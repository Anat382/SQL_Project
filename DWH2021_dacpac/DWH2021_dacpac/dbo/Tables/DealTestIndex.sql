CREATE TABLE [dbo].[DealTestIndex] (
    [Deal_ID]    INT           NOT NULL,
    [Lead_ID]    INT           NOT NULL,
    [DateCreate] DATETIME2 (7) NOT NULL,
    [DateClose]  DATETIME2 (7) NULL,
    [TypeID]     INT           NOT NULL,
    [StatusID]   INT           NOT NULL,
    [EmploeeID]  INT           NOT NULL,
    [DLM]        DATETIME2 (7) NOT NULL
);

