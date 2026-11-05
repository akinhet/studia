with Ada.Numerics.Discrete_Random;

package body Diffie_Hellman is

   Use Field;

   package Rand_Int is new Ada.Numerics.Discrete_Random(Long_Integer);

   Gen : Rand_Int.Generator;

   function Power(A : Ring; B : Long_Integer) return Ring is
      Result : Ring := Field.To_Ring(1);
      Base   : Ring := A;
      Exp    : Long_Integer := B;
   begin

      while Exp > 0 loop

         if (Exp mod 2) = 1 then
            Result := Result * Base;
         end if;

         Base := Base * Base;
         Exp := Exp / 2;

      end loop;

      return Result;
   end Power;

function Create_DH return DH_Setup is
   N   : constant Long_Integer := Field.Modulo;
   Phi : constant Long_Integer := N - 1;

   function Is_Generator (G : Ring) return Boolean is
      Temp_Phi : Long_Integer := Phi;
      D        : Long_Integer := 2;
   begin
      if To_Long(G) <= 1 then return False; end if;

      while D * D <= Temp_Phi loop
         if Temp_Phi mod D = 0 then
            if Power(G, Phi / D) = To_Ring(1) then
               return False;
            end if;
            while Temp_Phi mod D = 0 loop
               Temp_Phi := Temp_Phi / D;
            end loop;
         end if;
         D := D + 1;
      end loop;

      if Temp_Phi > 1 then
         if Power(G, Phi / Temp_Phi) = To_Ring(1) then
            return False;
         end if;
      end if;

      return True;
   end Is_Generator;

   Candidate_Val : Long_Integer;
   Candidate     : Ring;
begin
   loop
      Candidate_Val := (Rand_Int.Random(Gen) mod (N - 2)) + 2;
      Candidate     := To_Ring(Candidate_Val);

      exit when Is_Generator(Candidate);
   end loop;

   return (Generator => Candidate);
end Create_DH;

   function Get_Generator(DH : DH_Setup) return Ring is
   begin
      return DH.Generator;
   end Get_Generator;

   procedure Init(U : out User; DH : DH_Setup) is
   begin
      U.Setup := DH;
      U.Secret := Rand_Int.Random(Gen) mod 10000 + 2;
      U.Has_Key := False;
   end Init;

   function Get_Public_Key(U : User) return Ring is
   begin
      return Power(U.Setup.Generator, U.Secret);
   end Get_Public_Key;

   procedure Set_Key(U : in out User; A : Ring) is
   begin
      U.Key := Power(A, U.Secret);
      U.Has_Key := True;
   end Set_Key;

   function Encrypt(U : User; M : Ring) return Ring is
   begin

      if not U.Has_Key then
         raise Key_Not_Set;
      end if;

      return M * U.Key;
   end Encrypt;

   function Decrypt(U : User; C : Ring) return Ring is
   begin

      if not U.Has_Key then
         raise Key_Not_Set;
      end if;

      return C / U.Key;
   end Decrypt;

begin
   Rand_Int.Reset(Gen);
end Diffie_Hellman;
