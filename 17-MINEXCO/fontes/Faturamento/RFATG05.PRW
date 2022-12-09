#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATG05  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 10/08/2010 ³±±
±±³          ³          ³       ³     MVG Consultoria     ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Recalcula os Precos e Totais do Pedido                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ C6_X_PRCVE			                                          ³±±
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

User Function RFATG05()

Local _nQtdVen	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})]
Local _nPrcVen	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]
Local _nXprcve	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_X_PRCVE"})]
Local _cProduto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})]
Local _cLoteCtl :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]
Local _nValor	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})]
Local _nDescont	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DESCONT"})]
Local _nValDes	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALDESC"})]
Local _cLocaliz :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOCALIZ"})]

//----> SO EXECUTA O GATILHO SE A FUNCAO FOR MATA410 (PEDIDO DE VENDA)
If UPPER(AllTrim(FunName())) == "MATA410"
	
	//----> VERIFICA SE TEM TAXA MOEDA CADASTRADA
	If _nXprcve > 0
		
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})]	:=	A410Arred(_nXprcve * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})],"C6_PRUNIT")
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]	:=	A410Arred(_nXprcve * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_UNSVEN"})],"C6_PRCVEN")
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR" })]	:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")
	EndIf
EndIf

Return(_nXprcve)
