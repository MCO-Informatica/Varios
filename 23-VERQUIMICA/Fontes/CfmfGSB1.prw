#Include "Protheus.ch"
/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: CfmfGSB1 | Autor: Celso Ferrone Martins  | Data: 09/06/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Gatilho para preenchimento do cadastro de produtos        |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/

User Function CfmfGSB1(cTipo)

Local cRet := Space(15)
Local aAreaSb1 := SB1->(GetArea())
Local aAreaSb5 := SB5->(GetArea())
Local aAreaSx3 := SX3->(GetArea())
Local cB1Cod    := ""
Local cB1CodMp  := ""
Local cB1CodEm  := ""
Local cB1Desc   := ""
Local cB1DescMp := ""
Local cB1DescEm := ""
Local cB1Origem := ""
Local cMSB1Cod := ""
Local lExistPrd := .T.

Local aCpoEm   := {}
Local aCpoMpB1 := 	{;
	{"B1_UM"     ,"C"},;
	{"B1_SEGUM"  ,"C"},;
	{"B1_CONV"   ,"N"},;
	{"B1_TIPCONV","C"},;
	{"B1_GRUPO"  ,"C"},;
	{"B1_PICM"   ,"N"},;
	{"B1_IPI"    ,"N"},;
	{"B1_POSIPI" ,"C"},;
	{"B1_VQ_ICMS","N"},;
	{"B1_VQ_IPI" ,"N"},;
	{"B1_VQ_COD" ,"C"},;
	{"B1_ORIGEM" ,"C"},;
	{"B1_RASTRO" ,"C"},;
	{"B1_LOCALIZ","C"} ;
					}

Local aCpoMpB5 := 	{;
	{"B5_ONU"    ,"C"},;
	{"B5_ITEM"   ,"C"},;
	{"B5_PRODPF" ,"C"},;
	{"B5_PRODEX" ,"C"},;
	{"B5_DENSID" ,"N"} ;
					}
					
DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("SB5") ; DbSetOrder(1)

If cTipo == "MP"
	cRet := M->B1_VQ_MP
ElseIf cTipo == "EM"
	cRet := M->B1_VQ_EM
EndIf

If M->B1_TIPO == "PA"
	//	Campos da Matéria Prima
	If SB1->(DbSeek(xFilial("SB1")+M->B1_VQ_MP))
		cB1CodMp := SubStr(SB1->B1_COD,3,5)
		cB1DescMp := AllTrim(SB1->B1_DESC)
		cB1Origem := SB1->B1_ORIGEM
		For nX := 1 To Len(aCpoMpB1)
			&("M->"+aCpoMpB1[nX][1]) := &("SB1->"+aCpoMpB1[nX][1])
		Next Nx
		If Empty(M->B1_LOCPAD)
			M->B1_LOCPAD := "01"
		EndIf
		If SB5->(DbSeek(xFilial("SB5")+M->B1_VQ_MP))
			For nX := 1 To Len(aCpoMpB5)
				If aCpoMpB5[nX][2] == "C"	
					If Empty(&("M->"+aCpoMpB5[nX][1])) .Or. aCpoMpB5[nX][1] $ "B5_PRODPF/B5_PRODEX"
						&("M->"+aCpoMpB5[nX][1]) := &("SB5->"+aCpoMpB5[nX][1])
					EndIf
				ElseIf aCpoMpB5[nX][2] == "N"
					If &("M->"+aCpoMpB5[nX][1]) == 0
						&("M->"+aCpoMpB5[nX][1]) := &("SB5->"+aCpoMpB5[nX][1])
					EndIf
				EndIf
				
			Next Nx
		EndIf
	EndIf 
	
	//  Campos da Matéria Embalagem
	If SB1->(DbSeek(xFilial("SB1")+M->B1_VQ_EM))
		cB1CodEM := SubStr(SB1->B1_COD,3,3)
		cB1DescEM := AllTrim(SB1->B1_DESC)
	EndIf
	

	If !Empty(cB1CodMp) .And. !Empty(cB1CodEM) .and. inclui
		cMSB1Cod := "01"+cB1CodMp+cB1CodEM+cB1Origem
		If !SB1->(DbSeek(xFilial("SB1")+cMSB1Cod))
			oMdlSb1 := fwModelActive()
			oSb1Master := oMdlSb1:getModel("SB1MASTER")
			oSb1Master:setValue("B1_COD"   , cMSB1Cod)
			oSb1Master:setValue("B1_CODBAR", cMSB1Cod)
		Else
			MsgAlert("Já existe o produto "+cMSB1Cod+". Favor verificar!!!")
		EndIf
	EndIf
	
	If Empty(M->B1_DESC) .And. !Empty(cB1DescMp) .And. !Empty(cB1DescEM)
		M->B1_DESC := cB1DescMp + " - " + cB1DescEM
	EndIf
	
	If cTipo == "MPDE"
		cRet := cB1DescMp
	ElseIf cTipo == "EMDE"
		cRet := cB1DescEm
	EndIf
EndIf

SB1->(RestArea(aAreaSb1))
SB5->(RestArea(aAreaSb5))
SX3->(RestArea(aAreaSx3))

Return(cRet)
