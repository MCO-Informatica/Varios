//proxima funcao utilzar ajax019 pulei sem querer
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#Include "aarray.ch"
#Include "json.ch"

#DEFINE cNOME_FONTE "CSRHAJAX.PRW"

#DEFINE cPARAM_CAMINHO 			   "PARAM_CAMINHO"
#DEFINE cPARAM_MODO_DEBUG 		   "PARAM_MODO_DEBUG"
#DEFINE cPARAM_SHOW_PENDENTES_V2   "PENDENTES_V2"
#DEFINE cPARAM_AREA_RH 	 		   "AREA_RH"
#DEFINE cPARAM_VIEW_REL_BH_EXTRATO "VIEW_REL_BH_EXTRATO"
#DEFINE cPARAM_VIEW_REL_BH_CUSTO   "VIEW_REL_BH_CUSTO"

#DEFINE lDEBUG_CABEC .F.

/*
{Protheus.doc} Ajax011
Rotina chamada pelo Portal Web do Protheus - Dados do funcionario
@Return String - Retorna dados do funcionario em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax011()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Carregando dados do colaborador")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		If oPon:GETFUNCIONARIO( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno  := oPon:cGETFUNCIONARIORESULT
		EndIf
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax012
Rotina chamada pelo Portal Web do Protheus - Lista de marcacoes do funcionario
@Return String - Retorna uma lista de marcacoes do funcionario em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax012()
	Local cRetorno  := ""
	Local oPon		:= Nil

	//Monta Json do cabecalho do colaborador
	if ValidUser()
		showMsg("Lista de marcacoes do funcionario")
		if !empty( HttpSession->idkey ) .AND. !empty( HttpGet->cperiodo )
			//Instancia o WS
			oPon := WSWSCSPORTALRH():New()
			WsChgURL(@oPon, "WSCSPORTALRH.APW")
			if oPon:GETMARCACAO( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), HttpGet->cperiodo  )
				cRetorno := oPon:cGETMARCACAORESULT
			endif
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax013
Rotina chamada pelo Portal Web do Protheus - Altera marcacao de um dia
@Return String - Json com dados do dia alterado
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax013()
	Local cRetorno := ""
	Local oWSDL    := Nil

	//Monta Json do cabecalho do colaborador
	if ValidUser()
		showMsg("Altera marcacao de um dia")
		if !Empty(httpSession->idkey) //.And. !Empty(cponmes)
			//Instancia o WS
			oPon := WSWSCSPORTALRH():New()
			WsChgURL(@oPon, "WSCSPORTALRH.APW")

			oWSDL := WSCSPORTALRH_STRMARCDIA():New()

			oWSDL:dcData 				:= ctod(httpGet->CDATA)				//1
			oWSDL:cc1E					:= httpGet->C1E						//2
			oWSDL:cc1S 					:= httpGet->C1S						//3
			oWSDL:cc2E 					:= httpGet->C2E						//4
			oWSDL:cc2S 					:= httpGet->C2S						//5
			oWSDL:cc3E 					:= httpGet->C3E						//6
			oWSDL:cc3S 					:= httpGet->C3S						//7
			oWSDL:cc4E 					:= httpGet->C4E						//8
			oWSDL:cc4S 					:= httpGet->C4S						//9
			oWSDL:nhoraNegValor 		:= val(httpGet->HORANEGVALOR)		//10
			oWSDL:choraNegEvento 		:= httpGet->HORANEGEVENTO			//11
			oWSDL:choraNegJustificativa := httpGet->HORANEGJUSTIFICATIVA	//12
			oWSDL:nhoraPosValor 		:= val(httpGet->HORAPOSVALOR)		//13
			oWSDL:choraPosEvento 		:= httpGet->HORAPOSEVENTO			//14
			oWSDL:choraPosJustificativa := httpGet->HORAPOSJUSTIFICATIVA	//15
			oWSDL:ncalend1EHR 			:= val(httpGet->CALEND1EHR)			//16
			oWSDL:ccalend1ETP 			:= httpGet->CALEND1ETP				//17
			oWSDL:ncalend1SHR 			:= val(httpGet->CALEND1SHR)			//18
			oWSDL:ccalend1STP 			:= httpGet->CALEND1STP				//19
			oWSDL:ncalend2EHR 			:= val(httpGet->CALEND2EHR)			//20
			oWSDL:ccalend2ETP 			:= httpGet->CALEND2ETP				//21
			oWSDL:ncalend2SHR 			:= val(httpGet->CALEND2SHR)			//22
			oWSDL:ccalend2STP 			:= httpGet->CALEND2STP				//23
			oWSDL:ncalend3EHR 			:= val(httpGet->CALEND3EHR)			//24
			oWSDL:ccalend3ETP 			:= httpGet->CALEND3ETP				//25
			oWSDL:ncalend3SHR 			:= val(httpGet->CALEND3SHR)			//26
			oWSDL:ccalend3STP 			:= httpGet->CALEND3STP				//27
			oWSDL:ncalend4EHR 			:= val(httpGet->CALEND4EHR)			//28
			oWSDL:ccalend4ETP	 		:= httpGet->CALEND4ETP				//29
			oWSDL:ncalend4SHR 			:= val(httpGet->CALEND4SHR)			//30
			oWSDL:ccalend4STP 			:= httpGet->CALEND4STP				//31
			oWSDL:cordem 				:= httpGet->ORDEM					//32
			oWSDL:caponta 				:= httpGet->APONTA					//33
			oWSDL:cperAponta  			:= httpGet->PERAPONTA				//34
			oWSDL:cturno 				:= httpGet->TURNO					//35
			oWSDL:cjustificativaMarcacao:= httpGet->JUSTIFICATIVAMARCACAO	//36
			oWSDL:cM1E 					:= httpGet->M1E 					//37
			oWSDL:cM1S 					:= httpGet->M1S 					//38
			oWSDL:cM2E 					:= httpGet->M2E 					//39
			oWSDL:cM2S 					:= httpGet->M2S 					//40
			oWSDL:cM3E 					:= httpGet->M3E 					//41
			oWSDL:cM3S 					:= httpGet->M3S 					//42
			oWSDL:cM4E 					:= httpGet->M4E 					//43
			oWSDL:cM4S 					:= httpGet->M4S 					//44
			oWSDL:cstatusMarc 			:= httpGet->STATUS 					//45
			oWSDL:cflagaponta 			:= httpGet->FLAGAPONTA 				//46
			oWSDL:cstatusAtraso 		:= httpGet->statusAtraso            //47
			oWSDL:cstatusHE 			:= httpGet->statusHE                //48

			//Executa o metodo de dados do colaborador
			if oPon:SETMARCACAODIA( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), oWSDL)
				cRetorno := oPon:cSETMARCACAODIARESULT
			endif
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax014
Rotina chamada pelo Portal Web do Protheus - Retorna eventos negativos liberados para portal do ponto
@Return String - Retorna uma lista eventos negativos em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax014()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna eventos negativos liberados para portal do ponto")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getEveNeg(HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ))
			cRetorno := oPon:cGETEVENEGRESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax015
Rotina chamada pelo Portal Web do Protheus - Retorna eventos positivos liberados para portal do ponto
@Return String - Retorna uma lista eventos positivos em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax015()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna eventos positivos liberados para portal do ponto")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getEvePos(HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ))
			cRetorno := oPon:cGETEVEPOSRESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax016
Rotina chamada pelo Portal Web do Protheus - Aprova ou reprova apontamentos
@Return String - Retorna uma lista eventos positivos em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax016()
	Local cRetorno   := ""
	Local oPon		 := Nil
	Local cAprovador := ""

	if ValidUser()
		showMsg("Aprova ou reprova apontamentos")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if !empty( HttpSession->aprovador )
			cAprovador := HttpSession->aprovador
		endif

		//Executa o metodo de dados do colaborador
		if oPon:setToAprovacao( HttpSession->idkey, ;
								GerChaCrip( HttpSession->cIdPontoPar ), ;
								httpGet->APONTAMENTOS, ;
								cAprovador )
			cRetorno := ""
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax017
Rotina chamada pelo Portal Web do Protheus - Retorna lista de periodos do funcionario
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax017()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna lista de periodos abertos do colaboradore")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getListaPeriodo(HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno := oPon:cGETLISTAPERIODORESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax018
Rotina chamada pelo Portal Web do Protheus - Retorna lista de periodos por gestor
@Return String - Retorna uma lista periodos abertos para o gestor em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax018()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna lista de periodos por gestor")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getListaEquipe( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ),  httpGet->matresp )
			cRetorno := oPon:cGETLISTAEQUIPERESULT
		EndIf
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax019
Reverte marcacoes do funcionário para poder reenviar
@Return String - Retorna 1 - para revertido 2 - nao revertido
@author Bruno Nunes
@since 07/01/2019
@version 2.01
*/
User Function Ajax019()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Reverte marcacoes do funcionário para poder reenviar")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:setReverterAprovacao( HttpSession->idkey, ;
									  GerChaCrip( HttpSession->cIdPontoPar ), ;
									  httpGet->filcolab, ;
									  httpGet->matcolab, ;
									  httpGet->ponmes, ;
									  httpGet->tipoUsu )
			cRetorno := oPon:cSETREVERTERAPROVACAORESULT
		EndIf
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)


/*
{Protheus.doc} Ajax020
Rotina chamada pelo Portal Web do Protheus - Volta as marcacoes para marcaco inicial do relogio
@Return String - Retorna uma lista de marcacoes em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax020()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Volta as marcacoes para marcaco inicial do relogio")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:setMarcacaoInicial( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), httpGet->CDATA, httpGet->CPONMES, httpGet->CORDEM)
			cRetorno := oPon:cSETMARCACAOINICIALRESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax021
Controle de acesso determina se o usuário pode entrar no portal determinado pelo
parametro MV_CSRH001, se preenchido, somente o centro de custo no campo tem acesso ao portal, se vazio,
todos acessam
@Return String - Retorna de qual ambiente logar 0 - Portal antigo, 1- Portal release 1, 2- Portal release 2 em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax021()
	Local cRetorno := ""
	Local oPon	   := Nil
	Local idKey    := ''

	showMsg("Retorna de qual ambiente logar 0 - Portal antigo, 1- Portal release 1, 2- Portal release 2 em JSON")

	if !Empty( HttpSession->cParticipantID )
		idKey := GerChaCrip(HttpSession->cParticipantID)
	endif

	//Monta Json do cabecalho do colaborador
	if !Empty( idKey )
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		If oPon:getPortal( idKey, idKey )
			cRetorno  := oPon:cGETPORTALRESULT
			HttpSession->cIdPontoPar := HttpSession->cParticipantID
			HttpSession->idkey       := idKey
		EndIf
	endif

	showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
Return(cRetorno)

/*
{Protheus.doc} Ajax022
Rotina chamada pelo Portal Web do Protheus - Retorna lista de eventos negativos do funcionario
@Return String - Retorna lista de eventos negativos do funcionario em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax022()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna lista de eventos negativos do funcionario em JSON")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getDetalheNeg( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), httpGet->CDATA)
			cRetorno := oPon:cGETDETALHENEGRESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax023
Rotina chamada pelo Portal Web do Protheus - Retorna lista de eventos positivos do funcionario
@Return String - Retorna lista de eventos positivos do funcionario em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax023()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna lista de eventos positivos do funcionario")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getDetalhePos( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), httpGet->CDATA)
			cRetorno := oPon:cGETDETALHEPOSRESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax090
Rotina chamada pelo Portal Web do Protheus - Pega parametros passados na pagian web do portal para session
@Return String - Ok - Pegou parametros, Vazio - Erro
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax090()
	Local cRetorno := ""

	if ValidUser()
		showMsg("Carrega parametros passados na pagina web do portal para session")
		if !empty(httpGet->idkeyParam)
			HttpSession->aprovador  := httpGet->aprovador
			HttpSession->idkey  	:= httpGet->idkeyParam +';'+ httpGet->cperiodo
			cRetorno := 'ok'
		endif
		showMsg("Retorno: "+cRetorno, lDEBUG_CABEC)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax091
Rotina chamada pelo Portal Web do Protheus - Retora parametros da session para pagina web
@Return String - Paramotros guardados na session
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax091()
	Local cRetorno := ""

	if ValidUser()
		showMsg("Retorna parametros da session para pagina web")

		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")
		if !empty( HttpSession->idkey )
			cRetorno := HttpSession->idkey
		endif
		showMsg("Retorno: "+cRetorno, lDEBUG_CABEC)
	endif
Return(cRetorno)

/*
{Protheus.doc} ValidUser
Verifica se o usuario continua logado
@Return Boolean - .T. Participante validado, .F. Participante não validado.
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function ValidUser()
	Local lRetorno := .F.

	showMsg("Valida usuario logado")

	if  type('HttpSession->cIdPontoPar') == 'C' .AND. type('HttpSession->cParticipantID') == 'C'
		if !empty('HttpSession->cIdPontoPar') .and. !empty('HttpSession->cParticipantID')
			if HttpSession->cIdPontoPar == HttpSession->cParticipantID
				lRetorno := .T.
			endif
		endif
	endif

	if empty(HttpSession->idkey)
		lRetorno := .F.
		HttpSession->cIdPontoPar 	:= ''
		HttpSession->cParticipantID := ''
		showMsg("RETORNO: Usuario nao autenticado", lDEBUG_CABEC)
	else
		showMsg("RETORNO: Usuario autenticado", lDEBUG_CABEC)
	endif
Return(lRetorno)

/*
{Protheus.doc} GerChaCrip
Rotina para criptografar chave do portal
@Param cId - id do Participante
@Return string - Chave criptografada
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function GerChaCrip(cId)
Return u_CrypCsPE(.T., cId+';'+dtos(MsDate())+';'+cId)

/*
{Protheus.doc} Ajax024
Carrega lista de aprovadores
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return string em json com lista de aprovadores
*/
User Function Ajax024()
	Local cRetorno := ''
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Carrega lista de aprovadores")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getGrupoAprovadores( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno := oPon:cGETGRUPOAPROVADORESRESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax027
Monta lista de pendencias do ponto
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return string - lista pendencia do ponto
*/
User Function Ajax027()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Monta lista de colaboradores subordinado ao aprovadore logado")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if GetGlbValue(cPARAM_SHOW_PENDENTES_V2) == "1"
			//Executa o metodo de dados do colaborador
			if oPon:getAprovacaoV2( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
				cRetorno := oPon:cGETAPROVACAOV2RESULT
			endif
		else
			//Executa o metodo de dados do colaborador
			if oPon:getAprovacaoPendente( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
				cRetorno := oPon:cGETAPROVACAOPENDENTERESULT
			endif
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax028
Monta Json com lista de aprovadores
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax028()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna lista de aprovação")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getListaAprovacao( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), httpGet->CPERIODO )
			cRetorno := oPon:cGETLISTAAPROVACAORESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax029
Monta Json para usar em gráfico de horas
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax029()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Dashboard")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if  !Empty(httpGet->cdiaIni) 	.and. ;
			!Empty(httpGet->cdiaFim) 	.and. ;
			!Empty(httpGet->ctipo) 		.and. ;
			!Empty(httpGet->ctotaliza) 	.and. ;
			!Empty(httpGet->cgrafico)
			oWSDL := WSCSPORTALRH_STRRESULT():New()
			oWSDL:cdia		 := httpGet->cdiaIni
			oWSDL:cdiaFim	 := httpGet->cdiaFim
			oWSDL:ctipo		 := httpGet->ctipo
			oWSDL:ctotaliza	 := httpGet->ctotaliza
			oWSDL:cgrafico	 := httpGet->cgrafico
			if oPon:getResultParcial( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), oWSDL )
				cRetorno := oPon:cGETRESULTPARCIALRESULT
			endif
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax030
Monta Json para usar em gráfico de horas
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax030()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Dashboard")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if 	!Empty(httpGet->ctipoGRA) 	.and. ;
			!Empty(httpGet->ctipoGES) 	.and. ;
			!Empty(httpGet->ctotaliza) 	.and. ;
			!Empty(httpGet->cgrafico)
			oWSDL := WSCSPORTALRH_STRRESULT():New()
			oWSDL:cperiodo		:= httpGet->cperiodo
			oWSDL:ctipoGra		:= httpGet->ctipoGRA
			oWSDL:ctipoGES		:= httpGet->ctipoGES
			oWSDL:ctotaliza		:= httpGet->ctotaliza
			oWSDL:cgrafico		:= httpGet->cgrafico
			oWSDL:cFiltro		:= httpGet->cFiltro
			if oPon:getResultDiretoria( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), oWSDL )
				cRetorno := oPon:cGETRESULTDIRETORIARESULT
			endif
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax031
Monta Json com o tipo de aprovador
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax031()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna tipo de gestor")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if oPon:getTipoGestor( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno := oPon:cGETTIPOGESTORRESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax032
Monta Json com periodo em aberto
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax032()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna periodo aberto")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if oPon:getPeriodoAberto( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno := oPon:cGETPERIODOABERTORESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax033
Pega informações do tipo de aprovador que esta na pagina
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax033()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Carrega informacoes do aprovador logado")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if oPon:getAprovador( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno := oPon:cGETAPROVADORRESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax034
Verifica se o funcionario possui grupo de aprovacao
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax034()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Verifica se funcionario esta em grupo de aprovacao")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		if oPon:getPossuiAprovador( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), httpGet->CPONMES )
			cRetorno := oPon:cGETPOSSUIAPROVADORRESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax035
Verifica se o funcionario possui grupo de aprovacao
@type function
@author Bruno Nunes
@since 16/05/2016
@version P11.5
@return nulo
*/
User Function Ajax035()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Retorna fluxo de aprovacao")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")


		if oPon:getListaProcesso( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), httpGet->periodoFlow, httpGet->gruopoSel )
			cRetorno := oPon:cGETLISTAPROCESSORESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax036
Rotina chamada pelo Portal Web do Protheus - Retorna lista de periodos do funcionario
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax036()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Lista de centro de custo")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getListaCentroCusto(HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno := oPon:cGETLISTACENTROCUSTORESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax037
Monta em Json url com o caminho padrão (Ele altera entre homologação e produção.)
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function Ajax037()
	local cJson   := ""
	local aName   := {}
	local aValue  := {'pageIndex','showPendentes2'}

	u_ParamPtE()
	aName := {GetGlbValue(cPARAM_CAMINHO), GetGlbValue(cPARAM_SHOW_PENDENTES_V2)}
	U_json(@cJson, aName, aValue, 'parametros')

	showMsg("Parametros globais a carregar pagina web")
	showMsg("Retorno: ", lDEBUG_CABEC, cJson)
Return cJson

/*
{Protheus.doc} showMsg
Exibe mensagem no console.log para analise pelos desenvolvedores.
@Return Logico - Retorna verdadeiro se deve mostrar mensagem em console
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
static function showMsg( cTexto, lCabec, cJson )

	default cTexto := ""
	default lCabec := .T.
	default cJson  := ""

	//Configura caminho do portal GCH
	if GetGlbValue( cPARAM_MODO_DEBUG ) == "1"
		if lCabec
			conout( "[PE] THREAD: "+cValToChar(ThreadID()) + space(10) + "FUNCAO: "+procName(1)+ space(10) + "LINHA: "+cValToChar(procLine(1))  )
		endif
		if !empty(cTexto)
			conout( "[PE]    |")
			conout( "[PE]    +----> "+cTexto )
			if !empty( cJson )
				conout( u_JsonPrettify(cJson) )
			endif
			if !lCabec
				conout( "")
			endif
		endif
	endif
Return

/*
{Protheus.doc} Ajax038
Monta em Json verificando se usuário tem acesso a área RH
@Return String - Monta em Json verificando se usuário tem acesso a área RH
@author Bruno Nunes
@since 21/02/2019
@version 2.01
*/
User Function Ajax038()
	local cJson   := ""
	local aProper := {'idParticipante'}
	local i       := 0
	local aAux    := {}
	local aData   := {}

	u_ParamPtE()
	aAux := StrTokArr( GetGlbValue( cPARAM_AREA_RH ), "-" )
	for i := 1 to len(aAux)
		aAdd( aData, {aAux[i] }  )
	next i

	U_json( @cJson, aData, aProper, 'listaAreaRH' )

	showMsg("Acesso exclusivo RH")
	showMsg("Retorno: ", lDEBUG_CABEC, cJson)
Return cJson

/*
{Protheus.doc} Ajax040
@Return String - Retorna
@author Bruno Nunes
@since 26/02/2019
@version 2.01
*/
User Function Ajax040()
	local cRetorno   := ""

	if !empty( HttpGet->matricula )
		showMsg("Retorna dados particiapntes")
		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//getPeriodoAberto
		if oPon:getParticipante( HttpGet->matricula  )
			cRetorno := oPon:cGETPARTICIPANTERESULT
		endif
		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return cRetorno

/*
{Protheus.doc} Ajax041
@Return String - Retorna
@author Bruno Nunes
@since 26/02/2019
@version 2.01
*/
User Function Ajax041()
	local cOk := "0"

	if !empty( HttpGet->id )
		showMsg("Atualiza participantes")

		HttpSession->idkey 		 := GerChaCrip( HttpGet->id )
		HttpSession->cIdPontoPar := HttpGet->id
		HttpSession->cParticipantID := HttpGet->id
		showMsg("HttpSession->idkey: " + HttpSession->idkey, lDEBUG_CABEC)
		showMsg("HttpSession->cIdPontoPar: " + HttpSession->cIdPontoPar, lDEBUG_CABEC)
		cOk := "1"

	endif
Return cOk

/*
{Protheus.doc} Ajax042
Monta lista de grupo de aprovadores para o participante logado.
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 28/02/2019
@version 2.01
*/
User Function Ajax042()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Lista de grupo de aprovadores")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getListaGrupoAprovadores(HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ) )
			cRetorno := oPon:cGETLISTAGRUPOAPROVADORESRESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax025
Saldo Banco de Horas
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 28/02/2019
@version 2.02
*/
User Function Ajax025()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser() .and. !empty(HttpGet->filcolab) .and. !empty(HttpGet->matColab) .and. !empty(HttpGet->periodoColab)
		showMsg("Saldo Banco de Horas")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getSaldoBH( HttpSession->idkey, GerChaCrip( HttpSession->cIdPontoPar ), HttpGet->filcolab, HttpGet->matColab, HttpGet->periodoColab )
			cRetorno := oPon:cGETSALDOBHRESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax026
Parametros Relatorio
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 28/02/2019
@version 2.02
*/
User Function Ajax026()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Parametros Relatorio")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getListaUniversoGrupo( HttpSession->cIdPontoPar )
			varinfo("HttpSession->cIdPontoPar", HttpSession->cIdPontoPar)
			cRetorno := oPon:cGETLISTAUNIVERSOGRUPORESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax039
Gerar Excel Banco de Horas no protheus_data
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 28/02/2019
@version 2.02
*/
User Function Ajax039()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Gerar Excel")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getExcelBancoHoras( HttpSession->cIdPontoPar, HttpGet->grupo, HttpGet->cc, HttpGet->colaborador )
			varinfo("HttpSession->cIdPontoPar", HttpSession->cIdPontoPar)
			cRetorno := oPon:cGETEXCELBANCOHORASRESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax043
Gera Excel na protheus data
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 28/02/2019
@version 2.02
*/
User Function Ajax043()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Consultar Excel")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getListaExcelArquivo( HttpSession->cIdPontoPar )
			varinfo("HttpSession->cIdPontoPar", HttpSession->cIdPontoPar)
			cRetorno := oPon:cGETLISTAEXCELARQUIVORESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax044
Monta em Json url com o caminho padrão (Ele altera entre homologação e produção.)
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 27/06/2019
@version 2.01
*/
User Function Ajax044()
	local cJson   	:= ""
	local aProp  	:= {'acesso'}
	local cAcessa 	:= "0"
	local i 		:= 0

	showMsg("Acessa relatorios")
	u_ParamPtE()
	aAux := StrTokArr( GetGlbValue( cPARAM_VIEW_REL_BH_EXTRATO ), "-" )
	if len(aAux) > 0
		for i := 1 to len(aAux)
			if aAux[i] == HttpSession->cIdPontoPar
				cAcessa  := "1"
				exit
			endif
		next i
	else
		cAcessa  := "1"
	endif
	U_json( @cJson, {cAcessa}, aProp, 'acessaRelatorio' )

	showMsg("Retorno: ", lDEBUG_CABEC, cJson)
Return cJson

/*
{Protheus.doc} Ajax045
Gerar Excel Banco de Horas no protheus_data
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 28/02/2019
@version 2.02
*/
User Function Ajax045()
	Local cRetorno := ""
	Local oPon	   := Nil

	if ValidUser()
		showMsg("Gerar Excel")

		//Instancia o WS
		oPon := WSWSCSPORTALRH():New()
		WsChgURL(@oPon, "WSCSPORTALRH.APW")

		//Executa o metodo de dados do colaborador
		if oPon:getExcelBancoHorasCusto( HttpSession->cIdPontoPar, HttpGet->grupo, HttpGet->cc, HttpGet->colaborador )
			varinfo("HttpSession->cIdPontoPar", HttpSession->cIdPontoPar)
			cRetorno := oPon:cGETEXCELBANCOHORASCUSTORESULT
		endif

		showMsg("Retorno: ", lDEBUG_CABEC, cRetorno)
	endif
Return(cRetorno)

/*
{Protheus.doc} Ajax046
Monta em Json url com o caminho padrão (Ele altera entre homologação e produção.)
@Return String - Retorna uma lista periodos abertos do funcionario em JSON
@author Bruno Nunes
@since 27/06/2019
@version 2.01
*/
User Function Ajax046()
	local cJson    := ""
	local aProp    := {'acesso'}
	local cAcessa  := "0"
	local i        := 0

	showMsg("Acessa relatorios")
	u_ParamPtE()
	aAux := StrTokArr( GetGlbValue( cPARAM_VIEW_REL_BH_CUSTO ), "-" )
	if len(aAux) > 0
		for i := 1 to len(aAux)
			if aAux[i] == HttpSession->cIdPontoPar
				cAcessa  := "1"
				exit
			endif
		next i
	else
		cAcessa  := "1"
	endif
	U_json( @cJson, {cAcessa}, aProp, 'acessaRelatorio' )

	showMsg("Retorno: ", lDEBUG_CABEC, cJson)
Return cJson