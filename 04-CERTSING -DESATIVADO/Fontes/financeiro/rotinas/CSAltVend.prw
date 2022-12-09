#include 'protheus.ch'
#include 'parmtype.ch'

user function CSAltVend(cArq,lDebug,lLog)

Local nHdl

Default lDebug 	:= .F.
Default lLog	:= .F.

dbSelectArea("SC5")
//SC5->(dbOrderNickName("NUMPEDGAR"))
SC5->(dbSetOrder(1))

dbSelectArea("SC6")
SC6->(dbSetOrder(1))

dbSelectArea("SF2")
SF2->(dbSetOrder(1))

dbSelectArea("SE1")
SE1->(dbSetOrder(1))

If File(cArq)
	nHdl := FT_FUse(cArq)
	If nHdl == -1
		MsgStop("ocorreu um erro na abertura do arquivo " + AllTrim(cArq))
		Return
	EndIf
	
	Processa({|| ProcAltVen(lDebug)}, "Alterando CodRev","Alterando vendedores... ", .F.)
	
Else
	MsgStop("Arquivo não encontrado " + AllTrim(cArq))
	Return
EndIf

Static Function ProcAltVen(lDebug)

Local aHeader	:= {}
Local aDados	:= {}
Local cVend1	:= ""
Local cVend2	:= ""
Local cLinha	:= ""
Local lMsg		:= .T.
Local Ni		:= 0 
Local aLog		:= {{"SC5",{{"C5_NUM","C5_XNPSITE","C5_XCODREV","C5_VEND2","C5_VEND1","R_E_C_N_O_"}}},;
					{"SC6",{{"C6_FILIAL","C6_NUM","C6_CLI","C6_LOJA","C6_ITEM","C6_PRODUTO","R_E_C_N_O_"}}},;
					{"SF2",{{"F2_FILIAL","F2_DOC","F2_SERIE","F2_VEND1","F2_VEND2","R_E_C_N_O_"}}},;
					{"SE1",{{"E1_FILIAL","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_VEND1","E1_VEND2","R_E_C_N_O_"}}},;
					{"ERRO",{{"Mensagem"}}};
					}

ProcRegua(FT_FLastRec())

While !FT_FEOF()

	cLinha := FT_FReadLn()
	IncProc("Carregando linha " + cValToChar(FT_FRecno()))
	
	If FT_FRecno() == 1
		aHeader := StrTokArr(cLinha,";")
		FT_FSkip()
		Loop
	EndIf
	
	aDados 	 := StrTokArr(cLinha,";")
	//cPedSite := aDados[aScan(aHeader,{|z| z == "C5_CHVBPAG"})]
	cPedSite := aDados[aScan(aHeader,{|z| z == "C5_NUM"})]
	cCodRev	 := aDados[aScan(aHeader,{|z| z == "C5_XCODREV"})]
	cVend1	 := aDados[aScan(aHeader,{|z| z == "C5_VEND1"})]
	cVend2	 := aDados[aScan(aHeader,{|z| z == "C5_VEND2"})]

	If SC5->(dbSeek(xFilial("SC5")+cPedSite))
		If !lDebug
			RecLock("SC5",.F.)
				SC5->C5_XCODREV := Iif(cCodRev != "0",cCodRev,"")
				SC5->C5_VEND2	:= SC5->C5_VEND1
				SC5->C5_VEND1	:= cVend1
			SC5->(MsUnlock())
		EndIf
		If lMsg .And. lDebug
			Iif(Aviso("Pedido:" + SC5->C5_NUM + "(SC5/SC6)","SC5->C5_NUM: " + SC5->C5_NUM + "-" + cPedSite + CHR(13)+CHR(10)+;
			"SC5->C5_XCODREV: " + cCodRev + CHR(13)+CHR(10) + "SC5->C5_VEND2: " + SC5->C5_VEND1 + CHR(13)+CHR(10) +;
			"SC5->C5_VEND1: " + cVend1,{"Skip Msg","Ok"})==1,lMsg:=.F.,lMsg:=.T.)
		EndIf
		aAdd(aLog[aScan(aLog,{|x| x[1] == "SC5"})][2],{SC5->C5_NUM,SC5->C5_CHVBPAG,SC5->C5_XCODREV,SC5->C5_VEND2,SC5->C5_VEND1,cValToChar(SC5->(Recno()))})
		
		If SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
		
			cFilProc := SC5->C5_FILIAL
			cNumPed	 := SC5->C5_NUM
			cCliSC6	 := SC5->C5_CLIENTE
			cLojCliC6:= SC5->C5_LOJACLI
			lMsg := .T.
			
			While SC6->(!EoF()) .And. SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_CLI + SC6->C6_LOJA == cFilProc + cNumPed + cCliSC6 + cLojCliC6
			
				aAdd(aLog[aScan(aLog,{|x| x[1] == "SC6"})][2],{SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_ITEM,SC6->C6_PRODUTO,cValToChar(SC6->(Recno()))})
		
				If SF2->(dbSeek(xFilial("SF2")+SC6->C6_NOTA+SC6->C6_SERIE+SC6->C6_CLI+SC6->C6_LOJA))
					If !lDebug
						RecLock("SF2",.F.)
							SF2->F2_VEND2	:= SF2->F2_VEND1
							SF2->F2_VEND1	:= SC5->C5_VEND1
						SF2->(MsUnlock())
					EndIf
					If lMsg  .And. lDebug
						iif(Aviso("Pedido:" + SC5->C5_NUM + "(SF2)","SF2->F2_DOC: " + SF2->F2_DOC + CHR(13)+CHR(10)+;
							"SF2->F2_VEND2: " + SF2->F2_VEND2 + CHR(13)+CHR(10) +;
							"SF2->F2_VEND1: " + SF2->F2_VEND1,{"Skip Msg","Ok"})==1,lMsg:=.F.,lMsg:=.T.)
					EndIf
					
					aAdd(aLog[aScan(aLog,{|x| x[1] == "SF2"})][2],{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_VEND1,SF2->F2_VEND2,SF2->(cValToChar(Recno()))})
					
					If SE1->(dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DUPL))		
					
						lMsg := .T.
						While SE1->(!Eof()) .And. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM == xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL
						
							aAdd(aLog[aScan(aLog,{|x| x[1] == "SE1"})][2],{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_VEND1,SE1->E1_VEND2,SE1->(cValToChar(Recno()))})
						
							If !lDebug
								RecLock("SE1",.F.)
									SE1->E1_VEND2 := SE1->E1_VEND1
									SE1->E1_VEND1 := SF2->F2_VEND1
								SE1->(MsUnlock())
							EndIf
							SE1->(dbSkip())
							If lMsg .And. lDebug
								iif(Aviso("Pedido:" + SC5->C5_NUM + "(SE1)","SF2->F2_DOC: " + SF2->F2_DOC + CHR(13)+CHR(10)+;
									"SF2->F2_VEND2: " + SF2->F2_VEND2 + CHR(13)+CHR(10) +;
									"SF2->F2_VEND1: " + SF2->F2_VEND1,{"Skip Msg","Ok"})==1,lMsg:=.F.,lMsg:=.T.)
							EndIf
						EndDo
					Else
						aAdd(aLog[aScan(aLog,{|x| x[1] == "ERRO"})][2],{"Título [SE1]" + SF2->F2_DUPL +"/"+ SF2->F2_PREFIXO + " não encontrado na filial " + cFilAnt })
					EndIf
					
				EndIf
				
				SC6->(dbSkip())
			EndDo
		Else
			aAdd(aLog[aScan(aLog,{|x| x[1] == "ERRO"})][2],{"Nota Fiscal [SC6]" + SC6->C6_NOTA +"/"+SC6->C6_SERIE+ " não encontrado na filial " + cFilAnt })
		EndIf
	Else
		aAdd(aLog[aScan(aLog,{|x| x[1] == "ERRO"})][2],{"Pedido " + cPedSite + " não encontrado na filial " + cFilAnt })
	EndIf
	
	FT_FSkip()
EndDo 

If lLog
	For Ni := 1 To Len(aLog)
		GravaLog(aLog[Ni])
	Next
EndIf
	
return

Static Function GravaLog(aLog)

Local cArqLog	:= "csaltvend.log"
Local cDirLog	:= "C:\Data\Log\"
Local nHdlLog	:= 0
Local Nx

If !File(cDirLog + cArqLog) 
	If !ExistDir(cDirLog)
		If MakeDir(cDirLog) == 0
			cArqLog := cDirLog + cArqLog
		Else
			cArqLog := GetSrvProfString( "Startpath", "" ) + cArqLog
		EndIf
	EndIf
	nHdlLog := FCreate(cDirLog + cArqLog)
Else
	nHdlLog := FOpen(cDirLog + cArqLog)
	If nHdlLog < 0
		nHdlLog := FOpen(GetSrvProfString( "Startpath", "" ) + cArqLog)
		If nHdlLog < 0
			MsgStop("O arquivo não pode ser aberto.","Erro")
			Return
		EndIf
	EndIf
EndIf

If Len(aLog[2]) > 1
	For Nx := 1 To Len(aLog[2])
		For Ny := 1 To Len(aLog[2][Nx])
			FWrite(nHdlLog,AllTrim(aLog[2][Nx][Ny])+";")
		Next
		FWrite(nHdlLog,CHR(13)+CHR(10))
	Next
	FWrite(nHldLog,"**************************************************")
EndIf

FClose(nHdlLog)

Return