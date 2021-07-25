CREATE TABLE [dbo].[Log_index_defragmentation] (
    [dbname]        [sysname]      NULL,
    [database_id]   SMALLINT       NULL,
    [Object Name]   NVARCHAR (128) NULL,
    [Index Name]    [sysname]      NULL,
    [type_desc]     NVARCHAR (60)  NULL,
    [Fragmentation] FLOAT (53)     NULL,
    [Pages]         BIGINT         NULL,
    [Page Density]  FLOAT (53)     NULL,
    [DLM]           DATETIME       NOT NULL
);

