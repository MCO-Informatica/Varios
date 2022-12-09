#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
#include "rwmake.ch"

/*
* Funcao		:
* Autor			:	João Zabotto '
* Data			: 	14/02/2014
* Descricao		:
* Retorno		:
*/
User Function CHKEXEC()

SM2->(DbSetOrder(1))
If SM2->(DbSeek(Dtos(dDataBase)))
	Reclock('SM2',.F.)
Else
	Reclock('SM2',.T.)
	SM2->M2_DATA	:= dDataBase
EndIf
SM2->M2_MOEDA5	:= 1
SM2->(MsUnlock())

ZLOCKPER()

Return

/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	12/03/2015
* Descricao		:
* Retorno		:
*/
Static Function ZLOCKPER()
Local aPergOn  := {}
Local aPergOff := {}
Local nX       := 0
Local lOnlIne  := SuperGetMv('ZZ_LANONLI',.F.,.F.)


AaDd(aPergOn,{'FIN040','03'}) // Financeiro Receber
AaDd(aPergOn,{'FIN050','04'}) // Financeiro Pagar
AaDd(aPergOn,{'FIN330','09'}) // Comensação Receber
AaDd(aPergOn,{'AFI340','11'}) // Comensação Pagar
AaDd(aPergOn,{'AFI460','01'}) // Liquidação
AaDd(aPergOn,{'FIN565','01'}) // Liquidação
AaDd(aPergOn,{'AFI100','04'}) // Movimento Bancário
AaDd(aPergOn,{'FIN080','03'}) // Baixa Pagar
AaDd(aPergOn,{'FIN070','04'}) // Baixa Receber
AaDd(aPergOn,{'AFI200','11'}) // Retrono Cnab
AaDd(aPergOn,{'AFI290','03'}) // Faturas a Pagar
AaDd(aPergOn,{'AFI290','04'}) // Faturas a Pagar
AaDd(aPergOn,{'AFI190','04'}) // Cheques    

SXK->(DbSetOrder(1))
For nX := 1 to Len(aPergOn)       
	If !SXK->(DbSeek(Padr(aPergOn[nX][1],10) + aPergOn[nX][2] + 'U' + __CUserId))
		If Reclock('SXK',.T.)
			SXK->XK_GRUPO  := Padr(aPergOn[nX][1],10)
			SXK->XK_SEQ    := aPergOn[nX][2]
			SXK->XK_IDUSER := 'U' + __CUserId
			SXK->XK_CONTEUD:= If(lOnlIne,'1','2')
			SXK->(MsUnlock())
		EndIf
	ElseIf SXK->(DbSeek(Padr(aPergOn[nX][1],10) + aPergOn[nX][2] + 'U' + __CUserId))
		If Reclock('SXK',.F.)
			SXK->XK_GRUPO  := Padr(aPergOn[nX][1],10)
			SXK->XK_SEQ    := aPergOn[nX][2]
			SXK->XK_IDUSER := 'U' + __CUserId
			SXK->XK_CONTEUD:= If(lOnlIne,'1','2')
			SXK->(MsUnlock())
		EndIf
	EndIf
Next nX

Return

 
