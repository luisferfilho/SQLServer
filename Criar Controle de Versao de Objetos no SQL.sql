-- CRIA a TABELA que IRA guardar os dados

CREATE TABLE Controle_Versao_Objetos(
 [Id_Trace_Alteracao_Objeto] [int] IDENTITY(1,1) NOT NULL,
  [Tp_Evento] [varchar](30) NULL, [Dt_Alteracao] [datetime] NULL,
   [Servidor] [varchar](20) NULL, [Login] [varchar](50) NULL,
    [Database] [varchar](20) NULL, [Nome_Objeto] [varchar](50) NULL, 
    [Ds_Evento] [xml] NULL ) ON [PRIMARY]  
    
    
    -- CRIA o trigger que ira disparar toda vez que houver inserçao,alteraçao ou delete de um objeto

    CREATE TRIGGER trgControle_Versao_Objetos
     ON DATABASE
      FOR DDL_DATABASE_LEVEL_EVENTS 
      AS 
      BEGIN 
      SET NOCOUNT 
      ON DECLARE @Evento XML SET @Evento = EVENTDATA() 
      INSERT INTO Controle_Versao_Objetos(Tp_Evento, Dt_Alteracao, Servidor, [Login], [Database], Nome_Objeto,Ds_Evento) 
      SELECT @Evento.value('(/EVENT_INSTANCE/EventType/text())[1]','varchar(50)') Tipo_Evento,
       @Evento.value('(/EVENT_INSTANCE/PostTime/text())[1]','datetime') PostTime, 
       @Evento.value('(/EVENT_INSTANCE/ServerName/text())[1]','varchar(50)') ServerName,
       @Evento.value('(/EVENT_INSTANCE/LoginName/text())[1]','varchar(50)') LoginName,
        @Evento.value('(/EVENT_INSTANCE/DatabaseName/text())[1]','varchar(50)') DatabaseName, 
        @Evento.value('(/EVENT_INSTANCE/ObjectName/text())[1]','varchar(50)') ObjectName, @Evento 
        END


--Consulta os dados na tabela

SELECT Tp_Evento,Dt_Alteracao,Servidor,[Login],[Database],Nome_Objeto,Ds_Evento 
FROM Controle_Versao_Objetos WITH(NOLOCK) 
ORDER BY Dt_Alteracao