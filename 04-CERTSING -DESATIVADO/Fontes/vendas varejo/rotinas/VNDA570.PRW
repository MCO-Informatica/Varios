#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} VNDA570

Funcao criada para imprimir etiqueta em impressora térmica   

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function VNDA570(cPed,cPrintEtq)
	Local aArea		:= GetArea()
	Local cRast 	:= ""
	Local cCtrCorr	:= GetNewPar("MV_XCTRCOR", "0000000000")
	Local oPrinter	:= nil
	Local nLin		:= 0
	Local nCol		:= 0
	Local cProdCorr	:= ""
	Local oFont7	:= nil
	Local oFont7N	:= nil
	Local oFont11	:= nil
	Local oFont11N	:= nil
	
	Default cPed		:= ""
	Default cPrintEtq	:= GetNewPar("MV_XPRTETQ", "Brother TD-4000")		 					
	
	PAG->(DbSetOrder(3))
	
	If PAG->(DbSeek(xFilial("PAG")+cPed))
		cRast := PAG->PAG_CODRAS	
	EndIf
	
	If !Empty(cRast)
		
		SC5->(DbSetOrder(1))
		SC6->(DbSetOrder(1))			
		SB1->(DbSetOrder(1))			
		SA1->(DbSetOrder(1))
		SA2->(DbSetOrder(1))
		DAI->(DbSetOrder(4))
		SA4->(DbSetOrder(1))
		
		SC5->(DbSeek(xFilial("SC5")+PAG->PAG_CODPED))
		SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		DAI->(DbSeek(xFilial("DAI")+SC5->C5_NUM))
		If SC5->C5_TIPO $ "D,B"
			SA2->(DbSeek(xFilial("SA2")+DAI->(DAI_CLIENT+DAI_LOJA)))
		Else
			SA1->(DbSeek(xFilial("SA1")+DAI->(DAI_CLIENT+DAI_LOJA)))
		EndIf
		SA4->(DbSeek(xFilial("SA4")+SC5->C5_TRANSP))
		
		cProdCorr := Alltrim(SA4->A4_XCODCOR)
		
		oPrinter := FwMsprinter():New("etqfat",nil,.F.,nil,.T.,.F.)
		oPrinter:cPrinter 	:= cPrintEtq 
	
		oFont5	:= Tfont():New("Arial",5,5,,.f.,,,,.f.,.f.)
		
		oFont4N	:= Tfont():New("Arial",4,4,,.t.,,,,.f.,.f.)
		
		oFont7	:= Tfont():New("Arial",7,7,,.f.,,,,.f.,.f.)
		oFont7N	:= Tfont():New("Arial",7,7,,.t.,,,,.f.,.f.)

		oFont11	:= Tfont():New("Arial",11,11,,.f.,,,,.f.,.f.)
		oFont11N	:= Tfont():New("Arial",11,11,,.t.,,,,.f.,.f.)
		
		oPrinter:StartPage()
		
		oPrinter:SayBitmap ( 11, 4, cProdCorr+".png",100,73) 
		
		nLin	:= 50
		nCol	:= 25
		
		oPrinter:Say(nLin,nCol,cCtrCorr+"-DR/SPM",oFont5)
		nLin+= 10
		nCol:= 15
		oPrinter:Say(nLin,nCol,Alltrim(SM0->M0_NOMECOM),oFont4N)
		
		nLin	:= 020
		nCol	:= 120
		
		oPrinter:Say(nLin,nCol,"Contrato: "+cCtrCorr+"  DR/SPM",oFont7N)
		nLin+= 10
		oPrinter:Say(nLin,nCol,Alltrim(SM0->M0_NOMECOM),oFont7)		
		nLin+= 10
		oPrinter:Say(nLin,nCol,Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_COMPENT),oFont7)		
		nLin+= 10
		oPrinter:Say(nLin,nCol,Alltrim(SM0->M0_BAIRENT),oFont7)		
		nLin+= 10
		oPrinter:Say(nLin,nCol,Alltrim(SM0->M0_CEPENT)+" "+Alltrim(SM0->M0_CIDENT)+"-"+Alltrim(SM0->M0_ESTENT),oFont7)		
		nLin+= 10
		oPrinter:Say(nLin,nCol,"Nota Fiscal: "+DAI->DAI_SERIE+"\"+DAI->DAI_NFISCA ,oFont7N)
		nLin+= 10
		oPrinter:Say(nLin,nCol,"Código PLP: "+Alltrim(PAG->PAG_CODPLP) ,oFont7N)
		nLin+= 35
		
		nCol	:= 100 //120
		oPrinter:Say(nLin,nCol,cRast,oFont7N)
		nLin+= 60
		
		nCol	:= 40		
		//oPrinter:Code128C(nLin, nCol, cRast, 70 )
		oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,10/*nRow*/ ,3/*nCol*/ ,cRast  /*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
		
		nLin+= 20
		
		If SC5->C5_TIPO == "D"
			cNome	:= SA2->A2_NOME
			cEnd	:= SA2->A2_END
			cNum	:= ""
			cCompl	:= SA2->A2_ENDCOMP
			
			VD570END(@cEnd,@cCompl,@cNum)

			cCompl	:= Alltrim(cCompl)		
			cBairro	:= SA2->A2_BAIRRO
			cCep	:= SA2->A2_CEP
			cMun	:= SA2->A2_MUN
			cEst	:= SA2->A2_EST
		ElseIF SC5->C5_TIPO == "B"
			cNome	:= SA2->A2_NOME
			cEnd	:= SA2->A2_ENDENT
			cNum	:= ""
			cCompl	:= SA2->A2_COMPLEE
			
			VD570END(@cEnd,@cCompl,@cNum)

			cCompl	:= Alltrim(cCompl)		
			cBairro	:= SA2->A2_BAIRROE
			cCep	:= SA2->A2_CEPENT
			cMun	:= SA2->A2_MUNE
			cEst	:= SA2->A2_ESTE
		Else
			cNome	:= SA1->A1_NOME
			cEnd	:= SA1->A1_ENDENT 
			cNum	:= ""
			cCompl	:= 	SA1->A1_COMPLEM
			
			If SA1->A1_XNUMENT > 0 
				cNum	:= Alltrim(Str(SA1->A1_XNUMENT))
				cCompl	:= SA1->A1_XCOMPEN
			EndIf
			
			VD570END(@cEnd,@cCompl,@cNum)
			
			cCompl	:= Alltrim(cCompl)
			cBairro	:= SA1->A1_BAIRROE
			cCep	:= SA1->A1_CEPE
			cMun	:= SA1->A1_MUNE 
			cEst	:= SA1->A1_ESTE
		EndIf 		
		
		nCol	:= 004
		oPrinter:Say(nLin,nCol,"Destinatário:",oFont11N)
		nLin+= 10
		oPrinter:Say(nLin,nCol,Alltrim(cNome),oFont11)
		nLin+= 10				
		oPrinter:Say(nLin,nCol,Alltrim(cEnd)+" "+Alltrim(cNum),oFont11)
		nLin+= 10				
		If !Empty(cCompl)
			oPrinter:Say(nLin,nCol,Alltrim(cCompl),oFont11)
			nLin+= 10
		EndIf
		oPrinter:Say(nLin,nCol,Alltrim(cBairro),oFont11)
		nLin+= 10				
		oPrinter:Say(nLin,nCol,Alltrim(cCep)+" "+Alltrim(cMun)+"-"+cEst,oFont11)
		nLin+= 10				
		oPrinter:Say(nLin,nCol,"Carga: "+DAI->DAI_COD,oFont11)
		nLin+= 10
		
		nCol	:= 110
		oPrinter:Say(nLin,nCol,Alltrim(cCep),oFont7N)
		nLin+= 60
		
		nCol	:= 70		
		//oPrinter:Code128C(nLin, nCol, Alltrim(cCep), 70 )
		oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,23/*nRow*/ ,7/*nCol*/ ,Alltrim(cCep)  /*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
		
		oPrinter:EndPage()
	
		oPrinter:Preview()
		
		FreeObj(oPrinter)
	EndIf
	
	RestArea(aArea)
		
Return(cRast)

/*/{Protheus.doc} VD570END

Funcao statica criada para verificar endereço numero e complemento do endereço do cliente   

@author Totvs SM - David
@since 20/05/2014
@version P11

/*/
Static Function VD570END(cEnd,cCompl,cNum)
	Local nI	:= 0
	Local nAt	:= 0
	
	If Empty(cNum)
		cEnd	:= Alltrim(cEnd)
		cEnd	:= StrTran(cEnd,"/",",")
		cEnd	:= StrTran(cEnd,"-",",")
		nAt		:= at(",",cEnd)
		
		If nAt > 0
			cNum := Alltrim(SubStr(cEnd,nAt+1))
			
			If !Empty(cNum)
				cEnd	:= Alltrim(SubStr(cEnd,1,nAt-1))
				For nI:=1 to Len(cNum)
					If !SubStr(cNum,nI,1) $ ' 0123456789' 
						If Empty(cCompl)
							cCompl	:= Alltrim(SubStr(cNum,nI))
						EndIf
						cNum 	:= Alltrim(SubStr(cNum,1,nI-1))
						exit
					EndIf
				Next
			EndIf
		EndIf
	Else
		cEnd := StrTran(cEnd,Alltrim(cNum),"")	
		If !Empty(cCompl)
			cEnd := StrTran(cEnd,Alltrim(cCompl),"")
		EndIf
	EndIf
	
	If Len(cEnd) > 50
		cEnd 	:= SubStr(cEnd,1,50)
		cCompl	:= Alltrim(SubStr(cEnd,51))+"-"+Alltrim(cCompl)
	EndIf
	
	cCompl := Alltrim(cCompl)
	
	If Len(cCompl) > 30
		cCompl := SubStr(cCompl,1,30)
	EndIf
	
Return