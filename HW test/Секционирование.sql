/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/

use DWH2021;



--создадим файловую группу
ALTER DATABASE [DWH2021] ADD FILEGROUP [MonthData] --[YearData]
GO

--добавляем файл БД
ALTER DATABASE [DWH2021] ADD FILE 
( NAME = N'Years', FILENAME = N'E:\SQL_Developer\DataBase\MonthData.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [MonthData]
GO

--создаем функцию партиционирования по годам - по умолчанию left!!
CREATE PARTITION FUNCTION [fnMonthPartition](DATE) AS RANGE RIGHT FOR VALUES
('20201201','20210101','20210201','20210301','20210401', '20210501',
 '20210601', '20210701', '20210801');																																																									
GO

--CREATE PARTITION SCHEME [schmYearPartition] AS PARTITION [fnYearPartition] 
--ALL TO ([PRIMARY])


-- партиционируем, используя созданную нами функцию
CREATE PARTITION SCHEME [schmMonthPartition] AS PARTITION [fnMonthPartition] 
ALL TO ([MonthData])
GO



--смотрим какие таблицы у нас партиционированы
select distinct t.name
from sys.partitions p
inner join sys.tables t
	on p.object_id = t.object_id
where p.partition_number <> 1



select * from sys.partition_range_values;
select * from sys.partition_parameters;
select * from sys.partition_functions;
--EXEC sp_GetDDL PF_TransactionDateTime;

--можем посмотреть текущие границы
select	 f.name as NameHere
		,f.type_desc as TypeHere
		,(case when f.boundary_value_on_right=0 then 'LEFT' else 'Right' end) as LeftORRightHere
		,v.value
		,v.boundary_id
		,t.name from sys.partition_functions f
inner join  sys.partition_range_values v
	on f.function_id = v.function_id
inner join sys.partition_parameters p
	on f.function_id = p.function_id
inner join sys.types t
	on t.system_type_id = p.system_type_id
order by NameHere, boundary_id;


----- Создаем пратиционную таблицу 
CREATE TABLE [dbo].[LeadTestIndex](
	[Lead_ID] [int] NOT NULL,
	[DateCtreate] [datetime2] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[SourceID] [int] NOT NULL,
	[DLM] [datetime2] NOT NULL,
	[DateReport] [date] NOT NULL,
	CONSTRAINT [PK_LeadTestIndex] PRIMARY KEY CLUSTERED 
(
	[Lead_ID] ASC,
	[DateReport] ASC
)
) ON [schmMonthPartition] ([DateReport])   -- указываем схему патиционирования

----- Создаем вторую пратиционную таблицу 
CREATE TABLE [dbo].[LeadTestStage](
	[Lead_ID] [int] NOT NULL,
	[DateCtreate] [datetime2] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[SourceID] [int] NOT NULL,
	[DLM] [datetime2] NOT NULL,
	[DateReport] [date] NOT NULL,
	CONSTRAINT [PK_LeadTestStage] PRIMARY KEY CLUSTERED 
(
	[Lead_ID] ASC,
	[DateReport] ASC
)
) ON [schmMonthPartition] ([DateReport])   -- указываем схему патиционирования

--TRUNCATE TABLE [dbo].[LeadTestIndex]
--- заполняем таблицу
INSERT INTO [dbo].[LeadTestIndex]
SELECT [Lead_ID]
      ,[DateCtreate]
      ,[CustomerID]
      ,[StatusID]
      ,[SourceID]
      ,[DLM]
	  ,CAST([DateCtreate] as date)
  FROM [dbo].Lead
  WHERE [DateCtreate] BETWEEN '20210101' AND '20210731' --[DateCtreate] < '20210301' OR 

--TRUNCATE TABLE [dbo].[LeadTestIndex]
--- заполняем таблицу
--INSERT INTO [dbo].[LeadTestStage]
--SELECT [Lead_ID]
--      ,[DateCtreate]
--      ,[CustomerID]
--      ,[StatusID]
--      ,[SourceID]
--      ,[DLM]
--	  ,CAST([DateCtreate] as date)
--  FROM [dbo].Lead
--  WHERE [DateCtreate] BETWEEN  '20210301' AND '20210331'

SELECT * FROM [dbo].[LeadTestIndex]
SELECT * FROM [dbo].[LeadTestStage]

--смотрим как конкретно по диапазонам уехали данные
SELECT  $PARTITION.[fnMonthPartition](DateReport) AS Partition
		, COUNT(*) AS [COUNT]
		, MIN(DateReport)
		,MAX(DateReport) 
FROM [dbo].LeadTestIndex
GROUP BY $PARTITION.[fnMonthPartition](DateReport) 
ORDER BY Partition ;

SELECT  $PARTITION.[fnMonthPartition](DateReport) AS Partition
		, COUNT(*) AS [COUNT]
		, MIN(DateReport)
		,MAX(DateReport) 
FROM [dbo].[LeadTestStage]
GROUP BY $PARTITION.[fnMonthPartition](DateReport) 
ORDER BY Partition ; 

--SELECT $PARTITION.[fnMonthPartition]([DateCtreate]) AS Partition,   
--COUNT(*) AS [COUNT], MIN([DateCtreate]),MAX([DateCtreate]) 
--FROM [dbo].LeadTestIndex
--GROUP BY $PARTITION.[fnMonthPartition]([DateCtreate]) 
--ORDER BY Partition ;  


ALTER TABLE [dbo].LeadTestIndex SWITCH PARTITION 9 TO [dbo].[LeadTestStage] PARTITION 9;

SELECT * FROM [dbo].[LeadTestIndex]
SELECT * FROM [dbo].[LeadTestStage]

TRUNCATE TABLE [dbo].LeadTestIndex
TRUNCATE TABLE [dbo].[LeadTestStage]

DROP TABLE IF EXISTS [dbo].LeadTestIndex
DROP TABLE IF EXISTS  [dbo].[LeadTestStage]