#Include "QIER050.Ch"
#Include "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#define Confirma 1
#define Redigita 2
#define Abandona 3


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QIER050  ³ Autor ³     Marcelo Pimentel  ³ Data ³ 08.04.98 ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado de Qualidade.                                  ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQie                                                    ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao 					  ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Vera        ³14/04/99³------³ Inclusao da Loja do Fornecedor           ³±±
±±³CesarValadao³01/09/99³PROTHE³Retirada funcao FClose() apos MemoWrite() ³±±
±±³Paulo Emídio³16/08/00³Melhor³ Revisao e compatibilizacao da funcao     ³±±
±±³            ³        ³      ³ CTOD().                                  ³±±
±±³Paulo Emidio³29/09/00³------³Alteracao na exibicao de caracteres invali³±±
±±³            ³        ³      ³dos.                                      ³±±
±±³Robson Ramir³25/04/01³FNC   ³Alteracao para cabecalho grafico.         ³±±
±±³Paulo Emidio³21/05/01³META  ³ Alterado programa para que possa ser sele³±±
±±³       	   ³		³	   ³ cionado o Tipo da Nota Fiscal de Entrada ³±±
±±³       	   ³		³	   ³ sendo a mesma 1)Normal 2)Beneficiamento  ³±±
±±³       	   ³		³	   ³ 3)Devolucao.							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XQier050(lGerTXT,aDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpc    :=0 
Local oDlg
Local cTitulo :=""
Local cText1  :=""

Private lEnd  :=.F.
Private lEdit := .t.	// Para editar os textos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para montar Get.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aListBox  :={}
Private aMsg      :={}
Private aSel      :={}
Private aValid    :={}
Private aConteudo :={}
Private cPerg1    := "QER051"   
Private cRelDir   :=GetMv("MV_RELT") 

DEFAULT lGerTXT   := .F.
DEFAULT aDados := {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo := OemToAnsi(STR0001)	//"Certificado de Qualidade"
cText1  := OemToAnsi(STR0002)  	//"Neste relatorio sera impresso o Certificado de Qualidade"
R050IMP(lGerTXT,aDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura area                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R050GetList ³Autor³ Marcelo Pimentel      ³ Data ³ 19.03.98 ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Get para edicao de Elemento relacionado ao ListBox    ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIER050                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R050GetList(oListBox)
Local nAt :=oListBox:nAt

If nAt == 2 .Or. nAt == 3
	R050TEXT(oListBox)
ElseIf nAt == 4
	
	If Empty(Len(aDados))
		Pergunte(Perg1,.t.)
		//ALERT("TESTE1")
	EndIf	
Endif

Return    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R050Text    ³Autor³ Marcelo Pimentel      ³ Data ³ 08.04.98 ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Tela para preenchimento do conteudo relacionado com o ³±±
±±³          ³ListBox.                                                    ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIER050                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R050Text(oListBox)
Local cTexto      := ""
Local nOpca       := 2
Local oFontMet    := TFont():New("Courier New",6,0)
Local oDlgGet2
Local oTexto
Local oFontDialog := TFont():New("Arial",6,15,,.T.)
Local oBox1

nAt:=oListBox:nAt

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

cNomeArq := "QER050"+Str(nAt,1)+".TXT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le arquivo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTexto:=MemoRead(cNomeArq)
		
DEFINE MSDIALOG oDlgGet2 FROM	62,100 TO 345,610 TITLE  OemToAnsi(STR0008) PIXEL FONT oFontDialog		//"Itens de Configuracao"
@ 003, 004 TO 027, 250 LABEL "" 	OF oDlgGet2 PIXEL
@ 040, 004 TO 110, 250				OF oDlgGet2 PIXEL
@ 013, 010 MSGET oBox1 VAR aListBox[nAt] SIZE 235, 010 OF oDlgGet2 PIXEL
oBox1:lReadOnly := .t.

@ 050, 010 GET oTexto VAR cTexto MEMO NO VSCROLL WHEN lEdit SIZE 235, 051 OF oDlgGet2 PIXEL
oTexto:oFont := oFontMet
	
DEFINE SBUTTON FROM 120,190 TYPE 1 ACTION (nOpca := 1,oDlgGet2:End()) ENABLE OF oDlgGet2
DEFINE SBUTTON FROM 120,220 TYPE 2 ACTION (nOpca := 2,oDlgGet2:End()) ENABLE OF oDlgGet2
	
ACTIVATE MSDIALOG oDlgGet2 CENTERED

If nOpca == Confirma
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua gravacao do arquivo                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MemoWrit( cNomeArq,cTexto )
EndIf

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R050Imp  ³ Autor ³     Marcelo Pimentel  ³ Data ³ 08.04.98 ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado                                                ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQie                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R050Imp(lGerTXT,aDados)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Par„metros para a fun‡„o SetPrint () ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel    :="QIER050"
Local cString  :="QER"
Local cDesc1   :=STR0009		//"Neste relatorio sera impresso os Certificados"
Local cDesc2   :=""
Local cDesc3   :=""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nTipo      := 0
Private cTitulo    := STR0010	//"Certificado Qualidade"
Private cRelatorio := "QIER050"
Private cTamanho   := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault () ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0011, 1,STR0012,  1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private nLastKey := 0  
Private Perg     := "QER050"

nTipo := Iif(aReturn[4] == 1, 15, 18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01           // Fornecedor                             ³
//³ mv_par02           // Loja do Fornecedor                     ³
//³ mv_par03           // Produto                                ³
//³ mv_par04           // Data de Entrada                        ³
//³ mv_par05           // Lote                                   ³
//³ mv_par06           // Nota Fiscal                            ³
//³ mv_par07           // Serie                                  ³
//³ mv_par08           // Item          						 ³
//³ mv_par09           // Nr. Sequencial  						 ³
//³ mv_par10           // Nr. de Copias   						 ³
//³ mv_par11           // Impr. Ensaio Texto (Primeira/Todas)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Empty(Len(aDados))
	Pergunte(Perg,.T.)
	//ALERT("TESTE2")
Endif
	
cFilename := Criatrab(Nil,.F.)
			
lAdjustToLegacy := .T.   //.F.
lDisableSetup  := (!Empty(Len(aDados))) //.F.
oPrint := FWMSPrinter():New(cFilename, IMP_SPOOL, lAdjustToLegacy, , lDisableSetup)
//FWMSPrinter():New("DANFE", IMP_SPOOL)
oPrint:SetResolution(78)
oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetPaperSize(DMPAPER_A4) 
oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressğo em IMP_PDF 
cDiretorio := oPrint:cPathPDF
	
oFont  := TFont():New( "Arial",,16,,.t.,,,,,.f. )	
oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont5 := TFont():New( "Arial",,10,,.t.,,,,,.f. )  
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont7 := TFont():New( "Arial",,07,,.t.,,,,,.f. )  
oFont8 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,09,,.t.,,,,,.f. )  
oFont10:= TFont():New( "Arial",,10,,.f.,,,,,.f. ) 
oFont11:= TFont():New( "Arial",,11,,.t.,,,,,.f. )  
oFont12:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont14:= TFont():New( "Arial",,14,,.T.,,,,,.F. )
oFont16:= TFont():New( "Arial",,16,,.T.,,,,,.F. )
		
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

If !Empty(Len(aDados))
	For nI := 1 To Len(aDados)
		//³ mv_par01           // Fornecedor                             ³
		//³ mv_par02           // Loja do Fornecedor                     ³
		//³ mv_par03           // Produto                                ³
		//³ mv_par04           // Data de Entrada                        ³
		//³ mv_par05           // Lote                                   ³
		//³ mv_par06           // Nota Fiscal                            ³
		//³ mv_par07           // Serie                                  ³
		//³ mv_par08           // Item          						 ³
		//³ mv_par09           // Nr. Sequencial  						 ³
		//³ mv_par10           // Nr. de Copias   						 ³
		//³ mv_par11           // Impr. Ensaio Texto (Primeira/Todas)    ³
		
		MV_PAR01 := aDados[nI,1]
		MV_PAR02 := aDados[nI,2]
		MV_PAR03 := aDados[nI,3]
		MV_PAR04 := aDados[nI,4]
		MV_PAR05 := aDados[nI,5]
		MV_PAR06 := aDados[nI,6]
		MV_PAR07 := aDados[nI,7]
		MV_PAR08 := aDados[nI,8]
		MV_PAR09 := aDados[nI,9]
		MV_PAR10 := aDados[nI,10]
		MV_PAR11 := 0
		MV_PAR12 := aDados[nI,11]

		A050Imp(@lEnd,wnRel,cString,cTitulo,lGerTxt)   
	Next
Else
	A050Imp(@lEnd,wnRel,cString,cTitulo,lGerTxt)   
Endif

oPrint:EndPage()     // Finaliza a página
oPrint:Print()     // ViSCJliza antes de imprimir
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A050Imp  ³ Autor ³ Marcelo Pimentel      ³ Data ³ 08.04.98 ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡Æo dos Certificados                                   ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A050Imp(lEnd,wnRel,cString)                                ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQie                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A050Imp(lEnd,wnRel,cString,cTitulo,lGerTxt)
Local cData    := ""
Local cArqTxt  :=""
Local cTexto   :=""
Local cImpTxt  :=""
Local cEnsaio  :=""
Local cNomArq
Local cKey     :=""
Local cChave   :=""
Local cLabor   :=""
Local cProduto := ""
Local cRevi    :=""
Local cFornec  :=""
Local cLojFor  :=""
Local dDat     :=Ctod("  /  /  ")
Local cLote    :=""
Local cLaborat :=""
Local cAcentos := "€ú‡úúú…ú†úƒú úúˆú‚ú¡ú“ú”ú¢ú™ú£ú",cAcSubst := "C,c,A~A'a`a~a^a'E'e^e'i'o^o~o'O~U'"
Local aTexto   :={}
Local aTxtRes  :={}
Local aLinha   :={}
Local cImpLinha:={}
Local aMeses   := {STR0021,STR0022,STR0023,STR0024,STR0025,STR0026,STR0027,STR0028,STR0029,STR0030,STR0031,STR0032}	//"Janeiro"###"Fevereiro"###"Marco"###"Abril"###"Maio"###"Junho"###"Julho"###"Agosto"###"Setembro"###"Outubro"###"Novembro"###"Dezembro"
Local CbTxt
Local cbCont   :=00
Local cVlrMin  :=" "
Local cVlrMax  :=" "
Local cVlrUni  :=" "
Local nC       :=0
Local nCount   :=0
Local nV       :=1
Local nRec	   :=0
Local nAmostra :=0
Local nPorcent :=0
Local lUnic    :=.T.
Local nContador:=1
Local lImpTxt  := .T.
Local lMinFora := .F. 
Local cSeek    := ""
Local cNiseri  := ""
Local lNtEn    := .F.
Local cLaudo   := ""
Local lQReinsp := QieReinsp()
Local nQELRec  := 0
Private lFabric  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li       := 80
m_pag    := 1
Cabec1   := ""
Cabec2   := ""
nomeprog := "QIER050"

If !Empty(mv_par06)
	dbSelectArea("QEK")
	dbSetOrder(14)
	IF !(dbSeek(xFilial("QEK")+mv_par01+mv_par02+mv_par03+mv_par06+mv_par07))
        While !(Eof()) .and. xFilial("QEK")+mv_par01+mv_par02+mv_par03+mv_par06+mv_par07 ==;
	        QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF

    	    If !lNtEn
	    	    If DTOS(mv_par04) <> DTOS(QEK->QEK_DTENTR) .And. mv_par05 <> QEK->QEK_LOTE .And. mv_par08 <> QEK->QEK_ITEMNF
					lNtEn := .F.			 
				Else	
					If lQReinsp
						If QEK->QEK_NUMSEQ == mv_par09
							lNtEn := .T.
							Exit
						Endif
					Else
						lNtEn := .T.
						Exit
					Endif
				Endif		
			Endif

			dbSelectArea("QEK")
			dbSkip()
		Enddo
				
		If !lNtEn
			Set Device to Screen
			Help(" ",1,"QE_NAOENTR")	// "Entrada nao cadastrada."
			dbSelectArea("QER")
			dbSetOrder(1)
			Return
		Endif	
	Else
        While !(Eof()) .and. xFilial("QEK")+mv_par01+mv_par02+mv_par03+mv_par06+mv_par07 ==;
	        QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF

    	    If DTOS(mv_par04) == DTOS(QEK->QEK_DTENTR) .And. mv_par05 == QEK->QEK_LOTE .And. mv_par08 == QEK->QEK_ITEMNF
    	    	If lQReinsp
					If QEK->QEK_NUMSEQ == mv_par09
						cTitulo += " - "+QEK_CERQUA	
						Exit
					Endif
    	    	Else
					cTitulo += " - "+QEK_CERQUA	
					Exit
				Endif
			Endif
			dbSelectArea("QEK")
			dbSkip()
		Enddo
	EndIf
Else
	dbSelectArea("QEK")
	dbSetOrder(1)
	IF !(dbSeek(xFilial("QEK")+mv_par01+mv_par02+mv_par03+Inverte(mv_par04)+;
			Inverte(mv_par05)))
		Set Device to Screen
		Help(" ",1,"QE_NAOENTR")	// "Entrada nao cadastrada."
		dbSelectArea("QER")
		dbSetOrder(1)
		Return
	Else
		cTitulo += " - "+QEK_CERQUA	
	EndIf
EndIF

cCond := 'QER_FILIAL == "'+xFilial("QER") +'"'
cCond += '.And. QER_FORNEC=="'+mv_par01+'" .And.QER_LOJFOR=="'+mv_par02+'"'
cCond += '.And.QER_PRODUT=="'+mv_par03+'"'
cCond += '.And.DTOS(QER_DTENTR)=="'+DTOS(mv_par04)+'" .And.QER_LOTE=="'+mv_par05+'"'

cSeek := xFilial("QER")+mv_par03+QEK->QEK_REVI+mv_par01+mv_par02+DTOS(mv_par04)+mv_par05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01           // Resultados:1-Minimo/Maximo 2-Vlr.Unico ³
//³ mv_par02           // Observacao da Entrada:  1-Sim 2-Nao    ³
//³ mv_par03           // Justificativa do Laudo: 1-Sim 2-Nao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg1,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o Fornecedor ou Cliente se a NFE igual  a "B" ou "D"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QEK->QEK_TIPONF $ "D/B"
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR,.F.)
	cNomFor := SA1->A1_NOME
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR,.F.)
	cNomFor := SA2->A2_NOME

	dbSelectArea("SA5")
	dbSetOrder(1)
	If dbSeek(xFilial("SA5")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT,.F.)
		If !SA5->A5_FABREV$"F"
			If !Empty(SA5->A5_FABR)
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial("SA2")+SA5->A5_FABR+SA5->A5_FALOJA,.F.)
				cNomFor := SA2->A2_NOME
				//ALERT("REVENDEDOR "+CNOMFOR)
			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial("SA2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR,.F.)
				cNomFor := SA2->A2_NOME
				//ALERT("FABRICANTE "+CNOMFOR)
			EndIf
		EndIf
	EndIf
EndIf

dbSelectArea("QE6")
dbSetOrder(1)
dbSeek(xFilial("QE6")+QEK->QEK_PRODUT+Inverte(QEK->QEK_REVI))

If Empty(mv_par10)	//Nr. Copias
	mv_par10 := 1
EndIf

ProcRegua(mv_par10)

For nContador := 1 To mv_par10
	lPrimPag := .t.

	IncProc(nContador)		//Incrementar a Regua
	
	m_pag := 1

	ImpCabec()
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chave de ligacao da medicao com outros arquivos              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChave := QER->QER_CHAVE

	dbSelectArea("QER")
	DbSetOrder(1)
	dbGoTop()
	ProcRegua(RecCount())
	
	DbSeek(cSeek)
	lDadosFornec := .F.
	While !Eof() .and. &cCond

		IncProc()
		
		If lQReinsp
			If QER->QER_NUMSEQ <> mv_par09
				QER->(dbSkip())
				Loop
			Endif
		Endif
		
		If !Empty(mv_par06)
			If !(SubsTr(QER_NISERI,1,TamSX3("D1_DOC")[1]) == mv_par06 .And. ;
				SubsTr(QER_NISERI,TamSX3("D1_DOC")[1]+1,TamSX3("D1_SERIE")[1]) == mv_par07 .And. ;
				SubsTr(QER_NISERI,(TamSX3("D1_DOC")[1]+1+TamSX3("D1_SERIE")[1]),TamSX3("D1_ITEM")[1]) == mv_par08)
				
				QER->(dbSkip())
				Loop
			Endif
		EndIf

		If Li > 2500
            ImpCabec()
		EndIf


		dbSelectArea("SA5")
		dbSetOrder(2)
		If dbSeek(xFilial("SA5")+QEK->QEK_PRODUT+QEK->QEK_FORNEC+QEK->QEK_LOJFOR,.F.)
			lFabric := Iif(SA5->A5_FABREV$"F",.T.,.F.)
		EndIf

		dbSelectArea("QE1")
		dbSetOrder(1)
		If dbSeek(xFilial("QE1")+QER->QER_ENSAIO)
			If QE1->QE1_CARTA <> "TXT"
				dbSelectArea("QE7")
				dbSetOrder(1)
				If dbSeek(xFilial("QE7")+QER->QER_PRODUT+QER->QER_REVI+QER->QER_ENSAIO)
					SAH->(dbSeek(xFilial("SAH")+QE7->QE7_UNIMED))
					
					oPrint:Say( Li, 1850,PadC(AllTrim(SAH->AH_UMRES),50),oFont14,100 )
					//@Li,65 PSAY SAH->AH_UMRES
					
					If QER->QER_X_FABR == 'S'
						lDadosFornec := .T.
					Endif

					If QE7_MINMAX == "1"
						oPrint:Say( Li, 0800,QE7->QE7_LIE,oFont14,100 )
						oPrint:Say( Li, 1000,AllTrim(QE7->QE7_LSE),oFont14,100 )
					ElseIf QE7_MINMAX == "2"
						oPrint:Say( Li, 0800,QE7->QE7_LIE,oFont14,100 )
						oPrint:Say( Li, 1000,">>>",oFont14,100 )
					ElseIf QE7_MINMAX == "3"
						oPrint:Say( Li, 0800,"<<<",oFont14,100 )
						oPrint:Say( Li, 1000,AllTrim(QE7->QE7_LSE),oFont14,100 )
					EndIf
				EndIf
				oPrint:Say( Li, 0060,QE1->QE1_DESCPO,oFont14,100 )
			Else
				oPrint:Say( Li, 0060,QE1->QE1_DESCPO,oFont14,100 )
				dbSelectArea("QE8")
				dbSetOrder(1)
				dbSeek(xFilial()+QER->QER_PRODUT+QER->QER_REVI+QER->QER_ENSAIO)
			EndIf
			
			cProduto := QER->QER_PRODUT
			cRevi	 := QER->QER_REVI
			cFornec	 := QER->QER_FORNEC
			cLojFor	 := QER->QER_LOJFOR
			dDat	 := QER->QER_DTENTR
			cLote	 := QER->QER_LOTE
			cLaborat := QER->QER_LABOR
			cEnsaio	 := QER->QER_ENSAIO                                                              
	
	  
			dbSelectArea("QER")
			QER->(dbSetOrder(1))
			cSeekQER    := "QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+DTOS(QER_DTENTR)+QER_LOTE+QER_LABOR+QER_ENSAIO"
			cCompQER    := xFilial('QER')+cProduto+cRevi+cFornec+cLojFor+DTOS(dDat)+cLote+cLaborat+cEnsaio

			QER->(dbSetOrder(5))
			cSeekQER    := "QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+QER_NISERI+QER_TIPONF+QER_LOTE+QER_LABOR+QER_ENSAIO"
			cNiseri := QER->QER_NISERI
			cTipNoF := QER->QER_TIPONF			
			cCompQER    := xFilial('QER')+cProduto+cRevi+cFornec+cLojFor+cNiseri+cTipNoF+cLote+cLaborat+cEnsaio

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao das vari veis para impressao da Cartas de Controle:     ³
			//³ XBR,XBS,XMR,IND,HIS,C,NP,U,P : cVlrMin,cVlrMax,cVlrUni            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lImpTxt:= .T.
			lMinFora := .F.
			While !Eof() .And. cCompQER == &cSeekQER
				
				If lQReinsp
					If QER->QER_NUMSEQ <> mv_par09
						QER->(dbSkip())
						Loop
					Endif
				Endif

				If Li > 2500
		            ImpCabec()
				EndIf

				IncProc()
			
				cChave:= QER->QER_CHAVE
				cFabric:= QER->QER_X_FABR

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Os tipos de cartas:XBR|XBS|XMR|IND|HIS - Se o param. for "Minimo/  ³
				//³Maximo"-ira considerar o menor e o maior valor. Se o param. for    ³
				//³"Valor Unico-Ser  o maior valor encontrado ou menor fora da espec. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QE1->QE1_CARTA$"XBR/XBS/XMR/IND/HIS"
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMin:=If(SuperVal(QES_MEDICA)<SuperVal(cVlrMin) .Or. SuperVal(cVlrMin)==0,QES_MEDICA,cVlrMin)
							cVlrMax:=If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax) .Or. SuperVal(cVlrMax)==0,QES_MEDICA,cVlrMax)

							If mv_par01 == 2 // Valor Unico
								If SuperVal(cVlrMin) < SuperVal(QE7->QE7_LIE)
									cVlrUni := cVlrMin
									lMinFora:= .T.
								EndIf
								If !lMinFora
									If SuperVal(cVlrMax) > SuperVal(QE7->QE7_LSE) .Or. SuperVal(cVlrMax) > SuperVal(cVlrUni) .Or. SuperVal(cVlrUni) == 0
										cVlrUni := cVlrMax
									EndIf
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³O tipo de Carta:TMP (Tempo).						                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf QE1->QE1_CARTA == "TMP" 
				
	   				dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMin:=If(QA_HTOM(QES_MEDICA)<QA_HTOM(cVlrMin) .Or. Val(QA_HTOM(cVlrMin))==0,QES_MEDICA,cVlrMin)
							cVlrMax:=If(QA_HTOM(QES_MEDICA)>QA_HTOM(cVlrMax),QES_MEDICA,cVlrMax)

							If mv_par01 == 2 // Valor Unico
								If QA_HTOM(cVlrMin) < QA_HTOM(QE7->QE7_LIE)
									cVlrUni := cVlrMin
									lMinFora:= .T.
								EndIf
								If !lMinFora
									If QA_HTOM(cVlrMax) > QA_HTOM(QE7->QE7_LSE) .Or. QA_HTOM(cVlrMax) > QA_HTOM(cVlrUni) .Or. Val(QA_HTOM(cVlrUni)) == 0
										cVlrUni := cVlrMax
									EndIf
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³O tipo de Carta:TXT ir  o 1o. resultado encontrado.              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf QE1->QE1_CARTA == "TXT" .And. ;
						((Len(aTexto) == 0 .And. Len(aTxtRes) == 0) .Or. mv_par11 == 2)  // Imprime Todas Medicoes
					
					If Len(aTexto) == 0
						aTexto := QJustTxt(QE8->QE8_TEXTO,34)
					EndIf
				
					If Len(aTxtRes) == 0
						dbSelectArea("QEQ")
						dbSetOrder(1)
						dbSeek(xFilial()+cChave)
						aTxtRes := QJustTxt(QEQ_MEDICA,25)
					EndIf
				
					nTot:= IIF(Len(aTexto)>Len(aTxtRes),Len(aTexto),Len(aTxtRes))

					For nC := 1 to nTot
						If lImpTxT
							If Len(aTexto) >= nC
								If	!Empty(aTexto[nC])
									oPrint:Say( Li, 00800,aTexto[nC],oFont14,100 )
								EndIf
							EndIf	
						EndIf
						If  Len(aTxtRes) >= nC
							If	!Empty(aTxtRes[nC])
								oPrint:Say( Li, 01425,aTxtRes[nC],oFont14,100 )
							EndIf
						EndIf
						If Li > 2500
				            ImpCabec()
						EndIf
						//Li+=50
					Next nC
					lImpTxt:= .F.
					aTxtRes:= {}
					
				ElseIf QE1->QE1_CARTA$"C  /NP "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Os tipos de carta : C / NP -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor da 1a. medicao do QES p/  ³
					//³cada data/hora. Sempre existem 1 medi‡Æo para cada data/hora.      ³
					//³Se param. for "Valor Unico" - Ser  o maior valor do QES.           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMax := If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)
							dbSkip()
						EndDo
						If mv_par01 == 2 // Valor Unico
							If SuperVal(cVlrMax) > SuperVal(QE7->QE7_LSE) .Or. SuperVal(cVlrMax) > SuperVal(cVlrUni) .Or. SuperVal(cVlrUni) == 0
								cVlrUni := cVlrMax
							EndIf
						EndIf
					EndIf
			
				ElseIf AllTrim(QE1->QE1_CARTA)=="U"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O  tipo  de carta : U      -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor da 2a. medicao do QES p/  ³
					//³cada data/hora. Sempre existem 2 regs. medi‡äes para cada data/hora³
					//³Se param. for "Valor Unico" - Ser  a 2a. medi‡Æo do QES para a 1a. ³
					//³data/hora.                                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And. 	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							If nV == 2
								cVlrMax:=If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)
								nV:=0
								If mv_par01 == 2 .And. lUnic
									cVlrUni := QES_MEDICA
									lUnic:= .F.
								EndIf
							EndIf
							nV++
							dbSkip()
						EndDo
					EndIf
				
				ElseIf AllTrim(QE1->QE1_CARTA)=="P"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O  tipo  de carta : P      -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor de :                      ³
					//³Amostra * (Porcent./100)                                           ³
					//³Se param. for "Valor Unico" - Ser  o maior valor da Amostra:       ³
					//³Amostra * (Porcent./100)                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And. 	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
													
							If QES_INDMED == "A"
								nAmostra := SuperVal(QES_MEDICA)
							ElseIf QES_INDMED == "P"
								nPorcent := SuperVal(QES_MEDICA)
							EndIf
							If !Empty(nAmostra) .And. !Empty(nPorcent)
								cVlrMax:= If(nAmostra * (nPorcent / 100 )>SuperVal(cVlrMax),AllTrim(Str(nAmostra*(nPorcent/100))),cVlrMax)
								nAmostra:=0
								nPorcent:=0
								If mv_par01 == 2 // Valor Unico
									cVlrUni := IIF(ValType(cVlrMax)=="N",STR(cVlrMax),cVlrMax)
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf
				EndIf
				If Li > 2500
		            ImpCabec()
				EndIf
				dbSelectArea("QER")
				dbSkip()
				nRec:=Recno()
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz impressÆo de todas as cartas                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QE1->QE1_CARTA$"XBR/XBS/XMR/IND/HIS/TMP"
				If mv_par01 == 1
					oPrint:Say( Li, 01350,PadL(AllTrim(cVlrMin),15) + Iif(cFabric == 'S',' *',''),oFont14,100 )
					//oPrint:Say( Li, 01500,PadL(AllTrim(cVlrMax),15),oFont14,100 )
//					@Li,099 PSAY PadL(AllTrim(cVlrMin),15)
//					@Li,116 PSAY PadL(AllTrim(cVlrMax),15)
				Else
					oPrint:Say( Li, 01350,PadL(AllTrim(cVlrUni),15) + Iif(cFabric == 'S',' *',''),oFont14,100 )
//				    @Li,099 PSAY PadL(AllTrim(cVlrUni),15)
				EndIf
			ElseIf AllTrim(QE1->QE1_CARTA)$"C/NP/U/P"
				If mv_par01 == 1
					oPrint:Say( Li, 01350,PadL("0",15) + Iif(cFabric == 'S',' *',''),oFont14,100 )
					//oPrint:Say( Li, 01500,PadL(AllTrim(cVlrMax),15),oFont14,100 )
//					@Li,099 PSAY PadL("0",15)
//					@Li,116 PSAY PadL(AllTrim(cVlrMax),15)
				Else
					oPrint:Say( Li, 01350,PadL(AllTrim(cVlrUni),15) + Iif(cFabric == 'S',' *',''),oFont14,100 )
//					@Li,099 PSAY PadL(AllTrim(cVlrUni),15)
				EndIf
			EndIf
			
			If QE1->QE1_CARTA == "TXT"

				nTot:= IIF(Len(aTexto)>Len(aTxtRes),Len(aTexto),Len(aTxtRes))

				For nC := 1 to nTot
					If lImpTxT
						If Len(aTexto) >= nC
							If	!Empty(aTexto[nC])
								oPrint:Say( Li, 01350,aTexto[nC],oFont14,100 )
							EndIf
						EndIf	
					EndIf
					If  Len(aTxtRes) >= nC
						If	!Empty(aTxtRes[nC])
							//oPrint:Say( Li, 01400,aTxtRes[nC],oFont14,100 )
						EndIf
					EndIf
					If Li > 2500
			            ImpCabec()
					EndIf
					//Li+=50
				Next nC
				lImpTxt:= .F.

				aTexto:={}
				aTxtRes:={}
			Else
				cVlrMin := " "
				cVlrMax := " "
				cVlrUni := " "
				lUnic   :=.T.
//				Li+=50
			EndIf	
			Li+=50
            
			If Li > 2500
	            ImpCabec()
			EndIf
						
			dbSelectArea("QER")
			If nRec > 0
				dbGoTo(nRec)
			Else 
				QER->(dbSkip())
			Endif	
		EndIf
	EndDo

	dbSelectArea("QEL")

	cNiseri	:= QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF
	dbSetOrder(3) 
	cSeek	:= QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+cNiseri+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
	Space(TamSX3("QEL_LABOR")[1])

	If dbSeek(xFilial("QEL")+cSeek)
		dbSelectArea("QED")
		dbSetOrder(1)
		dbSeek(xFilial("QED")+QEL->QEL_LAUDO)
/*		Li+=2
		cLaudo := QaxIdioma("QED->QED_DESCPO","QED->QED_DESCIN","QED->QED_DESCES")
		@Li,01 PSAY AllTrim(TitSX3("QEL_LAUDO")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_LAUDO")[1])))+": "+cLaudo
		Li++
		@Li,01 PSAY AllTrim(TitSX3("QEL_DTLAUD")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_DTLAUD")[1])))+": "+Dtoc(QEL->QEL_DTLAUD)
		Li++
		@Li,01 PSAY AllTrim(TitSX3("QEL_DTVAL")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_DTVAL")[1])))+": "+Dtoc(QEL->QEL_DTVAL)
		Li++
		If !Empty(QEL->QEL_QTREJ)
			SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
			@Li,01 PSAY AllTrim(TitSX3("QEL_QTREJ")[1])+;
				Replicate(".",15-Len(AllTrim(TitSX3("QEL_QTREJ")[1])))+": "+;
				QEL->QEL_QTREJ+" "+SAH->AH_UMRES
			Li++
		EndIf
		If mv_par03 == 1
			@Li,01 PSAY AllTrim(TitSX3("QEL_JUSTLA")[1])+Replicate(".",15-Len(AllTrim(TitSX3("QEL_JUSTLA")[1])))+": "+QEL->QEL_JUSTLA
			Li++
		EndIf*/
	EndIf

	Li+=50
	If Li > 2500
       ImpCabec()
	EndIf

	oPrint:Line(Li, 0040,Li,2350,CLR_RED, "-8")
	Li+=100


	If lDadosFornec
		oPrint:Say(Li, 0060,"* Dados Informados Pelo Fornecedor: ",oFont14,100 )
		oPrint:Say(Li, 0800,cNomFor,oFont16,100 )
		Li+=50
	Endif
	
	//oPrint:Box(Li, 0040,Li+5,2350)
Next nContador

/*If Li != 80
	roda(CbCont,cbtxt,cTamanho)
EnDif*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QER")
Set Filter To
RetIndex("QER")
dbSetOrder(1)

If aReturn[5] == 1 
	//Set Printer To 
	dbCommitAll()
	//IIF(!lGerTXt,OurSpool(wnrel),.t.)
Endif

//MS_FLUSH()
Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ğÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
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

//Cabecalho Produto do Pedido

	cNiseri	:= QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF
	dbSelectArea("QEL")
	dbSetOrder(3)

	cSeek	:= QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+cNiseri+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
	Space(TamSX3("QEL_LABOR")[1])

	dbSeek(xFilial("QEL")+cSeek,.F.)


oPrint:SayBitmap( 0000,0050,"lgver.bmp",0550,0200 )
//oPrint:Box(0200, 0040,0205,2350)
oPrint:Line(0210, 0040,0210,2350,CLR_RED, "-8")
//oPrint:Say(0180, 1900, "www.verquimica.com.br",oFont14,100 )
oPrint:Say(0180, 1900, "www.verquimica.com.br", oFont14, , CLR_RED)

oPrint:Say( 0300, 0900, "CERTIFICADO DE ANÁLISE",oFont16,100 )

oPrint:Say( 0700, 0060, "Nota Fiscal:",oFont14,100 )
oPrint:Say( 0700, 1400, "Fabricação:",oFont14,100 )
oPrint:Say( 0900, 0060, "Lote Verquímica:",oFont14,100 )
oPrint:Say( 0900, 1400, "Validade:",oFont14,100 )

//oPrint:Box( 1090, 0040,1200,2350)
oPrint:Line(1090, 0040,1090,2350,CLR_RED, "-8")
oPrint:Line(1200, 0040,1200,2350,CLR_RED, "-8")

//oPrint:FillRect({1091,0043,1194,2347},oBrush)
oPrint:Say( 1120, 0060, "DETERMINAÇÃO",oFont14,100 )
oPrint:Say( 1120, 0800, "ESPECIFICAÇÃO",oFont14,100 )
oPrint:Say( 1120, 1400, "RESULTADOS",oFont14,100 )
oPrint:Say( 1120, 2020, "UNIDADE",oFont14,100 )

oPrint:Say( 1170, 0800, "Min",oFont14,100 )
oPrint:Say( 1170, 1030, "Max",oFont14,100 )

oPrint:Say( 0500, 0060,"Produto:",oFont14,100 )
If lFabric
	oPrint:Say( 0500, 1400,"Lote Fabricante:",oFont14,100 )
EndIf
oPrint:Say( 0500, 0410,QE6->QE6_DESCPO,oFont16,100 )
oPrint:Say( 0700, 0410,MV_PAR12,oFont16,100 )
oPrint:Say( 0700, 1750,DtoC(QEL->QEL_DTENLA),oFont16,100 )
oPrint:Say( 0900, 0410,QEK->QEK_LOTE,oFont16,100 )

If SB8->(dbSetOrder(5), dbSeek(xFilial("SB8")+QEK->QEK_PRODUT+QEK->QEK_LOTE))
	If lFabric
		oPrint:Say( 0500, 1750,SB8->B8_LOTEFOR,oFont16,100 )
	EndIf
	oPrint:Say( 0900, 1750,DtoC(QEL->QEL_DTVAL),oFont16,100 )
Endif
	
oPrint:Say(2500, 0170,"Responsável Técnico",oFont14,100 )
oPrint:Say(2550, 0060,"Eng. Químico - Fábio Roberto de Jesus",oFont14,100 )
oPrint:Say(2600, 0210,"CRQ - 04364989",oFont14,100 )

//oPrint:Say(2890, 0470, "Certificado de análise gerado eletronicamente em "+DTOC(QEL->QEL_DTLAUD)+", não necessita assinatura.",oFont14,100 )
oPrint:Say(2890, 0470, "Certificado de análise gerado eletronicamente em "+DTOC(QEL->QEL_DTDILA)+", não necessita assinatura.",oFont14,100 )

oPrint:Line(2910, 0040,2910,2350,CLR_RED, "-8")
oPrint:Say(2950, 0060, "Verquímica Indústria e Comércio de Produtos Químicos EIRELI",oFont11,100 )
oPrint:Say(3000, 0060, "Rua: Armandina Braga de Almeida, 158 - Jd. Santa Emilia - Guarulhos/SP - CEP 07141-003",oFont11,100 )
oPrint:Say(3050, 0060, "CNPJ 43.588.060/0001-80   Inscr. Estadual 336.125.845.118    Fone: 55 (11) 2404-8800",oFont11,100 )
oPrint:Say(3100, 0060, "Visite nosso site ",oFont11,100 )
oPrint:Say(3100, 0860, "Contate-nos ",oFont11,100 )

oPrint:Say(3100, 0405, "www.verquimica.com.br", oFont11, , CLR_BLUE)
oPrint:Say(3100, 1110, "laboratorio@verquimica.com.br", oFont11, , CLR_BLUE)

//oPrint:SayBitmap( 2950,01750,"logo_SGI-1.jpg",0180,0150 )
//oPrint:SayBitmap( 2950,01950,"Logo_SGI.jpg",0180,0150 )
//oPrint:SayBitmap( 2950,02150,"logo_prodir.png",0180,0150 )

Li := 1250
Return .T.
