#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"  

//-----------------------------------------------------------------------
/*{Protheus.doc} restViewSchema
Funcao que monta tela com tratamento de erro de schema.

@param	aDadosTit		Array com dados Titulo.
		aDatSacado		Array com dados Sacado.
		aDeducao		Array com dados Impostos.

@return lGeraShopLine	Retorna se pode gerar ShopLine Sim ou Nao.	

@author	Douglas Parreja
@since	29/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function restViewSchema( aDadosRest, lExibeTela )

	local lGeraShopLine		:= .T.  
	local cErro				:= ""
	  
	default aDadosRest		:= {}
	default lExibeTela		:= .T.
	default lExibeTela		:= .T.    
		
	private aDados			:= iif( len(aDadosRest) > 0, aDadosRest, {} ) 
		
	if validArGeral()			
		if lExibeTela	
			cErro := schemaTela()
		endif			
	else
		lGeraShopLine := .F.		 
	endif

return {lGeraShopLine, cErro}

//-----------------------------------------------------------------------
/*{Protheus.doc} viewSchemaMsg
Funcao que monta tela com tratamento de erro de schema.

@author	Douglas Parreja
@since	29/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function schemaTela()

	local cCodErro		:= "" 
	local cDesc			:= ""  
	local cString		:= ""
	local oTree     
	local lIsSame		:= .F.
	local nX 			:= 0
	local aDadosBol		:= {}     
		
	if len( aDados ) > 0
			
		DEFINE MSDIALOG oDlg TITLE "Validação dos dados enviados para ShopLine Itaú" FROM 0,0 TO 300,800 PIXEL  
		
		@ 000, 000 MSPANEL oPanelLeft OF oDlg SIZE 085, 000
		oPanelLeft:Align := CONTROL_ALIGN_LEFT
		
		@ 000, 000 MSPANEL oPanelRight OF oDlg SIZE 000, 000
		oPanelRight:Align := CONTROL_ALIGN_ALLCLIENT
		
		oTree := xTree():New(000,000,000,000,oPanelLeft,,,)
		oTree:Align := CONTROL_ALIGN_ALLCLIENT  
		
		oTree:AddTree("Dados do Boleto",,,"PARENT",,,) //"Mensagens"
		
		for nX := 1 to len(aDados)
		
			cCargo 		:= "Mensagem " + alltrim(Str(nX))			
			oMessage	:= "Mensagem " + alltrim(Str(nX))
		
			if ( oTree:TreeSeek(cCargo) )
				oTree:addTreeItem("Possibilidade","BPMSEDT3.png",cCargo+"|"+AllTrim(Str(nX)),{ || SchemaRefreshTree( @cCodErro, @cDesc, oTree ), oCodErro:Refresh(), oDesc:Refresh() }) 
			else       
				if ( nX > 1 )
					oTree:EndTree()
				endIf              
				
				oTree:AddTree(cCargo,"f10_verm.png","f10_verm.png",cCargo,,,,,)  
				oTree:addTreeItem("Possibilidade","BPMSEDT3.png",cCargo+"|"+AllTrim(Str(nX)),{ || SchemaRefreshTree( @cCodErro, @cDesc, oTree ), oCodErro:Refresh(), oDesc:Refresh() }) 	
			endIf
		
		next nX 
		
		oTree:EndTree()
		
		DEFINE FONT oFont BOLD
		
		@ 005, 010 SAY oSay PROMPT "Na coluna esquerda 'Dados do Boleto', clique no sinal(+) do 'Item' que deseja visualizar, será carregado o" OF oPanelRight PIXEL FONT oFont COLOR CLR_RED SIZE 350, 015 
		@ 013, 010 SAY oSay PROMPT "subitem com o nome 'Possibilidade', clique em 'Possibilidade' para ser populado os campos abaixo:" OF oPanelRight PIXEL FONT oFont COLOR CLR_RED SIZE 350, 015 
			
		@ 028, 010 SAY oSay PROMPT "Código :" OF oPanelRight PIXEL FONT oFont SIZE 040, 015 //"Código Erro:"
		@ 028, 034 SAY oCodErro PROMPT cCodErro OF oPanelRight PIXEL SIZE 350, 015
			
		@ 043, 010 SAY oSay PROMPT "Descrição :" OF oPanelRight PIXEL FONT oFont SIZE 040, 015 //Descrição:
		@ 043, 042 SAY oDesc PROMPT cDesc OF oPanelRight PIXEL SIZE 350, 015				
		
		@ 133, 097 BUTTON oBtn PROMPT "Gerar Log" SIZE 030, 010 ACTION schemaLog( aDados ) OF oPanelRight PIXEL //"Gerar Log"
		@ 133, 130 BUTTON oBtn PROMPT "Sair" SIZE 028, 010 ACTION  schemaRetErro( aDados, @cString ) OF oPanelRight PIXEL //"Sair"
			
		ACTIVATE MSDIALOG oDlg CENTERED
	
	endif

return cString

//-----------------------------------------------------------------------
/*{Protheus.doc} schemaRefreshTree
Função que atualiza as informacoes da tela de schema.


@param	@cCodErro		Codigo Erro restornado REST
		@cDesc		 	Descrição da tag
		oTree		 	Objeto com a árvore (XTree) de possibilidades
					
@return .T.

@author Douglas Parreja
@since	17/02/2017
@version 11.8				
/*/
//-----------------------------------------------------------------------
static function schemaRefreshTree( cCodErro, cDesc, oTree )   

	Local nPos	:= 0
	
	nPos := Val(Substr(oTree:GetCargo(),At("|",oTree:GetCargo())+1))
	
	if valtype( nPos ) == "N"
		if validArray( nPos )
			cCodErro	:= iif( type("aDados[nPos]:CODIGO") == "N", alltrim(Str(aDados[nPos]:CODIGO)), aDados[nPos]:CODIGO ) 
			cDesc		:= aDados[nPos]:MENSAGEM			
		endif			
	endif	

return .T. 

//-----------------------------------------------------------------------
/*{Protheus.doc} validArGeral
Funcao responsavel por validar Array se esta completo para evitar
incidente fora do padrao.

@param	aDados			Array com dados da mensagem retorno REST.
		
@return lOk				Retorna se esta Ok ou Nao.			

@author Douglas Parreja
@since	29/03/2017
@version 11.8				
/*/
//-----------------------------------------------------------------------
static function validArGeral()

	local lRet		:= .F.	
	
	if (type( "aDados" ) <> "U")
		if (type( "aDados" ) == "A") 
			if (len( aDados ) > 0)
				lRet := .T.
			endif		
		endif
	endif	

return lRet

//-----------------------------------------------------------------------
/*{Protheus.doc} validArray
Funcao responsavel por validar Array se esta completo para evitar
incidente fora do padrao.

@param	aMessage		Array com todas as tags e suas mensagens
@return lOk				Retorna se esta Ok ou Nao.			

@author Douglas Parreja
@since	29/03/2017
@version 11.8				
/*/
//-----------------------------------------------------------------------
static function validArray( nPos )

	local lOk		:= .F.	
	default nPos	:= 0
	
	if len( aDados ) > 0
		if nPos > 0
			if type("aDados["+alltrim(str(nPos))+"]:CODIGO") <> "U"
				if type("aDados["+alltrim(str(nPos))+"]:MENSAGEM") <> "U"							
					lOk := .T.
				endif
			endif
		endif							
	endif

return lOk

//-----------------------------------------------------------------------
/*{Protheus.doc} schemaLog
Funcao criara em disco um arquivo xml Log dos erros de schema.

@param	aMessage	Array com todas as tags e suas mensagens   

@author Douglas Parreja
@since	17/02/2017
@version 11.8	
/*/
//-----------------------------------------------------------------------
static function schemaLog( aMessage )

	local cDir		:= cGetFile( "*.xml", "Validacao Schema Agend Externo"+" XML", 1, "C:\", .T., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ),, .T. )
	local cFile		:= "schema_wsREST_"+DtoS(Date())+StrTran(Time(),":","")+".xml"
	local nX		:= 0
	local nHandle 
	
	default aMessage 	:= {} 
		
	if ( !empty(cDir) )     
	
		nHandle := FCreate(cDir+cFile) 
		
		if ( nHandle > 0 )  
		
			FWrite(nHandle,"<schemalog>") 
			cString := "<schemalog>"
													
			for nX := 1 to len( aMessage ) 
			
				//-----------------------------------------------------
				// Montagem do Arquivo
				//-----------------------------------------------------
				FWrite(nHandle,"<possibilidade item='" + allTrim(Str(nX)) + "'>")
				FWrite(nHandle,"<codigo>")
				FWrite(nHandle,u_removeCaracEspecial(alltrim(Str(aMessage[nX]:CODIGO))) )
				FWrite(nHandle,"</codigo>")				 
				FWrite(nHandle,"<descricao>")
				FWrite(nHandle,u_removeCaracEspecial(aMessage[nX]:MENSAGEM))
				FWrite(nHandle,"</descricao>")														
				FWrite(nHandle,"</possibilidade>")    
				
				//-----------------------------------------------------
				// Montagem da String de retorno
				//-----------------------------------------------------
				cString += "<possibilidade item='" + allTrim(Str(nX)) + "'>"
				cString += "<codigo>"
				cString += u_removeCaracEspecial(alltrim(Str(aMessage[nX]:CODIGO))) 
				cString += "</codigo>"				 
				cString += "<descricao>"
				cString += u_removeCaracEspecial(aMessage[nX]:MENSAGEM)
				cString += "</descricao>"						
				cString += "</possibilidade>"    
				
			next nX
			
			FWrite(nHandle,"</schemalog>")
			FClose(nHandle)     
			
			if ( MsgYesNo( "Arquivo de LOG gerado com sucesso em: " + cDir + cFile + CRLF + "Deseja abrir a pasta onde o arquivo foi gerado?" ) ) 
				ShellExecute ( "OPEN", cDir, "", cDir, 1 )
			endIf
		
		else
			msgInfo("Não foi possível criar o arquivo.")
		endIf
	
	else
		msgInfo("Deve ser informado um diretório para ser salvo o arquivo de LOG.")
	endIf

return 


//-----------------------------------------------------------------------
/*{Protheus.doc} schemaRetErro
Funcao retornara em formato de string o erro exibido no log para caso
o desenvolvedor queira gravar em algum campo.

@param	aMessage	Array com todas as tags e suas mensagens.
@param	cString		Retornara a String do erro exibido no Schema.   

@return	oDlg:end()	Fecha a tela de validacao de schema

@author Douglas Parreja
@since	31/03/2017
@version 11.8	
/*/
//-----------------------------------------------------------------------
static function schemaRetErro( aMessage, cString )

	local nX			:= 0
	
	default aMessage 	:= {}
	default cString	:= "" 
		
		
	if len(aMessage) > 0   			
		//-----------------------------------------------------
		// Montagem da String de retorno
		//-----------------------------------------------------
		cString := "<schemalog>" + CRLF			
											
		for nX := 1 to len( aMessage ) 					
			cString += space(10)+"<possibilidade item='" + allTrim(Str(nX)) + "'>" + CRLF
			cString += space(20)+"<codigo>"
			cString += u_removeCaracEspecial(alltrim(Str(aMessage[nX]:CODIGO)))
			cString += "</codigo>" + CRLF				 
			cString += space(20)+"<descricao>"
			cString += u_removeCaracEspecial(aMessage[nX]:MENSAGEM) 
			cString += "</descricao>" + CRLF						
			cString += space(10)+"</possibilidade>" + CRLF    			
		next nX
		
		cString += "</schemalog>" 			
	else
		u_autoMsg("SchemaREST", , "Nao foi possivel retornar a String com erro devido que no Array nao possui dados.")
	endIf
	
return oDlg:end()