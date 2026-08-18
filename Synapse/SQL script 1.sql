CREATE VIEW dbo.v_revenue_by_sector AS
SELECT * FROM OPENROWSET(
    BULK 'https://azureuaenorthst0811.blob.core.windows.net/gold/revenue_by_sector/part-00000-tid-2750919572875262238-806ff7ba-bb5b-4de0-86cb-40be67405724-139-1-c000.csv',
    FORMAT = 'CSV', PARSER_VERSION = '2.0', HEADER_ROW = TRUE
) AS rows;

SELECT * FROM dbo.v_revenue_by_sector;

CREATE VIEW dbo.v_revenue_by_location AS
SELECT * FROM OPENROWSET(
    BULK 'https://azureuaenorthst0811.blob.core.windows.net/gold/revenue_by_location/part-00000-tid-1898414183286108739-4957336f-61c8-4c11-a9e2-b1794bd438fa-155-1-c000.csv',
    FORMAT = 'CSV', PARSER_VERSION = '2.0', HEADER_ROW = TRUE
) AS rows;

SELECT * FROM dbo.v_revenue_by_location;


CREATE VIEW dbo.v_sales_by_month AS
SELECT * FROM OPENROWSET(
    BULK 'https://azureuaenorthst0811.blob.core.windows.net/gold/sales_by_month/part-00000-tid-265394392404934688-78ac3c3e-a769-41a3-b1f2-293f4424e13d-147-1-c000.csv',
    FORMAT = 'CSV', PARSER_VERSION = '2.0', HEADER_ROW = TRUE
) AS rows;

CREATE VIEW dbo.v_top_products AS
SELECT * FROM OPENROWSET(
    BULK 'https://azureuaenorthst0811.blob.core.windows.net/gold/top_products/part-00000-tid-6375315598163874067-ac90eb4e-2b05-4377-bd2a-dab0256c9dac-151-1-c000.csv',
    FORMAT = 'CSV', PARSER_VERSION = '2.0', HEADER_ROW = TRUE
) AS rows;

CREATE VIEW dbo.v_win_rate_by_agent AS
SELECT * FROM OPENROWSET(
    BULK 'https://azureuaenorthst0811.blob.core.windows.net/gold/win_rate_by_agent/part-00000-tid-401728557843735985-39379811-9a81-4026-bad3-ff3782c25040-143-1-c000.csv',
    FORMAT = 'CSV', PARSER_VERSION = '2.0', HEADER_ROW = TRUE
) AS rows;

SELECT * from dbo.v_revenue_by_sector

SELECT * FROM sys.views WHERE schema_id = SCHEMA_ID('dbo');