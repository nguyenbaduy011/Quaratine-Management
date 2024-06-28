--role admin
CREATE ROLE admin;
GRANT ALL ON ALL TABLES IN SCHEMA "public" TO admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "public" TO admin;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA "public" TO admin;
GRANT CONNECT ON DATABASE "postgres" TO admin;

--role bac_si
CREATE ROLE bac_si;
GRANT SELECT ON CANBONV, KHOA, BACSI, KHUVUC, KHUCACHLY, BENHNHAN, TNV TO bac_si;
GRANT UPDATE ON BENHNHAN TO bac_si;
GRANT EXECUTE ON PROCEDURE update_benhnhan TO bac_si;
GRANT EXECUTE ON FUNCTION get_benhnhan_by_status, get_benhnhan_by_id TO bac_si;
GRANT CONNECT ON DATABASE "postgres" TO bac_si;

--role nhan_vien
CREATE ROLE nhan_vien;
GRANT SELECT ON CSVC, QLCSVCYTE, CANBONV, BACSI, KHUVUC, KHUCACHLY, BENHNHAN, TNV TO nhan_vien;
GRANT INSERT, UPDATE ON BENHNHAN TO nhan_vien;
GRANT EXECUTE ON PROCEDURE add_benhnhan, update_benhnhan, transfer_benhnhan TO nhan_vien;
GRANT EXECUTE ON FUNCTION get_benhnhan_by_status, get_benhnhan_by_id,get_statistics_on_conditions, get_patients_statistics_on_provinces, get_adolescent_patients, get_middle_age_patients, get_elder_patients, get_patients_statistics_on_gender TO nhan_vien;
GRANT CONNECT ON DATABASE "postgres" TO nhan_vien;

--role giam_doc
CREATE ROLE giam_doc;
GRANT SELECT ON CSYT, CSVC, QLCSVCYTE, CHUCVU, CANBONV, KHOA, BACSI, KHUVUC, KHUCACHLY, BENHNHAN, TNV TO giam_doc;
GRANT INSERT ON QLCSVCYTE, CANBONV, BACSI, BENHNHAN, TNV TO giam_doc;
GRANT UPDATE ON QLCSVCYTE, CANBONV, BACSI, BENHNHAN, TNV TO giam_doc;
GRANT EXECUTE ON PROCEDURE add_benhnhan, update_benhnhan, add_canbonv, add_bacsi, transfer_benhnhan TO giam_doc;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "public" TO giam_doc;
GRANT CONNECT ON DATABASE "postgres" TO giam_doc;

--Users
CREATE USER admin1 WITH PASSWORD '123' LOGIN;
GRANT admin TO admin1;

CREATE USER bac_si_1 WITH PASSWORD '123' LOGIN;
CREATE USER bac_si_2 WITH PASSWORD '123' LOGIN;
CREATE USER bac_si_3 WITH PASSWORD '123' LOGIN;
GRANT bac_si TO bac_si_1, bac_si_2, bac_si_3;

CREATE USER nhan_vien_1 WITH PASSWORD '123' LOGIN;
CREATE USER nhan_vien_2 WITH PASSWORD '123' LOGIN;
CREATE USER nhan_vien_3 WITH PASSWORD '123' LOGIN;
GRANT nhan_vien TO nhan_vien_1, nhan_vien_2, nhan_vien_3;

CREATE USER giam_doc_1 WITH PASSWORD '123' LOGIN;
CREATE USER giam_doc_2 WITH PASSWORD '123' LOGIN;
CREATE USER giam_doc_3 WITH PASSWORD '123' LOGIN;
GRANT giam_doc TO giam_doc_1, giam_doc_2, giam_doc_3;


--re-grant on bac_si
REVOKE SELECT ON BENHNHAN FROM bac_si;
GRANT SELECT ON view_benhnhan TO bac_si; 

--re-grant on nhan_vien
REVOKE SELECT ON BENHNHAN FROM nhan_vien;
GRANT SELECT ON view_benhnhan TO nhan_vien; 

REVOKE SELECT ON BACSI FROM nhan_vien;
GRANT SELECT ON view_bacsi TO nhan_vien;



