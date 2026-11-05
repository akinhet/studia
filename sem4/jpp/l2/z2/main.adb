with Ada.Text_IO; use Ada.Text_IO;
with Modular_Arithmetic;

procedure Main is
   package Ring7 is new Modular_Arithmetic(Modulo => 7);
   use Ring7;

   A : Ring := To_Ring(5);
   B : Ring := To_Ring(3);
   C : Ring;
begin
   C := A / B;
   Put_Line("Wynik 5 / 3 mod 7 = " & Long_Integer'Image(To_Long(C)));

   if A > B then
      Put_Line("5 jest wieksze niz 3 w pierscieniu");
   end if;
exception
   when No_Inverse_Error =>
      Put_Line("Błąd: Nie można wykonać dzielenia!");
end Main;
