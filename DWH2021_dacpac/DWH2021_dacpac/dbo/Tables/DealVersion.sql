CREATE TABLE [dbo].[DealVersion] (
    [Deal_ID]    INT                                         NOT NULL,
    [Lead_ID]    INT                                         NOT NULL,
    [DateCreate] DATETIME2 (7)                               NOT NULL,
    [DateClose]  DATETIME2 (7)                               NULL,
    [TypeID]     INT                                         NOT NULL,
    [StatusID]   INT                                         NOT NULL,
    [EmploeeID]  INT                                         NOT NULL,
    [DLM]        DATETIME2 (7)                               NOT NULL,
    [StartTime]  DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [EndTime]    DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PRIMARY KEY CLUSTERED ([Deal_ID] ASC),
    PERIOD FOR SYSTEM_TIME ([StartTime], [EndTime])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[sch_1].[DealVersion], DATA_CONSISTENCY_CHECK=ON));

