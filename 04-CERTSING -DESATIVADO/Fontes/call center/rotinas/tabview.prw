#include 'protheus.ch'

/*                
Classe de objetos visuais do tipo controle – Tabview, a qual permite criar um controle visual do tipo pasta.
Autor: Opvs(Warleson Fernandes)  
Versao: BETA - 15/01/2013
Uso: CERTISIGN AP10
*/
              

Class Tabview
    
	DATA 	oAreaView
	DATA    oAreaTabs
	DATA 	oAreaScroll
	DATA 	aPrompts
	DATA 	bAction
	DATA 	nOption
    DATA    cManFunction
    	
	METHOD	New()CONSTRUCTOR
	METHOD	AddItem()
	METHOD	SetOption()
	METHOD	SetTabs()

EndClass
*______________________________________________________________________________________________________________________________________________________________

/*Metodo construtuor*/

METHOD New(nTop,nLeft,aPrompts,bAction,oWnd,nOption,aClrFore,lcanGotFocus,nWidth,nHeight) Class TabView

	Local oPanel1,oPanel2,oPanel3,oPanel4,oPanel5,oscroll
	
	Local cProcName	:= ProcName()
	Local nI		:= 0
	Local nF		:= 0
	Local nTam		:= 13 
	local cStyle1 	:= DefineCss(1)
	local cStyle2	:= DefineCss(2)
	local nCont		:= 0
    Local nPixel	:= 0
	Local nX		:= 0
	
	Default	aPrompts 		:= {'1'}
	Default	nOption 		:= 1 
	Default	aClrFore 		:= {0,64,128} 
	Default	lCanGotFocus	:= .F.

	::aPrompts		:= aPrompts
	::bAction		:= bAction		
	::nOption		:= nOption
	::cManFunction	:= ProcName(1)
	
	_SetOwnerPrvt("bAcao"	,::bAction)
	_SetOwnerPrvt("_nOpc"	,1)
	_SetOwnerPrvt("cStyle3"	,DefineCss(3))
	_SetOwnerPrvt("cStyle4"	,DefineCss(4,aClrFore))


	//nTop 		:= (nTop/2)
	//nLeft		:= (nLeft/2)
	//nWidth 	:= (nWidth/2)
	//nHeight	:= (nHeight/2)

	oPanel1:= tPanelCss():New(nTop,nLeft,"",oWnd,,.F.,.F.,,,nWidth,(nHeight-nTam),.T.,.F.)
	oPanel1:setCSS(cStyle1)

	oPanel3:=tPanelCss():New(((nHeight+nTop)-nTam)-0.5,nLeft,"",oWnd,,.F.,.F.,,,0,(nTam-1),.F.,.F.)    
	oPanel3:setCSS(cStyle2)

	oPanel2:=tPanelCss():New(0,0,"",oPanel3,,.F.,.F.,,,nWidth,nTam+8,.F.,.F.)    
	oPanel2:setCSS(cStyle2)
      
    oScroll := TScrollBox():Create(oPanel2,01,01,92,260,.F.,.T.,.F.)
	//oScroll := TScrollArea():New(oPanel2,01,01,260,92,.T.,.T.,.T.)

	@ 0,0 Mspanel oPanel5 of oScroll Size 0,nTam 


	oScroll:LCANGOTFOCUS:= lCangotFocus
	oScroll:align := CONTROL_ALIGN_ALLCLIENT

	For nX:=1 to len(::aPrompts)
		
		nPixel:= CalcFieldSize('C',len(::aPrompts[nX]),0,"","")+16

		_SetOwnerPrvt("_oBtn"+cvaltochar(nX))

  		&('_oBtn'+cvaltochar(nX)) := TButton():New(0-1.1,ncont,::aPrompts[nX],oPanel5,/*{||}*/,nPixel,nTam,,,,.T.,,"",,,,.F. )

		&('_oBtn'+cvaltochar(nX)):BGOTFOCUS:= &('{||U_SetOption('+cvaltochar(nX)+',SELF)}')

		nCont+=(nPixel)
		oPanel3:NWIDTH+=(nPixel*2)
		oPanel5:NWIDTH+=(nPixel*2)
		if nX==len(::aPrompts)
		 	if 	&('_oBtn'+cvaltochar(nX)):NRIGHT>(oScroll:NCLIENTWIDTH)
				oPanel3:NHEIGHT:= (oPanel3:NHEIGHT+18)
				oPanel5:NHEIGHT:= (oPanel3:NHEIGHT+18)
			endif
		Endif
	Next nX

    &('_oBtn'+cvaltochar(::nOption)):SetFocus()

	::oAreaView 	:= oPanel1 
	::oAreaTabs 	:= oPanel3
	::oAreaScroll 	:= oPanel5 
Return SELF
*______________________________________________________________________________________________________________________________________________________________
/*Metodo auxiliar - Seleciona aba*/

METHOD SetOption(nOpc)  Class TabView

	&('_oBtn'+cvaltochar(nOpc)):SetCss(cStyle4)
	if !(nOpc==_nOpc)
		&('_oBtn'+cvaltochar(_nOpc)):SetCss(cStyle3)         
		_nOpc:= nOpc
	endif
	
	if !(UPPER(Procname(3))=='NEW') .and. !(UPPER(ProcName(5))=='BUSCARESULT')//Passar para paremtro  a segunda condicao(Atencao)
		::nOption := nOpc
		Eval(bAcao)	
	endif
Return
*______________________________________________________________________________________________________________________________________________________________
/*Metodo auxiliar - para setar novas Abas*/

METHOD SetTabs(aPrompts) Class TabView

Local nX		:= 0
local nPixel	:= 0
Local ncont		:= 0
local nTam		:= 13
Local aFocus	:= {}

if !(valtype(Self:OAREATABS)=='U') .and. !(valtype(::Aprompts)=='U') .and. !(len(aPrompts)==0) .and. !valtype(_oBtn1)=='U'
	
   	&('_oBtn'+cvaltochar(1)):SetFocus()
	
	if len(::aPrompts)>1
		For nX:=1 to len(::aPrompts)-1
			if!(&('_oBtn'+cvaltochar(nX)):cCaption=='+')
				FreeObj(&('_oBtn'+cvaltochar(nX)))
			Else
				&('_oBtn'+cvaltochar(nX)):Hide()
			endif
		Next
    Endif
	
	For nX:=1 to len(aPrompts)
		Self:CMANFUNCTION
		nPixel:= CalcFieldSize('C',len(aPrompts[nX]),0,"","")+16

		//_SetOwnerPrvt("_oBtn"+cvaltochar(nX))
 		 _SetNamedPrvt("_oBtn"+cvaltochar(nX),"",::cManFunction)

  		&('_oBtn'+cvaltochar(nX)) := TButton():New(0-1.1,ncont,aPrompts[nX],::oAreaScroll,/*{||}*/,nPixel,nTam,,,,.T.,,"",,,,.F. )
		&('_oBtn'+cvaltochar(nX)):BGOTFOCUS:= &('{||U_SetOption('+cvaltochar(nX)+',SELF)}')
		
		nCont+=(nPixel)
		if (nX==1)
			::oAreaTabs:NWIDTH		:= (nPixel*2)
			::oAreaScroll:NWIDTH	:= (nPixel*2)		
			::oAreaTabs:NHEIGHT		:= nTam*2
			::oAreaScroll:NHEIGHT	:= nTam*2
		Else
		    ::oAreaTabs:NWIDTH+=(nPixel*2)
			::oAreaScroll:NWIDTH+=(nPixel*2)
			::oAreaTabs:NHEIGHT		:= nTam*2
			::oAreaScroll:NHEIGHT	:= nTam*2
		Endif
		
		::oAreaScroll:Refresh()
			
		if nX==len(aPrompts)
			If(::oAreaScroll:NWIDTH>::OAREAVIEW:NWIDTH)
				::oAreaTabs:NWIDTH	:= ::OAREAVIEW:NWIDTH
				::oAreaTabs:NHEIGHT:= (::oAreaTabs:NHEIGHT+18)
				::oAreaScroll:NHEIGHT:= (::oAreaTabs:NHEIGHT+18)
			Else
				::oAreaTabs:NHEIGHT:= nTam*2
				::oAreaScroll:NHEIGHT:= nTam*2
			Endif

		Endif
	Next nX
	
	::aPrompts := aclone(aPrompts)
  	
  	if ProcName(1)=='BUSCAR'
	   	&('_oBtn'+cvaltochar(1)):SetFocus()
	Elseif &('_oBtn'+cvaltochar(len(::aPrompts))):cCaption=='+'
		&('_oBtn'+cvaltochar(len(::aPrompts)-1)):SetFocus()
	Else
		&('_oBtn'+cvaltochar(len(::aPrompts))):SetFocus()	
	Endif

Endif

Return
*______________________________________________________________________________________________________________________________________________________________
METHOD AddItem(cNome) Class TabView

Local aPrompts := aClone(::aPrompts)
Local nX

	For nx:=1 to len(aPrompts)
		aPrompts[nX]:= cvaltochar(nX)
	Next	
 	
 	aAdd(aPrompts,cNome)
//	::SetTabs(aPrompts)
Return aPrompts
*______________________________________________________________________________________________________________________________________________________________
/*Funcao auxiliar - Seleciona aba*/

User Function SetOption(nOpc,SELF) 

	If !(UPPER(Procname(3))=='NEW')
		::SetOption(nOpc)
		::SetTabs("","","","")	
	Else
		&('_oBtn'+cvaltochar(nOpc)):SetCss(cStyle4)
		if !(nOpc==_nOpc)
			&('_oBtn'+cvaltochar(_nOpc)):SetCss(cStyle3)
			_nOpc:= nOpc
		endif
	eNDIF
//	::SetTabs(::AddItem('))	
Return
*______________________________________________________________________________________________________________________________________________________________
/*Definicoes de inteface */

static function DefineCss(nID,aValor)

Local cCSS := " "

	Do Case
		Case nId==1
			cCSS := "Q3Frame{background-color:#FFFFFF;border-style:solid; border-width: 1px;border-color:#838B8B}"
		Case nId==2
			cCSS := "Q3Frame{border-style: none;}"
		Case nId==3
			cCSS :="QPushButton {			color: #000000;} "+;
   					"QPushButton { 			border-style: solid } "+;                           	
					"QPushButton {			border-image: url(rpo:cssBtnImageFocus.png) 4 4 4 4 stretch }"+;		
					"QPushButton {			border-width: 2px }"+;
					"QPushButton:hover { 	color: #000000; } "+;
					"QPushButton:hover { 	border-style: solid } "+;
					"QPushButton:hover {	border-image: url(rpo:cssBtnImageFocus.png) 4 4 4 4 stretch }"+;		
					"QPushButton:hover {	border-width: 2px }"+;
					"QPushButton:focus { 	color: #000000; } "+;
					"QPushButton:focus { 	border-style: solid } "+;
					"QPushButton:focus {	border-image: url(rpo:cssBtnImageFocus.png) 4 4 4 4 stretch }"+;		
					"QPushButton:focus {	border-width: 2px }"+;
					"QPushButton:pressed { 	color: #000000; } "+;
					"QPushButton:pressed { 	border-style: solid } "+;
					"QPushButton:pressed {	border-image: url(rpo:cssBtnImage.png) 4 4 4 4 stretch }"+;		
					"QPushButton:pressed {	border-width: 2px }"
		Case nId==4
			cCSS := "QPushButton {border-style:solid;border-width:1px;border-color:#838B8B; background-color: white;font-weight: bold;"+;
			        "color:rgb("+cvaltochar(aValor[1])+','+cvaltochar(aValor[2])+','+cvaltochar(aValor[3])+");} QPushButton:pressed {background-color: white;}"
		EndCase

Return cCss