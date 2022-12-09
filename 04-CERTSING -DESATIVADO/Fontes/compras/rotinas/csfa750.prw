#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*/{Protheus.doc} CSFA750
Webservice de integra�ao do protheus com aplica��o de aprova��o de PC

@author Robson Gon�alves - Rleg
@since  04/10/2016
@version P11
/*/
WSSERVICE CSFA750 DESCRIPTION "WebService para integra��o aplica��o Java com aprova��o de pedido de compras" NAMESPACE "http://localhost:8080/wscomprasportal.apw"
	WSDATA cCPFAprov     As String
	WSDATA cFilialPC     As String
	WSDATA cMailAprov    As String
	WSDATA cNumeroPC     As String
	WSDATA cXMLAprovacao As String
	WSDATA cXMLConsulta  As String
	WSDATA cXmlRet       As String
	
	WSMETHOD getConsultaAlc       DESCRIPTION "Consultar a al�ada do pedido de compras."
	WSMETHOD getConsultaPC        DESCRIPTION "Consultar os detallhes do pedido de compras e a capa de despesa f�sica (pdf)."
	WSMETHOD getConsultFornec     DESCRIPTION "Consultar as �ltimas compras do fornecedor."
	WSMETHOD getPendenciaAlcadaPC DESCRIPTION "Autentica usu�rio aprovador e retornar lista de pend�ncia de al�ada de pedido de compra."
	WSMETHOD getSituacaoPC        DESCRIPTION "Consultar a situa��o da aprova��o/rejei��o do pedido de compra."
	WSMETHOD setAprovacaoPC       DESCRIPTION "Receber as a��es de aprova��o/reprova��o do pedido de compra."
ENDWSSERVICE

/*/{Protheus.doc} getPendenciaAlcadaPC

M�todo para autenticar usu�rio aprovador e retornar lista de pend�ncia de al�ada.

@author Robson Gon�alves
@since 26/09/2016
@version P11
/*/
WSMETHOD getPendenciaAlcadaPC WSRECEIVE cMailAprov, cCPFAprov WSSEND cXmlRet WSSERVICE CSFA750
	::cXmlRet := XML_VERSION + U_A610PenPC( ::cMailAprov, ::cCPFAProv )
Return( .T. )

/*/{Protheus.doc} setAprovacaoPC

M�todo para receber as a��es de aprova��o/reprova��o do pedido de compra.

@author Robson Gon�alves
@since 29/09/2016
@version P11
/*/
WSMETHOD setAprovacaoPC WSRECEIVE cXMLAprovacao WSSEND cXmlRet WSSERVICE CSFA750
	Local cMV750_001 := 'MV_750_001'
	
	If .NOT. GetMv( cMV750_001, .T. )
		CriarSX6( cMV750_001, 'N', 'ATIVAR=1 OU DESATIVA=0 PROCESSO SINCRONO INTEGRACAO APROVACAO DE ALCADA X APLICACAO JAVA. ROTINA CSFA750.prw', '1' )
	Endif
	
	::cXmlRet := XML_VERSION + U_A610RecApr( ::cXMLAprovacao, (GetMv( cMV750_001, .F. )==1) )
Return( .T. )

/*/{Protheus.doc} getSituacaoPC

M�todo para consultar a situa��o da aprova��o/rejei��o do pedido de compra.

@author Robson Gon�alves
@since 06/10/2016
@version P11
/*/
WSMETHOD getSituacaoPC WSRECEIVE cXMLConsulta WSSEND cXmlRet WSSERVICE CSFA750
	::cXmlRet := XML_VERSION + U_A610Situac( ::cXMLConsulta )
Return( .T. )

/*/{Protheus.doc} getConsultaPC

Consultar os detallhes do pedido de compras e a capa de despesa f�sica (pdf).

@author Robson Gon�alves
@since 07/10/2016
@version P11
/*/
WSMETHOD getConsultaPC WSRECEIVE cFilialPC, cNumeroPC WSSEND cXmlRet WSSERVICE CSFA750
	::cXmlRet := XML_VERSION + U_A610Ped( ::cFilialPC, ::cNumeroPC )
Return( .T. )

/*/{Protheus.doc} getConsultaAlc

Consultar a al�ada do pedido de compras.

@author Robson Gon�alves
@since 09/11/2016
@version P11
/*/
WSMETHOD getConsultaAlc WSRECEIVE cFilialPC, cNumeroPC WSSEND cXmlRet WSSERVICE CSFA750
	::cXmlRet := XML_VERSION + U_A610Alcad( ::cFilialPC, ::cNumeroPC )
Return( .T. )

/*/{Protheus.doc} getConsultFornec

Consultar as �ltimas compras do fornecedor.

@author Robson Gon�alves
@since 14/12/2016
@version P11
/*/
WSMETHOD getConsultFornec WSRECEIVE cFilialPC, cNumeroPC WSSEND cXmlRet WSSERVICE CSFA750
	::cXmlRet := XML_VERSION + U_A610HistForn( ::cFilialPC, ::cNumeroPC )
Return( .T. )