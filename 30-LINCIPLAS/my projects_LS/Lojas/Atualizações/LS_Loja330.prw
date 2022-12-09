#Include "RWMAKE.ch"
#Include "PROTHEUS.ch"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_LOJA330
// Autor 		Alexandre Dalpiaz
// Data 		05//08/11
// Descricao  	CONTABILIZAÇÃO DE CUPONS FISCAIS - PARAMETROS DE FILIAL DE/ATÉ
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Loja330()
//////////////////////////

LOCAL nOpca := 0
LOCAL oDlg
PRIVATE aRotina	  := MenuDef()
PRIVATE cCadastro := "Lançamentos Contábeis Off-Line - Cupons Fiscais"
_cFilAnt   := cFilAnt
_cNumEmp   := cNumEmp
_dDataBase := dDataBase
Pergunte("LS_LOJ330",.F.)

DEFINE MSDIALOG oDlg FROM 100,100 TO 350,510 TITLE cCadastro PIXEL OF oMainWnd

@ 03,05 TO 100,200 PIXEL
@ 10,10 SAY 'Este programa tem como objetivo gerar automaticamente os' SIZE 180,08 OF oDlg PIXEL
@ 20,10 SAY 'lançamentos contábeis dos movimentos de cupons fiscais.'  SIZE 180,08 OF oDlg PIXEL

DEFINE SBUTTON FROM 107,100 TYPE 1 ACTION (nOpca:=1,oDlg:End())     ENABLE OF oDlg
DEFINE SBUTTON FROM 107,135 TYPE 2 ACTION oDlg:End()			    ENABLE OF oDlg
DEFINE SBUTTON FROM 107,170 TYPE 5 ACTION Pergunte("LS_LOJ330",.T.) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca ==1
	Processa({|lEnd| RunProc() })	// Chamada da funcao de recalculos
	//RunProc()
EndIf

cFilAnt   := _cFilAnt
cNumEmp   := _cNumEmp
dDataBase := _dDataBase
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

mv_par05  := upper(mv_par05)
mv_par06  := upper(mv_par06)
_dDataDe  := mv_par03
_dDataAte := mv_par04

_nQtdFil := 0
DbSelectArea('SM0')
DbSeek(cEmpAnt + mv_par05,.f.)
Do While !eof() .and. SM0->M0_CODFIL <= mv_par06
	_nQtdFil++
	DbSkip()
EndDo

ProcRegua(_nQtdFil * (_dDataAte - _dDataDe + 1))

DbSeek(cEmpAnt + mv_par05,.f.)
Do While !eof() .and. SM0->M0_CODFIL <= mv_par06
	
	cFilAnt := SM0->M0_CODFIL
	cNumEmp := cEmpAnt + cFilAnt
	
	For dDataBase := _dDataDe to _dDataAte
		mv_par03 := dDataBase
		mv_par04 := dDataBase
		IncProc('Filial ' + cFilAnt + ' - ' + SM0->M0_FILIAL + ' - ' + dtoc(dDataBase))	// Chamada da funcao de recalculos
		L330Cont()
	Next
	
	DbSelectArea('SM0')
	DbSkip()
	
EndDo


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    |MenuDef	³ Autor ³ Fernando Amorim       ³ Data ³12/12/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de definição do aRotina                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRotina   retorna a array com lista de aRotina             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGALOJA                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()

Local aRotina:= { { "Parâmetros","AllwaysTrue", 0 , 3 , , .T.} }

Return(ARotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ L330Cont ³ Autor ³ Aline Correa do Vale  ³ Data ³ 23.01.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz contabilizacao das vendas no Loja					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ LOJA330													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ BOPS ³Prograd.³ALTERACAO                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 05/04/07 ³122711³Conrado ³Alterada a utilização da chamada            ³±±
±±³          ³      ³        ³SubStr(cUsuario,7,15) por cUserName         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function L330Cont()

Local lExecutou := .F.
Local lDigita
Local lAglutina

PRIVATE cArquivo,nHdlPrv:=0,nTotal:=0,cLoteFat


_cQuery := " SELECT COUNT(*) QUANT "
_cQuery += _cEnter + " FROM " + RetSqlName("SF2") + " (NOLOCK)"
_cQuery += _cEnter + " WHERE F2_FILIAL = '" + cFilAnt + "'"
_cQuery += _cEnter + " AND F2_EMISSAO = '" + Dtos(dDataBase) + "'"
_cQuery += _cEnter + " AND F2_DTLANC = ''"
_cQuery += _cEnter + " AND F2_ECF =  'S'"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP', .F., .T.)
If TMP->QUANT == 0
	DbCloseArea()
	Return()
EndIf
DbCloseArea()

dbSelectArea("SX5")
dbSeek(cFilial+"09LOJA")
cLoteFat := iif(Found(),Trim(X5Descri()),"LOJA ")

_cQuery := "SELECT MAX(CT2_DOC) CT2_DOC, SUM(CT2_VALOR) VALOR"
_cQuery += _cEnter + " FROM " + RetSqlName("CT2") + " (NOLOCK)"
_cQuery += _cEnter + " WHERE CT2_FILIAL = '" + cFilAnt + "'"
_cQuery += _cEnter + " AND CT2_DATA = '" + Dtos(dDataBase) + "'"
_cQuery += _cEnter + " AND CT2_LOTE = '" + padl(cLoteFat,6,'0') + "'"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SBLOTE', .F., .T.)
_cCT2_DOC := SBLOTE->CT2_DOC
_nValor   := SBLOTE->VALOR
DbCloseArea()

lDigita	  := Iif(mv_par01==1,.T.,.F.)
lAglutina := Iif(mv_par02==1,.T.,.F.)

nHdlPrv:=HeadProva(cLoteFat,"LOJA330",Subs(cUserName,1,6),@cArquivo)
A :=0
nTotal+=DetProva(nHdlPrv,"777","LOJA330",cLoteFat)
A :=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia para Lancamento Contabil, se gerado arquivo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RodaProva(nHdlPrv,nTotal)
A :=0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia para Lancamento Contabil, se gerado arquivo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cA100Incl(cArquivo,nHdlPrv,1,cLoteFat,lDigita,lAglutina)
A :=0

_cQuery := "SELECT MAX(CT2_DOC) CT2_DOC, SUM(CT2_VALOR) VALOR"
_cQuery += _cEnter + " FROM " + RetSqlName("CT2") + " (NOLOCK)"
_cQuery += _cEnter + " WHERE CT2_FILIAL = '" + cFilAnt + "'"
_cQuery += _cEnter + " AND CT2_DATA = '" + Dtos(dDataBase) + "'"
_cQuery += _cEnter + " AND CT2_LOTE = '" + padl(cLoteFat,6,'0') + "'"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SBLOTE', .F., .T.)

If _cCT2_DOC <> SBLOTE->CT2_DOC
	_cQuery := " UPDATE " + RetSqlName("SF2")
	_cQuery += _cEnter + " SET F2_DTLANC = '" + dtos(dDataBase) + "'"
	_cQuery += _cEnter + " WHERE F2_FILIAL = '" + cFilAnt + "'"
	_cQuery += _cEnter + " AND F2_EMISSAO = '" + Dtos(dDataBase) + "'"
	_cQuery += _cEnter + " AND F2_DTLANC = ''"
	_cQuery += _cEnter + " AND F2_ECF =  'S'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	
	TcSqlExec(_cQuery)
EndIf
DbCloseArea()

Return()
/*
//////////////////////////////////////////
// PONTOS DE ENTRADA NA CONTABILIZAÇÃO    - NAO UTILIZADOS 
/////////////////////////////////////////
User Function ct105qry()

_cRet := PARAMIXB[1]

Return(_cRet)

                                                         
User Function C105CESP()
Return(_cRet)

User Function ct105vlent()

_lRet := .t.

Return(_lRet)

User Function ct105lok()

_lRet := .t.

Return(_lRet)

User Function ct105tok()

_lRet := .t.

Return(_lRet)

User Function ct105chk()

_lRet := .t.

Return(_lRet)


User Function ctb105outm()

_lRet := .t.

Return(_lRet)

User Function ANTCTBGRV()

_lRet := .f.

Return()                                                                           

*/