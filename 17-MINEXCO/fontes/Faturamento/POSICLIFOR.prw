#include "rwmake.ch" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �U_POSICLIFOR� Autor �Magh Moura           � Data �18/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para posicionamento no cadastro de clientes ou      ���
���          � fornecedores dependendo do tipo de Nota Fiscal             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpC1 -> Posicionamento                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Minexco Com. Imp. Exp. Ltda                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function POSICLIFOR()

Local aArea      := GetArea()
Local aAreaSF2   := SF2->(GetArea())
Local aAreaSF1   := SF1->(GetArea()) 
Local retorno    := ""

IF !SF2->F2_TIPO $ "D/B"
    retorno:= POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME")
Else                                                            
    retorno:= POSICIONE("SA2",1,XFILIAL("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_NOME")
EndIf
                                         
RestArea(aAreaSF2)
RestArea(aAreaSF1) 
RestArea(aArea)



Return (retorno)

