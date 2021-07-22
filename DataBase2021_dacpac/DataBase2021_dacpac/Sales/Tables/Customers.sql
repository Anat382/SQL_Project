CREATE TABLE [Sales].[Customers] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [DateCreate] DATETIME2 (7) NOT NULL,
    [FirstName]  NVARCHAR (50) NOT NULL,
    [LastName]   NVARCHAR (50) NOT NULL,
    [SecondName] NVARCHAR (50) NOT NULL,
    [BierthDay]  DATE          NOT NULL,
    [RegionID]   INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CHECK ([BierthDay]>=N'19600101' AND [BierthDay]<=dateadd(year,(-21),getdate())),
    FOREIGN KEY ([RegionID]) REFERENCES [Sales].[Region] ([ID])
);

