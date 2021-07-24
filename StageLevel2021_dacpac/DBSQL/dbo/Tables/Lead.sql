CREATE TABLE [dbo].[Lead](
	[Lead_ID] [int] NOT NULL,
	[UID] [int] NOT NULL,
	[DATE_CREATE] [datetime2](7) NULL,
	[Date] [datetime2](7) NULL,
	[CONTACT_ID] [int] NULL,
	[STATUS_ID] [int] NULL,
	[SourceID] [int] NULL,
	[BudgetCalc] [nvarchar](50) NULL,
	[LeadReject] [nvarchar](50) NULL,
	[LeadConvertConsalt] [nvarchar](50) NULL,
	[ConsaltFact] [nvarchar](50) NULL,
	[RegistrationDeal] [nvarchar](50) NULL,
	[PaymentDeal] [nvarchar](50) NULL
) ON [PRIMARY]

