#Include "Protheus.ch"
#Include "TopConn.ch"

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: CFMMT010 | Autor: Celso Ferrone Martins  | Data: 09/06/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Rotina para gerar estrutura                               |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
User Function CFMMT010(cIncAlt)

Local aAreaSb1  := SB1->(GetArea())
Local aAreaSb5  := SB5->(GetArea())
Local aAreaSg1  := SG1->(GetArea())
Local aParamSb1 := {}
Local lRet      := .T.
Local cSeekSb1  := xFilial("SB1")+SB1->B1_COD
Local cSb1Cod   := SB1->B1_COD
Local cSb1Tipo  := SB1->B1_TIPO

DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("SG1") ; DbSetOrder(1)
DbSelectArea("SB5") ; DbSetOrder(1)

If SB1->B1_TIPO == "PA" .And. !Empty(SB1->B1_VQ_MP) .And. !Empty(SB1->B1_VQ_EM)
	aAdd(aParamSb1,{SB1->B1_COD})	// [01][01] - Produto Pai
	aAdd(aParamSb1,{SB1->B1_VQ_MP})	// [02][01] - Materia Prima
	aAdd(aParamSb1[2],"")			// [02][02] - Primeira UM da MP
	aAdd(aParamSb1[2],"")			// [02][03] - Segunda UM da MP
	aAdd(aParamSb1[2],0)			// [02][04] - Densidade
	aAdd(aParamSb1[2],"")			// [02][05] - Tipo de conversao
	aAdd(aParamSb1,{SB1->B1_VQ_EM})	// [03][01] - Embalegem
	aAdd(aParamSb1[3],0)			// [03][02] - Capacidade
	aAdd(aParamSb1[3],"")			// [03][03] - Unidade de Medida da EM
	If SB1->(DbSeek(xFilial("SB1")+aParamSb1[2][1]))
		aParamSb1[2][2] := SB1->B1_UM
		aParamSb1[2][3] := SB1->B1_SEGUM
		aParamSb1[2][4] := SB1->B1_CONV
		aParamSb1[2][5] := SB1->B1_TIPCONV
		If !SG1->(DbSeek(xFilial("SG1")+aParamSb1[1][1]))
			If SB1->(DbSeek(xFilial("SB1")+aParamSb1[3][1]))
				If SB1->B1_VQ_ECAP > 0
					aParamSb1[3][2] := SB1->B1_VQ_ECAP
					aParamSb1[3][3] := SB1->B1_VQ_UMEM
					If MsgYesNo("Deseja gerar estrutura com esse item?","Estrutura.")
						SB1->(DbSeek(cSeekSb1))
						Processa({|| CfmStrut(aParamSb1,@lRet)},"Gerando Estrutura")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	SB1->(DbSeek(cSeekSb1))
	If cIncAlt == "I"
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL := "1"
		MsUnLock()
	EndIf
	
EndIf

If cIncAlt == "A" .And. cSb1Tipo == "MP"
	Processa({|| CfmCompl(cSb1Cod)},"Atualizando Complemento")
EndIf

SB1->(RestArea(aAreaSb1))
SB5->(RestArea(aAreaSb5))
SG1->(RestArea(aAreaSg1))

Return(lRet)

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: CfmStrut | Autor: Celso Ferrone Martins  | Data: 09/06/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Funcao para gerar estrutura de produtos                   |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function CfmStrut(aParamSb1,lRet)

Local aCab     := {}
Local aItem    := {}
Local aDetalhe := {}
Local nQtdeMp  := 1
Local nQtdeEm  := 1

If aParamSb1[2][2] == aParamSb1[3][3]
	nQtdeMp := aParamSb1[3][2]
Else
	If aParamSb1[2][5] == "M"
		nQtdeMp := aParamSb1[3][2] / aParamSb1[2][4]
	ElseIf aParamSb1[2][5] == "D"
		nQtdeMp := aParamSb1[3][2] * aParamSb1[2][4]
	Else
		nQtdeMp := aParamSb1[3][2]
	EndIf
EndIf

aCab := {	{"G1_COD"   , aParamSb1[1][1]    , NIL},;
			{"G1_QUANT" , nQtdeMp            , NIL},;
			{"ATUREVSB1", "S"                , NIL},;
			{"NIVALT"   , "S"                , NIL}}

aDetalhe := {}
aadd(aDetalhe, {"G1_COD"   , aParamSb1[1][1]  , NIL})
aadd(aDetalhe, {"G1_COMP"  , aParamSb1[2][1]  , NIL})
aadd(aDetalhe, {"G1_QUANT" , nQtdeMp          , NIL})
aadd(aDetalhe, {"G1_FIXVAR", "V"              , NIL})
aadd(aDetalhe, {"G1_REVFIM", "ZZZ"            , NIL})
aadd(aDetalhe, {"G1_NIV"   , "01"             , NIL})
aadd(aDetalhe, {"G1_NIVINV", "99"             , NIL})
aadd(aDetalhe, {"G1_INI"   , dDataBase        , NIL})
aadd(aDetalhe, {"G1_FIM"   , cTod("31/12/49") , NIL})
aadd(aItem,aDetalhe)
aDetalhe := {}
aadd(aDetalhe, {"G1_COD"   , aParamSb1[1][1]  , NIL})
aadd(aDetalhe, {"G1_COMP"  , aParamSb1[3][1]  , NIL})
aadd(aDetalhe, {"G1_QUANT" , nQtdeEm          , NIL})
aadd(aDetalhe, {"G1_FIXVAR", "V"              , NIL})
aadd(aDetalhe, {"G1_REVFIM", "ZZZ"            , NIL})
aadd(aDetalhe, {"G1_NIV"   , "01"             , NIL})
aadd(aDetalhe, {"G1_NIVINV", "99"             , NIL})
aadd(aDetalhe, {"G1_INI"   , dDataBase        , NIL})
aadd(aDetalhe, {"G1_FIM"   , cTod("31/12/49") , NIL})
aadd(aItem,aDetalhe)

lMsErroAuto := .F.
MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,3)

If lMsErroAuto
	//	If AllTrim(Upper(FunName())) == 'CFGX019'
	MsgStop("Nao foi possivel gerar a estrutura")
	MostraErro()
	//	Else
	//		cLocalLog   := "\CfmLogTr\"
	//		MakeDir(cLocalLog)
	//		cNomeArq := CriaTrab(,.f.)+".LOG"
	//		cRetErro := MostraErro(cLocalLog,cNomeArq)
	//	EndIf
	//	ConOut(cRetErro)
	lRet := .F.
	DisarmTransaction()
	Break
	
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmCompl  | Autor: Celso Ferrone Martins  | Data: 08/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function CfmCompl(cSb1Cod)

If SB5->(DbSeek(xFilial("SB5")+cSb1Cod))

	cPolicia  := SB5->B5_PRODPF
	cExercito := SB5->B5_PRODEX
 	cCodOnu   := SB5->B5_ONU
	cItemOnu  := SB5->B5_ITEM
	cB5Densid := SB5->B5_DENSID

	cQuery := " SELECT * FROM " + RetSqlName("SB1")
	cQuery += " WHERE "
	cQuery += "    D_E_L_E_T_ <> '*' "
	cQuery += "    AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += "    AND B1_VQ_MP  = '"+cSb1Cod+"'"

	cQuery := ChangeQuery(cQuery)
	
	If Select("TMPPF") > 0
		TMPPF->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TMPPF"

	While !TMPPF->(Eof())
		IncProc()
		If SB5->(DbSeek(xFilial("SB5")+TMPPF->B1_COD))
			RecLock("SB5",.F.)
			SB5->B5_PRODPF := cPolicia
			SB5->B5_PRODEX := cExercito
			SB5->B5_ONU    := cCodOnu
			SB5->B5_ITEM   := cItemOnu
			SB5->B5_DENSID := cB5Densid
			MsUnLock()
		EndIf
		TMPPF->(DbSkip())
	EndDo

	If Select("TMPPF") > 0
		TMPPF->(DbCloseArea())
	EndIf

EndIf

Return()
