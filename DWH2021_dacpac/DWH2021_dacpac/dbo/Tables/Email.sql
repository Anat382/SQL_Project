CREATE TABLE [dbo].[Email] (
    [ID]      INT           NOT NULL,
    [EmailID] INT           NOT NULL,
    [Name]    NVARCHAR (50) NOT NULL,
    [DLM]     DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

