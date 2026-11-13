#show figure.caption: strong
#set text(lang: "pl", size: 11pt)
#set page(numbering: "1")
#show heading.where(level: 2): set align(center)
#show heading.where(level: 2): it => block(
  above: 1.5em,
  below: 0.8em,
  it
)

#align(center)[
  = Sprawozdanie do listy nr. 2 z kursu Obliczenia Naukowe
  ==== Piotr Zieniewicz 283961
]

= Zadanie 1.

== Wyniki

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: 10pt,
    table.header(
      [], table.cell(colspan: 2, [*Lista 1*]), table.cell(colspan: 2, [*Lista 2*])
    ),
    [], [*Float32*], [*Float64*], [*Float32*], [*Float64*],
    [a], $-0.4999443$, $1.0251881368296672*10^(-10)$, $-0.4999443$, $-0.004296342739891585$,
    [b], $-0.4543457$, $-1.5643308870494366*10^(-10)$, $-0.4543457$, $-0.004296342998713953$,
    [c], $-0.5$, $0.0$, $-0.5$, $-0.004296342842280865$,
    [d], $-0.5$, $0.0$, $-0.5$, $-0.004296342842280865$,
    // [builtin], $-0.34720382$, $1.0251881368296672*10^(-10)$,
    [real], table.cell(colspan: 2, $-1.00657107000000 dot 10^(-11)$), table.cell(colspan: 2, $−4.29634273989 dot 10^(−3)$)
  ),
  caption: [Wyniki zadania 1.]
) <zad1>

== Wnioski

1. Zadanie jest bardzo źle uwarunkowane i nawet zmiana rzędu $10^(-9)$ jest wystarczająca, aby znacząco poprawić wyniki nawet w przypadku funkcji, które wcześnie bardzo słabo radziły sobie z zadaniem.
2. Wskaźnik uwarunkowania zadania zmienił się z $approx 5.5 dot 10^17$ do $approx 1.3 dot 10^3$. Taka zmiana sprawiła, że wyniki dla nowych danych są znacznie dokłądniejsze.

= Zadanie 2.

== Wyniki

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    stroke: 0.4pt,
    inset: 5pt,

    table.header(
      [$n$], [cond$(A)$], [rank$(A)$], [Gauss], [inv$(A)$],
    ),

    [2],  [$1.9281 dot 10^(+01)$], [2],  [$5.6610 dot 10^(-16)$], [$1.4043 dot 10^(-15)$],
    [3],  [$5.2406 dot 10^(+02)$], [3],  [$8.0226 dot 10^(-15)$], [$0.0000 dot 10^(+00)$],
    [4],  [$1.5514 dot 10^(+04)$], [4],  [$4.1374 dot 10^(-14)$], [$0.0000 dot 10^(+00)$],
    [5],  [$4.7661 dot 10^(+05)$], [5],  [$1.6828 dot 10^(-12)$], [$3.3544 dot 10^(-12)$],
    [6],  [$1.4951 dot 10^(+07)$], [6],  [$2.6189 dot 10^(-10)$], [$2.0164 dot 10^(-10)$],
    [7],  [$4.7537 dot 10^(+08)$], [7],  [$1.2607 dot 10^(-08)$], [$4.7133 dot 10^(-09)$],
    [8],  [$1.5258 dot 10^(+10)$], [8],  [$6.1241 dot 10^(-08)$], [$3.0775 dot 10^(-07)$],
    [9],  [$4.9315 dot 10^(+11)$], [9],  [$3.8752 dot 10^(-06)$], [$4.5413 dot 10^(-06)$],
    [10], [$1.6025 dot 10^(+13)$], [10], [$8.6704 dot 10^(-05)$], [$2.5015 dot 10^(-04)$],
    [11], [$5.2269 dot 10^(+14)$], [10], [$1.5828 dot 10^(-04)$], [$7.6183 dot 10^(-03)$],
    [12], [$1.8087 dot 10^(+16)$], [11], [$1.3396 dot 10^(-01)$], [$2.5899 dot 10^(-01)$],
    [13], [$2.3382 dot 10^(+18)$], [11], [$1.1040 dot 10^(-01)$], [$5.3313 dot 10^(+00)$],
    [14], [$5.8703 dot 10^(+17)$], [11], [$1.4554 dot 10^(+00)$], [$8.7150 dot 10^(+00)$],
    [15], [$8.7184 dot 10^(+17)$], [12], [$4.6967 dot 10^(+00)$], [$7.3446 dot 10^(+00)$],
    [16], [$3.0204 dot 10^(+17)$], [12], [$5.4155 dot 10^(+01)$], [$2.9849 dot 10^(+01)$],
    [17], [$1.6733 dot 10^(+18)$], [12], [$1.3707 dot 10^(+01)$], [$1.0517 dot 10^(+01)$],
    [18], [$2.1250 dot 10^(+18)$], [12], [$1.0258 dot 10^(+01)$], [$2.4762 dot 10^(+01)$],
    [19], [$2.9976 dot 10^(+18)$], [13], [$1.0216 dot 10^(+02)$], [$1.0995 dot 10^(+02)$],
    [20], [$9.9546 dot 10^(+18)$], [13], [$1.0832 dot 10^(+02)$], [$1.1434 dot 10^(+02)$],
  ),
  caption: [Wyniki dla macierzy Hilberta],
)

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    stroke: 0.4pt,
    inset: 5pt,

    table.header(
      [$n$], [cond$(A)$], [rank$(A)$], [Gauss], [inv$(A)$],
    ),

    [5],  [$1.0000 dot 10^(+00)$], [5],  [$2.8522 dot 10^(-16)$], [$1.4895 dot 10^(-16)$],
    [5],  [$1.0000 dot 10^(+01)$], [5],  [$1.8578 dot 10^(-16)$], [$1.7902 dot 10^(-16)$],
    [5],  [$1.0000 dot 10^(+03)$], [5],  [$4.3128 dot 10^(-14)$], [$4.4210 dot 10^(-14)$],
    [5],  [$1.0000 dot 10^(+07)$], [5],  [$5.3095 dot 10^(-11)$], [$9.4755 dot 10^(-11)$],
    [5],  [$9.9999 dot 10^(+11)$], [5],  [$4.8379 dot 10^(-05)$], [$4.4748 dot 10^(-05)$],
    [5],  [$1.0169 dot 10^(+16)$], [4],  [$2.6251 dot 10^(-01)$], [$1.3184 dot 10^(-01)$],

    [10], [$1.0000 dot 10^(+00)$], [10], [$2.0472 dot 10^(-16)$], [$1.9860 dot 10^(-16)$],
    [10], [$1.0000 dot 10^(+01)$], [10], [$3.1792 dot 10^(-16)$], [$2.8522 dot 10^(-16)$],
    [10], [$1.0000 dot 10^(+03)$], [10], [$3.3945 dot 10^(-15)$], [$4.0895 dot 10^(-15)$],
    [10], [$1.0000 dot 10^(+07)$], [10], [$3.4263 dot 10^(-10)$], [$3.3540 dot 10^(-10)$],
    [10], [$1.0000 dot 10^(+12)$], [10], [$7.0608 dot 10^(-06)$], [$7.9161 dot 10^(-06)$],
    [10], [$4.4642 dot 10^(+15)$], [9],  [$2.3208 dot 10^(-01)$], [$2.4443 dot 10^(-01)$],

    [20], [$1.0000 dot 10^(+00)$], [20], [$6.7028 dot 10^(-16)$], [$4.3850 dot 10^(-16)$],
    [20], [$1.0000 dot 10^(+01)$], [20], [$5.0573 dot 10^(-16)$], [$3.1007 dot 10^(-16)$],
    [20], [$1.0000 dot 10^(+03)$], [20], [$1.2603 dot 10^(-14)$], [$1.5888 dot 10^(-14)$],
    [20], [$1.0000 dot 10^(+07)$], [20], [$3.3579 dot 10^(-11)$], [$2.9678 dot 10^(-11)$],
    [20], [$9.9991 dot 10^(+11)$], [20], [$1.3569 dot 10^(-05)$], [$1.3407 dot 10^(-05)$],
    [20], [$7.4783 dot 10^(+15)$], [19], [$3.1433 dot 10^(-02)$], [$3.1517 dot 10^(-02)$],
  ),
  caption: [Wyniki dla macierzy losowych],
)

== Wnioski

1. Dla macierzy Hilberta wskaźnik uwarunkowania bardzo szybko rośnie wraz z rozmiarem macierzy, co prowadzi do znacznej utraty dokładności obliczeń.

2. Dla macierzy losowych zaobserwowano wzrost błędów względnych wraz ze wzrostem zadanego wskaźnika uwarunkowania. W przypadku wartości rzędu $10^16$ otrzymane rozwiązania są obarczone dużymi błędami, ponieważ uwarunkowanie jest porównywalne z odwrotnością precyzji maszynowej `Float64`.

3. Algorytm eliminacji Gaussa $(A \\ b)$ na ogół zapewnia dokładniejsze wyniki niż metoda wykorzystująca jawną macierz odwrotną ($"inv"(A) * b$). Wynika to z faktu, że eliminacja Gaussa rozwiązuje układ bezpośrednio, natomiast druga metoda wymaga obliczenia przybliżonej macierzy odwrotnej i dodatkowego mnożenia przez wektor \(b\), co wprowadza kolejne błędy zaokrągleń. Różnica jest szczególnie widoczna dla źle uwarunkowanych macierzy.

4. Dla bardzo źle uwarunkowanych macierzy funkcja `rank(A)` może zwracać rząd mniejszy od rzeczywistego ze względu na ograniczoną precyzję arytmetyki zmiennoprzecinkowej. Dzieje się tak, ponieważ najmniejsze wartości osobliwe macierzy spadają poniżej przyjętej tolerancji numerycznej i są traktowane jako zero, mimo że matematycznie macierz pozostaje odwracalna.

5. Wskaźnik uwarunkowania nie określa dokładnej wartości błędu rozwiązania, lecz jego wrażliwość na zaburzenia danych. Dlatego błędy numeryczne nie muszą rosnąć monotonicznie wraz ze wskaźnikiem uwarunkowania, ponieważ ich rzeczywista wielkość zależy także od charakteru i kierunku zaburzeń oraz błędów zaokrągleń powstających podczas obliczeń.

= Zadanie 3.

== Wyniki

#figure(
  image("z3-desmos-a.png", width: 60%),
  caption: [desmos.org]
) <rys_zad5>
#figure(
  image("z3-desmos-b.png", width: 60%),
  caption: [desmos.org]
) <rys_zad5>
#figure(
  image("z3-python-a.png", width: 60%),
  caption: [matplotlib]
) <rys_zad5>
#figure(
  image("z3-python-b.png", width: 60%),
  caption: [matplotlib]
) <rys_zad5>



== Wnioski

1. Od $x approx 30$ wyraźnie widoczna jest nieciągłość wykresu i oscylacje, wynikające z zaokrąglania $1 + e^(-x)$ do kroku $2^(-52)$, którego błąd jest dodatkowo wzmacniany przez mnożenie przez $e^x$, które w tym zakresie osiąga wartości rzędu $10^10 ~ 10^16$.

2. Powyżej $x approx 710$ wykres się urywa. Wynika to z faktu, że we `Float64` $e^710 = "Inf"$, a ponieważ $"Inf" dot 0 = "NaN"$ to program przestaje rysować cokolwiek.

= Zadanie 4.

== Wyniki

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    stroke: 0.4pt,
    inset: 4pt,

    table.header(
      [$k$], [$z_k$], [$abs(P(z_k))$], [$abs(p(z_k))$], [$abs(z_k-k)$],
    ),

    [1],  [$1.000000 +0.000000i$], [$3.569651 dot 10^(+04)$], [$3.662643 dot 10^(+04)$], [$3.010925 dot 10^(-13)$],
    [2],  [$2.000000 +0.000000i$], [$1.762526 dot 10^(+05)$], [$1.813039 dot 10^(+05)$], [$2.831824 dot 10^(-11)$],
    [3],  [$3.000000 +0.000000i$], [$2.791577 dot 10^(+05)$], [$2.901723 dot 10^(+05)$], [$4.079035 dot 10^(-10)$],
    [4],  [$4.000000 +0.000000i$], [$3.027109 dot 10^(+06)$], [$2.041537 dot 10^(+06)$], [$1.626247 dot 10^(-08)$],
    [5],  [$5.000001 +0.000000i$], [$2.291747 dot 10^(+07)$], [$2.089463 dot 10^(+07)$], [$6.657698 dot 10^(-07)$],
    [6],  [$5.999989 +0.000000i$], [$1.290242 dot 10^(+08)$], [$1.125048 dot 10^(+08)$], [$1.075418 dot 10^(-05)$],
    [7],  [$7.000102 +0.000000i$], [$4.805113 dot 10^(+08)$], [$4.572909 dot 10^(+08)$], [$1.020028 dot 10^(-04)$],
    [8],  [$7.999356 +0.000000i$], [$1.637952 dot 10^(+09)$], [$1.555646 dot 10^(+09)$], [$6.441704 dot 10^(-04)$],
    [9],  [$9.002915 +0.000000i$], [$4.877071 dot 10^(+09)$], [$4.687816 dot 10^(+09)$], [$2.915294 dot 10^(-03)$],
    [10], [$9.990413 +0.000000i$], [$1.363864 dot 10^(+10)$], [$1.263460 dot 10^(+10)$], [$9.586958 dot 10^(-03)$],
    [11], [$11.025023 +0.000000i$], [$3.585631 dot 10^(+10)$], [$3.300128 dot 10^(+10)$], [$2.502293 dot 10^(-02)$],
    [12], [$11.953283 +0.000000i$], [$7.533332 dot 10^(+10)$], [$7.388526 dot 10^(+10)$], [$4.671675 dot 10^(-02)$],
    [13], [$13.074314 +0.000000i$], [$1.960599 dot 10^(+11)$], [$1.847622 dot 10^(+11)$], [$7.431403 dot 10^(-02)$],
    [14], [$13.914756 +0.000000i$], [$3.575135 dot 10^(+11)$], [$3.551428 dot 10^(+11)$], [$8.524441 dot 10^(-02)$],
    [15], [$15.075494 +0.000000i$], [$8.216271 dot 10^(+11)$], [$8.423202 dot 10^(+11)$], [$7.549380 dot 10^(-02)$],
    [16], [$15.946287 +0.000000i$], [$1.551498 dot 10^(+12)$], [$1.570729 dot 10^(+12)$], [$5.371328 dot 10^(-02)$],
    [17], [$17.025427 +0.000000i$], [$3.694736 dot 10^(+12)$], [$3.316978 dot 10^(+12)$], [$2.542715 dot 10^(-02)$],
    [18], [$17.990921 +0.000000i$], [$7.650109 dot 10^(+12)$], [$6.344853 dot 10^(+12)$], [$9.078647 dot 10^(-03)$],
    [19], [$19.001910 +0.000000i$], [$1.143527 dot 10^(+13)$], [$1.228572 dot 10^(+13)$], [$1.909818 dot 10^(-03)$],
    [20], [$19.999809 +0.000000i$], [$2.792411 dot 10^(+13)$], [$2.318310 dot 10^(+13)$], [$1.907088 dot 10^(-04)$],
  ),
  caption: [Wielomian Wilkinsona — wyniki dla pierwotnych współczynników],
)

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    stroke: 0.4pt,
    inset: 4pt,

    table.header(
      [$k$], [$z_k$], [$abs(P(z_k))$], [$abs(p(z_k))$], [$abs(z_k-k)$],
    ),

    [1],  [$1.000000 +0.000000i$], [$2.025987 dot 10^(+04)$], [$1.998787 dot 10^(+04)$], [$1.643130 dot 10^(-13)$],
    [2],  [$2.000000 +0.000000i$], [$3.465414 dot 10^(+05)$], [$3.523694 dot 10^(+05)$], [$5.503731 dot 10^(-11)$],
    [3],  [$3.000000 +0.000000i$], [$2.258060 dot 10^(+06)$], [$2.416242 dot 10^(+06)$], [$3.396580 dot 10^(-09)$],
    [4],  [$4.000000 +0.000000i$], [$1.054263 dot 10^(+07)$], [$1.126370 dot 10^(+07)$], [$8.972436 dot 10^(-08)$],
    [5],  [$4.999999 +0.000000i$], [$3.757831 dot 10^(+07)$], [$4.475744 dot 10^(+07)$], [$1.426112 dot 10^(-06)$],
    [6],  [$6.000020 +0.000000i$], [$1.314094 dot 10^(+08)$], [$2.142103 dot 10^(+08)$], [$2.047667 dot 10^(-05)$],
    [7],  [$6.999602 +0.000000i$], [$3.939356 dot 10^(+08)$], [$1.784617 dot 10^(+09)$], [$3.979296 dot 10^(-04)$],
    [8],  [$8.007772 +0.000000i$], [$1.184987 dot 10^(+09)$], [$1.868697 dot 10^(+10)$], [$7.772029 dot 10^(-03)$],
    [9],  [$8.915816 +0.000000i$], [$2.225522 dot 10^(+09)$], [$1.374631 dot 10^(+11)$], [$8.418363 dot 10^(-02)$],
    [10], [$10.095456 -0.644933i$], [$1.067792 dot 10^(+10)$], [$1.490070 dot 10^(+12)$], [$6.519587 dot 10^(-01)$],
    [11], [$10.095456 +0.644933i$], [$1.067792 dot 10^(+10)$], [$1.490070 dot 10^(+12)$], [$1.110918 dot 10^(+00)$],
    [12], [$11.793891 -1.652477i$], [$3.140196 dot 10^(+10)$], [$3.296279 dot 10^(+13)$], [$1.665281 dot 10^(+00)$],
    [13], [$11.793891 +1.652477i$], [$3.140196 dot 10^(+10)$], [$3.296279 dot 10^(+13)$], [$2.045820 dot 10^(+00)$],
    [14], [$13.992407 -2.518824i$], [$2.157665 dot 10^(+11)$], [$9.546022 dot 10^(+14)$], [$2.518836 dot 10^(+00)$],
    [15], [$13.992407 +2.518824i$], [$2.157665 dot 10^(+11)$], [$9.546022 dot 10^(+14)$], [$2.712881 dot 10^(+00)$],
    [16], [$16.730745 -2.812625i$], [$4.850111 dot 10^(+11)$], [$2.742106 dot 10^(+16)$], [$2.906002 dot 10^(+00)$],
    [17], [$16.730745 +2.812625i$], [$4.850111 dot 10^(+11)$], [$2.742106 dot 10^(+16)$], [$2.825484 dot 10^(+00)$],
    [18], [$19.502442 -1.940332i$], [$4.557199 dot 10^(+12)$], [$4.252486 dot 10^(+17)$], [$2.454021 dot 10^(+00)$],
    [19], [$19.502442 +1.940332i$], [$4.557199 dot 10^(+12)$], [$4.252486 dot 10^(+17)$], [$2.004329 dot 10^(+00)$],
    [20], [$20.846910 +0.000000i$], [$8.756387 dot 10^(+12)$], [$1.374374 dot 10^(+18)$], [$8.469102 dot 10^(-01)$],
  ),
  caption: [Wielomian Wilkinsona — wyniki po zmianie współczynnika przy $x^19$],
)

== Wnioski

1. Wielomian Wilkinsona jest przykładem zadania źle uwarunkowanego. Pomimo że jego dokładne pierwiastki są liczbami całkowitymi od 1 do 20, obliczone numerycznie pierwiastki wykazują zauważalne odchylenia, szczególnie w środkowej części przedziału. Wynika to z dużej wrażliwości pierwiastków na niewielkie zaburzenia współczynników wielomianu.

2. Wartości wielomianu obliczane w postaci naturalnej i iloczynowej różnią się ze względu na błędy zaokrągleń. W postaci naturalnej występuje odejmowanie dużych składników o przeciwnych znakach, co prowadzi do utraty cyfr znaczących. W przeprowadzonym eksperymencie wartości obu postaci były jednak podobnego rzędu wielkości, więc nie zaobserwowano jednoznacznej przewagi postaci iloczynowej.

3. Niewielka zmiana współczynnika przy $x^19$ spowodowała znaczące przesunięcia pierwiastków oraz pojawienie się pierwiastków zespolonych. Przykładowo otrzymano parę $16.730745 plus.minus 2.812625i$, co jest zgodne z eksperymentem Wilkinsona opisanym w literaturze. Pokazuje to, że nawet bardzo mała względna zmiana współczynnika może istotnie zmienić rozwiązanie.

4. Dokładność wyznaczanych pierwiastków zależy zarówno od uwarunkowania zadania, jak i zastosowanej arytmetyki numerycznej. Ponieważ obliczenia wykonywane są w ograniczonej precyzji `Float64`, błędy zaokrągleń współczynników oraz wykonywanych operacji mogą wpływać na otrzymywane pierwiastki. Nawet stabilny numerycznie algorytm nie jest w stanie całkowicie wyeliminować skutków złego uwarunkowania zadania.

= Zadanie 5.

== Wyniki

#figure(
  image("zad5.svg", width: 60%),
  caption: [Wykresy wartości modelu logistycznego dla wszystkich eksperymentów.]
) <rys_zad5>

== Wnioski

1. Model logistyczny dla $r = 3$ wykazuje dużą wrażliwość na niewielkie zaburzenia wartości początkowych i błędy obliczeniowe. Obcięcie wyniku po dziesiątej iteracji do trzech miejsc po przecinku powoduje początkowo niewielką zmianę, która w kolejnych iteracjach narasta, prowadząc do znaczących różnic między otrzymanymi wartościami.

2. Obliczenia wykonane w arytmetyce `Float32` i `Float64` dają różne wyniki pomimo identycznych parametrów początkowych. Wynika to z różnej precyzji reprezentacji liczb i powstających błędów zaokrągleń, które są wzmacniane podczas kolejnych iteracji równania rekurencyjnego.

3. Eksperyment pokazuje ograniczenia numerycznego przewidywania zachowania układów chaotycznych. Nawet bardzo małe błędy mogą z czasem prowadzić do znacznych rozbieżności, dlatego zwiększenie precyzji obliczeń poprawia wiarygodność wyników jedynie w ograniczonym zakresie iteracji.

= Zadanie 6.

== Wyniki

#figure(
  image("c_minus_1.png", width: 50%),
  caption: [$c=-1$]
) <rys_zad6a>
#figure(
  image("c_minus_2.png", width: 50%),
  caption: [$c=-2$]
) <rys_zad6a>


== Wnioski

1. Dla $c=-2$ zaobserwowano dużą wrażliwość ciągu na warunki początkowe. W przypadku $x_0=2$ ciąg pozostaje stały, natomiast zmiana wartości początkowej na $1.99999999999999$ prowadzi do nieregularnych oscylacji. Wynika to z niestabilności punktu stałego $x=2$, w którego otoczeniu niewielkie zaburzenia są wzmacniane w kolejnych iteracjach.

2. Dla $c=-1$ wszystkie badane ciągi osiągają lub zbliżają się do stabilnego cyklu dwuelementowego $0,-1$. Pomimo różnych wartości początkowych ich długoterminowe zachowanie jest podobne, choć mogą różnić się fazą cyklu. Wynika to z przyciągającego charakteru tego cyklu okresowego.

3. Wyznaczone punkty stałe są niestabilne dla obu badanych wartości parametru $c$. Nie oznacza to jednak, że każdy ciąg musi się od nich oddalać — przy dokładnym trafieniu w punkt stały iteracje mogą pozostawać w nim bez końca, co zaobserwowano dla $c=-2$ i $x_0=2$.

4. Eksperyment pokazuje istotną rolę warunków początkowych i stabilności w obliczeniach iteracyjnych. Dla układów niestabilnych nawet bardzo małe zaburzenia mogą znacząco zmienić wyniki, podczas gdy układy posiadające stabilne cykle mogą tłumić takie zaburzenia i wykazywać przewidywalne zachowanie.
