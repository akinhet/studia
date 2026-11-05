with Ada.Text_IO;
with Modular_Arithmetic;
with Diffie_Hellman;

procedure Main is

   package Field is new Modular_Arithmetic(1234567891);
   package DH is new Diffie_Hellman(Field);

   use Ada.Text_IO;
   use Field;

   Setup : DH.DH_Setup;

   Alice : DH.User;
   Bob   : DH.User;

   Msg       : Field.Ring;
   Encrypted : Field.Ring;
   Decrypted : Field.Ring;

begin

   Setup := DH.Create_DH;

   DH.Init(Alice, Setup);
   DH.Init(Bob, Setup);

   DH.Set_Key(Alice, DH.Get_Public_Key(Bob));
   DH.Set_Key(Bob, DH.Get_Public_Key(Alice));

   Msg := To_Ring(123456);

   Encrypted := DH.Encrypt(Alice, Msg);

   Decrypted := DH.Decrypt(Bob, Encrypted);

   Put_Line("Original : " & Long_Integer'Image(To_Long(Msg)));
   Put_Line("Encrypted: " & Long_Integer'Image(To_Long(Encrypted)));
   Put_Line("Decrypted: " & Long_Integer'Image(To_Long(Decrypted)));

end Main;
