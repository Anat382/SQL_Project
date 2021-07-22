CREATE TABLE [Sales].[TypesOfServices] (
    [ID]      INT            IDENTITY (1, 1) NOT NULL,
    [Name]    NVARCHAR (255) NOT NULL,
    [PriceID] INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([PriceID]) REFERENCES [Sales].[Price] ([ID])
);

