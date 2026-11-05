with Ada.Text_IO; use Ada.Text_IO;
with Interfaces.C; use Interfaces.C;
with GCDLibRust;

procedure Main is
   Res : GCDLibRust.Diophantes_Result;
   A, B : unsigned := 48;
   B_Val : unsigned := 18;
begin
   Put_Line ("GCD(48, 18) =" & unsigned'Image (GCDLibRust.GCD (A, B_Val)));

   Put_Line ("Phi(10) =" & unsigned'Image (GCDLibRust.Euler_Totient (10)));

   Res := GCDLibRust.Diophantes (10, 6, 2);
   Put_Line ("Diophantes (10x - 6y = 2): x =" & 
             unsigned'Image (Res.X) & ", y =" & unsigned'Image (Res.Y));
end Main;
