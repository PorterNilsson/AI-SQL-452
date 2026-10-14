PRAGMA foreign_keys = ON;

CREATE TABLE address (
    id INTEGER PRIMARY KEY,
    street TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    zip TEXT NOT NULL
);

CREATE TABLE person (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    age INTEGER NOT NULL CHECK (age BETWEEN 18 AND 120),
    gender TEXT NOT NULL CHECK (gender IN ('Female', 'Male', 'Nonbinary', 'Prefer not to say')),
    address_id INTEGER NOT NULL UNIQUE,
    FOREIGN KEY (address_id) REFERENCES address(id)
);

CREATE TABLE staff (
    id INTEGER PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE,
    role TEXT NOT NULL CHECK (role IN ('Nurse', 'Coordinator', 'Technician', 'Administrator')),
    hire_date TEXT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE donor (
    id INTEGER PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE,
    blood_type TEXT NOT NULL CHECK (blood_type IN ('A', 'B', 'AB', 'O')),
    rh_factor INTEGER NOT NULL CHECK (rh_factor IN (0, 1)),
    FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE medications (
    donor_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    amount INTEGER NOT NULL CHECK (amount > 0),
    FOREIGN KEY (donor_id) REFERENCES donor(id)
);

CREATE TABLE medical_conditions (
    donor_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('Mild', 'Moderate', 'Severe')),
    FOREIGN KEY (donor_id) REFERENCES donor(id)
);

CREATE TABLE locations (
    id INTEGER PRIMARY KEY,
    address_id INTEGER NOT NULL UNIQUE,
    FOREIGN KEY (address_id) REFERENCES address(id)
);

CREATE TABLE staff_to_location (
    staff_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    PRIMARY KEY (staff_id, location_id),
    FOREIGN KEY (staff_id) REFERENCES staff(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

CREATE TABLE donations (
    id INTEGER PRIMARY KEY,
    donor_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    amount INTEGER NOT NULL CHECK (amount > 0),
    location_id INTEGER NOT NULL,
    notes TEXT,
    FOREIGN KEY (donor_id) REFERENCES donor(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

CREATE INDEX idx_donations_donor_id ON donations(donor_id);
CREATE INDEX idx_donations_location_id ON donations(location_id);
CREATE INDEX idx_donations_date ON donations(date);
