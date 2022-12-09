#INCLUDE "PROTHEUS.CH" 
#Include "Rwmake.ch" 


USER FUNCTION CADCD() // U_CADSZC(), FUNÇÃO PARA VISUALIZACAO DOS DADOS DA TABELA PA2 
            

DbSelectArea("PA2") 
dbSetOrder(1) 

AxCadastro("PA2","COMPRA DIRETA") 
     
RETURN
