#set document(title: "Sprawozdanie nr. 3")
#set page(paper: "a4", margin: 2.5cm)
#set text(font: "New Computer Modern", lang: "pl", size: 11pt)
#set heading(numbering: "1.1.")
#set par(justify: true)
#show raw.where(block:true): block.with(fill: luma(240), inset: 1em, radius: 0.5em, width: 100%)
#show table: set align(center)

#align(center)[
  #text(size: 18pt, weight: "bold")[Sprawozdanie nr. 3]
  #v(1em)
  #text(size: 14pt)[Autor: Piotr Zieniewicz 283961]
  #v(2em)
]

= Zadanie 6.

== Podpunkt a) Struktura obsługująca wielomiany wielu zmiennych

Do reprezentacji wielomianów wielu zmiennych w języku Python zastosowano klasę `Polynomial`, której fundamentem jest wbudowana struktura słownika (`dict`). 

- *Klucze słownika* to krotki liczb całkowitych, które jednoznacznie reprezentują wykładniki potęg przy poszczególnych zmiennych. Na przykład dla pierścienia wielomianów trzech zmiennych $R[x, y, z]$, jednomian $x^2 y z^3$ przyjmuje postać krotki `(2, 1, 3)`.
- *Wartości słownika* to liczby zmiennoprzecinkowe odpowiadające współczynnikom przy danych jednomianach.

Taka struktura (tzw. reprezentacja rzadka) jest wysoce optymalna, ponieważ w pamięci przechowywane są wyłącznie te jednomiany, których współczynnik jest różny od zera. Klasa została wyposażona w przeciążone operatory arytmetyczne (`__add__`, `__sub__`, `__mul__`), co pozwala na naturalne i intuicyjne operowanie na wielomianach w kodzie.

== Podpunkt b) Implementacja algorytmów

W poniższych pseudokodach używam następujących oznaczeń:
 - $"LT"(p)$ - wyraz wiodący wielomianu $p$
 - $"LC"(p)$ - współczynnik wiodący wielomianu $p$
 - $"LM"(p)$ - jednomian wiodący wielomianu $p$

```
Funkcja PolynomialReduce(f, G)
    Wejście: Wielomian f, lista wielomianów G = [g_1, g_2, ..., g_k]
    Wyjście: Lista ilorazów [q_1, ..., q_k] oraz reszta r

    Inicjalizacja:
    dla każdego i od 1 do k:
        q_i := 0
    r := 0
    p := f  // p to wielomian, który aktualnie redukujemy

    Dopóki p != 0 Wykonuj:
        zredukowano := Fałsz
        i := 1
        
        // Szukamy pierwszego wielomianu g_i, który dzieli wiodący wyraz p
        Dopóki i <= k oraz zredukowano == Fałsz Wykonuj:
            Jeśli LM(g_i) dzieli LM(p) To:
                // Obliczamy wyraz ilorazu
                wspolczynnik := LC(p) / LC(g_i)
                jednomian := LM(p) / LM(g_i)
                wyraz := wspolczynnik * jednomian
                
                // Aktualizujemy iloraz i wielomian p
                q_i := q_i + wyraz
                p := p - wyraz * g_i
                zredukowano := Prawda
            W przeciwnym wypadku:
                i := i + 1
        
        // Jeśli żaden g_i nie dzieli LT(p), przesuwamy LT(p) do reszty
        Jeśli zredukowano == Fałsz To:
            r := r + LT(p)
            p := p - LT(p)

    Zwróć ([q_1, q_2, ..., q_k], r)
```

```
Funkcja Syzygium(f, g)
    Wejście: Wielomian f, Wielomian g
    Wyjście: Wielomian S(f, g)

    // Jeśli któryś z wielomianów jest zerowy, S-wielomian wynosi 0
    Jeśli f == 0 lub g == 0 To:
        Zwróć 0

    // Wyznaczamy Najmniejszą Wspólną Wielokrotność (NWW) wiodących jednomianów
    L := NWW(LM(f), LM(g))

    // Obliczamy składniki S-wielomianu
    skladnik_f := (L / LT(f)) * f
    skladnik_g := (L / LT(g)) * g

    Zwróć (skladnik_f - skladnik_g)
```
```
Funkcja BuchbergerAlgorithm(G_pocz)
    Wejście: Lista wielomianów generujących ideał G_pocz = [g_1, ..., g_k]
    Wyjście: Baza Groebnera G dla tego ideału

    G := Kopia(G_pocz)
    Pary := { {g_i, g_j} : g_i, g_j należą do G oraz g_i != g_j }

    Dopóki Pary nie jest puste Wykonuj:
        Wybierz i usuń parę {f, g} z Pary
        
        // 1. Oblicz S-wielomian dla wybranej pary
        S := Syzygium(f, g)
        
        // 2. Zredukuj S-wielomian względem aktualnej bazy G
        // Interesuje nas tylko reszta (drugi element zwracanej pary)
        (_, r) := PolynomialReduce(S, G)
        
        // 3. Jeśli reszta nie jest zerem, rozszerzamy bazę
        Jeśli r != 0 To:
            // Dodajemy nowe pary ze świeżo znalezionym wielomianem r
            Dla każdego h należącego do G Wykonuj:
                Pary := Pary U { {h, r} }
            
            // Dodajemy r do naszej bazy
            G := G U {r}

    Zwróć G
```

== Podpunkt c) Bazy Gröbnera na stożku

Ponieważ równanie $x^2 + y^2 = z^2$ opisuje dwa złączone ze sobą końcówkami stożki, to równania otrzymane z obliczenia poniższych Baz Gröbnera i wyeliminowaniu zmiennej $z$ przedstawiają przecięcia owych stożków pewną płaszczyzną.

#table(
  align: horizon,
  columns: 4,
  inset: 1em,
  [], [Równanie], [Baza Gröbnera], [$I_f$], 
  [1], [$4z = 0$], [$x^2+y^2, z$], [$x^2+y^2$],
  [2], [$z + 10 = 0$], [$x^2+y^2 - 100, z + 10$], [$x^2+y^2-100$],
  [3], [$x + z - 7 = 0$], [$14x - y^2 - 49, x + z - 7$], [$14x - y^2 - 49$],
  [4], [$x + y + z + 2 = 0$], [$x y + 2x + 2y + 2, x + y + z + 2$], [$x y + 2x + 2y + 2$],
  [5], [$y/2 + z + 1 = 0$], [$4x^2 + 3y^2 - 4y - 4, y + 2z + 2$], [$4x^2 + 3y^2 - 4y - 4$],
)

#figure(
  image("fig1.png", width: 80%),
  caption: [Wykresy rozmaitości $V(I_f)$]
)


== Podpunkt d) Eliminacja i analiza geometryczna

Załóżmy, że parametr $a = 2$. Rozważamy układ równań wielomianowych:
$ cases(
  (x^2 + y^2 - 2x)^2 = z^2(x^2 + y^2),
  x + 2y + 3z = 0
) $

=== Wyznaczenie bazy Gröbnera i eliminacja zmiennej $x$

Do wyeliminowania zmiennej $x$ wykorzystano porządek leksykograficzny (*lex*) ze strukturą zmiennych $x > y > z$. Algorytm bazy Gröbnera dla tak zdefiniowanego ideału generuje bazę składającą się z dwóch wielomianów $G = {g_1 (y, z), g_2 (x, y, z)}$, gdzie:

$ g_1 (y, z) = 25 y^4 + 120 y^3 z + 40 y^3 + 229 y^2 z^2 + 156 y^2 z + 16 y^2 + 204 y z^3 + 216 y z^2 + 48 y z + 72 z^4 + 108 z^3 + 36 z^2 $
$ g_2 (x, y, z) = x + 2y + 3z $

Wielomian $g_1 (y, z)$ reprezentuje tzw. *ideał eliminacji* ($I / K[y, z]$). Ponieważ nie występuje w nim zmienna $x$, opisuje on bezpośrednio rzut (cień) krzywej przecięcia obu obiektów trójwymiarowych na płaszczyznę współrzędnych $Y Z$. 

#figure(
  image("fig2.png", width: 80%),
  caption: [Wykres $g_1 (y, z) = 0$]
)

=== Analiza pierwszego równania wyjściowego dla $z = a$

Ostatnia część zadania wymaga zbadania zachowania wyłącznie pierwszego równania wyjściowego układu, czyli powierzchni algebraicznej czwartego stopnia danej wzorem:
$ (x^2 + y^2 - a x)^2 = z^2 (x^2 + y^2) $

Podstawiając do powyższego równania wartość wysokości $z = a$ (dla naszych danych $a = 2$), otrzymujemy równanie krzywej dwuwymiarowej na płaszczyźnie $X Y$:
$ (x^2 + y^2 - 2x)^2 = 4(x^2 + y^2) $

Krzywa ta w jawnej postaci geometrycznej nosi nazwę kardioidy (będącej szczególnym przypadkiem ślimaka Pascala). W tym konkretnym przypadku, ze względu na idealną równość parametru przesunięcia oraz czynnika skalującego ($z = a$), krzywa posiada charakterystyczne ostrze zwrotne w początku układu współrzędnych $(0,0)$ i nie tworzy pętli wewnętrznej.

== Podpunkt e) Analiza trysektrysy Maclaurina

Trysektrysa jest krzywą płaską w przestrzeni $RR^2$. Dla przyjętej wartości parametru $b = 8$, jej równanie w układzie biegunowym przyjmuje postać:
$ r = 8 (4 cos(theta) + 1 / cos(theta)) $

=== Wyznaczenie wzoru kartezjańskiego za pomocą bazy Gröbnera

W celu przekształcenia równania biegunowego na współrzędne kartezjańskie $(x, y)$, wprowadzono standardowe związki transformacyjne oraz zmienne pomocnicze $c = cos(theta)$ i $s = sin(theta)$:
1. $x = r c$
2. $y = r s$
3. $c^2 + s^2 = 1$ (jedynka trygonometryczna)

Mnożąc wyjściowe równanie krzywej przez $cos(theta)$ w celu eliminacji ułamka, otrzymujemy układ czterech równań wielomianowych, tworzących ideał $I$:
$ cases(
  r c - 8(4c^2 + 1) = 0,
  x - r c = 0,
  y - r s = 0,
  c^2 + s^2 - 1 = 0
) $

Aby wyznaczyć czyste równanie we współrzędnych $x$ i $y$, należy wyeliminować zmienne pomocnicze $r, s, c$. Zastosowano porządek leksykograficzny (*lex*) o hierarchii zmiennych:
$ {r, s, c} > {x, y} $

Własna implementacja algorytmu bazy Gröbnera dla tak zdefiniowanego układu wygenerowała wielomian eliminacji najniższego stopnia, stanowiący szukany wzór kartezjański trysektrysy dla $b=8$:
$ x^3 + x y^2 - 40x^2 - 8y^2 = 0 $

Krzywa ta po uporządkowaniu może być również przedstawiona w jawnej postaci uwikłanej jako:
$ x(x^2 + y^2) = 8(5x^2 + y^2) $

jest to krzywa algebraiczna trzeciego stopnia.

#figure(
  image("fig3.png", width: 80%),
  caption: [Wykres $x^3 + x y^2 - 40x^2 - 8y^2 = 0$]
)

=== Zastosowanie geometryczne trysektrysy

Trysektrysa (w tej konkretnej postaci znana w historii matematyki jako _Trysektrysa Maclaurina_) jest krzywą konstruowalną, która służy do **trysekcji kąta** -- czyli podziału dowolnego kąta na trzy równe części. Jak udowodnił Pierre Wantzel w 1837 roku, operacja ta jest niewykonalna za pomocą wyłącznie klasycznego cyrkla i linijki (dla ogólnego przypadku).

Wykorzystanie trysektrysy Maclaurina pozwala jednak obejść to ograniczenie. Konstrukcja polega na umieszczeniu wierzchołka dzielonego kąta w charakterystycznym punkcie węzłowym pętli krzywej (tzw. ognisku). Linia prosta poprowadzona pod zadanym kątem wyjściowym przecina pętlę trysektrysy w punkcie, który w połączeniu z anatomią tej krzywej automatycznie wyznacza promień lub prostą nachyloną pod kątem dokładnie $alpha / 3$. Dodatkowo, krzywa ta znajduje zastosowanie w kinematyce do projektowania specjalnych mechanizmów dźwigniowych i krzywkowych realizujących niestandardowe przełożenia obrotowe.
