SELECT
    Name AS ChaveEstrangeira,
    OBJECT_NAME(Referenced_Object_ID) AS TabelaPai,
    OBJECT_NAME(Parent_Object_ID) AS TabelaFilho
    
FROM SYS.FOREIGN_KEYS
order by TabelaPai