#INCLUDE "Fileio.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"              
#INCLUDE "rwmake.CH"              
#include 'topconn.ch'    
#include "msgraphi.ch"

#DEFINE MAXGETDAD 4096
#Define CRLF  CHR(13)+CHR(10)

#DEFINE	VTORDEM		001		// OP
#DEFINE	VTCODIGO	002		// Produto
#DEFINE	VTCOMP		003		// Comprimento
#DEFINE	VTQTDE		004		// Quantidade
#DEFINE	VTENTR		005		// Entrega
#DEFINE	VTCLIENTE	006		// Cliente
#DEFINE	VTOBSER		007		// Observacoes
#DEFINE	VTGERA		008		// Geracao
#DEFINE	VTIMPR		009		// Impressao
#DEFINE	VTLIBE		010		// Liberacao
#DEFINE	VTMP		011		// Materia Prima
#DEFINE	VTTERC		012		// Terceiros
#DEFINE	VTABST		013		// Abastecimento
#DEFINE	VTGRAV		014		// Gravacao
#DEFINE	VTCORTE		015		// Corte
#DEFINE	VTPRE		016		// Prensa
#DEFINE	VTCOL		017		// Col
#DEFINE	VTCC		018		// CC
#DEFINE	VTMTG		019		// Montagem
#DEFINE	VTCQ		020		// Controle de Qualidade
#DEFINE	VTEMB		021		// Embalagem
#DEFINE	VTINFO		022		// Informacoes

/*                                        l
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  PNCobranca   บAutor  ณ Luiz Alberto    บ Data ณ  28/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Painel geral para setor de cobran็a panther            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User FUNCTION PnPCP()
Local aArea := GetArea()
Local aObjects		:= {}
Local aInfo 		:= {}
Local aPosGet		:= {}
Local aPosObj		:= {}
Local nOpcA       := 0
Local aColors	:=	{}

Private oDlg
Private aTempTit:= {}
Private aStatAula := {}
Private oDlg
Private oFolder1
Private oGet01
Private oGet02
Private oGet03
Private oGet04
Private oGet05
Private oGet06
Private oGet07
Private oCmpCodi
Private cCmpCodi
Private oCmpNome
Private cCmpNome
Private oCmpEnde
Private cCmpEnde
Private oCmpMune
Private cCmpMune
Private oCmpUF
Private cCmpUF
Private oCmpBair
Private cCmpBair
Private oCmpCont
Private cCmpCont
Private lContatos := .f.
Private lContrato := .f.
Private lFinanceiro := .f.
Private lHistorico := .f.
Private cPerg := PadR("PRMHIS",10)
Private aTitulos := {'Ordem','Material','Comprimento','Qtde.','Entrega','Cliente','Observa็๕es','Gera็ใo','Impressใo','Libera็ใo','M.P.','Terc.','Abst','Grav','Corte','Pre','Col','C.C.','MTG','CQ','Emb','Informa็๕es'}

aSizeAut	:= MsAdvSize(,.F.)
aadd( aObjects, { 0,    30, .T., .F. } )
aadd( aObjects, { 100, 100, .T., .T. } )
aadd( aObjects, { 0,    3, .T., .F. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})

aGrupos		:= 	{}
aOrdens		:= 	{{'','','',0,CtoD(''),'',CtoD(''),CtoD(''),'','','','','','','','','','','','','',''}}

cBsqNome	:= Space(50)
cBsqEnde	:= Space(50)
cBsqTele	:= Space(50)
cBsqCont	:= Space(50)
cBsqCodi	:= Space(06)
nAnoRef		:= Year(dDataBase)
nRadio		:= 1

nContratos := 0
nContatos := 0
nTitAberto := 0
nTitVencid := 0

PrcGrupos(@aGrupos)

cGrupo := aGrupos[1]


lSai := .t.
While lSai
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Painel Gerencial - Cobran็a: "+ SM0->M0_CODIGO + ' - ' + Capital(SM0->M0_NOMECOM)) From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL Style DS_MODALFRAME 
	
	
	@ 030, 005 LISTBOX oStOrdens 	Fields HEADER  SIZE 640, 220 OF oDlg PIXEL ColSizes 50,50

/*	@ 010, 455 SAY 		oBsqNome PROMPT "Nome: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 010, 505 MSGET 	oGtBsqNo VAR cBsqNome Picture '@!' Valid( Processa({|| Iif(!Empty(cBsqNome),(PrcGeral(1,@aClientes),RefCli(.T.),oStOrdens:SetFocus()),.t.) },"Processando...") )  SIZE 100, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL

	@ 025, 455 SAY 		oBsqNome PROMPT "Endere็o: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 025, 505 MSGET 	oGtBsqNo VAR cBsqEnde Picture '@!' Valid( Processa({|| Iif(!Empty(cBsqEnde),(PrcGeral(1,@aClientes),RefCli(.T.),oStOrdens:SetFocus()),.t.) },"Processando...") ) SIZE 100, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL

	@ 040, 455 SAY 		oBsqNome PROMPT "Telefone: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 040, 505 MSGET 	oGtBsqNo VAR cBsqTele Picture '@!' Valid( Processa({|| Iif(!Empty(cBsqTele),(PrcGeral(1,@aClientes),RefCli(.T.),oStOrdens:SetFocus()),.t.) },"Processando...") ) SIZE 100, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL

	@ 055, 455 SAY 		oBsqNome PROMPT "Contato: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 055, 505 MSGET 	oGtBsqNo VAR cBsqCont Picture '@!' Valid( Processa({|| Iif(!Empty(cBsqCont),(PrcGeral(1,@aClientes),RefCli(.T.),oStOrdens:SetFocus()),.t.) },"Processando...") ) SIZE 100, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
  */
//	@ 070, 455 SAY 		oBsqCodi PROMPT "Codigo: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
//	@ 070, 505 MSGET 	oGtBsqCd VAR cBsqCodi Picture '@!' Valid( Processa({|| Iif(!Empty(cBsqCodi),(PrcGeral(1,@aClientes),RefCli(.T.),oStOrdens:SetFocus()),.t.) },"Processando...") ) SIZE 040, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL

	oStOrdens := TWBrowse():New( 030,005,640,220,,aTitulos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oStOrdens:SetArray( aOrdens )         
	oStOrdens:aHeaders := aTitulos
	oStOrdens:aColumns := aTitulos
	oStOrdens:ACOLSIZES := {40,30,10,10,10,40,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20}
	oStOrdens:lHScroll     := .T.
	oStOrdens:lVScroll     := .T.
	oStOrdens:bLine := {|| {	aOrdens[oStOrdens:nAt,VTORDEM],;
						      	aOrdens[oStOrdens:nAt,VTCODIGO],;
						      	aOrdens[oStOrdens:nAt,VTCOMP],;
						      	TransForm(aOrdens[oStOrdens:nAt,VTQTDE],'9,999,999,999'),;
						      	aOrdens[oStOrdens:nAt,VTENTR],;
						      	aOrdens[oStOrdens:nAt,VTCLIENTE],;
						      	aOrdens[oStOrdens:nAt,VTOBSER],;
						      	aOrdens[oStOrdens:nAt,VTGERA],;
						      	aOrdens[oStOrdens:nAt,VTIMPR],;
						      	aOrdens[oStOrdens:nAt,VTLIBE],;
						      	aOrdens[oStOrdens:nAt,VTMP],;
						      	aOrdens[oStOrdens:nAt,VTABST],;
						      	aOrdens[oStOrdens:nAt,VTGRAV],;
						      	aOrdens[oStOrdens:nAt,VTCORTE],;
						      	aOrdens[oStOrdens:nAt,VTPRE],;
						      	aOrdens[oStOrdens:nAt,VTCOL],;
						      	aOrdens[oStOrdens:nAt,VTCC],;
						      	aOrdens[oStOrdens:nAt,VTMTG],;
						      	aOrdens[oStOrdens:nAt,VTCQ],;
						      	aOrdens[oStOrdens:nAt,VTEMB],;
						      	aOrdens[oStOrdens:nAt,VTINFO]}}
	oStOrdens:nFreeze := 2


//	oStOrdens:bLDblClick := {|| CmpCli(oStOrdens:nAt) }
//	oStOrdens:bChange := {|| CmpCli(oStOrdens:nAt) }

	@ 010, 005 MSCOMBOBOX 	oGrupo VAR cGrupo	ITEMS 	aGrupos SIZE 90,10 OF oDlg  PIXEL ON CHANGE (MsAguarde({|| (PrcProd(@aOrdens,cGrupo),RefCli())},"Aguarde...","Processando...",.T.))

/*	@ 155, 005 SAY 		"Codigo: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 155, 055 MSGET 	oCmpCodi VAR cCmpCodi Picture '@!' SIZE 030, 010 WHEN .F. OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 170, 005 SAY 		"Nome: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 170, 055 MSGET 	oCmpNome VAR cCmpNome Picture '@!' SIZE 200, 010 WHEN .F. OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 185, 005 SAY 		"Endere็o: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 185, 055 MSGET 	oCmpEnde VAR cCmpEnde Picture '@!' SIZE 200, 010 WHEN .F. OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 185, 290 SAY 		"Bairro: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 185, 330 MSGET 	oCmpBair VAR cCmpBair Picture '@!' SIZE 100, 010 WHEN .F. OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 200, 005 SAY 		"Cidade: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 200, 055 MSGET 	oCmpMune VAR cCmpMune Picture '@!' SIZE 100, 010 WHEN .F. OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 200, 290 SAY 		"UF: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 200, 330 MSGET 	oCmpUF VAR cCmpUF Picture '@!' SIZE 030, 010 WHEN .F. OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 215, 005 SAY 		"Contato/Fone: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 215, 055 MSGET 	oCmpCont VAR cCmpCont Picture '@!' SIZE 200, 010 WHEN .F. OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL

	@ 100, 455 SAY 		oCmp1 PROMPT "No. Contratos: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 115, 455 SAY 		oCmp2 PROMPT "No. Titulos Aberto: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 130, 455 SAY 		oCmp3 PROMPT "No. Titulos Vencidos: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 145, 455 SAY 		oCmp4 PROMPT "No. Contatos: " SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL

	@ 100, 600 SAY 		oNosCont PROMPT nContratos Picture '9999' SIZE 150, 010 OF oDlg COLORS CLR_GREEN,CLR_WHITE PIXEL
	@ 115, 600 SAY 		oNosTitu PROMPT nTitAberto Picture '9999' SIZE 150, 010 OF oDlg COLORS CLR_GREEN,CLR_WHITE PIXEL
	@ 130, 600 SAY 		oNosTitV PROMPT nTitVencid Picture '9999' SIZE 150, 010 OF oDlg COLORS CLR_RED,CLR_WHITE PIXEL
	@ 145, 600 SAY 		oNContat PROMPT nContatos  Picture '9999' SIZE 150, 010 OF oDlg COLORS CLR_BLUE,CLR_WHITE PIXEL
	
	oCmp1:oFont := TFont():New('Arial',,18,,.F.,,,,.T.,.F.)
	oCmp2:oFont := TFont():New('Arial',,18,,.F.,,,,.T.,.F.)
	oCmp3:oFont := TFont():New('Arial',,18,,.F.,,,,.T.,.F.)
	oCmp4:oFont := TFont():New('Arial',,18,,.F.,,,,.T.,.F.)
	oNosCont:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oNosTitu:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oNosTitV:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oNContat:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.) */

	PrcProd(@aOrdens,cGrupo)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 0,oDlg:End()})
	  
	If nOpca = 1
	Endif
	lSai := .f.
Enddo 
Return .t.






Static Function RefCli(lTopo)

DEFAULT lTopo := .f.    

	oStOrdens:SetArray(aOrdens)
	oStOrdens:bLine := {|| {	aOrdens[oStOrdens:nAt,VTORDEM],;
						      	aOrdens[oStOrdens:nAt,VTCODIGO],;
						      	aOrdens[oStOrdens:nAt,VTCOMP],;
						      	TransForm(aOrdens[oStOrdens:nAt,VTQTDE],'9,999,999,999'),;
						      	aOrdens[oStOrdens:nAt,VTENTR],;
						      	aOrdens[oStOrdens:nAt,VTCLIENTE],;
						      	aOrdens[oStOrdens:nAt,VTOBSER],;
						      	aOrdens[oStOrdens:nAt,VTGERA],;
						      	aOrdens[oStOrdens:nAt,VTIMPR],;
						      	aOrdens[oStOrdens:nAt,VTLIBE],;
						      	aOrdens[oStOrdens:nAt,VTMP],;
						      	aOrdens[oStOrdens:nAt,VTABST],;
						      	aOrdens[oStOrdens:nAt,VTGRAV],;
						      	aOrdens[oStOrdens:nAt,VTCORTE],;
						      	aOrdens[oStOrdens:nAt,VTPRE],;
						      	aOrdens[oStOrdens:nAt,VTCOL],;
						      	aOrdens[oStOrdens:nAt,VTCC],;
						      	aOrdens[oStOrdens:nAt,VTMTG],;
						      	aOrdens[oStOrdens:nAt,VTCQ],;
						      	aOrdens[oStOrdens:nAt,VTEMB],;
						      	aOrdens[oStOrdens:nAt,VTINFO]}}


oStOrdens:Refresh()

If lTopo  
	If oStOrdens:nAt > Len(aOrdens)
		oStOrdens:nAt := 1
	Endif
Endif
oStOrdens:Refresh()
oDlg:Refresh()
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ U_CEstat บAutor ณLuiz Alberto V Alvesบ Data ณ  10/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento das Informa็๕es                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrcGrupos(aGrupos)
Local aArea 	:= GetArea()

aGrupos := {}

If Select("KAD1") <> 0
	KAD1->(dbCloseArea())
Endif

cQuery := 	 "	SELECT DISTINCT B1_GRUPO, "
cQuery +=	 " 	BM_DESC "
cQuery +=	 "  FROM " + RetSqlName("SC2") + " C2 (NOLOCK) "
cQuery +=	 "  INNER JOIN " + RetSqlName("SB1") + " B1 (NOLOCK) "
cQuery +=	 "  ON B1_FILIAL = C2_FILIAL AND B1_COD = C2_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery +=	 "  INNER JOIN " + RetSqlName("SBM") + " BM (NOLOCK) "
cQuery +=	 "  ON BM_FILIAL = C2_FILIAL AND BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = '' "
cQuery +=	 "  LEFT JOIN " + RetSqlName("SC6") + " C6 (NOLOCK) "
cQuery +=	 "  ON C6_FILIAL = C2_FILIAL AND C2_PEDIDO = C6_NUM AND C2_ITEMPV = C6_ITEM AND C6.D_E_L_E_T_ = '' "
cQuery +=	 "  LEFT JOIN " + RetSqlName("SA1") + " A1 (NOLOCK) "
cQuery +=	 "  ON A1.A1_COD = C6.C6_CLI AND A1.A1_LOJA = C6.C6_LOJA AND A1.D_E_L_E_T_ = '' "
cQuery +=	 "  LEFT JOIN " + RetSqlName("SA2") + " A2 (NOLOCK) "
cQuery +=	 "  ON A2.A2_COD = C2.C2_XFORNEC AND A2.A2_LOJA = C2.C2_XLOJA AND A2.D_E_L_E_T_ = '' "
cQuery +=	 "  WHERE C2_DATRF = '' "
cQuery +=	 "  AND C2_QUJE < C2_QUANT "
cQuery +=	 " 	ORDER BY B1_GRUPO "

TCQUERY cQuery NEW ALIAS "KAD1"

	Count To nReg
	
	dbGoTop()
	
	ProcRegua(nReg)
	While KAD1->(!Eof())
		IncProc("Processando Grupos, Aguarde...")
		
		AAdd(aGrupos,Capital(KAD1->BM_DESC))

		KAD1->(dbSkip(1))
	Enddo
	
	KAD1->(dbCloseArea())
	
	If Empty(nReg)                                          
		aGrupos := 	{''}
	Endif

RestArea(aArea)
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ U_CEstat บAutor ณLuiz Alberto V Alvesบ Data ณ  10/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento das Informa็๕es                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrcProd(aOrdens,cGrupo)
Local aArea 	:= GetArea()

aOrdens := {}

If Select("KAD1") <> 0
	KAD1->(dbCloseArea())
Endif

cQuery := 	 " 	SELECT C2_NUM+C2_ITEM+C2_SEQUEN OP, "
cQuery +=	 "	C2_PRODUTO, "
cQuery +=	 "  C2_OPC, "
cQuery +=	 "  C2_QUANT,  "
cQuery +=	 "  C2_DATPRF, "
cQuery +=	 "  NOME = "
cQuery +=	 "  CASE "
cQuery +=	 "  WHEN ISNULL(A1.A1_NOME,'') <> '' THEN ISNULL(A1.A1_NOME,'') "
cQuery +=	 "  WHEN ISNULL(A2.A2_NOME,'') <> '' THEN ISNULL(A2.A2_NOME,'') "
cQuery +=	 "  ELSE "
cQuery +=	 "  '' "
cQuery +=	 "  END, "
cQuery +=	 "  C2.C2_EMISSAO , "
cQuery +=	 "  C2.C2_XDTIMP  "
cQuery +=	 "  FROM " + RetSqlName("SC2") + " C2 (NOLOCK) "
cQuery +=	 "  INNER JOIN " + RetSqlName("SB1") + " B1 (NOLOCK) "
cQuery +=	 "  ON B1_FILIAL = C2_FILIAL AND B1_COD = C2_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery +=	 "  INNER JOIN " + RetSqlName("SBM") + " BM (NOLOCK) "
cQuery +=	 "  ON BM_FILIAL = C2_FILIAL AND BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = '' "
cQuery +=	 "  LEFT JOIN " + RetSqlName("SC6") + " C6 (NOLOCK) "
cQuery +=	 "  ON C6_FILIAL = C2_FILIAL AND C2_PEDIDO = C6_NUM AND C2_ITEMPV = C6_ITEM AND C6.D_E_L_E_T_ = '' "
cQuery +=	 "  LEFT JOIN " + RetSqlName("SA1") + " A1 (NOLOCK) "
cQuery +=	 "  ON A1.A1_COD = C6.C6_CLI AND A1.A1_LOJA = C6.C6_LOJA AND A1.D_E_L_E_T_ = '' "
cQuery +=	 "  LEFT JOIN " + RetSqlName("SA2") + " A2 (NOLOCK) "
cQuery +=	 "  ON A2.A2_COD = C2.C2_XFORNEC AND A2.A2_LOJA = C2.C2_XLOJA AND A2.D_E_L_E_T_ = '' "
cQuery +=	 "  WHERE C2_DATRF = '' "
cQuery +=	 "  AND C2_QUJE < C2_QUANT "
cQuery +=	 "  AND BM_DESC = '" + Upper(cGrupo) + "' "
cQuery +=	 "  ORDER BY C2_DATPRF DESC "

TCQUERY cQuery NEW ALIAS "KAD1"
	
TcSetField("KAD1","C2_EMISSAO","D")
TcSetField("KAD1","C2_DATPRF","D")
TcSetField("KAD1","C2_XDTIMP","D")

Count To nReg
	
dbGoTop()
	
ProcRegua(nReg)
While KAD1->(!Eof())
	IncProc("Processando Ordens de Produ็ใo, Aguarde...")
		
	SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+KAD1->OP))
	
	//SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+KAD1->A1_COD+KAD1->A1_LOJA))

	AAdd(aOrdens,{  KAD1->OP,;
					KAD1->C2_PRODUTO,;
					KAD1->C2_OPC,;
					KAD1->C2_QUANT,;
					KAD1->C2_DATPRF,;
					KAD1->NOME,;
					'',;
					KAD1->C2_EMISSAO,;
					KAD1->C2_XDTIMP,;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					''})

	KAD1->(dbSkip(1))
Enddo

KAD1->(dbCloseArea())
	
If Empty(nReg)                                          
	aOrdens	:= 	{{'','','',0,CtoD(''),'',CtoD(''),CtoD(''),'','','','','','','','','','','','','',''}}
Endif

RestArea(aArea)
Return .t.

