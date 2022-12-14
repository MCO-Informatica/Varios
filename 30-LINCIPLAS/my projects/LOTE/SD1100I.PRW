#include "rwmake.ch"
//
// Programa		SD1100I
// Autor		Carlos Nemesio Puerta
// Data			15/10/2017
// Descricao    Grava Dados da NFE em arquivo especifico de Controle de Lote (SZC)
// Uso          Ponto de entrada na inclusao da NFE.
// 				Especifico LINCIPLAS
//
User Function SD1100I()
Private _aArea   := GetArea()
Private _cTes    := aCols[N][aScan(aHeader,{|x|AllTrim(x[2])=="D1_TES"		})]
Private _cF4Est  := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_ESTOQUE")

If _cF4Est == "S"
	If !Empty(SD1->D1_XLOTE)
		dbSelectArea("SZC")
		dbSetOrder(1)          // ZC_FILIAL+ZC_SERNFE+ZC_DOCNFE+ZC_FORNFE+ZC_LOJANFE+ZC_ITEMNFE
		If !(dbSeek(xFilial("SZC")+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM))
			RecLock("SZC",.T.)
			SZC->ZC_FILIAL  := xFilial("SZC")
			SZC->ZC_SERNFE  := SD1->D1_SERIE
			SZC->ZC_DOCNFE  := SD1->D1_DOC
			SZC->ZC_ITEMNFE := SD1->D1_ITEM
			SZC->ZC_FORNFE  := SD1->D1_FORNECE
			SZC->ZC_LOJANFE := SD1->D1_LOJA
			SZC->ZC_PRODUTO := SD1->D1_COD
			SZC->ZC_LOTENFE := SD1->D1_XLOTE
 		    SZC->ZC_QTDNFE  := SD1->D1_QUANT
			SZC->ZC_STATUS  := "01"
			MsUnlock()
		EndIf
	EndIf
EndIf

RestArea(_aArea)
Return