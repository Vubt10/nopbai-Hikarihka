use QLDA
-- BÀI 1: CÁC STORED PROCEDURE Cơ BẢN 
-- 1. In ra "Xin chào + tên"
go
CREATE OR ALTER PROC XinChao
    @ten NVARCHAR(50)
AS 
BEGIN
	Print N'Xin chào ' + @ten
END
GO
    EXEC XinChao N'Trần Hửu Hào'
GO
-- Câu 2: Nhập vào 2 số, in ra tổng
CREATE OR ALTER PROC TinhTong
    @s1 INT,
    @s2 INT
AS
BEGIN
    DECLARE @tg INT
    SET @tg = @s1 + @s2
    PRINT N'Tổng là: ' + CAST(@tg AS NVARCHAR(20))
END
GO

EXEC TinhTong 10, 20
GO
-- Câu 3: Tổng các số chẵn từ 1 đến @n
CREATE OR ALTER PROC TongTuN
    @n INT
AS 
BEGIN
    DECLARE @i INT = 2
    DECLARE @tong INT = 0
    
    WHILE @i <= @n
    BEGIN
        SET @tong = @tong + @i
        SET @i = @i + 2
    END
    
    PRINT N'Tổng các số chẵn từ 1 đến ' + CAST(@n AS NVARCHAR(20)) + N' là: ' + CAST(@tong AS NVARCHAR(20))
END
EXEC TongTuN 10
GO

-- Câu 4: Ước chung lớn nhất của 2 số
CREATE OR ALTER PROCEDURE sp_UCLN
    @a INT,
    @b INT
AS
BEGIN
    DECLARE @temp INT
    
    -- Đảm bảo @a <= @A
    IF @a > @A
    BEGIN
        SET @temp = @a
        SET @a = @A
        SET @b = @temp
    END
    
    -- Tìm UCLN
    WHILE @a != 0
    BEGIN
        SET @temp = @b % @a
        SET @b = @a
        SET @a = @temp
    END
    
    PRINT N'Ước chung lớn nhất là: ' + CAST(@b AS NVARCHAR(20))
END
GO

 
EXEC sp_UCLN 12, 18
GO


-- BÀI 2: THAO TÁC VỚI CSDL QLDA (3 điểm)
-- Câu 1: Xuất thông tin nhân viên theo mã
CREATE OR ALTER PROCEDURE sp_ThongTinNhanVien
    @Manv INT
AS
BEGIN
    SELECT * 
    FROM NHANVIEN
    WHERE MANV = @Manv
END
GO

 
EXEC sp_ThongTinNhanVien 1
GO

-- Câu 2: Số lượng nhân viên tham gia đề án
CREATE OR ALTER PROCEDURE sp_SoLuongNV_DeAn
    @MaDa INT
AS
BEGIN
    DECLARE @SoLuong INT
    
    SELECT @SoLuong = COUNT(DISTINCT MA_NVIEN)
    FROM PHANCONG
    WHERE MADA = @MaDa
    
    PRINT N'Số lượng nhân viên tham gia đề án ' + CAST(@MaDa AS NVARCHAR(10)) + N' là: ' + CAST(@SoLuong AS NVARCHAR(10))
END
GO

 
EXEC sp_SoLuongNV_DeAn 1
GO

-- Câu 3: Số lượng NV theo mã đề án và địa điểm
CREATE OR ALTER PROCEDURE sp_SoLuongNV_DeAn_DiaDiem
    @MaDa INT,
    @Ddiem_DA NVARCHAR(50)
AS
BEGIN
    DECLARE @SoLuong INT
    
    SELECT @SoLuong = COUNT(DISTINCT PC.MA_NVIEN)
    FROM PHANCONG PC
    JOIN DEAN DA ON PC.MADA = DA.MADA
    WHERE PC.MADA = @MaDa AND DA.DDIEM_DA = @Ddiem_DA
    
    PRINT N'Số lượng nhân viên: ' + CAST(@SoLuong AS NVARCHAR(10))
END
GO

 
EXEC sp_SoLuongNV_DeAn_DiaDiem 1, N'TP HCM'
GO

-- Câu 4: Nhân viên không có thân nhân theo trưởng phòng
CREATE OR ALTER PROCEDURE sp_NV_KhongThanNhan
    @Trphg INT
AS
BEGIN
    SELECT NV.*
    FROM NHANVIEN NV
    JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
    WHERE PB.TRPHG = @Trphg
    AND NV.MANV NOT IN (SELECT MANV FROM THANNHAN)
END
GO

EXEC sp_NV_KhongThanNhan 1
GO

-- Câu 5: Kiểm tra nhân viên có thuộc phòng ban không
CREATE OR ALTER PROCEDURE sp_KiemTraNV_PhongBan
    @Manv INT,
    @Mapb INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM NHANVIEN WHERE MANV = @Manv AND PHG = @Mapb)
        PRINT N'Nhân viên ' + CAST(@Manv AS NVARCHAR(10)) + N' thuộc phòng ban ' + CAST(@Mapb AS NVARCHAR(10))
    ELSE
        PRINT N'Nhân viên ' + CAST(@Manv AS NVARCHAR(10)) + N' KHÔNG thuộc phòng ban ' + CAST(@Mapb AS NVARCHAR(10))
END
GO

 
EXEC sp_KiemTraNV_PhongBan 1, 5
GO

-- BÀI 3: INSERT, UPDATE VỚI STORED PROCEDURE (3 điểm)


-- Câu 1: Thêm phòng ban CNTT
CREATE OR ALTER PROC sp_ThemPhongBan
    @Maphg NVARCHAR(9),
    @Tenphg NVARCHAR(30),
    @Trphg NVARCHAR(9),
    @Ng_Nhanchuc DATE
AS
BEGIN
    IF EXISTS (SELECT * FROM PHONGBAN WHERE MAPHG = @Maphg)
        PRINT N'Thêm thất bại: Mã phòng đã tồn tại'
    ELSE
    BEGIN
        INSERT INTO PHONGBAN(MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
        VALUES(@Maphg, @Tenphg, @Trphg, @Ng_Nhanchuc)
        PRINT N'Thêm phòng ban thành công'
    END
END
GO

EXEC sp_ThemPhongBan '010', N'CNTT', '005', '2024-01-01'
GO

-- Câu 2: Cập nhật phòng CNTT thành IT
CREATE OR ALTER PROC sp_UpdatePhongCNTT
AS
BEGIN
    UPDATE PHONGBAN
    SET TENPHG = N'IT'
    WHERE TENPHG = N'CNTT'
    PRINT N'Đã cập nhật phòng CNTT thành IT'
END
GO

EXEC sp_UpdatePhongCNTT
GO

USE QLDA
GO

-- 1. Thêm phòng ban CNTT (kiểm tra trùng MAPHG)
CREATE OR ALTER PROC sp_ThemPhongBan
    @Maphg NVARCHAR(9),
    @Tenphg NVARCHAR(30),
    @Trphg NVARCHAR(9),
    @Ng_Nhanchuc DATE
AS
BEGIN
    IF EXISTS (SELECT * FROM PHONGBAN WHERE MAPHG = @Maphg)
        PRINT N'Thêm thất bại: Mã phòng đã tồn tại'
    ELSE
    BEGIN
        INSERT INTO PHONGBAN(MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
        VALUES(@Maphg, @Tenphg, @Trphg, @Ng_Nhanchuc)
        PRINT N'Thêm phòng ban thành công'
    END
END
GO

-- 2. Cập nhật tên phòng CNTT -> IT
CREATE OR ALTER PROC sp_UpdatePhongCNTT
AS
BEGIN
    UPDATE PHONGBAN
    SET TENPHG = N'IT'
    WHERE TENPHG = N'CNTT'
    PRINT N'Đã cập nhật phòng CNTT thành IT'
END
GO

-- 3. Thêm nhân viên (có điều kiện)
use QLDA;
go

CREATE OR ALTER PROC sp_ThemNhanVien
    @Manv NVARCHAR(9),
    @Honv NVARCHAR(15),
    @Tenlot NVARCHAR(15),
    @Tennv NVARCHAR(15),
    @Phai NVARCHAR(3),
    @NgSinh DATE,
    @Diachi NVARCHAR(50),
    @Luong FLOAT,
    @Phg NVARCHAR(9)
AS
BEGIN
    DECLARE @Tuoi INT = DATEDIFF(YEAR, @NgSinh, GETDATE())
    DECLARE @MaQL NVARCHAR(9)

    IF @Luong < 25000
        SET @MaQL = '009'
    ELSE
        SET @MaQL = '005'

    IF @Phai = N'Nam' AND (@Tuoi < 18 OR @Tuoi > 65)
        PRINT N'Nhân viên nam không hợp lệ (tuổi 18–65)'
    ELSE IF @Phai = N'Nữ' AND (@Tuoi < 18 OR @Tuoi > 60)
        PRINT N'Nhân viên nữ không hợp lệ (tuổi 18–60)'
    ELSE
    BEGIN
        INSERT INTO NHANVIEN(MANV, HONV, TENLOT, TENNV, PHAI, NGSINH, DCHI, LUONG, MA_NQL, PHG)
        VALUES(@Manv, @Honv, @Tenlot, @Tennv, @Phai, @NgSinh, @Diachi, @Luong, @MaQL, @Phg)
        PRINT N'Thêm nhân viên thành công'
    END
END
GO

EXEC sp_ThemNhanVien 
    'NV999', N'Nguyễn', N'Văn', N'Hào', N'Nam', '1999-10-11',
    N'Hà Nội', 23000, '010'
GO