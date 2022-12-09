#INCLUDE "PROTHEUS.CH"

// validacao se o usuario  é um representante para filtros na tela e regras de gatilhos.
USER FUNCTION DHFILREP(_cfuncao)

Local lFil 		:= ""                                                    
Local cQuery	:= ""
Local cMvGrp 	:= SuperGetMV("MV_GRPREP",,"")


//----> DISPARADO PELA INTEGRACAO MERCOS
If Alltrim(_cFuncao)$"MP_CABECPV"
	
	lFil := .F.
	
//----> DISPARADO PELAS FUNÇÕES PADRÃO DO PROTHEUS
Else

	PswOrder(1)
	PswSeek(__CUSERID,.T.)
	aUser      	:= PswRet(1)
	IdUsuario  	:= aUser[1][1]     // codigo do usuario     
	GrupoUsuario:= IIF(LEN(aUser[1][10]) > 0 , aUser[1][10][1], "000000") 	// Grupo Que o usuario Pertence

	DbSelectarea("SA3")
	DBSETORDER(7)
	IF DBSEEK(xfilial("SA3") + IdUsuario) .AND. GrupoUsuario $ cMvGrp 
		lFil := .T.
	ELSE
		lFil := .F.
	ENDIF

	
EndIf

Return lFil 
