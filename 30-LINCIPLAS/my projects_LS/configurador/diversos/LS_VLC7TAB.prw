#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"

// Programa   	LS_VLC7TAB()
// Autor 		Alexandre Dalpiaz
// Data 		30/08/2013
// Descricao  	VALIDAÇÃO DO CAMPO CODIGO DA TABELA DE PREÇOS -  SOMENTE NO MESMO ESTADO DA FILIAL DE ENTREGA
// Uso         	LaSelva

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_VLC7TAB()
/////////////////////////
Local _lRet := .t.
Local _cEst := Posicione('SM0',1,'01' + cFilialEnt,'M0_ESTENT')

If !(_cEst $ AIA->AIA_UFS)
	MsgBox('Tabela não pode ser utilizada neste estado','ATENÇÃO!!!','ALERT')
	_lRet := .f.
EndIf

Return(_lRet)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT010GRV()
/////////////////////////

If nOpcao <> 3
	_cQuery  := "UPDATE SB1 "
	_cQuery += _cEnter + " SET B1_IPI = AIB_ALQIPI"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('AIA') + " AIA (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('AIB') + " AIB (NOLOCK)"
	_cQuery += _cEnter + " ON AIB.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND AIB_CODFOR 		= AIA_CODFOR"
	_cQuery += _cEnter + " AND AIB_LOJFOR 		= AIA_LOJFOR"
	_cQuery += _cEnter + " AND AIB_CODTAB 		= AIA_CODTAB"
	_cQuery += _cEnter + " AND AIB_ALQIPI 		> 0"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	_cQuery += _cEnter + " ON SB1.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND B1_COD 			= AIB_CODPRO"
	
	_cQuery += _cEnter + " WHERE AIA_CODFOR 	= '" + AIA->AIA_CODFOR + "'"
	_cQuery += _cEnter + " AND AIA_LOJFOR 		= '" + AIA->AIA_LOJFOR + "'"
	_cQuery += _cEnter + " AND AIA_CODTAB 		= '" + AIA->AIA_CODTAB + "'"
	_cQuery += _cEnter + " AND AIA.D_E_L_E_T_ 	= ''"
	
	TcSqlExec(_cQuery)
	
	_cQuery  := "UPDATE SBZ"
	_cQuery += _cEnter + " SET BZ_PICMENT = AIB_ALQST"   ///, BZ_PICMRET = CASE WHEN BZ_PICMRET = 0 THEN AIB_ALQST ELSE BZ_PICMRET END"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('AIA') + " AIA (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('AIB') + " AIB (NOLOCK)"
	_cQuery += _cEnter + " ON AIB.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND AIB_CODFOR 		= AIA_CODFOR"
	_cQuery += _cEnter + " AND AIB_LOJFOR 		= AIA_LOJFOR"
	_cQuery += _cEnter + " AND AIB_CODTAB 		= AIA_CODTAB"
	_cQuery += _cEnter + " AND AIB_ALQST 		> 0"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	_cQuery += _cEnter + " ON SB1.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND B1_COD 			= AIB_CODPRO"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SBZ') + " SBZ (NOLOCK)"
	_cQuery += _cEnter + " ON SBZ.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND BZ_COD 			= AIB_CODPRO"
	
	_cQuery += _cEnter + " INNER JOIN SIGAMAT (NOLOCK)"
	_cQuery += _cEnter + " ON CHARINDEX(M0_ESTENT,AIA_UFS) > 0"
	_cQuery += _cEnter + " AND M0_CODFIL 		= BZ_FILIAL"
	
	_cQuery += _cEnter + " WHERE AIA_CODFOR 	= '" + AIA->AIA_CODFOR + "'"
	_cQuery += _cEnter + " AND AIA_LOJFOR 		= '" + AIA->AIA_LOJFOR + "'"
	_cQuery += _cEnter + " AND AIA_CODTAB 		= '" + AIA->AIA_CODTAB + "'"
	_cQuery += _cEnter + " AND AIA.D_E_L_E_T_ 	= ''"
	
	TcSqlExec(_cQuery)
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_GATAIB(_nOpc)
//////////////////////////////

Local _nRet := 0

If _nOpc == 1
	_cQuery  := "SELECT B1_IPI"
	_cQuery += _cEnter + " FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	_cQuery += _cEnter + " WHERE SB1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND B1_COD = '" + M->AIB_CODPRO + "'"
	
	TcSqlExec(_cQuery)
ElseIf _nCond == 2
	_cQuery  := ""
	_cQuery += _cEnter + " FROM " + RetSqlName('AIA') + " AIA (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('AIB') + " AIB (NOLOCK)"
	_cQuery += _cEnter + " ON AIB.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND AIB_CODFOR 		= AIA_CODFOR"
	_cQuery += _cEnter + " AND AIB_LOJFOR 		= AIA_LOJFOR"
	_cQuery += _cEnter + " AND AIB_CODTAB 		= AIA_CODTAB"
	_cQuery += _cEnter + " AND AIB_ALQST 		> 0"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SBZ') + " SBZ (NOLOCK)"
	_cQuery += _cEnter + " ON SBZ.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND BZ_COD 			= AIB_CODPRO"
	
	_cQuery += _cEnter + " INNER JOIN SIGAMAT (NOLOCK)"
	_cQuery += _cEnter + " ON CHARINDEX(M0_ESTENT,AIA_UFS) > 0"
	_cQuery += _cEnter + " AND M0_CODFIL 		= BZ_FILIAL"
	
	_cQuery += _cEnter + " WHERE AIA_CODFOR 	= '" + AIA->AIA_CODFOR + "'"
	_cQuery += _cEnter + " AND AIA_LOJFOR 		= '" + AIA->AIA_LOJFOR + "'"
	_cQuery += _cEnter + " AND AIA_CODTAB 		= '" + AIA->AIA_CODTAB + "'"
	_cQuery += _cEnter + " AND AIA.D_E_L_E_T_ 	= ''"
	
	TcSqlExec(_cQuery)
EndIf
Return(_nRet)
