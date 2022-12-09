#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCGC      �Autor  �Darcio R. Sporl     � Data �  17/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao criada para pegar a picture correta do documento do  ���
���          �cliente.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VNDA360(cCGC)

Local cPict := ""
Local aArea	:= GetArea()

If Len(cCGC) == 14
	cPict := "@R 99.999.999/9999-99"
Else
	cPict := "@R 999.999.999-99"
Endif

RestArea(aArea)
Return(cPict)