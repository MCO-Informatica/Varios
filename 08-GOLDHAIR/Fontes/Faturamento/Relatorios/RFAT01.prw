#INCLUDE "AP5MAIL.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "FWPRINTSETUP.CH" 

#define DMPAPER_A4 9      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RFAT01    ³ Autor ³ GUILHERME GIULIANO    ³ Data ³31.07.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Pedido de Vendas  - TmsPrinter                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico GOLD HAIR                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFAT01( cNum )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL oDlg		 	:= NIL
LOCAL cString		:= "SC7"

Private titulo 		:= ""
Private nLastKey	:= 0
Private cPerg		:= "FATR01"
Private nomeProg	:= FunName()
Private nTotItens	:= 0                            
Private nTotal		:= 0
Private nSubTot		:= 0                      
Private nRecnoD1 	:= 0
Private nMVPerc  	:= 1
Private _cNum 		:= cNum                           
Private nOpca 		:= 0
Private cGet1		:= Space(100)
Private cGet2		:= Space(100)
Private cGet3		:= Space(100)
Private cGet4		:= Space(100)
Private cMsg 
Private oDlgx
Private oButton1
Private oButton2
Private oGet1
Private oGet2
Private oGet3
Private oGet4
Private oMsg
Private oObs
Private cObs 
Private oGroup1
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  		³
//³ _cNum				// Numero da PT                   	     	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo		:= "Impressão do Pedido de Vendas"
Private oPrn		:= NIL
Private oFont1		:= NIL
Private oFont2		:= NIL
Private oFont3		:= NIL
Private oFont4		:= NIL
Private oFont5		:= NIL
Private oFont6		:= NIL
Private nLastKey	:= 0
Private nLin		:= 1650 // Linha de inicio da impressao das clausulas contratuais
Private _nPag		:= 1 // Linha de inicio da impressao das clausulas contratuais
Private nContP		:= 0
Private nQtdP		:= 0   
Private cPathImg	:= ""
Private cArqImg		:= ""
Private lCancelou   := .F.

DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD	OF oPrn
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD	OF oPrn
DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 	 	OF oPrn
DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC	OF oPrn
DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 		OF oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont09N	:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11		:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14		:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16		:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont13N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont13N	:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
nMVPerc		:= 100/GETMV("MV_X_PERC") 

nWidthPage	:=700
nHeightPage	:=1000
nZoom		:=100
nQuality	:=75

dbselectarea("SA1")
dbsetorder(1)
dbseek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
cGet1 := PADR(UPPER(SA1->A1_EMAIL),100)
cGet3 := PADR("ATENDIMENTO@GOLDHAIRADVANCE.COM.BR",100)
cGet4 := PADR("EXPEDICAO@GOLDHAIRADVANCE.COM.BR",100)  

DBSELECTAREA("SC5")
SC5->(DBSEEK(xFilial("SC5")+_cNum))

Do While SC5->(!EOF()) .AND. SC5->C5_NUM == _cNum
	IF SC5->C5_NUM == _cNum
		cObs := IIF(Empty(SC5->C5__OBSPED ),"",SC5->C5__OBSPED )
		cMsg := IIF(Empty(SC5->C5__OBSEMA),"",SC5->C5__OBSEMA)
		SC5->(DBSKIP())
	ELSE
		SC5->(DBSKIP())
	ENDIF
	SC5->(DBSKIP())
ENDDO 

DEFINE MSDIALOG oDlgx TITLE "Impressão do Pedido" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL
@ 003, 006 GROUP oGroup1 TO 68, 193 PROMPT "Observação no Corpo do Pedido" OF oDlgx COLOR 0, 16777215 PIXEL
@ 013, 010 GET oObs VAR cObs MEMO 				SIZE 161, 040 OF oGroup1 COLORS 0, 16777215 PIXEL
@ 76, 083 BUTTON oButton1 PROMPT "Imprime" 		SIZE 037, 012 OF oDlgx ACTION (nOpca:=1,oDlgx:End()) PIXEL
@ 76, 136 BUTTON oButton2 PROMPT "Cancelar" 	SIZE 037, 012 OF oDlgx ACTION (nOpca:=0,oDlgx:End()) PIXEL

ACTIVATE MSDIALOG oDlgx CENTER

IF nOpca == 0
	Return
Endif

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+_cNum)
While !Eof() .And. C5_NUM == _cNum
	IF SC5->C5_NUM == _cNum
		RecLock("SC5",.f.)
		SC5->C5__OBSPED := cObs
		SC5->C5__OBSEMA := cMsg
	    SC5->(MSUNLOCK())
	    SC5->(DBSKIP())                       
	ELSE
		SC5->(DBSKIP())
	ENDIF
	SC5->(DBSKIP())
ENDDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela de Entrada de Dados - Parametros                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do lay-out / impressao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqName	:= "PV_" + AllTrim(_cNum)	// + "_" + DtoS(Date()) + "_" +  SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2)
cArqImg		:= "PV_" + AllTrim(_cNum)	//+".PDF"

cStartPath	:= GetSrvProfString("ROOTPATH" ,"")
cPathImg	:= cStartPath+ "Images\"

MakeDir(cPathImg)
MakeDir("C:\TEMP\IMAGES\")

//aFiles := Directory(cPathImg+cArqName+"*")
aFiles := Directory("C:\TEMP\IMAGES\"+cArqName+"*")
 	
For i:=1 to Len(aFiles)
//	fErase(cPathImg+aFiles[i][1])
	fErase("C:\TEMP\IMAGES\"+aFiles[i][1])
Next i

cFilePrintert	:= cArqImg 
nDevice			:= IMP_PDF  
nDevice			:= 6
lAdjustToLegacy	:= .T.
cPathInServer	:= cPathImg
lDisabeSetup	:= .T.                                               
lTReport		:= .F.
oPrintSetup		:= nil
cPrinter		:= nil
lServer			:= nil
lPDFAsPNG		:= .T.                                                                                                                                                                            
lRaw			:= nil
lViewPDF		:= .T.
nQtdCopy 		:= 1
 
oPrn := FWMsPrinter():New (cFilePrintert ,  nDevice,  lAdjustToLegacy,  /*cPathInServer*/,  lDisabeSetup) // ,  /*lTReport*/, /* @oPrintSetup*/, /*cPrinter*/,/*lServer*/, lPDFAsPNG, /*lRaw*/,  lViewPDF,  nQtdCopy )

oPrn:SetLandsCape() //SetPortrait() //SetLansCape()

oPrn:SetResolution(72)
oPrn:SetPaperSize(9)
oPrn:SetMargin(60,60,60,60)
oPrn:cPathPDF :=  "C:\TEMP\IMAGES\" //cPathInServer  
     
lCancelou := Orcamento()

If !lCancelou

	oPrn:Preview()

	If MsgYesNo("Envia pedido por e-mail?")
		
		DEFINE MSDIALOG oDlgx TITLE "Envio de e-Mail do Pedido" FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL
		
		@ 003, 006 GROUP oGroup1 TO 126, 193 PROMPT "Parametros" OF oDlgx COLOR 0, 16777215 PIXEL
		@ 013, 010 SAY oSay1 PROMPT "Email 1:" 				SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 026, 010 SAY oSay2 PROMPT "Email 2:" 				SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 039, 010 SAY oSay3 PROMPT "Email 3:" 				SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 052, 010 SAY oSay4 PROMPT "Email 4:" 				SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 065, 010 SAY oSay5 PROMPT "Mensagem do Email:" 	SIZE 066, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 011, 034 MSGET oGet1 VAR cGet1 					SIZE 133, 010 OF oGroup1 COLORS 0, 16777215 F3 "SA1001" PIXEL
		@ 024, 034 MSGET oGet2 VAR cGet2 					SIZE 133, 010 OF oGroup1 COLORS 0, 16777215 F3 "SA1001" PIXEL
		@ 037, 034 MSGET oGet3 VAR cGet3 					SIZE 133, 010 OF oGroup1 COLORS 0, 16777215 F3 "SA1001" PIXEL
		@ 050, 034 MSGET oGet4 VAR cGet4 					SIZE 133, 010 OF oGroup1 COLORS 0, 16777215 F3 "SA1001" PIXEL
		@ 076, 010 GET oMsg VAR cMsg MEMO 					SIZE 161, 040 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 130, 083 BUTTON oButton1 PROMPT "OK" 				SIZE 037, 012 OF oDlgx ACTION (nOpca:=1,oDlgx:End()) PIXEL
		@ 130, 136 BUTTON oButton2 PROMPT "Cancelar" 		SIZE 037, 012 OF oDlgx ACTION (nOpca:=0,oDlgx:End()) PIXEL
		
		ACTIVATE MSDIALOG oDlgx CENTER
		
		IF nOpca == 1
			MAILPV(cArqName,cPathImg)
		Endif
		
	EndIf

EndIf

//aFiles := Directory(cPathImg+cArqName+"*")
aFiles := Directory("C:\TEMP\IMAGES\"+cArqName+"*")
 	
For i:=1 to Len(aFiles)
//	fErase(cPathImg+aFiles[i][1])
	fErase("C:\TEMP\IMAGES\"+aFiles[i][1])
Next i

FreeObj(oPrn)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ORCAMENTO ³ Autor ³ GUILHERME GIULIANO    ³ Data ³31.07.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Pedido de Vendas  - TmsPrinter                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico GOLD HAIR                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION Orcamento()

lCanceled		:= .F.  
nQtsP			:= "0"
cDia			:= SubStr(DtoS(dDataBase),7,2)
cMes			:= SubStr(DtoS(dDataBase),5,2)
cAno			:= SubStr(DtoS(dDataBase),1,4)
cMesExt			:= MesExtenso(Month(dDataBase))
cDataImpressao	:= cDia+" de "+cMesExt+" de "+cAno
cPercICMS		:= GetMv("MV_ESTICM")

DA0->(dbSetOrder(1))
SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
SA4->(dbSetOrder(1))
SC6->(dbSetOrder(1))
SC9->(dbSetOrder(1))
SE4->(dbSetOrder(1))
SF4->(dbSetOrder(1))

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+_cNum)
While !Eof() .And. C5_NUM == _cNum .And. !lcanceled

	DA0->(dbSeek(xFilial("DA0")+SC5->C5_TABELA))
	SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND1))
	SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP))
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
	SC9->(dbSeek(xFilial("SC9")+SC9->C9_PEDIDO))
	SE4->(dbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
	SF4->(dbSeek(xFilial("SF4")+SC6->C6_TES))
	
	cEstICM		:= SA1->A1_EST
	nPosICM		:= AT(cPercICMS,cEstICM)
	nPercICMS	:= VAL(SubStr(cPercICMS,(nPosICM+2),2))
	
	oPrn:StartPage()
	CabecRel()
	nLin  := 650

	oPrn:Box(0600,0050,0980,1450)    
	oPrn:Box(0600,1450,0980,2850)    

	oPrn:Say(nLin,0280,"Emitente",oFont13N)
	oPrn:Say(nLin,0280+1400,"Destinatário",oFont13N)
	
	nLin += 60
	oPrn:Say(nLin,0100,"Empresa:",oFont12N)
	oPrn:Say(nLin,0280,OemToAnsi(SM0->M0_NOMECOM),oFont12)
	oPrn:Say(nLin,0100+1400,"Cliente:",oFont12N)
	oPrn:Say(nLin,0280+1400,OemToAnsi(SA1->A1_COD+" - "+SA1->A1_NOME),oFont12)
	
	nLin  += 50
	oPrn:Say(nLin,0100,"Endereco:",oFont12N)
	oPrn:Say(nLin,0280,OemToAnsi(PADR(SM0->M0_ENDCOB,60)),oFont12)
	oPrn:Say(nLin,0800,"Bairro:",oFont12N)
	oPrn:Say(nLin,0960,OemToAnsi("LGO DO SOCORRO"),oFont12)
	oPrn:Say(nLin,0100+1400,"Endereco:",oFont12N)
	oPrn:Say(nLin,0280+1400,OemToAnsi(substr(SA1->A1_END,1,35)),oFont12)
	oPrn:Say(nLin,0800+1400,"Bairro:",oFont12N)
	oPrn:Say(nLin,0960+1400,OemToAnsi(SA1->A1_BAIRRO),oFont12)

	nLin  += 50       
	ESTADO := SA1->A1_EST
	oPrn:Say(nLin,0100,"Cidade:",oFont12N)
	oPrn:Say(nLin,0280,OemToAnsi(alltrim(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB),oFont12)
	oPrn:Say(nLin,0100+1400,"Cidade:",oFont12N)
	oPrn:Say(nLin,0280+1400,OemToAnsi(alltrim(SA1->A1_MUN)+"/"+SA1->A1_EST),oFont12)
	oPrn:Say(nLin,0800,"CEP:",oFont12N)
	oPrn:Say(nLin,0900,OemToAnsi(Transform(SM0->M0_CEPCOB,"@R 99999-999")),oFont12)
	oPrn:Say(nLin,0800+1400,"CEP:",oFont12N)
	oPrn:Say(nLin,0900+1400,OemToAnsi(Transform(SA1->A1_CEP,"@R 99999-999")),oFont12)

	nLin  += 50
	oPrn:Say(nLin,0100,"C.G.C:",oFont12N)
	oPrn:Say(nLin,0280,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont12)
	oPrn:Say(nLin,0100+1400,"C.G.C:",oFont12N)
	oPrn:Say(nLin,0280+1400,Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99"),oFont12)
	oPrn:Say(nLin,0800,"Ins Estadual:",oFont12N)
	oPrn:Say(nLin,1040,Transform(Alltrim(SM0->M0_INSC),"@R 999.999.999.999"),oFont12)
	oPrn:Say(nLin,0800+1400,"Ins Estadual:",oFont12N)
	oPrn:Say(nLin,1040+1400,Transform(Alltrim(SA1->A1_INSCR),"@R 999.999.999.999"),oFont12)

	nLin  += 50
	oPrn:Say(nLin,0100,"Telefone:"	,oFont12N)
	oPrn:Say(nLin,0280,OemToAnsi(SM0->M0_TEL),oFont12)
	oPrn:Say(nLin,0100+1400,"Telefone:"	,oFont12N)
	oPrn:Say(nLin,0280+1400,OemToAnsi("("+SA1->A1_DDD+")-"+SA1->A1_TEL),oFont12)

	nLin  += 70

	oPrn:Box(1000,0050,1340,1450)
	oPrn:Box(1000,1450,1340,2850)
		
	nLin  += 50

	nLin  += 20
	oPrn:Say(nLin,0280,"Transporte/Venda",oFont13N)
	oPrn:Say(nLin,0280+1400,"Cond. Pagamento",oFont13N)

	nLin += 60
	oPrn:Say(nLin,0100,"Nome:",oFont12N)
	oPrn:Say(nLin,0280,OemToAnsi(SA4->A4_NOME),oFont12)
	oPrn:Say(nLin,0100+1400,"Cond Pagto:",oFont12N)
	oPrn:Say(nLin,0700+1400,"Forma Pagto:",oFont12N)
	oPrn:Say(nLin,0325+1400,OemToAnsi(SE4->E4_DESCRI),oFont12)
	do case
		case SC5->C5_X_FPAGT == "B"
			oPrn:Say(nLin,950+1400,"Boleto",oFont12)		
		case SC5->C5_X_FPAGT == "V"
			oPrn:Say(nLin,950+1400,"A Vista",oFont12)		
		case SC5->C5_X_FPAGT == "C"
			oPrn:Say(nLin,950+1400,"Cheque",oFont12)				
		case SC5->C5_X_FPAGT == "O"                             
			oPrn:Say(nLin,950+1400,"Bonificação",oFont12)		
	End case	
				
	IF SE4->E4_TIPO == "1"

		aPrazo := strtoarray(SE4->E4_COND,",")
		IF Len(aPrazo)>=1
           cprazo1 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[1])))
		ELSE
			cPrazo1 := ""
		ENDIF
	
		IF Len(aPrazo)>=2
           cprazo2 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[2])))
		ELSE
			cPrazo2 := ""
		ENDIF
	
		IF Len(aPrazo)>=3
           cprazo3 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[3])))
		ELSE
			cPrazo3 := ""
		ENDIF
	
		IF Len(aPrazo)>=4
           cprazo4 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[4])))
		ELSE
			cPrazo4 := ""
		ENDIF
	
		IF Len(aPrazo)>=5
           cprazo5 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[5])))
		ELSE
			cPrazo5 := ""
		ENDIF
		
		IF Len(aPrazo)>=6
           cprazo6 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[6])))
		ELSE
			cPrazo6 := ""
		ENDIF
		
		IF Len(aPrazo)>=7
           cprazo7 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[7])))
		ELSE
			cPrazo7 := ""
		ENDIF
	
		IF Len(aPrazo)>=8
           cprazo8 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[8])))
		ELSE
			cPrazo8 := ""
		ENDIF
		
		IF Len(aPrazo)>=9
           cprazo9 := dtoc(DataValida(SC5->C5_EMISSAO +VAL(aPrazo[9])))
		ELSE
			cPrazo9 := ""
		ENDIF
    
	ELSEIF SE4->E4_TIPO == "9"
		aPrazo   := {}                                      
		cPrazo1 := IF(!Empty(SC5->C5_DATA1),dtoc(SC5->C5_DATA1),"")
		cPrazo2 := IF(!Empty(SC5->C5_DATA2),dtoc(SC5->C5_DATA2),"")
		cPrazo3 := IF(!Empty(SC5->C5_DATA3),dtoc(SC5->C5_DATA3),"")
		cPrazo4 := IF(!Empty(SC5->C5_DATA4),dtoc(SC5->C5_DATA4),"")
		cPrazo5 := IF(!Empty(SC5->C5_DATA5),dtoc(SC5->C5_DATA5),"")
		cPrazo6 := ""
		cPrazo7 := ""
		cPrazo8 := ""
		cPrazo9 := ""
	ELSE
		aPrazo   := {}                                      
		cPrazo1 := ""
		cPrazo2 := ""
		cPrazo3 := ""
		cPrazo4 := ""
		cPrazo5 := ""
		cPrazo6 := ""
		cPrazo7 := ""
		cPrazo8 := ""
		cPrazo9 := ""
	ENDIF        
	
    IF SC5->C5_X_FPAGT = "B"
	   Do case 
		case len(aPrazo) <= 5 
			If Empty(SC5->C5_PDEST1) .and. Empty(SC5->C5_PDEST2) .and. Empty(SC5->C5_PDEST3) .and. Empty(SC5->C5_PDEST4) .and. Empty(SC5->C5_PDEST5)
				lCanceled := .T.
				MSGALERT("Favor preencher o campo destino da parcela 5", "Pedido de Vendas")
			End If
		case len(aPrazo) <= 4
			If Empty(SC5->C5_PDEST1) .and. Empty(SC5->C5_PDEST2) .and. Empty(SC5->C5_PDEST3) .and. Empty(SC5->C5_PDEST4)
				lCanceled := .T.
				MSGALERT("Favor preencher o campo destino da parcela 4", "Pedido de Vendas")
			End If
		case len(aPrazo) <= 3
			If Empty(SC5->C5_PDEST1) .and. Empty(SC5->C5_PDEST2) .and. Empty(SC5->C5_PDEST3) 
				lCanceled := .T.
				MSGALERT("Favor preencher o campo destino da parcela 3", "Pedido de Vendas")
			End If
		case len(aPrazo) <= 2
			If Empty(SC5->C5_PDEST1) .and. Empty(SC5->C5_PDEST2) 
				lCanceled := .T.
				MSGALERT("Favor preencher o campo destino da parcela 2", "Pedido de Vendas")
			End If
		case len(aPrazo) <= 1
			If Empty(SC5->C5_PDEST1) 
				lCanceled := .T.
				MSGALERT("Favor preencher o campo destino da parcela 1", "Pedido de Vendas")
			End If
	   End Case		
    Endif
    
	If lCanceled	
		oPrn:Cancel()
	EndIf

    If !oPrn:Canceled()
    
		nTotSol 	:= nTotIcm := nBasIcm := nSubTot := nTotIPI := 	nVlrIPI := 	nICMS := nTotICMS := nTotalGeral := nPesoItem := nTotalItem := nTotalNota := nValDesc := nVolume := 0    
		_nAliqIcm	:= 0
		_nValIcm	:= 0
		_nBaseIcm	:= 0
		_nValIpi	:= 0
		_nBaseIpi	:= 0
		_nValMerc	:= 0
		_nValSol	:= 0
		_nValDesc	:= 0 
		
		While !SC6->(Eof()) .And. SC6->C6_NUM ==SC5->C5_NUM
			nContP++
			cFabricante	:=""//SC6->C6_XFABRIC
			nIPI		:= Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_IPI")
			nICMS		:= Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_ICM")
			nPesoItem	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESO")
			nPercIPI	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_IPI")
			cClassific	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_POSIPI")
			nPercICMS	:= Iif(Empty(nPercICMS),Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PICM"),nPercICMS)
			nVlrIPI		:= Iif(nIPI=="S",(SC6->C6_VALOR*nPercIPI)/100,0)
			nTotalItem	:= (SC6->C6_QTDVEN*nPesoItem)
			nSubTot		:= nSubTot + SC6->C6_VALOR         
			nTotIPI		:= nTotIPI + nVlrIPI
			nTotalNota	:= nTotalNota + nTotalItem     
			
			// Calculo ST e Outros Impostos
			MaFisIni(SC5->C5_CLIENTE,SC5->C5_LOJACLI,"C","N",SC5->C5_TIPOCLI,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")
			MaFisAdd(	SC6->C6_PRODUTO,;
						SC6->C6_TES,;
						SC6->C6_QTDVEN,;
						SC6->C6_PRCVEN,;
						SC6->C6_VALDESC,;
						"",;
						"",;
						0,;
						0,;
						0,;
						0,;
						0,;
						(SC6->C6_QTDVEN*SC6->C6_PRUNIT),;
						0,;
						0,;
						0)  
								
			_nAliqIcm	:= MaFisRet(1,"IT_ALIQICM")
			_nValIcm	:= MaFisRet(1,"IT_VALICM" )
			_nBaseIcm	:= MaFisRet(1,"IT_BASEICM")
			_nValIpi	:= MaFisRet(1,"IT_VALIPI" )
			_nBaseIpi	:= MaFisRet(1,"IT_BASEICM")
			_nValMerc	:= MaFisRet(1,"IT_VALMERC")
			_nValSol	:= MaFisRet(1,"IT_VALSOL" )
			_nValDesc	:= MaFisRet(1,"IT_DESCONTO" )
  
			nVolume		+= SC6->C6_QTDVEN		
			nTotIcm		+= _nValIcm
			nBasIcm		+= _nBaseIcm 
			nTotIPI		+= _nValIpi
			nTotSol		+= _nValSol
			nValDesc	+= _nValDesc
					
			MaFisEnd()
					
			SC6->(DBSKIP())            
			
		EndDo                                                                                                             

		nQtsP := IF(nContP<=10,"01",IF(nContP<=40,"02","03"))

		dbSelectArea("SC6")               
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+SC5->C5_NUM)
	
		nLin += 50
		nTotalGeral :=nSubTot+nTotIPI+SC5->C5_FRETE
		oPrn:Say(nLin,0100,"Frete:" ,oFont12N)
		oPrn:Say(nLin,0280,OemToAnsi(SC5->C5_TPFRETE),oFont12)

		IF !Empty(cPrazo1) 
			oPrn:Say(nLin,1500,"1º - " ,oFont12N)
			IF SE4->E4_TIPO == "9"
				oPrn:Say(nLin,1550,cPrazo1+" - R$ "+transform((SC5->C5_PARC1*(nMVPerc))			,"@E 999,999.99"),oFont12)
			ELSE	
				oPrn:Say(nLin,1550,cPrazo1+" - R$ "+transform((nTotalGeral*(nMVPerc))/len(aPrazo)	,"@E 999,999.99"),oFont12)
			ENDIF
			oPrn:Say(nLin,1850,"Pgto:",oFont12N)			// impressão do novo campo de observação do pagamento da parcela - Miguel
			oPrn:Say(nLin,2000,OemToAnsi(SC5->C5_PDEST1),oFont12)	
		EndIf	

		IF !Empty(cPrazo4) 
			oPrn:Say(nLin,2180,"4º - " ,oFont12N)
			IF SE4->E4_TIPO == "9"
				oPrn:Say(nLin,2230,cPrazo4+" - R$ "+transform((SC5->C5_PARC4*(nMVPerc))			,"@E 999,999.99"),oFont12)
			ELSE	
				oPrn:Say(nLin,2230,cPrazo4+" - R$ "+transform((nTotalGeral*(nMVPerc))/len(aPrazo)	,"@E 999,999.99"),oFont12)
			ENDIF
			oPrn:Say(nLin,2530,"Pgto:",oFont12N)			// impressão do novo campo de observação do pagamento da parcela - Miguel
			oPrn:Say(nLin,2680,OemToAnsi(SC5->C5_PDEST4),oFont12)	
		EndIf
	
		nLin += 50
		ncred:=0
		oPrn:Say(nLin,0100,"Vendedor:"	,oFont12N)
		oPrn:Say(nLin,0280,OemToAnsi(SA3->A3_COD+"-"+SA3->A3_NREDUZ),oFont12)
		
		IF !Empty(cPrazo2)
			oPrn:Say(nLin,1500,"2º - " ,oFont12N)
			IF SE4->E4_TIPO == "9"
				oPrn:Say(nLin,1550,cPrazo2+" - R$ "+transform((SC5->C5_PARC2*(nMVPerc))			,"@E 999,999.99"),oFont12)
			ELSE
				oPrn:Say(nLin,1550,cPrazo2+" - R$ "+transform((nTotalGeral*(nMVPerc))/len(aPrazo)	,"@E 999,999.99"),oFont12)
			ENDIF
			oPrn:Say(nLin,1850,"Pgto:",oFont12N)			// impressão do novo campo de observação do pagamento da parcela - Miguel
			oPrn:Say(nLin,2000,OemToAnsi(SC5->C5_PDEST2),oFont12)	
		EndIf	

		IF !Empty(cPrazo5) 
			oPrn:Say(nLin,2180,"5º - " ,oFont12N)                          
			IF SE4->E4_TIPO == "9"
				oPrn:Say(nLin,2230,cPrazo5+" - R$ "+transform((SC5->C5_PARC5*(nMVPerc))			,"@E 999,999.99"),oFont12)
			ELSE
				oPrn:Say(nLin,2230,cPrazo5+" - R$ "+transform((nTotalGeral*(nMVPerc))/len(aPrazo)	,"@E 999,999.99"),oFont12)
			ENDIF
			oPrn:Say(nLin,2530,"Pgto:",oFont12N)			// impressão do novo campo de observação do pagamento da parcela - Miguel
			oPrn:Say(nLin,2680,OemToAnsi(SC5->C5_PDEST5),oFont12)
		ENDIF 
			
		nLin  += 50
		finalidade:="" 
		oPrn:Say(nLin,0100,"Natureza:"	,oFont12N)
		finalidade := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_FINALID")
		oPrn:Say(nLin,0280,substr(finalidade,1,60),oFont12)

		IF !Empty(cPrazo3)
			oPrn:Say(nLin,1500,"3º - " ,oFont12N)
			IF SE4->E4_TIPO == "9"
				oPrn:Say(nLin,1550,cPrazo3+" - R$ "+transform((SC5->C5_PARC3*(nMVPerc)),"@E 999,999.99"),oFont12)
			ELSE
				oPrn:Say(nLin,1550,cPrazo3+" - R$ "+transform((nTotalGeral*(nMVPerc))/len(aPrazo),"@E 999,999.99"),oFont12)
			ENDIF
			oPrn:Say(nLin,1850,"Pgto:",oFont12N)			// impressão do novo campo de observação do pagamento da parcela - Miguel
			oPrn:Say(nLin,2000,OemToAnsi(SC5->C5_PDEST3),oFont12)		
		ENDIF	

		IF !Empty(cPrazo6) 
			oPrn:Say(nLin,2180,"6º - " ,oFont12N)
			oPrn:Say(nLin,2230,cPrazo6+" - R$ "+transform((nTotalGeral*(nMVPerc))/len(aPrazo),"@E 999,999.99"),oFont12)
		ENDIF         
	
		nLin  += 70
               
		oPrn:Box(1360,0050,1620,2850)
		
		nLin+=80     
	
		oPrn:Say(nLin,1400,"TOTAIS" ,oFont13N)

		nLin+=65               
		
		oPrn:Say(nLin,0100,"Base ICMS"				,oFont12N)
		oPrn:Say(nLin,0280,Transform(nBasIcm*(nMVPerc),"@E 9,999,999.99",),oFont12)
		oPrn:Say(nLin,0100+0485,"ICMS"				,oFont12N)
		oPrn:Say(nLin,0280+0485,Transform(nTotIcm*(nMVPerc),"@E 9,999,999.99",),oFont12)
		oPrn:Say(nLin,0100+0970,"ICMS-ST"			,oFont12N)
		oPrn:Say(nLin,0280+0970,Transform(nTotSol*(nMVPerc),"@E 9,999,999.99",),oFont12)
		oPrn:Say(nLin,0100+1455,"Desconto"			,oFont12N)
		oPrn:Say(nLin,0280+1455,Transform((nValDesc*(nMVPerc)),"@E 9,999,999.99"),oFont12)
		oPrn:Say(nLin,0100+1940,"Total Liq"			,oFont12N)
		oPrn:Say(nLin,0280+1940,Transform((nTotalGeral-(nTotalGeral*SC5->C5_DESC1/100)-(nSubTot*SC5->C5_COMIS1/100))*(nMVPerc),"@E 9,999,999.99",),oFont12)
		oPrn:Say(nLin,0100+2425,"Total Geral"		,oFont12N)
		oPrn:Say(nLin,0280+2425,Transform((nTotalGeral-(nTotalGeral*SC5->C5_DESC1/100))*(nMVPerc),"@E 9,999,999.99",),oFont12)	

		nLin += 65

		oPrn:Say(nLin,0100,"Frete"                 	,oFont12N)
		oPrn:Say(nLin,0280,Transform(SC5->C5_FRETE*(nMVPerc),"@E 9,999,999.99"),oFont12)
		oPrn:Say(nLin,0100+485,"Peso Liquido"		,oFont12N)
		oPrn:Say(nLin,0280+485,Transform(nTotalNota,"@E 9,999,999.99"),oFont12)
		oPrn:Say(nLin,0100+970,"Peso Bruto"			,oFont12N)
		oPrn:Say(nLin,0280+970,Transform(SC5->C5_PBRUTO,"@E 9,999,999.99",),oFont12)
		oPrn:Say(nLin,0100+1455,"Volume"			,oFont12N)
		oPrn:Say(nLin,0280+1455,Transform(nVolume,"@E 9999999.99",),oFont12)
		oPrn:Say(nLin,0100+1940,"Bonif Cliente"		,oFont12N)
		oPrn:Say(nLin,0280+1940,Transform(SC5->C5_X_TBO1,"@E 9,999,999.99",),oFont12)
		oPrn:Say(nLin,0100+2425,"Bonif Vend."		,oFont12N)
		oPrn:Say(nLin,0280+2425,Transform(SC5->C5_X_TBO2,"@E 9,999,999.99",),oFont12)	

	   	nLin += 115          
		nLin := 1640

		//oPrn:Box(nLin,0050,nLin+100,3200)	

		oPrn:Line(nLin,0050,nLin,2850)	
		oPrn:Line(nLin,0050,nLin+120,0050)	
		oPrn:Line(nLin,2850,nLin+120,2850)	

		nLin += 40

		oPrn:Say(nLin,0100,"Codigo"			,oFont12N)
		oPrn:Say(nLin,0280,"Descricao"		,oFont12N)
		oPrn:Say(nLin,1300,"Qtd Ven"		,oFont12N)
		oPrn:Say(nLin,1510,"Pr.Unitario"	,oFont12N)
		oPrn:Say(nLin,1720,"% Desc"			,oFont12N)
		oPrn:Say(nLin,1930,"Val. Desc"		,oFont12N)
		oPrn:Say(nLin,2140,"Total"			,oFont12N)
		oPrn:Say(nLin,2350,"Entrega"		,oFont12N)
		oPrn:Say(nLin,2560,"Peso"			,oFont12N)

		nLin += 30
		oPrn:Line(nLin,0050,nLin,2850)    
		nLin += 50
	
		nSubTot := 	nTotIPI := 	nVlrIPI := 	nICMS := nTotICMS := nTotalGeral := nPesoItem := nTotalItem := nTotalNota := 0
		
		While !SC6->(Eof()) .And. SC6->C6_NUM ==SC5->C5_NUM
			
			cFabricante:=""//SC6->C6_XFABRIC
			nIPI      := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_IPI")
			nICMS     := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_ICM")
			nPesoItem := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESO")
			nPercIPI  := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_IPI")
			cClassific:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_POSIPI")
			nPercICMS := Iif(Empty(nPercICMS),Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PICM"),nPercICMS)
			nVlrIPI   := Iif(nIPI=="S",(SC6->C6_VALOR*nPercIPI)/100,0)
			nTotalItem:= (SC6->C6_QTDVEN*nPesoItem)
			nSubTot   := nSubTot + SC6->C6_VALOR
			nTotIPI   := nTotIPI + nVlrIPI
			nTotalNota:= nTotalNota + nTotalItem
			nTotItens += SC6->C6_QTDVEN

			oPrn:Line(nLin,0050,nLin+50,0050)	
			oPrn:Line(nLin,2850,nLin+50,2850)	

			oPrn:Say(nLin,0120,OemToAnsi(SC6->C6_PRODUTO)								,oFont10N)
			oPrn:Say(nLin,0300,OemToAnsi(SC6->C6_DESCRI)								,oFont10N)
			oPrn:Say(nLin,1300,Transform(SC6->C6_QTDVEN			,"@E 9,999,999.99")	,oFont10N)
			oPrn:Say(nLin,1510,Transform(SC6->C6_PRCVEN*(nMVPerc)	,"@E 9,999,999.99")	,oFont10N)
			oPrn:Say(nLin,1720,Transform(SC6->C6_DESCONT			,"@R 9,999,999.99")	,oFont10N)
			oPrn:Say(nLin,1930,Transform(SC6->C6_VALDESC*(nMVPerc)	,"@E 9,999,999.99")	,oFont10N)
			oPrn:Say(nLin,2140,Transform(SC6->C6_VALOR*(nMVPerc)	,"@E 9,999,999.99")	,oFont10N)   
			oPrn:Say(nLin,2350,DTOC(SC6->C6_ENTREG)									,oFont10N)
			oPrn:Say(nLin,2560,Transform(nTotalItem					,"@E 9,999,999.99")	,oFont10N)
	
			/*IF nIPI=="S"
			oPrn:Say(nLin,2750,Transform(nPercIpi,"@R 999.99",),			oFont10N)
			oPrn:Say(nLin,2920,Transform(nVlrIPI,"@E 9,999,999.99",),		oFont10N)
			else*/
			nPerIPI:=0
			nVlrIpi:=0
			/*oPrn:Say(nLin,2750,Transform(nPercIpi,"@R 999.99",),			oFont10N)
			oPrn:Say(nLin,2920,Transform(nVlrIPI,"@E 9,999,999.99",),		oFont10N)
			endif*/
					
			nLin+=50
			
			IF nLin > 2200

				oPrn:Line(nLin,0050,nLin,2850)    

				oPrn:Say(2300,2500,"Pedido "+_cNum+" Pag. "+strzero(_nPag,2)+"/"+nQtsP,		oFont09N)
				_nPag++

				oPrn:EndPage()
				oPrn:StartPage()
				CabecRel()	
				nLin := 650 
				
				oPrn:Line(0600,0050,0600,2850)    
				oPrn:Line(0600,0050,0650,0050)    
				oPrn:Line(0600,2850,0650,2850)    
				
			ENDIF
					
			SC6->(DBSKIP())            

		ENDDO
		
	EndIf            

	oPrn:EndPage()
	SC5->(dbskip())
	
EndDo                   

IF nLin > 2000

	oPrn:Line(nLin,0050,nLin,2850)    

	oPrn:Say(2300,2500,"Pedido "+_cNum+" Pag. "+strzero(_nPag,2)+"/"+nQtsP,		oFont09N)
	_nPag++
	
	oPrn:EndPage()
	oPrn:StartPage()
	CabecRel()	
	nLin := 650

	oPrn:Line(0600,0050,0600,2850)    
	oPrn:Line(0600,0050,0650,0050)    
	oPrn:Line(0600,2850,0650,2850)    

ENDIF

oPrn:Line(nLin,0050,nLin    ,2850)    
oPrn:Line(nLin,0050,nLin+70,0050)    
oPrn:Line(nLin,2850,nLin+70,2850)    
       
nLin += 40     

oPrn:Say(nLin,0100,"Total de Itens:", oFont10N)
oPrn:Say(nLin,1300,Transform(nTotItens,"@E 9,999,999.99"), oFont10N)

nLin += 30     
oPrn:Line(nLin,0050,nLin,2850)    

nLin += 20     
oPrn:Line(nLin,0050,nLin   ,2850)    
oPrn:Line(nLin,0050,nLin+90,0050)    
oPrn:Line(nLin,2850,nLin+90,2850)    

nLin+=40                        

oPrn:Say(nLin,1350,"Observações" ,oFont13N)

nLin+=50                        

cAux := alltrim(strtran(cObs,CHR(13)+CHR(10),""))
aTexto := {}
if at(";",cAux) > 0
	aTexto := strtoarray(cAux,";")	
ENDIF                                             
IF Len(aTexto) > 0
	For nj:=1 to Len(aTexto)                           
		cAux := Alltrim(aTexto[nj])
		While len(cAux) > 0

			oPrn:Line(nLin,0050,nLin+50,0050) 
			oPrn:Line(nLin,2850,nLin+50,2850)    
			oPrn:Say(nLin,0100,substr(cAux,1,120),oFont12)
			nLin += 50

			cAux := substr(cAux,121)	
			loop
		Enddo
	next nj	
ELSE
	While len(cAux) > 0

		oPrn:Line(nLin,0050,nLin+50,0050) 
		oPrn:Line(nLin,2850,nLin+50,2850)    
		oPrn:Say(nLin,0100,substr(cAux,1,120),oFont12)
		nLin += 50

		cAux := substr(cAux,121)	
		loop
	Enddo	
ENDIF	

oPrn:Line(nLin,0050,nLin,2850) 

IF nLin > 2200
	oPrn:Say(2300,2500,"Pedido "+_cNum+" Pag. "+strzero(_nPag,2)+"/"+nQtsP,		oFont09N)
	_nPag++
	oPrn:EndPage()
	oPrn:StartPage()
	CabecRel()	
	nLin := 900
ELSE	
	nLin += 250
ENDIF        

oPrn:Say(nLin,1000,"--------------------------------------------",		oFont13N)
oPrn:Say(nLin,2000,"--------------------------------------------",		oFont13N)
nLin += 50
oPrn:Say(nLin,1100,"Cliente",		oFont13N)
oPrn:Say(nLin,2100,"Gold Hair",		oFont13N)


oPrn:Say(2300,2500,"Pedido "+_cNum+" Pag. "+strzero(_nPag,2)+"/"+nQtsP,		oFont09N)

//oPrn:Say(2270,2800,"Total de Itens: "+Transform(nTotItens,"@E 9,999,999.99"),		oFont10N)

oPrn:EndPage()

Return(lCanceled)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MAILPV    ³ Autor ³ GUILHERME GIULIANO    ³ Data ³31.07.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Pedido de Vendas  - TmsPrinter                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico GOLD HAIR                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CABECREL()

cBitMap			:= "lgrl01.Bmp"
cBitMapB		:= "lgrl01B.Bmp"
cBitMapC		:= "lgrl01C.bmp"

oPrn:SayBitmap(260,0080,cBitMap ,400,320)		// Imprime logo da Empresa: comprimento X altura
oPrn:SayBitmap(380,0500,cBitMapB,400,200)		// Imprime logo da Empresa: comprimento X altura
oPrn:SayBitmap(380,0920,cBitMapC,400,200)		// Imprime logo da Empresa: comprimento X altura
oPrn:Say(300,0600,SM0->M0_NOMECOM,oFont14N)                                           

oPrn:Box(0250,2200,0350,2800)
oPrn:Say(0310,2300, "Pedido No",oFont14N)
oPrn:Say(0310,2600,OemToAnsi(SC5->C5_NUM),oFont14)
oPrn:Say(0550,2560,"Emissão: "+Dtoc(SC5->C5_EMISSAO),oFont11)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MAILPV    ³ Autor ³ GUILHERME GIULIANO    ³ Data ³31.07.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Pedido de Vendas  - TmsPrinter                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico GOLD HAIR                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MAILPV(cArqName,cPathImg)

local nheightpage	:= 800                                        
local nwidthpage	:= 1200 
local cServer		:= GetMV("MV_RELSERV")
local cEnvia		:= GetMV("MV_RELFROM")
local cPassword		:= GetMV("MV_RELPSW")
local cRecebe		:= alltrim(cGet1)+IF(Empty(cGet2),"",";"+alltrim(cGet2))+IF(Empty(cGet3),"",";"+alltrim(cGet3))+IF(Empty(cGet4),"",";"+alltrim(cGet4))
local aRecebe		:= {} 
local aAnexos		:= {}             

IF Empty(cRecebe)
	msgalert("Campo de email em branco!")
Else             
	CONNECT SMTP SERVER cServer ACCOUNT cEnvia PASSWORD cPassword RESULT lResulConn
	MailAutH(cEnvia,cPassword)

	IF lResulConn

		CpyT2S( "C:\TEMP\IMAGES\"+cArqName+".PDF", "\IMAGES" )

		aadd(aAnexos,"\Images\"+cArqName+".PDF")
			
		IF !Empty(cRecebe)
			aadd(aRecebe,cRecebe)
		
			lEnviado := MailSend( cEnvia, aRecebe,{} ,{} , 'Gold Hair Advance - Pedido de Venda: '+	_cNum+" gerado.",alltrim(strtran(cMsg,CHR(13)+CHR(10),"")), aAnexos , .F. )
			
			IF !lEnviado                             
				GET MAIL ERROR cMensagem
				MsgAlert("Nao foi possivel enviar o email - "+cMensagem)            
			ELSE
				msgInfo("Email enviado com sucesso!")	
			Endif
		ENDIF	
	ELSE
		Msgalert("Nao foi possivel conectar ao servidor SMTP")	
	ENDIF
	aRecebe := {}
ENDIF                           

fErase("\\SRVGH01\D$\TOTVS11\Microsiga\Protheus_data\Images\"+cArqName+".PDF")

Return

