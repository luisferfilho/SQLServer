


-- Caso Ocorra Erro na coluna provider na tabela usuario executar o script abaixo primeiro
-- Insert de registros que nao existem na tabela PROVIDER - N3ENG
insert into N3ENG.MES_DEV.dbo.PROVIDER 
(idProvider,providerName,descriptionService,CD_LEADER,TX_MAILCOOR)
	(SELECT DISTINCT * FROM dbo.Provider AS PROV_N3SIA
		WHERE NOT EXISTS
			(SELECT *  FROM N3ENG.MES_DEV.dbo.PROVIDER AS PROV_N3ENG
				WHERE PROV_N3SIA.idProvider = PROV_N3ENG.idProvider))




-- Insert de registros que nao existem na tabela USUARIO - N3ENG
insert into N3ENG.MES_DEV.dbo.USUARIO 
(MATRICULA,PAGINA_INICIAL,NOME,DOMINIO_NT,EMAIL,APELIDO,PROVIDER,Empresa_PJ,Inativo,idClassification,uniqueId)
	(SELECT DISTINCT * FROM dbo.USUARIO AS USER_N3SIA
		WHERE NOT EXISTS
			(SELECT *  FROM N3ENG.MES_DEV.dbo.USUARIO AS USER_N3ENG
				WHERE USER_N3SIA.MATRICULA = USER_N3ENG.MATRICULA))
