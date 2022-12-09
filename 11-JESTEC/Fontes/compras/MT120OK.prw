#INCLUDE "PROTHEUS.CH"


	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �MT120OK  �Autor  �Roberto Marques      � Data �  02/28/12   ���
	�������������������������������������������������������������������������͹��
	���Desc.     � PONTO DE ENTRADA PARA VALIDAR PEDIDO DE COMPRAS COM PMS    ���
	���          �                                                            ���
	�������������������������������������������������������������������������͹��
	���Uso       � AP                                                        ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/

User Function MT120OK()
    Local mSQL := ""
    Local nRet
    //mSQL := "Select COUNT(*)TOTAL FROM AJ7010


    If Select( "TMP" ) > 0
        TMP->( DbCloseArea() )
    EndIf

    mSQL := " SELECT COUNT(*)TOTAL "
    mSQL += " FROM "+ RetSQLName("AJ7")
    mSQL += " WHERE AJ7_NUMPC='"+ca120Num+"' AND AJ7_FILIAL='"+ xFilial ("AJ7") +"' AND D_E_L_E_T_ <>'*' "


    DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TMP", .F., .T.)
    TMP->( DbGoTop() )

    IF TMP->TOTAL >= 1
        nRet	:= .T.
    Else
        //Alert("Favor relacionar o Projeto e Tarefa para este Pedido de Compras."+CA120NUM )
        Alert("Projeto e Tarefa n�o relacionado para este Pedido de Compras."+CA120NUM )
        //nRet	:= .F.
        nRet	:=	.t.
    Endif


Return nRet