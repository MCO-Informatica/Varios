#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR010		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmissใo de etiqueta ap๓s a entrada da NF					  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ 
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
User function PZCVR010(cDoc, cSerie, cFornece, cLoja)

	Local aArea		:= GetArea()
	Local aParam	:= {}

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""


	//Verifica se existe produto para impressใo de etiqueta
	If IsPrdEti(cDoc, cSerie, cFornece, cLoja)

		If Aviso("Aten็ใo","Deseja imprimir a(s) etiqueta(s) ?" ,{"Sim","Nใo"},2) == 1 .And. PergRel(@aParam)

			//Executa a rotina de impressใo de etiqueta
			RunImp(cDoc, cSerie, cFornece, cLoja, aParam[1])
		EndIf
	EndIf

	RestArea(aArea)	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณIsPrdEti	บAutor  ณMicrosiga	     บ Data ณ  17/10/2019 	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se existe produto apto para imprimir etiqueta	  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
Static Function IsPrdEti(cDoc, cSerie, cFornece, cLoja)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cTpProd	:= U_MyNewSX6("CV_TPPRDET", "MP|ME"	,"C","Tipos de produtos a serem considerados na etiqueta.", "", "", .F. )
	Local lRet		:= .F.

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""

	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SD1")+" SD1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD1.D1_COD " +CRLF
	cQuery	+= " AND SB1.B1_TIPO  IN"+FormatIn(cTpProd,"|")+" "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD1.D1_TES "+CRLF
	cQuery	+= " AND SF4.F4_ESTOQUE = 'S' "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF
	cQuery	+= " AND SD1.D1_DOC = '"+cDoc+"' "+CRLF
	cQuery	+= " AND SD1.D1_SERIE = '"+cSerie+"' "+CRLF
	cQuery	+= " AND SD1.D1_FORNECE = '"+cFornece+"' "+CRLF
	cQuery	+= " AND SD1.D1_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR > 0
		lRet := .T.
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRunImp		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta a rotina de impressใo das etiquetas				  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
Static Function RunImp(cDoc, cSerie, cFornece, cLoja, cCodImp)
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cTpProd	:= U_MyNewSX6("CV_TPPRDET", "MP|ME"	,"C","Tipos de produtos a serem considerados na etiqueta.", "", "", .F. )
	Local nQtdEti	:= 0
	Local nX		:= 0
	Local cCodEti	:= ""
	Local lImp		:= .F. 

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""
	Default cCodImp		:= "000001"

	cQuery	:= " SELECT B1_COD, B1_QE, D1_DOC, D1_SERIE, D1_FORNECE, D1_QUANT, D1_PEDIDO, "+CRLF
	cQuery	+= " D1_LOJA, D1_LOCAL, D1_LOTECTL, D1_NUMLOTE, B8_DTVALID, B8_YFABRIC FROM "+RetSqlName("SD1")+" SD1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD1.D1_COD " +CRLF
	cQuery	+= " AND SB1.B1_TIPO  IN"+FormatIn(cTpProd,"|")+" "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB8")+" SB8 "+CRLF
	cQuery	+= " ON SB8.B8_FILIAL = SD1.D1_FILIAL "+CRLF
	cQuery	+= " AND SB8.B8_PRODUTO = SD1.D1_COD "+CRLF
	cQuery	+= " AND SB8.B8_LOCAL = SD1.D1_LOCAL "+CRLF
	cQuery	+= " AND SB8.B8_LOTECTL = SD1.D1_LOTECTL "+CRLF
	cQuery	+= " AND SB8.B8_NUMLOTE = SD1.D1_NUMLOTE "+CRLF
	cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF
	cQuery	+= " AND SD1.D1_DOC = '"+cDoc+"' "+CRLF
	cQuery	+= " AND SD1.D1_SERIE = '"+cSerie+"' "+CRLF
	cQuery	+= " AND SD1.D1_FORNECE = '"+cFornece+"' "+CRLF
	cQuery	+= " AND SD1.D1_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		//Verifica se o produto estแ apto para imprimir etiqueta
		If VldPrdImp((cArqTmp)->D1_DOC, (cArqTmp)->D1_SERIE, (cArqTmp)->D1_FORNECE, (cArqTmp)->D1_LOJA, (cArqTmp)->B1_COD)

			//Calculo da quantidade de etiquetas
			nQtdEti := INT((cArqTmp)->D1_QUANT / (cArqTmp)->B1_QE)

			//Grava a tabela CB0 e imprime todas as etiquetas para o produto
			For nX := 1 To nQtdEti

				//Realiza a grava็ใo da etiqueta na tabela CB0
				cCodEti := GravaCB0((cArqTmp)->B1_COD,;					//Produto 
				(cArqTmp)->B1_QE,; 				//Quantidade
				"",; 							//Usuario
				(cArqTmp)->D1_DOC,; 			//Nf de Entrada
				(cArqTmp)->D1_SERIE,; 			//Serie de Entrada
				(cArqTmp)->D1_FORNECE,; 		//Codigo do fornecedor
				(cArqTmp)->D1_LOJA,; 			//Loja
				(cArqTmp)->D1_PEDIDO,;			//Pedido compra
				"",; 							//Localiza็ใo
				(cArqTmp)->D1_LOCAL, ;			//Armazem
				"",; 							//Codigo da OP
				"",; 							//Sequencia
				"",; 							//Nf de Saida
				"",; 							//Serie de Saida
				"",; 							//Etiqueta do cliente
				(cArqTmp)->D1_LOTECTL,; 		//Lote
				"",;							//Sub lote
				STOD((cArqTmp)->B8_DTVALID),; 	//Data de validade
				"")								//Centro de custo

				//Chama a rotina para imprimir a etiqueta						
				ImpEtiq(cCodEti, STOD((cArqTmp)->B8_YFABRIC), cCodImp, @lImp)										 				
			Next
			
			//Finaliza a impressao
			If lImp
				MSCBCLOSEPRINTER()
			EndIf   
			
		Else
			Aviso("Aten็ใo","Produto "+Alltrim((cArqTmp)->D1_COD)+" sem saldo em estoque. Nใo serแ possํvel imprimir a etiqueta. ",{"Ok"},2)
		EndIf


		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGravaCB0		บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a grava็ใo dos dados na tabela CB0				  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaCB0(cProd, nQtd, cUsr, cNfEntr, cSerieEntr, cCodFor, cLoja, cPedCom,cLocaliz, cArmaz, ;
	cOp, cNumSeq, cNfSaida, cSerieSaid, cEtiqCli, cLote, cSbLote, dDtValid, cCentroCust)

	Local aArea 		:= GetArea()
	Local aConteudo		:= {}
	Local cRet			:= ""

	Default cProd 		:= ""
	Default nQtd		:= 0
	Default cUsr		:= ""
	Default cNfEntr		:= ""
	Default cSerieEntr	:= ""
	Default cCodFor		:= ""
	Default cLoja		:= ""
	Default cLocaliz	:= ""
	Default cArmaz		:= ""
	Default cOp			:= ""
	Default cNumSeq		:= ""
	Default cNfSaida	:= ""
	Default cSerieSaid	:= ""
	Default cEtiqCli	:= ""
	Default cLote		:= ""
	Default cSbLote		:= ""
	Default dDtValid	:= ""
	Default cCentroCust	:= ""

	aConteudo := {cProd,; 
	nQtd,; 
	cUsr,; 
	cNfEntr,; 
	cSerieEntr,; 
	cCodFor,; 
	cLoja,;
	cPedCom,; 
	cLocaliz,; 
	cArmaz, ;
	cOp,; 
	cNumSeq,; 
	cNfSaida,; 
	cSerieSaid,; 
	cEtiqCli,; 
	cLote,; 
	cSbLote,; 
	dDtValid,; 
	cCentroCust,;
	Nil,Nil,Nil,Nil,Nil,Nil}

	cRet := CBGrvEti("01",aConteudo, Nil)

	RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณImpEtiq		บAutor  ณMicrosiga		 บ Data ณ  10/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime a etiqueta									      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpEtiq(cCodEtiq, dFabric, cCodImp, lImp)

	Local aArea		:= GetArea()

	DbSelectArea("CB0")
	DbSetOrder(1)
	If CB0->(DbSeek(xFilial("CB0")+cCodEtiq ))

		DbSelectArea("SB1")
		DbSetOrder(1)
		If SB1->(DbSeek(xFilial("SB1") + CB0->CB0_CODPRO))

			CB5SetImp(cCodImp)
			MSCBBEGIN(1,6)
			MSCBBOX(04,04,90,112,5)
			MSCBLineV(80,04,112,3)
			MSCBLineV(70,04,112,3)
			MSCBLineV(45,04,112,3)   
			MSCBSAY(82,50,"PROZYN","R","C","40")
			MSCBSAY(72,05,"FAB: ","R","C","30")  
			MSCBSAY(72,30,DtoC(dFabric), "R", "C", "30") 
			MSCBSAY(72,68,"VAL:", "R", "C", "30")			
			MSCBSAY(72,80,DtoC(CB0->CB0_DTVLD), "R", "C", "30") 

			MSCBSAY(62,05,"CODIGO:", "R", "C", "40")
			MSCBSAY(59,35,AllTrim(CB0->CB0_CODPRO), "R", "C", "70")
			MSCBSAY(50,05,"LOTE: ", "R", "C", "30")   
			MSCBSAY(47,35,CB0->CB0_LOTE, "R", "C", "70")

			MSCBSAY(38,05,"PESO LIQ: ", "R", "C", "30")
			MSCBSAY(35,40,AllTrim(Transform(CB0->CB0_QTDE ,"@E 999,999.9999"))+Space(01)+SB1->B1_UM, "R", "C", "60")
			MSCBSAYBAR(13,40,CB0->CB0_CODETI,"R","MB07",15,.F.,.T.,.F.,,3,1,.F.,.F.,"1",.T.) 
			MSCBSAY(05,40, CB0->CB0_CODETI	,'R', "C" , "5" )
			MSCBInfoEti("Produto","100X30")
			MSCBEND()
			
			lImp := .T.
		EndIf
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณVldPrdImp	บAutor  ณMicrosiga	     บ Data ณ  17/10/2019 	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo do produto a ser impresso						  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
Static Function VldPrdImp(cDoc, cSerie, cFornece, cLoja, cCod)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cTpProd	:= U_MyNewSX6("CV_TPPRDET", "MP|ME"	,"C","Tipos de produtos a serem considerados na etiqueta.", "", "", .F. )
	Local lVldSld	:= U_MyNewSX6("CV_VLDSLET", .T.	,"L","Verifica se valida o saldo do produto na impressใo da etiqueta.", "", "", .F. )
	Local lRet		:= .F.

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""

	If !lVldSld
		Return .T.
	EndIf

	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SD1")+" SD1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD1.D1_COD " +CRLF
	cQuery	+= " AND SB1.B1_TIPO  IN"+FormatIn(cTpProd,"|")+" "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB8")+" SB8 "+CRLF
	cQuery	+= " ON SB8.B8_FILIAL = SD1.D1_FILIAL "+CRLF
	cQuery	+= " AND SB8.B8_PRODUTO = SD1.D1_COD "+CRLF
	cQuery	+= " AND SB8.B8_LOCAL = SD1.D1_LOCAL "+CRLF
	cQuery	+= " AND SB8.B8_LOTECTL = SD1.D1_LOTECTL "+CRLF
	cQuery	+= " AND SB8.B8_NUMLOTE = SD1.D1_NUMLOTE "+CRLF
	cQuery	+= " AND (SB8.B8_SALDO-SB8.B8_EMPENHO-SB8.B8_QACLASS) > 0 "+CRLF
	cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF
	cQuery	+= " AND SD1.D1_DOC = '"+cDoc+"' "+CRLF
	cQuery	+= " AND SD1.D1_SERIE = '"+cSerie+"' "+CRLF
	cQuery	+= " AND SD1.D1_FORNECE = '"+cFornece+"' "+CRLF
	cQuery	+= " AND SD1.D1_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SD1.D1_COD = '"+cCod+"' "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR > 0
		lRet := .T.
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPergRel  บAutor  ณMicrosiga	         บ Data ณ  01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPergunta 							                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PergRel(aParam)

	Local aArea 		:= GetArea()
	Local aParamBox		:= {} 
	Local lRet			:= .F.
	Local cLoadArq		:= "pzcvr10"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)

	AADD(aParamBox,{1,"Impressora"		,Space(TamSx3("CB5_CODIGO")[1])	,"","","CB5","",50,.T.})

	//Monta a pergunta
	lRet := ParamBox(aParamBox, "Parโmetros", @aParam, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

	RestArea(aArea)
Return lRet  
