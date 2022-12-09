#include "rwmake.ch"

//=========================================================================//
// Programa  : EXPRC05   Autor: EDUARDO FELIPE DA SILVA  Data: 11/10/2005  //
//=========================================================================//
// Descrição : Gatilho disparado no codigo de produto retona preco         //
//=========================================================================//
// Uso       : Especifico Expand                                           //
//=========================================================================//

User Function EXPRC05()  

Local cAlias 		:= Alias()
Local cIndex 		:= IndexOrd()
Local nRecno 		:= Recno()
Local _cCod 		:= Acols[n][aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_PRODUTO" })]
Local _cPosDescri	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_DESCRI" })
Local _nPosprcTab 	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_PRCTAB" })
Local _nPosprcUni 	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_VRUNIT" })
Local _nPosVlrTot 	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_VLRITEM"})
Local _nPosCodTab 	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_TABELA" })
Local _nPosPrcPro 	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_PRCPROM"})// 20/09/04 Alteração
Local _nPosPerPad 	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_DESC"   })// 20/09/04 Alteração
Local _nPosVlrPad 	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_VALDESC"})// 20/09/04 Alteração
Local _nPosQuant	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "L2_QUANT"  })// 20/09/04 Alteração
Local lRet     		:= .T.
Local _nPre    		:= 0
Local _nTxdolar	  	:= 0
Local _cCodTab 		:= "1"
Local _nValDesc		:= 0
Local _nQuant		:= Iif(Empty(Acols[n][_nPosQuant]),1,Acols[n][_nPosQuant]) //Acols[n][_nPosQuant]
Local _nVlrItem		:= 0

 
If Posicione("SB2",1,xFilial("SB2")+_cCod+"01","B2_QATU") <= 0 .And. ! FunName() $ "ESMREST/EXPREST" 
	_nQuant := 0
EndIf

DbSelectArea("SB0")
DbSetOrder(1)
If DbSeek(xFilial("SB0")+_cCod)
	If dDataBase>=SB0->B0_INIDT2 .and. dDataBase<=SB0->B0_DATA2
	   	_nPre		:= SB0->B0_PRV2
	   	_nVlrItem	:= _nQuant * _nPre
		_cCodTab	:= "2"
    Else
		_nPre		:= SB0->B0_PRV1
		_nVlrItem	:= _nQuant * _nPre
	EndIf
	If FunName() $ "ESMREST/EXPREST" 
 		Acols[n][_nPosQuant]  := _nQuant
 		Acols[n][_nPosprcUni] := Round(_nPre,2)
 		//Acols[n][_nPosVlrTot] := Round(_nQuant * _nPre,2) 
 		Acols[n][_nPosVlrTot] := Acols[n][_nPosQuant] * Acols[n][_nPosprcUni]
 		Acols[n][_cPosDescri] := Posicione("SB1",1,xFilial("SB1")+_cCod,"B1_DESC")
		U_ValQtde()
		DbSelectArea(cAlias)
		DbSetOrder(cIndex)
		DbGoto(nRecno)
    	Return(_nPre)
	EndIf
	Acols[n][_nPosQuant]  := _nQuant
	Acols[n][_nPosPrcPro] := SB0->B0_PRV1//_nPre															// Preço da promoção
	Acols[n][_nPosprcTab] := _nPre// SB0->B0_PRV1													// Preço de tabela
	Acols[n][_nPosCodTab] := _cCodTab
	Acols[n][_nPosprcUni] := Round(_nPre -((_nPre * Acols[n][_nPosPerPad])/100),2)     
	Acols[n][_nPosVlrPad] := Round((_nPre * _nQuant * Acols[n][_nPosPerPad])/100,2)                                          
	Acols[n][_nPosVlrTot] := Round((_nPre * _nQuant) - Acols[n][_nPosVlrPad],2)                                              
Endif

IF _nPre <= 0 .And. Len(_cCod) < 13
	MsgAlert("Não existe preço cadastrado para este produto.","Atenção")
	aCols[n,Len(aHeader)+1] := .T.
ElseIf FunName() $ "ESMREST" 
	 U_EsmBal()	
	 U_ValQtde()
EndIF   



DbSelectArea(cAlias)
DbSetOrder(cIndex)
DbGoto(nRecno)

Return(Acols[n][_nPosprcUni])