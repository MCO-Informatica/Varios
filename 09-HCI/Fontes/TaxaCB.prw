#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � TaxaCB   � Autor � Eduardo Porto         � Data � 24.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria Verba de Desconto da Taxa de Entrega da Cesta Basica  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RDMake ( DOS e Windows )                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para HCI                                        ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function TaxaCB()

//Montando Variaveis de Trabalho
VlrDesc_ := 0
cVerba    := "570"
//Processamento

// CALCULO DA TAXA DE ENTREGA DA CESTA BASICA PARA O FUNCIONARIO

If SRA->RA_CESTAB = "S" .And. SRA->RA_ENTRCB_ = "S"
	//Localiza Parametros
	U_TxCB()
    fGeraVerba(cVerba,VlrDesc_,,,,,,,,,.T.)
Endif 

Return(" ")



User Function TxCB() 

dBSelectArea("RCC")
dBSetOrder(1)

MsSeek(Space(2) + "U002" +Space(8) + "001")

	If RCC->(Found())
        VlrDesc_ := Val(Substr(RCC_CONTEU,1,12))
	EndIf          

Return(VlrDesc_)





