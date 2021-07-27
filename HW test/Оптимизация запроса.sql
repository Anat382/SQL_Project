
USE WideWorldImporters

------------
/*
--****** Итоги оптимизации запроса ******---

-- Стоимость запроса по действительному плану составляеет 36% против 64% (у запроса без оптимизации)
-- Сравнение статистик:

-- не оптимиз запрос 
   Время ЦП = 531 мс, затраченное время = 1060 мс.

-- оптимизированный запрос
	Время ЦП = 125 мс, затраченное время = 624 мс.

-- ниже приведены корректировки 

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

--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 91 мс, истекшее время = 91 мс.

--(затронуто строк: 3619)
--Таблица "StockItemTransactions". Число просмотров 1, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 29, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "StockItemTransactions". Считано сегментов 1, пропущено 0.
--Таблица "OrderLines". Число просмотров 4, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 331, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "OrderLines". Считано сегментов 2, пропущено 0.
--Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "CustomerTransactions". Число просмотров 5, логических чтений 261, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "Orders". Число просмотров 2, логических чтений 883, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "Invoices". Число просмотров 1, логических чтений 44495, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "StockItems". Число просмотров 1, логических чтений 2, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.

--(затронута одна строка)

-- Время работы SQL Server:
--   Время ЦП = 531 мс, затраченное время = 1060 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

--Время выполнения: 2021-07-27T23:49:18.0115372+07:00


--- ИСКЛЮЧЕНИЯ:
/*
1)  DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0  заменил на равенство дат (проверив что тип даннеых одинаковый)

2) заменил условие ниже на  ItemTrans.SupplierId = 12
	AND (
		Select SupplierId 
		FROM Warehouse.StockItems AS It 
		Where It.StockItemID = det.StockItemID) = 12 
3) создан некластеризованный индекс и применен с помощью хинта WITH (INDEX([IX_Sales_invoices_OrderID_InvoiceDate_BillToCustomerID]))

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

--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 68 мс, истекшее время = 68 мс.

--(затронуто строк: 3619)
--Таблица "OrderLines". Число просмотров 4, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 331, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "OrderLines". Считано сегментов 2, пропущено 0.
--Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "CustomerTransactions". Число просмотров 5, логических чтений 261, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "Orders". Число просмотров 2, логических чтений 883, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "Invoices". Число просмотров 1, логических чтений 44495, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "StockItemTransactions". Число просмотров 2, логических чтений 3, физических чтений 0, упреждающих чтений 0, lob логических чтений 407, lob физических чтений 0, lob упреждающих чтений 0.
--Таблица "StockItemTransactions". Считано сегментов 15, пропущено 0.

--(затронута одна строка)

-- Время работы SQL Server:
--   Время ЦП = 125 мс, затраченное время = 624 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

--Время выполнения: 2021-07-27T23:51:05.8806966+07:00
