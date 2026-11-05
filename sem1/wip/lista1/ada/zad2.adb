with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;


procedure zad2 is
	a, b, temp: Integer;
begin
	Put("Podaj pierwszą liczbę: ");
	Get(a);
	Put("Podaj drugą liczbę: ");
	Get(b);

	while b > 0 loop
		temp := a;
		a := b;
		b := temp rem b;
	end loop;

	Put_Line("Wynik to" & a'Image);
end zad2;
