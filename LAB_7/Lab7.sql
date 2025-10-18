USE QLDA
GO
--Bài 1: (4 điểm)
--Viết các hàm:
-- Nhập vào MaNV cho biết tuổi của nhân viên này.
CREATE FUNCTION fn_TuoiNhanVien (@MaNV CHAR(9))
RETURNS INT
AS
BEGIN
    DECLARE @Tuoi INT
    SELECT @Tuoi = DATEDIFF(YEAR, NGSINH, GETDATE())
    FROM NhanVien
    WHERE MANV = @MaNV
    RETURN @Tuoi
END
GO
SELECT dbo.fn_TuoiNhanVien('001') AS TuoiNhanVien
GO
-- Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia
CREATE FUNCTION fn_SoLuongDeAnNV (@MaNV CHAR(9))
RETURNS INT
AS
BEGIN
    DECLARE @SoLuong INT
    SELECT @SoLuong = COUNT(MADA)
    FROM PHANCONG
    WHERE MA_NVIEN = @MaNV
    RETURN @SoLuong
END
GO
SELECT dbo.fn_SoLuongDeAnNV('001') AS SoDeAn
GO
-- Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái
CREATE FUNCTION fn_SoLuongTheoPhai (@Phai NVARCHAR(3))
RETURNS INT
AS
BEGIN
    DECLARE @SoLuong INT
    SELECT @SoLuong = COUNT(*)
    FROM NhanVien
    WHERE PHAI = @Phai
    RETURN @SoLuong
END
GO
SELECT dbo.fn_SoLuongTheoPhai(N'Nam') AS SoNam,
       dbo.fn_SoLuongTheoPhai(N'Nữ') AS SoNu
GO
-- Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung của phòng đó.
CREATE FUNCTION fn_NhanVienLuongTrenTB (@TenPhong NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT NV.HONV, NV.TENLOT, NV.TENNV, NV.LUONG
    FROM NhanVien NV
    JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
    WHERE PB.TENPHG = @TenPhong
      AND NV.LUONG > (
            SELECT AVG(LUONG)
            FROM NhanVien NV2
            JOIN PHONGBAN PB2 ON NV2.PHG = PB2.MAPHG
            WHERE PB2.TENPHG = @TenPhong
        )
)
GO
SELECT * FROM dbo.fn_NhanVienLuongTrenTB(N'Nghiên cứu')
GO
-- Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng và số lượng đề án mà phòng ban đó chủ trì.
CREATE FUNCTION fn_ThongTinPhong (@MaPhong INT)
RETURNS TABLE
AS
RETURN
(
    SELECT PB.TENPHG,
           (NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV) AS TruongPhong,
           COUNT(DA.MADA) AS SoDeAnChuTri
    FROM PHONGBAN PB
    LEFT JOIN NhanVien NV ON PB.TRPHG = NV.MANV
    LEFT JOIN DEAN DA ON PB.MAPHG = DA.PHONG
    WHERE PB.MAPHG = @MaPhong
    GROUP BY PB.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV
)
GO

-- Kiểm tra:
SELECT * FROM dbo.fn_ThongTinPhong(5)
GO

--Bài 2: Tạo view
-- 1️ Hiển thị HoNV, TenNV, TenPHG, DiaDiemPhg
CREATE VIEW v_ThongTinNhanVien_Phong
AS
SELECT HONV, TENNV, PB.TENPHG, DP.DIADIEM
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
JOIN DIADIEM_PHG DP ON PB.MAPHG = DP.MAPHG
GO

SELECT * FROM v_ThongTinNhanVien_Phong
go

-- 2️ Hiển thị TenNv, Lương, Tuổi
CREATE VIEW v_TenLuongTuoi
AS
SELECT TENNV, LUONG, YEAR(GETDATE()) - YEAR(NGSINH) AS TUOI
FROM NHANVIEN
GO

SELECT * FROM v_TenLuongTuoi
go

-- 3️ Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông NV nhất
CREATE VIEW v_PhongDongNhanVienNhat
AS
SELECT TOP 1 PB.TENPHG,
       NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS TruongPhong,
       COUNT(NV2.MANV) AS SoNhanVien
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.TRPHG = NV.MANV
JOIN NHANVIEN NV2 ON NV2.PHG = PB.MAPHG
GROUP BY PB.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV
ORDER BY COUNT(NV2.MANV) DESC
GO

SELECT * FROM v_PhongDongNhanVienNhat

