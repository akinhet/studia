with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure main is

   Num_Philosophers : constant Positive := 5;
   Target_Eaten : constant Positive := 10;

   protected type Fork(ID : Positive) is
      entry Pickup;
      procedure Putdown;
   private
      Available : Boolean := True;
   end Fork;

   protected body Fork is
      entry Pickup when Available is
      begin
         Available := False;
      end Pickup;

      procedure Putdown is
      begin
         Available := True;
      end Putdown;
   end Fork;

   type Fork_Access is access Fork;
   type Fork_Array is array (Positive range <>) of Fork_Access;

   Forks : Fork_Array(1 .. Num_Philosophers);

   subtype Time_Thinking is Integer range 50 .. 200;
   package Random_Thinking is new Ada.Numerics.Discrete_Random(Time_Thinking);

   subtype Time_Eating is Integer range 10 .. 40;
   package Random_Eating is new Ada.Numerics.Discrete_Random(Time_Eating);

   task type Philosopher_Type(ID : Positive; Left, Right : Fork_Access) is
      entry Download_Statistics(failures : out Natural);
   end Philosopher_Type;

   task body Philosopher_Type is
      Eaten : Natural := 0;
      Failed  : Natural := 0;
      Gen_C            : Random_Thinking.Generator;
      Gen_O            : Random_Eating.Generator;
      Success   : Boolean;
   begin
      Random_Thinking.Reset(Gen_C, ID);
      Random_Eating.Reset(Gen_O, ID);

      while Eaten < Target_Eaten loop
         Put_Line("[Filozof" & Positive'Image(ID) & "] Myśli...");
         delay Duration(Float(Random_Thinking.Random(Gen_C)) / 1000.0);

         Put_Line("[Filozof" & Positive'Image(ID) & "] Chce zjeść posiłek nr" & Natural'Image(Eaten + 1));

         Left.Pickup;

         Success := False;
         select
            Right.Pickup;
            Success := True;
         else
            null;
         end select;

         if Success then
            Put_Line("--> [Filozof" & Positive'Image(ID) & "] JEST! Używa widelców" & Positive'Image(Left.ID) & " i" & Positive'Image(Right.ID));

            delay Duration(Float(Random_Thinking.Random(Gen_C)) / 1000.0);
            Eaten := Eaten + 1;

            Right.Putdown;
            Left.Putdown;
         else
            Left.Putdown;
            Failed := Failed + 1;
            Put_Line("X [Filozof" & Positive'Image(ID) & "] Nie udało się (widelec" & Positive'Image(Right.ID) & " zajęty). Rezygnuje.");

            delay Duration(Float(Random_Eating.Random(Gen_O)) / 1000.0);
         end if;
      end loop;

      Put_Line("[Filozof" & Positive'Image(ID) & "] Sfinalizował ucztę! Zjadł" & Natural'Image(Eaten) & " posiłków.");

      accept Download_Statistics(Failures : out Natural) do
         Failures := Failed;
      end Download_Statistics;
   end Philosopher_Type;

   type Filozof_Access is access Philosopher_Type;
   type Philosopher_Array is array (Positive range <>) of Filozof_Access;

   Philosophers : Philosopher_Array(1 .. Num_Philosophers);
   Result_Failed : Natural;

begin
   Put_Line("=== URUCHAMIANIE UCZTY W JĘZYKU ADA ===");

   for I in 1 .. Num_Philosophers loop
      Forks(I) := new Fork(ID => I);
   end loop;

   for I in 1 .. Num_Philosophers loop
      declare
         Right_Index : constant Positive := (I mod Num_Philosophers) + 1;
       Keynes : constant Positive := I;
      begin
         Philosophers(I) := new Philosopher_Type(ID => I, Left => Forks(I), Right => Forks(Right_Index));
      end;
   end loop;

   Put_Line("");
   Put_Line("=== KONIEC UCZTY - STATYSTYKI PORAŻEK ===");
   for I in 1 .. Num_Philosophers loop
      Philosophers(I).Download_Statistics(Result_Failed);
      Put_Line("Filozof" & Positive'Image(I) & ":" & Natural'Image(Result_Failed) & " nieudanych prób zjedzenia obiadu.");
   end loop;

end main;
