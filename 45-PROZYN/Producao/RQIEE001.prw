#include "Protheus.ch"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RQIEE001()   ºAutor  ³Roberta Alonso   º Data ³  11/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para preenchimento das medições no resultados do    º±±
±±º          ³ inspeção de entrada                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12                          	                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//—————————————————————————
User Function RQIEE001()
//—————————————————————————

Local _aSavArea := GetArea()
Local _lRet 	:= .T.
Local _nMed 	:= 1
Local _nMaxMed	:= 15

//esta rotina é executada de qualquer campo Medicao da especificação tecnica, pois os campos tem o mesmo nome.
//a Deborah (resp. pela qualidade) disse que eles possuem apenas uma medicao para todos os produtos, mas o XBR trabalha com no minimo duas.
//Entao nossa rotina pega o que digitou e replica na Medicao 02.

_cMedicao := &(ReadVar())  //conteudo digitado

For _nMed := 1 To _nMaxMed
	
	_cCampo := "Medicao " + StrZero(_nMed,2)
	_nPosMed := aScan(aHeader, {|x| alltrim(x[1]) == _cCampo})
	
	If _nPosMed > 0
		aCols[n,_nPosMed] := _cMedicao  //atualizacao da medicao
	EndIf

Next

Q215VERCAL(M->QES_MEDICA) //Chamada de função para avaliar média dos resultados e atualizar status do lote (aprovado/reprovado)

RestArea(_aSavArea)

Return(_lRet)