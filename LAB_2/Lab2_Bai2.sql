--I. Chương trình tính diện tích--
--1. Biến vô hướng
declare @Chieudai FLOAT
declare @Chieurong FLOAT

set @Chieudai = 7
set @Chieurong = 5

print 'Chu vi: ' + cast((@Chieudai + @Chieurong)*2 as nvarchar)
print 'Dien tich: ' + cast(@Chieudai * @Chieurong as nvarchar)

--2. Biến table
declare @TinhHCN table (
	Dai float,
	Rong float,
	ChuVi as ((Dai+Rong)*2),
	DienTich as (Dai*Rong));

insert into @TinhHCN values (7,5), (8,3);
select * from @TinhHCN;

use QLDA
--II. Truy vấn từ QLDA
--1. Cho biêt nhân viên có lương cao nhất
	--Truy vấn thường
	select HONV, TENLOT, TENNV, MANV, LUONG from NHANVIEN
	where LUONG = (select MAX(LUONG) from NHANVIEN);
	--Truy vấn bảng
	declare @NVLuongMax table (
    MANV   char(9),
    HONV   nvarchar(15),
    TENLOT nvarchar(15),
    TENNV  nvarchar(15),
    LUONG  float
	);
	insert into @NVLuongMax select MANV, HONV, TENLOT, TENNV, LUONG from NHANVIEN where LUONG = (select MAX(LUONG) from NHANVIEN);
	select * from @NVLuongMax

--2. Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng "Nghiên cứu”
	use QLDA
	select HONV, TENLOT, TENNV from NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
	where LUONG > (select AVG(LUONG) from NHANVIEN) and PHONGBAN.TENPHG =  N'Nghiên cứu';

--3. Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.
	select P.TENPHG, COUNT(N.MANV) as SoNV from PHONGBAN P inner join NHANVIEN N on P.MAPHG = N.PHG group by P.TENPHG having avg(N.LUONG) > 30000;

--4. Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà phòng ban đó chủ trì
	select P.TENPHG, count(D.MADA) as SoDeAn from PHONGBAN P inner join DEAN D on P.MAPHG = D.PHONG group by P.TENPHG;

