#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"      

#DEFINE ITAU  	'2'

//-----------------------------------------------------------------------
/*/{Protheus.doc} boletoReg
Funcao responsavel por realizar a geracao link do Banco para a geracao
do Boleto registrado.



@author	Douglas Parreja
@since	13/12/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function boletoReg( aDados1, aDados2, aDados3 )
	
	local cMVBolReg		:= "MV_BOLETRG" 
	local cRetLink		:= ""          
	
	private aDadosTit 	:= {}
	private aDatSacado	:= {} 
	private aImpostoTit	:= {}

	default aDados1	:= {}
	default aDados2	:= {} 
	default aDados3 := {}
	
	if ( (len( aDados1 ) > 0) .and. (len( aDados2 ) > 0) .and. (len( aDados3 ) > 0) )
	
		//----------------------------------------------------------------
		//Atribuindo na Private pq utilizarei em varios momentos
		//----------------------------------------------------------------
		aDadosTit  	:= aDados1
		aDatSacado 	:= aDados2    
		aImpostoTit	:= aDados3		
		
		if csValidParam()
			//----------------------------------------------------------------
			// 1-Boleto sem registro / 2-Link Boleto Registrado ITAU
			//----------------------------------------------------------------
			cMVBolReg := alltrim( getNewPar(cMVBolReg, "2") ) 
			//----------------------------------------------------------------
			// Funcao para gerar o link Boleto Registrado 
			//----------------------------------------------------------------  
			cRetLink := csBolControl( cMVBolReg )         
		endif
	endif

return cRetLink

//-----------------------------------------------------------------------
/*/{Protheus.doc} csValidParam
Funcao que verifica se consta/configurado parametros e tabela.

@return	lOk		Retorna se o ambiente esta preparado para prosseguir.

@author	Douglas Parreja
@since	12/12/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csValidParam()

	local lOk		:= .T.
	local cBarra	:= IIf(IsSrvUnix(),'/','\')
	local cSystem	:= cBarra + 'system' + cBarra
	local cExec		:= "Boleto Registrado"
	local cMVDados	:= ""        
	local cMVBolReg	:= "MV_BOLETRG" 
	local cMVLink	:= "MV_LINKAGE"
	
	//-------------------------------------------------------------------------------------------
	// MV_BOLETRG - Define se a operacao do Agendamento Externo sera atraves de Boleto Registrado
	// 1-Certisign (Legado) / 2-Itau. 
	// Criado desta maneira para caso no futuro tenha outros Bancos, somente inserir e gerar o 
	// JSON.
	//-------------------------------------------------------------------------------------------			
	if !GetMV( cMVBolReg, .T. )
		CriarSX6( cMVBolReg, 'C', 'Boleto Registrado. 1-Certisign(legado), 2-Itau', "2" )
		u_autoMsg(cExec, , "criado parametro MV_BOLETRG - Boleto Registrado")
	endif
	cMVBolReg := GetMV(cMVBolReg) 
	if Empty( cMVBolReg )
		u_autoMsg(cExec, ,'Nao eh possivel continuar. Parametro '+alltrim(cMVBolReg)+' sem conteudo.' )
		lOk := .F.
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_LINKAGE - Define o Link do ShopLine para geracao do Boleto Registrado.	
	//-------------------------------------------------------------------------------------------			
	if !GetMV( cMVLink, .T. )
		CriarSX6( cMVLink, 'C', 'Agend. Externo - Link ShopLine (Bol.Reg.)', "" )
		u_autoMsg(cExec, , "criado parametro MV_LINKAGE - Responsavel pelo direcionamento do ShopLine.")    
	else
		cMVLink := GetMV(cMVLink) 
		if Empty( cMVLink )
			u_autoMsg(cExec, ,'Nao eh possivel continuar. Parametro '+alltrim(cMVLink)+' sem conteudo.' )
			msgAlert("Por favor, entre em contato com Sistemas Corporativos e solicite que preencham o parâmetro MV_LINKAGE")
			lOk := .F.
		endif
	endif
		
return lOk

//-----------------------------------------------------------------------
/*/{Protheus.doc} csBolControl
Funcao que realiza o controle das geracoes dos Links a serem gerados,
ou seja, preparado desta maneira para caso tenha outros bancos a serem
utilizados, somente passar como parametro.

@param	cBanco	Qual Banco sera realizado o link Boleto Registrado

@author	Douglas Parreja
@since	13/12/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csBolControl( cBanco )
	
	local cRet		:= ""  
	local cExec		:= "Boleto Registrado"
	default cBanco := ""
	
	if !empty( cBanco )
		if alltrim(cBanco) == ITAU
			cRet := csBolITAU()
		else
			u_autoMsg(cExec, , "Parametro MV_BOLETRG - Consta com a informacao -> " + alltrim(cBanco) + " neste caso eh preciso refazer o processo. Exit!")
			return
		endif		
	endif
	
return cRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} csBolITAU
Funcao Pai para a geracao do Link.

@author	Douglas Parreja
@since	13/12/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csBolITAU()

	local cString 	:= ""
	local cMsgCrip	:= ""  
	local cMVLink	:= alltrim(getMv("MV_LINKAGE"))

	cString		:= csBolJSON()
	cMsgCrip	:= csCriptografia( cString )  
	if !empty( cMsgCrip )  
		csLink( cMVLink+cMsgCrip )   
	else
		conout(cMsgCrip)
		alert("Nao executou direto o Shell Execute" + cMVLink+cMsgCrip )		
	endif
			
return (cMVLink+cMsgCrip)

//-------------------------------------------------------------------
/*/{Protheus.doc} csBolJSON
Funcao responsavel gerar o JSON com os Dados do Boleto.

-----------------------------------
 Exemplo JSON 
----------------------------------- 

DadosBoleto : {
   "codEmp": "0001", 				//(java codificar)
   "pedido": "99900091",
   "valor": "1500,00",
   "chave": "ABCDEFGHIJKLMNOPQ", 	//(java codificar)
   "nomeSacado": "nomeSacado",
   "codigoInscricao": "01", 
   "numeroInscricao": "00000000000", 
   "enderecoSacado": "enderecoSacado",
   "bairroSacado": "bairroSacado",
   "cepSacado": "00000000",
   "cidadeSacado": "cidadeSacado",
   "estadoSacado": "SP",
   "dataVencimento": "00/00/0000",
   "urlRetorna": "/qualquerurl.com.br", //(java codificar)
   "obsAdicional1": "",
   "obsAdicional2": "",
   "obsAdicional3": "",
   "obsAdicional4": "",
   "observacao": ""
}


@return cAlias		Alias da query executada

@author  Douglas Parreja
@since   13/12/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csBolJSON()

	local cString 	:= ""         
	local cValor	:= ""
			
	if ( (len( aDadosTit ) > 0) .and. (len( aDatSacado ) > 0) .and. (len( aImpostoTit ) > 0) )
						
		cString += 'DadosBoleto : {'
		cString += '"codEmp": "",' 		//(java codificar)
		if type( "aDadosTit[1]" ) <> "U"
			cString += '"pedido"' 		+ ":" + '"'+  iif( valtype( aDadosTit[1] ) == "N",  iif( aDadosTit[1]>0 , substr(alltrim(str(aDadosTit[1])),1,8) , "" )  ,iif( len(aDadosTit[1])>0 , substr(alltrim(aDadosTit[1]),1,8) , "" )) +'",'
		endif
		cValor := csCalcValor()                          
		if type( cValor ) <> "U"
			cString += '"valor"'		+ ":" + '"'+  iif( valtype( cValor ) == "C", cValor, "") +'",'				                          
		endif
		/*if type( "aDadosTit[5]" ) <> "U"
			cString += '"valor"' 			+ ":" + '"'+ iif( valtype( aDadosTit[5]  ) == "N",  iif( aDadosTit[5]>0 , alltrim(str(aDadosTit[5])) , "" )  ,iif( len(aDadosTit[5])>0 , alltrim(aDadosTit[5]) , "" )) +'",'  
		endif*/
		cString += '"chave": "",' 		//(java codificar)
		if type( "aDatSacado[1]" ) <> "U"
			cString += '"nomeSacado"' 		+ ":" + '"'+ iif( valtype( aDatSacado[1] ) == "N",  iif( aDatSacado[1]>0, substr(alltrim(str(aDatSacado[1])),1,30) , "" )  ,iif( len(aDatSacado[1])>0, substr(alltrim(aDatSacado[1]),1,30), "") ) +'",' 
		endif
		if type( "aDatSacado[3]" ) <> "U"		
			cString += '"codigoInscricao"' 	+ ":" + '"'+ iif( len(aDatSacado[8])>0, iif(alltrim(aDatSacado[8]) == "F", "01", "02"), "") +'",'
		endif
		if type( "aDatSacado[7]" ) <> "U"
			cString += '"numeroInscricao"' 	+ ":" + '"'+ iif( valtype( aDatSacado[7] ) == "N",  iif( aDatSacado[7]>0, substr(alltrim(str(aDatSacado[7])),1,14) , "" )  ,iif( len(aDatSacado[7])>0, substr(alltrim(aDatSacado[7]),1,14) , "") ) +'",'
		endif
		if type( "aDatSacado[3]" ) <> "U"
			cString += '"enderecoSacado"' 	+ ":" + '"'+ iif( valtype( aDatSacado[3] ) == "N",  iif( aDatSacado[3]>0, substr(alltrim(str(aDatSacado[3])),1,40) , "" )  ,iif( len(aDatSacado[3])>0, alltrim(substr(aDatSacado[3],1,40)), "") ) +'",' 
		endif
		if type( "aDatSacado[9]" ) <> "U"
			cString += '"bairroSacado"'		+ ":" + '"'+ iif( valtype( aDatSacado[9] ) == "N",  iif( aDatSacado[9]>0, substr(alltrim(str(aDatSacado[9])),1,15) , "" )  ,iif( len(aDatSacado[9])>0, substr(alltrim(aDatSacado[9]),1,15) , "") ) +'",' 
		endif
		if type( "aDatSacado[10]" ) <> "U"
			cString += '"numeroSacado"'		+ ":" + '"'+ iif( valtype( aDatSacado[10] ) == "N",  iif( aDatSacado[10]>0, substr(alltrim(str(aDatSacado[10])),1,10) , "" )  ,iif( len(aDatSacado[10])>0, substr(alltrim(aDatSacado[10]),1,10) , "") ) +'",' 
		endif
		if type( "aDatSacado[11]" ) <> "U"
			cString += '"complementoSacado"' 	+ ":" + ' "'+ iif( valtype( aDatSacado[11] ) == "N",  iif( aDatSacado[11]>0, substr(alltrim(str(aDatSacado[11])),1,40) , "" )  ,iif( len(aDatSacado[11])>0, alltrim(substr(aDatSacado[11],1,40)), "") ) +'",' 
		endif
		if type( "aDatSacado[6]" ) <> "U"
			cString += '"cepSacado"'		+ ":" + '"'+ iif( valtype( aDatSacado[6] ) == "N",  iif( aDatSacado[6]>0, alltrim(str(aDatSacado[6])), "" )  ,iif( len(aDatSacado[6])>0, alltrim(aDatSacado[6]), "") ) +'",'
		endif
		if type( "aDatSacado[4]" ) <> "U"
			cString += '"cidadeSacado"'		+ ":" + '"'+ iif( valtype( aDatSacado[4] ) == "N",  iif( aDatSacado[4]>0, substr(alltrim(str(aDatSacado[4])),1,15) , "" )  ,iif( len(aDatSacado[4])>0, substr(alltrim(aDatSacado[4]),1,15) , "") ) +'",'
		endif
		if type( "aDatSacado[5]" ) <> "U"
			cString += '"estadoSacado"'		+ ":" + '"'+ iif( valtype( aDatSacado[5] ) == "N",  iif( aDatSacado[5]>0, alltrim(str(aDatSacado[5])), "" )  ,iif( len(aDatSacado[5])>0, alltrim(aDatSacado[5]), "") ) +'",'
		endif
		if type( "aDadosTit[4]" ) <> "U"
			cString += '"dataVencimento"'	+ ":" + '"'+ iif( valtype( aDadosTit[4]  ) == "D",  iif( !empty(aDadosTit[4]) , alltrim(Dtos(aDadosTit[4])), "" )  ,iif( len(aDadosTit[4])>0 , alltrim(aDadosTit[4]) , "") ) +'",'
		endif
		cString += '"urlRetorna" : "",' //(java codificar)
		cString += '"obsAdicional1" : "DEMONSTRATIVO: Valor Bruto R$ ' + alltrim(Transform(aImpostoTit[1], "@E 9,999,999.99")) +'",'	//	+ ":" + '"'+ iif( valtype( aImpostoTit[1]  ) == "C",  iif( !empty(aDadosTit[4]) , alltrim(Dtos(aDadosTit[4])), "" )  ,iif( len(aDadosTit[4])>0 , alltrim(aDadosTit[4]) , "") ) +'",'
		cString += '"obsAdicional2":  "Deducoes ' + alltrim(aImpostoTit[4]) + "|" + alltrim(aImpostoTit[5]) + "|" + alltrim(aImpostoTit[6]) + "|" + alltrim(aImpostoTit[7]) + '",' //"teste2",'
		cString += '"obsAdicional3":  "Valor Liquido R$ ' + alltrim(Transform(aImpostoTit[3], "@E 9,999,999.99")) +'", ' 
		cString += '"observacao":  "3" ' 
		cString += '}'			
		
		MemoWrite("C:\Data\json\boleto"+DTOS(DAte())+".json",cString)
		
	endif

return	cString

//-------------------------------------------------------------------
/*/{Protheus.doc} csCriptografia
Funcao responsavel por realizar a Criptografia da URL

@param	cMsg		String da URL.
@return cRet		Retorno da String Criptografado.


@author  Douglas Parreja
@since   15/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------	
static function csCriptografia( cMsg )

	default cMsg := ""

	if !empty( cMsg )
		cRet := Encode64( cMsg )
		//------------------------------
		// Funcao Escape URL Encoding 
		//------------------------------
		cRet := Escape( cRet )
	endif
	
return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} csLink
Funcao responsavel por criar Tela de log com o link gerado.

@param	cLink	Link do checkout que foi gerado e sera exibido na tela.


@author  Douglas Parreja
@since   13/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csLink( cLink )
	
	default cLink := ""
	if !empty( cLink )
		ShellExecute( "Open", cLink , "", "C:\", 1 )
	endif
	
return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} csCalcValor
Funcao responsavel calcular o valor Liquido do Boleto

@param	cLink	Link do checkout que foi gerado e sera exibido na tela.


@author  Douglas Parreja
@since   13/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csCalcValor()
              
	local nValBruto	:= 0
	local nValLiq	:= 0
	local cRet 		:= ""
	local lValid	:= .F.
	//-----------------------------------------
	// Total Liquido = Valor Titulo - Deducao
	//-----------------------------------------
	if type( "aImpostoTit[1]" ) <> "U" .and. type( "aImpostoTit[2]" ) <> "U" 	
		nValLiq := iif( valtype(aImpostoTit[1]) == "N",  iif( valtype(aImpostoTit[2]) == "N" , aImpostoTit[1] - aImpostoTit[2] , 0)  , 0 )
	endif      
	//------------------------------
	// Validacao
	//------------------------------
	if type( "aImpostoTit[3]" ) <> "U"
		lValid := iif( valtype(aImpostoTit[3]) == "N",  aImpostoTit[3] == nValLiq , 0 )
		if lValid                               
			cRet := AllTrim(Str(nValLiq,,2))
		else
		    cRet := AllTrim(Str(aImpostoTit[3],,2))
		endif
	endif
	
	cRet := StrTran(cRet,".",",")
		
return cRet 

//-------------------------------------------------------------------
/*/{Protheus.doc} csGravaZZV
Funcao responsavel por Gravar o Registro na tabela ZZV.
Tabela que mantera o Historico de todos os boletos gerados para a 
mesma Ordem de Servico.

@param	cOrdemServ		Numero da Ordem de Servio.		
		cNumControle	Numero Controle do novo Boleto Gerado.
		dDataVenc		Nova Data de Vencimento.
		cLinkNovo		Link do checkout que foi gerado.
		lReenvBol		.T. Significa que nao consta registro na ZZV 
						    e consta na PA0, processo antigo.
						    Criado para que ao gerar novo Boleto e caso
						    nao tenha registro na ZZV, eu incluo um novo
						    para manter o historico e gero o posterior.
						.F. Gerara status a partir do Relock.

@author  Douglas Parreja
@since   31/01/2016
@version 11.8
/*/
//-------------------------------------------------------------------
user function csGravaZZV( cOrdemServ, cNumControle, dDataVen, cLinkNovo, lReenvBol  )	

	local lRet				:= .F.	
	local cUsuarioNome		:= logusername()
	local cUsuarioComp		:= "Sistema integrou Automaticamente" 
	default cOrdemServ 		:= ""
	default cNumControle	:= "" 
	default cLinkNovo		:= ""
	default dDataVen		:= dDataBase
	default lReenvBol		:= .F.
		
	if u_csChkTabela( "ZZV" )
																	
		dbSelectArea("ZZV")
		ZZV->(dbSetOrder(2)) //ZZV_FILIAL+ZZV_CONTRO

		if ZZV->( dbSeek( xFilial("ZZV") + cNumControle ))
			lReclock := .F.
		else
			lReclock := .T.
		endif

		ZZV->( reclock( "ZZV", lReclock ) )
		ZZV->ZZV_FILIAL	:= xFilial("ZZV")
		ZZV->ZZV_OS		:= cOrdemServ
		ZZV->ZZV_CONTRO	:= cNumControle
		ZZV->ZZV_DTVENC	:= dDataVen
		ZZV->ZZV_LINK	:= cLinkNovo 
		//------------------------------------------------
		// ZZV_STATUS
		//
		// Variavel lReenvBol	
		// .T. Significa que nao consta registro na ZZV 
		//	    e consta na PA0, processo antigo.
		//	    Criado para que ao gerar novo Boleto e caso
		//	    nao tenha registro na ZZV, eu incluo um novo
		//	    para manter o historico e gero o posterior.
		// .F. Gerara status a partir do Relock.
		// 
		//  1. Inclusao
		//  2. Gerado novamente
		//  3. Sistema realizou inclusao Automaticamente
		//------------------------------------------------
		ZZV->ZZV_STATUS	:= iif( lReenvBol, "3",iif( lReclock, "1", "2" )) 
		ZZV->ZZV_USER	:= "User: " + iif(lReenvBol,cUsuarioComp,cUsuarioNome) + " | " + "Data: " + dtoc(Date()) + " - " + Time() + " | " + "IPClient: " + getClientIP()
		ZZV->( MsUnLock() )
	 	lRet := .T.
	endif

return lRet


