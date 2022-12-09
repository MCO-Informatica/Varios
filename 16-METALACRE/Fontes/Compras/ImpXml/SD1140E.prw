#Include "protheus.ch"
#include "topconn.ch"

//+-----------------------------------------------------------------------------------//
//|Funcao....: SD1140E()
//|Autor.....: Luiz ALberto
//|Data......: 11 de novembro de 2014, 09:00
//|Descricao.: P.E. executado na exclusão da PRE-NOTA
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function SD1140E()
*-----------------------------------------------------------*
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local lGrvMsg := .T.
Local cStatus := "5"
Local cMensag := ""
Local cChvNfe := ""

Local cQuery  := ""

SF1->(DbSetOrder(1))
If SF1->(DbSeek(SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA))
	If !Empty(SF1->F1_CHVNFE)

		cChvNfe := AllTrim(SF1->F1_CHVNFE)
		cChvNfe := StrTran(cChvNfe,"e","")
		cChvNfe := StrTran(cChvNfe,"E","")

		cMensag := "PRE NOTA FOI EXCLUIDA DO SISTEMA! - NUMERO PRE NOTA: "+SD1->D1_DOC + " / " + SD1->D1_SERIE
		U_ACOMA001(lGrvMsg,cStatus,cMensag,cChvNfe)

	Endif
EndIf

Return