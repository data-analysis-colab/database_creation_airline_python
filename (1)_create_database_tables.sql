-- AIRPORTS
CREATE TABLE airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    coordinates POINT,
    climate_region VARCHAR(50),
    hub_status VARCHAR(20)
);

-- AIRCRAFT
CREATE TABLE aircraft(
    aircraft_id      CHAR(10) PRIMARY KEY,
    model            VARCHAR(50),
    manufacturer     VARCHAR(50),
    seat_capacity    INT,
    range_km         INT,
    manufacture_year INT
);

-- ROUTES
CREATE TABLE routes (
    line_number SERIAL PRIMARY KEY,
    departure_airport_code CHAR(3),
    arrival_airport_code CHAR(3),
    distance_km INT,
    flights_per_day INT,
    price_economy DECIMAL(8,2),
    price_business DECIMAL(8,2),
    price_first DECIMAL(8,2),
    FOREIGN KEY (departure_airport_code) REFERENCES airports(airport_code),
    FOREIGN KEY (arrival_airport_code) REFERENCES airports(airport_code),
    CHECK (departure_airport_code != arrival_airport_code)
);

-- WEATHER
CREATE TABLE weather (
    weather_id SERIAL PRIMARY KEY,
    airport_code CHAR(3),
    observation_time TIMESTAMPTZ,
    season VARCHAR(10),
    temperature_celsius DECIMAL(4,1),
    wind_speed_kmh DECIMAL(5,1),
    visibility_km DECIMAL(4,1),
    condition_description VARCHAR(100),
    FOREIGN KEY (airport_code) REFERENCES airports(airport_code)
);

-- FLIGHTS
CREATE TABLE flights (
    flight_number VARCHAR(10),
    flight_date DATE,
    line_number INT,
    aircraft_id VARCHAR(10),
    passengers_total INT,
    scheduled_departure TIMESTAMP,
    scheduled_arrival TIMESTAMP,
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP,
    cancelled BOOLEAN,
    cancellation_reason TEXT,
    delay_reason_dep TEXT,
    delay_reason_arr TEXT,
    PRIMARY KEY (flight_number, flight_date),
    FOREIGN KEY (line_number) REFERENCES routes(line_number),
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id)
);

-- COSTS PER FLIGHT
CREATE TABLE costs_per_flight (
    flight_cost_id VARCHAR(14),
    flight_number VARCHAR(10),
    flight_date DATE,
    flight_cost_total DECIMAL(10,2),
    fuel_cost DECIMAL(10,2),
    crew_cost DECIMAL(10,2),
    maintenance_cost DECIMAL(10,2),
    landing_fees DECIMAL(10,2),
    catering_cost DECIMAL(10,2),
    other_costs DECIMAL(10,2),
    PRIMARY KEY (flight_cost_id),
    FOREIGN KEY (flight_number, flight_date) REFERENCES flights(flight_number, flight_date)
);

-- FLIGHT CAPACITY BY CLASS
CREATE TABLE flight_capacity_by_class (
    flight_number VARCHAR(10),
    flight_date DATE,
    class_name VARCHAR(20),
    capacity INT,
    class_bookings INT,
    PRIMARY KEY (flight_number, flight_date, class_name),
    FOREIGN KEY (flight_number, flight_date) REFERENCES flights(flight_number, flight_date),
    CHECK (class_bookings <= capacity)
);

-- FLIGHT CLASS COST SHARES
CREATE TABLE flight_class_cost_shares (
    cost_share_id VARCHAR(14),
    flight_number VARCHAR(10),
    flight_date DATE,
    class_name VARCHAR(20),
    cost_share NUMERIC(4,2),
    PRIMARY KEY (cost_share_id),
    FOREIGN KEY (flight_number, flight_date) REFERENCES flights(flight_number, flight_date),
    CHECK (cost_share >= 0 AND cost_share <= 1)
);

-- FREQUENT FLYER DISCOUNTS
CREATE TABLE frequent_flyer_discounts (
    frequent_flyer_status_code VARCHAR(10),
    frequent_flyer_status VARCHAR(20),
    min_flights_yearly INT,
    frequent_flyer_discount_pct DECIMAL(5,1),
    PRIMARY KEY (frequent_flyer_status_code)
);

-- CUSTOMERS
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(100),
    date_of_birth DATE,
    nationality VARCHAR(100),
    gender VARCHAR(10),
    frequent_flyer_status_code VARCHAR(10),
    FOREIGN KEY (frequent_flyer_status_code) REFERENCES frequent_flyer_discounts(frequent_flyer_status_code)
);

-- BOOKINGS
CREATE TABLE bookings (
    booking_id SERIAL,
    customer_id INT,
    flight_number VARCHAR(10),
    flight_date DATE NOT NULL,
    booking_time TIMESTAMP,
    class_name VARCHAR(20),
    frequent_flyer_status_code VARCHAR(10),
    price_paid DECIMAL(8,2),
    checked_in BOOLEAN,
    flight_cxl_refund BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (booking_id, flight_date),
    FOREIGN KEY (flight_number, flight_date) REFERENCES flights(flight_number, flight_date),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (frequent_flyer_status_code) REFERENCES frequent_flyer_discounts(frequent_flyer_status_code)
) PARTITION BY RANGE (flight_date);

CREATE TABLE bookings_2022 (
    booking_id SERIAL,
    customer_id INT,
    flight_number VARCHAR(10),
    flight_date DATE NOT NULL,
    booking_time TIMESTAMP,
    class_name VARCHAR(20),
    frequent_flyer_status_code VARCHAR(10),
    price_paid DECIMAL(8,2),
    checked_in BOOLEAN,
    flight_cxl_refund BOOLEAN DEFAULT FALSE
);
CREATE TABLE bookings_2023 (
    booking_id SERIAL,
    customer_id INT,
    flight_number VARCHAR(10),
    flight_date DATE NOT NULL,
    booking_time TIMESTAMP,
    class_name VARCHAR(20),
    frequent_flyer_status_code VARCHAR(10),
    price_paid DECIMAL(8,2),
    checked_in BOOLEAN,
    flight_cxl_refund BOOLEAN DEFAULT FALSE
);
CREATE TABLE bookings_2024 (
    booking_id SERIAL,
    customer_id INT,
    flight_number VARCHAR(10),
    flight_date DATE NOT NULL,
    booking_time TIMESTAMP,
    class_name VARCHAR(20),
    frequent_flyer_status_code VARCHAR(10),
    price_paid DECIMAL(8,2),
    checked_in BOOLEAN,
    flight_cxl_refund BOOLEAN DEFAULT FALSE
);

-- after loading table contents:
ALTER TABLE bookings
    ATTACH PARTITION bookings_2022
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');
ALTER TABLE bookings
    ATTACH PARTITION bookings_2023
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
ALTER TABLE bookings
    ATTACH PARTITION bookings_2024
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');