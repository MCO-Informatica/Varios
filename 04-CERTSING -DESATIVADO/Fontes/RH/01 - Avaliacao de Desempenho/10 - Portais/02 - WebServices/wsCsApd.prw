#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'TOPCONN.CH' 


//--------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} WsCsPortalRH
Web Service do Portal do Ponto

@author Bruno Nunes
@since 12/08/2016
@version 1.0
/*/
//--------------------------------------------------------------------------------------------------------------------------------------------
WsService WsCsPortalAPD Description "Web Service do Módulo APD - Customizado para Certisign"
	WsData _IdParticipant					As String
	WsData _IdEvalueted 			  		As String  
	WsData _Date							As Date
	WsData _result				  			As apdAvaCon
	WsData _cChave							As String
	WsData _cResult							As String
	WsData _Media							As Float
	WsMethod getListaAvaliacaoConsenso     	Description "Lista de avaliação de consenso"
	WsMethod getMediaAvaliacaoConsenso     	Description "Media do consenso"	
	WsMethod getCodigoMentor     			Description "Código do Mentor"	
	WsMethod getNomeMentor     				Description "Nome do Mentor"	
	WsMethod getCodigoCc     				Description "Código do Centro de Custo"	
	WsMethod getNomeCc     			   		Description "Nome do Centro de Custo"				
	WsMethod getCodigoLider					Description "Código Líder"				
	WsMethod getNomeLider					Description "Nome Líder"
	WsMethod getDescricaoLegenda			Description "Legenda da média"
EndWsService

WsStruct apdAvaCon
	WsData _cLiderHi As String
	WsData _cDatRet	 As String	
EndWsStruct

//--------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} getFuncionario
Metodo para consultar informaçãoes do
funcionario com retorno em Json

@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal

@Return String em Json
@author Bruno Nunes
@since 05/02/2016
@version 2.0
/*/
//--------------------------------------------------------------------------------------------------------------------------------------------
WsMethod getListaAvaliacaoConsenso WsReceive _IdParticipant, _IdEvalueted, _Date WsSEnd _result WsService WsCsPortalAPD
	local _cSql     := ''
	local _cLiderHi := ''        
	local _cDatRet  := ''
	local cAlias    := getNextAlias()
	local oAux 		:= nil

	_cSql := " SELECT "
	_cSql += "   RDC_CODDOR, RDC_DATRET "
	_cSql += " FROM "
	_cSql += " 	RDC010 "
	_cSql += " WHERE "
	_cSql += "   RDC_FILIAL = '  ' AND "
	_cSql += "   RDC_TIPOAV = '3' AND "
	_cSql += "   RDC_CODADO = '"+::_IdParticipant+"' AND "
	_cSql += "   RDC_CODAVA = '"+::_IdEvalueted+"' AND "
	_cSql += "   RDC_DTIAVA = '"+DtoS(::_Date)+"' AND "
	_cSql += "   D_E_L_E_T_ = ' ' " 
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),cAlias,.F.,.T.)
	                                   
	If (cAlias)->(!EoF())          
		::_result:_cLiderHi := (cAlias)->RDC_CODDOR
		::_result:_cDatRet 	:= (cAlias)->RDC_DATRET
	EndIf
  
	(cAlias)->(DbCloseArea())    
Return(.T.)

//--------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} getFuncionario
Metodo para consultar informaçãoes do
funcionario com retorno em Json

@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal

@Return String em Json
@author Bruno Nunes
@since 05/02/2016
@version 2.0
/*/
//--------------------------------------------------------------------------------------------------------------------------------------------
WsMethod getMediaAvaliacaoConsenso WsReceive _cChave WsSEnd _Media WsService WsCsPortalAPD
	Dbselectarea("RD9")
	//GetAdvFVal - Execução de pesquisa em arquivo ( < cKeyAlias>, < uCpo>, [ uChave], [ nOrder], [ uDef] )
	//RD9_FILIAL+RD9_CODAVA+RD9_CODADO+RD9_CODPRO+DTOS(RD9_DTIAVA)
	::_Media := getadvfval("RD9","RD9_MEDFIN",xFilial("RD9")+::_cChave,1,"")
Return(.T.)

WsMethod getCodigoMentor WsReceive _cChave WsSEnd _cResult WsService WsCsPortalAPD
    ::_cResult := Posicione("RDA",1,xFilial("RDA")+_cChave,"RDA_CODDOR")
Return(.T.)

WsMethod getNomeMentor WsReceive _cChave WsSEnd _cResult WsService WsCsPortalAPD
	::_cResult := Posicione("RD0",1,xFilial("RD0")+_cChave,"RD0_NOME")
Return(.T.)

WsMethod getCodigoCc WsReceive _cChave WsSEnd _cResult WsService WsCsPortalAPD
    ::_cResult := Posicione("RD0",1,xFilial("RD0")+_cChave,"RD0_CC")
Return(.T.)

WsMethod getNomeCc WsReceive _cChave WsSEnd _cResult WsService WsCsPortalAPD
	::_cResult := Posicione("CTT",1,xFilial("CTT")+_cChave,"CTT_DESC01")
Return(.T.)

WsMethod getCodigoLider WsReceive _cChave WsSEnd _cResult WsService WsCsPortalAPD
    ::_cResult := Posicione("RDA",2,xFilial("RDA")+_cChave,"RDA_CODDOR")
Return(.T.)

WsMethod getNomeLider WsReceive _cChave WsSEnd _cResult WsService WsCsPortalAPD
	::_cResult := Posicione("RD0",1,xFilial("RD0")+_cChave,"RD0_NOME")
Return(.T.)

WsMethod getDescricaoLegenda WsReceive _cChave WsSEnd _cResult WsService WsCsPortalAPD
	//Alexandre, trocar aqui para tirar o texto chumbado
	local cTexto := ''

	cTexto := 'A média final de sua avaliação de desempenho considerando o consenso em todos os fatores, será classificada de acordo os seguintes intervalos:  <br>'
	cTexto += '1,00 a 1,94 = abaixo do esperado <br>'
	cTexto += '1,95 a 2,59 = esperado <br>'
	cTexto += '2,60 a 3,00 = acima do esperado  <br>'

	::_cResult := cTexto
	
	//Alexandre, fim da alteração
Return(.T.)
                                                                                      
