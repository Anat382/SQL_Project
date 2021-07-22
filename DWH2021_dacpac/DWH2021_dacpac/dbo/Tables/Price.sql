CREATE TABLE [dbo].[Price] (
    [ID]      INT           NOT NULL,
    [PriceID] INT           NOT NULL,
    [Price]   DECIMAL (18)  NOT NULL,
    [DLM]     DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

