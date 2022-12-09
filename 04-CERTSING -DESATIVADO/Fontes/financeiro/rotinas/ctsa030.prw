#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSA030   ºAutor  ³Microsiga           º Data ³  23/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho para carregar os dados cadastrais do Cliente/       º±±
±±º          ³Prospect nas Rotinas de TLV                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTSA030()
Local __aStru	:= {}
Local __nI		:= 0 
Local __cCpo1 	:= ""
Local __cCpo2	:= "" 
Local __cAlias	:= IIF(lProspect,"SUS","SA1") 
Local _cReturn	:= M->UA_CLIENTE

__aStru := 	{	{RIGHT(__cAlias,2)+"_PESSOA"}	,;
				{RIGHT(__cAlias,2)+"_NOME"}		,;
				{RIGHT(__cAlias,2)+"_NREDUZ"}	,;
				{RIGHT(__cAlias,2)+"_TIPO"}		,;
				{RIGHT(__cAlias,2)+"_CEP"}		,;
				{RIGHT(__cAlias,2)+"_END"}		,;
				{RIGHT(__cAlias,2)+"_EST"}		,;
				{RIGHT(__cAlias,2)+"_MUN"}		,;
				{RIGHT(__cAlias,2)+"_BAIRRO"}	,;
				{RIGHT(__cAlias,2)+"_CEPC"}		,;
				{RIGHT(__cAlias,2)+"_ENDCOB"}		,;
				{RIGHT(__cAlias,2)+"_ESTC"}		,;
				{RIGHT(__cAlias,2)+"_MUNC"}		,;
				{RIGHT(__cAlias,2)+"_BAIRROC"}	,;
				{RIGHT(__cAlias,2)+"_CGC"}		,;
				{RIGHT(__cAlias,2)+"_INSCR"}	,;				
				{RIGHT(__cAlias,2)+"_INSCRM"}	,;				
				{RIGHT(__cAlias,2)+"_CONTFIN"}	,;
				{RIGHT(__cAlias,2)+"_TELCONT"}	,;
				{RIGHT(__cAlias,2)+"_DDD"}	,;			
				{RIGHT(__cAlias,2)+"_TEL"}	,;				
				{RIGHT(__cAlias,2)+"_EMAIL"}	}
				
For  __nI:= 1 to Len(__aStru)
	__cCpo1 := __aStru[__nI,1] 	
	__cCpo2 := StrTran(__aStru[__nI,1],RIGHT(__cAlias,2)+"_","UA_")
	
	If 	SUA->(FieldPos(__cCpo2)) > 0 
				
		&("M->"+__cCpo2) := &(__cAlias+"->"+__cCpo1)
		
	EndIf
Next

Return(_cReturn)


