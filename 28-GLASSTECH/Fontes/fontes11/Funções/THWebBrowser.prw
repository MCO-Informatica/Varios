#include "PROTHEUS.CH"

Class WebBrowser
	
	Data oTIBrowser
	
	Data cTitle
	Data cUrl
	
	Method New(cUrl) Constructor
	Method Navigate(cUrl)
	Method SetUrl(cUrl)
	
End Class

Method New(cUrl) Class WebBrowser 
	Local oDlg
	Local aButtons := {}

	AAdd(aButtons,{"BtIn1" ,{|| Self:oTIBrowser:GoHome()}, "Inicio"  ,"Inicio"} )   // Self:oTIBrowser:GoHome()
	AAdd(aButtons,{"BtIm2" ,{|| Self:oTIBrowser:Print()}, "Imprimir","Imprimir"} ) // Self:oTIBrowser:Print()
	//AAdd(aButtons,{"Bt3"   ,{|| ''}, "Alterar" ,"Alterar"} )  // Self:oTIBrowser:
	//AAdd(aButtons,{"Bt4"   ,{|| ''}, "Excluir" ,"Excluir"} )

  	Private aSize := MsAdvSize() // pega o tamanho da tela 
  	//-------------------------------------  
  	// A opção nOR(WS_VISIBLE,WS_POPUP) é a   
  	// responsável pela janela sem borda  
  	//-------------------------------------  
  	DEFINE MSDIALOG oDlg TITLE Self:cTitle From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
  
  	Self:oTIBrowser := TIBrowser():New( 2,2,(aSize[5]/2), (aSize[6]/2), '', oDlg ) 
      
  	ACTIVATE DIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| Self:oTIBrowser:Navigate(cUrl) },{||oDlg:End()},,aButtons)  
Return( Self )

Method Navigate(cUrl) Class WebBrowser
	If cUrl <> Self:cUrl
		Self:SetUrl(cUrl)
	EndIf
	Self:oTIBrowser:Navigate(cUrl)
Return

Method SetUrl(cUrl) Class WebBrowser
	Self:cUrl := cUrl
Return

//Initial function
User Function XInit()
	Local cUsrInfo := ""
	Local oWeb
	Local oUsr
	
	oUsr := UserControl():New()
	cUsrInfo := "?Code=" + AllTrim(oUsr:GetUserCode()) + "&"
	cUsrInfo += "Name=" + AllTrim(oUsr:GetUserName()) + "&"
	cUsrInfo += "Level=" + AllTrim(Str(cNivel))
	
	oWeb := WebBrowser():New("http://localhost:8001/Filter/GenericReport/" + cUsrInfo)	
Return

// Relatório de apontamento de primitivo
User Function Rel001()
	Local oWeb

	oWeb := WebBrowser():New("http://localhost:8001/Filter/GenericReport/1")
Return





