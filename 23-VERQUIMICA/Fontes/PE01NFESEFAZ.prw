#Include "Protheus.Ch"

/*
==========================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+------------------------+------------------------------+------------+||
||| Programa: PE01NFESEFAZ | Autor: Celso Ferrone Martins | 23/03/2015 |||
||+-----------+------------+------------------------------+------------+||
||| Descricao | PE para customizacao na transmissao da NF (SEFAZ).     |||
||+-----------+--------------------------------------------------------+||
||| Alteracao |                                                        |||
||+-----------+--------------------------------------------------------+||
||| Uso       |                                                        |||
||+-----------+--------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==========================================================================
*/
User Function PE01NFESEFAZ()


Local aRetorno := {}
Local aContain := {}

Local aProd		:= PARAMIXB[1]
Local cMensCli	:= PARAMIXB[2]
Local cMensFis	:= PARAMIXB[3]
Local aDest		:= PARAMIXB[4]
Local aNota   	:= PARAMIXB[5]
Local aInfoItem	:= PARAMIXB[6]
Local aDupl		:= PARAMIXB[7]
Local aTransp	:= PARAMIXB[8]
Local aEntrega	:= PARAMIXB[9]
Local aRetirada	:= PARAMIXB[10]
Local aVeiculo	:= PARAMIXB[11]
Local aReboque	:= PARAMIXB[12]
Local aNfVincRur := PARAMIXB[13]
Local aEspVol   := PARAMIXB[14]
Local aNfVinc   := PARAMIXB[15]
Local AdetPag   := PARAMIXB[16]
Local aObsCont  := PARAMIXB[17]


Local aAreaSwn  := SWN->(GetArea())

Local cTipoNf   := ""

DbSelectArea("SWN") ; DbSetOrder(2)

For nX := 1 To Len(aProd)
	If AllTrim(aProd[nX][7]) < "5000"
		cTipoNf := "E"
	Else
		cTipoNf := "S"
	EndIf
Next nX


If cTipoNf == "E"
	////Inclusão de containers na mensagem da nota
	If SWN->(DbSeek(xFilial("SWN")+aNota[2]+aNota[1]))
		SJD->(DbSetOrder(1))
		If SJD->(DbSeek(xFilial("SJD")+SWN->WN_HAWB))
			While !SJD->(EoF()) .And. SWN->WN_HAWB == SJD->JD_HAWB
				aaDD(aContain, SJD->JD_CONTAIN)
				SJD->(DbSkip())
			EndDo
		EndIf
		If AllTrim(SWN->WN_TIPO_NF) == "6"
			_cHawb := SWN->WN_HAWB
			_cMsgEic += "Valor total R$ "+AllTrim(Str(SWN->WN_VALOR))+;
			" - "+AllTrim(Posicione("SB1",1,xFilial("SB1")+SWN->WN_PRODUTO,"B1_DESC"))+;
			" ONU "+AllTrim(Posicione("SB5",1,xFilial("SB5")+SWN->WN_PRODUTO,"B5_ONU"))
			SWN->(DbSetOrder(3))
			If SWN->(DbSeek(xFilial("SWN")+_cHawb+"1"))
				_cMsgEic += " - Impostos já destacados na NF mãe "+SWN->WN_DOC
			EndIf
			cMensCli := _cMsgEic+" - "+cMensCli
		Else
			If Len(aContain) > 0
				For i := 1 To Len(aContain)
					If i == 1
						_cMsgEic += "CONTAINERS: "+AllTrim(aContain[i])
					Else
						_cMsgEic += " - "+AllTrim(aContain[i])
					EndIf
				Next
			EndIf
			While !SWN->(EoF()) .And. SWN->WN_DOC == aNota[2] .And. SWN->WN_SERIE == aNota[1]
				_cMsgEic += " - Valor CIF R$ "+AllTrim(Str(SWN->WN_CIF))+;
				", II R$ "+AllTrim(Str(SWN->WN_VLDEVII))+;
				", PIS R$ "+AllTrim(Str(SWN->WN_VLRPIS))+;
				", COFINS R$ "+AllTrim(Str(SWN->WN_VLRCOF))+;
				", TAXA SISCOMEX R$ "+AllTrim(Str(SWN->WN_DESPICM-SWN->WN_AFRMM))+;
				", AFRMM R$ "+AllTrim(Str(SWN->WN_AFRMM))+;
				", ICMS R$ "+AllTrim(Str(SWN->WN_VL_ICM))+;
				" - "+AllTrim(Posicione("SB1",1,xFilial("SB1")+SWN->WN_PRODUTO,"B1_DESC"))+;
				" ONU "+AllTrim(Posicione("SB5",1,xFilial("SB5")+SWN->WN_PRODUTO,"B5_ONU"))
				cMensCli := _cMsgEic+" - "+cMensCli
				SWN->(DbSkip())
			EndDo
		EndIf
	EndIf

	For nX := 1 To Len(aProd)
		If SB1->(DbSeek(xFilial("SB1")+aProd[nX][2]))
			If SD1->(DbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)+aProd[nX][2]+AllTrim(StrZero(aProd[nX][1],4))))
				If !Empty(SB1->B1_SEGUM) .And. SB1->B1_CONV > 0 .And. !Empty(SB1->B1_TIPCONV) .And. AllTrim(SD1->D1_VQ_UM) == "L"
					aProd[nX][11] := SB1->B1_SEGUM
					If SB1->B1_TIPCONV == "D"
						aProd[nX][12] := Round(aProd[nX][09] / SB1->B1_CONV,2)
					Else
						aProd[nX][12] := Round(aProd[nX][09] * SB1->B1_CONV,2)
					EndIf
				EndIf
			EndIf
		EndIf
	Next nX

EndIf

If !Empty(aDest[15])
	If Empty(cMensCli)
		cMensCli += "Inscrição SUFRAMA: "+aDest[15]+" "
	Else
		cMensCli += " - Inscrição SUFRAMA: "+aDest[15]+" "
	EndIf
EndIf

aadd(aRetorno,aProd)
aadd(aRetorno,cMensCli)
aadd(aRetorno,cMensFis)
aadd(aRetorno,aDest)
aadd(aRetorno,aNota)
aadd(aRetorno,aInfoItem)
aadd(aRetorno,aDupl)
aadd(aRetorno,aTransp)
aadd(aRetorno,aEntrega)
aadd(aRetorno,aRetirada)
aadd(aRetorno,aVeiculo)
aadd(aRetorno,aReboque)
aadd(aRetorno,aNfVincRur)
aadd(aRetorno,aEspVol)
aadd(aRetorno,aNfVinc)
aadd(aRetorno,AdetPag)
aadd(aRetorno,aObsCont)


SWN->(RestArea(aAreaSwn))


Return(aRetorno)
