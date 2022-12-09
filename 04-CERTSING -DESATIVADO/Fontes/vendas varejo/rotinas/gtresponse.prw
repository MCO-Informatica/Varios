#INCLUDE 'PROTHEUS.CH'

// RELEASE 20091221

// Funcao de retorno - Notifica status de pedido para o gerenciador trabsacional
// WSMETHOD NotifyOrderEvent WSSEND oWSorderEvent WSRECEIVE oWSNotifyOrderEventResult WSCLIENT WSServiceBus
// recebe codigo do pedido e aRet com status

// ALteracoes em 21/12 -
// Alteracoes no Webservice de retorno !!
// Novos codigos de mensagem !

// Release 20091222
// Tratamentos adicionais de log de eventos e retorno

/*
Tabela 01

Codigos de Eventos de Retorno

PurchaseOrderAccepted Pedido aceito pelo ERP com sucesso ERP
--> PEdido recebido

PurchaseOrderRejected Pedido rejeitado pelo ERP
--> Deu crica ao processar o pedido

ERP PurchaseOrderAltered Alteração de dados do pedido ERP
--> Usado para notifcar emissao da nota , em caso de sucesso ou erro

PurchaseOrderCancelled	Cancelamento do pedido ERP
--> Pendente .. Tratamento a inserir no ERP

// Dados dos eventos de notificacao

WSDATA   nAttemptsProcessing       AS int OPTIONAL
WSDATA   cEvent                    AS string OPTIONAL  // Evento, vide tabela 01
WSDATA   cEventCode                AS string OPTIONAL  // Codigo do erro
WSDATA   cEventData                AS string OPTIONAL  // Descricao adicional do erro / ocorrencia
WSDATA   cEventDateTime            AS dateTime OPTIONAL  // data e hora do evento
WSDATA   cLastTry                  AS dateTime OPTIONAL  // data e hora da ultima tentativa
WSDATA   cSender                   AS string OPTIONAL    // Quem enviou ? Verificar ...
WSDATA   cTraceError               AS string OPTIONAL    // Verificar ...

Exemplo de pacote retornado

<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
<s:Body>
<NotifyOrderEventResponse xmlns="http://tempuri.org/">
<NotifyOrderEventResult xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<EventArgs>
<AttemptsProcessing>0</AttemptsProcessing>
<Event>PurchaseOrderRejected</Event>
<EventCode>0</EventCode>
<EventData i:nil="true"/>
<EventDateTime i:nil="true"/>
<LastTry i:nil="true"/>
<Sender i:nil="true"/>
<TraceError i:nil="true"/>
</EventArgs>
<Document>
<Invoices i:nil="true"/>
<OrderData i:nil="true"/>
<OrderId>50010     </OrderId>
<OrderItems i:nil="true"/>
</Document>
</NotifyOrderEventResult>
</NotifyOrderEventResponse>
</s:Body>
</s:Envelope>

VERIFICAR : Se EventCode vier com algo diferente de 0 (zero), deu crica ...

*/


/* --------------------------------------------------------------------
Funcao chamada para dar um retorno apos a inclusao de um pedido 
-------------------------------------------------------------------- */

USER Function GTRetPed(cGTId,aRet)
Local oWSRet
Local cWsUsr := getjobprofstring("GTRESPONSEURL","http://certisign.vtexlab.com.br/GerenciadorTransacional/GerenciadorTransacional.svc")
Local lDebug := (getjobprofstring("GTRESPONSEDEBUG","1") == '1')
Local lOk    := .F.
Local aEventCode

oWSRet := WSServiceBus():New()

// coloca a URL onde esta o gerenciador transacional para devolver o retorno
OWSRet:_URL := cWsUsr

If lDebug
	// Liga modo de debug para client de webservices para devolver rerorno
	// Para o
	WSDLDbgLevel(3)
Else
	// Debug nao esta ligado ? desliga entao ...
	WSDLDbgLevel(0)
Endif

oWSRet:oWSorderEvent:oWSEventArgsService := ServiceBus_EventArgsService():New()
oWSRet:oWSorderEvent:oWSOrder := ServiceBus_Order():New()

If aRet[1]   

	// tudo certo, informa que aceitou o pedido
	oWSRet:oWSorderEvent:oWSEventArgsService:cEvent 		:= 'PurchaseOrderAccepted'
	oWSRet:oWSorderEvent:oWSOrder:cOrderId 					:= aRet[3] // Codigo do pedido

Else

	aEventCode := RetCodes(aRet[2] )

	// Houve algum erro  ...
	// Retorna codigo e descricao de messageria combinada
	oWSRet:oWSorderEvent:oWSEventArgsService:cEvent 		:= 'PurchaseOrderRejected'
	oWSRet:oWSorderEvent:oWSEventArgsService:cEventCode 	:= aEventCode[1] // Codigo de erro ou evento
	oWSRet:oWSorderEvent:oWSEventArgsService:cEventData		:= aEventCode[2] // Descricao adicional.. sera mostrado ao usuario..
	oWSRet:oWSorderEvent:oWSOrder:cOrderId 					:= aRet[3] // Codigo do pedido

Endif

lOk := oWSRet:NotifyOrderEvent()

xInfo := ''

If !lOk
	
	// Algum problema de comunicacao ou processamento 
	xInfo := getwscerror()
	
Else
	
	// PENDENTE
	// A requisicao foi enviada. Verificar o retorno ...
	// Pode ter dado algo errado ... que necessite reenviar ... 
	// WSMETHOD NotifyOrderEvent WSSEND oWSorderEvent WSRECEIVE oWSNotifyOrderEventResult WSCLIENT WSServiceBus
	
	xInfo := varinfo("OWSRET",oWSRet:oWSNotifyOrderEventResult,,.f.,.f.)
	
Endif

// Atualiza status de saida
U_GTUpdOut(cGTId,lOk,xInfo)

Return lOk


/* -----------------------------------------------------------------------
Funcao GtRetNFF - Retorno da emissao da Nota Fiscal 
Prefeitura e/ou Entrega Futura
Chamada para dar um retorno apos a inclusao do pedido
----------------------------------------------------------------------- */

USER Function GTRetNFF(cGTId,aRet)

Local oWSRet
Local cXmlData := ''
Local cWsUsr := getjobprofstring("GTRESPONSEURL","http://certisign.vtexlab.com.br/GerenciadorTransacional/GerenciadorTransacional.svc")
Local lDebug := (getjobprofstring("GTRESPONSEDEBUG","1") == '1')  
Local aURIPrefSefaz := {"","","","","",""}
Local cPathRet
Local aEventCode      
Local aCodeTmp

// Path de retorno, onde serao gravadas as imagens / espelhos da nota ( PDF ) 
cPathRet := GetNewPar("MV_COMPNF","http://192.168.16.30/espelhonf/")

oWSRet := WSServiceBus():New()

// coloca a URL onde esta o gerenciador transacional para devolver o retorno
OWSRet:_URL := cWsUsr

If lDebug
	// Liga modo de debug para client de webservices para devolver rerorno
	// Para o
	WSDLDbgLevel(3)
Else
	// Debug nao esta ligado ? desliga entao ...
	WSDLDbgLevel(0)
Endif

oWSRet:oWSorderEvent:oWSEventArgsService 	:= ServiceBus_EventArgsService():New()
oWSRet:oWSorderEvent:oWSOrder 	  			:= ServiceBus_Order():New()

aEventCode := RetCodes( aRet[2] )

If len(aRet) > 3 .and. cPathRet $ aRet[4]

	// Verifica se no quarto elemento do aRet chegou 
	// um caminho do espelho da nota fiscal

	// Ajusta virgulas "coladas" para montar os retornos 
	cTemp := aRet[4]
	If left(cTemp,1) == ','
		cTemp := ' '+cTemp
	Endif
	While ",," $ cTemp
		cTemp := strtran(cTemp,",,",", ,")
	Enddo

	aURIPrefSefaz := strtokarr(cTemp,",")
//	varinfo("URIS PREF-F",aUriPrefSefaz)
	
	// Formato novo 
	// 1 t ou f, prefeitura
	// 2 = codigo de evento
	// 3 = URI da nota Prefeitura

	// 4 = t ou f, sefaz
	// 5 = codigo de evento 
	// 6 = URI da nota Sefaz

Else

//	conout("URIs nao recebidas para requisicao "+cGTId)

Endif

	
// Monta pacote xml informando espelhos das notas emitidas
IF !empty(aURIPrefSefaz[1])	 .or. !empty(aURIPrefSefaz[4])
	
//	varinfo("aURIPrefSefaz",aURIPrefSefaz)

	// Sempre monta o pacote, havendo impressao da nota ou nao ... 
	//se chegou uma ou mais urls dos arquivos impressos, sempre serao enviados ... 

	cXmlData := ''
	cXmlData += '<PurchaseOrder>'
	cXmlData += '<Invoices>'
	
	// Nota para a Prefeitura 
	If !empty(aURIPrefSefaz[1])
		cXmlData += '<Invoice>'  // (O elemento Id poderá conter os valores “Prefeitura” ou “Sefaz”)
		cXmlData += '<Id>Prefeitura</Id>'
		If aURIPrefSefaz[1] != "T"
			// deu algo de errado, acrescenta codigos
			aCodeTmp := RetCodes( aURIPrefSefaz[2] )
			cXmlData += '<EventCode>'+aCodeTmp[1]+'</EventCode>' 
			cXmlData += '<EventData>'+aCodeTmp[2]+'</EventData>'
		Endif
		If !empty(aURIPrefSefaz[3])
			cXmlData += '<Uri>'+aURIPrefSefaz[3]+'</Uri>'
		Endif
		cXmlData += '</Invoice>'
	Endif
	
	// Nota Sefaz - Entrega futura 
	If !empty(aURIPrefSefaz[4])
		cXmlData += '<Invoice>'
		cXmlData += '<Id>SefazEntregaFutura</Id>'
		If aURIPrefSefaz[4] != "T"
			// deu algo de errado, acrescenta codigos
			aCodeTmp := RetCodes( aURIPrefSefaz[5] )
			cXmlData += '<EventCode>'+aCodeTmp[1]+'</EventCode>' 
			cXmlData += '<EventData>'+aCodeTmp[2]+'</EventData>'
		Endif
		If !empty(aURIPrefSefaz[6])
			cXmlData += '<Uri>'+aURIPrefSefaz[6]+'</Uri>'
		Endif
		cXmlData += '</Invoice>'
	Endif
	cXmlData += '</Invoices>'
	cXmlData += '</PurchaseOrder>'
	
Endif

If aRet[1]

	oWSRet:oWSorderEvent:oWSOrder:cOrderId 		:= aRet[3] // Codigo do pedido
	oWSRet:oWSorderEvent:oWSOrder:cOrderData 	:= cXmlData
	
	oWSRet:oWSorderEvent:oWSEventArgsService:cEvent := 'PurchaseOrderAltered'
	
Else
	
	// Houve algum erro  ...
	// Basta setar eventcode ...
	// e enviar detalhes do erro
	
	oWSRet:oWSorderEvent:oWSOrder:cOrderId := aRet[3] // Codigo do Pedido
	oWSRet:oWSorderEvent:oWSOrder:cOrderData := cXmlData
	
	oWSRet:oWSorderEvent:oWSEventArgsService:cEvent := 'PurchaseOrderAltered'
	oWSRet:oWSorderEvent:oWSEventArgsService:cEventCode := aEventCode[1]
	oWSRet:oWSorderEvent:oWSEventArgsService:cEventData := aEventCode[2]
	
Endif

// Envia a requisicao ...
lOk := oWSRet:NotifyOrderEvent()
xInfo := ''

If !lOk
	
	xInfo := GetWSCerror()
	
Else
	
	// PENDENTE
	// A requisicao foi enviada. Verificar o retorno ...
	// WSMETHOD NotifyOrderEvent WSSEND oWSorderEvent WSRECEIVE oWSNotifyOrderEventResult WSCLIENT WSServiceBus
	
	xInfo := varinfo("OWSRET",oWSRet:oWSNotifyOrderEventResult,,.f.,.f.)
	
Endif

// Atualiza status de saida
U_GTUpdOut(cGTId,lOk,xInfo)

Return lOk


/* -----------------------------------------------------------------------
Funcao GtRetNFE - Retorno da emissao
Nota Fiscal Entrega Efetiva
----------------------------------------------------------------------- */

USER Function GTRetNFE(cGTId,aRet)

Local oWSRet
Local cXmlData := ''
Local cWsUsr := getjobprofstring("GTRESPONSEURL","http://certisign.vtexlab.com.br/GerenciadorTransacional/GerenciadorTransacional.svc")
Local lDebug := (getjobprofstring("GTRESPONSEDEBUG","1") == '1')
Local cURINotaefetiva
Local cPathRet

// Path de retorno, onde serao gravadas as imagens / espelhos da nota ( PDF ) 
cPathRet := GetNewPar("MV_COMPNF","http://192.168.16.30/espelhonf/")

oWSRet := WSServiceBus():New()

// coloca a URL onde esta o gerenciador transacional para devolver o retorno
OWSRet:_URL := cWsUsr

If lDebug
	// Liga modo de debug para client de webservices para devolver rerorno
	// Para o
	WSDLDbgLevel(3)
Else
	// Debug nao esta ligado ? desliga entao ...
	WSDLDbgLevel(0)
Endif

oWSRet:oWSorderEvent:oWSEventArgsService 	:= ServiceBus_EventArgsService():New()
oWSRet:oWSorderEvent:oWSOrder 	  			:= ServiceBus_Order():New()

aEventCode := RetCodes(aRet[2] )

If len(aRet) > 3 .and. cPathRet $ aRet[4]
	
	cURINotaefetiva := aRet[4]
	
	If left(cURINotaefetiva,1) == ','
		// Ajuste : Se a nota efetiva vier com uma ","
		// no comeco, remove a virtula
		cURINotaefetiva := substr(cURINotaefetiva,2)
	Endif
	
//	varinfo("URI EFETIVA",cURINotaefetiva)
	
Else
	
//	conout("URIs nao recebidas para Entrega Efetiva - Requisicao "+cGTId)
	
Endif


// Sempre monta o pacote, havendo impressao da nota ou nao ...
//se chegou uma ou mais urls dos arquivos impressos, sempre serao enviados ...

cXmlData := ''
cXmlData += '<PurchaseOrder>'
cXmlData += '<Invoices>'

// Nota Sefaz - Entrega efetiva
cXmlData += '<Invoice>'  // (O elemento Id poderá conter os valores “Prefeitura” ou “Sefaz”)
cXmlData += '<Id>Sefaz</Id>'

If !aRet[1]
	// deu algo de errado, acrescenta codigos
	cXmlData += '<EventCode>'+aEventCode[1]+'</EventCode>'
	cXmlData += '<EventData>'+aEventCode[2]+'</EventData>'
Endif

If !empty(cURINotaefetiva)
	cXmlData += '<Uri>'+cURINotaefetiva+'</Uri>'
Endif

cXmlData += '</Invoice>'
cXmlData += '</Invoices>'
cXmlData += '</PurchaseOrder>'


// Com erro ou nao , o pacote de retorno vai ser o mesmo
// o que vai informar uma condicao de erro sao
// os event codes dentro do ORderData

oWSRet:oWSorderEvent:oWSOrder:cOrderId 		:= aRet[3] // Codigo do pedido
oWSRet:oWSorderEvent:oWSOrder:cOrderData 	:= cXmlData
oWSRet:oWSorderEvent:oWSEventArgsService:cEvent := 'PurchaseOrderAltered'

// Envia a requisicao ...
lOk := oWSRet:NotifyOrderEvent()
xInfo := ''

If !lOk
	
	xInfo := GetWSCerror()
	
Else
	
	// PENDENTE
	// A requisicao foi enviada. Verificar o retorno ...
	// WSMETHOD NotifyOrderEvent WSSEND oWSorderEvent WSRECEIVE oWSNotifyOrderEventResult WSCLIENT WSServiceBus
	
	xInfo := varinfo("OWSRET",oWSRet:oWSNotifyOrderEventResult,,.f.,.f.)
	
Endif

// Atualiza status de saida
U_GTUpdOut(cGTId,lOk,xInfo)

Return lOk


/* ==================================================================
Funcao de criacao das tabelas de retencao e logs
================================================================== */
User Function GTSetUp()
Local aStru :=  {}
Local aIndex     := {}
Local aStruct    := {}
Local cTable     := 'GTLOG'
Local cIndexName := ''
Local nLoop      := 0
Local aStructAtu := {}
Local nP := 0
Local lAlter := .F.
Local lContinue := .T.


If !tccanopen('GTIN')
	
	// Cria a tabela caso nao exista
	aStru :=  {}
	aadd(aStru,{"GT_ID","C",24,0})
	aadd(aStru,{"GT_TYPE","C",1,0})
	aadd(aStru,{"GT_DATE","D",8,0})
	aadd(aStru,{"GT_TIME","C",8,0})
	aadd(aStru,{"GT_PEDGAR","C",10,0})
	aadd(aStru,{"GT_PARAM","M",10,0})
	aadd(aStru,{"GT_SEND","L",1,0})     // Encaminhado para processo
	aadd(aStru,{"GT_INPROC","L",1,0})   // Ja estava em processamento ?
	aadd(aStru,{"GT_XNPSITE","C",10,0})
	aadd(aStru,{"GT_CARTAO","C",16,0})
	aadd(aStru,{"GT_LDIGIT","C",54,0})
	aadd(aStru,{"GT_VOUCHER","C",15,0})
	aadd(aStru,{"GT_CCDOC","C",16,0})
	aadd(aStru,{"GT_CCCONF","C",16,0})
	aadd(aStru,{"GT_CCAUT","C",16,0})

//	conout("Criando tabela de entrada GTIN")
	DbCreate('GTIN',aStru,"TOPCONN")	
Endif

If !TcCanOpen('GTIN','GTIN01' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de entrada GTIN01")
	
	USE GTIN ALIAS GTIN EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTIN em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON DTOS(GT_DATE) + GT_TIME + GT_TYPE + GT_PEDGAR TO ("GTIN01")
	
	USE
	
Endif

If !TcCanOpen('GTIN','GTIN02' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de entrada GTIN02")
	
	USE GTIN ALIAS GTIN EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTIN em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON GT_ID TO ("GTIN02")
	
	USE
	
Endif

If !tccanopen('GTOUT')
	
	// Cria a tabela caso nao exista
	aStru :=  {}
	aadd( aStru, {"GT_ID",		"C",	24,	0} )
	aadd( aStru, {"GT_TYPE",	"C",	01,	0} )	// Tipo do metodo que foi executado "P"=incpedido (o tipo F estah imbutido neste metodo), "E"=geranota
	aadd( aStru, {"GT_DATE",	"D",	08,	0} )
	aadd( aStru, {"GT_TIME",	"C",	08,	0} )
	aadd( aStru, {"GT_PEDGAR",	"C",	10,	0} )	// Numero do pedido do GAR
	aadd( aStru, {"GT_CODMSG",	"C",	06,	0} )	// Codigo da mensagem devolvida para o GAR
	aadd( aStru, {"GT_STATUS",	"C",	01,	0} )	// ("S" retornou tudo OK) ("N" retornou alguma coisa com problema)
	aadd( aStru, {"GT_ULTIMO",	"C",	01,	0} )	// ("S" representa a ultima transação ocorrida) ("N" historico das transacoes que aconteceram mas nao eh a ultima)
	aadd( aStru, {"GT_RETURN",	"M",	10,	0} )	// Guarda o conteudo dos arrays de retorno onde TYPE="E" (um array) TYPE="P" (dois arrays)
	aadd( aStru, {"GT_DRET",	"D",	08,	0} )
	aadd( aStru, {"GT_TRET",	"C",	08,	0} )
	aadd( aStru, {"GT_SEND",	"L",	01,	0} )	// Conseguiu enviar devolucao
	aadd( aStru, {"GT_CARTAO",  "C",    16, 0} )
	aadd( aStru, {"GT_LDIGIT",  "C",    56, 0} )
	aadd( aStru, {"GT_VOUCHER", "C",    15, 0} )
	aadd( aStru, {"GT_INFO",	"M",	10,	0} )
	aadd( aStru, {"GT_TIMDES",	"C",	14,	0} )	// Time do descarte 20100325092633
	aadd( aStru, {"GT_USRDES",	"C",	50,	0} )	// Nome do usuario que descartou o pedido com problema
	aadd( aStru, {"GT_MOTDES",	"M",	10,	0} )	// Motivo do descarte
	
//	conout("Criando tabela de saida GTOUT")
	DbCreate('GTOUT',aStru,"TOPCONN")
	
Endif

If !TcCanOpen('GTOUT','GTOUT01' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de saida GTOUT01")
	
	USE GTOUT ALIAS GTOUT EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTOUT em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON DTOS(GT_DATE) + GT_TIME + GT_TYPE + GT_PEDGAR TO ("GTOUT01")
	
	USE
	
Endif

If !TcCanOpen('GTOUT','GTOUT02' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de saida GTOUT02")
	
	USE GTOUT ALIAS GTOUT EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTOUT em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON GT_ID TO ("GTOUT02")
	
	USE
	
Endif

If !TcCanOpen('GTOUT','GTOUT03' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de saida GTOUT03")
	
	USE GTOUT ALIAS GTOUT EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTOUT em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON GT_PEDGAR+GT_ULTIMO+GT_STATUS TO ("GTOUT03")
	
	USE
	
Endif


If !tccanopen('GTRET')
	
	// Cria a tabela caso nao exista
	aStru :=  {}
	aadd(aStru,{"GT_ID","C",24,0})
	aadd(aStru,{"GT_TYPE","C",1,0})
	aadd(aStru,{"GT_DATE","D",8,0})
	aadd(aStru,{"GT_TIME","C",8,0})
	aadd(aStru,{"GT_STAT","L",1,0})
	aadd(aStru,{"GT_RETRY","N",2,0})
	aadd(aStru,{"GT_PEDGAR","C",10,0})
	aadd(aStru,{"GT_RETCODE","C",6,0})
	aadd(aStru,{"GT_RETSTR","M",10,0})
//	conout("Criando tabela de retorno GTRET")
	DbCreate('GTRET',aStru,"TOPCONN")
	
Endif

If !TcCanOpen('GTRET','GTRET01' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de retorno GTRET01")
	
	USE GTRET ALIAS GTRET EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTRET em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON DTOS(GT_DATE) + GT_TIME + GT_TYPE TO ("GTRET01")
	
	USE
	
Endif

If !TcCanOpen('GTRET','GTRET02' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de saida GTRET02")
	
	USE GTRET ALIAS GTRET EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTRET em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON GT_ID TO ("GTRET02")
	
	USE
	
Endif

//If !tccanopen('GTLOG')
	// Cria a tabela caso nao exista
	//aStru :=  {}
	//aadd(aStru,{"GT_DATE"  ,"D",8,0})
	//aadd(aStru,{"GT_TIME"  ,"C",8,0})
	//aadd(aStru,{"GT_ONLINE","L",1,0})
	//aadd(aStru,{"GT_INFO"  ,"C",250,0})
	//	conout("Criando tabela de log de status GTLOG")
	//DbCreate('GTLOG',aStru,"TOPCONN")
//Endif

// Esta nova estrutura de tabela e suas dependências irão
// suportar a integração da aplicação java com a aprovação
// de pedido de compras.
AAdd( aStruct, { 'GT_IDOPER' , 'C',  9, 0 } ) // Id operação.
AAdd( aStruct, { 'GT_DTOPER' , 'D',  8, 0 } ) // Data da operação.
AAdd( aStruct, { 'GT_ACAO'   , 'C',  1, 0 } ) // Ação da operação (A = aprovado; R=reprovado; L=Log).
AAdd( aStruct, { 'GT_EMAIL'  , 'C', 60, 0 } ) // Email do aprovador.
AAdd( aStruct, { 'GT_MOTIVO' , 'M', 10, 0 } ) // Motivo/Justificativa da ação.
AAdd( aStruct, { 'GT_CODAPRO', 'C',  6, 0 } ) // Código do aprovador.
AAdd( aStruct, { 'GT_CODUSER', 'C',  6, 0 } ) // Código do usuário.
AAdd( aStruct, { 'GT_FILPC'  , 'C',  2, 0 } ) // Código da filial da operação.
AAdd( aStruct, { 'GT_NUMPC'  , 'C',  6, 0 } ) // Número do pedido de compras.
AAdd( aStruct, { 'GT_PARAM'  , 'M', 10, 0 } ) // Parâmetros XML recebidos.
AAdd( aStruct, { 'GT_SEND'   , 'C',  1, 0 } ) // Identificador de processo (F = recebido; T = processado )
AAdd( aStruct, { 'GT_INIPROC', 'C',  1, 0 } ) // Identificador de processamento (F = não foi processado.
                                              //                                 T = foi processado com sucesso.
                                              //                                 1 = Pedido não localizado.
                                              //                                 2 = Alçada não lozalizada.
                                              //                                 3 = Penência de alçada não lozalizada.
                                              //                                 4 = Penência de alçada não lozalizada.)
AAdd( aStruct, { 'GT_DTPROC' , 'D',  8, 0 } ) // Data do processamento
AAdd( aStruct, { 'GT_HRPROC' , 'C',  8, 0 } ) // Hora do processamento
AAdd( aStruct, { 'GT_LOG'    , 'M', 10, 0 } ) // log de processamento

//-----------------------------------
// novos campos criados em agosto/17.
AAdd( aStruct, { 'GT_FILIAL' , 'C',  2, 0 } ) // Código da filial da operação.
AAdd( aStruct, { 'GT_DOCTO'  , 'C', 50, 0 } ) // Número do documento.
AAdd( aStruct, { 'GT_TPDOC'  , 'C',  2, 0 } ) // Tipo do documento, podendo ser: SC|PC|CT
                                              //                                 |  |  +---> contratos.
                                              //                                 |  +------> pedido de compras.
                                              //                                 +---------> solicitação de compras.
//-----------------------------------------------------------
// Os campos abaixo permanecerão apenas para manter o legado.
AAdd( aStruct, { 'GT_DATE'  , 'D',  8, 0 } )
AAdd( aStruct, { 'GT_TIME'  , 'C',  8, 0 } )
AAdd( aStruct, { 'GT_ONLINE', 'L',  1, 0 } )
AAdd( aStruct, { 'GT_INFO'  , 'C',250, 0 } )

If !TcCanOpen( cTable )
	dbCreate( cTable, aStruct, 'TOPCONN' )
Endif

If Select('GTLOG') <= 0
	STATICCALL( CSFA610, A610UseGTL )
Endif

aStructAtu := GTLOG->( DbStruct() )

// Todos os campos do vetor existem na tabela fisicamente?
For nLoop := 1 To Len( aStruct )
	nP := AScan( aStructAtu, {|e| e[ 1 ] == aStruct[ nLoop, 1 ] } )
	If nP == 0
		lAlter := .T.
		Exit
	Endif
Next nI

If lAlter
	DbSelectArea( 'GTLOG' )
	DbCloseArea()
	If .NOT. TcAlter( 'GTLOG', aStructAtu, aStruct )
		lContinue := .F.
	Endif
Endif	

If lContinue
	If Select('GTLOG') > 0
		DbSelectArea( 'GTLOG' )
		DbCloseArea()
	Endif
	
	AAdd( aIndex, 'GT_IDOPER+GT_FILPC+GT_NUMPC')                        //01
	AAdd( aIndex, 'GT_FILPC+GT_NUMPC+GT_CODUSER+GT_CODAPRO' )           //02
	AAdd( aIndex, 'GT_CODAPRO+GT_CODUSER' )                             //03
	AAdd( aIndex, 'GT_CODUSER+GT_CODAPRO' )                             //04
	AAdd( aIndex, 'GT_SEND+GT_INIPROC' )                                //05
	AAdd( aIndex, 'GT_IDOPER+GT_FILIAL+GT_DOCTO+GT_TPDOC')              //06 - novo, feito em agosto/17.
	AAdd( aIndex, 'GT_FILIAL+GT_DOCTO+GT_TPDOC+GT_CODUSER+GT_CODAPRO' ) //07 - novo, feito em agosto/17.
	
	For nLoop := 1 To Len( aIndex )
		cIndexName := cTable + StrZero( nLoop, 2, 0 )
		If .NOT. TcCanOpen( cTable, cIndexName )
			USE &(cTable) ALIAS &(cTable) EXCLUSIVE NEW VIA 'TOPCONN'
			If NetErr()
				UserExecption('Falha ao abrir '+cTable+' em modo exclusivo para criação do índice ['+cIndexName+' -> '+aIndex[ nLoop ]+']')
			Endif
			INDEX ON &(aIndex[ nLoop ]) TO (cIndexName)
			USE
		Endif
	Next nLoop
Endif

/******
 *
 * Estrutura da tabela de dados de LOG entre a comunicação do RigthNow e Protheus.
 * 07/05/2018 - Robson Gonçalves - Rleg.
 * -------------------------------------------------------------------------------
 * Tipos de registros que serão gravados.
 * RigthNow solicita um token.
 * Protheus devolve o toke ou alguma rejeição.
 * RightNow requisita dados do cliente.
 * Protheus devolve os dados solicitados se encontrar.
 * RightNow requisita dados do agente de registro.
 * Protheus devolve os dados solicitados se encontrar.
 * 
 */
 
cTable := 'GTRNOW'
aStruct := {}
aStructAtu := {}
lContinue := .T.
aIndex := {}

AAdd( aStruct, { 'GT_ID'     , 'C',  10, 0 } ) //Id da operação.
AAdd( aStruct, { 'GT_DATA'   , 'D',  08, 0 } ) //Data da operação.
AAdd( aStruct, { 'GT_HORA'   , 'C',  08, 0 } ) //Hora da operação.
AAdd( aStruct, { 'GT_ACAO'   , 'C',  30, 0 } ) //Ação da operação.
AAdd( aStruct, { 'GT_SERVICE', 'C',  30, 0 } ) //Serviço solicitado da operação.
AAdd( aStruct, { 'GT_PARAM'  , 'M',  10, 0 } ) //Parâmetros solicitados.
AAdd( aStruct, { 'GT_RETURN' , 'M',  10, 0 } ) //Retorno de dados ou mensagem devolvida.
AAdd( aStruct, { 'GT_TMPINI' , 'C',  12, 0 } ) //Hora início do processamento. HH:MM:SS.Milesegundos
AAdd( aStruct, { 'GT_TMPFIM' , 'C',  12, 0 } ) //Hora fim do processamento.    HH:MM:SS.Milesegundos
AAdd( aStruct, { 'GT_TMPDECO', 'C',  09, 0 } ) //Tempo decorrido de todo o processo.

If .NOT. TcCanOpen( cTable )
	dbCreate( cTable, aStruct, 'TOPCONN' )
Endif

If Select( cTable ) > 0
	DbSelectArea( cTable )
	DbCloseArea()
Endif

AAdd( aIndex, 'GT_ID+Dtos(GT_DATA)+GT_HORA')

For nLoop := 1 To Len( aIndex )
	cIndexName := cTable + StrZero( nLoop, 2, 0 )
	If .NOT. TcCanOpen( cTable, cIndexName )
		USE &(cTable) ALIAS &(cTable) EXCLUSIVE NEW VIA 'TOPCONN'
		If NetErr()
			UserExecption('Falha ao abrir '+cTable+' em modo exclusivo para criação do índice ['+cIndexName+' -> '+aIndex[ nLoop ]+']')
		Endif
		INDEX ON &(aIndex[ nLoop ]) TO (cIndexName)
		USE
	Endif
Next nLoop

If Select( cTable ) <= 0
	U_UseRightNow()
Endif

aStructAtu := (cTable)->( DbStruct() )

// Todos os campos do vetor existem na tabela fisicamente?
For nLoop := 1 To Len( aStruct )
	nP := AScan( aStructAtu, {|e| e[ 1 ] == aStruct[ nLoop, 1 ] } )
	If nP == 0
		lAlter := .T.
		Exit
	Endif
Next nI

If lAlter
	DbSelectArea( cTable )
	DbCloseArea()
	If .NOT. TcAlter( cTable, aStructAtu, aStruct )
		lContinue := .F.
	Endif
Endif	

/******
 *
 * Estrutura da tabela de dados de LOG entre a comunicação do AENet e Protheus.
 * 01/08/2018 - Robson Gonçalves - Rleg.
 * -------------------------------------------------------------------------------
 * Tipos de registros que serão gravados.
 * AENet solicita um token.
 * Protheus devolve o toke ou alguma rejeição.
 * AENet requisita dados do cliente.
 * Protheus devolve os dados solicitados se encontrar.
 * AENet requisita dados do agente de registro.
 * Protheus devolve os dados solicitados se encontrar.
 * 
 */
 
cTable := 'GTAENET'
aStruct := {}
aStructAtu := {}
lContinue := .T.
aIndex := {}

AAdd( aStruct, { 'GT_ID'     , 'C',  10, 0 } ) //Id da operação.
AAdd( aStruct, { 'GT_DATA'   , 'D',  08, 0 } ) //Data da operação.
AAdd( aStruct, { 'GT_HORA'   , 'C',  08, 0 } ) //Hora da operação.
AAdd( aStruct, { 'GT_ACAO'   , 'C',  30, 0 } ) //Ação da operação.
AAdd( aStruct, { 'GT_SERVICE', 'C',  30, 0 } ) //Serviço solicitado da operação.
AAdd( aStruct, { 'GT_PARAM'  , 'M',  10, 0 } ) //Parâmetros solicitados.
AAdd( aStruct, { 'GT_RETURN' , 'M',  10, 0 } ) //Retorno de dados ou mensagem devolvida.
AAdd( aStruct, { 'GT_TMPINI' , 'C',  12, 0 } ) //Hora início do processamento. HH:MM:SS.Milesegundos
AAdd( aStruct, { 'GT_TMPFIM' , 'C',  12, 0 } ) //Hora fim do processamento.    HH:MM:SS.Milesegundos
AAdd( aStruct, { 'GT_TMPDECO', 'C',  09, 0 } ) //Tempo decorrido de todo o processo.

If .NOT. TcCanOpen( cTable )
	dbCreate( cTable, aStruct, 'TOPCONN' )
Endif

If Select( cTable ) > 0
	DbSelectArea( cTable )
	DbCloseArea()
Endif

AAdd( aIndex, 'GT_ID+Dtos(GT_DATA)+GT_HORA')

For nLoop := 1 To Len( aIndex )
	cIndexName := cTable + StrZero( nLoop, 2, 0 )
	If .NOT. TcCanOpen( cTable, cIndexName )
		USE &(cTable) ALIAS &(cTable) EXCLUSIVE NEW VIA 'TOPCONN'
		If NetErr()
			UserExecption('Falha ao abrir '+cTable+' em modo exclusivo para criação do índice ['+cIndexName+' -> '+aIndex[ nLoop ]+']')
		Endif
		INDEX ON &(aIndex[ nLoop ]) TO (cIndexName)
		USE
	Endif
Next nLoop

If Select( cTable ) <= 0
	U_UseAENet()
Endif

aStructAtu := (cTable)->( DbStruct() )

// Todos os campos do vetor existem na tabela fisicamente?
For nLoop := 1 To Len( aStruct )
	nP := AScan( aStructAtu, {|e| e[ 1 ] == aStruct[ nLoop, 1 ] } )
	If nP == 0
		lAlter := .T.
		Exit
	Endif
Next nI

If lAlter
	DbSelectArea( cTable )
	DbCloseArea()
	If .NOT. TcAlter( cTable, aStructAtu, aStruct )
		lContinue := .F.
	Endif
Endif	

Return

User Function UseRightNow()
	USE GTRNOW ALIAS GTRNOW SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela GTRNOW - SHARED" )
	Endif
	dbSetIndex("GTRNOW01")
	dbSelectArea("GTRNOW")
	dbSetOrder(1)
Return

User Function UseAENet()
	USE GTAENET ALIAS GTAENET SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela AENET - SHARED" )
	Endif
	dbSetIndex("GTAENET01")
	dbSelectArea("GTAENET")
	dbSetOrder(1)
Return

/* --------------------------------------------------------------------
Funcao chamada pela casca de integracao com webservices assincronos
para retornar ao Gerenciador Transacional o status de uma operacao
Type P = Pedido  / F = Nota de Entrega Futura / E = de entrega efetiva
Ela grava na base de retorno pendente, para envio atraves do job de retencao
-------------------------------------------------------------------- */
USER Function GTPutRet(cGTId,cType,aRet)
Local cOldAlias := alias()

Default aRet := Array(3)

OpenGTEnv()

DbSelectArea("GTRET")

// Acrescrenta a pendencia de retorno na base para envio posterior
DbAppend(.F.)
GTRET->GT_ID        := cGTId
GTRET->GT_TYPE 		:= cType
GTRET->GT_DATE 		:= date()
GTRET->GT_TIME 		:= time()
GTRET->GT_STAT 		:= IiF ( aRet[1] <> NIL, aRet[1], .F. )
GTRET->GT_RETCODE   := IiF ( aRet[2] <> NIL, aRet[2], '' )
GTRET->GT_PEDGAR    := IiF ( aRet[3] <> NIL, aRet[3], '' )
If len(aRet) > 3
	GTRET->GT_RETSTR    := aRet[4]
Endif

//varinfo("GTPutRet",{cGTId,cType,aRet})

DBCommit()
Dbrunlock()

if !empty(cOldAlias)
	DbSelectArea(cOldAlias)
Endif

Return


/* --------------------------------------------------------------------
Funcao chamada pela casca de integracao com webservices assincronos
Chama assim que recebe uma requisicao.
Retorna um ID unico para rastrear
-------------------------------------------------------------------- */
User Function GTPutIN(cGtId,cType,cCodPed,lSend,aParam,cXNpSite, aDetPag, aXmlCC, aChkOut, cNpEcomm )
Local cOldAlias  := alias()
Local aDadFila   := {}         

//Detalhe do pagamento: 1=Cartao|2=Linha Digitavel|3=Voucher
// Cf. Solicitação Sr. Giovanni = 03/02/2014
Default aDetPag	:= {"","",""} 
Default aXmlCC	:= {"","",""}

Default cNpEcomm	:= ''

aDadFila := DadFila(cCodPed,cXNpSite)

If !Empty(aDadFila[1]) .and. Empty(cGtId)
	cGtId := aDadFila[1]
EndIf

If !Empty(aDadFila[2]) .and. Empty(cCodPed)
	cCodPed := aDadFila[2]
EndIf

If !Empty(aDadFila[3]) .and. Empty(cXNpSite)
	cXNpSite:= aDadFila[3]
EndIf

OpenGTEnv()

DbSelectArea("GTIN")
// Acrescrenta a pendencia de retorno na base para envio posterior
DbAppend(.F.)

GTIN->GT_ID         := cGTId
GTIN->GT_TYPE 		:= cType
GTIN->GT_DATE 		:= date()
GTIN->GT_TIME 		:= time()
GTIN->GT_PEDGAR		:= cCodPed
GTIN->GT_PARAM		:= VarInfo("",aParam,,.f.,.f.)
GTIN->GT_SEND     	:= lSend
GTIN->GT_XNPSITE   	:= cXNpSite
GTIN->GT_CARTAO		:= aDetPag[1]  
GTIN->GT_LDIGIT   	:= aDetPag[2]
GTIN->GT_VOUCHER   	:= aDetPag[3]
//Detalhe do pagamento: 1=Cartao|2=Linha Digitavel|3=Voucher
GTIN->GT_CCDOC		:= aXmlCC[1]  
GTIN->GT_CCCONF   	:= aXmlCC[2]
GTIN->GT_CCAUT   	:= aXmlCC[3]
GTIN->GT_XNPECOM   	:= cNpEcomm
//Detalhe do pagamento: 1=Documento|2=Confirmacao|3=Autorizacao

/******
 *
 * A instrução abaixo foi criada para gravar o CPF/CNPJ do contato e da ordem de pagamento.
 * A instrução abaixo é dependente da criação desta estrutura que está na função U_UpdGTIN() neste mesmo programa fonte.
 * A funcionalidade que envia dados para a instrução abaixo está no VNDA130.prw função U_VNDA130 fila "F".
 * Autor: Robson Gonçalves | Data: 26/06/2018 | Uso: Integração RightNow
 * Key: #alterargtin
 *
 */

If cType == "F"
	CONOUT("[GTIN] PARAMETRO aChkOut -> CAMPOS: [GT_CNPJCON,GT_CNPJFAT,GT_ORIGVEN]")
	CONOUT("[GTIN] VALTYPE: " + VALTYPE( aChkOut ) )
	
	If ValType( aChkOut ) == "A"
		CONOUT("[GTIN] LEN: " + LTRIM( STR( LEN( aChkOut ) ) ) )
		
		If Len( aChkOut ) > 0
			CONOUT("[GTIN] EFETUADO GRAVACAO NO CAMPO: GT_CNPJCON [" + aChkOut[ 1 ] + "]" )
			GTIN->GT_CNPJCON := aChkOut[ 1 ] //CNPJ DO CONTATO <contato><cpf ou cnpj>
		Else
			CONOUT("[GTIN] WARNING: NAO GRAVOU O GT_CNPJCON" )
		Endif
			
		If Len( aChkOut ) > 1
			CONOUT("[GTIN] EFETUADO GRAVACAO NO CAMPO: GT_CNPJFAT [" + aChkOut[ 2 ] + "]" )
			GTIN->GT_CNPJFAT := aChkOut[ 2 ] //CNPJ DO FATUTAENTO <fatura><cpf ou cnpj>
		Else
			CONOUT("[GTIN] WARNING: NAO GRAVOU O GT_CNPJFAT" )
		Endif
		
		If Len( aChkOut ) > 2
			CONOUT("[GTIN] EFETUADO GRAVACAO NO CAMPO: GT_ORIGVEN [" + aChkOut[ 3 ] + "]" )
			GTIN->GT_ORIGVEN := aChkOut[ 3 ] //Origem da venda <pagamento><origemVenda>
		Else
			CONOUT("[GTIN] WARNING: NAO GRAVOU O GT_ORIGVEN" )
		Endif
	Else
		CONOUT("[GTIN] WARNING: NAO GRAVOU OS REFERIDOS CAMPOS." )
	Endif
Endif

DBCommit()
Dbrunlock()

If !empty(cOldAlias)
	DbSelectArea(cOldAlias)
Endif

Return cGTId

/* ------------------------------------------------------------------
Grava o log de retorno de processamento, e se houve
envio do retorno ao GAR ou nao
------------------------------------------------------------------ */
User Function GTPutOUT(cGTId,cType,cCodPed,aReturn,cXNpSite,cNpEcomm)

Local cOldAlias	:= Alias()
Local nI		:= 0
Local cStatus	:= "S"
Local cPedGar	:= ""
Local cCodMsg	:= ""
Local aAux		:= {}
Local aDadFila	:= {}
Local cMailNot	:= ""
Local aEventCode:= {}
Local cCorpo	:= ""
Local nCont 	:= 1
Local lProcName	:= GetMv( 'GTOUTPROCN', , .F. )

Default cXNpSite	:= ''
Default cNpEcomm	:= ''

OpenGTEnv()

If ValType(aReturn[1]) == "C" .and. ValType(aReturn[2])=="A" .and. len(aReturn[2]) >=2
	aAux 	:= aReturn
	aReturn	:= {}
	aadd(aReturn,aAux)	
EndIf

For nI := 1 To Len(aReturn)
	If ValType(aReturn[nI])=="A" .AND. ValType(aReturn[nI][2])=="A"
	
		cPedGar	:= IIF(Len(aReturn[nI][2])>3,aReturn[nI][2][3],"")
		cCodMsg	:= IIF(Len(aReturn[nI][2])>2,aReturn[nI][2][2],"")
		If Len(aReturn	[nI][2]) > 1 .AND. !aReturn[nI][2][1]
			cStatus	:= "N"
			Exit
		Endif
	
	Endif
Next nI

aEventCode	:= RetCodes(cCodMsg)
cMailNot	:= aEventCode[3]

// Garante que a requisicao atual sera a unica marcada como ultima

TcSqlExec("UPDATE GTOUT SET GT_ULTIMO = 'N' WHERE GT_XNPSITE = '"+cXNpSite+"' AND GT_ULTIMO = 'S' AND GT_TYPE = '"+cType+"'  "   )

aDadFila := DadFila(cCodPed)

If !Empty(aDadFila[1]) .and. Empty(cGtId)
	cGtId := aDadFila[1]
EndIf

If !Empty(aDadFila[2]) .and. Empty(cCodPed)
	cPedGar := ""
	cCodPed := aDadFila[2]
EndIf

If !Empty(aDadFila[3]) .and. Empty(cXNpSite)
	cXNpSite:= aDadFila[3]
EndIf

DbSelectArea("GTOUT")

GTOUT->(RecLock('GTOUT',.T.))
GTOUT->GT_ID		:= cGTId
GTOUT->GT_TYPE		:= cType
GTOUT->GT_DATE		:= Date()
GTOUT->GT_TIME		:= Time()
GTOUT->GT_PEDGAR	:= IIF(Empty(cPedGar),cCodPed,cPedGar)
GTOUT->GT_CODMSG	:= cCodMsg
GTOUT->GT_STATUS	:= cStatus
GTOUT->GT_ULTIMO	:= "S"
GTOUT->GT_RETURN	:= VarInfo("",aReturn,,.F.,.F.)
GTOUT->GT_XNPSITE  	:= cXNpSite
GTOUT->GT_XNPECOM  	:= cNpEcomm
GTOUT->(MsUnlock())
GTOUT->( DBCommit() )


If !Empty(cOldAlias)
	DbSelectArea(cOldAlias)
Endif

If !Empty(cMailNot) 
	cFunProc:= Upper(Alltrim(ProcName(1)))
	cLineProc:= Alltrim(Str(ProcLine(1)))
	cIpSrv	:= GETSRVINFO()[1]
	cPortSrv:= GetPvProfString(GetPvProfString("DRIVERS","ACTIVE","TCP",GetADV97()),"PORT","0",GetADV97())
	cAmbSrv := GetEnvServer()
	// Envio e-mail para comunicar inconsistência de Processamento
	cCorpo	:= "*****Mensagem Automática, por favor não responda*****" + CRLF + CRLF
	cCorpo	+= "Foram encontradas Inconsistências no processamento de Pedido de Venda de acordo os dados abaixo:"+ CRLF + CRLF
	cCorpo	+= "Ambiente : " + cAmbSrv + CRLF	
	cCorpo	+= "Função de Processamento : " + cFunProc +" Linha: "+cLineProc+ CRLF	
	cCorpo	+= "Servidor Processamento : " + Alltrim(cIpSrv) + " Porta : "+Alltrim(cPortSrv) + CRLF	
	cCorpo	+= "Identificação da Fila : " + cGTId + CRLF	
	cCorpo	+= "Cód. da Etapa de Processamento : " + cType + CRLF		
	cCorpo	+= "Pedido: " + cCodPed + CRLF
	cCorpo	+= "Data: " + DtoC(Date()) + " Hora: "+Time()+ CRLF
	cCorpo	+= "Mensagem de Inconsistência: " + CRLF
	cCorpo	+= VarInfo("",aReturn,,.F.,.F.) + CRLF + CRLF

	IF lProcName
		//Enquanto houver procname que não estão em branco
		While !Empty(ProcName(nCont))
			//Escrevendo o número do procname e a descrição
			cCorpo	+= 'ProcName > '+StrZero(nCont, 6)+' - '+ProcName(nCont) + CRLF
			nCont++
		EndDo
	EndIF

	cCorpo	+= CRLF + "É necessário analisar a situação para que o processamento do pedido seja finalizado." + CRLF + CRLF
	cCorpo	+= "Agradecemos sua atenção," + CRLF
	cCorpo	+= "Equipe Certisign" + CRLF
	U_VNDA290(cCorpo, cMailNot, "[VENDAS_VAREJO] Inconsistência Processamento do Pedido - "+cCodPed)
EndIf

Return

USER Function GTUpdOut(cGTId,lSend,cInfo)
Local cOldAlias := alias()
Local nRetry := 10

OpenGTEnv()

// Atualiza Status do log de saida do processo
// pois o GTRET é temporario ...
DbSelectArea("GTOUT")
DbSetOrder(2)
If DbSeek(cGTId)
	
	While !dbrlock(recno()) .and. !killapp()
//		conout("[Thread "+alltrim(str(threadid()))+"] Try to lock GTOUT - Record "+alltrim(str(recno())))
		sleep(250)	
	Enddo

	GTOUT->GT_DRET := date()
	GTOUT->GT_TRET := time()
	GTOUT->GT_SEND := lSend
	
	If !empty(cInfo)
		GTOUT->GT_INFO := cInfo
	Endif
	
	// Solta o lock deste registro ...
	dbrunlock(recno())
	
Endif

If !empty(cOldAlias)
	DbSelectArea(cOldAlias)
Endif

Return

/* ---------------------------------------------------------------------------------
Job de envio de retornos pendentes
Varre a base de dados de retornos pendentes
--------------------------------------------------------------------------------- */
USER Function GTRETJOB()
Local cTime := left(time(),2)
Local nRecToDel := 0
Local aSendRet := {}
Local nTotPend := 0
Local nTotEnv  := 0
Local nI
Local cJobEmp := Getjobprofstring("JOBEMP","99")
Local cJobFil := Getjobprofstring("JOBFIL","01")
Local cGTID := ''

//Conout("Job GTRETJOB - Begin Emp("+cJobEmp+"/"+cJobFil+")" )

// Prepara ambiente e conecta com TOP
Rpcsettype(3)
RpcSetEnv(cJobEmp,cJobFil)

U_GTSetUp()		// Setup , criacao da tabela caso nao exista

//Conout("Job GTRETJOB - Running..." )
PtInternal(1,"Job GTRETJOB - Running...")

SET DELETED ON

While !killapp()
	
	If left(time(),2)  != cTime
		// a cada hora cheia, o job sai para
		// permitir refresh de memoria do servidor
		EXIT
	Endif
	
	OpenGTEnv()				// Abertura das Tabelas
	DbSelectArea("GTRET")
	dbgotop()
	
	nTotPend := 0
	nTotEnv  := 0
	
	While !eof()
		
		// verifica os retornos pendentes de envio
		nRecToDel := 0
		nTotPend++
		
		If !dbrlock(recno())
//			Conout("GTRET WARNING: Failed to Lock RECNO "+str(recno(),6)+" .. skip record ...")
			DBskip()
			LOOP
		Endif
		
		If Empty(GTRET->GT_PEDGAR)
			DbDelete()
			nRecToDel := 0		

		ElseIf GTRET->GT_TYPE == 'P'
			
			// Inclusao de Pedido
			
			cGTID	:= GTRET->GT_ID
			
			aSendRet := {}
			aadd(aSendRet,GTRET->GT_STAT)
			aadd(aSendRet,GTRET->GT_RETCODE)
			aadd(aSendRet,GTRET->GT_PEDGAR)
			aadd(aSendRet,GTRET->GT_RETSTR)

//			Varinfo("ASENDRETPED",aSendRet)
			
			If U_GTRetPed(cGTID,aSendRet)
				// Mandou o retorno, guarda numero do registro para deletar
				nRecToDel := recno()
				nTotEnv++
			Else
				// Deu crica ... aumenta o retry ...
				GTRET->GT_RETRY := GTRET->GT_RETRY + 1
				EventError(Getwscerror())
			Endif
			
		ElseIf GTRET->GT_TYPE == 'F'
			
			// Geracao de Nota Fiscal 
			// Prefeitura e entrega futura
			
			cGTID	:= GTRET->GT_ID
			
			aSendRet := {}
			aadd(aSendRet,GTRET->GT_STAT)
			aadd(aSendRet,GTRET->GT_RETCODE)
			aadd(aSendRet,GTRET->GT_PEDGAR)
			aadd(aSendRet,GTRET->GT_RETSTR)
			
//			Varinfo("ASENDRETNFF",aSendRet)

			If U_GTRetNFF(cGTID,aSendRet)
				// Mandou o retorno, guarda numero do registro para deletar
				nRecToDel := recno()
				nTotEnv++
			Else
				// Deu crica ... aumenta o retry ...
				GTRET->GT_RETRY := GTRET->GT_RETRY + 1
			Endif
			
		ElseIf GTRET->GT_TYPE == 'E'
			
			// Geracao de Nota Fiscal 
			// Entrega Efetiva 
			
			cGTID	:= GTRET->GT_ID
			
			aSendRet := {}
			aadd(aSendRet,GTRET->GT_STAT)
			aadd(aSendRet,GTRET->GT_RETCODE)
			aadd(aSendRet,GTRET->GT_PEDGAR)
			aadd(aSendRet,GTRET->GT_RETSTR)
			
//			Varinfo("ASENDRETNFE",aSendRet)

			If U_GTRetNFE(cGTID,aSendRet)
				// Mandou o retorno, guarda numero do registro para deletar
				nRecToDel := recno()
				nTotEnv++
			Else
				// Deu crica ... aumenta o retry ...
				GTRET->GT_RETRY := GTRET->GT_RETRY + 1
			Endif
			
		Else
			
//			Conout("GTRET ERROR: Invalid Type code ["+GTRET->GT_TYPE+"]")
			
		Endif
		
		dbselectarea("GTRET")

		If nRecToDel > 0
  			// Apenas marca delecao ...
			DbDelete()
			nRecToDel := 0
		Endif		
		
		dbrunlock()
		
		// Ja pula para o proximo ...
		DbSkip()
		
/*
		If nRecToDel > 0
			// Existe registro para ser deletado fisicamente .. manda ver
			// AQUI, temporario ... 
			// nao deleta fisicamente , apenas marca como deletado
			nErr := tcsqlexec("DELETE FROM GTRET WHERE R_E_C_N_O_ = "+str(nRecToDel,10) )
			If nErr < 0
				UserException(TcSqlError())
			Endif
			nRecToDel := 0
		Endif
*/
		
	Enddo
	
	// Limpa cache da interface XML
	// Para livrar memoria do Protheus Server
	DelClassIntf()
	
//	conout(replicate('-',79))
//	conout(time()+" GTRET - Job de Retorno ")
//	conout("Pendencias Encontradas ..... "+str(nTotPend,8))
//	conout("Pendencias ReEnviadas ...... "+str(nTotEnv,8))
//	conout("Pendencias Com Falha ....... "+str(nTotPend-nTotEnv,8))
//	conout(replicate('-',79))
//	conout('')
	
	// Fecha a tabela ...
	DbSelectArea("GTRET")
	USE
	
	// Agora espera 60 segundos para postar retornos novamente
	For nI := 60 to 1 step -1
		PtInternal(1,"[GTRETJOB] Wait ("+str(nI,2)+" s.) ...")
		Sleep( 1000 )
	Next
	
Enddo

PtInternal(1,"Job GTRETJOB - End")
//Conout("Job GTRETJOB - End" )

Return


/* ==============================================================
Funcao de Abertura das Tabelas de LOGS de Processo 
GTIN - Recepcao de requisicao de processamento 
GTOUT - Registro de requisicao processada 
GTRET - REgistro de retorno de processamento 
GTLOG - Log de integração entre aplicação Java e Aprovação de Compras.
============================================================== */
STATIC Function OpenGTEnv()

If select("GTIN") <= 0
	USE GTIN ALIAS GTIN SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException("Falha ao abrir GTIN - SHARED" )
	Endif
	DbSetIndex("GTIN01")
	DbSetOrder(1)
Endif

If select("GTOUT") <= 0
	USE GTOUT ALIAS GTOUT SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException("Falha ao abrir GTOUT - SHARED" )
	Endif
	DbSetIndex("GTOUT01")
	DbSetIndex("GTOUT02")
	DbSetOrder(1)
Endif

If select("GTRET") <= 0
	USE GTRET ALIAS GTRET SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException("Falha ao abrir GTRET - SHARED" )
	Endif
	DbSetIndex("GTRET01")
	DbSetIndex("GTRET02")
	DbSetOrder(1)
Endif

If Select("GTLOG") <= 0
	USE GTLOG ALIAS GTLOG SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela GTLOG - SHARED" )
	Endif
	dbSetIndex("GTLOG01")
	dbSetIndex("GTLOG02")
	dbSetIndex("GTLOG03")
	dbSetIndex("GTLOG04")
	dbSetOrder(1)
Endif

Return

// Usado pelo Retry de envio de retorno pendente
// mostra log de console com o tipo da ocorrencia registrada

STATIC Function EventError(cMsgError)
//conout(replicate("*",79))
//conout("Send Return Event Error ")
//conout(cMsgError)
//conout(replicate("*",79))
//conout("")
Return



/* ---------------------------------------------------------------------------
Client para teste dos metodos de notificacao
de status de pedido e/ou emissao de nota
--------------------------------------------------------------------------- */

// Teste de envio de rejeicao de pedido
User Function TRET1()

Local oWSRet
Local lOk    := .F.

oWSRet := WSServiceBus():New()

// WSDLDbgLevel(3)

oWSRet:oWSorderEvent:oWSEventArgsService := ServiceBus_EventArgsService():New()
oWSRet:oWSorderEvent:oWSOrder := ServiceBus_Order():New()

// Houve algum erro  ...
oWSRet:oWSorderEvent:oWSEventArgsService:cEvent 		:= 'PurchaseOrderRejected'
oWSRet:oWSorderEvent:oWSEventArgsService:cEventCode 	:= '666'
oWSRet:oWSorderEvent:oWSOrder:cOrderId 					:= '633970318561845703'

lOk := oWSRet:NotifyOrderEvent()

IF lOk
	MsgInfo("Foi pra conta")
Else
	MSGStop(GetWScerror())
Endif


Return

// Teste de post de xml de notificacao de ordem de pedido
User Function TRET2()
Local xRet := ''
Local naosei := ''
Local aHeader := {}
Local cXmlPost := memoread('\xmlpost.txt')
Local cUrl := GetNewPar( "MV_GTURL", "http://10.100.0.11:8000/VTEXServiceBus")

aadd(aHeader,"Content-Type: text/xml; charset=utf-8")
aadd(aHeader,'SOAPAction: "http://tempuri.org/IServiceBus/NotifyOrderEvent"')

xRet := httppost(cUrl,NIL, cXmlPost, 180, aHeader , @naosei )

//varinfo("xRet",xRet)
//varinfo("",naosei)

Return

/*
USER Function ZAPLOG()
RpcSetEnv('01','02')
IF MSgYesNo("ATENCAO !!! APAGA MESMO AS TABELAS DE LOG ???")
	tcdelfile('GTIN')
	tcdelfile('GTOUT')
	tcdelfile('GTRET')
	U_GTSetUp()	
	MsgInfo("Ja ERA BOY")
Endif
Return
*/


/*
Recebe codigo do evento 
e troca por codigo e descricao combinadas 
*/

STATIC Function RetCodes(cRetCode)
Local cMailNt	:= ""

SZ7->( DbSetorder(1) )
SZ7->( DbSeek( xFilial("SZ7")+cRetCode ) )
cMailNt := iif(SZ7->(fieldpos('Z7_MAILNOT'))>0,SZ7->Z7_MAILNOT,"")
	
Return { SZ7->Z7_CODGRU , SZ7->Z7_DESGRU, Alltrim(cMailNt)  }


/* ----------------------------------------------------------------------------
Atualizar informacao da GTIN, para dizer que a requisicao foi distribuida, 
mas ja / ainda existia processamento 
---------------------------------------------------------------------------- */
User Function GTPutPRO(cGtId)
Local cOldAlias := alias()
Local nStat

OpenGTEnv()

DbSelectArea("GTIN")

If fieldpos("GT_INPROC") > 0 
	nStat := tcsqlexec("UPDATE GTIN SET GT_INPROC='T' WHERE GT_ID='"+cGtId+"'")
	If nStat < 0 
//		conout("*** FALHA AO ATUALIZAR STATUS DE ENTRADA")
//		conout(tcsqlerror())
	Endif
Endif

If !empty(cOldAlias)
	DbSelectArea(cOldAlias)
Endif

Return


// Funcao de execucao unica, para criar campo adicional na GTIN
User Function AjustaIN()

rpcsetenv('01','02')

USE GTIN ALIAS GTIN SHARED NEW VIA "TOPCONN"
If neterr()
	MsgStop("Falha ao abrir GTIN")
	return
Endif

If fieldpos("GT_INPROC") > 0
	MsgInfo("Campo GT_INPROC JA CRIADO")
	Return
Endif

aStru := dbstruct()

aNewStru := aclone(aStru)

aadd(aNewStru,{"GT_INPROC","L",1,0})   // Ja estava em processamento ?

USE

lOk := TcAlter("GTIN",aStru,aNewStru)

IF !lOk
	MsgStop(tcsqlerror(),"Falha em TCAlter")
Else
	MSgInfo("Campo GT_INPROC acrescentado com sucesso")
Endif

Return





/* ---------------------------------------------------------------------------------
Job de verificacao de status do VTEX
Registra LOG de verificacao 
--------------------------------------------------------------------------------- */
USER Function GTLOGJOB()
Local cTime := left(time(),2)
Local nRecToDel := 0
Local aSendRet := {}
Local nTotPend := 0
Local nTotEnv  := 0
Local nI
Local cJobEmp := Getjobprofstring("JOBEMP","01")
Local cJobFil := Getjobprofstring("JOBFIL","02")
Local cInterval := Getjobprofstring("INTERVAL","60")
Local cWsUsr := getjobprofstring("GTRESPONSEURL","http://200.219.128.28:8000/VTEXServiceBus")
Local lOk := .t.
Local xTmp

//Conout("Job GTLOGJOB - Begin Emp("+cJobEmp+"/"+cJobFil+")" )
//Conout("Interval Check : "+cInterval)

// Prepara ambiente e conecta com TOP
Rpcsettype(3)
RpcSetEnv(cJobEmp,cJobFil)

U_GTSetUp()		// Setup , criacao da tabela caso nao exista

//Conout("Job GTLOGJOB - Running..." )
PtInternal(1,"Job GTLOGJOB - Running...")

OpenGTEnv()				// Abertura das Tabelas
DbSelectArea("GTLOG")
dbgotop()

While !killapp()
	
	If left(time(),2)  != cTime
		// a cada hora cheia, o job sai para
		// permitir refresh de memoria do servidor
		EXIT
	Endif
	
	// faz um GET para o WebSErvices, dummy
	// apenas pede a pagina do servico, sem solicitar metodo 
//	conout("Verificando "+cWsUsr+' ... ')
	xTmp := httpget(cWsUsr)
	xExtra := ""
	nCode := httpgetstatus(@xExtra)
	If empty(xTmp) .or. nCode != 200
		lOk := .f.
	Else
		lOk := .t.
	Endif

	DbAppend(.f.)

	GTLOG->GT_DATE   := date()
	GTLOG->GT_TIME   := time()
	GTLOG->GT_ONLINE := lOk
	GTLOG->GT_INFO   := str(nCode,6)+" "+xExtra

//	conout("STATUS : "+str(nCode,6)+" "+xExtra)
	
	dbcommit()
	dbrunlock(recno())

	// Espera pelo intervao de verificacao 
	For nI := 1 to val(cInterval)
		Sleep(1000)
		IF killapp()
			EXIT
		Endif
	Next

Enddo

//Conout("Job GTLOGJOB - End Emp("+cJobEmp+"/"+cJobFil+")" )

Return

/* ---------------------------------------------------------------------------------
Identificação do ID da Fila e XnpSite 
--------------------------------------------------------------------------------- */
Static Function DadFila(cPed,cPedSite)
Local csql := ""
Local aRet := {"","",""}

If !Empty(cPed) .OR. !Empty(cPedSite)
	csql := "SELECT "
	csql += "  GT_ID, "
	csql += "  GT_PEDGAR, "
	csql += "  GT_XNPSITE "
	csql += "FROM "
	csql += "  GTIN "
	csql += "WHERE "
	If !Empty(cPed)
		csql += "  GT_PEDGAR = '"+Alltrim(cPed)+"' AND "
	EndIf
	If !Empty(cPedSite)
		csql += "  GT_XNPSITE = '"+Alltrim(cPedSite)+"' AND "
	EndIf
	csql += "  GT_TYPE = 'F' AND "
	csql += "  D_E_L_E_T_ = ' ' " 
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,csql),"TRBFILA",.F.,.T.)
	
	If !TRBFILA->(Eof())
		aRet[1] := TRBFILA->GT_ID     
		aRet[3] := TRBFILA->GT_PEDGAR
		aRet[3] := TRBFILA->GT_XNPSITE
	EndIf 
	
	TRBFILA->(DbCloseArea())
EndIf

Return(aRet)

/* ==================================================================
Funcao de criacao das tabelas de retencao e logs
================================================================== */
User Function GTLEGADO()

Local aStru :=  {}

If !tccanopen('GTLEGADO')
	
	// Cria a tabela caso nao exista
	aStru :=  {}
	aadd(aStru,{"GT_TYPE","C",1,0})
	aadd(aStru,{"GT_PEDGAR","C",10,0})
	aadd(aStru,{"GT_INPROC","L",1,0})   // Ja estava em processamento ?

//	conout("Criando tabela de entrada GTIN")
	DbCreate('GTLEGADO',aStru,"TOPCONN")
	
Endif

If !TcCanOpen('GTLEGADO','GTLEGADO01' )
	
	// cria o indice caso nao exista
//	conout("Criando indice de entrada GTIN01")
	
	USE GTLEGADO ALIAS GTLEGADO EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falta ao abrir GTLEGADO em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON GT_TYPE + GT_PEDGAR TO ("GTLEGADO01")
	
	USE
	
Endif

Return

//--------------------------------------------------------------------------
// Rotina | UpdGTIN | Autor | Robson Gonçalves           | Data | 28/06/2018
//--------------------------------------------------------------------------
// Descr. | Rotina p/ criar novos campos e índice na tabela GTIN.
//        | Esta rotina deverá ser executada pelo menu do usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function UpdGTIN()
	Local aButton := {}
	Local aSay := {}
	Local nOpc := 0
	
	Private cCadastro := 'Criar para campos na tabela GTIN'
	
	AAdd( aSay, 'Rotina para criar campos e índices na tabela GTIN' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		MsAguarde( {|lEnd| CriarCpos( @lEnd ) }, cCadastro, "Iniciando processo, são 4 etapas, aguarde...", .F. )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | CriarCpos | Autor | Robson Gonçalves         | Data | 28/06/2018
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para efetuar o alter table na tabela GTIN.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function CriarCpos()
	Local aIndex := {}
	Local aStruct := {}
	Local aStructAtu := {}

	Local cIndexName := ""
	Local cTable := "GTIN"

	Local lAlter := .F.
	Local lContinue := .T.

	Local nLoop := 0
	Local nP := 0
	
	MsProcTxt( 'Abrindo tabela GTIN [1/4]' )
	ProcessMessage()
	
	If Select(cTable) <= 0
		USE &(cTable) ALIAS &(cTable) SHARED NEW VIA "TOPCONN"
		If NetErr()
			UserException( "Falha ao abrir tabela GTIN - SHARED" )
		Endif
		dbSetIndex(cTable+"01")
		dbSetIndex(cTable+"02")
		dbSelectArea(cTable)
		dbSetOrder(1)
	Endif

	aStructAtu := GTIN->( DbStruct() )

	aStruct := AClone( aStructAtu )

	AAdd( aStruct, { "GT_CNPJCON", "C", 14, 0 } )
	AAdd( aStruct, { "GT_CNPJFAT", "C", 14, 0 } )
	AAdd( aStruct, { "GT_ORIGVEN", "C",  1, 0 } )
	
	MsProcTxt( 'Comparando a estrutura da tabela [2/4]' )
	ProcessMessage()

	For nLoop := 1 To Len( aStruct )
		nP := AScan( aStructAtu, {|e| e[ 1 ] == aStruct[ nLoop, 1 ] } )
		If nP == 0
			lAlter := .T.
			Exit
		Endif
	Next nI
	
	If lAlter
		MsProcTxt( 'Alterando a estrutura da tabela [3/4]' )
		ProcessMessage()
		
		DbSelectArea(cTable)
		DbCloseArea()
		If .NOT. TcAlter( cTable, aStructAtu, aStruct )
			lContinue := .F.
		Endif
	Endif
	
	AAdd( aIndex, { 'GT_CNPJCON+GT_ORIGVEN', '_CERT05' } )
	AAdd( aIndex, { 'GT_CNPJFAT+GT_ORIGVEN', '_CERT06' }  )
	
	If lContinue
		If Select(cTable) > 0
			DbSelectArea(cTable)
			DbCloseArea()
		Endif
		
		For nLoop := 1 To Len( aIndex )
			MsProcTxt( 'Comparando o índice da tabela [4/4]' )
			ProcessMessage()
			
			cIndexName := cTable + aIndex[ nLoop, 2 ]
			
			If .NOT. TcCanOpen( cTable, cIndexName )
				
				USE &(cTable) ALIAS &(cTable) EXCLUSIVE NEW VIA 'TOPCONN'
				
				If NetErr()
					UserExecption('Falha ao abrir '+cTable+' em modo exclusivo para criação do índice ['+cIndexName+' -> '+aIndex[ nLoop, 1 ]+']')
				Endif
				
				MsProcTxt( 'Criando o índice da tabela [4/4]' )
				ProcessMessage()
				
				INDEX ON &(aIndex[ nLoop, 1 ]) TO (cIndexName)
				USE
			Endif
		Next nLoop
	Endif
	MsgInfo('Final do processamento, tecle algo para sair.', cCadastro )
Return

//--------------------------------------------------------------------------
// Rotina | PopGTIN | Autor | Robson Gonçalves           | Data | 28/06/2018
//--------------------------------------------------------------------------
// Descr. | Rotina p/ popular os dados nos campos da tabela GTIN.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function PopGTIN()
	Local aButton := {}
	Local aSay := {}
	Local nOpc := 0
	
	Private cCadastro := 'Popular CPF/CNPJ contato, faturamento e origem venda GTIN'
	
	AAdd( aSay, 'Rotina para processar os registros da tabela GTIN quando os campos ' )
	AAdd( aSay, 'GT_TYPE = F e GT_XNPSITE preenchido. Sendo verdadeira esta condição será ' )
	AAdd( aSay, 'localizado no campo GT_PARAM o CPF/CNPJ do contato, do faturamento e a' )
	AAdd( aSay, 'origem da venda. Com esta identificação será gravado estes dados nos' )
	AAdd( aSay, 'respectivos campos.' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		MsAguarde( {|lEnd| ProcGTIN( @lEnd ) }, "Popular os dados na GTIN", "Iniciando processo, aguarde...", .F. )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | ProcGTIN | Autor | Robson Gonçalves          | Data | 28/06/2018
//--------------------------------------------------------------------------
// Descr. | Rotina p/ processar os registros da GTIN e gravar CPF/CNPJ do
//        | contato, faturamento e a origem da venda.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function ProcGTIN()
	Local cCPF_Contato := ''
	Local cCPF_Fatura := ''
	Local cOrigemVenda := ''
	Local cParam := ''
	Local cTable := 'GTIN'
	Local cSQL := ''
	Local cTRB := ''
	Local nGrv := 0
	Local nLine := 0
	Local nP := 0
	Local nSeconds := Seconds()
	
	cSQL := "SELECT R_E_C_N_O_ AS GT_RECNO " 
	cSQL += "FROM GTIN "
	cSQL += "WHERE GT_TYPE = 'F' "
	cSQL += "AND GT_XNPSITE <> ' ' "
	cSQL += "AND GT_CNPJCON = ' ' "
	cSQL += "AND GT_CNPJFAT = ' ' "
	cSQL += "AND GT_ORIGVEN = ' ' "
	cSQL += "ORDER BY R_E_C_N_O_ "
	
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	If Select(cTable) <= 0
		USE &(cTable) ALIAS &(cTable) SHARED NEW VIA "TOPCONN"
		If NetErr()
			UserException( "Falha ao abrir tabela GTIN - SHARED" )
		Endif
		dbSetIndex(cTable+"01")
		dbSetIndex(cTable+"02")
	Endif
	
	dbSelectArea(cTable)
	dbSetOrder(2)
	
	While (cTRB)->( .NOT. EOF() )
		MsProcTxt( 'Registros lidos: ' + LTrim( Str( ++nLine ) ) + ' - gravados: ' + LTrim( Str( nGrv ) ) )
		ProcessMessage()

		(cTable)->( dbGoTo( (cTRB)->GT_RECNO ) )
		
		If (cTable)->( RecNo() ) == (cTRB)->GT_RECNO
			
			If .NOT. Empty( (cTable)->GT_PARAM )
				cParam := AllTrim( (cTable)->GT_PARAM )
				
				nP := At( '_CONTATO:_CPF:TEXT', cParam )
				If nP > 0
					cCPF_Contato := SubStr( cParam, (nP+33), 11 )
				Endif
				
				nP := At( '_FATURA:_CPF:TEXT', cParam )
				If nP > 0
					cCPF_Fatura := SubStr( cParam, (nP+32), 11 )
				Else
					nP := At( '_FATURA:_CNPJ:TEXT', cParam )
					If nP > 0
						cCPF_Fatura := SubStr( cParam, (nP+33), 14 )
					Endif
				Endif
				
				nP := At( '_ORIGEMVENDA:TEXT', cParam )
				If nP > 0
					cOrigemVenda := SubStr( cParam, (nP+32), 1 )
				Endif
				
				(cTable)->( RecLock( cTable, .F. ) )
				(cTable)->GT_CNPJCON := cCPF_Contato
				(cTable)->GT_CNPJFAT := cCPF_Fatura
				(cTable)->GT_ORIGVEN := cOrigemVenda
				(cTable)->( MsUnLock() )
				(cTable)->( DBCommit() )
				(cTable)->( DbrUnLock() )
				
				nGrv++
			Endif
		Endif
		
		(cTRB)->( dbSkip() )
	End
	(cTRB)->(dbCloseArea())
	
	MsgInfo('Final do processamento, tempo decorrido ' + LTrim( Str( Seconds() - nSeconds ) )+ 'tecle algo para sair.', cCadastro )
Return

//--Rafael Beghini [08.01.2020]
//--Rotina para criar o campo pedido eCommerce
User Function GTUpdEcom()
	Local aGtIN		:= {}
	Local aGtOU		:= {}
	Local aNewGtIn	:= {}
	Local aNewGtOu	:= {}
	Local cMsg		:= ''

	OpenGTEnv()

	aGtIN := ( 'GTIN'  )->( DbStruct() )
	aGtOU := ( 'GTOUT' )->( DbStruct() )

	aNewGtIn := aClone( aGtIN )
	aNewGtOu := aClone( aGtOU )

	AAdd( aNewGtIn, { 'GT_XNPECOM', 'C',  16, 0 } )
	AAdd( aNewGtOu, { 'GT_XNPECOM', 'C',  16, 0 } )

	DbSelectArea( 'GTIN' )
	DbCloseArea()
	If .NOT. TcAlter( 'GTIN', aGtIN, aNewGtIn )
		cMsg += 'Erro para criar na GTIN' + CRLF
	Endif

	DbSelectArea( 'GTOUT' )
	DbCloseArea()
	If .NOT. TcAlter( 'GTOUT', aGtOU, aNewGtOu )
		cMsg += 'Erro para criar na GTOUT' + CRLF
	Endif
	
	IF .NOT. Empty( cMsg )
		HS_MsgInf(cMsg,"Atenção","GTUpdEcom")
	Else
		HS_MsgInf("Processo finalizado com sucesso","Atenção","GTUpdEcom")
	EndIF
Return