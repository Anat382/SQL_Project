CREATE TABLE [sch_1].[DealVersion] (
    [Deal_ID]    INT           NOT NULL,
    [Lead_ID]    INT           NOT NULL,
    [DateCreate] DATETIME2 (7) NOT NULL,
    [DateClose]  DATETIME2 (7) NULL,
    [TypeID]     INT           NOT NULL,
    [StatusID]   INT           NOT NULL,
    [EmploeeID]  INT           NOT NULL,
    [DLM]        DATETIME2 (7) NOT NULL,
    [StartTime]  DATETIME2 (7) NOT NULL,
    [EndTime]    DATETIME2 (7) NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_DealVersion]
    ON [sch_1].[DealVersion]([EndTime] ASC, [StartTime] ASC) WITH (DATA_COMPRESSION = PAGE);

