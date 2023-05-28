ALTER VIEW [dbo].[SKUrateSouth_AllChannels] AS
SELECT SKU.[�������� �������], ������_�������, �������_������_�������, SKU.[����������� ������� ������], ������_SKU_RU,
             SUM(VRblProiz) AS ���, SUM(V) AS ��,  
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY SKU.[�������� �������]) AS shareTL, 
             row_number () over (partition BY ������_������� ORDER BY SUM(VRblProiz) DESC) rate,
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY ������_�������) AS shareRub, 
             SUM(V)*1.0/SUM(SUM(V)) OVER (PARTITION BY ������_�������) AS shareUnits, 'RF' As Scale
FROM     Sales LEFT OUTER JOIN SKU
                  ON SKU.������� = Sales.ID_SKU LEFT OUTER JOIN
                  distr ON Sales.ID_ERP = distr.ID_ERP LEFT OUTER JOIN
                  TT ON Sales.ID_�� = TT.ID_�� LEFT OUTER JOIN
				  [SKU 1C] ON [SKU 1C].������� = Sales.ID_SKU
WHERE distr.Channel = 'DIST' AND (Sales.Sales_Month BETWEEN '20210101' AND '20210601') AND (SKU.[�������� �������] = 'HH' OR SKU.[�������� �������] = 'HG')
AND SKU.[�������������� ������ ��] NOT LIKE '%������� �����%' AND SKU.[�������������� ������ ��] NOT LIKE '%������%' 
AND SKU.[�������������� ������ ��] NOT LIKE '%PRO%' AND SKU.[�������������� ������ ��] NOT LIKE '%��%'
AND SKU.[����������� ������� ������# ������������] NOT LIKE '%��%' AND SKU.[����������� ������� ������] NOT IN ('421060')
GROUP BY SKU.[����������� ������� ������], ������_�������, �������_������_�������, SKU.[�������� �������] , ������_SKU_RU

UNION ALL

SELECT SKU.[�������� �������], ������_�������, �������_������_�������, SKU.[����������� ������� ������], ������_SKU_RU,
             SUM(VRblProiz) AS ���, SUM(V) AS ��,
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY SKU.[�������� �������], distr.��������),
             row_number () over (partition BY ������_�������, distr.�������� ORDER BY SUM(VRblProiz) DESC),
             SUM(VRblProiz)/SUM(SUM(VRblProiz)) OVER (PARTITION BY ������_�������, distr.��������),
             SUM(V)*1.0/SUM(SUM(V)) OVER (PARTITION BY ������_�������, distr.��������), 'South'
FROM     Sales LEFT OUTER JOIN SKU
                  ON SKU.������� = Sales.ID_SKU LEFT OUTER JOIN
                  distr ON Sales.ID_ERP = distr.ID_ERP LEFT OUTER JOIN
                  TT ON Sales.ID_�� = TT.ID_�� LEFT OUTER JOIN
                  [SKU 1C] ON [SKU 1C].������� = Sales.ID_SKU
WHERE distr.Channel = 'DIST' AND (Sales.Sales_Month BETWEEN '20210101' AND '20210601') AND distr.�������� = '��'
AND (SKU.[�������� �������] = 'HH' OR SKU.[�������� �������] = 'HG')
AND SKU.[�������������� ������ ��] NOT LIKE '%������� �����%' AND SKU.[�������������� ������ ��] NOT LIKE '%������%' 
AND SKU.[�������������� ������ ��] NOT LIKE '%PRO%' AND SKU.[�������������� ������ ��] NOT LIKE '%��%'
AND SKU.[����������� ������� ������# ������������] NOT LIKE '%��%' AND SKU.[����������� ������� ������] NOT IN ('421060')
GROUP BY SKU.[����������� ������� ������],  ������_�������, �������_������_�������, SKU.[�������� �������], distr.��������, ������_SKU_RU
 