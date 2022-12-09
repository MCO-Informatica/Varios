#Include "Protheus.ch"
#Include "TcBrowse.ch"
#Include "TopConn.ch"
#Include "Totvs.ch"
#include "fileio.ch"
#Include "TBICONN.ch"

/*/{Protheus.doc} LIPEDIDOS
Lista os pedidos com pagamento aprovado na Loja Integrada e importa para o Protheus.
@type  Function
@author Gustavo Gonzalez
@since 10/09/2021
/*/
User Function LIPEDIDOS()
	Local cEmpDef 	:= '01'
	Local cFilDef	:= '01'
	Local cPedsJson	:= ''
	Local nX


	Private oObjJson
	Private aHeadApi  	:= {}
	Private cErr 		:= ''
	Private nTimeOut	:= 120
	Private cHeadRet	:= ''
	Private cCodCli		:= ''
	Private cLoja		:= ''
	Private lCliOk		:= .F.
	Private aCompara	:= {}

	//Abre o Ambiente
	RPCSetType(3)
	RpcSetEnv ( cEmpDef, cFilDef)

	//Variáveis da Rotina.
	cChaveApi 	:= SuperGetMv( "LI_CHVAPI",.F.,'9794926de07a525e82db')					// Chave API gerada no site da Loja Integrada.
	cChaveApl 	:= SuperGetMv( "LI_CHVAPL",.F.,'759ba53c-c076-4f32-8646-95d1c75afe94')	// Chave Aplicação gerada via chamado.
	cEndpoint	:= SuperGetMv( "LI_ENDPOI",.F.,'https://api.awsli.com.br')				// Ambiente a ser passado como parametros para acesso à API da Loja Integrada

	//Monta Array do Cabecalho
	Aadd( aHeadApi	, 'Content-Type: application/json' )
	Aadd( aHeadApi	, 'Authorization: chave_api ' + cChaveApi + ' aplicacao ' + cChaveApl )

	//Lista os pedidos em aberto (Situação 4)
	cURLParam	:= '/v1/pedido/search/?situacao_id=4'
	cPedsJson  	:= HttpGet(cEndpoint+cURLParam, "", nTimeOut, aHeadApi, @cHeadRet )
	cErr		:= Substr(cHeadRet,10,3)
	cPedsJson	:= DecodeUTF8(cPedsJson)
	Memowrite('\LOJAINTEGRADA\CPEDSJSON.TXT',cPedsJson)
	FWJsonDeserialize(cPedsJson ,@oObjJson)

	If cErr == "200"
		For nX := 1 to Len(oObjJson:Objects)
			Conout("Loja Integrada -  Pedido na fila: " + Alltrim(Str(oObjJson:Objects[nX]:NUMERO)) + " Status: " + oObjJson:Objects[nX]:SITUACAO:CODIGO)

			//Processa o cadastro de cliente
			LICLIENTE(oObjJson:Objects[nX]:CLIENTE , @cCodcli , @cLoja)

			If lCliOk
				LIPROCPED(oObjJson:Objects[nX]:RESOURCE_URI)
			Else
				Conout("Loja Integrada -  Pedido  " + Alltrim(Str(oObjJson:Objects[nX]:NUMERO)) + " nao foi importado pois o cliente esta INATIVO.")
			EndIf
		Next nX
	EndIf

	Freeobj(oObjJson)
	Conout("Loja Integradas: Processamento da Fila Finalizado")

	RpcClearEnv()
Return


/*/{Protheus.doc} LICLIENTE
Função para criar Cliente vindo da Loja Integrada
/*/
Static Function LICLIENTE(cURLCli,cCodCli,cLoja)
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaCC2	:= CC2->(GetArea())
	Local oObjCli
	Local cCliJson	:= ''
	Local lRet		:= .T.
	Local cCGC		:= ''
	Local aAI0Auto  :=  {}
	Local cBloq		:= ''
	Local lNovo		:= .F.

	cCliJson  	:= HttpGet(cEndpoint+cURLCli, "", nTimeOut, aHeadApi, @cHeadRet )
	cErr		:= Substr(cHeadRet,10,3)
	cCliJson	:= DecodeUTF8(cCliJson)
	Memowrite('\LOJAINTEGRADA\CCLIJSON.TXT',cCliJson)
	FWJsonDeserialize(cCliJson ,@oObjCli)

	//Define CGC e Tipo de Pessoa do cliente.
	cCGC			:= IIf(oObjCli:TIPO == 'PF',oObjCli:CPF,oObjCli:CNPJ)
	cTpPessoa		:= IIF(oObjCli:TIPO == 'PF',"F","J")

	If cErr == "200"
		//Grava dados do cliente na tabela Temporária ZZQ
		DBSelectArea("ZZQ")
		ZZQ->(DBSetOrder(1))
		ZZQ->(DBGotop())

		If ZZQ->(DbSeek(xFilial("ZZQ") + cCGC))
			Reclock("ZZQ",.F.) //Alteração
			Conout("Loja Integrada -  Cliente " + cCGC + " " + FWnoAccent(oObjCli:NOME) + " ja existe na ZZQ, ira alterar.")
		Else
			Reclock("ZZQ",.T.) //Inclusão
			Conout("Loja Integrada -  Cliente " + cCGC + " " + FWnoAccent(oObjCli:NOME) + " sera incluido.")
		EndIf
		ZZQ->ZZQ_CGC 	:= cCGC
		//Trata Inscrição Estadual
		oObjCli:IE	:= Strtran(oObjCli:IE,'.','')
		oObjCli:IE	:= Strtran(oObjCli:IE,'-','')
		ZZQ->ZZQ_IE 	:= IIf(Empty(oObjCli:IE),'ISENTO',UPPER(oObjCli:IE))
		ZZQ->ZZQ_PESSOA	:= cTpPessoa
		ZZQ->ZZQ_NOME	:= IIf(Empty(oObjCli:NOME),'',FWNOACCENT(UPPER(oObjCli:NOME)))
		ZZQ->ZZQ_RAZAO	:= IIf(Empty(oObjCli:RAZAO_SOCIAL),FWNOACCENT(UPPER(oObjCli:NOME)),FWNOACCENT(UPPER(oObjCli:RAZAO_SOCIAL)))
		ZZQ->ZZQ_GENERO	:= IIf(Empty(oObjCli:SEXO),'',UPPER(oObjCli:SEXO))
		ZZQ->ZZQ_DTNASC	:= IIf(Empty(oObjCli:DATA_NASCIMENTO),STOD(''),STOD(STRTRAN(oObjCli:DATA_NASCIMENTO,"-","")))
		ZZQ->ZZQ_EMAIL	:= IIf(Empty(oObjCli:EMAIL),'',FWNOACCENT(oObjCli:EMAIL))
		If Empty(oObjCli:TELEFONE_PRINCIPAL)
			ZZQ->ZZQ_DDD1 := ''
			ZZQ->ZZQ_TEL1 := ''
		Else
			ZZQ->ZZQ_DDD1 := Substr(oObjCli:TELEFONE_PRINCIPAL,1,2)
			ZZQ->ZZQ_TEL1 := Substr(oObjCli:TELEFONE_PRINCIPAL,3)
		EndIf

		If Empty(oObjCli:TELEFONE_CELULAR)
			ZZQ->ZZQ_DDD2 := ''
			ZZQ->ZZQ_TEL2 := ''
		Else
			ZZQ->ZZQ_DDD2 := Substr(oObjCli:TELEFONE_CELULAR,1,2)
			ZZQ->ZZQ_TEL2 := Substr(oObjCli:TELEFONE_CELULAR,3)
		EndIf

		If Empty(oObjCli:TELEFONE_COMERCIAL)
			ZZQ->ZZQ_DDD3 := ''
			ZZQ->ZZQ_TEL3 := ''
		Else
			ZZQ->ZZQ_DDD3 := Substr(oObjCli:TELEFONE_COMERCIAL,1,2)
			ZZQ->ZZQ_TEL3 := Substr(oObjCli:TELEFONE_COMERCIAL,3)
		EndIf

		//PONTO DE ATENÇÃO ENTRE O ENDEREÇO DE ENTREGA E DE FATURAMENTO, CHECAR COM A LOJA INTEGRADA
		ZZQ->ZZQ_END	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:ENDERECO + IIF(!Empty(oObjCli:ENDERECOS[1]:NUMERO), ', ' + oObjCli:ENDERECOS[1]:NUMERO, '')))
		ZZQ->ZZQ_COMPLE	:= IIf(Empty(oObjCli:ENDERECOS[1]:COMPLEMENTO),'',FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:COMPLEMENTO)))
		ZZQ->ZZQ_EST	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:ESTADO))
		ZZQ->ZZQ_COD_MU	:= POSICIONE("CC2",4,"  " + oObjCli:ENDERECOS[1]:ESTADO + FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:CIDADE)),"CC2_CODMUN")
		ZZQ->ZZQ_MUN	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:CIDADE))
		ZZQ->ZZQ_BAIRRO	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:BAIRRO))
		ZZQ->ZZQ_CEP	:= STRTRAN(oObjCli:ENDERECOS[1]:CEP,"-","")
		ZZQ->ZZQ_OBS	:= IIf(Empty(oObjCli:ENDERECOS[1]:REFERENCIA),'',FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:REFERENCIA)))

		ZZQ->ZZQ_ENDE	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:ENDERECO + IIF(!Empty(oObjCli:ENDERECOS[1]:NUMERO), ', ' + oObjCli:ENDERECOS[1]:NUMERO, '')))
		ZZQ->ZZQ_COMPEN	:= IIf(Empty(oObjCli:ENDERECOS[1]:COMPLEMENTO),'',FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:COMPLEMENTO)))
		ZZQ->ZZQ_ESTE	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:ESTADO))
		ZZQ->ZZQ_COD_ME	:= POSICIONE("CC2",4,"  " + oObjCli:ENDERECOS[1]:ESTADO + FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:CIDADE)),"CC2_CODMUN")
		ZZQ->ZZQ_MUNE	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:CIDADE))
		ZZQ->ZZQ_BAIRRE	:= FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:BAIRRO))
		ZZQ->ZZQ_CEPE	:= STRTRAN(oObjCli:ENDERECOS[1]:CEP,"-","")
		ZZQ->ZZQ_OBSE	:= IIf(Empty(oObjCli:ENDERECOS[1]:REFERENCIA),'',FWNOACCENT(UPPER(oObjCli:ENDERECOS[1]:REFERENCIA)))

		MsUnlock()

		//Verifica se o cadastro de cliente já existe e se deve ser bloqueado.
		DBSelectArea('SA1')
		SA1->(DBSetOrder(3))
		SA1->(DBGoTop())

		If SA1->(DbSeek(xFilial("SA1") + cCGC))
			If SA1->A1_MSBLQL == '1'
				lCliOk	:= .F.
				Return
			Else
				nUpdate		:= 4
				cCodCli		:= SA1->A1_COD
				cLoja		:= SA1->A1_LOJA
				If Empty(SA1->A1_LIID)
					cBloq	:= '1'
					lCliOk	:= .F.
				Else
					cBloq	:= '2'
					lCliOk	:= .T.
					//Checar campos alterados.
					COMPARACLI()
				EndIf
			Endif
		Else
			nUpdate		:= 3
			cCodCli		:= GetSxeNum("SA1","A1_COD")
			cLoja		:= '01'
			RollbackSx8()
			cBloq		:= '1'
			lCliOk		:= .F.
			lNovo		:= .T.
		EndIf
	EndIf

	//Gravar dados na tabela SA1
	cGrpTrib	:= IIF(oObjCli:ENDERECOS[1]:ESTADO == "SP","005","006")
	cPfxNreduz	:= ""
	aContato	:= StrTokArr(ZZQ->ZZQ_NOME, " ")
	cDDD1		:= ZZQ->ZZQ_DDD1
	cTel1		:= ZZQ->ZZQ_TEL1
	cDDD2		:= ZZQ->ZZQ_DDD2
	cTel2		:= ZZQ->ZZQ_TEL2
	cDDD3		:= ZZQ->ZZQ_DDD3
	cTel3		:= ZZQ->ZZQ_TEL3

	If lNovo
		cVend		:= "000026"
		cContrib	:= '1'
	Else
		cVend		:= SA1->A1_VEND
		cContrib	:= SA1->A1_CONTRIB
	EndIf


	aSA1Auto:= {	{"A1_FILIAL"	,xFilial("SA1")													, Nil},;
		{"A1_COD"		,cCodCli																	, Nil},;
		{"A1_LOJA"		,cLoja																		, Nil},;
		{"A1_NOME"		,Substr(ZZQ->ZZQ_RAZAO,1,GetSx3Cache('A1_NOME','X3_TAMANHO'))			 	, Nil},;
		{"A1_PESSOA"	,ZZQ->ZZQ_PESSOA															, Nil},;
		{"A1_NREDUZ"	,Substr(cPfxNreduz + ZZQ->ZZQ_NOME,1,GetSx3Cache('A1_NREDUZ','X3_TAMANHO'))	, Nil},;
		{"A1_TIPO"		,"F"																		, Nil},;
		{"A1_PAIS"		,"105"																		, Nil},;
		{"A1_CODPAIS"	,"01058"   																	, Nil},;
		{"A1_EST"		,ZZQ->ZZQ_EST																, Nil},;
		{"A1_COD_MUN"	,ZZQ->ZZQ_COD_MU															,'.T.'},;
		{"A1_END"		,Substr(ZZQ->ZZQ_END,1,GetSx3Cache('A1_END','X3_TAMANHO'))					, Nil},;
		{"A1_MUN"		,Substr(ZZQ->ZZQ_MUN,1,GetSx3Cache('A1_MUN','X3_TAMANHO'))					, Nil},;
		{"A1_BAIRRO"	,Substr(ZZQ->ZZQ_BAIRRO,1,GetSx3Cache('A1_BAIRRO','X3_TAMANHO'))			, Nil},;
		{"A1_CEP"		,ZZQ->ZZQ_CEP																,'.T.'},;
		{"A1_INSCR"		,ZZQ->ZZQ_IE																, Nil},;
		{"A1_DDD"		,cDDD1																		, Nil},;
		{"A1_TEL"		,cTel1																		, Nil},;
		{"A1_TELEX"		,cTel2																		, Nil},;
		{"A1_FAX"		,cTel3																		, Nil},;
		{"A1_CGC"		,ZZQ->ZZQ_CGC																,'.T.'},;
		{"A1_EMAIL"		,Substr(ZZQ->ZZQ_EMAIL,1,GetSx3Cache('A1_EMAIL','X3_TAMANHO'))				, Nil},;
		{"A1_ENDENT"	,Substr(ZZQ->ZZQ_ENDE,1,GetSx3Cache('A1_ENDENT','X3_TAMANHO'))				, Nil},;
		{"A1_COMPENT"	,Substr(ZZQ->ZZQ_COMPEN,1,GetSx3Cache('A1_COMPENT','X3_TAMANHO'))			, Nil},;
		{"A1_MUNE"		,Substr(ZZQ->ZZQ_MUNE,1,GetSx3Cache('A1_MUNE','X3_TAMANHO'))				, Nil},;
		{"A1_BAIRROE"	,Substr(ZZQ->ZZQ_BAIRRE,1,GetSx3Cache('A1_BAIRROE','X3_TAMANHO'))			, Nil},;
		{"A1_ESTE"		,ZZQ->ZZQ_ESTE																, Nil},;
		{"A1_CEPE"		,ZZQ->ZZQ_CEPE																, Nil},;
		{"A1_COMPLEM"	,Substr(ZZQ->ZZQ_COMPLE,1,GetSx3Cache('A1_COMPLEM','X3_TAMANHO'))			, Nil},;
		{"A1_LIID"		,Substr(Alltrim(Str(oObjCli:ID)),1,GetSx3Cache('A1_LIID','X3_TAMANHO'))		, Nil},;
		{"A1_CONTATO"	,Substr(aContato[1],1,GetSx3Cache('A1_CONTATO','X3_TAMANHO'))				, Nil},;
		{"A1_TPFRET"	,"C"   																		, Nil},;
		{"A1_GRPTRIB"	,cGrpTrib																	, Nil},;
		{"A1_SIMPNAC"	,"2"   																		, Nil},;
		{"A1_VEND"		,cVend		   																, Nil},;
		{"A1_CONTRIB"	,cContrib																	, Nil},;
		{"A1_COND"		,"002"   																	, Nil},;
		{"A1_DTCAD"		,dDataBase 																	, Nil},;
		{"A1_HRCAD"		,SUBSTR(TIME(), 1, 5)														, Nil},;
		{"A1_CONTA"		,'1120100101001'															, Nil},;
		{"A1_MSBLQL"	,cBloq																		, Nil},;
		{"A1_DTINIV"	,dDataBase   																, Nil}}

	SA1->(RestArea(aAreaSA1))
	CC2->(RestArea(aAreaCC2))
	lMsHelpAuto	:= .T.
	lMsErroAuto	:= .F.
	MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aSA1Auto, nUpdate, aAI0Auto)
	If lMsErroAuto
		Conout("Loja Integrada - Erro no Execauto do cliente " + cCGC + " " + oObjCli:NOME + " no código " + cCodCli + ".")
		MostraErro("\LOJAINTEGRADA\","SA1_"+dtos(dDatabase)+"_"+StrTran(Time(),":",'')+".txt")
		RollbackSx8()
		lErro	    := .T.
		lRet		:= .F.
		LISENDMAIL(lErro,'CLIENTE')
	Else
		ConfirmSX8()
		//Apaga dados que devem ser revisados manualmente.
		If lNovo
			SA1->(DbSetOrder(3))
			If SA1->(DbSeek(xFilial("SA1") + cCGC))
				SA1->(Reclock("SA1",.F.))
				SA1->A1_VEND 	:= ''
				SA1->A1_CONTRIB	:= ''
				SA1->(MsUnlock())
			EndIf
		EndIf

		Conout("Loja Integrada - Execauto com sucesso, cliente " + cCodCli + " " + cCGC + " " + oObjCli:NOME)

		//Dispara E-Mail informando que o cliente foi criado e precisa ser validado.
		IF cBloq == '1'
			LIMAILCLI()
		EndIf
	Endif
Return lRet


/*/{Protheus.doc} LIPROCPED
Função para processar os pedidos vindos da Loja Integrada
/*/
Static Function LIPROCPED(cUrlPed)
	Local aDetail:= {}
	Local nA
	Local oObjPed
	Local oPut
	Local cPedJson	:= ''
	Local lRet		:= .T.
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaSB5	:= SB5->(GetArea())
	Local cArmazem	:= SuperGetMv( "LI_LOCAL" ,.F.,"06")

	cPedJson  	:= HttpGet(cEndpoint+cUrlPed, "", nTimeOut, aHeadApi, @cHeadRet )
	cErr		:= Substr(cHeadRet,10,3)
	cPedJson	:= DecodeUTF8(cPedJson)
	Memowrite('\LOJAINTEGRADA\CPEDJSON.TXT',cPedJson)
	FWJsonDeserialize(cPedJson ,@oObjPed)

	If cErr == "200"
		//Grava dados do pedido na tabela Temporária ZZR e SSZ
		cPedidoLI	:= FWNOACCENT(Alltrim(Str(oObjPed:NUMERO)))
		cStatusLI	:= FWNOACCENT(oObjPed:SITUACAO:CODIGO)

		DBSelectArea("ZZR")
		ZZR->(DBSetOrder(1))
		ZZR->(DBGotop())
		If ZZR->(DbSeek(xFilial("ZZR") + cPedidoLI))
			ZZR->(Reclock("ZZR",.F.)) //Alteração do Status do Pedido
			ZZR->ZZR_STATUS	:= cStatusLI
			ZZR->(MsUnlock())
			Conout("Loja Integrada - Pedido "+ cPedidoLI + " já importado, status: " + cStatusLI)
		Else
			Conout("Loja Integrada - Novo pedido "+ cPedidoLI + " será importado.")
			ZZR->(Reclock("ZZR",.T.)) //Inclusão de Cabeçalho de Pedido
			ZZR->ZZR_NUM	:= cPedidoLI
			ZZR->ZZR_STATUS	:= cStatusLI
			ZZR->ZZR_CLIENT	:= cCodCli
			ZZR->ZZR_LOJA	:= cLoja
			ZZR->ZZR_TRANSP	:= FWNOACCENT(oObjPed:ENVIOS[1]:FORMA_ENVIO:NOME)
			ZZR->ZZR_FRETE	:= Val(oObjPed:VALOR_ENVIO)
			ZZR->ZZR_METPAG	:= oObjPed:PAGAMENTOS[1]:FORMA_PAGAMENTO:CODIGO
			ZZR->ZZR_PARCEL	:= 0
			ZZR->ZZR_VALOR	:= Val(oObjPed:VALOR_TOTAL)
			ZZR->(MsUnlock())

			DBSelectArea("ZZS") //Inclusão de Itens de Pedido
			For nA := 1 to Len(oObjPed:ITENS)
				ZZS->(Reclock("ZZS",.T.))
				ZZS->ZZS_NUM	:= cPedidoLI
				ZZS->ZZS_ITEM	:= STRZERO(nA,2)
				ZZS->ZZS_PRODUT	:= oObjPed:ITENS[nA]:SKU
				ZZS->ZZS_DESCRI	:= oObjPed:ITENS[nA]:NOME
				ZZS->ZZS_QTDVEN	:= Val(oObjPed:ITENS[nA]:QUANTIDADE)
				ZZS->ZZS_PRCVEN	:= Val(oObjPed:ITENS[nA]:PRECO_VENDA)
				ZZS->ZZS_FRTUNI	:= Round(Val(oObjPed:VALOR_ENVIO)/Len(oObjPed:ITENS),2)
				ZZS->ZZS_OBS	:= ''
				ZZS->(MsUnlock())
			Next nA
		EndIf

		If Alltrim(ZZR->ZZR_STATUS) == 'pedido_pago' .And. (Empty(ZZR->ZZR_PEDC5) .Or. ZZR->ZZR_PEDC5 == '      ')
			//Prepara dados para rodar Execauto de pedido
			cNumPed:= GetSX8Num("SC5","C5_NUM")
			RollbackSx8()
			Conout("Loja Integrada - Pedido "+ cPedidoLI + " será convertido para o Protheus com o número: " + cNumPed)
			cCondPg := '002' //SHCONDPAG(oObjPed)
			cTabela	:= SuperGetMv( "LI_TABPRE",.F.,"APC")
			cMenPed := "PEDIDO VIA LOJA INTEGRADA"
			nPesLiq := 0

			aCabec	:={	{"C5_FILIAL"	,xFilial("SC5")		,Nil},;
				{"C5_NUM"   	,cNumPed       		,Nil},;
				{"C5_TIPO"   	,'N'         		,Nil},;
				{"C5_LIID"		,ZZR->ZZR_NUM		,Nil},;
				{"C5_NUMPCOM"	,"LI#"+ZZR->ZZR_NUM	,Nil},;
				{"C5_CLIENTE"	,ZZR->ZZR_CLIENT	,Nil},;
				{"C5_LOJACLI"	,ZZR->ZZR_LOJA		,Nil},;
				{"C5_CONDPAG"	,cCondPg   			,Nil},;
				{"C5_CLIENT" 	,ZZR->ZZR_CLIENT	,'.T.'},;
				{"C5_LOJAENT"	,ZZR->ZZR_LOJA		,'.T.'},;
				{"C5_EMISSAO"	,dDataBase			,Nil},;
				{"C5_MOEDA"  	,1					,Nil},;
				{"C5_FRETE"  	,ZZR->ZZR_FRETE		,Nil},;
				{"C5_PESOL"  	,nPesLiq 			,Nil},;
				{"C5_VOLUME1"  	,1		  	   		,Nil},;
				{"C5_PBRUTO"  	,nPesLiq 			,Nil},;
				{"C5_FECENT"  	,Date() 			,Nil},; //Checar daqui pra baixo
				{"C5_TRANSP"  	,"000001" 			,Nil},;
				{"C5_TABELA"	,cTabela			,Nil},;
				{"C5_TPFRETE"  	,'C'				,Nil},;
				{"C5_NATUREZ"	,"10202"			,Nil},;
				{"C5_MENNOTA"	,cMenPed  	   		,Nil}}

			ZZS->(DBSetOrder(1))
			ZZS->(DBGotop())
			ZZS->(DbSeek(xFilial("ZZS")+ZZR->ZZR_NUM))

			DBSelectArea('SA7')
			SA7->(DBSetOrder(1))
			While ZZS->(!EOF()) .AND. ZZR->ZZR_NUM == ZZS->ZZS_NUM
				cProduto	:= Alltrim(ZZS->ZZS_PRODUT)
				cUM			:= POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_UM")
				cSegUM		:= POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_SEGUM")
				cEstFat		:= POSICIONE("SA1",1,xFilial("SA1")+ZZR->ZZR_CLIENT+ZZR->ZZR_LOJA,"A1_EST")
				nAliqIpi	:= POSICIONE("SB1",1,xFilial("SB1")+ZZS->ZZS_PRODUT,"B1_IPI")
				//cTesPad		:= If(cEstFat=="SP", If(nAliqIpi>0,'541','520'), If(nAliqIpi>0,'721','720'))
				cTesPad		:= IIF(nAliqIpi > 0,'504','503')//POSICIONE("SB5",1,xFilial("SB5")+cProduto,"B5_TES")
				cCfoPad		:= POSICIONE("SF4",1,xFilial("SF4")+cTesPad,"F4_CF")
				//nVlrUnit	:= ZZS->ZZS_PRCVEN
				//nTotItem	:= ZZS->ZZS_PRCVEN * ZZS->ZZS_QTDVEN
				nVlrUnit2	:= (ZZS->ZZS_PRCVEN * ZZS->ZZS_QTDVEN) + ZZS->ZZS_FRTUNI
				nVlrUnit1	:= nVlrUnit2/(1+nAliqIpi/100)
				nVlrUnit	:= Round((nVlrUnit2-(nVlrUnit2-nVlrUnit1)-ZZS->ZZS_FRTUNI)/ZZS->ZZS_QTDVEN,8)
				nTotItem	:= Round(nVlrUnit*ZZS->ZZS_QTDVEN,2)

				//Cria amarração cliente x produto
				SA7->(DBGotop())
				If !SA7->(DbSeek(xFilial("SA7")+cCodCli+cLoja+cProduto))
					Reclock('SA7',.T.)
					SA7->A7_CLIENTE		:= cCodCli
					SA7->A7_LOJA		:= cLoja
					SA7->A7_PRODUTO		:= cProduto
					SA7->A7_XSEGMENT	:= '300005'
					SA7->A7_YDESINT		:= 'CERVEJARIA'
					SA7->(MsUnlock())
				EndIf

				aItens := {	{"C6_FILIAL"	,xFilial("SC6")		,Nil},;
					{"C6_NUM"		,cNumPed			,Nil},;
					{"C6_ITEM"		,ZZS->ZZS_ITEM		,Nil},;
					{"C6_PRODUTO"	,cProduto			,Nil},;
					{"C6_LOCAL"		,cArmazem			,Nil},;
					{"C6_TES"		,cTesPad		 	,NIL},;
					{"C6_CFO"		,cCfoPad		 	,NIL},;
					{"C6_CLI"		,ZZR->ZZR_CLIENT	,NIL},;
					{"C6_LOJA"		,ZZR->ZZR_LOJA		,NIL},;
					{"C6_QTDVEN"	,ZZS->ZZS_QTDVEN	,NIL},;
					{"C6_QTDLIB"	,ZZS->ZZS_QTDVEN	,NIL},;
					{"C6_UNSVEN"	,ZZS->ZZS_QTDVEN*1000	,NIL},;
					{"C6_PRCVEN"	,nVlrUnit			,NIL},;
					{"C6_PRUNIT"	,nVlrUnit			,NIL},;
					{"C6_LIID"		,ZZS->ZZS_NUM		,NIL},;
					{"C6_VALOR"		,nTotItem			,NIL},;
					{"C6_UM"		,cUM				,NIL},;
					{"C6_SEGUM"		,cSegUM				,NIL},;
					{"C6_FRTUNI"	,ZZS->ZZS_FRTUNI	,NIL},;
					{"C6_ENTREG"	,dDataBase			,NIL}}
				Aadd(aDetail,aItens)
				ZZS->(DbSkip())
			EndDo


			SA1->(RestArea(aAreaSA1))
			SB1->(RestArea(aAreaSB1))
			SB5->(RestArea(aAreaSB5))
			lMsHelpAuto	:= .T.
			lMsErroAuto	:= .F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec, aDetail, 3)
			If lMsErroAuto
				Conout("Loja Integrada - Erro na Execauto do pedido "+ cPedidoLI + " - " + cNumPed)
				MostraErro("\LOJAINTEGRADA\","SC5_"+dtos(dDatabase)+"_"+StrTran(Time(),":",'')+".txt")
				RollbackSx8()
				lErro	    := .T.
				LISENDMAIL(lErro,cPedidoLI)
				Return
			Else
				Conout("Loja Integrada - Execauto do pedido " + cPedidoLI + " - Protheus: ("+ cNumPed + ") realizada com sucesso.")
				ConfirmSx8()

				//Atualiza tabelas ZZR e ZZS
				ZZR->(Reclock("ZZR",.F.))
				ZZR->ZZR_PEDC5 := cNumPed
				ZZR->(MsUnlock())

				ZZS->(DBSetOrder(1))
				ZZS->(DBGotop())
				ZZS->(DbSeek(xFilial("ZZS")+ZZR->ZZR_NUM))
				While ZZS->(!EOF()) .AND. ZZR->ZZR_NUM == ZZS->ZZS_NUM
					ZZS->(Reclock("ZZS",.F.))
					ZZS->ZZS_PEDC5 := cNumPed
					ZZS->(MsUnlock())
					ZZS->(DbSkip())
				EndDo

				//Atualiza status do Pedido na Loja Integrada
				oPut := FWRest():New(cEndpoint)
				oPut:SetPath('/v1/situacao/pedido/' + cPedidoLI)
				cBody	:= '{  "codigo": "pedido_em_separacao"}'
				oPut:Put(aHeadApi, cBody)
				cRespJSON := oPut:GetResult()

				If !('200' $ oPut:oResponseH:cStatusCode)
					Conout("Loja Integrada: Nao foi possivel alterar o status do pedido" + cPedidoLI )
				else
					ZZR->(Reclock("ZZR",.F.))
					ZZR->ZZR_STATUS := "pedido_em_separacao"
					ZZR->(MsUnlock())
					//Envio de E-mail
					lErro := .F.
					LISENDMAIL(lErro,ZZR->ZZR_NUM)
				Endif

				Return
			Endif
		Else
			Conout("Loja Integrada - Pedido " + cPedidoLI + " já existe no Protheus ou não foi Aprovado, não vai rodar Execauto.")
		Endif
	EndIf
Return lRet

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄìd!
//³Rotina para envio de e-mails com status dos pedidos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄìd!
ENDDOC*/
Static Function LISENDMAIL(lErro,cPedido)

Local lFoi 		:= .F.
Local nCount 	:= 0
Local cBody		:= ''

	If lErro
		cTo      	:= SuperGetMV( "LI_MAILERR" , .F. , 'gustavo@newbridge.srv.br') 
		If cPedido == 'CLIENTE'
			cAssunto	:= "Cliente Loja Integrada não foi importado, verificar ZZQ"
		Else
			cAssunto	:= "Pedido Loja Integrada nº " + cPedido + " não foi importado, verificar ZZR e ZZS"
		EndIf
		cBody 		:= "Favor Verificar o problema pelo log em E:\TOTVS12_HM\Protheus_Data\LOJAINTEGRADA\"
	Else
		cTo      	:= SuperGetMV( "LI_MAIL" , .F. , 'gustavo@newbridge.srv.br')             
		cAssunto	:= "Novo pedido via Loja Integrada - " + ZZR->ZZR_PEDC5
		cCondPg		:= POSICIONE("SC5",1,xFilial("SC5")+ZZR->ZZR_PEDC5,"C5_CONDPAG")

		cBody	:= '<html>'
		cBody  	+= '<body>'
		cBody  	+= '<style>
		cBody  	+= 'th {text-align:left;}
		cBody  	+= 'table tr th,table tr td {padding:5px;}
		cBody  	+= '</style>
		cBody 	+= '<font size="3" face="Arial">'           
		cBody 	+= '<b><h2 style="padding:5px;border-bottom:1px solid #000;">Pedido Loja Integrada #'+ZZR->ZZR_PEDC5+'</h2></b>'	
		cBody 	+= '<table style="text-align: left">
		cBody 	+= '	<tr>'
		cBody 	+= '		<th>Pedido:</th>'
		cBody 	+= '		<td>' + ZZR->ZZR_PEDC5	+ '</td>'
		cBody 	+= '	</tr>'
		cBody 	+= '	<tr>'
		cBody 	+= '		<th>Cliente:</th>'
		cBody 	+= '		<td>' + ZZR->ZZR_CLIENT + ' - ' + POSICIONE("SA1",1,xFilial("SA1")+ZZR->ZZR_CLIENT+ZZR->ZZR_LOJA,"A1_NOME") + '</td>' 
		cBody 	+= '	</tr>' 
		cBody 	+= '	<tr>'
		cBody 	+= '		<th>Cond. Pagto.:</th>'
		cBody 	+= '		<td>' + cCondPg + ' - ' + POSICIONE("SE4",1,xFilial("SE4")+cCondPg,"E4_DESCRI") + '</td>' 
		cBody 	+= '	</tr>' 
		cBody 	+= '	<tr>'
		cBody 	+= '		<th>ID Loja Integrada:</th>'
		cBody 	+= '		<td>' + ZZR->ZZR_NUM + '</td>' 
		cBody 	+= '	</tr>'				
		cBody 	+= '	<tr>'
		cBody 	+= '		<th>Total Pedido:</th>'
		cBody 	+= '		<td>R$' + Transform(ZZR->ZZR_VALOR,"@E 999,999.99") + '</td>' 
		cBody 	+= '	</tr>'					
		cBody 	+= '	<tr>'
		cBody 	+= '		<th>Frete:</th>'
		cBody 	+= '		<td>R$' + Transform(ZZR->ZZR_FRETE,"@E 999,999.99") + '</td>' 
		cBody 	+= '	</tr>'		
		cBody	+= '</table><br><br>'
		cBody 	+= '<table border="1" style="border-collapse: collapse;margin-left:5px;">'
		cBody 	+= '	<tr>'
		cBody 	+= '   		<th>Item</th>'
		cBody 	+= '   		<th>Produto</th>'
		cBody 	+= '   		<th>Descrição</th>'
		cBody 	+= '   		<th>Valor Unitário</th>'
		cBody 	+= '   		<th>Quantidade</th>'
		cBody 	+= '   		<th>Valor Total</th>'
		cBody 	+= '	</tr>'	

		ZZS->(DBSetOrder(1))		
		ZZS->(DBGotop())
		ZZS->(DbSeek(xFilial("ZZS")+ZZR->ZZR_NUM))   
		While ZZS->(!EOF()) .AND. ZZR->ZZR_NUM == ZZS->ZZS_NUM
			cBody 	+= '<tr>'
			cBody 	+= '	<td>' + ZZS->ZZS_ITEM + '</td>' 
			cBody 	+= '	<td>' + ZZS->ZZS_PRODUT + '</td>' 
			cBody 	+= '	<td>' + ZZS->ZZS_DESCRI + '</td>' 		
			cBody 	+= '	<td>R$' + Transform(ZZS->ZZS_PRCVEN,"@E 999,999.99") + '</td>'  		
			cBody 	+= '	<td>' + STR(ZZS->ZZS_QTDVEN) + '</td>'
			cBody 	+= '	<td>R$' + Transform(ZZS->ZZS_PRCVEN*ZZS->ZZS_QTDVEN,"@E 999,999.99") + '</td>'  				
			cBody 	+= '</tr>'			
			ZZS->(DbSkip())
		EndDo
		cBody	+= '</table>'
		cBody	+= '</font>'	
		cBody	+= '</body>'
		cBody	+= '</html>' 

		Memowrite("\LOJAINTEGRADA\email\" + Alltrim(cPedido)+".html",cBody)
	Endif
	

	For nCount := 1 to 10
		lFoi := .F.
		lFoi := u_zEnvMail(cTo,cAssunto,cBody,{},.f.,.t.)
		If !lFoi .and. nCount <= 10
			Conout("Falha na tentativa "+cValtoChar(nCount))
			nCount++
		ElseIf lFoi
			nCount := 10
			Conout("Enviado com sucesso para "+cTo)
		EndIf
	Next nCount

		
Return .T.

/*/{Protheus.doc} LIPROCPED
Função para envio de e-mail informando novo cadastro de cliente 
/*/
Static Function LIMAILCLI()
	Local lFoi 	:= .F.
	Local nCount := 0

	cTo      	:= SuperGetMV( "LI_MAILCLI" , .F. , 'gustavo@newbridge.srv.br')
	cAssunto	:= "Novo cliente Loja Integrada - " + cCodcli + " " + cLoja
	cBody 		:= "Um novo cliente foi cadastrado na Loja Integrada, favor acessar o cadastro de cliente, avaliar o cadastro e ativá-lo."

	For nCount := 1 to 10
		lFoi := .F.
		lFoi := u_zEnvMail(cTo,cAssunto,cBody,{},.f.,.t.)
		If !lFoi .and. nCount <= 10
			Conout("Falha na tentativa "+cValtoChar(nCount))
			nCount++
		ElseIf lFoi
			nCount := 10
			Conout("Enviado com sucesso para "+cTo)
		EndIf
	Next nCount
Return


Static Function COMPARACLI()
	Local lFoi 		:= .F.
	Local nCount 	:= 0
	Local cTo		:= 'gustavo@newbridge.srv.br'
	Local cAssunto	:= 'Loja Integrada - Alteração de dados de cliente'
	Local cBody		:= ''
	Local nZ

	If Alltrim(SA1->A1_NOME) <> Alltrim(ZZQ->ZZQ_RAZAO)
		aAdd(aCompara,'Nome: ' + Alltrim(ZZQ->ZZQ_RAZAO) )
	EndIf

	If Alltrim(SA1->A1_EST) <> Alltrim(ZZQ->ZZQ_EST)
		aAdd(aCompara,'Estado: ' + Alltrim(ZZQ->ZZQ_EST) )
	EndIf
	If Alltrim(SA1->A1_END) <> Alltrim(ZZQ->ZZQ_END)
		aAdd(aCompara,'Endereço: ' + Alltrim(ZZQ->ZZQ_END) )
	EndIf
	If Alltrim(SA1->A1_MUN) <> Alltrim(ZZQ->ZZQ_MUN)
		aAdd(aCompara,'Município: ' + Alltrim(ZZQ->ZZQ_MUN) )
	EndIf
	If Alltrim(SA1->A1_BAIRRO) <> Alltrim(ZZQ->ZZQ_BAIRRO)
		aAdd(aCompara,'Bairro: ' + Alltrim(ZZQ->ZZQ_BAIRRO) )
	EndIf
	If Alltrim(SA1->A1_CEP) <> Alltrim(ZZQ->ZZQ_CEP)
		aAdd(aCompara,'CEP: ' + Alltrim(ZZQ->ZZQ_CEP) )
	EndIf
	If Alltrim(SA1->A1_EMAIL) <> Alltrim(ZZQ->ZZQ_EMAIL)
		aAdd(aCompara,'E-Mail: ' + Alltrim(ZZQ->ZZQ_EMAIL) )
	EndIf

	If Len(aCompara) > 0
		cBody := 'O cliente ' + cCodcli + ' ' + cLoja + ' teve os seguintes valores alterados: <br>'
		For nZ := 1 to Len(aCompara)
			cBody += aCompara[nZ] + '<br>'
		Next

		For nCount := 1 to 10
			lFoi := .F.
			lFoi := u_zEnvMail(cTo,cAssunto,cBody,{},.f.,.t.)
			If !lFoi .and. nCount <= 10
				Conout("Falha na tentativa "+cValtoChar(nCount))
				nCount++
			ElseIf lFoi
				nCount := 10
				Conout("Enviado com sucesso para "+cTo)
			EndIf
		Next nCount
	EndIf
Return
