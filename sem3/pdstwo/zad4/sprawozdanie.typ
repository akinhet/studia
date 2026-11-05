#show figure.caption: strong
#set text(lang: "pl")
#show heading.where(level: 1): set align(center)

= Zadanie 1

== Wstęp

W tym zadaniu należało sprawdzić skuteczność nierówności Markowa i Czebyszewa, porównując wyniki z nich uzyskane do faktycznych wartości szacowanych prawdopodobieństw. Należało w tym celu zbadać nierówności ogonowe rozkładu $"Bin"(n,1/2)$ dla wartości $n in {100,1000,10000}$.

== Metodologia

Operujemy na rozkładzie $X ~ "Bin"(n,1/2)$. Wartość oczekiwana i wariancja tego rozkładu są dobrze znane i dla $p = 1/2$ wynoszą $bold(E)(X) = n/2$ i $bold("var")(X) = n/4$.

W podpunkcie a) mamy dane zdarzenie
$
P(X >= 1 1/5 bold(E)(X))
$

Oszacowanie go za pomocą nierówności Markowa jest trywialne, nie musimy stosować żadnych przekształceń
$
P(X >= 1 1/5 bold(E)(X)) <= (bold(E)(X)) /(6/5 bold(E)(X)) = 5/6
$

Dla nierówności Czebyszewa musimy nieco przekształcić zdarzenie, korzystając z faktu, że rozkład dwumianowy jest symetryczny względem $bold(E)(X)$
$
P(X >= 1 1/5 bold(E)(X)) = P(X - bold(E)(X) >= 1/5 bold(E)(X)) = 1/2 P(|X - bold(E)(X)| >= 1/5 bold(E)(X)) <= 1/2 (bold("var")(X))/(1/5 bold(E)(X))^2 = 1/2 (n/4)/(1/25 n^2/4) = 25/(2n)
$

W podpunkcie b) mamy dane zdarzenie
$
P(|X - bold(E)(X)| >= 1/10 bold(E)(X))
$

Tutaj z kolei lepiej dopasowana do wzoru jest nierówność Czebyszewa
$
P(|X - bold(E)(X)| >= 1/10 bold(E)(X)) <= (bold("var")(X))/(1/10 bold(E)(X))^2 = (n/4)/(1/100 n^2/4) = 100/n
$

Dla nierówności Markowa w tym przykładzie ponownie skorzystamy z symetryczności rozkładu dwumianowego
$
P(|X - bold(E)(X)| >= 1/10 bold(E)(X)) = 2P(X - bold(E)(X) >= 1/10 bold(E)(X)) = 2P(X >= 11/10 bold(E)(X)) <= 2 (bold(E)(X))/(11/10 bold(E)(X)) = 20/11
$

Do obliczenia faktycznej wartości tych prawdopodobieństw użyłem biblioteki `scipy` w Pythonie. Użyłem metody `sf`, czyli survival function, definiowanej jako $1 - P(X <= k)$, w klasie `binom` odpowiadającej rozkładowi dwumianowemu.

#pagebreak()
== Wyniki

Na podstawie poprzednich obliczeń możemy skonstruować następującą tabelę:

#set table(
  fill: (x, y) =>
    if x == 0 or y == 0 {
      gray.lighten(40%)
    },
  align: right,
)

#align(center)[
  #table(
    columns: 5,
    align: center + horizon,
    inset: 8pt,
    table.header(
      table.cell(colspan:2)[], [100], [1000], [10000]
    ),
    table.cell(rowspan: 3)[a\)],
    [Markow], [$5/6$], [$5/6$], [$5/6$],
    [Czebyszew], [$1/8$], [$1/80$], [$1/800$],
    [faktyczna], [0,0284], [1,364e-10], [8,702e-90],
    table.cell(rowspan: 3)[b\)],
    [Markow], [$20/11$], [$20/11$], [$20/11$],
    [Czebyszew], [$1$], [$1/10$], [$1/100$],
    [faktyczna], [0,368], [1,731e-3], [1,551e-23],
  )
]

Z powyższej tabeli widać, że nierówność Markowa produkuje ograniczenia niezależne od wartości $n$, dlatego wraz ze zwiększaniem $n$ staje się ona coraz bardziej oddalona od faktycznej wartości, chociaż już w pierwszym przypadku różnica ta jest ogromna.

== Wnioski
Po wynikach widać, że mimo iż nierówności Markowa i Czebyszewa mogą być przydatnymi narzędzami, to są one w pewnych przypadkach ekstremalnie nieprecyzyjne. Widać tutaj również supermacje nierówności Czebyszewa, która przynajmniej zmienia się w tym samym kierunku co faktyczna wartość, nawet jeżeli różnica rzędów wielkości wynosi nawet do kilkudziesięciu razy. Stoi to w przeciwieństwie do nierówności Markowa, która jest stała, bez względu na $N$, a w przypadku punktu b) poddaje się kompletnie i zwraca wartość większą niż 1, co z perspektywy badania ogonów rozkładu jest kompletnie bezużytecznym wynikiem. Widać więc, że nierówność Czebyszewa jest znacznie lepsza niż nierówność Markowa, jednak nawet i ona ma swoje znaczące ograniczenia.

= Zadanie 2

== Wstęp
W tym zadaniu należało wyznaczyć numerycznie dystrybuanty zmiennych losowych $S_N$ dla $N in {5, 10, 15, 20, 25, 30}$ reprezentujących błądzenie losowe na liczbach całkowitych, a następnie przyrównać je do dystrybuant rozkładu normalnego aproksymujących rozkład $S_N$.

== Metodologia
Zauważmy, że $bold(E)(S_N) = sum bold(E)(X_N) = 0$ oraz $sigma(S_N) = sqrt(bold("var")(S_N)) = sqrt(N)$.

Korzystając z biblioteki `numpy` dla każdego $N$ wygenerowałem 10000 losowań rozkładu dwumianowego, a następnie korzystając z funkcji `ecdf` z biblioteki `scipy` obliczyłem empiryczną dystrybuantę $S_N$. Następnie wygenerowałem dystrybuantę rozkładu normalnego $N(0, N)$, która zgodnie z CLT powinna być zbliżona do dystrybuanty obliczonej dla $S_N$.

== Wyniki
#align(center)[
  #figure(
    image("zad2/Figure_1.png"),
    caption: [Wyniki dla $N in {5, 10, 15, 20, 25, 30}$]
  )
  #figure(
    image("zad2/Figure_2.png"),
    caption: [Wyniki dla $N = 100$]
  )
]

Jak widać na powyższych wykresach dystrybuanta $S_N$ dosyć dokładnie śledzi dystrybuantę rozkładu $N(0, N)$, co zgadza się z przewidywaniami wynikającym z centralnego twierdzenia granicznego. Zgodnie z oczekiwaniami im wyższy paramter $N$ tym ściślej nakładają się na siebie oba wykresy, a przy $N = 100$ jest to już bardzo ścisłe przyleganie.

== Wnioski
Na podstawie powyższego zadania widać, że centralne twierdzenie graniczne działa i zachowuje się zgodnie z oczekiwaniami. Wyraźnie widać, że w razie potrzeby można w ten sposób łatwo aproksymować rozkład normalny od obliczeń inżynierskich.

= Zadanie 3

== Wstęp
W tym zadaniu należało przy pomocy mechanizmów z poprzedniego zadania wyznaczyć rozkład czasu spędzonego po jednej stronie osi OX w trakcie błądzenie losowego po liczbach całkowitych.

== Metodologia
Badanie frakcji czasu spędzonego nad osią OX w prostym błądzeniu losowym przeprowadziłem przy użyciu symulacji Monte Carlo dla trzech wariantów długości procesu $N in {100,1000,10000}$. Dla każdej wartości $N$ wygenerowałem $k=5000$ niezależnych prób, startujących z punktu $S_0=0$. Wyznaczyłem wskaźnik $D_n$, który zgodnie z definicją przyjmował wartość 1, jeżeli proces znajdował się nad osią lub właśnie do niej powrócił z góry, co technicznie zrealizowałem poprzez alternatywę warunków $(S_n > 0 or S_(n−1) > 0)$. Frakcję czasu $P_N$ obliczyłem jako stosunek sumy wskaźników $D_n$ do całkowitej liczby kroków $N$. Uzyskane dane przedstawiłem na wykresach znormalizowanych do gęstości prawdopodobieństwa z podziałem na 20 równych przedziałów.

== Wyniki

#align(center)[
  #figure(
    image("zad3/Figure_1.png"),
    caption: [Wyniki dla $N in {100, 1000, 10000}$]
  )
]

Jak widać na powyższym rysunku najbardziej prawdopodobne są przypadki gdzie cały czas spędzamy nad bądź pod osią OX, a najmniej prawdopodobny jest przypadek, gdzie czas ten jest w miarę równy, co daje charakterystyczny kształt U wykresów. Widać również, że słupki w wykresie są bardzo zbliżone do dystrybuanty arcusa sinusa.

== Wnioski
Wbrew intuicyjnym oczekiwaniom, proces błądzenia losowego ma bardzo małe prawodpodobieństwo utrzymywania się wokół osi OX. Ostatecznie eksperyment wykazał, że proces błądzenia losowego dąży do wartości ekstremalnych, a wartości średnie są statystycznie najrzadsze.
