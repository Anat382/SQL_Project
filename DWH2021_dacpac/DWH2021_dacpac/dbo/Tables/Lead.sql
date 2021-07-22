CREATE TABLE [dbo].[Lead] (
    [Lead_ID]     INT           NOT NULL,
    [DateCtreate] DATETIME2 (7) NOT NULL,
    [CustomerID]  INT           NOT NULL,
    [StatusID]    INT           NOT NULL,
    [SourceID]    INT           NOT NULL,
    [DLM]         DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([Lead_ID] ASC)
);

