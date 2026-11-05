#show figure.caption: strong
#set text(lang: "pl")

= Zadanie 1.

== Wstęp

W tym zadaniu należało przeprowadzić symulacje modelu urn i kul, a następnie na jej podstawie wyznaczyć maksymalne zapełnienie pojedynczej urny w zależności od sposobu losowania urny.

== Wyniki

#align(center)[
  // #figure(
  //   image("zad1/Figures/Figure_1.png"),
  //   caption: [$l_n^(\(1\)) dot (ln ln n)/(ln n)$],
  // )
  //
  // #figure(
  //   image("zad1/Figures/Figure_2.png"),
  //   caption: [$l_n^(\(2\)) dot (ln 2)/(ln ln n)$],
  // )

  #grid(
    columns: (auto, auto),
    grid.cell(
      figure(
        image("zad1/Figures/Figure_1.png"),
        caption: [$l_n^(\(1\)) dot (ln ln n)/(ln n)$],
      )
    ),
    grid.cell(
      figure(
        image("zad1/Figures/Figure_2.png"),
        caption: [$L_n^(\(1\))$],
      )
    )
  )
  #grid(
    columns: (auto, auto),
    grid.cell(
      figure(
        image("zad1/Figures/Figure_3.png"),
        caption: [$l_n^(\(2\)) dot (ln 2)/(ln ln n)$],
      )
    ),
    grid.cell(
      figure(
        image("zad1/Figures/Figure_4.png"),
        caption: [$L_n^(\(2\))$],
      )
    )
  )
]

$L_n^(\(d\))$ oznacza maksymalne zapełnienie pojedynczej urny po wrzuceniu $n$-kul, losując za każdym razem $d$-urn i wybierając najmniej zapełnioną z nich. Dla $d = 1$ widać, że rozrzut wyników nie jest bardzo duży, natomiast ewidentnie większe odchylenia są w górę niż w dół. Wartość średnia rośnie bardzo powoli i nie ma żadnych bardzo znaczących odchyleń. Dla $d = 2$ rozrzut wyników jest jeszcze bardziej skondensowany i ogranicza się zaledwie do dwóch prostych na wykresie, tj. wszystkie $L_n^(\(2\)) in {3,4}$. Co więcej wartości te są znacznie niższe niż w przypadku $d = 1$. Średnia zachowuje się podobnie co w poprzednim przypadku, a nawet znacząco się wypłaszcza pod koniec.

== Wnioski

Z wyników eksperymentu widać, że zwiększenie ilości losowanych urn dla jednej kuli nawet zaledwie do dwóch znacząco poprawia równomierność rozkładu kul. Rozrzut wyników przy $d = 1$ ciągnie w górę, ponieważ bardziej prawdopodobne jest pojawienie się skupisk kul niż równomierne rozłożenie się ich we wszystkich urnach. W kwestii asymptotyki, widać, że $l_n^(\(1\)) ~ (ln n)/(ln ln n)$, a $l_n^(\(2\)) ~ (ln ln n)$. Wykresy ich ilorazów są bardzo skupione.

#pagebreak()
= Zadanie 2.

== Wstęp

W tym zadaniu należało eksperymentalnie wyznaczyć liczbę porównań i przestawień kluczy w Insertion Sort.

== Wyniki

#align(center)[
  #figure(
    image("zad2/Figures/Figure_1.png"),
    caption: [$"cmp"(n)$],
  )

  #grid(
    columns: (auto, auto),
    grid.cell(
      figure(
        image("zad2/Figures/Figure_3.png"),
        caption: [$"cmp"(n)/n$],
      )
    ),
    grid.cell(
      figure(
        image("zad2/Figures/Figure_4.png"),
        caption: [$"cmp"(n)/n^2$],
      )
    )
  )

  #figure(
    image("zad2/Figures/Figure_2.png"),
    caption: [$s(n)$],
  )

  #grid(
    columns: (auto, auto),
    grid.cell(
      figure(
        image("zad2/Figures/Figure_5.png"),
        caption: [$s(n)/n$],
      )
    ),
    grid.cell(
      figure(
        image("zad2/Figures/Figure_6.png"),
        caption: [$s(n)/n^2$],
      )
    )
  )
]

$"cmp"(n)$ i $s(n)$ to odpowiednio liczba porównań i przestawień kluczy w algorytmie sortującym Insertion Sort. Na wykresach widać, że są to wielkości bardzo bliskie sobie, niemal identyczne. Dopiero po ręcznej analizie danych widać, że ich różnica jest rzędu wielkości 10, przy czym to zawsze $s(n)$ jest większe. Rozrzut wartości wokół średnich jest bardzo niewielki, sięgający kliku procent.

== Wnioski

Z wyników eksperymentu widać, że zarówno $"cmp"(n)$, jak i $s(n)$ mają asymptotykę kwadratową, ze stałą dążącą do $1/4$. Co więcej po małym rozrzucie wyników widać, że algorytm Insertion Sort jest mało wrażliwy na dane wejściowe.

#pagebreak()
= Zadanie 3.

== Wstęp

W tym zadaniu należało przeprowadzić symulacje modelu komunikacji w sieci o topologii gwiazdy z zakłóceniami.

== Wyniki

#align(center)[
  #grid(
    columns: (auto, auto),
    grid.cell(
      figure(
        image("zad3/Figures/Figure_1.png"),
        caption: [$(T_n)/(ln n)$],
      )
    ),
    grid.cell(
      figure(
        image("zad3/Figures/Figure_2.png"),
        caption: [$T_n$],
      )
    )
  )
]

$T_n$ to minimalna liczba rund potrzebna by do każdego z węzłów dotarła informacja zakładając, że prawdopodobieństwo dotarcia komunikatu wynosi $p$. Rozrzut jest przesunięty w górę i odbiega stosunkowo daleko od średniej. Ze względu na swoją dyskretną naturę wykres wygląda schodkowo, natomiast wykres średniej układa się w krzywą logarytmiczną. Wykres $T_n/(ln n)$ jest bardzo stały z magnitudą maksymalną ok. 0.12 i oscyluje wokół 1.5.

== Wnioski

Asymptotyka $T_n$ jest logarytmiczna. Oznacza to, że nawet dodając dużą liczbę nowych węzłów liczba $T_n$ nie wzrasta zbyt znacznie, a więc sieć jest wysoce skalowalna. Przesunięcie rozrzutu w górę sugeruje, że istnieją długie ogony przypadków pesymistycznych, gdzie faktyczna liczba $T_n$ ucieknie daleko od średniej.
