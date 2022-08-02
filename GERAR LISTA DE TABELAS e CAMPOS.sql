create table #dd (

table_id int NULL,

table_name nvarchar(128) NULL,

column_order int NULL,

column_name varchar(60) NULL,

column_datatype varchar(20) NULL,

column_length int NULL

--column_description varchar(500) NULL

)

DECLARE @table_name nvarchar(128)

DECLARE tablenames_cursor CURSOR FOR

--SELECT name FROM sysobjects where type = 'U' and status > 1 order by name

SELECT name FROM sysobjects where type = 'U' order by name

OPEN tablenames_cursor

FETCH NEXT FROM tablenames_cursor INTO @table_name

WHILE @@FETCH_STATUS = 0

BEGIN

insert #dd select

o.[id] as 'table_id',

o.[name] as 'table_name',

0 as 'column_order',

NULL as 'column_name',

NULL as 'column_datatype',

NULL as 'column_length'

--Cast(e.value as varchar(500)) as 'column_description'

from sysobjects o

--left join ::fn_listextendedproperty(N'MS_Description',

--N'user',N'dbo',N'table', @table_name, null, default) e on o.name = e.objname COLLATE Latin1_General_CI_AS

where o.name = @table_name
and o.type = 'U'


insert #dd select

o.[id] as 'table_id',

o.[name] as 'table_name',

c.colorder as 'column_order',

c.[name] as 'column_name',

t.[name] as 'column_datatype',

c.[length] as 'column_length'

--Cast(e.value as varchar(500)) as 'column_description'

from sysobjects o inner join syscolumns c on o.id = c.id inner join systypes t on c.xtype = t.xtype

--left join ::fn_listextendedproperty(N'MS_Description',

---N'user',N'dbo',N'table', @table_name, N'column', null) e on o.name = e.objname COLLATE Latin1_General_CI_AS

where o.name = @table_name
and t.status = 0

order by c.colorder

FETCH NEXT FROM tablenames_cursor INTO @table_name

END

CLOSE tablenames_cursor

DEALLOCATE tablenames_cursor

select table_name as TABELA,column_name as COLUNA,column_datatype as DATA_TYPE,column_length as TAMANHO,column_order as ORDEM from #dd
where column_order <> 0

order by table_name,column_order
drop table #dd

Return

Go
