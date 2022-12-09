#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SACI008   �Autor  �Opvs (Thiago)       � Data �  22/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada desenvolvido, para baixas de t�tulos em    ���
���          �arquivo cnab e flegar o mesmo como baixado                  ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SACI008()
Local aArea		:= GetArea()

SZQ->(DbSelectArea("SZQ"))
SZQ->(DbSetOrder(2))
IF SZQ->(DbSeek(xFilial("SZQ")+Alltrim(SE1->E1_XNPSITE))) 
SZQ->(Reclock("SZQ"))
	SZQ->ZQ_STATUS := "6"
	SZQ->ZQ_OCORREN := "T�tulo baixado com sucesso."  
	SZQ->ZQ_DATA := ddatabase
	SZQ->ZQ_HORA:=time() 
	SZQ->(MsUnlock())
Endif

RestArea(aArea)
Return