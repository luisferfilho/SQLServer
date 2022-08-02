--TOTAL MEMORIA CONSUMIDA
SELECT  object_name  , counter_name ,   cntr_value 
 FROM  sys . dm_os_performance_counters 
 WHERE  counter_name   =   'Total Server Memory (KB)'  

--TOTAL MEMORIA ALOCADA
SELECT  object_name  , counter_name ,   cntr_value 
 FROM  sys . dm_os_performance_counters 
 WHERE  counter_name   =   'Target Server Memory (KB)' 