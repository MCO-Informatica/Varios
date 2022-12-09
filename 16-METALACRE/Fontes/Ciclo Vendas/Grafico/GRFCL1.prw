#include "rwmake.ch"
#include "colors.ch"
#INCLUDE "PROTHEUS.CH"      
#include "msgraphi.ch"
#include "topconn.ch"                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ GRFCL1  ³ Autor ³ Luiz Alberto       ³ Data ³14/04/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Graficos Ciclo 1                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GRFCL1(cCodigo,cLoja)
Local aArea := GetArea()
Private aPosObj     := {} 
Private aObjects    := {}                        
Private aSize       := MsAdvSize( .F. ) 
Private aItensAC2   := {} 
Private aLegenda    := {}
Private aUsButtons  := {} 
Private nLinIni     := 0 
Private nRight      := 0 
Private nModelo     := 1 
Private nTipo	      := 1 
Private nLoop       := 0 

Private oDlg
Private oGraph
Private oListBox  
Private oMenu 
Private oBold
Private oCbx             
Private oTip             
Private oBut1     
Private _oDlg				// Dialog Principal

SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+cCodigo+cLoja))

Processa( {|| U_GRF001() } )           

RestArea(aArea)
Return .t.

User Function GRF001()
Local aArea	      := GetArea()
LOCAL aColors := {}
LOcal aSerie := {}
Local dDataDe	 	:= FirstDate(MonthSub(dDataBase,12))
Local dDataAte		:= LastDate(dDataBase)
Local cTitulo     	:= "Grafico de Vendas por Faturamento - Cliente: " + SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+Capital(SA1->A1_NOME)
Local cCfopVal		:= GetNewPar("MV_CLCFOP","5102/6102/7102")	// CFOP´s Validos para o Processo
                             
// Adiciona as cores padrao

AAdd( aColors,  CLR_HBLUE     )
AAdd( aColors,  CLR_HGREEN    )
AAdd( aColors,  CLR_HCYAN     )
AAdd( aColors,  CLR_HRED      )
AAdd( aColors,  CLR_HMAGENTA  )
AAdd( aColors,  CLR_YELLOW    )
AAdd( aColors,  CLR_WHITE     )
AAdd( aColors,  CLR_MAGENTA   )
AAdd( aColors,  CLR_BROWN     )
AAdd( aColors,  CLR_HGRAY     )
AAdd( aColors,  CLR_LIGHTGRAY )
AAdd( aColors,  CLR_BLUE      )
AAdd( aColors,  CLR_GREEN     )
AAdd( aColors,  CLR_CYAN      )
AAdd( aColors,  CLR_RED       )
AAdd( aColors,  CLR_GRAY      )
AAdd( aColors,  CLR_BLACK     )

cQuery := 	 " SELECT LEFT(D2_EMISSAO,6) ANOMES, SUM(D2_TOTAL) TOTAL "
cQuery +=	 " FROM " + RetSqlName("SD2") + " D2, " + RetSqlName("SF4") + " F4, " + RetSqlName("SB1") + " B1 "
cQuery +=	 " WHERE D2.D_E_L_E_T_ = '' "
cQuery +=	 " AND F4.D_E_L_E_T_ = '' "
cQuery +=	 " AND B1.D_E_L_E_T_ = '' "
cQuery +=	 " AND D2.D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery +=	 " AND B1.B1_COD = D2.D2_COD "
cQuery +=	 " AND F4.F4_CODIGO = D2.D2_TES "
cQuery +=	 " AND F4.F4_ESTOQUE = 'S' "
cQuery +=	 " AND F4.F4_DUPLIC = 'S' "
cQuery +=	 " AND F4.F4_FILIAL = D2.D2_FILIAL "
cQuery +=	 " AND B1.B1_FILIAL = D2.D2_FILIAL "
cQuery +=	 " AND D2.D2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
cQuery +=	 " AND D2.D2_CLIENTE = '" + SA1->A1_COD + "' AND D2.D2_LOJA = '" + SA1->A1_LOJA + "' "
//cQuery +=	 " AND RTRIM(D2.D2_CF) IN " + FormatIn(cCfopVal,'/')
cQuery +=	 " GROUP BY LEFT(D2_EMISSAO,6) "
cQuery +=	 " ORDER BY LEFT(D2_EMISSAO,6) "

TCQUERY cQuery NEW ALIAS "CHK1"
	
Count To nReg

If Empty(nReg)
	MsgStop("Atenção Cliente Não Possui Venda Localizada nos Últimos 12 Meses conforme Regra Especifica !")
	CHK1->(dbCloseArea())
	Return .f.
Endif

nTipo := GRP_LINE

DEFINE DIALOG oDlg TITLE cTitulo FROM 00,00 TO 550,1300 PIXEL 

@ 01,01 MSGRAPHIC oGraphic SIZE 650,240 OF oDlg
oGraphic:SetMargins(2,2,2,2)
oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetLegenProp( GRP_SCRRIGHT, CLR_WHITE, GRP_VALUES, GRP_FOOT )

oGraphic:l3D := .t.
nSerie := oGraphic:CreateSerie( nTipo,'',3,.f. ) 
		
nCor := 1
ProcRegua( nReg )
CHK1->(dbGoTop())
While CHK1->(!Eof()) 
	IncProc( "Processando Dados do Gráfico Aguarde..." ) 
		
	cSerie  := StrZero(nCor,2)
	nMes	:= Val(Right(AllTrim(CHK1->ANOMES),2))
	cLegenda:= Left(MesExtenso(nMes),3)+'/'+SubStr(CHK1->ANOMES,3,2)//+' - ('+TransForm(CHK1->QTDE,'@E 999,999.999')+")"

	oGraphic:Add(nSerie, CHK1->TOTAL, cLegenda, aColors[nCor] )//Capital(cLegenda) 

 //	nCor++                   
		
	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())	 
	
oGraphic:SetTitle('', cTitulo , CLR_HRED, A_LEFTJUST, GRP_TITLE )

@ 25,05 Button OemToAnsi("&Dimensão") Size 40,14 Action (oGraphic:l3D := !oGraphic:l3D)
@ 25,20 Button OemToAnsi("&GeraJPG")  Size 40,14 Action MySaveBmp( oGraphic )// When oGraphic:l3D
@ 25,35 BUTTON OemToAnsi("&Ampliar")  SIZE 40,14 ACTION ( oGraphic:ZoomIn() ) 
@ 25,50 BUTTON OemToAnsi("&Reduzir")  SIZE 40,14 ACTION ( oGraphic:ZoomOut() ) 
@ 25,65 BUTTON OemToAnsi("&Imprime")  SIZE 40,14 ACTION ( MontaRel(oGraphic) ) 
@ 25,80 Button OemToAnsi("&Sair")     Size 40,14 Action Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED            
	 
RestArea(aArea)
Return .t.	 



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                


*
*** MySaveBmp
*
* Grava a imagem do grafico no formato BMP

Static Function MySaveBmp( oGraphic )         
Local _cName := ''
Local _cBmpName := ''
Local _cWhereToSave := "\" // Somente gravar abaixo do rootpath do servidor

If AdmPath("*.JPEG")
	_cName := AdmArq()
	If at(".JPEG",upper(_cName)) > 0
		_cBmpName := alltrim(substr(_cName,rat("\",_cName)+1,len(_cName)))
	Else
		_cBmpName := alltrim(substr(_cName,rat("\",_cName)+1,len(_cName))) + ".JPEG"
	EndIf

	lSucesso := oGraphic:saveToImage(_cBmpName,"\","JPEG")
	If lSucesso
		_cArqDest := _cName + iif(at(".JPEG",upper(_cName)) > 0,"",".JPEG")
		_cArqOrig := "\" + _cBmpName

		copy file &_cArqOrig to &_cArqDest
		delete file &_cArqOrig

		MsgInfo("Arquivo: " + _cBmpName + " gerado com sucesso!")
	Else
		MsgStop("Não foi possível gerar o arquivo bitmap do gráfico")
	EndIf
EndIf
Return

Static Function MontaRel(oMSGraphic) 
Local cFile          
Local cPath := AllTrim(GetTempPath())

//lSucesso := oGraphic:saveToImage("Imprime.JPEG",cPath,"JPEG")
lSucesso := oGraphic:saveToImage("Imprime.JPEG","\","JPEG")
If lSucesso
	_cArqDest := cPath + "IMPRIME.JPEG"
	_cArqOrig := "\IMPRIME.JPEG"

	copy file &_cArqOrig to &_cArqDest
	delete file &_cArqOrig
EndIf

If !lSucesso
	MsgInfo("Nao Foi Possivel a Criação do Arquivo de Imagem do Grafico")
	Return .f.
Endif

//cTipo :=         "Bitmap (*.BMP)          | *.BMP | "
//cTipo := cTipo + "Todos os Arquivos  (*.*) |   *.*   |"

//cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos")

cFile := cPath + "Imprime.JPEG"

If Empty(cFile)
	MsgStop("Cancelada a Selecao!","Voce cancelou o Processo.")
	Return .f.
EndIf

//Objetos para tamanho e tipo das fontes
oFont1 	:= TFont():New( "Times New Roman",,08,,.T.,,,,,.F.)
oFont2 	:= TFont():New( "Tahoma",,16,,.T.,,,,,.F.)
oFont3	:= TFont():New( "Arial"       ,,20,,.F.,,,,,.F.)
oPrn 		:= tAvPrinter():New("Graficos")
oprn:SETPAPERSIZE(9) // <==== ajuste para papel A4
oPrn:Setlandscape()
oPrn:StartPage() //Inicia uma nova página // startando a impressora
oPrn:Say(0, 0, " ",oFont1,100) 

//             linha  colu     tam  largura
oPrn:Saybitmap(0100,0100,cFile,2900,2550)

oPrn:EndPage()
oPrn:Preview()
oPrn:End()

Return
                                                  
