/**********************************************************************************
* Programa....:  CallChgXnu()                                                     *
* Autor.......:  Marcelo Aguiar Pimentel                                          *
* Data........:  25/11/2013                                                       *
* Descrição...:  Valida se o ambiente escolhido é equivalente com a empresa logada*
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


User Function CallChgXnu()
	Local cAmbiente := AllTrim(Upper(GetEnvServer()))
	aRet := ParamIxb[5]

	/*
	If nModulo <> 99 .And. nModulo <> 98 // 99 = Configurador; 98 = Controladoria;
		If cEmpAnt == "02" .and. !(cAmbiente $("FOLHA|ARMAZEM|HOMOLOG_AG"))
			MsgInfo("O ambiente(" + GetEnvServer() + ") escolhido para empresa não é permitido!  Favor usar o ambiente ARMAZEM")
			break
		elseIf cEmpAnt <> "02" .and. (cAmbiente == "ARMAZEM" .OR. cAmbiente == "HOMOLOG_AG") 
			MsgInfo("O ambiente(" + GetEnvServer() + ") escolhido para empresa não é permitido!  Favor usar o ambiente THOR")
			break
		endif
//	ElseIf nModulo == 98 // Controladoria
	EndIf
	*/
	
	SetKey(CTRL_E, {|| u_sigacmd() })
return aRet