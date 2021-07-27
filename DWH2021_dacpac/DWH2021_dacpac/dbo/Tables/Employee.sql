CREATE TABLE [dbo].[Employee] (
    [ID]         INT           NOT NULL,
    [EmploeeID]  INT           NOT NULL,
    [DateStart]  DATETIME2 (7) NOT NULL,
    [DateEnd]    DATETIME2 (7) NULL,
    [JobID]      INT           NOT NULL,
    [EmailID]    INT           NOT NULL,
    [FirstName]  NVARCHAR (50) NOT NULL,
    [LastName]   NVARCHAR (50) NOT NULL,
    [SecondName] NVARCHAR (50) NOT NULL,
    [Birhday]    DATE          NOT NULL,
    [DLM]        DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK] PRIMARY KEY CLUSTERED ([ID] ASC)
);



