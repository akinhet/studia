with Ada.Text_IO; use Ada.Text_IO;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;
with Ada.Numerics.Long_Elementary_Functions; use Ada.Numerics.Long_Elementary_Functions;


procedure zad4 is
   function FindZero (F : access function (X : Long_Float) return Long_Float;
                      A, B, Eps : Long_Float) return Long_Float is
      Start  : Long_Float := A;
      Finish : Long_Float := B;
      Mid    : Long_Float;
	  test   : Integer := 0;
   begin
      if A >= B or else F (A) * F (B) >= 0.0 then
         return A;
      end if;

      while (Finish - Start) > Eps loop
         Mid := Start / 2.0 + Finish / 2.0;
		 test := test + 1;

         if F (Mid) = 0.0 then
            return Mid;
         end if;

         if F (Start) * F (Mid) < 0.0 then
            Finish := Mid;
         else
            Start := Mid;
         end if;
      end loop;

      return Mid;
   end FindZero;

   function HalfCos (X : Long_Float) return Long_Float is
   begin
      return Cos (X / 2.0);
   end HalfCos;

   Eps : Long_Float := 1.0;

begin
   for I in 1 .. 8 loop
      Put (FindZero (HalfCos'Access, 2.0, 4.0, Eps));
      New_Line;
      Eps := Eps / 10.0;
   end loop;
end zad4;
