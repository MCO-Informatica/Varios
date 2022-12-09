#INCLUDE "PROTHEUS.CH"

//FILTRO DO BROWSE DOS PEDIDOS DE VENDA
//SO FILTRA OS PEDIDOS DO REPRESENTANTE.
USER FUNCTION M410FSQL()

Local cFil 		:= ""                                                    
Local cQuery	:= ""
Local cMvGrp 	:= SuperGetMV("MV_GRPREP",,"")

PswOrder(1)
PswSeek(__CUSERID,.T.)
aUser      	:= PswRet(1)
IdUsuario  	:= aUser[1][1]     // codigo do usuario     
GrupoUsuario:= aUser[1][10][1] // Grupo Que o usuario Pertence

DbSelectarea("SA3")
DBSETORDER(7)
IF DBSEEK(xfilial("SA3") + IdUsuario) .AND. GrupoUsuario $ cMvGrp 
	cFil := "C5_VEND1 = '" + ALLTRIM(SA3->A3_COD) + " '"
ELSE
	cFil := NIL
ENDIF

Return cFil 
