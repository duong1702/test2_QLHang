--- CAU 1----
CREATE DATABASE QLHANG
GO
USE QLHANG
GO

CREATE TABLE VatTu(
    MaVT varchar(10) PRIMARY KEY not null, 
    TenVT nvarchar(50) not null,
    DVTinh nvarchar(50) not null,
    SLCon INT
);

CREATE TABLE HDBan(
    MaHD varchar(10) PRIMARY KEY not null, 
    NgayXuat DATE not null,
    HoTenKhach nvarchar(50)
);

CREATE TABLE HangXuat(
    MaHD varchar(10) not null,
    MaVT varchar(10)not null,
    DonGia INT not null,
    SLBan INT not null,
    CONSTRAINT PK_HangXuat PRIMARY KEY (MaHD, MaVT)
);

ALTER TABLE HangXuat ADD CONSTRAINT FK_HANGXUAT_HDBAN
FOREIGN KEY (MaHD) REFERENCES HDBan (MaHD);

ALTER TABLE HangXuat ADD CONSTRAINT FK_HANGXUAT_VATTU
FOREIGN KEY (MaVT) REFERENCES VatTu (MaVT);

INSERT INTO VatTu VALUES
('MVT1', N'Gạch', N'Viên', 700000),
('MVT2', N'Ximang', N'Bao', 9000);

INSERT INTO HDBan VALUES
('HD1', '2022-09-10', N'Lê Vân Anh'),
('HD2', '2022-05-11', N'Nguyễn Văn B');

INSERT INTO HangXuat VALUES
('HD1', 'MVT1', 1000, 500),
('HD1', 'MVT2', 23000, 50),
('HD2', 'MVT1', 7200, 300),
('HD2', 'MVT2', 45000, 100);


-- CAU 2-------
SELECT TOP 1
MaHD, SUM(SLBan * DonGia) AS N'Tổng Tiền'
FROM HangXuat
GROUP BY MaHD
ORDER BY SUM(SLBan * DonGia) Desc;
GO

-- CAU 3
GO
CREATE FUNCTION Fn_ThongTin (
    @MaHD varchar(10)
)
RETURNS TABLE
AS
RETURN
    SELECT 
        HX.MaHD,
        HD.NgayXuat,
        HX.MaVT,
        HX.DonGia,
        HX.SLBan,  
        CASE
            WHEN DATENAME(dw,HD.NgayXuat) = 'Monday' THEN N'Thứ hai'            
            WHEN DATENAME(dw,HD.NgayXuat) = 'Tuesday' THEN N'Thứ ba'
            WHEN DATENAME(dw,HD.NgayXuat) = 'Wednesday' THEN N'Thứ tư'
            WHEN DATENAME(dw,HD.NgayXuat) = 'Thursday' THEN N'Thứ năm'
            WHEN DATENAME(dw,HD.NgayXuat) = 'Friday' THEN N'Thứ sáu'
            WHEN DATENAME(dw,HD.NgayXuat) = 'Saturday' THEN N'Thứ bảy'
            ELSE N'Chủ nhật'	
        END AS NGAYTHU
    FROM HangXuat HX
    INNER JOIN HDBan HD ON HX.MaHD = HD.MaHD
    WHERE HX.MaHD = @MaHD;
GO
select * from Fn_ThongTin ('HD1')

-- CAU 4
Go
CREATE PROCEDURE sp_TongTienVT
@thang int, @nam int 
AS
SELECT 
SUM(SLBan * DonGia)
FROM HangXuat HX
INNER JOIN HDBan HD ON HX.MaHD = HD.MaHD
where MONTH(HD.NgayXuat) = @thang AND YEAR(HD.NgayXuat) = @nam;


