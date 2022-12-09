#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'RESTFUL.CH'    
 
User Function _RESTPROCESS ; Return  // "dummy" function - Internal Use

//-----------------------------------------------------------------------
/*{Protheus.doc} restProcess
Classe responsavel por consumir o servico REST de qualquer aplicacao,
ou seja, podera ser consumida tanto de Fornecedor (Ex: Checkout), ou
Protheus.
Neste fonte eh responsavel somente por realizar o consumo, toda a parte
de inteligencia da regra do negocio precisara ser realizada no 
restBusiness.


@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
class restProcess from LongClassName

	data	cHttp
	data	cMethodRest
	data	cMethodAplic
	data	cJson
	data	cUser
	data	cPassword
	data	cEmpresa
	data	cFilialEmp
	data	oRestClient
	data	aHeader
	data	cCodErr 
	data	cMsgErr
	data	cCodRest
	
	method new()
	method transmitir()
	method validParam()
	method validType()
	method getInterface()
	method validaInterface()


endclass

//--------------------------------------------------------------------------------------
/*{Protheus.doc} new
Metodo de instanciacao da classe restProcess

@param	cHttp			String,	Link do Http do rest que sera consumido (Ex: https://checkout-teste.certisign.com.br).
@param	cMethodRest		String,	Nome do metodo que sera utilizado no Rest (GET,POST,PUT,DELETE).
@param	cMethodAplic	String, Nome do metodo que sera utilizado na Aplicacao do Fornecedor. 
@param	cJson			String,	Os dados em formato Json para ser enviado ao Rest. 
@param	cUser			String,	Usuario da parte da integracao.
@param	cPassword		String,	Senha da parte da integracao.
@param	cEmpresa		String, Empresa Protheus.
@param	cFilialEmp		String, Filial Protheus.
@param	oRestClient		Objeto,	Responsavel pela instanciacao do Objeto Rest do Protheus. 
@param	aHeader			Array,	Eh o cabecalho do Rest (Headers), neste array eh preciso constar tudo conforme o Rest que consumira.	 

@return nil

@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//--------------------------------------------------------------------------------------
method new() class restProcess

	::cHttp			:= ""
	::cMethodRest	:= ""
	::cMethodAplic	:= ""
	::cJson			:= ""
	::cUser			:= ""
	::cPassword		:= ""
	::cEmpresa		:= ""
	::cFilialEmp	:= ""
	::oRestClient	:= nil
	::aHeader		:= {}
	::cCodErr		:= "" 
	::cMsgErr		:= ""
	::cCodRest		:= ""
	

return nil

//-----------------------------------------------------------------------
/*{Protheus.doc} transmitir
Metodo responsavel por consumir o Rest.


@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
method transmitir() class restProcess

	local lOk 		:= .F.
	local cRetorno	:= ""
	local oObj
		
	lOk := ::validParam() 
	
	if lOk
		oRestClient := FWRest():New( ::cHttp )
		oRestClient:setPath( alltrim(::cMethodAplic) + alltrim(::cMethodRest) )
		oRestClient:SetPostParams( ::cJson )
				 
		if oRestClient:Post( ::aHeader )	
		   cRetorno := DecodeUtf8(oRestClient:GetResult())			   
		else
		   ::cCodErr	:= DecodeUtf8(oRestClient:GetLastError())
		   ::cMsgErr	:= DecodeUtf8(oRestClient:GetResult())	
		   cRetorno		:= ::cMsgErr   
		endIf
		if !empty( cRetorno )	   
			if FWJsonDeserialize( cRetorno,@oObj )
				::oRestClient := oObj
			endif
		endif	
				
	endif

return ( lOk )

//-----------------------------------------------------------------------
/*{Protheus.doc} validParam
Metodo responsavel por realizar a validacao dos parametros enviados.

@return		lValido		Retorna se todos os parametros estao preenchidos.
			
			::cCodErr	Caso tenha erro, retornara codigo abaixo.
			::cMsgErr	Caso tenha erro, retornara descricao do erro abaixo.
			{"001","Os parametros obrigatorios nao foram enviados (Http, Metodo Rest, Metodo Aplicacao, Json, Usuario, Senha, Empresa, Filial e Cabecalho)"}
			{"002","Os parametros obrigatorios nao foram enviados (Metodo Rest, Metodo Aplicacao, Json, Usuario, Senha, Empresa, Filial e Cabecalho)"}
			{"003","Os parametros obrigatorios nao foram enviados (Metodo Aplicacao, Json, Usuario, Senha, Empresa, Filial e Cabecalho)"}
			{"004","Os parametros obrigatorios nao foram enviados (Json, Usuario, Senha, Empresa, Filial e Cabecalho)"}
			{"005","Os parametros obrigatorios nao foram enviados (Usuario, Senha, Empresa, Filial e Cabecalho)"}
			{"006","Os parametros obrigatorios nao foram enviados (Senha, Empresa, Filial e Cabecalho)"}
			{"007","Os parametros obrigatorios nao foram enviados (Empresa, Filial e Cabecalho)"}
			{"008","Os parametros obrigatorios nao foram enviados (Filial e Cabecalho)"}
			{"009","O parametro obrigatorio nao foi enviado (Cabecalho)"}
			{"010","O parametro obrigatorio nao foi enviado (Http)"}
			{"011","O parametro obrigatorio nao foi enviado (Metodo Rest)"}
			{"012","O parametro obrigatorio nao foi enviado (Json)"}
			{"013","O parametro obrigatorio nao foi enviado (Usuario)"}
			{"014","O parametro obrigatorio nao foi enviado (Senha)"}
			{"015","O parametro obrigatorio nao foi enviado (Empresa)"}
			{"016","O parametro obrigatorio nao foi enviado (Filial)"}
			{"017","O parametro obrigatorio nao foi enviado (Metodo Aplicacao)"}
			
@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static method validParam() class restProcess

	local lValido := .T.
	
	if ::validType()	
		if empty( ::cHttp ) .and. empty( ::cMethodRest ) .and. empty( ::cMethodAplic ) .and. empty( ::cJson ) .and. empty( ::cUser ) .and. empty( ::cPassword ) .and. empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(1)[1] 
			::cMsgErr	:= u_restGetErro(1)[2]
			lValido		:= .F.
		elseif !empty( ::cHttp ) .and. empty( ::cMethodRest ) .and. empty( ::cMethodAplic ) .and. empty( ::cJson ) .and. empty( ::cUser ) .and. empty( ::cPassword ) .and. empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(2)[1] 
			::cMsgErr	:= u_restGetErro(2)[2]
			lValido		:= .F.
		elseif !empty( ::cHttp ) .and. !empty( ::cMethodRest ) .and. empty( ::cMethodAplic ) .and. empty( ::cJson ) .and. empty( ::cUser ) .and. empty( ::cPassword ) .and. empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(3)[1] 
			::cMsgErr	:= u_restGetErro(3)[2]
			lValido		:= .F.		
		elseif !empty( ::cHttp ) .and. !empty( ::cMethodRest ) .and. !empty( ::cMethodAplic ) .and. empty( ::cJson ) .and. empty( ::cUser ) .and. empty( ::cPassword ) .and. empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(4)[1] 
			::cMsgErr	:= u_restGetErro(4)[2]
			lValido		:= .F.			
		elseif !empty( ::cHttp ) .and. !empty( ::cMethodRest ) .and. !empty( ::cMethodAplic ) .and. !empty( ::cJson ) .and. empty( ::cUser ) .and. empty( ::cPassword ) .and. empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(5)[1] 
			::cMsgErr	:= u_restGetErro(5)[2]
			lValido		:= .F.
		elseif !empty( ::cHttp ) .and. !empty( ::cMethodRest ) .and. !empty( ::cMethodAplic ) .and. !empty( ::cJson ) .and. !empty( ::cUser ) .and. empty( ::cPassword ) .and. empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(6)[1] 
			::cMsgErr	:= u_restGetErro(6)[2]
			lValido		:= .F.	
		elseif !empty( ::cHttp ) .and. !empty( ::cMethodRest ) .and. !empty( ::cMethodAplic ) .and. !empty( ::cJson ) .and. !empty( ::cUser ) .and. !empty( ::cPassword ) .and. empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(7)[1] 
			::cMsgErr	:= u_restGetErro(7)[2]
			lValido		:= .F.				
		elseif !empty( ::cHttp ) .and. !empty( ::cMethodRest ) .and. !empty( ::cMethodAplic ) .and. !empty( ::cJson ) .and. !empty( ::cUser ) .and. !empty( ::cPassword ) .and. !empty( ::cEmpresa ) .and. empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(8)[1] 
			::cMsgErr	:= u_restGetErro(8)[2]
			lValido		:= .F.										
		elseif !empty( ::cHttp ) .and. !empty( ::cMethodRest ) .and. !empty( ::cMethodAplic ) .and. !empty( ::cJson ) .and. !empty( ::cUser ) .and. !empty( ::cPassword ) .and. !empty( ::cEmpresa ) .and. !empty( ::cFilialEmp ) .and. ( len(::aHeader) == 0 )
			::cCodErr	:= u_restGetErro(9)[1] 
			::cMsgErr	:= u_restGetErro(9)[2]
			lValido		:= .F.			
		elseif empty( ::cHttp ) 
			::cCodErr	:= u_restGetErro(10)[1] 
			::cMsgErr	:= u_restGetErro(10)[2]
			lValido		:= .F.
		elseif empty( ::cMethodRest )
			::cCodErr	:= u_restGetErro(11)[1] 
			::cMsgErr	:= u_restGetErro(11)[2]
			lValido		:= .F.		
		elseif empty( ::cJson ) 
			::cCodErr	:= u_restGetErro(12)[1] 
			::cMsgErr	:= u_restGetErro(12)[2]
			lValido		:= .F.		
		elseif empty( ::cUser ) 
			::cCodErr	:= u_restGetErro(13)[1] 
			::cMsgErr	:= u_restGetErro(13)[2]
			lValido		:= .F.		
		elseif empty( ::cPassword ) 
			::cCodErr	:= u_restGetErro(14)[1] 
			::cMsgErr	:= u_restGetErro(14)[2]
			lValido		:= .F.		
		elseif empty( ::cEmpresa ) 
			::cCodErr	:= u_restGetErro(15)[1] 
			::cMsgErr	:= u_restGetErro(15)[2]
			lValido		:= .F.	
		elseif empty( ::cFilialEmp ) 
			::cCodErr	:= u_restGetErro(16)[1] 
			::cMsgErr	:= u_restGetErro(16)[2]
			lValido		:= .F.		
		elseif empty( ::cMethodAplic ) 
			::cCodErr	:= u_restGetErro(17)[1] 
			::cMsgErr	:= u_restGetErro(17)[2]
			lValido		:= .F.					
		endif
	endif
	
return ( lValido )

//-----------------------------------------------------------------------
/*{Protheus.doc} validType
Metodo responsavel por realizar a validacao dos Tipos enviados, para 
evitar error.log.


@author	Douglas Parreja
@since	10/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static method validType() class restProcess

	local lOk	:= .F.
	
	if type( "oTemp:self:cHttp" ) <> "U" .or. ;
		 type( "oTemp:self:cMethodRest" ) <> "U" .or.;
		 	type( "oTemp:self:cMethodAplic" ) <> "U" .or.;
			 	type( "oTemp:self:cJson" ) <> "U" .or.;
			 		type( "oTemp:self:cUser" ) <> "U" .or.;
			 			type( "oTemp:self:cPassword" ) <> "U" .or.;
			 				type( "oTemp:self:cEmpresa" ) <> "U" .or.;
			 					type( "oTemp:self:cFilialEmp" ) <> "U" .or.;
			 						type( "oTemp:self:aHeader" ) <> "U"
										lOk := .T.
	endif	 								

return ( lOk )

//-----------------------------------------------------------------------
/*{Protheus.doc} getInterface
Metodo responsavel por retornar dados da Interface atraves do Codigo Rest
enviado.


@author	Douglas Parreja
@since	28/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
method getInterface() class restProcess

	local lOk 		:= .F.
	local aHeader	:= {}
	
	if ::validaInterface()
		if !empty(::cCodRest) 		
			ZZW->( dbSetOrder(1) )
			if ZZW->( dbSeek( xFilial("ZZW") + alltrim(::cCodRest) ))
	
				::cHttp			:= ZZW->ZZW_HTTP
				::cMethodAplic	:= ZZW->ZZW_PATH
				::cUser			:= ZZW->ZZW_USER
				::cPassword		:= ZZW->ZZW_SENHA
				::cEmpresa		:= ZZW->ZZW_EMPRES
				::cFilialEmp	:= ZZW->ZZW_FILEMP				
				
				//----------------------------------------------------------
				// Validacao para montagem do Cabecalho
				//----------------------------------------------------------
				aAdd(aHeader, "tenantId: "+alltrim(::cEmpresa)+','+alltrim(::cFilialEmp)+'"' )
				if !empty(ZZW->ZZW_HEADAT)
					aAdd(aHeader, "Authorization: " + alltrim(ZZW->ZZW_HEADAT) )
				elseif !empty(::cUser) .and. !empty(::cPassword)
					aAdd(aHeader, "Authorization: Basic " + encode64(alltrim(::cUser) +":"+ alltrim(::cPassword)) )
				endif
				if !empty(ZZW->ZZW_HEADCT)				
					aAdd(aHeader, "Content-Type: " + alltrim(ZZW->ZZW_HEADCT) )
				endif
				::aHeader		:= aHeader
			endif
			//----------------------------------------------------------
			// Valido se os campos principais estao preenchidos
			//----------------------------------------------------------
			if !empty(::cEmpresa) .and. !empty(::cFilialEmp) .and. !empty(::cHttp) .and. !empty(::cMethodAplic)
				lOk := .T.
			endif
		endif
	endif
	
return ( lOk )

//-----------------------------------------------------------------------
/*{Protheus.doc} validaInterface
Metodo responsavel por validar se a tabela esta aberta, caso nao esteja,
realizo a abertura da mesma.

@lRet		Retorna se conseguiu abrir a tabela.

@author	Douglas Parreja
@since	28/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static method validaInterface() class restProcess

	local lRet	:= .F.
	local nX	:= 0 
	local nCont	:= 4
	
	//----------------------------------------------------------
	// Realizo a tentativa de 4 vezes para abertura da tabela
	// caso a mesma esteja fechada, caso consegui abertura ou 
	// ja consta aberto, ja saio do loop.
	//----------------------------------------------------------
	for nX := 1 to nCont		
		if select("ZZW") > 0 
			lRet := .T.
			exit
		else
			dbSelectArea("ZZW")
			if select("ZZW") > 0 
				lRet := .T.
				exit
			endif 		
		endif 
	next nX
	
return ( lRet ) 
	




