CREATE TABLE [dbo].[Job] (
    [ID]    INT           NOT NULL,
    [JobID] INT           NOT NULL,
    [Name]  NVARCHAR (50) NOT NULL,
    [DLM]   DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

