-- =============================================
-- Script: Nhập dữ liệu mẫu cho CSDL Quản lý nhà trọ
-- Yêu cầu: Y2 - Nhập liệu cho các bảng
-- =============================================

USE QLNHATRO_TranHuuHao;
GO

-- =============================================
-- Bảng LOAINHA: Tối thiểu 3 bản ghi
-- =============================================
INSERT INTO LOAINHA (TenLoaiNha, MoTa) VALUES
(N'Phòng trọ khép kín', N'Phòng riêng biệt, có khóa riêng, toilet riêng'),
(N'Căn hộ chung cư', N'Căn hộ trong chung cư cao tầng, đầy đủ tiện nghi'),
(N'Nhà riêng', N'Nhà nguyên căn, nhiều phòng, có sân vườn'),
(N'Chung cư mini', N'Nhà nhiều tầng, mỗi tầng có nhiều phòng, thang máy'),
(N'Homestay', N'Phòng trong nhà chủ, chia sẻ không gian chung');
GO

-- =============================================
-- Bảng NGUOIDUNG: Tối thiểu 10 bản ghi
-- =============================================
INSERT INTO NGUOIDUNG (TenNguoiDung, GioiTinh, DienThoai, SoNha, TenDuong, TenPhuong, Quan, Email, NgayDangKy, TrangThai) VALUES
(N'Nguyễn Văn Thắng', N'Nam', '0912345678', N'123', N'Đường Láng', N'Láng Thượng', N'Đống Đa', 'thangnv@gmail.com', '2024-01-15', 1),
(N'Trần Thị Lan', N'Nữ', '0987654321', N'45', N'Giải Phóng', N'Bách Khoa', N'Hai Bà Trưng', 'lantt@gmail.com', '2024-02-20', 1),
(N'Lê Minh Tuấn', N'Nam', '0909123456', N'78', N'Cầu Giấy', N'Dịch Vọng', N'Cầu Giấy', 'tuanlm@gmail.com', '2024-03-10', 1),
(N'Phạm Thị Hương', N'Nữ', '0938765432', N'12', N'Nguyễn Trãi', N'Thanh Xuân Bắc', N'Thanh Xuân', 'huongpt@gmail.com', '2024-01-25', 1),
(N'Hoàng Văn Nam', N'Nam', '0918234567', N'56', N'Tôn Đức Thắng', N'Hàng Bột', N'Đống Đa', 'namhv@gmail.com', '2024-02-15', 1),
(N'Đỗ Thị Mai', N'Nữ', '0976543210', N'89', N'Xã Đàn', N'Phương Liên', N'Đống Đa', 'maidt@gmail.com', '2024-03-05', 1),
(N'Bùi Quang Huy', N'Nam', '0945678901', N'234', N'Kim Mã', N'Kim Mã', N'Ba Đình', 'huybq@gmail.com', '2024-01-30', 1),
(N'Vũ Thị Nga', N'Nữ', '0923456789', N'67', N'Trường Chinh', N'Khương Mai', N'Thanh Xuân', 'ngavt@gmail.com', '2024-02-28', 1),
(N'Đinh Văn Dũng', N'Nam', '0967890123', N'101', N'Láng Hạ', N'Thành Công', N'Ba Đình', 'dungdv@gmail.com', '2024-03-15', 1),
(N'Ngô Thị Linh', N'Nữ', '0934567890', N'45A', N'Nguyễn Khang', N'Yên Hòa', N'Cầu Giấy', 'linhnt@gmail.com', '2024-01-20', 1),
(N'Trương Minh Quân', N'Nam', '0956789012', N'78B', N'Phạm Văn Đồng', N'Cổ Nhuế', N'Bắc Từ Liêm', 'quantm@gmail.com', '2024-02-10', 1),
(N'Lý Thị Thu', N'Nữ', '0912378945', N'22', N'Tây Sơn', N'Quang Trung', N'Đống Đa', 'thult@gmail.com', '2024-03-20', 1);
GO

-- =============================================
-- Bảng NHATRO: Tối thiểu 10 bản ghi
-- =============================================
INSERT INTO NHATRO (MaLoaiNha, DienTich, GiaPhong, SoNha, TenDuong, TenPhuong, Quan, MoTa, NgayDangTin, MaNguoiLienHe, TrangThai) VALUES
-- Phòng trọ Đống Đa
(1, 25.5, 3500000, N'123A', N'Đường Láng', N'Láng Thượng', N'Đống Đa', 
 N'Phòng khép kín, có gác, WC riêng, giường tủ, máy nước nóng. Gần trường ĐH Thương Mại, siêu thị, chợ.', 
 '2024-09-15', 1, N'Còn trống'),

(1, 30.0, 4000000, N'56', N'Tôn Đức Thắng', N'Hàng Bột', N'Đống Đa', 
 N'Phòng rộng rãi, thoáng mát, full nội thất, có ban công. Giờ giấc tự do, an ninh tốt.', 
 '2024-09-20', 5, N'Còn trống'),

-- Chung cư Cầu Giấy
(2, 65.0, 8000000, N'78', N'Cầu Giấy', N'Dịch Vọng', N'Cầu Giấy', 
 N'Căn hộ 2 phòng ngủ, đầy đủ nội thất, view đẹp. Có thang máy, bảo vệ 24/7, bãi xe rộng.', 
 '2024-09-10', 3, N'Còn trống'),

(2, 55.5, 7500000, N'45A', N'Nguyễn Khang', N'Yên Hòa', N'Cầu Giấy', 
 N'Chung cư cao cấp, 2PN, nội thất gỗ, máy lạnh đầy đủ. Gần BigC, trường học.', 
 '2024-08-25', 10, N'Còn trống'),

-- Nhà riêng Ba Đình
(3, 120.0, 15000000, N'234', N'Kim Mã', N'Kim Mã', N'Ba Đình', 
 N'Nhà 3 tầng, 4 phòng ngủ, có sân để xe, khu vực yên tĩnh, an ninh tốt.', 
 '2024-09-05', 7, N'Còn trống'),

-- Phòng trọ Thanh Xuân
(1, 28.0, 3800000, N'12', N'Nguyễn Trãi', N'Thanh Xuân Bắc', N'Thanh Xuân', 
 N'Phòng mới xây, sạch sẽ, có WC riêng, giường tủ, máy lạnh. Gần bến xe, siêu thị.', 
 '2024-09-18', 4, N'Còn trống'),

(4, 22.0, 3000000, N'67', N'Trường Chinh', N'Khương Mai', N'Thanh Xuân', 
 N'Chung cư mini, phòng khép kín, có thang máy, bảo vệ. Điện nước giá dân.', 
 '2024-09-22', 8, N'Còn trống'),

-- Phòng trọ Hai Bà Trưng
(1, 27.5, 3600000, N'45', N'Giải Phóng', N'Bách Khoa', N'Hai Bà Trưng', 
 N'Phòng gần ĐH Bách Khoa, đầy đủ tiện nghi, chủ nhà thân thiện. Giờ giấc tự do.', 
 '2024-09-12', 2, N'Còn trống'),

-- Homestay Bắc Từ Liêm
(5, 20.0, 2500000, N'78B', N'Phạm Văn Đồng', N'Cổ Nhuế', N'Bắc Từ Liêm', 
 N'Phòng trong nhà chủ, có ban công, được dùng bếp chung. Môi trường gia đình ấm cúng.', 
 '2024-08-30', 11, N'Còn trống'),

-- Phòng trọ Đống Đa
(1, 32.0, 4200000, N'89', N'Xã Đàn', N'Phương Liên', N'Đống Đa', 
 N'Phòng có gác cao, WC khép kín, nóng lạnh, tủ lạnh, máy giặt. Gần Big C Thăng Long.', 
 '2024-09-08', 6, N'Còn trống'),

-- Căn hộ Ba Đình
(2, 75.0, 10000000, N'101', N'Láng Hạ', N'Thành Công', N'Ba Đình', 
 N'Căn hộ 2PN+2WC, nội thất cao cấp, view hồ. Có chỗ đỗ ô tô.', 
 '2024-09-01', 9, N'Còn trống'),

-- Phòng trọ Đống Đa (thêm để test)
(1, 26.0, 3300000, N'22', N'Tây Sơn', N'Quang Trung', N'Đống Đa', 
 N'Phòng mới, sạch sẽ, an ninh tốt. Gần ĐH Y, ĐH Mỏ Địa chất. Free wifi.', 
 '2024-09-25', 12, N'Còn trống');
GO

-- =============================================
-- Bảng DANHGIA: Tối thiểu 10 bản ghi
-- =============================================
INSERT INTO DANHGIA (MaNguoiDanhGia, MaNhaTro, LoaiDanhGia, NoiDung, NgayDanhGia) VALUES
-- Đánh giá cho nhà trọ 1
(2, 1, N'LIKE', N'Phòng rất đẹp, chủ nhà thân thiện, giá cả hợp lý. Rất hài lòng!', '2024-09-16 10:30:00'),
(3, 1, N'LIKE', N'Vị trí thuận tiện, gần trường, gần chợ. Phòng sạch sẽ.', '2024-09-17 14:20:00'),
(4, 1, N'DISLIKE', N'Phòng hơi nhỏ so với giá tiền, không có ban công.', '2024-09-18 09:15:00'),

-- Đánh giá cho nhà trọ 2
(1, 2, N'LIKE', N'Phòng thoáng mát, chủ nhà dễ tính. Giờ giấc tự do rất phù hợp.', '2024-09-21 16:45:00'),
(6, 2, N'LIKE', N'An ninh tốt, có camera, khu vực yên tĩnh.', '2024-09-22 11:30:00'),

-- Đánh giá cho nhà trọ 3
(5, 3, N'LIKE', N'Căn hộ đẹp, view tốt, có thang máy rất tiện. Đáng đồng tiền.', '2024-09-11 08:20:00'),
(2, 3, N'LIKE', N'Nội thất đầy đủ, không phải mua gì thêm. Chung cư cao cấp.', '2024-09-12 15:10:00'),
(8, 3, N'LIKE', N'Bãi xe rộng, bảo vệ 24/7. Rất an toàn.', '2024-09-13 19:30:00'),

-- Đánh giá cho nhà trọ 4
(3, 4, N'LIKE', N'Chung cư mới, sạch sẽ, gần siêu thị rất tiện lợi.', '2024-08-26 10:00:00'),
(7, 4, N'DISLIKE', N'Giá hơi cao so với diện tích, nhưng vị trí tốt.', '2024-08-27 13:45:00'),

-- Đánh giá cho nhà trọ 5
(1, 5, N'LIKE', N'Nhà rộng rãi, phù hợp cho gia đình. Khu vực yên tĩnh.', '2024-09-06 11:20:00'),
(4, 5, N'LIKE', N'Có sân để xe rộng, an ninh tốt. Giá hợp lý.', '2024-09-07 16:30:00'),

-- Đánh giá cho nhà trọ 6
(5, 6, N'LIKE', N'Phòng mới, sạch, gần bến xe rất tiện đi lại.', '2024-09-19 09:40:00'),
(9, 6, N'LIKE', N'Có máy lạnh, nội thất đầy đủ. Giá phải chăng.', '2024-09-20 14:15:00'),

-- Đánh giá cho nhà trọ 7
(6, 7, N'LIKE', N'Chung cư mini tiện nghi, có thang máy. Điện nước giá tốt.', '2024-09-23 08:50:00'),
(10, 7, N'DISLIKE', N'Phòng hơi nhỏ, không có cửa sổ lớn.', '2024-09-24 12:30:00'),

-- Đánh giá cho nhà trọ 8
(7, 8, N'LIKE', N'Gần trường Bách Khoa, rất tiện cho sinh viên. Chủ tốt.', '2024-09-13 10:20:00'),
(11, 8, N'LIKE', N'Giờ giấc tự do, môi trường thân thiện.', '2024-09-14 15:45:00'),

-- Đánh giá cho nhà trọ 9
(8, 9, N'LIKE', N'Homestay ấm cúng, chủ nhà như người thân. Giá rẻ.', '2024-09-01 09:30:00'),
(12, 9, N'DISLIKE', N'Phải chia sẻ không gian chung, không riêng tư lắm.', '2024-09-02 11:00:00'),

-- Đánh giá cho nhà trọ 10
(9, 10, N'LIKE', N'Phòng có gác rộng, tủ lạnh máy giặt đầy đủ. Tuyệt vời!', '2024-09-09 14:20:00'),
(3, 10, N'LIKE', N'Gần siêu thị BigC, mua sắm rất tiện. Recommend!', '2024-09-10 16:40:00'),

-- Đánh giá cho nhà trọ 11
(10, 11, N'LIKE', N'Căn hộ cao cấp, view hồ đẹp. Có chỗ đỗ xe ô tô.', '2024-09-02 10:15:00'),
(4, 11, N'DISLIKE', N'Giá hơi cao, nhưng chất lượng xứng đáng.', '2024-09-03 13:30:00'),

-- Đánh giá cho nhà trọ 12
(11, 12, N'LIKE', N'Phòng mới, wifi nhanh, gần nhiều trường ĐH. Tốt cho SV.', '2024-09-26 09:00:00'),
(12, 12, N'LIKE', N'An ninh tốt, chủ nhà nhiệt tình. Giá hợp lý.', '2024-09-27 11:45:00');
