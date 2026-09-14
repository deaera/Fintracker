--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Homebrew)
-- Dumped by pg_dump version 15.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: Accounts; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."Accounts" (
    "Id" uuid NOT NULL,
    "Name" character varying(100) NOT NULL,
    "Type" integer NOT NULL,
    "InitialBalance" numeric(18,2) NOT NULL,
    "Currency" text NOT NULL,
    "BalanceDate" date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public."Accounts" OWNER TO andreeahusleag;

--
-- Name: Assets; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."Assets" (
    "Id" uuid NOT NULL,
    "Ticker" character varying(12) NOT NULL,
    "Name" character varying(200) NOT NULL,
    "Type" integer NOT NULL,
    "Currency" character varying(8) NOT NULL,
    "ManualPrice" numeric(18,4),
    "StooqSymbol" character varying(20)
);


ALTER TABLE public."Assets" OWNER TO andreeahusleag;

--
-- Name: CashTransactions; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."CashTransactions" (
    "Id" uuid NOT NULL,
    "AccountId" uuid NOT NULL,
    "CategoryId" uuid NOT NULL,
    "Date" date NOT NULL,
    "Amount" numeric(18,2) NOT NULL,
    "Description" text NOT NULL,
    "TransferPairId" uuid,
    "IsOutgoingTransfer" boolean DEFAULT false NOT NULL,
    "Currency" character varying(8) DEFAULT 'EUR'::character varying NOT NULL,
    "AffectsBalance" boolean DEFAULT true NOT NULL
);


ALTER TABLE public."CashTransactions" OWNER TO andreeahusleag;

--
-- Name: Categories; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."Categories" (
    "Id" uuid NOT NULL,
    "Name" character varying(100) NOT NULL,
    "Type" integer NOT NULL,
    "Icon" text NOT NULL,
    "Color" text NOT NULL
);


ALTER TABLE public."Categories" OWNER TO andreeahusleag;

--
-- Name: InvestmentAccounts; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."InvestmentAccounts" (
    "Id" uuid NOT NULL,
    "Name" character varying(100) NOT NULL,
    "Institution" character varying(200) NOT NULL,
    "Currency" character varying(8) NOT NULL,
    "OpeningBalance" numeric(18,2) NOT NULL
);


ALTER TABLE public."InvestmentAccounts" OWNER TO andreeahusleag;

--
-- Name: InvestmentTransactions; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."InvestmentTransactions" (
    "Id" uuid NOT NULL,
    "InvestmentAccountId" uuid NOT NULL,
    "AssetId" uuid,
    "Type" integer NOT NULL,
    "Date" date NOT NULL,
    "Quantity" numeric(18,4) NOT NULL,
    "Price" numeric(18,4) NOT NULL,
    "Amount" numeric(18,2) NOT NULL,
    "Fee" numeric(18,2) NOT NULL,
    "Note" character varying(300) NOT NULL
);


ALTER TABLE public."InvestmentTransactions" OWNER TO andreeahusleag;

--
-- Name: PriceHistory; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."PriceHistory" (
    "Id" uuid NOT NULL,
    "AssetId" uuid NOT NULL,
    "Date" date NOT NULL,
    "Price" numeric(18,4) NOT NULL,
    "IsManual" boolean NOT NULL
);


ALTER TABLE public."PriceHistory" OWNER TO andreeahusleag;

--
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: andreeahusleag
--

CREATE TABLE public."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);


ALTER TABLE public."__EFMigrationsHistory" OWNER TO andreeahusleag;

--
-- Data for Name: Accounts; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."Accounts" ("Id", "Name", "Type", "InitialBalance", "Currency", "BalanceDate") FROM stdin;
01a09af5-6b0e-7b52-a540-1d3d59bb659e	Revolut	0	54.71	RON	2026-09-13
01a09af5-f1ee-7f29-af20-b8e645301f75	BT	1	15002.29	RON	2026-09-13
01a09af6-6a8a-744e-83c4-e1de7da7155d	Edenred Bonuri	0	319.99	RON	2026-09-13
01a0a04d-d17a-77d3-9c25-8d3bec98edcb	Cash	3	0.00	RON	2026-09-14
01a0a02a-50d9-76e7-bc55-105c6379a360	ING	0	6.95	RON	2026-09-14
01a0a04a-fda6-7d01-9452-87d79567ff86	ING Savings	1	4800.53	RON	2026-09-14
\.


--
-- Data for Name: Assets; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."Assets" ("Id", "Ticker", "Name", "Type", "Currency", "ManualPrice", "StooqSymbol") FROM stdin;
01a09aec-4568-70ae-8b56-86340439138f	CLS	Celestica Inc	6	EUR	\N	CLS
01a09aec-4575-7883-ae54-8f9d1a944c07	CRDO	Credo Technology Group Holding Ltd	6	EUR	\N	CRDO
01a09aec-4576-71e2-bf71-4939cb0a312f	LEU	Centrus Energy	6	EUR	\N	LEU
01a09aec-4576-77a7-abc2-c1d63684cf3f	UUUU	Energy Fuels	6	EUR	\N	UUUU
01a09aec-4576-78fc-bf1d-dbad45060ade	OKLO	Oklo Inc	6	EUR	\N	OKLO
01a09aec-feb5-712e-8c48-b883fdca364a	ERO	Ero Copper	6	USD	\N	ERO
01a09aec-feb5-75c7-8b48-c12503e310cb	AAOI	Applied Optoelectronics	6	USD	\N	AAOI
01a09aec-feb5-75ff-a369-a322f5890621	ALAB	Astera Labs	6	USD	\N	ALAB
01a09aec-feb5-76f4-bba8-c8836a215b85	INOD	Innodata	6	USD	\N	INOD
01a09aec-feb5-7704-96cb-ba2a747fb7a1	GOOGL	Alphabet	6	USD	\N	GOOGL
01a09aec-feb5-777c-a7e4-586834fdefce	IDCC	InterDigital	6	USD	\N	IDCC
01a09aec-feb5-78d7-b474-9ae90156cbbf	ANET	Arista Networks	6	USD	\N	ANET
01a09aec-feb5-791d-b3fc-038868ce5cef	VRT	Vertiv	6	USD	\N	VRT
01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	NVTS	Navitas Semiconductor Corp	6	USD	\N	NVTS
01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	IESC	IES	6	USD	\N	IESC
01a09aec-feb5-7b92-84bb-0764d59ddf43	FN	Fabrinet	6	USD	\N	FN
01a09aec-feb5-7c87-b3e4-f90f29dbd01a	MU	Micron	6	USD	\N	MU
01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	VUAA	S&P 500	6	USD	\N	VUAA.DE
\.


--
-- Data for Name: CashTransactions; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."CashTransactions" ("Id", "AccountId", "CategoryId", "Date", "Amount", "Description", "TransferPairId", "IsOutgoingTransfer", "Currency", "AffectsBalance") FROM stdin;
01a0a045-dfe2-7918-9367-79d524b986fb	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-26	39.77	Auchan	\N	f	RON	t
01a0a046-371b-703a-b31c-889b1ecbdd91	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7bc8-9302-58364f96222b	2026-08-26	8.00	Unknown stuff	\N	f	RON	t
01a09f0e-f833-7581-8f4c-872a99dbedfc	01a09af5-f1ee-7f29-af20-b8e645301f75	01a09a52-15db-7018-a722-89ee3104adff	2026-09-14	10829.00	Salariu	\N	f	RON	t
01a09f13-bbad-7194-95b1-c05912ff510a	01a09af5-f1ee-7f29-af20-b8e645301f75	01a09afe-525e-7b1d-84b2-af4291f18092	2026-09-14	3500.00	Transfer	3f018e9e-5f4d-49bb-9801-0647ddfb23dd	t	RON	t
01a09f13-bbae-7054-8266-c53ab27234b1	01a09af5-6b0e-7b52-a540-1d3d59bb659e	01a09afe-525e-7b1d-84b2-af4291f18092	2026-09-14	3500.00	Transfer	3f018e9e-5f4d-49bb-9801-0647ddfb23dd	f	RON	t
01a09f1a-0a32-7e02-9d20-3b72442ba4d5	01a09af5-6b0e-7b52-a540-1d3d59bb659e	01a09a52-15e8-7baa-8f8e-022bd83f8fb2	2026-09-14	1159.80	Bilete avion Napoli	\N	f	RON	t
01a09f1c-920a-74f5-838c-8df8e16ee43b	01a09af6-6a8a-744e-83c4-e1de7da7155d	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-13	439.00	Atac Auchan	\N	f	RON	t
01a09f1d-37a7-7975-91c3-08d55421f78c	01a09af6-6a8a-744e-83c4-e1de7da7155d	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-13	45.36	Lidl	\N	f	RON	t
01a09f1f-4ce6-72ac-a245-03fa73d6ad74	01a09af5-f1ee-7f29-af20-b8e645301f75	01a09afe-525e-7b1d-84b2-af4291f18092	2026-09-14	1000.00	Transfer	d6ecedb2-f7cb-4e71-b3e4-ca9834d48cfc	t	RON	t
01a09f1f-4ce6-7971-8683-1cf664162676	01a09af5-6b0e-7b52-a540-1d3d59bb659e	01a09afe-525e-7b1d-84b2-af4291f18092	2026-09-14	1000.00	Transfer	d6ecedb2-f7cb-4e71-b3e4-ca9834d48cfc	f	RON	t
01a09f21-8232-76ed-b4a0-6dead67e42c0	01a09af5-6b0e-7b52-a540-1d3d59bb659e	01a09a52-15e8-7baa-8f8e-022bd83f8fb2	2026-09-14	2450.00	Cazari Napoli	\N	f	RON	t
01a0a032-8980-7c28-9890-133d4d95611f	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15db-7018-a722-89ee3104adff	2026-07-30	1795.00	Salariu	\N	f	RON	t
01a0a034-605e-70ba-88a0-55d6fc2eb678	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7baa-8f8e-022bd83f8fb2	2026-07-31	30.00	Taxa de oras la mare	\N	f	RON	t
01a0a034-b461-7506-a973-498c3e6c387c	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-07-31	11.00	La doi pasi	\N	f	RON	t
01a0a034-f932-7a49-bba3-12bf6ac17760	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-07-31	80.98	Dabo	\N	f	RON	t
01a0a035-57f6-701b-bef6-266323acdb6b	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-02	9.00	La doi pasi	\N	f	RON	t
01a0a036-2436-7b42-8708-0e184f683f9a	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-03	15.48	Profi + Kaufland + La doi pasi	\N	f	RON	t
01a0a036-760b-7443-8880-ec992ae91e28	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7b86-9e94-5f4541c31779	2026-08-03	250.01	Combustibil	\N	f	RON	t
01a0a036-d62e-7cf0-9bf2-d68593e4410a	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-03	56.50	KFC	\N	f	RON	t
01a0a037-87d8-7361-8be7-4aaf4e45a265	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-04	59.18	Profi	\N	f	RON	t
01a0a037-d4d2-7fc0-a97d-628c193dc110	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-05	6.25	Profi	\N	f	RON	t
01a0a038-2848-7acc-83c6-fb988229966e	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-06	6.99	Carrefour	\N	f	RON	t
01a0a038-ad8e-717a-b7dc-3ceaa261990f	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-06	41.99	Pep&Pepper	\N	f	RON	t
01a0a039-db6a-7281-9eb6-96f3288be86e	01a0a02a-50d9-76e7-bc55-105c6379a360	01a0a039-5a8b-7dc3-aac9-d7b4895d9ce6	2026-08-07	210.84	Zooplus	\N	f	RON	t
01a0a03a-4ba6-7346-9341-89571dd53ca5	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7bc8-9302-58364f96222b	2026-08-09	3.90	Prostia de CV	\N	f	RON	t
01a0a03b-0ab2-7538-81e4-f094976d4185	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-09	32.00	Kafea	\N	f	RON	t
01a0a03b-d71c-7164-9cf2-2cb670897621	01a0a02a-50d9-76e7-bc55-105c6379a360	01a0a039-5a8b-7dc3-aac9-d7b4895d9ce6	2026-08-09	4.20	Plic baiat	\N	f	RON	t
01a0a03c-cbfc-7f7d-9689-e691b2235359	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7bc8-9302-58364f96222b	2026-08-10	29.99	Unknown stuff	\N	f	RON	t
01a0a03d-a286-7ac9-8242-6625936bbfd3	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7a02-ad4a-60aa99d0d15d	2026-08-10	15.50	Pepco	\N	f	RON	t
01a0a03e-d2f7-78d7-9982-47c6609942ed	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7cbf-97f4-363ebdd01b10	2026-08-10	578.00	Gym	\N	f	RON	t
01a0a03f-2abe-7ee9-83a3-994ae09ae10c	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7918-a8fd-593229866811	2026-08-11	24.90	Catena	\N	f	RON	t
01a0a03f-6420-7961-a1ce-5e171011f713	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-12	7.49	Profi	\N	f	RON	t
01a0a03f-c33b-7840-914e-e2dca1dbd51a	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15db-7018-a722-89ee3104adff	2026-08-14	1600.00	Salariu	\N	f	RON	t
01a0a041-0366-7465-8fd5-c72fd41c2d16	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7cbf-97f4-363ebdd01b10	2026-08-14	29.00	Youtube Premium	\N	f	RON	t
01a0a041-3c8f-73b2-9d4b-807843761ad2	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-15	6.00	Ikea	\N	f	RON	t
01a0a041-7240-70a2-becf-665e31f9309e	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-15	36.00	McDonalds	\N	f	RON	t
01a0a041-b130-7162-8f4f-65df34031e6e	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7826-91b6-90e33d6c43f7	2026-08-15	54.99	Decathlon	\N	f	RON	t
01a0a041-fe15-7537-9077-5f0b4385cca5	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7b86-9e94-5f4541c31779	2026-08-15	300.04	Combustibil	\N	f	RON	t
01a0a042-a5d2-70ab-af9a-13c29aa1bd5f	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-78bb-b2a9-b3ccf8992daf	2026-08-15	251.60	Electrica	\N	f	RON	t
01a0a043-1550-7730-9121-d05aaa374972	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-15	5.99	Mancare benzinarie	\N	f	RON	t
01a0a043-4d5e-7b72-a4b9-80d7b06293ab	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-78bb-b2a9-b3ccf8992daf	2026-08-18	250.02	Engie	\N	f	RON	t
01a0a043-a662-7c0e-a193-52497e0e0696	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-17	86.51	Bolt food	\N	f	RON	t
01a0a043-ef8f-7425-a973-dad27aea046f	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-19	9.00	Placinta	\N	f	RON	t
01a0a044-5168-7856-b3b8-6035369f186e	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-20	35.00	Meatica	\N	f	RON	t
01a0a044-a12e-7ec2-9e17-7880ebaa297d	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-21	9.00	Placinta	\N	f	RON	t
01a0a044-f2ef-7ef5-93e8-54d02b1638e4	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7bc8-9302-58364f96222b	2026-08-23	98.00	Prostie CV	\N	f	RON	t
01a0a045-328f-7a40-857c-bd24c5955d3e	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-21	60.00	Panini	\N	f	RON	t
01a0a045-9b51-79ed-a0c8-edaba7b964c8	01a0a02a-50d9-76e7-bc55-105c6379a360	01a0a03e-2e14-7f75-a7cd-918ebebd20f7	2026-08-24	26.76	Leroy Merlin	\N	f	RON	t
01a0a046-7445-788c-982b-ab9959e59f5b	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-27	71.90	KFC	\N	f	RON	t
01a0a047-117c-7a34-9eab-e48941e79838	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-08-29	114.16	Profi + Auchan + Lidl	\N	f	RON	t
01a0a048-09d3-76b6-877b-985ee1e75ab3	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-29	41.99	Mesopotamia	\N	f	RON	t
01a0a048-7b9c-76a7-b358-5366109e2d2d	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-78bb-b2a9-b3ccf8992daf	2026-08-31	51.76	Engie	\N	f	RON	t
01a0a049-3091-7ec9-9fc4-10e15c03137d	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7b86-9e94-5f4541c31779	2026-08-31	300.04	Combustibil	\N	f	RON	t
01a0a049-6dde-7620-aa81-c9461bda8455	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-08-31	43.50	McDonalds	\N	f	RON	t
01a0a04a-16f1-7049-aa02-17c91ebefdbe	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15db-7018-a722-89ee3104adff	2026-08-31	1254.00	Salariu	\N	f	RON	t
01a0a04b-fd1b-716d-9dbf-b16c2af3f7bc	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09afe-525e-7b1d-84b2-af4291f18092	2026-09-01	200.00	August Leftovers	6c209b3c-5732-490a-b0d2-36750309906c	t	RON	t
01a0a04b-fd1b-7a59-b4de-b9cca36a2283	01a0a04a-fda6-7d01-9452-87d79567ff86	01a09afe-525e-7b1d-84b2-af4291f18092	2026-09-01	200.00	August Leftovers	6c209b3c-5732-490a-b0d2-36750309906c	f	RON	t
01a0a04e-7cf6-7252-a18e-7cf7d4984df3	01a0a04d-d17a-77d3-9c25-8d3bec98edcb	01a09a52-15e8-7bc8-9302-58364f96222b	2026-08-31	300.00	Unknown Stuff	\N	f	RON	t
01a0a04f-005c-72cd-9da6-a4a92224f07d	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-01	14.89	Profi	\N	f	RON	t
01a0a04f-41fc-7af9-a475-73c49cbd9578	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-09-02	52.00	Filalei	\N	f	RON	t
01a0a04f-88c1-745e-9cd2-c5a57d13fc35	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-02	27.04	Profi	\N	f	RON	t
01a0a050-3308-71b4-a2fd-9a72d19a7692	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-03	41.97	Profi + Selgros	\N	f	RON	t
01a0a051-7a51-76da-b167-9e4220a7aba4	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7bc8-9302-58364f96222b	2026-09-06	3000.00	Nunta Maria + Sergiu	\N	f	RON	t
01a0a052-0af4-7071-8342-784011cb6bdb	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-05	54.87	Profi + auchan	\N	f	RON	t
01a0a052-4ed8-7a5d-bf5f-a8739c156f26	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-09-07	34.00	McDonalds	\N	f	RON	t
01a0a052-863d-7f0d-ba4d-9188835717da	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-07	8.54	Lidl	\N	f	RON	t
01a0a052-c261-732a-b104-b66c2bf91088	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7b86-9e94-5f4541c31779	2026-09-07	200.05	Combustibil	\N	f	RON	t
01a0a053-2a49-7bb2-bd16-b0e90decdc77	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7bc8-9302-58364f96222b	2026-09-07	3.00	Unknown Stuff	\N	f	RON	t
01a0a053-b626-7d4d-98c3-a7d3cfa3fe4f	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-09-07	20.00	Burger King	\N	f	RON	t
01a0a053-fba2-74cf-b750-4928f02b13a2	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-08	17.94	Profi	\N	f	RON	t
01a0a054-df20-7390-b702-9c66771e270d	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7cbf-97f4-363ebdd01b10	2026-09-12	480.00	Gym Membership	\N	f	RON	t
01a0a055-3a88-72e2-a04c-997de4f32d74	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-09-11	68.37	Kapsalon	\N	f	RON	t
01a0a055-801e-784c-8ebe-ff1746fe8665	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7c9a-8783-c3d6976baf77	2026-09-11	23.18	Carrefour	\N	f	RON	t
01a0a056-47e2-750c-81c7-33b5bcdb32e5	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7cbf-97f4-363ebdd01b10	2026-09-14	29.00	Youtube Premium	\N	f	RON	t
01a0a056-a413-764e-9bc9-460e3bb743a6	01a0a02a-50d9-76e7-bc55-105c6379a360	01a09a52-15e8-7aec-af3f-25073879a345	2026-09-14	20.00	Mega Image	\N	f	RON	t
\.


--
-- Data for Name: Categories; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."Categories" ("Id", "Name", "Type", "Icon", "Color") FROM stdin;
01a09a52-15db-7018-a722-89ee3104adff	Salary	0	💼	#4CAF50
01a09a52-15e8-76c5-bd7a-c8cac8c889c0	Entertainment	1	🎮	#FF7043
01a09a52-15e8-7805-b938-b12adec9bfb6	Bonus	0	🎁	#2E7D32
01a09a52-15e8-7826-91b6-90e33d6c43f7	Shopping	1	🛍️	#EC407A
01a09a52-15e8-78bb-b2a9-b3ccf8992daf	Utilities	1	💡	#5C6BC0
01a09a52-15e8-7918-a8fd-593229866811	Healthcare	1	🏥	#26A69A
01a09a52-15e8-7a99-a1ba-8256c002e74d	Freelance	0	🧑‍💻	#66BB6A
01a09a52-15e8-7b86-9e94-5f4541c31779	Transport	1	🚗	#1E88E5
01a09a52-15e8-7baa-8f8e-022bd83f8fb2	Travel	1	✈️	#29B6F6
01a09a52-15e8-7bc8-9302-58364f96222b	Other	1	📦	#78909C
01a09a52-15e8-7c29-a5d4-c62dbf440489	Interest	0	🏦	#43A047
01a09a52-15e8-7c9a-8783-c3d6976baf77	Groceries	1	🛒	#E57373
01a09a52-15e8-7cbf-97f4-363ebdd01b10	Subscriptions	1	📺	#AB47BC
01a09afe-525e-7b1d-84b2-af4291f18092	Transfer	2	↔️	#64748B
01a0a039-5a8b-7dc3-aac9-d7b4895d9ce6	Pet Stuff	1	🐶	#000000
01a09a52-15e8-7aec-af3f-25073879a345	Food & Drinks	1	🍔	#EF5350
01a09a52-15e8-7a02-ad4a-60aa99d0d15d	House Stuff	1	🏠	#8E24AA
01a0a03e-2e14-7f75-a7cd-918ebebd20f7	Renovation	1	🏠	#EF5350
\.


--
-- Data for Name: InvestmentAccounts; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."InvestmentAccounts" ("Id", "Name", "Institution", "Currency", "OpeningBalance") FROM stdin;
01a09aec-4524-7eaa-b25e-b6977a4fbc5c	XTB	XTB	USD	0.00
\.


--
-- Data for Name: InvestmentTransactions; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."InvestmentTransactions" ("Id", "InvestmentAccountId", "AssetId", "Type", "Date", "Quantity", "Price", "Amount", "Fee", "Note") FROM stdin;
01a09aec-4582-7a30-a05f-1ed8dac4ae28	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-12-17	0.0000	0.0000	1500.00	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4793814-822799292, JP_MORGAN merchant reference id=TXN-C-4793814-822799292, id=26444335
01a09aec-458a-7534-83cf-e3be2fe9a669	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2026-03-19	0.0000	0.0000	1000.89	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4873753-1138151448, JP_MORGAN merchant reference id=TXN-C-4873753-1138151448, id=30325850
01a09aec-458a-76c9-a8b4-8843b85b160c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2026-04-15	0.0000	0.0000	1479.16	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4897129-1234941587, JP_MORGAN merchant reference id=TXN-C-4897129-1234941587, id=31461829
01a09aec-458a-7710-bd2e-2f3f26c4ba81	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-04-03	0.0000	0.0000	1.47	0.00	Free-funds Interest 2026-03
01a09aec-458a-77a1-afa3-82dfc7aa9af0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-78fc-bf1d-dbad45060ade	0	2026-04-15	17.0000	55.7276	947.37	0.00	OPEN BUY 17/17.9466 @ 65.40
01a09aec-458a-77ba-a499-a37f7d4cb392	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-01-07	0.0000	0.0000	0.55	0.00	Free-funds Interest 2025-12
01a09aec-458a-7ccc-a776-88cb0c7d980e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-03-05	0.0000	0.0000	1.04	0.00	Free-funds Interest 2026-02
01a09aec-458a-7fdd-8ef3-301721652a6a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-02-03	0.0000	0.0000	1.15	0.00	Free-funds Interest 2026-01
01a09aec-458b-7040-80b1-df3a74cdef2a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	2.10	0.00	RO tax CRDO.US 2026-08-11 (11.00 RON) ///OMI/1556041652/11.00//
01a09aec-458b-7048-9555-6f5faa329f4d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-77a7-abc2-c1d63684cf3f	0	2026-04-21	5.0000	17.7820	88.91	0.00	OPEN BUY 5/5.6234 @ 20.77
01a09aec-458b-705f-ab33-4fab713f65b0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-05-04	0.0000	0.0000	1.90	0.00	Free-funds Interest 2026-04
01a09aec-458b-70a6-9493-c8d07e55961b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-08-04	0.0000	0.0000	3.73	0.00	Free-funds Interest 2026-07
01a09aec-458b-70c0-a75b-acc0e6549ae5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-04-28	0.3185	314.8195	100.27	0.00	OPEN BUY 0.3185 @ 366.73
01a09aec-458b-70e5-b291-179d2b91818c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2026-06-16	0.0000	0.0000	2405.87	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4951707-1465247658, JP_MORGAN merchant reference id=TXN-C-4951707-1465247658, id=34233686
01a09aec-458b-7170-9580-1e17bdedc462	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-04-28	0.6929	144.3065	99.99	0.00	OPEN BUY 0.6929 @ 168.05
01a09aec-458b-720c-95c2-88ba1ac3ecb6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2026-08-24	0.0000	0.0000	2846.80	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-5011864-1712538881, JP_MORGAN merchant reference id=TXN-C-5011864-1712538881, id=37018250
01a09aec-458b-73c2-9763-4a3f8e8cce4a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-07-06	0.0000	0.0000	2.38	0.00	Free-funds Interest 2026-06
01a09aec-458b-7499-849f-4fbe414715af	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-06-03	0.0000	0.0000	1.73	0.00	Free-funds Interest 2026-05
01a09aec-458b-74fb-8afd-64c35e95940b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-77a7-abc2-c1d63684cf3f	0	2026-04-15	11.0000	18.0636	198.70	0.00	OPEN BUY 11/11.041 @ 21.20
01a09aec-458b-7519-bc8e-1426496da959	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-77a7-abc2-c1d63684cf3f	0	2026-04-15	0.0410	18.0488	0.74	0.00	OPEN BUY 0.041/11.041 @ 21.26
01a09aec-458b-760d-8271-4961f8ebdf8b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-77a7-abc2-c1d63684cf3f	0	2026-05-22	25.0000	15.7572	393.93	0.00	OPEN BUY 25/25.3854 @ 18.18
01a09aec-458b-776f-9aec-7ad306c3a293	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-78fc-bf1d-dbad45060ade	0	2026-04-15	0.9466	55.7680	52.79	0.00	OPEN BUY 0.9466/17.9466 @ 65.45
01a09aec-458b-78a4-ab6e-a2a48d6ed3ec	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-77a7-abc2-c1d63684cf3f	0	2026-04-21	0.6234	17.7895	11.09	0.00	OPEN BUY 0.6234/5.6234 @ 20.77
01a09aec-458b-78fc-95a1-81ee82334107	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.6929	209.8571	145.41	0.00	CLOSE BUY 0.6929 @ 243.40
01a09aec-458b-7c6f-bdf0-051087d85cfa	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2026-04-23	0.5203	192.1968	100.00	0.00	OPEN BUY 0.5203 @ 223.80
01a09aec-458b-7eb0-8fd6-38301acff5bb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	1	2026-08-11	0.5203	160.7919	83.66	0.00	CLOSE BUY 0.5203 @ 186.49
01a09aec-458b-7f68-845d-5b94cfbd68d7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-09-01	0.0000	0.0000	4.49	0.00	Free-funds Interest 2026-08
01a09aec-458b-7f93-95ff-66fca76bf0f4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-77a7-abc2-c1d63684cf3f	0	2026-05-22	0.3854	15.7499	6.07	0.00	OPEN BUY 0.3854/25.3854 @ 18.18
01a09aec-feb9-7158-8095-a53ec49a1e88	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-04-11	0.0000	0.0000	12993.17	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4574795-34986085, JP_MORGAN merchant reference id=TXN-C-4574795-34986085, id=19132887
01a09aec-feba-711b-8b41-b3979df4c0ab	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-05-06	8.0000	107.0400	856.32	0.00	OPEN BUY 8 @ 107.04
01a09aec-feba-744e-a645-e4af06528f69	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-11	0.4889	100.8000	49.28	0.00	OPEN BUY 0.4889/1.4889 @ 100.80
01a09aec-feba-74be-a52f-1a48cd747818	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-11	1.0000	100.7000	100.70	0.00	OPEN BUY 1/1.4889 @ 100.70
01a09aec-feba-757d-bae0-460f6523221e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-14	19.0000	103.8800	1973.72	0.00	OPEN BUY 19 @ 103.88
01a09aec-feba-75b8-b9fa-e468e97277b6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-04-25	0.0000	0.0000	1135.07	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4586783-42776996, JP_MORGAN merchant reference id=TXN-C-4586783-42776996, id=19488181
01a09aec-feba-7693-b02d-e0fef3512bb4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-04-25	0.0000	0.0000	1592.90	0.00	Currency conversion, RON to USD from TA: 51802484 to: 52013087, Exchange rate:0.226957
01a09aec-feba-76be-adc5-8721f9d92543	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-29	19.0000	105.3200	2001.08	0.00	OPEN BUY 19 @ 105.32
01a09aec-feba-76c5-a566-30265ca26f79	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-05-04	0.0000	0.0000	1.00	0.00	Free-funds Interest Tax 2025-04
01a09aec-feba-770c-92e2-c729ee1117e8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	0	2025-04-14	0.2699	159.5000	43.05	0.00	OPEN BUY 0.2699/6.2699 @ 159.50
01a09aec-feba-7740-a235-ee4c2ce92926	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	0	2025-04-14	6.0000	159.4900	956.94	0.00	OPEN BUY 6/6.2699 @ 159.49
01a09aec-feba-775c-9562-5aec1e0d8fef	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-05-06	20.0000	107.5800	2151.60	0.00	OPEN BUY 20 @ 107.58
01a09aec-feba-78c4-9570-145cf282886f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-14	0.4428	103.9400	46.02	0.00	OPEN BUY 0.4428/1.4428 @ 103.94
01a09aec-feba-78de-b16d-6cd5a6d5afc6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-05-04	0.0000	0.0000	10.39	0.00	Free-funds Interest 2025-04
01a09aec-feba-7973-80eb-382ab6ed0d98	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-14	1.0000	103.9000	103.90	0.00	OPEN BUY 1/1.4428 @ 103.90
01a09aec-feba-7b48-b2a0-50eebb277d89	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-04-11	0.0000	0.0000	157.53	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4574795-34867303, JP_MORGAN merchant reference id=TXN-C-4574795-34867303, id=19120388
01a09aec-feba-7db8-b3ed-43bde4591e95	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	0	2025-04-14	10.0000	161.2500	1612.50	0.00	OPEN BUY 10 @ 161.25
01a09aec-feba-7ddb-be18-124e63a19b8d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-14	0.4932	104.7200	51.65	0.00	OPEN BUY 0.4932/57.4932 @ 104.72
01a09aec-feba-7e92-bfcc-2ca564cdccdc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-04-14	57.0000	103.9200	5923.44	0.00	OPEN BUY 57/57.4932 @ 103.92
01a09aec-febb-7057-9b3e-3e3338084f1f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-08-15	0.0977	181.5300	17.74	0.00	OPEN BUY 0.0977/1.0977 @ 181.53
01a09aec-febb-705b-b4d5-4a1dd6c295d0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-08-15	1.0000	181.4000	181.40	0.00	OPEN BUY 1/1.0977 @ 181.40
01a09aec-febb-7125-9265-abb3f6c00881	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-09-15	0.0000	0.0000	1.26	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-febb-7131-b266-ec4357a35b8a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-06-16	0.0000	0.0000	0.38	0.00	GOOGL.US USD WHT 30%
01a09aec-febb-7133-8417-c27e15840d61	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-05-30	2.0000	112.7400	225.48	0.00	OPEN BUY 2 @ 112.74
01a09aec-febb-7162-89be-10317784eb95	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-07-15	0.8418	119.8200	100.86	0.00	OPEN BUY 0.8418/17.8418 @ 119.82
01a09aec-febb-71ae-82f9-2d6cf8360aff	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-09-22	6.0000	302.4900	1814.94	0.00	OPEN BUY 6/6.6115 @ 302.49
01a09aec-febb-71db-b49d-a9ec09adfbec	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-08-15	0.0000	0.0000	1210.00	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4684817-110559187, JP_MORGAN merchant reference id=TXN-C-4684817-110559187, id=22421803
01a09aec-febb-7250-a0e0-5959fb52b3c4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-05-12	0.1319	111.5000	14.71	0.00	OPEN BUY 0.1319/4.1319 @ 111.50
01a09aec-febb-7311-9683-4eb5164b6794	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-06-01	0.0000	0.0000	2.32	0.00	Free-funds Interest 2025-05
01a09aec-febb-740f-84af-bd4587c3b7f4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-09-25	4.0000	66.4100	265.64	0.00	OPEN BUY 4 @ 66.41
01a09aec-febb-746f-b5a4-0bb8cc906dcf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-07-03	0.0000	0.0000	0.16	0.00	Free-funds Interest 2025-06
01a09aec-febb-7488-8a26-933b00fb8b10	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-08-04	0.0000	0.0000	1997.00	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4674245-103334099, JP_MORGAN merchant reference id=TXN-C-4674245-103334099, id=22091512
01a09aec-febb-7496-8ddf-33717343625d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-09-24	0.0000	0.0000	20825.54	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4719736-134571978, JP_MORGAN merchant reference id=TXN-C-4719736-134571978, id=23515441
01a09aec-febb-749f-aca1-e01c6c908d09	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-05-12	4.0000	111.5000	446.00	0.00	OPEN BUY 4/4.1319 @ 111.50
01a09aec-febb-74d6-b21a-4f7cdaec18cb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-08-15	0.0000	0.0000	4.19	0.00	Currency conversion, RON to USD from TA: 51802484 to: 52013087, Exchange rate:0.229485
01a09aec-febb-7603-9866-fbd01139e91c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-06-16	0.0000	0.0000	1.26	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-febb-76ad-999a-d70db3929b6c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-09-15	0.0000	0.0000	0.06	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-febb-76f6-8132-8e2b19fd1d43	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-05-16	0.0000	0.0000	1089.47	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4604533-55307742, JP_MORGAN merchant reference id=TXN-C-4604533-55307742, id=20074247
01a09aec-febb-7722-acaf-9643236e2c75	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-09-17	0.0000	0.0000	1996.50	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4713386-130133938, JP_MORGAN merchant reference id=TXN-C-4713386-130133938, id=23313145
01a09aec-febb-7731-869b-ee250f853f71	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	0	2025-09-25	1.0000	376.8100	376.81	0.00	OPEN BUY 1 @ 376.81
01a09aec-febb-7764-b188-856b96907667	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-06-02	1.0000	112.3800	112.38	0.00	OPEN BUY 1 @ 112.38
01a09aec-febb-77c4-b32c-826a5fa23536	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-06-16	0.0000	0.0000	2.10	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-febb-77e6-8929-2bd641df31c6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-05-27	0.0000	0.0000	444.52	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4613347-61081220, JP_MORGAN merchant reference id=TXN-C-4613347-61081220, id=20294428
01a09aec-febb-781e-a9f3-e920d193dae1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-07-15	17.0000	119.8200	2036.94	0.00	OPEN BUY 17/17.8418 @ 119.82
01a09aec-febb-7881-a8a2-1d24f44373e8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-08-05	0.0000	0.0000	0.11	0.00	Free-funds Interest 2025-07
01a09aec-febb-7962-b170-8ffa676b96a8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-06-16	0.0000	0.0000	0.63	0.00	GOOGL.US USD WHT 30%
01a09aec-febb-7986-8196-1bdc99285caf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-08-15	0.6061	188.6200	114.32	0.00	OPEN BUY 0.6061/10.6061 @ 188.62
01a09aec-febb-79a5-bc10-49f1b0ba576c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-06-02	1.0000	112.2800	112.28	0.00	OPEN BUY 1 @ 112.28
01a09aec-febb-7a38-979e-46873ddfbf8b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-07-15	0.0000	0.0000	2096.00	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4656309-91076975, JP_MORGAN merchant reference id=TXN-C-4656309-91076975, id=21540355
01a09aec-febb-7a70-9623-3d4cb78d5ba2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-25	0.4090	156.0700	63.83	0.00	OPEN BUY 0.409/6.409 @ 156.07
01a09aec-febb-7aa4-902b-0377ebb72fa1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-08-15	0.5533	180.7100	99.99	0.00	OPEN BUY 0.5533 @ 180.71
01a09aec-febb-7b19-9519-8ec7d8bac16f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-06-16	0.0000	0.0000	0.06	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-febb-7b43-9048-ccad8dbe91bc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-09-22	0.6115	302.5000	184.98	0.00	OPEN BUY 0.6115/6.6115 @ 302.50
01a09aec-febb-7bd7-8a34-e8618020dabc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-09-15	0.0000	0.0000	0.38	0.00	GOOGL.US USD WHT 30%
01a09aec-febb-7c0b-aa0d-306fa8892388	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	0	2025-05-19	9.0000	112.5200	1012.68	0.00	OPEN BUY 9 @ 112.52
01a09aec-febb-7c74-b045-a42279e2dad5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-25	6.0000	156.0600	936.36	0.00	OPEN BUY 6/6.409 @ 156.06
01a09aec-febb-7cb0-95eb-e7bed5e84b42	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2025-09-22	2.0000	389.5900	779.18	0.00	OPEN BUY 2 @ 389.59
01a09aec-febb-7ce9-862c-8672845fd7a5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-09-15	0.0000	0.0000	2.10	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-febb-7d24-b306-df099ee3c8b4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-08-15	0.5529	180.7000	99.91	0.00	OPEN BUY 0.5529 @ 180.70
01a09aec-febb-7d40-87fc-27dff088690e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-09-15	0.0000	0.0000	0.02	0.00	GOOGL.US USD WHT 30%
01a09aec-febb-7d8c-b678-c63340e27358	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-25	6.0000	156.1000	936.60	0.00	OPEN BUY 6/6.4065 @ 156.10
01a09aec-febb-7dcd-ab1e-31e9e23e940f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-05-07	0.0000	0.0000	452.26	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4596091-49298124, JP_MORGAN merchant reference id=TXN-C-4596091-49298124, id=19772713
01a09aec-febb-7ddf-a8bf-22275e9a0a59	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-08-15	10.0000	188.0000	1880.00	0.00	OPEN BUY 10/10.6061 @ 188.00
01a09aec-febb-7eea-816f-e26ca6705e96	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2025-09-25	2.0000	361.7600	723.52	0.00	OPEN BUY 2 @ 361.76
01a09aec-febb-7eef-bf41-68e3f6320c7e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-09-03	0.0000	0.0000	2.14	0.00	Free-funds Interest 2025-08
01a09aec-febb-7f02-94e2-cd019d272448	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-09-15	0.0000	0.0000	0.63	0.00	GOOGL.US USD WHT 30%
01a09aec-febb-7f09-9436-795821c2e36d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	0	2025-09-22	0.2123	385.3700	81.81	0.00	OPEN BUY 0.2123 @ 385.37
01a09aec-febb-7f2a-85d6-026eb7636366	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-06-16	0.0000	0.0000	0.02	0.00	GOOGL.US USD WHT 30%
01a09aec-febc-701d-8c15-af0925b32c3c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-10-07	2.0000	137.2900	274.58	0.00	OPEN BUY 2/2.1846 @ 137.29
01a09aec-febc-707b-84cd-b225466f1603	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-10-06	3.0000	148.1600	444.48	0.00	OPEN BUY 3/3.3745 @ 148.16
01a09aec-febc-7087-9ac6-4e89c94f1937	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-29	9.0000	162.9700	1466.73	0.00	OPEN BUY 9/9.2079 @ 162.97
01a09aec-febc-70fe-9754-1cb30695d49d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-10-03	0.0000	0.0000	7.70	0.00	Free-funds Interest 2025-09
01a09aec-febc-71b0-b5f7-58d319a761e0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-06	4.0000	219.7600	879.04	0.00	OPEN BUY 4/4.5541 @ 219.76
01a09aec-febc-71c0-93d6-7421a9affa63	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2025-09-29	2.0000	366.4800	732.96	0.00	OPEN BUY 2 @ 366.48
01a09aec-febc-7356-ab53-203f041d21f5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-13	2.0000	204.7900	409.58	0.00	OPEN BUY 2/2.4489 @ 204.79
01a09aec-febc-7485-8082-566f8a8a56de	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-10-01	5.0000	180.7900	903.95	0.00	OPEN BUY 5 @ 180.79
01a09aec-febc-748d-aaff-ba25cadd7057	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-10-06	0.3745	148.1100	55.47	0.00	OPEN BUY 0.3745/3.3745 @ 148.11
01a09aec-febc-751d-bbd6-4b7f580abc2c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-10-03	0.9247	189.1000	174.86	0.00	OPEN BUY 0.9247/7.9247 @ 189.10
01a09aec-febc-751f-9183-f60451799e91	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-09-26	10.0000	70.8400	708.40	0.00	OPEN BUY 10 @ 70.84
01a09aec-febc-75f8-b396-82e70f82de78	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-25	0.4065	156.0900	63.45	0.00	OPEN BUY 0.4065/6.4065 @ 156.09
01a09aec-febc-763d-8416-f4fe40908c0f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-13	0.4489	204.5000	91.80	0.00	OPEN BUY 0.4489/2.4489 @ 204.50
01a09aec-febc-77a7-8319-804fee8f4161	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-10-07	0.1846	137.3200	25.35	0.00	OPEN BUY 0.1846/2.1846 @ 137.32
01a09aec-febc-7828-90b0-01180cf081f9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-10-06	6.0000	148.2000	889.20	0.00	OPEN BUY 6/6.7476 @ 148.20
01a09aec-febc-789b-b97e-a49e33506030	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-06	0.5541	219.9000	121.85	0.00	OPEN BUY 0.5541/4.5541 @ 219.90
01a09aec-febc-7abb-8e0f-bb977ed878b6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-29	0.2079	162.9700	33.88	0.00	OPEN BUY 0.2079/9.2079 @ 162.97
01a09aec-febc-7c02-b188-01ca2da5b855	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-10-06	0.7476	148.4300	110.97	0.00	OPEN BUY 0.7476/6.7476 @ 148.43
01a09aec-febc-7c14-9846-773cc7a715cc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-06	0.2233	224.8900	50.22	0.00	OPEN BUY 0.2233/2.2233 @ 224.89
01a09aec-febc-7c30-abbb-9ca39595da35	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-25	2.0000	157.7100	315.42	0.00	OPEN BUY 2 @ 157.71
01a09aec-febc-7d9d-959e-37e83518d078	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-03	0.0000	0.0000	1.00	0.00	Free-funds Interest Tax 2025-09
01a09aec-febc-7df9-a6ca-c05dbd59a602	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-09-25	2.0000	157.5800	315.16	0.00	OPEN BUY 2 @ 157.58
01a09aec-febc-7f1d-8908-f96574a4feca	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-10-03	7.0000	189.3200	1325.24	0.00	OPEN BUY 7/7.9247 @ 189.32
01a09aec-febc-7f2d-a59a-c707aa85fe48	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-13	14.5751	127.2800	1855.12	0.00	CLOSE BUY 14.5751/18 @ 127.28
01a09aec-febc-7fef-90d2-6d73fa3e2df8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-06	2.0000	224.8900	449.78	0.00	OPEN BUY 2/2.2233 @ 224.89
01a09aec-febd-7018-b685-effee381d64a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.58	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-70a2-a351-3f57a5340a7e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-13	0.4932	127.2800	62.77	0.00	CLOSE BUY 0.4932/18 @ 127.28
01a09aec-febd-7246-b591-8ffe593ea628	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-14	42.4249	126.5600	5369.30	0.00	CLOSE BUY 42.4249/70 @ 126.56
01a09aec-febd-72a2-8ec5-700e5899e5bf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.07	0.00	MU.US USD WHT 30%
01a09aec-febd-72a7-a5a9-022cf5ed8fa6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.69	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-731e-afb6-83ec1b9cd56a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-16	0.2388	164.8700	39.37	0.00	OPEN BUY 0.2388/4.2388 @ 164.87
01a09aec-febd-7369-a5e4-cc86694e6b0b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-13	1.0000	127.2800	127.28	0.00	CLOSE BUY 1/18 @ 127.28
01a09aec-febd-7383-a573-02384a23ee03	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-14	4.0000	172.6000	690.40	0.00	OPEN BUY 4/4.0488 @ 172.60
01a09aec-febd-740b-ae4d-c7b8a28e68f4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-14	0.1007	170.4900	17.17	0.00	OPEN BUY 0.1007/4.1007 @ 170.49
01a09aec-febd-7468-9619-99a6de1575eb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.23	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-7504-a0d4-9ffc43bd41af	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-13	0.4889	127.2800	62.23	0.00	CLOSE BUY 0.4889/18 @ 127.28
01a09aec-febd-75d7-bbf7-8a7bb58ce6c1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.23	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-76a2-a982-1b6c6162364a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-16	0.0000	0.0000	40.54	0.00	RO tax VUAA.UK 2025-10-14 (178.00 RON) ///OMI/1166290038/178.00//
01a09aec-febd-7779-b37e-831992c830a7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2025-10-14	2.0000	245.2200	490.44	0.00	OPEN BUY 2/2.0389 @ 245.22
01a09aec-febd-778d-bd13-6c33c4589870	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-14	0.0000	0.0000	10.91	0.00	RO tax VUAA.UK 2025-10-13 (48.00 RON) ///OMI/1163658882/48.00//
01a09aec-febd-77f5-9291-f0997acf7411	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.05	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-788e-96b4-af3706b696ee	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.02	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-78b7-ba17-5c87b3f3ce79	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-14	4.0000	170.2500	681.00	0.00	OPEN BUY 4/4.1007 @ 170.25
01a09aec-febd-78c6-935f-e1707e2142ef	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-14	19.0000	126.5600	2404.64	0.00	CLOSE BUY 19/70 @ 126.56
01a09aec-febd-78f7-b715-a52606f4025b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-15	0.2016	166.7000	33.61	0.00	OPEN BUY 0.2016/4.2016 @ 166.70
01a09aec-febd-7946-8d78-6dd7c25cdb6b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	1.04	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-7961-be84-b3af301c189a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-16	4.0000	164.8700	659.48	0.00	OPEN BUY 4/4.2388 @ 164.87
01a09aec-febd-799d-bffc-ce66d8708572	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.05	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-79ca-9af0-38c43ea10125	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2025-10-21	0.0000	0.0000	0.69	0.00	MU.US USD 0.1150/ SHR
01a09aec-febd-7a7d-88c6-69025454c474	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-13	0.4428	127.2800	56.36	0.00	CLOSE BUY 0.4428/18 @ 127.28
01a09aec-febd-7c64-acb2-23354850334d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-14	8.5751	126.5600	1085.26	0.00	CLOSE BUY 8.5751/70 @ 126.56
01a09aec-febd-7cd7-a2d1-44b6e5bea265	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-13	1.0000	127.2800	127.28	0.00	CLOSE BUY 1/18 @ 127.28
01a09aec-febd-7db7-83b0-de27d466cbf1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2025-10-21	5.0000	413.8100	2069.05	0.00	OPEN BUY 5 @ 413.81
01a09aec-febd-7ee4-ac4e-79b3ca920cbb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2025-10-14	0.0389	244.8400	9.52	0.00	OPEN BUY 0.0389/2.0389 @ 244.84
01a09aec-febd-7f26-85ef-57f29519292c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-14	0.0488	172.9600	8.44	0.00	OPEN BUY 0.0488/4.0488 @ 172.96
01a09aec-febd-7fe5-89eb-11c9699a3ec8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-15	4.0000	166.6900	666.76	0.00	OPEN BUY 4/4.2016 @ 166.69
01a09aec-febe-708a-85f1-089b05379891	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-27	2.0000	131.3400	262.68	0.00	CLOSE BUY 2/36 @ 131.34
01a09aec-febe-70c8-9eae-9b7b8b836a04	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-10-22	10.0000	70.5300	705.30	0.00	OPEN BUY 10 @ 70.53
01a09aec-febe-7187-b840-05422139038e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	0	2025-10-22	36.0000	13.5700	488.52	0.00	OPEN BUY 36/36.6837 @ 13.57
01a09aec-febe-722c-9642-786d5a722b9e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	0	2025-10-22	0.5626	357.3300	201.03	0.00	OPEN BUY 0.5626 @ 357.33
01a09aec-febe-722f-b7a2-0377762f6c54	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.31	0.00	MU.US USD WHT 30%
01a09aec-febe-734d-a23a-70e22de3a1fa	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-10-22	0.6470	304.0600	196.73	0.00	OPEN BUY 0.647/1.647 @ 304.06
01a09aec-febe-7368-b084-d72d6b5a300e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-11-04	0.1022	225.7400	23.07	0.00	OPEN BUY 0.1022/3.1022 @ 225.74
01a09aec-febe-73dd-9429-43041e5bda3a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-10-22	5.0000	316.8100	1584.05	0.00	OPEN BUY 5 @ 316.81
01a09aec-febe-7400-8e9a-709d4e8da56d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	0	2025-10-30	0.6068	383.6000	232.77	0.00	OPEN BUY 0.6068/2.6068 @ 383.60
01a09aec-febe-7413-94fe-d6eb500c7783	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-febe-748e-90dd-ae676cd4c661	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-27	3.5751	131.3400	469.55	0.00	CLOSE BUY 3.5751/36 @ 131.34
01a09aec-febe-74c9-82ae-94d92a39b11d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-11-04	0.3204	69.8300	22.37	0.00	OPEN BUY 0.3204/14.3204 @ 69.83
01a09aec-febe-7508-9149-2d24e54740fd	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	0	2025-10-30	2.0000	389.9100	779.82	0.00	OPEN BUY 2/2.6068 @ 389.91
01a09aec-febe-7516-accc-4aa3f0ed6ef6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2025-10-28	0.4947	334.5000	165.48	0.00	OPEN BUY 0.4947/1.4947 @ 334.50
01a09aec-febe-7562-b318-fcd9696cd9cb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-27	10.4249	131.3400	1369.21	0.00	CLOSE BUY 10.4249/36 @ 131.34
01a09aec-febe-7610-b4ee-4ed90adf68c7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-febe-7685-ad16-58a35230a209	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.07	0.00	MU.US USD WHT 30%
01a09aec-febe-7744-83cf-37afa7f29804	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	17.0000	129.8600	2207.62	0.00	CLOSE BUY 17/37.3986 @ 129.86
01a09aec-febe-779a-9a28-25a693a3be94	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-27	0.4249	131.3400	55.81	0.00	CLOSE BUY 0.4249/36 @ 131.34
01a09aec-febe-779e-8f9f-e6cfe701f8e5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	0	2025-10-22	0.6837	13.5700	9.28	0.00	OPEN BUY 0.6837/36.6837 @ 13.57
01a09aec-febe-78b4-b1d9-4f70ffbb3f44	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-28	0.0000	0.0000	1.37	0.00	RO tax VUAA.UK 2025-10-27 (6.00 RON) ///OMI/1186328860/6.00//
01a09aec-febe-7959-9073-f0ced57d5b3d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.21	0.00	MU.US USD WHT 30%
01a09aec-febe-796d-a141-06791b320732	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-10-22	10.0000	70.4900	704.90	0.00	OPEN BUY 10 @ 70.49
01a09aec-febe-79b5-a99b-77cc8c788a06	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-22	0.6073	151.9700	92.29	0.00	OPEN BUY 0.6073/4.6073 @ 151.97
01a09aec-febe-7a21-91c9-564e741f3179	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	0	2025-10-22	0.9101	366.4700	333.52	0.00	OPEN BUY 0.9101/1.9101 @ 366.47
01a09aec-febe-7ae2-8cf9-96a2a3e1ed54	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-10-22	1.0000	302.8500	302.85	0.00	OPEN BUY 1/1.647 @ 302.85
01a09aec-febe-7ae2-9ace-379dfdd533f3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-11-04	3.0000	225.3800	676.14	0.00	OPEN BUY 3/3.1022 @ 225.38
01a09aec-febe-7bcd-bcff-ac4ccfbee059	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-28	0.0000	0.0000	21.47	0.00	RO tax VUAA.UK 2025-10-27 (94.00 RON) ///OMI/1186328857/94.00//
01a09aec-febe-7bed-8815-e389f4206047	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-10-27	19.5751	131.3400	2570.99	0.00	CLOSE BUY 19.5751/36 @ 131.34
01a09aec-febe-7c23-ab76-feb31991aa62	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-11-04	0.0712	327.9000	23.35	0.00	OPEN BUY 0.0712/3.0712 @ 327.90
01a09aec-febe-7c4a-96c6-8b3b9a07086e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-11-04	14.0000	70.3800	985.32	0.00	OPEN BUY 14/14.3204 @ 70.38
01a09aec-febe-7d04-b59d-43f3bd81891c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.21	0.00	MU.US USD WHT 30%
01a09aec-febe-7d0f-a0d7-afd7dfa3d5f9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-11-04	3.0000	326.3500	979.05	0.00	OPEN BUY 3/3.0712 @ 326.35
01a09aec-febe-7d6f-87fc-70952475f2a7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	0	2025-10-22	1.0000	369.4500	369.45	0.00	OPEN BUY 1/1.9101 @ 369.45
01a09aec-febe-7d82-ab77-f92ec1a6cbd3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.01	0.00	MU.US USD WHT 30%
01a09aec-febe-7dfc-b77f-497a07424bc7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-28	0.0000	0.0000	2.97	0.00	RO tax VUAA.UK 2025-10-27 (13.00 RON) ///OMI/1186328858/13.00//
01a09aec-febe-7e04-9aef-7eaa46f17c0c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2025-10-28	1.0000	334.9700	334.97	0.00	OPEN BUY 1/1.4947 @ 334.97
01a09aec-febe-7ed1-9fe5-f367f54f2b46	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-10-21	0.0000	0.0000	0.17	0.00	MU.US USD WHT 30%
01a09aec-febe-7f8a-b112-32b8b03d0382	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-10-29	10.0000	229.9400	2299.40	0.00	OPEN BUY 10 @ 229.94
01a09aec-febe-7fdf-b762-614f07b1aca8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-10-22	4.0000	152.0000	608.00	0.00	OPEN BUY 4/4.6073 @ 152.00
01a09aec-febf-70bf-bc92-3b3c4912cc81	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2025-11-18	1.0000	410.2900	410.29	0.00	OPEN BUY 1 @ 410.29
01a09aec-febf-70f7-ab39-1503c98c2f16	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-11-14	8.0000	57.4400	459.52	0.00	OPEN BUY 8/8.7001 @ 57.44
01a09aec-febf-71e2-805f-08dfea729ebb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	1.0000	129.8600	129.86	0.00	CLOSE BUY 1/37.3986 @ 129.86
01a09aec-febf-7205-9560-bf18fea9bd45	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-11-20	0.1834	219.5500	40.27	0.00	OPEN BUY 0.1834/3.1834 @ 219.55
01a09aec-febf-723c-b660-bd02d2f50a6c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	0.3986	129.8600	51.76	0.00	CLOSE BUY 0.3986/37.3986 @ 129.86
01a09aec-febf-725c-8f37-192d695b7228	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-11-06	0.0000	0.0000	2.00	0.00	Free-funds Interest Tax 2025-10
01a09aec-febf-7278-b8ec-37528d14d113	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2025-11-14	0.3392	299.2400	101.50	0.00	OPEN BUY 0.3392/2.3392 @ 299.24
01a09aec-febf-72d6-991a-92f90dde9e38	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	1	2025-11-06	36.0000	9.3700	337.32	0.00	CLOSE BUY 36/36.6837 @ 9.37
01a09aec-febf-7326-9762-5887f1769b7a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-11-06	0.8407	271.6300	228.36	0.00	OPEN BUY 0.8407/1.8407 @ 271.63
01a09aec-febf-73e0-8adc-b2c3799f787f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	2.0000	129.8600	259.72	0.00	CLOSE BUY 2/37.3986 @ 129.86
01a09aec-febf-75ba-9deb-2b4d6ca2e3b0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-11-13	2.0000	141.0800	282.16	0.00	OPEN BUY 2/2.1293 @ 141.08
01a09aec-febf-75cb-9818-5961947421e7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-11-13	0.7382	57.2200	42.24	0.00	OPEN BUY 0.7382/8.7382 @ 57.22
01a09aec-febf-7617-a5a8-991854dc02ce	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-11-14	0.7001	57.5000	40.26	0.00	OPEN BUY 0.7001/8.7001 @ 57.50
01a09aec-febf-7664-9a43-f7645eaa7786	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2025-11-14	2.0000	301.7400	603.48	0.00	OPEN BUY 2/2.3392 @ 301.74
01a09aec-febf-7747-85af-c54c56667c88	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-11-20	3.0000	219.7500	659.25	0.00	OPEN BUY 3/3.1834 @ 219.75
01a09aec-febf-7771-99d9-147f65f7880b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-11-21	0.9498	210.5600	199.99	0.00	OPEN BUY 0.9498 @ 210.56
01a09aec-febf-777e-951e-d56d9392245d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2025-11-13	8.0000	57.0000	456.00	0.00	OPEN BUY 8/8.7382 @ 57.00
01a09aec-febf-7862-8772-04cbbfc86e0a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	0.1319	129.8600	17.13	0.00	CLOSE BUY 0.1319/37.3986 @ 129.86
01a09aec-febf-79cd-a2a7-40d87ef7b2b7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	9.0000	129.8600	1168.74	0.00	CLOSE BUY 9/37.3986 @ 129.86
01a09aec-febf-79dd-8f6d-94efd1674b02	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-11-06	1.0000	270.8000	270.80	0.00	OPEN BUY 1/1.8407 @ 270.80
01a09aec-febf-7a1a-bdee-fef8e48ac7eb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-11-13	0.1293	140.9000	18.22	0.00	OPEN BUY 0.1293/2.1293 @ 140.90
01a09aec-febf-7a6a-9585-9ae379f302d7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	1	2025-11-06	0.6837	9.3600	6.40	0.00	CLOSE BUY 0.6837/36.6837 @ 9.36
01a09aec-febf-7af1-a375-c5675ad6d824	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-11-10	0.0000	0.0000	0.23	0.00	RO tax VUAA.UK 2025-11-05 (1.00 RON) ///OMI/1200221370/1.00//
01a09aec-febf-7b47-bf30-ee830d6ba7cc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	4.0000	129.8600	519.44	0.00	CLOSE BUY 4/37.3986 @ 129.86
01a09aec-febf-7c71-8765-f7ff52c7863d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-11-06	0.0000	0.0000	18.32	0.00	Free-funds Interest 2025-10
01a09aec-febf-7d3a-8375-2601e2373972	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	2.0263	129.8600	263.14	0.00	CLOSE BUY 2.0263/37.3986 @ 129.86
01a09aec-febf-7db9-acfe-53e23c56a796	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	5	2025-11-14	0.0000	0.0000	2276.07	0.00	JP_MORGAN deposit, JP_MORGAN provider transaction id=TXN-C-4764639-167858008, JP_MORGAN merchant reference id=TXN-C-4764639-167858008, id=25427598
01a09aec-febf-7df1-8b62-34893edd1b87	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-11-12	0.0969	161.6100	15.66	0.00	OPEN BUY 0.0969/3.0969 @ 161.61
01a09aec-febf-7ee4-bc4d-0c474b1b0dfd	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	0.8418	129.8600	109.32	0.00	CLOSE BUY 0.8418/37.3986 @ 129.86
01a09aec-febf-7f15-9884-b668020ce104	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-11-12	3.0000	160.8700	482.61	0.00	OPEN BUY 3/3.0969 @ 160.87
01a09aec-febf-7f32-a477-15972e9d6312	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-11-26	3.0000	230.6400	691.92	0.00	OPEN BUY 3/3.468 @ 230.64
01a09aec-febf-7f5c-866e-ad1f68f37fa5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	1	2025-11-05	1.0000	129.8600	129.86	0.00	CLOSE BUY 1/37.3986 @ 129.86
01a09aec-febf-7f95-b4e2-625404a8abd3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-11-10	0.0000	0.0000	25.79	0.00	RO tax VUAA.UK 2025-11-05 (114.00 RON) ///OMI/1200221373/114.00//
01a09aec-fec0-709a-99ef-03b2cdd515a8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.11	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7100-bb7f-e67f592f16e4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2025-12-18	0.4422	226.1200	99.99	0.00	OPEN BUY 0.4422 @ 226.12
01a09aec-fec0-71dd-958b-8fd837cdad20	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2025-12-12	0.1974	167.0200	32.97	0.00	OPEN BUY 0.1974/1.1974 @ 167.02
01a09aec-fec0-71f0-b7f6-cdb738d23fc0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.01	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-724e-90d6-0242c76328a5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-01-14	0.3225	310.0000	99.98	0.00	OPEN BUY 0.3225 @ 310.00
01a09aec-fec0-727b-9476-6c8cf41b345a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2025-12-16	0.3446	290.1700	99.99	0.00	OPEN BUY 0.3446 @ 290.17
01a09aec-fec0-741e-aa77-358ac29d3650	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-12-30	0.3392	294.8200	100.00	0.00	OPEN BUY 0.3392 @ 294.82
01a09aec-fec0-74f5-8f81-22c35e7e4f0a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	1.04	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7580-9787-715df9fbd577	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-01-08	0.6153	162.5600	100.02	0.00	OPEN BUY 0.6153 @ 162.56
01a09aec-fec0-758e-bb78-dfafa13b084d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-01-07	0.0000	0.0000	11.58	0.00	Free-funds Interest 2025-12
01a09aec-fec0-75a0-ae67-14aee963588f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.05	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-75c8-862d-bb464e72fcf9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-01-06	0.3267	306.0000	99.97	0.00	OPEN BUY 0.3267 @ 306.00
01a09aec-fec0-75fe-9c18-97fdc68c4a5c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.01	0.00	MU.US USD WHT 30%
01a09aec-fec0-7629-9112-4869e0715f8b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.03	0.00	MU.US USD WHT 30%
01a09aec-fec0-767e-9d13-158909293f75	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-12-04	0.0000	0.0000	1.00	0.00	Free-funds Interest Tax 2025-11
01a09aec-fec0-7686-b711-a9956261b25f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-12-15	0.0000	0.0000	0.63	0.00	GOOGL.US USD WHT 30%
01a09aec-fec0-76c6-aabd-e9221ee1db2b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.58	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-76df-855b-e7d8e30dd3de	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.35	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-76f0-b2f0-08e22852851d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.11	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-775f-95f2-ec9eb219762c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.05	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-77ba-a8c6-b3762a931394	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-12-15	0.0000	0.0000	0.38	0.00	GOOGL.US USD WHT 30%
01a09aec-fec0-77c0-a03e-785441ad632c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.23	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-77e4-aea5-b99c44910038	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-12-03	1.0000	147.6900	147.69	0.00	OPEN BUY 1/1.3548 @ 147.69
01a09aec-fec0-7810-a6bb-0cbcdbd7f7d3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.02	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-787e-8042-6e43b8988321	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2025-12-23	0.6012	166.3100	99.99	0.00	OPEN BUY 0.6012 @ 166.31
01a09aec-fec0-78a9-93bd-805297f0c6b8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2025-12-09	0.5815	171.9400	99.98	0.00	OPEN BUY 0.5815 @ 171.94
01a09aec-fec0-78ed-b3f1-6d6d1f71a2ee	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.81	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7950-b523-4528063c5290	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2025-12-15	0.0000	0.0000	0.02	0.00	GOOGL.US USD WHT 30%
01a09aec-fec0-7990-a56f-9d3f6d8958bd	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2025-12-12	1.0000	166.9800	166.98	0.00	OPEN BUY 1/1.1974 @ 166.98
01a09aec-fec0-7996-9645-7c5b4b7606c9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2025-11-26	0.4680	230.7400	107.99	0.00	OPEN BUY 0.468/3.468 @ 230.74
01a09aec-fec0-79e5-8b89-0a897feceecb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2025-12-04	0.0000	0.0000	14.18	0.00	Free-funds Interest 2025-11
01a09aec-fec0-7a09-ad6d-d69c62eed40b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.69	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7a4b-95ea-7aa796cab2c7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2026-01-05	1.0000	58.3800	58.38	0.00	OPEN BUY 1/1.7624 @ 58.38
01a09aec-fec0-7a89-9b6b-112075938fd6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-01-02	0.6996	142.9200	99.99	0.00	OPEN BUY 0.6996 @ 142.92
01a09aec-fec0-7ab7-a921-00bdd42729db	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-07	0.0000	0.0000	1.00	0.00	Free-funds Interest Tax 2025-12
01a09aec-fec0-7b1e-88cd-c989de416416	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.35	0.00	MU.US USD WHT 30%
01a09aec-fec0-7b1f-a02d-8ea0d0c382f5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.05	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7b2c-9c84-ede6f3dd76ab	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.35	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7b37-aef7-06a2facc7163	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-12-15	0.0000	0.0000	0.06	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-fec0-7bed-8256-18d5a6835834	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.35	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7c17-a35b-b4275a215b37	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	1.15	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7c3c-8f40-2890b032dde9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-12-15	0.0000	0.0000	2.10	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-fec0-7d46-8bf2-dd694062ea77	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2025-12-03	0.3548	147.6900	52.40	0.00	OPEN BUY 0.3548/1.3548 @ 147.69
01a09aec-fec0-7d4b-bc39-f45f6ec03ae3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.31	0.00	MU.US USD WHT 30%
01a09aec-fec0-7d9b-a1ae-4a586155b0b7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.23	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7dec-b0b4-fae05c1f439c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.07	0.00	MU.US USD WHT 30%
01a09aec-fec0-7ded-a962-74e248ca13de	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec0-7dfa-930a-6ea641ad12ce	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2025-12-15	0.0000	0.0000	1.26	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-fec0-7e24-846c-5f99ca4c5b6b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.02	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7f94-b57c-56e473a98a2e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-01-14	0.0000	0.0000	0.69	0.00	MU.US USD 0.1150/ SHR
01a09aec-fec0-7fb9-9adc-d2ca495fa799	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2026-01-05	0.7624	56.7400	43.26	0.00	OPEN BUY 0.7624/1.7624 @ 56.74
01a09aec-fec0-7fda-8c61-d4c4c131b854	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2025-12-17	0.6675	149.8000	99.99	0.00	OPEN BUY 0.6675 @ 149.80
01a09aec-fec0-7fe8-863d-a2303af7fee1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-01-09	0.6161	162.3000	99.99	0.00	OPEN BUY 0.6161 @ 162.30
01a09aec-fec1-7148-be03-2465567e117a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-02-03	0.0000	0.0000	1.00	0.00	Free-funds Interest Tax 2026-01
01a09aec-fec1-7149-8624-1f403877cfe9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-03	0.0774	96.2300	7.45	0.00	OPEN BUY 0.0774/2.0774 @ 96.23
01a09aec-fec1-7160-9cb6-fd5c0c69005b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2026-02-06	0.5164	387.2900	200.00	0.00	OPEN BUY 0.5164 @ 387.29
01a09aec-fec1-7168-964f-8b4382ddb3f4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.07	0.00	MU.US USD WHT 30%
01a09aec-fec1-718d-b37b-04c26c5771b3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.11	0.00	MU.US USD WHT 30%
01a09aec-fec1-71f5-9987-b1f1200c2425	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	1	2026-02-05	0.0001	355.1600	0.04	0.00	CLOSE BUY 0.0001 @ 355.16
01a09aec-fec1-7216-a223-bcf08ba453cc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-01-20	0.5676	176.1500	99.98	0.00	OPEN BUY 0.5676 @ 176.15
01a09aec-fec1-7287-8968-1c5869fa4de8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-13	0.7721	26.4500	20.42	0.00	OPEN BUY 0.7721/3.7721 @ 26.45
01a09aec-fec1-72fc-844e-823810dbb5f9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-03	2.0000	95.9100	191.82	0.00	OPEN BUY 2/2.0731 @ 95.91
01a09aec-fec1-7309-bd89-e3bdccbfbc66	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-02-24	0.7754	128.9500	99.99	0.00	OPEN BUY 0.7754 @ 128.95
01a09aec-fec1-7315-82ca-f5de5d5ba389	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	1	2026-02-05	0.6067	355.1600	215.48	0.00	CLOSE BUY 0.6067/2.6067 @ 355.16
01a09aec-fec1-738d-b584-51b7e99cc52c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-02	0.8761	114.1000	99.96	0.00	OPEN BUY 0.8761 @ 114.10
01a09aec-fec1-73aa-b363-c3594b89fc40	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-19	0.3029	23.2400	7.04	0.00	OPEN BUY 0.3029/4.3029 @ 23.24
01a09aec-fec1-7401-8775-5013e115f57b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-02-27	0.3962	252.3700	99.99	0.00	OPEN BUY 0.3962 @ 252.37
01a09aec-fec1-7407-a04b-69efd7ac116d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-19	0.3010	23.2500	7.00	0.00	OPEN BUY 0.301/4.301 @ 23.25
01a09aec-fec1-7444-822d-141ea0d40f56	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	2	2026-01-28	0.0000	0.0000	1.40	0.00	IDCC.US USD 0.7000/ SHR
01a09aec-fec1-7461-a012-e64e0f4d6f83	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.11	0.00	MU.US USD WHT 30%
01a09aec-fec1-747f-bea7-53239a90a9aa	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	1	2026-02-05	0.0001	354.5200	0.04	0.00	CLOSE BUY 0.0001/2.6067 @ 354.52
01a09aec-fec1-749e-ae47-c52d24c4aafa	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-02-04	0.9898	101.0300	100.00	0.00	OPEN BUY 0.9898 @ 101.03
01a09aec-fec1-74d8-93e6-f192773ae96e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-01-22	0.3369	296.8200	100.00	0.00	OPEN BUY 0.3369 @ 296.82
01a09aec-fec1-755d-a4be-4005a6ae2ed2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2026-02-12	0.5050	198.0000	99.99	0.00	OPEN BUY 0.505 @ 198.00
01a09aec-fec1-760f-9801-e7d14a9df43c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-02-06	0.9393	106.8200	100.34	0.00	OPEN BUY 0.9393 @ 106.82
01a09aec-fec1-7640-a86a-1bcc0238308c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2026-03-16	0.0000	0.0000	2.10	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-fec1-7671-97b4-7b0a41895d11	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-16	0.0000	0.0000	0.38	0.00	GOOGL.US USD WHT 30%
01a09aec-fec1-769c-bd9d-a2bad6028438	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	1	2026-02-05	1.9999	354.5200	709.00	0.00	CLOSE BUY 1.9999/2.6067 @ 354.52
01a09aec-fec1-76a0-9f39-f3953b4c696b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-02	0.8761	114.1000	99.96	0.00	OPEN BUY 0.8761 @ 114.10
01a09aec-fec1-7721-8703-9f5fde7fd4a5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-01-27	0.7620	131.2200	99.99	0.00	OPEN BUY 0.762 @ 131.22
01a09aec-fec1-7735-8bb0-3aa998e19841	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-01-27	0.7606	131.4600	99.99	0.00	OPEN BUY 0.7606 @ 131.46
01a09aec-fec1-77a8-9920-bb271bf23be8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.03	0.00	MU.US USD WHT 30%
01a09aec-fec1-77ca-8a83-de676ca46453	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-16	0.0000	0.0000	0.63	0.00	GOOGL.US USD WHT 30%
01a09aec-fec1-7814-b065-516c5545f7ee	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2026-02-12	0.0145	197.1400	2.86	0.00	OPEN BUY 0.0145/1.0145 @ 197.14
01a09aec-fec1-781c-a198-1cec6ddde91e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-19	4.0000	23.2900	93.16	0.00	OPEN BUY 4/4.3029 @ 23.29
01a09aec-fec1-787d-b474-e0a7b7544b45	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-01-29	12.0000	39.0500	468.60	0.00	OPEN BUY 12/12.7942 @ 39.05
01a09aec-fec1-78b1-baa6-cd9f35e0a1b8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-13	0.7721	26.4500	20.42	0.00	OPEN BUY 0.7721/3.7721 @ 26.45
01a09aec-fec1-7924-ad7d-188be69add4d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-777c-a7e4-586834fdefce	2	2026-01-28	0.0000	0.0000	0.42	0.00	IDCC.US USD 0.7000/ SHR
01a09aec-fec1-7963-ad39-25bae120ee23	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-03-05	0.0000	0.0000	4.52	0.00	Free-funds Interest 2026-02
01a09aec-fec1-7983-8d61-266cc30858ba	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2026-03-16	0.0000	0.0000	0.06	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-fec1-7999-8cbd-b27330b04d3f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-03-02	0.3675	272.0800	99.99	0.00	OPEN BUY 0.3675 @ 272.08
01a09aec-fec1-799a-a3f0-447f3dc67605	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.11	0.00	MU.US USD WHT 30%
01a09aec-fec1-79c5-bbf9-ccf6517bf47d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-03-03	1.0000	110.5500	110.55	0.00	OPEN BUY 1/1.8047 @ 110.55
01a09aec-fec1-79e2-98b4-67022f0c3612	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2026-03-09	0.2676	373.6200	99.98	0.00	OPEN BUY 0.2676 @ 373.62
01a09aec-fec1-79f8-a851-3c3b8ff58080	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec1-7a82-9430-b599932df175	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.24	0.00	MU.US USD WHT 30%
01a09aec-fec1-7a9a-a739-6cdaeb155179	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-28	0.0000	0.0000	0.42	0.00	IDCC.US USD WHT 30%
01a09aec-fec1-7aab-8786-0992c7955212	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-01-29	0.7942	39.0800	31.04	0.00	OPEN BUY 0.7942/12.7942 @ 39.08
01a09aec-fec1-7b2a-8a16-6aed24a25200	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-13	3.0000	26.3900	79.17	0.00	OPEN BUY 3/3.7721 @ 26.39
01a09aec-fec1-7b2c-80a5-45bf805463ec	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-01-29	1.0000	298.0000	298.00	0.00	OPEN BUY 1/1.0083 @ 298.00
01a09aec-fec1-7ba0-ab9f-dd5965dd096a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2	2026-03-16	0.0000	0.0000	1.26	0.00	GOOGL.US USD 0.2100/ SHR
01a09aec-fec1-7bb5-95eb-54eaba2991cb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-03	2.0000	96.2100	192.42	0.00	OPEN BUY 2/2.0774 @ 96.21
01a09aec-fec1-7c0f-a99e-adb92f462d7b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-13	3.0000	26.4100	79.23	0.00	OPEN BUY 3/3.7721 @ 26.41
01a09aec-fec1-7c33-a4e5-55143f29e07b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.21	0.00	MU.US USD WHT 30%
01a09aec-fec1-7c3c-b089-22844f924641	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-03	0.0731	96.4700	7.05	0.00	OPEN BUY 0.0731/2.0731 @ 96.47
01a09aec-fec1-7c52-b910-1a91d58a4d39	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-03-03	0.8047	110.8200	89.18	0.00	OPEN BUY 0.8047/1.8047 @ 110.82
01a09aec-fec1-7c5f-a295-16f834d85555	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-28	0.0000	0.0000	0.13	0.00	IDCC.US USD WHT 30%
01a09aec-fec1-7c71-9fed-349dabbf55a5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-19	4.0000	23.3000	93.20	0.00	OPEN BUY 4/4.301 @ 23.30
01a09aec-fec1-7c7e-a38e-fd22e38d6bd0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-01-28	50.0000	36.5300	1826.50	0.00	OPEN BUY 50 @ 36.53
01a09aec-fec1-7ced-bc7a-2fb585620175	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.01	0.00	MU.US USD WHT 30%
01a09aec-fec1-7d6f-9285-6a824c12dcd8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-02-13	0.3536	282.7600	99.98	0.00	OPEN BUY 0.3536 @ 282.76
01a09aec-fec1-7d87-910c-82bdaf92fe33	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.21	0.00	MU.US USD WHT 30%
01a09aec-fec1-7da6-acd6-e9b089f8cf92	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2026-02-09	0.2575	388.5800	100.06	0.00	OPEN BUY 0.2575 @ 388.58
01a09aec-fec1-7e40-b8ae-c9fe794a504e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-01-29	0.0083	297.5300	2.47	0.00	OPEN BUY 0.0083/1.0083 @ 297.53
01a09aec-fec1-7e93-81ee-f1702a98a0bf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2026-02-12	1.0000	197.5600	197.56	0.00	OPEN BUY 1/1.0145 @ 197.56
01a09aec-fec1-7f2d-a9a3-20548a927e14	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.17	0.00	MU.US USD WHT 30%
01a09aec-fec1-7f4f-b9b9-73af5beec8e5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	0	2026-01-30	0.5270	379.4800	199.99	0.00	OPEN BUY 0.527 @ 379.48
01a09aec-fec1-7f8f-b474-a47bf798e507	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-01-14	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec1-7f94-a857-7285893b633d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2026-02-03	0.5000	434.0200	217.01	0.00	OPEN BUY 0.5 @ 434.02
01a09aec-fec1-7fd5-a828-09163c407c60	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-02-03	0.0000	0.0000	9.36	0.00	Free-funds Interest 2026-01
01a09aec-fec1-7fd9-b9ee-f8b9e941a802	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-02-20	0.7436	134.4000	99.94	0.00	OPEN BUY 0.7436 @ 134.40
01a09aec-fec1-7ff1-8d18-d21461206eeb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-16	0.0000	0.0000	0.02	0.00	GOOGL.US USD WHT 30%
01a09aec-fec2-70b2-879d-644f711cadf4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.14	0.00	MU.US USD WHT 30%
01a09aec-fec2-70c1-812b-1f0208bfe2f2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-03-26	0.0000	0.0000	0.02	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec2-70c9-8058-a609ae174a7c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-03-26	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec2-70ea-8fc5-6628a3a15977	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-26	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec2-7115-b4e8-b57dea378dee	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec2-7174-b02a-8c6e8c313fc7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-26	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec2-719f-a1ae-04b12d5bd66f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2026-04-09	0.7746	36.0800	27.95	0.00	OPEN BUY 0.7746/2.7746 @ 36.08
01a09aec-fec2-71d1-a4ed-4495abfb91bf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-19	4.0000	23.1100	92.44	0.00	OPEN BUY 4/4.3159 @ 23.11
01a09aec-fec2-7283-8cd6-cb4acdbc3727	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-03-26	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec2-7356-84a7-cb5eef3181a3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-26	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec2-7392-86e6-61d334a19364	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2026-04-09	2.0000	36.0800	72.16	0.00	OPEN BUY 2/2.7746 @ 36.08
01a09aec-fec2-739f-bc82-90eb6c42d8a4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	1.38	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-743f-bbe4-1383a04e278d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.30	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-74d7-9de6-9f9d193ec7a8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.05	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-750a-a4db-670712bfeebc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-03-26	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec2-7512-963b-333638e53063	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.47	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7514-a6ce-995c94811c1a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-26	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec2-756a-ae52-64299f3f53ac	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.08	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-769d-885a-ac0e51548c60	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-04-14	3.0000	30.9600	92.88	0.00	OPEN BUY 3/3.2351 @ 30.96
01a09aec-fec2-76d8-890b-f1239ca072a6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.96	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-76e7-8d26-83dc009fd34f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.04	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7718-915f-7b02fbdcd435	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2026-03-30	0.6210	322.0300	199.98	0.00	OPEN BUY 0.621 @ 322.03
01a09aec-fec2-7761-a3c1-108e0a337f87	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2026-03-24	0.5053	395.7400	199.97	0.00	OPEN BUY 0.5053 @ 395.74
01a09aec-fec2-777d-a6ae-43ec675ff07e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-30	0.2988	87.0000	26.00	0.00	OPEN BUY 0.2988/2.2988 @ 87.00
01a09aec-fec2-7793-8fc7-8c240993e65b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-03-26	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec2-78b6-96e5-7bfaf444c647	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.04	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-78d9-92a4-9d76ee8f9c69	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-26	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec2-79a2-b576-506c4bff3402	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2026-04-01	0.5317	376.1000	199.97	0.00	OPEN BUY 0.5317 @ 376.10
01a09aec-fec2-7a58-a9d4-3ca42f778ca2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.96	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7a78-b4bd-3d6851e7a5d8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-03-30	2.0000	86.8100	173.62	0.00	OPEN BUY 2/2.2988 @ 86.81
01a09aec-fec2-7a99-a718-968d79551fcb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2026-03-30	0.5971	167.2600	99.87	0.00	OPEN BUY 0.5971 @ 167.26
01a09aec-fec2-7b7f-a67f-b686d44489ee	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-03-26	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec2-7bb4-b4de-d669b36c66b5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.52	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7bd0-a093-4c903bb85b73	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.75	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7c1d-85a4-6e0cc268815a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-26	0.0000	0.0000	0.02	0.00	VRT.US USD WHT 30%
01a09aec-fec2-7c26-b142-5068a183c343	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.30	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7c5d-ac74-4b1a16350370	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.08	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7c79-a5a7-ed9164ba299b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-03-20	0.3720	268.7900	99.99	0.00	OPEN BUY 0.372 @ 268.79
01a09aec-fec2-7c7b-92c8-55acc28f57f1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-04-14	0.2351	30.9000	7.26	0.00	OPEN BUY 0.2351/3.2351 @ 30.90
01a09aec-fec2-7cc2-bbf4-580ddbad9277	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-03-19	0.3159	23.1300	7.31	0.00	OPEN BUY 0.3159/4.3159 @ 23.13
01a09aec-fec2-7d98-a5f4-d14fbc59cafc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	1.19	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7dec-8472-685edd29e9e7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-03-26	0.0000	0.0000	0.07	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec2-7e02-b970-afdcc385ee77	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.48	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7e2c-b4f6-96c558874e62	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2026-04-09	2.0000	36.0800	72.16	0.00	OPEN BUY 2/2.7716 @ 36.08
01a09aec-fec2-7e3c-81e2-4235f13988d1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-04-03	0.0000	0.0000	2.57	0.00	Free-funds Interest 2026-03
01a09aec-fec2-7e89-95b1-ffeac9e103a9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	0	2026-04-09	0.7716	36.0800	27.84	0.00	OPEN BUY 0.7716/2.7716 @ 36.08
01a09aec-fec2-7ed3-a573-7c719958f1d4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	1.50	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec2-7f10-a77b-efac02706517	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	0	2026-03-30	0.5844	342.3000	200.04	0.00	OPEN BUY 0.5844 @ 342.30
01a09aec-fec2-7f3d-865b-6114d759eb1f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.41	0.00	MU.US USD WHT 30%
01a09aec-fec2-7f6a-900c-a4c485b7e637	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-03-26	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec2-7f9f-8b24-4856c5a07f35	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-04-15	0.0000	0.0000	0.14	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec3-7006-96b1-6b67fc7d7cdf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	1	2026-04-30	10.0000	369.6000	3696.00	0.00	CLOSE BUY 10/16.2699 @ 369.60
01a09aec-fec3-703c-9cdc-ed08489bfd6c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.36	0.00	MU.US USD WHT 30%
01a09aec-fec3-704a-8324-26cd0b4cb79a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-05	0.5000	639.8700	319.94	0.00	CLOSE BUY 0.5/9.5 @ 639.87
01a09aec-fec3-70fa-bac9-0def52e92a4d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.09	0.00	MU.US USD WHT 30%
01a09aec-fec3-7101-bb3c-6174c0c0020f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-05-08	10.0000	28.2300	282.30	0.00	OPEN BUY 10/10.6194 @ 28.23
01a09aec-fec3-7303-944e-ba3f0d74c116	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-01	0.0000	0.0000	100.24	0.00	RO tax GOOGL.US 2026-04-30 (437.00 RON) ///OMI/1428726491/437.00//
01a09aec-fec3-73c3-9e5a-6a95c7e44af2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-05-04	0.0000	0.0000	0.52	0.00	Free-funds Interest 2026-04
01a09aec-fec3-73d0-81e1-3657552371ff	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	1	2026-04-30	0.2699	369.3500	99.69	0.00	CLOSE BUY 0.2699/16.2699 @ 369.35
01a09aec-fec3-7435-9565-c68c19cbd70e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	1	2026-05-08	10.0000	87.7700	877.70	0.00	CLOSE BUY 10/33.1655 @ 87.77
01a09aec-fec3-746e-8b81-c17e43eafede	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	1	2026-05-08	10.0000	87.7700	877.70	0.00	CLOSE BUY 10/33.1655 @ 87.77
01a09aec-fec3-7499-ab21-19ab28b90916	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.16	0.00	MU.US USD WHT 30%
01a09aec-fec3-75c9-bf2d-8b9e953ff8e0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.01	0.00	MU.US USD WHT 30%
01a09aec-fec3-75f0-9d85-155256632291	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-05-08	0.6194	28.2500	17.50	0.00	OPEN BUY 0.6194/10.6194 @ 28.25
01a09aec-fec3-76e5-896e-5698137c59a1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.09	0.00	MU.US USD WHT 30%
01a09aec-fec3-76e7-a535-e87e2451d06e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-06	0.0000	0.0000	240.45	0.00	RO tax MU.US 2026-05-05 (1067.00 RON) ///OMI/1433742383/1067.00//
01a09aec-fec3-774a-9c5a-7eaac567ff96	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec3-776f-9b3e-b1f2e6d33b09	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-01	0.0000	0.0000	1.61	0.00	RO tax GOOGL.US 2026-04-30 (7.00 RON) ///OMI/1428726470/7.00//
01a09aec-fec3-7813-bce1-fb95f33de41f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	1	2026-04-30	6.0000	369.6000	2217.60	0.00	CLOSE BUY 6/16.2699 @ 369.60
01a09aec-fec3-787e-b85e-818c4d08d95b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.01	0.00	MU.US USD WHT 30%
01a09aec-fec5-7c1a-a49a-b765bfad36a1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec3-7984-8568-7e5666fe51a6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-05	5.5000	639.6400	3518.02	0.00	CLOSE BUY 5.5/9.5 @ 639.64
01a09aec-fec3-7a39-b520-d306127fe33a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-05-05	2.0000	218.7700	437.54	0.00	OPEN BUY 2/2.2831 @ 218.77
01a09aec-fec3-7a78-8fb2-3baf8703f538	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-05-05	0.2831	219.0000	62.00	0.00	OPEN BUY 0.2831/2.2831 @ 219.00
01a09aec-fec3-7b0c-aa23-9c9e35de7014	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-05-06	0.3317	214.4300	71.13	0.00	OPEN BUY 0.3317/2.3317 @ 214.43
01a09aec-fec3-7b2d-b652-4d0575da192f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	1	2026-05-08	0.1655	87.6300	14.50	0.00	CLOSE BUY 0.1655/33.1655 @ 87.63
01a09aec-fec3-7b6a-9ab0-403168d36214	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.45	0.00	MU.US USD WHT 30%
01a09aec-fec3-7bac-8b2f-8d9a60acc727	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec3-7c48-b08a-851c2645dcfb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.14	0.00	MU.US USD WHT 30%
01a09aec-fec3-7c85-9cc7-47bb345ef016	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	1	2026-05-08	3.8345	87.7700	336.55	0.00	CLOSE BUY 3.8345/33.1655 @ 87.77
01a09aec-fec3-7cb8-b6a8-731e591a091e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.29	0.00	MU.US USD WHT 30%
01a09aec-fec3-7cda-8a21-c217dda3cea1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.04	0.00	MU.US USD WHT 30%
01a09aec-fec3-7d12-beae-4a5d3b2d62c8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.23	0.00	MU.US USD WHT 30%
01a09aec-fec3-7d18-bcb0-5671277ceef3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-06	0.0000	0.0000	13.30	0.00	RO tax MU.US 2026-05-05 (59.00 RON) ///OMI/1433742381/59.00//
01a09aec-fec3-7d6f-89ae-d2807ebf3050	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-05-06	2.0000	214.0000	428.00	0.00	OPEN BUY 2/2.3317 @ 214.00
01a09aec-fec3-7dad-bff3-1f6f1e13932b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-05	1.5000	639.6400	959.46	0.00	CLOSE BUY 1.5/9.5 @ 639.64
01a09aec-fec3-7dae-a529-e475471e007f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-04-15	0.0000	0.0000	0.29	0.00	MU.US USD WHT 30%
01a09aec-fec3-7e48-9718-625a19d4ced1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	0	2026-04-23	0.4547	223.8100	101.77	0.00	OPEN BUY 0.4547 @ 223.81
01a09aec-fec3-7f0c-8bbb-c11971dfe629	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-05	2.0000	639.6400	1279.28	0.00	CLOSE BUY 2/9.5 @ 639.64
01a09aec-fec3-7fdd-8bc9-6be5182b199c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-76f4-bba8-c8836a215b85	1	2026-05-08	9.1655	87.7700	804.46	0.00	CLOSE BUY 9.1655/33.1655 @ 87.77
01a09aec-fec4-7036-8f41-767d6fe2f115	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-09	1.0000	349.8200	349.82	0.00	OPEN BUY 1/1.145 @ 349.82
01a09aec-fec4-7138-83ff-85ea579138a4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec4-714f-81c6-40045d3a8005	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-26	0.4065	882.5000	358.74	0.00	CLOSE BUY 0.4065/8.5 @ 882.50
01a09aec-fec4-7217-94ae-232ba00c6347	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-06-09	0.5842	278.6400	162.78	0.00	OPEN BUY 0.5842/3.5842 @ 278.64
01a09aec-fec4-7225-9a9b-0ec67b74af01	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-05-19	0.5965	336.7700	200.88	0.00	OPEN BUY 0.5965 @ 336.77
01a09aec-fec4-7299-a6e0-79fecff2c46f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2026-06-09	2.0000	555.2600	1110.52	0.00	OPEN BUY 2 @ 555.26
01a09aec-fec4-72d1-ac8a-e48bbded82a2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.02	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec4-7335-812c-704804172422	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-27	0.0000	0.0000	331.73	0.00	RO tax MU.US 2026-05-26 (1495.00 RON) ///OMI/1459709911/1495.00//
01a09aec-fec4-734c-85aa-301faf1e53b6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-06-03	0.0000	0.0000	17.43	0.00	Free-funds Interest 2026-05
01a09aec-fec4-7372-bb36-df146208a457	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-05-18	2.0000	157.4200	314.84	0.00	OPEN BUY 2/2.5 @ 157.42
01a09aec-fec4-73c7-b90c-208731017793	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-06-01	20.0000	235.9800	4719.60	0.00	OPEN BUY 20 @ 235.98
01a09aec-fec4-75d7-8028-2cd3d363061a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-09	0.0000	0.0000	49.41	0.00	RO tax INOD.US 2026-05-08 (221.00 RON) ///OMI/1438714200/221.00//
01a09aec-fec4-75de-91cc-464c4e9b516f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-06-01	5.0000	1031.6900	5158.45	0.00	CLOSE BUY 5/14 @ 1031.69
01a09aec-fec4-75e5-b893-3b229335e769	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-04	1.0000	407.9500	407.95	0.00	OPEN BUY 1 @ 407.95
01a09aec-fec4-7671-a93f-e23f27d3aa3c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-05-11	0.3642	29.1000	10.60	0.00	OPEN BUY 0.3642/34.3642 @ 29.10
01a09aec-fec4-76cd-9a93-ddf38284da67	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-05-11	34.0000	29.0600	988.04	0.00	OPEN BUY 34/34.3642 @ 29.06
01a09aec-fec4-76f6-8b5a-0dcdce447f62	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec4-7733-aa11-c670471ed179	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-05-18	0.5000	157.5300	78.76	0.00	OPEN BUY 0.5/2.5 @ 157.53
01a09aec-fec4-7754-8138-2634dab42530	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-23	0.0000	0.0000	181.14	0.00	RO tax ALAB.US 2026-06-22 (828.00 RON) ///OMI/1494925758/828.00//
01a09aec-fec4-7770-ae3a-8283aeda27d8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-04	0.4908	407.9500	200.22	0.00	OPEN BUY 0.4908 @ 407.95
01a09aec-fec4-7792-990e-54c8e5b3eb51	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-06-09	3.0000	277.9600	833.88	0.00	OPEN BUY 3/3.5842 @ 277.96
01a09aec-fec4-7862-b8c4-818613e0349c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-23	0.1280	354.5800	45.39	0.00	OPEN BUY 0.128/1.128 @ 354.58
01a09aec-fec4-7865-9c58-da3277da3e68	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-23	1.0000	354.5800	354.58	0.00	OPEN BUY 1/1.128 @ 354.58
01a09aec-fec4-792d-beb5-9628fd582766	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-06-22	1.0000	351.1900	351.19	0.00	OPEN BUY 1 @ 351.19
01a09aec-fec4-795d-9e1e-f14801a30887	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-05-12	2.0000	188.0000	376.00	0.00	OPEN BUY 2/2.1293 @ 188.00
01a09aec-fec4-798a-9e06-520c734c6027	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-26	1.1845	882.5000	1045.32	0.00	CLOSE BUY 1.1845/8.5 @ 882.50
01a09aec-fec4-79e5-a9f5-666f28f12218	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-03	0.0000	0.0000	2.00	0.00	Free-funds Interest Tax 2026-05
01a09aec-fec4-7a8f-bd89-a5ea8f1994a7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-06-22	2.7737	421.1700	1168.20	0.00	CLOSE BUY 2.7737/12 @ 421.17
01a09aec-fec4-7ac1-a45d-f08febd0ea0b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-26	6.4090	882.5000	5655.94	0.00	CLOSE BUY 6.409/8.5 @ 882.50
01a09aec-fec4-7ac1-b9a6-a30f60ef0613	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-06-22	2.2233	421.1700	936.39	0.00	CLOSE BUY 2.2233/12 @ 421.17
01a09aec-fec4-7b25-949d-7965cc46f9d3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-02	0.0000	0.0000	706.00	0.00	RO tax MU.US 2026-06-01 (3184.00 RON) ///OMI/1467257227/3184.00//
01a09aec-fec4-7b4c-8652-5e356da32fc6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.22	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec4-7b8e-8c17-3a30dff1035f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-06-22	4.5541	421.1700	1918.05	0.00	CLOSE BUY 4.5541/12 @ 421.17
01a09aec-fec4-7b9d-8cb0-fba225d516df	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-09	0.1450	349.3300	50.65	0.00	OPEN BUY 0.145/1.145 @ 349.33
01a09aec-fec4-7c06-974e-b7a42dbc94ec	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec4-7c2c-91fe-03323918684f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-06-02	15.0000	219.6000	3294.00	0.00	OPEN BUY 15 @ 219.60
01a09aec-fec4-7c3c-a016-6380aebeffea	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-06-04	3.0000	206.1800	618.54	0.00	OPEN BUY 3 @ 206.18
01a09aec-fec4-7c6c-89cb-71b840760830	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-05-26	0.5000	882.1000	441.05	0.00	CLOSE BUY 0.5/8.5 @ 882.10
01a09aec-fec4-7c70-8c52-906f237d76eb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-05-26	0.4456	28.7200	12.80	0.00	OPEN BUY 0.4456/10.4456 @ 28.72
01a09aec-fec4-7c94-a674-1a9653e3f01d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-06-01	8.0234	1031.6900	8277.66	0.00	CLOSE BUY 8.0234/14 @ 1031.69
01a09aec-fec4-7ca9-ac51-24b8f4a00814	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	0	2026-05-26	10.0000	28.7200	287.20	0.00	OPEN BUY 10/10.4456 @ 28.72
01a09aec-fec4-7cbf-adcf-47422c1e918e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-16	0.0318	387.6600	12.33	0.00	OPEN BUY 0.0318/1.0318 @ 387.66
01a09aec-fec4-7ccd-94ff-f851f2051529	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-09	0.0000	0.0000	0.22	0.00	RO tax INOD.US 2026-05-08 (1.00 RON) ///OMI/1438714190/1.00//
01a09aec-fec4-7d7a-81e8-7dd64f479e80	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec4-7db5-82ba-35d3f0a5a23f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-16	1.0000	387.6200	387.62	0.00	OPEN BUY 1/1.0318 @ 387.62
01a09aec-fec4-7f47-99cb-e2574650f683	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-06-22	2.4489	421.1700	1031.40	0.00	CLOSE BUY 2.4489/12 @ 421.17
01a09aec-fec4-7f51-9d09-68c01145e22d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-05-12	0.8227	364.7300	300.06	0.00	OPEN BUY 0.8227 @ 364.73
01a09aec-fec4-7f64-8105-b89ee56eae9b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-05-12	0.1293	188.7000	24.40	0.00	OPEN BUY 0.1293/2.1293 @ 188.70
01a09aec-fec4-7f7c-a14e-e1152cd423b6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-05-27	0.0000	0.0000	20.64	0.00	RO tax MU.US 2026-05-26 (93.00 RON) ///OMI/1459709909/93.00//
01a09aec-fec4-7fb5-be5f-7dd24dc9f23c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-06-01	0.9766	1031.6900	1007.55	0.00	CLOSE BUY 0.9766/14 @ 1031.69
01a09aec-fec4-7fe8-a5a1-29016348aece	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-06-02	5.0000	213.8200	1069.10	0.00	OPEN BUY 5 @ 213.82
01a09aec-fec5-703b-92e3-b9aff0012513	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	1.50	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-70da-8d95-d574fc2b7c81	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.05	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-70e0-b972-a878fe4346bf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec5-7102-8cf1-0ea3f043a074	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.09	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7147-b838-b497e99d7778	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.04	0.00	MU.US USD WHT 30%
01a09aec-fec5-71a9-b239-231476dfa87c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-08-11	2.8758	309.8700	891.12	0.00	CLOSE BUY 2.8758/8.5 @ 309.87
01a09aec-fec5-71d1-86d3-4452ba6ccc0e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	1.0340	243.7600	252.05	0.00	CLOSE BUY 1.034/25 @ 243.76
01a09aec-fec5-7210-8354-85f9bc41f4d4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-07-06	0.0000	0.0000	28.87	0.00	Free-funds Interest 2026-06
01a09aec-fec5-7219-8983-502763bc61d9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.08	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7252-975f-37f88047c854	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.45	0.00	MU.US USD WHT 30%
01a09aec-fec5-7265-971d-b32e1eae6c28	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec5-726a-9d8f-f04402d009a3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-07-21	0.9881	303.9800	300.36	0.00	OPEN BUY 0.9881 @ 303.98
01a09aec-fec5-727a-85fe-11ef9b109e3e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-07-16	0.5000	214.5900	107.30	0.00	OPEN BUY 0.5/1.5 @ 214.59
01a09aec-fec5-7280-b2db-1ed95b2d2cca	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.08	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-72d2-bb2f-a22f7e97cadc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.08	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-730b-8800-ee8b85cf2269	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-08-04	0.0000	0.0000	25.80	0.00	Free-funds Interest 2026-07
01a09aec-fec5-7341-8496-486feef8faa6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-08-11	0.8270	309.8800	256.27	0.00	CLOSE BUY 0.827/8.5 @ 309.88
01a09aec-fec5-7356-9d71-e9c373611b37	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.52	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7357-91d8-55d0d8c2c1f9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec5-739b-af35-91e1025ebdeb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec5-73df-95a0-d33b371957f2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-04	0.0000	0.0000	3.00	0.00	Free-funds Interest Tax 2026-07
01a09aec-fec5-7454-92ec-7ea9051e41cb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-78d7-b474-9ae90156cbbf	0	2026-06-29	12.0000	164.0800	1968.96	0.00	OPEN BUY 12/12.181 @ 164.08
01a09aec-fec5-746a-8a2e-3317e50630f2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-07-07	1.0000	384.9900	384.99	0.00	OPEN BUY 1/1.2987 @ 384.99
01a09aec-fec5-74e3-aa04-2cd699ad39e8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec5-758b-9e08-6641ae43866e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.31	0.00	MU.US USD WHT 30%
01a09aec-fec5-759f-83ab-8964650ad0e5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-07-16	1.0000	214.5900	214.59	0.00	OPEN BUY 1/1.5 @ 214.59
01a09aec-fec5-765a-84e4-0287032d84ea	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-06	0.0000	0.0000	3.00	0.00	Free-funds Interest Tax 2026-06
01a09aec-fec5-7662-bf15-346c25d97214	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-06-29	0.5850	341.8600	199.99	0.00	OPEN BUY 0.585 @ 341.86
01a09aec-fec5-766e-96cd-382656a83c46	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.07	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec5-76b9-a8dc-b49fbda42ed2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.47	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-76dc-81d2-6085c7f24cd6	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4568-70ae-8b56-86340439138f	0	2026-07-07	0.5786	345.6600	200.00	0.00	OPEN BUY 0.5786 @ 345.66
01a09aec-fec5-76e1-a82a-b23fb7a4437f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.04	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7775-80ba-c2679c6c7e16	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec5-77dc-889b-a7201e394223	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-08-11	1.0000	309.8800	309.88	0.00	CLOSE BUY 1/8.5 @ 309.88
01a09aec-fec5-781e-b3d3-7c5385ad70ac	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec5-783d-9a8e-30df514954f0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.14	0.00	MU.US USD WHT 30%
01a09aec-fec5-784d-b643-43197e6e7610	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-78d7-b474-9ae90156cbbf	0	2026-07-15	2.0000	177.1500	354.30	0.00	OPEN BUY 2/2.8123 @ 177.15
01a09aec-fec5-789b-a205-713f65bbf23b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.02	0.00	MU.US USD WHT 30%
01a09aec-fec5-78a6-b155-f9b182a2bac3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75c7-8b48-c12503e310cb	0	2026-07-28	0.7293	87.3000	63.67	0.00	OPEN BUY 0.7293/5.7293 @ 87.30
01a09aec-fec5-7947-8a8e-734a86fe0bb5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-07-01	0.9369	320.1900	299.99	0.00	OPEN BUY 0.9369 @ 320.19
01a09aec-fec5-7951-b613-092df77402b9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-07-07	0.2987	384.9900	115.00	0.00	OPEN BUY 0.2987/1.2987 @ 384.99
01a09aec-fec5-7971-8296-50ac3ad0643a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.07	0.00	VRT.US USD WHT 30%
01a09aec-fec5-79a7-833f-d3c00df44518	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	1.04	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-79e4-b8bd-9415122211ee	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.02	0.00	VRT.US USD WHT 30%
01a09aec-fec5-79f1-9d62-e8e55b34d672	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	2.0774	243.7600	506.39	0.00	CLOSE BUY 2.0774/25 @ 243.76
01a09aec-fec5-7a2b-8b81-84d433b880cf	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.04	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7a76-80b2-f243dc93efff	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.01	0.00	MU.US USD WHT 30%
01a09aec-fec5-7b00-a1a3-be8ef016920f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.09	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7b57-85a1-0a4b2aebb687	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-78d7-b474-9ae90156cbbf	0	2026-06-29	0.1810	164.1900	29.72	0.00	OPEN BUY 0.181/12.181 @ 164.19
01a09aec-fec5-7b95-8c64-2cda90263e9e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.48	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7b99-985a-36d4d093c223	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-08-11	3.1242	309.8700	968.10	0.00	CLOSE BUY 3.1242/8.5 @ 309.87
01a09aec-fec5-7ba7-a790-8fc4a85e277d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.03	0.00	MU.US USD WHT 30%
01a09aec-fec5-7bff-b89a-734f9ba33054	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-06-25	0.0000	0.0000	0.01	0.00	VRT.US USD WHT 30%
01a09aec-fec5-7c00-a29e-9d7ded6aefef	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2	2026-07-21	0.0000	0.0000	0.14	0.00	MU.US USD 0.1500/ SHR
01a09aec-fec5-7d21-ab14-93dd82da31fe	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	2	2026-06-25	0.0000	0.0000	0.04	0.00	VRT.US USD 0.0625/ SHR
01a09aec-fec5-7d75-86e6-f466baa3a314	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-08-11	0.5000	309.6100	154.80	0.00	CLOSE BUY 0.5/8.5 @ 309.61
01a09aec-fec5-7d7d-b9c8-91045e4fece0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-07-16	0.9213	326.5000	300.80	0.00	OPEN BUY 0.9213 @ 326.50
01a09aec-fec5-7dac-85fb-065586795aff	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.01	0.00	MU.US USD WHT 30%
01a09aec-fec5-7dd0-968c-018ca6f17196	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.16	0.00	MU.US USD WHT 30%
01a09aec-fec5-7e7c-a0fe-8610f1eec5da	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2026-07-24	0.6000	488.4600	293.08	0.00	OPEN BUY 0.6 @ 488.46
01a09aec-fec5-7eaa-9b41-f6eb3f5fbeed	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2026-07-02	1.0000	495.3600	495.36	0.00	OPEN BUY 1 @ 495.36
01a09aec-fec5-7eca-933d-5de636cee078	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.14	0.00	MU.US USD WHT 30%
01a09aec-fec5-7ed9-9d76-56782eb94250	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-07-28	1.0000	266.1300	266.13	0.00	OPEN BUY 1/1.1271 @ 266.13
01a09aec-fec5-7f09-abc3-400b009863ca	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75c7-8b48-c12503e310cb	0	2026-07-28	5.0000	87.3100	436.55	0.00	OPEN BUY 5/5.7293 @ 87.31
01a09aec-fec5-7f1a-a415-c4a788face0a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	1	2026-08-11	0.1730	309.8800	53.61	0.00	CLOSE BUY 0.173/8.5 @ 309.88
01a09aec-fec5-7f2b-ab5c-70dd9a3d237b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-07-21	0.0000	0.0000	0.03	0.00	MU.US USD WHT 30%
01a09aec-fec5-7f55-961e-14a5e15bab0d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-78d7-b474-9ae90156cbbf	0	2026-07-15	0.8123	177.8600	144.48	0.00	OPEN BUY 0.8123/2.8123 @ 177.86
01a09aec-fec5-7f55-b7a2-31cdc2db9e85	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2026-07-16	1.0000	468.9200	468.92	0.00	OPEN BUY 1 @ 468.92
01a09aec-fec5-7fe4-99dd-405482c90bc5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75ff-a369-a322f5890621	0	2026-07-28	0.1271	266.1600	33.83	0.00	OPEN BUY 0.1271/1.1271 @ 266.16
01a09aec-fec6-703c-b8ab-702d5530aaf3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-09-10	0.3966	252.1100	99.99	0.00	OPEN BUY 0.3966 @ 252.11
01a09aec-fec6-703d-bc73-ec2362d7cb4e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-09-01	0.0000	0.0000	4.00	0.00	Free-funds Interest Tax 2026-08
01a09aec-fec6-70c1-8646-1d726e66d204	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	44.12	0.00	RO tax ALAB.US 2026-08-11 (200.00 RON) ///OMI/1556040884/200.00//
01a09aec-fec6-710a-b8c9-e9a6d1266460	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-09-01	0.3518	212.6000	74.79	0.00	OPEN BUY 0.3518/2.3518 @ 212.60
01a09aec-fec6-7136-bb22-5495d8df41e7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	6.7476	243.7600	1644.79	0.00	CLOSE BUY 6.7476/25 @ 243.76
01a09aec-fec6-7145-80d2-39032de423be	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	0.13	0.00	Sec Fee adj CRDO.US 20260811
01a09aec-fec6-717c-a5e8-64bc8d1093a0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	4.3029	38.6300	166.22	0.00	CLOSE BUY 4.3029/141.9225 @ 38.63
01a09aec-fec6-7194-b16b-72ef86b7ac0a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.7620	243.7600	185.75	0.00	CLOSE BUY 0.762/25 @ 243.76
01a09aec-fec6-71d2-af1e-589874f29689	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	7.28	0.00	RO tax ALAB.US 2026-08-11 (33.00 RON) ///OMI/1556040881/33.00//
01a09aec-fec6-71fe-9f8b-81b5c46b7bfc	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-25	0.0000	0.0000	0.45	0.00	RO tax ERO.US 2026-08-24 (2.00 RON) ///OMI/1571250761/2.00//
01a09aec-fec6-7201-b958-14b18bd44c7a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-09-11	1.0000	257.1400	257.14	0.00	OPEN BUY 1/1.1666 @ 257.14
01a09aec-fec6-723b-bfd8-7af17a60d8bd	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.8761	243.7600	213.56	0.00	CLOSE BUY 0.8761/25 @ 243.76
01a09aec-fec6-72da-bc91-1f9b18405766	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	1	2026-08-11	0.5000	186.4900	93.24	0.00	CLOSE BUY 0.5/10.5 @ 186.49
01a09aec-fec6-7337-bb82-df441e9fa2ef	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	0.15	0.00	Sec Fee adj MU.US 20260811
01a09aec-fec6-734c-9146-28fba5884926	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	12.7942	38.6300	494.24	0.00	CLOSE BUY 12.7942/141.9225 @ 38.63
01a09aec-fec6-7368-981d-910249c24de4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.9393	243.7600	228.96	0.00	CLOSE BUY 0.9393/25 @ 243.76
01a09aec-fec6-7411-9595-f6dfd0e40d7b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	20.08	0.00	RO tax MU.US 2026-08-11 (91.00 RON) ///OMI/1555939747/91.00//
01a09aec-fec6-7446-ab94-cc637944665d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	2.1846	243.7600	532.52	0.00	CLOSE BUY 2.1846/25 @ 243.76
01a09aec-fec6-744b-9b04-1e3660dd23f8	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	10.4456	38.6300	403.51	0.00	CLOSE BUY 10.4456/141.9225 @ 38.63
01a09aec-fec6-7455-9fe1-c99f076f26f4	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-25	0.0000	0.0000	0.12	0.00	Sec Fee adj ERO.US 20260824
01a09aec-fec6-7462-9e7b-1f201975ebd1	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-09-01	2.0000	212.4400	424.88	0.00	OPEN BUY 2/2.3518 @ 212.44
01a09aec-fec6-74c6-96be-48a2355d682c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	0.06	0.00	Sec Fee adj ALAB.US 20260811
01a09aec-fec6-74d6-80d1-990e730985d7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-08-11	6.4481	856.5700	5523.25	0.00	CLOSE BUY 6.4481/8.5 @ 856.57
01a09aec-fec6-7503-9e23-c331fa242191	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	0.02	0.00	Sec Fee adj IESC.US 20260811
01a09aec-fec6-7523-b2ff-509d5cace7af	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-09-11	0.1666	257.1400	42.84	0.00	OPEN BUY 0.1666/1.1666 @ 257.14
01a09aec-fec6-7547-89e3-022644d0b754	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-09-02	0.8537	170.8300	145.84	0.00	OPEN BUY 0.8537/5.8537 @ 170.83
01a09aec-fec6-7572-9694-e7b437a7b1bd	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	0	2026-09-02	5.0000	170.6000	853.00	0.00	OPEN BUY 5/5.8537 @ 170.60
01a09aec-fec6-75f4-854c-2de97f51ce76	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.9898	243.7600	241.27	0.00	CLOSE BUY 0.9898/25 @ 243.76
01a09aec-fec6-760d-8c95-1a2e89e1724a	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	3.2351	38.6300	124.97	0.00	CLOSE BUY 3.2351/141.9225 @ 38.63
01a09aec-fec6-7645-ba4b-e6b08dbc511f	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	34.3642	38.6300	1327.49	0.00	CLOSE BUY 34.3642/141.9225 @ 38.63
01a09aec-fec6-7665-8ec6-82d93cdcd98b	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	3.0969	243.7600	754.90	0.00	CLOSE BUY 3.0969/25 @ 243.76
01a09aec-fec6-7676-af44-c925d90ee300	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.6996	243.7600	170.53	0.00	CLOSE BUY 0.6996/25 @ 243.76
01a09aec-fec6-76df-9887-9f9629b1e5d7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	1	2026-08-11	0.2123	747.6900	158.73	0.00	CLOSE BUY 0.2123/1 @ 747.69
01a09aec-fec6-7716-ba23-2a863cf746ef	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	319.88	0.00	RO tax MU.US 2026-08-11 (1450.00 RON) ///OMI/1555939765/1450.00//
01a09aec-fec6-7738-a9c5-ef8a9b7fcb7d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	1	2026-08-11	0.7877	747.6900	588.96	0.00	CLOSE BUY 0.7877/1 @ 747.69
01a09aec-fec6-776d-ac36-8d0d9d919df9	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	7.28	0.00	RO tax ALAB.US 2026-08-11 (33.00 RON) ///OMI/1556040882/33.00//
01a09aec-fec6-7825-a18c-06ff3357eb7e	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75c7-8b48-c12503e310cb	0	2026-09-01	9.0000	102.7700	924.93	0.00	OPEN BUY 9/9.737 @ 102.77
01a09aec-fec6-782d-9b2d-906ebfada6cb	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	0.04	0.00	Sec Fee adj LEU.US 20260811
01a09aec-fec6-78a8-a788-0ecec7dee309	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	23.61	0.00	RO tax IESC.US 2026-08-11 (107.00 RON) ///OMI/1556040622/107.00//
01a09aec-fec6-78ac-b2e6-77de521c5b97	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-75c7-8b48-c12503e310cb	0	2026-09-01	0.7370	102.7000	75.69	0.00	OPEN BUY 0.737/9.737 @ 102.70
01a09aec-fec6-7911-9717-90a151cdfc14	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	0.9225	38.6300	35.64	0.00	CLOSE BUY 0.9225/141.9225 @ 38.63
01a09aec-fec6-7963-8cf5-9c4491627c5d	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	10.6194	38.6300	410.23	0.00	CLOSE BUY 10.6194/141.9225 @ 38.63
01a09aec-fec6-79da-a10b-9b9d06a405c2	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.8761	243.7600	213.56	0.00	CLOSE BUY 0.8761/25 @ 243.76
01a09aec-fec6-7a2a-be2a-0e97ba62a515	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.7606	243.7600	185.40	0.00	CLOSE BUY 0.7606/25 @ 243.76
01a09aec-fec6-7a5e-baae-4800af563948	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	3	2026-09-01	0.0000	0.0000	41.87	0.00	Free-funds Interest 2026-08
01a09aec-fec6-7b02-8892-e80830bcf9b3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	3.7721	38.6300	145.72	0.00	CLOSE BUY 3.7721/141.9225 @ 38.63
01a09aec-fec6-7b28-9f8e-dee1f77f2c77	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-08-11	0.5000	856.5300	428.26	0.00	CLOSE BUY 0.5/8.5 @ 856.53
01a09aec-fec6-7b6a-ad3f-b321647a2904	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-78d7-b474-9ae90156cbbf	0	2026-08-19	2.0000	185.5000	371.00	0.00	OPEN BUY 2/2.6883 @ 185.50
01a09aec-fec6-7b82-ae6c-be0b98f9c043	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-25	0.0000	0.0000	65.00	0.00	RO tax ERO.US 2026-08-24 (292.00 RON) ///OMI/1571250765/292.00//
01a09aec-fec6-7bb1-833b-9b59950eaf94	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	0	2026-08-18	2.0000	471.0200	942.04	0.00	OPEN BUY 2 @ 471.02
01a09aec-fec6-7d64-be1b-28fd9032a6e5	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4576-71e2-bf71-4939cb0a312f	1	2026-08-11	10.0000	187.0000	1870.00	0.00	CLOSE BUY 10/10.5 @ 187.00
01a09aec-fec6-7d72-852c-7acfd0afe945	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-791d-b3fc-038868ce5cef	0	2026-09-09	0.3820	261.7500	99.99	0.00	OPEN BUY 0.382 @ 261.75
01a09aec-fec6-7ddc-93db-4b8e989e50ad	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	4.3159	38.6300	166.72	0.00	CLOSE BUY 4.3159/141.9225 @ 38.63
01a09aec-fec6-7e68-b659-14cea25027a3	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-78d7-b474-9ae90156cbbf	0	2026-08-19	0.6883	185.9900	128.02	0.00	OPEN BUY 0.6883/2.6883 @ 185.99
01a09aec-fec6-7eb5-966c-f6c3d36565a0	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	49.0775	38.6300	1895.86	0.00	CLOSE BUY 49.0775/141.9225 @ 38.63
01a09aec-fec6-7ec7-b34e-12feafe0358c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	88.91	0.00	RO tax CRDO.US 2026-08-11 (403.00 RON) ///OMI/1555940143/403.00//
01a09aec-fec6-7ed7-aa9d-077d119c93a7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	1	2026-08-11	1.5519	856.5700	1329.31	0.00	CLOSE BUY 1.5519/8.5 @ 856.57
01a09aec-fec6-7ed7-b6a9-cbcc1619d186	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	0.5815	243.7600	141.75	0.00	CLOSE BUY 0.5815/25 @ 243.76
01a09aec-fec6-7eda-b8d6-3c63b108be0c	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-4575-7883-ae54-8f9d1a944c07	1	2026-08-11	3.3745	243.7600	822.57	0.00	CLOSE BUY 3.3745/25 @ 243.76
01a09aec-fec6-7edc-b045-0a4d5e5bc672	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	\N	4	2026-08-12	0.0000	0.0000	3.75	0.00	RO tax ALAB.US 2026-08-11 (17.00 RON) ///OMI/1556040870/17.00//
01a09aec-fec6-7f0d-ba68-508c8b98f5b7	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	4.3010	38.6300	166.15	0.00	CLOSE BUY 4.301/141.9225 @ 38.63
01a09aec-fec6-7fca-93bd-035368d46b36	01a09aec-4524-7eaa-b25e-b6977a4fbc5c	01a09aec-feb5-712e-8c48-b883fdca364a	1	2026-08-24	3.7721	38.6300	145.72	0.00	CLOSE BUY 3.7721/141.9225 @ 38.63
\.


--
-- Data for Name: PriceHistory; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."PriceHistory" ("Id", "AssetId", "Date", "Price", "IsManual") FROM stdin;
01a09b0f-dc51-7f62-a70a-3aee4408c719	01a09aec-4568-70ae-8b56-86340439138f	2025-09-02	200.6300	f
01a09b0f-dc63-745d-9939-28ab908f7983	01a09aec-4568-70ae-8b56-86340439138f	2025-09-03	211.8700	f
01a09b0f-dc64-7020-bcde-57e13e484846	01a09aec-4568-70ae-8b56-86340439138f	2025-11-13	292.7500	f
01a09b0f-dc64-705f-9604-be3d7e7643b7	01a09aec-4568-70ae-8b56-86340439138f	2026-01-20	310.7600	f
01a09b0f-dc64-7069-9799-1e59dc1dd841	01a09aec-4568-70ae-8b56-86340439138f	2026-03-11	265.8000	f
01a09b0f-dc64-7071-a53c-caeb7e984d00	01a09aec-4568-70ae-8b56-86340439138f	2025-10-22	270.8900	f
01a09b0f-dc64-7079-9282-f88b5b3be6e4	01a09aec-4568-70ae-8b56-86340439138f	2025-09-19	252.9300	f
01a09b0f-dc64-707b-99c5-f739fcbbb50c	01a09aec-4568-70ae-8b56-86340439138f	2026-01-28	345.2300	f
01a09b0f-dc64-7086-b1d8-89adedf80f0b	01a09aec-4568-70ae-8b56-86340439138f	2026-01-21	309.7600	f
01a09b0f-dc64-708d-ad64-7c722376e8d8	01a09aec-4568-70ae-8b56-86340439138f	2025-12-08	340.7600	f
01a09b0f-dc64-709e-ab65-811bbdf00443	01a09aec-4568-70ae-8b56-86340439138f	2025-11-05	352.6100	f
01a09b0f-dc64-70b9-8084-9368740dcbed	01a09aec-4568-70ae-8b56-86340439138f	2026-02-04	275.8600	f
01a09b0f-dc64-70c8-a0c1-a862fe20d72a	01a09aec-4568-70ae-8b56-86340439138f	2026-03-16	270.5300	f
01a09b0f-dc64-70d5-8e79-ba953d1f0f37	01a09aec-4568-70ae-8b56-86340439138f	2026-03-31	281.6800	f
01a09b0f-dc64-70da-83ff-40d8adefc97f	01a09aec-4568-70ae-8b56-86340439138f	2025-12-30	299.4000	f
01a09b0f-dc64-70fc-832b-c854be46040f	01a09aec-4568-70ae-8b56-86340439138f	2026-05-01	418.9300	f
01a09b0f-dc64-7119-9733-bd56beada048	01a09aec-4568-70ae-8b56-86340439138f	2026-03-03	256.9500	f
01a09b0f-dc64-711a-a369-075c89528966	01a09aec-4568-70ae-8b56-86340439138f	2025-11-18	299.9200	f
01a0a071-88ee-7956-a445-98d3150b9e08	01a09aec-4568-70ae-8b56-86340439138f	2026-09-14	318.9900	f
01a0a071-8988-7305-acbb-0d138e16ff82	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-14	150.4600	f
01a0a071-8a08-74b6-a5e4-6d14c9760f7b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-14	148.1800	f
01a0a071-8a79-7843-88b6-589101097129	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-14	12.2850	f
01a0a071-8aee-70ce-9675-6fb2e4ffdb71	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-14	36.3600	f
01a0a071-8b61-70f5-9582-e2289dbf33a0	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-14	33.0000	f
01a0a071-8bca-7975-8d2c-2e12bb505dc7	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-14	96.2700	f
01a0a071-8c35-76d6-b470-dd007e8ab28f	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-14	260.4200	f
01a0a071-8ca6-7b42-a037-355dc4b34ce9	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-14	52.9000	f
01a0a071-8d2d-7f45-8142-d2d01e4b2cd1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-14	344.8800	f
01a0a071-8d9f-7403-8613-cfbd7aa5a768	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-14	339.0050	f
01a0a071-8e54-7137-ac0a-ea43b17f1db3	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-14	187.5750	f
01a0a071-8ec7-764d-88ae-0a2c2874a25c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-14	235.1900	f
01a0a071-8f3a-7380-b69a-4eb51a3abd21	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-14	10.9700	f
01a0a071-8fdd-79f0-b0f2-5d66e5c3daaf	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-14	320.3700	f
01a0a071-905a-71ee-9cf8-887c2ab7eb1a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-14	390.2600	f
01a0a071-90df-7ac0-9115-7a6f41f251dd	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-14	912.7190	f
01a0a071-9150-7f26-bbd5-f631045def96	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-14	127.3400	f
01a09b0f-dc64-7128-9670-fcbea891b650	01a09aec-4568-70ae-8b56-86340439138f	2025-09-05	242.6800	f
01a09b0f-dc64-7146-941f-9eaf880c03d3	01a09aec-4568-70ae-8b56-86340439138f	2026-01-22	290.9300	f
01a09b0f-dc64-7163-ae31-7aba3d3f16b9	01a09aec-4568-70ae-8b56-86340439138f	2026-01-02	302.4000	f
01a09b0f-dc64-7175-87a0-c09d6d124fd8	01a09aec-4568-70ae-8b56-86340439138f	2026-05-06	413.8700	f
01a09b0f-dc64-7176-bf51-b5f43c24d4af	01a09aec-4568-70ae-8b56-86340439138f	2026-02-11	295.6800	f
01a09b0f-dc64-717b-8277-47c75032f7c8	01a09aec-4568-70ae-8b56-86340439138f	2025-10-10	243.7200	f
01a09b0f-dc64-717d-a0a1-211d48ea4392	01a09aec-4568-70ae-8b56-86340439138f	2026-03-20	269.1000	f
01a09b0f-dc64-718f-a9b9-84dc4d53fc87	01a09aec-4568-70ae-8b56-86340439138f	2025-12-24	308.5900	f
01a09b0f-dc64-7196-9ff7-c07fc8421ab3	01a09aec-4568-70ae-8b56-86340439138f	2025-12-09	342.0300	f
01a09b0f-dc64-71e8-9510-a8b58039dd52	01a09aec-4568-70ae-8b56-86340439138f	2025-10-31	344.4800	f
01a09b0f-dc64-721c-9710-7d41e2fa9640	01a09aec-4568-70ae-8b56-86340439138f	2026-01-09	302.3000	f
01a09b0f-dc64-7224-8a9e-fe271ded3b45	01a09aec-4568-70ae-8b56-86340439138f	2026-01-14	310.0400	f
01a09b0f-dc64-722e-ac2c-84efc4337a6a	01a09aec-4568-70ae-8b56-86340439138f	2025-12-02	304.2900	f
01a09b0f-dc64-727e-a018-94376313c075	01a09aec-4568-70ae-8b56-86340439138f	2025-12-17	275.8300	f
01a09b0f-dc64-7284-bcb2-c4f3739fa4a6	01a09aec-4568-70ae-8b56-86340439138f	2025-10-03	233.6700	f
01a09b0f-dc64-729c-bc27-5617e3b69a1b	01a09aec-4568-70ae-8b56-86340439138f	2026-01-30	280.9900	f
01a09b0f-dc64-72aa-abbb-4c8afc5f680b	01a09aec-4568-70ae-8b56-86340439138f	2026-02-05	294.8900	f
01a09b0f-dc64-72ad-927d-e4f145bc992e	01a09aec-4568-70ae-8b56-86340439138f	2026-03-09	267.9500	f
01a09b0f-dc64-72e5-b861-44aa2f48809c	01a09aec-4568-70ae-8b56-86340439138f	2025-09-29	245.9500	f
01a09b0f-dc64-731c-94b3-24fc2f30a4cb	01a09aec-4568-70ae-8b56-86340439138f	2025-11-07	322.1000	f
01a09b0f-dc64-7326-9e8b-a50efdcdc88e	01a09aec-4568-70ae-8b56-86340439138f	2025-09-23	257.6400	f
01a09b0f-dc64-733c-a720-c481bf3587ff	01a09aec-4568-70ae-8b56-86340439138f	2026-04-10	351.3100	f
01a09b0f-dc64-734d-b1da-fc3e468331be	01a09aec-4568-70ae-8b56-86340439138f	2025-11-25	327.7500	f
01a09b0f-dc64-7361-9156-9039864c737c	01a09aec-4568-70ae-8b56-86340439138f	2026-02-25	293.9800	f
01a09b0f-dc64-7375-b7b5-157a2be96207	01a09aec-4568-70ae-8b56-86340439138f	2026-01-23	303.0900	f
01a09b0f-dc64-7378-aba2-8e98376a97b7	01a09aec-4568-70ae-8b56-86340439138f	2025-12-03	308.4100	f
01a09b0f-dc64-737b-9df2-6cb20e1966e9	01a09aec-4568-70ae-8b56-86340439138f	2026-05-13	372.5500	f
01a09b0f-dc64-73a0-a8d2-3effb15174a5	01a09aec-4568-70ae-8b56-86340439138f	2025-10-21	264.6900	f
01a09b0f-dc64-73d0-9ac0-52d4a24852f9	01a09aec-4568-70ae-8b56-86340439138f	2026-04-20	401.1200	f
01a09b0f-dc64-73e5-882c-551e21afc51b	01a09aec-4568-70ae-8b56-86340439138f	2026-04-21	403.0300	f
01a09b0f-dc64-73f2-b26f-9ac05c8f6dbd	01a09aec-4568-70ae-8b56-86340439138f	2026-02-24	296.3500	f
01a09b0f-dc64-7416-8fec-8b49499ca6fb	01a09aec-4568-70ae-8b56-86340439138f	2025-12-15	302.9800	f
01a09b0f-dc64-742b-b120-3a4f0485d148	01a09aec-4568-70ae-8b56-86340439138f	2025-10-27	301.8200	f
01a09b0f-dc64-7450-97c5-8b0fa64b2af8	01a09aec-4568-70ae-8b56-86340439138f	2026-04-13	365.4600	f
01a09b0f-dc64-746e-a9f4-b359b6f55d4b	01a09aec-4568-70ae-8b56-86340439138f	2025-10-16	279.8600	f
01a09b0f-dc64-7494-947d-6530b04d523a	01a09aec-4568-70ae-8b56-86340439138f	2025-12-12	306.5000	f
01a09b0f-dc64-7499-9c17-bd3ae58a42fc	01a09aec-4568-70ae-8b56-86340439138f	2025-10-23	282.7300	f
01a09b0f-dc64-74a5-aa41-addeeb873af3	01a09aec-4568-70ae-8b56-86340439138f	2025-12-26	303.5600	f
01a09b0f-dc64-7507-9c26-982533faf211	01a09aec-4568-70ae-8b56-86340439138f	2025-12-05	325.0900	f
01a09b0f-dc64-7531-97cb-3cedc0c766a6	01a09aec-4568-70ae-8b56-86340439138f	2025-09-16	254.3900	f
01a09b0f-dc64-7539-9f72-37602bdac32d	01a09aec-4568-70ae-8b56-86340439138f	2025-09-18	252.0400	f
01a09b0f-dc64-7562-ab66-a73b0d33ec96	01a09aec-4568-70ae-8b56-86340439138f	2026-03-04	270.6400	f
01a09b0f-dc64-7565-b6f4-ae68d482af91	01a09aec-4568-70ae-8b56-86340439138f	2025-10-28	326.4500	f
01a09b0f-dc64-7591-9220-5d3ada338c67	01a09aec-4568-70ae-8b56-86340439138f	2025-11-11	331.8600	f
01a09b0f-dc64-75bc-8336-082748bda5ba	01a09aec-4568-70ae-8b56-86340439138f	2026-03-25	302.2200	f
01a09b0f-dc64-75f4-aaec-7b8eeb48ed2a	01a09aec-4568-70ae-8b56-86340439138f	2025-09-26	243.7900	f
01a09b0f-dc64-762b-a37e-68926a97855b	01a09aec-4568-70ae-8b56-86340439138f	2026-01-05	293.2400	f
01a09b0f-dc64-763a-b2af-62a289e2e2eb	01a09aec-4568-70ae-8b56-86340439138f	2025-12-19	292.2900	f
01a09b0f-dc64-7640-9b2f-6eb356972c1f	01a09aec-4568-70ae-8b56-86340439138f	2026-03-17	281.9500	f
01a09b0f-dc64-7666-b903-5a458561ec36	01a09aec-4568-70ae-8b56-86340439138f	2025-11-19	312.4800	f
01a09b0f-dc64-7679-88d1-36a654580f96	01a09aec-4568-70ae-8b56-86340439138f	2025-09-10	253.0300	f
01a09b0f-dc64-768e-9778-ed2e041376c4	01a09aec-4568-70ae-8b56-86340439138f	2026-05-05	417.6600	f
01a09b0f-dc64-7691-8e8f-ca03afc60f27	01a09aec-4568-70ae-8b56-86340439138f	2026-01-12	314.7000	f
01a09b0f-dc64-76bb-b0dd-46ce457001d5	01a09aec-4568-70ae-8b56-86340439138f	2025-11-24	322.5400	f
01a09b0f-dc64-76bd-994a-b23232c527f5	01a09aec-4568-70ae-8b56-86340439138f	2025-12-29	303.2200	f
01a09b0f-dc64-76d8-9e19-5dea29c28b05	01a09aec-4568-70ae-8b56-86340439138f	2025-10-20	273.5000	f
01a09b0f-dc64-76ee-88a1-7b352afa974c	01a09aec-4568-70ae-8b56-86340439138f	2026-04-09	328.3300	f
01a09b0f-dc64-76ef-b478-f442cf059dc0	01a09aec-4568-70ae-8b56-86340439138f	2026-03-18	273.5800	f
01a09b0f-dc64-76f3-8afc-73dd5d5c8209	01a09aec-4568-70ae-8b56-86340439138f	2026-03-02	266.9800	f
01a09b0f-dc64-770b-b5ef-75a56f53c34d	01a09aec-4568-70ae-8b56-86340439138f	2026-04-14	384.3500	f
01a09b0f-dc64-7763-85d1-e95f0ad8c3db	01a09aec-4568-70ae-8b56-86340439138f	2026-04-27	422.2100	f
01a09b0f-dc64-776d-ba97-9d02afec8030	01a09aec-4568-70ae-8b56-86340439138f	2025-10-29	337.7700	f
01a09b0f-dc64-7771-9d7d-6954ef315f62	01a09aec-4568-70ae-8b56-86340439138f	2026-04-28	361.5400	f
01a09b0f-dc64-777a-a478-59ef66680742	01a09aec-4568-70ae-8b56-86340439138f	2025-10-01	251.6900	f
01a09b0f-dc64-777a-b7f9-8ac1e19e11e9	01a09aec-4568-70ae-8b56-86340439138f	2025-09-12	241.7700	f
01a09b0f-dc64-7799-bd9c-921a645cc44a	01a09aec-4568-70ae-8b56-86340439138f	2025-10-09	259.7800	f
01a09b0f-dc64-77b5-939e-fc7bf0f3cac5	01a09aec-4568-70ae-8b56-86340439138f	2025-12-31	295.6100	f
01a09b0f-dc64-77bb-a007-9ec537aff155	01a09aec-4568-70ae-8b56-86340439138f	2025-10-24	296.6200	f
01a09b0f-dc64-77e5-a058-14848b5ce260	01a09aec-4568-70ae-8b56-86340439138f	2026-02-03	297.4500	f
01a09b0f-dc64-77f1-93fb-6a1b2d103f05	01a09aec-4568-70ae-8b56-86340439138f	2026-05-08	375.5500	f
01a09b0f-dc64-77fe-8232-f398c9378bc9	01a09aec-4568-70ae-8b56-86340439138f	2025-10-06	235.3400	f
01a09b0f-dc64-7803-abd9-1a6e5c9a3f8c	01a09aec-4568-70ae-8b56-86340439138f	2026-03-26	273.3800	f
01a09b0f-dc64-780b-a4ab-9496b3402b61	01a09aec-4568-70ae-8b56-86340439138f	2025-09-11	245.7400	f
01a09b0f-dc64-7822-8821-90de5aa0e454	01a09aec-4568-70ae-8b56-86340439138f	2025-11-12	334.5700	f
01a09b0f-dc64-7838-992e-74f63e1d5662	01a09aec-4568-70ae-8b56-86340439138f	2025-09-22	254.7900	f
01a09b0f-dc64-785f-9331-589f4bc28db8	01a09aec-4568-70ae-8b56-86340439138f	2026-02-09	319.2100	f
01a09b0f-dc64-7877-bc89-1ccc0a34bc20	01a09aec-4568-70ae-8b56-86340439138f	2026-01-27	333.1700	f
01a09b0f-dc64-78c8-b1a7-e82be8b1e122	01a09aec-4568-70ae-8b56-86340439138f	2026-01-29	300.0000	f
01a09b0f-dc64-78f5-ac97-66d4381f77b2	01a09aec-4568-70ae-8b56-86340439138f	2026-01-13	328.5600	f
01a09b0f-dc64-791c-94f5-df95c029a01d	01a09aec-4568-70ae-8b56-86340439138f	2025-11-14	310.8800	f
01a09b0f-dc64-7923-8e5d-b1e970a82a95	01a09aec-4568-70ae-8b56-86340439138f	2026-04-17	396.0100	f
01a09b0f-dc64-7932-a3c6-834d3196f10c	01a09aec-4568-70ae-8b56-86340439138f	2025-12-23	303.4600	f
01a09b0f-dc64-7948-a67a-d651d0ae5706	01a09aec-4568-70ae-8b56-86340439138f	2025-12-18	270.9200	f
01a09b0f-dc64-7972-94d5-d3137f15ef11	01a09aec-4568-70ae-8b56-86340439138f	2026-04-29	376.5400	f
01a09b0f-dc64-797a-a78e-7f86b32c1aa9	01a09aec-4568-70ae-8b56-86340439138f	2026-05-07	385.2100	f
01a09b0f-dc64-7984-ae0f-ac6e23fdd99c	01a09aec-4568-70ae-8b56-86340439138f	2026-04-02	294.8400	f
01a09b0f-dc64-79a0-aed8-3a73d456923d	01a09aec-4568-70ae-8b56-86340439138f	2026-02-17	286.6600	f
01a09b0f-dc64-79ac-95de-b031863429ae	01a09aec-4568-70ae-8b56-86340439138f	2025-12-10	348.6600	f
01a09b0f-dc64-79c1-90b2-7515a6c15fd7	01a09aec-4568-70ae-8b56-86340439138f	2026-03-05	265.8300	f
01a09b0f-dc64-79cb-951a-61e455caeea2	01a09aec-4568-70ae-8b56-86340439138f	2025-10-30	340.1300	f
01a09b0f-dc64-7a0d-bc9d-1a770e9499fa	01a09aec-4568-70ae-8b56-86340439138f	2026-01-06	305.0000	f
01a09b0f-dc64-7a22-be48-b11ba4998487	01a09aec-4568-70ae-8b56-86340439138f	2026-02-19	291.3300	f
01a09b0f-dc64-7a33-9e98-335350f0c319	01a09aec-4568-70ae-8b56-86340439138f	2025-10-14	247.7500	f
01a09b0f-dc64-7a44-90b6-494f6d91b993	01a09aec-4568-70ae-8b56-86340439138f	2025-10-08	254.8800	f
01a09b0f-dc64-7a6b-94a2-aeaf2d29a281	01a09aec-4568-70ae-8b56-86340439138f	2025-11-06	340.7600	f
01a09b0f-dc64-7a72-8430-96b80e1fa669	01a09aec-4568-70ae-8b56-86340439138f	2025-11-21	280.0600	f
01a09b0f-dc64-7a86-a36a-702f292663df	01a09aec-4568-70ae-8b56-86340439138f	2025-10-02	250.9100	f
01a09b0f-dc64-7aaf-8564-c714dc4206d8	01a09aec-4568-70ae-8b56-86340439138f	2025-11-20	282.2800	f
01a09b0f-dc64-7acd-a947-f54a3c132a24	01a09aec-4568-70ae-8b56-86340439138f	2026-04-30	409.5900	f
01a09b0f-dc64-7ad7-9525-a9521d38466b	01a09aec-4568-70ae-8b56-86340439138f	2026-04-07	297.3400	f
01a09b0f-dc64-7b10-b1b5-0bef45229d00	01a09aec-4568-70ae-8b56-86340439138f	2025-12-16	288.8700	f
01a09b0f-dc64-7b24-979c-7ef6f4abd9bb	01a09aec-4568-70ae-8b56-86340439138f	2026-02-18	291.4000	f
01a09b0f-dc64-7b2f-888e-21b854f3e1f1	01a09aec-4568-70ae-8b56-86340439138f	2025-09-24	240.4600	f
01a09b0f-dc64-7b30-ae98-c34fb9d10f8d	01a09aec-4568-70ae-8b56-86340439138f	2025-09-15	248.9900	f
01a09b0f-dc64-7b39-abc0-e08af3de0b9d	01a09aec-4568-70ae-8b56-86340439138f	2026-01-07	305.8700	f
01a09b0f-dc64-7b5f-9b3b-d24c21889def	01a09aec-4568-70ae-8b56-86340439138f	2025-11-26	332.2400	f
01a09b0f-dc64-7b8d-9621-44a7ec02ea72	01a09aec-4568-70ae-8b56-86340439138f	2026-03-13	263.4600	f
01a09b0f-dc64-7b9e-92be-3c669606ec7d	01a09aec-4568-70ae-8b56-86340439138f	2025-11-28	344.4100	f
01a09b0f-dc64-7bb1-8f70-a15d7d611a24	01a09aec-4568-70ae-8b56-86340439138f	2026-04-23	391.6000	f
01a09b0f-dc64-7bba-8c0e-957c00335b77	01a09aec-4568-70ae-8b56-86340439138f	2025-12-01	318.3700	f
01a09b0f-dc64-7bc3-8e44-3f75c0145e11	01a09aec-4568-70ae-8b56-86340439138f	2026-04-15	381.9400	f
01a09b0f-dc64-7bdb-969d-4d299d240eef	01a09aec-4568-70ae-8b56-86340439138f	2026-02-27	277.6300	f
01a09b0f-dc64-7be7-8054-8c0b29571f7b	01a09aec-4568-70ae-8b56-86340439138f	2025-11-03	349.0100	f
01a09b0f-dc64-7bef-a788-2ecc8e43d673	01a09aec-4568-70ae-8b56-86340439138f	2026-04-16	382.3200	f
01a09b0f-dc64-7bf7-9466-8eb00979b90e	01a09aec-4568-70ae-8b56-86340439138f	2026-05-11	380.9900	f
01a09b0f-dc64-7c13-9d50-79a5c51eacfb	01a09aec-4568-70ae-8b56-86340439138f	2026-02-06	307.5300	f
01a09b0f-dc64-7c18-8e2d-1552f87462d9	01a09aec-4568-70ae-8b56-86340439138f	2026-05-12	374.0700	f
01a09b0f-dc64-7c4a-af40-80b342cec4f6	01a09aec-4568-70ae-8b56-86340439138f	2026-02-20	292.6900	f
01a09b0f-dc64-7c67-af7b-84b6efd433ea	01a09aec-4568-70ae-8b56-86340439138f	2025-12-22	306.8600	f
01a09b0f-dc64-7cd8-8ed7-f936b7eae23d	01a09aec-4568-70ae-8b56-86340439138f	2025-09-17	247.6600	f
01a09b0f-dc64-7cf1-be45-20847b643044	01a09aec-4568-70ae-8b56-86340439138f	2025-10-15	269.9600	f
01a09b0f-dc64-7d08-87be-809f288b38a2	01a09aec-4568-70ae-8b56-86340439138f	2025-12-11	351.4100	f
01a09b0f-dc64-7d13-9423-f41fc15d4ce3	01a09aec-4568-70ae-8b56-86340439138f	2026-03-12	264.8900	f
01a09b0f-dc64-7d1d-a780-1a4dd9ace119	01a09aec-4568-70ae-8b56-86340439138f	2026-03-30	257.2700	f
01a09b0f-dc64-7d38-9c99-039768bdc1b9	01a09aec-4568-70ae-8b56-86340439138f	2026-02-26	279.1600	f
01a09b0f-dc64-7d40-9aee-99c7757f7351	01a09aec-4568-70ae-8b56-86340439138f	2026-03-06	249.5200	f
01a09b0f-dc64-7d5a-a4e3-6f60ffcbe1bb	01a09aec-4568-70ae-8b56-86340439138f	2025-11-04	335.7900	f
01a09b0f-dc64-7d6d-a6a7-e624f587c8e3	01a09aec-4568-70ae-8b56-86340439138f	2026-02-12	274.7900	f
01a09b0f-dc64-7d91-89f3-2df3b2e5c4a9	01a09aec-4568-70ae-8b56-86340439138f	2025-09-25	244.6400	f
01a09b0f-dc64-7d92-8e91-3d8af1837e85	01a09aec-4568-70ae-8b56-86340439138f	2025-10-17	276.4600	f
01a09b0f-dc64-7db3-8533-73f72ca8a8f4	01a09aec-4568-70ae-8b56-86340439138f	2026-05-04	420.7300	f
01a09b0f-dc64-7db7-bade-39ddeef9c34b	01a09aec-4568-70ae-8b56-86340439138f	2025-11-17	309.3700	f
01a09b0f-dc64-7dfe-b8d4-2e8ffd025066	01a09aec-4568-70ae-8b56-86340439138f	2026-01-15	313.5300	f
01a09b0f-dc64-7e17-8f01-5ac52d69bb31	01a09aec-4568-70ae-8b56-86340439138f	2025-09-08	244.3300	f
01a09b0f-dc64-7e49-9937-cf03c61640bb	01a09aec-4568-70ae-8b56-86340439138f	2026-01-08	288.6000	f
01a09b0f-dc64-7e50-92d3-9fb94c4eacab	01a09aec-4568-70ae-8b56-86340439138f	2026-03-19	284.3000	f
01a09b0f-dc64-7e5a-9aca-3d7a0d58890b	01a09aec-4568-70ae-8b56-86340439138f	2025-11-10	344.6100	f
01a09b0f-dc64-7ea4-8a95-51a1290f4080	01a09aec-4568-70ae-8b56-86340439138f	2026-04-08	320.7000	f
01a09b0f-dc64-7ea9-b6b7-3250a6ba56db	01a09aec-4568-70ae-8b56-86340439138f	2025-12-04	322.7900	f
01a09b0f-dc64-7ead-90f1-93c5bb97374e	01a09aec-4568-70ae-8b56-86340439138f	2026-03-10	269.2000	f
01a09b0f-dc64-7ede-ae3e-3f1c2fbf8f9c	01a09aec-4568-70ae-8b56-86340439138f	2026-04-06	292.3000	f
01a09b0f-dc64-7f0c-b9b3-5e3066e87ae6	01a09aec-4568-70ae-8b56-86340439138f	2026-04-22	401.7400	f
01a09b0f-dc64-7f18-a5f7-d20d9e032f33	01a09aec-4568-70ae-8b56-86340439138f	2026-03-27	280.2200	f
01a09b0f-dc64-7f1f-bd06-3826b279220f	01a09aec-4568-70ae-8b56-86340439138f	2026-01-26	308.2500	f
01a09b0f-dc64-7f22-b74c-e5c40dd4c636	01a09aec-4568-70ae-8b56-86340439138f	2026-02-23	296.6800	f
01a09b0f-dc64-7f29-a2cb-16d54bb745df	01a09aec-4568-70ae-8b56-86340439138f	2025-10-13	261.0600	f
01a09b0f-dc64-7f61-b845-e44d0c1b33dc	01a09aec-4568-70ae-8b56-86340439138f	2025-09-04	221.3400	f
01a09b0f-dc64-7f76-a1cb-2a38b2f1fa6b	01a09aec-4568-70ae-8b56-86340439138f	2025-10-07	237.7900	f
01a09b0f-dc64-7f7a-9c0c-1da0a4f374ec	01a09aec-4568-70ae-8b56-86340439138f	2026-03-24	301.5200	f
01a09b0f-dc64-7f89-97e7-b4593e247b9e	01a09aec-4568-70ae-8b56-86340439138f	2026-02-13	280.6600	f
01a09b0f-dc64-7f8c-963b-d07e16d7f2af	01a09aec-4568-70ae-8b56-86340439138f	2026-04-01	288.7300	f
01a09b0f-dc64-7fb3-aea6-c9e4da72eaaa	01a09aec-4568-70ae-8b56-86340439138f	2026-02-10	297.9300	f
01a09b0f-dc64-7fb4-a16e-7f6ec1b0137b	01a09aec-4568-70ae-8b56-86340439138f	2026-04-24	410.2100	f
01a09b0f-dc64-7fc3-8218-e0734d5ae78f	01a09aec-4568-70ae-8b56-86340439138f	2026-02-02	285.1100	f
01a09b0f-dc64-7fc3-9d02-362394049283	01a09aec-4568-70ae-8b56-86340439138f	2025-09-09	244.0800	f
01a09b0f-dc64-7fd4-a48d-5330d7e95d12	01a09aec-4568-70ae-8b56-86340439138f	2026-03-23	286.9800	f
01a09b0f-dc64-7fe2-ab30-b34121585ecf	01a09aec-4568-70ae-8b56-86340439138f	2025-09-30	246.3800	f
01a09b0f-dc64-7fed-8edb-9e923c592721	01a09aec-4568-70ae-8b56-86340439138f	2026-01-16	313.6000	f
01a09b0f-dc65-7003-b1fd-088e794a78eb	01a09aec-4568-70ae-8b56-86340439138f	2026-08-12	339.4600	f
01a09b0f-dc65-711f-a210-a1ffe53d1c05	01a09aec-4568-70ae-8b56-86340439138f	2026-08-14	335.0500	f
01a09b0f-dc65-7128-9d50-476d26171876	01a09aec-4568-70ae-8b56-86340439138f	2026-08-17	340.4000	f
01a09b0f-dc65-7128-bae9-f60d5b4654ef	01a09aec-4568-70ae-8b56-86340439138f	2026-08-21	296.5500	f
01a09b0f-dc65-7179-b4e5-cd4b0c4cb8ac	01a09aec-4568-70ae-8b56-86340439138f	2026-08-03	341.9100	f
01a09b0f-dc65-71d8-9a20-18b512d8a662	01a09aec-4568-70ae-8b56-86340439138f	2026-05-18	342.6700	f
01a09b0f-dc65-7223-985b-5f261cd04331	01a09aec-4568-70ae-8b56-86340439138f	2026-05-21	354.7700	f
01a09b0f-dc65-727a-b8dc-8053865aa348	01a09aec-4568-70ae-8b56-86340439138f	2026-08-28	298.7000	f
01a09b0f-dc65-727c-98de-05cbadb3bef4	01a09aec-4568-70ae-8b56-86340439138f	2026-09-03	309.8400	f
01a09b0f-dc65-727f-9b2e-dc1d9c4096d3	01a09aec-4568-70ae-8b56-86340439138f	2026-08-04	371.1500	f
01a09b0f-dc65-72ca-bced-1f4a00242a6d	01a09aec-4568-70ae-8b56-86340439138f	2026-06-04	425.3600	f
01a09b0f-dc65-72dc-82dd-3b82e1783125	01a09aec-4568-70ae-8b56-86340439138f	2026-08-06	314.5300	f
01a09b0f-dc65-7347-b50b-cd3cdb46a93f	01a09aec-4568-70ae-8b56-86340439138f	2026-05-28	351.0200	f
01a09b0f-dc65-739d-8df1-bc12e6b21fec	01a09aec-4568-70ae-8b56-86340439138f	2026-06-24	362.2400	f
01a09b0f-dc65-73e2-8266-9c151dc3fff0	01a09aec-4568-70ae-8b56-86340439138f	2026-06-17	380.3700	f
01a09b0f-dc65-73e2-9c32-3fd9ff420678	01a09aec-4568-70ae-8b56-86340439138f	2026-05-29	385.3900	f
01a09b0f-dc65-73ed-88a1-6d6e1ccebeee	01a09aec-4568-70ae-8b56-86340439138f	2026-06-18	372.5500	f
01a09b0f-dc65-73fc-8889-ec4c11f11581	01a09aec-4568-70ae-8b56-86340439138f	2026-05-19	339.1300	f
01a09b0f-dc65-740c-840e-6f754e3157ab	01a09aec-4568-70ae-8b56-86340439138f	2026-06-05	371.7100	f
01a09b0f-dc65-742b-bcb9-89351c6942be	01a09aec-4568-70ae-8b56-86340439138f	2026-08-11	310.3800	f
01a09b0f-dc65-7450-ba86-3ab57a068dae	01a09aec-4568-70ae-8b56-86340439138f	2026-07-09	354.7800	f
01a09b0f-dc65-74c3-837f-fda3368a5a27	01a09aec-4568-70ae-8b56-86340439138f	2026-07-10	359.8500	f
01a09b0f-dc65-74cc-ad81-f5d28e70cce5	01a09aec-4568-70ae-8b56-86340439138f	2026-05-26	370.8400	f
01a09b0f-dc65-7563-ad5e-3cceb592f49d	01a09aec-4568-70ae-8b56-86340439138f	2026-08-25	306.8600	f
01a09b0f-dc65-756a-b5bf-dfab8edfaa90	01a09aec-4568-70ae-8b56-86340439138f	2026-07-15	334.7700	f
01a09b0f-dc65-758b-9435-d2b19c663842	01a09aec-4568-70ae-8b56-86340439138f	2026-08-19	301.3600	f
01a09b0f-dc65-758c-b840-d561b917ea67	01a09aec-4568-70ae-8b56-86340439138f	2026-09-09	333.6000	f
01a09b0f-dc65-7597-808b-0f3d4d3795d4	01a09aec-4568-70ae-8b56-86340439138f	2026-06-22	376.8400	f
01a09b0f-dc65-75a3-890c-9a4512866a5b	01a09aec-4568-70ae-8b56-86340439138f	2026-06-30	364.8000	f
01a09b0f-dc65-75a8-acbe-7b60595e4d81	01a09aec-4568-70ae-8b56-86340439138f	2026-07-22	335.5000	f
01a09b0f-dc65-761a-8408-cf1f7029d7e3	01a09aec-4568-70ae-8b56-86340439138f	2026-06-11	385.8600	f
01a09b0f-dc65-7635-aa20-4aa2880935c4	01a09aec-4568-70ae-8b56-86340439138f	2026-07-08	360.7400	f
01a09b0f-dc65-7666-b279-7c1ba9e60939	01a09aec-4568-70ae-8b56-86340439138f	2026-08-18	310.5900	f
01a09b0f-dc65-76c1-8652-98dacd46a639	01a09aec-4568-70ae-8b56-86340439138f	2026-05-14	381.5900	f
01a09b0f-dc65-76cf-a8b4-14a9f92d4b37	01a09aec-4568-70ae-8b56-86340439138f	2026-06-08	386.5000	f
01a09b0f-dc65-76e7-aff1-80ead66db379	01a09aec-4568-70ae-8b56-86340439138f	2026-05-22	367.3700	f
01a09b0f-dc65-7709-b12f-9a504b06bc3f	01a09aec-4568-70ae-8b56-86340439138f	2026-07-02	336.2100	f
01a09b0f-dc65-773d-b95d-4efaf52e234b	01a09aec-4568-70ae-8b56-86340439138f	2026-08-27	317.3800	f
01a09b0f-dc65-777d-9968-24aa6e0a1429	01a09aec-4568-70ae-8b56-86340439138f	2026-06-29	343.2500	f
01a09b0f-dc65-77a2-b81d-632cb9f02229	01a09aec-4568-70ae-8b56-86340439138f	2026-07-28	350.2000	f
01a09b0f-dc65-77ab-b24b-27bff5230b90	01a09aec-4568-70ae-8b56-86340439138f	2026-08-20	302.0000	f
01a09b0f-dc65-77ce-ab25-0bf85b971430	01a09aec-4568-70ae-8b56-86340439138f	2026-09-02	277.7700	f
01a09b0f-dc65-7806-a785-3fa3b3061096	01a09aec-4568-70ae-8b56-86340439138f	2026-06-23	351.2000	f
01a09b0f-dc65-7815-a483-7025e8bf5e52	01a09aec-4568-70ae-8b56-86340439138f	2026-07-07	345.0600	f
01a09b0f-dc65-7890-bfcb-e842944d9528	01a09aec-4568-70ae-8b56-86340439138f	2026-06-02	472.4000	f
01a09b0f-dc65-7895-83e7-39fae475c056	01a09aec-4568-70ae-8b56-86340439138f	2026-07-24	305.2800	f
01a09b0f-dc65-78ec-97d6-076f147b325d	01a09aec-4568-70ae-8b56-86340439138f	2026-06-15	403.4500	f
01a09b0f-dc65-78f1-b9d0-ded69f768bee	01a09aec-4568-70ae-8b56-86340439138f	2026-08-10	314.5900	f
01a09b0f-dc65-791f-9069-b3a6f00c7de9	01a09aec-4568-70ae-8b56-86340439138f	2026-06-25	361.4000	f
01a09b0f-dc65-796a-9518-0d8d89d30821	01a09aec-4568-70ae-8b56-86340439138f	2026-07-23	334.7500	f
01a09b0f-dc65-7989-bef0-b80afec97e82	01a09aec-4568-70ae-8b56-86340439138f	2026-07-06	350.2000	f
01a09b0f-dc65-7992-a5c9-087b3115b937	01a09aec-4568-70ae-8b56-86340439138f	2026-07-27	318.2400	f
01a09b0f-dc65-79a7-acec-93ba39fd132d	01a09aec-4568-70ae-8b56-86340439138f	2026-07-01	361.6200	f
01a09b0f-dc65-79d4-8109-a3db65d1b05c	01a09aec-4568-70ae-8b56-86340439138f	2026-07-16	303.8600	f
01a09b0f-dc65-7a1b-9c8f-50bcd06c03bb	01a09aec-4568-70ae-8b56-86340439138f	2026-06-09	371.8600	f
01a09b0f-dc65-7a66-914c-296108613ca5	01a09aec-4568-70ae-8b56-86340439138f	2026-07-13	345.1800	f
01a09b0f-dc65-7a80-982d-15645b06307d	01a09aec-4568-70ae-8b56-86340439138f	2026-07-20	307.3400	f
01a09b0f-dc65-7a8f-ac55-691e8650515c	01a09aec-4568-70ae-8b56-86340439138f	2026-09-01	292.5900	f
01a09b0f-dc65-7a91-a6e3-d9d55e130bed	01a09aec-4568-70ae-8b56-86340439138f	2026-09-11	346.5500	f
01a09b0f-dc65-7b2e-b040-cfc08cf81f99	01a09aec-4568-70ae-8b56-86340439138f	2026-07-17	301.3400	f
01a09b0f-dc65-7b34-9f9c-5f7502f97c33	01a09aec-4568-70ae-8b56-86340439138f	2026-06-10	362.9200	f
01a09b0f-dc65-7b6b-bd80-24a37c9e5924	01a09aec-4568-70ae-8b56-86340439138f	2026-08-31	299.4000	f
01a09b0f-dc65-7b72-ada1-aeaf4f5f3670	01a09aec-4568-70ae-8b56-86340439138f	2026-05-15	358.5500	f
01a09b0f-dc65-7b73-b921-001666681749	01a09aec-4568-70ae-8b56-86340439138f	2026-07-30	352.5900	f
01a09b0f-dc65-7b74-b203-e9e750fa7776	01a09aec-4568-70ae-8b56-86340439138f	2026-07-31	331.4400	f
01a09b0f-dc65-7b9e-bc51-70792229d6bd	01a09aec-4568-70ae-8b56-86340439138f	2026-06-16	382.0100	f
01a09b0f-dc65-7c23-a0f4-a978f2c4005d	01a09aec-4568-70ae-8b56-86340439138f	2026-09-08	329.9700	f
01a09b0f-dc65-7c79-8d5d-992d143477ba	01a09aec-4568-70ae-8b56-86340439138f	2026-05-20	346.4800	f
01a09b0f-dc65-7cc2-8bc6-9c10dded62dc	01a09aec-4568-70ae-8b56-86340439138f	2026-09-04	312.3500	f
01a09b0f-dc65-7ce2-abfe-84451b5707c2	01a09aec-4568-70ae-8b56-86340439138f	2026-08-13	347.6300	f
01a09b0f-dc65-7d9d-b437-e91439153c6d	01a09aec-4568-70ae-8b56-86340439138f	2026-06-12	393.1200	f
01a09b0f-dc65-7dab-9481-9170f6a4c975	01a09aec-4568-70ae-8b56-86340439138f	2026-07-29	328.4300	f
01a09b0f-dc65-7dc6-8cd5-b41bd324f649	01a09aec-4568-70ae-8b56-86340439138f	2026-05-27	357.7000	f
01a09b0f-dc65-7dc8-a5d1-20a591d2b388	01a09aec-4568-70ae-8b56-86340439138f	2026-06-26	337.5300	f
01a09b0f-dc65-7de4-bde0-f7332fce48bd	01a09aec-4568-70ae-8b56-86340439138f	2026-09-10	325.2200	f
01a09b0f-dc65-7e2d-850a-6a71708b5011	01a09aec-4568-70ae-8b56-86340439138f	2026-07-14	345.0300	f
01a09b0f-dc65-7e51-8205-1b084cdd5970	01a09aec-4568-70ae-8b56-86340439138f	2026-08-24	294.5700	f
01a09b0f-dc65-7e7b-a596-1d895d8b3a61	01a09aec-4568-70ae-8b56-86340439138f	2026-06-03	458.1400	f
01a09b0f-dc65-7ee1-a21e-6a796b05fc0a	01a09aec-4568-70ae-8b56-86340439138f	2026-08-26	307.3200	f
01a09b0f-dc65-7ee2-a40f-e18296262169	01a09aec-4568-70ae-8b56-86340439138f	2026-08-05	362.7600	f
01a09b0f-dc65-7f0d-93ed-505289803c2f	01a09aec-4568-70ae-8b56-86340439138f	2026-08-07	317.8300	f
01a09b0f-dc65-7f10-92ac-941dc4dd98f1	01a09aec-4568-70ae-8b56-86340439138f	2026-06-01	426.5500	f
01a09b0f-dc65-7f16-bab9-5a0b868c2097	01a09aec-4568-70ae-8b56-86340439138f	2026-07-21	339.5900	f
01a09b0f-dcfd-70a0-8261-b5e59acb1eba	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-08-22	114.0400	f
01a09b0f-dcfd-7481-a481-fa433c084984	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-08-27	122.7300	f
01a09b0f-dcfd-7574-b89c-acf8c34bb214	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-08-26	120.1000	f
01a09b0f-dcfd-7a8d-94be-31808ac49516	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-08-25	115.4100	f
01a09b0f-dcfe-705a-9b53-7f83be0400d2	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-08-29	123.0550	f
01a09b0f-dcfe-705a-ae45-6bb672e446d5	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-28	177.6000	f
01a09b0f-dcfe-7077-8781-95304c9fbb2f	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-08	148.8700	f
01a09b0f-dcfe-70a7-9a14-51e4a3b1bb98	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-14	145.5200	f
01a09b0f-dcfe-70a9-a928-b2cdfe550df3	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-16	164.4200	f
01a09b0f-dcfe-712a-b50c-98f1dde40db4	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-25	144.9400	f
01a09b0f-dcfe-7189-b023-5b357782ee31	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-08-28	131.8200	f
01a09b0f-dcfe-7229-8d0c-9ebfb9a181ab	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-07	163.6100	f
01a09b0f-dcfe-725c-a2c5-9f5691e7a240	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-23	150.9700	f
01a09b0f-dcfe-726d-bd11-854e1fdfb8dc	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-01	171.1300	f
01a09b0f-dcfe-7280-add7-7d408ecf9bd4	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-26	142.9300	f
01a09b0f-dcfe-72f3-a976-cabb374d16e6	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-02	124.2700	f
01a09b0f-dcfe-730d-b44f-40a50e6907ba	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-16	136.5300	f
01a09b0f-dcfe-7323-8dd6-05f9012c695f	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-18	172.3100	f
01a09b0f-dcfe-7395-95b0-f1cf697bc10d	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-15	163.9800	f
01a09b0f-dcfe-7396-a0c4-3e06c5cd3ed7	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-22	137.2000	f
01a09b0f-dcfe-73eb-bd98-710fd74b8318	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-09	151.1500	f
01a09b0f-dcfe-744d-874a-23e37394c0f2	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-19	141.8800	f
01a09b0f-dcfe-7457-b4e9-a9e750136439	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-17	145.5800	f
01a09b0f-dcfe-748f-8100-6050cb36dfcd	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-04	180.9200	f
01a09b0f-dcfe-7498-b6a1-6111db5d6e5d	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-30	145.6100	f
01a09b0f-dcfe-74eb-b2da-141dacab67c5	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-26	164.0100	f
01a09b0f-dcfe-752f-a335-a1d6d3de6641	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-21	133.4900	f
01a09b0f-dcfe-753e-82de-36fb5e262490	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-20	134.7300	f
01a09b0f-dcfe-7647-9ff3-79a4f8f80ac7	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-10	138.8300	f
01a09b0f-dcfe-76b0-a12b-919af5749cef	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-24	149.3800	f
01a09b0f-dcfe-7716-bfd1-94f00b32367a	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-22	164.1000	f
01a09b0f-dcfe-774b-8787-6606f1872dde	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-15	131.4100	f
01a09b0f-dcfe-7755-97cf-95bf737297ad	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-05	173.1600	f
01a09b0f-dcfe-7776-914b-8703ed19477a	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-03	180.6400	f
01a09b0f-dcfe-7780-aecb-bc7aed061a50	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-27	154.9600	f
01a09b0f-dcfe-77ac-b9df-9bc153903b87	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-04	164.2300	f
01a09b0f-dcfe-77ce-819e-a5ff6a4d5712	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-29	171.5200	f
01a09b0f-dcfe-7810-aca0-ab59fb4caf50	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-08	147.5300	f
01a09b0f-dcfe-78a2-a18d-17dbe0df31e0	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-12	161.9900	f
01a09b0f-dcfe-78ac-bd7a-74210494e64e	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-19	169.5600	f
01a09b0f-dcfe-7944-9a87-8e6da4c1549a	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-11	158.5000	f
01a09b0f-dcfe-7966-9492-47cfadf175be	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-10	170.1600	f
01a09b0f-dcfe-7982-ba7d-c2891b23f9d3	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-11	159.3200	f
01a09b0f-dcfe-79c4-91fd-3f1363ad65b4	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-23	162.2600	f
01a09b0f-dcfe-79f4-bd08-83dc556ab00e	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-30	166.6200	f
01a09b0f-dcfe-7a0a-bf9c-a8dbd9fed909	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-09	149.0300	f
01a09b0f-dcfe-7a33-948e-125cb105b095	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-21	144.1700	f
01a09b0f-dcfe-7a5f-bdc7-03e03d2b0e8d	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-18	139.5600	f
01a09b0f-dcfe-7b02-9022-f7e02bb81cf3	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-13	149.9000	f
01a09b0f-dcfe-7b23-b38b-25a6945810bf	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-04	134.0000	f
01a09b0f-dcfe-7b42-8dcf-23e8d025da74	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-20	151.6600	f
01a09b0f-dcfe-7b47-af81-590b88c51ce0	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-05	140.8200	f
01a09b0f-dcfe-7b8a-a239-8506da5581e1	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-01	144.9100	f
01a09b0f-dcfe-7b8d-9e5f-e8318582a01b	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-31	187.6200	f
01a09b0f-dcfe-7b8d-adad-8f42a8fc8509	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-03	124.7700	f
01a09b0f-dcfe-7be8-a595-e26863571982	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-02	188.4400	f
01a09b0f-dcfe-7bef-8ca9-8cea8327054f	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-12	160.3400	f
01a09b0f-dcfe-7c18-9e48-a86cdef4fd67	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-25	154.1800	f
01a09b0f-dcfe-7c4a-96f7-02fa090a7182	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-13	142.9500	f
01a09b0f-dcfe-7cab-9613-b09671a31c6c	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-06	147.4200	f
01a09b0f-dcfe-7cfc-8c15-3db6c9a9042b	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-28	162.1800	f
01a09b0f-dcfe-7d05-bc10-3afadb663bf4	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-03	189.1900	f
01a09b0f-dcfe-7dde-8477-ca38d585c4e8	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-29	146.0100	f
01a09b0f-dcfe-7dec-9b0e-94593adeb2f0	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-14	129.7500	f
01a09b0f-dcfe-7e36-b9b1-941d118f362a	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-02	149.6300	f
01a09b0f-dcfe-7e4b-9191-5e4e613e6312	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-17	164.4400	f
01a09b0f-dcfe-7e81-bdc2-c12e6a80648b	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-09-10	163.9600	f
01a09b0f-dcfe-7ec8-a245-e46ba8216058	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-06	162.7400	f
01a09b0f-dcfe-7ed9-9c69-5cd27d484d90	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-17	143.6100	f
01a09b0f-dcfe-7ee5-be89-ccf4caacdbbc	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-11-24	150.8500	f
01a09b0f-dcfe-7f19-b462-d9a951af8a13	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-24	155.5500	f
01a09b0f-dcfe-7f21-872c-fcfc259f9c81	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-03	143.8700	f
01a09b0f-dcfe-7ff1-8e2d-2ca7a19211ec	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-10-07	137.2000	f
01a09b0f-dcff-7015-a9e1-f11f0e0c371a	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-08	141.5900	f
01a09b0f-dcff-7023-b384-40165dfa22d5	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-25	123.4600	f
01a09b0f-dcff-707d-960f-da37bc70029a	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-26	144.8300	f
01a09b0f-dcff-70bc-b281-8f0f41912937	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-13	117.6900	f
01a09b0f-dcff-70be-96b5-c9ad8609d09b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-14	156.8400	f
01a09b0f-dcff-710f-84d4-e8baa2fe209b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-16	116.8800	f
01a09b0f-dcff-7157-8e3e-a6342a84d311	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-06	109.8300	f
01a09b0f-dcff-7190-8ff7-56cb8de3bd73	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-02	143.2200	f
01a09b0f-dcff-71bb-9339-c873ad1c33c1	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-30	125.2800	f
01a09b0f-dcff-71e2-a316-8bb0d0b488b7	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-09	115.9800	f
01a09b0f-dcff-7215-84a0-2391262c7c76	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-04	96.9500	f
01a09b0f-dcff-7261-86af-9c26bbafa5e6	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-05	176.0400	f
01a09b0f-dcff-72aa-ad54-fe6fa5c08929	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-21	139.1600	f
01a09b0f-dcff-72b3-9061-16bc814a5199	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-15	142.0200	f
01a09b0f-dcff-72ed-a7ea-b45b4b0dab2f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-23	124.0500	f
01a09b0f-dcff-7321-b691-9a7328fc7683	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-12	143.9100	f
01a09b0f-dcff-7338-aa0d-9eccddd68514	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-16	140.3400	f
01a09b0f-dcff-736b-ba6f-856d048d4606	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-22	135.1000	f
01a09b0f-dcff-7380-ac17-913056a7378d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-27	112.2700	f
01a09b0f-dcff-7384-8ca4-e860d1408be9	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-09	123.4100	f
01a09b0f-dcff-738a-b058-cdda729c66f8	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-11	128.4000	f
01a09b0f-dcff-73da-87c1-e29239d583b4	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-03	111.3100	f
01a09b0f-dcff-73fd-8d16-4ae95474f9bc	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-08	178.9400	f
01a09b0f-dcff-7470-a124-80b286663581	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-11	154.4700	f
01a09b0f-dcff-74b1-b304-cf1894b79a10	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-18	101.7200	f
01a09b0f-dcff-7598-9b0c-5c6ac2a9f20b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-05	114.7400	f
01a09b0f-dcff-75a6-a92b-a4f03d49a846	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-26	114.4800	f
01a09b0f-dcff-75aa-a63a-07764eeba502	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-13	121.4400	f
01a09b0f-dcff-75ab-9bc5-740f8c54878c	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-12	156.0700	f
01a09b0f-dcff-75ac-ab7d-8cabb218a12e	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-09	150.4200	f
01a09b0f-dcff-75f4-8574-a6bfd8f4fa51	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-16	150.9700	f
01a09b0f-dcff-762a-837a-3e6fee19d020	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-06	132.9500	f
01a09b0f-dcff-7670-95b0-a6cc1aa7daeb	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-10	157.9800	f
01a09b0f-dcff-7694-8a25-ff586d585959	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-07	141.0000	f
01a09b0f-dcff-7719-b15a-b9e2fbf903fa	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-20	153.2200	f
01a09b0f-dcff-775c-b9ad-9288dfc1dfd8	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-02	119.9600	f
01a09b0f-dcff-7772-9b4d-70cd895d27f8	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-12	121.7800	f
01a09b0f-dcff-77e1-8ea2-2f9ba072f719	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-05	140.2400	f
01a09b0f-dcff-7811-a7c7-cdd523fe1391	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-22	149.9400	f
01a09b0f-dcff-7875-8b39-9d4437960c67	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-18	127.9100	f
01a09b0f-dcff-7876-aa64-e7bf3d39d01c	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-06	111.4000	f
01a09b0f-dcff-788c-9dae-fc8729d180c5	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-24	150.1900	f
01a09b0f-dcff-78a6-adce-29f8874ab78b	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-09	170.2900	f
01a09b0f-dcff-78d5-9f97-d78bcbf0bdbc	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-15	149.1200	f
01a09b0f-dcff-790c-8f95-94800c431867	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-28	129.6600	f
01a09b0f-dcff-79b5-a0cb-25156b4608c0	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-17	134.1300	f
01a09b0f-dcff-79c7-af90-f215e9091778	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-19	130.6600	f
01a09b0f-dcff-7a3f-9ecf-04edeb1dfd3a	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-03	97.3000	f
01a09b0f-dcff-7a63-936a-c83bc440ccd5	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-10	134.7200	f
01a09b0f-dcff-7a74-9aa0-e1dc1da6d8bc	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-18	138.5700	f
01a09b0f-dcff-7aeb-93fe-b3b595ffff16	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-19	150.1300	f
01a09b0f-dcff-7b09-8c12-1eba0a3b9d74	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-31	143.8900	f
01a09b0f-dcff-7b5a-b4e7-aa573e0fdc82	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-12	111.5700	f
01a09b0f-dcff-7b76-b22b-adf28fce4ddd	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-13	161.3800	f
01a09b0f-dcff-7bb5-ad99-22272d3028f5	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-23	147.8100	f
01a09b0f-dcff-7bcd-9080-c4ce46ce78dc	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-10	112.3300	f
01a09b0f-dcff-7c66-bdb9-96dec80832aa	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-17	104.0600	f
01a09b0f-dcff-7c7c-9880-a24577e2d6f4	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-05	98.0600	f
01a09b0f-dcff-7cff-8bc6-0f6ae3d0e7df	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-24	120.8300	f
01a09b0f-dcff-7d1e-b508-c2a49c56a46a	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-23	133.1600	f
01a09b0f-dcff-7d89-b1d4-4808f9d3657c	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-26	128.0200	f
01a09b0f-dcff-7dcd-877f-81cb751045cb	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-11	115.9100	f
01a09b0f-dcff-7ddc-a6df-f531b0b8bcbc	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-29	144.7000	f
01a09b0f-dcff-7e1b-a2c2-e6f8461aed94	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-29	129.4700	f
01a09b0f-dcff-7e93-8ca8-16314a2dca0a	01a09aec-4575-7883-ae54-8f9d1a944c07	2025-12-30	144.9200	f
01a09b0f-dcff-7ed5-b264-75f29d9d397b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-01-27	129.5700	f
01a09b0f-dcff-7f76-892e-a34941922a1b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-17	124.8000	f
01a09b0f-dcff-7f7a-8c40-4bbbd9ed04ea	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-02	114.2200	f
01a09b0f-dcff-7fb8-aa8b-5ec47c1b9a87	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-02-20	124.0600	f
01a09b0f-dcff-7ffc-8c2d-8333c12a4585	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-04	102.5400	f
01a09b0f-dd00-701c-bf28-0658783a403a	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-27	180.5000	f
01a09b0f-dd00-701f-b791-3a06dbd4efc7	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-23	272.0050	f
01a09b0f-dd00-702b-ae16-c1ca1500c22f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-15	172.1700	f
01a09b0f-dd00-7031-8bdd-8b8921b5333d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-17	249.3300	f
01a09b0f-dd00-7046-bc51-bb56868c7ccb	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-29	175.7700	f
01a09b0f-dd00-706b-9544-bd9b8e79bc2d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-04	217.5000	f
01a09b0f-dd00-70e2-afb7-ffbc042bbc1f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-20	103.4000	f
01a09b0f-dd00-7136-a977-8859f088dc7d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-16	207.9700	f
01a09b0f-dd00-7161-a18f-d320e3b70add	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-08	110.2100	f
01a09b0f-dd00-7165-ba3a-546cde865f55	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-22	228.2700	f
01a09b0f-dd00-7182-be53-a11442d12bb8	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-15	168.3500	f
01a09b0f-dd00-71ee-80cc-6d062cd14fcf	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-28	165.9200	f
01a09b0f-dd00-722e-bb76-ad1a98db73b8	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-25	103.9100	f
01a09b0f-dd00-725d-b8a7-893f07807355	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-10	237.6800	f
01a09b0f-dd00-7272-bac1-9ed67fe6559a	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-30	271.9500	f
01a09b0f-dd00-72c5-8e12-f473ab8d1bdb	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-12	250.8100	f
01a09b0f-dd00-72d4-b4cf-3157c04a33cc	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-26	221.6400	f
01a09b0f-dd00-731e-a53f-96e186bead6a	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-30	87.8100	f
01a09b0f-dd00-7326-bc49-cd575f7b1c45	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-21	223.8700	f
01a09b0f-dd00-7376-a7bc-9fc35e457a3b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-01	184.3800	f
01a09b0f-dd00-7464-a394-d75a1b37795f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-02	241.9100	f
01a09b0f-dd00-748a-8910-e0cfeaeaa0b8	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-28	222.3500	f
01a09b0f-dd00-74b5-8a31-93fbfb69a36b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-26	238.0000	f
01a09b0f-dd00-74f8-a292-67cf79653e39	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-15	226.7400	f
01a09b0f-dd00-7575-9dae-a1adad761305	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-04	180.0600	f
01a09b0f-dd00-7585-9f19-4a98c4f122c6	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-29	236.0300	f
01a09b0f-dd00-759c-b897-6ea4886406a7	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-23	105.1000	f
01a09b0f-dd00-75ce-bc2b-761aebb282d1	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-29	245.6800	f
01a09b0f-dd00-75d4-b207-f4a94783e34d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-08	258.6900	f
01a09b0f-dd00-7610-a6c8-1ecd8646df25	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-21	183.3200	f
01a09b0f-dd00-7611-b07a-8e8b166db9a6	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-26	96.4400	f
01a09b0f-dd00-7632-b271-c5e69593882b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-01	226.1000	f
01a09b0f-dd00-7640-a0a6-2cef34637bd9	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-24	195.0400	f
01a09b0f-dd00-7641-b37f-7418f06b4c8e	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-18	156.2700	f
01a09b0f-dd00-7682-b61b-3916e741ef80	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-14	184.5400	f
01a09b0f-dd00-76d4-bb9e-232a92ec3dad	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-22	302.5200	f
01a09b0f-dd00-76dc-aff6-80ea49b1932d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-18	271.8300	f
01a09b0f-dd00-76e9-bd46-69ac972910ef	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-17	202.6800	f
01a09b0f-dd00-771a-b98f-6e1bcb4897ae	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-13	236.8800	f
01a09b0f-dd00-772c-a080-c916e7f66f37	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-06	102.4600	f
01a09b0f-dd00-7756-ada4-0bbd83571c4e	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-27	95.2400	f
01a09b0f-dd00-77aa-a015-f25530d5feb6	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-05	193.5700	f
01a09b0f-dd00-7846-b6e5-950b47f75d02	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-08	188.5050	f
01a09b0f-dd00-7875-b76a-34e57c38135e	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-10	257.7900	f
01a09b0f-dd00-7891-b893-dc4c9a8314f0	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-30	174.0100	f
01a09b0f-dd00-794d-8808-f004520142bc	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-09	265.6500	f
01a09b0f-dd00-79b6-b0ba-d1300eb32ed2	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-12	198.5700	f
01a09b0f-dd00-79b8-a19f-883c1872736d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-13	134.3600	f
01a09b0f-dd00-79ea-b5d5-e1320409e539	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-05	206.8900	f
01a09b0f-dd00-7a65-9831-9389e99ef936	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-06	265.5500	f
01a09b0f-dd00-7a6b-8b94-974f7579eafa	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-24	100.3000	f
01a09b0f-dd00-7a97-8b0d-c7af35de0491	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-23	185.5400	f
01a09b0f-dd00-7ab9-b66b-70b539968b42	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-20	212.0700	f
01a09b0f-dd00-7af8-b1e0-27b4287362cb	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-14	159.5200	f
01a09b0f-dd00-7b07-ac51-0cf3c6f30a11	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-01	95.9200	f
01a09b0f-dd00-7b66-873f-33b20c423e80	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-14	236.1800	f
01a09b0f-dd00-7bd6-99b5-4a528c7f5f98	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-11	210.2200	f
01a09b0f-dd00-7beb-a842-8486fdcb63d7	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-09	107.9300	f
01a09b0f-dd00-7c0a-92ec-e273abbb3d53	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-20	174.5300	f
01a09b0f-dd00-7c17-a31b-624994635165	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-31	93.8700	f
01a09b0f-dd00-7c52-a3a6-b5c9b66b81f9	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-25	268.0300	f
01a09b0f-dd00-7c93-b27e-08e99563bd99	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-06	198.2900	f
01a09b0f-dd00-7ca7-8618-f95222aa279c	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-22	189.4900	f
01a09b0f-dd00-7ccf-9297-69f3439dd966	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-07	188.2900	f
01a09b0f-dd00-7d19-926e-6aea18d11a09	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-03	214.6000	f
01a09b0f-dd00-7d26-99da-100cb17817a1	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-15	259.4100	f
01a09b0f-dd00-7d61-8440-0cf7a891f797	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-09	234.3200	f
01a09b0f-dd00-7d76-bedf-de8ef9339794	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-27	221.2300	f
01a09b0f-dd00-7d77-8905-88c657fcc771	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-19	168.9900	f
01a09b0f-dd00-7d91-a80a-b1803c5c2833	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-07	106.7900	f
01a09b0f-dd00-7da4-9ad0-a5e5fb1990e8	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-11	264.7600	f
01a09b0f-dd00-7dab-8248-8b886c80df4b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-20	182.9800	f
01a09b0f-dd00-7dce-8cee-5c3aeea96cba	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-17	160.6900	f
01a09b0f-dd00-7e2e-b91f-a0e7f32a13fd	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-08	222.2700	f
01a09b0f-dd00-7e44-81d7-c94fe118efb2	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-02	101.4500	f
01a09b0f-dd00-7e8a-8df5-c07c233cd716	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-24	268.9900	f
01a09b0f-dd00-7e9d-8954-4feaf97bea36	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-21	193.3900	f
01a09b0f-dd00-7ea0-b58e-4e8059e60ab2	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-07	246.4000	f
01a09b0f-dd00-7ec5-960b-0cbb073f7fc9	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-13	189.3600	f
01a09b0f-dd00-7ede-9d0a-b934715f0fd5	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-16	158.9300	f
01a09b0f-dd00-7f0d-8d79-2bee5e3498d2	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-16	239.1800	f
01a09b0f-dd00-7f3c-9fa6-eed4a306bf44	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-03-19	107.0900	f
01a09b0f-dd00-7f5a-8882-b6793510846e	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-04-10	119.5900	f
01a09b0f-dd00-7f87-837a-8a2d1550edd9	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-01	259.0900	f
01a09b0f-dd00-7fde-833f-7536d6858cfa	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-05-22	218.4100	f
01a09b0f-dd00-7ff4-821a-d0b3b1c06eef	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-06-02	229.0000	f
01a09b0f-dd01-717f-a13c-676b6070480c	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-02	165.2200	f
01a09b0f-dd01-7180-98c8-5700b058149b	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-17	282.8200	f
01a09b0f-dd01-7198-9da6-63acae061043	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-13	265.9900	f
01a09b0f-dd01-71a2-83c4-252b110b055c	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-12	268.1600	f
01a09b0f-dd01-7220-877a-c52c768a1c51	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-08	167.7500	f
01a09b0f-dd01-72ba-ac2b-9b5c4c23fd8f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-04	170.5700	f
01a09b0f-dd01-73bd-bc2a-3f37bd12f366	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-29	177.4500	f
01a09b0f-dd01-740e-aee6-fbadb20cc5ea	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-20	231.3500	f
01a09b0f-dd01-7436-95e8-a2e1846dcee2	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-23	236.5000	f
01a09b0f-dd01-7448-b032-ede992bce8a1	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-28	232.7500	f
01a09b0f-dd01-744a-94b6-cf2a711f89f1	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-31	226.1900	f
01a09b0f-dd01-747d-9c6c-dbcbc03d799f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-09	167.9200	f
01a09b0f-dd01-7490-b55a-eaf002830807	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-27	240.2400	f
01a09b0f-dd01-74bd-989c-9cff92246719	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-04	237.9200	f
01a09b0f-dd01-7520-92ea-3f23ee0a154d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-10	160.3100	f
01a09b0f-dd01-755a-bbe7-c0e629ff4571	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-01	206.6300	f
01a09b0f-dd01-756f-8df6-1b9a57795920	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-11	247.6900	f
01a09b0f-dd01-7788-a10b-03d396593661	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-28	192.2800	f
01a09b0f-dd01-7812-9e93-1ccc46e94245	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-11	162.9500	f
01a09b0f-dd01-787c-bb67-4513bd172477	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-05	224.6300	f
01a09b0f-dd01-7a2b-8857-2fb9b0744fe5	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-07	249.8900	f
01a09b0f-dd01-7a3d-9cde-5c9188ed0d36	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-10	239.9350	f
01a09b0f-dd01-7a7a-94c7-9b33582e97a1	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-27	208.1400	f
01a09b0f-dd01-7a7f-9ef8-f8c39c9fe63f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-31	206.9900	f
01a09b0f-dd01-7a80-87b3-8be2beaae6dd	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-24	222.6100	f
01a09b0f-dd01-7be9-b87a-79b12af82f76	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-19	234.8200	f
01a09b0f-dd01-7c16-8234-9231b99d965d	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-30	201.0800	f
01a09b0f-dd01-7d05-8f1b-4650eda1f2f4	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-25	226.5100	f
01a09b0f-dd01-7d87-90a6-1236a61c3ed2	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-18	245.9700	f
01a09b0f-dd01-7daa-970b-356feb516975	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-14	259.9000	f
01a09b0f-dd01-7ef8-9e76-f2ce019b2619	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-06	230.4300	f
01a09b0f-dd01-7f4d-9311-d7f776c83273	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-26	226.4900	f
01a09b0f-dd01-7f80-9c23-494853b68f7f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-21	230.5700	f
01a09b0f-dd01-7f95-8098-563761299710	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-07-24	213.1500	f
01a09b0f-dd01-7fd3-84af-afbf62c3b1de	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-09-03	164.1700	f
01a09b0f-dd01-7fdf-ba0e-e62c2a80870f	01a09aec-4575-7883-ae54-8f9d1a944c07	2026-08-03	218.3500	f
01a09b0f-ddae-701e-8f1c-86de3991fcfa	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-16	227.2600	f
01a09b0f-ddae-701f-a9da-d1d29dd877ab	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-10	264.5800	f
01a09b0f-ddae-7046-bde4-c5ce999c5004	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-26	254.2200	f
01a09b0f-ddae-704d-b625-d3ec5360a8b7	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-19	261.7700	f
01a09b0f-ddae-7069-811c-7d09c09ceb18	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-22	215.8300	f
01a09b0f-ddae-7071-a527-9e3fba35d433	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-07	183.6500	f
01a09b0f-ddae-707a-90e5-82d8b93ff16b	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-06	277.7800	f
01a09b0f-ddae-708a-b9c9-b2d98dd389dc	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-03	342.9900	f
01a09b0f-ddae-708b-9169-a26277597c09	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-08	223.1500	f
01a09b0f-ddae-70ca-8e92-adb253077200	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-27	198.2900	f
01a09b0f-ddae-70e0-999f-441b54201d24	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-06	356.2800	f
01a09b0f-ddae-70e0-b23c-e7d122fa267f	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-23	200.9900	f
01a09b0f-ddae-70ff-96f6-2c33598a50d1	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-02	265.5800	f
01a09b0f-ddae-7120-899f-7a5ea64734e8	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-02	349.0900	f
01a09b0f-ddae-7126-b927-ab4b9af97765	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-02	272.5000	f
01a09b0f-ddae-713d-9e59-481cf6232698	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-26	208.6700	f
01a09b0f-ddae-7180-9ca3-9f6741e1b3a6	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-26	281.7000	f
01a09b0f-ddae-71a6-bf34-8d9dfff4d4b3	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-21	377.0100	f
01a09b0f-ddae-71c3-8a9f-0a6eb20c4809	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-04	327.2000	f
01a09b0f-ddae-71c3-a966-2b499120b8c6	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-21	224.0000	f
01a09b0f-ddae-71d6-bb30-119d9f2c6457	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-03	268.1000	f
01a09b0f-ddae-71f2-9dc8-34f23ca2c380	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-12	275.6000	f
01a09b0f-ddae-721e-b2b0-4e2afb70ee17	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-17	245.6400	f
01a09b0f-ddae-722b-af41-5906c6a54ee0	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-10	197.4600	f
01a09b0f-ddae-7230-a92c-bfc370b77053	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-30	278.2800	f
01a09b0f-ddae-7231-8d1d-e168f761227d	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-14	216.2700	f
01a09b0f-ddae-7237-b5f0-97adf5334e46	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-05	213.8000	f
01a09b0f-ddae-7247-941f-e52ed213fe0a	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-30	247.0300	f
01a09b0f-ddae-724b-bae1-cb374eff0021	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-01	251.3600	f
01a09b0f-ddae-729b-b9de-5ae68db68f9e	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-04	210.0500	f
01a09b0f-ddae-72c2-8a64-e5fa5bc20899	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-17	199.3500	f
01a09b0f-ddae-731f-9f32-27c4ffd79a9b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-02	267.2100	f
01a09b0f-ddae-7323-bb1e-dd3d07a9a572	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-02	203.8900	f
01a09b0f-ddae-7329-8416-eb129a91e540	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-10	363.7100	f
01a09b0f-ddae-7339-b0f1-826f963bf782	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-07	322.9700	f
01a09b0f-ddae-734b-9e82-2a8aa9cb73dd	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-07	370.0700	f
01a09b0f-ddae-7362-be10-f7ba86510e5e	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-02	176.4600	f
01a09b0f-ddae-7368-a374-74535ea8e849	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-15	183.4100	f
01a09b0f-ddae-73d9-8fcc-6b106acd6a9e	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-29	249.2400	f
01a09b0f-ddae-73ef-b7ee-891e4091a0d0	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-26	305.3500	f
01a09b0f-ddae-73f4-8351-80da206eb9ee	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-13	253.8500	f
01a09b0f-ddae-73fb-bbdf-6a1a89091ca2	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-24	249.8400	f
01a09b0f-ddae-7417-9217-197f1c2e4206	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-29	390.8200	f
01a09b0f-ddae-7424-b3d4-5f341f0ba1cc	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-26	254.3000	f
01a09b0f-ddae-7439-a876-2019bb045ab9	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-17	230.1500	f
01a09b0f-ddae-7463-96cb-ea27d7a4697b	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-22	261.1600	f
01a09b0f-ddae-74a7-ba83-932cb8b9e401	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-20	203.7300	f
01a09b0f-ddae-74ba-bfac-e6103194fed5	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-21	303.9400	f
01a09b0f-ddae-74c7-b7bd-4ed10d3990ea	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-07	294.1600	f
01a09b0f-ddae-74d4-b23b-dd6e0489866f	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-16	233.6200	f
01a09b0f-ddae-7504-952b-34e709cfc721	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-07	234.9400	f
01a09b0f-ddae-7527-a2ea-c51206b1112a	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-23	344.2300	f
01a09b0f-ddae-753a-8027-2478d28d0dd9	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-18	229.6800	f
01a09b0f-ddae-7552-932a-e0fd2d15d959	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-03	175.6500	f
01a09b0f-ddae-7580-b806-bbda09e6660c	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-27	359.7300	f
01a09b0f-ddae-759c-a3ba-818d1b24650d	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-06	232.3900	f
01a09b0f-ddae-75a2-8b6a-c80bb731cf91	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-18	262.6500	f
01a09b0f-ddae-75af-812f-024676b751e7	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-08	173.8500	f
01a09b0f-ddae-75e5-9d0f-05a2981faba9	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-05	242.0900	f
01a09b0f-ddae-75f4-a44e-9e6a64adbb4c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-15	306.1000	f
01a09b0f-ddae-75f7-8af2-1fbd92e85b7a	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-28	259.3000	f
01a09b0f-ddae-7622-9227-37ddb8e8f1fe	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-15	228.7400	f
01a09b0f-ddae-7657-b9e3-f4993f39eeba	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-30	310.0700	f
01a09b0f-ddae-766c-9f76-a1885111a3d8	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-12	217.3700	f
01a09b0f-ddae-7674-a3dc-d491047f50c9	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-23	258.0500	f
01a09b0f-ddae-76a0-ba11-33c35bc3194d	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-04	278.6300	f
01a09b0f-ddae-76eb-abfc-5dae6ba368a0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-14	307.5700	f
01a09b0f-ddae-76f4-aa40-9b44b95f58e4	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-11	210.1600	f
01a09b0f-ddae-770d-a7b8-2c144c68d9de	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-11	224.3200	f
01a09b0f-ddae-7715-80e4-28f9baaed9de	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-18	177.5700	f
01a09b0f-ddae-771a-b215-1bd96f189295	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-16	235.8200	f
01a09b0f-ddae-7726-9613-c720bc2c1080	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-12	222.1300	f
01a09b0f-ddae-7728-b1b0-b8165e070a67	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-15	215.2600	f
01a09b0f-ddae-773a-904e-c736f8f185e9	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-18	206.6700	f
01a09b0f-ddae-774e-8abf-28b84703d162	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-11	219.1000	f
01a09b0f-ddae-777a-893d-5a6a7a46f174	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-30	383.3100	f
01a09b0f-ddae-7783-9905-dd5f618d1a4e	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-17	233.8900	f
01a09b0f-ddae-77b1-847e-ee4be218a541	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-31	367.4600	f
01a09b0f-ddae-77be-922e-dd4689cbce55	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-09	264.6900	f
01a09b0f-ddae-7804-a557-9e578f2da946	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-03	201.5400	f
01a09b0f-ddae-781d-8ae3-c67de4eb71d5	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-05	266.2300	f
01a09b0f-ddae-7822-a6b5-d3efc85a1cd3	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-13	298.2700	f
01a09b0f-ddae-7831-adcd-e9cf106bf870	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-08	268.5000	f
01a09b0f-ddae-783b-bee4-bb13d0f1a296	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-01	208.3300	f
01a09b0f-ddae-7840-87c2-827193ba3446	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-27	309.3900	f
01a09b0f-ddae-786c-bb91-c307716daa6f	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-22	302.3700	f
01a09b0f-ddae-7871-acf0-42954ab67b08	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-24	242.3300	f
01a09b0f-ddae-7872-a1bd-2c87aa0ca18a	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-15	243.4800	f
01a09b0f-ddae-788e-8418-67c01922288c	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-14	189.0800	f
01a09b0f-ddae-7895-94b3-7f71782684df	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-01	168.7100	f
01a09b0f-ddae-78d0-86b0-363256294fc3	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-06	263.4700	f
01a09b0f-ddae-78d4-a849-c6c1595a0f39	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-31	242.7600	f
01a09b0f-ddae-78e6-b41f-a3bace6a3ae2	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-19	208.8800	f
01a09b0f-ddae-78e7-9bb1-ff2c2fc9c142	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-03	343.4900	f
01a09b0f-ddae-78ee-ad3a-aff4b636e7a3	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-25	248.9800	f
01a09b0f-ddae-78f7-a919-d0aee1185298	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-05	325.7300	f
01a09b0f-ddae-7900-b639-6209f92c3136	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-12	249.0100	f
01a09b0f-ddae-7903-abcf-e7ff6c0d5724	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-04	251.4300	f
01a09b0f-ddae-7915-b305-fda2940d5c13	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-24	383.0000	f
01a09b0f-ddae-7958-8164-92ecc716d2ed	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-23	296.1900	f
01a09b0f-ddae-7979-b2fb-e5b80aa99f39	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-05	300.4100	f
01a09b0f-ddae-79a4-b4e6-ad596bf2ee7b	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-21	241.7300	f
01a09b0f-ddae-79b3-9b69-ac561c9fcb14	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-09	179.3700	f
01a09b0f-ddae-7a15-803b-f872b2cbfba5	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-24	260.1800	f
01a09b0f-ddae-7a3d-b8c7-83137ab060f7	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-23	229.5100	f
01a09b0f-ddae-7a7d-89a5-79a5871f1ab1	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-19	294.4900	f
01a09b0f-ddae-7aba-946b-3944493638f4	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-18	246.0800	f
01a09b0f-ddae-7ac3-8a60-0022b6fec9ed	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-13	400.7400	f
01a09b0f-ddae-7ad0-8d51-ebab0e961e4b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-12	309.2600	f
01a09b0f-ddae-7afb-907c-5e22ec35ee4c	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-28	209.3800	f
01a09b0f-ddae-7b05-8f02-12247f21d09d	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-05	205.3900	f
01a09b0f-ddae-7b4b-98e6-8ffe3f0fecd5	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-04	199.0100	f
01a09b0f-ddae-7b84-9936-03f166bed7f4	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-14	250.0000	f
01a09b0f-ddae-7b90-8e3f-2ef5eb81a3b4	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-23	302.5900	f
01a09b0f-ddae-7b96-85a7-0451273da658	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-30	225.1900	f
01a09b0f-ddae-7b98-ac8a-4fab33282d6a	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-06	311.8900	f
01a09b0f-ddae-7b99-82bc-7a8f0b70780d	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-16	415.4300	f
01a09b0f-ddae-7bb2-9bb8-fa8c7b96f040	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-19	166.5800	f
01a09b0f-ddae-7be1-a7ec-be88962fd827	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-09	371.0900	f
01a09b0f-ddae-7c03-9c28-85e793421d6c	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-11	206.4000	f
01a09b0f-ddae-7c3a-97d7-222c15f9058c	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-21	177.2800	f
01a09b0f-ddae-7c46-85c3-3f6fea7829b0	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-22	186.4700	f
01a09b0f-ddae-7c80-bdbb-ef19a1bffb61	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-08	204.6800	f
01a09b0f-ddae-7c93-bc8a-734bf87cd684	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-29	301.5000	f
01a09b0f-ddae-7c9b-be9f-b46ab44dc054	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-09	276.2400	f
01a09b0f-ddae-7ca1-81c0-10a12dbd1134	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-10	264.9900	f
01a09b0f-ddae-7caa-bbbf-2478d2851744	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-13	199.1900	f
01a09b0f-ddae-7cb9-87f0-7f2b4a467b09	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-17	380.1800	f
01a09b0f-ddae-7cc3-b206-0b1166611d62	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-09	217.9000	f
01a09b0f-ddae-7cc4-858a-a4790fd9599c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-20	315.9200	f
01a09b0f-ddae-7ce9-b9b6-62790110fe31	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-20	241.3100	f
01a09b0f-ddae-7cfe-85a8-f24069da0f0c	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-08	364.2200	f
01a09b0f-ddae-7d09-925c-6dadb9e63866	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-25	241.0000	f
01a09b0f-ddae-7d31-851b-b8d9f6fde0b7	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-22	306.2200	f
01a09b0f-ddae-7d6f-ba6a-9217f2c186ca	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-31	215.4000	f
01a09b0f-ddae-7d98-8a72-e030742971df	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-24	276.0000	f
01a09b0f-ddae-7d9d-8b2a-57293e11429a	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-19	264.2700	f
01a09b0f-ddae-7da1-b3b1-e643bc6c7e6c	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-20	399.8700	f
01a09b0f-ddae-7dbc-afc9-0886615acb8b	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-10	219.3000	f
01a09b0f-ddae-7dbd-b2c0-4c617a559b0e	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-10	290.2000	f
01a09b0f-ddae-7dcc-b09c-02aeb2484118	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-29	315.6200	f
01a09b0f-ddae-7dd8-8985-0bc87df7411f	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-16	331.0300	f
01a09b0f-ddae-7dea-8cd5-490fa609a69d	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-03	280.4700	f
01a09b0f-ddae-7df3-8df4-e71131b8b989	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-17	221.0900	f
01a09b0f-ddae-7e57-be4c-69257cbbca4c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-24	207.1700	f
01a09b0f-ddae-7e73-acc7-6acaca39901d	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-12-11	273.1100	f
01a09b0f-ddae-7e79-9421-0cdc5107d7db	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-12	185.2000	f
01a09b0f-ddae-7e7d-b1c3-d02c229b85da	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-18	249.3400	f
01a09b0f-ddae-7e86-b031-c20a9c61debe	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-29	201.7300	f
01a09b0f-ddae-7ea1-92cc-7df9ee9ec6af	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-28	239.4000	f
01a09b0f-ddae-7ebc-8c65-1a53a94e1775	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-14	396.1600	f
01a09b0f-ddae-7ebc-a6b6-fb31a8510e5b	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-11-11	275.5400	f
01a09b0f-ddae-7ebf-a6ed-0dd883c4bdc0	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-28	363.7000	f
01a09b0f-ddae-7ec9-b5c0-1f0e7ec3967d	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-13	187.4400	f
01a09b0f-ddae-7f11-a375-953a16306d47	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-01	331.1100	f
01a09b0f-ddae-7f30-876c-d607b0bf0ee6	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-08	286.2500	f
01a09b0f-ddae-7f51-882c-66fbee6f1d5a	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-15	436.0000	f
01a09b0f-ddae-7f5c-9b1c-cf90f9dfb290	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-09	306.1900	f
01a09b0f-ddae-7f77-9080-e987b5328098	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-10-22	314.8300	f
01a09b0f-ddae-7fa2-ba1b-70e7c357f1e6	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-20	175.9900	f
01a09b0f-ddae-7fa6-83fb-4dc3937bcc38	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-09-25	312.1900	f
01a09b0f-ddae-7fca-a814-ec1cec0ac0ec	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-01-28	337.7600	f
01a09b0f-ddae-7fed-a2bc-b5a7bf68d7da	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-07-29	224.0800	f
01a09b0f-ddae-7fef-8df3-b422fb8b8110	01a09aec-4576-71e2-bf71-4939cb0a312f	2025-08-25	185.2800	f
01a09b0f-ddaf-700d-a280-090599d0246d	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-21	171.2400	f
01a09b0f-ddaf-7046-9cbe-9f5fd5609da4	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-30	167.8700	f
01a09b0f-ddaf-706e-9f27-b4757e325129	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-27	194.7800	f
01a09b0f-ddaf-706f-b7fb-46f2c107cde0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-17	203.6300	f
01a09b0f-ddaf-7072-a09e-07e254c87783	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-08	207.3300	f
01a09b0f-ddaf-7076-9a41-545e1fdafc96	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-13	191.9900	f
01a09b0f-ddaf-7085-a607-c596b4d269ac	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-02	183.2100	f
01a09b0f-ddaf-70d2-ba79-6b2f205e2f24	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-10	146.6100	f
01a09b0f-ddaf-710d-a044-0ea99fe48ea6	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-06	231.3200	f
01a09b0f-ddaf-7130-9f31-dbc5cbf40148	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-23	177.5000	f
01a09b0f-ddaf-715f-8a85-427f5b6f396f	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-05	194.2800	f
01a09b0f-ddaf-7188-815b-7bdb8d0c1b1e	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-02	162.1300	f
01a09b0f-ddaf-718f-bf66-dd36c824a0a3	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-20	176.1300	f
01a09b0f-ddaf-71bc-b40b-a5bf3533cfb9	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-23	193.6100	f
01a09b0f-ddaf-71e4-8758-02bfad9312bc	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-01	166.3400	f
01a09b0f-ddaf-71f0-97db-dbe87cf529d9	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-29	160.2500	f
01a09b0f-ddaf-7216-b3bb-e28972a09135	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-24	195.8400	f
01a09b0f-ddaf-722c-a856-d82ba07b42a0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-10	200.8400	f
01a09b0f-ddaf-72a8-bd92-dc2dc6f862b4	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-17	170.3100	f
01a09b0f-ddaf-72aa-9b6b-991fa1cd3bb7	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-17	213.6000	f
01a09b0f-ddaf-72aa-bd32-d7969617e0f8	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-09	180.1700	f
01a09b0f-ddaf-72bb-91f3-1553e0dda3ca	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-01	189.0000	f
01a09b0f-ddaf-72ef-950a-0b652d34a8e9	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-22	174.2800	f
01a09b0f-ddaf-7300-a0ce-5480d10b0d2e	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-05	206.0400	f
01a09b0f-ddaf-7306-b94b-3f8a3ab845b3	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-13	156.0500	f
01a09b0f-ddaf-730d-b5d3-f332927e28cf	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-31	176.9300	f
01a09b0f-ddaf-732f-a49c-bafe58a2be5c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-12	214.8500	f
01a09b0f-ddaf-7385-a481-9869a2205a1a	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-08	190.1300	f
01a09b0f-ddaf-73cb-b53c-1f9eab8ee99c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-07	206.3000	f
01a09b0f-ddaf-7419-9b6f-b2cd9fde0292	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-06	178.0300	f
01a09b0f-ddaf-744f-8782-c81280b66340	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-27	175.9800	f
01a09b0f-ddaf-7455-937d-e753e5cb477c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-09	156.0200	f
01a09b0f-ddaf-7466-8052-5a325da61f13	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-02	171.4900	f
01a09b0f-ddaf-746a-976a-cecc59039323	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-11	213.2200	f
01a09b0f-ddaf-746d-84cb-643458cdedf7	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-14	159.3800	f
01a09b0f-ddaf-746e-8f30-abc069d8d79b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-27	182.9000	f
01a09b0f-ddaf-749f-95ac-21dfa267d615	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-16	212.8400	f
01a09b0f-ddaf-74b3-8550-99970cbd53eb	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-04	206.9200	f
01a09b0f-ddaf-74df-8e77-965848c8eae3	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-07	191.3700	f
01a09b0f-ddaf-7508-a3c8-3eb43317c51c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-06	174.2300	f
01a09b0f-ddaf-752a-9c87-6cc0959b9808	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-03	184.7600	f
01a09b0f-ddaf-7532-bc4c-3e03247bb20a	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-28	185.4600	f
01a09b0f-ddaf-756d-9e5e-4462002aab9d	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-24	163.8900	f
01a09b0f-ddaf-7596-913a-2055574513cb	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-26	183.3600	f
01a09b0f-ddaf-75a3-8ffd-2274fd12c194	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-06	188.8900	f
01a09b0f-ddaf-75a9-a846-3aeede188810	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-29	191.9800	f
01a09b0f-ddaf-75b4-8f89-7ac7bd7c9251	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-22	183.6800	f
01a09b0f-ddaf-75c0-b0c6-af5bd89b2729	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-30	176.7500	f
01a09b0f-ddaf-75cf-b04e-2ad59648a536	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-09	181.4900	f
01a09b0f-ddaf-75d1-ad0a-214ed56223f2	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-15	197.7900	f
01a09b0f-ddaf-75da-9d2b-d9fe218fe4f9	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-10	187.2200	f
01a09b0f-ddaf-7605-8d95-c91efea62f10	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-09	195.8500	f
01a09b0f-ddaf-7605-b637-586019a90bdc	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-15	182.6000	f
01a09b0f-ddaf-7627-bdbb-24584da46c60	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-13	192.3100	f
01a09b0f-ddaf-7639-8bfd-e38c7a5e44b0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-19	169.0000	f
01a09b0f-ddaf-7639-a324-19de49088e86	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-26	193.3100	f
01a09b0f-ddaf-764a-8bdc-58d7d9e17890	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-03	170.4600	f
01a09b0f-ddaf-764d-8dcf-01bb611eba85	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-29	182.4700	f
01a09b0f-ddaf-764f-a82e-10c0c398ec62	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-11	152.3100	f
01a09b0f-ddaf-7674-866d-1e5f7270ca08	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-08	166.4700	f
01a09b0f-ddaf-767e-8094-fd5c8270ca3b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-15	156.5400	f
01a09b0f-ddaf-7689-bc46-9cde10d519c7	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-19	205.0900	f
01a09b0f-ddaf-769a-ad3d-f32d59783b7b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-24	177.1400	f
01a09b0f-ddaf-769b-975c-9060c06c61ec	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-10	189.3400	f
01a09b0f-ddaf-76b9-877e-3b724548746e	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-25	210.6300	f
01a09b0f-ddaf-76c1-9f53-569b9ba80053	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-09	173.5600	f
01a09b0f-ddaf-7704-82c6-023137c7f76d	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-05	161.7800	f
01a09b0f-ddaf-7726-928e-fce774c61e14	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-28	205.5900	f
01a09b0f-ddaf-772c-aa91-f886ffe55d41	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-04	173.8900	f
01a09b0f-ddaf-772e-8568-8bc1739cec12	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-20	199.6100	f
01a09b0f-ddaf-7745-beba-3b9359217a27	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-25	193.3900	f
01a09b0f-ddaf-7770-8a93-4bc5a241d5f5	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-01	168.3100	f
01a09b0f-ddaf-77c1-a55a-6f2abc20f61b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-28	175.7800	f
01a09b0f-ddaf-77cf-886c-ecac23a22036	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-31	173.5900	f
01a09b0f-ddaf-77e8-a68c-251039352771	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-26	165.5200	f
01a09b0f-ddaf-77e8-ad6f-42c8b0ee3f7b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-27	180.1300	f
01a09b0f-ddaf-77ec-9fdb-06818c43acee	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-05	187.6300	f
01a09b0f-ddaf-7800-8635-e9b17efadfd0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-28	169.6500	f
01a09b0f-ddaf-7815-850c-b2948779a9a7	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-19	183.6800	f
01a09b0f-ddaf-7816-a5b7-594411ff6256	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-17	184.1200	f
01a09b0f-ddaf-7842-8de4-d0e851828789	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-03	181.6700	f
01a09b0f-ddaf-789f-be7c-feabc9e90d69	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-24	171.1300	f
01a09b0f-ddaf-78b2-9172-81a084926f7a	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-31	171.4000	f
01a09b0f-ddaf-78bb-a558-58a4eaba180f	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-27	221.9800	f
01a09b0f-ddaf-7913-9d0f-e9923260fa46	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-14	192.3200	f
01a09b0f-ddaf-7915-aa01-139a1651d7ff	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-26	210.9600	f
01a09b0f-ddaf-7915-b06e-87e9dfd346fb	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-13	209.6400	f
01a09b0f-ddaf-793a-8fad-776d06176631	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-20	186.7600	f
01a09b0f-ddaf-7944-a4af-1118ea469681	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-29	159.6900	f
01a09b0f-ddaf-794e-9602-87f0e9f7883b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-21	177.1500	f
01a09b0f-ddaf-7967-8b38-911ce0ca137d	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-18	172.9500	f
01a09b0f-ddaf-7971-b4c9-f3c560540770	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-01	183.1600	f
01a09b0f-ddaf-79b3-b51c-7058517a583e	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-12	162.5800	f
01a09b0f-ddaf-79d4-8704-036c20602e93	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-03	197.3500	f
01a09b0f-ddaf-79da-9475-c8cb9c6fd53a	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-15	176.6500	f
01a09b0f-ddaf-79fa-b1f8-cd366e517f27	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-10	171.0500	f
01a09b0f-ddaf-79fc-982a-f25f131b4021	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-23	170.7800	f
01a09b0f-ddaf-7a04-8700-024b4d30661b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-04	189.2400	f
01a09b0f-ddaf-7a0d-a5f8-4058b4db507b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-20	169.3100	f
01a09b0f-ddaf-7a2c-983a-0550d782d5cd	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-02	207.9900	f
01a09b0f-ddaf-7a2d-8a18-2314be000dac	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-18	208.4600	f
01a09b0f-ddaf-7a32-8ff3-427aad55d4e8	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-16	165.4700	f
01a09b0f-ddaf-7a40-9a4b-19c4d89afd1e	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-22	179.3600	f
01a09b0f-ddaf-7a7f-ace2-d684783465a8	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-02	199.1300	f
01a09b0f-ddaf-7a86-8ada-bf47494819dc	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-16	147.0700	f
01a09b0f-ddaf-7a99-9386-5ac64340f127	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-11	158.6800	f
01a09b0f-ddaf-7a99-b441-b8b312c8a373	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-11	200.3500	f
01a09b0f-ddaf-7ad4-a642-bd31ca1cb09a	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-13	191.8200	f
01a09b0f-ddaf-7b4f-ba70-9a23214a4e9b	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-30	168.5200	f
01a09b0f-ddaf-7b52-b4bc-50a66553ec4a	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-04	203.0800	f
01a09b0f-ddaf-7bd1-a165-36c23fd34ffe	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-30	210.9600	f
01a09b0f-ddaf-7bf9-b97c-aff9c2fbcf26	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-02-27	202.5900	f
01a09b0f-ddaf-7c0e-890b-aaeda99a955d	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-10	165.8700	f
01a09b0f-ddaf-7c44-9b22-893a1d476261	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-16	202.0200	f
01a09b0f-ddaf-7c67-81d5-d2150f671d50	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-20	156.3900	f
01a09b0f-ddaf-7cd7-a415-146240179090	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-25	170.3800	f
01a09b0f-ddaf-7cdb-855a-c1cc944690a0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-01	206.6400	f
01a09b0f-ddaf-7d43-9e30-36dcf5cd8468	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-14	193.1100	f
01a09b0f-ddaf-7d44-a132-8f96f4f1e597	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-08	163.7400	f
01a09b0f-ddaf-7d47-8d46-93a6e11dae58	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-21	191.5500	f
01a09b0f-ddaf-7d48-b599-a9cc5b748907	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-04	186.6900	f
01a09b0f-ddaf-7d65-b297-5436089b827c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-23	219.5800	f
01a09b0f-ddaf-7d66-9061-d146530f481c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-06	183.5300	f
01a09b0f-ddaf-7d69-a763-c77765d35479	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-06-18	191.3900	f
01a09b0f-ddaf-7d7b-ac45-8b18e9e3e663	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-26	187.6300	f
01a09b0f-ddaf-7def-960a-6d978ea16ea0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-03-25	193.2600	f
01a09b0f-ddaf-7e05-b4dd-c9bef3b711b4	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-21	186.2600	f
01a09b0f-ddaf-7e12-adbf-28b72e752732	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-22	217.0800	f
01a09b0f-ddaf-7e33-94e2-be522c8a46b1	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-17	156.0500	f
01a09b0f-ddaf-7e6a-b363-48bcd682c273	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-07-07	165.6400	f
01a09b0f-ddaf-7e79-aa74-46f35b3c360f	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-14	190.1500	f
01a09b0f-ddaf-7e7e-8db4-d8cd5e7a7716	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-24	205.6300	f
01a09b0f-ddaf-7e96-b5f5-f7da15c030dc	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-12	185.0600	f
01a09b0f-ddaf-7ef6-a56d-2cad3b3d0de5	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-18	175.7000	f
01a09b0f-ddaf-7f57-a7ff-b1686993a12c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-05-12	202.3400	f
01a09b0f-ddaf-7f7e-a78e-42e2e3f431e0	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-09-08	185.5300	f
01a09b0f-ddaf-7f83-94ed-d35ca8be93de	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-04-07	173.4700	f
01a09b0f-ddaf-7fc0-ac7b-3f7ce6d2b37c	01a09aec-4576-71e2-bf71-4939cb0a312f	2026-08-11	189.1900	f
01a09b0f-de40-7038-a329-a95f9d5ecea1	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-30	16.4600	f
01a09b0f-de40-7090-9a2d-2eb00cc7436a	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-06	17.8300	f
01a09b0f-de40-70c6-8447-8dbe173b0379	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-01	21.6600	f
01a09b0f-de40-70f2-b817-a218c64340f1	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-10	20.3100	f
01a09b0f-de40-7144-b8d9-93580b0b30b8	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-16	19.2400	f
01a09b0f-de40-71bf-ab8e-0242b4ec7296	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-11	20.0700	f
01a09b0f-de40-7241-b170-c3e4cecd6ed5	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-06	19.0300	f
01a09b0f-de40-7255-82c1-c4c0939261e0	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-04	21.6200	f
01a09b0f-de40-7276-a520-ad7ad29c8d3c	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-02	23.3700	f
01a09b0f-de40-727c-94b5-35254c72d44f	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-30	21.6400	f
01a09b0f-de40-72e9-840a-0632461c6be7	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-31	18.2500	f
01a09b0f-de40-7331-9fc4-7a258c3abd65	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-12	20.9500	f
01a09b0f-de40-7350-8970-4f2c1a8d6e55	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-21	20.5200	f
01a09b0f-de40-739e-abe6-5496ac988186	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-13	18.6700	f
01a09b0f-de40-7463-ba28-4bd6b0e5f4ca	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-16	20.9300	f
01a09b0f-de40-74c0-9935-d1a9866ec3aa	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-22	22.6300	f
01a09b0f-de40-74e7-8e6b-ba6849f4e342	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-03	20.8900	f
01a09b0f-de40-753c-a9b8-5e6e86ae9c65	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-27	21.3200	f
01a09b0f-de40-7577-ab1c-f86095155a4e	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-23	17.7900	f
01a09b0f-de40-7579-8075-f48cf8fd16bc	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-05	20.3200	f
01a09b0f-de40-75ac-b235-7bd72a837a4d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-11	22.0400	f
01a09b0f-de40-75cb-ae3d-197038cd0fe6	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-28	20.5900	f
01a09b0f-de40-75e4-bf5e-cc5fee1c15bb	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-23	21.9100	f
01a09b0f-de40-75f4-96a5-94cc70a99840	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-07	23.3500	f
01a09b0f-de40-7660-b808-69d78c68af0e	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-13	19.3600	f
01a09b0f-de40-7727-86bc-911353a2ff0a	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-14	19.5000	f
01a09b0f-de40-777b-afde-90e8316e694f	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-07	17.4400	f
01a09b0f-de40-77a0-8503-dfd04047ba65	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-18	17.4000	f
01a09b0f-de40-77b3-ae35-82f98bfcba57	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-26	17.6600	f
01a09b0f-de40-780e-ae5b-17ea8f1f09b5	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-15	21.0000	f
01a09b0f-de40-7817-a529-3d0acbb1aaf2	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-06	23.5200	f
01a09b0f-de40-783b-9cc1-006e00f14842	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-09	18.3200	f
01a09b0f-de40-784e-b6f3-d1a7fe4da81f	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-25	18.7500	f
01a09b0f-de40-78ae-b0cf-02778f65ebfd	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-27	17.6100	f
01a09b0f-de40-78b3-b05e-00fc2c1d6e7e	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-08	21.3800	f
01a09b0f-de40-78d8-9869-6336869b958a	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-12	19.8200	f
01a09b0f-de40-78d9-8918-dcf65207d72c	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-17	20.4900	f
01a09b0f-de40-7990-afd4-8c2f0401c478	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-01	17.9500	f
01a09b0f-de40-7a29-a4f9-eac2543fcfa1	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-08	18.3800	f
01a09b0f-de40-7a30-b2ad-89ba6bf1bdc5	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-13	20.1800	f
01a09b0f-de40-7aa0-ad53-83a0e19e4847	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-04	21.8100	f
01a09b0f-de40-7af8-bafb-2c9f3aaa28ab	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-05	21.0400	f
01a09b0f-de40-7b51-8763-50cb6d61ae65	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-24	20.3200	f
01a09b0f-de40-7b64-8925-d74184c7ba4f	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-18	18.7100	f
01a09b0f-de40-7b95-89b8-ea24caf646fd	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-19	16.1800	f
01a09b0f-de40-7c2c-aa7f-04e4fdf63e25	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-14	19.5400	f
01a09b0f-de40-7c6c-b0c0-132af16feec7	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-24	18.0600	f
01a09b0f-de40-7d48-83ba-7338c3cff64d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-19	17.9200	f
01a09b0f-de40-7d86-8b9f-c1bc90287982	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-02	17.7500	f
01a09b0f-de40-7d8b-8fc7-ba309ce1d714	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-20	16.7500	f
01a09b0f-de40-7d98-9d6a-421fd66a81eb	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-15	18.4100	f
01a09b0f-de40-7dc0-9864-7c82dba00f62	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-29	19.5800	f
01a09b0f-de40-7def-a162-5b85f952cb8b	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-10	18.4000	f
01a09b0f-de40-7df8-8496-fab0425d9e72	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-17	19.3200	f
01a09b0f-de40-7e8a-a809-147cb9c775e5	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-03-09	19.8700	f
01a09b0f-de40-7f89-8d98-e6186d31a09d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-04-20	21.5100	f
01a09b0f-de41-7028-89d2-516726b6804e	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-27	15.7400	f
01a09b0f-de41-7030-8f71-420b997f2534	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-03	18.0000	f
01a09b0f-de41-703b-8339-12ec5e739ccc	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-02	13.8100	f
01a09b0f-de41-7041-a291-e688cb549813	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-10	14.2900	f
01a09b0f-de41-7042-bdb3-9058fee5a45a	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-25	14.4200	f
01a09b0f-de41-7053-a691-ea8f86bb7022	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-03	12.1500	f
01a09b0f-de41-7064-a9c1-b8406dd44c6c	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-02	19.5400	f
01a09b0f-de41-7092-9ff8-3197155256fb	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-26	15.7000	f
01a09b0f-de41-70a1-bfe7-702796e90daf	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-04	12.8600	f
01a09b0f-de41-70de-bbe5-f9833008ee52	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-10	13.6900	f
01a09b0f-de41-712d-83d4-5ad76f797a6a	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-05	15.0300	f
01a09b0f-de41-714f-8b1d-676892028823	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-11	12.9500	f
01a09b0f-de41-71c2-b42d-37b6bd201d23	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-29	14.5900	f
01a09b0f-de41-7206-8a8d-b9eb7145c7fb	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-20	13.9000	f
01a09b0f-de41-7211-8da0-5eac0fa208ba	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-20	16.7800	f
01a09b0f-de41-7260-8ac7-3da3b44e8775	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-26	14.6200	f
01a09b0f-de41-7280-a62d-4950e1453e6d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-06	13.7700	f
01a09b0f-de41-7282-8a0f-065ef367bb09	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-09	14.3700	f
01a09b0f-de41-728d-abc2-fe0d0cfdfbae	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-12	14.4700	f
01a09b0f-de41-7290-b8e5-8c1e76734e64	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-03	14.3500	f
01a09b0f-de41-7296-8faf-3a5718765dc6	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-21	17.8600	f
01a09b0f-de41-72ae-883e-70d3a1fd3cf3	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-09	13.4900	f
01a09b0f-de41-72ec-8353-4206dcfa7103	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-06	12.9000	f
01a09b0f-de41-737d-8df1-74120341dc91	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-26	18.4000	f
01a09b0f-de41-73e9-9a78-8de54e59f031	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-02	14.2900	f
01a09b0f-de41-740c-a092-77e4981e1b09	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-04	17.3700	f
01a09b0f-de41-743a-9225-3c313bdf81f9	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-08	13.1400	f
01a09b0f-de41-746e-b493-2895f3dbf9ba	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-14	13.2300	f
01a09b0f-de41-7478-856f-9fc3e9f3e137	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-13	13.0500	f
01a09b0f-de41-7482-8aca-424156e77e85	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-18	14.0900	f
01a09b0f-de41-749f-9520-769748a3d2f2	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-08	15.2100	f
01a09b0f-de41-7503-9492-24314f815a6c	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-21	12.3500	f
01a09b0f-de41-7573-baf6-044d516f3646	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-13	14.5800	f
01a09b0f-de41-757d-8305-fa97931e8a7d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-16	11.6700	f
01a09b0f-de41-7586-a591-9f8aede8cef5	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-04	14.4700	f
01a09b0f-de41-7587-92ff-7764809373ff	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-11	15.0800	f
01a09b0f-de41-75cf-8190-15a78eb86297	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-12	15.0400	f
01a09b0f-de41-75f3-a2a1-a8d62772794a	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-17	11.4900	f
01a09b0f-de41-7641-9813-69e29c557314	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-21	15.1400	f
01a09b0f-de41-764c-b4d6-fa5fb6619aea	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-05	12.4400	f
01a09b0f-de41-7665-84e2-beeb70b11032	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-15	12.6700	f
01a09b0f-de41-7693-b541-0ac8ae963629	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-30	11.7100	f
01a09b0f-de41-7698-a9e5-9e42c0c62834	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-09	14.5500	f
01a09b0f-de41-770e-95a3-3b36d07d2f5d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-16	15.3400	f
01a09b0f-de41-771c-bcd1-af4251305657	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-07	14.1400	f
01a09b0f-de41-772c-8a73-5a6ef5e75c28	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-25	15.9700	f
01a09b0f-de41-77e0-aeca-6503dc3b3c93	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-15	15.6400	f
01a09b0f-de41-7806-81ba-a168f0fd2b46	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-27	11.7100	f
01a09b0f-de41-7817-b5a3-c03d1d63473d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-24	14.8800	f
01a09b0f-de41-7846-888e-0648e88a002e	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-29	18.2200	f
01a09b0f-de41-784f-84e3-4e6becca8533	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-28	11.3300	f
01a09b0f-de41-7869-a96e-db277028c698	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-01	17.6200	f
01a09b0f-de41-7869-b078-75de22b8d727	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-22	16.1200	f
01a09b0f-de41-78f0-bb64-f524d131be4a	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-31	11.4400	f
01a09b0f-de41-79d1-b9de-a1b9d29ddc3f	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-23	15.4700	f
01a09b0f-de41-79f0-9c2d-11e360e91ab6	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-19	14.8500	f
01a09b0f-de41-7a32-9694-16eefc1a11b8	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-01	14.2200	f
01a09b0f-de41-7a36-ba25-cf53d887f04e	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-23	12.0100	f
01a09b0f-de41-7a77-8598-334f425e5724	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-27	18.3500	f
01a09b0f-de41-7aa8-9d5f-fbab768aee9f	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-01	14.2200	f
01a09b0f-de41-7adb-8719-75069361aaef	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-18	16.5600	f
01a09b0f-de41-7b27-b89c-e64e17434bb0	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-10	13.6300	f
01a09b0f-de41-7b46-91cf-2579f011a215	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-20	11.7400	f
01a09b0f-de41-7b7d-abc1-f91b4265dca6	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-07	12.8600	f
01a09b0f-de41-7be0-a0dc-54419cdef640	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-17	14.7900	f
01a09b0f-de41-7cb1-816e-4a8085674e5b	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-22	18.0400	f
01a09b0f-de41-7ccb-b85f-7aade0df40f1	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-09-08	14.6200	f
01a09b0f-de41-7d29-be1c-4dfab56c75ef	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-28	14.6700	f
01a09b0f-de41-7d9c-a2c8-641302e955a7	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-22	12.3100	f
01a09b0f-de41-7e0b-8b0e-0720391296bb	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-10	13.5800	f
01a09b0f-de41-7e59-a182-90801b8f2c43	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-24	15.0300	f
01a09b0f-de41-7eac-a97c-bd487607899b	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-29	10.7400	f
01a09b0f-de41-7eb1-aaf0-93e5feceb20d	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-17	15.3000	f
01a09b0f-de41-7ef2-8696-1b12f38b784c	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-05-28	18.4400	f
01a09b0f-de41-7f24-b84a-c1715465654f	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-11	14.7800	f
01a09b0f-de41-7f2f-9508-755c8ad1f08e	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-31	14.7500	f
01a09b0f-de41-7fb1-8b6b-aed8714092c6	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-08-14	15.1000	f
01a09b0f-de41-7ff5-b043-5c265f669555	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-06-30	14.5000	f
01a09b0f-de41-7ff7-a80a-8e9ef1fc1fe2	01a09aec-4576-77a7-abc2-c1d63684cf3f	2026-07-24	11.3000	f
01a09b0f-ded8-704a-b258-0e28c7fd4ce6	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-22	65.8800	f
01a09b0f-ded8-7053-b090-7f3d00b4cd5b	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-17	58.8200	f
01a09b0f-ded8-7056-aedc-8ffc73531cf8	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-06	58.2500	f
01a09b0f-ded8-7071-bf60-16ba32f027fe	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-20	62.5800	f
01a09b0f-ded8-7086-8fe8-bcafc4444374	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-27	50.2300	f
01a09b0f-ded8-70ce-8f24-9dd86ab61d71	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-06	48.7600	f
01a09b0f-ded8-70d0-b3ac-e69ac27b7320	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-13	53.9400	f
01a09b0f-ded8-7137-919f-dc547a4c48be	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-09	61.7800	f
01a09b0f-ded8-7139-8c64-00949ff98a3c	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-24	54.0600	f
01a09b0f-ded8-7173-8375-677236360898	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-29	52.7600	f
01a09b0f-ded8-717d-aad8-536933823872	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-22	72.4100	f
01a09b0f-ded8-71a9-bb91-6e12def175ee	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-03	63.3000	f
01a09b0f-ded8-71dc-a6bc-232a01f68b99	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-09	56.4800	f
01a09b0f-ded8-7218-9c0b-7e3fbfe8f7a5	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-24	71.0000	f
01a09b0f-ded8-724e-a391-9dd0a5e6a172	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-30	45.5800	f
01a09b0f-ded8-7297-b17e-5dcfaf4de495	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-10	50.2500	f
01a09b0f-ded8-72b4-a3ba-14d6b25606b9	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-31	49.5900	f
01a09b0f-ded8-72b8-9160-aa180cabea85	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-02	48.1300	f
01a09b0f-ded8-72fe-afbc-d4d9c503606f	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-22	58.4000	f
01a09b0f-ded8-7346-b3f4-15706a3f7e21	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-09	47.7500	f
01a09b0f-ded8-7347-9328-490c188bcd68	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-19	55.8800	f
01a09b0f-ded8-7350-be59-903ceeba761e	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-23	76.4600	f
01a09b0f-ded8-7363-a4fe-d0838e95724a	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-20	53.9700	f
01a09b0f-ded8-7384-a1b0-c34514c48d0f	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-21	65.0900	f
01a09b0f-ded8-7388-9feb-f0766c7dab55	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-25	55.2700	f
01a09b0f-ded8-73af-a72e-3802a797e2ec	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-07	71.8300	f
01a09b0f-ded8-73bc-ab33-365c19a79608	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-15	62.2500	f
01a09b0f-ded8-73c3-a561-f66202a81137	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-21	62.6100	f
01a09b0f-ded8-73e6-87bc-e92a0436d3ef	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-27	75.9300	f
01a09b0f-ded8-741c-8e68-5838d1b3a907	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-24	54.9600	f
01a09b0f-ded8-7427-a5bb-327e602eca83	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-14	58.5800	f
01a09b0f-ded8-7451-b46b-de39b9563f8a	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-04	65.3900	f
01a09b0f-ded8-746a-af57-89b032812519	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-10	54.0200	f
01a09b0f-ded8-7489-a2af-010a409de5f9	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-18	58.5600	f
01a09b0f-ded8-7495-99ee-5a746f887c2a	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-18	56.7000	f
01a09b0f-ded8-74b7-8aaa-60d40a6c1c54	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-23	56.2600	f
01a09b0f-ded8-7538-a784-4aef1f4f1aca	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-12	59.5900	f
01a09b0f-ded8-753b-aa3e-95a8db94e3d3	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-04	68.6000	f
01a09b0f-ded8-757d-89d3-4b8c76edb7ba	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-16	57.4500	f
01a09b0f-ded8-75e0-a8c1-1ef00722728d	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-11	62.7600	f
01a09b0f-ded8-75ec-bef1-b53eb22dd677	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-20	68.1300	f
01a09b0f-ded8-760b-b786-4eabca4d54a8	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-08	50.2100	f
01a09b0f-ded8-7624-9e8a-694477940b7d	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-05	58.0900	f
01a09b0f-ded8-7691-b9d0-325353643c75	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-19	54.6900	f
01a09b0f-ded8-76c8-a2fa-92127a457b0a	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-01	48.0700	f
01a09b0f-ded8-76f0-ba46-7f6288e40b43	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-23	57.1900	f
01a09b0f-ded8-775a-b3e6-2ccbf52fcea4	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-10	61.3800	f
01a09b0f-ded8-7761-b085-fc611b712293	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-29	64.9800	f
01a09b0f-ded8-77c2-afc6-f180526e2f48	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-16	59.6900	f
01a09b0f-ded8-7834-a680-525e350b7858	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-17	60.5300	f
01a09b0f-ded8-787f-825f-7b4473d49d07	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-16	64.2100	f
01a09b0f-ded8-78da-9eba-03135facc712	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-03	65.2100	f
01a09b0f-ded8-78f4-87ec-d7d0c8dc2e47	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-30	72.5000	f
01a09b0f-ded8-7950-af06-b87828fae67a	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-11	57.8600	f
01a09b0f-ded8-7979-a435-f1558ad8e0f8	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-18	61.1700	f
01a09b0f-ded8-798f-9331-7c5399ff4355	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-17	66.8100	f
01a09b0f-ded8-79ab-959e-3b9da8b4cd41	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-25	51.0100	f
01a09b0f-ded8-79fc-8cd9-1e72729facd9	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-14	67.2100	f
01a09b0f-ded8-7a3a-8115-c3af702e86d6	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-26	68.7000	f
01a09b0f-ded8-7a5b-87fc-21d286f24a59	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-06	79.6200	f
01a09b0f-ded8-7aa4-9e7f-5f72c4c42ee8	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-05	62.0300	f
01a09b0f-ded8-7aa7-a6bc-788ae9c1129b	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-28	68.0900	f
01a09b0f-ded8-7b1c-be77-fd365e483d5f	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-02	73.4700	f
01a09b0f-ded8-7b2f-88cb-047c17d66734	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-27	67.8200	f
01a09b0f-ded8-7b52-b4d1-b8d45ad4fcb8	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-01	66.8900	f
01a09b0f-ded8-7bbc-8e6e-171c60034118	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-29	66.8800	f
01a09b0f-ded8-7bce-8d7e-e242faab8c05	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-13	58.3700	f
01a09b0f-ded8-7c39-a433-12c7f96c01c0	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-08	72.5100	f
01a09b0f-ded8-7c50-aa51-4147c8e06423	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-26	50.0000	f
01a09b0f-ded8-7c92-98f9-585300d94c40	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-05	68.3800	f
01a09b0f-ded8-7c94-a874-dc3735067acb	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-26	51.8100	f
01a09b0f-ded8-7c95-a65a-c1e453015e4d	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-15	63.3500	f
01a09b0f-ded8-7cd9-a82b-e56be1237e37	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-02	64.6800	f
01a09b0f-ded8-7d09-90eb-5e48d2f39e21	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-11	78.1300	f
01a09b0f-ded8-7d11-b095-36a5ab2706ea	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-28	69.0900	f
01a09b0f-ded8-7d12-94cc-bd7343a53691	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-13	69.6600	f
01a09b0f-ded8-7d19-91de-a16ee1ee1569	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-15	60.7400	f
01a09b0f-ded8-7e12-bbae-368fc9f1e21c	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-12	73.6300	f
01a09b0f-ded8-7e5e-b9c0-f4e4225bb7a6	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-12	57.4900	f
01a09b0f-ded8-7e6e-a1a9-abd8cb176d2f	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-04-07	46.5900	f
01a09b0f-ded8-7fa9-aa94-56b283e17f3b	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-05-01	70.4000	f
01a09b0f-ded8-7fad-bd9b-7a0fce56adb6	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-03-04	65.6500	f
01a09b0f-ded8-7fe5-8062-c4fb91647a0d	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-08	58.9400	f
01a09b0f-ded9-7078-bdbe-c9b88d31060c	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-13	45.8100	f
01a09b0f-ded9-70b1-9cd0-bcfdc4a2bc4c	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-05	42.9900	f
01a09b0f-ded9-7154-9166-f37d64c2f26b	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-04	43.3300	f
01a09b0f-ded9-71b6-bf53-1c6741146e61	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-31	38.8300	f
01a09b0f-ded9-7260-ab83-af6598f55800	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-08	47.2800	f
01a09b0f-ded9-7297-8fd1-adcd89c7d232	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-24	39.6900	f
01a09b0f-ded9-72bd-be5a-a59d3153e89f	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-26	41.6000	f
01a09b0f-ded9-7363-98a1-8d9399f8460b	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-11	47.0100	f
01a09b0f-ded9-73ad-aa70-8b1112772d4c	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-10	39.8800	f
01a09b0f-ded9-73bf-8b73-036eac4333b2	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-17	41.1100	f
01a09b0f-ded9-7406-acc4-893e01b77348	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-02	52.3600	f
01a09b0f-ded9-7422-b0da-b7ccb0328e6a	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-20	41.6600	f
01a09b0f-ded9-743d-8dfa-334b098204f5	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-10	48.8500	f
01a09b0f-ded9-7464-a5f6-b46b39060454	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-13	46.4500	f
01a09b0f-ded9-7499-877a-5d12e5a5bb35	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-03	39.8400	f
01a09b0f-ded9-7520-81fc-2d1c09dea4d2	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-06	51.8400	f
01a09b0f-ded9-7542-b538-30a77ce61f94	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-14	44.3800	f
01a09b0f-ded9-754d-bf7e-3c1e0f2f65cf	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-21	42.0900	f
01a09b0f-ded9-760b-813b-d4b67ad1db06	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-07	48.4200	f
01a09b0f-ded9-765f-b739-695daf47fd68	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-22	44.5000	f
01a09b0f-ded9-7692-9af8-e1c8adc5886d	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-18	41.3600	f
01a09b0f-ded9-76ad-8fac-b08c88c4bb6c	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-19	42.9400	f
01a09b0f-ded9-76c2-9c16-f743a8f3f157	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-06-30	52.3300	f
01a09b0f-ded9-76fc-af90-3fbfc25890b7	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-09	42.5700	f
01a09b0f-ded9-7734-a52f-93867ce62791	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-12	45.1300	f
01a09b0f-ded9-77e1-89a4-d13a7e18a7c1	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-24	40.2500	f
01a09b0f-ded9-7894-8ea2-b0ef49e0821f	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-25	44.2700	f
01a09b0f-ded9-78c3-8f86-c1d396336ad0	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-28	39.5800	f
01a09b0f-ded9-7921-9946-b699c48b8c93	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-20	41.5100	f
01a09b0f-ded9-7931-9ccb-7143aaaeca6d	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-16	41.7000	f
01a09b0f-ded9-7990-a6ef-e0db1e2ddb21	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-31	40.5700	f
01a09b0f-ded9-7991-9bf3-3a129b6c0c90	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-03	41.2200	f
01a09b0f-ded9-79a5-819a-365947d8a100	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-08	43.3100	f
01a09b0f-ded9-79f4-bf63-ed369e35281d	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-27	42.5300	f
01a09b0f-ded9-7ab2-acdf-3cd5a898a44a	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-01	38.5300	f
01a09b0f-ded9-7b5b-a017-37bbd93b5869	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-06	42.1900	f
01a09b0f-ded9-7bec-b987-eb48b414f1fb	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-09	49.2700	f
01a09b0f-ded9-7c10-a855-1722c4a214d4	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-23	44.0000	f
01a09b0f-ded9-7c16-8ae2-6c9179b664ed	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-17	43.8800	f
01a09b0f-ded9-7c1b-bce4-13d8ac3260cd	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-21	44.1300	f
01a09b0f-ded9-7c4b-9e65-c59121581ff5	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-30	41.0900	f
01a09b0f-ded9-7c8f-914d-854c450a8f52	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-11	36.2200	f
01a09b0f-ded9-7ccd-88db-a26d57bacb2f	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-10	44.4900	f
01a09b0f-ded9-7d51-b2d4-1836f479aa29	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-07	47.9000	f
01a09b0f-ded9-7d52-a4c6-f36206f2222e	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-01	52.4500	f
01a09b0f-ded9-7d8e-bde9-f6b6572ce777	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-15	45.6900	f
01a09b0f-ded9-7f1e-94e0-58f04207fd15	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-27	41.8100	f
01a09b0f-ded9-7f91-8bbc-fb9be64a694b	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-08-28	40.1400	f
01a09b0f-ded9-7fc4-aaa3-c2b7df701007	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-14	46.2400	f
01a09b0f-ded9-7fcb-b802-c4f27580a877	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-07-29	36.8400	f
01a09b0f-ded9-7fdf-9f75-e7b7bb090dcf	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-02	39.5200	f
01a09b0f-ded9-7ff9-afe8-c85a45dddb5b	01a09aec-4576-78fc-bf1d-dbad45060ade	2026-09-04	41.2700	f
01a09b0f-df6f-726a-b8e1-cce3d5ba5cf9	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-15	25.1700	f
01a09b0f-df70-7004-abab-8fc57375bcf4	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-14	29.9200	f
01a09b0f-df70-7014-9f33-92e05183a41b	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-24	24.7000	f
01a09b0f-df70-7035-9071-79cccfb9a0d8	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-20	30.1500	f
01a09b0f-df70-705b-a892-8c0ec729e3c0	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-06	30.6100	f
01a09b0f-df70-7063-bbfc-269b9c94c73c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-15	29.7200	f
01a09b0f-df70-7068-94a8-8e518fc4f16b	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-06	31.1000	f
01a09b0f-df70-7086-ae26-60aa22d1a892	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-16	27.0000	f
01a09b0f-df70-7095-8080-3b452da20f1c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-05	31.5500	f
01a09b0f-df70-7099-b55a-2ba61f11b407	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-08	29.0900	f
01a09b0f-df70-70cc-ad46-990decb526db	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-31	28.2900	f
01a09b0f-df70-70e0-b8ef-3ee2068eeb84	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-01	28.0500	f
01a09b0f-df70-70ef-977e-62b36bde3df5	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-30	33.5100	f
01a09b0f-df70-70ff-ad56-419ae0880819	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-13	29.8300	f
01a09b0f-df70-7133-b01f-42882b3c7fcb	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-04	29.0000	f
01a09b0f-df70-7137-8e56-0bca9ac11745	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-01	25.2100	f
01a09b0f-df70-713b-ac42-439c9e4dfe49	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-21	26.9700	f
01a09b0f-df70-7153-89d1-ad77b32f08e7	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-17	34.9100	f
01a09b0f-df70-7159-a88b-c02a31649b96	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-02	34.1900	f
01a09b0f-df70-716f-ace2-bf796b08dd09	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-19	24.1300	f
01a09b0f-df70-7180-a3bd-a6f85dd46bfb	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-13	26.1200	f
01a09b0f-df70-7198-8b26-7961ea10d4ea	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-04	24.4600	f
01a09b0f-df70-71b0-b79d-b39d588950a1	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-11	31.5000	f
01a09b0f-df70-71c8-b0dc-5be36b9ca01e	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-29	25.9500	f
01a09b0f-df70-71e4-9a78-df183cad6ecc	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-13	34.3700	f
01a09b0f-df70-721b-817c-2240786ca27b	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-25	26.3700	f
01a09b0f-df70-7233-af40-c4a9eabcd8f1	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-05	30.3700	f
01a09b0f-df70-727b-8d20-dd2505bd32ce	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-02	33.3900	f
01a09b0f-df70-7291-8b7f-91075471cb97	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-09	25.0600	f
01a09b0f-df70-729b-b189-25cd8fc0c528	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-23	31.1300	f
01a09b0f-df70-72d0-a62b-43ca1f510dae	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-24	38.5500	f
01a09b0f-df70-7303-8e0b-9f7fd31c05d2	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-06	30.5000	f
01a09b0f-df70-730b-9f66-caa9c55274f3	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-22	27.0700	f
01a09b0f-df70-7332-8445-06f1d4820e3c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-22	26.9800	f
01a09b0f-df70-7367-b705-079861b444ef	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-16	24.5200	f
01a09b0f-df70-7381-84df-c52cf13084c1	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-13	30.9800	f
01a09b0f-df70-73a6-a12b-bd99cc809531	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-28	29.8600	f
01a09b0f-df70-73b2-ab29-819fe1c5e21a	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-29	38.0300	f
01a09b0f-df70-73d7-bdb3-db72c144502f	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-23	26.3700	f
01a09b0f-df70-73dd-a20b-97a49d0cebe6	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-17	26.7700	f
01a09b0f-df70-73f0-b487-509f426cf1d4	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-23	32.8400	f
01a09b0f-df70-73f1-a3f1-6c0a7fbfe79e	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-13	32.1200	f
01a09b0f-df70-73f2-9c37-c2a7cf190de5	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-20	26.9700	f
01a09b0f-df70-73f4-892d-09beb5d6946b	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-15	30.7100	f
01a09b0f-df70-7431-b515-c978d8c818cb	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-05	25.8200	f
01a09b0f-df70-7434-820d-94e7bcf559f0	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-28	25.6000	f
01a09b0f-df70-7440-89be-50f3cd7b30ad	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-09	29.2700	f
01a09b0f-df70-747d-bc04-3a197df7cfe0	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-27	27.5300	f
01a09b0f-df70-7481-8cab-50e206d246bd	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-23	27.7500	f
01a09b0f-df70-7488-ac9e-7eb5be1882c6	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-20	30.9900	f
01a09b0f-df70-74cc-9fc2-75c93d8d4b87	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-12	31.0300	f
01a09b0f-df70-74cd-ac7a-f0fb8a39fdf3	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-13	24.6500	f
01a09b0f-df70-7516-be51-34797fa8cdc2	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-14	25.8900	f
01a09b0f-df70-7542-be9c-04c483bd3fbe	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-30	28.6800	f
01a09b0f-df70-757f-a50c-49ceff8e24ee	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-11	27.7000	f
01a09b0f-df70-75b1-8b97-00de8a213cac	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-05	28.9200	f
01a09b0f-df70-75d2-b52d-18e6ebaf4948	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-10	31.1500	f
01a09b0f-df70-75e5-94f2-e2b21498dfbd	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-10	28.0900	f
01a09b0f-df70-75e7-8626-4c86bed76075	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-22	26.8300	f
01a09b0f-df70-7634-a9e6-ca2c4d5c92f3	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-12	29.3900	f
01a09b0f-df70-7654-837e-c794843050ac	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-14	30.0200	f
01a09b0f-df70-7679-a142-a0c368ea887c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-16	30.1000	f
01a09b0f-df70-7687-92cd-e3a9a72ee515	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-17	28.9500	f
01a09b0f-df70-768a-92be-7a504871e5d3	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-17	24.1300	f
01a09b0f-df70-768a-aa8c-7d98b628eb35	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-07	34.3100	f
01a09b0f-df70-7697-abfd-c9feaabdd13e	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-30	24.9300	f
01a09b0f-df70-76a2-a2b6-3176c19758c7	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-21	39.4200	f
01a09b0f-df70-76a5-a806-ff08c6a9276c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-10	25.7800	f
01a09b0f-df70-76c0-b72a-3a6cb9f916a1	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-11	36.3000	f
01a09b0f-df70-76db-80c1-06e113f5a1a6	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-18	30.1000	f
01a09b0f-df70-7739-838d-08e8b6b2bcde	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-18	29.7500	f
01a09b0f-df70-773b-8b16-a72e749468f7	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-12	36.0700	f
01a09b0f-df70-7740-8a32-2a1d59372891	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-20	25.1000	f
01a09b0f-df70-7776-86ad-c497cbd48786	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-08	28.4800	f
01a09b0f-df70-7791-afe3-04aa7d389148	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-10	30.9800	f
01a09b0f-df70-779a-8cb1-651c4cb7bb2e	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-19	29.6800	f
01a09b0f-df70-779a-a292-4a4812612e73	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-12	30.0200	f
01a09b0f-df70-77a4-b4d6-11fa7ca52ff2	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-11	28.9700	f
01a09b0f-df70-77cc-8e76-6f385364314f	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-09	31.7700	f
01a09b0f-df70-77cd-8173-4845d9a70432	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-26	34.4200	f
01a09b0f-df70-77f8-87df-52172c43490a	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-03	30.9700	f
01a09b0f-df70-7847-99fe-e3fec13b48bb	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-07	28.8500	f
01a09b0f-df70-784c-9f57-ff685bedb313	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-16	29.5100	f
01a09b0f-df70-785d-84fb-f75a99a7bffa	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-10	25.5800	f
01a09b0f-df70-7872-85ba-678c3b910ac1	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-06	26.4000	f
01a09b0f-df70-7878-9d16-4c5c6fcd6610	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-17	29.9300	f
01a09b0f-df70-787a-98f6-6de1ea1a42b1	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-17	24.9600	f
01a09b0f-df70-78ad-9cc5-136278f4c2c2	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-31	26.6700	f
01a09b0f-df70-78cb-97e8-3e664382eedc	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-26	33.4600	f
01a09b0f-df70-78e4-9d47-a6e842dfa69b	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-01	25.7200	f
01a09b0f-df70-78ef-903b-c7e4bbf48375	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-11	28.0000	f
01a09b0f-df70-7919-8aec-1a71c66e2c2c	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-29	27.5200	f
01a09b0f-df70-792f-88ed-8b06006fb2de	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-03	30.8300	f
01a09b0f-df70-7934-a8ad-4542e429eb4d	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-07	24.9000	f
01a09b0f-df70-7957-bbe2-a860a65a6583	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-19	26.3700	f
01a09b0f-df70-796c-bb13-d5c0155343e7	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-30	27.0500	f
01a09b0f-df70-797c-b7b4-16f6d13cb6fb	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-15	29.9900	f
01a09b0f-df70-7983-bce5-9d988041a740	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-05	25.7800	f
01a09b0f-df70-7984-8287-2cf49868ec13	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-07	28.8000	f
01a09b0f-df70-7985-a714-b5e8e38d0485	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-17	30.4300	f
01a09b0f-df70-7993-b442-5b8d80431d26	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-23	24.7600	f
01a09b0f-df70-79cb-a4ce-d42b538a49e0	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-24	33.4900	f
01a09b0f-df70-79d7-9c2b-f4e7f66b126b	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-27	25.0500	f
01a09b0f-df70-79e7-87a9-0a0c581833ed	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-02	26.2100	f
01a09b0f-df70-79eb-aa63-d075860dbf41	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-19	34.0800	f
01a09b0f-df70-79f3-b2be-1670572a6f5e	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-16	25.0400	f
01a09b0f-df70-79fb-a17a-0d712463b053	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-04	35.2400	f
01a09b0f-df70-7a1a-8451-88facd058549	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-20	36.0200	f
01a09b0f-df70-7a99-b466-16f477e65d41	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-02	28.1000	f
01a09b0f-df70-7a9b-b261-805a8cb39afc	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-07	27.1000	f
01a09b0f-df70-7aa0-9a6c-53e650aac17e	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-02	32.2000	f
01a09b0f-df70-7ab0-9fef-536658de1613	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-03	36.8800	f
01a09b0f-df70-7abc-8509-770148ae3c2b	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-28	26.4000	f
01a09b0f-df70-7ac0-885b-e4d8f3dbe570	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-24	25.9800	f
01a09b0f-df70-7ad9-b051-2588981eeee9	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-12	27.3100	f
01a09b0f-df70-7aed-915b-4d17cfaf51a2	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-26	27.9800	f
01a09b0f-df70-7af1-b560-1320bc1a7464	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-27	26.2000	f
01a09b0f-df70-7af2-acab-63df8ad8c8b7	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-01	31.4200	f
01a09b0f-df70-7afb-a6dc-062f121d4b51	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-05	30.4300	f
01a09b0f-df70-7b12-9781-5e8ae4595cd4	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-23	27.2700	f
01a09b0f-df70-7b1e-987f-da1ce2a83058	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-08	26.9000	f
01a09b0f-df70-7b2e-906e-dc57e211e5c6	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-03	27.3700	f
01a09b0f-df70-7b57-96e7-737dfc1bfeff	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-30	25.8500	f
01a09b0f-df70-7b57-a3be-5cdd8cf2e820	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-25	25.4100	f
01a09b0f-df70-7b5c-b71e-f2147c1f9cf7	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-23	27.3700	f
01a09b0f-df70-7b74-9bd2-9446bead6a60	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-14	30.6000	f
01a09b0f-df70-7b74-b37d-85de2b28606b	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-24	27.4300	f
01a09b0f-df70-7b93-b0bb-31ec571299a7	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-13	30.7200	f
01a09b0f-df70-7b95-972f-6541611dfdab	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-26	26.5700	f
01a09b0f-df70-7b9b-b2c8-ec0fb0dab5c0	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-18	32.9700	f
01a09b0f-df70-7b9c-8fe0-4b141d93aaf3	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-14	33.8000	f
01a09b0f-df70-7ba7-8995-5642b935473a	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-26	24.5600	f
01a09b0f-df70-7bc2-bd36-828af4faca04	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-21	26.7200	f
01a09b0f-df70-7bc9-92a7-a9f23e67137a	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-06	28.3600	f
01a09b0f-df70-7bca-9cc8-f5f95f9d8387	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-04	31.7000	f
01a09b0f-df70-7bcd-b658-06ab81ffdc0f	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-29	25.2800	f
01a09b0f-df70-7be2-ac6c-f22637cebe5f	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-12	31.8900	f
01a09b0f-df70-7bef-9c9b-db4039302a73	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-09	30.8200	f
01a09b0f-df70-7c42-9f41-98aa281bbdbc	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-22	30.4500	f
01a09b0f-df70-7c6c-ab64-6d3a743ffe71	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-09	28.2000	f
01a09b0f-df70-7c7a-b46c-62299c26f4df	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-24	27.3100	f
01a09b0f-df70-7c82-9d83-9d712add7832	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-27	35.3800	f
01a09b0f-df70-7c83-b640-f805729e4748	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-20	28.3900	f
01a09b0f-df70-7c9b-a300-ec31fe848265	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-24	26.4400	f
01a09b0f-df70-7ca0-bd38-1fb1fa1cd2a8	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-08	23.8400	f
01a09b0f-df70-7cca-a3a7-4f65b62e814c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-06	27.0700	f
01a09b0f-df70-7cd5-8cbb-51406f68fa9c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-28	36.1000	f
01a09b0f-df70-7ce0-9cd9-8544a07fdc49	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-25	34.3700	f
01a09b0f-df70-7d09-802b-1acaf414fd9c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-20	23.5900	f
01a09b0f-df70-7d1e-8abb-7f72cf74da35	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-21	26.8700	f
01a09b0f-df70-7d29-a772-c1cc5b142d96	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-27	28.1800	f
01a09b0f-df70-7d43-8d9a-ebf26b20084a	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-31	26.9100	f
01a09b0f-df70-7d4a-ad3f-15297ebd75f5	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-18	25.5300	f
01a09b0f-df70-7d70-ad36-c07047e2d2c2	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-18	24.9300	f
01a09b0f-df70-7db1-b5fc-4c41f54fbc8e	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-04	30.7600	f
01a09b0f-df70-7db4-83b0-17ee58213c65	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-29	30.4400	f
01a09b0f-df70-7db4-afbb-3379d46a9c58	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-16	29.5200	f
01a09b0f-df70-7dbd-8995-a739c81ab826	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-08	30.2900	f
01a09b0f-df70-7de8-8a9c-0168000fc20c	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-15	27.2600	f
01a09b0f-df70-7df9-93ba-a65375d48dc1	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-18	26.7200	f
01a09b0f-df70-7dfe-9c99-e1557d3f01df	01a09aec-feb5-712e-8c48-b883fdca364a	2026-07-15	25.3500	f
01a09b0f-df70-7e23-9e0b-486be8ad17ab	01a09aec-feb5-712e-8c48-b883fdca364a	2026-02-27	34.1800	f
01a09b0f-df70-7e4b-9ba2-d29f401cfd49	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-22	30.9300	f
01a09b0f-df70-7ec2-9be2-0c9b679614b9	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-10	36.5400	f
01a09b0f-df70-7ed6-beb8-763ad180fcc4	01a09aec-feb5-712e-8c48-b883fdca364a	2026-03-06	27.7600	f
01a09b0f-df70-7ef0-938c-e20b50e22bcb	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-29	25.9500	f
01a09b0f-df70-7f0b-9139-700b99138586	01a09aec-feb5-712e-8c48-b883fdca364a	2026-05-26	28.8500	f
01a09b0f-df70-7f0c-8268-84778522de76	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-09	26.2600	f
01a09b0f-df70-7f56-8860-b42faea2f5f2	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-21	31.1400	f
01a09b0f-df70-7f85-8d10-493174cad679	01a09aec-feb5-712e-8c48-b883fdca364a	2026-01-02	29.0500	f
01a09b0f-df70-7fa1-8e3a-8b41e345f8bd	01a09aec-feb5-712e-8c48-b883fdca364a	2026-04-22	27.6500	f
01a09b0f-df70-7ff1-81fc-ab409a15324f	01a09aec-feb5-712e-8c48-b883fdca364a	2025-12-19	26.1900	f
01a09b0f-df70-7ff8-a987-c0bf3928e0a9	01a09aec-feb5-712e-8c48-b883fdca364a	2026-06-30	26.7500	f
01a09b0f-df71-71f4-bb69-54c4bfdc82fc	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-25	40.4000	f
01a09b0f-df71-7583-9104-f3d8cdaeaac0	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-11	35.4700	f
01a09b0f-df71-779d-9d76-e87eacb85a44	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-27	39.8200	f
01a09b0f-df71-77c8-ab43-f7450631cb60	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-04	34.9000	f
01a09b0f-df71-7868-9c42-edead5195e78	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-03	35.3200	f
01a09b0f-df71-78ba-8bf5-f83289114568	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-09	38.2500	f
01a09b0f-df71-78d5-999c-bd2886810fd6	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-26	39.2400	f
01a09b0f-df71-7a61-bdb1-afe2f431016a	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-31	37.1300	f
01a09b0f-df71-7a8b-aede-1f505ec79d69	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-10	34.9800	f
01a09b0f-df71-7af9-b361-14273e2b8788	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-08	37.9100	f
01a09b0f-df71-7b51-9a17-d41e855cc1fa	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-01	34.8200	f
01a09b0f-df71-7eef-982a-974a4de4d746	01a09aec-feb5-712e-8c48-b883fdca364a	2026-09-02	34.7600	f
01a09b0f-df71-7f76-b510-ff70f51703f9	01a09aec-feb5-712e-8c48-b883fdca364a	2026-08-28	38.8300	f
01a09b0f-e002-724f-a2fe-5f56353e526a	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-30	148.1600	f
01a09b0f-e002-74b7-8fec-39e3cfc997cb	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-15	191.5500	f
01a09b0f-e002-7660-923c-ab0463584af1	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-26	135.6900	f
01a09b0f-e002-76fd-8f9a-119db8ece483	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-22	171.2300	f
01a09b0f-e002-77c6-889a-02220ef5d88a	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-02	120.9500	f
01a09b0f-e002-790f-bf11-3c96bca0043b	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-29	150.1000	f
01a09b0f-e002-7966-b8b7-83fd97994554	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-24	146.9700	f
01a09b0f-e002-7969-b895-bb1c002ee29d	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-01	139.0000	f
01a09b0f-e002-799e-ac5e-2ea172059080	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-16	170.8100	f
01a09b0f-e002-79ea-bf1b-babf89aaa782	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-23	147.4400	f
01a09b0f-e002-7b3d-a471-d108cbdf9480	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-17	167.3400	f
01a09b0f-e002-7b8f-86f3-b96af0749e96	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-25	138.5400	f
01a09b0f-e002-7bb5-ad48-6baa9e46a707	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-06-18	161.8500	f
01a09b0f-e003-7003-adb5-3f6715baedf2	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-31	107.6900	f
01a09b0f-e003-708a-8d78-1cfc841e791e	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-21	119.2600	f
01a09b0f-e003-70e4-98de-828a382b0f2c	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-12	138.0800	f
01a09b0f-e003-70ec-b361-3a60b2b2df18	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-23	112.0200	f
01a09b0f-e003-7142-bfc4-f5d6cec60d71	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-13	111.8800	f
01a09b0f-e003-7215-83fb-de315dc3b271	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-06	123.3600	f
01a09b0f-e003-73d9-b78a-b1bd3c599a09	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-19	122.1900	f
01a09b0f-e003-73f0-b9b8-bcc549fe54e6	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-06	124.2200	f
01a09b0f-e003-743b-961b-bd5368f702ab	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-07	135.6300	f
01a09b0f-e003-74a7-bec4-4a2bd475f96d	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-10	103.2900	f
01a09b0f-e003-7659-864d-72ef2a7a73c4	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-07	114.4100	f
01a09b0f-e003-7664-af10-ac12b72882c4	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-04	105.5300	f
01a09b0f-e003-7675-a41a-5b88b0922077	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-27	113.2800	f
01a09b0f-e003-7695-999e-161f1fb56e02	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-11	105.3600	f
01a09b0f-e003-76a5-9e8a-02f99b328a34	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-10	119.9200	f
01a09b0f-e003-76c9-81b7-3b63727cbdd9	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-09	107.9300	f
01a09b0f-e003-775c-803e-73a720303d17	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-11	134.3300	f
01a09b0f-e003-777a-9cfe-c25fef0be234	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-14	125.4500	f
01a09b0f-e003-7846-871d-37ab57fb20a6	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-30	90.1100	f
01a09b0f-e003-78ac-a001-94be2ec8d8e2	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-15	109.0900	f
01a09b0f-e003-78e2-8cba-d3f4f4283e50	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-09	122.2100	f
01a09b0f-e003-78f6-8cad-cc20dec6e7c2	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-17	102.4100	f
01a09b0f-e003-795d-8594-ea143e91b2e4	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-01	103.3900	f
01a09b0f-e003-798f-a908-ce2d81faa60f	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-13	130.0800	f
01a09b0f-e003-7a0b-a43c-d8657ac751a3	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-08	111.5500	f
01a09b0f-e003-7a13-bcdc-4ffcf0e079d6	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-27	97.8200	f
01a09b0f-e003-7a1e-a10e-0bb16ed68860	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-16	100.2400	f
01a09b0f-e003-7a4e-88da-119da93624db	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-14	150.2800	f
01a09b0f-e003-7a4e-914e-c0cae565e3f8	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-03	100.3800	f
01a09b0f-e003-7ab0-bd2a-d71cd15d7d9b	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-18	131.4100	f
01a09b0f-e003-7b36-8805-e5b5f1cefd5a	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-08	114.4400	f
01a09b0f-e003-7bb5-a0f3-43a3bea45743	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-28	88.1400	f
01a09b0f-e003-7bb8-9c55-2602a7f6f08a	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-20	129.1000	f
01a09b0f-e003-7c27-80e7-f9519861985c	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-24	107.6300	f
01a09b0f-e003-7c58-a3b2-f0667a788f1b	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-24	100.1500	f
01a09b0f-e003-7c78-850c-2a5db4067f84	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-03	110.2100	f
01a09b0f-e003-7c9b-84e0-fff9edc83a73	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-22	110.5200	f
01a09b0f-e003-7caf-9cf5-f2742669b450	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-10	132.8100	f
01a09b0f-e003-7d5d-8dde-69236353b275	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-28	106.2300	f
01a09b0f-e003-7ddf-aa0d-57226adb1c57	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-09-02	103.1300	f
01a09b0f-e003-7de7-be49-4a6fa1deb171	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-20	103.0200	f
01a09b0f-e003-7deb-9868-9e83844c145d	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-21	124.8200	f
01a09b0f-e003-7e36-bf8f-583cb472f526	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-29	76.5200	f
01a09b0f-e003-7e9f-9a89-c6902a36288b	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-17	154.8900	f
01a09b0f-e003-7f37-b057-2a23beea2071	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-25	113.1500	f
01a09b0f-e003-7f70-8db4-2b745b8e4439	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-05	128.5600	f
01a09b0f-e003-7f7e-a009-47e979eb0fde	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-04	131.6300	f
01a09b0f-e003-7fcb-9275-b161d464f17a	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-08-26	113.7600	f
01a09b0f-e003-7ff4-8572-16b23de6d2fe	01a09aec-feb5-75c7-8b48-c12503e310cb	2026-07-31	94.3200	f
01a09b0f-e095-707f-a9e8-9ddfe341423d	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-22	237.3000	f
01a09b0f-e095-708b-8960-34785a8c9101	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-17	249.3800	f
01a09b0f-e095-70b9-a44e-f5037a647f0c	01a09aec-feb5-75ff-a369-a322f5890621	2025-08-29	182.2000	f
01a09b0f-e095-70dc-9161-94ef64bcf613	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-18	251.8800	f
01a09b0f-e095-726d-9475-4836a79f4527	01a09aec-feb5-75ff-a369-a322f5890621	2025-08-27	179.2000	f
01a09b0f-e095-73b7-ab4d-0bb8201529a4	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-19	245.2000	f
01a09b0f-e095-7450-8110-b717b67fbc17	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-12	229.5000	f
01a09b0f-e095-7455-83cc-2d3263d9e6c3	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-15	231.2900	f
01a09b0f-e095-75b0-89d3-a00f7502e26a	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-08	216.1000	f
01a09b0f-e095-7603-913b-1bd0b7cc3540	01a09aec-feb5-75ff-a369-a322f5890621	2025-08-25	174.1500	f
01a09b0f-e095-7618-9606-84332e8055f3	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-11	232.9000	f
01a09b0f-e095-7832-86ce-5d3d0efcb395	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-10	230.3700	f
01a09b0f-e095-786d-a16d-1715dc9d1341	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-02	174.2400	f
01a09b0f-e095-7998-8874-9272e44953d5	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-09	214.4900	f
01a09b0f-e095-79b2-af21-03029653d07d	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-03	176.6100	f
01a09b0f-e095-79fd-bec6-c4707d28a1e9	01a09aec-feb5-75ff-a369-a322f5890621	2025-08-22	179.0900	f
01a09b0f-e095-7b9f-b8b7-d9da0b309f81	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-16	238.7900	f
01a09b0f-e095-7d31-be75-6dd37b9f4bc1	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-04	187.9500	f
01a09b0f-e095-7e01-94a6-dd4c158d4a46	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-05	191.2000	f
01a09b0f-e095-7e05-969e-6c7f2ef54c4e	01a09aec-feb5-75ff-a369-a322f5890621	2025-08-26	178.5600	f
01a09b0f-e095-7fe8-a26e-cdf4b1eb14ac	01a09aec-feb5-75ff-a369-a322f5890621	2025-08-28	189.1500	f
01a09b0f-e096-7046-b322-b34eedfa5ea3	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-10	173.7400	f
01a09b0f-e096-70b5-a5f8-c1297e43654f	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-13	144.4700	f
01a09b0f-e096-70cd-a1b5-82b04e9c539d	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-03	191.5600	f
01a09b0f-e096-70f9-940c-2fcf0e8ae90e	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-29	170.1050	f
01a09b0f-e096-7128-90b3-bd839553f5a2	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-04	152.5100	f
01a09b0f-e096-7149-bd09-9ae39e4919e5	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-03	200.7400	f
01a09b0f-e096-716d-a1ce-998a53520263	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-05	161.2300	f
01a09b0f-e096-71b8-8cfb-25e1b176c38f	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-17	141.3900	f
01a09b0f-e096-71bf-90b5-7ea067f9d6f0	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-05	167.1100	f
01a09b0f-e096-720e-9fc1-be1acc79aac5	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-05	181.9400	f
01a09b0f-e096-7219-9d95-2f8c6bb62131	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-21	176.0050	f
01a09b0f-e096-7299-8b60-abd326f34a7e	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-11	167.5500	f
01a09b0f-e096-72a6-ab63-f8066dc4015c	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-09	162.6100	f
01a09b0f-e096-72af-8d4a-27effd376d73	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-06	161.0100	f
01a09b0f-e096-72c8-8f38-bb331a43358d	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-30	195.8000	f
01a09b0f-e096-7314-b17a-0d509ddd0a22	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-17	159.8000	f
01a09b0f-e096-733a-9864-a265ef50af4a	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-22	172.6200	f
01a09b0f-e096-7350-9ded-0801efeabf92	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-22	154.8500	f
01a09b0f-e096-7352-a6b1-84c132297180	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-26	197.7800	f
01a09b0f-e096-7355-a14e-ca65df8d4d3e	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-07	165.4900	f
01a09b0f-e096-7356-8c47-c20337b1ed34	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-08	219.3600	f
01a09b0f-e096-7363-8c5a-5798bedb5e6c	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-14	144.3400	f
01a09b0f-e096-7370-8393-491898a59b32	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-02	209.6000	f
01a09b0f-e096-7408-95a8-d9c0e1b0f41a	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-02	142.9400	f
01a09b0f-e096-7425-9f2d-9b75c3e4785a	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-18	139.5200	f
01a09b0f-e096-748f-837b-d8c191c7023e	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-11	173.7000	f
01a09b0f-e096-74a4-bd38-2cd1938cb78c	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-06	162.8300	f
01a09b0f-e096-756b-b33e-cad69ac65b65	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-02	179.5600	f
01a09b0f-e096-7581-a5ca-f904a0115c60	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-12	172.5700	f
01a09b0f-e096-75b3-9dea-7272ca3639ba	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-24	164.9700	f
01a09b0f-e096-75e3-8076-bab51a56428f	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-08	175.7400	f
01a09b0f-e096-760a-8578-d261cdb20bd0	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-16	163.5500	f
01a09b0f-e096-7687-9445-1bbd02606828	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-01	194.5000	f
01a09b0f-e096-76ab-be72-e4613e276188	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-29	173.6200	f
01a09b0f-e096-76af-94f8-d37f2eab1d16	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-10	164.3150	f
01a09b0f-e096-76e0-ac84-b0c3240c785b	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-21	157.5100	f
01a09b0f-e096-76ff-acdc-340617f5c1c4	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-19	164.4000	f
01a09b0f-e096-776e-9519-e5fd19a01ae9	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-09	225.4300	f
01a09b0f-e096-7785-9d23-ac456f3a4b8f	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-26	154.2200	f
01a09b0f-e096-77b4-80f3-8bcd0bddaf16	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-13	180.5600	f
01a09b0f-e096-77d5-984c-d10f306d226a	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-12	157.7900	f
01a09b0f-e096-784e-9d01-ca1d6c1b99eb	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-20	156.3100	f
01a09b0f-e096-7868-bb7e-bac78d8faece	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-24	169.9700	f
01a09b0f-e096-788b-85b8-781ed7bfbfb5	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-06	220.8100	f
01a09b0f-e096-78c1-ac6f-eda0dadc0726	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-13	199.5300	f
01a09b0f-e096-78d7-b58c-4df545e6f592	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-25	144.7800	f
01a09b0f-e096-7933-958e-d1b9827775b3	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-23	230.1100	f
01a09b0f-e096-794c-aab4-ec746251d270	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-31	166.3600	f
01a09b0f-e096-7965-a791-c16a16ebff3d	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-26	167.2600	f
01a09b0f-e096-7999-99a9-3c6a861f0330	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-31	186.6800	f
01a09b0f-e096-79bb-9782-3710727ce815	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-15	161.4650	f
01a09b0f-e096-79be-913f-b0486f5ae866	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-20	183.7500	f
01a09b0f-e096-79fa-99de-364a0e069ba4	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-25	200.6400	f
01a09b0f-e096-7a32-be78-9c914e2f5391	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-03	152.5000	f
01a09b0f-e096-7a62-8b10-2161e51c5a4d	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-22	176.3500	f
01a09b0f-e096-7a63-ba3f-2efafd1ef9aa	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-21	141.8000	f
01a09b0f-e096-7a78-a6e6-4339a18fccd2	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-17	140.2400	f
01a09b0f-e096-7a90-964e-1ff66f22eb7a	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-24	205.2700	f
01a09b0f-e096-7ad3-aaf4-44509e88da11	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-30	170.8400	f
01a09b0f-e096-7af2-92ad-289a316f0e2d	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-09	167.0800	f
01a09b0f-e096-7af5-b2ef-ad1167b29755	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-14	161.5500	f
01a09b0f-e096-7b59-98d4-a82b517d3d88	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-07	212.1000	f
01a09b0f-e096-7c0a-8335-c424838fd271	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-04	179.3100	f
01a09b0f-e096-7c1e-84b0-c2166cf80ab1	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-18	145.8800	f
01a09b0f-e096-7c3b-8e9a-674187d316e9	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-23	168.8300	f
01a09b0f-e096-7c3c-9cb0-f10cbe616c99	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-30	169.5500	f
01a09b0f-e096-7c66-a7f3-d6a6aca3e3b8	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-14	172.1400	f
01a09b0f-e096-7c74-8817-30ac6f19491e	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-24	147.7500	f
01a09b0f-e096-7ca2-9024-eccaad9a3edc	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-28	157.5700	f
01a09b0f-e096-7cbd-8b5a-32f3a11f824c	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-27	170.2800	f
01a09b0f-e096-7cc4-ac7c-8b0e330d2e31	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-16	182.0000	f
01a09b0f-e096-7d43-8df3-df0c8bf0d114	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-10	206.2100	f
01a09b0f-e096-7d67-a65d-e6da6fb5d6dd	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-28	168.2500	f
01a09b0f-e096-7df4-bba4-95d0c6467143	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-12	148.8500	f
01a09b0f-e096-7e71-847b-07810e212058	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-16	144.9400	f
01a09b0f-e096-7e8f-8dca-0aee2057acfe	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-08	156.7300	f
01a09b0f-e096-7eb5-85e0-74f32d075a7d	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-19	142.0100	f
01a09b0f-e096-7f0f-90a8-a0b9be24b83d	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-15	174.4500	f
01a09b0f-e096-7f3b-ae82-eccc8ba6294a	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-15	143.6600	f
01a09b0f-e096-7f58-868d-bcd9eda80551	01a09aec-feb5-75ff-a369-a322f5890621	2025-12-01	165.1900	f
01a09b0f-e096-7f68-8ba8-eda14a21b0c8	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-07	165.7700	f
01a09b0f-e096-7fc5-99da-b5492f0c6ce6	01a09aec-feb5-75ff-a369-a322f5890621	2025-10-23	163.6400	f
01a09b0f-e096-7fc6-9fbf-3a60e49c6105	01a09aec-feb5-75ff-a369-a322f5890621	2025-09-29	198.8000	f
01a09b0f-e096-7fe1-8e2f-100bba27ed26	01a09aec-feb5-75ff-a369-a322f5890621	2025-11-20	139.2900	f
01a09b0f-e097-7045-8e68-6e5be46f5d89	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-16	170.8100	f
01a09b0f-e097-704c-a6f1-15b1f07ed8e2	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-18	126.3400	f
01a09b0f-e097-7124-b97e-57522fb29738	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-14	170.6000	f
01a09b0f-e097-71d6-bfab-7810ff1dd6ea	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-27	196.6400	f
01a09b0f-e097-726e-9735-5a0f03256cc2	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-26	163.2500	f
01a09b0f-e097-7271-ace5-8bacd5af6a0f	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-02	120.5500	f
01a09b0f-e097-727a-b460-f9badbd5319a	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-30	100.2700	f
01a09b0f-e097-727b-a31f-6907e08ff279	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-18	129.5800	f
01a09b0f-e097-7295-9bc2-d3914275006f	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-06	117.9900	f
01a09b0f-e097-72c6-8584-e5dcac50e70a	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-28	183.3100	f
01a09b0f-e097-72e3-9e50-644cf1ee7ed0	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-17	174.0500	f
01a09b0f-e097-7325-9049-2dae483028e8	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-30	194.7400	f
01a09b0f-e097-7368-ac35-7c2e9da08371	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-02	152.4400	f
01a09b0f-e097-7368-b1db-ee98c345ff58	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-03	109.8000	f
01a09b0f-e097-7384-91f6-265b1fa336f0	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-26	113.6050	f
01a09b0f-e097-7397-b416-c0f56d79e1bf	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-10	149.0500	f
01a09b0f-e097-740b-b73c-d55df1db18be	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-12	119.9000	f
01a09b0f-e097-7417-8d11-ed9579e1e590	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-09	129.4600	f
01a09b0f-e097-7473-9902-d3ace35b77ba	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-23	197.5400	f
01a09b0f-e097-747d-849d-3aff205d9cf2	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-27	170.9300	f
01a09b0f-e097-7497-af54-8d595c39ce50	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-22	194.0600	f
01a09b0f-e097-74aa-8e88-8d50a707c5f1	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-23	128.2400	f
01a09b0f-e097-74cc-ba7e-9e0bfd617035	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-25	120.3300	f
01a09b0f-e097-74e2-9d6e-785269f5202c	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-01	202.6800	f
01a09b0f-e097-74f1-a282-6fceae5451c8	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-29	196.8500	f
01a09b0f-e097-7566-851d-6bf528641e87	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-13	166.7950	f
01a09b0f-e097-7587-ac3e-4a39de410731	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-30	150.6200	f
01a09b0f-e097-7593-bed2-b5849e28ed92	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-13	120.3100	f
01a09b0f-e097-760c-9e35-df6e52fd8e36	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-06	169.8500	f
01a09b0f-e097-7661-a2b9-103a326682d7	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-05	142.8200	f
01a09b0f-e097-76aa-84a9-d89f3c6f9911	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-21	191.9700	f
01a09b0f-e097-7773-90ba-fda2515a48d9	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-20	129.6800	f
01a09b0f-e097-779e-8332-2db5c614847d	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-16	127.4800	f
01a09b0f-e097-78c3-9590-024671b1162c	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-03	158.5200	f
01a09b0f-e097-78fd-98cf-5162b4150118	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-07	118.9900	f
01a09b0f-e097-7902-980b-bd77230b81ba	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-17	127.5700	f
01a09b0f-e097-7929-80a1-775e208bd05b	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-20	175.8000	f
01a09b0f-e097-7944-b0a1-d19625087202	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-27	118.8300	f
01a09b0f-e097-7950-85ff-638579b43ab7	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-19	132.6200	f
01a09b0f-e097-7952-aa23-1977323362cd	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-13	129.3200	f
01a09b0f-e097-79b7-abc0-f4c91acc93e4	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-05	120.0000	f
01a09b0f-e097-7a8a-87f8-64a979ac8470	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-01	106.3300	f
01a09b0f-e097-7b03-93e5-e23876e0761f	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-31	109.6000	f
01a09b0f-e097-7b7d-9710-d29ad8841948	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-10	182.8600	f
01a09b0f-e097-7b84-bf15-6568b6425838	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-11	143.7100	f
01a09b0f-e097-7c04-bf70-3531f9358bfc	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-08	125.4600	f
01a09b0f-e097-7c73-b46f-52188d46a952	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-09	187.6700	f
01a09b0f-e097-7ca7-9500-537d5d36297c	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-25	128.1500	f
01a09b0f-e097-7cab-b0c0-1dcd9c92a920	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-24	121.7600	f
01a09b0f-e097-7cdd-9183-096b6cdf9866	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-23	123.8700	f
01a09b0f-e097-7d01-bdc3-f59aa807264d	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-17	123.6900	f
01a09b0f-e097-7d2c-ae28-adfa24f5a87a	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-04	144.6700	f
01a09b0f-e097-7d48-b785-2f9a4c7253fb	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-27	112.4700	f
01a09b0f-e097-7d4a-a533-ceb266873ef7	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-24	128.4000	f
01a09b0f-e097-7d4d-8a3b-d3068f6abc3e	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-11	124.7100	f
01a09b0f-e097-7d7e-b64f-e88014784336	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-15	172.0900	f
01a09b0f-e097-7d8b-bc76-6df1b497159b	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-02	117.1400	f
01a09b0f-e097-7db3-97bb-de97d62588f8	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-28	167.9000	f
01a09b0f-e097-7dd8-aefb-a45aeb7eec2b	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-06	119.2000	f
01a09b0f-e097-7df9-aed0-e421704bbfc2	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-19	126.1600	f
01a09b0f-e097-7e07-9d90-e7c124944e27	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-12	126.5800	f
01a09b0f-e097-7ea5-80f9-31c8e0d7ccb0	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-09	122.3100	f
01a09b0f-e097-7eda-9a16-49a287e3b73d	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-23	169.6600	f
01a09b0f-e097-7f02-ac3f-fd523a2ba2cb	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-10	116.4800	f
01a09b0f-e097-7f74-a5af-1e2c456aa0f6	01a09aec-feb5-75ff-a369-a322f5890621	2026-04-24	212.8400	f
01a09b0f-e097-7f8c-94c2-929a561e257a	01a09aec-feb5-75ff-a369-a322f5890621	2026-01-29	160.4600	f
01a09b0f-e097-7fce-886f-577e59f227e5	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-04	113.7700	f
01a09b0f-e097-7fdb-8552-1cb2589c355d	01a09aec-feb5-75ff-a369-a322f5890621	2026-03-20	116.0400	f
01a09b0f-e097-7ff9-9c5e-4f22f7bcc933	01a09aec-feb5-75ff-a369-a322f5890621	2026-02-26	124.6700	f
01a09b0f-e098-708f-9778-55f93a2cf1ee	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-06	432.7400	f
01a09b0f-e098-70ab-a206-e734c4ad677a	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-08	199.7900	f
01a09b0f-e098-70c1-9dc3-a8e5ca71b3d5	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-12	367.1500	f
01a09b0f-e098-70c9-a566-eb7325642e48	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-02	355.7600	f
01a09b0f-e098-70df-92a6-073506d4c77e	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-15	232.6800	f
01a09b0f-e098-70ec-94fe-6c6e92e0b8ff	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-29	249.7400	f
01a09b0f-e098-7122-8a32-90a8d8823707	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-26	391.7400	f
01a09b0f-e098-71c5-b5f5-19b4e961ca07	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-22	330.8950	f
01a09b0f-e098-71c6-91ed-32110dffabb0	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-05	215.6900	f
01a09b0f-e098-71d7-a453-15535e04a630	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-27	325.3300	f
01a09b0f-e098-71fd-a75f-25e232e4911a	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-10	330.8600	f
01a09b0f-e098-7230-a276-8df036c46f91	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-18	215.5800	f
01a09b0f-e098-7230-b5c4-8861642d8390	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-24	291.5800	f
01a09b0f-e098-7237-8607-c154faff18b0	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-02	406.4200	f
01a09b0f-e098-7242-9df3-7812762d3e94	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-19	244.2600	f
01a09b0f-e098-7340-908d-4d9655652fc6	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-16	361.7100	f
01a09b0f-e098-736b-b079-ce27242015a1	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-23	397.0200	f
01a09b0f-e098-73b6-8076-b8b95e1a6d81	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-07	195.6500	f
01a09b0f-e098-73e4-b48a-703dd901834b	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-17	303.6200	f
01a09b0f-e098-7452-baba-0a9997104ad3	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-29	342.8500	f
01a09b0f-e098-7499-991a-7d0cda7f637f	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-29	455.9600	f
01a09b0f-e098-7505-824f-b8de4b5cfbdf	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-28	260.2300	f
01a09b0f-e098-755f-9cfa-caca3483fcf1	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-24	399.9200	f
01a09b0f-e098-75bf-9bc7-5e9378f75b31	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-14	361.7800	f
01a09b0f-e098-75cc-a406-393a6b28f46a	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-01	430.8600	f
01a09b0f-e098-76ef-a1a6-5a2fd61eabe2	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-07	382.8900	f
01a09b0f-e098-770e-994f-e84302abd990	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-20	287.4800	f
01a09b0f-e098-773a-9938-a15506024508	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-04	201.2500	f
01a09b0f-e098-7805-a633-b8d201380099	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-01	320.0900	f
01a09b0f-e098-7811-bf3d-fb08586fcb61	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-15	389.2000	f
01a09b0f-e098-7828-9a26-e8204a1a80d3	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-27	282.5200	f
01a09b0f-e098-7848-9cfb-ef0a12e99112	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-10	412.9700	f
01a09b0f-e098-786b-81e0-4448676441ef	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-03	363.5400	f
01a09b0f-e098-789e-b966-c92304246114	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-22	439.6600	f
01a09b0f-e098-792e-bd63-2c3477a4b93b	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-21	297.8400	f
01a09b0f-e098-7935-aaee-8eb9682374a4	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-18	417.0700	f
01a09b0f-e098-79c4-b55b-14fba4cc0e3a	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-08	346.3300	f
01a09b0f-e098-7a04-a742-2c760cea05d4	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-09	417.4500	f
01a09b0f-e098-7a5f-882c-e72e348a46de	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-11	367.4700	f
01a09b0f-e098-7a83-ab73-0e055448fc49	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-08	393.1600	f
01a09b0f-e098-7a88-99d9-c96ead47c9b0	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-28	349.1700	f
01a09b0f-e098-7ac4-b8be-91c9e3b60a64	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-13	362.0500	f
01a09b0f-e098-7b13-adc3-c166a76bf56d	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-15	350.6200	f
01a09b0f-e098-7b4e-aa37-bfd4b5482296	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-30	483.0200	f
01a09b0f-e098-7c3b-9757-1deda9826706	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-25	398.0000	f
01a09b0f-e098-7c50-8b50-81f6a01c573e	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-16	319.7400	f
01a09b0f-e098-7c65-9041-05db84776453	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-21	319.7900	f
01a09b0f-e098-7c80-b002-ea90547885e5	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-13	224.0900	f
01a09b0f-e098-7cb7-be21-fb134422f694	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-14	228.6400	f
01a09b0f-e098-7cce-abf9-bae171927d9b	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-22	306.8800	f
01a09b0f-e098-7d4e-8d47-e265b5b3cc48	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-20	309.0900	f
01a09b0f-e098-7d51-9f4f-12271807963d	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-26	318.7200	f
01a09b0f-e098-7d70-b733-572d525fab7a	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-30	299.6900	f
01a09b0f-e098-7d94-925d-9f6330b8fc61	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-23	326.9700	f
01a09b0f-e098-7dc2-b385-73edc6db0d9e	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-11	207.3500	f
01a09b0f-e098-7dd6-bbfd-d7f15b35f1cf	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-05	317.0600	f
01a09b0f-e098-7e79-bf25-b8ca77d8868e	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-09	341.7000	f
01a09b0f-e098-7e88-9d95-05415f141338	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-17	374.6800	f
01a09b0f-e098-7e98-a019-8a347d41ba52	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-06	213.9100	f
01a09b0f-e098-7f50-aa84-d8b32312edc6	01a09aec-feb5-75ff-a369-a322f5890621	2026-06-04	358.0500	f
01a09b0f-e098-7fa4-adac-5444064127e5	01a09aec-feb5-75ff-a369-a322f5890621	2026-05-12	204.4200	f
01a09b0f-e099-7060-9913-31cd520ee828	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-26	290.3000	f
01a09b0f-e099-706c-9a78-3e4903299928	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-06	331.5000	f
01a09b0f-e099-716d-8b46-8d94c002dc4a	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-25	282.6500	f
01a09b0f-e099-717c-a021-c51fabd9c008	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-07	334.1700	f
01a09b0f-e099-722d-98cb-3f0723ab77bd	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-13	322.7800	f
01a09b0f-e099-73f0-acce-6a53486c9efc	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-10	317.2300	f
01a09b0f-e099-7557-bde8-4c4469159ac0	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-08	288.8500	f
01a09b0f-e099-75f4-ba89-6f95278dec44	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-09	300.5400	f
01a09b0f-e099-75ff-baaa-acd4e119f646	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-04	361.6700	f
01a09b0f-e099-7622-87be-020f41390edf	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-05	318.4300	f
01a09b0f-e099-76da-8817-c7c627a24edb	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-14	321.6100	f
01a09b0f-e099-7723-8d36-f3397b439986	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-11	291.2200	f
01a09b0f-e099-773d-bde2-688a714e4ec9	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-20	290.5200	f
01a09b0f-e099-7864-8796-079d2796955c	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-19	289.0200	f
01a09b0f-e099-791d-8876-1ebbb331a027	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-27	304.0900	f
01a09b0f-e099-7922-8e76-e61c5d7d4b26	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-12	318.8000	f
01a09b0f-e099-794f-a85e-95a683abd12f	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-04	310.4000	f
01a09b0f-e099-797f-a36e-15929d4f781a	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-28	289.4700	f
01a09b0f-e099-79c8-b3e5-d03ea6ac4c12	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-17	320.1700	f
01a09b0f-e099-79ff-90e3-7d46387fa0cf	01a09aec-feb5-75ff-a369-a322f5890621	2026-07-31	311.2300	f
01a09b0f-e099-7ad8-b94d-13a5fdc6ed3e	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-31	296.9800	f
01a09b0f-e099-7b10-85f5-84d271a82941	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-01	279.9100	f
01a09b0f-e099-7bd4-bc11-55a89ccde6b6	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-03	282.8200	f
01a09b0f-e099-7bff-a108-b15ddff098f4	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-02	274.1300	f
01a09b0f-e099-7c97-a393-cfbc2183fe01	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-11	311.9900	f
01a09b0f-e099-7caf-8c68-6349631ebfd2	01a09aec-feb5-75ff-a369-a322f5890621	2026-09-10	284.5300	f
01a09b0f-e099-7de5-bb3b-f48eadda5b93	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-21	284.9700	f
01a09b0f-e099-7f27-829a-9b82322e5e02	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-18	303.4400	f
01a09b0f-e099-7fab-9504-e20cf16133d6	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-03	321.0500	f
01a09b0f-e099-7fc7-a6ff-e5a88b908e90	01a09aec-feb5-75ff-a369-a322f5890621	2026-08-24	277.5300	f
01a09b0f-e129-7023-960f-68a8fd2ee82b	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-26	38.2500	f
01a09b0f-e129-7040-8bcf-fb65d8920b28	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-07	87.4600	f
01a09b0f-e129-70b4-8259-d884ad0d7813	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-03	36.6800	f
01a09b0f-e129-7182-80ca-64a85069be2a	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-15	82.9800	f
01a09b0f-e129-7182-8ed9-eb4b37aa3dd2	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-29	75.9400	f
01a09b0f-e129-7190-85d6-12d7c73384ac	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-05	43.4800	f
01a09b0f-e129-71cc-84fb-c72ff88aa9ed	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-14	57.2100	f
01a09b0f-e129-71e3-b673-6287ba05cd00	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-07	65.1000	f
01a09b0f-e129-7202-bde0-19fe6b6a1cd2	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-16	81.4900	f
01a09b0f-e129-7209-b665-5ec71facb55b	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-23	73.9000	f
01a09b0f-e129-7233-a572-d52736441994	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-17	79.4400	f
01a09b0f-e129-7341-a8cf-cd10b466ebef	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-14	40.6200	f
01a09b0f-e129-7367-b186-5c660dde83bb	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-09	53.6300	f
01a09b0f-e129-73ae-89dd-4b69b1270f0b	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-15	40.1900	f
01a09b0f-e129-73e2-9cb3-6c44ab65ab8a	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-01	82.3600	f
01a09b0f-e129-73f8-a9c7-df39b7f07804	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-11	60.9700	f
01a09b0f-e129-742e-8293-e8926aec508d	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-21	37.7400	f
01a09b0f-e129-7475-be7a-0e102407f76b	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-24	76.6500	f
01a09b0f-e129-747e-82b2-39bbfba84399	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-20	38.2700	f
01a09b0f-e129-74ac-9869-9759a1dd56fe	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-19	70.5700	f
01a09b0f-e129-750a-b392-6f5e219e3c21	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-12	42.9500	f
01a09b0f-e129-7586-8bba-b5650b1071a5	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-19	55.3900	f
01a09b0f-e129-759c-893c-913094e991a0	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-05	64.6900	f
01a09b0f-e129-75a7-bc9c-765a87e591e6	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-12	62.5600	f
01a09b0f-e129-75a9-9ba2-976761a326cb	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-09	91.7300	f
01a09b0f-e129-7615-a1c9-46092545a17c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-28	39.5100	f
01a09b0f-e129-7639-a16b-94bf694a7e58	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-11	40.0700	f
01a09b0f-e129-763c-8dda-07e0512d6b5c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-04	58.3500	f
01a09b0f-e129-7641-95cd-4f9916cb530a	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-17	66.9500	f
01a09b0f-e129-7667-87e6-2a78339c4023	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-16	65.8900	f
01a09b0f-e129-7702-b7bc-7084a9134845	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-25	55.6800	f
01a09b0f-e129-7703-91b9-b9c7fa91ecb5	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-28	57.4700	f
01a09b0f-e129-7760-9be4-240fcc6b51aa	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-06	87.2700	f
01a09b0f-e129-77e4-b507-7266aecfbb3e	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-18	39.5800	f
01a09b0f-e129-7802-835a-30c7f5349cbb	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-18	69.9100	f
01a09b0f-e129-781e-908f-07898f59e983	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-03	72.4600	f
01a09b0f-e129-7868-9d26-3f91afd14000	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-27	79.3400	f
01a09b0f-e129-78b4-88f5-3b1db04e8664	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-02	37.4400	f
01a09b0f-e129-78bc-8f7f-7fccef4af957	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-02	59.0700	f
01a09b0f-e129-78da-97b8-c211b24f4aba	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-08	93.1900	f
01a09b0f-e129-78fc-8a6a-c1b176a97e7b	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-20	75.8900	f
01a09b0f-e129-7919-89b4-82d194dffc70	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-19	38.5000	f
01a09b0f-e129-7940-a0dd-6b384c91a816	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-01	55.0300	f
01a09b0f-e129-7949-ab83-1dc9e8364bbc	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-03	59.6500	f
01a09b0f-e129-7970-8102-8ba33d6809ed	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-31	74.6100	f
01a09b0f-e129-79a6-b03d-412e1ad27e49	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-27	39.0700	f
01a09b0f-e129-79db-9762-a51f73c790d0	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-06	60.9000	f
01a09b0f-e129-79fc-90af-19d53802bda0	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-20	52.2700	f
01a09b0f-e129-7a62-889b-0c57d904a9cc	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-24	69.4300	f
01a09b0f-e129-7a99-a7bf-55ace102c831	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-13	43.1800	f
01a09b0f-e129-7a9f-b6a7-7adfd395639c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-05	57.7800	f
01a09b0f-e129-7ac8-af3a-3bcc9e0367e8	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-26	70.5200	f
01a09b0f-e129-7acb-af3d-11282de56edf	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-21	77.0300	f
01a09b0f-e129-7add-b7c1-006178c888b9	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-13	56.8000	f
01a09b0f-e129-7af3-b4f3-64ec0fff7000	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-08	47.7200	f
01a09b0f-e129-7b65-9da8-4b77fe837a2e	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-09	55.8000	f
01a09b0f-e129-7b92-805b-9433714b2262	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-23	73.8600	f
01a09b0f-e129-7bc8-8ea6-a4903e3d6bf0	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-10	58.1500	f
01a09b0f-e129-7c08-b944-921500986bd1	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-10	68.5400	f
01a09b0f-e129-7c3f-8cc0-578613d0c148	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-12	61.9500	f
01a09b0f-e129-7c58-8e5a-73a22038e2bc	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-29	37.9800	f
01a09b0f-e129-7c7d-8eef-618fdf63e202	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-04	66.8600	f
01a09b0f-e129-7cb3-ab33-37a6ec1406c2	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-14	75.8300	f
01a09b0f-e129-7cb9-93c3-a64a1b809fe6	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-28	75.4800	f
01a09b0f-e129-7d2d-ae04-5d86c36592b2	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-21	51.4600	f
01a09b0f-e129-7d4e-a648-99bab822212a	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-29	78.7000	f
01a09b0f-e129-7da4-8e46-e7a488d14027	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-08	57.5700	f
01a09b0f-e129-7db0-9df8-4e54d8f7047a	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-22	72.2000	f
01a09b0f-e129-7dce-8079-8d158d6812f5	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-17	56.1700	f
01a09b0f-e129-7dd6-b191-692b4ef8f2a4	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-25	37.8200	f
01a09b0f-e129-7dde-9b60-5db192faee1c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-26	57.3400	f
01a09b0f-e129-7e1a-b9b7-aa02f2a0af6c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-04	41.1000	f
01a09b0f-e129-7e2e-b185-2d0c2e45c1d4	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-11	62.4700	f
01a09b0f-e129-7e34-8b88-6ec0d628ab36	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-18	55.3900	f
01a09b0f-e129-7ec9-a66f-7d4e742d287e	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-10	83.2800	f
01a09b0f-e129-7ee4-a314-7da93c50ec03	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-30	74.6200	f
01a09b0f-e129-7eee-a18c-fea8d28b138b	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-13	81.6800	f
01a09b0f-e129-7f2f-bf52-d5b68fdac13b	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-11-24	56.9300	f
01a09b0f-e129-7f3c-8d66-36d11cb9a166	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-25	68.6200	f
01a09b0f-e129-7f49-91fc-92d565275567	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-22	72.0700	f
01a09b0f-e129-7f67-ad2a-26f2f97cf5b2	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-03	84.1400	f
01a09b0f-e129-7f8c-9e33-d4e55db128b0	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-10	54.8200	f
01a09b0f-e129-7fb0-a0ee-36d1362eef4c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-30	77.0700	f
01a09b0f-e129-7fcb-b42d-d31c8cdcf8b9	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-08-22	38.4800	f
01a09b0f-e129-7fe2-8a6d-29f8cf7e516c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-10-02	87.4100	f
01a09b0f-e129-7ff5-ad6e-8e187090b442	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-09-15	65.6700	f
01a09b0f-e12a-700c-8bde-47a148aeeaa2	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-25	73.1800	f
01a09b0f-e12a-7018-b51b-f09ae5e50cec	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-08	69.0200	f
01a09b0f-e12a-7050-8236-a4c7d81ff907	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-14	41.3200	f
01a09b0f-e12a-7057-bf26-5b257478df5c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-13	62.7000	f
01a09b0f-e12a-7084-b489-57c7eaf6f594	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-16	43.4200	f
01a09b0f-e12a-708c-8704-c5763ca0a390	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-27	89.0000	f
01a09b0f-e12a-7095-8adf-a6de86fbf24f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-02	114.2200	f
01a09b0f-e12a-7099-b522-b2a396a53b4d	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-16	61.5400	f
01a09b0f-e12a-709b-a38f-e5e327d4e2fe	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-29	76.6400	f
01a09b0f-e12a-70a2-ac93-c7394468d673	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-26	73.9000	f
01a09b0f-e12a-70d2-91da-2625c7350c21	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-28	55.8400	f
01a09b0f-e12a-7102-962b-a43c78f48a82	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-19	45.6200	f
01a09b0f-e12a-715e-a531-d021320ce036	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-12	42.7500	f
01a09b0f-e12a-718a-bd14-8e84c5a5006f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-16	44.1800	f
01a09b0f-e12a-71a0-98f1-8ad48ea3fd45	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-09	48.6000	f
01a09b0f-e12a-71e5-b535-c70ee8b5991a	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-25	43.6700	f
01a09b0f-e12a-71e6-b02d-86fc85ddbced	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-24	42.3400	f
01a09b0f-e12a-71e9-865e-63318ab45a84	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-09	98.7700	f
01a09b0f-e12a-71fb-ac13-1860bb3e5064	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-31	50.9500	f
01a09b0f-e12a-7226-a879-8bf75eebbd27	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-04	45.7200	f
01a09b0f-e12a-727b-b87e-0a11b9d593ec	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-30	51.6800	f
01a09b0f-e12a-7282-b332-eed23dc009ee	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-17	48.1500	f
01a09b0f-e12a-7286-a7fb-c0c02313449e	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-10	67.8000	f
01a09b0f-e12a-72a2-b922-615efcb201cc	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-16	60.9700	f
01a09b0f-e12a-72b3-8db8-e046e7cbbc55	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-02	55.1800	f
01a09b0f-e12a-734f-8d9a-a449241c5f5e	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-14	63.1600	f
01a09b0f-e12a-736f-bfc6-dd82208a1c09	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-22	54.2000	f
01a09b0f-e12a-737e-8c82-d08f60d81429	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-03	43.7200	f
01a09b0f-e12a-7383-bfa9-f19c418ffbd8	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-13	42.5000	f
01a09b0f-e12a-73c3-8265-7ae8b9676558	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-05	101.9700	f
01a09b0f-e12a-73c3-b01f-59a72361cb86	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-19	88.1900	f
01a09b0f-e12a-73c3-b4dd-edc109f96332	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-21	59.0900	f
01a09b0f-e12a-73c9-b808-c91c65e712dd	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-17	60.8100	f
01a09b0f-e12a-73d0-9107-31d990846da1	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-29	52.0800	f
01a09b0f-e12a-73ed-b052-b0ba0f4c0d13	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-20	46.9400	f
01a09b0f-e12a-7425-8521-33b0acc39372	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-13	44.3900	f
01a09b0f-e12a-743f-b88a-be518bdc38e7	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-12	61.6600	f
01a09b0f-e12a-7460-ab1a-827058ad4e51	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-09	64.9700	f
01a09b0f-e12a-746a-aa23-18cd1d370531	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-18	94.7200	f
01a09b0f-e12a-7470-acb4-9d96052b2b35	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-30	34.4500	f
01a09b0f-e12a-748b-84d5-62f1de03e98a	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-25	46.1900	f
01a09b0f-e12a-7490-8f2f-8667d05bb2fd	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-20	43.6600	f
01a09b0f-e12a-74a2-8ee2-0bee0e489eee	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-15	99.6600	f
01a09b0f-e12a-74c0-a8c0-85889c4b1b31	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-10	47.5500	f
01a09b0f-e12a-74cd-b883-2da7e98d6297	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-27	37.1200	f
01a09b0f-e12a-74dc-b808-e5e292c3042f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-20	44.8200	f
01a09b0f-e12a-7531-a4f8-d573f2d3309c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-16	107.4200	f
01a09b0f-e12a-7533-9a37-7b0e328856be	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-04	47.0800	f
01a09b0f-e12a-7547-9368-30c35fd507c3	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-27	58.6500	f
01a09b0f-e12a-755c-8577-2357d6dc29ea	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-23	43.4800	f
01a09b0f-e12a-758f-8fe5-f57d7349e303	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-18	44.5800	f
01a09b0f-e12a-75b6-8ad3-c6cac269dc3a	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-07	69.6600	f
01a09b0f-e12a-75d6-bf77-4626acdb2616	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-24	44.3000	f
01a09b0f-e12a-75ea-b897-f787f94bd02c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-02	38.4700	f
01a09b0f-e12a-7613-8167-d351835bb5b3	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-02	44.4600	f
01a09b0f-e12a-761e-8494-9edf93389c68	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-14	67.1400	f
01a09b0f-e12a-7665-974e-f8752f10399f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-05	44.4100	f
01a09b0f-e12a-7692-8921-b592af9fbf60	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-06	45.1500	f
01a09b0f-e12a-76ac-a3ae-6ccad87ab32c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-12	100.9000	f
01a09b0f-e12a-76c2-b0e9-61b8c4f2057a	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-13	89.9500	f
01a09b0f-e12a-76cf-8027-97cc574cc35e	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-02	68.8800	f
01a09b0f-e12a-76d8-bdff-00e7a2766be0	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-20	61.6200	f
01a09b0f-e12a-76df-b576-f7022feb9448	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-18	47.9500	f
01a09b0f-e12a-7719-bae4-35b87ee6b482	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-11	45.4100	f
01a09b0f-e12a-772a-bdbc-f2457f9f2d14	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-04	44.4300	f
01a09b0f-e12a-773a-85f9-c96a41b894a6	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-16	50.7500	f
01a09b0f-e12a-773c-98af-4564d0c2454c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-22	47.3300	f
01a09b0f-e12a-7758-88d3-43c3c92fcc42	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-06	47.5900	f
01a09b0f-e12a-7769-94ae-4ca6579ff978	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-29	39.9500	f
01a09b0f-e12a-778c-937d-f54365649e01	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-23	59.5200	f
01a09b0f-e12a-7793-867c-9d81c280105a	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-28	99.3500	f
01a09b0f-e12a-77c4-92d6-628a283613e4	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-13	68.1200	f
01a09b0f-e12a-7816-ac18-aaec927351e2	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-06	39.1000	f
01a09b0f-e12a-7825-9eee-fdd2dabc822c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-08	102.7900	f
01a09b0f-e12a-7826-87a1-3996e673448f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-29	104.9800	f
01a09b0f-e12a-7847-9123-f6053962b1a7	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-17	46.9300	f
01a09b0f-e12a-7862-b1aa-b5ead3c3476c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-13	39.0000	f
01a09b0f-e12a-7864-abb7-f42fef667829	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-23	87.0300	f
01a09b0f-e12a-786d-8777-f761e4a0ee9b	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-21	98.5300	f
01a09b0f-e12a-7892-9ac1-8aa739593620	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-21	46.1800	f
01a09b0f-e12a-789c-9e7c-e1d723b33869	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-09	36.0900	f
01a09b0f-e12a-78a8-90be-de6bf46066a4	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-23	43.8700	f
01a09b0f-e12a-78ae-a654-792c6bef3c64	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-21	63.6300	f
01a09b0f-e12a-78b7-9ab3-e7786db052f9	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-11	54.2600	f
01a09b0f-e12a-78da-9279-d0399c6f5795	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-26	95.9100	f
01a09b0f-e12a-78e0-8691-e32458801f59	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-26	41.0000	f
01a09b0f-e12a-790e-bc04-b97eeb18e01f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-10	35.5800	f
01a09b0f-e12a-7917-8a7b-049098c41220	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-09	69.1800	f
01a09b0f-e12a-7930-bf0d-ca58488d250c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-18	44.3000	f
01a09b0f-e12a-7935-b65c-37601d711c44	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-19	44.4300	f
01a09b0f-e12a-793b-b447-9e266ebe0a66	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-07	64.0300	f
01a09b0f-e12a-794a-9787-eab204510d36	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-17	102.5200	f
01a09b0f-e12a-794c-8f19-c9e9649bdb15	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-12	92.0900	f
01a09b0f-e12a-795b-b573-932549ed37e9	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-22	61.4100	f
01a09b0f-e12a-795e-8ffe-5436582fbe01	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-08	63.6900	f
01a09b0f-e12a-7973-8acf-002ae2c3e746	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-15	43.8400	f
01a09b0f-e12a-798c-acc6-8972790e294c	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-23	53.5600	f
01a09b0f-e12a-79f7-9983-cffac5f7e66b	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-15	65.3100	f
01a09b0f-e12a-7a10-a2fb-806553cc53dc	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-23	44.9400	f
01a09b0f-e12a-7a1a-bdd0-eb74c6115ca3	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-24	44.2000	f
01a09b0f-e12a-7a34-9935-f4844f3ed8d5	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-24	53.5200	f
01a09b0f-e12a-7a3f-ad23-41cdcb696536	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-18	95.5000	f
01a09b0f-e12a-7a63-b6d9-14f71dca4fcd	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-26	52.5100	f
01a09b0f-e12a-7a69-8ec5-57a597a9271c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-10	44.0300	f
01a09b0f-e12a-7a9f-9718-f4e61d2e37c7	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-08	84.8900	f
01a09b0f-e12a-7ab0-a6d3-209d600ef278	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-26	59.4400	f
01a09b0f-e12a-7acf-9bb8-c60ab75fb308	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-03	54.3900	f
01a09b0f-e12a-7b13-9181-2391f3f9a894	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-02	52.9900	f
01a09b0f-e12a-7b15-9662-5b129466642f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-20	62.0800	f
01a09b0f-e12a-7b2e-b47d-78f069994b96	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-30	55.4400	f
01a09b0f-e12a-7b3d-98ad-89460dfaf9b2	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-23	60.0100	f
01a09b0f-e12a-7b4c-807e-24482ce62c0d	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-11	44.8500	f
01a09b0f-e12a-7b74-aef0-0d9afbe8850f	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-30	42.2300	f
01a09b0f-e12a-7ba6-a389-eb03a50eb76d	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-11	103.8300	f
01a09b0f-e12a-7c16-9dcc-dc0fe3f7cf43	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-01	72.2300	f
01a09b0f-e12a-7c44-bfc7-6bbf2fe60197	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-05	43.5200	f
01a09b0f-e12a-7c54-b5f5-a63e020c051d	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-22	90.6800	f
01a09b0f-e12a-7c97-8db7-ff9e2e2101c9	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-01	44.0200	f
01a09b0f-e12a-7cbd-8be6-8753bac9abf5	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-27	41.8300	f
01a09b0f-e12a-7ce1-b2ec-51a3b964c939	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-27	44.1700	f
01a09b0f-e12a-7cf8-a9d2-1a5efc5cfd32	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-26	47.5800	f
01a09b0f-e12a-7d00-a583-b7cc1e095f72	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-06	73.1200	f
01a09b0f-e12a-7d01-9c7c-c0a2c6fb42a9	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-31	38.6200	f
01a09b0f-e12a-7d05-88e3-a0d82de6ea0b	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-10	99.8900	f
01a09b0f-e12a-7d0c-a4e6-f047484199a4	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-14	90.1500	f
01a09b0f-e12a-7d11-b3a1-fb1471e9c858	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-05	62.0100	f
01a09b0f-e12a-7d18-8dce-cc4c058ed0ac	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-01	39.6600	f
01a09b0f-e12a-7d40-94c4-99a285a2b156	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-24	81.5500	f
01a09b0f-e12a-7d4d-927d-b8ae2f5c61da	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-07	45.6400	f
01a09b0f-e12a-7d70-b6f0-ce32b769eb14	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-19	53.0000	f
01a09b0f-e12a-7db9-8a56-2a5723808ad1	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-08	39.8500	f
01a09b0f-e12a-7dc8-9efe-fa0d62c2976e	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-28	41.8800	f
01a09b0f-e12a-7dc8-b1b9-6fd0dc0eb9ab	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-12	52.4000	f
01a09b0f-e12a-7df7-98ee-c86a939e40ea	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-11	105.3600	f
01a09b0f-e12a-7df9-ae4b-cf3b457e29bc	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-15	57.6100	f
01a09b0f-e12a-7e5a-86ac-6587edf7468e	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-06	65.0100	f
01a09b0f-e12a-7e66-a8bd-4b142b534d43	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-09	45.5000	f
01a09b0f-e12a-7e98-bd1e-48ef24567ec0	01a09aec-feb5-76f4-bba8-c8836a215b85	2025-12-15	49.2300	f
01a09b0f-e12a-7ecb-9616-3713b460c30e	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-01	115.3200	f
01a09b0f-e12a-7ee0-9795-342932a36d0d	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-06	46.5100	f
01a09b0f-e12a-7ee2-86a8-a5a9e60386da	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-29	63.8600	f
01a09b0f-e12a-7eea-8d10-31b7b1b079f7	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-03-17	45.4300	f
01a09b0f-e12a-7f1b-9d4a-dbc112c1c6b2	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-01-22	60.7100	f
01a09b0f-e12a-7f1b-b538-b2af913fd82c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-15	96.1000	f
01a09b0f-e12a-7f31-a6a2-6469a90dd703	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-22	95.4800	f
01a09b0f-e12a-7f43-8025-817d8a5df0ee	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-04	121.5000	f
01a09b0f-e12a-7f4d-86bd-322e1805aa0a	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-04-07	38.7900	f
01a09b0f-e12a-7f5b-827e-8f8cbac540e9	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-05	45.6400	f
01a09b0f-e12a-7f68-88b0-17ead2b98d5c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-03	108.2700	f
01a09b0f-e12a-7fc5-880f-6a18b09e8146	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-05-20	94.7100	f
01a09b0f-e12a-7fc8-bd78-e1fe14db7cc8	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-06-30	75.5800	f
01a09b0f-e12a-7fe4-ad47-6b4a74b4c700	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-17	43.0200	f
01a09b0f-e12a-7ffd-bb35-cf4abb7bf1eb	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-02-12	43.5000	f
01a09b0f-e12b-704a-9f95-8047cb071ef3	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-01	54.6400	f
01a09b0f-e12b-7059-a3a7-d1fe0a725803	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-09	54.6400	f
01a09b0f-e12b-7099-bbef-2dacbe68905d	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-31	62.8300	f
01a09b0f-e12b-7103-8313-ad4379fbc1ec	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-10	53.1100	f
01a09b0f-e12b-7231-977b-10dc6e7b204d	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-05	69.3700	f
01a09b0f-e12b-72a6-9d23-78a7d32fe90b	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-28	57.5600	f
01a09b0f-e12b-72ad-ae25-f13ad33d44a9	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-03	55.0500	f
01a09b0f-e12b-72b6-9f68-8cbeafec08b4	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-30	60.0700	f
01a09b0f-e12b-732a-b7a5-7930b536b336	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-13	62.1300	f
01a09b0f-e12b-7423-b1b1-08819b4aa280	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-19	62.7800	f
01a09b0f-e12b-746d-b8eb-d22e056c80f6	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-27	59.4100	f
01a09b0f-e12b-74a4-9064-aa5dbd2eb053	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-04	55.6600	f
01a09b0f-e12b-74a6-9cea-8280d8d822c4	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-18	61.6200	f
01a09b0f-e12b-74e2-9492-d139a196f80a	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-11	62.7100	f
01a09b0f-e12b-7523-b3e2-6917f55dad27	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-24	55.8900	f
01a09b0f-e12b-759d-9781-62b861094107	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-28	56.5900	f
01a09b0f-e12b-75f5-995e-72889d9b5052	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-03	63.2600	f
01a09b0f-e12b-760d-ba8c-f93fd3ec10f8	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-11	53.2100	f
01a09b0f-e12b-763c-b5ef-da1a623dead1	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-08	56.1200	f
01a09b0f-e12b-767e-b45a-c9e6c26491e3	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-12	61.4700	f
01a09b0f-e12b-7726-973b-cead708a4059	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-09-02	54.2900	f
01a09b0f-e12b-77b2-ad64-ac957d0e2037	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-07	62.3300	f
01a09b0f-e12b-77db-97ce-21749bba7a88	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-14	63.8500	f
01a09b0f-e12b-7815-87a1-f24c0e5a79c5	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-10	62.2300	f
01a09b0f-e12b-7890-9df5-fdbdb62b0731	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-26	55.8400	f
01a09b0f-e12b-79db-a9e2-ff7fd7218086	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-27	59.2300	f
01a09b0f-e12b-7a2d-b99b-e3cb208174a8	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-25	57.1700	f
01a09b0f-e12b-7c35-9eec-8ca8dd5f9673	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-04	70.2100	f
01a09b0f-e12b-7c93-b394-cbaf9ae9440c	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-20	62.7900	f
01a09b0f-e12b-7d0d-b00e-b8c3750148e5	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-17	64.3000	f
01a09b0f-e12b-7d1c-87ad-6862d74b0b31	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-06	65.4800	f
01a09b0f-e12b-7dad-ab8f-fc218263ab60	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-21	64.2100	f
01a09b0f-e12b-7f0f-9aab-43fd07f8dea2	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-31	56.4200	f
01a09b0f-e12b-7f7a-a71c-dd0b208cf4d2	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-07-29	55.4000	f
01a09b0f-e12b-7f7b-b987-fec9a85d3008	01a09aec-feb5-76f4-bba8-c8836a215b85	2026-08-24	57.1300	f
01a09b0f-e1ae-700e-a634-71bb60d60c50	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-02	157.0400	f
01a09b0f-e1ae-7175-86f9-70f259c442c1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-31	154.6400	f
01a09b0f-e1ae-7202-988f-2bbbd8ba9284	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-01	161.3000	f
01a09b0f-e1ae-72f2-a932-4bddf7bde1e9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-13	162.7600	f
01a09b0f-e1ae-7329-85fd-02e609c90511	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-26	165.0600	f
01a09b0f-e1ae-736c-a174-2026641b7cc0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-14	165.4900	f
01a09b0f-e1ae-737a-9384-4728b06f9b34	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-19	163.8900	f
01a09b0f-e1ae-7380-80a3-720da2173491	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-11	164.0400	f
01a09b0f-e1ae-73cf-8357-4167303cc8d7	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-22	151.4700	f
01a09b0f-e1ae-7421-9359-647c649d4fed	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-20	162.8000	f
01a09b0f-e1ae-742e-93b3-22d00dd24bdd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-17	151.1600	f
01a09b0f-e1ae-747c-a980-6a887c52978b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-01	157.0700	f
01a09b0f-e1ae-748b-9742-81f858ae274e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-03	150.7200	f
01a09b0f-e1ae-7497-8440-fa82761ad332	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-02-28	170.2800	f
01a09b0f-e1ae-75c7-8e6c-f5694550f9cf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-16	153.3300	f
01a09b0f-e1ae-7606-b62d-d104ee123223	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-17	164.2900	f
01a09b0f-e1ae-765a-9128-9ed6e2fd241e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-06	163.2300	f
01a09b0f-e1ae-7676-b972-2e04821082fb	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-08	154.2800	f
01a09b0f-e1ae-76be-9d6e-800ae89779a5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-11	157.1400	f
01a09b0f-e1ae-76bf-837d-bf85e3feba69	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-29	160.1600	f
01a09b0f-e1ae-76db-ad5a-f3832d1d06c5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-10	152.8200	f
01a09b0f-e1ae-773d-8e63-34c6a706a3ee	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-04	170.9200	f
01a09b0f-e1ae-77bd-bf3b-5fe8a07d45f3	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-28	160.6100	f
01a09b0f-e1ae-7873-a71d-c29354b33095	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-24	167.6800	f
01a09b0f-e1ae-78bf-be4d-ef68224cf850	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-07	173.8600	f
01a09b0f-e1ae-78dd-b96e-eda416bf4592	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-06	172.3500	f
01a09b0f-e1ae-790e-a29b-06bb6a60d231	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-05	164.2100	f
01a09b0f-e1ae-7948-b3e3-21ae17f78999	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-12	167.1100	f
01a09b0f-e1ae-7977-b640-316624f03b93	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-05	173.0200	f
01a09b0f-e1ae-79ab-87ac-978d7d184daf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-21	163.9900	f
01a09b0f-e1ae-7a1c-accd-48e3ed72e8cf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-30	158.8000	f
01a09b0f-e1ae-7a48-89e3-25832b1c734d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-23	155.3500	f
01a09b0f-e1ae-7a9c-90ad-67bf5a746ce5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-09	158.7100	f
01a09b0f-e1ae-7b1a-aa32-bd2197638796	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-02	164.0300	f
01a09b0f-e1ae-7b43-868f-43f0589cbfca	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-15	156.3100	f
01a09b0f-e1ae-7b52-8af7-6148c3c30abd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-21	147.6700	f
01a09b0f-e1ae-7bb2-9839-e8cdc3095dfb	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-25	161.9600	f
01a09b0f-e1ae-7c43-9049-2622b6d9035c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-10	165.8700	f
01a09b0f-e1ae-7c50-a71a-cba3370d2dec	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-18	160.6700	f
01a09b0f-e1ae-7c70-ab76-2829a97cc468	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-27	162.2400	f
01a09b0f-e1ae-7c7e-8b5f-635aad70d61c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-07	151.3800	f
01a09b0f-e1ae-7cbc-b38c-43acde9328d5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-04	145.6000	f
01a09b0f-e1ae-7d30-9953-1280969558bf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-24	159.2800	f
01a09b0f-e1ae-7d74-8687-227722fd4c96	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-28	154.3300	f
01a09b0f-e1ae-7dd0-8689-d8807c0d4afc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-07	146.7500	f
01a09b0f-e1ae-7e15-abed-3d7ec459b344	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-03	167.0100	f
01a09b0f-e1ae-7e88-aa92-a871fe348276	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-08	144.7000	f
01a09b0f-e1ae-7f99-b821-56382818b443	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-03-25	170.5600	f
01a09b0f-e1ae-7fad-bfa7-5fc241500098	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-04-14	159.0700	f
01a09b0f-e1af-709a-ad59-ef196bb74c3c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-25	193.1800	f
01a09b0f-e1af-709e-8c0b-d3b57ec49ffe	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-13	244.1500	f
01a09b0f-e1af-709f-8ee8-c27806f497a1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-21	250.4600	f
01a09b0f-e1af-70c6-bc4d-560bc30d11bf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-20	289.4500	f
01a09b0f-e1af-7110-abc7-f6a10517d185	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-30	196.5300	f
01a09b0f-e1af-712a-b6ac-8edcc7b99275	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-29	171.8600	f
01a09b0f-e1af-7134-bd3d-87336f7f8d16	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-05	194.6700	f
01a09b0f-e1af-713c-874b-9bac804e7aed	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-03	283.7200	f
01a09b0f-e1af-713e-8cb4-e11cbcf48d7d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-09	239.6300	f
01a09b0f-e1af-7172-a8a0-2924564f6c78	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-22	170.8700	f
01a09b0f-e1af-71af-80e3-2489045c727d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-19	254.7200	f
01a09b0f-e1af-71b1-815e-612f649fee65	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-09	176.0900	f
01a09b0f-e1af-71b8-858d-3a8b54541a01	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-07	196.5200	f
01a09b0f-e1af-71c8-b028-429f608b22e8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-26	246.5400	f
01a09b0f-e1af-71e5-9092-4982faccf29a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-16	166.1900	f
01a09b0f-e1af-7201-8894-3f3106fe0165	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-13	278.5700	f
01a09b0f-e1af-7202-985e-16f281f07082	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-20	166.6400	f
01a09b0f-e1af-7240-8a3b-3fcc1449da0a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-13	201.9600	f
01a09b0f-e1af-7264-b923-48e5c63ac9ed	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-05	284.3100	f
01a09b0f-e1af-7273-ac16-7720d589517f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-20	199.3200	f
01a09b0f-e1af-7291-b522-2d2dd96fd789	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-24	247.1400	f
01a09b0f-e1af-72c3-bb40-9b108312cbe7	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-25	208.4900	f
01a09b0f-e1af-7300-9ee9-bed7b1225efc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-17	249.5300	f
01a09b0f-e1af-731e-b794-17ea79833f2b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-21	299.6600	f
01a09b0f-e1af-7320-a63a-657698be6445	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-20	163.9800	f
01a09b0f-e1af-7331-a266-b5e633a680e3	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-16	182.9700	f
01a09b0f-e1af-7334-85a7-a3aa9699a9f1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-16	251.4600	f
01a09b0f-e1af-7349-b443-23cc35c32f1b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-06	173.6800	f
01a09b0f-e1af-7357-a532-482128a4bae9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-23	253.0800	f
01a09b0f-e1af-735b-92ad-d3d327e25815	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-14	276.4100	f
01a09b0f-e1af-735c-81b2-9151e86e07e0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-14	165.3700	f
01a09b0f-e1af-737f-a266-844ae573189d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-06	284.7500	f
01a09b0f-e1af-73ad-b917-f2dac7b49a88	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-31	281.1900	f
01a09b0f-e1af-73ae-bf0a-53f943e09276	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-23	165.1900	f
01a09b0f-e1af-73b6-a63f-0fc22ad04cb9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-21	199.7500	f
01a09b0f-e1af-73bd-8c2c-96ec1294e9ce	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-28	211.6400	f
01a09b0f-e1af-73d0-a04f-3bd5e8183b7d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-06	196.0900	f
01a09b0f-e1af-7441-bcd8-3c8d59088c9a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-18	203.5000	f
01a09b0f-e1af-7483-8590-b9b695c6280c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-17	253.3000	f
01a09b0f-e1af-74ac-91c6-c14ab6c3c33a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-18	173.3200	f
01a09b0f-e1af-74b4-9024-69fa1d0b0c0c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-01	175.8400	f
01a09b0f-e1af-74cc-938e-d7269a952c1b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-27	269.2700	f
01a09b0f-e1af-74cc-939a-d7e78e371f0c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-10	290.1000	f
01a09b0f-e1af-74ce-bf37-60b031eb8a85	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-17	183.5800	f
01a09b0f-e1af-74d4-a8ce-74e5977df6ba	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-29	212.9100	f
01a09b0f-e1af-74e6-93b8-747be2d7fb57	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-21	190.1000	f
01a09b0f-e1af-751b-83a3-76b368b49e95	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-11	177.3500	f
01a09b0f-e1af-7529-a937-40747d81aee4	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-15	251.6100	f
01a09b0f-e1af-7532-b63d-2b43010e2df0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-22	251.6900	f
01a09b0f-e1af-7534-b8b3-696924d9906d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-11	180.1900	f
01a09b0f-e1af-753e-b388-1e6b0de3a3f3	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-29	244.0500	f
01a09b0f-e1af-7551-891b-82c65e301b6c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-01	189.1300	f
01a09b0f-e1af-7577-a450-cfb55b54e64b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-08	201.4200	f
01a09b0f-e1af-7579-9eb2-ca1e2b951a30	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-12	175.7000	f
01a09b0f-e1af-7582-9e9f-63a585f33fcd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-28	172.3600	f
01a09b0f-e1af-758b-9166-ffd4c7dc571a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-27	207.4800	f
01a09b0f-e1af-7599-88e4-106a968c1590	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-08	174.3600	f
01a09b0f-e1af-75a6-8c47-b235feb0c6a5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-25	323.4400	f
01a09b0f-e1af-75b2-9667-1493b449eb67	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-22	252.5300	f
01a09b0f-e1af-75c0-987d-8adc4b0326f5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-04	195.0400	f
01a09b0f-e1af-7614-8bf4-d144f25b0891	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-08	244.6200	f
01a09b0f-e1af-7617-a027-32fb00b19391	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-18	252.0300	f
01a09b0f-e1af-767b-86f5-ec92689234aa	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-22	206.0900	f
01a09b0f-e1af-7682-98b5-5ed6bee3d78c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-15	203.9000	f
01a09b0f-e1af-7686-8459-156660317935	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-06	250.4300	f
01a09b0f-e1af-768b-b2b2-8b55ba19aa39	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-09	152.7500	f
01a09b0f-e1af-768b-b784-a6bd45040a84	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-12	203.3400	f
01a09b0f-e1af-7694-92ee-a5bfd2500b7c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-10	177.6200	f
01a09b0f-e1af-769c-83ae-9756e88bcf09	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-15	251.0300	f
01a09b0f-e1af-769f-9a0a-f8cc9d30342d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-15	163.9600	f
01a09b0f-e1af-76b5-9613-dacc994f2d33	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-24	192.1700	f
01a09b0f-e1af-76bf-b51f-758e72e4e36a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-29	274.5700	f
01a09b0f-e1af-76c6-8fa6-bd25877ae414	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-24	166.7700	f
01a09b0f-e1af-76ee-9530-92c41cdde209	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-13	174.6700	f
01a09b0f-e1af-770a-b775-cde8fdb97f39	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-10	236.5700	f
01a09b0f-e1af-7712-824f-898edd3f21bb	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-15	182.0000	f
01a09b0f-e1af-771c-a48c-f5bcdc00a7d0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-30	176.2300	f
01a09b0f-e1af-771d-be49-3e4d7282341a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-30	281.4800	f
01a09b0f-e1af-7727-9575-dd7b8f053e12	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-12	240.8000	f
01a09b0f-e1af-7732-bef7-8165fcfa98a9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-16	251.1600	f
01a09b0f-e1af-7750-b3bc-c30bd8d2fdd4	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-18	284.2800	f
01a09b0f-e1af-7760-924a-4cbd228f3f93	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-24	259.9200	f
01a09b0f-e1af-7786-a5ac-07e1729f5188	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-11	240.3700	f
01a09b0f-e1af-77ab-8531-c6b10438b108	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-17	285.0200	f
01a09b0f-e1af-77bc-b91b-e02609281f7d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-09	176.6200	f
01a09b0f-e1af-77f8-9948-b6b676776e9e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-05	235.0000	f
01a09b0f-e1af-7811-8ce7-c4fa29ca035a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-02	245.6900	f
01a09b0f-e1af-7838-b409-1377faef84fe	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-30	243.1000	f
01a09b0f-e1af-7867-869c-a70943ab3a03	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-12	286.7100	f
01a09b0f-e1af-786a-80ed-99420a12f39d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-02	169.0300	f
01a09b0f-e1af-78be-b337-67e08c358bdf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-27	172.9000	f
01a09b0f-e1af-7914-8d5b-616cf1b2ee92	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-02	178.6400	f
01a09b0f-e1af-794a-a47d-e298b3bab59c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-07	278.8300	f
01a09b0f-e1af-79ca-9f8d-316f79c28f2a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-19	292.8100	f
01a09b0f-e1af-79f1-a975-53be0f7927cd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-03	245.3500	f
01a09b0f-e1af-7a31-9d6d-152c9dc525cc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-26	207.1400	f
01a09b0f-e1af-7a46-9e62-5c829613bbb5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-31	191.9000	f
01a09b0f-e1af-7a67-a0ca-b7cdd3ba1b15	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-27	178.5300	f
01a09b0f-e1af-7a90-abbd-eb9c6f28e4d8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-21	168.5600	f
01a09b0f-e1af-7a94-97eb-5fcb2545755d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-23	190.2300	f
01a09b0f-e1af-7a9d-ad59-e951b69a6ab9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-26	173.5400	f
01a09b0f-e1af-7ab5-b992-b42d9c6f8fe3	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-14	181.5600	f
01a09b0f-e1af-7ab7-9c86-21c0fa3a4ab8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-05	168.2100	f
01a09b0f-e1af-7ac0-b453-a3e843803d4a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-08	234.0400	f
01a09b0f-e1af-7acb-ba17-50c0a940976f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-12	158.4600	f
01a09b0f-e1af-7af0-aeb5-52a93134f885	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-04	232.3000	f
01a09b0f-e1af-7b3e-ae00-0b237a8eee19	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-23	168.4700	f
01a09b0f-e1af-7b4c-a816-93b2f85c9727	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-28	192.5800	f
01a09b0f-e1af-7b4c-bc26-3519907c98bc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-03	179.5300	f
01a09b0f-e1af-7ba9-bb33-fa2225abdd1b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-10	239.1700	f
01a09b0f-e1af-7bb3-b1b3-649b4aca65af	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-19	201.5700	f
01a09b0f-e1af-7bf3-9811-4225000f9e37	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-17	175.9500	f
01a09b0f-e1af-7c11-83ce-41af51af4689	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-07	176.7900	f
01a09b0f-e1af-7c1a-a15b-aa346a755fd0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-22	191.3400	f
01a09b0f-e1af-7c1d-9a1b-c4872782c4c6	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-24	318.5800	f
01a09b0f-e1af-7c5a-a0dc-46d9ca6b6ba4	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-11	201.0000	f
01a09b0f-e1af-7c60-8fd1-399f1ca7a24e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-11	291.3100	f
01a09b0f-e1af-7c68-a5ef-b6cbe09a0d64	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-10	178.6000	f
01a09b0f-e1af-7ca3-943a-3f5e6e3a4b41	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-28	267.4700	f
01a09b0f-e1af-7d1f-86b9-77e60b66a288	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-20	256.5500	f
01a09b0f-e1af-7d3f-a232-26e93212db6f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-03	230.6600	f
01a09b0f-e1af-7de5-b2b1-9168b38c59d5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-04	277.5400	f
01a09b0f-e1af-7e0b-a83a-032ee43d3442	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-09	241.5300	f
01a09b0f-e1af-7e17-9ab4-bc77c7643113	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-04	168.0500	f
01a09b0f-e1af-7e5d-ba06-58856df2617b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-03	166.1800	f
01a09b0f-e1af-7e77-9ba2-2d58bea63ff3	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-02	211.3500	f
01a09b0f-e1af-7e85-a1f3-0be45acc5fbc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-14	245.4500	f
01a09b0f-e1af-7e9f-a44e-af5baa890eaa	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-25	245.7900	f
01a09b0f-e1af-7ea0-baca-c9b2284d6f52	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-18	185.0600	f
01a09b0f-e1af-7eb4-8c0e-539dec1a08b5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-19	166.5400	f
01a09b0f-e1af-7ed8-856b-f7d7d271db58	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-30	171.7400	f
01a09b0f-e1af-7ee7-8008-1c22c12d5ad9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-07	245.7600	f
01a09b0f-e1af-7eee-b2cd-2c5d5a3db462	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-07-29	195.7500	f
01a09b0f-e1af-7ef7-9788-2f33e9714a49	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-10-01	244.9000	f
01a09b0f-e1af-7f41-a544-b62d445d6167	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-25	170.6800	f
01a09b0f-e1af-7f77-a068-81b2ddcbdb8f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-06-16	176.7700	f
01a09b0f-e1af-7fba-81c9-448518c2a00a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-05-13	159.5300	f
01a09b0f-e1af-7fc0-82b5-1e9a47eeff4d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-08-14	202.9400	f
01a09b0f-e1af-7fed-b1c4-468c8769c5e0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-09-23	251.6600	f
01a09b0f-e1b0-700b-9d39-775c10137576	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-01	376.3700	f
01a09b0f-e1b0-702d-8a0e-c6c5a4e49f28	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-16	336.0200	f
01a09b0f-e1b0-7033-b868-377a3a311436	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-24	290.4400	f
01a09b0f-e1b0-7034-a0b9-a1b7f8416ea0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-17	310.9200	f
01a09b0f-e1b0-7044-a827-6c377411c953	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-06	299.9900	f
01a09b0f-e1b0-7067-ab10-b686ea08eb77	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-22	309.7800	f
01a09b0f-e1b0-709f-991b-2ab0d2595394	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-27	274.3400	f
01a09b0f-e1b0-70a5-b3ce-40df66fc2885	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-13	321.3100	f
01a09b0f-e1b0-70af-9d1e-6b2d098c8b33	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-16	305.5600	f
01a09b0f-e1b0-70c3-a497-77343fdbaf6a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-26	280.9200	f
01a09b0f-e1b0-70d5-aa30-2e2447845959	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-12	387.3500	f
01a09b0f-e1b0-7111-836f-63855459dbaa	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-11	308.7000	f
01a09b0f-e1b0-7125-8cae-43115e3958ae	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-03	319.6300	f
01a09b0f-e1b0-714b-a4ab-02cff4d78d0a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-15	369.3500	f
01a09b0f-e1b0-715a-a45f-405f667c5758	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-17	363.7900	f
01a09b0f-e1b0-715e-afcf-79fe75d9e3ca	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-29	353.6500	f
01a09b0f-e1b0-7181-9553-f0c1a27c733b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-10	307.0400	f
01a09b0f-e1b0-71e7-a085-33e5e0539727	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-29	349.9400	f
01a09b0f-e1b0-71f7-8435-e272924d011b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-04	303.1300	f
01a09b0f-e1b0-7273-b362-abca81de97a2	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-31	287.5600	f
01a09b0f-e1b0-7282-a7ef-bb3eafd0878a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-05	388.4300	f
01a09b0f-e1b0-72c2-813c-d935c11a2c97	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-20	301.0000	f
01a09b0f-e1b0-72c8-869a-6d21c03dc06f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-19	307.1600	f
01a09b0f-e1b0-72e2-90af-83c5df051cca	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-04	317.6200	f
01a09b0f-e1b0-72ec-b608-a91239f11175	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-12	359.6800	f
01a09b0f-e1b0-732a-9779-4f1aa2cf9ad8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-02	295.7700	f
01a09b0f-e1b0-7337-9dbb-c516f3f8d255	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-02	315.8100	f
01a09b0f-e1b0-7344-9cc3-fe3a1d1420d5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-03	358.9900	f
01a09b0f-e1b0-736d-b832-ddcaee6296eb	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-02	343.6900	f
01a09b0f-e1b0-7375-a205-7f248c50460a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-17	302.0200	f
01a09b0f-e1b0-73aa-bcf2-ba541a5d09dd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-20	337.4200	f
01a09b0f-e1b0-73e1-b228-311dbeb8c36a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-26	307.3800	f
01a09b0f-e1b0-73f9-be4b-8d9da2eaaad6	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-09	364.2600	f
01a09b0f-e1b0-7410-96b7-6c61acd6dda4	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-08	317.3200	f
01a09b0f-e1b0-7425-ae9d-4545fd286267	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-26	388.8800	f
01a09b0f-e1b0-7434-984f-7c6724d497f8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-25	312.9000	f
01a09b0f-e1b0-7442-9d77-69291e1749ee	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-24	310.9000	f
01a09b0f-e1b0-7462-8ba5-aa7f1184b145	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-14	401.0700	f
01a09b0f-e1b0-74a7-9b00-37a348112210	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-12	303.5500	f
01a09b0f-e1b0-74b2-8a21-20cf72b84319	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-23	338.8900	f
01a09b0f-e1b0-74b7-ab47-8ef28d00b06b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-26	333.2600	f
01a09b0f-e1b0-74ea-a930-7bc8571277de	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-23	327.9300	f
01a09b0f-e1b0-751e-a467-742c91c49ed0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-28	320.1800	f
01a09b0f-e1b0-753e-88dd-e925716fc34e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-15	308.2200	f
01a09b0f-e1b0-755a-aacf-451ca7a2cc81	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-13	305.7200	f
01a09b0f-e1b0-756b-90cb-2e4ac66040c8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-26	313.5100	f
01a09b0f-e1b0-75a2-bf45-54ffaf93de8a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-21	328.3800	f
01a09b0f-e1b0-75a3-b9de-684b87a36cd5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-15	337.1200	f
01a09b0f-e1b0-75a6-9e21-042d5bfe3bda	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-20	314.9800	f
01a09b0f-e1b0-75a7-b472-46af7d24bcb2	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-08	325.4400	f
01a09b0f-e1b0-75b8-ac64-37caa7e17c1e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-28	349.7800	f
01a09b0f-e1b0-75c0-9f3c-3106b3361328	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-24	344.4000	f
01a09b0f-e1b0-75d3-a222-697c4713577d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-24	345.2900	f
01a09b0f-e1b0-75f2-997b-c7d9185214dd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-17	296.7200	f
01a09b0f-e1b0-7604-b2f9-d351d2e72f2b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-29	313.5600	f
01a09b0f-e1b0-7620-b3b2-35a9fdb75db5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-29	338.2500	f
01a09b0f-e1b0-7625-a667-29687251fe1c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-28	336.0100	f
01a09b0f-e1b0-7659-bd3e-c3d8b53b0937	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-15	396.7800	f
01a09b0f-e1b0-769b-8bb3-0a840ff1e108	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-09	324.3200	f
01a09b0f-e1b0-76b2-ae37-c6a7bb931adf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-09	306.3600	f
01a09b0f-e1b0-76b4-a5d8-c3ef2ad73e66	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-18	302.4600	f
01a09b0f-e1b0-76b5-a221-f2b9e60e474b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-01	385.6900	f
01a09b0f-e1b0-76be-b7b1-e8254b91d7dc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-03	339.7100	f
01a09b0f-e1b0-7703-b9f8-033405408105	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-06	314.3400	f
01a09b0f-e1b0-770b-9138-fa59ec7bcd0d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-01	314.8900	f
01a09b0f-e1b0-770c-9701-61df35146eaf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-29	380.3400	f
01a09b0f-e1b0-771d-a67b-ece5aee338ac	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-11	312.4300	f
01a09b0f-e1b0-7728-b2d5-4f91c618d844	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-19	302.8500	f
01a09b0f-e1b0-7729-a1ea-a1a770476d8c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-18	396.9400	f
01a09b0f-e1b0-7750-be24-bd9ed7f06b60	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-12	331.8600	f
01a09b0f-e1b0-7773-9229-c1a4800b66d6	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-08	313.7200	f
01a09b0f-e1b0-7784-873e-5bee1023a7c9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-16	306.5700	f
01a09b0f-e1b0-77b8-b9df-05734051e2a9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-16	330.0000	f
01a09b0f-e1b0-783e-a74f-e6eb44023c2c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-30	384.8000	f
01a09b0f-e1b0-784d-88a1-560ed2de60a1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-27	388.8300	f
01a09b0f-e1b0-7856-bc6f-5150d3302ed9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-22	382.9700	f
01a09b0f-e1b0-78aa-988e-4d7380fa5670	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-11	310.9600	f
01a09b0f-e1b0-78af-bdd9-4412edbe3472	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-28	390.1300	f
01a09b0f-e1b0-78b8-abab-644238f15d47	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-30	313.8500	f
01a09b0f-e1b0-7935-8831-7389669d1ca9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-10	318.5800	f
01a09b0f-e1b0-794e-b681-4e8af02d7d22	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-10	320.2100	f
01a09b0f-e1b0-795d-a8ce-0a73d3448b72	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-18	303.3300	f
01a09b0f-e1b0-79ab-9f59-717632f6f6ec	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-13	302.2800	f
01a09b0f-e1b0-79b3-8629-3086e17d5062	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-03	303.5800	f
01a09b0f-e1b0-79b3-a777-90df356800bc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-18	368.0300	f
01a09b0f-e1b0-79b9-80ff-3f87c98d54fe	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-04	383.2500	f
01a09b0f-e1b0-79ef-91c7-204b9dc03ae0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-23	314.3500	f
01a09b0f-e1b0-79f6-97ca-6df31f68bc2c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-14	332.9100	f
01a09b0f-e1b0-7a02-a4bf-3aaad829178e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-20	322.0000	f
01a09b0f-e1b0-7a04-8f48-c28152e4418f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-18	307.6900	f
01a09b0f-e1b0-7a23-9392-61fe8d5bfe74	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-05	368.5300	f
01a09b0f-e1b0-7a2b-a226-f7c4815c0216	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-12	309.2900	f
01a09b0f-e1b0-7a2d-94f3-52a109615661	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-10	356.3800	f
01a09b0f-e1b0-7a2e-b920-547087aa386f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-30	338.0000	f
01a09b0f-e1b0-7a5e-9a88-f89b7c0a894a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-09	317.0800	f
01a09b0f-e1b0-7a70-9e16-62f580ffd49f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-02	306.5200	f
01a09b0f-e1b0-7a77-8207-137be470ce04	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-16	373.2500	f
01a09b0f-e1b0-7a7e-816a-3b7131de6bc9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-01	297.3900	f
01a09b0f-e1b0-7a7e-ae91-bc60201e0624	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-11-26	319.9500	f
01a09b0f-e1b0-7a90-a4ae-7aecb5cd04e2	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-21	332.2900	f
01a09b0f-e1b0-7aab-ab6a-8716fd7d6294	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-11	388.6400	f
01a09b0f-e1b0-7ac2-bb1d-7125e7bf0d98	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-07	321.9800	f
01a09b0f-e1b0-7acb-b476-924bbb4938c0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-31	313.0000	f
01a09b0f-e1b0-7ace-8ef5-54a7718beb01	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-06	298.5200	f
01a09b0f-e1b0-7aec-84f2-a89f7dec4977	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-14	335.8400	f
01a09b0f-e1b0-7b03-b5ad-1369cfe68d02	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-08	400.8000	f
01a09b0f-e1b0-7b0f-b773-8a9fb5f153fd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-20	388.9100	f
01a09b0f-e1b0-7b1d-9423-2b5bd7071ea7	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-05	316.5400	f
01a09b0f-e1b0-7b45-9237-1ed409d92f86	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-13	335.9700	f
01a09b0f-e1b0-7b47-9dbc-b0e0aff86f4a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-02	361.8500	f
01a09b0f-e1b0-7b77-aee2-0e3d265c00e5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-11	357.7700	f
01a09b0f-e1b0-7bf9-abfd-bfb6f727bc29	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-23	302.0600	f
01a09b0f-e1b0-7c11-86f7-e09584ba98bb	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-13	402.6200	f
01a09b0f-e1b0-7c27-8b94-5c8e30dd644d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-23	346.1300	f
01a09b0f-e1b0-7c31-bc15-6b8f4ce0ed53	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-15	332.7800	f
01a09b0f-e1b0-7c40-8410-c9a359199aef	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-17	341.6800	f
01a09b0f-e1b0-7c73-bd47-fc106d6ea4ab	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-23	311.4900	f
01a09b0f-e1b0-7c83-8d30-8527ece5fd88	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-05	300.8800	f
01a09b0f-e1b0-7c9b-a047-e2d3556eb09c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-04	372.1900	f
01a09b0f-e1b0-7cad-96de-5c1c908753f6	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-19	307.1300	f
01a09b0f-e1b0-7d05-b94b-62c9ee4a6559	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-02	315.1500	f
01a09b0f-e1b0-7d0a-91aa-d251ef118530	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-22	339.3200	f
01a09b0f-e1b0-7d15-83fe-cd3647b20d05	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-21	387.6600	f
01a09b0f-e1b0-7d3e-bfa0-3dc012df8c3e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-22	330.5400	f
01a09b0f-e1b0-7d4d-a7c2-8a3c777f2cfd	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-09	318.4900	f
01a09b0f-e1b0-7d63-96df-1724b9d3b7c6	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-06	322.8600	f
01a09b0f-e1b0-7dc0-b2d4-ad0a4c6a978e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-30	357.3700	f
01a09b0f-e1b0-7dec-af5b-4565513c5423	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-25	290.9300	f
01a09b0f-e1b0-7e0e-9c6c-37d0139b1847	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-09	328.5700	f
01a09b0f-e1b0-7e11-aa77-6ddd7781d584	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-03-30	273.5000	f
01a09b0f-e1b0-7e3c-81a4-57f340b73063	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-05	331.2500	f
01a09b0f-e1b0-7e42-bcd4-d3d1f64a3014	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-04	333.0400	f
01a09b0f-e1b0-7e55-a52e-3a24999e80b8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-05	321.2700	f
01a09b0f-e1b0-7e95-b1f9-eb161e3ac310	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-12	309.0000	f
01a09b0f-e1b0-7ead-80c3-6fbb178376fe	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-10	317.2400	f
01a09b0f-e1b0-7ec1-b59a-e0b71c3cc09e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-27	350.3400	f
01a09b0f-e1b0-7ec9-9a2b-5e59a534e713	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-02-27	311.7600	f
01a09b0f-e1b0-7ee2-b195-de20bf418353	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-25	343.7100	f
01a09b0f-e1b0-7f01-acee-a85545b8f5fe	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-08	363.3100	f
01a09b0f-e1b0-7f1e-8770-b8532119a857	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-19	387.6600	f
01a09b0f-e1b0-7f6f-8439-1d96513d50ff	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-04-07	305.4600	f
01a09b0f-e1b0-7f77-864c-3fdd220dc29c	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-22	349.6800	f
01a09b0f-e1b0-7f89-ae06-a0d9489f2a22	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-06-26	337.3900	f
01a09b0f-e1b0-7f9b-8f0f-ab6b812b63ef	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-01-27	334.5500	f
01a09b0f-e1b0-7fdf-8b38-0d653b701e7b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2025-12-24	314.0900	f
01a09b0f-e1b0-7ff2-a6cb-db4696f824ef	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-07	397.9900	f
01a09b0f-e1b0-7ffa-883c-ff6537cea7ce	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-05-06	398.0400	f
01a09b0f-e1b1-707f-bf63-3fe2365cb17b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-07	354.3000	f
01a09b0f-e1b1-708c-adf3-07dc4eecd506	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-01	361.2100	f
01a09b0f-e1b1-70fd-82c4-42c0baef4a1b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-31	356.1300	f
01a09b0f-e1b1-71e7-8cca-03a2a3a562ee	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-27	340.6500	f
01a09b0f-e1b1-720d-ba70-956aac9e515a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-18	344.2000	f
01a09b0f-e1b1-722a-ae00-7a6cb04d9912	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-21	344.8200	f
01a09b0f-e1b1-7261-a243-928c581c6f3d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-13	346.3600	f
01a09b0f-e1b1-727e-a0f1-95bfc5871242	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-24	319.7400	f
01a09b0f-e1b1-7303-bb00-b411d8d040f6	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-04	377.6500	f
01a09b0f-e1b1-730a-af66-7a168ff5fa9f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-07	367.0300	f
01a09b0f-e1b1-738f-96cd-af57d12f37f1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-02	359.9100	f
01a09b0f-e1b1-7396-bc71-29ada39343b8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-10	332.6000	f
01a09b0f-e1b1-739c-8a80-80625565dbcf	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-17	346.7700	f
01a09b0f-e1b1-73c0-836d-4918d619f41e	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-13	352.5100	f
01a09b0f-e1b1-73da-bd8b-5718b36c324b	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-15	370.9200	f
01a09b0f-e1b1-7498-95b0-d40c3e8c2b70	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-17	344.0000	f
01a09b0f-e1b1-74fc-9e37-1345bdddaac9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-28	333.7100	f
01a09b0f-e1b1-7538-b812-67591e922022	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-31	339.3500	f
01a09b0f-e1b1-756d-8ad4-467fabcd8df1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-25	346.9600	f
01a09b0f-e1b1-7586-906a-b8a52ebd7823	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-28	346.5900	f
01a09b0f-e1b1-758d-98b9-a792c1b2716d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-20	351.9900	f
01a09b0f-e1b1-75f1-87f9-b1d79ca25e62	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-10	357.1800	f
01a09b0f-e1b1-760d-a10b-f8c157c23882	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-03	342.4800	f
01a09b0f-e1b1-76ad-8f1c-3b92094a6ab2	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-14	359.5100	f
01a09b0f-e1b1-7700-916e-02f24dcb7c68	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-16	354.4600	f
01a09b0f-e1b1-7741-af18-e66d685fbeb1	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-02	337.1200	f
01a09b0f-e1b1-776e-8ca9-83937c9483c3	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-08	338.3600	f
01a09b0f-e1b1-7843-ad45-b2f34529cf40	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-27	326.5600	f
01a09b0f-e1b1-784e-b585-38de9ab37c36	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-12	343.5400	f
01a09b0f-e1b1-78ad-b7ab-c4536200cfe8	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-09	358.8900	f
01a09b0f-e1b1-78e7-bcc1-2711342990ae	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-06	366.4600	f
01a09b0f-e1b1-7905-8b42-59a410f35df5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-08	361.9200	f
01a09b0f-e1b1-7939-97df-cb5682326b35	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-11	338.5000	f
01a09b0f-e1b1-7942-a7db-31946ed50f08	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-23	317.6900	f
01a09b0f-e1b1-79f7-8e8d-f67bb7920f3f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-05	362.4300	f
01a09b0f-e1b1-7a03-864f-d9e55ca0c21d	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-10	357.5200	f
01a09b0f-e1b1-7a11-9d86-422573851d2f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-09	330.6500	f
01a09b0f-e1b1-7ad6-82ee-2a81d9899bdc	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-11	343.8000	f
01a09b0f-e1b1-7b54-8060-f91d16aa2565	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-26	342.0000	f
01a09b0f-e1b1-7c5a-a0fa-a93d518bfd4f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-06	357.7500	f
01a09b0f-e1b1-7d26-9f76-9fc9bd5b1306	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-04	338.4600	f
01a09b0f-e1b1-7d2f-aee3-54ae4607e77f	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-09-01	335.0200	f
01a09b0f-e1b1-7dac-88f6-03ad8a1c6a96	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-22	342.0900	f
01a09b0f-e1b1-7dae-bf8d-2ac4e4e5f73a	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-20	340.6700	f
01a09b0f-e1b1-7dc2-8c9c-2c8f9dad14c5	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-14	345.9000	f
01a09b0f-e1b1-7e39-a377-ea0d567d18e0	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-30	333.6600	f
01a09b0f-e1b1-7e82-94a7-be69cba3b3d9	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-29	336.7100	f
01a09b0f-e1b1-7f30-b7c7-2297e7eb84ff	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-03	373.5100	f
01a09b0f-e1b1-7f3f-a300-b093eaa11118	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-19	344.7200	f
01a09b0f-e1b1-7fa4-8342-1dd3b0d8c6ba	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-08-24	348.0600	f
01a09b0f-e1b1-7fd6-984f-0c92a3d6d2db	01a09aec-feb5-7704-96cb-ba2a747fb7a1	2026-07-21	347.1500	f
01a09b0f-e27b-703a-91b8-e29498919518	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-16	348.0600	f
01a09b0f-e27b-7044-a2f9-bdd41978b488	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-20	327.3700	f
01a09b0f-e27b-7060-bcf7-a8d790efd5df	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-02	337.7400	f
01a09b0f-e27b-7067-9cd8-ef1f546c5883	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-17	366.4200	f
01a09b0f-e27b-708b-8fd9-b6cffb250e3a	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-22	346.4900	f
01a09b0f-e27b-70a6-86ee-dd72ec7f9e9f	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-23	374.2800	f
01a09b0f-e27b-70be-9da2-47515abe62f9	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-21	327.6300	f
01a09b0f-e27b-70dc-9c84-22983667709c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-07	309.2300	f
01a09b0f-e27b-70df-bfc0-6abca6e99673	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-29	330.2600	f
01a09b0f-e27b-70e0-8732-900077859f1f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-23	330.5200	f
01a09b0f-e27b-70f2-a64b-042a51a159a3	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-16	323.5400	f
01a09b0f-e27b-7110-b3e0-02d51f70c58f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-28	331.9200	f
01a09b0f-e27b-712b-8273-119424f002d8	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-23	349.2300	f
01a09b0f-e27b-7150-9c61-a87368744ec6	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-05	355.1800	f
01a09b0f-e27b-7162-9c01-9d5e0b70a35f	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-17	327.1700	f
01a09b0f-e27b-717c-8757-481cfda3aa97	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-17	366.8500	f
01a09b0f-e27b-7190-a00b-24aa4c0bba69	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-27	366.5300	f
01a09b0f-e27b-71dc-a124-4a8486b49242	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-20	325.8800	f
01a09b0f-e27b-71e2-8604-567f8548c3d2	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-15	350.8900	f
01a09b0f-e27b-7216-a04c-46116373729c	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-26	359.8900	f
01a09b0f-e27b-7287-80c9-67ede3f02411	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-13	356.7200	f
01a09b0f-e27b-72bb-b9a6-5af6cb834b44	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-12	312.0100	f
01a09b0f-e27b-72cc-b902-170f9fd673e1	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-10	339.9000	f
01a09b0f-e27b-72d2-8cdc-e75455ff7382	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-30	326.4400	f
01a09b0f-e27b-72e5-8483-5646d20273fa	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-03	323.9100	f
01a09b0f-e27b-7321-889b-c8aa3b38bf50	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-23	327.7800	f
01a09b0f-e27b-7335-aa11-ba22ed49a945	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-06	309.0000	f
01a09b0f-e27b-735f-bcc2-7538829810e1	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-08	306.6900	f
01a09b0f-e27b-73dc-bd1c-be067cc3231e	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-28	372.4800	f
01a09b0f-e27b-73e0-9d3a-af95d7c98d52	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-12	356.8300	f
01a09b0f-e27b-743d-a091-d32659fc0190	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-17	339.1200	f
01a09b0f-e27b-7443-92cd-6db165a49c26	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-07	340.8700	f
01a09b0f-e27b-7471-b9ee-f2b6e4ac545c	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-22	331.8700	f
01a09b0f-e27b-749c-9e44-d1b6a63999e9	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-25	357.5700	f
01a09b0f-e27b-74a0-bef9-72ddecfe5426	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-12	354.2800	f
01a09b0f-e27b-74c3-b994-865a4b5ab69b	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-06	337.3200	f
01a09b0f-e27b-74c6-bde8-9f7bb10bd310	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-30	345.2300	f
01a09b0f-e27b-74c7-a4ba-f4714959c7de	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-18	361.6100	f
01a09b0f-e27b-74f2-8c74-7c70939d6aed	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-13	375.0100	f
01a09b0f-e27b-74fb-a6b8-5a25a0746652	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-26	345.0500	f
01a09b0f-e27b-7541-9f29-4520852aa5a9	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-14	348.4400	f
01a09b0f-e27b-7551-a1bb-3a950b864d1f	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-13	345.8800	f
01a09b0f-e27b-759c-8015-025a4f6a8c35	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-17	325.0000	f
01a09b0f-e27b-75b0-8b46-eac58239665c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-19	348.3400	f
01a09b0f-e27b-75fe-b3a1-4bd2e54f49d4	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-15	310.4300	f
01a09b0f-e27b-762a-ac39-7548e6bb6396	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-12	354.6300	f
01a09b0f-e27b-762a-acf8-d807eaf6b6a6	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-31	318.3800	f
01a09b0f-e27b-7632-8d33-7734a5bc9924	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-27	386.8300	f
01a09b0f-e27b-766c-9c74-3ce88ef07c87	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-05	335.8400	f
01a09b0f-e27b-76a7-86c9-76e9ecf1db4b	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-09	348.3200	f
01a09b0f-e27b-76aa-a49b-fc989588a4e9	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-19	334.8100	f
01a09b0f-e27b-76c3-9c02-5d52cde6548e	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-02	356.1000	f
01a09b0f-e27b-76e6-be43-f612a7d29bd4	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-19	334.4000	f
01a09b0f-e27b-76ee-9684-9e15cbe3bd5d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-06	371.0800	f
01a09b0f-e27b-7707-9f8c-9bf37bf788af	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-10	359.8800	f
01a09b0f-e27b-771b-9d5e-c7f696fc6d4a	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-05	385.8200	f
01a09b0f-e27b-771b-a868-a67b6dac563f	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-14	358.2600	f
01a09b0f-e27b-7746-895b-000ad876fd10	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-22	363.9100	f
01a09b0f-e27b-774e-8710-e2e5fe23ee5d	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-07	370.0700	f
01a09b0f-e27b-7789-b45b-bff517273806	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-18	339.2100	f
01a09b0f-e27b-779e-a45d-e8c4b9fd6f35	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-25	379.0200	f
01a09b0f-e27b-77e2-b8cf-ebb2e0a1f713	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-26	330.6900	f
01a09b0f-e27b-7816-8088-5f72ac131249	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-18	323.1900	f
01a09b0f-e27b-7823-ac52-ec2ceb21837b	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-28	357.7500	f
01a09b0f-e27b-786c-9cef-86d5a799773d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-10	351.1500	f
01a09b0f-e27b-7870-87e6-1ed73ec779f0	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-24	378.6200	f
01a09b0f-e27b-788a-a40b-93a928b3d9ff	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-09	363.0900	f
01a09b0f-e27b-78db-b397-2f2ef04fbb7a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-22	330.1200	f
01a09b0f-e27b-7911-b580-bac8d1307be3	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-02	329.3800	f
01a09b0f-e27b-7916-be84-ff45812451e9	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-24	345.6400	f
01a09b0f-e27b-791a-8993-1d050dbbb883	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-10	365.0000	f
01a09b0f-e27b-7951-952c-d38fa766deff	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-11	357.9400	f
01a09b0f-e27b-7958-a126-7af8e9ef12ee	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-15	364.6900	f
01a09b0f-e27b-79ae-be49-fb6adbc73946	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-16	367.3800	f
01a09b0f-e27b-79cf-9d6b-6fe0a86fc19a	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-29	348.6400	f
01a09b0f-e27b-79d8-af34-dc1320969e9b	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-13	314.0600	f
01a09b0f-e27b-79f9-b61e-3e77b4cb2584	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-03	341.8400	f
01a09b0f-e27b-7a09-ac97-638c674f77e2	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-11	363.9000	f
01a09b0f-e27b-7a4a-8bb9-11602423ad87	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-03	396.5400	f
01a09b0f-e27b-7a91-b514-9558b0828d4d	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-31	361.9600	f
01a09b0f-e27b-7ac6-9dc3-d4197d6798f3	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-08	358.6500	f
01a09b0f-e27b-7af1-bdda-f71040cba489	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-06	380.7700	f
01a09b0f-e27b-7b21-a4a5-95c3a0cd4940	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-26	330.1500	f
01a09b0f-e27b-7b22-9011-6e1757de0870	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-18	335.9400	f
01a09b0f-e27b-7b32-bb0c-57340654494f	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-11	371.6300	f
01a09b0f-e27b-7b46-860e-624d0f50b35a	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-01	351.6600	f
01a09b0f-e27b-7b4e-824f-d8056d011e0e	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-09	309.0900	f
01a09b0f-e27b-7b6e-b989-3fecba9d171c	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-04	350.7900	f
01a09b0f-e27b-7b9a-a311-f90af3852b78	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-25	338.9400	f
01a09b0f-e27b-7ba8-8315-92c910a3c0e6	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-15	329.3100	f
01a09b0f-e27b-7bba-9e65-4664f7f5f579	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-24	362.9600	f
01a09b0f-e27b-7bdd-905b-02eabd058560	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-20	358.5000	f
01a09b0f-e27b-7be4-8f6f-0a2a4276d0e7	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-20	371.0000	f
01a09b0f-e27b-7c1d-af27-50eafa85d659	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-01	348.3900	f
01a09b0f-e27b-7c21-8c37-17b9da506882	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-21	332.9900	f
01a09b0f-e27b-7c56-af6f-a35badc7252d	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-19	336.2500	f
01a09b0f-e27b-7c69-8c83-ab5c5fc47c00	01a09aec-feb5-777c-a7e4-586834fdefce	2025-11-04	381.5200	f
01a09b0f-e27b-7c71-b1b2-6e960ad9d0cb	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-09	376.6000	f
01a09b0f-e27b-7ca3-822b-80e58ba1d842	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-26	375.2900	f
01a09b0f-e27b-7cb1-b635-60ea109172d5	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-08	350.4300	f
01a09b0f-e27b-7d15-bbf2-9cef8c104f06	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-04	313.8700	f
01a09b0f-e27b-7d3e-90c9-fab39be5f242	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-29	330.9300	f
01a09b0f-e27b-7d74-8770-1e23292f95b8	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-27	333.4700	f
01a09b0f-e27b-7d8b-892d-880505b343e0	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-21	372.1700	f
01a09b0f-e27b-7daf-8463-eb4e30b9953b	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-03	339.1000	f
01a09b0f-e27b-7dcd-9eb4-986cf715d96b	01a09aec-feb5-777c-a7e4-586834fdefce	2025-09-24	346.0500	f
01a09b0f-e27b-7de8-9b81-4d53a80cb948	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-24	328.3400	f
01a09b0f-e27b-7e4e-b623-e4e2e1745988	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-02	326.2600	f
01a09b0f-e27b-7e5a-a07a-9379c0cc6ea0	01a09aec-feb5-777c-a7e4-586834fdefce	2025-12-30	325.1100	f
01a09b0f-e27b-7e5c-a2e0-aa915c94d2bc	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-16	308.7600	f
01a09b0f-e27b-7ed3-acab-dc53b32ea739	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-05	345.0500	f
01a09b0f-e27b-7f1e-92cb-2ba59a411171	01a09aec-feb5-777c-a7e4-586834fdefce	2026-02-23	351.5000	f
01a09b0f-e27b-7f34-a9f3-d79622adfdb9	01a09aec-feb5-777c-a7e4-586834fdefce	2026-01-14	312.6300	f
01a09b0f-e27b-7f74-ae67-a98310f89c70	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-29	382.8700	f
01a09b0f-e27b-7f79-b60e-e37b0787b813	01a09aec-feb5-777c-a7e4-586834fdefce	2025-10-30	396.3700	f
01a09b0f-e27c-7014-b715-fbdfac1a8e14	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-08	255.6000	f
01a09b0f-e27c-7041-8770-cd9385ca7e6d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-12	283.7300	f
01a09b0f-e27c-7045-80bd-95607929251c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-04	373.3100	f
01a09b0f-e27c-704f-9ef2-f6bbcf2b0805	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-08	344.9600	f
01a09b0f-e27c-7071-b819-a52fa70d5fa2	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-25	311.0500	f
01a09b0f-e27c-7073-88bf-4e826732742a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-16	358.3100	f
01a09b0f-e27c-7085-97a9-82f220f09ebe	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-10	264.8800	f
01a09b0f-e27c-709e-9f25-6db35001bdfc	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-09	257.1100	f
01a09b0f-e27c-70a4-a7da-0511c62de01d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-06	314.3100	f
01a09b0f-e27c-70aa-ab8d-4068df2024c4	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-14	265.4900	f
01a09b0f-e27c-70b6-bd9f-68f45312a93c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-11	350.1300	f
01a09b0f-e27c-70c4-b798-5f821297230c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-06	278.0000	f
01a09b0f-e27c-70d5-9ac7-e798e3febbd4	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-22	376.3500	f
01a09b0f-e27c-70e1-8dfe-bd4a6964bea8	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-01	319.9000	f
01a09b0f-e27c-70f0-ae5a-36a04862fbc3	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-28	260.2000	f
01a09b0f-e27c-7102-8310-a3e0c1c2b949	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-31	304.8300	f
01a09b0f-e27c-7103-ae53-0b06c614d8ca	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-29	352.6800	f
01a09b0f-e27c-7159-868d-1151473ab39f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-20	258.1800	f
01a09b0f-e27c-7179-8e28-6a2b982064ba	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-21	342.4200	f
01a09b0f-e27c-717c-80d0-044081328b81	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-08	267.7600	f
01a09b0f-e27c-718e-9010-bc05752a99bf	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-04	261.0700	f
01a09b0f-e27c-719f-a638-973a52e5020d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-10	346.4400	f
01a09b0f-e27c-71b1-82f5-505b134f8d32	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-28	250.7500	f
01a09b0f-e27c-71b5-816d-dbb107512c8e	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-23	359.4500	f
01a09b0f-e27c-71b6-9b40-6ac55180b215	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-13	351.9400	f
01a09b0f-e27c-7205-abeb-159d9ac07e7e	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-10	365.7200	f
01a09b0f-e27c-723d-89fb-afbf99e275b3	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-29	277.0700	f
01a09b0f-e27c-7263-9ea0-ce85e0b04560	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-19	352.6000	f
01a09b0f-e27c-7298-a39d-9afa0316ea90	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-06	282.8900	f
01a09b0f-e27c-72c2-8e5c-f7b153eb2159	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-05	330.5400	f
01a09b0f-e27c-72c7-9c35-2c96d3294f76	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-18	263.8500	f
01a09b0f-e27c-72d0-813f-8590fa2f542d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-18	352.0300	f
01a09b0f-e27c-7329-97c9-dafa13566ace	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-26	344.3200	f
01a09b0f-e27c-7345-89bc-dd801696e515	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-07	278.7700	f
01a09b0f-e27c-7383-9d12-429bf93bb43a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-14	269.3100	f
01a09b0f-e27c-7385-91a7-8f7dc95f92ef	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-17	351.3300	f
01a09b0f-e27c-7390-91ac-c5003e9dd716	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-30	283.1300	f
01a09b0f-e27c-7421-a2c9-c788901e5bab	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-02	378.8300	f
01a09b0f-e27c-7423-9abc-7e395c8470ff	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-11	338.0700	f
01a09b0f-e27c-7460-a7ad-490b5c08c431	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-29	261.1400	f
01a09b0f-e27c-74a5-b33c-54bf06dd6f3c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-06	357.0600	f
01a09b0f-e27c-74c4-873f-aad9206a198b	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-14	352.3200	f
01a09b0f-e27c-74cf-851f-8a72d570d921	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-02	281.4000	f
01a09b0f-e27c-74ef-ad9c-74c3941fc95f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-24	274.0500	f
01a09b0f-e27c-7527-9a44-940e8c7c98ee	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-04	323.1700	f
01a09b0f-e27c-752b-a8b6-bf755bab5286	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-05	287.1300	f
01a09b0f-e27c-752c-bcc1-dd1265a6a14c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-09	349.5800	f
01a09b0f-e27c-7543-add8-861fdfe2af88	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-27	259.2600	f
01a09b0f-e27c-756b-8c34-ce7d0c52ecbe	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-10	352.2700	f
01a09b0f-e27c-75f0-94b2-765635689c05	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-13	270.2100	f
01a09b0f-e27c-7635-86c1-45957d4a5593	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-15	365.5000	f
01a09b0f-e27c-7657-9293-168b371d7225	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-15	288.8700	f
01a09b0f-e27c-7687-84c4-f81597d54d0d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-09	339.3400	f
01a09b0f-e27c-7689-aad5-c480ac3e7ba3	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-15	270.2100	f
01a09b0f-e27c-76b6-91a4-2cc714e386ae	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-31	302.0000	f
01a09b0f-e27c-76c5-8e30-ca5f123d5d67	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-27	301.2500	f
01a09b0f-e27c-76f8-a501-81607c22f705	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-03	370.8000	f
01a09b0f-e27c-76fb-8106-5a22b1da1f9e	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-09	363.7700	f
01a09b0f-e27c-76ff-9f5e-cedf63c55ec1	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-20	325.6900	f
01a09b0f-e27c-770d-9deb-7975c49e06ec	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-23	279.1700	f
01a09b0f-e27c-77de-b8a2-9ec23a86f78b	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-19	264.7900	f
01a09b0f-e27c-77f2-9889-e5fd4de31573	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-11	368.3100	f
01a09b0f-e27c-7804-9482-18924951771a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-04	272.9600	f
01a09b0f-e27c-7806-9b8e-8db88b0c03be	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-21	267.1000	f
01a09b0f-e27c-781b-b2ee-ba8df7f6556d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-23	256.0600	f
01a09b0f-e27c-7822-912f-fa1ff71a0fbe	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-23	311.4600	f
01a09b0f-e27c-7823-a318-5146c65f99f1	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-12	351.4300	f
01a09b0f-e27c-7825-af03-bb2d0c89d91f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-31	335.0300	f
01a09b0f-e27c-783d-b3d1-f9544e7d06ba	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-26	263.3600	f
01a09b0f-e27c-7847-8805-c4ad4894bf17	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-15	260.3700	f
01a09b0f-e27c-7847-9492-c9fe55f021be	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-22	259.0800	f
01a09b0f-e27c-786a-b35b-82335691d063	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-12	362.3500	f
01a09b0f-e27c-786d-89f8-580a1cb0c87a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-17	348.3900	f
01a09b0f-e27c-787c-a27f-a01087b97710	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-20	266.1200	f
01a09b0f-e27c-78c6-bd2f-545f626351d5	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-25	273.2000	f
01a09b0f-e27c-78ce-84c8-2d7d176e3f9b	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-02	312.9300	f
01a09b0f-e27c-78d0-a122-341525e2295b	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-26	299.0400	f
01a09b0f-e27c-78fa-8e72-86ed16dd0167	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-28	335.1500	f
01a09b0f-e27c-7955-8ed5-18e472fad10f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-05	260.6400	f
01a09b0f-e27c-795d-8512-171b8e510eb4	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-16	287.1500	f
01a09b0f-e27c-7966-8a69-3f380d7a1d96	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-03	309.2300	f
01a09b0f-e27c-7984-b989-99501d25f5ae	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-20	341.9300	f
01a09b0f-e27c-7987-be26-9057d6ec3cab	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-09	266.2800	f
01a09b0f-e27c-79e7-a36a-81e8e13df7fc	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-30	296.5600	f
01a09b0f-e27c-79e7-b384-e1615c401bd7	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-07	315.4200	f
01a09b0f-e27c-79eb-a470-cd6acf4d71bf	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-24	368.5000	f
01a09b0f-e27c-79f9-8020-3ddde4c117f5	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-21	264.3700	f
01a09b0f-e27c-7a60-9877-f3af0b4e4422	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-14	343.6500	f
01a09b0f-e27c-7a62-902f-77ae37c3e538	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-04	337.9400	f
01a09b0f-e27c-7a6b-b332-bf525fae8ade	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-16	375.1600	f
01a09b0f-e27c-7a7c-ab17-01de066a7720	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-26	275.8600	f
01a09b0f-e27c-7a7e-aba8-879008200c6c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-01	258.3400	f
01a09b0f-e27c-7a88-9b1b-465d2ba34b7d	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-13	359.0700	f
01a09b0f-e27c-7a8e-af2f-9b89db9b0a1e	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-19	344.8600	f
01a09b0f-e27c-7a94-b954-b50074fe53db	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-18	296.0400	f
01a09b0f-e27c-7ad0-a67b-b367d58fcf04	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-30	303.3300	f
01a09b0f-e27c-7b2f-8294-95ec5a5fecc4	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-24	305.6600	f
01a09b0f-e27c-7b42-8d7f-885e750a88bb	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-24	258.3000	f
01a09b0f-e27c-7b53-ab12-5f110e038e23	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-20	368.9500	f
01a09b0f-e27c-7b9c-b39f-e57b227183f3	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-08	279.6100	f
01a09b0f-e27c-7b9d-9637-459a71f3b8a0	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-02	329.7900	f
01a09b0f-e27c-7bac-96bc-9434405fdb5a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-07	344.5600	f
01a09b0f-e27c-7bc0-b8a5-7c636d7de1c3	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-28	353.1000	f
01a09b0f-e27c-7c55-9947-bd45703dfd01	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-27	362.2400	f
01a09b0f-e27c-7c6c-967b-157ad6b0b046	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-01	290.5000	f
01a09b0f-e27c-7c79-8ea2-20406fcde47c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-25	345.5400	f
01a09b0f-e27c-7c8b-8852-68cc9e4fe908	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-03	335.9100	f
01a09b0f-e27c-7cb9-be26-d8bc8e946645	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-01	306.3900	f
01a09b0f-e27c-7cc6-8e31-b341e7cd89a5	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-01	282.2600	f
01a09b0f-e27c-7cde-926f-250cd1fc584c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-27	334.6500	f
01a09b0f-e27c-7cf2-b52f-b53390feeae1	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-17	373.0200	f
01a09b0f-e27c-7cfd-8a7a-fabc5734a3a2	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-11	276.6600	f
01a09b0f-e27c-7d33-ab61-4d9ec74a4764	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-17	286.1000	f
01a09b0f-e27c-7d3c-9fa5-24eb3d487b33	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-22	297.8400	f
01a09b0f-e27c-7d47-8741-e8b15026b98f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-24	341.0900	f
01a09b0f-e27c-7d55-84bc-74b9079f564c	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-13	344.0700	f
01a09b0f-e27c-7d5e-aa49-ab26c9d7bd6f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-03	256.6400	f
01a09b0f-e27c-7d6c-8f35-fe4db7271a22	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-05	363.7400	f
01a09b0f-e27c-7df1-a42e-653779d20802	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-10	253.9100	f
01a09b0f-e27c-7dff-be67-c409594e6f18	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-07	276.0200	f
01a09b0f-e27c-7e10-85c0-8f06df8f5ab0	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-17	260.4500	f
01a09b0f-e27c-7e15-b106-b311a1cfa31f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-03-30	294.7000	f
01a09b0f-e27c-7e47-b086-abc3f060dad1	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-13	261.5200	f
01a09b0f-e27c-7e9e-aedb-d8c89ced1d3a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-10	348.2500	f
01a09b0f-e27c-7ecb-899f-5f7863a0bd2f	01a09aec-feb5-777c-a7e4-586834fdefce	2026-07-16	265.5900	f
01a09b0f-e27c-7ed8-b5b7-d36efe2cd085	01a09aec-feb5-777c-a7e4-586834fdefce	2026-09-08	340.9400	f
01a09b0f-e27c-7efb-9425-2b6cc1c83452	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-18	335.7700	f
01a09b0f-e27c-7f05-aa14-2d69295b7d92	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-27	252.4500	f
01a09b0f-e27c-7f15-bee1-57461cd84a29	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-29	252.0900	f
01a09b0f-e27c-7f70-a820-09edadf8d24b	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-12	269.8200	f
01a09b0f-e27c-7f7f-93ef-709f9c9ef72a	01a09aec-feb5-777c-a7e4-586834fdefce	2026-08-06	328.4100	f
01a09b0f-e27c-7fb0-b52d-2007ed47f8dd	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-11	269.5800	f
01a09b0f-e27c-7fbe-9b54-18690c8357bb	01a09aec-feb5-777c-a7e4-586834fdefce	2026-04-21	375.1800	f
01a09b0f-e27c-7ff0-9435-28630fa16849	01a09aec-feb5-777c-a7e4-586834fdefce	2026-06-02	259.0000	f
01a09b0f-e27c-7ff4-9136-649b7aa7fe29	01a09aec-feb5-777c-a7e4-586834fdefce	2026-05-22	260.9800	f
01a09b0f-e345-7021-903f-d3af74a4f0a9	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-26	158.0100	f
01a09b0f-e345-7086-9ff0-0fd6ec885bdf	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-18	193.1800	f
01a09b0f-e345-7090-87ef-9085045c1d73	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-17	164.9300	f
01a09b0f-e345-70c3-bef5-da8416f0b2c6	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-02	175.3300	f
01a09b0f-e345-7116-85ed-3b48cb5b68ee	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-07	188.6700	f
01a09b0f-e345-7146-b314-83ae5b8b7118	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-10	151.7600	f
01a09b0f-e345-7190-a4f7-e616ca9a84b4	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-23	176.6100	f
01a09b0f-e345-71bf-a736-cd9a65a39623	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-01	189.2600	f
01a09b0f-e345-71e3-8f94-af32b54b7466	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-29	164.1000	f
01a09b0f-e345-728a-8044-1f08171e7b44	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-15	171.9200	f
01a09b0f-e345-72a1-a549-00322ed4be89	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-21	174.5800	f
01a09b0f-e345-72a7-8ab2-3a3b0a5fcaf9	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-22	174.8700	f
01a09b0f-e345-72bc-8e97-cee4bb452809	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-06	192.3200	f
01a09b0f-e345-72bc-8ff1-a37817082707	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-13	181.1500	f
01a09b0f-e345-72d7-b55d-89c38eee48a6	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-03	174.3700	f
01a09b0f-e345-72dc-9d81-dc9dacf8bf79	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-01	170.6800	f
01a09b0f-e345-72fb-a9f9-eee69cc76091	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-20	169.3500	f
01a09b0f-e345-7366-8c7c-f175dde42076	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-26	157.6000	f
01a09b0f-e345-7383-8ba0-de4e1474743d	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-28	155.2700	f
01a09b0f-e345-73eb-a8e4-4a50381071c6	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-21	148.5900	f
01a09b0f-e345-7433-9328-3b96d70e6b81	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-31	195.6900	f
01a09b0f-e345-74aa-ae33-6532a07aed82	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-16	168.0100	f
01a09b0f-e345-74d9-a6c7-4691c912d8be	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-25	165.4500	f
01a09b0f-e345-74fc-80b1-b456591b87b0	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-12	163.2400	f
01a09b0f-e345-7555-8a17-4341153683c2	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-03	191.4400	f
01a09b0f-e345-7563-9b63-9c3d28f33a6a	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-05	154.2700	f
01a09b0f-e345-7571-9a71-d34a3dd8e860	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-14	182.5700	f
01a09b0f-e345-75bc-b229-4ceae64d541e	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-03	184.8900	f
01a09b0f-e345-75c5-a889-d2c831f2139d	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-15	141.9700	f
01a09b0f-e345-75c6-aa8b-5b7e063b6e93	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-04	166.0100	f
01a09b0f-e345-75fe-af0b-e8031712b7dd	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-20	183.7500	f
01a09b0f-e345-7610-8a3b-d1659976b11d	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-08	156.4000	f
01a09b0f-e345-7616-8b57-467f531c4073	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-13	203.6200	f
01a09b0f-e345-7642-a2fd-95dc6ca4daa8	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-04	193.7800	f
01a09b0f-e345-76ce-8c6e-a504820cda57	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-02	186.1000	f
01a09b0f-e345-76f7-9f3b-ac985ca32cb7	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-26	202.2500	f
01a09b0f-e345-7724-9a50-19e246b8faa0	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-21	188.6500	f
01a09b0f-e345-778c-8f92-f3412ebd6ad7	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-09	184.6900	f
01a09b0f-e345-77c2-8e98-66d4d373e12d	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-11	199.5900	f
01a09b0f-e345-77de-9d79-57d5ed93767d	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-24	161.7400	f
01a09b0f-e345-7823-801d-a0624622e8cf	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-30	171.0200	f
01a09b0f-e345-7824-a326-bd25b5ddf56e	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-04	190.5100	f
01a09b0f-e345-78a1-81ac-99f8460387ae	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-29	159.4700	f
01a09b0f-e345-78a5-bad9-ba8b664fb66c	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-05	197.3100	f
01a09b0f-e345-78bd-9cc6-968ed58a9e68	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-07	166.4600	f
01a09b0f-e345-78c5-a566-5042106aba03	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-19	141.5800	f
01a09b0f-e345-78d0-8dfa-fcdc7132d418	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-31	180.3500	f
01a09b0f-e345-7909-a64b-b7ecdce02f03	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-16	168.5600	f
01a09b0f-e345-7921-9ff1-99ba9c37f8f5	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-24	173.9900	f
01a09b0f-e345-792a-bb79-b0ccff7e8f78	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-11	156.4000	f
01a09b0f-e345-793b-9ddf-27a5c9d453c0	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-18	169.6700	f
01a09b0f-e345-7966-8b73-160922f5172a	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-24	188.1500	f
01a09b0f-e345-7a14-bf06-893458d7701f	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-18	141.7100	f
01a09b0f-e345-7a1d-a5ca-0ce32bf4b5f9	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-02	159.9900	f
01a09b0f-e345-7a31-9304-788c10bce0c1	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-20	140.4900	f
01a09b0f-e345-7a66-a686-a8c16a14b7aa	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-22	154.0300	f
01a09b0f-e345-7ad3-9259-213013a0585a	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-10	188.9900	f
01a09b0f-e345-7ad5-8137-1207612d8b16	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-25	190.9400	f
01a09b0f-e345-7b04-bb8c-a3c1289a9397	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-15	169.0900	f
01a09b0f-e345-7b86-b859-11cbac25c54c	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-10	191.5200	f
01a09b0f-e345-7be2-8abd-9ff73841bb91	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-06	173.2800	f
01a09b0f-e345-7bfc-8ed0-6395cd5cf1f8	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-09	192.9300	f
01a09b0f-e345-7c2f-8127-2804cbcc6139	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-05-27	154.3100	f
01a09b0f-e345-7c4d-ad9d-5a3961f70ba7	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-28	195.3800	f
01a09b0f-e345-7c5f-a569-d7d9ebc9a477	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-23	162.2000	f
01a09b0f-e345-7c75-8b2d-5fb43459e6e2	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-10	186.9600	f
01a09b0f-e345-7ca2-9d49-e2408d892c54	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-11	197.8500	f
01a09b0f-e345-7cc6-ae26-6c615c6a8ff8	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-30	169.8800	f
01a09b0f-e345-7cf9-9768-3f6ca3a0f6cb	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-09-08	194.9600	f
01a09b0f-e345-7d1e-9e3c-d0ef4bde3109	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-28	169.7100	f
01a09b0f-e345-7dc6-b6ee-4e1fc15037e8	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-14	198.8200	f
01a09b0f-e345-7dce-85de-06bc8b58cbc4	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-17	168.6100	f
01a09b0f-e345-7e0a-ba66-8dcad74a7b71	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-09	152.1600	f
01a09b0f-e345-7e2a-a7ca-9aef026e0bba	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-17	201.8000	f
01a09b0f-e345-7e2a-b26e-b47bccd4857f	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-29	157.9700	f
01a09b0f-e345-7e5f-88d4-18a236d2dc33	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-27	170.7600	f
01a09b0f-e345-7e70-bece-362f946377a3	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-08	181.0500	f
01a09b0f-e345-7efe-8cde-78cc01611787	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-07-01	166.6200	f
01a09b0f-e345-7f49-830c-be22e32aac44	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-27	201.0900	f
01a09b0f-e345-7f59-8c51-1ce28303a17a	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-12	210.5000	f
01a09b0f-e345-7f74-bf77-65e670c6d35d	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-06-22	174.5600	f
01a09b0f-e345-7fdc-9639-c5dd9a13aeb9	01a09aec-feb5-78d7-b474-9ae90156cbbf	2026-08-19	186.4500	f
01a09b0f-e3b8-7ab3-b1ea-374fffcf55dd	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-10-28	190.5700	f
01a09b0f-e3b9-7000-bb49-304cfc2cb225	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-05	173.9500	f
01a09b0f-e3b9-7022-a69d-399a9200d1dd	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-22	166.2500	f
01a09b0f-e3b9-7031-99dd-a9cd8a09d5e8	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-01	179.2200	f
01a09b0f-e3b9-7046-b6a8-e373fb77f040	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-26	172.0200	f
01a09b0f-e3b9-7062-b95f-3147f5b0f96b	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-06	183.0200	f
01a09b0f-e3b9-708e-b8c1-62f166342ecb	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-14	170.8600	f
01a09b0f-e3b9-70a9-a740-6a3ce328801a	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-03	190.1500	f
01a09b0f-e3b9-70dc-8a7d-4f5f539a3a94	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-03	244.4400	f
01a09b0f-e3b9-7108-9245-9b566fc96f75	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-20	243.7500	f
01a09b0f-e3b9-716f-9118-627b64a908b1	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-21	181.4700	f
01a09b0f-e3b9-717f-bd0b-d6e93593ceae	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-28	179.7300	f
01a09b0f-e3b9-7180-8c14-2f9233081f11	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-30	186.1800	f
01a09b0f-e3b9-7183-9fc4-8f0a032fff00	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-11	248.5100	f
01a09b0f-e3b9-71a2-800b-1b9a5346056d	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-25	169.5700	f
01a09b0f-e3b9-71a2-91fd-ccab46cdc4ca	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-23	245.4200	f
01a09b0f-e3b9-71aa-a89b-3600ba1a6dc7	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-12	161.2700	f
01a09b0f-e3b9-71ae-b9e9-b2e56f5d961a	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-30	164.3400	f
01a09b0f-e3b9-71cf-bde3-d23c775eb8dd	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-09	202.0000	f
01a09b0f-e3b9-71fc-a21d-4960c801055a	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-08	185.6100	f
01a09b0f-e3b9-7247-b3e8-f216969cd998	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-05	190.7100	f
01a09b0f-e3b9-724d-84a3-d457592e7778	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-02	257.7500	f
01a09b0f-e3b9-7261-b939-05faaaa9dcd2	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-12	236.5100	f
01a09b0f-e3b9-7324-8734-31adbf1beed2	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-05	177.7500	f
01a09b0f-e3b9-7338-ae6f-04895a316e20	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-02	180.9100	f
01a09b0f-e3b9-7344-86bf-7a5f926bd0dd	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-10-31	192.8600	f
01a09b0f-e3b9-73be-a3a4-7122e77a07a1	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-03	178.8800	f
01a09b0f-e3b9-73d3-82dd-323cb6d0ed25	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-29	165.6200	f
01a09b0f-e3b9-744a-ab96-3afab388fb29	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-07	179.8000	f
01a09b0f-e3b9-7498-a07d-4b3f236267c3	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-17	166.6500	f
01a09b0f-e3b9-7527-8c6b-af0a8951c7e7	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-13	172.7200	f
01a09b0f-e3b9-753d-85f0-e58dafb6c178	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-26	259.2300	f
01a09b0f-e3b9-7562-a779-a480e8af0de8	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-04	182.5600	f
01a09b0f-e3b9-7577-af16-041314d5b9be	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-26	181.2300	f
01a09b0f-e3b9-7583-b6ec-8fb47199187f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-16	176.9300	f
01a09b0f-e3b9-75f3-a676-e575a06ea748	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-14	170.9700	f
01a09b0f-e3b9-75f6-9ec9-87333dd6f64b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-25	262.1900	f
01a09b0f-e3b9-7602-86c3-c923672cbb88	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-17	149.8300	f
01a09b0f-e3b9-7606-85ef-1436ec4a4496	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-05	189.0200	f
01a09b0f-e3b9-760a-81d5-b410d2116ad0	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-11	179.0500	f
01a09b0f-e3b9-760a-9b41-add7ed1a9358	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-22	181.1200	f
01a09b0f-e3b9-764b-9c0b-746102aa9d72	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-10	181.8200	f
01a09b0f-e3b9-7659-934b-a519e740f626	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-11	178.6600	f
01a09b0f-e3b9-7680-9a63-c77d71c30a65	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-23	182.4900	f
01a09b0f-e3b9-768c-a821-b79d2ef6ac01	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-24	168.9100	f
01a09b0f-e3b9-76d0-926d-a01d96cfc6fc	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-10-29	199.2700	f
01a09b0f-e3b9-76fd-a513-c12bb8489b51	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-27	189.2100	f
01a09b0f-e3b9-773d-840a-791aa702d93c	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-10-30	193.7600	f
01a09b0f-e3b9-779f-ac66-ab33adcae619	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-20	159.6100	f
01a09b0f-e3b9-783b-9ce8-666a47fa9237	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-03	191.4000	f
01a09b0f-e3b9-7842-9582-9b757682550b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-07	171.5400	f
01a09b0f-e3b9-7861-a950-d7c1efba63e3	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-19	243.0600	f
01a09b0f-e3b9-7899-8a2d-05bc2b4d791a	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-31	162.0100	f
01a09b0f-e3b9-78ca-a257-d8535ce8d725	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-13	163.6400	f
01a09b0f-e3b9-7976-9bdb-539c912b447f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-27	254.8900	f
01a09b0f-e3b9-79a5-8f61-ce12e7586549	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-06	195.5800	f
01a09b0f-e3b9-79ba-b854-4eef2df21288	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-21	159.8300	f
01a09b0f-e3b9-79d4-8209-55c36fcfc454	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-16	160.6600	f
01a09b0f-e3b9-7a24-ba12-e0ccc67b05d8	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-10	187.8400	f
01a09b0f-e3b9-7a47-9227-ccf4051944fe	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-09	178.3800	f
01a09b0f-e3b9-7b11-bf9a-3e76ce5307e2	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-18	243.2100	f
01a09b0f-e3b9-7bf1-976b-d67a9bd83c75	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-24	166.8700	f
01a09b0f-e3b9-7c00-8a42-1fd0a2def093	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-23	166.2600	f
01a09b0f-e3b9-7c03-9da0-b1eb11032d6d	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-15	161.7400	f
01a09b0f-e3b9-7c34-8b32-ef0afa5a8221	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-26	167.5800	f
01a09b0f-e3b9-7c43-a72d-8a3fbc5bd9a7	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-02	175.6100	f
01a09b0f-e3b9-7cc8-80a9-daca2ff12b05	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-19	170.6500	f
01a09b0f-e3b9-7cc8-9e4a-0001269265f8	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-12	170.0300	f
01a09b0f-e3b9-7ce5-8f26-737df19909b6	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-02	190.0100	f
01a09b0f-e3b9-7d08-af8b-f9e6434bb9ed	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-04	182.5400	f
01a09b0f-e3b9-7d16-aa63-d363a1d3cf08	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-24	253.1500	f
01a09b0f-e3b9-7d2e-8748-ff0ee57cb4be	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-13	234.5300	f
01a09b0f-e3b9-7d7e-a8ab-1d17024b5984	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-06	174.9500	f
01a09b0f-e3b9-7dd6-8531-b662054d1480	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-04	180.8200	f
01a09b0f-e3b9-7e31-91da-d176b22511d3	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-17	243.5300	f
01a09b0f-e3b9-7e34-a215-a15ac6ae206b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-15	172.5400	f
01a09b0f-e3b9-7e50-a22c-57b548d8c037	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-18	164.8600	f
01a09b0f-e3b9-7e86-8559-15669636ef4a	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-02-10	199.6200	f
01a09b0f-e3b9-7e92-9fce-a002cc490440	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-28	193.7600	f
01a09b0f-e3b9-7ee1-81f1-b64701354f36	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-09	163.5800	f
01a09b0f-e3b9-7f0f-b753-372013fba765	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-19	159.8200	f
01a09b0f-e3b9-7f17-b242-6e332b3ed6ab	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-29	195.1000	f
01a09b0f-e3b9-7f72-8411-65b9c40862df	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-11-12	173.3700	f
01a09b0f-e3b9-7f89-902c-dd93755a04d1	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-08	160.7800	f
01a09b0f-e3b9-7fc8-a4d9-637ad3a929b0	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-01-20	175.1800	f
01a09b0f-e3b9-7ff7-852c-18a9969630fc	01a09aec-feb5-791d-b3fc-038868ce5cef	2025-12-18	154.3900	f
01a09b0f-e3ba-70f8-b71a-9c215428a9d2	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-10	280.9800	f
01a09b0f-e3ba-711a-8e1d-973769fa3f6f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-02	261.2900	f
01a09b0f-e3ba-7123-9554-05f055628bfb	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-11	268.2600	f
01a09b0f-e3ba-712f-8f10-d799c80e4a2c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-22	305.1400	f
01a09b0f-e3ba-713a-8f0f-3cbb441563d6	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-08	281.0300	f
01a09b0f-e3ba-7140-a610-4d6cb815387b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-12	302.8700	f
01a09b0f-e3ba-71f9-9418-36bebf081ded	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-29	315.7100	f
01a09b0f-e3ba-721b-b115-3a116c6037d8	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-23	256.0000	f
01a09b0f-e3ba-7229-833a-aeed3725421e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-01	259.3700	f
01a09b0f-e3ba-725b-9712-1618579326e9	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-12	367.1300	f
01a09b0f-e3ba-727f-aa19-57c6ba79499b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-19	269.1700	f
01a09b0f-e3ba-7292-8d9d-4ea329e62bce	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-09	264.3500	f
01a09b0f-e3ba-7294-985d-923e78a8dc9b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-04	323.9200	f
01a09b0f-e3ba-7300-bde1-39717e1039f9	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-16	294.1300	f
01a09b0f-e3ba-733e-a2a9-6e2b9809ac0c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-15	311.9300	f
01a09b0f-e3ba-734a-81cb-d4d477dd2756	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-31	250.5800	f
01a09b0f-e3ba-7439-a134-0c3e8e99ff84	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-07	262.3000	f
01a09b0f-e3ba-743a-9ca6-53d029b16dd0	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-08	339.9700	f
01a09b0f-e3ba-74f9-bbb1-e72800e17491	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-24	270.8900	f
01a09b0f-e3ba-753d-ae52-005f49ecf12f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-24	323.4600	f
01a09b0f-e3ba-7572-a8c0-3df4e0057175	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-22	357.9600	f
01a09b0f-e3ba-75d4-ab9e-7a0711d2ddde	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-06	258.7300	f
01a09b0f-e3ba-762d-b3d7-8bde9d05607c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-29	306.1800	f
01a09b0f-e3ba-76c1-8d7c-4fe5fbb39166	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-25	276.1600	f
01a09b0f-e3ba-76c2-b091-3fb426403da0	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-13	258.8800	f
01a09b0f-e3ba-7708-8c57-cfe39da4c191	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-03	331.4400	f
01a09b0f-e3ba-7717-94a1-fa5de4f8842a	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-18	333.0500	f
01a09b0f-e3ba-7797-a0f4-5a71bdfae502	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-11	297.8800	f
01a09b0f-e3ba-77cc-ae04-f924c1a610fd	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-04	330.9700	f
01a09b0f-e3ba-780a-86f4-f2972394a9a6	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-26	252.4000	f
01a09b0f-e3ba-7870-a1dd-aa4d69078379	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-20	314.4100	f
01a09b0f-e3ba-7885-8ec5-363d8a461a8d	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-23	318.3200	f
01a09b0f-e3ba-78ba-8524-83d1518da13c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-02	334.4900	f
01a09b0f-e3ba-78cf-bb42-32d8ae7bed77	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-27	322.4300	f
01a09b0f-e3ba-790d-b67a-adc26319045d	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-10	270.0600	f
01a09b0f-e3ba-791d-b21b-23c593f59ba4	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-28	314.1800	f
01a09b0f-e3ba-792c-ae84-af17c6d98315	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-21	323.4000	f
01a09b0f-e3ba-7939-a340-9be33982eecc	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-22	327.4600	f
01a09b0f-e3ba-7944-8987-f1649ac03573	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-13	369.9900	f
01a09b0f-e3ba-79b9-b2fb-1035afa3d11e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-10	295.1100	f
01a09b0f-e3ba-79c9-a7c0-aaa7950e383c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-06	358.9200	f
01a09b0f-e3ba-79ca-9e69-290623c80fd8	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-01	328.3100	f
01a09b0f-e3ba-79d2-aa91-b546928c370c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-13	299.9600	f
01a09b0f-e3ba-7a2e-8e8c-f8f2368025fe	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-06	241.7800	f
01a09b0f-e3ba-7a57-a17d-29c9276accde	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-27	319.7800	f
01a09b0f-e3ba-7a84-a2c5-2d56b43c1d5d	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-16	299.6000	f
01a09b0f-e3ba-7aba-965e-cdbbda1191e5	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-01	323.3900	f
01a09b0f-e3ba-7b0a-a77c-55cc2fe47936	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-05	300.5100	f
01a09b0f-e3ba-7b12-b982-142dc530366a	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-11	367.9200	f
01a09b0f-e3ba-7b34-a0d1-9d078c728723	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-17	268.4100	f
01a09b0f-e3ba-7b71-81b2-b2a852d7ddc0	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-08	300.5700	f
01a09b0f-e3ba-7bc6-b749-f1fd06a42507	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-20	255.8800	f
01a09b0f-e3ba-7c2e-84a7-a8e8a7690f4e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-16	264.7400	f
01a09b0f-e3ba-7c57-bc2a-89e4ad9b1843	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-15	301.1600	f
01a09b0f-e3ba-7c64-a62e-7abe795ef8c6	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-21	312.4400	f
01a09b0f-e3ba-7c9f-b882-3dc814a9831c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-14	310.5100	f
01a09b0f-e3ba-7cad-8619-28245c9a3f44	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-18	339.7300	f
01a09b0f-e3ba-7cd9-8510-3f324239de23	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-30	234.2200	f
01a09b0f-e3ba-7cf6-8852-0f76b1a6b96e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-23	321.7500	f
01a09b0f-e3ba-7d4f-ab8e-8a192091351c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-04	251.2800	f
01a09b0f-e3ba-7d5a-923c-17189b665633	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-26	323.9100	f
01a09b0f-e3ba-7d60-9168-55524bcef227	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-30	328.4900	f
01a09b0f-e3ba-7d87-8660-832830db126a	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-17	317.5800	f
01a09b0f-e3ba-7d93-8a29-9ddc406cda31	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-19	322.6300	f
01a09b0f-e3ba-7d9e-a08d-414d873c89ef	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-07	340.0100	f
01a09b0f-e3ba-7ddb-a385-013b7a880307	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-09	289.5200	f
01a09b0f-e3ba-7e1a-b901-a0e5880592d4	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-17	307.3400	f
01a09b0f-e3ba-7e54-a5f0-e0a013b58dc6	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-18	264.7100	f
01a09b0f-e3ba-7e73-bcec-6616b0751f28	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-28	305.0300	f
01a09b0f-e3ba-7eb9-9dfc-90e2bf305e6e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-15	370.9400	f
01a09b0f-e3ba-7f2a-9de7-67a22420e7ca	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-27	251.0700	f
01a09b0f-e3ba-7f38-8ba9-e7d3bbc6c79e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-14	376.2300	f
01a09b0f-e3ba-7f93-9de5-974af3d993af	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-04-09	287.6400	f
01a09b0f-e3ba-7f9a-815f-8d04b61d4431	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-20	315.6700	f
01a09b0f-e3ba-7f9a-9644-43751d08a2eb	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-12	265.3800	f
01a09b0f-e3ba-7fab-a923-c5d4aad7319b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-05-05	341.0200	f
01a09b0f-e3ba-7ff7-b34d-38a283e8e07f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-03-05	249.7500	f
01a09b0f-e3bb-704a-b25f-dd7a0065691e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-16	294.1100	f
01a09b0f-e3bb-7050-8ab1-3d2594e301ad	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-29	306.9700	f
01a09b0f-e3bb-7071-a4b3-8b163e7c786d	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-04	269.9300	f
01a09b0f-e3bb-7083-9af3-05b5142db264	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-28	269.5600	f
01a09b0f-e3bb-70d7-a084-2f8883f37d02	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-30	334.8200	f
01a09b0f-e3bb-70f4-aafa-d8f5e35f3971	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-10	270.1000	f
01a09b0f-e3bb-715a-bcff-a3d6f5578782	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-10	318.8600	f
01a09b0f-e3bb-7281-99d4-361ce8d6c5a3	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-11	281.8100	f
01a09b0f-e3bb-72b7-a6fd-ce178759ce3b	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-06	275.1700	f
01a09b0f-e3bb-72bd-87bc-7fbb7d02f286	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-19	261.0000	f
01a09b0f-e3bb-7364-bad6-55f8dd572ea0	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-21	261.9500	f
01a09b0f-e3bb-7381-84d7-0df3a2f63375	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-24	316.4300	f
01a09b0f-e3bb-739e-95fd-2548c71b4f81	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-24	254.9700	f
01a09b0f-e3bb-73ab-8469-05656213af11	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-25	325.5700	f
01a09b0f-e3bb-743c-9683-97c8bb8fadc0	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-01	311.4200	f
01a09b0f-e3bb-74aa-972e-b06e6b16de5e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-07	272.4000	f
01a09b0f-e3bb-74e4-bd77-94a74178bfeb	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-11	257.0600	f
01a09b0f-e3bb-7504-afee-d95eb982c371	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-10	248.1300	f
01a09b0f-e3bb-75c3-90b2-6a5a9caab8ea	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-28	257.0800	f
01a09b0f-e3bb-7627-a071-d7847e0a7293	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-15	304.5700	f
01a09b0f-e3bb-762b-8925-249234ad60b7	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-03	268.8300	f
01a09b0f-e3bb-76ba-83b2-54576b3467a5	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-21	304.5000	f
01a09b0f-e3bb-7721-a1b2-25f1dc14047c	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-08	290.8300	f
01a09b0f-e3bb-772c-b2e0-0903d2276010	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-20	264.6300	f
01a09b0f-e3bb-7799-b15b-fd1ed549e7f5	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-14	293.8400	f
01a09b0f-e3bb-77c8-879d-94fba0489c6e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-17	289.5600	f
01a09b0f-e3bb-77cb-a47f-558b6dcb1a5f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-02	300.5300	f
01a09b0f-e3bb-78f2-81bb-8488f9e9c8ad	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-09	323.9200	f
01a09b0f-e3bb-795b-b160-a0e07b73996f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-29	223.0400	f
01a09b0f-e3bb-7972-9501-34c193ecda8e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-27	287.6000	f
01a09b0f-e3bb-79bd-87e2-e1fa12e56253	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-08	317.8100	f
01a09b0f-e3bb-79c3-8484-73c19ce64187	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-23	304.0400	f
01a09b0f-e3bb-7a19-be09-891436e39486	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-12	288.3600	f
01a09b0f-e3bb-7a52-9219-8ff534606e47	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-20	291.6700	f
01a09b0f-e3bb-7a71-aa3d-1e7a12b0a4be	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-31	258.7200	f
01a09b0f-e3bb-7a92-b117-b99fa1288af5	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-03	263.0500	f
01a09b0f-e3bb-7b66-b536-a106589427f2	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-07	305.5800	f
01a09b0f-e3bb-7b9d-bca8-08e0fd29014a	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-30	227.5000	f
01a09b0f-e3bb-7baf-844e-636ad5698384	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-13	287.0700	f
01a09b0f-e3bb-7bb2-b099-8fb3bd5c7c20	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-18	272.5400	f
01a09b0f-e3bb-7bd8-ad82-e371d2980f12	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-01	255.9700	f
01a09b0f-e3bb-7be1-9866-adab4d1c4be3	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-27	269.2800	f
01a09b0f-e3bb-7bee-aa5c-e1a59fdbca7f	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-04	280.5300	f
01a09b0f-e3bb-7c58-9a74-c5e533a54cbd	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-26	263.8100	f
01a09b0f-e3bb-7d1c-bd82-682bc5c0e71d	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-17	292.4300	f
01a09b0f-e3bb-7d5f-8197-4ac0ebde90bd	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-24	290.3600	f
01a09b0f-e3bb-7d7f-bb25-2be7e298ffd2	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-13	305.8700	f
01a09b0f-e3bb-7d95-ba95-ecfd0ee73440	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-14	303.5800	f
01a09b0f-e3bb-7ddc-9f3c-8c55c2d7c2ae	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-09	262.8900	f
01a09b0f-e3bb-7e49-bdf1-6672348f6287	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-05	277.9400	f
01a09b0f-e3bb-7ea0-9163-488f966f0dce	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-06-26	303.9500	f
01a09b0f-e3bb-7eee-acc0-e537fd8715cd	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-09-02	256.7000	f
01a09b0f-e3bb-7f12-a145-b68f71ae44c1	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-06	318.4700	f
01a09b0f-e3bb-7f75-a37c-5e17b99faadd	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-22	301.1600	f
01a09b0f-e3bb-7fc6-821e-a3f51013384e	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-07-31	241.5700	f
01a09b0f-e3bb-7fcb-a31f-29a01b60402d	01a09aec-feb5-791d-b3fc-038868ce5cef	2026-08-25	255.7500	f
01a09b0f-e450-700f-afe0-57b51e29873a	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-03	7.8200	f
01a09b0f-e450-7047-a3eb-00ceecd912d1	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-29	7.1900	f
01a09b0f-e450-7079-add2-c71cc28f1498	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-30	12.5600	f
01a09b0f-e450-709d-a068-6e0e5f702149	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-20	17.1000	f
01a09b0f-e450-70d4-b0d4-733d1ecabb50	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-22	13.6050	f
01a09b0f-e450-70ee-a1c3-39cccb58fe28	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-15	6.1100	f
01a09b0f-e450-70f5-978c-b16b3125d3da	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-23	6.8800	f
01a09b0f-e450-7100-8eed-1df18fa4f330	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-17	7.7300	f
01a09b0f-e450-7153-b9b0-85586030867d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-17	6.4600	f
01a09b0f-e450-71cb-ad54-d5e4df81503f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-17	14.6600	f
01a09b0f-e450-71d2-bd31-58f6bae15896	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-10	5.6400	f
01a09b0f-e450-71fc-9870-944dbb8f1e32	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-10	9.6000	f
01a09b0f-e450-7258-8a36-aa3bd91a0ad5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-15	15.1600	f
01a09b0f-e450-7278-af77-98543a5c17a5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-03	12.2500	f
01a09b0f-e450-727f-8689-75bde376b76e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-23	13.6100	f
01a09b0f-e450-7332-88b0-f3118577fa88	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-08	5.6100	f
01a09b0f-e450-7358-aa78-652360763794	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-24	6.8600	f
01a09b0f-e450-7362-92f7-ebfb710a6d70	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-04	10.4600	f
01a09b0f-e450-73a4-a173-37854d7cb4d1	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-16	5.8900	f
01a09b0f-e450-73bd-8e6f-bc0b12d672ce	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-01	7.3000	f
01a09b0f-e450-73e9-9542-1721d3e6f18c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-06	8.8350	f
01a09b0f-e450-7465-ab74-69bb436e5509	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-30	7.2200	f
01a09b0f-e450-7470-b31b-ec214191f4a5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-11	9.1200	f
01a09b0f-e450-74f3-a81e-846611ac400f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-13	7.9100	f
01a09b0f-e450-7511-9e18-616595f269f5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-08	7.7400	f
01a09b0f-e450-7518-9458-d035b8e26eef	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-25	8.0300	f
01a09b0f-e450-751a-a835-ab52aa76d6b9	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-14	12.5700	f
01a09b0f-e450-7521-9cd1-ae4c20f56cb2	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-28	8.7400	f
01a09b0f-e450-756c-a904-6452ac59eab4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-28	12.8300	f
01a09b0f-e450-757f-9d6d-621f7939e11b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-26	6.4300	f
01a09b0f-e450-764c-86dd-f3100e4c2e48	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-29	13.5700	f
01a09b0f-e450-765e-b1ed-d49a05367bc5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-16	15.6300	f
01a09b0f-e450-7685-86d9-918281d3c43e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-26	8.3400	f
01a09b0f-e450-769a-9d8f-20d2370ee706	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-11	6.0800	f
01a09b0f-e450-76df-a694-2a46431dbe24	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-18	6.7300	f
01a09b0f-e450-77cf-8376-6b5babe70beb	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-07	7.8400	f
01a09b0f-e450-77db-bbba-f40196bac619	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-02	8.1950	f
01a09b0f-e450-780b-abf7-864e849a2411	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-05	9.8600	f
01a09b0f-e450-781f-8d4d-7870ea8351fb	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-25	6.5100	f
01a09b0f-e450-7848-bc36-5335825b0925	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-14	8.1100	f
01a09b0f-e450-786e-a466-a6c5e2d1a216	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-07	7.7800	f
01a09b0f-e450-795f-ae86-cae889b932e7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-13	9.9700	f
01a09b0f-e450-7a95-bd67-ba00f444b2cd	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-01	8.3000	f
01a09b0f-e450-7ac0-a5f1-54fa01eb83e5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-12	8.6400	f
01a09b0f-e450-7b21-8911-03906deab198	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-21	7.5600	f
01a09b0f-e450-7b81-b13b-6239221c0d0f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-24	14.0700	f
01a09b0f-e450-7c09-8388-0ca5b847369c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-24	8.2900	f
01a09b0f-e450-7c09-8e80-03391c93898b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-22	7.1600	f
01a09b0f-e450-7c24-915c-519bdfe1ea74	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-20	7.5500	f
01a09b0f-e450-7c3e-9889-4590524b7e57	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-19	7.7200	f
01a09b0f-e450-7c6a-9d00-b039649dc37e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-10	8.2300	f
01a09b0f-e450-7d5e-86de-0e756d173558	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-31	13.4600	f
01a09b0f-e450-7e38-b1f2-060287bfa20d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-09	8.0000	f
01a09b0f-e450-7e5e-8864-a1af54ee9e67	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-19	7.0100	f
01a09b0f-e450-7e60-8808-a12926d5f13e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-06	8.1300	f
01a09b0f-e450-7ebe-a887-539daa26f4ad	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-09	5.7600	f
01a09b0f-e450-7f42-ab5f-e4f2204a8f51	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-27	13.9100	f
01a09b0f-e450-7fbb-8cc8-4d4d205a1d8b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-10-21	15.0300	f
01a09b0f-e450-7fd4-97f8-a92298bfcd95	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-11-18	7.7800	f
01a09b0f-e450-7ffe-999c-3a82e7931279	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-09-12	6.1700	f
01a09b0f-e451-7029-b266-4542d2208659	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-14	22.3200	f
01a09b0f-e451-703a-af47-3a9df744a6d7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-30	16.5000	f
01a09b0f-e451-7040-9ebe-a3cb68515dae	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-10	9.1200	f
01a09b0f-e451-7056-9fe9-2d526fc2f8a3	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-13	10.1000	f
01a09b0f-e451-70de-a2bd-68e90e641a9b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-26	9.5100	f
01a09b0f-e451-70f6-a6c1-b1d1bb752df5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-04	9.2200	f
01a09b0f-e451-70fd-b0ea-6f3862834bdd	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-02	8.6200	f
01a09b0f-e451-714d-80ee-176bde28af18	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-07	10.3100	f
01a09b0f-e451-7150-9720-9f08bf8a9a37	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-27	18.3000	f
01a09b0f-e451-7156-b041-18df66f5dc17	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-16	10.9100	f
01a09b0f-e451-7174-8256-67294f7f116b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-04	8.2000	f
01a09b0f-e451-7183-b8a3-198c1c133d1d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-22	18.4700	f
01a09b0f-e451-71ab-8550-5e6256176efa	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-18	8.0900	f
01a09b0f-e451-71c2-99b4-c51419281072	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-06	10.1900	f
01a09b0f-e451-7212-9ee1-3d74d538ea86	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-08	9.6000	f
01a09b0f-e451-724e-8e83-e00aad6fa175	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-06	8.8600	f
01a09b0f-e451-7288-8b05-b00fe2fa2910	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-12	8.3700	f
01a09b0f-e451-72e4-956c-5f75ee424772	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-26	9.0200	f
01a09b0f-e451-7326-83c1-d2f700af7598	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-20	13.2000	f
01a09b0f-e451-7332-b749-eb0101daa03f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-19	9.1700	f
01a09b0f-e451-737c-8079-dcf8cc8ee75d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-13	9.4550	f
01a09b0f-e451-737d-be76-64dd3fd6a834	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-09	8.3800	f
01a09b0f-e451-73b0-9feb-0984abda0198	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-09	10.0700	f
01a09b0f-e451-73c4-a9ed-fbb367fae28c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-30	7.8300	f
01a09b0f-e451-73cd-9567-071afdbeb736	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-17	8.2200	f
01a09b0f-e451-73e0-8b29-f0d8274c7a75	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-12	10.4300	f
01a09b0f-e451-7427-88a0-23f54ff26030	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-02	8.8000	f
01a09b0f-e451-743e-8a4b-1081c8506c6e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-17	7.3800	f
01a09b0f-e451-7487-9570-e434a88bb1dc	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-09	9.1700	f
01a09b0f-e451-7494-bbce-8fb5cc6a3c55	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-29	7.2100	f
01a09b0f-e451-7495-80ad-b8bfb211578e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-30	8.5800	f
01a09b0f-e451-749c-9e98-c2c81f1026c8	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-02	8.3200	f
01a09b0f-e451-7521-9731-017cfb60e26e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-09	9.4200	f
01a09b0f-e451-754a-9b78-26c88289c555	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-24	7.6600	f
01a09b0f-e451-754c-86bf-ceaecd753040	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-16	12.3700	f
01a09b0f-e451-7553-b2bc-6efee49bac58	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-07	15.7900	f
01a09b0f-e451-7574-b9d0-dafc32f084b0	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-27	8.2800	f
01a09b0f-e451-75ba-b7ed-dbe414a094ad	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-05	9.0500	f
01a09b0f-e451-75d1-a19a-316990ef7300	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-23	9.1800	f
01a09b0f-e451-75e1-824c-aca30135441c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-20	9.8600	f
01a09b0f-e451-7601-ab50-310574e32c78	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-21	9.7600	f
01a09b0f-e451-7604-9df1-72f07c5782f9	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-08	18.2000	f
01a09b0f-e451-7631-8f20-1930d6b64b48	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-08	9.5500	f
01a09b0f-e451-7634-aadd-64b819a9380e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-26	9.3800	f
01a09b0f-e451-7639-9bad-bbe493008641	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-06	8.8350	f
01a09b0f-e451-763a-ac49-f0cebdf19c9d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-22	7.9000	f
01a09b0f-e451-7649-b4e2-a8be8f31ab37	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-06	16.6800	f
01a09b0f-e451-765f-aba7-7edc7e59c8b7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-25	9.8800	f
01a09b0f-e451-7668-a942-5679d7c21d18	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-17	12.3200	f
01a09b0f-e451-768b-89d9-8ab65eda5c26	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-01	17.4500	f
01a09b0f-e451-7694-aa73-9fa214dffa49	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-11	8.7600	f
01a09b0f-e451-76ae-ad23-fa9e0589eb48	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-30	7.2400	f
01a09b0f-e451-76df-8604-bab744e0c088	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-20	8.7500	f
01a09b0f-e451-76f4-8746-573f4fa52a0d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-12	8.5900	f
01a09b0f-e451-7735-97eb-1548f7b3f423	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-27	9.5600	f
01a09b0f-e451-775a-b3fe-2214d6deecf4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-31	7.1400	f
01a09b0f-e451-77d2-8ef2-a08a88429dd8	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-26	7.4000	f
01a09b0f-e451-7804-95d5-15f2fe217da4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-29	15.4800	f
01a09b0f-e451-783b-8561-367ac8659e5f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-15	7.9600	f
01a09b0f-e451-7875-a6f9-4673d24f56b9	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-24	17.2800	f
01a09b0f-e451-7890-97fa-a4f730a33cfc	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-11	10.8400	f
01a09b0f-e451-789a-88d0-bcd68fb727e9	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-31	8.7700	f
01a09b0f-e451-78d1-a2f9-f4f2e1167c72	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-28	10.1900	f
01a09b0f-e451-78f8-b16e-d41572baed12	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-11	9.1800	f
01a09b0f-e451-792f-b690-a0996098cb36	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-05	8.9600	f
01a09b0f-e451-795a-9f46-42fa1a8ec735	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-13	9.8200	f
01a09b0f-e451-796e-abd1-9a370ba2c420	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-06	8.2000	f
01a09b0f-e451-79bc-8d45-58468d69afa4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-05	17.5500	f
01a09b0f-e451-79d1-97dc-f6e2d7c94372	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-18	19.6700	f
01a09b0f-e451-79d5-a151-51ae3ef456ad	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-23	18.5100	f
01a09b0f-e451-79d6-a4ed-04ab377ef563	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-12	9.9800	f
01a09b0f-e451-79e3-b7b5-313e3a211946	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-15	21.3200	f
01a09b0f-e451-79f4-957b-17d5d64ac6d0	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-14	9.8700	f
01a09b0f-e451-7a10-9252-4adf52bbab39	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-09	9.2200	f
01a09b0f-e451-7a37-9509-f4cc88cbb7ed	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-08	10.0600	f
01a09b0f-e451-7a4d-9d29-ed37b7179c47	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-10	8.6800	f
01a09b0f-e451-7a7e-8170-edec6818d76a	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-11	22.6500	f
01a09b0f-e451-7ab5-b284-552203ce708f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-07	8.5700	f
01a09b0f-e451-7af7-b691-e0980309531e	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-05	9.4800	f
01a09b0f-e451-7b53-a594-09de55a08eff	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-24	9.2800	f
01a09b0f-e451-7b5e-989a-1eeda1f6612b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-20	7.8800	f
01a09b0f-e451-7b6a-b3ed-cb3cb5e16f66	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-02	8.3800	f
01a09b0f-e451-7b86-bbd2-acb12766160b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-13	8.3000	f
01a09b0f-e451-7b96-ab55-178a33524e5b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-23	7.6600	f
01a09b0f-e451-7b97-8eb8-0496ec700cf4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-03	9.0500	f
01a09b0f-e451-7bcc-a9f9-e9a26aca22d4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-28	15.1200	f
01a09b0f-e451-7bef-81a6-42ad2cf791c5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-14	10.0400	f
01a09b0f-e451-7c24-8214-b81afd1bb64a	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-13	21.1700	f
01a09b0f-e451-7c47-943b-61d0c2329d58	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-04	15.9200	f
01a09b0f-e451-7cd3-9936-b8570f8b4e95	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-02	9.5500	f
01a09b0f-e451-7cd3-b733-91c739f07b93	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-10	8.7900	f
01a09b0f-e451-7cfe-86b3-a0d472ecd5e3	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-04	9.4500	f
01a09b0f-e451-7d01-bd56-441bdde74d52	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-18	7.3700	f
01a09b0f-e451-7d13-a29f-64829ca1f657	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-17	9.8200	f
01a09b0f-e451-7d32-91ec-a534d57e07bb	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-29	9.4600	f
01a09b0f-e451-7d73-b3b1-54846139eb7f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-25	9.4800	f
01a09b0f-e451-7d94-be2f-9351aa54aecf	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-19	7.8100	f
01a09b0f-e451-7da1-8beb-722a97ff4b4b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-12	19.2500	f
01a09b0f-e451-7e34-840e-fc29bd5fa57f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-01	8.5400	f
01a09b0f-e451-7e36-bf70-b1c1e6c12d77	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-24	8.2600	f
01a09b0f-e451-7e39-a0d6-672fddca365f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-23	8.1200	f
01a09b0f-e451-7e3b-8ccf-c1c9059a2299	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-03	8.6900	f
01a09b0f-e451-7e9a-afcf-22afd84220bd	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-22	11.2900	f
01a09b0f-e451-7ed8-92de-f39be673b783	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-10	9.5400	f
01a09b0f-e451-7ee6-aabc-0438657cec69	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-05	7.4300	f
01a09b0f-e451-7f0c-a7de-30fc8bc40c9f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-15	10.0000	f
01a09b0f-e451-7f23-a3a9-50fccb07fde6	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2025-12-16	7.8300	f
01a09b0f-e451-7f45-9fc3-72695e003a2f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-18	9.0600	f
01a09b0f-e451-7f5c-9d6a-7ceb195d662c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-19	8.0800	f
01a09b0f-e451-7f5e-b99f-769871f89024	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-03	8.9000	f
01a09b0f-e451-7fa9-a708-2dd15e50385b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-21	15.3300	f
01a09b0f-e451-7fc3-8d82-c2347949d024	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-02-27	9.0000	f
01a09b0f-e451-7fd0-a9b2-640ff607cf94	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-01-23	10.1700	f
01a09b0f-e451-7fd2-9b5a-6e698bac3a33	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-04-15	10.2600	f
01a09b0f-e451-7fd4-a850-43769794b75f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-03-16	10.4900	f
01a09b0f-e452-7044-90dc-284bfb7bbeb7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-07	13.9900	f
01a09b0f-e452-706d-844e-eda91e6e8936	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-25	17.7000	f
01a09b0f-e452-7089-bee8-386b9108a674	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-06	15.2300	f
01a09b0f-e452-70b3-9273-118b671da1a8	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-05	12.3500	f
01a09b0f-e452-7145-bf71-6586798ca651	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-26	17.3000	f
01a09b0f-e452-714d-bfd1-303e8f8778cd	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-29	26.6000	f
01a09b0f-e452-71d7-8063-bd4b24d8b5c0	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-29	17.7400	f
01a09b0f-e452-71dc-a4fd-db60a15465e7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-17	11.4600	f
01a09b0f-e452-71de-b154-d2ff94b7bb30	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-11	13.6000	f
01a09b0f-e452-7234-8421-908f7fba88fd	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-05	25.0800	f
01a09b0f-e452-724c-ae4e-ae6131ec8226	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-30	17.9200	f
01a09b0f-e452-72c0-a229-85941dd016c4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-10	20.5000	f
01a09b0f-e452-7366-8639-1c54ca4a5773	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-16	11.7550	f
01a09b0f-e452-7395-b034-8e737b78e2ec	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-01	24.8600	f
01a09b0f-e452-73d2-a9de-10f5125a295f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-16	22.0900	f
01a09b0f-e452-740f-ab5b-3c0c11e4d0ac	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-02	25.8600	f
01a09b0f-e452-7437-8455-41498e963b70	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-20	22.9900	f
01a09b0f-e452-7484-88df-0aa7f6d25202	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-22	29.2500	f
01a09b0f-e452-748e-913a-e857d80021a2	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-01	16.5300	f
01a09b0f-e452-74dd-a2ab-9297fdbc1bfe	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-23	12.0300	f
01a09b0f-e452-74ec-9a11-6f91cdfe692f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-10	13.1700	f
01a09b0f-e452-7577-93dc-f77dfcb2f0d1	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-12	13.9300	f
01a09b0f-e452-75b0-835c-22cb7750b792	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-20	11.5400	f
01a09b0f-e452-7616-8bbe-4156b458187a	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-24	18.3200	f
01a09b0f-e452-76af-b85f-7e0d99fc4481	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-21	12.8250	f
01a09b0f-e452-76b2-bad6-654dbc9bb0f6	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-31	10.8600	f
01a09b0f-e452-76fe-938b-e483a39cf493	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-23	21.4000	f
01a09b0f-e452-7704-a758-763ada377416	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-24	10.9200	f
01a09b0f-e452-778c-80c7-ea2201de45d4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-04	12.6900	f
01a09b0f-e452-77b8-98fe-a242790222c6	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-12	23.3900	f
01a09b0f-e452-77b8-9e57-b87152f08aa8	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-07	13.8900	f
01a09b0f-e452-77eb-8fa2-c6d29e974865	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-30	11.0100	f
01a09b0f-e452-7842-b774-76955752545d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-09	14.1800	f
01a09b0f-e452-7849-b09d-f1fb8dfd45ca	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-03	30.8400	f
01a09b0f-e452-78d4-b962-536e629ee90d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-27	28.8800	f
01a09b0f-e452-791f-b338-256ccf2eb868	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-11	22.2100	f
01a09b0f-e452-7a41-b61d-8a2885bb52c5	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-19	19.4300	f
01a09b0f-e452-7a78-9cc8-4f84e12cae18	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-22	23.7000	f
01a09b0f-e452-7a7e-ba59-4bfa4f2b79ad	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-15	23.7300	f
01a09b0f-e452-7a8d-a745-b8f026b92303	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-28	10.0100	f
01a09b0f-e452-7a91-bfb7-7ed82308ad58	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-13	12.8700	f
01a09b0f-e452-7a9c-8e5d-91bc858a6b0f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-26	31.7900	f
01a09b0f-e452-7a9e-aaeb-f93814fd42d0	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-06	12.4000	f
01a09b0f-e452-7c06-8033-dad0a3bee396	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-22	12.6700	f
01a09b0f-e452-7c25-bd20-ac89fefe0cb4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-03	11.5200	f
01a09b0f-e452-7c3f-aa0e-19cbea2db50d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-10	13.4700	f
01a09b0f-e452-7c79-b3b4-a31ab04a4970	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-02	14.4600	f
01a09b0f-e452-7d57-a807-42d5a522a027	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-04	30.6700	f
01a09b0f-e452-7d9c-a606-c2c9e500ca9b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-08	13.3600	f
01a09b0f-e452-7dc7-8355-fce3a52ddd5f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-27	11.4100	f
01a09b0f-e452-7def-bd53-9bbe950965b1	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-28	28.5100	f
01a09b0f-e452-7e06-9477-f668278dacd9	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-09	22.8500	f
01a09b0f-e452-7e36-877e-53eabe48f143	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-08	24.4800	f
01a09b0f-e452-7e50-94fc-b7bf6d0c30ad	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-14	13.0900	f
01a09b0f-e452-7e65-8cdf-f618c7fe5701	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-15	13.2700	f
01a09b0f-e452-7eac-ae8b-29b2e4f7c834	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-17	22.3400	f
01a09b0f-e452-7f33-9ac2-c638aeb0d5df	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-07-29	9.7350	f
01a09b0f-e452-7f55-8a8d-df061ca9d681	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-06-18	24.0200	f
01a09b0f-e452-7ff5-98a4-f320fb3034ba	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-05-21	24.3800	f
01a09b0f-e453-71e2-91b7-c7d2739507e7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-25	12.4400	f
01a09b0f-e453-7216-9521-86a3e1edef80	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-17	14.5800	f
01a09b0f-e453-7219-b6eb-1afe792bc55b	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-03	11.1000	f
01a09b0f-e453-7281-ae08-2a9f8815ae4d	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-31	11.5900	f
01a09b0f-e453-72c6-8b8f-f1cfe7fbeca4	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-14	14.4500	f
01a09b0f-e453-7330-b8a0-a0a632bd9bf8	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-27	12.5100	f
01a09b0f-e453-73b9-bb08-76b2f143929a	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-08	12.0000	f
01a09b0f-e453-73bc-8f51-d95144458797	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-28	11.4900	f
01a09b0f-e453-745f-8d15-0f9a821ba035	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-09	11.6000	f
01a09b0f-e453-758d-b1f4-6a04264c28d7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-18	13.1700	f
01a09b0f-e453-76a7-bb58-bc369d05d6c7	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-19	12.8300	f
01a09b0f-e453-7862-908c-6ac2fb77f1bd	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-20	12.9700	f
01a09b0f-e453-78fd-91e6-1c56ea8678a1	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-21	12.9700	f
01a09b0f-e453-790a-a1ed-2ca32c4a9294	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-01	10.9400	f
01a09b0f-e453-7957-baa8-51bd981582f6	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-26	12.6700	f
01a09b0f-e453-7aff-9853-da819f551bd0	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-02	11.2100	f
01a09b0f-e453-7ca8-acbe-cd07422c8076	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-10	11.1500	f
01a09b0f-e453-7dc0-b24e-aa440b23522c	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-04	11.8000	f
01a09b0f-e453-7e53-9838-319e2cc880d6	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-24	12.2300	f
01a09b0f-e453-7f8f-8b6c-9db88f579817	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-08-13	13.6600	f
01a09b0f-e454-7968-97a7-52efdcdf0a3f	01a09aec-feb5-7a7e-9e46-faa24a3b0d4f	2026-09-11	11.6300	f
01a09b0f-e4f0-70b8-9791-06805604e5c9	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-11	168.8350	f
01a09b0f-e4f0-7c19-81d2-765ad4bcfcfb	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-08	172.9500	f
01a09b0f-e4f1-700c-b34f-03c48b29aaf3	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-26	210.3750	f
01a09b0f-e4f1-7010-b34f-f413bbfab783	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-23	190.1900	f
01a09b0f-e4f1-7022-b24b-44bb609d800a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-14	209.8650	f
01a09b0f-e4f1-70ae-809d-ecd2e6148a86	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-06	199.6900	f
01a09b0f-e4f1-70c1-bdc0-df983f7a9ad6	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-29	237.3050	f
01a09b0f-e4f1-70e5-b7fe-27f1f1ca6ecc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-22	201.9650	f
01a09b0f-e4f1-70e8-87e7-79904a4b729a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-29	208.9950	f
01a09b0f-e4f1-7132-b3f1-f220bac921dc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-05	212.4300	f
01a09b0f-e4f1-7136-b576-662b676d0430	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-07	197.8300	f
01a09b0f-e4f1-7138-aeaf-31cc3a78fc33	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-15	226.7150	f
01a09b0f-e4f1-7145-973c-c24480e877db	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-31	195.9400	f
01a09b0f-e4f1-7149-bfe3-15b1269964f4	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-24	201.3750	f
01a09b0f-e4f1-71cf-8a42-b851f9d2f7b8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-04	201.1450	f
01a09b0f-e4f1-71fd-b131-139e75c87bff	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-08	180.4400	f
01a09b0f-e4f1-7204-bbe3-a67dd6a4d1c8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-24	218.4900	f
01a09b0f-e4f1-7256-aff6-954b76747e68	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-20	178.9700	f
01a09b0f-e4f1-7261-9288-57f2a0b743f8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-29	198.9350	f
01a09b0f-e4f1-7264-b6c3-e933da40091f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-28	209.2850	f
01a09b0f-e4f1-727c-8339-fb2a1401c83b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-21	163.8650	f
01a09b0f-e4f1-72b4-bab1-4ad40e5c8733	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-17	179.8150	f
01a09b0f-e4f1-72b6-af7c-d00735802ea9	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-06	197.9750	f
01a09b0f-e4f1-72bb-a172-98294b9467db	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-15	184.8700	f
01a09b0f-e4f1-72da-afde-a0ac51898f9d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-27	206.3500	f
01a09b0f-e4f1-72df-9ac7-5b5275bb4a54	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-25	203.7500	f
01a09b0f-e4f1-72f0-947e-778c21d7bbd7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-25	176.9850	f
01a09b0f-e4f1-72fa-8e40-87119793c981	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-26	234.1050	f
01a09b0f-e4f1-7326-8a00-72dcceef0681	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-23	230.7550	f
01a09b0f-e4f1-734c-8344-b63d64838dea	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-12	230.0800	f
01a09b0f-e4f1-735e-8246-a12cbffd645d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-07	199.5150	f
01a09b0f-e4f1-73d4-828b-d6beb259f7cd	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-13	179.1800	f
01a09b0f-e4f1-73ed-a397-4028ceb2dd82	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-30	198.8250	f
01a09b0f-e4f1-73fa-b8cf-fa27f68202e0	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-02	203.4550	f
01a09b0f-e4f1-73fb-bbd8-661c73d5a3c3	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-05	204.4750	f
01a09b0f-e4f1-7434-ad86-0b980b08fe33	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-17	178.8550	f
01a09b0f-e4f1-7441-943c-21cdf4012393	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-21	185.5950	f
01a09b0f-e4f1-745f-a40c-0a5c580a0407	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-21	237.2150	f
01a09b0f-e4f1-7484-9e9a-1b891887e62c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-27	238.4850	f
01a09b0f-e4f1-748f-ad95-65709ede5137	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-09	194.9600	f
01a09b0f-e4f1-74a9-9914-6fa3193534c2	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-09	197.9400	f
01a09b0f-e4f1-74c6-9b2f-577417a573bc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-10	180.7800	f
01a09b0f-e4f1-74fd-81ec-a0c94227a2ce	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-20	196.5300	f
01a09b0f-e4f1-7517-890d-bb70b6d1dd84	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-19	205.0600	f
01a09b0f-e4f1-7555-b35d-0571aa9aede8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-11	188.4650	f
01a09b0f-e4f1-7572-b7c5-e605d1095fa7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-12	194.6250	f
01a09b0f-e4f1-7576-b1b1-3c4a5161716b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-16	230.0450	f
01a09b0f-e4f1-7588-b2f1-4d3e31590d31	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-15	216.3450	f
01a09b0f-e4f1-758c-9f1f-f6a844180124	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-03	197.7900	f
01a09b0f-e4f1-759c-a1bd-8680d23d0205	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-30	197.2000	f
01a09b0f-e4f1-75a7-a6a0-f725b23b8383	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-23	204.1150	f
01a09b0f-e4f1-75ef-8234-fa59fecbdd95	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-26	179.1950	f
01a09b0f-e4f1-75f6-ae47-3c93f60b9f36	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-26	201.5900	f
01a09b0f-e4f1-763a-9dbb-cb1021c9b52f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-03	171.3100	f
01a09b0f-e4f1-7647-a98e-60c96d151e9b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-30	194.5750	f
01a09b0f-e4f1-764f-8743-5e272096ce8d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-03	210.3100	f
01a09b0f-e4f1-7689-8246-0c08703e9133	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-18	201.8750	f
01a09b0f-e4f1-769e-b05d-0c7e2333f65b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-25	190.0050	f
01a09b0f-e4f1-76a8-9ceb-abe69bb92995	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-02	173.8700	f
01a09b0f-e4f1-76e1-a3fd-8c2fb5ce2537	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-14	182.3550	f
01a09b0f-e4f1-76e7-9137-8a09b6997cd0	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-01	195.8050	f
01a09b0f-e4f1-773e-9aa9-ee8b44ccd62c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-12	209.8800	f
01a09b0f-e4f1-7759-b880-2eb1f28006b7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-27	177.9200	f
01a09b0f-e4f1-775c-90d0-49c0d52e07dc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-28	205.3100	f
01a09b0f-e4f1-7773-9242-64c5d2042e27	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-24	190.5700	f
01a09b0f-e4f1-7784-9ffb-b65301f5df10	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-08	221.2800	f
01a09b0f-e4f1-77a3-b182-72ba136ad813	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-18	168.1150	f
01a09b0f-e4f1-77be-943f-fdfca0f333b5	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-08	200.0000	f
01a09b0f-e4f1-77c7-b5de-d2df962fb20c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-16	183.4400	f
01a09b0f-e4f1-7852-9d18-76843da7c661	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-28	237.5200	f
01a09b0f-e4f1-7858-9474-76ea1b53ab16	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-19	184.8850	f
01a09b0f-e4f1-7891-8d03-34987b9a0073	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-20	225.9300	f
01a09b0f-e4f1-78a1-80a3-2ccab32ecb84	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-24	203.1850	f
01a09b0f-e4f1-78be-8d2a-d6f28b15777b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-21	198.2400	f
01a09b0f-e4f1-78cd-a5a4-8105ba86c508	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-26	196.4250	f
01a09b0f-e4f1-78f4-b283-2d63b3847741	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-18	179.1400	f
01a09b0f-e4f1-791a-b7af-4d1110d99b52	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-22	235.5600	f
01a09b0f-e4f1-7924-badb-bddc2ed8f952	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-29	174.6550	f
01a09b0f-e4f1-7934-bf0d-65c8933ba186	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-18	188.7500	f
01a09b0f-e4f1-7965-8937-ba3acc61463f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-30	190.1450	f
01a09b0f-e4f1-7993-8faf-3296448efaf5	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-05	204.8400	f
01a09b0f-e4f1-79c6-86df-e181042546df	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-03	191.5100	f
01a09b0f-e4f1-79c7-a3ab-0cefcd0e9823	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-17	193.1000	f
01a09b0f-e4f1-79c8-9b3a-845781a0a9d5	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-07	195.5700	f
01a09b0f-e4f1-79e0-bb1d-822b41fe47e7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-02	200.6100	f
01a09b0f-e4f1-79fc-829e-02e47a49d8de	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-04	179.5700	f
01a09b0f-e4f1-7a74-a32c-26f62403b035	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-15	166.0800	f
01a09b0f-e4f1-7a80-b87f-ca00b5b1d469	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-12	188.7650	f
01a09b0f-e4f1-7aae-9b57-c8a3d6a29f52	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-15	195.7750	f
01a09b0f-e4f1-7ae9-92e5-fa0c837c52d4	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-22	170.5550	f
01a09b0f-e4f1-7b0d-9c54-21ad7cb2253b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-16	191.8100	f
01a09b0f-e4f1-7b1d-815a-ef543b881887	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-10	190.5950	f
01a09b0f-e4f1-7b31-a4a5-8cbf778cd9f3	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-31	194.5100	f
01a09b0f-e4f1-7b6f-bf03-1c1403c1522d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-20	160.7950	f
01a09b0f-e4f1-7b86-a04c-e1ac69c28846	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-29	195.4450	f
01a09b0f-e4f1-7bb9-b5dd-3e96d837c99a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-10	235.4200	f
01a09b0f-e4f1-7bd3-93a4-28a2d75f3f3e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-10	201.4100	f
01a09b0f-e4f1-7be2-9bcc-a457c939ade2	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-23	193.6550	f
01a09b0f-e4f1-7bea-9307-9669035661b4	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-06	206.1350	f
01a09b0f-e4f1-7c0c-a3f5-4e08734efbf2	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-09	226.9750	f
01a09b0f-e4f1-7c0e-a315-6837dcd300d6	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-05	214.3100	f
01a09b0f-e4f1-7c13-b649-bbf867bf2f1b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-13	193.9200	f
01a09b0f-e4f1-7c15-8fb2-7c10c840c94c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-22	194.8850	f
01a09b0f-e4f1-7c3f-ac68-38d043274a07	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-05	174.8200	f
01a09b0f-e4f1-7c3f-b497-c70a8befbf1f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-12	176.8550	f
01a09b0f-e4f1-7c63-8d3c-211c1f6630ce	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-22	179.9900	f
01a09b0f-e4f1-7cb1-9722-378a0a3d4574	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-04	193.5650	f
01a09b0f-e4f1-7cd9-a478-a9a3865d070e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-09	180.7350	f
01a09b0f-e4f1-7d35-b008-db717869cbca	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-17	199.1500	f
01a09b0f-e4f1-7d3f-8004-66cd2ac7b143	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-16	223.6750	f
01a09b0f-e4f1-7d73-9499-5864df0fcbfb	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-01	202.1200	f
01a09b0f-e4f1-7df5-b785-4f1dccc52e8b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-02	194.4550	f
01a09b0f-e4f1-7e03-a6b6-fe7074ba2cbf	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-14	167.4200	f
01a09b0f-e4f1-7e67-ae2b-2018b7b8b02e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-04	210.3650	f
01a09b0f-e4f1-7e76-9bc0-868fc5cfea2c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-03	209.6650	f
01a09b0f-e4f1-7e98-bba1-cfd08aa5a62e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-02	208.5000	f
01a09b0f-e4f1-7ec8-b167-ca8d1f87852d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-10-14	197.4950	f
01a09b0f-e4f1-7edc-94c2-d957fc50fd67	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-13	174.1650	f
01a09b0f-e4f1-7f41-90ec-bdb0a42a327a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-19	162.3700	f
01a09b0f-e4f1-7f5f-b47d-a7e210852d2c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-08-28	181.1650	f
01a09b0f-e4f1-7fa2-90c3-0e826647950d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-12-11	238.8850	f
01a09b0f-e4f1-7fb3-b1bf-30c63765290e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-09-19	189.7100	f
01a09b0f-e4f1-7fba-9dcc-7dd2a303e1d7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-13	216.0950	f
01a09b0f-e4f1-7fcc-8c80-bd230014f8fd	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2025-11-11	197.3250	f
01a09b0f-e4f1-7fff-8454-226d4495dab2	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-01-08	186.8150	f
01a09b0f-e4f2-7019-86fb-5e950f23ae4c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-12	374.9150	f
01a09b0f-e4f2-703b-91c4-547e2e0cb731	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-13	338.8900	f
01a09b0f-e4f2-7056-8b46-150344d81951	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-16	304.7900	f
01a09b0f-e4f2-7073-9376-bfbc4fb85db6	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-24	247.8600	f
01a09b0f-e4f2-70a3-ac8d-6fb3a02c729e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-17	250.4250	f
01a09b0f-e4f2-70b9-854b-57c4e6825fae	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-19	227.3150	f
01a09b0f-e4f2-7126-8db7-ec49662b6767	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-31	372.2700	f
01a09b0f-e4f2-7135-9cb6-94fa00c5713c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-16	226.1200	f
01a09b0f-e4f2-713b-916c-b9dcc00ab4f6	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-09	363.1550	f
01a09b0f-e4f2-7144-bf3f-158bb8de0fd8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-29	286.0050	f
01a09b0f-e4f2-7199-b834-609a0bb115c4	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-11	221.0700	f
01a09b0f-e4f2-71b0-8628-aeaa59c214d8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-05	360.3600	f
01a09b0f-e4f2-720f-8dc6-abbcfeff1a6e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-28	300.5000	f
01a09b0f-e4f2-721b-afbf-068578237b19	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-05	330.7000	f
01a09b0f-e4f2-721e-b190-9835a407d5ab	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-27	247.6750	f
01a09b0f-e4f2-724e-8b80-dcd95181289f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-23	293.0850	f
01a09b0f-e4f2-7295-beec-8baaf731978d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-27	303.4850	f
01a09b0f-e4f2-72a0-91d2-48734e552bbe	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-14	348.6050	f
01a09b0f-e4f2-72b3-b46b-b0b22e6362e0	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-13	259.0800	f
01a09b0f-e4f2-72bc-b971-ffa8fc98d34e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-16	241.6900	f
01a09b0f-e4f2-72f9-be0e-05740000025d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-06	227.9400	f
01a09b0f-e4f2-730f-99bc-4838a98f92d8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-13	221.3800	f
01a09b0f-e4f2-7318-9bd1-8da68e3cd92a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-08	309.6450	f
01a09b0f-e4f2-7322-9d72-bb94aa11ddff	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-02	352.4450	f
01a09b0f-e4f2-7327-bded-921b634f9af7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-13	269.7300	f
01a09b0f-e4f2-732f-b9dd-5b7e95b18bb8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-09	267.8600	f
01a09b0f-e4f2-7345-bbde-6d51b5ece5e8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-01	349.9900	f
01a09b0f-e4f2-73d8-b9c3-73e538e609bc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-06	335.3950	f
01a09b0f-e4f2-73ea-8aa5-f21ed99eec7b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-19	253.4700	f
01a09b0f-e4f2-73fd-b38b-180c412e0b6f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-17	306.5100	f
01a09b0f-e4f2-7408-a85f-ab6b620ca713	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-08	333.3500	f
01a09b0f-e4f2-741c-b606-b1f116e276cd	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-29	339.1750	f
01a09b0f-e4f2-7444-9eb9-0e0d4a659252	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-19	319.7200	f
01a09b0f-e4f2-7452-ae75-f3081a5eb735	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-11	342.5550	f
01a09b0f-e4f2-7469-b987-e87a48e10c81	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-09	321.3850	f
01a09b0f-e4f2-7499-93ef-cccaca2fec8a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-30	285.7700	f
01a09b0f-e4f2-749d-a030-90e236300af3	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-23	236.0000	f
01a09b0f-e4f2-74ae-ace9-8f604ce2be12	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-30	322.0400	f
01a09b0f-e4f2-74ea-9651-b90c7c8d647c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-15	363.2050	f
01a09b0f-e4f2-7507-b047-a2ea4cdf8208	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-09	244.7600	f
01a09b0f-e4f2-7548-8cdf-71b467c19149	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-02	241.2500	f
01a09b0f-e4f2-7561-88d5-8c16a18a8a0f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-05	213.0050	f
01a09b0f-e4f2-7569-acb9-6d5ffab98831	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-22	377.3700	f
01a09b0f-e4f2-75cb-8890-2716d7b847f8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-20	259.8350	f
01a09b0f-e4f2-75cf-bd48-dd925888f711	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-31	238.2350	f
01a09b0f-e4f2-75d9-81b4-9238c0b80147	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-20	310.5200	f
01a09b0f-e4f2-7618-aa21-5e807ce62349	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-21	282.0950	f
01a09b0f-e4f2-761d-9e52-478ef037042a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-20	276.6400	f
01a09b0f-e4f2-764b-ada8-96f6d473907f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-14	308.0750	f
01a09b0f-e4f2-7663-b2c8-3e25a9f453b2	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-15	341.1000	f
01a09b0f-e4f2-7673-b675-5cdaf0e7a70e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-15	264.6100	f
01a09b0f-e4f2-7674-b21e-e24cf074ea49	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-17	268.7900	f
01a09b0f-e4f2-7685-8b15-2845315e6c76	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-04	371.0450	f
01a09b0f-e4f2-76c1-b5ef-83783ad47a27	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-24	313.0350	f
01a09b0f-e4f2-77ac-8833-6f97609004b1	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-29	248.1100	f
01a09b0f-e4f2-77df-a4ba-c1d309295141	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-20	327.9400	f
01a09b0f-e4f2-7814-8890-aa30d6414a67	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-25	252.3350	f
01a09b0f-e4f2-781c-ae17-8830d6767b19	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-24	299.9000	f
01a09b0f-e4f2-782f-bd4b-9f84c97e7b6d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-06	244.4650	f
01a09b0f-e4f2-7835-883b-a7b022d8083f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-26	234.4600	f
01a09b0f-e4f2-7849-8b3b-a9a71edaec0a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-21	323.9600	f
01a09b0f-e4f2-7875-bb63-34c6c7f29223	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-09	225.1350	f
01a09b0f-e4f2-78b9-9ed4-e1838a137c8c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-12	342.7400	f
01a09b0f-e4f2-78dc-92ea-3738a7926080	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-27	236.9300	f
01a09b0f-e4f2-7901-9fa3-d912cad0d673	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-27	301.6150	f
01a09b0f-e4f2-7905-9cf7-a3342e4937b8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-01	338.7150	f
01a09b0f-e4f2-7914-b513-164add199b40	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-11	365.6650	f
01a09b0f-e4f2-7926-a108-a01cdb374586	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-18	327.1400	f
01a09b0f-e4f2-792e-b822-71b9730418ea	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-17	342.5900	f
01a09b0f-e4f2-7955-b2b2-796f801b77b3	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-18	245.2450	f
01a09b0f-e4f2-796a-ba19-eea3020b6d6f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-03	362.2250	f
01a09b0f-e4f2-79f3-b159-2bf535c67fab	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-30	220.8600	f
01a09b0f-e4f2-79f8-9213-327ea6d1b143	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-26	348.4250	f
01a09b0f-e4f2-7a09-95bc-0641a7c58be8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-27	347.1000	f
01a09b0f-e4f2-7a0e-8471-2192e004c9fc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-07	304.7350	f
01a09b0f-e4f2-7a2c-b986-12727d56ef2e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-26	357.4500	f
01a09b0f-e4f2-7a5e-831c-9cd71c51dfa9	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-02	251.1850	f
01a09b0f-e4f2-7a5e-a485-333f92b37a46	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-06	215.3250	f
01a09b0f-e4f2-7a77-990e-a61f2eebbc4f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-29	361.4850	f
01a09b0f-e4f2-7aa3-9048-2976d35872db	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-01	241.9250	f
01a09b0f-e4f2-7aaf-9273-7d205f4ee579	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-26	257.5250	f
01a09b0f-e4f2-7ae0-90f5-3f01dcd5a5b4	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-10	312.7700	f
01a09b0f-e4f2-7ae1-a488-78ab5298d170	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-10	339.1000	f
01a09b0f-e4f2-7b05-81d1-115694a9157d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-16	347.9050	f
01a09b0f-e4f2-7b7d-9aff-4ce3ee24f3cf	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-15	312.9550	f
01a09b0f-e4f2-7b9d-bf3f-4771b8272aaf	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-28	349.4800	f
01a09b0f-e4f2-7ba2-9d3c-b5b685ce6362	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-07	332.8150	f
01a09b0f-e4f2-7bb6-9aaf-35d9aeb22ec8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-04	313.2100	f
01a09b0f-e4f2-7bb8-8c44-36acaff09b8c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-23	331.8500	f
01a09b0f-e4f2-7bbd-9f41-bb1e5d713d50	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-18	220.7800	f
01a09b0f-e4f2-7bc5-a434-78404b62a89a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-10	224.1900	f
01a09b0f-e4f2-7be6-b313-eb8327787d12	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-28	271.7450	f
01a09b0f-e4f2-7c2b-9072-84b25e3525cc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-20	218.4750	f
01a09b0f-e4f2-7c8f-97d4-0c3081688ceb	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-11	257.1800	f
01a09b0f-e4f2-7ca0-a0c9-a43723b735ba	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-08	367.4550	f
01a09b0f-e4f2-7cb4-bb02-0469f8b7127c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-23	252.8650	f
01a09b0f-e4f2-7cbb-b5b4-e86e55a9b4c7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-30	367.3300	f
01a09b0f-e4f2-7cbf-ba4a-3731b20051fc	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-22	329.8250	f
01a09b0f-e4f2-7cd8-a001-603339820a05	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-18	356.1950	f
01a09b0f-e4f2-7d0f-84e3-21a8ef8e340d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-22	291.1100	f
01a09b0f-e4f2-7d11-aef1-84ec82b714d0	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-24	256.7000	f
01a09b0f-e4f2-7d34-9b07-533996edd176	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-08	261.5050	f
01a09b0f-e4f2-7d37-a502-9bb84acf2e56	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-25	383.2700	f
01a09b0f-e4f2-7d4a-891d-f4d17837d9fd	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-17	225.1950	f
01a09b0f-e4f2-7d4f-99c3-1bf3ede298c0	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-07	240.9350	f
01a09b0f-e4f2-7d75-8ab8-de03d4f2abab	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-14	272.0700	f
01a09b0f-e4f2-7d97-afec-611fb7dbd4ed	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-10	249.8900	f
01a09b0f-e4f2-7da1-8042-362f8b9cd27b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-24	373.7450	f
01a09b0f-e4f2-7da1-8e06-39b19f73d278	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-04	243.8850	f
01a09b0f-e4f2-7da5-9467-7e3e434c21a8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-02-12	247.7450	f
01a09b0f-e4f2-7dc8-8efa-19ed99836984	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-02	327.0000	f
01a09b0f-e4f2-7dd6-bcfe-128e435cb754	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-03	362.4950	f
01a09b0f-e4f2-7dff-96f8-e236459006bd	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-01	327.8200	f
01a09b0f-e4f2-7e20-b81a-54ff9bab201c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-22	337.1000	f
01a09b0f-e4f2-7e56-af49-8606c138c2fa	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-06	336.9200	f
01a09b0f-e4f2-7e5d-b320-2da0dd55a424	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-05-21	323.9200	f
01a09b0f-e4f2-7f21-bf24-83e92fd7dca9	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-12	217.7500	f
01a09b0f-e4f2-7f41-b969-0a9602fe853e	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-07-13	301.4550	f
01a09b0f-e4f2-7f65-a985-f08bfac11840	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-04-10	266.3950	f
01a09b0f-e4f2-7f67-b34a-0d5e9d8082fe	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-03	243.7850	f
01a09b0f-e4f2-7f98-85c2-9bf9e31bae9a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-03-25	250.6350	f
01a09b0f-e4f2-7ffe-a4cb-c23878d61c9d	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-06-23	355.2700	f
01a09b0f-e4f3-70bf-a9c2-6e2d5721e085	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-19	348.6900	f
01a09b0f-e4f3-70c1-b31f-68f4f1708b9b	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-20	341.6350	f
01a09b0f-e4f3-713f-aab2-f78990d74bb9	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-05	392.0150	f
01a09b0f-e4f3-719f-b24b-9882d77aec62	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-03	315.0900	f
01a09b0f-e4f3-7249-aa27-52beac94e6aa	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-01	300.5900	f
01a09b0f-e4f3-73ba-ac64-da75acc06eeb	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-17	396.9800	f
01a09b0f-e4f3-7493-b6bd-b8f6909e65b7	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-07	381.3550	f
01a09b0f-e4f3-7650-bdf0-5e85d0c6c80a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-08	342.8000	f
01a09b0f-e4f3-76a0-ac02-3efd9b07466a	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-13	374.2200	f
01a09b0f-e4f3-76ec-9902-818c2c0b6d9c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-11	345.7100	f
01a09b0f-e4f3-772e-871a-be472f4d8eba	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-10	319.5200	f
01a09b0f-e4f3-7743-bcf0-66a3c09d4a60	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-04	380.1800	f
01a09b0f-e4f3-776c-8753-ba2b1d4c245f	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-18	369.3950	f
01a09b0f-e4f3-777d-98e1-d404d98bda86	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-09	324.6600	f
01a09b0f-e4f3-777e-b138-adb3c672ae93	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-04	322.5700	f
01a09b0f-e4f3-77f1-97b3-6f5588613804	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-12	383.1650	f
01a09b0f-e4f3-79e3-92bf-3a51815baada	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-11	390.0000	f
01a09b0f-e4f3-7a6e-bafe-179512c5b526	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-24	324.1200	f
01a09b0f-e4f3-7b23-afc3-eb25a6c0bdac	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-26	331.4800	f
01a09b0f-e4f3-7c55-8e1b-5d9f623582f4	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-14	378.0900	f
01a09b0f-e4f3-7caf-b4da-da028fccbed0	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-31	303.0000	f
01a09b0f-e4f3-7cb5-bacd-7abc0a73fafe	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-28	309.8000	f
01a09b0f-e4f3-7cd1-a152-46efce3d4e16	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-25	313.2300	f
01a09b0f-e4f3-7ced-baa0-5f060f99aac2	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-09-02	302.6400	f
01a09b0f-e4f3-7d13-a539-2545f13a09bd	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-21	342.5200	f
01a09b0f-e4f3-7db6-aa4a-7de4464db89c	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-10	375.5450	f
01a09b0f-e4f3-7e61-bb3c-17fa93272bb8	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-27	333.6700	f
01a09b0f-e4f3-7eb5-a261-e66726f83617	01a09aec-feb5-7aeb-a4ae-aa963ecf88d5	2026-08-06	384.2150	f
01a09b0f-e588-7065-a4d5-444353abcd53	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-20	407.5500	f
01a09b0f-e588-71a3-aadf-f1a6a7dd983a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-12	348.3300	f
01a09b0f-e588-71b3-8e3d-9cb9837b7b95	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-28	437.5600	f
01a09b0f-e588-71cb-9ed5-ef01efb0ccf6	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-29	443.9200	f
01a09b0f-e588-7201-99d0-f87a4220019e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-09	369.0900	f
01a09b0f-e588-7241-999e-4f1cc5f51b5d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-23	380.2100	f
01a09b0f-e588-728b-88ec-9db1581da201	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-28	355.0500	f
01a09b0f-e588-72cb-80e6-fb7252e0fea1	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-15	398.3400	f
01a09b0f-e588-72d0-83a5-0c84c3185008	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-12	358.0000	f
01a09b0f-e588-7324-bd89-7a175a8c930a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-26	358.9000	f
01a09b0f-e588-7343-9624-70596b86f738	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-14	375.2400	f
01a09b0f-e588-7369-83ee-cd3aefaa6896	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-30	438.0000	f
01a09b0f-e588-7391-afff-82aba21911ef	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-19	285.2300	f
01a09b0f-e588-739f-a8cc-32de2b505d94	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-18	378.0100	f
01a09b0f-e588-73a0-a0ee-f1bbaf11f105	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-02	335.7000	f
01a09b0f-e588-73ba-aea4-865e25798d58	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-22	400.2400	f
01a09b0f-e588-73c4-81f0-3bcfbc370d46	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-20	280.3300	f
01a09b0f-e588-73c7-94cd-73326e5671c4	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-22	389.4700	f
01a09b0f-e588-73ef-b466-623ab0df9533	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-29	331.2900	f
01a09b0f-e588-7407-b469-b2843a52621b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-30	364.6200	f
01a09b0f-e588-7419-ad9b-c42d6434e1b9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-15	329.8000	f
01a09b0f-e588-743b-b8be-4c3b77a83804	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-18	327.1200	f
01a09b0f-e588-743e-9b86-9c1b05ee5f86	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-04	362.1600	f
01a09b0f-e588-746e-9ca1-59df67e9614e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-16	355.5300	f
01a09b0f-e588-7471-8ee9-0def7f5b73dc	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-15	359.0000	f
01a09b0f-e588-747c-b29f-7711a4802fd4	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-10	361.9400	f
01a09b0f-e588-74c4-b2d6-aa4cd7f839e1	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-13	337.3100	f
01a09b0f-e588-7536-9383-716863d93a87	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-19	383.1300	f
01a09b0f-e588-7560-be0a-259d3bfd00c0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-09	382.2400	f
01a09b0f-e588-7597-ab27-f8b9e47699e9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-31	440.5700	f
01a09b0f-e588-75d1-ae72-199c6fa33bdb	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-25	312.2800	f
01a09b0f-e588-7608-8e14-2537e86d7d15	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-11	362.1600	f
01a09b0f-e588-762c-9162-62748e28fbdb	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-21	415.9800	f
01a09b0f-e588-7700-acca-fce89bbc4335	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-10	372.5700	f
01a09b0f-e588-7733-b581-40d1b9d7363e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-08	383.4300	f
01a09b0f-e588-7764-bf16-ad9d39207d35	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-27	332.3400	f
01a09b0f-e588-77f9-89bc-9dc03ec09bd3	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-01	371.3200	f
01a09b0f-e588-7806-a3c0-5a13a55e090c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-24	421.0000	f
01a09b0f-e588-78cc-a9dd-292cddd51118	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-08	370.6700	f
01a09b0f-e588-78db-9ffe-5294f5cb6835	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-07	370.1700	f
01a09b0f-e588-791a-a423-15b992b5a263	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-08	343.9900	f
01a09b0f-e588-793f-b5c1-011bd68d88a0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-23	414.9900	f
01a09b0f-e588-796c-b0d4-d083f7f4862a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-13	382.6000	f
01a09b0f-e588-79d5-a041-77a061002f16	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-21	277.0400	f
01a09b0f-e588-79df-bb96-65cb3a3b37b8	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-24	366.6600	f
01a09b0f-e588-7a70-88d8-51e66462c198	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-05	370.0300	f
01a09b0f-e588-7aea-aee2-6c634ab2430e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-11	332.4100	f
01a09b0f-e588-7b5f-820f-dfda0bd94624	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-22	294.3500	f
01a09b0f-e588-7c2d-9928-ff9f94bad88a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-17	358.2100	f
01a09b0f-e588-7c64-a652-25a23cf97620	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-02	369.5600	f
01a09b0f-e588-7cbc-bae0-16d434f91b81	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-26	330.6600	f
01a09b0f-e588-7da7-bf2a-413080ef6625	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-03	366.0000	f
01a09b0f-e588-7dbf-93f8-d1f49874dd1d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-03	337.5300	f
01a09b0f-e588-7dd2-8b97-fbe894e492ee	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-17	409.9000	f
01a09b0f-e588-7edc-85f3-44145f9d2f00	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-25	360.9500	f
01a09b0f-e588-7ef5-9265-6c3eac6d95ef	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-06	370.2900	f
01a09b0f-e588-7f2f-8341-482d61f386d0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-08-14	322.0800	f
01a09b0f-e588-7f44-8e36-bb7b87459c12	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-16	412.4600	f
01a09b0f-e588-7fa1-8124-8d0b14bb7b7b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-10-27	423.6100	f
01a09b0f-e588-7ffe-b7bb-a20bf17cd431	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-09-29	363.8100	f
01a09b0f-e589-7141-bba6-526f36a31434	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-08	442.9400	f
01a09b0f-e589-7144-ab15-1e2c9a44bf7e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-20	482.5600	f
01a09b0f-e589-71d2-8e1f-3f78bd193b6c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-19	416.6900	f
01a09b0f-e589-71e4-a7ff-a408ee6fb989	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-05	478.4500	f
01a09b0f-e589-71ec-80f7-d0a16c77d5f8	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-11	449.2900	f
01a09b0f-e589-7265-9761-dd561b5fa153	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-30	461.9300	f
01a09b0f-e589-7278-8455-0fdc1cadab97	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-10	516.6300	f
01a09b0f-e589-7289-948d-d76493ebafd8	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-18	409.2500	f
01a09b0f-e589-7298-941b-c3ac53acad11	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-06	503.9900	f
01a09b0f-e589-72de-a41e-781066fc2b6c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-01	449.5900	f
01a09b0f-e589-7300-b77e-5c38cb39d0d1	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-05	442.7000	f
01a09b0f-e589-7358-8e01-e9c3f8c656b5	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-12	462.0500	f
01a09b0f-e589-736e-8821-dea7efdf8917	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-29	472.0800	f
01a09b0f-e589-7382-89a9-08525c5e9e01	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-12	470.8900	f
01a09b0f-e589-742c-ab1c-57935362bd8a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-06	479.1700	f
01a09b0f-e589-7460-b68a-fcb4ba432f91	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-21	488.3600	f
01a09b0f-e589-7464-ac8c-1a6cab4c5e75	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-22	470.3900	f
01a09b0f-e589-748d-a2c1-f1d92d9f8cda	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-12	447.4900	f
01a09b0f-e589-7493-b7eb-1614e5681b27	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-03	448.5300	f
01a09b0f-e589-74f1-85fa-175904b252cc	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-15	470.0200	f
01a09b0f-e589-7576-85e6-a2e3678266ed	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-21	390.4600	f
01a09b0f-e589-7583-b85c-f786706465d0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-17	496.7800	f
01a09b0f-e589-758b-b96d-46a9d0ba1665	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-25	429.6900	f
01a09b0f-e589-7602-8803-d419760d2e55	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-17	426.5300	f
01a09b0f-e589-764b-9076-f9e9fc7022b6	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-13	489.0000	f
01a09b0f-e589-7691-bcd9-2ab5558c4270	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-10	466.2900	f
01a09b0f-e589-76af-a13a-de9c47e1def0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-03	443.0000	f
01a09b0f-e589-76ce-94f2-5a63ef240019	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-13	495.5500	f
01a09b0f-e589-76f5-b7e2-5d4f30f55420	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-24	481.7400	f
01a09b0f-e589-7748-ad8e-bdbd8e7732a9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-02	441.5800	f
01a09b0f-e589-7749-9a3d-9b4cdea0ca32	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-07	470.5000	f
01a09b0f-e589-7751-b7b7-7c1481b6e147	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-31	455.2800	f
01a09b0f-e589-775e-b984-95b0779576c3	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-09	498.4500	f
01a09b0f-e589-7776-ba16-f97e236fcfe3	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-18	505.7800	f
01a09b0f-e589-778f-9814-fb1a9e68ac31	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-11	528.1700	f
01a09b0f-e589-7791-aedc-1d8740fb644f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-26	478.3200	f
01a09b0f-e589-77cc-b251-b6445fc6c03e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-28	501.0000	f
01a09b0f-e589-77d2-8b43-1cb98fe9e77b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-24	416.3500	f
01a09b0f-e589-77e1-a750-09abd65ec8d1	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-10	467.2300	f
01a09b0f-e589-7833-a359-81dbceddfb61	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-08	491.0300	f
01a09b0f-e589-7847-a4fa-7874d8fa842d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-12	462.9400	f
01a09b0f-e589-7891-aa3a-614450596a76	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-22	483.5500	f
01a09b0f-e589-78aa-aa4e-a42c8754204c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-19	513.8300	f
01a09b0f-e589-7918-b22f-504bca6df268	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-26	449.0600	f
01a09b0f-e589-79ba-bb55-59dd219dd28c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-06	461.2400	f
01a09b0f-e589-79c3-a59a-69558af14847	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-20	387.2200	f
01a09b0f-e589-7a9f-9dae-38c260ca8c29	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-16	451.1600	f
01a09b0f-e589-7ac4-85f2-a38f83317fe7	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-16	494.4500	f
01a09b0f-e589-7b4c-9b92-65ebbab592df	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-02	499.6100	f
01a09b0f-e589-7b4d-936c-9adb3a3c6c2c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-02	479.4200	f
01a09b0f-e589-7b5c-8b00-b6fd416cdcc6	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-23	486.9200	f
01a09b0f-e589-7b6e-b260-15eaa8cba795	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-14	413.3200	f
01a09b0f-e589-7b9a-a7e4-06b146d1ebfd	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-14	477.0500	f
01a09b0f-e589-7bc9-8210-bf5635b0f02a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-04	471.7800	f
01a09b0f-e589-7be4-973b-1d2554de5760	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-17	416.6400	f
01a09b0f-e589-7bed-ae37-66b3da8e6d5c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-04	423.0300	f
01a09b0f-e589-7c07-9d63-a90039f04a8c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-04	459.6000	f
01a09b0f-e589-7c19-957d-db9288fdcb57	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-09	447.2300	f
01a09b0f-e589-7c4d-9825-511731f7ea74	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-29	496.2600	f
01a09b0f-e589-7c4f-9ad0-cc0b467fde5e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-18	452.4600	f
01a09b0f-e589-7c54-b908-c96bfa5f6366	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-28	459.4100	f
01a09b0f-e589-7ca1-9ce1-f34582c6c94a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-07	449.1300	f
01a09b0f-e589-7d16-a530-1c865c038875	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-23	466.9100	f
01a09b0f-e589-7d7b-85ca-e5700ef51a7f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-05	486.9100	f
01a09b0f-e589-7d9a-a3b6-5ff749a8d031	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-26	474.1200	f
01a09b0f-e589-7da7-9c4b-94d1ffe558da	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-27	498.5900	f
01a09b0f-e589-7db0-a63e-edac1f1c6660	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-30	489.4400	f
01a09b0f-e589-7dc2-b748-b9f56c46824f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-03	447.3100	f
01a09b0f-e589-7dc5-8567-3a30aff394ad	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-09	501.8900	f
01a09b0f-e589-7de3-9146-700181832d65	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-05	456.9000	f
01a09b0f-e589-7e7a-bfec-2774b7894034	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-12-19	475.4700	f
01a09b0f-e589-7ec1-9180-29014bb0bbc8	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-11	465.5300	f
01a09b0f-e589-7fbc-876d-423fa2c5add8	01a09aec-feb5-7b92-84bb-0764d59ddf43	2025-11-13	402.4700	f
01a09b0f-e589-7fe7-a32c-02258bab2174	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-01-15	497.5800	f
01a09b0f-e58a-700a-9d40-18512b17ac1b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-18	700.2600	f
01a09b0f-e58a-7013-8d74-6658d60e96c4	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-22	703.8600	f
01a09b0f-e58a-7029-962b-c46dfd9e25f2	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-04	717.8000	f
01a09b0f-e58a-7034-88a6-9610e527394c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-27	551.9700	f
01a09b0f-e58a-7062-b224-ab3a5688b708	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-30	683.4700	f
01a09b0f-e58a-706a-a635-5f17bf99ac4b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-05	660.3200	f
01a09b0f-e58a-7085-8b7f-d3465de94851	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-09	618.2600	f
01a09b0f-e58a-70b2-a3d5-324eb8a7470b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-02	557.9700	f
01a09b0f-e58a-7101-b114-b386442c499d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-01	706.5300	f
01a09b0f-e58a-716f-a9db-ff670b9be481	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-07	557.7200	f
01a09b0f-e58a-717a-8235-a313a4689654	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-31	521.5200	f
01a09b0f-e58a-717b-9eec-c1294cfb538c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-28	667.9500	f
01a09b0f-e58a-718e-967e-2adc4183b88f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-18	500.4300	f
01a09b0f-e58a-71b4-b13f-1520b53532dd	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-21	703.2700	f
01a09b0f-e58a-721f-862f-2addb14d9d01	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-13	689.8900	f
01a09b0f-e58a-7241-8a88-e2f2a03b68c5	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-06	679.0900	f
01a09b0f-e58a-7281-b650-0b982e8e9e34	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-27	684.7600	f
01a09b0f-e58a-72a9-a504-e3c09e1fb241	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-20	662.2100	f
01a09b0f-e58a-72bf-a96d-2cfd9636a624	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-10	543.0200	f
01a09b0f-e58a-7330-b825-d5c0fdaec1f4	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-12	512.8000	f
01a09b0f-e58a-736c-8c63-1c0cd54750ba	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-14	681.6800	f
01a09b0f-e58a-73ab-aaae-3cd4dfdf856a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-30	491.8800	f
01a09b0f-e58a-73e9-9e2f-8c17e5976ec6	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-01	534.9800	f
01a09b0f-e58a-7470-b3d1-e892a9bc3d24	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-19	677.7500	f
01a09b0f-e58a-74b6-adab-6ef8f8948bc9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-15	685.8100	f
01a09b0f-e58a-74d7-abd9-c666ac383ccc	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-23	576.7100	f
01a09b0f-e58a-74db-b89c-36e6b8c51396	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-20	546.1300	f
01a09b0f-e58a-7505-9d80-b013f4ab39e0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-17	500.0200	f
01a09b0f-e58a-7550-950f-2eaf80252099	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-04	563.8700	f
01a09b0f-e58a-7563-a6d1-3f0b951cdcbe	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-23	546.4700	f
01a09b0f-e58a-7576-be61-78a848418bc5	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-28	637.7400	f
01a09b0f-e58a-75cb-90e2-5977a7d8af6f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-26	549.7000	f
01a09b0f-e58a-75e0-b486-94ee93c26b46	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-17	689.8900	f
01a09b0f-e58a-769e-9081-c45cdaefcfd5	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-09	527.5300	f
01a09b0f-e58a-76b6-9c06-ca49eb1b492c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-06	489.3800	f
01a09b0f-e58a-76f6-ade5-66fa05ffe172	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-12	634.4800	f
01a09b0f-e58a-774f-ab3d-1380e265a3d8	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-08	610.1800	f
01a09b0f-e58a-77ef-ac95-f9136da02833	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-24	600.9100	f
01a09b0f-e58a-780e-8bc1-ac4062ef0003	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-13	696.0700	f
01a09b0f-e58a-7816-b4fb-65f3b5ce758b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-26	680.7700	f
01a09b0f-e58a-781f-846f-ae38b866b9c0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-02	581.3700	f
01a09b0f-e58a-7832-8136-8caabe3d657c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-10	662.1300	f
01a09b0f-e58a-7849-873f-c347e6f9229f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-21	695.5200	f
01a09b0f-e58a-7850-b2cd-f323f8ab5369	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-14	746.4700	f
01a09b0f-e58a-78b9-93ac-1c43647fc4de	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-24	585.8700	f
01a09b0f-e58a-7926-a2b0-f3361571fbd2	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-15	722.0400	f
01a09b0f-e58a-7939-8413-5410adb540b9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-25	615.9900	f
01a09b0f-e58a-79e3-9c50-d6a84cf66544	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-05	544.4500	f
01a09b0f-e58a-79ec-a99c-21e2cca84159	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-20	506.2700	f
01a09b0f-e58a-7a35-810f-4abaa81ab200	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-27	686.9000	f
01a09b0f-e58a-7a40-beb5-4115bc23e23c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-25	612.0300	f
01a09b0f-e58a-7a86-81ec-5fc7ef6141b9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-06	554.3500	f
01a09b0f-e58a-7aa9-9c9a-42922d14152a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-08	621.2800	f
01a09b0f-e58a-7ad5-bd43-1b11cfb7ac55	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-23	689.4600	f
01a09b0f-e58a-7b34-9323-f04d4a5541ef	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-22	690.0600	f
01a09b0f-e58a-7b6f-bc19-9201b2c409e4	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-27	545.6300	f
01a09b0f-e58a-7b71-a05c-f96231a54e70	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-19	540.7500	f
01a09b0f-e58a-7bbc-a976-02d651a3596e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-20	700.0100	f
01a09b0f-e58a-7ce0-8139-fb242f6375a7	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-16	672.6400	f
01a09b0f-e58a-7d34-96dd-4efd4245e288	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-02-26	562.4400	f
01a09b0f-e58a-7d6a-afa1-78a753548035	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-11	649.5300	f
01a09b0f-e58a-7dbf-a1fd-c305b43a8961	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-03	553.0300	f
01a09b0f-e58a-7e0e-aa6e-463928ecc905	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-29	643.4600	f
01a09b0f-e58a-7e7b-a49a-d14ae75cd084	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-11	524.3300	f
01a09b0f-e58a-7f21-b2fd-37671c410303	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-16	512.8200	f
01a09b0f-e58a-7f60-bf88-66853c1213cd	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-04-24	720.1900	f
01a09b0f-e58a-7f83-af4b-31b008003590	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-03-13	502.1400	f
01a09b0f-e58a-7f9b-8246-af4376452879	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-07	626.1200	f
01a09b0f-e58b-7003-b470-e9cad0a4450c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-05	522.2200	f
01a09b0f-e58b-700c-acb7-b8cdbff83ba4	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-06	543.9500	f
01a09b0f-e58b-7082-866c-6207d3d91f51	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-22	617.0900	f
01a09b0f-e58b-70ef-9bd7-e5132814a25e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-28	449.7200	f
01a09b0f-e58b-715a-adb3-2b1d732225db	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-13	566.4900	f
01a09b0f-e58b-7183-9191-146bdb9bec35	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-02	701.1100	f
01a09b0f-e58b-71d9-adc7-3f37782a1756	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-20	444.8700	f
01a09b0f-e58b-71e7-920c-57cdafd5e426	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-30	439.3300	f
01a09b0f-e58b-722f-a3b8-2b5e74921e2d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-12	611.0100	f
01a09b0f-e58b-7230-8dda-0a549b7199cd	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-15	635.5800	f
01a09b0f-e58b-7237-ae27-6ae0664d65e2	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-10	527.0700	f
01a09b0f-e58b-7292-9bd8-7c2613a1d526	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-01	402.0700	f
01a09b0f-e58b-729f-bb0d-05be19bf4f7a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-10	403.9500	f
01a09b0f-e58b-72a5-bcba-9e395a2479a0	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-07	562.3800	f
01a09b0f-e58b-72b6-9269-7a8b929e6ee4	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-15	486.6500	f
01a09b0f-e58b-72cd-acc9-82fc191d279d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-25	431.5400	f
01a09b0f-e58b-72e7-a411-8e2504d6553e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-11	525.8800	f
01a09b0f-e58b-73a2-9a36-35a0a120b640	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-11	414.5800	f
01a09b0f-e58b-73da-aea7-42bc9e5d709d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-21	527.3500	f
01a09b0f-e58b-7440-be66-faf61a05d298	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-12	571.8800	f
01a09b0f-e58b-7453-b6fc-33c6f553545d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-24	476.0400	f
01a09b0f-e58b-7494-aacb-96c12ef38caf	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-22	513.6700	f
01a09b0f-e58b-749b-83b6-9a88639bd060	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-24	568.1700	f
01a09b0f-e58b-74b9-a0e6-d0f5011369a5	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-21	436.6700	f
01a09b0f-e58b-74f0-b7c6-8a29d3a25c35	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-09	586.0000	f
01a09b0f-e58b-7540-be5e-6eb2e81fe56d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-23	517.7300	f
01a09b0f-e58b-7567-8c8e-962f1735a1df	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-03	455.9400	f
01a09b0f-e58b-75f3-a5f9-7a601c0fd86b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-02	395.3500	f
01a09b0f-e58b-75f9-a21f-602b7b43da6e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-08	623.7100	f
01a09b0f-e58b-761d-8f03-ee7610f9ffa1	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-04	407.4000	f
01a09b0f-e58b-764f-a2d4-3dabbd89d29e	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-03	395.0000	f
01a09b0f-e58b-76a5-abf4-a2fc4de79a6c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-24	421.1400	f
01a09b0f-e58b-770d-8e54-46fa442ce117	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-27	432.7100	f
01a09b0f-e58b-7719-bbd1-9ee0e25174b9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-10	580.2500	f
01a09b0f-e58b-772b-84df-f7d629bcf932	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-28	414.3600	f
01a09b0f-e58b-773c-a31f-e1b80fa9f604	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-01	547.1800	f
01a09b0f-e58b-775c-bb84-515fc961887d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-29	414.5000	f
01a09b0f-e58b-77a1-a117-c270db21e957	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-05	621.2500	f
01a09b0f-e58b-780b-89a4-534fa54253a1	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-07	468.4800	f
01a09b0f-e58b-7885-9a69-764956f073be	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-09	482.7800	f
01a09b0f-e58b-7893-beca-65c5025658a9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-29	528.2300	f
01a09b0f-e58b-78a4-bdf2-3aceeb891ce3	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-13	474.6400	f
01a09b0f-e58b-78b7-b6b7-14993c935663	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-09	418.2700	f
01a09b0f-e58b-78d6-bfd1-29708cc534ae	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-04	714.7800	f
01a09b0f-e58b-79ff-9a17-12ca804ef61d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-17	598.5800	f
01a09b0f-e58b-7a6e-b88e-c35faa8b43a7	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-17	478.3900	f
01a09b0f-e58b-7ab9-97e8-5012b5a275db	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-31	435.4100	f
01a09b0f-e58b-7b69-87d6-14fbe1762636	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-18	482.5900	f
01a09b0f-e58b-7b9a-baad-1fac60ca210d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-08	480.0700	f
01a09b0f-e58b-7bc7-9c6d-693df989cc9c	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-31	412.9300	f
01a09b0f-e58b-7bc9-b08b-c71c34a0e772	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-16	588.0300	f
01a09b0f-e58b-7bf5-b211-211ec565ad75	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-14	570.2200	f
01a09b0f-e58b-7c02-bd50-c8cacf35753b	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-05-29	654.1600	f
01a09b0f-e58b-7c5e-b358-0b9c7530cbd7	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-18	573.7600	f
01a09b0f-e58b-7c75-b4b5-61d9d04489f2	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-20	494.2600	f
01a09b0f-e58b-7cc2-9770-48f850891455	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-30	562.0800	f
01a09b0f-e58b-7d70-a524-a81fa7ec2abe	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-02	499.6100	f
01a09b0f-e58b-7d7b-80c0-71e76f2a8294	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-11	582.2400	f
01a09b0f-e58b-7d8a-ba2e-cd76e7d0bef6	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-03	725.0000	f
01a09b0f-e58b-7e36-b8ab-6a1753321f5a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-27	470.8200	f
01a09b0f-e58b-7e3f-8e92-5e984bca5270	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-10	471.1300	f
01a09b0f-e58b-7e6d-9d50-d9c48a3560c9	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-04	531.0300	f
01a09b0f-e58b-7e7e-87e4-cf6170fd9d3d	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-26	524.7900	f
01a09b0f-e58b-7e86-ba7c-0e71ebf5b301	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-14	482.7800	f
01a09b0f-e58b-7f0f-95e2-95308b311936	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-26	437.8000	f
01a09b0f-e58b-7f34-bc0f-84386e8ca003	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-09-08	416.3100	f
01a09b0f-e58b-7f8f-b5a6-e8b18644bd34	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-16	460.1900	f
01a09b0f-e58b-7f91-a63a-36abce5dab0a	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-23	583.5500	f
01a09b0f-e58b-7f9d-80b3-cc79b6cb590f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-25	567.7900	f
01a09b0f-e58b-7fc4-814f-7c3612a6b909	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-08-19	454.5500	f
01a09b0f-e58b-7fc6-b368-3b5d6f14187f	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-01	622.3600	f
01a09b0f-e58b-7fce-b9d9-c9b00f39ef14	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-07-06	500.7500	f
01a09b0f-e58b-7ff4-aa0f-f8cc8cd45776	01a09aec-feb5-7b92-84bb-0764d59ddf43	2026-06-17	584.3800	f
01a09b0f-e618-7294-9ade-8286bead96db	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-11	123.7200	f
01a09b0f-e619-7009-aa33-1715be300b1e	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-09	252.4200	f
01a09b0f-e619-7022-a384-feb9960e43cf	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-14	246.8300	f
01a09b0f-e619-7028-addd-3d2d55faa4a3	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-06	238.3300	f
01a09b0f-e619-7034-ab41-5df154f3ba51	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-21	207.3700	f
01a09b0f-e619-7048-b5fa-16a485f6f95c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-15	237.5000	f
01a09b0f-e619-7057-a5cd-4af4b37c0010	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-25	116.4200	f
01a09b0f-e619-70d7-a2e8-317af082feab	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-14	125.2900	f
01a09b0f-e619-70f9-8db1-2cd6794f3bfe	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-01	240.4600	f
01a09b0f-e619-7102-999f-b13d96112b86	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-24	219.0200	f
01a09b0f-e619-7126-9e7f-83ee4739c7a1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-21	115.7900	f
01a09b0f-e619-712a-b76f-4c98ebda5745	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-05	237.2200	f
01a09b0f-e619-712f-ad38-3a596d2621f9	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-30	167.3200	f
01a09b0f-e619-7145-8d6f-af13ea3abf52	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-16	158.8200	f
01a09b0f-e619-7165-80bf-1b069ea937c5	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-18	228.5000	f
01a09b0f-e619-724b-bb18-2a6af0dce521	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-12	244.9000	f
01a09b0f-e619-7264-99fc-7ee7e7bc8688	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-01	182.1500	f
01a09b0f-e619-7285-8149-863b0af90872	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-29	226.6300	f
01a09b0f-e619-7314-8739-9496eb1b1ebc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-26	116.5000	f
01a09b0f-e619-7334-aff6-82f563be9c43	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-22	117.6800	f
01a09b0f-e619-7371-bee3-457b04dab81b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-26	284.7900	f
01a09b0f-e619-7374-8c07-e4f65c62e484	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-09	135.2400	f
01a09b0f-e619-7383-aea0-22d7b56bf540	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-28	236.4800	f
01a09b0f-e619-73da-97cb-05577eee44d5	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-03	234.1600	f
01a09b0f-e619-7413-9a31-474c869be397	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-15	191.9400	f
01a09b0f-e619-7419-a6c2-08de2191e359	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-29	119.0100	f
01a09b0f-e619-7441-995d-14ad1ade193b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-27	220.1000	f
01a09b0f-e619-748f-a5ec-b6632f3079c8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-11	241.1100	f
01a09b0f-e619-749a-b219-e1f527187f49	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-13	192.7700	f
01a09b0f-e619-74a3-962e-56d3af2ca263	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-24	161.7100	f
01a09b0f-e619-7517-9e3f-3fd33472f30f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-03	234.7000	f
01a09b0f-e619-7532-8768-9d80030d8392	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-02	118.4800	f
01a09b0f-e619-7554-89c1-014a3f04788b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-22	276.5900	f
01a09b0f-e619-755b-b622-7299196912df	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-20	206.7700	f
01a09b0f-e619-7598-a2ba-acf0f2b1b429	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-24	223.9300	f
01a09b0f-e619-75c3-af27-7921f2949993	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-03	187.8300	f
01a09b0f-e619-75ec-89be-73a535516a00	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-26	230.2600	f
01a09b0f-e619-75f2-a551-c4ce4eadb968	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-24	286.6800	f
01a09b0f-e619-7630-85a7-4346e0df35bf	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-10	140.0000	f
01a09b0f-e619-7634-a1c4-af48823a6b5b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-31	285.4100	f
01a09b0f-e619-7659-82bd-fc140e1fd5a8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-20	117.2100	f
01a09b0f-e619-765b-9bc7-95e49b022aeb	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-22	164.6200	f
01a09b0f-e619-7682-9f59-41c1a5316fa4	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-10	181.6000	f
01a09b0f-e619-76a1-ae0c-cb514f72eb34	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-22	198.4700	f
01a09b0f-e619-76db-88e8-0e660fd5d074	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-21	202.2900	f
01a09b0f-e619-76f5-b90e-312829e426b6	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-12	157.2300	f
01a09b0f-e619-7714-a472-fe61d85614d0	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-25	224.5300	f
01a09b0f-e619-7726-a776-99152ca7162c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-04	124.2100	f
01a09b0f-e619-774c-a9f7-0c4ec0dd2078	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-17	225.5200	f
01a09b0f-e619-7752-b398-2ec1d0fa11d5	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-11	150.5700	f
01a09b0f-e619-776b-9cac-606b15dd9d30	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-08	131.4600	f
01a09b0f-e619-779d-b536-b52c768b2c67	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-29	294.3700	f
01a09b0f-e619-77ae-9fef-ba78fbb137e7	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-25	156.8300	f
01a09b0f-e619-77bd-bbba-aaee0175bc51	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-04	226.6500	f
01a09b0f-e619-77be-aadd-bc29979e7045	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-19	265.9200	f
01a09b0f-e619-77c4-a681-6eacd96f5958	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-28	221.9100	f
01a09b0f-e619-781d-ba6f-55c468b16be2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-13	124.2700	f
01a09b0f-e619-7856-9087-8d51a08722a3	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-15	120.8700	f
01a09b0f-e619-78c2-b831-bb00b2730d56	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-13	236.9500	f
01a09b0f-e619-7925-bc9f-ef368e0c81bc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-17	241.9500	f
01a09b0f-e619-7939-8181-1f1fc7c68c60	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-18	123.5500	f
01a09b0f-e619-7948-8a49-2e3f097a7115	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-18	168.8900	f
01a09b0f-e619-7989-80f0-0558e082a395	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-12	241.1400	f
01a09b0f-e619-799c-872b-bdde504ced9f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-26	157.2700	f
01a09b0f-e619-79a8-9a0d-4be0583cb757	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-07	185.6900	f
01a09b0f-e619-79cb-9a39-3a87342c794d	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-28	122.0000	f
01a09b0f-e619-79f7-973f-1e1d820a91c4	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-29	163.9000	f
01a09b0f-e619-7a0e-b574-bd2925dc6ffd	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-06	190.9600	f
01a09b0f-e619-7a2b-9977-7dcbde5e1489	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-30	224.0100	f
01a09b0f-e619-7a3b-9c77-61dbee713f2a	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-02	239.4900	f
01a09b0f-e619-7a63-a958-f6c2d760ddde	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-27	117.7500	f
01a09b0f-e619-7aa1-b646-2156507152e1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-02	183.7500	f
01a09b0f-e619-7ad3-9bc0-31642e575311	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-16	232.5100	f
01a09b0f-e619-7b6b-b656-03685ac1126f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-23	166.4100	f
01a09b0f-e619-7b73-b05f-52f67e3d1bfc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-16	202.5300	f
01a09b0f-e619-7b79-9c7c-b7486745d2a1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-10	263.7100	f
01a09b0f-e619-7b8e-aab5-d16b128bc139	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-18	248.5500	f
01a09b0f-e619-7be4-be62-80bc58c7fd11	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-30	292.6300	f
01a09b0f-e619-7c43-9683-ebde059f2987	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-31	223.7700	f
01a09b0f-e619-7ca3-821b-b13189c3e462	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-15	157.7700	f
01a09b0f-e619-7cb9-a329-749ed636523a	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-05	131.3700	f
01a09b0f-e619-7cbe-ba23-6a7abc6efb4e	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-04	218.0300	f
01a09b0f-e619-7cd2-8d45-68ecc8fa79d3	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-23	206.7100	f
01a09b0f-e619-7d1d-bdf0-9a3d34caffbe	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-03	118.7200	f
01a09b0f-e619-7d26-a12f-5439e640831e	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-19	162.7300	f
01a09b0f-e619-7d9c-8085-ccf5580d91fb	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-14	187.0600	f
01a09b0f-e619-7da6-bcc3-e191625ef442	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-07	237.9200	f
01a09b0f-e619-7df6-bddb-4d0d842ebd51	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-20	201.3700	f
01a09b0f-e619-7e08-8c37-500a3d33db03	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-23	276.2700	f
01a09b0f-e619-7e1f-8c04-d5850236507f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-19	225.9200	f
01a09b0f-e619-7e22-be47-6a0b039dcf6b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-09-17	159.9900	f
01a09b0f-e619-7e4b-8092-d35f54cfafff	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-17	202.3800	f
01a09b0f-e619-7e90-acc8-52731ee30c71	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-19	122.0500	f
01a09b0f-e619-7ec8-832d-7e98a30a7dfe	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-08	196.5400	f
01a09b0f-e619-7eca-b7c8-f8179e581711	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-08-12	127.7500	f
01a09b0f-e619-7f3c-b1f7-d2351b902ade	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-10	253.3000	f
01a09b0f-e619-7f40-acdf-0d2056ef0553	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-11-05	237.5000	f
01a09b0f-e619-7f53-a6c4-161e689ff471	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-11	258.4600	f
01a09b0f-e619-7fc1-8dd2-517a29f78656	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-10-09	192.3300	f
01a09b0f-e619-7fdf-a431-49a2280ba834	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2025-12-08	246.9200	f
01a09b0f-e61a-7070-a336-88433beadad7	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-29	435.7900	f
01a09b0f-e61a-7088-86a9-b4cef99c0086	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-04	400.7700	f
01a09b0f-e61a-709b-bb43-c6ef53ba54c5	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-11	795.3300	f
01a09b0f-e61a-709d-bd66-d6187fda15c6	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-07	646.6300	f
01a09b0f-e61a-70b6-9767-ea8087e4aa5c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-02	315.4200	f
01a09b0f-e61a-70bd-b23f-317371c383e9	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-09	421.5100	f
01a09b0f-e61a-7119-9edd-b47371fab659	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-22	751.0000	f
01a09b0f-e61a-7127-93c6-f5bd3544f957	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-06	394.6900	f
01a09b0f-e61a-71c3-9be7-88ced34bf5c8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-27	928.4100	f
01a09b0f-e61a-71cb-b9e7-34f6817fb201	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-17	455.0700	f
01a09b0f-e61a-723d-81a7-46d5a0ad7cfa	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-01	1035.5000	f
01a09b0f-e61a-724e-a712-2eb8390a9bec	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-02	412.6700	f
01a09b0f-e61a-725f-9e91-bf3019a056dc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-23	399.6500	f
01a09b0f-e61a-7288-90c0-7850aa2db5cd	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-10	420.5900	f
01a09b0f-e61a-72aa-95b5-db86edd241a7	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-24	496.7200	f
01a09b0f-e61a-7304-81c5-cbddf2e148a8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-17	461.6900	f
01a09b0f-e61a-730a-a792-5d9d0cb50e78	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-27	410.2400	f
01a09b0f-e61a-731c-9cbf-18023f4dc9be	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-21	449.3800	f
01a09b0f-e61a-738f-aace-b2b7c49fdfd0	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-31	337.8400	f
01a09b0f-e61a-7391-a874-2fa1d874d03a	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-11	410.3400	f
01a09b0f-e61a-73af-806c-ae8236824fab	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-18	461.7300	f
01a09b0f-e61a-73af-ab38-2293e2365efa	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-15	724.6600	f
01a09b0f-e61a-73ed-ac17-7bded6036717	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-18	420.9500	f
01a09b0f-e61a-7415-b9fc-bf93d99a97fd	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-06	343.4300	f
01a09b0f-e61a-742c-88b1-bcc198c56e21	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-27	524.5600	f
01a09b0f-e61a-7459-a60f-c6169df151e8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-08	327.0200	f
01a09b0f-e61a-7472-b618-63cddfd3e033	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-03	1079.5699	f
01a09b0f-e61a-749d-abcf-02798332ab8e	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-22	397.5800	f
01a09b0f-e61a-74b9-852b-cb3039ca1c37	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-13	803.6300	f
01a09b0f-e61a-74ff-b766-e13b7e141229	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-01	367.8500	f
01a09b0f-e61a-753b-a0f9-55e429063b4a	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-04	576.4500	f
01a09b0f-e61a-7549-978d-adbaba1856a6	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-16	441.8000	f
01a09b0f-e61a-7554-9a37-2247efef87ca	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-09	389.3200	f
01a09b0f-e61a-7554-bcb4-6414e1ac79bc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-20	731.9900	f
01a09b0f-e61a-7582-bd66-451830bc1a82	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-14	333.3500	f
01a09b0f-e61a-759c-b481-5ea737658867	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-30	517.1600	f
01a09b0f-e61a-75a1-badd-dd500d7ff4e2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-15	336.6300	f
01a09b0f-e61a-75b0-9ff9-a8ebc835c44f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-25	382.0900	f
01a09b0f-e61a-75d7-bddc-38becb3075ba	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-26	895.8800	f
01a09b0f-e61a-75e4-bf57-62db18370dc5	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-13	411.6600	f
01a09b0f-e61a-75e6-becd-e142688da3eb	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-08	949.2800	f
01a09b0f-e61a-7680-9513-45d694f3da9d	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-03	379.6800	f
01a09b0f-e61a-7681-a4b9-82eff18e5d6b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-01	542.2100	f
01a09b0f-e61a-7684-a2e2-91566fb0b91d	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-12	345.8700	f
01a09b0f-e61a-76c1-ab8c-d3555bc2b3b2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-13	426.1300	f
01a09b0f-e61a-76c9-b615-725d16c9889b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-20	422.9000	f
01a09b0f-e61a-76d9-b39e-a06836a2bd10	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-13	338.1300	f
01a09b0f-e61a-76ee-944c-7b5b547d0f93	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-09	345.0900	f
01a09b0f-e61a-76ef-a17d-0ce92343f675	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-09	383.5000	f
01a09b0f-e61a-7715-97fa-7cb77d083912	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-30	414.8800	f
01a09b0f-e61a-7718-a718-b5ab79948522	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-14	776.0100	f
01a09b0f-e61a-7749-854c-839afbb4579e	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-02	366.2400	f
01a09b0f-e61a-77a6-b31a-c1525679ebae	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-21	762.1000	f
01a09b0f-e61a-77f1-866f-4fce3c7976b1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-04	379.4000	f
01a09b0f-e61a-7845-bc1e-bb4b18c645e5	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-22	487.4800	f
01a09b0f-e61a-7853-b61c-fd0dcdca1ce2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-28	504.2900	f
01a09b0f-e61a-7874-b51d-e752322baf19	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-23	481.7200	f
01a09b0f-e61a-7880-9df1-4da89e5310ec	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-07	377.5800	f
01a09b0f-e61a-78a9-9976-c44c7eeb034b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-30	321.8000	f
01a09b0f-e61a-78ae-be17-e1357f57e286	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-07	339.5500	f
01a09b0f-e61a-78ca-af67-8a224880bfbe	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-20	448.4200	f
01a09b0f-e61a-7931-bdfd-c995b2993d0d	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-28	923.5200	f
01a09b0f-e61a-7932-abf8-7600df93d69c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-13	426.5600	f
01a09b0f-e61a-7986-b55f-d0a4ac8ff8f8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-20	365.0000	f
01a09b0f-e61a-79a6-9d03-7475c2079dd7	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-29	971.0000	f
01a09b0f-e61a-79b1-a991-db80a8d0eff2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-03	419.4400	f
01a09b0f-e61a-79b2-8aa8-18e1431d3646	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-26	389.0900	f
01a09b0f-e61a-79ec-91b1-b91df04ce5f6	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-24	418.0100	f
01a09b0f-e61a-7a19-bd90-1297886f4232	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-02	1064.1000	f
01a09b0f-e61a-7a2d-bd9a-45722dd4d3e8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-18	681.5400	f
01a09b0f-e61a-7a37-a45d-f3ce5b3307d7	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-28	435.2800	f
01a09b0f-e61a-7a44-a5c7-785be7601753	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-05	382.8900	f
01a09b0f-e61a-7a76-ac98-305dfaae1d29	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-15	456.2300	f
01a09b0f-e61a-7a9d-b8da-90e50c7c5291	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-14	465.6600	f
01a09b0f-e61a-7ab4-8be1-cc4d8608b74b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-21	389.1100	f
01a09b0f-e61a-7b11-8b98-56b9b5cc47da	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-25	429.0000	f
01a09b0f-e61a-7b7f-b76b-9f49c2f657fc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-29	518.4600	f
01a09b0f-e61a-7ba5-9b1c-6193cc877538	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-10	403.1100	f
01a09b0f-e61a-7c2e-af51-8f8cb6134399	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-12	405.3500	f
01a09b0f-e61a-7c49-bc6e-ab6d82ed4ee8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-06	370.3000	f
01a09b0f-e61a-7c4c-afa1-fafd3281a987	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-16	457.2300	f
01a09b0f-e61a-7ca8-9d3b-f895e3935c43	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-16	362.7500	f
01a09b0f-e61a-7cb4-ad7a-53064a72d3ef	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-01-05	312.1500	f
01a09b0f-e61a-7cbb-aebc-4f41c6bc8a2d	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-23	404.3500	f
01a09b0f-e61a-7ccf-864b-91e1e3ccf533	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-06	666.5900	f
01a09b0f-e61a-7cd2-b7eb-926450e31474	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-02	437.8000	f
01a09b0f-e61a-7ce5-991e-2f4cab948f2a	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-10	373.2500	f
01a09b0f-e61a-7d34-8a94-28f8643e23b4	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-11	418.6900	f
01a09b0f-e61a-7d40-a43d-b3bd2854ea75	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-19	698.7400	f
01a09b0f-e61a-7d76-9262-546e6c9e1770	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-23	420.9700	f
01a09b0f-e61a-7d83-bace-5794d8190ed1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-05	864.0100	f
01a09b0f-e61a-7d9b-b53c-51a6474127ed	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-12	766.5800	f
01a09b0f-e61a-7d9d-b0ba-9b27ce917f01	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-08	406.7300	f
01a09b0f-e61a-7dd3-9121-2fc92cc3d207	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-26	355.4600	f
01a09b0f-e61a-7de1-bcf3-2772e4174c0d	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-19	417.3500	f
01a09b0f-e61a-7e17-af7f-0028ca73b74c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-05	640.2000	f
01a09b0f-e61a-7e19-9762-5dbcb9f95151	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-05	397.0500	f
01a09b0f-e61a-7e25-b70b-327e2f1c0859	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-04-06	377.7600	f
01a09b0f-e61a-7e41-a336-246a016c2c55	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-05-08	746.8100	f
01a09b0f-e61a-7e61-8c10-fe6f430f651f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-24	395.5300	f
01a09b0f-e61a-7e70-a90f-e26b561aa237	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-27	412.3700	f
01a09b0f-e61a-7e8f-ac31-56331d96f4c0	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-19	444.2700	f
01a09b0f-e61a-7e9f-a049-7f63c192d658	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-17	399.7800	f
01a09b0f-e61a-7eaf-93f6-7465ee9dea77	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-26	415.5600	f
01a09b0f-e61a-7ed0-8ac3-ad274736b32c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-03-27	357.2200	f
01a09b0f-e61a-7eee-991f-3f482211d9e4	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-04	996.0000	f
01a09b0f-e61a-7f3c-8b44-e03f9c9e4acf	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-12	413.9700	f
01a09b0f-e61a-7fc0-abc3-ce82bea8c707	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-02-20	428.1700	f
01a09b0f-e61b-7089-a464-a8da3d1688b1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-11	995.8700	f
01a09b0f-e61b-70ba-b612-6fc2badfb218	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-09	935.8900	f
01a09b0f-e61b-70dc-a413-441a818634ec	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-31	958.7300	f
01a09b0f-e61b-70e4-b86b-d86a16b00be1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-23	990.2100	f
01a09b0f-e61b-70eb-819c-09df0759047f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-19	937.1100	f
01a09b0f-e61b-70ee-965e-d6db0d349db6	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-09	991.6400	f
01a09b0f-e61b-71a7-9a6a-a332f1681dca	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-10	861.0000	f
01a09b0f-e61b-71d5-b11e-38c562aa4ed2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-25	932.9700	f
01a09b0f-e61b-7216-b4c5-a9bf956b7966	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-03	958.1600	f
01a09b0f-e61b-7286-a850-f8cc8d6c657f	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-21	966.7800	f
01a09b0f-e61b-72bf-8e6f-b39ca004a623	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-29	739.0000	f
01a09b0f-e61b-72cf-b00e-2ee364d93236	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-26	1132.3300	f
01a09b0f-e61b-72d2-a4ec-d497d881fb24	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-06	984.7500	f
01a09b0f-e61b-72eb-91d3-1f4d8177b9a1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-31	823.0300	f
01a09b0f-e61b-732d-b8f6-570c3f7bbff9	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-29	1145.2800	f
01a09b0f-e61b-7435-9d87-3f3a3d6ec368	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-13	949.8300	f
01a09b0f-e61b-74d9-9889-a379c6a1aa2d	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-18	940.7600	f
01a09b0f-e61b-74ef-a9b7-5a2ac26aa9a0	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-24	910.4300	f
01a09b0f-e61b-750a-b9f7-9884522c7ad8	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-02	975.5600	f
01a09b0f-e61b-750c-a20c-bdaef35f32bf	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-10	977.4100	f
01a09b0f-e61b-756c-89ee-4d4eef870b50	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-16	1020.7600	f
01a09b0f-e61b-7576-a51d-9da3feb528dc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-03	829.5000	f
01a09b0f-e61b-75ee-a7ae-94f8b7b0556b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-09	1027.7700	f
01a09b0f-e61b-761a-8ef2-b51caabdb71b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-26	938.4000	f
01a09b0f-e61b-763a-af01-213fd24a6529	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-01	933.4400	f
01a09b0f-e61b-763c-ae21-4af286a063cc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-11	975.2600	f
01a09b0f-e61b-76af-856f-e6e1874aff07	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-16	853.2000	f
01a09b0f-e61b-76ed-b874-2873bba8d7fb	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-07	877.5700	f
01a09b0f-e61b-7710-9a76-42de8ad3d5e1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-18	1133.9900	f
01a09b0f-e61b-77c4-8d9b-5cf9005e59d1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-17	1011.7500	f
01a09b0f-e61b-77e5-8970-3a2d0abf3190	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-17	1043.1899	f
01a09b0f-e61b-7828-9d73-69765ca1963c	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-02	956.0800	f
01a09b0f-e61b-7867-9d6b-0ed1ba884e21	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-13	937.0000	f
01a09b0f-e61b-7868-b26d-a73d41815ea6	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-04	1016.5900	f
01a09b0f-e61b-78ef-923f-dd2d5c8fcb20	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-23	1051.7700	f
01a09b0f-e61b-794a-a9da-4e566323c243	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-24	920.9500	f
01a09b0f-e61b-79a4-8f98-bcd67d596523	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-10	979.3000	f
01a09b0f-e61b-7a0d-b6a2-e3536930fe2b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-28	820.5300	f
01a09b0f-e61b-7a5f-be16-17e85e9b9cb4	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-24	1048.5100	f
01a09b0f-e61b-7a86-a7b7-d2e41537b294	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-11	868.5200	f
01a09b0f-e61b-7aaf-9201-acdf38b6d289	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-01	1032.2800	f
01a09b0f-e61b-7aba-9bca-e9b5547c2822	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-30	874.6600	f
01a09b0f-e61b-7b07-b4e0-5f8ee8c9c1d0	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-12	981.6100	f
01a09b0f-e61b-7b10-a948-7e162cb79cd2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-14	971.6600	f
01a09b0f-e61b-7b3f-98a1-32b074f06240	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-10	891.8800	f
01a09b0f-e61b-7b88-9a6a-5bcfc0a88067	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-22	959.4800	f
01a09b0f-e61b-7bc3-ac4b-30091f191c24	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-07	938.3800	f
01a09b0f-e61b-7bd6-bd87-5ce16eabe3db	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-05	893.1900	f
01a09b0f-e61b-7c65-aa22-3466df2faa12	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-09-08	1000.2600	f
01a09b0f-e61b-7c7f-a13e-6dea6e3c1b85	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-04	892.6700	f
01a09b0f-e61b-7cb3-9587-0fca2e703660	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-17	848.9500	f
01a09b0f-e61b-7cba-8823-0a5f88d5f455	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-21	970.8200	f
01a09b0f-e61b-7cc3-804d-90fa2493d98b	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-15	1087.9900	f
01a09b0f-e61b-7cc5-965d-4af3b45a4ecd	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-27	935.3900	f
01a09b0f-e61b-7d0f-b3dc-15ad13437cbe	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-08	948.8000	f
01a09b0f-e61b-7d1d-89f7-4bb5e7b8e561	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-20	865.4600	f
01a09b0f-e61b-7d2f-8ea1-a7bff01c4442	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-30	1154.2900	f
01a09b0f-e61b-7d74-9824-85ea60ee0cce	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-25	1213.5601	f
01a09b0f-e61b-7d78-9b55-5df05e360d23	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-06-22	1211.3800	f
01a09b0f-e61b-7e00-a901-3c498b21a2fe	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-15	904.2800	f
01a09b0f-e61b-7e54-bed7-b7af9ce04be1	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-27	900.2000	f
01a09b0f-e61b-7ec8-b595-6858cfd6d182	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-12	911.2900	f
01a09b0f-e61b-7ecb-b522-a9fccf32bdfc	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-20	974.3300	f
01a09b0f-e61b-7ee2-a93b-03b28bea9e13	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-28	932.8600	f
01a09b0f-e61b-7f11-8301-aa9240494c40	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-08-06	881.4700	f
01a09b0f-e61b-7f7f-a9c8-024f3e53d2e2	01a09aec-feb5-7c87-b3e4-f90f29dbd01a	2026-07-14	983.1200	f
01a09b0f-e6c0-700b-bde0-7f8959be091c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-09	85.9540	f
01a09b0f-e6c0-702e-834e-48c845e15723	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-14	109.6500	f
01a09b0f-e6c0-7030-9bbb-7bb0855c809f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-11	100.6800	f
01a09b0f-e6c0-706d-9fcd-3aed3eb03d86	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-20	110.6750	f
01a09b0f-e6c0-70ae-b98a-87b53689dcc9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-02	95.4600	f
01a09b0f-e6c0-70c0-89f5-1ee6ab1ff6a2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-24	101.6800	f
01a09b0f-e6c0-70c6-8e69-7965dcb42098	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-24	91.4820	f
01a09b0f-e6c0-70ce-a07a-cb849654d4c9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-21	99.8840	f
01a09b0f-e6c0-70e9-9c0f-a15b2510f9ab	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-17	98.5780	f
01a09b0f-e6c0-7111-940f-835e7f326ccf	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-01	105.9150	f
01a09b0f-e6c0-713f-a8d6-741a459b1dda	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-28	105.2150	f
01a09b0f-e6c0-7145-825d-7534f4ff74f8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-22	87.5200	f
01a09b0f-e6c0-7154-a1e7-050901319efc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-13	105.3850	f
01a09b0f-e6c0-7164-bb28-33132f645306	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-25	91.9140	f
01a09b0f-e6c0-7187-9c79-b9110711b641	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-13	100.7000	f
01a09b0f-e6c0-7192-a7f9-a37114f681d7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-28	106.4050	f
01a09b0f-e6c0-71b0-b253-09be9fb7ffcc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-02-26	108.8100	f
01a09b0f-e6c0-71fd-af3f-4a1c897f4542	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-08	111.3950	f
01a09b0f-e6c0-7201-8ac2-64932e71b166	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-29	105.7400	f
01a09b0f-e6c0-7238-a100-b2dcba1b49b4	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-23	99.1220	f
01a09b0f-e6c0-7249-86ab-168c4d5528c3	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-12	99.7820	f
01a09b0f-e6c0-7288-b9f7-b67d3765340a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-25	104.0400	f
01a09b0f-e6c0-7299-8155-e05d36d5042a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-14	102.4350	f
01a09b0f-e6c0-72ab-9523-b2e09080e902	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-16	101.5450	f
01a09b0f-e6c0-72cc-89df-73a9f284f51f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-23	103.2400	f
01a09b0f-e6c0-72fd-94fd-effed6149de5	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-08	106.1000	f
01a09b0f-e6c0-735a-8879-b1b026b2bf13	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-20	104.7700	f
01a09b0f-e6c0-7361-b937-da5369bdeb83	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-04	104.0650	f
01a09b0f-e6c0-736d-8e85-45f1d9eb1355	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-17	103.7550	f
01a09b0f-e6c0-7389-9244-d64cf40f3ad3	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-24	100.0350	f
01a09b0f-e6c0-73bc-9aa4-7675d9e80d9e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-11	102.3350	f
01a09b0f-e6c0-73c9-bdb9-f7403f6f9170	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-08	96.2900	f
01a09b0f-e6c0-73f9-9a80-245914974058	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-15	103.3350	f
01a09b0f-e6c0-7416-9638-259476b0f49c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-06	94.7600	f
01a09b0f-e6c0-741b-8f6c-43c913189907	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-09	96.0300	f
01a09b0f-e6c0-744d-bb6e-036947ece735	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-04	106.4900	f
01a09b0f-e6c0-744f-8698-4bdf8475b45a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-30	108.6000	f
01a09b0f-e6c0-7458-95f0-cc98d2e2f441	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-25	105.9350	f
01a09b0f-e6c0-746c-9591-cc3947ffcd73	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-26	105.8000	f
01a09b0f-e6c0-74a9-b8a7-4661d6e9b86e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-01	100.5700	f
01a09b0f-e6c0-74aa-9656-6159ee1cc680	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-18	108.1050	f
01a09b0f-e6c0-74ae-a06b-7f49ac76fc52	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-28	99.8400	f
01a09b0f-e6c0-74da-8a38-755e1d5d0f88	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-10	102.8600	f
01a09b0f-e6c0-74f2-8b44-9b1a0316abf9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-03	110.0600	f
01a09b0f-e6c0-7534-8cea-e0414997b1c4	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-02	109.7750	f
01a09b0f-e6c0-753a-bf24-829dfdbf7e61	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-30	99.1860	f
01a09b0f-e6c0-7566-ba48-3dc57718b40e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-11	107.5000	f
01a09b0f-e6c0-756b-a5a9-f9fe02ad4012	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-14	106.0300	f
01a09b0f-e6c0-75df-afd9-169293dd9d58	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-10	89.3640	f
01a09b0f-e6c0-7613-9ba8-6cef323d7b43	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-31	97.9860	f
01a09b0f-e6c0-761f-9ada-9505fce3d7df	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-01	99.3040	f
01a09b0f-e6c0-762a-8993-4d3694446981	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-31	106.8650	f
01a09b0f-e6c0-762a-a98e-fc23563c7711	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-08	104.5650	f
01a09b0f-e6c0-763a-aee9-7af636b6325a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-03	102.0600	f
01a09b0f-e6c0-764f-a217-145f20c8564f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-29	99.3040	f
01a09b0f-e6c0-7671-b045-d62f88487dde	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-01	103.2900	f
01a09b0f-e6c0-76a9-82b2-f4236abe9566	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-07	87.7940	f
01a09b0f-e6c0-76ab-95ca-fcdcbcf81fc2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-18	97.9380	f
01a09b0f-e6c0-76e4-bc2a-e0cd6009cd68	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-20	100.8500	f
01a09b0f-e6c0-76f3-b8ec-455722447a47	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-22	99.0040	f
01a09b0f-e6c0-76fe-b710-43c381f711ca	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-09	101.9900	f
01a09b0f-e6c0-7715-aa8e-e7799c1bfed1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-21	103.4900	f
01a09b0f-e6c0-7718-a8d9-497e1a3ede31	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-21	105.2800	f
01a09b0f-e6c0-7749-b177-44f42ada156b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-04	101.3300	f
01a09b0f-e6c0-7753-93eb-7dbfa038c20c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-02	100.9000	f
01a09b0f-e6c0-776b-8233-a228c919f07c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-30	106.2550	f
01a09b0f-e6c0-7770-a495-ee3bae77b0f0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-05	103.9950	f
01a09b0f-e6c0-778a-ab1b-ce0c9ffbe864	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-27	100.8250	f
01a09b0f-e6c0-778f-ae12-7b8e8dc9b6b1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-07	110.2550	f
01a09b0f-e6c0-7799-919c-b0d1ecb05d48	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-17	108.5500	f
01a09b0f-e6c0-77a3-98d8-f5362a7d131d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-18	103.3750	f
01a09b0f-e6c0-77b4-b06e-53bb69b0e54a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-12	107.6900	f
01a09b0f-e6c0-77bb-a90a-71901dca9e06	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-26	108.5100	f
01a09b0f-e6c0-77be-993c-4a2501e12119	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-06	110.3450	f
01a09b0f-e6c0-77c9-bfb7-a4ce37410655	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-15	100.7800	f
01a09b0f-e6c0-77ec-8def-16f6dc5a25cc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-05	100.0950	f
01a09b0f-e6c0-782a-b467-5c530a02a269	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-19	105.5400	f
01a09b0f-e6c0-7842-beee-76212054a08e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-04	100.0200	f
01a09b0f-e6c0-784b-a982-aa7794d7687b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-14	98.4620	f
01a09b0f-e6c0-7880-9fb5-6b6045c925f6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-19	98.7640	f
01a09b0f-e6c0-7898-91ec-df589a134362	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-29	92.5920	f
01a09b0f-e6c0-789a-86e1-d4150ecd74d2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-11	88.3640	f
01a09b0f-e6c0-78b6-849f-3ae429379714	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-22	102.6350	f
01a09b0f-e6c0-78c2-b4a8-2b483a162bde	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-27	100.8000	f
01a09b0f-e6c0-78cd-8261-b3b13acca5a6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-05	105.5750	f
01a09b0f-e6c0-78e0-998f-384e52f7e32d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-05	101.7700	f
01a09b0f-e6c0-7908-91f0-d11872804c2d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-19	99.1660	f
01a09b0f-e6c0-7926-aa70-8cc624d6258c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-09	111.6150	f
01a09b0f-e6c0-7934-8adb-a50414854357	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-15	110.1400	f
01a09b0f-e6c0-793b-99df-6173e05ea6b2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-10	100.5700	f
01a09b0f-e6c0-795c-a493-36b3444b3c37	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-01	109.3600	f
01a09b0f-e6c0-7965-b755-99bb52473be9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-06	100.4750	f
01a09b0f-e6c0-79b0-81ae-252abebfdc4d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-16	106.8900	f
01a09b0f-e6c0-79b0-8a72-e2f660645d13	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-02	99.3160	f
01a09b0f-e6c0-79b3-9c4e-10b5294aceab	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-23	108.6850	f
01a09b0f-e6c0-79bd-845e-4c67975ef64e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-14	90.8020	f
01a09b0f-e6c0-79bf-8b33-3b92c7ce6597	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-22	105.8450	f
01a09b0f-e6c0-79ce-83e9-96e842698e81	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-17	88.7380	f
01a09b0f-e6c0-79ea-9584-33d5599bfe5e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-02	104.6500	f
01a09b0f-e6c0-79f7-8aa4-d43022be7700	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-22	108.6200	f
01a09b0f-e6c0-7a0d-9774-3d98614747f7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-03	93.8140	f
01a09b0f-e6c0-7a31-9380-47184270f2e4	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-30	100.7100	f
01a09b0f-e6c0-7a3c-9ea4-80ab701068d5	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-12	98.1260	f
01a09b0f-e6c0-7a4c-b373-9dcb2efa79c9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-20	99.7300	f
01a09b0f-e6c0-7a52-b0e2-f50e431acd17	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-07	94.3500	f
01a09b0f-e6c0-7a7a-9d73-c453ab1ad05c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-11	97.3160	f
01a09b0f-e6c0-7a7f-8178-2463ec2af52f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-30	92.8360	f
01a09b0f-e6c0-7aad-81cf-508eef704815	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-25	101.7450	f
01a09b0f-e6c0-7aae-bdf1-c70e7b732c40	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-17	99.7280	f
01a09b0f-e6c0-7abc-a745-40540c210c89	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-25	108.5150	f
01a09b0f-e6c0-7ac8-9cca-8ce3aa917c70	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-23	90.5500	f
01a09b0f-e6c0-7aef-8aa5-9036f732370a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-15	105.4900	f
01a09b0f-e6c0-7b39-8b55-b01389bca666	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-07	99.8840	f
01a09b0f-e6c0-7b7a-bf65-2e0fea304983	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-02	98.5720	f
01a09b0f-e6c0-7b85-b66d-4af574b7c956	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-03	105.5600	f
01a09b0f-e6c0-7bc3-a440-62f4da995c50	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-25	100.2000	f
01a09b0f-e6c0-7bd6-8d39-bcf168f16535	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-20	99.2320	f
01a09b0f-e6c0-7be7-bb97-54bb91e2f55c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-29	105.6450	f
01a09b0f-e6c0-7c0d-b24b-7b54525d8be7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-07	104.2150	f
01a09b0f-e6c0-7c12-8c44-bd3694470e30	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-18	105.6500	f
01a09b0f-e6c0-7c1c-929c-3b9f75283375	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-19	108.2950	f
01a09b0f-e6c0-7c28-82ff-4c94ac8764c0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-26	98.5080	f
01a09b0f-e6c0-7c2a-acab-7715a7642a1b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-02-28	107.7650	f
01a09b0f-e6c0-7c62-8c83-2a3a6757c506	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-08	90.5160	f
01a09b0f-e6c0-7c6c-89bf-0607d2a19b03	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-16	90.0360	f
01a09b0f-e6c0-7c7e-9d2a-0110301b9ba7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-06	101.9550	f
01a09b0f-e6c0-7c80-87aa-d30c999235f8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-08	101.7350	f
01a09b0f-e6c0-7c85-986e-844f47b93ad1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-02-27	109.1400	f
01a09b0f-e6c0-7cad-bb44-60e6d854b9e2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-10	106.8400	f
01a09b0f-e6c0-7cc4-b119-fe5ac2ba79e5	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-02-25	107.3650	f
01a09b0f-e6c0-7cc9-8fc5-71cda654aa41	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-17	106.7650	f
01a09b0f-e6c0-7ccf-b91b-2915543c4e28	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-10	109.4150	f
01a09b0f-e6c0-7d05-af12-d4598d74fb12	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-15	107.7150	f
01a09b0f-e6c0-7d08-bb6d-92d8946ed0d6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-13	97.2500	f
01a09b0f-e6c0-7d5d-b93f-71b6248c2dae	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-05	95.3820	f
01a09b0f-e6c0-7d71-b208-e86d98ad1ad6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-26	101.3350	f
01a09b0f-e6c0-7d7d-a027-136110ee58ed	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-03	107.7450	f
01a09b0f-e6c0-7d9e-b3c3-908f82dda0f7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-10	99.3740	f
01a09b0f-e6c0-7daf-b641-459b2f4769f3	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-13	99.3080	f
01a09b0f-e6c0-7db4-ba59-879b6f72e09a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-23	97.6840	f
01a09b0f-e6c0-7dc8-bbdb-8f5f4abdc5bf	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-06	104.2300	f
01a09b0f-e6c0-7dea-ad36-9c0f21d7ad5c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-24	108.5450	f
01a09b0f-e6c0-7df0-a253-fbdd8d39ed31	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-12	105.2800	f
01a09b0f-e6c0-7df2-b931-94326a731923	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-18	99.6460	f
01a09b0f-e6c0-7dff-b204-9d87009e2b7c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-04	89.8620	f
01a09b0f-e6c0-7e00-ac3d-44b34af43cc2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-28	92.0820	f
01a09b0f-e6c0-7e08-ab81-544867ed8f07	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-21	99.4240	f
01a09b0f-e6c0-7e52-979c-f2d31ec46f9e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-11	105.3700	f
01a09b0f-e6c0-7e5f-9b28-93a0c8b7072b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-07	101.6900	f
01a09b0f-e6c0-7e9b-8926-64958dbf3b58	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-24	103.5900	f
01a09b0f-e6c0-7e9d-93f3-ca69ac97869d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-16	109.8150	f
01a09b0f-e6c0-7eb7-b269-5525aab8b45c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-16	99.6860	f
01a09b0f-e6c0-7eb8-a48a-434a92b35825	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-14	100.4650	f
01a09b0f-e6c0-7ec8-8c58-baf269ee9839	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-07-16	101.4600	f
01a09b0f-e6c0-7eca-96c0-2ee5741f53a2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-27	99.4340	f
01a09b0f-e6c0-7f13-b99e-c988bc808531	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-09	100.4950	f
01a09b0f-e6c0-7f1a-a431-220043d95a06	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-13	110.2050	f
01a09b0f-e6c0-7f27-8818-5de0ae871bed	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-09	106.1750	f
01a09b0f-e6c0-7f3c-a99c-486f6b0f9911	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-05-19	100.7950	f
01a09b0f-e6c0-7f58-b6df-ca44fa15c45b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-27	106.8300	f
01a09b0f-e6c0-7f67-88da-3aa9a369d63d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-03-28	98.4520	f
01a09b0f-e6c0-7f68-8565-cc24dd9fc9fc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-09-29	108.7650	f
01a09b0f-e6c0-7f86-abb5-9c056ad571af	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-04-15	91.5600	f
01a09b0f-e6c0-7f8f-9b04-cf3386ad003a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-08-04	104.3750	f
01a09b0f-e6c0-7f90-bd79-4ee343a01434	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-26	100.1200	f
01a09b0f-e6c0-7fb4-9722-91fd1aa0653d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-12	99.6260	f
01a09b0f-e6c0-7ff7-8ab3-e6c2093eaa62	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-06-03	100.1400	f
01a09b0f-e6c1-702a-ba00-dec02089365d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-12	113.2600	f
01a09b0f-e6c1-702d-8c7c-e92fdb75030c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-23	111.5400	f
01a09b0f-e6c1-7038-8b03-1a2b44695014	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-12	124.0400	f
01a09b0f-e6c1-70b5-899d-b7199f6cf92f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-05	119.4200	f
01a09b0f-e6c1-70b8-8c75-4e9d0b330cda	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-13	127.8350	f
01a09b0f-e6c1-70ba-aacc-8ec9b5c47a8f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-19	112.2300	f
01a09b0f-e6c1-70fa-af93-b7abad61bce6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-16	127.6850	f
01a09b0f-e6c1-70ff-9b8b-a5f1723c7fbf	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-22	126.1350	f
01a09b0f-e6c1-710d-813d-542a498d9180	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-05	125.2250	f
01a09b0f-e6c1-7126-951a-aea63e90ab52	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-19	126.1650	f
01a09b0f-e6c1-712a-b68e-53a860040c76	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-26	112.8900	f
01a09b0f-e6c1-713e-a226-635445282129	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-17	129.6450	f
01a09b0f-e6c1-713f-bb6b-ee95aa37f891	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-01	127.4050	f
01a09b0f-e6c1-715c-b5e4-7ad753a1bdd3	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-23	112.5100	f
01a09b0f-e6c1-717c-93cd-1bcfb9eb9f61	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-17	111.2550	f
01a09b0f-e6c1-7190-953a-b1e0d32c47c5	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-28	113.2450	f
01a09b0f-e6c1-719c-8c6c-569b093ad77f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-04	113.5750	f
01a09b0f-e6c1-719e-82cd-999814b9a7d0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-15	127.6100	f
01a09b0f-e6c1-71a5-9c5d-a4f4d09b0fff	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-03	127.2100	f
01a09b0f-e6c1-71a9-9c24-94b5ec0b4751	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-02	128.0100	f
01a09b0f-e6c1-71b4-9547-931124a6cb9b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-11	112.6050	f
01a09b0f-e6c1-71c2-9465-d5cb56b5fd6a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-07	129.6450	f
01a09b0f-e6c1-71c3-b0f6-3affc1a62d30	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-12	112.0450	f
01a09b0f-e6c1-71ea-aef2-62ffee55983a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-17	116.4500	f
01a09b0f-e6c1-7210-a28c-f43cb084f074	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-03	112.8800	f
01a09b0f-e6c1-7229-a945-e4441c9619aa	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-27	111.9050	f
01a09b0f-e6c1-7232-9354-421bcc59a759	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-30	126.4050	f
01a09b0f-e6c1-723b-abcc-65ce70f99488	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-19	111.9600	f
01a09b0f-e6c1-724e-b7d6-36ee91bf5b20	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-05	111.2650	f
01a09b0f-e6c1-7274-b58d-9d0ecb28690a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-09	111.9200	f
01a09b0f-e6c1-7279-b9df-3a8ba6217ccf	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-27	112.7950	f
01a09b0f-e6c1-7283-9bba-49f97e244740	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-24	126.8100	f
01a09b0f-e6c1-7287-bfdf-900fdf0a1bc7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-05	113.3300	f
01a09b0f-e6c1-7296-8409-03f044009755	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-06	112.2650	f
01a09b0f-e6c1-72a2-8bd1-f4018f26709d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-27	113.0150	f
01a09b0f-e6c1-72cc-b127-3412b05d64ab	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-08	127.8750	f
01a09b0f-e6c1-72cf-a64d-556510ae4886	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-20	112.5100	f
01a09b0f-e6c1-72d0-85ba-64f45bd8aaa9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-04	125.6700	f
01a09b0f-e6c1-72d7-977f-d4eb7654dbb8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-14	127.3300	f
01a09b0f-e6c1-72ed-90ee-e624ba4130af	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-12	111.5200	f
01a09b0f-e6c1-72f8-9734-a05ffde4b2a0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-28	117.1750	f
01a09b0f-e6c1-72fe-b29d-abd69467b1e6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-19	128.0300	f
01a09b0f-e6c1-7303-a50a-84f642dd454c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-31	107.5750	f
01a09b0f-e6c1-730a-9403-60f44c778881	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-30	117.7400	f
01a09b0f-e6c1-730b-85a7-fb2ed3b42d0a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-31	124.8200	f
01a09b0f-e6c1-7314-8c05-b4a4cd3a57fd	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-02	113.6200	f
01a09b0f-e6c1-7316-9766-99e574ff8858	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-13	130.4000	f
01a09b0f-e6c1-731a-ae9c-a568af21bbbd	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-07	120.8100	f
01a09b0f-e6c1-7325-a94d-a385c3634759	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-07	109.1650	f
01a09b0f-e6c1-7335-b344-172f7fa2b377	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-19	122.0900	f
01a09b0f-e6c1-7338-add9-47d8e300c132	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-18	128.4550	f
01a09b0f-e6c1-7338-bca5-b80df8462fa6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-28	129.3250	f
01a09b0f-e6c1-734a-8440-f06c8ef4a188	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-18	122.2950	f
01a09b0f-e6c1-7359-886c-f60c1cb34ac1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-03	126.6400	f
01a09b0f-e6c1-7360-ab29-9fb545d84e31	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-20	122.9800	f
01a09b0f-e6c1-7363-a0be-29f91bff3f2e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-21	109.8250	f
01a09b0f-e6c1-736a-8501-94c116f4ca79	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-14	111.5800	f
01a09b0f-e6c1-7380-a31b-6b725a182f78	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-23	113.0900	f
01a09b0f-e6c1-738e-8946-26e16863172b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-29	117.5300	f
01a09b0f-e6c1-73ad-9fb5-6617b8c3427b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-12	114.6900	f
01a09b0f-e6c1-73b3-9aa9-66f44383ac6f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-29	113.5900	f
01a09b0f-e6c1-73ca-a971-c3637dd8cfcb	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-25	126.9900	f
01a09b0f-e6c1-73cf-b2c1-fe7baa1c0ecc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-16	112.1400	f
01a09b0f-e6c1-73ea-9c32-1e33cc49b636	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-04	112.7650	f
01a09b0f-e6c1-73ef-8f5f-ddcace9348e7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-16	110.8800	f
01a09b0f-e6c1-7411-95cd-406ed12936a0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-16	110.7700	f
01a09b0f-e6c1-7417-b9e5-d71dc17f9835	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-24	112.1550	f
01a09b0f-e6c1-7425-97e5-1fcfd895c638	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-03	112.4950	f
01a09b0f-e6c1-7478-9914-7d0b36a1dc4a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-09	111.5850	f
01a09b0f-e6c1-7487-8ab8-7857782bcffd	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-07	126.4900	f
01a09b0f-e6c1-748c-80ad-320856dbe0e5	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-13	112.0150	f
01a09b0f-e6c1-7498-b4fb-9a0d07164243	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-23	125.1650	f
01a09b0f-e6c1-74b9-8dfd-06eb52aa63c9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-01	127.6100	f
01a09b0f-e6c1-74bc-b6f4-b3bce80fb459	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-31	127.6700	f
01a09b0f-e6c1-74e6-90bc-8c3cfd2a316f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-25	111.5700	f
01a09b0f-e6c1-74ea-b67c-1927435de38f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-02	112.7500	f
01a09b0f-e6c1-750c-b128-345153c9f83a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-12	120.7750	f
01a09b0f-e6c1-751b-9f34-e09df3ea9767	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-10	122.2300	f
01a09b0f-e6c1-752c-96f9-8ce6b7bc2a38	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-04	118.6000	f
01a09b0f-e6c1-753a-9833-d5921d1c40fb	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-26	112.4950	f
01a09b0f-e6c1-754a-a762-181354dedbfb	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-05	113.6850	f
01a09b0f-e6c1-755d-b053-ecfe67215bce	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-03	125.8250	f
01a09b0f-e6c1-7566-a12e-114e1b0dd49f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-24	109.2350	f
01a09b0f-e6c1-75e7-9af8-4e5db1f2bce8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-25	125.0450	f
01a09b0f-e6c1-75fb-920e-288298638a09	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-28	126.0750	f
01a09b0f-e6c1-761c-99d8-34c0b19185f9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-18	111.5700	f
01a09b0f-e6c1-761d-bbd4-7c826ecb13fb	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-10	112.5850	f
01a09b0f-e6c1-761e-a286-4d1d9880c940	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-11	121.3950	f
01a09b0f-e6c1-7627-8b1d-0101a945245f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-15	114.2200	f
01a09b0f-e6c1-762a-9e67-78e06b3e420f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-11	122.1550	f
01a09b0f-e6c1-763e-a7a3-af31d3eefffe	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-30	113.7700	f
01a09b0f-e6c1-7652-9670-00dfe1e91c79	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-24	111.4550	f
01a09b0f-e6c1-766b-a1c3-1b115baf5591	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-10	129.7850	f
01a09b0f-e6c1-767d-9bf4-5e32f36fec6b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-09	114.8400	f
01a09b0f-e6c1-7695-af09-efb8f7a29ef9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-08	113.1000	f
01a09b0f-e6c1-76bc-ae88-63ac0de1e084	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-21	116.2600	f
01a09b0f-e6c1-76d5-9604-ea0dc7512090	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-09	112.6000	f
01a09b0f-e6c1-76e0-b182-a8896a19305e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-05	113.4350	f
01a09b0f-e6c1-76fb-9e31-f279e90773a0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-17	125.1350	f
01a09b0f-e6c1-770c-8559-4d3fa5769681	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-17	126.1400	f
01a09b0f-e6c1-7729-8825-1daff75b72c6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-23	117.5950	f
01a09b0f-e6c1-772e-b3f6-02273f057ff9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-06	113.7300	f
01a09b0f-e6c1-7762-a863-7918bb2dd91b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-30	107.6650	f
01a09b0f-e6c1-7772-9151-dd4cd785b295	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-25	124.9200	f
01a09b0f-e6c1-7780-b63a-a4292b9d0c94	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-21	126.9550	f
01a09b0f-e6c1-7781-a309-fcad7cb15e3c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-13	111.0500	f
01a09b0f-e6c1-77c2-a505-d20201d381ea	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-10	112.2100	f
01a09b0f-e6c1-77da-9d35-29de76e098b7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-20	126.6250	f
01a09b0f-e6c1-77ff-9bdf-82e2b5175ed6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-22	112.3450	f
01a09b0f-e6c1-7809-9dc9-f390c0cae7ec	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-08	125.8900	f
01a09b0f-e6c1-7813-89e8-d227909f645b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-17	111.1650	f
01a09b0f-e6c1-7819-b80d-179a01d6515a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-14	113.8700	f
01a09b0f-e6c1-7830-af5d-dcb11c3a139f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-02	112.9500	f
01a09b0f-e6c1-7861-bf47-494663807d61	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-01	125.9150	f
01a09b0f-e6c1-7886-9e39-7c4819de2f93	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-23	111.0450	f
01a09b0f-e6c1-7890-9cb6-33f23a700213	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-25	113.0000	f
01a09b0f-e6c1-789a-9016-fe5dafb7f399	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-06	127.3700	f
01a09b0f-e6c1-78a2-ae59-60c9cd27e03d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-01	109.4400	f
01a09b0f-e6c1-78bd-a8bd-264cfc0804f8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-11	112.7550	f
01a09b0f-e6c1-78e7-bef9-c8be7348753f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-04	113.5150	f
01a09b0f-e6c1-78f5-9b1c-d24fc8e54b68	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-22	127.2000	f
01a09b0f-e6c1-7902-8182-4779edd15c41	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-26	112.6200	f
01a09b0f-e6c1-790f-8424-3299cef40c4d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-12	111.3100	f
01a09b0f-e6c1-792e-91cd-e9420d8fac0e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-24	117.5600	f
01a09b0f-e6c1-792f-9e86-03b4ac9e452b	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-30	123.8200	f
01a09b0f-e6c1-793d-91cb-3f777f106e99	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-08	114.0250	f
01a09b0f-e6c1-793f-8419-3b6a4184270d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-28	113.2200	f
01a09b0f-e6c1-793f-8dab-a7e359ba6dc9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-22	117.0650	f
01a09b0f-e6c1-7940-9edf-908308a6d13a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-12	129.6100	f
01a09b0f-e6c1-7943-b281-62f5c9c57bf1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-07	114.2800	f
01a09b0f-e6c1-794c-9419-08cc752ea8c1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-11	127.8650	f
01a09b0f-e6c1-7955-b636-f8c14228f342	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-15	115.4350	f
01a09b0f-e6c1-7961-8152-ba1ff6702786	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-17	112.2750	f
01a09b0f-e6c1-7980-b9bf-225c1baa0cfe	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-23	125.5850	f
01a09b0f-e6c1-79a3-b8ae-f9570e5c5551	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-09	126.9650	f
01a09b0f-e6c1-79a5-a35e-e821e312c627	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-31	113.7700	f
01a09b0f-e6c1-79ab-b69b-67a829bd0b20	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-26	127.2500	f
01a09b0f-e6c1-79ba-9388-4df4ba695aa0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-18	125.8100	f
01a09b0f-e6c1-79d3-a3aa-2640f077847a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-10	127.5700	f
01a09b0f-e6c1-79e2-89dc-c3741efb2ee1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-25	109.9500	f
01a09b0f-e6c1-79e9-9d2b-fa6c250bec7c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-30	112.7950	f
01a09b0f-e6c1-79ec-bd14-9b2e8e676159	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-27	128.0750	f
01a09b0f-e6c1-7a4a-84b8-bca7904771bc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-27	112.1100	f
01a09b0f-e6c1-7a50-b22b-03462edcb960	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-16	115.1300	f
01a09b0f-e6c1-7a63-8142-541e32bd22e6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-11	129.6350	f
01a09b0f-e6c1-7a71-9582-e23fbcfdaac8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-16	125.4450	f
01a09b0f-e6c1-7a75-8ec6-ac9dc27c007c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-05	113.3350	f
01a09b0f-e6c1-7a8c-97b8-71f853b73232	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-15	123.3300	f
01a09b0f-e6c1-7a8d-9d56-2ffde14e4d9e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-04	128.2450	f
01a09b0f-e6c1-7a8f-9fa3-1e2a9713f74a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-10	112.5200	f
01a09b0f-e6c1-7a93-bda0-5a65b5f73c4d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-20	127.0700	f
01a09b0f-e6c1-7a9f-9810-8a3ca8aad53f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-13	111.6050	f
01a09b0f-e6c1-7aa1-8e38-f19e773c6d68	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-04	129.1350	f
01a09b0f-e6c1-7aa5-b835-a95185dbe767	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-24	126.1850	f
01a09b0f-e6c1-7aa7-8554-8953ecf2500a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-29	112.6850	f
01a09b0f-e6c1-7ad5-8c1c-8a50991dac11	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-02	126.3150	f
01a09b0f-e6c1-7ad8-ac00-9f7d0db59740	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-26	124.8650	f
01a09b0f-e6c1-7aed-b400-05aa4828e0d7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-22	110.6350	f
01a09b0f-e6c1-7b05-8d38-389a34f4fcfb	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-29	125.1150	f
01a09b0f-e6c1-7b05-aa5f-0c4b453fe1fa	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-03	112.6700	f
01a09b0f-e6c1-7b1a-8f4d-98a3b291489f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-14	123.9450	f
01a09b0f-e6c1-7b4e-a833-e772fd85fed2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-29	125.3200	f
01a09b0f-e6c1-7b55-a4d9-168cc2d3bf16	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-18	112.3650	f
01a09b0f-e6c1-7b58-8e09-6b275f91b6f4	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-06	120.3850	f
01a09b0f-e6c1-7b5c-a405-53ca13f7d3e5	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-05	129.5400	f
01a09b0f-e6c1-7b71-a9b7-d9951e04e378	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-19	110.2300	f
01a09b0f-e6c1-7b72-a6fa-bae5cba068b8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-10	112.7750	f
01a09b0f-e6c1-7bb5-b5dd-7fab9906a5b6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-15	111.4650	f
01a09b0f-e6c1-7be2-9520-60eba8dc10a1	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-21	123.2100	f
01a09b0f-e6c1-7be2-9be1-af04a507c2fb	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-07	110.1200	f
01a09b0f-e6c1-7be6-a59e-f9b6e5ad0a82	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-10-21	111.3400	f
01a09b0f-e6c1-7be9-b0c2-3866bc6a825d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-13	112.1750	f
01a09b0f-e6c1-7bf0-8a66-23840831b864	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-21	127.1450	f
01a09b0f-e6c1-7bf9-ab52-297f1f979f7c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-20	116.0950	f
01a09b0f-e6c1-7c02-965e-36d4dc7e4863	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-26	108.9000	f
01a09b0f-e6c1-7c15-b872-9455e0da4175	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-10	126.5450	f
01a09b0f-e6c1-7c28-a0f2-b2ad0fd66bb5	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-02	126.2400	f
01a09b0f-e6c1-7c77-9c5b-4149d6ed40ba	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-09	127.0950	f
01a09b0f-e6c1-7c7b-9912-17d5988451ba	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-20	111.2050	f
01a09b0f-e6c1-7ccf-9533-999a0bd5a8ff	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-27	125.5600	f
01a09b0f-e6c1-7cd7-899c-8ca71f152975	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-08	121.0250	f
01a09b0f-e6c1-7cde-831e-1fadfd56b6c8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-24	126.3300	f
01a09b0f-e6c1-7cfb-9139-c53eee0037e4	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-03	113.9100	f
01a09b0f-e6c1-7d0e-8185-6593e1c17c3f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-20	112.4650	f
01a09b0f-e6c1-7d13-9ec9-2a5e4c9a3dac	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-06	129.3000	f
01a09b0f-e6c1-7d24-a307-60a766e5a70c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-10	112.9250	f
01a09b0f-e6c1-7d48-97f3-7605543ca008	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-18	111.5350	f
01a09b0f-e6c1-7d4a-973f-905616c23c0d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-29	111.2300	f
01a09b0f-e6c1-7d51-9c74-5db6886852c9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-28	112.4550	f
01a09b0f-e6c1-7d57-bd61-66a8b05dfaa8	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-08-14	129.8400	f
01a09b0f-e6c1-7d7b-b668-493216327895	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-17	110.2200	f
01a09b0f-e6c1-7d98-bc75-8816f04e1cf7	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-11	112.2050	f
01a09b0f-e6c1-7d9a-ad0a-75d18ca367be	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-23	109.4050	f
01a09b0f-e6c1-7dc3-b981-4ea185beb926	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-15	125.7950	f
01a09b0f-e6c1-7dcf-891a-6923a04dd8bc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-07	128.0200	f
01a09b0f-e6c1-7de5-b24f-87ad6355d689	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-01	112.7500	f
01a09b0f-e6c1-7df0-9e38-c3cbc175f01e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-08	111.4300	f
01a09b0f-e6c1-7df4-bc69-91ac40f96f29	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-26	124.7600	f
01a09b0f-e6c1-7e0b-be6f-8706f2358b4c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-07-29	125.1150	f
01a09b0f-e6c1-7e29-b2b1-96d980bad35a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-08	124.3250	f
01a09b0f-e6c1-7e42-b05b-05a849883a3d	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-04	112.3500	f
01a09b0f-e6c1-7e55-ac68-dbdb7b47500a	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-27	107.1650	f
01a09b0f-e6c1-7e5b-b588-0aa2e2697a24	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-14	113.4650	f
01a09b0f-e6c1-7e6a-aa68-8d2d97835807	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-22	113.2950	f
01a09b0f-e6c1-7e70-b67b-df1b9018ec88	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-27	117.4850	f
01a09b0f-e6c1-7e7a-abca-e99e7790c037	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-04-02	109.6450	f
01a09b0f-e6c1-7e93-8976-0716a17cd9d9	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-13	122.0500	f
01a09b0f-e6c1-7e96-8a94-2b2e92116fff	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-16	115.2150	f
01a09b0f-e6c1-7e96-8fd8-afb492f048b3	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-28	125.1050	f
01a09b0f-e6c1-7ec9-97b3-0a4c109833f2	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-22	124.6100	f
01a09b0f-e6c1-7ef8-b061-ed3aebd3f532	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-02	111.9800	f
01a09b0f-e6c1-7eff-84e1-511660d50ba0	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-18	109.8950	f
01a09b0f-e6c1-7f05-a1b3-abcf68b57e6c	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-30	112.2850	f
01a09b0f-e6c1-7f1c-ab32-c3a3e9d24ef6	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-12-09	113.2650	f
01a09b0f-e6c1-7f2d-9d81-7059b5f69943	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-19	113.3400	f
01a09b0f-e6c1-7f2f-a1c2-cae2ee1beb70	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-13	115.0000	f
01a09b0f-e6c1-7f50-9007-dae8324a57fc	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-20	109.1000	f
01a09b0f-e6c1-7f69-92ad-43712cee5951	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2025-11-06	111.7500	f
01a09b0f-e6c1-7f87-9454-06f946a8212e	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-02-11	112.4300	f
01a09b0f-e6c1-7fb0-a654-2a394d7c2f5f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-09-03	128.8400	f
01a09b0f-e6c1-7fc9-8c45-196de5928387	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-03-19	109.9400	f
01a09b0f-e6c1-7fec-b7e7-85325fa65fd3	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-01-21	112.5650	f
01a09b0f-e6c1-7ff0-ab1a-bc0cc0ebdd82	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-05-27	124.5400	f
01a09b0f-e6c1-7ff4-a9a1-35939bba0f9f	01a09aec-feb5-7f7b-8f8d-14bc5bcdda1c	2026-06-09	122.4150	f
\.


--
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: andreeahusleag
--

COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20260913102839_InitialCreate	10.0.9
20260913112345_AddInvestments	10.0.9
20260913133818_AddTransferLink	10.0.9
20260913134156_AddTransferDirection	10.0.9
20260913204014_AddCashTransactionCurrency	10.0.9
20260913205504_AddAccountBalanceDate	10.0.9
20260914091255_AddCashTransactionAffectsBalance	10.0.9
\.


--
-- Name: Accounts PK_Accounts; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."Accounts"
    ADD CONSTRAINT "PK_Accounts" PRIMARY KEY ("Id");


--
-- Name: Assets PK_Assets; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."Assets"
    ADD CONSTRAINT "PK_Assets" PRIMARY KEY ("Id");


--
-- Name: CashTransactions PK_CashTransactions; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."CashTransactions"
    ADD CONSTRAINT "PK_CashTransactions" PRIMARY KEY ("Id");


--
-- Name: Categories PK_Categories; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."Categories"
    ADD CONSTRAINT "PK_Categories" PRIMARY KEY ("Id");


--
-- Name: InvestmentAccounts PK_InvestmentAccounts; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."InvestmentAccounts"
    ADD CONSTRAINT "PK_InvestmentAccounts" PRIMARY KEY ("Id");


--
-- Name: InvestmentTransactions PK_InvestmentTransactions; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."InvestmentTransactions"
    ADD CONSTRAINT "PK_InvestmentTransactions" PRIMARY KEY ("Id");


--
-- Name: PriceHistory PK_PriceHistory; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."PriceHistory"
    ADD CONSTRAINT "PK_PriceHistory" PRIMARY KEY ("Id");


--
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- Name: IX_Assets_Ticker; Type: INDEX; Schema: public; Owner: andreeahusleag
--

CREATE UNIQUE INDEX "IX_Assets_Ticker" ON public."Assets" USING btree ("Ticker");


--
-- Name: IX_CashTransactions_AccountId; Type: INDEX; Schema: public; Owner: andreeahusleag
--

CREATE INDEX "IX_CashTransactions_AccountId" ON public."CashTransactions" USING btree ("AccountId");


--
-- Name: IX_CashTransactions_CategoryId; Type: INDEX; Schema: public; Owner: andreeahusleag
--

CREATE INDEX "IX_CashTransactions_CategoryId" ON public."CashTransactions" USING btree ("CategoryId");


--
-- Name: IX_InvestmentTransactions_AssetId; Type: INDEX; Schema: public; Owner: andreeahusleag
--

CREATE INDEX "IX_InvestmentTransactions_AssetId" ON public."InvestmentTransactions" USING btree ("AssetId");


--
-- Name: IX_InvestmentTransactions_InvestmentAccountId; Type: INDEX; Schema: public; Owner: andreeahusleag
--

CREATE INDEX "IX_InvestmentTransactions_InvestmentAccountId" ON public."InvestmentTransactions" USING btree ("InvestmentAccountId");


--
-- Name: IX_PriceHistory_AssetId; Type: INDEX; Schema: public; Owner: andreeahusleag
--

CREATE INDEX "IX_PriceHistory_AssetId" ON public."PriceHistory" USING btree ("AssetId");


--
-- Name: CashTransactions FK_CashTransactions_Accounts_AccountId; Type: FK CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."CashTransactions"
    ADD CONSTRAINT "FK_CashTransactions_Accounts_AccountId" FOREIGN KEY ("AccountId") REFERENCES public."Accounts"("Id") ON DELETE CASCADE;


--
-- Name: CashTransactions FK_CashTransactions_Categories_CategoryId; Type: FK CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."CashTransactions"
    ADD CONSTRAINT "FK_CashTransactions_Categories_CategoryId" FOREIGN KEY ("CategoryId") REFERENCES public."Categories"("Id") ON DELETE CASCADE;


--
-- Name: InvestmentTransactions FK_InvestmentTransactions_Assets_AssetId; Type: FK CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."InvestmentTransactions"
    ADD CONSTRAINT "FK_InvestmentTransactions_Assets_AssetId" FOREIGN KEY ("AssetId") REFERENCES public."Assets"("Id") ON DELETE RESTRICT;


--
-- Name: InvestmentTransactions FK_InvestmentTransactions_InvestmentAccounts_InvestmentAccount~; Type: FK CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."InvestmentTransactions"
    ADD CONSTRAINT "FK_InvestmentTransactions_InvestmentAccounts_InvestmentAccount~" FOREIGN KEY ("InvestmentAccountId") REFERENCES public."InvestmentAccounts"("Id") ON DELETE CASCADE;


--
-- Name: PriceHistory FK_PriceHistory_Assets_AssetId; Type: FK CONSTRAINT; Schema: public; Owner: andreeahusleag
--

ALTER TABLE ONLY public."PriceHistory"
    ADD CONSTRAINT "FK_PriceHistory_Assets_AssetId" FOREIGN KEY ("AssetId") REFERENCES public."Assets"("Id") ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

