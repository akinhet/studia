package body Modular_Arithmetic is

   function Normalize (V : Long_Integer) return Long_Integer is
   begin
      return ((V mod Modulo) + Modulo) mod Modulo;
   end Normalize;

   function To_Ring (Val : Long_Integer) return Ring is
   begin
      return (Value => Normalize(Val));
   end To_Ring;

   function To_Long (R : Ring) return Long_Integer is
   begin
      return R.Value;
   end To_Long;

   function GCD (A, B : Long_Integer) return Long_Integer is
   begin
      if B = 0 then
         return abs(A);
      else
         return GCD(B, A mod B);
      end if;
   end GCD;

   function Inverse (A : Long_Integer) return Long_Integer is
      T     : Long_Integer := 0;
      NewT  : Long_Integer := 1;
      R     : Long_Integer := Modulo;
      NewR  : Long_Integer := A;
      Q     : Long_Integer;
      Temp  : Long_Integer;
   begin

      while NewR /= 0 loop
         Q := R / NewR;

         Temp := T;
         T := NewT;
         NewT := Temp - Q * NewT;

         Temp := R;
         R := NewR;
         NewR := Temp - Q * NewR;
      end loop;

      if R > 1 then
         raise No_Inverse_Error;
      end if;

      if T < 0 then
         T := T + Modulo;
      end if;

      return T;
   end Inverse;

   function "+" (L, R : Ring) return Ring is
   begin
      return To_Ring(L.Value + R.Value);
   end "+";

   function "-" (L, R : Ring) return Ring is
   begin
      return To_Ring(L.Value - R.Value);
   end "-";

   function "*" (L, R : Ring) return Ring is
   begin
      return To_Ring(L.Value * R.Value);
   end "*";

   function "/" (L, R : Ring) return Ring is
   begin
      return To_Ring(L.Value * Inverse(R.Value));
   end "/";

   function "=" (L, R : Ring) return Boolean is
   begin
      return L.Value = R.Value;
   end "=";

   function "<" (L, R : Ring) return Boolean is
   begin
      return L.Value < R.Value;
   end "<";

   function "<=" (L, R : Ring) return Boolean is
   begin
      return L.Value <= R.Value;
   end "<=";

   function ">" (L, R : Ring) return Boolean is
   begin
      return L.Value > R.Value;
   end ">";

   function ">=" (L, R : Ring) return Boolean is
   begin
      return L.Value >= R.Value;
   end ">=";

end Modular_Arithmetic;
