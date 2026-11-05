with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure zad2 is
   type Int_Array is array (Positive range <>) of Integer;
   Num_Good_Boards : Integer := 0;

   procedure Eval_Board(A : in Int_Array; N : Integer) is
   begin
      for I in 1 .. N - 1 loop
         for J in I + 1 .. N loop
            if A(J) = A(I) + (J - I) or else A(J) = A(I) - (J - I) then
               return;
            end if;
         end loop;
      end loop;

      for I in 1 .. N loop
         Put(A(I)'Img & " ");
      end loop;
      New_Line;
      Num_Good_Boards := Num_Good_Boards + 1;
   end Eval_Board;

   procedure Gen_Permutations(A : in out Int_Array; Size, N : Integer) is
   begin
      if Size = 1 then
         Eval_Board(A, N);
         return;
      end if;

      for I in 1 .. Size loop
         Gen_Permutations(A, Size - 1, N);

         if Size mod 2 = 1 then
            -- Swap A(1) and A(Size)
            declare
               Temp : Integer := A(1);
            begin
               A(1) := A(Size);
               A(Size) := Temp;
            end;
         else
            -- Swap A(I) and A(Size)
            declare
               Temp : Integer := A(I);
            begin
               A(I) := A(Size);
               A(Size) := Temp;
            end;
         end if;
      end loop;
   end Gen_Permutations;

begin
   Put("Enter number of queens: ");
   declare
      N : Integer;
   begin
      Get(N);
      if N <= 0 then
         Put_Line("ERROR: Number of queens must be positive!");
         return;
      end if;

      declare
         A : Int_Array(1 .. N);
      begin
         for I in 1 .. N loop
            A(I) := I;
         end loop;

         Gen_Permutations(A, N, N);

         Put_Line("Number of solutions: " & Num_Good_Boards'Img);
      end;
   end;
end zad2;
