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
    CONSTRAINT [FK_FactConvertLeadToDeal_CreatedDate] FOREIGN KEY ([CreatedDate]) REFERENCES [dbo].[CalendarDay] ([CreatedDate]),
    CONSTRAINT [FK_FactConvertLeadToDeal_CustomerID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_d_StatusID] FOREIGN KEY ([d_StatusID]) REFERENCES [dbo].[Status] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_EmailID] FOREIGN KEY ([EmailID]) REFERENCES [dbo].[Email] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_EmploeeID] FOREIGN KEY ([EmploeeID]) REFERENCES [dbo].[Employee] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_JobID] FOREIGN KEY ([JobID]) REFERENCES [dbo].[Job] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_RegionID] FOREIGN KEY ([RegionID]) REFERENCES [dbo].[Region] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_SourceID] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[Source] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_StatusID] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[Status] ([ID]),
    CONSTRAINT [FK_FactConvertLeadToDeal_TypeID] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[TypesOfServices] ([ID])
);




GO
CREATE UNIQUE CLUSTERED INDEX [IXС_FactConvertLeadToDeal_Lead_ID_Deal_ID]
    ON [dbo].[FactConvertLeadToDeal]([Lead_ID] ASC, [Deal_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IXNС_FactConvertLeadToDeal_CreatedDate]
    ON [dbo].[FactConvertLeadToDeal]([CreatedDate] ASC)
    INCLUDE([Lead_ID], [CustomerID], [RegionID], [StatusID], [SourceID], [Deal_ID], [Deal_DateCreate], [Deal_DateClose], [TypeID], [Price], [d_StatusID], [EmploeeID], [EmailID], [JobID], [DLM]);


GO
GRANT UPDATE
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_54]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_52]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [ManagerUser]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_54]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_52]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [ManagerUser]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_54]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_52]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [ManagerUser]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_54]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [Менеджер_52]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[FactConvertLeadToDeal] TO [ManagerUser]
    AS [dbo];

