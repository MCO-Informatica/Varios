#INCLUDE 'PROTHEUS.CH'

 
//CRIAR GATILHO NOS CAMPOS QUE IRAO REALIZAR A VALIDACAO ABAIXO.
//DESCOMPILAR A ROTINA MA030TOK.  - A1_GRPTRIB
// A1_TIPO                                                
// A1_INSCR
// A1_XIESIMP 
// A1_EST 

//-------------------------------------------------------------------------------
// GATILHO PARA VERIFICAR AS REGRAS DO CLIENTE PARA DETERMINAR A TABELA			|
// DE PRECO - REGRAS INFORMADAS POR RAFAEL.										| 
// CRIADOR: Ewerton Sobrinho | Data: 15/01/2015 |                               |
//-------------------------------------------------------------------------------
USER FUNCTION VLDGRP()

Local lRet 		:= .F.
Local cMvIeS 	:= SuperGetMV("MV_XIESIMP",,"") //PARAMETRO QUE CONTEM OS ESTADOS QUE FAZEM PARTE DA REGRA.

//======================================================================================================+
//TIPO CLIENTE "CONSUMIDOR FINAL" / OPTANTE SIMPLES "TANTO FAZ" / PARAMETRO "TANTO FAZ"/ Insc.Est "SIM" +	 
//======================================================================================================+
If alltrim(M->A1_TIPO) == 'F' .AND. ( Empty(M->A1_INSCR) .or. alltrim(M->A1_INSCR) $ "ISENTO" )
	cTpExc 	:= 'CF3'
	lRet 	:=.T.
	
//======================================================================================================+
//TIPO CLIENTE "CONSUMIDOR FINAL" / OPTANTE SIMPLES "TANTO FAZ" / PARAMETRO "TANTO FAZ"/ Insc.Est "NAO" +	 
//======================================================================================================+
ELSEIf alltrim(M->A1_TIPO) == 'F'.AND. ( !Empty(M->A1_INSCR) .AND. !ALLTRIM(M->A1_INSCR) $ "ISENTO" )
	cTpExc 	:= 'CF2'
	lRet 	:= .T.

//======================================================================================+
//TIPO CLIENTE "SOLIDARIO" / OPTANTE SIMPLES "SIM" / PARAMETRO "SIM" / Insc.Eest. "SIM" +	 
//======================================================================================+
ELSEIf alltrim(M->A1_TIPO) == 'S' .AND. ALLTRIM(M->A1_XIESIMP) == '1' .AND. ALLTRIM(M->A1_EST) $ cMvIeS .AND. ( !Empty(M->A1_INSCR) .AND. !ALLTRIM(M->A1_INSCR) $ "ISENTO" )
	cTpExc 	:=  'SIM'  
	lRet 	:= .T.
	
//=====================================================================================+
//TIPO CLIENTE "SOLIDARIO" / OPTANTE SIMPLES "SIM" / PARAMETRO "SIM" / Insc.Est. "NAO" +	 
//=====================================================================================+
ELSEIf alltrim(M->A1_TIPO) == 'S' .AND. ALLTRIM(M->A1_XIESIMP) == '1' .AND. ALLTRIM(M->A1_EST) $ cMvIeS .AND. ( Empty(M->A1_INSCR) .or. alltrim(M->A1_INSCR) $ "ISENTO" )
	cTpExc 	:=  'CF3'
	lRet 	:= .T.

//=====================================================================================+
//TIPO CLIENTE "SOLIDARIO" / OPTANTE SIMPLES "SIM" / PARAMETRO "NAO" / Insc.Est. "SIM" +	 
//=====================================================================================+
ELSEIf alltrim(M->A1_TIPO) == 'S' .AND. ALLTRIM(M->A1_XIESIMP) == '1' .AND. !ALLTRIM(M->A1_EST) $ cMvIeS .AND. ( !Empty(M->A1_INSCR) .AND. !ALLTRIM(M->A1_INSCR) $ "ISENTO" ) 
	cTpExc 	:=  'SLD'
	lRet 	:= .T.
	
//=====================================================================================+
//TIPO CLIENTE "SOLIDARIO" / OPTANTE SIMPLES "SIM" / PARAMETRO "NAO" / Insc.Est. "NAO" +	 
//=====================================================================================+
ELSEIf alltrim(M->A1_TIPO) == 'S' .AND. ALLTRIM(M->A1_XIESIMP) == '1' .AND. !ALLTRIM(M->A1_EST) $ cMvIeS .AND. ( Empty(M->A1_INSCR) .or. alltrim(M->A1_INSCR) $ "ISENTO" )
	cTpExc 	:=  'CF3'
	lRet 	:= .T.

//===========================================================================================+
//TIPO CLIENTE "SOLIDARIO" / OPTANTE SIMPLES "NAO" / PARAMETRO "TANTO FAZ" / Insc.Est. "SIM" +	 
//===========================================================================================+
ELSEIf alltrim(M->A1_TIPO) == 'S' .AND. ALLTRIM(M->A1_XIESIMP) == '2' .AND. ( !Empty(M->A1_INSCR) .AND. !ALLTRIM(M->A1_INSCR) $ "ISENTO" ) 
	cTpExc 	:=  'SLD'
	lRet 	:= .T.
	
//===========================================================================================+
//TIPO CLIENTE "SOLIDARIO" / OPTANTE SIMPLES "NAO" / PARAMETRO "TANTO FAZ" / Insc.Est. "NAO" +	 
//===========================================================================================+
ELSEIf alltrim(M->A1_TIPO) == 'S' .AND. ALLTRIM(M->A1_XIESIMP) == '2' .AND. ( Empty(M->A1_INSCR) .or. alltrim(M->A1_INSCR) $ "ISENTO" )
	cTpExc 	:=  'CF3'	
	lRet 	:= .T.

ELSE
	cTpExc 	:=  ''
	lRet 	:= .F.

ENDIF

M->A1_GRPTRIB := cTpExc

RETURN  cTpExc