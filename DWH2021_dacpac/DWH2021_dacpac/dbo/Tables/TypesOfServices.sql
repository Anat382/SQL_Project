CREATE TABLE [dbo].[TypesOfServices] (
    [ID]      INT            NOT NULL,
    [TypeID]  INT            NOT NULL,
    [Name]    NVARCHAR (255) NOT NULL,
    [PriceID] INT            NOT NULL,
    [DLM]     DATETIME2 (7)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

