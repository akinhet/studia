generic
   Modulo : Long_Integer;
package Modular_Arithmetic is
   type Ring is private;

   No_Inverse_Error : exception;

   function "+" (L, R : Ring) return Ring;
   function "-" (L, R : Ring) return Ring;
   function "*" (L, R : Ring) return Ring;
   function "/" (L, R : Ring) return Ring;

   function "="  (L, R : Ring) return Boolean;
   function "<"  (L, R : Ring) return Boolean;
   function "<=" (L, R : Ring) return Boolean;
   function ">"  (L, R : Ring) return Boolean;
   function ">=" (L, R : Ring) return Boolean;

   function To_Ring (Val : Long_Integer) return Ring;
   function To_Long (R : Ring) return Long_Integer;

private
   type Ring is record
      Value : Long_Integer range 0 .. Modulo - 1;
   end record;
end Modular_Arithmetic;
