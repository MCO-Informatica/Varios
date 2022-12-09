# Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณCSGEnchBar  บAutor  ณMarcelo Celi Marquesบ Data ณ 02/10/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณBarra de Menu personalizada.						          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CSGEnchBar(oDlg,bOk,bCancel,aButtons,aButText,lIsEnchoice,lSplitBar,lLegenda,nDirecao,lBGround)
Local nX 		:= 0
Local xAlinha 	:= ""

DEFAULT aButtons	:= {}                 
DEFAULT aButText	:= {}
DEFAULT lIsEnchoice := .T.
DEFAULT lSplitBar 	:= .T.
DEFAULT lLegenda  	:= .F.
DEFAULT nDirecao	:= 0
DEFAULT lBGround	:= .T.

If nDirecao == 0
	xDirecao := CONTROL_ALIGN_BOTTOM
ElseIf nDirecao == 1
	xDirecao := CONTROL_ALIGN_TOP	
ElseIf nDirecao == 2
	xDirecao := CONTROL_ALIGN_RIGHT	
Else
	xDirecao := CONTROL_ALIGN_LEFT	
EndIf
	                 
nTam := 15	
	
oButtonBar := FWButtonBar():new()
oButtonBar:Init(oDlg,nTam,15,xDirecao,.T.,lIsEnchoice)

If lIsEnchoice
	oButtonBar:setEnchBar( bOk, bCancel,,,,.T.)
Else
	//Criacao dos botoes de Texto OK e Cancela quando nao for enchoicebar
	If !Empty(bCancel)
		oButtonBar:addBtnText( "Cancela"	, "Cancela"	, bCancel,,,CONTROL_ALIGN_RIGHT, .T.) 
		SetKEY(24,{||Eval(bCancel)})
	Endif

	If !Empty(bOk)
		oButtonBar:addBtnText( "OK"		, "Confirma", bOk,,,CONTROL_ALIGN_RIGHT) 
		SetKEY(15,{||Eval(bOk)})
	Endif
Endif
	
//Criacao dos botoes de texto do usuario ou complementares
If Len(aButText) > 0
	For Nx := 1 to Len(aButText)
		oButtonBar:addBtnText( aButText[nX,1], aButText[nX,2],aButText[nX,3],,, CONTROL_ALIGN_RIGHT)
	Next
Endif

//Se a FAMYBAR esta sendo montada num browse e este tiver legenda alguns botoes padrao sao criados (botao imagem)
If lLegenda
	oButtonBar:addBtnImage( "PMSCOLOR"  , "Legenda"		, {|| FLegenda(FinWindow:cAliasFile, (FinWindow:cAliasFile)->(RECNO()))},, .T., CONTROL_ALIGN_LEFT)
Endif

// criacao dos botoes de imagem do usuario ou complementares
If Len(aButtons) > 0
	For Nx := 1 To Len(aButtons)
		oButtonBar:addBtnImage( aButtons[nX,1], aButtons[nX,3],aButtons[nX,2],,.T., CONTROL_ALIGN_LEFT)
   Next
EndIf

//altera o fundo da buttonbar
If lBGround
	oButtonBar:setBackGround( "toolbar_mdi.png", 000, 000, .T. ) 
EndIf	

If lIsEnchoice
	oButtonBar:AITEMS[1]:LVISIBLECONTROL := .F. 
	oButtonBar:AITEMS[2]:LVISIBLECONTROL := .F.
	oButtonBar:AITEMS[3]:LVISIBLECONTROL := .F.
	oButtonBar:AITEMS[4]:LVISIBLECONTROL := .F.	
EndIf	

Return Nil

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณSCGetCpo   ณ Autor ณ Marcelo Celi Marques ณ Data ณ 26/10/12 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณRetorna o inicio do campo conforme alias.                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Certisign                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SCGetCpo(cAlias)
Local cRet := ""
If Left(cAlias,1)=="S"
	cRet := Right(cAlias,2)
Else
    cRet := cAlias
EndIf
Return cRet

