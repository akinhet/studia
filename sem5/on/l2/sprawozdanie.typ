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

= Zadanie 2.

== Wnioski

1. **Dla macierzy Hilberta** wskaźnik uwarunkowania bardzo szybko rośnie wraz z rozmiarem macierzy, co prowadzi do znacznej utraty dokładności obliczeń. Wynika to z coraz większej liniowej zależności między wierszami macierzy, przez co nawet niewielkie błędy zaokrągleń mogą znacząco wpłynąć na rozwiązanie układu.

2. **Dla macierzy losowych** zaobserwowano wzrost błędów względnych wraz ze wzrostem zadanego wskaźnika uwarunkowania. W przypadku wartości rzędu \(10^{16}\) otrzymane rozwiązania są obarczone dużymi błędami, ponieważ uwarunkowanie jest porównywalne z odwrotnością precyzji maszynowej `Float64`.

3. **Algorytm eliminacji Gaussa (`A \ b`)** na ogół zapewnia dokładniejsze wyniki niż metoda wykorzystująca jawną macierz odwrotną (`inv(A) * b`). Wynika to z faktu, że eliminacja Gaussa rozwiązuje układ bezpośrednio, natomiast druga metoda wymaga obliczenia przybliżonej macierzy odwrotnej i dodatkowego mnożenia przez wektor \(b\), co wprowadza kolejne błędy zaokrągleń. Różnica jest szczególnie widoczna dla źle uwarunkowanych macierzy.

4. **Dla bardzo źle uwarunkowanych macierzy** funkcja `rank(A)` może zwracać rząd mniejszy od rzeczywistego ze względu na ograniczoną precyzję arytmetyki zmiennoprzecinkowej. Dzieje się tak, ponieważ najmniejsze wartości osobliwe macierzy spadają poniżej przyjętej tolerancji numerycznej i są traktowane jako zero, mimo że matematycznie macierz pozostaje odwracalna.

5. **Wskaźnik uwarunkowania** nie określa dokładnej wartości błędu rozwiązania, lecz jego wrażliwość na zaburzenia danych. Dlatego błędy numeryczne nie muszą rosnąć monotonicznie wraz ze wskaźnikiem uwarunkowania, ponieważ ich rzeczywista wielkość zależy także od charakteru i kierunku zaburzeń oraz błędów zaokrągleń powstających podczas obliczeń.

= Zadanie 4.

== Wnioski

1. **Wielomian Wilkinsona jest przykładem zadania źle uwarunkowanego.** Pomimo że jego dokładne pierwiastki są liczbami całkowitymi od 1 do 20, obliczone numerycznie pierwiastki wykazują zauważalne odchylenia, szczególnie w środkowej części przedziału. Wynika to z dużej wrażliwości pierwiastków na niewielkie zaburzenia współczynników wielomianu.

2. **Wartości wielomianu obliczane w postaci naturalnej i iloczynowej różnią się ze względu na błędy zaokrągleń.** W postaci naturalnej występuje odejmowanie dużych składników o przeciwnych znakach, co prowadzi do utraty cyfr znaczących. W przeprowadzonym eksperymencie wartości obu postaci były jednak podobnego rzędu wielkości, więc nie zaobserwowano jednoznacznej przewagi postaci iloczynowej.

3. **Niewielka zmiana współczynnika przy \(x^{19}\) spowodowała znaczące przesunięcia pierwiastków oraz pojawienie się pierwiastków zespolonych.** Przykładowo otrzymano parę \(16.730745\pm2.812625i\), co jest zgodne z eksperymentem Wilkinsona opisanym w literaturze. Pokazuje to, że nawet bardzo mała względna zmiana współczynnika może istotnie zmienić rozwiązanie.

4. **Dokładność wyznaczanych pierwiastków zależy zarówno od uwarunkowania zadania, jak i zastosowanej arytmetyki numerycznej.** Ponieważ obliczenia wykonywane są w ograniczonej precyzji `Float64`, błędy zaokrągleń współczynników oraz wykonywanych operacji mogą wpływać na otrzymywane pierwiastki. Nawet stabilny numerycznie algorytm nie jest w stanie całkowicie wyeliminować skutków złego uwarunkowania zadania.

= Zadanie 5.

== Wnioski

1. **Model logistyczny dla \(r=3\) wykazuje dużą wrażliwość na niewielkie zaburzenia wartości początkowych i błędy obliczeniowe.** Obcięcie wyniku po dziesiątej iteracji do trzech miejsc po przecinku powoduje początkowo niewielką zmianę, która w kolejnych iteracjach narasta, prowadząc do znaczących różnic między otrzymanymi wartościami.

2. **Obliczenia wykonane w arytmetyce `Float32` i `Float64` dają różne wyniki pomimo identycznych parametrów początkowych.** Wynika to z różnej precyzji reprezentacji liczb i powstających błędów zaokrągleń, które są wzmacniane podczas kolejnych iteracji równania rekurencyjnego.

3. **Eksperyment pokazuje ograniczenia numerycznego przewidywania zachowania układów chaotycznych.** Nawet bardzo małe błędy mogą z czasem prowadzić do znacznych rozbieżności, dlatego zwiększenie precyzji obliczeń poprawia wiarygodność wyników jedynie w ograniczonym zakresie iteracji.

= Zadanie 6.

== Wnioski

1. **Dla \(c=-2\) zaobserwowano dużą wrażliwość ciągu na warunki początkowe.** W przypadku \(x_0=2\) ciąg pozostaje stały, natomiast zmiana wartości początkowej na \(1.99999999999999\) prowadzi do nieregularnych oscylacji. Wynika to z niestabilności punktu stałego \(x=2\), w którego otoczeniu niewielkie zaburzenia są wzmacniane w kolejnych iteracjach.

2. **Dla \(c=-1\) wszystkie badane ciągi osiągają lub zbliżają się do stabilnego cyklu dwuelementowego \(0,-1\).** Pomimo różnych wartości początkowych ich długoterminowe zachowanie jest podobne, choć mogą różnić się fazą cyklu. Wynika to z przyciągającego charakteru tego cyklu okresowego.

3. **Wyznaczone punkty stałe są niestabilne dla obu badanych wartości parametru \(c\).** Nie oznacza to jednak, że każdy ciąg musi się od nich oddalać — przy dokładnym trafieniu w punkt stały iteracje mogą pozostawać w nim bez końca, co zaobserwowano dla \(c=-2\) i \(x_0=2\).

4. **Eksperyment pokazuje istotną rolę warunków początkowych i stabilności w obliczeniach iteracyjnych.** Dla układów niestabilnych nawet bardzo małe zaburzenia mogą znacząco zmienić wyniki, podczas gdy układy posiadające stabilne cykle mogą tłumić takie zaburzenia i wykazywać przewidywalne zachowanie.
