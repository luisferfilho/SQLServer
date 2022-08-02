select name, run_Requested_Date, datediff(mi,run_Requested_Date,getdate())
from msdb..sysjobactivity A
join msdb..sysjobs B on A.job_id = B.job_id
where start_Execution_Date is not null and stop_execution_date is null