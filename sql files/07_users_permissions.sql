-- ============================================
-- 08_roles_permissions.sql
-- Day 18 — Roles & Permissions
-- Land Registration Database
-- ============================================

-- IMPORTANT:
-- Run these commands as a PostgreSQL superuser or a role
-- with permission to CREATE ROLE and GRANT privileges.


-- ============================================
-- 1. CREATE ROLES
-- ============================================

CREATE ROLE land_admin LOGIN PASSWORD 'ChangeAdminPassword';
CREATE ROLE land_officer LOGIN PASSWORD 'ChangeOfficerPassword';
CREATE ROLE land_viewer LOGIN PASSWORD 'ChangeViewerPassword';


-- ============================================
-- 2. BASIC DATABASE ACCESS
-- ============================================

GRANT CONNECT ON DATABASE land_registration_db
TO land_admin, land_officer, land_viewer;

GRANT USAGE ON SCHEMA public
TO land_admin, land_officer, land_viewer;


-- ============================================
-- 3. LAND ADMIN PRIVILEGES
-- ============================================

-- Full control over all current tables.
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public
TO land_admin;

-- Allow use of sequences for inserting rows with generated IDs.
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public
TO land_admin;


-- ============================================
-- 4. LAND OFFICER PRIVILEGES
-- ============================================

-- Officers can read all operational tables.
GRANT SELECT ON ALL TABLES IN SCHEMA public
TO land_officer;

-- Officers can create and update operational records.
GRANT INSERT, UPDATE
ON landowners, land_parcels, applications, payments, disputes, transfers
TO land_officer;

-- Officers may need sequences when inserting records.
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO land_officer;


-- ============================================
-- 5. LAND VIEWER PRIVILEGES
-- ============================================

-- Viewer is read-only.
GRANT SELECT ON ALL TABLES IN SCHEMA public
TO land_viewer;

-- Explicitly remove modification privileges.
REVOKE INSERT, UPDATE, DELETE, TRUNCATE
ON ALL TABLES IN SCHEMA public
FROM land_viewer;


-- ============================================
-- 6. DEMONSTRATE GRANT AND REVOKE
-- ============================================

-- Example: Temporarily give the viewer permission
-- to insert applications.
GRANT INSERT ON applications
TO land_viewer;

-- Remove that permission again.
REVOKE INSERT ON applications
FROM land_viewer;


-- ============================================
-- 7. VERIFY VIEWER IS READ-ONLY
-- ============================================

-- Run these commands after connecting as land_viewer.

-- This SELECT should succeed:
-- SELECT * FROM land_parcels;

-- This INSERT should fail with a permission error:
-- INSERT INTO landowners (
--     first_name,
--     last_name,
--     national_id_sample,
--     phone
-- )
-- VALUES (
--     'ViewerTest',
--     'User',
--     'TZ-VIEWER-001',
--     '+255700000001'
-- );

-- Check table privileges granted to land_viewer:
SELECT
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'land_viewer'
ORDER BY table_name, privilege_type;


-- ============================================
-- 8. OPTIONAL DEFAULT PRIVILEGES
-- ============================================

-- These commands can be used so future tables created
-- by the current database owner automatically receive
-- the desired permissions.

-- ALTER DEFAULT PRIVILEGES IN SCHEMA public
-- GRANT ALL PRIVILEGES ON TABLES TO land_admin;

-- ALTER DEFAULT PRIVILEGES IN SCHEMA public
-- GRANT SELECT ON TABLES TO land_officer, land_viewer;
