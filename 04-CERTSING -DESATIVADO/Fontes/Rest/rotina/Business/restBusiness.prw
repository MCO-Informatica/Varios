#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH" 

#DEFINE SERVICE_DESK  	1

//-----------------------------------------------------------------------
/*{Protheus.doc} restBusiness
Funcao responsavel por realizar a regra de negocio do Rest, ou seja,
nela recebera os dados para ser criado JSON, regras e etc.
A partir disso, sera responsavel em chamar o restProcess, que eh
responsavel por consumir o servico REST conforme determinado os parametros
definido no restBusiness.

IMPORTANTE: Verificar abaixo a forma de retorno. 

@param		nProcess	Tipo da Demanda que sera realizada, ou seja,
						o Processamento para o Rest.

@return		lEnviado	Identifica se a operacao ocorreu com sucesso.
			oObj		Deixei de uma maneira Flexivel e Opcional, para 
						caso a funcao Pai que chamou esta, caso ela 
						queira tratar o retorno dos dados e nao tratar
						no restBusiness.		


@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function restBusiness( nProcess, aDadosFat )
	
	local lRet 		:= .F.
	default nProcess 	:= 0
	default aDadosFat	:= {}
	
	private aDados		:= iif( len(aDadosFat) > 0, aDadosFat, {} )
	private oTemp			
	
	if nProcess > 0
		if nProcess == SERVICE_DESK
			lRet := restServDesk()
		endif
	endif	

return { lRet, oTemp }
	
//-----------------------------------------------------------------------
/*{Protheus.doc} restServDesk
Funcao que devolve o erro e deescrição.

@param		nPos		Posicao do erro desejado no array.
						  
@return		aCodErro	Array com o codigo e descricao do erro.
						[1] - Codigo do erro
						[2] - Descricao do erro.	

@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function restServDesk()
	
	local lEnviado	:= .F.
	local aHeader	:= {}
	local cPedSite	:= retDados("pedSite")
	local cFormPgto	:= retDados("formaPagamento") 
	local nProcess	:= 0
		
	oTemp := restProcess():new()
	
	oTemp:cCodRest	:= "001" //Parametro
	if oTemp:getInterface()
		if empty(cPedSite)
			oTemp:cMethodRest := "pedidos"
			nProcess := 1
		else
			if ( !empty(cPedSite) .and. !empty(cFormPgto) ) 
				oTemp:cMethodRest	:= "pedidos/"+alltrim(cPedSite)+"/pagamento/"+alltrim(LOWER(cFormPgto))
				nProcess := 2			
			else
				oTemp:cMethodRest := "pedidos"
				nProcess := 1
			endif
		endif
		oTemp:cJson	:= jsonServDesk( nProcess )		
		if !empty(oTemp:cJson)
			lEnviado := oTemp:transmitir()
		endif		
	endif

return ( lEnviado )
//-----------------------------------------------------------------------
/*{Protheus.doc} restGetErro
Funcao que devolve o erro e deescrição.

@param		nPos		Posicao do erro desejado no array.						  
@return		aCodErro	Array com o codigo e descricao do erro.
						[1] - Codigo do erro
						[2] - Descricao do erro.	

@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function restGetErro( nPos )

	local aCodErro	:= {}
	local aCodigos	:= {}
	
	default nPos	:= 0
	
	aadd(aCodigos, {"001","Os parametros obrigatorios nao foram enviados (Http, Metodo Rest, Metodo Aplicacao, Json, Usuario, Senha, Empresa, Filial e Cabecalho)"	})
	aadd(aCodigos, {"002","Os parametros obrigatorios nao foram enviados (Metodo Rest, Metodo Aplicacao, Json, Usuario, Senha, Empresa, Filial e Cabecalho)"		})
	aadd(aCodigos, {"003","Os parametros obrigatorios nao foram enviados (Metodo Aplicacao, Json, Usuario, Senha, Empresa, Filial e Cabecalho)"						})
	aadd(aCodigos, {"004","Os parametros obrigatorios nao foram enviados (Json, Usuario, Senha, Empresa, Filial e Cabecalho)"										})
	aadd(aCodigos, {"005","Os parametros obrigatorios nao foram enviados (Usuario, Senha, Empresa, Filial e Cabecalho)"												})
	aadd(aCodigos, {"006","Os parametros obrigatorios nao foram enviados (Senha, Empresa, Filial e Cabecalho)"														})
	aadd(aCodigos, {"007","Os parametros obrigatorios nao foram enviados (Empresa, Filial e Cabecalho)"																})
	aadd(aCodigos, {"008","Os parametros obrigatorios nao foram enviados (Filial e Cabecalho)"																		})
	aadd(aCodigos, {"009","O parametro obrigatorio nao foi enviado (Cabecalho)"																						})
	aadd(aCodigos, {"010","O parametro obrigatorio nao foi enviado (Http)"																							})
	aadd(aCodigos, {"011","O parametro obrigatorio nao foi enviado (Metodo Rest)"																					})
	aadd(aCodigos, {"012","O parametro obrigatorio nao foi enviado (Json)"																							})
	aadd(aCodigos, {"013","O parametro obrigatorio nao foi enviado (Usuario)"																						})
	aadd(aCodigos, {"014","O parametro obrigatorio nao foi enviado (Senha)"																							})
	aadd(aCodigos, {"015","O parametro obrigatorio nao foi enviado (Empresa)"																						})
	aadd(aCodigos, {"016","O parametro obrigatorio nao foi enviado (Filial)"																						})
	aadd(aCodigos, {"017","O parametro obrigatorio nao foi enviado (Metodo Aplicacao)"																				})
	
	//-----------------------------------------------------
	// Adiciona no array o Codigo e Descricao do Erro 	
	//-----------------------------------------------------
	if Len(aCodigos) >= nPos
		aCodErro	:= aCodigos[nPos]
	else
		aCodErro	:= {"",""}
	endif
	
return aCodErro
//-----------------------------------------------------------------------
/*{Protheus.doc} jsonServDesk
Funcao responsavel por realizar o Json com os dados do Service-Desk.


@param		nProcess	Define qual json sera retornado
						1-Pedido Site vazio, ou seja, nova compra.
						2-Ja existe Pedido Site, enviar json para troca
						  de Forma de Pagamento.						  
@return		cString		Retorna o Json a ser enviado para o Rest.
						
	{
	    "contato": {
	        "email":"thiago.costa@certisign.com.br12312"
	    },
	    "faturamentoPJ":{
	        "estado":"SP",
	        "cnpj": "01554285000175",
	        "razaoSocial": "CERTISIGN CERTIFICADORA DIGITAL S.A.",
	        "inscricaoEstadual": "149714249119",
	        "nomeContato":"THIAGO",
	        "telefoneContato":"11991989983",
	        "email":"thiago.costa@certisign.com.br",
	        "motivoCompra":"Emissão de Nota Fiscal Eletrônica",
	        "tipoTributacao":2,
	        "endereco": {
	            "cep":"06150000",
	            "logradouro":"AV SARAH VELOSO",
	            "numero":"1200",
	            "complemento":"123",
	            "bairro":"JD VELOSO",
	            "estado":"SP",
	            "cidade":"OSASCO",
	            "fone":"11991989983"
	        }
	    },
	    "carrinho":{
	        "codigoOrigem":7,
	        "itens": [
	        {
	            "codigoProdutoGAR":"SRFA1PFHV2",
	            "grupo":"PUBLI",
	            "ar":"CRSNT",
	            "quantidade":1
	        }
	        ]},
	    "pagamento":{
	        "formaPagamento":"BOLETO",
	        "boleto": {
	            "enviaEmail":true
	        }
	    }
	}
				

@author	Douglas Parreja
@since	14/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function jsonServDesk( nProcess )

	local cString 	:= ''
	local cTipo		:= ''
	
	default nProcess := 0

	if nProcess > 0
		//---------------------------------------------------------------
		// Nova compra, ou seja, Pedido Site em branco
		//---------------------------------------------------------------
		if nProcess == 1
			cString := '{'
				cString += ' "contato": {'
					cString += '"email":"integracaosac@certisign.com.br"'
					/*cString += '"automatico":true' +','
					cString += '"email":"' + retDados("contatoEmail") +'",'
					cString += '"cpf":"' + retDados("cpfSU5") +'",'
					cString += '"nome":"' + retDados("contatoSU5") +'",'
					cString += '"fone":"' + retDados("contatoTel") +'"'*/
					cString += '},'
				cTipo := retDados("tipo")	
				if alltrim(cTipo) == "F"
					cString += '"faturamentoPF":{'				
						cString += '"cpf":"' + retDados("cpf") +'",'
						cString += '"nome":"' + retDados("nome") +'",'
						cString += '"rg":"' + retDados("rg") +'",'
						cString += '"orgaoExpedidor":"' + retDados("orgaoExpedidor") +'",'
						cString += '"sexo":"' + retDados("sexo") +'",'
						cString += '"dataNascimento":"' + retDados("dataNascimento") +'",'
						cString += '"telefoneCelular":"' + retDados("telefoneCelular") +'",'
				else
					cString += '"faturamentoPJ":{'
						cString += '"estado":"' + retDados("estado") +'",'
						cString += '"cnpj":"' + retDados("cnpj") +'",'
						cString += '"razaoSocial":"' + retDados("razaoSocial") +'",'
						cString += '"inscricaoEstadual":"' + retDados("inscricaoEstadual") +'",'
						cString += '"nomeContato":"' + retDados("nomeContato") +'",'
						cString += '"telefoneContato":"' + retDados("telefoneContato") +'",'
				endif
						cString += '"email":"' + retDados("email") +'",' 
						cString += '"motivoCompra":"' + retDados("motivoCompra") +'",'
						if alltrim(cTipo) == "J"
							cString += '"tipoTributacao":2,'
						endif
						cString += '"endereco": {'
							cString += '"cep":"' + retDados("cep") +'",'
							cString += '"logradouro":"' + retDados("logradouro") +'",'
							cString += '"numero":"' + retDados("numero") +'",'
							cString += '"complemento":"' + retDados("complemento") +'",'
							cString += '"bairro":"' + retDados("bairro") +'",'
							cString += '"estado":"' + retDados("estado") +'",'
							cString += '"cidade":"' + retDados("cidade") +'",'
							cString += '"fone":"' + retDados("fone") +'"'
							cString += '}'
					cString += '},'
				
				cString += '"carrinho":{'
					cString += '"codigoOrigem":' + iif( valtype(retDados("codigoOrigem")) == "N", alltrim(Str(retDados("codigoOrigem"))), '"'+retDados("codigoOrigem")+'"' ) +','	
					cString += '"itens": ['
					cString += '{'
					cString += '"codigo":"' + retDados("codigoProdutoGAR") +'",'
					cString += '"grupo":"' + retDados("grupo") +'",'
					cString += '"ar":"' + retDados("ar") +'",'
					cString += '"quantidade":' + iif( valtype(retDados("quantidade")) == "N", alltrim(Str(retDados("quantidade"))), '"'+retDados("quantidade")+'"' ) +','
					cString += '"renovacao":' + retDados("renovacao") //True ou False 
					cString += '}'
				cString += ']},'
				cString += '"pagamento":{'
					cString += '"formaPagamento":"' + retDados("formaPagamento") +'",'
					IF alltrim(retDados("formaPagamento")) == "BOLETO"
						cString += '"boleto": {'
						cString += '"enviaEmail":"' + iif( !empty(retDados("enviaEmail")), alltrim(retDados("enviaEmail")), 'true' ) +'"}' 
					Else
						cString += '"cartao": {'
						cString += '"enviaEmail":"' + iif( !empty(retDados("enviaEmail")), alltrim(retDados("enviaEmail")), 'true' ) +'",'
						cString += '"parcelas":"' + iif( !empty(retDados("parcelas")), alltrim(retDados("parcelas")), '1' ) + '"}'
					EndIF					
				cString += '},'
				cString += '"sac":{'
					cString += '"protocolo":"' + retDados("protocolo") +'",'
					cString += '"codigoAnalista":"' + retDados("codigoAnalista") +'",'
					cString += '"nomeAnalista":"' + retDados("nomeAnalista") +'"'
				cString += '}'				
			cString += '}'	
		//---------------------------------------------------------------
		// Pedido Site ja preenchido, com isso entendesse que eh uma 
		// troca de Forma de Pagamento
		//---------------------------------------------------------------		
		elseif nProcess == 2
			cString := '{'
	    		cString += '"enviaEmail":true'
			cString += '}'
		endif
	endif
	
return FwCutOff(cString,.T.)	

//-----------------------------------------------------------------------
/*{Protheus.doc} retDados
Funcao responsavel por retornar o conteudo conforme a posicao do Array.

@param		cPesquisa	Nome da primeira posicao do Array para posicionar
						nos dados corretos.						
												 
@return		cRet		Retorna o conteudo do array, neste caso, estara
						retornando segunda posicao do array.	

@author	Douglas Parreja
@since	14/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function retDados( cPesquisa )

	local nRet	:= 0
	local xRet := ""	//apesar de ter declarado como Xret, estou deixando default como caracter.
	
	if !empty( cPesquisa )
		nRet := ( ascan( aDados, {|x| x[1] == alltrim(cPesquisa)}) ) 
		if nRet > 0
			if restValidDados( nRet )
				//---------------------------------------------------------------
				// Nao valido e-mail no caracter especial pq retirara o @arroba
				//---------------------------------------------------------------
				if ( alltrim(aDados[nRet][1]) == "email" .or. alltrim(aDados[nRet][1]) == "contatoEmail";
						.or. ( valtype(aDados[nRet][2]) == "N" ) )
					xRet := aDados[nRet][2]
				//---------------------------------------------------------------
				// Validacao para Data Nascimento - 04/04/2017
				// O legado foi desenvolvido para constar ddmmaaaa, porem, agora
				// com o servico REST eh preciso enviar dd/mm/aaaa.
				// Conversei com o Thiago se era possivel ele realizar alteracao
				// do lado do Java, porem ele informou que nao eh possivel pq
				// foi alterado e mantido um padrao para outras areas consumirem.
				//---------------------------------------------------------------
				elseif ( alltrim(aDados[nRet][1]) == "dataNascimento" )
					if len(aDados[nRet][2]) == 8 .or. len(aDados[nRet][2]) == 6
						xRet := substr(aDados[nRet][2],1, 2) //Dia
						xRet += "/"
						xRet += substr(aDados[nRet][2],3, 2) //Mes
						xRet += "/"
						if len(aDados[nRet][2]) == 8
							xRet += substr(aDados[nRet][2],5, 4) //Ano
						elseif len(aDados[nRet][2]) == 6
							xRet += substr(aDados[nRet][2],5, 2) //Ano
						endif
					else
						xRet := u_removeCaracEspecial( aDados[nRet][2] )
					endif
				else
					xRet := u_removeCaracEspecial( aDados[nRet][2] )
				endif	
			endif			
		endif			
	endif
	
return xRet

//-----------------------------------------------------------------------
/*{Protheus.doc} restValidDados
Funcao que valida o Array.

@param		nPos		Posicao do Array a ser validado.						 
@return		lRet		Retorna se esta apto a continuar com o Processo.

@author	Douglas Parreja
@since	14/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function restValidDados( nPos )
	
	local lRet 	:= .F.
	default nPos	:= 0
	
	if nPos > 0
		if ( type("aDados")<>"U" )
			if ( len(aDados) > 0 )
				if ( len(aDados[nPos]) > 0 )
					if ( len(aDados[nPos]) > 1 )
						lRet := .T.
					endif
				endif
			endif
		endif
	endif
		
return lRet