#include "rwmake.ch"
//
// Programa		SD1100E
// Autor		Carlos Nemesio Puerta
// Data			02/02/2018
// Descricao    Deleta Dados da NFE em arquivo especifico de Controle de Lote (SZC)
// Uso          Ponto de entrada na exclusão da NFE.
// 				Especifico LINCIPLAS
//
User Function SD1100E()
Private _aArea   := GetArea()
Private _cTes    := aCols[N][aScan(aHeader,{|x|AllTrim(x[2])=="D1_TES"		})]
Private _cF4Est  := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_ESTOQUE")

If _cF4Est == "S"
	If !Empty(SD1->D1_XLOTE)
		dbSelectArea("SZC")
		dbSetOrder(1)          // ZC_FILIAL+ZC_SERNFE+ZC_DOCNFE+ZC_FORNFE+ZC_LOJANFE+ZC_ITEMNFE
		If dbSeek(xFilial("SZC")+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
			RecLock("SZC",.F.)
			dbDelete()
			MsUnlock()
		EndIf
	EndIf
EndIf

RestArea(_aArea)
Return