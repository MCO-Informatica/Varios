#include 'protheus.ch'
#include 'parmtype.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MTA175MNU		�Autor  �Microsiga	     � Data �  06/04/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �PE utilizado para adicionar itens no menu (mbrowse)		  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function MTA175MNU()

	Local aArea		:= GetArea()
	Local cCodUser  := RetCodUsr()
	Local cUsersObs :=U_MyNewSX6("CV_USROBCQ", ""	,"C","Usuarios autorizados a incluir/alterar observa��es na baixa do CQ", "", "", .F. )

	If Alltrim(cCodUser) $ Alltrim(cUsersObs)
		Aadd(aRotina,{"Observa��o","U_PZCVA011", 0 , 7,0,nil}) 
	EndIf
	
	RestArea(aArea)	
Return
