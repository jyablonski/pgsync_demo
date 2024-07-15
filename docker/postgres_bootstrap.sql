ALTER SYSTEM SET wal_level = logical;
ALTER SYSTEM SET max_replication_slots = 5;
ALTER ROLE postgres WITH REPLICATION;

create schema source;
set search_path to source;

CREATE TABLE venues (
    id serial PRIMARY KEY,
    venue_name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the events table
CREATE TABLE events (
    id serial PRIMARY KEY,
    venue_id INTEGER NOT NULL,
    event_name VARCHAR(255) NOT NULL,
    event_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (venue_id) REFERENCES venues(id)
);

-- Create the customer_event_bookings table
CREATE TABLE customer_event_bookings (
    id serial PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    seat_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id)
);


INSERT INTO venues (venue_name, address, city, state, postal_code, created_at, updated_at) VALUES
('Madison Square Garden', '4 Pennsylvania Plaza', 'New York', 'NY', '10001', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Staples Center', '1111 S Figueroa St', 'Los Angeles', 'CA', '90015', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Wembley Stadium', 'Wembley', 'London', 'London', 'HA9 0WS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Sydney Opera House', 'Bennelong Point', 'Sydney', 'NSW', '2000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Tokyo Dome', '1-3-61 Koraku', 'Tokyo', 'Tokyo', '112-0004', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO events (venue_id, event_name, event_date, created_at, updated_at) VALUES
(1, 'Rock Concert 2024', '2024-08-15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'NBA Finals Game 1', '2024-06-05', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'FA Cup Final', '2024-05-18', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'Opera Night: Verdi La Traviata', '2024-09-20', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'Baseball World Series', '2024-10-22', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
