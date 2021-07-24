CREATE TABLE [dbo].[Deal](
	[UID] [int] NOT NULL,
	[Deal_ID] [int] NOT NULL,
	[LEAD_ID] [nvarchar](50) NOT NULL,
	[CONTACT_ID] [int] NOT NULL,
	[DATE_CREATE] [nvarchar](50) NULL,
	[Date] [nvarchar](50) NULL,
	[DateClose] [nvarchar](50) NULL,
	[TypeProdact] [int] NULL,
	[StatusID] [int] NULL,
	[ConsaltStart] [nvarchar](50) NULL,
	[ConsaltFact] [nvarchar](50) NULL,
	[CREATED_DATE_TASK] [nvarchar](50) NULL,
	[CLOSED_DATE_TASK] [nvarchar](50) NULL,
	[RegistrationDeal] [nvarchar](50) NULL,
	[PaymentDeal] [nvarchar](50) NULL,
	[PriceProdact] [nvarchar](50) NULL
) ON [PRIMARY]

