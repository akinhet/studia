with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Main is

   NumClients : constant := 10;
   ToSend     : constant := 10;


   function Img (I : Integer) return String is
      S : constant String := Integer'Image (I);
   begin
      if S (S'First) = ' ' then
         return S (S'First + 1 .. S'Last);
      else
         return S;
      end if;
   end Img;


   subtype Receiver_Range is Integer range 0 .. NumClients - 1;
   package Random_Receiver is new Ada.Numerics.Discrete_Random (Receiver_Range);

   subtype Send_Delay_Range is Integer range 10 .. 20;
   package Random_Send_Delay is new Ada.Numerics.Discrete_Random (Send_Delay_Range);

   subtype Recv_Delay_Range is Integer range 50 .. 100;
   package Random_Recv_Delay is new Ada.Numerics.Discrete_Random (Recv_Delay_Range);


   protected Shared_State is
      procedure Increment_Senders;
      procedure Decrement_Senders;
      function Senders_Count return Integer;
      procedure Set_Closed;
      function Is_Closed return Boolean;
   private
      Active_Senders : Integer := 0;
      Closed         : Boolean := False;
   end Shared_State;

   protected body Shared_State is
      procedure Increment_Senders is
      begin
         Active_Senders := Active_Senders + 1;
      end Increment_Senders;

      procedure Decrement_Senders is
      begin
         Active_Senders := Active_Senders - 1;
      end Decrement_Senders;

      function Senders_Count return Integer is
      begin
         return Active_Senders;
      end Senders_Count;

      procedure Set_Closed is
      begin
         Closed := True;
      end Set_Closed;

      function Is_Closed return Boolean is
      begin
         return Closed;
      end Is_Closed;
   end Shared_State;


   protected type Client_Stat is
      procedure Inc_Failed;
      function Get_Failed return Integer;
   private
      Failed_Count : Integer := 0;
   end Client_Stat;

   protected body Client_Stat is
      procedure Inc_Failed is
      begin
         Failed_Count := Failed_Count + 1;
      end Inc_Failed;

      function Get_Failed return Integer is
      begin
         return Failed_Count;
      end Get_Failed;
   end Client_Stat;

   Stats : array (0 .. NumClients - 1) of Client_Stat;


   task type Client_Task (ID : Integer) is
      entry Start_Running;
      entry Receive_Message (Msg : Integer);
   end Client_Task;

   type Client_Access is access Client_Task;
   Clients : array (0 .. NumClients - 1) of Client_Access;


   task Server_Task is
      entry Route_Message (Receiver_ID : Integer);
      entry Start_Server;
   end Server_Task;


   task body Client_Task is
      Sent           : Integer := 0;
      Recv_ID        : Receiver_Range;
      Msg_Recv       : Integer;

      Gen_Recv       : Random_Receiver.Generator;
      Gen_Send       : Random_Send_Delay.Generator;
      Gen_Rcv_Delay  : Random_Recv_Delay.Generator;

      Send_Delay_Val : Send_Delay_Range;
      Recv_Delay_Val : Recv_Delay_Range;
   begin
      accept Start_Running;

      Random_Receiver.Reset (Gen_Recv);
      Random_Send_Delay.Reset (Gen_Send);
      Random_Recv_Delay.Reset (Gen_Rcv_Delay);

      while not Shared_State.Is_Closed loop
         if Sent < ToSend then
            Recv_ID := Random_Receiver.Random (Gen_Recv);
            Send_Delay_Val := Random_Send_Delay.Random (Gen_Send);


            select
               Server_Task.Route_Message (Recv_ID);
               Put_Line ("[" & Img (ID) & "]: sending message to " & Img (Recv_ID));
               Sent := Sent + 1;
               if Sent = ToSend then
                  Shared_State.Decrement_Senders;
               end if;
            or
               delay Duration (Float (Send_Delay_Val) / 1000.0);
               Stats (ID).Inc_Failed;
            end select;
         end if;


         Recv_Delay_Val := Random_Recv_Delay.Random (Gen_Rcv_Delay);
         select
            accept Receive_Message (Msg : Integer) do
               Msg_Recv := Msg;
            end Receive_Message;
            Put_Line ("[" & Img (ID) & "]: received message: " & Img (Msg_Recv));
         or
            delay Duration (Float (Recv_Delay_Val) / 1000.0);
         end select;
      end loop;
   end Client_Task;


   task body Server_Task is
      Target : Integer;
   begin
      accept Start_Server;

      loop
         select

            accept Route_Message (Receiver_ID : Integer) do
               Target := Receiver_ID;
            end Route_Message;


            if Target >= 0 and Target < NumClients then
               Clients (Target).Receive_Message (123);
            end if;
         else

            if Shared_State.Senders_Count = 0 then
               Shared_State.Set_Closed;
               exit;
            end if;
            delay 0.005;
         end select;
      end loop;
   end Server_Task;

begin

   for I in 0 .. NumClients - 1 loop
      if ToSend > 0 then
         Shared_State.Increment_Senders;
      end if;
      Clients (I) := new Client_Task (I);
   end loop;

   Server_Task.Start_Server;
   for I in 0 .. NumClients - 1 loop
      Clients (I).Start_Running;
   end loop;

   while not Server_Task'Terminated loop
      delay 0.01;
   end loop;

   Put_Line("");
   for I in 0 .. NumClients - 1 loop
      Put_Line ("[" & Img (I) & "] failed " & Img (Stats (I).Get_Failed) & " times");
   end loop;

end Main;
