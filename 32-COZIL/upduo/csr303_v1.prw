#include "rwmake.ch"

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ CSR30330     ³Autor  ³ Elvis Kinuta        ³ Data ³ 01/11/10 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Emissao do Orcamento de Vendas                               ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

User Function CSR303()
	cFix1     :="Texto Fixo 1"
	cFix2     :="Texto Fixo 2"
	cFix3     :="Texto Fixo 3"
	RptStatus({||ListarP()},"Emitindo (Formato Paisagem)")

Return

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ Listar     ³Autor  ³ Elvis Kinuta          ³ Data ³ 01/11/10 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Emissao do Orcamento de Vendas Paisagem                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

Static Function ListarP()
	cNumero  := SCJ->CJ_NUM
	cEmissao := DtoC(dDataBase)
		
	Do Case
		Case Month(dDataBase) == 1  ;  cMes := "janeiro"
		Case Month(dDataBase) == 2  ;  cMes := "fevereiro"
		Case Month(dDataBase) == 3  ;  cMes := "marco"
		Case Month(dDataBase) == 4  ;  cMes := "abril"
		Case Month(dDataBase) == 5  ;  cMes := "maio"
		Case Month(dDataBase) == 6  ;  cMes := "junho"
		Case Month(dDataBase) == 7  ;  cMes := "julho"
		Case Month(dDataBase) == 8  ;  cMes := "agosto"
		Case Month(dDataBase) == 9  ;  cMes := "setembro"
		Case Month(dDataBase) == 10 ;  cMes := "outubro"
		Case Month(dDataBase) == 11 ;  cMes := "novembro"
		Case Month(dDataBase) == 12 ;  cMes := "dezembro"
	Endcase
	
	cExt     := "São Paulo, " + substr(cEmissao,1,2) + " de " + cMes + "  " +  str(year(dDatabase),4)
	
	If SCJ->(FieldPos("CJ_NOMCLI")) > 0
		cNomCli  	:= SCJ->CJ_NOMCLI
	else
		cNomCli	:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_NOME")
	Endif
	
	cEndCli:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_END")

	cCidCli		:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_MUN")
	cUFCli		:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_EST")
	cConCli		:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_CONTATO")
	cFonCli		:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_TEL")
	cDddCli		:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_DDD")
	cEmaCli		:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_EMAIL")
	cFaxCli		:=Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_FAX")
	cNomVen 	:=Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_VEND1,"A3_NOME")
	cDddVen		:=Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_VEND1,"A3_DDDTEL")
	cTelVen		:=Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_VEND1,"A3_TEL")
	cEmaVen 	:=Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_VEND1,"A3_EMAIL")
	cCondPag	:=Posicione("SE4",1,xFilial("SE4") + SCJ->CJ_CONDPAG, "E4_DESCRI")
			
	DbSelectArea("SE4")
	Dbseek(xFilial("SE4") + SCJ->CJ_CONDPAG)
	
	cCondPag 	:= SE4->E4_DESCRI
	cTotal   	:= ""
	nTotal   	:= 0.00
	cNit		:= "" ; cQtd:= "" ; cUm :="" ; aCod:=""    ; cRef :=""; cDes:=""; cSet :=""
	cPrc		:= "" ;cPrc:= "" ; cIPI:="" ; aVIP:=""    ; cVto :=""; cTot:=""; cAnd :=""
	nFreteTotal := 0
	
	cSMoeda	:="R$"
	
	aItens		:={}
	aOrg		:={}
	
	DbSelectArea("SCK")
	DbSeek(xFilial("SCK") + SCJ->CJ_NUM)
	Do While !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM
		cIt  := SCK->CK_ITEM
		cQtd := TRANSFORM(SCK->CK_QTDVEN, "@R 999999")
		cUm  := SCK->CK_UM
		cCod := SCK->CK_PRODUTO
		cPrc := TRANSFORM(SCK->CK_PRCVEN, "@R 999,999,999.99")
		nTot := ROUND(SCK->CK_PRCVEN * SCK->CK_QTDVEN,2)
		cTot := TRANSFORM(nTot, "@R 999,999,999.99")
		cVto := TRANSFORM(SCK->CK_VALOR, "@R 999,999,999.99")
		cMem := SCK->CK_XESPEC
		If Alltrim(SCK->CK_PRODUTO) == "25.06.0005"		
			nFreteTotal += SCK->CK_VALOR
		Endif
	
		cNesp1	:=Posicione("SB1",1,xFilial("SB1") + SCK->CK_XAC1,"B1_DESC")
		cNesp2	:=Posicione("SB1",1,xFilial("SB1") + SCK->CK_XAC2,"B1_DESC")
		cNesp3	:=Posicione("SB1",1,xFilial("SB1") + SCK->CK_XAC3,"B1_DESC")
		cNesp4	:=Posicione("SB1",1,xFilial("SB1") + SCK->CK_XAC4,"B1_DESC")
		cNesp5	:=Posicione("SB1",1,xFilial("SB1") + SCK->CK_XAC5,"B1_DESC")       
	
		If !Empty(SCK->CK_XAC1)
			cEsp1 := "     Acessorio 1: " + Alltrim(cNesp1)
		Else
			cEsp1 := ""
		EndIf
		
		If !Empty(SCK->CK_XAC2)
			cEsp2 := "     Acessorio 2: " + Alltrim(cNesp2)
		Else
			cEsp2 := ""
		EndIf
		
		If !Empty(SCK->CK_XAC3)
			cEsp3 := "     Acessorio 3: " + Alltrim(cNesp3)
		Else
			cEsp3 := ""
		EndIf
		
		If !Empty(SCK->CK_XAC4)
			cEsp4 := "     Acessorio 4: " + Alltrim(cNesp4)
		Else
			cEsp4 := ""
		EndIf
		
		If !Empty(SCK->CK_XAC5)
			cEsp5 := "     Acessorio 5: " + Alltrim(cNesp5)
		Else
			cEsp5 := ""
		EndIf
	
		DbSelectArea("SB1")
		cDesc:=""
		if DbSeek(xFilial("SB1") + SCK->CK_PRODUTO)
			cDesc:=""
			If !Empty(cMem)
				cDesc :=  "DESCRIÇÃO: "+ alltrim(SB1->B1_DESC) + "       ESPECIFICAÇÕES TECNICAS ..:" + cMem + cEsp1+ cEsp2+ cEsp3+ cEsp4+ cEsp5
			Else
				cDesc :=  "DESCRIÇÃO: "+  alltrim(SB1->B1_DESC) + cEsp1+ cEsp2+ cEsp3+ cEsp4+ cEsp5+ "                                                                                                                                                                               "
			EndIf
		Endif
	
		cXIPI := Posicione("SF4",1,xFilial("SF4")+SCK->CK_TES,"F4_IPI")
		IF cXIPI == "S"
			cIPI := TRANSFORM(SB1->B1_IPI,"@ 99")
			nIPI := Round(nTot * (SB1->B1_IPI/100),2)
			nVto := SCK->CK_VALOR + nIPI
			cVip := TRANSFORM(nIPI, "@R 999,999.99")
			cVto := TRANSFORM(nVto, "@R 999,999,999.99")
			cAnd := SCK->CK_XANDAR
			cSet := SCK->CK_XSETOR
		Else
			*/
			cIPI := ""
			nIPI := 0.00
			nVto := SCK->CK_VALOR
			cVip := ""
			cVto := TRANSFORM(nVto, "@R 999,999,999.99")
			cAnd := SCK->CK_XANDAR
			cSet := SCK->CK_XSETOR
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Classificacao da impressao dos produtos pelo Andar + Setor. Elemento 12 do Array	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		aadd (aOrg ,{"x", cQtd, cCod, cDesc, cPrc, cTot, cIPI, cVip,cVto,cAnd,cSet, cAnd+cSet })
	   //	ASORT(aOrg,,, { |x, y| x[12] < y[12] }) 
			
		nTotal := nTotal + nVto
		DbSelectArea("SCK")
		DbSkip()
	Enddo

	For	a:= 1 to len(aOrg)
		aDesc	:={}
		cDesc_	:= aOrg[a][4] 						//	Descricao
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Controle da quantidade de caracteres para impressao no quadro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		for b:= 1 TO MlCount(cDesc_,85)
			Aadd (aDesc, MemoLine(cDesc_,85,b))
		Next b
			
		aadd(aItens ,{	aOrg[a][1] ,;		// 	x
		 				aOrg[a][2] ,;		// 	Quantidade
		 				aOrg[a][3] ,;		// 	Codigo
	                    aDesc	   ,;		//	Descricao
		 				aOrg[a][5] ,;		//	Preco Unitari
		 				aOrg[a][6] ,;		//	SubTotal
		 				aOrg[a][7] ,;		//	Aliquota IPI
		 				aOrg[a][8] ,;		//	Valor IPI
		 				aOrg[a][9] ,;		//	Valor total
		 				aOrg[a][10],;		//	Andar
		 		 		aOrg[a][11]	}	)	//	Setor
		 				
	Next

cTotal := TRANSFORM(nTotal, "@R 999,999,999.99")
cCab0 := " Prezados Senhores(as), "
cCab1 := " "
cCab2 := " "
cAss0 := "Sendo só para o momento e no aguardo do pronunciamento de V.Sas, subscrevemos-nos."
cAss1 := "Atenciosamente,"
If ALLTRIM(SM0->M0_CODIGO) == '01' .or. ALLTRIM(SM0->M0_CODIGO) == "99"
	cAss2 := "_____________________________________    ____________________________________"
Else
	cAss2 := "____________________________________"
Endif
cAss3 :=""
cRod1:=""
cRod2:=""
cRod3:=""
cRod4:=""
cAss3:= "xxxxxxxxxxxxxxxxx - xxxxxxxxxxxxxxxxx    xxxxxxxxxxxxxxxx - xxxxxxxxxxxxxxx"
cRod1 := SM0->M0_NOMECOM // "COZIL EQUIPAMENTOS INDUSTRIAIS LTDA"
cRod2 := Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - São Paulo - "+Alltrim(SM0->M0_CIDCOB)	//"RUA BOTUCATU, 200  - Jardim Nossa Senhora D' Ajuda- Itaquaquecetuba - São Paulo - Brasil-  CEP: 08576660"
cRod3 := "Tel.:(0xx11) "+SM0->M0_TEL+"- Fax: (0xx11) "+SM0->M0_FAX
cRod4 := "    E-Mail: vendas@cozilandia.com.br  /  comercial@cozilandia.com.br

oFont1:= TFont():New( "Courier New"    	,,18,,.t.,,,,,.f. ) // NEGRITO
oFont2:= TFont():New( "Courier New"      	,,12,,.t.,,,,,.f. ) // NEGRITO
oFont3:= TFont():New( "Courier New" 		,,12,,.f.,,,,,.f. )
oFont4:= TFont():New( "Courier New"      	,,14,,.t.,,,,,.f. ) // NEGRITO
oFont5:= TFont():New( "Courier New"      	,,14,,.f.,,,,,.f. )
oFont6:= TFont():New( "Courier New"      	,,10,,.f.,,,,,.f. )
oFont7:= TFont():New( "Courier New"      	,,08,,.f.,,,,,.f. )
oFont8:= TFont():New( "Courier New"      	,,10,,.t.,,,,,.f. )
oFont9:= TFont():New( "Courier New"      	,,08,,.f.,,,,,.f. )
oFont0:= TFont():New( "Courier New"      	,,08,,.t.,,,,,.f. )

// Impresao do Logotipo
oPrn := TMSPrinter():New()
oPrn:SetLandscape()
oPrn:StartPage()
oPrn:Setup()
ImpCabecP()
nCol := 860
lCont := .F.
for a:=1 to len(aItens)
	nCol := nCol + 40 										// Controle de Impressao das Pautas
	if nCol > 2000 //1800/2140
		lCont := .T.   ;  ImpRodaP()  ;  ImpCabecP()  ;  nCol := 890
	Endif
	if nCol # 900 .and. aItens[a, 1] = "x"
	oPrn:Box(nCol,0050, nCol + 3,2464)  					// Controle de Impressao das Pautas
		nCol := nCol + 40
	Endif
		

	//cBitmap := "/FOTOS/"+Alltrim(aItens[a, 3])+".BMP" //Busca na Pasta Protheus_Data
	cNcm 	:= Posicione("SB1",1,xFilial("SB1") +aItens[a, 3],"B1_POSIPI")
	
	oPrn:Say(nCol - 10,0040, aItens[a, 2]                  ,oFont7,100) 	//Quantidade
	oPrn:Say(nCol - 10,0200, aItens[a, 3]                  ,oFont7,100) 	//Codigo       
	oPrn:Say(nCol + 40 - 10,0200, "NCM:. "+ cNCM   ,oFont7,100) 			//NCM
	//oPrn:SayBitMap(nCol - 09,2050,cBitmap,200,200) 						//Foto
	oPrn:Say(nCol - 10,1600, aItens[a, 5]                  ,oFont7,100) 	//Pr.Unitario
	If !EMPTY(aItens[a, 7])
        oPrn:Say(nCol - 10,1950, aItens[a, 7]+"%"              ,oFont7,100) 	//IPI
    Endif
	oPrn:Say(nCol - 10,2010, aItens[a, 8]                  ,oFont7,100) 	//Valor IPI
	oPrn:Say(nCol - 10,2200, aItens[a, 9]                  ,oFont7,100) 	//Valor Total

    /*
    oPrn:Say(nCol - 10,0040, aItens[a, 2]                  ,oFont7,100) 	//Quantidade
	oPrn:Say(nCol - 10,0200, aItens[a, 3]                  ,oFont7,100) 	//Codigo       
	oPrn:Say(nCol + 40 - 10,0200, "NCM:. "+ cNCM   ,oFont7,100) 			//NCM
	oPrn:SayBitMap(nCol - 09,2050,cBitmap,200,200) 						//Foto
	oPrn:Say(nCol - 10,2250, aItens[a, 5]                  ,oFont7,100) 	//Pr.Unitario
	oPrn:Say(nCol - 10,2520, aItens[a, 7]                  ,oFont7,100) 	//IPI
	oPrn:Say(nCol - 10,2655, aItens[a, 8]                  ,oFont7,100) 	//Valor IPI
	oPrn:Say(nCol - 10,2885, aItens[a, 9]                  ,oFont7,100) 	//Valor Total
    */
 	
 	If !Empty(aItens[a,10])
 		oPrn:Say(nCol - 10,0520, "Andar: " + aItens[a,10] + " Setor: " + aItens[a,11]             ,oFont6,100) 	//Descricao  
    
    For c:= 1 To Len (aItens[a,4])
		oPrn:Say(nCol + 40 - 10,0468, aItens[a, 4,c ]           ,oFont7,100) 	//Descricao
		nCol := nCol + 40 													
		if nCol > 2140  //1800												// Controle de Impressao de Pautas
			lCont := .T.   ;  ImpRodaP()  ;  ImpCabecP()  ;  nCol := 890
		Endif		
Next	
    Else
    
For c:= 1 To Len (aItens[a,4])
		oPrn:Say(nCol - 10,0468, aItens[a, 4,c ]           ,oFont7,100) 	//Descricao
		nCol := nCol + 40 													
		if nCol > 2140  //1800												// Controle de Impressao de Pautas
			lCont := .T.   ;  ImpRodaP()  ;  ImpCabecP()  ;  nCol := 890
		Endif		
Next	
EndIf	
Next A
lCont := .F.
ImpRodaP()
oPrn:Preview()
MS_FLUSH()
Return

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ Listar     ³Autor  ³ Elvis Kinuta          ³ Data ³ 01/11/10 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Emissao do Orcamento de Vendas (Paisagem)                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
Static Function ImpCabecP()
cBitMap:= "LGRL"+cEmpAnt+".Bmp"
//cBitIso:= ""
//cBitSel:= "LOGO_TOPFIVE.BMP"
oPrn:SayBitmap(0100,1200,cBitMap,300,300 )
//oPrn:SayBitmap(0140,1400,cBitMap,700,300 ) //700,500

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Primeira Caixa de Texto - Cabecalho					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrn:Box(0790,0050, 0875,2464)
//oPrn:Box(0793,0050, 0878,3150)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Segunda Caixa de Texto - Itens						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrn:Box(0790,0050, 2200,0050)    					//Borda Esquerda
oPrn:Box(0790,0053, 2200,0185)    					//Quantidade
oPrn:Box(0790,0185, 2200,0450)    					//Codigo
oPrn:Box(0790,0450, 2200,1700)    					//Descricao
oPrn:Box(0790,1700, 2200,1910)    					//Preco Unitario
oPrn:Box(0790,1910, 2200,2021)    					//Aliquota IPI
oPrn:Box(0790,2021, 2200,2205)    					//Valor do IPI
oPrn:Box(0790,2205, 2200,2464)    					//Valor Total
//oPrn:Box(0790,2850, 2200,3150)	  					//

/*
oPrn:Box(0790,1966, 2200,2176)    					//Preco Unitario
oPrn:Box(0790,2179, 2200,2290)    					//Aliquota IPI
oPrn:Box(0790,2293, 2200,2552)    					//Valor do IPI
oPrn:Box(0790,2555, 2200,2814)    					//Valor Total
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Terceira Caixa de Texto - Totais					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:Box(2290,0050, 2210,2464)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quarta Caixa de Texto - Observacoes gerais			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrn:Say(0250,0060, cExt                           		,oFont5,100)
oPrn:Say(0100,0040, "Orçamento nº: " + SCJ->CJ_NUM 	,oFont1,100)
oPrn:Say(0320,0060, "À"                            		,oFont3,100)
oPrn:Say(0370,0060, cNomCli                        		,oFont3,100)
oPrn:Say(0420,0060, cEndCli                        		,oFont3,100)
oPrn:Say(0470,0060, cCidCli + " " +  cUFCli        		,oFont3,100)
cFonFax := "Fone : ("+cDddCli+") "+ Alltrim(cFonCli)
If !Empty(cFaxCli)
	cFonFax := cFonFax + " Fax : " + cFaxCLi
Endif
oPrn:Say(0520,0060, cFonFax           ,oFont3,100)
cImp := "A/C " + AllTrim(cConCli)
If !Empty(cEmaCli)
	cImp := cImp + " e-mail: " + cEmaCLi
Endif

If Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_PESSOA") == "J"
	oPrn:Say(0640,0060, "CNPJ do Cliente: "+Transform(Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_CGC"),"@R 99.999.999/9999-99")           ,oFont3,100)
Else
	oPrn:Say(0640,0060, "CPF do Cliente: "+Transform(Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_CGC"),"@R 999.999.999-99")           ,oFont3,100)
Endif
oPrn:Say(0300,1700, "Vendedor: "+cNomVen                       ,oFont3,100)
oPrn:Say(0350,1700, "Tel:      "+"("+cDddVen+") - "+cTelVen    ,oFont3,100)
oPrn:Say(0400,1700, "E-Mail   "+cEmaVen                        ,oFont3,100)

If SCJ->CJ_TPFRETE = "C"
	oPrn:Say(0450,1700, "Frete:  CIF"    ,oFont3,100)  
ElseIf SCJ->CJ_TPFRETE = "F"
	oPrn:Say(0450,1700, "Frete:  FOB"    ,oFont3,100)  
EndIf

If SCJ->CJ_FRETE <> 0 
	oPrn:Say(0500,1700, "Valor Frete: "+Transform(SCJ->CJ_FRETE,"@e 999,999,999.99")       ,oFont3,100)
ElseIf nFreteTotal <> 0
	oPrn:Say(0500,1700, "Valor Frete: "+Transform(nFreteTotal,"@e 999,999,999.99")       ,oFont3,100)
Else
	oPrn:Say(0500,1700, "Valor Frete: NÃO POSSUI VALOR"     ,oFont3,100)
Endif
oPrn:Say(0550,1700, "Condição de Pagamento: "+cCondPag ,oFont3,100)
	
oPrn:Say(0580,0060, cImp                           		,oFont3,100)
oPrn:Say(0660,0060, cCab1                          		,oFont3,100) 
oPrn:Say(0700,0060, cCab2                          		,oFont3,100)
oPrn:Say(0830,0060, "Qtd."                       		,oFont2,100)
oPrn:Say(0830,0200, "Codigo"                       		,oFont2,100)
oPrn:Say(0830,0468, "Descricao do Equipamento"     		,oFont2,100)
oPrn:Say(0830,1718, "Pr.Unit. "                    		,oFont2,100)
oPrn:Say(0830,1928, "IPI"                          		,oFont2,100)
oPrn:Say(0830,2039, "Vlr. IPI"                     		,oFont2,100) // Valor do IPI
oPrn:Say(0830,2223, "Total C/IPI" 		            	,oFont2,100)

/*
oPrn:Say(0830,2000, "Produto"                       	,oFont2,100)
oPrn:Say(0830,2310, "Pr.Unit. "                    		,oFont2,100)
//oPrn:Say(0830,2110, "SubTotal "                    	,oFont2,100)
oPrn:Say(0830,2510, "IPI"                          		,oFont2,100)
oPrn:Say(0830,2610, "Vlr. IPI"                     		,oFont2,100) // Valor do IPI
oPrn:Say(0830,2850, "Total C/IPI" 		            	,oFont2,100)
*/
Return

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ Listar     ³Autor  ³ Elvis Kinuta          ³ Data ³ 01/11/10 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Function responsavel pela impressao do Cabecalho e Rodape    ³
³          ³       das Condicoes de Fornecimento                          ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

Static Function Cabcdf()
cBitMap:= "LOGO.Bmp"
cBitIso:= ""
cBitSel:= "LOGO_TOPFIVE.BMP"
oPrn:SayBitmap(1940,2550,cBitIso,500,500 )
oPrn:SayBitmap(0140,1400,cBitMap,700,500 )
//oPrn:SayBitmap(1940,2550,cBitSel,500,500 )  LOGO TOTVS


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quarta Caixa de Texto - Observacoes gerais			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:Box(2200,0010, 2205,2450)

oPrn:Say(0350,0010, cExt                           		,oFont5,100)
oPrn:Say(0200,0040, "Orçamento nº: " +SCJ->CJ_NUM 		,oFont1,100)
oPrn:Say(0420,0060, "À"                            		,oFont3,100)
oPrn:Say(0470,0060, cNomCli                        		,oFont3,100)
oPrn:Say(0520,0060, cEndCli                        		,oFont3,100)
oPrn:Say(0570,0060, cCidCli + " " +  cUFCli        		,oFont3,100)
cFonFax := "Fone : ("+cDddCli+") "+ Alltrim(cFonCli)
If !Empty(cFaxCli)
	cFonFax := cFonFax + " Fax : " + cFaxCLi
Endif
oPrn:Say(0620,0060, cFonFax           ,oFont3,100)
cImp := "A/C " + AllTrim(cConCli)
If !Empty(cEmaCli)
	cImp := cImp + " e-mail: " + cEmaCLi
Endif

oPrn:Say(0400,2350, "Vendedor: "+cNomVen                       ,oFont3,100)
oPrn:Say(0450,2350, "Tel:   "+"("+cDddVen+") - "+cTelVen       ,oFont3,100)
oPrn:Say(0500,2350, "E-Mail   "+cEmaVen                        ,oFont3,100)

If SCJ->CJ_TPFRETE = "C"
	oPrn:Say(0550,2350, "Frete:  CIF"    ,oFont3,100)  
ElseIf SCJ->CJ_TPFRETE = "F"
	oPrn:Say(0550,2350, "Frete:  FOB"    ,oFont3,100)  
EndIf
	


oPrn:Say(0640,0010,"_______________________________________________________________________________________________________________________________________________________"                            ,oFont3,100)
cCab0 := " Prezados Senhores(as), "
cCab1 := " Atendendo à solicitação de V.Sas., estamos enviando nosso orçamento para o fornecimento do(s) seguinte(s) produto(s),"
cCab2 := "   "
cAss0 := "Sendo só para o momento e no aguardo do pronunciamento de V.Sas, subscrevemos-nos."
cAss1 := "Atenciosamente,"
if ALLTRIM(SM0->M0_CODIGO) == '01' .or. ALLTRIM(SM0->M0_CODIGO) == "99"
	cAss2 := "_____________________________________    ____________________________________"
Else
	cAss2 := "____________________________________"
Endif
cAss3 :=""
cRod1:=""
cRod2:=""
cRod3:=""
cRod4:=""
cAss3:= "xxxxxxxxxxxxxxxxx - xxxxxxxxxxxxxxxxx    xxxxxxxxxxxxxxxx - xxxxxxxxxxxxxxx"
cRod1 := SM0->M0_NOMECOM // "COZIL EQUIPAMENTOS INDUSTRIAIS LTDA"
cRod2 := Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - São Paulo - "+Alltrim(SM0->M0_CIDCOB)	//"RUA BOTUCATU, 200  - Jardim Nossa Senhora D' Ajuda- Itaquaquecetuba - São Paulo - Brasil-  CEP: 08576660"
cRod3 := "Tel.:(0xx11) "+SM0->M0_TEL+" -  Fax: (0xx11) "+SM0->M0_FAX
cRod4 := "    E-Mail: vendas@cozilandia.com.br  /  comercial@cozilandia.com.br
Return()




/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ Listar     ³Autor  ³ Elvis Kinuta          ³ Data ³ 01/11/10 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Emissao do Orcamento de Vendas(Paisagem)                     ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
Static Function ImpRodaP()
if lCont
	oPrn:Say(2225,0135, "Continua na Proxima Página"	,oFont5,100)
else
	oPrn:Say(2225,1100, "Total Geral do Orçamento"     ,oFont4,100)
	oPrn:Say(2225,2130, cTotal                         ,oFont4,100)
	
	lCont := .T.;ImpRodaP(); nCol := 200
	oPrn:Say(100,0040, "Orçamento nº: " + SCJ->CJ_NUM + "           Condições de Fornecimento"      ,oFont1,100)	   
   
   cCol 	:= 	200
   
   If SCJ->CJ_XTPPV == "A"	// Se for um orçamento de assistencia tecnica, a impressao é diferente

   //'PEDIDO: '+SD2->D2_PEDIDO + Space(88-len('PEDIDO: '+SD2->D2_PEDIDO))
   
   		oPrn:Say(nCol + 160,0030, SubStr("1.Pagamento: SUJEITO A APROVAÇÃO PELA ÁREA FINANCEIRA",1,100)+CHR(10)+CHR(13)+SubStr("1.Pagamento: SUJEITO A APROVAÇÃO PELA ÁREA FINANCEIRA",101),oFont5,100)
   		oPrn:Say(nCol + 220,0030, SubStr("2.Prazo de Entrega de peças e serviços: 05 dias após aprovação via e-mail.",1,100)+CHR(10)+CHR(13)+SubStr("2.Prazo de Entrega de peças e serviços: 05 dias após aprovação via e-mail.",101),oFont5,100)
   		oPrn:Say(nCol + 280,0030, SubStr("3.Validade da proposta: 10 Dias",1,100)+CHR(10)+CHR(13)+SubStr("3.Validade da proposta: 10 Dias",101),oFont5,100)
   		oPrn:Say(nCol + 340,0030, SubStr("4.Frete: Por conta do cliente",1,100)+CHR(10)+CHR(13)+SubStr("4.Frete: Por conta do cliente",101),oFont5,100)
   		oPrn:Say(nCol + 400,0030, SubStr("5.Considerações: Solicitamos que a confirmação do orçamento seja assinada e devolvida via fax ou e-mail nos contatos: ",1,100)+CHR(10)+CHR(13)+SubStr("5.Considerações: Solicitamos que a confirmação do orçamento seja assinada e devolvida via fax ou e-mail nos contatos: ",101,200),oFont5,100)
   		oPrn:Say(nCol + 460,0050, SubStr("(11) 2832-8066 / assistenciatecnica@cozil.com.br",1,100)+CHR(10)+CHR(13)+SubStr("(11) 2832-8066 / assistenciatecnica@cozil.com.br",101),oFont5,100)
   	
   	Else
                             		
		cXprc 	:= 	SCJ->CJ_XPRC  // PRECO
		cXpde	:=	SCJ->CJ_XPDE  // PRAZO DE ENTREGA
		cXcdp	:=	SCJ->CJ_CONDPAG  // CONDICAO DE PAGAMENTO
		cXmei	:=	SCJ->CJ_XMEI  // MONTAFEN E INSTALACAO
		
		oPrn:Say(nCol,0010,       "PREÇOS................................:",oFont8,100)
		oPrn:Say(nCol + 040,0010, "Entendem-se líquidos, com acréscimo do IPI respectivo conforme aliquota vigente no mês de faturamento, para material ",oFont6,100) 
		
		If !Empty(cXprc)
			oPrn:Say(nCol + 080,0010, "posto " + Alltrim(cXprc) + ", embalado em plástico bolha.",oFont6,100)
		Else
			oPrn:Say(nCol + 080,0010, "posto fábrica em Itaquaquecetuba na área metropolitana de São Paulo, embalado em plástico bolha.",oFont6,100)
		EndIf                           
		
		oPrn:Say(nCol + 160,0010, "TRANSPORTE............................:",oFont8,100)
		oPrn:Say(nCol + 200,0010, "Incluso na região metropolitana de São Paulo. Para entrega fora da Grande São Paulo a despesa de frete correrá por conta ",oFont6,100)
		oPrn:Say(nCol + 240,0010, "do cliente. Está fora de nosso escopo a movimentação horizontal e vertical na obra.",oFont6,100)
	
		oPrn:Say(nCol + 320,0010, "PRAZO DE ENTREGA......................:",oFont8,100)
		
		If !Empty(cXpde)	
			oPrn:Say(nCol + 360,0010, "Dentro de " + Alltrim(cXpde) + " dias após confirmação do pedido e eventuais condições de medição em obra, com aprovação dos desenhos",oFont6,100) 
		Else	
			oPrn:Say(nCol + 360,0010, "Dentro de 45/60 dias após confirmação do pedido e eventuais condições de medição em obra, com aprovação dos desenhos ",oFont6,100)
		EndIf	
		
		oPrn:Say(nCol + 400,0010, "técnicos de fabricação.",oFont6,100)
		nCol := nCol + 40                                           
	
		oPrn:Say(nCol + 440,0010, "CONDICOES DE PAGAMENTO................:",oFont8,100)
		
		If !Empty(cXcdp)
			oPrn:Say(nCol + 480,0010, Alltrim(cXcdp),oFont6,100) 
		Else	
			oPrn:Say(nCol + 480,0010, "30 % de sinal, como confirmação do pedido e saldo a 30/60/90 dias da data do pedido.",oFont6,100)
		EndIf	
		
		oPrn:Say(nCol + 520,0010, "Dispomos de Cartão BNDES, PROGER, Banco do Brasil ou Caixa Econômica Federal: A liberação do pagamento através de orgãos ",oFont6,100)
		oPrn:Say(nCol + 560,0010, "financiadores deverá ocorrer até 10 dias antes da data de entrega contratual.",oFont6,100)
		oPrn:Say(nCol + 640,0010, "MONTAGEM E INSTALACAO A PONTOS........:",oFont8,100)
		
		If !Empty(cXmei)
			oPrn:Say(nCol + 680,0010, Alltrim(Substr(cXmei,1,120))	 ,oFont6,100)
			oPrn:Say(nCol + 720,0010, Alltrim(Substr(cXmei,120,240)),oFont6,100)
		Else
			oPrn:Say(nCol + 680,0010, "Fornecimento de um projeto executivo no que tange aos pontos de tomadas elétricas, hidráulicas, gás GLP ou Natural,",oFont6,100)
			oPrn:Say(nCol + 720,0010, "escoamentos, com os respectivos manuais de instalação e operação.",oFont6,100)
		EndIf	
		
		oPrn:Say(nCol + 760,0010, "Caso Vossas Senhorias optem pela instalação executada por nossos técnicos da fábrica, esses serviços serão orçados em ",oFont6,100)
		oPrn:Say(nCol + 800,0010, "separado e submetidos a sua aprovação.",oFont6,100)
		oPrn:Say(nCol + 840,0010, "Não estão inclusos em nosso escopo de fornecimento ou instalação:",oFont6,100)							
		oPrn:Say(nCol + 880,0010, "- torneiras, misturadores, sifões, válvulas em geral, registros, plugs, tomadas elétricas e quadros de comando;",oFont6,100)							
		oPrn:Say(nCol + 920,0010, "- válvulas reguladoras de pressão de gás,",oFont6,100)							
		oPrn:Say(nCol + 960,0010, "- redes elétricas, hidráulicas e de refrigeração remota;.",oFont6,100)							
		nCol 		:= 1300
	
		oPrn:Say(nCol ,0010,      "GARANTIA..............................:",oFont8,100)
		oPrn:Say(nCol + 040,0010, "06 (Seis) meses para equipamentos fabricados pela Cozilandia, contra eventuais defeitos de fabricação, a partir da data de emissão",oFont6,100) 
		oPrn:Say(nCol + 080,0010, "da Nota Fiscal. A garantia não cobre: mau funcionamento ocasionado por falta de pressão ou vazão de água ou gás; falta de",oFont6,100)
		oPrn:Say(nCol + 120,0010, "limpeza que ocasiona bloqueios em queimadores, evaporadores, condensadores ou compressores; uso inadequado dos equipamentos;",oFont6,100) 
		oPrn:Say(nCol + 160,0010, "agressõesde partes elétricas e eletrônicas ocasionadas por limpeza com jato de água, detergente ou soluções causticas;",oFont6,100) 
		oPrn:Say(nCol + 200,0010, "queima fortuita decomponentes elétricos ou eletrônicos por variação de tensão; inversão de fase em equipamentos;",oFont6,100)
		oPrn:Say(nCol + 240,0010, "desregulagem por imperícia do usuário.",oFont6,100)
		 
		oPrn:Say(nCol + 320,0010, "A garantia será invalidada quando a instalação ou eventuais serviços nos equipamentos forem efetuados por profissionais não",oFont6,100)
		oPrn:Say(nCol + 360,0010, "autorizados pela Cozilandia, ou quando houver acidente no transporte não realizado pela nossa empresa.",oFont6,100)
		
		oPrn:Say(nCol + 440,0010, "Caso os equipamentos venham a apresentar alguma anomalia durante o período de garantia, as despesas de locomoção dos nossos",oFont6,100) 
		oPrn:Say(nCol + 480,0010, "técnicos correrão por conta da contratante.",oFont6,100)
		
		oPrn:Say(nCol + 560,0010, "A garantia para equipamentos não fabricados pela Cozilandia (revendas) correrá sob responsabilidade do respectivo fabricante.",oFont6,100)	
		
		oPrn:Say(nCol + 640,0010, "VALIDADE DA PROPOSTA..................:",oFont8,100)
		oPrn:Say(nCol + 680,0010, "20 dias, ficando posteriormente sujeita a nossa aprovação.",oFont6,100)
		
		oPrn:Say(nCol + 960,0010, "Permanecemos a inteira disposição de V.sas. para quaisquer outros eventuais esclarecimentos necessários pertinentes ao assunto.",oFont8,100)
	
	EndIf //If da assistencia	

EndIf
	
oPrn:Say(2400,0010, cRod1                          ,oFont3,100)
oPrn:Say(2440,0010, cRod2                          ,oFont3,100)
oPrn:Say(2480,0010, cRod3 + cRod4                  ,oFont3,100)


oPrn:EndPage()

Return


