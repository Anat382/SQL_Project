

CREATE PROCEDURE [dbo].[uspCreateDataBase2021]
AS
BEGIN
	SET ANSI_WARNINGS ON; 
    SET NOCOUNT ON;
    SET XACT_ABORT ON;



	-- Delete table
	DROP TABLE IF EXISTS [Sales].[Deal]
	DROP TABLE IF EXISTS [Sales].[Lead]
	DROP TABLE IF EXISTS [Sales].[Customers]
	DROP TABLE IF EXISTS [Prod].[Employee]
	DROP TABLE IF EXISTS [Prod].[Job]
	DROP TABLE IF EXISTS  Sales.Region
	DROP TABLE IF EXISTS [Prod].[CalendarDay]
	DROP TABLE IF EXISTS [Prod].[Email]
	DROP TABLE IF EXISTS [Prod].[Status]
	DROP TABLE IF EXISTS [Sales].[TypesOfServices]
	DROP TABLE IF EXISTS [Sales].[Price]
	DROP TABLE IF EXISTS [Sales].[Source]
	DROP TABLE IF EXISTS  dbo.LogUpdateTable


	CREATE TABLE dbo.LogUpdateTable (
		ID bigint NOT NULL identity(1, 1)  primary key,
		NameTable NVARCHAR(50) NOT NULL,
		UpdateRow int NOT NULL,
		InsertRow int NOT NULL,
		DateOper DateTime2 NOT NULL
	)
	

	---- Region -----
	BEGIN
		CREATE TABLE Sales.Region(
			ID    int			not null identity(1, 1)  primary key,
			Name  nvarchar(100) not null
		)

		INSERT INTO Sales.Region ( Name)
			SELECT Name FROM [StageLevel2021].[dbo].[Region]
	END
	--SELECT * FROM  Sales.Region

	--=======================================
	---- Customers -----
	BEGIN
		--DROP TABLE IF EXISTS  Sales.Customers
		CREATE TABLE Sales.Customers(
			ID			int				not null identity(1, 1)  primary key,
			DateCreate  datetime2		not null,
			FirstName	nvarchar(50)	not null,
			LastName	nvarchar(50)	not null,
			SecondName	nvarchar(50)	not null,
			BierthDay	date			not null CHECK (BierthDay >= N'19600101' AND BierthDay <= DATEADD( year, -21, GETDATE() ) ),
			RegionID	int				not null FOREIGN KEY REFERENCES Sales.Region (ID)  
		)

		--SELECT DATEADD( day, FLOOR(RAND()*(14600-100)+100), '19700101')
		--(SELECT TOP 1 ID FROM Sales.Region ORDER BY NEWID())

		--SELECT *  FROM [StageLevel2021].[dbo].[Contact]
		DROP TABLE IF EXISTS  #Contact
		DECLARE @n int, @num int, @const int

		SELECT DATE_CREATE, FIRST_NAME, LAST_NAME, SECOND_NAME, ROW_NUMBER() OVER( ORDER BY DATE_CREATE) as Row_Count 
		INTO #Contact
		FROM [StageLevel2021].[dbo].[Contact]
		WHERE FIRST_NAME != 'NULL' AND LAST_NAME != 'NULL'  AND SECOND_NAME != 'NULL'

		SET @n = ( SELECT COUNT(*) FROM Sales.Region)
		SET @const = ( SELECT COUNT(*) FROM #Contact )

		SET @num = 1

		--INSERT INTO  Sales.Customers (DATE_CREATE, FIRST_NAME, LAST_NAME, SECOND_NAME, BierthDay, RegionID)
		BEGIN
		WHILE @num <= @const
			BEGIN
				INSERT INTO  Sales.Customers (DateCreate, FirstName, LastName, SecondName, BierthDay, RegionID)
					SELECT DATE_CREATE, FIRST_NAME, LAST_NAME, SECOND_NAME,  DATEADD( day, FLOOR(RAND()*(14600-100)+100), '19600101'), FLOOR(RAND()*(@n-1)+1) FROM #Contact
					WHERE  Row_Count = @num
	
				SET @num = @num + 1
			END
		END
		--SELECT * FROM Sales.Customers

		------

		--, FirstName ASC, LastName, SecondName ASC, BierthDay ASC, RegionID ASC
		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Customers'
		--AND TABLE_SCHEMA = 'Sales'

	END
	--============================================================
	---- Email -----
	BEGIN
	--DROP TABLE IF EXISTS  Prod.Email
	
		CREATE TABLE Prod.Email(
			ID		int			 not null identity(1, 1)  primary key,
			Name	nvarchar(50) not null CHECK (Name LIKE '%@%' )
		)

		--SELECT * FROM [StageLevel2021].[dbo].[EMAIL]

		INSERT INTO Prod.Email ( NAme)
			SELECT NAme FROM [StageLevel2021].[dbo].[EMAIL]

		--SELECT * FROM Prod.Email
	END
	--===========================================================
			---- job -----
	BEGIN

		--DROP TABLE IF EXISTS  Prod.Job
		CREATE TABLE Prod.Job(
			ID		int				not null identity(1, 1)  primary key,
			Name	nvarchar(50)	not null
		)

		--SELECT * FROM [StageLevel2021].[dbo].[WORK_POSITION]

		INSERT INTO Prod.Job ( NAme)
			SELECT NAme FROM [StageLevel2021].[dbo].[WORK_POSITION]

		--SELECT * FROM Prod.Job
	END
	--============================================================
	---- Price -----
	BEGIN
		--DROP TABLE IF EXISTS  Sales.Price
		CREATE TABLE Sales.Price(
			ID		int		not null identity  primary key,
			Price	decimal not null CHECK (Price >= 1000 AND Price <= 50000)
		)

		DECLARE  @np int

		SET @np = 1

		WHILE @np <= 10
			BEGIN
				INSERT INTO Sales.Price ( Price)
					SELECT  FLOOR(RAND()*(50000-1000)+1000)
					SET @np = @np + 1
			END

		--SELECT * FROM Sales.Price
		--TRUNCATE TABLE Sales.Price
	END
	--===================================================================
	---- Types Of Services -----
	BEGIN
		--DROP TABLE IF EXISTS  Sales.TypesOfServices
		CREATE TABLE  Sales.TypesOfServices(
			ID		int			 not null identity  primary key,
			Name	nvarchar(255) not null,
			PriceID int			 not null FOREIGN KEY REFERENCES Sales.Price (ID)
		)

		DECLARE @n1 int, @cp int, @q int

		SET @n1 = (SELECT COUNT(*) FROM Sales.Price )
		SET @q =  (SELECT COUNT(*) FROM [StageLevel2021].[dbo].[TypeProduct] )

		SET @cp = 1

		DROP TABLE IF EXISTS  #Prodact
		SELECT *, ROW_NUMBER() OVER( ORDER BY ID) as Row
		INTO #Prodact
		FROM [StageLevel2021].[dbo].[TypeProduct]

		WHILE @cp <= @q
			BEGIN
				INSERT INTO Sales.TypesOfServices ( Name, PriceID)
					SELECT Name, CAST(FLOOR(RAND()*(@n1-1)+1) as int) FROM #Prodact
					WHERE Row = @cp
					SET @cp = @cp + 1
			END

		--SELECT  * FROM Sales.TypesOfServices
		--TRUNCATE TABLE Sales.TypesOfServices
	END
	--===================================================================
	----  Source -----

	BEGIN
		--DROP TABLE IF EXISTS  Sales.Source
		CREATE TABLE  Sales.Source(
			ID	 int		  not null identity(1, 1)  primary key,
			Name nvarchar(100) not null
		)

		--SELECT * FROM [StageLevel2021].[dbo].[Source]

		INSERT INTO Sales.Source ( Name)
			SELECT [Name] FROM [StageLevel2021].[dbo].[Source]

		--SELECT * FROM Sales.Source

		--=================================================================
		----  Status -----
		--DROP TABLE IF EXISTS  Prod.Status
		CREATE TABLE   Prod.Status(
			ID	 int		  not null identity(1, 1)  primary key,
			Name nvarchar(50) not null,
			Type nvarchar(50) not null
		)

		INSERT INTO Prod.Status ( Name, Type)
			VALUES ( 'Брак', 'Lead'),
				   ('Консультация', 'Lead'),
				   ('Оплачен', 'Deal'),
				   ('Брак', 'Deal')

		--SELECT * FROM  Prod.Status
	END

	--=================================================================
	------ Employee -----
	BEGIN
		--DROP TABLE IF EXISTS  Prod.Employee
		CREATE TABLE Prod.Employee(
			ID					int			 not null identity(1, 1)  primary key,
			DateStart			Datetime2 not null,
			DateEnd				Datetime2  null,
			JobID				int			 not null FOREIGN KEY REFERENCES Prod.Job (ID),
			EmailID				int			 not null FOREIGN KEY REFERENCES Prod.Email (ID),
			FirstName			nvarchar(50) not null,
			LastName			nvarchar(50) not null,
			SecondName			nvarchar(50) not null,
			Birhday				date		 not null
		)

		--SELECT FLOOR(RAND()*(15-5)+5); --- пїЅпїЅпїЅпїЅпїЅпїЅ
		--SELECT * FROM [StageLevel2021].[dbo].[Emploee]

		--UPDATE [StageLevel2021].[dbo].[Emploee] SET ID = c2.[Row]
		--FROM [StageLevel2021].[dbo].[Emploee] c
		--JOIN ( SELECT *, ROW_NUMBE-R() OVER( ORDER BY DateStart ) as [Row] FROM [StageLevel2021].[dbo].[Emploee] ) c2 ON c2.ID=c.ID


		DECLARE 
		 @JOB_C INT,
		 @EMAIL_C INT,
		 @Emploee INT,
		 @cc int


		SET @JOB_C = (SELECT COUNT(*) FROM Prod.Job )
		SET @EMAIL_C = (SELECT COUNT(*) FROM Prod.Email )
		SET @Emploee = (SELECT COUNT(*) FROM [StageLevel2021].[dbo].[Emploee] )
		SET @cc = 1

		WHILE @cc <= @Emploee
			BEGIN
			INSERT INTO Prod.Employee (DateStart ,DateEnd ,JobID ,EmailID , FirstName, LastName ,SecondName ,Birhday)
				 SELECT DateStart ,IIF(DateEnd = 'NULL', NULL, DateEnd) ,FLOOR(RAND()*(@JOB_C-1)+1) ,ID,  n.Name ,LAST_NAME ,SECOND_NAME ,
				 DATEADD( day, FLOOR(RAND()*(3650-100)+100), '19850101')
				 FROM [StageLevel2021].[dbo].[Emploee] e
				 OUTER APPLY (
					SELECT TOP 1 Gender , NAME FROM ( VALUES (1, 'Анна'), (0, 'Игорь'), (0, 'Евгений'), (0, 'Алекесандр'), (1, 'Нина'), (1, 'Светлана'), (1, 'Ольга'), (0, 'Николай'), (0, 'Пётр'), (0, 'Иван'), (1, 'Надежда'),
						(1, 'Анастасия'), (0, 'Роман'), (0, 'Егор'), (0, 'Дмитрий')
							) d(Gender, Name)
					WHERE IIF( RIGHT(e.SECOND_NAME,1) = 'а',1,0)=Gender
					ORDER BY  NEWID()
					) n 
				 WHERE e.ID = @cc 
			SET @cc = @cc + 1 
			END

		--SELECT * FROM Prod.Employee

		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Employee'
		--AND TABLE_SCHEMA = 'Prod'
	END
	--=====================================================================
	------ Lead -----
	BEGIN
		--DROP TABLE IF EXISTS  Sales.Lead
		CREATE TABLE Sales.Lead(
			Lead_ID		int			not null identity(1, 1)  primary key,
			DateCtreate datetime2	not null,
			CustomerID	int			not null FOREIGN KEY REFERENCES Sales.Customers (ID),
			StatusID	int			not null FOREIGN KEY REFERENCES Prod.Status (ID),
			SourceID	int			not null FOREIGN KEY REFERENCES Sales.Source (ID) 
		)

		--SELECT * FROM [StageLevel2021].[dbo].[Lead] ORDER BY Lead_ID

		--UPDATE [StageLevel2021].[dbo].[Lead] SET Lead_ID = c2.[Row]
		--FROM [StageLevel2021].[dbo].[Lead] c
		--JOIN ( SELECT *, ROW_NUMBER() OVER( ORDER BY DATE_CREATE ) as [Row] FROM [StageLevel2021].[dbo].[Lead] ) c2 ON c2.UID=c.UID

		DECLARE 
		 @Customers_C INT,
		 @Source_C INT,
		 @Lead INT,
		 @cc1 int


		SET @Customers_C = ( SELECT COUNT(*) FROM [Sales].[Customers] )
		SET @Source_C = ( SELECT COUNT(*) FROM [Sales].[Source] )
		SET @Lead = ( SELECT COUNT(*) FROM [StageLevel2021].[dbo].[Lead] )
		SET @cc1 = 1

		WHILE @cc1 <= @Lead
			BEGIN
			INSERT INTO Sales.Lead(DateCtreate ,CustomerID ,StatusID ,SourceID)
				 SELECT 
					DATE_CREATE , FLOOR(RAND()*(@Customers_C-1)+1) ,IIF(Lead_ID %2 > 0,2,1) ,FLOOR(RAND()*(@Source_C-1)+1) 
				 FROM [StageLevel2021].[dbo].[Lead]  e
				 WHERE e.Lead_ID = @cc1 
			SET @cc1 = @cc1 + 1 
			END

		--SELECT * FROM Sales.Lead ORDER BY Lead_ID




		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Lead'
		--AND TABLE_SCHEMA = 'Sales'
	END
	--==================================================================================
	------ Deal -----
	BEGIN
		--DROP TABLE IF EXISTS  Sales.Deal
		CREATE TABLE Sales.Deal(
			Deal_ID		int			not null identity(1, 1) primary key,
			Lead_ID		int			not null FOREIGN KEY REFERENCES  Sales.Lead (Lead_ID),
			DateCreate datetime2	not null,
			DateClose	datetime2	null,
			TypeID		int			not null FOREIGN KEY REFERENCES Sales.TypesOfServices (ID),
			StatusID	int			not null FOREIGN KEY REFERENCES Prod.Status (ID),
			EmploeeID	int			not null FOREIGN KEY REFERENCES [Prod].[Employee] (ID)
		)

		--SELECT * FROM [Sales].[TypesOfServices]
		----SELECT * FROM [StageLevel2021].[dbo].[Deal] ORDER BY Deal_ID

		--UPDATE [StageLevel2021].[dbo].Deal SET Deal_ID = c2.[Row]
		--FROM [StageLevel2021].[dbo].Deal c
		--JOIN ( SELECT *, ROW_NUMBER() OVER( ORDER BY DATE_CREATE ) as [Row] FROM [StageLevel2021].[dbo].Deal ) c2 ON c2.Deal_ID=c.Deal_ID

		DECLARE 
		 @Deal INT,
		 @cc2 int

		SET @Deal = ( SELECT COUNT(*) FROM [StageLevel2021].[dbo].[Deal]  ) 
		SET @cc2 = 1

		WHILE @cc2 <= @Deal
			BEGIN
				INSERT INTO Sales.Deal(Lead_ID ,DateCreate ,DateClose ,TypeID ,StatusID, EmploeeID)
					 SELECT 
						n.Lead_ID, DATE_CREATE , IIF(DateClose = 'NULL', NULL, DateClose), t.ID, IIF(DateClose = 'NULL', 4, 3) , emp.ID
					 FROM [StageLevel2021].[dbo].[Deal]  e
					 OUTER APPLY (
						SELECT TOP 1 
							Lead_ID	
						FROM Sales.Lead
						WHERE StatusID = 2
						ORDER BY  NEWID()
						) n
					 OUTER APPLY (
						SELECT TOP 1 
							ID	
						FROM Sales.TypesOfServices
						ORDER BY  NEWID()
						) t
					 OUTER APPLY (
						SELECT TOP 1 
							ID	
						FROM [Prod].[Employee] 
						WHERE  CAST(  e.DATE_CREATE as DATE) BETWEEN CAST( ISNULL(DateStart, N'99900101') as DATE) AND CAST( ISNULL(DateEnd, N'99900101') as DATE)
						ORDER BY  NEWID()
						) emp
					 WHERE e.Deal_ID = @cc2 
				SET @cc2 = @cc2 + 1 
			END

		--SELECT * FROM Sales.[Deal]


		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Deal'
		--AND TABLE_SCHEMA = 'Sales'
	END

	--===================================================================================
	----- Calendar -----------
	BEGIN

		--CREATE PROCEDURE [Calendar].[UpdateDay]

		--AS
		--BEGIN
		--    SET NOCOUNT ON;
		--    SET XACT_ABORT ON;

			--TRUNCATE TABLE  Prod.[CalendarDay]
			--DROP TABLE IF EXISTS Prod.[CalendarDay]
			CREATE TABLE  Prod.[CalendarDay] ([CreatedDate] date NOT NULL  CONSTRAINT PK_Prod_CalendarDay_CreatedDate PRIMARY KEY ([CreatedDate]) , 
					[SatrtMonth] date NOT NULL,
					[EndMonth] date NOT NULL,
					[Year] int NOT NULL,
					[Month] int NOT NULL,
					[Day] int NOT NULL,
					[MonthReport] NVARCHAR(10) NOT NULL,
					[MonthName] NVARCHAR(10) NOT NULL,
					[Quarter] int NOT NULL,
					[Dayofyear] int NOT NULL,
					[Week] int NOT NULL,
					[Weekday] int NOT NULL
					)

			DECLARE @date date
			SET @date = '2020-01-01'


		;WITH calday( [CreatedDate], [SatrtMonth], [EndMonth], [Year], [Month], [Day], [MonthReport], [MonthName], [Quarter], [Dayofyear], [Week], [Weekday] )
		 as (
				SELECT 
					@date
					, DATEFROMPARTS(YEAR(@date), MONTH(@date), 1) --[SatrtMonth]
					, EOMONTH(@date) -- as [EndMonth]
					, YEAR(@date) -- [Year]
					, MONTH(@date) -- [Month]
					, DAY(@date) -- [Day]
					, FORMAT(@date, 'yyyy-MM') -- [MonthReport]
					, CASE MONTH(@date) 
						WHEN 1 THEN 'Январь' 
						WHEN 2 THEN 'Февраль'
						WHEN 3 THEN 'Март'
						WHEN 4 THEN 'Апрель'
						WHEN 5 THEN 'Май'
						WHEN 6 THEN 'Июнь'
						WHEN 7 THEN 'Июль'
						WHEN 8 THEN 'Август'
						WHEN 9 THEN 'Сентябрь'
						WHEN 10 THEN 'Октябрь'
						WHEN 11 THEN 'Ноябрь'
						WHEN 12 THEN 'Декабрь'
						END --- [MONTHNAME]
					, DATEPART(Quarter, @date ) --[Quarter]
					, DATEPART(dayofyear, @date ) -- [dayofyear]
					, DATEPART(week, @date ) -- [week]
					, DATEPART(weekday, @date ) -- [weekday] )
				UNION ALL 
				SELECT 
					dt.[CreatedDate]
					, DATEFROMPARTS(YEAR(dt.[CreatedDate]), MONTH(dt.[CreatedDate]), 1) --[SatrtMonth]
					, EOMONTH(dt.[CreatedDate]) -- as [EndMonth]
					, YEAR(dt.[CreatedDate]) -- [Year]
					, MONTH(dt.[CreatedDate]) -- [Month]
					, DAY(dt.[CreatedDate]) -- [Day]
					, FORMAT(dt.[CreatedDate], 'yyyy-MM') -- [MonthReport]
					, CASE MONTH(dt.[CreatedDate]) 
						WHEN 1 THEN 'Январь' 
						WHEN 2 THEN 'Февраль'
						WHEN 3 THEN 'Март'
						WHEN 4 THEN 'Апрель'
						WHEN 5 THEN 'Май'
						WHEN 6 THEN 'Июнь'
						WHEN 7 THEN 'Июль'
						WHEN 8 THEN 'Август'
						WHEN 9 THEN 'Сентябрь'
						WHEN 10 THEN 'Октябрь'
						WHEN 11 THEN 'Ноябрь'
						WHEN 12 THEN 'Декабрь'
						END --- [MONTHNAME]
					, DATEPART(Quarter, dt.[CreatedDate] ) --[Quarter]
					, DATEPART(dayofyear, dt.[CreatedDate] ) -- [dayofyear]
					, DATEPART(week, dt.[CreatedDate] ) -- [week]
					, DATEPART(weekday, dt.[CreatedDate] ) -- [weekday] )
				FROM calday 
				CROSS APPLY( SELECT DATEADD(DAY, 1, calday.[CreatedDate]) as [CreatedDate]) as dt
				WHERE dt.[CreatedDate] <= GETDATE()
		 )

		 INSERT INTO  Prod.[CalendarDay] ([CreatedDate], [SatrtMonth], [EndMonth], [Year], [Month], [Day], [MonthReport], [MonthName], [Quarter], [Dayofyear], [Week], [Weekday])  
			SELECT [CreatedDate], [SatrtMonth], [EndMonth], [Year], [Month], [Day], [MonthReport], [MonthName], [Quarter], [Dayofyear], [Week], [Weekday] 
			FROM calday
			OPTION (MAXRECURSION 0 ) 
 
			--WHILE @date <= EOMONTH(GETDATE() )
			--	BEGIN

			--		INSERT INTO  Prod.[CalendarDay] ([CreatedDate], [SatrtMonth], [EndMonth], [Year], [Month], [Day], [MonthReport], [MonthName], [Quarter], [Dayofyear], [Week], [Weekday]) 
			--			VALUES(
			--					@date
			--					, DATEFROMPARTS(YEAR(@date), MONTH(@date), 1) --[SatrtMonth]
			--					, EOMONTH(@date) -- as [EndMonth]
			--					, YEAR(@date) -- [Year]
			--					, MONTH(@date) -- [Month]
			--					, DAY(@date) -- [Day]
			--					, FORMAT(@date, 'yyyy-MM') -- [MonthReport]
			--					, CASE MONTH(@date) 
			--						WHEN 1 THEN 'Январь' 
			--						WHEN 2 THEN 'Февраль'
			--						WHEN 3 THEN 'Март'
			--						WHEN 4 THEN 'Апрель'
			--						WHEN 5 THEN 'Май'
			--						WHEN 6 THEN 'Июнь'
			--						WHEN 7 THEN 'Июль'
			--						WHEN 8 THEN 'Август'
			--						WHEN 9 THEN 'Сентябрь'
			--						WHEN 10 THEN 'Октябрь'
			--						WHEN 11 THEN 'Ноябрь'
			--						WHEN 12 THEN 'Декабрь'
			--						END --- [MONTHNAME]
			--					, DATEPART(Quarter, @date ) --[Quarter]
			--					, DATEPART(dayofyear, @date ) -- [dayofyear]
			--					, DATEPART(week, @date ) -- [week]
			--					, DATEPART(weekday, @date ) -- [weekday] )
			--				)
			--		SET @date = DATEADD(DAY,1,@date)

      
			--	END;
	
			--SELECT * FROM Prod.[CalendarDay]

		--END;
		--GO



		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'CalendarDay'
	END

	--===================================================================================
	--____________________________________________________________________________________________________________
	------------ check the created tables --------

	BEGIN
		DECLARE @dml AS NVARCHAR(MAX), @COUNT AS INT, @N3 int, @TABLE_NAME NVARCHAR(100)

		SET @COUNT = (SELECT  COUNT(*) FROM INFORMATION_SCHEMA.TABLES -- STRING_AGG(CONCAT(TABLE_SCHEMA,'.', TABLE_NAME) , ',' ) 
						WHERE TABLE_SCHEMA IN ('Prod','Sales') )


		DROP TABLE IF EXISTS #tab_tt
		SELECT  CONCAT(TABLE_SCHEMA,'.', TABLE_NAME)  as Name, ROW_NuMBER() OVER( ORDER BY TABLE_SCHEMA ) as ID
		INTO #tab_tt
		FROM INFORMATION_SCHEMA.TABLES -- STRING_AGG(CONCAT(TABLE_SCHEMA,'.', TABLE_NAME) , ',' ) 
		WHERE TABLE_SCHEMA IN ('Prod','Sales')

		--SELECT @COUNT

		SET @N3 = 1

		WHILE @N3 <= @COUNT
			BEGIN 
				SET @TABLE_NAME = (SELECT NAME FROM #tab_tt WHERE ID=@N3 )
				SET @dml = N'SELECT TOP 5 * FROM ' +  @TABLE_NAME
				SELECT @TABLE_NAME as TableName
				SET @N3 =  1 + @N3
				--SELECT @dml
				EXEC sp_executesql @dml;
			END

	END




END
