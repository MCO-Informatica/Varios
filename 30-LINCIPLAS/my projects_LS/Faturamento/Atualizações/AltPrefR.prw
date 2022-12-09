#include "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �    � Autor � Vanilson Souza     � Data �  02/03/09         ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o para grava��o do prefixo dos titulos                ���
���          � (C. Receber) gerados a partir de NFs                       ���
���          � Chamado/Executado pelo parametro MV_1DUPREF			      ���
�������������������������������������������������������������������������͹��
���Uso       � Laselva                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AltPrefR()

Local cPrefixoE1

If Substr(SF2->F2_SERIE, 1, 1) == '0'
	
	cPrefixoE1 := Alltrim(Substr(SF2->F2_SERIE, 2, 1))+Alltrim(SF2->F2_FILIAL)
	
Else
	
	cPrefixoE1 := Alltrim(SF2->F2_SERIE)+Alltrim(SF2->F2_FILIAL)
	
EndIf

Return (cPrefixoE1)