
#include "protheus.ch"

#DEFINE WS_CLIENTID    'be49d474-5c1d-43f2-9b30-e01c4660e703'
#DEFINE WS_USERNAME    'microsiga'
#DEFINE WS_PASSWORD    'protheus'
#DEFINE WS_SERVICETYPE 'SOAMashupStudioService'

Static oMSGetIn
Static oMSGetOut
Static __cCPDALIAS     := ""
Static __cAliasMashup  := ""
Static __aMashups      := {}
Static __aListMashups  := {}
Static __aListParam    := {}
Static __aPutMashups   := {}
Static __aStructMshp   := {}
Static  __lViewUsrScreen := .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA460  ºAutor  ³Opvs (David)        º Data ³  23/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que Valida o CEP consultando MAshups da TOTVS        º±±
±±º          ³Retorna Array com a seguintes Estrutura:                    º±±
±±º          ³Areturn[1,1] - .t. CEP Válido / .f. CEP Inválido            º±±
±±º          ³Areturn[2,1] - Caso Cep Válido Array com os dados do endere-º±±
±±º          ³co caso inváliso mensagem com descricao da inconsistencia   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VNDA460(cCep)

Local oWS
Local oWSConnectionData
Local oWSServiceData 
Local nI         := 0
Local nX         := 0
Local nPosOri    := 0
Local nPosCpo    := 0
Local lRet       := .T.
Local aParamIn   := {}
Local aParamOut  := {}
Local aWSSOAData := {}
Local aUsrScreen := {}
Local aService	 := {}
Local aMashups	 := {}
Local cMashup    := "Correios.PesquisaCEP"
Local nVersion   := 1
Local lChgInfo   := .f.
Local xResult	 := {}
Local aReturn	 := {}
Local cMsgErr	 := ""

__lViewUsrScreen := .T.

oWS:= WSSOAManager():New()
oWS:_Url := GetUrl(oWS)
oWS:oWSConnectionData:cClientID := WS_CLIENTID
oWS:oWSConnectionData:cUserName := WS_USERNAME
oWS:oWSConnectionData:cPassWord := WS_PASSWORD
oWS:cServiceType    := WS_SERVICETYPE
oWS:cServiceName    := cMashup
oWS:nServiceVersion := nVersion

If 	oWS:GetServiceTypes()
	aService := oWS:oWSServiceTypes:cString

	For nX := 1 to len(aService)                       
		If Alltrim(aService[nX]) == 'SOAMashupStudioService'		
			oWS:oWSConnectionData:cClientID := WS_CLIENTID
			oWS:oWSConnectionData:cUserName := WS_USERNAME
			oWS:oWSConnectionData:cPassWord := WS_PASSWORD
			oWS:cServiceType                := aService[nX]         
			oWSConnectionData               := oWS:oWSConnectionData:Clone()
		
			If oWS:GetServiceNames()
				aMashups := oWS:oWSServiceNames:cString   
				If Ascan( aMashups, { |x| alltrim(x) == alltrim(cMashup) } ) > 0
					oWS:oWSConnectionData:cClientID := WS_CLIENTID
					oWS:oWSConnectionData:cUserName := WS_USERNAME
					oWS:oWSConnectionData:cPassWord := WS_PASSWORD
					oWS:cServiceType                := aService[nX]
					oWS:cServiceName                := Alltrim(cMashup)
					oWS:nServiceVersion             := nVersion

					// Clona o parametro de envio, pois ele será usado novamente em outro webservice
					oWSConnectionData:= oWS:oWSConnectionData:Clone()
					
					If oWS:GetService()
						// Clona o parametro de envio, pois ele será usado novamente em outro webservice
						aWSSOAData := aClone(oWS:oWSServiceData:OWSData:OWSSOAData)
						oWSServiceData := oWS:oWSServiceData:Clone()
						 
						 // RESETA o objeto Client !!!! Para uma nova utilização
						oWS:Reset()
					
						 // Alimenta os parametros para a segunda chamada
						 oWS:oWSConnectionData := oWSConnectionData:Clone()
						 oWS:oWSServiceData    := oWSServiceData:Clone()
						 oWS:oWSServiceData:OWSData:OWSSOAData := aClone(aWSSOAData)
						 
						 //Verifica se ocorreu algum erro
						If oWS:oWSResultType:Value == "Error"
							MsgAlert(oWS:cResultMessage)
							cMsgErr := oWS:cResultMessage 
						Else
							aParam := oWS:oWSServiceData:oWSData:oWSSOAData
							For nY := 1 to len(aParam)
								If Upper(Alltrim(aParam[nY]:cName)) == "CEP" .and. aParam[nY]:oWSDataKind:Value == "Param"
									aParam[nY]:cValue := cCep								
									Exit
								Endif
							Next nY
							
							// Alimenta os parametros para a segunda chamada
							oWS:oWSConnectionData := oWSConnectionData:Clone()

							If oWS:Execute()
								If oWS:oWSResultType:Value == "Finished"
									aParam := oWS:oWSServiceData:oWSData:oWSSOAData
									For nY := 1 To Len(aParam)  
										If aParam[nY]:oWSDataKind:Value == "Result"
											AaDd(xResult,{aParam[nY]:cName,Upper(NoAcento(AnsitoOem(aParam[nY]:cValue)))})
										EndIF
									Next nY
								ElseIf oWS:oWSResultType:Value == "Error" .Or. oWS:oWSResultType:Value == "InvalidParam"
									MsgAlert(oWS:cResultMessage)
									cMsgErr := oWS:cResultMessage
									lRet := .F.
								EndIf
							Else
								MsgStop(Getwscerror())
								cMsgErr := Getwscerror()
								lRet := .F.
							EndIf
						EndIf
					Else
						MsgStop(Getwscerror())
						cMsgErr := Getwscerror()
						lRet := .F.
					EndIf
					Exit											
				EndIf
			Else
				MsgStop(Getwscerror())
				cMsgErr := Getwscerror() 
				lRet := .F.
			Endif
		EndIf
	Next nX
Else
	MsgStop(Getwscerror())
	cMsgErr := Getwscerror() 
	lRet := .F.	
EndIf
If lRet
	aReturn := {.T.,xResult}
Else
	aReturn := {.F.,cMsgErr}
EndIf
Return aReturn

//-----------------------------------------
Static Function GetUrl(oWS)
Local cUrl := oWS:_Url //-- Poderá ser manipulada a url futuramente
Return cUrl
