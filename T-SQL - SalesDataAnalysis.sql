# Динамика SellOut клиентов производственной компании

SELECT Источник, Distr, Channel, Дивизион, ТСМ, ДСМ, месяц, Сеть_, Sales_Month, Мес, Канал, Rub, [2019], [2020], [2021]
FROM
(SELECT dbo.distr.Источник, dbo.distr.Distr, dbo.distr.Channel, dbo.distr.Дивизион, dbo.distr.ТСМ, dbo.distr.ДСМ,
DATEADD(d, DAY(dbo.Sales.Sales_Month) * - 1 + 1, dbo.Sales.Sales_Month) AS месяц, 
CASE WHEN MONTH(dbo.Sales.Sales_Month) < 3 THEN YEAR(dbo.Sales.Sales_Month) - 1 ELSE YEAR(dbo.Sales.Sales_Month) END AS год,
{ fn MONTHNAME(dbo.Sales.Sales_Month) } AS Мес, 
CASE WHEN dbo.[TT].[ID_ТТ] IS NULL THEN [Прямаясеть] ELSE [Сеть] END AS Сеть_, 
CASE WHEN [источник] = '1C' THEN 'Прямой клиент' WHEN [сеть] = '[not set]' THEN 'ЛР' WHEN [сеть] = 'нет' THEN 'ЛР' WHEN [сеть] IS NULL THEN 'ЛР' ELSE 'КР' END AS Канал, 
dbo.Sales.Sales_Month, COUNT(DISTINCT dbo.Sales.ID_ТТ) AS АКБ, SUM(VRblProiz) AS Rub

FROM   dbo.Sales INNER JOIN
             dbo.distr ON dbo.Sales.ID_ERP = dbo.distr.ID_ERP INNER JOIN
             dbo.SKU ON dbo.Sales.ID_SKU = dbo.SKU.Артикул LEFT OUTER JOIN
             dbo.TT ON dbo.Sales.ID_ТТ = dbo.TT.ID_ТТ
             
WHERE (dbo.Sales.Sales_Month >= '20190301')

GROUP BY
DATEADD(d, DAY(dbo.Sales.Sales_Month) * - 1 + 1, dbo.Sales.Sales_Month),
CASE WHEN MONTH(dbo.Sales.Sales_Month) < 3 THEN YEAR(dbo.Sales.Sales_Month) - 1 ELSE YEAR(dbo.Sales.Sales_Month) END, 
CASE WHEN dbo.[TT].[ID_ТТ] IS NULL THEN [Прямаясеть] ELSE [Сеть] END, 
CASE WHEN [источник] = '1C' THEN 'Прямой клиент' WHEN [сеть] = '[not set]' THEN 'ЛР' WHEN [сеть] = 'нет' THEN 'ЛР' WHEN [сеть] IS NULL THEN 'ЛР' ELSE 'КР' END,
dbo.distr.Источник, dbo.distr.Distr, dbo.distr.Channel, dbo.distr.Дивизион, dbo.distr.ТСМ, dbo.distr.ДСМ, dbo.Sales.Sales_Month, { fn MONTHNAME(dbo.Sales.Sales_Month) })

tab PIVOT (sum(АКБ) FOR год IN ([2019], [2020], [2021])) AS PivotTable;

