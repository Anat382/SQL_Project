CREATE TABLE [dbo].[Deal] (
    [Deal_ID]    INT           NOT NULL,
    [Lead_ID]    INT           NOT NULL,
    [DateCreate] DATETIME2 (7) NOT NULL,
    [DateClose]  DATETIME2 (7) NULL,
    [TypeID]     INT           NOT NULL,
    [StatusID]   INT           NOT NULL,
    [EmploeeID]  INT           NOT NULL,
    [DLM]        DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([Deal_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IXNС_Deal_Lead_ID]
    ON [dbo].[Deal]([Lead_ID] ASC)
    INCLUDE([DateCreate], [DateClose], [TypeID], [StatusID], [EmploeeID]);

