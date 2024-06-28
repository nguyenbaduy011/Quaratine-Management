--1. Thêm bệnh nhân mới:
CREATE OR REPLACE PROCEDURE add_benhnhan(
    p_mabn varchar(6),
    p_hoten VARCHAR(30),
    p_gioitinh BOOLEAN,
    p_ngaysinh DATE,
    p_diachi VARCHAR(4),
    p_sdt VARCHAR(10),
    p_quoctich VARCHAR(30),
    p_tinhtrang VARCHAR(50),
    p_tt_giamho VARCHAR(50),
    p_makhu VARCHAR(4),
    p_tgcachly INT,
    p_tgbdcachly DATE,
    p_tgktcachly DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO BENHNHAN (
        MABN, HOTEN, GIOITINH, NGAYSINH, DIACHI, SDT, QUOCTICH, TINHTRANG, TT_GIAMHO, MAKHU, TGCACHLY, TGBDCACHLY, TGKTCACHLY
    ) VALUES (
        p_mabn, p_hoten, p_gioitinh, p_ngaysinh, p_diachi, p_sdt, p_quoctich, p_tinhtrang, p_tt_giamho, p_makhu, p_tgcachly, p_tgbdcachly, p_tgktcachly
    );
END;
$$;

--2. Cập nhật thông tin bệnh nhân
CREATE OR REPLACE PROCEDURE update_benhnhan(
    p_mabn VARCHAR(6),
    p_hoten VARCHAR(30),
    p_gioitinh BOOLEAN,
    p_ngaysinh DATE,
    p_diachi VARCHAR(4),
    p_sdt VARCHAR(10),
    p_quoctich VARCHAR(30),
    p_tinhtrang VARCHAR(50),
	p_tt_giamho VARCHAR(50),
    p_makhu VARCHAR(4),
    p_tgcachly INT,
    p_tgbdcachly DATE,
    p_tgktcachly DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE BENHNHAN
    SET HOTEN = p_hoten,
        GIOITINH = p_gioitinh,
        NGAYSINH = p_ngaysinh,
        DIACHI = p_diachi,
        SDT = p_sdt,
        QUOCTICH = p_quoctich,
        TINHTRANG = p_tinhtrang,
        MAKHU = p_makhu,
        TGCACHLY = p_tgcachlY,
        TGBDCACHLY = p_tgbdcachlY,
        TGKTCACHLY = p_tgktcachlY,
        TT_GIAMHO = p_tt_giamho
    WHERE MABN = p_mabn;
END;
$$;

--3. Thêm cán bộ nhân viên
CREATE OR REPLACE PROCEDURE add_canbonv(
	p_macb VARCHAR(6),
    p_hoten VARCHAR(30),
    p_gioitinh BOOLEAN,
    p_macv VARCHAR(3),
    p_sdt VARCHAR(10),
    p_donvict VARCHAR(4),
    p_noihd VARCHAR(4)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO CANBONV (MACB, HOTEN, GIOITINH, MACV, SDT, DONVICT, NOIHD)
    VALUES (p_macb, p_hoten, p_gioitinh, p_macv, p_sdt, p_donvict, p_noihd);
END;
$$;

--4. Thêm bác sĩ
CREATE OR REPLACE PROCEDURE add_bacsi(
	p_mabs VARCHAR(6),
    p_hoten VARCHAR(30),
    p_gioitinh BOOLEAN,
    p_sdt VARCHAR(10),
    p_donvict VARCHAR(4),
    p_noihd VARCHAR(4),
    p_chuyenkhoa VARCHAR(3),
    p_macv VARCHAR(3)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO BACSI (MABS, HOTEN, GIOITINH, SDT, DONVICT, NOIHD, CHUYENKHOA, MACV)
    VALUES (p_mabs,p_hoten, p_gioitinh, p_sdt, p_donvict, p_noihd, p_chuyenkhoa, p_macv);
END;
$$;

--5. Thêm khu cách ly mới
CREATE OR REPLACE PROCEDURE add_khucachly(
    p_makhu VARCHAR(4),
    p_macs VARCHAR(4),
    p_diachi VARCHAR(4)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO KHUCACHLY (MAKHU, MACS, DIACHI)
    VALUES (p_makhu, p_macs, p_diachi);
END;
$$;

--6. Chuyển bệnh nhân từ khu cách ly này sang khu cách ly khác
CREATE OR REPLACE PROCEDURE transfer_benhnhan(
    p_mabn VARCHAR(6),
    p_from_makhu VARCHAR(4),
    p_to_makhu VARCHAR(4)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Kiểm tra xem khu cách ly mới có trùng với khu cách ly cũ không
    IF p_from_makhu = p_to_makhu THEN
        RAISE EXCEPTION 'Khu cách ly mới không được trùng với khu cách ly hiện tại';
    END IF;

    -- Kiểm tra xem bệnh nhân có tồn tại trong bảng BENHNHAN không
    IF NOT EXISTS (SELECT 1 FROM BENHNHAN WHERE BENHNHAN.MABN = p_mabn) THEN
        RAISE EXCEPTION 'Bệnh nhân với ID % không tồn tại', p_mabn;
    END IF;

    -- Kiểm tra xem khu cách ly hiện tại có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM KHUCACHLY WHERE KHUCACHLY.MAKHU = p_from_makhu) THEN
        RAISE EXCEPTION 'Khu cách ly hiện tại với ID % không tồn tại', p_from_makhu;
    END IF;

    -- Kiểm tra xem khu cách ly mới có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM KHUCACHLY WHERE KHUCACHLY.MAKHU = p_to_makhu) THEN
        RAISE EXCEPTION 'Khu cách ly mới với ID % không tồn tại', p_to_makhu;
    END IF;

    -- Kiểm tra xem bệnh nhân có đang ở trong khu cách ly hiện tại không
    IF NOT EXISTS (
        SELECT 1 FROM BENHNHAN WHERE MABN = p_mabn AND MAKHU = p_from_makhu
    ) THEN
        RAISE EXCEPTION 'Bệnh nhân với ID % không ở trong khu cách ly với ID %', p_mabn, p_from_makhu;
    END IF;

    -- Cập nhật thông tin khu cách ly mới cho bệnh nhân
    UPDATE BENHNHAN
    SET MAKHU = p_to_makhu, TGBDCACHLY = CURRENT_DATE
    WHERE MABN = p_mabn;

    -- Cập nhật số lượng bệnh nhân trong các khu cách ly
    UPDATE KHUCACHLY
    SET SOLUONGBN = SOLUONGBN - 1
    WHERE MAKHU = p_from_makhu;

    UPDATE KHUCACHLY
    SET SOLUONGBN = SOLUONGBN + 1
    WHERE MAKHU = p_to_makhu;

    RAISE NOTICE 'Bệnh nhân với ID % đã được chuyển từ khu cách ly với ID % sang khu cách ly với ID % vào ngày %',
                 p_mabn, p_from_makhu, p_to_makhu, CURRENT_DATE;
END;
$$;
