#include 'protheus.ch'
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVV004		�Autor  �Microsiga	     � Data �  14/02/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o da data de previs�o de faturamento				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVV004(dDtFat)

	Local aArea 	:= GetArea()
	Local lRet		:= .T.
	Local cCodUsr	:= Alltrim(RetCodUsr())
	Local cCodULib	:= U_MyNewSX6("CV_USLBPVD", ""	,"C","Usuarios liberados a utilizar data retroativa no pedido de vendas", "", "", .F. ) 

	If INCLUI
		If (dDtFat < MsDate()) .And. !(Alltrim(cCodUsr) $ Alltrim(cCodULib))
			Aviso("Aten��o","A data de faturamento n�o pode ser menor que a data do sistema ("+DTOC(MsDate())+").",{"Ok"},2)
			lRet := .F.
		EndIf
	EndIf
	RestArea(aArea)	
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZ410PCP		�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o da data de entrega PCP							  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZ410PCP()

	Local aArea	:= GetArea()
	Local lRet	:= .T.
	Local nX	:= 0
	Local nPosItem   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ITEM"})	//Armazem
	Local nPosLoc   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})	//Armazem
	Local nPosPrd   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"}) 	//Codigo do produto
	Local nPosDtEnt		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ENTREG"})	//Data de entrega do PCP
	Local nPosQtd		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})	//Quantidade informada
	Local nPosSPcp		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YDTCPRO"})	//Data calculada para produ��o do pcp
	Local nPosDFat		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YPREVFA"})	//Data de prev. de faturamento
	// Local nPosOper		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_OPER"})		//Tp.Opera��o
	Local nPosTes		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})		//TES	
	// Local nDiasAdd		:= U_MyNewSX6("CV_ADDPROD", 1	,"N","Quantidade de dias a ser adicionado na produ��o", "", "", .F. )
	Local cMsg			:= ""
	Local cMsgAux		:= ""
	Local dDtSugFat		:= CTOD('')
	Local cCodULib		:= U_MyNewSX6("CV_USLBPVD", ""	,"C","Usuarios liberados a utilizar data retroativa no pedido de vendas", "", "", .F. )
	Local cCodUsr		:= Alltrim(RetCodUsr())
	Local cCFOPNCicl	:= U_MyNewSX6("CV_NCFOPCI", "5911|6911|7949"	,"C","CFOP que n�o considera o ciclo", "", "", .F. )
	Local cCfop			:= ""

	If !(Alltrim(cCodUsr) $ Alltrim(cCodULib))//Verifica ususuario esta liberado da valida��o

		//Recalculo da data de entrega PCP
		If INCLUI .Or. ALTERA
			u_PZCVP004(1)
		EndIf

		For nX := 1 To Len(aCols)
			
			cCfop	:= ""
			cCfop	:= Posicione("SF4",1,xFilial("SF4") + aCols[nX][nPosTes] , 'F4_CF' )
			
			//Verifica a maior data suerida para faturamento 
			If dDtSugFat < aCols[nX][nPosDFat]
				dDtSugFat := aCols[nX][nPosDFat]
			EndIf

			If !U_PZCVV104(aCols[nX][nPosPrd], aCols[nX][nPosLoc], aCols[nX][nPosQtd]); 
				.And. (aCols[nX][nPosSPcp]) > (aCols[nX][nPosDtEnt] );
				.And. !aCols[nX][Len(aCols[nX])];
				.And. !(Alltrim(cCfop) $ Alltrim(cCFOPNCicl))
				
				cMsgAux += "-Item: "+aCols[nX][nPosItem]+" Produto: "+aCols[nX][nPosPrd];
				+" Dt.Calc.Pcp: "+DTOC(aCols[nX][nPosSPcp])+";"+CRLF
			EndIf
		Next

		If !Empty(cMsgAux) .And. (INCLUI .Or. ALTERA)
			cMsg := "Imposs�vel entregar os produto(s) abaixo na data informada. A data sugerida para faturamento � "+DTOC(dDtSugFat)+"."+CRLF
			cMsg += "Deseja continuar com a data "+DTOC(M->C5_FECENT)+"? "+CRLF+CRLF

			lRet := (Aviso("Aten��o-Ciclo do Pedido",cMsg+cMsgAux,{"Sim","N�o"},3)==1)
		EndIf
	EndIf
	RestArea(aArea)
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVV104		�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o do estoque na SB2								  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVV104(cCodProd, cArmz, nQtd)

	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .T.

	Default cCodProd	:= "" 
	Default cArmz		:= "" 
	Default nQtd		:= 0

	cQuery	:= " SELECT B2_COD, (B2_QATU - B2_QEMP- B2_RESERVA) AS B2_SLD FROM "+RetSqlName("SB2")+" SB2 "
	cQuery	+= " WHERE SB2.B2_FILIAL=  '"+xFilial("SB2")+"' "
	cQuery	+= " AND SB2.B2_COD = '"+cCodProd+"' "
	cQuery	+= " AND SB2.B2_LOCAL = '"+cArmz+"' "
	cQuery	+= " AND SB2.D_E_L_E_T_ = ' ' "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		If (cArqTmp)->B2_SLD > 0 .And. (cArqTmp)->B2_SLD >= nQtd
			lRet	:= .T.
		Else
			lRet	:= .F.
		EndIf 
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVV204		�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o do estoque na SB2								  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVV204()

	Local aArea			:= GetArea()
	Local lRet			:= .T.
	Local nX			:= 0
	Local nPosPrd   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"}) 	//Codigo do produto
	Local nPosQtd		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})	//Quantidade informada
	// Local nPosItem		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ITEM"})	//Item
	Local nPosTes		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})	//Item
	Local cMsgAux		:= ""
	Local cMsg			:= "Produto(os) em desacordo com o forecast, deseja continuar ?"+CRLF+CRLF
	Local cMsgForCast	:= ""
	Local aItens 		:= {}
	Local nA			:= 0

	For nX := 1 To Len(aCols)
		cMsgForCast := ""
		If !Empty(M->C5_FECENT) ;
				.And. !ExisForCast(aCols[nX][nPosPrd], M->C5_CLIENTE, M->C5_LOJACLI, aCols[nX][nPosQtd], M->C5_FECENT, M->C5_NUM, @cMsgForCast, @aItens); 
				.And. !aCols[nX][Len(aCols[nX])];
				.And. Alltrim(Posicione("SF4",1,xFilial("SF4") + aCols[nX][nPosTes] , 'F4_DUPLIC' )) == "S"
				
			cMsgAux += "-Produto: "+Alltrim(aCols[nX][nPosPrd])+" "+cMsgForCast+";"+CRLF
		EndIf
	Next

	If !Empty(cMsgAux) .And. !IsBlind() //Ajuste para n�o dar erro na Execauto da loja integrada. Gustavo Gonzalez - 05/11/2021
		lRet := Aviso("Aten��o-Forecast",cMsg+cMsgAux,{"Sim","N�o"},3) == 1

		If lRet .and. len(aItens) > 0
			  	cHTML := "<html>
				cHTML += "<head>
				cHTML += "<style>
				cHTML += "* {outline: none;border:none;margin: 0;padding:0;box-sizing: border-box;font-family: Arial;}
				cHTML += "table { width: 100%;max-width: 700px;font-size:10px;}
				cHTML += "table thead {background: #C0D9D9;text-align: center;}
				cHTML += "table td {padding: 5px;border:1px solid #222;}
				cHTML += "p {margin-bottom: 15px;padding:5px;}
				cHTML += "h4 {padding:5px;margin:10px 0;}
				cHTML += "</style>
				cHTML += "</head>
				cHTML += "<body>

				cHTML += "<p>Informamos que o pedido "+M->C5_NUM+" do cliente (C�digo: "+AllTrim(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COD"))+" - Loja: "+AllTrim(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_LOJA"))+")"+" "+AllTrim(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NREDUZ"))+" possui os seguintes desvios de Forecast:</p>
				cHTML += "<h4>Informa��es do pedido:</h4>
				cHTML += "<table>
				cHTML += "	<thead>
				cHTML += "		<tr>
				cHTML += "		<td align='center'>C�digo SKU</td>
				cHTML += "      <td>Descri��o do Produto</td>
				cHTML += "      <td align='center'>Forecast</td>
				cHTML += "      <td align='center'>Realizado</td>
				cHTML += "      <td align='center'>Pedidos</td>
				cHTML += "      <td align='center'>Realizado + Pedidos</td>
				cHTML += "      <td align='center'>Diferen�a</td>
				cHTML += "		</tr>
				cHTML += "	</thead>
				cHTML += "	<tbody>
				For nA := 1 to len(aItens)
					cHTML += "		<tr>
					cHTML += "			<td align='center'>"+aItens[nA][1]+"</td>
					cHTML += "			<td>"+aItens[nA][2]+"</td>
					cHTML += "			<td align='center'>"+cValtoChar(aItens[nA][3])+"</td>
					cHTML += "			<td align='center'>"+cValtoChar(aItens[nA][4])+"</td>
					cHTML += "			<td align='center'>"+cValtoChar(aItens[nA][5])+"</td>
					cHTML += "			<td align='center'>"+cValtoChar(aItens[nA][4] + aItens[nA][5])+"</td>
					cHTML += "			<td align='center' style='"+Iif(aItens[nA][6] < 0,"color: #f00;","")+"'>"+cValtoChar(aItens[nA][6])+"</td>
					cHTML += "		</tr>
				Next nA
				cHTML += "	</tbody>
				cHTML += "</table>
				cHTML += "<br/>"
				cHTML += "<p>Respons�vel: "+Trim(Posicione("SA3",1,xFilial("SA3")+M->C5_VEND1,"A3_NOME"))+"<br/>"
				cHTML += "<p>Data de Emiss�o: "+DtoC(M->C5_EMISSAO)+" | Data Solicitada: "+DtoC(M->C5_FECENT)+"</p>"

				cHTML += "</body>
				cHTML += "</html>


			cTo := SuperGetMV("MV_DESVEML",,"")
			// cTo := "denis.varella@newbridge.srv.br"
    		U_zEnvMail(cTo, "Aviso de Desvio de Forecast: N� Pedido "+M->C5_NUM, cHTML, {}, .f., .t., .t.)
		EndIf

	Else
		lRet := .T.
	EndIf


	RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ExisForCast	�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o da existencia de forcast para o pedido			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ExisForCast(cCodProd, cCodCli, cLoja, nQtd, dDtFat, cNumPv, cMsg, aItens)

	Local aArea 	:= GetArea()
	Local lRet		:= .T.
	Local nResut	:= 0
	Local nCart		:= 0		
	Local nRealiz	:= 0
	Local nForcast	:= 0
	Local cTipoPrd	:= U_MyNewSX6("CV_TPPRDVF", "PA|ME"	,"C","Tipo de produtos a serem validados no forecast", "", "", .F. )

	Default cCodProd	:= "" 
	Default cCodCli		:= "" 
	Default cLoja		:= "" 
	Default nQtd		:= 0 
	Default dDtFat		:= CTOD('')
	Default cNumPv		:= ""
	Default cMsg		:= ""

	DbSelectArea("SB1")
	DbSetOrder(1)

	If SB1->(DbSeek(xFilial("SB1") + cCodProd))
		If Alltrim(SB1->B1_TIPO) $ Alltrim(cTipoPrd) .And. !Empty(dDtFat)
		 
			nRealiz 	:= GetFat(cCodProd, cCodCli, cLoja, dDtFat)
			nCart		:= GetPvRealiz(cCodProd, cCodCli, cLoja, nQtd, dDtFat, cNumPv)
			nForcast 	:= GetForcast(cCodProd, cCodCli, cLoja, dDtFat)

			nResut := nForcast - (nRealiz+nCart)

			If (nRealiz+nCart) > nForcast .And. (INCLUI .Or. ALTERA)
				aAdd(aItens, {Trim(cCodProd),Trim(SB1->B1_DESC),nForcast,nRealiz,nCart,nResut})
				cMsg := "Forecast: "+Alltrim(Str(nForcast))+" | ";
				+"  Realizado: "+Alltrim(Str((nRealiz+nCart)))+" | ";
				+"  Resultado: "+Alltrim(Str(nResut))
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
	RestArea(aArea)
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetPvRealiz	�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna os pedidos em carteira							  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetPvRealiz(cCodProd, cCodCli, cLoja, nQtd, dDtFat, cNumPv)

	Local aArea	:= GetArea()
	Local nRet	:= 0
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodProd	:= "" 
	Default cCodCli		:= "" 
	Default cLoja		:= "" 
	Default nQtd		:= 0 
	Default dDtFat		:= CTOD('')
	Default cNumPv		:= ""

	cQuery	:= " SELECT SUM(C6_QTDVEN) C6_QTDVEN, SUM(C6_VALOR) C6_VALOR " +CRLF
	cQuery	+= " 		 FROM "+RetSqlName("SC5")+" SC5 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SC6")+" SC6 "+CRLF
	cQuery	+= " ON SC6.C6_FILIAL = SC5.C5_FILIAL "+CRLF
	cQuery	+= " AND SC6.C6_NUM = SC5.C5_NUM "+CRLF
	cQuery	+= " AND SC6.C6_PRODUTO = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND SC6.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "+CRLF
	cQuery	+= " AND SC5.C5_NUM != '"+cNumPv+"' "+CRLF
	cQuery	+= " AND SC5.C5_CLIENTE = '"+cCodCli+"' "+CRLF
	cQuery	+= " AND SC5.C5_LOJACLI = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(FirstDay(dDtFat))+"' AND '"+DTOS(LastDay(dDtFat))+"' "+CRLF 
	cQuery	+= " AND SC5.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->C6_QTDVEN + nQtd
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetFat		�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a quantidade de itens faturado para o cliente 	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetFat(cCodProd, cCodCli, cLoja, dDtFat)

	Local aArea	:= GetArea()
	Local nRet	:= 0
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodProd	:= "" 
	Default cCodCli		:= "" 
	Default cLoja		:= "" 
	Default dDtFat		:= CTOD('')


	cQuery	+= " SELECT SUM(D2_QUANT) D2_QUANT FROM "+RetSqlName("SD2")+" SD2 "+CRLF
	cQuery	+= " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' "+CRLF
	cQuery	+= " AND SD2.D2_CLIENTE = '"+cCodCli+"' "+CRLF
	cQuery	+= " AND SD2.D2_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SD2.D2_COD = '"+cCodProd+"' " +CRLF
	cQuery	+= " AND SD2.D2_EMISSAO BETWEEN '"+DTOS(FirstDay(dDtFat))+"' AND '"+DTOS(LastDay(dDtFat))+"' "+CRLF
	cQuery	+= " AND SD2.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->D2_QUANT
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetPvRealiz	�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o forcast do produto x cliente					  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetForcast(cCodProd, cCodCli, cLoja, dDtFat)

	Local aArea	:= GetArea()
	Local nRet	:= 0
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodProd	:= "" 
	Default cCodCli		:= "" 
	Default cLoja		:= "" 
	Default dDtFat		:= CTOD('')


	cQuery	+= " SELECT "
	cQuery	+= " 		SUM(Z2_QTM01) Z2_QTM01, SUM(Z2_QTM02) Z2_QTM02, SUM(Z2_QTM03) Z2_QTM03, SUM(Z2_QTM04) Z2_QTM04, "+CRLF 
	cQuery	+= " 		SUM(Z2_QTM05) Z2_QTM05, SUM(Z2_QTM06) Z2_QTM06, SUM(Z2_QTM07) Z2_QTM07, SUM(Z2_QTM08) Z2_QTM08, "+CRLF
	cQuery	+= " 		SUM(Z2_QTM09) Z2_QTM09, SUM(Z2_QTM10) Z2_QTM10, SUM(Z2_QTM11) Z2_QTM11, SUM(Z2_QTM12) Z2_QTM12 "+CRLF
	cQuery	+= " FROM "+RetSqlName("SZ2")+" SZ2 "+CRLF
	cQuery	+= " WHERE SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"' "+CRLF
	cQuery	+= " AND SZ2.Z2_CLIENTE = '"+cCodCli+"' "+CRLF
	cQuery	+= " AND SZ2.Z2_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SZ2.Z2_PRODUTO = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND SZ2.Z2_ANO = SubString('"+DTOS(dDtFat)+"',1,4) "+CRLF
	cQuery	+= " AND SZ2.Z2_TOPICO = 'F' "+CRLF
	cQuery	+= " AND SZ2.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->&("Z2_QTM"+SubStr(DTOS(dDtFat),5,2))
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet
