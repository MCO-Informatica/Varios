#include 'protheus.ch'

#DEFINE DATAPCP 	1
#DEFINE DATASUGFAT	2
#DEFINE DTPRODUC	3
#DEFINE EXISTESTOQ	4
#DEFINE LAUDOEXT	5
#DEFINE DIASPRODUC	6
#DEFINE DIASLAUDO	7
#DEFINE DATAINIPRO	8

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PZCVP004 �Autor  �Microsiga 	          � Data � 28/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho na valida��o para calcular a data do PCP 			  ���
���          �no pedido de venda							    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCVP004(nOpc)

	Local aArea 	:= GetArea()
	Local lRet		:= .T.		

	Default nOpc		:= 1 

	//Realiza o calculo da entrega PCP, ap�s altera��o da data de faturamento
	If nOpc == 1

		//Realiza o calculo dos itens na atualiza��o da data de faturamento
		lRet := CalcDtPcp()

	ElseIf nOpc == 2//Realiza o calculo do item posicionado

		//Realiza o calculo do item ao incluir ou alterar produto
		lRet := CalcDtPcIt()
	EndIf


	RestArea(aArea)	
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcDtPcp �Autor  �Microsiga 	          � Data � 28/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho na valida��o para calcular a data do PCP 			  ���
���          �no pedido de venda. (Atualiza todos os itens)	    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalcDtPcp()

	Local aArea			:= GetArea()
	Local nX			:= 0
	Local nPosLoc   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})	//Armazem
	Local nPosPrd   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"}) 	//Codigo do produto
	Local nPosDtEnt		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ENTREG"})	//Data de entrega do PCP
	Local nPosDProd		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTPROD"})	//Data de produ��o
	Local nPosDFat		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YPREVFA"})	//Data sugerida para faturamento	
	Local nPosLaExt		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LAUEXT"})	//Laudo Externo
	Local nPosLog		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LGCICLO"})	//Log
	Local nPosQtd		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})	//Quantidade informada
	Local nPosSPcp		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YDTCPRO"})	//Data calculada para produ��o do pcp
	Local nPosPrevFat	:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_SUGENTR"})	//Previs�o de faturamento
	Local nPosIniPrd	:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YDTINIP"})	//Data de inicio da produ��o	
	Local aCalcPcp		:= {}
	Local nDiasAdd		:= U_MyNewSX6("CV_ADDPROD", 1	,"N","Quantidade de dias a ser adicionado na produ��o", "", "", .F. )
	Local dMaiorDt		:= CTOD('')
	Local lRet			:= .T.

	For nX := 1 To Len(aCols)

		If !Empty(aCols[nX][nPosPrd])
			aCalcPcp := {}

			//Calculo da data e dados complementares referente a entrega pcp 
			aCalcPcp := GetDtPcp(M->C5_CLIENTE, M->C5_LOJACLI, aCols[nX][nPosPrd], M->C5_FECENT, aCols[nX][nPosLoc], aCols[nX][nPosQtd])

			//Data da previs�o de faturamento
			aCols[nX][nPosPrevFat] := M->C5_FECENT

			If Len(aCalcPcp) >= 7

				//Informa se existe laudo externo
				If aCalcPcp[LAUDOEXT]
					aCols[nX][nPosLaExt] := "1"//Sim
				Else
					aCols[nX][nPosLaExt] := "2"//N�o
				EndIf

				//Preenche os dados de entrega do PCP quando existe estoque
				If aCalcPcp[EXISTESTOQ]
					aCols[nX][nPosDtEnt]	:= GetSbDiaUt(M->C5_FECENT, nDiasAdd ) 
					aCols[nX][nPosDProd] 	:= GetSbDiaUt(M->C5_FECENT, nDiasAdd )    					       
					aCols[nX][nPosDFat]		:= DataValida(MsDate())
					aCols[nX][nPosSPcp]		:= aCalcPcp[DATAPCP]	//Data calculada para entrega do PCP
					aCols[nX][nPosLog]		:= CVALTOCHAR("EST-OK"+dtoc(ddatabase)+"-"+time())
					aCols[nX][nPosIniPrd] 	:= GetSbDiaUt(M->C5_FECENT, nDiasAdd )//M->C5_FECENT
				Else//Preenche os dados de entrega do PCP quando n�o existir estoque

					aCols[nX][nPosDtEnt]	:= GetSbDiaUt(M->C5_FECENT, nDiasAdd )//Data de Entrega PCP
					aCols[nX][nPosDProd] 	:= aCalcPcp[DTPRODUC] 	//Data de produ��o      
					aCols[nX][nPosDFat]		:= aCalcPcp[DATASUGFAT]  //Data sugerida para faturamento
					aCols[nX][nPosSPcp]		:= aCalcPcp[DATAPCP]	//Data calculada para entrega do PCP
					aCols[nX][nPosIniPrd] 	:= GetIniProd(M->C5_CLIENTE, M->C5_LOJACLI, aCols[nX][nPosPrd], aCols[nX][nPosDtEnt])	//Data de inicio da produ��o
					
					If aCols[nX][nPosIniPrd] > aCols[nX][nPosDtEnt]
						aCols[nX][nPosIniPrd] := aCols[nX][nPosDtEnt]
					EndIf 
					
					aCols[nX][nPosLog]		:= "Data para produ��o � maior que a data de faturamento."

				EndIf


			EndIf
		EndIf
	Next	 

	If Type("oGetDad") == "O"
		oGetDad:oBrowse:Refresh()
	EndIf

	RestArea(aArea)
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcDtPcIt �Autor  �Microsiga 	      � Data � 28/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho na valida��o para calcular a data do PCP 			  ���
���          �no pedido de venda. (Atualiza todos os itens)	    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalcDtPcIt()

	Local aArea			:= GetArea()
	Local nPosLoc   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})	//Armazem
	Local nPosPrd   	:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"}) 	//Codigo do produto
	Local nPosDtEnt		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ENTREG"})	//Data de entrega do PCP
	Local nPosDProd		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTPROD"})	//Data de produ��o
	Local nPosDFat		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YPREVFA"})	//Data de prev. de faturamento	
	Local nPosLaExt		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LAUEXT"})	//Laudo Externo
	Local nPosLog		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LGCICLO"})	//Log
	Local nPosQtd		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})	//Quantidade informada
	Local nPosSPcp		:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YDTCPRO"})	//Data calculada para produ��o do pcp
	Local nPosIniPrd	:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_YDTINIP"})	//Data de inicio da produ��o
	Local nPosPrevFat	:= Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_SUGENTR"})	//Previs�o de faturamento	
	Local aCalcPcp		:= {}
	Local nDiasAdd		:= U_MyNewSX6("CV_ADDPROD", 1	,"N","Quantidade de dias a ser adicionado na produ��o", "", "", .F. ) 
	Local dMaiorDt		:= CTOD('')
	Local lRet			:= .T.

	aCalcPcp := {}

	//Calculo da data e dados complementares referente a entrega pcp 
	aCalcPcp := GetDtPcp(M->C5_CLIENTE, M->C5_LOJACLI, aCols[n][nPosPrd], M->C5_FECENT, aCols[n][nPosLoc], aCols[n][nPosQtd])
	
	//Data da previs�o de faturamento
	aCols[n][nPosPrevFat] := M->C5_FECENT
	
	
	If Len(aCalcPcp) >= 7

		//Informa se existe laudo externo
		If aCalcPcp[LAUDOEXT]
			aCols[n][nPosLaExt] := "1"//Sim
		Else
			aCols[n][nPosLaExt] := "2"//N�o
		EndIf

		//Preenche os dados de entrega do PCP quando existe estoque
		If aCalcPcp[EXISTESTOQ]
			aCols[n][nPosDtEnt]		:= GetSbDiaUt(M->C5_FECENT, nDiasAdd ) 
			aCols[n][nPosDProd] 	:= GetSbDiaUt(M->C5_FECENT, nDiasAdd )    					       
			aCols[n][nPosDFat]		:= DataValida(MsDate())
			aCols[n][nPosSPcp]		:= aCalcPcp[DATAPCP]	//Data calculada para entrega do PCP
			aCols[n][nPosLog]		:= CVALTOCHAR("EST-OK"+dtoc(ddatabase)+"-"+time())
			aCols[n][nPosIniPrd]	:= GetSbDiaUt(M->C5_FECENT, nDiasAdd )//M->C5_FECENT			

		Else//Preenche os dados de entrega do PCP quando n�o existir estoque

			aCols[n][nPosDtEnt]		:= GetSbDiaUt(M->C5_FECENT, nDiasAdd )//Data de Entrega PCP
			aCols[n][nPosDProd] 	:= aCalcPcp[DTPRODUC] //Data de produ��o      
			aCols[n][nPosDFat]		:= aCalcPcp[DATASUGFAT]  //Data sugerida para faturamento
			aCols[n][nPosSPcp]		:= aCalcPcp[DATAPCP]	//Data calculada para entrega do PCP
			aCols[n][nPosIniPrd]	:= GetIniProd(M->C5_CLIENTE, M->C5_LOJACLI, aCols[n][nPosPrd], aCols[n][nPosDtEnt])	//Data de inicio da produ��o
			
			If aCols[n][nPosIniPrd] > aCols[n][nPosDtEnt]
				aCols[n][nPosIniPrd] := aCols[n][nPosDtEnt]
			EndIf 
			
			aCols[n][nPosLog]		:= "Data para produ��o � maior que a data de faturamento."


		EndIf


	EndIf

	If Type("oGetDad") == "O"
		oGetDad:oBrowse:Refresh()
	EndIf

	RestArea(aArea)
Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetDtPcp �Autor  �Microsiga 	          � Data � 28/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a data do Pcp para o produto e cliente informado	  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetDtPcp(cCodCli, cLoja, cCodProd, dDtFat, cArmz, nQtd)

	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local dDtPcp	:= CTOD('')
	Local dDtSuFat	:= CTOD('')
	Local dDtIniPro	:= CTOD('')
	Local dDtProduc	:= CTOD('')
	Local aRet		:= {CTOD(''),CTOD(''),CTOD(''),.F.,.F.,0,0}
	Local nDiasAdd	:= U_MyNewSX6("CV_ADDPROD", 1	,"N","Quantidade de dias a ser adicionado na produ��o", "", "", .F. )
	Local lExisEst	:= .F.
	Local lLaudoExt	:= .F.

	Default cCodCli		:= "" 
	Default cLoja		:= "" 
	Default cCodProd	:= ""
	Default dDtFat		:= CTOD('')
	Default cArmz		:= ""
	Default nQtd		:= 0

	cQuery	:= " SELECT B1_PE, A7_ANTEMPO, (B2_QATU - B2_QEMP- B2_RESERVA) AS B2_SLD FROM "+RetSqlName("SB1")+" SB1 "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = '"+xFilial("SA7")+"' "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = '"+cCodCli+"' "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SB2")+" SB2 "+CRLF
	cQuery	+= " ON SB2.B2_FILIAL = '"+xFilial("SB2")+"' "+CRLF
	cQuery	+= " AND SB2.B2_COD = B1_COD "+CRLF
	cQuery	+= " AND SB2.B2_LOCAL = '"+cArmz+"' "+CRLF
	cQuery	+= " AND SB2.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = '"+cCodProd+"' " +CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())

		dDtPcp 		:= GetAdDiaUt(MsDate(), (cArqTmp)->(B1_PE+A7_ANTEMPO))//Calculo da data do PCP
		dDtSuFat	:= GetAdDiaUt(dDtPcp,nDiasAdd )
		dDtIniPro	:= GetSbDiaUt(dDtPcp, (cArqTmp)->(B1_PE+A7_ANTEMPO)) 
		lExisEst	:= ((cArqTmp)->B2_SLD >= nQtd)
		lLaudoExt	:= ((cArqTmp)->A7_ANTEMPO > 0)
		dDtProduc	:= GetAdDiaUt(MsDate(), (cArqTmp)->B1_PE )//Calculo da data do PCP

		aRet := {;
		dDtPcp,;
		dDtSuFat,;
		dDtProduc,;
		lExisEst,;
		lLaudoExt,;
		(cArqTmp)->B1_PE,;
		(cArqTmp)->A7_ANTEMPO,;
		dDtIniPro;
		}
	Else
		Aviso("Aten��o","N�o foi possivel calcular a data do PCP. Verifique o cadastro do produto.",{"Ok"},2)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetSbDiaUt �Autor  �Microsiga	          � Data � 03/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Subtra��o de dias de determinada data						  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetSbDiaUt(dData, nDias)

	Local aArea := GetArea()
	Local nX	:= 0

	Default dData	:= CTOD('') 
	Default nDias	:= 0

	For nX:=1 to nDias   
		dData := dData - 1  
		If DataValida(dData,.t.) != dData 
			nX--
		EndIf
	Next

	RestArea(aArea)
Return dData


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetAdDiaUt �Autor  �Microsiga	          � Data � 03/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adi��o de dias de determinada data						  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function GetAdDiaUt(dData,nDias)
	Local aArea := GetArea()
	Local nX	:= 0

	Default dData	:= CTOD('')
	Default nDias	:= 0

	For nX:=1 to nDias
		dData := dData + 1

		If DataValida(dData,.t.) != dData 
			nX--
		EndIf
	Next

	RestArea(aArea)
Return dData


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetIniProd �Autor  �Microsiga	          � Data � 03/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicio da produ��o										  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetIniProd(cCodCli, cLoja, cCodProd, dDtPcp)

	Local aArea		:= GetArea()
	Local cArqTmp	:= GetNextAlias()
	Local cQuery	:= ""
	Local dDtRet	:= CTOD('')

	Default cCodCli		:= "" 
	Default cLoja		:= "" 
	Default cCodProd	:= ""
	Default dDtPcp		:= CTOD('')

	cQuery	:= " SELECT B1_PE, A7_ANTEMPO FROM "+RetSqlName("SB1")+" SB1 "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = '"+xFilial("SA7")+"' "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = '"+cCodCli+"' "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = '"+cCodProd+"' " +CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
	
	If (cArqTmp)->(!Eof())
		dDtRet := GetSbDiaUt(dDtPcp, (cArqTmp)->(B1_PE+A7_ANTEMPO))
	Else
		dDtRet := CTOD('')
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return dDtRet