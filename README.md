# Simulated Airline Database (Python)

## Overview

This project simulates a realistic airline database using Python (Pandas) to support data analytics across operations, 
finance, weather, and customer behavior.
It represents a medium-to-large European airline and allows export to PostgreSQL, CSV collections, or an Excel snapshot.
(For a more detailed version of this readme click [here](DETAILED_DOCUMENTATION.md).)

## Database Usage

- Analyze capacity demand, occupancy, and financial performance
- Evaluate operational reliability and weather impacts
- Study customer behavior, booking, and check-in patterns

## Skills Demonstrated

- **Data Engineering & Simulation Design**  
Creation of a multi-table relational database backed by realistic, interdependent simulation logic 
(operations, weather, demand, customers, finance).
- **Python & Pandas Expertise**  
Complex dataframe generation, transformation, debugging, and export processes, including large-scale multi-day 
scheduling logic.
- **SQL & Database Architecture**  
Design of a fully normalized PostgreSQL schema, including primary/foreign keys, fact tables, and lookup structures.
- **AI-Assisted Development Competence**  
Effective use of ChatGPT for iterative code generation, debugging, and refinement while maintaining critical 
oversight and manual adjustments.
- **Collaborative Development & Workflow Coordination**  
Working jointly on complex simulation logic, coordinating design decisions, reviewing each other’s code, and 
ensuring consistent structure across Python, SQL, and documentation components.
- **Analytical Thinking**  
Ensuring the simulation supports robust evaluations of capacity, financial performance, and operational reliability.
- **Probabilistic, Operational, & Behavioral Modeling**  
Formulation of aircraft rotations, turnaround constraints, weather effects, demand variation, booking behavior, 
demographics, and noise injection for downstream analytics.
- **Performance-Aware Data Output**  
Ability to export to SQL, CSV, and Excel formats depending on downstream analytical requirements.

## Data Generation

**Options**
- SQL Database (PostgreSQL) via SQLAlchemy
- CSV files for use in Pandas, Excel, Power BI, etc.
- Excel workbook (3-week snapshot for size/performance)

**Simulation Period**  
Flexible; at least one year recommended for full realism.

## Project Files

| File                             | Description                                                          |
|----------------------------------|----------------------------------------------------------------------|
| `(0)_create_database.txt`        | Reminder to create/host SQL database manually before running scripts |
| `(1)_create_database_tables.sql` | SQL script to create all required tables                             |
| `(2)_populate_database.ipynb`    | Jupyter Notebook to generate and populate dataframes into SQL or CSV |

## Simulation Features

- **Network**: 42 airports, 142 routes, 264 daily flights
    - Primary hub: Frankfurt (FRA)
    - Secondary hubs: London (LHR), Paris (CDG)
    - ~70% short-haul, ~23% medium-haul, ~7% long-haul
- **Fleet**: 68 aircraft across multiple models and manufacturers
- **Scheduling**: Aircraft assigned based on real availability; multi-day loops and weather effects
- **Weather Simulation**: Localized conditions influence delays and cancellations
- **Demand Modeling**: Affected by season, weekday, holidays, and randomness
- **Operational Realism**: Turnaround time varies by aircraft size and route distance
- **Financial Logic**: Flight costs split into fuel, crew, maintenance, and class-level cost shares
- **Customer Behavior**:
  - Frequent flyer discounts
  - Check-in likelihoods affected by age, gender, and demand
  - Class and nationality patterns influence booking behavior
  - Introduced noise for data cleaning tasks

## Database Tables (Key Structure)

| Table                      | Description                                     | Primary Key(s)                             |
|----------------------------|-------------------------------------------------|--------------------------------------------|
| `airports`                 | Airport info, coordinates, climate data         | `airport_code`                             |
| `aircraft`                 | Fleet info (capacity, range, manufacturer)      | `aircraft_id`                              |
| `routes`                   | Routes, distances, pricing, frequencies         | `line_number`                              |
| `weather`                  | Hourly airport weather observations             | `weather_id`                               |
| `flights`                  | Core fact table (schedule, delay, cancellation) | `(flight_number, flight_date)`             |
| `flight_capacity_by_class` | Seats & bookings per class                      | `(flight_number, flight_date, class_name)` |
| `costs_per_flight`         | Total & component flight costs                  | `(flight_number, flight_date)`             |
| `flight_class_cost_shares` | Class-level cost breakdown                      | `(flight_number, flight_date, class_name)` |
| `frequent_flyer_discounts` | Status tiers & discounts                        | `frequent_flyer_status_code`               |
| `bookings`                 | Customer bookings, payments, refunds            | `booking_id`                               |
| `customers`                | Demographics, nationality, flyer status         | `customer_id`                              |

## Format Conventions

- Dates: `YYYY-MM-DD`
- Timestamps: UTC
- Currency: Euro (€)
- Week start: Monday

## Known Limitations & Future Improvements

- Limited inter-year variation in trends
- Flight scheduling not fully optimized for passenger preferences
- No connecting flights (nonstop only)
- Simplified flyer status logic (future bookings rewarded)
- Nationality not yet distributed per-flight realistically
- Potential extensions: `payments` and `maintenance_records` tables

## Implementation Notes

- Most data generation logic created with ChatGPT-assisted iteration
- Route network and flight assignment logic manually refined for realism and loop stability
- Extensive debugging was required to ensure valid multi-day aircraft scheduling

## Authors
Jan H. Schüttler ([LinkedIn](https://www.linkedin.com/in/jan-heinrich-sch%C3%BCttler-64b872396/)), Behzad Nematipour ([LinkedIn](https://linkedin.com/in/behzad-nematipour-99b8b4399))