#INCLUDE "RWMAKE.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function TWAESCH(aParam)
	//Private lJob 	:= aParam[1]
	Private cCodEmp := aParam[2]
	Private cCodFil := aParam[3]
	
	Conout("Preparando o ambiente")
	RpcSetEnv(cCodEmp,cCodFil)
	
	Conout("Processando rotina TWACEMPB2")
	U_TWACEMPB2()
	Conout("Processamento finalizado")
		
	RpcClearEnv()	
Return