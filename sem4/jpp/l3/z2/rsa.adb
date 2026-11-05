with Ada.Numerics.Discrete_Random;

package body RSA is

   use Field;

   Phi : constant Long_Integer := (P - 1) * (Q - 1);
   N   : constant Long_Integer := P * Q;

   package Rand_Int is
      new Ada.Numerics.Discrete_Random(Long_Integer);

   Gen : Rand_Int.Generator;

   function GCD(A, B : Long_Integer) return Long_Integer is
   begin
      if B = 0 then
         return abs(A);
      else
         return GCD(B, A mod B);
      end if;
   end GCD;

   function Inverse(A, M : Long_Integer)
      return Long_Integer
   is
      T     : Long_Integer := 0;
      NewT  : Long_Integer := 1;
      R     : Long_Integer := M;
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

      if T < 0 then
         T := T + M;
      end if;

      return T;
   end Inverse;

   function Power
   (
      A : Ring;
      B : Long_Integer
   ) return Ring
   is
      Result : Ring := To_Ring(1);
      Base   : Ring := A;
      Exp    : Long_Integer := B;
   begin

      while Exp > 0 loop

         if Exp mod 2 = 1 then
            Result := Result * Base;
         end if;

         Base := Base * Base;
         Exp := Exp / 2;

      end loop;

      return Result;
   end Power;

   function Generate_E return Long_Integer is
      E : Long_Integer;
   begin

      loop

         E := Rand_Int.Random(Gen)
            mod (Phi - 2) + 2;

         exit when GCD(E, Phi) = 1;

      end loop;

      return E;
   end Generate_E;

   function Create_RSA return RSA_Type is

      E : Long_Integer;
      D : Long_Integer;

   begin

      E := Generate_E;
      D := Inverse(E, Phi);

      return (
         Public_Key  => E,
         Private_Key => D
      );

   end Create_RSA;

   function Get_Modulo
   (
      R : RSA_Type
   ) return Long_Integer
   is
   begin
      return N;
   end Get_Modulo;

   function Get_Public_Key
   (
      R : RSA_Type
   ) return Long_Integer
   is
   begin
      return R.Public_Key;
   end Get_Public_Key;

   function Encrypt
   (
      R : RSA_Type;
      M : Ring
   ) return Ring
   is
   begin
      return Power(M, R.Public_Key);
   end Encrypt;

   function Decrypt
   (
      R : RSA_Type;
      S : Ring
   ) return Ring
   is
   begin
      return Power(S, R.Private_Key);
   end Decrypt;

begin
   Rand_Int.Reset(Gen);
end RSA;
