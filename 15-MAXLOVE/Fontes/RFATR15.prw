#Include "avprint.ch"
#Include "Font.ch"
#Include "Protheus.ch"
#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR15  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 06/01/2010 ³±±                                                                 3
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Romaneio de Cobranca                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Max Love                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR15()

Private cPerg	:= "FATR151"
Private cNumDe	:= ""
ÅPrivate cNumAte	:= ""
Private dDtDe	:= ctod("  /  /  ")
Private dDtAte	:= ctod("  /  /  ")

_aRegs := {}

AAdd(_aRegs,{cPerg,"01","Do Romaneio ?     ","Do Romaneio ?     ","Do Romaneio ?     ","mv_ch0","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"02","Ate o Romaneio ?  ","Ate o Romaneio ?  ","Ate o Romaneio ?  ","mv_ch1","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"03","Da Serie ?        ","Da Emissao ?      ","Da Emissao ?      ","mv_ch2","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})


ValidPerg(_aRegs,cPerg)

If !Pergunte(cPerg, .T.)
	Return (.T.)
Endif

cNumDe	:= ALLTRIM(mv_par01)
cNumAte	:= ALLTRIM(mv_par02)
dDtDe	:= ALLTRIM(mv_par03)

ImpPed()

Return()

Static Function ImpPed()

Local aArea   := GetArea()

SetPrvt("OFONT1,OFONT2,OFONT3,OFONT4,OFONT5,OFONT6,OFONT7,OFONT8,OFONT9")
SetPrvt("OFONT10,OFONT11,OFONT12,OFONT13,OFONT14,OFONT15,OFONT16")

Private lEnd
Private oPrn	:= Nil
Private aOP		:= {}
Private nDes	:= 0  // Deslocamento
Private cTexto 	:= ""

Private aProduto	:= {}
Private aCodAux		:= {}
Private aDescri		:= {}
Private aUM			:= {}
Private aQtdVen		:= {}
Private aQtdEnt		:= {}
Private aQtdSld		:= {}
Private aQtdCan		:= {}
Private aPrcVen		:= {}
Private aValor		:= {}
Private aValCI		:= {}
Private aMargem		:= {}
Private aMBruta		:= {}
Private aICMS		:= {}
Private aIPI		:= {}
Private aEntrega	:= {}
Private aTES		:= {}
Private aCFOP		:= {}
Private aObs		:= {}
Private aComis		:= {}

Private nTotQtd		:= 0
Private nTotEnt		:= 0
Private nTotCan		:= 0
Private nTotSld		:= 0
Private nTotPeso	:= 0
Private nEntPeso	:= 0
Private nCanPeso	:= 0
Private nSldPeso	:= 0
Private nTotProd	:= 0
Private nFrete		:= 0
Private nTotIPI		:= 0
Private nTotICMS	:= 0
Private nTotGeral	:= 0
Private _nTotMBru	:= 0

Private _lCalcICMS	:= .T.

If Lastkey() = 27
	Return (.T.)
Endif

oFont1	:= oFont2 := oFont3 := oFont4 := oFont5 := oFont6 := oFont7 := oFont8 := Nil


//AVPRINT oPrn NAME "Romaneio"

oPrn:=TMSPRINTER():NEW("Romaneio")

oPrn:SetPortrait() // ou SetLandscape()

oFont1 := oSend(TFont(),"New","Arial Black" ,0,28,,.T.,,,,,,,,,,,oPrn )
oFont2 := oSend(TFont(),"New","Arial Black" ,0,40,,.T.,,,,,,,,,,,oPrn )
oFont3 := oSend(TFont(),"New","Arial Black" ,0,54,,.T.,,,,,,,,,,,oPrn )

oFont4 := oSend(TFont(),"New","Century Gothic" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont5 := oSend(TFont(),"New","Century Gothic" ,0,11,,.T.,,,,,,,,,,,oPrn )
oFont6 := oSend(TFont(),"New","Century Gothic" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont7 := oSend(TFont(),"New","Century Gothic" ,0,14,,.T.,,,,,,,,,,,oPrn )

oFont8  := oSend(TFont(),"New","Arial" ,0,08,,.F.,,,,,,,,,,,oPrn )
oFont9  := oSend(TFont(),"New","Arial" ,0,09,,.F.,,,,,,,,,,,oPrn )
oFont10 := oSend(TFont(),"New","Arial" ,0,10,,.F.,,,,,,,,,,,oPrn )
oFont11 := oSend(TFont(),"New","Arial" ,0,11,,.F.,,,,,,,,,,,oPrn )

oFont9b  := oSend(TFont(),"New","Arial" ,0,09,,.T.,,,,,,,,,,,oPrn )
oFont10b := oSend(TFont(),"New","Arial" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont11b := oSend(TFont(),"New","Arial" ,0,11,,.T.,,,,,,,,,,,oPrn )
oFont12b := oSend(TFont(),"New","Arial" ,0,12,,.T.,,,,,,,,,,,oPrn )

//oBrush	:= TBrush():New(,4)
//oPen 	:= TPen():New(0,5,CLR_BLACK,oPrn)
//oPen 	:= oSend(TPen(),"New",0,25,CLR_BLACK,oPrn)

// Insere retângulo preenchido

Processa({|X| lEnd := X, DadosPed()})

//AVENDPAGE

oPrn:EndPage()

oSend(oFont1,"End")
oSend(oFont2,"End")
oSend(oFont3,"End")
oSend(oFont4,"End")
oSend(oFont5,"End")
oSend(oFont6,"End")
oSend(oFont7,"End")

oSend(oFont8,"End")
oSend(oFont9,"End")
oSend(oFont10,"End")
oSend(oFont11,"End")

oSend(oFont9b,"End")
oSend(oFont10b,"End")
oSend(oFont11b,"End")
oSend(oFont12b,"End")

//AVENDPRINT
oPrn:Preview()

RestArea(aArea)

Return()  // ImpPed()


//*****************************************************************************
Static Function DadosPed()
//*****************************************************************************

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial("SF2") + MV_PAR01+MV_PAR03,.T.)

ProcRegua(RecCount())

Do While SF2->(!Eof()) .And. SF2->F2_FILIAL == xFilial("SF2") .AND. SF2->F2_DOC <= MV_PAR02
	
	IncProc("Processando Romaneio "+SF2->F2_DOC+"")
	
	If SF2->F2_SERIE <> MV_PAR03
		dbSelectArea("SF2")
		dbSkip()
		Loop
	EndIf
	
	//ALERT(SF2->F2_DOC+" - "+Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE,"D2_PEDIDO"),"C5_XPRIORI"))

/*	LTorres em 06/07/2016 a pedido do Caio
	If Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE,"D2_PEDIDO"),"C5_XPRIORI")$"A" .AND. !SF2->F2_SERIE$"1F 2F 3F "
		dbSelectArea("SF2")
		dbSkip()
		Loop
	EndIf
*/	
	cCliente	:= SF2->F2_CLIENTE
	cLoja		:= SF2->F2_LOJA
	cCliEnt		:= SF2->F2_CLIENT
	cLojaEnt	:= SF2->F2_LOJENT
	cNumPV		:= SF2->F2_DOC
	dData		:= SF2->F2_EMISSAO
	cData		:= "São Paulo, " + STRZERO(DAY(SF2->F2_EMISSAO),2)
	cData		+= " de " + MesExtenso(MONTH(SF2->F2_EMISSAO)) + " de " + str(year(SF2->F2_EMISSAO),4)
	cCondPag	:= SF2->F2_COND
	//	cVendedor	:= SC5->C5_VEND1
	//	nComissao	:= SC5->C5_COMIS1
	//	nDesconto	:= SC5->C5_DESC1
	//	cTpFrete	:= iIf(SC5->C5_TPFRETE = "C","CIF","FOB")
	//	cTransp		:= SC5->C5_TRANSP
	//	cRedesp     := SC5->C5_REDESP
	//	cTpFreteR	:= iIf(SC5->C5_X_TPFRE = "C","CIF","FOB")
	//	nMargemPD	:= SC5->C5_CITOTAL
	//	nMargemPD2	:= SC5->C5_PMCITOT
	//	nFrete		:= 0
	nIcmsRet	:= 0
	//	cObsPed		:= SC5->C5_X_OBS
	//	cMens1Lin	:= SC5->C5_MENNOTA
	//	nTpPed		:= SC5->C5_X_PRIOR
	cObsCli		:= ""
Private xprod   :=0	
	aProduto	:= {}
	aCodAux		:= {}
	aDescri		:= {}
	aUM			:= {}
	aQtdVen		:= {}
	aQtdEnt		:= {}
	aQtdSld		:= {}
	aQtdCan		:= {}
	aPrcVen		:= {}
	aValor		:= {}
	aValCI		:= {}
	aMargem		:= {}
	aMBruta		:= {}
	aICMS		:= {}
	aIPI		:= {}
	aEntrega	:= {}
	aTES		:= {}
	aCFOP		:= {}
	aObs		:= {}
	aComis		:= {}
	
	If SF2->F2_TIPO $ "DB"
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+cCliente+cLoja)
	Else
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+cCliente+cLoja)
		cObsCli := ""
	EndIf
	
	cFilterSC6 := "D2_FILIAL == '" + xFilial("SD2") + "'"
	cFilterSC6 += " .And. D2_DOC = '" + SF2->F2_DOC + "' .And. D2_SERIE = '"+SF2->F2_SERIE+"' "
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
	
	While !Eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		
		cPedVen := SD2->D2_PEDIDO
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+SD2->D2_COD,.T.)
		
		aImp := PVImp(SD2->D2_COD,SD2->D2_TES)
		
		aAdd(aProduto,SD2->D2_COD)
		aAdd(aCodAux,SB1->B1_CODANT)
		aAdd(aDescri,SB1->B1_DESC)
		aAdd(aUM,SD2->D2_UM)
		aAdd(aQtdVen,SD2->D2_QUANT)
		aAdd(aQtdEnt,SD2->D2_QUANT)
		aAdd(aPrcVen,Iif(SD2->D2_SERIE$"1F 2F 3F 4F ",SD2->D2_PRCVEN,Posicione("SC6",1,xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD,"C6_PRCVEN2")))
		aAdd(aValor,(SD2->D2_QUANT * Iif(SD2->D2_SERIE$"1F 2F 3F 4F ",SD2->D2_PRCVEN,Posicione("SC6",1,xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD,"C6_PRCVEN2"))))
		//		aAdd(aVAlCI,SC6->C6_VALCI)
		//		aAdd(aMargem,SC6->C6_CI)
		//		aAdd(aICMS,aImp[1])
		//		aAdd(aIPI,aImp[2])
		//		aAdd(aEntrega,SC6->C6_ENTREG)
		aAdd(aTES,SD2->D2_TES)
		//		aAdd(aCFOP,SC6->C6_CF)
		//		aAdd(aComis,SC6->C6_COMIS1)
		//		aAdd(aObs,SC6->C6_OBS)
		
		nTotQtd	+= SD2->D2_QUANT
		nTotEnt	+= SD2->D2_QUANT
		
		nTotProd += (SD2->D2_QUANT * Iif(SD2->D2_SERIE$"1F 2F 3F 4F ",SD2->D2_PRCVEN,Posicione("SC6",1,xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD,"C6_PRCVEN2")))
		//		nTotIPI  += SC6->C6_VALOR / 100 * aImp[2]
		//		nTotICMS += SC6->C6_VALOR / 100 * aImp[1]
		
		//		nTotPeso += SC6->C6_QTDVEN * SB1->B1_PESO
		//		nEntPeso += SC6->C6_QTDENT * SB1->B1_PESO
		                                                                                                     
		nIcmsRet += aImp[3]  //Icms Retido -> Substituição Tributária
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	    
	Imprime()
	
	nTotQtd	:= 0
	nTotEnt	:= 0
	
	nTotProd := 0
	
	dbSelectArea("SF2")
	dbSkip()
	
EndDo
  
Return(.T.)





Static Function Imprime()

Local I			:= 0
Private nLinha	:= 1
xprod:=0

ImpCabec(@nLinha)

CabecItem(@nLinha)

For I := 1 to len(aProduto)
	xprod++
	DetItem(I,@nLinha)
	TstFimPag(@nLinha)
Next

ImpTot(@nLinha)
TstFimPag(@nLinha)
DetCli(@nLinha)
TstFimPag(@nLinha)
ImpObs(@nLinha)
nLinha :=21
TstFimPag(@nLinha)
ImpRod(@nLinha)
TstFimPag(@nLinha)
Return()


Static Function TstFimPag(nLinha)

    If nLinha > 20
	nLinha := 1
	oPrn:EndPage()    
    Endif

if xprod==20 
nLinha += 0.5
 oPrn:Say(nLin(nLinha), nCol(01.5),"  Continua na Proxima Pagina >>>>",oFont9b ,,,,1)
   xprod=0
    nLinha := 1
	oPrn:EndPage()
    ImpCabec(@nLinha)
	CabecItem(@nLinha)
Endif

Return()




Static Function ImpCabec(nLinha)

Local cStartPath := GetSrvProfString("Startpath","")
Local aBitmap	 := cStartPath + ""

cEmpresa	:= ""

nLinha	:= 1

//AVNEWPAGE
oPrn:StartPage()
oPrn:SetLandscape()

oPrn:SayBitmap (nLin(0.0),nCol(0.0),aBitmap,nLin(5.0),nLin(0.5))  // Largura x Altura
oPrn:Say(nLin(1.7), nCol(19),cData,oFont11 ,,,,1)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

//TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.0),"Romaneio: " + cNumPV,oFont12b)
oPrn:Say(nLin(nLinha), nCol(05.0),cEmpresa,oFont11)
//oPrn:Say(nLin(nLinha), nCol(12.0),"Dt.Pedido: " + dtoc(dData),oFont11b)
//oPrn:Say(nLin(nLinha), nCol(15.5),"Dt.Entrega: " + dtoc(aEntrega[1]),oFont11b)
oPrn:Say(nLin(nLinha), nCol(16.2)  ,"Num. Pedido: " + cPedVen,oFont12b)

nLinha += 0.5
//TstFimPag(@nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2
//TstFimPag(@nLinha)


// Rodape
//oPrn:Say(nLin(26.5), nCol(11.0),'Estrada Fazenda Cachoeira, 571 CEP 13318-000 Cabreúva SP',oFont9)
//oPrn:Say(nLin(26.9), nCol(11.0),'Tel.: (0xx11) 4529-1500 Fax: 4529-1505',oFont9)
//oPrn:Say(nLin(27.3), nCol(11.0),'corrplastik@corr.com.br',oFont9)
//oPrn:Say(nLin(27.7), nCol(11.0),'www.corrplastik.com.br',oFont9)

Return() // ImpCabec()


//*****************************************************************************
Static Function CabecItem(nLinha)
//*****************************************************************************

nLinha += 0.5
//TstFimPag(@nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2
//TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.8),"Quant.",oFont9b ,,,,1)
oPrn:Say(nLin(nLinha), nCol(01.2),"Código",oFont9b)
oPrn:Say(nLin(nLinha), nCol(03.5),"",oFont9b)
oPrn:Say(nLin(nLinha), nCol(06.5),"Descrição",oFont9b)
//oPrn:Say(nLin(nLinha), nCol(10.5),"Un.",oFont9b)
oPrn:Say(nLin(nLinha), nCol(15.0),"Val.Unit.",oFont9b ,,,,1)
//oPrn:Say(nLin(nLinha), nCol(14.5),"Comissão",oFont9b ,,,,1)

//If lImpMrg
//	oPrn:Say(nLin(nLinha), nCol(16.0),"???",oFont9b ,,,,1)
//	oPrn:Say(nLin(nLinha), nCol(17.0),"C.I.(%)",oFont9b ,,,,1)
//EndIf

oPrn:Say(nLin(nLinha), nCol(19.0),"Val.Total",oFont9b ,,,,1)
nLinha += 0.5
//TstFimPag(@nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2
//TstFimPag(@nLinha)

Return()


//*****************************************************************************
Static Function DetItem(I,nLinha)
//*****************************************************************************

cTexto := transform(aQtdVen[I],"@E 999,999")
oPrn:Say(nLin(nLinha), nCol(00.8),cTexto,oFont9 ,,,,1)

oPrn:Say(nLin(nLinha), nCol(01.2),aProduto[I],oFont9)
oPrn:Say(nLin(nLinha), nCol(03.5),aCodAux[I],oFont9)
oPrn:Say(nLin(nLinha), nCol(06.5),aDescri[I],oFont8)
//oPrn:Say(nLin(nLinha), nCol(11.5),aUM[I],oFont8)

cTexto := transform(aPrcVen[I],PesqPict("SC6","C6_PRCVEN"))
oPrn:Say(nLin(nLinha), nCol(15.0),cTexto,oFont9 ,,,,1)

//cTexto := transform(iIf(Empty(aComis[I]),nComissao,aComis[I]),PesqPict("SC6","C6_COMIS1"))
//oPrn:Say(nLin(nLinha), nCol(14.5),cTexto+"%",oFont9 ,,,,1)

//If lImpMrg
//	cTexto := transform(aValCI[I],PesqPict("SC6","C6_PRCVEN"))
//	oPrn:Say(nLin(nLinha), nCol(16.0),cTexto,oFont9 ,,,,1)

//	cTexto := transform(aMargem[I],"@E 999.99")
//	oPrn:Say(nLin(nLinha), nCol(17.0),cTexto,oFont9 ,,,,1)
//EndIf

cTexto := transform(aValor[I],PesqPict("SC6","C6_VALOR"))
oPrn:Say(nLin(nLinha), nCol(19.0),cTexto,oFont9 ,,,,1)

/*
nTamObs := 150

For J := 1 To MlCount(aObs[I],nTamObs)
cTexto := Alltrim(MemoLine(aObs[I],nTamObs,J))
oPrn:Say(nLin(nLinha), nCol(01.0),cTexto,oFont10)
nLinha += 0.4
Next
*/

nLinha += 0.5
//TstFimPag(@nLinha)

Return()




Static Function ImpTot(nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2
TstFimPag(@nLinha)

//oPrn:Say(nLin(nLinha), nCol(0.0),"Desconto: ",oFont9b)
//cTexto := transform(nDesconto,PesqPict("SC5","C5_DESC1"))
//oPrn:Say(nLin(nLinha), nCol(03.0),cTexto,oFont9 ,,,,1)

//If lImpMrg
//	oPrn:Say(nLin(nLinha), nCol(5.0),"C.I. Pedido: ",oFont10b)
//	cTexto := transform(nMargemPD,PesqPict("SC5","C5_CITOTAL"))
//	oPrn:Say(nLin(nLinha), nCol(7.0),cTexto,oFont10 ,,,,1)

//	oPrn:Say(nLin(nLinha), nCol(7.5),"C.I. Novo: ",oFont10b)
//	cTexto := transform(nMargemPD2,PesqPict("SC5","C5_PMCITOT"))
//	oPrn:Say(nLin(nLinha), nCol(9.5),cTexto,oFont10 ,,,,1)
//EndIf

//oPrn:Say(nLin(nLinha), nCol(10.5),"Vlr. ICMS: ",oFont9b)
//cTexto := transform(nTotICMS,PesqPict("SC6","C6_VALOR"))
//oPrn:Say(nLin(nLinha), nCol(13.5),cTexto,oFont9 ,,,,1)

oPrn:Say(nLin(nLinha), nCol(15.0),"Valor Total: ",oFont9b)
cTexto := transform(nTotProd,PesqPict("SC6","C6_VALOR"))
oPrn:Say(nLin(nLinha), nCol(19.0),cTexto,oFont9 ,,,,1)
nLinha += 0.5
TstFimPag(@nLinha)

//oPrn:Say(nLin(nLinha), nCol(0.0),"Vlr.Frete: ",oFont9b)
//cTexto := transform(nFrete,PesqPict("SC5","C5_FRETE"))
//oPrn:Say(nLin(nLinha), nCol(03.0),cTexto,oFont9 ,,,,1)

//If nIcmsRet # 0
//	oPrn:Say(nLin(nLinha), nCol(05.0),"ICMS ST: ",oFont10b)
//	cTexto := transform(nIcmsRet,PesqPict("SF2","F2_ICMSRET"))
//	oPrn:Say(nLin(nLinha), nCol(09.5),cTexto,oFont10 ,,,,1)
//EndIf

//oPrn:Say(nLin(nLinha), nCol(10.5),"Vlr. IPI: ",oFont9b)
//cTexto := transform(nTotIPI,PesqPict("SC6","C6_VALOR"))
//oPrn:Say(nLin(nLinha), nCol(13.5),cTexto,oFont9 ,,,,1)

//nValTotal := nTotProd + nTotIPI + nFrete + nIcmsRet

//oPrn:Say(nLin(nLinha), nCol(15.0),"Valor Total: ",oFont9b)
//cTexto := transform(nValTotal,PesqPict("SC6","C6_VALOR"))
//oPrn:Say(nLin(nLinha), nCol(19.0),cTexto,oFont9 ,,,,1)
//nLinha += 0.5
//TstFimPag(@nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.5
TstFimPag(@nLinha)

Return() // ImpTot()


//*****************************************************************************
Static Function DetCli(nLinha)
//*****************************************************************************
local n
_aVencto := {}

If SC5->C5_TIPO $ "DB"
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+cCliente+cLoja)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Fornecedor:",oFont10b)
	oPrn:Say(nLin(nLinha), nCol(2.0),cCliente+"/"+cLoja+" - "+AllTrim(SA2->A2_NOME),oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)	
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Endereço:",oFont10b)
	cTexto := alltrim(SA2->A2_END) + " - " + alltrim(SA2->A2_BAIRRO) + " - CEP " + transform(SA2->A2_CEP,"@R 99999-999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Cidade:",oFont10b)
	cTexto := SA2->A2_MUN
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Estado:",oFont10b)
	cTexto := SA2->A2_EST
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),If(Len(AllTrim(SA2->A2_CGC))==14,"CNPJ:","CPF:"),oFont10b)
	cTexto := transform(SA2->A2_CGC,If(Len(AllTrim(SA2->A2_CGC))==14,"@R 99.999.999/9999-99","@R 999.999.999-99"))
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Insc.Est.:",oFont10b)
	cTexto := SA2->A2_INSCR
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Fone:",oFont10b)
	cTexto := "(" + alltrim(SA2->A2_DDD) + ") " + transform(SA2->A2_TEL,"@R 9999-9999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Contato:",oFont10b)
	cTexto := SA2->A2_CONTATO
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
	
	nLinha += 0.5
	TstFimPag(@nLinha)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(2.0),"Vencto(s):",oFont10b)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	If SF2->F2_SERIE$"1  "
		_cPrefSE1 := "AT "
	ElseIf SF2->F2_SERIE$"2  "
		_cPrefSE1 := "MA "
	ElseIf SF2->F2_SERIE$"3  "
		_cPrefSE1 := "DR "
	ElseIf SF2->F2_SERIE$"4  "
		_cPrefSE1 := "LK "
	ElseIf SF2->F2_SERIE$"5  "
		_cPrefSE1 := "EV "
	ElseIf SF2->F2_SERIE$"1F "
		_cPrefSE1 := "1F "
	ElseIf SF2->F2_SERIE$"2F "
		_cPrefSE1 := "2F "
	ElseIf SF2->F2_SERIE$"3F "
		_cPrefSE1 := "3F "
	ElseIf SF2->F2_SERIE$"4F "
		_cPrefSE1 := "4F "
	ElseIf SF2->F2_SERIE$"5F "
		_cPrefSE1 := "5F "
	EndIf
	
	//_cPrefSE1 := IIF(SF2->F2_SERIE$"1  ","AT ",IIF(SF2->F2_SERIE$"2  ","MA ","DR "))
	
	dbSelectArea("SE1")
	dbSetOrder(2)
	If dbSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+_cPrefSE1+F2_DOC),.f.)
		
		While Eof() == .f. .And. SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == SF2->(F2_CLIENTE+F2_LOJA+_cPrefSE1+F2_DOC)
			
			AADD(_aVencto,{SE1->E1_VENCTO,SE1->E1_VALOR})
			
			dbSelectArea("SE1")
			dbSkip()
		EndDo
	EndIf
	
	For n:= 1 To Len(_aVencto)
		
		oPrn:Say(nLin(nLinha), nCol(2.0),Dtoc(_aVencto[n,1]),oFont10)
		oPrn:Say(nLin(nLinha), nCol(10.0),Transform(_aVencto[n,2],PesqPict("SE1","E1_VALOR")),oFont10)
		nLinha += 0.5
		TstFimPag(@nLinha)
		
	Next
	
	_aVencto := {}
	
	
Else
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+cCliente+cLoja)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Cliente:",oFont10b)
	oPrn:Say(nLin(nLinha), nCol(2.0),cCliente+"/"+cLoja+" - "+AllTrim(SA1->A1_NOME),oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Endereço:",oFont10b)
	cTexto := alltrim(SA1->A1_END) + " - " + alltrim(SA1->A1_BAIRRO) + " - CEP " + transform(SA1->A1_CEP,"@R 99999-999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Cidade/UF:",oFont10b)
	cTexto := AllTrim(SA1->A1_MUN)+"/"+SA1->A1_EST
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Tipo Cliente:",oFont10b)
	cTexto := X3Combo("C5_TIPOCLI",SC5->C5_TIPOCLI)
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),If(Len(AllTrim(SA1->A1_CGC))==14,"CNPJ:","CPF:"),oFont10b)
	cTexto := transform(SA1->A1_CGC,If(Len(AllTrim(SA1->A1_CGC))==14,"@R 99.999.999/9999-99","@R 999.999.999-99"))
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	
	If !Empty(SA1->A1_INSCRUR)
		oPrn:Say(nLin(nLinha), nCol(07.0),"Insc.Est.:",oFont10b)
		cTexto := SA1->A1_INSCR
		oPrn:Say(nLin(nLinha), nCol(09.0),cTexto,oFont10)
		oPrn:Say(nLin(nLinha), nCol(12.0),"Insc.Rural:",oFont10b)
		cTexto := SA1->A1_INSCRUR
		oPrn:Say(nLin(nLinha), nCol(14.0),cTexto,oFont10)
		nLinha += 0.5
		TstFimPag(@nLinha)
	
	Else
		oPrn:Say(nLin(nLinha), nCol(10.0),"Insc.Est.:",oFont10b)
		cTexto := SA1->A1_INSCR
		oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
		nLinha += 0.5
		TstFimPag(@nLinha)
		
	EndIf
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Fone:",oFont10b)
	cTexto := "(" + alltrim(SA1->A1_DDD) + ") " + transform(SA1->A1_TEL,"@R 9999-9999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Contato:",oFont10b)
	cTexto := SA1->A1_CONTATO
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
	
	nLinha += 0.5
	TstFimPag(@nLinha)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	oPrn:Say(nLin(nLinha), nCol(2.0),"Vencto(s):",oFont10b)
	nLinha += 0.5
	TstFimPag(@nLinha)
	
	If SF2->F2_SERIE$"1  "
		_cPrefSE1 := "AT "
	ElseIf SF2->F2_SERIE$"2  "
		_cPrefSE1 := "MA "
	ElseIf SF2->F2_SERIE$"3  "
		_cPrefSE1 := "DR "
	ElseIf SF2->F2_SERIE$"4  "
		_cPrefSE1 := "LK "
	ElseIf SF2->F2_SERIE$"5  "
		_cPrefSE1 := "EV "
	ElseIf SF2->F2_SERIE$"1F "
		_cPrefSE1 := "1F "
	ElseIf SF2->F2_SERIE$"2F "
		_cPrefSE1 := "2F "
	ElseIf SF2->F2_SERIE$"3F "
		_cPrefSE1 := "3F "
	ElseIf SF2->F2_SERIE$"4F "
		_cPrefSE1 := "4F "
	ElseIf SF2->F2_SERIE$"5F "
		_cPrefSE1 := "5F "
	EndIf
	
	//_cPrefSE1 := IIF(SF2->F2_SERIE$"1  ","AT ",IIF(SF2->F2_SERIE$"2  ","MA ","DR "))
                                                                       
	dbSelectArea("SE1")
	dbSetOrder(2)
	If dbSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+_cPrefSE1+F2_DOC),.f.)
		
		While Eof() == .f. .And. SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == SF2->(F2_CLIENTE+F2_LOJA+_cPrefSE1+F2_DOC)
			
			AADD(_aVencto,{SE1->E1_VENCTO,SE1->E1_VALOR})
			
			dbSelectArea("SE1")
			dbSkip()
		EndDo
	EndIf
	
	For n:= 1 To Len(_aVencto)
		
		oPrn:Say(nLin(nLinha), nCol(2.0),Dtoc(_aVencto[n,1]),oFont10)
		oPrn:Say(nLin(nLinha), nCol(10.0),Transform(_aVencto[n,2],PesqPict("SE1","E1_VALOR")),oFont10)
		nLinha += 0.5
		TstFimPag(@nLinha)	
	
	Next
	
	_aVencto := {}
	
EndIf

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+aTES[1])

/*oPrn:Say(nLin(nLinha), nCol(0.0),"Tipo Saída:",oFont10b)
cTexto := SF4->F4_FINALID
oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
oPrn:Say(nLin(nLinha), nCol(10.0),"CFOP:",oFont10b)
cTexto := aCFOP[1]
oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
nLinha += 0.5

If cCliente <> cCliEnt .or. cLoja <> cLojaEnt .And. !(SC5->C5_TIPO) $ "DB"

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+cCliEnt+cLojaEnt)

oPrn:Say(nLin(nLinha), nCol(0.0),"Entrega:",oFont10b)
cTexto := alltrim(SA1->A1_END) + " - " + alltrim(SA1->A1_BAIRRO) + " - CEP " + transform(SA1->A1_CEP,"@R 99999-999")
oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
nLinha += 0.5

oPrn:Say(nLin(nLinha), nCol(0.0),"Cidade:",oFont10b)
cTexto := SA1->A1_MUN
oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
oPrn:Say(nLin(nLinha), nCol(10.0),"Estado:",oFont10b)
cTexto := SA1->A1_EST
oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
nLinha += 0.5  */

//EndIf

nLinha += 0.5
TstFimPag(@nLinha)

Return() // DetCli()


//*****************************************************************************
Static Function ImpObs(nLinha)
//*****************************************************************************

TstFimPag(@nLinha)

//oPrn:Say(nLin(nLinha), nCol(00.0),"Demais condições:",oFont11b)
nLinha += 0.5
TstFimPag(@nLinha)

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+cCondPag)

TstFimPag(@nLinha)

//oPrn:Say(nLin(nLinha), nCol(00.0),"Pagamento:",oFont10b)
//oPrn:Say(nLin(nLinha), nCol(03.0),SE4->E4_DESCRI,oFont10)

cTexto := "B"



//If !Empty(cTexto)
//	oPrn:Say(nLin(nLinha), nCol(0.0),"Prioridade:",oFont10b)
//	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
//EndIf

nLinha += 0.5
TstFimPag(@nLinha)

//oPrn:Say(nLin(nLinha), nCol(00.0),"Representante:",oFont10b)
//oPrn:Say(nLin(nLinha), nCol(03.0),cVendedor + " - " + Posicione("SA3",1,xFilial("SA3")+cVendedor,"A3_NOME"),oFont10)
nLinha += 0.5
TstFimPag(@nLinha)

//oPrn:Say(nLin(nLinha), nCol(00.0),"Transportadora:",oFont10b)
//oPrn:Say(nLin(nLinha), nCol(03.0),cTransp + " - " + Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME"),oFont10)
nLinha += 0.5
TstFimPag(@nLinha)

//oPrn:Say(nLin(nLinha), nCol(00.0),"Tipo Frete:",oFont10b)
//oPrn:Say(nLin(nLinha), nCol(03.0),cTpFrete,oFont10)
//nLinha += 0.5
//TstFimPag(@nLinha)
/*
If !Empty(cRedesp)
oPrn:Say(nLin(nLinha), nCol(00.0),"Redespacho:",oFont10b)
oPrn:Say(nLin(nLinha), nCol(03.0),cRedesp + " - " + Posicione("SA4",1,xFilial("SA4")+cRedesp,"A4_NOME"),oFont10)
nLinha += 0.5
TstFimPag(@nLinha)

//	oPrn:Say(nLin(nLinha), nCol(00.0),"Tipo Frete Redesp.:",oFont10b)
//	oPrn:Say(nLin(nLinha), nCol(03.0),cTpFreteR,oFont10)
nLinha += 0.5
TstFimPag(@nLinha)

End if

nLinha += 0.5
oPrn:Say(nLin(nLinha), nCol(00.0),"Observação do Pedido:",oFont10b)
nLinha += 0.5
oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

TstFimPag(@nLinha)*/

nTamObs := 100

/*For J := 1 To MlCount(cObsPed,nTamObs)
cTexto := Alltrim(MemoLine(cObsPed,nTamObs,J))
oPrn:Say(nLin(nLinha), nCol(00.0),cTexto,oFont10)
nLinha += 0.4
TstFimPag(@nLinha)
Next

nLinha += 0.5
TstFimPag(@nLinha)    */

//oPrn:Say(nLin(nLinha), nCol(00.0),"Observação do Cadastro de Cliente:",oFont10b)
//nLinha += 0.5
//oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
//nLinha += 0.2

TstFimPag(@nLinha)

nTamObs := 100
/*
For J := 1 To MlCount(cObsCli,nTamObs)
cTexto := Alltrim(MemoLine(cObsCli,nTamObs,J))
oPrn:Say(nLin(nLinha), nCol(00.0),cTexto,oFont10)
nLinha += 0.4
TstFimPag(@nLinha)
Next

nLinha += 0.5
TstFimPag(@nLinha)*/

Return() // ImpObs()


//*****************************************************************************
Static Function ImpRod(nLinha)
//*****************************************************************************

/*
oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
oPrn:Line(nLin(nLinha), nCol(00.0), nLin(nLinha + 1.3), nCol(00.0))
oPrn:Line(nLin(nLinha), nCol(03.8), nLin(nLinha + 1.3), nCol(03.8))
oPrn:Line(nLin(nLinha), nCol(07.6), nLin(nLinha + 1.3), nCol(07.6))
oPrn:Line(nLin(nLinha), nCol(11.4), nLin(nLinha + 1.3), nCol(11.4))
oPrn:Line(nLin(nLinha), nCol(15.2), nLin(nLinha + 1.3), nCol(15.2))
oPrn:Line(nLin(nLinha), nCol(19.0), nLin(nLinha + 1.3), nCol(19.0))
nLinha += 0.2
TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(01.9),"Peso:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(05.7),"Volumes:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(09.5),"Visto Vendas:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(13.3),"Visto Expedição:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(17.1),"Visto Dpto Crédito:",oFont10b ,,,,2)
nLinha += 0.6
TstFimPag(@nLinha)

cTexto := alltrim(transform(nTotPeso,PesqPict("SB1","B1_PESO")))
oPrn:Say(nLin(nLinha), nCol(01.9),cTexto,oFont10 ,,,,1)
nLinha += 0.5
TstFimPag(@nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2
TstFimPag(@nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
oPrn:Line(nLin(nLinha), nCol(00.0), nLin(nLinha + 1.5), nCol(00.0))
oPrn:Line(nLin(nLinha), nCol(19.0), nLin(nLinha + 1.5), nCol(19.0))
nLinha += 0.2
TstFimPag(@nLinha)

cTexto := "Pedido faturado através da(s) Nota(s) Fiscal(is)"
oPrn:Say(nLin(nLinha), nCol(00.2),cTexto,oFont10b)
nLinha += 0.8
TstFimPag(@nLinha)

cTexto := "Nº ___________  de ____ / ____ / _______      "
cTexto += "Nº ___________  de ____ / ____ / _______      "
cTexto += "Nº ___________  de ____ / ____ / _______      "
oPrn:Say(nLin(nLinha), nCol(00.2),cTexto,oFont10b)
nLinha += 0.5
TstFimPag(@nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2
nLinha :=21
TstFimPag(@nLinha)
*/
Return() // ImpRod()


//*****************************************************************************
Static Function PVImp(cProd,cTES)
//*****************************************************************************

Local aArea	:= GetArea()
Local aRet	:= {}

If SC5->C5_TIPO $ "DB"
	
	MaFisIni(SA2->A2_COD,;			              // 1-Codigo Cliente/Fornecedor
	SA2->A2_LOJA,;		                  // 2-Loja do Cliente/Fornecedor
	"C",;							      // 3-C:Cliente , F:Fornecedor
	"N",;				                  // 4-Tipo da NF
	SA2->A2_TIPO,;			              // 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100",{"SF2","SD2"}),; // 6-Relacao de Impostos que suportados no arquivo
	,;							          // 7-Tipo de complemento
	,;							          // 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;					              // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MTR700")					          // 10-Nome da rotina que esta utilizando a funcao
	
Else
	
	MaFisIni(SA1->A1_COD,;			              // 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA,;		                  // 2-Loja do Cliente/Fornecedor
	"C",;							      // 3-C:Cliente , F:Fornecedor
	"N",;				                  // 4-Tipo da NF
	SC5->C5_TIPOCLI,;		//			SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100",{"SF2","SD2"}),; // 6-Relacao de Impostos que suportados no arquivo
	,;							          // 7-Tipo de complemento
	,;							          // 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;					              // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MTR700")					          // 10-Nome da rotina que esta utilizando a funcao
	
EndIf

MaFisAdd(cProd,; 				  // 1-Codigo do Produto ( Obrigatorio )
cTES,;					  // 2-Codigo do TES ( Opcional )
SC6->C6_QTDVEN,;  //1,;				              // 3-Quantidade ( Obrigatorio )
SC6->C6_PRCVEN,;  //1,;		                      // 4-Preco Unitario ( Obrigatorio )
0,;                           // 5-Valor do Desconto ( Opcional )
,;							  // 6-Numero da NF Original ( Devolucao/Benef )
,;							  // 7-Serie da NF Original ( Devolucao/Benef )
,;					          // 8-RecNo da NF Original no arq SD1/SD2
0,;							  // 9-Valor do Frete do Item ( Opcional )
0,;							  // 10-Valor da Despesa do item ( Opcional )
0,;            				  // 11-Valor do Seguro do item ( Opcional )
0,;							  // 12-Valor do Frete Autonomo ( Opcional )
SC6->C6_VALOR,;  //1,;                           // 13-Valor da Mercadoria ( Obrigatorio )
0,;							  // 14-Valor da Embalagem ( Opiconal )
0,;		     				  // 15-RecNo do SB1
0) 							  // 16-RecNo do SF4

/*
nALIQICM := MaFisRet(1,"IT_ALIQICM")
nALIQIPI := MaFisRet(1,"IT_ALIQIPI")
nALIQISS := MaFisRet(1,"IT_ALIQISS")
nALIQIRR := MaFisRet(1,"IT_ALIQIRR")
nALIQINS := MaFisRet(1,"IT_ALIQINS")
nALIQCOF := MaFisRet(1,"IT_ALIQCOF")
nALIQCSL := 0//MaFisRet(1,"IT_ALIQCLS")
nALIQPIS := MaFisRet(1,"IT_ALIQPIS")
nALIQIV5 := MaFisRet(1,"IT_ALIQIV5")
nALIQIV6 := MaFisRet(1,"IT_ALIQIV6")
nALIQPS2 := MaFisRet(1,"IT_ALIQPS2")
*/

/*
aImp := MaFisRet(,"NF_IMPOSTOS")

For I:= 1 to len(aImp)

If aImp[I][2] <> "IPI"
nRet += aImp[I][5]
EndIf

Next
*/

aAdd(aRet,MaFisRet(1,"IT_ALIQICM"))
aAdd(aRet,MaFisRet(1,"IT_ALIQIPI"))
aAdd(aRet,MaFisRet(1,"IT_VALSOL"))

MaFisEnd()

RestArea(aArea)

Return(aRet) // PVImp()


//*****************************************************************************
Static Function nLin(nVal)
//*****************************************************************************

Local nRet

nRet := (300/2.54) * (nVal + 0.5 + nDes)

Return(nRet)  // nLin()


//*****************************************************************************
Static Function nCol(nVal)
//*****************************************************************************

Local nRet

nRet := (300/2.54) * (nVal + 1)

Return(nRet) // nCol()


