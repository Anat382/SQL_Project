CREATE TABLE [Sales].[Lead] (
    [Lead_ID]     INT           IDENTITY (1, 1) NOT NULL,
    [DateCtreate] DATETIME2 (7) NOT NULL,
    [CustomerID]  INT           NOT NULL,
    [StatusID]    INT           NOT NULL,
    [SourceID]    INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Lead_ID] ASC),
    FOREIGN KEY ([CustomerID]) REFERENCES [Sales].[Customers] ([ID]),
    FOREIGN KEY ([SourceID]) REFERENCES [Sales].[Source] ([ID]),
    FOREIGN KEY ([StatusID]) REFERENCES [Prod].[Status] ([ID])
);

