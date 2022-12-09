#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuCCPed  �Autor  �OPVS (David)        � Data �  27/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AtuCCPed(cTipo,cArquivo,cPedGar,cCrtArq,cVlrArq,cVldArq,cBanArq,cParArq,cDatArq,nHandle,nHandlog,nRecAtu,lAtu,cRv,cPv,cDatComp,cIDCC,cCV)
Local lRet		:= .T.

Default lAtu	:= .T.
Default cRv		:= ""
Default cPv     := ""                    
cVldArq := IIF(Len(Alltrim(cVldArq))< 6 , Replicate("0",6-Len(Alltrim(cVldArq)))+cVldArq, cVldArq )

If cTipo == "1"
	lRet := AtuPedGAR(cPedGar,cCrtArq,cVlrArq,cVldArq,cBanArq,	cParArq,cDatArq,nHandle,nHandlog,nRecAtu,lAtu, cArquivo,cIDCC)
EndIf

If cTipo == "2"
	lRet := AtuPedRV(cCrtArq,cVlrArq,cVldArq,cBanArq,cParArq,nHandle,nHandlog,nRecAtu,lAtu,cRv,cArquivo,cPv,cDatComp,cCV)
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuPedGAR �Autor  �Opvs (David)        � Data �  01/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuPedGAR(cPedGar,cCrtArq,cVlrArq,cVldArq,cBanArq,cParArq,cDatArq,nHandle,nHandlog,nRecAtu,lAtu,cArquivo,cIDCC)
Local cSql := ""
Local cMsgLog 	:= ""
Local lLoop		:= .F. 
Local nTotSc6	:= 0
Local cTitBx	:= ""
Local bLog		:= {|nHand,cMsg| iif(nHand > 0 ,FWrite(nHand, cMsg ), nil ) } 

If Empty(cPedGar)
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";02;Pedido do GAR n�o informado no arquivo de retorno" + CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	Return(.F.)
Endif

cSql := " SELECT R_E_C_N_O_ RECC5 FROM "+RetSqlName("SC5")+" WHERE C5_FILIAL = '"+xfilial("SC5")+"' AND C5_CHVBPAG = '"+cPedGar+"' AND D_E_L_E_T_ = ' ' " 	

If select("TMPC5") > 0
	TMPC5->(DbCloseArea())				
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)	

If TMPC5->(EOF())
	/*cSql := " SELECT R_E_C_N_O_ RECC5 FROM "+RetSqlName("SC5")+" WHERE C5_FILIAL = '"+xfilial("SC5")+"' AND C5_CHVBPAG = '' AND C5_MENNOTA LIKE '%"+cPedGar+"%' AND D_E_L_E_T_ = ' ' " 	

	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())				
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)		
	
	If TMPC5->(EOF())
		cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";03;N�o foram econtrados pedidos na Base de dados para Pedido do GAR; "+cPedGar+";"+cIDCC+ CRLF
		Eval(bLog,nHandle, cMsgLog  )
		Eval(bLog,nHandlog, cMsgLog )
		Return(.F.)			
	EndIF */
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";03;N�o foram econtrados pedidos na Base de dados para Pedido do GAR; "+cPedGar+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	Return(.F.)					
EndIf

While !TMPC5->(EOF()) 
	SC5->(DbGoTo(TMPC5->RECC5))		
	
	cSql := " SELECT " 
	cSql += " 	C6_VALOR, " 
	cSql += " 	C6.R_E_C_N_O_ RECC6 "
	cSql += " FROM " 
	cSql += " 	"+RetSqlName("SC6")+" C6 INNER JOIN "+RetSqlName("SF4")+" F4 ON " 
	cSql += " 	C6_TES = F4_CODIGO " 
	cSql += " WHERE " 
	cSql += " 	C6_FILIAL = '"+xfilial("SC6")+"' AND "
	cSql += " 	C6_NUM = '"+SC5->C5_NUM+"' AND " 	
	cSql += " 	C6.D_E_L_E_T_ = ' ' AND "
	cSql += " 	F4_FILIAL = '"+xfilial("SF4")+"' AND " 
	cSql += " 	F4_DUPLIC = 'S' AND " 
	cSql += " 	F4.D_E_L_E_T_ = ' ' "
	
	If select("TMPC6") > 0
		TMPC6->(DbCloseArea())				
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC6",.F.,.T.) 
	
	TcSetField("TMPC6","C6_VALOR","N",15,2)
	
	TMPC6->(DbEval({|| nTotSc6 += TMPC6->C6_VALOR   }))
	
	TMPC5->(DbSkip())

EndDo

nVlrArq := iif(right(cVlrArq,5)==",0000",val(cVlrArq),(Val(cVlrArq)/100))
cBand 	:= IIF(UPPER(SubStr(cBanArq,1,3)) == "MAS","RED",UPPER(SubStr(cBanArq,1,3)))
    
If nTotSc6 <> nVlrArq
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";04;Valor Pedido do GAR difere do valor total do Pedido na base de dados.;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+ ";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
Endif

If !Empty(SC5->C5_XCARTAO) .and. Alltrim(Upper(SC5->C5_XCARTAO)) <> Alltrim(Upper(cCrtArq))
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";05;Codigo Cartao do Pedido GAR difere do Codigo no Pedido na base de dados.;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	Return(.F.)	
ElseIf !Empty(SC5->C5_XCARTAO) .and. Alltrim(Upper(SC5->C5_XCARTAO)) == Alltrim(Upper(cCrtArq)) 
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";06;Codigo Cartao do Pedido GAR ja gravado no Pedido na base de dados.;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	lLoop:= .t.	
EndIf

If !Empty(SC5->C5_XCODAUT) .and. Alltrim(Upper(SC5->C5_XCODAUT)) <> Alltrim(Upper(cVldArq))
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";07;Codigo Validacao de Aut. de Comp. do Pedido GAR difere do Codigo no Pedido na base de dados.;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	lLoop:= .t.	
Elseif !Empty(SC5->C5_XCODAUT) .and. Alltrim(Upper(SC5->C5_XCODAUT)) == Alltrim(Upper(cVldArq))
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";08;Codigo Validacao de Aut. de Comp. do Pedido GAR ja gravado no Pedido na base de dados;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	lLoop:= .t.	
EndIf

If !Empty(SC5->C5_XBANDEI) .and. Alltrim(Upper(SC5->C5_XBANDEI)) <> cBand
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";09;Codigo Bandeira do Pedido GAR difere da Bandeira no Pedido na base de dados. ;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	lLoop:= .t.	
Elseif !Empty(SC5->C5_XBANDEI) .and. Alltrim(Upper(SC5->C5_XBANDEI)) == cBand
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";10;Codigo Bandeira do Pedido GAR ja gravado no Pedido na base de dados;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	lLoop:= .t.	
EndIf

If !Empty(SC5->C5_XTIDCC) .and. Alltrim(Upper(SC5->C5_XTIDCC)) <> cIDCC
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";09;Id do Cartao de Credito do Pedido GAR difere do Pedido na base de dados. ;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	lLoop:= .t.	
Elseif !Empty(SC5->C5_XTIDCC) .and. Alltrim(Upper(SC5->C5_XTIDCC)) == cIDCC
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";10;ID do Pedido GAR ja gravado no Pedido na base de dados;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	lLoop:= .t.	
ElseIf Empty(SC5->C5_XTIDCC)
	lLoop:= .F.		 
EndIf

If !lLoop .or. Empty(SC5->C5_XCARTAO)  

	If lAtu
		RecLock("SC5",.F.)
		SC5->C5_XCARTAO := cCrtArq
		SC5->C5_XCODAUT := cVldArq
		SC5->C5_XBANDEI := cBand
		SC5->C5_XPARCEL := cParArq
		SC5->C5_XVALIDA := cDatArq
		SC5->C5_ARQVTEX	:= cArquivo
		SC5->C5_XTIDCC	:= cIDCC
		SC5->C5_TIPMOV 	:= "2"
		SC5->(Msunlock())		
	EndIf
	
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";11;Pedido GAR Atualizado a Base de Dados;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	
	cSql := " SELECT "
	cSql += " 	E1.R_E_C_N_O_ RECE1 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5 INNER JOIN "+RetSqlName("SC6")+" C6 ON "	
	cSql += " 	C5_FILIAL = C6_FILIAL AND "
	cSql += " 	C5_NUM = C6_NUM INNER JOIN "+RetSqlName("SE1")+" E1 ON "
	cSql += " 	C6_NOTA = E1_NUM AND "
	cSql += " 	E1_PREFIXO = 'SP'||SUBSTR(C6_SERIE,1,1) " 
	cSql += " WHERE "
	cSql += " 	C5_FILIAL = '"+xFilial("SC5")+"' AND "
	cSql += " 	C5_NUM = '"+SC5->C5_NUM+"' AND "
	cSql += " 	C5.D_E_L_E_T_ = ' ' AND "	
	cSql += " 	C6_FILIAL = '"+xFilial("SC6")+"' AND "	
	cSql += " 	C6_XOPER<>'53' AND "
	cSql += " 	C6.D_E_L_E_T_ = ' '  AND "
	cSql += " 	E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " 	E1_PEDGAR = ' ' AND "		
	cSql += " 	E1.D_E_L_E_T_ = ' ' "
	cSql += " GROUP BY " 
	cSql += " 	E1.R_E_C_N_O_ "
	
	If select("TMPE1") > 0
		TMPE1->(DbCloseArea())				
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPE1",.F.,.T.)				
	
	If TMPE1->(Eof())
		cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";12;N�o foram encontrados  Titulos ligados ao Pedido GAR ;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
		Eval(bLog,nHandle, cMsgLog  )
		Eval(bLog,nHandlog, cMsgLog )
	EndIf
	
	While !TMPE1->(Eof())
		SE1->(DbGoTo(TMPE1->RECE1))
		
		If lAtu
			RecLock("SE1",.F.)
			SE1->E1_PEDGAR := cPedGar
			SE1->E1_TIPMOV := "2"
			SE1->(MsUnlock())
		EndIf
		
		cTitBx += ALLTRIM(SE1->(E1_PREFIXO+E1_NUM+E1_TIPO+E1_PARCELA))+"/"
		
		TMPE1->(DbSkip())
	EndDo
	
	If !Empty(cTitBx)
		cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";13;Os  Titulos ligados ao Pedido GAR foram Atualizado na Base de Dados.;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cTitBx+";"+cIDCC+ CRLF
		Eval(bLog,nHandle, cMsgLog  )
	EndIf
Else
	cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";14;Pedido GAR n�o Atualizado a Base de Dados.;"+cPedGar+";"+Transform(nVlrArq,"@E 999,999.99")+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Alltrim(Upper(cCrtArq))+";"+Alltrim(Upper(SC5->C5_XCARTAO))+";"+Alltrim(Upper(cVldArq))+";"+Alltrim(Upper(SC5->C5_XCODAUT))+";"+cBand+";"+SC5->C5_XBANDEI+";"+SC5->C5_NUM+";"+cIDCC+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	Return(.F.)
EndIf

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuPedRV  �Autor  �Opvs (David)        � Data �  01/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuPedRV(cCrtArq,cVlrArq,cVldArq,cBanArq,cParArq,nHandle,nHandlog,nRecAtu,lAtu,cRv,cArquivo,cPv,cDatComp,cCV)
Local cSql := ""
Local cMsgLog 	:= ""
Local lLoop		:= .F. 
Local nTotSc6	:= 0
Local cTitBx	:= ""
Local bLog		:= {|nHand,cMsg| iif(nHand > 0 ,FWrite(nHand, cMsg ), nil ) } 
Local cBand 	:= IIF(UPPER(SubStr(cBanArq,1,3)) == "MAS","RED",UPPER(SubStr(cBanArq,1,3)))
Local cIniCar	:= Left(cCrtArq,6)
Local cFimCar	:= Right(cCrtArq,4) 

cSql := " SELECT R_E_C_N_O_ RECC5 "
cSql +=	" FROM "+RetSqlName("SC5")
cSql +=	" WHERE C5_FILIAL = '"+xfilial("SC5")+"' AND"
cSql +=			" SUBSTR(C5_XCARTAO,1,6) = '"+cIniCar+"' AND "
cSql +=			" SUBSTR(C5_XCARTAO,-4) = '"+cFimCar+"' AND " 	
cSql +=			" UPPER(SUBSTR(C5_XCODAUT,1,6)) = '"+cVldArq+"' AND "
If UPPER(SubStr(cBanArq,1,3)) = "MAS"
	cSql +=	" C5_XBANDEI IN ('"+cBand+"','MASTERCARD') AND " 			
ElseIf UPPER(SubStr(cBanArq,1,3)) = "VIS"
	cSql +=	" C5_XBANDEI IN ('"+cBand+"','VISA') AND " 			 
ElseIf UPPER(SubStr(cBanArq,1,3)) = "AME"
	cSql +=	" C5_XBANDEI IN ('"+cBand+"','AMEX') AND "
Else
	cSql +=	" C5_XBANDEI IN ('"+cBand+"') AND "
EndIf
cSql +=	" D_E_L_E_T_ = ' ' "

If select("TMPC5") > 0
	TMPC5->(DbCloseArea())				
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)	

If TMPC5->(EOF())
	cSql := " SELECT R_E_C_N_O_ RECC5 "
	cSql +=	" FROM "+RetSqlName("SC5")
	cSql +=	" WHERE C5_FILIAL = '"+xfilial("SC5")+"' AND"
	cSql +=			" C5_MENNOTA LIKE '%"+cFimCar+"%' AND " 	
	cSql +=			" C5_MENNOTA LIKE '%"+cVldArq+"%' AND " 	
	If UPPER(SubStr(cBanArq,1,3)) = "MAS"
		cSql +=			" UPPER(C5_MENNOTA) LIKE '%MASTER%' AND " 	
	ElseIf UPPER(SubStr(cBanArq,1,3)) = "VIS"
		cSql +=			" UPPER(C5_MENNOTA) LIKE '%VISA%' AND "
	ElseIf UPPER(SubStr(cBanArq,1,3)) = "AME"
		cSql +=			" UPPER(C5_MENNOTA) LIKE '%AMEX%' AND "
	EndIf
	cSql +=	" D_E_L_E_T_ = ' ' " 	
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())				
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)	

	If TMPC5->(EOF())
		cSql := " SELECT R_E_C_N_O_ RECC5 "
		cSql +=	" FROM "+RetSqlName("SC5")
		cSql +=	" WHERE C5_FILIAL = '"+xfilial("SC5")+"' AND"
		cSql +=			" SUBSTR(C5_XCARTAO,1,6) = '"+cIniCar+"' AND " 	
		cSql +=			" SUBSTR(C5_XCARTAO,-4) = '"+cFimCar+"' AND " 	
		cSql +=			" (C5_XCODAUT LIKE '%"+cCV+"%' OR " 	
		cSql +=			"  C5_XTIDCC = '"+cCV+"') AND " 	
		If UPPER(SubStr(cBanArq,1,3)) = "MAS"
			cSql +=	" C5_XBANDEI IN ('"+cBand+"','MASTERCARD') AND " 			
		ElseIf UPPER(SubStr(cBanArq,1,3)) = "VIS"
			cSql +=	" C5_XBANDEI IN ('"+cBand+"','VISA') AND " 			 
		ElseIf UPPER(SubStr(cBanArq,1,3)) = "AME"
			cSql +=	" C5_XBANDEI IN ('"+cBand+"','AMEX') AND "
		Else
			cSql +=	" C5_XBANDEI IN ('"+cBand+"') AND "
		EndIf
		cSql +=	" D_E_L_E_T_ = ' ' " 	
		
		If select("TMPC5") > 0
			TMPC5->(DbCloseArea())				
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)	
	
		If TMPC5->(EOF())
			cMsgLog := alltrim(cArquivo)+";"+AllTrim(Strzero(nRecAtu,6))+";02;N�o foram econtrados pedidos na Base de dados.;"+cBand+";"+cCrtArq+";"+cParArq+";"+cVldArq+";"+cRv+";"+cPV+";"+Left(cDatComp,2)+"/"+SubStr(cDatComp,3,2)+"/"+Right(cDatComp,4)+ CRLF
			Eval(bLog,nHandle, cMsgLog  )
			Eval(bLog,nHandlog, cMsgLog )
			Return(.F.)
		EndIf	
	EndIf
EndIf

While !TMPC5->(EOF()) 
	SC5->(DbGoTo(TMPC5->RECC5))		
	
	cSql := " SELECT " 
	cSql += " 	C6_VALOR, " 
	cSql += " 	C6.R_E_C_N_O_ RECC6 "
	cSql += " FROM " 
	cSql += " 	"+RetSqlName("SC6")+" C6 INNER JOIN "+RetSqlName("SF4")+" F4 ON " 
	cSql += " 	C6_TES = F4_CODIGO " 
	cSql += " WHERE " 
	cSql += " 	C6_FILIAL = '"+xfilial("SC6")+"' AND "
	cSql += " 	C6_NUM = '"+SC5->C5_NUM+"' AND " 	
	cSql += " 	C6.D_E_L_E_T_ = ' ' AND "
	cSql += " 	F4_FILIAL = '"+xfilial("SF4")+"' AND " 
	cSql += " 	F4_DUPLIC = 'S' AND " 
	cSql += " 	F4.D_E_L_E_T_ = ' ' "
	
	If select("TMPC6") > 0
		TMPC6->(DbCloseArea())				
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC6",.F.,.T.) 
	
	TcSetField("TMPC6","C6_VALOR","N",15,2)
	
	TMPC6->(DbEval({|| nTotSc6 += TMPC6->C6_VALOR   }))
	
	TMPC5->(DbSkip())

EndDo
  

If !lLoop
	If nTotSc6 <> (Val(cVlrArq)/100)
		cMsgLog := alltrim(cArquivo)+";"+AllTrim(Strzero(nRecAtu,6))+";03;Valor difere do valor total do Pedido na base de dados.;"+cBand+";"+cCrtArq+";"+cParArq+";"+cVldArq+";"+cRv+";"+cPV+";"+Left(cDatComp,2)+"/"+SubStr(cDatComp,3,2)+"/"+Right(cDatComp,4)+";"+SC5->C5_NUM+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Transform(Val(cVlrArq)/100,"@E 999,999.99")+ CRLF
		Eval(bLog,nHandle, cMsgLog  )
	Endif
	
	If lAtu
		RecLock("SC5",.F.)
		SC5->C5_XARQCC:= cArquivo
		SC5->C5_XRVCC 	:= cRv
		SC5->C5_TIPMOV	:= "2"
		SC5->(Msunlock())		
	EndIf
	
	cMsgLog := alltrim(cArquivo)+";"+AllTrim(Strzero(nRecAtu,6))+";04;Pedido Atualizado na Base de Dados;"+cBand+";"+cCrtArq+";"+cParArq+";"+cVldArq+";"+cRv+";"+cPV+";"+Left(cDatComp,2)+"/"+SubStr(cDatComp,3,2)+"/"+Right(cDatComp,4)+";"+SC5->C5_NUM+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Transform(Val(cVlrArq)/100,"@E 999,999.99")+ CRLF
	Eval(bLog,nHandle, cMsgLog  )	
	
Else
	cMsgLog := alltrim(cArquivo)+";"+AllTrim(Strzero(nRecAtu,6))+";05;Pedido n�o Atualizado na Base de Dados;"+cBand+";"+cCrtArq+";"+cParArq+";"+cVldArq+";"+cRv+";"+cPV+";"+Left(cDatComp,2)+"/"+SubStr(cDatComp,3,2)+"/"+Right(cDatComp,4)+";"+SC5->C5_NUM+";"+Transform(nTotSc6,"@E 999,999.99")+";"+Transform(Val(cVlrArq)/100,"@E 999,999.99")+ CRLF
	Eval(bLog,nHandle, cMsgLog  )
	Eval(bLog,nHandlog, cMsgLog )
	Return(.F.)
EndIf

Return(.T.)