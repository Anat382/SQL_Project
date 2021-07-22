CREATE TABLE [dbo].[CalendarDay] (
    [CreatedDate] DATE          NOT NULL,
    [SatrtMonth]  DATE          NOT NULL,
    [EndMonth]    DATE          NOT NULL,
    [Year]        INT           NOT NULL,
    [Month]       INT           NOT NULL,
    [Day]         INT           NOT NULL,
    [MonthReport] NVARCHAR (10) NOT NULL,
    [MonthName]   NVARCHAR (10) NOT NULL,
    [Quarter]     INT           NOT NULL,
    [Dayofyear]   INT           NOT NULL,
    [Week]        INT           NOT NULL,
    [Weekday]     INT           NOT NULL,
    [DLM]         DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([CreatedDate] ASC)
);

