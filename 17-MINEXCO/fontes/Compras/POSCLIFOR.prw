		#include "rwmake.ch" 
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �U_POSCLIFOR    � Autor �Magh Moura           � Data �25/09/2006���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para posicionamento no cadastro de clientes ou         ���
���          � fornecedores dependendo do tipo de Nota Fiscal                ���
���          � OBS: a fun��o chama POSCLIFOR pois POSICLIFORSF1 tem nome mto ���
���          � extenso e o protheus nao permite.                             ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                               ���
����������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                        ���
����������������������������������������������������������������������������Ĵ��
���Retorno   � ExpC1 -> Posicionamento                                       ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Minexco Com. Imp. Exp. Ltda                   ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function POSCLIFOR()

Local aArea      := GetArea()
Local aAreaSF1   := SF1->(GetArea())
Local retorno    := "";

IF SF1->F1_TIPO $ "D/B"
    retorno:= POSICIONE("SA1",1,XFILIAL("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME")
Else                                                            
    retorno:= POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
EndIf
                                         
RestArea(aAreaSF1)
RestArea(aArea)



Return (retorno)