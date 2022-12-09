#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExecFila  ºAutor  ³Darcio R. Sporl     º Data ³  05/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte criado para executar a fila de pedidos gravada anteri-º±±
±±º          ³ormente com os pedidos gerados pelo site                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ExecFila(_lJob)
Local aDados	:= {}
Local aDadosT	:= {}
Local nOpc		:= 3
Local cNpSite	:= ""
Local cTipo		:= ""
Local cCliente	:= ""
Local cLjCli	:= ""
Local cTpCli	:= ""
Local cForPag	:= ""
Local dEmissao	:= ""
Local cItem		:= ""
Local cProd		:= ""
Local cNome		:= ""
Local cNReduz	:= ""
Local cEnd		:= ""
Local cBairro	:= ""
Local cCompl	:= ""
Local cCep		:= ""
Local cFone		:= ""
Local cDDD		:= ""
Local cEmail	:= ""
Local nQtVend	:= 0
Local nPrecUni	:= 0
Local nPrecVen	:= 0
Local nValor	:= 0
Local dEntreg	:= CtoD("  /  /  ")
Local cTES		:= ""
Local cError	:= ""
Local cWarning	:= ""
Local cCgc		:= ""
Local cPessoa	:= ""
Local cTabela	:= ""
Local cTabela1	:= ""
Local nI		:= 0
Local aProdutos	:= {}
Local cPosNom	:= ""	//Nome do Posto
Local cPosEnd	:= ""	//Endereco Posto
Local cPosBai	:= ""	//Bairro Posto
Local cPosCom	:= ""	//Complemento Posto
Local cPosCep	:= ""	//Cep Posto
Local cPosFon	:= ""	//Fone Posto
Local cPosCid	:= ""	//Nome da cidade do Posto
Local cPosUf	:= ""	//UF do Posto
Local cPosCod	:= ""	//Codigo do Posto
Local cPosLoj	:= ""	//Loja do Posto
Local cPosGAR	:= ""
Local lChkVou	:= .F.
Local lRet		:= .T.
Local cTipCar	:= ""
Local cNumCart	:= ""
Local cNomTit	:= ""
Local cCodSeg	:= ""
Local dDtVali	:= CtoD("  /  /  ")
Local cParcela	:= ""
Local cTipo		:= ""
Local cLinDig	:= ""
Local cNumVou	:= ""
Local nQtdVou	:= 0
Local cDados	:= ""
Local aParam	:= {}
Local aRVou		:= {.T., ""}
Local nPed		:= 0
Local nPro		:= 0
Local nProd		:= 0
Local cNomeC	:= ""
Local cCpfC		:= ""
Local cEmailC	:= ""
Local cSenhaC	:= ""
Local cFoneC	:= ""
Local cQrySC5	:= ""
Local cRootPath	:= ""
Local cArquivo	:= ""
Local oXml		:= Nil
Local cQryGT	:= ""
Local cQryXML	:= ""
Local cUpdLis	:= ""
Local cUpdPed	:= ""
Local cRootPath	:= ""
Local cID		:= ""
Local cPedGarL	:= ""
Local cXML		:= ""
Local nXML		:= 0
Local aRetCo	:= {}
Local aRetCl	:= {}
Local cJobEmp	:= GETJOBPROFSTRING ("JOBEMP", "01")
Local cJobFil	:= GETJOBPROFSTRING ("JOBFIL", "02")
Local cInEst	:= ""
Local cInMun	:= ""
Local cSufra	:= ""
Local nDias		:= 0

Default _lJob 	:= .T. //Executa o acesso ao Servidor

If _lJob
	RpcSetType(2)
	RpcSetEnv(cJobEmp, cJobFil)
EndIf

Private cContSite := ""

cTabela	:= GetMV("MV_XTABPRC",,"")
nDias	:= GetMV("MV_XDIAPRC",,3)
If Select("QRYGT") > 0
	DbSelectArea("QRYGT")
	QRYGT->(DbCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recupero as listas de pedidos que ainda nao foram executadas ³
// ou pedidos ainda não processados devido a falta de Thread de ³
// acordo numero de dias informado no  parâmetro MV_XDIAPRC     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQryGT := "SELECT GT_ID, GT_PEDGAR "
cQryGT += "FROM GTIN " 
cQryGT += "WHERE GT_TYPE = 'F' "
cQryGT += "AND GT_SEND = 'F' " 
cQryGT += "AND D_E_L_E_T_ = ' ' " 
cQryGT += "UNION "
cQryGT += "SELECT "
cQryGT += "	GT_ID, GT_PEDGAR "
cQryGT += "FROM "
cQryGT += "	GTOUT A LEFT OUTER JOIN "+RetSqlName("SC5")+" B ON "
cQryGT += "	B.C5_FILIAL = '"+xFilial("SC5")+"' AND "
cQryGT += "	B.D_E_L_E_T_ = ' ' AND "
cQryGT += "	GT_PEDGAR = C5_XNPSITE "
cQryGT += "WHERE "
cQryGT += "	B.C5_NUM IS NULL AND " 
cQryGT += "	A.GT_DATE >= '"+DtoS(Date()-nDias)+"' AND "
cQryGT += "	A.GT_CODMSG = 'E00002' "
cQryGT += "ORDER BY GT_ID "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGT),"QRYGT",.F.,.T.)
DbSelectArea("QRYGT")

While QRYGT->(!Eof())
	
	cPedGarL	:= SubStr(QRYGT->GT_ID, 1, 10)
	
	cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
	cRootPath	:= cRootPath + "vendas_site\"
	
	cID			:= AllTrim(QRYGT->GT_ID)
	cArquivo	:= "Pedidos_" + cID + ".XML"
	cArquivo	:= cRootPath + cArquivo
	
	oXml		:= XmlParserFile( cArquivo, "_", @cError, @cWarning )
	
	cTipo		:= "N" //Tipo de pedido N = Normal
	if valtype(oXml)=='O'
	   
		If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
			XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
		EndIf
	ELSE
	
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "E00001" ) // NFS gerada com sucesso...
		Aadd( aRet, QRYGT->GT_PEDGAR )
	    Aadd( aRet, "" )
		
			
		U_GTPutOUT(cID,"F",QRYGT->GT_PEDGAR,{"U_EXECFILA",{"F",aRet},"Erro no XML da FILA " + cArquivo,,})
	                           
		QRYGT->(DbSkip())
    	Loop
	
	Endif
	For nPed := 1 to Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO)
		aProdutos	:= {}
		
		cNpSite := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_NUMERO:TEXT)
		
		//Verifica se Fila se Refere a Pedido GAR posicionado na Tabela Gtin
		If AllTrim(QRYGT->GT_PEDGAR) == cNpSite
	        
	 		//Semaforo para controle de processamento de pedido
	 		If U_GarLock(cNpSite) 
			
				//TRATAMENTO PARA ERRO FATAL NA THREAD
				cErrorMsg := ""
				bOldBlock := ErrorBlock({|e| U_ProcError(e) })
				
				BEGIN SEQUENCE		
		
				If Select("QRYGTF") > 0
					DbSelectArea("QRYGTF")
					QRYGTF->(DbCloseArea())
				EndIf
				     
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a existencia do pedido em outra fila.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cQryGT := "SELECT COUNT(GT_ID) QTDFILA "
				cQryGT += "FROM GTIN "
				cQryGT += "WHERE GT_TYPE = 'F' "
				cQryGT += "AND GT_SEND = 'T' "
				cQryGT += "AND GT_PEDGAR = '" + cNpSite + "' "
				cQryGT += "AND GT_ID <> '" + cID + "' "
				cQryGT += "AND D_E_L_E_T_ = ' ' "
				
				cQryGT := ChangeQuery(cQryGT)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGT),"QRYGTF",.F.,.T.)
				DbSelectArea("QRYGTF")
				
				If QRYGTF->QTDFILA <= 0
					
					If Select("QRYSC5") > 0
						DbSelectArea("QRYSC5")
						QRYSC5->(DbCloseArea())
					EndIf
					
					cQrySC5 := "SELECT COUNT(*) NCONT "
					cQrySC5 += "FROM " + RetSqlName("SC5") + " "
					cQrySC5 += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
					cQrySC5 += "  AND C5_XNPSITE = '" + cNpSite + "' "
					cQrySC5 += "  AND D_E_L_E_T_ = ' '"
					
					cQrySC5 := ChangeQuery(cQrySC5)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.)
					DbSelectArea("QRYSC5")
					
					If QRYSC5->NCONT <= 0
						
						cEmailC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_EMAIL:TEXT
						cNomeC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_NOME:TEXT
						cCpfC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_CPF:TEXT
						cSenhaC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_SENHA:TEXT
						cFoneC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_FONE:TEXT
						
						aDados := {cNomeC, cCpfC, cEmailC, cSenhaC, cFoneC}
						
						U_GTPutIN(cID,"O",cNpSite,.T.,{"U_CriaCtto",cNpSite,aDados})
						
						aRetCo := U_CriaCtto(cCpfC, aDados)
						
						aRet := {}
						Aadd( aRet, aRetCo[1])
						Aadd( aRet, if(aRetCo[1],"M00001","E00001") )
						Aadd( aRet, cNpSite )
						Aadd( aRet, "" )
						
						If aRetCo[1]
							U_GTPutOUT(cID,"O",cNpSite,{"CRIACONTATO",{"O",aRet},aRetCo[2]})
						Else
							U_GTPutOUT(cID,"O",cNpSite,{"CRIACONTATO",{"O",aRet},aRetCo[2]})
						EndIf
						
						cInEst	:= ""
						cInMun	:= ""
						cSufra	:= ""
						
						//Verifico se eh pessoa fisica ou juridica, pois a informacao eh passada de maneira diferente no XML
						If "PF" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_XSI_TYPE:TEXT
							cCgc	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CPF:TEXT
							cNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_NOME:TEXT
							cNReduz	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_NOME:TEXT
							cEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT + ", " + oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_NUMERO:TEXT
							cCompl	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_COMPL:TEXT
							cCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT
							cBairro	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_BAIRRO:TEXT
							cFone	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 3, 8)
							cDDD	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 1, 2)
							cUfNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT
							cUf		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT
							cEmail	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_EMAIL:TEXT
							cPessoa	:= "F"
						Else
							cCgc	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CNPJ:TEXT
							cNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_RZSOCIAL:TEXT
							cNReduz	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_RZSOCIAL:TEXT
							cEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT + oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_NUMERO:TEXT
							cCompl	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_COMPL:TEXT
							cCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT
							cBairro	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_BAIRRO:TEXT
							cFone	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 3, 8)
							cDDD	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 1, 2)
							cUfNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT
							cUf		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT
							cInEst	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCEST:TEXT
							cInMun	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCMUN:TEXT
							cSufra	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_SUFRAMA:TEXT
							cEmail	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_EMAIL:TEXT
							cPessoa	:= "J"
						EndIf
						
						cInEst	:= iif(Empty(cInEst),"ISENTO",ALLTRIM(cInEst))
						cInMun	:= iif(Empty(cInMun),"ISENTO",ALLTRIM(cInMun))
						
						DbSelectArea("SA1")
						DbSetOrder(3) //A1_FILIAL + A1_CGC
						If !DbSeek(xFilial("SA1") + U_CSFMTSA1(cCgc))
							
							cCliente	:= GetSXENum('SA1','A1_COD')
							cLjCli		:= "01"
							cTpCli		:= "F"	//Consumidor final
							
							nOpc 		:= 3
							
							U_GTPutIN(cID,"C",cNpSite,.T.,{"U_CriaCli",cNpSite,{cCliente, cLjCli, cEmail}})
							
							//Cria cadastro de cliente, caso o mesmo nao exista.
							aRetCl := U_CriaCli(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cUfNome,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,cSufra)
							
							If __lSX8
								ConfirmSX8()
							EndIf
							
							aRet := {}
							Aadd( aRet, aRetCl[1])
							Aadd( aRet, if(aRetCl[1],"M00001","E00001") )
							Aadd( aRet, cNpSite )
							Aadd( aRet, "" )
							
						Else
							cCliente	:= SA1->A1_COD
							cLjCli		:= SA1->A1_LOJA
							cTpCli		:= iif(Empty(SA1->A1_TIPO),"F",SA1->A1_TIPO)
							cPessoa		:= iif(Empty(SA1->A1_PESSOA),cPessoa,SA1->A1_PESSOA)
							
							nOpc 		:= 4
							
							U_GTPutIN(cID,"C",cNpSite,.T.,{"U_CriaCli",cNpSite,{cCliente, cLjCli, cEmail}})
							
							//Altera cadastro de cliente, caso o mesmo exista.
							aRetCl := U_CriaCli(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cUfNome,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,cSufra)
							
							aRet := {}
							Aadd( aRet, aRetCl[1])
							Aadd( aRet, if(aRetCl[1],"M00001","E00001") )
							Aadd( aRet, cNpSite )
							Aadd( aRet, "" )
							
						EndIf
						
						U_GTPutOUT(cID,"C",cNpSite,{"CRIACLIENTE",{"C",aRet},aRetCl[2]})
						
						If aRetCl[1]
							//Cliente foi tratado com sucesso
							cCliente	:= SA1->A1_COD
							cLjCli		:= SA1->A1_LOJA
							cTpCli		:= SA1->A1_TIPO
							
							//Amarro o contato ao cliente
							U_ConXCli("SA1", cCliente, cLjCli, cContSite)
							
							//Zero as variaveis das formas de pagamento, para pegar a proxima
							cNumCart	:= ""
							cNomTit		:= ""
							cCodSeg		:= ""
							dDtVali		:= CtoD("  /  /  ")
							cParcela	:= ""
							cTipCar		:= " "
							cLinDig		:= ""
							lChkVou		:= .F.
							cNumVou		:= ""
							nQtdVou		:= 0
							
							//Forma de Pagamento
							If "cartao" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT
								cForPag		:= "2"
								cNumCart	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT
								cNomTit		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NMTITULAR:TEXT
								cCodSeg		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CODSEG:TEXT
								dDtVali		:= CtoD(SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_DTVALID:TEXT,1,10))
								cParcela	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_PARCELAS:TEXT
								cTipCar		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_TIPO:TEXT
							ElseIf "boleto" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT
								cForPag		:= "1"
								cLinDig		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_LINHADIGITAVEL:TEXT
							ElseIf "voucher" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT
								lChkVou		:= .T.
								cForPag		:= "3"
								cNumVou		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT
								nQtdVou		:= Val(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_QTCONSUMIDA:TEXT)
							EndIf
							
							//Emissao do pedido
							dEmissao	:= CtoD(SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_DATA:TEXT,1,10))
							
							//Data de Entrega
							dEntreg		:= CtoD(SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_DATA:TEXT,1,10))
							
							//Tipo de Entrada/Saida
							cTES        := GetMV("MV_XTESWEB",,"502")
							
							//Produtos
							If	Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO) <> "A"
								XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO, "_PRODUTO" )
							EndIf
							
							For nProd := 1 To Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO)
								//Verifico se o produto é do tipo Combo, para pegar os itens do combo
								AADD(aProdutos, {	StrZero(nProd, TamSX3("C6_ITEM")[1]),;										//[1]Item
								oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODPROD:TEXT,;		//[2]Codigo Produto
								oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_QTD:TEXT,;			//[3]Quantidade
								oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLUNID:TEXT,;		//[4]Valor Unitario
								oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLDESCONTO:TEXT,;	//[5]Valor com desconto
								oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLTOTAL:TEXT,;		//[6]Valor Total
								dEntreg,;																	//[7]Data da Entrega
								cTES,;																		//[8]TES
								cNumVou,;																	//[9]Numero Voucher
								nQtdVou})																	//[10]Saldo Voucher
			
								cTabela1 := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODGRUPO:TEXT
							Next nI
							
							If Empty(cTabela1)
								cTabela1 := cTabela
							EndIf
							
							//Se a forma de pagamento for voucher, faco as devidas validacoes
							If lChkVou
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Posicoes do aProduto ³
								//³[1]Item              ³
								//³[2]Codigo Produto    ³
								//³[3]Quantidade        ³
								//³[4]Valor Unitario    ³
								//³[5]Valor com desconto³
								//³[6]Valor Total       ³
								//³[7]Data da Entrega   ³
								//³[8]TES               ³
								//³[9]Numero Voucher    ³
								//³[10]Saldo Voucher    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								
								U_GTPutIN(cID,"V",cNpSite,.T.,{"U_ValVouHA",cNpSite,{cNumVou, nQtdVou}})
								
								aRVou := U_ValVouHA(aProdutos, cNumVou, nQtdVou)
								
								aRet := {}
								Aadd( aRet, aRVou[1])
								Aadd( aRet, if(aRVou[1],"M00001","E00001") )
								Aadd( aRet, cNpSite )
								Aadd( aRet, "" )
								
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Caso o retorno da validacao do voucher seja verdadeira, faco a movimentacao³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If aRVou[1]
									For nProd := 1 To Len(aProdutos)
										U_MovVoucher(cNpSite, aProdutos[nProd][9], aProdutos[nProd][10], aProdutos[nProd][1])
									Next nProd
									U_GTPutOUT(cID,"V",cNpSite,{"VALVOUHA",{"V",aRet},aRVou[2] + " " + cNumVou})
								Else
									U_GTPutOUT(cID,"V",cNpSite,{"VALVOUHA",{"V",aRet},aRVou[2] + " " + cNumVou})
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Retorno - aRVou                             ³
								//³[1] - .T. Voucher valido, .F. Caso contrario³
								//³[2] - Mensagem caso retorno for .F.         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							Else
								aRVou := {.T.,""}						
							EndIf
							
							If aRVou[1] 
								//Dados do Posto
								cPosNom	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_NOME:TEXT							//Nome do Posto
								cPosEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_DESC:TEXT				//Endereco Posto
								cPosBai	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_BAIRRO:TEXT				//Bairro Posto
								cPosCom	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_COMPL:TEXT				//Complemento Posto
								cPosCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CEP:TEXT				//Cep Posto
								cPosFon	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_FONE:TEXT				//Fone Posto
								cPosCid	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CIDADE:_NOME:TEXT		//Nome da cidade do Posto
								cPosUf	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT	//UF do Posto
								cPosCGC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_CNPJ:TEXT							//CGC Posto
								cPosGAR	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_CODGAR:TEXT						//Codigo do GAR
								
								aParam := {	3,cTipo,cCliente,cLjCli,cTpCli,cForPag,dEmissao,cPosGAR,cPosLoj,cForPag,cNumCart,cNomTit,cCodSeg,;
								dDtVali,cParcela,cTipCar,cNpSite,cLinDig,cNumVou,nQtdVou,cTabela1}
								
								nTime := Seconds()
								While .t.
									
									If U_Send2Proc(cID,"U_IncPed",aParam,aProdutos)
										//Chama a funcao que faz a inclusao do pedido no sistema Protheus
										
										U_GTPutIN(cID,"P",cNpSite,.T.,{"U_IncPed",cNpSite,aParam,aProdutos},,{cNumCart,alltrim(cLinDig),cNumvou})
										conout("Rotina: ExecFila.prw - Linha: 503")

										
										cUpdPed := "UPDATE GTIN "
										cUpdPed += "SET GT_SEND = 'T' "
										cUpdPed += "WHERE GT_ID = '" + cID + "' "
										cUpdPed += "  AND GT_TYPE = 'F' "
										cUpdPed += "  AND GT_SEND = 'F' "
										cUpdPed += "  AND GT_PEDGAR = '" + cNpSite + "' "
										cUpdPed += "  AND D_E_L_E_T_ = ' ' "
										
										TCSqlExec(cUpdPed)
										
										aRet := {}
										Aadd( aRet, .T.)
										Aadd( aRet, "M000001" )
										Aadd( aRet, cNpSite )
										Aadd( aRet, "" )
										
										U_GTPutOUT(cID,"F",cNpSite,{"FILAPEDIDOS",{"F",aRet},"Fila do pedido " + cNpSite + " Executada com sucesso."})
										
										Exit
									Else
										
										nWait := Seconds()-nTime
										If nWait < 0
											nWait += 86400
										Endif
										aRet := {}
										Aadd( aRet, .f.)
										Aadd( aRet, "E00002" )
										Aadd( aRet, cNpSite )
										Aadd( aRet, "" )
										
										If nWait > 10
											// Passou de 2 minutos tentando ? Desiste !
											U_GTPutOUT(cID,"F",cNpSite,{"FILAPEDIDOS",{"F",aRet},"Fila do pedido " + cNpSite + " THREAD indisponível."})
											
											cUpdPed := "UPDATE GTIN "
											cUpdPed += "SET GT_SEND = 'T' "
											cUpdPed += "WHERE GT_ID = '" + cID + "' "
											cUpdPed += "  AND GT_TYPE = 'F' "
											cUpdPed += "  AND GT_SEND = 'F' "
											cUpdPed += "  AND GT_PEDGAR = '" + cNpSite + "' "
											cUpdPed += "  AND D_E_L_E_T_ = ' ' "
											
											TCSqlExec(cUpdPed)
											
											// Solta o lock do processo deste item
											U_GarUnlock(cNpSite)
											
											EXIT
										Endif
										
										// Espera um pouco ( 5 segundos ) para tentar novamente
										
										Sleep(5000)
									EndIf
								EndDo
							Else
								aRet := {}
								Aadd( aRet, .f.)
								Aadd( aRet, "E00001" )
								Aadd( aRet, cNpSite )
								Aadd( aRet, aRetVou[2] )
							
								U_GTPutOUT(cID,"F",cNpSite,{"FILAPEDIDOS",{"F",aRet}})
								
								cUpdPed := "UPDATE GTIN "
								cUpdPed += "SET GT_SEND = 'T' "
								cUpdPed += "WHERE GT_ID = '" + cID + "' "
								cUpdPed += "  AND GT_TYPE = 'F' "
								cUpdPed += "  AND GT_SEND = 'F' "
								cUpdPed += "  AND GT_PEDGAR = '" + cNpSite + "' "
								cUpdPed += "  AND D_E_L_E_T_ = ' ' "
								
								TCSqlExec(cUpdPed)
								// Solta o lock do processo deste item
								U_GarUnlock(cNpSite)
							EndIf
						Else
							aRet := {}
							Aadd( aRet, .f.)
							Aadd( aRet, "E00001" )
							Aadd( aRet, cNpSite )
							Aadd( aRet, aRetCl[2] )
						
							U_GTPutOUT(cID,"F",cNpSite,{"FILAPEDIDOS",{"F",aRet}})		
							
							cUpdPed := "UPDATE GTIN "
							cUpdPed += "SET GT_SEND = 'T' "
							cUpdPed += "WHERE GT_ID = '" + cID + "' "
							cUpdPed += "  AND GT_TYPE = 'F' "
							cUpdPed += "  AND GT_SEND = 'F' "
							cUpdPed += "  AND GT_PEDGAR = '" + cNpSite + "' "
							cUpdPed += "  AND D_E_L_E_T_ = ' ' "
							
							TCSqlExec(cUpdPed)
							
							// Solta o lock do processo deste item
							U_GarUnlock(cNpSite)
							
						EndIf
					Else
						aRet := {}
						Aadd( aRet, .T.)
						Aadd( aRet, "M00001" )
						Aadd( aRet, cNpSite )
						Aadd( aRet, "Pedido Site ["+cNpSite+"] ja Existe na Tabela de Pedidos de Vendas" )
					
						U_GTPutOUT(cID,"F",cNpSite,{"FILAPEDIDOS",{"F",aRet}})		
						
						cUpdPed := "UPDATE GTIN "
						cUpdPed += "SET GT_SEND = 'T' "
						cUpdPed += "WHERE GT_ID = '" + cID + "' "
						cUpdPed += "  AND GT_TYPE = 'F' "
						cUpdPed += "  AND GT_SEND = 'F' "
						cUpdPed += "  AND GT_PEDGAR = '" + cNpSite + "' "
						cUpdPed += "  AND D_E_L_E_T_ = ' ' "
						
						TCSqlExec(cUpdPed)
						// Solta o lock do processo deste item
						U_GarUnlock(cNpSite)
						
					EndIf
					DbSelectArea("QRYSC5")
					QRYSC5->(DbCloseArea())
				EndIf
				
				END SEQUENCE
					
				If InTransact()
				// Esqueceram transacao aberta ... Fecha fazendo commit ...
					Conout("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***")
					EndTran()
				Endif
		
				ErrorBlock(bOldBlock)
			
				cErrorMsg := U_GetProcError()
			
				If !empty(cErrorMsg)
					U_GTPutOUT(cID,"F",cNpSite,{"FILAPEDIDOS",{.F.,"E00001",cNpSite,"Inconsistência na Geração do Pedido"+CRLF+cErrorMsg}})
					
					cUpdPed := "UPDATE GTIN "
					cUpdPed += "SET GT_SEND = 'T' "
					cUpdPed += "WHERE GT_ID = '" + cID + "' "
					cUpdPed += "  AND GT_TYPE = 'F' "
					cUpdPed += "  AND GT_SEND = 'F' "
					cUpdPed += "  AND GT_PEDGAR = '" + cNpSite + "' "
					cUpdPed += "  AND D_E_L_E_T_ = ' ' "
						
					TCSqlExec(cUpdPed)
					
					// Solta o lock do processo deste item
					U_GarUnlock(cNpSite)
				Endif
			Else
				U_GTPutPRO(cID)
				Conout("--> PEDIDO JA SENDO PROCESSADO ["+cNpSite+"] ")					
			Endif		
	
		EndIf		
	Next nPed
	
	cUpdLis := "UPDATE GTIN "
	cUpdLis += "SET GT_SEND = 'T' "
	cUpdLis += "WHERE GT_ID = '" + cID + "' "
	cUpdLis += "  AND GT_TYPE = 'F' "
	cUpdLis += "  AND GT_SEND = 'F' "
	cUpdLis += "  AND GT_PEDGAR = '" + cPedGarL + "' "
	cUpdLis += "  AND D_E_L_E_T_ = ' ' "
	
	TCSqlExec(cUpdLis)
	
	QRYGT->(DbSkip())
End
DbSelectArea("QRYGT")
QRYGT->(DbCloseArea())

Return
