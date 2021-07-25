


CREATE PROCEDURE  [dbo].[uspCleanUP_index]
AS
BEGIN
	SET ANSI_WARNINGS ON; 
    SET NOCOUNT ON;


DECLARE @tt TABLE (ID INT IDENTITY, NAME NVARCHAR(50))
DECLARE @n int, @db NVARCHAR(50), @nc int, @text NVARCHAR(MAX), @text_conf NVARCHAR(MAX)
DECLARE @n2 INT, @indc float, @nc2 int, @text2 NVARCHAR(MAX), @text_conf2 NVARCHAR(MAX), @tab_name NVARCHAR(50), @pr float, @schemaname NVARCHAR(50), @defrag NVARCHAR(MAX), @createdb NVARCHAR(MAX)


INSERT INTO @tt
SELECT  name FROm sys.databases
WHERE NAME NOT IN ('SSISDB','master','tempdb','model','msdb', 'AdventureWorks2017', 'WideWorldImporters')

SELECT * FROM @tt
SELECT @n = COUNT(*) FROM @tt
SET @nc = 1

CREATE TABLE #td (
	ID INT,
	[NameDB] NVARCHAR(50) NULL,
	[schema_name] NVARCHAR(50) NULL,
	[table_name] [sysname] NULL,
	[index_id] [int] NULL,
	[name] [sysname] NULL,
	[avg_fragmentation_in_percent] [float] NULL
)

WHILE @nc <= @n
	BEGIN 
		SET @db = (SELECT NAME FROM @tt WHERE ID = @nc)
		SET @text = 			
			'use ' + @db + ';' + 
				'
				INSERT INTO #td
					SELECT ' + 'ROW_NUMBER() OVER(PARTITION BY ' + '''' + @db + '''' + ' ORDER BY t.name )' + ' as [ID], ' + '''' + @db + ''''  +    ' as [NameDB], s.name as [schema_name], t.name as [table_name], a.index_id, b.name, avg_fragmentation_in_percent 
					FROM sys.dm_db_index_physical_stats (DB_ID(N'''+ @db + '''), NULL, NULL, NULL, NULL) AS a  
					JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id   
					LEFT JOIN sys.tables t on t.object_id=a.object_id
					LEFT JOIN sys.schemas s on s.schema_id=t.schema_id
					WHERE avg_fragmentation_in_percent > 5.0
						AND b.name IS NOT NULL
					'
		
		EXEC sp_sqlexec @text 
		
		SELECT @n2 = COUNT(*)  FROM #td WHERE [NameDB] = @db
		SELECT @n2

		SET @nc2 = 1  
		SET  @pr = 30.0

		IF EXISTS ( SELECT *  FROM #td WHERE [NameDB] = @db )

			WHILE @nc2 <= @n2
				BEGIN
					SET @indc = (SELECT avg_fragmentation_in_percent FROM #td WHERE [NameDB] = @db AND ID = @nc2 )
					SET @text2 = (SELECT name FROM #td WHERE [NameDB] = @db AND ID = @nc2 )
					SET @tab_name = (SELECT [table_name] FROM #td WHERE [NameDB] = @db AND ID = @nc2 )
					SET @schemaname = (SELECT [schema_name] FROM #td WHERE [NameDB] = @db AND ID = @nc2 )

					SET @text_conf2 =				
						'use ' + @db + ';' + ' IF ' + CAST(@indc as varchar) + ' < ' + CAST( @pr as varchar) 
							+ ' ALTER INDEX ' +   @text2 + ' ON ' + CONCAT(@schemaname,'.',@tab_name) + ' REORGANIZE'
						+ ' ELSE'
							+ ' ALTER INDEX ' +   @text2 + ' ON ' +  CONCAT(@schemaname,'.',@tab_name)  + ' REBUILD;'
		
					SELECT @text_conf2 --@text_conf2
						
					EXEC sp_sqlexec @text_conf2; 

					SET @nc2 = @nc2 + 1
				END;
		
		SET @nc2 = 0
		SET @nc = @nc + 1

			---- Смотрим фрагментацию
		SET	@createdb =
			'use ' + @db + '; ' + 
			--'DROP TABLE IF EXISTS [dbo].[Log_index_defragmentation] ' +
			'IF OBJECT_ID(''dbo.Log_index_defragmentation'' ) IS NULL ' +
			'CREATE TABLE [dbo].[Log_index_defragmentation](
				[dbname] [sysname] NULL,
				[database_id] [smallint] NULL,
				[Object Name] [nvarchar](128) NULL,
				[Index Name] [sysname] NULL,
				[type_desc] [nvarchar](60) NULL,
				[Fragmentation] [float] NULL,
				[Pages] [bigint] NULL,
				[Page Density] [float] NULL,
				[DLM] [datetime] NOT NULL
			);'	

		SET @defrag = 
			'use ' + @db + '; ' + 
			'INSERT INTO dbo.Log_index_defragmentation ' +
			'SELECT
				db_name() as [dbname],
				database_id,
				OBJECT_NAME (ips.[object_id]) AS [Object Name],
				si.name AS [Index Name],
				type_desc,
				ROUND (ips.avg_fragmentation_in_percent, 2) AS [Fragmentation],
				ips.page_count AS [Pages],
				ROUND (ips.avg_page_space_used_in_percent, 2) AS [Page Density],
				GETDATE() as [DLM]
			FROM sys.dm_db_index_physical_stats (DB_ID ('''+ @db + '''), NULL, NULL, NULL, ''DETAILED'') ips
			CROSS APPLY sys.indexes si
			WHERE
			   si.object_id = ips.object_id
			   AND si.index_id = ips.index_id
			   AND ips.index_level = 0;'
		
		EXEC sp_sqlexec @createdb
		EXEC sp_sqlexec @defrag
	END

END
