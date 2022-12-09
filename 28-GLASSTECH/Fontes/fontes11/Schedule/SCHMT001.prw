#include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
 
//Integração - Importação Materiais.
 
User Function SCHMT001(_sEmp, _sFil)
 
	Private cCodEmp := _sEmp //"01"
	Private cCodFil := _sFil //"0101"
	 
	if (!Empty(cCodEmp) .and. !Empty(cCodFil))
	 
		RPCSetType(3) //não consome licença.
		 
		PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil TABLES "SB1","SB9","SC2","ZP1","SD3"
		 
		SetModulo("SIGACOM","COM")
		Conout("SCHEDMAT - Iniciando rotinas scheduladas em " + dtoc(date()) + " as " + time())
		Conout("Iniciando Processo")
		Conout("Empresa: "+ cCodEmp +" Filial: "+ cCodFil)
		//u_CTIIMP01()
		Conout("SCHEDMAT - Finalizando rotinas scheduladas em " + dtoc(date()) + " as " + time())
		
		RESET ENVIRONMENT
	 
	endif
 
Return(.T.)
