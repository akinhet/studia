with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;	use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;


procedure zad5 is
	a, b, c : Float;
	dlt, first_part, second_part, x1, x2: Float;
begin
	Put("Podaj pierwszą liczbę: ");
	Get(a);
	Put("Podaj drugą liczbę: ");
	Get(b);
	Put("Podaj trzecią liczbę: ");
	Get(c);

	dlt := (b*b) - (4.0 * a * c);

	if dlt < 0.0 then
		Put_Line("Równanie nie ma pierwiastków rzeczywistych.");
	elsif dlt = 0.0 then
		first_part := -b / (2.0*a);
		Put_Line("Pierwiastkiem równania jest" & first_part'Image);
	else
		first_part := -b / (2.0*a);
		second_part := Sqrt(dlt) / (2.0*a);
		x1 := first_part + second_part;
		x2 := first_part - second_part;
		Put_Line("Pierwiastkami równania są " & x1'Image & " oraz" & x2'Image);
	end if;
	
end zad5;
