/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa � MT410BRW � Autor � Denise Freitas       � Data � 20/01/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para Inclusao de Botoes na Rotina de      ���
���          � Pedidos de Vendas                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
 */
 User Function MT410BRW()
    local cLibUsr:= SuperGetMV("MV_USRPVCO",,"000000;000119;000206")
    Local cUsr   := RetCodUsr()

    AADD(aRotina,{"Confirma��o do Pedido","U_RFATR002",0,3})
    AADD(aRotina,{"Relacao Itens COnvertido","U_RFATC002",0,4})

    If cUsr $ cLibUsr
        AADD(aRotina,{"Info Complementar","U_PVCOMPLEM", 0 , 4})
    EndIf

 Return
