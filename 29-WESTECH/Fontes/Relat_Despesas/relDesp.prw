#INCLUDE "TOTVS.CH"
#INCLUDE "FONT.CH"

User Function relDesp()

Local oDlg       := NIL
Local cString	  := "SZ2"

Private titulo   := ""
Private nLastKey := 0
Private cPerg	  := "relDesp"
Private nomeProg := FunName()


AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

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

DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N  := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11   := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N  := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12   := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N  := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N  := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N  := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N  := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)

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

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o impresso customizado:"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Relatorio de Despesas"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

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
cMesExt := MesExtenso(Month(dDataBase))
cDataImpressao := cDia+" de "+cMesExt+" de "+cAno

oPrn:StartPage()
/*
cBitMap := "P:\Logo1.Bmp"
oPrn:SayBitmap(1200,1200,cBitMap,2400,1700)			// Imprime logo da Empresa: comprimento X altura

oPrn:Say(0030,0100,SM0->M0_NOMECOM,oFont14N)
*/
oPrn:Box(0180,0050,0630,2300)

SZ2->( dbSetOrder(1) )
SZ2->( dbSeek( xFilial("SZ2")+MV_PAR01 ) )

While ! SZ2->( Eof() ) .AND. SZ2->Z2_CODRDV == MV_PAR01
	
	oPrn:Box(0030,1770,0130,2350)
	oPrn:Say(0030,1370, "Pedido No",oFont14N)
	oPrn:Say(0040,1890,SZ2->Z2_CODRDV,oFont14)
	/*
	dataHora:=Time()
	
	oPrn:Say(0030,2800,dataHora,oFont14N)
	
	oPrn:Box(0180,2350,0630,3350)
	
	oPrn:Say(0200,0100,"Cliente:",oFont12N)
	oPrn:Say(0200,0280,SZ2->Z2_IDRDV,oFont12)
	
	
	oPrn:Say(0200,0480,SZ2->Z2_IDCOLAB,oFont12)
	
	oPrn:Say(0250,0100,"Colaborador:",oFont12N)
	oPrn:Say(0250,0280,SZ2->Z2_COLAB,oFont12)
	*/	
	SZ3->( dbSetOrder(1) )
	SZ3->( dbSeek(xFilial("SZ3")+SZ2->Z2_CODRDV) )
	
	nLin    := 0780
	
	While ! SZ3->(Eof() ) .And. SZ3->Z3_IDRDV == SZ2->Z2_CODRDV
	

		oPrn:Say(nLin,0050,SZ3->Z3_ITEM, oFont08)
		oPrn:Say(nLin,0330,SZ3->Z3_DATA, oFont08)
		/*
	  	oPrn:Say(nLin,1750,SZ3->Z3_CODFORN, oFont08 )
		oPrn:Say(nLin,1930,SZ3->Z3_FORNECE, oFont08 )
		oPrn:Say(nLin,2200,SZ3->Z3_DESCDES, oFont08 )
		oPrn:Say(nLin,2370,Transform(SZ3->Z3_VALOR,"@E 9,999,999.99"  ), oFont08 )
		*/
		nLin+=0050

		SZ3->(dbSkip())

	EndDo

	SZ2->( dbSkip() )
	
EndDo

oPrn:EndPage()

Return( NIL )


Static Function AjustaSX1()

PutSx1(cPerg,"01","No. RDV?"," "," ","mv_ch1","C",10,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe numero do Pedido Vendas"},{"Informe o numero Relat�rios de Despesas de"},{"Informe o Numero do Relat�rios de Despesas"})

Return( NIL )

