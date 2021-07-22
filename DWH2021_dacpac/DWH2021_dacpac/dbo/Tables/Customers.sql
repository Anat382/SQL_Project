CREATE TABLE [dbo].[Customers] (
    [ID]         INT           NOT NULL,
    [CustomerID] INT           NOT NULL,
    [DateCreate] DATETIME2 (7) NOT NULL,
    [FirstName]  NVARCHAR (50) NOT NULL,
    [LastName]   NVARCHAR (50) NOT NULL,
    [SecondName] NVARCHAR (50) NOT NULL,
    [BierthDay]  DATE          NOT NULL,
    [RegionID]   INT           NOT NULL,
    [DLM]        DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

