CREATE TABLE [Sales].[Price] (
    [ID]    INT          IDENTITY (1, 1) NOT NULL,
    [Price] DECIMAL (18) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CHECK ([Price]>=(1000) AND [Price]<=(50000))
);

