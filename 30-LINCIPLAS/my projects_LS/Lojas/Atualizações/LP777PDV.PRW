#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LP777PDV
// Autor 		Alexandre Dalpiaz
// Data 		29/11/2012
// Descricao  	CONTABILIZA플O DE CUPONS FISCAIS - LANCAMENTOS PADRAO 777
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// VENDAS PDV - FORMAS DE PAGAMENTO
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LP777PAG(_cForma)
///////////////////////////////

Local _nRet	:= 0

_nPosic := ascan(__LP777PAG,{|X| alltrim(X[1]) == alltrim(_cForma)})
_nRet   := iif(_nPosic == 0, 0, __LP777PAG[_nPosic,2] - iif(_cForma =='R$', __LP777DEV, 0))

Return(_nRet)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// DEVOLU합ES PDV
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LP777DEV(_cGrupo,_nPerc)
//////////////////////////////////////

Local _nPosic, _nRet := 0
Default _nPerc := 100

_nPosic := ascan(__LP777VDA,{|X| X[1] == _cGrupo})
_nRet := iif(_nPosic == 0, 0, __LP777VDA[_nPosic,4])

Return(_nRet)
                       
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// VENDAS PDV
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LP777VDA(_cGrupo,_nPerc)
//////////////////////////////////////
Local _nPosic, _nRet := 0
Default _nPerc := 100

_nPosic := ascan(__LP777VDA,{|X| X[1] == _cGrupo})
_nRet := iif(_nPosic == 0, 0, __LP777VDA[_nPosic,3])

Return(_nRet)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// VENDAS PDV
/// CALCULA O TOTAL DE VENDAS POR GRUPO
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LP777PDV()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local _cQuery

Public __LP777VDA := {} // GRUPO, DESCRICAO, VENDAS, DEVOLU합ES
Public __LP777ICM := 0	// ICM
Public __LP777PAC := 0	// PIS CUMULATIVO,
Public __LP777PNA := 0	// COFINS CUMULATIVO,
Public __LP777CAC := 0	// PIS NAO CUMULATIVO,
Public __LP777CNA := 0	// COFINS NAO CUMULATIVO)
Public __LP777VEN := 0	// TOTAL DA VENDA
Public __LP777DEV := 0	// TOTAL DA DEVOLU플O
Public __LP777PAG := {}	// FORMAS DE PAGAMENTO - TIPO, VALOR
Public __LP777TPG := 0	// TOTAL DE PAGAMENTOS

// PESQUISA PARA FORMAS DE PAGAMENTOS
_cQuery := " SELECT ROUND(SUM(L4_VALOR),2) AS TOTAL, AE_TIPO "
_cQuery += _cEnter + " FROM " + RetSqlName("SL4") + " SL4 (NOLOCK) "

_cQuery += _cEnter + " INNER JOIN " + RetSqlName("SAE") + " SAE (NOLOCK)"
_cQuery += _cEnter + " ON SAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND AE_COD = L4_ADMINIS"
_cQuery += _cEnter + " AND AE_TIPO = L4_FORMA"

_cQuery += _cEnter + " WHERE L4_FILIAL = '" + cFilAnt + "'"
_cQuery += _cEnter + " AND L4_DATA = '" + dtos(dDataBase) + "'"
_cQuery += _cEnter + " AND SL4.D_E_L_E_T_ = '' "
_cQuery += _cEnter + " GROUP BY AE_TIPO"
_cQuery += _cEnter + " ORDER BY AE_TIPO"

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP', .F., .T.)
Do While !eof()
	aAdd(__LP777PAG,{TMP->AE_TIPO, TMP->TOTAL})  
	__LP777TPG += TMP->TOTAL
	DbSkip()
EndDo
DbCloseArea()

// PESQUISA PARA TOTAL DE VENDAS, DEVOLU합ES, ICM, PIS E COFINS (POR GRUPO DE PRODUTOS)
_cQuery := " SELECT D2_GRUPO, BM_DESC, ROUND(SUM(D2_TOTAL) *  100/100,2) AS VENDAS,
_cQuery += _cEnter + " ISNULL((SELECT SUM(Z8_VALOR)"
_cQuery += _cEnter + " FROM " + RetSqlName("SZ8") + " SZ8 (NOLOCK) "
_cQuery += _cEnter + " INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK)"
_cQuery += _cEnter + " ON B1_COD = Z8_PRODUTO"
_cQuery += _cEnter + " WHERE Z8_DATA = D2_EMISSAO"
_cQuery += _cEnter + " AND Z8_FILIAL = D2_FILIAL"
_cQuery += _cEnter + " AND B1_GRUPO = D2_GRUPO ),0) DEVOLUCAO,"
_cQuery += _cEnter + " ROUND(SUM(D2_VALICM),2) ICM,"
_cQuery += _cEnter + " ROUND(SUM(CASE WHEN D2_ALQIMP5 = 3.0 THEN D2_VALIMP5 ELSE 0 END),2) COFACU,"
_cQuery += _cEnter + " ROUND(SUM(CASE WHEN D2_ALQIMP5 = 7.6 THEN D2_VALIMP5 ELSE 0 END),2) COFNACU,"
_cQuery += _cEnter + " ROUND(SUM(CASE WHEN D2_ALQIMP5 = 3.0 THEN D2_VALIMP6 ELSE 0 END),2) PISACU,"
_cQuery += _cEnter + " ROUND(SUM(CASE WHEN D2_ALQIMP5 = 7.6 THEN D2_VALIMP6 ELSE 0 END),2) PISNACU"

_cQuery += _cEnter + " FROM " + RetSqlName("SF2") + "  SF2 (NOLOCK) "

_cQuery += _cEnter + " INNER JOIN " + RetSqlName("SD2") + "  SD2 (NOLOCK) "
_cQuery += _cEnter + " ON SD2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D2_FILIAL = F2_FILIAL"
_cQuery += _cEnter + " AND D2_DOC = F2_DOC"
_cQuery += _cEnter + " AND D2_SERIE = F2_SERIE"
_cQuery += _cEnter + " AND D2_CLIENTE = F2_CLIENTE"
_cQuery += _cEnter + " AND D2_LOJA = F2_LOJA"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName("SBM") + " SBM (NOLOCK)"
_cQuery += _cEnter + " ON BM_GRUPO = D2_GRUPO"
_cQuery += _cEnter + " AND SBM.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " WHERE F2_FILIAL = '" + cFilAnt + "'"
_cQuery += _cEnter + " AND F2_EMISSAO = '" + Dtos(dDataBase) + "'"
_cQuery += _cEnter + " AND F2_DTLANC = ''"
_cQuery += _cEnter + " AND F2_ECF =  'S'"
_cQuery += _cEnter + " AND SF2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " GROUP BY D2_GRUPO, BM_DESC, D2_FILIAL, D2_EMISSAO"

_cQuery += _cEnter + " ORDER BY D2_GRUPO"

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP', .F., .T.)

Do While !eof()

	aAdd(__LP777VDA,{TMP->D2_GRUPO, TMP->BM_DESC, TMP->VENDAS, TMP->DEVOLUCAO})
	
	__LP777ICM += TMP->ICM
	__LP777PAC += TMP->PISACU
	__LP777PNA += TMP->COFACU
	__LP777CAC += TMP->PISNACU
	__LP777CNA += TMP->COFNACU
	__LP777VEN += TMP->VENDAS
	__LP777DEV += TMP->DEVOLUCAO
	
	DbSkip()
EndDo
DbCloseArea()
	
Return(0)