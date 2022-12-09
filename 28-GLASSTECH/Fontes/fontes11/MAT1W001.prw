#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
 
WSSERVICE WSTHERMOSERVICE DESCRIPTION 'Servi�o de dados da Thermoglass'
 
 WSDATA cResult as String
 WSDATA cStringEnvio as String
 WSDATA cNumOP as String
 WSDATA nQnt as String
 WSDATA nPerda as String
 WSMETHOD Echo DESCRIPTION "M�todo Echo"
 WSMETHOD InsM250 DESCRIPTION "M�todo para inclus�o da MATA250"
 
ENDWSSERVICE
 
//WSMETHOD Echo WSRECEIVE NULLPARAM WSSEND cString WSSERVICE WSTHERMOSERVICE
WSMETHOD Echo WSRECEIVE cStringEnvio WSSEND cResult WSSERVICE WSTHERMOSERVICE 
 
	::cResult := "Comando enviado: " + cStringEnvio
 
Return .T.

WSMETHOD InsM250 WSRECEIVE cNumOP, nQnt, nPerda WSSEND cResult WSSERVICE WSTHERMOSERVICE
	//RPCSetType(3)
	RpcClearEnv()
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' USER "admin" PASSWORD "thcpd319000"
	
	//U_InsM250(cNumOP, nQnt, nPerda)
		
	::cResult := 'Cashews'
	
	RESET ENVIRONMENT
return .T.