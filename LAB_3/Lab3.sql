-- BÀI 1: Sử dụng hàm chuyển đổi kiểu dữ liệu (2 điểm)
-- 1.2 Với mỗi đề án: tên đề án + tổng số giờ (decimal 2 số thập phân, và varchar)
SELECT DA.TENDEAN, 
       CAST(SUM(PC.THOIGIAN) AS decimal(10,2)) AS TongGio_DECIMAL,
       CAST(SUM(PC.THOIGIAN) AS varchar(20)) AS TongGio_VARCHAR
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

SELECT DA.TENDEAN, 
       CONVERT(decimal(10,2), SUM(PC.THOIGIAN)) AS TongGio_DECIMAL,
       CONVERT(varchar(20), SUM(PC.THOIGIAN)) AS TongGio_VARCHAR
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

-- 1.3 Với mỗi phòng ban: tên phòng ban + lương TB
-- Xuất decimal (2 số thập phân, dùng dấu phẩy phân cách thập phân)
SELECT PB.TENPHG,
       REPLACE(CAST(CAST(AVG(NV.LUONG) AS DECIMAL(10,2)) AS VARCHAR(20)), '.', ',') AS LuongTB_DECIMAL
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

SELECT PB.TENPHG,
       REPLACE(CONVERT(varchar(20), CONVERT(decimal(10,2), AVG(NV.LUONG))), '.', ',') AS LuongTB_DECIMAL
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

-- Xuất varchar, có dấu phẩy tách mỗi 3 số
SELECT PB.TENPHG,
       REPLACE(CAST(CAST(AVG(NV.LUONG) AS money) AS varchar(20)), '.00','') AS LuongTB_VARCHAR
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

SELECT PB.TENPHG,
       REPLACE(CONVERT(varchar, CAST(AVG(NV.LUONG) AS money), 1), '.00','') AS LuongTB_VARCHAR
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

-- BÀI 2: HÀM TOÁN HỌC (2 điểm)
-- 2.1 Với mỗi đề án: tổng số giờ với CEILING, FLOOR, ROUND
SELECT DA.TENDEAN,
       CEILING(SUM(PC.THOIGIAN)) AS TongGio_CEILING,
       FLOOR(SUM(PC.THOIGIAN)) AS TongGio_FLOOR,
       ROUND(SUM(PC.THOIGIAN),2) AS TongGio_ROUND
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;
-- 2.2 Nhân viên có lương > lương TB phòng "Nghiên cứu"
SELECT NV.HONV, NV.TENLOT, NV.TENNV, NV.LUONG
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
WHERE NV.LUONG > (
      SELECT ROUND(AVG(NV2.LUONG),2)
      FROM NHANVIEN NV2
      JOIN PHONGBAN PB2 ON NV2.PHG = PB2.MAPHG
      WHERE PB2.TENPHG = N'Nghiên cứu'
);

-- BÀI 3: Sử dụng các hàm xử lý chuỗ (2 điểm)
-- Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân, thỏa các yêu cầu
    -- 3.1 Nhân viên có > 2 thân nhân
SELECT 
    UPPER(NV.HONV) AS HoNV,
    LOWER(NV.TENLOT) AS TenLot,
    STUFF(LOWER(NV.TENNV),2,1,UPPER(SUBSTRING(NV.TENNV,2,1))) AS TenNV,
    SUBSTRING(NV.DCHI,CHARINDEX(' ', NV.DCHI)+1,CHARINDEX(',', NV.DCHI) - CHARINDEX(' ', NV.DCHI) - 1)  AS TenDuong
FROM NHANVIEN NV
JOIN THANNHAN TN ON NV.MANV = TN.MA_NVIEN
GROUP BY NV.HONV, NV.TENLOT, NV.TENNV, NV.DCHI, NV.MANV
HAVING COUNT(TN.TENTN) > 2; 

-- Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất, hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly”
-- 3.2 Phòng ban đông nhân viên nhất
SELECT TOP 1 PB.TENPHG,
       NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS TruongPhong,
       'Fpoly' AS ReplaceName
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.TRPHG = NV.MANV
ORDER BY (SELECT COUNT(*) FROM NHANVIEN NV2 WHERE NV2.PHG = PB.MAPHG) DESC;

--Bài 4
-- 4.1 Nhân viên sinh 1960–1965
SELECT *
FROM NHANVIEN
WHERE YEAR(NGSINH) BETWEEN 1960 AND 1965;

-- 4.2 Tuổi nhân viên đến hiện tại
SELECT MANV, HONV, TENLOT, TENNV,
       DATEDIFF(YEAR, NGSINH, GETDATE()) AS Tuoi
FROM NHANVIEN;

-- 4.3 Sinh vào thứ mấy
SELECT MANV, HONV, TENLOT, TENNV,
       DATENAME(WEEKDAY, NGSINH) AS ThuSinh
FROM NHANVIEN;

-- 4.4 Số lượng NV, tên trưởng phòng, ngày nhận chức (dd-mm-yy)
SELECT PB.TENPHG,
       COUNT(NV.MANV) AS SoNhanVien,
       TP.HONV + ' ' + TP.TENLOT + ' ' + TP.TENNV AS TruongPhong,
       CONVERT(varchar, PB.NG_NHANCHUC, 5) AS NgayNhanChuc_ddmmyy
FROM PHONGBAN PB
JOIN NHANVIEN TP ON PB.TRPHG = TP.MANV
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG, TP.HONV, TP.TENLOT, TP.TENNV, PB.NG_NHANCHUC;