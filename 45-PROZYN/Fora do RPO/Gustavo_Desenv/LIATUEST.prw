#Include "Protheus.ch"
#Include "TBICONN.ch"

/*/{Protheus.doc} LIATUEST
	Atualização de estoque dos produtos que contenham ID de produto da Loja Integrada na tabela SB5, via API.
	@type  Function
	@author Gustavo Gonzalez
	@since 02/09/2021
	/*/
User Function LIATUEST()
	Local oPut
	Local aHeadApi  	:= {}
	Local cBody			:= ''
	Local cEmpDef 		:= '01'
	Local cFilDef		:= '01'
	Local cIdProd 	 	:= ''
	Local cSaldo		:= ''
	Local cRespJSON		:= ''
	Local cQryEst		:= ''

	//Abre o Ambiente
	RPCSetType(3)
	RpcSetEnv ( cEmpDef, cFilDef)

	//Variáveis da Rotina.
	cChaveApi 	:= SuperGetMv( "LI_CHVAPI",.F.,'9794926de07a525e82db')					// Chave API gerada no site da Loja Integrada.
	cChaveApl 	:= SuperGetMv( "LI_CHVAPL",.F.,'759ba53c-c076-4f32-8646-95d1c75afe94')	// Chave Aplicação gerada via chamado.
	cEndpoint	:= SuperGetMv( "LI_ENDPOI",.F.,'https://api.awsli.com.br')				// Ambiente a ser passado como parametros para acesso à API da Loja Integrada
	cArmazem	:= SuperGetMv( "LI_LOCAL" ,.F.,"06")									// Armazém utilizado para enviar o estoque.

	//Monta Array do Cabecalho
	Aadd( aHeadApi	, 'Content-Type: application/json' )
	Aadd( aHeadApi	, 'Authorization: chave_api ' + cChaveApi + ' aplicacao ' + cChaveApl )

	//Verifica se a tabela auxiliar está aberta
	If Select("QryEst") > 0
		("QryEst")->(DbCloseArea())
	Endif

	cQryEst	:= " SELECT B2_COD CODIGO, B2_LOCAL CODARM, SUM(B2_QATU)-(B2_QACLASS+B2_RESERVA+B2_QEMP+B2_QPEDVEN) AS SALDOS , B5_LIID AS IDPROD"
	cQryEst	+= " FROM "+RetSqlName("SB2")+" B2 "
	cQryEst	+= " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.B1_COD = B2.B2_COD "
	cQryEst	+= " INNER JOIN "+RetSqlName("SB5")+" B5 ON B1.B1_COD = B5.B5_COD "
	cQryEst	+= " WHERE B1.D_E_L_E_T_ = ' ' AND B2.D_E_L_E_T_ = ' ' AND B5.D_E_L_E_T_ = ' '"
	cQryEst	+= " AND B1.B1_MSBLQL = '2' "
	cQryEst	+= " AND B5.B5_LI = 'S' "
	cQryEst	+= " AND B2.B2_LOCAL = '" + cArmazem + "' "
	cQryEst	+= " GROUP BY B2_COD, B5_LIID, B2_LOCAL, B2_QACLASS, B2_RESERVA, B2_QEMP, B2_QPEDVEN "
	cQryEst	+= " ORDER BY B2_COD "

	MemoWrite("\LOJAINTEGRADA\LIATUEST.TXT",cQryEst)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryEst), "QryEst",.F.,.T.)

	If ("QryEst")->(Eof())
		MsgAlert("Não ha dados para o processamento...")
		Return
	Endif

	("QryEst")->(DbGoTop())
	Conout("Iniciando atualizacao de Estoque na Loja Integrada:")
	While ("QryEst")->(!Eof())
		cIdProd		:= Alltrim(("QryEst")->IDPROD)
		cSaldo		:= IIF(("QryEst")->SALDOS < 0, "0",Alltrim(Str(("QryEst")->SALDOS,5)))
		cBody		:= '{'
		cBody		+= '	"gerenciado": true,'
		cBody		+= '	"quantidade": ' + cSaldo
		cBody		+= '}'

		//Execucao do envio do saldo para a Loja Integrada via Put
		oPut := FWRest():New(cEndpoint)
		oPut:SetPath('/v1/produto_estoque/' + cIdProd)
		oPut:Put(aHeadApi, cBody)
		cRespJSON := oPut:GetResult()

		If !('200' $ oPut:oResponseH:cStatusCode)
			Conout("Produto NAO atualizado: " + cIdProd + " / Motivo: " + oPut:GetLastError())
		Else
			Conout('Produto atualizado: '+ cIdProd + ' / Saldo: ' + cSaldo )
		EndIf
		("QryEst")->(DbSkip())
	EndDo
	Conout("Fim da atualizacao de Estoque na Loja Integrada.")

	RpcClearEnv()

Return Nil
