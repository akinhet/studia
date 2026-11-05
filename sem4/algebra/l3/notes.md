* 
```
Funkcja PolynomialReduce(f, G)
    Wejście: Wielomian f, lista wielomianów G = [g_1, g_2, ..., g_k]
    Wyjście: Lista ilorazów [q_1, ..., q_k] oraz reszta r

    Inicjalizacja:
    dla każdego i od 1 do k:
        q_i := 0
    r := 0
    p := f  // p to wielomian, który aktualnie redukujemy

    Dopóki p != 0 Wykonuj:
        zredukowano := Fałsz
        i := 1
        
        // Szukamy pierwszego wielomianu g_i, który dzieli wiodący wyraz p
        Dopóki i <= k oraz zredukowano == Fałsz Wykonuj:
            Jeśli LM(g_i) dzieli LM(p) To:
                // Obliczamy wyraz ilorazu
                wspolczynnik := LC(p) / LC(g_i)
                jednomian := LM(p) / LM(g_i)
                wyraz := wspolczynnik * jednomian
                
                // Aktualizujemy iloraz i wielomian p
                q_i := q_i + wyraz
                p := p - wyraz * g_i
                zredukowano := Prawda
            W przeciwnym wypadku:
                i := i + 1
        
        // Jeśli żaden g_i nie dzieli LT(p), przesuwamy LT(p) do reszty
        Jeśli zredukowano == Fałsz To:
            r := r + LT(p)
            p := p - LT(p)

    Zwróć ([q_1, q_2, ..., q_k], r)
```
```
Funkcja Syzygium(f, g)
    Wejście: Wielomian f, Wielomian g
    Wyjście: Wielomian S(f, g)

    // Jeśli któryś z wielomianów jest zerowy, S-wielomian wynosi 0
    Jeśli f == 0 lub g == 0 To:
        Zwróć 0

    // Wyznaczamy Najmniejszą Wspólną Wielokrotność (NWW) wiodących jednomianów
    L := NWW(LM(f), LM(g))

    // Obliczamy składniki S-wielomianu
    skladnik_f := (L / LT(f)) * f
    skladnik_g := (L / LT(g)) * g

    Zwróć (skladnik_f - skladnik_g)
```
```
Funkcja BuchbergerAlgorithm(G_pocz)
    Wejście: Lista wielomianów generujących ideał G_pocz = [g_1, ..., g_k]
    Wyjście: Baza Groebnera G dla tego ideału

    G := Kopia(G_pocz)
    Pary := { {g_i, g_j} : g_i, g_j należą do G oraz g_i != g_j }

    Dopóki Pary nie jest puste Wykonuj:
        Wybierz i usuń parę {f, g} z Pary
        
        // 1. Oblicz S-wielomian dla wybranej pary
        S := Syzygium(f, g)
        
        // 2. Zredukuj S-wielomian względem aktualnej bazy G
        // Interesuje nas tylko reszta (drugi element zwracanej pary)
        (_, r) := PolynomialReduce(S, G)
        
        // 3. Jeśli reszta nie jest zerem, rozszerzamy bazę
        Jeśli r != 0 To:
            // Dodajemy nowe pary ze świeżo znalezionym wielomianem r
            Dla każdego h należącego do G Wykonuj:
                Pary := Pary U { {h, r} }
            
            // Dodajemy r do naszej bazy
            G := G U {r}

    Zwróć G
```

// #algorithm-figure(
//   "Polynomial-Reduce",
//   vstroke: .5pt + luma(200),
//   {
//     import algorithmic: *
//     Procedure(
//       "Polynomial-Reduce",
//       ("f", "G"),
//       {
//         Comment[Wejście: Wielomian f, lista wielomianów G = [$g_1, g_2, ..., g_k$]]
//         Comment[Wyjście: Lista ilorazów [$q_1, ..., q_k$] oraz reszta r]
//         LineBreak
//         For($1 <= i <= k$, {
//           Assign[$q_i$][0]
//         })
//         Assign[$r$][0]
//         Assign[$p$][$f$]
//         LineBreak
//         Comment[Szukamy pierwszego wielomianu $g_i$, który dzieli wiodący wyraz $p$]
//         While(
//           $p != 0$,
//           {
//             Assign[$"zredukowany"$][$"False"$]
//             Assign[$i$][$1$]
//             While($i <= k and "zredukowano" = "False"$, {
//               If($"LM"(g_i) | "LM"(p)$, {
//                 Comment[Obliczamy wyraz ilorazu]
//                 Assign[wspolczynnik][$"LC"(p) "/" "LC"(g_i)$]
//                 Assign[jednomian][$"LM"(p) "/" "LM"(g_i)$]
//                 Assign[wyraz][$"wspolczynnik" * "jednomian"$]
//
//                 LineBreak
//                 Comment[Aktualizujemy iloraz i wielomian $p$]
//                 Assign[$q_i$][$q_i + "wyraz"$]
//                 Assign[$p$][$p - "wyraz" * g_i$]
//                 Assign[zredukowano][True]
//               })
//               Else({Assign[i][$i + 1$]})
//             })
//           },
//         )
//       },
//     )
//   }
// )

* 1. x^2 + y^2 = 0
  2. x^2 + y^2 - 100 = 0
  3. 14x - y^2 - 49 = 0
  4. xy + 2x + 2y + 2 = 0
  5. 4x^2 + 3y^2 - 4y - 4 = 0

  ponieważ obliczając bazy grobnera przecinamy stożek płaszczyznami


