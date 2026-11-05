#set text(lang: "pl")

= Zadanie 5

== Wstęp

Zadanie polega na zbadaniu co się stanie z protokołem podpisu BLS, gdy w obrazie funkcji haszującej można łatwo obliczyć logarytm dyskretny.

== Schemat

Zakładamy, że dla funkcji haszującej $H(m)$ możemy łatwo znaleźć $b in Z_q$, które spełnia\ $H(m) = b P$. Podpisujący oblicza podpis
$
sigma = a H(m) = a b P
$
Weryfikator sprawdza warunek BLS
$
e(sigma, Q) = e(H(m), A)
$

== Dowód poprawności

Warto zauważyć, że oprócz wrażliwości funkcji haszującej, schemat ten nie różni się od standardowego schematu BLS. Dlatego też dowód poprawności jest identyczny:
$
e(sigma, Q) = e(a H(m), Q) = e(H(m), Q)^a = e(H(m), a Q) = e(H(m), A)
$

== Atak na schemat

Atak na ten schemat zakłada, że atakujący posiada poprawną parę podpisu i wiadomości $(sigma_1, m_1)$.

1. Przy pomocy $(sigma_1, m_1)$ obliczamy $a P$
$
H(m_1) = a b_1 P \
sigma_1 b_1^(-1) = a H(m_1) P b_1^(-1) = a b_1 b_1^(-1) P = a P
$

2. Dla wiadomości $m_2$ wyliczamy $b_2$
$
H(m_2) = a b_2 P
$

3. Mnożąc $a P$ razy $b_2$ wyliczamy nowy podpis $sigma_2$
$
e(sigma_2, Q) = e(a b_2 P, Q) = e(b_2 P, Q)^a = e(H(m_2), a Q) = e(H(m_2), A)
$

W ten sposób przechwytując jeden poprawny podpis możemy podpisać dowolną inną wiadomość, a więc schemat został całkowicie złamany.

== Wnioski

To zadanie pokazuje jak ważny jest dobór silnej funkcji haszującej w schematach kryptograficznych. Mimo, że schemat BLS jest poprawny i szeroko stosowany, wybranie funkcji haszującej, dla której logarytm dyskretny jest łatwo obliczalny całkowicie rujnuje cały schemat. Nie ma znaczenia, że logarytm dyskretny jest trudny w grupie jako w całości. Wystarczy, że akurat nasza funkcja $H(m)$ jest na to podatna.

Zadanie wpisuje się w szereg poprzednich, w których przejęcie jednego poprawnego podpisu pozwala wyliczyć wartość, która pozwala podrabiać podpisy pod dowolnymi wiadomościami. Widać na jego przykładzie, że należy być czujnym i dokładnie przeanalizować schemat, jeżeli atakujacy jest w stanie wyznaczyć jakąś część wspólną dla wszystkich podpisów, do której normalnie nie powinien mieć dostępu.
