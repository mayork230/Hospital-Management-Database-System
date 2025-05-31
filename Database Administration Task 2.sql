-- Create Database
CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- Create Departments Table
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Create Doctors Table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    department_id INT,
    specialization VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);

-- Create Patients Table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    date_of_birth DATE,
    address VARCHAR(255),
    registration_date DATE NOT NULL
);

-- Create Appointments Table
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date date NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled') NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Create Medical_Records Table
CREATE TABLE Medical_Records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_id INT UNIQUE,
    diagnosis TEXT,
    treatment TEXT,
    record_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) 
) ;

-- Create Billings Table
CREATE TABLE Billings (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(7,2) NOT NULL,
    bill_date DATE NOT NULL,
    paid_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) 
) ;


-- Create Indexes
CREATE INDEX idx_patient_email ON Patients(email);
CREATE INDEX idx_doctor_email ON Doctors(email);
CREATE INDEX idx_appointment_date ON Appointments(appointment_date);


-- Insert Sample Data
-- Insert Departments
INSERT INTO Departments (department_name) VALUES
('Cardiology'),
('Pediatrics'),
('Orthopedics');

-- Insert Doctors
INSERT INTO Doctors (first_name, last_name, email, phone, department_id, specialization) VALUES
('Emma', 'Wilson', 'emma.wilson@hospital.com', '2345678901', 1, 'Cardiologist'),
('James', 'Brown', 'james.brown@hospital.com', '3456789012', 2, 'Pediatrician');

-- Insert Patients
INSERT INTO Patients (first_name, last_name, email, phone, date_of_birth, address, registration_date) VALUES
('Sarah', 'Davis', 'sarah.davis@example.com', '4567890123', '1990-03-15', '123 Maple St', '2025-01-10'),
('Michael', 'Lee', 'michael.lee@example.com', '5678901234', '1985-07-22', '456 Oak Ave', '2025-02-15');

-- Insert Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status) VALUES
(1, 1, '2025-06-01 10:00:00', 'scheduled'),
(2, 2, '2025-06-02 14:00:00', 'scheduled');

-- Insert Medical Records
INSERT INTO Medical_Records (patient_id, doctor_id, appointment_id, diagnosis, treatment, record_date) VALUES
(1, 1, 1, 'Hypertension', 'Prescribed ACE inhibitors', '2025-06-01');

-- Insert Billings
INSERT INTO Billings (patient_id, appointment_id, amount, bill_date, paid_status) VALUES
(1, 1, 100.00, '2025-06-01', FALSE);


-- Trigger: Update appointment status to 'completed' after medical record creation
DELIMITER //
CREATE TRIGGER after_medical_record_insert
AFTER INSERT ON Medical_Records
FOR EACH ROW
BEGIN
    UPDATE Appointments
    SET status = 'completed'
    WHERE appointment_id = NEW.appointment_id;
END //
DELIMITER ;

-- Trigger: Generate bill after medical record creation
DELIMITER //
CREATE TRIGGER after_medical_record_bill
AFTER INSERT ON Medical_Records
FOR EACH ROW
BEGIN
    DECLARE v_patient_id INT;
    SELECT patient_id INTO v_patient_id
    FROM Appointments
    WHERE appointment_id = NEW.appointment_id;
    
    INSERT INTO Billings (patient_id, appointment_id, amount, bill_date, paid_status)
    VALUES (v_patient_id, NEW.appointment_id, 100.00, CURDATE(), FALSE);
END //
DELIMITER ;


-- View: Upcoming Appointments
CREATE VIEW Upcoming_Appointments AS
SELECT a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,
       d.first_name AS doctor_first_name, d.last_name AS doctor_last_name, d.specialization,
       a.appointment_date, d.department_id
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date >= CURDATE() AND a.status = 'scheduled';

-- SQL Queries for Common Operations
-- 1. List Upcoming Appointments
SELECT * FROM Upcoming_Appointments;
-- 2. View Patient Medical History
SELECT p.first_name, p.last_name, m.diagnosis, m.treatment, m.record_date, d.first_name AS doctor_first_name, d.last_name AS doctor_last_name
FROM Medical_Records m
JOIN Patients p ON m.patient_id = p.patient_id
JOIN Doctors d ON m.doctor_id = d.doctor_id;

-- 3. List Unpaid Bills for a Patient
SELECT b.bill_id, p.first_name, p.last_name, b.amount, b.bill_date
FROM Billings b
JOIN Patients p ON b.patient_id = p.patient_id
WHERE b.paid_status = FALSE;

-- 4. Find Doctors by Department
SELECT d.first_name, d.last_name, d.specialization, de.department_name
FROM Doctors d
JOIN Departments de ON d.department_id = de.department_id;

-- 5. Calculate Total Revenue from Paid Bills
SELECT SUM(amount) AS total_revenue
FROM Billings;
