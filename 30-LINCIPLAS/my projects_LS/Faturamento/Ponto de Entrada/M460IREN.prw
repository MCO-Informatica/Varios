#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	m460iren
// Autor 		Alexandre Dalpiaz
// Data 		17/10/2011
// Descricao  	ponto de entrada no MATA460 (nf SAIDA)
//				calcula o imposto de renda - considera apenas um item na nota fiscal
// Uso         	LaSelva
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function M460IREN()
////////////////////////

Local _nIrrf, _nBaseIRF := 0

If paramixb == 0
	
	_cQuery := "SELECT SUM(D2_TOTAL) TOTAL, A1_ALIQIR, ED_PERCIRF"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN SA1010 SA1 (NOLOCK)"
	_cQuery += _cEnter + " ON A1_COD = D2_CLIENTE"
	_cQuery += _cEnter + " AND A1_LOJA = D2_LOJA"
	_cQuery += _cEnter + " AND SA1.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SED') + " SED (NOLOCK)"
	_cQuery += _cEnter + " ON ED_CODIGO = A1_NATUREZ"
	_cQuery += _cEnter + " AND ED_CALCIRF = 'S'"
	_cQuery += _cEnter + " AND SED.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	_cQuery += _cEnter + " ON B1_COD = D2_COD"
	_cQuery += _cEnter + " AND B1_IRRF = 'S'"
	_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D2_FILIAL = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + " AND D2_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND D2_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " GROUP BY A1_ALIQIR, ED_PERCIRF"

	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SD2', .F., .F.)
	
	_nAliq := iif(_SD2->A1_ALIQIR == 0, iif(_SD2->ED_PERCIRF == 0, GetMv('MV_ALIQIRF'),_SD2->ED_PERCIRF),_SD2->A1_ALIQIR)
	_nIrrf := NoRound(_SD2->TOTAL * _nAliq / 100,2)
	DbCloseArea()
	
Else
	
	_nIrrf := paramixb
	
EndIf

Return(_nIrrf)
