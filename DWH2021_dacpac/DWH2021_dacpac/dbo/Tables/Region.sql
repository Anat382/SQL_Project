CREATE TABLE [dbo].[Region] (
    [ID]       INT            NOT NULL,
    [RegionID] INT            NOT NULL,
    [Name]     NVARCHAR (100) NOT NULL,
    [DLM]      DATETIME2 (7)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

