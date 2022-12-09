#Include "Protheus.ch"
#Include "TBICONN.ch"

/*/{Protheus.doc} LIATUPRE
	Atualização de preço dos produtos que contenham ID de produto da Loja Integrada na tabela SB5, via API.
	@type  Function
	@author Gustavo Gonzalez
	@since 02/09/2021
	/*/
User Function LIATUPRE()
	Local oPut
	Local aHeadApi  	:= {}
	Local cBody			:= ''
	Local cEmpDef 		:= '01'
	Local cFilDef		:= '01'
	Local cIdProd 	 	:= ''
	Local cPreco		:= ''
	Local cRespJSON		:= ''
	Local cQryEst		:= ''

	//Abre o Ambiente
	RPCSetType(3)
	RpcSetEnv ( cEmpDef, cFilDef)

	//Variáveis da Rotina.
	cChaveApi 	:= SuperGetMv( "LI_CHVAPI",.F.,'9794926de07a525e82db')					// Chave API gerada no site da Loja Integrada.
	cChaveApl 	:= SuperGetMv( "LI_CHVAPL",.F.,'759ba53c-c076-4f32-8646-95d1c75afe94')	// Chave Aplicação gerada via chamado.
	cEndpoint	:= SuperGetMv( "LI_ENDPOI",.F.,'https://api.awsli.com.br')				// Ambiente a ser passado como parametros para acesso à API da Loja Integrada
	cTabela	  	:= SuperGetMv( "LI_TABPRE",.F.,"ARV")									// Tabela utilizada para enviar o preço.

	//Monta Array do Cabecalho
	Aadd( aHeadApi	, 'Content-Type: application/json' )
	Aadd( aHeadApi	, 'Authorization: chave_api ' + cChaveApi + ' aplicacao ' + cChaveApl )

	//Verifica se a tabela auxiliar está aberta
	If Select("QryEst") > 0
		("QryEst")->(DbCloseArea())
	Endif

	cQryEst	:= " SELECT	"
	cQryEst	+= "    SB1.B1_COD AS PRODUTO, "
	cQryEst	+= "    DA1.DA1_PRCVEN PRECO, "
	cQryEst	+= "    SB5.B5_LIID IDPROD "
	cQryEst	+= "	FROM
	cQryEst	+= "		" + RetSqlName("SB1") + " SB1 "
	cQryEst	+= "		JOIN " + RetSqlName("SB5") + " SB5 ON SB5.D_E_L_E_T_ = '' AND B5_COD = B1_COD "
	cQryEst	+= "		JOIN " + RetSqlName("DA1") + " DA1 ON DA1.D_E_L_E_T_ = '' AND DA1_CODPRO = B1_COD  AND DA1_CODTAB = '" + cTabela + "'"
	cQryEst	+= "	WHERE "
	cQryEst	+= "		SB1.B1_MSBLQL <> '1' AND SB1.D_E_L_E_T_ = '' "
	cQryEst	+= "		AND SB5.B5_LI = 'S' "
	cQryEst	+= "		ORDER BY SB1.B1_COD"

	MemoWrite("\LOJAINTEGRADA\LIATUPRE.TXT",cQryEst)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryEst), "QryEst",.F.,.T.)

	If ("QryEst")->(Eof())
		MsgAlert("Não ha dados para o processamento...")
		Return
	Endif

	("QryEst")->(DbGoTop())
	Conout("Iniciando atualizacao de Estoque na Loja Integrada:")
	While ("QryEst")->(!Eof())
		cIdProd		:= Alltrim(("QryEst")->IDPROD)
		cPreco		:= Alltrim(Str(("QryEst")->PRECO))
		cBody		:= '{'
		cBody		+= '	"cheio": ' + cPreco
		cBody		+= '}'

		//Execucao do envio do preço para a Loja Integrada via Put
		oPut := FWRest():New(cEndpoint)
		oPut:SetPath('/v1/produto_preco/' + cIdProd)
		oPut:Put(aHeadApi, cBody)
		cRespJSON := oPut:GetResult()

		If !('200' $ oPut:oResponseH:cStatusCode)
			Conout("Produto NAO atualizado: " + cIdProd + " / Motivo: " + oPut:GetLastError())
		Else
			Conout('Produto atualizado: '+ cIdProd + ' / Preco: ' + cPreco )
		EndIf
		("QryEst")->(DbSkip())
	EndDo
	Conout("Fim da atualizacao de Preco na Loja Integrada.")

	RpcClearEnv()
Return Nil
