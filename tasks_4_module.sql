USE SalesOrders;
GO

/*1. Â ÿêèõ ì³ñòàõ æèâóòü íàø³ êë³ºíòè?*/
SELECT DISTINCT CustCity
FROM Customers;
GO

/*2. Ïîêàçàòè ïîòî÷íèé ñïèñîê íàøèõ ïðàö³âíèê³â ³ íîìåðè ¿õí³õ òåëåôîí³â.*/
SELECT EmpFirstName,EmpLastName,EmpPhoneNumber
FROM Employees;
GO

/*3. Ïðîäóêòè ÿêèõ êàòåãîð³é ìè ïðîïîíóºìî â äàíèé ìîìåíò ÷àñó?*/
SELECT DISTINCT c.CategoryDescription
FROM Products AS p JOIN Categories AS c
ON p.CategoryID=c.CategoryID
WHERE QuantityOnHand>0;
GO

/*4. ßê íàçèâàþòüñÿ ³ ñê³ëüêè êîøòóþòü ïðîäóêòè êîòð³ ìè ïåðåâîçèìî ³ äî ÿêî¿ êàòåãîð³¿ âîíè â³äíîñÿòüñÿ.*/
SELECT DISTINCT p.ProductName,pv.WholesalePrice,c.CategoryDescription
FROM Products AS p JOIN Categories AS c
ON p.CategoryID=c.CategoryID
JOIN Product_Vendors AS pv
ON p.ProductNumber=pv.ProductNumber
GO

/*5. Ïîêàçàòè ñïèñîê ³ìåí ïîñòàâùèê³â â ïîðÿäêó ïîøòîâèõ ³íäåêñ³â.*/
SELECT VendName
FROM Vendors
ORDER BY VendZipCode;
GO

/*6. Ïîêàçàòè ñïèñîê ïðàö³âíèê³â ðàçîì ç ¿õí³ìè òåëåôîíàìè ³ ³äåíòèô³êàö³éíèìè íîìåðàìè ³ â³äñîðòóâàòè éîãî ïî ïð³çâèùàõ ³ ³ìåíàõ.*/
SELECT EmpFirstName,EmpLastName,EmpPhoneNumber,EmployeeID
FROM Employees
ORDER BY EmpLastName,EmpFirstName;
GO

/*7. Ïîêàçàòè ³ìåíà âñ³õ ïîñòàâùèê³â.*/
SELECT VendName
FROM Vendors;
GO

/*8. Â ÿêèõ øòàòàõ çíàõîäÿòüñÿ íàø³ êë³ºíòè?*/
SELECT DISTINCT c.CustState
FROM Customers AS c JOIN Orders AS o
ON c.CustomerID=o.CustomerID
GO

/*9. ßê íàçèâàþòüñÿ ³ ñê³ëüêè êîøòóþòü òîâàðè, êîòðèìè ìè òîðãóºìî?*/
SELECT DISTINCT p.ProductName,od.QuotedPrice
FROM Products AS p JOIN Order_Details AS od
ON p.ProductNumber=od.ProductNumber;
GO

/*10. Ïîêàçàòè âñþ ³íôîðìàö³þ ïðî íàøèõ ñï³âðîá³òíèêàõ.*/
SELECT EmployeeID,EmpFirstName,EmpLastName,EmpStreetAddress,EmpCity,EmpState,EmpZipCode,EmpAreaCode,EmpPhoneNumber
FROM Employees;
GO

/*11. Ïîêàçàòè â àëôàâ³òíîìó ïîðÿäêó ñïèñîê ì³ñò â êîòðèõ º íàø³ ïîñòàâùèêè ³ âêëþ÷èòè â íüîãî ³ìåíà âñ³õ ïîñòàâùèê³â, ç ÿêèìè ìè ïðàöþºìî â êîæíîìó ì³ñò³.*/
SELECT DISTINCT VendCity,VendName
FROM Vendors;
GO

/*12. Ñê³ëüêè äí³â ïîòð³áíî äëÿ äîñòàâêè êîæíîãî çàìîâëåííÿ?*/
SELECT od.OrderNumber,MAX(DaysToDeliver) AS DaysToDeliver
FROM Product_Vendors AS pv JOIN Order_Details AS od
ON od.ProductNumber=pv.ProductNumber
GROUP BY od.OrderNumber
ORDER BY od.OrderNumber;
GO

/*13. ßêà âàðò³ñòü çàïàñ³â êîæíîãî òîâàðó*/
SELECT ProductName,RetailPrice*QuantityOnHand AS [QuantityOnHand_Price]
FROM Products;
GO

/*14. Ñê³ëüêè äí³â ïðîéøëî â³ä äàòè çàìîâëåííÿ äî äàòè ïîñòàâêè êîæíîãî çàìîâëåííÿ?*/
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

/*15. Âèâåä³òü îäíèì çàïèòîì ñïèñîê íàòóðàëüíèõ ÷èñåë â³ä 1 äî 10 000.*/
DECLARE @start INT=1, @end INT=10000;
WITH cte AS (
    SELECT @start AS num
    UNION ALL
    SELECT num+1 FROM cte WHERE num+1<=@end
)
SELECT * FROM cte
OPTION (MAXRECURSION 10000);
GO

/*16.Ïîðàõóéòå çàïèòîì ñê³ëüêè ñóáîò ³ íåä³ëü â ïîòî÷íîìó ðîö³.*/
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
OR DATENAME(WEEKDAY,[days]) = 'ñóááîòà' OR DATENAME(WEEKDAY,[days]) = 'âîñêðåñåíüå'
GROUP BY DATENAME(WEEKDAY,[days])
OPTION (MAXRECURSION 400);
GO
