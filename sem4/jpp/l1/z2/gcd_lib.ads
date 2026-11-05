with Interfaces; use Interfaces;

package Gcd_Lib is
   pragma Preelaborate;

   type Diophantes_Result is record
      X : Unsigned_32;
      Y : Unsigned_32;
   end record;
   pragma Convention (C, Diophantes_Result);

   function Gcd (A, B : Unsigned_32) return Unsigned_32;
   pragma Export (C, Gcd, "gcd");

   function Smallest_Prime_Factor (N : Unsigned_32) return Unsigned_32;
   pragma Export (C, Smallest_Prime_Factor, "smallest_prime_factor");

   function Euler_Totient (N : Unsigned_32) return Unsigned_32;
   pragma Export (C, Euler_Totient, "euler_totient");

   function Diophantes (A, B, C : Unsigned_32) return Diophantes_Result;
   pragma Export (C, Diophantes, "diophantes");

end Gcd_Lib;
