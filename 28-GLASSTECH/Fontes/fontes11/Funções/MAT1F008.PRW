#include 'protheus.ch'
#include "topconn.ch"

user function MAT1F008(cProd)

	local nValorMercadoria := 0

	If Type("oGetDad")!="U"
		oGetDad:oBrowse:Refresh()
	EndIf
	
	If "C6_TES"$ReadVar()
		cTes := M->C6_TES
	Else
		cTes := aCols[N,GDFieldPos("C6_TES")]
	EndIF

	nValorMercadoria := U_GetEmitT(cProd/*C6_PRODUTO*/, cTes/*C6_TES*/)

	if (nValorMercadoria > -1)
		aCols[N,GDFieldPos("C6_PRCVEN")] :=  nValorMercadoria
		aCols[N,GDFieldPos("C6_PRUNIT")] :=  nValorMercadoria
		aCols[N,GDFieldPos("C6_VALOR")] :=  Round(aCols[N,GDFieldPos("C6_PRCVEN")] * aCols[N,GDFieldPos("C6_QTDVEN")],2)
	endif

	If Type("oGetDad")!="U"
		oGetDad:oBrowse:Refresh()
	EndIF

	Return .T.


// Função responsável por trazer o preço do produto baseado
// nas emissões de notas feito pePlas empresas
user function GetEmitT(cProd, cTes)

	local nAreaPeca := 0
	local nValorProd := 0

	DbSelectArea("SB1")
	dbSetOrder(1)

	if (dbseek(xFilial("SB1") + cProd))
		nAreaPeca := SB1->B1_ZZBRUTA

// Acessa regra Tes X Valor Servico
		DbSelectArea("ZZG")
		if (dbSeek(xFilial("ZZG") + cTes))
			return (nAreaPeca * ZZG->ZZG_VALOR)
		endif
	endif

	return -1
