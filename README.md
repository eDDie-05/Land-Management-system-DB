# Tanzania Land Registration System

## Project Overview
A PostgreSQL-based Land Registration Database System for managing:

- Landowners
- Regions and districts
- Land parcels
- Applications
- Payments
- Land titles
- Ownership transfers
- Land disputes
- User roles and permissions
- Reports and system testing

## Project Structure

### database/
Contains the main database SQL scripts. Add or place the following scripts here:

- 01_create_database.sql
- 02_create_tables.sql
- 03_insert_data.sql
- 04_queries.sql
- 05_views.sql
- 06_functions.sql
- 07_users_permissions.sql
- 08_test_cases.sql

### documentation/
Contains the ERD and final project documentation.

### reports/
Contains SQL scripts used to generate final database reports.

### tests/
Contains the full end-to-end system test.

### presentation/
Contains the Day 21 PowerPoint presentation.

## Running the Project

Connect to PostgreSQL:

```bash
psql -U YOUR_USERNAME -d land_registration_db
```

Run the final reports:

```sql
\i reports/day19_final_reports.sql
```

Run the full system test:

```sql
\i tests/day20_full_test.sql
```

## Final Deliverables

- ERD
- SQL scripts
- Final reports
- Full system test
- Final PowerPoint presentation
- Final project report
