INSERT INTO address (id, street, city, state, zip) VALUES
(1, '72 North Canyon Road', 'Provo', 'UT', '84604'),
(2, '184 West Center Street', 'Provo', 'UT', '84601'),
(3, '905 East 900 South', 'Salt Lake City', 'UT', '84105'),
(4, '1187 Maple Avenue', 'Provo', 'UT', '84604'),
(5, '44 University Parkway', 'Orem', 'UT', '84058'),
(6, '612 Oak Street', 'Salt Lake City', 'UT', '84102'),
(7, '901 Birch Lane', 'Provo', 'UT', '84606'),
(8, '328 West 300 North', 'Orem', 'UT', '84057'),
(9, '215 Canyon View Drive', 'Provo', 'UT', '84604'),
(10, '56 South Main Street', 'Spanish Fork', 'UT', '84660'),
(11, '771 East 400 North', 'Provo', 'UT', '84606'),
(12, '239 Center Street', 'Orem', 'UT', '84057'),
(13, '415 West 200 South', 'Salt Lake City', 'UT', '84101'),
(14, '1010 East 800 North', 'Provo', 'UT', '84604'),
(15, '24 North 500 West', 'American Fork', 'UT', '84003'),
(16, '138 South 700 East', 'Provo', 'UT', '84606'),
(17, '890 West 100 South', 'Orem', 'UT', '84058'),
(18, '303 East 600 South', 'Salt Lake City', 'UT', '84111'),
(19, '450 North 200 East', 'Provo', 'UT', '84606');

INSERT INTO person (id, first_name, last_name, phone_number, age, gender, address_id) VALUES
(1, 'Maya', 'Chen', '801-555-0101', 34, 'Female', 1),
(2, 'Ethan', 'Brooks', '801-555-0102', 41, 'Male', 2),
(3, 'Sofia', 'Martinez', '801-555-0103', 29, 'Female', 3),
(4, 'Avery', 'Johnson', '801-555-0104', 26, 'Nonbinary', 4),
(5, 'Noah', 'Williams', '801-555-0105', 38, 'Male', 5),
(6, 'Isabella', 'Davis', '801-555-0106', 22, 'Female', 6),
(7, 'Liam', 'Wilson', '801-555-0107', 31, 'Male', 7),
(8, 'Amara', 'Patel', '801-555-0108', 45, 'Female', 8),
(9, 'Lucas', 'Garcia', '801-555-0109', 27, 'Male', 9),
(10, 'Zoe', 'Thompson', '801-555-0110', 36, 'Female', 10),
(11, 'Caleb', 'Anderson', '801-555-0111', 19, 'Male', 11),
(12, 'Nina', 'Roberts', '801-555-0112', 52, 'Female', 12),
(13, 'Owen', 'Kim', '801-555-0113', 24, 'Male', 13),
(14, 'Leila', 'Hassan', '801-555-0114', 33, 'Female', 14),
(15, 'Mateo', 'Rivera', '801-555-0115', 40, 'Male', 15),
(16, 'Grace', 'Bennett', '801-555-0116', 28, 'Female', 16),
(17, 'Henry', 'Clark', '801-555-0117', 47, 'Male', 17),
(18, 'Priya', 'Shah', '801-555-0118', 30, 'Female', 18),
(19, 'Jack', 'Foster', '801-555-0119', 39, 'Male', 19);

INSERT INTO staff (id, person_id, role, hire_date) VALUES
(1, 1, 'Nurse', '2021-04-12'),
(2, 2, 'Coordinator', '2019-08-05'),
(3, 3, 'Technician', '2023-02-20');

INSERT INTO donor (id, person_id, blood_type, rh_factor) VALUES
(1, 4, 'O', 1),
(2, 5, 'A', 1),
(3, 6, 'B', 0),
(4, 7, 'AB', 1),
(5, 8, 'O', 0),
(6, 9, 'A', 0),
(7, 10, 'B', 1),
(8, 11, 'O', 1),
(9, 12, 'AB', 0),
(10, 13, 'A', 1),
(11, 14, 'O', 1),
(12, 15, 'B', 0),
(13, 16, 'A', 1),
(14, 17, 'O', 0),
(15, 18, 'AB', 1),
(16, 19, 'B', 1);

INSERT INTO medications (donor_id, name, amount) VALUES
(2, 'Daily multivitamin', 1),
(5, 'Iron supplement', 1),
(9, 'Allergy medication', 10),
(12, 'Vitamin D', 1);

INSERT INTO medical_conditions (donor_id, name, severity) VALUES
(3, 'Seasonal asthma', 'Mild'),
(5, 'Iron deficiency', 'Moderate'),
(9, 'Seasonal allergies', 'Mild'),
(12, 'High blood pressure', 'Moderate');

INSERT INTO locations (id, address_id) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 8);

INSERT INTO staff_to_location (staff_id, location_id) VALUES
(1, 1), (1, 3),
(2, 1), (2, 2), (2, 4),
(3, 2), (3, 3);

INSERT INTO donations (id, donor_id, date, amount, location_id, notes) VALUES
(1, 1, '2025-01-12 09:30:00', 470, 1, 'Whole blood'),
(2, 2, '2025-01-19 11:15:00', 450, 1, 'Whole blood'),
(3, 3, '2025-02-02 13:00:00', 500, 2, 'Whole blood'),
(4, 4, '2025-02-14 10:20:00', 460, 3, 'Whole blood'),
(5, 5, '2025-03-08 08:45:00', 480, 1, 'Whole blood'),
(6, 1, '2025-04-20 12:10:00', 470, 2, 'Whole blood'),
(7, 6, '2025-05-05 14:00:00', 450, 4, 'Whole blood'),
(8, 7, '2025-06-16 09:10:00', 500, 3, 'Whole blood'),
(9, 8, '2025-07-03 10:40:00', 460, 1, 'Whole blood'),
(10, 9, '2025-08-22 15:30:00', 480, 2, 'Whole blood'),
(11, 10, '2025-09-11 11:05:00', 470, 4, 'Whole blood'),
(12, 2, '2025-10-29 08:55:00', 450, 1, 'Whole blood'),
(13, 11, '2025-12-04 13:25:00', 500, 3, 'Whole blood'),
(14, 12, '2026-01-18 09:50:00', 460, 2, 'Whole blood'),
(15, 4, '2026-03-02 12:35:00', 480, 3, 'Whole blood'),
(16, 13, '2026-04-24 10:15:00', 470, 4, 'Whole blood'),
(17, 14, '2026-06-13 14:20:00', 450, 1, 'Whole blood'),
(18, 1, '2026-08-07 09:05:00', 500, 2, 'Whole blood');
