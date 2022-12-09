#INCLUDE "PROTHEUS.CH"


//=======================================================================
//ROTINA PARA FILTRAR OS CLIENTES QUANDO O USUARIO FOR UM REPRESENTANTE.
//SO EXECUTA SE ESTIVER NO GRUPO DO REPRESENTANTE.
//=======================================================================

User Function MA030BRW()

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
	cFil := 'SA1->A1_VEND == "'+SA3->A3_COD+'"'
ELSE
	cFil := NIL
ENDIF

Return cFil
                             

