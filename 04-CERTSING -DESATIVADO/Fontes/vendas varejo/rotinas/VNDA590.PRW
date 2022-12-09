#INCLUDE "PROTHEUS.CH"
/*/{Protheus.doc} VNDA590

Funcao criada mostrar tela de rastreamento dos correios   

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function VNDA590(cRast)
	Local lRet		:= .T.	
	Local cLink		:= GetNewPar("MV_XLNKRAS", "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_ITEMCODE=&P_LINGUA=001&P_TESTE=&P_TIPO=001&Z_ACTION=Search&P_COD_UNI=")
	Local oDlg		:= nil
	Local cPagHtm	:= ""
	Local oTIBrowser:= nil
	
	Default cRast	:= ""		 					
	
	PAG->(DbSetOrder(2))
	
	If PAG->(DbSeek(xFilial("PAG")+cRast))
		ShellExecute("open",cLink+cRast,"","",5)
	Else
		lRet := .F.
	EndIf
	
Return(lRet)