#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFINE009  � Autor � Leandro Schumann   � Data �  26/07/16   ���
�������������������������������������������������������������������������͹��
���Descricao �Zera par�metros dos lotes do arquivo SISPAG ITA�.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Prozyn	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFINE009()


_cNum   := "0001"

dbSelectArea("SX6")
dBSetOrder(1)
If dBSeek(xfilial("SX6") +"MV_LOTEPAG")   

	 
		Reclock("SX6",.F.)                                                        
		SX6->X6_CONTEUD := _cNum
	    msUnLock() 
      
Endif

dbSelectArea("SX6")
dBSetOrder(1)
If dBSeek(xfilial("SX6") +"MV_HEADARQ")   

	 
		Reclock("SX6",.F.)                                                        
		SX6->X6_CONTEUD := _cNum
	    msUnLock() 
      
Endif
dbSelectArea("SX6")
dBSetOrder(1)
If dBSeek(xfilial("SX6") +"MV_LOTESJ")   

	 
		Reclock("SX6",.F.)                                                        
		SX6->X6_CONTEUD := _cNum
	    msUnLock() 
      
Endif
Return("")
