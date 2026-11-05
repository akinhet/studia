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
  = Sprawozdanie do listy nr. 1 z kursu Obliczenia Naukowe
  ==== Piotr Zieniewicz 283961
]

= Zadanie 1.

// == Wstęp
//
// W tym zadaniu należało obliczyć metodą iteracyjną liczby _macheps_, _eta_ oraz _MAX_ dla kilku różnych typów zmiennoprzecinkowych, a następnie porównać je z wartościami wbudowanymi w język Julia oraz język C, a także odpowiedzieć na kilka powiązanych z tym tematem pytań.

== Wyniki


#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    inset: 10pt,
    table.header(
      [], [*Float16*], [*Float32*], [*Float64*]
    ),
    [_macheps_ (iterative)], $0.000977$, $1.1920929*10^(-7)$, $2.220446049250313*10^(-16)$,
    [_eps_ (in Julia)], $0.000977$, $1.1920929*10^(-7)$, $2.220446049250313*10^(-16)$,
    [_eps_ (in C)], $0.000977$, $1.1920929*10^(-7)$, $2.220446049250313*10^(-16)$,
    [_eta_ (iterative)], $6.0*10^(-8)$, $1.0*10^(-45)$, $5.0*10^(-324)$,
    [_eta_ (in Julia)], $6.0*10^(-8)$, $1.0*10^(-45)$, $5.0*10^(-324)$,
    [`floatmin(T)`], [N/A], $1.1754944*10^(-38)$, $2.2250738585072014*10^(-308)$,
    [_MAX_ (iterative)], $6.55*10^4$, $3.4028235*10^38$, $1.7976931348623157*10^308$,
    [_MAX_ (in Julia)], $6.55*10^4$, $3.4028235*10^38$, $1.7976931348623157*10^308$,
    [_MAX_ (in C)], $6.55*10^4$, $3.4028235*10^38$, $1.7976931348623157*10^308$,
  ),
  caption: [Wyniki zadania 1.]
) <zad1>

== Wnioski

- *Związek $epsilon$ z precyzją (długość mantysy):*
  Epsilon maszynowy $"macheps"$ mierzy krok dyskretyzacji arytmetyki wokół jedynki. Precyzja arytmetyki jest z nim powiązana relacją \ $epsilon = 1/2 dot "macheps"$. Spadek wartości $"macheps"$ dla wyższych typów wynika bezpośrednio ze wzrostu liczby bitów mantysy (10 bitów w `Float16`, 23 w `Float32`, 52 w `Float64`), co wyznacza dokładność względną reprezentacji liczb. Ważny jest fakt, że funkcja `eps(T)` w Julii nie zwraca $epsilon$ tylko $"macheps"$.

- *Postać zsubnormalizowana a $"MIN" _ "sub"$:*
  Wyznaczona wartość $eta$ jest równa najmniejszej dodatniej liczbie zsubnormalizowanej $"MIN"_"sub"$. Wynika to z mechanizmu IEEE 754, w którym po osiągnięciu minimalnego wykładnika zeruje się bit cechy, a mantysa traci ukrytą jedynkę. Pozwala to na reprezentowanie wartości mniejszych niż znormalizowane, aż do całkowitej utraty bitów precyzji.

- *Różnica między $"MIN"_"nor"$ (`floatmin`) a $"MIN"_"sub"$ ($eta$):*
  Funkcja `floatmin` wyznacza $"MIN"_"nor"$, czyli najmniejszą liczbę *znormalizowaną* posiadającą pełną precyzję mantysy (z ukrytą jedynką). Wartość $"MIN"_"sub"$ ($eta$) jest mniejsza od $"MIN"_"nor"$ dokładnie $2^p$ razy (gdzie $p$ to liczba bitów mantysy), ponieważ powstała przez zastąpienie ukrytej jedynki z mantysy zerem.

- *Zakres wartości $"MAX"$ (długość cechy):*
  Wartość $"MAX"$ jest wyznaczona przez maksymalną pojemność pola wykładnika (cechy) przy pełnym zapełnieniu mantysy jedynkami. Rozmiar cechy (5 bitów w `Float16`, 8 w `Float32`, 11 w `Float64`) definiuje zakres wykładnika $2^(E_"max")$, powyżej którego operacje przechodzą w wartość $+infinity$.

= Zadanie 2.

== Wyniki

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 10pt,
    table.header(
      [], [$delta$], [$delta = 2^x$]
    ),
    [$[1/2, 1]$], $1.1102230246251565*10^(-16)$, $-53$,
    [$[1, 2]$], $2.220446049250313*10^(-16)$, $-52$,
    [$[2, 4]$], $4.440892098500626*10^(-16)$, $-51$,
  ),
  caption: [Wyniki zadania 2.]
) <zad2>

== Wnioski

- *Równomierność rozmieszczenia w przedziale $[1, 2]$:*
  Eksperyment potwierdza, że w przedziale $[1, 2]$ liczby zmiennopozycyjne są rozmieszczone ze stałym krokiem $delta = 2^(-52)$. Każda kolejna liczba maszynowa różni się od poprzedniej o dokładnie 1 na najmniej znaczącym bicie mantysy, co widać w reprezentacji binarnej zwracanej przez `bitstring` (`...00`, `...01`, `...10`, `...11`).

- *Skalowanie kroku $delta$ w sąsiednich przedziałach:*
  Krok siatki dyskretyzacji zależy bezpośrednio od wartości cechy (wykładnika) i ulega podwojeniu przy każdym przejściu do kolejnego przedziału postaci $[2^E, 2^(E+1)]$:
  - Dla $[1/2, 1]$ wykładnik wynosi $E = -1$, a krok siatki to $delta = 2^(-53)$.
  - Dla $[1, 2]$ wykładnik wynosi $E = 0$, a krok siatki to $delta = 2^(-52)$.
  - Dla $[2, 4]$ wykładnik wynosi $E = 1$, a krok siatki to $delta = 2^(-51)$.

- *Ogólna postać reprezentacji liczb maszynowych:*
  Dla dowolnego przedziału $[2^E, 2^(E+1)]$ każdą reprezentowalną liczbę zmiennopozycyjną $x$ można przedstawić w postaci:
  $ x = 2^E + k dot delta_E $
  gdzie $delta_E = 2^(E - 52)$ to krok dyskretyzacji w tym przedziale, a $k in {0, 1, 2, dots, 2^52 - 1}$ oznacza indeks kolejnej liczby maszynowej odpowiadający wartości całkowitej zapisanej na 52 bitach mantysy.

= Zadanie 3.

== Wyniki

$ x = 1.000000057228997 \
"fl"(x * "fl"(1/x)) = 0.9999999999999999 $

== Wnioski

- *Błąd zaokrągleń:*
  Nierówność $"fl"(x dot "fl"(1/x)) != 1$ wynika z błędów zaokrągleń podczas obliczania odwrotności i mnożenia. Błędy te nie zawsze się kompensują, przez co wynik może różnić się od jedynki.

- *Reprezentacja binarna:*
  Dla $x = 1.000000057228997$ odwrotność nie ma skończonego rozwinięcia binarnego. Jej przybliżenie powoduje, że końcowy iloczyn różni się od 1.

- *Najmniejsza liczba:*
  Ponieważ przeszukiwanie obejmowało wszystkie kolejne wartości `Float64` od `nextfloat(1.0)`, pierwsza znaleziona liczba jest najmniejszą spełniającą warunek w przedziale $(1, 2)$.

= Zadanie 4.

== Wyniki

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 10pt,
    table.header(
      [], [*Float32*], [*Float64*]
    ),
    [a], $-0.4999443$, $1.0251881368296672*10^(-10)$,
    [b], $-0.4543457$, $-1.5643308870494366*10^(-10)$,
    [c], $-0.5$, $0.0$,
    [d], $-0.5$, $0.0$,
    [builtin], $-0.34720382$, $1.0251881368296672*10^(-10)$,
    [real], table.cell(colspan: 2, $-1.00657107000000*10^(-11)$)
  ),
  caption: [Wyniki zadania 4.]
) <zad4>

== Wnioski

- *Zjawisko kasowania cyfr znaczących:*
  Iloczyny częściowe zawierają duże wartości o przeciwnych znakach, których suma jest bliska zeru. Powoduje to utratę dokładności podczas dodawania i dużą wrażliwość wyniku na błędy zaokrągleń.

- *Wpływ kolejności sumowania:*
  Sumowanie w przód (`a`) daje w tym przypadku najdokładniejszy wynik, ponieważ duże wartości znoszą się stosunkowo wcześnie. Sumowanie w tył (`b`) jest mniej dokładne. Metody `c` i `d`, sumujące osobno liczby dodatnie i ujemne, prowadzą do największych błędów wskutek odejmowania dużych, niemal równych sum częściowych.

- *Wpływ precyzji:*
  `Float32` nie zapewnia wystarczającej dokładności do obliczenia wyniku rzędu $10^(-11)$ przy składnikach rzędu $10^6$. `Float64` znacząco zmniejsza błędy, jednak nadal nie gwarantuje dokładnego wyniku ze względu na kasowanie cyfr znaczących.

= Zadanie 5.

== Wyniki

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 10pt,
    table.header(
      [x], [$f(x)$], [$g(x)$]
    ),
    $8^(-1)$, $7.7822185373186414381052600*10^(-3)$, $7.7822185373187064902356092*10^(-3)$,
    $8^(-2)$, $1.2206286282867573333987821*10^(-4)$, $1.2206286282875901361925225*10^(-4)$,
    $8^(-3)$, $1.9073468138230964541435242*10^(-6)$, $1.9073468138265659010954778*10^(-6)$,
    $8^(-7)$, $1.1368683772161602973937988*10^(-13)$, $1.1368683772160956739084431*10^(-13)$,
    $8^(-8)$, $1.7763568394002504646778107*10^(-15)$, $1.7763568394002488869560002*10^(-15)$,
    $8^(-9)$, $0$, $2.7755575615628913510590792*10^(-17)$,
    $8^(-10)$, $0$, $4.3368086899420177360298112*10^(-19)$,
    $8^(-11)$, $0$, $6.7762635780344027125465800*10^(-21)$,
  ),
  caption: [Wyniki zadania 5.]
) <zad4>

== Wnioski

- *Równoważność funkcji:*
  Funkcje $f(x)$ i $g(x)$ są matematycznie równoważne, jednak ze względu na błędy zaokrągleń dają różne wyniki w arytmetyce zmiennoprzecinkowej.

- *Utrata dokładności w $f(x)$:*
  Dla małych wartości $x$ odejmowanie dwóch liczb bliskich jedynce powoduje utratę cyfr znaczących. Gdy $x^2$ jest dostatecznie małe, wyrażenie $sqrt(1 + x^2)$ zaokrągla się do 1, przez co $f(x) = 0$. Dla badanych argumentów następuje to od $x = 8^(-9)$.

- *Stabilność numeryczna $g(x)$:*
  Funkcja $g(x)$ eliminuje odejmowanie bliskich sobie liczb. Dla małych $x$ zachodzi $g(x) approx x^2 / 2$, dzięki czemu zachowuje ona wysoką dokładność w całym badanym zakresie. Jest zatem numerycznie bardziej wiarygodna niż $f(x)$.

= Zadanie 6.

== Wyniki

#figure(
  image("zad6_wykres.svg", width: 85%),
  caption: [Błąd bezwzględny przybliżenia pochodnej w zależności od $n$.]
) <rys_zad6>

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    table.header(
      [*$n$*], [*$h = 2^(-n)$*], [*$tilde f'(x_0)$*], [*Błąd $|f'(x_0) - tilde f'(x_0)|$*]
    ),
    [0], [$1.0$], [$2.017989$], [$1.901047$],
    [14], [$6.10 times 10^(-5)$], [$0.117189$], [$2.46 times 10^(-4)$],
    [*28*], [*$3.73 times 10^(-9)$*], [*$0.116942286$*], [*$4.80 times 10^(-9)$*],
    [40], [$9.09 times 10^(-13)$], [$0.116821$], [$1.21 times 10^(-4)$],
    [53], [$1.11 times 10^(-16)$], [$0.000000$], [$1.17 times 10^(-1)$],
  ),
  caption: [Wybrane wartości przybliżenia pochodnej dla reprezentatywnych punktów.]
)

== Wnioski

- *Optymalny krok $h$:*
  Początkowo zmniejszanie $h$ poprawia dokładność przybliżenia pochodnej, ponieważ maleje błąd obcięcia. Najmniejszy zaobserwowany błąd występuje dla $n = 28$ ($h = 2^(-28)$).

- *Wpływ błędów zaokrągleń:*
  Dla bardzo małych $h$ odejmowanie bliskich wartości $f(1+h)$ i $f(1)$ powoduje utratę cyfr znaczących. Dzielenie tej różnicy przez coraz mniejsze $h$ wzmacnia błędy zaokrągleń, przez co dokładność przybliżenia pogarsza się.

- *Zachowanie $1+h$:*
  Dla $n >= 53$ w arytmetyce `Float64` zachodzi $"fl"(1+h) = 1$, ponieważ $h <= 2^(-53)$. W rezultacie licznik wynosi zero, a obliczona pochodna również przyjmuje wartość $0.0$, mimo że rzeczywista pochodna jest niezerowa.
