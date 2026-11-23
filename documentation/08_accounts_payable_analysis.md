# 08. Accounts Payable Analysis

## Overview

This phase analyzes supplier invoices and payment activity using the synthetic procurement dataset stored in BigQuery.

The analysis focuses on invoice values, payment status, outstanding balances, invoice aging, supplier payment performance, and monthly payment activity.

A consistent reporting cutoff of **31 October 2026** was applied to ensure that the results represent the same reporting period. Invoices dated from 1 November 2026 onward and payments made from that date onward are excluded.

The analysis uses the following tables:

- `supplier_invoices`
- `supplier_invoice_lines`
- `supplier_payments`
- `suppliers`

The queries were designed to support accounts payable monitoring and provide insights into outstanding liabilities, payment behavior, and supplier-related financial exposure.

---

## 08.1 Supplier Invoice Overview

**Purpose**

This query provides an overview of supplier invoices, showing the number and total value of invoices issued by each supplier.

**Key metrics**

- Number of invoices
- Total invoice value
- Average invoice value
- First invoice date
- Last invoice date

**Methodology**

Invoice records are grouped by supplier. The query calculates the number of invoices, total invoice amount, and average invoice value. It also identifies the earliest and latest invoice dates for each supplier.

Only invoices issued before 1 November 2026 are included.

**Key findings**

- Summit Outdoor Goods recorded the highest total invoice value at **$23,411.60** across 12 invoices.
- EuroStyle Manufacturing ranked second with **$22,342.82**.
- Metro Basics Trading ranked third with **$20,415.53**.
- Global Garment Partners recorded the lowest total invoice value at **$11,496.35**.
- Most suppliers issued 12 invoices during the analyzed period, while Classic Wear Industries, Vertex Retail Supply, and Prime Denim Suppliers issued 9 invoices each.
- Evergreen Accessories and Pacific Fashion Supply each had 11 invoices after applying the reporting cutoff.

**Business interpretation**

The results show differences in the total value of supplier invoices and the average invoice amount. These differences may reflect variations in purchasing volume, product costs, and supplier relationships.

Summit Outdoor Goods represents the largest supplier by recorded invoice value, while Global Garment Partners represents the smallest.

The total invoice value should be interpreted as the value of invoices recorded in the dataset, rather than as a verified accounting liability balance.

---

## 08.2 Invoice Payment Status

**Purpose**

This query evaluates the payment status of supplier invoices and identifies the value of outstanding accounts payable.

**Key metrics**

- Number of invoices by payment status
- Total invoice value
- Total amount paid
- Outstanding amount

**Methodology**

Payment transactions are aggregated by invoice to calculate the total amount paid. The resulting payment summary is joined to supplier invoices to determine the remaining balance.

Each invoice is classified as:

- `paid` – the amount paid is equal to or greater than the invoice amount.
- `partially_paid` – the amount paid is greater than zero but lower than the invoice amount.
- `unpaid` – no payment has been recorded.

Only invoices issued before 1 November 2026 and payments made before that date are included.

**Key findings**

| Payment status | Invoices | Invoice value | Total paid | Outstanding |
|---|---:|---:|---:|---:|
| Paid | 107 | $142,023.84 | $142,023.84 | $0.00 |
| Unpaid | 57 | $82,968.17 | $0.00 | $82,968.17 |
| Partially paid | 5 | $8,109.40 | $8,109.40 | $0.00 |
| **Total** | **169** | **$233,101.41** | **$150,133.24** | **$82,968.17** |

- 107 invoices were classified as paid.
- 57 invoices were classified as unpaid.
- 5 invoices were classified as partially paid.
- The total outstanding balance amounted to **$82,968.17**.

**Business interpretation**

The results indicate that the majority of the recorded invoice value has been paid, while $82,968.17 remains outstanding according to the payment records.

However, the five invoices classified as partially paid require additional validation. Their aggregated payment amount equals their invoice value, and their calculated outstanding balance is zero.

This may indicate a precision or rounding issue in the payment-status classification. The classification should therefore be verified using amounts rounded to two decimal places before treating these invoices as genuinely partially paid.

---

## 08.3 Outstanding Invoice Balance by Supplier

**Purpose**

This query identifies suppliers with the highest outstanding accounts payable balances.

**Key metrics**

- Number of outstanding invoices
- Total outstanding amount
- Average outstanding invoice amount

**Methodology**

Payments are aggregated at invoice level and subtracted from the corresponding invoice amounts.

The results are then grouped by supplier, including only invoices with a positive outstanding balance.

Both invoice dates and payment dates are restricted to the reporting period ending on 31 October 2026.

**Key findings**

- Summit Outdoor Goods recorded the highest outstanding balance at **$10,607.01** across 5 invoices.
- EuroStyle Manufacturing ranked second with **$7,757.13**.
- Classic Wear Industries ranked third with **$7,315.35**.
- Global Garment Partners had the highest number of outstanding invoices, with 6.
- Pacific Fashion Supply recorded the lowest outstanding balance at **$2,855.54**.

The total outstanding balance across all suppliers was **$82,968.17**.

**Business interpretation**

The results highlight differences in outstanding financial exposure across suppliers.

Summit Outdoor Goods represents the largest outstanding balance, making it the supplier with the highest recorded accounts payable exposure at the reporting date.

Global Garment Partners has the highest number of outstanding invoices, although its total outstanding value is lower than that of Summit Outdoor Goods.

These metrics can help prioritize invoice follow-ups and support accounts payable monitoring. A high outstanding balance does not necessarily indicate overdue payments, as some invoices may not yet have reached their due dates.

---

## 08.4 Invoice Aging Analysis

**Purpose**

This query evaluates outstanding invoices based on the number of days remaining until their due dates or the number of days they are overdue.

**Key metrics**

- Number of outstanding invoices by aging bucket
- Total outstanding amount by aging bucket
- Average outstanding invoice amount

**Methodology**

Outstanding invoices are grouped into aging categories based on the difference between their due dates and the reporting date of **31 October 2026**.

The following categories are used:

- `not yet due` – invoices with due dates on or after the reporting date.
- `1-30 days overdue` – invoices overdue by 1 to 30 days.
- `31-60 days overdue` – invoices overdue by 31 to 60 days.
- `over 60 days overdue` – invoices overdue by more than 60 days.

Only invoices with a positive outstanding balance are included.

**Key findings**

| Aging bucket | Invoices | Outstanding amount | Average outstanding amount |
|---|---:|---:|---:|
| Not yet due | 5 | $7,585.96 | $1,517.19 |
| 1–30 days overdue | 5 | $4,856.48 | $971.30 |
| 31–60 days overdue | 3 | $3,488.32 | $1,162.77 |
| Over 60 days overdue | 49 | $67,037.41 | $1,368.11 |
| **Total** | **62** | **$82,968.17** | — |

- 49 invoices were overdue by more than 60 days.
- Their outstanding balance amounted to **$67,037.41**.
- This represents approximately **80.8% of the total outstanding balance**.
- Only 5 invoices were not yet due at the reporting date.

**Business interpretation**

The aging analysis indicates a significant concentration of outstanding balances in invoices overdue by more than 60 days.

This suggests that overdue invoices represent the largest area requiring attention within the accounts payable dataset.

The aging analysis is particularly useful for prioritizing payment follow-ups and identifying potential liquidity and supplier relationship risks.

However, the results should be interpreted in the context of the synthetic dataset. They do not represent verified real-world payment delays or actual financial risk.

---

## 08.5 Payment Performance by Supplier

**Purpose**

This query compares supplier payment performance by evaluating whether invoices were paid on time or after their due dates.

**Key metrics**

- Number of fully paid invoices
- Number of on-time payments
- Number of late payments
- On-time payment rate
- Average days to payment
- Average days from due date to final payment

**Methodology**

Payment transactions are aggregated by invoice to identify the final payment date.

Only fully paid invoices are included in the analysis. The final payment date is compared with the invoice due date to classify each payment as on time or late.

The average payment duration measures the number of days between the invoice date and the final payment date.

The average number of days from the due date to final payment indicates whether invoices were generally paid before or after their due dates:

- Positive values indicate late payment.
- Zero indicates payment on the due date.
- Negative values indicate early payment.

Only payments made before 1 November 2026 are considered.

**Key findings**

- Vertex Retail Supply recorded the highest on-time payment rate at **60.00%**.
- Global Garment Partners and Metro Basics Trading followed with **50.00%**.
- BluePeak Clothing Co. recorded the lowest on-time payment rate at **22.22%**.
- Northstar Apparel Ltd. had the highest number of fully paid invoices, with 9.
- Pacific Fashion Supply and Luxe Fashion Wholesale had relatively high average payment durations of 61.25 and 63.25 days, respectively.
- The average number of days from the due date to final payment was positive for every supplier.

Across the 107 fully paid invoices, there were 37 on-time payments and 70 late payments, resulting in an overall on-time payment rate of approximately **34.58%**.

**Business interpretation**

The results indicate differences in payment behavior across suppliers.

Vertex Retail Supply achieved the highest on-time payment rate, while BluePeak Clothing Co. had the lowest rate among the analyzed suppliers.

The average days from the due date to final payment provide additional context. For example, some suppliers have relatively low on-time payment rates but average delays of only a few days.

This distinction is important because the on-time payment rate measures the frequency of late payments, whereas the average delay measures their typical duration.

The results can support supplier payment performance monitoring and help identify suppliers whose invoices are frequently settled after their due dates.

The analysis includes only fully paid invoices. Consequently, invoices that remain unpaid or partially paid are not represented in these performance metrics.

---

## 08.6 Monthly Payment Activity

**Purpose**

This query analyzes monthly supplier payment activity and identifies changes in payment volume and value over time.

**Key metrics**

- Number of payment transactions
- Number of distinct invoices paid
- Total monthly payment value
- Average payment amount

**Methodology**

Payment transactions are grouped by calendar month using the payment date.

The query calculates the number of payment transactions, the number of distinct invoices associated with those transactions, the total payment value, and the average payment amount.

Only payments made before 1 November 2026 are included.

An invoice may appear in multiple months if it was settled through multiple payment transactions. Therefore, the number of distinct invoices is not necessarily additive across months.

**Key findings**

- Payment activity was observed from February 2025 through October 2026.
- October 2025 recorded the highest number of payment transactions, with 13.
- July 2025 recorded the highest monthly payment value at **$12,097.30**.
- October 2026 recorded a monthly payment value of **$9,853.47**.
- Monthly payment values varied over the analyzed period, reflecting differences in payment volume and transaction amounts.

**Business interpretation**

Monthly payment activity provides an overview of how supplier payments are distributed over time.

The analysis can help identify periods with higher payment volumes and support cash flow monitoring and short-term financial planning.

The number of transactions and total payment value should be considered together. A month with more transactions does not necessarily have the highest total payment value, as individual payment amounts may differ.

---

## Overall Conclusions

The Accounts Payable analysis provides insight into supplier invoice values, payment status, outstanding balances, overdue liabilities, and payment performance.

The main findings are:

1. **Supplier exposure:** Summit Outdoor Goods recorded the highest invoice value and the highest outstanding balance among suppliers.
2. **Outstanding liabilities:** The total outstanding invoice balance amounted to $82,968.17 as of 31 October 2026.
3. **Invoice aging:** Approximately 80.8% of the outstanding balance was overdue by more than 60 days.
4. **Payment performance:** The overall on-time payment rate among fully paid invoices was approximately 34.58%.
5. **Supplier differences:** Vertex Retail Supply recorded the highest on-time payment rate, while BluePeak Clothing Co. recorded the lowest.
6. **Payment activity:** Monthly payment values varied over time, providing a basis for monitoring payment patterns and cash flow.

### Data Limitations

The analysis is based on a synthetic dataset and should be treated as a portfolio demonstration rather than a representation of actual company financial records.

Important limitations include:

- Supplier invoices and payments are synthetically generated.
- The dataset does not establish whether recorded invoices have been independently approved or reconciled with accounting records.
- The payment-status classification contains five records where the reported `partially_paid` status is inconsistent with the displayed paid and outstanding amounts. These records require precision and rounding validation.
- Payment performance is calculated only for fully paid invoices.
- Outstanding balances do not necessarily represent overdue liabilities.
- The aging analysis uses 31 October 2026 as a fixed reporting date.
- Monthly payment activity reflects payment transactions, not necessarily the number of invoices fully settled during each month.

The results are intended to demonstrate SQL-based financial analysis, invoice reconciliation logic, accounts payable monitoring, and the interpretation of operational financial metrics.

**Business interpretation**

The results highlight differences in outstanding financial exposure across suppliers.

Summit Outdoor Goods represents the largest outstanding balance, making it the supplier with the highest recorded accounts payable exposure
