#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � SF2520E  � Autor � Ricardo Correa de Souza � Data � 06/01/2010 ���
���          �          �       �     MVG Consultoria     �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Apaga o Financeiro e a Comissao do Vendedor                    ���
�����������������������������������������������������������������������������Ĵ��
���Observacao� LOTEC, LOTED, #                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Ricaelle Industria e Comercio Ltda                             ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function SF2520E()

Local _cAlias	:= Alias()
Local _nOrdem	:= IndexOrd()
Local _nRecno	:= Recno()
Local cPrefixo	:= ""


If cFilAnt == "0101"
	cPrefixo := "AT "
Elseif cFilAnt == "0102"
	cPrefixo := "MA "
Elseif cFilAnt == "0103"
	cPrefixo := "DR "
Elseif cFilAnt == "0104"
	cPrefixo := "LK "
Elseif cFilAnt == "0105"
	cPrefixo := "EV "
Endif

dbSelectArea("SF2")

dbSelectArea("SE1")
dbSetOrder(2)
DbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+cPrefixo+SF2->F2_DOC,.F.)

While !Eof() .And. (xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+cPrefixo+SF2->F2_DOC)==SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
	If Empty(SE1->E1_BAIXA)
		recLock("SE1",.F.)
			DbDelete()
		MsUnLock("SE1")
	EndIf
	dBSelectArea("SE1")
	dBSkip()
EndDo

dbSelectArea("SE3")
dbSetOrder(1)
DbSeek(xFilial("SE3")+cPrefixo+SF2->F2_DOC,.F.)

While !Eof() .And. (xFilial("SE3")+cPrefixo+SF2->F2_DOC)==SE3->(E3_FILIAL+E3_PREFIXO+E3_NUM)
	If SE3->E3_TIPO = cPrefixo
		recLock("SE3",.F.)
			DbDelete()
		MsUnLock("SE3")
	EndIf
	dBSelectArea("SE3")
	dBSkip()
EndDo

//Exclui Bonus Vendas
If !Empty(SF2->F2_DUPL)
	U_DelBonus(cFilAnt,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
EndIf



DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoTo(_nRecno)

Return()
