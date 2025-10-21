USE QLNHATRO_TranHuuHao;
GO

-- Y3.1 - THÊM THÔNG TIN VÀO CÁC BẢNG
-- ============= SP1: Thêm NGUOIDUNG =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThemNguoiDung' AND type = 'P')
    DROP PROCEDURE sp_ThemNguoiDung;
GO

CREATE PROCEDURE sp_ThemNguoiDung
    @TenNguoiDung NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @DienThoai VARCHAR(15),
    @SoNha NVARCHAR(50) = NULL,
    @TenDuong NVARCHAR(100) = NULL,
    @TenPhuong NVARCHAR(100) = NULL,
    @Quan NVARCHAR(100),
    @Email VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra các trường bắt buộc (NOT NULL)
    IF @TenNguoiDung IS NULL OR LTRIM(RTRIM(@TenNguoiDung)) = ''
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Tên người dùng!';
        RETURN;
    END
    
    IF @GioiTinh IS NULL OR LTRIM(RTRIM(@GioiTinh)) = ''
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Giới tính!';
        RETURN;
    END
    
    IF @DienThoai IS NULL OR LTRIM(RTRIM(@DienThoai)) = ''
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Số điện thoại!';
        RETURN;
    END
    
    IF @Quan IS NULL OR LTRIM(RTRIM(@Quan)) = ''
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Quận/Huyện!';
        RETURN;
    END
    
    -- Thực hiện chèn dữ liệu
    BEGIN TRY
        INSERT INTO NGUOIDUNG (TenNguoiDung, GioiTinh, DienThoai, SoNha, TenDuong, TenPhuong, Quan, Email)
        VALUES (@TenNguoiDung, @GioiTinh, @DienThoai, @SoNha, @TenDuong, @TenPhuong, @Quan, @Email);
        
        PRINT N'Thêm người dùng thành công! Mã người dùng: ' + CAST(SCOPE_IDENTITY() AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Lời gọi SP1 - Thành công
EXEC sp_ThemNguoiDung 
    @TenNguoiDung = N'Phan Văn Hòa',
    @GioiTinh = N'Nam',
    @DienThoai = '0945123789',
    @SoNha = N'15',
    @TenDuong = N'Hoàng Quốc Việt',
    @TenPhuong = N'Nghĩa Đô',
    @Quan = N'Cầu Giấy',
    @Email = 'hoapv@gmail.com';
GO

-- Lời gọi SP1 - Lỗi (thiếu tên)
EXEC sp_ThemNguoiDung 
    @TenNguoiDung = NULL,
    @GioiTinh = N'Nam',
    @DienThoai = '0945123789',
    @Quan = N'Cầu Giấy';
GO

-- ============= SP2: Thêm NHATRO =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThemNhaTro' AND type = 'P')
    DROP PROCEDURE sp_ThemNhaTro;
GO

CREATE PROCEDURE sp_ThemNhaTro
    @MaLoaiNha INT,
    @DienTich DECIMAL(6,2),
    @GiaPhong DECIMAL(12,0),
    @SoNha NVARCHAR(50) = NULL,
    @TenDuong NVARCHAR(100) = NULL,
    @TenPhuong NVARCHAR(100) = NULL,
    @Quan NVARCHAR(100),
    @MoTa NVARCHAR(MAX) = NULL,
    @MaNguoiLienHe INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra các trường bắt buộc
    IF @MaLoaiNha IS NULL
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Mã loại nhà!';
        RETURN;
    END
    
    IF @DienTich IS NULL OR @DienTich <= 0
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Diện tích hợp lệ (> 0)!';
        RETURN;
    END
    
    IF @GiaPhong IS NULL OR @GiaPhong < 0
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Giá phòng hợp lệ (>= 0)!';
        RETURN;
    END
    
    IF @Quan IS NULL OR LTRIM(RTRIM(@Quan)) = ''
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Quận/Huyện!';
        RETURN;
    END
    
    IF @MaNguoiLienHe IS NULL
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Mã người liên hệ!';
        RETURN;
    END
    
    -- Kiểm tra MaLoaiNha có tồn tại
    IF NOT EXISTS (SELECT 1 FROM LOAINHA WHERE MaLoaiNha = @MaLoaiNha)
    BEGIN
        PRINT N'Lỗi: Mã loại nhà không tồn tại!';
        RETURN;
    END
    
    -- Kiểm tra MaNguoiLienHe có tồn tại
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaNguoiDung = @MaNguoiLienHe)
    BEGIN
        PRINT N'Lỗi: Mã người liên hệ không tồn tại!';
        RETURN;
    END
    
    -- Thực hiện chèn dữ liệu
    BEGIN TRY
        INSERT INTO NHATRO (MaLoaiNha, DienTich, GiaPhong, SoNha, TenDuong, TenPhuong, Quan, MoTa, MaNguoiLienHe)
        VALUES (@MaLoaiNha, @DienTich, @GiaPhong, @SoNha, @TenDuong, @TenPhuong, @Quan, @MoTa, @MaNguoiLienHe);
        
        PRINT N'Thêm nhà trọ thành công! Mã nhà trọ: ' + CAST(SCOPE_IDENTITY() AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Lời gọi SP2 - Thành công
EXEC sp_ThemNhaTro
    @MaLoaiNha = 1,
    @DienTich = 35.0,
    @GiaPhong = 4500000,
    @SoNha = N'99',
    @TenDuong = N'Nguyễn Chí Thanh',
    @TenPhuong = N'Láng Hạ',
    @Quan = N'Đống Đa',
    @MoTa = N'Phòng mới xây, đầy đủ tiện nghi, gần ĐH Thương Mại',
    @MaNguoiLienHe = 1;
GO

-- Lời gọi SP2 - Lỗi (thiếu diện tích)
EXEC sp_ThemNhaTro
    @MaLoaiNha = 1,
    @DienTich = NULL,
    @GiaPhong = 4500000,
    @Quan = N'Đống Đa',
    @MaNguoiLienHe = 1;
GO

-- ============= SP3: Thêm DANHGIA =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThemDanhGia' AND type = 'P')
    DROP PROCEDURE sp_ThemDanhGia;
GO

CREATE PROCEDURE sp_ThemDanhGia
    @MaNguoiDanhGia INT,
    @MaNhaTro INT,
    @LoaiDanhGia NVARCHAR(10),
    @NoiDung NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra các trường bắt buộc
    IF @MaNguoiDanhGia IS NULL
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Mã người đánh giá!';
        RETURN;
    END
    
    IF @MaNhaTro IS NULL
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Mã nhà trọ!';
        RETURN;
    END
    
    IF @LoaiDanhGia IS NULL OR LTRIM(RTRIM(@LoaiDanhGia)) = ''
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập Loại đánh giá (LIKE/DISLIKE)!';
        RETURN;
    END
    
    -- Kiểm tra MaNguoiDanhGia có tồn tại
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaNguoiDung = @MaNguoiDanhGia)
    BEGIN
        PRINT N'Lỗi: Mã người đánh giá không tồn tại!';
        RETURN;
    END
    
    -- Kiểm tra MaNhaTro có tồn tại
    IF NOT EXISTS (SELECT 1 FROM NHATRO WHERE MaNhaTro = @MaNhaTro)
    BEGIN
        PRINT N'Lỗi: Mã nhà trọ không tồn tại!';
        RETURN;
    END
    
    -- Kiểm tra người dùng đã đánh giá nhà trọ này chưa
    IF EXISTS (SELECT 1 FROM DANHGIA WHERE MaNguoiDanhGia = @MaNguoiDanhGia AND MaNhaTro = @MaNhaTro)
    BEGIN
        PRINT N'Lỗi: Bạn đã đánh giá nhà trọ này rồi!';
        RETURN;
    END
    
    -- Thực hiện chèn dữ liệu
    BEGIN TRY
        INSERT INTO DANHGIA (MaNguoiDanhGia, MaNhaTro, LoaiDanhGia, NoiDung)
        VALUES (@MaNguoiDanhGia, @MaNhaTro, @LoaiDanhGia, @NoiDung);
        
        PRINT N'Thêm đánh giá thành công! Mã đánh giá: ' + CAST(SCOPE_IDENTITY() AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Lời gọi SP3 - Thành công
EXEC sp_ThemDanhGia
    @MaNguoiDanhGia = 5,
    @MaNhaTro = 12,
    @LoaiDanhGia = N'LIKE',
    @NoiDung = N'Phòng đẹp, giá hợp lý, chủ nhà thân thiện!';
GO

-- Lời gọi SP3 - Lỗi (thiếu mã nhà trọ)
EXEC sp_ThemDanhGia
    @MaNguoiDanhGia = 5,
    @MaNhaTro = NULL,
    @LoaiDanhGia = N'LIKE',
    @NoiDung = N'Phòng đẹp';
GO

-- =============================================
-- Y3.2 - TRUY VẤN THÔNG TIN
-- =============================================

-- ============= Y3.2a: SP Tìm kiếm nhà trọ =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_TimKiemNhaTro' AND type = 'P')
    DROP PROCEDURE sp_TimKiemNhaTro;
GO

CREATE PROCEDURE sp_TimKiemNhaTro
    @Quan NVARCHAR(100) = NULL,
    @DienTichMin DECIMAL(6,2) = NULL,
    @DienTichMax DECIMAL(6,2) = NULL,
    @NgayDangTinMin DATE = NULL,
    @NgayDangTinMax DATE = NULL,
    @GiaMin DECIMAL(12,0) = NULL,
    @GiaMax DECIMAL(12,0) = NULL,
    @MaLoaiNha INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        N'Cho thuê phòng trọ tại ' + 
        ISNULL(NT.SoNha + N', ', N'') + 
        ISNULL(NT.TenDuong + N', ', N'') + 
        ISNULL(NT.TenPhuong + N', ', N'') + 
        NT.Quan AS [Địa chỉ],
        
        FORMAT(NT.DienTich, 'N1', 'vi-VN') + N' m²' AS [Diện tích],
        
        FORMAT(NT.GiaPhong, 'N0', 'vi-VN') AS [Giá phòng],
        
        NT.MoTa AS [Mô tả],
        
        FORMAT(NT.NgayDangTin, 'dd-MM-yyyy') AS [Ngày đăng],
        
        CASE 
            WHEN ND.GioiTinh = N'Nam' THEN N'A. ' + ND.TenNguoiDung
            WHEN ND.GioiTinh = N'Nữ' THEN N'C. ' + ND.TenNguoiDung
            ELSE ND.TenNguoiDung
        END AS [Người liên hệ],
        
        ND.DienThoai AS [Điện thoại],
        
        ISNULL(ND.SoNha + N', ', N'') + 
        ISNULL(ND.TenDuong + N', ', N'') + 
        ISNULL(ND.TenPhuong + N', ', N'') + 
        ND.Quan AS [Địa chỉ liên hệ]
    FROM NHATRO NT
    INNER JOIN NGUOIDUNG ND ON NT.MaNguoiLienHe = ND.MaNguoiDung
    WHERE 
        (@Quan IS NULL OR NT.Quan = @Quan)
        AND (@DienTichMin IS NULL OR NT.DienTich >= @DienTichMin)
        AND (@DienTichMax IS NULL OR NT.DienTich <= @DienTichMax)
        AND (@NgayDangTinMin IS NULL OR NT.NgayDangTin >= @NgayDangTinMin)
        AND (@NgayDangTinMax IS NULL OR NT.NgayDangTin <= @NgayDangTinMax)
        AND (@GiaMin IS NULL OR NT.GiaPhong >= @GiaMin)
        AND (@GiaMax IS NULL OR NT.GiaPhong <= @GiaMax)
        AND (@MaLoaiNha IS NULL OR NT.MaLoaiNha = @MaLoaiNha)
    ORDER BY NT.NgayDangTin DESC;
END
GO

-- Lời gọi 1: Tìm nhà trọ ở Đống Đa, giá 3-5 triệu
EXEC sp_TimKiemNhaTro
    @Quan = N'Đống Đa',
    @GiaMin = 3000000,
    @GiaMax = 5000000;
GO

-- Lời gọi 2: Tìm căn hộ chung cư, diện tích 50-80m², đăng từ tháng 9/2024
EXEC sp_TimKiemNhaTro
    @MaLoaiNha = 2,
    @DienTichMin = 50,
    @DienTichMax = 80,
    @NgayDangTinMin = '2024-09-01';
GO

-- ============= Y3.2b: Function tìm mã người dùng =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'fn_TimMaNguoiDung' AND type IN ('FN', 'IF', 'TF'))
    DROP FUNCTION fn_TimMaNguoiDung;
GO

CREATE FUNCTION fn_TimMaNguoiDung
(
    @TenNguoiDung NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @DienThoai VARCHAR(15),
    @SoNha NVARCHAR(50),
    @TenDuong NVARCHAR(100),
    @TenPhuong NVARCHAR(100),
    @Quan NVARCHAR(100),
    @Email VARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @MaNguoiDung INT;
    
    SELECT @MaNguoiDung = MaNguoiDung
    FROM NGUOIDUNG
    WHERE 
        TenNguoiDung = @TenNguoiDung
        AND GioiTinh = @GioiTinh
        AND DienThoai = @DienThoai
        AND ISNULL(SoNha, '') = ISNULL(@SoNha, '')
        AND ISNULL(TenDuong, '') = ISNULL(@TenDuong, '')
        AND ISNULL(TenPhuong, '') = ISNULL(@TenPhuong, '')
        AND Quan = @Quan
        AND ISNULL(Email, '') = ISNULL(@Email, '');
    
    RETURN @MaNguoiDung;
END
GO

-- Test function
SELECT dbo.fn_TimMaNguoiDung(
    N'Nguyễn Văn Thắng', 
    N'Nam', 
    '0912345678', 
    N'123', 
    N'Đường Láng', 
    N'Láng Thượng', 
    N'Đống Đa', 
    'thangnv@gmail.com'
) AS MaNguoiDung;
GO

-- ============= Y3.2c: Function đếm LIKE/DISLIKE =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'fn_DemLikeDislike' AND type IN ('FN', 'IF', 'TF'))
    DROP FUNCTION fn_DemLikeDislike;
GO

CREATE FUNCTION fn_DemLikeDislike (@MaNhaTro INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @KetQua NVARCHAR(100);
    DECLARE @SoLike INT, @SoDislike INT;
    
    SELECT 
        @SoLike = COUNT(CASE WHEN LoaiDanhGia = N'LIKE' THEN 1 END),
        @SoDislike = COUNT(CASE WHEN LoaiDanhGia = N'DISLIKE' THEN 1 END)
    FROM DANHGIA
    WHERE MaNhaTro = @MaNhaTro;
    
    SET @KetQua = N'LIKE: ' + CAST(ISNULL(@SoLike, 0) AS NVARCHAR(10)) + 
                  N', DISLIKE: ' + CAST(ISNULL(@SoDislike, 0) AS NVARCHAR(10));
    
    RETURN @KetQua;
END
GO

-- Test function
SELECT 
    MaNhaTro,
    dbo.fn_DemLikeDislike(MaNhaTro) AS [Thống kê đánh giá]
FROM NHATRO
WHERE MaNhaTro IN (1, 2, 3);
GO

-- ============= Y3.2d: View TOP 10 nhà trọ có nhiều LIKE nhất =============
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_Top10NhaTroNhieuLike')
    DROP VIEW vw_Top10NhaTroNhieuLike;
GO

CREATE VIEW vw_Top10NhaTroNhieuLike
AS
SELECT TOP 10
    NT.DienTich,
    NT.GiaPhong AS Gia,
    NT.MoTa,
    NT.NgayDangTin,
    ND.TenNguoiDung AS TenNguoiLienHe,
    ISNULL(ND.SoNha + N', ', N'') + 
    ISNULL(ND.TenDuong + N', ', N'') + 
    ISNULL(ND.TenPhuong + N', ', N'') + 
    ND.Quan AS DiaChi,
    ND.DienThoai,
    ND.Email,
    COUNT(DG.MaDanhGia) AS SoLuotLike
FROM NHATRO NT
INNER JOIN NGUOIDUNG ND ON NT.MaNguoiLienHe = ND.MaNguoiDung
LEFT JOIN DANHGIA DG ON NT.MaNhaTro = DG.MaNhaTro AND DG.LoaiDanhGia = N'LIKE'
GROUP BY 
    NT.DienTich, NT.GiaPhong, NT.MoTa, NT.NgayDangTin,
    ND.TenNguoiDung, ND.SoNha, ND.TenDuong, ND.TenPhuong, 
    ND.Quan, ND.DienThoai, ND.Email
ORDER BY COUNT(DG.MaDanhGia) DESC;
GO

-- Test view
SELECT * FROM vw_Top10NhaTroNhieuLike;
GO

-- ============= Y3.2e: SP lấy danh sách đánh giá theo nhà trọ =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_DanhSachDanhGia' AND type = 'P')
    DROP PROCEDURE sp_DanhSachDanhGia;
GO

CREATE PROCEDURE sp_DanhSachDanhGia
    @MaNhaTro INT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM NHATRO WHERE MaNhaTro = @MaNhaTro)
    BEGIN
        PRINT N'Mã nhà trọ không tồn tại!';
        RETURN;
    END
    
    SELECT 
        DG.MaNhaTro AS [Mã nhà trọ],
        ND.TenNguoiDung AS [Tên người đánh giá],
        DG.LoaiDanhGia AS [Trạng thái],
        DG.NoiDung AS [Nội dung đánh giá],
        FORMAT(DG.NgayDanhGia, 'dd-MM-yyyy HH:mm') AS [Ngày đánh giá]
    FROM DANHGIA DG
    INNER JOIN NGUOIDUNG ND ON DG.MaNguoiDanhGia = ND.MaNguoiDung
    WHERE DG.MaNhaTro = @MaNhaTro
    ORDER BY DG.NgayDanhGia DESC;
END
GO

-- Test SP
EXEC sp_DanhSachDanhGia @MaNhaTro = 1;
GO

-- =============================================
-- Y3.3 - XÓA THÔNG TIN
-- =============================================

-- ============= Y3.3.1: SP xóa nhà trọ theo số DISLIKE =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_XoaNhaTroTheoDislike' AND type = 'P')
    DROP PROCEDURE sp_XoaNhaTroTheoDislike;
GO

CREATE PROCEDURE sp_XoaNhaTroTheoDislike
    @SoDislike INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Tìm các nhà trọ có số DISLIKE > @SoDislike
        DECLARE @DanhSachXoa TABLE (MaNhaTro INT);
        
        INSERT INTO @DanhSachXoa
        SELECT NT.MaNhaTro
        FROM NHATRO NT
        INNER JOIN DANHGIA DG ON NT.MaNhaTro = DG.MaNhaTro
        WHERE DG.LoaiDanhGia = N'DISLIKE'
        GROUP BY NT.MaNhaTro
        HAVING COUNT(DG.MaDanhGia) > @SoDislike;
        
        DECLARE @SoLuongXoa INT = (SELECT COUNT(*) FROM @DanhSachXoa);
        
        IF @SoLuongXoa = 0
        BEGIN
            PRINT N'Không có nhà trọ nào có số DISLIKE > ' + CAST(@SoDislike AS NVARCHAR(10));
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Xóa đánh giá trước (do có khóa ngoại)
        DELETE FROM DANHGIA
        WHERE MaNhaTro IN (SELECT MaNhaTro FROM @DanhSachXoa);
        
        -- Xóa nhà trọ
        DELETE FROM NHATRO
        WHERE MaNhaTro IN (SELECT MaNhaTro FROM @DanhSachXoa);
        
        COMMIT TRANSACTION;
        
        PRINT N'Đã xóa thành công ' + CAST(@SoLuongXoa AS NVARCHAR(10)) + N' nhà trọ và các đánh giá tương ứng.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Test SP (không xóa thật, chỉ xem kết quả)
-- EXEC sp_XoaNhaTroTheoDislike @SoDislike = 2;
PRINT N'-- Để test SP xóa theo DISLIKE, chạy: EXEC sp_XoaNhaTroTheoDislike @SoDislike = 2';
GO

-- Test SP (không xóa thật)
-- EXEC sp_XoaNhaTroTheoThoiGian @NgayBatDau = '2024-09-01', @NgayKetThuc = '2024-09-10';
PRINT N'-- Để test SP xóa theo thời gian, chạy: EXEC sp_XoaNhaTroTheoThoiGian @NgayBatDau = ''2024-09-01'', @NgayKetThuc = ''2024-09-10''';
GO

-- =============================================
-- TỔNG KẾT
-- =============================================
PRINT N'';
PRINT N'========================================';
PRINT N'HOÀN THÀNH Y3 - CÁC CHỨC NĂNG';
PRINT N'========================================';
PRINT N'';
PRINT N'Y3.1 - THÊM THÔNG TIN:';
PRINT N'  ✓ sp_ThemNguoiDung';
PRINT N'  ✓ sp_ThemNhaTro';
PRINT N'  ✓ sp_ThemDanhGia';
PRINT N'';
PRINT N'Y3.2 - TRUY VẤN THÔNG TIN:';
PRINT N'  ✓ sp_TimKiemNhaTro (Y3.2a)';
PRINT N'  ✓ fn_TimMaNguoiDung (Y3.2b)';
PRINT N'  ✓ fn_DemLikeDislike (Y3.2c)';
PRINT N'  ✓ vw_Top10NhaTroNhieuLike (Y3.2d)';
PRINT N'  ✓ sp_DanhSachDanhGia (Y3.2e)';
PRINT N'';
PRINT N'Y3.3 - XÓA THÔNG TIN:';
PRINT N'  ✓ sp_XoaNhaTroTheoDislike (Y3.3.1)';
PRINT N'  ✓ sp_XoaNhaTroTheoThoiGian (Y3.3.2)';
PRINT N'';
PRINT N'========================================';
PRINT N'Tất cả đã có Transaction để đảm bảo';
PRINT N'tính toàn vẹn dữ liệu!';
PRINT N'========================================';
GO

-- ============= Y3.3.2: SP xóa nhà trọ theo khoảng thời gian =============
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_XoaNhaTroTheoThoiGian' AND type = 'P')
    DROP PROCEDURE sp_XoaNhaTroTheoThoiGian;
GO

CREATE PROCEDURE sp_XoaNhaTroTheoThoiGian
    @NgayBatDau DATE,
    @NgayKetThuc DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @NgayBatDau IS NULL OR @NgayKetThuc IS NULL
    BEGIN
        PRINT N'Lỗi: Vui lòng nhập đầy đủ khoảng thời gian!';
        RETURN;
    END
    
    IF @NgayBatDau > @NgayKetThuc
    BEGIN
        PRINT N'Lỗi: Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc!';
        RETURN;
    END
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Tìm các nhà trọ trong khoảng thời gian
        DECLARE @DanhSachXoa TABLE (MaNhaTro INT);
        
        INSERT INTO @DanhSachXoa
        SELECT MaNhaTro
        FROM NHATRO
        WHERE NgayDangTin BETWEEN @NgayBatDau AND @NgayKetThuc;
        
        DECLARE @SoLuongXoa INT = (SELECT COUNT(*) FROM @DanhSachXoa);
        
        IF @SoLuongXoa = 0
        BEGIN
            PRINT N'Không có nhà trọ nào được đăng trong khoảng thời gian từ ' + 
                  FORMAT(@NgayBatDau, 'dd-MM-yyyy') + N' đến ' + FORMAT(@NgayKetThuc, 'dd-MM-yyyy');
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Xóa đánh giá trước
        DELETE FROM DANHGIA
        WHERE MaNhaTro IN (SELECT MaNhaTro FROM @DanhSachXoa);
        
        -- Xóa nhà trọ
        DELETE FROM NHATRO
        WHERE MaNhaTro IN (SELECT MaNhaTro FROM @DanhSachXoa);
        
        COMMIT TRANSACTION;
        
        PRINT N'Đã xóa thành công ' + CAST(@SoLuongXoa AS NVARCHAR(10)) + N' nhà trọ và các đánh giá tương ứng.';
        PRINT N'Khoảng thời gian: ' + FORMAT(@NgayBatDau, 'dd-MM-yyyy') + N' đến ' + FORMAT(@NgayKetThuc, 'dd-MM-yyyy');
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END
GO