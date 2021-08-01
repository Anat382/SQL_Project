CREATE PARTITION SCHEME [schmMonthPartition]
    AS PARTITION [fnMonthPartition]
    TO ([MonthData], [MonthData], [MonthData], [MonthData], [MonthData], [MonthData], [MonthData], [MonthData], [MonthData], [MonthData]);

