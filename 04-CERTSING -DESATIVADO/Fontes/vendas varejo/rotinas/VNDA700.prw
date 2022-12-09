#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | VNDA700 | Autor | Rafael Beghini | Data | 20.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Valida a linha do atendimento para informar o Motivo do
//|        | cancelamento do Pedido Site no Service Desk
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function VNDA700()
	Local lRet  := .T.
	Local nL    := 0
	Local nTot  := Len( aCOLS )
	Local cOcor := ''
	Local cPar1 := 'VNDA700A' 
	Local cPar2 := 'VNDA700B' 
	                
	If .NOT. SX6->( ExisteSX6( cPar1 ) )
		CriarSX6( cPar1, 'C', 'Assunto utilizado para cancelamento de PedSite no SDK. VNDA700.prw', 'BK0014;BK0015;BK0028;BK0032' )
	Endif
		
	If .NOT. SX6->( ExisteSX6( cPar2 ) )
		CriarSX6( cPar2, 'C', 'Ocorrencia utilizada para cancelamento de PedSite no SDK. VNDA700.prw', '006475;006482;006545;014449' )
	Endif
	
	cOcor := GetMv( cPar2 )
	
	For nL := nTot To Len( aCOLS )
		IF aCOLS[nL,2] $ cOcor .And. Empty( aCOLS[nL,10] )
			MsgAlert 	('Necessário o preenchimento do campo "Observação da Ocorrência" para este Assunto e Ocorrência.')
			lRet := .F.
		EndIF
	Next nL
Return( lRet )