#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � RFATG03  � Autor � Ricardo Correa de Souza � Data � 10/08/2010 ���
���          �          �       �     MVG Consultoria     �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Busca o Preco de Venda pelo Lote na Tabela de Preco            ���
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

User Function RFATG06()

Local _nQtdVen	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})]
Local _nPrcVen	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]
Local _cProduto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})]
Local _cLoteCtl :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]
Local _nValor	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})]
Local _nDescont	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DESCONT"})]
Local _nValDes	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALDESC"})]
Local _cLocaliz :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOCALIZ"})]

//----> SO EXECUTA O GATILHO SE A FUNCAO FOR MATA410 (PEDIDO DE VENDA)
If UPPER(AllTrim(FunName())) == "MATA410"
	
	dbSelectArea("SM2")
	dbSetOrder(1)
	If dbSeek(Dtos(dDataBase),.f.)
		
		//----> VERIFICA SE TEM TAXA MOEDA CADASTRADA
		If SM2->M2_MOEDA2 > 0 .or. SM2->M2_MOEDA4 > 0
		
			If !Empty(_cLotectl)
				
				dbSelectArea("DA1")
				dbSetOrder(7)
				//----> VERIFICA SE O PRODUTO POSSUI TABELA DE PRECO
				If dbSeek(xFilial("DA1")+M->C5_TABELA+_cProduto+_cLotectl,.f.)
					
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})]//A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})] * xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,1,M->C5_EMISSAO),"C6_PRUNIT")
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})] //A410Arred(FtDescCab((aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})] * xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,1,M->C5_EMISSAO)),{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),"C6_PRCVEN")
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR" })]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})] //A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_X_PRCVE"})]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_X_PRCVE"})] //A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})] / aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})],"C6_X_PRCVE")
					
					If aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})] <= 0
						MsgAlert("O lote n�o possui pre�o de venda cadastrado nesta tabela de pre�o. Ser� assumido o pre�o do produto.","Pre�o de Lista","Stop")
					EndIf
					
				ElseIf dbSeek(xFilial("DA1")+M->C5_TABELA+_cProduto,.f.)
					
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})] //A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})] * xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,1,M->C5_EMISSAO),"C6_PRUNIT")
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})] //A410Arred(FtDescCab((aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})] * xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,1,M->C5_EMISSAO)),{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),"C6_PRCVEN")
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR" })]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})] //A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")
					aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_X_PRCVE"})]	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_X_PRCVE"})] //A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})] / aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})],"C6_X_PRCVE")
					
					If aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})] <= 0
						MsgAlert("O produto n�o possui pre�o de venda cadastrado nesta tabela de pre�o.","Pre�o de Lista","Stop")
					EndIf
				EndIf
			Else
				MsgAlert("Lote n�o informado. � necess�rio informar o lote para busca do pre�o de venda.","Lote","Stop")
			EndIf
		Else
			MsgAlert("Taxa cambial est� zerada nesta data.","Taxa Cambial Zerada","Stop")
		EndIf
	Else
		MsgAlert("Taxa cambial n�o cadastrada nesta data.","Taxa Cambial N�o Cadastrada","Stop")
	EndIf
EndIf

Return(_cLotectl)