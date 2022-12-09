#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"


&&==========================================================================================================================================================
&&Impressão de orçamento
User Function ImpOrcX()
	Private nLastKey        := 0
	Private cCliente        := ''
	Private cLoja           := ''
	Private nVlrTotal    := 0
	Private nVlrSol      := 0
	Private nTpag	       := 0
	Private nBasIPI      := 0
	Private nAlqIPI      := 0                        	
	Private nValIPI      := 0
	Private nBasICM      := 0
	Private nAlqICM      := 0
	Private nValICM      := 0
	Private ntotIpi 		:= 0
	Private ntotIcm 		:= 0
	Private ntotSol 		:= 0
	Private ntotFrt 		:= 0
	Private ntotGer 		:= 0
	Private QtdItem      := 0
	Private ntotMerc     := 0
	Private nPrcLista    := 0
	Private cNivel       := ''
	Private nValMerc     := 0
	Private nDescZF 	 := 0
	Private aRet 		 := {}
	Private nTotItem 	 := 0
	Private nDesconto    := 0
	Private nTotalBruto  := 0
	Private nVlrDZFM	 := 0

	cPerg:="TMKORC"
&&If Pergunte(cPerg,.T.)

&&==============================================
&&Validação para impressão
&&If SUA->UA_IMP=="N"
&&	Alert("Orçamento não liberado para impressao")
&&	Return(.F.)
&&EndIf

&&==============================================
&&Validação para impressão
	Iif (SUA->UA_1OPER<>'2',xTipo:="1",xTipo:="2")
&&2=orc
&&==============================================
&&Validação para impressão
	If SUA->UA_CANC=="S"
		Alert("Orçamento cancelado!")
		Return(.F.)
	EndIf

&&============================================================================================================================================================
&&Levantamento de dados
	cQuery := "SELECT * FROM " + RetSqlName("SUA") + " SUA "
	cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += "ON UA_CLIENTE=A1_COD "
	cQuery += "INNER JOIN " + RetSqlName("SA4") + " SA4 "
	cQuery += "ON (UA_TRANSP = A4_COD OR UA_REDESP = A4_COD) "
	cQuery += "INNER JOIN " + RetSqlName("SA3") + " SA3 "
	cQuery += "ON UA_VEND=A3_COD "
	cQuery += "WHERE UA_NUM = '"+SUA->UA_NUM+"' "
	cQuery += "AND UA_LOJA=A1_LOJA "
	cQuery += "AND SUA.D_E_L_E_T_=' ' "
	cQuery += "AND SA1.D_E_L_E_T_=' ' "
	cQuery += "AND SA4.D_E_L_E_T_=' ' "
	cQuery += "AND SA3.D_E_L_E_T_=' ' "
	cQuery := ChangeQuery(cQuery)
	MemoWrite("C:\temp\query.txt",cQuery)
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TBTMK', .F., .T.)},"Call Center")

	DbSelectArea("TBTMK")

&&==============================================
&&Variaveis
	xRefNum		:=TBTMK->UA_NUM
	xObsComl	:=Posicione("SUA",1,xFilial("SUA")+xRefNum,"UA_X_OBS")
	xVendNome	:=Alltrim(TBTMK->A3_NREDUZ)
&&	xVendTel	:=Alltrim(TBTMK->A3_DDDTEL)+" "+Alltrim(TBTMK->A3_TEL)
&&	xVendTel	:=TBTMK->A3_RAMAL
	xVendTel	:=TBTMK->A3_TEL
	xEVend		:=Alltrim(TBTMK->A3_EMAIL)
	xEst		:=Alltrim(TBTMK->A1_EST)
	xA1Trib		:=Alltrim(TBTMK->A1_GRPTRIB)
	xTpCli		:=Alltrim(TBTMK->A1_TIPO)
	xFrete		:=TBTMK->UA_FRETE
	xVarCGC		:=Substr(SM0->M0_CGC,1,2)+"."+Substr(SM0->M0_CGC,3,3)+"."+Substr(SM0->M0_CGC,6,3)+"/"+Substr(SM0->M0_CGC,9,4)+"-"+Substr(SM0->M0_CGC,13,2)
	xVarINSC	:=Substr(SM0->M0_INSC,1,3)+"."+Substr(SM0->M0_INSC,4,3)+"."+Substr(SM0->M0_INSC,7,3)+"."+Substr(SM0->M0_INSC,10,3)
&&==============================================
&&Especificas para TMSPRINTER
	Private oPrn      := TMSPrinter():New("Orçamento Shangri-lá") &&inicializador do objeto
	Private oFont1    := TFont():New( "Arial",,08  ,,.T.,,,,,.F. )
	Private oFont2    := TFont():New( "Arial",,10  ,,.T.,,,,,.F. )
	Private oFont3    := TFont():New( "Arial",,12  ,,.T.,,,,,.F. )
	Private aRet      := {}

	xLin2:=0


	IF LastKey() == 286 && Tecla ESC
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Return
	Endif

	IF Empty(xRefNum)
		DbCloseArea("TBTMK")
		@Prow()+1,001 PSAY "NAO A DADOS"
		Return
	Endif

	oPrn:SetPaperSize(9)
	oPrn:Setup()
	oPrn:SetLandScape()

	oPrn:StartPage()

&&============================================================================================================================================================
&&Cabeçalho direita
	xLin1	:=0020
	xAuxLin1:=0040
	xCol1	:=0080
	xAuxCol1:=3280
	xText	:=0005
	xAuxCol2:=0020


	cBitMap:= "lgrl01" + ".Bmp"
	oPrn:SayBitmap( 0080,0110,cBitMap,0230,0240)  &&Logo da empresa

	oPrn:Say(xLin1+=xAuxLin1,xCol1+xAuxCol1,Alltrim(SM0->M0_NOMECOM)											,oFont1,100,,,1)
	oPrn:Say(xLin1+=xAuxLin1,xCol1+xAuxCol1,"CNPJ: "+xVarCGC+" - INSCR. ESTADUAL: "+xVarInsc					,oFont1,100,,,1)
	oPrn:Say(xLin1+=xAuxLin1,xCol1+xAuxCol1,Alltrim(SM0->M0_ENDENT)+" - "+Alltrim(SM0->M0_BAIRENT)+" - "+Alltrim(SM0->M0_CIDENT)+" - "+Alltrim(SM0->M0_ESTENT)+" - "+Substr(SM0->M0_CEPENT,1,5)+"-"+Substr(SM0->M0_CEPENT,6,3),oFont1,100,,,1)
	oPrn:Say(xLin1+=xAuxLin1,xCol1+xAuxCol1,"PABX ("+Substr(SM0->M0_TEL,4,2)+")"+Substr(SM0->M0_TEL,7,4)+"-"+Substr(SM0->M0_TEL,11,4)+" FAX ("+Substr(Alltrim(SM0->M0_FAX),4,2)+")"+Substr(Alltrim(SM0->M0_FAX),7,4)+"-"+Substr(Alltrim(SM0->M0_FAX),11,4),oFont1,100,,,1)

	oPrn:Say(xLin1+=xAuxLin1,xCol1+xAuxCol1,"site: www.gruposhangrila.com.br"									,oFont1,100,,,1)

	If xTipo=="2"
		oPrn:Say(xLin1+=xAuxLin1,1500,"ORÇAMENTO",oFont3,100,,,2)
	Else
		oPrn:Say(xLin1+=xAuxLin1,1500,"PEDIDO DE VENDAS",oFont3,100,,,2)
	EndIf


	xLin2+=xLin1+(xAuxLin1*4)
	xLin3:=xLin2 &&Grade direita
&&=========================================================
&&Grade esquerda!
&&1 Linha

	oPrn:Box(xLin2,0080,xLin2+xAuxLin1,0296)
	oPrn:Say(xLin2+xText,0080+xText,"Cliente",oFont1,100,,,0)

	oPrn:Box(xLin2,0296,xLin2+xAuxLin1,1214)
	oPrn:Say(xLin2+xText,0296+xText,Alltrim(TBTMK->UA_NOMCLI),oFont1,100,,,0)

	oPrn:Box(xLin2,1214,xLin2+xAuxLin1,1484)
	oPrn:Say(xLin2+xText,1214+xText,"Cód. Cliente",oFont1,100,,,0)

	oPrn:Box(xLin2,1484,xLin2+xAuxLin1,1754)
	oPrn:Say(xLin2+xText,1484+xText,TBTMK->UA_CLIENTE+TBTMK->UA_LOJA,oFont1,100,,,0)

	oPrn:Box(xLin2,1754,xLin2+xAuxLin1,2024)
	oPrn:Box(xLin2,2024,xLin2+xAuxLin1,2780)

&&2 Linha
	xLin2+=xAuxLin1

	oPrn:Box(xLin2,0080,xLin2+xAuxLin1,0296)
	oPrn:Say(xLin2+xText,0080+xText,"CNPJ",oFont1,100,,,0)

	oPrn:Box(xLin2,0296,xLin2+xAuxLin1,0674)
	oPrn:Say(xLin2+xText,0296+xText,TBTMK->A1_CGC,oFont1,100,,,0)

	oPrn:Box(xLin2,0674,xLin2+xAuxLin1,0944)
	oPrn:Say(xLin2+xText,0674+xText,"Insc. Est. ",oFont1,100,,,0)

	oPrn:Box(xLin2,0944,xLin2+xAuxLin1,1214)
	oPrn:Say(xLin2+xText,0944+xText,TBTMK->A1_INSCR,oFont1,100,,,0)

	oPrn:Box(xLin2,1214,xLin2+xAuxLin1,1484)
	oPrn:Say(xLin2+xText,1214+xText,"Contato ",oFont1,100,,,0)

	oPrn:Box(xLin2,1484,xLin2+xAuxLin1,1754)
	oPrn:Say(xLin2+xText,1484+xText,Alltrim(TBTMK->UA_DESCNT),oFont1,100,,,0)

	oPrn:Box(xLin2,1754,xLin2+xAuxLin1,2024)
	oPrn:Say(xLin2+xText,1754+xText,"Local Cobrança ",oFont1,100,,,0)

	oPrn:Box(xLin2,2024,xLin2+xAuxLin1,2780)
	oPrn:Say(xLin2+xText,2024+xText,Alltrim(TBTMK->A1_ENDCOB),oFont1,100,,,0)

	xLin2+=xAuxLin1

	oPrn:Box(xLin2,0080,xLin2+xAuxLin1,0296)
	oPrn:Say(xLin2+xText,0085,"End.",oFont1,100,,,0)

	oPrn:Box(xLin2,0296,xLin2+xAuxLin1,1214)
	oPrn:Say(xLin2+xText,0296+xText,Alltrim(TBTMK->A1_END),oFont1,100,,,0)

	oPrn:Box(xLin2,1214,xLin2+xAuxLin1,1484)
	oPrn:Say(xLin2+xText,1214,"Telefone",oFont1,100,,,0)

	oPrn:Box(xLin2,1484,xLin2+xAuxLin1,1754)
	oPrn:Say(xLin2+xText,1484+xText,Alltrim(TBTMK->A1_DDD)+" "+Alltrim(TBTMK->A1_TEL),oFont1,100,,,0)

	oPrn:Box(xLin2,1754,xLin2+xAuxLin1,2780)
	xLin2+=xAuxLin1

	oPrn:Box(xLin2,0080,xLin2+xAuxLin1,0296)
	oPrn:Say(xLin2+xText,0085,"Bairro",oFont1,100,,,0)

	oPrn:Box(xLin2,0296,xLin2+xAuxLin1,0944)
	oPrn:Say(xLin2+xText,0296+xText,Alltrim(TBTMK->A1_BAIRRO),oFont1,100,,,0)

	oPrn:Box(xLin2,0944,xLin2+xAuxLin1,1050)
	oPrn:Say(xLin2+xText,0944,"Cep",oFont1,100,,,0)

	oPrn:Box(xLin2,1050,xLin2+xAuxLin1,1214)
	oPrn:Say(xLin2+xText,1050+xText,Substr(TBTMK->A1_CEP,1,5)+"-"+Substr(TBTMK->A1_CEP,6,3),oFont1,100,,,0)

	oPrn:Box(xLin2,1214,xLin2+xAuxLin1,1484)
	oPrn:Say(xLin2+xText,1214,"Fax",oFont1,100,,,0)

	oPrn:Box(xLin2,1484,xLin2+xAuxLin1,1754)
	oPrn:Say(xLin2+xText,1484+xText,Alltrim(TBTMK->A1_DDD)+Alltrim(TBTMK->A1_FAX),oFont1,100,,,0)

	oPrn:Box(xLin2,1754,xLin2+xAuxLin1,2024)
	oPrn:Say(xLin2+xText,1754,"Local Faturamento",oFont1,100,,,0)

	oPrn:Box(xLin2,2024,xLin2+xAuxLin1,2780)
	oPrn:Say(xLin2+xText,2024,"",oFont1,100,,,0)

	xLin2+=xAuxLin1

	oPrn:Box(xLin2,0080,xLin2+xAuxLin1,0296)
	oPrn:Say(xLin2+xText,0085,"Cidade",oFont1,100,,,0)

	oPrn:Box(xLin2,0296,xLin2+xAuxLin1,0674)
	oPrn:Say(xLin2+xText,0296+xText,Alltrim(TBTMK->A1_MUN),oFont1,100,,,0)

	oPrn:Box(xLin2,0674,xLin2+xAuxLin1,0944)
	oPrn:Say(xLin2+xText,0674,"Transportadora",oFont1,100,,,0)

	oPrn:Box(xLin2,0944,xLin2+xAuxLin1,1484)
	oPrn:Say(xLin2+xText,0944+xText,Alltrim(TBTMK->A4_NREDUZ),oFont1,100,,,0)

	oPrn:Box(xLin2,1484,xLin2+xAuxLin1,1754)
	oPrn:Say(xLin2+xText,1484,"Prazo Pagto",oFont1,100,,,0)

	oPrn:Box(xLin2,1754,xLin2+xAuxLin1,2024)
	oPrn:Say(xLin2+xText,1754+xText,Alltrim(TBTMK->UA_CONDPAG),oFont1,100,,,0)

	oPrn:Box(xLin2,2024,xLin2+xAuxLin1,2780)
	xLin2+=xAuxLin1

	oPrn:Box(xLin2,0080,xLin2+xAuxLin1,0296)
	oPrn:Say(xLin2+xText,0085,"Estado",oFont1,100,,,0)

	oPrn:Box(xLin2,0296,xLin2+xAuxLin1,0674)
	oPrn:Say(xLin2+xText,0296+xText,Alltrim(TBTMK->A1_EST),oFont1,100,,,0)

	oPrn:Box(xLin2,0674,xLin2+xAuxLin1,0944)
	oPrn:Say(xLin2+xText,0674,"Frete",oFont1,100,,,0)

	If TBTMK->UA_XTEMRED$"S"
		oPrn:Box(xLin2,0944,xLin2+xAuxLin1,1214)
		oPrn:Say(xLin2+xText,0944+xText,Iif(TBTMK->UA_TPREDES$"R","REMETENTE","DESTINATARIO"),oFont1,100,,,0)
	else
		oPrn:Box(xLin2,0944,xLin2+xAuxLin1,1214)
		oPrn:Say(xLin2+xText,0944+xText,Iif(TBTMK->UA_TPFRETE$"C","CIF","FOB"),oFont1,100,,,0)
	EndIf
	
	oPrn:Box(xLin2,1214,xLin2+xAuxLin1,1484)
	oPrn:Say(xLin2+xText,1214,"Cond. Negociada",oFont1,100,,,0)

	oPrn:Box(xLin2,1484,xLin2+xAuxLin1,1754)
	oPrn:Say(xLin2+xText,1484+xText,Alltrim(TBTMK->UA_X_CODRE),oFont1,100,,,0)

	oPrn:Box(xLin2,1754,xLin2+xAuxLin1,2390)

	oPrn:Box(xLin2,2390,xLin2+xAuxLin1,2780)
	oPrn:Say(xLin2+xText,2390+xText,Alltrim(TBTMK->UA_TABELA),oFont1,100,,,0)


&&============================================================================================================================================================
&&1 Grade direita

	xCol3:=2840
	xAuxLin3:=0080

	oPrn:Box(xLin3,xCol3,xLin3+xAuxLin3,xCol3+0500)
	oPrn:Say(xLin3+0020,xCol3+0020,"USO EXCLUSIVO INTERNO",oFont2,100,,,0)

	xLin3+=xAuxLin3
	oPrn:Box(xLin3,xCol3,xLin3+xAuxLin3,xCol3+0500)
	oPrn:Say(xLin3+0020,xCol3+0020,"Cod. Cliente "+TBTMK->A1_COD+TBTMK->A1_LOJA,oFont2,100,,,0)
&&oPrn:Say(xLin3+0060,xCol3+0020,TBTMK->A1_COD+TBTMK->A1_LOJA,oFont2,100,,,0)

	xLin3+=xAuxLin3
	oPrn:Box(xLin3,xCol3,xLin3+xAuxLin3,xCol3+0500)
	If xTipo=="2"
		oPrn:Say(xLin3+0020,xCol3+0020,"Nº Orçamento "+TBTMK->UA_NUM,oFont2,100,,,0)
	Else
		oPrn:Say(xLin3+0020,xCol3+0020,"Nº Ped Vendas "+TBTMK->UA_NUMSC5,oFont2,100,,,0)
	&&oPrn:Say(xLin3+0060,xCol3+0020,TBTMK->UA_NUM,oFont2,100,,,0)
	EndIf

	xLin3+=xAuxLin3
	oPrn:Box(xLin3,xCol3,xLin3+xAuxLin3,xCol3+0500)
	oPrn:Say(xLin3+0020,xCol3+0020,"Data "+DTOC((STOD(TBTMK->UA_EMISSAO))),oFont2,100,,,0)
&&oPrn:Say(xLin3+0060,xCol3+0020,DTOC((STOD(TBTMK->UA_EMISSAO))),oFont2,100,,,0)

&&============================================================================================================================================================
&&1 Linha solta
&&xLin1+=(xAuxLin1*2)
	xAuxLin4:=xAuxLin1
	xLin4:=xLin2+(xAuxLin4*2)
	xCol3:=0015

	oPrn:Box(xLin4,0080,xLin4+xAuxLin4,0296)
	oPrn:Say(xLin4+xText,0080+xCol3,"Data",oFont1,100,,,0)

	oPrn:Box(xLin4,0296,xLin4+xAuxLin4,0674)
	oPrn:Say(xLin4+xText,0296+xText,DTOC((STOD(TBTMK->UA_EMISSAO))),oFont1,100,,,0)

	oPrn:Box(xLin4,0674,xLin4+xAuxLin4,0944)
	oPrn:Say(xLin4+xText,0674+xCol3,"Vendedor",oFont1,100,,,0)

	oPrn:Box(xLin4,0944,xLin4+xAuxLin4,1214)
	oPrn:Say(xLin4+xText,0944+xText,xVendNome,oFont1,100,,,0)

	oPrn:Box(xLin4,1214,xLin4+xAuxLin4,1484)
	oPrn:Say(xLin4+xText,1214+xCol3,"Região",oFont1,100,,,0)

	oPrn:Box(xLin4,1484,xLin4+xAuxLin4,1754)
	oPrn:Say(xLin4+xText,1484+xText,"",oFont1,100,,,0)

	oPrn:Box(xLin4,1754,xLin4+xAuxLin4,2000)
	oPrn:Say(xLin4+xText,1754+xCol3,"Email",oFont1,100,,,0)

	oPrn:Box(xLin4,2000,xLin4+xAuxLin4,2780)
	oPrn:Say(xLin4+xText,2000+xText,Alltrim(TBTMK->A1_EMAIL),oFont1,100,,,0)


&&=========================================================
&&2 Grade

&&1 Linha
	xAuxLin4:=0040
	xLin4+=(xAuxLin4*3)

	oPrn:Box(xLin4,0080,xLin4+xAuxLin4,0280)&&1
	oPrn:Say(xLin4+xText,0080+xText,"Código",oFont1,100,,,0)
	oPrn:Box(xLin4,0280,xLin4+xAuxLin4,0481)&&2
	oPrn:Say(xLin4+xText,0280+xText,"Quant.",oFont1,100,,,0)
	oPrn:Box(xLin4,0481,xLin4+xAuxLin4,0681)&&3
	oPrn:Say(xLin4+xText,0481+xText,"Unid",oFont1,100,,,0)
	oPrn:Box(xLin4,0681,xLin4+xAuxLin4,1616)&&4
	oPrn:Say(xLin4+xText,0681+xText,"Produto.",oFont1,100,,,0)
	oPrn:Box(xLin4,1616,xLin4+xAuxLin4,1817)&&5
	oPrn:Say(xLin4+xText,1616+xText,"Unitário",oFont1,100,,,0)
	oPrn:Box(xLin4,1817,xLin4+xAuxLin4,2017)&&6
	oPrn:Say(xLin4+xText,1817+xText,"Valor Bruto",oFont1,100,,,0)
	oPrn:Box(xLin4,2017,xLin4+xAuxLin4,2218)&&7
	oPrn:Say(xLin4+xText,2017+xText,"Desconto",oFont1,100,,,0)
	oPrn:Box(xLin4,2218,xLin4+xAuxLin4,2418)&&8
	oPrn:Say(xLin4+xText,2218+xText,"R$ Liquido",oFont1,100,,,0)
	oPrn:Box(xLin4,2418,xLin4+xAuxLin4,2618)&&9
	oPrn:Say(xLin4+xText,2418+xText,"Total",oFont1,100,,,0)
	oPrn:Box(xLin4,2618,xLin4+xAuxLin4,2819)&&10
	oPrn:Say(xLin4+xText,2618+xText,"IPI",oFont1,100,,,0)
	oPrn:Box(xLin4,2819,xLin4+xAuxLin4,3003)&&11
	oPrn:Say(xLin4+xText,2819+xText,"Liq IPI",oFont1,100,,,0)
	oPrn:Box(xLin4,3003,xLin4+xAuxLin4,3170)&&12
	oPrn:Say(xLin4+xText,3003+xText,"ST",oFont1,100,,,0)
	oPrn:Box(xLin4,3170,xLin4+xAuxLin4,3340)&&13
	oPrn:Say(xLin4+xText,3170+xText,"Valor ST",oFont1,100,,,0)

	cCliente  := TBTMK->A1_COD
	cLoja     := TBTMK->A1_LOJA

	DbCloseArea("TBTMK")

&&=========================================================
&&Impressão dos itens

	DbSelectArea("SUB")
	DbSetOrder(1)
	DbSeek (xFilial("SUB")+xRefNum)

&&==========================================================
&&Variaveis
	yValB		:=0
	yValT		:=0
	yTotIPI 	:=0
	yTotST		:=0
	xCalc1		:=0
	xCalc2		:=0
	xCalc3		:=0
	xCalc4		:=0
	_nVlImp 	:= 0

	While !Eof() .And. SUB->UB_NUM==xRefNum
		aRet := CalcImp()
		xCalc1		:=0
		xCalc2		:=0
		xCalc3		:=0
		xCalc4		:=0
	&&==========================================================
	&&Variaveis
		xIPI		:=Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_IPI")
		xGrTrib		:=Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_GRTRIB")
	
		yValB		:=Round((SUB->UB_PRCTAB*SUB->UB_QUANT)+yValB,4)
		yValT		:=Round(SUB->UB_VLRITEM+yValT,2)
		yTotIPI 	:=Round((((xIPI*SUB->UB_VLRITEM)/100)+SUB->UB_VLRITEM)+yTotIPI,2)
	
	
	&&============================================================================================================================================================
	&&Rotina para trazer dados para calculo de ST
	
		_nAliqICMS 	:=0
	
		If xEst $ "SP,"
			_nAliqICMS := 18.00
		Elseif xEst $ "RJ,MG,RS,SC,PR,"
			_nAliqICMS := 12.00
		Elseif xEst $ "ES,MT,MS,GO,DF,BA,SE,AL,PE,PB,RN,CE,PI,MA,AM,AC,PA,TO,RR,RO,AP,"
			_nAliqICMS := 7.00
		Elseif xEst $ "EX,"
			_nAliqICMS := 0.00
		Endif
	
	/*	cQuery := "SELECT * FROM " + RetSqlName("SF7") + " SF7 "
	cQuery += "WHERE 	F7_GRPCLI  = '"+xA1Trib+"' " 	&&Cod exc cliente
	cQuery += "AND 		F7_GRTRIB  = '"+xGrTrib+"' " 	&&Cod exc produto
	cQuery += "AND 		(F7_EST     = '"+xEst+"' " 		&&Estado
	cQuery += "OR 		F7_EST     = '**' )"				&&Estado
	cQuery += "AND 		(F7_TIPOCLI = '"+xTpCli+"' " 	&&Tipo Cliente
	cQuery += "OR 		F7_TIPOCLI = '*' )"				&&Tipo Cliente
	cQuery += "AND SF7.D_E_L_E_T_=' ' "
	cQuery := ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TBSF7', .F., .T.)},"Call Center")
	
	&&==========================================================
	&&Variaveis
	IIf (TBSF7->F7_ALIQINT>0,xAliqInt:=TBSF7->F7_ALIQINT,xAliqInt:=GETMV("MV_ICMPAD"))
	
	DbSelectArea("TBSF7")
	If Alltrim(TBSF7->F7_GRTRIB)<>""
	xCalc1:=(SUB->UB_VLRITEM+((SUB->UB_VLRITEM*xIPI)/100)+xFrete)
	xCalc2:=xCalc1+((TBSF7->F7_MARGEM*xCalc1)/100) &&base de calculo
	xCalc3:=(((xCalc2*xAliqInt)/100)-((SUB->UB_VLRITEM*_nAliqICMS)/100))&&+SUB->UB_VLRITEM
	xCalc4:=((((xCalc2*xAliqInt)/100)-((SUB->UB_VLRITEM*_nAliqICMS)/100))*100)/SUB->UB_VLRITEM
	Else
	xCalc3:= Round(((xIPI*SUB->UB_VLRITEM)/100)+SUB->UB_VLRITEM,2)
	EndIf
	yTotST	:=Round(xCalc3+yTotST,4)
	DbCloseArea("TBSF7")
	*/
	&&==========================================================
	&&Continuidade de Impressão
	
	
		DbSelectArea("SUB")
	
		xLin4+=(xAuxLin4)
		oPrn:Box(xLin4,0080,xLin4+xAuxLin4,0280)&&1
		oPrn:Say(xLin4+xText,0080+xText,Alltrim(SUB->UB_PRODUTO),oFont1,100,,,0)
		oPrn:Box(xLin4,0280,xLin4+xAuxLin4,0481)&&2
		oPrn:Say(xLin4+xText,0280+xText,Transform(SUB->UB_QUANT,"@E 999,999,999.99"),oFont1,100,,,0)
		oPrn:Box(xLin4,0481,xLin4+xAuxLin4,0681)&&3
		oPrn:Say(xLin4+xText,0481+xText,SUB->UB_UM,oFont1,100,,,0)
		oPrn:Box(xLin4,0681,xLin4+xAuxLin4,1616)&&46
		oPrn:Say(xLin4+xText,0681+xText,Posicione("SB1",1,xFilial("SB1")+Alltrim(SUB->UB_PRODUTO),"B1_DESC"),oFont1,100,,,0)
		oPrn:Box(xLin4,1616,xLin4+xAuxLin4,1817)&&5
		&&oPrn:Say(xLin4+xText,1616+xText,Transform(If(SUB->UB_PRCTAB,"@E 999,999,999.9999"),oFont1,100,,,0)
		oPrn:Say(xLin4+xText,1616+xText,Transform(SUB->UB_PRCTAB,"@E 999,999,999.9999"),oFont1,100,,,0)
		oPrn:Box(xLin4,1817,xLin4+xAuxLin4,2017)&&6
		oPrn:Say(xLin4+xText,1817+xText,Transform(Round((SUB->UB_PRCTAB*SUB->UB_QUANT),2),"@E 999,999,999.99"),oFont1,100,,,0)
		oPrn:Box(xLin4,2017,xLin4+xAuxLin4,2218)&&7
		oPrn:Say(xLin4+xText,2017+xText,Transform(SUB->UB_DESC,"@E 99.99"),oFont1,100,,,0)
		oPrn:Box(xLin4,2218,xLin4+xAuxLin4,2418)&&8
		oPrn:Say(xLin4+xText,2218+xText,Transform(SUB->UB_VRUNIT,"@E 999,999,999.9999"),oFont1,100,,,0)
		oPrn:Box(xLin4,2418,xLin4+xAuxLin4,2618)&&9
		oPrn:Say(xLin4+xText,2418+xText,Transform(SUB->UB_VLRITEM,"@E 999,999,999.99"),oFont1,100,,,0)
		oPrn:Box(xLin4,2618,xLin4+xAuxLin4,2819)&&10
		oPrn:Say(xLin4+xText,2618+xText,Transform(aRet[2],"@E 99.99"),oFont1,100,,,0)
		oPrn:Box(xLin4,2819,xLin4+xAuxLin4,3003)&&11
		If SUB->UB_TES = '507'
			oPrn:Say(xLin4+xText,2819+xText,Transform(Round(aRet[17] + aRet[3] - (SUB->UB_VLRITEM*.1625) ,2),"@E 999,999,999.99"),oFont1,100,,,0)
		Elseif SUB->UB_TES = '559'
			oPrn:Say(xLin4+xText,2819+xText,Transform(Round(aRet[17] + aRet[3] - (SUB->UB_VLRITEM*.07) ,2),"@E 999,999,999.99"),oFont1,100,,,0)
		Else
			oPrn:Say(xLin4+xText,2819+xText,Transform(Round(aRet[17] + aRet[3] - aRet[22] ,2),"@E 999,999,999.99"),oFont1,100,,,0)
		Endif 
		 
		_nVlImp += aRet[22]
		//oPrn:Say(xLin4+xText,2819+xText,Transform(Round(aRet[19],2),"@E 999,999,999.99"),oFont1,100,,,0)
		oPrn:Box(xLin4,3003,xLin4+xAuxLin4,3170)&&12
		oPrn:Say(xLin4+xText,3003+xText,Transform(aRet[10],"@E 99.99"),oFont1,100,,,0)
		oPrn:Box(xLin4,3170,xLin4+xAuxLin4,3340)&&13
		oPrn:Say(xLin4+xText,3170+xText,Transform(aRet[9],"@E 999,999,999.99"),oFont1,100,,,0)
	
		nTotalBruto += Round((SUB->UB_PRCTAB*SUB->UB_QUANT),2)
	
		DbSkip()
	
		If xLin4 > 2100
			xLin4:= 001
			oPrn:EndPage()
			oPrn:StartPage()
		EndIf
	EndDo()

	xLin4+=(xAuxLin4)
	oPrn:Box(xLin4,0080,xLin4+xAuxLin4,0280)&&1
	oPrn:Say(xLin4+xText,0080+xText,"TOTAL",oFont1,100,,,0)
	oPrn:Box(xLin4,0280,xLin4+xAuxLin4,0481)&&2
	oPrn:Box(xLin4,0481,xLin4+xAuxLin4,0681)&&3
	oPrn:Box(xLin4,0681,xLin4+xAuxLin4,1616)&&4
	oPrn:Box(xLin4,1616,xLin4+xAuxLin4,1817)&&5
	oPrn:Box(xLin4,1817,xLin4+xAuxLin4,2017)&&6
	oPrn:Say(xLin4+xText,1817+xText,Transform(Round(nTotalBruto,2),"@E 999,999,999.99"),oFont1,100,,,0)
	oPrn:Box(xLin4,2017,xLin4+xAuxLin4,2218)&&7
	oPrn:Box(xLin4,2218,xLin4+xAuxLin4,2418)&&8
	oPrn:Box(xLin4,2418,xLin4+xAuxLin4,2618)&&9
	oPrn:Say(xLin4+xText,2418+xText,Transform(Round(aRet[18],2),"@E 999,999,999.99"),oFont1,100,,,0)
	oPrn:Box(xLin4,2618,xLin4+xAuxLin4,2819)&&10
	oPrn:Box(xLin4,2819,xLin4+xAuxLin4,3003)&&11
	oPrn:Say(xLin4+xText,2819+xText,Transform(Round(aRet[18]+aret[11]-aRet[22],2),"@E 999,999,999.99"),oFont1,100,,,0)
	//oPrn:Say(xLin4+xText,2819+xText,Transform(Round(aRet[19],2),"@E 999,999,999.99"),oFont1,100,,,0)
	oPrn:Box(xLin4,3003,xLin4+xAuxLin4,3170)&&12
	oPrn:Box(xLin4,3170,xLin4+xAuxLin4,3340)&&13
	//oPrn:Say(xLin4+xText,3170+xText,Transform(Round(aRet[13],2),"@E 999,999,999.99"),oFont1,100,,,0) //Modificado a forma de imprimir o Total de IPI + ST, sem declarar o valor isolado da ST.
	oPrn:Say(xLin4+xText,3170+xText,Transform(Round(aRet[18]+aret[11]-aRet[22]+aRet[13],2),"@E 999,999,999.99"),oFont1,100,,,0)

	xLin4+=(xAuxLin4)
	oPrn:Box(xLin4,0080,xLin4+(xAuxLin4*3),3340)&&12
	oPrn:Say(xLin4+xText,3300+xText,"valor final aproximado com os impostos",oFont1,100,,,1)

	xLin4+=(xAuxLin4*3)
	oPrn:Box(xLin4,0080,xLin4+(xAuxLin4*6),3340)&&12
	oPrn:Say(xLin4+xText,0080+xText,"Observações:",oFont1,100,,,0)

	nTamObs := 200

	For J := 1 To MlCount(xObsComl,nTamObs)
		cTexto := Alltrim(MemoLine(xObsComl,nTamObs,J))
		xLin4+=(xAuxLin4)
	&&oPrn:Box(xLin4,0080,xLin4+(xAuxLin4*3),3340)&&12
		oPrn:Say(xLin4+xText,0080+xText,cTexto,oFont1,100,,,0)
	Next


	xLin4+=(xAuxLin4*3)
	oPrn:Box(xLin4,0080,xLin4+(xAuxLin4*6),3340)&&12
	xLin4+=(xAuxLin4)
	oPrn:Say(xLin4,0500,xVendNome				,oFont1,100,,,2)
	xLin4+=(xAuxLin4)
	oPrn:Say(xLin4,0500,Alltrim(SM0->M0_NOMECOM),oFont1,100,,,2)
	xLin4+=(xAuxLin4)
	oPrn:Say(xLin4,0500,xEVend					,oFont1,100,,,2)
	oPrn:Say(xLin4,2700,"______________________",oFont3,100,,,1)
	xLin4+=(xAuxLin4)
&&oPrn:Say(xLin4,0500,"Fone: "+xVendTel		,oFont1,100,,,2)
&&	oPrn:Say(xLin4,0500,"Fone: "+"("+Substr(SM0->M0_TEL,4,2)+")"+Substr(SM0->M0_TEL,7,4)+"-"+Substr(xVendTel,5,4),oFont1,100,,,2)
	oPrn:Say(xLin4,0500,"Fone: "+"("+Substr(SM0->M0_TEL,4,2)+")"+Substr(xVendTel,1,4)+"-"+Substr(xVendTel,5,4),oFont1,100,,,2)
	oPrn:Say(xLin4,2700,"Assinatura do cliente"	,oFont3,100,,,1)


	DbCloseArea("SUB")

	oPrn:EndPage() && finaliza pagina
	oPrn:Preview()  && visualizar
&&EndIf

Return()

Static Function CalcImp()
	Local aArea           := GetArea()
	Local cTipoCli        := POSICIONE("SA1",1,xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA,"A1_TIPO")
	Local cTipoNF         := "N"
	Local nVlrTotItem     := SUB->UB_VLRITEM
	Local nQuant          := SUB->UB_QUANT
	Local nVlUnit         := SUB->UB_VRUNIT
	Local nPrcLista       := SUB->UB_PRCTAB
	Local nAliqSol        := 0
	Local nSolMarg		  := 0

&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
&&| Verifico o tipo da nota para efetuar o calculo                                          |
&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	MaFisSave()
	MaFisEnd()

	MaFisIni(SUA->UA_CLIENTE,;&& 1-Codigo Cliente/Fornecedor
	SUA->UA_LOJA,;		&& 2-Loja do Cliente/Fornecedor
	"C",;				&& 3-C:Cliente , F:Fornecedor
	"N",;				&& 4-Tipo da NF
	cTipoCli,;		&& 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"TMKA271")

&&Na argentina o calculo de impostos depende da serie.
	If cPaisLoc == 'ARG'
		MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
	Endif

	MaFisAdd(    SUB->UB_PRODUTO                    ,;           // 1-Codigo do Produto ( Obrigatorio )
	SUB->UB_TES                        ,;          // 2-Codigo do TES ( Opcional )
	SUB->UB_QUANT                    ,;          // 3-Quantidade ( Obrigatorio )
	nVlUnit                    ,;          // 4-Preco Unitario ( Obrigatorio )
	0			                     ,;           // 5-Valor do Desconto ( Opcional )
	""                                ,;          // 6-Numero da NF Original ( Devolucao/Benef )
	""                                ,;          // 7-Serie da NF Original ( Devolucao/Benef )
	""                                ,;          // 8-RecNo da NF Original no arq SD1/SD2
	0                                ,;          // 9-Valor do Frete do Item ( Opcional )
	0                                ,;          // 10-Valor da Despesa do item ( Opcional )
	0                                ,;        // 11-Valor do Seguro do item ( Opcional )
	0                                ,;          // 12-Valor do Frete Autonomo ( Opcional )
	(nVlUnit*SUB->UB_QUANT)    ,;          // 13-Valor da Mercadoria ( Obrigatorio )
	0                                ,;          // 14-Valor da Embalagem ( Opiconal )
	0                                ,;          // 15-RecNo do SB1
	0                                )           // 16-RecNo do SF4

	MaFisWrite(1)

	nBasIPI := MaFisRet(1,'IT_BASEIPI')
	nValIPI := MaFisRet(1,'IT_VALIPI')
	nAlqIPI := MaFisRet(1,'IT_ALIQIPI')
	nBasICM := MaFisRet(1,'IT_BASEICM')
	nValICM := MaFisRet(1,'IT_VALICM')
	nAlqICM := MaFisRet(1,'IT_ALIQICM')
	nBasSol := 0
	nVlrDZFM  := 0
	nAliqSol  := 0
	If  MaFisRet(1,'IT_MARGEM') > 0
		nBasSol := MaFisRet(1,'IT_VALMERC') + nValIPI + ((MaFisRet(1,'IT_VALMERC') + nValIPI  ) * MaFisRet(1,'IT_MARGEM'))/100 //MaFisRet(1,'IT_BASESOL')
		nAliqSol  := MaFisRet(1,'IT_ALIQSOL')
	EndIf
	If nBasSol > 0
		nValSol := ((nBasSol * nAliqSol ) /100) - ((nBasICM * nValICM )/100 ) //Round(((SUB->UB_VLRITEM  + (SUB->UB_VLRITEM *  MaFisRet(1,'IT_MARGEM')/100)) * nAliqSol)/100,4)- Round((SUB->UB_VLRITEM * nAlqICM)/100,4)
	Else
		nValSol := 0
	EndIF

	nValSol := MaFisRet(1,'IT_VALSOL')

	nTotMercIt:= nVlrTotItem
	nTotItem  += nTotMercIt

	nDesconto += (MaFisRet(1,'IT_VALMERC') * SUB->UB_DESC)/100

	ntotIpi  += nValIPI
	ntotIcm  += nValICM
	nDescZF := MaFisRet(,"NF_DESCZF")
	ntotSol  := MaFisRet(,"NF_VALSOL")
	ntotFrt  := MaFisRet(,"NF_FRETE")
	ntotDesp := MaFisRet(,"NF_DESPESA")
	ntotDesc := MaFisRet(,"NF_DESCONTO")
	ntotGer  := MaFisRet(,"NF_TOTAL")
	ntotMerc += MaFisRet(,"NF_VALMERC")

	If nBasSol > 0
		nSolMarg := (((Round((nBasSol*nAliqSol)/100,	4))-((SUB->UB_VLRITEM*nAlqICM)/100))*100)/SUB->UB_VLRITEM   // Zabotto 14/04/2015
	&&nSolMarg := Round((((SUB->UB_VLRITEM + nValSol) / SUB->UB_VLRITEM) - 1 ) * 100,4)
	EndIF

	nVlrSol += ntotSol

	nVlrTotal += ntotGer
	
	nVlrDZFM  += nDescZF
	
	//ALERT(nVlrDZFM)

	If nVlrDZFM > 0
		nVlrDZFM := Round(nVlrTotal * 0.1625,2)
	EndIf

	//ALERT(nVlrDZFM)

	MaFisEnd()

	RestArea( aArea )
Return ({nBasIPI,nAlqIPI,nValIPI,nBasICM,nValICM,nAlqICM,nBasSol,nAliqSol,nValSol,nSolMarg,ntotIpi,ntotIcm,nVlrSol,ntotFrt,ntotDesp,ntotDesc,nTotMercIt,nTotItem,nVlrTotal,ntotMerc,nDesconto,nVlrDZFM})



	MaFisIni(cCliEnt,;						// 1-Codigo Cliente/Fornecedor
		(cAliasSC5)->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
		If((cAliasSC5)->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
		(cAliasSC5)->C5_TIPO,;				// 4-Tipo da NF
		(cAliasSC5)->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
		aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
		,;						   			// 7-Tipo de complemento
		,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
		"SB1",;								// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MATA461")							// 10-Nome da rotina que esta utilizando a funcao
