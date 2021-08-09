CREATE TABLE [dbo].[Deal] (
    [Deal_ID]    INT           NOT NULL,
    [Lead_ID]    INT           NOT NULL,
    [DateCreate] DATETIME2 (7) NOT NULL,
    [DateClose]  DATETIME2 (7) NULL,
    [TypeID]     INT           NOT NULL,
    [StatusID]   INT           NOT NULL,
    [EmploeeID]  INT           NOT NULL,
    [DLM]        DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([Deal_ID] ASC)
);








GO
CREATE NONCLUSTERED INDEX [IXNС_Deal_Lead_ID]
    ON [dbo].[Deal]([Lead_ID] ASC)
    INCLUDE([DateCreate], [DateClose], [TypeID], [StatusID], [EmploeeID]);


GO



CREATE TRIGGER TRG_Merge_DealVersion ON [dbo].[Deal]
	AFTER INSERT, UPDATE, DELETE
	AS
	BEGIN
		DECLARE @SQL_Command VARCHAR(100);
		/*
		Определяем, что это за операция
		на основе наличия записей в таблицах inserted и deleted.
		На практике, конечно же, лучше делать отдельный триггер для каждой операции
		*/
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) 
			SET @SQL_Command = 'INSERT'
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
			SET @SQL_Command = 'UPDATE'
		IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
			SET @SQL_Command = 'DELETE'
		-- Инструкция если происходит добавление или обновление записи
		IF @SQL_Command = 'UPDATE' OR @SQL_Command = 'INSERT'
			BEGIN
				MERGE [dbo].[DealVersion] AS T_Base
					USING (
						SELECT 
						[Deal_ID]
					  ,[Lead_ID]
					  ,[DateCreate]
					  ,[DateClose]
					  ,[TypeID]
					  ,[StatusID]
					  ,[EmploeeID]
					  ,[DLM]			
						FROM  [dbo].[Deal]
						) AS T_Source
						ON (T_Base.[Deal_ID] = T_Source.[Deal_ID]
							AND T_Base.[Lead_ID] = T_Source.[Lead_ID]
						)
					WHEN MATCHED THEN
					UPDATE 
						SET T_Base.[DateCreate]	 = 	T_Source.[DateCreate]
						,T_Base.[DateClose]		 = 	T_Source.[DateClose]
						,T_Base.[TypeID]		 = 	T_Source.[TypeID]
						,T_Base.[StatusID]		 = 	T_Source.[StatusID]
						,T_Base.[EmploeeID]		 = 	T_Source.[EmploeeID]
						,T_Base.[DLM]			 = 	T_Source.[DLM]

					WHEN NOT MATCHED THEN
					INSERT (
							[Deal_ID]
							,[Lead_ID]
							,[DateCreate]
							,[DateClose]
							,[TypeID]
							,[StatusID]
							,[EmploeeID]
							,[DLM]	
						)
					VALUES (
							[Deal_ID]
							,[Lead_ID]
							,[DateCreate]
							,[DateClose]
							,[TypeID]
							,[StatusID]
							,[EmploeeID]
							,[DLM]
					);
				END
	END