-- 1. Show owner + parcel + district
SELECT
    lo.owner_id,
    lo.first_name,
    lo.middle_name,
    lo.last_name,
    lp.parcel_id,
    lp.plot_number,
    lp.block_number,
    lp.area_size_sqm,
    lp.land_use,
    d.district_name
FROM landowners lo
JOIN land_parcels lp
    ON lo.owner_id = lp.current_owner_id
JOIN districts d
    ON lp.district_id = d.district_id
ORDER BY lo.owner_id;


-- 2. Show owner + parcel + title
SELECT
    lo.owner_id,
    lo.first_name,
    lo.middle_name,
    lo.last_name,
    lp.parcel_id,
    lp.plot_number,
    lp.block_number,
    t.title_number,
    t.issue_date,
    t.expiry_date,
    t.status AS title_status
FROM landowners lo
JOIN land_parcels lp
    ON lo.owner_id = lp.current_owner_id
JOIN titles t
    ON lp.parcel_id = t.parcel_id
ORDER BY lo.owner_id;


-- 3. Show applications + applicant + parcel
SELECT
    a.application_id,
    a.application_number,
    a.application_type,
    a.application_date,
    a.status AS application_status,
    lo.owner_id AS applicant_id,
    lo.first_name,
    lo.middle_name,
    lo.last_name,
    lp.parcel_id,
    lp.plot_number,
    lp.block_number,
    lp.land_use
FROM applications a
JOIN landowners lo
    ON a.applicant_id = lo.owner_id
JOIN land_parcels lp
    ON a.parcel_id = lp.parcel_id
ORDER BY a.application_id;
