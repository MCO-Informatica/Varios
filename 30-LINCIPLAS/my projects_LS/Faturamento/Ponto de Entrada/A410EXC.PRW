#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
+===========================================================+
|Programa: A410EXC |Autor: Antonio Carlos |Data: 15/02/2010 |
+===========================================================+
|Descricao: PE Utilizado para validar a exclusao do Pedido  |
|de Venda.                                                  |
+===========================================================+
|Uso: Laselva                                               |
+===========================================================+
*/

User Function A410EXC()

Local cCodFOri 		:= cFilAnt
Local cCodFOriName 	:= GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + cFilAnt,1)
Local aAreaSM0 		:= SM0->(GetArea())
Local aAreaSA1		:= SA1->(GetArea())
Local nPos 			:= 0
Local nQtd			:= 0
Local aGrvPro 		:= {}
Local nI			:= 0
Local nSC6Rec		:= SC6->(RECNO())
Local _lRet			:= .T.

Local nPosItem		:= aScan( aHeader, { |x| Alltrim(x[2]) == "C6_ITEM"} )
Local nPosProd		:= aScan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO"} )
Local _nPosQtd		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local _nPosTes		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local _nPosLoc		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})


If SC5->C5_TIPO == 'B' .and. left(SC5->C5_USERCAL,2) == 'NF'
	If SF2->(DbSeek(xFilial('SF2') + substr(SC5->C5_USERCAL,4),.F.))
		MsgBox('Este pedido de devolução simbólica refere-se a nota fiscal de devolução física nro ' + substr(SC5->C5_USERCAL,4,9) + ' série ' + right(SC5->C5_USERCAL,3),'ATENÇÃO!!!','ALERT')
		_lRet := .f.
	Else
		_lRet := MsgBox('Este pedido de devolução simbólica refere-se a nota fiscal de devolução física nro ' + substr(SC5->C5_USERCAL,4,9) + ' série ' + right(SC5->C5_USERCAL,3),'Nota Fiscal não existe. Excluir o pedido???','YESNO')
	EndIf
EndIf

IF SC5->C5_CLIENT<'000009' .and. _lRet 
/*	SC6->( DbSetOrder(1) ) 
	If SC6->( DbSeek( xFilial("SC6")+SC5->C5_NUM ) )
		While !SC6->( EOF() ) .AND. SC6->C6_NUM == SC5->C5_NUM
			_cQuery := "UPDATE " + RetSqlName('SB2')
			_cQuery += " SET B2_XRESERV = CASE WHEN B2_XRESERV < 0 THEN 0 ELSE B2_XRESERV END -  "+CVALTOCHAR(SC6->C6_QTDVEN)
			
			_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
			
			_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
			_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ 			= ''"
			_cQuery += _cEnter + " AND F4_CODIGO 				= '"+SC6->C6_TES+"'"
			_cQuery += _cEnter + " AND F4_ESTOQUE 				= 'S'"
			
			_cQuery += _cEnter + " WHERE SC6.D_E_L_E_T_ 		= ''"
			_cQuery += _cEnter + " AND C6_FILIAL 				= '"+SC5->C5_FILIAL+"'"
			_cQuery += _cEnter + " AND C6_NUM 					= '"+SC5->C5_NUM+"'"
			_cQuery += _cEnter + " AND C6_CLI 					< '000009'"
			_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 		= ''"
			_cQuery += _cEnter + " AND B2_FILIAL 				= '"+SC6->C6_LOJA+"'"
			_cQuery += _cEnter + " AND B2_COD 					='"+SC6->C6_PRODUTO+"'"
			_cQuery += _cEnter + " AND B2_LOCAL 				='"+SC6->C6_LOCAL+"'"
			nValSQL := TcSqlExec(_cQuery)
			
			if nValSQL < 0
				alert("Erro na execução do SQL -Delete Reserva filial")
			endif
			SC6->( DbSkip() )
		EndDo
	endif
	*/
	
		For _nI := 1 To Len(aCols)
		//If !aCols[_nI,Len(aHeader)+1]
			
			_cQuery := "UPDATE " + RetSqlName('SB2')
			_cQuery += _cEnter + " SET B2_XRESERV = B2_XRESERV  - "+CVALTOCHAR(aCols[_nI,_nPosQtd ])
			
			_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
			
			_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
			_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ 			= ''"
			_cQuery += _cEnter + " AND F4_CODIGO 				= '"+alltrim(aCols[_nI,_nPosTes])+"'"
			_cQuery += _cEnter + " AND F4_ESTOQUE 				= 'S'"
			
			_cQuery += _cEnter + " WHERE SC6.D_E_L_E_T_ 		= ''"
			_cQuery += _cEnter + " AND C6_FILIAL 				= '"+SC5->C5_FILIAL+"'"
			_cQuery += _cEnter + " AND C6_NUM 					= '"+SC5->C5_NUM+"'"
			_cQuery += _cEnter + " AND C6_CLI 					< '000009'"
			_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 		= ''"
			_cQuery += _cEnter + " AND B2_FILIAL 				= '"+SC5->C5_LOJACLI+"'"
			_cQuery += _cEnter + " AND B2_COD 					='"+alltrim(aCols[_nI,nPosProd])+"'"
			_cQuery += _cEnter + " AND B2_LOCAL 				='"+alltrim(aCols[_nI,_nPosLoc])+"'"
			nValSQL := TcSqlExec(_cQuery)
			
			if nValSQL < 0
				alert("Erro na execução do SQL -Delete Reserva filial")
				alert(_cquery)
				
			endif
		//EndIf
	Next _nI
endif

Return(_lRet)