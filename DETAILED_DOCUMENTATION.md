# Simulated Airline-Database Creation (Detailed Documentation)

## Goal

Create a realistic airline database using Python (Pandas) that can be exported to:

- A relational SQL database (PostgreSQL recommended)
- A collection of CSV files
- An Excel workbook (limited snapshot only)

The generated dataset aims to support analysis across:
- Capacity demand and occupancy
- Financial performance
- Operational reliability
- Weather impacts
- Customer behavior and demographics

The simulation balances realism with computational efficiency and can be run for an arbitrary date range 
(one full year recommended for the full feature set).

## Skills Demonstrated

- **End-to-End Data System Construction**  
Building a full synthetic airline database ecosystem – from conceptual schema design to detailed procedural generation
of each table using Python and SQL.
- **Advanced Pandas Workflow Design**  
Crafting complex interlinked dataframes, implementing multistep logic flows (e.g., aircraft availability, 
booking lead times, cost breakdowns), and optimizing for realism and performance.
- **Relational Modeling & SQL Proficiency**  
Implementing a rich, dependency-heavy SQL structure (fact tables, dimensional tables, constraints) and integrating 
it efficiently with Python/SQLAlchemy pipelines.
- **Joint Development & Cross-Workflow Coordination**  
Partnering on complex simulation features, aligning on design choices, conducting mutual code reviews, and 
maintaining a consistent structure across Python code, SQL queries, and project documentation.
- **Collaborative AI Workflow Maturity**  
Demonstrating sophisticated iterative collaboration with ChatGPT – leveraging AI-generated code while applying 
domain expertise to refine, correct, and extend complex logic.
- **Quality Assurance & Iterative Refinement**  
Systematic debugging and reworking of AI-generated logic, especially to prevent aircraft scheduling deadlocks and 
ensure stable multi-day simulation loops.
- **Simulation Engineering & Constraint Handling**  
Modeling realistic route networks, multi-tier hub structures, aircraft utilization constraints, stochastic weather 
disruptions, and customer behavioral patterns.
- **Statistical & Behavioral Logic Implementation**  
Designing probabilistic rules for class choice, check-in likelihoods, age-dependent behavior, nationality patterns, 
seasonal demand, and more.
- **Data Export Strategy & Tooling Awareness**  
Producing SQL databases, CSV collections, and Excel snapshots with awareness of performance limitations and 
use-case specificity.

## Data Generation Options

| Output Format             | Notes                                                                                                                                          |
|---------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| SQL database (PostgreSQL) | Tables populated via SQLAlchemy; recommended default for full simulation horizon                                                               |
| CSV collection            | Suitable for Pandas, Excel, or Power BI (via Power Query)                                                                                      |
| Excel workbook            | Three-week snapshot stored in a single .xlsx file; used when row limits or performance matter                                                  |
| Simulation Period         | Any period is possible. At least one full year is strongly recommended to fully benefit from seasonal, operational, and weather-related logic. |

## Associated Files

| File                             | Description                                                                          |
|----------------------------------|--------------------------------------------------------------------------------------|
| `(0)_create_database.txt`        | Reminder to create or host a PostgreSQL instance before running scripts              |
| `(1)_create_database_tables.sql` | SQL schema for all required tables                                                   |
| `(2)_populate_database.ipynb`    | Jupyter notebook that generates the simulation data and writes SQL/CSV/Excel outputs |

## Key Realism Features

- **Airline Network**
  - 42 airports across Europe, Middle East, and long-haul destinations
  - 142 routes with reverse counterparts
  - ~264 flights per day, distributed by distance category:
    - ~70% short-haul (< 1500 km)
    - ~20–25% medium-haul (1500–5000 km)
    - ~7.5% long-haul (> 5000 km)
  - Hubs:
    - Primary: Frankfurt (FRA)
    - Secondary: London (LHR), Paris (CDG)

- **Fleet**
  - 68 aircraft across multiple manufacturers and models
  - Realistic seat capacity, range, and assignment rules
  - Range limits determine which aircraft can serve which routes

- **Scheduling Logic**
  - Aircraft availability tracked across days and across airports
  - Turnaround time depends on:
    - Aircraft size
    - Previous flight distance
  - Departure times are constrained by scheduling logic, which can create natural concentrations of early-morning flights
  - Flights are always nonstop (layovers excluded for performance reasons)

- **Weather Simulation**
  - Hourly weather observations per airport
  - Local climate conditions determine:
    - Visibility
    - Temperature
    - Wind speed
    - Precipitation
  - Weather influences delays and cancellations

- **Demand Modeling**  
Route-level demand varies by:
  - Season
  - Weekday
  - Holidays
  - Distance category
  - Random variation

  Passenger-class seat allocation depends on aircraft capacity and distance category.

- **Financial Modeling**
  - Each flight receives a total cost based on:
    - Fuel
    - Crew
    - Maintenance
    - Other operational cost buckets
  - Costs are distributed to passenger classes for class-level profitability analysis
  - Ticket price discounts are applied based on frequent flyer status

- **Customer Behavior Logic**  
Customer demographic attributes influence booking and flight behavior:
  - Age and gender → class choice, check-in likelihood, booking lead time
  - Nationality → time-of-day booking tendencies
  - Frequent flyer status → discounts, price modifiers
  - Customer noise: typos, missing fields, and inconsistent formatting introduced intentionally

  Nationality distribution of the customer base is approximate and corresponds to how often airports in those 
  countries are served – but not at the individual-flight level.

## Limitations & Potential Improvements

- **Randomness & Variation**
  - Large samples sometimes appear more uniformly distributed than real data
  - Limited inter-year variation (e.g., financial or operational trends)

- **Scheduling Constraints**
  - Many flights depart early due to the availability-based assignment method
  - No modeling of connecting flights
  - Long-haul fleet consists of only the longest-range aircraft to simplify assignment logic

- **Frequent Flyer Logic**  
Current implementation assigns flyer status based on a customer’s average yearly flights and applies discounts 
retrospectively across the entire simulation period.

  **Realistic alternative**
  - Earn points per booking
  - Update flyer status dynamically during the simulation
  - Apply discounts only to future bookings

- **Nationality Distribution**  
Nationality is not realistically distributed per flight  
(e.g., a Paris → Dubai flight won’t necessarily contain more French passengers)  
Improving this is straightforward but significantly increases computation time.

- **Additional Table Opportunities**  
Potential enhancements:
  - `payments` table for detailed payment tracking
  - `maintenance_records` table for maintenance history and cost integration

## Table Overview (Key Columns Only)

| Table                      | Description                                     | Primary Key(s)                             | Notes                                   |
|----------------------------|-------------------------------------------------|--------------------------------------------|-----------------------------------------|
| `airports`                 | Airport names, locations, climate               | `airport_code`                             | Used for distance & weather logic       |
| `aircraft`                 | Model, manufacturer, capacity, range            | `aircraft_id`                              | Range determines route eligibility      |
| `routes`                   | Distances, pricing, flights per day             | `line_number`                              | Links airports and defines schedule     |
| `weather`                  | Hourly weather by airport                       | `weather_id`                               | Drives delays & cancellations           |
| `flights`                  | Daily flight schedule & operational performance | `(flight_number, flight_date)`             | Core fact table                         |
| `flight_capacity_by_class` | Seats & bookings per class                      | `(flight_number, flight_date, class_name)` |                                         |
| `costs_per_flight`         | Total & component flight costs                  | `(flight_number, flight_date)`             |                                         |
| `flight_class_cost_shares` | Class-level cost allocation                     | `(flight_number, flight_date, class_name)` |                                         |
| `frequent_flyer_discounts` | Status tiers, requirements, discounts           | `frequent_flyer_status_code`               |                                         |
| `bookings`                 | Customer bookings, payments, refunds            | `booking_id`                               | Links to flights & customers            |
| `customers`                | Demographics, nationality, flyer status         | `customer_id`                              | Contains intentional data quality noise |

## Procedural Notes

### AI-Assisted Development

- Most data-generation logic was developed iteratively using ChatGPT, with extensive refinements after reviewing
  intermediate outputs.
- Several components required deep redesign to ensure realism, consistency, and performance.

### Manual Refinements

- **Route Network Design**  
Randomly generated route networks were unrealistic.
The final network uses curated rules:
  - All airports connect to FRA
  - Long-haul routes connect only to FRA
  - Medium-haul routes link FRA, LHR, and CDG to Middle Eastern airports
  - Short- and medium-haul: 2 flights/day
  - Long-haul: 1 flight/day
  - All routes include reverse directions

- **Flight Assignment Stability**  
The original AI-generated logic frequently left aircraft “stranded” at airports, causing cascading cancellations.  
The final version includes heavily revised:
  - Multi-day aircraft scheduling
  - Robust availability tracking
  - Constraints that prevent dead-end aircraft placements

More details are available inside the [Jupyter notebook]((2)_populate_database.ipynb).