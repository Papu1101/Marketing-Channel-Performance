# Marketing Channel Performance

## 📊 Project Overview

This project analyzes six months of marketing channel and campaign performance using **PostgreSQL**.

The analysis focuses on understanding how paid marketing campaigns perform across the acquisition funnel — from impressions and clicks to signups, paying subscribers, and first-90-day revenue.

The goal is to evaluate marketing efficiency, compare paid and unpaid acquisition, identify performance trends, and develop a data-driven framework for allocating the next six months of marketing budget.

---

## 🎯 Business Objective

The marketing team wants to understand:

* Which campaigns generate the most efficient traffic?
* Which campaigns acquire the most customers?
* How efficiently do signups convert into paying subscribers?
* Which channels generate the strongest return on advertising spend?
* How does paid acquisition compare with organic and referral acquisition?
* Which campaigns stopped running during the six-month period?
* How should the marketing budget be allocated for the next six months?

---

## 📁 Dataset

The project uses two datasets:

### `svgad_spend.csv`

Contains advertising performance data including:

* Date
* Marketing channel
* Campaign
* Impressions
* Clicks
* Spend

### `svgsignups.csv`

Contains customer acquisition and subscription data including:

* User ID
* Signup date
* Marketing channel
* Campaign
* Subscription start date
* Plan
* First-90-day revenue

The data includes both paid and unpaid acquisition sources such as:

* Paid Search
* Paid Social
* Display
* Affiliate
* Organic
* Referral

---

## 🛠️ Tools

* **PostgreSQL**
* **SQL**
* **pgAdmin 4**

---

## 🔍 Analysis Workflow

### 1. Data Validation & Standardization

Validated the source data for:

* Duplicate records
* Missing values
* Invalid numeric values
* Clicks greater than impressions
* Channel and campaign naming inconsistencies

Standardized channel and campaign names using lowercase formatting and underscores to create reliable join keys.

---

### 2. Campaign Performance

Calculated campaign-level marketing metrics:

* Total Spend
* Impressions
* Clicks
* Click-Through Rate (CTR)
* Cost Per Click (CPC)

These metrics help evaluate how efficiently campaigns generate traffic.

---

### 3. Campaign Outcomes

Connected advertising spend with customer outcomes to calculate:

* Total Signups
* Paying Subscribers
* Signup-to-Paid Conversion Rate
* Cost Per Signup
* Cost Per Paying Subscriber
* First-90-Day Revenue
* Return on Ad Spend (ROAS)

---

### 4. Paid vs. Unpaid Acquisition

Compared paid acquisition with:

* Organic
* Referral

The analysis evaluates signup-to-paying conversion rates to understand differences between paid and unpaid customer acquisition.

---

### 5. Six-Month Performance Trends

Analyzed monthly marketing performance to identify:

* Monthly advertising spend
* Impressions
* Clicks
* CTR
* CPC
* Active campaigns
* Campaigns that stopped running
* Monthly signup and subscription trends

---

### 6. Channel Evaluation

Evaluated marketing channels using multiple efficiency metrics:

| Metric                     | Purpose                                                  |
| -------------------------- | -------------------------------------------------------- |
| CPC                        | Measures traffic acquisition efficiency                  |
| Cost Per Signup            | Measures signup acquisition efficiency                   |
| Cost Per Paying Subscriber | Measures customer acquisition efficiency                 |
| ROAS                       | Measures revenue generated relative to advertising spend |

ROAS provides a revenue-based view of campaign performance, while the other metrics help explain differences in traffic and customer acquisition efficiency.

---

### 7. Budget Allocation Framework

Developed a risk-aware framework for allocating the next six months of marketing budget.

The recommendation combines:

* **70% ROAS performance signal**
* **30% historical spending signal**

This approach avoids allocating the entire budget based only on historical ROAS and accounts for the fact that campaign performance may change as spending increases.

---

## 📈 Key Business Considerations

The analysis highlights several important considerations when evaluating marketing performance:

* High traffic efficiency does not necessarily translate into high customer conversion.
* A campaign can generate many signups while producing relatively few paying subscribers.
* ROAS can provide a different ranking from CPC or cost per signup because it incorporates revenue.
* Historical performance may not remain constant when budgets increase.
* First-90-day revenue does not capture the full potential lifetime value of customers.
* Campaign performance should be monitored after budget changes to identify diminishing returns.
* Historical correlations between spend and revenue should not automatically be interpreted as causal effects.

---

## 📂 Project Structure

```text
Marketing-Channel-Performance/
│
├── data/
│   ├── svgad_spend.csv
│   └── svgsignups.csv
│
├── sql/
│   ├── 01_data_validation_and_standardization.sql
│   ├── 02_campaign_performance.sql
│   ├── 03_campaign_outcomes.sql
│   ├── 04_paid_vs_unpaid.sql
│   ├── 05_monthly_performance.sql
│   ├── 06_channel_evaluation.sql
│   └── 07_budget_recommendation.sql
│
├── outputs/
│   └── campaign_metrics.xlsx
│
└── README.md
```

---

## 📊 Final Deliverable

The project includes a campaign-level performance table containing:

* Channel
* Campaign
* Total Spend
* Impressions
* Clicks
* CTR
* CPC
* Total Signups
* Paying Subscribers
* Signup-to-Paid Rate
* Cost Per Signup
* Cost Per Paying Subscriber
* First-90-Day Revenue
* ROAS

---

## 💡 Conclusion

This project demonstrates how SQL can be used to move from raw marketing data to actionable business analysis.

By connecting advertising spend with customer acquisition and revenue outcomes, the analysis provides a structured view of marketing channel performance and a framework for making future budget allocation decisions.

---

## 👤 Author

**Papu**

Data Analyst | SQL | Python | Power BI | Excel

---

## 📌 Dataset Source

Dataset provided by **Data Career School** and used for portfolio/practice purposes.
