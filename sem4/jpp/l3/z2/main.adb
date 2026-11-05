with Ada.Text_IO;
with Modular_Arithmetic;
with RSA;

procedure Main is

   package Field is
      new Modular_Arithmetic(10007 * 10009);

   package RSA_Pkg is
      new RSA
      (
         P => 10007,
         Q => 10009,
         Field => Field
      );

   use Ada.Text_IO;
   use Field;

   R : RSA_Pkg.RSA_Type;

   Msg       : Ring;
   Encrypted : Ring;
   Decrypted : Ring;

begin

   R := RSA_Pkg.Create_RSA;

   Put_Line
   (
      "Modulo n: " &
      Long_Integer'Image
      (
         RSA_Pkg.Get_Modulo(R)
      )
   );

   Put_Line
   (
      "Public key: " &
      Long_Integer'Image
      (
         RSA_Pkg.Get_Public_Key(R)
      )
   );

   Msg := To_Ring(123456);

   Encrypted :=
      RSA_Pkg.Encrypt(R, Msg);

   Decrypted :=
      RSA_Pkg.Decrypt(R, Encrypted);

   Put_Line
   (
      "Original : " &
      Long_Integer'Image
      (
         To_Long(Msg)
      )
   );

   Put_Line
   (
      "Encrypted: " &
      Long_Integer'Image
      (
         To_Long(Encrypted)
      )
   );

   Put_Line
   (
      "Decrypted: " &
      Long_Integer'Image
      (
         To_Long(Decrypted)
      )
   );

end Main;
