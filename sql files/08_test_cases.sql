-- ============================================
-- 07_integrity_tests.sql
-- Day 17 — Integrity Testing
-- Land Registration Database
-- ============================================

-- IMPORTANT:
-- Each test below is expected to fail because it deliberately
-- violates an integrity constraint.
--
-- Run the tests one at a time.
-- If a test unexpectedly succeeds, use the cleanup command shown.


-- ============================================
-- TEST 1: DUPLICATE TITLE NUMBER
-- ============================================

-- Expected result:
-- ERROR: duplicate key value violates unique constraint
-- "titles_title_number_key"

INSERT INTO titles (
    title_number,
    parcel_id,
    issue_date,
    expiry_date,
    status
)
VALUES (
    'TITLE-001',     -- Already exists
    1016,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '99 years',
    'ACTIVE'
);


-- ============================================
-- TEST 2: INVALID FOREIGN KEY
-- ============================================

-- Expected result:
-- ERROR: insert or update violates foreign key constraint
-- because applicant_id 9999 does not exist in landowners.

INSERT INTO applications (
    application_number,
    applicant_id,
    parcel_id,
    application_type
)
VALUES (
    'APP-INVALID-FK',
    9999,            -- Non-existent owner
    1001,
    'First Registration'
);


-- ============================================
-- TEST 3: NEGATIVE LAND AREA
-- ============================================

-- Expected result:
-- ERROR: new row violates check constraint
-- "land_parcels_area_size_sqm_check"

INSERT INTO land_parcels (
    plot_number,
    block_number,
    area_size_sqm,
    land_use,
    location,
    district_id,
    current_owner_id
)
VALUES (
    'TEST-NEG-AREA',
    'TEST-BLK',
    -500.00,         -- Invalid negative area
    'Residential',
    'Training Location',
    100,
    1
);


-- ============================================
-- TEST 4: MISSING REQUIRED FIELD
-- ============================================

-- Expected result:
-- ERROR: null value violates not-null constraint
-- because first_name is required.

INSERT INTO landowners (
    first_name,
    last_name,
    national_id_sample,
    phone
)
VALUES (
    NULL,            -- Required field intentionally missing
    'TestOwner',
    'TZ-TEST-999',
    '+255700000999'
);


-- ============================================
-- OPTIONAL VERIFICATION QUERIES
-- ============================================

-- These queries help verify that invalid records were not inserted.

SELECT *
FROM titles
WHERE title_number = 'TITLE-001';

SELECT *
FROM applications
WHERE application_number = 'APP-INVALID-FK';

SELECT *
FROM land_parcels
WHERE plot_number = 'TEST-NEG-AREA';

SELECT *
FROM landowners
WHERE national_id_sample = 'TZ-TEST-999';


-- ============================================
-- DAY 17 TEST RESULTS DOCUMENTATION
-- ============================================

/*
Test 1: Duplicate title number
Expected: INSERT should fail because title_number must be unique.
Actual: Record the PostgreSQL result after running the test.
Status: PASS if PostgreSQL rejects the duplicate.

Test 2: Invalid foreign key
Expected: INSERT should fail because applicant_id must reference
an existing landowners.owner_id.
Actual: Record the PostgreSQL result after running the test.
Status: PASS if PostgreSQL rejects the invalid reference.

Test 3: Negative land area
Expected: INSERT should fail because area_size_sqm must be greater than 0.
Actual: Record the PostgreSQL result after running the test.
Status: PASS if PostgreSQL rejects the negative area.

Test 4: Missing required field
Expected: INSERT should fail because first_name cannot be NULL.
Actual: Record the PostgreSQL result after running the test.
Status: PASS if PostgreSQL rejects the missing required value.
*/
