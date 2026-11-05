#align(center)[
  = Dokumentacja bazy danych - Laboratoria lista 5
  === Piotr Zieniewicz 283961
]
== Cel aplikacji
Celem aplikacji jest umożliwienie hurtowni obsługującej klientów biznesowych wystawianie faktur ze sprzedaży oraz zarządzanie swoją ofertą produktów i bazą klientów.

Aplikacja umożliwia:
 - Dodawanie, wyświetlanie oraz usuwanie artykułów w ofercie
 - Dodawanie oraz wyświetlanie klientów
 - Dodawanie oraz wyświetlanie faktur
 - Dodawanie, wyświetlanie, usuwanie oraz edytowanie użytkowników systemu
 - Logowanie się do systemu

== Użytkownicy
W systemie znajdują się 4 rodzaje użytkowników:
1. Administrator 
 - zarządza użytkownikami w systemie
 - tworzy nowe konta
 - jest odpowiedzialny za zmianę haseł, nazw oraz uprawnień użytkowników
2. Pracownik działu sprzedaży
 - zarządza bazą klientów
 - może dodawać nowych klientów
3. Pracownik magazynu
 - zarządza asortymentem hurtowni
 - może dodawać i zmieniać produkty z oferty
4. Księgowy
 - zarządza tabelą faktur
 - może wyświetlać produkty oraz klientów
 - wystawia na podstawie innych tabel faktury
 - może wyśeitlać podgląd danej faktury

== Tabele
1. *clients* - informacje o klientach hurtowni \
   Struktura: (nip, name, address) \
   Klucze kandydackie: nip \
   Klucz główny: nip
2. *articles* - artykuły oferowane przez hurtownię \
   Struktura: (id, name, price) \
   Klucze kandydackie: nip \
   Klucz główny: nip
3. *invoices* - faktury wystawione przez księgowość na klientów hurtowni \
   Struktura: (id, client_nip, date) \
   Klucze kandydackie: id \
   Klucz główny: id \
   Klucze obce: client_nip -> clients(nip)
4. *invoice_items* - pozycje z faktur, kopiuje wartości z tabeli articles \
   Struktura: (id, invoice_id, name, price, quantity) \
   Klucze kandydackie: id \
   Klucz główny: id \
   Klucze obce: invoice_id -> invoices(id)
5. *roles* - tabela słownikowa zawierająca role w systemie \
   Struktura: (id, role) \
   Klucze kandydackie: id \
   Klucz główny: id
6. *users* - tabela użytkowników, hasła są hashowane hashem BCrypt \
   Struktura: (id, username, hash, role_id) \
   Klucze kandydackie: id, username \
   Klucz główny: id \
   Klucze obce: role_id -> roles(id)

== Związki między tabelami
 - invoices *1..n* invoice_items
 - clients *1..n* invoices
 - roles *1..n* users

== Diagram tabel
#align(center)[#image("diagram.png")]

== Normalizacja
Baza danych jest zgodna z 3NF, tj.:
1. 1NF
  - Każda kolumna zawiera niepodzielne wartości
  - Każda kolumna zawiera jeden typ danych
2. 2NF
  - Każda kolumna, która nie jest kluczem głównym zależy od całego klucza głównego
3. 3NF
  - Kolumny niekluczowe nie zależą od innych kolumn nie kluczowych

== Uzasadnienie redundancji
Kopiowanie danych z articles do invoice_items, tj. pól `name` i `price` jest wykonywane, ponieważ zmiany w tabeli articles nie mogą wpływać na wystawione już faktury, np. podwyższenie ceny jakiegoś artykułu nie może podnieść wartości całej faktury. Faktury muszą odzwierciedlać moment sprzedaży, a wszelkie modyfikacje muszą być zamierzone i bezpośrednie. Zasada ta nie dotyczy klientów, ponieważ są oni rozpoznawalni unikalnym nipem i wszelkie zmiany w ich nazwach, bądź adresach nie wpływają na ważność faktury.

== Bezpieczeństwo
W aplikacji funkcjonują dwaj użytkownicy bazy danych:
1. *auth* - użytkownik stosowany tylko do sprawdzania danych logowania. Ma jedynie uprawnienia `SELECT` na tabelach roles i users.
2. *app* - użytkownik obsługujący żądania pracowników. Ma uprawnienia `SELECT`, `INSERT`, `UPDATE` i `DELETE` na wszystkich tabelach systemu, oprócz tabeli roles na której ma tylko uprawnienia `SELECT`.
