#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MALTCLI  �Autor  �  Daniel   Gondran  � Data �  10/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para gravar os campos A1_USERI (usuario   ���
���          � inclusao) A1_USERA (usuario alteracao) A1_DATAI (data      ���
���          � inclusao) e A1_DATAA (data alteracao) no Cad Clientes      ���
�������������������������������������������������������������������������͹��
���Uso       � MATA030                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MALTCLI()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MALTCLI" , __cUserID )
	//U_INTSFCLI()
	
	If ALTERA
		RECLOCK("SA1",.F.)
		SA1->A1_USERA := AllTrim(UsrRetName(__cUserId))	
		SA1->A1_DATAA := dDataBase    
		MSUNLOCK()                    
	Endif

Return (.T.)


User Function M030INC()

	//U_INTSFCLI()
	
	RECLOCK("SA1",.F.)
	SA1->A1_USERI := AllTrim(UsrRetName(__cUserId))
	SA1->A1_DATAI := dDataBase
	MSUNLOCK()

Return (.T.)
