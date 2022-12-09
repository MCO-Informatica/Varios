#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMA50VLD  �Autor  �Alexandre Sousa     � Data �  03/16/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. durante a validacao de incl.alt.e excl. do recurso.    ���
���          �usando para verificar o apontamento em obra                 ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMA50VLD()

	Local l_Ret := .T.


	If !INCLUI .and. !ALTERA
		c_query := "select * from SZC010 where ZC_RECURSO = '"+AE8->AE8_RECURS+"' and D_E_L_E_T_ <> '*'"
		If Select("QRY") > 0          
			DbSelectArea("QRY")           
			DbCloseArea()                 
		EndIf                          
		TcQuery c_Query New Alias "QRY"
		QRY->(DbGotop())
		
		If !QRY->(EOF())
			msgalert("Esse recurso n�o poder� ser exclu�do, pois existe obra apontada com seu c�digo.", "A T E N � A O")
			l_Ret := .F.
		EndIf                         
	
	EndIf

Return l_Ret