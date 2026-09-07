CREATE TABLE regions (
    region_id     SERIAL PRIMARY KEY,
    region_name   VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE districts (
    district_id     SERIAL PRIMARY KEY,
    district_name   VARCHAR(100) NOT NULL,
    region_id       INT NOT NULL REFERENCES regions(region_id) ON DELETE RESTRICT,
    UNIQUE (district_name, region_id)
);
CREATE TABLE landowners (
    owner_id             SERIAL PRIMARY KEY,
    first_name           VARCHAR(50) NOT NULL,
    middle_name          VARCHAR(50),
    last_name            VARCHAR(50) NOT NULL,
    gender               CHAR(1) CHECK (gender IN ('M', 'F')),
    national_id_sample   VARCHAR(30) NOT NULL UNIQUE,
    phone                VARCHAR(20) NOT NULL,
    email                VARCHAR(100) UNIQUE,
    address              TEXT,
    created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE land_parcels (
    parcel_id         SERIAL PRIMARY KEY,
    plot_number       VARCHAR(20) NOT NULL,
    block_number      VARCHAR(20),
    area_size_sqm     NUMERIC(10, 2) NOT NULL CHECK (area_size_sqm > 0),
    land_use          VARCHAR(50) NOT NULL
                       CHECK (land_use IN ('Residential', 'Commercial', 'Agricultural',
                                            'Industrial', 'Institutional', 'Mixed Use')),
    location          VARCHAR(150),
    district_id       INT NOT NULL REFERENCES districts(district_id) ON DELETE RESTRICT,
    current_owner_id  INT REFERENCES landowners(owner_id) ON DELETE RESTRICT,
    UNIQUE (plot_number, block_number, district_id)
);
CREATE TABLE applications (
    application_id      SERIAL PRIMARY KEY,
    application_number  VARCHAR(30) NOT NULL UNIQUE,
    applicant_id         INT NOT NULL REFERENCES landowners(owner_id) ON DELETE RESTRICT,
    parcel_id            INT NOT NULL REFERENCES land_parcels(parcel_id) ON DELETE RESTRICT,
    application_type     VARCHAR(30) NOT NULL
                          CHECK (application_type IN ('First Registration', 'Transfer',
                                                       'Title Replacement', 'Mortgage', 'Lease')),
    application_date     DATE NOT NULL DEFAULT CURRENT_DATE,
    status                VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                          CHECK (status IN ('PENDING', 'UNDER_REVIEW', 'APPROVED',
                                             'REJECTED', 'COMPLETED'))
);
CREATE TABLE payments (
    payment_id          SERIAL PRIMARY KEY,
    application_id      INT NOT NULL REFERENCES applications(application_id) ON DELETE RESTRICT,
    amount               NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    payment_date         DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_reference    VARCHAR(50) NOT NULL UNIQUE,
    payment_status        VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                          CHECK (payment_status IN ('PENDING', 'PAID', 'FAILED', 'REFUNDED'))
);
CREATE TABLE transfers (
    transfer_id        SERIAL PRIMARY KEY,
    title_id            INT NOT NULL REFERENCES titles(title_id) ON DELETE RESTRICT,
    previous_owner_id   INT NOT NULL REFERENCES landowners(owner_id) ON DELETE RESTRICT,
    new_owner_id         INT NOT NULL REFERENCES landowners(owner_id) ON DELETE RESTRICT,
    transfer_date        DATE NOT NULL DEFAULT CURRENT_DATE,
    transfer_status       VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                          CHECK (transfer_status IN ('PENDING', 'COMPLETED', 'REJECTED')),
    CHECK (previous_owner_id <> new_owner_id)
);
CREATE TABLE disputes (
    dispute_id       SERIAL PRIMARY KEY,
    parcel_id         INT NOT NULL REFERENCES land_parcels(parcel_id) ON DELETE RESTRICT,
    complainant_id     INT NOT NULL REFERENCES landowners(owner_id) ON DELETE RESTRICT,
    description        TEXT NOT NULL,
    date_reported       DATE NOT NULL DEFAULT CURRENT_DATE,
    status              VARCHAR(20) NOT NULL DEFAULT 'OPEN'
                        CHECK (status IN ('OPEN', 'UNDER_INVESTIGATION', 'RESOLVED', 'DISMISSED'))
);
CREATE INDEX idx_districts_region        ON districts(region_id);
CREATE INDEX idx_parcels_district        ON land_parcels(district_id);
CREATE INDEX idx_parcels_owner           ON land_parcels(current_owner_id);
CREATE INDEX idx_titles_parcel           ON titles(parcel_id);
CREATE INDEX idx_applications_applicant  ON applications(applicant_id);
CREATE INDEX idx_applications_parcel     ON applications(parcel_id);
CREATE INDEX idx_payments_application    ON payments(application_id);
CREATE INDEX idx_transfers_title         ON transfers(title_id);
CREATE INDEX idx_disputes_parcel         ON disputes(parcel_id);

