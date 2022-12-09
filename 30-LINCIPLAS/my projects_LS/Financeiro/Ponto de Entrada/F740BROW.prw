#INCLUDE "TCBROWSE.CH"

#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F740BROW()
// Autor 		Alexandre Dalpiaz
// Data 		22/06/10
// Descricao  	Consulta nota fiscal de saida/entrada a partir do titulo a receber
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	08/11/13 - Thiago Queiroz - Removido filtro personalizado para utilizar o filtro padrão da VERSÃO 11
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F740BROW()
////////////////////////
Local _aRot := {}
U_LS_MATRIZ()
Public _cFilBrow := "E1_MATRIZ == '" + cFilAnt + "'" // ALTERADO POR alexandre em 29/7/2011

DbSelectArea('SE1')
set filter to &_cFilBrow

aAdd(aRotina, { 'Manutenção','U_LS_590(1)', 0 , 2}) // [05,2]

aAdd( _aRot,	{ 'Título'		,'U_FM740(1)'		, 0 , 2})
aAdd( _aRot,	{ 'Nota Fiscal'	,'U_FM740(2)'	, 0 , 2})

aAdd( aRotina,	{ 'Cons&ultar'	, _aRot, 0 , 2})

_aRot := {}

//aAdd( aRotina,	{ 'Filtro' , 'U_LS_FILTRO("SE1",_cFilBrow)'	, 0 , 2})

aAdd(aRotina, { 'Relatório Retorno','U_FINR01', 0 , 2})  // Retirado [10,2] - estranhamente após a tualização isso não funciona.
//aAdd(aRotina[10,2], { 'Relatório Retorno','U_FINR01', 0 , 2})


If '/'+ __cUserId + '/' $ GetMv('LA_PODER')
	aAdd(aRotina, { 'Conf CNAB Mod 1','CFGX014', 0 , 2}) // [10,2]
	aAdd(aRotina, { 'Conf CNAB Mod 2','CFGX049', 0 , 2}) // [10,2]
EndIf
If '/'+ __cUserId + '/' $ GetMV('LS_GERFINA') + GetMv('LA_PODER')
	aAdd( aRotina,	{ 'Lib/Bloq Data' , 'U_LS750LIB(3)'	, 0 , 2})
EndIf

_aRot := {}
aAdd( _aRot,	{ 'Títulos a Receber'		, 'FINR130'	, 0 , 2})
aAdd( _aRot,	{ 'Histórico de Clientes'	, 'FINR270'	, 0 , 2})
aAdd( _aRot,	{ 'Posição Geral Cobrança'	, 'FINR320'	, 0 , 2})
aAdd( _aRot,	{ 'Posição de Clientes'		, 'FINR340'	, 0 , 2})
aAdd( _aRot,	{ 'Títulos Env. ao Banco'	, 'FINR660'	, 0 , 2})
aAdd( _aRot,	{ 'Liquidação'				, 'FINR500'	, 0 , 2})
aAdd( _aRot,	{ 'Movimentos Mês a Mês'	, 'FINR801'	, 0 , 2})
aAdd( _aRot,	{ 'Cheques Devolvidos'		, 'LOJR190'	, 0 , 2})
aAdd( _aRot,	{ 'Emissão de Borderôs'		, 'FINR170'	, 0 , 2})

aAdd(aRotina, {'Relatór&ios', aClone(_aRot),0,2})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_FILTRO(_cAlias, _cFilOri)
///////////////////////////////////////////
Local _cFiltro	:= ''
DbSelectArea(_cAlias)

_cFiltro := BuildExpr( _cAlias,, _cFiltro)
If !empty(_cFilOri) .and. !(_cFilOri $ _cFiltro)
	_cFiltro  += iif(!empty(_cFiltro),' .and. ','') + _cFilOri
EndIf
set filter to &_cFiltro

Return()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FM740(_xPar)  // CONSULTA NOTA FISCAL A PARTIR DO DO TITULO
/////////////////////////////////////////////////////////////////////////
Local _aAlias := GetArea()
Local lFi040Cmpo := .t.
Local cFilName := SM0->M0_FILIAL
Local cFieldPE := ''
Local _cFilAnt

If _xPar == 1
	
	Fc040Con()
	
Else
	If alltrim(SE1->E1_ORIGEM) $ 'MATA460/LOJA010'
		
		DbSelectArea('SF2')
		SF2->(DbSetOrder(1))
		If SF2->(DbSeek(SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_SERIE + SE1->E1_CLIENTE + SE1->E1_LOJA,.F.))
			_cFilAnt := cFilAnt
			cFilAnt  := SE1->E1_FILORIG
			MC090Visual()
			cFilAnt := _cFilAnt
		Else
			MsgBox('Nota fiscal de saída não encontrada','ATENÇÃO!!!','ALERT')
		EndIf
		
	ElseIf alltrim(SE1->E1_ORIGEM) $ 'MATA100/MATA103'
		
		DbSelectArea('SF1')
		SF1->(DbSetOrder(1))
		If SF1->(DbSeek(SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_SERIE + SE1->E1_CLIENTE + SE1->E1_LOJA,.F.))
			_cFilAnt := cFilAnt
			cFilAnt  := SE1->E1_FILORIG
			A103NFiscal('SF1',,2)
			cFilAnt := _cFilAnt
		Else
			MsgBox('Nota fiscal de entrada não encontrada','ATENÇÃO!!!','ALERT')
		EndIf
		
		RestArea(_aAlias)
		
	Else
		
		MsgBox('Titulo não foi originado através de nota fiscal','ATENÇÃO!!!','ALERT')
		
	EndIf
EndIf
Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F590COK()
///////////////////////

If PARAMIXB[1] == 'P'
	If SE2->E2_SALDO > 0
		RecLock( "SE2" )
		SE2->E2_NUMBOR := Space(6)
		SE2->E2_PORTADO := ""
		SE2->E2_NUMBCO  := ""
		MsUnlock( )
		RecLock("SEA",.F.,.T.)
		dbDelete()
		MsUnlock()
	EndIf
Else
	If SE1->E1_SALDO > 0
		RecLock( "SE1" )
		SE1->E1_NUMBOR := Space(6)
		SE1->E1_DATABOR := CTOD("")
		SE1->E1_PORTADO := ""
		SE1->E1_AGEDEP  := ""
		SE1->E1_CONTA   := ""
		SE1->E1_SITUACA := "0"
		SE1->E1_NUMBCO  := ""
		MsUnlock( )
		RecLock("SEA",.F.,.T.)
		dbDelete()
		MsUnlock()
	EndIf
EndIf
Return(.f.)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA920BUT()
////////////////////////
_aButton := ''
If SF2->F2_TIPO == 'N'
	_cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VALOR, E1_VENCTO, E1_VENCREA, E1_SALDO, E1_BAIXA, E1_EMISSAO"
	_cQuery += _cEnter + " FROM " + RetSqlName('SE1') + " SE1 (NOLOCK)"
	_cQuery += _cEnter + " WHERE SE1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E1_FILIAL = ''"
	_cQuery += _cEnter + " AND E1_PREFIXO = '" + SF2->F2_PREFIXO + "'"
	_cQuery += _cEnter + " AND E1_NUM = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND E1_TIPO = 'NF'"
	
	If Select('TRBSE1') > 0
		TRBSE1->(DbCloseArea())
	EndIf
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRBSE1',.f.,.f.)},'Verificando Baixas...')
	TcSetField('TRBSE1','E1_VENCTO' ,'D', 0)
	TcSetField('TRBSE1','E1_VENCREA','D', 0)
	TcSetField('TRBSE1','E1_BAIXA'  ,'D', 0)
	TcSetField('TRBSE1','E1_EMISSAO','D', 0)
	If !eof()
		_aButton := {}
		aAdd(_aButton,{ "BUDGET", {|| U_LS_MA920BUT() }, 'Financeiro', 'Financeiro' } ) //"System Tracker"
	EndIf
EndIf
Return(_aButton)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_MA920BUT()
///////////////////////////
_nAltura 	:= oMainWnd:nClientHeight - 300
_nLargura 	:= oMainWnd:nClientWidth - 300
_lInverte 	:= .F.
_lMarca   	:= .F.
_lDesmarca	:= .F.
_aSE1 := {}
DbSelectArea('TRBSE1')
DbGoTop()
Do While !eof()
	aAdd(_aSE1,{TRBSE1->E1_EMISSAO, TRBSE1->E1_PREFIXO, TRBSE1->E1_NUM, TRBSE1->E1_PARCELA, TRBSE1->E1_TIPO, TRBSE1->E1_VALOR,  TRBSE1->E1_VENCTO,  TRBSE1->E1_SALDO, TRBSE1->E1_BAIXA})
	DbSkip()
EndDo

If len(_aSE1) > 1
	_nLin := 1
	oDlg:=MsDialog():New(0,0,_nAltura,_nLargura,"Consulta Movimentação Financeira",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	@ 010,005 ListBox  _oListSE1  Var _cVarPed Fields HEADER "Emissão","Prefixo","Título", "Parcela", "Tipo", "Valor", "Vencimento", "Saldo", "Baixa" Size _nLargura/2-05,_nAltura/2-100 On DblClick (LS_VESE1(_oListSE1:nAt)) OF oDlg PIXEL
	_oListSE1:SetArray(_aSE1)
	_oListSE1:bLine := { || {_aSE1[_oListSE1:nAt,1],_aSE1[_oListSE1:nAt,2],_aSE1[_oListSE1:nAt,3],_aSE1[_oListSE1:nAt,4],_aSE1[_oListSE1:nAt,5],_aSE1[_oListSE1:nAt,6],_aSE1[_oListSE1:nAt,7],_aSE1[_oListSE1:nAt,8],_aSE1[_oListSE1:nAt,9]}}
	
	@ _nAltura/2 - 050,010 BUTTON "Fechar"  SIZE 040,015 OF oDlg PIXEL ACTION(oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Else
	_nLin := 1
	LS_VESE1(_nLin)
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_VESE1(_nLin)
//////////////////////////           
SE1->(Dbseek(xFilial('SE1') + _aSE1[_nLin,2] + _aSE1[_nLin,3] + _aSE1[_nLin,4] + _aSE1[_nLin,5],.f.))
Fc040Con()
Return()

