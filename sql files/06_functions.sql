
CREATE OR REPLACE FUNCTION create_training_application(
    p_application_number VARCHAR(30),
    p_applicant_id INTEGER,
    p_parcel_id INTEGER,
    p_application_type VARCHAR(30)
)
RETURNS TABLE (
    application_id INTEGER,
    application_number VARCHAR(30),
    applicant_id INTEGER,
    parcel_id INTEGER,
    application_type VARCHAR(30),
    application_date DATE,
    status VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    INSERT INTO applications (
        application_number,
        applicant_id,
        parcel_id,
        application_type
    )
    VALUES (
        p_application_number,
        p_applicant_id,
        p_parcel_id,
        p_application_type
    )
    RETURNING
        applications.application_id,
        applications.application_number,
        applications.applicant_id,
        applications.parcel_id,
        applications.application_type,
        applications.application_date,
        applications.status;
END;
$$;


-- ============================================
-- TEST WITH FICTIONAL DATA
-- ============================================

-- Uses existing fictional owner ID 16 and parcel ID 1016.
-- APP-TRAIN-001 is a new fictional application number.

SELECT *
FROM create_training_application(
    'APP-TRAIN-001',
    16,
    1016,
    'First Registration'
);


-- Verify that the application was created.
SELECT *
FROM applications
WHERE application_number = 'APP-TRAIN-001';


-- ============================================
-- OPTIONAL CLEANUP
-- ============================================

-- Run this only if you want to remove the test data.
-- DELETE FROM applications
-- WHERE application_number = 'APP-TRAIN-001';
