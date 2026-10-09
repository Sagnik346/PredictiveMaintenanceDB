use PredictiveMaintenanceDB

select*from Machines
select *from Products
select * from Customers
select * from Orders
select * from Production
select * from Energy_Usage
select * from Maintenance
select * from Production_Cost
select * from inventory
select * from Sales

SELECT 'Customers' AS TableName, COUNT(*) AS Row_Count FROM Customers
UNION ALL
SELECT 'Energy_Usage', COUNT(*) FROM Energy_Usage
UNION ALL
SELECT 'Inventory', COUNT(*) FROM Inventory
UNION ALL
SELECT 'Machines', COUNT(*) FROM Machines
UNION ALL
SELECT 'Maintenance', COUNT(*) FROM Maintenance
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Production', COUNT(*) FROM Production
UNION ALL
SELECT 'Production_Cost', COUNT(*) FROM Production_Cost
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Sales', COUNT(*) FROM Sales;

SELECT
    tc.TABLE_NAME,
    kcu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY tc.TABLE_NAME;



ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (Customer_ID)
REFERENCES Customers(Customer_ID);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Products
FOREIGN KEY (Product_ID)
REFERENCES Products(Product_ID);

ALTER TABLE Production
ADD CONSTRAINT FK_Production_Product
FOREIGN KEY (Product_ID)
REFERENCES Products(Product_ID);

ALTER TABLE Production
ADD CONSTRAINT FK_Production_Machines
FOREIGN KEY (Machine_ID)
REFERENCES Machines(Machine_ID);


ALTER TABLE Maintenance
ADD CONSTRAINT FK_Maintenance_Machines
FOREIGN KEY (Machine_ID)
REFERENCES Machines(Machine_ID);

ALTER TABLE Energy_Usage
ADD CONSTRAINT FK_Energy_Usage_Machines
FOREIGN KEY (Machine_ID)
REFERENCES Machines(Machine_ID);

SELECT DISTINCT m.Machine_ID
FROM Maintenance m
LEFT JOIN Machines mc
    ON m.Machine_ID = mc.Machine_ID
WHERE mc.Machine_ID IS NULL;


SELECT DISTINCT e.Machine_ID
FROM Energy_Usage e
LEFT JOIN Machines mc
    ON e.Machine_ID = mc.Machine_ID
WHERE mc.Machine_ID IS NULL;


SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc
    ON fk.object_id = fc.constraint_object_id
WHERE fk.name = 'FK_Maintenance_Machines';


SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc
    ON fk.object_id = fc.constraint_object_id
WHERE fk.name = 'FK_EnergyUsage_Machines';

--EnergyUsage to machines relationship

ALTER TABLE Energy_Usage
ADD CONSTRAINT FK_Energy_Usage_Machines
FOREIGN KEY (Machine_ID)
REFERENCES Machines(Machine_ID);

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc
    ON fk.object_id = fc.constraint_object_id
WHERE fk.name = 'FK_EnergyUsage_Machines';



SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc
    ON fk.object_id = fc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'Energy_Usage';

--Inventory table

SELECT DISTINCT i.Product_ID
FROM Inventory i
LEFT JOIN Products p
    ON i.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

--ForeignKey check
ALTER TABLE Inventory
ADD CONSTRAINT FK_Inventory_Product
FOREIGN KEY (Product_ID)
REFERENCES Products(Product_ID);

--verify

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc
    ON fk.object_id = fc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'Inventory';


--Order_id

SELECT DISTINCT s.Order_ID
FROM Sales s
LEFT JOIN Orders o
    ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

--Product_ID

SELECT DISTINCT s.Product_ID
FROM Sales s
LEFT JOIN Products p
    ON s.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

--Customer_ID:

SELECT DISTINCT s.Customer_ID
FROM Sales s
LEFT JOIN Customers c
    ON s.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

--Foreign Keys:

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_Orders
FOREIGN KEY (Order_ID)
REFERENCES Orders(Order_ID);

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_Product
FOREIGN KEY (Product_ID)
REFERENCES Products(Product_ID);

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_Customers
FOREIGN KEY (Customer_ID)
REFERENCES Customers(Customer_ID);

--Check

--Production_ID:

SELECT DISTINCT pc.Production_ID
FROM Production_Cost pc
LEFT JOIN Production p
    ON pc.Production_ID = p.Production_ID
WHERE p.Production_ID IS NULL;

--Product_ID:

SELECT DISTINCT pc.Product_ID
FROM Production_Cost pc
LEFT JOIN Products p
    ON pc.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

--Machine_ID:

SELECT DISTINCT pc.Machine_ID
FROM Production_Cost pc
LEFT JOIN Machines m
    ON pc.Machine_ID = m.Machine_ID
WHERE m.Machine_ID IS NULL;

--make a relationship

ALTER TABLE Production_Cost
ADD CONSTRAINT FK_ProductionCost_Production
FOREIGN KEY (Production_ID)
REFERENCES Production(Production_ID);

ALTER TABLE Production_Cost
ADD CONSTRAINT FK_ProductionCost_Product
FOREIGN KEY (Product_ID)
REFERENCES Products(Product_ID);

ALTER TABLE Production_Cost
ADD CONSTRAINT FK_ProductionCost_Machines
FOREIGN KEY (Machine_ID)
REFERENCES Machines(Machine_ID);

--Data Quality Check

SELECT 'Customers' AS TableName, COUNT(*) AS Row_Count FROM Customers
UNION ALL
SELECT 'Energy_Usage', COUNT(*) FROM Energy_Usage
UNION ALL
SELECT 'Inventory', COUNT(*) FROM Inventory
UNION ALL
SELECT 'Machines', COUNT(*) FROM Machines
UNION ALL
SELECT 'Maintenance', COUNT(*) FROM Maintenance
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Production', COUNT(*) FROM Production
UNION ALL
SELECT 'ProductionCost', COUNT(*) FROM Production_Cost
UNION ALL
SELECT 'Product', COUNT(*) FROM Products
UNION ALL
SELECT 'Sales', COUNT(*) FROM Sales;

--Duplicate Check

--Machines

SELECT Machine_ID, COUNT(*) AS DuplicateCount
FROM Machines
GROUP BY Machine_ID
HAVING COUNT(*) > 1;

--Product
SELECT Product_ID, COUNT(*) AS DuplicateCount
FROM Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

--Customers
SELECT Customer_ID, COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

--Orders
SELECT Order_ID, COUNT(*) AS DuplicateCount
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

--Production
SELECT Production_ID, COUNT(*) AS DuplicateCount
FROM Production
GROUP BY Production_ID
HAVING COUNT(*) > 1;

--NULL Check

--Machine ID:
SELECT *
FROM Machines
WHERE Machine_ID IS NULL;

--Product:
SELECT *
FROM Products
WHERE Product_ID IS NULL;

--Customer:
SELECT *
FROM Customers
WHERE Customer_ID IS NULL;

--Production:
SELECT *
FROM Production
WHERE Production_ID IS NULL;

--Production data aggregate

SELECT
    Machine_ID,
    COUNT(*) AS Production_Records,
    SUM(Planned_Qty) AS Total_Planned_Quantity,
    SUM(Actual_Qty) AS Total_Actual_Quantity,
    SUM(Rejected_Qty) AS Total_Reject_Quantity,
    SUM(Production_Hours) AS Total_Production_Hours,
    AVG(Capacity) AS Avg_Capacity
FROM Production
GROUP BY Machine_ID;

--Energy data aggregate

SELECT
    Machine_ID,
    SUM(Energy_Consumed_kWh) AS Total_Energy_Consumed,
    SUM(Energy_Cost) AS Total_Energy_Cost,
    AVG(Energy_Efficiency) AS Avg_Energy_Efficiency,
    SUM(Production_Output) AS Total_Energy_Production_Output,
    SUM(Maintenance_Downtime_Hours) AS Total_Downtime_Hours
FROM Energy_Usage
GROUP BY Machine_ID;

--Maintenance data aggregate

SELECT
    Machine_ID,
    COUNT(*) AS Maintenance_Count,
    SUM(Downtime_Hours) AS Total_Maintenance_Downtime,
    SUM(Maintenance_Cost) AS Total_Maintenance_Cost,
    SUM(CASE
        WHEN Failure_Flag = 1 THEN 1
        ELSE 0
    END) AS Failure_Count
FROM Maintenance
GROUP BY Machine_ID;

--Production Cost aggregate

SELECT
    Machine_ID,
    SUM(Material_Cost) AS Total_Material_Cost,
    SUM(Labour_Cost) AS Total_Labor_Cost,
    SUM(Energy_Cost) AS Total_Production_Energy_Cost,
    SUM(Maintenance_Cost) AS Total_Production_Maintenance_Cost,
    SUM(Total_Production_Cost) AS Total_Production_Cost,
    AVG(Cost_Per_Unit) AS Avg_Cost_Per_Unit
FROM Production_Cost
GROUP BY Machine_ID;

--Make a view name(vw_Machine_Analytics)

use PredictiveMaintenanceDB

CREATE VIEW dbo.vw_Machine_Analytics
AS

SELECT
    m.Machine_ID,
    m.Machine_Name,
    m.Machine_Type,

-- Production
    ISNULL(p.Production_Records, 0) AS Production_Records,
    ISNULL(p.Total_Planned_Quantity, 0) AS Total_Planned_Quantity,
    ISNULL(p.Total_Actual_Quantity, 0) AS Total_Actual_Quantity,
    ISNULL(p.Total_Reject_Quantity, 0) AS Total_Reject_Quantity,
    ISNULL(p.Total_Production_Hours, 0) AS Total_Production_Hours,
    ISNULL(p.Avg_Capacity, 0) AS Avg_Capacity,

-- Energy
    ISNULL(e.Total_Energy_Consumed, 0) AS Total_Energy_Consumed,
    ISNULL(e.Total_Energy_Cost, 0) AS Total_Energy_Cost,
    ISNULL(e.Avg_Energy_Efficiency, 0) AS Avg_Energy_Efficiency,
    ISNULL(e.Total_Energy_Production_Output, 0) AS Total_Energy_Production_Output,
    ISNULL(e.Total_Energy_Downtime, 0) AS Total_Energy_Downtime,

-- Maintenance
    ISNULL(mt.Maintenance_Count, 0) AS Maintenance_Count,
    ISNULL(mt.Total_Maintenance_Downtime, 0) AS Total_Maintenance_Downtime,
    ISNULL(mt.Total_Maintenance_Cost, 0) AS Total_Maintenance_Cost,
    ISNULL(mt.Failure_Count, 0) AS Failure_Count,

-- Production Cost
    ISNULL(pc.Total_Material_Cost, 0) AS Total_Material_Cost,
    ISNULL(pc.Total_Labor_Cost, 0) AS Total_Labor_Cost,
    ISNULL(pc.Total_Production_Energy_Cost, 0) AS Total_Production_Energy_Cost,
    ISNULL(pc.Total_Production_Maintenance_Cost, 0) AS Total_Production_Maintenance_Cost,
    ISNULL(pc.Total_Production_Cost, 0) AS Total_Production_Cost,
    ISNULL(pc.Avg_Cost_Per_Unit, 0) AS Avg_Cost_Per_Unit

FROM Machines m

LEFT JOIN
(
    SELECT
        Machine_ID,
        COUNT(*) AS Production_Records,
        SUM(Planned_Qty) AS Total_Planned_Quantity,
        SUM(Actual_Qty) AS Total_Actual_Quantity,
        SUM(Rejected_Qty) AS Total_Reject_Quantity,
        SUM(Production_Hours) AS Total_Production_Hours,
        AVG(Capacity) AS Avg_Capacity
    FROM Production
    GROUP BY Machine_ID
) p
ON m.Machine_ID = p.Machine_ID

LEFT JOIN
(
    SELECT
        Machine_ID,
        SUM(Energy_Consumed_kWh) AS Total_Energy_Consumed,
        SUM(Energy_Cost) AS Total_Energy_Cost,
        AVG(Energy_Efficiency) AS Avg_Energy_Efficiency,
        SUM(Production_Output) AS Total_Energy_Production_Output,
        SUM(Maintenance_Downtime_Hours) AS Total_Energy_Downtime
    FROM Energy_Usage
    GROUP BY Machine_ID
) e
ON m.Machine_ID = e.Machine_ID

LEFT JOIN
(
    SELECT
        Machine_ID,
        COUNT(*) AS Maintenance_Count,
        SUM(Downtime_Hours) AS Total_Maintenance_Downtime,
        SUM(Maintenance_Cost) AS Total_Maintenance_Cost,
        SUM(CASE
            WHEN Failure_Flag = 1 THEN 1
            ELSE 0
        END) AS Failure_Count
    FROM Maintenance
    GROUP BY Machine_ID
) mt
ON m.Machine_ID = mt.Machine_ID

LEFT JOIN
(
    SELECT
        Machine_ID,
        SUM(Material_Cost) AS Total_Material_Cost,
        SUM(Labour_Cost) AS Total_Labor_Cost,
        SUM(Energy_Cost) AS Total_Production_Energy_Cost,
        SUM(Maintenance_Cost) AS Total_Production_Maintenance_Cost,
        SUM(Total_Production_Cost) AS Total_Production_Cost,
        AVG(Cost_Per_Unit) AS Avg_Cost_Per_Unit
    FROM Production_Cost
    GROUP BY Machine_ID
) pc
ON m.Machine_ID = pc.Machine_ID;

--check the created view

select * from dbo.vw_Machine_Analytics  ---(now the number of rows will depend on our machines)

select COUNT(*) as Total_Machines
from dbo.vw_Machine_Analytics

---Machine Performance Metrics View

--Production Efficiency 
SELECT
    Machine_ID,
    Total_Planned_Quantity,
    Total_Actual_Quantity,
    CASE
        WHEN Total_Planned_Quantity = 0 THEN 0
        ELSE
            (Total_Actual_Quantity * 100.0)
            / Total_Planned_Quantity
    END AS Production_Efficiency
FROM dbo.vw_Machine_Analytics;

--Reject Rate
SELECT
    Machine_ID,
    Total_Actual_Quantity,
    Total_Reject_Quantity,
    CASE
        WHEN Total_Actual_Quantity = 0 THEN 0
        ELSE
            (Total_Reject_Quantity * 100.0)
            / Total_Actual_Quantity
    END AS Reject_Rate
FROM dbo.vw_Machine_Analytics;

--Energy per Unit
SELECT
    Machine_ID,
    Total_Energy_Consumed,
    Total_Actual_Quantity,
    CASE
        WHEN Total_Actual_Quantity = 0 THEN 0
        ELSE
            Total_Energy_Consumed / Total_Actual_Quantity
    END AS Energy_Per_Unit
FROM dbo.vw_Machine_Analytics;

--Maintenance Frequency
SELECT
    Machine_ID,
    Maintenance_Count,
    Production_Records,
    CASE
        WHEN Production_Records = 0 THEN 0
        ELSE
            Maintenance_Count * 1.0 / Production_Records
    END AS Maintenance_Frequency
FROM dbo.vw_Machine_Analytics;

--find Actual column names


SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vw_Machine_Analytics'
ORDER BY ORDINAL_POSITION;

SELECT TOP 1 *
FROM dbo.vw_Machine_Analytics;


---CREATE VIEW vw_Machine_Performance

CREATE VIEW dbo.vw_Machine_Performance
AS
SELECT
    Machine_ID,
    Machine_Name,
    Machine_Type,

    -- Production Metrics
    Production_Records,
    Total_Planned_Quantity,
    Total_Actual_Quantity,
    Total_Reject_Quantity,
    Total_Production_Hours,
    Avg_Capacity,

    -- Production Efficiency %
    CASE
        WHEN Total_Planned_Quantity = 0 THEN 0
        ELSE
            (Total_Actual_Quantity * 100.0)
            / Total_Planned_Quantity
    END AS Production_Efficiency,

    -- Reject Rate %
    CASE
        WHEN Total_Actual_Quantity = 0 THEN 0
        ELSE
            (Total_Reject_Quantity * 100.0)
            / Total_Actual_Quantity
    END AS Reject_Rate,

    -- Energy Metrics
    Total_Energy_Consumed,
    Total_Energy_Cost,
    Avg_Energy_Efficiency,
    Total_Energy_Production_Output,
    Total_Energy_Downtime,

    -- Energy consumed per unit
    CASE
        WHEN Total_Actual_Quantity = 0 THEN 0
        ELSE
            Total_Energy_Consumed * 1.0
            / Total_Actual_Quantity
    END AS Energy_Per_Unit,

    -- Maintenance Metrics
    Maintenance_Count,
    Total_Maintenance_Downtime,
    Total_Maintenance_Cost,
    Failure_Count,

    -- Maintenance Frequency
    CASE
        WHEN Production_Records = 0 THEN 0
        ELSE
            Maintenance_Count * 1.0
            / Production_Records
    END AS Maintenance_Frequency,

    -- Cost Metrics
    Total_Material_Cost,
    Total_Labor_Cost,
    Total_Production_Energy_Cost,
    Total_Production_Maintenance_Cost,
    Total_Production_Cost,
    Avg_Cost_Per_Unit,

    -- Total Downtime
    Total_Energy_Downtime
        + Total_Maintenance_Downtime
        AS Total_Downtime

FROM dbo.vw_Machine_Analytics;


SELECT *
FROM dbo.vw_Machine_Performance;

SELECT COUNT(*) AS Total_Machines
FROM dbo.vw_Machine_Performance;

--check Production date range start-end

SELECT
    MIN(Production_Date) AS Start_Date,
    MAX(Production_Date) AS End_Date,
    COUNT(*) AS Total_Records
FROM Production;

--check Energy date range start-end

SELECT
    MIN(Energy_Date) AS Start_Date,
    MAX(Energy_Date) AS End_Date,
    COUNT(*) AS Total_Records
FROM Energy_Usage;

--check Maintenance date range start-end


SELECT
    MIN(Maintenance_Date) AS Start_Date,
    MAX(Maintenance_Date) AS End_Date,
    COUNT(*) AS Total_Records
FROM Maintenance;


---Machine-Day level data


SELECT
    p.Machine_ID,
    CAST(p.Production_Date AS DATE) AS Data_Date,

    SUM(p.Planned_Qty) AS Planned_Qty,
    SUM(p.Actual_Qty) AS Actual_Qty,
    SUM(p.Rejected_Qty) AS Reject_Qty,
    SUM(p.Production_Hours) AS Production_Hours,
    AVG(p.Capacity) AS Average_Capacity

FROM Production p

GROUP BY
    p.Machine_ID,
    CAST(p.Production_Date AS DATE)

ORDER BY
    p.Machine_ID,
    Data_Date;


--Aggregate energy with Machine+Data Level

SELECT
    e.Machine_ID,
    CAST(e.Energy_Date AS DATE) AS Data_Date,

    SUM(e.Energy_Consumed_kWh) AS Energy_Consumed,
    SUM(e.Energy_Cost) AS Energy_Cost,
    AVG(e.Energy_Efficiency) AS Energy_Efficiency,
    SUM(e.Production_Output) AS Energy_Production_Output,
    SUM(e.Maintenance_Downtime_Hours) AS Energy_Downtime

FROM Energy_Usage e

GROUP BY
    e.Machine_ID,
    CAST(e.Energy_Date AS DATE)

ORDER BY
    e.Machine_ID,
    Data_Date;


--Maintenance- Machine + Date level aggregate

SELECT
    m.Machine_ID,
    CAST(m.Maintenance_Date AS DATE) AS Data_Date,

    COUNT(*) AS Maintenance_Count,
    SUM(m.Downtime_Hours) AS Maintenance_Downtime,
    SUM(m.Maintenance_Cost) AS Maintenance_Cost,

    SUM(
        CASE
            WHEN m.Failure_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Failure_Count

FROM Maintenance m

GROUP BY
    m.Machine_ID,
    CAST(m.Maintenance_Date AS DATE)

ORDER BY
    m.Machine_ID,
    Data_Date;


--Production + Energy + Maintenance together

--1st remove old view
DROP VIEW IF EXISTS dbo.vw_ML_Machine_Daily;


--Make Main ML Dataset View


CREATE VIEW dbo.vw_ML_Machine_Daily
AS

SELECT
    p.Machine_ID,
    p.Data_Date,

    -- Production
    p.Planned_Quantity,
    p.Actual_Quantity,
    p.Reject_Quantity,
    p.Production_Hours,
    p.Average_Capacity,

    -- Energy
    ISNULL(e.Energy_Consumed, 0) AS Energy_Consumed,
    ISNULL(e.Energy_Cost, 0) AS Energy_Cost,
    ISNULL(e.Energy_Efficiency, 0) AS Energy_Efficiency,
    ISNULL(e.Energy_Production_Output, 0) AS Energy_Production_Output,
    ISNULL(e.Energy_Downtime, 0) AS Energy_Downtime,

    -- Maintenance
    ISNULL(m.Maintenance_Count, 0) AS Maintenance_Count,
    ISNULL(m.Maintenance_Downtime, 0) AS Maintenance_Downtime,
    ISNULL(m.Maintenance_Cost, 0) AS Maintenance_Cost,
    ISNULL(m.Failure_Count, 0) AS Failure_Count,

    -- Derived Metrics

    CASE
        WHEN p.Planned_Quantity = 0 THEN 0
        ELSE
            p.Actual_Quantity * 100.0
            / p.Planned_Quantity
    END AS Production_Efficiency,

    CASE
        WHEN p.Actual_Quantity = 0 THEN 0
        ELSE
            p.Reject_Quantity * 100.0
            / p.Actual_Quantity
    END AS Reject_Rate,

    CASE
        WHEN p.Actual_Quantity = 0 THEN 0
        ELSE
            e.Energy_Consumed * 1.0
            / p.Actual_Quantity
    END AS Energy_Per_Unit,

    ISNULL(e.Energy_Downtime, 0)
        + ISNULL(m.Maintenance_Downtime, 0)
        AS Total_Downtime

FROM
(
    SELECT
        Machine_ID,
        CAST(Production_Date AS DATE) AS Data_Date,

        SUM(Planned_Qty) AS Planned_Quantity,
        SUM(Actual_Qty) AS Actual_Quantity,
        SUM(Rejected_Qty) AS Reject_Quantity,
        SUM(Production_Hours) AS Production_Hours,
        AVG(Capacity) AS Average_Capacity

    FROM dbo.Production

    GROUP BY
        Machine_ID,
        CAST(Production_Date AS DATE)
) p

LEFT JOIN
(
    SELECT
        Machine_ID,
        CAST(Energy_Date AS DATE) AS Data_Date,

        SUM(Energy_Consumed_kWh) AS Energy_Consumed,
        SUM(Energy_Cost) AS Energy_Cost,
        AVG(Energy_Efficiency) AS Energy_Efficiency,
        SUM(Production_Output) AS Energy_Production_Output,
        SUM(Maintenance_Downtime_Hours) AS Energy_Downtime

    FROM dbo.Energy_Usage

    GROUP BY
        Machine_ID,
        CAST(Energy_Date AS DATE)
) e

ON
    p.Machine_ID = e.Machine_ID
    AND p.Data_Date = e.Data_Date

LEFT JOIN
(
    SELECT
        Machine_ID,
        CAST(Maintenance_Date AS DATE) AS Data_Date,

        COUNT(*) AS Maintenance_Count,
        SUM(Downtime_Hours) AS Maintenance_Downtime,
        SUM(Maintenance_Cost) AS Maintenance_Cost,

        SUM(
            CASE
                WHEN Failure_Flag = 1 THEN 1
                ELSE 0
            END
        ) AS Failure_Count

    FROM dbo.Maintenance

    GROUP BY
        Machine_ID,
        CAST(Maintenance_Date AS DATE)
) m

ON
    p.Machine_ID = m.Machine_ID
    AND p.Data_Date = m.Data_Date;



--View check

SELECT *
FROM dbo.vw_ML_Machine_Daily;

--Total ML-row

SELECT COUNT(*) AS Total_ML_Rows
FROM dbo.vw_ML_Machine_Daily;

--Check failure data

SELECT
    SUM(Failure_Count) AS Total_Failures
FROM dbo.vw_ML_Machine_Daily;

--Test target logic

SELECT
    d.Machine_ID,
    d.Data_Date,

    CASE
        WHEN EXISTS
        (
            SELECT 1
            FROM dbo.Maintenance m
            WHERE m.Machine_ID = d.Machine_ID
              AND m.Failure_Flag = 1
              AND CAST(m.Maintenance_Date AS DATE) > d.Data_Date
              AND CAST(m.Maintenance_Date AS DATE) <= DATEADD(DAY, 7, d.Data_Date)
        )
        THEN 1
        ELSE 0
    END AS Failure_Next_7_Days

FROM dbo.vw_ML_Machine_Daily d

ORDER BY
    d.Machine_ID,
    d.Data_Date;


--Target distribution check

SELECT
    Failure_Next_7_Days,
    COUNT(*) AS Total_Rows
FROM
(
    SELECT
        d.Machine_ID,
        d.Data_Date,

        CASE
            WHEN EXISTS
            (
                SELECT 1
                FROM dbo.Maintenance m
                WHERE m.Machine_ID = d.Machine_ID
                  AND m.Failure_Flag = 1
                  AND CAST(m.Maintenance_Date AS DATE) > d.Data_Date
                  AND CAST(m.Maintenance_Date AS DATE)
                      <= DATEADD(DAY, 7, d.Data_Date)
            )
            THEN 1
            ELSE 0
        END AS Failure_Next_7_Days

    FROM dbo.vw_ML_Machine_Daily d
) x

GROUP BY Failure_Next_7_Days;


--Deop previous view

DROP VIEW IF EXISTS dbo.vw_ML_Failure_Prediction;

--Make Final ML Dataset View

CREATE VIEW dbo.vw_ML_Failure_Prediction
AS

SELECT
    d.Machine_ID,
    d.Data_Date,

    -- Production Features
    d.Planned_Quantity,
    d.Actual_Quantity,
    d.Reject_Quantity,
    d.Production_Hours,
    d.Average_Capacity,
    d.Production_Efficiency,
    d.Reject_Rate,

    -- Energy Features
    d.Energy_Consumed,
    d.Energy_Cost,
    d.Energy_Efficiency,
    d.Energy_Production_Output,
    d.Energy_Downtime,
    d.Energy_Per_Unit,

    -- Maintenance Features
    d.Maintenance_Count,
    d.Maintenance_Downtime,
    d.Maintenance_Cost,
    d.Failure_Count,

    -- Overall Machine Condition
    d.Total_Downtime,

    -- Target
    CASE
        WHEN EXISTS
        (
            SELECT 1
            FROM dbo.Maintenance m
            WHERE m.Machine_ID = d.Machine_ID
              AND m.Failure_Flag = 1
              AND CAST(m.Maintenance_Date AS DATE) > d.Data_Date
              AND CAST(m.Maintenance_Date AS DATE)
                  <= DATEADD(DAY, 7, d.Data_Date)
        )
        THEN 1
        ELSE 0
    END AS Failure_Next_7_Days

FROM dbo.vw_ML_Machine_Daily d;

--Final Dataset Check

SELECT *
FROM dbo.vw_ML_Failure_Prediction
ORDER BY Machine_ID, Data_Date;

SELECT COUNT(*) AS Total_ML_Rows
FROM dbo.vw_ML_Failure_Prediction;


SELECT
    Failure_Next_7_Days,
    COUNT(*) AS Total_Rows
FROM dbo.vw_ML_Failure_Prediction
GROUP BY Failure_Next_7_Days;

--Check any null values are in ML Dataset

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Actual_Quantity IS NULL THEN 1 ELSE 0 END) AS Null_Actual_Quantity,
    SUM(CASE WHEN Energy_Consumed IS NULL THEN 1 ELSE 0 END) AS Null_Energy,
    SUM(CASE WHEN Production_Efficiency IS NULL THEN 1 ELSE 0 END) AS Null_Production_Efficiency,
    SUM(CASE WHEN Energy_Per_Unit IS NULL THEN 1 ELSE 0 END) AS Null_Energy_Per_Unit,
    SUM(CASE WHEN Maintenance_Count IS NULL THEN 1 ELSE 0 END) AS Null_Maintenance_Count
FROM dbo.vw_ML_Failure_Prediction;

use PredictiveMaintenanceDB

SELECT *
FROM dbo.vw_ML_Failure_Prediction;