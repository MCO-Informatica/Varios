#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT185EST     �Autor  �Felipe Valenca      � Data �  26-04-12 ���
�������������������������������������������������������������������������͹��
���Desc.     � Exclui a nota e o pedido de venda na exclusao da requisicao���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Jestec                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT185EST
    Local _lRet := .T.
    Local _aArea := {}

    cQuery := "SELECT C5_NUM FROM "+RetSqlName("SC5")+" WHERE D_E_L_E_T_ = '' AND C5_XSOLICI = '"+SCP->CP_NUM+"' "

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    Endif

    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

    If !TRB->(Eof())
        Alert("Exclus�o n�o permitida, pois esta solicita��o j� gerou pedido. Favor excluir o pedido "+TRB->C5_NUM+" !")
        _lRet := .F.
    Endif

Return _lRet