#include 'protheus.ch'
#include 'parmtype.ch'

user function MT103CWH()
Local cCampo    := PARAMIXB[1] 
Local cConteudo := PARAMIXB[2] 
Local lRet := .T.	
If !IsInCallStack("A103DEVOL")
	If cFormul == 'S' .AND. cCampo == "F1_EMISSAO"
		lRet := .F.
		dDEmissao := Date()
		oGetDados:oBrowse:Refresh()
	EndIf
EndIf	
return lRet