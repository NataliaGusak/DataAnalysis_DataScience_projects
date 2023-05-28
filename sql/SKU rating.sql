ALTER VIEW [dbo].[SKUrateSouth_AllChannels] AS
SELECT SKU.[Товарная линейка], Группа_рейтинг, Порядок_группы_рейтинг, SKU.[Генеральный артикул Россия], Статус_SKU_RU,
             SUM(VRblProiz) AS Руб, SUM(V) AS Шт,  
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY SKU.[Товарная линейка]) AS shareTL, 
             row_number () over (partition BY Группа_рейтинг ORDER BY SUM(VRblProiz) DESC) rate,
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY Группа_рейтинг) AS shareRub, 
             SUM(V)*1.0/SUM(SUM(V)) OVER (PARTITION BY Группа_рейтинг) AS shareUnits, 'RF' As Scale
FROM     Sales LEFT OUTER JOIN SKU
                  ON SKU.Артикул = Sales.ID_SKU LEFT OUTER JOIN
                  distr ON Sales.ID_ERP = distr.ID_ERP LEFT OUTER JOIN
                  TT ON Sales.ID_ТТ = TT.ID_ТТ LEFT OUTER JOIN
				  [SKU 1C] ON [SKU 1C].Артикул = Sales.ID_SKU
WHERE distr.Channel = 'DIST' AND (Sales.Sales_Month BETWEEN '20210101' AND '20210601') AND (SKU.[Товарная линейка] = 'HH' OR SKU.[Товарная линейка] = 'HG')
AND SKU.[Номенклатурная группа РФ] NOT LIKE '%Частные марки%' AND SKU.[Номенклатурная группа РФ] NOT LIKE '%препак%' 
AND SKU.[Номенклатурная группа РФ] NOT LIKE '%PRO%' AND SKU.[Номенклатурная группа РФ] NOT LIKE '%ЧМ%'
AND SKU.[Генеральный артикул Россия# Наименование] NOT LIKE '%ЧМ%' AND SKU.[Генеральный артикул Россия] NOT IN ('421060')
GROUP BY SKU.[Генеральный артикул Россия], Группа_рейтинг, Порядок_группы_рейтинг, SKU.[Товарная линейка] , Статус_SKU_RU

UNION ALL

SELECT SKU.[Товарная линейка], Группа_рейтинг, Порядок_группы_рейтинг, SKU.[Генеральный артикул Россия], Статус_SKU_RU,
             SUM(VRblProiz) AS Руб, SUM(V) AS Шт,
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY SKU.[Товарная линейка], distr.Дивизион),
             row_number () over (partition BY Группа_рейтинг, distr.Дивизион ORDER BY SUM(VRblProiz) DESC),
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY Группа_рейтинг, distr.Дивизион),
             SUM(V)*1.0/SUM(SUM(V)) OVER (PARTITION BY Группа_рейтинг, distr.Дивизион), 'South'
FROM     Sales LEFT OUTER JOIN SKU
                  ON SKU.Артикул = Sales.ID_SKU LEFT OUTER JOIN
                  distr ON Sales.ID_ERP = distr.ID_ERP LEFT OUTER JOIN
                  TT ON Sales.ID_ТТ = TT.ID_ТТ LEFT OUTER JOIN
                  [SKU 1C] ON [SKU 1C].Артикул = Sales.ID_SKU
WHERE distr.Channel = 'DIST' AND (Sales.Sales_Month BETWEEN '20210101' AND '20210601') AND distr.Дивизион = 'Юг'
AND (SKU.[Товарная линейка] = 'HH' OR SKU.[Товарная линейка] = 'HG')
AND SKU.[Номенклатурная группа РФ] NOT LIKE '%Частные марки%' AND SKU.[Номенклатурная группа РФ] NOT LIKE '%препак%' 
AND SKU.[Номенклатурная группа РФ] NOT LIKE '%PRO%' AND SKU.[Номенклатурная группа РФ] NOT LIKE '%ЧМ%'
AND SKU.[Генеральный артикул Россия# Наименование] NOT LIKE '%ЧМ%' AND SKU.[Генеральный артикул Россия] NOT IN ('421060')
GROUP BY SKU.[Генеральный артикул Россия],  Группа_рейтинг, Порядок_группы_рейтинг, SKU.[Товарная линейка], distr.Дивизион, Статус_SKU_RU
 