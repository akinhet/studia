= Sprawozdanie

== Wstęp
W tym sprawozadaniu przedstawię wyniki eksprerymentu polegającego na obliczaniu całek wybranych funkcji metodą Monte Carlo uwzględniając różne ilości powtórzeń.

== Metodologia
Aby skutecznie obliczyć pola całek zastosowałem metodę Monte Carlo. Każda próba polegająca na wylosowaniu $n in {50, 100...5000}$ punktów została powtórzona
$k in {5, 50}$ razy a wyniki uśrednione.

== Wyniki
Po zamieszczonych niżej wykresach widać, że zwiększając ilość losowanych punktów dokładność przybliżeń zwiększa i stabilizuje się. Ponadto zwiększenie $k$ przyczynia się do znaczącej poprawy dokładności wyników, a wzięcie średniej z prób dla danego n stabilizuje przybliżenia.

#align(center)[
  #image("Figure1.png")

  *wyniki dla k = 5*
]

#align(center)[
  #image("Figure2.png")

  *wyniki dla k = 50*
]

== Wnioski
Zwiększanie ilości niezależnych prób losowych i obliczanie z nich średniej przyczynia się do znaczącej poprawy uzyskiwanych wyników, jednak jest to również obliczeniowo kosztowne. Lepsze rezultaty uzyskamy zwiększając ilość prób niezależnych niż ilość punktów losowanych w każdej próbie, a obliczanie średniej z wielu prób pozwala uniknąć znaczących odchyleń od oczekiwanego wyniku. Nie mniej średnie i tak są podatne na ekstremalne odchyły pojedynczych punktów, także warto się zastanowić czy nie lepiej byłoby brać na przykład medianę zamiast średniej.
