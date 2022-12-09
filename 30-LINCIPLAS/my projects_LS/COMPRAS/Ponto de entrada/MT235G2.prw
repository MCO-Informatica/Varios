#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_TRANSF
// Autor 		Alexandre Dalpiaz
// Data 		09/02/11
// Descricao  	eliminação residuos pedidos de comrpas
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT235G2
/////////////////////

_cGrupo := Posicione('SB1',1,xFilial('SB1') + SC7->C7_PRODUTO,'B1_GRUPO')
_lRet := .f.

If _cGrupo >= mv_par18 .and. _cGrupo <= mv_par19
	_lRet := .t.
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_MATA235()
//////////////////////////
LOCAL nOpca := 0
Local aSays:={}, aButtons := {}
PRIVATE lMT235G1 := existblock("MT235G1")

PRIVATE cCadastro := "Eliminação de resíduos dos Pedidos de Compras"

If !Pergunte('MTA235',.T.)
	Return()
EndIf             

DbSelectArea('SM0')
_nRecno := Recno()
DbSeek(cEmpAnt)
Do While !eof() .and. cEmpAnt == SM0->M0_CODIGO
	If SM0->M0_CODFIL  >= mv_par20 .and. SM0->M0_CODFIL <= mv_par21
		cFilAnt := SM0->M0_CODFIL                                                       
		
		_cQuery := "SELECT DISTINCT C7_NUM, C7_EMISSAO,C7_FORNECE, C7_DATPRF"
		_cQuery += _cEnter + "FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"
		_cQuery += _cEnter + "JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
		_cQuery += _cEnter + "ON B1_COD = C7_PRODUTO"
		_cQuery += _cEnter + "AND B1_GRUPO BETWEEN '" + mv_par18 + "' AND '" + mv_par19 + "'"
		_cQuery += _cEnter + "WHERE C7_EMISSAO BETWEEN '" + dtos(mv_par02) + "' AND '" + dtos(mv_par03) + "'"
		_cQuery += _cEnter + "AND C7_NUM BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
		_cQuery += _cEnter + "And C7_FILIAL = '" + cFilAnt + "'"
		_cQuery += _cEnter + "AND C7_RESIDUO = ' '"
		
		If !Empty(MV_PAR22)
		 
			_cQuery += _cEnter + "AND C7_TES = '" + MV_PAR22 + "' " // Incluído por Rodrigo em 03/10/12 a pedido do Daniel (tckt: 62109)
		
		EndIf
		
		_cQuery += _cEnter + "AND SC7.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + "AND C7_QUJE < C7_QUANT"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)     
		count to _nLastRec
		TcSetField('TRB','C7_EMISSAO','D',0)
		TcSetField('TRB','C7_DATPRF' ,'D',0)         
		DbGoTop()
		If !eof()
			MsAguarde({|lEnd| RunProc()},'Filial ' + SM0->M0_CODFIL + ' / ' + alltrim(SM0->M0_NOME) + ' - ' + SM0->M0_FILIAL )
		EndIf
		DbCloseArea()
	EndIf
	
	DbSelectArea('SM0')
	DbSkip()
EndDo

DbGoTo(_nRecno)
cFilAnt := SM0->M0_CODFIL

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////
DbSelectArea('TRB')
DbGoTop()         
//ProcRegua(_nLastRec)
_nRec := 0
Do While !eof()
	MsProcTxt(MA235PC(mv_par01,mv_par08,TRB->C7_EMISSAO,TRB->C7_EMISSAO,TRB->C7_NUM,TRB->C7_NUM,mv_par06,mv_par07,mv_par09,mv_par10,mv_par11,mv_par12,mv_par14,mv_par15),'Filial ' + SM0->M0_CODFIL + ' / ' + alltrim(SM0->M0_NOME) + ' - ' + SM0->M0_FILIAL + ' (' + alltrim(str(++_nRec))+ '/' + alltrim(str(_nLastRec)) + ')')
	// |lEnd| MA235PC(mv_par01,mv_par08,mv_par02,       mv_par03,       mv_par04,   mv_par05,   mv_par06,mv_par07,mv_par09,mv_par10,mv_par11,mv_par12,mv_par14,mv_par15)})
	//nperc, cTipo, dEmisDe, dEmisAte, cCodigoDe, cCodigoAte, cProdDe, cProdAte, cFornDe, cFornAte, dDatprfde, dDatPrfAte, cItemDe, cItemAte, lConsEIC)
	DbSelectArea('TRB')
	DbSkip()
EndDo
Return()


