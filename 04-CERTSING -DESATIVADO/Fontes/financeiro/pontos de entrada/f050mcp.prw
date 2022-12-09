#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050MCP  ³Autor  ³Douglas Pedroso     ³ Data ³  18-11-2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para Habilitar os campos do contas a pg    º±±
±±º          ³no momento da alteração.								      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Contas a pagar		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F050MCP() 

aCpos	:=	{}

If (!Empty(SE2->E2_BAIXA) .or. SE2->E2_TIPO $ MVISS+"/"+MVTAXA+"/"+MVINSS+"/"+"SES"+"/"+MVTAXA+"/"+MVISS+"/"+MVTXA .Or. ;
		"S" $ SE2->E2_LA .or. SE2->E2_IMPCHEQ == "S" .or. "GPE" $ SE2->E2_ORIGEM .Or.;
		"S" $ SE2->E2_RATEIO .or. SE2->E2_FATURA = "NOTFAT" .or. ;
		((SE2->E2_PRETPIS == "2" .or. SE2->E2_PRETCOF == "2" .or. SE2->E2_PRETCSL == "2")))

	If SE2->E2_SALDO = 0
		Help(" ",1,"FA050BAIXA")
		Return
	EndIf
	AADD(aCpos,"E2_VENCTO")
	AADD(aCpos,"E2_VENCREA")
	AADD(aCpos,"E2_HIST")
	AADD(aCpos,"E2_INDICE")
	AADD(aCpos,"E2_OP")
	AADD(aCpos,"E2_PORTADO")
	AADD(aCpos,"E2_FLUXO")
	AADD(aCpos,"E2_VALJUR")
	AADD(aCpos,"E2_PORCJUR")
	AADD(aCpos,"E2_CODRET")
	AADD(aCpos,"E2_DIRF")
		
	// So permite alterar a natureza, depois de contabilizado o titulo, se ela nao estiver 
	// preenchida
	If SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
		For nX := 1 To SED->(FCount())
			If "_CALC" $ SED->(FieldName(nX))
				lPode := !SED->(FieldGet(nX)) $ "1S" // So permite alterar se nao calcular impostos
				If !lPode // No primeiro campo que calcula impostos, nao permite alterar
					Exit
				Endif	
			Endif
		Next
	Endif	
	If Empty(SE2->E2_NATUREZ) .Or.;
		lPode
		Aadd(aCpos,"E2_NATUREZ")
	Endif
	//So permite alterar os campos abaixo se não houve baixa, ainda que tenha sido contabilizada
	//a inclusao do mesmo
	If Empty(SE2->E2_BAIXA)
		AADD(aCpos,"E2_ACRESC")
		AADD(aCpos,"E2_DECRESC")
	Endif		
Else
	AADD(aCpos,"E2_VENCTO")
	AADD(aCpos,"E2_VENCREA")
	AADD(aCpos,"E2_HIST")
	AADD(aCpos,"E2_INDICE")
	AADD(aCpos,"E2_OP")
	AADD(aCpos,"E2_PORTADO")
	AADD(aCpos,"E2_VALJUR")
	AADD(aCpos,"E2_PORCJUR")
	AADD(aCpos,"E2_VALOR")
	AADD(aCpos,"E2_IRRF")
	AADD(aCpos,"E2_ISS")
	AADD(aCpos,"E2_FLUXO")
	AADD(aCpos,"E2_INSS")
	AADD(aCpos,"E2_ACRESC")
	AADD(aCpos,"E2_DECRESC")
	AADD(aCpos,"E2_CODRET")
	AADD(aCpos,"E2_DIRF")
	AAdd(aCpos, "E2_PIS")
	AAdd(aCpos, "E2_COFINS")
	AAdd(aCpos, "E2_CSLL")
	// Nao permite alterar a natureza do titulo que reteve os impostos PIS/COFINS/CSL
	// do periodo, dele e de outros titulos.
	If SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
		If !((SED->ED_CALCPIS == "S" .OR. SED->ED_CALCCSL == "S" .OR. SED->ED_CALCCOF == "S") .and. ;
			(SE2->(E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) > 0 .and. ;
			STR(SE2->(E2_VRETPIS+E2_VRETCOF+E2_VRETCSL),17,2) != STR(SE2->(E2_PIS+E2_COFINS+E2_CSLL),17,2)))
			Aadd(aCpos,"E2_NATUREZ")
		Endif
	Endif	
EndIf

AADD(aCpos,"E2_CODBAR")
AADD(aCpos,"E2_VARIAC")
AADD(aCpos,"E2_PERIOD")
AADD(aCpos,"E2_CCD")
AADD(aCpos,"E2_ITEMD")
AADD(aCpos,"E2_CLVLDB")

Return(aCpos) 