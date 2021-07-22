CREATE TABLE [Prod].[Employee] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [DateStart]  DATETIME2 (7) NOT NULL,
    [DateEnd]    DATETIME2 (7) NULL,
    [JobID]      INT           NOT NULL,
    [EmailID]    INT           NOT NULL,
    [FirstName]  NVARCHAR (50) NOT NULL,
    [LastName]   NVARCHAR (50) NOT NULL,
    [SecondName] NVARCHAR (50) NOT NULL,
    [Birhday]    DATE          NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([EmailID]) REFERENCES [Prod].[Email] ([ID]),
    FOREIGN KEY ([JobID]) REFERENCES [Prod].[Job] ([ID])
);

