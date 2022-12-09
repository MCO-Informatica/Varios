#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TOPCONN.CH"

User Function KFAT30M()

Local _cQuery	  := ""    
Local _lTemMsg    := .F.
Local _lAleMsg    := .F.
Local _cEol		  := Chr(13)+Chr(10)
Local _cMsg		  := ""
Local _cMsgFin	  := " Favor informar o departamento financeiro."
Local _nValSE1	  := 0
Local _nValSC6	  := 0
Local _nValAtr	  := 0
Local _nLimite	  := 0
Local _cCliente	  := M->C5_CLIENTE
Local _cLoja	  := M->C5_LOJAENT
Local _aArea	  := GetArea()

// Verifica Data Limite Credito
_dDtLimCred 	:= POSICIONE("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_VENCLC")
_nLimite 		:= POSICIONE("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_LC")
_cRisco			:= POSICIONE("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_RISCO")



If !Empty(_dDtLimCred)
	If _dDtLimCred < DATE()
		If _cRisco$"A"
    		_cMsg += "Data do limite de crédito ("+DTOC(_dDtLimCred)+") do cliente expirou, porém o risco é 'A'."+_cEol
        Else
			_cMsg += "Data do limite de crédito ("+DTOC(_dDtLimCred)+") do cliente expirou. O Pedido de venda não poderá ser digitado."+_cEol
	 	EndIf
		
		_lTemMsg := .T.

	EndIf		
EndIf                                           

If _nLimite <= 1
		
		If _cRisco$"A"
			_cMsg += "O cliente não possui limite de crédito disponível, porém o risco é 'A'."+_cEol
		Else
			_cMsg += "O cliente não possui limite de crédito disponível. O Pedido de venda não poderá ser digitado."+_cEol+_cEol
        EndIf
        
		_lTemMsg := .T.
EndIf                                           


_cQuery := " SELECT	SA1.A1_COD AS CLIENTE, SA1.A1_LOJA AS LOJA, SA1.A1_LC LIMITE, SUM(ISNULL(DAD.C5_VALOR,0)) VALOR, DAD.C5_OBS IDENTIF " + _cEol
_cQuery += " FROM	"+RetSqlName("SA1")+" SA1 " + _cEol
_cQuery += " LEFT	JOIN	(	SELECT	SC5.C5_FILIAL, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) C5_VALOR, '03 - PEDIDO EM ABERTO' C5_OBS " + _cEol
_cQuery += " FROM	"+RetSqlName("SC5")+" SC5 " + _cEol
_cQuery += " INNER	JOIN "+RetSqlName("SC6")+" SC6 ON " + _cEol
_cQuery += " SC5.C5_FILIAL = SC6.C6_FILIAL AND " + _cEol
_cQuery += " SC5.C5_CLIENTE = SC6.C6_CLI AND " + _cEol
_cQuery += " SC5.C5_LOJACLI = SC6.C6_LOJA AND " + _cEol
_cQuery += " SC5.C5_NUM = SC6.C6_NUM AND " + _cEol
_cQuery += " SC6.C6_QTDVEN>C6_QTDENT AND " + _cEol
_cQuery += " SC6.C6_BLQ <> 'R' AND " + _cEol
_cQuery += " SC6.D_E_L_E_T_ = ' ' " + _cEol
_cQuery += " INNER JOIN SF4010 SF4 ON " + _cEol 
_cQuery += " SF4.F4_CODIGO = SC6.C6_TES AND " + _cEol
_cQuery += " SF4.F4_DUPLIC = 'S' AND " + _cEol
_cQuery += " SF4.D_E_L_E_T_ = ' ' " + _cEol
_cQuery += " WHERE	SC5.C5_NOTA = ' ' AND " + _cEol
_cQuery += " SC5.D_E_L_E_T_ = ' ' " + _cEol
_cQuery += " GROUP	BY SC5.C5_FILIAL, SC5.C5_CLIENTE, SC5.C5_LOJACLI " + _cEol
_cQuery += " UNION ALL" + _cEol
_cQuery += " SELECT	SE1.E1_FILIAL,SE1.E1_CLIENTE,SE1.E1_LOJA, SUM(SE1.E1_SALDO) E1_VALOR, " + _cEol
_cQuery += " CASE WHEN SE1.E1_VENCREA < '"+dtos(dDatabase-1)+"' THEN '01 - TITULOS EM ATRASO' ELSE '02 - TITULOS EM ABERTO' END E1_OBS " + _cEol    
_cQuery += " FROM	"+RetSqlName("SE1")+" SE1 " + _cEol
_cQuery += " WHERE	SE1.E1_SALDO > 0 " + _cEol
_cQuery += " AND SE1.D_E_L_E_T_ = ' ' " + _cEol
_cQuery += " GROUP	BY SE1.E1_FILIAL,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_VENCREA ) DAD ON " + _cEol
_cQuery += " SA1.A1_COD = DAD.C5_CLIENTE AND " + _cEol
_cQuery += " SA1.A1_LOJA = DAD.C5_LOJACLI " + _cEol
_cQuery += " WHERE	SA1.A1_COD = '"+_cCliente+"' AND " + _cEol
_cQuery += " SA1.A1_LOJA = '"+_cLoja+"' AND " + _cEol
_cQuery += " SA1.D_E_L_E_T_ = ' ' " + _cEol
_cQuery += " GROUP	BY SA1.A1_COD,SA1.A1_LOJA,SA1.A1_LC,DAD.C5_OBS " + _cEol
_cQuery += " ORDER	BY DAD.C5_OBS " + _cEol

_cQuery := ChangeQuery(_cQuery)
	
If Select("TMPSE1") > 0
	TMPSE1->(DbCloseArea())	
EndIf
	
TcQuery _cQuery New Alias "TMPSE1"
	
While !TMPSE1->(Eof())
	If TMPSE1->VALOR > 0
		
		_nLimite	:=	TMPSE1->LIMITE
		
		If SUBSTR(TMPSE1->IDENTIF,1,2) == '01'
			_nValAtr := _nValAtr + TMPSE1->VALOR
		ElseIf SUBSTR(TMPSE1->IDENTIF,1,2) == '02'
			_nValSE1 := _nValSE1 + TMPSE1->VALOR
		ElseIf SUBSTR(TMPSE1->IDENTIF,1,2) == '03'
			_nValSC6 := _nValSC6 + TMPSE1->VALOR
		EndIf	
	EndIf		
	
	DbSelectArea("TMPSE1")
	DbSkip()   	
EndDo
	
If _nValAtr > 0 
	_cMsg += "Títulos em Atraso: " +(Transform(_nValAtr,"@E 999,999,999.99"))+_cEol

	If !_cRisco$"A"
		_cMsg += "O Pedido de venda nao poderá ser digitado."+_cEol+_cEol
 	EndIf
 
	_lTemMsg := .T.

EndIf

If (_nValSE1 + _nValSC6) > _nLimite
	_cMsg += "Valores em Aberto ultrapassam o limite de crédito."+_cEol
	_cMsg += "Limite de Crédito: " +(Transform(_nLimite,"@E 999,999,999.99"))+_cEol
	_cMsg += "(A) Títulos em Aberto: " +(Transform(_nValSE1,"@E 999,999,999.99"))+_cEol
	_cMsg += "(B) Pedidos em Aberto: " +(Transform(_nValSC6,"@E 999,999,999.99"))+_cEol
	_cMsg += "Total A + B: " +(Transform(_nValSE1+_nValSC6,"@E 999,999,999.99"))+_cEol+_cEol
	
	If !_cRisco$"A"
		_cMsg += "O Pedido de venda nao poderá ser digitado."+_cEol
 	EndIf
 	   
	_lTemMsg := .T.

EndIf

If Select("TMPSE1") > 0
	TMPSE1->(DbCloseArea())	
EndIf
	
If _lTemMsg
	_cMsgInfo   := _cMsg+_cMsgFin+_cEol
	_lAleMsg    := .T.     
	_cMsg 		:= ""	
EndIf
	
If _lAleMsg .and. !Empty(Alltrim(_cMsgInfo))
	MsgStop(_cMsgInfo,"Atencao!!!")	
	If !_cRisco$"A"
		_cCliente	:= ""
		_cLoja		:= ""
	EndIf
EndIf          
	
RestArea(_aArea)                        

Return(_cCliente)