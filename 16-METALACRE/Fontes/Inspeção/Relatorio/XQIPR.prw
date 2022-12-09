#Include "QIPR050.Ch"
#Include "PROTHEUS.Ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QIPR050  ³ Autor ³     Marcelo Pimentel  ³ Data ³ 08.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado de Qualidade.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQIP                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³String    ³ Ultimo utilizado -> 0036       							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Paulo Emídio³16/08/00³Melhor³ Revisao e compatibilizacao da funcao     ³±±
±±³            ³        ³      ³ CTOD().                               	  ³±±
±±³Marcelo Pim.³26/03/01³------³Inclusao da impressao grafica no relatorio³±±
±±³Marcelo Pim.³10/04/01³7255  ³Verificacao no cadastro de especificacao  ³±±
±±³            ³        ³      ³de produtos o campo Consta Certificado P/ ³±±
±±³            ³        ³      ³que seja impresso somente se for = "S"    ³±±
±±³Marcelo Pim.³21/08/02³------³Melhoria na apresentacao da Tela de Para- ³±±
±±³            ³        ³      ³metros.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XQIPR(aNotas)
Local oDlgGet
Local oListBox
Local nItem		:=0
Private lEnd	:=.F.
Private aListBox:={}
Private cPerg1	:="QPR051"
Private  __cPRODUTO := CriaVar("QP6_PRODUT") //Codigo do Produto, quando a Especificacao for em Grupo      
Private lProduto   := .F.
Private lFase3     := IIF(QP6->(FieldPos("QP6_SITREV"))<>0,.T.,.F.)

DEFAULT	aNotas	:=	{}         //000048021

AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aListBox,OemToAnsi(STR0004))		//" Texto Superior "
AADD(aListBox,OemToAnsi(STR0005))		//" Texto Inferior "
AADD(aListBox,OemToAnsi(STR0034))		//" Informacoes Complementares "
AADD(aListBox,OemToAnsi(STR0006))		//" Impressao "

If Empty(Len(aNotas))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa ListBox com opcoes para o array da configuracao          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlgGet TITLE STR0007 FROM  0,0	TO 217,297 OF oMainWnd PIXEL 	//"Certificado de Qualidade"
	@ 01,05 SAY OemToAnsi(STR0008)	SIZE 100, 07 OF oDlgGet PIXEL					//"Itens de Configuracao"
	@ 10,05 LISTBOX oListBox VAR nItem  ITEMS aListBox  ON DBLCLICK Iif(nItem<=3,R050TEXT(oListBox:nAt),Pergunte(cPerg1,.T.)) SIZE 110,90 PIXEL OF oDlgGet
	DEFINE SBUTTON FROM 10, 120 TYPE 6 ACTION (R050IMP(),oDlgGet:End()) ENABLE OF oDlgGet
	DEFINE SBUTTON FROM 26, 120 TYPE 2 ACTION oDlgGet:End() ENABLE OF oDlgGet
	
	ACTIVATE MSDIALOG oDlgGet CENTERED
Else                           
		
	cFilename := Criatrab(Nil,.F.)
		
	lAdjustToLegacy := .T.   //.F.
	lDisableSetup  := .T.
	oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
	oPrint:SetResolution(78)
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:SetPaperSize(DMPAPER_A4) 
	oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
	oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF 
	cDiretorio := oPrint:cPathPDF

	For nI := 1 To Len(aNotas)

		R050Imp(aNotas[nI])

	Next
	oPrint:EndPage()     // Finaliza a página
	oPrint:Preview()     // ViSCJliza antes de imprimir
Endif
Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R050Text    ³Autor³ Marcelo Pimentel      ³ Data ³ 08.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Tela para preenchimento do conteudo relacionado com o ³±±
±±³          ³ListBox.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIPR050                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R050Text(nOpcao)
Local oDlgGet2
Local oTexto
Local cTexto 		:= ""
Local oFontDialog	:= TFont():New("Arial",6,15,,.T.)

nAt:=nOpcao //oListBox:nAt

cNomeArq := "X"
nHdl:=MSFCREATE(cNomeArq,0)
If nHdl <= -1
	HELP(" ",1,"NODIRCQ")
	Return .T.
Else
	If File(cNomeArq)
		FCLOSE(nHdl)
		FERASE(cNomeArq)
	Endif
Endif

cNomeArq := "QPR050"+Str(nAt,1)+".TXT"

While .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le arquivo                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTexto:=MemoRead(cNomeArq)
		
	DEFINE MSDIALOG oDlgGet2 FROM	62,100 TO 345,610 TITLE  OemToAnsi(STR0008) PIXEL FONT oFontDialog		//"Itens de Configura‡Æo"
	@ 003, 004 TO 027, 250 LABEL "" 	OF oDlgGet2 PIXEL
	@ 040, 004 TO 110, 250				OF oDlgGet2 PIXEL
		
	@ 013, 010 MSGET aListBox[nAt]		             WHEN .F. SIZE 235, 010 OF oDlgGet2 PIXEL
	@ 050, 010 GET oTexto VAR cTexto MEMO NO VSCROLL WHEN .T. SIZE 235, 051 OF oDlgGet2 PIXEL
		
	DEFINE SBUTTON FROM 120,190 TYPE 1 ACTION (MemoWrit( cNomeArq,cTexto ),FCLOSE(cNomeArq),oDlgGet2:End()) ENABLE OF oDlgGet2
	DEFINE SBUTTON FROM 120,220 TYPE 2 ACTION oDlgGet2:End() ENABLE OF oDlgGet2
		
	ACTIVATE MSDIALOG oDlgGet2 CENTERED
	Exit
EndDo

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R050Imp  ³ Autor ³     Marcelo Pimentel  ³ Data ³ 08.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQIP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R050Imp(nRegQPK)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Par„metros para a fun‡„o SetPrint () ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel		:="QIPR050"
LOCAL cString	:="QPR"
LOCAL cDesc1	:=STR0009		//"Neste relatorio sera impresso os Certificados"
LOCAL cDesc2	:=""
LOCAL cDesc3	:=""
Local nVias     :=0
Local nImpEns   :=0
Local lAchou    :=.F. 
Local cImprCQ   := GETMV("MV_QIMPRCQ")

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cTitulo 	:=STR0010	//"Certificado Qualidade"
PRIVATE cRelatorio	:="QIPR050"
PRIVATE nTamanho	:="G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault () ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn 	:= {STR0011, 1,STR0012,  1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg		:= "QPR050"
PRIVATE cPergR		:= "QPR50R"

DEFAULT	nRegQPK		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01           // Cliente                                ³
//³ mv_par02           // Loja do Cliente                        ³
//³ mv_par03           // Produto                                ³
//³ mv_par04           // Data da Producao                       ³
//³ mv_par05           // Lote                                   ³
//³ mv_par06           // Lote                                   ³
//³ mv_par07           // Nr. de Vias                            ³
//³ mv_par08           // Revisao                                ³
//³ mv_par09           // Impr. Ensaio Texto (Primeira/Todas)    ³
//³ mv_par10           // Nota Fiscal                            ³
//³ mv_par11           // Serie                                  ³
//³ mv_par12           // Ordem de Produção                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Empty(nRegQPK)
	If !Pergunte(cPerg,.T.)	
		Return .t.
	Endif

	cFilename := Criatrab(Nil,.F.)
	
	lAdjustToLegacy := .T.   //.F.
	lDisableSetup  := .T.
	oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
	oPrint:SetResolution(78)
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:SetPaperSize(DMPAPER_A4) 
	oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
	oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF 
	cDiretorio := oPrint:cPathPDF

Else 
	Pergunte(cPerg,.F.)	
	
	QPK->(dbGoTo(nRegQPK))
	
	MV_PAR01	:=	''
	MV_PAR02	:=	''
	MV_PAR03	:=	QPK->QPK_PRODUT
	MV_PAR04	:=	QPK->QPK_DTPROD
	MV_PAR05	:=	''
	MV_PAR06	:=	''
	MV_PAR07	:=	1
	MV_PAR08	:=	QPK->QPK_REVI
	MV_PAR09	:=	2
	MV_PAR10	:=	SPACE(09)
	MV_PAR11	:=	SPACE(03)
	MV_PAR12	:=	QPK->QPK_OP
Endif

oFont  := TFont():New( "Arial",,16,,.t.,,,,,.f. )	
oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont5 := TFont():New( "Arial",,10,,.t.,,,,,.f. )  
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont7 := TFont():New( "Arial",,12,,.t.,,,,,.f. )  
oFont8 := TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,12,,.t.,,,,,.f. )  
oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. ) 
oFont11:= TFont():New( "Arial",,07,,.t.,,,,,.f. )  
oFont12:= TFont():New( "Arial",,07,,.f.,,,,,.f. )
	
oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )  
oFont6c := TFont():New( "Courier New",,10,,.T.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )  
oFont8c := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )  
oFont10c:= TFont():New( "Courier New",,12,,.t.,,,,,.f. ) 
oBrush	:= TBrush():NEW("",CLR_HGRAY)          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FunName() == "QIPA215"           
	
	Pergunte(cPergR,.F.)
//	wnrel := SetPrint(cString,wnrel,cPergR,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,nTamanho)
	
	//Salva variaveis do pergunte QIPR501
	nVias     :=mv_par01
	cRevi     :=Iif(Empty(AllTrim(QPK->QPK_REVI)),QA_UltRevEsp(QPK->QPK_PRODUT,,,,"QIP"),QPK->QPK_REVI)
	nImpEns   :=mv_par03
	cNota     :=mv_par04
	cSerie    :=mv_par05

	Pergunte(cPerg,.F.)
	
	//Atualiza variaveis do pergunte padrao do relatorio QIPR050
	mv_par01  := cIPCLIENT        // Cliente                                
	mv_par02  := cIPLoj           // Loja do Cliente                        
	mv_par03  := QPK->QPK_PRODUT  // Produto  
	
	//Pesquisa data da medição.
	dbSelectArea("QPR")     
    dbSetOrder(9)
    If dbSeek(xFilial("QPR")+QPK->QPK_OP+QPK->QPK_LOTE+QPK->QPK_NUMSER)
    	mv_par04  := QPR->QPR_DTENTR     
	Else 
		mv_par04  := QPK->QPK_DTPROD	
	EndIf                      
	
	mv_par05  := QPK->QPK_LOTE	   // Lote                                   
	mv_par06  := QPK->QPK_NUMSER  //  Numero do Lote                                   
	mv_par07  := nVias            // Nr. de Vias                            
	mv_par08  := cRevi            // Revisao                                
	mv_par09  := nImpEns          // Impr. Ensaio Texto (Primeira/Todas)    
	mv_par10  := cNota            // Nota Fiscal                            
	mv_par11  := cSerie           // Serie  
	mv_par12  := QPK->QPK_OP      // Ordem de Produção  
	
Else
//	wnrel := SetPrint(cString,wnrel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,nTamanho)
	DbSelectArea("QPK")
	DbSetOrder(2)
	If DbSeek(xFilial("QPK")+MV_PAR03)
   		While !EOF().AND. AllTrim(QPK->QPK_PRODUT) == AllTrim(MV_PAR03)
   		    If cImprCQ == "N"
   		   		If DTOS(QPK->QPK_DTPROD) == DTOS(MV_PAR04) .AND. AllTrim(QPK_OP) == AllTrim(MV_PAR12) .AND. AllTrim(QPK_LOTE) == AllTrim(MV_PAR05) .AND.;
	            	AllTrim(QPK_NUMSER) == AllTrim(MV_PAR06) .AND. AllTrim(QPK_REVI) == AllTrim(MV_PAR08) .AND. !Empty(QPK_CERQUA)
        			lAchou := .T.  
        			Exit
        		EndIf
           		DbSkip()
             Else
             	If DTOS(QPK->QPK_DTPROD) == DTOS(MV_PAR04) .AND. AllTrim(QPK_OP) == AllTrim(MV_PAR12) .AND. AllTrim(QPK_LOTE) == AllTrim(MV_PAR05) .AND.;
	            	AllTrim(QPK_NUMSER) == AllTrim(MV_PAR06) .AND. AllTrim(QPK_REVI) == AllTrim(MV_PAR08) 
        			lAchou := .T.  
        			Exit
        		EndIf
           		DbSkip() 
             Endif
   		EndDo
   		If !lAchou
//			MsgInfo(STR0043) // "Identificada inconsistencia, favor verificar (Ordem de Producao + Lote + Num Serie + Produto + Revisao)"
			Return()
   		EndIf   
	Else
//		MsgInfo(STR0044) // "Identificada inconsistencia, favor verificar a chave (Produto + Data Producao)"
		return()
	EndIf

EndIF

If Empty(nRegQPK)
	RptStatus({|lEnd| A050Imp(@lEnd,wnRel,cString,cTitulo)},ctitulo)
	
	oPrint:EndPage()     // Finaliza a página
	oPrint:Preview()     // ViSCJliza antes de imprimir
Else
	RptStatus({|lEnd| A050Imp(@lEnd,wnRel,cString,cTitulo)},ctitulo)
Endif
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A050Imp  ³ Autor ³ Marcelo Pimentel      ³ Data ³ 08.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡Æo dos Certificados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A050Imp(lEnd,wnRel,cString)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQIP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A050Imp(lEnd,wnRel,cString,cTitulo)
Local cAcentos		:="€ú‡úúú…ú†úƒú úúˆú‚ú¡ú“ú”ú¢ú™ú£ú"
Local cAcSubst 		:="C,c,A~A'a`a~a^a'E'e^e'i'o^o~o'O~U'"
Local cArqTxt		:=""
Local cTexto		:=""
Local cImpTxt		:=""
Local cEnsaio		:=""
Local cChave		:=""
Local cSeek			:=""
Local cTxtRes		:=""
Local cTxt			:=""
Local cLabor		:=""
Local cRevi			:= If(Empty(mv_par08),QA_UltRevEsp(mv_par03,,,,"QIP"), mv_par08) 
Local cLote			:=""
Local cLaborat		:=""
Local aTexto		:={}
Local aTxtRes		:={}
Local aLinha		:={}
Local cImpLinha	:={}
Local cbCont		:=00
Local nVlrMin		:=999999
Local nVlrMax		:=-999999
Local nVlrUnic		:=0
Local nC				:=0
Local nCount		:=0
Local nV				:=1
Local nX				:=0
Local nAmostra		:=0
Local nPorcent		:=0
Local lUnic			:=.T.
Local nContador	:=1
Local cOperacao	:=""
Local cRoteiro 	:=""
Local CbTxt
Local cNomArq		:=""
Local cPrd 			:=mv_par03
Local dDatOP		:=mv_par04
Local lEnsaio		:=.F.
Local lChecaQQ7		:=.F.
Local aAreaQPR		:= {}
Local lImpTxt       := .T.
Local lPula         := .T.
Local nMedia        := 0
Local nPosQPR       := 0
Local nOrdQPR       := 0
Local nPosQQ7       := 0
Local nOrdQQ7       := 0
Local nPosSA1       := 0
Local nOrdSA1       := 0
Local nPosQP6       := 0
Local nOrdQP6       := 0
Local nPosSC2       := 0
Local nOrdSC2       := 0
Local nRecQPR       := 0

Private cOp			:=mv_par12
Private cLot			:=Padr(mv_par05,TamSX3("QPR_LOTE")[1]) 
Private cNumSer       :=Padr(mv_par06,TamSX3("QPR_NUMSER")[1]) 
Private Titulo 	 := cTitulo
Private Cabec1 	 := ""
Private Cabec2	 := ""
Private	nomeprog := "QIPR050"
Private cTamanho := "M"
Private nTipo	 := 0
Private lPrimPag := .t.
Private aMeses		:={STR0021,STR0022,STR0023,STR0024,STR0025,STR0026,STR0027,STR0028,STR0029,STR0030,STR0031,STR0032}	//"Janeiro"###"Fevereiro"###"Marco"###"Abril"###"Maio"###"Junho"###"Julho"###"Agosto"###"Setembro"###"Outubro"###"Novembro"###"Dezembro"
Private dDat			:=Ctod("  /  /  ")
Private cCliente		:=mv_par01
Private cLoja			:=mv_par02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := If(aReturn[4]==1,15,18)

If Empty(mv_par12)
	dbSelectArea("QPR")
	dbSetOrder(6)
	DbSeek(xFilial("QPR")+cPrd+cRevi+Dtos(dDatOP)+cLot)
Else 
	dbSelectArea("QPR")
	dbSetOrder(1)
	DbSeek(xFilial("QPR")+cOp)
EndIf
nPosQPR  := QPR->(RecNo())
nOrdQPR  := QPR->(IndexOrd())


dbSelectArea("SC2")
dbSetOrder(1)
If !Empty(QPR->QPR_OP)
	cSeek := QPR->QPR_OP
Else
	cSeek := cOp
Endif
If dbSeek(xFilial("SC2")+cSeek)
	nPosSC2  := SC2->(RecNo())
	nOrdSC2  := SC2->(IndexOrd())
	cRoteiro := SC2->C2_ROTEIRO
Endif

dbSelectArea("QPK")
dbSetOrder(1)
If !Empty(QPR->QPR_OP)
	cSeek := QPR->QPR_OP+cLot+cNumser
Else
	cSeek := cOp+cLot+cNumser
Endif
If dbSeek(xFilial("QPK")+cSeek)
	nPosQQ7  := QQ7->(RecNo())
	nOrdQQ7  := QQ7->(IndexOrd())
Endif
                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe amarração Cliente x Produto               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cCliente) .and. !Empty(QPR->QPR_CLIENT)
	If QPK->(FieldPos("QPK_CLIENT"))>0
		cCliente := QPK->QPK_CLIENT
		cLoja    := QPK->QPK_LOJA
	Else
		cCliente := QPR->QPR_CLIENT
		cLoja    := QPR->QPR_LOJA
	EndIF
EndIF 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01           // Resultados:1-Minimo/Maximo 2-Vlr.Unico ³
//³ mv_par02           // Observacao da Entrega:  1-Sim 2-Nao    ³
//³ mv_par03           // Justificativa do Laudo: 1-Sim 2-Nao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg1,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona em Registros de outros arquivos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QQ7")
dbSetOrder(1)
If dbSeek(xFilial("QQ7")+QPR->QPR_PRODUT+cCliente+cLoja)
	nPosQQ7  := QQ7->(RecNo())
	nOrdQQ7  := QQ7->(IndexOrd())
Endif

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+cCliente+cLoja)
	nPosSA1  := SA1->(RecNo())
	nOrdSA1  := SA1->(IndexOrd())
Endif

dbSelectArea("QP6")
dbSetOrder(1)
If !Empty(QPR->QPR_PRODUT)
	cSeek := QPR->QPR_PRODUT+Inverte(QPR->QPR_REVI)
Else
	cSeek := cPrd+Inverte(cRevi)
Endif
If dbSeek(xFilial("QP6")+cSeek)
	nPosQP6  := QP6->(RecNo())
	nOrdQP6  := QP6->(IndexOrd())
Endif

dbSelectArea("QPL")
dbSetOrder(3)
If dbSeek(xFilial("QPL")+QPK->QPK_OP+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+Space(TamSX3("QPL_OPERAC")[1])+Space(TamSX3("QPL_LABOR")[1]))
	dbSelectArea("QPD")
	dbSetOrder(1)
	If dbSeek(xFilial("QPD")+QPL->QPL_LAUDO)
		If QPD->QPD_CATEG == '4'
			MessageDlg(OemToAnsi(STR0035),OemToAnsi(STR0036),2)		//'Devido o laudo estar com Libera‡Æo Urgente, nÆo ser  poss¡vel emitir o Certificado de Qualidade.'###'Aten‡Æo'
			dbSelectArea("QPR")
			RetIndex("QPR")
			dbSetOrder(1)
			Set Filter To
			If File(cNomArq+OrdBagExt())
				Ferase(cNomArq+OrdBagExt())
			EndIf
			Return .T.
		EndIf	
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao do Certificado de qualidade ao Titulo.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo += " - " +QPK->QPK_CERQUA

If Empty(mv_par07)
	mv_par07 := 1
EndIf

SetRegua(mv_par07)

For nContador := 1 To mv_par07
	lPrimPag := .t.
	
	IncRegua(nContador)		//Incrementar a Regua
	If nContador > 1
		//Retorna a Ordem/Posicao Atual dos arquivos para  executar uma  nova  impressao do certificado
		QPR->(DbGoto(nPosQPR))
		QPR->(DbSetOrder(nOrdQPR))
		QQ7->(DbGoto(nPosQQ7))
		QQ7->(DbSetOrder(nOrdQQ7))
		SA1->(DbGoto(nPosSA1))
		SA1->(DbSetOrder(nOrdSA1))
		QP6->(DbGoto(nPosQP6))
		QP6->(DbSetOrder(nOrdQP6))
		SC2->(DbGoto(nPosSC2))
		SC2->(DbSetOrder(nOrdSC2))
		cOperacao:= ""
		cLabor:= ""
		lEnsaio		:=.F.
	EndIf
	nPag := 0

	cData := Upper(AllTrim(SM0->M0_CIDENT)+","+ Str(day(dDataBase),2) + STR0014 + aMeses[month(dDataBase)] + STR0014 + StrZero(year(dDataBase),4))		//" de "###" de "
	If !Empty(QPR->QPR_PRODUT)
		cProduto := AllTrim(QPR->QPR_PRODUT)+" - "+AllTrim(QP6->QP6_DESCPO) +" - "+QPR->QPR_REVI
	Else
		cProduto := AllTrim(cPrd)+" - "+AllTrim(QP6->QP6_DESCPO) +" - "+cRevi
	Endif
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cPrd))
	dProducao := DtoC(QPK->QPK_DTPROD)
	cGrupo	  := SB1->B1_GRUPO
	cSerie	  := ''
	If !Empty(QPR->QPR_NUMSER)
		cSerie :=QPR->QPR_NUMSER
	Endif
	If !Empty(QPR->QPR_OP)
		cOp := QPR->QPR_OP
	Endif
	SAH->(dbSeek(xFilial("SAH")+QPK->QPK_UM))
	cTamLote := Alltrim(str(QPK->QPK_TAMLOT))+" "+SAH->AH_UMRES
	// MATEUS HENGLE 
	cPedidox := SUBSTR(QPR->QPR_OP, 1,6)
	cItemx   := SUBSTR(QPR->QPR_OP, 7,2)
	cProdx   := ALLTRIM(QPR->QPR_PRODUT)
	cEndere := ''
			
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	IF DbSeek(xFilial("SC6")+cPedidox + cItemx + cProdx)
        If SC6->(FieldPos("C6_XENDPRO")) > 0			// 3L Systems - Luiz Alberto - 22-04-2014 - Campo Ainda Não Criado na SC6 Gerando Erro No Relatorio
			cEndere := SC6->C6_XENDPRO
		Endif
	ENDIF
		
	If Empty(cCliente)
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA))
		cCliente := AllTrim(SA1->A1_COD)+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME
	Endif
	Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+SC6->C6_XLACRE+SC6->C6_CLI+SC6->C6_LOJA))
	cLacre := SC6->C6_XLACRE + ' - ' + Z00->Z00_DESC
	cNumera:= 'De ' + AllTrim(Str(SC6->C6_XINIC,10)) + ' Ate ' + AllTrim(Str(SC6->C6_XFIM,10))
	cOPC   := Left(SC6->C6_OPC,30)
	cPedCli:= AllTrim(SC6->C6_PEDCLI)+'/'+AllTrim(SC6->C6_ITEMCLI)
	cCodProd  := ''
	SA7->(dbSetOrder(1)) 	         
	If SA7->(MsSeek( xFilial("SA7") + SC6->(C6_CLI+C6_LOJA+C6_PRODUTO) )) 
		If !Empty(SC6->C6_XCODCLI)
			cCodProd  := SC6->C6_XCODCLI
		Else
			cCodProd  := SA7->A7_CODCLI 
		Endif
	Endif
	cNota := SC6->C6_NOTA+'/'+SC6->C6_SERIE
	
    If Empty(cLot)
		cLot := SC6->C6_LOTECTL
	Endif


	ImpCabec()

	
		
	// MATEUS HENGLE
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chave de ligacao da medicao com outros arquivos              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChave := QQ7->QQ7_CHAVE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo do Texto-Amarracao Prod.xCliente QQ7    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par02 == 1
		dbSelectArea("QA2")
		dbSetOrder(1)
		If dbSeek(xFilial("QA2")+"QIPA070 "+cChave)
			oPrint:Say( Li, 0060, "OBS.:",oFont3c,100 )
			While QA2->(!Eof()) .And. xFilial("QA2") == QA2->QA2_FILIAL .And. QA2->QA2_CHAVE == cChave
				If Li > 2500
					ImpCabec()
				Endif
				oPrint:Say( Li, 0320, StrTran(QA2_TEXTO, "\13\10", ""),oFont3,100 )
				Li+=40
				dbSkip()
			EndDo
		EndIf
		Li++
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo do Texto superior                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTxt := "QPR0501"+".TXT"
	If File(cArqTxt)
		cTexto:=MemoRead(cArqTxt)
		For nC := 1 To MLCOUNT(cTexto,130)
			aLinha := MEMOLINE(cTexto,130,nC)
			cImpTxt   := ""
			cImpLinha := ""
			For nCount := 1 To Len(aLinha)
				cImpTxt := Substr(aLinha,nCount,1)
				If AT(cImpTxt,cAcentos)>0
					cImpTxt:=Substr(cAcSubst,AT(cImpTxt,cAcentos),1)
				EndIf
				cImpLinha := cImpLinha+cImpTxt
			Next nCount
			oPrint:Say( Li, 0320, cImpLinha,oFont3,100 )
			Li+=40
		Next nC
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo dos Ensaios especificado com Encontrado           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aAreaQPR	:= GetArea()
	dbSelectArea("QPR")
 	dbSetOrder(9)
    If dbSeek(xFilial("QPR")+QPK->QPK_OP+QPK->QPK_LOTE+QPK->QPK_NUMSER)
		While QPR->(!Eof()) .and. xFilial("QPR") == QPR->QPR_FILIAL .And. ;
			QPK->QPK_OP+QPK->QPK_LOTE+QPK->QPK_NUMSER == QPR->QPR_OP+QPR->QPR_LOTE+QPR->QPR_NUMSER
			lPula:= .T.
			lEnsaio:=.F.  
			nRecQPR := QPR->(Recno())
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Checa a existˆncia do registro na amarra‡Æo Produto x Cliente.    ³
			//³ Se existir, ser  impresso somente os ensaios selecionados.        ³
			//³ Se nÆo achar o registro, ser  impresso todos os ensaios, sem      ³
			//³ a checagem.                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			QQ7->(dbSetOrder(1))
			If QQ7->(dbSeek(xFilial("QQ7")+QPR->QPR_PRODUT+cCliente+cLoja,.T.))
				lChecaQQ7 := .T.
			Endif
			
			If lChecaQQ7
				If !QQ7->(dbSeek(xFilial("QQ7")+QPR->QPR_PRODUT+cCliente+cLoja+QPR->QPR_LABOR+;
							QPR->QPR_ENSAIO+cRoteiro+QPR->QPR_OPERAC))
					dbSkip()
					Loop
				EndIf	
			EndIf
			
			If  cOperacao == QPR->QPR_OPERAC .AND. cLabor == QPR->QPR_LABOR	.AND. cEnsaio == QPR->QPR_ENSAIO
				dbSkip()
				Loop
			EndIF
			
			If QIP50OC(cRoteiro)
				If cOperacao <> QPR->QPR_OPERAC
					cLabor := ""
					cEnsaio:=""		
			
					If !Empty(cOperacao)
						oPrint:Box( Li, 0040, Li,2350)
						Li+=60
					Endif
					
					cOperacao:= QPR->QPR_OPERAC
					oPrint:Say( Li, 0060, STR0033,oFont3c,100 )
					oPrint:Say( Li, 0320, QPR->QPR_OPERAC+ " - "+RetDesOper(QPR->QPR_OP,cOperacao,QPR->QPR_PRODUT,QPR->QPR_REVI),oFont3,100 )
				EndIf
			Endif
		
			
			If cLabor <> QPR->QPR_LABOR	
			    cEnsaio:=""		
				dbSelectArea("QP1")
				dbSetOrder(1)
				If dbSeek(xFilial("QP1")+QPR->QPR_ENSAIO)
	
					If QP1->QP1_TPCART <> "X"
						If QP7->(dbSeek(xFilial("QP7")+QPR->QPR_PRODUT+QPR->QPR_REVI+cRoteiro+QPR->QPR_OPERAC+QPR->QPR_ENSAIO))
							If QP7->QP7_CERTIF == "S"
								lPula := .F.
								cLabor:= QPR->QPR_LABOR
							EndIf
						EndIf
					Else	
						If QP8->(DbSeek(xFilial()+QPR->QPR_PRODUT+QPR->QPR_REVI+cRoteiro+QPR->QPR_OPERAC+QPR->QPR_ENSAIO))
							If QP8->QP8_CERTIF == "S"
								lPula := .F.
								cLabor:= QPR->QPR_LABOR
							EndIf
						EndIf
					EndIf
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Nao imprime ensaio que esta setado para nao constar no certificado. ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lPula
						cLabor:= " "
						DbSelectArea("QPR")
						DbSkip()
						Loop
					EndIf
	
					Li+=40
					oPrint:Say( Li, 0060, STR0015,oFont3c,100 )
					oPrint:Say( Li, 0320, QPR->QPR_LABOR,oFont3,100 )
					Li+=40
	
					lEnsaio:= .T.			
					If mv_par01 ==1 .And. QP1->QP1_TPCART <> "X"
						oPrint:Say( Li, 1700, STR0016,oFont3c,100 )
						oPrint:Say( Li, 2000, STR0017,oFont3c,100 )
					Else
						If QP1->QP1_CARTA$"XBR/XBS/XMR/IND/HIS/TXT"
							oPrint:Say( Li, 1700, STR0016,oFont3c,100 )
							oPrint:Say( Li, 2000, STR0017,oFont3c,100 )
						EndIf
					EndIf
				EndIf
	
				Li+=60
				If lEnsaio                              
					oPrint:Say( Li, 0060, TitSX3("QPR_ENSAIO")[1],oFont3c,100 )
					oPrint:Say( Li, 0900, TitSX3("QP7_METODO")[1],oFont3c,100 )
					oPrint:Say( Li, 1200, Subs(TitSX3("QP7_UNIMED")[1],1,9),oFont3c,100 )
					If mv_par01 ==1 .And. QP1->QP1_TPCART <> "X"                         
						oPrint:Say( Li, 1600, STR0018,oFont3c,100 )
						oPrint:Say( Li, 1800, STR0019,oFont3c,100 )
						oPrint:Say( Li, 2000, STR0018,oFont3c,100 )
						oPrint:Say( Li, 2200, STR0019,oFont3c,100 )
					Else
						If QP1->QP1_CARTA$"XBR/XBS/XMR/IND/HIS"
							oPrint:Say( Li, 1600, STR0018,oFont3c,100 )
							oPrint:Say( Li, 1800, STR0019,oFont3c,100 )
							oPrint:Say( Li, 2200, STR0042,oFont3c,100 )
						Else
							oPrint:Say( Li, 1600, STR0018,oFont3c,100 )
							oPrint:Say( Li, 1800, STR0019,oFont3c,100 )
							oPrint:Say( Li, 2000, STR0018,oFont3c,100 )
							oPrint:Say( Li, 2200, STR0019,oFont3c,100 )
						EndIf
					EndIf
					Li+=60
				EndIf
				If Li > 2500
					ImpCabec()
				EndIf
			EndIf
	
			dbSelectArea("QP1")
			dbSetOrder(1)
			If dbSeek(xFilial("QP1")+QPR->QPR_ENSAIO)
	
				If cEnsaio <> QPR->QPR_ENSAIO 
		
					If QP1->QP1_TPCART <> "X"
						dbSelectArea("QP7")
						dbSetOrder(1)
						If dbSeek(xFilial("QP7")+QPR->QPR_PRODUT+QPR->QPR_REVI+cRoteiro+QPR->QPR_OPERAC+QPR->QPR_ENSAIO)
							If QP7->QP7_CERTIF == "S"
								oPrint:Say( Li, 0060, QP1->QP1_DESCPO,oFont3,100 )
								oPrint:Say( Li, 0900, QP7->QP7_METODO,oFont3,100 )
	
								SAH->(dbSeek(xFilial("SAH")+QP7->QP7_UNIMED))
								oPrint:Say( Li, 1300, SAH->AH_UMRES,oFont3,100 )
	
								If mv_par01 = 1
									If QP7_MINMAX == "1"                          
										oPrint:Say( Li, 1600, QP7->QP7_LIE,oFont3,100 )
										oPrint:Say( Li, 1800, QP7->QP7_LSE,oFont3,100 )
									ElseIf QP7_MINMAX == "2"
										oPrint:Say( Li, 1600, QP7->QP7_LIE,oFont3,100 )
										oPrint:Say( Li, 1800, ">>>",oFont3,100 )
									ElseIf QP7_MINMAX == "3"
										oPrint:Say( Li, 1600, "<<<",oFont3,100 )
										oPrint:Say( Li, 1800, QP7->QP7_LSE,oFont3,100 )
									EndIf
								ElseIf QP1->QP1_CARTA$"XBR/XBS/XMR/IND/HIS"  
									oPrint:Say( Li, 1600, QP7->QP7_LIE,oFont3,100 )
									oPrint:Say( Li, 1800, QP7->QP7_LSE,oFont3,100 )
								Else
									oPrint:Say( Li, 1300, Padc(AllTrim(QP7->QP7_NOMINA), 38),oFont3,100 )
								Endif
								lEnsaio := .T.
							Else
								lEnsaio	:= .F.
							EndIf
						EndIf
					Else
						dbSelectArea("QP8")
						dbSetOrder(1)
						If dbSeek(xFilial()+QPR->QPR_PRODUT+QPR->QPR_REVI+cRoteiro+QPR->QPR_OPERAC+QPR->QPR_ENSAIO)
							If QP8->QP8_CERTIF == "S"
								If Li > 2500
									ImpCabec()
								EndIf
								oPrint:Say( Li, 0060, QP1->QP1_DESCPO,oFont3,100 )
								oPrint:Say( Li, 0900, QP8->QP8_METODO,oFont3,100 )
								lEnsaio := .T.
							Else
								lEnsaio	:= .F.
							EndIf	
						EndIf
					EndIf
				EndIF	    
			Endif
			If Li > 2500
				ImpCabec()
			EndIf
			dDat		:= QPR->QPR_DTMEDI
			cLote		:= QPR->QPR_LOTE
			cLaborat	:= QPR->QPR_LABOR
			cEnsaio		:= QPR->QPR_ENSAIO
			cOp			:= QPR->QPR_OP
			If lEnsaio
				dbSelectArea("QPR")
		 		dbSetOrder(9)
		    	IF dbSeek(xFilial("QPR")+cOp+cLote+QPK->QPK_NUMSER+cRoteiro+cOperacao+cLaborat+cEnsaio+dTos(dDat))
		
					lImpTxt  := .T.
					nVlrUnic := ""
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Defini‡Æo das vari veis para impressÆo:                            ³
					//³Cartas:XBR,XBS,XMR,IND,HIS,C,NP,U,P : nVlrMin,nVlrMax,nVlrUnic     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While QPR->(!Eof()) .And. xFilial("QPR") == QPR->QPR_FILIAL .And.;
						cPrd     	== QPR->QPR_PRODUT	.And.	cRevi		== QPR->QPR_REVI .And.;
						dDat		== QPR->QPR_DTMEDI	.And.	cLote		== QPR->QPR_LOTE .And.;  
						cLaborat	== QPR->QPR_LABOR	.And. 	cOperacao	== QPR->QPR_OPERAC .And. ;
						cOp			== QPR->QPR_OP .And. QPK->QPK_NUMSER  == QPR->QPR_NUMSER .And.;        
						cEnsaio	== QPR->QPR_ENSAIO				
						lEnsaio := .t.
						If lEnsaio
							If li > 2500
								ImpCabec()
							EndIf
			
							IncRegua()
					
							cChave:= QPR->QPR_CHAVE
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Os tipos de cartas:XBR|XBS|XMR|IND|HIS - Se o param. for "Minimo/  ³
							//³Maximo"-ira considerar o menor e o maior valor. Se o param. for    ³
							//³"Valor Unico-Ser  o maior valor encontrado ou menor fora da espec. ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If QP1->QP1_TPCART <> "X"
								If QP1->QP1_CARTA$"XBR/XBS/XMR/IND/HIS"
									dbSelectArea("QPS")
									dbSetOrder(1)
									If dbSeek(xFilial("QPS")+cChave)
										While QPS->(!Eof()) .And. 	QPS->QPS_FILIAL == xFilial("QPS") .And. ;
																QPS->QPS_CODMED == cChave
										
											nVlrMin:=IIF(SuperVal(QPS->QPS_MEDICA)<SuperVal(nVlrMin) .Or. ;
															SuperVal(nVlrMin)==0,QPS->QPS_MEDICA,nVlrMin)
											nVlrMax:=IIF(SuperVal(QPS->QPS_MEDICA)>SuperVal(nVlrMax),QPS->QPS_MEDICA,nVlrMax)
		
					 						If mv_par01 == 2 // Valor Unico
												nVlrUnic := Alltrim(Str(SuperVal(nVlrUnic) + SuperVal(QPS->QPS_MEDICA)))
												nMedia ++
											EndIf
					
											dbSkip()
										EndDo
									EndIf
								
								ElseIf QP1->QP1_CARTA$"C  /NP "
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Os tipos de carta : C / NP -Se o param. for "Minimo/Maximo", o Mi- ³
									//³nimo ser  0, o M ximo ser  o maior valor da 1a. medicao do QPS p/  ³
									//³cada data/hora. Sempre existem 1 medi‡Æo para cada data/hora.      ³
									//³Se param. for "Valor Unico" - Ser  o maior valor do QPS.           ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
									dbSelectArea("QPS")
									dbSetOrder(1)
									If dbSeek(xFilial("QPS")+cChave)
										While QPS->(!Eof()) .And. 	QPS->QPS_FILIAL == xFilial("QPS") .And. ;
																QPS->QPS_CODMED == cChave
																	
											nVlrMax:=IIF(SuperVal(QPS->QPS_MEDICA)>SuperVal(nVlrMax),QPS->QPS_MEDICA,nVlrMax)
		
											dbSkip()
										EndDo
										If mv_par01 == 2 // Valor Unico
											If SuperVal(nVlrMax) > SuperVal(QP7->QP7_LSE) .Or. SuperVal(nVlrUnic) == 0
												nVlrUnic:= nVlrMax
											EndIf
										EndIf
									EndIf
						
								ElseIf AllTrim(QP1->QP1_CARTA)=="U"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³O  tipo  de carta : U      -Se o param. for "Minimo/Maximo", o Mi- ³
									//³nimo ser  0, o M ximo ser  o maior valor da 2a. medicao do QPS p/  ³
									//³cada data/hora. Sempre existem 2 regs. medi‡äes para cada data/hora³
									//³Se param. for "Valor Unico" - Ser  a 2a. medi‡Æo do QPS para a 1a. ³
									//³data/hora.                                                         ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									dbSelectArea("QPS")
									dbSetOrder(1)
									If dbSeek(xFilial("QPS")+cChave)
										While QPS->(!Eof()) .And. 	QPS->QPS_FILIAL == xFilial("QPS") .And. ;
																QPS->QPS_CODMED == cChave
											If nV == 2
												nVlrMax:=IIF(SuperVal(QPS->QPS_MEDICA)>SuperVal(nVlrMax),QPS->QPS_MEDICA,nVlrMax)
												nV:=0
												If mv_par01 == 2 .And. lUnic
													nVlrUnic := QPS->QPS_MEDICA
													lUnic:= .F.
												EndIf
											EndIf
											nV++
											dbSkip()
										EndDo
									EndIf
							
								ElseIf AllTrim(QP1->QP1_CARTA)=="P"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³O  tipo  de carta : P      -Se o param. for "Minimo/Maximo", o Mi- ³
									//³nimo ser  0, o M ximo ser  o maior valor de :                      ³
									//³Amostra * (Porcent./100)                                           ³
									//³Se param. for "Valor Unico" - Ser  o maior valor da Amostra:       ³
									//³Amostra * (Porcent./100)                                           ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									dbSelectArea("QPS")
									dbSetOrder(1)
									If dbSeek(xFilial("QPS")+cChave)
										While QPS->(!Eof()) .And. 	QPS->QPS_FILIAL == xFilial("QPS") .And. ;
																QPS->QPS_CODMED == cChave
																
											If QPS->QPS_INDMED == "A"
												nAmostra := QPS->QPS_MEDICA
											ElseIf QPS->QPS_INDMED == "P"
												nPorcent := QPS->QPS_MEDICA
											EndIf
											If !Empty(nAmostra) .And. !Empty(nPorcent)
												nVlrMax:= IIF(SuperVal(nAmostra) * (SuperVal(nPorcent) / 100 ) > SuperVal(nVlrMax),SuperVal(nAmostra) * (SuperVal(nPorcent) / 100 ),nVlrMax)
												nAmostra:= ""
												nPorcent:= ""
												If mv_par01 == 2 // Valor Unico
		 				  							nVlrUnic:= Str(nVlrMax)
												EndIf
											EndIf
										dbSkip()
										EndDo
									EndIf
								EndIf
							Else	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³O tipo de Carta:TXT ir  o 1o. resultado encontrado ou Todas Med. ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If (Len(aTexto) == 0 .And. Len(aTxtRes) == 0) .Or. mv_par09 == 2
									aTexto  := {}
									aTxtRes := {}
									lImpTxT := .T.
									If Len(aTexto) == 0
										cTxt := QP8->QP8_TEXTO
										While ! Empty(cTxt)
										Aadd(aTexto, Left(cTxt, 23))
										cTxt := Subs(cTxt, 24, Len(cTxt))
										EndDo
									EndIf
		
									If Len(aTxtRes) == 0							
										dbSelectArea("QPQ")
										dbSetOrder(1)
										If dbSeek(xFilial()+cChave)
											cTxtRes:= QPQ->QPQ_MEDICA
											nX:=0
										
											While ! Empty(cTxtRes)
											Aadd(aTxtRes, Left(cTxtRes, 23))
											cTxtRes := Subs(cTxtRes, 24, Len(cTxtRes))
											EndDo
										Endif
									EndIf	
								
		
									nTot:= IIF(Len(aTexto)>Len(aTxtRes),Len(aTexto),Len(aTxtRes))
									For nC := 1 to nTot
										If lImpTxT
											If Len(aTexto) >= nC
												If	!Empty(aTexto[nC])          
													oPrint:Say( Li, 1600, Alltrim(aTexto[nC]),oFont3,100 )
												EndIf
											EndIf	
										EndIf
										If  Len(aTxtRes) >= nC
											If	!Empty(aTxtRes[nC])
												oPrint:Say( Li, 2000, AllTrim(aTxtRes[nC]),oFont3,100 )
											EndIf
										EndIf
										If Li > 2500
											ImpCabec()
										EndIf
										Li+=40
									Next nC
								Endif							
								
							EndIf
		
							If Li > 2500
								ImpCabec()
							EndIf
						Else
							Li+=40
						EndIf
						dbSelectArea("QPR")
						dbSkip()
					EndDo
					
				EndIf
				
				If QP1->QP1_CARTA$"XBR/XBS/XMR/IND/HIS" .and. mv_par01 == 2 // Valor Unico
					nVlrUnic := Alltrim(Str(SuperVal(nVlrUnic) /nMedia))
				EndIF   
			Endif
		
			If lEnsaio
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Faz impressÆo de todas as cartas                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QP1->QP1_TPCART <> "X"
					If QP1->QP1_CARTA$"XBR/XBS/XMR/IND/HIS"
						If mv_par01 == 1                   
							oPrint:Say( Li, 2000, AllTrim(nVlrMin),oFont3,100 )
							oPrint:Say( Li, 2200, AllTrim(nVlrMax),oFont3,100 )
						Else
							oPrint:Say( Li, 2000, Padc(AllTrim(nVlrUnic), 27),oFont3,100 )
						EndIf
					
					ElseIf AllTrim(QP1->QP1_CARTA)$"C/NP/U/P"
						If mv_par01 == 1
							oPrint:Say( Li, 2000, "0",oFont3,100 )
							If ValType(nVlrMax) = "N"
								oPrint:Say( Li, 2200, AllTrim(Str(nVlrMax)),oFont3,100 )
				   			Else                                                              
								oPrint:Say( Li, 2200, AllTrim(nVlrMax),oFont3,100 )
				      		EndIf
						Else
							oPrint:Say( Li, 2000, Padc(AllTrim(nVlrUnic), 27),oFont3,100 )
						EndIf
					EndIf
				EndIf
				If QP1->QP1_TPCART == "X"
					aTexto:={}
					aTxtRes:={}
				Else
					nVlrMin :=999999
					nVlrMax :=-999999
					nVlrUnic:=""
					lUnic   :=.T.
					nMedia  :=0
					Li+=40
				EndIf	
			EndIf
			dbSelectArea("QPR")
			dbSetOrder(9)
			dbGoTo(nRecQPR)
			dbSkip()
		
		EndDo
		oPrint:Box( Li, 0040, Li,2350)
	
		RestArea(aAreaQPR)
		lEnsaio := .T.	//Flag para impressao dos ensaios
	Endif

	dbSelectArea("QPL")
	dbSetOrder(2)                          
	If !Empty(cLote)
		cSeek := xFilial("QPL")+cOP+cLote+Space(TamSX3("QPL_OPERAC")[1])+Space(TamSX3("QPL_LABOR")[1])
	Else
		cSeek := xFilial("QPL")+cOP
	Endif
	If dbSeek(cSeek)
		dbSelectArea("QPD")
		dbSetOrder(1)
		If dbSeek(xFilial("QPD")+QPL->QPL_LAUDO)
			Li+=60
			oPrint:Say( Li, 0060, AllTrim(TitSX3("QPL_LAUDO")[1]),oFont3c,100 )
			oPrint:Say( Li, 0320, QPD->QPD_DESCPO,oFont3,100 )
			Li+=60

			// Impressão Assinatura Responsavel

			oPrint:SayBitmap( Li,1800,"samuel_ass.bmp",0400,0200 )

			oPrint:Say( Li, 0060, AllTrim(TitSX3("QPL_DTLAUD")[1]),oFont3c,100 )
			oPrint:Say( Li, 0320, Dtoc(QPL->QPL_DTLAUD),oFont3,100 )
			Li+=60
			If !Empty(QPL->QPL_QTREJ)
				SAH->(dbSeek(xFilial("SAH")+QPK->QPK_UM))
				oPrint:Say( Li, 0060, AllTrim(TitSX3("QPL_QTREJ")[1]),oFont3c,100 )
				oPrint:Say( Li, 0320, QPL->QPL_QTREJ+" "+SAH->AH_UMRES,oFont3,100 )
				Li+=60
			EndIf
			If mv_par03 == 1
				oPrint:Say( Li, 0060, AllTrim(TitSX3("QPL_JUSTLA")[1]),oFont3c,100 )
				oPrint:Say( Li, 0320, QPL->QPL_JUSTLA,oFont3,100 )
				Li+=60
			EndIf      

			oPrint:Say( Li, 1700, '_____________________________________',oFont3c,100 )
			Li+=40
			oPrint:Say( Li, 1800, 'SAMUEL A. BIGI',oFont3c,100 )
			Li+=40
			oPrint:Say( Li, 1800, 'GESTÃO DA QUALIDADE',oFont3c,100 )
			Li+=60
		Endif
	EndIf
	
	Li+=2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo das Informa‡äes Complementares   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTxt := "QPR0503"+".TXT"
	If File(cArqTxt)
		cTexto:=MemoRead(cArqTxt)
		For nC := 1 To MLCOUNT(cTexto,130)
			aLinha := MEMOLINE(cTexto,130,nC)
			cImpTxt   := ""
			cImpLinha := ""
			For nCount := 1 To Len(aLinha)
				cImpTxt := Substr(aLinha,nCount,1)
				If AT(cImpTxt,cAcentos)>0
					cImpTxt:=Substr(cAcSubst,AT(cImpTxt,cAcentos),1)
				EndIf
				cImpLinha := cImpLinha+cImpTxt
			Next nCount
			oPrint:Say( Li, 0320, cImpLinha,oFont3,100 )
			Li+=60
			If Li > 2500
				ImpCabec()
			EndIf
		Next nC
	EndIf
	
	Li+=2
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo do Texto inferior                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(cGrupo) $ GetNewPar("MV_MSGRPQ",'612/613/614/620/621')
		cTexto:= 'METALACRE METALACRE INDÚSTRIA E COMÉRCIO DE LACRES LTDA., INFORMA QUE O PRODUTO FORNECIDO ESTA EM CONFORMIDADE COM AS ESPECIFICAÇÕES '
		cTexto+= 'DEFINIDAS NA NORMA ISO/PAS 17712:2013 (E) - CLAUSES 4.1.3 E 5, SENDO CERTIFICADO NA REFERIDA NORMA ATRAVÉS DE SHANGHAI OUFU CONTAINER '
		cTexto+= 'SEAL CO, LTD. '
		cTexto+= 'CASO FOR DETECTADA UMA NÃO CONFORMIDADE (PRODUTO), SOLICITAMOS QUE SEJA ENCAMINHADA AO NOSSO DEPARTAMENTO COMERCIAL, A ETIQUETA DA '
		cTexto+= 'EMBALAGEM DO LOTE, ENCONTRADA DENTRO DAS CAIXAS, JUNTAMENTE COM A AMOSTRA EM QUESTÃO E OUTRAS INFORMAÇÕES QUE JULGAREM RELEVANTES'
	Else
		cTexto:= 'METALACRE INDÚSTRIA E COMÉRCIO DE LACRES LTDA., INFORMA QUE O PRODUTO CITADO ESTÁ EM CONFORMIDADE COM AS ESPECIFICAÇÕES REQUERIDAS '
		cTexto+= '(CONFORME ACORDADO NA ACEITAÇÃO DO PEDIDO), ATENDENDO PLENAMENTE TODOS OS REQUISITOS JUNTO AO NOSSO PADRÃO DE QUALIDADE, BALIZADO EM INSPEÇÕES '
		cTexto+= 'AMOSTRAIS DO PROCESSO. CASO FOR DETECTADA UMA NÃO CONFORMIDADE (PRODUTO),SOLICITAMOS QUE SEJA ENCAMINHADA AO NOSSO DEPARTAMENTO COMERCIAL, A '
		cTexto+= 'ETIQUETA DA EMBALAGEM DO LOTE, ENCONTRADA DENTRO DAS CAIXAS, JUNTAMENTE COM A AMOSTRA EM QUESTÃO E OUTRAS INFORMAÇÕES QUE JULGAREM RELEVANTES'
	Endif
	cTexto+=''
	cTexto+='"OBS: Os lacres fornecidos possui validade padrão de 2 anos após a data de fabricação, desde que armazenados adequadamente em local que esteja'
	cTexto+=' protegido de intempéries e efeitos climáticos (umidade e calor)."'
	//cArqTxt := "QPR0502"+".TXT"
	//If File(cArqTxt)
		//cTexto:=MemoRead(cArqTxt)
		For nC := 1 To MLCOUNT(cTexto,80)
			aLinha := MEMOLINE(cTexto,80,nC)
			cImpTxt   := ""
			cImpLinha := ""
			For nCount := 1 To Len(aLinha)
				cImpTxt := Substr(aLinha,nCount,1)
				If AT(cImpTxt,cAcentos)>0
					cImpTxt:=Substr(cAcSubst,AT(cImpTxt,cAcentos),1)
				EndIf
				cImpLinha := cImpLinha+cImpTxt
			Next nCount
			oPrint:Say( Li, 0320, cImpLinha,oFont3,100 )
			Li+=60
			If Li > 2500
				ImpCabec()
			EndIf
		Next nC
	//EndIf
	Li++
Next nContador
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QPR")
RetIndex("QPR")
dbSetOrder(1)
Set Filter To

If File(cNomArq+OrdBagExt())
	Ferase(cNomArq+OrdBagExt())
EndIf
MS_FLUSH()
Return .T.         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPR050   ºAutor  ³Renata Cavalcante   º Data ³  05/15/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para verificação se há ensaios com Certificado como  º±±
±±º          ³S(Sim) para a Operação. Tanto ensaios texto qto dimensionaisº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verificação dos Ensaios                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QIP50OC(cRoteiro)

Local aAreaQPR:= GETAREA("QPR")
Local aAreaQQ7:= GETAREA("QQ7")
Local lRetorno:=.F.

Dbselectarea("QP7")
Dbsetorder(1)

If DbSeek(xFilial("QP7")+QPR->QPR_PRODUT+QPR->QPR_REVI+cRoteiro+QPR->QPR_OPERAC+QPR->QPR_ENSAIO)
	While QP7->(!Eof())   .And. QP7->QP7_OPERAC == QPR->QPR_OPERAC
			If QP7->QP7_CERTIF == "S"
				lRetorno:= .T. 
				exit
			EndIf	 
			QP7->(DBSKIP())
	Enddo
Else

	DbSelectarea("QP8")
	Dbsetorder(1)

	If DbSeek(xFilial()+QPR->QPR_PRODUT+QPR->QPR_REVI+cRoteiro+QPR->QPR_OPERAC+QPR->QPR_ENSAIO)
		While QP8->(!Eof())   .And. QP8->QP8_OPERAC == QPR->QPR_OPERAC
			If QP8->QP8_CERTIF == "S"
				lRetorno:= .T.
				exit
			EndIf
			QP8->(DBSKIP())
		
		Enddo
	Endif
Endif

              
Restarea(aAreaQPR)
Restarea(aAreaQQ7)
Return(lRetorno)  




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPR050   ºAutor  ³Iolanda Vilanova    º Data ³  03/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³AJUSTASX1                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPR050                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1

Local aArea := GetArea()
dbSelectArea("SX1")
dbSetOrder(1)

If (SX1->(DbSeek("QPR051    "+"01")))
		RecLock("SX1",.F.)
		Replace SX1->X1_DEF01 With "Minimo/Maximo"		
		MsUnlock()
	
Endif

RestArea(aArea)





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA1","A1_CEP")
cCGCPict:=PesqPict("SA1","A1_CGC")

If !lPrimPag
   	oPrint:EndPage()
   	oPrint:StartPage() 
Else
   	lPrimPag := .f.
   	lEnc     := .t.
	oPrint:StartPage() 
EndIF  
oPrint:Say( 0020, 0040, " ",oFont,100 ) // startando a impressora   

//Cabecalho (Enderecos da Empresa e Fornecedor)
oPrint:Box( 0020, 0040, 0410,2350)
oPrint:Box( 0410, 0040, 2700,2350)

// Dados do Cliente

oPrint:Say( 0280, 1850, "Página(s):",oFont3c,100 )
oPrint:Say( 0330, 1850, "Data Impressão:",oFont3c,100 )
oPrint:Say( 0380, 1850, "Hora Impressão:",oFont3c,100 )

oPrint:Say( 0280, 2100, StrZero(++nPag,3), oFont3,100 )
oPrint:Say( 0330, 2100, DtoC(Date()), oFont3,100 )
oPrint:Say( 0380, 2100, Time(), oFont3,100 )

oPrint:Say( 0480, 0060, "Produto:",oFont3c,100 )
oPrint:Say( 0520, 0060, "Cliente:",oFont3c,100 )
oPrint:Say( 0560, 0060, "Data Produção:",oFont3c,100 )
oPrint:Say( 0560, 1400, "Lote:",oFont3c,100 )
oPrint:Say( 0600, 0060, "Ordem Produção:",oFont3c,100 )
oPrint:Say( 0600, 1400, "Tam.Lote:",oFont3c,100 )
oPrint:Say( 0640, 0060, "Personaliz:",oFont3c,100 )
oPrint:Say( 0640, 0800, "Numeracao:",oFont3c,100 )
oPrint:Say( 0640, 1400, "Comprimento:",oFont3c,100 )
oPrint:Say( 0680, 0060, "Endereço:",oFont3c,100 )
oPrint:Say( 0680, 0800, "Ped/Item Cliente:",oFont3c,100 )
oPrint:Say( 0680, 1400, "Cod.Mat.Cliente:",oFont3c,100 )

///////

oPrint:Say( 0440, 1500, cData,oFont3,100 )
oPrint:Say( 0480, 0320, cProduto,oFont3,100 )
oPrint:Say( 0560, 0320, dProducao,oFont3,100 )
oPrint:Say( 0560, 2000, "Série:",oFont3c,100 )
oPrint:Say( 0560, 2100, cSerie,oFont3,100 )
oPrint:Say( 0600, 0320, cOp,oFont3,100 )
oPrint:Say( 0600, 1700, cTamLote,oFont3,100 )
oPrint:Say( 0520, 0320, AllTrim(SA1->A1_COD)+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME,oFont3,100 )
oPrint:Say( 0640, 0320, cLacre,oFont3,100 )
oPrint:Say( 0640, 1000, cNumera,oFont3,100 )
oPrint:Say( 0640, 1700, cOpc,oFont3,100 )
oPrint:Say( 0680, 0320, cEndere,oFont3,100 )
oPrint:Say( 0680, 1150, cPedCli,oFont3,100 )
oPrint:Say( 0680, 1800, cCodProd,oFont3,100 )
oPrint:Say( 0520, 1400, "Nota:",oFont3c,100 )
oPrint:Say( 0520, 1700, cNota,oFont3,100 )
oPrint:Say( 0560, 1700, cLot,oFont3,100 )

/////////

//Cabecalho Produto do Pedido

If cEmpANT=='01'
	cBitmap      := FisxLogo("1")
	oPrint:SayBitmap( 0050,1800,"logotipopng.bmp",0500,0180 )
Endif

oPrint:Say( 0020, 0060, "CERTIFICADO QUALIDADE",oFont1,100 )

// Dados da Empresa/Filial

if (SM0->M0_ESTCOB == "SP")
   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 999.999.999.999"))
elseif (SM0->M0_ESTCOB == "RJ")
   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))
Else                                                                    
	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))	
endif

cEmail	:= 'vendas@metalacre.com.br'

oPrint:Say( 0130, 0060, SM0->M0_NOMECOM,oFont7,100 )
oPrint:Say( 0180, 0060, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB),oFont8,100 )
oPrint:Say( 0230, 0060, AllTrim(SM0->M0_CIDCOB)+" - "+ SM0->M0_ESTCOB+" "+"CEP: " + Transform(SM0->M0_CEPCOB,'@R 99999-999'), oFont8,100 )
oPrint:Say( 0280, 0060, "CNPJ: "+TransForm(AllTrim(SM0->M0_CGC),cCGCPict)+ " INSCR.EST.: " + inscEst ,oFont8,100 )
oPrint:Say( 0330, 0060, "FONE: "+AllTrim(SM0->M0_TEL) + " | " + AllTrim(SM0->M0_FAX) + " | " + AllTrim(SM0->M0_TEL_PO) + " Email: " + cEmail,oFont8,100 )

Li := 710
oPrint:Box( Li, 0040, Li,2350)
Li+=60

Return .T.

