#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

User Function MATA110XML()
	Local cXML := ''
	
	cXML += '<?xml version="1.0" encoding="UTF-8"?>'
	cXML += '<?xml-stylesheet type="text/xsl" href="MATA110.xsl"?>
	cXML += '<MATA110>
	cXML +=	'	<C1_NUM><value>' + SC1->C1_NUM +'</value></C1_NUM>'
	cXML +=	'	<C1_EMISSAO><value>' + dtos (SC1->C1_EMISSAO) +'</value></C1_EMISSAO>'
	cXML +=	'	<C1_ITEM><value>' + SC1->C1_ITEM +'</value></C1_ITEM>'
	cXML +=	'	<C1_PRODUTO><value>' + SC1->C1_PRODUTO +'</value></C1_PRODUTO>'
	cXML +=	'	<C1_DESCRI><value>' + SC1->C1_DESCRI +'</value></C1_DESCRI>'
	cXML +=	'	<C1_UM><value>' + SC1->C1_UM +'</value></C1_UM>'
	cXML +=	'	<C1_QUANT><value>' + alltrim (str(SC1->C1_QUANT, 12, 2)) +'</value></C1_QUANT>'
	cXML +=	'	<C1_APROV><value>' + SC1->C1_APROV +'</value></C1_APROV>'
	cXML += '</MATA110>
	
Return cXML