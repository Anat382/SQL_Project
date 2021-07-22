CREATE TABLE [Sales].[Deal] (
    [Deal_ID]    INT           IDENTITY (1, 1) NOT NULL,
    [Lead_ID]    INT           NOT NULL,
    [DateCreate] DATETIME2 (7) NOT NULL,
    [DateClose]  DATETIME2 (7) NULL,
    [TypeID]     INT           NOT NULL,
    [StatusID]   INT           NOT NULL,
    [EmploeeID]  INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Deal_ID] ASC),
    FOREIGN KEY ([EmploeeID]) REFERENCES [Prod].[Employee] ([ID]),
    FOREIGN KEY ([Lead_ID]) REFERENCES [Sales].[Lead] ([Lead_ID]),
    FOREIGN KEY ([StatusID]) REFERENCES [Prod].[Status] ([ID]),
    FOREIGN KEY ([TypeID]) REFERENCES [Sales].[TypesOfServices] ([ID])
);

