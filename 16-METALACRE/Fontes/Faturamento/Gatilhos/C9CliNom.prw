#include 'protheus.ch'
#include 'parmtype.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �C9CliNom  �Autor  �Bruno Daniel Abrigo � Data �  15/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �mostra nome do cliente, na tela documento saida.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function C9CliNom()
Local aArea 	:= GetArea()
Local cNomCli	:= ''
If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
	cNomCli	:=	SC5->C5_NOMECLI
Endif
return cNomCli