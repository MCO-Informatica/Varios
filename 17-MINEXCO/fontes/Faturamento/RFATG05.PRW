#include "protheus.ch"
/*
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????Ŀ??
???Programa  ? RFATG05  ? Autor ? Ricardo Correa de Souza ? Data ? 10/08/2010 ???
???          ?          ?       ?     MVG Consultoria     ?      ?            ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Descricao ? Recalcula os Precos e Totais do Pedido                         ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Observacao? C6_X_PRCVE			                                          ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ? Minexco                                                        ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???             ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL              ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Programador   ?  Data  ?              Motivo da Alteracao                  ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???              ?        ?                                                   ???
??????????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
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
