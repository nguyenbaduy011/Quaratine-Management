--1. Xem bệnh nhân ẩn thông tin số điện thoại, địa chỉ, thông tin giám hộ, khu cách ly
CREATE VIEW view_benhnhan AS
SELECT MABN, HOTEN, GIOITINH, NGAYSINH, QUOCTICH, TINHTRANG, TGCACHLY, TGBDCACHLY, TGKTCACHLY
FROM BENHNHAN;

--2. Xem bác sĩ ẩn thông tin số  điện thoại, địa chỉ của bác sĩ
CREATE VIEW view_bacsi AS
SELECT MABS, HOTEN, GIOITINH, CHUYENKHOA, NOIHD, MACV
FROM BACSI;

--3. Xem bệnh nhân đến từ thành phố Hồ Chí Minh
CREATE VIEW view_benhnhan_come_from_HCM AS
SELECT MABN, HOTEN, GIOITINH, NGAYSINH, QUOCTICH, TINHTRANG, TGCACHLY
FROM BENHNHAN
JOIN KHUVUC on BENHNHAN.DIACHI = KHUVUC.MAKV
WHERE KHUVUC.TENTINH = 'TPHCM';

--4. Xem bệnh nhân đã khỏi bệnh
CREATE VIEW view_benhnhan_cured AS
SELECT MABN, HOTEN, GIOITINH, NGAYSINH, QUOCTICH, TINHTRANG
FROM BENHNHAN
WHERE TINHTRANG = 'Khỏi bệnh';

--5. Xem thiết bị y tế
CREATE VIEW view_thietbiyte AS
SELECT CSVC.MATHIETBI, CSVC.TENTHIETBI, QLCSVCYTE.MACS, QLCSVCYTE.SL
FROM CSVC
JOIN QLCSVCYTE ON CSVC.MATHIETBI = QLCSVCYTE.MATHIETBI;

--6. Xem bệnh nhân đến từ thành phố Hồ Chí Minh đã khỏi bệnh
CREATE VIEW view_benhnhan_come_from_HCM_and_cured AS
SELECT MABN, HOTEN, GIOITINH, NGAYSINH, QUOCTICH, TINHTRANG, TGCACHLY, TENTINH, TENHUYEN
FROM BENHNHAN
JOIN KHUVUC on BENHNHAN.DIACHI = KHUVUC.MAKV
WHERE KHUVUC.TENTINH = 'TPHCM' AND TINHTRANG = 'Khỏi bệnh';

