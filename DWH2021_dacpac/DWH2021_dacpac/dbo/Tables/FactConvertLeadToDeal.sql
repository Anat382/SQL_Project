CREATE TABLE [dbo].[FactConvertLeadToDeal] (
    [Lead_ID]         INT          NOT NULL,
    [CreatedDate]     DATE         NULL,
    [CustomerID]      INT          NOT NULL,
    [RegionID]        INT          NULL,
    [StatusID]        INT          NOT NULL,
    [SourceID]        INT          NOT NULL,
    [Deal_ID]         INT          NULL,
    [Deal_DateCreate] DATE         NULL,
    [Deal_DateClose]  DATE         NULL,
    [TypeID]          INT          NULL,
    [Price]           DECIMAL (18) NULL,
    [d_StatusID]      INT          NULL,
    [EmploeeID]       INT          NULL,
    [EmailID]         INT          NULL,
    [JobID]           INT          NULL,
    [DLM]             DATETIME     NOT NULL,
    FOREIGN KEY ([CreatedDate]) REFERENCES [dbo].[CalendarDay] ([CreatedDate]),
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID]),
    FOREIGN KEY ([d_StatusID]) REFERENCES [dbo].[Status] ([ID]),
    FOREIGN KEY ([EmailID]) REFERENCES [dbo].[Email] ([ID]),
    FOREIGN KEY ([EmploeeID]) REFERENCES [dbo].[Employee] ([ID]),
    FOREIGN KEY ([JobID]) REFERENCES [dbo].[Job] ([ID]),
    FOREIGN KEY ([RegionID]) REFERENCES [dbo].[Region] ([ID]),
    FOREIGN KEY ([SourceID]) REFERENCES [dbo].[Source] ([ID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[Status] ([ID]),
    FOREIGN KEY ([TypeID]) REFERENCES [dbo].[TypesOfServices] ([ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [IXС_FactConvertLeadToDeal_Lead_ID_Deal_ID]
    ON [dbo].[FactConvertLeadToDeal]([Lead_ID] ASC, [Deal_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IXNС_FactConvertLeadToDeal_CreatedDate]
    ON [dbo].[FactConvertLeadToDeal]([CreatedDate] ASC)
    INCLUDE([Lead_ID], [CustomerID], [RegionID], [StatusID], [SourceID], [Deal_ID], [Deal_DateCreate], [Deal_DateClose], [TypeID], [Price], [d_StatusID], [EmploeeID], [EmailID], [JobID], [DLM]);

