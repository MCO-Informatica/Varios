#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �M410STTS	�Autor  �Microsiga		     � Data �  13/12/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada ap�s a inclus�o do pedido de venda	      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function M410STTS()

	Local aArea 	:= GetArea()
	Local cPedido	:= SC5->C5_NUM
	
	If INCLUI .Or. ALTERA

		//Verifica se existe bloqueio no pedido, para ravar flag
		If IsBlqPv(cPedido)
			Aviso("Aten��o","O pedido foi enviado para aprova��o, devido n�o atender os requisitos necess�rios. ",{"Ok"},2)
		
		ElseIf !U_PZCVP010(cPedido)//Efetua a libera��o do pedido
			Aviso("Aten��o","Pedido bloqueado por credito.",{"Ok"},2)
		
		Else
			u_RFATR002()
		EndIf
	EndIf	

	RestArea(aArea)	
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �IsBlqPv		�Autor  �Microsiga		 � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica a necessidade de bloqueio do pedido			      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function IsBlqPv(cPedido)

	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .F.
	Local nValorTot	:= 0
	Local lBlqDtPcp	:= .F.
	Local lBlqVlMin	:= .F.
	Local nDiasAdd	:= U_MyNewSX6("CV_ADDPROD", 1	,"N","Quantidade de dias a ser adicionado na produ��o", "", "", .F. )
	Local nTxMoed	:= 0
	Local lProcMoed	:= .F.
	Local nMinFt 	:= SuperGetMv('MV_VLMIFAT',,2000)
	Local cCodULib	:= U_MyNewSX6("CV_USLBAPV", ""	,"C","Usuarios liberados a alterar pedido, sem interferir no bloqueio", "", "", .F. )
	Local cCodUsr	:= Alltrim(RetCodUsr())
	Local lFin		:= .F.
	Local cCFOPNCicl	:= U_MyNewSX6("CV_NCFOPCI", "5911|6911|7949"	,"C","CFOP que n�o considera o ciclo", "", "", .F. )
	Local cCfop		:= ""
	
	Default cPedido	:= ""

	//Verifica se o usuario precisa passar pela valida��o do bloqueio em caso de altera��o
	If !(Alltrim(cCodUsr) $ Alltrim(cCodULib))

		cQuery	:= " SELECT C5_TXMOEDA, C5_MOEDA, SC5.R_E_C_N_O_ RECSC5,C6_VALOR, C6_ITEM, C6_TES, "+CRLF
		cQuery	+= " C6_LOCAL, C6_PRODUTO, C6_ENTREG, C6_QTDVEN, C6_YDTCPRO FROM "+RetSqlName("SC5")+" SC5 "+CRLF

		cQuery	+= " INNER JOIN "+RetSqlName("SC6")+" SC6 "+CRLF
		cQuery	+= " ON SC6.C6_FILIAL = SC5.C5_FILIAL " +CRLF
		cQuery	+= " AND SC6.C6_NUM = SC5.C5_NUM "+CRLF
		cQuery	+= " AND SC6.D_E_L_E_T_ = ' ' "+CRLF

		cQuery	+= " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "+CRLF
		cQuery	+= " AND SC5.C5_NUM = '"+cPedido+"' " +CRLF
		cQuery	+= " AND SC5.D_E_L_E_T_ = ' ' "+CRLF

		DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

		While (cArqTmp)->(!Eof())
			cCfop	:= ""
			cCfop	:= Posicione("SF4",1,xFilial("SF4") + (cArqTmp)->C6_TES , 'F4_CF' )
			
			If Alltrim(Posicione("SF4",1,xFilial("SF4") + (cArqTmp)->C6_TES , 'F4_DUPLIC' )) == "S"
				lFin := .T.
				
				//Preenche a taxa da moeda
				If !lProcMoed
					If (cArqTmp)->C5_MOEDA == 1
						nTxMoed := 1
					Else
						nTxMoed := (cArqTmp)->C5_TXMOEDA
					EndIf
					lProcMoed := .T.
				EndIf

				//Soma do valor total
				nValorTot	+= (cArqTmp)->C6_VALOR*nTxMoed
			EndIf

			//Verifica se existe bloqueio da referente a data de entrea do PCP
			// If !U_PZCVV104((cArqTmp)->C6_PRODUTO, (cArqTmp)->C6_LOCAL, (cArqTmp)->C6_QTDVEN); 
			// .And. (STOD((cArqTmp)->C6_YDTCPRO)-nDiasAdd) > STOD((cArqTmp)->C6_ENTREG);
			// .And. !(Alltrim(cCfop) $ Alltrim(cCFOPNCicl))  

			// 	lBlqDtPcp := .T.
			// EndIf

			(cArqTmp)->(DbSkip())
		EndDo

		//Verifica bloqueio do faturamento minimo
		// If (nValorTot < nMinFt) .And. lFin
		// 	lBlqVlMin := .T.
		// EndIf  



		//Realiza o bloqueio de regra no pedido de venda
		If lBlqVlMin .Or. lBlqDtPcp
			RecLock("SC5", .F.)
			SC5->C5_BLQ 	:= "9"
			SC5->C5_YTPBLQ 	:= Iif(lBlqVlMin,"A","")+Iif(lBlqDtPcp,"B","") 
			SC5->(MsUnLock())

			lRet := .T.
		EndIf

		If Select(cArqTmp) > 0
			(cArqTmp)->(DbCloseArea())
		EndIf
	Else
		//Tratamento realizado devido o sistema padr�o limpar o campo C5_BLQ na altera��o. 
		If !Empty(SC5->C5_YTPBLQ) .And. Alltrim(SC5->C5_YTPBLQ) != "OK" 
			RecLock("SC5", .F.)
			SC5->C5_BLQ 	:= "9"
			SC5->(MsUnLock())
		EndIf
	EndIf
	RestArea(aArea)
Return lRet
