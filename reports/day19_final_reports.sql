-- ============================================
-- DAY 19: FINAL REPORTS
-- LAND REGISTRATION DATABASE
-- ============================================


-- ============================================
-- REPORT 1: LANDOWNERS REPORT
-- ============================================

SELECT
    owner_id,
    first_name,
    middle_name,
    last_name,
    gender,
    national_id_sample,
    phone,
    email,
    address,
    created_at
FROM landowners
ORDER BY owner_id;


-- ============================================
-- REPORT 2: PARCELS BY DISTRICT REPORT
-- ============================================

SELECT
    d.district_name,
    lp.parcel_id,
    lp.plot_number,
    lp.block_number,
    lp.area_size_sqm,
    lp.land_use,
    lp.location
FROM land_parcels lp
JOIN districts d
    ON lp.district_id = d.district_id
ORDER BY d.district_name, lp.parcel_id;


-- ============================================
-- REPORT 3: ACTIVE TITLES REPORT
-- ============================================

SELECT
    t.title_id,
    t.title_number,
    lp.plot_number,
    lp.block_number,
    lp.location,
    t.issue_date,
    t.expiry_date,
    t.status
FROM titles t
JOIN land_parcels lp
    ON t.parcel_id = lp.parcel_id
WHERE t.status = 'ACTIVE'
ORDER BY t.title_id;


-- ============================================
-- REPORT 4: PENDING APPLICATIONS REPORT
-- ============================================

SELECT
    a.application_number,
    lo.first_name || ' ' || lo.last_name AS applicant_name,
    lp.plot_number,
    a.application_type,
    a.application_date,
    a.status
FROM applications a
JOIN landowners lo
    ON a.applicant_id = lo.owner_id
JOIN land_parcels lp
    ON a.parcel_id = lp.parcel_id
WHERE a.status = 'PENDING'
ORDER BY a.application_date;


-- ============================================
-- REPORT 5: PAYMENTS REPORT
-- ============================================

SELECT
    p.payment_id,
    p.payment_reference,
    a.application_number,
    lo.first_name || ' ' || lo.last_name AS applicant_name,
    p.amount,
    p.payment_date,
    p.payment_status
FROM payments p
JOIN applications a
    ON p.application_id = a.application_id
JOIN landowners lo
    ON a.applicant_id = lo.owner_id
ORDER BY p.payment_date;


-- ============================================
-- REPORT 6: TRANSFER HISTORY REPORT
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
ORDER BY tr.transfer_date;
