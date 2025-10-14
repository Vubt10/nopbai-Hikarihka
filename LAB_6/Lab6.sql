USE QLDA
GO
--Bài 1: Viết trigger DML
-- Trigger kiểm tra khi thêm nhân viên
CREATE TRIGGER trg_Insert_NhanVien
ON NhanVien
FOR INSERT
AS
BEGIN
    DECLARE @Luong INT, @Tuoi INT
    SELECT @Luong = LUONG,
           @Tuoi = DATEDIFF(YEAR, NGSINH, GETDATE())
    FROM INSERTED

    IF @Luong <= 15000
    BEGIN
        RAISERROR (N'Luong phải > 15000', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF @Tuoi < 18 OR @Tuoi > 65
    BEGIN
        RAISERROR (N'Độ tuổi phải trong khoảng 18–65', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO

-- Trigger không cho phép cập nhật nhân viên ở TP.HCM
CREATE TRIGGER trg_Update_NhanVien_TPHCM
ON NhanVien
FOR UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT * FROM INSERTED i
        JOIN DELETED d ON i.MANV = d.MANV
        WHERE d.DCHI LIKE N'%TP HCM%' OR d.DCHI LIKE N'%TP.HCM%'
    )
    BEGIN
        RAISERROR (N'Không được cập nhật nhân viên ở TP.HCM', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO


--Bài 2:Trigger AFTER
-- Sau khi thêm nhân viên -> hiển thị tổng số nam/nữ
CREATE TRIGGER trg_AfterInsert_NhanVien
ON NhanVien
AFTER INSERT
AS
BEGIN
    DECLARE @SoNam INT, @SoNu INT
    SELECT @SoNam = COUNT(*) FROM NhanVien WHERE PHAI = N'Nam'
    SELECT @SoNu = COUNT(*) FROM NhanVien WHERE PHAI = N'Nữ'

    PRINT N'Tổng số nhân viên Nam: ' + CAST(@SoNam AS NVARCHAR(10))
    PRINT N'Tổng số nhân viên Nữ: ' + CAST(@SoNu AS NVARCHAR(10))
END
GO

-- Sau khi cập nhật giới tính -> hiển thị tổng số nam/nữ
CREATE TRIGGER trg_AfterUpdate_Phai
ON NhanVien
AFTER UPDATE
AS
BEGIN
    IF UPDATE(PHAI)
    BEGIN
        DECLARE @SoNam INT, @SoNu INT
        SELECT @SoNam = COUNT(*) FROM NhanVien WHERE PHAI = N'Nam'
        SELECT @SoNu = COUNT(*) FROM NhanVien WHERE PHAI = N'Nữ'

        PRINT N'Cập nhật giới tính xong!'
        PRINT N'Tổng số nhân viên Nam: ' + CAST(@SoNam AS NVARCHAR(10))
        PRINT N'Tổng số nhân viên Nữ: ' + CAST(@SoNu AS NVARCHAR(10))
    END
END
GO

-- Sau khi xóa trên bảng DEAN -> hiển thị tổng số đề án mỗi nhân viên
CREATE TRIGGER trg_AfterDelete_DeAn
ON DEAN
AFTER DELETE
AS
BEGIN
    PRINT N'Tổng số đề án mỗi nhân viên sau khi xóa:'
    SELECT nv.MANV, nv.TENNV, COUNT(p.MADA) AS TongDeAn
    FROM NhanVien nv
    LEFT JOIN PHANCONG p ON nv.MANV = p.MA_NVIEN
    GROUP BY nv.MANV, nv.TENNV
END
GO

--Bài 3: Trigger INSTEAD OF
-- Xóa nhân viên -> đồng thời xóa thân nhân liên quan
CREATE TRIGGER trg_InsteadOfDelete_NhanVien
ON NhanVien
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Thannhan
    WHERE MA_NVIEN IN (SELECT MANV FROM DELETED)

    DELETE FROM NhanVien
    WHERE MANV IN (SELECT MANV FROM DELETED)
END
GO

-- Khi thêm nhân viên mới -> tự động phân công vào đề án MADA = 1
CREATE OR ALTER TRIGGER trg_InsteadOfInsert_NhanVien
ON NhanVien
INSTEAD OF INSERT
AS
BEGIN
    -- Thêm nhân viên mới đầy đủ các cột cần thiết
    INSERT INTO NhanVien (HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
    SELECT 
        HONV, TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG
    FROM INSERTED

    -- Tự động phân công đề án MADA = 1
    INSERT INTO PHANCONG (MA_NVIEN, MADA,STT, THOIGIAN)
    SELECT MANV, 1, 10,3
    FROM INSERTED
END
GO

INSERT INTO CONGVIEC (MADA, STT, TEN_CONG_VIEC)
VALUES (1, 3, N'Công việc mặc định cho đề án 1');

INSERT INTO NhanVien (HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
VALUES (N'Nguyễn', N'Văn', N'Hào', 'NV99', '1995-01-01', N'Hà Nội', N'Nam', 20000, NULL, 1);
