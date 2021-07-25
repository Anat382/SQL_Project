SET  STATISTICS IO, TIME ON
	
	SELECT * INTO [dbo].[DealTestIndex] FROM [dbo].[Deal]
	SELECT * INTO [dbo].[LeadTestIndex] FROM [dbo].[Lead]	


 SELECT
	l.[Lead_ID]
	,CAST(l.[DateCtreate] as DATE) as [CreatedDate]
	,l.[CustomerID]
	,c.RegionID
	,l.[StatusID]
	,l.[SourceID]
	,d.[Deal_ID]
	,CAST(d.[DateCreate]  as DATE) as [Deal_DateCreate]
	,CAST(d.[DateClose]  as DATE) as [Deal_DateClose]
	,d.[TypeID]
	,p.Price
	,d.[StatusID] as [d_StatusID]
	,d.[EmploeeID]
	,e.EmailID
	,e.JobID
	,GETDATE() as DLM
 FROM [dbo].[Lead] l -- WITH ( INDEX( [IXNС_Lead_DateCtreate]) )  --- не эффективно 
 LEFT HASH JOIN [dbo].[Deal] d   on l.Lead_ID=d.Lead_ID   -- Добавляем HASH, так же результат даёт MERGE
 LEFT  JOIN [dbo].[Customers] c on c.ID=l.CustomerID
 LEFT JOIN [dbo].[Employee] e on e.ID=d.[EmploeeID]
 LEFT JOIN 	[dbo].[TypesOfServices] t on t.ID=d.[TypeID]
 LEFT JOIN 	[dbo].[Price] p on p.ID=t.PriceID
WHERE l.[DateCtreate] >= N'20200101' -- убираем функции в условиях
--OPTION (FORCE ORDER);
--OPTION (MAXDOP 10)

 SELECT
	l.[Lead_ID]
	,CAST(l.[DateCtreate] as DATE) as [CreatedDate]
	,l.[CustomerID]
	,c.RegionID
	,l.[StatusID]
	,l.[SourceID]
	,d.[Deal_ID]
	,CAST(d.[DateCreate]  as DATE) as [Deal_DateCreate]
	,CAST(d.[DateClose]  as DATE) as [Deal_DateClose]
	,d.[TypeID]
	,p.Price
	,d.[StatusID] as [d_StatusID]
	,d.[EmploeeID]
	,e.EmailID
	,e.JobID
	,GETDATE() as DLM
 FROM [dbo].[LeadTestIndex] l
 LEFT JOIN [dbo].[DealTestIndex] d on l.Lead_ID=d.Lead_ID
 LEFT JOIN [dbo].[Customers] c on c.ID=l.CustomerID
 LEFT JOIN [dbo].[Employee] e on e.ID=d.[EmploeeID]
 LEFT JOIN 	[dbo].[TypesOfServices] t on t.ID=d.[TypeID]
 LEFT JOIN 	[dbo].[Price] p on p.ID=t.PriceID
WHERE CAST( l.[DateCtreate] as date) >= N'20200101'


