#set document(title: "Sprawozdanie nr. 2")
#set page(paper: "a4", margin: 2.5cm)
#set text(font: "New Computer Modern", lang: "pl", size: 11pt)
#set heading(numbering: "1.1.")
#set par(justify: true)

#align(center)[
  #text(size: 18pt, weight: "bold")[Sprawozdanie nr. 2]
  #v(1em)
  #text(size: 14pt)[Autor: Piotr Zieniewicz 283961]
  #v(2em)
]

= Zadanie 4.

== Podpunkt a) Struktura obsługująca wielomiany wielu zmiennych

Do reprezentacji wielomianów wielu zmiennych w języku Python zastosowano klasę `Polynomial`, której fundamentem jest wbudowana struktura słownika (`dict`). 

- *Klucze słownika* to krotki liczb całkowitych, które jednoznacznie reprezentują wykładniki potęg przy poszczególnych zmiennych. Na przykład dla pierścienia wielomianów trzech zmiennych $R[x, y, z]$, jednomian $x^2 y z^3$ przyjmuje postać krotki `(2, 1, 3)`.
- *Wartości słownika* to liczby zmiennoprzecinkowe odpowiadające współczynnikom przy danych jednomianach.

Taka struktura (tzw. reprezentacja rzadka) jest wysoce optymalna, ponieważ w pamięci przechowywane są wyłącznie te jednomiany, których współczynnik jest różny od zera. Klasa została wyposażona w przeciążone operatory arytmetyczne (`__add__`, `__sub__`, `__mul__`), co pozwala na naturalne i intuicyjne operowanie na wielomianach w kodzie.

== Podpunkt b) Implementacja porządków na jednomianach

Porządki jednomianowe zrealizowano jako funkcje wyznaczające klucze sortowania, które można przekazać do wbudowanych algorytmów Pythona (np. funkcji `max()`). Zaimplementowano trzy warianty porządków:

1. *Porządek leksykograficzny (Lex):* Działa analogicznie do porządku słownikowego. Funkcja zwraca oryginalną krotkę wykładników, a Python naturalnie porównuje je od lewej do prawej.
2. *Permutowany porządek leksykograficzny:* Zmodyfikowana wersja standardowego porządku Lex, w której za pomocą zadanej permutacji zmieniamy priorytet poszczególnych zmiennych (np. narzucając relację $y > x > z$).
3. *Porządek ze stopniowaniem (GradedLex):* Funkcja zwraca krotkę złożoną z dwóch elementów: `(suma_wykladnikow, oryginalna_krotka)`. W ten sposób algorytm w pierwszej kolejności porównuje całkowity stopień jednomianu, a standardowy porządek leksykograficzny stosowany jest wyłącznie jako rozstrzygnięcie w przypadku remisów.

```python
# Przykładowa implementacja porządku GradedLex
def grlex_order(exp):
    return (sum(exp), exp)
```

== Podpunkt c) Algorytm redukcji wielomianowej

Zaimplementowano algorytm `PolynomialReduce`, stanowiący uogólnienie dzielenia wielomianów z resztą dla wielu zmiennych. Funkcja przyjmuje wielomian $f$ do zredukowania, listę dzielników $G$ oraz wybraną funkcję porządkującą jednomiany. Wynikiem jej działania jest ciąg wielomianów stanowiących ilorazy (współczynniki $alpha_i$) oraz wielomian reszty $r$, taki że:
$ f = alpha_1 g_1 + alpha_2 g_2 + dots + alpha_n g_n + r $

Algorytm działa w sposób zachłanny. W głównej pętli analizowany jest wyraz wiodący redukowanego wielomianu ($L T$). Następnie iterujemy po liście dzielników sprawdzając podzielność jednomianów. Jeśli wyraz wiodący dzielnika dzieli obecny $L T$, następuje krok redukcji. W przeciwnym razie, nieredukowalny składnik trafia do reszty $r$.

*Zasadniczy fragment pętli redukcyjnej:*

```python
while not p.is_zero():
    p_exp, p_coeff = p.get_leading_term(order_key)
    division_occurred = False

    for i, (g_exp, g_coeff) in enumerate(G_LTs):
        if divides(g_exp, p_exp):
            t_exp = subtract_exp(p_exp, g_exp)
            t_coeff = p_coeff / g_coeff
            
            alphas[i] = alphas[i] + Polynomial({t_exp: t_coeff})
            term_to_subtract = G[i].multiply_by_term(t_coeff, t_exp)
            p = p - term_to_subtract
            
            division_occurred = True
            break 

    if not division_occurred:
        r = r + Polynomial({p_exp: p_coeff})
        p = p - Polynomial({p_exp: p_coeff})
```

Algorytm gwarantuje zakończenie działania (ze względu na dobre ufundowanie porządków jednomianowych) i stanowi podstawę do dalszych obliczeń algebraicznych, m.in. wyznaczania baz Gröbnera.

== Podpunkt d) Wyniki dla Ćwiczenia 37

W ramach tego podpunktu zbadano wpływ kolejności dzielników w ciągu generatorów na końcowy wynik algorytmu redukcji wielomianu. Wykorzystano porządek ze stopniowaniem (`GradedLex`, z konwencją $x > y > z$) oraz zdefiniowano następujące wielomiany:
$ f = x^3 - x^2 y - x^2 z, quad g_1 = x^2 y - z, quad g_2 = x y - 1 $

Wykonano dwa niezależne procesy dzielenia wielomianu $f$ z resztą:
+ Redukcja $f$ przez ciąg $(g_1, g_2)$ dała resztę:
  $ r_1 = x^3 - x^2 z - z $
+ Redukcja $f$ przez ciąg $(g_2, g_1)$ dała resztę:
  $ r_2 = x^3 - x^2 z - x $

Różnica otrzymanych reszt wynosi:
$ r_1 - r_2 = x - z $

*Wnioski z ćwiczenia:* Udowodniono analitycznie oraz programistycznie, że powyższa różnica reszt należy do ideału generowanego przez wielomiany $g_1$ oraz $g_2$ ($r_1 - r_2 in chevron.l g_1, g_2 chevron.r$). Można to zapisać wprost jako algebraiczną kombinację:
$ g_1 - x dot g_2 = (x^2 y - z) - x(x y - 1) = x^2 y - z - x^2 y + x = x - z $

Zjawisko otrzymania dwóch różnych reszt dla tego samego ideału wynika z faktu, że zbiór ${g_1, g_2}$ *nie jest bazą Gröbnera*. W trakcie redukcji jednomianu $-x^2 y$ algorytm zmuszony był podjąć zachłanną decyzję o tym, którego dzielnika użyć (oba pasowały), co trwale zmieniło dalszą ścieżkę obliczeń i uniemożliwiło uzyskanie kanonicznej, jednoznacznej postaci reszty.

```python
def run_part_d():
    f = Polynomial({(3, 0, 0): 1.0, (2, 1, 0): -1.0, (2, 0, 1): -1.0})
    g1 = Polynomial({(2, 1, 0): 1.0, (0, 0, 1): -1.0})
    g2 = Polynomial({(1, 1, 0): 1.0, (0, 0, 0): -1.0})
    
    # 1. Redukcja przez (g1, g2)
    alphas1, r1 = PolynomialReduce(f, [g1, g2], grlex_order)
    
    # 2. Redukcja przez (g2, g1)
    alphas2, r2 = PolynomialReduce(f, [g2, g1], grlex_order)
    
    # 3. Sprawdzenie różnicy reszt
    diff = r1 - r2
    x_poly = Polynomial({(1, 0, 0): 1.0})
    combination = g1 - (x_poly * g2) 
    
    # Sprawdzenie g1 - x*g2 == r1 - r2
    is_in_ideal = diff.terms == combination.terms
```

== Podpunkt e) Zależność wyniku od wybranego porządku leksykograficznego

Zgodnie z numerem indeksu *283961* wygenerowano współczynniki $a=2, b=8, c=3, d=9, e=6, f=1$, co posłużyło do konstrukcji wielomianu wejściowego $h$:
$ h(x,y,z) = x^2 y^8 - y^3 z^9 + x^6 z $

Zdefiniowano jednoelementowy zbiór generatorów $G = (g)$, gdzie $g = x + y + z$. Następnie przeprowadzono procedurę redukcji dla trzech odmiennych porządków leksykograficznych. Przypadek ten demonstruje specyficzną własność: dzielenie przez wielomian liniowy jest tożsame z algebraicznym podstawieniem za zmienną będącą wyrazem wiodącym ($L T$). Zmiana porządku wymusza zatem redukcję względem innej zmiennej.

*Wariant 1: Porządek Lex ($x > y > z$)* \
Wyrazem wiodącym $g$ jest $x$. Algorytm eliminuje $x$, co odpowiada podstawieniu $x = -y - z$. Otrzymana reszta $r_x$ wyraża się wyłącznie w zmiennych $y$ oraz $z$:
$ r_x = y^(10) + 2y^9 z + y^8 z^2 + y^6 z + 6y^5 z^2 + 15y^4 z^3 - y^3 z^9 + 20y^3 z^4 + 15y^2 z^5 + 6y z^6 + z^7 $

*Wariant 2: Porządek Lex ($y > x > z$)* \
Wyrazem wiodącym $g$ jest $y$. Algorytm eliminuje $y$, co odpowiada podstawieniu $y = -x - z$. Otrzymana reszta $r_y$ wyraża się wyłącznie w zmiennych $x$ oraz $z$:
$ r_y = x^(10) + 8x^9 z + 28x^8 z^2 + 56x^7 z^3 + 70x^6 z^4 + x^6 z + 56x^5 z^5 + 28x^4 z^6 + x^3 z^9 + 8x^3 z^7 + 3x^2 z^(10) + x^2 z^8 + 3x z^(11) + z^(12) $

*Wariant 3: Porządek Lex ($z > x > y$)* \
Wyrazem wiodącym $g$ jest $z$. Algorytm eliminuje $z$, co odpowiada podstawieniu $z = -x - y$. Otrzymana reszta $r_z$ wyraża się wyłącznie w zmiennych $x$ oraz $y$:
$ r_z = x^9 y^3 + 9x^8 y^4 + 36x^7 y^5 - x^7 + 84x^6 y^6 - x^6 y + 126x^5 y^7 + 126x^4 y^8 + 84x^3 y^9 + 36x^2 y^(10) + x^2 y^8 + 9x y^(11) + y^(12) $

Powyższe wyniki dowodzą w pełni poprawnego działania implementacji. Dobitnie ilustrują również nadrzędną rolę doboru porządku na jednomianach — determinuje on strukturę reszty, sprawiając, że redukcja tego samego wielomianu przez ten sam ideał daje rezultaty o drastycznie różnej budowie morfologicznej.

```python
def run_part_e():
    # Wielomian wejściowy h i dzielnik g
    h = Polynomial({(2, 8, 0): 1.0, (0, 3, 9): -1.0, (6, 0, 1): 1.0})
    g = Polynomial({(1, 0, 0): 1.0, (0, 1, 0): 1.0, (0, 0, 1): 1.0})
    G = [g]
    
    # Konfiguracja trzech porządków Lex
    lex_x_y_z = get_permuted_lex_order((0, 1, 2))
    lex_y_x_z = get_permuted_lex_order((1, 0, 2))
    lex_z_x_y = get_permuted_lex_order((2, 0, 1))
    
    # Wykonanie redukcji
    _, res_x = PolynomialReduce(h, G, lex_x_y_z)
    _, res_y = PolynomialReduce(h, G, lex_y_x_z)
    _, res_z = PolynomialReduce(h, G, lex_z_x_y)
```

= Zadanie 5.
== Wprowadzenie i równania parametryczne
Celem zadania było uogólnienie krzywej *Quadrifolium* (czterolistnej koniczyny) w celu zamodelowania japońskiego godła cesarskiego, które przedstawia złocień o szesnastu płatkach ułożonych w dwóch rzędach. 

Wspomniana krzywa to tzw. krzywa rozety. W układzie współrzędnych biegunowych podstawowe równanie takiej krzywej ma postać $r = cos(k theta)$. Aby uzyskać 16 płatków pierwszego planu, przyjmujemy $2k = 16$, co daje $k = 8$. Zatem równanie dla płatków pierwszoplanowych to:
$ r_1(theta) = cos(8 theta) $

Drugi rząd płatków (tło) składa się z kolejnych 16 elementów, które są obrócone względem pierwszych o połowę kąta między nimi, czyli o $pi/16$, i mają nieznacznie większy promień. Wykorzystując wzory redukcyjne ($cos(x - pi/2) = sin(x)$), równanie tła upraszcza się do postaci:
$ r_2(theta) = 1.15 sin(8 theta) $

== Połączone równanie we współrzędnych biegunowych
Aby narysować całe godło (oba rzędy płatków) za pomocą pojedynczego, ciągłego równania przypisującego promień do zmiennej, wprowadzono parametr $t$ z przedziału $t in [0, 4pi]$. Rysik wykonuje dwa pełne obroty. Wykorzystując funkcję skokową $H(x)$, możemy zapisać:

$ r(t) = |cos(8t)| dot H(2pi - t) + |1.15 sin(8t)| dot H(t - 2pi) $

W pierwszym obrocie ($t <= 2pi$) kreślony jest pierwszy plan, a w drugim ($t > 2pi$) dorysowywane jest tło. Wartość bezwzględna zapewnia poprawny, pełny kształt płatków.

== Przedstawienie krzywej jako rozmaitości algebraicznej
Zgodnie z poleceniem, krzywą rozety można przenieść do układu kartezjańskiego i przedstawić jako rozmaitość algebraiczną $F(x,y) = 0$. Rozpatrując równanie pierwszego planu $r = cos(8 theta)$, korzystamy ze wzoru de Moivre'a:

$ cos(8 theta) = op("Re")((cos theta + i sin theta)^8) = op("Re")(((x + i y) / r)^8) = 1/r^8 op("Re")((x + i y)^8) $

Rozwijając ze wzoru dwumianowego Newtona i wybierając tylko składniki rzeczywiste, otrzymujemy:
$ op("Re")((x+i y)^8) = x^8 - 28x^6y^2 + 70x^4y^4 - 28x^2y^6 + y^8 $

Podstawiając to do początkowego równania, mamy:
$ r = (x^8 - 28x^6y^2 + 70x^4y^4 - 28x^2y^6 + y^8) / r^8 $
$ r^9 = x^8 - 28x^6y^2 + 70x^4y^4 - 28x^2y^6 + y^8 $

Aby całkowicie usunąć $r$ z równania, podnosimy obie strony do kwadratu i stosujemy tożsamość $r^2 = x^2 + y^2$. Pozwala to zapisać ostateczne równanie wielomianowe opisujące rozmaitość algebraiczną:

$ F(x,y) = (x^2 + y^2)^9 - (x^8 - 28x^6y^2 + 70x^4y^4 - 28x^2y^6 + y^8)^2 = 0 $

== Implementacja w języku Python
Poniższy skrypt przedstawia sposób wygenerowania dwuwarstwowego złocienia za pomocą jednego standardowego równania analitycznego z przedziału $[0, 4pi]$.

```python
import numpy as np
import matplotlib.pyplot as plt

# 1. Parametr t robiący dwa pełne obroty (dla przodu i dla tła)
t = np.linspace(0, 4 * np.pi, 2000)

# 2. Jedno standardowe równanie ciągłe
r = np.abs(np.cos(8 * t)) * (t <= 2 * np.pi) + np.abs(1.15 * np.sin(8 * t)) * (t > 2 * np.pi)

# 3. Rysowanie na wykresie biegunowym
fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})
ax.plot(t, r, color='goldenrod', linewidth=2.5)

# Kosmetyka (ukrycie osi)
ax.set_yticklabels([])
ax.set_xticklabels([])
ax.spines['polar'].set_visible(False)
ax.grid(False)

plt.title('Złocień wygenerowany ciągłym równaniem r(t)')
plt.show()
```
