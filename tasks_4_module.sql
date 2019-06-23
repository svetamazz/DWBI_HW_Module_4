USE SalesOrders;
GO

/*1. В яких містах живуть наші клієнти?*/
SELECT DISTINCT CustCity
FROM Customers;
GO

/*2. Показати поточний список наших працівників і номери їхніх телефонів.*/
SELECT EmpFirstName,EmpLastName,EmpPhoneNumber
FROM Employees;
GO

/*3. Продукти яких категорій ми пропонуємо в даний момент часу?*/
SELECT DISTINCT c.CategoryDescription
FROM Products AS p JOIN Categories AS c
ON p.CategoryID=c.CategoryID
WHERE QuantityOnHand>0;
GO

/*4. Як називаються і скільки коштують продукти котрі ми перевозимо і до якої категорії вони відносяться.*/
SELECT DISTINCT p.ProductName,pv.WholesalePrice,c.CategoryDescription
FROM Products AS p JOIN Categories AS c
ON p.CategoryID=c.CategoryID
JOIN Product_Vendors AS pv
ON p.ProductNumber=pv.ProductNumber
GO

/*5. Показати список імен поставщиків в порядку поштових індексів.*/
SELECT VendName
FROM Vendors
ORDER BY VendZipCode;
GO

/*6. Показати список працівників разом з їхніми телефонами і ідентифікаційними номерами і відсортувати його по прізвищах і іменах.*/
SELECT EmpFirstName,EmpLastName,EmpPhoneNumber,EmployeeID
FROM Employees
ORDER BY EmpLastName,EmpFirstName;
GO

/*7. Показати імена всіх поставщиків.*/
SELECT VendName
FROM Vendors;
GO

/*8. В яких штатах знаходяться наші клієнти?*/
SELECT DISTINCT c.CustState
FROM Customers AS c JOIN Orders AS o
ON c.CustomerID=o.CustomerID
GO

/*9. Як називаються і скільки коштують товари, котрими ми торгуємо?*/
SELECT DISTINCT p.ProductName,od.QuotedPrice
FROM Products AS p JOIN Order_Details AS od
ON p.ProductNumber=od.ProductNumber;
GO

/*10. Показати всю інформацію про наших співробітниках.*/
SELECT EmployeeID,EmpFirstName,EmpLastName,EmpStreetAddress,EmpCity,EmpState,EmpZipCode,EmpAreaCode,EmpPhoneNumber
FROM Employees;
GO

/*11. Показати в алфавітному порядку список міст в котрих є наші поставщики і включити в нього імена всіх поставщиків, з якими ми працюємо в кожному місті.*/
SELECT DISTINCT VendCity,VendName
FROM Vendors;
GO

/*12. Скільки днів потрібно для доставки кожного замовлення?*/
SELECT od.OrderNumber,MAX(DaysToDeliver) AS DaysToDeliver
FROM Product_Vendors AS pv JOIN Order_Details AS od
ON od.ProductNumber=pv.ProductNumber
GROUP BY od.OrderNumber
ORDER BY od.OrderNumber;
GO

/*13. Яка вартість запасів кожного товару*/
SELECT ProductName,RetailPrice*QuantityOnHand AS [QuantityOnHand_Price]
FROM Products;
GO

/*14. Скільки днів пройшло від дати замовлення до дати поставки кожного замовлення?*/
;WITH DeliveryTime AS(
SELECT od.OrderNumber,MAX(DaysToDeliver) AS DaysToDeliver
FROM Product_Vendors AS pv JOIN Order_Details AS od
ON od.ProductNumber=pv.ProductNumber
GROUP BY od.OrderNumber
)
SELECT Orders.OrderNumber,DATEDIFF(dd,OrderDate,ShipDate)+DeliveryTime.DaysToDeliver AS WholeDeliveryTime
FROM Orders JOIN DeliveryTime
ON Orders.OrderNumber=DeliveryTime.OrderNumber
ORDER BY Orders.OrderNumber;
GO

/*15. Виведіть одним запитом список натуральних чисел від 1 до 10 000.*/
DECLARE @start INT=1, @end INT=10000;
WITH cte AS (
    SELECT @start AS num
    UNION ALL
    SELECT num+1 FROM cte WHERE num+1<=@end
)
SELECT * FROM cte
OPTION (MAXRECURSION 10000);
GO

/*16. Порахуйте запитом скільки субот і неділь в поточному році.*/
DECLARE @startdate DATE='01/01/2019'    
DECLARE @enddate DATE='31/12/2019'

;WITH  CTE AS
(
    SELECT  @startdate AS [days]
    UNION ALL
    SELECT DATEADD(DAY,1,[days]) AS [days]
    FROM    CTE
    WHERE   [days] < @enddate
	
)
SELECT DATENAME(WEEKDAY,[days]) AS [day], COUNT([days]) AS cnt_days 
FROM CTE 
WHERE DATENAME(WEEKDAY,[days]) = 'saturday' OR DATENAME(WEEKDAY,[days]) = 'sunday' 
OR DATENAME(WEEKDAY,[days]) = 'суббота' OR DATENAME(WEEKDAY,[days]) = 'воскресенье'
GROUP BY DATENAME(WEEKDAY,[days])
OPTION (MAXRECURSION 400);
GO
