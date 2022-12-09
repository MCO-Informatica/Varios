#Include "Protheus.CH"  
#Include "RwMake.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410PVNF  �Autor  �Sidney Oliveira     � Data �  06/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para alimentar o transito da loja que esta recebendo ���
���          �a nota fiscal                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico La Selva                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M410PVNF()
////////////////////////
Local lContinua := .T.
Local nValor 	:= 0

DbSelectarea("SC6")
DbSetOrder(1)
dbSeek(xFilial("SC6")+SC5->C5_NUM,.F.)

WHILE !EOF() .AND. SC6->C6_NUM == SC5->C5_NUM

//Retirada do Transito, pois iremos tratar na emiss�o da nota fiscal
// ajusta o transito (B2_SALPEDI) na filial de destino do romaneio (ap�s a grava��o da inclus�o ou altera��o do pedido)
//If (altera .and. empty(SC5->C5_COTACAO)) .or. (inclui .and. empty(M->C5_COTACAO))
If SF2->F2_TIPO == 'N' .and. SF2->F2_CLIENTE < '000009'

	_cQuery := "UPDATE " + RetSqlName('SB2')
	_cQuery += _cEnter + " SET B2_SALPEDI = B2_SALPEDI + C6_QTDVEN"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ 			= ''"
	_cQuery += _cEnter + " AND F4_CODIGO 				= C6_TES"
	_cQuery += _cEnter + " AND F4_ESTOQUE 				= 'S'"  
	
	_cQuery += _cEnter + " WHERE SC6.D_E_L_E_T_ 		= ''"
	_cQuery += _cEnter + " AND C6_FILIAL 				= '" + SC5->C5_FILIAL + "'"
	_cQuery += _cEnter + " AND C6_NUM 					= '" + SC5->C5_NUM + "'"
	_cQuery += _cEnter + " AND C6_CLI 					< '000009'"
	_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 		= ''"
	_cQuery += _cEnter + " AND B2_FILIAL 				= C6_LOJA"
	_cQuery += _cEnter + " AND B2_COD 					= C6_PRODUTO"
	_cQuery += _cEnter + " AND B2_LOCAL 				= C6_LOCAL"
	nValSQL := TcSqlExec(_cQuery)
	
	if nValSQL < 0
	   alert("Erro na execu��o do SQL - M410PVNF")
	   alert(_cquery)
	endif
EndIf
End
Return lContinua
