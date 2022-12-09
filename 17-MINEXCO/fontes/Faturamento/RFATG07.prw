#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � RFATG04  � Autor � Ricardo Correa de Souza � Data � 10/08/2010 ���
���          �          �       �     MVG Consultoria     �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Busca a Quantidade Segunda Unidade Medida da Chapa/Ladrilho    ���
�����������������������������������������������������������������������������Ĵ��
���Observacao� C6_LOCALIZ			                                          ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Minexco                                                        ���
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

User Function RFATG07()

Local _cProduto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})]
Local _cLoteCtl :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]
Local _cLocal 	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOCAL"  })]
Local _cNumSeri :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_NUMSERI"})]
Local _nQt :=	0
//----> SO EXECUTA O GATILHO SE A FUNCAO FOR MATA410 (PEDIDO DE VENDA)
If UPPER(AllTrim(FunName())) == "MATA410"
	
	If !Empty(_cLoteCtl)
		
		dbSelectArea("SB8")
		dbSetOrder(6)
		//----> VERIFICA SE O PRODUTO POSSUI TABELA DE PRECO                         
	//  If dbSeek(xFilial("SBF")+_cLocal+_cLocaliz+_cProduto+_cNumSeri+_cLoteCtl,.f.)	
		If dbSeek(xFilial("SB8")+_cProduto+_cLoteCtl+_cLocal,.f.)
			_nQt := SB8->B8_QTDORI 
			

		EndIf			
	EndIf	
EndIf

Return(_nQt)
