#include 'Protheus.ch'
#include 'MsgOpManual.ch'
#Include  "Tbiconn.ch"
#include  "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LibQtdUb �Autor  � Luiz Albeto V Alves � Data �  29/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao da Edicao do Campo Quantidade na Tela de Or�amento���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LibQtdUb()
Local aArea 	:= GetArea()
Local nPosnLacreIni	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XINIC"})
Local nPos_nLacFim	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XFIM"})

// Se Lacre Inicial e Final Estiverem Vazios ent�o Permite Alterar a Quantidade Independente do Status do Or�amento

If Empty(aCols[n,nPosnLacreIni]) .And. Empty(aCols[n,nPos_nLacFim])
	RestArea(aArea)
	Return .T.
Endif

RestArea(aArea)
Return .F.

