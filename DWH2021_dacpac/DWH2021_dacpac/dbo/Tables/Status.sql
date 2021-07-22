CREATE TABLE [dbo].[Status] (
    [ID]         INT           NOT NULL,
    [StatusID]   INT           NOT NULL,
    [d_StatusID] INT           NOT NULL,
    [Name]       NVARCHAR (50) NOT NULL,
    [Type]       NVARCHAR (50) NOT NULL,
    [DLM]        DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

