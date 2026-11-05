#show figure.caption: strong
#set text(lang: "pl")

= Sprawozdanie

== Wstęp
W tym sprawozadaniu przedstawię wyniki eksperymentu badającego wybrane cechy modelu kul i urn.

== Wyniki

#align(center)[
  #figure(
    image("figures/Figure_1.png"),
    caption: [$B_n$ - moment pierwszej kolizji],
  )

  #grid(
    columns: (auto, auto),
    grid.cell(
      figure(
        image("figures/Figure_6.png"),
        caption: [ $B_n/n$ ]
      )
    ),
    grid.cell(
      figure(
        image("figures/Figure_7.png"),
        caption: [ $B_n/sqrt(n)$ ]
      )
    )
  )
]

$B_n$ to moment pierwszego rzutu, w którym wrzucamy kulę do niepustej urny. Na powyższych wykresach widać, że uśredniona wartość $B_n$ ma asymptotykę zbliżoną do $sqrt(n)$, zwłaszcza wyraźne jest to na wykresie 3., gdzie funkcja zamyka się w wąskim przedziale. Widać również, że wraz ze zwiększaniem $n$ wyniki pojedynczych powtórzeń coraz bardziej odbiegają od średniej, jednak rozstrzał jest proporcjonalny do wartości utrzymując się w miarę w przedziale $(0, 2B_n)$, z pojedynczymi wyjątkami.

#pagebreak()
#align(center)[
  #figure(
    image("figures/Figure_2.png"),
    caption: [$U_n$ - liczba pustych urn po wrzuceniu $n$ kul],
  )

  #grid(
    columns: (auto, auto),
    grid.cell(
      figure(
        image("figures/Figure_8.png"),
        caption: [ $U_n/n$ ]
      )
    ),
  )
]

$U_n$ to liczba pustych urn po wrzuceniu $n$ kul. Na powyższych wykresach widać, że $U_n$ rośnie liniowo z nachyleniem bliskim $0.36$. Rozrzut wyników pojedynczych prób jest znikomy i nie zależy od $n$.

#pagebreak()
#align(center)[
  #figure(
    image("figures/Figure_3.png"),
    caption: [$C_n$ - moment, w którym w każdej urnie jest conajmniej 1 kula],
  )

  #grid(
    columns: (auto, auto, auto),
    grid.cell(
      figure(
        image("figures/Figure_9.png"),
        caption: [ $C_n/n$ ]
      )
    ),
    grid.cell(
      figure(
        image("figures/Figure_10.png"),
        caption: [ $C_n/(n ln n)$ ]
      )
    ),
    grid.cell(
      figure(
        image("figures/Figure_11.png"),
        caption: [ $C_n/n^2$ ]
      )
    ),
  )
]

$C_n$ to liczba rzutów potrzebna, by każda urna była niepusta. Na powyższych wykresach, a zwłaszcza na wykresie 9. widać, że $C_n$ jest asymptotyczne z $n ln n$. Rozrzut wyników rośnie wraz z $n$, jednak mieści się z grubsza w granicach $plus.minus 20%$.

#pagebreak()
#align(center)[
  #figure(
    image("figures/Figure_4.png"),
    caption: [$D_n$ - moment, w którym w każdej urnie są conajmniej 2 kule],
  )

  #grid(
    columns: (auto, auto, auto),
    grid.cell(
      figure(
        image("figures/Figure_12.png"),
        caption: [ $D_n/n$ ]
      )
    ),
    grid.cell(
      figure(
        image("figures/Figure_13.png"),
        caption: [ $D_n/(n ln n)$ ]
      )
    ),
    grid.cell(
      figure(
        image("figures/Figure_14.png"),
        caption: [ $D_n/n^2$ ]
      )
    ),
  )
]

$D_n$ to liczba rzutów potrzebna, by w każdej urnie znajdowały się conajmniej 2 kule. Jest to liczba siostrzana do $C_n$, dlatego jej asymptotyka, jak i rozrzut wyników są bardzo zbliżone i również wynoszą $n ln n$ i $plus.minus 20%$. Widać jednak na rysunku 12., że asymptotyka $D_n$ jest nieco większa niż $n ln n$, ponieważ wykres nachyla się w prawo.

#pagebreak()
#align(center)[
  #figure(
    image("figures/Figure_5.png"),
    caption: [$D_n - C_n$ - liczba rzutów między $C_n$ a $D_n$],
  )

  #grid(
    columns: (auto, auto, auto),
    grid.cell(
      figure(
        image("figures/Figure_15.png"),
        caption: [ $(D_n - C_n)/n$ ]
      )
    ),
    grid.cell(
      figure(
        image("figures/Figure_16.png"),
        caption: [ $(D_n - C_n)/(n ln n)$ ]
      )
    ),
    grid.cell(
      figure(
        image("figures/Figure_17.png"),
        caption: [ $(D_n - C_n)/(n ln ln n)$ ]
      )
    ),
  )
]

$D_n - C_n$ to różnica rzutów między $C_n$ i $D_n$. Ze względu na bardzo zbliżoną asymptotykę tych liczb, ich różnica nie rośnie zbyt szybko i na pierwszy rzut oka wydawałoby się, że z tempem $alpha n$, jednak analizując wykresy 15-17 widać, że faktyczną asymptotyką $D_n - C_n$ jest $n ln ln n$. Pomyłka ta wynika z faktu, że $ln ln n$ ma bardzo powolne tempo wzrostu, dlatego jest trudne do odróżnienia od $n$ czy $n ln n$. Rozrzut $D_n - C_n$ jest bardzo duży, podobnej skali co $B_n$, i podobnie jak w $B_n$ rośnie wraz ze wzrostem $n$.

#pagebreak()
== Wyjaśnienie nazewnictwa

Kilka sposród tych liczb ma swoje specjalne nazwy. Postaram się je tutaj wytłumaczyć.

1. *$B_n$ - Paradoks urodzinowy* \
   Liczbę $B_n$ możemy skorelować z tak zwanym paradoksem urodzinowym. Jest to paradoks zadający pytanie ile osób należy zgromadzić, żeby prawdopodobieństwo, że 2 z nich mają urodziny tego samego dnia wynosiło $1/2$. Jak się okazuje odpowiedź na to pytanie wynosi zaledwie 23. Liczba $B_n$ jest niczym innym jak odpowiedzią na pytanie ile średnio potrzeba losowych liczb z zakresu $n$, aby dwie z nich było sobie równe. Jest to więc odpowiedź na paradoks urodzinowy uogólniony na $n$.

2. *$C_n$ - Problem kolekcjonera kuponów* \
   Problem kolekcjonera kuponów to matematyczne uogólnienie konkursów, w których aby wygrać nagrodę, należy zebrać ileś unikalnych kuponów. Pyta ono po ilu zebranych kuponach powinniśmy się spodziewać, że wygraliśmy nagrodę (tj. zebraliśmy $n$ różnych kuponów). Liczba $C_n$ jest właśnie odpowiedzią na to pytanie.

== Wnioski

Przeprowadzone eksperymenty potwierdzają znane własności modelu kul i urn oraz pozwalają empirycznie ocenić tempo wzrostu badanych wielkości:

1. *Moment pierwszej kolizji $B_n$* \
   Eksperymenty wskazują, że $B_n$ rośnie jak $sqrt(n)$. Rozrzut pojedynczych prób zwiększa się wraz z $n$, ale pozostaje proporcjonalny do wartości, co jest zgodne z losowym charakterem pierwszej kolizji.

2. *Liczba pustych urn $U_n$* \
   Wielkość $U_n$ rośnie liniowo z nachyleniem około $0.36$, a zmienność pomiędzy próbami jest bardzo mała i praktycznie niezależna od $n$.

3. *Czas zapełnienia wszystkich urn $C_n$* \
   Wyniki wskazują, że $C_n$ ma asymptotykę $n ln n$. Rozrzut wartości rośnie wraz z $n$, lecz względnie pozostaje w granicach około $plus.minus 20%$.

4. *Czas umieszczenia dwóch kul w każdej urnie $D_n$* \
   Asymptotyka $D_n$ jest taka sama jak w przypadku $C_n$, również $n ln n$, z podobnym poziomem rozrzutu.

5. *Różnica $D_n - C_n$* \
   Mimo bardzo zbliżonej asymptotyki $C_n$ i $D_n$, ich różnica rośnie znacznie wolniej. Analiza wykresów pokazuje, że
   $ D_n - C_n tilde n ln ln n $
   Bardzo wolny wzrost funkcji $ln ln n$ powoduje pozorne podobieństwo do funkcji liniowej, co zostało wyjaśnione poprzez porównanie skalowania na wykresach.

Całość eksperymentu pokazuje, że różne zjawiska w tym samym modelu mogą charakteryzować się odmiennymi asymptotykami oraz jak ostrożnie należy interpretować wyniki przy funkcjach o bardzo wolnym tempie wzrostu.

#pagebreak()
== Znaczenie $B_n$ w kontekście funkcji hashujących i kryptograficznych

Funkcję hashujące borykają się z problemem kolizji, tj. sytuacji, w której dwa różne wejścia generują takie same wyjście. Jest to problematyczne, ponieważ funkcje hashujące są często stosowane do określania integralności danych. W przypadku kolizji hacker może podmienić dane na zupełnie inne mimo, że hash będzie taki sam, tym samym naruszając integralność całego systemu. Paradoks urodzinowy mówi nam o tym, że dla hashu produkującego hashe długości $n$ bitów kolizję mozna znaleźć w około zbiorze $2^(n/2)$ hashy. Z tego powodu hashe powinny być projektowane z odpowiednio dużym wyjściem, tak by unikać kolizji. Dla kryptograficznych funkcji hashujących uznaje się, że wystarczającą liczbą operacji potrzebnych do wykrycia kolizji jest $2^128$, a więc hashe powinny być conajmniej 256 bitowe.
