/**********************************************************************************
* Programa....:  ChkExec()                                                        *
* Autor.......:  Marcelo Aguiar Pimentel                                          *
* Data........:  25/11/2013                                                       *
* Descri��o...:  Valida se o ambiente escolhido � equivalente com a empresa logada*
*                                                                                 *
**********************************************************************************/

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOTVS.CH"
#include "vkey.ch"
#include "topconn.ch"

#DEFINE CTRL_E	05


User Function ChkExec()

	Local cAmbiente := AllTrim(Upper(GetEnvServer()))
	Local lRet := .t.
/*
	If SubStr(Upper(AllTrim(cUserName)), 1, 5) <> "ADMIN" // 99 = Configurador; 98 = Controladoria;
		If nModulo <> 99 .And. nModulo <> 98 // 99 = Configurador; 98 = Controladoria;
			If cEmpAnt == "02" .and. !(cAmbiente $("TESTE|P12117|FOLHA|ARMAZEM|HOMOLOG_AG"))
				MsgInfo("O ambiente(" + GetEnvServer() + ") escolhido para empresa n�o � permitido!  Favor usar o ambiente ARMAZEM")
				lRet := .f.
			elseIf cEmpAnt <> "02" .and. (cAmbiente == "ARMAZEM" .or. cAmbiente == "HOMOLOG_AG")
				MsgInfo("O ambiente(" + GetEnvServer() + ") escolhido para empresa n�o � permitido!  Favor usar o ambiente THOR")
				lRet := .f.
			endif
		ElseIf nModulo == 98 // Controladoria
			If !u_fChekGrp(__cUserId,"CONTROLADORIA")
				MsgAlert("Voc� n�o tem privil�gios suficientes para controladoria!")
				lRet := .f.
			EndIf
		EndIf
	EndIf
*/
	SetKey(CTRL_E, {|| u_sigacmd() })
	
return lRet