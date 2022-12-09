#include 'protheus.ch'

Static cArqAnalit	:= GetNextAlias()//Tabela temporaria analitica
Static cArqSint		:= GetNextAlias()//Tabela temporaria sintetica

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVP007		�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina auxiliar responsavel por retornar os dados do 	      ���
���          �forecast do relatorio de MRP	                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVP017(nOpc, cCod, cTipo)

	Local aArea	:= GetArea()
	Local aRet	:= {0,0}

	Default nOpc 	:= 0
	Default cCod	:= "" 
	Default cTipo	:= ""

	If nOpc == 0//Inicia a tabela temporaria

		//Cria as tabelas temporarias  
		CriaTabsTmp()

		//Preenche os dados da tabela analitica
		AtuTbAnali()

		//Preenche os dados da tabela sintetica
		AtuTbSint()

	ElseIf nOpc == 1
		//Retorna a quantidade do forecast do produto pesquisado
		aRet := GetQtdFc(cCod, cTipo)

	ElseIf nOpc == 2

		//Fecha as tabelas temporarias
		CloseTabs()

	EndIf

	RestArea(aArea)	
Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CloseTabs		�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fecha as tabelas temporarias								  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CloseTabs()

	If Select(cArqAnalit)>0
		(cArqAnalit)->(DbCloseArea())
	EndIf

	If Select(cArqSint) >0 
		(cArqSint)->(DbCloseArea())
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CriaTabsTmp	�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria as tabelas temporarias sintetica e analitica			  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaTabsTmp()

	Local aArea 	:= GetArea()

	//Cria a tabela temporaria analitica
	CriaTabAnli()

	//Cria a tabela temporaria sintetica
	CriaTabSint()

	RestArea(aArea)
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CriaTabAnli	�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Tabela temporaria analitica								  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaTabAnli()

	Local aArea 	:= GetArea()
	Local aCmp		:= {}
	Local cArq		:= ""

	aAdd (aCmp, {"ANL_COD"		,"C", TAMSX3("B1_COD")[1]		,	0})//Produto componente  
	aAdd (aCmp, {"ANL_DESC"		,"C", TAMSX3("B1_DESC")[1]		,	0})   
	aAdd (aCmp, {"ANL_TIPO"		,"C", TAMSX3("B1_TIPO")[1]		,	0})    
	aAdd (aCmp, {"ANL_YCLIEN"	,"C", TAMSX3("A1_COD")[1]		,	0})    
	aAdd (aCmp, {"ANL_YLOJA"	,"C", TAMSX3("A1_LOJA")[1]		,	0})  
	aAdd (aCmp, {"ANL_PRDORI"	,"C", TAMSX3("B1_COD")[1]		,	0})//Produto origem	(Informativo)
	aAdd (aCmp, {"ANL_PRDC4"	,"C", TAMSX3("B1_COD")[1]		,	0})//Produto da previs�o de venda (Informativo)
	aAdd (aCmp, {"ANL_C4QTD"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})//Quantidade da previs�o de venda
	aAdd (aCmp, {"ANL_QTDORI"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})//Quantidade do produto origem
	aAdd (aCmp, {"ANL_QTDFOR"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})//Quantidade do forecast (Componente)
	aAdd (aCmp, {"ANL_UM_MES"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})//Quantidade do forecast 1 M�s

	cArq	:=	CriaTrab(aCmp)
	DbUseArea (.T., __LocalDriver, cArq, cArqAnalit)

	IndRegua (cArqAnalit, cArq, "ANL_COD+ANL_TIPO")

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CriaTabSint	�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Tabela temporaria sintetica								  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaTabSint()

	Local aArea 	:= GetArea()
	Local aCmp		:= {}
	Local cArq		:= ""

	aAdd (aCmp, {"SIN_COD"		,"C", TAMSX3("B1_COD")[1]		,	0})//Produto componente  
	aAdd (aCmp, {"SIN_DESC"		,"C", TAMSX3("B1_DESC")[1]		,	0})   
	aAdd (aCmp, {"SIN_TIPO"		,"C", TAMSX3("B1_TIPO")[1]		,	0})    
	aAdd (aCmp, {"SIN_QTDFOR"	,"N", TAMSX3("C4_QUANT")[1]+2		,	TAMSX3("C4_QUANT")[2]})//Quantidade do forecast (Componente)
	aAdd (aCmp, {"SIN_UM_MES"	,"N", TAMSX3("C4_QUANT")[1]+2		,	TAMSX3("C4_QUANT")[2]})//Quantidade do forecast 1 m�s

	cArq	:=	CriaTrab(aCmp)
	DbUseArea (.T., __LocalDriver, cArq, cArqSint)

	IndRegua (cArqSint, cArq, "SIN_COD+SIN_TIPO")

	RestArea(aArea)
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AtuTbAnali	�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza os dados da tabela analitica						  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuTbAnali()

	Local aArea		:= GetArea()
	Local cArqTmp	:= GetNextAlias()
	Local cQuery	:= ""
	Local cMeses 	:= ""
	Local cMes		:= ""
	Local lNextYear	:= .F.
	Local nQ 		:= 0
	Local dData 	:= MsDate()
	Local nQtdMeses	:= 3

	For nQ := 1 to nQtdMeses
		If nQ > 1
			cMeses += "+"
		EndIf
		cMeses += "CASE WHEN Z2_ANO = '"+Year2Str(MonthSum(dData,nQ-1))+"' THEN Z2_QTM"+PadL(Month(MonthSum(dData,nQ-1)),2,"0")+" ELSE 0 END "
		If nQ == 1
			cMes := cMeses
		EndIf
		If nQ > 1 .and. Month(MonthSum(dData,nQ-1)) == 1
			lNextYear := .T.
		EndIf
	Next nQ

	//Grava os dados do produto principal da previs�o de vendas
	cQuery	+= " SELECT * FROM ( "+CRLF
	cQuery	+= " SELECT	B1_COD, "+CRLF 
	cQuery	+= " 		B1_TIPO, "+CRLF 
	cQuery	+= " 		B1_DESC, "+CRLF 
	cQuery	+= " 		B1_IMPORT, "+CRLF 
	cQuery	+= " 		B1_QB, "+CRLF
	cQuery	+= " 		A1_COD C4_YCLIENT, "+CRLF 
	cQuery	+= " 		A1_LOJA C4_YLOJA, "+CRLF
	cQuery	+= " 		SUM("+cMeses+") C4_QUANT, "+CRLF
	cQuery	+= " 		SUM("+cMes+") UM_MES "+CRLF
	cQuery	+= " 		FROM "+RetSqlName("SZ2")+" SZ2 "+CRLF 

	cQuery	+= " 	INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF 
	cQuery	+= " 	ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " 	AND SB1.B1_COD=SZ2.Z2_PRODUTO "+CRLF 
	cQuery	+= " 	AND SB1.D_E_L_E_T_='' "+CRLF 

	cQuery	+= " 	INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " 	ON SA1.A1_FILIAL='"+xFilial("SA1")+"' " +CRLF
	cQuery	+= " 	AND SA1.A1_COD = SZ2.Z2_CLIENTE "+CRLF
	cQuery	+= " 	AND SA1.A1_LOJA = SZ2.Z2_LOJA "+CRLF
	cQuery	+= " 	AND SA1.A1_MSBLQL<>'1' "+CRLF
	cQuery	+= " 	AND SA1.D_E_L_E_T_='' " 	+CRLF

	cQuery	+= " WHERE SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "+CRLF 
	cQuery	+= " AND SZ2.Z2_TOPICO='F' " +CRLF
	If lNextYear
		cQuery	+= " AND SZ2.Z2_ANO BETWEEN '"+Alltrim(Str(Year(MsDate())))+"' AND '"+Alltrim(Str(Year(MsDate())+1))+"' "+CRLF
	Else
		cQuery	+= " AND SZ2.Z2_ANO BETWEEN '"+Alltrim(Str(Year(MsDate())))+"' AND '"+Alltrim(Str(Year(MsDate())))+"' "+CRLF
	EndIf
	cQuery	+= " AND SZ2.D_E_L_E_T_=' ' "+CRLF
	cQuery	+= " GROUP BY B1_COD, B1_TIPO, B1_DESC, B1_IMPORT, B1_QB, A1_COD, A1_LOJA "+CRLF
	cQuery	+= " ) DADOS "+CRLF
	cQuery	+= " WHERE C4_QUANT != 0"+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea(cArqAnalit)
	DbSetOrder(1)
	While (cArqTmp)->(!Eof())

		//Grava os dados do produto utilizado na previs�o de venda
		RecLock(cArqAnalit, .T.)
		(cArqAnalit)->ANL_COD		:= (cArqTmp)->B1_COD
		(cArqAnalit)->ANL_DESC		:= (cArqTmp)->B1_DESC
		(cArqAnalit)->ANL_TIPO		:= (cArqTmp)->B1_TIPO
		(cArqAnalit)->ANL_YCLIEN	:= (cArqTmp)->C4_YCLIENT
		(cArqAnalit)->ANL_YLOJA		:= (cArqTmp)->C4_YLOJA
		(cArqAnalit)->ANL_PRDORI	:= ""
		(cArqAnalit)->ANL_PRDC4		:= ""
		(cArqAnalit)->ANL_C4QTD		:= (cArqTmp)->C4_QUANT
		(cArqAnalit)->ANL_QTDORI	:= (cArqTmp)->C4_QUANT
		(cArqAnalit)->ANL_QTDFOR	:= (cArqTmp)->C4_QUANT	
		(cArqAnalit)->ANL_UM_MES	:= (cArqTmp)->UM_MES
		(cArqAnalit)->(MsUnLock())

		//Grava os dados dos componentes necessarios
		GrvComp((cArqTmp)->B1_COD, (cArqTmp)->C4_QUANT,(cArqTmp)->UM_MES, (cArqTmp)->C4_YCLIENT, (cArqTmp)->C4_YLOJA, (cArqTmp)->B1_QB)

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GrvComp		�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados do componente na tabela analitica			  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvComp(cCodPv, nQtdPv, nQtdPv1, cCodCli, cLoja, nBase)

	Local aArea		:= GetArea()
	Local cArqTmp	:= GetNextAlias()
	Local cQuery	:= ""

	Default cCodPv 	:= ""
	Default nQtdPv	:= 0
	Default nBase	:= 0

	cQuery	:= " SELECT B1_COD, B1_DESC, B1_IMPORT, B1_TIPO, B1_DESCINT, B1_QB, B1_QE, G1_COD,"
	cQuery	+= " ("+cValtoChar(nQtdPv)+" * (G1_QUANT / "+cValtoChar(nBase)+") ) QTDCOMP, "
	cQuery	+= " ("+cValtoChar(nQtdPv1)+" * (G1_QUANT / "+cValtoChar(nBase)+") ) QTDCOMP1, "
	cQuery	+= " G1_COMP, G1_QUANT FROM "+RetSqlName("SG1")+" G1 "+CRLF  

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 " +CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = G1.G1_COMP "+CRLF
	cQuery	+= " AND SB1.B1_TIPO <> 'MO' "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE G1.G1_FILIAL = '"+xFilial("SG1")+"' "+CRLF
	cQuery	+= " AND G1.G1_COD = '"+cCodPv+"' " +CRLF
	cQuery	+= " AND G1.D_E_L_E_T_ = ' ' "  +CRLF
	cQuery	+= " ORDER BY B1_COD "+CRLF

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf
	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())
		If Alltrim((cArqTmp)->B1_TIPO) == 'PA'
			(cArqTmp)->(DbSkip())
			Loop
		EndIf

		if trim((cArqTmp)->B1_COD) == '004411'
			cA := ""
		EndIf


		If Alltrim((cArqTmp)->B1_TIPO) == 'PI' 

			RecLock(cArqAnalit, .T.)
			(cArqAnalit)->ANL_COD		:= (cArqTmp)->B1_COD
			(cArqAnalit)->ANL_DESC		:= (cArqTmp)->B1_DESC
			(cArqAnalit)->ANL_TIPO		:= (cArqTmp)->B1_TIPO
			(cArqAnalit)->ANL_YCLIEN	:= cCodCli
			(cArqAnalit)->ANL_YLOJA		:= cLoja
			(cArqAnalit)->ANL_PRDORI	:= cCodPv
			(cArqAnalit)->ANL_PRDC4		:= cCodPv
			(cArqAnalit)->ANL_C4QTD		:= nQtdPv
			(cArqAnalit)->ANL_QTDORI	:= nQtdPv
			(cArqAnalit)->ANL_QTDFOR	:= (cArqTmp)->QTDCOMP		
			(cArqAnalit)->ANL_UM_MES	:= (cArqTmp)->QTDCOMP1
			(cArqAnalit)->(MsUnLock())	

			//Calculo do PI e seus componentes
			CalcPI((cArqTmp)->G1_COMP, (cArqTmp)->QTDCOMP, (cArqTmp)->QTDCOMP1, cCodPv, cCodCli, cLoja, nQtdPv, (cArqTmp)->B1_QB)

		Else
		 							
			RecLock(cArqAnalit, .T.)
			(cArqAnalit)->ANL_COD		:= (cArqTmp)->B1_COD
			(cArqAnalit)->ANL_DESC		:= (cArqTmp)->B1_DESC
			(cArqAnalit)->ANL_TIPO		:= (cArqTmp)->B1_TIPO
			(cArqAnalit)->ANL_YCLIEN	:= cCodCli
			(cArqAnalit)->ANL_YLOJA		:= cLoja
			(cArqAnalit)->ANL_PRDORI	:= cCodPv
			(cArqAnalit)->ANL_PRDC4		:= cCodPv
			(cArqAnalit)->ANL_C4QTD		:= nQtdPv
			(cArqAnalit)->ANL_QTDORI	:= nQtdPv
			(cArqAnalit)->ANL_QTDFOR	:= (cArqTmp)->QTDCOMP		
			(cArqAnalit)->ANL_UM_MES	:= (cArqTmp)->QTDCOMP1
			(cArqAnalit)->(MsUnLock())		
		EndIf

		(cArqTmp)->(DbSkip())
	EndDo


	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf


	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CalcPI		�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do produto do tipo PI e componentes				  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalcPI(cCodPI, nQtdPI, nQtdPI1, cCodPv, cCodCli, cLoja, nQtdPv, nBase)
	Local cQuery 	:= "" 
	Local cArqTmp 	:= GetNextAlias() 

	cQuery	:= " SELECT B1_COD, B1_DESC, B1_TIPO, B1_DESCINT, B1_QB, B1_QE, G1_COD,"
	cQuery	+= " (" + cValtoChar(nQtdPI) + " * (G1_QUANT / "+cValtoChar(nBase)+") ) QTDCOMP, "
	cQuery	+= " (" + cValtoChar(nQtdPI1) + " * (G1_QUANT / "+cValtoChar(nBase)+") ) QTDCOMP1, "
	cQuery	+= " G1_COMP, G1_QUANT FROM "+RetSqlName("SG1")+" G1 "+CRLF  

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 " +CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = G1.G1_COMP "+CRLF
	cQuery  += " AND SB1.B1_TIPO <> 'MO' "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE G1.G1_FILIAL = '"+xFilial("SG1")+"' "+CRLF
	cQuery	+= " AND G1.G1_COD = '"+cCodPI+"' " +CRLF
	cQuery	+= " AND G1.D_E_L_E_T_ = ' ' "  +CRLF
	cQuery	+= " ORDER BY B1_COD "+CRLF

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf
	
	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)


	While (cArqTmp)->(!Eof())

		If Alltrim((cArqTmp)->B1_TIPO) == 'PA'
			(cArqTmp)->(DbSkip())
			Loop
		EndIf

		if trim((cArqTmp)->B1_COD) == '004411'
			cA := ""
		EndIf

		If 	Alltrim((cArqTmp)->B1_TIPO) == 'PI' 

			RecLock(cArqAnalit, .T.)
			(cArqAnalit)->ANL_COD		:= (cArqTmp)->B1_COD
			(cArqAnalit)->ANL_DESC		:= (cArqTmp)->B1_DESC
			(cArqAnalit)->ANL_TIPO		:= (cArqTmp)->B1_TIPO
			(cArqAnalit)->ANL_YCLIEN	:= cCodCli
			(cArqAnalit)->ANL_YLOJA		:= cLoja
			(cArqAnalit)->ANL_PRDORI	:= cCodPI
			(cArqAnalit)->ANL_PRDC4		:= cCodPv
			(cArqAnalit)->ANL_C4QTD		:= nQtdPv
			(cArqAnalit)->ANL_QTDORI	:= nQtdPI
			(cArqAnalit)->ANL_QTDFOR	:= (cArqTmp)->QTDCOMP		
			(cArqAnalit)->ANL_UM_MES	:= (cArqTmp)->QTDCOMP1
			(cArqAnalit)->(MsUnLock())	

			//Chamada recursiva - Calculo do PI e seus componentes
			CalcPI((cArqTmp)->G1_COMP, (cArqTmp)->QTDCOMP, (cArqTmp)->QTDCOMP1, cCodPv, cCodCli, cLoja, nQtdPv, (cArqTmp)->B1_QB)

		Else 							
			RecLock(cArqAnalit, .T.)
			(cArqAnalit)->ANL_COD		:= (cArqTmp)->B1_COD
			(cArqAnalit)->ANL_DESC		:= (cArqTmp)->B1_DESC
			(cArqAnalit)->ANL_TIPO		:= (cArqTmp)->B1_TIPO
			(cArqAnalit)->ANL_YCLIEN	:= cCodCli
			(cArqAnalit)->ANL_YLOJA		:= cLoja
			(cArqAnalit)->ANL_PRDORI	:= cCodPI
			(cArqAnalit)->ANL_PRDC4		:= cCodPv
			(cArqAnalit)->ANL_C4QTD		:= nQtdPv
			(cArqAnalit)->ANL_QTDORI	:= nQtdPI
			(cArqAnalit)->ANL_QTDFOR	:= (cArqTmp)->QTDCOMP		
			(cArqAnalit)->ANL_UM_MES	:= (cArqTmp)->QTDCOMP1
			(cArqAnalit)->(MsUnLock())	
		EndIf

		(cArqTmp)->(DbSkip())
	EndDo


	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AtuTbSint		�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza os dados da tabela sintetica						  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuTbSint()

	Local aArea	:= GetArea()

	DbSelectArea(cArqAnalit)
	DbSetOrder(1)
	(cArqAnalit)->(DbGoTop())

	DbSelectArea(cArqSint)
	DbSetOrder(1)

	While (cArqAnalit)->(!Eof())

		If (cArqSint)->(DbSeek((cArqAnalit)->(ANL_COD+ANL_TIPO) ))
			RecLock(cArqSint,.F.)

			(cArqSint)->SIN_QTDFOR	+= (cArqAnalit)->ANL_QTDFOR		
			(cArqSint)->SIN_UM_MES 	+= (cArqAnalit)->ANL_UM_MES		

			(cArqSint)->(MsUnLock())
		Else
			RecLock(cArqSint,.T.)

			(cArqSint)->SIN_COD		:= (cArqAnalit)->ANL_COD
			(cArqSint)->SIN_DESC	:= (cArqAnalit)->ANL_DESC
			(cArqSint)->SIN_TIPO	:= (cArqAnalit)->ANL_TIPO
			(cArqSint)->SIN_QTDFOR	:= (cArqAnalit)->ANL_QTDFOR		
			(cArqSint)->SIN_UM_MES 	:= (cArqAnalit)->ANL_UM_MES		

			(cArqSint)->(MsUnLock())
		EndIf
		(cArqAnalit)->(DbSkip())
	EndDo

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetQtdFc		�Autor  �Microsiga	     � Data �  03/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a quantidade do forecas do produto				  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetQtdFc(cCod, cTipo)

	Local aArea	:= GetArea()
	Local aRet	:= {0,0}

	Default cCod	:= "" 
	Default cTipo	:= ""

	DbSelectArea(cArqSint)
	DbSetOrder(1)
	If !Empty(cCod) .And. (cArqSint)->(DbSeek(cCod+cTipo))
		aRet[1] := ROUND((cArqSint)->SIN_QTDFOR,0)
		aRet[2] := ROUND((cArqSint)->SIN_UM_MES,0)
	EndIf

	RestArea(aArea)
Return aRet
