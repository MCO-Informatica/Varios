#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APWEBSRV.CH'

// Release 20091222 = Gravar recebimento de requisicoes 

/* ===========================================================================
	Classe de WebServices da CertiSign
	Utilização via intranet, requisicoes de pedidos e geracao de notas 
	O pedido é inserido no sistema já pago, com as informações sobre o recebimento
	alimentadas no SE1 como um RA - Recebimento Antecipado, os dados do cliente 
	no SA1, e os itens de pedido em SC5 e SC6  via rotina automatica ( execauto ) 
	
	Mode de funcionamento : WebSErvices Assincrono 
	
	O webservice depende de servicos auxiliares de processamento dedicado, 
	conectados nele. Ao receber a requisicao, o recebimento é logado na tabela 
	GTIN, com um status .t. caso ele tenha sido distribuido para processamento
	ou .f. caso nao tenham agentes disponiveis no momento da requisicao
	
=========================================================================== */

/* ---------------------------------------------------------------------------
	Estrutura com os dados do cliente, 
	informados na inclusao do pedido
--------------------------------------------------------------------------- */
WSSTRUCT CSCLIENTEST

	// Informacoes Obrigatorias 
	WSDATA A1NOME               AS STRING
	WSDATA A1PESSOA             AS STRING
	WSDATA A1NREDUZ             AS STRING
	WSDATA A1END                AS STRING
	WSDATA A1NUMERO             AS STRING
	WSDATA A1TIPO               AS STRING
	WSDATA A1EST                AS STRING
	WSDATA A1ESTADO             AS STRING
	WSDATA A1COD_MUN            AS STRING
	WSDATA A1MUN                AS STRING
	WSDATA A1BAIRRO             AS STRING
	WSDATA A1CEP                AS STRING
	WSDATA A1PAIS               AS STRING
	WSDATA A1CGC                AS STRING
	WSDATA A1INSCR              AS STRING
	WSDATA A1EMAIL              AS STRING

	// Informacoes Opcionais 
	WSDATA A1COMPLEM            AS STRING OPTIONAL
	WSDATA A1DDI                AS STRING OPTIONAL
	WSDATA A1DDD                AS STRING OPTIONAL
	WSDATA A1TEL                AS STRING OPTIONAL
	WSDATA A1TELEX              AS STRING OPTIONAL
	WSDATA A1FAX                AS STRING OPTIONAL
	WSDATA A1ENDCOB             AS STRING OPTIONAL
	WSDATA A1ENDENT             AS STRING OPTIONAL
	WSDATA A1ENDREC             AS STRING OPTIONAL
	WSDATA A1CONTATO            AS STRING OPTIONAL
	WSDATA A1PFISICA            AS STRING OPTIONAL
	WSDATA A1INSCRM             AS STRING OPTIONAL
	WSDATA A1RECISS             AS STRING OPTIONAL
	WSDATA A1SUFRAMA            AS STRING OPTIONAL
	WSDATA A1INCISS             AS STRING OPTIONAL
	WSDATA A1ALIQIR             AS FLOAT  OPTIONAL
	WSDATA A1RG                 AS STRING OPTIONAL
	WSDATA A1OBSERV             AS STRING OPTIONAL
	WSDATA A1BAIRROC            AS STRING OPTIONAL
	WSDATA A1CEPC               AS STRING OPTIONAL
	WSDATA A1MUNC               AS STRING OPTIONAL
	WSDATA A1ESTC               AS STRING OPTIONAL
	WSDATA A1BAIRROE            AS STRING OPTIONAL
	WSDATA A1CEPE               AS STRING OPTIONAL
	WSDATA A1MUNE               AS STRING OPTIONAL
	WSDATA A1ESTE               AS STRING OPTIONAL
	WSDATA A1CODMUNZF           AS STRING OPTIONAL
	WSDATA A1CNAE               AS STRING OPTIONAL
	WSDATA A1RECINSS            AS STRING OPTIONAL
	WSDATA A1RECCOFI            AS STRING OPTIONAL
	WSDATA A1RECCSLL            AS STRING OPTIONAL
	WSDATA A1RECPIS             AS STRING OPTIONAL
	WSDATA A1NATUREZ            AS STRING OPTIONAL
	
ENDWSSTRUCT 

/* ---------------------------------------------------------------------------
	Estrutura com os dados financeiros do recebimento 
	informado na inclusao do pedido
--------------------------------------------------------------------------- */
WSSTRUCT CSFINANCST

	// Informacoes Obrigatorias 
	WSDATA E1PEDGAR             AS STRING 
	WSDATA E1TIPMOV             AS STRING
	WSDATA E1CNPJ               AS STRING
	WSDATA E1EMISSAO            AS DATE
	WSDATA E1VENCTO             AS DATE
	WSDATA E1VALOR              AS FLOAT
	WSDATA E1PORTADO            AS STRING
	WSDATA E1AGEDEP             AS STRING
	WSDATA E1CONTA              AS STRING

	// Informacoes Opcionais e/ou condicionais
	WSDATA E1HIST               AS STRING OPTIONAL
	WSDATA E1ADM                AS STRING OPTIONAL

ENDWSSTRUCT 

/* ---------------------------------------------------------------------------
	Estrutura com os dados do cabeçalho do pedido 
	informado na inclusao do pedido
--------------------------------------------------------------------------- */
WSSTRUCT CSPEDCABECST

	// Informacoes Obrigatorias 
	WSDATA C5CHVBPAG           AS STRING
	WSDATA C5CNPJ              AS STRING
	WSDATA C5CONDPAG           AS STRING
	WSDATA C5EMISSAO           AS DATE
	WSDATA C5TIPMOV            AS STRING
	WSDATA C5TOTPED			   AS FLOAT
	WSDATA C5STATUS            AS STRING

	// Informacoes Opcionais e/ou condicionais
	WSDATA C5TIPMOV2           AS STRING OPTIONAL 
	WSDATA C5MENNOTA           AS STRING OPTIONAL
	WSDATA C5TIPVOU            AS STRING OPTIONAL
	WSDATA C5CODVOU            AS STRING OPTIONAL
	WSDATA C5MOTVOU            AS STRING OPTIONAL
	WSDATA C5GARANT            AS STRING OPTIONAL

ENDWSSTRUCT 

/* ---------------------------------------------------------------------------
	Estrutura com os dados de um item de pedido
	informado na inclusao do pedido
--------------------------------------------------------------------------- */
WSSTRUCT CSITEMST

	// Informacoes Obrigatorias 
	WSDATA C6PEDGAR            AS STRING
	WSDATA C6PROGAR            AS STRING
	WSDATA C6QTDVEN            AS FLOAT
	WSDATA C6PRCVEN            AS FLOAT

ENDWSSTRUCT 

/* ---------------------------------------------------------------------------
	Estrutura agrupando todos os dados necessarios para a inclusao de um pedido
--------------------------------------------------------------------------- */
WSSTRUCT CSINCPEDST
	WSDATA CLIENTE    AS CSCLIENTEST
	WSDATA TITULO     AS CSFINANCST 
	WSDATA HEADER     AS CSPEDCABECST
	WSDATA ITENS	  AS ARRAY OF CSITEMST
ENDWSSTRUCT 

/* ---------------------------------------------------------------------------
	Estrutura agrupando todos os dados necessarios para gerar a nota 
--------------------------------------------------------------------------- */
WSSTRUCT CSMOVNOTAST

	// Informacoes Obrigatorias 

	WSDATA Z5PEDGAR               AS STRING
	WSDATA Z5DATPED               AS DATE
	WSDATA Z5DATVAL               AS DATE
	WSDATA Z5HORVAL               AS STRING
	WSDATA Z5CNPJ                 AS STRING
	WSDATA Z5CNPJCER              AS STRING
	WSDATA Z5NOMREC               AS STRING
	WSDATA Z5DATPAG               AS DATE
	WSDATA Z5VALOR                AS FLOAT
	WSDATA Z5TIPMOV               AS STRING
	WSDATA Z5CODAR                AS STRING
	WSDATA Z5DESCAR               AS STRING
	WSDATA Z5CODPOS               AS STRING
	WSDATA Z5DESPOS               AS STRING
	WSDATA Z5CODAGE               AS STRING
	WSDATA Z5NOMAGE               AS STRING
	WSDATA Z5CPFAGE               AS STRING
	WSDATA Z5PRODUTO              AS STRING
	WSDATA Z5DESPRO               AS STRING


	// Informacoes Opcionais e/ou condicionais
	WSDATA Z5STATUS               AS STRING OPTIONAL
	WSDATA Z5EMISSAO              AS DATE   OPTIONAL
	WSDATA Z5RENOVA               AS DATE   OPTIONAL
	WSDATA Z5REVOGA               AS DATE   OPTIONAL
	WSDATA Z5GARANT               AS STRING OPTIONAL
	WSDATA Z5CERTIF               AS STRING OPTIONAL
	WSDATA Z5GRUPO                AS STRING OPTIONAL
	WSDATA Z5DESGRU               AS STRING OPTIONAL
	WSDATA Z5TIPVOU               AS STRING OPTIONAL
	WSDATA Z5CODVOU               AS STRING OPTIONAL

    //Novas Informações Integraçao Gar 
	WSDATA Z5CODAC               AS STRING OPTIONAL
	WSDATA Z5DESCAC              AS STRING OPTIONAL
	WSDATA Z5CODARP              AS STRING OPTIONAL
	WSDATA Z5DESCARP             AS STRING OPTIONAL
	WSDATA Z5REDE	             AS STRING OPTIONAL
	WSDATA Z5CPFT	             AS STRING OPTIONAL
	WSDATA Z5NTITULA             AS STRING OPTIONAL
	WSDATA Z5CNPJV	             AS STRING OPTIONAL
	WSDATA Z5RSVAL	             AS STRING OPTIONAL
	
ENDWSSTRUCT 

/* ---------------------------------------------------------------------------
	Estrutura de resposta dos metodos deste serviço. 
	Retorna identificador numerico, onde 0 indica sucesso 
	E qqer numero diferente de 0 indica uma inonsistencia de processamento. 
	O campo DETAILSTR informa a causa de falha no processamento. 
--------------------------------------------------------------------------- */
WSSTRUCT CSRESPONSEST
	WSDATA OK		 		AS BOOLEAN
	WSDATA DETAILSTR		AS STRING	OPTIONAL
ENDWSSTRUCT 

/* ===========================================================================
	Declaracao da classe de WebServices CertiSignErp
=========================================================================== */

WSSERVICE CERTISIGNERP	;
	DESCRIPTION "<b>Serviço de integração com ERP - Específico CertiSign.</b><br><br>Utilizado para inclusão de pedidos e geração de notas fiscais."  ;
	NAMESPACE "http://www.certisign.com.br/certisignerp.apw"
	
	WSDATA PEDIDO      AS CSINCPEDST
	WSDATA MOVNOTA     AS CSMOVNOTAST
	WSDATA RESPONSE    AS CSRESPONSEST

	WSMETHOD INCPEDIDO    DESCRIPTION "Insere um pedido contendo informações do cliente e informações da transação financeira."
	WSMETHOD GERANOTA     DESCRIPTION "Realiza a liberação e geração de nota de um pedido já registrado."

ENDWSSERVICE

/* ===========================================================================
	Metodo de inserção de pedido no ERP 
	Recebe um pedido já pago, com dados do cliente, pagamento e itens do pedido
=========================================================================== */

WSMETHOD INCPEDIDO   WSRECEIVE PEDIDO WSSEND RESPONSE WSSERVICE CERTISIGNERP
Local aInfoSA1		:= {}
Local aInfoSE1		:= {}
Local aInfoSC5		:= {}
Local aInfoSC6		:= {}
Local aItemPed		:= {}
Local nItensPed		:= 0
Local nI			:= 0
Local lAssync 
Local cGTId 		:= dtos(date())+strtran(time(),":","")+strzero(threadid(),10)
Local cBreakIni		:= GetNewPar("MV_GARBKIN", "23:55")	
Local cBreakFim		:= GetNewPar("MV_GARBKFI", "00:00")	

// GTID : Identificador unico de requisicao de processamento

lAssync := ( alltrim(Getjobprofstring("ASSYNCMODE","0")) == '1' )

If !lAssync
	SetSoapFault("Protheus WS Config Error","AssyncMode nao configurado.")
	Return .F.
Endif

// Etapa 01 : Separa informacoes do cliente para execauto

// Informacoes Obrigatorias
AADD(aInfoSA1,{"A1_NOME"	,PEDIDO:CLIENTE:A1NOME})
AADD(aInfoSA1,{"A1_PESSOA"	,PEDIDO:CLIENTE:A1PESSOA})
AADD(aInfoSA1,{"A1_NREDUZ"	,PEDIDO:CLIENTE:A1NREDUZ})
AADD(aInfoSA1,{"A1_END"		,PEDIDO:CLIENTE:A1END})
AADD(aInfoSA1,{"A1_NUMERO"	,PEDIDO:CLIENTE:A1NUMERO})
AADD(aInfoSA1,{"A1_TIPO"	,PEDIDO:CLIENTE:A1TIPO})
AADD(aInfoSA1,{"A1_EST"		,PEDIDO:CLIENTE:A1EST})
AADD(aInfoSA1,{"A1_ESTADO"	,PEDIDO:CLIENTE:A1ESTADO})
AADD(aInfoSA1,{"A1_COD_MUN",PEDIDO:CLIENTE:A1COD_MUN})
AADD(aInfoSA1,{"A1_MUN"		,PEDIDO:CLIENTE:A1MUN})
AADD(aInfoSA1,{"A1_BAIRRO"	,PEDIDO:CLIENTE:A1BAIRRO})
AADD(aInfoSA1,{"A1_CEP"		,PEDIDO:CLIENTE:A1CEP})
AADD(aInfoSA1,{"A1_PAIS"	,PEDIDO:CLIENTE:A1PAIS})
AADD(aInfoSA1,{"A1_CGC"		,PEDIDO:CLIENTE:A1CGC})
AADD(aInfoSA1,{"A1_INSCR"	,PEDIDO:CLIENTE:A1INSCR})
AADD(aInfoSA1,{"A1_EMAIL"	,PEDIDO:CLIENTE:A1EMAIL})

// Informacoes Opcionais
IF PEDIDO:CLIENTE:A1COMPLEM != NIL
	AADD(aInfoSA1,{"A1_COMPLEM"	,PEDIDO:CLIENTE:A1COMPLEM})
Endif
IF PEDIDO:CLIENTE:A1DDI != NIL
	AADD(aInfoSA1,{"A1_DDI",PEDIDO:CLIENTE:A1DDI})
Endif
IF PEDIDO:CLIENTE:A1DDD != NIL
	AADD(aInfoSA1,{"A1_DDD",PEDIDO:CLIENTE:A1DDD})
Endif
IF PEDIDO:CLIENTE:A1TEL != NIL
	AADD(aInfoSA1,{"A1_TEL     ",PEDIDO:CLIENTE:A1TEL})
Endif
IF PEDIDO:CLIENTE:A1TELEX != NIL
	AADD(aInfoSA1,{"A1_TELEX   ",PEDIDO:CLIENTE:A1TELEX})
Endif
IF PEDIDO:CLIENTE:A1FAX != NIL
	AADD(aInfoSA1,{"A1_FAX     ",PEDIDO:CLIENTE:A1FAX})
Endif
IF PEDIDO:CLIENTE:A1ENDCOB != NIL
	AADD(aInfoSA1,{"A1_ENDCOB  ",PEDIDO:CLIENTE:A1ENDCOB})
Endif
IF PEDIDO:CLIENTE:A1ENDENT != NIL
	AADD(aInfoSA1,{"A1_ENDENT  ",PEDIDO:CLIENTE:A1ENDENT})
Endif
IF PEDIDO:CLIENTE:A1ENDREC != NIL
	AADD(aInfoSA1,{"A1_ENDREC  ",PEDIDO:CLIENTE:A1ENDREC})
Endif
IF PEDIDO:CLIENTE:A1CONTATO != NIL
	AADD(aInfoSA1,{"A1_CONTATO ",PEDIDO:CLIENTE:A1CONTATO})
Endif
IF PEDIDO:CLIENTE:A1PFISICA != NIL
	AADD(aInfoSA1,{"A1_PFISICA ",PEDIDO:CLIENTE:A1PFISICA})
Endif
IF PEDIDO:CLIENTE:A1INSCRM != NIL
	AADD(aInfoSA1,{"A1_INSCRM  ",PEDIDO:CLIENTE:A1INSCRM})
Endif
IF PEDIDO:CLIENTE:A1RECISS != NIL
	AADD(aInfoSA1,{"A1_RECISS  ",PEDIDO:CLIENTE:A1RECISS})
Endif
IF PEDIDO:CLIENTE:A1SUFRAMA != NIL
	AADD(aInfoSA1,{"A1_SUFRAMA ",PEDIDO:CLIENTE:A1SUFRAMA})
Endif
IF PEDIDO:CLIENTE:A1INCISS != NIL
	AADD(aInfoSA1,{"A1_INCISS  ",PEDIDO:CLIENTE:A1INCISS})
Endif
IF PEDIDO:CLIENTE:A1ALIQIR != NIL
	AADD(aInfoSA1,{"A1_ALIQIR  ",PEDIDO:CLIENTE:A1ALIQIR})
Endif
IF PEDIDO:CLIENTE:A1RG != NIL
	AADD(aInfoSA1,{"A1_RG      ",PEDIDO:CLIENTE:A1RG})
Endif
IF PEDIDO:CLIENTE:A1OBSERV != NIL
	AADD(aInfoSA1,{"A1_OBSERV  ",PEDIDO:CLIENTE:A1OBSERV})
Endif
IF PEDIDO:CLIENTE:A1BAIRROC != NIL
	AADD(aInfoSA1,{"A1_BAIRROC ",PEDIDO:CLIENTE:A1BAIRROC})
Endif
IF PEDIDO:CLIENTE:A1CEPC != NIL
	AADD(aInfoSA1,{"A1_CEPC    ",PEDIDO:CLIENTE:A1CEPC})
Endif
IF PEDIDO:CLIENTE:A1MUNC != NIL
	AADD(aInfoSA1,{"A1_MUNC    ",PEDIDO:CLIENTE:A1MUNC})
Endif
IF PEDIDO:CLIENTE:A1ESTC != NIL
	AADD(aInfoSA1,{"A1_ESTC    ",PEDIDO:CLIENTE:A1ESTC})
Endif
IF PEDIDO:CLIENTE:A1BAIRROE != NIL
	AADD(aInfoSA1,{"A1_BAIRROE ",PEDIDO:CLIENTE:A1BAIRROE})
Endif
IF PEDIDO:CLIENTE:A1CEPE != NIL
	AADD(aInfoSA1,{"A1_CEPE    ",PEDIDO:CLIENTE:A1CEPE})
Endif
IF PEDIDO:CLIENTE:A1MUNE != NIL
	AADD(aInfoSA1,{"A1_MUNE    ",PEDIDO:CLIENTE:A1MUNE})
Endif
IF PEDIDO:CLIENTE:A1ESTE != NIL
	AADD(aInfoSA1,{"A1_ESTE    ",PEDIDO:CLIENTE:A1ESTE})
Endif
IF PEDIDO:CLIENTE:A1CODMUNZF != NIL
	AADD(aInfoSA1,{"A1_CODMUN  ",PEDIDO:CLIENTE:A1CODMUNZF})
Endif
IF PEDIDO:CLIENTE:A1CNAE != NIL
	AADD(aInfoSA1,{"A1_CNAE    ",PEDIDO:CLIENTE:A1CNAE})
Endif
IF PEDIDO:CLIENTE:A1RECINSS != NIL
	AADD(aInfoSA1,{"A1_RECINSS ",PEDIDO:CLIENTE:A1RECINSS})
Endif
IF PEDIDO:CLIENTE:A1RECCOFI != NIL
	AADD(aInfoSA1,{"A1_RECCOFI ",PEDIDO:CLIENTE:A1RECCOFI})
Endif
IF PEDIDO:CLIENTE:A1RECCSLL != NIL
	AADD(aInfoSA1,{"A1_RECCSLL ",PEDIDO:CLIENTE:A1RECCSLL})
Endif
IF PEDIDO:CLIENTE:A1RECPIS != NIL
	AADD(aInfoSA1,{"A1_RECPIS  ",PEDIDO:CLIENTE:A1RECPIS})
Endif
IF PEDIDO:CLIENTE:A1NATUREZ != NIL
	AADD(aInfoSA1,{"A1_NATUREZ ",PEDIDO:CLIENTE:A1NATUREZ})
Endif

// varinfo("CLIENTE",aInfoSA1)

// Monta array com informacoes sobre o Titulo do SE1

// Informacoes Obrigatorias
aadd(aInfoSE1,{"E1_PEDGAR",PEDIDO:TITULO:E1PEDGAR})
aadd(aInfoSE1,{"E1_TIPMOV",PEDIDO:TITULO:E1TIPMOV})
aadd(aInfoSE1,{"E1_CNPJ",PEDIDO:TITULO:E1CNPJ})
aadd(aInfoSE1,{"E1_EMISSAO",PEDIDO:TITULO:E1EMISSAO})
aadd(aInfoSE1,{"E1_VENCTO",PEDIDO:TITULO:E1VENCTO})
aadd(aInfoSE1,{"E1_VALOR",PEDIDO:TITULO:E1VALOR})

// Informacoes Opcionais e/ou condicionais
If PEDIDO:TITULO:E1HIST != NIL
	aadd(aInfoSE1,{"E1_HIST",PEDIDO:TITULO:E1HIST})
Endif
If PEDIDO:TITULO:E1ADM != NIL
	aadd(aInfoSE1,{"E1_ADM",PEDIDO:TITULO:E1ADM})
Endif
If PEDIDO:TITULO:E1PORTADO != NIL
	aadd(aInfoSE1,{"E1_PORTADO",PEDIDO:TITULO:E1PORTADO})
Endif
If PEDIDO:TITULO:E1AGEDEP != NIL
	aadd(aInfoSE1,{"E1_AGEDEP",PEDIDO:TITULO:E1AGEDEP})
Endif
If PEDIDO:TITULO:E1CONTA != NIL
	aadd(aInfoSE1,{"E1_CONTA",PEDIDO:TITULO:E1CONTA})
Endif

// Varinfo("TITULO",aInfoSE1)         

// Informacoes do Header do Pedido
aadd(aInfoSC5,{"C5_CHVBPAG",PEDIDO:HEADER:C5CHVBPAG})
aadd(aInfoSC5,{"C5_CNPJ",PEDIDO:HEADER:C5CNPJ})
aadd(aInfoSC5,{"C5_CONDPAG",PEDIDO:HEADER:C5CONDPAG})
aadd(aInfoSC5,{"C5_EMISSAO",PEDIDO:HEADER:C5EMISSAO})
aadd(aInfoSC5,{"C5_TIPMOV",PEDIDO:HEADER:C5TIPMOV})
aadd(aInfoSC5,{"C5_TOTPED",PEDIDO:HEADER:C5TOTPED})
aadd(aInfoSC5,{"C5_STATUS",PEDIDO:HEADER:C5STATUS})

// Informacoes Opcionais e/ou condicionais 
If PEDIDO:HEADER:C5TIPMOV2 != NIL 
	aadd(aInfoSC5,{"C5_TIPMOV2",PEDIDO:HEADER:C5TIPMOV2})
Endif
If PEDIDO:HEADER:C5MENNOTA != NIL
	aadd(aInfoSC5,{"C5_MENNOTA",PEDIDO:HEADER:C5MENNOTA})
Endif
If PEDIDO:HEADER:C5TIPVOU != NIL
	aadd(aInfoSC5,{"C5_TIPVOU",PEDIDO:HEADER:C5TIPVOU})
Endif
If PEDIDO:HEADER:C5CODVOU != NIL
	aadd(aInfoSC5,{"C5_CODVOU",PEDIDO:HEADER:C5CODVOU})
Endif
If PEDIDO:HEADER:C5MOTVOU != NIL
	aadd(aInfoSC5,{"C5_MOTVOU",PEDIDO:HEADER:C5MOTVOU})
Endif
If PEDIDO:HEADER:C5GARANT != NIL
	aadd(aInfoSC5,{"C5_GARANT",PEDIDO:HEADER:C5GARANT})
Endif

// Varinfo("HEADER",aInfoSC5)

// Verifica se o pedido tem pelo menos um item
If empty(PEDIDO:ITENS)
	SetSoapFault("Argument Error","Pedido recebido sem itens.")
	Return .F.
Endif

nItensPed := len(PEDIDO:ITENS)

For nI := 1 to nItensPed

	// Obtem agora os itens do pedido
	// acrescenta um item de pedido como um array em branco
	// e pega a referenia dele para acrescentar os conteudos
	aadd(aInfoSC6,{})
	aItemPed := atail(aInfoSC6)
	
	aadd(aItemPed,{"C6_PEDGAR",PEDIDO:ITENS[nI]:C6PEDGAR})
	aadd(aItemPed,{"C6_PROGAR",PEDIDO:ITENS[nI]:C6PROGAR})
	aadd(aItemPed,{"C6_QTDVEN",PEDIDO:ITENS[nI]:C6QTDVEN})
	aadd(aItemPed,{"C6_PRCVEN",PEDIDO:ITENS[nI]:C6PRCVEN})

Next

// varinfo("ITENS",aInfoSC6)
   
/*
WebSErvice em Modo assincrono - Retorno Imediato
Retorno positivo caso a requisicao tenha sido distribuida
Retorno negativo 

Distibuicao para componente send2proc()
Para ser executado em servico dedicado
*/

If Empty(PEDIDO:HEADER:C5CHVBPAG)
	
	RESPONSE:OK 	   := .F.
	RESPONSE:DETAILSTR := "Requisicao invalida. Chave C5CHVBPAG nao preenchida"
	
ElseIf !(Substr(time(),1,5) <= cBreakIni  .AND. Substr(time(),1,5) >= cBreakFim)
	RESPONSE:OK 	   := .F.
	RESPONSE:DETAILSTR := "Solicitacao dentro do Horário restrito de "+cBreakIni+" ate "+cBreakFim		
Else

	// Manda a requisicao para processamento em outro servico 
	
	If U_Send2Proc(cGtId,"U_GARA110J",PEDIDO:HEADER:C5CHVBPAG,aInfoSA1,aInfoSC5,aInfoSC6,aInfoSE1)
		
		// Grava no log de entrada que uma requisicao de pedido foi recebida 
		U_GTPutIN(cGtId,"P",PEDIDO:HEADER:C5CHVBPAG,.T.,;
			{"U_GARA110J",PEDIDO:HEADER:C5CHVBPAG,aInfoSA1,aInfoSC5,aInfoSC6,aInfoSE1},,{"Não Disponivel","Não Disponivel","Não Disponivel"})
		conout("Rotina: CertisignServerWS.prw - Linha: 497")
		RESPONSE:OK 	   := .T.
		
	Else
		
		// Grava no log de entrada que uma requisicao de pedido foi recebida 
		// Mas nao foi distribuida 
		U_GTPutIN(cGtId,"P",PEDIDO:HEADER:C5CHVBPAG,.F.,;
			{"U_GARA110J",PEDIDO:HEADER:C5CHVBPAG,aInfoSA1,aInfoSC5,aInfoSC6,aInfoSE1},,{"Não Disponivel","Não Disponivel","Não Disponivel"})
		conout("Rotina: CertisignServerWS.prw - Linha: 506")
		RESPONSE:OK 	   := .F.
		RESPONSE:DETAILSTR := "Nao foi possivel distribuir a requisicao. Tente novamente mais tarde."
		
	Endif
	
Endif

Return .T.

/* ===========================================================================
	Metodo de geracao de nota do pedido.
	Atualiza tabela SZ5 do ERP, com a movimentação realizada, 
	liberando o pedido, gerando a nota fiscal, e transmitindo a nota
	via integração NFE automaticamente.
=========================================================================== */

WSMETHOD GERANOTA    WSRECEIVE MOVNOTA WSSEND RESPONSE WSSERVICE CERTISIGNERP

Local aInfoSZ5	:= {}
Local lAssync 
Local cGTId := dtos(date())+strtran(time(),":","")+strzero(threadid(),10)
Local cBreakIni		:= GetNewPar("MV_GARBKIN", "23:55")	
Local cBreakFim		:= GetNewPar("MV_GARBKFI", "00:00")	


// GTID : Identificador unico de requisicao de processamento

lAssync := ( alltrim(Getjobprofstring("ASSYNCMODE","0")) == '1' )

If !lAssync
	SetSoapFault("Protheus WS Config Error","AssyncMode nao configurado.")
	Return .F.
Endif

aadd(aInfoSZ5,{"Z5_PEDGAR" ,MOVNOTA:Z5PEDGAR})
aadd(aInfoSZ5,{"Z5_DATPED" ,MOVNOTA:Z5DATPED})
aadd(aInfoSZ5,{"Z5_EMISSAO",MOVNOTA:Z5EMISSAO})
aadd(aInfoSZ5,{"Z5_RENOVA" ,MOVNOTA:Z5RENOVA})
aadd(aInfoSZ5,{"Z5_REVOGA" ,MOVNOTA:Z5REVOGA})
aadd(aInfoSZ5,{"Z5_DATVAL" ,MOVNOTA:Z5DATVAL})
aadd(aInfoSZ5,{"Z5_HORVAL" ,MOVNOTA:Z5HORVAL})
aadd(aInfoSZ5,{"Z5_CNPJ"   ,MOVNOTA:Z5CNPJ})
aadd(aInfoSZ5,{"Z5_CNPJCER",MOVNOTA:Z5CNPJCER})
aadd(aInfoSZ5,{"Z5_NOMREC" ,MOVNOTA:Z5NOMREC})
aadd(aInfoSZ5,{"Z5_DATPAG" ,MOVNOTA:Z5DATPAG})
aadd(aInfoSZ5,{"Z5_VALOR"  ,MOVNOTA:Z5VALOR})
aadd(aInfoSZ5,{"Z5_TIPMOV" ,MOVNOTA:Z5TIPMOV})
aadd(aInfoSZ5,{"Z5_STATUS" ,MOVNOTA:Z5STATUS})
aadd(aInfoSZ5,{"Z5_CODAR"  ,MOVNOTA:Z5CODAR})
aadd(aInfoSZ5,{"Z5_DESCAR" ,MOVNOTA:Z5DESCAR})
aadd(aInfoSZ5,{"Z5_CODPOS" ,MOVNOTA:Z5CODPOS})
aadd(aInfoSZ5,{"Z5_DESPOS" ,MOVNOTA:Z5DESPOS})
aadd(aInfoSZ5,{"Z5_CODAGE" ,MOVNOTA:Z5CODAGE})
aadd(aInfoSZ5,{"Z5_NOMAGE" ,MOVNOTA:Z5NOMAGE})
aadd(aInfoSZ5,{"Z5_CPFAGE" ,MOVNOTA:Z5CPFAGE})
aadd(aInfoSZ5,{"Z5_CERTIF" ,MOVNOTA:Z5CERTIF})
aadd(aInfoSZ5,{"Z5_PRODUTO",MOVNOTA:Z5PRODUTO})
aadd(aInfoSZ5,{"Z5_DESPRO" ,MOVNOTA:Z5DESPRO})
aadd(aInfoSZ5,{"Z5_GRUPO"  ,MOVNOTA:Z5GRUPO})
aadd(aInfoSZ5,{"Z5_DESGRU" ,MOVNOTA:Z5DESGRU})

IF MOVNOTA:Z5STATUS != NIL
	aadd(aInfoSZ5,{"Z5_STATUS" ,MOVNOTA:Z5STATUS})
Endif
IF MOVNOTA:Z5EMISSAO != NIL
	aadd(aInfoSZ5,{"Z5_EMISSAO" ,MOVNOTA:Z5EMISSAO})
Endif
IF MOVNOTA:Z5RENOVA != NIL
	aadd(aInfoSZ5,{"Z5_RENOVA" ,MOVNOTA:Z5RENOVA})
Endif
IF MOVNOTA:Z5REVOGA != NIL
	aadd(aInfoSZ5,{"Z5_REVOGA" ,MOVNOTA:Z5REVOGA})
Endif
IF MOVNOTA:Z5GARANT != NIL
	aadd(aInfoSZ5,{"Z5_GARANT" ,MOVNOTA:Z5GARANT})
Endif
IF MOVNOTA:Z5CERTIF != NIL
	aadd(aInfoSZ5,{"Z5_CERTIF" ,MOVNOTA:Z5CERTIF})
Endif
IF MOVNOTA:Z5GRUPO != NIL
	aadd(aInfoSZ5,{"Z5_GRUPO" ,MOVNOTA:Z5GRUPO})
Endif
IF MOVNOTA:Z5DESGRU != NIL
	aadd(aInfoSZ5,{"Z5_DESGRU" ,MOVNOTA:Z5DESGRU})
Endif
IF MOVNOTA:Z5TIPVOU != NIL
	aadd(aInfoSZ5,{"Z5_TIPVOU" ,MOVNOTA:Z5TIPVOU})
Endif

IF MOVNOTA:Z5CODVOU != NIL
	aadd(aInfoSZ5,{"Z5_CODVOU" ,MOVNOTA:Z5CODVOU})
Endif

IF MOVNOTA:Z5CODAC != NIL
	aadd(aInfoSZ5,{"Z5_CODAC" ,MOVNOTA:Z5CODAC})
Endif

IF MOVNOTA:Z5DESCAC != NIL
	aadd(aInfoSZ5,{"Z5_DESCAC" ,MOVNOTA:Z5DESCAC})
Endif

IF MOVNOTA:Z5CODARP != NIL
	aadd(aInfoSZ5,{"Z5_CODARP" ,MOVNOTA:Z5CODARP})
Endif

IF MOVNOTA:Z5DESCARP != NIL
	aadd(aInfoSZ5,{"Z5_DESCARP" ,MOVNOTA:Z5DESCARP})
Endif

IF MOVNOTA:Z5REDE != NIL
	aadd(aInfoSZ5,{"Z5_REDE" ,MOVNOTA:Z5REDE})
Endif

IF MOVNOTA:Z5CPFT != NIL
	aadd(aInfoSZ5,{"Z5_CPFT" ,MOVNOTA:Z5CPFT})
Endif

IF MOVNOTA:Z5NTITULA != NIL
	aadd(aInfoSZ5,{"Z5_NTITULA" ,MOVNOTA:Z5NTITULA})
Endif

IF MOVNOTA:Z5CNPJV != NIL
	aadd(aInfoSZ5,{"Z5_CNPJV" ,MOVNOTA:Z5CNPJV})
Endif   

IF MOVNOTA:Z5RSVAL != NIL
	aadd(aInfoSZ5,{"Z5_CNPJV" ,MOVNOTA:Z5RSVAL})
Endif

// VarInfo("MOVNOTA",aInfoSZ5)

// WebService em Modo assincrono
// Distribui a requisicao usando Send2Proc
// Repassa codigo do pedido / identificador
// Retorno IMEDIATO : 
// Positivo caso a requsicao tenha sido dostribuida
// Negativo caso a chave Z5PEDGAR esteja vazia, 
// ou caso a distribuicao nao tenha sido distribuida ( falta de agentes disponiveis ) 

If Empty(MOVNOTA:Z5PEDGAR)
	
	RESPONSE:OK 	   := .F.
	RESPONSE:DETAILSTR := "Requisicao invalida. Chave Z5PEDGAR nao preenchida"

ElseIf !(Substr(time(),1,5) <= cBreakIni  .AND. Substr(time(),1,5) >= cBreakFim)
	RESPONSE:OK 	   := .F.
	RESPONSE:DETAILSTR := "Solicitacao dentro do Horário restrito de "+cBreakIni+" ate "+cBreakFim			
Else
	
	If U_Send2Proc(cGtId,"U_GARA130J",MOVNOTA:Z5PEDGAR,aInfoSZ5)
		
		// Grava no log de entrada que uma requisicao de nota fiscal 
		// foi recebida  e distribuida
		U_GTPutIN(cGtId,"E",MOVNOTA:Z5PEDGAR,.T.,{"U_GARA130J",MOVNOTA:Z5PEDGAR,aInfoSZ5})

		RESPONSE:OK 	   := .T.
		
	Else
		
		// Grava que a requisicao foi recebida mas nao foi distribuida 
		U_GTPutIN(cGtId,"E",MOVNOTA:Z5PEDGAR,.F.,{"U_GARA130J",MOVNOTA:Z5PEDGAR,aInfoSZ5})

		RESPONSE:OK 	   := .F.
		RESPONSE:DETAILSTR := "Nao foi possivel distribuir a requisicao. Tente novamente mais tarde."
		
	Endif
	
Endif

Return .T.