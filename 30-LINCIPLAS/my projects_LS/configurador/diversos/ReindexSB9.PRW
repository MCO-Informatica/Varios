#Include "RWMAKE.CH"                   
#Include "protheus.CH"
                                
User Function ReindexSB9       

USE SB9010 exclusive NEW
 
DBSETINDEX("SB90101")     

DBREINDEX()   


alert("Tabela reindexada !..... (creio eu)")
SB9->(Dbclosearea())

Return

 