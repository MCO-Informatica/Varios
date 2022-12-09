#include "Protheus.ch"
#INCLUDE "TOTVS.CH"
/*
ﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ｱｱﾉﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｻｱｱ
ｱｱｺPrograma  ｳRQIEE001()   ｺAutor  ｳRoberta Alonso   ｺ Data ｳ  11/11/16   ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺDesc.     ｳ Rotina para preenchimento das medi鋏es no resultados do    ｺｱｱ
ｱｱｺ          ｳ inspe鈬o de entrada                                        ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺUso       ｳ Protheus 12                          	                  ｺｱｱ
ｱｱﾈﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｼｱｱ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟ
*/

//覧覧覧覧覧覧覧覧覧覧覧覧�
User Function RQIEE001()
//覧覧覧覧覧覧覧覧覧覧覧覧�

Local _aSavArea := GetArea()
Local _lRet 	:= .T.
Local _nMed 	:= 1
Local _nMaxMed	:= 15

//esta rotina � executada de qualquer campo Medicao da especifica鈬o tecnica, pois os campos tem o mesmo nome.
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

Q215VERCAL(M->QES_MEDICA) //Chamada de fun鈬o para avaliar m馘ia dos resultados e atualizar status do lote (aprovado/reprovado)

RestArea(_aSavArea)

Return(_lRet)