-- =============================================
-- Script: Tạo CSDL Quản lý nhà trọ cho thuê
-- Yêu cầu: Y1 - Thiết kế và cài đặt CSDL
-- =============================================


USE master;
GO

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'QLNHATRO_<TenDangNhap>')
BEGIN
    ALTER DATABASE QLNHATRO_TranHuuHao SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QLNHATRO_TranHuuHao;
END
GO

-- Tạo database mới
CREATE DATABASE QLNHATRO_TranHuuHao;
GO

USE QLNHATRO_TranHuuHao;
GO

-- =============================================
-- Bảng LOAINHA: Lưu thông tin loại hình nhà trọ
-- =============================================
CREATE TABLE LOAINHA (
    MaLoaiNha INT IDENTITY(1,1) PRIMARY KEY,
    TenLoaiNha NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(500) NULL
);
GO

-- =============================================
-- Bảng NGUOIDUNG: Lưu thông tin người dùng
-- =============================================
CREATE TABLE NGUOIDUNG (
    MaNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    TenNguoiDung NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) NOT NULL CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác')),
    DienThoai VARCHAR(15) NOT NULL CHECK (DienThoai LIKE '[0-9]%'),
    SoNha NVARCHAR(50) NULL,
    TenDuong NVARCHAR(100) NULL,
    TenPhuong NVARCHAR(100) NULL,
    Quan NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NULL CHECK (Email LIKE '%_@__%.__%'),
    NgayDangKy DATE NOT NULL DEFAULT GETDATE(),
    TrangThai BIT NOT NULL DEFAULT 1 -- 1: Active, 0: Inactive
);
GO

-- =============================================
-- Bảng NHATRO: Lưu thông tin nhà trọ cho thuê
-- =============================================
CREATE TABLE NHATRO (
    MaNhaTro INT IDENTITY(1,1) PRIMARY KEY,
    MaLoaiNha INT NOT NULL,
    DienTich DECIMAL(6,2) NOT NULL CHECK (DienTich > 0),
    GiaPhong DECIMAL(12,0) NOT NULL CHECK (GiaPhong >= 0),
    SoNha NVARCHAR(50) NULL,
    TenDuong NVARCHAR(100) NULL,
    TenPhuong NVARCHAR(100) NULL,
    Quan NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(MAX) NULL,
    NgayDangTin DATE NOT NULL DEFAULT GETDATE(),
    MaNguoiLienHe INT NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Còn trống' 
        CHECK (TrangThai IN (N'Còn trống', N'Đã cho thuê', N'Ngưng đăng')),
    
    -- Ràng buộc khóa ngoại
    CONSTRAINT FK_NHATRO_LOAINHA FOREIGN KEY (MaLoaiNha) 
        REFERENCES LOAINHA(MaLoaiNha) ON DELETE CASCADE,
    CONSTRAINT FK_NHATRO_NGUOIDUNG FOREIGN KEY (MaNguoiLienHe) 
        REFERENCES NGUOIDUNG(MaNguoiDung)
);
GO

-- =============================================
-- Bảng DANHGIA: Lưu thông tin đánh giá
-- =============================================
CREATE TABLE DANHGIA (
    MaDanhGia INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDanhGia INT NOT NULL,
    MaNhaTro INT NOT NULL,
    LoaiDanhGia NVARCHAR(10) NOT NULL CHECK (LoaiDanhGia IN (N'LIKE', N'DISLIKE')),
    NoiDung NVARCHAR(MAX) NULL,
    NgayDanhGia DATETIME NOT NULL DEFAULT GETDATE(),
    
    -- Ràng buộc khóa ngoại
    CONSTRAINT FK_DANHGIA_NGUOIDUNG FOREIGN KEY (MaNguoiDanhGia) 
        REFERENCES NGUOIDUNG(MaNguoiDung),
    CONSTRAINT FK_DANHGIA_NHATRO FOREIGN KEY (MaNhaTro) 
        REFERENCES NHATRO(MaNhaTro) ON DELETE CASCADE,
    
    -- Ràng buộc một người chỉ đánh giá một nhà trọ một lần
    CONSTRAINT UQ_DANHGIA_NGUOI_NHATRO UNIQUE (MaNguoiDanhGia, MaNhaTro)
);
GO

-- =============================================
-- Tạo các Index để tối ưu truy vấn
-- =============================================
CREATE INDEX IX_NHATRO_Quan ON NHATRO(Quan);
CREATE INDEX IX_NHATRO_NgayDangTin ON NHATRO(NgayDangTin);
CREATE INDEX IX_NHATRO_GiaPhong ON NHATRO(GiaPhong);
CREATE INDEX IX_NHATRO_DienTich ON NHATRO(DienTich);
CREATE INDEX IX_DANHGIA_MaNhaTro ON DANHGIA(MaNhaTro);
CREATE INDEX IX_DANHGIA_LoaiDanhGia ON DANHGIA(LoaiDanhGia);
GO