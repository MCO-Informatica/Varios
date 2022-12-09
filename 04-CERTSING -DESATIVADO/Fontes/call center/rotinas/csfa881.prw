//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | OTRS / JIRA               |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| 26/06/2020 | Bruno Nunes   | - Erro ao consultar por CPF, CNPJ, pedido site, pedido GAR quando o atributo     | 1.00   | SIS-555, SIS-530, SIS-376 |
//|            |               | "itemProduto"                                                                    |	       | SIS-70                    |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| 28/07/2020 | Bruno Nunes   | - Identificado erro 500 na busca de alguns contatos. Ajustado GetTrilha          | 1.01   | RN-1                      |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| 28/07/2020 | Bruno Nunes   | - Não consulta o pedido site: 11138719                                           | 1.02   | RN-2                      |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| 29/12/2020 | Bruno Nunes   | - Não consulta o CNPJ: 82602327000106                                            | 1.03   | RN-2                      |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'
#include 'tbiconn.ch'

STATIC aClock    := {}
STATIC lPostgres := .T. //( Upper( GetEnvServer() ) == 'POSTGRES' )
STATIC lTeste    := .F. // Variável para estabelecer o uso do check-out de teste.

/*/{Protheus.doc} RNProtheus
Serviços Protheus Webservice REST para integrar RightNow com GAR
SERVIÇO PROTHEUS PARA CONFERIR O TOKEN E
DEVOLVER DADOS DO PROTHEUS E GAR FORMATO JSON
@type web function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
WSRESTFUL RNProtheus DESCRIPTION 'Integração ERP Protheus x RightNow - Protheus/GAR'
	WSDATA cToken       AS STRING OPTIONAL
	WSDATA cLocalizador AS STRING OPTIONAL
	WSDATA cOpcConsulta AS STRING OPTIONAL
	
	WSMETHOD GET DESCRIPTION 'Integração ERP Prothueus x RightNow Cloud Service Orcale' WSSYNTAX '/rightnow/{id}'
END WSRESTFUL

/*/{Protheus.doc} GET
Serviços Protheus Webservice REST para integrar RightNow com GAR
SERVIÇO PROTHEUS PARA CONFERIR O TOKEN E
DEVOLVER DADOS DO PROTHEUS E GAR FORMATO JSON
@type method
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
WSMETHOD GET WSRECEIVE cToken, cLocalizador, cOpcConsulta WSSERVICE RNProtheus
	Local aParLog  := Array( 7 )
	Local aRet     := {'',''}
	Local cEnvSrv  := GetEnvServer()
	Local cLigaLog := 'MV_880_02'
	Local cReturn  := ''
	Local cStack   := 'Pilha de chamada: RNPROTHEUS()' + CRLF
	Local cThread  := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
	Local lRet     := .T.
	
	private aSA1 := {}
	
	DEFAULT cToken       := 'x' 
	DEFAULT cLocalizador := 'x'
	DEFAULT cOpcConsulta := 'x'
	
	U_rnConout('Parametros recebidos: ' + VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) )
		
	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif

	lLigaLog := GetMv( cLigaLog, .F. )

	If lLigaLog		
		aParLog[ 1 ] := 'CONSULTARPROTHEUS'
		aParLog[ 2 ] := 'RNPROTHEUS [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA EXTERNO.'
		aParLog[ 5 ] := U_rnGetNow()	
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	// Define o tipo de retorno do método
	::SetContentType('application/json')
	
	U_rnConout('Entrei no RNProtheus.')
	
	lRet := U_validPar( ::aURLParms, @aRet )
	
	If lRet
		lRet := procConsul( ::aURLParms, @cReturn, @aRet, @cStack, cThread )
	Endif
	
	U_rnConout('Sai do RNProtheus. ' + cThread)
	
	If lRet
		::SetResponse( cReturn )
	Else
		cReturn := '{"codigo": ' + aRet[ 1 ] + ',"menssagem": "' + aRet[ 2 ] +'" }'
		::SetResponse( cReturn )
		
		U_rnConout( 'Retorno inconsistente: ' + cReturn )
	Endif
		
	If lLigaLog
		aParLog[ 2 ] := 'RNPROTHEUS [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := aRet[ 1 ] + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	DelClassIntf()
Return( .T. )

 /*/{Protheus.doc} procConsul
 O objetivo do procConsul é validar o token e
 estabelecer o processamento conforme o que foi requisitado.
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/		
Static Function procConsul( aParam, cReturn, aRet, cStack, cThread )
	Local cDoc       := ''
	Local cKey       := ''
	Local cMV_881_06 := 'MV_881_06'
	Local cOpc       := ''
	Local cTip       := ''
	Local lRet       := .T.
	
	Private lVarInfo := .F.	
	
	cStack += 'procConsul()' + CRLF
	
	If .NOT. GetMv( cMV_881_06, .T. )
		CriarSX6( cMV_881_06, 'L', 'T=HABILITAR, F=DESABILITAR VARINFO P/ OBJETOS CHECKOUT/GAR. CSFA881.','.F.' )
	Endif
	
	lVarInfo := GetMv( cMV_881_06, .F. )
	
	If Len( aParam ) == 3
		cKey := aParam[ 1 ]
		cOpc := aParam[ 3 ]
		
		// cOpc = 1 => consultar por CPF/CNPJ (varios).
		// cOpc = 2 => consultar por pedido site (somente um).
		If cOpc == '1'
			cTip := SubStr( aParam[ 2 ], 1, 1 ) // A variável cTip pode ser 'T' = CPF/CNPJ do titular ou 'F' = CPF/CNPJ do faturamento.
			cDoc := Substr( aParam[ 2 ], 2 )
		Elseif cOpc == '2'
			cTip := SubStr( aParam[ 2 ], 1, 1 ) // A variável cTip pode ser 'S' = pedido site ou 'G' = pedido GAR.
			cDoc := Substr( aParam[ 2 ], 2 )
		Endif
		
		U_rnConout('Vou validar o token. ' + cThread)
		
		lRet := U_rnVldToken( cKey, @aRet, @cStack, cThread )
		
		If lRet
			U_rnConout( 'Token homologado. ' + cThread )
			If cOpc == '1' .OR. cOpc == '2'
				U_rnConout( 'Vou iniciar o pontoCentr opcao: ' + cOpc + ' cTip: ' + cTip + ' cDoc: ' + cDoc + ' ' + cThread )
				
				cReturn := pontoCentr( cTip, cDoc, cOpc, @cStack, cThread )
				
				U_rnConout('Sai do pontoCentr. '+cThread)
			Else
				lRet := .F.
				aRet[ 1 ] := '315'
				aRet[ 2 ] := 'Conteudo do terceiro parametro invalido: ' + cOpc + '.'
				U_rnConout( aRet[ 2 ] +  ' ' + cThread)
			Endif
		Else
			U_rnConout( aRet[ 2 ] + ' ' + cThread )
		Endif
	Else
		lRet := .F.
		aRet[ 1 ] := '314'
		aRet[ 2 ] := 'Quantidade de parametro invalido. Esperado: token/identificador+documento/type.'
		U_rnConout( aRet[ 2 ]  + cThread )	
	Endif
Return lRet

/*/{Protheus.doc} pontoCentr
O objetivo do pontoCentr é processar os tipos de
requisição e devolver os dados no formato json.
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/		
Static Function pontoCentr( cTip, cDoc, cOpc, cStack, cThread )
	Local aCertif 	 := {}
	Local aERP 		 := {}
	Local aFindDPed  := {}
	Local aTrilha 	 := {}
	Local aPEDIDO 	 := {}
	Local aHead1     := {}
	Local aHead11    := {}
	Local aHead12    := {}
	Local aHead13    := {}
	Local aHead14    := {}
	Local aHead15    := {}
	Local aHead2     := {}
	Local aHead3     := {}
	Local aHead4     := {}
	Local cJson      := ''
	Local cMV_881_07 := 'MV_881_07'
	Local cMV_881_10 := 'MV_881_10'
	Local cPedidoGAR := ''
	Local lMV_881_07 := .F.
	Local lMV_881_10 := .F.
	Local nCnt       := 0
	Local nE         := 0
	Local nI         := 0
	Local nM         := 0
	Local nT         := 0
	Local nL         := 0
	
	cStack += 'pontoCentr()' + CRLF
	
	U_rnConout('Vou iniciar a consulta no get_ChkOut. '+cThread)
	
	If .NOT. GetMv( cMV_881_07, .T. )
		CriarSX6( cMV_881_07, 'L', 'HABILITAR O USO DO NOVO FLUXO DE VENDAS. F=NAO; T=SIM. CSFA881.','.F.' )
	Endif
	
	If .NOT. GetMv( cMV_881_10, .T. )
		CriarSX6( cMV_881_10, 'L', 'HABILITAR O USO DO NOVO SERVICO GAR TRILHA DE AUDITORIA. F=NAO; T=SIM. CSFA881.','.F.' )
	Endif
	
	/*	
	+------------------------------------------------------------+
	| Parâmetro com a siglas que determina se a pesquisar é por: |
	+------+-----------------------------------------------------+
	| cTip | Descricaop                                          |
	+------+-----------------------------------------------------+
	| T    | Titular                                             |
	| F    | Faturamento                                         |
	| S    | Pedido Site                                         |
	| G    | Pedido GAR                                          |
	| E    | Pedido eCommerce                                    |
	+------+-----------------------------------------------------+
	
	+------------------------------------------------------------+
	| Parâmetro com o conteúdo que pode ser:                     |
	+-----------------+------------------------------------------+
	| cDoc            | Descricao                                |
	+-----------------+------------------------------------------+
	| cpf             | 00000000000                              |
	| cnpj            | 00000000000000                           |
	| Pedido site/gar | todos numéricos.                         |
	+-----------------+------------------------------------------+
	
	+------------------------------------------------------------+
	| Parâmetro que determina o tipo de pesquisa requisitada:    |
	+------+-----------------------------------------------------+
	| cOpc | Descricao                                           |
	+------+-----------------------------------------------------+
	| 1    | CPF ou CNPJ                                         |
	| 2    | Pedido Site ou GAR                                  |
	+------+-----------------------------------------------------+
	*/
	
	// HABILITAR O USO DO NOVO FLUXO DE VENDAS. F=NAO; T=SIM.
	lMV_881_07 := GetMv( cMV_881_07, .F. )
	
	// HABILITAR O USO DO NOVO SERVICO GAR TRILHA DE AUDITORIA. F=NAO; T=SIM.
	lMV_881_10 := GetMv( cMV_881_10, .F. )

	If lMV_881_07 
		ChkOutComb( cTip, cDoc, @aERP, @cStack, cOpc, cThread, @aFindDPed )
	Else
		get_ChkOut( cTip, cDoc, @aERP, @cStack, cOpc, cThread, @aFindDPed )
	Endif
	
	U_rnConout('Terminei a consulta no get_ChkOut. '+cThread)
	
	For nI := 1 To Len( aERP )
		If aERP[ nI, 1 ] == '1-Documento nao localizado no ERP-Protheus' .OR. ;
		   aERP[ nI, 1 ] == '2-Documento nao localizado no ERP-Protheus'
			getNotFoun( NIL, @aFindDPed, @aCertif, @aTrilha, @cStack )
		Else
			If lMV_881_07
				aPEDIDO := aERP[ nI, 60 ]
				For nT := 1 To Len( aPEDIDO )
					For nL := 1 To Len( aPEDIDO[ nT, 10 ] )
						cPedidoGAR := aPEDIDO[ nT, 10, nL, 9 ]

						getNewTril( cPedidoGAR, @aTrilha, @cStack, cThread )
						get_Ped( cPedidoGAR, @aFindDPed, @cStack, cThread, (cTip+cOpc), @aTrilha )
						get_Certif( cPedidoGAR, @aCertif, @cStack, cThread )
					Next nL
				Next nT
			Else
				cPedidoGAR := aERP[ nI, 2 ] // pedidoOrigem é pedido GAR quando o codigoOrigem é 1/7/9.

				get_Trilha( cPedidoGAR, @aTrilha, @cStack, cThread )
				get_Ped( cPedidoGAR, @aFindDPed, @cStack, cThread, (cTip+cOpc), @aTrilha )
				get_Certif( cPedidoGAR, @aCertif, @cStack, cThread )
			Endif
		Endif
	Next nI
	
	If lMV_881_07
		AAdd( aHead1, '"msgRetorno":' 		) //01
		AAdd( aHead1, '"pedidoSite":' 		) //02
		AAdd( aHead1, '"pedidoProtheus":' 	) //03
		AAdd( aHead1, '"nomeClienteFat":' 	) //04
		AAdd( aHead1, '"qtdeParcelas":' 	) //05
		AAdd( aHead1, '"emissaoDocFiscal":' ) //06
		AAdd( aHead1, '"condicaoTitulo":' 	) //07
		AAdd( aHead1, '"dataPedido":' 		) //08
		AAdd( aHead1, '"dataEntrega":' 		) //09
		AAdd( aHead1, '"linkBoleto":' 		) //10
		AAdd( aHead1, '"reciboCompra":' 	) //11
		AAdd( aHead1, '"nomeContato":' 		) //12
		AAdd( aHead1, '"cpfContato":' 		) //13
		AAdd( aHead1, '"emailContato":' 	) //14
		AAdd( aHead1, '"foneContato":' 		) //15
		AAdd( aHead1, '"nomeFatura":' 		) //16
		AAdd( aHead1, '"cgcFatura":' 		) //17
		AAdd( aHead1, '"endFatura":' 		) //18
		AAdd( aHead1, '"complFatura":' 		) //19
		AAdd( aHead1, '"cepFatura":' 		) //20
		AAdd( aHead1, '"bairroFatura":' 	) //21
		AAdd( aHead1, '"foneFatura":' 		) //22
		AAdd( aHead1, '"dddFatura":' 		) //23
		AAdd( aHead1, '"cidadeFatura":' 	) //24
		AAdd( aHead1, '"ufFatura":' 		) //25
		AAdd( aHead1, '"emailFatura":' 		) //26
		AAdd( aHead1, '"inscrEstFatura":' 	) //27
		AAdd( aHead1, '"inscrMunFatura":' 	) //28
		AAdd( aHead1, '"suframaFatura":' 	) //29
		AAdd( aHead1, '"formaPagto":' 		) //30
		AAdd( aHead1, '"tipoPessoa":' 		) //31
		AAdd( aHead1, '"statusFaturamento":') //32
		AAdd( aHead1, '"statusPagamento":' 	) //33
		AAdd( aHead1, '"tipoTributacao":' 	) //34
		AAdd( aHead1, '"origemVenda":' 		) //35
		AAdd( aHead1, '"pedidoOrigem":'	 	) //36
		AAdd( aHead1, '"postoNome":' 		) //37
		AAdd( aHead1, '"postoEnd":' 		) //38
		AAdd( aHead1, '"postoCompl":' 		) //39
		AAdd( aHead1, '"postoBairro":' 		) //40
		AAdd( aHead1, '"postoCEP":' 		) //41
		AAdd( aHead1, '"postoFone":' 		) //42
		AAdd( aHead1, '"postoCidade":' 		) //43
		AAdd( aHead1, '"postoUF":' 			) //44
		AAdd( aHead1, '"numEtiquetaPostag":') //45
		AAdd( aHead1, '"nomeServEntrega":' 	) //46
		AAdd( aHead1, '"endEntrega":' 		) //47
		AAdd( aHead1, '"numEntrega":' 		) //48
		AAdd( aHead1, '"complEntrega":' 	) //49
		AAdd( aHead1, '"bairroEntrega":' 	) //50
		AAdd( aHead1, '"cepEntrega":' 		) //51
		AAdd( aHead1, '"cidadeEntrega":' 	) //52
		AAdd( aHead1, '"ufEntrega":' 		) //53
		AAdd( aHead1, '"vlServEntrega":' 	) //54
		AAdd( aHead1, '"linkCorreio":' 		) //55
		AAdd( aHead1, '"nomeAnalista":' 	) //56
		AAdd( aHead1, '"idAnalista":' 		) //57
		AAdd( aHead1, '"valorBruto":' 		) //58
		AAdd( aHead1, '"pedidoEcommerce":' 	) //59
		
		// ItemProduto
		AAdd( aHead11, '"codigoGAR":' 		  ) //01
		AAdd( aHead11, '"grupo":' 			  ) //02
		AAdd( aHead11, '"qtd":' 			  ) //03
		AAdd( aHead11, '"vlUnitario":' 		  ) //04
		AAdd( aHead11, '"vlTotal":' 		  ) //05
		AAdd( aHead11, '"descricaoGAR":' 	  ) //06
		AAdd( aHead11, '"codigoProtheus":' 	  ) //07
		AAdd( aHead11, '"descricaoProtheus":' ) //08
		AAdd( aHead11, '"pedidoGAR":' 		  ) //09
		AAdd( aHead11, '"pedidoOrigem":' 	  ) //10
		AAdd( aHead11, '"plataforma":' 		  ) //11
		AAdd( aHead11, '"idSKU":' 			  ) //12
		AAdd( aHead11, '"idSKUItem":' 		  ) //13

		// Nota fiscal
		AAdd( aHead12, '"tipo":' ) //01
		AAdd( aHead12, '"link":' ) //02

		// SKU
		AAdd( aHead13, '"codigoGAR":'         ) //01
		AAdd( aHead13, '"grupo":' 		      ) //02
		AAdd( aHead13, '"qtd":' 		      ) //03
		AAdd( aHead13, '"vlUnitario":' 	 	  ) //04
		AAdd( aHead13, '"vlTotal":' 	      ) //05
		AAdd( aHead13, '"descricaoGAR":' 	  ) //06
		AAdd( aHead13, '"codigoProtheus":' 	  ) //07
		AAdd( aHead13, '"descricaoProtheus":' ) //08
		AAdd( aHead13, '"idSKU":' 			  ) //09

		// Titularidade
		AAdd( aHead14, '"pedido":' 		 ) //01
		AAdd( aHead14, '"dataregistro":' ) //02
		AAdd( aHead14, '"nome":' 		 ) //03
		AAdd( aHead14, '"documento":' 	 ) //05

		// Agendamento
		AAdd( aHead15, '"pedido":' 			) //01
		AAdd( aHead15, '"nomeponto":' 		) //02
		AAdd( aHead15, '"endereco":' 		) //03
		AAdd( aHead15, '"dataagendamento":' ) //04
		AAdd( aHead15, '"horaagendamento":' ) //05
		AAdd( aHead15, '"dataregistro":' 	) //06
	Else
		AAdd( aHead1, '"msgRetorno":' 			) //01
		AAdd( aHead1, '"pedidoGAR":' 			) //02
		AAdd( aHead1, '"pedidoSite":' 			) //03
		AAdd( aHead1, '"pedidoProtheus":' 		) //04
		AAdd( aHead1, '"nomeClienteFat":' 		) //05
		AAdd( aHead1, '"linkNF":' 				) //06
		AAdd( aHead1, '"nfHardware":' 			) //07
		AAdd( aHead1, '"nfEntregaHardware":' 	) //08
		AAdd( aHead1, '"nfSoftware":' 			) //09
		AAdd( aHead1, '"qtdeParcelas":' 		) //10
		AAdd( aHead1, '"emissaoDocFiscal":' 	) //11
		AAdd( aHead1, '"condicaoTitulo":' 		) //12
		AAdd( aHead1, '"dataPedido":' 			) //13
		AAdd( aHead1, '"dataEntrega":' 			) //14
		AAdd( aHead1, '"linkBoleto":' 			) //15
		AAdd( aHead1, '"reciboCompra":' 		) //16
		AAdd( aHead1, '"nomeContato":' 			) //17
		AAdd( aHead1, '"cpfContato":' 			) //18
		AAdd( aHead1, '"emailContato":' 		) //19
		AAdd( aHead1, '"foneContato":' 			) //20
		AAdd( aHead1, '"nomeFatura":' 			) //21
		AAdd( aHead1, '"cpfFatura":' 			) //22
		AAdd( aHead1, '"endFatura":' 			) //23
		AAdd( aHead1, '"complFatura":' 			) //24
		AAdd( aHead1, '"cepFatura":' 			) //25
		AAdd( aHead1, '"bairroFatura":' 		) //26
		AAdd( aHead1, '"foneFatura":' 			) //27
		AAdd( aHead1, '"dddFatura":' 			) //28
		AAdd( aHead1, '"cidadeFatura":' 		) //29
		AAdd( aHead1, '"ufFatura":' 			) //30
		AAdd( aHead1, '"emailFatura":' 			) //31
		AAdd( aHead1, '"cnpjFatura":' 			) //32
		AAdd( aHead1, '"razaoFatura":' 			) //33
		AAdd( aHead1, '"inscrEstFatura":' 		) //34
		AAdd( aHead1, '"inscrMunFatura":' 		) //35
		AAdd( aHead1, '"suframaFatura":' 		) //36
		AAdd( aHead1, '"formaPagto":' 			) //37
		AAdd( aHead1, '"tipoPessoa":'	 		) //38
		AAdd( aHead1, '"statusFaturamento":' 	) //39
		AAdd( aHead1, '"statusPagamento":' 		) //40
		AAdd( aHead1, '"tipoTributacao":' 		) //41
		AAdd( aHead1, '"origemVenda":' 			) //42
		AAdd( aHead1, '"pedidoOrigem":' 		) //43
		AAdd( aHead1, '"postoNome":' 			) //44
		AAdd( aHead1, '"postoEnd":' 			) //45
		AAdd( aHead1, '"postoCompl":' 			) //46
		AAdd( aHead1, '"postoBairro":' 			) //47
		AAdd( aHead1, '"postoCEP":' 			) //48
		AAdd( aHead1, '"postoFone":' 			) //49
		AAdd( aHead1, '"postoCidade":' 			) //50
		AAdd( aHead1, '"postoUF":' 				) //51
		AAdd( aHead1, '"numEtiquetaPostag":' 	) //52
		AAdd( aHead1, '"nomeServEntrega":' 		) //53
		AAdd( aHead1, '"endEntrega":' 			) //54
		AAdd( aHead1, '"numEntrega":' 			) //55
		AAdd( aHead1, '"complEntrega":' 		) //56
		AAdd( aHead1, '"bairroEntrega":' 		) //57
		AAdd( aHead1, '"cepEntrega":' 			) //58
		AAdd( aHead1, '"cidadeEntrega":' 		) //59
		AAdd( aHead1, '"ufEntrega":' 			) //60
		AAdd( aHead1, '"vlServEntrega":' 		) //61
		AAdd( aHead1, '"linkCorreio":' 			) //62
		AAdd( aHead1, '"nomeAnalista":' 		) //63
		AAdd( aHead1, '"idAnalista":' 			) //64
	
		AAdd( aHead11, '"codigoGAR":' 			) //01
		AAdd( aHead11, '"grupo":' 				) //02
		AAdd( aHead11, '"ar":' 					) //03
		AAdd( aHead11, '"qtd":' 				) //04
		AAdd( aHead11, '"vlUnitario":' 			) //05
		AAdd( aHead11, '"vlTotal":' 			) //06
		AAdd( aHead11, '"descricaoGAR":' 		) //07
		AAdd( aHead11, '"codigoProtheus":' 		) //08
		AAdd( aHead11, '"descricaoProtheus":' 	) //09
	Endif
	
	AAdd( aHead2, '"msgRetorno": ' 				) //01
	AAdd( aHead2, '"arDesc": ' 					) //02
	AAdd( aHead2, '"arId": ' 					) //03
	AAdd( aHead2, '"arValidacao": ' 			) //04
	AAdd( aHead2, '"arValidacaoDesc": ' 		) //05
	AAdd( aHead2, '"cnpjCert": ' 				) //06
	AAdd( aHead2, '"cpfAgenteValidacao": ' 		) //07
	AAdd( aHead2, '"cpfAgenteVerificacao": '	) //08
	AAdd( aHead2, '"cpfTitular": ' 				) //09
	AAdd( aHead2, '"dataEmissao": ' 			) //10
	AAdd( aHead2, '"dataPedido": ' 				) //11
	AAdd( aHead2, '"dataValidacao": ' 			) //12
	AAdd( aHead2, '"dataVerificacao": ' 		) //13
	AAdd( aHead2, '"emailTitular": ' 			) //14
	AAdd( aHead2, '"grupo": ' 					) //15
	AAdd( aHead2, '"grupoDescricao": ' 			) //16
	AAdd( aHead2, '"nomeAgenteValidacao": ' 	) //17
	AAdd( aHead2, '"nomeAgenteVerificacao": ' 	) //18
	AAdd( aHead2, '"nomeTitular": ' 			) //19
	AAdd( aHead2, '"pedido": ' 					) //20
	AAdd( aHead2, '"postoValidacaoDesc": ' 		) //21
	AAdd( aHead2, '"postoValidacaoId": ' 		) //22
	AAdd( aHead2, '"postoVerificacaoDesc": ' 	) //23
	AAdd( aHead2, '"postoVerificacaoId": ' 		) //24
	AAdd( aHead2, '"produto": ' 				) //25
	AAdd( aHead2, '"produtoDesc": ' 			) //26
	AAdd( aHead2, '"razaoSocialCert": ' 		) //27
	AAdd( aHead2, '"rede": ' 					) //28
	AAdd( aHead2, '"status": ' 					) //29
	AAdd( aHead2, '"statusDesc": ' 				) //30
	AAdd( aHead2, '"ufTitular": ' 				) //31
	
	AAdd( aHead3, '"msgRetorno": ' 				) //01
	AAdd( aHead3, '"nome": ' 					) //02
	AAdd( aHead3, '"dataNascimento": ' 			) //03
	AAdd( aHead3, '"email": ' 					) //04
	AAdd( aHead3, '"classe": ' 					) //05
	AAdd( aHead3, '"validoDe": ' 				) //06
	AAdd( aHead3, '"validoAte": ' 				) //07
	AAdd( aHead3, '"serie": ' 					) //08
	AAdd( aHead3, '"emissor": ' 				) //09
	AAdd( aHead3, '"assunto": ' 				) //10
	AAdd( aHead3, '"cpf": ' 					) //11
	AAdd( aHead3, '"rg": ' 						) //12
	AAdd( aHead3, '"pisPasep": ' 				) //13
	AAdd( aHead3, '"orgaoExpedidor": ' 			) //14
	AAdd( aHead3, '"uf": ' 						) //15
	AAdd( aHead3, '"ceiPF": ' 					) //16
	AAdd( aHead3, '"razaoSocial": ' 			) //17
	AAdd( aHead3, '"ceiPJ": ' 					) //18
	AAdd( aHead3, '"cnpj": ' 					) //19
	AAdd( aHead3, '"status": ' 					) //20
	AAdd( aHead3, '"cCrtId": ' 					) //21
	AAdd( aHead3, '"pedido": ' 					) //22
	AAdd( aHead3, '"tituloEleitor": ' 			) //23
	AAdd( aHead3, '"tituloEleitorMunicipio": ' 	) //24
	AAdd( aHead3, '"tituloEleitorSecao": ' 		) //25
	AAdd( aHead3, '"tituloEleitorUf": ' 		) //26
	AAdd( aHead3, '"tituloEleitorZona": ' 		) //27
	
	AAdd( aHead4, '"msgRetorno": ' 		) //01
	AAdd( aHead4, '"pedidoGar": ' 		) //02
	AAdd( aHead4, '"acao": ' 			) //03
	AAdd( aHead4, '"comentario": ' 		) //04
	AAdd( aHead4, '"data": ' 			) //05
	AAdd( aHead4, '"descricaoAcao": ' 	) //06
	AAdd( aHead4, '"nomeUsuario": ' 	) //07
	AAdd( aHead4, '"posto": ' 			) //08
	AAdd( aHead4, '"clienteAcao": ' 	) //09
	AAdd( aHead4, '"cpfUsuario": ' 		) //10
	
	U_rnConout('Vou montar o Json. ' + cThread)
	
	cJson := '['
	
	For nM := 1 To Len( aERP )
		nCnt++
		
		cJson += '{'
		If lMV_881_07
			For nI := 1 To 59
				cJson += aHead1[ nI ] + '"' + aERP[ nM, nI ] + '",'
			Next nI
		else
			For nI := 1 To 64
				cJson += aHead1[ nI ] + '"' + aERP[ nM, nI ] + '",'
			Next nI
		endif
		
		conout( "incluir aSA1: " + cValToChar( len( aSA1 ) ) )
		varinfo( "aSA1", aSA1 )
		if len( aSA1 ) > 0
			cJson += '"ramoAtividade":"'        + aSA1[1] + '",'
			cJson += '"classificacaoCliente":"' + aSA1[2] + '",'
		else
			cJson += '"ramoAtividade":"",'
			cJson += '"classificacaoCliente":"",'
		endif
		
		If lMV_881_07
			cJson += '"SKU":['
			For nI := 1 To Len( aERP[ nM, 60 ] )
				cJson += "{"
				For nE := 1 To Len( aERP[ nM, 60, nI ] ) -1
					cJson += aHead13[ nE ] + '"' + aERP[ nM, 60, nI, nE ] + '",'
				Next nE
				
				//itemProduto
				cJson += '"itemProduto":['
				For nL := 1 To Len( aERP[ nM, 60, nI, 10 ] )
					cJson += "{"
					For nE := 1 To Len( aERP[ nM, 60, nI, 10, nL ] )
						cJson += aHead11[ nE ] + '"' + aERP[ nM, 60, nI, 10, nL, nE ] + '",'
					Next nE
					cJson := SubStr( cJson, 1, Len( cJson )-1 )
					cJson += "},"
				Next nL
				if Len( aERP[ nM, 60, nI, 10 ] ) > 0
					cJson := SubStr( cJson, 1, Len( cJson )-1 )
				endif
				cJson += ']'
				
				cJson += "},"
			Next nI
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
			cJson += '],'					
		EndIF
		
		If lMV_881_07
			//notasFiscais
			cJson += '"notasFiscais":['
			For nI := 1 To Len( aERP[ nM, 61 ] )
				cJson += "{"
				For nE := 1 To Len( aERP[ nM, 61, nI ] )
					cJson += aHead12[ nE ] + '"' + aERP[ nM, 61, nI, nE ] + '",'
				Next nE
				cJson := SubStr( cJson, 1, Len( cJson )-1 )
				cJson += "},"
			Next nI
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
			cJson += '],'

			//Titularidade
			cJson += '"Titularidade":['
			For nI := 1 To Len( aERP[ nM, 62 ] )
				cJson += "{"
				For nE := 1 To Len( aERP[ nM, 62, nI ] )
					cJson += aHead14[ nE ] + '"' + aERP[ nM, 62, nI, nE ] + '",'
				Next nE
				cJson := SubStr( cJson, 1, Len( cJson )-1 )
				cJson += "},"
			Next nI
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
			cJson += '],'

			//Agendamento
			cJson += '"Agendamento":['
			For nI := 1 To Len( aERP[ nM, 63 ] )
				cJson += "{"
				For nE := 1 To Len( aERP[ nM, 63, nI ] )
					cJson += aHead15[ nE ] + '"' + aERP[ nM, 63, nI, nE ] + '",'
				Next nE
				cJson := SubStr( cJson, 1, Len( cJson )-1 )
				cJson += "},"
			Next nI
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
			cJson += '],'
		Else
			For nI := 1 To Len( aERP[ nM, 65 ] )
				cJson += "{"
				For nE := 1 To Len( aERP[ nM, 65, nI ] )
					cJson += aHead11[ nE ] + '"' + aERP[ nM, 65, nI, nE ] + '",'
				Next nE
				cJson := SubStr( cJson, 1, Len( cJson )-1 )
				cJson += "},"
			Next nI
			
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
			cJson += '],'
		Endif
		
		/*		
		cJson += '"findDadosPedido":['
		For nF := 1 To Len( aFindDPed[ nCnt ] )
			cJson += "{"
			For nE := 1 To Len()
			cJson += aHead2[ nF ] + '"' + aFindDPed[ nCnt, nF ] + '",'
		Next nF
		cJson := SubStr( cJson, 1, Len( cJson )-1 )
		cJson += '},'
		*/
		
		//findDadosPedido
		cJson += '"findDadosPedido":['
		For nT := 1 To Len( aFindDPed )
			cJson += "{"
			For nE := 1 To Len( aFindDPed[ nT ] )
				cJson += aHead2[ nE ] + '"' + aFindDPed[ nT, nE ] + '",'
			Next nE
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
			cJson += "},"
		Next nT
		if Len( aFindDPed ) > 0
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
		endif
		cJson += '],'
		
		/*		
		cJson += '"dadosCertificado":{'
		For nC := 1 To Len( aCertif[ nCnt ] )
			cJson += aHead3[ nC ] + '"' + aCertif[ nCnt, nC ] + '",'
		Next nC
		cJson := SubStr( cJson, 1, Len( cJson )-1 )
		cJson += '},'
		*/
				
		//dadosCertificado
		cJson += '"dadosCertificado":['
		For nT := 1 To Len( aCertif )
			cJson += "{"
			For nE := 1 To Len( aCertif[ nT ] )
				cJson += aHead3[ nE ] + '"' + aCertif[ nT, nE ] + '",'
			Next nE
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
			cJson += "},"
		Next nT
		if  Len( aCertif ) > 0
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
		endif
		cJson += '],'

		//Monta trilha
		cJson += '"trilhaDeAuditoria":['
		if nCnt <= len( aTrilha ) 
			For nT := 1 To Len( aTrilha[ nCnt ] )
				cJson += "{"
				For nE := 1 To Len( aTrilha[ nCnt, nE ] )
					cJson += aHead4[ nE ] + '"' + aTrilha[ nCnt, nT, nE ] + '",'
				Next nE
				cJson := SubStr( cJson, 1, Len( cJson )-1 )
				cJson += "},"
			Next nT
			cJson := SubStr( cJson, 1, Len( cJson )-1 )
		endif
		cJson += ']'
		
		cJson += '},'
		
	Next nM
	
	cJson := SubStr( cJson, 1, Len( cJson )-1 )
	cJson += ']'
	
	U_rnConout('Finalizei o procesamento do pontoCentr e montei o Json: ' + CRLF + cJson)
	U_rnConout('Fim do pontoCentr ' + cThread)
Return( cJSon )

/*/{Protheus.doc} get_ChkOut
Monta Json com dados com base no link https://checkout.certisign.com.br/rest/api
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/		
Static Function get_ChkOut( cTpPesq, cPesq, aERP, cStack, cOpc, cThread, aFindDPed )
	Local aHeadStr     := {}
	Local aStatusPagto := {'PENDENTE','PAGO'}
	Local cC5_XNPSITE  := ''
	Local cEndPoint    := ''
	Local cGetResult   := ''
	Local cMV_881_05   := 'MV_881_05'
	Local cParam       := ''
	Local cParam2      := ''
	Local cPage        := '&page=1&per_page='
	Local cPassword    := ''
	Local cStatusPagto := ''
	Local cTpPessoa    := ''
	Local cURL         := ''
	Local cUser        := ''
	Local lDeserialize := .F.
	Local lNickName    := .T.
	Local lFound_SA1   := .F.
	Local lFound_SC5   := .F.
	Local lGet
	Local j            := 0
	Local nElem        := 0
	Local nI           := 0
	Local nJ           := 0
	Local nL           := 0
	Local nQtd         := 0
	Local nQtdLim      := 0
	Local oChkOut
	Local oDados
	Local oWsGAR
	Local oObj1
	
	o881Rest   := NIL
	o881Result := NIL
	
	Private oObj
	Private oPSite
	
	cStack += 'GET_CHKOUT()' + CRLF
	
	/*
	+--------------------------------------------------------------+
	| CONJUNTO DE DADOS PARA ACESSO AO CHECK-OUT                   | 
	+--------------------------------------------------------------+
	| [TESTE]                                                      |
	+-----------+--------------------------------------------------+
	| url...... | https://checkout-teste.certisign.com.br          |
	| endpoint. | /rest/api/pedidos                                |
	| user..... | 9a7d0de2-06be-4339-ae40-ebf83ae88cd9             |
	| password. | PfMlXkE1BK+PZWeRSLxmdw==                         |
	+-----------+--------------------------------------------------+

	+--------------------------------------------------------------+
	| CONJUNTO DE DADOS PARA ACESSO AO CHECK-OUT                   | 
	+--------------------------------------------------------------+
	| [HOMOLOG]                                                    |
	+-----------+--------------------------------------------------+
	| url...... | https://checkout-homolog.certisign.com.br        |
	| endpoint. | /rest/api/pedidos                                |
	| user..... | 0cfda315-4a15-4708-bad1-f87deb24b49b             |
	| password. | xcflRpM5AGmG7GukTYA5OQ==                         |
	+-----------+--------------------------------------------------+

	+--------------------------------------------------------------+
	| CONJUNTO DE DADOS PARA ACESSO AO CHECK-OUT                   | 
	+--------------------------------------------------------------+
	| [PRODUCAO]                                                   |
	+-----------+--------------------------------------------------+
	| url...... | https://checkout.certisign.com.br                |
	| endpoint. | /rest/api/pedidos                                |
	| user..... | 7516d708-b733-4f5a-aae5-fbb2955c0c45             |
	| password. | SOwY3RCA9sOSgtM68MxmQQ==                         |
	+-----------+--------------------------------------------------+
	*/
	
	If .NOT. GetMv( cMV_881_05, .T. )
		CriarSX6( cMV_881_05, 'C', 'QUANTIDADE DE REGISTRO PARA CONSULTA NO CHECK-OUT. CSFA881.',;
		'60' )
	Endif
	cMV_881_05 := GetMv( cMV_881_05, .F. )
	
	cPage := cPage + cMV_881_05
	
	nQtdLim := Val( cMV_881_05 )
	
	If cOpc == '1' // é CPF ou CNPJ
		// É CPF?
		If Len( cPesq ) == 11
			//T=titular; F=faturamento
			If cTpPesq == 'T'
				cParam := '?cpf_titular=' + cPesq + cPage
				cParam2 := '?cpf_contato=' + cPesq + cPage
			Elseif cTpPesq == 'F'
				cParam := '?cpf_faturamento=' + cPesq + cPage
				cParam2 := '?cpf_contato=' + cPesq + cPage
			Endif
			
		// É CNPJ?
		Elseif Len( cPesq ) == 14
			//T=titular; F=faturamento
			If cTpPesq == 'T'
				cParam := '?cnpj_titular=' + cPesq + cPage
			Elseif cTpPesq == 'F'
				cParam := '?cnpj_faturamento=' + cPesq + cPage
			Endif
		Endif
	Else
		If cOpc == '2'
			If cTpPesq == 'S'
				cParam := '/'+cPesq
			Elseif cTpPesq == 'G'
				cParam := '?pedido_gar='+cPesq
			Endif
		Endif
	Endif
	
	oChkOut := checkoutParam():get()
	
	cURL      := oChkOut:url
	cEndPoint := oChkOut:endPoint
	cUser     := oChkOut:userCode
	cPassWord := oChkOut:password
	
	AAdd( aHeadStr, "Content-Type: application/json" )
	AAdd( aHeadStr, "Accept: application/json" )
	AAdd( aHeadStr, "Authorization: Basic " + EnCode64( cUser + ":" + cPassword ) )
	
	U_rnConout('Vou conectar no Check-Out: ' + cURL + cEndPoint + cParam + ' - Thread: ' + cThread )
	
	//+-------------------------------------------------------------------------------------------------------------------------------------+
	//| O processo é fazer a consulta no Check-Out pelas opções:                                                                            |
	//+-------------------------------------------------------------------------------------------------------------------------------------+
	//| a) cpf_titular;                                                                                                                     |
	//| b) cpf_faturamento;                                                                                                                 |
	//| c) cnpj_titular;                                                                                                                    |
	//| d) cnpj_faturamento;                                                                                                                |
	//| e) pedido site.                                                                                                                     |
	//| Quando a opção for cpf_titular ou cnpj_titular é necessário fazer a consulta no serviço do GAR byCPFCNPJ.                           |
	//| Caso a consulta no Check-Out retorne vazia não agregar nada no aERP, ou seja, apenas atribuir dados qdo um dos serviços entregar.   |
	//+-------------------------------------------------------------------------------------------------------------------------------------+
	
	// Host para consumo REST.
	o881Rest := FWRest():New( cURL )
	
	// Primeiro path aonde será feito a requisição
	o881Rest:setPath( cEndPoint + cParam )
	
	// Efetuar o GET para completar a conexão.
	lGet := o881Rest:Get( aHeadStr )
	
	// Conseguiu fazer o GET?
	If lGet
		U_rnConout('Consegui fazer GET no Check-Out. ' + cThread)
		// Retorna o conteudo.
		cGetResult := o881Rest:GetResult()
		
		//+----------------------------------------------------------------------------------------------------------+
		//| Se for cOpc == '2' é pesquisa por pedido site.                                                           |
		//| Neste caso avaliar o cGetResult para saber se o pedido existe.                                           |
		//| Conseguiu serializar? É do tipo do valor é Array? O tamanho é um? O tipo do dado no elemento é numérico? |
		//| O retorno sendo igual a 500 sair fora, pois o pedido não existe.                                         |
		//+----------------------------------------------------------------------------------------------------------+
		If cOpc == '2'
			If FwJsonDeserialize(cGetResult,@oPSite) .AND. ValType(oPSite)=='A' .AND. Len(oPSite)==1 .AND. Type('oPSite[1]:codigo')=='N'
				If oPSite[ 1 ]:codigo == 500
					U_rnConout('_______________CHECK-OUT INFORMA QUE O PEDIDO SITE (' + cParam + ') NAO FOI LOCALIZADO. THREAD ' + cThread + '_______________' )
					U_rnConout('GETRESULT: ' + cGetResult )
					cGetResult := '[ ]'
				Endif
			Endif
		Endif
		
		// O conteúdo é vazio?
		If cGetResult == '[ ]' .OR. cGetResult == '{ }'
			// Tem o segundo parâmetro?
			If cParam2 <> ''
				U_rnConout('Vou reconectar no Check-Out: ' + cURL + cEndPoint + cParam2 + ' - Thread: ' + cThread )
				// Fazer o segundo path para requisição.
				o881Rest:setPath( cEndPoint + cParam2 )
				// Efetuar o GET para completar a conexão.
				lGet := o881Rest:Get( aHeadStr )
				// Conseguiu fazer o GET.
				If lGet
					// Retorna o conteudo válido.
					cGetResult := o881Rest:GetResult()
				Endif
			Endif
		Endif
	Endif
	
	// Se conseguiu fazer o GET e houve retorno de dados.
	If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }'
		// Deserializar o retorno em objeto.
		lDeserialize := FWJsonDeserialize( cGetResult, @o881Result )
	Endif
	
	// Se conseguiu fazer o GET e houve retorno de dados e conseguiu deserealizar.
	If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }' .AND. lDeserialize
		U_rnConout('Consegui fazer o GetResult e Deserializei o retorno do Check-Out. ' + cThread )
		
		// Atribuir os dados ao aERP.
		If ValType( o881Result ) == 'A'
			oObj := AClone( o881Result )
		Else
			oObj := {}
			AAdd( oObj, o881Result )
		Endif
		
		If Select( 'SA1' ) == 0
			ChkFile( 'SA1', .F. )
		Endif
		
		If Select( 'SC5' ) == 0
			ChkFile( 'SC5', .F. )
		Endif
		
		lNickName := FindNickName( 'SC5', 'PEDSITE' )
		
		For nI := 1 To Len( oObj )
			AAdd( aERP, '' )
			nElem := Len( aERP )
			aERP[ nElem ] := {}
			aERP[ nElem ] := Array( 65 )
			aFill( aERP[ nElem ], '' )
			
			// --> oObj[nI]:numero É O NÚMERO DO PEDIDO SITE.
			cC5_XNPSITE := AllTrim( Iif( Type( "oObj["+Str(nI)+"]:numero" )=="U", "", cValToChar( oObj[nI]:numero ) ) )
			
			If cC5_XNPSITE <> ''
				dbSelectArea( 'SC5' )
				If lNickName
					SC5->( dbOrderNickName( 'PEDSITE' ) )
					lFound_SC5 := SC5->( dbSeek( xFilial( 'SC5' ) + cC5_XNPSITE ) )
					
					If lFound_SC5
						dbSelectArea( 'SA1' )
						SA1->( dbSetOrder( 1 ) )
						lFound_SA1 := SA1->( dbSeek( xFilial( 'SA1' ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
						retSA1()
					Endif
				Endif
			Else
				lFound_SC5 := .F.
				lFound_SA1 := .F.
			Endif
			
			cStatusPagto := Iif(Type("oObj["+Str(nI)+"]:statusPagamento")=="U","",cValToChar(oObj[nI]:statusPagamento))
			
			If cStatusPagto $ '12'
				cStatusPagto := aStatusPagto[ Val( cStatusPagto ) ]
			Else
				cStatusPagto := ''
			Endif
			
			aERP[ nElem, 1 ] := 'Documento encontrado no ERP-Protheus'
			aERP[ nElem, 2 ] := Iif(Type("oObj["+Str(nI)+"]:pedidoOrigem")=="U","",cValToChar(oObj[nI]:pedidoOrigem))
			aERP[ nElem, 3 ] := Iif(Type("oObj["+Str(nI)+"]:numero")=="U","",cValToChar(oObj[nI]:numero))
			aERP[ nElem, 4 ] := Iif( lFound_SC5 .AND. lFound_SA1, SC5->C5_NUM, '' )
			aERP[ nElem, 5 ] := Iif( lFound_SC5 .AND. lFound_SA1, U_RnNoAcen( RTrim( SA1->A1_NOME ) ), '' )
			aERP[ nElem, 6 ] := Iif(Type("oObj["+Str(nI)+"]:linkNotaServico")=="U","",cValToChar(oObj[nI]:linkNotaServico))
			aERP[ nElem, 7 ] := Iif(Type("oObj["+Str(nI)+"]:linkNotaProduto")=="U","",cValToChar(oObj[nI]:linkNotaProduto))
			aERP[ nElem, 8 ] := Iif(Type("oObj["+Str(nI)+"]:linkNotaEntrega")=="U","",cValToChar(oObj[nI]:linkNotaEntrega))
			aERP[ nElem, 9 ] := Iif( lFound_SC5 .AND. lFound_SA1, RTrim( SC5->C5_XNFSFW ), '' )
			aERP[ nElem, 10] := Iif( lFound_SC5 .AND. lFound_SA1, RTrim( SC5->C5_XNPARCE ), '' )
			aERP[ nElem, 11] := Iif(Type("oObj["+Str(nI)+"]:dataFaturamento")=="U","",cValToChar(oObj[nI]:dataFaturamento))
			aERP[ nElem, 12] := cStatusPagto
			aERP[ nElem, 13] := Iif(Type("oObj["+Str(nI)+"]:data")=="U","",cValToChar(oObj[nI]:data))
			aERP[ nElem, 14] := Iif(Type("oObj["+Str(nI)+"]:dataEntrega")=="U","",cValToChar(oObj[nI]:dataEntrega))
			aERP[ nElem, 15] := Iif(Type("oObj["+Str(nI)+"]:pagamento:boleto:url")=="U","",cValToChar(oObj[nI]:pagamento:boleto:url))
			aERP[ nElem, 16] := Iif(Type("oObj["+Str(nI)+"]:linkRecibo")=="U","",cValToChar(oObj[nI]:linkRecibo))
			aERP[ nElem, 17] := Iif(Type("oObj["+Str(nI)+"]:contato:nome")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:contato:nome)))
			aERP[ nElem, 18] := Iif(Type("oObj["+Str(nI)+"]:contato:cpf")=="U","",cValToChar(oObj[nI]:contato:cpf))
			aERP[ nElem, 19] := Iif(Type("oObj["+Str(nI)+"]:contato:email")=="U","",cValToChar(oObj[nI]:contato:email))
			aERP[ nElem, 20] := Iif(Type("oObj["+Str(nI)+"]:contato:fone")=="U","",cValToChar(oObj[nI]:contato:fone))
			
			If cTpPessoa == 'F'
				aERP[ nElem, 21] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:nome")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPF:nome)))
				aERP[ nElem, 22] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:cpf")=="U","",cValToChar(oObj[nI]:faturamentoPF:cpf))
				aERP[ nElem, 23] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:logradouro")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPF:endereco:logradouro)) +' '+ Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:numero")=="U","",cValToChar(oObj[nI]:faturamentoPF:endereco:numero)))
				aERP[ nElem, 24] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:complemento")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPF:endereco:complemento)))
				aERP[ nElem, 25] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:cep")=="U","",cValToChar(oObj[nI]:faturamentoPF:endereco:cep))
				aERP[ nElem, 26] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:bairro")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPF:endereco:bairro)))
				aERP[ nElem, 27] := '' // DDD não há no check-out.
				aERP[ nElem, 28] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:fone")=="U","",cValToChar(oObj[nI]:faturamentoPF:endereco:fone))
				aERP[ nElem, 29] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:cidade")=="U","",cValToChar(oObj[nI]:faturamentoPF:endereco:cidade))
				aERP[ nElem, 30] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:endereco:estado")=="U","",cValToChar(oObj[nI]:faturamentoPF:endereco:estado))
				aERP[ nElem, 31] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPF:email")=="U","",cValToChar(oObj[nI]:faturamentoPF:email))
			Else
				aERP[ nElem, 21] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:razaoSocial")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPJ:razaoSocial)))
				aERP[ nElem, 22] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:cnpj")=="U","",cValToChar(oObj[nI]:faturamentoPJ:cnpj))
				aERP[ nElem, 23] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:logradouro")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPJ:endereco:logradouro)) +' '+ Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:numero")=="U","",cValToChar(oObj[nI]:faturamentoPJ:endereco:numero)))
				aERP[ nElem, 24] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:complemento")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPJ:endereco:complemento)))
				aERP[ nElem, 25] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:cep")=="U","",cValToChar(oObj[nI]:faturamentoPJ:endereco:cep))
				aERP[ nElem, 26] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:bairro")=="U","",cValToChar(oObj[nI]:faturamentoPJ:endereco:bairro))
				aERP[ nElem, 27] := '' // DDD não tem no check-out.
				aERP[ nElem, 28] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:fone")=="U","",cValToChar(oObj[nI]:faturamentoPJ:endereco:fone))
				aERP[ nElem, 29] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:cidade")=="U","",cValToChar(oObj[nI]:faturamentoPJ:endereco:cidade))
				aERP[ nElem, 30] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:endereco:estado")=="U","",cValToChar(oObj[nI]:faturamentoPJ:endereco:estado))
				aERP[ nElem, 31] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:email")=="U","",cValToChar(oObj[nI]:faturamentoPJ:email))
			Endif
			
			aERP[ nElem, 32] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:cnpj")=="U","",cValToChar(oObj[nI]:faturamentoPJ:cnpj))
			aERP[ nElem, 33] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:razaoSocial")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:faturamentoPJ:razaoSocial)))
			aERP[ nElem, 34] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:inscricaoEstadual")=="U","",cValToChar(oObj[nI]:faturamentoPJ:inscricaoEstadual))
			aERP[ nElem, 35] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:inscricaoMunicipal")=="U","",cValToChar(oObj[nI]:faturamentoPJ:inscricaoMunicipal))
			aERP[ nElem, 36] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:suframa")=="U","",cValToChar(oObj[nI]:faturamentoPJ:suframa))
			aERP[ nElem, 37] := Iif(Type("oObj["+Str(nI)+"]:pagamento:formaPagamento")=="U","",cValToChar(oObj[nI]:pagamento:formaPagamento))
			aERP[ nElem, 38] := cTpPessoa
			aERP[ nElem, 39] := Iif(Type("oObj["+Str(nI)+"]:statusFaturamento")=="U","",cValToChar(oObj[nI]:statusFaturamento))
			aERP[ nElem, 40] := Iif(Type("oObj["+Str(nI)+"]:statusPagamento")=="U","",cValToChar(oObj[nI]:statusPagamento))
			aERP[ nElem, 41] := Iif(Type("oObj["+Str(nI)+"]:faturamentoPJ:tipoTributacao")=="U","",cValToChar(oObj[nI]:faturamentoPJ:tipoTributacao))
			aERP[ nElem, 42] := Iif(Type("oObj["+Str(nI)+"]:codigoOrigem")=="U","",cValToChar(oObj[nI]:codigoOrigem))
			aERP[ nElem, 43] := Iif(Type("oObj["+Str(nI)+"]:pedidoOrigem")=="U","",cValToChar(oObj[nI]:pedidoOrigem))
			aERP[ nElem, 44] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:nome")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:postoRetirada:nome)))
			aERP[ nElem, 45] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:logradouro")=="U","",cValToChar(oObj[nI]:postoRetirada:endereco:logradouro)) + ' ' + Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:numero")=="U","",cValToChar(oObj[nI]:postoRetirada:endereco:numero))
			aERP[ nElem, 46] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:complemento")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:postoRetirada:endereco:complemento)))
			aERP[ nElem, 47] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:bairro")=="U","",cValToChar(oObj[nI]:postoRetirada:endereco:bairro))
			aERP[ nElem, 48] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:cep")=="U","",cValToChar(oObj[nI]:postoRetirada:endereco:cep))
			aERP[ nElem, 49] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:fone")=="U","",cValToChar(oObj[nI]:postoRetirada:endereco:fone))
			aERP[ nElem, 50] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:cidade")=="U","",cValToChar(oObj[nI]:postoRetirada:endereco:cidade))
			aERP[ nElem, 51] := Iif(Type("oObj["+Str(nI)+"]:postoRetirada:endereco:estado")=="U","",cValToChar(oObj[nI]:postoRetirada:endereco:estado))
			aERP[ nElem, 52] := Iif(Type("oObj["+Str(nI)+"]:entrega:codigoRastreamento")=="U","",cValToChar(oObj[nI]:entrega:codigoRastreamento))
			aERP[ nElem, 53] := Iif(Type("oObj["+Str(nI)+"]:entrega:nomeServico")=="U","",cValToChar(oObj[nI]:entrega:nomeServico))
			aERP[ nElem, 54] := Iif(Type("oObj["+Str(nI)+"]:entrega:endereco:logradouro")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:entrega:endereco:logradouro)))
			aERP[ nElem, 55] := Iif(Type("oObj["+Str(nI)+"]:entrega:endereco:numero")=="U","",cValToChar(oObj[nI]:entrega:endereco:numero))
			aERP[ nElem, 56] := Iif(Type("oObj["+Str(nI)+"]:entrega:endereco:complemento")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:entrega:endereco:complemento)))
			aERP[ nElem, 57] := Iif(Type("oObj["+Str(nI)+"]:entrega:endereco:bairro")=="U","",cValToChar(oObj[nI]:entrega:endereco:bairro))
			aERP[ nElem, 58] := Iif(Type("oObj["+Str(nI)+"]:entrega:endereco:cep")=="U","",cValToChar(oObj[nI]:entrega:endereco:cep))
			aERP[ nElem, 59] := Iif(Type("oObj["+Str(nI)+"]:entrega:endereco:cidade")=="U","",cValToChar(oObj[nI]:entrega:endereco:cidade))
			aERP[ nElem, 60] := Iif(Type("oObj["+Str(nI)+"]:entrega:endereco:estado")=="U","",cValToChar(oObj[nI]:entrega:endereco:estado))
			aERP[ nElem, 61] := Iif(Type("oObj["+Str(nI)+"]:entrega:valorServico")=="U","",cValToChar(oObj[nI]:entrega:valorServico))
			aERP[ nElem, 62] := Iif(Type("oObj["+Str(nI)+"]:entrega:linkRastreamento")=="U","",cValToChar(oObj[nI]:entrega:linkRastreamento))
			aERP[ nElem, 63] := Iif(Type("oObj["+Str(nI)+"]:sac:nomeAnalista")=="U","",U_RnNoAcen(cValToChar(oObj[nI]:sac:nomeAnalista)))
			aERP[ nElem, 64] := Iif(Type("oObj["+Str(nI)+"]:sac:codigoAnalista")=="U","",cValToChar(oObj[nI]:sac:codigoAnalista))
			
			For nJ := 1 To Len( oObj[nI]:itens )
				aERP[ nElem, 65 ] := {}
				AAdd( aERP[ nElem, 65 ], ' ' )
				j := Len( aERP[ nElem, 65 ] )
				aERP[ nElem, 65, j ] := {}
				aERP[ nElem, 65, j ] := Array( 9 )
				
				aERP[ nElem, 65, j, 1 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:codigo")=="U","",cValToChar(oObj[nI]:itens[nJ]:codigo))
				aERP[ nElem, 65, j, 2 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:grupo")=="U","",cValToChar(oObj[nI]:itens[nJ]:grupo))
				aERP[ nElem, 65, j, 3 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:ar")=="U","",cValToChar(oObj[nI]:itens[nJ]:ar))
				aERP[ nElem, 65, j, 4 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:quantidade")=="U","",cValToChar(oObj[nI]:itens[nJ]:quantidade))
				aERP[ nElem, 65, j, 5 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:valorUnitario")=="U","",cValToChar(oObj[nI]:itens[nJ]:valorUnitario))
				aERP[ nElem, 65, j, 6 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:valorTotal")=="U","",cValToChar(oObj[nI]:itens[nJ]:valorTotal))
				aERP[ nElem, 65, j, 7 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:descricao")=="U","",cValToChar(oObj[nI]:itens[nJ]:descricao))
				aERP[ nElem, 65, j, 8 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:codigoProtheus")=="U","",cValToChar(oObj[nI]:itens[nJ]:codigoProtheus))
				aERP[ nElem, 65, j, 9 ] := Iif(Type("oObj["+Str(nI)+"]:itens["+Str(nJ)+"]:descricaoProtheus")=="U","",cValToChar(oObj[nI]:itens[nJ]:descricaoProtheus))
			Next nJ
		Next nI
	Else
		U_rnConout('Nome Servico' + GetSrvProfString( 'NAME', 'NAO ENCONTRADO' ) )
		If .NOT. lGet
			U_rnConout('_______________NAO CONSEGUI FAZER O GET NO CHECK-OUT ' + cThread + '_______________')
			U_rnConout('GETLASTERRO: ' + o881Rest:GetLastError() )
		Endif
		If cGetResult == '[ ]'
			U_rnConout('_______________NAO CONSEGUI OBTER O GETRESULT NO CHECK-OUT ' + cThread + '_______________')
			U_rnConout('GETLASTERRO: ' + o881Rest:GetLastError() )
		Endif
		If .NOT. lDeserialize
			U_rnConout('_______________NA THREAD ' + cThread + ' HOUVE ERRO NA SINTAXE JSON ENTREGUE PELO CHECK-OUT_______________' )
			U_rnConout('GETRESULT: ' + cGetResult )
		Endif
		cGetResult := "Erro de comunicação com o checkout, tente novamente."
	Endif
	
	//+-------------------------------------------------------------------------+
	//| Após fazer a pesquisa no Check-Out verificar se é CPF/CNPJ títular      | 
	//| Sendo assim buscar o número dos pedidos no GAR pelo serviço byCPFCNPJ.  |
	//+-------------------------------------------------------------------------+
	If (cTpPesq=='T') 
		oWsGAR := WSIntegracaoGARERPImplService():New()
		oWsGAR:findPedidosByCPFCNPJ( eVal({|| oObj1:=loginUserPassword():get('USERERPGAR'), oObj1:cReturn }),;
									 eVal({|| oObj1:=loginUserPassword():get('PASSERPGAR'), oObj1:cReturn }),;
									 Val( cPesq ) )
		oDados := oWsGAR:oWsIdPedido
		If oDados <> NIL
			For nL := Len( oDados ) To 1 STEP -1
				If oDados[ nL ]:TEXT <> NIL
					If .NOT. Empty( oDados[ nL ]:TEXT )
						// Verificar se está dentro do limite de pedidos.
						If (++nQtd > nQtdLim)
							U_rnConout('SAIR DO FOR/NEXT FINDPEDIDOSBYCPFCNPJ, EXCEDEU LIMITE: nQtd ' + LTrim( Str( nQtd ) ) + ' ' + LTrim( Str( nQtdLim ) ) + '. ' + cThread)
							Exit
						Endif
						
						// Procurar o pedido GAR em questão no array aERP, se não existir agregar ele.
						If AScan( aERP, {|e| e[ 2 ] == oDados[ nL ]:TEXT } ) == 0
							AAdd( aERP, '' )
							nElem := Len( aERP )
							aERP[ nElem ] := {}
							aERP[ nElem ] := Array( 65 )
							aFill( aERP[ nElem ], '' )
							
							aERP[ nElem, 1 ] := 'Documento encontrado no ERP-Protheus'
							aERP[ nElem, 2 ] := oDados[ nL ]:TEXT
							aERP[ nElem, 65 ] := {}
							
							AAdd( aERP[ nElem, 65 ], ' ' )
							j := Len( aERP[ nElem, 65 ] )
							aERP[ nElem, 65, j ] := {}
							aERP[ nElem, 65, j ] := Array( 9 )
							aFill( aERP[ nElem, 65, j ], '' )
						Endif
					Else
						U_rnConout('NAO LOCALIZEI DADOS NO FINDPEDIDOSBYCPFCNPJ.' + cThread )
						U_rnConout(VarInfo( 'oDados', oDados, ,.F., .F. ))
					Endif
				Else
					U_rnConout('ESTOU DENTRO DO FOR/NEXT FINDPEDIDOSBYCPFCNPJ, POREM NAO CONSEGUI INDETIFICAR O DADO.' + cThread)
					U_rnConout(VarInfo( 'oDados', oDados, ,.F., .F. ))
				Endif
			Next nL
		Else
			U_rnConout('__________________________________________________________________________')
			U_rnConout('_______________NAO CONSEGUI CONSULTAR O findPedidoByCPFCNPJ_______________')
			U_rnConout('__________________________________________________________________________')
			U_rnConout(GetSrvProfString( 'NAME', 'NAO ENCONTRADO' ) )
			If lVarInfo
				U_rnConout(VarInfo( 'WSIntegracaoGARERPImplService', oWsGAR, ,.F., .F. ))
				U_rnConout((VarInfo( 'findPedidosByCPFCNPJ - numero do CPF/CNPJ: ' + cPesq, oDados, ,.F., .F. )))
			Endif
			U_rnConout('__________________________________________________________________________')
		Endif
	Else
		U_rnConout('Nao entrei no findPedidosByCPFCNPJ o tipo é: ' + cTpPesq + '. ' + cThread)
	Endif
	
	//+----------------------------------------------------------------------+
	//| a consulta solicitada é pedido gar (cOpc=='2' .AND. cTpPesq=='G')?   |
	//| não foi possível localizar dados no check-out (Len(aERP)==0)?        |
	//| se ambas perguntas foram respondidas positivamente,                  |
	//| fazer a consulta no GAR.                                             |
	//+----------------------------------------------------------------------+
	If cOpc == '2' .AND. cTpPesq == 'G' .AND. Len( aERP ) == 0
		get_Ped( cPesq, @aFindDPed, @cStack, cThread, (cTpPesq+cOpc) )
		
		If Len( aFindDPed ) > 0
			AAdd( aERP, '' )
			nElem := Len( aERP )
			aERP[ nElem ] := {}
			aERP[ nElem ] := Array( 65 )
			aFill( aERP[ nElem ], '' )
			aERP[ nElem, 1 ] := 'Documento encontrado no ERP-Protheus'
			aERP[ nElem, 2 ] := cPesq
			
			aERP[ nElem, 65 ] := {}
			AAdd( aERP[ nElem, 65 ], ' ' )
			j := Len( aERP[ nElem, 65 ] )
			aERP[ nElem, 65, j ] := {}
			aERP[ nElem, 65, j ] := Array( 9 )
			aFill( aERP[ nElem, 65, j ], '' )
		Endif
	Endif
	
	//+----------------------------------------------------------------------------------+
	//| Acima deste ponto há diversas variáveis que tratam a possibilidade,              |
	//| são elas lGet, cGetResult e lDeserialize, no entanto qualquer uma dessas         |
	//| podem ajudar a determinar se a array aERP está preenchida ou vazia. Bem, ela     |
	//| estando vazia é o suficiaente para determinar que não há dados para entregar,    |
	//| mesmo sim é preciso preenche-la como array.                                      |
	//+----------------------------------------------------------------------------------+
	If Len( aERP ) == 0
		AAdd( aERP, '' )
		nElem := Len( aERP )
		aERP[ nElem ] := {}
		aERP[ nElem ] := Array( 65 )
		aFill( aERP[ nElem ], '' )
		aERP[ nElem, 1 ] := '1-Documento nao localizado no ERP-Protheus'
		
		aERP[ nElem, 65 ] := {}
		
		AAdd( aERP[ nElem, 65 ], ' ' )
		j := Len( aERP[ nElem, 65 ] )
		aERP[ nElem, 65, j ] := {}
		aERP[ nElem, 65, j ] := Array( 9 )
		aFill( aERP[ nElem, 65, j ], '' )
	Endif
	
	o881Rest   := NIL
	o881Result := NIL
Return

/*/{Protheus.doc} ChkOutComb
Monta Json com dados com base no link https://checkout.certisign.com.br/rest/api
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/		
Static Function ChkOutComb( cTpPesq, cPesq, aERP, cStack, cOpc, cThread, aFindDPed )
	Local aHeadStr      := {}
	Local aPedGAR       := {}
	Local aStatusPagto  := {'PENDENTE','PAGO'}
	Local cC5_XNPSITE   := ''
	Local cEndPoint     := ''
	Local cGetResult    := ''
	Local cMV_881_05    := 'MV_881_05'
	Local cParam        := ''
	Local cParam2       := ''
	Local cPage         := '&page=1&per_page='
	Local cPassword     := ''
	Local cStatusPagto  := ''
	Local cTpPessoa     := ''
	Local cURL          := ''
	Local cUser         := ''
	Local lDeserialize 	:= .F.
	Local lNickName 	:= .T.
	Local lFound_SA1 	:= .F.
	Local lFound_SC5 	:= .F.
	Local lGet
	Local i             := 0
	Local j             := 0
	Local k             := 0
	Local l             := 0
	Local m             := 0
	Local nElem         := 0
	Local nSKU	        := 0
	Local nL            := 0
	Local nQtd          := 0
	Local nQtdLim       := 0
	Local nQtdNF        := 0
	Local nPos	        := 0
	Local oChkOut
	Local oDados
	Local oWsGAR
	Local oObj1
	Local aSKU	        := {}
	//--Variaveis SalesForce
	Local aTitular	    := {}
	Local aAgendam	    := {}
	Local nTit		    := 0
	Local nAgend	    := 0
	//Local lIdItempai    := .F.

	o881Rest   := NIL
	o881Result := NIL
	
	Private oObj
	Private oPSite
	Private aItem := {}
	
	cStack += 'GET_CHKOUT()' + CRLF
	
	/*
	+--------------------------------------------------------------+
	| CONJUNTO DE DADOS PARA ACESSO AO CHECK-OUT                   |
	+--------------------------------------------------------------+
	| [TESTE]                                                      |
	+--------------------------------------------------------------+
	| url...... = https://checkout-teste.certisign.com.br          |
	| endpoint. = /rest/api/pedidos                                |
	| user..... = 9a7d0de2-06be-4339-ae40-ebf83ae88cd9             |
	| password. = PfMlXkE1BK+PZWeRSLxmdw==                         |
	+--------------------------------------------------------------+

	+--------------------------------------------------------------+
	| CONJUNTO DE DADOS PARA ACESSO AO CHECK-OUT                   |
	+--------------------------------------------------------------+
	| [HOMOLOG]                                                    |
	+--------------------------------------------------------------+
	| url...... = https://checkout-homolog.certisign.com.br        |
	| endpoint. = /rest/api/pedidos                                |
	| user..... = 0cfda315-4a15-4708-bad1-f87deb24b49b             |
	| password. = xcflRpM5AGmG7GukTYA5OQ==                         |
	+--------------------------------------------------------------+

	+--------------------------------------------------------------+
	| CONJUNTO DE DADOS PARA ACESSO AO CHECK-OUT                   |
	+--------------------------------------------------------------+
	| [PRODUCAO]                                                   |
	+--------------------------------------------------------------+
	| url...... = https://checkout.certisign.com.br                |
	| endpoint. = /rest/api/pedidos                                |
	| user..... = 7516d708-b733-4f5a-aae5-fbb2955c0c45             |
	| password. = SOwY3RCA9sOSgtM68MxmQQ==                         |
	+--------------------------------------------------------------+
	*/
	
	If .NOT. GetMv( cMV_881_05, .T. )
		CriarSX6( cMV_881_05, 'C', 'QUANTIDADE DE REGISTRO PARA CONSULTA NO CHECK-OUT. CSFA881.',;
		'60' )
	Endif
	cMV_881_05 := GetMv( cMV_881_05, .F. )
	
	cPage := cPage + cMV_881_05
	
	nQtdLim := Val( cMV_881_05 )
	
	If cOpc == '1' // é CPF ou CNPJ
		// É CPF?
		If Len( cPesq ) == 11
			//T=titular; F=faturamento
			If cTpPesq == 'T'
				cParam := '?cpf_titular=' + cPesq + cPage
				cParam2 := '?cpf_contato=' + cPesq + cPage
			Elseif cTpPesq == 'F'
				cParam := '?cpf_faturamento=' + cPesq + cPage
				cParam2 := '?cpf_contato=' + cPesq + cPage
			Endif
			
		// É CNPJ?
		Elseif Len( cPesq ) == 14
			//T=titular; F=faturamento
			If cTpPesq == 'T'
				cParam := '?cnpj_titular=' + cPesq + cPage
			Elseif cTpPesq == 'F'
				cParam := '?cnpj_faturamento=' + cPesq + cPage
			Endif
		Endif
	Else
		If cOpc == '2'
			If cTpPesq == 'S'
				cParam := '/'+cPesq
			Elseif cTpPesq == 'G'
				cParam := '?pedido_gar='+cPesq
			Elseif cTpPesq == 'E'
				cParam := '?pedido_ecommerce='+cPesq
			Endif
		Endif
	Endif
	
	oChkOut := checkoutParam():get()
	
	cURL      := oChkOut:url
	cEndPoint := oChkOut:endPoint
	cUser     := oChkOut:userCode
	cPassWord := oChkOut:password
	
	If lTeste// .OR. cTpPesq == 'E'
		cURL := 'https://checkout-teste.certisign.com.br'
		cUser := '9a7d0de2-06be-4339-ae40-ebf83ae88cd9'
		cPassword := 'PfMlXkE1BK+PZWeRSLxmdw=='
	Endif
	
	AAdd( aHeadStr, "Content-Type: application/json" )
	AAdd( aHeadStr, "Accept: application/json" )
	AAdd( aHeadStr, "Authorization: Basic " + EnCode64( cUser + ":" + cPassword ) )
	
	U_rnConout('Vou conectar no Check-Out: ' + cURL + cEndPoint + cParam + ' - Thread: ' + cThread )
	
	//+--------------------------------------------------------------------------------------------------------------------------------------+
	//| O processo é fazer a consulta no Check-Out pelas opções:                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------+
	//| a) cpf_titular;                                                                                                                      | 
	//| b) cpf_faturamento;                                                                                                                  |
	//| c) cnpj_titular;                                                                                                                     |
	//| d) cnpj_faturamento;                                                                                                                 |
	//| e) pedido site.                                                                                                                      |
	//| Quando a opção for cpf_titular ou cnpj_titular é necessário fazer a consulta no serviço do GAR byCPFCNPJ.                            |
	//| Caso a consulta no Check-Out retorne vazia não agregar nada no aERP, ou seja, apenas atribuir dados qdo um dos serviços entregar.    |
	//+--------------------------------------------------------------------------------------------------------------------------------------+
	
	// Host para consumo REST.
	o881Rest := FWRest():New( cURL )
	
	// Primeiro path aonde será feito a requisição
	o881Rest:setPath( cEndPoint + cParam )
	
	// Efetuar o GET para completar a conexão.
	lGet := o881Rest:Get( aHeadStr )
	
	// Conseguiu fazer o GET?
	If lGet
		U_rnConout('Consegui fazer GET no Check-Out. ' + cThread)
		// Retorna o conteudo.
		cGetResult := o881Rest:GetResult()
		
		//+-----------------------------------------------------------------------------------------------------------+
		//| Se for cOpc == '2' é pesquisa por pedido site.                                                            |
		//| Neste caso avaliar o cGetResult para saber se o pedido existe.                                            |
		//| Conseguiu serializar? É do tipo do valor é Array? O tamanho é um? O tipo do dado no elemento é numérico?  |
		//| O retorno sendo igual a 500 sair fora, pois o pedido não existe.                                          |
		//+-----------------------------------------------------------------------------------------------------------+
		If cOpc == '2'
			If FwJsonDeserialize(cGetResult,@oPSite) .AND. ValType(oPSite)=='A' .AND. Len(oPSite)==1 .AND. Type('oPSite[1]:codigo')=='N'
				If oPSite[ 1 ]:codigo == 500
					U_rnConout('_______________CHECK-OUT INFORMA QUE O PEDIDO SITE (' + cParam + ') NAO FOI LOCALIZADO. THREAD ' + cThread + '_______________' )
					U_rnConout('GETRESULT: ' + cGetResult )
					cGetResult := '[ ]'
				Endif
			Endif
		Endif
		
		// O conteúdo é vazio?
		If cGetResult == '[ ]' .OR. cGetResult == '{ }'
			// Tem o segundo parâmetro?
			If cParam2 <> ''
				U_rnConout('Vou reconectar no Check-Out: ' + cURL + cEndPoint + cParam2 + ' - Thread: ' + cThread )
				// Fazer o segundo path para requisição.
				o881Rest:setPath( cEndPoint + cParam2 )
				// Efetuar o GET para completar a conexão.
				lGet := o881Rest:Get( aHeadStr )
				// Conseguiu fazer o GET.
				If lGet
					// Retorna o conteudo válido.
					cGetResult := o881Rest:GetResult()
				Endif
			Endif
		Endif
	Endif
	
	U_rnConout( cEndPoint + cParam )
	
	// Se conseguiu fazer o GET e houve retorno de dados.
	If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }'
		// Deserializar o retorno em objeto.
		lDeserialize := FWJsonDeserialize( cGetResult, @o881Result )
	Endif
	
	// Se conseguiu fazer o GET e houve retorno de dados e conseguiu deserealizar.
	If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }' .AND. lDeserialize
		U_rnConout('Consegui fazer o GetResult e Deserializei o retorno do Check-Out. ' + cThread )
		
		// Atribuir os dados ao aERP.
		If ValType( o881Result ) == 'A'
			oObj := AClone( o881Result )
		Else
			oObj := {}
			AAdd( oObj, o881Result )
		Endif
		
		If Select( 'SA1' ) == 0
			ChkFile( 'SA1', .F. )
		Endif
		
		If Select( 'SC5' ) == 0
			ChkFile( 'SC5', .F. )
		Endif
		
		lNickName := FindNickName( 'SC5', 'PEDSITE' )
		
		// Laço para ler todo o objeto.
		/*
		For i := 1 To Len( oObj )

			//Nesta etapa, preciso identificar qual elemento é o SKU(Combo), 
			//desta maneira, não demonstro como item no Json
			aSKU  := {}
			aItem := {}
			aItem := aClone( oObj[i]:itens )
			For j := 1 To Len( aItem )
				IF Type("aItem["+Str(j)+"]:id") <> "U" .And. Type("aItem["+Str(j)+"]:iditempai") == "U" .And. Len( aItem ) > 1
					AAdd( aSKU, '' )
					nSKU := Len( aSKU )
					aSKU[ nSKU ] := {}
					aSKU[ nSKU ] := Array( 09 )
					
					aSKU[ nSKU , 1 ] := Iif( Type("aItem["+Str(j)+"]:codigo")=="U"				, "", U_RnNoAcen( cValToChar( aItem[j]:codigo				) ) )
					aSKU[ nSKU , 2 ] := Iif( Type("aItem["+Str(j)+"]:grupo")=="U"				, "", U_RnNoAcen( cValToChar( aItem[j]:grupo				) ) )
					aSKU[ nSKU , 3 ] := Iif( Type("aItem["+Str(j)+"]:quantidade")=="U"			, "", U_RnNoAcen( cValToChar( aItem[j]:quantidade			) ) )
					aSKU[ nSKU , 4 ] := Iif( Type("aItem["+Str(j)+"]:valorUnitario")=="U"		, "", U_RnNoAcen( cValToChar( aItem[j]:valorUnitario		) ) )
					aSKU[ nSKU , 5 ] := Iif( Type("aItem["+Str(j)+"]:valorTotal")=="U"			, "", U_RnNoAcen( cValToChar( aItem[j]:valorTotal			) ) )
					aSKU[ nSKU , 6 ] := Iif( Type("aItem["+Str(j)+"]:descricao")=="U"			, "", U_RnNoAcen( cValToChar( aItem[j]:descricao			) ) )
					aSKU[ nSKU , 7 ] := Iif( Type("aItem["+Str(j)+"]:codigoProtheus")=="U"		, "", U_RnNoAcen( cValToChar( aItem[j]:codigoProtheus		) ) )
					aSKU[ nSKU , 8 ] := Iif( Type("aItem["+Str(j)+"]:descricaoProtheus")=="U"	, "", U_RnNoAcen( cValToChar( aItem[j]:descricaoProtheus	) ) )
					aSKU[ nSKU , 9 ] := Iif( Type("aItem["+Str(j)+"]:id")=="U"					, "", U_RnNoAcen( cValToChar( aItem[j]:id					) ) )

					aDel( aItem, j )
					aSize( aItem, Len(aItem) - 1 )					
				EndIF
			Next j

			//Caso a consulta seja por PEDIDO GAR, devo demonstrar somente o pedido específico e eliminar os demais.
			IF cOpc == '2' .And. cTpPesq == 'G'
				For j := 1 To Len( aItem )
					IF Type("aItem["+Str(j)+"]:id") <> "U" .And. Type("aItem["+Str(j)+"]:iditempai") <> "U" .And.;
						( Type("aItem["+Str(j)+"]:NUMEROPEDIDOORIGEM") == "U" .OR. cValToChar( aItem[j]:NUMEROPEDIDOORIGEM ) <> cPesq )
						aDel( aItem, j )
						aSize( aItem, Len(aItem) - 1 )
					EndIF
				Next j
			EndIF

			For j := 1 To Len( aItem )
				AAdd( aERP, '' )
				nElem := Len( aERP )
				aERP[ nElem ] := {}
				aERP[ nElem ] := Array( 66 )
				aFill( aERP[ nElem ], '' )

				// --> oObj[i]:numero É O NÚMERO DO PEDIDO SITE.
				cC5_XNPSITE := AllTrim( Iif( Type( "oObj["+Str(i)+"]:numero" )=="U", "", cValToChar( oObj[i]:numero ) ) )
			
				If cC5_XNPSITE <> ''
					dbSelectArea( 'SC5' )
					If lNickName
						SC5->( dbOrderNickName( 'PEDSITE' ) )
						lFound_SC5 := SC5->( dbSeek( xFilial( 'SC5' ) + cC5_XNPSITE ) )
						
						If lFound_SC5
							dbSelectArea( 'SA1' )
							SA1->( dbSetOrder( 1 ) )
							lFound_SA1 := SA1->( MsSeek( xFilial( 'SA1' ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
						Endif
					Endif
				Else
					lFound_SC5 := .F.
					lFound_SA1 := .F.
				Endif
			
				cStatusPagto := Iif(Type("oObj["+Str(i)+"]:statusPagamento")=="U","",cValToChar(oObj[i]:statusPagamento))
				
				If cStatusPagto $ '12'
					cStatusPagto := aStatusPagto[ Val( cStatusPagto ) ]
				Else
					cStatusPagto := ''
				Endif
				
				If Type( "oObj["+Str(i)+"]:faturamentoPJ:cnpj" ) == "U"
					cTpPessoa := 'F'
				Else
					cTpPessoa := 'J'
				Endif
				
				aERP[ nElem, 1 ] := 'Documento encontrado no ERP-Protheus'
				aERP[ nElem, 2 ] := Iif(Type("oObj["+Str(i)+"]:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:numero)) )
				aERP[ nElem, 3 ] := Iif( lFound_SC5 .AND. lFound_SA1, SC5->C5_NUM, '' )
				aERP[ nElem, 4 ] := Iif( lFound_SC5 .AND. lFound_SA1, U_RnNoAcen( RTrim( SA1->A1_NOME ) ), '' )
				aERP[ nElem, 5 ] := Iif( lFound_SC5 .AND. lFound_SA1, RTrim( SC5->C5_XNPARCE ), '' )
				aERP[ nElem, 6 ] := Iif(Type("oObj["+Str(i)+"]:dataFaturamento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:dataFaturamento)) )
				aERP[ nElem, 7 ] := cStatusPagto
				aERP[ nElem, 8 ] := Iif(Type("oObj["+Str(i)+"]:data")=="U","",U_RnNoAcen( cValToChar(oObj[i]:data)) )
				aERP[ nElem, 9 ] := Iif(Type("oObj["+Str(i)+"]:dataEntrega")=="U","",U_RnNoAcen( cValToChar(oObj[i]:dataEntrega)) )
				aERP[ nElem, 10] := Iif(Type("oObj["+Str(i)+"]:pagamento:boleto:url")=="U","",U_RnNoAcen( cValToChar(oObj[i]:pagamento:boleto:url)) )
				aERP[ nElem, 11] := Iif(Type("oObj["+Str(i)+"]:linkRecibo")=="U","",U_RnNoAcen( cValToChar(oObj[i]:linkRecibo)) )
				aERP[ nElem, 12] := Iif(Type("oObj["+Str(i)+"]:contato:nome")=="U","",U_RnNoAcen(U_RnNoAcen( cValToChar(oObj[i]:contato:nome)) ))
				aERP[ nElem, 13] := Iif(Type("oObj["+Str(i)+"]:contato:cpf")=="U","",U_RnNoAcen( cValToChar(oObj[i]:contato:cpf)) )
				aERP[ nElem, 14] := Iif(Type("oObj["+Str(i)+"]:contato:email")=="U","",U_RnNoAcen( cValToChar(oObj[i]:contato:email)) )
				aERP[ nElem, 15] := Iif(Type("oObj["+Str(i)+"]:contato:fone")=="U","",U_RnNoAcen( cValToChar(oObj[i]:contato:fone)) )
				
				If cTpPessoa == 'F'
					aERP[ nElem, 16] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:nome")=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:nome)) )
					aERP[ nElem, 17] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:cpf")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:cpf)) )
					aERP[ nElem, 18] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:logradouro")=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:endereco:logradouro)) ) +' '+ Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:numero)) )
					aERP[ nElem, 19] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:complemento")=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:endereco:complemento)) )
					aERP[ nElem, 20] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:cep")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:cep)) )
					aERP[ nElem, 21] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:bairro")=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:endereco:bairro)) )
					aERP[ nElem, 22] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:fone")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:fone)) )
					aERP[ nElem, 23] := '' // DDD não há no check-out.
					aERP[ nElem, 24] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:cidade")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:cidade)) )
					aERP[ nElem, 25] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:estado")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:estado)) )
					aERP[ nElem, 26] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:email")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:email)) )
				Else
					aERP[ nElem, 16] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:razaoSocial")=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPJ:razaoSocial)) )
					aERP[ nElem, 17] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:cnpj")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:cnpj)) )
					aERP[ nElem, 18] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:logradouro")=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPJ:endereco:logradouro)) ) +' '+ Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:numero)) )
					aERP[ nElem, 19] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:complemento")=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPJ:endereco:complemento)) )
					aERP[ nElem, 20] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:cep")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:cep)) )
					aERP[ nElem, 21] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:bairro")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:bairro)) )
					aERP[ nElem, 22] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:fone")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:fone)) )
					aERP[ nElem, 23] := '' // DDD não tem no check-out.
					aERP[ nElem, 24] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:cidade")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:cidade)) )
					aERP[ nElem, 25] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:estado")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:estado)) )
					aERP[ nElem, 26] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:email")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:email)) )
				Endif
				
				aERP[ nElem, 27] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:cnpj")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:cnpj)))
				aERP[ nElem, 28] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:razaoSocial")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:razaoSocial)) )
				aERP[ nElem, 29] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:inscricaoEstadual")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:inscricaoEstadual)) )
				aERP[ nElem, 30] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:inscricaoMunicipal")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:inscricaoMunicipal)) )
				aERP[ nElem, 31] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:suframa")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:suframa)) )
				aERP[ nElem, 32] := Iif(Type("oObj["+Str(i)+"]:pagamento:formaPagamento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:pagamento:formaPagamento)) )
				aERP[ nElem, 33] := cTpPessoa
				aERP[ nElem, 34] := Iif(Type("oObj["+Str(i)+"]:statusFaturamento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:statusFaturamento)) )
				aERP[ nElem, 35] := Iif(Type("oObj["+Str(i)+"]:statusPagamento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:statusPagamento)) )
				aERP[ nElem, 36] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:tipoTributacao")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:tipoTributacao)) )
				aERP[ nElem, 37] := Iif(Type("oObj["+Str(i)+"]:codigoOrigem")=="U","",U_RnNoAcen( cValToChar(oObj[i]:codigoOrigem)) )
				aERP[ nElem, 38] := Iif(Type("oObj["+Str(i)+"]:pedidoOrigem")=="U","",U_RnNoAcen( cValToChar(oObj[i]:pedidoOrigem)) )
				aERP[ nElem, 39] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:nome")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:nome)) )
				aERP[ nElem, 40] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:logradouro")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:logradouro)) ) + ' ' + Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:numero)) )
				aERP[ nElem, 41] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:complemento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:complemento)) )
				aERP[ nElem, 42] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:bairro")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:bairro)) )
				aERP[ nElem, 43] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:cep")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:cep)) )
				aERP[ nElem, 44] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:fone")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:fone)) )
				aERP[ nElem, 45] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:cidade")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:cidade )) )
				aERP[ nElem, 46] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:estado")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:estado)) )
				aERP[ nElem, 47] := Iif(Type("oObj["+Str(i)+"]:entrega:codigoRastreamento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:codigoRastreamento)) )
				aERP[ nElem, 48] := Iif(Type("oObj["+Str(i)+"]:entrega:nomeServico")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:nomeServico)) )
				aERP[ nElem, 49] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:logradouro")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:logradouro)) )
				aERP[ nElem, 50] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:numero)) )
				aERP[ nElem, 51] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:complemento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:complemento)) )
				aERP[ nElem, 52] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:bairro")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:bairro)) )
				aERP[ nElem, 53] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:cep")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:cep)) )
				aERP[ nElem, 54] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:cidade")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:cidade)) )
				aERP[ nElem, 55] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:estado")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:estado)) )
				aERP[ nElem, 56] := Iif(Type("oObj["+Str(i)+"]:entrega:valorServico")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:valorServico)) )
				aERP[ nElem, 57] := Iif(Type("oObj["+Str(i)+"]:entrega:linkRastreamento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:linkRastreamento)) )
				aERP[ nElem, 58] := Iif(Type("oObj["+Str(i)+"]:sac:nomeAnalista")=="U","",U_RnNoAcen( cValToChar(oObj[i]:sac:nomeAnalista)) )
				aERP[ nElem, 59] := Iif(Type("oObj["+Str(i)+"]:sac:codigoAnalista")=="U","",U_RnNoAcen( cValToChar(oObj[i]:sac:codigoAnalista)) )
				aERP[ nElem, 60] := Iif(Type("oObj["+Str(i)+"]:valorbruto")=="U","",U_RnNoAcen( cValToChar(oObj[i]:valorbruto)) )
				aERP[ nElem, 61] := Iif(Type("oObj["+Str(i)+"]:ecommerce")=="U","",U_RnNoAcen( cValToChar(oObj[i]:ecommerce)) )

				//Nesta etapa, preciso identificar qual elemento é o SKU(Combo), desta maneira
				//devo armezanar o elemento 62 "SKU" e não considerar no elemento 63 "itemProduto"
				IF Len( aSKU ) > 0
					For l := 1 To Len( aSKU )
						aERP[ nElem, 62 ] := {}
						AAdd( aERP[ nElem, 62 ], ' ' )
						k := Len( aERP[ nElem, 62 ] )
						aERP[ nElem, 62, k ] := {}
						aERP[ nElem, 62, k ] := Array( 09 )
						aFill( aERP[ nElem, 62, k ], '' )

						aERP[ nElem, 62, k, 1 ] := aSKU[ l, 1 ]
						aERP[ nElem, 62, k, 2 ] := aSKU[ l, 2 ]
						aERP[ nElem, 62, k, 3 ] := aSKU[ l, 3 ]
						aERP[ nElem, 62, k, 4 ] := aSKU[ l, 4 ]
						aERP[ nElem, 62, k, 5 ] := aSKU[ l, 5 ]
						aERP[ nElem, 62, k, 6 ] := aSKU[ l, 6 ]
						aERP[ nElem, 62, k, 7 ] := aSKU[ l, 7 ]
						aERP[ nElem, 62, k, 8 ] := aSKU[ l, 8 ]
						aERP[ nElem, 62, k, 9 ] := aSKU[ l, 9 ]
					Next l
				Else
					aERP[ nElem, 62 ] := {}
					AAdd( aERP[ nElem, 62 ], ' ' )
					k := Len( aERP[ nElem, 62 ] )
					aERP[ nElem, 62, k ] := {}
					aERP[ nElem, 62, k ] := Array( 09 )
					aFill( aERP[ nElem, 62, k ], '' )
				EndIF

				// Atribuir os dados de Produto
				aERP[ nElem, 63 ] := {}
				AAdd( aERP[ nElem, 63 ], ' ' )
				k := Len( aERP[ nElem, 63 ] )
				aERP[ nElem, 63, k ] := {}
				aERP[ nElem, 63, k ] := Array( 13 )
				
				aERP[ nElem, 63, k, 1 ] := Iif( Type("aItem["+Str(j)+"]:codigo")=="U"				,"", U_RnNoAcen( cValToChar(aItem[j]:codigo				)) )
				aERP[ nElem, 63, k, 2 ] := Iif( Type("aItem["+Str(j)+"]:grupo")=="U"				,"", U_RnNoAcen( cValToChar(aItem[j]:grupo				)) )
				aERP[ nElem, 63, k, 3 ] := Iif( Type("aItem["+Str(j)+"]:quantidade")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:quantidade			)) )
				aERP[ nElem, 63, k, 4 ] := Iif( Type("aItem["+Str(j)+"]:valorUnitario")=="U"		,"", U_RnNoAcen( cValToChar(aItem[j]:valorUnitario		)) )
				aERP[ nElem, 63, k, 5 ] := Iif( Type("aItem["+Str(j)+"]:valorTotal")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:valorTotal			)) )
				aERP[ nElem, 63, k, 6 ] := Iif( Type("aItem["+Str(j)+"]:descricao")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:descricao			)) )
				aERP[ nElem, 63, k, 7 ] := Iif( Type("aItem["+Str(j)+"]:codigoProtheus")=="U"		,"", U_RnNoAcen( cValToChar(aItem[j]:codigoProtheus		)) )
				aERP[ nElem, 63, k, 8 ] := Iif( Type("aItem["+Str(j)+"]:descricaoProtheus")=="U"	,"", U_RnNoAcen( cValToChar(aItem[j]:descricaoProtheus	)) )
				aERP[ nElem, 63, k, 9 ] := Iif( Type("aItem["+Str(j)+"]:numeroPedidoOrigem")=="U"	,"", U_RnNoAcen( cValToChar(aItem[j]:numeroPedidoOrigem	)) )
				aERP[ nElem, 63, k, 10] := Iif( Type("aItem["+Str(j)+"]:pedOrigem")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:PedOrigem			)) )
				aERP[ nElem, 63, k, 11] := Iif( Type("aItem["+Str(j)+"]:plataforma")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:plataforma			)) )
				aERP[ nElem, 63, k, 12] := Iif( Type("aItem["+Str(j)+"]:iditempai")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:iditempai			)) )
				aERP[ nElem, 63, k, 13] := Iif( Type("aItem["+Str(j)+"]:id")=="U"					,"", U_RnNoAcen( cValToChar(aItem[j]:id					)) )
				
				// Guardar este dado para fácil pesquisa.
				If aERP[ nElem, 63, k, 9 ] <> ''
					AAdd( aPedGAR, aERP[ nElem, 63, k, 9 ] )
				Endif
				
				// Atribuir os dados da Nota fiscal
				If Type("oObj["+Str(i)+"]:notasFiscais")<>"U" .AND. Len( oObj[i]:notasFiscais ) > 0
					// Quantas NF tem neste Json do check-out?
					nQtdNF := Len( oObj[i]:notasFiscais )
					// Atribuir o elemento 61 como vetor.
					aERP[ nElem, 64 ] := {}
					
					// Laço para processar todas as NF do objeto Json do check-out.
					For l := 1 To nQtdNF
						// Atribuir um dado no elemento do array criado em questão.
						AAdd( aERP[ nElem, 64 ], ' ' )
						// Qual o valor do elemento criado?
						m := Len( aERP[ nElem, 64 ] )
						// Atribuir no elemento em questão como vetor.
						aERP[ nElem, 64, m ] := {}
						// Definir dois elemento para esta dimensão.
						aERP[ nElem, 64, m ] := Array( 2 ) // [1]=TIPO e [2]LINK
						// Atribuir os dados as dimensões criadas.
						aERP[ nElem, 64, m, 1 ] := oObj[i]:notasFiscais[l]:tipo
						aERP[ nElem, 64, m, 2 ] := oObj[i]:notasFiscais[l]:link
					Next l
				Else
					aERP[ nElem, 64 ] := {}
					AAdd( aERP[ nElem, 64 ], ' ' )
					m := Len( aERP[ nElem, 64 ] )
					aERP[ nElem, 64, m ] := {}
					aERP[ nElem, 64, m ] := Array( 2 )
					aFill( aERP[ nElem, 64, m ], '' )					
				Endif

				// Atribuir os dados da Titularidade
				aERP[ nElem, 65 ] := {}
				AAdd( aERP[ nElem, 65 ], ' ' )
				k := Len( aERP[ nElem, 65 ] )
				aERP[ nElem, 65, k ] := {}
				aERP[ nElem, 65, k ] := Array( 3 )
				
				aERP[ nElem, 65, k, 1 ] := Iif( Type("aItem["+Str(j)+"]:titular:dataregistro") == "U"	, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:dataregistro ) ) )
				aERP[ nElem, 65, k, 2 ] := Iif( Type("aItem["+Str(j)+"]:titular:nome") == "U"			, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:nome ) ) )
				IF cTpPessoa == 'F'
					aERP[ nElem, 65, k, 3 ] := Iif( Type("aItem["+Str(j)+"]:titular:cpf") == "U"		, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:cpf ) ) )
				Else
					aERP[ nElem, 65, k, 3 ] := Iif( Type("aItem["+Str(j)+"]:titular:cnpj") == "U"		, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:cnpj ) ) )
				EndIF
				
				// Atribuir os dados do agendamento
				aERP[ nElem, 66 ] := {}
				AAdd( aERP[ nElem, 66 ], ' ' )
				k := Len( aERP[ nElem, 66 ] )
				aERP[ nElem, 66, k ] := {}
				aERP[ nElem, 66, k ] := Array( 5 )
				
				aERP[ nElem, 66, k, 1 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:nomeponto") == "U"		, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:nomeponto ) ) )
				aERP[ nElem, 66, k, 2 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:endereco") == "U"		, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:endereco ) ) )
				aERP[ nElem, 66, k, 3 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:dataagendamento") == "U", "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:dataagendamento ) ) )
				aERP[ nElem, 66, k, 4 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:horaagendamento") == "U", "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:horaagendamento ) ) )
				aERP[ nElem, 66, k, 5 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:dataregistro") == "U"	, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:dataregistro ) ) )

			Next j
		Next i
		*/
		
		//+------------------------------------------+
		//|Novo Layout para atender o SalesForce     |
		//|Rafael Beghini 19.08.2019                 |
		//+------------------------------------------+
		For i := 1 To Len( oObj )
			aSKU  := {}
			aItem := {}
			aItem := aClone( oObj[i]:itens )

			//+----------------------------------------------------------------------------------------------+
			//| Bruno Nunes                                                                                  |
			//+----------------------------------------------------------------------------------------------+
			//| Retirei a programação do iditempai, pois esta dando erro para os outros casos.               |
			//| O campo iditempai é excessão, caso der erro neste caso. fazer essa trativa de outra forma.   |
			//| Não ajustei para os dois casos pois não encontrei e ninguém achou um pedido com idPai.       |
			//+----------------------------------------------------------------------------------------------+
			/*
			For j := 1 To Len( aItem )
				lIdItempai := Type("aItem["+Str(j)+"]:iditempai") <> "U"
				if lIdItempai
					exit
				EndIF
			next j

			IF Len( aItem ) > 1 .And. .NOT. lIdItempai
				U_rnConout('Regra do idpai faz ignorar esse item.'  )
				Loop			
			EndIF
			*/
			
			AAdd( aERP, '' )
			nElem := Len( aERP )
			aERP[ nElem ] := {}
			aERP[ nElem ] := Array( 63 )
			aFill( aERP[ nElem ], '' )

			// --> oObj[i]:numero É O NÚMERO DO PEDIDO SITE.
			cC5_XNPSITE := AllTrim( Iif( Type( "oObj["+Str(i)+"]:numero" )=="U", "", cValToChar( oObj[i]:numero ) ) )
		
			U_rnConout('Pedido Site: ' + cC5_XNPSITE )
		
			If cC5_XNPSITE <> ''
				dbSelectArea( 'SC5' )
				If lNickName
					SC5->( dbOrderNickName( 'PEDSITE' ) )
					lFound_SC5 := SC5->( dbSeek( xFilial( 'SC5' ) + cC5_XNPSITE ) )
					
					If lFound_SC5
						dbSelectArea( 'SA1' )
						SA1->( dbSetOrder( 1 ) )
						lFound_SA1 := SA1->( MsSeek( xFilial( 'SA1' ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
						retSA1()
					Endif
				Endif
			Else
				lFound_SC5 := .F.
				lFound_SA1 := .F.
			Endif
			
			U_rnConout('Encontrou pedido de venda?: ' + iif( lFound_SC5, "Sim", "Nao" ) )
		
			cStatusPagto := Iif(Type("oObj["+Str(i)+"]:statusPagamento")=="U","",cValToChar(oObj[i]:statusPagamento))
			
			If cStatusPagto $ '12'
				cStatusPagto := aStatusPagto[ Val( cStatusPagto ) ]
			Else
				cStatusPagto := ''
			Endif
			
			If Type( "oObj["+Str(i)+"]:faturamentoPJ:cnpj" ) == "U"
				cTpPessoa := 'F'
			Else
				cTpPessoa := 'J'
			Endif

			//Pesquiso o cliente
			lFound_SA1 := findClient( i, cTpPesq, cTpPessoa )
			
			aERP[ nElem, 1 ] := 'Documento encontrado no ERP-Protheus'
			aERP[ nElem, 2 ] := Iif(Type("oObj["+Str(i)+"]:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:numero)) )
			aERP[ nElem, 3 ] := Iif( lFound_SC5 .AND. lFound_SA1, SC5->C5_NUM, '' )
			aERP[ nElem, 4 ] := Iif( lFound_SC5 .AND. lFound_SA1, U_RnNoAcen( RTrim( SA1->A1_NOME ) ), '' )
			aERP[ nElem, 5 ] := Iif( lFound_SC5 .AND. lFound_SA1, RTrim( SC5->C5_XNPARCE ), '' )
			aERP[ nElem, 6 ] := Iif(Type("oObj["+Str(i)+"]:dataFaturamento"                        )=="U","",U_RnNoAcen( cValToChar(oObj[i]:dataFaturamento)) )
			aERP[ nElem, 7 ] := cStatusPagto
			aERP[ nElem, 8 ] := Iif(Type("oObj["+Str(i)+"]:data"                                   )=="U","",U_RnNoAcen( cValToChar(oObj[i]:data)) )
			aERP[ nElem, 9 ] := Iif(Type("oObj["+Str(i)+"]:dataEntrega"                            )=="U","",U_RnNoAcen( cValToChar(oObj[i]:dataEntrega)) )
			aERP[ nElem, 10] := Iif(Type("oObj["+Str(i)+"]:pagamento:boleto:url"                   )=="U","",U_RnNoAcen( cValToChar(oObj[i]:pagamento:boleto:url)) )
			aERP[ nElem, 11] := Iif(Type("oObj["+Str(i)+"]:linkRecibo"                             )=="U","",U_RnNoAcen( cValToChar(oObj[i]:linkRecibo)) )
			aERP[ nElem, 12] := Iif(Type("oObj["+Str(i)+"]:contato:nome"                           )=="U","",U_RnNoAcen(U_RnNoAcen( cValToChar(oObj[i]:contato:nome)) ))
			aERP[ nElem, 13] := Iif(Type("oObj["+Str(i)+"]:contato:cpf"                            )=="U","",U_RnNoAcen( cValToChar(oObj[i]:contato:cpf)) )
			aERP[ nElem, 14] := Iif(Type("oObj["+Str(i)+"]:contato:email"                          )=="U","",U_RnNoAcen( cValToChar(oObj[i]:contato:email)) )
			aERP[ nElem, 15] := Iif(Type("oObj["+Str(i)+"]:contato:fone"                           )=="U","",U_RnNoAcen( cValToChar(oObj[i]:contato:fone)) )
			
			If cTpPessoa == 'F'
				aERP[ nElem, 16] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:nome"                 )=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:nome)) )
				aERP[ nElem, 17] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:cpf"                  )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:cpf)) )
				aERP[ nElem, 18] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:logradouro"  )=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:endereco:logradouro)) ) +' '+ Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:numero)) )
				aERP[ nElem, 19] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:complemento" )=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:endereco:complemento)) )
				aERP[ nElem, 20] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:cep"         )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:cep)) )
				aERP[ nElem, 21] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:bairro"      )=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPF:endereco:bairro)) )
				aERP[ nElem, 22] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:fone"        )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:fone)) )
				aERP[ nElem, 23] := '' // DDD não há no check-out.
				aERP[ nElem, 24] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:cidade"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:cidade)) )
				aERP[ nElem, 25] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:endereco:estado"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:endereco:estado)) )
				aERP[ nElem, 26] := Iif(Type("oObj["+Str(i)+"]:faturamentoPF:email"                )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPF:email)) )
				aERP[ nElem, 27] := ''
				aERP[ nElem, 28] := ''
				aERP[ nElem, 29] := ''
			Else
				aERP[ nElem, 16] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:razaoSocial"          )=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPJ:razaoSocial)) )
				aERP[ nElem, 17] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:cnpj"                 )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:cnpj)) )
				aERP[ nElem, 18] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:logradouro"  )=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPJ:endereco:logradouro)) ) +' '+ Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:numero)) )
				aERP[ nElem, 19] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:complemento" )=="U","",U_RnNoAcen(cValToChar(oObj[i]:faturamentoPJ:endereco:complemento)) )
				aERP[ nElem, 20] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:cep"         )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:cep)) )
				aERP[ nElem, 21] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:bairro"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:bairro)) )
				aERP[ nElem, 22] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:fone"        )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:fone)) )
				aERP[ nElem, 23] := '' // DDD não tem no check-out.
				aERP[ nElem, 24] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:cidade"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:cidade)) )
				aERP[ nElem, 25] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:endereco:estado"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:endereco:estado)) )
				aERP[ nElem, 26] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:email"                )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:email)) )
				aERP[ nElem, 27] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:inscricaoEstadual"    )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:inscricaoEstadual)) )
				aERP[ nElem, 28] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:inscricaoMunicipal"   )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:inscricaoMunicipal)) )
				aERP[ nElem, 29] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:suframa"              )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:suframa)) )
			Endif
			
			//aERP[ nElem, 27] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:cnpj")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:cnpj)))
			//aERP[ nElem, 28] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:razaoSocial")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:razaoSocial)) )
			//aERP[ nElem, 29] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:inscricaoEstadual")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:inscricaoEstadual)) )
			//aERP[ nElem, 30] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:inscricaoMunicipal")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:inscricaoMunicipal)) )
			//aERP[ nElem, 31] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:suframa")=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:suframa)) )
			aERP[ nElem, 30] := Iif(Type("oObj["+Str(i)+"]:pagamento:formaPagamento")=="U","",U_RnNoAcen( cValToChar(oObj[i]:pagamento:formaPagamento)) )
			aERP[ nElem, 31] := cTpPessoa
			aERP[ nElem, 32] := Iif(Type("oObj["+Str(i)+"]:statusFaturamento"                  )=="U","",U_RnNoAcen( cValToChar(oObj[i]:statusFaturamento)) )
			aERP[ nElem, 33] := Iif(Type("oObj["+Str(i)+"]:statusPagamento"                    )=="U","",U_RnNoAcen( cValToChar(oObj[i]:statusPagamento)) )
			aERP[ nElem, 34] := Iif(Type("oObj["+Str(i)+"]:faturamentoPJ:tipoTributacao"       )=="U","",U_RnNoAcen( cValToChar(oObj[i]:faturamentoPJ:tipoTributacao)) )
			aERP[ nElem, 35] := Iif(Type("oObj["+Str(i)+"]:codigoOrigem"                       )=="U","",U_RnNoAcen( cValToChar(oObj[i]:codigoOrigem)) )
			aERP[ nElem, 36] := Iif(Type("oObj["+Str(i)+"]:pedidoOrigem"                       )=="U","",U_RnNoAcen( cValToChar(oObj[i]:pedidoOrigem)) )
			aERP[ nElem, 37] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:nome"                 )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:nome)) )
			aERP[ nElem, 38] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:logradouro"  )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:logradouro)) ) + ' ' + Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:numero")=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:numero)) )
			aERP[ nElem, 39] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:complemento" )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:complemento)) )
			aERP[ nElem, 40] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:bairro"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:bairro)) )
			aERP[ nElem, 41] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:cep"         )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:cep)) )
			aERP[ nElem, 42] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:fone"        )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:fone)) )
			aERP[ nElem, 43] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:cidade"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:cidade )) )
			aERP[ nElem, 44] := Iif(Type("oObj["+Str(i)+"]:postoRetirada:endereco:estado"      )=="U","",U_RnNoAcen( cValToChar(oObj[i]:postoRetirada:endereco:estado)) )
			aERP[ nElem, 45] := Iif(Type("oObj["+Str(i)+"]:entrega:codigoRastreamento"         )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:codigoRastreamento)) )
			aERP[ nElem, 46] := Iif(Type("oObj["+Str(i)+"]:entrega:nomeServico"                )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:nomeServico)) )
			aERP[ nElem, 47] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:logradouro"        )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:logradouro)) )
			aERP[ nElem, 48] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:numero"            )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:numero)) )
			aERP[ nElem, 49] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:complemento"       )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:complemento)) )
			aERP[ nElem, 50] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:bairro"            )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:bairro)) )
			aERP[ nElem, 51] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:cep"               )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:cep)) )
			aERP[ nElem, 52] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:cidade"            )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:cidade)) )
			aERP[ nElem, 53] := Iif(Type("oObj["+Str(i)+"]:entrega:endereco:estado"            )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:endereco:estado)) )
			aERP[ nElem, 54] := Iif(Type("oObj["+Str(i)+"]:entrega:valorServico"               )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:valorServico)) )
			aERP[ nElem, 55] := Iif(Type("oObj["+Str(i)+"]:entrega:linkRastreamento"           )=="U","",U_RnNoAcen( cValToChar(oObj[i]:entrega:linkRastreamento)) )
			aERP[ nElem, 56] := Iif(Type("oObj["+Str(i)+"]:sac:nomeAnalista"                   )=="U","",U_RnNoAcen( cValToChar(oObj[i]:sac:nomeAnalista)) )
			aERP[ nElem, 57] := Iif(Type("oObj["+Str(i)+"]:sac:codigoAnalista"                 )=="U","",U_RnNoAcen( cValToChar(oObj[i]:sac:codigoAnalista)) )
			aERP[ nElem, 58] := Iif(Type("oObj["+Str(i)+"]:valorbruto"                         )=="U","",U_RnNoAcen( cValToChar(oObj[i]:valorbruto)) )
			aERP[ nElem, 59] := Iif(Type("oObj["+Str(i)+"]:pedidoecommerce"                    )=="U","",U_RnNoAcen( cValToChar(oObj[i]:pedidoecommerce)) )

			//+-------------------------------------------------------------------+
			//|Nesta etapa, preciso identificar qual elemento é o SKU(Combo),     |
			//|desta maneira, não demonstro como item no Json                     |
			//+-------------------------------------------------------------------+
			
			For j := 1 To Len( aItem )
				IF Type("aItem["+Str(j)+"]:id") <> "U" .And. Type("aItem["+Str(j)+"]:iditempai") == "U"
					AAdd( aSKU, '' )
					nSKU := Len( aSKU )
					aSKU[ nSKU ] := {}
					aSKU[ nSKU ] := Array( 10 )
					aFill( aSKU[ nSKU ], '' )

					aSKU[ nSKU , 01 ] := Iif( Type("aItem["+Str(j)+"]:codigo")=="U"				, "", U_RnNoAcen( cValToChar( aItem[j]:codigo				) ) )
					aSKU[ nSKU , 02 ] := Iif( Type("aItem["+Str(j)+"]:grupo")=="U"				, "", U_RnNoAcen( cValToChar( aItem[j]:grupo				) ) )
					aSKU[ nSKU , 03 ] := Iif( Type("aItem["+Str(j)+"]:quantidade")=="U"			, "", U_RnNoAcen( cValToChar( aItem[j]:quantidade			) ) )
					aSKU[ nSKU , 04 ] := Iif( Type("aItem["+Str(j)+"]:valorUnitario")=="U"		, "", U_RnNoAcen( cValToChar( aItem[j]:valorUnitario		) ) )
					aSKU[ nSKU , 05 ] := Iif( Type("aItem["+Str(j)+"]:valorTotal")=="U"			, "", U_RnNoAcen( cValToChar( aItem[j]:valorTotal			) ) )
					aSKU[ nSKU , 06 ] := Iif( Type("aItem["+Str(j)+"]:descricao")=="U"			, "", U_RnNoAcen( cValToChar( aItem[j]:descricao			) ) )
					aSKU[ nSKU , 07 ] := Iif( Type("aItem["+Str(j)+"]:codigoProtheus")=="U"		, "", U_RnNoAcen( cValToChar( aItem[j]:codigoProtheus		) ) )
					aSKU[ nSKU , 08 ] := Iif( Type("aItem["+Str(j)+"]:descricaoProtheus")=="U"	, "", U_RnNoAcen( cValToChar( aItem[j]:descricaoProtheus	) ) )
					aSKU[ nSKU , 09 ] := Iif( Type("aItem["+Str(j)+"]:id")=="U"					, "", U_RnNoAcen( cValToChar( aItem[j]:id					) ) )
					aSKU[ nSKU , 10 ] := {}

					//+----------------------------------------------------------------------------------------------+
					//| Bruno Nunes                                                                                  |
					//+----------------------------------------------------------------------------------------------+
					//| Retirei a programação do iditempai, pois esta dando erro para os outros casos.               |
					//| O campo iditempai é excessão, caso der erro neste caso. fazer essa trativa de outra forma.   |
					//| Não ajustei para os dois casos pois não encontrei e ninguém achou um pedido com idPai.       |
					//+----------------------------------------------------------------------------------------------+
					
					IF Len( aItem ) > 1
						aDel( aItem, j )
						aSize( aItem, Len(aItem) - 1 )						
					EndIF
				EndIF				
			Next j

			For j := 1 To Len( aItem )
				nPos := aScan( aSKU, { |r| r[9] == U_RnNoAcen( cValToChar( IIF( Type("aItem["+Str(j)+"]:iditempai")=="U", aItem[j]:id, aItem[j]:iditempai ) ) ) } )
				
				if nPos > 0
					AAdd( aSKU[ nPos, 10 ], ' ' )
					k := Len( aSKU[ nPos, 10 ] )
					aSKU[ nPos, 10, k ] := {}
					aSKU[ nPos, 10, k ] := Array( 13 )
					aFill( aSKU[ nPos, 10, k ], '' )
	
					aSKU[ nPos, 10, k, 1 ] := Iif( Type("aItem["+Str(j)+"]:codigo")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:codigo				)) )
					aSKU[ nPos, 10, k, 2 ] := Iif( Type("aItem["+Str(j)+"]:grupo")=="U"				,"", U_RnNoAcen( cValToChar(aItem[j]:grupo				)) )
					aSKU[ nPos, 10, k, 3 ] := Iif( Type("aItem["+Str(j)+"]:quantidade")=="U"		,"", U_RnNoAcen( cValToChar(aItem[j]:quantidade			)) )
					aSKU[ nPos, 10, k, 4 ] := Iif( Type("aItem["+Str(j)+"]:valorUnitario")=="U"		,"", U_RnNoAcen( cValToChar(aItem[j]:valorUnitario		)) )
					aSKU[ nPos, 10, k, 5 ] := Iif( Type("aItem["+Str(j)+"]:valorTotal")=="U"		,"", U_RnNoAcen( cValToChar(aItem[j]:valorTotal			)) )
					aSKU[ nPos, 10, k, 6 ] := Iif( Type("aItem["+Str(j)+"]:descricao")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:descricao			)) )
					aSKU[ nPos, 10, k, 7 ] := Iif( Type("aItem["+Str(j)+"]:codigoProtheus")=="U"	,"", U_RnNoAcen( cValToChar(aItem[j]:codigoProtheus		)) )
					aSKU[ nPos, 10, k, 8 ] := Iif( Type("aItem["+Str(j)+"]:descricaoProtheus")=="U"	,"", U_RnNoAcen( cValToChar(aItem[j]:descricaoProtheus	)) )
					aSKU[ nPos, 10, k, 9 ] := Iif( Type("aItem["+Str(j)+"]:numeroPedidoOrigem")=="U","", U_RnNoAcen( cValToChar(aItem[j]:numeroPedidoOrigem	)) )
					aSKU[ nPos, 10, k, 10] := Iif( Type("aItem["+Str(j)+"]:pedOrigem")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:PedOrigem			)) )
					aSKU[ nPos, 10, k, 11] := Iif( Type("aItem["+Str(j)+"]:plataforma")=="U"		,"", U_RnNoAcen( cValToChar(aItem[j]:plataforma			)) )
					aSKU[ nPos, 10, k, 12] := Iif( Type("aItem["+Str(j)+"]:iditempai")=="U"			,"", U_RnNoAcen( cValToChar(aItem[j]:iditempai			)) )
					aSKU[ nPos, 10, k, 13] := Iif( Type("aItem["+Str(j)+"]:id")=="U"				,"", U_RnNoAcen( cValToChar(aItem[j]:id					)) )
	
					If aSKU[ nPos, 10, k, 9 ] <> ''
						AAdd( aPedGAR, aSKU[ nPos, 10, k, 9 ] )
					Endif
	
					IF Type("aItem["+Str(j)+"]:titular") <> "U"
						AAdd( aTitular, '' )
						nTit := Len( aTitular )
						aTitular[ nTit ] := {}
						aTitular[ nTit ] := Array( 04 )
	
						aTitular[ nTit, 1 ] := Iif( Type("aItem["+Str(j)+"]:numeroPedidoOrigem")=="U"		, ""	, U_RnNoAcen( cValToChar(aItem[j]:numeroPedidoOrigem )) )
						aTitular[ nTit, 2 ] := Iif( Type("aItem["+Str(j)+"]:titular:dataregistro") == "U"	, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:dataregistro ) ) )
						aTitular[ nTit, 3 ] := Iif( Type("aItem["+Str(j)+"]:titular:nome") == "U"			, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:nome ) ) )
						IF cTpPessoa == 'F'
							aTitular[ nTit, 4 ] := Iif( Type("aItem["+Str(j)+"]:titular:cpf") == "U"		, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:cpf ) ) )
						Else
							aTitular[ nTit, 4 ] := Iif( Type("aItem["+Str(j)+"]:titular:cnpj") == "U"		, ""	, U_RnNoAcen( cValToChar( aItem[j]:titular:cnpj ) ) )
						EndIF
					EndIF
	
					IF Type("aItem["+Str(j)+"]:agendamento") <> "U"
						AAdd( aAgendam, '' )
						nAgend := Len( aAgendam )
						aAgendam[ nAgend ] := {}
						aAgendam[ nAgend ] := Array( 06 )
	
						aAgendam[ nAgend, 1 ] := Iif( Type("aItem["+Str(j)+"]:numeroPedidoOrigem")=="U"				, "", U_RnNoAcen( cValToChar(aItem[j]:numeroPedidoOrigem )) )
						aAgendam[ nAgend, 2 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:nomeponto") == "U"		, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:nomeponto ) ) )
						aAgendam[ nAgend, 3 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:endereco") == "U"			, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:endereco ) ) )
						aAgendam[ nAgend, 4 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:dataagendamento") == "U"	, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:dataagendamento ) ) )
						aAgendam[ nAgend, 5 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:horaagendamento") == "U"	, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:horaagendamento ) ) )
						aAgendam[ nAgend, 6 ] := Iif( Type("aItem["+Str(j)+"]:agendamento:dataregistro") == "U"		, "", U_RnNoAcen( cValToChar( aItem[j]:agendamento:dataregistro ) ) )
					EndIF
				endif
			Next j

			aERP[ nElem, 60 ] := aSKU
			
			// Atribuir os dados da Nota fiscal
			If Type("oObj["+Str(i)+"]:notasFiscais")<>"U" .AND. Len( oObj[i]:notasFiscais ) > 0
				// Quantas NF tem neste Json do check-out?
				nQtdNF := Len( oObj[i]:notasFiscais )
				// Atribuir o elemento 61 como vetor.
				aERP[ nElem, 61 ] := {}
				
				// Laço para processar todas as NF do objeto Json do check-out.
				For l := 1 To nQtdNF
					// Atribuir um dado no elemento do array criado em questão.
					AAdd( aERP[ nElem, 61 ], ' ' )
					// Qual o valor do elemento criado?
					m := Len( aERP[ nElem, 61 ] )
					// Atribuir no elemento em questão como vetor.
					aERP[ nElem, 61, m ] := {}
					// Definir dois elemento para esta dimensão.
					aERP[ nElem, 61, m ] := Array( 2 ) // [1]=TIPO e [2]LINK
					// Atribuir os dados as dimensões criadas.
					aERP[ nElem, 61, m, 1 ] := oObj[i]:notasFiscais[l]:tipo
					aERP[ nElem, 61, m, 2 ] := oObj[i]:notasFiscais[l]:link
				Next l
			Else
				aERP[ nElem, 61 ] := {}
				AAdd( aERP[ nElem, 61 ], ' ' )
				m := Len( aERP[ nElem, 61 ] )
				aERP[ nElem, 61, m ] := {}
				aERP[ nElem, 61, m ] := Array( 2 )
				aFill( aERP[ nElem, 61, m ], '' )					
			Endif

			IF Len( aTitular ) > 0
				aERP[ nElem, 62 ] := aTitular
			Else
				AAdd( aTitular, '' )
				nTit := Len( aTitular )
				aTitular[ nTit ] := {}
				aTitular[ nTit ] := Array( 04 )
				aFill( aTitular[ nTit ], '' )

				aERP[ nElem, 62 ] := aTitular
			EndIF

			IF Len( aAgendam ) > 0
				aERP[ nElem, 63 ] := aAgendam		
			Else
				AAdd( aAgendam, '' )
				nAgend := Len( aAgendam )
				aAgendam[ nAgend ] := {}
				aAgendam[ nAgend ] := Array( 06 )
				aFill( aAgendam[ nAgend ], '' )

				aERP[ nElem, 63 ] := aAgendam
			EndIF			
		Next i

	Else
		If .NOT. lGet
			U_rnConout('_______________NAO CONSEGUI FAZER O GET NO CHECK-OUT ' + cThread + '_______________')
			U_rnConout('GETLASTERRO: ' + o881Rest:GetLastError() )
		Endif
		If cGetResult == '[ ]'
			U_rnConout('_______________NAO CONSEGUI OBTER O GETRESULT NO CHECK-OUT ' + cThread + '_______________')
			U_rnConout('GETLASTERRO: ' + o881Rest:GetLastError() )
		Endif
		If .NOT. lDeserialize
			U_rnConout('_______________NA THREAD ' + cThread + ' HOUVE ERRO NA SINTAXE JSON ENTREGUE PELO CHECK-OUT_______________' )
			U_rnConout('GETRESULT: ' + cGetResult )
		Endif
		findCliPar( cPesq )
	Endif
	
	//+------------------------------------------------------------------------+
	//| Após fazer a pesquisa no Check-Out verificar se é CPF/CNPJ títular     | 
	//| Sendo assim buscar o número dos pedidos no GAR pelo serviço byCPFCNPJ. |
	//+------------------------------------------------------------------------+
	If (cTpPesq=='T') 
		oWsGAR := WSIntegracaoGARERPImplService():New()
		oWsGAR:findPedidosByCPFCNPJ( eVal({|| oObj1:=loginUserPassword():get('USERERPGAR'), oObj1:cReturn }),;
									 eVal({|| oObj1:=loginUserPassword():get('PASSERPGAR'), oObj1:cReturn }),;
									 Val( cPesq ) )
		oDados := oWsGAR:oWsIdPedido
		If oDados <> NIL
			For nL := Len( oDados ) To 1 STEP -1
				If oDados[ nL ]:TEXT <> NIL
					If .NOT. Empty( oDados[ nL ]:TEXT )
						// Verificar se está dentro do limite de pedidos.
						If (++nQtd > nQtdLim)
							U_rnConout('SAIR DO FOR/NEXT FINDPEDIDOSBYCPFCNPJ, EXCEDEU LIMITE: nQtd ' + LTrim( Str( nQtd ) ) + ' ' + LTrim( Str( nQtdLim ) ) + '. ' + cThread)
							Exit
						Endif
						
						// Procurar o pedido GAR em questão no array aERP, se não existir agregar ele. rbeghini
						If AScan( aPedGAR, oDados[ nL ]:TEXT ) == 0
							AAdd( aERP, '' )
							nElem := Len( aERP )
							aERP[ nElem ] := {}
							aERP[ nElem ] := Array( 63 )
							aFill( aERP[ nElem ], '' )
							aERP[ nElem, 1 ] := 'Documento encontrado no ERP-Protheus'
							
							//SKU (+ item)
							aERP[ nElem, 60 ] := {}
							AAdd( aERP[ nElem, 60 ], '' )
							j := Len( aERP[ nElem, 60 ] )
							aERP[ nElem, 60, j ] := {}
							aERP[ nElem, 60, j ] := Array( 10 )
							aFill( aERP[ nElem, 60, j ], '' )

							aERP[ nElem, 60, j, 10 ] := {}

							AAdd( aERP[ nElem, 60, j, 10 ], ' ' )
							k := Len( aERP[ nElem, 60, j, 10 ] )
							aERP[ nElem, 60, j, 10, k ] := {}
							aERP[ nElem, 60, j, 10, k ] := Array( 13 )
							aFill( aERP[ nElem, 60, j, 10, k ], '' )
							
							aERP[ nElem, 60, j, 10, k, 9 ] := oDados[ nL ]:TEXT
							
							//Nota fiscal
							aERP[ nElem, 61 ] := {}
							AAdd( aERP[ nElem, 61 ], '' )
							m := Len( aERP[ nElem, 61 ] )
							aERP[ nElem, 61, m ] := {}
							aERP[ nElem, 61, m ] := Array( 2 )
							aFill( aERP[ nElem, 61, m ], '' )

							//Titularidade
							aERP[ nElem, 62 ] := {}
							AAdd( aERP[ nElem, 62 ], '' )
							m := Len( aERP[ nElem, 62 ] )
							aERP[ nElem, 62, m ] := {}
							aERP[ nElem, 62, m ] := Array( 4 )
							aFill( aERP[ nElem, 62, m ], '' )

							//Agendamento
							aERP[ nElem, 63 ] := {}
							AAdd( aERP[ nElem, 63 ], '' )
							m := Len( aERP[ nElem, 63 ] )
							aERP[ nElem, 63, m ] := {}
							aERP[ nElem, 63, m ] := Array( 6 )
							aFill( aERP[ nElem, 63, m ], '' )
						Endif
					Else
						U_rnConout('NAO LOCALIZEI DADOS NO FINDPEDIDOSBYCPFCNPJ.' + cThread )
						U_rnConout(VarInfo( 'oDados', oDados, ,.F., .F. ))
					Endif
				Else
					U_rnConout('ESTOU DENTRO DO FOR/NEXT FINDPEDIDOSBYCPFCNPJ, POREM NAO CONSEGUI INDETIFICAR O DADO.' + cThread)
					U_rnConout(VarInfo( 'oDados', oDados, ,.F., .F. ))
				Endif
			Next nL
		Else
			U_rnConout('__________________________________________________________________________')
			U_rnConout('_______________NAO CONSEGUI CONSULTAR O findPedidoByCPFCNPJ_______________')
			If lVarInfo
				U_rnConout(VarInfo( 'WSIntegracaoGARERPImplService', oWsGAR, ,.F., .F. ))
				U_rnConout((VarInfo( 'findPedidosByCPFCNPJ - numero do CPF/CNPJ: ' + cPesq, oDados, ,.F., .F. )))
			Endif
			U_rnConout('__________________________________________________________________________')
		Endif
	Else
		U_rnConout('Nao entrei no findPedidosByCPFCNPJ o tipo é: ' + cTpPesq + '. ' + cThread)
	Endif
	
	//+------------------------------------------------------------------------+
	//| a consulta solicitada é pedido gar (cOpc=='2' .AND. cTpPesq=='G')?     |
	//| não foi possível localizar dados no check-out (Len(aERP)==0)?          |
	//| se ambas perguntas foram respondidas positivamente,                    | 
	//| fazer a consulta no GAR.                                               |
	//+------------------------------------------------------------------------+
	If cOpc == '2' .AND. cTpPesq == 'G' .AND. Len( aERP ) == 0
		get_Ped( cPesq, @aFindDPed, @cStack, cThread, (cTpPesq+cOpc) )
		
		If Len( aFindDPed ) > 0
			AAdd( aERP, '' )
			nElem := Len( aERP )
			aERP[ nElem ] := {}
			aERP[ nElem ] := Array( 63 )
			aFill( aERP[ nElem ], '' )
			aERP[ nElem, 1 ] := 'Documento encontrado no ERP-Protheus'
			
			//SKU (+ item)
			aERP[ nElem, 60 ] := {}
			AAdd( aERP[ nElem, 60 ], '' )
			j := Len( aERP[ nElem, 60 ] )
			aERP[ nElem, 60, j ] := {}
			aERP[ nElem, 60, j ] := Array( 10 )
			aFill( aERP[ nElem, 60, j ], '' )

			aERP[ nElem, 60, j, 10 ] := {}

			AAdd( aERP[ nElem, 60, j, 10 ], ' ' )
			k := Len( aERP[ nElem, 60, j, 10 ] )
			aERP[ nElem, 60, j, 10, k ] := {}
			aERP[ nElem, 60, j, 10, k ] := Array( 13 )
			aFill( aERP[ nElem, 60, j, 10, k ], '' )
			
			//aERP[ nElem, 60, j, 10, k, 9 ] := oDados[ nL ]:TEXT
			
			//Nota fiscal
			aERP[ nElem, 61 ] := {}
			AAdd( aERP[ nElem, 61 ], '' )
			m := Len( aERP[ nElem, 61 ] )
			aERP[ nElem, 61, m ] := {}
			aERP[ nElem, 61, m ] := Array( 2 )
			aFill( aERP[ nElem, 61, m ], '' )

			//Titularidade
			aERP[ nElem, 62 ] := {}
			AAdd( aERP[ nElem, 62 ], '' )
			m := Len( aERP[ nElem, 62 ] )
			aERP[ nElem, 62, m ] := {}
			aERP[ nElem, 62, m ] := Array( 4 )
			aFill( aERP[ nElem, 62, m ], '' )

			//Agendamento
			aERP[ nElem, 63 ] := {}
			AAdd( aERP[ nElem, 63 ], '' )
			m := Len( aERP[ nElem, 63 ] )
			aERP[ nElem, 63, m ] := {}
			aERP[ nElem, 63, m ] := Array( 6 )
			aFill( aERP[ nElem, 63, m ], '' )
		Endif
	Endif
	
	//+--------------------------------------------------------------------------------+
	//| Acima deste ponto há diversas variáveis que tratam a possibilidade,            |
	//| são elas lGet, cGetResult e lDeserialize, no entanto qualquer uma dessas       |
	//| podem ajudar a determinar se a array aERP está preenchida ou vazia. Bem, ela   |
	//| estando vazia é o suficiaente para determinar que não há dados para entregar,  |
	//| mesmo sim é preciso preenche-la como array.                                    |
	//+--------------------------------------------------------------------------------+
	If Len( aERP ) == 0
		AAdd( aERP, '' )
		nElem := Len( aERP )
		aERP[ nElem ] := {}
		aERP[ nElem ] := Array( 63 )
		aFill( aERP[ nElem ], '' )
		aERP[ nElem, 1 ] := '1-Documento nao localizado no ERP-Protheus'
		
		//SKU (+ item)
		aERP[ nElem, 60 ] := {}
		AAdd( aERP[ nElem, 60 ], '' )
		j := Len( aERP[ nElem, 60 ] )
		aERP[ nElem, 60, j ] := {}
		aERP[ nElem, 60, j ] := Array( 10 )
		aFill( aERP[ nElem, 60, j ], '' )

		aERP[ nElem, 60, j, 10 ] := {}

		AAdd( aERP[ nElem, 60, j, 10 ], ' ' )
		k := Len( aERP[ nElem, 60, j, 10 ] )
		aERP[ nElem, 60, j, 10, k ] := {}
		aERP[ nElem, 60, j, 10, k ] := Array( 13 )
		aFill( aERP[ nElem, 60, j, 10, k ], '' )
		
		//aERP[ nElem, 60, j, 10, k, 9 ] := oDados[ nL ]:TEXT
		
		//Nota fiscal
		aERP[ nElem, 61 ] := {}
		AAdd( aERP[ nElem, 61 ], '' )
		m := Len( aERP[ nElem, 61 ] )
		aERP[ nElem, 61, m ] := {}
		aERP[ nElem, 61, m ] := Array( 2 )
		aFill( aERP[ nElem, 61, m ], '' )

		//Titularidade
		aERP[ nElem, 62 ] := {}
		AAdd( aERP[ nElem, 62 ], '' )
		m := Len( aERP[ nElem, 62 ] )
		aERP[ nElem, 62, m ] := {}
		aERP[ nElem, 62, m ] := Array( 4 )
		aFill( aERP[ nElem, 62, m ], '' )

		//Agendamento
		aERP[ nElem, 63 ] := {}
		AAdd( aERP[ nElem, 63 ], '' )
		m := Len( aERP[ nElem, 63 ] )
		aERP[ nElem, 63, m ] := {}
		aERP[ nElem, 63, m ] := Array( 6 )
		aFill( aERP[ nElem, 63, m ], '' )
	Endif
	
	o881Rest := NIL
	o881Result := NIL
Return

/*/{Protheus.doc} get_Ped
Monta Json com dados com base no Client do GAR findDadosPedido
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/	
Static Function get_Ped( cPedidoGAR, aFindDPed, cStack, cThread, cTipOpc, aTrilha )
	Local nElem := 0
	Local oDados
	Local oWsGAR
	Local oObj
	
	DEFAULT cStack := ''
	Default aTrilha := {}

	//+---------------------------------------------------------------------------+
	//| Verificar se o número do pedido GAR já está incluso no vetor.             |
	//| Se estiver, não é necessário fazer a busca.                               |
	//| Porque isto pode acontecer? Porque a opção da pesquisa por pedido GAR     |
	//| tem a possibilidade de não existir dados no check-out e por isso          |
	//| é feito a pesquisa diretamente no GAR, então para não refazer a pesquisa  |
	//| é melhor verificar se já há o número do pedido GAR no vetor.              |
	//+---------------------------------------------------------------------------+
	If .NOT. Empty( cPedidoGAR )
		If AScan( aFindDPed, {|e| e[ 20 ] == cPedidoGAR } ) > 0
			If cTipOpc == '2G'
				Return
			Endif
		Endif
	Endif
	
	cStack += 'GET_PED()' + CRLF
	 
	U_rnConout('Vou conectar no findDadosPedidos. ' + cThread)
	
	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
							eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
							Val( cPedidoGAR ) )
	oDados := oWsGAR:oWsDadosPedido
	
	U_rnConout('Vou ler o findDadosPedidos. ' + cThread)
	
	AAdd( aFindDPed, '' )
	nElem := Len( aFindDPed )
	aFindDPed[ nElem ] := {}
	aFindDPed[ nElem ] := Array( 31 )
	aFill( aFindDPed[ nElem ], '' )
	
	If oDados == NIL .OR. oDados:nPedido == NIL
		U_rnConout('______________________________________________________________________________')
		U_rnConout('_______________### NAO CONSEGUI CONSULTAR O findDadosPedido ###_______________')
		U_rnConout(VarInfo( 'findDadosPedido', cPedidoGAR, ,.F., .F. ))
		If lVarInfo
			U_rnConout(VarInfo( 'WSIntegracaoGARERPImplService', oWsGAR, ,.F., .F. ))
			U_rnConout(VarInfo( 'findDadosPedido - numero do pedido: ' + cPedidoGAR, oDados, ,.F., .F. ))
		Endif
		U_rnConout('______________________________________________________________________________')
		aFindDPed[ nElem, 1 ] := 'Documento nao localizado no GAR-Find Dados Pedido'
		Return
	Endif
	
	aFindDPed[ nElem,  1 ] := 'Documento encontrado no GAR-Find Dados Pedido'
	aFindDPed[ nElem,  2 ] := U_RnNoAcen( cValToChar( oDados:cArDesc ) )
	aFindDPed[ nElem,  3 ] := U_RnNoAcen( cValToChar( oDados:cArId ) )
	aFindDPed[ nElem,  4 ] := U_RnNoAcen( cValToChar( oDados:cArValidacao ) )
	aFindDPed[ nElem,  5 ] := U_RnNoAcen( cValToChar( oDados:cArValidacaoDesc ) )
	aFindDPed[ nElem,  6 ] := U_RnNoAcen( cValToChar( oDados:nCnpjCert ) )
	aFindDPed[ nElem,  7 ] := U_RnNoAcen( cValToChar( oDados:nCpfAgenteValidacao ) )
	aFindDPed[ nElem,  8 ] := U_RnNoAcen( cValToChar( oDados:nCpfAgenteVerificacao ) )
	aFindDPed[ nElem,  9 ] := U_RnNoAcen( cValToChar( oDados:nCpfTitular ) )
	aFindDPed[ nElem, 10 ] := U_RnNoAcen( cValToChar( oDados:cDataEmissao ) )
	aFindDPed[ nElem, 11 ] := U_RnNoAcen( cValToChar( oDados:cDataPedido ) )
	aFindDPed[ nElem, 12 ] := U_RnNoAcen( cValToChar( oDados:cDataValidacao ) )
	aFindDPed[ nElem, 13 ] := U_RnNoAcen( cValToChar( oDados:cDataVerificacao ) )
	aFindDPed[ nElem, 14 ] := U_RnNoAcen( cValToChar( oDados:cEmailTitular ) )
	aFindDPed[ nElem, 15 ] := U_RnNoAcen( cValToChar( oDados:cGrupo ) )
	aFindDPed[ nElem, 16 ] := U_RnNoAcen( cValToChar( oDados:cGrupoDescricao ) )
	aFindDPed[ nElem, 17 ] := U_RnNoAcen( cValToChar( oDados:cNomeAgenteValidacao ) )
	aFindDPed[ nElem, 18 ] := U_RnNoAcen( cValToChar( oDados:cNomeAgenteVerificacao ) )
	aFindDPed[ nElem, 19 ] := U_RnNoAcen( cValToChar( oDados:cNomeTitular ) )
	aFindDPed[ nElem, 20 ] := U_RnNoAcen( cValToChar( oDados:nPedido ) )
	aFindDPed[ nElem, 21 ] := U_RnNoAcen( cValToChar( oDados:cPostoValidacaoDesc ) )
	aFindDPed[ nElem, 22 ] := U_RnNoAcen( cValToChar( oDados:nPostoValidacaoId ) )
	aFindDPed[ nElem, 23 ] := U_RnNoAcen( cValToChar( oDados:cPostoVerificacaoDesc ) )
	aFindDPed[ nElem, 24 ] := U_RnNoAcen( cValToChar( oDados:nPostoVerificacaoId ) )
	aFindDPed[ nElem, 25 ] := U_RnNoAcen( cValToChar( oDados:cProduto ) )
	aFindDPed[ nElem, 26 ] := U_RnNoAcen( cValToChar( oDados:cProdutoDesc ) )
	aFindDPed[ nElem, 27 ] := U_RnNoAcen( cValToChar( oDados:cRazaoSocialCert ) )
	aFindDPed[ nElem, 28 ] := U_RnNoAcen( cValToChar( oDados:cRede ) )
	aFindDPed[ nElem, 29 ] := U_RnNoAcen( cValToChar( oDados:cStatus ) )
	aFindDPed[ nElem, 30 ] := IIf( U_RnNoAcen( cValToChar( oDados:cStatus ) ) == '3', 'Aprovado', U_RnNoAcen( cValToChar( oDados:cStatusDesc) ) )
	aFindDPed[ nElem, 31 ] := U_RnNoAcen( cValToChar( oDados:cUfTitular ) )

	IF Len( aTrilha ) > 0
		IF aTrilha[1, 1, 3] == 'BLQ'
			aFindDPed[ nElem, 30 ] := 'Bloqueado por segurança'
		EndIF
	EndIF	
Return

/*/{Protheus.doc} get_Certif
Monta Json com dados com base no Client do GAR consultaDadosCertificadoPorPedido
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/	
Static Function get_Certif( cPedidoGAR, aCertif, cStack, cThread )
	Local cAux := ''
	Local nElem := 0
	Local oDados
	Local oWsGAR
	Local oObj
	
	DEFAULT cStack := ''
		
	cStack += 'GET_CERTIF()' + CRLF
	
	U_rnConout('Vou conectar no consultaDadosCertificadoPorPedido. ' + cThread)
	
	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:consultaDadosCertificadoPorPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
											  eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
											  Val( cPedidoGAR ) )
	oDados := oWsGAR:oWsDadosCertificado
	
	U_rnConout('Vou ler o consultaDadosCertificadoPorPedido.')
	
	AAdd( aCertif, '' )
	nElem := Len( aCertif )
	aCertif[ nElem ] := {}
	aCertif[ nElem ] := Array( 27 )
	aFill( aCertif[ nElem ], '' )
	
	If oDados == NIL .OR. oDados:nPedido == NIL
		U_rnConout('________________________________________________________________________________________________')
		U_rnConout('_______________### NAO CONSEGUI CONSULTAR O consultaDadosCertificadoPorPedido ###_______________')
		U_rnConout(VarInfo( 'consultaDadosCertificadoPorPedido',  cPedidoGAR, ,.F., .F. ))
		If lVarInfo
			U_rnConout(VarInfo( 'WSIntegracaoGARERPImplService', oWsGAR, ,.F., .F. ))
			U_rnConout(VarInfo( 'consultaDadosCertificadoPorPedido - numero do pedido: ' + cPedidoGAR, oDados, ,.F., .F. ))
		Endif
		U_rnConout('________________________________________________________________________________________________')

		aCertif[ nElem, 1 ] := 'Documento nao localizado no GAR-Certificado'
		Return
	Endif
	
	cAux := U_RnNoAcen( cValToChar( oDados:cAssunto ) )
	
	aCertif[ nElem,  1 ] := 'Documento encontrado no GAR-Certificado'
	aCertif[ nElem,  2 ] := U_RnNoAcen( cValToChar( oDados:cNome 			) )
	aCertif[ nElem,  3 ] := U_RnNoAcen( cValToChar( oDados:cDataNascimento 	) )
	aCertif[ nElem,  4 ] := U_RnNoAcen( cValToChar( oDados:cEmail 			) )
	aCertif[ nElem,  5 ] := U_RnNoAcen( cValToChar( oDados:cClasse 			) )
	aCertif[ nElem,  6 ] := U_RnNoAcen( cValToChar( oDados:cValidoDe 		) )
	aCertif[ nElem,  7 ] := U_RnNoAcen( cValToChar( oDados:cValidoAte 		) )
	aCertif[ nElem,  8 ] := U_RnNoAcen( cValToChar( oDados:cNumeroSerie 	) )
	aCertif[ nElem,  9 ] := U_RnNoAcen( cValToChar( oDados:cEmissor 		) )
	aCertif[ nElem, 10 ] := cAux          
	aCertif[ nElem, 11 ] := U_RnNoAcen( cValToChar( oDados:cCpf 			) )
	aCertif[ nElem, 12 ] := U_RnNoAcen( cValToChar( oDados:cRg 				) )
	aCertif[ nElem, 13 ] := U_RnNoAcen( cValToChar( oDados:cPisPasep 		) )
	aCertif[ nElem, 14 ] := U_RnNoAcen( cValToChar( oDados:cOrgaoExpedidorRg) )
	aCertif[ nElem, 15 ] := U_RnNoAcen( cValToChar( oDados:cUf 				) )
	aCertif[ nElem, 16 ] := U_RnNoAcen( cValToChar( oDados:cCeiPF 			) )
	aCertif[ nElem, 17 ] := U_RnNoAcen( cValToChar( oDados:cRazaoSocial 	) )
	aCertif[ nElem, 18 ] := U_RnNoAcen( cValToChar( oDados:cCeiPJ 			) )
	aCertif[ nElem, 19 ] := U_RnNoAcen( cValToChar( oDados:cCnpj 			) )

	IF oDados:cStatus == NIL .OR. Empty( cValToChar( oDados:cStatus 		) )
		aCertif[ nElem, 20 ] := 'Não emitido'
	ElseIF Alltrim( cValToChar( oDados:cStatus ) ) == 'Valido'
		aCertif[ nElem, 20 ] := 'Emitido'
	Else
		aCertif[ nElem, 20 ] := U_RnNoAcen( cValToChar( oDados:cStatus ) )
	EndIF
	
	aCertif[ nElem, 21 ] := U_RnNoAcen( cValToChar( oDados:cCrtId 					) )
	aCertif[ nElem, 22 ] := U_RnNoAcen( cValToChar( oDados:nPedido 					) )
	aCertif[ nElem, 23 ] := U_RnNoAcen( cValToChar( oDados:cTituloEleitor 			) )
	aCertif[ nElem, 24 ] := U_RnNoAcen( cValToChar( oDados:cTituloEleitorMunicipio 	) )
	aCertif[ nElem, 25 ] := U_RnNoAcen( cValToChar( oDados:cTituloEleitorSecao 		) )
	aCertif[ nElem, 26 ] := U_RnNoAcen( cValToChar( oDados:cTituloEleitorUf 		) )
	aCertif[ nElem, 27 ] := U_RnNoAcen( cValToChar( oDados:cTituloEleitorZona 		) )
Return

/*/{Protheus.doc} get_Trilha
Monta Json com dados com base no Client do GAR listarTrilhasDeAuditoriaParaIdPedido
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/	
Static Function get_Trilha( cPedidoGAR, aTrilha, cStack, cThread )
	Local cAux   := ''
	Local i      := 0
	Local j      := 0
	Local nI     := 0
	Local nLoop  := 0
	Local oWsGAR
	Local oWsAud
	Local oObj

	DEFAULT cStack := ''
	
	cStack += 'GET_TRILHA()' + CRLF
	
	U_rnConout('Vou conectar no listarTrilhasDeAuditoriaParaIdPedido. ' + cThread)
	
	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:listarTrilhasDeAuditoriaParaIdPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
												 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
												 Val( cPedidoGAR ) )
	oWsAud := oWsGAR:oWsAuditoriaInfo
	
	U_rnConout('Vou ler o listarTrilhasDeAuditoriaParaIdPedido. ' + cThread)
	
	AAdd( aTrilha, '' )
	i := Len( aTrilha )
	aTrilha[ i ] := {}
	
	If (oWsAud == NIL .OR. Len( oWsAud ) == 0) .Or. Empty( cPedidoGAR )
		U_rnConout('___________________________________________________________________________________________________')
		U_rnConout('_______________### NAO CONSEGUI CONSULTAR O listarTrilhasDeAuditoriaParaIdPedido ###_______________')
		U_rnConout(VarInfo( 'listarTrilhasDeAuditoriaParaIdPedido', cPedidoGAR, ,.F., .F. ))
		If lVarInfo
			U_rnConout(VarInfo( 'WSIntegracaoGARERPImplService', oWsGAR, ,.F., .F. ))
			U_rnConout(VarInfo( 'listarTrilhasDeAuditoriaParaIdPedido - numero do pedido: ' + cPedidoGAR, oWsAud, ,.F., .F. ))
		Endif
		U_rnConout('___________________________________________________________________________________________________')

		AAdd( aTrilha[ i ], '' )
		j := Len( aTrilha[ i ] )
		aTrilha[ i, j ] := {}
		aTrilha[ i, j ] := Array( 10 )
		aFill( aTrilha[ i, j ], ' ' )
		aTrilha[ i, j,  1 ] := 'Documento nao localizado no GAR-TrilhasDeAuditoria'
		Return
	Endif
	
	// Fazer a leitura dos dados decrescente.
	For nI := Len( oWsAud ) To 1 STEP -1
		nLoop++
		
		AAdd( aTrilha[ i ], '' )
		j := Len( aTrilha[ i ] )
		aTrilha[ i, j ] := {}
		aTrilha[ i, j ] := Array( 10 )
				
		cAux := U_RnNoAcen( cValToChar( oWsAud[ nI ]:cComentario ) )
		
		aTrilha[ i, j,  1 ] := 'Documento encontrado no GAR-TrilhasDeAuditoria'
		aTrilha[ i, j,  2 ] := cPedidoGAR
		aTrilha[ i, j,  3 ] := U_RnNoAcen( cValToChar( oWsAud[ nI ]:cAcao ) )
		aTrilha[ i, j,  4 ] := cAux
		aTrilha[ i, j,  5 ] := U_RnNoAcen( cValToChar( oWsAud[ nI ]:cData ) )
		aTrilha[ i, j,  6 ] := U_RnNoAcen( cValToChar( oWsAud[ nI ]:cDescricaoAcao ) )
		
		cAux := U_RnNoAcen( cValToChar( oWsAud[ nI ]:cNomeUsuario ) )
		
		aTrilha[ i, j,  7 ] := cAux
		
		cAux := U_RnNoAcen( cValToChar( oWsAud[ nI ]:cPosto ) )
		
		aTrilha[ i, j,  8 ] := cAux
		
		aTrilha[ i, j,  9 ] := Iif( cValToChar( oWsAud[ nI ]:lClienteAcao ) == '.T.', 'true', 'false' )
		aTrilha[ i, j, 10 ] := U_RnNoAcen( cValToChar( oWsAud[ nI ]:nCPFUsuario ) )
	Next nI
Return

/*/{Protheus.doc} getNewTril
Monta Json com dados com base no Client do GAR integracao-ar.certisign.com.br/trilha/pedido/
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/	
Static Function getNewTril( cPedidoGAR, aTrilha, cStack, cThread )
	Local aHeader      := {}
	Local cAddress     := ''
	Local cAux         := ''
	Local cMV_881_08   := 'MV_881_08'
	Local cMV_881_09   := 'MV_881_09'
	Local cResponse    := ''
	Local i            := 0
	Local j            := 0
	Local k            := 0
	Local lDeserialize := .F.
	Local lGet         := .F.
	Local nElem        := 0
	Local oObj 
	Local oResponse 
	Local oRest 
	
	DEFAULT cStack := ''
	
	cStack += 'getNewTril()' + CRLF
	
	U_rnConout( 'Vou conectar no (integracao-ar.certisign.com.br/trilha/pedido/). ' + cThread )

	If .NOT. GetMv( cMV_881_08, .T. )
		CriarSX6( cMV_881_08, 'C', 'ENDERECO URL PARA CONECTAR NO NOVO SERVICO GAR TRILHA DE AUDITORIA. CSFA881', 'http://integracao-ar.certisign.com.br/' )
	Endif

	If .NOT. GetMv( cMV_881_09, .T. )
		CriarSX6( cMV_881_09, 'C', 'ENDPOINT DO NOVO SERVICO GAR TRILHA DE AUDITORIA. CSFA881', 'trilha/pedido/' )
	Endif

	cAddress  := GetMv( cMV_881_08, .F. )
	cEndPoint := GetMv( cMV_881_09, .F. )

	AAdd( aHeader, "Content-Type: application/json" )
	AAdd( aHeader, "Accept: application/json" )
	
	oRest := FWRest():New( cAddress )
	oRest:SetPath( cEndPoint + cPedidoGAR )
	
	U_rnConout( 'Vou ler (integracao-ar.certisign.com.br/trilha/pedido/). ' + cThread )
	
	AAdd( aTrilha, '' )
	nElem := Len( aTrilha )
	aTrilha[ nElem ] := {}
	
	If ( lGet := oRest:Get( aHeader ) )
		cResponse := oRest:GetResult()
		
		If ( lDeserialize := FWJSonDeserialize( cResponse, @oResponse ) )
			If ValType( oResponse ) == 'A'
				oObj := AClone( oResponse )
			Else
				oObj := {}
				AAdd( oObj, oResponse )
			Endif
			
			// Fazer a leitura dos dados em ordem crescente, pois neste novo serviço o GAR entrega nesta ordem.
			For i := 1 To Len( oObj )
				For j := 1 To Len( oObj[i]:trilhas )
					AAdd( aTrilha[nElem], '' )
					k := Len( aTrilha[nElem] )
					aTrilha[nElem,k] := {}
					aTrilha[nElem,k] := Array(10)
				
					cAux := cValToChar( oObj[i]:trilhas[j]:data )
					cAux := Dtoc( Stod( StrTran( SubStr( cAux, 1, 10 ), '-' ) ) ) + ' ' + SubStr( cAux, 12 )
					
					aTrilha[nElem,k,1]  := 'Documento encontrado no GAR-TrilhasDeAuditoria'
					aTrilha[nElem,k,2]  := U_RnNoAcen( cValToChar( oObj[i]:pedido ) )
					aTrilha[nElem,k,3]  := U_RnNoAcen( cValToChar( oObj[i]:trilhas[j]:acao ) )
					aTrilha[nElem,k,4]  := U_RnNoAcen( cValToChar( oObj[i]:trilhas[j]:comentario ) )
					aTrilha[nElem,k,5]  := cAux 
					aTrilha[nElem,k,6]  := ''
					aTrilha[nElem,k,7]  := U_RnNoAcen( cValToChar( oObj[i]:trilhas[j]:nome ) )
					aTrilha[nElem,k,8]  := U_RnNoAcen( cValToChar( oObj[i]:trilhas[j]:posto ) )
					aTrilha[nElem,k,9]  := ''
					aTrilha[nElem,k,10] := U_RnNoAcen( cValToChar( oObj[i]:trilhas[j]:cpf ) )
				Next j
			Next i
		Else
			U_rnConout( 'NAO CONSEGUI DESERIALIZAR ' + cAddress + cEndPoint + cPedidoGAR )
		Endif
	Else
		cResponse := oRest:GetLastError()
		U_rnConout( 'NAO CONSEGUI get NO ' + cAddress + cEndPoint + cPedidoGAR + ' - getLastError: [' + cResponse +']' ) 
	Endif
	
	If ( .NOT. lGet ) .OR. ( .NOT. lDeserialize )
		AAdd( aTrilha[nElem], '' )
		j := Len( aTrilha[nElem] )
		aTrilha[nElem,j] := {}
		aTrilha[nElem,j] := Array( 10 )
		aFill( aTrilha[nElem,j], '' )
		aTrilha[nElem,j,1] := 'Documento nao localizado no GAR-TrilhasDeAuditoria'
	Endif
Return

/*/{Protheus.doc} getNotFoun
Monta Json com dados vazio
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function getNotFoun( aERP, aFindDPed, aCertif, aTrilha, cStack )
	Local cMV_881_07 := 'MV_881_07'
	Local i          := 0
	Local j          := 0
	Local m          := 0
	Local nElem      := 0
	
	DEFAULT cStack := ''
	
	cStack += 'getNotFoun()' + CRLF
	
	If .NOT. GetMv( cMV_881_07, .T. )
		CriarSX6( cMV_881_07, 'L', 'HABILITAR O USO DO NOVO FLUXO DE VENDAS. F=NAO; T=SIM. CSFA881.','.F.' )
	Endif
	
	If ValType( aERP ) <> 'U'
		// HABILITAR O USO DO NOVO FLUXO DE VENDAS. F=NAO; T=SIM.
		If GetMv( cMV_881_07, .F. )
			AAdd( aERP, '' )
			nElem := Len( aERP )
			aERP[ nElem ] := {}
			aERP[ nElem ] := Array( 63 )
			aFill( aERP[ nElem ], '' )
			aERP[ nElem, 1 ] := '1-Documento nao localizado no ERP-Protheus'
			
			//SKU (+ item)
			aERP[ nElem, 60 ] := {}
			AAdd( aERP[ nElem, 60 ], '' )
			j := Len( aERP[ nElem, 60 ] )
			aERP[ nElem, 60, j ] := {}
			aERP[ nElem, 60, j ] := Array( 10 )
			aFill( aERP[ nElem, 60, j ], '' )

			aERP[ nElem, 60, j, 10 ] := {}

			AAdd( aERP[ nElem, 60, j, 10 ], ' ' )
			k := Len( aERP[ nElem, 60, j, 10 ] )
			aERP[ nElem, 60, j, 10, k ] := {}
			aERP[ nElem, 60, j, 10, k ] := Array( 13 )
			aFill( aERP[ nElem, 60, j, 10, k ], '' )
			
			aERP[ nElem, 60, j, 10, k, 9 ] := oDados[ nL ]:TEXT
			
			//Nota fiscal
			aERP[ nElem, 61 ] := {}
			AAdd( aERP[ nElem, 61 ], '' )
			m := Len( aERP[ nElem, 61 ] )
			aERP[ nElem, 61, m ] := {}
			aERP[ nElem, 61, m ] := Array( 2 )
			aFill( aERP[ nElem, 61, m ], '' )

			//Titularidade
			aERP[ nElem, 62 ] := {}
			AAdd( aERP[ nElem, 62 ], '' )
			m := Len( aERP[ nElem, 62 ] )
			aERP[ nElem, 62, m ] := {}
			aERP[ nElem, 62, m ] := Array( 4 )
			aFill( aERP[ nElem, 62, m ], '' )

			//Agendamento
			aERP[ nElem, 63 ] := {}
			AAdd( aERP[ nElem, 63 ], '' )
			m := Len( aERP[ nElem, 63 ] )
			aERP[ nElem, 63, m ] := {}
			aERP[ nElem, 63, m ] := Array( 6 )
			aFill( aERP[ nElem, 63, m ], '' )
		Else
			AAdd( aERP, '' )
			nElem := Len( aERP )
			aERP[ nElem ] := {}
			aERP[ nElem ] := Array( 65 )
			aFill( aERP[ nElem ], '' )
			aERP[ nElem, 1 ] := '1-Documento nao localizado no ERP-Protheus'
			
			aERP[ nElem, 65 ] := {}
			
			AAdd( aERP[ nElem, 65 ], ' ' )
			j := Len( aERP[ nElem, 65 ] )
			aERP[ nElem, 65, j ] := {}
			aERP[ nElem, 65, j ] := Array( 9 )
		Endif
	Endif
	
	AAdd( aFindDPed, '' )
	nElem := Len( aFindDPed )
	aFindDPed[ nElem ] := {}
	aFindDPed[ nElem ] := Array( 31 )
	aFill( aFindDPed[ nElem ], '' )
	aFindDPed[ nElem, 1 ] := 'Documento nao localizado no GAR-FindDadosPedido'
	
	AAdd( aCertif, '' )
	nElem := Len( aCertif )
	aCertif[ nElem ] := {}
	aCertif[ nElem ] := Array( 27 )
	aFill( aCertif[ nElem ], '' )
	aCertif[ nElem, 1 ] := 'Documento nao localizado no GAR-Certificado'
	
	AAdd( aTrilha, '' )
	i := Len( aTrilha )
	aTrilha[ i ] := {}	
	AAdd( aTrilha[ i ], '' )
	j := Len( aTrilha[ i ] )
	aTrilha[ i, j ] := {}
	aTrilha[ i, j ] := Array( 10 )
	aFill( aTrilha[ i, j ], ' ' )
	aTrilha[ i, j,  1 ] := 'Documento nao localizado no GAR-TrilhasDeAuditoria'
Return

//+----------------------------------------------------------------------------------------------------------------------------+
//| AS ROTINAS ABAIXO SÃO PARA EFEUTAR TESTES DAS ROTINAS AUXILIARES DO WEB SERVICE                                            |
//+----------------------------------------------------------------------------------------------------------------------------+
//| Testar a busca de dados por CPF/CNPJ ou por pedido, depende do que for informado no elemento 3 do aParam.                  |
//+----------------------------------------------------------------------------------------------------------------------------+
//| uPar1 --> é o documento a ser pesquisado, exemplo: S20004066,2,1 (S=pedido site; 20004066 nº do pedido site - G=pedido GAR)|
//| uPar2 --> é o tipo de pesquisa, exemplo: S20004066,2,1 (2=pesquisar por pedido)                                            |
//| uPar3 --> é para executar o check-out de teste, exemplo: S20004066,2,1 (1=sim usar o check-out de teste)                   |
//+----------------------------------------------------------------------------------------------------------------------------+
//| Type = 1 => Pesquisar por CPF ou CNPJ - Letras T ou F para CPF e F para CNPJ => T=titular; F=faturamento.                  |
//|        2 => Pesquisar Pedido.                                                                                              |
//+----------------------------------------------------------------------------------------------------------------------------+
//| Exemplo ==> uPar1 = T55008957880 ou 7902917                                                                                |
//|        ==> uPar2 = 1 ou 2                                                                                                  |
//+----------------------------------------------------------------------------------------------------------------------------+
/*/{Protheus.doc} My881a
Testar a busca de dados por CPF/CNPJ ou por pedido, depende do que for informado no elemento 3 do aParam.
@type function 
@author RLEG
@since 01/01/2018
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
User Function My881a( uPar1, uPar2, uPar3 )
	Local aEnv     := {}
	Local aPar     := {}
	Local aParLog  := Array( 7 )
	Local aRet     := {'',''}
	Local cEnvSrv  := GetEnvServer()
	Local cLigaLog := 'MV_880_02'
	Local cReturn  := ''
	Local cStack   := 'Pilha de chamada: My881a()' + CRLF
	Local cThread  := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
	Local lRet     := .T.
	
	DEFAULT uPar1 := 'S10458317'//'S1163'//'T15215518807'//'T02981917684'//'T36573492862'//'S9692820'
	DEFAULT uPar2 := '2'
	DEFAULT uPar3 := ''
	
	lTeste := (uPar3=='1')
		
	aPar := { '', uPar1, uPar2 }
	
	aEnv := Iif( lPostgres, {'99','01'}, {'01','02'} )
	
	RpcSetType( 3 )
	RpcSetEnv( aEnv[ 1 ], aEnv[ 2 ] )

	aPar[ 1 ] := enCode64( StaticCall( CSFA880, GETTOKEN, @cStack ) + 'Protheus.RightNow' )
	
	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif
	
	lLigaLog := GetMv( cLigaLog, .F. )
	
	If lLigaLog
		aParLog[ 1 ] := 'CONSULTARPROTHEUS'
		aParLog[ 2 ] := 'RNPROTHEUS [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', aPar, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA EXTERNO.'
		aParLog[ 5 ] := U_rnGetNow()	
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )

		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	U_rnConout('Entrei no RNProtheus.')
	
	lRet := U_validPar( aPar, @aRet )
	
	If lRet
		lRet := procConsul( aPar, @cReturn, @aRet, @cStack, cThread )
	Endif
	
	U_rnConout('Sai do RNProtheus.')
	
	If lRet
		CopyToClipboard( cReturn )
		MsgAlert( cReturn, 'teste' )
	Else
		MsgAlert( '{"codigo": ' + aRet[ 1 ] + ',"menssagem": "' + aRet[ 2 ] +'" }', 'teste' )
	Endif
	
	If lLigaLog
		aParLog[ 2 ] := 'RNPROTHEUS [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := aRet[ 1 ] + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	DelClassIntf()
Return

static function retSA1()
	aSA1 := {}
	aAdd( aSA1, SA1->A1_TPESSOA )
	//classificacaoCliente
	If SA1->( FieldPos("A1_CLASCLI") > 0 )
		aAdd( aSA1, SA1->A1_CLASCLI )
	else
		aAdd( aSA1, "Campo nao criado" )
	Endif
return

static function IsVoucher( i )
	local lVoucher := .F.
	varinfo( "oObj[i]", oObj[i] )
	conout( Type( "oObj[" + Str( i ) + "]:PAGAMENTO:FORMAPAGAMENTO" ) )
	if Type( "oObj[" + Str( i ) + "]:PAGAMENTO:FORMAPAGAMENTO" ) != "U" 
		if allTrim( oObj[i]:pagamento:formaPagamento ) == "VOUCHER"
			lVoucher := .T.
		endif
	endif
return lVoucher

static function findClient( i, cTpPesq, cTpPessoa )
	local lSA1      := .F.
	local cChaveSA1 := ""
	
	//Verifico se o pedido é do tipo voucher
	conout("### verifica se e voucher")
	
	if IsVoucher( i )
		conout("###e voucher")
		SA1->( dbSetOrder( 3 ) )
		If cTpPesq == 'T'
			//Posiciono na SA1 por CNPJ / CPF
			if Type( "oObj[" + Str( i ) + "]:ITENS[1]:titular" ) == "O"
				if cTpPessoa == 'J'
					cChaveSA1 := xFilial( 'SA1' ) + oObj[i]:ITENS[1]:titular:cnpj
				else
					cChaveSA1 := xFilial( 'SA1' ) + oObj[i]:ITENS[1]:titular:cpf 
				endif
			endif
		else
			if cTpPessoa == 'J'
				cChaveSA1 := xFilial( 'SA1' ) + oObj[i]:faturamentoPJ:cnpj
			else
				cChaveSA1 := xFilial( 'SA1' ) + oObj[i]:faturamentoPF:cpf 
			endif
		endif
		conout("chave SA1: " + cChaveSA1 )
		if !empty( cChaveSA1 )
			lSA1 := SA1->( dbSeek( cChaveSA1 ) )
			retSA1()
		endif
	endif
return lSA1

static function findCliPar( cCodigo )
	local lSA1      := .F.
	
	SA1->( dbSetOrder( 3 ) )
	if !empty( cCodigo )
		lSA1 := SA1->( dbSeek( xFilial( 'SA1' ) + cCodigo ) )
		retSA1()
	endif
return lSA1