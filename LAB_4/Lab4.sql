
--Bài 1
use QLDA;
go
-- 1. kiểm tra tăng lương
select N.TENNV,
       case 
            when N.LUONG < (select avg(LUONG) 
                            from NHANVIEN 
                            where PHG = N.PHG) then N'TangLuong'
            else N'KhongTangLuong'
       end as XetTangLuong
from NHANVIEN N;

-- 2. phân loại nhân viên
select N.TENNV,
       case 
            when N.LUONG < (select avg(LUONG) 
                            from NHANVIEN 
                            where PHG = N.PHG) then N'nhanvien'
            else N'truongphong'
       end as XepLoai
from NHANVIEN N;

-- 3. hiển thị TenNV theo phái
select TENNV,
       case PHAI
            when N'Nam' then N'Mr. ' + TENNV
            when N'Nữ' then N'Mrs. ' + TENNV
            else N'... ' + TENNV
       end as HienThi
from NHANVIEN;

-- 4. tính thuế thu nhập
select TENNV, LUONG,
       case 
            when LUONG < 25000 then LUONG * 0.1
            when LUONG < 30000 then LUONG * 0.12
            when LUONG < 40000 then LUONG * 0.15
            when LUONG < 50000 then LUONG * 0.20
            else LUONG * 0.25
       end as Thue
from NHANVIEN;

--Bài 2
use QLDA;
go

-- 1. nhân viên có MaNV số chẵn
declare @MaNV int = 1;
while @MaNV <= (select max(MANV) from NHANVIEN)
begin
    if (@MaNV % 2 = 0)
        select HONV, TENLOT, TENNV
        from NHANVIEN
        where MANV = @MaNV;
    set @MaNV = @MaNV + 1;
end;

-- 2. nhân viên có MaNV số chẵn nhưng loại trừ MaNV = 4
declare @MaNV2 int = 1;
while @MaNV2 <= (select max(MANV) from NHANVIEN)
begin
    if (@MaNV2 % 2 = 0 and @MaNV2 <> 4)
        select HONV, TENLOT, TENNV
        from NHANVIEN
        where MANV = @MaNV2;
    set @MaNV2 = @MaNV2 + 1;
end;

--Bài 3
use QLDA;
go
-- 1. thử - bắt lỗi khi chèn dữ liệu
begin try
    insert into PHONGBAN(MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
    values ('9', N'Phong Moi', null, getdate());
    print N'them du lieu thanh cong';
end try
begin catch
    print N'them du lieu that bai';
end catch;

-- 2. chia cho 0
declare @chia int = 100, @mau int = 0;
begin try
    declare @ketqua int = @chia / @mau;
end try
begin catch
    raiserror(N'Loi chia cho 0', 16, 1);
end catch;
