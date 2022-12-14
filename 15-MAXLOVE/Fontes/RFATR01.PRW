
#Include "Avprint.ch"
#Include "Font.ch"
#Include "Protheus.ch"
#Include "rwmake.ch"
/*
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????Ŀ??
???Programa  ? RFATR01  ? Autor ? Ricardo Correa de Souza ? Data ? 20/08/2017 ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Descricao ? Impressao dos Pedidos de Venda via Menu ou Relatorio           ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Observacao? Via Ponto de Entrada MA410MNU                                  ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ? MAXLOVE                                                        ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???             ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL              ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Programador   ?  Data  ?              Motivo da Alteracao                  ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???              ?        ?                                                   ???
??????????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
*/


User Function RFATR01()

If Alltrim(FunName()) $ "MATA410"
	cPerg	:= "FATR01A"
	cNumDe	:= SC5->C5_NUM
	cNumAte	:= SC5->C5_NUM
	dDtDe	:= SC5->C5_EMISSAO
	dDtAte	:= SC5->C5_EMISSAO
	
	_aRegs := {}
	
	AAdd(_aRegs,{cPerg,"01","Impressao ?     ","Impressao ?     ","Impressao ?     ","mv_ch0","N",01,0,0,"C","","mv_par01","Total","","","","","Saldo","","","","","","","","","","","","","","","","","","",""})
	//AAdd(_aRegs,{cPerg,"02","Comissao ?      ","Comissao ?      ","Comissao ?      ","mv_ch0","N",01,0,0,"C","","mv_par02","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	
	//ValidPerg(_aRegs,cPerg)
	
	If !pergunte(cPerg,.T.)
		Return
	Endif
Else
	cPerg	:= "FATR01B"
	
	_aRegs := {}
	
	AAdd(_aRegs,{cPerg,"01","Impressao ?     ","Impressao ?     ","Impressao ?     ","mv_ch0","N",01,0,0,"C","","mv_par01","Total","","","","","Saldo","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{cPerg,"02","Do Pedido ?     ","Do Pedido ?     ","Do Pedido ?     ","mv_ch0","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{cPerg,"03","Ate o Pedido ?  ","Ate o Pedido ?  ","Ate o Pedido ?  ","mv_ch0","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{cPerg,"04","Da Emissao ?    ","Da Emissao ?    ","Da Emissao ?    ","mv_ch0","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{cPerg,"05","Ate a Emissao ? ","Ate a Emissao ? ","Ate a Emissao ? ","mv_ch0","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//AAdd(_aRegs,{cPerg,"06","Comissao ?      ","Comissao ?      ","Comissao ?      ","mv_ch0","N",01,0,0,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	
	ValidPerg(_aRegs,cPerg)
	
	If !pergunte(cPerg,.T.)
		Return
	Endif
	
	cNumDe	:= MV_PAR02
	cNumAte	:= MV_PAR03
	dDtDe	:= MV_PAR04
	dDtAte	:= MV_PAR05
	
EndIf

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

AVPRINT oPrn NAME "Pedido de Venda"
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

oBrush	:= TBrush():New(,4)
//oPen 	:= TPen():New(0,5,CLR_BLACK,oPrn)
//oPen 	:= oSend(TPen(),"New",0,25,CLR_BLACK,oPrn)

Processa({|X| lEnd := X, DadosPed()})

AVENDPAGE

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

AVENDPRINT

RestArea(aArea)

Return()  // ImpPed()


//*****************************************************************************
Static Function DadosPed()
//*****************************************************************************
Private cSuframa := ""
psworder(2)

if pswseek(substr(cusuario,7,15),.t.)
	_daduser:=pswret(1)
	_grupo:=Array(len(_daduser[1,10]))
	psworder(1)
	for i:=1 to len(_daduser[1,10])
		if pswseek(_daduser[1,10,i],.f.)
			_grupo[i]:=pswret(NIL)
			_cGrupo := _grupo[i,1,2]
		endif
	next
endif
	
If Alltrim(FunName()) $ "MATA410" .Or. !Alltrim(_cGrupo)$"REPRESENTANTE"
	
	cFilter := "C5_FILIAL == '" + xFilial("SC5") + "'"
	cFilter += " .And. C5_NUM >= '" + cNumDe + "'"
	cFilter += " .And. C5_NUM <= '" + cNumAte + "'"
	cFilter += " .And. Dtos(C5_EMISSAO) >= '" + Dtos(dDtDe) + "'"
	cFilter += " .And. Dtos(C5_EMISSAO) <= '" + Dtos(dDtAte) + "'"
	
Else
  
	cFilter := "C5_FILIAL == '" + xFilial("SC5") + "'"
	cFilter += " .And. C5_NUM >= '" + cNumDe + "'"
	cFilter += " .And. C5_NUM <= '" + cNumAte + "'"
	cFilter += " .And. Dtos(C5_EMISSAO) >= '" + Dtos(dDtDe) + "'"
	cFilter += " .And. Dtos(C5_EMISSAO) <= '" + Dtos(dDtAte) + "'"
	cFilter += " .And. C5_VEND1 $ '" + substr(cusuario,7,06) + "'"
	
EndIf
dbSelectArea("SC5")
dbSetOrder(1)

If !Alltrim(FunName()) $ "MATA410"
	Set Filter To &cFilter
EndIf

dbSeek(xFilial("SC5") + cNumDe,.T.)

ProcRegua(RecCount())

Do While SC5->(!Eof()) .And. SC5->C5_NUM <= cNumAte
	
	cCliente	:= SC5->C5_CLIENTE
	cLoja		:= SC5->C5_LOJACLI
	cCliEnt		:= SC5->C5_CLIENT
	cLojaEnt	:= SC5->C5_LOJAENT
	cNumPV		:= SC5->C5_NUM
	dData		:= SC5->C5_EMISSAO
	cData		:= "S?o Paulo, " + STRZERO(DAY(SC5->C5_EMISSAO),2)
	cData		+= " de " + MesExtenso(MONTH(SC5->C5_EMISSAO)) + " de " + str(year(SC5->C5_EMISSAO),4)
	cCondPag	:= SC5->C5_CONDPAG
	cVendedor	:= SC5->C5_VEND1
	nComissao	:= SC5->C5_COMIS1
	nDesconto	:= SC5->C5_DESC1
	cTpFrete	:= iIf(SC5->C5_TPFRETE = "C","CIF","FOB")
	cTransp		:= SC5->C5_TRANSP
	cRedesp     := SC5->C5_REDESP
	//	cTpFreteR	:= iIf(SC5->C5_X_TPFRE = "C","CIF","FOB")
	//	nMargemPD	:= SC5->C5_CITOTAL
	//	nMargemPD2	:= SC5->C5_PMCITOT
	nFrete		:= 0
	nIcmsRet	:= 0
	cObsPed		:= ''//SC5->C5_X_OBS
	cMens1Lin	:= SC5->C5_MENNOTA
	nTpPed		:= SC5->C5_XPRIORI
	cObsCli		:= ""
	
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
	aCodBar		:= {}
	
	If SC5->C5_TIPO $ "DB"
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+cCliente+cLoja)
	Else
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+cCliente+cLoja)
		cObsCli := ""
	EndIf
	
	cFilterSC6 := "C6_FILIAL == '" + xFilial("SC6") + "'"
	cFilterSC6 += " .And. C6_NUM = '" + SC5->C5_NUM + "'"
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	//Set Filter To &cFilterSC6
	//DbSeek(xFilial("SC6"),.T.)
	DbSeek(xFilial("SC6")+SC5->C5_NUM,.F.)
	
	//While !Eof() //  .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM
	While !Eof() .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM
		
		If SC6->C6_BLQ $ "R"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		EndIf
		
		If mv_par01 == 2
			If SC6->C6_QTDVEN <= SC6->C6_QTDENT
				dbSelectArea("SC6")
				dbSkip()
				Loop
			EndIf
		EndIf
		
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		//DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.T.)
		DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)
		
		aImp := PVImp(SC6->C6_PRODUTO,SC6->C6_TES)
		
		aAdd(aProduto,SC6->C6_PRODUTO)
		aAdd(aCodAux, SC6->C6_KIT)
		aAdd(aDescri,SC6->C6_DESCRI)
		aAdd(aUM,SC6->C6_UM)
		aAdd(aQtdVen,SC6->C6_QTDVEN)
		aAdd(aQtdEnt,SC6->C6_QTDENT)
		aAdd(aPrcVen,SC6->C6_PRCTAB)
		If MV_PAR01 == 2
        	aAdd(aValor,((SC6->C6_QTDVEN - SC6->C6_QTDENT)*SC6->C6_PRCTAB))
  		Else
			aAdd(aValor,(SC6->C6_QTDVEN * SC6->C6_PRCTAB))
		Endif
		//		aAdd(aVAlCI,SC6->C6_VALCI)
		//		aAdd(aMargem,SC6->C6_CI)
		aAdd(aICMS,aImp[1])
		aAdd(aIPI,aImp[2])
		aAdd(aEntrega,SC6->C6_ENTREG)
		aAdd(aTES,SC6->C6_TES)
		aAdd(aCFOP,SC6->C6_CF)
		aAdd(aComis,SC6->C6_COMIS1)
		//		aAdd(aObs,SC6->C6_OBS)
		aAdd(aCodBar,SB1->B1_CODBAR)
		nTotQtd	+= SC6->C6_QTDVEN
		nTotEnt	+= SC6->C6_QTDENT
		
		If mv_par01 == 2
			nTotProd += ((SC6->C6_QTDVEN - SC6->C6_QTDENT)*(SC6->C6_PRCTAB))
			nTotIPI  += ((SC6->C6_QTDVEN - SC6->C6_QTDENT)*(SC6->C6_PRCTAB)) / 100 * aImp[2]
			nTotICMS += ((SC6->C6_QTDVEN - SC6->C6_QTDENT)*(SC6->C6_PRCTAB)) / 100 * aImp[1]
		Else
			nTotProd += ((SC6->C6_QTDVEN)*(SC6->C6_PRCTAB))
			nTotIPI  += ((SC6->C6_QTDVEN)*(SC6->C6_PRCTAB)) / 100 * aImp[2]
			nTotICMS += ((SC6->C6_QTDVEN)*(SC6->C6_PRCTAB)) / 100 * aImp[1]
		EndIf
		
		nTotPeso += SC6->C6_QTDVEN * SB1->B1_PESO
		nEntPeso += SC6->C6_QTDENT * SB1->B1_PESO
		
		nIcmsRet += aImp[3]  //Icms Retido -> Substitui??o Tribut?ria
		
		dbSelectArea("SC6")
		dbSkip()
		
	EndDo
	
	dbSelectArea("SC6")
	Set Filter To
	
	If SC5->C5_XPRIORI == "A"
		nTotIPI  := nTotIPI  * 1
		nTotICMS := nTotICMS * 1
		nIcmsRet := nIcmsRet * 1
	ElseIf SC5->C5_XPRIORI == "B"
		nTotIPI  := nTotIPI  * 0.50
		nTotICMS := nTotICMS * 0.50
		nIcmsRet := nIcmsRet * 0.50
	ElseIf SC5->C5_XPRIORI == "C"
		nTotIPI  := nTotIPI  * 0.40
		nTotICMS := nTotICMS * 0.40
		nIcmsRet := nIcmsRet * 0.40
	ElseIf SC5->C5_XPRIORI == "D"
		nTotIPI  := nTotIPI  * 0.20
		nTotICMS := nTotICMS * 0.20
		nIcmsRet := nIcmsRet * 0.20
	ElseIf SC5->C5_XPRIORI == "E"
		nTotIPI  := nTotIPI  * 0.70
		nTotICMS := nTotICMS * 0.70
		nIcmsRet := nIcmsRet * 0.70
	ElseIf SC5->C5_XPRIORI == "F"
		nTotIPI  := nTotIPI  * 0.10
		nTotICMS := nTotICMS * 0.10
		nIcmsRet := nIcmsRet * 0.10
	Else
		nTotIPI  := nTotIPI  * 1
		nTotICMS := nTotICMS * 1
		nIcmsRet := nIcmsRet * 1
	EndIf
	
//	cSuframa := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_SUFRAMA")

	If aTES[1] $ "512/513"
		nTotICMS := 0
	Endif
	
	If Len(aProduto) > 0
		Imprime()
	EndIf
	
	//RecLock("SC5",.f.)
	//SC5->C5_X_IMPPV	:=	"S"
	//MsUnLock()
	
	dbSelectArea("SC5")
	dbSkip()
	
EndDo

Return(.T.)





Static Function Imprime()

Private I		:= 0
Private nLinha	:= 1

ImpCabec(@nLinha)

CabecItem(@nLinha)

For I := 1 to len(aProduto)
	DetItem(I,@nLinha)
	TstFimPag(@nLinha)
Next

ImpTot(@nLinha)
TstFimPag(@nLinha)
DetCli(@nLinha)
TstFimPag(@nLinha)
ImpObs(@nLinha)
TstFimPag(@nLinha)
ImpRod(@nLinha)

Return()


Static Function TstFimPag(nLinha)

If nLinha > 25
	ImpCabec(@nLinha)
EndIf

Return()




Static Function ImpCabec(nLinha)

Local cStartPath := GetSrvProfString("Startpath","")
Local aBitmap	 := cStartPath + "pedlogo.bmp"

cEmpresa	:= ""

nLinha	:= 1.5

AVNEWPAGE

oPrn:SayBitmap (nLin(0.0),nCol(0.0),aBitmap,nLin(3.0),nCol(0.3))  // Largura x Altura
//oPrn:Say(nLin(1.7), nCol(19),cData,oFont11 ,,,,1)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

oPrn:Say(nLin(nLinha), nCol(00.0),"Pedido de Venda: " + cNumPV,oFont12b)
oPrn:Say(nLin(nLinha), nCol(05.0),cEmpresa,oFont11)
oPrn:Say(nLin(nLinha), nCol(16.0),"Data Pedido: " + dtoc(dData),oFont11b)
//oPrn:Say(nLin(nLinha), nCol(15.5),"Dt.Entrega: " + dtoc(aEntrega[1]),oFont11b)
nLinha += 0.5

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2


// Rodape
//oPrn:Say(nLin(26.5), nCol(11.0),'Estrada Fazenda Cachoeira, 571 CEP 13318-000 Cabre?va SP',oFont9)
//oPrn:Say(nLin(26.9), nCol(11.0),'Tel.: (0xx11) 4529-1500 Fax: 4529-1505',oFont9)
//oPrn:Say(nLin(27.3), nCol(11.0),'corrplastik@corr.com.br',oFont9)
//oPrn:Say(nLin(27.7), nCol(11.0),'www.corrplastik.com.br',oFont9)

Return() // ImpCabec()


//*****************************************************************************
Static Function CabecItem(nLinha)
//*****************************************************************************

nLinha += 0.5

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

oPrn:Say(nLin(nLinha), nCol(00.8),"Quant.",oFont9b ,,,,1)
oPrn:Say(nLin(nLinha), nCol(01.2),"C?digo",oFont9b)
oPrn:Say(nLin(nLinha), nCol(03.5),"Kit",oFont9b)
oPrn:Say(nLin(nLinha), nCol(06.5),"Descri??o",oFont9b)
//oPrn:Say(nLin(nLinha), nCol(11.0),"Un.",oFont9b)
oPrn:Say(nLin(nLinha), nCol(13.0),"Val.Unit.",oFont9b ,,,,1)

oPrn:Say(nLin(nLinha), nCol(16.0),"CFOP",oFont9b ,,,,1)

//If lImpMrg
//	oPrn:Say(nLin(nLinha), nCol(16.0),"???",oFont9b ,,,,1)
//	oPrn:Say(nLin(nLinha), nCol(17.0),"C.I.(%)",oFont9b ,,,,1)
//EndIf

oPrn:Say(nLin(nLinha), nCol(19.0),"Val.Total",oFont9b ,,,,1)
nLinha += 0.5

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

Return()


//*****************************************************************************
Static Function DetItem(I,nLinha)
//*****************************************************************************
If MV_PAR01 == 2
	cTexto := transform(aQtdVen[I]-aQtdEnt[I],"@E 999,999")	
Else
	cTexto := transform(aQtdVen[I],"@E 999,999")
Endif
oPrn:Say(nLin(nLinha), nCol(00.8),cTexto,oFont9 ,,,,1)

oPrn:Say(nLin(nLinha), nCol(01.2),aProduto[I],oFont9)
oPrn:Say(nLin(nLinha), nCol(03.5),aCodAux[I],oFont9)
oPrn:Say(nLin(nLinha), nCol(06.5),aDescri[I],oFont8)
//oPrn:Say(nLin(nLinha), nCol(11.5),aUM[I],oFont8)

cTexto := transform(aPrcVen[I],PesqPict("SC6","C6_PRCVEN"))
oPrn:Say(nLin(nLinha), nCol(13.0),cTexto,oFont9 ,,,,1)

If cPerg $"FATR01"
	If MV_PAR02 == 1
		cTexto := transform(iIf(Empty(aComis[I]),nComissao,aComis[I]),PesqPict("SC6","C6_COMIS1"))
		oPrn:Say(nLin(nLinha), nCol(14.5),cTexto+"%",oFont9 ,,,,1)
	EndIf
ElseIf cPerg $"FATR01"
	If MV_PAR06 == 1
		cTexto := transform(iIf(Empty(aComis[I]),nComissao,aComis[I]),PesqPict("SC6","C6_COMIS1"))
		oPrn:Say(nLin(nLinha), nCol(14.5),cTexto+"%",oFont9 ,,,,1)
	EndIf
EndIf

oPrn:Say(nLin(nLinha), nCol(15.3),aCFOP[I],oFont8)

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

Return()




Static Function ImpTot(nLinha)

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

oPrn:Say(nLin(nLinha), nCol(0.0),"Desconto: ",oFont9b)
cTexto := transform(nDesconto,PesqPict("SC5","C5_DESC1"))
oPrn:Say(nLin(nLinha), nCol(03.0),cTexto,oFont9 ,,,,1)

//If lImpMrg
//	oPrn:Say(nLin(nLinha), nCol(5.0),"C.I. Pedido: ",oFont10b)
//	cTexto := transform(nMargemPD,PesqPict("SC5","C5_CITOTAL"))
//	oPrn:Say(nLin(nLinha), nCol(7.0),cTexto,oFont10 ,,,,1)

//	oPrn:Say(nLin(nLinha), nCol(7.5),"C.I. Novo: ",oFont10b)
//	cTexto := transform(nMargemPD2,PesqPict("SC5","C5_PMCITOT"))
//	oPrn:Say(nLin(nLinha), nCol(9.5),cTexto,oFont10 ,,,,1)
//EndIf

oPrn:Say(nLin(nLinha), nCol(10.5),"Vlr. ICMS: ",oFont9b)
cTexto := transform(nTotICMS,PesqPict("SC6","C6_VALOR"))
oPrn:Say(nLin(nLinha), nCol(13.5),cTexto,oFont9 ,,,,1)

oPrn:Say(nLin(nLinha), nCol(15.0),"Valor Mercadoria: ",oFont9b)
cTexto := transform(nTotProd,PesqPict("SC6","C6_VALOR"))
oPrn:Say(nLin(nLinha), nCol(19.0),cTexto,oFont9 ,,,,1)
nLinha += 0.5

oPrn:Say(nLin(nLinha), nCol(0.0),"Vlr.Frete: ",oFont9b)
cTexto := transform(nFrete,PesqPict("SC5","C5_FRETE"))
oPrn:Say(nLin(nLinha), nCol(03.0),cTexto,oFont9 ,,,,1)

If nIcmsRet # 0
	oPrn:Say(nLin(nLinha), nCol(05.0),"ICMS ST: ",oFont10b)
	cTexto := transform(nIcmsRet,PesqPict("SF2","F2_ICMSRET"))
	oPrn:Say(nLin(nLinha), nCol(09.5),cTexto,oFont10 ,,,,1)
EndIf

oPrn:Say(nLin(nLinha), nCol(10.5),"Vlr. IPI: ",oFont9b)
cTexto := transform(nTotIPI,PesqPict("SC6","C6_VALOR"))
oPrn:Say(nLin(nLinha), nCol(13.5),cTexto,oFont9 ,,,,1)

nValTotal := nTotProd + nTotIPI + nFrete + nIcmsRet

oPrn:Say(nLin(nLinha), nCol(15.0),"Valor Total: ",oFont9b)
cTexto := transform(nValTotal,PesqPict("SC6","C6_VALOR"))
oPrn:Say(nLin(nLinha), nCol(19.0),cTexto,oFont9 ,,,,1)
nLinha += 0.5

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.5

Return() // ImpTot()


//*****************************************************************************
Static Function DetCli(nLinha)
//*****************************************************************************

If SC5->C5_TIPO $ "DB"
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+cCliente+cLoja)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Fornecedor:",oFont10b)
	oPrn:Say(nLin(nLinha), nCol(2.0),cCliente+"/"+cLoja+" - "+AllTrim(SA2->A2_NOME),oFont10)
	nLinha += 0.5
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Endere?o:",oFont10b)
	cTexto := alltrim(SA2->A2_END) + " - " + alltrim(SA2->A2_BAIRRO) + " - CEP " + transform(SA2->A2_CEP,"@R 99999-999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	nLinha += 0.5
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Cidade:",oFont10b)
	cTexto := SA2->A2_MUN
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Estado:",oFont10b)
	cTexto := SA2->A2_EST
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	
	oPrn:Say(nLin(nLinha), nCol(0.0),If(Len(AllTrim(SA2->A2_CGC))==14,"CNPJ:","CPF:"),oFont10b)
	cTexto := transform(SA2->A2_CGC,If(Len(AllTrim(SA2->A2_CGC))==14,"@R 99.999.999/9999-99","@R 999.999.999-99"))
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Insc.Est.:",oFont10b)
	cTexto := SA2->A2_INSCR
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Fone:",oFont10b)
	cTexto := "(" + alltrim(SA2->A2_DDD) + ") " + transform(SA2->A2_TEL,"@R 9999-9999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Contato:",oFont10b)
	cTexto := SA2->A2_CONTATO
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	
Else
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+cCliente+cLoja)
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Cliente:",oFont10b)
	oPrn:Say(nLin(nLinha), nCol(2.0),cCliente+"/"+cLoja+" - "+AllTrim(SA1->A1_NOME),oFont10)
	nLinha += 0.5
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Endere?o:",oFont10b)
	cTexto := alltrim(SA1->A1_END) + " - " + alltrim(SA1->A1_BAIRRO) + " - CEP " + transform(SA1->A1_CEP,"@R 99999-999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	nLinha += 0.5
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Cidade/UF:",oFont10b)
	cTexto := AllTrim(SA1->A1_MUN)+"/"+SA1->A1_EST
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Tipo Cliente:",oFont10b)
	cTexto := X3Combo("C5_TIPOCLI",SC5->C5_TIPOCLI)
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	
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
	Else
		oPrn:Say(nLin(nLinha), nCol(10.0),"Insc.Est.:",oFont10b)
		cTexto := SA1->A1_INSCR
		oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
		nLinha += 0.5
	EndIf
	
	oPrn:Say(nLin(nLinha), nCol(0.0),"Fone:",oFont10b)
	cTexto := "(" + alltrim(SA1->A1_DDD) + ") " + transform(SA1->A1_TEL,"@R 9999-9999")
	oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Contato:",oFont10b)
	cTexto := SA1->A1_CONTATO
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
	nLinha += 0.5
	
EndIf

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+aTES[1])

//oPrn:Say(nLin(nLinha), nCol(0.0),"Tipo Sa?da:",oFont10b)
cTexto := SF4->F4_FINALID
//oPrn:Say(nLin(nLinha), nCol(2.0),cTexto,oFont10)
//oPrn:Say(nLin(nLinha), nCol(10.0),"CFOP:",oFont10b)
cTexto := aCFOP[1]
//oPrn:Say(nLin(nLinha), nCol(12.0),cTexto,oFont10)
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
	nLinha += 0.5
	
EndIf

nLinha += 0.5

Return() // DetCli()


//*****************************************************************************
Static Function ImpObs(nLinha)
//*****************************************************************************

TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.0),"Demais condi??es:",oFont11b)
nLinha += 0.5

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+cCondPag)

TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.0),"Pagamento:",oFont10b)
oPrn:Say(nLin(nLinha), nCol(03.0),SE4->E4_DESCRI,oFont10)

cTexto := ""

Do Case
	Case nTpPed = "A"
		cTexto := "A"
	Case nTpPed = "B"
		cTexto := "B"
	Case nTpPed = "C"
		cTexto := "C"
	Case nTpPed = "D"
		cTexto := "D"
	Case nTpPed = "E"
		cTexto := "E"
	Otherwise
		cTexto := "F"
EndCase

If !Empty(cTexto)
	oPrn:Say(nLin(nLinha), nCol(10.0),"Prioridade:",oFont10b)
	oPrn:Say(nLin(nLinha), nCol(12.0),cTexto+" - "+SC5->C5_X_EMPFA,oFont10)
EndIf

nLinha += 0.5
TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.0),"Representante:",oFont10b)
oPrn:Say(nLin(nLinha), nCol(03.0),cVendedor + " - " + Posicione("SA3",1,xFilial("SA3")+cVendedor,"A3_NOME"),oFont10)
nLinha += 0.5
TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.0),"Transportadora:",oFont10b)
oPrn:Say(nLin(nLinha), nCol(03.0),cTransp + " - " + Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME"),oFont10)
nLinha += 0.5
TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.0),"Tipo Frete:",oFont10b)
oPrn:Say(nLin(nLinha), nCol(03.0),cTpFrete,oFont10)
nLinha += 0.5
TstFimPag(@nLinha)

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
oPrn:Say(nLin(nLinha), nCol(00.0),"Observa??o do Pedido:",oFont10b)
nLinha += 0.5
oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

TstFimPag(@nLinha)

nTamObs := 100

For J := 1 To MlCount(cObsPed,nTamObs)
	cTexto := Alltrim(MemoLine(cObsPed,nTamObs,J))
	oPrn:Say(nLin(nLinha), nCol(00.0),cTexto,oFont10)
	nLinha += 0.4
	TstFimPag(@nLinha)
Next

nLinha += 0.5
TstFimPag(@nLinha)

oPrn:Say(nLin(nLinha), nCol(00.0),"Observa??o do Cadastro de Cliente:",oFont10b)
nLinha += 0.5
oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

TstFimPag(@nLinha)

nTamObs := 100

For J := 1 To MlCount(cObsCli,nTamObs)
	cTexto := Alltrim(MemoLine(cObsCli,nTamObs,J))
	oPrn:Say(nLin(nLinha), nCol(00.0),cTexto,oFont10)
	nLinha += 0.4
	TstFimPag(@nLinha)
Next

nLinha += 0.5
TstFimPag(@nLinha)

Return() // ImpObs()


//*****************************************************************************
Static Function ImpRod(nLinha)
//*****************************************************************************

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
oPrn:Line(nLin(nLinha), nCol(00.0), nLin(nLinha + 1.3), nCol(00.0))
oPrn:Line(nLin(nLinha), nCol(03.8), nLin(nLinha + 1.3), nCol(03.8))
oPrn:Line(nLin(nLinha), nCol(07.6), nLin(nLinha + 1.3), nCol(07.6))
oPrn:Line(nLin(nLinha), nCol(11.4), nLin(nLinha + 1.3), nCol(11.4))
oPrn:Line(nLin(nLinha), nCol(15.2), nLin(nLinha + 1.3), nCol(15.2))
oPrn:Line(nLin(nLinha), nCol(19.0), nLin(nLinha + 1.3), nCol(19.0))
nLinha += 0.2

oPrn:Say(nLin(nLinha), nCol(01.9),"Peso:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(05.7),"Volumes:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(09.5),"Visto Vendas:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(13.3),"Visto Expedi??o:",oFont10b ,,,,2)
oPrn:Say(nLin(nLinha), nCol(17.1),"Visto Financeiro:",oFont10b ,,,,2)
nLinha += 0.6

cTexto := alltrim(transform(nTotPeso,PesqPict("SB1","B1_PESO")))
oPrn:Say(nLin(nLinha), nCol(01.9),cTexto,oFont10 ,,,,1)
nLinha += 0.5

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
oPrn:Line(nLin(nLinha), nCol(00.0), nLin(nLinha + 1.5), nCol(00.0))
oPrn:Line(nLin(nLinha), nCol(19.0), nLin(nLinha + 1.5), nCol(19.0))
nLinha += 0.2

cTexto := "Pedido faturado atrav?s da(s) Nota(s) Fiscal(is)"
oPrn:Say(nLin(nLinha), nCol(00.2),cTexto,oFont10b)
nLinha += 0.8

cTexto := "N? ___________  de ____ / ____ / _______      "
cTexto += "N? ___________  de ____ / ____ / _______      "
cTexto += "N? ___________  de ____ / ____ / _______      "
oPrn:Say(nLin(nLinha), nCol(00.2),cTexto,oFont10b)
nLinha += 0.5

oPrn:Line(nLin(nLinha), nCol(0.0), nLin(nLinha), nCol(19))
nLinha += 0.2


Return() // ImpRod()


//*****************************************************************************
Static Function PVImp(cProd,cTES)
//*****************************************************************************

Local aArea	:= GetArea()
Local aRet	:= {}

If SC5->C5_TIPO $ "DB"
	
	MaFisIni(SC5->C5_CLIENTE,;			              // 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,;		                  // 2-Loja do Cliente/Fornecedor
	"C",;							      // 3-C:Cliente , F:Fornecedor
	"N",;				                  // 4-Tipo da NF
	SC5->C5_TIPOCLI,;			              // 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100",{"SF2","SD2"}),; // 6-Relacao de Impostos que suportados no arquivo
	,;							          // 7-Tipo de complemento
	,;							          // 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;					              // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MTR700")					          // 10-Nome da rotina que esta utilizando a funcao
	
Else
	
	MaFisIni(SC5->C5_CLIENTE,;			              // 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,;		                  // 2-Loja do Cliente/Fornecedor
	"C",;							      // 3-C:Cliente , F:Fornecedor
	"N",;				                  // 4-Tipo da NF
	SC5->C5_TIPOCLI,;			              // 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100",{"SF2","SD2"}),; // 6-Relacao de Impostos que suportados no arquivo
	,;							          // 7-Tipo de complemento
	,;							          // 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;					              // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MTR700")					          // 10-Nome da rotina que esta utilizando a funcao
	
EndIf

MaFisAdd(SC6->C6_PRODUTO,; 				  // 1-Codigo do Produto ( Obrigatorio )
SC6->C6_TES,;					  // 2-Codigo do TES ( Opcional )
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


//*****************************************************************************
Static Function AjustaSX1(cPerg)
//*****************************************************************************

_aArea := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)

aRegs:={}
//          Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

If cPerg = "FATR01"
	AAdd(aRegs,{cPerg,"01","Impressao ?     ","Gera Excel ?     ","Gera Excel ?     ","mv_ch0","N",01,0,0,"C","","mv_par01","Total","","","","","Saldo","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Pedido de  ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","SC5"})
	aAdd(aRegs,{cPerg,"03","Pedido ate ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SC5"})
	aAdd(aRegs,{cPerg,"04","Emissao de ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Emissao ate?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
	
EndIf

For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]
		MsUnlock()
		DbCommit()
	Endif
Next

RestArea(_aArea)

Return()
