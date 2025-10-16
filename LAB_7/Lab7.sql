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

