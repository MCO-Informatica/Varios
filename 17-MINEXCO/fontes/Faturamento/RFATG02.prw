#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � RFATG02  � Autor � Ricardo Correa de Souza � Data � 10/08/2010 ���
���          �          �       �     MVG Consultoria     �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Busca o Preco de Venda pelo Lote na Tabela de Preco            ���
�����������������������������������������������������������������������������Ĵ��
���Observacao� C6_LOTECTL			                                          ���
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

User Function RFATG02()

Local _nQtdVen	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})]
Local _nPrcVen	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]
Local _cProduto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})]
Local _cLoteCtl :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]
Local _nValor	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})]
Local _nDescont	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DESCONT"})]
Local _nValDes	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALDESC"})]

//----> SO EXECUTA O GATILHO SE A FUNCAO FOR MATA410 (PEDIDO DE VENDA)
If UPPER(AllTrim(FunName())) == "MATA410"
	
	If !Empty(_cLotectl)
		
		dbSelectArea("DA1")
		dbSetOrder(7)
		//----> VERIFICA SE O PRODUTO POSSUI TABELA DE PRECO
		If dbSeek(xFilial("DA1")+M->C5_TABELA+_cProduto+_cLotectl,.f.)
			
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})]	:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})] * xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,1,M->C5_EMISSAO),"C6_PRUNIT")
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]	:=	A410Arred(FtDescCab((aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})] * xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,1,M->C5_EMISSAO)),{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),"C6_PRCVEN")
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR" })]	:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")
			
			If aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})] <= 0
				MsgAlert("O produto/lote n�o possui pre�o de venda cadastrado nesta tabela de pre�o.","Pre�o de Lista","Stop")
			EndIf
		Else
			MsgAlert("O produto/lote n�o possui pre�o de venda cadastrado nesta tabela de pre�o.","Pre�o de Lista","Stop")
		EndIf
	Else
		MsgAlert("Lote n�o informado. � necess�rio informar o lote para busca do pre�o de venda.","Lote","Stop")
	EndIf
EndIf

Return(_cLotectl)
