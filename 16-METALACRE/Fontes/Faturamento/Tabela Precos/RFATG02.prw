#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATG02  ³ Autor ³ Luiz Alberto V Alves    ³ Data ³ 19/02/2014 ³±±
±±³          ³          ³       ³     3L Systems          ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta o Preco de Venda Com Base Tabela Precos Quantidade Mts. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ UB_VRUNIT UB_QUANT                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Metalacre Ind e Com Lacres Ltda                                ³±±
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
Local aArea			:= GetArea()
Local _nAnt			:= n
Local _nPosProd		:= aScan(aHeader,{|e|Trim(e[2])=="UB_PRODUTO"})
Local _nPosValDesc	:= aScan(aHeader,{|e|Trim(e[2])=="UB_VALDESC"})
Local _nPosDescPer	:= aScan(aHeader,{|e|Trim(e[2])=="UB_DESC"})
Local _nPosVrUnit	:= aScan(aHeader,{|e|Trim(e[2])=="UB_VRUNIT"})
Local _nPosQtdVen	:= aScan(aHeader,{|e|Trim(e[2])=="UB_QUANT"})
Local cTabPadrao	:=  GetMV("MV_TBQPAD")

_nVrunit		:= aCols[n][_nPosVrUnit]
_cDescper		:= aCols[n][_nPosDescPer]
_nValdesc		:= aCols[n][_nPosValDesc]
_nQtdVen		:= aCols[n][_nPosQtdVen]
_cCodProd		:= aCols[n][_nPosProd]


If Empty(cTabPadrao)
	Alert("Atenção Parâmetro da Tabela Quantidade Está Vazio, Verifique MV_TBQPAD !!!")
	RestArea(aArea)
	Return _nQtdVen
Endif

nPrcTab := _nVrunit

   // Busca Valor do Produto com Base na Quantidade Tabela de Preços Quantidades
	
If SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8")+cTabPadrao+_cCodProd))
	If _nQtdVen <= 1000
		nPrcTab := SZ8->Z8_P00500
	ElseIf _nQtdVen >= 1001 .And. _nQtdVen <= 5000
		nPrcTab := SZ8->Z8_P03000
	ElseIf _nQtdVen >= 5001 .And. _nQtdVen <= 10000
		nPrcTab := SZ8->Z8_P05000
	ElseIf _nQtdVen >= 10001 .And. _nQtdVen <= 50000
		nPrcTab := SZ8->Z8_P20000
	ElseIf _nQtdVen >= 50001 
		nPrcTab := SZ8->Z8_P20001
	Else
		nPrcTab := _nVrunit
	Endif			

	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})]	:=	nPrcTab
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VLRITEM" })]	:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_QUANT"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})],"UB_VLRITEM")
	M->UB_VLRITEM           									:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_QUANT"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})],"UB_VLRITEM")
	If aScan(aHeader,{|x| Alltrim(x[2])== "UB_XTAB"}) > 0
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XTAB"})]	:=	nPrcTab
	Endif

	Tk273trigger("UB_VLRITEM")

Endif
RestArea(aArea)
n		:= _nAnt
Return(_nQtdVen)
