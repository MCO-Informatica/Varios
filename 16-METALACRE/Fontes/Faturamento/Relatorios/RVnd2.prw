#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE VENDEDOR   001
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
User Function RelVend2()
Local cDescri       := " "
LOCAL cString		:= "SD2"
Local titulo 		:= ""
LOCAL wnrel		 	:= "RVND1"
LOCAL cDesc1	    := "Relatorio Clientes Primeira Compra"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico Metalacre"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("RVND2",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "RVND2"
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

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio Clientes Primeira Compra - Anual")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(cDesc1)
@ 030,020 SAY OemToAnsi(cDesc2)
@ 045,020 SAY OemToAnsi(cDesc3)
@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)

@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )
ACTIVATE DIALOG oDlg CENTERED



IF nOpcRel == 1 
	Processa({ |lEnd| RVND_2CFG("Impressao Relatório Clientes Primeira Compra")},"Imprimindo , aguarde...")
	Processa({|lEnd| RVND_2REL(@lEnd,wnRel,cString,nReg)},titulo)
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
Static Function RVND_2CFG(Titulo)
Local cFilename := 'RelVnd2'
Local i 	 := 1
Local x 	 := 0

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
oPrint:SetPortrait()
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
Static Function RVND_2REL(lEnd,WnRel,cString,nReg)
Private cCGCPict, cCepPict
Private dDataFim	:= LastDate(MV_PAR05)
Private dDataIni	:= FirstDate(MonthSub(MV_PAR05,11))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If MV_PAR10==1	// Considera Loja
	cQueryCad := "	SELECT A1_VEND, A3_NOME, A1_PRICOM, COUNT(DISTINCT LEFT(A1_CGC,8)) TOT " 
Else
	cQueryCad := "	SELECT A1_VEND, A3_NOME, A1_PRICOM, COUNT(DISTINCT A1_COD) TOT " 
Endif
cQueryCad += "  FROM " + RetSqlName("SA1") + " SA1 "
cQueryCad += "  INNER JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD = A1_VEND AND SA3.D_E_L_E_T_ = '' AND A3_FILIAL = '" + xFilial("SA3") + "' AND A3_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
If MV_PAR10==1	// Considera Loja
	cQueryCad += "  INNER JOIN " + RetSqlName("SD2") + " SD2 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND D2_EMISSAO = A1_PRICOM AND SD2.D_E_L_E_T_ = '' AND SD2.D2_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 +"' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
Else
	cQueryCad += "  INNER JOIN " + RetSqlName("SD2") + " SD2 ON D2_CLIENTE = A1_COD AND D2_EMISSAO = A1_PRICOM AND SD2.D_E_L_E_T_ = '' AND SD2.D2_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 +"' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
Endif
cQueryCad += "  INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = D2_COD AND B1_GRUPO BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' AND SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
cQueryCad += "  WHERE A1_PRICOM BETWEEN '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "' "
cQueryCad += "  AND A1_FILIAL = '" + xFilial("SA1") + "' "
cQueryCad += "  AND A1_EST BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQueryCad += "  AND A1_IDCWEB = '' "
cQueryCad += "  AND SA1.D_E_L_E_T_ = '' "
cQueryCad += "  AND A1_PESSOA = 'J' "
cQueryCad += "  GROUP BY A1_VEND, A3_NOME, A1_PRICOM "
cQueryCad += "  ORDER BY A1_VEND, A3_NOME, A1_PRICOM "

TCQUERY cQueryCad NEW ALIAS "CADTMP"

tcSetField("CADTMP","A1_PRICOM","D")

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
	
	nAchou := Ascan(aResVend,{|x| x[1] == CADTMP->A1_VEND})
	
	If Empty(nAchou)
		AAdd(aResVend,{CADTMP->A1_VEND,;
						CADTMP->A3_NOME,;
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
						0,;
						0})
		nPosMes := Ascan(aPosMes,Left(Dtos(CADTMP->A1_PRICOM),6))
		aResVend[Len(aResVend),nPosMes+2] += CADTMP->TOT
		aResVend[Len(aResVend),15] += CADTMP->TOT
	Else
		nPosMes := Ascan(aPosMes,Left(Dtos(CADTMP->A1_PRICOM),6))
		aResVend[nAchou,nPosMes+2] += CADTMP->TOT
		aResVend[nAchou,15] += CADTMP->TOT
	Endif

	CADTMP->(dbSkip(1))
Enddo       
AAdd(aResVend,{'Total Geral','',0,0,0,0,0,0,0,0,0,0,0,0,0})

For nSoma := 1 TO Len(aResVend)-1
	aResVend[Len(aResVend),3] += aResVend[nSoma,3]
	aResVend[Len(aResVend),4] += aResVend[nSoma,4]
	aResVend[Len(aResVend),5] += aResVend[nSoma,5]
	aResVend[Len(aResVend),6] += aResVend[nSoma,6]
	aResVend[Len(aResVend),7] += aResVend[nSoma,7]
	aResVend[Len(aResVend),8] += aResVend[nSoma,8]
	aResVend[Len(aResVend),9] += aResVend[nSoma,9]
	aResVend[Len(aResVend),10] += aResVend[nSoma,10]
	aResVend[Len(aResVend),11] += aResVend[nSoma,11]
	aResVend[Len(aResVend),12] += aResVend[nSoma,12]
	aResVend[Len(aResVend),13] += aResVend[nSoma,13]
	aResVend[Len(aResVend),14] += aResVend[nSoma,14]
	aResVend[Len(aResVend),15] += aResVend[nSoma,15]
Next

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

	oPrint:Say(li,0040,aResVend[nItem,1],oArial08N)
	oPrint:Say(li,0150,Capital(aResVend[nItem,2]),oArial08N)
	
	nColMes := 650
	For nCol := 3 To 14
		oPrint:Say(li,nColMes,TransForm(aResVend[nItem,nCol],"@E 999,999"),oArial08N,,,,1)
		
		nColMes+=100
	Next
	oPrint:Say(li,2050,TransForm(aResVend[nItem,15],"@E 999,999"),oArial09N,,,,1)
	li+=50
Next

oPrint:Box(li,0030,li,2200 )  //LINHA/COLUNA/ALTURA/LARGURA
li+=50

oPrint:Say(li,0150,Capital(aResVend[Len(aResVend),1]),oArial09N)
nColMes := 650
For nCol := 3 To 14
	oPrint:Say(li,nColMes,TransForm(aResVend[Len(aResVend),nCol],"@E 999,999"),oArial08N,,,,1)
		
	nColMes+=100
Next
oPrint:Say(li,2050,TransForm(aResVend[Len(aResVend),15],"@E 999,999"),oArial09N,,,,1)

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

oPrint:Say(180,0850,OemToAnsi("Relatório de Primeira Compra"),oArial14N)  
oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(dDataIni) + ' Até ' + DtoC(dDataFim)),oArial11N)  

oPrint:Box(0290,0030,0380,2200)

oPrint:Say(0320,0040,"Codigo",oArial09N)
oPrint:Say(0320,0150,"Vendedor(a)",oArial09N)

nColMes := 600
For nCol := 1 To Len(aPosMes)
	cMes := MesExtenso(Val(Right(aPosMes[nCol],2)))
	cAno := Left(aPosMes[nCol],4)
	
	oPrint:Say(0320,nColMes,Left(cMes,3)+'/'+cAno,oArial07N)

	nColMes+=100
Next
oPrint:Say(0320,2000,"Total Geral",oArial09N)
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

PutSx1(cPerg,'01','Vendedor de      ?','','','mv_ch1','C', 6, 0, 0,'G','','SA3','','','mv_par01'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'02','Vendedor Ate     ?','','','mv_ch2','C', 6, 0, 0,'G','','SA3','','','mv_par02'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'03','Uf De            ?','','','mv_ch3','C', 2, 0, 0,'G','',''   ,'','','mv_par03'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'04','Uf Ate           ?','','','mv_ch4','C', 2, 0, 0,'G','',''   ,'','','mv_par04'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'05','Data Até (MM/AA) ?','','','mv_ch5','D', 8, 0, 0,'G','',''   ,'','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'06','Produto de       ?','','','mv_ch6','C',15, 0, 0,'G','','SB1','','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'07','Produto Ate      ?','','','mv_ch7','C',15, 0, 0,'G','','SB1','','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'08','Grupo De         ?','','','mv_ch8','C', 4, 0, 0,'G','','SBM','','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'09','Grupo Ate        ?','','','mv_ch9','C', 4, 0, 0,'G','','SBM','','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'10','Considera Loja   ?','','','mv_chA','N', 1, 0, 1,'C','',''   ,'','','mv_par10'             ,'Sim' ,'','','','Nao','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
Return NIL
