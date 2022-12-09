#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "AP5MAIL.CH"                                                                    
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RCOMR03   ³ Autor ³ J.Marcelino Correa    ³ Data ³08.01.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Pedido de Compras - TmsPrinter                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico lisonda                                   		  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCOMR03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿    
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL oDlg := NIL
LOCAL cString	:= "SC7"
PRIVATE titulo 	:= ""
PRIVATE nLastKey:= 0
PRIVATE cPerg	:= "COMR01"
PRIVATE nomeProg:= FunName()
Private nTotal	:= 0
Private nSubTot	:= 0
cDia := SubStr(DtoS(dDataBase),7,2)
cMes := SubStr(DtoS(dDataBase),5,2)
cAno := SubStr(DtoS(dDataBase),1,4)
cMesExt := MesExtenso(Month(dDataBase))
cDataImpressao := cDia+" de "+cMesExt+" de "+cAno     
cLogo     := FisxLogo("1") // mhd
_cValFre := 0
_cVlDesp := 0
_cVlDesc := 0
_cDesc := 0
_cDscObr := ""                   
_cMoeda := ""

PswOrder(1)
PswSeek(__CUSERID,.T.)
aUsuario := PswRet(1)
cComprador := aUsuario[1,2]

AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

dbSelectArea("SC7")
dbSetOrder(1)       
If !dbSeek(xFilial("SC7")+mv_par01)
	Aviso("Pedido NAO Encontrado","Pedido de Compras "+MV_PAR01+" NÃO ENCONTRADO",{"Ok"},1,"Atencao!!!")
	Return
Else
	If SC7->C7_CONAPRO <> "L"
		Aviso("Pedido BLOQUEADO!!!","Necessario Liberar Pedido de Compras antes de imprimi-lo",{"Ok"},1,"Atencao!!!")
		Return
	EndIf
EndIf

If SC7->C7_XFATD = 'S'
	If SC7->C7_XSTATFI <> 'L'
		msgAlert('O pedido de compras não foi liberado pelo departamento financeiro. Solicite aprovação!!!', 'A T E N Ç Ã O')
		Return
	EndIf
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  		³
//³ mv_par01				// Numero Pedido Compras           		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := FunName()            //Nome Default do relatorio em Disco

PRIVATE cTitulo := "Impressão do Pedido de Compras"
PRIVATE oPrn    := NIL
PRIVATE oFont1  := NIL                             
PRIVATE oFont2  := NIL
PRIVATE oFont3  := NIL
PRIVATE oFont4  := NIL
PRIVATE oFont5  := NIL
PRIVATE oFont6  := NIL
Private cPerg := "FATR03"
Private nLastKey := 0
Private nLin := 1650 // Linha de inicio da impressao das clausulas contratuais

DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD OF oPrn
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD OF oPrn
DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 OF oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)


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

oPrn := TMSPrinter():New(cTitulo)
oPrn:Setup()
oPrn:SetPortrait() //SetLansCape()
oPrn:StartPage()
Imprimir()
oPrn:EndPage()
oPrn:End()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o documento customizado:"				OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Pedido de Compras" 						OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL
//@ 70,167 BUTTON "&Grava JPEG"	SIZE 036,012 ACTION SetupW2()  		OF oDlg PIXEL
//@ 49,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
//@ 70,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
oPrn:End()

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIMIR  ¦ Autor ¦ J.Marcelino Correa   ¦ Data ¦08.01.2007¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Pedido de Compras   					          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Grupo TCI                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION Imprimir()

/*dbSelectArea("SC7")
dbSetOrder(01)
If !dbSeek(xFilial("SC7")+mv_par01)
	Aviso("Pedido NAO Encontrado","Pedido de Compras "+MV_PAR01+" NÃO ENCONTRADO",{"Ok"},1,"Atencao!!!")
	Return
Else
	If SC7->C7_CONAPRO <> "L"
		Aviso("Pedido BLOQUEADO!!!","Necessario Liberar Pedido de Compras antes de imprimi-lo",{"Ok"},1,"Atencao!!!")
		Return
	EndIf
EndIf*/


//oPrn := TMSPrinter():New(cTitulo)
//oPrn:Setup()
//oPrn:SetPortrait() //SetLansCape()
//oPrn:StartPage()
PCompra()
//		oPrn:EndPage()
//		oPrn:End()

PAnexo()
oPrn:EndPage()
oPrn:End()

Ms_Flush()
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ Impressao ¦ Autor ¦ J.Marcelino Correa   ¦ Data ¦08.01.2007¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Pedido de Compras						          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Grupo TCI                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION PCompra()

dbSelectArea("SC7")
/*dbSetOrder(01)
If !dbSeek(xFilial("SC7")+mv_par01)
	Aviso("Pedido NAO Encontrado","Pedido de Compras "+MV_PAR01+" NÃO ENCONTRADO",{"Ok"},1,"Atencao!!!")
	Return
Else
	If SC7->C7_CONAPRO <> "L"
		Aviso("Pedido BLOQUEADO!!!","Necessario Liberar Pedido de Compras antes de imprimi-lo",{"Ok"},1,"Atencao!!!")
		Return
	EndIf
EndIf*/

cNome     := SubStr(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME"),1,50)
cCGC      := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_CGC")
cCEP      := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_CEP")
cEnd      := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_END")
cINSCR    := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_INSCR")
cMun      := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_MUN") 
cTel      := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_TEL")  
cContato  := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_CONTATO")    
cFax      := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_FAX")    
cEst      := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EST")
dData	  := Dtoc(SC7->C7_EMISSAO)
cNome := SA2->A2_COD+" - "+cNome
cMun  := AllTrim(cMun)+"   "+AllTrim(cEst)
//PswOrder(1)
//PswSeek(__CUSERID,.T.)
//aUsuario := PswRet(1)
//cComprador := aUsuario[1,2]
//PAnexo()

ntotlin := 0    
_npagina := 1

_cCabec() 

nTotIPI  := 0  
nTotPro := 0
nTotPed  := 0      
nlin := 1140                                                                        


dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+MV_PAR01)

Do While !eof() .And. C7_NUM == MV_PAR01

    //Do while !eof() .and. nTotlin <= 15 .and. C7_NUM == MV_PAR01
    //excluida linha abaixo [Mauro Nagata, Actual Trend, 20170323]
	//Do while !eof() .and. nLin <= 2000 .and. C7_NUM == MV_PAR01
		
		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170323]
		If nLin > 2700
     	   oPrn:EndPage()
   		   _nPagina +=1
		   _cCabec()
   		   nLin := 1140
		   nTotlin := 0     
		Endif                                                         
		//fim bloco [Mauro Nagata, Actual Trend, 20170323]
		
		dbSelectArea("SC7")
		dbSetorder(1)
		lDescDet := .F.
		cDescrPr1 := SC7->C7_DESCRI
    	
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbseek(xfilial("SB1")+SC7->C7_PRODUTO)
		cDescrPr0 := SB1->B1_DESC     //SC7->C7_DESCRI
		dbSelectArea("SC7")

		dbSelectArea("SB5")
		dbSetOrder(01)
		If dbSeek(xFilial("SB5")+SC7->C7_PRODUTO)
			cDescrPr1 := SB5->B5_CEME	
		EndIf

		dbSelectArea("SC1")
		dbSetOrder(01)
		//If dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC) 
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170323]
		If dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC).And..F.
			lDescDet := .T.
			cDescrPr1 := '' //mv_par02 //SubStr(SC1->C1_XDESDT1,001,115)
			cDescrPr2 := ''//SubStr(SC1->C1_XDESDT1,116,095)//+" "+SubStr(SC1->C1_XDESDT2,001,040)
			cDescrPr3 := ''//SubStr(SC1->C1_XDESDT2,001,115)
			cDescrPr4 := ''//SubStr(SC1->C1_XDESDT2,116,095)
		EndIf
		dbSelectArea("SC7")        
		dbSetOrder(1)

		iF SC7->C7_MOEDA == 2
			_cMoeda := "DOLAR"
		Endif	                                                                         

		nTotIPI  := C7_VALIPI + C7_TOTAL   
   		nTotPed  := nTotPed + nTotIPI    		
   		nTotPro   := nTotPro + C7_TOTAL
	 	oPrn:Say(nLin,0070,OemToAnsi(SC7->C7_ITEM),oFont10)  
 		oPrn:Say(nLin,0170,OemToAnsi(SC7->C7_UM),oFont10)  
	    oPrn:Say(nLin,0300,Transform(SC7->C7_QUANT,"@E 9,999,999.99"),oFont10)
    	//If !lDescDet		//  07.05
		//    oPrn:Say(nLin,0590,OemToAnsi(cDescrPr1),oFont08)
		//EndIf
		cProduto0 := AllTrim(SC7->C7_PRODUTO)
    	wFlagPr0 := .F.
	    If Len(AllTrim(cDescrPr0)) < 40
			cProduto0 := AllTrim(SC7->C7_PRODUTO)+"-"+AllTrim(cDescrPr0)
	    	oPrn:Say(nLin,0495,OemToAnsi(cProduto0),oFont08)
		    wFlagPr0 := .T.
		Else
		    oPrn:Say(nLin,0495,OemToAnsi(AllTrim(SC7->C7_PRODUTO)),oFont08)		//	07.05
		EndIf
	  	//oPrn:Say(nLin,1320,Transform(SC7->C7_PRECO,"@E 9,999,999.99"),oFont10)
  		oPrn:Say(nLin,1200,Transform(SC7->C7_PRECO,"@E 999,999.9999"),oFont10)
	  	oPrn:Say(nLin,1480,Transform(SC7->C7_TOTAL,"@E 9,999,999.99"),oFont10 )         
		oPrn:Say(nLin,1730,Transform(nTotIPI,"@E 9,999,999.99"		),oFont10)
	    oPrn:Say(nLin,1940,Transform(SC7->C7_IPI,"@E 99,999.99"		),oFont10 )            
    	oPrn:Say(nLin,2130,OemToAnsi(dtoc(SC7->C7_DATPRF)),oFont12N )            
	    _cValfre := _cvalFre + SC7->C7_VALFRE  // Mhd
	    _cVlDesc := _cVlDesc + SC7->C7_VLDESC
	    _cVlDesp := _cVlDesp + SC7->C7_DESPESA
	    _cDesc := SC7->C7_DESC1
    	
	    nLin+=0050 
	    nTotLin += 1
    	If !wFlagPr0
		    oPrn:Say(nLin,0590,OemToAnsi(cDescrPr0),oFont08)		//	07.05
		    nLin+=0050
		    nTotLin += 1
		EndIf
    	If lDescDet
		   oPrn:Say(nLin,0070,OemToAnsi(cDescrPr1),oFont08) 
		   nLin+=0050
		   If !Empty(cDescrPr2)
			   oPrn:Say(nLin,0070,OemToAnsi(cDescrPr2),oFont08)
			   nLin+=0050
			EndIf
		   If !Empty(cDescrPr3)
			   oPrn:Say(nLin,0070,OemToAnsi(cDescrPr3),oFont08)
			   nLin+=0050
			EndIf
		   If !Empty(cDescrPr4)
			   oPrn:Say(nLin,0070,OemToAnsi(cDescrPr4),oFont08)
			   nLin+=0050
			EndIf
		EndIf    
		nTotlin += 1   
		dbSelectArea("SC7")
		dbSkip()

Enddo  //ntotlin

If nLin < 1950
		cTrace := Replicate("_",115)
		dbSeek(xFilial("SC7")+mv_par01)
		nPerICMS := SC7->C7_PICM
		cDescPagto :=  Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")          
		nVlICM := (nTotPed*nPerICMS)/100
    	
		oPrn:Say(1950,0070,(cTrace),oFont12N)
		oPrn:Say(2000,0070,"Valor Produtos:",oFont12N)
		oPrn:Say(2000,0350,Transform(nTotPro,"@E  9999,999.99"),oFont12N)
		oPrn:Say(2000,1700,"Total c/Impostos:",oFont12N)
		oPrn:Say(2000,2100,Transform(nTotPed,"@E  9999,999.99"),oFont12N)
		oPrn:Say(2050,0070,"Frete:",oFont12N)
		oPrn:Say(2050,0350,Transform(_cValFre,"@E  9999,999.99"),oFont12N)	   
		
		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170323]
		If !Empty(_cVlDesp)
			oPrn:Say(2050,0900,"Despesas:",oFont12N)
			oPrn:Say(2050,1080,Transform(_cVlDesp,"@E  9999,999.99"),oFont12)
		EndIf
		//fim bloco [Mauro Nagata, Actual Trend, 20170323]
		
		oPrn:Say(2050,1700,"Valor Total:",oFont12N)

		ntotped := ntotped + _cValfre - _cVlDesc + _cVlDesp

		oPrn:Say(2050,2100,Transform(nTotPed,"@E  9999,999.99"),oFont12N)    
		oPrn:Say(2100,0070,"Desconto:",oFont12N)
		oPrn:Say(2100,0320,"%    "+Transform(_cDesc,"@E  999.99"),oFont12N)
		oPrn:Say(2100,0450,Transform(_cVlDesc,"@E  9999,999.99"),oFont12N)	
		oPrn:Say(2110,0060,(cTrace),oFont12N)
 		oPrn:Say(2250,0070,"Autorizado pela:  "+SM0->M0_NOMECOM,oFont12N)
		oPrn:Say(2400,0070,"_______/ _______/ _______                              ASSINATURA",oFont12N)
		oPrn:Say(2400,1100,"________________________________",oFont12N)
		oPrn:Say(2450,0060,(cTrace),oFont12N)            
	
        //adicionado para trazer todas observações do pedido de compras   - luiz henrique 17/05/2013            
		oPrn:Say(2500,0070,"Observacoes:",oFont12N)  
		dbSelectArea("SC7")
        dbSetOrder(1)
        dbSeek(xFilial("SC7")+MV_PAR01)
        nlin:=2500  
        Do While !eof().And. C7_NUM == MV_PAR01 
           IF C7_OBS <> ' '
				oPrn:Say(nlin,0330,"item: "+Alltrim(SC7->C7_ITEM)+" - "+Alltrim(SC7->C7_OBS),oFont12N) 
			    nLin+=0050  
			    dbSkip() 
	       ELSE
				dbSkip()     
	       ENDIF
        Enddo
	    oPrn:Say(nlin,0060,(cTrace),oFont12N)   
	    nlin += 0050	

		oPrn:Say(nlin,0070,"Data da Emisssão:",oFont12N)
		oPrn:Say(nlin,0420,OemToAnsi(cDataImpressao),oFont14)  
		oPrn:Say(nlin,1600,"Comprador:",oFont12N)
		oPrn:Say(nlin,1840,(cComprador),oFont14) 
		nlin += 0030
		oPrn:Say(nlin,0060,(cTrace),oFont12N)   
		nlin += 0050                                                                                         
		oPrn:Say(nlin,0060,"*** CONSTAR O NÚMERO DESTE PEDIDO DE COMPRAS NA NOTA FISCAL",oFont14N)
		nlin += 0100
		oPrn:Say(nlin,0060,"=> ENDEREÇO DE COBRANÇA:",oFont14N)     
		nlin += 0050
		//oPrn:Say(nlin,0160,"Estrada da Aldeinha, 618 - Barueri - São Paulo - CEP 06465-100",oFont14)
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20190210]
		oPrn:Say(nlin,0160,AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_COMPCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+" - "+AllTrim(SM0->M0_ESTCOB)+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont14)		
		//fim bloco [Mauro Nagata, Actual Trend, 18/04/2013]
		
		oPrn:EndPage()
Else
	   cTrace := Replicate("_",115)
		dbSeek(xFilial("SC7")+mv_par01)
		nPerICMS := SC7->C7_PICM
		cDescPagto :=  Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")          
		nVlICM := (nTotPed*nPerICMS)/100
		                                                  
		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170323]
		If nLin > 2800
     	   oPrn:EndPage()
   		   _npagina +=1
		   _ccabec()
   		   nlin := 1140
		   ntotlin := 0     
		Endif                                                         
		//fim bloco [Mauro Nagata, Actual Trend, 20170323]
		
		oPrn:Say(nLin,0070,(cTrace),oFont12N)
		nLin += 50
		oPrn:Say(nLin,0070,"Valor Produtos:",oFont12N)
		oPrn:Say(nLin,0350,Transform(nTotPro,"@E  9999,999.99"),oFont12N)
		oPrn:Say(nLin,1700,"Total c/Impostos:",oFont12N)
		oPrn:Say(nLin,1700,"Total c/Impostos:",oFont12N)
		oPrn:Say(nLin,2100,Transform(nTotPed,"@E  9999,999.99"),oFont12N)
		nLin += 50
		oPrn:Say(nLin,0070,"Frete:",oFont12N)
		oPrn:Say(nLin,0350,Transform(_cValFre,"@E  9999,999.99"),oFont12N)	  
		
		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170323]
		If !Empty(_cVlDesp)
			oPrn:Say(nLin,0900,"Despesas:",oFont12N)
			oPrn:Say(nLin,1080,Transform(_cVlDesp,"@E  9999,999.99"),oFont12)
		EndIf		                                                  
		//fim bloco [Mauro Nagata, Actual Trend, 20170323]
		
		
		oPrn:Say(nLin,1700,"Valor Total:",oFont12N)

		ntotped := ntotped + _cValfre - _cVlDesc + _cVlDesp

		oPrn:Say(nLin,2100,Transform(nTotPed,"@E  9999,999.99"),oFont12N)    
		nLin += 50
		oPrn:Say(nLin,0070,"Desconto:",oFont12N)
		oPrn:Say(nLin,0320,"%    "+Transform(_cDesc,"@E  999.99"),oFont12N)
		oPrn:Say(nLin,0450,Transform(_cVlDesc,"@E  9999,999.99"),oFont12N)	
		nLin += 10
		oPrn:Say(nLin,0060,(cTrace),oFont12N)
		
		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170323]
		If nLin > 2800
     	   oPrn:EndPage()
   		   _npagina +=1
		   _ccabec()
   		   nlin := 1140
		   ntotlin := 0     
		Endif                                                         
		//fim bloco [Mauro Nagata, Actual Trend, 20170323]
		
		nLin += 140
		oPrn:Say(nLin,0070,"Autorizado pela :"+SM0->M0_NOMECOM,oFont12N)
		nLin += 150
		oPrn:Say(nLin,0070,"_______/ _______/ _______                              ASSINATURA",oFont12N)
		oPrn:Say(nLin,1050,"________________________________",oFont12N)
		nLin += 50
		oPrn:Say(nLin,0060,(cTrace),oFont12N)            
		nLin += 50
		
		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170323]
		If nLin > 2800
     	   oPrn:EndPage()
   		   _npagina +=1
		   _ccabec()
   		   nlin := 1140
		   ntotlin := 0     
		Endif                                                         
		//fim bloco [Mauro Nagata, Actual Trend, 20170323]
		
		oPrn:Say(nLin,0070,"Observacoes:",oFont12N)  
		dbSelectArea("SC7")
        dbSetOrder(1)
        dbSeek(xFilial("SC7")+MV_PAR01)
        nlin +=50
        Do While !eof().And. C7_NUM == MV_PAR01 
           IF C7_OBS <> ' '
				oPrn:Say(nlin,0330,"item: "+Alltrim(SC7->C7_ITEM)+" - "+Alltrim(SC7->C7_OBS),oFont12N) 
			    nLin+=0050  
			    dbSkip()                                 
			    
			    //incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170323]
				If nLin > 2700
		     	   oPrn:EndPage()
		   		   _npagina +=1
				   _cCabec()
		   		   nLin := 1140
				   nTotlin := 0     
				Endif                                                         
				//fim bloco [Mauro Nagata, Actual Trend, 20170323]
	       ELSE
				dbSkip()     
		   ENDIF
        Enddo
	    oPrn:Say(nlin,0060,(cTrace),oFont12N)   
	    nlin += 0050	         	
		oPrn:Say(nlin,0070,"Data da Emisssão:",oFont12N)
		oPrn:Say(nlin,0420,OemToAnsi(cDataImpressao),oFont14)  
		oPrn:Say(nlin,1600,"Comprador:",oFont12N)
		oPrn:Say(nlin,1840,(cComprador),oFont14) 
		nlin += 0030
		oPrn:Say(nlin,0060,(cTrace),oFont12N)   
		nlin += 0050                                                                                          
		oPrn:Say(nlin,0060,"*** CONSTAR O NÚMERO DESTE PEDIDO DE COMPRAS NA NOTA FISCAL",oFont14N)
		nlin += 0100
		oPrn:Say(nlin,0060,"=> ENDEREÇO DE COBRANÇA:",oFont14N)     
		nlin += 0050
		//oPrn:Say(nlin,0160,"Estrada da Aldeinha, 618 - Barueri - São Paulo - CEP 06465-100",oFont14)
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20190210]
		oPrn:Say(nlin,0160,AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_COMPCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+" - "+AllTrim(SM0->M0_ESTCOB)+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont14)
		//fim bloco [Mauro Nagata, Actual Trend, 18/04/2013]
		
		oPrn:EndPage()
    	
EndIf

Return
                                                                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  J.Marcelino Correa  ³Data³03.06.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cabeçalho do Pedido de Compras                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _cCabec()

oPrn:StartPage()    

If nTotlin <= 15 // Se primeira Vez

	oPrn:Box(0010,0050,0250,2350) 
	oPrn:SayBitmap(0030,0100,cLogo,0400,0090)
	oPrn:Say(0030,0600,SM0->M0_NOMECOM,oFont14N)   
	//oPrn:Say(0100,0100,"End.:"	,oFont12N); 0270
	oPrn:Say(0100,0100,Alltrim(SM0->M0_ENDENT),oFont12N)	//0270
	oPrn:Say(0100,0800,"CEP: ",oFont12N)
	oPrn:Say(0100,1000,Alltrim(SM0->M0_CEPENT),oFont12N)
	oPrn:Say(0100,1250,Alltrim(SM0->M0_CIDENT),oFont12N)
	oPrn:Say(0100,1800,Alltrim(SM0->M0_ESTENT),oFont12N)
	oPrn:Say(0150,0100,"CNPJ    :",oFont12N)     
	oPrn:Say(0150,0320,Transform(Alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99"),oFont12N)
	oPrn:Say(0150,0800,"Insc. Est. : ",oFont12N)
	oPrn:Say(0150,1000,Transform(Alltrim(SM0->M0_INSC),"@R 999.999.999.999"),oFont12N)   
	oPrn:Say(0200,0100,"Fone/Fax:"		,oFont12N)
	oPrn:Say(0200,0320,SM0->M0_TEL	,oFont12N)
	//oPrn:Say(0150,1000,"Cep: 07242-100",oFont12N)
	oPrn:Say(0200,0800,"Data Emissão:",oFont12N)   
	oPrn:Say(0200,1100,OemToAnsi(dtoc(ddatabase))	,oFont12N)
	oPrn:Say(0200,1800,"Página: ",oFont12N)   
	oPrn:Say(0200,1950,str(_nPagina),oFont12N)
	
	oPrn:Box(0300,0050,0400,2350) 
	oPrn:Say(0330,0450,"*** Pedido de Compra No:",oFont14N)
	oPrn:Say(0330,1150,OemToAnsi(mv_par01)	 ,oFont16N)
	oPrn:Say(0330,1200,OemToAnsi(_cMoeda)	 ,oFont14N)

	//oPrn:Say(0330,1800,"STATUS:  APROVADO"	 ,oFont14N)

	oPrn:Box(0450,0050,0720,2350) 
	oPrn:Say(0470,0100,"Fornecedor:",oFont12N)
	oPrn:Say(0470,0380,cNome,oFont12N)
	oPrn:Say(0470,1850,"CNPJ:",oFont12N) 			//1550
	oPrn:Say(0470,2000,Transform(Alltrim(cCGC),"@R 99.999.999/9999-99"),oFont12N)		// 1700
	//oPrn:Say(0500,1250,"Inscr",oFont12N)
	//oPrn:Say(0500,1500,cINSCR,oFont12N)
	oPrn:Say(0520,0100,"Endereço   :",oFont12N) 
	oPrn:Say(0520,0380,cEnd,oFont12N)
	oPrn:Say(0570,0100,"Cidade       :",oFont12N)  
	oPrn:Say(0570,0380,cMun,oFont12N)
	//oPrn:Say(0570,0580,cEst,oFont12N)
	oPrn:Say(0570,1250,"CEP:",oFont12N)  
	oPrn:Say(0570,1350,cCEP,oFont12N)
	oPrn:Say(0620,0100,"Vendedor   :",oFont12N)  
	oPrn:Say(0620,0380,cContato,oFont12N)
	oPrn:Say(0620,1250,"Telefone:",oFont12N)  
	oPrn:Say(0620,1500,cTel,oFont12N)
                    
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+MV_PAR01)

	dbSelectArea("SC1")
	dbSetOrder(1)
	dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)

	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+SC7->C7_COND)
	// cCondPgto := SC7->C7_COND+" - "+SE4->E4_DESCRI  //  Retirado por Cintia Aquino em 15/12
	cCondPgto := SE4->E4_DESCRI
	dbSelectArea("SC7")

	oPrn:Say(0670,0100,"Cond.Pagto:",oFont12N)  
	oPrn:Say(0670,0380,OemToAnsi(cCondPgto),oFont12N)

	oPrn:Box(0750,0050,0970,2350) 
	oPrn:Say(0780,0100,"Local de Entrega: ",oFont12N)
	//oPrn:Say(0780,0400,OemToAnsi(mv_par02),oFont08N)  
	oPrn:Say(0780,0410,OemToAnsi(mv_par02),oFont12)  
	oPrn:Say(0850,0100,"Obra:",oFont12N)
	//oPrn:Say(0850,0250,OemToAnsi(SC7->C7_CC),oFont08N)  
	oPrn:Say(0850,0410,OemToAnsi(SC7->C7_CC),oFont12)  
	dbSelectArea("CTT")
	DbSetorder(1)
	DbSeek(xfilial("CTT")+SC7->C7_CC)
	_cDscObr := CTT->CTT_DESC01               
	//oPrn:Say(0850,0400,"- "+OemToAnsi(_cDscObr),oFont08N)
	oPrn:Say(0850,0560,"- "+OemToAnsi(_cDscObr),oFont12)
	
	dbSelectArea("SC7")

	oPrn:Say(0910,0100,"Tipo de Frete:",oFont12N)
	If SC7->C7_TPFRETE == "F"
   	//oPrn:Say(0910,0380,"FOB",oFont10N)
   	oPrn:Say(0910,0410,"FOB",oFont10N)
	Else
		//oPrn:Say(0910,0380,"CIF",oFont10N)
		oPrn:Say(0910,0410,"CIF",oFont10N)
	EndIf

	oPrn:Box(1020,0050,1100,2350)     
    
    oPrn:Say(1050,0070,"Item  Unid   Quantidade   Descricao do Produto                           Preco Unitario        Preco Total          Preco+IPI      IPI        Dt.Entrega",oFont12N)
    
Else

	oPrn:Box(0010,0050,0250,2350) 
	oPrn:SayBitmap(0030,0100,cLogo,0400,0090)
	oPrn:Say(0030,0600,SM0->M0_NOMECOM,oFont14N)   
	oPrn:Say(0100,0100,Alltrim(SM0->M0_ENDENT),oFont12N)	//0270
	oPrn:Say(0100,0800,"CEP: ",oFont12N)
	oPrn:Say(0100,1000,Alltrim(SM0->M0_CEPENT),oFont12N)
	oPrn:Say(0100,1250,Alltrim(SM0->M0_CIDENT),oFont12N)
	oPrn:Say(0100,1800,Alltrim(SM0->M0_ESTENT),oFont12N)
	oPrn:Say(0150,0100,"CNPJ    :",oFont12N)     
	oPrn:Say(0150,0320,Transform(Alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99"),oFont12N)
	oPrn:Say(0150,0800,"Insc. Est. : ",oFont12N)
	oPrn:Say(0150,1000,Transform(Alltrim(SM0->M0_INSC),"@R 999.999.999.999"),oFont12N)   
	oPrn:Say(0200,0100,"Fone/Fax:"		,oFont12N)
	oPrn:Say(0200,0320,SM0->M0_TEL	,oFont12N)
	oPrn:Say(0200,0800,"Data Emissão:",oFont12N)   
	oPrn:Say(0200,1100,OemToAnsi(dtoc(ddatabase	)),oFont12N)
	oPrn:Say(0200,1800,"Página: ",oFont12N)                        
   	oPrn:Say(0200,1950,Str(_nPagina),oFont12N)

	oPrn:Box(0300,0050,0400,2350) 
	oPrn:Say(0330,0500,"Pedido de Compra No:",oFont14N)
	oPrn:Say(0330,1080,OemToAnsi(mv_par01)	 ,oFont14N)                           
	oPrn:Say(0330,1200,OemToAnsi(_cMoeda)	 ,oFont14N)
                                                                         
	oPrn:Box(0450,0050,0720,2350) 
	oPrn:Say(0470,0100,"Fornecedor:",oFont12N)
	oPrn:Say(0470,0380,cNome,oFont12N)
	oPrn:Say(0470,1850,"CNPJ:",oFont12N) 			//1550
	oPrn:Say(0470,2000,Transform(Alltrim(cCGC),"@R 99.999.999/9999-99"),oFont12N)		// 1700
	oPrn:Say(0520,0100,"Endereço   :",oFont12N) 
	oPrn:Say(0520,0380,cEnd,oFont12N)
	oPrn:Say(0570,0100,"Cidade      :",oFont12N)  
	oPrn:Say(0570,0380,cMun,oFont12N)
	oPrn:Say(0570,1250,"CEP:",oFont12N)  
	oPrn:Say(0570,1350,cCEP,oFont12N)
	oPrn:Say(0620,0100,"Vendedor   :",oFont12N)  
	oPrn:Say(0620,0380,cContato,oFont12N)
	oPrn:Say(0620,1250,"Telefone:",oFont12N)  
	oPrn:Say(0620,1500,cTel,oFont12N)
    dbSelectArea("SC1")                                                                                        
	dbSetOrder(1)
	dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)

	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+SC7->C7_COND)
	//  cCondPgto := SC7->C7_COND+" - "+SE4->E4_DESCRI      //  Retirado por Cintia Aquino em 15/12
	cCondPgto := SE4->E4_DESCRI
	dbSelectArea("SC7")
                
	oPrn:Say(0670,0100,"Cond.Pagto:",oFont12N)  
	oPrn:Say(0670,0380,OemToAnsi(cCondPgto),oFont12N)

	oPrn:Box(0750,0050,0970,2350) 
	oPrn:Say(0780,0100,"Local de Entrega: ",oFont12N)
	//oPrn:Say(0780,0400,OemToAnsi(mv_par02),oFont08N)  
	oPrn:Say(0780,0410,OemToAnsi(mv_par02),oFont12)  
	oPrn:Say(0850,0100,"Obra:",oFont12N)
	//oPrn:Say(0850,0250,OemToAnsi(SC7->C7_CC),oFont08N)  
	oPrn:Say(0850,0410,OemToAnsi(SC7->C7_CC),oFont12)  
	
	dbSelectArea("CTT")
	DbSetorder(1)
	DbSeek(xfilial("CTT")+SC7->C7_CC)
	_cDscObr := CTT->CTT_DESC01               
	//oPrn:Say(0850,0400,"- "+OemToAnsi(_cDscObr),oFont08N)
	oPrn:Say(0850,0560,"- "+OemToAnsi(_cDscObr),oFont12)
	dbSelectArea("SC7")

	oPrn:Say(0910,0100,"Tipo de Frete:",oFont12N)
	If SC7->C7_TPFRETE == "F"
	oPrn:Say(0910,0380,"FOB",oFont10N)
	Else
		oPrn:Say(0910,0380,"CIF",oFont10N)
	EndIf

	oPrn:Box(1020,0050,1100,2350) 
	oPrn:Say(1050,0070,"Item  Unid   Quantidade   Descricao do Produto                           Preco Unitario        Preco Total          Preco+IPI      IPI        Dt.Entrega",oFont12N)

Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  J.Marcelino Correa  ³Data³03.06.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","No Pedido Compras               ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o numero do Orcamento"},{"Informe o numero do Pedido de Compras de"},{"Informe o Numero do Pedido de Compras de"})
PutSx1(cPerg,"02","Local Entrega                        ?"," "," ","mv_ch2","C",40,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Local Entrega"},{"Local Entrega"},{"Local Entrega"})
RestArea(aArea)

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ SETUPW    ¦ Autor ¦ J.Marcelino Correa   ¦ Data ¦03606.2005¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Grava arquivo JPG								          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ 			                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION SETUPW()

Private aUsuario    := "", oDlgMail, nOp:=0
Private cFrom       := ""
Private cServer     := AllTrim(GetNewPar("MV_RELSERV"," ")) // "mailhost.average.com.br" //Space(50)
Private cAccount    := AllTrim(GetNewPar("MV_RELACNT"," ")) //Space(50)
Private cPassword   := AllTrim(GetNewPar("MV_RELPSW" ," ")) //Space(50)
Private lRelauth 	:= GetMv("MV_RELAUTH")					// Parametro que indica se existe autenticacao no e-mail
Private cToo        := space(200)
Private cCC         := space(200)
Private cSubject    := space(250)

lenvmail:=.T.
titulo:="Orcamento Comercial"
lOk   := .T.
cDiretorio := AllTrim(GetNewPar("MV_RELT"," "))
If EMPTY(cDiretorio)
	cDiretorio := "\SYSTEM\"
EndIf

oPrn:Preview()  												// Visualiza antes de imprimir
oPrn:SaveAllAsJpeg("\WORKFLOW\PEDIDO",2400,3600,1800)

//PswOrder(1)
//PswSeek(__CUSERID,.T.)
//aUsuario := PswRet(1)
//cCC := cFrom := AllTrim(aUsuario[1,14])
//cFrom := "ultrak@ultrak.com.br"
cFrom := "ultrak@ultrak.com.br"
cSubject := "Orçamento"
  
DEFINE MSDIALOG oDlgMail OF oMainWnd FROM 0,0 TO 200,544 PIXEL TITLE "Escolha e-Mail"
  
	@ 5,4  To 079,268   OF oDlgMail PIXEL
	@ 18,8  Say "De: "   	Size 12,8           OF oDlgMail PIXEL
	@ 33,8  Say "Para:"  	Size 16,8           OF oDlgMail PIXEL
	@ 48,8  Say "Assunto:" 	Size 21,8           OF oDlgMail PIXEL

	@ 18,33  MSGet cFrom    Size 233,10  		OF oDlgMail PIXEL 
	@ 33,33  MSGet cToo     Size 233,10         OF oDlgMail PIXEL
	@ 48,33  MSGet cSubject Size 233,10         OF oDlgMail PIXEL

DEFINE SBUTTON FROM 85,100 TYPE 1 ACTION (If(!Empty(cToo),If(oDlgMail:End(),nOp:=1,),"Help")) ENABLE OF oDlgMail PIXEL
DEFINE SBUTTON FROM 85,140 TYPE 2 ACTION (oDlgMail:End()) ENABLE OF oDlgMail PIXEL
  
ACTIVATE MSDIALOG oDlgMail CENTERED

cFrom:=AllTrim(cFRom)
cToo:=AllTrim(cToo)
cCC:=AllTrim(cCC)
cSubject:=AllTrim(cSubject)

oProcess:=TWFProcess():New( "000001", "Orçamento Comercial" )
oProcess:NewVersion(.T.)
oProcess:NewTask( "Envio Orçamento", "\workflow\ORCCOM.htm" )
oHTML:=oProcess:oHTML
_cNumOrc:=mv_par01
oHTML:ValByName("ORCCOM",mv_par01)
oProcess:cSubject := "Ultrak Orçamento "+mv_par01
oProcess:cto:=cToo										// := "mcjose@microsiga.com.br"
//oProcess:AttachFile("\WorkFlow\ORC_COM_PAG1.JPG")
//oProcess:Start()
//cAttach := "\WorkFlow\ORC"+mv_Par01+".PDF"
//If !File(cAttach)
//	Aviso("Orcamento.PDF","Documento ORCAMENTO "+MV_PAR01+" .PDF NÃO ENCONTRADO: SALVAR NO DIRETORIO WORKFLOW",{"Ok"},1,"Atencao")
//	Return
//Endif
	//oProcess:AttachFile(cAttach)
	//oProcess:Start()
cAttach := "\WorkFlow\ORCCOM"+mv_Par01+".PDF"
If !File(cAttach)
	Aviso("Orçamento Nao Encontrado","Documento ORCCOM "+MV_PAR01+" .PDF NÃO ENCONTRADO: SALVAR NO DIRETORIO WORKFLOW",{"Ok"},1,"Atencao")
	Return
Endif
oProcess:AttachFile(cAttach)
oProcess:Start()


/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ Impressao ¦ Autor ¦ J.Marcelino Correa   ¦ Data ¦17.01.2007¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Anexo ao Pedido de Compras				          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Grupo TCI                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static FUNCTION PAnexo()

oPrn:StartPage()    
oPrn:Box(0080,0050,2800,2350) 
oPrn:Box(0200,0070,0300,2320) 

oPrn:Say(0230,0600,"Anexo ao Pedido de Compra No: ",oFont14N)
oPrn:Say(0230,1420,OemToAnsi(mv_par01)	 ,oFont14N)

oPrn:Say(0350,0070,"HORÁRIOS DE RECEBIMENTO:",oFont14N)
oPrn:Say(0440,0070,"SEGUNDA À SEXTA – DAS 09:00h ÀS 11:00h e DAS 13:30h ÀS 16:00h",oFont12N)
oPrn:Say(0490,0070,"Nota : Caso esta regra não seja cumprida, reservamo-nos o direito de não proceder com o recebimento .",oFont12N)

oPrn:Say(0600,0070,"ACORDOS DE FORNECIMENTO:",oFont14N)
oPrn:Say(0700,0070,"1. O número do PEDIDO DE COMPRA deverá constar obrigatoriamente na Nota Fiscal de Venda, Serviço ou Simples Remessa,",oFont12N)
oPrn:Say(0750,0070,"   caso contrário reservamo-nos o direito de não receber a mercadoria no ato do recebimento e em casos de Notas Fiscais",oFont12N)
oPrn:Say(0800,0070,"   de Serviço, a mesma será devolvida sem o respectivo aceite ao fornecedor imediatamente.",oFont12N)

oPrn:Say(0900,0070,"2. O FORNECEDOR declara expressamente ser firma ou empresa legalmente constituída e habilitada para a fabricação e/ou",oFont12N)
oPrn:Say(0950,0070,"   comercialização  dos materiais, equipamentos, prestação de serviços, etc. objetos neste instrumento, responsabilizando-se ",oFont12N)
oPrn:Say(1000,0070,"   inteiramente, com total isenção da COMPRADORA, pelas suas atividades decorrentes das obrigações ",oFont12N)
oPrn:Say(1050,0070,"   aqui assumidas,bem como por quaisquer eventuais demandas, reclamações processos, danos, custos, encargos e despesas",oFont12N)
oPrn:Say(1100,0070,"   que resultem ou sejam contraídas pelo FORNECEDOR, em razão de violação de patentes de invenção, projetos,",oFont12N)
oPrn:Say(1150,0070,"   marcas ou nomes registrados, direitos autorais ou demais direitos salvaguardos de terceiros.",oFont12N)

oPrn:Say(1250,0070,"3. É vedada a transferência deste PEDIDO DE COMPRA bem como dos direitos e obrigações dele decorrentes, tanto para terceiros",oFont12N)
oPrn:Say(1300,0070,"   como para empresas coligadas ou do mesmo grupo, sem prévia autorização da COMPRADORA, por escrito",oFont12N)
oPrn:Say(1350,0070,"   sob pena de rescisão deste instrumento.",oFont12N)

oPrn:Say(1450,0070,"4. O FORNECEDOR, quando solicitado pela COMPRADORA, obriga-se a entregar, juntamente com o material, os respectivos",oFont12N)
oPrn:Say(1500,0070,"   certificados de garantia, de análise ou de composição e/ou qualidade do material",oFont12N)
oPrn:Say(1550,0070,"   empregado na fabricação do equipamento, da peça, etc. ",oFont12N)
oPrn:Say(1650,0070,"   Esta regra valerá também para prestações de serviços.",oFont12N)

oPrn:Say(1750,0070,"5. O presente PEDIDO DE COMPRA poderá ser considerado rescindido de pleno direito pela COMPRADORA, sem que",oFont12N)
oPrn:Say(1800,0070,"   isso implique responsabilidade de nenhuma natureza, independente de interpelação judicial",oFont12N)
oPrn:Say(1850,0070,"   ou notificação judicial ou extra-judicial, nas seguintes hipóteses:",oFont12N)
oPrn:Say(1900,0070,"* ocorrência de motivos de força maior, nos termos do Código Civil;",oFont12N)
oPrn:Say(1950,0070,"* se ficar provado, a qualquer momento, que o FORNECEDOR não iniciou em tempo hábil",oFont12N)
oPrn:Say(2000,0070,"  a execução do PEDIDO DE COMPRA ou deixou de tomar as medidas necessárias ao seu exato",oFont12N)
oPrn:Say(2050,0070,"  cumprimento no que tange as especificações da mercadoria e/ou serviços à serem prestados,",oFont12N)
oPrn:Say(2100,0070,"  prazos de entregas e demais condições estabelecidas;",oFont12N)
oPrn:Say(2150,0070,"* na hipótese de falência, concordata, dissolução do FORNECEDOR ou caso ele venha a ser declarado insolvente;",oFont12N)
oPrn:Say(2200,0070,"* se o FORNECEDOR infringir qualquer cláusula ou condição deste PEDIDO DE COMPRA, especialmente",oFont12N)
oPrn:Say(2250,0070,"  pelo não fornecimento da mercadoria e/ou prestação do serviço acordado, ",oFont12N)
oPrn:Say(2300,0070,"  por deficiência técnica, a sucessivas devoluções de mercadorias, etc.",oFont12N)
oPrn:Say(2350,0070,"* na hipótese de a COMPRADORA tomar conhecimento de fatos ou circunstâncias que desabonem a idoneidade comercial",oFont12N)
oPrn:Say(2400,0070,"  do FORNECEDOR ou comprometam sua capacidade econômica-financeira, técnica ou de produção .",oFont12N)

oPrn:Say(2700,0070,"Data da Emisssão:",oFont12N)
oPrn:Say(2700,0420,OemToAnsi(cDataImpressao),oFont10)  
oPrn:Say(2700,1350,"Comprador:",oFont12N)
oPrn:Say(2700,1600,(cComprador),oFont10)

//oPrn:EndPage()

Return (.T.)



STATIC FUNCTION SETUPW2()

oPrn:Preview()  												// Visualiza antes de imprimir
oPrn:SaveAllAsJpeg("\WORKFLOW\PEDIDO",2400,3600,1800)

Return

