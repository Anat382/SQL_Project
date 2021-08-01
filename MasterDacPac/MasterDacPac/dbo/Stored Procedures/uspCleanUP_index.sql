

CREATE PROCEDURE  [dbo].[uspCleanUP_index]
AS
BEGIN
	SET ANSI_WARNINGS ON; 
    SET NOCOUNT ON;

---- Объявляем переменные
DECLARE @tt TABLE (ID INT IDENTITY, NAME NVARCHAR(50))
DECLARE @n int, @db NVARCHAR(50), @nc int, @text NVARCHAR(MAX), @text_conf NVARCHAR(MAX)
DECLARE @n2 INT, @indc float, @nc2 int, @text2 NVARCHAR(MAX), @text_conf2 NVARCHAR(MAX), @tab_name NVARCHAR(50), @pr float, @schemaname NVARCHAR(50), @defrag NVARCHAR(MAX), @createdb NVARCHAR(MAX)

---- Исключаем БД которые не нужно обслуживать (при проявлении новой БД автоматически включается в обслуживание)
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
		
		---- Заполняем таблицу индексами с фрагментацией более 5 ед.
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

			---- Делаем обслуживание индексов в зависимости от уровня фрагментации (у меня отработало не на всех индексах)
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

	---- Заполняем таблицу с индексами и степенью фрагментации с датой и временем проведения обслуживания
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


---- Альтернативынй метод используя курсор
--DECLARE @database_id AS int;
--DECLARE @Schema AS VARCHAR(100);
--DECLARE @index_name nvarchar(200);
--DECLARE @table_name nvarchar(200);
--DECLARE @defrag nvarchar(200);
--DECLARE @persent AS float;
----USE ВПИСАТЬ ИМЯ ДБ!;
----SET @Schema = 'ВПИСАТЬ ИМЯ СХЕМЫ!';
--SET @persent = 0.1;
--SET QUOTED_IDENTIFIER ON
--SELECT @database_id = db_id()
--declare dirty_index_cursor cursor for
--SELECT i.name AS [index],
--       @Schema + '.[' + tbl.name + ']' AS [table],
--       fi.avg_fragmentation_in_percent
----       ,CAST(CASE i.index_id WHEN 1 THEN 1 ELSE 0 END AS bit) AS [IsClustered]
----       ,i.is_unique AS [IsUnique]
--FROM sys.indexes AS i
--   INNER JOIN sys.tables AS tbl ON  (i.object_id=tbl.object_id)
--   INNER JOIN sys.dm_db_index_physical_stats(@database_id, NULL, NULL, NULL, 'LIMITED') AS fi ON fi.object_id=CAST(i.object_id AS int)
--              AND fi.index_id=CAST(i.index_id AS int)
--WHERE (i.index_id > 0 and i.is_hypothetical = 0)
--      AND SCHEMA_NAME(tbl.schema_id)=@Schema
--      AND fi.avg_fragmentation_in_percent > @persent
--ORDER BY tbl.name
--open dirty_index_cursor;
--fetch next from dirty_index_cursor into @index_name, @table_name, @defrag;
--	while @@FETCH_STATUS = 0 begin
--	   print 'DEFRAG = ' + @defrag + ' | ' + @index_name + ' on table ' + @table_name
--	   exec( 'ALTER INDEX [' + @index_name + '] ON ' + @table_name +
--			 ' REBUILD WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ' +
--			 'ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ' +
--			 'SORT_IN_TEMPDB = OFF, ONLINE = OFF )' );
--	   fetch next from dirty_index_cursor into @index_name, @table_name, @defrag;
--	end
--close dirty_index_cursor;
--deallocate dirty_index_cursor;




END
