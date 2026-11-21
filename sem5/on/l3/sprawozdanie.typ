#set page(paper: "a4", margin: (top: 17mm, bottom: 18mm, left: 19mm, right: 19mm), numbering: "1")
// #set text(font: "Noto Serif", size: 9.7pt, lang: "pl")
#set par(justify: true, leading: 0.45em)
#set heading(numbering: none)
#set figure(numbering: none)

#align(center)[
  #text(size: 16pt, weight: "bold")[Metody wyznaczania miejsc zerowych]
  #v(3pt)
  #text(size: 10pt)[Sprawozdanie z zadań 2–6]
]
#v(5pt)

Obliczenia wykonano w języku Julia, głównie w arytmetyce `Float64`. W tabelach $r$ oznacza znalezione przybliżenie pierwiastka, `it` liczbę iteracji, a `err` kod zakończenia programu. Błąd bezwzględny liczono względem znanego pierwiastka.

= Zadanie 2 — równanie $sin x - (x/2)^2 = 0$

== Wyniki

Przyjęto $delta=epsilon=5 dot 10^(-6)$ oraz dokładniejszą wartość pierwiastka $r_*=1.9337537628270213$. Bisekcję uruchomiono na $[1.5,2]$, Newtona od $x_0=1.5$, a sieczne od $x_0=1$, $x_1=2$.

#table(
  columns: (1.1fr, 1.55fr, 1.45fr, 0.6fr, 1.15fr),
  inset: (x: 4pt, y: 3pt),
  stroke: 0.4pt + luma(180),
  [*Metoda*], [*$r$*], [*$f(r)$*], [*`it`*], [*$|r-r_*|$*],
  [Bisekcja], [1.933753967285156], [-2.702768e-7], [16], [2.044581e-7],
  [Newton], [1.933753779789742], [-2.242332e-8], [4], [1.696272e-8],
  [Sieczne], [1.933753644474301], [1.564525e-7], [4], [1.183527e-7],
)

We wszystkich trzech przypadkach `err = 0`.

== Obserwacje

Newton i sieczne wymagały po 4 iteracje, a bisekcja 16. Najmniejszy błąd bezwzględny uzyskał Newton ($1.70 dot 10^(-8)$). Wszystkie trzy metody spełniły warunek zakończenia, ale uzyskały różne wartości $|f(r)|$ i $|r-r_*|$.

== Wnioski

- *Gwarancja zbieżności a szybkość:*
  Bisekcja jest metodą o przewidywalnym zachowaniu: przy ciągłości funkcji i zmianie znaku na końcach przedziału zachowuje przedział z pierwiastkiem. Newton i sieczne mogą być znacznie szybsze, lecz ich zbieżność zależy od własności funkcji i odpowiednio dobranych punktów początkowych.

- *Koszt pojedynczej iteracji:*
  Mniejsza liczba iteracji nie musi oznaczać krótszego czasu obliczeń. Newton wymaga obliczania pochodnej, sieczne przechowują wartości funkcji z poprzednich kroków, a bisekcja korzysta z prostych operacji i oceny znaku. Wybór metody powinien uwzględniać koszt obliczenia funkcji oraz jej pochodnej.

- *Kryterium stopu a dokładność:*
  Spełnienie tolerancji dla wartości funkcji lub zmiany argumentu nie jest równoznaczne z jednakowym błędem pierwiastka. Związek między małym residuum a błędem zależy między innymi od nachylenia funkcji w pobliżu miejsca zerowego. Przy ocenie wyniku warto rozróżniać te dwie wielkości.

= Zadanie 3 — przecięcia $y=3x$ i $y=e^x$

== Wyniki

Rozwiązano $f(x)=3x-e^x=0$, z pochodną $f'(x)=3-e^x$, dla $delta=epsilon=10^(-4)$. Dla bisekcji wybrano przedziały $[0.5,1]$ i $[1,2]$, a dla Newtona punkty $0.5$ i $2$.

#table(
  columns: (1.2fr, 0.5fr, 1.65fr, 1.4fr, 0.6fr),
  inset: (x: 4pt, y: 3pt),
  stroke: 0.4pt + luma(180),
  [*Metoda*], [*Nr*], [*$r$*], [*$f(r)$*], [*`it`*],
  [Bisekcja], [1], [0.6191406250], [9.066320e-5], [8],
  [Bisekcja], [2], [1.5120849609], [7.618579e-5], [13],
  [Newton], [1], [0.6189967797], [-7.372350e-5], [2],
  [Newton], [2], [1.5121372501], [-4.145953e-6], [4],
)

Wszystkie wywołania zwróciły `err = 0`. Przybliżone współrzędne punktów przecięcia to:

$ P_1 approx (0.6190613; 1.8571839), quad P_2 approx (1.5121346; 4.5364037). $

#figure(
  image("wykresy/zad3.svg", width: 90%),
  caption: [Rys. 1. Dwa punkty przecięcia prostej $y=3x$ i krzywej $y=e^x$.],
)

== Obserwacje

Dla pierwszego pierwiastka Newton wykonał 2 iteracje zamiast 8, a dla drugiego 4 zamiast 13. Przy obu punktach otrzymano wartości $|f(r)| < 10^(-4)$. W celu znalezienia obu rozwiązań konieczne było zastosowanie różnych przedziałów lub punktów startowych. Na wykresie prosta przecina krzywą wykładniczą dwukrotnie: między tymi punktami $3x > e^x$, a poza nimi $3x < e^x$.

== Wnioski

- *Lokalizacja wszystkich rozwiązań:*
  Metody iteracyjne zwykle wyznaczają jeden pierwiastek w danym uruchomieniu. Jeżeli funkcja ma kilka miejsc zerowych, konieczne jest wcześniejsze rozpoznanie jej przebiegu i dobranie osobnych przedziałów lub punktów startowych. Samo znalezienie jednego rozwiązania nie wyklucza istnienia innych; analiza wykresu lub monotoniczności pomaga zidentyfikować odrębne obszary poszukiwań.

- *Znaczenie punktu początkowego:*
  Metoda Newtona jest lokalna, a jej krok zależy od odwrotności pochodnej. W pobliżu punktów o małej pochodnej nawet niezbyt duża wartość funkcji może powodować bardzo duży krok. Wstępne ograniczenie obszaru poszukiwania zmniejsza ryzyko przejścia do innego pierwiastka.

- *Łączenie metod:*
  Bisekcja i Newton dostarczają różnych rodzajów kontroli: pierwsza utrzymuje pierwiastek w znanym przedziale, drugi pozwala szybko poprawiać przybliżenie w jego otoczeniu. W praktyce użyteczne jest najpierw wyznaczenie bezpiecznego przedziału, a dopiero potem zastosowanie szybszej metody lokalnej.

#pagebreak()
= Zadanie 4 — funkcje $f_1$ i $f_2$

Rozpatrzono $f_1(x)=e^(1-x)-1$ (pierwiastek $r=1$) i $f_2(x)=x e^(-x)$ (pierwiastek $r=0$), przy $delta=epsilon=10^(-5)$.

== Wyniki

#table(
  columns: (0.55fr, 1.05fr, 1.5fr, 0.55fr, 1.1fr),
  inset: (x: 4pt, y: 3pt),
  stroke: 0.4pt + luma(180),
  [*Funkcja*], [*Metoda*], [*$r$*], [*`it`*], [*Błąd*],
  [$f_1$], [Newton], [0.9999999999], [4], [1.121648e-10],
  [$f_1$], [Sieczne], [1.0000017597], [6], [1.759713e-6],
  [$f_2$], [Newton], [-0.0000003064], [5], [3.064249e-7],
  [$f_2$], [Sieczne], [0.0000021762], [6], [2.176192e-6],
)

Punkty startowe: dla $f_1$ Newton $x_0=0.5$, sieczne $(0,2)$; dla $f_2$ Newton $x_0=0.5$, sieczne $(-0.5,0.5)$. Wszystkie wyniki z tej tabeli mają `err = 0`.

*Podpunkt a — Newton dla $f_1$, $x_0>1$.*

#table(
  columns: (0.65fr, 0.65fr, 1.6fr),
  inset: (x: 5pt, y: 2.5pt),
  stroke: 0.4pt + luma(180),
  [*$x_0$*], [*`it`*], [*$|r-1|$*],
  [1.1], [3], [8.905998e-11],
  [1.5], [4], [1.526378e-9],
  [2.0], [5], [1.899390e-8],
  [3.0], [9], [2.892168e-8],
  [4.0], [21], [4.721766e-10],
  [5.0], [54], [3.572904e-7],
)

#figure(
  image("wykresy/zad4a.svg", width: 90%),
  caption: [Rys. 2. Styczne Newtona dla $f_1(x)$, start $x_0=3$. Styczna w punkcie startowym prowadzi do $x_1 approx -3.389$.],
)

#pagebreak()
*Podpunkt b — Newton dla $f_2$, $x_0 >= 1$.*

#table(
  columns: (0.65fr, 0.65fr, 1.6fr, 0.55fr),
  inset: (x: 5pt, y: 2.5pt),
  stroke: 0.4pt + luma(180),
  [*$x_0$*], [*`it`*], [*$r$*], [*`err`*],
  [1.0], [0], [1.0000000000], [2],
  [1.1], [3], [14.2721239383], [0],
  [1.5], [10], [14.7874368028], [0],
  [2.0], [10], [14.3986627657], [0],
  [3.0], [10], [14.7874368028], [0],
)

#figure(
  image("wykresy/zad4b.svg", width: 90%),
  caption: [Rys. 3. Funkcja $f_2(x)$ i styczne Newtona dla $x_0=2$; kolejne przybliżenia przesuwają się w prawo.],
)

== Obserwacje

Dla $f_1$ wzór Newtona to $x_(n+1)=x_n+1-e^(x_n-1)$. Gdy $x_n>1$, następne przybliżenie spada poniżej 1; dla $x_0=5$ pierwszy krok daje $x_1=6-e^4 approx -48.6$, co tłumaczy aż 54 iteracje. Na rys. 2 widać analogiczny mechanizm dla $x_0=3$: pierwsza styczna przecina oś daleko na lewo od pierwiastka, a przy dużych ujemnych argumentach kolejne kroki mają długość zbliżoną do 1. W przypadku $f_2$ nie wolno wybrać $x_0=1$, ponieważ $f_2'(1)=0$. Dla $x_0>1$ wzór Newtona ma postać

$ x_(n+1) = x_n^2/(x_n-1) > x_n, $

a więc przybliżenia rosną zamiast dążyć do zera. Rys. 3 pokazuje maksimum w $x=1$ (styczna pozioma) oraz wypłaszczanie funkcji po jego prawej stronie; styczne kierują kolejne punkty na prawo. Pomimo tego program zgłasza `err = 0`, ponieważ $x e^(-x) -> 0$ dla $x -> +infinity$.

== Wnioski

- *Lokalny, a nie globalny charakter Newtona:*
  Zbieżność metody Newtona można zagwarantować jedynie przy określonych założeniach i odpowiednio bliskim punkcie startowym. Daleki punkt początkowy może prowadzić do gwałtownego skoku, długiego powrotu w okolice pierwiastka albo do rozbieżności, mimo że sam pierwiastek istnieje. Styczna jest przybliżeniem lokalnym, dlatego jej przecięcie z osią może być bardzo odległe od rzeczywistego miejsca zerowego.

- *Rola pochodnej:*
  Zerowa pochodna uniemożliwia obliczenie kroku klasycznego Newtona, a bardzo mała pochodna może wywołać niestabilnie duże przemieszczenie. Dlatego badanie pochodnej i kontrola rozmiaru kroku są ważne dla odporności algorytmu; samo sprawdzenie, czy pochodna nie jest dokładnie zerem, bywa niewystarczające.

- *Residuum nie jest błędem pierwiastka:*
  Funkcja może przyjmować wartości bliskie zeru również daleko od swojego miejsca zerowego. Warunek oparty wyłącznie na małej wartości funkcji może więc błędnie sygnalizować sukces, gdy argument w rzeczywistości oddala się od rozwiązania. Należy odróżniać małe residuum od małego błędu argumentu; szczególnie niebezpieczne są funkcje, które zbliżają się do zera asymptotycznie bez jego osiągania.

- *Zabezpieczanie algorytmów:*
  W praktycznych implementacjach warto kontrolować rozmiar kroku, opuszczenie dopuszczalnego obszaru i brak postępu oraz stosować dodatkowe warunki zakończenia. Jeśli dostępny jest przedział ze zmianą znaku, metodę Newtona można zabezpieczyć, przechodząc w trudnych sytuacjach do bisekcji.

= Zadanie 5 — dokładność i rząd zbieżności

== Wyniki — podpunkt a

Dla $f(x)=x-10^8-pi$ zastosowano bisekcję na $[99\,999\,999,100\,000\,005]$, z $delta=epsilon=10^(-13)$ i `maxit = 100`. Rzeczywiste rozwiązanie to $r_*=10^8+pi$; do oceny błędu użyto `BigFloat`.

#table(
  columns: (1.45fr, 1.8fr),
  inset: (x: 5pt, y: 3pt),
  stroke: 0.4pt + luma(180),
  [*Wielkość*], [*Otrzymana wartość*],
  [$r$], [100000003.14159265],
  [$f(r)$], [-1.9841870369e-9],
  [Liczba iteracji / `err`], [100 / 1],
  [$|r-r_*|$ (`BigFloat`)], [1.9841871594e-9],
  [$delta$], [1e-13],
  [`eps(r)` dla `Float64`], [1.4901161194e-8],
)

== Obserwacje — podpunkt a

Błąd rzeczywisty $1.984 dot 10^(-9)$ jest większy od tolerancji $10^(-13)$. W otoczeniu $10^8$ odstęp sąsiednich liczb `Float64` wynosi około $1.49 dot 10^(-8)$. Po pewnym czasie obliczany środek przedziału zaokrągla się do jednego z końców i bisekcja nie może już zawężać przedziału.

== Wnioski — podpunkt a

- *Rozdzielczość arytmetyki zmiennoprzecinkowej:*
  Liczby typu `Float64` nie są rozmieszczone równomiernie na osi liczbowej: odstęp między sąsiednimi wartościami rośnie wraz z ich modułem. Żądana tolerancja bezwzględna może być zatem mniejsza od najmniejszej możliwej zmiany reprezentowanego argumentu.

- *Stagnacja numeryczna:*
  W arytmetyce skończonej precyzji kolejne dzielenie przedziału może przestać zmieniać jego końce. Dalsze iteracje nie zmniejszają wtedy błędu, niezależnie od limitu iteracji. Algorytm powinien wykrywać brak zmiany środka przedziału, zamiast bezcelowo powtarzać te same operacje.

- *Tolerancje i skala danych:*
  Bezwzględny próg dokładności należy odnosić do rzędu wielkości szukanego rozwiązania. Połączenie tolerancji bezwzględnej i względnej zwykle lepiej opisuje oczekiwania, ale nie pozwala przekroczyć fizycznej rozdzielczości użytego typu liczbowego.

- *Precyzja a sformułowanie zadania:*
  Wyższa precyzja, na przykład `BigFloat`, pozwala reprezentować gęściej położone wartości i kontynuować obliczenia. Przeskalowanie lub przesunięcie zmiennej może poprawić pośrednie obliczenia, lecz nie wystarczy, jeśli końcowy wynik musi być zapisany w `Float64` z dokładnością mniejszą niż odstęp sąsiednich liczb.

== Wyniki — podpunkt b

Dla równania z zadania 2 użyto $delta=epsilon=10^(-7)$, `maxit = 100` i $r_*=1.9337537628270213$. W tabeli przedstawiono ilorazy błędów $e_n=x_n-r_*$:

$ Q_B = frac(|e_(n+1)|, |e_n|), quad Q_N = frac(|e_(n+1)|, |e_n|^2), $
$ Q_S = frac(|e_(n+1)|, |e_n|^p), quad p=frac(1+sqrt(5), 2) approx 1.618034. $

Wiersz oznaczony $n$ odpowiada ilorazowi $frac(|e_n|, |e_(n-1)|^p)$ (z właściwym wykładnikiem dla danej metody). Kreska oznacza brak następnej iteracji. Dla siecznych wiersz $n=1$ porównuje dwa zadane punkty startowe.

#table(
  columns: (0.45fr, 1.1fr, 0.45fr, 1.1fr, 1.05fr, 1.05fr),
  inset: (x: 4pt, y: 2.5pt),
  stroke: 0.35pt + luma(185),
  [*$n$*], [*Bisekcja $Q_B$*], [*$n$*], [*Bisekcja $Q_B$*], [*Newton $Q_N$*], [*Sieczne $Q_S$*],
  [1], [0.3197418], [11], [0.4510104], [1.098312], [0.07401611],
  [2], [0.06376166], [12], [0.6086218], [0.4275251], [5.390438],
  [3], [7.341704], [13], [0.3215282], [0.5305632], [0.1916518],
  [4], [0.4318959], [14], [1.055073], [0.5425958], [1.574187],
  [5], [0.3423137], [15], [0.02609931], [—], [0.4105934],
  [6], [0.03935132], [16], [17.6576], [—], [0.9407739],
  [7], [11.20605], [17], [0.4716836], [—], [—],
  [8], [0.4553813], [18], [0.4399673], [—], [—],
  [9], [0.4020189], [19], [0.363552], [—], [—],
  [10], [0.2562775], [20], [0.1246808], [—], [—],
)

W kolumnach Newtona i siecznych indeks $n$ odczytuje się z pierwszej kolumny.

== Obserwacje — podpunkt b

W bisekcji ilorazy rzeczywistych błędów silnie oscylują (np. $7.34$ i $17.66$), choć długość przedziału zmniejsza się dwukrotnie w każdej iteracji. Dla Newtona $Q_N$ zbliża się do wartości $0.5426$. Dla siecznych ostatnie dwa ilorazy wynoszą $0.4106$ i $0.9408$ — nie widać jeszcze ustalonej granicy.

Teoretycznie, dla tego równania:

$ C_N = |frac(f''(r_*), 2 f'(r_*))| approx 0.542716, quad K_S = C_N^(1/p) approx 0.685420. $

== Wnioski — podpunkt b

- *Rząd zbieżności jest własnością asymptotyczną:*
  Stałe i rzędy zbieżności opisują błędy dopiero wtedy, gdy iteracje znajdują się dostatecznie blisko prostego pierwiastka i spełnione są wymagane założenia regularności. Początkowe ilorazy nie muszą odpowiadać wartościom granicznym i nie powinny być podstawą do oceniania rzędu metody.

- *Błąd rzeczywisty a jego oszacowanie:*
  Bisekcja zmniejsza długość przedziału dokładnie dwukrotnie, lecz błędy kolejnych punktów środkowych nie muszą maleć monotonicznie. Dlatego w tej metodzie miarodajna jest gwarantowana granica błędu wynikająca z szerokości przedziału, a nie iloraz dwóch rzeczywistych błędów.

- *Trudność pomiaru szybkiej zbieżności:*
  Metody o wysokim rzędzie mogą potrzebować tak niewielu iteracji, że trudno zaobserwować stabilizację ilorazów. Gdy błąd zbliża się do precyzji maszynowej, zaokrąglenia mogą zdominować analizowany iloraz. Do wiarygodnej weryfikacji teorii przydatna bywa większa precyzja obliczeń.


#pagebreak()
= Zadanie 6 — pierwiastek trzykrotny

Dla $f(x)=(x-1)^3 cos x$ mamy pierwiastek $r=1$ o krotności $m=3$. Przyjęto $x_0=1.2$. Pochodna ma postać

$ f'(x) = 3(x-1)^2 cos x - (x-1)^3 sin x. $

== Wyniki

Zastosowano klasyczny krok Newtona $x_(n+1)=x_n-frac(f(x_n),f'(x_n))$ oraz jego modyfikację $x_(n+1)=x_n-3frac(f(x_n),f'(x_n))$. W tabeli $e_n=x_n-1$, $Q_K=|e_n|/|e_(n-1)|$ i $Q_M=|e_n|/|e_(n-1)|^2$.

#table(
  columns: (0.4fr, 1.25fr, 1.0fr, 1.25fr, 1.0fr),
  inset: (x: 4pt, y: 3pt),
  stroke: 0.35pt + luma(185),
  [*$n$*], [*Klasyczny $|e_n|$*], [*$Q_K$*], [*Zmodyfikowany $|e_n|$*], [*$Q_M$*],
  [0], [2.000000e-1], [—], [2.000000e-1], [—],
  [1], [1.195355e-1], [0.5976777], [4.139335e-2], [1.034834],
  [2], [7.612076e-2], [0.6368044], [7.976980e-4], [0.4655617],
  [3], [4.949469e-2], [0.6502128], [3.296225e-7], [0.5180121],
  [4], [3.250848e-2], [0.6568074], [5.639933e-14], [0.5190871],
  [5], [2.147203e-2], [0.6605056], [0], [0],
  [10], [2.785325e-3], [0.6659346], [—], [—],
  [15], [3.660984e-4], [0.6665715], [—], [—],
)

== Obserwacje

Dla klasycznego Newtona iloraz błędów zbliża się do przewidywanej stałej

$ C = 1 - 1/m = 2/3 approx 0.666667. $

Dla Newtona zmodyfikowanego iloraz kwadratowy zbliża się do

$ C_(mod) = |frac(g'(1), 3 g(1))| = |frac(-sin 1, 3 cos 1)| approx 0.5191359, $

gdzie $g(x)=cos x$. Ostatni wiersz metody zmodyfikowanej daje błąd równy zeru wskutek zaokrąglenia `Float64`, dlatego jego iloraz nie jest miarodajny.

== Wnioski

- *Wpływ krotności pierwiastka:*
  Pierwiastek wielokrotny ma inną lokalną strukturę niż pierwiastek prosty: pierwsza pochodna zanika w samym rozwiązaniu. Z tego powodu klasyczny Newton traci typową zbieżność kwadratową i zbiega jedynie liniowo. Rząd zbieżności zależy więc nie tylko od algorytmu, ale też od własności rozwiązywanego równania.

- *Wykorzystanie wiedzy o problemie:*
  Znajomość krotności umożliwia skorygowanie kroku Newtona i odzyskanie zbieżności kwadratowej. Pokazuje to, że odpowiednio dobrana modyfikacja metody może być skuteczniejsza niż samo zwiększanie liczby iteracji. Korzyść wymaga jednak prawidłowego ustalenia krotności pierwiastka.

- *Małe residuum przy pierwiastku wielokrotnym:*
  W otoczeniu pierwiastka wielokrotnego wartość funkcji maleje jak wysoka potęga błędu argumentu. Nawet bardzo małe residuum nie musi więc oznaczać porównywalnie dokładnego wyznaczenia pierwiastka. Interpretacja warunku stopu powinna uwzględniać krotność i lokalne zachowanie funkcji.

- *Granica wiarygodności obliczeń:*
  Przy bardzo szybkiej zbieżności obliczone przybliżenie może zrównać się z pierwiastkiem wskutek zaokrąglenia w `Float64`. Zerowy błąd zapisany przez komputer nie jest dowodem zerowego błędu matematycznego. W tej fazie ilorazy błędów przestają być wiarygodnym narzędziem badania zbieżności.
