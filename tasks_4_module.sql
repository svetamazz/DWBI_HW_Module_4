USE SalesOrders;
GO

/*1. � ���� ����� ������ ���� �볺���?*/
SELECT DISTINCT CustCity
FROM Customers;
GO

/*2. �������� �������� ������ ����� ���������� � ������ ���� ��������.*/
SELECT EmpFirstName,EmpLastName,EmpPhoneNumber
FROM Employees;
GO

/*3. �������� ���� �������� �� ��������� � ����� ������ ����?*/
SELECT DISTINCT c.CategoryDescription
FROM Products AS p JOIN Categories AS c
ON p.CategoryID=c.CategoryID
WHERE QuantityOnHand>0;
GO

/*4. �� ����������� � ������ �������� �������� ���� �� ���������� � �� ��� ������� ���� ����������.*/
SELECT DISTINCT p.ProductName,pv.WholesalePrice,c.CategoryDescription
FROM Products AS p JOIN Categories AS c
ON p.CategoryID=c.CategoryID
JOIN Product_Vendors AS pv
ON p.ProductNumber=pv.ProductNumber
GO

/*5. �������� ������ ���� ���������� � ������� �������� �������.*/
SELECT VendName
FROM Vendors
ORDER BY VendZipCode;
GO

/*6. �������� ������ ���������� ����� � ����� ���������� � ����������������� �������� � ����������� ���� �� �������� � ������.*/
SELECT EmpFirstName,EmpLastName,EmpPhoneNumber,EmployeeID
FROM Employees
ORDER BY EmpLastName,EmpFirstName;
GO

/*7. �������� ����� ��� ����������.*/
SELECT VendName
FROM Vendors;
GO

/*8. � ���� ������ ����������� ���� �볺���?*/
SELECT DISTINCT c.CustState
FROM Customers AS c JOIN Orders AS o
ON c.CustomerID=o.CustomerID
GO

/*9. �� ����������� � ������ �������� ������, ������� �� �������?*/
SELECT DISTINCT p.ProductName,od.QuotedPrice
FROM Products AS p JOIN Order_Details AS od
ON p.ProductNumber=od.ProductNumber;
GO

/*10. �������� ��� ���������� ��� ����� ������������.*/
SELECT EmployeeID,EmpFirstName,EmpLastName,EmpStreetAddress,EmpCity,EmpState,EmpZipCode,EmpAreaCode,EmpPhoneNumber
FROM Employees;
GO

/*11. �������� � ���������� ������� ������ ��� � ������ � ���� ���������� � �������� � ����� ����� ��� ����������, � ����� �� �������� � ������� ���.*/
SELECT DISTINCT VendCity,VendName
FROM Vendors;
GO

/*12. ������ ��� ������� ��� �������� ������� ����������?*/
SELECT od.OrderNumber,MAX(DaysToDeliver) AS DaysToDeliver
FROM Product_Vendors AS pv JOIN Order_Details AS od
ON od.ProductNumber=pv.ProductNumber
GROUP BY od.OrderNumber
ORDER BY od.OrderNumber;
GO

/*13. ��� ������� ������ ������� ������*/
SELECT ProductName,RetailPrice*QuantityOnHand AS [QuantityOnHand_Price]
FROM Products;
GO

/*14. ������ ��� ������� �� ���� ���������� �� ���� �������� ������� ����������?*/
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

/*15. ������� ����� ������� ������ ����������� ����� �� 1 �� 10 000.*/
DECLARE @start INT=1, @end INT=10000;
WITH cte AS (
    SELECT @start AS num
    UNION ALL
    SELECT num+1 FROM cte WHERE num+1<=@end
)
SELECT * FROM cte
OPTION (MAXRECURSION 10000);
GO

/*16. ��������� ������� ������ ����� � ����� � ��������� ����.*/
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
OR DATENAME(WEEKDAY,[days]) = '�������' OR DATENAME(WEEKDAY,[days]) = '�����������'
GROUP BY DATENAME(WEEKDAY,[days])
OPTION (MAXRECURSION 400);
GO