#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA055  º Autor ³ RENATO RUY BERNARDO  º Data ³ 09/07/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia notificacoes de entrega posto.						    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPA055() 

Local cPeriodo := ""
Local cXml		 := ""
Local aItemPV	 := {}
Local oWsObj
Local lLinha	 := .F.

Private lMsErroAuto 		:= .F.
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

cPeriodo := Iif(SubStr(getmv("MV_REMMES"),5,2)=="12",Soma1(SubStr(getmv("MV_REMMES"),1,4))+"01",Soma1(getmv("MV_REMMES")))

//Query para buscar os pedidos que não geraram a entrega ou sem linha de entrega
Beginsql Alias "TMPHWA"
	
	%NoParser%	
	
	SELECT  C5_XNPSITE, 
	        C5_NUM, 
	        NVL(C6_NOTA,'SEM LINHA ENTREGA') NOTA,
	        C6_XOPER,
	        C5_XPOSTO
	FROM PROTHEUS.SC5010 SC5
	left JOIN PROTHEUS.SC6010 SC6 ON C6_FILIAL = %xFilial:SC6% AND C6_NUM = C5_NUM AND C6_XOPER = '53' AND SC6.%Notdel%
	WHERE
	C5_FILIAL = %xFilial:SC5% AND
	C5_XORIGPV = '3' AND
	(C6_NOTA = ' ' OR C6_NOTA IS NULL) AND
	C5_XNPSITE IN ( SELECT GT_XNPSITE FROM PROTHEUS.GTIN
	                WHERE
	                GT_DATE BETWEEN %Exp:cPeriodo+"01"% AND %Exp:cPeriodo+"31"% AND
	                GT_TYPE = 'E' AND
	                GT_XNPSITE > ' ' AND
	                %Notdel%
	                GROUP BY GT_XNPSITE) AND
	SC5.%Notdel%  
	GROUP BY C5_XNPSITE, C5_NUM, C6_NOTA, C6_XOPER, C5_XPOSTO

Endsql

//Modelo Mensagem
/*
 <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<listPedidoFullType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">
    <pedido>
        <numero>7850678</numero>
        <statusConfEntrega>0</statusConfEntrega>
        <postoEntregaGar>38680</postoEntregaGar>
        <postoEntrega>Posto Provisorio AR Nacional - Vila Mariana/SP</postoEntrega>
        <agenteEntrega>32623871850</agenteEntrega>
        <dataEntrega>09/07/2018</dataEntrega>
        <horaEntrega>14:22</horaEntrega>
    </pedido>
</listPedidoFullType> */

oWsObj := WSHARDWAREAVULSOPROVIDER():New()

While !TMPHWA->(EOF())
	
	//Caso tenha inserido o item 2 de entrega
	lLinha	 	 := .F.

	If AllTrim(TMPHWA->NOTA) == 'SEM LINHA ENTREGA'
		
		//Posiciona tabelas para alteracao
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(xFilial("SC5")+TMPHWA->C5_NUM))
		
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+TMPHWA->C5_NUM))
		
		//Limpa array dos produtos
		aItemPV	 := {}
		
		//seta array de alteração
		//Primeiro o produto existente
		AADD(aItemPV,{{"C6_ITEM"		,SC6->C6_ITEM 		,Nil},; // Numero do Item no Pedido
						{"C6_PRODUTO"	,SC6->C6_PRODUTO		,Nil},; // Codigo do Produto
						{"C6_QTDVEN"	,SC6->C6_QTDVEN		,Nil},; // Quantidade Vendida   ***
						{"C6_PRUNIT"	,SC6->C6_PRUNIT		,Nil},; // PRECO DE LISTA      ***
						{"C6_PRCVEN"	,SC6->C6_PRCVEN		,Nil},; // Preco Unitario Liquido   ***
						{"C6_OPER"		,SC6->C6_XOPER		,Nil},; // Operação de faturamento    *** Mudar o C6_OPER para retorno do tipo de operacao aRvou//////////
						{"C6_XOPER"	,SC6->C6_XOPER		,Nil},; // Operação de faturamento    ***
						{"C6_LOCAL"	,SC6->C6_LOCAL		,Nil},; // Armazém Padrão
						{"C6_PROGAR"	,SC6->C6_PROGAR		,Nil},;	// Codigo Produto GAR
						{"C6_XCDPRCO"	,SC6->C6_XCDPRCO		,Nil},;	// Codigo Combo
						{"C6_ENTREG"	,SC6->C6_ENTREG		,Nil},; // Data da Entrega
						{"C6_XNUMVOU"	,SC6->C6_XNUMVOU		,Nil},; // Numero do Voucher
						{"C6_XQTDVOU"	,SC6->C6_XQTDVOU		,Nil},; // Quantidade do Voucher
						{"C6_PEDGAR"	,SC6->C6_PEDGAR		,Nil}}) // Numero do Pedido GAR
		
		//Segundo produto a ser adicionado				
		AADD(aItemPV,{{"C6_ITEM"		,SOMA1(SC6->C6_ITEM)	,Nil},; // Numero do Item no Pedido
						{"C6_PRODUTO"	,SC6->C6_PRODUTO		,Nil},; // Codigo do Produto
						{"C6_QTDVEN"	,SC6->C6_QTDVEN		,Nil},; // Quantidade Vendida   ***
						{"C6_PRUNIT"	,SC6->C6_PRUNIT		,Nil},; // PRECO DE LISTA      ***
						{"C6_PRCVEN"	,SC6->C6_PRCVEN		,Nil},; // Preco Unitario Liquido   ***
						{"C6_OPER"		,"53"					,Nil},; // Operação de faturamento    *** Mudar o C6_OPER para retorno do tipo de operacao aRvou//////////
						{"C6_XOPER"	,"53"					,Nil},; // Operação de faturamento    ***
						{"C6_LOCAL"	,SC6->C6_LOCAL		,Nil},; // Armazém Padrão
						{"C6_PROGAR"	,SC6->C6_PROGAR		,Nil},;	// Codigo Produto GAR
						{"C6_XCDPRCO"	,SC6->C6_XCDPRCO		,Nil},;	// Codigo Combo
						{"C6_ENTREG"	,SC6->C6_ENTREG		,Nil},; // Data da Entrega
						{"C6_XNUMVOU"	,SC6->C6_XNUMVOU		,Nil},; // Numero do Voucher
						{"C6_XQTDVOU"	,SC6->C6_XQTDVOU		,Nil},; // Quantidade do Voucher
						{"C6_PEDGAR"	,SC6->C6_PEDGAR		,Nil}}) // Numero do Pedido GAR
	
		//Efetua alteracao
		MSExecAuto({|x,y,z|Mata410(x,y,z)},{{"C5_NUM",SC5->C5_NUM,Nil}},aItemPV,4)
		
		//Atualiza validador para gerar a notificacao de entrega
		If !lMsErroAuto
			lLinha := .T.
		Endif
	
	Endif

	If AllTrim(TMPHWA->NOTA) != 'SEM LINHA ENTREGA' .Or. lLinha

		cXml :=  '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
		cXml +=  '<listPedidoFullType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">'
		cXml +=  '    <pedido>'
		cXml +=  '        <numero>'+AllTrim(TMPHWA->C5_XNPSITE)+'</numero>'
		cXml +=  '        <statusConfEntrega>0</statusConfEntrega>'
		cXml +=  '        <postoEntregaGar>'+AllTrim(TMPHWA->C5_XPOSTO)+'</postoEntregaGar>'
		cXml +=  '        <postoEntrega>'+Posicione("SZ3",4,xFilial("SZ3")+TMPHWA->C5_XPOSTO,"Z3_DESENT")+'</postoEntrega>'
		cXml +=  '        <agenteEntrega>12345678909</agenteEntrega>'
		cXml +=  '        <dataEntrega>'+DtoC(dDatabase)+'</dataEntrega>'
		cXml +=  '        <horaEntrega>'+Time()+'</horaEntrega>'
		cXml +=  '    </pedido>'
		cXml +=  '</listPedidoFullType>'
		
		oWsObj:updateConfirmarEntregas(cXml)
	
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2)  // Soap Fault Code
		cSoapFDescr := GetWSCError(3)  // Soap Fault Description

	Endif
	
	TMPHWA->(DbSkip())
Enddo

Return