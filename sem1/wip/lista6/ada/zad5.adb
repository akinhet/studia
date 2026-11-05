with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure zad5 is
   Max_N : constant Integer := 20;

   type Bool_Array is array (1 .. Max_N) of Boolean;
   type Int_Array is array (1 .. Max_N) of Integer;
   type Bool_Array_Large is array (1 .. 2 * Max_N) of Boolean;

   Position : Int_Array := (others => 0);
   Bije_Wiersz : Bool_Array := (others => False);
   Bije_Przek1 : Bool_Array_Large := (others => False);
   Bije_Przek2 : Bool_Array_Large := (others => False);

   procedure Drukuj_Rozwiazanie(N : Integer) is
   begin
      for I in 1 .. N loop
         Put(Position(I)'Img & " ");
      end loop;
      New_Line;
   end Drukuj_Rozwiazanie;

   procedure Ustaw(I, N : Integer) is
   begin
      for J in 1 .. N loop
         if not Bije_Wiersz(J) and then not Bije_Przek1(I + J) and then not Bije_Przek2(I - J + N) then
            Position(I) := J;
            Bije_Wiersz(J) := True;
            Bije_Przek1(I + J) := True;
            Bije_Przek2(I - J + N) := True;

            if I < N then
               Ustaw(I + 1, N);
            else
               Drukuj_Rozwiazanie(N);
            end if;

            Position(I) := 0;
            Bije_Wiersz(J) := False;
            Bije_Przek1(I + J) := False;
            Bije_Przek2(I - J + N) := False;
         end if;
      end loop;
   end Ustaw;

begin
   Put("Enter number of queens (1-20): ");
   declare
      N : Integer;
   begin
      Get(N);

      if N < 1 or else N > Max_N then
         Put_Line("ERROR: n must be an integer in the range 1-20.");
         return;
      end if;

      Position := (others => 0);
      Bije_Wiersz := (others => False);
      Bije_Przek1 := (others => False);
      Bije_Przek2 := (others => False);

      Ustaw(1, N);
   end;
end zad5;
