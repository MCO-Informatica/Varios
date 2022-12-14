User Function MATUCOMP()

cEntSai := ParamIXB[1]
cDoc    := ParamIXB[3]
cSerie  := ParamIXB[2]
cCliefor:= ParamIXB[4]
cLoja   := ParamIXB[5]
//lCDT	:= CDT->(dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
lCDG	:= CDG->(dbSeek(xFilial("CDG")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
//lCDC	:= CDC->(dbSeek(xFilial("CDC")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
//lCDD	:= CDD->(dbSeek(xFilial("CDD")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
//lCDE	:= CDE->(dbSeek(xFilial("CDE")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
//lCDG	:= CDG->(dbSeek(xFilial("CDG")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
cGeraFin := Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_DUPLIC")


If !lCDG .And. cGeraFin$"S" .AND. cSerie == "0"
	//----> REGISTRO C111 E C115 PIS
	RecLock("CDG",.T.)
	CDG->CDG_FILIAL	:= xFilial("CDG")
	CDG->CDG_TPMOV	:= cEntSai
	CDG->CDG_DOC	:= cDoc
	CDG->CDG_SERIE	:= cSerie
	CDG->CDG_CLIFOR	:= cClieFor
	CDG->CDG_LOJA	:= cLoja
	CDG->CDG_IFCOMP := "000003"
	CDG->CDG_PROCES	:= "50075792820194036110"
	CDG->CDG_TPPROC := "1"
	CDG->CDG_ITPROC := "00000001"
	CDG->CDG_VALOR	:= SD2->D2_VALICM
	CDG->CDG_ITEM	:= SD2->D2_ITEM	
	CDG->(MsUnLock())
	FkCommit()

	//----> REGISTRO C111 E C115 COFINS
	RecLock("CDG",.T.)
	CDG->CDG_FILIAL	:= xFilial("CDG")
	CDG->CDG_TPMOV	:= cEntSai
	CDG->CDG_DOC	:= cDoc
	CDG->CDG_SERIE	:= cSerie
	CDG->CDG_CLIFOR	:= cClieFor
	CDG->CDG_LOJA	:= cLoja
	CDG->CDG_IFCOMP := "000003"
	CDG->CDG_PROCES	:= "50075792820194036110"
	CDG->CDG_TPPROC := "1"
	CDG->CDG_ITPROC := "00000002"
	CDG->CDG_VALOR	:= SD2->D2_VALICM
	CDG->CDG_ITEM	:= SD2->D2_ITEM	
	CDG->(MsUnLock())
	FkCommit()
EndIf

/*
If !lCDT	
	//----> REGISTRO C110
	RecLock("CDT",.T.)
	CDT->CDT_FILIAL	:= xFilial("CDT")	
	CDT->CDT_TPMOV	:= cEntSai	
	CDT->CDT_DOC	:= cDoc	
	CDT->CDT_SERIE	:= cSerie	
	CDT->CDT_CLIFOR	:= cClieFor	
	CDT->CDT_LOJA	:= cLoja									
	CDT->CDT_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
Else
	RecLock("CDT",.F.)
	CDT->CDT_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
EndIf

If !lCDC	
	//----> REGISTRO C112
	RecLock("CDC",.T.)
	CDC->CDC_FILIAL	:= xFilial("CDC")
	CDC->CDC_TPMOV	:= cEntSai
	CDC->CDC_DOC	:= cDoc
	CDC->CDC_SERIE	:= cSerie
	CDC->CDC_CLIFOR	:= cClieFor
	CDC->CDC_LOJA	:= cLoja
	CDC->CDC_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
Else
	RecLock("CDC",.F.)
	CDC->CDC_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
EndIf

If !lCDD
	//----> REGISTRO C113
	RecLock("CDD",.T.)
	CDD->CDD_FILIAL	:= xFilial("CDD")
	CDD->CDD_TPMOV	:= cEntSai
	CDD->CDD_DOC	:= cDoc
	CDD->CDD_SERIE	:= cSerie
	CDD->CDD_CLIFOR	:= cClieFor
	CDD->CDD_LOJA	:= cLoja
	CDD->CDD_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
Else
	RecLock("CDD",.F.)
	CDD->CDD_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
EndIf
	
If !lCDE
	//----> REGISTRO C114
	RecLock("CDE",.T.)
	CDE->CDE_FILIAL	:= xFilial("CDE")
	CDE->CDE_TPMOV	:= cEntSai
	CDE->CDE_DOC	:= cDoc
	CDE->CDE_SERIE	:= cSerie
	CDE->CDE_CLIFOR	:= cClieFor
	CDE->CDE_LOJA	:= cLoja
	CDE->CDE_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
Else
	RecLock("CDE",.F.)
	CDE->CDE_IFCOMP := "000002"
	MsUnLock()
	FkCommit()
EndIf
*/
Return
