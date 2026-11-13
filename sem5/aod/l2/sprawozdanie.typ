#show figure.caption: strong
#set text(lang: "pl", size: 11pt)
#set page(numbering: "1")
#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): it => block(
  above: 2em,
  below: 0.8em,
  it
)

#align(center)[
  = Sprawozdanie do listy nr. 2 z kursu Algorytmy Optymalizacji Dyskretnej
  ==== Piotr Zieniewicz 283961
]

= Zadanie 1.

== Model

=== Parametry
 - $"supply"_i$ - maksymalna ilość paliwa zakupionego od $i$-tego dostawcy
 - $"demand"_i$ - ilość paliwa potrzebnego na $i$-tym lotnisku
 - $"cost"_(i j)$ - koszt zakupu paliwa na $i$-tymlotnisku od $j$-tego dostawcy

=== Zmienne
$ forall_(i in "Lotniska", j in "Dostawcy") x_(i j) >= 0 $

Zmienne $x_(i j)$ odpowiadają ilości zakupionego paliwa na $i$-tym lotnisku od $j$-tego dostawcy, mierzone w galonach.

=== Ograniczenia

$ forall_(i in "Dostawcy") sum_(j in "Lotniska") x_(i j) <= "supply"_i $
$ forall_(i in "Lotniska") sum_(j in "Dostawcy") x_(j i) = "demand"_i $

=== Funkcja celu

$ min sum_(i in "Lotniska", j in "Dostawcy") x_(i j) dot "cost"_(i j) $

== Egzemplarz

W tym egzemplarzu mamy 3 dostawców i 4 lotniska.

== Wyniki


Wartości zmiennych $x_(i j)$:
#align(center)[
#table(
  columns: (auto, auto, auto, auto),
  align: (left, center, center, center),
  inset: 10pt,
  table.header(
    [], [*Firma 1*], [*Firma 2*], [*Firma 3*],
  ),
  [*Lotnisko 1*], $0$, $110000$, $0$,
  [*Lotnisko 2*], $165000$, $55000$, $0$,
  [*Lotnisko 3*], $0$, $0$, $330000$,
  [*Lotnisko 4*], $110000$, $0$, $330000$,
)
]

Minimalny koszt zakupu paliwa:
$ sum_(i in "Lotniska", j in "Dostawcy") x_(i j) dot "cost"_(i j) = 8525000 $

Wyczerpanie możliwości dostaw paliwa przez firmy:
$ sum_(j in "Lotniska") x_(1 j) = "supply"_1 $
$ sum_(j in "Lotniska") x_(2 j) != "supply"_2 $
$ sum_(j in "Lotniska") x_(3 j) = "supply"_3 $


= Zadanie 2.

== Model

=== Parametry
- $"price"_i$ - cena sprzedaży jednostki $i$-tego produktu
- $"materialcost"_i$ - koszt materiałów potrzebnych do wytworzenia jednostki $i$-tego produktu
- $"operatingcost"_j$ - godzinowy koszt pracy $j$-tej maszyny
- $"demand"_i$ - maksymalne zapotrzebowanie na $i$-ty produkt
- $"timeneeded"_(i j)$ - czas potrzebny na wytworzenie jednostki $i$-tego produktu na $j$-tej maszynie, wyrażony w minutach

=== Zmienne

$ forall_(i in "Produkty") 0 <= x_i <= "demand"_i $

Zmienna $x_i$ odpowiada liczbie wyprodukowanych jednostek $i$-tego produktu.

=== Ograniczenia

Każda maszyna może pracować przez maksymalnie 60 godzin:

$ forall_(j in "Maszyny") sum_(i in "Produkty") (x_i dot "timeneeded"_(i j)) / 60 <= 60 $

Ponadto produkcja każdego produktu nie może przekroczyć zapotrzebowania.

=== Funkcja celu

Celem jest maksymalizacja zysku, czyli różnicy między przychodami ze sprzedaży a kosztami materiałów i pracy maszyn.

$ max (
    sum_(i in "Produkty") x_i dot ("price"_i - "materialcost"_i)
    - sum_(i in "Produkty", j in "Maszyny") (x_i dot "operatingcost"_j dot "timeneeded"_(i j)) / 60
) $

== Egzemplarz

W tym egzemplarzu mamy 4 produkty i 3 maszyny. Każda maszyna może pracować maksymalnie 60 godzin.

== Wyniki

Wartości zmiennych $x_i$:

#align(center)[
  #table(
    columns: (auto, auto),
    align: (left, center),
    inset: 10pt,
    table.header(
      [*Produkt*], [*Liczba jednostek*],
    ),
    [*Produkt 1*], $125$,
    [*Produkt 2*], $100$,
    [*Produkt 3*], $150$,
    [*Produkt 4*], $500$,
  )
]

Maksymalny zysk:

$ "objective" = 3632.5 $

Wykorzystanie czasu pracy maszyn:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 10pt,
    table.header(
      [*Maszyna*], [*Czas pracy [h]*], [*Wykorzystanie*],
    ),
    [*Maszyna 1*], $58.75$, $97.92%$,
    [*Maszyna 2*], $60$, $100%$,
    [*Maszyna 3*], $35$, $58.33%$,
  )
]

Wyczerpanie dostępnego czasu pracy maszyn:

$ sum_(i in "Produkty") (x_i dot "timeneeded"_(i 1)) / 60 < 60 $
$ sum_(i in "Produkty") (x_i dot "timeneeded"_(i 2)) / 60 = 60 $
$ sum_(i in "Produkty") (x_i dot "timeneeded"_(i 3)) / 60 < 60 $

Osiągnięcie maksymalnego zapotrzebowania:

$ x_1 < "demand"_1 $
$ x_2 = "demand"_2 $
$ x_3 = "demand"_3 $
$ x_4 = "demand"_4 $

Optymalne rozwiązanie zakłada pełne zaspokojenie zapotrzebowania na produkty 2, 3 i 4 oraz wyprodukowanie 125 jednostek produktu 1.

Ograniczeniem uniemożliwiającym dalsze zwiększenie produkcji jest czas pracy drugiej maszyny, który został wykorzystany w całości.


= Zadanie 3.

== Model

=== Parametry
- $"maxProd"$ - maksymalna liczba jednostek towaru produkowanych w trybie normalnym w jednym okresie
- $"cost"_j$ - koszt wyprodukowania jednostki towaru w trybie normalnym w $j$-tym okresie
- $"demand"_j$ - zapotrzebowanie na towar w $j$-tym okresie
- $"maxOvertime"_j$ - maksymalna liczba dodatkowych jednostek towaru możliwych do wyprodukowania w $j$-tym okresie
- $"overtimeCost"_j$ - koszt wyprodukowania jednostki towaru w trybie nadwyżkowym w $j$-tym okresie
- $"maxStorage"$ - maksymalna pojemność magazynu
- $"storageCost"$ - koszt magazynowania jednej jednostki towaru przez jeden okres
- $"initialStorage"$ - początkowa liczba jednostek towaru w magazynie

=== Zmienne

$ forall_(j in "Okresy") 0 <= p_j <= "maxProd" $

$ forall_(j in "Okresy") 0 <= o_j <= "maxOvertime"_j $

$ forall_(j in "Okresy") 0 <= s_j <= "maxStorage" $

Zmienne:
- $p_j$ - liczba jednostek towaru wyprodukowanych w trybie normalnym w $j$-tym okresie
- $o_j$ - liczba jednostek towaru wyprodukowanych w trybie nadwyżkowym w $j$-tym okresie
- $s_j$ - liczba jednostek towaru pozostających w magazynie na koniec $j$-tego okresu

=== Ograniczenia

W każdym okresie suma produkcji oraz zapasów z poprzedniego okresu musi pokrywać zapotrzebowanie i zapasy pozostające na koniec okresu:

$ forall_(j in "Okresy") s_(j-1) + p_j + o_j = "demand"_j + s_j $

Przy czym początkowy stan magazynu wynosi:

$ s_0 = "initialStorage" = 15 $

Na koniec ostatniego okresu magazyn musi być pusty:

$ s_4 = 0 $

Ponadto produkcja normalna, nadwyżkowa oraz stan magazynu nie mogą przekraczać odpowiednich górnych ograniczeń określonych przy zmiennych.

=== Funkcja celu

Celem jest minimalizacja łącznego kosztu produkcji normalnej, produkcji nadwyżkowej oraz magazynowania towaru.

$ min sum_(j in "Okresy") (
    "cost"_j dot p_j
    + "overtimeCost"_j dot o_j
    + "storageCost" dot s_j
) $

== Egzemplarz

W tym egzemplarzu mamy 4 kolejne okresy produkcyjne.

Maksymalna produkcja normalna wynosi 100 jednostek na okres, pojemność magazynu wynosi 70 jednostek, a początkowy zapas to 15 jednostek.

Koszt magazynowania jednej jednostki przez jeden okres wynosi 1500 \$.

== Wyniki

Optymalne wartości zmiennych:

#align(center)[
  #table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    inset: 10pt,
    table.header(
      [*Okres*],
      [*Produkcja normalna*],
      [*Produkcja nadwyżkowa*],
      [*Stan magazynu*],
    ),
    [1], $100$, $15$, $0$,
    [2], $100$, $50$, $70$,
    [3], $100$, $0$, $45$,
    [4], $100$, $50$, $0$,
  )
]

Minimalny całkowity koszt:

$ "objective" = 3842500 $

Koszt produkcji normalnej:

$ sum_(j in "Okresy") "cost"_j dot p_j = 2700000 $

Koszt produkcji nadwyżkowej:

$ sum_(j in "Okresy") "overtimeCost"_j dot o_j = 970000 $

Koszt magazynowania:

$ sum_(j in "Okresy") "storageCost" dot s_j = 172500 $

=== Wykorzystanie możliwości produkcyjnych

Produkcja normalna we wszystkich okresach osiąga maksymalną dopuszczalną wartość:

$ forall_(j in "Okresy") p_j = "maxProd" = 100 $

Wykorzystanie produkcji nadwyżkowej:

$ o_1 < "maxOvertime"_1 $
$ o_2 < "maxOvertime"_2 $
$ o_3 < "maxOvertime"_3 $
$ o_4 < "maxOvertime"_4 $

W żadnym okresie nie wykorzystano pełnych możliwości produkcji nadwyżkowej.

=== Wykorzystanie magazynu

$ s_1 < "maxStorage" $
$ s_2 = "maxStorage" $
$ s_3 < "maxStorage" $
$ s_4 = 0 $

Magazyn osiąga maksymalną pojemność w drugim okresie.

=== Wnioski

Optymalne rozwiązanie zakłada wykorzystanie pełnych możliwości produkcji normalnej we wszystkich czterech okresach.

W drugim okresie, w którym koszty produkcji są najniższe, firma wytwarza dodatkowe 50 jednostek w trybie nadwyżkowym i gromadzi 70 jednostek w magazynie.

W trzecim okresie firma nie korzysta z produkcji nadwyżkowej, lecz wykorzystuje 25 jednostek wcześniej zgromadzonego zapasu.

W czwartym okresie pozostałe 45 jednostek z magazynu oraz bieżąca produkcja pokrywają zapotrzebowanie wynoszące 195 jednostek.

Takie rozwiązanie pozwala ograniczyć koszt produkcji nadwyżkowej w droższych okresach, pomimo konieczności poniesienia kosztów magazynowania.


= Zadanie 4.

== Model

=== Parametry

- $"Nodes"$ - zbiór miast (wierzchołków grafu)
- $"Arcs"$ - zbiór skierowanych połączeń między miastami
- $"cost"_(i j)$ - koszt przejazdu z miasta $i$ do miasta $j$
- $"time"_(i j)$ - czas przejazdu z miasta $i$ do miasta $j$
- $"source"$ - miasto początkowe
- $"destination"$ - miasto docelowe
- $"maxTime"$ - maksymalny dopuszczalny czas przejazdu

=== Zmienne

$ forall_((i,j) in "Arcs") x_(i j) in {0,1} $

Zmienna $x_(i j)$ określa, czy połączenie z miasta $i$ do miasta $j$ należy do wybranej ścieżki:

$ x_(i j) = cases(
  1 & "jeżeli połączenie należy do ścieżki",
  0 & "w przeciwnym przypadku"
) $

=== Ograniczenia

Dla każdego wierzchołka obowiązuje warunek zachowania przepływu:

$ forall_(v in "Nodes") sum_((v,j) in "Arcs") x_(v j) - sum_((i,v) in "Arcs") x_(i v) = cases(
  1 & "gdy " v = "source",
  -1 & "gdy " v = "destination",
  0 & "w pozostałych przypadkach"
) $

Oznacza to, że z miasta początkowego musi wychodzić o jedno połączenie więcej niż do niego wchodzi, do miasta docelowego musi wchodzić o jedno połączenie więcej niż z niego wychodzi, natomiast dla pozostałych miast liczba połączeń wchodzących i wychodzących musi być równa.

Łączny czas przejazdu nie może przekroczyć ustalonej wartości:

$ sum_((i,j) in "Arcs") "time"_(i j) dot x_(i j) <= "maxTime" $

=== Funkcja celu

Celem jest minimalizacja całkowitego kosztu przejazdu:

$ min sum_((i,j) in "Arcs") "cost"_(i j) dot x_(i j) $

== Egzemplarz A

W pierwszym egzemplarzu mamy graf skierowany składający się z 10 wierzchołków i 21 krawędzi.

Miastem początkowym jest wierzchołek 1, a docelowym wierzchołek 10.

Maksymalny dopuszczalny czas przejazdu wynosi $T = 15$.

#figure(
  image("z4/graph.svg", width: 90%),
  caption: [Graf dla egzemplarza A. Etykiety krawędzi przedstawiają koszt i czas przejazdu. Czerwona ścieżka to najlepsza ścieżka dla braku ograniczeń. Zielona to rozwiązanie egzemplarza.],
)

=== Wyniki

Optymalna ścieżka:

$ 1 -> 2 -> 3 -> 5 -> 7 -> 9 -> 10 $

Wybrane połączenia:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center,
    inset: 10pt,
    table.header(
      [*Połączenie*], [*Koszt*], [*Czas*],
    ),
    [$1 -> 2$], $3$, $4$,
    [$2 -> 3$], $2$, $3$,
    [$3 -> 5$], $2$, $2$,
    [$5 -> 7$], $3$, $3$,
    [$7 -> 9$], $1$, $1$,
    [$9 -> 10$], $2$, $2$,
  )
]

Minimalny koszt przejazdu:

$ "objective" = 3 + 2 + 2 + 3 + 1 + 2 = 13 $

Łączny czas przejazdu:

$ 4 + 3 + 2 + 3 + 1 + 2 = 15 $

Ograniczenie czasowe zostało spełnione i wykorzystane w całości:

$ sum_((i,j) in "Arcs") "time"_(i j) dot x_(i j) = T = 15 $

=== Wnioski

Optymalna ścieżka składa się z 6 krawędzi, a jej całkowity koszt wynosi 13.

Czas przejazdu jest dokładnie równy maksymalnej dopuszczalnej wartości, co oznacza, że ograniczenie czasowe jest aktywne.

Bez ograniczenia czasowego najtańsza byłaby ścieżka:

$ 1 -> 3 -> 10 $

Jej koszt wynosi 10, a czas przejazdu 20, dlatego nie spełnia ograniczenia $T = 15$.

== Egzemplarz B

W drugim egzemplarzu również mamy graf skierowany składający się z 10 wierzchołków, tym razem z 13 krawędziami.

Miastem początkowym jest wierzchołek 1, a docelowym wierzchołek 10.

Maksymalny dopuszczalny czas przejazdu wynosi $T = 15$.

#figure(
  image("z4/graphb.svg", width: 90%),
  caption: [Graf dla egzemplarza B. Etykiety krawędzi przedstawiają koszt i czas przejazdu.],
)

=== Wyniki

Optymalna ścieżka:

$ 1 -> 3 -> 4 -> 10 $

Wybrane połączenia:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center,
    inset: 10pt,
    table.header(
      [*Połączenie*], [*Koszt*], [*Czas*],
    ),
    [$1 -> 3$], $2$, $3$,
    [$3 -> 4$], $2$, $3$,
    [$4 -> 10$], $2$, $3$,
  )
]

Minimalny koszt przejazdu:

$ "objective" = 2 + 2 + 2 = 6 $

Łączny czas przejazdu:

$ 3 + 3 + 3 = 9 $

Ograniczenie czasowe zostało spełnione:

$ 9 <= 15 $

=== Porównanie z rozwiązaniem bez ograniczenia czasowego

Po usunięciu ograniczenia czasowego najtańszą ścieżką jest:

$ 1 -> 2 -> 10 $

Jej całkowity koszt wynosi:

$ 1 + 1 = 2 $

Natomiast czas przejazdu wynosi:

$ 10 + 10 = 20 $

Ścieżka ta nie spełnia ograniczenia czasowego, ponieważ:

$ 20 > 15 $

Porównanie obu rozwiązań:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center,
    inset: 10pt,
    table.header(
      [],
      [*Z ograniczeniem*],
      [*Bez ograniczenia*],
    ),
    [Koszt], $6$, $2$,
    [Czas], $9$, $20$,
    [Liczba krawędzi], $3$, $2$,
  )
]

=== Wnioski

Optymalna ścieżka spełniająca ograniczenie czasowe składa się z 3 krawędzi, a jej całkowity koszt wynosi 6.

Bez ograniczenia czasowego najtańsza ścieżka składa się z 2 krawędzi i ma koszt 2, jednak jej czas przejazdu przekracza dopuszczalny limit.

Egzemplarz spełnia więc wszystkie wymagania zadania.

== Całkowitoliczbowość zmiennych

=== Punkt (c)

Ograniczenie całkowitoliczbowości zmiennych jest potrzebne, ponieważ po jego usunięciu model może dopuszczać ułamkowe wartości zmiennych decyzyjnych.

Oznacza to możliwość podziału przepływu pomiędzy kilka ścieżek, co nie odpowiada zadaniu wyboru jednej konkretnej trasy.

Kontrprzykład stanowi egzemplarz B.

Po zastąpieniu ograniczenia binarności przez:

$ 0 <= x_(i j) <= 1 $

rozwiązanie optymalne relaksacji liniowej może przyjmować następujące wartości:

$ x_(1 2) = x_(2 10) = 6/11 $

$ x_(1 3) = x_(3 4) = x_(4 10) = 5/11 $

Pozostałe zmienne są równe zero.

Wartość funkcji celu wynosi:

$ "objective" = 2 dot 6/11 + 6 dot 5/11 = 42/11 approx 3.818 $

Całkowity ważony czas przejazdu:

$ 20 dot 6/11 + 9 dot 5/11 = 15 $

Rozwiązanie spełnia wszystkie ograniczenia modelu liniowego, jednak nie reprezentuje pojedynczej ścieżki.

Jego koszt jest mniejszy od kosztu optymalnej ścieżki całkowitoliczbowej:

$ 42/11 < 6 $

Pokazuje to, że ograniczenie całkowitoliczbowości jest istotne dla poprawnego modelowania tego problemu.

== Usunięcie ograniczenia czasowego

=== Punkt (d)

Po usunięciu ograniczenia czasowego problem sprowadza się do klasycznego problemu najkrótszej ścieżki w grafie skierowanym, w którym minimalizowany jest koszt przejazdu.

Macierz ograniczeń zachowania przepływu jest macierzą całkowicie unimodularną.

Ponieważ prawe strony ograniczeń są całkowite, a granice zmiennych również są całkowite, istnieje optymalne rozwiązanie całkowitoliczbowe relaksacji liniowej.

Oznacza to, że po usunięciu ograniczenia czasowego można zrezygnować z binarności zmiennych bez utraty możliwości znalezienia optymalnej ścieżki.

Należy jednak zaznaczyć, że przy istnieniu wielu równoważnych kosztowo ścieżek mogą występować także optymalne rozwiązania ułamkowe, będące kombinacjami tych ścieżek.

Dlatego nie każde rozwiązanie relaksacji musi bezpośrednio reprezentować pojedynczą trasę, ale zawsze istnieje rozwiązanie optymalne o wartościach całkowitych.

Przy dodatnich kosztach krawędzi takie rozwiązanie odpowiada najtańszej ścieżce od miasta początkowego do docelowego.

=== Wnioski

Ograniczenie czasowe powoduje, że problem staje się bardziej złożony niż klasyczny problem najkrótszej ścieżki.

W obecności tego ograniczenia relaksacja liniowa może prowadzić do rozwiązań ułamkowych o koszcie mniejszym niż koszt dowolnej dopuszczalnej ścieżki.

Po usunięciu ograniczenia czasowego własność całkowitej unimodularności zapewnia istnienie optymalnego rozwiązania całkowitoliczbowego, dlatego binarność zmiennych nie jest konieczna do znalezienia optymalnej ścieżki.


= Zadanie 5.

== Model

=== Parametry

- $"minCars"_(i j)$ - minimalna liczba radiowozów przydzielonych do $i$-tej dzielnicy na $j$-tej zmianie
- $"maxCars"_(i j)$ - maksymalna liczba radiowozów przydzielonych do $i$-tej dzielnicy na $j$-tej zmianie
- $"minDistrict"_i$ - minimalna łączna liczba przydziałów radiowozów do $i$-tej dzielnicy
- $"minShift"_j$ - minimalna liczba radiowozów potrzebnych na $j$-tej zmianie

=== Zmienne

$ forall_(i in "Dzielnice", j in "Zmiany") "minCars"_(i j) <= x_(i j) <= "maxCars"_(i j) $

$ x_(i j) in ZZ $

Zmienna $x_(i j)$ odpowiada liczbie radiowozów przydzielonych do $i$-tej dzielnicy na $j$-tej zmianie.

=== Ograniczenia

Łączna liczba przydziałów radiowozów do każdej dzielnicy musi spełniać minimalne wymagania:

$ forall_(i in "Dzielnice") sum_(j in "Zmiany") x_(i j) >= "minDistrict"_i $

Łączna liczba radiowozów dostępnych na każdej zmianie musi być nie mniejsza od wymaganej:

$ forall_(j in "Zmiany") sum_(i in "Dzielnice") x_(i j) >= "minShift"_j $

Ponadto liczba radiowozów w każdej dzielnicy na każdej zmianie musi mieścić się w przedziale określonym przez parametry $"minCars"_(i j)$ i $"maxCars"_(i j)$.

=== Funkcja celu

Celem jest minimalizacja łącznej liczby przydziałów radiowozów do dzielnic na wszystkich zmianach.

$ min sum_(i in "Dzielnice", j in "Zmiany") x_(i j) $

== Egzemplarz

W tym egzemplarzu mamy 3 dzielnice i 3 zmiany.

Minimalne liczby radiowozów wymagane na kolejnych zmianach wynoszą odpowiednio 10, 20 i 18.

Minimalne łączne liczby przydziałów do kolejnych dzielnic wynoszą odpowiednio 10, 14 i 13.

== Wyniki

Optymalne wartości zmiennych $x_(i j)$:

#align(center)[
  #table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    inset: 10pt,
    table.header(
      [], [*Zmiana 1*], [*Zmiana 2*], [*Zmiana 3*],
    ),
    [*Dzielnica 1*], $2$, $7$, $5$,
    [*Dzielnica 2*], $3$, $6$, $7$,
    [*Dzielnica 3*], $5$, $7$, $6$,
  )
]

Minimalna łączna liczba przydziałów radiowozów:

$ "objective" = 48 $

=== Spełnienie wymagań dla zmian

$ sum_(i in "Dzielnice") x_(i 1) = 10 = "minShift"_1 $

$ sum_(i in "Dzielnice") x_(i 2) = 20 = "minShift"_2 $

$ sum_(i in "Dzielnice") x_(i 3) = 18 = "minShift"_3 $

Na każdej zmianie liczba radiowozów jest dokładnie równa minimalnej wymaganej wartości.

=== Spełnienie wymagań dla dzielnic

$ sum_(j in "Zmiany") x_(1 j) = 14 > "minDistrict"_1 $

$ sum_(j in "Zmiany") x_(2 j) = 16 > "minDistrict"_2 $

$ sum_(j in "Zmiany") x_(3 j) = 18 > "minDistrict"_3 $

Minimalne wymagania dla wszystkich dzielnic zostały spełnione.

=== Wnioski

Optymalne rozwiązanie zakłada łącznie 48 przydziałów radiowozów, z czego 10 przypada na pierwszą zmianę, 20 na drugą i 18 na trzecią.

Wszystkie ograniczenia dotyczące minimalnej i maksymalnej liczby radiowozów w poszczególnych dzielnicach i na zmianach zostały spełnione.

Wartość funkcji celu jest optymalna, ponieważ suma minimalnych wymagań dla trzech zmian wynosi 48 i znalezione rozwiązanie osiąga dokładnie tę wartość.

Oznacza to, że nie można zmniejszyć łącznej liczby przydziałów bez naruszenia przynajmniej jednego z ograniczeń.


= Zadanie 6.

== Model

=== Parametry

- $m$ - liczba wierszy terenu
- $n$ - liczba kolumn terenu
- $k$ - maksymalna odległość obserwacji kamery w każdym z czterech kierunków
- $"Containers"$ - zbiór współrzędnych kwadratów zajętych przez kontenery

=== Zmienne

$ forall_(i in "Rows", j in "Cols") x_(i j) in {0, 1} $

Zmienna $x_(i j)$ określa, czy w kwadracie o współrzędnych $(i, j)$ umieszczono kamerę:

$ x_(i j) = cases(
  1 & "jeżeli w kwadracie znajduje się kamera",
  0 & "w przeciwnym przypadku"
) $

=== Ograniczenia

Kamera nie może zostać umieszczona w kwadracie zajętym przez kontener:

$ forall_((i,j) in "Containers") x_(i j) = 0 $

Każdy kontener musi być monitorowany przez co najmniej jedną kamerę znajdującą się w tym samym wierszu lub kolumnie, w odległości nie większej niż $k$.

Definiujemy zbiór kwadratów, z których można obserwować kontener $(i,j)$:

$ V_(i j) = {(r,c) : (r = i and abs(c-j) <= k) or (c = j and abs(r-i) <= k)} $

Ograniczenie pokrycia przyjmuje postać:

$ forall_((i,j) in "Containers") sum_((r,c) in V_(i j)) x_(r c) >= 1 $

=== Funkcja celu

Celem jest minimalizacja łącznej liczby kamer rozmieszczonych na terenie:

$ min sum_(i in "Rows", j in "Cols") x_(i j) $

== Egzemplarz

W rozpatrywanym egzemplarzu teren ma wymiary $5 times 5$ kwadratów, a maksymalny zasięg obserwacji kamery wynosi $k = 1$ w pierwszym przypadku, a w drugim $k = 2$.

Kontenery znajdują się na pozycjach:

$ "Containers" = {(1,1), (1,5), (3,3), (5,1), (5,5)} $

Łącznie na terenie znajduje się 5 kontenerów.


== Wyniki

Rozwiązano problem dla dwóch wartości parametru $k$, przy zachowaniu tych samych wymiarów terenu oraz rozmieszczenia kontenerów.

=== Przypadek $k = 1$

Minimalna liczba wymaganych kamer:

$ "objective" = 5 $

Przykładowe optymalne rozmieszczenie kamer:

#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: center,
    inset: 10pt,
    table.header(
      [], [*1*], [*2*], [*3*], [*4*], [*5*],
    ),
    [*1*], [K], [C], [], [C], [K],
    [*2*], [], [], [], [], [],
    [*3*], [], [C], [K], [], [],
    [*4*], [C], [], [], [], [C],
    [*5*], [K], [], [], [], [K],
  )
]

Kamery umieszczono na pozycjach:

$ (1,2), (1,4), (3,2), (5,2), (5,4) $

Każdy kontener jest obserwowany przez osobną kamerę, ponieważ przy zasięgu $k = 1$ nie istnieje kwadrat umożliwiający obserwację dwóch kontenerów jednocześnie.

=== Przypadek $k = 2$

Minimalna liczba wymaganych kamer:

$ "objective" = 2 $

#pagebreak()
Przykładowe optymalne rozmieszczenie kamer:

#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: center,
    inset: 10pt,
    table.header(
      [], [*1*], [*2*], [*3*], [*4*], [*5*],
    ),
    [*1*], [K], [], [], [], [K],
    [*2*], [], [], [], [], [],
    [*3*], [C], [], [K], [], [C],
    [*4*], [], [], [], [], [],
    [*5*], [K], [], [], [], [K],
  )
]

Kamery umieszczono na pozycjach:

$ (3,1), (3,5) $

Pierwsza kamera monitoruje kontenery $(1,1)$, $(3,3)$ oraz $(5,1)$.

Druga kamera monitoruje kontenery $(1,5)$, $(3,3)$ oraz $(5,5)$.

Obie kamery obserwują środkowy kontener, a wszystkie pozostałe są monitorowane przez jedną z nich.

=== Porównanie wyników

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center,
    inset: 10pt,
    table.header(
      [*Parametr*],
      [*$k = 1$*],
      [*$k = 2$*],
    ),
    [Liczba kontenerów], [5], [5],
    [Liczba kamer], [5], [2],
    // [Monitorowane kontenery], [5], [5],
  )
]

Zwiększenie zasięgu obserwacji z $k = 1$ do $k = 2$ pozwoliło zmniejszyć liczbę wymaganych kamer z 5 do 2.

=== Wnioski

Dla zasięgu $k = 1$ konieczne jest zastosowanie 5 kamer, ponieważ każda z nich może monitorować tylko jeden kontener.

Zwiększenie zasięgu do $k = 2$ umożliwia jednoczesną obserwację kilku kontenerów przez jedną kamerę, dzięki czemu minimalna wymagana liczba kamer spada do 2.

W obu przypadkach wszystkie kontenery są monitorowane, a żadna kamera nie znajduje się na zajętym kwadracie.

Otrzymane rozwiązania są optymalne. Dla $k = 1$ konieczna jest osobna kamera dla każdego kontenera, natomiast dla $k = 2$ jedna kamera nie może monitorować jednocześnie wszystkich pięciu kontenerów.

Wyniki pokazują, że zwiększenie zasięgu obserwacji może znacząco zmniejszyć liczbę kamer potrzebnych do monitorowania terenu.
