#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

// Funcao      	fm_z07
// Autor 		Alexandre Dalpiaz
// Data 		04/01/2012
// Descricao    CONTROLE DE JORNAIS
// Uso         	Especifico para laselva
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_z07()
//////////////////////

Private cString 	:= "Z07"
Private cCadastro 	:= "Controle de jornais"
Private _aInclui 	:= {}
Private _aExclui 	:= {}
Private aRotina 	:= {}
Private aCores 		:= {}
Private _aLegenda 	:= {}

dbSelectArea("Z07")
dbSetOrder(1)

//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( _aInclui,  {||.t.} )  			// 1. antes da abertura
aAdd( _aInclui,  {|| U_Z07Inc() } )     // 2. ao clicar no botao ok
aAdd( _aInclui,  {||.t.} )  			// 3. durante a transacao
aAdd( _aInclui,  {||.t.} )       		// 4. termino da transacao

//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( _aExclui,  {||.t.} )  			// 1. antes da abertura
aAdd( _aExclui,  {|| U_Z07Exc() } )     // 2. ao clicar no botao ok
aAdd( _aExclui,  {||.t.} )  			// 3. durante a transacao
aAdd( _aExclui,  {||.t.} )       		// 4. termino da transacao

aAdd(aRotina, {"Pesquisar"			 , "AxPesqui"		, 0 , 1 })
aAdd(aRotina, {"Visualizar"		 	 , "AxVisual"		, 0 , 2 })
aAdd(aRotina, {"Incluir"			 , "AxInclui('Z07',Z07->(Recno()),3,,,,,.F.,,,_aInclui,,,.T.,,,,,)", 0 , 3 })
aAdd(aRotina, {"Alterar"			 , "AxAltera('Z07',Z07->(Recno()),4,,,,,,'U_Z07ALT()',.T.,,,,,)", 0 , 4 })
aAdd(aRotina, {"Excluir"     		 , "AxDeleta('Z07',Z07->(Recno()),5,,,,_aExclui,,.T.,,,,,)", 0 , 5 })
aAdd(aRotina, {"Legenda"     	 	 , "BrwLegenda('Controle de Jornais','LEGENDA',_aLegenda)" 	, 0 , 7 })

aAdd(aCores, {"Z07_QTDENT > Z07_VENDAS + Z07_QTDENC + Z07_PERDAS"		,'BR_VERDE'})
aAdd(aCores, {"Z07_QTDENT == Z07_VENDAS + Z07_QTDENC + Z07_PERDAS"		,'BR_VERMELHO'})

aAdd(_aLegenda, {"BR_VERDE" 	, "Em aberto"})
aAdd(_aLegenda, {"BR_VERMELHO" 	, "Encerrado"})

dbSelectArea('Z07')
mBrowse( 6,1,22,75,'Z07',,,,,,aCores)

RetIndex('Z07')

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// na inclusão do registo
// gera o movimento interno de inclusão no estoque após a confirmação da inclusão
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function Z07Inc()
//////////////////////
Local _lRet 	  := .t.
Local lMsErroAuto := .F.
Local _aVetor 	  := {}

aAdd(_aVetor, { "D3_TM"			, "050"			,	NIL })
aAdd(_aVetor, { "D3_COD"		, M->Z07_CODPRO	,	NIL })
aAdd(_aVetor, { "D3_LOCAL"		, '01'			,	NIL })
aAdd(_aVetor, { "D3_EMISSAO"	, M->Z07_DTPUBL	,	NIL })
aAdd(_aVetor, { "D3_QUANT"		, M->Z07_QTDENT	,	NIL })
aAdd(_aVetor, { "D3_CUSTO1"		, M->Z07_PRCCOM	,	NIL })

MsExecAuto({|x,y| mata240(x,y)},_aVetor,3) //Inclusao

If lMsErroAuto
	_lRet := .f.
	MsgBox('Problemas para inclusão do estoque','ATENÇÃO!!!','ALERT')
	Mostraerro()
ElseIf SD3->D3_TM == '050'
	M->Z07_SEQENT  := SD3->D3_NUMSEQ
Endif

DbSelectArea('Z07')
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// na alteração do registo
// gera os movimentos internos de saida (encalhe e/ou perdas) no estoque após a confirmação da alteração
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function Z07Alt()
//////////////////////
Local _lRet 	  := .t.
Local lMsErroAuto := .F.
Local _aVetor 	  := {}

Begin Transaction

If M->Z07_QTDENC > 0		// MOVIMENTO DE ENCALHE
	aAdd(_aVetor, { "D3_TM"			, "550"			,	NIL })
	aAdd(_aVetor, { "D3_COD"		, M->Z07_CODPRO	,	NIL })
	aAdd(_aVetor, { "D3_LOCAL"		, '01'			,	NIL })
	aAdd(_aVetor, { "D3_EMISSAO"	, M->Z07_DTENC	,	NIL })
	aAdd(_aVetor, { "D3_QUANT"		, M->Z07_QTDENC	,	NIL })
	aAdd(_aVetor, { "D3_CUSTO1"		, M->Z07_PRCCOM	,	NIL })
	
	MsExecAuto({|x,y| mata240(x,y)},_aVetor,3)
	
	If lMsErroAuto
		MsgBox('Problemas no movimento de ENCALHE do estoque','ATENÇÃO!!!','ALERT')
		Mostraerro()
		_lRet := .f.
		DisarmTransaction()
	Else
		lMsErroAuto   := .F.
		_aVetor 	  := {}
		
		If M->Z07_PERDAS > 0		// MOVIMENTO DE PERDAS
			aAdd(_aVetor, { "D3_TM"			, "551"			,	NIL })
			aAdd(_aVetor, { "D3_COD"		, M->Z07_CODPRO	,	NIL })
			aAdd(_aVetor, { "D3_LOCAL"		, '01'			,	NIL })
			aAdd(_aVetor, { "D3_EMISSAO"	, M->Z07_DTENC	,	NIL })
			aAdd(_aVetor, { "D3_QUANT"		, M->Z07_PERDAS	,	NIL })
			aAdd(_aVetor, { "D3_CUSTO1"		, M->Z07_PRCCOM	,	NIL })
			
			MsExecAuto({|x,y| mata240(x,y)},_aVetor,3)
			
			If lMsErroAuto
				_lRet := .f.
				MsgBox('Problemas no movimento de PERDAS do estoque','ATENÇÃO!!!','ALERT')
				Mostraerro()
				DisarmTransaction()
			EndIf
		EndIf
	EndIf
Endif
End Transaction
DbSelectArea('Z07')
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// gera o movimento interno de exclusão no estoque após a confirmação da exclusão
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function Z07Exc()
//////////////////////
Local _lRet 	  := .t.

DbSelectArea('SD3')
DbSetOrder(4)	// D3_NUMSEQ
If DbSeek(xFilial('SD3') + Z07->Z07_SEQENT,.f.)
	RecLock('SD3',.f.)
	DbDelete()
	MsUnLock()
EndIf

If DbSeek(xFilial('SD3') + Z07->Z07_SEQENC,.f.)
	RecLock('SD3',.f.)
	DbDelete()
	MsUnLock()
EndIf

If DbSeek(xFilial('SD3') + Z07->Z07_SEQPER,.f.)
	RecLock('SD3',.f.)
	DbDelete()
	MsUnLock()
EndIf

DbSelectArea('SB2')
If DbSeek(xFilial('SB2') + Z07->Z07_CODPRO,.f.)
	RecLock('SB2',.f.)
	SB2->B2_QATU := SB2->B2_QATU - Z07->Z07_QTDENT + Z07->Z07_QTDENC + Z07->Z07_PERDAS
	MsUnLock()
EndIf

DbSelectArea('Z07')
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Gatilho Z07_QTDENC - Quantidade encalhada
// Verifica se o encalhe é menor ou igual que a quantidade entregue - vendas
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z07Enc()
//////////////////////

Local _nRet := M->Z07_QTDENC

If M->Z07_QTDENT - M->Z07_VENDAS - M->Z07_QTDENC < 0
	MsgBox('Encalhe não pode ser maior que a quantidade recebida menos as vendas (' + alltrim(STR(M->Z07_QTDENT)) + ' - ' + alltrim(str(M->Z07_VENDAS)) + ')','ATENÇÃO!!!','ALTERT')
	
	_nRet := 0
EndIf
DbSelectArea('Z07')
Return(_nRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Gatilho Z07_QTDENC - Quantidade vendida
// Calcula as vendas do jornal na loja, no período da validade do jornal
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z07Ven()
//////////////////////

Local _nRet := 0

_cQuery := "SELECT SUM(D2_QUANT) QUANTIDADE"
_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " (NOLOCK)"
_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D2_FILIAL = '" + xFilial('SD2') + "'"
_cQuery += _cEnter + " AND D2_EMISSAO BETWEEN '" + dtos(M->Z07_DTPUBL) + "' AND '" + dtos(M->Z07_DTENC) + "'"
_cQuery += _cEnter + " AND D2_CLIENTE = '999999'"
_cQuery += _cEnter + " AND D2_ORIGLAN = 'LO'"
_cQuery += _cEnter + " AND D2_COD = '" + M->Z07_CODPRO + "'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
_nRet := QUANTIDADE
DbCloseArea()
DbSelectArea('Z07')
Return(_nRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ponto de entrada na rotina de movimentos internos mod I
// grava o campo D3_NUMSEQ no registro do controle de jornal para exclusão futura, se for o caso
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function SD3240I()
///////////////////////

If FunName() == 'LS_Z07'
	If SD3->D3_TM == '550'
		Z07->Z07_SEQENC  := SD3->D3_NUMSEQ
	ElseIf SD3->D3_TM == '551'
		Z07->Z07_SEQPER  := SD3->D3_NUMSEQ
	EndIf
EndIf
return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// determina se e quando alguns campos serão editáveis
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Z07WHEN(_xPar)
///////////////////////////////

Local _lRet := .t.
If _xPar == 'Z07_QTDENC'
	_lRet := M->Z07_QTDENT > M->Z07_VENDAS + M->Z07_QTDENC + M->Z07_PERDAS .and. altera
EndIf

Return(_lRet)

