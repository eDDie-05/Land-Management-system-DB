-- ============================================
-- 05_views.sql
-- Day 15 — Views
-- Land Registration Database
-- ============================================

-- 1. Create registered_land_view
-- Combines owner, parcel, district and title information.

CREATE OR REPLACE VIEW registered_land_view AS
SELECT
    lo.owner_id,
    CONCAT_WS(' ', lo.first_name, lo.middle_name, lo.last_name) AS owner_name,

    lp.parcel_id,
    lp.plot_number,
    lp.block_number,
    lp.area_size_sqm,
    lp.land_use,
    lp.location,

    d.district_id,
    d.district_name,

    t.title_id,
    t.title_number,
    t.issue_date,
    t.expiry_date,
    t.status AS title_status
FROM landowners lo
JOIN land_parcels lp
    ON lo.owner_id = lp.current_owner_id
JOIN districts d
    ON lp.district_id = d.district_id
JOIN titles t
    ON lp.parcel_id = t.parcel_id;


-- 2. Test the view
SELECT *
FROM registered_land_view;
