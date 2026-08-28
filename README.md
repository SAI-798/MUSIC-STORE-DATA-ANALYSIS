* # 🎧 Music Store Data Analysis: Main Character Energy 💅

> **TL;DR:** We took raw transactional music store data, threw it into **MySQL Workbench**, ran high-key sophisticated CTEs and Window Functions, and pulled actionable business insights. No boring basic queries allowed. 🚀



## 📁 Repository Structure

* 📜 [SQL Queries & Analysis Script](MUSIC_STORE.sql)
* 📄 [Music Store Data Schema (PDF)](music%20data%20schema.pdf)


---

## ☕ What’s the Tea? (Executive Summary)

Instead of just running plain `SELECT * FROM table`, this project breaks down how a digital media store actually makes money, retains top listeners, and cleans up catalog clutter. 

### Key Takeaways (Real Business Value):
* 🌍 **Global Footprint Hits Different:** Top revenue streams are heavily concentrated in 3 regions (USA, Canada, Brazil). Secondary markets need localized promos ASAP.
* 🎸 **Rock is Still Goated:** Rock & Metal carry volume sales, but niche genres drive higher average spend per transaction.
* 💸 **Whales & VIP Listeners:** Top-tier spenders drive the majority of margin—re-engagement automations are needed before they churn.

---

## 🛠️ The Tech Stack (No Cap)

* **Engine:** MySQL 8.0+
* **IDE:** MySQL Workbench
* **Flexing These Skills:**
  * 🪟 **Window Functions:** `ROW_NUMBER()`, `PARTITION BY` for ranking top genres and top country spenders.
  * 🧱 **CTEs (Common Table Expressions):** Modular `WITH` clauses for clean, non-spaghetti code.
  * 🧹 **Data Wrangling & Schema Fixes:** Enforcing PK/FK constraints, handling nulls, and resolving data loading choke points (`LOAD DATA INFILE`).

---

## 📁 Repo Architecture

```text
├── DATA/                       # Raw CSVs & Dataset files
├── MUSIC_STORE.sql             # The whole SQL script (Schema + Analytics)
├── music data schema.pdf       # Database ERD/Schema visual
└── README.md                   # You are here!
