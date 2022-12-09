#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} IMPQUOTE
Realiza a importação de orçamentos provenientes do Sales Force. 
Importação de XML.
@author  marcio.katsumata
@since   07/12/2019
@version 1.0
@param   oXml, object, objeto XML 
@param   oSfInLy, object, objeto do model de layout
@param   oModelIn, object, objeto do model da tabela intermediária.
@return  logical, sucesso no processamento?
/*/
//-------------------------------------------------------------------
User Function IMPQUOTE(oXml,oSfInLy, oModelIn)
	Local cAliasQt		as character
	Local cMsgError     as character  //Mensagem de erro
	Local aCabec        as array      //Vetor com as informações do cabeçalho para realizar execauto de orçamento
	Local aItens        as array      //Vetor com as informações dos itens para realizar execauto de orçamento
	Local aLinha        as array      //Vetor auxiliar com as informações do item
	Local cDoc          as character  //Numero do orçamento
	Local lOk           as logical    //Sucesso no processamento
	local cArqLog       as character  //Arquivo de log do mostraerro
	local cLogPath      as character  //Pasta para gravacao do log de erro pela funcao Mostraerro().
	Local nItem       	as numeric    //Indice de navagação nos itens do orçamento.
	Local nItens		as numeric    //Indice de navagação nos itens do orçamento.
	Local aAttach :={}

	private lMsErroAuto as logical    //Variável que indica se ocorreu erro no execauto do FINA460
	private lMsHelpAuto as logical    //Variável interna do execauto
	private oCabec      as object     //Objeto XML do cabeçalho do orçamento
	private oItens      as object     //Objeto XML dos itens do orçamento
	private nInd        as numeric    //Indice de navegação no model de layout de integração
	private xValue
	private oXmlPrv     as object
	Private cQuote		as character
	Private cTO := ""
	Private cCC := ""
	Private cBcc := 'junior.gardel@gmail.com'
	Private cCliQuote as character
	Private cLojQuote as character
	Private cObs := ""
	Private cList as character
	Private cB1Cod as character
	Private nVlrTab := 0
	Private cCodTab := " "

	//-----------------------------------------------
	//Inicialização de variáveis
	//-----------------------------------------------
	cArqLog      := ""
	cLogPath     := SuperGetMV("MV_LOGPATH",,"logs")
	lMsErroAuto  := .F.
	lMsHelpAuto  := .T.
	cRootXml     := alltrim(oSfInLy:getValue("ZNQMASTER", "ZNQ_ROOT"))
	cHeader      := alltrim(oSfInLy:getValue("ZNQMASTER", "ZNQ_HEAD"))
	cLines       := alltrim(oSfInLy:getValue("ZNQMASTER", "ZNQ_ITENS"))
	cMsgError    := ""
	aCabec       := {}
	aItens       := {}
	aLinha       := {}
	cDoc         := ""
	lOk          := .T.
	oXmlPrv      := oXml
	oCabec       := XmlChildEx(&("oXmlPrv:"+cRootXml), cHeader) // pega o 5º elemento a partir do elemento PEDIDO, o conteúdo da tag "Itens"
	oItens       := XmlChildEx(&("oXmlPrv:"+cRootXml), cLines )
	lMsErroAuto  := .F.
	cFilOut := cfilant

	if cEmpAnt  == '01'

		cShipFrom := ALLTRIM(oCabec:_SHIPFROM:TEXT)

		IF !EMPTY(cShipFrom)

			cShipFrom := substr(cShipFrom,2,2)

			cShipFrom := iif(cShipFrom == '01','02',cShipFrom )

			cfilant := cShipFrom

		ENDIF

	ENDIF

	cQuote := ALLTRIM(oCabec:_NAME:TEXT)
	cTO := ALLTRIM(oCabec:_SalesRepEmail:TEXT)

	IF  valtype(oItens)  <> "O"
		cSubject := "Erro na estrutura da Quote "+cQuote
		cMsgError := cSubject + ". Não há itens no XML."
		U_ENVMAILIMCD( cTO,cCc,cBcc,cSubject,cMsgError,{})
		LOK := .F.
	ELSE

		//dap =  CIF / EXW - FOB OUTROS CIF
		cDoc         := GetSxeNum("SCJ","CJ_NUM")

		rollbackSx8()
		//------------------------------------------------------
		//Verifica a quantidade de registros da tabela de layout
		//------------------------------------------------------
		nTamLy := oSfInLy:getModel("ZNQDETAIL"):length()

		//-----------------------------------------------------------
		//Realiza a leitura da estrutura XML e alimenta o array
		//de cabeçalho para o execauto do orçamento.
		//-----------------------------------------------------------
		nInd := 1

		aadd(aCabec,{"CJ_NUM"   ,cDoc,Nil})

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))

		dbSelectArea("SED")
		SED->(dbSetOrder(1))

		dbSelectArea("SE4")
		SE4->(dbSetOrder(1))

		cInterCom := UPPER(OCABEC:_INTERNALCOMMENTS:TEXT)
		nPos = (AT('#ORC',cInterCom)+4)
		cNumOrc := IIF(nPos > 4, substr(cInterCom,nPos,6),'')

		if !EMPTY(cNumOrc)
			cSubject := "INTEGRAÇÃO QUOTE "+cQuote+" X  ORÇAMENTO "+cNumOrc

			dbSelectArea("SCJ")
			dbSetOrder(1)
			IF MsSeek(xFilial("SCJ")+cNumOrc)
				RecLock("SCJ", .F.)
				SCJ->CJ_QUOTESF 	:= cQuote
				MSUnlock()

				cMSgError := '<p>A quote <span style="color: #0000ff;">'+cQuote+'</span> '
				cMSgError += 'foi associada ao Or&ccedil;amento <span style="color: #0000ff;">'+cNumOrc+'</span> já exisitante</p>'

				U_ENVMAILIMCD( cTo,cCc,cBcc,cSubject,cMSgError,{})
			ELSE
				cMSgError := '<p>O Orçamento <span style="color: #0000ff;">'+cQuote+'</span>, informado '
				cMSgError +='<p>na quote <span style="color: #0000ff;">'+cQuote+'</span> não foi Localizado.<p>''

				U_ENVMAILIMCD( cTo,cCc,cBcc,cSubject,cMSgError,{})

			ENDIF

		else
			cMSgError := ''
			if !EMPTY(cQuote)
				cAliasQt := getNextAlias()
				beginSql alias cAliasQt
            SELECT CJ_NUM,  CJ_QUOTESF FROM %table:SCJ% SCJ
            WHERE SCJ.%notDel%  AND CJ_QUOTESF = %Exp:cQuote%   
				endSql

				while (cAliasQt)->(!eof())

					cMsgError += "A Quote:"+(cAliasQt)->CJ_QUOTESF+", já foi integrada. Orçamento: "+(cAliasQt)->CJ_NUM+ CRLF
					lOk := .F.
					(cAliasQt)->(dbSkip())
				enddo
				(cAliasQt)->(dbCloseArea())
			ENDIF

			if lOk
				while nInd <= nTamLy .and. lOk
					oSfInLy:getModel('ZNQDETAIL'):goLine(nInd)
					if oSfInLy:getValue("ZNQDETAIL", "ZNQ_TYPE") == 'H'

						//----------------------------------
						//Validação específica para cliente/
						//condição pagamento/natureza
						//----------------------------------
						if "_ACCOUNTINTEGRATIONID" $ oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPSF")

							cA1Cod :=  Substr(oCabec:_ACCOUNTINTEGRATIONID:TEXT,1,6)
							cA1Loja :=  Substr(oCabec:_ACCOUNTINTEGRATIONID:TEXT,7,2)
							If SA1->(! MsSeek(xFilial("SA1") + cA1Cod + cA1Loja))
								cMsgError += "Cadastrar o Cliente: " + cA1Cod + " Loja: " + cA1Loja + CRLF
								lOk     := .F.
							EndIf
							cCliQuote := cA1Cod
							cLojQuote := cA1Loja
							if lOk
								cE4Codigo := IIF(!EMPTY(SA1->A1_COND),SA1->A1_COND,'001')
								If SE4->(! MsSeek(xFilial("SE4") + cE4Codigo))
									cMsgError += "Cadastrar a Condição de Pagamento: " + cE4Codigo + CRLF
									lOk     := .F.
								EndIf
							endif

							if lOk
								cEDNat := IIF(!EMPTY(SA1->A1_NATUREZ),SA1->A1_NATUREZ,'')
								If SED->(! MsSeek(xFilial("SED") + cEDNat))
									cMsgError += "Cadastrar a Natureza: " + cEDNat + CRLF
									lOk     := .F.
								EndIf
							endif
							if lOk
								aadd(aCabec,{"CJ_CLIENTE",cA1Cod,Nil})
								aadd(aCabec,{"CJ_LOJACLI",cA1Loja,Nil})
								aadd(aCabec,{"CJ_CLIENT",cA1Cod,Nil})
								aadd(aCabec,{"CJ_LOJAENT",cA1Loja,Nil})
								aadd(aCabec,{"CJ_CONDPAG",cE4Codigo,Nil})
								aadd(aCabec,{"CJ_XVEND",SA1->A1_VEND,Nil})
								aadd(aCabec,{"CJ_XTRANSP",SA1->A1_TRANSP,Nil})

							endif
						else
							if !empty(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPSF"))
								xValue := &("oCabec:"+alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPSF"))+":TEXT")
							endif
							cForm   := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_FORM1"))
							cColumn := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT"))
							cValid  := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CONDIC"))

							//--------------------------------------------------
							//Aplica a função que está dentro do campo ZNU_FORM1
							//--------------------------------------------------
							if !empty(cForm)
								xValue := &(cForm)
							endif

							//--------------------------------------
							//Realiza validação informada no campo
							//--------------------------------------
							if !empty(cValid)
								if ! &(cValid)
									cMsgError += "Erro na validação do campo: "+cColumn+". Verifique se o campo está preenchido corretamente."+ CRLF
									lOk := .F.
								endif
							endif

							if lOk
								aadd(aCabec,{cColumn ,xValue,Nil})
								//DDATABASE := IIF(cColumn = 'CJ_EMISSAO',xValue, DDATABASE)
							endif
						endif
					endif
					nInd++
				enddo
				//-----------------------------------------------------------
				//Realiza a leitura da estrutura XML e alimenta o array
				//de itens para o execauto do orçamento.
				//-----------------------------------------------------------

				aItens := {}
				if valtype(oItens:_QUOTELINE) == 'A'
					nItens     := Len(oItens:_QUOTELINE)
					cItensRoot := "_QUOTELINE[nitem]:"
				else
					nItens := 1
					cItensRoot := "_QUOTELINE:"
				endif

				nInd := 1

				For nItem := 1  to nItens

					aLinha :={}
					nInd := 1

					aadd(aLinha,{"CK_ITEM",StrZero(nItem,tamSx3("CK_ITEM")[1]),Nil})

					while nInd <= nTamLy .and. lOk

						oSfInLy:getModel('ZNQDETAIL'):goLine(nInd)

						if oSfInLy:getValue("ZNQDETAIL", "ZNQ_TYPE") == 'I'
							//---------------------------------------------
							//Validação específica para codigo de produto
							//---------------------------------------------
							if "_PRODUCTFULLSEGMENTSNUMBER" $ oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPSF")
								lOk :=  BUSCATAB(aCabec, aLinha, nItem, @nVlrTab ,@cMsgError)
							else

								if !empty(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPSF"))
									xValue := &("oItens:"+alltrim(cItensRoot+oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPSF"))+":TEXT")
								endif

								cForm   := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_FORM1"))
								cColumn := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT"))
								cValid  := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CONDIC"))

								//--------------------------------------------------
								//Aplica a função que está dentro do campo ZNU_FORM1
								//--------------------------------------------------
								if !empty(cForm)
									xValue := &(cForm)
								endif

								if cColumn = 'CK_XVLRINF' .and. xValue == 0
									xValue := nVlrTab
									cObs := 'O Valor informado foi alterado de 0 para '+cValToChar(xValue)
									cObs += CRLF+'Valor extraido da Tabela de Preço.'+CRLF
								Endif

								//--------------------------------------
								//Realiza validação informada no campo
								//--------------------------------------
								if !empty(cValid)
									if !&(cValid)

										if cColumn == 'CK_XMOEDA'
											cMsgError +="Taxa da Moeda não Cadastrada. Verifique se o valor da Moeda está preenchido corretamente para o Dia "+DTOC(dDataBase)+ CRLF
										else
											cMsgError +="Erro na validação do campo: "+cColumn+". Verifique se o campo está preenchido corretamente."+ CRLF
										endif
										lOk := .F.
									endif
								endif

								if lOk
									aadd(aLinha,{cColumn ,xValue,Nil})
								endif

							endif
						endif
						nInd++
					enddo

					aadd(aItens,aLinha)

				Next nItem
			ENDIF

			if lOk
				//-----------------------------------------------------------
				//Realiza execauto de orçamento.
				//-----------------------------------------------------------
				if !empty(aCabec) .and. !empty(aItens)

					cSubject := "INTEGRAÇÃO QUOTE "+cQuote
					cBody :=""
					aAttach :={}

					MSExecAuto({|x,y,z| MATA415(x,y,z)},aCabec,aItens,3)

					If lMsErroAuto
						//Mensagem de erro do execauto
						cArqLog   := GetNextAlias()+".log"
						cMsgError  := MostraErro(cLogPath,cArqLog)

						//Apaga o arquivo de LOG.
						if file(cLogPath+"\"+cArqLog)
							FErase(cLogPath+"\"+cArqLog)
						endif
						cSubject := "ERRO - "+cSubject

						cBody := COMPLMSG(cMsgError)  //STRTRAN(cMsgError,CHR(13)+CHR(10), "</BR>")

						//aAdd(aAttach,cLogPath+"\"+cArqLog)
						U_ENVMAILIMCD(cTO,cCc,cBcc, cSubject,cBody,{})

						lOk := .F.
					else
						oModelIn:getModel("ZNSDETAIL"):goLine(1)
						oModelIn:setValue("ZNSDETAIL", "ZNS_CHAVE", cDoc)
						cSubject += " X  ORÇAMENTO "+cDoc
						cBody := "ARQUIVO INTEGRADO COM SUCESSO. "+ cSubject
						cBody += cObs
						U_ENVMAILIMCD(cTO,cCc,cBcc, cSubject,cBody ,aAttach)

						LimparOPER(cDoc)
					Endif

				endif

			else
				cBody := cMsgError
				cSubject := "ERRO INTEGRAÇÃO QUOTE "+cQuote
				U_ENVMAILIMCD(cTO,cCc,cBcc, cSubject,cBody,aAttach)

			endif

		ENDIF
	ENDIF
	aSize(aItens,0)
	aSize(aLinha,0)
	aSize(aCabec,0)

	if cEmpAnt == '01'
		cfilant := cFilOut
	Endif

Return { lOk, cMsgError}


Static Function BUSCATAB(aCabec, aLinha, nItem, nVlrTab, cMsgError)
	Local lOk := .T.
	Local lTabAtiva := .F.
	Local cMoeda := ""
	Local cCurrencyCod := ""

	cList := PADR(UPPER(oCabec:_lob1:TEXT), tamSx3("ACY_XDESC")[1])
	cB1Cod :=   " "

	cB1Cod := &("oItens:"+cItensRoot+"_PRODUCTFULLSEGMENTSNUMBER:TEXT")
	cB1Cod := alltrim(SUBSTR(cB1Cod,1,AT("__", cB1Cod) -1))

	cCurrencyCod := &("oItens:"+cItensRoot+"_CurrencyIsocode:TEXT")

	If SB1->(! MsSeek(xFilial("SB1") + cB1Cod))
		cMsgError += "Cadastrar o Produto: " + cB1Cod + CRLF
		lOk     := .F.
	EndIf
	aadd(aLinha,{"CK_PRODUTO",cB1Cod,Nil})

	if SB1->B1_SEGMENT = '000035'
		cList := 'PIGMENTS'
	endif

	dbSelectArea("ACY")
	DBOrderNickname("LOB1")
	if ACY->(dbSeek(xFilial("ACY")+cList))
		cCodTab := ACY->ACY_CODTAB
		aadd(aCabec,{"CJ_TABELA", cCodTab  ,Nil})
	ELSE
		cMsgError += "Tabela de preço não encontrada [ "+cList + " ] " + CRLF
		lOk     := .F.
	ENDIF

	IF lOk
		dbSelectArea("DA1")
		DA1->(dbSetOrder(1))
		IF  DA1->(dbSeek(xFilial("DA1") + cCodTab + cB1Cod))
			WHILE ( rtrim(DA1->(DA1_FILIAL + DA1_CODTAB + DA1_CODPRO)) ==  xFilial("DA1") + cCodTab + cB1Cod )
				IF DA1->DA1_ATIVO == '1' .AND. !lTabAtiva
					nVlrTab := DA1->DA1_PRCVEN
					lTabAtiva := .T.

					DO CASE
					CASE DA1->DA1_MOEDA = 1 //REAL
						cMoeda := 'BRL'
					CASE DA1->DA1_MOEDA = 2  //DOLAR
						cMoeda := 'USD'
					CASE DA1->DA1_MOEDA = 3  //UFIR
						cMoeda := 'UFIR'
					CASE DA1->DA1_MOEDA = 4 //EURO
						cMoeda := 'EUR'
					CASE DA1->DA1_MOEDA = 5 //DOLAR CANADENSE
						cMoeda := 'CAD'
					CASE DA1->DA1_MOEDA = 6 // LIBRA
						cMoeda := 'GBP'
					CASE DA1->DA1_MOEDA = 7 //FRANCO SUICO
						cMoeda := 'CHF'
					ENDCASE

				ENDIF
				DA1->(dbSkip())
			ENDDO
			IF !lTabAtiva
				cMsgError := "Tabela de preço [ "+cCodTab+" - "+cList + " ] Inativa para o Produto "+cB1Cod
				lOk := .F.
			ENDIF

			IF cCurrencyCod <> cMoeda
				cMsgError := "Moeda Divergente.<br>"
				cMsgError += "A Quote foi criada com a Moeda "+cCurrencyCod+".<br>"
				cMsgError += "E na Tabela de preço [ "+cCodTab+" ], está com a Moeda "+cMoeda+"."
				lOk := .F.
			ENDIF

		ELSE
			cMsgError :="Produto "+cB1Cod+ "não encontrado na Tabela de preço [ "+cCodTab+" - "+cList + " ] "
			lOk := .F.
		ENDIF

	ENDIF

RETURN lOk

Static Function COMPLMSG(cMsgError)

	Local cMensagem := ' '

	cMensagem :='<!DOCTYPE html>'

	cMensagem += '<html lang="pt" dir="ltr">'

	cMensagem +='<head>'

	cMensagem +='</head>'
	cMensagem +='<body>'

	cMensagem +='<textarea id="story" name="story"  rows="30" cols="150">

	cMensagem +=cMsgError

	cMensagem +='</textarea>'

	cMensagem +='</body>'
	cMensagem +='</html>'

Return(cMensagem)


 /*/{Protheus.doc} nomeFunction
	(long_description)
	@type  Function
	@author user
	@since 20/05/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example

	dbSelectArea cDoc

	(examples)
	@see (links_or_references)
	/*/
Static Function LimparOPER(cDoc)
	Local cQuery := ""

	if !Empty(cDoc)
		cQuery := "UPDATE " + RetSQLName( "SCK" )
		cQuery += " SET CK_XOPER = ' ', CK_TES = ' ' "
		cQuery += " WHERE CK_FILIAL = '"+cfilant+"' "
		cQuery += " AND CK_NUM = '"+cDoc+"'
		cQuery += " AND D_E_L_E_T_ = ' ' "
		TCSQLExec( cQuery )
		TcRefresh( 'SCK' )

		SCK->( dbCommit() )
	Endif

Return()
