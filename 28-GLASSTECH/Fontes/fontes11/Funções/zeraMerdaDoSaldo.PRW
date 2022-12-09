#include "PROTHEUS.CH"
#include "TOPCONN.CH"
#include "RWMAKE.CH"

User Function PesLamb()

	Local cQuery := ""
	Local aData := {}

	cQuery += "	Select "
	cQuery += "		BF_FILIAL, "
	cQuery += "		BF_PRODUTO, "
	cQuery += "		BF_LOTECTL, "
	cQuery += "		BF_LOCALIZ, "
	cQuery += "		BF_QUANT, "
	cQuery += "		B1_UM, "
	cQuery += "		Case IsNull(BZ.BZ_LOCPAD, '00') "
	cQuery += "			When '00' Then B1.B1_LOCPAD "
	cQuery += "			Else BZ.BZ_LOCPAD "
	cQuery += "		End As LOCPAD "
	cQuery += "	From SBF010 As BF "
	cQuery += "	Inner Join SB1010 As B1 On (B1.B1_COD = BF.BF_PRODUTO And B1.D_E_L_E_T_ = '') "
	cQuery += "	Left Join SBZ010 As BZ On (BZ.BZ_COD = BF.BF_PRODUTO And BZ.BZ_FILIAL = BF.BF_FILIAL And BZ.D_E_L_E_T_ = '') "
	cQuery += "	Where "
	cQuery += "		BF.D_E_L_E_T_ = '' "
	cQuery += "	Order By BF_PRODUTO, BF_FILIAL "

	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery Alias PROD New
	TCSetField("PROD", "BF_QUANT", "N", 12, 3)
	dbSelectArea("PROD")
	nCount := 0

	While ! PROD->(Eof())
		AAdd(aData, { PROD->BF_FILIAL, PROD->BF_PRODUTO, PROD->BF_LOTECTL, PROD->BF_LOCALIZ, PROD->BF_QUANT, PROD->B1_UM,  PROD->LOCPAD  } )
		nCount++
		PROD->(dbSkip())
	End

	MsgAlert("Processo de pesquesa concluido, " + Str(Len(aData)) + " linhas!")
	dbSelectArea("PROD")
	dbCloseArea()

	Return aData


// Rotina para inclusão de saldo no protheus a partir do gestoq pela rotina interna MOD 2
// MATA241
User Function PonRab1

	Local cQuery := ""
	Local aData  := {}

// MATA241
	Local _aCab1 := {}
	Local _aItem := {}
	Local _aExecItem := {}

	Local _aData := {}
	Local i := 1

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	MsgAlert("Essa função faz uma merda na base de dados!")

	_aCab1 := {{"D3_TM", "507", nil},;
		{"D3_EMISSAO", dDatabase, nil}}

	cQuery += "	Select "
	cQuery += "		BF_FILIAL, "
	cQuery += "		BF_PRODUTO, "
	cQuery += "		BF_LOTECTL, "
	cQuery += "		BF_LOCALIZ, "
	cQuery += "		BF_QUANT, "
	cQuery += "		B1_UM, "
	cQuery += "		Case IsNull(BZ.BZ_LOCPAD, '00') "
	cQuery += "			When '00' Then B1.B1_LOCPAD "
	cQuery += "			Else BZ.BZ_LOCPAD "
	cQuery += "		End As LOCPAD "
	cQuery += "	From SBF010 As BF "
	cQuery += "	Inner Join SB1010 As B1 On (B1.B1_COD = BF.BF_PRODUTO And B1.D_E_L_E_T_ = '') "
	cQuery += "   INNER JOIN SB2010 B2 ON B2_COD = BF_PRODUTO AND B2_FILIAL = BF_FILIAL AND B2.D_E_L_E_T_ = '' AND B2_QATU <> 0 AND B2_QACLASS = 0 "
	cQuery += "	Left Join SBZ010 As BZ On (BZ.BZ_COD = BF.BF_PRODUTO And BZ.BZ_FILIAL = BF.BF_FILIAL And BZ.D_E_L_E_T_ = '') "
	cQuery += "	Where "
	cQuery += "		BF.D_E_L_E_T_ = '' "
	cQuery += " And BF_LOTECTL = '' And BF_QUANT > 0"
	//cQuery += "  And BF_QUANT > 0"
	cQuery += "	Order By BF_PRODUTO, BF_FILIAL "

//cQuery := ChangeQuery(cQuery)

	TCQuery cQuery Alias PROD New

	TCSetField("PROD", "BF_QUANT", "N", 12, 3)
 
	dbSelectArea("PROD")

	nCount := 0

	While !PROD->(Eof())
		AAdd(aData, { AllTrim(PROD->BF_FILIAL), AllTrim(PROD->BF_PRODUTO), AllTrim(PROD->BF_LOTECTL), AllTrim(PROD->BF_LOCALIZ), PROD->BF_QUANT, AllTrim(PROD->B1_UM),  AllTrim(PROD->LOCPAD)  } )
		nCount++
		PROD->(dbSkip())
	End

	MsgAlert("Processo de pesquisa concluido, " + Str(Len(aData)) + " linhas!")

	_aData := aData

	For  i := 1 To len(_aData)

		lMsHelpAuto := .T.
		lMsErroAuto := .F.
		_aItem := {}
		/*_aItem := {{"D3_COD", 		PadR(_aData[i][2], TamSX3("D3_COD")[1]), nil},;
		{"D3_FILIAL", 	PadR(_aData[i][1], TamSX3("D3_FILIAL")), nil},;
		{"D3_UM", 		PadR(_aData[i][6], TamSX3("D3_UM")), nil},;
		{"D3_QUANT", 	_aData[i][5], nil},;
		{"D3_LOCAL", 	PadR(_aData[i][7], TamSX3("D3_LOCAL")), nil},;
		{"D3_LOCALIZ", 	PadR(_aData[i][4], TamSX3("D3_LOCALIZ")), nil},;
		{"D3_LOTECTL", 	PadR(_aData[i][3], TamSX3("D3_LOTECTL")), nil}}*/

		aAdd(_aItem, {"D3_COD", 		PadR(_aData[i][2], TamSX3("D3_COD")[1]), nil})
		aAdd(_aItem, {"D3_FILIAL", 	PadR(_aData[i][1], TamSX3("D3_FILIAL")[1]), nil})
		aAdd(_aItem, {"D3_UM", 		PadR(_aData[i][6], TamSX3("D3_UM")[1]), nil})
		aAdd(_aItem, {"D3_QUANT", 	_aData[i][5], nil})
		aAdd(_aItem, {"D3_LOCAL", 	PadR(_aData[i][7], TamSX3("D3_LOCAL")[1]), nil})
		aAdd(_aItem, {"D3_LOCALIZ", 	PadR(_aData[i][4], TamSX3("D3_LOCALIZ")[1]), nil})

		//SB1->(DbSetOrder(1))
		//If SB1->(DbSeek(xFilial('SB1') + PadR(_aData[i][2], TamSX3("D3_COD")[1])))
		//If SB1->B1_RASTRO != 'N'
		//	aAdd(_aItem, {"D3_LOTECTL", 	PadR(_aData[i][3], TamSX3("D3_LOTECTL")[1]), nil})
		//EndIf
		//EndIf
		_aExecItem := {}
		aAdd(_aExecItem, _aItem)

		MsExecAuto({|x, y, z| Mata241(x, y, z)}, _aCab1, _aExecItem, 3)

		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			Break
		EndIf
	Next

	MsgAlert("Processo finalizado com sucesso")
Return
