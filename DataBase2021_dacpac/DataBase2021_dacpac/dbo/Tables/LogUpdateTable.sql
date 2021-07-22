CREATE TABLE [dbo].[LogUpdateTable] (
    [ID]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [NameTable] NVARCHAR (50) NOT NULL,
    [UpdateRow] INT           NOT NULL,
    [InsertRow] INT           NOT NULL,
    [DateOper]  DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

