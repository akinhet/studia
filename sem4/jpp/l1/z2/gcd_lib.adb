package body Gcd_Lib is

   type Egcd_Result is record
      X : Integer_64;
      Y : Integer_64;
      C : Integer_64;
   end record;

   function Egcd (A, B : Integer_64) return Egcd_Result is
      Prev_X : Integer_64 := 1;
      Prev_Y : Integer_64 := 0;
      X      : Integer_64 := 0;
      Y      : Integer_64 := 1;
      A1     : Integer_64 := A;
      B1     : Integer_64 := B;
      Q, Tmp : Integer_64;
   begin
      while B1 > 0 loop
         Q := A1 / B1;

         Tmp := X;
         X := Prev_X - Q * X;
         Prev_X := Tmp;

         Tmp := Y;
         Y := Prev_Y - Q * Y;
         Prev_Y := Tmp;

         Tmp := B1;
         B1 := A1 rem B1;
         A1 := Tmp;
      end loop;

      return (X => Prev_X, Y => Prev_Y, C => A1);
   end Egcd;


   function Gcd (A, B : Unsigned_32) return Unsigned_32 is
      Res : constant Egcd_Result := Egcd (Integer_64 (A), Integer_64 (B));
   begin
      return Unsigned_32 (Res.C);
   end Gcd;


   function Smallest_Prime_Factor (N : Unsigned_32) return Unsigned_32 is
      I    : Integer_64 := 3;
      N_64 : constant Integer_64 := Integer_64 (N);
   begin
      if N rem 2 = 0 then
         return 2;
      end if;

      while I * I <= N_64 loop
         if N_64 rem I = 0 then
            return Unsigned_32 (I);
         end if;
         I := I + 2;
      end loop;

      return N;
   end Smallest_Prime_Factor;


   function Euler_Totient (N : Unsigned_32) return Unsigned_32 is
      Res   : Unsigned_32 := N;
      I     : Integer_64 := 2;
      Mut_N : Unsigned_32 := N;
   begin
      while I * I <= Integer_64 (Mut_N) loop
         if Mut_N rem Unsigned_32 (I) = 0 then
            while Mut_N rem Unsigned_32 (I) = 0 loop
               Mut_N := Mut_N / Unsigned_32 (I);
            end loop;
            Res := Res - (Res / Unsigned_32 (I));
         end if;
         I := I + 1;
      end loop;

      if Mut_N > 1 then
         Res := Res - (Res / Mut_N);
      end if;
      return Res;
   end Euler_Totient;


   function Diophantes (A, B, C : Unsigned_32) return Diophantes_Result is
      Gcd_Res : constant Egcd_Result := Egcd (Integer_64 (A), Integer_64 (B));
      C_64    : constant Integer_64  := Integer_64 (C);
      A_64    : constant Integer_64  := Integer_64 (A);
      B_64    : constant Integer_64  := Integer_64 (B);

      Mul, X, Step_X, Step_Y, Y : Integer_64;
   begin
      if C_64 rem Gcd_Res.C /= 0 then
         return (0, 0);
      end if;

      Mul := C_64 / Gcd_Res.C;
      X   := Gcd_Res.X * Mul;

      Step_X := B_64 / Gcd_Res.C;
      Step_Y := A_64 / Gcd_Res.C;

      X := X rem Step_X;

      Y := (A_64 * X - C_64) / B_64;

      if Y < 0 then
         Y := Y + Step_Y;
         X := (B_64 * Y + C_64) / A_64;
      end if;

      return (Unsigned_32 (X), Unsigned_32 (Y));
   end Diophantes;

end Gcd_Lib;
