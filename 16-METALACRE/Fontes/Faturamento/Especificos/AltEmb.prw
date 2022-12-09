#Include "TOPCONN.CH"
#Include "Protheus.Ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VerEmb � Autor � Luiz Alberto       � Data � 24/10/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida Altera��o Quantidade por Embalagens, se Houver
				Pedido j� utilizando a embalagem ent�o n�o permite altera��o.
�������������������������������������������������������������������������͹��
���          � 													          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AltEmb(nTipo)
Local aArea := GetArea()

DEFAULT nTipo := 1

If ALTERA .And. cFilAnt=='01' .And. nTipo == 1
	If M->Z05_PESOEM <> Z05->Z05_PESOEM
		cQuery := "SELECT TOP 1 C6_NUM as RESULT "
		cQuery += "		FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("Z05") + " Z05, " + RetSqlName("Z06") + " Z06 "
		cQuery += "		WHERE C6.D_E_L_E_T_ = '' "
		cQuery += "		AND Z05.D_E_L_E_T_ = '' "
		cQuery += "		AND Z06.D_E_L_E_T_ = '' "
		cQuery += "		AND C6.C6_FILIAL = '" + xFilial("SC6") + "' "
		cQuery += "		AND Z05.Z05_FILIAL = '" + xFilial("Z05") + "' "
		cQuery += "		AND Z06.Z06_FILIAL = '" + xFilial("Z06") + "' "
		cQuery += "		AND C6.C6_XEMBALA = Z06.Z06_COD               "
		cQuery += "		AND C6.C6_PRODUTO = Z06.Z06_PROD "
		cQuery += "		AND Z06.Z06_EMBALA = Z05.Z05_COD "
		cQuery += "		AND Z05.Z05_FILIAL = Z06.Z06_FILIAL "
		cQuery += "		AND Z05.Z05_COD = '" + M->Z05_COD + "' "

		TcQuery cQuery NEW ALIAS 'RES'
	
		If !Empty(RES->RESULT)
			MsgStop("Aten��o, Existem Pedidos de Vendas J� Gerados com Essa Embalagem, Imposs�vel Permitir Altera��o de Peso !")
			RES->(dbCloseArea())
			RestArea(aArea)
			Return .f.
		Endif
	Endif
ElseIf ALTERA .And. cFilAnt=='01' .And. nTipo == 2	// Produto x Embalagem
	If M->Z06_PESOUN <> Z06->Z06_PESOUN
		cQuery := "SELECT TOP 1 C6_NUM as RESULT "
		cQuery += "		FROM " + RetSqlName("SC6") + " C6 "
		cQuery += "		WHERE C6.D_E_L_E_T_ = '' "
		cQuery += "		AND C6.C6_FILIAL = '" + xFilial("SC6") + "' "
		cQuery += "		AND C6.C6_XEMBALA = '" + M->Z06_COD + "' "
		cQuery += "		AND C6.C6_PRODUTO = '" + M->Z06_PROD + "' "

		TcQuery cQuery NEW ALIAS 'RES'
	
		If !Empty(RES->RESULT)
			MsgStop("Aten��o, Existem Pedidos de Vendas J� Gerados com Essa Embalagem, Imposs�vel Permitir Altera��o de Peso !")
			RES->(dbCloseArea())
			RestArea(aArea)
			Return .f.
		Endif
	Endif
Endif
RES->(dbCloseArea())
RestArea(aArea)
Return .t.
