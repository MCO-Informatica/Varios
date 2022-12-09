#Include 'Protheus.ch'
//---------------------------------------------------------------
// Rotina | CNTA300 | Autor | Rafael Beghini | Data | 13/03/2018 
//---------------------------------------------------------------
// Descr. | Manutenções na rotina de Contratos
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function CNTA300()
	LOCAL xReturn  		:= .T.
	LOCAL aParam		:= PARAMIXB
	LOCAL oModelActive	:= NIL
	LOCAL cIdPonto		:= ''
	LOCAL cIdModel		:= ''
	Local cSituac		:= ''
	
	IF aParam <> NIL
		oModelActive	:= aParam[1]
		cIdPonto		:= aParam[2]
		cIdModel		:= aParam[3]
		
		IF IsInCallStac('Cn300Aprov') .And. ALLTRIM(cIdPonto) == "MODELCOMMITNTTS" .AND. ALLTRIM(cIdModel) == "CNTA300"	
			//Chamar função para disparar notificação da Revisão.
			U_A650Rev( { CN9->CN9_TIPREV, Alltrim(MSMM(CN9->CN9_CODJUS)) } )
		EndIF
		
		IF IsInCallStac('CN300PrCF') .And. ALLTRIM(cIdPonto) == "FORMCOMMITTTSPOS"
			MsgAlert('CN300PrCF')
		EndIF
		
		IF ALLTRIM(cIdPonto) == "BUTTONBAR" .And. ALLTRIM(cIdModel) == "CNTA300" .And. ( ( ( INCLUI	.Or. ALTERA ) .And. CN9->CN9_SITUAC $ '02|09' ) .Or. IsInCallStac('Cn300Rev') )
			xReturn := {}
			aADD( xReturn, {'#Alterar Data Cronograma','CLIPS',{|| U_CSGCT030(oModelActive) } } )
		EndIF
	EndIF
Return xReturn