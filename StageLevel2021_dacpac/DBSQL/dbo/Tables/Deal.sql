CREATE TABLE [dbo].[Deal] (
    [UID]               INT           NOT NULL,
    [Deal_ID]           INT           NOT NULL,
    [LEAD_ID]           NVARCHAR (50) NOT NULL,
    [CONTACT_ID]        INT           NOT NULL,
    [DATE_CREATE]       NVARCHAR (50) NULL,
    [Date]              NVARCHAR (50) NULL,
    [DateClose]         NVARCHAR (50) NULL,
    [TypeProdact]       INT           NULL,
    [StatusID]          INT           NULL,
    [ConsaltStart]      NVARCHAR (50) NULL,
    [ConsaltFact]       NVARCHAR (50) NULL,
    [CREATED_DATE_TASK] NVARCHAR (50) NULL,
    [CLOSED_DATE_TASK]  NVARCHAR (50) NULL,
    [RegistrationDeal]  NVARCHAR (50) NULL,
    [PaymentDeal]       NVARCHAR (50) NULL,
    [PriceProdact]      NVARCHAR (50) NULL
);

