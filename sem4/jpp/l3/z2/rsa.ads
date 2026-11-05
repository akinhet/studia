with Modular_Arithmetic;

generic
   P, Q : Long_Integer;
   with package Field is new Modular_Arithmetic(<>);

package RSA is

   subtype Ring is Field.Ring;

   type RSA_Type is private;

   function Create_RSA return RSA_Type;

   function Get_Modulo(R : RSA_Type) return Long_Integer;

   function Get_Public_Key(R : RSA_Type) return Long_Integer;

   function Encrypt
   (
      R : RSA_Type;
      M : Ring
   ) return Ring;

   function Decrypt
   (
      R : RSA_Type;
      S : Ring
   ) return Ring;

private

   type RSA_Type is record
      Public_Key  : Long_Integer;
      Private_Key : Long_Integer;
   end record;

end RSA;
