#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE TOTORC     001
#DEFINE TOTVEN     002
#DEFINE TOTEST     003
#DEFINE TOTOCO     004

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Vendas4 ³ Autor ³ Luiz Alberto V Alves ³ Data ³ Janeiro/2015±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Orçamentos Perdidos x Motivo
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Metalacre                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function R4Vnd()
Local cDescri       := " "
LOCAL cString		:= "SUA"
Local titulo 		:= ""
LOCAL wnrel		 	:= "RVND4"
LOCAL cDesc1	    := "Relatorio de Orçamentos Perdidos x Motivo"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico Metalacre"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("RVND4",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "RVND4"
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
PRIVATE oArial08N	:= TFont():New("Arial"			,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial09N	:= TFont():New("Arial"			,12,12,,.T.,,,,.F.,.F.)		// Negrito
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

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(cDesc1)
@ 030,020 SAY OemToAnsi(cDesc2)
@ 045,020 SAY OemToAnsi(cDesc3)
@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)

@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )
ACTIVATE DIALOG oDlg CENTERED



IF nOpcRel == 1 
	Processa({ |lEnd| RVND_1CFG("Impressao Relatorio de Orçamentos Perdidos x Motivo")},"Imprimindo , aguarde...")
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
Local cFilename := 'RelVnd4'                                                                    
Local i 	 := 1
Local x 	 := 0


lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
oPrint:SetLandscape()
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
Private aTotEstat := {{0,0},{0,0},{0,0},{0,0}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQueryCad := "	SELECT UA_NUM, UA_ESTC, UA_VEND, UA_DTCANC, UA_EMISSAO, UA_CLIENTE, UA_LOJA, UA_NOMECLI, UA_CODLIG, U9_DESC, UA_NUMSC5, UA_CODCANC, UA_STATUS, B1_GRUPO, B1_COD, B1_DESC, UB_OPC, B1_UM, UB_QUANT, UB_VRUNIT, UB_VLRITEM "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SU9") + " U9, " + RetSqlName("SUB") + " UB, " + RetSqlName("SB1") + " B1 "
cQueryCad += "  WHERE UA_CODLIG = U9_CODIGO "
cQueryCad += "  AND B1_FILIAL = '" + xFilial("SB1") + "' "
cQueryCad += "  AND UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQueryCad += "  AND UA_ESTC BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQueryCad += "  AND B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQueryCad += "  AND B1_COD BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND U9.D_E_L_E_T_ = '' "
cQueryCad += "  AND B1.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
//cQueryCad += "  AND UA_ESTC <> '' "
cQueryCad += "  AND UA_VEND <> '' "
cQueryCad += "  AND UA_NUMSC5 = '' "
cQueryCad += "  AND U9_VALIDO = '1' "
cQueryCad += "  AND U9_TIPOATE IN('2','4') "      
cQueryCad += "  AND U9_CODIGO NOT IN('000069') "      
cQueryCad += "  AND UB_NUM = UA_NUM "
cQueryCad += "  AND UB_FILIAL = UA_FILIAL "
cQueryCad += "  AND B1_COD = UB_PRODUTO "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Endif	
cQueryCad += "  ORDER BY UA_VEND, UA_ESTC, UA_DTCANC, B1_GRUPO, UA_NUM, UB_PRODUTO "

TCQUERY cQueryCad NEW ALIAS "CADTMP"

TcSetField('CADTMP','UA_DTCANC','D')
TcSetField('CADTMP','UA_EMISSAO','D')

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
aTotais	:= {{0,0,0},;
			{0,0,0},;
			{0,0,0},;
			{0,0,0}}

aGeral	:= {{0,0,0},;
			{0,0,0},;
			{0,0,0},;
			{0,0,0}}

aResVnd := {}
aResEst := {}
aResOco := {}
aResGru := {}

aRstVnd := {}
aRstEst := {}
aRstOco := {}
aRstGru := {}
aRstCli := {}
			
ProcRegua(nReg,"Aguarde a Impressao")
While CADTMP->(!Eof())                           
	IncProc()

	SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+CADTMP->UA_NUM))
	If SUA->UA_CLIPROS == '1'
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
		cEstado := SA1->A1_ESTC
	ElseIf SUA->UA_CLIPROS == '2'
		SUS->(dbSetOrder(1), dbSeek(xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA))
		cEstado := SUS->US_EST
	Endif
	
	cVended := CADTMP->UA_VEND
		
	cOcorre := CADTMP->UA_CODLIG
	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVended))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se havera salto de formulario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li >= 2100 .And. MV_PAR11 == 2	// Analitico
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
			
	While CADTMP->(!Eof()) .And. cVended == CADTMP->UA_VEND .And. cEstado == Iif(SUA->UA_CLIPROS=='1',SA1->A1_ESTC,SUS->US_EST)
		SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+CADTMP->UA_NUM))
		If SUA->UA_CLIPROS == '1'
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
			cEstado := SA1->A1_ESTC
		ElseIf SUA->UA_CLIPROS == '2'
			SUS->(dbSetOrder(1), dbSeek(xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA))
			cEstado := SUS->US_EST
		Endif     
		
		cVended := CADTMP->UA_VEND
		
		cOcorre := CADTMP->UA_CODLIG
		
		SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVended))
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+CADTMP->B1_COD))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se havera salto de formulario                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If li >= 2100 .And. MV_PAR11 == 2	// Analitico
			If Li <> 5000
				oPrint:EndPage()
			Endif		
		
			nPg++
			ImpCabec()                                                                     
		Endif
	                                                    
		If MV_PAR11 == 2
			oPrint:Say(li,0040,CADTMP->UA_ESTC,oArial08N)
			oPrint:Say(li,0100,DtoC(CADTMP->UA_DTCANC),oArial08N)
			oPrint:Say(li,0300,DtoC(CADTMP->UA_EMISSAO),oArial08N)
			oPrint:Say(li,0500,CADTMP->UA_NUM,oArial08N)
			oPrint:Say(li,0600,CADTMP->UA_STATUS,oArial08N)
			oPrint:Say(li,0700,Capital(Left(CADTMP->U9_DESC,25)),oArial08N)
			oPrint:Say(li,1000,Capital(Left(CADTMP->UA_NOMECLI,25)),oArial08N)
		Else
			li := 100
		Endif
		
        dbSelectArea("SUA")
		If SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+CADTMP->UA_NUM))
			cOrc := SUA->UA_NUM
			cMotivo := MSMM(SUA->UA_CODCANC)
		Endif
			
		aTotais[TOTORC,1]++
		aTotais[TOTVEN,1]++
		aTotais[TOTEST,1]++
		aTotais[TOTOCO,1]++
		aGeral[TOTVEN,1]++
		aGeral[TOTEST,1]++
		aGeral[TOTOCO,1]++

		While CADTMP->(!Eof()) .And. Li < 2100 .And. cVended == CADTMP->UA_VEND .And. cEstado == Iif(SUA->UA_CLIPROS=='1',SA1->A1_ESTC,SUS->US_EST) .And. cOrc == CADTMP->UA_NUM

			If MV_PAR11 == 2
				oPrint:Say(li,1400,CADTMP->B1_GRUPO,oArial08N)
				oPrint:Say(li,1500,CADTMP->B1_COD,oArial08N)
				oPrint:Say(li,1700,Left(CADTMP->UB_OPC,30),oArial08N)
				oPrint:Say(li,2400,CADTMP->B1_UM,oArial08N)
				oPrint:Say(li,2500,TransForm(CADTMP->UB_QUANT,"@E 9999999"),oArial09N,,,,1)
				oPrint:Say(li,2600,TransForm(CADTMP->UB_VRUNIT,"@E 99,999,999.99"),oArial09N,,,,1)
				oPrint:Say(li,2750,TransForm(CADTMP->UB_VLRITEM,"@E 99,999,999.99"),oArial09N,,,,1)
				li+=50
			Endif
				
			aTotais[TOTORC,3]+=CADTMP->UB_VLRITEM
			
			aTotais[TOTVEN,2]+=CADTMP->UB_QUANT
			aTotais[TOTVEN,3]+=CADTMP->UB_VLRITEM
		
			aTotais[TOTEST,2]+=CADTMP->UB_QUANT
			aTotais[TOTEST,3]+=CADTMP->UB_VLRITEM
	
			aTotais[TOTOCO,2]+=CADTMP->UB_QUANT
			aTotais[TOTOCO,3]+=CADTMP->UB_VLRITEM
		
			aGeral[TOTORC,1]++
			aGeral[TOTORC,3]+=CADTMP->UB_VLRITEM
			
			aGeral[TOTVEN,2]+=CADTMP->UB_QUANT
			aGeral[TOTVEN,3]+=CADTMP->UB_VLRITEM
		
			aGeral[TOTEST,2]+=CADTMP->UB_QUANT
			aGeral[TOTEST,3]+=CADTMP->UB_VLRITEM
		
			aGeral[TOTOCO,2]+=CADTMP->UB_QUANT
			aGeral[TOTOCO,3]+=CADTMP->UB_VLRITEM
	
			
			// Resumo Por Vendedor + Estado
		
			nAchou := Ascan(aResEst,{|x| x[1]+x[2] == CADTMP->UA_VEND+CADTMP->UA_ESTC })
			If Empty(nAchou)
				AAdd(aResEst,{	CADTMP->UA_VEND,;
								CADTMP->UA_ESTC,;
								1,;           
								CADTMP->UB_QUANT,;
								CADTMP->UB_VLRITEM})
			Else
				aResEst[nAchou,3]++
				aResEst[nAchou,4]+=CADTMP->UB_QUANT
				aResEst[nAchou,5]+=CADTMP->UB_VLRITEM
			Endif
			
			// Resumo Por Vendedor + Ocorrencia
		
			nAchou := Ascan(aResOco,{|x| x[1]+x[2] == CADTMP->UA_VEND+CADTMP->UA_CODLIG })
			If Empty(nAchou)
				AAdd(aResOco,{	CADTMP->UA_VEND,;
								CADTMP->UA_CODLIG,;
								1,;           
								CADTMP->UB_QUANT,;
								CADTMP->UB_VLRITEM})
			Else
				aResOco[nAchou,3]++
				aResOco[nAchou,4]+=CADTMP->UB_QUANT
				aResOco[nAchou,5]+=CADTMP->UB_VLRITEM
			Endif
	
			// Resumo por Vendedor + Grupo
		
			nAchou := Ascan(aResGru,{|x| x[1]+x[2] == CADTMP->UA_VEND+CADTMP->B1_GRUPO })
			If Empty(nAchou)
				AAdd(aResGru,{	CADTMP->UA_VEND,;
								CADTMP->B1_GRUPO,;
								1,;           
								CADTMP->UB_QUANT,;
								CADTMP->UB_VLRITEM})
			Else
				aResGru[nAchou,3]++
				aResGru[nAchou,4]+=CADTMP->UB_QUANT
				aResGru[nAchou,5]+=CADTMP->UB_VLRITEM
			Endif
								
			// Resumo Total
		
			// Resumo Por Vendedor
		
			nAchou := Ascan(aRstVnd,{|x| x[1] == CADTMP->UA_VEND })
			If Empty(nAchou)
				AAdd(aRstVnd,{	CADTMP->UA_VEND,;
								SA3->A3_NREDUZ,;
								1,;           
								CADTMP->UB_QUANT,;
								CADTMP->UB_VLRITEM,;
								0})
			Else
				aRstVnd[nAchou,3]++
				aRstVnd[nAchou,4]+=CADTMP->UB_QUANT
				aRstVnd[nAchou,5]+=CADTMP->UB_VLRITEM
			Endif
		
			// Resumo Por Vendedor
		
			nAchou := Ascan(aRstCli,{|x| x[1] == CADTMP->UA_VEND+CADTMP->UA_CLIENTE+CADTMP->UA_LOJA })
			If Empty(nAchou)
				AAdd(aRstCli,{	CADTMP->UA_VEND+CADTMP->UA_CLIENTE+CADTMP->UA_LOJA,;
								1})
			Endif

			// Resumo Por Vendedor
		
			nAchou := Ascan(aRstOco,{|x| x[1] == CADTMP->UA_CODLIG })
			If Empty(nAchou)
				AAdd(aRstOco,{	CADTMP->UA_CODLIG,;
								CADTMP->U9_DESC,;
								1,;           
								CADTMP->UB_QUANT,;
								CADTMP->UB_VLRITEM})
			Else
				aRstOco[nAchou,3]++
				aRstOco[nAchou,4]+=CADTMP->UB_QUANT
				aRstOco[nAchou,5]+=CADTMP->UB_VLRITEM
			Endif
		
			// Resumo Por Estado
		
			nAchou := Ascan(aRstEst,{|x| x[1] == Iif(SUA->UA_CLIPROS=='1',SA1->A1_ESTC,SUS->US_EST) })
			If Empty(nAchou)
				AAdd(aRstEst,{	Iif(SUA->UA_CLIPROS=='1',SA1->A1_ESTC,SUS->US_EST),;
								AchEstado(Iif(SUA->UA_CLIPROS=='1',SA1->A1_ESTC,SUS->US_EST)),;
								1,;           
								CADTMP->UB_QUANT,;
								CADTMP->UB_VLRITEM})
			Else
				aRstEst[nAchou,3]++
				aRstEst[nAchou,4]+=CADTMP->UB_QUANT
				aRstEst[nAchou,5]+=CADTMP->UB_VLRITEM
			Endif
			
			// Resumo por Grupo
		
			nAchou := Ascan(aRstGru,{|x| x[1] == CADTMP->B1_GRUPO })
			If Empty(nAchou)
				AAdd(aRstGru,{	CADTMP->B1_GRUPO,;
								Posicione("SBM",1,xFilial("SBM")+CADTMP->B1_GRUPO,'BM_DESC'),;
								1,;           
								CADTMP->UB_QUANT,;
								CADTMP->UB_VLRITEM})
			Else
				aRstGru[nAchou,3]++
				aRstGru[nAchou,4]+=CADTMP->UB_QUANT
				aRstGru[nAchou,5]+=CADTMP->UB_VLRITEM
			Endif
	
			CADTMP->(dbSkip(1))

		Enddo

		If MV_PAR11 == 2
			If !Empty(cMotivo) .And. MV_PAR12 == 1
				_nLinhas := MlCount(cMotivo,100)
		
				oPrint:Say(li,0100,'Motivo: ',oArial08N)
	
				For _nT := 1 To _nLinhas
					oPrint:Say(li,0200,Capital(MemoLine(cMotivo,100,_nT)),oArial08N)
					li+=50
				Next _nT
			Endif
		Endif
		cMotivo := ''
	Enddo

/*	If cEstado <> Iif(SUA->UA_CLIPROS=='1',SA1->A1_ESTC,SUS->US_EST) .Or. CADTMP->(Eof()) 
		If MV_PAR11 == 2
			If li <> 5000
				li+=050
	
				oPrint:Say(li,0200,'Sub-Total Estado ' + cEstado,oArial09N)
				
				oPrint:Say(li,2400,TransForm(aTotais[TOTEST,2],"9999999"),oArial09N,,,,1)
				oPrint:Say(li,2600,TransForm(aTotais[TOTEST,3],"@E 99,999,999.99"),oArial09N,,,,1)
	
				aTotais[TOTEST,1] := 0
				aTotais[TOTEST,2] := 0
				aTotais[TOTEST,3] := 0
	
				li+=070
			Endif
			cEstado := Iif(SUA->UA_CLIPROS=='1',SA1->A1_ESTC,SUS->US_EST)
		Endif
	Endif     */

	If cVended <> CADTMP->UA_VEND .Or. CADTMP->(Eof())
		If MV_PAR11 == 2
			If li <> 5000
				li+=050
	
				oPrint:Say(li,0200,'Sub-Total Vendedor ' + cVended,oArial09N)
				
				oPrint:Say(li,1200,'Qt.Registros '+TransForm(aTotais[TOTVEN,1],"9999"),oArial09N,,,,1)
				oPrint:Say(li,2400,TransForm(aTotais[TOTVEN,2],"9999999"),oArial09N,,,,1)
				oPrint:Say(li,2600,TransForm(aTotais[TOTVEN,3],"@E 99,999,999.99"),oArial09N,,,,1)
	
				aTotais[TOTVEN,1] := 0
				aTotais[TOTVEN,2] := 0
				aTotais[TOTVEN,3] := 0
	
				li+=070
			Endif
			li := 2900
		Endif                     
		U_ResV4(cVended)
		cVended := CADTMP->UA_VEND
		li := 2900
	Endif
EndDo
If li <> 5000 .Or. MV_PAR11 == 1
	li := 2900
	U_ResT4(cVended)
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
oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(nPg,3)),oCouNew08)

oPrint:Say(180,0040,OemToAnsi(SM0->M0_NOME),oArial14N)  

oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  

oPrint:Box(0290,0030,0420,3000 )

oPrint:Say(0320,0040,"UF",oArial09N)
oPrint:Say(0320,0100,"Canc",oArial09N)
oPrint:Say(0320,0300,"Emiss",oArial09N)
oPrint:Say(0320,0500,"Orç",oArial09N)
oPrint:Say(0320,0600,"St",oArial09N)
oPrint:Say(0320,0700,"Ocorr.",oArial09N)
oPrint:Say(0320,1000,"Cliente",oArial09N)
oPrint:Say(0320,1400,"Grp",oArial09N)
oPrint:Say(0320,1500,"Cod.Prod",oArial09N)
oPrint:Say(0320,1700,"Opcional",oArial09N)
oPrint:Say(0320,2400,"Un",oArial09N)
oPrint:Say(0320,2500,"Qtde",oArial09N)
oPrint:Say(0320,2600,"Unitário",oArial09N)
oPrint:Say(0320,2800,"Vlr.Total",oArial09N)

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
PutSx1(cPerg,'11','Só Resumos     ?','','','mv_chB','N', 1, 0, 1,'C','',''   ,'','','mv_par11'           ,'Sim','','',''          ,'Nao','','','','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
PutSx1(cPerg,'12','Texto Motivo   ?','','','mv_chC','N', 1, 0, 1,'C','',''   ,'','','mv_par12'           ,'Sim','','',''          ,'Nao','','','','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
PutSx1(cPerg,'13','Cod.Mot.Cancel.?','','','mv_chD','C', 6, 0, 1,'G','','SU9F','','','mv_par13'           ,'','','',''          ,'','','','','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
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
User Function ResV4(cVend)
Local cMoeda := "1"  
Local aTotal := {0,0,0,0}



aSort(aResEst,,, { |x,y| y[1]+y[2] > x[1]+x[2]} )      
aSort(aResGru,,, { |x,y| y[1]+y[2] > x[1]+x[2]} )      

// Impressão Resumo por Estado

If MV_PAR11 == 2
	lPri := .t.
	li := 3000

	For nRes := 1 To Len(aResEst)
		If li >= 2100 
			If !lPri
				oPrint:EndPage()
			Endif
			lPri := .f.
			oPrint:StartPage() 		// Inicia uma nova pagina
			oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA
			
			oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
			oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
			
			SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend))
			
			oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
			oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
			oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  
			
			oPrint:Box(0290,0030,0380,3000 )
			
			oPrint:Say(0320,0600,'Estado',oArial09N)
			oPrint:Say(0320,1100,'Qtde Itens',oArial09N)
			oPrint:Say(0320,1500,'Qtde Total',oArial09N)
			oPrint:Say(0320,1900,'Valor Total',oArial09N)
					
			li := 420
	    Endif
	    
		If aResEst[nRes,1] == cVend
			oPrint:Say(li,0600,aResEst[nRes,2],oArial09N)
				
			oPrint:Say(li,1200,TransForm(aResEst[nRes,3],"9999"),oArial09N,,,,1)
			oPrint:Say(li,1600,TransForm(aResEst[nRes,4],"9999999"),oArial09N,,,,1)
			oPrint:Say(li,2050,TransForm(aResEst[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)
	
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
		oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
	Endif
	aTotal := {0,0,0,0}
	
	li := 2900
	// Impressão Resumo por Grupo
	
	For nRes := 1 To Len(aResGru)
		If li >= 2100
			oPrint:EndPage()
			oPrint:StartPage() 		// Inicia uma nova pagina
			oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA
			
			oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
			oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
			
			SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend))
			
			oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
			oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
			oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  
			
			oPrint:Box(0290,0030,0380,3000 )
			
			oPrint:Say(0320,0150,'Grupo',oArial09N)
			oPrint:Say(0320,0350,'Descrição',oArial09N)
			oPrint:Say(0320,1100,'Qtde Itens',oArial09N)
			oPrint:Say(0320,1500,'Qtde Total',oArial09N)
			oPrint:Say(0320,1900,'Valor Total',oArial09N)
					
			li := 420
	    Endif
	    
		If aResGru[nRes,1] == cVend
			oPrint:Say(li,0150,aResGru[nRes,2],oArial09N)
			oPrint:Say(li,0350,Posicione("SBM",1,xFilial("SBM")+aResGru[nRes,2],'BM_DESC'),oArial09N)
				
			oPrint:Say(li,1200,TransForm(aResGru[nRes,3],"9999"),oArial09N,,,,1)
			oPrint:Say(li,1600,TransForm(aResGru[nRes,4],"9999999"),oArial09N,,,,1)
			oPrint:Say(li,2050,TransForm(aResGru[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)
	
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
		oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
	Endif
	aTotal := {0,0,0}
	li := 2900
	
	// Impressão Resumo por Estado
	
	For nRes := 1 To Len(aResOco)
		If li >= 2100
			oPrint:EndPage()
			oPrint:StartPage() 		// Inicia uma nova pagina
			oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA
			
			oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
			oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
			
			SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend))
			
			oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
			oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
			oPrint:Say(240,0040,OemToAnsi("Vendedor(a): " + SA3->A3_COD + ' - ' + SA3->A3_NREDUZ),oArial11N)  
			
			oPrint:Box(0290,0030,0380,3000 )
			
			oPrint:Say(0320,0050,'Ocorrencia',oArial09N)
			oPrint:Say(0320,0300,'Descrição',oArial09N)
			oPrint:Say(0320,1100,'Qtde Itens',oArial09N)
			oPrint:Say(0320,1500,'Qtde Total',oArial09N)
			oPrint:Say(0320,1900,'Valor Total',oArial09N)
					
			li := 420
	    Endif
	    
		If aResOco[nRes,1] == cVend
			oPrint:Say(li,0050,aResOco[nRes,2],oArial09N)
			oPrint:Say(li,0300,Capital(Posicione("SU9",2,xFilial("SU9")+aResOco[nRes,2],'U9_DESC')),oArial09N)
				
			oPrint:Say(li,1200,TransForm(aResOco[nRes,3],"9999"),oArial09N,,,,1)
			oPrint:Say(li,1600,TransForm(aResOco[nRes,4],"9999999"),oArial09N,,,,1)
			oPrint:Say(li,2050,TransForm(aResOco[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)
	
			aTotal[1] += aResOco[nRes,3]
			aTotal[2] += aResOco[nRes,4]
			aTotal[3] += aResOco[nRes,5]
	
			li+=50
		Endif		
	Next
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)

Endif

// Dados Estatisticos

// Quantidade de Orçamentos do Vendedor que Geraram Pedidos no Periodo

cQueryCad := "	SELECT COUNT(*) ORC_PEDIDOS "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND = '" + cVend + "' "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Endif	
cQueryCad += "  AND UA.UA_NUMSC5 <> '' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "

TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nTotalPedidos := UATMP->ORC_PEDIDOS
	
UATMP->(dbCloseArea())

// Valor de Orçamentos do Vendedor que Geraram Pedidos no Periodo

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_PEDIDO "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND = '" + cVend + "' "
cQueryCad += "  AND UA.UA_NUMSC5 <> '' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Endif	
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nValorPedidos := UATMP->TOT_PEDIDO
	
UATMP->(dbCloseArea())
	
// Quantidade de Orçamentos Cancelados do Vendedor 

cQueryCad := "	SELECT COUNT(*) ORC_CANC "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND = '" + cVend + "' "
cQueryCad += "  AND UA.UA_CANC = 'S' "
cQueryCad += "  AND UA.UA_STATUS = 'CAN' "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Else
	cQueryCad += "  AND UA.UA_CODLIG = '000069' "
Endif
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nTotalCanc := UATMP->ORC_CANC
	
UATMP->(dbCloseArea())
		                         
// Valor de Orçamentos Cancelados do Vendedor 

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_CANC "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND = '" + cVend + "' "
cQueryCad += "  AND UA.UA_CANC = 'S' "
cQueryCad += "  AND UA.UA_STATUS = 'CAN' "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Else
	cQueryCad += "  AND UA.UA_CODLIG = '000069' "
Endif	
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nValorCanc := UATMP->TOT_CANC
	
UATMP->(dbCloseArea())


// Quantidade de Orçamentos em Aberto do Vendedor 

cQueryCad := "	SELECT COUNT(*) ORC_ABRE "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND = '" + cVend + "' "
cQueryCad += "  AND UA.UA_NUMSC5 = '' "
cQueryCad += "  AND UA.UA_STATUS <> 'CAN' "
cQueryCad += "  AND UA.UA_CANC <> 'S' "
cQueryCad += "  AND UA.UA_CODLIG <> '000069' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nTotalAbre := UATMP->ORC_ABRE
	
UATMP->(dbCloseArea())
		

// Valor de Orçamentos em Aberto do Vendedor 

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_ABRE "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND = '" + cVend + "' "
cQueryCad += "  AND UA.UA_NUMSC5 = '' "
cQueryCad += "  AND UA.UA_STATUS <> 'CAN' "
cQueryCad += "  AND UA.UA_CANC <> 'S' "
cQueryCad += "  AND UA.UA_CODLIG <> '000069' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nValorAbre := UATMP->TOT_ABRE
	
UATMP->(dbCloseArea())

// Quantidade de Orçamentos em Aberto do Vendedor 

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_ABERTO "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA_VEND = '" + cVend + "' "
cQueryCad += "  AND UA.UA_NUMSC5 = '' "
cQueryCad += "  AND UA.UA_STATUS <> 'CAN' "
cQueryCad += "  AND UA.UA_CANC <> 'S' "
cQueryCad += "  AND UA.UA_CODLIG <> '000069' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nVlrAberto := UATMP->TOT_ABERTO
	
UATMP->(dbCloseArea())

aTotEstat[1,1]	+=	nTotalPedidos
aTotEstat[1,2]	+=	nValorPedidos
aTotEstat[2,1]	+=	nTotalCanc
aTotEstat[2,2]	+=	nValorCanc
aTotEstat[3,1]	+=	nTotalAbre         
aTotEstat[3,2]	+=	nValorAbre         
aTotEstat[4,1]	+=	nVlrAberto

If MV_PAR11 == 2
	li+=100
	
	oPrint:Say(li,0600,'Qtde Total Orcamentos Convertidos em Pedido de Vendas ',oArial09N)
				
	oPrint:Say(li,1600,TransForm(nTotalPedidos,"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(nValorPedidos,"@E 99,999,999.99"),oArial09N,,,,1)
	
	li+=50
	
	oPrint:Say(li,0600,'Qtde Total Orcamentos Cancelados (Alt.Orçamento)',oArial09N)
				
	oPrint:Say(li,1600,TransForm(nTotalCanc,"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(nValorCanc,"@E 99,999,999.99"),oArial09N,,,,1)
		
	li+=50
	
	oPrint:Say(li,0600,'Qtde / Valor Total Orcamentos Em Aberto ',oArial09N)
				
	oPrint:Say(li,1600,TransForm(nTotalAbre,"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(nVlrAberto,"@E 99,999,999.99"),oArial09N,,,,1)

	li+=50
	
	oPrint:Say(li,0600,'Total de Orcamentos Enviados ',oArial09N)
				
	oPrint:Say(li,1600,TransForm((nTotalPedidos+nTotalAbre+aTotal[1]),"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm((nValorPedidos+nVlrAberto+aTotal[3]),"@E 99,999,999.99"),oArial09N,,,,1)


	li+=50
	
	oPrint:Say(li,0600,'(%) de Perda ',oArial09N)
				
	oPrint:Say(li,1600,TransForm(Round(nValorPedidos/aTotal[3],6)*100,"@E 9,999.99")+' %',oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)

	aTotal := {0,0,0}
	li := 2900
	
	oPrint:EndPage()
Endif
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
User Function ResT4()
Local cMoeda := "1"  
Local aTotal := {0,0,0,0}

aSort(aRstVnd,,, { |x,y| y[1] > x[1]} )      
aSort(aRstEst,,, { |x,y| y[1] > x[1]} )      
aSort(aRstGru,,, { |x,y| y[1] > x[1]} )      
aSort(aRstOco,,, { |x,y| y[1] > x[1]} )      

li := 2900

// Impressão Resumo por Vendedor

For nRes := 1 To Len(aRstVnd)
	If li >= 2100
		If MV_PAR11 == 2 .Or. li <> 2900
			oPrint:EndPage()
		Endif
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		
		oPrint:Box(0290,0030,0380,3000 )
		
		oPrint:Say(0320,0100,'Código',oArial09N)
		oPrint:Say(0320,0300,'Nome Vendedor',oArial09N)
		oPrint:Say(0320,1000,'Clientes',oArial09N)
		oPrint:Say(0320,1200,'Qtde Itens',oArial09N)
		oPrint:Say(0320,1500,'Qtde Total',oArial09N)
		oPrint:Say(0320,1900,'Valor Total',oArial09N)
				
		li := 420
    Endif
    

	// Resumo Por Vendedor
		
	
	nTTClientes := 0
	For nTCli := 1 To Len(aRstCli)
		If Left(aRstCli[nTCli,1],6) == aRstVnd[nRes,1]
			nTTClientes++
		Endif
	Next

	oPrint:Say(li,0100,aRstVnd[nRes,1],oArial09N)
	oPrint:Say(li,0300,Capital(aRstVnd[nRes,2]),oArial09N)
			
	oPrint:Say(li,1000,TransForm(nTTClientes,"9999"),oArial09N,,,,1)
	oPrint:Say(li,1200,TransForm(aRstVnd[nRes,3],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstVnd[nRes,4],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aRstVnd[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

	aTotal[1] += aRstVnd[nRes,3]
	aTotal[2] += aRstVnd[nRes,4]
	aTotal[3] += aRstVnd[nRes,5]
	aTotal[4] += nTTClientes

	li+=50
Next
If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1000,TransForm(aTotal[4],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)

Endif
aTotal := {0,0,0}

li+=50
lPriPag := .t.

// Impressão Resumo por Estado

For nRes := 1 To Len(aRstEst)
	If li >= 2100
		lPriPag := .t.
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		li:=290		
    Endif
    
    If lPriPag
		oPrint:Box(li,0030,li+90,3000 )
		li+=30
		
		oPrint:Say(li,0200,'Estado',oArial09N)
		oPrint:Say(li,0400,'Descrição',oArial09N)
		oPrint:Say(li,1100,'Qtde Itens',oArial09N)
		oPrint:Say(li,1500,'Qtde Total',oArial09N)
		oPrint:Say(li,1900,'Valor Total',oArial09N)
				
		li += 100
		lPriPag := .f.
	Endif    
    
	oPrint:Say(li,0200,aRstEst[nRes,1],oArial09N)
	oPrint:Say(li,0400,Capital(aRstEst[nRes,2]),oArial09N)
			
	oPrint:Say(li,1200,TransForm(aRstEst[nRes,3],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstEst[nRes,4],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aRstEst[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

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
	oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif
aTotal := {0,0,0}

li+=50
lPriPag := .t.

// Impressão Resumo por Grupo

For nRes := 1 To Len(aRstGru)
	If li >= 2100
		lPriPag := .t.
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		li:=290		
    Endif
    If lPriPag
		
		oPrint:Box(li,0030,li+90,3000 )
		li+=30		
		oPrint:Say(li,0150,'Grupo',oArial09N)
		oPrint:Say(li,0350,'Descrição',oArial09N)
		oPrint:Say(li,1100,'Qtde Itens',oArial09N)
		oPrint:Say(li,1500,'Qtde Total',oArial09N)
		oPrint:Say(li,1900,'Valor Total',oArial09N)
				
		li += 100
		lPriPag := .f.
	Endif    
    
	oPrint:Say(li,0150,aRstGru[nRes,1],oArial09N)
	oPrint:Say(li,0350,aRstGru[nRes,2],oArial09N)
			
	oPrint:Say(li,1200,TransForm(aRstGru[nRes,3],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstGru[nRes,4],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aRstGru[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

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
	oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
Endif

aTotal := {0,0,0}

li+=50
lPriPag := .t.

// Impressão Resumo por Estado

For nRes := 1 To Len(aRstOco)
	If li > 2100
		lPriPag := .t.
		oPrint:EndPage()
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:Box(0130,0030,2200,3000 )  //LINHA/COLUNA/ALTURA/LARGURA
		
		oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
		oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(++nPg,3)),oCouNew08)
		
		oPrint:Say(180,0700,OemToAnsi("Relatorio de Orçamentos Perdidos x Motivo"),oArial14N)  
		oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),oArial11N)  
		li:=290		
    Endif
	If lPriPag
		oPrint:Box(li,0030,li+90,3000 )
		li+=30
		
		oPrint:Say(li,0050,'Ocorrência',oArial09N)
		oPrint:Say(li,0300,'Descrição',oArial09N)
		oPrint:Say(li,1100,'Qtde',oArial09N)
		oPrint:Say(li,1500,'Qtde Total',oArial09N)
		oPrint:Say(li,1900,'Valor Total',oArial09N)
				
		li += 100
		lPriPag := .f.
	Endif
    
	oPrint:Say(li,0050,aRstOco[nRes,1],oArial09N)
	oPrint:Say(li,0300,Capital(aRstOco[nRes,2]),oArial09N)
			
	oPrint:Say(li,1200,TransForm(aRstOco[nRes,3],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aRstOco[nRes,4],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aRstOco[nRes,5],"@E 99,999,999.99"),oArial09N,,,,1)

	aTotal[1] += aRstOco[nRes,3]
	aTotal[2] += aRstOco[nRes,4]
	aTotal[3] += aRstOco[nRes,5]

	li+=50
Next

// Dados Estatisticos

// Quantidade de Orçamentos do Vendedor que Geraram Pedidos no Periodo

cQueryCad := "	SELECT COUNT(*) ORC_PEDIDOS "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA.UA_NUMSC5 <> '' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "

TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nTotalPedidos := UATMP->ORC_PEDIDOS
	
UATMP->(dbCloseArea())

// Valor de Orçamentos do Vendedor que Geraram Pedidos no Periodo

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_PEDIDO "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA.UA_NUMSC5 <> '' "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Endif	
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nValorPedidos := UATMP->TOT_PEDIDO
	
UATMP->(dbCloseArea())
	
// Quantidade de Orçamentos Cancelados do Vendedor 

cQueryCad := "	SELECT COUNT(*) ORC_CANC "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA.UA_CANC = 'S' "
cQueryCad += "  AND UA.UA_STATUS = 'CAN' "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Else
	cQueryCad += "  AND UA.UA_CODLIG = '000069' "
Endif
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nTotalCanc := UATMP->ORC_CANC
	
UATMP->(dbCloseArea())
		                         
// Valor de Orçamentos Cancelados do Vendedor 

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_CANC "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_DTCANC BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA.UA_CANC = 'S' "
cQueryCad += "  AND UA.UA_STATUS = 'CAN' "
If !Empty(MV_PAR13)
	cQueryCad += "  AND UA_CODLIG = '" + MV_PAR13 + "' "      
Else
	cQueryCad += "  AND UA.UA_CODLIG = '000069' "
Endif
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nValorCanc := UATMP->TOT_CANC
	
UATMP->(dbCloseArea())


// Quantidade de Orçamentos em Aberto do Vendedor 

cQueryCad := "	SELECT COUNT(*) ORC_ABRE "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA.UA_NUMSC5 = '' "
cQueryCad += "  AND UA.UA_STATUS <> 'CAN' "
cQueryCad += "  AND UA.UA_CANC <> 'S' "
cQueryCad += "  AND UA.UA_CODLIG <> '000069' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nTotalAbre := UATMP->ORC_ABRE
	
UATMP->(dbCloseArea())
		

// Valor de Orçamentos em Aberto do Vendedor 

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_ABRE "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA.UA_NUMSC5 = '' "
cQueryCad += "  AND UA.UA_STATUS <> 'CAN' "
cQueryCad += "  AND UA.UA_CANC <> 'S' "
cQueryCad += "  AND UA.UA_CODLIG <> '000069' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nValorAbre := UATMP->TOT_ABRE
	
UATMP->(dbCloseArea())

// Quantidade de Orçamentos em Aberto do Vendedor 

cQueryCad := "	SELECT SUM(UB_VLRITEM) TOT_ABERTO "
cQueryCad += "  FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SUB") + " UB "
cQueryCad += "  WHERE "
cQueryCad += "  UA_FILIAL = '" + xFilial("SUA") + "' "
cQueryCad += "  AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQueryCad += "  AND UA.UA_NUMSC5 = '' "
cQueryCad += "  AND UA.UA_STATUS <> 'CAN' "
cQueryCad += "  AND UA.UA_CANC <> 'S' "
cQueryCad += "  AND UA.UA_CODLIG <> '000069' "
cQueryCad += "  AND UA.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.D_E_L_E_T_ = '' "
cQueryCad += "  AND UB.UB_FILIAL = UA.UA_FILIAL "
cQueryCad += "  AND UB.UB_NUM = UA.UA_NUM "
	
TCQUERY cQueryCad NEW ALIAS "UATMP"
	
nVlrAberto := UATMP->TOT_ABERTO
	
UATMP->(dbCloseArea())

If aTotal[1] > 0
	li+=50
	oPrint:Say(li,0600,'Total',oArial09N)
			
	oPrint:Say(li,1200,TransForm(aTotal[1],"9999"),oArial09N,,,,1)
	oPrint:Say(li,1600,TransForm(aTotal[2],"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)
	
	li+=100

	oPrint:Say(li,0600,'Qtde Total Orcamentos Convertidos em Pedido de Vendas ',oArial09N)
			
	oPrint:Say(li,1600,TransForm(nTotalPedidos,"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(nValorPedidos,"@E 99,999,999.99"),oArial09N,,,,1)

	li+=50

	oPrint:Say(li,0600,'Qtde Total Orcamentos Cancelados (Alt.Orçamento)',oArial09N)
			
	oPrint:Say(li,1600,TransForm(nTotalCanc,"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(nValorCanc,"@E 99,999,999.99"),oArial09N,,,,1)
	
	li+=50

	oPrint:Say(li,0600,'Qtde / Valor Total Orcamentos Em Aberto ',oArial09N)
			
	oPrint:Say(li,1600,TransForm(nTotalAbre,"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(nVlrAberto,"@E 99,999,999.99"),oArial09N,,,,1)

	li+=50
	
	oPrint:Say(li,0600,'Total de Orcamentos Enviados ',oArial09N)
				
	oPrint:Say(li,1600,TransForm((nTotalPedidos+nTotalAbre+aTotal[1]),"9999999"),oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm((nValorPedidos+nVlrAberto+aTotal[3]),"@E 99,999,999.99"),oArial09N,,,,1)

	li+=50

	oPrint:Say(li,0600,'(%) de Perda ',oArial09N)
			
	oPrint:Say(li,1600,TransForm(Round(nValorPedidos/aTotal[3],6)*100,"@E 9,999.99")+' %',oArial09N,,,,1)
	oPrint:Say(li,2050,TransForm(aTotal[3],"@E 99,999,999.99"),oArial09N,,,,1)

Endif

aTotal := {0,0,0}


li := 2900

oPrint:EndPage()
Return 

