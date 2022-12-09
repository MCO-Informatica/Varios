#Include 'Protheus.ch'

Static __Shop    := {"ISHOPL_INDEFINIDO","ISHOPL_TEF","ISHOPL_BOLETO","ISHOPL_ITAUCARD","BB_INDEFINIDO","BB_TEF"}

//+----------------------+----------------------+---------------+--------------+-----------------+------------------------------------------------+
//| Origem PEDIDO        | CHECKOUT             | C5_XORIGPV	| Z11_ORIGEM   | É LEGADO?       | QUANDO GERA PEDIDO GAR                         |
//+----------------------+----------------------+---------------+--------------+-----------------+------------------------------------------------+
//| 1. Portal GAR        | GAR(1)               | 2=Varejo		| ''		   | LEGADO          | EXISTE PEDIDO GAR NA MENSAGEM DO 'ENVIAPEDIDO' |
//| 2. Portal Certisign  | HARDWARE_AVULSO(2)   | 3=Hard.Avulso	| ''           |                 |                                                |
//| 3. Portal Assinatura | PORTAL_ASSINATURA(3) | 7=Port.Ass.	| ''           |                 |                                                |
//| 4. Venda de cursos   | CURSOS(4)            | 8=Cursos		| ''           |                 |                                                |
//| 5. Portal SSL        | PORTAL_SSL(5)        | 9=Port.SSL	| ''           |                 |                                                |
//| 6. Ponto Movel       | PONTO_MOVEL(6)       | 0=Pto.Movel	| ''           |                 |                                                |
//| 7. Gar NOVO          | GAR_NOVO(7)          | A=Varejo		| ''           | LEGADO          | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
//| 8. Prodest           | PRODEST(8)           | ''			| '8=Dua'      |                 |                                                |
//| 9. Venda SAC         | SAC(9)               | B=SAC			| ''           |                 | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
//| 10. Emissao Carteira | PDA(10)              | C=PDA			| ''           |                 |                                                |
//| 11. Sage             | Sage(11)             | ''			| '11=Sage'    |                 |                                                |
//| 12. Televendas       | Televendas(12)       | 4=Televendas	| ''           |                 |                                                |
//| 13. CertiBio         | CertiBio(13)         | D=CertiBio	| ''           |                 |                                                |
//| 14. Combo de Kit´s   | Ecommerce(14)        | 2=Varejo		| ''           |                 | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
//| 15. SalesForce  	 | SALESFORCE(15)	    | 2=Varejo      |              |                 | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
//| 16. GAD (Domicilio)  | GAD(16)			    | 5=AtendiDomici|              |                 |                                                |
//+----------------------+----------------------+---------------+--------------+-----------------+------------------------------------------------+

//Origem da venda
#define cORIGEM_VENDA_PORTAL_GAR		'1' 
#define cORIGEM_VENDA_PORTAL_CERTISIGN  '2'
#define cORIGEM_VENDA_PORTAL_ASSINATURA '3'
#define cORIGEM_VENDA_VENDA_CURSOS      '4'
#define cORIGEM_VENDA_PORTAL_SSL        '5'
#define cORIGEM_VENDA_PONTO_MOVEL       '6'
#define cORIGEM_VENDA_GAR_NOVO          '7'
#define cORIGEM_VENDA_PRODEST           '8'
#define cORIGEM_VENDA_VENDA_SAC         '9'
#define cORIGEM_VENDA_EMISSAO_CARTEIRA  '10'
#define cORIGEM_VENDA_SAGE              '11'
#define cORIGEM_VENDA_TELEVENDAS        '12'
#define cORIGEM_VENDA_CERTIBIO          '13'
#define cORIGEM_VENDA_COMBO_KIT         '14'
#define cORIGEM_VENDA_SALESFORCE        '15'
#define cORIGEM_VENDA_GAD               '16'

//Lista de parametros para o comboVarejo()
#define nCOMBO_OBJETO_PEDIDO  	  1
#define nCOMBO_DATA_ENTREGA   	  2
#define nCOMBO_NUMERO_VOUCHER 	  3
#define nCOMBO_QUANTIDADE_VOUCHER 4
#define nCOMBO_ORIGEM_VENDA       5
#define nCOMBO_PEDIDO_SITE 		  6
#define nCOMBO_ECOMMERCE 		  7
#define nCOMBO_CUMPOM_DESCONTO    8

//Lista do array de parametros para o VNDA260()
#define nPARAM_260_N_OPC							01 //aParam[01] - nOpc      
#define nPARAM_260_C_TIPO							02 //aParam[02] - cTipo     
#define nPARAM_260_C_CLIENTE						03 //aParam[03] - cCliente  
#define nPARAM_260_C_LOJA_CLIENTE					04 //aParam[04] - cLjCli    
#define nPARAM_260_C_TIPO_CLIENTE					05 //aParam[05] - cTpCli    
#define nPARAM_260_C_OBSOLETO_1						06 //aParam[06] - cForPag   
#define nPARAM_260_D_EMISSAO						07 //aParam[07] - dEmissao  
#define nPARAM_260_C_POSTO_GAR						08 //aParam[08] - cPosGAR   
#define nPARAM_260_C_POSTO_LOJA 					09 //aParam[09] - cPosLoj   
#define nPARAM_260_C_FORMA_PAGAMENTO				10 //aParam[10] - cForPag  
#define nPARAM_260_C_CARTAO_CREDITO_NUMERO			11 //aParam[11] - cNumCart  
#define nPARAM_260_C_CARTAO_CREDITO_NOME			12 //aParam[12] - cNomTit  
#define nPARAM_260_C_CARTAO_CREDITO_CODIGO			13 //aParam[13] - cCodSeg  
#define nPARAM_260_C_CARTAO_CREDITO_DATA_VALIDADE	14 //aParam[14] - cDtVali  
#define nPARAM_260_N_CARTAO_CREDITO_NUMERO_PARCELA	15 //aParam[15] - nParcel   - cParcela
#define nPARAM_260_C_CARTAO_CREDITO_BANDEIRA		16 //aParam[16] - cTipCar  
#define nPARAM_260_C_PEDIDO_SITE					17 //aParam[17] - cNpSite  
#define nPARAM_260_C_BOLETO_LINHA_DIGITAVEL			18 //aParam[18] - cLinDig  
#define nPARAM_260_C_VOUCHER_NUMERO					19 //aParam[19] - cNumvou  
#define nPARAM_260_N_VOUCHER_QUANTIDADE				20 //aParam[20] - nQtdVou  
#define nPARAM_260_C_TABELA_PRECO					21 //aParam[21] - cTabela1 
#define nPARAM_260_C_ORIGEM_VENDA					22 //aParam[22] - cOriVen  
#define nPARAM_260_C_PEDIDO_GAR						23 //aParam[23] - cPedGar  
#define nPARAM_260_A_VOUCHER_FLUXO_VOUCHER			24 //aParam[24] - aRVou    
#define nPARAM_260_L_ENTREGA						25 //aParam[25] - lEntrega 
#define nPARAM_260_N_VALOR_FRETE					26 //aParam[26] - nVlrFret 
#define nPARAM_260_C_PEDIDO_LOG						27 //aParam[27] - cPedLog  
#define nPARAM_260_N_TOTAL_PEDIDO					28 //aParam[28] - nTotPed  
#define nPARAM_260_C_SERVICO_ENTREGA				29 //aParam[29] - cServEnt 
#define nPARAM_260_C_TIPO_SHOP						30 //aParam[30] - cTipShop 
#define nPARAM_260_C_PEDIDO_ORIGEM					31 //aParam[31] - cPedOrigem 
#define nPARAM_260_C_CODIGO_DUA						32 //aParam[32] - cCodDUA 
#define nPARAM_260_C_CGC_DUA						33 //aParam[33] - cCGCDUA 
#define nPARAM_260_C_MUN_DUA						34 //aParam[34] - cMunDUA 
#define nPARAM_260_C_OBS_DUA						35 //aParam[35] - cObsDUA 
#define nPARAM_260_C_EST_DUA						36 //aParam[36] - cEstDUA 
#define nPARAM_260_C_PROTOCOLO						37 //aParam[37] - cProtocolo 
#define nPARAM_260_C_CARTAO_NUMERO_DOCUMENTO		38 //aParam[38] - cDocCar 
#define nPARAM_260_C_CARTAO_AUTORIZACAO				39 //aParam[39] - cDocAut 
#define nPARAM_260_C_CARTAO_CONFIRMACAO				40 //aParam[40] - cCodConf 
#define nPARAM_260_C_ORIGEM_VOUCHER					41 //aParam[41] - cOriVou 
#define nPARAM_260_C_VENDEDOR_CODIGO				42 //aParam[42] - cCodRev 
#define nPARAM_260_C_ECOMMERCE						43 //aParam[43] - cEcommerce 
#define nPARAM_260_C_CUPOM_DESCONTO					44 //aParam[44] - cCupomDesc 
#define nPARAM_260_N_VALOR_BRUTO					45 //aParam[45] - nValBruto 
#define nPARAM_260_N_VALOR_DESCONTO					46 //aParam[46] - nValDesc 

//Forma de Pagamento no XML
#define cFORMA_PAGAMENTO_CARTAO_XML 	"cartao"
#define cFORMA_PAGAMENTO_BOLETO_XML 	"boleto"
#define cFORMA_PAGAMENTO_VOUCHER_XML 	"voucher"
#define cFORMA_PAGAMENTO_DEBITO_XML     "debito"
#define cFORMA_PAGAMENTO_DUA_XML     	"dua"

//Forma de pagamento no Protheus //C5_TIPMOV
#define cFORMA_PAGAMENTO_BOLETO_CODIGO  						"1"
#define cFORMA_PAGAMENTO_CARTAO_CREDITO_CODIGO 	 				"2"
#define cFORMA_PAGAMENTO_DEBITO_AUTOMATICO_CODIGO  				"3"
#define cFORMA_PAGAMENTO_DEBITO_AUTOMATICO_BANCO_BRASIL_CODIGO  "4"
#define cFORMA_PAGAMENTO_VOUCHER_CODIGO 						"6"
#define cFORMA_PAGAMENTO_DEBITO_AUTOMATICO_ITAU_CODIGO  		"7"
#define cFORMA_PAGAMENTO_DUA_CODIGO  							"8"

//Tipo de voucher
#define cEMISSOR_VOUCHER_PROTHEUS '1' //Emissor Voucher ERP Protheus(1)  -- Usado para diferenciar 
#define cEMISSOR_VOUCHER_SAGE     '2' //Emissor Voucher Sage(2)

//Tipo de pessoa
#define cPESSOA_FISICA    'PF'
#define cPESSOA_JURIDICA  'PJ'

//Tipo de processamento na ExecAuto
#define cTIPO_PROCESSAMENTO_INCLUSAO  3
#define cTIPO_PROCESSAMENTO_ALTERACAO 4

/*/{Protheus.doc} vnda630
Rotina do tipo JOB que seleciona os pedido com divergencia de valores entre pedido e seus itens
@author david.oliveira
@since 13/04/2015
@version 1.0
@param aParam, array, array com 2 posições que indica empresa e filial de processamento da rotina
/*/
User Function vnda630( aParam )
	Local lReturn	 := .T.
	Local cError	 := ""
	Local cWarning	 := ""
	Local aProdut260 := {}
	Local aProdut430 := {}
	Local lChkVou	 := .F.
	Local cRootPath	 := ""
	Local cArquivo	 := ""
	Local cQryGT	 := ""
	Local cUpdLis	 := ""
	Local cUpdPed	 := ""
	Local cID		 := ""
	Local oXmlPst	 := nil
	Local bOldBlock
	Local cErrorMsg  := ''
	Local cPedAnt	 := ""
	local cAliasPV   := getNextAlias()
	local oPedido    := nil
	local aVNDA260   := {}
	local oQuery     := nil

	Private oXml	 := Nil
	Private nPed	 := 0

	U_GTPutRet('VNDA630','A')

	Conout( "[ VNDA630 - " + Dtoc( Date() ) + " - " + Time() + " ] INICIO" )

	If Select("PEDGT") > 0
		DbSelectArea("PEDGT")
		PEDGT->(DbCloseArea())
	EndIf

	cQryGT := "SELECT "
	cQryGT += "       C5_FILIAL, " + CRLF
	cQryGT += "       C5_NUM, " + CRLF
	cQryGT += "       C5_EMISSAO, " + CRLF
	cQryGT += "       C5_XNPSITE, " + CRLF
	cQryGT += "       C5_TOTPED," + CRLF
	cQryGT += "       Sum(C6_VALOR) C6_VALOR" + CRLF
	cQryGT += "FROM   " + RetSqlName("SC5") + " SC5 " + CRLF
	cQryGT += "       INNER JOIN " + RetSqlName("SC6") + " SC6 " + CRLF
	cQryGT += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cQryGT += "                  AND C6_FILIAL = C5_FILIAL " + CRLF
	cQryGT += "                  AND C6_NUM = C5_NUM " + CRLF
	cQryGT += "                  AND C6_XOPER = ANY ( '01', '51', '52', '61', '62' ) " + CRLF
	cQryGT += "WHERE  SC5.D_E_L_E_T_ = ' ' " + CRLF
	cQryGT += "       AND C5_FILIAL = '" + xFilial('SC5') + "' " + CRLF
	cQryGT += "       AND C5_EMISSAO >= '20200601' " + CRLF
	cQryGT += "       AND C5_XNPSITE <> '' " + CRLF
	cQryGT += "       AND NOT C5_NOTA = ANY ('XXXXXX','XXXXXXXXX') " + CRLF
	cQryGT += "GROUP  BY "
	cQryGT += "		C5_FILIAL, " + CRLF
	cQryGT += "		C5_NUM, " + CRLF
	cQryGT += "		C5_EMISSAO, " + CRLF
	cQryGT += "     C5_XNPSITE, " + CRLF
	cQryGT += "     C5_TOTPED " + CRLF
	cQryGT += "HAVING C5_TOTPED <> Sum(C6_VALOR)" + CRLF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGT),cAliasPV,.F.,.T.)

	oQuery := CSQuerySQL():New()
	if oQuery:Consultar( cQryGT )
		enviaMail( oQuery:GetAlias() )
	endif
	return {}
	return {}

	//Nao esta processando
	While PEDGT->(!Eof())
		cQryGT := " SELECT "
		cQryGT += "  GT_ID, " 
		cQryGT += "  GT_PEDGAR "
		cQryGT += " FROM GTIN "
		cQryGT += " WHERE "
		cQryGT += "      GT_XNPSITE = '"+PEDGT->C5_XNPSITE+"' AND "
		cQryGT += "      GT_TYPE = 'F' AND "
		cQryGT += "      GTIN.D_E_L_E_T_ = ' ' "
		cQryGT += " GROUP BY " 
		cQryGT += "  GT_ID, " 
		cQryGT += "  GT_PEDGAR "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGT),"QRYGT",.F.,.T.)
		DbSelectArea("QRYGT")

		cPedAnt	:= ""

		If QRYGT->(!Eof())
			//(TSM David - 10/01/19) Novo fluxo com informações por item
			cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
			cRootPath	:= cRootPath + "vendas_site\"

			cID			:= AllTrim(QRYGT->GT_ID)
			If Len(cID) <= 18
				cArquivo	:= "Pedidos_" + Left(cID,12) + ".XML"
			Else
				cArquivo	:= "Pedidos_" + Left(cID,17) + ".XML"
			EndIf		
			cArquivo	:= cRootPath + cArquivo
			oXml		:= XmlParserFile( cArquivo, "_", @cError, @cWarning )

			If Empty(cError)

				If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
					XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
				EndIf

				nPed := Val( Right( alltrim( cID ), 6 ) )
				If Valtype(nPed) == "N" .and. nPed > 0  //For nPed := 1 to Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO)
					aProdut260 := {}
					aProdut430 := {}
					oPedido    := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]

					//Carrega dados do pedido
					loadPedido( @aVNDA260, oPedido )

					cUpdPed := "UPDATE GTIN "
					cUpdPed += "SET GT_SEND = 'T' "
					cUpdPed += "WHERE GT_ID = '" + cID + "' "
					cUpdPed += "  AND GT_TYPE = 'F' "
					cUpdPed += "  AND GT_SEND = 'F' "
					cUpdPed += "  AND GT_XNPSITE = '" + aVNDA260[ nPARAM_260_C_PEDIDO_SITE ] + "' "
					cUpdPed += "  AND D_E_L_E_T_ = ' ' "

					TCSqlExec(cUpdPed)

					//Semaforo para controle de processamento de pedido
					If LockByName( aVNDA260[ nPARAM_260_C_PEDIDO_SITE ],.F.,.F.)

						//TRATAMENTO PARA ERRO FATAL NA THREAD
						cErrorMsg := ""
						bOldBlock := ErrorBlock({|e| U_ProcError(e) })

						BEGIN SEQUENCE

							lChkVou	:= .F.

							//Carrega dados entrega
							loadEntreg( @aVNDA260, oPedido )

							//Carrega dados de pagamento
							loadfrmPgt( @aVNDA260, oPedido, lChkVou )

							//Carraga dados para executar classe comboVarejo
							loadCombo( @aParCombo, oPedido, aVNDA260 ) 

							//Carrega dados de cliente	
							loadClient( aVNDA260, oPedido )

							//Nova forma Rafael beghini 25/07/2019
							oCombo 	:= Combo():XmlBProd( aParCombo[ nCOMBO_OBJETO_PEDIDO      ],; 
							aParCombo[ nCOMBO_DATA_ENTREGA       ], ;
							aParCombo[ nCOMBO_NUMERO_VOUCHER     ], ;
							aParCombo[ nCOMBO_QUANTIDADE_VOUCHER ], ;
							aParCombo[ nCOMBO_ORIGEM_VENDA       ], ;
							aParCombo[ nCOMBO_PEDIDO_SITE        ], ;
							aParCombo[ nCOMBO_ECOMMERCE          ], ;
							aParCombo[ nCOMBO_CUMPOM_DESCONTO    ];
							)

							IF oCombo:lRetorno
								aProdut260 	:= oCombo:aProduto
								aProdut430 	:= oCombo:aProdPrin
								aVNDA260[ nPARAM_260_C_TABELA_PRECO ] := oCombo:cTabPreco

								//Atualizar valor se campo estiver vazio
								If aVNDA260[ nPARAM_260_N_VALOR_BRUTO 	] == 0
									aVNDA260[ nPARAM_260_N_VALOR_BRUTO 	] := oCombo:nValor
								EndIF

								//Se a forma de pagamento for voucher, faco as devidas validacoes
								If lChkVou
									fluxoVouch( @aVNDA260, aProdut430 )
								EndIF

								//Dados do Posto
								loadPosto( @aVNDA260, oPedido )

								//Reordena o array de produtos para que o pedido seja criado agrupando os produtos por kit´s
								sortProd( @aProdut260, aVNDA260 )

								//Processa pedido de venda
								U_VNDA260(cId, aVNDA260, aProdut260, .T.)
							Else
								cErrorMsg := oCombo:cMsgRetorno
								U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00019",cPedLog,"Inconsistência na Geração do Pedido"+CRLF+cErrorMsg}},aVNDA260[ nPARAM_260_C_PEDIDO_SITE ],cEcommerce)

								cUpdPed := "UPDATE GTIN "
								cUpdPed += "SET GT_SEND = 'T' "
								cUpdPed += "WHERE GT_ID = '" + cID + "' "
								cUpdPed += "  AND GT_TYPE = 'F' "
								cUpdPed += "  AND GT_SEND = 'F' "
								cUpdPed += "  AND GT_XNPSITE = '" + aVNDA260[ nPARAM_260_C_PEDIDO_SITE ] + "' "
								cUpdPed += "  AND D_E_L_E_T_ = ' ' "

								TCSqlExec(cUpdPed)

								// Solta o lock do processo deste item
								UnLockByName(aVNDA260[ nPARAM_260_C_PEDIDO_SITE ],.F.,.F.)//U_GarUnlock(aVNDA260[ nPARAM_260_C_PEDIDO_SITE ])
							END SEQUENCE

							If InTransact()
								// Esqueceram transacao aberta ... Fecha fazendo commit ...
								Conout("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***")
								EndTran()
							Endif

							ErrorBlock(bOldBlock)
							cErrorMsg := U_GetProcError()

							If !empty(cErrorMsg)
								U_GTPutOUT(cID,"F",aVNDA260[ nPARAM_260_C_PEDIDO_SITE ],{"EXECUTAPEDIDOS",{.F.,"E00019",aVNDA260[ nPARAM_260_C_PEDIDO_SITE ],"Inconsistência na Geração do Pedido"+CRLF+cErrorMsg}},aVNDA260[ nPARAM_260_C_PEDIDO_SITE ])

								cUpdPed := "UPDATE GTIN "
								cUpdPed += "SET GT_SEND = 'T' "
								cUpdPed += "WHERE GT_ID = '" + cID + "' "
								cUpdPed += "  AND GT_TYPE = 'F' "
								cUpdPed += "  AND GT_SEND = 'F' "
								cUpdPed += "  AND GT_XNPSITE = '" + aVNDA260[ nPARAM_260_C_PEDIDO_SITE ] + "' "
								cUpdPed += "  AND D_E_L_E_T_ = ' ' "

								TCSqlExec(cUpdPed)
							Endif

						END SEQUENCE

					EndIf
				ELSE

					U_GTPutOUT(cID,"F",AllTrim(QRYGT->GT_PEDGAR),{"EXECUTAPEDIDOS",{.F.,"E00019",AllTrim(QRYGT->GT_PEDGAR),"Inconsistência na Geração do Pedido"+CRLF+"Não foi possível abrir o XML"}},AllTrim(QRYGT->GT_PEDGAR))

				EndIf//Next nPed
			Else
				U_GTPutOUT(cID,"F","",{"EXECUTAPEDIDOS",{.F.,"E00001","","Inconsistência na ABertura do XML de Pedidos "+CRLF+cError}})

				cUpdLis := "UPDATE GTIN "
				cUpdLis += "SET GT_SEND = 'T' "
				cUpdLis += "WHERE GT_ID = '" + cID + "' "
				cUpdLis += "  AND GT_TYPE = 'F' "
				cUpdLis += "  AND GT_SEND = 'F' "
				cUpdLis += "  AND D_E_L_E_T_ = ' ' "

				TCSqlExec(cUpdLis)

			EndIf

			cUpdPed := "UPDATE GTIN "
			cUpdPed += "SET GT_SEND = 'T' "
			cUpdPed += "WHERE GT_ID = '" + cID + "' "
			cUpdPed += "  AND GT_TYPE = 'F' "
			cUpdPed += "  AND GT_SEND = 'F' "
			cUpdPed += "  AND GT_XNPSITE = '" + AllTrim(QRYGT->GT_PEDGAR) + "' "
			cUpdPed += "  AND D_E_L_E_T_ = ' ' "

			TCSqlExec(cUpdPed)

			oXml	:=nil
			oXmlPst	:=nil
			DelClassIntf()
		End
		DbSelectArea("QRYGT")
		QRYGT->(DbCloseArea()) 
		PEDGT->(DbSkip())	
	EndDo
	PEDGT->(DbCloseArea())

	Conout( "[ VNDA630 - " + Dtoc( Date() ) + " - " + Time() + " ] FINAL" )
Return(lReturn)

//Envia email
static function enviaMail( cAliasPV )
	local cHtml    := ""
	local cTitulo  := "[VENDAS_VAREJO] VNDA630 RELATORIO OCORRENCIAS"
	local cMsgHTML := "Relação de possíveis diferenças entre cabeçalho do pedido de venda e itens do pedido de venda SC5 /SC6."
	local cEmail   := "sistemascorporativos@certisign.com.br,bruno.nunes@certisign.com.br,amoreira@certisign.com.br,yuri.volpe@certisign.com.br"//superGetMv( "MV_RH220ML", .F., "sistemascorporativos@certisign.com.br" )
	local cAnexo   := ""

	//Inicia construcao do html
	cHtml += '<!DOCTYPE HTML>'
	cHtml += '<html>'
	cHtml += '	<head>'
	cHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> '
	cHtml += '	</head>'
	cHtml += '	<body style="font-family: Fontin Roman, Lucida Sans Unicode">'
	cHtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" align="center">'
	cHtml += '				<table width="627">'
	cHtml += '					<tr>'
	cHtml += '						<td valign="middle" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<h2>'
	cHtml += '								<span style="color:#FE5000" ><strong>'+cTitulo+'</strong></span>'
	cHtml += '								<br />'
	cHtml += '								<span style="color:#003087" >Recursos Humanos</span>'
	cHtml += '							</h2>'
	cHtml += '						</td>'
	cHtml += '						<td valign="top" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	cHtml += '						</td>'
	cHtml += '					</tr>'
	cHtml += '				</table>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>'+cMsgHTML+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'


	//cab
	cHtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	cHtml += '		<tr>'
	chtml += '			<td>C5_FILIAL</td>'
	chtml += '			<td>C5_NUM</td>'				
	chtml += '			<td>C5_EMISSAO</td>'
	chtml += '			<td>C5_XNPSITE</td>'
	chtml += '			<td>C5_TOTPED</td>'
	chtml += '			<td>C6_VALOR</td>'
	chtml += '		</tr>'

	( cAliasPV )->( dbGoTop())
	while ( cAliasPV )->(!EoF())

		chtml += '		<tr>'
		chtml += '			<td valign="top">'+cValToChar(( cAliasPV )->C5_FILIAL)+'</td>'
		chtml += '			<td valign="top">'+cValToChar(( cAliasPV )->C5_NUM)+'</td>'
		chtml += '			<td valign="top">'+cValToChar(( cAliasPV )->C5_EMISSAO)+'</td>'
		chtml += '			<td valign="top">'+cValToChar(( cAliasPV )->C5_XNPSITE)+'</td>'
		chtml += '			<td valign="top">'+cValToChar(( cAliasPV )->C5_TOTPED)+'</td>'
		chtml += '			<td valign="top">'+cValToChar(( cAliasPV )->C6_VALOR)+'</td>'
		chtml += '		</tr>'

		( cAliasPV )->(dbSkip())
	end
	( cAliasPV )->(dbCloseArea())
	cHtml += '	</table>'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" colspan="2" style="padding:5px" width="0">'
	cHtml += '				<p align="left">'
	cHtml += '					<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	cHtml += '				</p>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '	</table>'
	cHtml += '	</body>'
	cHtml += '</html>'

	//1 - destinatario
	//2 - assunto
	//3 - html
	//4 - anexo (separados por ;
	fsSendMail( cEmail, cTitulo, cHtml, cAnexo )
return

static function loadCombo( aParCombo, oPedido, aVNDA260 )
	default aParCombo := {}

	If	Valtype(oPedido:_PRODUTO) <> "A"
		XmlNode2Arr( oPedido:_PRODUTO, "_PRODUTO" )
	EndIf
	aParCombo[ nCOMBO_OBJETO_PEDIDO      ] := oPedido:_PRODUTO //Objeto de pedido
	aParCombo[ nCOMBO_DATA_ENTREGA       ] := iif ( type("oPedido:_DATA:TEXT") <> "U", CtoD(SubStr(oPedido:_DATA:TEXT,1,10)), ctod("//") ) //Data da entrega
	aParCombo[ nCOMBO_NUMERO_VOUCHER     ] := aVNDA260[ nPARAM_260_C_VOUCHER_NUMERO     ] //Numero do voucher
	aParCombo[ nCOMBO_QUANTIDADE_VOUCHER ] := aVNDA260[ nPARAM_260_N_VOUCHER_QUANTIDADE ] //Quantidade consumida
	aParCombo[ nCOMBO_ORIGEM_VENDA       ] := aVNDA260[ nPARAM_260_C_ORIGEM_VENDA ] 
	aParCombo[ nCOMBO_PEDIDO_SITE        ] := aVNDA260[ nPARAM_260_C_PEDIDO_SITE ]
	aParCombo[ nCOMBO_ECOMMERCE          ] := aVNDA260[ nPARAM_260_C_ECOMMERCE      ] 
	aParCombo[ nCOMBO_CUMPOM_DESCONTO    ] := aVNDA260[ nPARAM_260_C_CUPOM_DESCONTO ] 
return 

static function loadfrmPgt( aVNDA260, oPedido, lChkVou )
	local oformaPgto := nil
	local oContato   := nil
	Local cEmailC	 := ""
	Local cNomeC	 := ""
	Local cCpfC		 := ""

	default aVNDA260 := {}
	default lChkVou  := .F.

	//So continua se passar o objeto XML do pedido de venda
	if oPedido == nil
		return
	endif

	oformaPgto := oPedido:_PAGAMENTO
	oContato   := oPedido:_CONTATO

	//Zero as variaveis das formas de pagamento, para pegar a proxima
	aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_NUMERO 		 ] := ""
	aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_NOME 			 ] := ""
	aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_CODIGO 		 ] := ""
	aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_DATA_VALIDADE  ] := ""
	aVNDA260[ nPARAM_260_N_CARTAO_CREDITO_NUMERO_PARCELA ] := ""
	aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_BANDEIRA       ] := " "
	aVNDA260[ nPARAM_260_C_BOLETO_LINHA_DIGITAVEL        ] := ""
	aVNDA260[ nPARAM_260_C_VOUCHER_NUMERO 				 ] := ""
	aVNDA260[ nPARAM_260_N_VOUCHER_QUANTIDADE 			 ] := 0
	aVNDA260[ nPARAM_260_C_TIPO_SHOP 					 ] := "0"
	aVNDA260[ nPARAM_260_C_CODIGO_DUA 					 ] := ""
	aVNDA260[ nPARAM_260_C_CGC_DUA 						 ] := ""
	aVNDA260[ nPARAM_260_C_MUN_DUA 						 ] := ""
	aVNDA260[ nPARAM_260_C_OBS_DUA 						 ] := ""
	aVNDA260[ nPARAM_260_C_EST_DUA		   				 ] := "ES"
	aVNDA260[ nPARAM_260_C_CARTAO_NUMERO_DOCUMENTO  	 ] := ''
	aVNDA260[ nPARAM_260_C_CARTAO_AUTORIZACAO       	 ] := ''
	aVNDA260[ nPARAM_260_C_CARTAO_CONFIRMACAO       	 ] := ''
	aVNDA260[ nPARAM_260_C_ORIGEM_VOUCHER 				 ] := cEMISSOR_VOUCHER_PROTHEUS //Emissor Voucher ERP Protheus(1)  -- Usado para diferenciar emissor Voucher Sage(2)
	aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO 				 ] := ''

	If cFORMA_PAGAMENTO_CARTAO_XML $ oformaPgto:_XSI_TYPE:TEXT
		aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO               ] := cFORMA_PAGAMENTO_CARTAO_CREDITO_CODIGO
		aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_NOME           ] := ""//Nao deve mais informar esse dado oPedido:_PAGAMENTO:_NMTITULAR:TEXT
		aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_CODIGO         ] := ""//Nao deve mais informar esse dado oPedido:_PAGAMENTO:_CODSEG:TEXT
		aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_NUMERO         ] := iif ( type("oformaPgto:_NUMERO:TEXT"      ) <> "U", AllTrim( oformaPgto:_NUMERO:TEXT      ), "" )
		aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_DATA_VALIDADE  ] := iif ( type("oformaPgto:_DTVALID:TEXT"     ) <> "U", AllTrim( oformaPgto:_DTVALID:TEXT     ), "" )
		aVNDA260[ nPARAM_260_N_CARTAO_CREDITO_NUMERO_PARCELA ] := iif ( type("oformaPgto:_PARCELAS:TEXT"    ) <> "U", AllTrim( oformaPgto:_PARCELAS:TEXT    ), "" )
		aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_BANDEIRA       ] := iif ( type("oformaPgto:_TIPO:TEXT"        ) <> "U", AllTrim( oformaPgto:_TIPO:TEXT        ), "" )		
		aVNDA260[ nPARAM_260_C_CARTAO_NUMERO_DOCUMENTO       ] := iif ( type("oformaPgto:_DOCUMENTO:TEXT"   ) <> "U", AllTrim( oformaPgto:_DOCUMENTO:TEXT   ), "" )
		aVNDA260[ nPARAM_260_C_CARTAO_AUTORIZACAO            ] := iif ( type("oformaPgto:_AUTORIZACAO:TEXT" ) <> "U", AllTrim( oformaPgto:_AUTORIZACAO:TEXT ), "" )
		aVNDA260[ nPARAM_260_C_CARTAO_CONFIRMACAO            ] := iif ( type("oformaPgto:_CONFIRMACAO:TEXT" ) <> "U", AllTrim( oformaPgto:_CONFIRMACAO:TEXT ), "" )

		//Se for bandeira 9 ou 10 muda a forma de pagamento
		If aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_BANDEIRA    ] == "9" .or. ; //Nao tratei o hardcode porque nao o que significa essa bandeira
		aVNDA260[ nPARAM_260_C_CARTAO_CREDITO_BANDEIRA    ] == "10"	     //Nao tratei o hardcode porque nao o que significa essa bandeira
			aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO ] := cFORMA_PAGAMENTO_DEBITO_AUTOMATICO_CODIGO
		EndIf
	ElseIf cFORMA_PAGAMENTO_BOLETO_XML $ oformaPgto:_XSI_TYPE:TEXT
		aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO        ] := cFORMA_PAGAMENTO_BOLETO_CODIGO
		aVNDA260[ nPARAM_260_C_BOLETO_LINHA_DIGITAVEL ] := iif ( type("oformaPgto:_LINHADIGITAVEL:TEXT" ) <> "U", AllTrim( oformaPgto:_LINHADIGITAVEL:TEXT ), "" )		
	ElseIf cFORMA_PAGAMENTO_VOUCHER_XML $ oformaPgto:_XSI_TYPE:TEXT
		lChkVou		:= .T.
		aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO    ] := cFORMA_PAGAMENTO_VOUCHER_CODIGO
		aVNDA260[ nPARAM_260_C_VOUCHER_NUMERO     ]	:= iif ( type("oformaPgto:_NUMERO:TEXT"      ) <> "U", AllTrim( oformaPgto:_NUMERO:TEXT  ), "" )
		aVNDA260[ nPARAM_260_N_VOUCHER_QUANTIDADE ]	:= iif ( type("oformaPgto:_QTCONSUMIDA:TEXT" ) <> "U", Val( oformaPgto:_QTCONSUMIDA:TEXT ), 0  )

		//Tratamento para Voucher SAGE
		If Type( "oformaPgto:_EMISSOR:TEXT" ) <> "U"
			aVNDA260[ nPARAM_260_C_ORIGEM_VOUCHER ]	:= iif ( type("oformaPgto:_EMISSOR:TEXT" ) <> "U", AllTrim( oformaPgto:_EMISSOR:TEXT ), ""  )
			if aVNDA260[ nPARAM_260_C_ORIGEM_VOUCHER ] == cEMISSOR_VOUCHER_SAGE //Emissor Voucher SAGE - Nao tratei o hardcode porque nao o que significa esse emisso sage
				lChkVou	:= .F. // Não se faz necessário chegagem do voucher pois não foi gerado pelo ERP Protheus

				//Gravo dados do contato nas variáveis de DUA/SAGE para atualização da Z11
				cEmailC	:= iif ( type("oContato:_EMAIL:TEXT" ) <> "U", AllTrim( oContato:_EMAIL:TEXT ), ""  ) 
				cNomeC	:= iif ( type("oContato:_NOME:TEXT"  ) <> "U", AllTrim( oContato:_NOME:TEXT  ), ""  )
				cCpfC	:= iif ( type("oContato:_CPF:TEXT"   ) <> "U", AllTrim( oContato:_CPF:TEXT   ), ""  )
				cFoneC	:= iif ( type("oContato:_FONE:TEXT"  ) <> "U", AllTrim( oContato:_FONE:TEXT  ), ""  )

				aVNDA260[ nPARAM_260_C_CGC_DUA ] :=  cCpfC
				aVNDA260[ nPARAM_260_C_OBS_DUA ] := "Nome;"+cNomeC+";Email;"+cEmailC +";Fone;"+cFoneC				
			Endif
		Endif
	ElseIf cFORMA_PAGAMENTO_DEBITO_XML $ oformaPgto:_XSI_TYPE:TEXT
		aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO ] := cFORMA_PAGAMENTO_DEBITO_AUTOMATICO_ITAU_CODIGO //Shopline
		aVNDA260[ nPARAM_260_C_TIPO_SHOP       ] := Alltrim( Str( aScan( __Shop, { |x| x == oformaPgto:_TIPO:TEXT } ) ) )

		//Verifica se o tipo de pagamento é 4 ou 5
		If aVNDA260[ nPARAM_260_C_TIPO_SHOP    ] $ "4,5"
			aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO ] := cFORMA_PAGAMENTO_DEBITO_AUTOMATICO_BANCO_BRASIL_CODIGO
		EndIf
	ElseIf cFORMA_PAGAMENTO_DUA_XML $ oformaPgto:_XSI_TYPE:TEXT
		aVNDA260[ nPARAM_260_C_FORMA_PAGAMENTO ] := cFORMA_PAGAMENTO_DUA_CODIGO //DUA - Prodest
		aVNDA260[ nPARAM_260_C_CODIGO_DUA 	   ] := iif ( type("oformaPgto:_NUMERODUA:TEXT"      			) <> "U", AllTrim( oformaPgto:_NUMERODUA:TEXT  				), "" )
		aVNDA260[ nPARAM_260_C_CGC_DUA 		   ] := iif ( type("oformaPgto:_CPFCNPJ:TEXT"        			) <> "U", AllTrim( oformaPgto:_CPFCNPJ:TEXT  				), "" )
		aVNDA260[ nPARAM_260_C_MUN_DUA 		   ] := iif ( type("oformaPgto:_CODIGOMUNICIPIO:TEXT"        	) <> "U", AllTrim( oformaPgto:_CODIGOMUNICIPIO:TEXT  		), "" ) 
		aVNDA260[ nPARAM_260_C_OBS_DUA 		   ] := iif ( type("oformaPgto:_INFORMACAOCOMPLEMENTAR:TEXT"  ) <> "U", AllTrim( oformaPgto:_INFORMACAOCOMPLEMENTAR:TEXT  ), "" )
		aVNDA260[ nPARAM_260_C_EST_DUA		   ] := "ES" 
	EndIf
return


static function loadEntreg( aVNDA260, oPedido )
	local oEntrega := nil

	default aVNDA260 := {}

	//So continua se passar o objeto XML do pedido de venda
	if oPedido == nill
		return
	endif

	oEntrega := XmlChildEx(oPedido,"_ENTREGA")

	If ValType(oEntrega) <> 'U'
		aVNDA260[ nPARAM_260_L_ENTREGA		   ] :=  .T.
		aVNDA260[ nPARAM_260_N_VALOR_FRETE     ] := iif ( type("oEntrega:_VALOR:TEXT"   ) <> "U", AllTrim( oEntrega:_VALOR:TEXT  ), 0 )
		aVNDA260[ nPARAM_260_C_SERVICO_ENTREGA ] := iif ( type("oEntrega:_SERVICO:TEXT" ) <> "U", PadL(AllTrim(Str(Val(oEntrega:_SERVICO:TEXT))),5,"0"), "" )
	Else
		aVNDA260[ nPARAM_260_L_ENTREGA		   ] := .F.
		aVNDA260[ nPARAM_260_N_VALOR_FRETE     ] := 0
		aVNDA260[ nPARAM_260_C_SERVICO_ENTREGA ] := ""
	EndIf
return


static function loadPedido( aVNDA260, oPedido )
	default aVNDA260 := {}

	//So continua se passar o objeto XML do pedido de venda
	if oPedido == nill
		return
	endif

	aVNDA260[ nPARAM_260_N_OPC                   ] := cTIPO_PROCESSAMENTO_ALTERACAO
	aVNDA260[ nPARAM_260_C_TIPO                  ] := "N" //Tipo de pedido N = Normal
	aVNDA260[ nPARAM_260_A_VOUCHER_FLUXO_VOUCHER ] := {.T.,""}
	aVNDA260[ nPARAM_260_C_POSTO_GAR             ] := "" //cPosGAR
	aVNDA260[ nPARAM_260_C_POSTO_LOJA            ] := ""//cPosLoj
	aVNDA260[ nPARAM_260_C_PEDIDO_SITE           ] := iif ( type("oPedido:_NUMERO:TEXT"             ) <> "U", AllTrim( oPedido:_NUMERO:TEXT             ), "" )
	aVNDA260[ nPARAM_260_C_VENDEDOR_CODIGO       ] := iif ( type("oPedido:_CODREV:TEXT"             ) <> "U", AllTrim( oPedido:_CODREV:TEXT             ), "" )//-- Recupera o Código de Revenda do XML
	aVNDA260[ nPARAM_260_C_PROTOCOLO             ] := iif ( type("oPedido:_PROTOCOLO:TEXT"          ) <> "U", AllTrim( oPedido:_PROTOCOLO:TEXT          ), "" )
	aVNDA260[ nPARAM_260_C_PEDIDO_GAR            ] := iif ( type("oPedido:_NUMEROPEDIDOGAR:TEXT"    ) <> "U", AllTrim( oPedido:_NUMEROPEDIDOGAR:TEXT    ), "" )
	aVNDA260[ nPARAM_260_C_PEDIDO_ORIGEM         ] := iif ( type("oPedido:_NUMEROPEDIDOORIGEM:TEXT" ) <> "U", AllTrim( oPedido:_NUMEROPEDIDOORIGEM:TEXT ), "" )
	aVNDA260[ nPARAM_260_N_VALOR_BRUTO 	         ] := iif ( type("oPedido:_VALORBRUTO:TEXT"         ) <> "U", val( oPedido:_VALORBRUTO:TEXT             ), 0  )
	aVNDA260[ nPARAM_260_N_VALOR_DESCONTO        ] := iif ( type("oPedido:_VALORDESCONTO:TEXT"      ) <> "U", val( oPedido:_VALORDESCONTO:TEXT          ), 0  )
	aVNDA260[ nPARAM_260_D_EMISSAO               ] := iif ( type("oPedido:_DATA:TEXT"               ) <> "U", CtoD( SubStr( oPedido_DATA:TEXT, 1, 10 )  ), ctod("//")  )
	aVNDA260[ nPARAM_260_C_ORIGEM_VENDA          ] := iif ( type("oPedido:_ORIGEMVENDA:TEXT"        ) <> "U", AllTrim( oPedido:_ORIGEMVENDA:TEXT     ), "" )	
	aVNDA260[ nPARAM_260_C_ECOMMERCE             ] := iif ( type("oPedido:_PEDIDOECOMMERCE:TEXT"    ) <> "U", AllTrim( oPedido:_PEDIDOECOMMERCE:TEXT ), "" ) 
	aVNDA260[ nPARAM_260_C_CUPOM_DESCONTO        ] := iif ( type("oPedido:_CUPOMDESCONTO:TEXT"      ) <> "U", AllTrim( oPedido:_CUPOMDESCONTO:TEXT    ), "" ) 
	
	if aVNDA260[ nPARAM_260_C_PEDIDO_GAR      ] == "0"
		aVNDA260[ nPARAM_260_C_PEDIDO_GAR      ] := ""
	endif
	
	if empty( aVNDA260[ nPARAM_260_C_PEDIDO_ORIGEM   ] )
		aVNDA260[ nPARAM_260_C_PEDIDO_ORIGEM   ] :=  aVNDA260[ nPARAM_260_C_PEDIDO_SITE ]
	endif
return

static function loadPosto( aVNDA260, oPedido )
	local oPosto := nil
	
	default aVNDA260 := {}

	//So continua se passar o objeto XML do pedido de venda
	if oPedido == nill
		return
	endif
	
	//Dados do Posto
	oPosto := XmlChildEx(oPedido,"_POSTO")
	If aVNDA260[ nPARAM_260_C_ORIGEM_VENDA ] == cORIGEM_VENDA_PORTAL_CERTISIGN
	   aVNDA260[ nPARAM_260_C_POSTO_GAR  ] := iif( ValType( oPosto ) <> 'U', oPosto:_CODGAR:TEXT, "" ) //Codigo do GAR
	EndIf
return

static function fluxoVouch( aVNDA260, aProdut430 )
	local nProdPri := 0
	local aProcVou := {}
	For nProdPri := 1 to Len( aProdut430 ) 
		aProcVou := { aProdut430[ nProdPri ] }
		aVNDA260[ nPARAM_260_A_VOUCHER_FLUXO_VOUCHER ] := U_VNDA430( aProcVou							 , ;
																	 aProdut430[ nProdPri, 11 ]			 , ;
																	 aProdut430[ nProdPri, 12 ]			 , ;
																	 aVNDA260[ nPARAM_260_C_PEDIDO_SITE ], ;
																	 cID								 , ;
																	 nil								 , ;
																	 aVNDA260[ nPARAM_260_C_PEDIDO_SITE ])
		//+-----------------------------------------------------+
		//|Retorno do VNDA430                                   |
		//+----+------------------------------------------------+
		//|[01]| .T. Voucher valido, .F. Caso contrario         |
		//|[02]| Mensagem caso retorno for .F.                  |         
		//|[03]| Gera Pedido .T. ou .F.    #1                   |          
		//|[04]| Gera Nota Serviço .T. ou .F. #1                |       
		//|[05]| Gera Nota Produto .T. ou .F. #1                |       
		//|[06]| Codigo da Op. de Servico (51)#1                |       
		//|[07]| Codigo da Op. de Produto Venda (52)#1          | 
		//|[08]| Codigo da Op. de Produto Entrega (53)          | 
		//|[09]| Codigo do Pedido de Vendas                     |            
		//|[10]| Codigo do Fluxo do Voucher                     |			
		//|[11]| Tipo de Voucher                                |			            
		//+----+------------------------------------------------+
	Next nProdPri
return

static function sortProd( aProdut260, aVNDA260 )
 	local nItem := 0
	If aVNDA260[ nPARAM_260_C_ORIGEM_VENDA ] == cORIGEM_VENDA_COMBO_KIT
		aProdut260:= aSort( aProdut260,,, { |x, y| x[15]+x[16]+x[2] < y[15]+y[16]+y[2] })
		nItem := 0 
		aEval(aProdut260,{|x| nItem++, x[1] := StrZero(nItem, TamSX3("C6_ITEM")[1]) })
	Endif
return


static function loadClient( aVNDA260, oPedido )
	local cCGC    := ""
	local oFatura := nil
	
	default aVNDA260 := {}

	//So continua se passar o objeto XML do pedido de venda
	if oPedido == nill
		return
	endif	

	oFatura := oPedido:_FATURA
	If cPESSOA_FISICA $ oFatura:_XSI_TYPE:TEXT
		cCgc := iif ( type("oFatura:_CPF:TEXT"  ) <> "U", AllTrim( oFatura:_CPF:TEXT  ), "" )
	Else
		cCgc := iif ( type("oFatura:_CNPJ:TEXT" ) <> "U", AllTrim( oFatura:_CNPJ:TEXT ), "" )
    endif

	dbSelectArea("SA1")
	dbSetOrder(3) //A1_FILIAL + A1_CGC
	If dbSeek(xFilial("SA1") + U_CSFMTSA1(cCgc))
		aVNDA260[ nPARAM_260_C_CLIENTE      ] := SA1->A1_COD
		aVNDA260[ nPARAM_260_C_LOJA_CLIENTE ] := SA1->A1_LOJA
		aVNDA260[ nPARAM_260_C_TIPO_CLIENTE ] := SA1->A1_TIPO	
	EndIf
return