
USE WideWorldImporters

------------
/*
--****** ����� ����������� ������� ******---

-- ��������� ������� �� ��������������� ����� ����������� 36% ������ 64% (� ������� ��� �����������)
-- ��������� ���������:

-- �� ������� ������ 
   ����� �� = 531 ��, ����������� ����� = 1060 ��.

-- ���������������� ������
	����� �� = 125 ��, ����������� ����� = 624 ��.

-- ���� ��������� ������������� 

*/

------------

SET STATISTICS IO, TIME ON

Select 
	ord.CustomerID, 
	det.StockItemID, 
	SUM(det.UnitPrice) as UnitPrice, 
	SUM(det.Quantity) as [QuantityPosition], 
	COUNT(ord.OrderID) as [QuantityOrder] 
FROM Sales.Orders AS ord 
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID 
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID 
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
WHERE Inv.BillToCustomerID != ord.CustomerID 
	AND (
		Select SupplierId 
		FROM Warehouse.StockItems AS It 
		Where It.StockItemID = det.StockItemID) = 12 
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity) 
		FROM Sales.OrderLines AS Total 
		Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID 
		WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000 
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID

--����� ��������������� ������� � ���������� SQL Server: 
-- ����� �� = 0 ��, �������� ����� = 0 ��.

-- ����� ������ SQL Server:
--   ����� �� = 0 ��, ����������� ����� = 0 ��.
--����� ��������������� ������� � ���������� SQL Server: 
-- ����� �� = 91 ��, �������� ����� = 91 ��.

--(��������� �����: 3619)
--������� "StockItemTransactions". ����� ���������� 1, ���������� ������ 0, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 29, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "StockItemTransactions". ������� ��������� 1, ��������� 0.
--������� "OrderLines". ����� ���������� 4, ���������� ������ 0, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 331, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "OrderLines". ������� ��������� 2, ��������� 0.
--������� "Worktable". ����� ���������� 0, ���������� ������ 0, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "CustomerTransactions". ����� ���������� 5, ���������� ������ 261, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "Orders". ����� ���������� 2, ���������� ������ 883, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "Invoices". ����� ���������� 1, ���������� ������ 44495, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "StockItems". ����� ���������� 1, ���������� ������ 2, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.

--(��������� ���� ������)

-- ����� ������ SQL Server:
--   ����� �� = 531 ��, ����������� ����� = 1060 ��.
--����� ��������������� ������� � ���������� SQL Server: 
-- ����� �� = 0 ��, �������� ����� = 0 ��.

-- ����� ������ SQL Server:
--   ����� �� = 0 ��, ����������� ����� = 0 ��.

--����� ����������: 2021-07-27T23:49:18.0115372+07:00


--- ����������:
/*
1)  DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0  ������� �� ��������� ��� (�������� ��� ��� ������� ����������)

2) ������� ������� ���� ��  ItemTrans.SupplierId = 12
	AND (
		Select SupplierId 
		FROM Warehouse.StockItems AS It 
		Where It.StockItemID = det.StockItemID) = 12 
3) ������ ������������������ ������ � �������� � ������� ����� WITH (INDEX([IX_Sales_invoices_OrderID_InvoiceDate_BillToCustomerID]))

CREATE NONCLUSTERED INDEX [IX_Sales_invoices_OrderID_InvoiceDate_BillToCustomerID] ON [Sales].[Invoices]
(
	OrderID asc,
	[InvoiceDate] ASC,
	[BillToCustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

*/


Select 
	ord.CustomerID, 
	det.StockItemID, 
	SUM(det.UnitPrice) as UnitPrice, 
	SUM(det.Quantity) as [QuantityPosition], 
	COUNT(ord.OrderID) as [QuantityOrder]
FROM Sales.Orders AS ord 
INNER  JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
INNER  JOIN Sales.Invoices AS Inv  WITH (INDEX([IX_Sales_invoices_OrderID_InvoiceDate_BillToCustomerID])) ON Inv.OrderID = ord.OrderID
INNER JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
INNER  JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
WHERE
	Inv.InvoiceDate = ord.OrderDate
	AND Inv.BillToCustomerID != ord.CustomerID 
	AND ItemTrans.SupplierId = 12
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity) 
		FROM Sales.OrderLines AS Total 
		Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID 
		WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000 	
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID

--����� ��������������� ������� � ���������� SQL Server: 
-- ����� �� = 0 ��, �������� ����� = 0 ��.

-- ����� ������ SQL Server:
--   ����� �� = 0 ��, ����������� ����� = 0 ��.
--����� ��������������� ������� � ���������� SQL Server: 
-- ����� �� = 68 ��, �������� ����� = 68 ��.

--(��������� �����: 3619)
--������� "OrderLines". ����� ���������� 4, ���������� ������ 0, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 331, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "OrderLines". ������� ��������� 2, ��������� 0.
--������� "Worktable". ����� ���������� 0, ���������� ������ 0, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "CustomerTransactions". ����� ���������� 5, ���������� ������ 261, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "Orders". ����� ���������� 2, ���������� ������ 883, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "Invoices". ����� ���������� 1, ���������� ������ 44495, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 0, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "StockItemTransactions". ����� ���������� 2, ���������� ������ 3, ���������� ������ 0, ����������� ������ 0, lob ���������� ������ 407, lob ���������� ������ 0, lob ����������� ������ 0.
--������� "StockItemTransactions". ������� ��������� 15, ��������� 0.

--(��������� ���� ������)

-- ����� ������ SQL Server:
--   ����� �� = 125 ��, ����������� ����� = 624 ��.
--����� ��������������� ������� � ���������� SQL Server: 
-- ����� �� = 0 ��, �������� ����� = 0 ��.

-- ����� ������ SQL Server:
--   ����� �� = 0 ��, ����������� ����� = 0 ��.

--����� ����������: 2021-07-27T23:51:05.8806966+07:00
