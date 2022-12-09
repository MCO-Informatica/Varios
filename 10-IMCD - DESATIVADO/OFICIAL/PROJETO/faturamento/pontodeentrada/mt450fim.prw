#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     �Autor  �Microsiga           � Data �  06/23/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function MT450FIM()

Local cPedido := ParamIXB[1]

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT450FIM" , __cUserID )

SC9->( dbSetOrder(1) )
SC9->( dbSeek(xFilial("SC9")+cPedido) )

if !empty( SC9->C9_LIBFST ) .and. !empty( SC9->C9_LIBSND )
	//Muda para o campo C5_LIBCRED para X para possibilitar a legenda 
    SC5->( dbSetOrder(1) ) //C5_FILIAL+C5_NUM
	if SC5->( dbSeek( xFilial("SC5")+SC9->C9_PEDIDO ) )
		recLock("SC5", .F.)
		SC5->C5_LIBCRED := "X"
		SC5->( msUnlock() )
	endif
endif

return