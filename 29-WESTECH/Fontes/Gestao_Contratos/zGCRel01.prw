#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"

User Function zGCRel01()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel01"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressão do Relatório de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC01()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC01()

PrnGCC01()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC01()

	
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	

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
				
	TRB1->( dbSetOrder(1) )
	TRB1->( dbSeek( xFilial("TRB1")+_cItemConta ) )
	
	nLinha    := 0500
	While ! TRB1->( Eof() ) .AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3300) //Box Cabeça

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,1200,"GESTÃO DE CONTRATO - CUSTO EMPENHADO -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3300) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissão " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
	
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV),oFont7) //data movimento
		oPrn:Say  (nLinha,0170,TRB1->ORIGEM,oFont7) //origem
		oPrn:Say  (nLinha,0240,TRB1->NUMERO,oFont7) //origem
		oPrn:Say  (nLinha,0320,TRB1->TIPO,oFont7) //origem
		oPrn:Say  (nLinha,0380,TRB1->PRODUTO,oFont7) //codigo produto		
		
		
		nLinha+=0050
		
		TRB1->(dbSkip())
	
		EndDo


oPrn:EndPage()

Return( NIL )

Static Function cabec()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,1200,"GESTÃO DE CONTRATO - CUSTO EMPENHADO -  " + _cItemConta ,oFont20)
		
Return ( Nil )

