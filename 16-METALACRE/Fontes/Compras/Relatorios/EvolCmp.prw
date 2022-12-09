#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE FORNECEDOR 001
#DEFINE JANE	   002
#DEFINE FEVE	   003
#DEFINE MARC	   004
#DEFINE ABRI	   005
#DEFINE MAIO	   006
#DEFINE JUNH	   007
#DEFINE JULH	   008
#DEFINE AGOS	   009
#DEFINE SETE	   010
#DEFINE OUTU	   011
#DEFINE NOVE	   012
#DEFINE DEZE	   013
#DEFINE TOTAL	   014

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Vendas1 ³ Autor ³ Luiz Alberto V Alves ³ Data ³ Janeiro/2015±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Vendas Faturamento Modelo Gráfico  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Metalacre                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EvolCmp()
Local cDescri       := " "
LOCAL cString		:= "SD1"
Local titulo 		:= ""
LOCAL wnrel		 	:= "REVLCP"
LOCAL cDesc1	    := "Relatorio Evolucao Compras"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico Metalacre"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("REVLCP",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "REVLCP"
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
PRIVATE oArial07N	:= TFont():New("Arial"			,07,07,,.T.,,,,.F.,.F.)		// Negrito
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

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio Evolução de Compras - Anual")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(cDesc1)
@ 030,020 SAY OemToAnsi(cDesc2)
@ 045,020 SAY OemToAnsi(cDesc3)
@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)

@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )
ACTIVATE DIALOG oDlg CENTERED



IF nOpcRel == 1 
	Processa({ |lEnd| REVO_2CFG("Impressao Relatório Evolução Compras")},"Imprimindo , aguarde...")
	Processa({|lEnd| REVO_2REL(@lEnd,wnRel,cString,nReg)},titulo)
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
Static Function REVO_2CFG(Titulo)
Local cFilename := 'RelEvol'
Local i 	 := 1
Local x 	 := 0


lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .F.
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
Static Function REVO_2REL(lEnd,WnRel,cString,nReg)
Private cCGCPict, cCepPict
Private dDataFim	:= LastDate(MV_PAR05)
Private dDataIni	:= FirstDate(MonthSub(MV_PAR05,11))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQueryCad := "SELECT  A2_COD, "
cQueryCad += "  		A2_LOJA, "
cQueryCad += "  		A2_NOME, "
cQueryCad += "  		B1_COD, "
cQueryCad += "  		B1_DESC, "
cQueryCad += "  		LEFT(D1_EMISSAO,6) REF, "
cQueryCad += "  		AVG(D1_VUNIT) UNITARIO "
cQueryCad += "  FROM " + RetSqlName("SA2") + " A2, " + RetSqlName("SD1") + " D1, " + RetSqlName("SB1") + " B1 "
cQueryCad += "  WHERE D1_FORNECE = A2_COD "
cQueryCad += "  AND D1_LOJA = A2_LOJA "
cQueryCad += "  AND D1_COD = B1_COD "
cQueryCad += "  AND D1_EMISSAO BETWEEN '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "' " 
cQueryCad += "  AND D1_FORNECE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR03 + "' " 
cQueryCad += "  AND D1_LOJA BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR04 + "' " 
cQueryCad += "  AND B1_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' " 
cQueryCad += "  AND B1_GRUPO BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' " 
cQueryCad += "  AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQueryCad += "  AND A2_FILIAL = '" + xFilial("SA2") + "' "
cQueryCad += "  AND B1_FILIAL = '" + xFilial("SB1") + "' "
cQueryCad += "  AND D1_TIPO = 'N' "
cQueryCad += "  AND D1.D_E_L_E_T_ = '' "
cQueryCad += "  AND A2.D_E_L_E_T_ = '' "
cQueryCad += "  AND B1.D_E_L_E_T_ = '' "
If !Empty(MV_PAR10)
	cQueryCad += "  AND B1_TIPO = '" + MV_PAR10 + "' "
Endif
cQueryCad += "  GROUP BY A2_COD, A2_LOJA, A2_NOME, B1_COD, B1_DESC, LEFT(D1_EMISSAO,6) "
cQueryCad += "  ORDER BY A2_COD "

TCQUERY cQueryCad NEW ALIAS "CADTMP"

Count To nReg

CADTMP->(dbGoTop())

If Empty(nReg)	
	MsgAlert("Atenção Não Foram Encontrados Dados no Filtro Gerado !","Atenção !")
	CADTMP->(dbCloseArea())
	Return .f.
Endif 

li       	:= 5000
nPg		  	:= 0
aPosMes		:= {}              
aResVend	:= {}
dDataI := dDataIni
While dDataI <= dDataFim
	AAdd(aPosMes,Left(Dtos(dDataI),6))
	
	dDataI := MonthSum(dDataI,1)
Enddo

ProcRegua(nReg,"Aguarde Processando os Dados")
While CADTMP->(!Eof())                           
	IncProc()
	
	nAchou := Ascan(aResVend,{|x| x[1] == CADTMP->A2_COD+CADTMP->A2_LOJA .And. x[3]==CADTMP->B1_COD})
	
	If Empty(nAchou)
		AAdd(aResVend,{CADTMP->A2_COD+CADTMP->A2_LOJA,;
						CADTMP->A2_NOME,;
						CADTMP->B1_COD,;
						CADTMP->B1_DESC,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0})
		nPosMes := Ascan(aPosMes,CADTMP->REF)
		aResVend[Len(aResVend),nPosMes+4] += CADTMP->UNITARIO
	Else
		nPosMes := Ascan(aPosMes,CADTMP->REF)
		aResVend[nAchou,nPosMes+4] += CADTMP->UNITARIO
	Endif

	CADTMP->(dbSkip(1))
Enddo       

// Inicio da Impressao

For nItem := 1 To Len(aResVend)-1
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

	If Empty(aResVend[nItem,1])
		Loop
	Endif

	cForn := aResVend[nItem,1]

	oPrint:Say(li,0040,aResVend[nItem,1],oArial08N)
	oPrint:Say(li,0150,Capital(aResVend[nItem,2]),oArial08N)

	li+=50

	While cForn == aResVend[nItem,1]
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

		oPrint:Say(li,0050,aResVend[nItem,3],oArial07N)
		oPrint:Say(li,0300,Capital(aResVend[nItem,4]),oArial08N)
		
		nColMes := 910
		For nCol := 5 To 16
			oPrint:Say(li,nColMes,TransForm(aResVend[nItem,nCol],"@E 99,999.999"),oArial08N,,,,1)
			
			nColMes+=100
		Next
		li+=50
		nItem++
		If nItem > Len(aResVend)
			Exit
		Endif
	Enddo
Next
oPrint:Box(li,0030,li,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
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

oPrint:Say(180,0850,OemToAnsi("Relatório de Evolução de Compras"),oArial14N)  
oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(dDataIni) + ' Até ' + DtoC(dDataFim)),oArial11N)  

oPrint:Box(0290,0030,0380,2200)

oPrint:Say(0320,0040,"Codigo",oArial08N)
oPrint:Say(0320,0150,"Fornecedor",oArial08N)
oPrint:Say(0380,0050,"Codigo",oArial08N)
oPrint:Say(0380,0300,"Descricao",oArial08N)

nColMes := 900
For nCol := 1 To Len(aPosMes)
	cMes := MesExtenso(Val(Right(aPosMes[nCol],2)))
	cAno := Left(aPosMes[nCol],4)
	
	oPrint:Say(0380,nColMes,Left(cMes,3)+'/'+cAno,oArial07N)

	nColMes+=100
Next
li := 420
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

PutSx1(cPerg,'01','Fornecedor de    ?','','','mv_ch1','C', 6, 0, 0,'G','','SA2','','','mv_par01'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'02','Loja De          ?','','','mv_ch3','C', 2, 0, 0,'G','',''   ,'','','mv_par02'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'03','Fornecedor Ate   ?','','','mv_ch2','C', 6, 0, 0,'G','','SA2','','','mv_par03'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'04','Loja Ate         ?','','','mv_ch4','C', 2, 0, 0,'G','',''   ,'','','mv_par04'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'05','Data Até (MM/AA) ?','','','mv_ch5','D', 8, 0, 0,'G','',''   ,'','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'06','Produto de       ?','','','mv_ch6','C',15, 0, 0,'G','','SB1','','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'07','Produto Ate      ?','','','mv_ch7','C',15, 0, 0,'G','','SB1','','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'08','Grupo De         ?','','','mv_ch8','C', 4, 0, 0,'G','','SBM','','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'09','Grupo Ate        ?','','','mv_ch9','C', 4, 0, 0,'G','','SBM','','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
PutSx1(cPerg,'10','Tipo Produto     ?','','','mv_chA','C', 2, 0, 0,'G','','02' ,'','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',{},{},{})                               
Return NIL
