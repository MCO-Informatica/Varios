#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE TOTPED     001
#DEFINE TOTVEN     002
#DEFINE TOTEST     003
#DEFINE TOTGRU     004
#DEFINE TOTPRD     005
#DEFINE TOTOPC     006

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Vendas3 ³ Autor ³ Luiz Alberto V Alves ³ Data ³ Janeiro/2015±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Vendas Cliente Primeira Compra ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Metalacre                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RelVend3()
Local cDescri       := " "
LOCAL cString		:= "SD2"
Local titulo 		:= ""
LOCAL wnrel		 	:= "RVND3"
LOCAL cDesc1	    := "Relatório de Vendas Clientes Abertos Primeira Compra"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico Metalacre"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("RVND3",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "RVND3"
PRIVATE lEnd        := .F.
PRIVATE nLastKey	:= 0
PRIVATE nBegin		:= 0
PRIVATE nDifColCC   := 0
PRIVATE aLinha		:= {}
PRIVATE aSenhas		:= {}
PRIVATE aUsuarios	:= {}
PRIVATE M_PAG	    := 1
Private lEnd        := .F.
Private oPrint
PRIVATE nSalto      := 50
PRIVATE lFirstPage  := .T.
Private oBrush  := TBrush():NEW("",CLR_HGRAY)          
Private oBrushG  := TBrush():NEW("",CLR_YELLOW)          
Private oPen		:= TPen():New(0,5,CLR_BLACK)
PRIVATE oCouNew08	:= TFont():New("Courier New"	,08,08,,.F.,,,,.T.,.F.)
PRIVATE oCouNew08N	:= TFont():New("Courier New"	,08,08,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
PRIVATE oCouNew09N	:= TFont():New("Courier New"	,09,09,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
PRIVATE oCouNew10N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew12N	:= TFont():New("Courier New"	,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11N	:= TFont():New("Courier New"	,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11 	:= TFont():New("Courier New"	,11,11,,.F.,,,,.T.,.F.)                 
PRIVATE oArial08N	:= TFont():New("Arial"			,08,08,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial09N	:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial10N	:= TFont():New("Arial"			,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial11N	:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial12N	:= TFont():New("Arial"			,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial14N	:= TFont():New("Arial"			,14,14,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew12S	:= TFont():New("Courier New",12,12,,.T.,,,,.F.,.F.)		// SubLinhado
PRIVATE cContato    := ""
PRIVATE cNomFor     := ""
Private nReg 			:= 0


AjustaSx1(cPerg)
Pergunte(cPerg,.f.)
//IF ! Pergunte(cPerg,.T.)
//	Return
//Endif

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio de Clientes Abertos Primeira Compra")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(cDesc1)
@ 030,020 SAY OemToAnsi(cDesc2)
@ 045,020 SAY OemToAnsi(cDesc3)
@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)

@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )
ACTIVATE DIALOG oDlg CENTERED



IF nOpcRel == 1 
	Processa({ |lEnd| RVND_1CFG("Impressao Relatório de Clientes Abertos Primeira Compra")},"Imprimindo , aguarde...")
	Processa({|lEnd| RVND_1REL(@lEnd,wnRel,cString,nReg)},titulo)
Else
	Return .f.
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³COMR01Cfg ³ Autor ³ Luiz Alberto    ³ Data ³20/02/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria os objetos para relat. grafico.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RVND_1CFG(Titulo)
Local cFilename := 'RelVnd3'
Local i 	 := 1
Local x 	 := 0

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetPaperSize(DMPAPER_A4) 
oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF 
cDiretorio := oPrint:cPathPDF

If	MAKEDIR('C:\TEMP')!= 0
	//		Aviso(STR0001,STR0026+cPathOri+STR0027,{"OK"}) //"Inconsistencia"###"Nao foi possivel criar diretorio "###".Finalizando ..."
	return nil
EndIf
  
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Luiz Alberto     ³ Data ³ 20.02.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110	    		                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RVND_1REL(lEnd,WnRel,cString,nReg)
Private cCGCPict, cCepPict

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQueryCad := "	SELECT A1_VEND, A3_NREDUZ, A1_EST, A1_PRICOM, A1_CGC, A1_COD, A1_LOJA, A1_NOME, B1_GRUPO, B1_COD, B1_DESC, D2_DOC, D2_QUANT, D2_PRCVEN, D2_TOTAL   FROM " + RetSqlName("SA1") + " SA1   "
cQueryCad += "  INNER JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD = A1_VEND AND SA3.D_E_L_E_T_ = '' AND A3_FILIAL = '" + xFilial("SA3") + "' AND A3_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " 
cQueryCad += "  INNER JOIN " + RetSqlName("SD2") + " SD2 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND D2_EMISSAO = A1_PRICOM AND SD2.D_E_L_E_T_ = '' AND SD2.D2_COD BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
cQueryCad += "  INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = D2_COD AND B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' AND SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
cQueryCad += "  WHERE A1_PRICOM BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'    "
cQueryCad += "  AND A1_FILIAL = '" + xFilial("SA1") + "' "
cQueryCad += "  AND A1_EST BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQueryCad += "  AND B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQueryCad += "  AND B1_COD BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
cQueryCad += "  AND A1_IDCWEB = ''    "
cQueryCad += "  AND SA1.D_E_L_E_T_ = ''    "
cQueryCad += "  AND A1_PESSOA = 'J'    "
cQueryCad += "  ORDER BY A1_VEND, A3_NREDUZ, A1_CGC, A1_COD, A1_LOJA, A1_NOME, A1_EST, A1_PRICOM, B1_GRUPO, B1_COD, B1_DESC, D2_DOC, D2_QUANT, D2_PRCVEN, D2_TOTAL "

TCQUERY cQueryCad NEW ALIAS "CADTMP"

TcSetField('CADTMP','A1_PRICOM','D')

Count To nReg

CADTMP->(dbGoTop())

If Empty(nReg)	
	MsgAlert("Atenção Não Foram Encontrados Dados no Filtro Gerado !","Atenção !")
	CADTMP->(dbCloseArea())
	Return .f.
Endif 

li       := 5000
nPg		  := 0

//C5_NUM, A1_VEND, A1_EST, B1_GRUPO, B1_COD, C6_OPC, C5_EMISSAO "
aTotais	:= {{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0}}

aGeral	:= {{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0},;
			{0,0,0,0}}

aResEst := {}
aResGru := {}
aResOpc := {}
aResMid := {}

aRstVnd := {}
aRstEst := {}
aRstGru := {}
aRstOpc := {}
aRstMid := {}
nVenCli := 0
nTotCli := 0
			
ProcRegua(nReg,"Aguarde a Impressao")
While CADTMP->(!Eof())                           
	IncProc()

	If SUS->(dbSetorder(5), dbSeek(xFilial("SUS")+CADTMP->A1_COD+CADTMP->A1_LOJA))
		If !(SUS->US_MIDIA >= MV_PAR11 .And. SUS->US_MIDIA <= MV_PAR12)
			CADTMP->(dbSkip(1));Loop
		Endif
	Endif

	cVended := CADTMP->A1_VEND
	cEstado := CADTMP->A1_EST
	cGrupo  := CADTMP->B1_GRUPO
	cProduto:= CADTMP->B1_COD
	cCliente:= Left(CADTMP->A1_CGC,8)+CADTMP->A1_COD+CADTMP->A1_LOJA

	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVended))
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+CADTMP->B1_COD))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se havera salto de formulario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 2700
		If Li <> 5000
			oPrint:EndPage()
		Endif		
	
		nPg++
		ImpCabec()                                                                     
	Endif

	If lEnd
		oPrint:Say(Li,030,"CANCELADO PELO OPERADOR",oArial12N)
		Goto Bottom
		Exit
	Endif
			
	oPrint:Say(li,0040,CADTMP->A1_COD+'/'+CADTMP->A1_LOJA,oArial08N)
	oPrint:Say(li,0200,CADTMP->A1_NOME,oArial08N)
	oPrint:Say(li,0800,DtoC(CADTMP->A1_PRICOM),oArial08N)
	oPrint:Say(li,1000,AchEstado(CADTMP->A1_EST),oArial08N)
	oPrint:Say(li,1500,SUS->US_MIDIA + ' - ' + Posicione("SUH",1,xFilial("SUH")+SUS->US_MIDIA,"UH_DESC"),oArial08N)
	oPrint:Say(li,2000,SUS->US_INDCLI+'/'+SUS->US_INDLOJ,oArial08N)
	li+=50
	
	nTotCli++
	nQtdCli := 0
	nVlrCli := 0
	nVenCli++
	
	nItem := 1
	While CADTMP->(!Eof()) .And. cCliente == Left(CADTMP->A1_CGC,8)+CADTMP->A1_COD+CADTMP->A1_LOJA
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se havera salto de formulario                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If li > 2700
			If Li <> 5000
				oPrint:EndPage()
			Endif		
		
			nPg++
			ImpCabec()                                                                     
		Endif
	
		aTotais[TOTPED,1]++
		aTotais[TOTVEN,1]++
		aTotais[TOTEST,1]++
		aGeral[TOTPED,1]++
		aGeral[TOTVEN,1]++
		aGeral[TOTEST,1]++
		
		oPrint:Say(li,0300,CADTMP->D2_DOC,oArial08N)
		oPrint:Say(li,0500,CADTMP->B1_GRUPO,oArial08N)
		oPrint:Say(li,0650,CADTMP->B1_COD,oArial08N)
		oPrint:Say(li,0800,CADTMP->B1_DESC,oArial08N)
		oPrint:Say(li,1500,TransForm(CADTMP->D2_QUANT,"9999999"),oArial09N,,,,1)
		oPrint:Say(li,1800,TransForm(CADTMP->D2_PRCVEN,"@E 99,999,999.99"),oArial09N,,,,1)
		oPrint:Say(li,2000,TransForm(CADTMP->D2_TOTAL,"@E 99,999,999.99"),oArial09N,,,,1)

		aTotais[TOTPED,2]+=CADTMP->D2_QUANT
		aTotais[TOTPED,3]+=CADTMP->D2_TOTAL
		
		aTotais[TOTVEN,2]+=CADTMP->D2_QUANT
		aTotais[TOTVEN,3]+=CADTMP->D2_TOTAL
		
		aTotais[TOTEST,2]+=CADTMP->D2_QUANT
		aTotais[TOTEST,3]+=CADTMP->D2_TOTAL
		
		aTotais[TOTGRU,1]++
		aTotais[TOTGRU,2]+=CADTMP->D2_QUANT
		aTotais[TOTGRU,3]+=CADTMP->D2_TOTAL
		
		aTotais[TOTPRD,1]++
		aTotais[TOTPRD,2]+=CADTMP->D2_QUANT
		aTotais[TOTPRD,3]+=CADTMP->D2_TOTAL
	
		aTotais[TOTOPC,1]++
		aTotais[TOTOPC,2]+=CADTMP->D2_QUANT
		aTotais[TOTOPC,3]+=CADTMP->D2_TOTAL
		
		aGeral[TOTPED,2]+=CADTMP->D2_QUANT
		aGeral[TOTPED,3]+=CADTMP->D2_TOTAL
		
		aGeral[TOTVEN,2]+=CADTMP->D2_QUANT
		aGeral[TOTVEN,3]+=CADTMP->D2_TOTAL
	
		aGeral[TOTEST,2]+=CADTMP->D2_QUANT
		aGeral[TOTEST,3]+=CADTMP->D2_TOTAL
	
		aGeral[TOTGRU,1]++
		aGeral[TOTGRU,2]+=CADTMP->D2_QUANT
		aGeral[TOTGRU,3]+=CADTMP->D2_TOTAL
		
		aGeral[TOTPRD,1]++
		aGeral[TOTPRD,2]+=CADTMP->D2_QUANT
		aGeral[TOTPRD,3]+=CADTMP->D2_TOTAL
		
		aGeral[TOTOPC,1]++
		aGeral[TOTOPC,2]+=CADTMP->D2_QUANT
		aGeral[TOTOPC,3]+=CADTMP->D2_TOTAL
		
		li+=50
			
		// Resumo Por Vendedor + Estado
		
		nAchou := Ascan(aResEst,{|x| x[1]+x[2] == CADTMP->A1_VEND+CADTMP->A1_EST })
		If Empty(nAchou)
			AAdd(aResEst,{	CADTMP->A1_VEND,;
							CADTMP->A1_EST,;
							1,;           
							CADTMP->D2_QUANT,;
							CADTMP->D2_TOTAL})
		Else
			If nItem == 1
				aResEst[nAchou,3]++
			Endif
			aResEst[nAchou,4]+=CADTMP->D2_QUANT
			aResEst[nAchou,5]+=CADTMP->D2_TOTAL
		Endif

		// Resumo Por Vendedor + Midia
		
		nAchou := Ascan(aResMid,{|x| x[1]+x[2] == CADTMP->A1_VEND+SUS->US_MIDIA })
		If Empty(nAchou)
			AAdd(aResMid,{	CADTMP->A1_VEND,;
							SUS->US_MIDIA,;
							1,;           
							CADTMP->D2_QUANT,;
							CADTMP->D2_TOTAL,;
							Posicione("SUH",1,xFilial("SUH")+SUS->US_MIDIA,"UH_DESC")})
		Else
			If nItem == 1
				aResMid[nAchou,3]++
			Endif
			aResMid[nAchou,4]+=CADTMP->D2_QUANT
			aResMid[nAchou,5]+=CADTMP->D2_TOTAL
		Endif

		// Resumo por Vendedor + Grupo
	
		nAchou := Ascan(aResGru,{|x| x[1]+x[2] == CADTMP->A1_VEND+CADTMP->B1_GRUPO })
		If Empty(nAchou)
			AAdd(aResGru,{	CADTMP->A1_VEND,;
							CADTMP->B1_GRUPO,;
							1,;           
							CADTMP->D2_QUANT,;
							CADTMP->D2_TOTAL})
		Else
			If nItem == 1
				aResGru[nAchou,3]++
			Endif
			aResGru[nAchou,4]+=CADTMP->D2_QUANT
			aResGru[nAchou,5]+=CADTMP->D2_TOTAL
		Endif
							
		// Resumo Total
	
		// Resumo Por Vendedor
	
		nAchou := Ascan(aRstVnd,{|x| x[1] == CADTMP->A1_VEND })
		If Empty(nAchou)
			AAdd(aRstVnd,{	CADTMP->A1_VEND,;
							SA3->A3_NREDUZ,;
							nVenCli,;           
							CADTMP->D2_QUANT,;
							CADTMP->D2_TOTAL})
		Else
			aRstVnd[nAchou,3]:=nVenCli
			aRstVnd[nAchou,4]+=CADTMP->D2_QUANT
			aRstVnd[nAchou,5]+=CADTMP->D2_TOTAL
		Endif
	
		// Resumo Midia
		
		nAchou := Ascan(aRstMid,{|x| x[1] == SUS->US_MIDIA })
		If Empty(nAchou)
			AAdd(aRstMid,{	SUS->US_MIDIA,;
							1,;           
							CADTMP->D2_QUANT,;
							CADTMP->D2_TOTAL,;
							Posicione("SUH",1,xFilial("SUH")+SUS->US_MIDIA,"UH_DESC")})
		Else
			If nItem == 1
				aRstMid[nAchou,2]++
			Endif
			aRstMid[nAchou,3]+=CADTMP->D2_QUANT
			aRstMid[nAchou,4]+=CADTMP->D2_TOTAL
		Endif

		// Resumo Por Estado
	
		nAchou := Ascan(aRstEst,{|x| x[1] == CADTMP->A1_EST })
		If Empty(nAchou)
			AAdd(aRstEst,{	CADTMP->A1_EST,;
							AchEstado(CADTMP->A1_EST),;
							1,;           
							CADTMP->D2_QUANT,;
							CADTMP->D2_TOTAL})
		Else
			If nItem == 1
				aRstEst[nAchou,3]++
			Endif
			aRstEst[nAchou,4]+=CADTMP->D2_QUANT
			aRstEst[nAchou,5]+=CADTMP->D2_TOTAL
		Endif
		
		// Resumo por Grupo
	
		nAchou := Ascan(aRstGru,{|x| x[1] == CADTMP->B1_GRUPO })
		If Empty(nAchou)
			AAdd(aRstGru,{	CADTMP->B1_GRUPO,;
							Posicione("SBM",1,xFilial("SBM")+CADTMP->B1_GRUPO,'BM_DESC'),;
							1,;           
							CADTMP->D2_QUANT,;
							CADTMP->D2_TOTAL})
		Else
			If nItem == 1
				aRstGru[nAchou,3]++
			Endif
			aRstGru[nAchou,4]+=CADTMP->D2_QUANT
			aRstGru[nAchou,5]+=CADTMP->D2_TOTAL
		Endif
							
		nQtdCli += CADTMP->D2_QUANT
		nVlrCli += CADTMP->D2_TOTAL

		CADTMP->(dbSkip(1))
		nItem++
	Enddo

	If cCliente <> Left(CADTMP->A1_CGC,8)+CADTMP->A1_COD+CADTMP->A1_LOJA .Or. CADTMP->(Eof())
		If li <> 5000
			li+=050

			oPrint:Say(li,0300,'Sub-Total Cliente CNPJ: ' + cCliente,oArial09N)
			
//			oPrint:Say(li,1100,'Qt.Registros '+TransForm(nTotCli,"9999"),oArial09N,,,,1)
			oPrint:Say(li,1500,TransForm(nQtdCli,"9999999"),oArial09N,,,,1)
			oPrint:Say(li,2000,TransForm(nVlrCli,"@E 99,999,999.99"),oArial09N,,,,1)

			nQtdCli := 0
			nVlrCli := 0
			li+=070
		Endif
	Endif

	If cEstado <> CADTMP->A1_EST .Or. CADTMP->(Eof())
		If li <> 5000
			li+=050

			oPrint:Say(li,0300,'Sub-Total Estado ' + cEstado,oArial09N)
			
//			oPrint:Say(li,1100,'Qt.Registros '+TransForm(aTotais[TOTEST,1],"9999"),oArial09N,,,,1)
			oPrint:Say(li,1500,TransForm(aTotais[TOTEST,2],"9999999"),oArial09N,,,,1)
			oPrint:Say(li,2000,TransForm(aTotais[TOTEST,3],"@E 99,999,999.99"),oArial09N,,,,1)

			aTotais[TOTEST,1] := 0
			aTotais[TOTEST,2] := 0
			aTotais[TOTEST,3] := 0

			li+=070
		Endif
		cEstado := CADTMP->A1_EST
	Endif

	If cGrupo <> CADTMP->B1_GRUPO .Or. CADTMP->(Eof())
		If li <> 5000
			li+=050

			oPrint:Say(li,0300,'Sub-Total Grupo ' + cGrupo,oArial09N)
			
//			oPrint:Say(li,1100,'Qt.Registros '+TransForm(aTotais[TOTGRU,1],"9999"),oArial09N,,,,1)
			oPrint:Say(li,1500,TransForm(aTotais[TOTGRU,2],"9999999"),oArial09N,,,,1)
			oPrint:Say(li,2000,TransForm(aTotais[TOTGRU,3],"@E 99,999,999.99"),oArial09N,,,,1)

			aTotais[TOTGRU,1] := 0
			aTotais[TOTGRU,2] := 0
			aTotais[TOTGRU,3] := 0

			li+=070
		Endif
		cGrupo := CADTMP->B1_GRUPO
	Endif

	// Pula para o proximo cliente que não seja o mesmo CNPJ

	While Left(cCliente,8) == Left(CADTMP->A1_CGC,8) .And. CADTMP->(!Eof())
		CADTMP->(dbSkip(1))
	Enddo

	If cVended <> CADTMP->A1_VEND .Or. CADTMP->(Eof())
		If li <> 5000
			li+=050

			oPrint:Say(li,0300,'Sub-Total do Vendedor ' + cVended,oArial09N)
			
			oPrint:Say(li,1100,'Qt.Clientes '+TransForm(nVenCli,"9999"),oArial09N,,,,1)
			oPrint:Say(li,1500,TransForm(aTotais[TOTVEN,2],"9999999"),oArial09N,,,,1)
			oPrint:Say(li,2000,TransForm(aTotais[TOTVEN,3],"@E 99,999,999.99"),oArial09N,,,,1)

			aTotais[TOTVEN,1] := 0
			aTotais[TOTVEN,2] := 0
			aTotais[TOTVEN,3] := 0                             
			nVenCli := 0

			li+=070
		Endif
		li := 2900
		U_ResV3(cVended)
		cVended := CADTMP->A1_VEND
		li := 2900
	Endif
EndDo
If li <> 5000
	li := 2900
	U_ResT3(cVended)
Endif
oPrint:Preview()  				// Visualiza antes de imprimir
CADTMP->(dbCloseArea())	
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()
Local cMoeda := "1"  

oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(nPg,3)),oCouNew08)

oPrint:Say(180,0040,OemToAnsi(SM0->M0_NOME),oArial14N)  

oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  

oPrint:Box(0290,0030,0420,2200)

oPrint:Say(0320,0040,"Codigo",oArial09N)
oPrint:Say(0320,0200,"Cliente",oArial09N)
oPrint:Say(0320,0800,"1a.Compra",oArial09N)
oPrint:Say(0320,1000,"Estado",oArial09N)
oPrint:Say(0320,1500,"Midia",oArial09N)
oPrint:Say(0320,2000,"Indicou",oArial09N)

oPrint:Say(0350,0300,"N.Fiscal",oArial09N)
oPrint:Say(0350,0500,"Grupo",oArial09N)
oPrint:Say(0350,0650,"Cod.Material",oArial09N)
oPrint:Say(0350,0900,"Descrição",oArial09N)
oPrint:Say(0350,1500,"Quantidade",oArial09N)
oPrint:Say(0350,1800,"Unitário",oArial09N)
oPrint:Say(0350,2000,"Vlr.Total",oArial09N)

li := 450
Return 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AjustaSX1()                                                                                                                                       
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aHelpPor01 := {}
Local aHelpPor02 := {}
Local aHelpPor03 := {}
Local aHelpPor04 := {}
Local aHelpPor05 := {}
Local aHelpPor06 := {}
Local aHelpPor07 := {}

PutSx1(cPerg,'01','Data De        ?','','','mv_ch1','D',08, 0, 0,'G','',''   ,'','','mv_par01'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'02','Data Ate       ?','','','mv_ch2','D',08, 0, 0,'G','',''   ,'','','mv_par02'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'03','Vendedor de    ?','','','mv_ch3','C', 6, 0, 0,'G','','SA3','','','mv_par03'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'04','Vendedor Ate   ?','','','mv_ch4','C', 6, 0, 0,'G','','SA3','','','mv_par04'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'05','Uf De          ?','','','mv_ch5','C', 2, 0, 0,'G','',''   ,'','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'06','Uf Ate         ?','','','mv_ch6','C', 2, 0, 0,'G','',''   ,'','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'07','Grupo De       ?','','','mv_ch7','C', 4, 0, 0,'G','','SBM','','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'08','Grupo Ate      ?','','','mv_ch8','C', 4, 0, 0,'G','','SBM','','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'09','Produto De     ?','','','mv_ch9','C',15, 0, 0,'G','','SB1','','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'10','Produto Ate    ?','','','mv_chA','C',15, 0, 0,'G','','SB1','','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'11','Midia De       ?','','','mv_chB','C',06, 0, 0,'G','','SUH','','','mv_par11'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'12','Midia Ate      ?','','','mv_chC','C',06, 0, 0,'G','','SUH','','','mv_par12'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
Return NIL

Static Function AchEstado(cEstado)
Local aEstados := {}
Local nAchou := 0

// Lista de Estados Brasileiros para Identificacao da Sigla UF

AAdd(aEstados,{'ACRE','AC'})
AAdd(aEstados,{'ALAGOAS','AL'})
AAdd(aEstados,{'AMAPA','AP'})
AAdd(aEstados,{'AMAZONAS','AM'})
AAdd(aEstados,{'BAHIA','BA'})
AAdd(aEstados,{'CEARA','CE'})
AAdd(aEstados,{'DISTRITO FEDERAL','DF'})
AAdd(aEstados,{'ESPIRITO SANTO','ES'})
AAdd(aEstados,{'GOIAS','GO'})
AAdd(aEstados,{'MARANHAO','MA'})
AAdd(aEstados,{'MATO GROSSO','MT'})
AAdd(aEstados,{'MATO GROSSO DO SUL','MS'})
AAdd(aEstados,{'MINAS GERAIS','MG'})
AAdd(aEstados,{'PARA','PA'})
AAdd(aEstados,{'PARAIBA','PB'})
AAdd(aEstados,{'PARANA','PR'})
AAdd(aEstados,{'PERNAMBUCO','PE'})
AAdd(aEstados,{'PIAUI','PI'})
AAdd(aEstados,{'RIO DE JANEIRO','RJ'})
AAdd(aEstados,{'RIO GRANDE DO NORTE','RN'})
AAdd(aEstados,{'RIO GRANDE DO SUL','RS'})
AAdd(aEstados,{'RONDONIA','RO'})
AAdd(aEstados,{'RORAIMA','RR'})
AAdd(aEstados,{'SANTA CATARINA','SC'})
AAdd(aEstados,{'SAO PAULO','SP'})
AAdd(aEstados,{'SERGIPE','SE'})
AAdd(aEstados,{'TOCANTINS','TO'})
AAdd(aEstados,{'EXTERIOR','EX'})


nAchou := Ascan(aEstados,{|x| AllTrim(x[2]) == AllTrim(Upper(cEstado))} )
If !Empty(nAchou)
	cEstado := aEstados[nAchou,1]
Else
	cEstado	:= cEstado+' - (N Localizado)'
Endif
Return cEstado


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ResV3(cVend)
Local cMoeda := "1"  
Local aTotal := {0,0,0}

aSort(aResEst,,, { |x,y| y[1]+y[2] > x[1]+x[2]} )      
aSort(aResGru,,, { |x,y| y[1]+y[2] > x[1]+x[2]} )      
aSort(aResMid,,, { |x,y| y[1]+y[2] > x[1]+x[2]} )      

// Impressão Resumo por Estado

For nRes := 1 To Len(aResEst)
	If li > 2700
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend))
		
		oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  
		
		oPrint:Box(0290,0030,0380,2200)
		
		oPrint:Say(0320,0600,'Estado',oArial09N)
		oPrint:Say(0320,1100,'Qtde Clientes',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    
	If aResEst[nRes,1] == cVend
		oPrint:Say(li,0600,aResEst[nRes,2],oArial09N)
			
		oPrint:Say(li,1200,TransForm(aResEst[nRes,3],"9999"),oArial09N,,,,1)
		oPrint:Say(li,1600,TransForm(aResEst[nRes,4],"9999999"),oArial09N,,,,1)
		oPrint:Say(li,2000,TransForm(aResEst[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

		aTotal[1] += aResEst[nRes,3]
		aTotal[2] += aResEst[nRes,4]
		aTotal[3] += aResEst[nRes,5]

		li+=50
	Endif		
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}

li := 2900

// Impressão Resumo por Midia

For nRes := 1 To Len(aResMid)
	If li > 2700
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend))
		
		oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  
		
		oPrint:Box(0290,0030,0380,2200)
		
		oPrint:Say(0320,0600,'Midias',oArial09N)
		oPrint:Say(0320,1100,'Qtde Clientes',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    
	If aResMid[nRes,1] == cVend
		oPrint:Say(li,0600,aResMid[nRes,6],oArial09N)
			
		oPrint:Say(li,1200,TransForm(aResMid[nRes,3],"9999"),oArial09N,,,,1)
		oPrint:Say(li,1600,TransForm(aResMid[nRes,4],"9999999"),oArial09N,,,,1)
		oPrint:Say(li,2000,TransForm(aResMid[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

		aTotal[1] += aResMid[nRes,3]
		aTotal[2] += aResMid[nRes,4]
		aTotal[3] += aResMid[nRes,5]

		li+=50
	Endif		
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}

li := 2900

// Impressão Resumo por Grupo

For nRes := 1 To Len(aResGru)
	If li > 2700
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend))
		
		oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  
		
		oPrint:Box(0290,0030,0380,2200)
		
		oPrint:Say(0320,0250,'Grupo',oArial09N)
		oPrint:Say(0320,0350,'Descrição',oArial09N)
		oPrint:Say(0320,1100,'Qtde Clientes',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    
	If aResGru[nRes,1] == cVend
		oPrint:Say(li,0250,aResGru[nRes,2],oArial09N)
		oPrint:Say(li,0350,Posicione("SBM",1,xFilial("SBM")+aResGru[nRes,2],'BM_DESC'),oArial09N)
			
		oPrint:Say(li,1200,TransForm(aResGru[nRes,3],"9999"),oArial09N,,,,1)
		oPrint:Say(li,1600,TransForm(aResGru[nRes,4],"9999999"),oArial09N,,,,1)
		oPrint:Say(li,2000,TransForm(aResGru[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

		aTotal[1] += aResGru[nRes,3]
		aTotal[2] += aResGru[nRes,4]
		aTotal[3] += aResGru[nRes,5]

		li+=50
	Endif		
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}


li := 2900
oPrint:EndPage()
Return 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ResT3()
Local cMoeda := "1"  
Local aTotal := {0,0,0}

aSort(aRstVnd,,, { |x,y| y[1] > x[1]} )      
aSort(aRstMid,,, { |x,y| y[1] > x[1]} )      
aSort(aRstEst,,, { |x,y| y[1] > x[1]} )      
aSort(aRstGru,,, { |x,y| y[1] > x[1]} )      

// Impressão Resumo por Vendedor

For nRes := 1 To Len(aRstVnd)
	If li > 2700
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		
		oPrint:Box(0290,0030,0380,2200)
		
		oPrint:Say(0320,0100,'Código',oArial09N)
		oPrint:Say(0320,0300,'Nome Vendedor',oArial09N)
		oPrint:Say(0320,1100,'Qtde Clientes',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    
	oPrint:Say(li,0100,aRstVnd[nRes,1],oArial09N)
	oPrint:Say(li,0300,Capital(aRstVnd[nRes,2]),oArial09N)
			
	oPrint:Say(li,1200,TransForm(aRstVnd[nRes,3],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstVnd[nRes,4],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aRstVnd[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

	aTotal[1] += aRstVnd[nRes,3]
	aTotal[2] += aRstVnd[nRes,4]
	aTotal[3] += aRstVnd[nRes,5]

	li+=50
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}

li := 2900

// Impressão Resumo Midia

For nRes := 1 To Len(aRstMid)
	If li > 2700
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		
		oPrint:Box(0290,0030,0380,2200)
		
		oPrint:Say(0320,0100,'Midia',oArial09N)
		oPrint:Say(0320,0300,'Descrição',oArial09N)
		oPrint:Say(0320,1100,'Qtde Clientes',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    
	oPrint:Say(li,0100,aRstMid[nRes,1],oArial09N)
	oPrint:Say(li,0300,Capital(aRstMid[nRes,5]),oArial09N)
			
	oPrint:Say(li,1200,TransForm(aRstMid[nRes,2],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstMid[nRes,3],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aRstMid[nRes,4],"@E 99,999,999.99"),oArial09N,,,,1)

	aTotal[1] += aRstMid[nRes,2]
	aTotal[2] += aRstMid[nRes,3]
	aTotal[3] += aRstMid[nRes,4]

	li+=50
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}

li := 2900

// Impressão Resumo por Estado

For nRes := 1 To Len(aRstEst)
	If li > 2700
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		
		oPrint:Box(0290,0030,0380,2200)
		
		oPrint:Say(0320,0300,'Estado',oArial09N)
		oPrint:Say(0320,0400,'Descrição',oArial09N)
		oPrint:Say(0320,1100,'Qtde Itens',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    
	oPrint:Say(li,0300,aRstEst[nRes,1],oArial09N)
	oPrint:Say(li,0400,Capital(aRstEst[nRes,2]),oArial09N)
			
	oPrint:Say(li,1200,TransForm(aRstEst[nRes,3],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstEst[nRes,4],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aRstEst[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

	aTotal[1] += aRstEst[nRes,3]
	aTotal[2] += aRstEst[nRes,4]
	aTotal[3] += aRstEst[nRes,5]

	li+=50
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}

li := 2900

// Impressão Resumo por Grupo

For nRes := 1 To Len(aRstGru)
	If li > 2700
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,3100,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0800,OemToAnsi("Relatório de Vendas Clientes Abertos Primeira Compra"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		
		oPrint:Box(0290,0030,0380,2200)
		
		oPrint:Say(0320,0250,'Grupo',oArial09N)
		oPrint:Say(0320,0350,'Descrição',oArial09N)
		oPrint:Say(0320,1100,'Qtde Itens',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    
	oPrint:Say(li,0250,aRstGru[nRes,1],oArial09N)
	oPrint:Say(li,0350,aRstGru[nRes,2],oArial09N)
			
	oPrint:Say(li,1200,TransForm(aRstGru[nRes,3],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstGru[nRes,4],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aRstGru[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

	aTotal[1] += aRstGru[nRes,3]
	aTotal[2] += aRstGru[nRes,4]
	aTotal[3] += aRstGru[nRes,5]

	li+=50
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2000,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}


li := 2900
oPrint:EndPage()
Return 

