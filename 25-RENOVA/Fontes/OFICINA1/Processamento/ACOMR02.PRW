#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOMR02   บAutor  ณFelipi Marques      บ Data ณ  03/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para descompactar o retorno dos WS da SEFAZ          บฑฑ
ฑฑบ          ณem formato gzip                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACOMR02(cString, cTag, cMetodo, cSchema, lWs)      

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cSource   	:= Decode64(cString)
Local nSourceLen	:= Len(cSource)
Local cTarget		:= ""  
Local cResult		:= ""
    
Local oXML			:= Nil
Local cXML			:= '<?xml version="1.0" encoding="ISO-8859-1"?>'
Local cError		:= ""
Local cWarning		:= ""

Default	cMetodo 	:= ""
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณDescompacta a string no formato gzip ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
If GzStrDecomp( cSource, nSourceLen, @cTarget )
	Conout(cTarget)
	If !Empty(cTag)
		If Upper(cMetodo) == Upper("nfeDistDFeInteresse")
			cXML	+= cTarget      
			oXML	:= XmlParser( cXml, "_", @cError, @cWarning)
			If oXML != Nil .And. cTag == "chNfe"
				If Upper("resNFe") $ Upper(cSchema)
					cTarget	:=oXML:_RESNFE:_CHNFE:TEXT
				ElseIf Upper("resEvento") $ Upper(cSchema)
					Conout("Linha 40")				
					cTarget	:=oXML:_RESEVENTO:_CHNFE:TEXT
				ElseIf Upper("procEventoNFE") $ Upper(cSchema)
					Conout("Linha 44")				
					cTarget	:=oXML:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_CHNFE:TEXT			
				EndIf
			ElseIf oXML != Nil .And. cTag == "dhRecbto"
				If Upper("resNFe") $ Upper(cSchema)
					Conout("Linha 49")					
					cTarget	:=SubStr(oXML:_RESNFE:_DHRECBTO:TEXT,1,4)+SubStr(oXML:_RESNFE:_DHRECBTO:TEXT,6,2)+SubStr(oXML:_RESNFE:_DHRECBTO:TEXT,9,2)
					Conout("DATA: "+cTarget)
				EndIf                                                           
			ElseIf oXML != Nil .And. cTag == "cSitNFe"
				If Upper("resNFe") $ Upper(cSchema)		
					cTarget	:=oXML:_RESNFE:_CSITNFE:TEXT
				Else
					Conout("Linha 58 EXTXML. Tag cSitNFe nใo encontrada no retorno.")
				EndIf				
			ElseIf oXML != Nil .And. cTag == "XML"
				cTarget := cXml
				Conout("Linha 49")				
			EndIf
		ElseIf Empty(cMetodo)
			Conout("Linha 52")
			cXML	+= cTarget      
			oXML	:= XmlParser( cXml, "_", @cError, @cWarning)		
			If oXML != Nil .And. cTag == "TagsEvento"
				cTarget := oXML:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CHNFE:TEXT + "|" + oXML:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_TPEVENTO:TEXT
				Conout("Linha 58")
			EndIf
		EndIf        		
	EndIf
Else                 
	Conout("Linha 63")
	Conout("ERRO")
EndIf

Return cTarget