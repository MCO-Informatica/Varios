#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE PRODUTO		1
#DEFINE QTD			2
#DEFINE QTDEMB		3
#DEFINE LOTE		4
#DEFINE IMPRESSORA	5

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PZCVR008		ºAutor  ³Microsiga	     º Data ³  10/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Etiqueta de recebimento (Impressora Zebra)				  º±±
±±º          ³(Imprime o relatorio com base na tabela CB0)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVR008()

	Local aArea 	:= GetArea()
	Local aParams	:= {}

	If PergRel(@aParams)
		Processa( {|| RunProcRel(aParams[PRODUTO], aParams[QTD], aParams[QTDEMB], aParams[LOTE], aParams[IMPRESSORA]) },"Aguarde...","" )
	EndIf

	RestArea(aArea)	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PergRel	ºAutor  ³Microsiga		     º Data ³  10/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas a serem utilizadas no filtro				      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PergRel(aParams)

	Local aParamBox := {}
	Local lRet      := .T.
	Local cLoadArq	:= "PZCVR008X"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)

	AADD(aParamBox,{1,"Produto"			,Space(TamSx3("B1_COD")[1])		,"","","SB1","",50,.T.})	
	AADD(aParamBox,{1,"Quantidade"		,25.000							,"@E 999,999,999.999","","","",50,.T.})
	AADD(aParamBox,{1,"Qtd.Por Embalag.",25.000							,"@E 999,999,999.999","","","",50,.T.})
	AADD(aParamBox,{1,"Lote"			,Space(TamSx3("C2_LOTECTL")[1])	,"","","","",50,.T.})
	AADD(aParamBox,{1,"Impressora"		,Space(TamSx3("CB5_CODIGO")[1])		,"","","CB5","",50,.T.})	

	lRet := ParamBox(aParamBox, "Parâmetros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RunProcRel	ºAutor  ³Microsiga		 º Data ³  10/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a geração do relatorio						      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunProcRel(cCodProd, nQtd, nQtdEmb, cLote, cImpressora)

	Local aArea		:= GetArea()
	Local nQtdEti	:= 0
	Local nX		:= 0
	Local cArqTmp	:= ""
	Local cCodEti	:= ""
	Local lLibUsr	:= .F.

	Default cCodProd	:= "" 
	Default nQtd		:= 0 
	Default nQtdEmb		:= 0
	Default cLote		:= ""
	Default cImpressora	:= ""

	//Verifica se esta liberado a validação do lote para o usuario
	lLibUsr	:= IsLibUsr(cCodProd)

	//Validação do usuario e/ou lote do produto
	If IsLoteVld(cCodProd, cLote) .Or. lLibUsr
		If nQtd > 0 .And. nQtdEmb > 0

			//Quantidade de etiquetas
			nQtdEti := INT(nQtd / nQtdEmb)

			For nX	:= 1 To nQtdEti

				//Dados da etiqueta
				cArqTmp	:= GetDadEtiq(cCodProd, cLote)

				If (cArqTmp)->(!Eof())

					//Realiza a gravação da tabela CB0
					cCodEti := GravaCB0((cArqTmp)->B8_PRODUTO,;			//Produto 
					nQtdEmb,; 								//Quantidade
					"",; 									//Usuario
					"",; 									//Nf de Entrada
					"",; 									//Serie de Entrada
					"",; 									//Codigo do fornecedor
					"",; 									//Loja
					"",;									//Pedido compra
					"",; 									//Localização
					(cArqTmp)->B1_LOCPAD, ;					//Armazem
					"",; //Codigo da OP
					"",; 									//Sequencia
					"",; 									//Nf de Saida
					"",; 									//Serie de Saida
					"",; 									//Etiqueta do cliente
					(cArqTmp)->B8_LOTECTL,; 				//Lote
					"",;									//Sub lote
					STOD((cArqTmp)->B8_DTVALID),; 			//Data de validade
					"")									//Centro de custo
					
					//Imprime a etiqueta
					ImpEtiq(cCodEti, STOD((cArqTmp)->B8_YFABRIC),cImpressora)
					 
				ElseIf lLibUsr
					If Select(cArqTmp)>0
						(cArqTmp)->(DbCloseArea())
					EndIf

					cArqTmp := GetDadSc2(cCodProd, cLote)

					If (cArqTmp)->(!Eof())

						//Realiza a gravação da tabela CB0
						cCodEti := GravaCB0((cArqTmp)->C2_PRODUTO,;			//Produto 
						nQtdEmb,; 								//Quantidade
						"",; 									//Usuario
						"",; 									//Nf de Entrada
						"",; 									//Serie de Entrada
						"",; 									//Codigo do fornecedor
						"",; 									//Loja
						"",;									//Pedido compra
						"",; 									//Localização
						(cArqTmp)->B1_LOCPAD, ;					//Armazem
						(cArqTmp)->OP,; //Codigo da OP
						"",; 									//Sequencia
						"",; 									//Nf de Saida
						"",; 									//Serie de Saida
						"",; 									//Etiqueta do cliente
						(cArqTmp)->C2_LOTECTL,; 								//Lote
						"",;									//Sub lote
						STOD((cArqTmp)->C2_DTVALID),; 			//Data de validade
						"")									//Centro de custo 
						
						//Imprime a etiqueta
						ImpEtiq(cCodEti, STOD((cArqTmp)->C2_EMISSAO),cImpressora)
					Else
						Aviso("Atenção","Lote ("+Alltrim(cLote)+") não encontrado, verifique os dados preenchidos.",{"Ok"},2)	
					EndIf


				EndIf


				If Select(cArqTmp)>0
					(cArqTmp)->(DbCloseArea())
				EndIf

			Next

		Else
			Aviso("Atenção", "Quantidade ou Qtd.Por Embalagem não preenchido",{"Ok"},2)
		EndIf

	Else
		Aviso("Atenção","Lote ("+Alltrim(cLote)+") não encontrado, verifique os dados preenchidos.",{},2)
	EndIf


	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IsLoteVld		ºAutor  ³Microsiga		 º Data ³  10/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o lote é valido							      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IsLoteVld(cCodProd, cLote)

	Local aArea		:= GetArea()
	Local lRet		:= .F.
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodProd	:= "" 
	Default cLote		:= ""

	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SB8")+" SB8 "
	cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
	cQuery	+= " AND SB8.B8_PRODUTO = '"+cCodProd+"' "
	cQuery	+= " AND SB8.B8_LOTECTL = '"+cLote+"' "
	cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If ((cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR > 0)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetDadEtiq	ºAutor  ³Microsiga		 º Data ³  10/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o lote é valido							      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetDadEtiq(cCodProd, cLote)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodProd	:= "" 
	Default cLote		:= ""

	cQuery	:= " SELECT B8_PRODUTO, B8_LOTECTL, B8_DTVALID, B8_LOCAL, B8_YFABRIC, B1_LOCPAD FROM "+RetSqlName("SB8")+" SB8 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SB8.B8_PRODUTO "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
	cQuery	+= " AND SB8.B8_PRODUTO = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND SB8.B8_LOTECTL = '"+cLote+"' "+CRLF
	cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " ORDER BY B8_DTVALID "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	RestArea(aArea)
Return cArqTmp


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetDadSc2		ºAutor  ³Microsiga		 º Data ³  10/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os dados da etiqueta atraves das tabelas sc2/sb1    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetDadSc2(cCodProd, cLote)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodProd	:= "" 
	Default cLote		:= ""


	cQuery	:= " SELECT B1_LOCPAD, C2_EMISSAO, C2_PRODUTO, C2_LOTECTL, C2_DTVALID, (SC2.C2_NUM + SC2.C2_ITEM+ SC2.C2_SEQUEN) OP FROM "+RetSqlName("SC2")+" SC2 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SC2.C2_PRODUTO "+CRLF
	cQuery	+= " AND SB1.B1_TIPO IN('PA','PI') "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SC2.C2_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SC2.C2_PRODUTO = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND SC2.C2_LOTECTL = '"+cLote+"' "+CRLF
	cQuery	+= " AND SC2.D_E_L_E_T_ = ' ' "+CRLF


	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	RestArea(aArea)
Return cArqTmp



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GravaCB0		ºAutor  ³Microsiga	     º Data ³  18/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravação dos dados na tabela CB0				  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpEtiq		ºAutor  ³Microsiga		 º Data ³  10/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime a etiqueta									      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpEtiq(cCodEtiq, dFabric, cImpressora)

	Local aArea		:= GetArea()
	Local cCodImp	:= ""//U_MyNewSX6("CV_IMPETIR", "000001","C","Codigo da impressora do recebimento", "", "", .F. )

	Default cImpressora := "000001"

	//Codio da impressora
	cCodImp := cImpressora

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

			//Finaliza a impressao
			MSCBCLOSEPRINTER()   

		EndIf
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IsLibUsr		ºAutor  ³Microsiga		 º Data ³  25/11/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se libera a impressão para o usuario			      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IsLibUsr(cCod)

	Local aArea		:= GetArea()
	Local cCodUsr	:= Alltrim(RetCodUsr())
	Local cCodULib	:= U_MyNewSX6("CV_USLBETQ", ""	,"C","Usuarios liberados a imprimir etiqueta sem consultar lote", "", "", .F. )
	Local lRet		:= .F.

	Default cCod 	:= ""

	If !Empty(cCod)
		DbSelectArea("SB1")
		DbSetOrder(1)
		If SB1->(DbSeek(xFilial("SB1") + cCod))
			If (Alltrim(SB1->B1_TIPO) $ 'PA|PI') .And. Alltrim(cCodUsr) $ Alltrim(cCodULib)
				lRet := .T.
			EndIf
		EndIf
	EndIf

	RestArea(aArea)
Return lRet