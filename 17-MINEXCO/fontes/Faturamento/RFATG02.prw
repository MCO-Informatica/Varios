#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATG02  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 10/08/2010 ³±±
±±³          ³          ³       ³     MVG Consultoria     ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Busca o Preco de Venda pelo Lote na Tabela de Preco            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ C6_LOTECTL			                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Minexco                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
				MsgAlert("O produto/lote não possui preço de venda cadastrado nesta tabela de preço.","Preço de Lista","Stop")
			EndIf
		Else
			MsgAlert("O produto/lote não possui preço de venda cadastrado nesta tabela de preço.","Preço de Lista","Stop")
		EndIf
	Else
		MsgAlert("Lote nào informado. É necessário informar o lote para busca do preço de venda.","Lote","Stop")
	EndIf
EndIf

Return(_cLotectl)
