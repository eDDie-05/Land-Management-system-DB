--
-- PostgreSQL database dump
--

\restrict dPnLcfB0FzBZ1UaQWBMtCFgRCZUfGQq7SEsb5XgnovbyaY0p8pBT91AOvyZhWm4

-- Dumped from database version 18.6 (Homebrew)
-- Dumped by pg_dump version 18.6 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.applications (
    application_id integer NOT NULL,
    application_number character varying(30) NOT NULL,
    applicant_id integer NOT NULL,
    parcel_id integer NOT NULL,
    application_type character varying(30) NOT NULL,
    application_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    CONSTRAINT applications_application_type_check CHECK (((application_type)::text = ANY ((ARRAY['First Registration'::character varying, 'Transfer'::character varying, 'Title Replacement'::character varying, 'Mortgage'::character varying, 'Lease'::character varying])::text[]))),
    CONSTRAINT applications_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'UNDER_REVIEW'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying, 'COMPLETED'::character varying])::text[])))
);


ALTER TABLE public.applications OWNER TO georgemollel;

--
-- Name: applications_application_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.applications_application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applications_application_id_seq OWNER TO georgemollel;

--
-- Name: applications_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.applications_application_id_seq OWNED BY public.applications.application_id;


--
-- Name: disputes; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.disputes (
    dispute_id integer NOT NULL,
    parcel_id integer NOT NULL,
    complainant_id integer NOT NULL,
    description text NOT NULL,
    date_reported date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'OPEN'::character varying NOT NULL,
    CONSTRAINT disputes_status_check CHECK (((status)::text = ANY ((ARRAY['OPEN'::character varying, 'UNDER_INVESTIGATION'::character varying, 'RESOLVED'::character varying, 'DISMISSED'::character varying])::text[])))
);


ALTER TABLE public.disputes OWNER TO georgemollel;

--
-- Name: disputes_dispute_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.disputes_dispute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.disputes_dispute_id_seq OWNER TO georgemollel;

--
-- Name: disputes_dispute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.disputes_dispute_id_seq OWNED BY public.disputes.dispute_id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.districts (
    district_id integer NOT NULL,
    district_name character varying(100) NOT NULL,
    region_id integer NOT NULL
);


ALTER TABLE public.districts OWNER TO georgemollel;

--
-- Name: districts_district_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.districts_district_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.districts_district_id_seq OWNER TO georgemollel;

--
-- Name: districts_district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.districts_district_id_seq OWNED BY public.districts.district_id;


--
-- Name: land_parcels; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.land_parcels (
    parcel_id integer NOT NULL,
    plot_number character varying(20) NOT NULL,
    block_number character varying(20),
    area_size_sqm numeric(10,2) NOT NULL,
    land_use character varying(50) NOT NULL,
    location character varying(150),
    district_id integer NOT NULL,
    current_owner_id integer,
    CONSTRAINT land_parcels_area_size_sqm_check CHECK ((area_size_sqm > (0)::numeric)),
    CONSTRAINT land_parcels_land_use_check CHECK (((land_use)::text = ANY ((ARRAY['Residential'::character varying, 'Commercial'::character varying, 'Agricultural'::character varying, 'Industrial'::character varying, 'Institutional'::character varying, 'Mixed Use'::character varying])::text[])))
);


ALTER TABLE public.land_parcels OWNER TO georgemollel;

--
-- Name: land_parcels_parcel_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.land_parcels_parcel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.land_parcels_parcel_id_seq OWNER TO georgemollel;

--
-- Name: land_parcels_parcel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.land_parcels_parcel_id_seq OWNED BY public.land_parcels.parcel_id;


--
-- Name: landowners; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.landowners (
    owner_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50),
    last_name character varying(50) NOT NULL,
    gender character varying(10),
    national_id_sample character varying(30) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(100),
    address text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT landowners_gender_check CHECK (((gender)::bpchar = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.landowners OWNER TO georgemollel;

--
-- Name: landowners_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.landowners_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.landowners_owner_id_seq OWNER TO georgemollel;

--
-- Name: landowners_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.landowners_owner_id_seq OWNED BY public.landowners.owner_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    application_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_date date DEFAULT CURRENT_DATE NOT NULL,
    payment_reference character varying(50) NOT NULL,
    payment_status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    CONSTRAINT payments_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT payments_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['PENDING'::character varying, 'PAID'::character varying, 'FAILED'::character varying, 'REFUNDED'::character varying])::text[])))
);


ALTER TABLE public.payments OWNER TO georgemollel;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO georgemollel;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.regions (
    region_id integer NOT NULL,
    region_name character varying(100) NOT NULL
);


ALTER TABLE public.regions OWNER TO georgemollel;

--
-- Name: regions_region_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.regions_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_region_id_seq OWNER TO georgemollel;

--
-- Name: regions_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.regions_region_id_seq OWNED BY public.regions.region_id;


--
-- Name: titles; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.titles (
    title_id integer NOT NULL,
    title_number character varying(30) NOT NULL,
    parcel_id integer NOT NULL,
    issue_date date NOT NULL,
    expiry_date date,
    status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    CONSTRAINT titles_check CHECK (((expiry_date IS NULL) OR (expiry_date > issue_date))),
    CONSTRAINT titles_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'EXPIRED'::character varying, 'REVOKED'::character varying])::text[])))
);


ALTER TABLE public.titles OWNER TO georgemollel;

--
-- Name: titles_title_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.titles_title_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.titles_title_id_seq OWNER TO georgemollel;

--
-- Name: titles_title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.titles_title_id_seq OWNED BY public.titles.title_id;


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: georgemollel
--

CREATE TABLE public.transfers (
    transfer_id integer NOT NULL,
    title_id integer NOT NULL,
    previous_owner_id integer NOT NULL,
    new_owner_id integer NOT NULL,
    transfer_date date DEFAULT CURRENT_DATE NOT NULL,
    transfer_status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    CONSTRAINT transfers_check CHECK ((previous_owner_id <> new_owner_id)),
    CONSTRAINT transfers_transfer_status_check CHECK (((transfer_status)::text = ANY ((ARRAY['PENDING'::character varying, 'COMPLETED'::character varying, 'REJECTED'::character varying])::text[])))
);


ALTER TABLE public.transfers OWNER TO georgemollel;

--
-- Name: transfers_transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: georgemollel
--

CREATE SEQUENCE public.transfers_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transfers_transfer_id_seq OWNER TO georgemollel;

--
-- Name: transfers_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: georgemollel
--

ALTER SEQUENCE public.transfers_transfer_id_seq OWNED BY public.transfers.transfer_id;


--
-- Name: applications application_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.applications ALTER COLUMN application_id SET DEFAULT nextval('public.applications_application_id_seq'::regclass);


--
-- Name: disputes dispute_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.disputes ALTER COLUMN dispute_id SET DEFAULT nextval('public.disputes_dispute_id_seq'::regclass);


--
-- Name: districts district_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.districts ALTER COLUMN district_id SET DEFAULT nextval('public.districts_district_id_seq'::regclass);


--
-- Name: land_parcels parcel_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.land_parcels ALTER COLUMN parcel_id SET DEFAULT nextval('public.land_parcels_parcel_id_seq'::regclass);


--
-- Name: landowners owner_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.landowners ALTER COLUMN owner_id SET DEFAULT nextval('public.landowners_owner_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: regions region_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.regions ALTER COLUMN region_id SET DEFAULT nextval('public.regions_region_id_seq'::regclass);


--
-- Name: titles title_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.titles ALTER COLUMN title_id SET DEFAULT nextval('public.titles_title_id_seq'::regclass);


--
-- Name: transfers transfer_id; Type: DEFAULT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.transfers ALTER COLUMN transfer_id SET DEFAULT nextval('public.transfers_transfer_id_seq'::regclass);


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.applications (application_id, application_number, applicant_id, parcel_id, application_type, application_date, status) FROM stdin;
1	APP-001	1	1001	First Registration	2021-01-15	APPROVED
2	APP-002	2	1002	Transfer	2021-03-20	COMPLETED
3	APP-003	3	1003	Lease	2022-02-10	PENDING
4	APP-004	4	1004	Transfer	2022-05-18	APPROVED
5	APP-005	5	1005	Mortgage	2022-08-25	REJECTED
6	APP-006	6	1006	First Registration	2023-01-12	COMPLETED
7	APP-007	7	1007	Title Replacement	2023-04-05	UNDER_REVIEW
8	APP-008	8	1008	Lease	2023-06-22	APPROVED
9	APP-009	9	1009	First Registration	2023-09-14	COMPLETED
10	APP-010	10	1010	Transfer	2024-01-08	PENDING
11	APP-011	11	1011	Mortgage	2024-03-19	REJECTED
12	APP-012	12	1012	Title Replacement	2024-06-11	APPROVED
13	APP-013	13	1013	Lease	2024-08-30	UNDER_REVIEW
14	APP-014	14	1014	Transfer	2025-02-17	COMPLETED
15	APP-015	15	1015	First Registration	2025-05-26	PENDING
\.


--
-- Data for Name: disputes; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.disputes (dispute_id, parcel_id, complainant_id, description, date_reported, status) FROM stdin;
\.


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.districts (district_id, district_name, region_id) FROM stdin;
100	Mheza	4
200	Kahama	6
300	Mbarali	5
400	Kinondoni	1
500	Butimba	3
600	Kibaigwa	2
700	Ilala	1
800	Kyela	5
900	Ilemela	3
1000	Pangani	4
\.


--
-- Data for Name: land_parcels; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.land_parcels (parcel_id, plot_number, block_number, area_size_sqm, land_use, location, district_id, current_owner_id) FROM stdin;
1001	PL001	BLK-A1	450.50	Residential	Mheza	100	1
1002	PL002	BLK-A1	600.00	Commercial	Mheza	100	2
1003	PL003	BLK-B1	750.25	Residential	Kahama	200	3
1004	PL004	BLK-B2	1200.00	Commercial	Kahama	200	4
1005	PL005	BLK-C1	1500.75	Agricultural	Mbarali	300	5
1006	PL006	BLK-C2	2000.00	Agricultural	Mbarali	300	6
1007	PL007	BLK-D1	500.00	Residential	Kinondoni	400	7
1008	PL008	BLK-D2	850.50	Commercial	Kinondoni	400	8
1009	PL009	BLK-E1	900.00	Residential	Butimba	500	9
1010	PL010	BLK-E2	1100.25	Commercial	Butimba	500	10
1011	PL011	BLK-F1	1800.00	Agricultural	Kibaigwa	600	11
1012	PL012	BLK-F2	950.50	Residential	Kibaigwa	600	12
1013	PL013	BLK-G1	650.00	Residential	Ilala	700	13
1014	PL014	BLK-G2	1300.75	Commercial	Ilala	700	14
1015	PL015	BLK-H1	2200.00	Agricultural	Kyela	800	15
1016	PL016	BLK-H2	700.25	Residential	Kyela	800	16
1017	PL017	BLK-I1	800.00	Residential	Ilemela	900	17
1018	PL018	BLK-I2	1400.50	Commercial	Ilemela	900	18
1019	PL019	BLK-J1	1000.00	Residential	Pangani	1000	19
1020	PL020	BLK-J2	1750.75	Agricultural	Pangani	1000	20
\.


--
-- Data for Name: landowners; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.landowners (owner_id, first_name, middle_name, last_name, gender, national_id_sample, phone, email, address, created_at) FROM stdin;
1	John	Michael	Mwakyusa	M	TZ-100001	+255712000001	john.mwakyusa@example.com	Mbezi Beach, Dar es Salaam	2026-01-05 08:30:00
2	Asha	Neema	Mashauri	F	TZ-100002	+255712000002	asha.mashauri@example.com	Sinza, Dar es Salaam	2026-01-06 09:15:00
3	Peter	Joseph	Mrema	M	TZ-100003	+255712000003	peter.mrema@example.com	Kijitonyama, Dar es Salaam	2026-01-07 10:20:00
4	Grace	Maria	John	F	TZ-100004	+255712000004	grace.john@example.com	Tegeta, Dar es Salaam	2026-01-08 11:00:00
5	David	Emanuel	Mushi	M	TZ-100005	+255712000005	david.mushi@example.com	Kimara, Dar es Salaam	2026-01-09 12:45:00
6	Rehema	Fatuma	Said	F	TZ-100006	+255712000006	rehema.said@example.com	Tabata, Dar es Salaam	2026-01-10 13:10:00
7	Emmanuel	Paul	Kweka	M	TZ-100007	+255712000007	emmanuel.kweka@example.com	Ubungo, Dar es Salaam	2026-01-11 14:25:00
8	Sophia	Anna	Mallya	F	TZ-100008	+255712000008	sophia.mallya@example.com	Mikocheni, Dar es Salaam	2026-01-12 15:30:00
9	George	Simon	Mtui	M	TZ-100009	+255712000009	george.mtui@example.com	Kariakoo, Dar es Salaam	2026-01-13 08:50:00
10	Zainabu	Halima	Mohamed	F	TZ-100010	+255712000010	zainabu.mohamed@example.com	Ilala, Dar es Salaam	2026-01-14 09:40:00
11	Frank	Leonard	Mwakalinga	M	TZ-100011	+255712000011	frank.mwakalinga@example.com	Kigamboni, Dar es Salaam	2026-01-15 10:15:00
12	Esther	Joyce	Mwakalobo	F	TZ-100012	+255712000012	esther.mwakalobo@example.com	Masaki, Dar es Salaam	2026-01-16 11:35:00
13	Joseph	Daniel	Ngowi	M	TZ-100013	+255712000013	joseph.ngowi@example.com	Mwenge, Dar es Salaam	2026-01-17 12:20:00
14	Mary	Elizabeth	Charles	F	TZ-100014	+255712000014	mary.charles@example.com	Buguruni, Dar es Salaam	2026-01-18 13:55:00
15	William	Baraka	Lema	M	TZ-100015	+255712000015	william.lema@example.com	Magomeni, Dar es Salaam	2026-01-19 14:40:00
16	Janeth	Rose	Mwakipesile	F	TZ-100016	+255712000016	janeth.mwakipesile@example.com	Manzese, Dar es Salaam	2026-01-20 15:10:00
17	Charles	Robert	Macha	M	TZ-100017	+255712000017	charles.macha@example.com	Kawe, Dar es Salaam	2026-01-21 08:25:00
18	Agnes	Beatrice	Mashauri	F	TZ-100018	+255712000018	agnes.mashauri@example.com	Kinondoni, Dar es Salaam	2026-01-22 09:50:00
19	Kelvin	Thomas	Mboya	M	TZ-100019	+255712000019	kelvin.mboya@example.com	Goba, Dar es Salaam	2026-01-23 10:30:00
20	Rose	Juliana	Matata	F	TZ-100020	+255712000020	rose.matata@example.com	Bunju, Dar es Salaam	2026-01-24 11:45:00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.payments (payment_id, application_id, amount, payment_date, payment_reference, payment_status) FROM stdin;
1	1	150000.00	2021-01-16	PAY-001	PAID
2	2	200000.00	2021-03-21	PAY-002	PAID
3	3	100000.00	2022-02-11	PAY-003	PENDING
4	4	250000.00	2022-05-19	PAY-004	PAID
5	5	180000.00	2022-08-26	PAY-005	FAILED
6	6	150000.00	2023-01-13	PAY-006	PAID
7	7	120000.00	2023-04-06	PAY-007	PENDING
8	8	175000.00	2023-06-23	PAY-008	PAID
9	9	150000.00	2023-09-15	PAY-009	PAID
10	10	220000.00	2024-01-09	PAY-010	PENDING
11	11	190000.00	2024-03-20	PAY-011	FAILED
12	12	130000.00	2024-06-12	PAY-012	PAID
13	13	110000.00	2024-08-31	PAY-013	PENDING
14	14	240000.00	2025-02-18	PAY-014	PAID
15	15	160000.00	2025-05-27	PAY-015	PAID
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.regions (region_id, region_name) FROM stdin;
1	Dar es Salaam
2	Dodoma
3	Mwanza
4	Tanga
5	Mbeya
6	Shinyanga
\.


--
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.titles (title_id, title_number, parcel_id, issue_date, expiry_date, status) FROM stdin;
1	TITLE-001	1001	2020-01-15	2119-01-15	ACTIVE
2	TITLE-002	1002	2021-03-20	2120-03-20	ACTIVE
3	TITLE-003	1003	2019-06-10	2118-06-10	ACTIVE
4	TITLE-004	1004	2022-02-05	2121-02-05	ACTIVE
5	TITLE-005	1005	2018-09-12	2117-09-12	EXPIRED
6	TITLE-006	1006	2020-11-25	2119-11-25	ACTIVE
7	TITLE-007	1007	2021-07-18	2120-07-18	ACTIVE
8	TITLE-008	1008	2019-04-30	2118-04-30	ACTIVE
9	TITLE-009	1009	2022-08-14	2121-08-14	ACTIVE
10	TITLE-010	1010	2020-05-22	2119-05-22	ACTIVE
11	TITLE-011	1011	2017-12-01	2116-12-01	EXPIRED
12	TITLE-012	1012	2021-10-09	2120-10-09	ACTIVE
13	TITLE-013	1013	2022-06-17	2121-06-17	ACTIVE
14	TITLE-014	1014	2019-02-28	2118-02-28	REVOKED
15	TITLE-015	1015	2020-09-05	2119-09-05	ACTIVE
\.


--
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: georgemollel
--

COPY public.transfers (transfer_id, title_id, previous_owner_id, new_owner_id, transfer_date, transfer_status) FROM stdin;
1	1	1	16	2022-03-15	COMPLETED
2	2	2	17	2022-06-20	COMPLETED
3	3	3	18	2023-01-10	PENDING
4	4	4	19	2023-04-25	COMPLETED
5	5	5	20	2023-08-12	REJECTED
6	6	6	1	2024-02-18	COMPLETED
7	7	7	2	2024-05-30	PENDING
8	8	8	3	2024-09-14	COMPLETED
9	9	9	4	2025-01-22	COMPLETED
10	10	10	5	2025-06-10	PENDING
\.


--
-- Name: applications_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.applications_application_id_seq', 1, false);


--
-- Name: disputes_dispute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.disputes_dispute_id_seq', 1, false);


--
-- Name: districts_district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.districts_district_id_seq', 1, false);


--
-- Name: land_parcels_parcel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.land_parcels_parcel_id_seq', 1, false);


--
-- Name: landowners_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.landowners_owner_id_seq', 1, false);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- Name: regions_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.regions_region_id_seq', 1, false);


--
-- Name: titles_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.titles_title_id_seq', 1, false);


--
-- Name: transfers_transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: georgemollel
--

SELECT pg_catalog.setval('public.transfers_transfer_id_seq', 1, false);


--
-- Name: applications applications_application_number_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_application_number_key UNIQUE (application_number);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (application_id);


--
-- Name: disputes disputes_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_pkey PRIMARY KEY (dispute_id);


--
-- Name: districts districts_district_name_region_id_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_district_name_region_id_key UNIQUE (district_name, region_id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (district_id);


--
-- Name: land_parcels land_parcels_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.land_parcels
    ADD CONSTRAINT land_parcels_pkey PRIMARY KEY (parcel_id);


--
-- Name: land_parcels land_parcels_plot_number_block_number_district_id_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.land_parcels
    ADD CONSTRAINT land_parcels_plot_number_block_number_district_id_key UNIQUE (plot_number, block_number, district_id);


--
-- Name: landowners landowners_email_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.landowners
    ADD CONSTRAINT landowners_email_key UNIQUE (email);


--
-- Name: landowners landowners_national_id_sample_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.landowners
    ADD CONSTRAINT landowners_national_id_sample_key UNIQUE (national_id_sample);


--
-- Name: landowners landowners_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.landowners
    ADD CONSTRAINT landowners_pkey PRIMARY KEY (owner_id);


--
-- Name: payments payments_payment_reference_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_payment_reference_key UNIQUE (payment_reference);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_id);


--
-- Name: regions regions_region_name_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_region_name_key UNIQUE (region_name);


--
-- Name: titles titles_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.titles
    ADD CONSTRAINT titles_pkey PRIMARY KEY (title_id);


--
-- Name: titles titles_title_number_key; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.titles
    ADD CONSTRAINT titles_title_number_key UNIQUE (title_number);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (transfer_id);


--
-- Name: idx_applications_applicant; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_applications_applicant ON public.applications USING btree (applicant_id);


--
-- Name: idx_applications_parcel; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_applications_parcel ON public.applications USING btree (parcel_id);


--
-- Name: idx_disputes_parcel; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_disputes_parcel ON public.disputes USING btree (parcel_id);


--
-- Name: idx_districts_region; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_districts_region ON public.districts USING btree (region_id);


--
-- Name: idx_parcels_district; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_parcels_district ON public.land_parcels USING btree (district_id);


--
-- Name: idx_parcels_owner; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_parcels_owner ON public.land_parcels USING btree (current_owner_id);


--
-- Name: idx_payments_application; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_payments_application ON public.payments USING btree (application_id);


--
-- Name: idx_titles_parcel; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_titles_parcel ON public.titles USING btree (parcel_id);


--
-- Name: idx_transfers_title; Type: INDEX; Schema: public; Owner: georgemollel
--

CREATE INDEX idx_transfers_title ON public.transfers USING btree (title_id);


--
-- Name: applications applications_applicant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_applicant_id_fkey FOREIGN KEY (applicant_id) REFERENCES public.landowners(owner_id) ON DELETE RESTRICT;


--
-- Name: applications applications_parcel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_parcel_id_fkey FOREIGN KEY (parcel_id) REFERENCES public.land_parcels(parcel_id) ON DELETE RESTRICT;


--
-- Name: disputes disputes_complainant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_complainant_id_fkey FOREIGN KEY (complainant_id) REFERENCES public.landowners(owner_id) ON DELETE RESTRICT;


--
-- Name: disputes disputes_parcel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_parcel_id_fkey FOREIGN KEY (parcel_id) REFERENCES public.land_parcels(parcel_id) ON DELETE RESTRICT;


--
-- Name: districts districts_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(region_id) ON DELETE RESTRICT;


--
-- Name: land_parcels land_parcels_current_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.land_parcels
    ADD CONSTRAINT land_parcels_current_owner_id_fkey FOREIGN KEY (current_owner_id) REFERENCES public.landowners(owner_id) ON DELETE RESTRICT;


--
-- Name: land_parcels land_parcels_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.land_parcels
    ADD CONSTRAINT land_parcels_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(district_id) ON DELETE RESTRICT;


--
-- Name: payments payments_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(application_id) ON DELETE RESTRICT;


--
-- Name: titles titles_parcel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.titles
    ADD CONSTRAINT titles_parcel_id_fkey FOREIGN KEY (parcel_id) REFERENCES public.land_parcels(parcel_id) ON DELETE RESTRICT;


--
-- Name: transfers transfers_new_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_new_owner_id_fkey FOREIGN KEY (new_owner_id) REFERENCES public.landowners(owner_id) ON DELETE RESTRICT;


--
-- Name: transfers transfers_previous_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_previous_owner_id_fkey FOREIGN KEY (previous_owner_id) REFERENCES public.landowners(owner_id) ON DELETE RESTRICT;


--
-- Name: transfers transfers_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: georgemollel
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_title_id_fkey FOREIGN KEY (title_id) REFERENCES public.titles(title_id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict dPnLcfB0FzBZ1UaQWBMtCFgRCZUfGQq7SEsb5XgnovbyaY0p8pBT91AOvyZhWm4

