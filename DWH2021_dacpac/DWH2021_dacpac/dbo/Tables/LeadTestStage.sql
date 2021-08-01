CREATE TABLE [dbo].[LeadTestStage] (
    [Lead_ID]     INT           NOT NULL,
    [DateCtreate] DATETIME2 (7) NOT NULL,
    [CustomerID]  INT           NOT NULL,
    [StatusID]    INT           NOT NULL,
    [SourceID]    INT           NOT NULL,
    [DLM]         DATETIME2 (7) NOT NULL,
    [DateReport]  DATE          NOT NULL,
    CONSTRAINT [PK_LeadTestStage] PRIMARY KEY CLUSTERED ([Lead_ID] ASC, [DateReport] ASC) ON [schmMonthPartition] ([DateReport])
) ON [schmMonthPartition] ([DateReport]);

