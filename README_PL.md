# Kompleksowa analiza finansowa i operacyjna przedsiębiorstwa

## Opis projektu

Projekt obejmuje kompleksową analizę wyników finansowych i operacyjnych przedsiębiorstwa z wykorzystaniem SQL, Google BigQuery oraz Power BI.

Głównym celem było przekształcenie surowych danych biznesowych w uporządkowane zbiory analityczne, zbudowanie relacyjnego modelu danych oraz opracowanie interaktywnych dashboardów umożliwiających monitorowanie kluczowych obszarów działalności przedsiębiorstwa.

Projekt obejmuje pięć głównych obszarów analitycznych: wyniki sprzedaży, procesy zakupowe, zobowiązania wobec dostawców, zarządzanie budżetem oraz analizę zapasów i produktów.

Projekt przedstawia kompleksowy proces analityczny – od eksploracji i przygotowania danych, przez analizę SQL i modelowanie danych, aż po tworzenie miar DAX oraz raportów Business Intelligence.

## Cele biznesowe

Główne cele projektu:

- Analiza wyników sprzedaży oraz trendów dotyczących zamówień.
- Ocena procesów zakupowych i efektywności współpracy z dostawcami.
- Monitorowanie faktur od dostawców, płatności oraz pozostałych zobowiązań.
- Porównanie przydzielonych budżetów z rzeczywistymi wydatkami.
- Analiza charakterystyki zapasów magazynowych i wyników sprzedaży produktów.
- Opracowanie interaktywnych dashboardów wspierających monitorowanie działalności przedsiębiorstwa i podejmowanie decyzji biznesowych.

## Wykorzystane technologie i narzędzia

| Technologia | Zastosowanie |
|---|---|
| Google BigQuery | Chmurowa hurtownia danych i analiza SQL |
| SQL | Eksploracja, transformacja, przygotowanie danych i zapytania analityczne |
| Power BI | Modelowanie danych i tworzenie interaktywnych dashboardów |
| DAX | Tworzenie miar, wskaźników KPI i obliczeń biznesowych |
| Power Query | Przygotowanie i transformacja danych w Power BI |

## Źródła danych

Projekt wykorzystuje dane pochodzące z dwóch źródeł.

**1. TheLook E-commerce Dataset**

Publiczny zbiór danych dotyczący działalności sklepu internetowego, obejmujący informacje o:

- Zamówieniach.
- Pozycjach zamówień.
- Produktach.
- Pozycjach magazynowych.

**2. Syntetyczne dane zakupowe i finansowe**

Dodatkowe zbiory danych przygotowane na potrzeby projektu w celu odwzorowania procesów zakupowych i finansowych przedsiębiorstwa:

- Dostawcy.
- Zamówienia zakupu.
- Pozycje zamówień zakupu.
- Przyjęcia towarów.
- Faktury od dostawców.
- Pozycje faktur.
- Płatności na rzecz dostawców.
- Budżety.

Połączenie obu źródeł umożliwia analizę kilku powiązanych ze sobą obszarów działalności biznesowej.

## Przebieg projektu

### 1. Eksploracja i poznanie danych

- Analiza dostępnych zbiorów danych i ich struktury.
- Weryfikacja kolumn, typów danych oraz zależności między tabelami.
- Identyfikacja zmiennych istotnych z punktu widzenia analizy biznesowej.
- Ocena kompletności i spójności danych.

### 2. Przygotowanie i transformacja danych

- Wykorzystanie SQL w BigQuery do przygotowania danych analitycznych.
- Ujednolicenie struktur danych i typów kolumn w razie potrzeby.
- Selekcja kolumn istotnych dla dalszych analiz.
- Przygotowanie zbiorów danych do integracji w Power BI.

### 3. Analiza SQL

Przeprowadzono analizy dotyczące:

- Wyników sprzedaży i aktywności zamówień.
- Wartości zakupów i wzorców zakupowych.
- Aktywności dostawców.
- Faktur i płatności.
- Alokacji budżetów i wydatków.
- Charakterystyki produktów i zapasów magazynowych.

### 4. Modelowanie danych

Zbudowano relacyjny model danych w Power BI.

Model integruje dane dotyczące e-commerce, zakupów i finansów, wykorzystując relacje pomiędzy odpowiednimi encjami biznesowymi.

Utworzono wspólne tabele wymiarów, w tym:

- Kalendarz.
- Kategorie.

Model umożliwia analizę danych z różnych obszarów działalności oraz interaktywne filtrowanie raportów.

### 5. Tworzenie miar DAX i wskaźników KPI

Opracowano miary DAX służące do obliczania kluczowych wskaźników biznesowych, między innymi:

- Wartość sprzedaży.
- Liczba zamówień.
- Średnia wartość zamówienia.
- Wartość zakupów.
- Liczba zamówień zakupu.
- Wartość faktur.
- Wartość dokonanych płatności.
- Pozostała kwota zobowiązań.
- Stopień wykorzystania budżetu.
- Liczba pozycji magazynowych.
- Wskaźnik udziału sprzedanych pozycji magazynowych.

### 6. Tworzenie dashboardów

Opracowano pięć interaktywnych dashboardów w Power BI, obejmujących najważniejsze obszary działalności przedsiębiorstwa.

## Dashboardy

### 1. Sales Performance – Analiza wyników sprzedaży

Dashboard koncentruje się na analizie sprzedaży w sklepie internetowym oraz wynikach realizacji zamówień.

<img width="1327" height="742" alt="image" src="https://github.com/user-attachments/assets/bbb8acaf-9f4c-4da0-8026-f8b3da100f1a" />


Główne obszary analizy:

- Całkowita wartość sprzedaży.
- Liczba zamówień.
- Średnia wartość zamówienia.
- Średnia cena sprzedaży produktu.
- Liczba zrealizowanych zamówień.
- Wskaźnik realizacji zamówień.
- Miesięczne trendy sprzedażowe.
- Sprzedaż według kategorii produktów.
- Sprzedaż według statusu zamówienia.

### 2. Procurement Performance – Analiza procesów zakupowych

Dashboard przedstawia aktywność zakupową przedsiębiorstwa oraz wyniki współpracy z dostawcami.

<img width="1327" height="743" alt="image" src="https://github.com/user-attachments/assets/9e87c3a7-979b-445b-845a-c4c7ae603c05" />


Główne obszary analizy:

- Całkowita wartość zakupów.
- Liczba zamówień zakupu.
- Liczba dostawców.
- Średnia wartość zamówienia zakupu.
- Zamówiona ilość produktów.
- Odebrana ilość produktów.
- Miesięczna wartość zakupów.
- Wartość zakupów według kategorii.
- Ranking dostawców według wartości zakupów.
- Zamówienia zakupu według statusu.

### 3. Accounts Payable – Analiza zobowiązań wobec dostawców

Dashboard koncentruje się na fakturach od dostawców oraz realizowanych płatnościach.

<img width="1327" height="746" alt="image" src="https://github.com/user-attachments/assets/50d9d66c-5529-4701-8927-37bbdc846155" />


Główne obszary analizy:

- Całkowita wartość faktur.
- Liczba faktur.
- Wartość dokonanych płatności.
- Pozostała kwota zobowiązań.
- Średnia wartość faktury.
- Miesięczna wartość faktur i płatności.
- Pozostałe zobowiązania według dostawców.
- Wartość faktur według dostawców.
- Wartość faktur według terminów płatności.

### 4. Budget Performance – Analiza realizacji budżetu

Dashboard analizuje alokację budżetów oraz poziom wydatków w poszczególnych kategoriach i okresach.

<img width="1325" height="741" alt="image" src="https://github.com/user-attachments/assets/95c9fe90-3a6e-429f-a888-0ea88f9a4814" />


Główne obszary analizy:

- Całkowita wartość budżetu.
- Rzeczywiste wydatki.
- Pozostały budżet.
- Procent wykorzystania budżetu.
- Miesięczne porównanie budżetu z rzeczywistymi wydatkami.
- Alokacja budżetu według kategorii.
- Rzeczywiste wydatki według kategorii.
- Stopień wykorzystania budżetu według kategorii.

### 5. Inventory & Product Performance – Analiza zapasów i wyników produktów

Dashboard łączy informacje o pozycjach magazynowych z analizą sprzedaży produktów.

<img width="1323" height="750" alt="image" src="https://github.com/user-attachments/assets/d7aae11c-2f95-4563-b17d-6e42e0566388" />


Główne obszary analizy:

- Całkowita liczba pozycji magazynowych.
- Liczba unikalnych produktów.
- Liczba sprzedanych pozycji magazynowych.
- Liczba niesprzedanych pozycji magazynowych.
- Wskaźnik udziału sprzedanych pozycji.
- Rozkład pozycji magazynowych według kategorii.
- 10 najlepiej sprzedających się produktów.
- Porównanie sprzedanych i niesprzedanych pozycji.
- Miesięczne trendy sprzedażowe.

## Istotne założenia i ograniczenia analityczne

Podczas analizy uwzględniono kilka istotnych kwestii dotyczących interpretacji danych:

- Dane e-commerce i dane zakupowo-finansowe pochodzą z różnych źródeł i mają odmienne struktury oraz konteksty biznesowe.
- Zbiory danych dotyczące zakupów i finansów są syntetyczne, dlatego należy interpretować je jako symulację procesów biznesowych.
- Wartość zamówień zakupu, wartość faktur i kwoty płatności reprezentują różne etapy procesu zakupowego i płatniczego.
- Rzeczywiste wydatki obliczane są na podstawie wartości pozycji faktur, a nie dokonanych płatności.
- Wskaźnik wykorzystania budżetu przedstawia relację pomiędzy zarejestrowanymi wydatkami z faktur a przydzielonym budżetem.
- Pozycje magazynowe bez daty `sold_at` traktowane są jako niesprzedane rekordy, a nie potwierdzony aktualny stan magazynowy.
- Dane magazynowe nie muszą odzwierciedlać rzeczywistego stanu zapasów w konkretnym momencie.
- Statusy zamówień interpretowane są zgodnie z definicjami dostępnymi w zbiorze danych.

Uwzględnienie tych ograniczeń jest istotne przy interpretacji wskaźników KPI i formułowaniu wniosków biznesowych.

## Struktura repozytorium

```text
business-operations-financial-analytics/
│
├── sql/
|   ├── 01_data_exploration.sql
|   ├── 02_data_quality_checks.sql
|   ├── 03_order_status_analysis.sql
|   ├── 04_sales_analysis.sql
|   ├── 05_inventory_analysis.sql
|   ├── 06_procurement_and_accounts_payable_dataset.sql
|   ├── 07_procurement_analysis.sql
|   ├── 08_accounts_payable_analysis.sql
|   └── 09_budget_and_financial_analysis.sql
|
├── power_bi/
│   ├── business_operations_dashboard.md
│   ├── sales_performance.png
│   ├── procurement_performance.png
│   ├── accounts_payable.png
│   ├── budget_performance.png
│   └── inventory_and_product_performance.png
│
├── documentation/
|   ├── 01_data_overview.md
|   ├── 02_data_quality_report.md
|   ├── 03_order_analysis.md
|   ├── 04_sales_analysis.md
|   ├── 05_inventory_analysis.md
|   ├── 06_procurement_and_accounts_payable_dataset.md
|   ├── 07_procurement_analysis.md
|   ├── 08_accounts_payable_analysis.md
|   └── 09_budget_and_financial_analysis.md
│
└── README.md
└── README_PL.md
