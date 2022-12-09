#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP?wsdl
Gerado em        02/14/13 14:47:19
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.110425
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _MCROSYG ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSIntegracaoGARERPImplService
------------------------------------------------------------------------------- */

WSCLIENT WSIntegracaoGARERPImplService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD verificaExistenciaPermissaoSac
	WSMETHOD listaARs
	WSMETHOD listaARsPorAC
	WSMETHOD detalhesPosto
	WSMETHOD detalhesPostobyCpfAgente
	WSMETHOD findDadosPedido
	WSMETHOD postosParaCpfAgenteComEntregaHW
	WSMETHOD consultaDadosCertificadoPorPedido
	WSMETHOD postosParaIdAR
	WSMETHOD listarTrilhasDeAuditoriaParaIdPedido
	WSMETHOD findPedidosByCPFCNPJ
	WSMETHOD listarProdutosAtivos
	WSMETHOD listaARsPorRede
	WSMETHOD consultaAgente	
	WSMETHOD listarACs
	WSMETHOD agentesComEntregaHWParaIdPosto
	WSMETHOD listarRevendedor
	WSMETHOD consultaCadastroCompletoAgente
	WSMETHOD agentesParaIdPosto
	
	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cuser                     AS string
	WSDATA   cpassword                 AS string
	WSDATA   ccpf                      AS string
	WSDATA   lreturn                   AS boolean
	WSDATA   oWSar                     AS IntegracaoGARERPImplService_ar
	WSDATA   carg0                     AS string
	WSDATA   carg1                     AS string
	WSDATA   narg2                     AS long
	WSDATA   nidPosto                  AS long
	WSDATA   oWSposto                  AS IntegracaoGARERPImplService_posto
	WSDATA   ccpfAgente                AS string
	WSDATA   ncpfcnpj                  AS long
	WSDATA   nid                       AS long
	WSDATA   oWSdadosPedido            AS IntegracaoGARERPImplService_dadosPedido
	WSDATA   oWSdadosCertificado       AS IntegracaoGARERPImplService_dadosCertificado
	WSDATA   oWSauditoriaInfo          AS IntegracaoGARERPImplService_auditoriaInfo
	WSDATA   oWSproduto                AS IntegracaoGARERPImplService_produto
	WSDATA   oWSagente                 AS Array of IntegracaoGARERPImplService_agente
	WSDATA   oWSrevendedor             AS IntegracaoGARERPImplService_revendedores
	WSDATA   oWSac                     AS IntegracaoGARERPImplService_ac
	WSDATA   cid		               AS string  
	WSDATA   car	                   AS Array of String
	WSDATA   oWsIdPedido               AS IntegracaoGARERPImplService_idPedido
ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSIntegracaoGARERPImplService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.120420A-20120726] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSIntegracaoGARERPImplService
	::car                := {} // Array Of  ""
	::oWSposto           := {} // Array Of  IntegracaoGARERPImplService_POSTO():New()
	::oWSdadosPedido     := IntegracaoGARERPImplService_DADOSPEDIDO():New()
	::oWSdadosCertificado := IntegracaoGARERPImplService_DADOSCERTIFICADO():New()
	::oWSauditoriaInfo   := {} // Array Of  IntegracaoGARERPImplService_AUDITORIAINFO():New()
	::oWSproduto         := {} // Array Of  IntegracaoGARERPImplService_PRODUTO():New()
	::oWSagente          := {} //IntegracaoGARERPImplService_AGENTE():New()
	::oWSac              := {} // Array Of  IntegracaoGARERPImplService_AC():New()
	::oWSrevendedor      := {} // Array Of  IntegracaoGARERPImplService_REVENDEDORES():New()
	::oWsIdPedido        := {} // Array Of  IntegracaoGARERPImplService_idPedido():New()
Return

WSMETHOD RESET WSCLIENT WSIntegracaoGARERPImplService
	::cuser              := NIL 
	::cpassword          := NIL 
	::ccpf               := NIL 
	::lreturn            := NIL 
	::car                := NIL
	::carg0              := NIL 
	::carg1              := NIL 
	::narg2              := NIL 
 	::ccpfAgente         := NIL 
	::nidPosto           := NIL
	::oWSgrupo           := NIL 
	::nid                := NIL 
	::oWSdadosPedido     := NIL 
	::oWSposto           := NIL 
	::oWSauditoriaInfo   := NIL 
	::oWSproduto         := NIL 
	::oWSagente          := NIL 
	::oWSrevendedor      := NIL 
	::oWSdadosCertificado := NIL 
	::npedid             := NIL 
	::ncpfcnpj           := NIL 
	::oWSac              := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSIntegracaoGARERPImplService
Local oClone := WSIntegracaoGARERPImplService():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cuser         := ::cuser
	oClone:cpassword     := ::cpassword
	oClone:ccpf          := ::ccpf
	oClone:lreturn       := ::lreturn
	oClone:car           :=  IIF(::car = NIL , NIL ,::car:Clone() )
	oClone:oWSposto      :=  IIF(::oWSposto = NIL , NIL ,::oWSposto:Clone() )
	oClone:nid           := ::nid
	oClone:oWSdadosPedido :=  IIF(::oWSdadosPedido = NIL , NIL ,::oWSdadosPedido:Clone() )
	oClone:oWSauditoriaInfo :=  IIF(::oWSauditoriaInfo = NIL , NIL ,::oWSauditoriaInfo:Clone() )
	oClone:oWSproduto    :=  IIF(::oWSproduto = NIL , NIL ,::oWSproduto:Clone() )
	oClone:oWSagente     :=  IIF(::oWSagente = NIL , NIL ,::oWSagente:Clone() )
	oClone:oWSrevendedor :=  IIF(::oWSrevendedor = NIL , NIL ,::oWSrevendedor:Clone() )
	oClone:oWSdadosCertificado :=  IIF(::oWSdadosCertificado = NIL , NIL ,::oWSdadosCertificado:Clone() )
	oClone:carg0         := ::carg0
	oClone:carg1         := ::carg1
	oClone:narg2         := ::narg2
	oClone:ccpfAgente    := ::ccpfAgente
	oClone:ncpfcnpj      := ::ncpfcnpj
	oClone:oWSac         :=  IIF(::oWSac = NIL , NIL ,::oWSac:Clone() )
Return oClone

// WSDL Method verificaExistenciaPermissaoSac of Service WSIntegracaoGARERPImplService

WSMETHOD verificaExistenciaPermissaoSac WSSEND cuser,cpassword,ccpf WSRECEIVE lreturn WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local cXWSGAR := GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<verificaExistenciaPermissaoSac xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("cpf", ::ccpf, ccpf , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</verificaExistenciaPermissaoSac>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
::lreturn            :=  WSAdvValue( oXmlRet,"_NS2_VERIFICAEXISTENCIAPERMISSAOSACRESPONSE:_RETURN:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,"tns") 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listaARs of Service WSIntegracaoGARERPImplService

WSMETHOD listaARs WSSEND cuser,cpassword WSRECEIVE car WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<listaARs xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</listaARs>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_NS2_LISTAARSRESPONSE:_RETURN","ar",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::car,IntegracaoGARERPImplService_ar():New()) , ::car[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listaARsPorAC of Service WSIntegracaoGARERPImplService

WSMETHOD listaARsPorAC WSSEND carg0,carg1,narg2 WSRECEIVE car WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<listaARsPorAC xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("arg0", ::carg0, carg0 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("arg1", ::carg1, carg1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("arg2", ::narg2, narg2 , "long", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</listaARsPorAC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_NS2_LISTAARSPORACRESPONSE:_RETURN","ar",NIL,NIL,NIL,NIL,NIL,"tns") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::car,IntegracaoGARERPImplService_ar():New()) , ::car[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listaARsPorRede of Service WSIntegracaoGARERPImplService

WSMETHOD listaARsPorRede WSSEND carg0,carg1,narg2 WSRECEIVE car WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<listaARsPorRede xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("arg0", ::carg0, carg0 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("arg1", ::carg1, carg1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("arg2", ::narg2, narg2 , "long", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</listaARsPorRede>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_NS2_LISTAARSPORREDERESPONSE:_RETURN","ar",NIL,NIL,NIL,NIL,NIL,"tns") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::car,IntegracaoGARERPImplService_ar():New()) , ::car[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Method findDadosPedido of Service WSIntegracaoGARERPImplService

WSMETHOD findDadosPedido WSSEND cuser,cpassword,nid WSRECEIVE oWSdadosPedido WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<findDadosPedido xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("id", ::nid, nid , "long", .F. , .F., 0 , NIL, .T.) 
cSoap += "</findDadosPedido>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
::oWSdadosPedido:SoapRecv( WSAdvValue( oXmlRet,"_NS2_FINDDADOSPEDIDORESPONSE:_RETURN","dadosPedido",NIL,NIL,NIL,NIL,NIL,"tns") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method detalhesPostobyCpfAgente of Service WSIntegracaoGARERPImplService

WSMETHOD detalhesPostobyCpfAgente WSSEND cuser,cpassword,ccpfAgente WSRECEIVE oWSposto WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<detalhesPostobyCpfAgente xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cpfAgente", ::ccpfAgente, ccpfAgente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</detalhesPostobyCpfAgente>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_NS2_DETALHESPOSTOBYCPFAGENTERESPONSE:_RETURN","posto",NIL,NIL,NIL,NIL,NIL,"tns") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWSposto,IntegracaoGARERPImplService_posto():New()) , ::oWSposto[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method detalhesPosto of Service WSIntegracaoGARERPImplService

WSMETHOD detalhesPosto WSSEND cuser,cpassword,nidPosto WSRECEIVE oWSposto WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet 
Local oATmp01
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<detalhesPosto xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("idPosto", ::nidPosto, nidPosto , "long", .F. , .F., 0 , NIL, .T.)
cSoap += "</detalhesPosto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()

oATmp01 := WSAdvValue( oXmlRet,"_NS2_DETALHESPOSTORESPONSE:_RETURN","posto",NIL,NIL,NIL,NIL,NIL,"tns")

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSposto,IntegracaoGARERPImplService_posto():New()) , ::oWSposto[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method postosParaCpfAgenteComEntregaHW of Service WSIntegracaoGARERPImplService

WSMETHOD postosParaCpfAgenteComEntregaHW WSSEND cuser,cpassword,ccpf WSRECEIVE oWSposto WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<postosParaCpfAgenteComEntregaHW xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("cpf", ::ccpf, ccpf , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</postosParaCpfAgenteComEntregaHW>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 := WSAdvValue( oXmlRet,"_NS2_POSTOSPARACPFAGENTECOMENTREGAHWRESPONSE:_RETURN","posto",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSposto,IntegracaoGARERPImplService_posto():New()) , ::oWSposto[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method postosParaIdAR of Service WSIntegracaoGARERPImplService

WSMETHOD postosParaIdAR WSSEND cuser,cpassword,cid WSRECEIVE oWSposto WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
//Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<postosParaIdAR xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("id", ::cid, cid , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</postosParaIdAR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 := WSAdvValue( oXmlRet,"_NS2_POSTOSPARAIDARRESPONSE:_RETURN","posto",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSposto,IntegracaoGARERPImplService_posto():New()) , ::oWSposto[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listarTrilhasDeAuditoriaParaIdPedido of Service WSIntegracaoGARERPImplService

WSMETHOD listarTrilhasDeAuditoriaParaIdPedido WSSEND cuser,cpassword,nid WSRECEIVE oWSauditoriaInfo WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
//Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<listarTrilhasDeAuditoriaParaIdPedido xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("id", ::nid, nid , "long", .F. , .F., 0 , NIL, .T.) 
cSoap += "</listarTrilhasDeAuditoriaParaIdPedido>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 := WSAdvValue( oXmlRet,"_NS2_LISTARTRILHASDEAUDITORIAPARAIDPEDIDORESPONSE:_RETURN","auditoriaInfo",NIL,NIL,NIL,NIL,NIL,"tns") 
If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSauditoriaInfo,IntegracaoGARERPImplService_auditoriaInfo():New()) , ::oWSauditoriaInfo[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listarProdutosAtivos of Service WSIntegracaoGARERPImplService

WSMETHOD listarProdutosAtivos WSSEND cuser,cpassword WSRECEIVE oWSproduto WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
//Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<listarProdutosAtivos xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</listarProdutosAtivos>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 := WSAdvValue( oXmlRet,"_NS2_LISTARPRODUTOSATIVOSRESPONSE:_RETURN","produto",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSproduto,IntegracaoGARERPImplService_produto():New()) , ::oWSproduto[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method agentesComEntregaHWParaIdPosto of Service WSIntegracaoGARERPImplService

WSMETHOD agentesComEntregaHWParaIdPosto WSSEND cuser,cpassword,nid WSRECEIVE oWSagente WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
//Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<agentesComEntregaHWParaIdPosto xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("id", ::nid, nid , "long", .F. , .F., 0 , NIL, .T.) 
cSoap += "</agentesComEntregaHWParaIdPosto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 := WSAdvValue( oXmlRet,"_NS2_AGENTESCOMENTREGAHWPARAIDPOSTORESPONSE:_RETURN","agente",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSagente,IntegracaoGARERPImplService_agente():New()) , ::oWSagente[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method agentesParaIdPosto of Service WSIntegracaoGARERPImplService

WSMETHOD agentesParaIdPosto WSSEND cuser,cpassword,nid WSRECEIVE oWSagente WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local oATmp01
//Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar-teste.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<agentesParaIdPosto xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("id", ::nid, nid , "long", .F. , .F., 0 , NIL, .T.) 
cSoap += "</agentesParaIdPosto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 := WSAdvValue( oXmlRet,"_NS2_AGENTESPARAIDPOSTORESPONSE:_RETURN","agente",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSagente,IntegracaoGARERPImplService_agente():New()) , ::oWSagente[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listarRevendedor of Service WSIntegracaoGARERPImplService

WSMETHOD listarRevendedor WSSEND cuser,cpassword,nId WSRECEIVE oWSrevendedor WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
//Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

Private oATmp01

BEGIN WSMETHOD

cSoap += '<listarRevendedor xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("idRevendedor", ::nid, nid , "long", .F. , .F., 0 , NIL, .T.) 
cSoap += "</listarRevendedor>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 := WSAdvValue( oXmlRet,"_NS2_LISTARREVENDEDORRESPONSE:_RETURN","revendedores",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}	
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSrevendedor,IntegracaoGARERPImplService_revendedores():New()) , ::oWSrevendedor[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Data Structure ar

WSSTRUCT IntegracaoGARERPImplService_ar
	WSDATA   carOrganizacional         AS string OPTIONAL
	WSDATA   latendimento              AS boolean OPTIONAL
	WSDATA   lativo                    AS boolean OPTIONAL
	WSDATA   ccn                       AS string OPTIONAL
	WSDATA   ncnpj                     AS long OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cdiretorio                AS string OPTIONAL
	WSDATA   cid                       AS string OPTIONAL
	WSDATA   cmunicipio                AS string OPTIONAL
	WSDATA   cnomeFantasia             AS string OPTIONAL
	WSDATA   creplyTo                  AS string OPTIONAL
	WSDATA   csite                     AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_ar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_ar
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_ar
	Local oClone := IntegracaoGARERPImplService_ar():NEW()
	oClone:carOrganizacional    := ::carOrganizacional
	oClone:latendimento         := ::latendimento
	oClone:lativo               := ::lativo
	oClone:ccn                  := ::ccn
	oClone:ncnpj                := ::ncnpj
	oClone:cdescricao           := ::cdescricao
	oClone:cdiretorio           := ::cdiretorio
	oClone:cid                  := ::cid
	oClone:cmunicipio           := ::cmunicipio
	oClone:cnomeFantasia        := ::cnomeFantasia
	oClone:creplyTo             := ::creplyTo
	oClone:csite                := ::csite
	oClone:cuf                  := ::cuf
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_ar
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::carOrganizacional  :=  WSAdvValue( oResponse,"_ARORGANIZACIONAL","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::latendimento       :=  WSAdvValue( oResponse,"_ATENDIMENTO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lativo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::ccn                :=  WSAdvValue( oResponse,"_CN","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ncnpj              :=  WSAdvValue( oResponse,"_CNPJ","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdiretorio         :=  WSAdvValue( oResponse,"_DIRETORIO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cid                :=  WSAdvValue( oResponse,"_ID","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cmunicipio         :=  WSAdvValue( oResponse,"_MUNICIPIO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cnomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::creplyTo           :=  WSAdvValue( oResponse,"_REPLYTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::csite              :=  WSAdvValue( oResponse,"_SITE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cuf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"tns") 
Return

// WSDL Data Structure dadosPedido
WSSTRUCT IntegracaoGARERPImplService_dadosPedido
	WSDATA   cacDesc                   AS string OPTIONAL
	WSDATA   carDesc                   AS string OPTIONAL
	WSDATA   carId                     AS string OPTIONAL
	WSDATA   carValidacao              AS string OPTIONAL
	WSDATA   carValidacaoDesc          AS string OPTIONAL
	WSDATA   ncnpjCert                 AS long OPTIONAL
	WSDATA   ncodigoParceiro           AS long OPTIONAL
	WSDATA   ncodigoRevendedor         AS long OPTIONAL
	WSDATA   ncomissaoParceiroHW       AS long OPTIONAL
	WSDATA   ncomissaoParceiroSW       AS long OPTIONAL
	WSDATA   ncpfAgenteValidacao       AS long OPTIONAL
	WSDATA   ncpfAgenteVerificacao     AS long OPTIONAL
	WSDATA   ncpfTitular               AS long OPTIONAL
	WSDATA   cdataEmissao              AS string OPTIONAL
	WSDATA	 cdataExpiracao			   AS string OPTIONAL
	WSDATA   cdataPedido               AS string OPTIONAL
	WSDATA   cdataValidacao            AS string OPTIONAL
	WSDATA   cdataVerificacao          AS string OPTIONAL
	WSDATA   cdescricaoParceiro        AS string OPTIONAL
	WSDATA   cdescricaoRedeParceiro    AS string OPTIONAL
	WSDATA   cdescricaoRevendedor      AS string OPTIONAL
	WSDATA   cemailTitular             AS string OPTIONAL
	WSDATA   cgrupo                    AS string OPTIONAL
	WSDATA   cgrupoDescricao           AS string OPTIONAL
	WSDATA   nidRede                   AS long OPTIONAL
	WSDATA   cnomeAgenteValidacao      AS string OPTIONAL
	WSDATA   cnomeAgenteVerificacao    AS string OPTIONAL
	WSDATA   cnomeTitular              AS string OPTIONAL
	WSDATA   npedido                   AS long OPTIONAL
	WSDATA   npedid                   	AS long OPTIONAL
	WSDATA   npedidoAntigo             AS long OPTIONAL
	WSDATA   cpostoValidacaoDesc       AS string OPTIONAL
	WSDATA   npostoValidacaoId         AS long OPTIONAL
	WSDATA   cpostoVerificacaoDesc     AS string OPTIONAL
	WSDATA   npostoVerificacaoId       AS long OPTIONAL
	WSDATA   cproduto                  AS string OPTIONAL
	WSDATA   cprodutoDesc              AS string OPTIONAL
	WSDATA   crazaoSocialCert          AS string OPTIONAL
	WSDATA   crede                     AS string OPTIONAL
	WSDATA   cstatus                   AS string OPTIONAL
	WSDATA   cstatusDesc               AS string OPTIONAL
	WSDATA   nstatusRevendedor         AS int OPTIONAL
	WSDATA   ntipoParceiro             AS int OPTIONAL
	WSDATA   cufTitular                AS string OPTIONAL
	WSDATA   cdataNascimento           AS string OPTIONAL
	WSDATA   crevogacao                AS string OPTIONAL
	WSDATA   crg                       AS string OPTIONAL
	WSDATA   cstatusCertificado        AS string OPTIONAL
	WSDATA   ctituloEleitor            AS string OPTIONAL
	WSDATA   ctituloEleitorMunicipio   AS string OPTIONAL
	WSDATA   ctituloEleitorSecao       AS string OPTIONAL
	WSDATA   ctituloEleitorUf          AS string OPTIONAL
	WSDATA   ctituloEleitorZona        AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   cufCnpj                   AS string OPTIONAL
	WSDATA   cvalidoAte                AS string OPTIONAL
	WSDATA   cvalidoDe                 AS string OPTIONAL
	WSDATA   corgaoExpedidorRg         AS string OPTIONAL
	WSDATA   cpisPasep                 AS string OPTIONAL
	WSDATA   crazaoSocial              AS string OPTIONAL
	WSDATA   ccidadeCnpj               AS string OPTIONAL
	WSDATA   cceiPJ                    AS string OPTIONAL
	WSDATA   cnumeroSerie              AS string OPTIONAL
	WSDATA   oWSrepresentantes         AS IntegracaoGARERPImplService_representantes OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_dadosPedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_dadosPedido
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_dadosPedido
	Local oClone := IntegracaoGARERPImplService_dadosPedido():NEW()
	oClone:cacDesc              := ::cacDesc
	oClone:carDesc              := ::carDesc
	oClone:carId                := ::carId
	oClone:carValidacao         := ::carValidacao
	oClone:carValidacaoDesc     := ::carValidacaoDesc
	oClone:ncnpjCert            := ::ncnpjCert
	oClone:ncodigoParceiro      := ::ncodigoParceiro
	oClone:ncodigoRevendedor    := ::ncodigoRevendedor
	oClone:ncomissaoParceiroHW  := ::ncomissaoParceiroHW
	oClone:ncomissaoParceiroSW  := ::ncomissaoParceiroSW
	oClone:ncpfAgenteValidacao  := ::ncpfAgenteValidacao
	oClone:ncpfAgenteVerificacao := ::ncpfAgenteVerificacao
	oClone:ncpfTitular          := ::ncpfTitular
	oClone:cdataEmissao         := ::cdataEmissao
	oClone:cdataExpiracao       := ::cdataExpiracao
	oClone:cdataPedido          := ::cdataPedido
	oClone:cdataValidacao       := ::cdataValidacao
	oClone:cdataVerificacao     := ::cdataVerificacao
	oClone:cdescricaoParceiro   := ::cdescricaoParceiro
	oClone:cdescricaoRedeParceiro := ::cdescricaoRedeParceiro
	oClone:cdescricaoRevendedor := ::cdescricaoRevendedor
	oClone:cemailTitular        := ::cemailTitular
	oClone:cgrupo               := ::cgrupo
	oClone:cgrupoDescricao      := ::cgrupoDescricao
	oClone:nidRede              := ::nidRede
	oClone:cnomeAgenteValidacao := ::cnomeAgenteValidacao
	oClone:cnomeAgenteVerificacao := ::cnomeAgenteVerificacao
	oClone:cnomeTitular         := ::cnomeTitular
	oClone:npedido              := ::npedido
	oClone:npedidoAntigo        := ::npedidoAntigo
	oClone:cpostoValidacaoDesc  := ::cpostoValidacaoDesc
	oClone:npostoValidacaoId    := ::npostoValidacaoId
	oClone:cpostoVerificacaoDesc := ::cpostoVerificacaoDesc
	oClone:npostoVerificacaoId  := ::npostoVerificacaoId
	oClone:cproduto             := ::cproduto
	oClone:cprodutoDesc         := ::cprodutoDesc
	oClone:crazaoSocialCert     := ::crazaoSocialCert
	oClone:crede                := ::crede
	oClone:cstatus              := ::cstatus
	oClone:cstatusDesc          := ::cstatusDesc
	oClone:nstatusRevendedor    := ::nstatusRevendedor
	oClone:ntipoParceiro        := ::ntipoParceiro
	oClone:cufTitular           := ::cufTitular
	oClone:cdataNascimento      := ::cdataNascimento
	oClone:crevogacao           := ::crevogacao
	oClone:crg                  := ::crg
	oClone:cstatus              := ::cstatus
	oClone:cstatusCertificado   := ::cstatusCertificado
	oClone:cstatusDesc          := ::cstatusDesc
	oClone:nstatusRevendedor    := ::nstatusRevendedor
	oClone:ntipoParceiro        := ::ntipoParceiro
	oClone:ctituloEleitor       := ::ctituloEleitor
	oClone:ctituloEleitorMunicipio := ::ctituloEleitorMunicipio
	oClone:ctituloEleitorSecao  := ::ctituloEleitorSecao
	oClone:ctituloEleitorUf     := ::ctituloEleitorUf
	oClone:ctituloEleitorZona   := ::ctituloEleitorZona
	oClone:cuf                  := ::cuf
	oClone:cufCnpj              := ::cufCnpj
	oClone:cufTitular           := ::cufTitular
	oClone:cvalidoAte           := ::cvalidoAte
	oClone:cvalidoDe            := ::cvalidoDe
	oClone:corgaoExpedidorRg    := ::corgaoExpedidorRg
	oClone:cpisPasep            := ::cpisPasep
	oClone:crazaoSocial         := ::crazaoSocial
	oClone:ccidadeCnpj          := ::ccidadeCnpj
	oClone:cceiPJ               := ::cceiPJ
	oClone:cnumeroSerie         := ::cnumeroSerie
	oClone:oWSrepresentantes    := IIF(::oWSrepresentantes = NIL , NIL , ::oWSrepresentantes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_dadosPedido
	Local oNode72
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cacDesc            :=  WSAdvValue( oResponse,"_ACDESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::carDesc            :=  WSAdvValue( oResponse,"_ARDESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::carId              :=  WSAdvValue( oResponse,"_ARID","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::carValidacao       :=  WSAdvValue( oResponse,"_ARVALIDACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::carValidacaoDesc   :=  WSAdvValue( oResponse,"_ARVALIDACAODESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ncnpjCert          :=  WSAdvValue( oResponse,"_CNPJCERT","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ncodigoParceiro    :=  WSAdvValue( oResponse,"_CODIGOPARCEIRO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ncodigoRevendedor  :=  WSAdvValue( oResponse,"_CODIGOREVENDEDOR","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ncomissaoParceiroHW :=  WSAdvValue( oResponse,"_COMISSAOPARCEIROHW","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ncomissaoParceiroSW :=  WSAdvValue( oResponse,"_COMISSAOPARCEIROSW","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ncpfAgenteValidacao :=  WSAdvValue( oResponse,"_CPFAGENTEVALIDACAO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ncpfAgenteVerificacao :=  WSAdvValue( oResponse,"_CPFAGENTEVERIFICACAO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ncpfTitular        :=  WSAdvValue( oResponse,"_CPFTITULAR","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cdataEmissao       :=  WSAdvValue( oResponse,"_DATAEMISSAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataExpiracao     :=  WSAdvValue( oResponse,"_DATAEXPIRACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataPedido        :=  WSAdvValue( oResponse,"_DATAPEDIDO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataValidacao     :=  WSAdvValue( oResponse,"_DATAVALIDACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataVerificacao   :=  WSAdvValue( oResponse,"_DATAVERIFICACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdescricaoParceiro :=  WSAdvValue( oResponse,"_DESCRICAOPARCEIRO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdescricaoRedeParceiro :=  WSAdvValue( oResponse,"_DESCRICAOREDEPARCEIRO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdescricaoRevendedor :=  WSAdvValue( oResponse,"_DESCRICAOREVENDEDOR","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cemailTitular      :=  WSAdvValue( oResponse,"_EMAILTITULAR","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cgrupo             :=  WSAdvValue( oResponse,"_GRUPO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cgrupoDescricao    :=  WSAdvValue( oResponse,"_GRUPODESCRICAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nidRede            :=  WSAdvValue( oResponse,"_IDREDE","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cnomeAgenteValidacao :=  WSAdvValue( oResponse,"_NOMEAGENTEVALIDACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cnomeAgenteVerificacao :=  WSAdvValue( oResponse,"_NOMEAGENTEVERIFICACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cnomeTitular       :=  WSAdvValue( oResponse,"_NOMETITULAR","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::npedido            :=  WSAdvValue( oResponse,"_PEDIDO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::npedidoAntigo      :=  WSAdvValue( oResponse,"_PEDIDOANTIGO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cpostoValidacaoDesc :=  WSAdvValue( oResponse,"_POSTOVALIDACAODESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::npostoValidacaoId  :=  WSAdvValue( oResponse,"_POSTOVALIDACAOID","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cpostoVerificacaoDesc :=  WSAdvValue( oResponse,"_POSTOVERIFICACAODESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::npostoVerificacaoId :=  WSAdvValue( oResponse,"_POSTOVERIFICACAOID","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cproduto           :=  WSAdvValue( oResponse,"_PRODUTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cprodutoDesc       :=  WSAdvValue( oResponse,"_PRODUTODESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crazaoSocialCert   :=  WSAdvValue( oResponse,"_RAZAOSOCIALCERT","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crede              :=  WSAdvValue( oResponse,"_REDE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cstatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cstatusDesc        :=  WSAdvValue( oResponse,"_STATUSDESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nstatusRevendedor  :=  WSAdvValue( oResponse,"_STATUSREVENDEDOR","int",NIL,NIL,NIL,"N",NIL,"tns") 
	::ntipoParceiro      :=  WSAdvValue( oResponse,"_TIPOPARCEIRO","int",NIL,NIL,NIL,"N",NIL,"tns") 
	::cufTitular         :=  WSAdvValue( oResponse,"_UFTITULAR","string",NIL,NIL,NIL,"S",NIL,"tns")
	::cdataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","string",NIL,NIL,NIL,"S",NIL,"tns")
	::crevogacao         :=  WSAdvValue( oResponse,"_REVOGACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crg                :=  WSAdvValue( oResponse,"_RG","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cstatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cstatusCertificado :=  WSAdvValue( oResponse,"_STATUSCERTIFICADO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cstatusDesc        :=  WSAdvValue( oResponse,"_STATUSDESC","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nstatusRevendedor  :=  WSAdvValue( oResponse,"_STATUSREVENDEDOR","int",NIL,NIL,NIL,"N",NIL,"tns") 
	::ntipoParceiro      :=  WSAdvValue( oResponse,"_TIPOPARCEIRO","int",NIL,NIL,NIL,"N",NIL,"tns") 
	::ctituloEleitor     :=  WSAdvValue( oResponse,"_TITULOELEITOR","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorMunicipio :=  WSAdvValue( oResponse,"_TITULOELEITORMUNICIPIO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorSecao :=  WSAdvValue( oResponse,"_TITULOELEITORSECAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorUf   :=  WSAdvValue( oResponse,"_TITULOELEITORUF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorZona :=  WSAdvValue( oResponse,"_TITULOELEITORZONA","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cuf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cufCnpj            :=  WSAdvValue( oResponse,"_UFCNPJ","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cufTitular         :=  WSAdvValue( oResponse,"_UFTITULAR","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cvalidoAte         :=  WSAdvValue( oResponse,"_VALIDOATE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cvalidoDe          :=  WSAdvValue( oResponse,"_VALIDODE","string",NIL,NIL,NIL,"S",NIL,"tns")
	::corgaoExpedidorRg  :=  WSAdvValue( oResponse,"_ORGAOEXPEDIDORRG","string",NIL,NIL,NIL,"S",NIL,"tns")
	::cpisPasep          :=  WSAdvValue( oResponse,"_PISPASEP","string",NIL,NIL,NIL,"S",NIL,"tns")
	::crazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,"tns")
	::ccidadeCnpj        :=  WSAdvValue( oResponse,"_CIDADECNPJ","string",NIL,NIL,NIL,"S",NIL,"tns")
	::cceiPJ             :=  WSAdvValue( oResponse,"_CEIPJ","string",NIL,NIL,NIL,"S",NIL,"tns")
	::cnumeroSerie       :=  WSAdvValue( oResponse,"_NUMEROSERIE","string",NIL,NIL,NIL,"S",NIL,"tns")
	oNode72 :=  WSAdvValue( oResponse,"_REPRESENTANTES","representantes",NIL,NIL,NIL,"O",NIL,"tns") 
	If oNode72 != NIL
		::oWSrepresentantes := IntegracaoGARERPImplService_representantes():New()
		::oWSrepresentantes:SoapRecv(oNode72)
	EndIf
Return

// WSDL Data Structure representantes

WSSTRUCT IntegracaoGARERPImplService_representantes
	WSDATA   oWSrepresentante          AS IntegracaoGARERPImplService_representante OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_representantes
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_representantes
	::oWSrepresentante     := {} // Array Of  IntegracaoGARERPImplService_REPRESENTANTE():New()
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_representantes
	Local oClone := IntegracaoGARERPImplService_representantes():NEW()
	oClone:oWSrepresentante := NIL
	If ::oWSrepresentante <> NIL 
		oClone:oWSrepresentante := {}
		aEval( ::oWSrepresentante , { |x| aadd( oClone:oWSrepresentante , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_representantes
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REPRESENTANTE","representante",{},NIL,.T.,"O",NIL,"tns") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSrepresentante , IntegracaoGARERPImplService_representante():New() )
			::oWSrepresentante[len(::oWSrepresentante)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure representante

WSSTRUCT IntegracaoGARERPImplService_representante
	WSDATA   ccodUsuario               AS string OPTIONAL
	WSDATA   ncpf                      AS long OPTIONAL
	WSDATA   cdataEmissaoRg            AS string OPTIONAL
	WSDATA   cdataInsercao             AS string OPTIONAL
	WSDATA   cdataNascimento           AS string OPTIONAL
	WSDATA   cdataUltimaAtualizacao    AS string OPTIONAL
	WSDATA   cincapaz                  AS string OPTIONAL
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   corgarEmissoRg            AS string OPTIONAL
	WSDATA   npedido                   AS long OPTIONAL
	WSDATA   crg                       AS string OPTIONAL
	WSDATA   cufRg                     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_representante
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_representante
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_representante
	Local oClone := IntegracaoGARERPImplService_representante():NEW()
	oClone:ccodUsuario          := ::ccodUsuario
	oClone:ncpf                 := ::ncpf
	oClone:cdataEmissaoRg       := ::cdataEmissaoRg
	oClone:cdataInsercao        := ::cdataInsercao
	oClone:cdataNascimento      := ::cdataNascimento
	oClone:cdataUltimaAtualizacao := ::cdataUltimaAtualizacao
	oClone:cincapaz             := ::cincapaz
	oClone:cnome                := ::cnome
	oClone:corgarEmissoRg       := ::corgarEmissoRg
	oClone:npedido              := ::npedido
	oClone:crg                  := ::crg
	oClone:cufRg                := ::cufRg
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_representante
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ccodUsuario        :=  WSAdvValue( oResponse,"_CODUSUARIO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ncpf               :=  WSAdvValue( oResponse,"_CPF","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cdataEmissaoRg     :=  WSAdvValue( oResponse,"_DATAEMISSAORG","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataInsercao      :=  WSAdvValue( oResponse,"_DATAINSERCAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataUltimaAtualizacao :=  WSAdvValue( oResponse,"_DATAULTIMAATUALIZACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cincapaz           :=  WSAdvValue( oResponse,"_INCAPAZ","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cnome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::corgarEmissoRg     :=  WSAdvValue( oResponse,"_ORGAREMISSORG","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::npedido            :=  WSAdvValue( oResponse,"_PEDIDO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::crg                :=  WSAdvValue( oResponse,"_RG","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cufRg              :=  WSAdvValue( oResponse,"_UFRG","string",NIL,NIL,NIL,"S",NIL,"tns") 
Return

// WSDL Data Structure posto

WSSTRUCT IntegracaoGARERPImplService_posto
	WSDATA   carId                     AS string OPTIONAL
	WSDATA   latendimento              AS boolean OPTIONAL
	WSDATA   lativo                    AS boolean OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   ncep                      AS long OPTIONAL
	WSDATA   ccidade                   AS string OPTIONAL
	WSDATA   ccnpj                     AS string OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cemailAgendamento         AS string OPTIONAL
	WSDATA   cendereco                 AS string OPTIONAL
	WSDATA   nid                       AS long OPTIONAL
	WSDATA   nidRede                   AS long OPTIONAL
	WSDATA   cnomeFantasia             AS string OPTIONAL
	WSDATA   npostoOrganizacional      AS long OPTIONAL
	WSDATA   crazaoSocial              AS string OPTIONAL
	WSDATA   crede                     AS string OPTIONAL
	WSDATA   ntelefone                 AS long OPTIONAL
	WSDATA   ntipo                     AS int OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   lvendasHw                 AS boolean OPTIONAL
	WSDATA   lvisibilidade             AS boolean OPTIONAL
	WSDATA   clatitude		           AS string OPTIONAL
	WSDATA   clongitude		           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_posto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_posto
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_posto
	//::Init()
	//If oResponse = NIL ; Return ; Endif 
	Local oClone := IntegracaoGARERPImplService_posto():NEW()
	::carId              :=  WSAdvValue( oResponse,"_ARID","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::latendimento       :=  WSAdvValue( oResponse,"_ATENDIMENTO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lativo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::cbairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ncep               :=  WSAdvValue( oResponse,"_CEP","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ccidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ccnpj              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cemailAgendamento  :=  WSAdvValue( oResponse,"_EMAILAGENDAMENTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cendereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nid                :=  WSAdvValue( oResponse,"_ID","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::nidRede            :=  WSAdvValue( oResponse,"_IDREDE","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cnomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::npostoOrganizacional :=  WSAdvValue( oResponse,"_POSTOORGANIZACIONAL","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::crazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crede              :=  WSAdvValue( oResponse,"_REDE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ntelefone          :=  WSAdvValue( oResponse,"_TELEFONE","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ntipo              :=  WSAdvValue( oResponse,"_TIPO","int",NIL,NIL,NIL,"N",NIL,"tns") 
	::cuf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::lvendasHw          :=  WSAdvValue( oResponse,"_VENDASHW","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lvisibilidade      :=  WSAdvValue( oResponse,"_VISIBILIDADE","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::clatitude          :=  WSAdvValue( oResponse,"_LATITUDE","string",NIL,NIL,NIL,"S",NIL,"tns")
	::clongitude         :=  WSAdvValue( oResponse,"_LONGITUDE","string",NIL,NIL,NIL,"S",NIL,"tns")
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_posto
	::Init()
	If oResponse = NIL
		Return 
	Endif 
	::latendimento       :=  WSAdvValue( oResponse,"_ATENDIMENTO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lativo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::cbairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ncep               :=  WSAdvValue( oResponse,"_CEP","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ccidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ccnpj              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cemailAgendamento  :=  WSAdvValue( oResponse,"_EMAILAGENDAMENTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cendereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nid                :=  WSAdvValue( oResponse,"_ID","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::nidRede            :=  WSAdvValue( oResponse,"_IDREDE","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cnomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crede              :=  WSAdvValue( oResponse,"_REDE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ntelefone          :=  WSAdvValue( oResponse,"_TELEFONE","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::ntipo              :=  WSAdvValue( oResponse,"_TIPO","int",NIL,NIL,NIL,"N",NIL,"tns") 
	::cuf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::lvendasHw          :=  WSAdvValue( oResponse,"_VENDASHW","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lvisibilidade      :=  WSAdvValue( oResponse,"_VISIBILIDADE","boolean",NIL,NIL,NIL,"L",NIL,"tns")
	::clatitude          :=  WSAdvValue( oResponse,"_LATITUDE","string",NIL,NIL,NIL,"S",NIL,"tns")
	::clongitude         :=  WSAdvValue( oResponse,"_LONGITUDE","string",NIL,NIL,NIL,"S",NIL,"tns")
Return


// WSDL Data Structure auditoriaInfo

WSSTRUCT IntegracaoGARERPImplService_auditoriaInfo
	WSDATA   cacao                     AS string OPTIONAL
	WSDATA   lclienteAcao              AS boolean OPTIONAL
	WSDATA   ccomentario               AS string OPTIONAL
	WSDATA   ncpfUsuario               AS long OPTIONAL
	WSDATA   cdata                     AS string OPTIONAL
	WSDATA   cdescricaoAcao            AS string OPTIONAL
	WSDATA   cnomeUsuario              AS string OPTIONAL
	WSDATA   cposto                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_auditoriaInfo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_auditoriaInfo
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_auditoriaInfo
	Local oClone := IntegracaoGARERPImplService_auditoriaInfo():NEW()
	oClone:cacao                := ::cacao
	oClone:lclienteAcao         := ::lclienteAcao
	oClone:ccomentario          := ::ccomentario
	oClone:ncpfUsuario          := ::ncpfUsuario
	oClone:cdata                := ::cdata
	oClone:cdescricaoAcao       := ::cdescricaoAcao
	oClone:cnomeUsuario         := ::cnomeUsuario
	oClone:cposto               := ::cposto
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_auditoriaInfo
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cacao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::lclienteAcao       :=  WSAdvValue( oResponse,"_CLIENTEACAO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::ccomentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ncpfUsuario        :=  WSAdvValue( oResponse,"_CPFUSUARIO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cdata              :=  WSAdvValue( oResponse,"_DATA","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdescricaoAcao     :=  WSAdvValue( oResponse,"_DESCRICAOACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cnomeUsuario       :=  WSAdvValue( oResponse,"_NOMEUSUARIO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cposto             :=  WSAdvValue( oResponse,"_POSTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
Return

// WSDL Data Structure produto

WSSTRUCT IntegracaoGARERPImplService_produto
	WSDATA   oWSac                     AS IntegracaoGARERPImplService_ac OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cid                       AS string OPTIONAL
	WSDATA   ntempoValidade            AS int OPTIONAL
	WSDATA   ctipoPessoa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_produto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_produto
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_produto
	Local oClone := IntegracaoGARERPImplService_produto():NEW()
	oClone:oWSac                := IIF(::oWSac = NIL , NIL , ::oWSac:Clone() )
	oClone:cdescricao           := ::cdescricao
	oClone:cid                  := ::cid
	oClone:ntempoValidade       := ::ntempoValidade
	oClone:ctipoPessoa          := ::ctipoPessoa
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_produto
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_AC","ac",NIL,NIL,NIL,"O",NIL,"tns") 
	If oNode1 != NIL
		::oWSac := IntegracaoGARERPImplService_ac():New()
		::oWSac:SoapRecv(oNode1)
	EndIf
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cid                :=  WSAdvValue( oResponse,"_ID","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ntempoValidade     :=  WSAdvValue( oResponse,"_TEMPOVALIDADE","int",NIL,NIL,NIL,"N",NIL,"tns") 
	::ctipoPessoa        :=  WSAdvValue( oResponse,"_TIPOPESSOA","string",NIL,NIL,NIL,"S",NIL,"tns") 
Return

// WSDL Data Structure agente

WSSTRUCT IntegracaoGARERPImplService_agente
	WSDATA   lativo                    AS boolean OPTIONAL
	WSDATA   ccpf                      AS string OPTIONAL
	WSDATA   cemail                    AS string OPTIONAL
	WSDATA   oWShabilitacao            AS IntegracaoGARERPImplService_dadosAgenteHabilitacao OPTIONAL
	WSDATA   nid                       AS long OPTIONAL
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   lpermissaoEntregaHW       AS boolean OPTIONAL
	WSDATA   lpermissaoSac             AS boolean OPTIONAL
	WSDATA   lpermissaoSupervisor      AS boolean OPTIONAL
	WSDATA   lpermissaoValidacao       AS boolean OPTIONAL
	WSDATA   lpermissaoVerificacao     AS boolean OPTIONAL
	WSDATA   cserialNumber             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_agente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_agente
	::oWShabilitacao       := {} // Array Of  IntegracaoGARERPImplService_DADOSAGENTEHABILITACAO():New()
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_agente
	Local oClone := IntegracaoGARERPImplService_agente():NEW()
	oClone:lativo               := ::lativo
	oClone:ccpf                 := ::ccpf
	oClone:cemail               := ::cemail
	oClone:oWShabilitacao := NIL
	If ::oWShabilitacao <> NIL
		oClone:oWShabilitacao := {}
		aEval( ::oWShabilitacao , { |x| aadd( oClone:oWShabilitacao , x:Clone() ) } )
	Endif
	oClone:nid                  := ::nid
	oClone:cnome                := ::cnome
	oClone:lpermissaoEntregaHW  := ::lpermissaoEntregaHW
	oClone:lpermissaoSac        := ::lpermissaoSac
	oClone:lpermissaoSupervisor := ::lpermissaoSupervisor
	oClone:lpermissaoValidacao  := ::lpermissaoValidacao
	oClone:lpermissaoVerificacao := ::lpermissaoVerificacao
	oClone:cserialNumber        := ::cserialNumber
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_agente
	Local nRElem4, oNodes4, nTElem4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::lativo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::ccpf               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cemail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nid                :=  WSAdvValue( oResponse,"_ID","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cnome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::lpermissaoEntregaHW :=  WSAdvValue( oResponse,"_PERMISSAOENTREGAHW","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lpermissaoSac      :=  WSAdvValue( oResponse,"_PERMISSAOSAC","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lpermissaoSupervisor :=  WSAdvValue( oResponse,"_PERMISSAOSUPERVISOR","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lpermissaoValidacao :=  WSAdvValue( oResponse,"_PERMISSAOVALIDACAO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lpermissaoVerificacao :=  WSAdvValue( oResponse,"_PERMISSAOVERIFICACAO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::cserialNumber      :=  WSAdvValue( oResponse,"_SERIALNUMBER","string",NIL,NIL,NIL,"S",NIL,"tns") 
	oNodes4 :=  WSAdvValue( oResponse,"_HABILITACAO","dadosAgenteHabilitacao",{},NIL,.T.,"O",NIL,"tns")
	nTElem4 := len(oNodes4)
	For nRElem4 := 1 to nTElem4 
		If !WSIsNilNode( oNodes4[nRElem4] )
			aadd(::oWShabilitacao , IntegracaoGARERPImplService_dadosAgenteHabilitacao():New() )
			::oWShabilitacao[len(::oWShabilitacao)]:SoapRecv(oNodes4[nRElem4])
		Endif
	Next 
Return 

// WSDL Data Structure dadosAgenteHabilitacao

WSSTRUCT IntegracaoGARERPImplService_dadosAgenteHabilitacao
	WSDATA   oWSac                     AS IntegracaoGARERPImplService_ac OPTIONAL
	WSDATA   oWSar                     AS IntegracaoGARERPImplService_ar OPTIONAL
	WSDATA   oWSposto                  AS IntegracaoGARERPImplService_posto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_dadosAgenteHabilitacao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_dadosAgenteHabilitacao
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_dadosAgenteHabilitacao
	Local oClone := IntegracaoGARERPImplService_dadosAgenteHabilitacao():NEW()
	oClone:oWSac                := IIF(::oWSac = NIL , NIL , ::oWSac:Clone() )
	oClone:car                  := IIF(::car = NIL , NIL , ::car:Clone() )
	oClone:oWSposto             := IIF(::oWSposto = NIL , NIL , ::oWSposto:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_dadosAgenteHabilitacao
	Local oNode1
	Local oNode2
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_AC","ac",NIL,NIL,NIL,"O",NIL,"tns") 
	If oNode1 != NIL
		::oWSac := IntegracaoGARERPImplService_ac():New()
		::oWSac:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_AR","ar",NIL,NIL,NIL,"O",NIL,"tns") 
	If oNode2 != NIL
		::oWSar := IntegracaoGARERPImplService_ar():New()
		::oWSar:SoapRecv(oNode2)
	EndIf
	oNode3 :=  WSAdvValue( oResponse,"_POSTO","posto",NIL,NIL,NIL,"O",NIL,"tns") 
	If oNode3 != NIL
		::oWSposto := IntegracaoGARERPImplService_posto():New()
		::oWSposto:SoapRecv(oNode3)
	EndIf
Return

// WSDL Data Structure Revendedores

WSSTRUCT IntegracaoGARERPImplService_revendedores
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   nid                       AS long OPTIONAL
	WSDATA   nidAgrupamentoProduto     AS int OPTIONAL
	WSDATA   nidPostosRestricaoAgenda  AS long OPTIONAL
	WSDATA   nidTipoAgenda             AS int OPTIONAL
	WSDATA   oWSvendedores             AS IntegracaoGARERPImplService_revendedores OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_revendedores
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_revendedores
	::nidPostosRestricaoAgenda := {} // Array Of  0
	::oWSvendedores        := {} // Array Of  IntegracaoGARERPImplService_REVENDEDORES():New()
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_revendedores
	Local oClone := IntegracaoGARERPImplService_revendedores():NEW()
	oClone:cdescricao           := ::cdescricao
	oClone:nid                  := ::nid
	oClone:nidAgrupamentoProduto := ::nidAgrupamentoProduto
	oClone:nidPostosRestricaoAgenda := IIf(::nidPostosRestricaoAgenda <> NIL , aClone(::nidPostosRestricaoAgenda) , NIL )
	oClone:nidTipoAgenda        := ::nidTipoAgenda
	oClone:oWSvendedores := NIL
	If ::oWSvendedores <> NIL 
		oClone:oWSvendedores := {}
		aEval( ::oWSvendedores , { |x| aadd( oClone:oWSvendedores , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_revendedores
	Local oNodes4 :=  WSAdvValue( oResponse,"_IDPOSTOSRESTRICAOAGENDA","long",{},NIL,.T.,"N",NIL,"tns") 
	Local nRElem6, oNodes6, nTElem6
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nid                :=  WSAdvValue( oResponse,"_ID","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::nidAgrupamentoProduto :=  WSAdvValue( oResponse,"_IDAGRUPAMENTOPRODUTO","int",NIL,NIL,NIL,"N",NIL,"tns") 
	aEval(oNodes4 , { |x| aadd(::nidPostosRestricaoAgenda ,  val(x:TEXT)  ) } )
	::nidTipoAgenda      :=  WSAdvValue( oResponse,"_IDTIPOAGENDA","int",NIL,NIL,NIL,"N",NIL,"tns") 
	oNodes6 :=  WSAdvValue( oResponse,"_VENDEDORES","listarRevendedor",{},NIL,.T.,"O",NIL,"tns") 
	nTElem6 := len(oNodes6)
	For nRElem6 := 1 to nTElem6 
		If !WSIsNilNode( oNodes6[nRElem6] )
			aadd(::oWSvendedores , IntegracaoGARERPImplService_vendedores():New() )
			::oWSvendedores[len(::oWSvendedores)]:SoapRecv(oNodes6[nRElem6])
		Endif
	Next
Return

WSSTRUCT IntegracaoGARERPImplService_vendedores
	WSDATA   ccpf		               AS string OPTIONAL
	WSDATA   nid                       AS long OPTIONAL
	WSDATA   cnome		               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_vendedores
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_vendedores
	::ccpf := "" 
	::nid  := 0 
	::cnome:= ""
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_vendedores
	Local oClone := IntegracaoGARERPImplService_vendedores():NEW()
	oClone:ccpf  := ::ccpf
	oClone:nid   := ::nid
	oClone:cnome := ::cnome
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_vendedores
	If oResponse = NIL ; Return ; Endif 
	::ccpf         	:=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nid           :=  WSAdvValue( oResponse,"_ID","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cnome 		:=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"tns") 
Return

// WSDL Method findPedidosByCPFCNPJ of Service WSIntegracaoGARERPImplService

WSMETHOD findPedidosByCPFCNPJ WSSEND cuser,cpassword,ncpfcnpj WSRECEIVE oWSIdPedido WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local oATmp01

BEGIN WSMETHOD

cSoap += '<findPedidosByCPFCNPJ xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("cpfcnpj", ::ncpfcnpj, ncpfcnpj , "long", .F. , .F., 0 , NIL, .T.) 
cSoap += "</findPedidosByCPFCNPJ>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()

oATmp01 := WSAdvValue( oXmlRet,"_NS2_FINDPEDIDOSBYCPFCNPJRESPONSE:_RETURN","idPedido",NIL,NIL,NIL,NIL,NIL,"tns") 

If valtype(oATmp01)<>"A"
	oATmp01 := {oATmp01}
Endif

aEval(oATmp01,{|x,y| ( aadd(::oWSIdPedido,IntegracaoGARERPImplService_idPedido():New()), ::oWSIdPedido[y]:SoapRecv(x) ) })

END WSMETHOD

oXmlRet := NIL
Return .T.

WSSTRUCT IntegracaoGARERPImplService_idPedido
	WSDATA   realname            AS string OPTIONAL
	WSDATA   text                AS string OPTIONAL
	WSDATA   type                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_idPedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_idPedido
	::realname := ""
	::text := ""
	::type := ""
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_idPedido
	Local oClone := IntegracaoGARERPImplService_idPedido():NEW()
	oClone:realname := ::realname
	oClone:text := ::text
	oClone:type := ::type
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_idPedido
	::Init()
	If oResponse = NIL
		Return
	Endif 
	::realname  :=  oResponse:REALNAME
	::text      :=  oResponse:TEXT 
	::type      :=  oResponse:TYPE 
Return

// WSDL Method consultaDadosCertificadoPorPedido of Service WSIntegracaoGARERPImplService

WSMETHOD consultaDadosCertificadoPorPedido WSSEND cuser,cpassword,npedid WSRECEIVE oWSdadosCertificado WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<consultaDadosCertificadoPorPedido xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.)
cSoap += '<pedid xmlns="">'+AllTrim(Str(npedid))+'</pedid>' 
//cSoap += WSSoapValue("pedid", ::npedid, npedid , "long", .F. , .F., 0 , NIL, .T.)  
cSoap += "</consultaDadosCertificadoPorPedido>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
::oWSdadosCertificado:SoapRecv( WSAdvValue( oXmlRet,"_NS2_CONSULTADADOSCERTIFICADOPORPEDIDORESPONSE:_RETURN","dadosCertificado",NIL,NIL,NIL,NIL,NIL,"tns") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Data Structure dadosCertificado

WSSTRUCT IntegracaoGARERPImplService_dadosCertificado
	WSDATA   cassunto                  AS string OPTIONAL
	WSDATA   lbloqueadoPeloGestor      AS boolean OPTIONAL
	WSDATA   lbloqueioFraudeStatus     AS boolean OPTIONAL
	WSDATA   cceiPF                    AS string OPTIONAL
	WSDATA   cceiPJ                    AS string OPTIONAL
	WSDATA   cclasse                   AS string OPTIONAL
	WSDATA   ccnpj                     AS string OPTIONAL
	WSDATA   ccpf                      AS string OPTIONAL
	WSDATA   ccrtid                    AS string OPTIONAL
	WSDATA   cdataNascimento           AS string OPTIONAL
	WSDATA   cdominioLogin             AS string OPTIONAL
	WSDATA   lemAnaliseFraudeStatus    AS boolean OPTIONAL
	WSDATA   cemail                    AS string OPTIONAL
	WSDATA   cemissor                  AS string OPTIONAL
	WSDATA   cfqdn                     AS string OPTIONAL
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   cnumeroSerie              AS string OPTIONAL
	WSDATA   coab_seccional            AS string OPTIONAL
	WSDATA   coab_uf                   AS string OPTIONAL
	WSDATA   corgaoExpedidorRg         AS string OPTIONAL
	WSDATA   corgaoLotacao             AS string OPTIONAL
	WSDATA   npedido                   AS long OPTIONAL
	WSDATA   cpisPasep                 AS string OPTIONAL
	WSDATA   crazaoSocial              AS string OPTIONAL
	WSDATA   lrenovacao                AS boolean OPTIONAL
	WSDATA   crevogacao                AS string OPTIONAL
	WSDATA   crg                       AS string OPTIONAL
	WSDATA   cstatus                   AS string OPTIONAL
	WSDATA   ctituloEleitor            AS string OPTIONAL
	WSDATA   ctituloEleitorMunicipio   AS string OPTIONAL
	WSDATA   ctituloEleitorSecao       AS string OPTIONAL
	WSDATA   ctituloEleitorUf          AS string OPTIONAL
	WSDATA   ctituloEleitorZona        AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   cvalidoAte                AS string OPTIONAL
	WSDATA   cvalidoDe                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_dadosCertificado
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_dadosCertificado
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_dadosCertificado
	Local oClone := IntegracaoGARERPImplService_dadosCertificado():NEW()
	oClone:cassunto             := ::cassunto
	oClone:lbloqueadoPeloGestor := ::lbloqueadoPeloGestor
	oClone:lbloqueioFraudeStatus := ::lbloqueioFraudeStatus
	oClone:cceiPF               := ::cceiPF
	oClone:cceiPJ               := ::cceiPJ
	oClone:cclasse              := ::cclasse
	oClone:ccnpj                := ::ccnpj
	oClone:ccpf                 := ::ccpf
	oClone:ccrtid               := ::ccrtid
	oClone:cdataNascimento      := ::cdataNascimento
	oClone:cdominioLogin        := ::cdominioLogin
	oClone:lemAnaliseFraudeStatus := ::lemAnaliseFraudeStatus
	oClone:cemail               := ::cemail
	oClone:cemissor             := ::cemissor
	oClone:cfqdn                := ::cfqdn
	oClone:cnome                := ::cnome
	oClone:cnumeroSerie         := ::cnumeroSerie
	oClone:coab_seccional       := ::coab_seccional
	oClone:coab_uf              := ::coab_uf
	oClone:corgaoExpedidorRg    := ::corgaoExpedidorRg
	oClone:corgaoLotacao        := ::corgaoLotacao
	oClone:npedido              := ::npedido
	oClone:cpisPasep            := ::cpisPasep
	oClone:crazaoSocial         := ::crazaoSocial
	oClone:lrenovacao           := ::lrenovacao
	oClone:crevogacao           := ::crevogacao
	oClone:crg                  := ::crg
	oClone:cstatus              := ::cstatus
	oClone:ctituloEleitor       := ::ctituloEleitor
	oClone:ctituloEleitorMunicipio := ::ctituloEleitorMunicipio
	oClone:ctituloEleitorSecao  := ::ctituloEleitorSecao
	oClone:ctituloEleitorUf     := ::ctituloEleitorUf
	oClone:ctituloEleitorZona   := ::ctituloEleitorZona
	oClone:cuf                  := ::cuf
	oClone:cvalidoAte           := ::cvalidoAte
	oClone:cvalidoDe            := ::cvalidoDe
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_dadosCertificado
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cassunto           :=  WSAdvValue( oResponse,"_ASSUNTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::lbloqueadoPeloGestor :=  WSAdvValue( oResponse,"_BLOQUEADOPELOGESTOR","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::lbloqueioFraudeStatus :=  WSAdvValue( oResponse,"_BLOQUEIOFRAUDESTATUS","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::cceiPF             :=  WSAdvValue( oResponse,"_CEIPF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cceiPJ             :=  WSAdvValue( oResponse,"_CEIPJ","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cclasse            :=  WSAdvValue( oResponse,"_CLASSE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ccnpj              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ccpf               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ccrtid             :=  WSAdvValue( oResponse,"_CRTID","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cdominioLogin      :=  WSAdvValue( oResponse,"_DOMINIOLOGIN","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::lemAnaliseFraudeStatus :=  WSAdvValue( oResponse,"_EMANALISEFRAUDESTATUS","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::cemail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cemissor           :=  WSAdvValue( oResponse,"_EMISSOR","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cfqdn              :=  WSAdvValue( oResponse,"_FQDN","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cnome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cnumeroSerie       :=  WSAdvValue( oResponse,"_NUMEROSERIE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::coab_seccional     :=  WSAdvValue( oResponse,"_OAB_SECCIONAL","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::coab_uf            :=  WSAdvValue( oResponse,"_OAB_UF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::corgaoExpedidorRg  :=  WSAdvValue( oResponse,"_ORGAOEXPEDIDORRG","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::corgaoLotacao      :=  WSAdvValue( oResponse,"_ORGAOLOTACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::npedido            :=  WSAdvValue( oResponse,"_PEDIDO","long",NIL,NIL,NIL,"N",NIL,"tns") 
	::cpisPasep          :=  WSAdvValue( oResponse,"_PISPASEP","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::lrenovacao         :=  WSAdvValue( oResponse,"_RENOVACAO","boolean",NIL,NIL,NIL,"L",NIL,"tns") 
	::crevogacao         :=  WSAdvValue( oResponse,"_REVOGACAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::crg                :=  WSAdvValue( oResponse,"_RG","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cstatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitor     :=  WSAdvValue( oResponse,"_TITULOELEITOR","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorMunicipio :=  WSAdvValue( oResponse,"_TITULOELEITORMUNICIPIO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorSecao :=  WSAdvValue( oResponse,"_TITULOELEITORSECAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorUf   :=  WSAdvValue( oResponse,"_TITULOELEITORUF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::ctituloEleitorZona :=  WSAdvValue( oResponse,"_TITULOELEITORZONA","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cuf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cvalidoAte         :=  WSAdvValue( oResponse,"_VALIDOATE","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::cvalidoDe          :=  WSAdvValue( oResponse,"_VALIDODE","string",NIL,NIL,NIL,"S",NIL,"tns") 
Return

// WSDL Method consultaCadastroCompletoAgente of Service WSIntegracaoGARERPImplService

WSMETHOD consultaCadastroCompletoAgente WSSEND cuser,cpassword,ncpf WSRECEIVE oWSagente WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<consultaCadastroCompletoAgente xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .T.)  
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += '<cpf xmlns="">'+AllTrim(Str(ncpf))+'</cpf>' 
//cSoap += WSSoapValue("cpf", ::ncpf, ncpf , "long", .F. , .F., 0 , NIL, .T.)  
cSoap += "</consultaCadastroCompletoAgente>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()

aadd(::oWSagente,IntegracaoGARERPImplService_agente():New())
::oWSagente[1]:SoapRecv( WSAdvValue( oXmlRet,"_NS2_CONSULTACADASTROCOMPLETOAGENTERESPONSE:_RETURN","agente",NIL,NIL,NIL,NIL,NIL,"tns") )

END WSMETHOD

oXmlRet := NIL

Return .T.

WSSTRUCT IntegracaoGARERPImplService_dadosagente
	WSDATA   realname            AS string OPTIONAL
	WSDATA   text                AS string OPTIONAL
	WSDATA   type                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_dadosagente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_dadosagente
	::realname := ""
	::text := ""
	::type := ""
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_dadosagente
	Local oClone := IntegracaoGARERPImplService_agente():NEW()
	oClone:realname := ::realname
	oClone:text := ::text
	oClone:type := ::type
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_dadosagente
	::Init()
	If oResponse = NIL
		Return
	Endif 
	::realname  :=  oResponse:REALNAME
	::text      :=  oResponse:TEXT 
	::type      :=  oResponse:TYPE 
Return

// WSDL Method consultaAgente of Service WSIntegracaoGARERPImplService

WSMETHOD consultaAgente WSSEND cuser,cpassword,ncpf WSRECEIVE oWSagente WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")

BEGIN WSMETHOD

cSoap += '<consultaAgente xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cpf", ::ncpf, ncpf , "long", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</consultaAgente>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
aadd(::oWSagente,IntegracaoGARERPImplService_agente():New())
::oWSagente[1]:SoapRecv( WSAdvValue( oXmlRet,"_NS2_CONSULTAAGENTERESPONSE:_RETURN","agente",NIL,NIL,NIL,NIL,NIL,"tns") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listarACs of Service WSIntegracaoGARERPImplService

WSMETHOD listarACs WSSEND cuser,cpassword WSRECEIVE oWSac WSCLIENT WSIntegracaoGARERPImplService
Local cSoap := "" , oXmlRet
Local cXWSGAR	:= GetNewPar("MV_XGARERP", "https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP")
Local oATmp01

BEGIN WSMETHOD

cSoap += '<listarACs xmlns="http://ws.integracaogarerp.certisign.com.br/">'
cSoap += WSSoapValue("user", ::cuser, cuser , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</listarACs>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.integracaogarerp.certisign.com.br/",,,; 
	cXWSGAR)

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_NS2_LISTARACSRESPONSE:_RETURN","ac",NIL,NIL,NIL,NIL,NIL,"tns") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWSac,IntegracaoGARERPImplService_ac():New()) , ::oWSac[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Data Structure ac

WSSTRUCT IntegracaoGARERPImplService_ac
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   nid                       AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IntegracaoGARERPImplService_ac
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IntegracaoGARERPImplService_ac
Return

WSMETHOD CLONE WSCLIENT IntegracaoGARERPImplService_ac
	Local oClone := IntegracaoGARERPImplService_ac():NEW()
	oClone:cdescricao           := ::cdescricao
	oClone:nid                  := ::nid
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IntegracaoGARERPImplService_ac
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"tns") 
	::nid                :=  WSAdvValue( oResponse,"_ID","long",NIL,NIL,NIL,"N",NIL,"tns") 
Return