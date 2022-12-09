#include "protheus.ch"

Static aParScript	:= {}

//-----------------------------------------------------------
// Rotina | ctsdk19 | Totvs - David       | Data | 31.10.13
// ----------------------------------------------------------
// Descr. | Rotina personalizada para tratamento especifico 
//        | de execução de campanhas e seus respectivos 
//        | scripts
//-----------------------------------------------------------
User Function CTSDK24()
Local lRet			:= .T.

//Customizacao para validar preenchimento de campos referente ao reembolso.
If M->ADE_ASSUNT $ GetMv("MV_XTMK01")

	If Empty(M->ADE_XBANCO)
		lRet := .F.
		MsgInfo("O campo Banco deve ser preenchido para reembolso.")
	ElseIf Empty(M->ADE_XAGENC)
		lRet := .F.
		MsgInfo("O campo Agencia deve ser preenchido para reembolso.")
	ElseIf Empty(M->ADE_XNUMCO)
		lRet := .F. 
		MsgInfo("O campo Numero da Conta deve ser preenchido para reembolso.")
	ElseIf Empty(M->ADE_XDCONT)
		lRet := .F.
		MsgInfo("O campo Digito da Conta deve ser preenchido para reembolso.")
	EndIf

EndIf 

Return(lRet)