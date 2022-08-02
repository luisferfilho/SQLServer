SELECT 
    db_name() as DatabaseName, 
    OBJECT_NAME (a.object_id) as ObjectName, 
    a.index_id, 
    b.name as IndexName, 
    avg_fragmentation_in_percent, 
    index_type_desc
FROM 
    sys.dm_db_index_physical_stats (db_id(), NULL, NULL, NULL, NULL) AS a
INNER JOIN 
    sys.indexes AS b 
ON 
    a.object_id = b.object_id 
AND 
    a.index_id = b.index_id
WHERE 
    b.index_id > 0 
AND 
    avg_fragmentation_in_percent > 0
	AND  db_name() = 'DADOSADV'
	order by avg_fragmentation_in_percent