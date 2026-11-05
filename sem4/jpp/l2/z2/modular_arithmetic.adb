package body Modular_Arithmetic is

   function To_Ring (Val : Long_Integer) return Ring is
      Result : Long_Integer := Val mod Modulo;
   begin
      return (Value => Result);
   end To_Ring;

   function To_Long (R : Ring) return Long_Integer is
   begin
      return R.Value;
   end To_Long;

   function Modular_Inverse (A : Long_Integer) return Long_Integer is
      M0 : Long_Integer := Modulo;
      T, Q : Long_Integer;
      X0 : Long_Integer := 0;
      X1 : Long_Integer := 1;
      AA : Long_Integer := A;
   begin
      if Modulo = 1 then return 0; end if;

      while AA > 1 loop
         if M0 = 0 then exit; end if;
         Q := AA / M0;
         T := M0;
         M0 := AA mod M0;
         AA := T;
         T := X0;
         X0 := X1 - Q * X0;
         X1 := T;
      end loop;

      if AA /= 1 then
         raise No_Inverse_Error with "Brak odwrotnosci modularnej";
      end if;

      if X1 < 0 then X1 := X1 + Modulo; end if;
      return X1;
   end Modular_Inverse;

   function "+" (L, R : Ring) return Ring is
      begin return To_Ring(L.Value + R.Value); end "+";

   function "-" (L, R : Ring) return Ring is
      begin return To_Ring(L.Value - R.Value); end "-";

   function "*" (L, R : Ring) return Ring is
      begin return To_Ring(L.Value * R.Value); end "*";

   function "/" (L, R : Ring) return Ring is
      begin return To_Ring(L.Value * Modular_Inverse(R.Value)); end "/";

   function "=" (L, R : Ring) return Boolean is begin return L.Value = R.Value; end "=";
   function "<" (L, R : Ring) return Boolean is begin return L.Value < R.Value; end "<";
   function "<=" (L, R : Ring) return Boolean is begin return L.Value <= R.Value; end "<=";
   function ">"  (L, R : Ring) return Boolean is begin return L.Value > R.Value; end ">";
   function ">=" (L, R : Ring) return Boolean is begin return L.Value >= R.Value; end ">=";

end Modular_Arithmetic;
