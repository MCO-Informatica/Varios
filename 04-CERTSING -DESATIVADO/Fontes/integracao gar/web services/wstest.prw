#INCLUDE 'PROTHEUS.CH'

Static cPedGar := "0000000052"

// RELEASE 20091222

/* =======================================================================
Funcao de teste dos WebServices da CertiSign
u_CSTest01 		Teste de inclusao de pedido 
u_CSTest02		Teste da geracao da nota 
======================================================================= */

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSTEST    ºAutor  ³Microsiga           º Data ³  12/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Teste de WebSErvices de inclusao de pedido              	    º±±
±±º          ³WSMETHOD INCPEDIDO WSSEND oWSPEDIDO WSRECEIVE               º±±
±±º          ³oWSINCPEDIDORESULT WSCLIENT WSCERTISIGNERP                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSTest01()

Local oWSObj
Local cMsg		:= ''
Local lOptional	:= .F.
Local cInicio	:= Time()

// Cria o objeto client do WebSErvices para o teste 
oWSObj := WSCERTISIGNERP():New()

// Cria as estruturas de dados que sao usadas no pedido 
// A propriedade oWSPedido já vem criada, mas os dados e estruturas
// que pertemcem a ela estao todos NIL
// Como todas as pripriedades esta estrutura sao outras estrutudas, 
// cada uma das estruturas deve ser criada com o construtor apropriado
// para entao os dados de cada uma das estruturas serem alimentados

oWSObj:oWSPedido:OWSCLIENTE  := CERTISIGNERP_CSCLIENTEST():New()
oWSObj:oWSPedido:OWSITENS    := CERTISIGNERP_ARRAYOFCSITEMST():New()
oWSObj:oWSPedido:OWSHEADER   := CERTISIGNERP_CSPEDCABECST():New()
oWSObj:oWSPedido:OWSTITULO   := CERTISIGNERP_CSFINANCST():New()

// Alimenta informacoes do cliente

oWSObj:OWSPEDIDO:OWSCLIENTE:cA1NOME		:= "ARMANDO M. TESSAROLI"						//	C	40		Nome
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1PESSOA	:= "F"											//	C	1		Fisica/Jurid
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1NREDUZ	:= "ARMANDO"									//	C	20		N Fantasia
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1END		:= "RUA ARTUR DE OLIVEIRA"						//	C	40		Endereco
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1NUMERO	:= "365"										//	C	10		Numero
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1COMPLEM	:= "APTO 132, B"								//	C	50		Complemento
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1TIPO		:= "F"											//	C	1		Tipo
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1EST		:= "SP"											//	C	2		Estado
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1ESTADO	:= "SAO PAULO"									//	C	20		Nome Estado
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1COD_MUN	:= "50308"										//	C	5		Cd.Municipio
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1MUN		:= "SAO PAULO"									//	C	15		Municipio
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1BAIRRO	:= "SANTANA"									//	C	30		Bairro
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1CEP		:= "02535010"									//	C	8		CEP
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1DDD		:= "021"										//	C	3		DDD
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1TEL		:= "2111 3612"									//	C	15		Telefone
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1PAIS		:= "105"										//	C	3		Pais
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1CGC		:= "14566205843"								//	C	14		CNPJ/CPF
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1INSCR	:= "ISENTO"										//	C	18		Ins. Estad.
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1INSCRM	:= "ISENTO"										//	C	18		Ins. Municip
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1EMAIL	:= "armando@neobiz.com.br"						//	C	30		E-Mail
oWSObj:OWSPEDIDO:OWSCLIENTE:cA1PFISICA	:= "247592614"									//	C	18		RG/Ced.Estr.  ---> CONDICIONAL

If lOptional
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1DDI		:= "55"											//	C	6		DDI
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1TELEX	:= "1234NBCO"									//	C	10		Telex
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1FAX		:= "(11) 2729 1240"								//	C	15		FAX
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1ENDREC	:= "RUA ARTUR DE OLIVEIRA, 365 APTO 132-B"		//	C	40		End.Recebto
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1CONTATO	:= "ARMANDO"									//	C	15		Contato
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1RECISS	:= "2"											//	C	1		Recolhe ISS
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1SUFRAMA	:= ""											//	C	12		SUFRAMA
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1INCISS	:= "S"											//	C	1		ISS no Preco
	oWSObj:OWSPEDIDO:OWSCLIENTE:nA1ALIQIR	:= 0											//	N	5	2	Aliq. IRRF
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1RG		:= "247592614"									//	C	15		RG
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1OBSERV	:= "TESTE DE OPCIONAIS"							//	C	40		Observacao
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1ENDCOB	:= "RUA ARTUR DE OLIVEIRA, 365 APTO 132-B"		//	C	40		End.Cobranca
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1BAIRROC	:= "SANTANA"									//	C	30		Bairro Cob
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1CEPC		:= "20021290"									//	C	8		Cep de Cobr.
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1MUNC		:= "SAO PAULO"									//	C	15		Mun. Cobr.
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1ESTC		:= "SP"											//	C	2		Uf de Cobr.
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1ENDENT	:= "RUA ARTUR DE OLIVEIRA, 365 APTO 132-B"		//	C	40		End.Entrega
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1BAIRROE	:= "SANTANA"									//	C	20		Bairro Entr.
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1CEPE		:= "20021290"									//	C	8		Cep Entr
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1MUNE		:= "SAO PAULO"									//	C	15		Mun. entr
//	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1ESTE		:= "SP"											//	C	2		Uf Entr
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1CODMUN	:= ""											//	C	5		Cod. Mun. ZF
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1CNAE		:= ""											//	C	9		Cod CNAE
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1RECINSS	:= "N"											//	C	1		Rec. INSS
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1RECCOFI	:= "N"											//	C	1		Rec.COFINS
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1RECCSLL	:= "N"											//	C	1		Rec. CSLL
	oWSObj:OWSPEDIDO:OWSCLIENTE:cA1RECPIS	:= "N"											//	C	1		Rec. PIS
Endif


// Alimenta campos com informacoes dos titulos
oWSObj:OWSPEDIDO:OWSTITULO:cE1PEDGAR	:= cPedGar		//	C	10		Pedido GAR
oWSObj:OWSPEDIDO:OWSTITULO:cE1TIPMOV	:= "1"				//	C	1		Orig Movim
oWSObj:OWSPEDIDO:OWSTITULO:cE1CNPJ		:= "14566205843"	//	C	14		CNPJ / CPF
oWSObj:OWSPEDIDO:OWSTITULO:dE1EMISSAO	:= Date()		//	D	8		DT Emissao
oWSObj:OWSPEDIDO:OWSTITULO:dE1VENCTO	:= Date()+15		//	D	8		Vencimento
oWSObj:OWSPEDIDO:OWSTITULO:nE1VALOR		:= 832.47			//	N	17	2	Vlr.Titulo
oWSObj:OWSPEDIDO:OWSTITULO:cE1ADM		:= "VIS"			//	C	3		Administ Cartao.  --> CONDICIONAL
oWSObj:OWSPEDIDO:OWSTITULO:cE1PORTADO	:= "123"			//	C	3		Banco
oWSObj:OWSPEDIDO:OWSTITULO:cE1AGEDEP	:= "12345"			//	C	5		Agencia
oWSObj:OWSPEDIDO:OWSTITULO:cE1CONTA		:= "123456"			//	C	10		Conta de Credito

If lOptional
	oWSObj:OWSPEDIDO:OWSTITULO:cE1_HIST		:= "TESTE DE INCLUSAO"			//	C	25		Historico
Endif


// Alimenta cabecalho do pedido

oWSObj:oWSPedido:OWSHEADER:cC5CHVBPAG	:= cPedGar		//	C	10		Pedido GAR
oWSObj:oWSPedido:OWSHEADER:cC5CNPJ		:= "14566205843"	//	C	14		CNPJ / CPF
oWSObj:oWSPedido:OWSHEADER:cC5CONDPAG	:= "001"			//	C	3		Cond. Pagto
oWSObj:oWSPedido:OWSHEADER:dC5EMISSAO	:= Date()		//	D	8		DT Emissao
oWSObj:oWSPedido:OWSHEADER:cC5TIPMOV	:= "1"				//	C	1		Orig Movim
oWSObj:oWSPedido:OWSHEADER:nC5TOTPED	:= 832.47			//	N	12	2	Vlr. Tot Ped.
oWSObj:oWSPedido:OWSHEADER:cC5STATUS	:= "1"				//	1 = Emissao CErt 2 = Renovacao

If lOptional
	oWSObj:oWSPedido:OWSHEADER:cC5MENNOTA	:= "TESTE PARA MENSAGEM DA NOTA"			//	C	60		Mens.p/ Nota
	oWSObj:oWSPedido:OWSHEADER:cC5TIPMOV2	:= ""										//	C	1		Orig Movim 2  --> Condicional
	oWSObj:oWSPedido:OWSHEADER:cC5TIPVOU	:= ""										//	C	1		Tipo Voucher  --> Condicional
	oWSObj:oWSPedido:OWSHEADER:cC5CODVOU	:= ""										//	C	20		Cod. Voucher  --> Condicional
Endif


// Alimenta itens do pedido

// Primeiro acrescenta o objeto do pedido no array
// Depois pega a referencia do objeto no ultimo elemento do array e alimenta
aadd ( oWSObj:OWSPEDIDO:OWSITENS:OWSCSITEMST , CERTISIGNERP_CSITEMST():New() )
oThisItemPed := aTail(oWSObj:OWSPEDIDO:OWSITENS:OWSCSITEMST)

oThisItemPed:CC6PEDGAR := cPedGar
oThisItemPed:CC6PROGAR := 'IDDIGITALSC'
oThisItemPed:NC6QTDVEN := 1
oThisItemPed:NC6PRCVEN := 800.00

// Primeiro acrescenta o objeto do pedido no array
// Depois pega a referencia do objeto no ultimo elemento do array e alimenta
aadd ( oWSObj:OWSPEDIDO:OWSITENS:OWSCSITEMST , CERTISIGNERP_CSITEMST():New() )
oThisItemPed := aTail(oWSObj:OWSPEDIDO:OWSITENS:OWSCSITEMST)

oThisItemPed:CC6PEDGAR := cPedGar
oThisItemPed:CC6PROGAR := 'ACMA3PJNFEL'
oThisItemPed:NC6QTDVEN := 1
oThisItemPed:NC6PRCVEN := 800.00

// Liga , apegas para debug, as mensagens de echo e diagnostico
// do client de webservices no protheus
// WSDLDbgLevel(3)

// Aghora chama o metodo de insercao.
// Um metodo client retorna .t. em caso de sucesso e .f. em caso de falha
If oWSObj:INCPEDIDO()
	cMsg += "RETURN "+IIF(oWSObj:oWSINCPEDIDORESULT:lOk,"OK","FAILED")+CRLF
	cMsg += "DETAILSTR "+oWSObj:oWSINCPEDIDORESULT:cDetailStr+CRLF
	MsgStop(	"Tempo estimado para execução do processo..." + CRLF + CRLF +;
				"Hora inicial-> "+cInicio + CRLF +;
				"Hora final-> "+Time())
	MsgInfo(cMsg,"CERTO")
Else
	// Em caso de falha, é possivel obter os detalhes da falha
	// utilizando GetWSCError()
	MSGSTOP(getwscerror(),"ERRADO")
Endif

// Terminou, elimina o objeto client da memoria.
FreeObj(oWSObj)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSTEST    ºAutor  ³Microsiga           º Data ³  12/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Teste de WebSErvices de geracao de nota                     º±±
±±º          ³WSMETHOD GERANOTA WSRECEIVE MOVNOTA WSSEND RESPONSE         º±±
±±º          ³WSSERVICE CERTISIGNERP                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSTest02()

Local oWSObj
Local cMsg		:= ''
Local lOptional	:= .F.
Local cInicio	:= Time()

// Cria o objeto client do WebSErvices
oWSObj := WSCERTISIGNERP():New()

// Alimenta a estutura usada para gerar nota 
// A propriedade OWSMOVNOTA já vem criada, mas os dados e estruturas
// que pertemcem a ela estao todos NIL
// Como todos os dados sao de tipos simples, eles sao alimentados 
// diretamente com seus conteudos 


oWSObj:OWSMOVNOTA:cZ5PEDGAR		:= cPedGar
oWSObj:OWSMOVNOTA:dZ5DATPED		:= Date()
oWSObj:OWSMOVNOTA:dZ5EMISSAO	:= Date()
oWSObj:OWSMOVNOTA:dZ5RENOVA		:= Date()
oWSObj:OWSMOVNOTA:dZ5REVOGA		:= Date()
oWSObj:OWSMOVNOTA:dZ5DATVAL		:= Date()
oWSObj:OWSMOVNOTA:cZ5HORVAL		:= Time()
oWSObj:OWSMOVNOTA:cZ5CNPJ		:= "14566205843"
oWSObj:OWSMOVNOTA:cZ5CNPJCER	:= "14566205843"
oWSObj:OWSMOVNOTA:cZ5NOMREC		:= "ARMANDO M. TESSAROLI"
oWSObj:OWSMOVNOTA:dZ5DATPAG		:= Date()
oWSObj:OWSMOVNOTA:nZ5VALOR		:= 832.47
oWSObj:OWSMOVNOTA:cZ5TIPMOV		:= "1"
oWSObj:OWSMOVNOTA:cZ5STATUS		:= "1"
oWSObj:OWSMOVNOTA:cZ5CODAR		:= "123456"
oWSObj:OWSMOVNOTA:cZ5DESCAR		:= "DESCRICAO DA AR"
oWSObj:OWSMOVNOTA:cZ5CODPOS		:= "567890"
oWSObj:OWSMOVNOTA:cZ5DESPOS		:= "DESCRICAO DO POSTO"
oWSObj:OWSMOVNOTA:cZ5CODAGE		:= "112233"
oWSObj:OWSMOVNOTA:cZ5NOMAGE		:= "NOME DO AGENTE"
oWSObj:OWSMOVNOTA:cZ5CPFAGE		:= "12345678901"
oWSObj:OWSMOVNOTA:cZ5CERTIF		:= "GFTDALKSJFGLKDSAHFKA"
oWSObj:OWSMOVNOTA:cZ5PRODUTO	:= "HFDDFCJDSKJFSAESFAFC"
oWSObj:OWSMOVNOTA:cZ5DESPRO		:= "DESCRICAO DO PRODUTO"
oWSObj:OWSMOVNOTA:cZ5GRUPO		:= "GRUPO DE VENDAS"
oWSObj:OWSMOVNOTA:cZ5DESGRU		:= "DESCRICAO DO GRUPO DE VENDAS"

If lOptional
	oWSObj:OWSMOVNOTA:cZ5TIPVOU		:= "1"
	oWSObj:OWSMOVNOTA:cZ5CODVOU		:= "1234567890"
	oWSObj:OWSMOVNOTA:cZ5GARANT		:= ""
Endif

// Liga , apegas para debug, as mensagens de echo e diagnostico
// do client de webservices no protheus
// WSDLDbgLevel(3)

// Aghora chama o metodo de gerar nota
// Um metodo client retorna .t. em caso de sucesso e .f. em caso de falha
If oWSObj:GERANOTA()
	cMsg += "RETURN "+IIF(oWSObj:oWSGERANOTARESULT:lOk,"OK","FAILED")+CRLF
	cMsg += "DETAILSTR "+oWSObj:oWSGERANOTARESULT:cDetailStr+CRLF
	MsgStop(	"Tempo estimado para execução do processo..." + CRLF + CRLF +;
				"Hora inicial-> "+cInicio + CRLF +;
				"Hora final-> "+Time())
	MsgInfo(cMsg,"CERTO")
Else
	// Em caso de falha, é possivel obter os detalhes da falha
	// utilizando GetWSCError()
	MSGSTOP(getwscerror(),"ERRADO")
Endif

// Terminou, elimina o objeto client da memoria.
FreeObj(oWSObj)

Return
