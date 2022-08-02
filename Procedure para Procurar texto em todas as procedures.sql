-- EXEC [dbo].[SP_SearchText] '@idline1'
ALTER PROCEDURE [dbo].[sp_SearchText]
	@texto VARCHAR(256) = ''
AS
BEGIN

SET NOCOUNT ON;

DECLARE @name_obj VARCHAR(200), 
		@type CHAR(2), 
		@schema_id INT, 
		@name_sch VARCHAR(50),
		@line VARCHAR(1024),
		@status_cur_objetos INTEGER,
		@status_cur_texto INTEGER,
		@i integer,
		@query VARCHAR(255)
CREATE TABLE #tCodeLine(
					line VARCHAR(1024)
					)
CREATE TABLE #tResult(
					nombre VARCHAR(128),
					tipo CHAR(2),
					nro_linea INT,
					texto VARCHAR(1024)
					)

-- Verifico si se especificó el parámetro requerido:
IF RTRIM(LTRIM(@texto)) = ''
	BEGIN
		SELECT 'Este procedimiento busca el texto especificado' + char(10) + 'dentro de procedimientos almacenados, vistas,' + char(10) + 'funciones de usuarios y triggers' as [Uso:]
	RETURN
	END

-- Obtengo todos los stored procedures, views, user functions y triggers de la base de datos:
DECLARE cur_objetos CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
	SELECT obj.name AS name_obj, obj.type, 0 , 'dbo' AS name_sch
	FROM sysobjects AS obj
	WHERE obj.type IN ('P', 'V', 'FN', 'TR') 
	ORDER BY 4, 1

	--SELECT obj.name AS name_obj, obj.type, 0 , 'dbo' AS name_sch
	--FROM sysobjects AS obj
	--WHERE obj.type IN ('P', 'V', 'FN', 'TR') 
	--ORDER BY 4, 1	

OPEN cur_objetos 
FETCH NEXT FROM cur_objetos INTO @name_obj, @type, @schema_id, @name_sch
SET @status_cur_objetos = @@FETCH_STATUS 
WHILE @status_cur_objetos = 0
BEGIN
	SET @query = 'sp_helptext ''[' + @name_sch + '].[' + @name_obj + ']'''
	DELETE FROM #tCodeLine
	INSERT INTO #tCodeLine
		EXEC (@query)

	DECLARE cur_texto CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
		SELECT line FROM #tCodeLine
		
	OPEN cur_texto
	FETCH NEXT FROM cur_texto INTO @line
	SET @status_cur_texto = @@FETCH_STATUS 

	SET @i = 1
	-- Para cada una de las lineas de codigo recuperadas, verificamos si contiene la cadena buscada y la misma no es un comentario
	WHILE @status_cur_texto = 0
	BEGIN
		IF CHARINDEX(@texto, @line) > 0 --AND CHARINDEX('--',RTRIM(LTRIM(@line))) = 0
			INSERT INTO #tResult(nombre, tipo, nro_linea, texto)
			VALUES (@name_sch + '.' + @name_obj, @type, @i,@line)
		
		FETCH NEXT FROM cur_texto INTO @line 				
		SET @status_cur_texto = @@FETCH_STATUS 
		SET @i = @i + 1
	END
	CLOSE cur_texto
	DEALLOCATE cur_texto

	FETCH NEXT FROM cur_objetos INTO @name_obj, @type, @schema_id, @name_sch
	SET @status_cur_objetos = @@FETCH_STATUS 
END
CLOSE cur_objetos
DEALLOCATE cur_objetos

-- Devuelvo los datos:
SELECT nombre, tipo, nro_linea, texto
FROM #tResult
ORDER BY 
1
END