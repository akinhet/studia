with Modular_Arithmetic;

generic
   with package Field is new Modular_Arithmetic(<>);
package Diffie_Hellman is

   subtype Ring is Field.Ring;

   type DH_Setup is private;

   function Create_DH return DH_Setup;

   function Get_Generator(DH : DH_Setup) return Ring;
   function Power(A : Ring; B : Long_Integer) return Ring;

   type User is private;

   procedure Init(U : out User; DH : DH_Setup);

   function Get_Public_Key(U : User) return Ring;

   procedure Set_Key(U : in out User; A : Ring);

   function Encrypt(U : User; M : Ring) return Ring;
   function Decrypt(U : User; C : Ring) return Ring;

   Key_Not_Set : exception;

private

   type DH_Setup is record
      Generator : Ring;
   end record;

   type User is record
      Setup    : DH_Setup;
      Secret   : Long_Integer;
      Key      : Ring;
      Has_Key  : Boolean := False;
   end record;

end Diffie_Hellman;
