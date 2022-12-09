#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SET.CH" 
/*
Descrição: APOS GERACAO DO ACOLS NA BAIXA ORCAMENTO
Executado apos o preenchimento do aCols na Baixa do Orcamento de Vendas.
*/

User Function MTA416PV()

	Local aArea := GetArea()
	Local nAux := PARAMIXB

	nPos1 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XMOEDA'})   
	nPos2 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XTAXA'})
	nPos3 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XPRUNIT'})
	nPos4 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XPRTABR'})
	nPos5 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XPRTABO'})  //não criado ainda
	nPos6 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XPRCALC'})
	nPos7 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XPISCOF'})
	nPos8 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XICMEST'})
	nPos9 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XVRMARG'})
	nPos10 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XPRMARG'})
	nPos11 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_EMBRET'})
	nPos12 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XOPER'})
	nPos13 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XOBSMAR'})

	nPos14 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_NUMPCOM'})
	nPos15 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_ITEMPC'})
	nPos16 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XVLRINF'})
	nPos17 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XMEDIO'})
	nPos18 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_ENTREG'})
	nPos19 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_LOTECTL'})
	nPos20 := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XDESMOE'})

	_aCols[nAux,nPos1] := SCK->CK_XMOEDA
	_aCols[nAux,nPos2] := SCK->CK_XTAXA
	_aCols[nAux,nPos3] := SCK->CK_XPRUNIT  
	_aCols[nAux,nPos4] := SCK->CK_XPRTABR
	_aCols[nAux,nPos5] := SCK->CK_XPRTABO
	_aCols[nAux,nPos6] := SCK->CK_XPRCALC   
	_aCols[nAux,nPos7] := SCK->CK_XPISCOF
	_aCols[nAux,nPos8] := SCK->CK_XICMEST
	_aCols[nAux,nPos9] := SCK->CK_XVRMARG
	_aCols[nAux,nPos10] := SCK->CK_XPRMARG
	_aCols[nAux,nPos11] := SCK->CK_XRETEMB
	_aCols[nAux,nPos12] := SCK->CK_XOPER
	_aCols[nAux,nPos13] := SCK->CK_XOBSMAR

	_aCols[nAux,nPos14] := SCK->CK_PEDCLI
	_aCols[nAux,nPos15] := SCK->CK_XITEMPC
	_aCols[nAux,nPos16] := SCK->CK_XVLRINF
	_aCols[nAux,nPos17] := SCK->CK_XMEDIO
	_aCols[nAux,nPos18] := SCK->CK_ENTREG
	_aCols[nAux,nPos19] := SCK->CK_LOTECTL
	_aCols[nAux,nPos20] := IIF(SCK->CK_XMOEDA=1,'R$',IIF(SCK->CK_XMOEDA=2,'US$',IIF(SCK->CK_XMOEDA=4,'EUR','OUTRAS')))               

	RestArea(aArea)

Return Nil
