



--SELECT CONCAT('TRUNCATE TABLE ', TABLE_SCHEMA, '.',	TABLE_NAME, ';' )FROM INFORMATION_SCHEMA.TABLES

CREATE PROCEDURE  [dbo].[uspCreateTableDWH2021]
AS
BEGIN
	SET ANSI_WARNINGS ON; 
    SET NOCOUNT ON;
    SET XACT_ABORT ON;



	-- Delete table
	DROP TABLE IF EXISTS dbo.[Deal]
	DROP TABLE IF EXISTS dbo.[Lead]
	DROP TABLE IF EXISTS dbo.[Customers]
	DROP TABLE IF EXISTS dbo.[Employee]
	DROP TABLE IF EXISTS dbo.[Job]
	DROP TABLE IF EXISTS  dbo.Region
	DROP TABLE IF EXISTS dbo.[CalendarDay]
	DROP TABLE IF EXISTS dbo.[Email]
	DROP TABLE IF EXISTS dbo.[Status]
	DROP TABLE IF EXISTS dbo.[TypesOfServices]
	DROP TABLE IF EXISTS dbo.[Price]
	DROP TABLE IF EXISTS dbo.[Source]

	DROP TABLE IF EXISTS [Sales].[FactConvertLeadToDeal];


	---- Region -----
	
	CREATE TABLE dbo.Region(
		ID    int			not null primary key,
		RegionID INT		not null,
		Name  nvarchar(100) not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_dboRegion_RegionID ON dbo.Region
	-- (
	-- RegionID ASC
	-- )

	--=======================================
	---- Customers -----

	CREATE TABLE dbo.Customers(
		ID			int				not null  primary key,
		[CustomerID] int			not null,
		DateCreate  datetime2		not null,
		FirstName	nvarchar(50)	not null,
		LastName	nvarchar(50)	not null,
		SecondName	nvarchar(50)	not null,
		BierthDay	date			not null,
		RegionID	int				not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_dboCustomers_CustomerID ON dbo.Customers
	-- (
	-- CustomerID ASC
	-- )

	--============================================================
	---- Email -----
	
	CREATE TABLE dbo.Email(
		ID		int			 not null primary key,
		EmailID	int			 not null,
		Name	nvarchar(50) not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_dboEmail_EmailID ON dbo.Email
	-- (
	-- EmailID ASC
	-- )

	--===========================================================
			---- job -----

	CREATE TABLE dbo.Job(
		ID		int				not null primary key,
		JobID		int				not null,
		Name	nvarchar(50)	not null,
		DLM			DATETIME2		not null
	)
	
	--CREATE UNIQUE CLUSTERED INDEX IXС_dboJob_JobID ON dbo.Job
	-- (
	-- JobID ASC
	-- )
	--============================================================
	---- Price -----

	CREATE TABLE dbo.Price(
		ID		int		not null primary key,
		PriceID		int		not null,
		Price	decimal not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_dboPrice_PriceID ON dbo.Price
	-- (
	-- PriceID ASC
	-- )
	--===================================================================
	---- Types Of Services -----

	CREATE TABLE  dbo.TypesOfServices(
		ID		int			 not null primary key,
		[TypeID]	int			 not null,
		Name	nvarchar(255) not null,
		PriceID int			 not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_dboTypesOfServices_TypeID ON dbo.TypesOfServices
	-- (
	-- TypeID ASC
	-- )
	--===================================================================
	----  Source -----

	CREATE TABLE  dbo.Source(
		ID	 int		  not null primary key,
		[SourceID] int		  not null,
		Name nvarchar(100) not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_dboSource_SourceID ON dbo.Source
	-- (
	-- SourceID ASC
	-- )

		--=================================================================
		----  Status -----

	CREATE TABLE   dbo.Status(
		ID	 int		  not null primary key,
		[StatusID] int	  not null,
		[d_StatusID] int  not null,
		Name nvarchar(50) not null,
		Type nvarchar(50) not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_dboStatus_StatusID ON dbo.Status
	-- (
	-- StatusID ASC
	-- )

	--=================================================================
	------ Employee -----

	CREATE TABLE dbo.Employee(
		ID					int			 not null  primary key,
		[EmploeeID]			int			 not null ,
		DateStart			Datetime2 not null,
		DateEnd				Datetime2  null,
		JobID				int			 not null,
		EmailID				int			 not null,
		FirstName			nvarchar(50) not null,
		LastName			nvarchar(50) not null,
		SecondName			nvarchar(50) not null,
		Birhday				date		 not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_Employee_EmploeeID ON dbo.Employee
	-- (
	-- EmploeeID ASC
	-- )
	--=====================================================================
	------ Lead -----

	CREATE TABLE dbo.Lead(
		Lead_ID		int			not null primary key,
		DateCtreate datetime2	not null,
		CustomerID	int			not null,
		StatusID	int			not null,
		SourceID	int			not null,
		DLM			DATETIME2		not null 
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_Lead_Lead_ID ON dbo.Lead
	-- (
	-- Lead_ID ASC
	-- )
	--==================================================================================
	------ Deal -----

	CREATE TABLE dbo.Deal(
		Deal_ID		int			not null primary key,
		Lead_ID		int			not null,
		DateCreate datetime2	not null,
		DateClose	datetime2	null,
		TypeID		int			not null,
		StatusID	int			not null,
		EmploeeID	int			not null,
		DLM			DATETIME2		not null
	)

	--CREATE UNIQUE CLUSTERED INDEX IXС_Deal_Deal_ID ON dbo.Deal
	-- (
	-- Deal_ID ASC
	-- )
	CREATE NONCLUSTERED INDEX IXNС_Deal_Lead_ID 
	ON [dbo].[Deal] ([Lead_ID])
	INCLUDE ([DateCreate],[DateClose],[TypeID],[StatusID],[EmploeeID])
	

	--===================================================================================
	----- Calendar -----------

	CREATE TABLE  dbo.[CalendarDay] (
			[CreatedDate] date NOT NULL  primary key, 
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
			[Weekday] int NOT NULL,
			DLM			DATETIME2		not null
			)

	--CREATE UNIQUE CLUSTERED INDEX IXС_CalendarDay_CreatedDate ON dbo.[CalendarDay]
	-- (
	-- CreatedDate ASC
	-- )



END
