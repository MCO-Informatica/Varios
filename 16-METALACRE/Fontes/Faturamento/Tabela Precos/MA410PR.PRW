#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA410PR บ Autor ณ Luiz Alberto V Alvesบ Data ณ  19/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada na Selecao de Grupo de Opcionais  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO Metalacre                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA410PR()
Local nPPrcVen :=   aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPPrUnit :=   aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPValor := aScan(aHeader,{|x|   AllTrim(x[2])=="C6_VALOR"})
Local nPQtdVen := aScan(aHeader,{|x|   AllTrim(x[2])=="C6_QTDVEN" })
Local nPDescon := aScan(aHeader,{|x|   AllTrim(x[2])=="C6_DESCONT"})
Local _cTES	:= aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_TES"})]
Local _nPrcVen	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]


If cEmpAnt <> '01'
	Return _nPrcVen
Endif      

/*If cEmpAnt == '01'	// Apenas Metalacre
	// Se a Tes Nใo Gerar Duplicata entใo Ignora Informa็ใo da Tabela
	
	If SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+_cTES))
		If SF4->F4_DUPLIC <> 'S'
			Return _nPrcVen
		Endif
	Endif
	
	
	nPrcRet := U_RFATG01(2,.f.) // Igual a 1 Retorna Quantidade, Igual a 2 Retorna Valor Unitario 
	_nPrcVen := nPrcRet
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})]	:=	_nPrcVen//nPrcRet
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]	:=	FtDescCab(nPrcRet,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR" })]	:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")
		
Endif */
Return _nPrcVen