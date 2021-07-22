CREATE TABLE [dbo].[Lead] (
    [Lead_ID]            INT           NOT NULL,
    [UID]                INT           NOT NULL,
    [DATE_CREATE]        DATETIME2 (7) NULL,
    [Date]               DATETIME2 (7) NULL,
    [CONTACT_ID]         INT           NULL,
    [STATUS_ID]          INT           NULL,
    [SourceID]           INT           NULL,
    [BudgetCalc]         NVARCHAR (50) NULL,
    [LeadReject]         NVARCHAR (50) NULL,
    [LeadConvertConsalt] NVARCHAR (50) NULL,
    [ConsaltFact]        NVARCHAR (50) NULL,
    [RegistrationDeal]   NVARCHAR (50) NULL,
    [PaymentDeal]        NVARCHAR (50) NULL
);

