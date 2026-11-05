with Interfaces.C; use Interfaces.C;

package GCDLibRust is

   type Diophantes_Result is record
      X : unsigned;
      Y : unsigned;
   end record
     with Convention => C;


   function GCD (A, B : unsigned) return unsigned
     with Import => True, 
          Convention => C, 
          External_Name => "gcd";

   function Smallest_Prime_Factor (N : unsigned) return unsigned
     with Import => True, 
          Convention => C, 
          External_Name => "smallest_prime_factor";

   function Euler_Totient (N : unsigned) return unsigned
     with Import => True, 
          Convention => C, 
          External_Name => "euler_totient";

   function Diophantes (A, B, C : unsigned) return Diophantes_Result
     with Import => True, 
          Convention => C, 
          External_Name => "diophantes";

end GCDLibRust;
