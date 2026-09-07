-- ============================================
-- DAY 20: FULL SYSTEM TEST
-- LAND REGISTRATION DATABASE
-- ============================================


-- ============================================
-- STEP 1: REGISTER A NEW FICTIONAL LANDOWNER
-- ============================================

INSERT INTO landowners (
    first_name,
    middle_name,
    last_name,
    gender,
    national_id_sample,
    phone,
    email,
    address
)
VALUES (
    'James',
    'Peter',
    'Mashauri',
    'M',
    'TZ-100021',
    '+255712000021',
    'james.mashauri@example.com',
    'Dodoma, Tanzania'
);

SELECT *
FROM landowners
WHERE national_id_sample = 'TZ-100021';


-- ============================================
-- STEP 2: REGISTER A NEW LAND PARCEL
-- ============================================

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
    'PL021',
    'BLK-K1',
    1000.00,
    'Residential',
    'Kibaigwa',
    600,
    (
        SELECT owner_id
        FROM landowners
        WHERE national_id_sample = 'TZ-100021'
    )
);

SELECT *
FROM land_parcels
WHERE plot_number = 'PL021';


-- ============================================
-- STEP 3: CREATE A LAND APPLICATION
-- ============================================

INSERT INTO applications (
    application_number,
    applicant_id,
    parcel_id,
    application_type,
    application_date,
    status
)
VALUES (
    'APP-021',
    (
        SELECT owner_id
        FROM landowners
        WHERE national_id_sample = 'TZ-100021'
    ),
    (
        SELECT parcel_id
        FROM land_parcels
        WHERE plot_number = 'PL021'
    ),
    'First Registration',
    CURRENT_DATE,
    'PENDING'
);

SELECT *
FROM applications
WHERE application_number = 'APP-021';


-- ============================================
-- STEP 4: RECORD PAYMENT
-- ============================================

INSERT INTO payments (
    application_id,
    amount,
    payment_date,
    payment_reference,
    payment_status
)
VALUES (
    (
        SELECT application_id
        FROM applications
        WHERE application_number = 'APP-021'
    ),
    200000.00,
    CURRENT_DATE,
    'PAY-021',
    'PAID'
);

SELECT *
FROM payments
WHERE payment_reference = 'PAY-021';


-- ============================================
-- STEP 5: APPROVE THE APPLICATION
-- ============================================

UPDATE applications
SET status = 'APPROVED'
WHERE application_number = 'APP-021';

SELECT
    application_number,
    status
FROM applications
WHERE application_number = 'APP-021';


-- ============================================
-- STEP 6: CREATE A LAND TITLE
-- ============================================

INSERT INTO titles (
    title_number,
    parcel_id,
    issue_date,
    expiry_date,
    status
)
VALUES (
    'TITLE-021',
    (
        SELECT parcel_id
        FROM land_parcels
        WHERE plot_number = 'PL021'
    ),
    CURRENT_DATE,
    (CURRENT_DATE + INTERVAL '99 years')::date,
    'ACTIVE'
);

SELECT *
FROM titles
WHERE title_number = 'TITLE-021';


-- ============================================
-- STEP 7: COMPLETE THE REGISTRATION
-- ============================================

UPDATE applications
SET status = 'COMPLETED'
WHERE application_number = 'APP-021';


-- ============================================
-- FULL REGISTRATION REPORT
-- ============================================

SELECT
    lo.owner_id,
    lo.first_name || ' ' || lo.last_name AS owner_name,
    lp.plot_number,
    lp.block_number,
    lp.location,
    a.application_number,
    a.application_type,
    a.status AS application_status,
    p.amount,
    p.payment_status,
    t.title_number,
    t.status AS title_status
FROM landowners lo
JOIN land_parcels lp
    ON lo.owner_id = lp.current_owner_id
JOIN applications a
    ON lp.parcel_id = a.parcel_id
JOIN payments p
    ON a.application_id = p.application_id
JOIN titles t
    ON lp.parcel_id = t.parcel_id
WHERE lo.national_id_sample = 'TZ-100021';


-- ============================================
-- STEP 8: REGISTER A SECOND OWNER FOR TRANSFER
-- ============================================

INSERT INTO landowners (
    first_name,
    middle_name,
    last_name,
    gender,
    national_id_sample,
    phone,
    email,
    address
)
VALUES (
    'Anna',
    'Maria',
    'John',
    'F',
    'TZ-100022',
    '+255712000022',
    'anna.john@example.com',
    'Dodoma, Tanzania'
);


-- ============================================
-- STEP 9: CREATE A TRANSFER
-- ============================================

INSERT INTO transfers (
    title_id,
    previous_owner_id,
    new_owner_id,
    transfer_date,
    transfer_status
)
VALUES (
    (
        SELECT title_id
        FROM titles
        WHERE title_number = 'TITLE-021'
    ),
    (
        SELECT owner_id
        FROM landowners
        WHERE national_id_sample = 'TZ-100021'
    ),
    (
        SELECT owner_id
        FROM landowners
        WHERE national_id_sample = 'TZ-100022'
    ),
    CURRENT_DATE,
    'COMPLETED'
);

UPDATE land_parcels
SET current_owner_id = (
    SELECT owner_id
    FROM landowners
    WHERE national_id_sample = 'TZ-100022'
)
WHERE plot_number = 'PL021';


-- ============================================
-- VERIFY TRANSFER
-- ============================================

SELECT
    tr.transfer_id,
    t.title_number,
    lp.plot_number,
    previous_owner.first_name || ' ' || previous_owner.last_name AS previous_owner,
    new_owner.first_name || ' ' || new_owner.last_name AS new_owner,
    tr.transfer_date,
    tr.transfer_status
FROM transfers tr
JOIN titles t
    ON tr.title_id = t.title_id
JOIN land_parcels lp
    ON t.parcel_id = lp.parcel_id
JOIN landowners previous_owner
    ON tr.previous_owner_id = previous_owner.owner_id
JOIN landowners new_owner
    ON tr.new_owner_id = new_owner.owner_id
WHERE t.title_number = 'TITLE-021';


-- ============================================
-- STEP 10: CREATE A DISPUTE
-- ============================================

INSERT INTO disputes (
    parcel_id,
    complainant_id,
    description,
    date_reported,
    status
)
VALUES (
    (
        SELECT parcel_id
        FROM land_parcels
        WHERE plot_number = 'PL021'
    ),
    (
        SELECT owner_id
        FROM landowners
        WHERE national_id_sample = 'TZ-100022'
    ),
    'Ownership boundary dispute for testing purposes.',
    CURRENT_DATE,
    'OPEN'
);


-- ============================================
-- VERIFY DISPUTE
-- ============================================

SELECT
    d.dispute_id,
    lp.plot_number,
    lo.first_name || ' ' || lo.last_name AS complainant_name,
    d.description,
    d.date_reported,
    d.status
FROM disputes d
JOIN land_parcels lp
    ON d.parcel_id = lp.parcel_id
JOIN landowners lo
    ON d.complainant_id = lo.owner_id
WHERE lp.plot_number = 'PL021';


-- ============================================
-- STEP 11: VERIFY RELATIONSHIPS
-- ============================================

SELECT
    lo.first_name || ' ' || lo.last_name AS current_owner,
    lp.plot_number,
    a.application_number,
    p.payment_reference,
    t.title_number
FROM landowners lo
JOIN land_parcels lp
    ON lo.owner_id = lp.current_owner_id
JOIN applications a
    ON lp.parcel_id = a.parcel_id
JOIN payments p
    ON a.application_id = p.application_id
JOIN titles t
    ON lp.parcel_id = t.parcel_id
WHERE lp.plot_number = 'PL021';


-- ============================================
-- STEP 12: TEST UNIQUE CONSTRAINT
-- ============================================

DO $$
BEGIN
    INSERT INTO landowners (
        first_name,
        last_name,
        gender,
        national_id_sample,
        phone
    )
    VALUES (
        'Duplicate',
        'Test',
        'M',
        'TZ-100021',
        '+255799999999'
    );

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE
        'SUCCESS: UNIQUE constraint prevented duplicate National ID.';
END $$;


-- ============================================
-- STEP 13: TEST FOREIGN KEY CONSTRAINT
-- ============================================

DO $$
BEGIN
    INSERT INTO applications (
        application_number,
        applicant_id,
        parcel_id,
        application_type,
        application_date,
        status
    )
    VALUES (
        'APP-INVALID',
        99999,
        99999,
        'First Registration',
        CURRENT_DATE,
        'PENDING'
    );

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE
        'SUCCESS: FOREIGN KEY constraint prevented invalid relationship.';
END $$;


-- ============================================
-- STEP 14: FINAL SYSTEM TEST SUMMARY
-- ============================================

SELECT
    'Landowner Registration' AS test_item,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM landowners
            WHERE national_id_sample = 'TZ-100021'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END AS result

UNION ALL

SELECT
    'Parcel Registration',
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM land_parcels
            WHERE plot_number = 'PL021'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'Application',
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM applications
            WHERE application_number = 'APP-021'
              AND status = 'COMPLETED'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'Payment',
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM payments
            WHERE payment_reference = 'PAY-021'
              AND payment_status = 'PAID'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'Title Creation',
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM titles
            WHERE title_number = 'TITLE-021'
              AND status = 'ACTIVE'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'Transfer',
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM transfers tr
            JOIN titles t
                ON tr.title_id = t.title_id
            WHERE t.title_number = 'TITLE-021'
              AND tr.transfer_status = 'COMPLETED'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'Dispute',
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM disputes d
            JOIN land_parcels lp
                ON d.parcel_id = lp.parcel_id
            WHERE lp.plot_number = 'PL021'
              AND d.status = 'OPEN'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END;
