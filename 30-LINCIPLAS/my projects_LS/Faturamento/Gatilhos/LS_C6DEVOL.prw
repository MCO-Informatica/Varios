#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
// Funcao      	LS_C6DEVOL
// Autor 		Alexandre Dalpiaz
// Data 		20/06/2013
// Descricao    GATILHO 004 NO PRODUTO DO PEDIDO DE VENDAS - QUANDO FOR PEDIDO TIPO DEVOLUÇÃO, BUSCA AS NOTAS DE ORIGEM DESTA FILIAL X PRODUTO X FORNECEDOR X LOJA 
//				QUE AINDA TENHAM SALDO PARA DEVOLUÇÃO - POSICIONA NA NOTA FISCAL MAIS MODERNA  E JOGA O NRO DA NOTA NO CAMPO C6_NFORI
//				OS GATILHOS SEGUINTES PREENCHEM OS DEMAIS CAMPOS DE NOTA DE ORIGEM (C6_SERIE, C6_ITEM, C6_PRUNIT, C6_PRCVEN)
// Uso         	Especifico para laselva
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_C6DEVOL(_xProduto)
///////////////////////////////////
Local _cQuery
Local _aAlias := GetArea()

_cQuery := "SELECT D1_DOC, D1_SERIE, D1_QTDEDEV, D1_QUANT, SD1.R_E_C_N_O_ REGISTRO"
_cQuery += _cEnter + "FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + "WHERE D1_COD = '" + _xProduto + "'"
_cQuery += _cEnter + "AND D1_FILIAL = '" + cFilAnt + "'"
_cQuery += _cEnter + "AND D1_QTDEDEV < D1_QUANT"
_cQuery += _cEnter + "AND D1_FORNECE = '" + M->C5_CLIENTE + "'"
_cQuery += _cEnter + "AND D1_LOJA = '" + M->C5_LOJACLI + "'"
_cQuery += _cEnter + "AND SD1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND D1_TIPO = 'N'"
_cQuery += _cEnter + "ORDER BY D1_EMISSAO DESC"
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'DEV', .F., .T.)
_nRecno := DEV->REGISTRO
DbCloseArea()
SD1->(DbGoTo(_nRecno))
If _nRecno == 0
	Msgbox('Este produto nunca foi adquirido desse fornecedor, portanto não pode ser devolvido','ATENÇÃO!!!','ALERT')
	SD1->(DbSeek('XXXXX'))
EndIf

RestArea(_aAlias)

Return(SD1->D1_COD)