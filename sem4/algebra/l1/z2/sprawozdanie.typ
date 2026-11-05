= Sprawozdanie 1
==== Piotr Zieniewicz 283961

== Lab 1: Pierścień liczb Gaussa $ZZ[i]$

=== 1. Reprezentacja liczb Gaussa
Liczby Gaussa zostały zaimplementowane jako struktura `Gauss` składająca się z dwóch pól typu całkowitego (`int`): "a" (część rzeczywista) oraz "b" (część urojona). 

*Uzasadnienie:*
Taka reprezentacja pozwala na zachowanie pełnej precyzji operacji arytmetycznych wewnątrz pierścienia $ZZ[i]$. Wykorzystanie liczb całkowitych zamiast zmiennoprzecinkowych eliminuje błędy zaokrągleń przy dodawaniu, odejmowaniu i mnożeniu.

=== 2. Zaimplementowane algorytmy
- *Norma:* Zdefiniowana jako kwadrat modułu liczby zespolonej: $N(a + b i) = a^2 + b^2$. Jest to norma euklidesowa, która przypisuje każdej liczbie Gaussa nieujemną liczbę całkowitą.
- *Dzielenie z resztą:* Algorytm wyznacza iloraz $q$ jako najbliższy punkt kratowy wyniku dzielenia w dziedzinie zespolonej. Ponieważ punkt może leżeć w równej odległości od kilku punktów kratowych, zaimplementowano funkcję zwracającą wszystkie poprawne pary $(q, r)$ spełniające warunek $N(r) < N(y)$.
- *NWD i NWW:* Wykorzystano algorytm Euklidesa oparty na resztach z dzielenia. W $ZZ[i]$ NWD jest wyznaczone z dokładnością do jedności pierścienia (${1, -1, i, -i}$).
- *Obsługa list:* Implementacja NWD dla list wykorzystuje własność łączności operacji: $"NWD"(a_1, a_2, dots, a_n) = "NWD"(a_1, "NWD"(a_2, dots))$.

=== 3. Podpunkt a) - Fragmenty kodu
Najistotniejszym elementem jest wyznaczanie wszystkich najbliższych punktów kratowych dla ilorazu, co pozwala na znalezienie wszystkich poprawnych reszt (fragment logiki Nim):

#block(fill: luma(240), inset: 10pt, radius: 4pt, width: 100%)[
```
proc getNearestGaussians(real, img: float): seq[Gauss] =
  let
    rLow = floor(real).int
    rHigh = ceil(real).int
    iLow = floor(img).int
    iHigh = ceil(img).int

  var candidates: seq[Gauss] = @[]
  for r in [rLow, rHigh]:
    for i in [iLow, iHigh]:
      let g = Gauss(a: r, b: i)
      if g notin candidates: candidates.add(g)

  let minDist = candidates.mapIt((real - it.a.float)^2 + (img - it.b.float)^2).min()
  result = candidates.filterIt((real - it.a.float)^2 + (img - it.b.float)^2 <= minDist + 0.0001)

proc getAssociates(x: Gauss): seq[Gauss] =
  @[x, Gauss(a: -x.b, b: x.a), Gauss(a: -x.a, b: -x.b), Gauss(a: x.b, b: -x.a)]

proc divRem*(x, y: Gauss): seq[(Gauss, Gauss)] =
  let
    denom = norm(y).float
    a = x
    b = toGauss(y.a, -y.b)
    c = a * b
    real = c.a.float / denom
    img = c.b.float / denom

  let quotients = getNearestGaussians(real, img)
  for q in quotients:
    let r = x - (y * q)
    result.add((q, r))

proc gcd(x, y: Gauss): seq[Gauss] =
  if x.norm == 0: return getAssociates(y)
  if y.norm == 0: return getAssociates(x)

  var a = x
  var b = y
  while b.norm != 0:
    let r = a % b
    a = b
    b = r
  return getAssociates(a)

proc gcd*(arr: openArray[Gauss]): seq[Gauss] =
  if arr.len == 0: return @[Gauss(a: 0, b: 0)]
  if arr.len == 1: return getAssociates(arr[0])

  var currentGcds = gcd(arr[0], arr[1])
  for i in 2 ..< arr.len:
    currentGcds = gcd(currentGcds[0], arr[i])
  return currentGcds
```
]

=== 4. Podpunkt b) - Analiza dzielenia
Dla parametrów $a=2, b=8, c=3, d=9, e=6, f=1$:
- Wywołanie normy $N(2 + 8i) = 68$.
- Dzielenie $(5+17i)$ przez $(6+1i)$.

*Wyniki dzielenia:*
Program wyznacza pary $(q, r)$ takie, że $x = q dot y + r$. Otrzymane wyniki:
- Iloraz: $(1 + 3i)$, Reszta: $(-4 - 2i)$
- Iloraz: $(2 + 3i)$, Reszta: $(2 - 3i)$

*Uzasadnienie liczby wyników:*
W pierścieniu $ZZ[i]$ dla danych $x, y$ może istnieć od 1 do 4 poprawnych ilorazów. Wynika to z faktu, że wynik dzielenia w $CC$ wpada do kwadratu jednostkowego, którego wierzchołkami są liczby całkowite Gaussa. Maksymalna odległość od wierzchołka to $1/ (sqrt(2))$, co daje normę reszty $1/2 dot N(y)$. Nie ma możliwości uzyskania więcej niż 4 wyników, gdyż obszar ten ograniczają dokładnie 4 wierzchołki.

=== 5. Podpunkt c) - NWD i NWW dla wielu liczb
Wywołanie dla trójki: $(2+8i)$, $(3+9i)$, $(6+9i)$.

*Wyniki:*
- *NWD:* Program zwraca zbiór ${3, -3, 3i, -3i}$. Wszystkie wyniki są poprawne (różnią się o jedność).
- *Lista pusta:* $"NWD"([]) = 0$.
- *Lista 1-elementowa:* $"NWD"([2+8i])$ zwraca liczbę oraz jej trzy skojarzenia: ${2+8i, -2-8i, -8+2i, 8-2i}$.

== Lab 2: Pierścień wielomianów

=== 1. Reprezentacja wielomianów
Wielomiany zostały zaimplementowane przy użyciu struktury generycznej `Poly[T]`. Współczynniki przechowywane są w dynamicznej tablicy (`seq[T]`), gdzie indeks elementu odpowiada potędze zmiennej $x$ (tj. indeks 0 to wyraz wolny, indeks 1 to współczynnik przy $x^1$ itd.). Ostatni element tablicy jest zawsze niezerowy (brak wiodących zer).

*Dlaczego taka reprezentacja?*
Dzięki wykorzystaniu typów generycznych w języku Nim (`[T]`), pierścień jednej zmiennej $RR[x]$ (gdzie `T` to np. `float`) można trywialnie i rekurencyjnie rozszerzyć do pierścienia wielu zmiennych $kappa[x_1, dots, x_n]$. Aby uzyskać wielomian dwóch zmiennych, wystarczy zadeklarować typ `Poly[Poly[float]]`. Traktujemy wtedy $K[x, y]$ jako $(K[x])[y]$.

=== 2. Zaimplementowane algorytmy
- *Norma:* W dziedzinie euklidesowej wielomianów normą jest stopień wielomianu. Zaimplementowano go jako długość tablicy współczynników pomniejszoną o 1.
- *Dzielenie z resztą:* Klasyczny algorytm pisemnego dzielenia. W każdej iteracji odejmujemy od dzielnej odpowiednio przeskalowany dzielnik, aż stopień reszty będzie ostro mniejszy niż stopień dzielnika.
- *NWD:* Zaimplementowany za pomocą klasycznego algorytmu Euklidesa (iteracyjne dzielenie z resztą aż do uzyskania reszty zerowej). Wynik jest na końcu normowany (dzielony przez współczynnik wiodący).
- *Rozszerzony NWD:* Śledzi liniową kombinację za pomocą zmiennych pomocniczych $s$ i $t$. Zwraca krotkę $(g, s, t)$, gdzie $g = "NWD"(a, b)$, oraz zachodzi tożsamość $a dot s + b dot t = g$.
- *NWW:* Wykorzystuje tożsamość dziedzin euklidesowych: $"NWW"(a, b) = (a dot b) / "NWD"(a, b)$.

=== 3. Podpunkt a) - Norma i dzielenie
Konstruujemy wielomian postaci $c x^a + b$:
$ P(x) = 3x^2 + 8 $

*Norma wielomianu:* $"deg"(P) = 2$

*Dzielenie przez wielomian $D(x) = x + 1$:*
Po wykonaniu dzielenia z resztą program wylicza następujące wartości:
- *Iloraz:* $3x - 3$
- *Reszta:* $11$

Sprawdzenie: $(x + 1)(3x - 3) + 11 = 3x^2 - 3x + 3x - 3 + 11 = 3x^2 + 8$.

=== 4. Podpunkt b) - Rozszerzony NWD i wyznaczanie stałej $g$
Na podstawie cyfr zdefiniowano wielomiany:
$ v(x) = a x^3 + b x^2 + c x + d = 2x^3 + 8x^2 + 3x + 9 $
$ w(x) = d x^3 + e x^2 + f x = 9x^3 + 6x^2 + x $

*Cel:* Znaleźć taką stałą $g$, aby $1 in.not "NWD"(v(x), w(x) + g)$.
Aby spełnić ten warunek, wielomiany te muszą posiadać przynajmniej jeden wspólny pierwiastek rzeczywisty $r$. 
1. Używając metody bisekcji dla $v(x)$, odnaleziono pierwiastek w przedziale $[-4, -3]$. Wyniósł on $r approx -3.910679$.
2. Ponieważ $r$ ma być także pierwiastkiem $w(x) + g$, musi zachodzić $w(r) + g = 0$, co po przekształceniu daje $g = -w(r)$.
3. Program wyliczył wartość wielomianu $w(x)$ w punkcie $r$ jako $w(-3.910679) approx -450.42$.
4. Zatem analitycznie wyznaczona stała to $g approx -450.42$.

Dla tak dobranego $g$, wywołanie rozszerzonego algorytmu Euklidesa zwraca:
- *NWD(v(x), w(x) + g):* $x - r = x + 3.816694$ (wspólny czynnik liniowy stopnia 1, co jednoznacznie dowodzi, że wartość $1 in.not "NWD"$).
- Odpowiednie wartości współczynników $s$ i $t$ (wielomianów) takie, by zachodziło $v(x)s(x) + (w(x)+g)t(x) = "NWD"$.
- *NWW(v(x), w(x) + g):* Wielomian 5 stopnia (będący iloczynem podzielonym przez wyliczone NWD).

== Lab 3: Porządki produktowe i elementy minimalne

=== 1. Implementacja porządku produktowego
Zgodnie z definicją matematyczną, porządek produktowy na zbiorze $NN^n$ polega na porównywaniu elementów "po współrzędnych". 
Dla dwóch wektorów $x = (x_1, dots, x_n)$ oraz $y = (y_1, dots, y_n)$ zachodzi:
- $x <= y <==> forall_i x_i <= y_i$
- $x < y <==> x <= y "oraz" x != y$

W języku Nim zaimplementowano to poprzez przeciążenie operatorów `<=` oraz `<` dla typu `seq[int]`. Algorytm iteruje po wszystkich wymiarach (indeksach) i jeśli na którejkolwiek współrzędnej $x_i > y_i$, zwraca fałsz.

=== 2. Algorytm wyznaczania elementów minimalnych
W przeciwieństwie do naiwnej metody porównywania "każdy z każdym" ($O(N^2)$), zaimplementowany algorytm zoptymalizowany przetwarza zbiór wejściowy $A$ sekwencyjnie, budując na bieżąco zbiór kandydatów na elementy minimalne $M$. Pozwala to na drastyczne ograniczenie liczby porównań.

*Kroki algorytmu dla każdego punktu $P$ ze zbioru $X$:*

1. #strong[Faza filtracji (Dominacja z dołu):]
   Sprawdzamy, czy punkt $P$ jest zdominowany przez jakikolwiek element znajdujący się już w zbiorze $M$. 
   - Iterujemy przez wszystkie $m in M$. Jeśli dla dowolnego $m$ zachodzi $m <= P$, oznacza to, że punkt $P$ nie jest minimalny. W takim przypadku algorytm natychmiast przerywa sprawdzanie $P$ i przechodzi do następnego punktu ze zbioru $X$.

2. #strong[Faza aktualizacji (Dominacja z góry):]
   Jeśli punkt $P$ nie został zdominowany przez żadne $m$, może on sam eliminować elementy, które do tej pory znajdowały się w $M$.
   - Przeszukujemy zbiór $M$ w poszukiwaniu elementów $m$, dla których zachodzi $P <= m$.
   - Wszystkie takie elementy $m$ są usuwane z $M$, ponieważ przestały być minimalne w obecności punktu $P$.

3. #strong[Faza insercji:]
   Po usunięciu zdominowanych elementów, punkt $P$ zostaje dodany do zbioru $M$.

Dla zbiorów nieograniczonych (jak zbiór $B$), większość punktów jest odrzucana w fazie 1 przez kilka punktów brzegowych znalezionych na początku, co czyni algorytm niezwykle wydajnym.

=== 3. Porównywanie krotek (podpunkty a i b)
*a) Pary z $NN^2$:* $p_1=(2,8), p_2=(3,9), p_3=(6,1)$
- $p_1 <= p_2$ jest *Prawdą*, ponieważ $2 <= 3$ oraz $8 <= 9$.
- $p_1$ oraz $p_3$ są *nieporównywalne* ($p_1 <= p_3$ to Fałsz, bo $8 > 1$; $p_3 <= p_1$ to Fałsz, bo $6 > 2$).
- $p_2$ oraz $p_3$ również są *nieporównywalne*.

*b) Trójki z $NN^3$:* $t_1=(2,3,6), t_2=(8,9,1)$
- Trójki są *nieporównywalne*. Element $t_1$ dominuje na pierwszych dwóch współrzędnych ($2<=8, 3<=9$), ale przegrywa na trzeciej ($6 > 1$).

=== 4. Wyznaczanie elementów minimalnych (Zbiory A i B)

*Zbiór A:*
$ A = { (x, y) in NN^2 : (x - 2)^2 + (y - 8)^2 < 5 } $
Zbiór ten to punkty kratowe we wnętrzu koła o środku w $(2,8)$ i promieniu $ sqrt(5)$. 
Generując punkty z tego obszaru i przepuszczając je przez algorytm minimalizujący, program znajduje tzw. "dolną powłokę" tego zbioru:
- Znalezione elementy minimalne: $(0, 8), (1, 7), (2, 6)$.
Wszystkie pozostałe punkty wewnątrz koła posiadają na obu współrzędnych wartości większe lub równe którymś z powyższych punktów.

*Zbiór B:*
$ B = { (x_1,x_2,x_3,x_4) in NN^4 : (x_1 - 3)^2 + (x_2 - 9)^2 + (x_3 - 6)^2 + (x_4 - 1)^2 > 224 } $
Zbiór ten to dopełnienie 4-wymiarowej kuli (hiperkuli), zawiera punkty leżące na zewnątrz niej. 
Ponieważ poszukujemy elementów $<=$-minimalnych w dziedzinie liczb naturalnych $NN^4$, wystarczy przeszukać przestrzeń dookoła wyznaczonego promienia. Wynikiem działania algorytmu jest zbiór brzegowych wektorów 4-wymiarowych o najmniejszych możliwych sumarycznie współrzędnych, które jeszcze "wystają" poza zadaną hiperkulę i nie dominują się nawzajem.
