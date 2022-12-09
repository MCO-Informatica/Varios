#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"

User Function relat024()

Local oDlg       := NIL
Local cString	  := "SZ2"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "relat024"
Private nomeProg 	:= FunName()
Private cCodRDV 	:= M->Z2_CODRDV

Private cIDCONF 	:= M->Z2_IDCONF
Private cIDAPROV 	:= M->Z2_IDAPROV
Private cIDAPRCO 	:= M->Z2_IDCONF
Private cIDCOLAB 	:= M->Z2_IDCOLAB

/*
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif
*/

wnrel := FunName()            //Nome Default do relatorio em Disco

Private cTitulo  := "Impressao do Relatorio de Despesas"
Private oPrn     := NIL
Private oFont1   := NIL
Private oFont2   := NIL
Private oFont3   := NIL
Private oFont4   := NIL
Private oFont5   := NIL
Private oFont6   := NIL
Private nLastKey := 0
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais

DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont8	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
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
oFont6		:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27

	Return( NIL )
	
Endif


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
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

Despesas()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function Despesas()

	cDia := SubStr(DtoS(dDataBase),7,2)
	cMes := SubStr(DtoS(dDataBase),5,2)
	cAno := SubStr(DtoS(dDataBase),1,4)

	
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
	
	
				
	SZ2->( dbSetOrder(1) )
	SZ2->( dbSeek( xFilial("SZ2")+cCodRDV ) )
	
	
	
While ! SZ2->( Eof() ) .AND. SZ2->Z2_CODRDV == cCodRDV

	
	/*
	cAssConf 	:= Alltrim(SZ2->Z2_IDCONF) + ".bmp"
	cAssAprov 	:= Alltrim(SZ2->Z2_IDAPROV) + ".bmp"
	*/
			
	//oPrn:Say(0040,1890, SZ2->Z2_CODRDV,oFont14)
				
	SZ3->( dbSetOrder(1) )
	SZ3->( dbSeek(xFilial("SZ3")+cCodRDV) )
	
	nLinha    := 0780
	While ! SZ3->(Eof() ) .And. SZ3->Z3_IDRDV == cCodRDV
		
		if nLinha > 2000 .OR. nLinha == 0   
			if nLinha <> 0	
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0780
				oPrn:EndPage()		
			endif
		End if
	
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  	( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n)
		
		
		// Dados da Colaborador
		oPrn:Box	(0190,0050,0280,0350) // 
		oPrn:Say  (0220,0070,"ID RDV: " + SZ2->Z2_CODRDV,oFont8n)
		oPrn:Box	(0190,0350,0280,0700) //
		oPrn:Say  (0220,0370,"ID Colaborador: " + SZ2->Z2_IDCOLAB,oFont8n)
		oPrn:Box	(0190,0700,0280,2100) //
		oPrn:Say  (0220,0720,"Colaborador: " + SZ2->Z2_COLAB,oFont9n)
		
		oPrn:FillRect({0280,0050,0360,2100},oBrush)
		oPrn:Box	(0280,0050,0360,2100)
		oPrn:Say  (0300,0900,"Resumo por tipo de Despesa"  ,oFont9n) 
		
		oPrn:Box	(0360,0050,0440,2100)
		oPrn:Say  (0380,0070,"Bilhete Aereo: " + Alltrim(transform(SZ2->Z2_RBILHET,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,0470,"Hospedagem: " + Alltrim(transform(SZ2->Z2_RHOSP,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,0870,"Alimentacao: " + Alltrim(transform(SZ2->Z2_RALIM,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,1270,"Taxi: " + Alltrim(transform(SZ2->Z2_RTAXI,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,1670,"Conducao: " + Alltrim(transform(SZ2->Z2_RCOND,"@E 999,999,999.99")) ,oFont9n)
		
		
		oPrn:Box	(0440,0050,0520,2100)
		oPrn:Say  (0460,0070,"Representacao: " + Alltrim(transform(SZ2->Z2_RREPRE,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,0470,"Diversos: " + Alltrim(transform(SZ2->Z2_RDIVERS,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,0870,"Veiculo Proprio: " + Alltrim(transform(SZ2->Z2_RVPROP,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,1270,"Pedagio: " + Alltrim(transform(SZ2->Z2_RPEDAG,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,1670,"Estacionamento: " + Alltrim(transform(SZ2->Z2_RESTAC,"@E 999,999,999.99")) ,oFont9n)
		
		
		oPrn:Box	(0520,0050,0600,2100)
		oPrn:Say  (0540,0070,"Combustivel: " + Alltrim(transform(SZ2->Z2_RCOMBUS,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0540,0470,"Multa: " + Alltrim(transform(SZ2->Z2_RMULTA,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0540,0870,"Locacao Veiculo: " + Alltrim(transform(SZ2->Z2_RLOCVEI,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0540,1270,"Telefone: " + Alltrim(transform(SZ2->Z2_RTEL,"@E 999,999,999.99")) ,oFont9n)
		
		oPrn:FillRect({0600,0050,0680,2100},oBrush)
		oPrn:Box	(0600,0050,0680,2100)
		oPrn:Say  (0620,0900,"Detalhamento Despesas ",oFont9n)
		
		// Resumo despesas
		oPrn:Box	(0050,0740,0190,1850) // Titulo Pedido
		oPrn:Say  (0100,0900,"Relatorio de Viagem - " +  SZ2->Z2_CODRDV ,oFont14)
		
		oPrn:Box	(0050,1850,0190,2100) // Data Registro
		oPrn:Say  (0070,1900,"Data Registro " ,oFont9n)
		oPrn:Say  (0120,1910,DTOC(SZ2->Z2_DTREG) ,oFont9n)
	
		oPrn:FillRect({0050,2750,0100,3300},oBrush)
		oPrn:FillRect({0050,2100,0100,2750},oBrush)
		oPrn:FillRect({0600,2800,0680,3300},oBrush)
		
		oPrn:FillRect({0050,2800,0100,3300},oBrush)
		oPrn:FillRect({0050,2100,0100,2800},oBrush)
		oPrn:FillRect({0600,2800,0680,3300},oBrush)
		
		oPrn:Box	(0050,2800,0600,3300) // Totais
		oPrn:Box	(0050,2800,0100,3300)
		oPrn:Say  (0060,2950,"RESUMO ",oFont8n) 
		
		oPrn:Box	(0100,2800,0200,3300)
		oPrn:Say  (0120,2820,"Adiantamento: ",oFont9n) 
		oPrn:Say  (0120,3250, Alltrim(transform(SZ2->Z2_TADIANT,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0200,2800,0300,3300)
		oPrn:Say  (0220,2820,"Pago Empresa: ",oFont9n) 
		oPrn:Say  (0220,3250, Alltrim(transform(SZ2->Z2_PGEMPRE,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0300,2800,0400,3300)
		oPrn:Say  (0320,2820,"Pago Funcionario: ",oFont9n) 
		oPrn:Say  (0320,3250, Alltrim(transform(SZ2->Z2_PGFUNC,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0400,2800,0500,3300)
		oPrn:Say  (0420,2820,"Total a Receber: ",oFont9n) 
		oPrn:Say  (0420,3250, Alltrim(transform(SZ2->Z2_TRECEB,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0500,2800,0600,3300)
		oPrn:Say  (0520,2820,"Total a Devolver: ",oFont9n) 
		oPrn:Say  (0520,3250, Alltrim(transform(SZ2->Z2_TDEVOL,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0600,2800,0680,3300)
		oPrn:Say  (0620,2820,"Total Despesas: ",oFont9n) 
		oPrn:Say  (0620,3250, Alltrim(transform(SZ2->Z2_TDESPES,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0050,2100,0680,2800) // Totais
		oPrn:Box	(0050,2100,0100,2800)
		oPrn:Say  (0060,2400,"RATEIO ",oFont8n) 
		
		oPrn:Box	(0100,2100,0170,2800)
		oPrn:Box	(0170,2100,0250,2800)
		oPrn:Box	(0250,2100,0320,2800)
		oPrn:Box	(0320,2100,0410,2800)
		oPrn:Box	(0410,2100,0500,2800)
		oPrn:Box	(0500,2100,0580,2800)
		oPrn:Say  (0110,2120,"Contrato " ,oFont9n) 
		oPrn:Say  (0190,2120, SZ2->Z2_ITEMIC1,oFont9n)
		oPrn:Say  (0270,2120, SZ2->Z2_ITEMIC2,oFont9n)
		oPrn:Say  (0350,2120, SZ2->Z2_ITEMIC3,oFont9n)
		oPrn:Say  (0430,2120, SZ2->Z2_ITEMIC4,oFont9n)
		oPrn:Say  (0520,2120, SZ2->Z2_ITEMIC5,oFont9n)
		oPrn:Say  (0600,2120, SZ2->Z2_ITEMIC6,oFont9n)
		
		oPrn:Say  (0110,2420,"Rel. Visita " ,oFont9n) 
		oPrn:Say  (0190,2420, SZ2->Z2_RELVS1,oFont9n)
		oPrn:Say  (0270,2420, SZ2->Z2_RELVS2,oFont9n)
		oPrn:Say  (0350,2420, SZ2->Z2_RELVS3,oFont9n)
		oPrn:Say  (0430,2420, SZ2->Z2_RELVS4,oFont9n)
		oPrn:Say  (0520,2420, SZ2->Z2_RELVS5,oFont9n)
		oPrn:Say  (0600,2420, SZ2->Z2_RELVS6,oFont9n)
		
		
		oPrn:Say  (0110,2650,"Valor " ,oFont9n)
		oPrn:Say  (0190,2750, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0270,2750, Alltrim(transform(SZ2->Z2_VALIC2,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0350,2750, Alltrim(transform(SZ2->Z2_VALIC3,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0430,2750, Alltrim(transform(SZ2->Z2_VALIC4,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0520,2750, Alltrim(transform(SZ2->Z2_VALIC5,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0600,2750, Alltrim(transform(SZ2->Z2_VALIC6,"@E 999,999,999.99")),oFont9n,20,,,1)
	
		// ********************** Rodap� ****************	 	
		//---------------------- CONFERENTE
		oPrn:Box	(2120,0050,2170,0790) 
		oPrn:Say  (2130,0070,"Revisado",oFont9n)

		cIdConf		:= Alltrim(SZ2->Z2_IDCONF)
		cAssConf	:= GetSrvProfString('Startpath','') + cIdConf + '.BMP'
		oPrn:SayBitmap(2220,0270,cAssConf,0580,0180)
		//oPrn:Box	(LS,CE,LI,DI) // Assinatura Comprador
		oPrn:Box	(2170,0050,2350,0790) // Assinatura Comprador
		oPrn:Say  (2190,0060,SZ2->Z2_UCONF,oFont9n)

		//---------------------- COLABORADOR
		oPrn:Box	(2120,0790,2170,1580)
		oPrn:Say  (2130,0800,"Colaborador",oFont9n)

		oPrn:Say  (2190,0800,SZ2->Z2_COLAB,oFont9n)
		cIdColab	:= Alltrim(SZ2->Z2_IDCOLAB)
		cAssColab	:= GetSrvProfString('Startpath','') + cIdColab + '.BMP'
		oPrn:SayBitmap(2220,0800,cAssColab,0580,0180)
		oPrn:Box	(2170,0790,2350,1580) // Colaborador

		//---------------------- COORDENADOR
		oPrn:FillRect({2070,1580,2120,3060},oBrush)
		oPrn:Box	(2070,1580,2120,3060)
		oPrn:Say  (2075,2270,"Aprovacao",oFont9n)

		oPrn:Box	(2120,1580,2170,2320)
		oPrn:Say  (2130,1590,"Coordenador",oFont9n)

		oPrn:Say  (2190,1590,SZ2->Z2_UAPRCO,oFont9n)
		cIDAprCO	:= Alltrim(SZ2->Z2_IDAPRCO)
		cAssAprCO	:= GetSrvProfString('Startpath','') + cIDAprCO + '.BMP'
		oPrn:SayBitmap(2220,1700,cAssAprCO,0580,0180)
		oPrn:Box	(2170,1580,2350,2320) // Colaborador
		
		//-------------------------- DIRETORIA
		oPrn:Box	(2120,2320,2170,3060)
		oPrn:Say  (2130,2330,"Diretoria",oFont9n)

		cIdAprov		:= Alltrim(SZ2->Z2_IDAPROV)
		cAssAprov	:= GetSrvProfString('Startpath','') + cIdAprov + '.BMP'
		oPrn:SayBitmap(2220,2400,cAssAprov,0580,0180)
		oPrn:Say  (2190,2340,SZ2->Z2_UAPROV,oFont9n)
		oPrn:Box	(2170,2320,2350,3060) // Ger�ncia
		
		oPrn:Box	(2170,3060,2350,3300) //
		oPrn:Say  (2230,3080,"Pagina " + Transform(StrZero(ncont,3),""),oFont8n) //+ " de " + Transform(StrZero(ncont1,3),"")
		
		oPrn:Box	(0680,0050,0760,3300) // cabeca�alhos detalhamento
		oPrn:Box	(0680,0050,2030,0180) // Item
		oPrn:Box	(0680,0180,2030,0380) // Data
		oPrn:Box	(0680,0380,2030,0580) // Cod. forn.
		oPrn:Box	(0680,0580,2030,1380) // fornecedor
		oPrn:Box	(0680,1380,2030,1640) // tipo desp
		oPrn:Box	(0680,1640,2030,2900) // descricao despesas
		oPrn:Box	(0680,2900,2030,3160) // valor
		oPrn:Box	(0680,3160,2030,3300) // Pg. empresa
		
		oPrn:Say  (0700,0070,"Item",oFont8n)
		oPrn:Say  (0700,0200,"Data",oFont8n)
		oPrn:Say  (0700,0400,"Cod.FC.",oFont8n)
		oPrn:Say  (0700,0600,"Empresa",oFont8n)
		oPrn:Say  (0700,1400,"Tipo Desp.",oFont8n)
		oPrn:Say  (0700,1660,"Descricao",oFont8n)
		oPrn:Say  (0700,3000,"Valor",oFont8n)
		oPrn:Say  (0700,3180,"Pg.Emp.",oFont8n)
		//***********************************************		
												
		oPrn:Say(nLinha,0070, SZ3->Z3_ITEM, oFont8)
		oPrn:Say(nLinha,0200, Substr(DTOS(SZ3->Z3_DATA),7,2) + "/" + Substr(DTOS(SZ3->Z3_DATA),5,2) + "/" + Substr(DTOS(SZ3->Z3_DATA),1,4), oFont8)
		oPrn:Say(nLinha,0400, SZ3->Z3_CODFORN, oFont8)
		oPrn:Say(nLinha,0600, SZ3->Z3_FORNECE, oFont8)
		
		If SZ3->Z3_TPDESP = "BLA"
			cTPDESP := "BILHETE AEREO"
		ElseIf SZ3->Z3_TPDESP = "CBT"
			cTPDESP := "COMBUSTIVEL"
		ElseIf SZ3->Z3_TPDESP = "CDC"
			cTPDESP := "CONDUCAO"
		ElseIf SZ3->Z3_TPDESP = "DVS"
			cTPDESP := "DIVERSOS"
		ElseIf SZ3->Z3_TPDESP = "EST"
			cTPDESP := "ESTACIONAMENTO"
		ElseIf SZ3->Z3_TPDESP = "HPG"
			cTPDESP := "HOSPEDAGEM"
		ElseIf SZ3->Z3_TPDESP = "LCH"
			cTPDESP := "LANCHE"
		ElseIf SZ3->Z3_TPDESP = "LCV"
			cTPDESP := "LOCACAO VEICULO"
		ElseIf SZ3->Z3_TPDESP = "MLT"
			cTPDESP := "MULTA"
		ElseIf SZ3->Z3_TPDESP = "PDG"
			cTPDESP := "PEDAGIO"
		ElseIf SZ3->Z3_TPDESP = "RFC"
			cTPDESP := "REFEICAO"
		ElseIf SZ3->Z3_TPDESP = "RPT"
			cTPDESP := "REPRESENTACAO"
		ElseIf SZ3->Z3_TPDESP = "TAX"
			cTPDESP := "TAXI"
		ElseIf SZ3->Z3_TPDESP = "TEL"
			cTPDESP := "TELEFONE"
		ElseIf SZ3->Z3_TPDESP = "VCP"
			cTPDESP := "VEICULO PROPRIO"
		Endif
		
		oPrn:Say(nLinha,1400, cTPDESP, oFont8)
		oPrn:Say(nLinha,1660, SZ3->Z3_DESCDES, oFont8)
		oPrn:Say(nLinha,3140,Alltrim(transform(SZ3->Z3_VALOR,"@E 999,999,999.99")),oFont8,20,,,1)
		
		if SZ3->Z3_PGEMPRE = "1" 
			oPrn:Say(nLinha,3200, "Sim", oFont8)
		else
			oPrn:Say(nLinha,3200, "Nao", oFont8)
		end if		
		nLinha+=0050
		
		SZ3->(dbSkip())
	
		EndDo

SZ2->( dbSkip() )
		
EndDo			

oPrn:EndPage()

Return( NIL )

Static Function cabec()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  	( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n)
		
		// Dados da Colaborador
		oPrn:Box	(0190,0050,0280,0350) // 
		oPrn:Say  (0220,0070,"ID RDV: " + SZ2->Z2_CODRDV,oFont8n)
		oPrn:Box	(0190,0350,0280,0700) //
		oPrn:Say  (0220,0370,"ID Colaborador: " + SZ2->Z2_IDCOLAB,oFont8n)
		oPrn:Box	(0190,0700,0280,2100) //
		oPrn:Say  (0220,0720,"Colaborador: " + SZ2->Z2_COLAB,oFont9n)
		
		oPrn:FillRect({0280,0050,0360,2100},oBrush)
		oPrn:Box	(0280,0050,0360,2100)
		oPrn:Say  (0300,0900,"Resumo por tipo de Despesa"  ,oFont9n) 
		
		oPrn:Box	(0360,0050,0440,2100)
		oPrn:Say  (0380,0070,"Bilhete Aereo: " + Alltrim(transform(SZ2->Z2_RBILHET,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,0470,"Hospedagem: " + Alltrim(transform(SZ2->Z2_RHOSP,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,0870,"Alimentacao: " + Alltrim(transform(SZ2->Z2_RALIM,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,1270,"Taxi: " + Alltrim(transform(SZ2->Z2_RTAXI,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0380,1670,"Conducao: " + Alltrim(transform(SZ2->Z2_RCOND,"@E 999,999,999.99")) ,oFont9n)
		
		oPrn:Box	(0440,0050,0520,2100)
		oPrn:Say  (0460,0070,"Representacao: " + Alltrim(transform(SZ2->Z2_RCOND,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,0470,"Diversos: " + Alltrim(transform(SZ2->Z2_RDIVERS,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,0870,"Veiculo Proprio: " + Alltrim(transform(SZ2->Z2_RVPROP,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,1270,"Pedagio: " + Alltrim(transform(SZ2->Z2_RPEDAG,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0460,1670,"Estacionamento: " + Alltrim(transform(SZ2->Z2_RESTAC,"@E 999,999,999.99")) ,oFont9n)
		
		oPrn:Box	(0520,0050,0600,2100)
		oPrn:Say  (0540,0070,"Combustivel: " + Alltrim(transform(SZ2->Z2_RCOMBUS,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0540,0470,"Multa: " + Alltrim(transform(SZ2->Z2_RMULTA,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0540,0870,"Locacao Veiculo: " + Alltrim(transform(SZ2->Z2_RLOCVEI,"@E 999,999,999.99")) ,oFont9n)
		oPrn:Say  (0540,1270,"Telefone: " + Alltrim(transform(SZ2->Z2_RTEL,"@E 999,999,999.99")) ,oFont9n)
		
		oPrn:FillRect({0600,0050,0680,2100},oBrush)
		oPrn:Box	(0600,0050,0680,2100)
		oPrn:Say  (0620,0900,"Detalhamento Despesas ",oFont9n)
		
		// Resumo despesas
		oPrn:Box	(0050,0740,0190,1850) // Titulo Pedido
		oPrn:Say  (0100,0900,"Relatorio de Viagem - " +  SZ2->Z2_CODRDV ,oFont14)
		
		oPrn:Box	(0050,1850,0190,2200) // Data Registro
		oPrn:Say  (0070,1920,"Data Registro " ,oFont9n)
		oPrn:Say  (0120,1920,DTOC(SZ2->Z2_DTREG) ,oFont9n)
	
		oPrn:FillRect({0050,2800,0100,3300},oBrush)
		oPrn:FillRect({0050,2100,0100,2800},oBrush)
		oPrn:FillRect({0600,2800,0680,3300},oBrush)
		
		oPrn:Box	(0050,2800,0600,3300) // Totais
		oPrn:Box	(0050,2800,0100,3300)
		oPrn:Say  (0060,2950,"RESUMO ",oFont8n) 
		
		oPrn:Box	(0100,2800,0200,3300)
		oPrn:Say  (0120,2820,"Adiantamento: ",oFont9n) 
		oPrn:Say  (0120,3250, Alltrim(transform(SZ2->Z2_TADIANT,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0200,2800,0300,3300)
		oPrn:Say  (0220,2820,"Pago Empresa: ",oFont9n) 
		oPrn:Say  (0220,3250, Alltrim(transform(SZ2->Z2_PGEMPRE,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0300,2800,0400,3300)
		oPrn:Say  (0320,2820,"Pago Funcionario: ",oFont9n) 
		oPrn:Say  (0320,3250, Alltrim(transform(SZ2->Z2_PGFUNC,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0400,2800,0500,3300)
		oPrn:Say  (0420,2820,"Total a Receber: ",oFont9n) 
		oPrn:Say  (0420,3250, Alltrim(transform(SZ2->Z2_TRECEB,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0500,2800,0600,3300)
		oPrn:Say  (0520,2820,"Total a Devolver: ",oFont9n) 
		oPrn:Say  (0520,3250, Alltrim(transform(SZ2->Z2_TDEVOL,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0600,2800,0680,3300)
		oPrn:Say  (0620,2820,"Total Despesas: ",oFont9n) 
		oPrn:Say  (0620,3250, Alltrim(transform(SZ2->Z2_TDESPES,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		oPrn:Box	(0050,2100,0680,2800) // Totais
		oPrn:Box	(0050,2100,0100,2800)
		oPrn:Say  (0060,2400,"RATEIO ",oFont8n) 
		
		oPrn:Box	(0100,2100,0170,2800)
		oPrn:Box	(0170,2100,0250,2800)
		oPrn:Box	(0250,2100,0320,2800)
		oPrn:Box	(0320,2100,0410,2800)
		oPrn:Box	(0410,2100,0500,2800)
		oPrn:Box	(0500,2100,0580,2800)
		oPrn:Say  (0110,2120,"Contrato " ,oFont9n) 
		oPrn:Say  (0190,2120, SZ2->Z2_ITEMIC1,oFont9n)
		oPrn:Say  (0270,2120, SZ2->Z2_ITEMIC2,oFont9n)
		oPrn:Say  (0350,2120, SZ2->Z2_ITEMIC3,oFont9n)
		oPrn:Say  (0430,2120, SZ2->Z2_ITEMIC4,oFont9n)
		oPrn:Say  (0520,2120, SZ2->Z2_ITEMIC5,oFont9n)
		oPrn:Say  (0600,2120, SZ2->Z2_ITEMIC6,oFont9n)
		
		oPrn:Say  (0110,2420,"Rel. Visita " ,oFont9n) 
		oPrn:Say  (0190,2420, SZ2->Z2_RELVS1,oFont9n)
		oPrn:Say  (0270,2420, SZ2->Z2_RELVS2,oFont9n)
		oPrn:Say  (0350,2420, SZ2->Z2_RELVS3,oFont9n)
		oPrn:Say  (0430,2420, SZ2->Z2_RELVS4,oFont9n)
		oPrn:Say  (0520,2420, SZ2->Z2_RELVS5,oFont9n)
		oPrn:Say  (0600,2420, SZ2->Z2_RELVS6,oFont9n)
		
		oPrn:Say  (0110,2650,"Valor " ,oFont9n)
		oPrn:Say  (0190,2750, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0270,2750, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0350,2750, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0430,2750, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0520,2750, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)
		oPrn:Say  (0600,2750, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)
		
		
		// ********************** Rodap� ****************	 	
		//---------------------- CONFERENTE
		oPrn:Box	(2120,0050,2170,0790) 
		oPrn:Say  (2130,0070,"Revisado",oFont9n)

		cIdConf		:= Alltrim(SZ2->Z2_IDCONF)
		cAssConf	:= GetSrvProfString('Startpath','') + cIdConf + '.BMP'
		oPrn:SayBitmap(2220,0270,cAssConf,0580,0180)
		//oPrn:Box	(LS,CE,LI,DI) // Assinatura Comprador
		oPrn:Box	(2170,0050,2350,0790) // Assinatura Comprador
		oPrn:Say  (2190,0060,SZ2->Z2_UCONF,oFont9n)

		//---------------------- COLABORADOR
		oPrn:Box	(2120,0790,2170,1580)
		oPrn:Say  (2130,0800,"Colaborador",oFont9n)

		oPrn:Say  (2190,0800,SZ2->Z2_COLAB,oFont9n)
		cIdColab	:= Alltrim(SZ2->Z2_IDCOLAB)
		cAssColab	:= GetSrvProfString('Startpath','') + cIdColab + '.BMP'
		oPrn:SayBitmap(2220,0800,cAssColab,0580,0180)
		oPrn:Box	(2170,0790,2350,1580) // Colaborador

		//---------------------- COORDENADOR
		oPrn:FillRect({2070,1580,2120,3060},oBrush)
		oPrn:Box	(2070,1580,2120,3060)
		oPrn:Say  (2075,2270,"Aprovacao",oFont9n)

		oPrn:Box	(2120,1580,2170,2320)
		oPrn:Say  (2130,1590,"Coordenador",oFont9n)

		oPrn:Say  (2190,1590,SZ2->Z2_UAPRCO,oFont9n)
		cIDAprCO	:= Alltrim(SZ2->Z2_IDAPRCO)
		cAssAprCO	:= GetSrvProfString('Startpath','') + cIDAprCO + '.BMP'
		oPrn:SayBitmap(2220,1700,cAssAprCO,0580,0180)
		oPrn:Box	(2170,1580,2350,2320) // Colaborador
		
		//-------------------------- DIRETORIA
		oPrn:Box	(2120,2320,2170,3060)
		oPrn:Say  (2130,2330,"Diretoria",oFont9n)

		cIdAprov		:= Alltrim(SZ2->Z2_IDAPROV)
		cAssAprov	:= GetSrvProfString('Startpath','') + cIdAprov + '.BMP'
		oPrn:SayBitmap(2220,2400,cAssAprov,0580,0180)
		oPrn:Say  (2190,2340,SZ2->Z2_UAPROV,oFont9n)
		oPrn:Box	(2170,2320,2350,3060) // Ger�ncia
		
		oPrn:Box	(2170,3060,2350,3300) //
		oPrn:Say  (2230,3080,"Pagina " + Transform(StrZero(ncont,3),""),oFont8n) //+ " de " + Transform(StrZero(ncont1,3),"")
		
		
		oPrn:Box	(0680,0050,0760,3300) // cabeca�alhos detalhamento
		oPrn:Box	(0680,0050,2030,0180) // Item
		oPrn:Box	(0680,0180,2030,0380) // Data
		oPrn:Box	(0680,0380,2030,0580) // Cod. forn.
		oPrn:Box	(0680,0580,2030,1380) // fornecedor
		oPrn:Box	(0680,1380,2030,1620) // tipo desp
		oPrn:Box	(0680,1620,2030,2900) // descricao despesas
		oPrn:Box	(0680,2900,2030,3160) // valor
		oPrn:Box	(0680,3160,2030,3300) // Pg. empresa
		
		oPrn:Say  (0700,0070,"Item",oFont8n)
		oPrn:Say  (0700,0200,"Data",oFont8n)
		oPrn:Say  (0700,0400,"Cod.FC.",oFont8n)
		oPrn:Say  (0700,0600,"Empresa",oFont8n)
		oPrn:Say  (0700,1400,"Tipo Desp.",oFont8n)
		oPrn:Say  (0700,1700,"Descricao",oFont8n)
		oPrn:Say  (0700,3000,"Valor",oFont8n)
		oPrn:Say  (0700,3180,"Pg.Emp.",oFont8n)
		//***********************************************
Return ( Nil )

Static Function AjustaSX1()

putSx1(cPerg, "01", "Numero RDV:"	  , "", "", "mv_ch1", "C", 10, 0, 0, "G", "", "SZ2", "", "", "mv_par01")


Return( NIL )

