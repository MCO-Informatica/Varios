#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

//-----------------------------------------------------------------------
/*{Protheus.doc} restInterface
Funcao responsavel por exibir a rotina de Integracao REST.
Realizado esta rotina para que fique uma comunicacao padrao para 
qualquer comunicacao via REST.


@author	Douglas Parreja
@since	21/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function restInterface()

	private cCadastro	:= "Integration REST Services"
	private aRotina 	:= { {"Pesquisar"	,"AxPesqui"		,0,1} ,;
			             {"Visualizar"	,"u_restWizard(2)"	,0,2} ,;
			             {"WizConfig"	,"u_restWizard(3)"	,0,3} ,;
			             {"Alterar"	,"u_restWizard(4)"	,0,4} ,;
			             {"Excluir"	,"u_restWizard(5)"	,0,5} }
	
	private cString 	:= "ZZW"
	private aGrava		:= {}
		
	dbSelectArea("ZZW")
	dbSetOrder(1) //ZZR_FILIAL+ZZR_ITEM
	dbSelectArea(cString)
		
	//----------------------	
	// Valida Upd/Ambiente
	//----------------------	
	if csCheckUpd()		
		mBrowse( 6,1,22,75,cString)			
	else
		msgInfo('Por gentileza, entre em contato com Sistemas Corporativos, não foi possível exibir a rotina.','Integration REST Services')
		return
	endif
		
return

//-----------------------------------------------------------------------
/*{Protheus.doc} restWizard
Funcao responsavel por exibir o Wizard para configuracao do REST.

@author	Douglas Parreja
@since	21/03/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function restWizard( nOpc )

	local oWizard
	local aTexto	:= {}
	local cCod		:= ""
	local cStatus	:= ""
	local cUser		:= ""
	
	private cEmp		:= space(2)
	private cFilEmp	:= space(2)
	private cOrigem	:= space(100)
	private cDestino	:= space(100)
	private cHttp		:= space(200)
	private cPath		:= space(100)
	private cUsuario	:= space(100)
	private cSenhaUs	:= space(100)
	private cHeadAut	:= space(100)
	private cHeadCont	:= space(100)
	private cObs1		:= space(200)
	private cObs2		:= space(200)
	private cObs3		:= space(200)
	private cObs4		:= space(200)
	private cObs5		:= space(200)
	
	default nOpc	:= 3

	if PswAdmin( /*cUser*/, /*cPsw*/,RetCodUsr()) == 0
	
		if nOpc > 0
						
			aadd(aTexto,{})
			aTexto[1] := "Esta rotina tem como objetivo ajuda-lo na configuração da integração do Protheus com o serviço Web Service via REST de qualquer fornecedor. " + CRLF 
			aTexto[1] += "O primeiro passo é configurar a conexão do Protheus com o Integration REST Services."
			
			aadd(aTexto,{})
			aTexto[2] := "Você concluíu com sucesso a configuração da integração do Protheus para o Integration REST Services." + CRLF
			aTexto[2] += "Após clicar em Finalizar, será atualizado os dados na Rotina."
			
			//-----------------------------------------------------
			// Inclusao
			//-----------------------------------------------------
			if nOpc == 3
				DEFINE WIZARD oWizard ;
					TITLE "Integration REST Services";
					HEADER "Atenção"; 
					MESSAGE "Siga atentamente os passos para a configuração do serviço Web Service REST.";
					TEXT aTexto[1] ;
					NEXT {|| .T.} ;
					FINISH {||.T.}
					
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| .F.} ;
					NEXT {|| cadProtheus(@cOrigem,@cDestino,@cEmp,@cFilEmp,nOpc) };
					PANEL
					
					@ 005,010 SAY "Nesta etapa, favor realizar as configurações referente ao PROTHEUS." SIZE 270,010 PIXEL OF oWizard:oMPanel[2] 			
					@ 030,012 SAY "Origem"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 028,033 GET cOrigem	SIZE 250,010 PIXEL OF oWizard:oMPanel[2]	
					@ 050,012 SAY "Destino"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 048,033 GET cDestino	SIZE 250,010 PIXEL OF oWizard:oMPanel[2]
					@ 070,009 SAY "Empresa"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 068,033 GET cEmp 	SIZE 005,010 PIXEL OF oWizard:oMPanel[2]
					@ 090,020 SAY "Filial"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 088,033 GET cFilEmp	SIZE 005,010 PIXEL OF oWizard:oMPanel[2]
				
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| oWizard:SetPanel(2),.T.} ;
					NEXT {|| cadHttp(@cHttp,nOpc) };
					PANEL
					
					@ 010,010 SAY "Informe a URL do servidor REST que será consumido:" SIZE 270,010 PIXEL OF oWizard:oMPanel[3] 
					@ 025,010 GET cHttp SIZE 270,010 PIXEL OF oWizard:oMPanel[3]
				
				
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| oWizard:SetPanel(3),.T.} ;
					NEXT {|| cadREST(@cPath,@cUsuario,@cSenhaUs,@cHeadAut,@cHeadCont,nOpc)};
					PANEL
					
					@ 005,010 SAY "Nesta etapa, favor realizar as configurações referente ao REST." SIZE 270,010 PIXEL OF oWizard:oMPanel[4] 		
					@ 030,012 SAY "SetPath"	SIZE 030,010 PIXEL OF oWizard:oMPanel[4] 
					@ 028,033 GET cPath 	SIZE 250,010 PIXEL OF oWizard:oMPanel[4]	
					@ 050,012 SAY "Usuário"	SIZE 030,010 PIXEL OF oWizard:oMPanel[4] 
					@ 048,033 GET cUsuario	SIZE 250,010 PIXEL OF oWizard:oMPanel[4]
					@ 070,015 SAY "Senha"	SIZE 030,010 PIXEL OF oWizard:oMPanel[4] 
					@ 068,033 GET cSenhaUs	SIZE 250,010 PIXEL OF oWizard:oMPanel[4] PASSWORD
					@ 090,010 SAY "Header Autorizathion"	SIZE 100,010 PIXEL OF oWizard:oMPanel[4] 
					@ 088,063 GET cHeadAut 				SIZE 220,010 PIXEL OF oWizard:oMPanel[4]
					@ 110,010 SAY "Header Content-Type" 	SIZE 100,010 PIXEL OF oWizard:oMPanel[4] 
					@ 108,063 GET cHeadCont 				SIZE 220,010 PIXEL OF oWizard:oMPanel[4]
					
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| oWizard:SetPanel(4),.T.} ;
					NEXT {|| cadRESTObs(@cObs1,@cObs2,@cObs3,@cObs4,@cObs5,nOpc)};
					PANEL
					
					@ 005,010 SAY "Caso tenha mais configurações para o Serviço REST, favor informar nos campos abaixo:" SIZE 270,010 PIXEL OF oWizard:oMPanel[5] 			
					@ 030,012 SAY "Obs.(1)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 028,033 GET cObs1 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]	
					@ 050,012 SAY "Obs.(2)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 048,033 GET cObs2 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]
					@ 070,012 SAY "Obs.(3)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 068,033 GET cObs3 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5] 
					@ 090,012 SAY "Obs.(4)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 088,033 GET cObs4 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]
					@ 110,012 SAY "Obs.(5)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 108,033 GET cObs5 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]
							
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services"; 
					MESSAGE "";
					BACK {|| oWizard:SetPanel(5),.T.} ;
					FINISH {|| restGrava(nOpc,cCod) } ;
					PANEL
				@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[6]
				
				ACTIVATE WIZARD oWizard CENTERED
			
			//-----------------------------------------------------
			// Visualizacao | Alteracao
			//-----------------------------------------------------
			elseif alltrim(Str(nOpc)) $ '2|4'				
				
				if select("ZZW") > 0
					cCod := ZZW->ZZW_COD
				endif
				
				DEFINE WIZARD oWizard ;
					TITLE "Integration REST Services";
					HEADER "Atenção"; 
					MESSAGE "Siga atentamente os passos para a configuração do serviço Web Service REST.";
					TEXT aTexto[1] ;
					NEXT {|| cadProtheus(@cOrigem,@cDestino,@cEmp,@cFilEmp,nOpc) };
					FINISH {||.T.}
					
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| .F.} ;
					NEXT {|| cadHttp(@cHttp,nOpc) };
					PANEL
					
					@ 005,010 SAY "Nesta etapa, favor realizar as configurações referente ao PROTHEUS." SIZE 270,010 PIXEL OF oWizard:oMPanel[2] 			
					@ 030,012 SAY "Origem"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 028,033 GET cOrigem	SIZE 250,010 PIXEL OF oWizard:oMPanel[2]	
					@ 050,012 SAY "Destino"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 048,033 GET cDestino	SIZE 250,010 PIXEL OF oWizard:oMPanel[2]
					@ 070,009 SAY "Empresa"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 068,033 GET cEmp 	SIZE 005,010 PIXEL OF oWizard:oMPanel[2]
					@ 090,020 SAY "Filial"	SIZE 030,010 PIXEL OF oWizard:oMPanel[2] 
					@ 088,033 GET cFilEmp	SIZE 005,010 PIXEL OF oWizard:oMPanel[2]
				
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| oWizard:SetPanel(2),.T.} ;
					NEXT {|| cadREST(@cPath,@cUsuario,@cSenhaUs,@cHeadAut,@cHeadCont,nOpc) };
					PANEL
					
					@ 010,010 SAY "Informe a URL do servidor REST que será consumido:" SIZE 270,010 PIXEL OF oWizard:oMPanel[3] 
					@ 025,010 GET cHttp SIZE 270,010 PIXEL OF oWizard:oMPanel[3]
				
				
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| oWizard:SetPanel(3),.T.} ;
					NEXT {|| cadRESTObs(@cObs1,@cObs2,@cObs3,@cObs4,@cObs5,nOpc) };
					PANEL
					
					@ 005,010 SAY "Nesta etapa, favor realizar as configurações referente ao REST." SIZE 270,010 PIXEL OF oWizard:oMPanel[4] 		
					@ 030,012 SAY "SetPath"	SIZE 030,010 PIXEL OF oWizard:oMPanel[4] 
					@ 028,033 GET cPath 	SIZE 250,010 PIXEL OF oWizard:oMPanel[4]	
					@ 050,012 SAY "Usuário"	SIZE 030,010 PIXEL OF oWizard:oMPanel[4] 
					@ 048,033 GET cUsuario	SIZE 250,010 PIXEL OF oWizard:oMPanel[4]
					@ 070,015 SAY "Senha"	SIZE 030,010 PIXEL OF oWizard:oMPanel[4] 
					@ 068,033 GET cSenhaUs	SIZE 250,010 PIXEL OF oWizard:oMPanel[4] PASSWORD
					@ 090,010 SAY "Header Autorizathion"	SIZE 100,010 PIXEL OF oWizard:oMPanel[4] 
					@ 088,063 GET cHeadAut 				SIZE 220,010 PIXEL OF oWizard:oMPanel[4]
					@ 110,010 SAY "Header Content-Type" 	SIZE 100,010 PIXEL OF oWizard:oMPanel[4] 
					@ 108,063 GET cHeadCont 				SIZE 220,010 PIXEL OF oWizard:oMPanel[4]
					
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services" ;
					MESSAGE ""	;
					BACK {|| oWizard:SetPanel(4),.T.} ;
					NEXT {|| .T. };
					PANEL
					
					@ 005,010 SAY "Caso tenha mais configurações para o Serviço REST, favor informar nos campos abaixo:" SIZE 270,010 PIXEL OF oWizard:oMPanel[5] 			
					@ 030,012 SAY "Obs.(1)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 028,033 GET cObs1 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]	
					@ 050,012 SAY "Obs.(2)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 048,033 GET cObs2 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]
					@ 070,012 SAY "Obs.(3)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 068,033 GET cObs3 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5] 
					@ 090,012 SAY "Obs.(4)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 088,033 GET cObs4 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]
					@ 110,012 SAY "Obs.(5)"	SIZE 030,010 PIXEL OF oWizard:oMPanel[5] 
					@ 108,033 GET cObs5 	SIZE 250,010 PIXEL OF oWizard:oMPanel[5]
							
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração Integration REST Services"; 
					MESSAGE "";
					BACK {|| oWizard:SetPanel(5),.T.} ;
					FINISH {|| restGrava(nOpc,cCod) } ;
					PANEL
				@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[6]
				
				ACTIVATE WIZARD oWizard CENTERED
			//-----------------------------------------------------
			// Exclusao
			//-----------------------------------------------------
			elseif nOpc == 5
				if select("ZZW") > 0
					cCod := ZZW->ZZW_COD
				endif
				restExcl(cCod)
			endif
		else
			msgInfo('Favor selecionar qual ação deseja executar (Alterar,WizConfig,Visualizar,Excluir).','Integration REST Services')
		endif	
	else
		msgInfo('Usuário não possui perfil de Administrador, com isso não é possível acessar a rotina.','Integration REST Services')
	endif

return

//-----------------------------------------------------------------------
/*{Protheus.doc} csCheckUpd()
Funcao que verifica se o update do foi aplicado.

@return	lUpdOK		Verdadeiro se estiver ok o Update.

@author	Douglas Parreja
@since	21/03/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csCheckUpd()
 
	local lUpdOK	:= .F. 
	local cExec		:= "Integration REST Services"
	
	u_autoMsg(cExec, , "Inicio verificacao base")
	
	if AliasIndic("ZZW")
		lUpdOk := csValidBase()
		u_autoMsg(cExec, , "Termino verificacao base")
	else
		u_autoMsg(cExec, ,'Nao eh possível continuar. Não existe a tabela ZZW.' ) 
	endif 
	
	
return lUpdOK	

//-----------------------------------------------------------------------
/*{Protheus.doc} csValidBase
Funcao que verifica se consta/configurado parametros e tabela.

@return	lOk		Retorna se o ambiente esta preparado para prosseguir.

@author	Douglas Parreja
@since	21/03/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csValidBase()

	local lOk := .T.
	
	if AliasIndic("ZZW")  
		cNome:= SubStr(Posicione('SX2',1,'ZZR','X2_ARQUIVO'),4,5)
		if !( posicione("SX2",1,"ZZW","X2_ARQUIVO") == ("ZZW" + cNome) )			
			msgAlert('Não é possível continuar. Existe a tabela ZZW, mas obteve falha na validação.' )
			lOk := .F.	
		endif
		DbSelectArea("SX3")
		DbSetOrder(2)
		if 	!dbSeek("ZZW_COD") .or. !dbSeek("ZZW_EMPRES") .or. !dbSeek("ZZW_FILEMP") .or.;
				!dbSeek("ZZW_ORIGEM") .or. !dbSeek("ZZW_DESTIN") .or. !dbSeek("ZZW_HTTP") .or. ;
					!dbSeek("ZZW_PATH") .or. !dbSeek("ZZW_USER") .or. !dbSeek("ZZW_SENHA") .or. ;
						!dbSeek("ZZW_HEADAT") .or. !dbSeek("ZZW_HEADCT") .or. !dbSeek("ZZW_OBS1") .or. ;
							!dbSeek("ZZW_OBS2") .or. !dbSeek("ZZW_OBS3") .or. !dbSeek("ZZW_OBS4") .or. ;
								!dbSeek("ZZW_OBS5") .or. !dbSeek("ZZW_STATUS") .or. !dbSeek("ZZW_USERPR")
									msgAlert('Não é possível continuar. Favor executar o compatibilizador updRest para criação dos campos  referente a tabela ZZW.','Compatibilizador XXXXXXX')
									lOk := .F.
		endif
	else
		msgAlert('Não é possível continuar. Não existe a tabela ZZW. Favor executar o compatibilizador updRest.' )
		lOk := .F.
	endif	
	
return lOk

//-----------------------------------------------------------------------
/*{Protheus.doc} cadProtheus
Funcao que valida Cadastro do Protheus.
Valida os campos obrigatorios.

@param	cOrigem		Origem da rotina que sera utilizado o REST.
		cDestino	Destino de onde sera consumido o REST.
		cEmp		Empresa do Protheus (SM0).
		cFilEmp		Filial do Protheus (SM0).

@return	lRet		Retorna se pode prosseguir para proxima aba.

@author	Douglas Parreja
@since	21/03/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function cadProtheus(cOrigem,cDestino,cEmp,cFilEmp,nOpc)

	local cString	:= ""
	local lRet		:= .T.
	local aRet		:= {}
	
	default nOpc 	:= 0
	
	if nOpc > 0	
		//-----------------------------------------------------
		// Inclusao
		//-----------------------------------------------------
		if nOpc == 3	
			if empty(cOrigem)
				aAdd( aRet, "Origem" )
			endif
			if empty(cDestino)
				aAdd( aRet, "Destino" )
			endif
			if empty(cEmp)
				aAdd( aRet, "Empresa" )
			endif
			if empty(cFilEmp)
				aAdd( aRet, "Filial Empresa" )
			endif
			if len( aRet ) > 0
				lRet := .F.
				cString := validMsg( aRet )
				if !empty( cString ) 
					msgInfo("Favor preencher o(s) campo(s): " + alltrim(cString) + ".", "Integration REST Services")
				endif
			else
				aAdd( aGrava, {"ZZW_ORIGEM",alltrim(cOrigem)	})
				aAdd( aGrava, {"ZZW_DESTIN",alltrim(cDestino)	})
				aAdd( aGrava, {"ZZW_EMPRES",alltrim(cEmp)		})
				aAdd( aGrava, {"ZZW_FILEMP",alltrim(cFilEmp)	})
			endif			
		//-----------------------------------------------------
		// Visualizacao | Alteracao
		//-----------------------------------------------------
		elseif alltrim(Str(nOpc)) $ '2|4'
			if select("ZZW") > 0
				cOrigem		:= ZZW->ZZW_ORIGEM
				cDestino	:= ZZW->ZZW_DESTIN
				cEmp		:= ZZW->ZZW_EMPRES
				cFilEmp		:= ZZW->ZZW_FILEMP
			endif
		endif
	endif
	
return lRet

//-----------------------------------------------------------------------
/*{Protheus.doc} cadHttp
Funcao que valida Cadastro da URL informada HTTP.
Valida os campos obrigatorios.

@param	cHttp		Url do servico REST que sera consumido.
		
@return	lRet		Retorna se pode prosseguir para proxima aba.

@author	Douglas Parreja
@since	22/03/2016
@version 11.8
/*/
//---------------------------------------------------------------------- -
static function cadHttp(cHttp,nOpc)

	local cString	:= ""
	local lRet		:= .T.
	local aRet		:= {}
	
	default nOpc	:= 0
		
	if nOpc > 0
		//-----------------------------------------------------
		// Inclusao
		//-----------------------------------------------------
		if nOpc == 3	
			if empty(cHttp)
				aAdd( aRet, "HTTP" )
			endif
		
			if len( aRet ) > 0
				lRet := .F.
				cString := validMsg( aRet )
				if !empty( cString ) 
					msgInfo("Favor preencher o campo: " + alltrim(cString) + "." + CRLF + "Informar a URL que será consumido o serviço REST.", "Integration REST Services")
				endif
			else
				aAdd( aGrava, {"ZZW_HTTP",alltrim(cHttp)} )		
			endif
		//-----------------------------------------------------
		// Visualizacao | Alteracao
		//-----------------------------------------------------	
		elseif alltrim(Str(nOpc)) $ '2|4'
			if select("ZZW") > 0
				cHttp		:= ZZW->ZZW_HTTP				
			endif
		endif
	endif
	
return lRet

//-----------------------------------------------------------------------
/*{Protheus.doc} cadREST
Funcao que valida Cadastro do REST a ser consumido.
Valida os campos obrigatorios.

@param	cPath		SetPath do servico REST que sera consumido.
		cUsuario	Usuario REST.
		cSenhaUs	Senha usuario REST.
		cHeadAut	Head Autorizathion.
		cHeadCont	Head Content-Type.
		
@return	lRet		Retorna se pode prosseguir para proxima aba.

@author	Douglas Parreja
@since	22/03/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function cadREST(cPath,cUsuario,cSenhaUs,cHeadAut,cHeadCont,nOpc)

	local cString	:= ""
	local cString	:= ""
	local lRet		:= .T.
	local aRet		:= {}
	
	default nOpc	:= 0
	
	if nOpc > 0	
		//-----------------------------------------------------
		// Inclusao
		//-----------------------------------------------------
		if nOpc == 3
			if empty(cPath)
				aAdd( aRet, "setPath" )
			endif
			if len( aRet ) > 0
				lRet := .F.
				cString := validMsg( aRet )
				if !empty( cString ) 
					msgInfo("Favor preencher o campo: " + alltrim(cString) + "." + CRLF + "Informar o caminho da SetPath a ser consumido o serviço REST.", "Integration REST Services")
				endif
			else
				aAdd( aGrava, {"ZZW_PATH"	,alltrim(cPath)	})
				aAdd( aGrava, {"ZZW_USER"	,alltrim(cUsuario)	})
				aAdd( aGrava, {"ZZW_SENHA"	,alltrim(cSenhaUs)	})
				aAdd( aGrava, {"ZZW_HEADAT"	,alltrim(cHeadAut)	})
				aAdd( aGrava, {"ZZW_HEADCT"	,alltrim(cHeadCont)	})
			endif
		//-----------------------------------------------------
		// Visualizacao | Alteracao
		//-----------------------------------------------------	
		elseif alltrim(Str(nOpc)) $ '2|4'
			if select("ZZW") > 0
				cPath		:= ZZW->ZZW_PATH				
				cUsuario	:= ZZW->ZZW_USER
				cSenhaUs	:= ZZW->ZZW_SENHA
				cHeadAut	:= ZZW->ZZW_HEADAT
				cHeadCont	:= ZZW->ZZW_HEADCT				
			endif
		endif	
	endif	 
	
return lRet

//-----------------------------------------------------------------------
/*{Protheus.doc} cadRESTObs
Funcao que valida Cadastro do REST a ser consumido, porem, como 
parametro adicionais.
Nao possui campos obrigatorios.

@param	cObs1		Observacao 1
		cObs2		Observacao 2
		cObs3		Observacao 3
		cObs4		Observacao 4
		cObs5		Observacao 5
		
@return	lRet		Retornara sempre .T. pq nao tenho campos Obrigatorios.

@author	Douglas Parreja
@since	22/03/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function cadRESTObs(cObs1,cObs2,cObs3,cObs4,cObs5,nOpc)

	local cString	:= ""
	local cString	:= ""
	local lRet		:= .T.
	local aRet		:= {}
		
	default nOpc	:= 0
	
	if nOpc > 0
		//-----------------------------------------------------
		// Inclusao
		//-----------------------------------------------------
		if nOpc == 3	
			if !empty(cObs1)
				aAdd( aRet, "Obs1" )
			endif
			if !empty(cObs2)
				aAdd( aRet, "Obs2" )
			endif
			if !empty(cObs3)
				aAdd( aRet, "Obs3" )
			endif
			if !empty(cObs4)
				aAdd( aRet, "Obs4" )
			endif
			if !empty(cObs5)
				aAdd( aRet, "Obs5" )
			endif
		
			//-----------------------------------------------------
			// Neste cenario a logica eh ao contrario, pois nao 
			// validarei se esta vazio pq nao eh obrigatorio o 
			// preenchimento, porem, eu gravarei caso o campo 
			// esteja preenchido.
			//-----------------------------------------------------
			if len( aRet ) > 0
				aAdd( aGrava, {"ZZW_OBS1"	,alltrim(cObs1)	})
				aAdd( aGrava, {"ZZW_OBS2"	,alltrim(cObs2)	})
				aAdd( aGrava, {"ZZW_OBS3"	,alltrim(cObs3)	})
				aAdd( aGrava, {"ZZW_OBS4"	,alltrim(cObs4)	})
				aAdd( aGrava, {"ZZW_OBS5"	,alltrim(cObs5)	})				
			endif
		//-----------------------------------------------------
		// Visualizacao | Alteracao
		//-----------------------------------------------------
		elseif alltrim(Str(nOpc)) $ '2|4'
			if select("ZZW") > 0
				cObs1		:= ZZW->ZZW_OBS1		
				cObs2		:= ZZW->ZZW_OBS2
				cObs3		:= ZZW->ZZW_OBS3
				cObs4		:= ZZW->ZZW_OBS4
				cObs5		:= ZZW->ZZW_OBS5
			endif
		endif
	endif
			
return lRet
//-----------------------------------------------------------------------
/*{Protheus.doc} csValidBase
Funcao responsavel por validar a Mensagem que sera retornada para o 
usuario.

@param		aDados	Array contendo os campos que nao foram preenchidos.

@return		cString	Retorna o nome dos campos para ser exibido.

@author	Douglas Parreja
@since	22/03/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function validMsg( aDados )

	local cString	:= ""
	local nX		:= 0	
	default aDados := {}	
	
	if len( aDados ) > 0
		for nX := 1 to len( aDados )
			if nX > 1 
				cString += ","
				cString += aDados[nX]
			else
				cString += aDados[nX]
			endif						
		next nX
	endif

return cString

//-----------------------------------------------------------------------
/*{Protheus.doc} restGrava()
Funcao responsavel por realizar a gravacao na tabela dos dados informados
no Wizard.


@return		.T.		Retornara sempre .T. pq nao vou travar o processo, 
					pois quem estara cadastrando eh preciso verificar
					na propria MBrowse a inclusao ou alteracao.

@author	Douglas Parreja
@since	22/03/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function restGrava( nOpc,cCod )

	local cStatus	:= ""
	local lContinua	:= .T.
	local nEmpresa	:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_EMPRES"	})	//1
	local nFilEmp	:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_FILEMP"	})	//2
	local nOrigem	:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_ORIGEM"	})	//3
	local nDestino	:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_DESTIN"	})	//4	
	local nHttp		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_HTTP"	})	//5
	local nPath		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_PATH"	})	//6
	local nUser		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_USER"	})	//7
	local nSenha	:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_SENHA"	})	//8
	local nHeadAt	:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_HEADAT"	})	//9
	local nHeadCt	:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_HEADCT"	})	//10
	local nObs1		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_OBS1"	})	//11
	local nObs2		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_OBS2"	})	//12
	local nObs3		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_OBS3"	})	//13
	local nObs4		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_OBS4"	})	//14
	local nObs5		:= ascan(aGrava, {|x| alltrim(x[1]) == "ZZW_OBS5"	})	//15
	
	default nOpc	:= 0
	default cCod 	:= ""
	
	//---------------------------------------------------------
	// Vaidacoes antes de realizar gravacao
	//---------------------------------------------------------
	if nOpc > 0	
		//-----------------------------------------------------
		// Inclusao
		//-----------------------------------------------------
		if nOpc == 3
			if type("aGrava") <> "U"
				if type("aGrava") == "A"
					if len(aGrava) > 0
						lReclock	:= .T.							
						cStatus		:= "1"					
					else
						lContinua := .F.
					endif
				else
					lContinua := .F.
				endif
			else
				lContinua := .F.
			endif		
			
		//-----------------------------------------------------
		// Visualiza
		//-----------------------------------------------------
		elseif alltrim(Str(nOpc)) $ '2'
			lContinua := .F.				
		//-----------------------------------------------------
		// Alteracao
		//-----------------------------------------------------
		elseif alltrim(Str(nOpc)) $ '4'
			lReclock	:= .F.
			cStatus		:= "2"
		endif
		
		//-----------------------------------------------------
		// Apos validacoes, caso esteja Ok realizo alteracao
		//-----------------------------------------------------
		if lContinua
			Begin Transaction				
				ZZW->( RecLock('ZZW', lReclock ))
				ZZW->ZZW_FILIAL := xFilial("ZZW")
				if lReclock				
					ZZW->ZZW_COD	:= csGetNum( 'ZZW', 'ZZW_COD' )
				endif
				ZZW->ZZW_EMPRES	:= iif( nEmpresa > 0	, alltrim(aGrava[nEmpresa][2])	, iif(!empty(cEmp)		, cEmp		, "") )		//1
				ZZW->ZZW_FILEMP	:= iif( nFilEmp > 0	, alltrim(aGrava[nFilEmp][2])	, iif(!empty(cFilEmp)	, cFilEmp	, "") )		//2
				ZZW->ZZW_ORIGEM	:= iif( nOrigem > 0	, alltrim(aGrava[nOrigem][2])	, iif(!empty(cOrigem)	, cOrigem	, "") )		//3
				ZZW->ZZW_DESTIN	:= iif( nDestino > 0	, alltrim(aGrava[nDestino][2])	, iif(!empty(cDestino)	, cDestino	, "") )		//4
				ZZW->ZZW_HTTP	:= iif( nHttp > 0		, alltrim(aGrava[nHttp][2])		, iif(!empty(cHttp)		, cHttp		, "") )		//5
				ZZW->ZZW_PATH	:= iif( nPath > 0		, alltrim(aGrava[nPath][2])		, iif(!empty(cPath)		, cPath		, "") )		//6
				ZZW->ZZW_USER	:= iif( nUser > 0		, alltrim(aGrava[nUser][2])		, iif(!empty(cUsuario)	, cUsuario	, "") )		//7
				ZZW->ZZW_SENHA	:= iif( nSenha > 0		, alltrim(aGrava[nSenha][2])	, iif(!empty(cSenhaUs)	, cSenhaUs	, "") )		//8
				ZZW->ZZW_HEADAT	:= iif( nHeadAt > 0	, alltrim(aGrava[nHeadAt][2])	, iif(!empty(cHeadAut)	, cHeadAut	, "") )		//9
				ZZW->ZZW_HEADCT	:= iif( nHeadCt > 0	, alltrim(aGrava[nHeadCt][2])	, iif(!empty(cHeadCont)	, cHeadCont	, "") )		//10
				ZZW->ZZW_OBS1	:= iif( nObs1 > 0		, alltrim(aGrava[nObs1][2])		, iif(!empty(cObs1)		, cObs1		, "") )		//11
				ZZW->ZZW_OBS2	:= iif( nObs2 > 0		, alltrim(aGrava[nObs2][2])		, iif(!empty(cObs2)		, cObs2		, "") )		//12
				ZZW->ZZW_OBS3	:= iif( nObs3 > 0		, alltrim(aGrava[nObs3][2])		, iif(!empty(cObs3)		, cObs3		, "") )		//13
				ZZW->ZZW_OBS4	:= iif( nObs4 > 0		, alltrim(aGrava[nObs4][2])		, iif(!empty(cObs4)		, cObs4		, "") )		//14
				ZZW->ZZW_OBS5	:= iif( nObs5 > 0		, alltrim(aGrava[nObs5][2])		, iif(!empty(cObs5)		, cObs5		, "") )		//15				
				ZZW->ZZW_STATUS	:= cStatus
				ZZW->ZZW_USERPR	:= "User: " + logusername() + " | " + "Data: " + dtoc(Date()) + " - " + Time() + " | " + "IPClient: " + getClientIP()
				ZZW->( MsUnLock() )
			End Transaction	
			aGrava := {}
			// Para posicionar no Grid apos qualquer gravacao, ordernar por Item.
			ZZW->( dbSetOrder(1) )
			
		endif
	endif

return .T.

//---------------------------------------------------------------
/*{Protheus.doc} csGetNum
Funcao responsavel para retornar numero da SXE
				  
@param	cAlias		Alias da tabela 
		cCampo		Campo a ser validado para numeracao				  
@return	cNum		Retorna o numero valido para ser gerado na tabela.						

@author	Douglas Parreja
@since	31/07/2016
@version	11.8
/*/
//---------------------------------------------------------------
static function csGetNum( cAlias, cCampo )
	local aArea    := GetArea()
	local cNum		:= GetSXENum( cAlias, cCampo )
	local cNumOk	:= ""	
	local cNumProx	:= ""	
	local nSaveSx8 := GetSX8Len()
	local nI		:= 0	
	
	default cAlias	:= ""
	default cCampo 	:= ""
	
	dbSelectArea( cAlias )
	dbSetOrder( 1 )
	
	if !dbSeek( xFilial( cAlias ) + cNum )
		if !Empty(cNum) .and. nSaveSx8 > 0
			ConfirmSX8()
		endif
	else
		while empty(cNumOk)
			n1 := Iif( nI == 0, val(cNum), val(cNumProx) )
			n2 := n1 + 1
			cNumProx := StrZero( n2,6,0 )
			while !DbSeek( xFilial( cAlias ) + cNumProx )
				cNumOk 	:= cNumProx
				cNum 	:= cNumOk	
				ConfirmSX8()
				exit
			end
			nI ++ 
		end
	endif
	RestArea( aArea )
	
return( cNum )

//-------------------------------------------------------------------
/*{Protheus.doc} restExcl
Funcao responsavel por Excluir o cadastro. 

@author  Douglas Parreja
@since   27/03/2017
@version 11.8
/*/
//-------------------------------------------------------------------
static function restExcl( cCod )
	
	if MsgYesNo("Você realmente deseja excluir este cadastro?")    
		Begin Transaction
			ZZW->(dbSetOrder(1)) //ZZW_FILIAL+ZZW_COD
			if ZZW->( dbSeek( xFilial("ZZW") + alltrim( cCod ) ))
				ZZW->( RecLock('ZZW',.F. ))
				ZZW->ZZW_STATUS	:= "3"
				ZZW->ZZW_USERPR	:= "User: " + logusername() + " | " + "Data: " + dtoc(Date()) + " - " + Time() + " | " + "IPClient: " + getClientIP()
				ZZW->( dbDelete() )
				ZZW->( MsUnLock() )					
			else
				msgAlert("Não foi possível Excluir o registro. Favor verificar.","Atenção")
			endif
		End Transaction	
		// Para posicionar no Grid apos qualquer gravacao, ordernar por Item.
		ZZW->( dbSetOrder(1) )	
	endif

return










