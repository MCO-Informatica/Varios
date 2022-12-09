#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		F080BROW
// Autor		Alexandre Dalpiaz
// Data			30/11/12
// Descricao	Filtro do Browse da rotina de cheques sobre títulos
// Uso			Laselva S/A
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F080BROW()
////////////////////////

U_LS_MATRIZ()
Public _cFilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'" 
DbSelectArea('SE2')
Set Filter to &_cFilBrow

aAdd( aRotina,	{ 'Canc Bxa Cheque' , 'U_LS_CANBXCH()'	, 0 , 2})
//aAdd( aRotina,	{ 'Filtro'     , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F390BROW()
////////////////////////

U_LS_MATRIZ()
Public _cFilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'" 
DbSelectArea('SE2')
Set Filter to &_cFilBrow

aAdd( aRotina,	{ 'Canc Bxa Cheque' , 'U_LS_CANBXCH()'	, 0 , 2})
//aAdd( aRotina,	{ 'Filtro'     , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// cancelamento de baixas de títulos por cheque - o cheque permanece
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CANBXCH()
//////////////////////////
U_LS_MATRIZ()
DbSelectArea('SEF')
DbSetOrder(3)
If !DbSeek(xFilial('SEF') + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO,.f.)
	MsgBox('Este Título não sofreu baixa por cheque','ATENÇÃO','INFO')
	Return()
EndIf                                              

If !empty(SEF->EF_HISTD)
	MsgBox('Baixa(s) do(s) título(s) deste cheque já fora(m) cancelada(s)' + _cEnter + SEF->EF_HISTD,'ATENÇÃO!!!','INFO')
	Return()
EndIf              

DbSetOrder(1)
_cChave := SEF->EF_FILIAL + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM
_cTexto := ''
DbSeek(_cChave,.f.)
_nValor := _nSaldo := 0
Do While !eof() .and. _cChave == SEF->EF_FILIAL + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM
	If !empty(SEF->EF_TITULO)
		_cTexto += SEF->EF_PREFIXO + '/' + SEF->EF_TITULO + '-' + SEF->EF_PARCELA + '(' + SEF->EF_TIPO + ') ' + SEF->EF_FORNECE + '/' + SEF->EF_LOJA + ' - ' 
		_cTexto += alltrim(Posicione('SE2',1,xFilial('SE2') + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO + SEF->EF_FORNECE + SEF->EF_LOJA,'E2_NOMFOR'))
		_cTexto += ' Vlr: ' + tran(SE2->E2_VALOR,'@E 999,999.99') + ' Sld: ' + tran(SE2->E2_SALDO,'@E 999,999.99') + _cEnter
		_nValor += SE2->E2_VALOR
		_nSaldo += SE2->E2_SALDO
	Else
		_cTexto += _cEnter + 'Totais - Valor: ' + tran(_nValor,'@E 999,999.99') + ' Saldo: ' + tran(_nSaldo,'@E 999,999.99') +  ' Cheque: ' + tran(SEF->EF_VALOR,'@E 999,999.99') + _cEnter
	EndIf
	DbSkip()
EndDo

If MsgBox(_cTexto,'Confirma cancelamento da(s) baixa(s) do(s) título(s) acima?','YESNO')

	DbSeek(_cChave,.f.)
	_cQuery := "UPDATE SE2"
	_cQuery += _cEnter + " SET E2_SALDO = E2_SALDO + EF_VALOR"
	_cQuery += _cEnter + " FROM " + RetSqlName('SEF') + " SEF (NOLOCK)"

	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SE2') + " SE2 (NOLOCK)"
	_cQuery += _cEnter + " ON E2_MATRIZ = EF_FILIAL"
	_cQuery += _cEnter + " AND E2_PREFIXO = EF_PREFIXO"
	_cQuery += _cEnter + " AND E2_NUM = EF_TITULO"
	_cQuery += _cEnter + " AND E2_PARCELA = EF_PARCELA"
	_cQuery += _cEnter + " AND E2_TIPO = EF_TIPO"
	_cQuery += _cEnter + " AND E2_FORNECE = EF_FORNECE"
	_cQuery += _cEnter + " AND E2_LOJA = EF_LOJA"
	_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE EF_FILIAL = '" + SEF->EF_FILIAL + "'"
	_cQuery += _cEnter + " AND EF_BANCO = '" + SEF->EF_BANCO + "'"
	_cQuery += _cEnter + " AND EF_AGENCIA = '" + SEF->EF_AGENCIA + "'"
	_cQuery += _cEnter + " AND EF_CONTA = '" + SEF->EF_CONTA + "'"
	_cQuery += _cEnter + " AND EF_NUM = '" + SEF->EF_NUM + "'"
	_cQuery += _cEnter + " AND EF_TITULO <> ''"
	_cQuery += _cEnter + " AND SEF.D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SEF') + " SEF (NOLOCK)"
	_cQuery += _cEnter + " SET EF_HISTD = 'BX TIT CANC EM " + dtoc(date()) + " POR " + cUserName + "'"
	_cQuery += _cEnter + " WHERE EF_FILIAL = '" + SEF->EF_FILIAL + "'"
	_cQuery += _cEnter + " AND EF_BANCO = '" + SEF->EF_BANCO + "'"
	_cQuery += _cEnter + " AND EF_AGENCIA = '" + SEF->EF_AGENCIA + "'"
	_cQuery += _cEnter + " AND EF_CONTA = '" + SEF->EF_CONTA + "'"
	_cQuery += _cEnter + " AND EF_NUM = '" + SEF->EF_NUM + "'"
	_cQuery += _cEnter + " AND SEF.D_E_L_E_T_ = ''"
 	TcSqlExec(_cQuery)
	
EndIf
	
Return()