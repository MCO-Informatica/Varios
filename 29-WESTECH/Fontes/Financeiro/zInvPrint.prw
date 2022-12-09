#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"

User Function zInvPrint()

Local oDlg       := NIL
Local cString	  := "ZZC"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zInvPrint"
Private nomeProg 	:= FunName()
Private cInvoice 	:= ZZC->ZZC_INVOIC

/*
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif
*/

wnrel := FunName()            //Nome Default do relatorio em Disco

Private cTitulo  := "Impress�o Commercial Invoice"
Private oPrn     := NIL
Private oFont1   := NIL
Private oFont2   := NIL
Private oFont3   := NIL
Private oFont4   := NIL
Private oFont5   := NIL
Private oFont6   := NIL
Private nLastKey := 0
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais

DEFINE FONT oFont1 NAME "Arial" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Arial" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Arial" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Arial" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont11n  	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont18n  	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont6		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27

	Return( NIL )

Endif


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetPortrait()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

Imprimir()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
/*
@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o impresso customizado:"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Relat�rio de Despesas de Viagem"			OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
*/
oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function Imprimir()

Invoice()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function Invoice()
	Local cTipoMoed
	Local cCodPais
	Local cCodPais2
	Local cPedido
	Local cTipo := ""

	local nXi
	Private nTotal := 0

	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	Private cIdConf
	Private	cAssConf


	cFileLogo := "lgrl" + cEmpAnt + ".bmp"
	/*
	cAssConf := cIDCONF + ".bmp"
	cAssAprov := cIDAPROV + ".bmp"
	*/
	oPrn:StartPage()

	nCont	:= 0

	//**********
	If Cont > Cont1
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1

  	If lCrtPag
		nCont := nCont + 1
	Endif



	ZZC->( dbSetOrder(1) )
	ZZC->( dbSeek( xFilial("ZZC")+cInvoice ) )




While ! ZZC->( Eof() ) .AND. ZZC->ZZC_INVOIC == cInvoice


	/*
	cAssConf 	:= Alltrim(SZ2->Z2_IDCONF) + ".bmp"
	cAssAprov 	:= Alltrim(SZ2->Z2_IDAPROV) + ".bmp"
	*/

	//oPrn:Say(0040,1890, SZ2->Z2_CODRDV,oFont14)

	ZZD->( dbSetOrder(1) )
	ZZD->( dbSeek(xFilial("ZZD")+cInvoice) )

	nLinha    := 0880
	While ! ZZD->(Eof() ) .And. ZZD->ZZD_INVOIC == cInvoice

		if nLinha > 2300 .OR. nLinha == 0
			if nLinha <> 0
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif

				nLinha  := 0880
				oPrn:EndPage()
			endif
		End if

		oPrn:Box	(0050,0050,0200,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  	( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n)

		if ZZC->ZZC_TIPO = "2"
			oPrn:Box	(0050,0740,0200,1500) // Titulo Pedido
			oPrn:Say  (0100,0820,"COMMERCIAL INVOICE  "  ,oFont14n)
		else
			oPrn:Box	(0050,0740,0200,1500) // Titulo Pedido
			oPrn:Say  (0100,0820,"PROFORMA INVOICE " ,oFont14n)
		endif

		oPrn:Box	(0050,1500,0200,1900) // Data Registro
		oPrn:Say  (0070,1540,"Date of issue " ,oFont9n)
		oPrn:Say  (0100,1540,DTOC(ZZC->ZZC_DTEMIS) ,oFont18n)

		// Dados da Invoice
		oPrn:Box	(0050,1900,0200,2300) //
		oPrn:Say  (0070,1940,"Document No. " ,oFont9n)
		oPrn:Say  (0100,1940, ZZC->ZZC_INVOIC,oFont18n)

		oPrn:Box	(0210,0050,0430,1150) //
		oPrn:Say  (0240,0070, "Emitter: " + ZZC->ZZC_NOMEMI  ,oFont8n)
		oPrn:Say  (0280,0070,"Project Manager: " + ZZC->ZZC_NOMCOO ,oFont8n)
		oPrn:Say  (0320,0070,"Requested by: " ,oFont8n)

		nLinha3 := 0280
		nLinhas3 := MLCount(alltrim(ZZC->ZZC_REQUES),55)
		For nXi:= 1 To nLinhas3
		        cTxtLinha3 := MemoLine(alltrim(ZZC->ZZC_REQUES),55,nXi)
		        If ! Empty(cTxtLinha3)
		              oPrn:Say(nLinha3+=40,0265,(cTxtLinha3),oFont8)
		        EndIf
		Next nXi

		oPrn:Box	(0210,1150,430,2300) //
		oPrn:Say  (0240,1170,"Job No/Acct No.: " + ZZC->ZZC_ITEMIC ,oFont8n)
		oPrn:Say  (0280,1170,"Name:  "  + ZZC->ZZC_NONCLI ,oFont8n)
		oPrn:Say  (0320,1170,"Contact: " + ZZC->ZZC_CONTEN ,oFont8)

		oPrn:Box	(0430,0050,0820,1150) //
		oPrn:Say  (0460,0070,"Shipping "  ,oFont8n)
		oPrn:Say  (0510,0070,"From: "  ,oFont8n)

		


		cCodPais2 := ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_PAIS"))

		oPrn:Say  (0460,0220, ZZC->ZZC_EMPORI  ,oFont8)
		oPrn:Say  (0510,0220, ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_END")) + ", " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_BAIRRO")),oFont8)
		oPrn:Say  (0560,0220,"CP: " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_CEP")) + " - "  + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_MUN")) + " - " + ALLTRIM(Posicione("SYA",1,xFilial("SYA") + cCodPais2,"YA_DESCR")),oFont8)
		oPrn:Say  (0610,0220,"CNPJ: " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_CGC")) ,oFont8)
		oPrn:Say  (0680,0070,"Ph/Fax: "  ,oFont8n)
		oPrn:Say  (0680,0230,"+" + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_DDI")) + " " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_DDD")) + " " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMPO,"A2_TEL")),oFont8n)
		oPrn:Say  (0720,0070,"E-mail: "  ,oFont8n)
		oPrn:Say   (0720,0230, ZZC->ZZC_EMAILE  ,oFont8n)


		oPrn:Box	(0430,1150,0820,2300) //
		oPrn:Say  (0460,1170,"Shipping "  ,oFont8n)
		oPrn:Say  (0510,1170,"To: " ,oFont8n)

		cPedido := alltrim(ZZC->ZZC_PEDIDO)
		if empty(cPedido)

			cCodPais := ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_PAIS"))

			oPrn:Say  (0460,1320, ZZC->ZZC_EMPENV ,oFont8)
			oPrn:Say  (0510,1320, ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_END")) + ", " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_BAIRRO")) ,oFont8)
			oPrn:Say  (0560,1320,"CP: " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_CEP")) + " - "  + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_MUN")) + " - " + ALLTRIM(Posicione("SYA",1,xFilial("SYA") + cCodPais,"YA_DESCR")) ,oFont8)
			oPrn:Say  (0610,1320,""  ,oFont8)
			oPrn:Say  (0680,1170,"Ph/Fax: "  ,oFont8n)
			oPrn:Say  (0680,1320, "+" + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDI")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDD")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_TEL")) ,oFont8n)
			oPrn:Say  (0720,1170,"E-mail: "  ,oFont8n)
			oPrn:Say  (0720,1320, ZZC->ZZC_EMAILV  ,oFont8n)
		
		else
			
			dbSelectArea("SC5")
			SC5->( dbSetOrder(1) )
			If SC5->( dbSeek( xFilial("SC5")+cPedido) )
				cTipo  := ALLTRIM(SC5->C5_TIPO)
			END IF

			IF cTipo == "B"

				cCodPais := ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_PAIS"))

				oPrn:Say  (0460,1320, ZZC->ZZC_EMPENV ,oFont8)
				oPrn:Say  (0510,1320, ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_END")) + ", " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_BAIRRO")) ,oFont8)
				oPrn:Say  (0560,1320,"CP: " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_CEP")) + " - "  + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_MUN")) + " - " + ALLTRIM(Posicione("SYA",1,xFilial("SYA") + cCodPais,"YA_DESCR")) ,oFont8)
				oPrn:Say  (0610,1320,""  ,oFont8)
				oPrn:Say  (0680,1170,"Ph/Fax: "  ,oFont8n)
				oPrn:Say  (0680,1320, "+" + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_DDI")) + " " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_DDD")) + " " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_TEL")) ,oFont8n)
				oPrn:Say  (0720,1170,"E-mail: "  ,oFont8n)
				oPrn:Say  (0720,1320, ZZC->ZZC_EMAILV  ,oFont8n)
			else

				cCodPais := ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_PAIS"))

				oPrn:Say  (0460,1320, ZZC->ZZC_EMPENV ,oFont8)
				oPrn:Say  (0510,1320, ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_END")) + ", " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_BAIRRO")) ,oFont8)
				oPrn:Say  (0560,1320,"CP: " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_CEP")) + " - "  + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_MUN")) + " - " + ALLTRIM(Posicione("SYA",1,xFilial("SYA") + cCodPais,"YA_DESCR")) ,oFont8)
				oPrn:Say  (0610,1320,""  ,oFont8)
				oPrn:Say  (0680,1170,"Ph/Fax: "  ,oFont8n)
				oPrn:Say  (0680,1320, "+" + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDI")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDD")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_TEL")) ,oFont8n)
				oPrn:Say  (0720,1170,"E-mail: "  ,oFont8n)
				oPrn:Say  (0720,1320, ZZC->ZZC_EMAILV  ,oFont8n)
			ENDIF
		endif

		oPrn:FillRect({0820,0050,0900,2300},oBrush)
		oPrn:Box  (0820,0050,3300,2300)

		oPrn:Box  (0820,0050,2540,1100) // descricao
		oPrn:Say  (0845,0550,"Description"  ,oFont8n)

		oPrn:Box	(0820,1100,2540,1300) // ncm
		oPrn:Say  (0830,1110,"Classification"  ,oFont6n)
		oPrn:Say  (0860,1150,"Code "  ,oFont6n)

		oPrn:Box	(0820,1300,2540,1430) // pais
		oPrn:Say  (0830,1310,"Country "  ,oFont6n)
		oPrn:Say  (0860,1330,"Origin "  ,oFont6n)

		oPrn:Box	(0820,1430,2540,1650) // quantidade
		oPrn:Say  (0845,1490,"Qty"  ,oFont8n)

		oPrn:Box	(0820,1650,2540,1750) // unidade
		oPrn:Say  (0845,1670,"Units"  ,oFont8n)

		oPrn:Box	(0820,1750,2540,2025) // vlr unitario
		oPrn:Say  (0845,1850,"Unit Price"  ,oFont8n)

		oPrn:Box	(0820,2025,2540,2300) // total
		oPrn:Say  (0845,2105,"Total Price"  ,oFont8n)

		oPrn:Box	(2550,0050,2800,1750)
		oPrn:Say(2560,0070, "Note: " , oFont8)
		nLinha2 := 2560
		nLinhas2 := MLCount(alltrim(ZZC->ZZC_NOTAS),70)
		For nXi:= 1 To nLinhas2
		        cTxtLinha2 := MemoLine(alltrim(ZZC->ZZC_NOTAS),120,nXi)
		        If ! Empty(cTxtLinha2)
		              oPrn:Say(nLinha2+=40,0070,(cTxtLinha2),oFont9)
		        EndIf
		Next nXi

		// ********************** Rodap� ****************


		if ZZC->ZZC_MOEDIN = "2"
			cTipoMoed = "USD"
		elseif ZZC->ZZC_MOEDIN = "4"
			cTipoMoed = "EUR"
		else
			cTipoMoed = ""
		endif

		oPrn:Box	(2730,0050,2800,1750)
		oPrn:Say(2750,0070, "Incoterm: " + alltrim(ZZC->ZZC_INCOT) , oFont9)

		oPrn:Box	(2800,0050,2870,2300)
		oPrn:Box	(2800,0050,2870,0820)
		oPrn:Say(2820,0070, "Total Net Weight (kg): " + Alltrim(transform(ZZC->ZZC_PESO,"@E 9,999,999.99")) , oFont9)

		oPrn:Box	(2800,0820,2870,1690)
		oPrn:Say(2820,0840, "Total Gross Weight (kg): " + Alltrim(transform(ZZC->ZZC_PBRUTO,"@E 9,999,999.99")) , oFont9)
		oPrn:Say(2820,1710, "Quantity of Bulks: " + Alltrim(transform( ZZC->ZZC_NITENS,"@E 9,999,999")) , oFont9)

		oPrn:Box	(2870,0050,3050,2300)
		
		if ZZC->ZZC_BANCO = "1"
		
			oPrn:Say(2880,0070, "Bank Name: ", oFont8n)
			oPrn:Say(2880,0300, "Clearing Code: ABA 026002561", oFont9n)
			oPrn:Say(2930,0300, "Beneficiary Bank: Banco Santader (Brasil) S.A.", oFont9n)
			oPrn:Say(2980,0300, "Swift (BIC CODE): BSCHBRSP", oFont9n)
	
			oPrn:Say(2880,1100, "Agency: 0250 - Account: 13002857-1", oFont9n)
			oPrn:Say(2930,1100, "Beneficiary Name: Westech Equipamentos Industriais Ltda.", oFont9n)
			oPrn:Say(2980,1100, "IBAN: BR93 9040 0888 0025 0013 0028 571C 1", oFont9n)
		else
			oPrn:Say(2880,0070, "Bank Name: ", oFont8n)
			//oPrn:Say(2880,0300, "Clearing Code: ", oFont9n)
			oPrn:Say(2930,0300, "Beneficiary Bank: Itau Unibanco S.A.", oFont9n)
			oPrn:Say(2980,0300, "Swift (BIC CODE): ITAUBRSP", oFont9n)
	
			oPrn:Say(2880,1100, "Agency: 0061 - Account: 12460-8", oFont9n)
			oPrn:Say(2930,1100, "Beneficiary Name: Westech Equipamentos Industriais Ltda.", oFont9n)
			oPrn:Say(2980,1100, "IBAN: BR9360701190000610000124608C1", oFont9n)
		endif

		oPrn:FillRect({3060,0050,3300,1250},oBrush)
		oPrn:Box	(3060,0050,3300,1250)
		oPrn:Say(3080,0070, "Westech Equipamento Industriais LTDA", oFont8n)
		oPrn:Say(3130,0070, "Rua Marques de Paranagua, 360, Consolacao, CEP: 01303-050 - Sao Paulo - Brasil", oFont8n)
		oPrn:Say(3180,0070, "Ph/Fax: +55 (11) 3234-5400 / 3234-5423 ", oFont8n)
		oPrn:Say(3230,0070, "E-mail: westech@westech.com.br - CNPJ: 07.798.560/0001-82", oFont8n)

		oPrn:Box	(3060,1250,3300,2100)
		oPrn:Say(3070,1260, "Signature", oFont8n)

		cIdConf		:= Alltrim(ZZC->ZZC_IDEMIS)
		cAssConf	:= GetSrvProfString('Startpath','') + cIdConf + '.BMP'
		oPrn:SayBitmap(3120,1450,cAssConf,0580,0180)
		oPrn:Say(3110,1260, ZZC->ZZC_NOMEMI , oFont8n)

		oPrn:Box	(3060,2100,3300,2300) //
		oPrn:Say  (3180,2130,"Page " + Transform(StrZero(ncont,3),""),oFont8n) //+ " de " + Transform(StrZero(ncont1,3),"")

		//***********************************************

		//oPrn:Say(nLinha,0200, Substr(DTOS(SZ3->Z3_DATA),7,2) + "/" + Substr(DTOS(SZ3->Z3_DATA),5,2) + "/" + Substr(DTOS(SZ3->Z3_DATA),1,4), oFont8)
		/*
		nLin := 1320
		nLinhas := MLCount(SZ8->Z8_OBS,70)
		For nXi:= 1 To nLinhas
		        cTxtLinha := MemoLine(SZ8->Z8_OBS,170,nXi)
		        If ! Empty(cTxtLinha)
		              oPrn:Say(nLin+=40,0070,(cTxtLinha),oFont9)
		        EndIf
		Next nXi
		*/
		nLinhas := MLCount(alltrim(ZZD->ZZD_DESCRI) + " " + alltrim(ZZD->ZZD_OBS),70)
		For nXi:= 1 To nLinhas
		        cTxtLinha := MemoLine(alltrim(ZZD->ZZD_DESCRI) + " " + alltrim(ZZD->ZZD_OBS),70,nXi)
		        If ! Empty(cTxtLinha)
		              oPrn:Say(nLinha+=40,0070,(cTxtLinha),oFont9)
		        EndIf
		Next nXi
		nLinha += -40

		//oPrn:Say(nLinha,0070, ZZD->ZZD_DESCRI + " " + ZZD->ZZD_OBS, oFont8)
		oPrn:Say(nLinha+40,1110, ZZD->ZZD_NCM, oFont8)
		oPrn:Say(nLinha+40,1330, ZZD->ZZD_PAIS , oFont8)
		oPrn:Say(nLinha+40,1630,Alltrim(transform(ZZD->ZZD_QUANT,"@E 999,999.9999")),oFont8,20,,,1)
		oPrn:Say(nLinha+40,1670, ZZD->ZZD_UM, oFont8)
		oPrn:Say(nLinha+40,2005,Alltrim(transform(ZZD->ZZD_VLRUNI,"@E 999,999,999.99")),oFont8,20,,,1)
		oPrn:Say(nLinha+40,2280,Alltrim(transform(ZZD->ZZD_TOTAL,"@E 999,999,999.99")),oFont8,20,,,1)

		oPrn:Box	(2550,1750,2800,2300)
		oPrn:Say(2560,1860, "Grand Total: " + cTipoMoed , oFont14n)

		nLinha+=0050

		nTotal += ZZD->ZZD_TOTAL

		ZZD->(dbSkip())

		EndDo

		oPrn:Say(2670,2280,Alltrim(transform( nTotal ,"@E 999,999,999.99")),oFont18n,20,,,1)

ZZC->( dbSkip() )


EndDo

oPrn:EndPage()

Return( NIL )

Static Function cabec()

		Local cPedido
		Local cTipo := ""
		Local nXi

		oPrn:Box	(0050,0050,0200,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  	( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n)

		if ZZC->ZZC_TIPO = "2"
			oPrn:Box	(0050,0740,0200,1500) // Titulo Pedido
			oPrn:Say  (0100,0820,"COMMERCIAL INVOICE  "  ,oFont14n)
		else
			oPrn:Box	(0050,0740,0200,1500) // Titulo Pedido
			oPrn:Say  (0100,0820,"PROFORMA INVOICE " ,oFont14n)
		endif

		oPrn:Box	(0050,1500,0200,1900) // Data Registro
		oPrn:Say  (0070,1540,"Date of issue " ,oFont9n)
		oPrn:Say  (0100,1540,DTOC(ZZC->ZZC_DTEMIS) ,oFont18n)

		// Dados da Invoice
		oPrn:Box	(0050,1900,0200,2300) //
		oPrn:Say  (0070,1940,"Document No. " ,oFont9n)
		oPrn:Say  (0100,1940, ZZC->ZZC_INVOIC,oFont18n)

		oPrn:Box	(0210,0050,0380,1150) //
		oPrn:Say  (0240,0070,"Project Manager: " + ZZC->ZZC_NOMCOO ,oFont8n)
		oPrn:Say  (0280,0070,"Requested by: " ,oFont9n)

		nLinha3 := 0240
		nLinhas3 := MLCount(alltrim(ZZC->ZZC_REQUES),55)
		For nXi:= 1 To nLinhas3
		        cTxtLinha3 := MemoLine(alltrim(ZZC->ZZC_REQUES),55,nXi)
		        If ! Empty(cTxtLinha3)
		              oPrn:Say(nLinha3+=40,0265,(cTxtLinha3),oFont8)
		        EndIf
		Next nXi

		oPrn:Box	(0210,1150,0380,2300) //
		oPrn:Say  (0240,1170,"Job No/Acct No.: " + ZZC->ZZC_ITEMIC ,oFont8n)
		oPrn:Say  (0280,1170,"Name:  "  + ZZC->ZZC_NONCLI ,oFont8n)

		oPrn:Box	(0390,0050,0820,1150) //
		oPrn:Say  (0410,0070,"Shipping " ,oFont8n)
		oPrn:Say  (0460,0070,"From: " ,oFont8n)
		oPrn:Say  (0410,0220, ZZC->ZZC_NOMEMI  ,oFont8)
		oPrn:Say  (0460,0220,"Westech Equipamento Industriais LTDA"  ,oFont8)
		oPrn:Say  (0510,0220,"Rua Marques de Paranagua, 360, Consolacao"  ,oFont8)
		oPrn:Say  (0560,0220,"CEP: 01303-050 - Sao Paulo - Brasil"  ,oFont8)
		oPrn:Say  (0610,0230,"CNPJ: 07.798.560/0001-82" ,oFont8)
		oPrn:Say  (0680,0070,"Ph/Fax: "  ,oFont8n)
		oPrn:Say  (0680,0230,"+55 (11) 3234-5400 / 3234-5423 " ,oFont8n)
		oPrn:Say  (0720,0070,"E-mail: "  ,oFont8n)
		oPrn:Say   (0720,0230, ZZC->ZZC_EMAILE  ,oFont8n)

		oPrn:Box	(0390,1150,0820,2300) //
		oPrn:Say  (0410,1170,"Shipping "  ,oFont8n)
		oPrn:Say  (0460,1170,"To: "  ,oFont8n)



		cPedido := alltrim(ZZC->ZZC_PEDIDO)
		if empty(cPedido)

			cCodPais := ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_PAIS"))

			oPrn:Say  (0460,1320, ZZC->ZZC_EMPENV ,oFont8)
			oPrn:Say  (0510,1320, ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_END")) + ", " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_BAIRRO")) ,oFont8)
			oPrn:Say  (0560,1320,"CP: " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_CEP")) + " - "  + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_MUN")) + " - " + ALLTRIM(Posicione("SYA",1,xFilial("SYA") + cCodPais,"YA_DESCR")) ,oFont8)
			oPrn:Say  (0610,1320,""  ,oFont8)
			oPrn:Say  (0680,1170,"Ph/Fax: "  ,oFont8n)
			oPrn:Say  (0680,1320, "+" + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDI")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDD")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_TEL")) ,oFont8n)
			oPrn:Say  (0720,1170,"E-mail: "  ,oFont8n)
			oPrn:Say  (0720,1320, ZZC->ZZC_EMAILV  ,oFont8n)
		
		else
			
			dbSelectArea("SC5")
			SC5->( dbSetOrder(1) )
			If SC5->( dbSeek( xFilial("SC5")+cPedido) )
				cTipo  := ALLTRIM(SC5->C5_TIPO)
			END IF

			IF cTipo == "B"

				cCodPais := ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_PAIS"))

				oPrn:Say  (0460,1320, ZZC->ZZC_EMPENV ,oFont8)
				oPrn:Say  (0510,1320, ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_END")) + ", " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_BAIRRO")) ,oFont8)
				oPrn:Say  (0560,1320,"CP: " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_CEP")) + " - "  + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_MUN")) + " - " + ALLTRIM(Posicione("SYA",1,xFilial("SYA") + cCodPais,"YA_DESCR")) ,oFont8)
				oPrn:Say  (0610,1320,""  ,oFont8)
				oPrn:Say  (0680,1170,"Ph/Fax: "  ,oFont8n)
				oPrn:Say  (0680,1320, "+" + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_DDI")) + " " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_DDD")) + " " + ALLTRIM(Posicione("SA2",1,xFilial("SA2") + ZZC->ZZC_IDEMEV,"A2_TEL")) ,oFont8n)
				oPrn:Say  (0720,1170,"E-mail: "  ,oFont8n)
				oPrn:Say  (0720,1320, ZZC->ZZC_EMAILV  ,oFont8n)
			else

				cCodPais := ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_PAIS"))

				oPrn:Say  (0460,1320, ZZC->ZZC_EMPENV ,oFont8)
				oPrn:Say  (0510,1320, ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_END")) + ", " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_BAIRRO")) ,oFont8)
				oPrn:Say  (0560,1320,"CP: " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_CEP")) + " - "  + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_MUN")) + " - " + ALLTRIM(Posicione("SYA",1,xFilial("SYA") + cCodPais,"YA_DESCR")) ,oFont8)
				oPrn:Say  (0610,1320,""  ,oFont8)
				oPrn:Say  (0680,1170,"Ph/Fax: "  ,oFont8n)
				oPrn:Say  (0680,1320, "+" + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDI")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_DDD")) + " " + ALLTRIM(Posicione("SA1",1,xFilial("SA1") + ZZC->ZZC_IDEMEV,"A1_TEL")) ,oFont8n)
				oPrn:Say  (0720,1170,"E-mail: "  ,oFont8n)
				oPrn:Say  (0720,1320, ZZC->ZZC_EMAILV  ,oFont8n)
			ENDIF
		endif

		if ZZC->ZZC_MOEDIN = "2"
			cTipoMoed = "USD"
		elseif ZZC->ZZC_MOEDIN = 4
			cTipoMoed = "EUR"
		else
			cTipoMoed = ""
		endif

		oPrn:Box	(2810,0050,3050,2300)
		oPrn:Say(2830,0070, "Bank Name: ", oFont9n)
		oPrn:Say(2880,0070, "Clearing Code: ABA 026002561", oFont9n)
		oPrn:Say(2930,0070, "Beneficiary Bank: Banco Santader (Brasil) S.A.", oFont9n)
		oPrn:Say(2980,0070, "Swift (BIC CODE): BSCHBRSP", oFont9n)

		oPrn:Say(2880,1000, "Agency: 0250 - Account: 13002857-1", oFont9n)
		oPrn:Say(2930,1000, "Beneficiary Name: Westech Equipamentos Industriais Ltda.", oFont9n)
		oPrn:Say(2980,1000, "IBAN: BR93 9040 0888 0025 0013 0028 571C 1", oFont9n)

		oPrn:FillRect({3060,0050,3300,1250},oBrush)
		oPrn:Box	(3060,0050,3300,1250)
		oPrn:Say(3080,0070, "Westech Equipamento Industriais LTDA", oFont8n)
		oPrn:Say(3130,0070, "Rua Marques de Paranagua, 360, Consolacao, CEP: 01303-050 - Sao Paulo - Brasil", oFont8n)
		oPrn:Say(3180,0070, "Ph/Fax: +55 (11) 3234-5400 / 3234-5423 ", oFont8n)
		oPrn:Say(3230,0070, "E-mail: westech@westech.com.br - CNPJ: 07.798.560/0001-82", oFont8n)

		oPrn:Box	(3060,1250,3300,2100)
		oPrn:Say(3070,1260, "Signature", oFont8n)

		oPrn:Say(3110,1300, ZZC->ZZC_NOMEMI , oFont8n)

		oPrn:Box	(3060,2100,3300,2300) //
		oPrn:Say  (3180,2130,"Page " + Transform(StrZero(ncont,3),""),oFont9n) //+ " de " + Transform(StrZero(ncont1,3),"")



		oPrn:Box	(2610,1750,2800,2300)
		oPrn:Say(2620,1860, "Grand Total: " + cTipoMoed , oFont14n)

		oPrn:Say(2690,2280,Alltrim(transform( nTotal ,"@E 999,999,999.99")),oFont18n,20,,,1)

Return ( Nil )

Static Function AjustaSX1()

putSx1(cPerg, "01", "Numero RDV:"	  , "", "", "mv_ch1", "C", 10, 0, 0, "G", "", "SZ2", "", "", "mv_par01")


Return( NIL )
