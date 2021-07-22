




--EXEC [dbo].[uspUdateDataBase2021]


CREATE PROCEDURE [dbo].[uspUdateDataBase2021]
AS

BEGIN TRAN 
	--SET ANSI_WARNINGS ON; 
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

	
	DECLARE @LogOutput table ( [TableName]  NVARCHAR(50), [Операция] NVARCHAR(50), [INSERTED] int )

---- Region -----
	
	--DROP TABLE IF EXISTS  #Region

	SELECT TOP 2 [Name] INTO #Region FROM  [StageLevel2021].[dbo].[Region] ORDER BY  NEWID()

		INSERT INTO Sales.Region ( Name)
			SELECT 
				t.Name
			FROM #Region  t
			LEFT JOIN  Sales.Region s on s.Name=t.Name
			WHERE s.Name IS NULL		

		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Sales.Region', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM #Region  t
			LEFT JOIN  Sales.Region s on s.Name=t.Name
			WHERE s.Name IS NULL
		) r
		
		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Sales.Region' )
			INSERT INTO @LogOutput 
				SELECT 'Sales.Region', NULl, 0;

	--SELECT * FROM  dbo.LogUpdateTable
	 --SELECT dbo.ufnString_agg( 'dbo', 'LogUpdateTable')
	--=======================================
	---- Customers -----
	
	--DROP TABLE IF EXISTS  #Customers
	--DROP TABLE IF EXISTS  #Contact

	SELECT * INTO #Customers FROM  Sales.Customers WHERE 1=0
	
	--DECLARE @n int, @num int, @const int

	SELECT TOP 20 DATE_CREATE, FIRST_NAME, LAST_NAME, SECOND_NAME, ROW_NUMBER() OVER( ORDER BY DATE_CREATE) as Row_Count 
	INTO #Contact
	FROM [StageLevel2021].[dbo].[Contact]
	WHERE FIRST_NAME != 'NULL' AND LAST_NAME != 'NULL'  AND SECOND_NAME != 'NULL'
	--ORDER BY  NEWID()

	--SET @n = 10 --( SELECT COUNT(*) FROM Sales.Region)
	--SET @const = ( SELECT COUNT(*) FROM #Contact )

	--SET @num = 1

	--INSERT INTO  Sales.Customers (DATE_CREATE, FIRST_NAME, LAST_NAME, SECOND_NAME, BierthDay, RegionID)


	;WITH 
	tt (DateCreate, FirstName, LastName, SecondName, BierthDay, RegionID, Row_Count, n) as (
		
		SELECT DATE_CREATE, FIRST_NAME, LAST_NAME, SECOND_NAME, DATEADD( day, FLOOR(RAND()*(14600-100)+100), '19600101'), CAST( RAND() * 20 as int ), Row_Count, 1
		FROM #Contact
		WHERE Row_Count = 1
		UNION ALL
		SELECT DATE_CREATE, FIRST_NAME, LAST_NAME, SECOND_NAME, DATEADD( day, 12000 + (600 + CAST( RAND() * t.n as int ) * CAST( RAND() * 20 as int )), '19600101') as BierthDay, CAST( RAND() * t.n - 1 as int ) + 1 as RegionID,  c.Row_Count, t.n  as n
		FROM #Contact c
		CROSS JOIN (SELECT n + 1 as n FROM tt) as t
		WHERE c.Row_Count = t.n
		
	)
	INSERT INTO  #Customers (DateCreate, FirstName, LastName, SecondName, BierthDay, RegionID)
	SELECT DateCreate, FirstName, LastName, SecondName, BierthDay, RegionID
	FROM tt
	OPTION (MAXRECURSION 0 ) 

	BEGIN
		MERGE Sales.Customers AS T_Base
			USING (
				SELECT 
					DateCreate
					, FirstName
					, LastName
					, SecondName
					, BierthDay
					, RegionID					
				FROM #Customers 
				) AS T_Source
				ON (T_Base.[DateCreate] = T_Source.[DateCreate]
					AND T_Base.FirstName = T_Source.FirstName
					AND T_Base.LastName = T_Source.LastName
					AND T_Base.SecondName = T_Source.SecondName
				) ----COLLATE Cyrillic_General_CI_AS)
			WHEN MATCHED THEN
			UPDATE 
				SET T_Base.BierthDay  = 	T_Source.BierthDay
				,T_Base.RegionID  = 	T_Source.RegionID

			WHEN NOT MATCHED THEN
			INSERT (
				DateCreate
				, FirstName
				, LastName
				, SecondName
				, BierthDay
				, RegionID	
				)
			VALUES (
				T_Source.DateCreate
				, T_Source.FirstName
				, T_Source.LastName
				, T_Source.SecondName
				, T_Source.BierthDay
				, T_Source.RegionID	
			)
		
		---- Запись в лог ----
		OUTPUT
			'Sales.Customers'
			,$action as [Операция]
			,1
		INTO @LogOutput;

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Sales.Customers' )
			INSERT INTO @LogOutput 
				SELECT 'Sales.Customers', NULL, 0;

	--SELECT * FROM  Sales.Customers


		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Customers'
		--AND TABLE_SCHEMA = 'Sales'

	END

	--SELECT * FROM  Sales.Customers
	--============================================================
	---- Email -----
	

		--DROP TABLE IF EXISTS  #Email
	
		SELECT TOP 10 [Name] INTO #Email FROM  [StageLevel2021].[dbo].[EMAIL]  ORDER BY  NEWID()

		INSERT INTO Prod.Email ( Name)
			SELECT 
				t.Name
			FROM #Email  t
			LEFT JOIN  Prod.Email s on s.Name=t.Name
			WHERE s.Name IS NULL	

		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Prod.Email', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM #Email  t
			LEFT JOIN  Prod.Email s on s.Name=t.Name
			WHERE s.Name IS NULL
		) r
		
		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Prod.Email' )
			INSERT INTO @LogOutput 
				SELECT 'Prod.Email', NULl, 0;

		--SELECT * FROM Prod.Email
	
	--===========================================================
			---- job -----
	
	
		SELECT TOP 2 [Name] INTO #Job FROM  [StageLevel2021].[dbo].[WORK_POSITION]  ORDER BY  NEWID()

		INSERT INTO Prod.Job ( Name)
			SELECT 
				t.Name
			FROM #Job  t
			LEFT JOIN  Prod.Job s on s.Name=t.Name
			WHERE s.Name IS NULL	

		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Prod.Job', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM #Job  t
			LEFT JOIN  Prod.Job s on s.Name=t.Name
			WHERE s.Name IS NULL
		) r

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Prod.Job' )
			INSERT INTO @LogOutput 
				SELECT 'Prod.Job', NULl, 0;
		--SELECT * FROM Prod.Job
	
	--============================================================
	---- Price -----

	--DROP TABLE IF EXISTS  #Price

	SELECT Price INTO #Price FROM  Sales.Price  WHERE 1=0
	
		DECLARE  @np int

		SET @np = 1

		WHILE @np <= 2
			BEGIN
				INSERT INTO #Price ( Price)
					SELECT  FLOOR(RAND()*(50000-1000)+1000)
					SET @np = @np + 1
			END

		INSERT INTO Sales.Price ( Price)
			SELECT 
				t.Price
			FROM #Price  t
			LEFT JOIN  Sales.Price s on s.Price=t.Price
			WHERE s.Price IS NULL


		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Sales.Price', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM #Price  t
			LEFT JOIN  Sales.Price s on s.Price=t.Price
			WHERE s.Price IS NULL
		) r

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Sales.Price' )
			INSERT INTO @LogOutput 
				SELECT 'Sales.Price', NULl, 0;

		--SELECT * FROM Sales.Price
		--TRUNCATE TABLE Sales.Price

	--===================================================================
	---- Types Of Services -----
	
		--DROP TABLE IF EXISTS  #TypesOfServices
		--DROP TABLE IF EXISTS  #Prodact
		--DROP TABLE IF EXISTS  #ResTypesOfServices
	

		SELECT [Name], PriceID INTO #TypesOfServices FROM  Sales.TypesOfServices  WHERE 1=0

		DECLARE @n1 int, @cp int, @q int

		SET @n1 = (SELECT COUNT(*) FROM Sales.Price )
		SET @q =  2 --(SELECT COUNT(*) FROM [StageLevel2021].[dbo].[TypeProduct] )

		SET @cp = 1


		SELECT *, ROW_NUMBER() OVER( ORDER BY ID) as Row
		INTO #Prodact
		FROM [StageLevel2021].[dbo].[TypeProduct]

		WHILE @cp <= @q
			BEGIN
				INSERT INTO #TypesOfServices ( Name, PriceID)
					SELECT TOP 2 Name, CAST(FLOOR(RAND()*(@n1-1)+1) as int) 
					FROM #Prodact
					WHERE Row = @cp
					ORDER BY  NEWID()
				SET @cp = @cp + 1
			END
	

		BEGIN
			MERGE Sales.TypesOfServices AS T_Base
				USING (
					SELECT 
						 Name, PriceID				
					FROM #TypesOfServices 
					) AS T_Source
					ON (T_Base.Name = T_Source.Name ) 
				WHEN MATCHED THEN
				UPDATE 
					SET T_Base.PriceID  = 	T_Source.PriceID

				WHEN NOT MATCHED THEN
				INSERT (
					Name
					, PriceID
					)
				VALUES (
					T_Source.Name
					, T_Source.PriceID
				)
		
		---- Запись в лог ----
		OUTPUT
			'Sales.Region',
			$action as [Операция],
			1
		INTO @LogOutput;

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Sales.Region' )
			INSERT INTO @LogOutput 
				SELECT 'Sales.Region', NULl, 0;
		--SELECT  * FROM Sales.TypesOfServices
		--TRUNCATE TABLE Sales.TypesOfServices
	
	--===================================================================
	----  Source -----

		--DROP TABLE IF EXISTS  Sales.Source

		--SELECT * FROM [StageLevel2021].[dbo].[Source]

		SELECT [Name] 
		INTO #Source 
		FROM  [StageLevel2021].[dbo].[Source]

		INSERT INTO Sales.Source ( Name)
			SELECT 
				t.Name
			FROM #Source  t
			LEFT JOIN   Sales.Source s on s.Name=t.Name
			WHERE s.Name IS NULL
		
		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Sales.Source', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM #Source  t
			LEFT JOIN   Sales.Source s on s.Name=t.Name
			WHERE s.Name IS NULL
		) r

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Sales.Source' )
			INSERT INTO @LogOutput 
				SELECT 'Sales.Source', NULl, 0;
		--SELECT * FROM Sales.Source


	--=================================================================
	----  Status -----
	----DROP TABLE IF EXISTS  Prod.Status
	--CREATE TABLE   Prod.Status(
	--	ID	 int		  not null identity(1, 1)  primary key,
	--	Name nvarchar(50) not null,
	--	Type nvarchar(50) not null
	--)

	--INSERT INTO Prod.Status ( Name, Type)
	--	VALUES ( 'Брак', 'Lead'),
	--			('Консультация', 'Lead'),
	--			('Оплачен', 'Deal'),
	--			('Брак', 'Deal')

	----SELECT * FROM  Prod.Status

	--=================================================================
	------ Employee -----

		;WITH
		rclient as (
			SELECT TOP 10 * 
			FROM  Prod.Employee 
			WHERE DateEnd IS NULL
			ORDER BY NEWID()
		) 
		,res2 as (
			SELECT DateStart, IIF( MIN(DateStart) OVER( ORDER BY DateStart ) =DateStart, GETDATE(), DateEnd) as DateEnd ,JobID ,EmailID , FirstName, LastName ,SecondName ,Birhday
			FROM rclient r
			UNION ALL 
			SELECT *
			FROM( 
				SELECT TOP 1 GETDATE() as DateStart ,NULL as DateEnd ,JobID ,EmailID 
				, (SELECT TOP 1 FirstName FROM Prod.Employee WHERE RIGHT(FirstName,1)='а'  ORDER BY NEWID()) as FirstName
				, (SELECT TOP 1 LastName FROM Prod.Employee WHERE RIGHT(FirstName,1)='а' ORDER BY NEWID())  as LastName
				, (SELECT TOP 1 SecondName FROM Prod.Employee WHERE RIGHT(FirstName,1)='а' ORDER BY NEWID()) as SecondName 
				, (SELECT TOP 1 Birhday FROM Prod.Employee ORDER BY NEWID()) as Birhday
				FROM  Prod.Employee 
				WHERE DateEnd IS NULL AND LastName != 'systems'
				ORDER BY NEWID()
			) s1
		)
		SELECT * 
		INTO #Employee 
		FROM res2

		BEGIN
			MERGE Prod.Employee AS T_Base
				USING (
					SELECT 
						 DateStart ,DateEnd ,JobID ,EmailID , FirstName, LastName ,SecondName ,Birhday			
					FROM #Employee 
					) AS T_Source
					ON (
						T_Base.DateStart = T_Source.DateStart
						AND T_Base.FirstName = T_Source.FirstName
						AND T_Base.LastName = T_Source.LastName
						AND T_Base.SecondName = T_Source.SecondName
						AND T_Base.Birhday = T_Source.Birhday
						) 
				WHEN MATCHED THEN
				UPDATE 
					SET T_Base.DateEnd  = 	T_Source.DateEnd,
						T_Base.JobID  = 	T_Source.JobID,
						T_Base.EmailID  = 	T_Source.EmailID

				WHEN NOT MATCHED THEN
				INSERT (
					DateStart ,DateEnd ,JobID ,EmailID , FirstName, LastName ,SecondName ,Birhday
					)
				VALUES (
					DateStart ,DateEnd ,JobID ,EmailID , FirstName, LastName ,SecondName ,Birhday
				)
		
		---- Запись в лог ----
			OUTPUT
			'Prod.Employee'
			,$action as [Операция]
			,1
			INTO @LogOutput;

		END
		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Prod.Employee' )
			INSERT INTO @LogOutput 
				SELECT 'Prod.Employee', NULl, 0;

		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Employee'
		--AND TABLE_SCHEMA = 'Prod'
	--=====================================================================
	------ Lead -----

		--DROP TABLE IF EXISTS #Lead
		--DROP TABLE IF EXISTS #LeadRes

		SELECT TOP 200 Lead_ID, DateCtreate, CustomerID, StatusID, SourceID 
		INTO #Lead
		FROM  Sales.Lead 
		WHERE [StatusID] = 2
		ORDER BY NEWID()


		SELECT GETDATE() as DateCtreate, r.CustomerID , IIF(Lead_ID % 3 > 0,2,1) as StatusID, SourceID
		INTO #LeadRes
		FROM #Lead
		OUTER APPLY( SELECT FLOOR(RAND() * CustomerID) as CustomerID) r

		INSERT INTO Sales.Lead(DateCtreate , CustomerID ,StatusID ,SourceID)
		SELECT DateCtreate , CustomerID ,StatusID ,SourceID
		FROM #LeadRes

		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Sales.Lead', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM #LeadRes
		) r

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Sales.Lead' )
			INSERT INTO @LogOutput 
				SELECT 'Sales.Lead', NULl, 0;		

		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Lead'
		--AND TABLE_SCHEMA = 'Sales'

	--==================================================================================
	------ Deal -----
		--DROP TABLE IF EXISTS  Sales.Deal
		

		DELETE Sales.Deal WHERE [StatusID] = 2 and [DateCreate] >= CAST( DATEFROMPARTS( YEAR(GETDATE()), MONTH(GETDATE()), 1) as DATETIME2);


		INSERT INTO Sales.Deal(Lead_ID ,DateCreate ,DateClose ,TypeID ,StatusID, EmploeeID)
			SELECT 
				l.Lead_ID, l.DateCtreate
				, IIF( res.StatusID = 3, DATEADD(hour, 9, l.DateCtreate ), NULL ) 
				, (SELECT TOP 1 ID FROM Sales.TypesOfServices t, Sales.Lead ld WHERE ld.Lead_ID=l.Lead_ID  ORDER BY NEWID() )
				, IIF(l.Lead_ID % 3 > 0,4,3)
				, (SELECT TOP 1 ID FROM Prod.Employee, Sales.Lead ld WHERE ld.Lead_ID=l.Lead_ID ORDER BY NEWID() )
			FROM Sales.Lead l
			OUTER APPLY( SELECT IIF(l.Lead_ID % 3 > 0,4,3) as StatusID) res
			WHERE l.[StatusID] = 2 
				and l.DateCtreate >= CAST( DATEFROMPARTS( YEAR(GETDATE()), MONTH(GETDATE()), 1) as DATETIME2) --(SELECT DATEMAX(DateCtreate) FROM #LeadRes)

		;WITH 
		dd as (
			SELECT TOP 3 *
			FROM Sales.Deal
			WHERE DateClose IS NULL
			ORDER BY NEWID()
		)

		UPDATE dd SET DateClose = GETDATE()
		OUTPUT 
			'Sales.Deal', 'UPDATE', 1
		INTO @LogOutput;


		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Sales.Deal', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM Sales.Lead l
			OUTER APPLY( SELECT IIF(l.Lead_ID % 3 > 0,4,3) as StatusID) res
			WHERE l.[StatusID] = 1 
				and l.DateCtreate >= CAST( DATEFROMPARTS( YEAR(GETDATE()), MONTH(GETDATE()), 1) as DATETIME2)
		) r

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Sales.Deal' )
			INSERT INTO @LogOutput 
				SELECT 'Sales.Deal', NULl, 0;			
		
		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'Deal'
		--AND TABLE_SCHEMA = 'Sales'
	

	--===================================================================================
	----- Calendar -----------
	

		TRUNCATE TABLE Prod.[CalendarDay] 

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

		---- Запись в лог ----
		INSERT INTO @LogOutput ( [TableName], [Операция], [INSERTED]  )
		SELECT 
			'Prod.CalendarDay', 'INSERTED', QTY
		FROM (	
			SELECT 
				1 as QTY
			FROM Prod.[CalendarDay]
		) r

		IF NOT EXISTS (SELECT l.TableName  FROM @LogOutput l WHERE l.TableName = 'Prod.CalendarDay' )
			INSERT INTO @LogOutput 
				SELECT 'Prod.CalendarDay', NULl, 0;	
		--SELECT STRING_AGG(COLUMN_NAME, ' ASC, ') FROm INFORMATION_SCHEMA.COLUMNS
		--WHERE TABLE_NAME = 'CalendarDay'
	


		---- Запись в лог ----
		INSERT INTO dbo.LogUpdateTable ( [NameTable], [UpdateRow], [InsertRow], [DateOper] )
		SELECT 
			[TableName], SUM(IIF([Операция] = 'UPDATE', 1, 0)), SUM(IIF([Операция] = 'INSERTED', 1, 0)), GETDATE()
		FROM @LogOutput
		GROUP BY [TableName]

		END


COMMIT
