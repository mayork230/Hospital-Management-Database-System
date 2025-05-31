# Hospital Management System Database

![Firefly_Healthcare Database 174917](https://github.com/user-attachments/assets/6cd4f12b-5dd5-44e4-ba0f-9d743c29fcc7)


## Overview
This project provides a MySQL-based relational database for a Hospital Management System. It manages hospital operations, including patients, doctors, appointments, medical records, departments, and billing. The database is designed with normalized tables, foreign key constraints, triggers, views, and stored procedures to ensure data integrity and support efficient hospital operations.

## Features
- Patient Management: Store patient details (name, contact, medical history).
- Doctor Management: Track doctor information and specialties by department.
- Appointments: Schedule and manage patient-doctor appointments.
- Medical Records: Record diagnoses and treatments linked to appointments.
- Billing: Handle billing for services with payment status tracking.
- Departments: Categorize doctors by department (e.g., Cardiology, Pediatrics).
- Triggers: Automate appointment status updates and bill generation.
- Views: Provide quick access to upcoming appointments.
- Stored Procedures: Simplify scheduling appointments and adding medical records.

# Database Schema
The database includes the following tables:

- Departments: Stores hospital departments.
- Doctors: Stores doctor details with department affiliation.
- Patients: Stores patient information.
- Appointments: Tracks patient-doctor appointments.
- Medical_Records: Records patient diagnoses and treatments.
- Billings: Manages billing for appointments and treatments.

# Relationships
Many-to-one: Doctors → Departments, Appointments → Patients, Appointments → Doctors, Medical_Records → Patients, Medical_Records → Doctors, Billings → Patients, Billings → Appointments.
One-to-one: Medical_Records → Appointments.

# Future Enhancements
Add triggers for dynamic bill amount calculation based on treatment.
Implement stored procedures for canceling appointments or updating patient records.
Include staff management (e.g., nurses, admins).
Add room or equipment allocation for appointments.
Optimize for large datasets with additional indexes or partitioning.
