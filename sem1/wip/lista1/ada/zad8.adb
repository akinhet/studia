with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;


procedure zad8 is
	n, p, num, output: Integer;
begin
	Put("Podaj liczbę: ");
	Get(n);
	Put("Podaj podstawę: ");
	Get(p);

	num := n;
	output := 0;

	while num > 0 loop
		output := output * p;
		output := output + num mod p;
		num := num / p;
	end loop;

	if n = output then
		Put_Line("Liczba" & n'Image & " jest palindromem w podstawie" & p'Image);
	else
		Put_Line("Liczba" & n'Image & " nie jest palindromem w podstawie" & p'Image);
	end if;	
end zad8;
