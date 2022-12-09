#include "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "PRTOPDEF.CH"

#DEFINE IMP_PDF 6

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02   บ Autor ณ Roberto Souza      บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Chamada para rotina principal de importa็ใo de arquivos    บฑฑ
ฑฑบ          ณ XML de Fornecedores.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ IMPORTA XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function HFXML02(cCodeOne,lOk)
Local aArea     := GetArea()
Local lRetorno  := .T.
Local nVezes    := 0
Private lBtnFiltro:= .F.
Default cCodeOne := ""
Default lOk := .F.
Static USANFE := AllTrim(GetNewPar("XM_USANFE","S")) $ "S "
Static USACTE := AllTrim(GetNewPar("XM_USACTE","S")) $ "S "
Static lUnix  := IsSrvUnix()
Static cBarra := Iif(lUnix,"/","\")
Static cIdEnt    := U_GetIdEnt()
Static cURL      := PadR(GetNewPar("XM_URL",""),250)
If Empty(cURL)
	cURL  := PadR(GetNewPar("MV_SPEDURL","http://"),250)
EndIf

If cCodeOne<>"HF351058875875878XSSD7XVXVUETVEIIIQPQNZZ6574883AJJANI00983881FFDHSEJJSNW" .Or. !lOk
	Aviso("Aviso", "Uso incorreto da rotina."+CRLF+"Entrar em contato com a HFConsulting.",{"OK"},3)
	Return(Nil)	
EndIf

While lRetorno
	lBtnFiltro:= .F.
    lRetorno := HFXML02A(nVezes==0)
    nVezes++
    If !lBtnFiltro
    	Exit
    EndIf
EndDo
RestArea(aArea)

Return(Nil)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02A  บ Autor ณ Roberto Souza      บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Montagem do browse principal de importa็ใo de arquivos     บฑฑ
ฑฑบ          ณ XML de Fornecedores.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ IMPORTA XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function HFXML02A(lInit,cAlias)
Local aPerg     := {}
Local lRetorno  := .T.
Local aIndArq   := {}
Local aFilPar   := {}
Local cExprFilTop
Local cHFTopFun
Local cHFBotFun
Private x_Ped_Rec := GetNewPar("XM_PEDREC","N")
Private x_ZBB     := GetNewPar("XM_TABREC","")
Private x_Tip_Pre := GetNewPar("XM_TIP_PRE","1")
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6")) 
Private nFormCte  := Val(GetNewPar("XM_FORMCTE","6"))
Private cFilUsu   := GetNewPar("XM_FIL_USU","N")
Private cCondicao := ""
Private bFiltraBrw
Private aFilBrw   := {}
Private cCadastro := "XML de Fornecedores - Entidade : "+cIdEnt
Private aRotina   := {} //GetMenu()
Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private aCores   := {}
Private cString  := "ZBZ"
Private aUserData:= {"",""} 
Private cTopFun  := ""
Private cBotFun  := "ZZZZ"

	AADD(aCores,{"ZBZ_PRENF == 'B' .AND. ZBZ_PROTC == Space(15)" ,"BR_AZUL" })
	AADD(aCores,{"ZBZ_PRENF == 'A' .AND. ZBZ_PROTC == Space(15)" ,"BR_LARANJA" })   //,BR_CINZA,BR_LARANJA,,BR_MARRON
	AADD(aCores,{"ZBZ_PRENF == 'S' .AND. ZBZ_PROTC == Space(15)" ,"BR_VERDE" })
	AADD(aCores,{"ZBZ_PRENF == 'N' .AND. ZBZ_PROTC == Space(15)" ,"BR_VERMELHO" })
	AADD(aCores,{"ZBZ_PRENF == 'F' .AND. ZBZ_PROTC == Space(15)" ,"BR_PRETO" })
	AADD(aCores,{"ZBZ_PRENF == 'Z' .AND. ZBZ_PROTC == Space(15)" ,"BR_AMARELO" })
	AADD(aCores,{"ZBZ_PRENF == 'X' .OR.  ZBZ_PROTC <> '' "       ,"BR_BRANCO" })

	SetKEY( VK_F3 , {|| U_HFXML02V()})

	PswOrder(2)
	cUserName := Substr(cUsuario,7,15)
	If PswSeek( cUserName, .T. )
	 	aUserData := PswRet()
		If aUserData[1][1]== "000000" //.or. aScan( aUserData[2][6], "@@@@" ) > 0
			SetKEY( VK_F12 , {|| U_HFXML04()}) 
		EndIf
	Else
		PswOrder(1)
		cCodUsr := RetCodUsr()
		If PswSeek( cCodUsr, .T. )
		 	aUserData := PswRet()
			If aUserData[1][1]== "000000" //.or. aScan( aUserData[2][6], "@@@@" ) > 0
				SetKEY( VK_F12 , {|| U_HFXML04()}) 
			EndIf
		Else
   			aUserData:={{"",""}}
   			cFilUsu := "N"
  		Endif
	EndIf

	if cFilUsu == "S"
		HfFiltra( @cExprFilTop, @cHFTopFun, @cHFBotFun )
	endif

	aRotina := GetMenu()

	MBrowse( 6,1,22,75,cString,,,,,2,aCores,cHFTopFun,cHFBotFun,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.T.,cExprFilTop)

	If aUserData[1][1]== "000000" //.or. aScan( aUserData[2][6], "@@@@" ) > 0
		SetKEY( VK_F12 , Nil )
	EndIf

	SetKEY( VK_F3 ,  Nil )

	lRetorno := .F.

Return(lRetorno)  


//se filiais for sequencial utilizar cHFTopFun, cHFBotFun
//senใo usar cExprFilTop
Static Function HfFiltra( cExprFilTop, cHFTopFun, cHFBotFun )
Local nTamEmp  := len(SM0->M0_CODIGO) + 1 //soma um para pegar a pr๓xima posi็ใo no aUserData[2][6][nI]
Local cFiliais := ""
Local aFiliais := {}
Local aGrupos  := {}
Local aGrpData := {}
Local nFilial  := 0
Local cFil001  := ""
Local cFil002  := ""
Local lPulou := .F.
Local nI := 0
Local nX := 0

If U_IsShared("ZZB")   //se a ZZB for compartilhada nใo se aplica filtro.
	Return NIL
EndIf

//ver Filiais do Usuแrio
If Len(aUserData) >= 2
	If len(aUserData[2]) >= 6

		If aScan( aUserData[2][6], "@@@@" ) > 0  //Todas as Filiais, nใo se aplica filtro
			Return NIL
		EndIf

		For nI := 1 to Len(aUserData[2][6])
			cFiliais := Substr( aUserData[2][6][nI], nTamEmp, Len(aUserData[2][6][nI]) )
			If Empty( aFiliais ) .or. aScan( aFiliais, cFiliais ) == 0
				aadd( aFiliais, cFiliais )
			EndIf
		Next nI
	EndIf

EndIf

//ver Filiais dos Grupos
If Len(aUserData) >= 1
	aGrupos := {}
	If Len(aUserData[1]) >= 10
		aGrupos := aUserData[1][10]
	EndIf
	
	For nX := 1 To Len( aGrupos )
		PswOrder(1)
		If PswSeek( aGrupos[nX], .F. )
			aGrpData := PswRet()
			If Len(aGrpData) >= 2
				If Len(aGrpData[2]) >= 6

					If aScan( aGrpData[2][6], "@@@@" ) > 0  //Todas as Filiais, nใo se aplica filtro
						Return NIL
					EndIf

					For nI := 1 to Len(aGrpData[2][6])
						cFiliais := Substr( aGrpData[2][6][nI], nTamEmp, Len(aGrpData[2][6][nI]) )
						If Empty( aFiliais ) .or. aScan( aFiliais, cFiliais ) == 0
							aadd( aFiliais, cFiliais )
						EndIf
					Next nI
				EndIf
			EndIf

		Endif
	Next

EndIf

cFiliais := ""
If .Not. Empty( aFiliais )
	aSort( aFiliais,,, {|x,y| x < y } )
   	cFil001  := aFiliais[1]
	cFiliais := "'"+aFiliais[1]+"'"
	lPulou   := .F.
	For nI := 1 To Len(aFiliais)
		If nI > 1
			If (Val(aFiliais[nI]) - nFilial) > 1
				lPulou := .T.
			EndIf
			cFiliais += ",'"+aFiliais[nI]+"'"
		EndIf
    	cFil002 := aFiliais[nI]
		nFilial := Val(aFiliais[nI])
	Next nI

EndIf

If lPulou  //Se tiver buraco na sequencia de Filiais utiliza cExprFilTop
	cExprFilTop := "ZBZ_FILIAL in ("+cFiliais+")"
Else
	cTopFun   := cFil001
	cBotFun   := cFil002
	cHFTopFun := "U_HFTOPFUN"
	cHFBotFun := "U_HFBOTFUN"
EndIf

Return NIL


User Function HFTopFun()
Return( cTopFun )


User Function HFBotFun()
Return( cBotFun )



Static Function GetMenu()
Local aMenu := {}
Local aSub1 := {}
Local aSub2 := {}


aadd(aSub1, {"Alterar"           ,"U_HFXML02M" ,0,3} )
If len(aUserData) >= 2 .And. ( aUserData[1][1] == "000000" .or. aScan( aUserData[2][6], "@@@@" ) > 0 )
	aadd(aSub1, {"Excluir"           ,"U_HFXML02Z" ,0,3} )
EndIf
aadd(aSub1, {"Consulta Chave Xml"  ,"U_HFXML02X" ,0,3} )
aadd(aSub1, {"Download Sefaz Xml"  ,"U_HFXML06D" ,0,3} )
aadd(aSub1, {"Cadastrar Fornecedor","U_HFXML08"  ,0,4} )
if x_Ped_Rec == "S"
	aadd(aSub1, {"Pedido Recorrente"  ,"U_HFXML09" ,0,4} )
endif

aSub2 := {}
if x_Tip_Pre $ "1,3,4,6"
	aadd(aSub2, {"Gera &Pre Nota"     ,"U_HFXML02P"   ,0,4})
endif
if x_Tip_Pre $ "2,3,5,6"
	aadd(aSub2, {"Aviso &Recbto Carga","U_HFXML02ARC" ,0,4})
endif
if x_Tip_Pre $ "4,5,6"
	aadd(aSub2, {"Nt Conhec Frete-CTe","U_HFXML02CTE" ,0,4})
endif
if x_Ped_Rec == "S"
	aadd(aSub2, {"Pre Nota p/Ped.Rec.","U_XML09PDR( ,.T. )",0,4})
endif

aMenu   := {}

aadd(aMenu, {"Pesquisar"          ,"AxPesqui"    ,0,1,0,Nil} )
aadd(aMenu, {"Vis. Registro"      ,"AxVisual"    ,0,2,0,Nil} )
aadd(aMenu, {"&Visualiza NF"      ,"U_HFXML02V"  ,0,2,0,Nil} )
aadd(aMenu, {"Baixar Xml"         ,"U_HFXML02D"  ,0,3,0,Nil} )
if len( aSub2 ) > 1
	aadd(aMenu, {"Gera &Doctos"       ,aSub2		 ,0,4,0,Nil} )
elseif x_Tip_Pre == "2"
	aadd(aMenu, {"Av. &Recbto Carga"  ,"U_HFXML02ARC",0,4,0,Nil} )
else
	aadd(aMenu, {"Gera &Pre Nota" 	  ,"U_HFXML02P"  ,0,4,0,Nil} )
endif
aadd(aMenu, {"Danfe/Dacte"        ,"U_XMLPRTdoc" ,0,2,0,Nil} )
aadd(aMenu, {"Exportar XML"       ,"U_HFXML02E"  ,0,4,0,Nil} )
aadd(aMenu, {"Fun็๕es XML"        , aSub1 		 ,0,5,0,Nil} )
aadd(aMenu, {"Manifestar"         ,"U_HFMANCHV"  ,0,5,0,Nil} )   //GETESB2
aadd(aMenu, {"Legenda"            ,"U_HFXML02L"  ,0,2,0,Nil} )


Return(aMenu)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02D  บ Autor ณ Roberto Souza      บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02D
Local aArea    := GetArea()
Local lEnd     := .F.
Local oProcess := Nil
Local cLogProc := ""
Local cDir     := AllTrim(SuperGetMv("MV_X_PATHX"))
Local cDirLog  := AllTrim(cDir+cBarra+"Log"+cBarra)
Local lAuto    := .F.
Local nCount   := 0
Local lNoMail  := AllTrim(GetSrvProfString("HF_XFUNC","0")) == "1"

cLogProc := "### Importa็ใo de Xml iniciada ###"+CRLF
cLogProc += dToC(date()) +"-"+ Substr(Time(),1,2) + "-" + Substr(Time(),4,2)+CRLF

oProcess := MsNewProcess():New( {|lEnd| OkProc(lAuto,@lEnd,oProcess,@cLogProc,@nCount)} ,"Processando...","Processando Rotinas...",.T.)	//###
oProcess:Activate()

cDatahora  	:= 	dTos(date()) +"-"+ Substr(Time(),1,2) + "-" + Substr(Time(),4,2)

cLogProc    += "### Importa็ใo de Xml Finalizada ###"+CRLF

If !ExistDir(cDirLog)
	Makedir(cDirLog)
EndIf

MemoWrite(cDirLog+"XML-"+cDataHora+".log",cLogProc)

If !lAuto
	U_MyAviso("Importa็ใo XML",cLogProc,{"OK"},3)
EndIf
RestArea(aArea)
Return



Static Function OkProc(lAuto,lEnd,oProcess,cLogProc,nCount)
Local cRotImp  := GetNewPar("XM_ROTINAS","1,2,3,5")
Local lRotinaX := ("X" $ cRotImp)
Local lRotina1 := ("1" $ cRotImp)
Local lRotina2 := ("2" $ cRotImp)
Local lRotina3 := ("3" $ cRotImp)
Local lRotina4 := ("4" $ cRotImp)
Local lRotina5 := ("5" $ cRotImp)

If lRotina1 .Or. lRotinaX
	EMailNFE(lAuto,@lEnd,oProcess,@cLogProc,@nCount)
	Conout("EMailNFE")
EndIf
If lRotina2 .Or. lRotinaX
	ProcXml(lAuto,@lEnd,oProcess,@cLogProc,@nCount) 
	Conout("ProcXml")
EndIf
If lRotina3 .Or. lRotinaX
	AtuXmlStat(lAuto,@lEnd,oProcess,@cLogProc,@nCount)
	Conout("AtuXmlStat")	
EndIf	   
If lRotina4 .Or. lRotinaX
	U_UPConsXML(lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)
	Conout("UPConsXML")	
EndIf		 

If lRotina5 .Or. lRotinaX
	ProcMail(lAuto,@lEnd,oProcess,@cLogProc,@nCount,.F.)
	Conout("ProcMail")	
EndIf		 

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEMailNFE  บ Autor ณ Roberto Souza      บ Data ณ  12/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function EMailNFE(lAuto,lEnd,oProcess,cLogProc,nCount)
Static __MailServer
Static __MailError
Static __MailFormatText := .f. // Mensagem em formato Texto
local oMessage
local nInd
local lRunTbi	 := .F.
local nCount
local cFilename
local aAttInfo
local acFrom := ""
local acTo := ""
local acCc := ""
local acBcc := ""
local acSubject := ""
local acBody := ""
local acPath  := ""
local alDelete := .T. // Deleta ou nใo do servidor
local aaFiles := { }
Local aPOP       := U_XCfgMail(2,1,{})
Local cMailServer := aPOP[1]
Local cLogin      := aPOP[2]
Local cMailConta  := aPOP[3]
Local cMailSenha  := aPOP[4]
Local lSMTPAuth   := aPOP[5]
Local lSSL        := aPOP[6]
Local cProtocolE  := aPOP[7]
Local cPortRec    := aPOP[8]
Local cError      := ""

Default oProcess := nil

If !lAuto .Or. oProcess<>Nil            
	oProcess:IncRegua1("Verificando e-mail "+AllTrim(cMailConta)+"...")
	oProcess:IncRegua2("Aguarde...")                        
EndIf

if cProtocolE == "2"
	MailImapConn ( cMailServer, cMailConta, cMailSenha ,,cPortRec, lSSL)
else
	MailPopConn ( cMailServer, cMailConta, cMailSenha ,,cPortRec, lSSL)
endif

If __MailError > 0 
	cRet := U_MailErro(__MailError)
	MsgAlert(cRet)
	return(.F.)
endif

//Modificado para versใo prothues 12 - 16/10/14
//inicio a variavel com valor 0
nMsgCount := 0
//Fun็ao PopMsgCountNFE e passo a variavel por referencia.
PopMsgCountNFE(@nMsgCount)

nCountMail := 0
oMessage   := TMailMessage():New()
oMessage:Clear()  

If !lAuto .Or. oProcess<>Nil            
	oProcess:SetRegua1(nMsgCount)
	oProcess:SetRegua2(0)

	oProcess:IncRegua1(AllTrim(Str(nMsgCount))+" E-mails encontrados...")
EndIf

For ttfmail := 1 to nMsgCount         

	__MailError := oMessage:Receive(__MailServer, ttfmail)
	If __MailError == 0
		acFrom := oMessage:cFrom
		acTo := oMessage:cTo
		acCc := oMessage:cCc
		acBcc := oMessage:cBcc
		acSubject := oMessage:cSubject
		acBody := oMessage:cBody
		nCountMail ++
		nCount := 0
		aaFiles := {}
		nTemXML := 0
		nAttach := oMessage:getAttachCount()

		For nInd := 1 to nAttach
			nTemXML := 0			
			aAttInfo := oMessage:getAttachInfo(nInd) 
			For ttx := 1 to Len(aAttInfo)
				If Upper(Right(aAttInfo[ttx],3)) == "XML"  
					nTemXML := ttx
					ttx := Len(aAttInfo)
				EndIf
			Next
	
			If nTemXML <> 0
				cFilename := acPath + "\" + RancaBarras( aAttInfo[nTemXML] )
				If !lAuto .Or. oProcess<>Nil            
					oProcess:IncRegua1("Verificando e-mail...")
					oProcess:IncRegua2("Arquivo ..."+Right(cFilename,20))                        
    			EndIf
				While file(cFilename)
					nCount++
					cFilename := acPath + "\" + substr(aAttInfo[nTemXML], 1, at(".", aAttInfo[nTemXML]) - 1) + strZero(nCount, 3) +;
					substr(aAttInfo[nTemXML], at(".", aAttInfo[nTemXML]))
				EndDo
				If Upper(Right(cFilename,4)) <> ".XML"
					Exit
				EndIf
				nHandle := FCreate(cFilename)
				if nHandle == 0
					__MailError == 2000
					return .f.
				EndIf
				FWrite(nHandle, oMessage:getAttach(nInd))
				FClose(nHandle)
				aAdd(aaFiles, { cFilename, aAttInfo[nTemXML]})

				MoveXml(lAuto,cFilename, @cError, @cLogProc,acPath+"\")
				FERASE(cFilename)
			EndIf    
		
		Next
		If alDelete
			__MailServer:DeleteMsg(ttfmail)
		Endif
	EndIf
	If !lAuto .Or. oProcess<>Nil            
		oProcess:IncRegua1("Restando "+AllTrim(Str(nMsgCount-ttfmail))+" E-mails...")
	EndIf
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDesconecta o e-mail                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if cProtocolE == "2"
	MailImapOff()
else
	MailPopOff ( )
endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLimpa os objetos em memoria                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DelClassIntf()

return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMailPopConn บ Autor ณ Roberto Souza    บ Data ณ  12/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MailPopConn ( cServer, cUser, cPassword, nTimeOut , cPortRec, lSSL)
Local nResult := 0
Default nTimeOut := 30                    		

__MailError	 := 0
If ValType(__MailServer) == "U"
	__MailServer := TMailManager():New()
Endif
if lSSL
	__MailServer:SetUseSSL( lSSL )
endif
//TMailManager(): Init ( < cMailServer>, < cSmtpServer>, < cAccount>, < cPassword>, [ nMailPort], [ nSmtpPort] ) 
__MailServer:Init(AllTrim(cServer), '', AllTrim(cUSer), AllTrim(cPassword) ,Val(cPortRec))
__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
__MailError := __MailServer:PopConnect()

Return( __MailError == 0 )


Static Function MailImapConn ( cServer, cUser, cPassword, nTimeOut , cPortRec, lSSL)
Local nResult := 0
Default nTimeOut := 15

__MailError	 := 0
If ValType(__MailServer) == "U"
	__MailServer := TMailManager():New()
Endif
//TMailManager(): Init ( < cMailServer>, < cSmtpServer>, < cAccount>, < cPassword>, [ nMailPort], [ nSmtpPort] ) 
if lSSL
	__MailServer:SetUseSSL( lSSL )
endif
__MailServer:Init(AllTrim(cServer),'', AllTrim(cUSer), AllTrim(cPassword) ,Val(cPortRec))
__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
__MailError := __MailServer:ImapConnect()

Return( __MailError == 0 )

                        
                                                            
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPopConn     บ Autor ณ Roberto Souza    บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PopConn ( cServer, cUser, cPassword, nTimeOut, nPort )
Local nRet   := 0
Local lRet   := .F.  
Local nMailError := 0
Default nTimeOut := 30                    		

nMailError	 := 0
If ValType(__MailServer) == "U"
	__MailServer := TMailManager():New()
Endif
//TMailManager(): Init ( < cMailServer>, < cSmtpServer>, < cAccount>, < cPassword>, [ nMailPort], [ nSmtpPort] ) 
__MailServer:Init(AllTrim(cServer), '', AllTrim(cUSer), AllTrim(cPassword) )
__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
__MailError := __MailServer:PopConnect()


U_MYAviso("Importa XML", "Visualiza detalhes",{"Sim","Nใo"})

Return( __MailError == 0 )  


Static Function MailPopOffNFE ( )
__MailError := __MailServer:PopDisconnect()
Return( __MailError == 0 )

Static Function MailImapOff()
__MailError := __MailServer:ImapDisconnect()
Return( __MailError == 0 )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัอออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPopMsgCountNFE บ Autor ณ Roberto Souza บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯอออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static function PopMsgCountNFE(nMsgCount)
nMsgCount := 0
__MailError := __MailServer:GetNumMsgs(@nMsgCount)
Return( __MailError == 0,nMsgCount)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaXmlAll  บ Autor ณ Roberto Souza      บ Data ณ  12/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores referente a NF-e, CT-e                    บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidaXmlAll(cModelo,cXml,cFilename,oMessage,nInd,nOpc,lInvalid,cLogProc,cFilXml,cKeyXml,cOcorr,aFilsEmp,oXmlOk)
Local cError    := ""
Local cWarning  := ""
Local cOcorr    := ""
Local lGrava    := .T.
Local lAppend   := .T.
Local lXmlCanc  := .F.
Local cMensagem := "" 
Local cCodRet   := ""
Local lValidado := .T.
Local lConsulta := .T.
Local nModoMail := 1
Local cAnexo    := ""
Local cChaveXml := "" 
Local cTipoDoc  := "N"  // Validar Tipo de DOcumento 
Local lContinua := .T.
Local nHdl      := -1
Local xManif    := ""   //GETESB2
Private oXml    := NIL
Private lSharedA1 := U_IsShared("SA1")
Private lSharedA2 := U_IsShared("SA2")
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6"))
Private nFormCTe  := Val(GetNewPar("XM_FORMCTE","6"))
Private nFormXML  := 6 
Private lForceT3  := AllTrim(GetNewPar("XM_FORCET3","N")) <> "N"
Private cT3       := AllTrim(GetNewPar("XM_FORCET3","N"))
Private cPref     := ""   
Private cTag      := ""
Private cTagTpEmiss:= ""
Private cTagTpAmb  := ""
Private cTagCHId   := ""
Private cTagSign   := ""
Private cTagProt   := ""
Private cTagKey    := ""
Private cTagDocEmit:= ""
Private cTagDocXMl := ""
Private cTagSerXml := ""
Private cTagDtEmit := ""
Private cTagDocDest:= "", cTagTpPag := ""  //GETESB
Private cTagIEDest := ""
Private cTagVerXml := ""
Private cTipoToma  := ""
Private cDtHrCOns  := ""
Private cVerXml    := ""
Private cVerNFE    := "2.00|2.01|3.10"
Private cVerCTE    := "1.03|1.04|1.05|2.00"
Private cMsgCanc   := ""
Private cMsgErr    := ""
Private lConsErr   := .F.
Private cTagUfDest := ""
Private cUfDest    := ""

Default nOpc    := 1
Default lInvalid:= .F.
Default cLogProc:= ""
Default cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

If cModelo == "55"
 	cPref    := "NF-e"
	cTAG     := "NFE"
	nFormXML := nFormNfe
	cVerOk   := cVerNFE
	cTagUfDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_ENDERDEST:_UF:TEXT"
ElseIf cModelo == "57"
 	cPref    := "CT-e"
	cTAG     := "CTE"
	nFormXML := nFormCte
	cVerOk   := cVerCTE
    cTagUfDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_ENDERDEST:_UF:TEXT"
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida็ใo da estrutura do XML.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ValidXml(@cXml,@cOcorr,@lInvalid,@cModelo)
If oXmlOk <> nil
	oXml  := oXmlOk
Else
	oXml := XmlParser( cXml, "_", @cError, @cWarning )  
EndIf

If Empty(cError) .And. Empty(cWarning) .And. !lInvalid .And. oXml <> Nil

		cTagTpEmiss:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPEMIS:TEXT"
		cTagTpAmb  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPAMB:TEXT"
		cTagCHId   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_ID:TEXT"
		cTagSign   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_SIGNATURE"
		cTagProt   := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_NPROT:TEXT"
		cTagKey    := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_CH"+cTAG+":TEXT"
		cTagDocEmit:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EMIT:_CNPJ:TEXT"

        cTagDocXMl := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_N"+Left(cTAG,2)+":TEXT"
        cTagSerXml := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_SERIE:TEXT"

		cTagVerXml := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_VERSAO:TEXT"
	    If Type(cTagVerXml)<>"U"
			cVerXml := &(cTagVerXml)
			If !cVerXml $ cVerOk
				cError += "Versใo de XML nใo suportada : "+cVerXml+" ."+CRLF
				cError += "Arquivo : "+cFilename+" "
				cLogProc += "Arquivo : "+cFilename+" "+"Versใo de XML nใo suportada : "+cVerXml+" ."+CRLF
		    	lInvalid := .T.
				lContinua := .F.
				lGrava := .F.
				If Type(cTagProt)== "U" .Or. Empty(&(cTagProt))  
					cProtocolo := ""
					cChaveXml  := Substr(&(cTagCHId),4,44)
				Else
					cProtocolo := &(cTagProt)
					cChaveXml  := &(cTagKey) 
				EndIf     
			EndIf
		Else
			cError += "Estrutura XML nใo suportado."+CRLF
			cError += "Arquivo : "+cFilename+" "
			cLogProc += "Arquivo : "+cFilename+" "+"Estrutura XML nใo suportado."+CRLF
	    	lInvalid  := .T.
			lContinua := .F.
			lGrava := .F.
			If Type(cTagProt)== "U" .Or. Empty(&(cTagProt))  
				cProtocolo := ""
				cChaveXml  := ""
			Else
				cProtocolo := &(cTagProt)
				cChaveXml  := ""
			EndIf     
		EndIf
		If lContinua
			if type(cTagUfDest) != "U"
				cUfDest := &(cTagUfDest)
			endif
			If cModelo == "55"
				cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DEMI:TEXT"
				if type(cTagDtEmit) == "U"
					cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DHEMI:TEXT"
				endif
				cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_CNPJ:TEXT"
				cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_IE:TEXT"
			ElSeIf cModelo == "57"
				/*
				0-Remetente; 
				1-Expedidor; 
				2-Recebedor; 
				3-Destinatแrio 
				*/
				cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DHEMI:TEXT"
				cTagTpPag  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_FORPAG:TEXT"

				If Type("oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA03:_TOMA:TEXT") <> "U"
					cTagToma := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA03:_TOMA:TEXT" 
				ElseIf Type("oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA4:_TOMA:TEXT") <> "U"
			   		cTagToma := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA4:_TOMA:TEXT"
				Else
				   	
				EndIf
				If cT3 $ "0123"
					cTipoToma  := cT3
				Else
					cTipoToma  := &(cTagToma)
				EndIf
				Do Case
					Case cTipoToma == "0"
						cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_CNPJ:TEXT"
						cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_IE:TEXT"
					Case cTipoToma == "1"
						cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EXPED:_CNPJ:TEXT"
						cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EXPED:_IE:TEXT"
					Case cTipoToma == "2"
						cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_RECEB:_CNPJ:TEXT"
						cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_RECEB:_IE:TEXT"
					Case cTipoToma == "3"
						cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_CNPJ:TEXT"
						cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_IE:TEXT"
					Case cTipoToma == "4" 
				   		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA4:_CNPJ:TEXT"
   						cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA4:_IE:TEXT"
					OtherWise   
						cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_CNPJ:TEXT"
						cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_IE:TEXT"
				EndCase
			Else
				cTagDtEmit := "" 
				cTagDocDest:= ""
				cTagIEDest := ""
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Valida็ใo Assinatura Digital.        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Type(cTagSign)== "U"
				cError += "O XML "+cFilename+" nใo possui Assinatura Digital."
				lContinua := .F.
				If !lXmlCanc
					lGrava := .T.
				EndIf
			EndIf
	 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Valida็ใo Protocolo.                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Type(cTagProt)== "U" .Or. Empty(&(cTagProt))  
				cError += "O XML "+cFilename+" nใo possui Protocolo de Autoriza็ใo."
				lContinua := .T.
				lGrava := .T.
				cProtocolo := ""
				cChaveXml  := Substr(&(cTagCHId),4,44)
			Else
				cProtocolo := &(cTagProt)
				cChaveXml  := &(cTagKey) 
			EndIf     

			DbSelectArea("ZBZ")
			DbSetOrder(3)
			If DbSeek(alltrim(cChaveXml)) 
			   If ZBZ->ZBZ_STATUS == "1" 
				    cError += "Este XML jแ esta na Base de Dados. A importa็ใo serแ Cancelada."+CRLF
				    cLogProc += "[XML] XML jแ consta na Base de Dados. " +cFilename +CRLF
				    lGrava := .F.
					lContinua := .F.
				Else
				    lGrava := .T.
				    lAppend:= .F.
				EndIf
			EndIf

			cTipoDoc := RetTpNf(cModelo,oXml)

			S_XML := cXml

			cDocXMl := Iif(nFormXML > 0,StrZero(Val(&(cTagDocXMl)),nFormXML),&(cTagDocXMl))
	        cSerXml := &(cTagSerXml)

	        //Altera็ใo para ITAMBษ 15/10/2014 - Alexandro de Oliveira
	        if ( GetNewPar("XM_SERXML","N") == "S" )
	        	if alltrim( cSerXml ) == '0' .or. alltrim( cSerXml ) == '00' .or. alltrim( cSerXml ) == '000'
	        		cSerXml := '   '
            	EndIf
            elseIf ( GetNewPar("XM_SERXML","N") == "Z" )
            	If Empty(cSerXml)
	        	    cSerXml := '0'	
                Endif
            endif

			cCnpjEmi  := &(cTagDocEmit)
			cDtEmit   := &(cTagDtEmit) 
			dDataEntr := StoD(substr(cDtEmit,1,4)+Substr(cDtEmit,6,2)+Substr(cDtEmit,9,2))

		    cFilXMLAtu := cFilAnt
		    cFilNova   := ""
		    cDocDest   := ""
		    cIEDest    := ""
		    If Type(cTagDocDest)<>"U"
		    	cDocDest := &(cTagDocDest)
		    Else
	   			lGrava := .F.
		    	lInvalid := .T.
				cOcorr := "Documento emitido sem CNPJ/CPF de destinatแrio."
		    EndIf
		    If Type(cTagIEDest)<>"U"
		    	cIEDest := &(cTagIEDest)
		    EndIf


	        nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest .and. AllTrim(x[5]) == AllTrim( cIEDest ) })
	        If nFilScan == 0
		        nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest })
	        EndIf
	        If nFilScan == 0
				If aScan(aFilsLic,{|x| x[2] == cDocDest }) > 0
					lXmlsLic := .T.
				EndIf
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Tratamento para consistencia na tag TOMA3.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		   	If nFilScan == 0 .And. cModelo == "57" .And. lForceT3
		    	lCont := .T.

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Busca no Toma 4 Primeiro, depois verifica os outros.ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			    If nFilScan == 0
					cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA4:_CNPJ:TEXT"
   					cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TOMA4:_IE:TEXT"
				    If Type(cTagIEDest)<>"U"
				    	cIEDest := &(cTagIEDest)
				    Else
					    cIEDest := ""
				    EndIf
				    If Type(cTagDocDest)<>"U"
				    	cDocDest := &(cTagDocDest)
				    	nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest .and. AllTrim(x[5]) == AllTrim( cIEDest ) })
				    	if nFilScan == 0
				    		nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest })
				    	endIf
	    		        If nFilScan == 0
							If aScan(aFilsLic,{|x| x[2] == cDocDest }) > 0
								lXmlsLic := .T.
							EndIf
						EndIf
				    Else 
				    	cDocDest := ""		    
			        EndIf
   				EndIf

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Busca no REMETENTE.                       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			    If nFilScan == 0
			   		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_CNPJ:TEXT"
					cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_IE:TEXT"
				    If Type(cTagIEDest)<>"U"
				    	cIEDest := &(cTagIEDest)
				    Else
					    cIEDest := ""
				    EndIf
				    If Type(cTagDocDest)<>"U"
				    	cDocDest := &(cTagDocDest)
				    	nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest .and. AllTrim(x[5]) == AllTrim( cIEDest ) })
				    	if nFilScan == 0
				    		nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest })
				    	endIf
	    		        If nFilScan == 0
							If aScan(aFilsLic,{|x| x[2] == cDocDest }) > 0
								lXmlsLic := .T.
							EndIf
						EndIf
				    Else 
				    	cDocDest := ""		    
			        EndIf
				EndIf
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Busca no EXPEDIDOR.                       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			    If nFilScan == 0
			   		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EXPED:_CNPJ:TEXT"
					cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EXPED:_IE:TEXT"
				    If Type(cTagIEDest)<>"U"
				    	cIEDest := &(cTagIEDest)
				    Else
					    cIEDest := ""
				    EndIf
				    If Type(cTagDocDest)<>"U"
				    	cDocDest := &(cTagDocDest)
				    	nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest .and. AllTrim(x[5]) == AllTrim( cIEDest ) })
				    	if nFilScan == 0
				    		nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest })
				    	endIf
	    		        If nFilScan == 0
							If aScan(aFilsLic,{|x| x[2] == cDocDest }) > 0
								lXmlsLic := .T.
							EndIf
						EndIf
				    Else
				    	cDocDest := ""		    
			        EndIf
				EndIf
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Busca no RECEBEDOR.                       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			    If nFilScan == 0
			   		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_RECEB:_CNPJ:TEXT"
					cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_RECEB:_IE:TEXT"
				    If Type(cTagIEDest)<>"U"
				    	cIEDest := &(cTagIEDest)
				    Else
					    cIEDest := ""
				    EndIf
				    If Type(cTagDocDest)<>"U"
				    	cDocDest := &(cTagDocDest)
				    	nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest .and. AllTrim(x[5]) == AllTrim( cIEDest ) })
				    	if nFilScan == 0
				    		nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest })
				    	endIf
	    		        If nFilScan == 0
							If aScan(aFilsLic,{|x| x[2] == cDocDest }) > 0
								lXmlsLic := .T.
							EndIf
						EndIf
				    Else
				    	cDocDest := ""		    
			        EndIf
				EndIf
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Busca no DESTINATARIO.                    ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			    If nFilScan == 0
			   		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_CNPJ:TEXT"
					cTagIEDest := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_IE:TEXT"
				    If Type(cTagIEDest)<>"U"
				    	cIEDest := &(cTagIEDest)
				    Else
					    cIEDest := ""
				    EndIf
				    If Type(cTagDocDest)<>"U"
				    	cDocDest := &(cTagDocDest)
				    	nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest .and. AllTrim(x[5]) == AllTrim( cIEDest ) })
				    	if nFilScan == 0
				    		nFilScan := aScan(aFilsEmp,{|x| x[2] == cDocDest })
				    	endIf
	    		        If nFilScan == 0
							If aScan(aFilsLic,{|x| x[2] == cDocDest }) > 0
								lXmlsLic := .T.
							EndIf
						EndIf
				    Else
				    	cDocDest := ""		    
			        EndIf
				EndIf

		    EndIf

		    If nFilScan > 0
	    	   	cFilAnt   := aFilsEmp[nFilScan][1]
			    cFilNova  := aFilsEmp[nFilScan][1]
			    cNomFil   := aFilsEmp[nFilScan][3]
				cFilXML   := cFilAnt			
				If cTipoDoc $ "D|B"
					DbSelectArea("SA1")
					DbSetOrder(3)
					cFilSeek := Iif(lSharedA1,xFilial("SA1"),cFilNova)
					If DbSeek(cFilSeek+cCnpjEmi)
						cCodEmit  := SA1->A1_COD
						cLojaEmit := SA1->A1_LOJA
					    cRazao    := SA1->A1_NOME
						Do While .not. SA1->( eof() ) .and. SA1->A1_FILIAL == cFilSeek .and.;
						               SA1->A1_CGC == cCnpjEmi
							if SA1->A1_MSBLQL != "1"
								cCodEmit  := SA1->A1_COD
								cLojaEmit := SA1->A1_LOJA
							    cRazao    := SA1->A1_NOME
								exit
							endif
							SA1->( dbSkip() )
						EndDo
		    		Else
						cCodEmit  := ""
						cLojaEmit := ""
					    cRazao    := ""		    		
		    		EndIf
				Else
					DbSelectArea("SA2")
					DbSetOrder(3)
					cFilSeek := Iif(lSharedA2,xFilial("SA2"),cFilNova)
					If DbSeek(cFilSeek+cCnpjEmi)
						cCodEmit  := SA2->A2_COD
						cLojaEmit := SA2->A2_LOJA
					    cRazao    := SA2->A2_NOME
						Do While .not. SA2->( eof() ) .and. SA2->A2_FILIAL == cFilSeek .and.;
						               SA2->A2_CGC == cCnpjEmi
							if SA2->A2_MSBLQL != "1"
								cCodEmit  := SA2->A2_COD
								cLojaEmit := SA2->A2_LOJA
							    cRazao    := SA2->A2_NOME
								exit
							endif
							SA2->( dbSkip() )
						EndDo
		    		Else
						cCodEmit  := ""
						cLojaEmit := ""
					    cRazao    := ""		    		
		    		EndIf
	    		EndIf        

		    Else
		    	If lXmlsLic
			    	cError += "Este XML nใo pertence a Empresa/Filial Licenciada! C๓digo "+AllTrim(SM0->M0_CODIGO)+" "  +CRLF
					cOcorr := "Documento emitido para CNPJ/CPF Nใo Licenciada."
		    	Else
			    	cError += "Este XML nใo pertence a Empresa/Filial ! C๓digo "+AllTrim(SM0->M0_CODIGO)+" "  +CRLF
					cOcorr := "Documento emitido para CNPJ/CPF diferente da empresa cadastrada."
				EndIf
			    cFilAnt   := cFilXMLAtu
	   			lGrava    := .F.
		    	lInvalid  := .T.
				cFilXML   := "XX"
				lConsulta := .F.
		    EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Consulta o Xml na Sefaz.                  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
			If lConsulta
				lValidado := U_XConsXml(cURL,cChaveXml,cModelo,cProtocolo,@cMensagem,@cCodRet,AllTrim(SuperGetMv("MV_MOSTRAA")) == "S",,,@xManif) //GETESB2
				cDtHrCOns := HfPutdt(1,dDatabase, Time(),"")
				If cCodRet == "101"
					lXmlCanc := .T. 
					cOcorr   := cMensagem
					cMsgCanc := "Tipo de xml: " + cPref +CRLF
					cMsgCanc += "Chave      : " + cChaveXml +CRLF
					cMsgCanc += "Observa็ใo : " + "Cancelamento do Xml de "+cPref+ " autorizado." +CRLF
					cMsgCanc += "Aviso      : " + "Cancele o documento de "+cPref+ " manualmente." +CRLF
//					SendMailCanc(1,cModelo,cChaveXml,cFilename,cMsgCanc,"","")
				ElseIf cCodRet <> "100"
					lConsErr := .T.
					cOcorr   := cMensagem
					cMsgErr := "Tipo de xml: " + cPref +CRLF
					cMsgErr += "Chave      : " + cChaveXml +CRLF
					cMsgErr += "Observa็ใo : " + "Erro na consulta do Xml de "+cPref+ "." +CRLF
					cMsgErr += "Aviso      : " + "Consulte o Xml manualmente pela rotina padrใo ou aguarde at้ a proxima consulta automแtica." +CRLF					                  
					
				EndIf
	
			EndIf
	 
		EndIf        
        If !Empty(AllTrim(cOcorr+cError)) .And. !lXmlCanc
			SendMailError(1,cModelo,oXml,cFilename,cOcorr,cError,cWarning)
		EndIf
Else
	lGrava := .F.           
	SendMailError(1,cModelo,oXml,cFilename,cOcorr,cError,cWarning)   

EndIf
       
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                               Status                                  บฑฑ
ฑฑฬออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบE-Mail    ณ 0-Xml Ok (Nใo envia)                                       บฑฑ
ฑฑบ          ณ 1-Xml com erro (Eendente)                                  บฑฑ
ฑฑบ          ณ 2-Xml com erro (Enviado)                                   บฑฑ
ฑฑบ          ณ 3-Xml cancelado (Pendente)                                 บฑฑ
ฑฑบ          ณ 4-Xml cancelado (Enviado)                                  บฑฑ
ฑฑบ          ณ X-Falha ao enviar o e-mail (Erro)                          บฑฑ
ฑฑบ          ณ Y-Falha ao enviar o e-mail (Cancelamento)                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ IMPORTA XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
If lGrava
	cStatusXml := ""
	cStatReg   := "" 
	cInfoErro  := ""
	Do Case
		Case lXmlCanc
		    	cStatusXml := "X"  
		    	cStatReg   := "2"
		    	cStatMail  := "3"          
		    	cInfoErro  := GetInfoErro(cStatMail,cMsgCanc,cModelo)
	    Case Empty(cError) .And. Empty(cWarning) .And. Empty(cOcorr) .And. lValidado
				cStatusXml := "B"  
		    	cStatReg   := "1"  
		    	cStatMail  := "0"				  
	    		cInfoErro  := ""
	    Case lConsErr
				cStatusXml := "Z"  
		    	cStatReg   := "2"  
		    	cStatMail  := "0"				  
	    		cInfoErro  := ""		    
	    OtherWise
		    	cStatusXml := "F"
		    	cStatReg   := "2"
		    	cStatMail  := "1"		    	
				cInfoErro  := GetInfoErro(cStatMail,(cMensagem+CRLF+cError+CRLF+cWarning+CRLF+cOcorr),cModelo)
	EndCase

	nHdl := -1
	If TravaXml("TRAVA", cChaveXml, @nHdl) //por AQUIIIIIIIIII
		DbSelectArea("ZBZ")
		DbSetOrder(3)

		If !DbSeek(alltrim(cChaveXml)) .Or. (!lAppend) .Or. (DbSeek(alltrim(cChaveXml)) .And. ZBZ->ZBZ_STATUS="2")                           
			Reclock("ZBZ",lAppend) 
			ZBZ->ZBZ_CHAVE  := cChaveXml  //Colocado no ํnicio para evitar a Fadiga
			ZBZ->ZBZ_FILIAL := cFilAnt
			ZBZ->ZBZ_CNPJ   := cCnpjEmi
			ZBZ->ZBZ_CNPJD  := cDocDest    
			ZBZ->ZBZ_CLIENT := cNomFil
			ZBZ->ZBZ_SERIE  := verSerie( cSerXMl, cFilAnt )
			ZBZ->ZBZ_NOTA   := cDocXMl
			ZBZ->ZBZ_FORNEC := cRazao
			ZBZ->ZBZ_DTRECB := dDataBase
			ZBZ->ZBZ_DTNFE  := dDataEntr
			ZBZ->ZBZ_XML    := S_XML
			ZBZ->ZBZ_PRENF  := cStatusXml
			ZBZ->ZBZ_STATUS := cStatReg
			ZBZ->ZBZ_OBS    := cMensagem+CRLF+cError+CRLF+cWarning+CRLF+cOcorr
			ZBZ->ZBZ_MODELO := cModelo
			ZBZ->ZBZ_CODFOR := cCodEmit		
			ZBZ->ZBZ_LOJFOR := cLojaEmit
			ZBZ->ZBZ_TPDOC  := cTipoDoc
			ZBZ->ZBZ_UF     := cUfDest
			ZBZ->ZBZ_SERORI := cSerXMl
			If ZBZ->(FieldPos("ZBZ_FORPAG"))>0    //GETESB
				if Type( cTagTpPag ) <> "U"
					ZBZ->ZBZ_FORPAG := &(cTagTpPag)
				else
					ZBZ->ZBZ_FORPAG := "1"
				endif
			Endif
			If ZBZ->(FieldPos("ZBZ_CONDPG"))>0    //GETESB
				ZBZ->ZBZ_CONDPG := U_HF02CPG()
			EndIf
			If ZBZ->(FieldPos("ZBZ_TPEMIS"))>0 .And. ZBZ->(FieldPos("ZBZ_TPAMB"))>0 
				ZBZ->ZBZ_TPEMIS := &(cTagTpEmiss) 
				ZBZ->ZBZ_TPAMB  := &(cTagTpAmb)
			EndIf
			If ZBZ->(FieldPos("ZBZ_TOMA"))>0 .And. ZBZ->(FieldPos("ZBZ_DTHRCS"))>0
		   		ZBZ->ZBZ_TOMA  := cTipoToma
		   		ZBZ->ZBZ_DTHRCS:= cDtHrCOns
			EndIf
			If ZBZ->(FieldPos("ZBZ_PROT"))>0 
				ZBZ->ZBZ_PROT  := cProtocolo
			EndIf				
	 		If ZBZ->(FieldPos("ZBZ_VERSAO"))>0
		   		ZBZ->ZBZ_VERSAO:= cVerXml
			EndIf				        
	 		If ZBZ->(FieldPos("ZBZ_MAIL"))>0
		   		ZBZ->ZBZ_MAIL   := cStatMail
		   		ZBZ->ZBZ_DTMAIL := cInfoErro	   		
			EndIf				   		
			if ZBZ->(FieldPos("ZBZ_MANIF")) > 0 //GETESB2
				ZBZ->ZBZ_MANIF := xManif
			endif

			MsUnLock()            
			cLogProc += "[XML] "+ZBZ->ZBZ_CHAVE +" importado com sucesso."+CRLF
		EndIf
		cKeyXml := cChaveXml
//		cFilXml := cFilAnt
		cFilAnt := cFilXMLAtu

		TravaXml("SOLTA", cChaveXml, nHdl)   //SOLTAR AQUIIIIII

		//PEDIDO RECORRENTE
		If x_Ped_Rec == "S"
			U_XML09PDR( @cLogProc, .F. )  //log, exibir
		EndIf

	Else
		cLogProc += "[XML] Erro ao Travar "+cChaveXml +"."+CRLF
	    lGrava := .F.
		lContinua := .F.
		lInvalid := .T.
	Endif

EndIf	 
//cFilXml := cFilAnt                        
cKeyXml := cChaveXml
cOcorr  := cError            

Return(.T.)


Static Function TravaXml(xTip, xChaveXml, nHdl)
Local cArq := ""
Local cDir := cBarra+AllTrim(GetNewPar("MV_X_PATHX",""))+cBarra
Local lRet := .T.
Local nConta := 0

If Empty(xChaveXml)
	return( .T. )
endIf

cDir := StrTran(cDir,cBarra+cBarra,cBarra)
cArq := cDir + xChaveXml + ".Trv"

If xTip == "TRAVA"
	nConta := 0
	Do While File( cArq )
		Sleep( 50 )
		nConta++
		if nConta > 10
			lRet := .F.
			Exit
		endif
	EndDo
	if lRet
		nConta := 0
		nHdl := -1
		Do While nHdl < 0
			if nConta > 0
				Sleep( 50 )
			endif
			nHdl := fCreate(cArq)
			nConta++
			if nConta > 10
				lRet := .F.
				Exit
			endif
		EndDo
	endif
Else
	if File( cArq )
		if nHdl > 0
		   fClose(nHdl)
		endif
		nHdl := -1

		nConta := 0
		Do While nHdl < 0
			if nConta > 0
				Sleep( 50 )
			endif
			nHdl := FErase(cArq)
			nConta++
			if nConta > 10
				Exit
			endif
		EndDo
	EndIf
Endif

Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ              บ Autor ณ Eneovaldo Roveri Jrบ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna o S้rie de acordo com a GRABER.                        บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function verSerie( cSerXMl, cFilAnt )
Local cRet := cSerXMl
Local cSrr := AllTrim(GetNewPar("XM_SEREMP",""))
Local aSrr := Separa(cSrr,";")
Local nI   := 0
Local cAux := ""

If .Not. empty( cSrr )
	if ";" $ cSrr .or. "," $ cSrr
		For nI := 1 To len( aSrr )
			if cFilAnt $ aSrr[nI]
				cAux := Substr( aSrr[nI], 1, AT("=",aSrr[nI] )-1 )
				cAux := AllTRim( cAux )
				if len( cAux ) >= 1 .and. len( cAux ) <= 3
					cRet := cAux
					Exit
				endif
			endif
		Next nI
	Else
		cRet := cSrr
	Endif
EndIf

Return( cRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancXmlAll    บ Autor ณ Roberto Souza      บ Data ณ  23/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores referente a NF-e, CT-e                    บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CancXmlAll(cModelo,cXml,cFilename,oMessage,nInd,nOpc,lInvalid,cLogProc,cFilXml,cKeyXml,cOcorr,aFilsEmp,oXmloK)
Local cError    := ""
Local cWarning  := ""
Local cOcorr    := ""
Local lGrava    := .T.
Local lAppend   := .T.
Local lXmlCanc  := .F.
Local cMensagem := ""
Local lValidado := .T.
Local lConsulta := .T.
Local nModoMail := 1
Local cAnexo    := ""
Local cChaveXml := "" 
Local cTipoDoc  := "N"  // Validar Tipo de DOcumento 
Local lContinua := .T.
Local lEvento   := .F.
Local cEvento   := ""
Private cTagEvento:= ""
Private cPref     := ""   
Private cTag      := ""
Private cTagTpEmiss:= ""
Private cTagTpAmb  := ""
Private cTagCHId   := ""
Private cTagSign   := ""
Private cTagProt   := ""
Private cKey       := ""
Private cTagDocEmit:= ""
Private cTagDocXMl := ""
Private cTagSerXml := ""
Private cTagDtEmit := ""
Private cTagDocDest:= ""
Private cTipoToma  := ""
Private cDtHrCOns  := ""
Private cTagId     := ""
Private cTagRet    := ""
Private oXml

Default nOpc    := 1
Default lInvalid:= .F.
Default cLogProc:= ""
Default cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

If cModelo == "55"
 	cPref    := "NF-e"                             
	cTAG     := "NFE"
ElseIf cModelo == "57"
 	cPref    := "CT-e"                             
	cTAG     := "CTE"
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida็ใo da estrutura do XML.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oXml := XmlParser( cXml, "_", @cError, @cWarning )  

If Empty(cError) .And. Empty(cWarning) .And. !lInvalid
		
	cTagId := "oXml:_PROCCANC"+cTAG+":_CANC"+cTAG+":_INFCANC"
	cTagRet:= "oXml:_PROCCANC"+cTAG+":_RETCANC"+cTAG+":_INFCANC"
 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo Info do cancelamento       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Type(cTagId)== "U"

		cTagId := "oXml:_PROCEVENTO"+cTAG+":_EVENTO"+":_INFEVENTO"
		cTagRet:= "oXml:_PROCEVENTO"+cTAG+":_RETENVEVENTO"+":_RETEVENTO"+":_INFEVENTO"

		If Type(cTagId)== "U"
			cError += CRLF+"O XML "+cFilename+" nใo possui as informa็๕es de cancelamento."
			lContinua := .F.
		else
			lEvento := .T.
			cTagEvento := "oXml:_PROCEVENTO"+cTAG+":_EVENTO"+":_INFEVENTO:_TPEVENTO:TEXT"
			If Type(cTagId)== "U"
				cError += CRLF+"O XML "+cFilename+" nใo possui evento de cancelamento."
				lContinua := .F.
			else
				cEvento := &(cTagEvento)
				if cEvento <> "110111"
					cError += CRLF+"O XML "+cFilename+" possui o evento diferente de cancelamento "+cEvento
					lContinua := .F.
				endif
			endif
		Endif

	EndIf			
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo Retorno do cancelamento    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Type(cTagRet)== "U"
		cError += CRLF+"O XML "+cFilename+" nใo possui retorno de cancelamento."
		lContinua := .F.
	EndIf
			
	If lContinua					

		if lEvento

			oRetId := &("oXml:_PROCEVENTO"+cTAG+":_EVENTO"+":_INFEVENTO")
			oRetC  := &("oXml:_PROCEVENTO"+cTAG+":_RETENVEVENTO"+":_RETEVENTO"+":_INFEVENTO")
	
			cProt   := oRetId:_DETEVENTO:_NPROT:TEXT
			cKey    := &("oRetId:_CH"+cTAG+":TEXT")       
		    cJust   := oRetId:_DETEVENTO:_XJUST:TEXT
	    
			cProtC  := oRetC:_NPROT:TEXT
			cDthRet := oRetC:_DHREGEVENTO:TEXT      
			cRetStat:= oRetC:_CSTAT:TEXT
			cMotX   := oRetC:_XMOTIVO:TEXT
		
		Else

			oRetId := &("oXml:_PROCCANC"+cTAG+":_CANC"+cTAG+":_INFCANC")
			oRetC  := &("oXml:_PROCCANC"+cTAG+":_RETCANC"+cTAG+":_INFCANC")
	
			cProt   := oRetId:_NPROT:TEXT
			cKey    := &("oRetId:_CH"+cTAG+":TEXT")       
		    cJust   := oRetId:_XJUST:TEXT
	    
			cProtC  := oRetC:_NPROT:TEXT
			cDthRet := oRetC:_DHRECBTO:TEXT      
			cRetStat:= oRetC:_CSTAT:TEXT
			cMotX   := oRetC:_XMOTIVO:TEXT

		Endif

		DbSelectArea("ZBZ")
		DbSetOrder(3)
		If DbSeek(alltrim(cKey)) 
			If ZBZ->ZBZ_PRENF == "X"
				cOcorr += "Cancelamento de xml: "+cPref +CRLF
				cOcorr += "Chave :" + cKey 	 +CRLF
				cOcorr += "Obs.  :" + "Xml de "+cPref+ " jแ estแ cancelado na base de dados." +CRLF	

				Reclock("ZBZ",.F.)     //Faltava isto, gravar o xml de cancelamento. (QUATROK).
				if empty( ZBZ->ZBZ_DTHCAN )
		   			ZBZ->ZBZ_DTHCAN := cDthRet
		  		endif
		  		if empty(ZBZ->ZBZ_XMLCAN)
					ZBZ->ZBZ_XMLCAN := cXml
				endif
				if empty(ZBZ->ZBZ_PROTC)
					ZBZ->ZBZ_PROTC  := cProtC
				endif
				MsUnLock()
			Else
				cOcorr += "Tipo de xml: " + cPref +CRLF
				cOcorr += "Chave      : " + cKey +CRLF
				cOcorr += "Observa็ใo : " + "Cancelamento do Xml de "+cPref+ " autorizado." +CRLF
				cOcorr += "Aviso      : " + "Cancele o documento de "+cPref+ " manualmente." +CRLF

	 	  		cOcorr:= GetInfoErro("3",cOcorr,cModelo)
	 			
				Reclock("ZBZ",.F.) 
		   		ZBZ->ZBZ_DTHCAN := cDthRet
				ZBZ->ZBZ_XMLCAN := cXml
				ZBZ->ZBZ_PROTC  := cProtC 
				ZBZ->ZBZ_PRENF  := "X"
				ZBZ->ZBZ_MAIL   := "3"
				ZBZ->ZBZ_DTMAIL := cOcorr
				MsUnLock()
	
 			EndIf 
 			

		Else
			cOcorr += "Cancelamento de xml: "+cPref +CRLF
			cOcorr += "Chave :" + cKey 	 +CRLF
			cOcorr += "Obs.  :" + "Nใo foi encontrado o Xml de "+cPref+ "." +CRLF	
		EndIf
		
//		SendMailCanc(1,cModelo,cKey,cFilename,cOcorr,cError,cWarning)    
	Else
		SendMailError(1,cModelo,oXml,cFilename,cOcorr,cError,cWarning)
	EndIf
Else
	        
	SendMailError(1,cModelo,oXml,cFilename,cOcorr,cError,cWarning)   

EndIf
  
cFilXml := cFilAnt                        
cKeyXml := cKey
cOcorr  += cError
oXmloK  := oXml

Return(.T.)
            



Static Function	SendMailError(nTipo,cModelo,oXml,cFilename,cOcorr,cError,cWarning)   
Local cPref   := ""
Local cTAG    := ""
Local cAnexo  := ""                
Local cMsgErr := ""
Local nNotifica := Val(GetSrvProfString("HF_NOTIFICA","0"))
If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf

	cEmailErr := AllTrim(SuperGetMv("XM_MAIL02")) // Conta de Email para erros
	lMailErr := !Empty(cEmailErr)        
    
	If lMailErr
	
	    aTo := Separa(cEmailErr,";")
		cMsg:=""
		If !Empty(cError)   
			cMsg+= "ERROS : "
			cMsg+= cOcorr+CRLF+cError +CRLF
	    EndIF     
		
		If !Empty(cWarning)     
			cMsg+= "AVISOS : "
			cMsg+= cOcorr+CRLF+cError +CRLF+ cWarning+CRLF
	    EndIF
	    
	    cTagKey := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_CH"+cTAG+":TEXT"
	    
	    cMsg+= "XML Invalido: "+ cFilename
	    If Type(cTagKey)<> "U"
			cMsg+= CRLF+"Chave :"+&(cTagKey)
	    EndIf
	    cAssunto:= "Aviso de Falha Xml/"+cPref+" de Entrada."
		cDirMail  := AllTrim(SuperGetMv("MV_X_PATHX")) + "\template\"+"xml_erro.html"
		Iif(lUnix,StrTran(cDirMail,"\","/"),cDirMail)
		If File(cDirMail)
			cTemplate := MemoRead(cDirMail)		  
		Else   
			cTemplate := ''
		EndIf     

		cBodyMail := ""

		While !Empty(cTemplate)
			nPosIni := At("<%=",cTemplate)
			nPosFim := At("%>" ,SubStr(cTemplate,nPosIni+3))
			If nPosIni <> 0 .And. nPosFim <> 0
				cBodyMail += SubStr(cTemplate,1,nPosIni-1)	
				cMacro := ""
				lBreak := .F.
				bErro  := ErrorBlock({|e| lBreak := .T. })
				Begin Sequence
					cMacro := SubStr(cTemplate,nPosIni+3,nPosFim-1)
					cMacro := &(cMacro)
					If lBreak
						Break
					EndIf		
				Recover
					cMacro := "Error"
				End Sequence
				ErrorBlock(bErro)		
				cBodyMail += AllTrim(cMacro)		
				cTemplate := SubStr(cTemplate,nPosIni+nPosFim+4)
			Else
				cBodyMail += cTemplate
				cTemplate := ""
		    EndIf    
		EndDo	
	    If  !Empty(cBodyMail)
	    	cMsg := cBodyMail
	    EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Envia E-mail.                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nNotifica == 2
			HfSetMail(aTo,cAssunto,cMsg,@cMsgErr,cAnexo,cAnexo,cEmailErr)
		Else
			//U_HX_MAIL(aTo,cAssunto,cMsg,@cMsgErr,cAnexo,cAnexo,cEmailErr)
			U_MAILSEND(aTo,cAssunto,cMsg,@cError,cAnexo,cAnexo,cEmailErr,"","")
		EndIf
	EndIf

Return(cMsgErr)

 
Static Function	SendMailCanc(nTipo,cModelo,cKey,cFilename,cOcorr,cError,cWarning)   
Local cPref     := ""                             
Local cTAG      := ""
Local cAnexo    := ""                 
Local nNotifica := Val(GetSrvProfString("HF_NOTIFICA","0"))

If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf

	cEmailErr := AllTrim(SuperGetMv("XM_MAIL01")) // Conta de Email para cancelamentos
	lMailErr := !Empty(cEmailErr)        
    
	If lMailErr
	
	    aTo := Separa(cEmailErr,";")
		cMsg:= cOcorr
		If !Empty(cError)   
			cMsg+= CRLF+"ERROS : "
			cMsg+= cError 
	    EndIF     
		
		If !Empty(cWarning)     
			cMsg+= CRLF+"AVISOS : "
			cMsg+= cOcorr+CRLF+cError +CRLF+ cWarning+CRLF
	    EndIF
	    
	    cTagKey := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_CH"+cTAG+":TEXT"
	    
//		cMsg+= CRLF+"Chave :"+cKey
	    cAssunto:= "Aviso de Cancelamento Xml/"+cPref+" de Entrada."
		cDirMail  := AllTrim(SuperGetMv("MV_X_PATHX")) + "\template\"+"xml_erro.html"
		Iif(lUnix,StrTran(cDirMail,"\","/"),cDirMail)
		If File(cDirMail)
			cTemplate := MemoRead(cDirMail)		  
		Else   
			cTemplate := ''
		EndIf     

		cBodyMail := ""

		While !Empty(cTemplate)
			nPosIni := At("<%=",cTemplate)
			nPosFim := At("%>" ,SubStr(cTemplate,nPosIni+3))
			If nPosIni <> 0 .And. nPosFim <> 0
				cBodyMail += SubStr(cTemplate,1,nPosIni-1)	
				cMacro := ""
				lBreak := .F.
				bErro  := ErrorBlock({|e| lBreak := .T. })
				Begin Sequence
					cMacro := SubStr(cTemplate,nPosIni+3,nPosFim-1)
					cMacro := &(cMacro)
					If lBreak
						Break
					EndIf		
				Recover
					cMacro := "Error"
				End Sequence
				ErrorBlock(bErro)		
				cBodyMail += AllTrim(cMacro)		
				cTemplate := SubStr(cTemplate,nPosIni+nPosFim+4)
			Else
				cBodyMail += cTemplate
				cTemplate := ""
		    EndIf    
		EndDo	
	    If  !Empty(cBodyMail)
	    	cMsg := cBodyMail
	    Else
			cMsgCfg := ""
			cMsgCfg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">
			cMsgCfg += '<head>
			cMsgCfg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			cMsgCfg += '<title>Importa XML</title>
			cMsgCfg += '  <style type="text/css"> 
			cMsgCfg += '	<!-- 
			cMsgCfg += '	body {background-color: rgb(37, 64, 97);} 
			cMsgCfg += '	.style1 {font-family: Hyperfont,Verdana, Arial;font-size: 12pt;} 
			cMsgCfg += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} 
			cMsgCfg += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} 
			cMsgCfg += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} 
			cMsgCfg += '	.style5 {font-size: 10pt} 
			cMsgCfg += '	--> 
			cMsgCfg += '  </style>
			cMsgCfg += '</head>
			cMsgCfg += '<body>
			cMsgCfg += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">
			cMsgCfg += '  <tbody>
			cMsgCfg += '    <tr>
			cMsgCfg += '      <td colspan="2">
			cMsgCfg += '    <Center>
//			cMsgCfg += '      <img src="http://extranet.helpfacil.com.br/images/cabecalho.jpg">
			cMsgCfg += '      <H2>CANCELAMENTO</H2>
			cMsgCfg += '      </Center>
			cMsgCfg += '      <hr>			
			cMsgCfg += '      <p class="style1">'+cMsg+'</p>
			cMsgCfg += '      <hr>			
			cMsgCfg += '      </td>
			cMsgCfg += '    </tr>
			cMsgCfg += '  </tbody>
			cMsgCfg += '</table>
			cMsgCfg += '<p class="style1">&nbsp;</p>
			cMsgCfg += '</body>
			cMsgCfg += '</html>
	        cMsg    := cMsgCfg
	    EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Envia E-mail.                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nNotifica == 2
			HfSetMail(aTo,cAssunto,cMsg,@cError,cAnexo,cAnexo,cEmailErr)
		Else
			U_HX_MAIL(aTo,cAssunto,cMsg,@cError,cAnexo,cAnexo,cEmailErr)
		EndIf
	EndIf

Return



 
User Function XGetFilS(cCnpjRoot,aFilsLic)

Local aRet    := {}
Local aArea   := GetArea()
Local cEmpProc:= AllTrim(SM0->M0_CODIGO)
Local cFilProc:= AllTrim(SM0->M0_CODFIL)
Local nRecFil := 1

DbSelectArea("SM0")
nRecFil := Recno()
DbGotop()
While !Eof()
    	//12.310.876/0001-90
	If Alltrim(SM0->M0_CODIGO) == cEmpProc //.And. Alltrim(Substr(SM0->M0_CGC,1,8))== Alltrim(Substr(cCnpjRoot,1,8))
		// a Partir 10/04/14 vai verificar cada filial exclusivamente, entใo verificar se tem licen็a cada CNPJ.
		If U_HFXML00X("HF000001","101",SM0->M0_CGC,,.F.)
			Aadd(aRet,{SM0->M0_CODFIL,SM0->M0_CGC,SM0->M0_FILIAL,SM0->M0_NOMECOM,SM0->M0_INSC})
		Else
			//Filiais sem licen็a
			Aadd(aFilsLic,{SM0->M0_CODFIL,SM0->M0_CGC,SM0->M0_FILIAL,SM0->M0_NOMECOM,SM0->M0_INSC})
		EndIF
	EndIf

	DbSkip()

EndDO
dbgoto(nRecFil)
RestArea(aArea)

Return(aRet)



Static Function HfPutdt(nTipo,dData, cTime, cData)
Local xRet := Nil           

If nTipo == 1
	xRet := dTos(dData)
	XRet := Substr(xRet,1,4)+"-"+Substr(xRet,5,2)+"-"+Substr(xRet,7,2)+"T"+cTime
EndIf
                       
Return(xRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02E  บ Autor ณ Roberto Souza      บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02E()
Local aArea := GetArea()
Processa( {|| ExpNFEFOR() }, "Aguarde...", "Exportando XML ...",.F.)
RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExpNFEFOR บ Autor ณ Roberto Souza      บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ExpNFEFOR()
Local cAliasZBZ:= GetNextAlias()
Local aPerg    := {}
Local cWhere   := ""
Local aParam   := {Space(Len(SF2->F2_FILIAL)),Space(Len(SF2->F2_FILIAL)),Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(60),CToD("01/01/2001"),dDataBase,Space(14),Space(14),CToD("01/01/2001"),dDataBase}
Local cParXMLExp := AllTrim(SM0->M0_CODIGO)+AllTrim(SM0->M0_CODFIL)+"HFXMLEXP"
Local cExt     := ".xml"
Local cNfes    := ""
Local _cLoad   := ""
Local cVersao  := "20140214"
Local cArqVer  := "\profile\"+__cUserID+"_"+cParXMLExp+".Exp"
Local cLidVer  := ""
Local nHandle  := 0
Local cProfile := ""
Local nLinha   := 0

If .NOT. File( cArqVer )
	cLidVer := ""
Else
	cLidVer := LerComFRead( cArqVer )
EndIf

If cLidVer != cVersao
	//Foi mudado Algo nos parametros. Apagar o tal arquivo para criar novamente.
	if File( "\profile\"+__cUserID+"_"+cParXMLExp+".PRB" )
		nErase := FErase( "\profile\"+__cUserID+"_"+cParXMLExp+".PRB" )
		If nErase < 0
			U_MYAviso("ERRO","Nใo foi possivel recriar o arquivo "+__cUserID+"_"+cParXMLExp+".PRB. Verifique permiss๕es de grava็ใo na Pasta \profile\.",{"Ok"},3)
			Return( NIL )
		EndIf
	EndIf
	nHandle := FCreate(cArqVer)

	If nHandle <= 0
		U_MYAviso("ERRO","Nใo foi possivel criar o arquivo "+cArqVer+". Verifique permiss๕es de grava็ใo na Pasta \profile\.",{"Ok"},3)
		Return( NIL )
	Else
		FWrite(nHandle, cVersao)
		FClose(nHandle)
	EndIf	
EndIf

If ParamLoad(cParXMLExp,aParam,0,"1")== "2" 
	_cLoad := ""
Else	
	_cLoad := __cUserID+"_"
Endif         

if valtype(aParam[07]) <> "D"
	aParam[07] := ctod("01/01/2001")
endif
if valtype(aParam[08]) <> "D"
	aParam[08] := dDataBase
endif


aadd(aPerg,{1,"Filial Inicial"       ,aParam[01],"",".T.","",".T.",30,.F.}) //"Filial Inicial"
aadd(aPerg,{1,"Filial final"         ,aParam[02],"",".T.","",".T.",30,.F.}) //"Filial final"
aadd(aPerg,{1,"Serie da Nota Fiscal" ,aParam[03],"",".T.","",".T.",30,.F.}) //"Serie da Nota Fiscal"
aadd(aPerg,{1,"Nota fiscal inicial"  ,aParam[04],"",".T.","",".T.",30,.T.}) //"Nota fiscal inicial"
aadd(aPerg,{1,"Nota fiscal final"    ,aParam[05],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"
aadd(aPerg,{6,"Diret๓rio de destino" ,aParam[06],"",".T.","!Empty(mv_par06)",80,.T.," |*.","c:\",GETF_RETDIRECTORY+GETF_LOCALHARD}) //"Diret๓rio de destino"
aadd(aPerg,{1,"Data Inicial"         ,aParam[07],"",".T.","",".T.",50,.T.}) //"Data Inicial"
aadd(aPerg,{1,"Data Final"           ,aParam[08],"",".T.","",".T.",50,.T.}) //"Data Final"
aadd(aPerg,{1,"CNPJ Inicial"         ,aParam[09],"",".T.","",".T.",50,.F.}) //"CNPJ Inicial"
aadd(aPerg,{1,"CNPJ final"           ,aParam[10],"",".T.","",".T.",50,.F.}) //"CNPJ final"
aadd(aPerg,{1,"Dt.Rec.XML Inicial"   ,aParam[11],"",".T.","",".T.",50,.T.}) //"Dt.Rec.XML Inicial"
aadd(aPerg,{1,"Dt.Rec.XML Final"     ,aParam[12],"",".T.","",".T.",50,.T.}) //"Dt.Rec.XML Final"

if AllTrim( ParamLoad(_cLoad+cParXMLExp,aPerg, 9,"NADA") ) == "NADA" .and.;
   AllTrim( ParamLoad(_cLoad+cParXMLExp,aPerg,10,"NADA") ) == "NADA"
	ParamSave(_cLoad+cParXMLExp,aPerg,"1")
endif

If cLidVer != cVersao

	Handle := FT_FUse( "\profile\"+__cUserID+"_"+cParXMLExp+".PRB" )

	if nHandle != -1
		FT_FGoTop()
		nLinha := 0
		While !FT_FEOF()
		   cBuf := FT_FReadLn() // Retorna a linha corrente
		   nLinha++
		   if nLinha == 8 .or. nLinha == 9
		      If Substr(cBuf,1,1) <> "D"
		         cBuf := "D"+Substr(cBuf,2,len(cBuf))
		      EndIf
		   endif
		   cProfile := cProfile + cBuf + ( Chr( 13 ) + Chr( 10 ) )
		   FT_FSKIP()
		End
		FT_FUSE()

		MemoWrite("\profile\"+__cUserID+"_"+cParXMLExp+".PRB",cProfile)
	EndIf

EndIf

If ParamBox(aPerg,"Importa XML - Exportar",@aParam,,,,,,,cParXMLExp,.T.,.T.)

	cWhere := "%("
	cWhere += "ZBZ.ZBZ_FILIAL >='"+aParam[01]+"' AND ZBZ.ZBZ_FILIAL <='"+aParam[02]+"'"
	cWhere += "AND ZBZ.ZBZ_NOTA >='"+aParam[04]+"' AND ZBZ.ZBZ_NOTA <='"+aParam[05]+"'"
	If !Empty(aParam[03])
		cWhere += "	AND ZBZ.ZBZ_SERIE ='"+aParam[03]+"'"
	EndIf
	cWhere += "	AND ZBZ.ZBZ_DTNFE >='"+DTos(aParam[07])+"' AND ZBZ.ZBZ_DTNFE <='"+DTos(aParam[08])+"'"
	If .not. Empty( aParam[12] )
		cWhere += "	AND ZBZ.ZBZ_DTRECB >='"+DTos(aParam[11])+"' AND ZBZ.ZBZ_DTRECB <='"+DTos(aParam[12])+"'"
	EndIf
	cWhere += "	AND ZBZ.ZBZ_CNPJ >='"+aParam[09]+"' AND ZBZ.ZBZ_CNPJ <='"+aParam[10]+"'"
	cWhere += " )%" 
                      
	BeginSql Alias cAliasZBZ
	
	SELECT	ZBZ.R_E_C_N_O_ 
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
    		AND %Exp:cWhere%
	EndSql                                 
                                               
	DbSelectArea(cAliasZBZ)
	While !(cAliasZBZ)->(Eof())    
		DbSelectArea("ZBZ")
		DbGoTo((cAliasZBZ)->R_E_C_N_O_)
		cNomeXML   := AllTrim(aParam[06])+alltrim(ZBZ->ZBZ_CHAVE) + "-nfe"+cExt
		cXMLExp    := ZBZ->ZBZ_XML
		MemoWrite(cNomeXML,cXMLExp)
		cNfes+= cNomeXML + CRLF
		(cAliasZBZ)->(DbSkip())    		
    EndDo

	If !Empty(cNfes)	
	   	If U_MYAviso("Importa XML", "Visualiza detalhes",{"Sim","Nใo"}) == 1	//"Solicita็ใo processada com sucesso."
			U_MYAviso("Detalhes","XML's Exportados para"+" "+Upper(AllTrim(aParam[06]))+CRLF+CRLF+cNFes,{"Ok"},3)
		EndIf
	EndIf

EndIF 



Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02P  บ Autor ณ Roberto Souza      บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02P
Local lOk := .T.     
Local aArea:= GetArea()
Local cMsg := "Gerando a Pr้-Nota ..."

If ZBZ->(FieldPos("ZBZ_STATUS"))>0 
	If ZBZ->ZBZ_STATUS <>"1"
		lOk:= .F.   
   		MsgStop("Esta rotina nใo pode ser executada em um registro com erros na importa็ใo.")
	EndIf	
EndIf

If ZBZ->(FieldPos("ZBZ_PROTC"))>0  .And. AllTrim(ZBZ->ZBZ_PROTC) <> ""
	lOk:= .F.   
	MsgStop("Este xml foi cancelado pelo emissor.Nใo pode ser gerada a pr้-nota.")
EndIf

If Empty(ZBZ->ZBZ_CODFOR) .Or. Empty(ZBZ->ZBZ_LOJFOR)
	lOk:= .F.   
	MsgStop("Este XML nใo possui fornecedor associado. Clique em A็๕es Relacionadas / Fun็๕es XML / Alterar e Associe o Fornecedor de Acordo com o CNPJ. Caso nใo Tenha Fornecedor Cadastrado com o CNPJ, fa็a-o no Cadastro de Fornecedor.")
EndIf

If lOk
	cXMLExp    := ZBZ->ZBZ_XML

	If ZBZ->ZBZ_MODELO == "55"
		Processa( {|| IMPXMLFOR() }, "Aguarde...", cMsg,.F.)
   	ELseIf ZBZ->ZBZ_MODELO == "57"
		Processa( {|| IMPXMLFOR() }, "Aguarde...", cMsg,.F.)
    EndIf

EndIf
                       
RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPXMLFOR บ Autor ณ Roberto Souza      บ Data ณ  11/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function IMPXMLFOR()
Local aVetor	:= {}
Local aPedaco	:= {}
Local cError    := ""
Local cWarning  := ""
Local lRetorno  := .F.
Local aLinha    := {}
Local nX        := 0
Local nY        := 0
Local cDoc      := ""
Local lOk       := .T.
Local aProdOk   := {}
Local aProdNo   := {}
Local aProdVl   := {}
Local aProdZr   := {}
Local oDlg
Local aArea       := GetArea()
Local nTamProd    := TAMSX3("B1_COD")[1]
Local lPergunta   := .F.
Local cTesPcNf    := GetNewPar("MV_TESPCNF","") // Tes que nao necessita de pedido de compra amarrado
Local cTesB1PcNf  := ""
Local lPCNFE      := GetNewPar("MV_PCNFE",.F.)
Local lXMLPE2UM   := ExistBlock( "XMLPE2UM" )
Local lXMLPEITE   := ExistBlock( "XMLPEITE" )
Local nQuant      := 0
Local nVunit      := 0
Local nTotal      := 0
Local cUm         := "  "
Local nErrItens   := 0
Local nD1Item     := 0
Local oIcm, _cCc := ""
Local cKeyFe	  := SetKEY( VK_F3 ,  Nil )
Private oFont01   := TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
Private oXml
Private oDet, oOri
Private lDetCte     := ( GetNewPar("XM_CTE_DET","N") == "S" )
Private lTagOri     := ( GetNewPar("XM_CTE_DET","N") == "S" )
Private cTagFci     := ""
Private cCodFci     := ""
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.
Private aCabec      := {}
Private aItens    := {}
Private lNossoCod := .F.
Private cProduto  := "" //nTamProd
Private cCnpjEmi  := ""
Private cCodEmit  := ""
Private cLojaEmit := ""
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6"))
Private nFormCTE  := Val(GetNewPar("XM_FORMCTE","6"))
Private cEspecNfe := GetNewPar("XM_ESP_NFE","SPED")
Private cEspecCte := GetNewPar("XM_ESP_CTE","CTE")
Private cModelo   := ZBZ->ZBZ_MODELO
Private cTipoNf   := "N"
Private aItXml    := {}
Private cAmarra   := GetNewPar("XM_DE_PARA","0")
Private aPerg     := {}
Private aCombo    := {}
Private nAliqCTE  := 0, nBaseCTE := 0, nPedagio := 0, cModFrete := " "
Private cPCSol    := GetNewPar("XM_CSOL","A")
Private lNfOri    := ( GetNewPar("XM_NFORI","N") == "S" )
Private _lCCusto  := ( GetNewPar("XM_CCNFOR","N") == "S" ), _cCCusto
Private cCnpRem   := ""
Private aCnpRem   := {}
Private cTagAux   := ""
Private nValAux   := 0
Private lSerEmp   := .NOT. Empty( AllTrim(GetNewPar("XM_SEREMP","")) )
Private nAmarris  := 0
Private cPedidis  := ""
Private cTagTot   := ""
Private nTotXml   := 0
Private lTemFreXml:= .F., lTemDesXml := .F., lTemSegXml := .F.

If cModelo == "55" 
	lDetCte  := .F.
	lTagOri  := .F.
 	cPref    := "NF-e"
	cTAG     := "NFE"
	nFormXML := nFormNfe
	cEspecXML:= cEspecNfe
	lPergunta:= .F.
ElseIf cModelo == "57"
 	cPref    := "CT-e"
	cTAG     := "CTE"
	nFormXML := nFormCte
	cEspecXML:= cEspecCte
	lPergunta:= .F.
EndIf

cPerg := "IMPXML"
ValidPerg1(cPerg)


aParam   := {" "}
cParXMLExp := cNumEmp+"IMPXML"
cExt     := ".xml"
cNfes    := ""

aAdd( aCombo, "1=Padrใo(SA5/SA7)" )
aAdd( aCombo, "2=Customizada(ZB5)")
aAdd( aCombo, "3=Sem Amarra็ใo"   )
if ZBZ->ZBZ_TPDOC $ " N"
	aAdd( aCombo, "4=Por Pedido"  )
Else
	cAmarra := iif( cAmarra=="4", "0", cAmarra )
endif

aadd(aPerg,{2,"Amarra็ใo Produto","",aCombo,120,".T.",.T.,".T."})

aParam[01] := ParamLoad(cParXMLExp,aPerg,1,aParam[01])

If cAmarra == "0" //.And. !cModelo $ "57"
	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
	DbSelectArea("SF1")
	DbSetOrder(1)

	lSeekNF := DbSeek(cChaveF1)

	If lSeekNf
		U_MyAviso("Aten็ใo","Esta NFE jแ foi importada para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
		lRetorno := .F.
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	EndIf

	If !ParamBox(aPerg,"Importa XML - Amarra็ใo",@aParam,,,,,,,cParXMLExp,.T.,.T.)
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	Else 
   		cAmarra  := aParam[01]
	EndIf
EndIf

If lPergunta
	lContImp := Pergunte(cPerg,.T.)
	If !lContImp
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	EndIf
ELse
	lContImp:= .T.
EndIf

cTipoCPro := MV_PAR02
cTipoCPro := cAmarra
oXml := XmlParser(ZBZ->ZBZ_XML, "_", @cError, @cWarning )

If oXml == NIL .Or. !Empty(cError) .Or. !Empty(cWarning)
	MsgSTOP("XML Invalido ou Nใo Encontrado, a Importa็ใo Nใo foi Efetuada.")
	SetKEY( VK_F3 ,  cKeyFe )
	Return
EndIf

cTagTpEmiss:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPEMIS:TEXT"
cTagTpAmb  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPAMB:TEXT"
cTagCHId   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_ID:TEXT"
cTagSign   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_SIGNATURE"
cTagProt   := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_NPROT:TEXT"
cTagKey    := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_CH"+cTAG+":TEXT"
cTagDocEmit:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EMIT:_CNPJ:TEXT"

cTagDocXMl := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_N"+Left(cTAG,2)+":TEXT"
cTagSerXml := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_SERIE:TEXT"

If cModelo == "55"
		cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DEMI:TEXT"
		if type(cTagDtEmit) == "U"
			cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DHEMI:TEXT"
		endif
		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_CNPJ:TEXT"
		cTagTot    := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TOTAL:_ICMSTOT:_VNF:TEXT"
		If Type(cTagTot)<> "U"
 			nTotXml   := Val(&(cTagTot))
 		Else
 			nTotXml   := 0
 		EndIf
 		cTagTipFre:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TRANSP:_MODFRETE:TEXT"
		If Type(cTagTipFre)<> "U"
	   		cModFrete := &(cTagTipFre)
	   	EndIf
ElSeIf cModelo == "57"
		cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DHEMI:TEXT"
		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_CNPJ:TEXT"
		cTagAliq   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS00:_PICMS:TEXT" 
		//Incluindo a TAG ICMS20 pelo Analista Alexandro de Oliveira - 16/12/2014
		cTagAliq1  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS20:_PICMS:TEXT"
		If Type(cTagAliq)<> "U"  
	   		nAliqCTE   := Val(&(cTagAliq))
	   	ElseIf Type(cTagAliq1)<>"U"
	   	    nAliqCTE  := Val(&(cTagAliq1))
	   	EndIf    
		cTagBase   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS00:_VBC:TEXT"
		//Incluindo a TAG ICMS20 pelo Analista Alexandro de Oliveira - 16/12/2014
		cTagBase1  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS20:_VBC:TEXT"
		If Type(cTagBase)<> "U"
	   		nBaseCTE   := Val(&(cTagBase))
	   	ElseIf Type(cTagBase1)<> "U"
	   		nBaseCTE   := Val(&(cTagBase1))
	   	EndIf

	   	nPedagio := 0
	   	If Type( "oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP" ) != "U"
			oDet := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP
			oDet := iif( ValType(oDet) == "O", {oDet}, oDet )
			For i := 1 to Len( oDet )
				If AllTRim( oDet[i]:_XNOME:TEXT ) == "PEDAGIO"
	   				nPedagio := Val(oDet[i]:_VCOMP:TEXT)
	   			EndIf
	   		Next i
	   	EndIf
		cTagTot    := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_VPREST:_VTPREST:TEXT"
		If Type(cTagTot)<> "U"
 			nTotXml   := Val(&(cTagTot))
 		Else
 			nTotXml   := 0
 		EndIf
Else
		cTagDtEmit := ""
		cTagDocDest:= ""
EndIf

cCodEmit  := ZBZ->ZBZ_CODFOR
cLojaEmit := ZBZ->ZBZ_LOJFOR
cDocXMl   := Iif(nFormXML > 0,StrZero(Val(&(cTagDocXMl)),nFormXML),&(cTagDocXMl))
cSerXml   := &(cTagSerXml)

//Alterado para atender ao empresa ITAMBษ - 16/10/2014
//Analista Alexandro de Oliveira
if ( GetNewPar("XM_SERXML","N") == "S" )
	If alltrim( cSerXml ) == '0' .or. alltrim( cSerXml ) == '00' .or. alltrim( cSerXml ) == '000'
		cSerXml := '   '
	EndIf
elseIf ( GetNewPar("XM_SERXML","N") == "Z" )
	If Empty(cSerXml)
  	    cSerXml := '0'	
    Endif
endif
if lSerEmp
	cSerXml := ZBZ->ZBZ_SERIE
endif

cChaveXml := &(cTagKey)
cDtEmit   := &(cTagDtEmit)
dDataEntr := StoD(substr(cDtEmit,1,4)+Substr(cDtEmit,6,2)+Substr(cDtEmit,9,2))

aadd(aCabec,{"F1_TIPO"   ,Iif(Empty(ZBZ->ZBZ_TPDOC),"N",AllTrim(ZBZ->ZBZ_TPDOC))})
aadd(aCabec,{"F1_FORMUL" ,"N"})
aadd(aCabec,{"F1_DOC"    ,cDocXMl})
aadd(aCabec,{"F1_SERIE"  ,cSerXml})
aadd(aCabec,{"F1_EMISSAO",dDataEntr})
aadd(aCabec,{"F1_FORNECE",cCodEmit})
aadd(aCabec,{"F1_LOJA"   ,cLojaEmit})
aadd(aCabec,{"F1_ESPECIE",cEspecXML})
aadd(aCabec,{"F1_CHVNFE" ,cChaveXml})
aadd(aCabec,{"F1_VALPEDG",nPedagio })
if cModFrete <> " "
	if cModFrete == "0"
		cModFrete := "C"
	elseif cModFrete == "1"
		cModFrete := "F"
	elseif cModFrete == "2"
		cModFrete := "T"
	else
		cModFrete := "S"
	endif
	//aadd(aCabec,{"F1_TPFRETE",cModFrete })
endif

cTagAux   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TOTAL:_ICMSTOT:_VFRETE:TEXT"
if Type(cTagAux) <> "U" 
	nValAux := Val( &(cTagAux) )
	if nValAux > 0
		aadd(aCabec,{"F1_FRETE",nValAux })
		lTemFreXml := .T.
	endif
endif
cTagAux   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TOTAL:_ICMSTOT:_VOUTRO:TEXT"
if Type(cTagAux) <> "U" 
	nValAux := Val( &(cTagAux) )
	if nValAux > 0
		aadd(aCabec,{"F1_DESPESA",nValAux })
		lTemDesXml := .T.
	endif
endif
cTagAux   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TOTAL:_ICMSTOT:_VSEG:TEXT"
if Type(cTagAux) <> "U" 
	nValAux := Val( &(cTagAux) )
	if nValAux > 0
		aadd(aCabec,{"F1_SEGURO",nValAux })
		lTemSegXml := .T.
	endif
endif
cTagAux   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TRANSP:_VOL:_QVOL:TEXT"    //AQUIIIII OS VOLUMES
if Type(cTagAux) <> "U" 
	nValAux := Val( &(cTagAux) )
	if nValAux > 0
		aadd(aCabec,{"F1_VOLUME1",nValAux })
	endif
else
	cTagAux   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TRANSP:_VOL[1]:_QVOL:TEXT"
	if Type(cTagAux) <> "U" 
		nValAux := Val( &(cTagAux) )
		if nValAux > 0
			aadd(aCabec,{"F1_VOLUME1",nValAux })
		endif
	endif
endif
cTagAux   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TRANSP:_VOL:_ESP:TEXT"    //AQUIIIII OS VOLUMES
if Type(cTagAux) <> "U" 
	cValAux := &(cTagAux)
	if .Not. Empty(cValAux)
		aadd(aCabec,{"F1_ESPECI1",cValAux })
	endif
else
	cTagAux   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TRANSP:_VOL[1]:_ESP:TEXT"
	if Type(cTagAux) <> "U" 
		cValAux := &(cTagAux)
		if .Not. Empty(cValAux)
			aadd(aCabec,{"F1_ESPECI1",cValAux })
		endif
	endif
endif

lCadastra := .F.

Do while ( nErrItens < 2 .and. cTipoCPro <> '4' )
 nErrItens++
 lRetorno := .T.
 aLinha   := {}
 aProdOk  := {}
 aProdNo  := {}
 aProdZr  := {}
 aProdVl  := {}
 aItXml   := {}
 aItens   := {}

 If cModelo == "55"
	oDet := oXml:_NFEPROC:_NFE:_INFNFE:_DET
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)

	If Type("oXml:_NFEPROC:_NFE:_INFNFE:_DET") == "A"
		aItem := oXml:_NFEPROC:_NFE:_INFNFE:_DET
	Else
		aItem := {oXml:_NFEPROC:_NFE:_INFNFE:_DET}
	EndIf

	nD1Item := 1
	For i := 1 To len(oDet)
		If cTipoCPro == "2" // Ararracao Customizada ZB5 Produto tem que estar Amarrados Tanto Cliente como Formecedor
			cProduto := ""
			If aCabec[1][2] $ "D|B"
				DbSelectArea("ZB5")
				DbSetOrder(2)
				// Filial + CNPJ CLIENTE + Codigo do Produto do Fornecedor
				If DbSeek(xFilial("ZB5")+PADR(ZBZ->ZBZ_CNPJ,14)+oDet[i]:_Prod:_CPROD:TEXT)
					cProduto := ZB5->ZB5_PRODFI
					lRetorno := .T.
					aadd(aProdOk,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
				Else
					aadd(aProdNo,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
				EndIf
			Else
				DbSelectArea("ZB5")
				DbSetOrder(1)
				// Filial + CNPJ FORNECEDOR + Codigo do Produto do Fornecedor
				If DbSeek(xFilial("ZB5")+PADR(ZBZ->ZBZ_CNPJ,14)+oDet[i]:_Prod:_CPROD:TEXT)
					cProduto := ZB5->ZB5_PRODFI
					lRetorno := .T.
					aadd(aProdOk,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
				Else
					aadd(aProdNo,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
				EndIf
			EndIF

		//##################################################################
		ElseIf cTipoCPro == "1" // Amarracao Padrao SA5/SA7

			If aCabec[1][2] $ "D|B" // dDevolu็ใo / Beneficiamento ( utiliza Cliente )

				cProduto  := ""
				if empty( cCodEmit )
					cCodEmit  := Posicione("SA1",3,xFilial("SA1")+ZBZ->ZBZ_CNPJ,"A1_COD")
					cLojaEmit := Posicione("SA1",3,xFilial("SA1")+ZBZ->ZBZ_CNPJ,"A1_LOJA")
				endif

				cAliasSA7 := GetNextAlias()
				nVz := len(aItem)

				cWhere := "%(SA7.A7_CODCLI IN ("
				cWhere += "'"+TrocaAspas( AllTrim(oDet[i]:_Prod:_CPROD:TEXT) )+"'"
				cWhere += ") )%"

				BeginSql Alias cAliasSA7

				SELECT	A7_FILIAL, A7_CLIENTE, A7_LOJA, A7_CODCLI, A7_PRODUTO, R_E_C_N_O_ 
						FROM %Table:SA7% SA7
						WHERE SA7.%notdel%
			    		AND A7_CLIENTE = %Exp:cCodEmit%
			    		AND A7_LOJA = %Exp:cLojaEmit%
			    		AND %Exp:cWhere%
			    		ORDER BY A7_FILIAL, A7_CLIENTE, A7_LOJA, A7_CODCLI
				EndSql

				DbSelectArea(cAliasSA7)            
				Dbgotop()
		        lFound := .F.
		        cKeySa7:= xFilial("SA7")+cCodEmit+cLojaEmit+TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT )
		        While !(cAliasSA7)->(EOF())
					cKeyTMP := (cAliasSA7)->A7_FILIAL+(cAliasSA7)->A7_CLIENTE+(cAliasSA7)->A7_LOJA+(cAliasSA7)->A7_CODCLI
					If 	AllTrim(cKeySa7) == AllTrim(cKeyTMP)
		        		lFound := .T.
		        		Exit
		        	Endif
		        	(cAliasSA7)->(DbSkip())
		        Enddo

				If lFound
					cProduto := (cAliasSA7)->A7_PRODUTO
					lRetorno := .T.
					aadd(aProdOk,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )
				Else
					aadd(aProdNo,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )
				EndIf

				DbCloseArea()

			Else
				cProduto  := ""
				if empty( cCodEmit )
					cCodEmit  := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_COD")
					cLojaEmit := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_LOJA")
				endif

				cAliasSA5 := GetNextAlias()
				nVz := len(aItem)

				cWhere := "%(SA5.A5_CODPRF IN ("				               
				cWhere += "'"+TrocaAspas( AllTrim(oDet[i]:_Prod:_CPROD:TEXT) )+"'"
				cWhere += ") )%"				               	

				BeginSql Alias cAliasSA5

				SELECT	A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF, A5_PRODUTO, R_E_C_N_O_ 
						FROM %Table:SA5% SA5
						WHERE SA5.%notdel%
			    		AND A5_FORNECE = %Exp:cCodEmit%
			    		AND A5_LOJA = %Exp:cLojaEmit%
			    		AND %Exp:cWhere%
			    		ORDER BY A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF
				EndSql

				DbSelectArea(cAliasSA5)            
				Dbgotop()
		        lFound := .F.
		        cKeySa5:= xFilial("SA5")+cCodEmit+cLojaEmit+TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT )
		        While !(cAliasSA5)->(EOF())
					cKeyTMP := (cAliasSA5)->A5_FILIAL+(cAliasSA5)->A5_FORNECE+(cAliasSA5)->A5_LOJA+(cAliasSA5)->A5_CODPRF
					If 	AllTrim(cKeySa5) == AllTrim(cKeyTMP)
		        		lFound := .T.
		        		Exit
		        	Endif
		        	(cAliasSA5)->(DbSkip())
		        Enddo


				If lFound
					cProduto := (cAliasSA5)->A5_PRODUTO
					lRetorno := .T.
					aadd(aProdOk,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )
				Else         
					aadd(aProdNo,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )				
				EndIf

				DbCloseArea()
			EndIF          		

		//##################################################################
		ElseIf cTipoCPro = "3" // Mesmo Codigo Nao requer amarracao SB1
			DbSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+oDet[i]:_Prod:_CPROD:TEXT)
				cProduto := Substr(oDet[i]:_Prod:_CPROD:TEXT,1,15)
				lRetorno := .T.
				aadd(aProdOk,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
			Else         
				aadd(aProdNo,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )				
			EndIF
		EndIf

		cUm    := "  "
		cTagFci:= "oDet[i]:_Prod:_UCOM:TEXT"
		if Type(cTagFci) <> "U"
			cUm := oDet[i]:_Prod:_UCOM:TEXT
		endif
		nQuant := VAL(oDet[i]:_Prod:_QCOM:TEXT)
		nVunit := VAL(oDet[i]:_Prod:_VUNCOM:TEXT)
		nTotal := VAL(oDet[i]:_Prod:_VPROD:TEXT)

        cCodFci:= ""
        cTagFci:= "oDet[i]:_PROD:_NFCI:TEXT"  //CONFIRMAR ESTA TAG
        If Type(cTagFci) <> "U"
			cCodFci:= &cTagFci.
		EndIf

		If lXMLPE2UM   //PE para conversใo da 2 unidade de medida
			oIcm := oDet[i]:_Imposto:_ICMS
			oIcm := IIf(ValType(oIcm)=="O",{oIcm},oIcm)
	   		aRet :=	ExecBlock( "XMLPE2UM", .F., .F., { cProduto,cUm,nQuant,nVunit,oIcm } )
	   		if aRet == NIL
				cUm    := "  "
				nQuant := 0
				nVunit := 0
			else
				cUm    := iif( len(aRet) >= 2, aRet[2], "  " )
				nQuant := iif( len(aRet) >= 3, aRet[3], 0 )
				nVunit := iif( len(aRet) >= 4, aRet[4], 0 )
	   		endif
		 	if Round((nQuant * nVunit),2) != Round(nTotal, 2)
		 		if ABS( Round((nQuant * nVunit),2) - Round(nTotal, 2) ) > 0.01
					aadd(aProdVl,{oDet[i]:_Prod:_CPROD:TEXT, cUm, nQuant, nVunit, nTotal, (nQuant * nVunit) } )
				else
					if nVunit <> VAL(oDet[i]:_Prod:_VUNCOM:TEXT) //por causa do problema de arredondar e truncar com valor unitแrio com 3 casas decimais (Itamb้)
						aadd(aProdVl,{oDet[i]:_Prod:_CPROD:TEXT, cUm, nQuant, nVunit, nTotal, (nQuant * nVunit) } )
					endif
				endif
		 	endif
	 	EndIf

		aadd(aLinha,{"D1_ITEM"  ,StrZero(nD1Item,4)              ,Nil})
		aadd(aLinha,{"D1_COD"   ,cProduto               		 ,Nil})
		aadd(aLinha,{"D1_QUANT" ,nQuant							 ,Nil})
		aadd(aLinha,{"D1_VUNIT" ,nVunit							 ,Nil})
		aadd(aLinha,{"D1_TOTAL" ,nTotal							 ,Nil})
		If .Not. Empty(cCodFci)
			aadd(aLinha,{"D1_FCICOD",cCodFci					 ,Nil})
		EndIf
		if cPCSol == "S"  //Centro de Custo do Pedido, entใo manda vazio para pegar do pedido ao relacionar o pedido F5 ou F6
			aadd(aLinha,{"D1_CC"    ,Space(9)  					 ,Nil})
		else
			if .not. empty( cProduto ) .And. SB1->( DbSeek(xFilial("SB1")+cProduto) )
				aadd(aLinha,{"D1_CC",SB1->B1_CC					 ,Nil})
			endif
		endif
//		aadd(aLinha,{"D1_CC"    ,Space(9)  						 ,Nil})
//		aadd(aLinha,{"D1_PEDIDO",Space(6)               		 ,Nil})
//		aadd(aLinha,{"D1_ITEMPC",Space(4)              			 ,Nil})

		If lXMLPEITE   //PE para incluir campos no aLinha SD1 -> para o aItens
   			aRet :=	ExecBlock( "XMLPEITE", .F., .F., { cProduto,oDet,i } )
			If ValType(aRet) == "A"
				AEval(aRet,{|x| AAdd(aLinha,x)})
			EndIf
 		endif

		if .not. empty( cProduto )
	 		if SB1->( DbSeek(xFilial("SB1")+cProduto) )
 				If SB1->( FieldGet(FieldPos("B1_MSBLQL")) ) == "1"
	 				aadd(aProdNo,{cProduto,"Produto Bloqueado SB1->"+SB1->B1_DESC} )
 				EndIf
	 		ElseIf cTipoCPro != "3"
 				aadd(aProdNo,{cProduto,"Nใo Cadastrado SB1->"+oDet[i]:_Prod:_XPROD:TEXT} )
 			endif
 		EndIf

 		if nVunit <= 0 //Nใo mostrar
			//aadd(aProdZr, { StrZero(i,4), oDet[i]:_Prod:_CPROD:TEXT, cProduto, nVunit, oDet[i]:_Prod:_XPROD:TEXT } )
 		endif

 		if nVunit > 0 //permitir valor unitแrio maior zero
	 		aadd(aItens,aLinha)
	 		nD1Item++
		 	aadd(aItXml,{StrZero(i,4),oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT})
	 	endif
		aLinha := {}

	Next i


	//Itens nใo encontrados
	if .not. ItNaoEnc( "PREN", aProdOk, aProdNo, aProdVl, @nErrItens, aProdZr )
	    lRetorno := .F.
		Loop
	endif


	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
	DbSelectArea("SF1")
	DbSetOrder(1)

	lSeekNF := DbSeek(cChaveF1)

	If !lSeekNf
		If ZBZ->ZBZ_PRENF $ "N|S"
			lOkGo := MsgYesNo("Pr้-nota gerada previamente mas foi excluida.Deseja prosseguir gerando novamente?","Aviso")
			If !lOkGo
				lRetorno := .F.
			EndIf
		EndIf
	Else
		U_MyAviso("Aten็ใo","Esta NFE jแ foi importada para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
		lRetorno := .F.
	EndIf

 ElseIf cModelo == "57"
	lRetorno := .T.
	cCnpRem := ""
	if lNfOri
		if Type(cTagDocDest) != "U"
			cCnpRem := &cTagDocDest
		endif
	endif

	oDet := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST
	cProdCte := Padr(GetNewPar("XM_PRODCTE","FRETE"),nTamProd)
    cProdCte :=Iif(Empty(cProdCte),Padr("FRETE",nTamProd),cProdCte)
	If cTipoCPro == "2" // Ararracao Customizada ZB5 Produto tem que estar Amarrados Tanto Cliente como Formecedor
		cProduto := ""

		DbSelectArea("ZB5")
		DbSetOrder(1)
		// Filial + CNPJ FORNECEDOR + Codigo do Produto do Fornecedor
		If DbSeek(xFilial("ZB5")+PADR(ZBZ->ZBZ_CNPJ,14)+cProdCte)
			cProduto := ZB5->ZB5_PRODFI
			lRetorno := .T.
			aadd(aProdOk,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		Else
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		EndIf

	//##################################################################
	ElseIf cTipoCPro == "1" // Amarracao Padrao SA5/SA7

		cProduto  := ""
		if empty( cCodEmit )
			cCodEmit  := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_COD")
			cLojaEmit := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_LOJA")
		endif

		cAliasSA5 := GetNextAlias()

		cWhere := "%(SA5.A5_CODPRF IN ("
		cWhere += "'"+AllTrim(cProdCte)+"'"
		cWhere += ") )%"

		BeginSql Alias cAliasSA5

		SELECT	A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF, A5_PRODUTO, R_E_C_N_O_ 
				FROM %Table:SA5% SA5
				WHERE SA5.%notdel%
	    		AND A5_FORNECE = %Exp:cCodEmit%
	    		AND A5_LOJA = %Exp:cLojaEmit%
	    		AND %Exp:cWhere%
	    		ORDER BY A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF
		EndSql

		DbSelectArea(cAliasSA5)
		Dbgotop()
        lFound := .F.
        cKeySa5:= xFilial("SA5")+cCodEmit+cLojaEmit+cProdCte
        While !(cAliasSA5)->(EOF())
			cKeyTMP := (cAliasSA5)->A5_FILIAL+(cAliasSA5)->A5_FORNECE+(cAliasSA5)->A5_LOJA+(cAliasSA5)->A5_CODPRF
			If 	AllTrim(cKeySa5) == AllTrim(cKeyTMP)
        		lFound := .T.
        		Exit
        	Endif
        	(cAliasSA5)->(DbSkip())
        Enddo


		If lFound
			cProduto := (cAliasSA5)->A5_PRODUTO

			lRetorno := .T.
			aadd(aProdOk,{cProduto,"PRESTACAO DE SERVICO - FRETE"} )
		Else
			cProduto := cProdCte
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		EndIf

		DbCloseArea()


	//##################################################################
	ElseIf cTipoCPro = "3" // Mesmo Codigo Nao requer amarracao SB1
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+cProdCte)
			cProduto := Substr(cProdCte,1,15)
			lRetorno := .T.
			aadd(aProdOk,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		Else
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		EndIF
	EndIf

	If lDetCte .And. Type("oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		nVunit := Round( ( VAL(oDet:_VTPREST:TEXT) / Len(oOri) ), 2 )
		nTotal := 0
		nBunit := Round( ( nBaseCTE / Len(oOri) ), 2 )
		nIctot := 0

		For i := 1 To Len(oOri)

            If i == Len(oOri)
            	nVunit := VAL(oDet:_VTPREST:TEXT) - nTotal
            	nBunit := nBaseCTE - nIctot
            EndIf
            nTotal += nVunit
            nIctot += nBunit
			aLinha = {}
			cNfOri := oOri[i]:_NDOC:TEXT
			if Val(cNfOri) > 0
				cNfOri := StrZero( Val(cNfOri), len(SD1->D1_NFORI) )
			endif
			cSerOri := AllTrim( oOri[i]:_SERIE:TEXT )
			cCnpRem := ""
			_cCCusto:= ""
			_cCc    := ""
			if lNfOri
				if Type(cTagDocDest) != "U"
					cCnpRem := &cTagDocDest
				endif
				if .not. empty(cCnpRem)
					ExistSf3( @cNfOri, @cSerOri,,,,, @_cCc )
				endif
			else
				ExistDoc( @cNfOri, @cSerOri,,,,, @_cCc )
			endif
			if _lCCusto
				_cCCusto := _cCc
			endif
			aadd( aCnpRem, cCnpRem )
			aadd(aLinha,{"D1_ITEM" ,StrZero(i,4,0)          ,Nil})
			aadd(aLinha,{"D1_COD"  ,cProduto                 ,Nil})
			aadd(aLinha,{"D1_QUANT",1                        ,Nil})
			aadd(aLinha,{"D1_NFORI",cNfOri				     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_VUNIT",nVunit					 ,Nil})
			aadd(aLinha,{"D1_TOTAL",nVunit					 ,Nil})

			if .NOT. Empty( _cCCusto )
				aadd(aLinha,{"D1_CC"    ,_cCCusto  					 ,Nil})
			elseif cPCSol == "S"  //Centro de Custo do Pedido, entใo manda vazio para pegar do pedido ao relacionar o pedido F5 ou F6
				aadd(aLinha,{"D1_CC"    ,Space(9)  					 ,Nil})
			else
				if .not. empty( cProduto ) .And. SB1->( DbSeek(xFilial("SB1")+cProduto) )
					aadd(aLinha,{"D1_CC",SB1->B1_CC					 ,Nil})
				endif
			endif
			If nAliqCte > 0
				aadd(aLinha,{"D1_PICM",nAliqCte             ,Nil})
			EndIf
			If nBunit > 0
				aadd(aLinha,{"D1_BASEICM",nBunit             ,Nil})
			EndIf
			If nAliqCte > 0 .And. nBunit > 0
				aadd(aLinha,{"D1_VALICM",(nBunit*(nAliqCte/100)),Nil})
			EndIf

			If lXMLPEITE   //PE para incluir campos no aLinha SD1 -> para o aItens
				aRet :=	ExecBlock( "XMLPEITE", .F., .F., { cProduto,oDet,i } )
				If ValType(aRet) == "A"
					AEval(aRet,{|x| AAdd(aLinha,x)})
				EndIf
			endif

			aadd(aItens,aLinha)

		Next i

	ElseIf lDetCte .And. Type("oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		nVunit := Round( ( VAL(oDet:_VTPREST:TEXT) / Len(oOri) ), 2 )
		nTotal := 0
		nBunit := Round( ( nBaseCTE / Len(oOri) ), 2 )
		nIctot := 0

		For i := 1 To Len(oOri)

            If i == Len(oOri)
            	nVunit := VAL(oDet:_VTPREST:TEXT) - nTotal
            	nBunit := nBaseCTE - nIctot
            EndIf
            nTotal += nVunit
            nIctot += nBunit
            cCnpRem := ""
			aLinha = {}
			_cCCusto:= ""
			_cCc    := ""
			if lNfOri
				aDocDaChave := Sf3DaChave( oOri[i]:_CHAVE:TEXT,,,,,@_cCc )  //Pegar Documentos no SF3
			else
				aDocDaChave := DocDaChave( oOri[i]:_CHAVE:TEXT,,,,,@_cCc )  //Pegar Documentos no SF2
			endif
			if _lCCusto
				_cCCusto := _cCc
			endif
			aadd( aCnpRem, cCnpRem )
			cNfOri := aDocDaChave[1]
			cSerOri := aDocDaChave[2]
			aadd(aLinha,{"D1_ITEM" ,StrZero(i,4,0)          ,Nil})
			aadd(aLinha,{"D1_COD"  ,cProduto                 ,Nil})
			aadd(aLinha,{"D1_QUANT",1                        ,Nil})
			aadd(aLinha,{"D1_NFORI",cNfOri				     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_VUNIT",nVunit					 ,Nil})
			aadd(aLinha,{"D1_TOTAL",nVunit					 ,Nil})
			if .NOT. Empty( _cCCusto )
				aadd(aLinha,{"D1_CC"    ,_cCCusto  					 ,Nil})
			elseif cPCSol == "S"  //Centro de Custo do Pedido, entใo manda vazio para pegar do pedido ao relacionar o pedido F5 ou F6
				aadd(aLinha,{"D1_CC"    ,Space(9)  					 ,Nil})
			else
				if .not. empty( cProduto ) .And. SB1->( DbSeek(xFilial("SB1")+cProduto) )
					aadd(aLinha,{"D1_CC",SB1->B1_CC					 ,Nil})
				endif
			endif
			If nAliqCte > 0
				aadd(aLinha,{"D1_PICM",nAliqCte             ,Nil})
			EndIf
			If nBunit > 0
				aadd(aLinha,{"D1_BASEICM",nBunit             ,Nil})
			EndIf
			If nAliqCte > 0 .And. nBunit > 0
				aadd(aLinha,{"D1_VALICM",(nBunit*(nAliqCte/100)),Nil})
			EndIf

			If lXMLPEITE   //PE para incluir campos no aLinha SD1 -> para o aItens
				aRet :=	ExecBlock( "XMLPEITE", .F., .F., { cProduto,oDet,i } )
				If ValType(aRet) == "A"
					AEval(aRet,{|x| AAdd(aLinha,x)})
				EndIf
			endif

			aadd(aItens,aLinha)

		Next i

	ElseIf lDetCte .And. Type("oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		nVunit := Round( ( VAL(oDet:_VTPREST:TEXT) / Len(oOri) ), 2 )
		nTotal := 0
		nBunit := Round( ( nBaseCTE / Len(oOri) ), 2 )
		nIctot := 0

		For i := 1 To Len(oOri)

            If i == Len(oOri)
            	nVunit := VAL(oDet:_VTPREST:TEXT) - nTotal
            	nBunit := nBaseCTE - nIctot
            EndIf
            nTotal += nVunit
            nIctot += nBunit
			aLinha = {}
			cNfOri := oOri[i]:_NDOC:TEXT
			if Val(cNfOri) > 0
				cNfOri := StrZero( Val(cNfOri), len(SD1->D1_NFORI) )
			endif
			cSerOri := AllTrim( oOri[i]:_SERIE:TEXT )
			cCnpRem := ""
			_cCCusto:= ""
			_cCc    := ""
			if lNfOri
				if Type(cTagDocDest) != "U"
					cCnpRem := &cTagDocDest
				endif
				if .not. empty(cCnpRem)
					ExistSf3( @cNfOri, @cSerOri,,,,, @_cCc )
				endif
			else
				ExistDoc( @cNfOri, @cSerOri,,,,, @_cCc )
			endif
			if _lCCusto
				_cCCusto := _cCc
			endif
			aadd( aCnpRem, cCnpRem )
			aadd(aLinha,{"D1_ITEM" ,StrZero(i,4,0)          ,Nil})
			aadd(aLinha,{"D1_COD"  ,cProduto                 ,Nil})
			aadd(aLinha,{"D1_QUANT",1                        ,Nil})
			aadd(aLinha,{"D1_NFORI",cNfOri				     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_VUNIT",nVunit					 ,Nil})
			aadd(aLinha,{"D1_TOTAL",nVunit					 ,Nil})
			if .NOT. Empty( _cCCusto )
				aadd(aLinha,{"D1_CC"    ,_cCCusto  					 ,Nil})
			elseif cPCSol == "S"  //Centro de Custo do Pedido, entใo manda vazio para pegar do pedido ao relacionar o pedido F5 ou F6
				aadd(aLinha,{"D1_CC"    ,Space(9)  					 ,Nil})
			else
				if .not. empty( cProduto ) .And. SB1->( DbSeek(xFilial("SB1")+cProduto) )
					aadd(aLinha,{"D1_CC",SB1->B1_CC					 ,Nil})
				endif
			endif
			If nAliqCte > 0
				aadd(aLinha,{"D1_PICM",nAliqCte             ,Nil})
			EndIf
			If nBunit > 0
				aadd(aLinha,{"D1_BASEICM",nBunit             ,Nil})
			EndIf
			If nAliqCte > 0 .And. nBunit > 0
				aadd(aLinha,{"D1_VALICM",(nBunit*(nAliqCte/100)),Nil})
			EndIf

			If lXMLPEITE   //PE para incluir campos no aLinha SD1 -> para o aItens
				aRet :=	ExecBlock( "XMLPEITE", .F., .F., { cProduto,oDet,i } )
				If ValType(aRet) == "A"
					AEval(aRet,{|x| AAdd(aLinha,x)})
				EndIf
			endif

			aadd(aItens,aLinha)

		Next i

	ElseIf lDetCte .And. Type("oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE  
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		nVunit := Round( ( VAL(oDet:_VTPREST:TEXT) / Len(oOri) ), 2 )
		nTotal := 0
		nBunit := Round( ( nBaseCTE / Len(oOri) ), 2 )
		nIctot := 0

		For i := 1 To Len(oOri)

            If i == Len(oOri)
            	nVunit := VAL(oDet:_VTPREST:TEXT) - nTotal
            	nBunit := nBaseCTE - nIctot
            EndIf
            nTotal += nVunit
            nIctot += nBunit
			aLinha = {}
			cCnpRem := ""
			_cCCusto:= ""
			_cCc    := ""
			if lNfOri
				aDocDaChave := Sf3DaChave( oOri[i]:_CHAVE:TEXT,,,,,@_cCc )  //Pegar Documentos no SF3
			else
				aDocDaChave := DocDaChave( oOri[i]:_CHAVE:TEXT,,,,,@_cCc )  //Pegar Documentos no SF2
			endif
			if _lCCusto
				_cCCusto := _cCc
			endif
			aadd( aCnpRem, cCnpRem )
			cNfOri := aDocDaChave[1]
			cSerOri := aDocDaChave[2]
			aadd(aLinha,{"D1_ITEM" ,StrZero(i,4,0)          ,Nil})
			aadd(aLinha,{"D1_COD"  ,cProduto                 ,Nil})
			aadd(aLinha,{"D1_QUANT",1                        ,Nil})
			aadd(aLinha,{"D1_NFORI",cNfOri				     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_VUNIT",nVunit					 ,Nil})
			aadd(aLinha,{"D1_TOTAL",nVunit					 ,Nil})
			if .NOT. Empty( _cCCusto )
				aadd(aLinha,{"D1_CC"    ,_cCCusto  					 ,Nil})
			elseif cPCSol == "S"  //Centro de Custo do Pedido, entใo manda vazio para pegar do pedido ao relacionar o pedido F5 ou F6
				aadd(aLinha,{"D1_CC"    ,Space(9)  					 ,Nil})
			else
				if .not. empty( cProduto ) .And. SB1->( DbSeek(xFilial("SB1")+cProduto) )
					aadd(aLinha,{"D1_CC",SB1->B1_CC					 ,Nil})
				endif
			endif
			If nAliqCte > 0
				aadd(aLinha,{"D1_PICM",nAliqCte             ,Nil})
			EndIf
			If nBunit > 0
				aadd(aLinha,{"D1_BASEICM",nBunit             ,Nil})
			EndIf
			If nAliqCte > 0 .And. nBunit > 0
				aadd(aLinha,{"D1_VALICM",(nBunit*(nAliqCte/100)),Nil})
			EndIf

			If lXMLPEITE   //PE para incluir campos no aLinha SD1 -> para o aItens
				aRet :=	ExecBlock( "XMLPEITE", .F., .F., { cProduto,oDet,i } )
				If ValType(aRet) == "A"
					AEval(aRet,{|x| AAdd(aLinha,x)})
				EndIf
			endif

			aadd(aItens,aLinha)

		Next i

	Else
		//lDetCte := .F.
		lTagOri := .F.
		aadd( aCnpRem, cCnpRem )
		aadd(aLinha,{"D1_ITEM" ,"0001"                  ,Nil})
		aadd(aLinha,{"D1_COD"  ,cProduto                ,Nil})
		aadd(aLinha,{"D1_QUANT",1                       ,Nil})
		aadd(aLinha,{"D1_VUNIT",VAL(oDet:_VTPREST:TEXT) ,Nil})
		aadd(aLinha,{"D1_TOTAL",VAL(oDet:_VTPREST:TEXT) ,Nil})
		if cPCSol == "S"  //Centro de Custo do Pedido, entใo manda vazio para pegar do pedido ao relacionar o pedido F5 ou F6
			aadd(aLinha,{"D1_CC"    ,Space(9)  					 ,Nil})
		else
			if .not. empty( cProduto ) .And. SB1->( DbSeek(xFilial("SB1")+cProduto) )
				aadd(aLinha,{"D1_CC",SB1->B1_CC					 ,Nil})
			endif
		endif
		If nAliqCte > 0
			aadd(aLinha,{"D1_PICM",nAliqCte             ,Nil})
		EndIf
		If nBaseCTE > 0
			aadd(aLinha,{"D1_BASEICM",nBaseCTE          ,Nil})
		EndIf
		If nAliqCte > 0 .And. nBaseCTE > 0
			aadd(aLinha,{"D1_VALICM",(nBaseCTE*(nAliqCte/100)),Nil})
		EndIf

		If lXMLPEITE   //PE para incluir campos no aLinha SD1 -> para o aItens
			aRet :=	ExecBlock( "XMLPEITE", .F., .F., { cProduto,oDet,1 } )
			If ValType(aRet) == "A"
				AEval(aRet,{|x| AAdd(aLinha,x)})
			EndIf
		endif

		aadd(aItens,aLinha)

	EndIf

	If .not. empty( cProduto )
		if SB1->( DbSeek(xFilial("SB1")+cProduto) )
			If SB1->( FieldGet(FieldPos("B1_MSBLQL")) ) == "1"
				aadd(aProdNo,{cProduto,"Produto Bloqueado SB1->"+SB1->B1_DESC} )
			EndIf
		ElseIf cTipoCPro != "3"
			aadd(aProdNo,{cProduto,"Nใo Cadastrado SB1->"+"PRESTACAO DE SERVICO - FRETE"} )
		EndIf
	EndIf

	if VAL(oDet:_VTPREST:TEXT) <= 0
		aadd(aProdZr, { "0001", cProdCte, cProduto, VAL(oDet:_VTPREST:TEXT), "PRESTACAO DE SERVICO - FRETE" } )
	endif

 	aadd(aItXml,{"0001",cProdCte,Posicione("SB1",1,xFilial("SB1")+cProdCte,"B1_DESC")})
	aLinha := {}

	if .not. ItNaoEnc( "PREN", aProdOk, aProdNo, aProdVl, @nErrItens, aProdZr )
	    lRetorno := .F.
		Loop
	endif

	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
	DbSelectArea("SF1")
	DbSetOrder(1)

	lSeekNF := DbSeek(cChaveF1)

	If !lSeekNf
		If ZBZ->ZBZ_PRENF $ "N|S"
			lOkGo := MsgYesNo("Pr้-nota gerada previamente mas foi excluida.Deseja prosseguir gerando novamente?","Aviso")
			If !lOkGo
				lRetorno := .F.
			EndIf
		EndIf
	Else
		U_MyAviso("Aten็ใo","Esta NFE jแ foi importada para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
		lRetorno := .F.
	EndIf

 EndIf

 Exit //s๓ para o nErrItens checar o erro, caso ele inclua pelo DePara a 2a vez estarแ certo e ele continuarแ com o aitens preenchido
EndDo

if cTipoCPro == '4'
	aItens   := {}
	nAmarris := 1
	cPedidis := ""
	lRetorno := U_HFXMLPED(cCodEmit,cLojaEmit,"N")
	nAmarris := 2
endif

If lRetorno
	aCols    := {}
	aRetHead := {}
	aRetCol  := {}
/*
	For Nx:= 1 to Len(aItens)
		Aadd(aCols,{aItXml[Nx][1],;
					aItXml[Nx][2],;
					aItXml[Nx][3],;
					aItens[Nx][1][2],;
					Iif ( !Empty(aItens[Nx][1][2]),Posicione("SB1",1,xFilial("SB1")+aItens[Nx][1][2],"B1_DESC"),Space(60)),;
					aItens[Nx][2][2],;
					aItens[Nx][3][2],;
					aItens[Nx][4][2],;
					aItens[Nx][5][2],;
					aItens[Nx][6][2],;
					aItens[Nx][7][2],;
					.F.})	
		Aadd(aCols,{aItXml[Nx][1],;
					aItXml[Nx][2],;
					aItXml[Nx][3],;
					aItens[Nx][1][2],;
					Iif ( !Empty(aItens[Nx][1][2]),Posicione("SB1",1,xFilial("SB1")+aItens[Nx][1][2],"B1_DESC"),Space(60)),;
					aItens[Nx][2][2],;
					aItens[Nx][3][2],;
					aItens[Nx][4][2],;
					.F.})
	Next
*/
	lSetPC := .F.

	cTesB1PcNf := ""
	If cModelo =='57'
		If !Empty(cTesPcNf) .And. (Posicione("SB1",1,xFilial("SB1")+aItens[1][2][2],"B1_TE") $ AllTrim(cTesPcNf))
			lSetPC := .T.
		EndIf
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Inicio da Inclusao                                           |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lRetorno :=.T.// U_VisNota(cModelo, ZBZ->ZBZ_CNPJ,oXml, aCols, @aCabec, @aItens )
                         

	If lRetorno  
/*	
		MSExecAuto({|x,y,z| U_Xmata140(x,y,z)},aCabec,aItens,3)
		
		If lSetPC
//		   	MSExecAuto({|x,y,z| mata103(x,y,z)},aCabec,aItens,3,,1)
		Else
// 			Em desuso - 12/03/2013
//			MSExecAuto({|x,y,z| mata140(x,y,z)},aCabec,aItens,3)
			If !lMsErroAuto
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ O ponto de entrada e disparado apos a inclusใo referente ao MT140SAI padrใo                     ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ExistBlock( "XM140SAI" )
					ExecBlock( "XM140SAI", .F., .F., { 3, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_TIPO, 1 } )
				EndIf
			EndIf
		
		EndIf
*/
		nOpcPut := 1
		lmata140 := .F.
		lmata103 := .F.
		
		If lSetPC
			If lPCNFE
				nOpcPut := U_MYAVISO("Aten็ใo","O Parametro MV_PCNFE estแ habilitado."+CRLF+"Nใo ้ permitido emitir pr้-nota sem pedido de compra."+CRLF+"Deseja incluir uma Pr้-Nota ou uma Nota Fiscal de Entrada?",{"Pr้-Nota","Nota Fiscal"},3)
				/*
				If nOpcPut == 1
					MsgInfo("Gera็ใo de Documento de Entrada Cancelado.")
					RestArea(aArea)
					Return(Nil)
        		ElseIf nOpcPut == 1
        	   		nOpcPut := 2	
				EndIf
				*/
			Else
				nOpcPut := U_MYAVISO("Aten็ใo","Deseja incluir uma Pr้-Nota ou uma Nota Fiscal de Entrada?",{"Pr้-Nota","Nota Fiscal"},3)
			EndIf
		EndIf

		xRet140 := .F.
		xRet103 := .F.
		If nOpcPut == 1
//			xRet140:= MSExecAuto({|x,y,z| U_Xmata140(x,y,z)},aCabec,aItens,3,,1)
			aAuxRot := aClone( aRotina )
			aRotina := get2Menu()    //Para nใo dar erro na rotina padrใo.

	   		xRet140:= U_XMATA140(aCabec,aItens,3,,1)

			aRotina := aClone( aAuxRot )

			lMata140 := .T.
		ElseIf nOpcPut == 2

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ O ponto de entrada e disparado apos a inclusใo referente ao MT140SAI padrใo                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			If ExistBlock( "XMLPE001" )
		   		aCabec :=	ExecBlock( "XMLPE001", .F., .F., { aCabec,oXml } )
				If Empty(aCabec)
					Conout("[XMLPE001] "+dtos(ddatabase)+"-"+Time())
					U_MYAviso("Erro","O cabe็alho da nota fiscal ้ invแlido.Verifique o ponto de entrada 'XMLPE001'.",{"OK"},3)
					SetKEY( VK_F3 ,  cKeyFe )
					Return(Nil)
				EndIf
			EndIf
			//Inserir a TES cTesPcNf para CTE quando Documento de Entrada Direto. Em 03/02/2015 conf. Thiago Almada
			For Nx:= 1 to Len(aItens)
				cTesB1PcNf  := Posicione("SB1",1,xFilial("SB1")+aItens[1][2][2],"B1_TE")  //Item 1, pois no CTE ้ sempre o mesmo produto, s๓ mudando a NF de Origem.
				aLinha := {"D1_TES",cTesB1PcNf,Nil}
				aadd(aItens[nX], aLinha)
			Next

			xRet103 := MSExecAuto({|x,y,z| mata103(x,y,z)},aCabec,aItens,3,.T.)
			lMata103 := .T.
		EndIf 


                        
		lEditStat := .F.

		If lMsErroAuto
			If xRet140 .Or. xRet103
				MOSTRAERRO()
				MsgSTOP("O documento de entrada nใo foi gerado.")
			EndIf
			lRetorno := .F.
		Else                              
		    lMsHelpAuto:=.F.
 
			If lMata140
				If xRet140
					If EditDocXml(cModelo,lSetPc,lMata140,lMata103)
					    U_MyAviso("Aviso","Importa็ใo da Pr้-Nota Efetuada com Sucesso."+CRLF+" Utilize a op็ใo :"+CRLF+;
						"Movimento -> Pre-Nota Entrada "+CRLF+" para Verificar a Integridade dos Dados.",{"OK"},3)
						lEditStat := .T.
					EndIf 
				EndIf	
			Else
			    U_MyAviso("Aviso","Gera็ใo da Nota fiscal de entrada efetuada com Sucesso."+CRLF+" Utilize a op็ใo :"+CRLF+;
				"Movimento -> Nota Fiscal de Entrada "+CRLF+" para Verificar a Integridade dos Dados.",{"OK"},3)
				lEditStat := .T.
			EndIf	
			If lEditStat 
				DbSelectArea("ZBZ")
				Reclock("ZBZ",.F.)
				ZBZ->ZBZ_PRENF  := Iif(Empty(SF1->F1_STATUS),'S','N')  
				ZBZ->ZBZ_TPDOC  := SF1->F1_TIPO
				ZBZ->ZBZ_CODFOR := aCabec[6][2]
				ZBZ->ZBZ_LOJFOR := aCabec[7][2]
				if FieldPos("ZBZ_MANIF") > 0
					ZBZ->ZBZ_MANIF	:= U_MANIFXML( AllTrim( ZBZ->ZBZ_CHAVE ), .T. )
				endif
				MsUnlock()     
			EndIf				
	
			lRetorno := .T.
		EndIf 
	EndIf
Endif
           
RestArea(aArea)
SetKEY( VK_F3 ,  cKeyFe )
Return


/*/
`ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPutDePara บ Autor ณ Roberto Souza      บ Data ณ  25/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Inclui de/para de inclusao de pre-nota                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PutDePara(oLbx1,oLbx2,cTipoNF,cTipoAm,cCnpjEmi,cCodEmit,cLojaEmit)
Local oDlg
Local lRet    := .F.           
Local nOpc    := 0   
Local aDados  := {}                                
Local nLinha  := oLbx2:NAT
Local oItem   := oLbx2:AARRAY[nLinha]
Local cTblCad := Iif(cTipoNF $ "D|B","SA1","SA2")
Local cTblDP  := Iif(cTipoAm=="2","ZB5", Iif(cTipoNF $ "D|B", "SA7","SA5")  )
Local lGravou := .F.
Local aArea   := GetArea()
Local cNomeEnt:= "" 
Local cKeyFe  := SetKEY( VK_F3 ,  Nil )

If cTipoAm=="3"
	U_MyAviso("Aviso","Relacionamento sem amarra็ใo. Deve ser cadastrado direto no Cadastro de Produto!",{"OK"},2)
	SetKEY( VK_F3 ,  cKeyFe )
	
	oLbx1:Refresh()
	oLbx2:Refresh()
	RestArea(aArea)
	Return(.F.)
EndIf

If cTblCad == "SA2"
	cNomEmit := Posicione("SA2",3,xFilial("SA2")+cCnpjEmi,"A2_NOME")
	cNomeEnt := "Fornecedor"
Else
	cNomEmit :=  Posicione("SA1",3,xFilial("SA1")+cCnpjEmi,"A1_NOME")
	cNomeEnt := "Cliente"
EndIf
	
cCodProd := oLbx2:AARRAY[nLinha][1]
cDescProd:= oLbx2:AARRAY[nLinha][2]

cCodProdP  := Space(15)
cDescProdP := Space(60)


DEFINE MSDIALOG oDlg TITLE "Relacionamento De/Para : "+cTblDP FROM 0,0 TO 280,552 OF oDlg PIXEL

@ 06,06 TO 070,271 LABEL "Dados do "+cNomeEnt OF oDlg PIXEL

@ 15,015 SAY   "Codigo" SIZE 45,8 PIXEL OF oDlg       
@ 25,015 MSGET cCodEmit PICTURE "@!" SIZE 30,08 PIXEL OF oDlg WHEN .F.

@ 15,050 SAY "Loja"  SIZE 45,8 PIXEL OF oDlg
@ 25,050 MSGET cLojaEmit PICTURE "@!" SIZE 20,08 PIXEL OF oDlg WHEN .F.

@ 15,075 SAY "CNPJ"   SIZE 45,8 PIXEL OF oDlg
@ 25,075 MSGET cCnpjEmi PICTURE "@ 99.999.999/9999-99" SIZE 50,08 PIXEL OF oDlg WHEN .F.

@ 15,130 SAY   "Nome" SIZE 45,8 PIXEL OF oDlg       
@ 25,130 MSGET cNomEmit PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F.

@ 45,015 SAY   "Cod Produto" SIZE 45,8 PIXEL OF oDlg       
@ 55,015 MSGET cCodProd PICTURE "@!" SIZE 50,08 PIXEL OF oDlg WHEN .F.

@ 45,080 SAY   "Descri็ใo Produto" SIZE 45,8 PIXEL OF oDlg       
@ 55,080 MSGET cDescProd PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F.


@ 76,06 TO 116,271 LABEL "Produto pr๓prio" OF oDlg PIXEL

@ 085,015 SAY   "Cod Produto" SIZE 45,8 PIXEL OF oDlg       
@ 095,015 MSGET cCodProdP F3 "SB1" PICTURE "@!" SIZE 50,08 PIXEL OF oDlg Valid( cDescProdP:=Posicione("SB1",1,xFilial("SB1")+cCodProdP,"B1_DESC") )

@ 085,080 SAY   "Descri็ใo Produto" SIZE 45,8 PIXEL OF oDlg       
@ 095,080 MSGET cDescProdP PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F. 
                                                 

@ 125,195 BUTTON "Cancelar" SIZE 35,12 PIXEL OF oDlg Action(nOpc:= 0,oDlg:End())
@ 125,235 BUTTON "Salvar" SIZE 35,12 PIXEL OF  oDlg Action(nOpc:= 1,iif(  _verSB1(cCodProdP),oDlg:End(),U_MyAviso("Aviso","Produto pr๓prio nใo cadastrado",{"OK"},1)) )


ACTIVATE MSDIALOG oDlg CENTERED


If nOpc == 1 .And. !Empty(cCodProdP)

	If cTblDP =="ZB5"
		If cTblCad == "SA2"
			RecLock("ZB5",.T.)
			ZB5->ZB5_FILIAL  := xFilial("ZB5")
			ZB5->ZB5_FORNEC  := cCodEmit
			ZB5->ZB5_LOJFOR  := cLojaEmit
			ZB5->ZB5_CGC     := cCnpjEmi
			ZB5->ZB5_NOME    := cNomEmit
			ZB5->ZB5_PRODFO  := cCodProd
			ZB5->ZB5_PRODFI  := cCodProdP
			ZB5->ZB5_DESCPR  := cDescProdP
			ZB5->ZB5_CLIENT  := ""
			ZB5->ZB5_CGCC    := ""
			ZB5->ZB5_NOMEC   := ""
			ZB5->ZB5_LOJCLI	 := ""									
			MsUnlock()
			lGravou := .T.
		ElseIf cTblCad == "SA1"
			RecLock("ZB5",.T.)
			ZB5->ZB5_FILIAL  := xFilial("ZB5")
			ZB5->ZB5_FORNEC  := ""
			ZB5->ZB5_LOJFOR  := ""
			ZB5->ZB5_CGC     := ""
			ZB5->ZB5_NOME    := ""
			ZB5->ZB5_PRODFO  := cCodProd
			ZB5->ZB5_PRODFI  := cCodProdP
			ZB5->ZB5_DESCPR  := cDescProdP
			ZB5->ZB5_CLIENT  := cCodEmit
			ZB5->ZB5_LOJCLI	 := cLojaEmit									
			ZB5->ZB5_CGCC    := cCnpjEmi
			ZB5->ZB5_NOMEC   := cNomEmit
			MsUnlock()
			lGravou := .T.
		EndIf	

	ElseIf cTblDP =="SA5"
		If cTblCad == "SA2"
			DbSelectArea("SA5")		
			DbSetOrder(1)
			If DbSeek(xFilial("SA5")+cCodEmit+cLojaEmit+cCodProdP)
			
				if .not. empty( SA5->A5_CODPRF )
	            
		           	U_MyAviso("Aviso","Jแ existe um relacionamento cadastrado para o produto:"+CRLF+cCodProdP+" - "+;
		           	          cDescProdP+CRLF+SA5->A5_CODPRF,{"OK"},3)

		  		else
		  		
					RecLock("SA5",.F.)
					SA5->A5_CODPRF  := cCodProd
					MsUnlock()
					lGravou := .T.

		  		endif

			Else
				RecLock("SA5",.T.)
				SA5->A5_FILIAL  := xFilial("SA5")
				SA5->A5_FORNECE := cCodEmit
				SA5->A5_LOJA    := cLojaEmit
				SA5->A5_NOMEFOR := cNomEmit
				SA5->A5_PRODUTO := cCodProdP
				SA5->A5_NOMPROD := cDescProdP
				SA5->A5_CODPRF  := cCodProd
				MsUnlock()
				lGravou := .T.
			EndIf
		EndIf

	ElseIf cTblDP =="SA7"
		If cTblCad == "SA1"
			DbSelectArea("SA7")		
			DbSetOrder(1)
			If DbSeek(xFilial("SA7")+cCodEmit+cLojaEmit+cCodProdP)

				if .not. empty( SA7->A7_CODCLI )
	
		           	U_MyAviso("Aviso","Jแ existe um relacionamento cadastrado para o produto:"+CRLF+cCodProdP+" - "+;
		           	cDescProdP+CRLF+SA7->A7_CODCLI,{"OK"},3)
	
	           	else
	
					RecLock("SA7",.F.)
					SA7->A7_CODCLI  := cCodProd
					MsUnlock()
					lGravou := .T.

	           	endif

			Else
				RecLock("SA7",.T.)
				SA7->A7_FILIAL  := xFilial("SA7")
				SA7->A7_CLIENTE := cCodEmit
				SA7->A7_LOJA    := cLojaEmit
				SA7->A7_DESCCLI := cDescProdP //cNomEmit em 31/03/2014
				SA7->A7_PRODUTO := cCodProdP
//				SA7->A7_NOMPROD := cDescProdP
				SA7->A7_CODCLI  := cCodProd
				MsUnlock()
				lGravou := .T.
			EndIf
		EndIf
	EndIf

EndIf

                          
If lGravou 
	U_MyAviso("Aviso","Relacionamento cadastrado com sucesso!",{"OK"},2)

EndIf

SetKEY( VK_F3 ,  cKeyFe )

oLbx1:Refresh()
oLbx2:Refresh()
RestArea(aArea)
Return(lRet)

Static Function _verSB1(cCodProdP)
Local lRet := .F.

SB1->( dbsetorder( 1 ) )
if SB1->( dbseek( xFilial("SB1")+cCodProdP ) )
   lRet := .T.
else
   lRet := .F.
endif

Return lRet



/*/
`ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPutDePara2บ Autor ณ Eneo               บ Data ณ  14/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Inclui de/para de inclusao de pre-nota para todos com mesmoบฑฑ
ฑฑบ          ณ c๓digo interno SB1                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PutDePara2(oLbx1,oLbx2,cTipoNF,cTipoAm,cCnpjEmi,cCodEmit,cLojaEmit,aProdOk,aProdNo)
Local oDlg
Local lRet    := .F.           
Local nOpc    := 0   
Local aDados  := {}                                
Local nLinha  := oLbx2:NAT
Local oItem   := oLbx2:AARRAY[nLinha]
Local cTblCad := Iif(cTipoNF $ "D|B","SA1","SA2")
Local cTblDP  := "ZB5"
Local lGravou := .F.
Local aArea   := GetArea()
Local cNomeEnt:= "" 
Local cKeyFe  := SetKEY( VK_F3 ,  Nil )

If cTblCad == "SA2"
	cNomEmit := Posicione("SA2",3,xFilial("SA2")+cCnpjEmi,"A2_NOME")
	cNomeEnt := "Fornecedor"
Else
	cNomEmit :=  Posicione("SA1",3,xFilial("SA1")+cCnpjEmi,"A1_NOME")
	cNomeEnt := "Cliente"
EndIf

cCodProd := oLbx2:AARRAY[nLinha][1]
cDescProd:= oLbx2:AARRAY[nLinha][2]

cCodProdP  := Space(15)
cDescProdP := Space(60)


DEFINE MSDIALOG oDlg TITLE "Relacionamento De/Para : "+cTblDP FROM 0,0 TO 280,552 OF oDlg PIXEL

@ 06,06 TO 070,271 LABEL "Dados do "+cNomeEnt OF oDlg PIXEL

@ 15,015 SAY   "Codigo" SIZE 45,8 PIXEL OF oDlg       
@ 25,015 MSGET cCodEmit PICTURE "@!" SIZE 30,08 PIXEL OF oDlg WHEN .F.

@ 15,050 SAY "Loja"  SIZE 45,8 PIXEL OF oDlg
@ 25,050 MSGET cLojaEmit PICTURE "@!" SIZE 20,08 PIXEL OF oDlg WHEN .F.

@ 15,075 SAY "CNPJ"   SIZE 45,8 PIXEL OF oDlg
@ 25,075 MSGET cCnpjEmi PICTURE "@ 99.999.999/9999-99" SIZE 50,08 PIXEL OF oDlg WHEN .F.

@ 15,130 SAY   "Nome" SIZE 45,8 PIXEL OF oDlg       
@ 25,130 MSGET cNomEmit PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F.

@ 45,015 SAY   "Cod Produto" SIZE 45,8 PIXEL OF oDlg       
@ 55,015 MSGET "***" PICTURE "@!" SIZE 50,08 PIXEL OF oDlg WHEN .F.

@ 45,080 SAY   "Descri็ใo Produto" SIZE 45,8 PIXEL OF oDlg       
@ 55,080 MSGET "** TODOS **" PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F.


@ 76,06 TO 116,271 LABEL "Produto pr๓prio" OF oDlg PIXEL

@ 085,015 SAY   "Cod Produto" SIZE 45,8 PIXEL OF oDlg       
@ 095,015 MSGET cCodProdP F3 "SB1" PICTURE "@!" SIZE 50,08 PIXEL OF oDlg Valid( cDescProdP:=Posicione("SB1",1,xFilial("SB1")+cCodProdP,"B1_DESC") )

@ 085,080 SAY   "Descri็ใo Produto" SIZE 45,8 PIXEL OF oDlg       
@ 095,080 MSGET cDescProdP PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F. 
                                                 

@ 125,195 BUTTON "Cancelar" SIZE 35,12 PIXEL OF oDlg Action(nOpc:= 0,oDlg:End())
@ 125,235 BUTTON "Salvar" SIZE 35,12 PIXEL OF  oDlg Action(nOpc:= 1,iif(  _verSB1(cCodProdP),oDlg:End(),U_MyAviso("Aviso","Produto pr๓prio nใo cadastrado",{"OK"},1)) )


ACTIVATE MSDIALOG oDlg CENTERED


If nOpc == 1 .And. !Empty(cCodProdP)

	For nLinha := 1 To Len( oLbx2:AARRAY )
		cCodProd := oLbx2:AARRAY[nLinha][1]
		cDescProd:= oLbx2:AARRAY[nLinha][2]
		If cTblCad == "SA2"
			RecLock("ZB5",.T.)
			ZB5->ZB5_FILIAL  := xFilial("ZB5")
			ZB5->ZB5_FORNEC  := cCodEmit
			ZB5->ZB5_LOJFOR  := cLojaEmit
			ZB5->ZB5_CGC     := cCnpjEmi
			ZB5->ZB5_NOME    := cNomEmit
			ZB5->ZB5_PRODFO  := cCodProd
			ZB5->ZB5_PRODFI  := cCodProdP
			ZB5->ZB5_DESCPR  := cDescProdP
			ZB5->ZB5_CLIENT  := ""
			ZB5->ZB5_CGCC    := ""
			ZB5->ZB5_NOMEC   := ""
			ZB5->ZB5_LOJCLI	 := ""									
			MsUnlock()
			lGravou := .T.
		ElseIf cTblCad == "SA1"
			RecLock("ZB5",.T.)
			ZB5->ZB5_FILIAL  := xFilial("ZB5")
			ZB5->ZB5_FORNEC  := ""
			ZB5->ZB5_LOJFOR  := ""
			ZB5->ZB5_CGC     := ""
			ZB5->ZB5_NOME    := ""
			ZB5->ZB5_PRODFO  := cCodProd
			ZB5->ZB5_PRODFI  := cCodProdP
			ZB5->ZB5_DESCPR  := cDescProdP
			ZB5->ZB5_CLIENT  := cCodEmit
			ZB5->ZB5_LOJCLI	 := cLojaEmit
			ZB5->ZB5_CGCC    := cCnpjEmi
			ZB5->ZB5_NOMEC   := cNomEmit
			MsUnlock()
			lGravou := .T.
		EndIf
		aadd( aProdOk, {cCodProd,cDescProd} )

	Next

EndIf

If lGravou
	aProdNo := {}
	aadd(aProdNo,{"- - -","- - - - - - -"} )
	oLbx1:SetArray( aProdOk )
	oLbx1:bLine := {|| {aProdOk[oLbx1:nAt,1],;
	     	            aProdOk[oLbx1:nAt,2]}}
	oLbx2:SetArray( aProdNo )
	oLbx2:bLine := {|| {aProdNo[oLbx2:nAt,1],;
	     	            aProdNo[oLbx2:nAt,2]}}
	U_MyAviso("Aviso","Relacionamento(s) cadastrado(s) com sucesso!",{"OK"},2)
EndIf

SetKEY( VK_F3 ,  cKeyFe )

oLbx1:Refresh()
oLbx2:Refresh()
RestArea(aArea)
Return(lRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg1บ Autor ณ Roberto Souza      บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg1(cPerg)
Local aHlpPor1 := {}
Local aHlpPor2 := {}

Aadd( aHlpPor1, "Informe o tipo de Nota fiscal que serใ")
Aadd( aHlpPor1, "gerada a partir do XML.               ")

Aadd( aHlpPor2, "Informe o tipo de amarracao que sera utilizada.")
Aadd( aHlpPor2, "N-Cod Protheus                                 ")
Aadd( aHlpPor2, "B-Amarracao SA5                                ")
Aadd( aHlpPor2, "C-Amarracao ZB5                                ")
Aadd( aHlpPor2, "D-Amarracao Pedido                             ")

DbSelectArea("SX1")
DbSetOrder(1)
DbGoTop()

cPerg := PADR(cPerg,6)

PutSx1(cPerg,"01","Informe Tipo da Nota ?"  ,"","","MV_CH1","N",1,0,1,"C","","","","","MV_PAR01","N-Normal","N-Normal","N-Normal","","B-Beneficiamento","B-Beneficiamento","B-Beneficiamento","D-Devolucao","D-Devolucao","D-Devolucao","","","","","","",aHlpPor1,aHlpPor1,aHlpPor1)
PutSx1(cPerg,"02","Cod. Produto a Utilizar?","","","MV_CH0","N",1,0,1,"C","","","","","MV_PAR02","N-Cod Protheus","N-Cod Protheus","N-Cod Protheus","","B-Amarracao SA5","B-Amarracao SA5","B-Amarracao SA5","C-Amarracao ZB5","C-Amarracao ZB5","C-Amarracao ZB5","D-Pedido","D-Pedido","D-Pedido","","","",aHlpPor2,aHlpPor2,aHlpPor2)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMP0005  บAutor  ณMicrosiga           บ Data ณ  09/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HFXML02L()
Local aLegenda := {}

AADD(aLegenda,{"BR_AZUL"    ,"XML Importado" })
AADD(aLegenda,{"BR_LARANJA"	,"Aviso Recbto Carga" })
AADD(aLegenda,{"BR_VERDE" 	,"Pr้-Nota a Classificar" })
AADD(aLegenda,{"BR_VERMELHO","Pr้-Nota Classificada" })
AADD(aLegenda,{"BR_PRETO"	,"Falha de Importa็ใo" })
AADD(aLegenda,{"BR_BRANCO"  ,"Xml Cancelado pelo Emissor" }) 
AADD(aLegenda,{"BR_AMARELO" ,"Falha na Consulta" })


BrwLegenda("Xml de Fornecedores", "Legenda", aLegenda)
Return Nil
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidXml  บ Autor ณ Roberto Souza      บ Data ณ  07/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Coloca o XML em uma estrutura padrใo para leitura.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidXml(cXml,cOcorr,lInvalid,cModelo,lCanc)
Local lRet := .T.
Local nAt1 := nAt2 := nAt3 := nAt4 := 0
Local cNfe := ""
Local cProt:= ""
Local cInfo:= "" 
Local cError:=""
Local cWarning:=""
                
If "<NFE" $ Upper(cXml) .And. ('VERSAO="1.10"' $ Upper(cXml) .Or. "VERSAO='1.10'" $ Upper(cXml))
	cModelo := "00"
	lInvalid := .T.
	lRet := .F.
	cOcorr := "Modelo Invแlido ou nใo homologado."
	Return(lRet)
EndIf

If "<NFE" $ Upper(cXml)
	oXmlTeste := XmlParser( cXml, "_", @cError, @cWarning )  
	cTagVerXml := "oXmlTeste:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT"
    If Type(cTagVerXml)<>"U"   //se nใo tiver a versใo provavelmente ้ Presta็ใo de Servi็o, ้ outro modelo.
		cModelo := "55"
	Else
		cModelo := "00"
		lInvalid := .T.
		lRet := .F.
		cOcorr := "Modelo Invแlido ou nใo homologado."
		Return(lRet)
	Endif
ElseIf "<PROCCANCNFE" $ Upper(cXml) .or. ("<PROCEVENTONFE" $ Upper(cXml) .and. "<TPEVENTO>110111" $ Upper(cXml) )
	cModelo := "55"
ElseIf "<CTE" $ Upper(cXml) .Or. "<PROCCANCCTE" $ Upper(cXml)
	cModelo := "57"	
Else
	cModelo := "00"
	lInvalid := .T.
	lRet := .F.
	cOcorr := "Modelo Invแlido ou nใo homologado."
	Return(lRet)
EndIf


If cModelo == "55"
	If !"PROCCANCNFE" $ Upper(cXml) .and. !( "<PROCEVENTONFE" $ Upper(cXml) .and. "<TPEVENTO>110111" $ Upper(cXml) )
		
		nAt1:= At('<NFE ',Upper(cXml))
		nAt2:= At('</NFE>',Upper(cXml))+ 6
		//Corpo da Nfe
		If nAt1 <=0
			nAt1:= At('<NFE>',Upper(cXml))
		EndIf 	
		If nAt1 > 0 .And. nAt2 > 6
			cNfe := Substr(cXml,nAt1,nAt2-nAt1)
		Else
			cOcorr := "Nf-e inconsistente."	
			lret := .F.
			lInvalid := .T.
		EndIf	
		nAt3:= At('<PROTNFE ',Upper(cXml))
		nAt4:= At('</PROTNFE>',Upper(cXml))+ 10
		//Protocolo	
		If nAt3 > 0 .And. nAt4 > 10
			cProt := Substr(cXml,nAt3,nAt4-nAt3)
		Else
			lret := .F.
			lInvalid := .F.
		EndIf
		
		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= '<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
		cXml+= cNfe
		cXml+= cProt
		cXml+= '</nfeProc>'
		
	ElseIf "PROCCANCNFE" $ Upper(cXml)        

		nAt1:= At('<CANCNFE ',Upper(cXml))
		nAt2:= At('</CANCNFE>',Upper(cXml))+ 10
		//Corpo da Nfe
		If nAt1 <=0
			nAt1:= At('<CANCNFE>',Upper(cXml))
		EndIf 	
		If nAt1 > 0 .And. nAt2 > 10
			cNfe := Substr(cXml,nAt1,nAt2-nAt1)
		Else
			cOcorr := "Nf-e inconsistente."	
			lret := .F.
			lInvalid := .T.
		EndIf	
		nAt3:= At('<RETCANCNFE ',Upper(cXml))
		nAt4:= At('</RETCANCNFE>',Upper(cXml))+ 13
		//Protocolo	
		If nAt3 > 0 .And. nAt4 > 13
			cProt := Substr(cXml,nAt3,nAt4-nAt3)
		Else
			lret := .F.
			lInvalid := .F.
		EndIf
		
		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= '<procCancNfe versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
		cXml+= cNfe
		cXml+= cProt
		cXml+= '</procCancNfe>'	
	
		lCanc := .T.
	Elseif ("<PROCEVENTONFE" $ Upper(cXml) .and. "<TPEVENTO>110111" $ Upper(cXml) )

		nAt1:= At('<EVENTO ',Upper(cXml))
		nAt2:= At('</EVENTO>',Upper(cXml))+ 9
		//Corpo da Nfe
		If nAt1 <=0
			nAt1:= At('<EVENTO>',Upper(cXml))
		EndIf 	
		If nAt1 > 0 .And. nAt2 > 10
			cNfe := Substr(cXml,nAt1,nAt2-nAt1)
		Else
			cOcorr := "Nf-e Evento inconsistente."	
			lret := .F.
			lInvalid := .T.
		EndIf	
		nAt3:= At('<RETENVEVENTO ',Upper(cXml))
		nAt4:= At('</RETENVEVENTO>',Upper(cXml))+ 15
		//Protocolo	
		If nAt3 > 0 .And. nAt4 > 15
			cProt := Substr(cXml,nAt3,nAt4-nAt3)
		Else
			lret := .F.
			lInvalid := .F.
		EndIf
		
		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= '<procEventoNfe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
		cXml+= cNfe
		cXml+= cProt
		cXml+= '</procEventoNfe>'	
	
		lCanc := .T.
	EndIf
ElseIf cModelo == "57"

	If !"PROCCANCCTE" $ Upper(cXml)     
		nAt1:= At('<CTE ',Upper(cXml))
		nAt2:= At('</CTE>',Upper(cXml))+ 6
		//Corpo da Nfe
		If nAt1 <=0
			nAt1:= At('<CTE>',Upper(cXml))
		EndIf 	
		If nAt1 > 0 .And. nAt2 > 6
			cNfe := Substr(cXml,nAt1,nAt2-nAt1)
		Else
			cOcorr := "CT-e inconsistente."	
			lret := .F.
			lInvalid := .T.
		EndIf	
		nAt3:= At('<PROTCTE ',Upper(cXml))
		nAt4:= At('</PROTCTE>',Upper(cXml))+ 10
		//Protocolo	
		If nAt3 > 0 .And. nAt4 > 10
			cProt := Substr(cXml,nAt3,nAt4-nAt3)
		Else
			lret := .F.
			lInvalid := .F.
		EndIf
		
		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= '<cteProc versao="1.03" xmlns="http://www.portalfiscal.inf.br/cte">'
		cXml+= cNfe
		cXml+= cProt
		cXml+= '</cteProc>'
		
	ElseiF "PROCCANCCTE" $ Upper(cXml)    
	
		nAt1:= At('<CANCCTE ',Upper(cXml))
		nAt2:= At('</CANCCTE>',Upper(cXml))+ 10
		//Corpo da Nfe
		If nAt1 <=0
			nAt1:= At('<CANCCTE>',Upper(cXml))
		EndIf 	
		If nAt1 > 0 .And. nAt2 > 10
			cNfe := Substr(cXml,nAt1,nAt2-nAt1)
		Else
			cOcorr := "Nf-e inconsistente."	
			lret := .F.
			lInvalid := .T.
		EndIf	
		nAt3:= At('<RETCANCCTE ',Upper(cXml))
		nAt4:= At('</RETCANCCTE>',Upper(cXml))+ 13
		//Protocolo	
		If nAt3 > 0 .And. nAt4 > 13
			cProt := Substr(cXml,nAt3,nAt4-nAt3)
		Else
			lret := .F.
			lInvalid := .F.
		EndIf
		
		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= '<procCancCTe versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">'
		cXml+= cNfe
		cXml+= cProt
		cXml+= '</procCancCTe>'	
	
		lCanc := .T.	
	
		lCanc := .T.
    EndIf
EndIf

cXml := NoAcento(cXml)
cXml := EncodeUTF8(cXml)

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNoAcento  บ Autor ณ Roberto Souza      บ Data ณ  07/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retira caracteres especiais.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "แ้ํ๓๚"+"มษอำฺ"
Local cCircu := "โ๊๎๔๛"+"ยสฮิÛ"
Local cTrema := "ไ๋๏๖ü"+"ฤหฯึÜ"
Local cCrase := "เ่์๒๙"+"ภศฬาู" 
Local cTio   := "ใ๕"
Local cCecid := "็ว"
Local lChar  := .F.

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123// .and. (cChar<> 10 .And. cChar<> 13)
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
Return cString

Return(cString)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMoveXml   บ Autor ณ Roberto Souza      บ Data ณ  07/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Move o xml para a estrutura padrใo de grava็ใo.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/           
Static Function MoveXml(lAuto,cFilename, cError, cLogProc, acPath)
Local cPathXml  := AllTrim(SuperGetMv("MV_X_PATHX"))            
Local lRet      := .F.
Local nHandle   := 0
Local cIni      := ""
Local nPos      := 0
Default cLogProc:= ""

If Empty(cPathXml)
	cPathXml := "\xmlsource\"
EndIf   
If !ExistDir(cPathXml)
	Makedir(cPathXml)
EndIf

If Right(Upper(cFilename),4)==".XML"

	cXml := MemoRead(cFilename)
	If Len(cXml) >= 65534
		cXml := LerComFRead( cFilename )
	endif

	//para ordenar primeiro as nfe e por ultimo as canceladas, e entใo se tiver a mesma chave com o xml principal
	//e o xml cancelado ele processa primeiro o xml principal depois o cancelado.
	If "<PROCCANCNFE" $ Upper(cXml) .Or.;
	   "<PROCCANCCTE" $ Upper(cXml) .Or.;
	  ("<PROCEVENTONFE" $ Upper(cXml) .and. "<TPEVENTO>110111" $ Upper(cXml) )
		cIni := "PCan"
	Else
		cIni := "Nfe"
	Endif
	nPos := AT(acPath,cFilename)
	if nPos > 0
		nPos := nPos + len(acPath)
		cFilename := Substr(cFilename,1,nPos-1)+cIni+Substr(cFilename,nPos,len(cFilename))
	endif

	nHandle := FCreate(cPathXml+cFilename)

	If nHandle <= 0
    	cError += "Nao foi possivel criar o arquivo "+cPathXml+cFilename
    	cLogProc+= Time()+"-"+"Nao foi possivel criar o arquivo "+cPathXml+cFilename+CRLF
	Else
		FWrite(nHandle, cXml)
		FClose(nHandle)
    	cLogProc+= Time()+"-"+"Arquivo "+cPathXml+cFilename + " criado com sucesso."+CRLF	
		lRet := .T.
	EndIf	
		
EndIf

Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcXml   บ Autor ณ Roberto Souza      บ Data ณ  07/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Processa os XMLs na estrutura padrใo para leitura.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ProcXml(lAuto,lEnd,oProcess,cLogProc,nCount)
Local lRet     := .F.                     
Local ny       := 0                     
Local aFiles   := {}
Local cDir     := "\"+AllTrim(GetNewPar("MV_X_PATHX",""))+"\"
Local lDirCnpj := AllTrim(GetNewPar("XM_DIRCNPJ","N")) == "S"                     
Local lDirFil  := AllTrim(GetNewPar("XM_DIRFIL" ,"N")) == "S" 
Local lDirMod  := AllTrim(GetNewPar("XM_DIRMOD" ,"N")) == "S"                     
Local cDirDest := AllTrim(cDir+"Importados\")                     
Local cDirRej  := AllTrim(cDir+"Rejeitados\")                     
Local cDirCfg  := AllTrim(cDir+"Cfg\")
Local cDrive   := "" 
Local cPath    := ""  
Local cNewFile := ""
Local cExt     := ""                        
Local lCopy    := .F.
Local nErase   := 0 
Local cFilXml  := ""
Local cKeyXml  := ""
Local lOnline  := .F.
Local cInfo    := ""
Local cErroR   := ""
Local cErroProc:= ""
Local cMsg     := ""
Local cOcorr   := ""
Local cPref    := ""  
Local aPref    := {"CTE","NFE"} 
Local lNewVer  := AllTrim(GetSrvProfString("HF_DEBUGKEY","0"))=="1"
Local nTag     := 0
Private oXml     := Nil
Private lOver    := .F.
Private cMsgTag  := ""
DbSelectArea("SM0")
nRecFil := Recno()

Private aFilsLic := {}
Private lXmlsLic := .F.
Private aFilsEmp := U_XGetFilS(SM0->M0_CGC,@aFilsLic)

DbSelectArea("SM0")
DbGoTo(nRecFil)

Default oProcess:= Nil

cDir           := StrTran(cDir,cBarra+cBarra,cBarra)
cDirDest       := StrTran(cDirDest,cBarra+cBarra,cBarra)
cDirRej        := StrTran(cDirRej,cBarra+cBarra,cBarra)
_cDirDest      := cDirDest
_cDirRej       := cDirRej
cDirCfg        := StrTran(cDirCfg,cBarra+cBarra,cBarra)
     
If !ExistDir(cDirDest)
	Makedir(cDirDest)
EndIf
If !ExistDir(cDirRej)
	Makedir(cDirRej)
EndIf

lOnline := U_HFSTATSEF(lAuto,@cIdEnt,@cInfo,.F.)

If Empty( aFilsEmp )

    cAssunto := "Aviso de Falta de Licen็a - Importa็ใo XML"
    cPara	 := AllTrim(SuperGetMv("XM_MAIL02")) // Conta de Email para erros
    aTo := Separa(cPara,";")
	
	cDirMail  := AllTrim(SuperGetMv("MV_X_PATHX")) + cBarra+"template"+cBarra+"xml_erro.html"
	
	If File(cDirMail)
		cTemplate := MemoRead(cDirMail)		  
	Else   
		cTemplate := ''
	EndIf 
	cInfo := "<center><b>Nใo foi possํvel encontrar lice็a valida.</b></center>"+CRLF+cInfo
	    
	cMsgCfg := ""
	cMsgCfg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">
	cMsgCfg += '<head>
	cMsgCfg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	cMsgCfg += '<title>Importa XML</title>
	cMsgCfg += '  <style type="text/css"> 
	cMsgCfg += '	<!-- 
	cMsgCfg += '	body {background-color: rgb(37, 64, 97);} 
	cMsgCfg += '	.style1 {font-family: Hyperfont,Verdana, Arial;font-size: 12pt;} 
	cMsgCfg += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} 
	cMsgCfg += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} 
	cMsgCfg += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} 
	cMsgCfg += '	.style5 {font-size: 10pt} 
	cMsgCfg += '	--> 
	cMsgCfg += '  </style>
	cMsgCfg += '</head>
	cMsgCfg += '<body>
	cMsgCfg += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">
	cMsgCfg += '  <tbody>
	cMsgCfg += '    <tr>
	cMsgCfg += '      <td colspan="2">
	cMsgCfg += '    <Center>
	cMsgCfg += '      <H2>LICENวA NรO ENCONTRADA OU VENCIDA PARA TODAS AS FILIAIS</H2>
	cMsgCfg += '      </Center>
	cMsgCfg += '      <hr>			
	cMsgCfg += '      <p class="style1">'+cInfo + CRLF +'</p>
	cMsgCfg += '      <hr>			
	cMsgCfg += '      </td>
	cMsgCfg += '    </tr>
	cMsgCfg += '  </tbody>
	cMsgCfg += '</table>
	cMsgCfg += '<p class="style1">&nbsp;</p>
	cMsgCfg += '</body>
	cMsgCfg += '</html>

	cBodyMail := ""
	cObs := cInfo + CRLF

	cMsg :=cMsgCfg
//	nRet:= 	U_HX_MAIL(aTo,cAssunto,cMsg,@cError,"","",cPara)	
	nRet:= 	U_MAILSEND(aTo,cAssunto,cMsg,@cError,"","",cPara,"","")
	lRet:=.F.

ElseIf !lOnline
    cAssunto := "Aviso de Falha - Importa็ใo XML - Conexใo - Entidade : "+cIdEnt
    cPara	 := AllTrim(SuperGetMv("XM_MAIL02")) // Conta de Email para erros
    aTo := Separa(cPara,";")
	
	cDirMail  := AllTrim(SuperGetMv("MV_X_PATHX")) + cBarra+"template"+cBarra+"xml_erro.html"
	
	If File(cDirMail)
		cTemplate := MemoRead(cDirMail)		  
	Else   
		cTemplate := ''
	EndIf 
	If "WSCERR044" $ cInfo
		cInfo := "<center><b>Nใo foi possํvel se conectar com o servidor de WebServices.</b></center>"+CRLF+cInfo
	EndIf
	    
	cMsgCfg := ""
	cMsgCfg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">
	cMsgCfg += '<head>
	cMsgCfg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	cMsgCfg += '<title>Importa XML</title>
	cMsgCfg += '  <style type="text/css"> 
	cMsgCfg += '	<!-- 
	cMsgCfg += '	body {background-color: rgb(37, 64, 97);} 
	cMsgCfg += '	.style1 {font-family: Hyperfont,Verdana, Arial;font-size: 12pt;} 
	cMsgCfg += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} 
	cMsgCfg += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} 
	cMsgCfg += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} 
	cMsgCfg += '	.style5 {font-size: 10pt} 
	cMsgCfg += '	--> 
	cMsgCfg += '  </style>
	cMsgCfg += '</head>
	cMsgCfg += '<body>
	cMsgCfg += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">
	cMsgCfg += '  <tbody>
	cMsgCfg += '    <tr>
	cMsgCfg += '      <td colspan="2">
	cMsgCfg += '    <Center>
	cMsgCfg += '      <H2>FALHA DE CONEXรO - WEBSERVICES</H2>
	cMsgCfg += '      </Center>
	cMsgCfg += '      <hr>			
	cMsgCfg += '      <p class="style1">'+cInfo + CRLF + cError+'</p>
	cMsgCfg += '      <hr>			
	cMsgCfg += '      </td>
	cMsgCfg += '    </tr>
	cMsgCfg += '  </tbody>
	cMsgCfg += '</table>
	cMsgCfg += '<p class="style1">&nbsp;</p>
	cMsgCfg += '</body>
	cMsgCfg += '</html>

	cBodyMail := ""
	cObs := cInfo + CRLF + cError

	cMsg :=cMsgCfg
//	nRet:= 	U_HX_MAIL(aTo,cAssunto,cMsg,@cError,"","",cPara)	
	nRet:= 	U_MAILSEND(aTo,cAssunto,cMsg,@cError,"","",cPara,"","")
	lRet:=lOnline
Else

    
	If !lAuto .Or. oProcess<>Nil            
		oProcess:IncRegua1("Processando Xml...")
		oProcess:IncRegua2("Entidade : "+cIdEnt+" - Status Sefaz Ok...")                        

		aFiles	:=	Directory(cDir+"*.XML","D")

		oProcess:SetRegua1(0)
		oProcess:SetRegua2(Len(aFiles))                        
	Else
		aFiles	:=	Directory(cDir+"*.XML","D")	
	EndIf
	aSort( aFiles,,,{|x,y| x[1]<y[1] } )

	For nI := 1 To Len(aFiles)
		lInvalid  := .F.
		SplitPath(cDir+AllTrim(aFiles[nI,1]),@cDrive,@cPath, @cNewFile,@cExt)
		cModelo   := "" 
		cOcorr    := ""
		cErroProc := ""
		cPref     := "XXX"  
		cFilXml   := "XX"   
		lCanc     := .F.
		lXmlsLic  := .F.
		
		cXml := MemoRead(cPath+cNewFile+cExt)    

		nTamFile := Len(cXml)
		
		If nTamFile >= 65534
			lOver := .T.
			cXml := LerComFRead( cPath+cNewFile+cExt )
		Else
			lOver := .F.
		EndIf

		oXml := Nil
		If lOver
			VldXmlOK(2,cPath+cNewFile+cExt,@cXml,@cOcorr,@lInvalid,@cModelo,@lCanc,@oXml)	
		Else
			ValidXml(@cXml,@cOcorr,@lInvalid,@cModelo,@lCanc)
        EndIf

		if AllTrim(GetNewPar("XM_XMLSEF" ,"N")) == "S"
			If !ExistDir(cDirCfg)
				Makedir(cDirCfg)
			EndIf
			If .Not. ChkTagNfe(cDirCfg+"TagNfe.Cfg")
				cLogProc += "(ARQTAG) Nao foi possivel criar o arquivo ["+cDirCfg+"TagNfe.Cfg"+"]"+CRLF
			Else
				If ! lCanc .And. cModelo <> "57" //For While
					cLogProc += cNewFile+cExt+" (Verificando TAGs)"+CRLF
					cMsgTag  := ""
					nTag := U_HFXMLCPS(cDirCfg+"TagNfe.Cfg",@cXml,@cOcorr,@lInvalid,@cModelo )
					If nTag == -1
						cLogProc += "(ARQTAG) Nao foi possํvel abrir o arquivo ["+cDirCfg+"TagNfe.Cfg"+"]"+CRLF
					ElseIf nTag == -2
						cLogProc += "Nao foi possํvel obter chave para Baixar XML da sefaz."+CRLF
					ElseIf nTag == -3 .Or. nTag == -4
						cLogProc += AllTrim(cMsgTag) //+CRLF
					ElseIf nTag == -9
						cLogProc += "(ARQTAG) Nao foi possํvel criar o arquivo ["+cDirCfg+"TagNfe.Cfg"+"]"+CRLF
					ElseIf nTag > 0
						cLogProc += AllTrim(cMsgTag) //+CRLF
					EndIf
				EndIf
			EndIf
		EndIf

		If !lInvalid .And. Empty(cOcorr)
			If cModelo =="55"
				cPref := "NFE"
				If USANFE
//					ValidaXmlNfe(cXml,cPath+cNewFile+cExt,,,1,@lInvalid,@cLogProc,@cFilXml,@cKeyXml,@cOcorr)
					If lCanc
				   		CancXmlAll(cModelo,cXml,cPath+cNewFile+cExt,,,1,@lInvalid,@cLogProc,@cFilXml,@cKeyXml,@cOcorr,aFilsEmp,oXml)
					Else
						ValidaXmlAll(cModelo,cXml,cPath+cNewFile+cExt,,,1,@lInvalid,@cLogProc,@cFilXml,@cKeyXml,@cOcorr,aFilsEmp,oXml)
				    EndIf
				Else
					lInvalid  := .T.						
					cErroProc := "Processamento de NF-e desabibilado. Verifique parโmetro XM_USANFE."			
				EndIf
			
			ElseIf cModelo =="57"
				If USACTE 
		   			cPref := "CTE"
					If lCanc
						CancXmlAll(cModelo,cXml,cPath+cNewFile+cExt,,,1,@lInvalid,@cLogProc,@cFilXml,@cKeyXml,@cOcorr,aFilsEmp,oXml)
					Else
						ValidaXmlAll(cModelo,cXml,cPath+cNewFile+cExt,,,1,@lInvalid,@cLogProc,@cFilXml,@cKeyXml,@cOcorr,aFilsEmp,oXml)
				    EndIf
				Else
					lInvalid  := .T.						
					cErroProc := "Processamento de CT-e desabibilado. Verifique parโmetro XM_USACTE."
				EndIf
			EndIf		
	    Else
			cLogProc += cOcorr+" ["+cNewFile+cExt+"]"+CRLF
	    EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณArvore de diret๓rios                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cDirRej := cDirRej
		_cDirDest:= cDirDest
		If lXmlsLic
			_cDirLic := _cDirRej + "CNPJ_SEM_LICENCA" + cBarra
			If !ExistDir(_cDirLic)
				Makedir(_cDirLic)
			EndIf
		EndIf
		If lDirMod
			_cDirRej := _cDirRej + cPref+cBarra
			_cDirDest:= _cDirDest + cPref+cBarra
			If !ExistDir(_cDirDest)
				Makedir(_cDirDest)
			EndIf
			If !ExistDir(_cDirRej)
				Makedir(_cDirRej)
			EndIf
		EndIf

		If lDirFil
			_cDirRej := _cDirRej + cFilXml+cBarra
			_cDirDest:= _cDirDest + cFilXml+cBarra
			If !ExistDir(_cDirDest)
				Makedir(_cDirDest)
			EndIf
			If !ExistDir(_cDirRej)
				Makedir(_cDirRej)
			EndIf
		EndIf
		If lDirCnpj
			cCnpjEmit := Substr(cKeyXml,7,14)
			_cDirRej := _cDirRej + cCnpjEmit+cBarra
			_cDirDest:= _cDirDest + cCnpjEmit+cBarra
			If !ExistDir(_cDirDest)
				Makedir(_cDirDest)
			EndIf
			If !ExistDir(_cDirRej)
				Makedir(_cDirRej)
			EndIf	
		EndIf

		
		If !lAuto .Or. oProcess<>Nil            
			oProcess:IncRegua1("Processando Xml...")
			oProcess:IncRegua2("Arquivo ..."+Right(cNewFile+cExt,20))                        
		EndIf
		If lInvalid
			if File( cDir+cNewFile+cExt )
				if lOver
					cFileToWrite := LerComFRead(cDir+cNewFile+cExt)
				else
					cFileToWrite := MemoRead(cDir+cNewFile+cExt)
				endif
				if lXmlsLic
					cFinalF:= _cDirLic+cKeyXml+"-"+(IIf(lCanc,"ProcCanc",""))+cPref+cExt
				Else
					cFinalF:= _cDirRej+cKeyXml+"-"+(IIf(lCanc,"ProcCanc",""))+cPref+cExt
				EndIF
				MemoWrite(cFinalF,cFileToWrite)    
				nErase := FErase(cDir+cNewFile+cExt)

		  		If nErase < 0
					cLogProc += "(EM USO) Nao foi possivel remover o arquivo ["+cDir+cNewFile+cExt+"]"+CRLF
				EndIf
			Else
				if lXmlsLic
					cFinalF:= _cDirLic+cKeyXml+"-"+(IIf(lCanc,"ProcCanc",""))+cPref+cExt
				Else
					cFinalF:= _cDirRej+cKeyXml+"-"+(IIf(lCanc,"ProcCanc",""))+cPref+cExt
				EndIF
			EndIf
			MemoWrite(cFinalF+"_log.txt",cOcorr)		
		Else
			if lOver
				cFileToWrite := LerComFRead(cDir+cNewFile+cExt)
			else
				cFileToWrite := MemoRead(cDir+cNewFile+cExt)
			endif
			cFinalF:= _cDirDest+cKeyXml+"-"+(IIf(lCanc,"ProcCanc",""))+cPref+cExt
			MemoWrite(cFinalF,cFileToWrite)
			nErase := FErase(cDir+cNewFile+cExt)
					        
		  	If nErase < 0
				cLogProc += "(EM USO) Nao foi possivel remover o arquivo ["+cDir+cNewFile+cExt+"]"+CRLF
			EndIf		 
		EndIf
	Next

EndIf
Return(lRet)

      

Static Function AtuXmlStat(lAuto,lEnd,oProcess,cLogProc,nCount)

	U_COMP0012(lAuto,@lEnd,oProcess,@cLogProc,@nCount)
	U_UPForXML(lAuto,@lEnd,oProcess,@cLogProc,@nCount,.F.)
Return

User Function COMP0012(lAuto,lEnd,oProcess,cLogProc,nCount)

Local aArea     := GetArea()
Local cQry      := ""
Local cWhere    := ""
Local cAliasZBZ := GetNextAlias()
Local lSeekFor  := ZBZ->(FieldPos("ZBZ_CODFOR"))>0 .And. ZBZ->(FieldPos("ZBZ_LOJFOR"))>0
Local nOk       := 0
Local nNo       := 0 
Private lSharedA1:= U_IsShared("SA1")
Private lSharedA2:= U_IsShared("SA2")
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6"))
Private dDtProc := dDatabase - Val(GetNewPar("XM_D_STATUS","30"))
Default cLogProc:= ""
Default lAuto   := .F.     
Default oProcess:= Nil
Default lEnd    := .F. 
Default nCount  := 0
	If !lAuto .Or. oProcess<>Nil
		oProcess:IncRegua1("Atualizando Status Xml...")
		oProcess:IncRegua2("Aguarde...")                        
	EndIf
    cLogProc +="### Atualizando Status Xml. ###"+CRLF

//	cWhere := "%( (ZBZ.ZBZ_PRENF NOT IN ('F')) )%"				               
	cWhere := "%( (ZBZ.ZBZ_PRENF NOT IN ('F') AND ZBZ.ZBZ_DTRECB >='" +Dtos(dDtProc)+"') )%"			
	If lSeekFor    
		cCampos	:=	"%,ZBZ_CODFOR,ZBZ_LOJFOR%"
	Else
		cCampos	:=	"%%"	
	EndIf
	
	BeginSql Alias cAliasZBZ
	
	SELECT	ZBZ_FILIAL, ZBZ_NOTA, ZBZ_SERIE, ZBZ_DTNFE, ZBZ_PRENF, ZBZ_CNPJ, ZBZ_FORNEC, ZBZ_CNPJD, ZBZ_CLIENT,ZBZ_CHAVE,ZBZ_TPDOC, ZBZ_MODELO, ZBZ.R_E_C_N_O_ 
			%Exp:cCampos%
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
    		AND %Exp:cWhere%
	EndSql

	DbSelectArea("SF1")
    DbSetOrder(1)
    DbGoTop()
	DbSelectArea(cAliasZBZ)

	While !(cAliasZBZ)->(Eof())    
    
		cTipoNf := Iif(Empty((cAliasZBZ)->ZBZ_TPDOC),"N",(cAliasZBZ)->ZBZ_TPDOC)
		cCodFor := (cAliasZBZ)->ZBZ_CODFOR+(cAliasZBZ)->ZBZ_LOJFOR
		if empty( cCodFor )
			If cTipoNf $ "D|B"
				cFilSeek := Iif(lSharedA1,xFilial("SA1"),(cAliasZBZ)->ZBZ_FILIAL )
				DbSelectArea("SA1")
				DbSetOrder(3)
				If DbSeek(cFilSeek+(cAliasZBZ)->ZBZ_CNPJ) 
					cCodFor := SA1->A1_COD+SA1->A1_LOJA
					Do While .not. SA1->( eof() ) .and. SA1->A1_FILIAL == cFilSeek .and.;
				    	           SA1->A1_CGC == (cAliasZBZ)->ZBZ_CNPJ
						if SA1->A1_MSBLQL != "1"
							cCodFor := SA1->A1_COD+SA1->A1_LOJA
							exit
						endif
						SA1->( dbSkip() )
					EndDo
				EndIf
			Else
				cFilSeek := Iif(lSharedA2,xFilial("SA2"),(cAliasZBZ)->ZBZ_FILIAL )
				DbSelectArea("SA2")
				DbSetOrder(3)
				If DbSeek(cFilSeek+(cAliasZBZ)->ZBZ_CNPJ) 
					cCodFor := SA2->A2_COD+SA2->A2_LOJA 
					Do While .not. SA2->( eof() ) .and. SA2->A2_FILIAL == cFilSeek .and.;
					               SA2->A2_CGC == (cAliasZBZ)->ZBZ_CNPJ
						if SA2->A2_MSBLQL != "1"
							cCodFor := SA2->A2_COD+SA2->A2_LOJA 
							exit
						endif
						SA2->( dbSkip() )
					EndDo
				EndIf	
			EndIf
		EndIf
		
		DbSelectArea("SF1")
  
        lSeek := .F.
		cNotaSeek :=  Iif(nFormNfe > 0,StrZero(Val((cAliasZBZ)->ZBZ_NOTA),nFormNfe),AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA))))
       	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)

       	If !lSeek
			cNotaSeek := AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA)))
   	    	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
       	EndIf

       	If !lSeek
   			cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),6)
   	    	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
       	EndIf
 
       	If !lSeek
   			cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),9)
   	    	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
       	EndIf

       	If !lSeek .And. cTipoNf == "N" .and. (cAliasZBZ)->ZBZ_MODELO == "57"
			cTipoNf := "C" //->Checar se ้ C
			cNotaSeek :=  Iif(nFormNfe > 0,StrZero(Val((cAliasZBZ)->ZBZ_NOTA),nFormNfe),AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA))))
	       	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
	
	       	If !lSeek
				cNotaSeek := AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA)))
	   	    	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
	       	EndIf
	
	       	If !lSeek
	   			cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),6)
	   	    	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
	       	EndIf
	 
	       	If !lSeek
	   			cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),9)
	   	    	lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
	       	EndIf
		Endif

        If lSeek

 			nOk++
//			If !Empty(SF1->F1_STATUS)
				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				RecLock("ZBZ",.F.)
					ZBZ->ZBZ_PRENF := Iif(Empty(SF1->F1_STATUS),'S','N')
					if cTipoNf == "C" .and. ZBZ->ZBZ_TPDOC == "N" .And. ZBZ->ZBZ_MODELO == "57" 
						ZBZ->ZBZ_TPDOC := cTipoNf
					endif
				MsUnlock()     
//			EndIf
		ElseiF (cAliasZBZ)->ZBZ_PRENF $ "A|S|N" 
			If (cAliasZBZ)->ZBZ_PRENF == "A"
				nNo++
			Endif

			DbSelectArea("DB2")
			DbSetorder(1)
		    lSeek := .F.
			cNotaSeek :=  Iif(nFormNfe > 0,StrZero(Val((cAliasZBZ)->ZBZ_NOTA),nFormNfe),AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA))))
    	    lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor)
            
			DbSelectArea("ZBZ")
			DbGoTo((cAliasZBZ)->R_E_C_N_O_)
			RecLock("ZBZ",.F.)
				ZBZ->ZBZ_PRENF := iif(lSeek, 'A', 'B')
			MsUnlock()
			
		Else
			nNo++
		EndIf	

/*
		If !lAuto .Or. oProcess<>Nil
			oProcess:IncRegua2("Serie/Nota : "+(cAliasZBZ)->ZBZ_SERIE+"/"+(cAliasZBZ)->ZBZ_NOTA)                            
	    EndIf
*/
		(cAliasZBZ)->(DbSkip())    	
	EndDo
    cLogProc += StrZero(nOk,6)+" Pr้-Nota(s) encontrada(s)."+CRLF		
    cLogProc += StrZero(nNo,6)+" Pr้-Nota(s) nใo encontrada(s)."+CRLF					              
DbSelectArea(cAliasZBZ)			             
DbCloseArea()
RestArea(aArea)

Return


User Function UPStatXML(lAuto,lEnd,oProcess,cLogProc,nCount)

Local aArea      := GetArea()
Local cQry       := ""
Local cWhere     := ""
Local cAliasZBZ  := GetNextAlias()
Local lSeekFor   := ZBZ->(FieldPos("ZBZ_CODFOR"))>0 .And. ZBZ->(FieldPos("ZBZ_LOJFOR"))>0
Local nOk        := 0
Local nNo        := 0 
Private lSharedA1:= U_IsShared("SA1")
Private lSharedA2:= U_IsShared("SA2")
Private nFormNfe := Val(GetNewPar("XM_FORMNFE","6"))
Private dDtProc  := dDatabase - Val(GetNewPar("XM_D_STATUS","30"))
Default cLogProc := ""
Default lAuto    := .F.     
Default oProcess := Nil
Default lEnd     := .F. 
Default nCount   := 0

ProcRegua(0)

    cLogProc +="### Atualizando Status Xml. ###"+CRLF

//	cWhere := "%( (ZBZ.ZBZ_PRENF NOT IN ('F')) )%"				               
	cWhere := "%( (ZBZ.ZBZ_PRENF NOT IN ('F') AND ZBZ.ZBZ_DTRECB >='" +Dtos(dDtProc)+"') )%"			
	If lSeekFor    
		cCampos	:=	"%,ZBZ_CODFOR,ZBZ_LOJFOR%"
	Else
		cCampos	:=	"%%"	
	EndIf
	
	BeginSql Alias cAliasZBZ
	
	SELECT	ZBZ_FILIAL, ZBZ_NOTA, ZBZ_SERIE, ZBZ_DTNFE, ZBZ_PRENF, ZBZ_CNPJ, ZBZ_FORNEC, ZBZ_CNPJD, ZBZ_CLIENT,ZBZ_CHAVE,ZBZ_TPDOC, ZBZ.R_E_C_N_O_ 
			%Exp:cCampos%
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
    		AND %Exp:cWhere%
	EndSql           
	
	DbSelectArea("SF1")
    DbSetOrder(1)
    DbGoTop()
	DbSelectArea(cAliasZBZ)

	While !(cAliasZBZ)->(Eof())    
    
		cTipoNf := Iif(Empty((cAliasZBZ)->ZBZ_TPDOC),"N",(cAliasZBZ)->ZBZ_TPDOC)
		cCodFor := (cAliasZBZ)->ZBZ_CODFOR+(cAliasZBZ)->ZBZ_LOJFOR
		if empty( cCodFor )
			If cTipoNf $ "D|B"
				cFilSeek := Iif(lSharedA1,xFilial("SA1"),(cAliasZBZ)->ZBZ_FILIAL )
				DbSelectArea("SA1")
				DbSetOrder(3)
				If DbSeek(cFilSeek+(cAliasZBZ)->ZBZ_CNPJ) 
					cCodFor := SA1->A1_COD+SA1->A1_LOJA
					Do While .not. SA1->( eof() ) .and. SA1->A1_FILIAL == cFilSeek .and.;
					               SA1->A1_CGC == (cAliasZBZ)->ZBZ_CNPJ
						if SA1->A1_MSBLQL != "1"
							cCodFor := SA1->A1_COD+SA1->A1_LOJA
							exit
						endif
						SA1->( dbSkip() )
					EndDo
				EndIf
			Else
				cFilSeek := Iif(lSharedA2,xFilial("SA2"),(cAliasZBZ)->ZBZ_FILIAL )
				DbSelectArea("SA2")
				DbSetOrder(3)
				If DbSeek(cFilSeek+(cAliasZBZ)->ZBZ_CNPJ) 
					cCodFor := SA2->A2_COD+SA2->A2_LOJA 
					Do While .not. SA2->( eof() ) .and. SA2->A2_FILIAL == cFilSeek .and.;
					               SA2->A2_CGC == (cAliasZBZ)->ZBZ_CNPJ
						if SA2->A2_MSBLQL != "1"
							cCodFor := SA2->A2_COD+SA2->A2_LOJA 
							exit
						endif
						SA2->( dbSkip() )
					EndDo
				EndIf	
			EndIf		   
		Endif
		
		DbSelectArea("SF1")
  
        lSeek := .F.
		cNotaSeek :=  Iif(nFormNfe > 0,StrZero(Val((cAliasZBZ)->ZBZ_NOTA),nFormNfe),AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA))))
        lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
        
        If !lSeek
			cNotaSeek := AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA)))
    	    lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
        EndIf

        If !lSeek
	   		cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),6)
    	    lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
        EndIf
 
        If !lSeek
	   		cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),9)
    	    lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
        EndIf


        If lSeek

 			nOk++
//			If !Empty(SF1->F1_STATUS)
				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				RecLock("ZBZ",.F.)
					ZBZ->ZBZ_PRENF := Iif(Empty(SF1->F1_STATUS),'S','N')									
				MsUnlock()     
//			EndIf
		ElseiF (cAliasZBZ)->ZBZ_PRENF $ "S|N"
			DbSelectArea("ZBZ")
			DbGoTo((cAliasZBZ)->R_E_C_N_O_)
			RecLock("ZBZ",.F.)
				ZBZ->ZBZ_PRENF := 'B'									
			MsUnlock()     
		Else
			nNo++
		EndIf	

		IncProc("Processando "+(cAliasZBZ)->ZBZ_SERIE+"/"+Padr(cNotaSeek,9))
		(cAliasZBZ)->(DbSkip())    	
	EndDo
    cLogProc += StrZero(nOk,6)+" Pr้-Nota(s) encontrada(s)."+CRLF		
    cLogProc += StrZero(nNo,6)+" Pr้-Nota(s) nใo encontrada(s)."+CRLF					              
DbSelectArea(cAliasZBZ)			             
DbCloseArea()
RestArea(aArea)

Aviso("Aviso", cLogProc,{"OK"},3)

Return

      



User Function UPForXML(lAuto,lEnd,oProcess,cLogProc,nCount,lMostra)

Local aArea     := GetArea()
Local cQry      := ""
Local cWhere    := ""
Local cAliasZBZ := GetNextAlias()
Local nOk       := 0
Local nNo       := 0
Private lSharedA1:= U_IsShared("SA1")
Private lSharedA2:= U_IsShared("SA2")
Default cLogProc:= ""
Default lAuto   := .F.     
Default oProcess:= Nil
Default lEnd    := .F. 
Default nCount  := 0 
Default lMostra := .T.

ProcRegua(0)    
    cLogProc +="### Atualizando Fornecedores Xml. ###"+CRLF

	cWhere := "%( ZBZ.ZBZ_CODFOR='' OR ZBZ.ZBZ_LOJFOR='' OR ZBZ.ZBZ_FORNEC='' )%"				               

	BeginSql Alias cAliasZBZ
	
	SELECT	ZBZ_FILIAL, ZBZ_NOTA, ZBZ_SERIE, ZBZ_DTNFE, ZBZ_PRENF, ZBZ_CNPJ, ZBZ_FORNEC, 
			ZBZ_CNPJD, ZBZ_CLIENT,ZBZ_CHAVE, ZBZ_CODFOR, ZBZ_LOJFOR,ZBZ_TPDOC,ZBZ.R_E_C_N_O_ 
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
    		AND %Exp:cWhere%
	EndSql           

	DbSelectArea(cAliasZBZ)
	While !(cAliasZBZ)->(Eof())    
 
		cTipoNf := Iif(Empty((cAliasZBZ)->ZBZ_TPDOC),"N",(cAliasZBZ)->ZBZ_TPDOC)
		cCodFor := (cAliasZBZ)->ZBZ_CODFOR+(cAliasZBZ)->ZBZ_LOJFOR
		If cTipoNf $ "D|B"
			cFilSeek := Iif(lSharedA1,xFilial("SA1"),(cAliasZBZ)->ZBZ_FILIAL )
			DbSelectArea("SA1")
			DbSetOrder(3)
			If DbSeek(cFilSeek+(cAliasZBZ)->ZBZ_CNPJ) 
				cCodEmit  := SA1->A1_COD
				cLojaEmit := SA1->A1_LOJA
			    cRazao    := SA1->A1_NOME
				Do While .not. SA1->( eof() ) .and. SA1->A1_FILIAL == cFilSeek .and.;
					               SA1->A1_CGC == (cAliasZBZ)->ZBZ_CNPJ
					if SA1->A1_MSBLQL != "1"
						cCodEmit  := SA1->A1_COD
						cLojaEmit := SA1->A1_LOJA
			    		cRazao    := SA1->A1_NOME
						exit
					endif
					SA1->( dbSkip() )
				EndDo

				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				RecLock("ZBZ",.F.)
					ZBZ->ZBZ_CODFOR:= cCodEmit
					ZBZ->ZBZ_LOJFOR:= cLojaEmit
					ZBZ->ZBZ_FORNEC:= cRazao
				MsUnlock()     
				nOk++
	   		Else
				cCodEmit  := ""
				cLojaEmit := ""
			    cRazao    := ""		    		
				nNo++
	   		EndIf
		Else
			cFilSeek := Iif(lSharedA2,xFilial("SA2"),(cAliasZBZ)->ZBZ_FILIAL )
			DbSelectArea("SA2")
			DbSetOrder(3)
			If DbSeek(cFilSeek+(cAliasZBZ)->ZBZ_CNPJ) 
				cCodEmit  := SA2->A2_COD
				cLojaEmit := SA2->A2_LOJA
			    cRazao    := SA2->A2_NOME
				Do While .not. SA2->( eof() ) .and. SA2->A2_FILIAL == cFilSeek .and.;
					               SA2->A2_CGC == (cAliasZBZ)->ZBZ_CNPJ
					if SA2->A2_MSBLQL != "1"
						cCodEmit  := SA2->A2_COD
						cLojaEmit := SA2->A2_LOJA
			    		cRazao    := SA2->A2_NOME
						exit
					endif
					SA2->( dbSkip() )
				EndDo

				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				RecLock("ZBZ",.F.)
					ZBZ->ZBZ_CODFOR:= cCodEmit
					ZBZ->ZBZ_LOJFOR:= cLojaEmit
					ZBZ->ZBZ_FORNEC:= cRazao
				MsUnlock()     
				nOk++
	   		Else
				cCodEmit  := ""
				cLojaEmit := ""
			    cRazao    := ""		    		
				nNo++
	   		EndIf
		EndIf		   
  

		IncProc("Processando "+(cAliasZBZ)->ZBZ_CNPJ)
		(cAliasZBZ)->(DbSkip())    	
	EndDo
    cLogProc += StrZero(nOk,6)+" Fornecedor(es) encontrado(s)."+CRLF		
    cLogProc += StrZero(nNo,6)+" Fornecedor(es) nใo encontrado(s)."+CRLF					              
DbSelectArea(cAliasZBZ)			             
DbCloseArea()
RestArea(aArea)

If lMostra
	Aviso("Aviso", cLogProc,{"OK"},3)
EndIf
Return

   



User Function UPConsXML(lAuto,lEnd,oProcess,cLogProc,nCount,cUrl)

Local aArea      := GetArea()
Local cQry       := ""
Local cWhere     := ""
Local cAliasZBZ  := GetNextAlias()
Local nOk        := 0
Local nNo        := 0 
Local cMensagem  := ""
Local xManif     := "" //GETESB2
Private dDtProc  := dDatabase - Val(GetNewPar("XM_D_CANCEL","3"))
Default cLogProc := ""
Default lAuto    := .F.     
Default oProcess := Nil
Default lEnd     := .F. 
Default nCount   := 0
Default cURL     := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf
ProcRegua(0)

    cLogProc +="### Consultando Xml's. ###"+CRLF

	If lAuto 
		cWhere := "%( (ZBZ.ZBZ_PRENF NOT IN ('F') AND ZBZ.ZBZ_MAIL NOT IN ('4') AND ZBZ.ZBZ_DTRECB >='" +Dtos(dDtProc)+"') )%"		
	Else
		cWhere := "%( (ZBZ.ZBZ_PRENF NOT IN ('F') AND ZBZ.ZBZ_MAIL NOT IN ('4') AND ZBZ.ZBZ_DTRECB >='" +Dtos(dDtProc)+"') )%"	
	EndIf

			
	If ZBZ->(FieldPos("ZBZ_PROT"))>0     
		cCampos	:=	"%,ZBZ_PROT%"
	Else
		cCampos	:=	"%%"	
	EndIf
	  //GETESB2	
	BeginSql Alias cAliasZBZ

	SELECT	ZBZ_FILIAL, ZBZ_NOTA, ZBZ_SERIE, ZBZ_DTNFE, ZBZ_PRENF, ZBZ_CNPJ, ZBZ_FORNEC, 
			ZBZ_CNPJD, ZBZ_CLIENT,ZBZ_CHAVE,ZBZ_TPDOC, ZBZ_MODELO, ZBZ_MANIF, ZBZ.R_E_C_N_O_  
			%Exp:cCampos%
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
    		AND %Exp:cWhere%
	EndSql           
	
	DbSelectArea(cAliasZBZ)

	While !(cAliasZBZ)->(Eof()) 
	
		If AllTrim((cAliasZBZ)->ZBZ_MODELO) == "55"
		 	cPref    := "NF-e"                             
			cTAG     := "NFE"
		ElseIf AllTrim((cAliasZBZ)->ZBZ_MODELO) == "57"
		 	cPref    := "CT-e"                             
			cTAG     := "CTE"
		EndIf
			   
    	cMensagem := ""
    	cCodRet   := ""
    	xManif    := (cAliasZBZ)->ZBZ_MANIF //GETESB2
		lRet := U_XConsXml(cURL,(cAliasZBZ)->ZBZ_CHAVE,(cAliasZBZ)->ZBZ_MODELO,(cAliasZBZ)->ZBZ_PROT,@cMensagem,@cCodRet,.F.,,,@xManif)   //GETESB2
		cDtHrCOns := HfPutdt(1,dDatabase, Time(),"")
		cKey := (cAliasZBZ)->ZBZ_CHAVE
		//U_XMLSETCS((cAliasZBZ)->ZBZ_MODELO,cKey,cCodRet,cMensagem)
		//podemos infiar isto aqui ao inv้s deste processamento abaixo.
		If lRet
			If cCodRet == "101"
				lXmlCanc := .T. 
				cOcorr   := cMensagem 
				
				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				Reclock("ZBZ",.F.) 
				
				cOcorr += "Tipo de xml: " + cPref +CRLF
				cOcorr += "Chave      : " + cKey +CRLF
				cOcorr += "Observa็ใo : " + "Cancelamento do Xml de "+cPref+ " autorizado." +CRLF
				cOcorr += "Aviso      : " + "Cancele o documento de "+cPref+ " manualmente." +CRLF

	 	  		cOcorr:= GetInfoErro("3",cOcorr,ZBZ->ZBZ_MODELO)

			    If ZBZ->ZBZ_PRENF != "X"
			    	cLogProc += AllTrim(cKey)+" XML Cancelado. Cancele o documento de "+cPref+ " manualmente."+CRLF
			    EndIf
	 			
				Reclock("ZBZ",.F.) 
				ZBZ->ZBZ_PRENF  := "X"
				ZBZ->ZBZ_STATUS := "2" 
				ZBZ->ZBZ_MAIL   := "3"
				ZBZ->ZBZ_DTMAIL := cOcorr
				ZBZ->ZBZ_MANIF  := xManif //GETESB2
				MsUnLock()
	       		nNo++
				DbSelectArea(cAliasZBZ)


			Else
				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				Reclock("ZBZ",.F.) 
				ZBZ->ZBZ_DTHRCS:= cDtHrCOns
				If ZBZ->ZBZ_PRENF == "Z" .and. cCodRet == "100"
					ZBZ->ZBZ_PRENF  := "B"
					ZBZ->ZBZ_STATUS := "1"
					ZBZ->ZBZ_OBS    := cMensagem
					ZBZ->ZBZ_MAIL   := "0"
 					ZBZ->ZBZ_DTMAIL := ""
					ZBZ->ZBZ_MANIF  := xManif //GETESB2
		    	EndIf
				MsUnLock()	
				DbSelectArea(cAliasZBZ)		
				nOk++
			EndIf                          
	    Else

			If cCodRet == "101"
				lXmlCanc := .T. 
				cOcorr   := cMensagem 
				
				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				Reclock("ZBZ",.F.) 
				
				cOcorr += "Tipo de xml: " + cPref +CRLF
				cOcorr += "Chave      : " + cKey +CRLF
				cOcorr += "Observa็ใo : " + "Cancelamento do Xml de "+cPref+ " autorizado." +CRLF
				cOcorr += "Aviso      : " + "Cancele o documento de "+cPref+ " manualmente." +CRLF

	 	  		cOcorr:= GetInfoErro("3",cOcorr,ZBZ->ZBZ_MODELO)

			    If ZBZ->ZBZ_PRENF != "X"
			    	cLogProc += AllTrim(cKey)+" XML Cancelado. Cancele o documento de "+cPref+ " manualmente."+CRLF
			    EndIf
	 			
				Reclock("ZBZ",.F.) 
				ZBZ->ZBZ_PRENF  := "X"
				ZBZ->ZBZ_STATUS := "2" 
				ZBZ->ZBZ_MAIL   := "3"
				ZBZ->ZBZ_DTMAIL := cOcorr
				ZBZ->ZBZ_DTHRCS := cDtHrCOns
				ZBZ->ZBZ_MANIF  := xManif //GETESB2
				MsUnLock()
				nNo++
				DbSelectArea(cAliasZBZ)

			Else

				DbSelectArea("ZBZ")
				DbGoTo((cAliasZBZ)->R_E_C_N_O_)
				Reclock("ZBZ",.F.) 
				ZBZ->ZBZ_DTHRCS:= cDtHrCOns
				If ZBZ->ZBZ_PRENF == "Z" .and. cCodRet == "100"
					ZBZ->ZBZ_PRENF  := "B"
					ZBZ->ZBZ_STATUS := "1"
					ZBZ->ZBZ_OBS    := cMensagem
					ZBZ->ZBZ_MAIL   := "0"
 					ZBZ->ZBZ_DTMAIL := ""
		    	EndIf
				ZBZ->ZBZ_OBS   := ZBZ->ZBZ_OBS+CRLF+cMensagem
				ZBZ->ZBZ_MANIF := xManif //GETESB2
				MsUnLock()	
				DbSelectArea(cAliasZBZ)		
				If cCodRet == "100"
					nOk++
				Else
					nNo++
				Endif
			EndIf
			
		EndIf	    
		IncProc("Processando "+(cAliasZBZ)->ZBZ_SERIE+"/"+(cAliasZBZ)->ZBZ_NOTA)
		(cAliasZBZ)->(DbSkip())    	
	EndDo
    cLogProc += StrZero(nOk,6)+" Pr้-Nota(s) autorizada(s)."+CRLF		
    cLogProc += StrZero(nNo,6)+" Pr้-Nota(s) nใo autorizada(s)."+CRLF					              
DbSelectArea(cAliasZBZ)			             
DbCloseArea()
RestArea(aArea)

if .not. lAuto
	U_MyAviso("Aviso", cLogProc,{"OK"},3)
endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcMail  บ Autor ณ Roberto Souza        บ Data ณ  16/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri…o ณ Rotina que atualiza os status de e-mail na tabela ZBZ        บฑฑ
ฑฑฬฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤนฑฑ
ฑฑบSintaxe   ณ HfSetMail(aTo,cSubject,cMsg,cError,cAnexo,cAnexo2,cEmailDest)บฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                               Status                                    บฑฑ
ฑฑฬออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบE-Mail    ณ 0-Xml Ok (Nใo envia)                                         บฑฑ
ฑฑบ          ณ 1-Xml com erro (Pendente)                                    บฑฑ
ฑฑบ          ณ 2-Xml com erro (Enviado)                                     บฑฑ
ฑฑบ          ณ 3-Xml cancelado (Pendente)                                   บฑฑ
ฑฑบ          ณ 4-Xml cancelado (Enviado)                                    บฑฑ
ฑฑบ          ณ X-Falha ao enviar o e-mail (Erro)                            บฑฑ
ฑฑบ          ณ Y-Falha ao enviar o e-mail (Cancelamento)                    บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Importa XML                                                  บฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ProcMail(lAuto,lEnd,oProcess,cLogProc,nCount,lMostra)
Local aArea     := GetArea()
Local cQry      := ""
Local cWhere    := ""
Local cAliasZBZ := GetNextAlias()
Local nErr      := 0
Local nCan      := 0
Default cLogProc:= ""
Default lAuto   := .F.     
Default oProcess:= Nil
Default lEnd    := .F. 
Default nCount  := 0 
Default lMostra := .T.

ProcRegua(0)    
    cLogProc +="### Notifica็๕es por E-mail. ###"+CRLF

	cWhere := "%( ZBZ.ZBZ_MAIL IN ('1','3','X','Y') )%"				               

	BeginSql Alias cAliasZBZ
	
	SELECT	ZBZ_FILIAL, ZBZ_NOTA, ZBZ_SERIE, ZBZ_DTNFE, ZBZ_PRENF, ZBZ_CNPJ, ZBZ_FORNEC, 
			ZBZ_CNPJD, ZBZ_CLIENT,ZBZ_CHAVE, ZBZ_CODFOR, ZBZ_LOJFOR,ZBZ_TPDOC,ZBZ_MAIL,ZBZ_DTMAIL,ZBZ.R_E_C_N_O_ 
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
    		AND %Exp:cWhere%
	EndSql           

	DbSelectArea(cAliasZBZ)
	While !(cAliasZBZ)->(Eof())    
		DbSelectArea("ZBZ")
		DbGoTo((cAliasZBZ)->R_E_C_N_O_)

		nRet := NotificaMail(ZBZ->ZBZ_MAIL,ZBZ->ZBZ_DTMAIL,ZBZ->ZBZ_MODELO,ZBZ->ZBZ_CHAVE)			
	    cNewStat := ""
		If nRet == 0                         
			If ZBZ->ZBZ_MAIL $ "1|X" // Erros
				cNewStat := "2"
	   			nErr++
			ElseIf ZBZ->ZBZ_MAIL $ "3|Y" // Cancelamentos
				cNewStat := "4"
				nCan++
			EndIf
			
			RecLock("ZBZ",.F.)
			ZBZ->ZBZ_MAIL := cNewStat //Iif(ZBZ->ZBZ_MAIL=="1","2","4")
			MsUnlock()
			

		Else
			RecLock("ZBZ",.F.)
			ZBZ->ZBZ_MAIL := Iif(ZBZ->ZBZ_MAIL $ "1|X", "X", "Y")
			MsUnlock()		
		EndIf
		IncProc("Processando "+(cAliasZBZ)->ZBZ_CNPJ)
		(cAliasZBZ)->(DbSkip())    	
	EndDo
    cLogProc += StrZero(nErr,6)+" Xml(s) com erro  notificado(s)."+CRLF		
    cLogProc += StrZero(nCan,6)+" Xml(s) cancelado(s) notificado(s)."+CRLF					              
DbSelectArea(cAliasZBZ)			             
DbCloseArea()
RestArea(aArea)

If lMostra
	Aviso("Aviso", cLogProc,{"OK"},3)
EndIf
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAutoXml1  บ Autor ณ Roberto Souza      บ Data ณ  01/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Direciona os jobs automaticos                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function AutoXml1(nTipo,lAuto,lEnd,oProcess,cLogProc,nCount,cUrl)      
Default nTipo := 0 
Private x_Ped_Rec := GetNewPar("XM_PEDREC","N")
Private x_ZBB     := GetNewPar("XM_TABREC","")
Private x_Tip_Pre := GetNewPar("XM_TIP_PRE","1")
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6")) 
Private nFormCte  := Val(GetNewPar("XM_FORMCTE","6"))
Private cFilUsu   := GetNewPar("XM_FIL_USU","N")
cIdEnt    := U_GetIdEnt()

If nTipo == 1  
	EMailNFE(lAuto,@lEnd,oProcess,@cLogProc,@nCount)
ElseIf nTipo == 2
	ProcXml(lAuto,@lEnd,oProcess,@cLogProc,@nCount)
ElseIf nTipo == 3
	AtuXmlStat(lAuto,@lEnd,oProcess,@cLogProc,@nCount)
ElseIf nTipo == 4
	U_UPConsXML(lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)
ElseIf nTipo == 5
	ProcMail(lAuto,@lEnd,oProcess,@cLogProc,@nCount,.F.)	
ElseIf nTipo == 6
	U_HFXML6JB(lAuto,@lEnd,oProcess,@cLogProc,@nCount,.F.)	
EndIf

Return

      
   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXMLPRTdoc บ Autor ณ HF                 บ Data ณ  01/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Direciona a impressaod de documentos                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function XMLPRTdoc()
Local lOk        := .T.
Local lAuto      := .F.
Local cError     := ""
Local cWarning   := ""
Local oNota
//Local cIdEnt := ""
Local aIndArq   := {}
Local oDanfe
Local nHRes  := 0
Local nVRes  := 0
Local nDevice
Local cFilePrint := "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
Local oSetup
Local aDevice  := {}
Local cSession     := GetPrinterSession()
Local nRet := 0
Local cDestFile := GetSrvProfString("STARTPATH","")+"\pdf\"
Makedir(cDestFile)

If ZBZ->(FieldPos("ZBZ_STATUS"))>0 
	If ZBZ->ZBZ_STATUS <>"1" .Or. ZBZ->ZBZ_PRENF == "X"
		lOk:= .F.   
		MsgStop("Esta rotina nใo pode ser executada em um registro com erros na importa็ใo.")
	EndIf	
EndIf
                                                   
//If ZBZ->ZBZ_MODELO == "57"
//	MsgStop("Impressใo de documento de CT-e nใo disponํvel.")
//	lOk:= .F.   
//EndIf


If lOk
	oNota := XmlParser(ZBZ->ZBZ_XML, "_", @cError, @cWarning )

	If findfunction("U_DANFE_V")
		nRet := U_Danfe_v()
	EndIf
	
	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6
	
	                                                                        
	nLocal       	:= If(GetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
	nOrientation 	:= If(GetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	cDevice     	:= GetProfString(cSession,"PRINTTYPE","SPOOL",.T.)
	nPrintType      := aScan(aDevice,{|x| x == cDevice })
		
	lAdjustToLegacy := .F. // Inibe legado de resolu็ใo com a TMSPrinter
	oDanfe := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, cDestFile, .T.)
	// ----------------------------------------------
	// Cria e exibe tela de Setup Customizavel
	// OBS: Utilizar include "FWPrintSetup.ch"
	// ----------------------------------------------
	//nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	If ( !oDanfe:lInJob )
		oSetup := FWPrintSetup():New(nFlags, "DANFE")
		// ----------------------------------------------
		// Define saida
		// ----------------------------------------------
		oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
		oSetup:SetPropert(PD_ORIENTATION , nOrientation)
		oSetup:SetPropert(PD_DESTINATION , nLocal)
		oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
		oSetup:SetPropert(PD_PAPERSIZE   , DMPAPER_A4)
//		oSetup:AOPTIONS[6]:= "X:\spool\"
	EndIf
	// ----------------------------------------------
	// Pressionado botใo OK na tela de Setup
	// ----------------------------------------------
	If oSetup:Activate() == PD_OK // PD_OK =1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSalva os Parametros no Profile             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

        WriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
        WriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==1   ,"SPOOL"     ,"PDF"       ), .T. )
        WriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )

		If oSetup:GetProperty(PD_ORIENTATION) == 1
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณDanfe Retrato DANFEII.PRW                  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ZBZ->ZBZ_MODELO == "57"
				U_Dacte_X(lAuto,oNota,cIdEnt,,,oDanfe,oSetup,cFilePrint)
			Else
				U_Danfe_X(lAuto,oNota,cIdEnt,,,oDanfe,oSetup,cFilePrint)
			Endif
		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณDanfe Paisagem DANFEIII.PRW                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ZBZ->ZBZ_MODELO == "57"
				U_Dacte_X(lAuto,oNota,cIdEnt,,,oDanfe,oSetup,cFilePrint)
			Else
				U_DANFE_XIII(lAuto,oNota,cIdEnt,,,oDanfe,oSetup,cFilePrint)
				//U_Danfe_X(lAuto,oNota,cIdEnt,,,oDanfe,oSetup,cFilePrint)
			EndIf
		EndIf
	Else
		MsgInfo("Relat๓rio cancelado pelo usuแrio.")
		Return
	Endif
		
	oDanfe := Nil
	oSetup := Nil
	

EndIf
Return





Static Function RetTpNf(cModelo,oXml)
Local cRet    := "N"                
Local Nx      := 0
Local cCfopD  := GetNewPar("XM_CFDEVOL","") // "5916"          
Local cCfopB  := GetNewPar("XM_CFBENEF","") 
Local lDevol  := .F.
Local lBenef  := .F.  
Local lNormal := .F. 
Local nLenProd:= 0

Private oDet  

IF ExistBlock("HFXMLTP1")
	cRet := ExecBlock("HFXMLTP1",.F.,.F.,{cModelo,oXml})
Else
	If cModelo=="55"
		oDet     := oXml:_NFEPROC:_NFE:_INFNFE:_DET            
		oDet     := IIf(ValType(oDet)=="O",{oDet},oDet)
		nLenProd := Len(oDet) 
		
		For Nx := 1 To nLenProd
			cCfopIt := AllTrim(oDet[nx]:_Prod:_CFOP:TEXT)
			If cCfopIt $ cCfopD
				lDevol := .T.
			ElseIf cCfopIt $ cCfopB			
		   		lBenef := .T. 
		 	Else
		 		lNormal := .T. 	
			EndIf	
        Next
		
		If lNormal
			cRet := "N"
		ElseIf lDevol 
			cRet := "D" 
		ElseIf lBenef 
			cRet := "B" 			
	    EndIf   
	    
	ElseIf cModelo=="57"
    	//Tratamento para CT-e
    	cRet    := "N"   
    EndIf
EndIf    
            
Return(cRet)




User Function www()
Local oDlg
Local aProdNo := {}
Local aProdOk := {}
Local Nx := 0
Private oFont01:= TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
             
aadd(aProdOk,{"000001","Produto 1"})
aadd(aProdOk,{"000003","Produto 3"})
aadd(aProdOk,{"000004","Produto 4"})
aadd(aProdOk,{"000006","Produto 6"})

aadd(aProdNo,{"000002","Produto 2"})
aadd(aProdNo,{"000005","Produto 5"})
aadd(aProdNo,{"000007","Produto 7"})
aadd(aProdNo,{"000008","Produto 8"})

	    
	cInfo := 	"A Gera็ใo da Pre-Nota serแ Interrompida ... "+CRLF
	cInfo += "Itens OK."+CRLF
	For Nx := 1 to Len(aProdOk)
		cInfo += aProdOk[Nx][1]+" - "+aProdOk[Nx][2]+CRLF
	Next

	cInfo += "Itens com problemas."+CRLF
	For Nx := 1 to Len(aProdNo)
		cInfo += aProdNo[Nx][1]+" - "+aProdNo[Nx][2]+CRLF
	Next	    
	
	DEFINE MSDIALOG oDlg TITLE "Avisos - Gera็ใo Pr้-Nota" FROM 000,000 TO 500,500 PIXEL

	@ 010,010 Say "Produtos Encontrados:"     PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
	@ 020,010 LISTBOX oLbx1 FIELDS HEADER ;
	   "Produto", "Descri็ใo" ;
	   SIZE 230,095 OF oDlg PIXEL
		                                      
	oLbx1:SetArray( aProdOk )
	oLbx1:bLine := {|| {aProdOk[oLbx1:nAt,1],;
	     	            aProdOk[oLbx1:nAt,2]}}
	     	            
	@ 125,010 Say "Produtos Nใo Encontrados:" PIXEL OF oDlg COLOR CLR_RED FONT oFont01
	@ 135,010 LISTBOX oLbx2 FIELDS HEADER ;
	   "Produto", "Descri็ใo" ;
	   SIZE 230,095 OF oDlg PIXEL
		                                      
	oLbx2:SetArray( aProdOk )
	oLbx2:bLine := {|| {aProdNo[oLbx2:nAt,1],;
	     	            aProdNo[oLbx2:nAt,2]}}	     	            

	@ 023.2,040 BUTTON "Detalhe" SIZE 35,15 OF oDlg Action U_MyAviso("Aviso","Existem itens que nใo encontraram amarra็ใo."+CRLF+cInfo,{"OK"},3)	
	@ 023.2,050 BUTTON "OK" SIZE 35,15 OF oDlg Action oDlg:End()
  
		ACTIVATE MSDIALOG oDlg CENTER
Return	



User Function wwy()
Local lRet  := .F.           
Local aDados:= {}                                
Local nLinha:= 1
Local oItem := nil
Local cTblCad:= ""
Local cTblDP := ""    
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
cCnpjEmi := "00000000000000"
cCodEmit := "XXXXXX"
cLojaEmit:= "WW"
cNomEmit := Replicate("A",60)    
cCodProd := "PAOOEEEIRI001"
cDescProd:= "MESA REDONDA TIPO MOGNO LUSTRADO"

cCodProdP  := Space(15)
cDescProdP := Space(60)
      
cUrlP:="http://www.hfbr.com.br/produtos/importa_xml/index.htm"
cHtmlP := HTTPGet ( cUrlP,,60,)


	DEFINE MSDIALOG oDlgUpd TITLE 'HTTPGET' FROM 00,00 TO 300,400 PIXEL
//    @ 010,010 Say cHtmlP PIXEL OF oDlgUpd
	TSay():New(001,001,{|| cHtmlP },oDlgUpd,,,,,,.T.,,,340,200,,,,.T.,,.T.)
	TButton():New( 220,270, '&Cancelar', oDlgUpd,;
					{||  oDlgUpd:End()},;
					075,015,,,,.T.,,,,,,)
	ACTIVATE MSDIALOG oDlgUpd CENTERED
	

DEFINE MSDIALOG oDlg TITLE "Relacionamento De/Para" FROM 0,0 TO 280,552 OF oDlg PIXEL

@ 06,06 TO 070,271 LABEL "Dados do Fornecedor" OF oDlg PIXEL

@ 15,015 SAY   "Codigo" SIZE 45,8 PIXEL OF oDlg       
@ 25,015 MSGET cCodEmit PICTURE "@!" SIZE 30,08 PIXEL OF oDlg WHEN .F.

@ 15,050 SAY "Loja"  SIZE 45,8 PIXEL OF oDlg
@ 25,050 MSGET cLojaEmit PICTURE "@!" SIZE 20,08 PIXEL OF oDlg WHEN .F.

@ 15,075 SAY "CNPJ"   SIZE 45,8 PIXEL OF oDlg
@ 25,075 MSGET cCnpjEmi PICTURE "@ 99.999.999/9999-99" SIZE 50,08 PIXEL OF oDlg WHEN .F.

@ 15,130 SAY   "Nome" SIZE 45,8 PIXEL OF oDlg       
@ 25,130 MSGET cNomEmit PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F.

@ 45,015 SAY   "Cod Produto" SIZE 45,8 PIXEL OF oDlg       
@ 55,015 MSGET cCodProd PICTURE "@!" SIZE 50,08 PIXEL OF oDlg WHEN .F.

@ 45,080 SAY   "Descri็ใo Produto" SIZE 45,8 PIXEL OF oDlg       
@ 55,080 MSGET cDescProd PICTURE "@!" SIZE 130,08 PIXEL OF oDlg WHEN .F.



@ 76,06 TO 116,271 LABEL "Produto pr๓prio" OF oDlg PIXEL

@ 085,015 SAY   "Cod Produto" SIZE 45,8 PIXEL OF oDlg       
@ 095,015 MSGET OCodProdP VAR cCodProdP F3 "SB1" PICTURE "@!" SIZE 50,08 PIXEL OF oDlg

@ 085,080 SAY   "Descri็ใo Produto" SIZE 45,8 PIXEL OF oDlg       
@ 095,080 MSGET cDescProdP PICTURE "@!" SIZE 130,08 PIXEL OF oDlg


@ 125,195 BUTTON "Cancelar" SIZE 35,12 PIXEL OF oDlg
@ 125,235 BUTTON "Salvar" SIZE 35,12 PIXEL OF  oDlg 

ACTIVATE MSDIALOG oDlg CENTERED

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02V  บ Autor ณ Roberto Souza      บ Data ณ  16/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza o Documento fiscal, caso haja.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02V()
Local oDlgKey, oBtnOut, oBtnCon
Local cIdEnt    := ""
Local cChaveXml := AllTrim(ZBZ->ZBZ_CHAVE)
Local cModelo   := ZBZ->ZBZ_MODELO
Local cProtocolo:= ZBZ->ZBZ_PROT
Local cMensagem := ""
Local aArea     := GetArea()
Local lRet      := .T.
Local cPref     := "NF-e"                             
Local cTAG      := "NFE"
Local lSeek     := .F.
If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf 

DbSelectArea("SF1")   
DbSetOrder(8)
lSeek := DbSeek(xFilial("SF1")+cChaveXml) 
If lSeek
	nReg := SF1->(Recno())
	cCadastro:= "Visualizar Documento Entrada"
	A103NFiscal("SF1",nReg,2,.F.,.F.)
Else
	U_MyAviso("Aten็ใo","Documento de Entrada nใo localizado.",{"OK"},2)
EndIf
                      
RestArea(aArea)                     
Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02X  บ Autor ณ Roberto Souza      บ Data ณ  22/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Consulta Chave e atualiza o Status do XML dos Fornecedores บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02X()
Local oDlgKey, oBtnOut, oBtnCon
Local cIdEnt    := ""
Local cChaveXml := AllTrim(ZBZ->ZBZ_CHAVE)
Local cModelo   := ZBZ->ZBZ_MODELO
Local cProtocolo:= ZBZ->ZBZ_PROT
Local cMensagem := ""
Local aArea     := GetArea()
Local lRet      := .T.
Local cPref     := "NF-e"                             
Local cTAG      := "NFE"
Local cCodRet   := ""
Local xManif    := "" //GETESB2
Default cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf
/*
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
	RpcSetType(3)
	DbSelectArea("ZBZ")
	DbGoTo(256)
*/
	
	DEFINE MSDIALOG oDlgKey TITLE "Consulta "+cPref FROM 0,0 TO 150,305 PIXEL OF GetWndDefault()
	
	@ 12,008 SAY "Informe a Chave de acesso do xml de "+cPref PIXEL OF oDlgKey
	@ 20,008 MSGET cChaveXml SIZE 140,10 PIXEL OF oDlgKey READONLY
	
	@ 46,035 BUTTON oBtnCon PROMPT "&Consultar" SIZE 38,11 PIXEL ;
	ACTION (lValidado := U_XConsXml(cURL,cChaveXml,cModelo,cProtocolo,@cMensagem,@cCodRet,.T.,,,@xManif),;
		,oDlgKey:End())
	@ 46,077 BUTTON oBtnOut PROMPT "&Sair" SIZE 38,11 PIXEL ACTION oDlgKey:End()
	
	ACTIVATE DIALOG oDlgKey CENTERED
    
	If !Empty(cCodRet)
		U_XMLSETCS(cModelo,cChaveXml,cCodRet,cMensagem,xManif) 
    EndIf
Return


User Function XMLSETCS(cModelo,cChaveXml,cCodRet,cMensagem,xManif)
Local lRet := .T.
Local cPref:= ""
If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf

DbSelectArea("ZBZ")
DbSetOrder(3) 
If DbSeek(alltrim(cChaveXml)) .And. !ZBZ->ZBZ_PRENF $ "X|F"

	cDtHrCOns := HfPutdt(1,dDatabase, Time(),"")
	RecLock("ZBZ")

	If ZBZ->(FieldPos("ZBZ_DTHRUC"))>0
   		ZBZ->ZBZ_DTHRUC:= cDtHrCOns
	Else
   		ZBZ->ZBZ_DTHRCS:= cDtHrCOns
	EndIf
	if FieldPos("ZBZ_MANIF") > 0  .And. .Not. Empty(xManif) //GETESB2
		ZBZ->ZBZ_MANIF := xManif
	endif
	
	If cCodRet == "101" // Cancelado

		cOcorr   := cMensagem
		cMsgCanc := "Tipo de xml: " + cPref +CRLF
		cMsgCanc += "Chave      : " + cChaveXml +CRLF
		cMsgCanc += "Observa็ใo : " + "Cancelamento do Xml de "+cPref+ " autorizado." +CRLF
		cMsgCanc += "Aviso      : " + "Cancele o documento de "+cPref+ " manualmente." +CRLF

    	cStatusXml := "X"  
    	cStatReg   := "2"
    	cStatMail  := "3"          
    	cInfoErro  := GetInfoErro(cStatMail,cMsgCanc,cModelo)

	ElseIf cCodRet == "100" // Autorizado

		If ZBZ->ZBZ_PRENF == "Z"
			cStatusXml := "B"  
	    	cStatReg   := "1"
	    	cStatMail  := "0"          
	    	cInfoErro  := ""
		Else
			cStatusXml := ZBZ->ZBZ_PRENF  
	    	cStatReg   := ZBZ->ZBZ_STATUS
	    	cStatMail  := ZBZ->ZBZ_MAIL          
	    	cInfoErro  := ZBZ->ZBZ_DTMAIL
    	EndIf
    Else
		lConsErr := .T.
		cOcorr   := cMensagem
		cMsgErr := "Tipo de xml: " + cPref +CRLF
		cMsgErr += "Chave      : " + cChaveXml +CRLF
		cMsgErr += "Observa็ใo : " + "Erro na consulta do Xml de "+cPref+ "." +CRLF
		cMsgErr += "Aviso      : " + "Consulte o Xml manualmente pela rotina padrใo ou aguarde at้ a proxima consulta automแtica." +CRLF					                  

		cStatusXml := "Z"  
    	cStatReg   := "2"  
    	cStatMail  := "0"				  
    		cInfoErro  := cMsgErr		    
	EndIf		    		

	ZBZ->ZBZ_PRENF  := cStatusXml
	ZBZ->ZBZ_STATUS := cStatReg
	ZBZ->ZBZ_OBS    := cMensagem

	ZBZ->ZBZ_MAIL   := cStatMail       
 	ZBZ->ZBZ_DTMAIL := cInfoErro

	MsUnlock()
EndIf	
Return



Static Function ConsNFeChave(cChaveNFe)

Local cMensagem:= ""
Local oWS
Default cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

lValidado := U_XConsXml(cURL,cChaveXml,cModelo,cProtocolo,@cMensagem,@cCodRet,AllTrim(SuperGetMv("MV_MOSTRAA")) == "S")


oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT    := cIdEnt
ows:cCHVNFE		 := AllTrim(cChaveNFe)
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	cMensagem := ""
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
		cMensagem += "Versใo"+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
	EndIf
	cMensagem += "Ambiente"+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produ็ใo","Homologa็ใo")+CRLF //###
	cMensagem += "Cod Ret"+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
	cMensagem += "Mensagem"+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
		cMensagem += "Protocolo"+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF	
	EndIf  
    If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cDIGVAL)
		cMensagem += "Dํgito"+": "+oWs:oWSCONSULTACHAVENFERESULT:cDIGVAL+CRLF  
	EndIf
	Aviso("Importa XMl",cMensagem,{"OK"},3)
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
EndIf

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02M  บ Autor ณ Roberto Souza      บ Data ณ  13/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02M()
Local aArea  := GetArea()
Local lRet   := .T.
Local aRadio := {}
Local nRadio := 1

/*
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
	RpcSetType(3)
	DbSelectArea("ZBZ")
	DbGoTo(10)
*/
	
aAdd( aRadio, "Tipo de Documento" )
//aAdd( aRadio, "Desabilitado" )
//aAdd( aRadio, "Desabilitado" )
                         

 	DEFINE MSDIALOG oDlgUpd TITLE 'Altera็ใo XML' FROM 00,00 TO 140,250 PIXEL
    
	@ 006,006 TO 060,080 LABEL "" OF oDlgUpd PIXEL
	@ 010,010 RADIO oRadio VAR nRadio ITEMS aRadio[1] SIZE 65,8 PIXEL OF oDlgUpd 
	@ 006,085 BUTTON "Ok" SIZE 35,15 PIXEL OF oDlgUpd Action (oDlgUpd:End(),EdtXML(nRadio))
	@ 026,085 BUTTON "Cancelar" SIZE 35,15 PIXEL OF oDlgUpd Action oDlgUpd:End()

	ACTIVATE MSDIALOG oDlgUpd CENTERED


Return


Static Function EdtXML(nTipo)
Local lRet       := .F.   
Local oDlg
Local aObjetos   := Array(10)
Local aCombo1    := {	"N=Normal",;	
						"D=Devolucao",;	
						"B=Beneficiamento",;	
						"I=Compl.  ICMS",;	
						"P=Compl.  IPI",;	
						"C=Compl. Preco/Frete"}
Local aCombo1A    := {	"Normal",;	
						"Devolucao",;	
						"Beneficiamento",;	
						"Compl.  ICMS",;	
						"Compl.  IPI",;	
						"Compl. Preco/Frete"}						
						
Local aCombo2       := {"Nao","Sim"}
Local lRodape       := .T. 
Local nTamProd      := 15// TAMSX3("B1_COD")[1] 
Local oGet2
Private nOpca       := 0 
Private nOpcb       := 0
Private lPreNota 	:= .F.
Private lPedido 	:= .F.
Private lPCNFE     	:= .F.
Private cUfOrig		:= Space(2)//Posicione("SA2",1,xFilial("SA2")+aHead[06][02]+aHead[07][02],"A2_EST")
Private cTipo		:= ZBZ->ZBZ_TPDOC
Private cFormul		:= "N"
Private cNFiscal	:= ZBZ->ZBZ_NOTA
Private cSerie		:= ZBZ->ZBZ_SERIE
Private dDEmissao	:= ZBZ->ZBZ_DTNFE
Private cA100For	:= ZBZ->ZBZ_CODFOR
Private cLoja		:= ZBZ->ZBZ_LOJFOR
Private cEspecie	:= U_SpecXml(ZBZ->ZBZ_MODELO)
Private cNome       := Space(30) 
Private cCnpjFor   	:= ZBZ->ZBZ_CNPJ 
Private cCnpj    	:= ZBZ->ZBZ_CNPJ
Private cCondicao	:= ""
Private cForAntNFE	:= cA100For+cLoja
Private n			:= 1
Private aCols		:= {}
Private aHeader		:= {} 
Private lVisual     := .T. 
Private aButtons    := {}
Private aPosObj     := {}
Private aHead1      := {}      
Private nI

Private nUsado      := 0
Private lRefresh    := .T.  
Private aFields     := {}   
Private aComp       := {}
Private aGets       := {} 
Private nVar        := {}
Private cTextGet    := "" 
Private aColsSDE    := {}
Private lWhen       := .T.
Private lEditCab    := .F.  
Private cSayForn    := IIf(cTipo$"DB",RetTitle("F2_CLIENTE"),RetTitle("F1_FORNECE"))
Private nCabMod     := 2 
Private aButtons    := {}
Private aItens      := {}  
Private aHead       := {}
                       

Private aRotina := {{"Pesquisar" , "AxPesqui", 0, 1},;
                    {"Visualizar", "AxVisual", 0, 2},;
                    {"Incluir"   , "AxInclui", 0, 3},;
                    {"Alterar"   , "AxAltera", 0, 4},;
                    {"Excluir"   , "AxDeleta", 0, 5}}

aHeader := aClone(aHead1)  
  
If cTipo $ "D|B"
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+cA100For+cLoja) 
Else
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+cA100For+cLoja) 
EndIf		   
Private aPos       := {15, 1, 70, 315}	 
		   
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Altera็ใo - XML") FROM 0,0 TO 180,720  PIXEL STYLE DS_MODALFRAME STATUS

	@ 15,05 TO 70,355 LABEL "" OF oDlg PIXEL
	//Linha 1
	@ 20,015 SAY RetTitle("F1_TIPO") SIZE 35,09 OF oDlg PIXEL 
	@ 27,015 MSCOMBOBOX aObjetos[1] VAR cTipo ITEMS aCombo1 SIZE 50,90 OF oDlg PIXEL WHEN lWhen ON CHANGE SetF3But(cTipo,oForSa1,oForSa2,.T.,oForNome)
	
	@ 20,075 SAY RetTitle("F1_FORMUL") SIZE 52,09 Of oDlg PIXEL 
	@ 27,075 MSCOMBOBOX aObjetos[2] VAR cFormul ITEMS aCombo2 SIZE 25,50 ;
		OF oDlg PIXEL   WHEN .F.                          
		
	@ 20,135 SAY RetTitle("F1_SERIE") SIZE 23,09 Of oDlg PIXEL
	@ 27,135 MSGET aObjetos[4] VAR cSerie  PICTURE PesqPict("SF1","F1_SERIE") ;
	    SIZE 18,09 OF oDlg PIXEL WHEN .F.
	
	@ 20,195 SAY RetTitle("F1_DOC") SIZE 45,09 Of oDlg PIXEL
	@ 27,195 MSGET aObjetos[3] VAR cNFiscal PICTURE PesqPict("SF1","F1_DOC") ;
		SIZE 34,09 OF oDlg PIXEL WHEN .F.
	
	@ 20,255 SAY RetTitle("F1_EMISSAO") OF oDlg PIXEL SIZE 35,09
	@ 27,255 MSGET aObjetos[5] VAR dDEmissao PICTURE PesqPict("SF1","F1_EMISSAO") OF oDlg PIXEL SIZE 45 ,9 HASBUTTON WHEN .F.

	@ 20,315 SAY RetTitle("F1_ESPECIE") Of oDlg PIXEL SIZE 63,09
	@ 27,315 MSGET aObjetos[9] VAR cEspecie PICTURE PesqPict("SF1","F1_ESPECIE") ;
			OF oDlg PIXEL SIZE 30,09 WHEN .F.


	
	@ 45,015 SAY aObjetos[6] VAR cSayForn Of oDlg PIXEL SIZE 43,09
	@ 52,015 MSGET oForSa1 VAR cA100For PICTURE PesqPict("SF2","F2_CLIENTE") F3 "SA1PRN";
		OF oDlg PIXEL SIZE 45,09 HASBUTTON VALID U_FillCab("SA1")
	
	@ 52,015 MSGET oForSa2 VAR cA100For PICTURE PesqPict("SF1","F1_FORNECE") F3 "SA2PRN";
		OF oDlg PIXEL SIZE 45,09 HASBUTTON VALID U_FillCab("SA2")
		
	
	@ 45,075 SAY aObjetos[6] VAR "Loja" Of oDlg PIXEL SIZE 43,09	
	@ 52,075 MSGET aObjetos[8] VAR cLoja PICTURE PesqPict("SF1","F1_LOJA") ;
		OF oDlg PIXEL SIZE 15,09 HASBUTTON WHEN lWhen
	
	@ 45,135 SAY OemToAnsi("Nome") Of oDlg PIXEL SIZE 63 ,9 // 
	@ 52,135 MSGET oForNome VAR cNome PICTURE "@!" OF oDlg PIXEL SIZE 120,9 HASBUTTON READONLY

	@ 45,255 SAY OemToAnsi("CNPJ") Of oDlg PIXEL SIZE 63 ,9 // 
	@ 52,255 MSGET oCnpj VAR cCnpjFor PICTURE "@R 99.999.999/9999-99" OF oDlg PIXEL SIZE 60,9 HASBUTTON READONLY

	
	@ 45,315 SAY OemToAnsi("UF.Origem") Of oDlg PIXEL SIZE 63 ,9 // 
	@ 52,315 MSGET cUfOrig PICTURE "@!" F3 "12"  OF oDlg PIXEL SIZE 20,9 HASBUTTON READONLY
 
	SetF3But(cTipo,oForSa1,oForSa2,.F.,oForNome)	
 
	@ 073,280 BUTTON "Ok"       SIZE 35,15 PIXEL OF oDlg Action (Iif(EditOK(nTipo,cA100For,cLoja,cCnpjFor), (EdtXMLOk(nTipo),oDlg:End()),.F.))
	@ 073,320 BUTTON "Cancelar" SIZE 35,15 PIXEL OF oDlg Action (oDlg:End())
							
ACTIVATE MSDIALOG oDlg CENTERED // ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})



Return(lRet)


Static Function SetF3But(cTipo,oForSa1,oForSa2,lEmpty,oForNome)
Default lEmpty := .T.      

If cTipo $ "D|B"
	cSayForn    := RetTitle("F2_CLIENTE")
	cNome       := SA1->A1_NOME
	cUfOrig     := SA1->A1_EST
	oForSa2:Hide() 
	oForSa1:Show()

Else
	cSayForn    := RetTitle("F1_FORNECE")
	cNome       := SA2->A2_NOME			
	cUfOrig     := SA2->A2_EST
	oForSa1:Hide() 
	oForSa2:Show()		    
EndIf

If lEmpty
	cA100For	:= Space(6)
	cLoja		:= Space(2)
	cNome       := Space(30) 
	cUfOrig     := Space(2)
EndIf
Return         
 



Static Function EditOK(nTipo,cA100For,cLoja,cCnpjFor)
Local lRet := .T.
Local cMsgAviso := "" 
Local cCanEdit  := "B"
Local cFilial   := ZBZ->ZBZ_FILIAL 
Local lSharedA1 := U_IsShared("SA1")
Local lSharedA2 := U_IsShared("SA2")


If nTipo == 1 //Tipo-Cliente - Fornecedor
	If ZBZ->ZBZ_PRENF $ cCanEdit
		If cTipo $ "D|B"
			if lSharedA1
				cFilial := xFilial("SA1")
			endif
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(cFilial+cA100For+cLoja)  //ZBZ->ZBZ_FILIAL ou xFilial("SA1")
				If cCnpjFor <> SA1->A1_CGC
			   		cMsgAviso += "CNPJ do cliente selecionado nใo corresponde ao emissor do Xml."+CRLF	
				EndIf 
			Else
				cMsgAviso += "Selecione um fornecedor/cliente vแlido."+CRLF	
			EndIf
		Else
			if lSharedA2
				cFilial := xFilial("SA2")
			endif
			DbSelectArea("SA2")
			DbSetOrder(1)
			If DbSeek(cFilial+cA100For+cLoja)  //ZBZ->ZBZ_FILIAL ou xFilial("SA2")
				If cCnpjFor <> SA2->A2_CGC
			   		cMsgAviso += "CNPJ do fornecedor selecionado nใo corresponde ao emissor do Xml."+CRLF	
				EndIf 
			Else
				cMsgAviso += "Selecione um fornecedor/cliente vแlido."+CRLF	
			EndIf
		EndIf		   
		
		
		If Empty(cA100For)
			lRet := .F.      
			cMsgAviso += "Selecione um fornecedor/cliente vแlido."+CRLF
		EndIf
		If Empty(cLoja)
			lRet := .F.
			cMsgAviso += "Selecione uma loja vแlida."+CRLF
		EndIf 
	Else 
		cMsgAviso += "Registros com status "+ZBZ->ZBZ_PRENF+" nใo podem sofrer este tipo de altera็ใo."+CRLF 
	EndIf
 
EndIf		 
If !Empty(cMsgAviso)
	U_MyAviso("Aviso",cMsgAviso,{"OK"},3)
EndIf               
Return(lRet)
 





Static Function EdtXMLOk(nTipo)  
Local lRet := .T.
Local cMsgAviso := ""

If AllTrim(cTipo) $ "D|B"
	cNomEmit :=  Posicione("SA1",1,xFilial("SA1")+cA100For+cLoja,"A1_NOME")
Else
	cNomEmit := Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_NOME")
EndIf

	RecLock("ZBZ",.F.)
	ZBZ->ZBZ_CODFOR := cA100For  
	ZBZ->ZBZ_LOJFOR := cLoja
	ZBZ->ZBZ_FORNEC := cNomEmit
	ZBZ->ZBZ_TPDOC  := cTipo	
	MsUnlock()

	U_MyAviso("Aviso","Altera็ใo efetuada com sucesso.",{"OK"},2)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HFXML02Z บ Autor ณ Eneovaldo Roveri Jrบ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclusใo de XML s๓mente para Fornecedores                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02Z()
Local aArea := GetArea()
Local lRet  := .T.
Local lSeek := .F.
Local cNotaSeek := ""
Local cAliasZBZ := "ZBZ"
Local cTipoNf := Iif(Empty((cAliasZBZ)->ZBZ_TPDOC),"N",(cAliasZBZ)->ZBZ_TPDOC)
Local cCodFor := (cAliasZBZ)->ZBZ_CODFOR+(cAliasZBZ)->ZBZ_LOJFOR
Local cStat   := ""
Private nFormNfe := Val(GetNewPar("XM_FORMNFE","6"))

If ZBZ_PRENF == 'B' .AND. ZBZ_PROTC == Space(15)
	cStat := "XML Importado"
ElseIf ZBZ_PRENF == 'A' .AND. ZBZ_PROTC == Space(15)
	cStat := "Aviso Recbto Carga"
ElseIf ZBZ_PRENF == 'S' .AND. ZBZ_PROTC == Space(15)
	cStat := "Pr้-Nota a Classificar"
ElseIf ZBZ_PRENF == 'N' .AND. ZBZ_PROTC == Space(15)
	cStat := "Pr้-Nota Classificada"
ElseIf ZBZ_PRENF == 'F' .AND. ZBZ_PROTC == Space(15)
	cStat := "Falha de Importa็ใo"
ElseIf ZBZ_PROTC <> ''
	cStat := "Xml Cancelado pelo Emissor"
ElseIf ZBZ_PRENF == 'Z' .AND. ZBZ_PROTC == Space(15)
	cStat := "Falha na Consulta"
Else
	cStat := "Falha na Consulta"
Endif

//Checar se tem Pr้-nota
DbSelectArea("SF1")
lSeek := .F.
cNotaSeek :=  Iif(nFormNfe > 0,StrZero(Val((cAliasZBZ)->ZBZ_NOTA),nFormNfe),AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA))))
lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
        
If !lSeek
	cNotaSeek := AllTrim(Str(Val((cAliasZBZ)->ZBZ_NOTA)))
    lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
EndIf

If !lSeek
	cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),6)
    lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
EndIf
 
If !lSeek
	cNotaSeek :=  StrZero(Val((cAliasZBZ)->ZBZ_NOTA),9)
    lSeek := DbSeek((cAliasZBZ)->ZBZ_FILIAL+Padr(cNotaSeek,9)+(cAliasZBZ)->ZBZ_SERIE+cCodFor+cTipoNf)
EndIf

DbSelectArea("ZBZ")
If lSeek
	RecLock("ZBZ",.F.)
	ZBZ->ZBZ_PRENF := Iif(Empty(SF1->F1_STATUS),'S','N')									
	MsUnlock()
ElseiF (cAliasZBZ)->ZBZ_PRENF $ "S|N"
	RecLock("ZBZ",.F.)
	ZBZ->ZBZ_PRENF := 'B'
	MsUnlock()     
EndIf	

If ZBZ->ZBZ_PRENF == 'B' .AND. ZBZ->ZBZ_PROTC == Space(15)
	cStat := "XML Importado"
ElseIf ZBZ->ZBZ_PRENF == 'A' .AND. ZBZ->ZBZ_PROTC == Space(15)
	cStat := "Aviso Recbto Carga"
	lSeek := .T.
ElseIf ZBZ->ZBZ_PRENF == 'S' .AND. ZBZ->ZBZ_PROTC == Space(15)
	cStat := "Pr้-Nota a Classificar"
ElseIf ZBZ->ZBZ_PRENF == 'N' .AND. ZBZ->ZBZ_PROTC == Space(15)
	cStat := "Pr้-Nota Classificada"
ElseIf ZBZ->ZBZ_PRENF == 'F' .AND. ZBZ->ZBZ_PROTC == Space(15)
	cStat := "Falha de Importa็ใo"
ElseIf ZBZ->ZBZ_PROTC <> ''
	cStat := "Xml Cancelado pelo Emissor"
ElseIf ZBZ->ZBZ_PRENF == 'Z' .AND. ZBZ->ZBZ_PROTC == Space(15)
	cStat := "Falha na Consulta"
Else
	cStat := "Falha na Consulta"
Endif

If lSeek
	U_MyAviso("Aten็ใo","Status do XML ้ "+cStat+". Desfa็a a rotina para poder excluir",{"OK"},3)
ElseiF ZBZ->ZBZ_PRENF == 'B'
	If U_MyAviso("Pergunta","Deseja Excluir o XML "+AllTrim(ZBZ->ZBZ_CHAVE)+" ?",{"SIM","NรO"},3) == 1
		DbSelectArea("ZBZ")
		RecLock("ZBZ",.F.)
		ZBZ->( dbDelete() )
		MsUnlock()
	EndIf
Else
	If U_MyAviso("Pergunta","Status do XML ้ "+cStat+". Deseja Excluir o XML "+AllTrim(ZBZ->ZBZ_CHAVE)+" ?",{"SIM","NรO"},3) == 1
		DbSelectArea("ZBZ")
		RecLock("ZBZ",.F.)
		ZBZ->( dbDelete() )
		MsUnlock()
	EndIf
Endif

RestArea( aArea )
Return( NIL )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldXmlOK  บ Autor ณ Roberto Souza      บ Data ณ  11/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Coloca o XML em uma estrutura padrใo para leitura.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function VldXmlOK(nModo,cFile,cXml,cOcorr,lInvalid,cModelo,lCanc,oXml)
Local lRet   := .T.
Local nAt1   := nAt2 := nAt3 := nAt4 := 0
Local cNfe   := ""
Local cProt  := ""
Local cInfo  := "" 
Local cError := ""
Local cWarning := ""
Private oParse := Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa verifica็ใo no modo clแssico                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nModo== 1
                
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIdentifica o modelo do XML                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If "<NFE" $ Upper(cXml) .And. ('VERSAO="1.10"' $ Upper(cXml) .Or. "VERSAO='1.10'" $ Upper(cXml))
		cModelo := "00"
		lInvalid := .T.
		lRet := .F.
		cOcorr := "Modelo Invแlido ou nใo homologado."
		Return(lRet)
	EndIf
	
	If "<NFE" $ Upper(cXml) .Or. "<PROCCANCNFE" $ Upper(cXml)
		cModelo := "55"
	ElseIf "<CTE" $ Upper(cXml) .Or. "<PROCCANCCTE" $ Upper(cXml)
		cModelo := "57"	
	Else
		cModelo := "00"
		lInvalid := .T.
		lRet := .F.
		cOcorr := "Modelo Invแlido ou nใo homologado."
		Return(lRet)
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica de acordo com o modelo                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cModelo == "55"
		If !"PROCCANCNFE" $ Upper(cXml)
			
			nAt1:= At('<NFE ',Upper(cXml))
			nAt2:= At('</NFE>',Upper(cXml))+ 6
			//Corpo da Nfe
			If nAt1 <=0
				nAt1:= At('<NFE>',Upper(cXml))
			EndIf 	
			If nAt1 > 0 .And. nAt2 > 6
				cNfe := Substr(cXml,nAt1,nAt2-nAt1)
			Else
				cOcorr := "Nf-e inconsistente."	
				lret := .F.
				lInvalid := .T.
			EndIf	
			nAt3:= At('<PROTNFE ',Upper(cXml))
			nAt4:= At('</PROTNFE>',Upper(cXml))+ 10
			//Protocolo	
			If nAt3 > 0 .And. nAt4 > 10
				cProt := Substr(cXml,nAt3,nAt4-nAt3)
			Else
				lret := .F.
				lInvalid := .F.
			EndIf
			
			cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
			cXml+= '<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
			cXml+= cNfe
			cXml+= cProt
			cXml+= '</nfeProc>'
			
		ElseIf "PROCCANCNFE" $ Upper(cXml)        
	
			nAt1:= At('<CANCNFE ',Upper(cXml))
			nAt2:= At('</CANCNFE>',Upper(cXml))+ 10
			//Corpo da Nfe
			If nAt1 <=0
				nAt1:= At('<CANCNFE>',Upper(cXml))
			EndIf 	
			If nAt1 > 0 .And. nAt2 > 10
				cNfe := Substr(cXml,nAt1,nAt2-nAt1)
			Else
				cOcorr := "Nf-e inconsistente."	
				lret := .F.
				lInvalid := .T.
			EndIf	
			nAt3:= At('<RETCANCNFE ',Upper(cXml))
			nAt4:= At('</RETCANCNFE>',Upper(cXml))+ 13
			//Protocolo	
			If nAt3 > 0 .And. nAt4 > 13
				cProt := Substr(cXml,nAt3,nAt4-nAt3)
			Else
				lret := .F.
				lInvalid := .F.
			EndIf
			
			cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
			cXml+= '<procCancNfe versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
			cXml+= cNfe
			cXml+= cProt
			cXml+= '</procCancNfe>'	
		
			lCanc := .T.
		
		EndIf
	ElseIf cModelo == "57"
	
		If !"PROCCANCCTE" $ Upper(cXml)     
			nAt1:= At('<CTE ',Upper(cXml))
			nAt2:= At('</CTE>',Upper(cXml))+ 6
			//Corpo da Nfe
			If nAt1 <=0
				nAt1:= At('<CTE>',Upper(cXml))
			EndIf 	
			If nAt1 > 0 .And. nAt2 > 6
				cNfe := Substr(cXml,nAt1,nAt2-nAt1)
			Else
				cOcorr := "CT-e inconsistente."	
				lret := .F.
				lInvalid := .T.
			EndIf	
			nAt3:= At('<PROTCTE ',Upper(cXml))
			nAt4:= At('</PROTCTE>',Upper(cXml))+ 10
			//Protocolo	
			If nAt3 > 0 .And. nAt4 > 10
				cProt := Substr(cXml,nAt3,nAt4-nAt3)
			Else
				lret := .F.
				lInvalid := .F.
			EndIf
			
			cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
			cXml+= '<cteProc versao="1.03" xmlns="http://www.portalfiscal.inf.br/cte">'
			cXml+= cNfe
			cXml+= cProt
			cXml+= '</cteProc>'
			
		ElseiF "PROCCANCCTE" $ Upper(cXml)    
		
			nAt1:= At('<CANCCTE ',Upper(cXml))
			nAt2:= At('</CANCCTE>',Upper(cXml))+ 10
			//Corpo da Nfe
			If nAt1 <=0
				nAt1:= At('<CANCCTE>',Upper(cXml))
			EndIf 	
			If nAt1 > 0 .And. nAt2 > 10
				cNfe := Substr(cXml,nAt1,nAt2-nAt1)
			Else
				cOcorr := "Nf-e inconsistente."	
				lret := .F.
				lInvalid := .T.
			EndIf	
			nAt3:= At('<RETCANCCTE ',Upper(cXml))
			nAt4:= At('</RETCANCCTE>',Upper(cXml))+ 13
			//Protocolo	
			If nAt3 > 0 .And. nAt4 > 13
				cProt := Substr(cXml,nAt3,nAt4-nAt3)
			Else
				lret := .F.
				lInvalid := .F.
			EndIf
			
			cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
			cXml+= '<procCancCTe versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">'
			cXml+= cNfe
			cXml+= cProt
			cXml+= '</procCancCTe>'	
		
			lCanc := .T.	
		
			lCanc := .T.
	    EndIf
	EndIf
	
	cXml := NoAcento(cXml)
	cXml := EncodeUTF8(cXml)
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica no modo novo com uso de parse                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf nModo == 2
	 
	oParse := XmlParserFile( cFile, "_", @cError, @cWarning )
	
	If Empty(cError) .And. Empty(cWarning) .And. !lInvalid .And. oParse <> Nil
		oXml :=  oParse               
		If Type("oParse:_NFEPROC")<>"U" .And. Type("oParse:_NFEPROC:_NFE:_INFNFE:_VERSAO") <> "U" .And. oParse:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT == "1.10"
			cModelo := "00"
			lInvalid := .T.
			lRet := .F.
			cOcorr := "Modelo Invแlido ou nใo homologado."
			Return(lRet)
		EndIf
		
		If Type("oParse:_NFEPROC")<>"U" .Or. Type("oParse:_PROCCANCNFE")<>"U" 
			cModelo := "55"
		ElseIf Type("oParse:_CTEPROC")<>"U" .Or. Type("oParse:_PROCCANCCTE")<>"U" 
			cModelo := "57"	
		Else
			cModelo := "00"
			lInvalid := .T.
			lRet := .F.
			cOcorr := "Modelo Invแlido ou nใo homologado."
			Return(lRet)
		EndIf
		
//Aqui		
		If cModelo == "55"
			If Type("oParse:_PROCCANCNFE")=="U"
				
				//Protocolo	
				If Type("oParse:_NFEPROC:_PROTNFE") <>"U"
					cProt := oParse:_NFEPROC:_PROTNFE:_INFPROT:_NPROT:TEXT
				Else
					lret := .F.
					lInvalid := .F.
				EndIf
				
			ElseIf Type("oParse:_PROCCANCNFE")<>"U"        
		
				oRetId := &("oParse:_PROCCANC"+cTAG+":_CANC"+cTAG+":_INFCANC")
				oRetC  := &("oParse:_PROCCANC"+cTAG+":_RETCANC"+cTAG+":_INFCANC")
			
				cProt   := oRetId:_NPROT:TEXT
				cKey    := &("oRetId:_CH"+cTAG+":TEXT")       
			    cJust   := oRetId:_XJUST:TEXT
			    
				cProtC  := oRetC:_NPROT:TEXT
				cDthRet := oRetC:_DHRECBTO:TEXT      
				cRetStat:= oRetC:_CSTAT:TEXT
				cMotX   := oRetC:_XMOTIVO:TEXT  	
				If Type("oRetC:_NPROT")<>"U"
					cProt := oRetC:_NPROT:TEXT
				Else
					lret := .F.
					lInvalid := .F.
				EndIf
			
				lCanc := .T.
			
			EndIf
		ElseIf cModelo == "57"
		
			If !"PROCCANCCTE" $ Upper(cXml)     
				nAt1:= At('<CTE ',Upper(cXml))
				nAt2:= At('</CTE>',Upper(cXml))+ 6
				//Corpo da Nfe
				If nAt1 <=0
					nAt1:= At('<CTE>',Upper(cXml))
				EndIf 	
				If nAt1 > 0 .And. nAt2 > 6
					cNfe := Substr(cXml,nAt1,nAt2-nAt1)
				Else
					cOcorr := "CT-e inconsistente."	
					lret := .F.
					lInvalid := .T.
				EndIf	
				nAt3:= At('<PROTCTE ',Upper(cXml))
				nAt4:= At('</PROTCTE>',Upper(cXml))+ 10
				//Protocolo	
				If nAt3 > 0 .And. nAt4 > 10
					cProt := Substr(cXml,nAt3,nAt4-nAt3)
				Else
					lret := .F.
					lInvalid := .F.
				EndIf
				
				cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
				cXml+= '<cteProc versao="1.03" xmlns="http://www.portalfiscal.inf.br/cte">'
				cXml+= cNfe
				cXml+= cProt
				cXml+= '</cteProc>'
				
			ElseiF "PROCCANCCTE" $ Upper(cXml)    
			
				nAt1:= At('<CANCCTE ',Upper(cXml))
				nAt2:= At('</CANCCTE>',Upper(cXml))+ 10
				//Corpo da Nfe
				If nAt1 <=0
					nAt1:= At('<CANCCTE>',Upper(cXml))
				EndIf 	
				If nAt1 > 0 .And. nAt2 > 10
					cNfe := Substr(cXml,nAt1,nAt2-nAt1)
				Else
					cOcorr := "Nf-e inconsistente."	
					lret := .F.
					lInvalid := .T.
				EndIf	
				nAt3:= At('<RETCANCCTE ',Upper(cXml))
				nAt4:= At('</RETCANCCTE>',Upper(cXml))+ 13
				//Protocolo	
				If nAt3 > 0 .And. nAt4 > 13
					cProt := Substr(cXml,nAt3,nAt4-nAt3)
				Else
					lret := .F.
					lInvalid := .F.
				EndIf
				
				cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
				cXml+= '<procCancCTe versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">'
				cXml+= cNfe
				cXml+= cProt
				cXml+= '</procCancCTe>'	
			
				lCanc := .T.	
			
				lCanc := .T.
		    EndIf
		EndIf
		
//		cXml := NoAcento(cXml)
//		cXml := EncodeUTF8(cXml)
	Else     
  		cOcorr := "Xml inconsistente."+CRLF+cError+CRLF+cWarning
		lInvalid := .T.	    
	EndIf   
	
Else
	lInvalid := .T.
EndIf

Return(lRet)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ HfSetMailณ Autor ณ Roberto Souza           ณ Data ณ16/01/2013ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Rotina que atualiza os status de e-mail na tabela ZBZ        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ HfSetMail(aTo,cSubject,cMsg,cError,cAnexo,cAnexo2,cEmailDest)ณฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                               Status                                    บฑฑ
ฑฑฬออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบE-Mail    ณ 0-Xml Ok (Nใo envia)                                         บฑฑ
ฑฑบ          ณ 1-Xml com erro (Pendente)                                    บฑฑ
ฑฑบ          ณ 2-Xml com erro (Enviado)                                     บฑฑ
ฑฑบ          ณ 3-Xml cancelado (Pendente)                                   บฑฑ
ฑฑบ          ณ 4-Xml cancelado (Enviado)                                    บฑฑ
ฑฑบ          ณ X-Falha ao enviar o e-mail (Erro)                            บฑฑ
ฑฑบ          ณ Y-Falha ao enviar o e-mail (Cancelamento)                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function HfSetMail(aTo,cSubject,cMensagem,cError,cAnexo,cAnexo2,cEmailDest,cCCdest,cBCCdest)
Return(Nil)  


Static Function NotificaMail(cStatus,cMsg,cModelo,cChave)	
Local cPref     := ""                             
Local cTAG      := ""
Local cAnexo    := ""
Local cTpMail   := ""                
Local nRet      := 0 
Local cError    := ""
lOCAL cEmailErr := ""

If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf
    
	If cStatus $ "1|X" // Erro
		cEmailErr := AllTrim(SuperGetMv("XM_MAIL01")) // Conta de Email para cancelamentos
		cTpMail   := "Erro"
	ElseIf cStatus $ "3|Y" // Cancelamento
		cEmailErr := AllTrim(SuperGetMv("XM_MAIL02")) // Conta de Email para Erros	
		cTpMail   := "Cancelamento"
	EndIf  
	
	lMailErr := !Empty(cEmailErr)        
    
	If lMailErr
	
	    aTo := Separa(cEmailErr,";")
	    cAssunto:= "Aviso de "+cTpMail+" de Xml/"+cPref+" de Entrada."
		nRet := U_MAILSEND(aTo,cAssunto,cMsg,@cError,cAnexo,cAnexo,cEmailErr,"","")
	EndIf

Return(nRet)


Return(nRet)


Static Function GetInfoErro(cStatMail,cMsg,cModelo)
Local cPref     := ""                             
Local cTAG      := "" 
Local cRet      := ""

If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf    

If cStatMail $ "1|X" // Erro
	cTpMail   := "erro"
ElseIf cStatMail $ "3|Y" // Cancelamento
	cTpMail   := "cancelamento"
EndIf  

cMsg := StrTran(cMsg,CRLF,'<br>')
If cStatMail $ "1|X|3|Y"
// Futuramente incluir template   
	cMsgCfg := ""
	cMsgCfg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">
	cMsgCfg += '<head>
	cMsgCfg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	cMsgCfg += '<title>Importa XML</title>
	cMsgCfg += '  <style type="text/css"> 
	cMsgCfg += '	<!-- 
	cMsgCfg += '	body {background-color: rgb(37, 64, 97);} 
	cMsgCfg += '	.style1 {font-family: Hyperfont,Verdana, Arial;font-size: 12pt;} 
	cMsgCfg += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} 
	cMsgCfg += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} 
	cMsgCfg += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} 
	cMsgCfg += '	.style5 {font-size: 10pt} 
	cMsgCfg += '	--> 
	cMsgCfg += '  </style>
	cMsgCfg += '</head>
	cMsgCfg += '<body>
	cMsgCfg += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">
	cMsgCfg += '  <tbody>
	cMsgCfg += '    <tr>
	cMsgCfg += '      <td colspan="2">
	cMsgCfg += '    <Center>
//			cMsgCfg += '      <img src="http://extranet.helpfacil.com.br/images/cabecalho.jpg">
	cMsgCfg += '      <H2>'+Capital(cTpMail)+'</H2>
	cMsgCfg += '      </Center>
	cMsgCfg += '      <hr>			
	cMsgCfg += '      <p class="style1">'+cMsg+'</p>
	cMsgCfg += '      <hr>			
	cMsgCfg += '      </td>
	cMsgCfg += '    </tr>
	cMsgCfg += '  </tbody>
	cMsgCfg += '</table>
	cMsgCfg += '<p class="style1">&nbsp;</p>
	cMsgCfg += '</body>
	cMsgCfg += '</html>
 	cRet    := cMsgCfg
EndIf

Return(cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณEditDocXml ณ Autor ณ Roberto Souza        ณ Data ณ14/02/2013ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Ac็ao tomada ap๓s incluir pr้-nota de entrada conforme     ณฑฑ
ฑฑณ          ณ parametro XM_CFGPRE                      	              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ EditDocXml()                             	              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Conteudo do Parametro XM_CFGPRE                            ณฑฑ
ฑฑณ          ณ 0=Nenhuma a็ใo                                             ณฑฑ
ฑฑณ          ณ 1=Alterar Pr้-Nota                                         ณฑฑ
ฑฑณ          ณ 2=Classificar NF                                           ณฑฑ
ฑฑณ          ณ 3=Alterar Pr้-Nota e Classificar NF                        ณฑฑ
ฑฑณ          ณ 4=Sempre Perguntar                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Importa Xml                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 
Static Function EditDocXml(cModelo,lSetPc,lMata140,lMata103)
Local lRet        := .T.
Local aArea       := GetArea()
Local cAliasEdt   := "SF1"
Local nReg        := 0 
Local nOpcY       := 5
Local nOpcW       := 5
Local cCfgPre     := GetNewPar("XM_CFGPRE","0")
Local lAltPreNf   := cCfgPre $ "4/4"     
Local lClassifica := cCfgPre $ "1/2"
Local lPergAlt    := cCfgPre $ "2" 
Local cTesPcNf    := GetNewPar("MV_TESPCNF","") // Tes que nao necessita de pedido de compra amarrado
Local cKeyFe	  := SetKEY( VK_F3 ,  Nil )
Private lPCNFE    := GetNewPar("MV_PCNFE",.F.)
Private aHeadSD1  := {}
Private lOnUpdate := .T.
Private nOpcAlt   := 0                                
Private aAutoCab  := {}
                       
DbSelectArea(cAliasEdt)
nReg := Recno()

If lPergAlt// .And. !lSetPc
	nOpcAlt := Aviso("Aten็ใo","Deseja classificar a pr้-nota gerada?",;
	{"Sim","Nใo"},;
	1)
	Do Case
 		Case nOpcAlt == 1 
			lAltPreNf  := .F.
	   		lClassifica:= .T.
		OtherWise
			lAltPreNf  := .F.
	   		lClassifica:= .F. 
 
 
/*		
		Case nOpcAlt == 1 
			lAltPreNf  := .T.
	   		lClassifica:= .F.
		Case nOpcAlt == 2 
			lAltPreNf  := .F.
	   		lClassifica:= .T.
		Case nOpcAlt == 3 
			lAltPreNf  := .T.
	   		lClassifica:= .T.
		OtherWise
			lAltPreNf  := .F.
	   		lClassifica:= .F.	   			   			   		
*/
	EndCase
EndIf        

/*
If lAltPreNf .And. !lSetPc
	cCadastro:= "Alterar Pr้-Nota"
	A140NFiscal(cAliasEdt,nReg,5)
EndIf
*/
If lClassifica //.And. !lSetPc
	cCadastro:= "Classificar Documento Entrada"
	aAuxRot := aClone( aRotina )
	aRotina := get2Menu()    //Para nใo dar erro na rotina padrใo.

	A103NFiscal(cAliasEdt,nReg,nOpcW,.F.,.F.)

	aRotina := aClone( aAuxRot )
EndIf              
 
SetKEY( VK_F3 ,  cKeyFe )
RestArea(aArea)
Return(lRet)     


Static Function GetFullTxt(cFile)
Local cRet
Private oParse    
Private cError  := ""
Private cWarning:= ""

	oParse:=XmlParserFile(cFile,"_", @cError, @cWarning )		

	cRet :=  MemoRead(cFile)         

Return(cRet)



//Abre o arquivonHandle := FT_FUse("c:\garbage\test.txt")// Se houver erro de abertura abandona processamentoif nHandle = -1  returnendif// Posiciona na primeira linhaFT_FGoTop()// Retorna o n๚mero de linhas do arquivonLast := FT_FLastRec()MsgAlert( nLast )While !FT_FEOF()   cLine  := FT_FReadLn() // Retorna a linha corrente  nRecno := FT_FRecno()  // Retorna o recno da linha  MsgAlert( "Linha: " + cLine + " - Recno: " + StrZero(nRecno,3) )    // Pula para pr๓xima linha  FT_FSKIP()End// Fecha o arquivoFT_FUSE()

Static Function LerComFRead( cFile )
Local cRet := ""
Local nHandle := 0
Local cBuf := space(1200)
Local nPointer := 0
Local nLido := 0
Local nEof := 0
Local cEol := Chr( 13 ) + Chr( 10 )


Handle := FT_FUse( cFile )

if nHandle = -1  
   return( "" )
endif

FT_FGoTop()
//nLast := FT_FLastRec()

While !FT_FEOF()   

   cBuf := FT_FReadLn() // Retorna a linha corrente
   cRet := cRet + cBuf

   FT_FSKIP()
End

FT_FUSE()

return cRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXMLRECCAR บ Autor ณ Eneovaldo Roveri Jrบ Data ณ  10/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ XML dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML para Aviso de Recebimento de Carga             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function XMLRECCAR()
Local cError    := ""
Local cWarning  := ""
Local lRetorno  := .F.
Local aLinha    := {}
Local nX        := 0
Local nY        := 0                                                   
Local cDoc      := ""
Local cNrAvRC   := ""
Local nTotIcms  := 0
Local nTotIpi   := 0
Local nPeso     := 0
Local nVolume   := 0
Local lOk       := .T.  
Local aProdOk   := {} 
Local aProdNo   := {}
Local aProdVl   := {}
Local aProdZr   := {}
Local oDlg
Local aArea       := GetArea()
Local nTamProd    := TAMSX3("B1_COD")[1]
Local lPergunta   := .F.   
Local cTesPcNf    := GetNewPar("MV_TESPCNF","") // Tes que nao necessita de pedido de compra amarrado
Local lPCNFE      := GetNewPar("MV_PCNFE",.F.)
Local lXMLPE2UM   := ExistBlock( "XMLPE2UM" )
Local lXMLPEIT2   := ExistBlock( "XMLPEIT2" )
Local nQuant      := 0
Local nVunit      := 0
Local nTotal      := 0
Local cUm         := "  "
Local nOpcAuto    := 3
Local nErrItens   := 0
Local nD1Item     := 0
Local oIcm
Local cKeyFe	  := SetKEY( VK_F3 ,  Nil )
Private oFont01   := TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
Private oXml
Private oDet
Private lDetCte     := .F.   //Nใo se aplica
Private lTagOri     := .F.   //Nใo se aplica
Private cTagFci     := ""
Private cCodFci     := ""
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.
Private aCabec    := {}
Private aItens    := {}
Private aItens2   := {}
Private lNossoCod := .F.
Private cProduto  := "" //nTamProd
Private cCnpjEmi  := ""
Private cCodEmit  := ""
Private cLojaEmit := ""
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6"))
Private nFormCTE  := Val(GetNewPar("XM_FORMCTE","6"))
Private cEspecNfe := GetNewPar("XM_ESP_NFE","SPED")
Private cEspecCte := GetNewPar("XM_ESP_CTE","CTE")
Private cModelo   := ZBZ->ZBZ_MODELO
Private cTipoNf   := "N"
Private aItXml    := {}
Private cAmarra   := GetNewPar("XM_DE_PARA","0")
Private aPerg     := {}
Private aCombo    := {}
Private nAliqCTE  := 0, nBaseCTE := 0, nPedagio := 0, cModFrete := " "
Private cPCSol    := GetNewPar("XM_CSOL","A")
Private lNfOri    := .F.  //Nใo se aplica
Private cCnpRem   := ""   //Nใo se aplica
Private lSharedA1 := U_IsShared("SA1")
Private lSharedA2 := U_IsShared("SA2")

Private cTagTotIcm:= ""
Private cTagTotIpi:= ""
Private cTagPeso  := ""
Private cTagVolume:= ""
Private cTagUfO   := ""
Private cxmlUfo   := "" 
Private lSerEmp   := .NOT. Empty( AllTrim(GetNewPar("XM_SEREMP","")) )
Private lTemFreXml:= .F., lTemDesXml := .F., lTemSegXml := .F.

If cModelo == "55"
 	cPref    := "NF-e"                             
	cTAG     := "NFE"
	nFormXML := nFormNfe
	cEspecXML:= cEspecNfe 
	lPergunta:= .F.
ElseIf cModelo == "57"
 	cPref    := "CT-e"                             
	cTAG     := "CTE"
	nFormXML := nFormCte
	cEspecXML:= cEspecCte 
	lPergunta:= .F.
EndIf

cPerg := "IMPXML"
ValidPerg1(cPerg)


aParam   := {" "}
cParXMLExp := cNumEmp+"IMPXML"
cExt     := ".xml"
cNfes    := ""

aAdd( aCombo, "1=Padrใo(SA5/SA7)" )             
aAdd( aCombo, "2=Customizada(ZB5)")
aAdd( aCombo, "3=Sem Amarra็ใo"   )            

aadd(aPerg,{2,"Amarra็ใo Produto","",aCombo,120,".T.",.T.,".T."})

aParam[01] := ParamLoad(cParXMLExp,aPerg,1,aParam[01])

cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR //+ ZBZ->ZBZ_TPDOC
DbSelectArea("DB2")
DbSetOrder(1)
	
lSeekNF := DbSeek(cChaveF1)
	
If !lSeekNf
	nOpcAuto := 3
Else
	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
	DbSelectArea("SF1")
	DbSetOrder(1)
	
	if DbSeek(cChaveF1)
		U_MyAviso("Aten็ใo","Esta NFE jแ foi importada para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
		lRetorno := .T.
		SetKEY( VK_F3 ,  cKeyFe )
		Return
	endif
	DbSelectArea("DB1")
	DbSetOrder(1)
	DbSeek(xFilial("DB1") + DB2->DB2_NRAVRC)
	nOpcAuto := 6
	lRetorno := .T.
EndIf

If cAmarra $ "0,4" .and. nOpcAuto != 6 //.And. !cModelo $ "57"  0,4 -> 4 ้ Pedido entใo pede amarra็ใo
	If !ParamBox(aPerg,"Importa XML - Amarra็ใo",@aParam,,,,,,,cParXMLExp,.T.,.T.)
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	Else 
   		cAmarra  := aParam[01]
	EndIf
EndIf

If lPergunta
	lContImp := Pergunte(cPerg,.T.)
	If !lContImp
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	EndIf
ELse
	lContImp:= .T.
EndIf
	
cTipoCPro := MV_PAR02
cTipoCPro := cAmarra
oXml := XmlParser(ZBZ->ZBZ_XML, "_", @cError, @cWarning )

If oXml == NIL .Or. !Empty(cError) .Or. !Empty(cWarning)
	MsgSTOP("XML Invalido ou Nใo Encontrado, a Importa็ใo Nใo foi Efetuada.")
	SetKEY( VK_F3 ,  cKeyFe )
	Return
EndIf
        
cTagTpEmiss:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPEMIS:TEXT"
cTagTpAmb  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPAMB:TEXT"
cTagCHId   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_ID:TEXT"
cTagSign   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_SIGNATURE"
cTagProt   := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_NPROT:TEXT"
cTagKey    := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_CH"+cTAG+":TEXT"
cTagDocEmit:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EMIT:_CNPJ:TEXT"

cTagDocXMl := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_N"+Left(cTAG,2)+":TEXT"
cTagSerXml := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_SERIE:TEXT"

If cModelo == "55"
		cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DEMI:TEXT"
		if type(cTagDtEmit) == "U"
			cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DHEMI:TEXT"
		endif
		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_DEST:_CNPJ:TEXT"
		cTagUfO    := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EMIT:_ENDEREMIT:_UF:TEXT"

		cTagTotIcm := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TOTAL:_ICMSTOT:_VICMS:TEXT"
		cTagTotIpi := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TOTAL:_ICMSTOT:_VIPI:TEXT"
		cTagPeso   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TRANSP:_VOL:_PESOB:TEXT"
		cTagVolume := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_TRANSP:_VOL:_QVOL:TEXT"
		
ElSeIf cModelo == "57"
		cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DHEMI:TEXT"
		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_CNPJ:TEXT"
		cTagUfO    := ""
		cTagAliq   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS00:_PICMS:TEXT"  
		//Incluindo a TAG ICMS20 pelo Analista Alexandro de Oliveira - 16/12/2014
		cTagAliq1  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS20:_PICMS:TEXT"
		If Type(cTagAliq)<> "U"
	   		nAliqCTE   := Val(&(cTagAliq))  
	   	ElseIf Type(cTagAliq1)<>"U"
	   	    nAliqCTE  := Val(&(cTagAliq1))
	   	EndIf	
		cTagBase   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS00:_VBC:TEXT"
		//Incluindo a TAG ICMS20 pelo Analista Alexandro de Oliveira - 16/12/2014
		cTagBase1  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS20:_VBC:TEXT"
		If Type(cTagBase)<> "U"
	   		nBaseCTE   := Val(&(cTagBase))
	   	ElseIf Type(cTagBase1)<> "U"
	   		nBaseCTE   := Val(&(cTagBase1))
	   	EndIf	   	
	   	nPedagio := 0
	   	If Type( "oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP" ) != "U"
			oDet := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP
			oDet := iif( ValType(oDet) == "O", {oDet}, oDet )
			For i := 1 to Len( oDet )
				If AllTRim( oDet[i]:_XNOME:TEXT ) == "PEDAGIO"
	   				nPedagio := Val(oDet[i]:_VCOMP:TEXT)
	   			EndIf
	   		Next i
	   	EndIf

		cTagTotIcm := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_CST00:_VICMS:TEXT"
		cTagTotIpi := ""
	
		oDet := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ
		oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
		For i := 1 To len(oDet)
			if oDet[i]:_CUNID:TEXT == "01"
				cTagPeso   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_INF"+cTAG+"NORM:_INFCARGA:_INFQ["+alltrim(str(i))+"]:_QCARGA:TEXT"
			elseif oDet[i]:_CUNID:TEXT == "03"
				cTagVolume := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_INF"+cTAG+"NORM:_INFCARGA:_INFQ["+alltrim(str(i))+"]:_QCARGA:TEXT"
			endif
		Next i

Else
		cTagUfO    := ""
		cTagDtEmit := "" 
		cTagDocDest:= ""	
		cTagTotIcm := ""
		cTagTotIpi := ""
		cTagPeso   := ""
		cTagVolume := ""
EndIf

cCodEmit  := ZBZ->ZBZ_CODFOR
cLojaEmit := ZBZ->ZBZ_LOJFOR
cDocXMl   := Iif(nFormXML > 0,StrZero(Val(&(cTagDocXMl)),nFormXML),&(cTagDocXMl))
cSerXml   := &(cTagSerXml)

//Alterado para atender ao empresa ITAMBษ - 16/10/2014
if ( GetNewPar("XM_SERXML","N") == "S" )
	If alltrim( cSerXml ) == '0' .or. alltrim( cSerXml ) == '00' .or. alltrim( cSerXml ) == '000'
		cSerXml := '   '
	EndIf
elseIf ( GetNewPar("XM_SERXML","N") == "Z" )
   	If Empty(cSerXml)
   	    cSerXml := '0'	
    Endif
endif
if lSerEmp
	cSerXml := ZBZ->ZBZ_SERIE
endif
  
cChaveXml := &(cTagKey)
If Type(cTagUfO)<> "U"
	cxmlUfo := &(cTagUfO)
endif
cDtEmit   := &(cTagDtEmit) 
dDataEntr := StoD(substr(cDtEmit,1,4)+Substr(cDtEmit,6,2)+Substr(cDtEmit,9,2))
//	cNrAvRC   := GETSXENUM("DB1","DB1_NRAVRC")
nTotIcms  := iif(Type(cTagTotIcm)<>"U", Val(&(cTagTotIcm)), 0)
nTotIpi   := iif(Type(cTagTotIpi)<>"U", Val(&(cTagTotIpi)), 0)
nPeso     := iif(Type(cTagPeso)<>"U", Val(&(cTagPeso)), 0)
nVolume   := iif(Type(cTagVolume)<>"U", Val(&(cTagVolume)), 0)

aCabec := {}
aadd(aCabec,{"DB1_TIPONF" , Iif(Empty(ZBZ->ZBZ_TPDOC),"N",AllTrim(ZBZ->ZBZ_TPDOC))})
aadd(aCabec,{"DB1_TIPO"   , Iif(ZBZ->ZBZ_TPDOC $ "D|B", "1", "2" ) })
aadd(aCabec,{"DB1_CLIFOR" , cCodEmit  })
aadd(aCabec,{"DB1_LOJA"   , cLojaEmit })
aadd(aCabec,{"DB1_EMISSA" , dDataBase })
aadd(aCabec,{"DB1_ENTREG" , dDataBase })
aadd(aCabec,{"DB1_HORA1"  , substr(Time(),1,5) })
aadd(aCabec,{"DB1_ENTREF" , dDataBase })
aadd(aCabec,{"DB1_HORA2"  , substr(Time(),1,5) })
//	aadd(aCabec,{"DB1_NRAVRC" , cNrAvRC  })
//	aadd(aCabec,{"DB1_NRDOC"  , cNrAvRC })

aItens := {}
aLinha := {}
aadd(aLinha,{"DB2_DOC"    , cDocXMl  								,Nil })
aadd(aLinha,{"DB2_SERIE"  , cSerXml  								,Nil })
aadd(aLinha,{"DB2_EMISSA" , dDataEntr								,Nil })
aadd(aLinha,{"DB2_TIPO"   , Iif(ZBZ->ZBZ_TPDOC $ "D|B", "1", "2" ) 	,Nil })
aadd(aLinha,{"DB2_CLIFOR" , cCodEmit 								,Nil })
aadd(aLinha,{"DB2_LOJA"   , cLojaEmit 								,Nil })
aadd(aLinha,{"DB2_ITEM"   , StrZero(1,Len(DB2->DB2_ITEM))			,Nil })
aadd(aLinha,{"DB2_ESPECI" , cEspecXML 								,Nil })
aadd(aLinha,{"DB2_FORMUL" , "2"										,Nil })
aadd(aLinha,{"DB2_VALICM" , nTotIcms								,Nil })
aadd(aLinha,{"DB2_VALIPI" , nTotIpi									,Nil })
aadd(aLinha,{"DB2_PESO"   , nPeso									,Nil })
aadd(aLinha,{"DB2_VOLUME" , nVolume									,Nil })
//	aadd(aLinha,{"DB2_NRAVRC" , cNrAvRC									,Nil })

aadd(aItens,aLinha)
//	aadd(aItens,{"F1_CHVNFE"  ,cChaveXml}) ta la no hfxml05.prw

lCadastra := .F.
  
Do while nErrItens < 2
 nErrItens++
 lRetorno := .T.
 aLinha   := {}
 aProdOk  := {} 
 aProdNo  := {}
 aProdVl  := {}
 aProdZr  := {}
 aItXml   := {}
 aItens2 := {}
 If cModelo == "55" .and. nOpcAuto != 6
	oDet := oXml:_NFEPROC:_NFE:_INFNFE:_DET            
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
	
	If Type("oXml:_NFEPROC:_NFE:_INFNFE:_DET") == "A"
		aItem := oXml:_NFEPROC:_NFE:_INFNFE:_DET
	Else
		aItem := {oXml:_NFEPROC:_NFE:_INFNFE:_DET}
	EndIf

	nD1Item := 1
	For i := 1 To len(oDet)
		If cTipoCPro == "2" // Ararracao Customizada ZB5 Produto tem que estar Amarrados Tanto Cliente como Formecedor
			cProduto := ""
			If aCabec[1][2] $ "D|B"
				DbSelectArea("ZB5")
				DbSetOrder(2)
				// Filial + CNPJ CLIENTE + Codigo do Produto do Fornecedor
				If DbSeek(xFilial("ZB5")+PADR(ZBZ->ZBZ_CNPJ,14)+oDet[i]:_Prod:_CPROD:TEXT)
					cProduto := ZB5->ZB5_PRODFI
					lRetorno := .T.
					aadd(aProdOk,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
				Else         
					aadd(aProdNo,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )				
				EndIf                     
			Else 
				DbSelectArea("ZB5")
				DbSetOrder(1)
				// Filial + CNPJ FORNECEDOR + Codigo do Produto do Fornecedor
				If DbSeek(xFilial("ZB5")+PADR(ZBZ->ZBZ_CNPJ,14)+oDet[i]:_Prod:_CPROD:TEXT)
					cProduto := ZB5->ZB5_PRODFI
					lRetorno := .T.
					aadd(aProdOk,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
				Else         
					aadd(aProdNo,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )				
				EndIf
			EndIF          
	
		//##################################################################		
		ElseIf cTipoCPro == "1" // Amarracao Padrao SA5/SA7
		
			If aCabec[1][2] $ "D|B" // dDevolu็ใo / Beneficiamento ( utiliza Cliente )

				cProduto  := ""
				if empty( cCodEmit )
					cCodEmit  := Posicione("SA1",3,xFilial("SA1")+ZBZ->ZBZ_CNPJ,"A1_COD")
					cLojaEmit := Posicione("SA1",3,xFilial("SA1")+ZBZ->ZBZ_CNPJ,"A1_LOJA")
				endif
		
				cAliasSA7 := GetNextAlias()
				nVz := len(aItem)
				
				cWhere := "%(SA7.A7_CODCLI IN ("				               
				cWhere += "'"+TrocaAspas( AllTrim(oDet[i]:_Prod:_CPROD:TEXT) )+"'"
				cWhere += ") )%"				               	
			
				BeginSql Alias cAliasSA7
				
				SELECT	A7_FILIAL, A7_CLIENTE, A7_LOJA, A7_CODCLI, A7_PRODUTO, R_E_C_N_O_ 
						FROM %Table:SA7% SA7
						WHERE SA7.%notdel%
			    		AND A7_CLIENTE = %Exp:cCodEmit%
			    		AND A7_LOJA = %Exp:cLojaEmit%
			    		AND %Exp:cWhere%
			    		ORDER BY A7_FILIAL, A7_CLIENTE, A7_LOJA, A7_CODCLI
				EndSql           
		
				DbSelectArea(cAliasSA7)            
				Dbgotop()
		        lFound := .F.
		        cKeySa7:= xFilial("SA7")+cCodEmit+cLojaEmit+TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT )
		        While !(cAliasSA7)->(EOF())
					cKeyTMP := (cAliasSA7)->A7_FILIAL+(cAliasSA7)->A7_CLIENTE+(cAliasSA7)->A7_LOJA+(cAliasSA7)->A7_CODCLI
					If 	AllTrim(cKeySa7) == AllTrim(cKeyTMP)
		        		lFound := .T.
		        		Exit
		        	Endif
		        	(cAliasSA7)->(DbSkip())
		        Enddo
				
				If lFound
					cProduto := (cAliasSA7)->A7_PRODUTO
					lRetorno := .T.
					aadd(aProdOk,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )
				Else         
					aadd(aProdNo,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )				
				EndIf
	
				DbCloseArea()
			
			Else
				cProduto  := ""
				if empty( cCodEmit )
					cCodEmit  := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_COD")
					cLojaEmit := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_LOJA")
				endif
		
				cAliasSA5 := GetNextAlias()
				nVz := len(aItem)
				
				cWhere := "%(SA5.A5_CODPRF IN ("				               
				cWhere += "'"+TrocaAspas( AllTrim(oDet[i]:_Prod:_CPROD:TEXT) )+"'"
				cWhere += ") )%"				               	
			
				BeginSql Alias cAliasSA5
				
				SELECT	A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF, A5_PRODUTO, R_E_C_N_O_ 
						FROM %Table:SA5% SA5
						WHERE SA5.%notdel%
			    		AND A5_FORNECE = %Exp:cCodEmit%
			    		AND A5_LOJA = %Exp:cLojaEmit%
			    		AND %Exp:cWhere%
			    		ORDER BY A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF
				EndSql           
		
				DbSelectArea(cAliasSA5)            
				Dbgotop()
		        lFound := .F.
		        cKeySa5:= xFilial("SA5")+cCodEmit+cLojaEmit+TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT )
		        While !(cAliasSA5)->(EOF())
					cKeyTMP := (cAliasSA5)->A5_FILIAL+(cAliasSA5)->A5_FORNECE+(cAliasSA5)->A5_LOJA+(cAliasSA5)->A5_CODPRF
					If 	AllTrim(cKeySa5) == AllTrim(cKeyTMP)
		        		lFound := .T.
		        		Exit
		        	Endif
		        	(cAliasSA5)->(DbSkip())
		        Enddo
				
				
				If lFound
					cProduto := (cAliasSA5)->A5_PRODUTO
					lRetorno := .T.
					aadd(aProdOk,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )
				Else         
					aadd(aProdNo,{TrocaAspas( oDet[i]:_Prod:_CPROD:TEXT ),oDet[i]:_Prod:_XPROD:TEXT} )				
				EndIf
	
				DbCloseArea()
			EndIF          		
		
		//##################################################################
		ElseIf cTipoCPro = "3" // Mesmo Codigo Nao requer amarracao SB1
			DbSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+oDet[i]:_Prod:_CPROD:TEXT)
				cProduto := Substr(oDet[i]:_Prod:_CPROD:TEXT,1,15)
				lRetorno := .T.
				aadd(aProdOk,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )
			Else         
				cProduto := Substr(oDet[i]:_Prod:_CPROD:TEXT,1,15)
				aadd(aProdNo,{oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT} )				
			EndIF
		EndIf

		cUm    := "  "
		cTagFci:= "oDet[i]:_Prod:_UCOM:TEXT"
		if Type(cTagFci) <> "U"
			cUm := oDet[i]:_Prod:_UCOM:TEXT
		endif
		nQuant := VAL(oDet[i]:_Prod:_QCOM:TEXT)
		nVunit := VAL(oDet[i]:_Prod:_VUNCOM:TEXT)
		nTotal := VAL(oDet[i]:_Prod:_VPROD:TEXT)
        cCodFci:= ""
        cTagFci:= "oDet[i]:_PROD:_NFCI:TEXT"
        If Type(cTagFci) <> "U"
			cCodFci:= &cTagFci.
		EndIf

		If lXMLPE2UM   //PE para conversใo da 2 unidade de medida
			oIcm := oDet[i]:_Imposto:_ICMS
			oIcm := IIf(ValType(oIcm)=="O",{oIcm},oIcm)
	   		aRet :=	ExecBlock( "XMLPE2UM", .F., .F., { cProduto,cUm,nQuant,nVunit,oIcm } )
	   		if aRet == NIL
				cUm    := "  "
				nQuant := 0
				nVunit := 0
			else
				cUm    := iif( len(aRet) >= 2, aRet[2], "  " )
				nQuant := iif( len(aRet) >= 3, aRet[3], 0 )
				nVunit := iif( len(aRet) >= 4, aRet[4], 0 )
	   		endif
		 	if Round((nQuant * nVunit),2) != Round(nTotal, 2)
		 		if ABS( Round((nQuant * nVunit),2) - Round(nTotal, 2) ) > 0.01
					aadd(aProdVl,{oDet[i]:_Prod:_CPROD:TEXT, cUm, nQuant, nVunit, nTotal, (nQuant * nVunit) } )
				else
					if nVunit <> VAL(oDet[i]:_Prod:_VUNCOM:TEXT) //por causa do problema de arredondar e truncar com valor unitแrio com 3 casas decimais (Itamb้)
						aadd(aProdVl,{oDet[i]:_Prod:_CPROD:TEXT, cUm, nQuant, nVunit, nTotal, (nQuant * nVunit) } )
					endif
				endif
		 	endif
	 	EndIf

		aadd(aLinha,{"DB3_ITDOC"  , StrZero(1,Len(DB3->DB3_ITDOC))	,Nil })
		aadd(aLinha,{"DB3_ITEM"   , StrZero(nD1Item,Len(DB3->DB3_ITEM)) 	,Nil })
		aadd(aLinha,{"DB3_CODPRO" , cProduto						,Nil })
		aadd(aLinha,{"DB3_QUANT"  , nQuant							,Nil })
		aadd(aLinha,{"DB3_VUNIT"  , nVunit							,Nil })
		aadd(aLinha,{"DB3_TOTAL"  , nTotal							,Nil })
//		aadd(aLinha,{"DB3_NRAVRC" , cNrAvRC 						,Nil })

		If lXMLPEIT2   //PE para incluir campos no aLinha DB3 -> para o aItens2
	   		aRet :=	ExecBlock( "XMLPEIT2", .F., .F., { cProduto,oDet,i } )
			If ValType(aRet) == "A"
				AEval(aRet,{|x| AAdd(aLinha,x)})
			EndIf
	 	endif

		If .not. Empty( cProduto )
	 		if SB1->( DbSeek(xFilial("SB1")+cProduto) )
 				If SB1->( FieldGet(FieldPos("B1_MSBLQL")) ) == "1"
	 				aadd(aProdNo,{cProduto,"Produto Bloqueado SB1->"+SB1->B1_DESC} )
 				EndIf
	 		ElseIf cTipoCPro != "3"
 				aadd(aProdNo,{cProduto,"Nใa Cadastrado SB1->"+oDet[i]:_Prod:_XPROD:TEXT} )
 			EndIf
 		EndIf

 		if nVunit <= 0   //Em natal ้ permitido valor unitแrio Zero
			//aadd(aProdZr, { StrZero(i,4), oDet[i]:_Prod:_CPROD:TEXT, cProduto, nVunit, oDet[i]:_Prod:_XPROD:TEXT } )
 		endif

 		if nVunit > 0 //permitir valor unitแrio maior zero
		 	aadd(aItens2,aLinha)
		 	nD1Item++
		 	aadd(aItXml,{StrZero(i,4),oDet[i]:_Prod:_CPROD:TEXT,oDet[i]:_Prod:_XPROD:TEXT})	
		endif
		aLinha := {}

	Next i
         
	if .not. ItNaoEnc( "AVRC", aProdOk, aProdNo, aProdVl, @nErrItens, aProdZr )
	    lRetorno := .F.
		Loop
	endif
	
	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR //+ ZBZ->ZBZ_TPDOC
	DbSelectArea("DB2")
	DbSetOrder(1)
	
	lSeekNF := DbSeek(cChaveF1)
	
	If !lSeekNf
		If ZBZ->ZBZ_PRENF $ "A"
			lOkGo := MsgYesNo("A.Rec. Carga gerada previamente mas foi excluida.Deseja prosseguir gerando novamente?","Aviso")						
			If !lOkGo
				lRetorno := .F.
			EndIf
		EndIf
		nOpcAuto := 3
	Else
		cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
		DbSelectArea("SF1")
		DbSetOrder(1)
	
		if DbSeek(cChaveF1)
			U_MyAviso("Aten็ใo","Esta NFE jแ foi importada para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
			lRetorno := .F.
		endif
		DbSelectArea("DB1")
		DbSetOrder(1)
		DbSeek(xFilial("DB1") + DB2->DB2_NRAVRC)
		nOpcAuto := 6
	EndIf
	
 ElseIf cModelo == "57" .and. nOpcAuto != 6
	lRetorno := .T.
	oDet := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST
	cProdCte := Padr(GetNewPar("XM_PRODCTE","FRETE"),nTamProd)
    cProdCte :=Iif(Empty(cProdCte),Padr("FRETE",nTamProd),cProdCte)
	If cTipoCPro == "2" // Ararracao Customizada ZB5 Produto tem que estar Amarrados Tanto Cliente como Formecedor
		cProduto := ""

		DbSelectArea("ZB5")
		DbSetOrder(1)
		// Filial + CNPJ FORNECEDOR + Codigo do Produto do Fornecedor
		If DbSeek(xFilial("ZB5")+PADR(ZBZ->ZBZ_CNPJ,14)+cProdCte)
			cProduto := ZB5->ZB5_PRODFI
			lRetorno := .T.
			aadd(aProdOk,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		Else         
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )				
		EndIf

	//##################################################################		
	ElseIf cTipoCPro == "1" // Amarracao Padrao SA5/SA7
	

		cProduto  := ""
		if empty( cCodEmit )
			cCodEmit  := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_COD")
			cLojaEmit := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_LOJA")
		endif

		cAliasSA5 := GetNextAlias()
		
		cWhere := "%(SA5.A5_CODPRF IN ("				               
		cWhere += "'"+AllTrim(cProdCte)+"'"
		cWhere += ") )%"				               	
	
		BeginSql Alias cAliasSA5
		
		SELECT	A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF, A5_PRODUTO, R_E_C_N_O_ 
				FROM %Table:SA5% SA5
				WHERE SA5.%notdel%
	    		AND A5_FORNECE = %Exp:cCodEmit%
	    		AND A5_LOJA = %Exp:cLojaEmit%
	    		AND %Exp:cWhere%
	    		ORDER BY A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF
		EndSql           

		DbSelectArea(cAliasSA5)            
		Dbgotop()
        lFound := .F.
        cKeySa5:= xFilial("SA5")+cCodEmit+cLojaEmit+cProdCte
        While !(cAliasSA5)->(EOF())
			cKeyTMP := (cAliasSA5)->A5_FILIAL+(cAliasSA5)->A5_FORNECE+(cAliasSA5)->A5_LOJA+(cAliasSA5)->A5_CODPRF
			If 	AllTrim(cKeySa5) == AllTrim(cKeyTMP)
        		lFound := .T.
        		Exit
        	Endif
        	(cAliasSA5)->(DbSkip())
        Enddo
		
		
		If lFound
			cProduto := (cAliasSA5)->A5_PRODUTO
			lRetorno := .T.
			aadd(aProdOk,{cProduto,"PRESTACAO DE SERVICO - FRETE"} )
		Else         
			cProduto := cProdCte
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )				
		EndIf

		DbCloseArea()
       		
	
	//##################################################################
	ElseIf cTipoCPro = "3" // Mesmo Codigo Nao requer amarracao SB1
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+cProdCte)
			cProduto := Substr(cProdCte,1,15)
			lRetorno := .T.
			aadd(aProdOk,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		Else         
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )				
		EndIF
	EndIf

	aadd(aLinha,{"DB3_ITDOC"  , StrZero(1,Len(DB3->DB3_ITDOC))	,Nil })
	aadd(aLinha,{"DB3_ITEM"   , StrZero(1,Len(DB3->DB3_ITEM)) 	,Nil })
	aadd(aLinha,{"DB3_CODPRO" , cProduto						,Nil })
	aadd(aLinha,{"DB3_QUANT"  , 1								,Nil })
	aadd(aLinha,{"DB3_VUNIT"  , VAL(oDet:_VTPREST:TEXT)			,Nil })
	aadd(aLinha,{"DB3_TOTAL"  , VAL(oDet:_VTPREST:TEXT)			,Nil })
//	aadd(aLinha,{"DB3_NRAVRC" , cNrAvRC 						,Nil })

	If lXMLPEIT2   //PE para incluir campos no aLinha para o aItens2
   		aRet :=	ExecBlock( "XMLPEIT2", .F., .F., { cProduto,oDet,1 } )
		If ValType(aRet) == "A"
			AEval(aRet,{|x| AAdd(aLinha,x)})
		EndIf
 	endif

	if VAL(oDet:_VTPREST:TEXT) <= 0
		aadd(aProdZr, { StrZero(1,Len(DB3->DB3_ITEM)), cProdCte, cProduto, VAL(oDet:_VTPREST:TEXT),"PRESTACAO DE SERVICO - FRETE" } )
	endif

	If .not. Empty( cProduto )
		if SB1->( DbSeek(xFilial("SB1")+cProduto) )
			If SB1->( FieldGet(FieldPos("B1_MSBLQL")) ) == "1"
				aadd(aProdNo,{cProduto,"Produto Bloqueado SB1->"+SB1->B1_DESC} )
			EndIf
		ElseIf cTipoCPro != "3"
			aadd(aProdNo,{cProduto,"Nใa Cadastrado SB1->"+"PRESTACAO DE SERVICO - FRETE"} )
		EndIf
	EndIf

 	aadd(aItens2,aLinha)
 	aadd(aItXml,{"0001",cProdCte,Posicione("SB1",1,xFilial("SB1")+cProdCte,"B1_DESC")})	
	aLinha := {}

	if .not. ItNaoEnc( "AVRC", aProdOk, aProdNo, aProdVl, @nErrItens, aProdZr )
	    lRetorno := .F.
		Loop
	endif
	
	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR //+ ZBZ->ZBZ_TPDOC
	DbSelectArea("DB2")
	DbSetOrder(1)
	
	lSeekNF := DbSeek(cChaveF1)
	
	If !lSeekNf
		If ZBZ->ZBZ_PRENF $ "A"
			lOkGo := MsgYesNo("Av. Rec. de Carga gerada previamente mas foi excluida. Deseja prosseguir gerando novamente?","Aviso")
			If !lOkGo
				lRetorno := .F.
			EndIf
		EndIf
		nOpcAuto := 3
	Else
		cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
		DbSelectArea("SF1")
		DbSetOrder(1)
	
		if DbSeek(cChaveF1)
			U_MyAviso("Aten็ใo","Esta NFE jแ foi importada para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
			lRetorno := .F.
		endif
		DbSelectArea("DB1")
		DbSetOrder(1)
		DbSeek(xFilial("DB1") + DB2->DB2_NRAVRC)
		nOpcAuto := 6
	EndIf

 Elseif nOpcAuto == 6
  If cModelo == "55"
	oDet := oXml:_NFEPROC:_NFE:_INFNFE:_DET            
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
  ElseIf cModelo == "57"
	oDet := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST
  Endif
	
 EndIf

 Exit
Enddo

If lRetorno

	DbSelectArea("DB1")
	DbSetOrder(1)

	aCols    := {}
	aRetHead := {}
	aRetCol  := {}

	lSetPC := .F.

	If cModelo =='57' .and. nOpcAuto != 6
		If !Empty(cTesPcNf) .And. (Posicione("SB1",1,xFilial("SB1")+aItens[1][2][2],"B1_TE") $ AllTrim(cTesPcNf))
			lSetPC := .T.
		EndIf
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Inicio da Inclusao                                           |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lRetorno :=.T. // U_VisNota(cModelo, ZBZ->ZBZ_CNPJ,oXml, aCols, @aCabec, @aItens )
                         

	If lRetorno  
		lmata140 := .F.

		xRet145 := 0

//		xRet145:= MSExecAuto({|x,y,z| U_Xmata145(x,y,z)},aCabec,aItens,3,,1)
		xRet145 := U_XMATA145(aCabec,aItens,aItens2,nOpcAuto)

		lMata140 := .T.

		lEditStat := .F.

		If lMsErroAuto
			MOSTRAERRO()
		Endif

		if xRet145 > 0
		    lMsHelpAuto:=.F.

			If xRet145 > 1   //para ver se classifica a nota.
				lEditStat := SF1->( DbSeek(cChaveF1) )
				if lEditStat .and. Empty(SF1->F1_STATUS)
					EditDocXml(cModelo,lSetPc,lMata140,.F.)
				endif
			    U_MyAviso("Aviso","Importa็ใo do Aviso de Rec. e Carga Efetuado e Homologado com Sucesso."+CRLF+" Utilize a op็ใo :"+CRLF+;
				"Movimento -> Pre-Nota Entrada / Aviso Recbto Carga "+CRLF+" para Verificar a Integridade dos Dados.",{"OK"},3)
			Else
				lEditStat := SF1->( DbSeek(cChaveF1) )
			    U_MyAviso("Aviso","Importa็ใo do Aviso de Rec. e Carga Efetuado com Sucesso."+CRLF+" Utilize a op็ใo :"+CRLF+;
				"Movimento -> Aviso Recbto Carga "+CRLF+" para Verificar a Integridade dos Dados.",{"OK"},3)
			EndIf
			DbSelectArea("ZBZ")
			Reclock("ZBZ",.F.)
			If lEditStat
				ZBZ->ZBZ_PRENF  := Iif(Empty(SF1->F1_STATUS),'S','N')
			elseif xRet145 > 1
				ZBZ->ZBZ_PRENF  := "S"
			else
				ZBZ->ZBZ_PRENF  := "A"
		    endif
				ZBZ->ZBZ_TPDOC  := aCabec[1][2]
				ZBZ->ZBZ_CODFOR := aCabec[3][2]
				ZBZ->ZBZ_LOJFOR := aCabec[4][2]
				if FieldPos("ZBZ_MANIF") > 0
					ZBZ->ZBZ_MANIF	:= U_MANIFXML( AllTrim( ZBZ->ZBZ_CHAVE ), .T. )
				endif
			MsUnlock()

			lRetorno := .T.
		EndIf
	EndIf
Endif

RestArea(aArea)
SetKEY( VK_F3 ,  cKeyFe )
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02ARCบ Autor ณEneovaldo Roveri Jr.บ Data ณ  25/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Menu de Aviso de Recebimento de Carga                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02ARC
Local lOk := .T.     
Local aArea:= GetArea()
Local cMsg := "Gerando o Aviso do Recebimento de Carga ..."

If ZBZ->(FieldPos("ZBZ_STATUS"))>0 
	If ZBZ->ZBZ_STATUS <>"1"
		lOk:= .F.   
   		MsgStop("Esta rotina nใo pode ser executada em um registro com erros na importa็ใo.")
	EndIf	
EndIf

If ZBZ->(FieldPos("ZBZ_PROTC"))>0  .And. AllTrim(ZBZ->ZBZ_PROTC) <> ""
	lOk:= .F.   
	MsgStop("Este xml foi cancelado pelo emissor.Nใo pode ser gerada e pr้-nota.")
EndIf

If Empty(ZBZ->ZBZ_CODFOR) .Or. Empty(ZBZ->ZBZ_LOJFOR)
	lOk:= .F.   
	MsgStop("Este XML nใo possui fornecedor associado. Clique em A็๕es Relacionadas / Fun็๕es XML / Alterar e Associe o Fornecedor de Acordo com o CNPJ. Caso nใo Tenha Fornecedor Cadastrado com o CNPJ, fa็a-o no Cadastro de Fornecedor.")
EndIf

If lOk
	cXMLExp    := ZBZ->ZBZ_XML
	
	If ZBZ->ZBZ_MODELO == "55"
		Processa( {|| XMLRECCAR() }, "Aguarde...", cMsg,.F.)   	
   	ELseIf ZBZ->ZBZ_MODELO == "57"
   		if U_MyAviso("Pergunta","Este XML ้ modelo 57 (CTE). Voc๊ deseja incluir Aviso de Recebimento de Carga ou Documento de Entrada (NF,pr้-nota)?",{"A.R.Carga","Doc.Entrada"},2) == 1
   			Processa( {|| XMLRECCAR() }, "Aguarde...", cMsg,.F.)
   		else
			Processa( {|| IMPXMLFOR() }, "Aguarde...", "Gerando a Pr้-Nota ...",.F.)
   		endif
	EndIf
    
EndIf
                       
RestArea(aArea)
Return

//cTipoProc -> AVRC -> Aviso Recebimento de Carga
//             PREN -> Pr้-Nota de Entrada
//             NFCF -> NT Conhecimento Frete
//             PDRC -> Pedido Recorrente
//cTipoCPro -> esta variแvel tem que vir como private
//aCabec    -> tem que vir como private
//nErrItens -> variแvel para controlar quantas vezes passou pelos ํtens, mostrar erros apenas uma vez, na segunda cai fora
//aProdZr   -> Produtos com valores unitแrios Zerado.
Static Function ItNaoEnc( cTipoProc, aProdOk, aProdNo, aProdVl, nErrItens, aProdZr )
Local lRet := .T.
Local cTit1 := ""
Local cTit2 := "" 
Local cAli  := iif(cTipoProc == "AVRC", "DB3", "SD1" )
Local cTips := iif(cTipoProc $ "NFCF,PDRC", Iif(Empty(ZBZ->ZBZ_TPDOC),"N",AllTrim(ZBZ->ZBZ_TPDOC)), aCabec[1][2] )

Private cInfo := ""

if nErrItens == NIL
	nErrItens := 1
endif

cTit1 := iif( (cTipoProc == "AVRC"), "Avisos - Gera็ใo Av. Rec. Carga",;
         iif( (cTipoProc == "NFCF"), "Avisos - Gera็ใo Nt Conhec Frete",;
         iif( (cTipoProc == "PDRC"), "Avisos - Manuten็ใo Pedido Recorrente",;
                                     "Avisos - Gera็ใo Pr้-Nota" ) ) )
cTit2 := iif( (cTipoProc == "AVRC"), "Avisos - Av. Rec. Carga Interrompido",;
         iif( (cTipoProc == "NFCF"), "Avisos - Nt Conhec Frete Interrompido",;
         iif( (cTipoProc == "PDRC"), "Avisos - Manuten็ใo Pedido Recorrente",;
                                     "Avisos - Gera็ใo Pr้-Nota Interrompida" ) ) )

//Itens nใo encontrados
If !Empty(aProdNo)
	if nErrItens < 2  
		If Empty(aProdOk)                                                     
			aadd(aProdOk,{"- - -","- - - - - - -"} )		
		EndIf
		if cTipoProc == "AVRC"
			cInfo := "A Gera็ใo do Aviso Recebimento de Carga serแ Interrompido ... "+CRLF
		elseif cTipoProc == "NFCF"
			cInfo := "A Gera็ใo da Nt Conhec Frete serแ Interrompida ... "+CRLF
		elseif cTipoProc == "PDRC"
			cInfo := "A Manuten็ใo de Pedido Recorrente serแ Interrompida ... "+CRLF
		else
			cInfo := "A Gera็ใo da Pre-Nota serแ Interrompida ... "+CRLF
		endif
		cInfo += "Itens OK."+CRLF
		For Nx := 1 to Len(aProdOk)
			cInfo += aProdOk[Nx][1]+" - "+aProdOk[Nx][2]+CRLF
		Next
	
		cInfo += "Itens com problemas."+CRLF
		For Nx := 1 to Len(aProdNo)
			cInfo += aProdNo[Nx][1]+" - "+aProdNo[Nx][2]+CRLF
		Next	    
		
		DEFINE MSDIALOG oDlg TITLE cTit1 FROM 000,000 TO 500,500 PIXEL
	
		@ 010,010 Say "Produtos Encontrados:"     PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
		@ 020,010 LISTBOX oLbx1 FIELDS HEADER ;
		   "Produto", "Descri็ใo" ;
		   SIZE 230,095 OF oDlg PIXEL
			                                      
		oLbx1:SetArray( aProdOk )
		oLbx1:bLine := {|| {aProdOk[oLbx1:nAt,1],;
		     	            aProdOk[oLbx1:nAt,2]}}
		     	            
		@ 125,010 Say "Produtos Nใo Encontrados:" PIXEL OF oDlg COLOR CLR_RED FONT oFont01
		@ 135,010 LISTBOX oLbx2 FIELDS HEADER ;
		   "Produto", "Descri็ใo" ;
		   SIZE 230,095 OF oDlg PIXEL ON DBLCLICK( PutDePara(oLbx1,oLbx2,cTips,cTipoCPro,ZBZ->ZBZ_CNPJ,ZBZ->ZBZ_CODFOR,ZBZ->ZBZ_LOJFOR)) 
			                                      
		oLbx2:SetArray( aProdNo )
		oLbx2:bLine := {|| {aProdNo[oLbx2:nAt,1],;
		     	            aProdNo[oLbx2:nAt,2]}}
	
		if cTipoCPro == "2"
			@ 023.2,005 BUTTON "Amarra Todos" SIZE 40,15 OF oDlg Action (PutDePara2(@oLbx1,@oLbx2,cTips,cTipoCPro,ZBZ->ZBZ_CNPJ,ZBZ->ZBZ_CODFOR,ZBZ->ZBZ_LOJFOR,@aProdOk,@aProdNo) )
		endif
		@ 023.2,040 BUTTON "Detalhe" SIZE 35,15 OF oDlg Action (U_MyAviso("Aviso","Existem itens que nใo encontraram amarra็ใo."+CRLF+cInfo,{"OK"},3))
		@ 023.2,050 BUTTON "OK" SIZE 35,15 OF oDlg Action oDlg:End()
	  
		ACTIVATE MSDIALOG oDlg CENTER
	EndIf
    lRet := .F.
Endif

if lRet //s๓ verificar isto, se o outro estiver Ok.
	//Produto com probela de valores, devido modifica็ใo pelo ponto de Entrada
	If !Empty(aProdVl)                                                     
		
		DEFINE MSDIALOG oDlg TITLE cTit2 FROM 000,000 TO 550,650 PIXEL

		@ 010,010 Say "Itens divergentes entre valor do item no xml e calculado da 2a Unidade de Medida (PE - U_XMLPE2UM):" PIXEL OF oDlg COLOR CLR_RED FONT oFont01
		@ 020,010 LISTBOX oLbx2 FIELDS HEADER ;
		   "Produto", "vPROD no XML", "UM", "Qtd", "Vr Unitario", "Vr Total" ;
		   SIZE 310,230 OF oDlg PIXEL

		oLbx2:SetArray( aProdVl )
		oLbx2:bLine := {|| {aProdVl[oLbx2:nAt,1],;
		     	            transform(aProdVl[oLbx2:nAt,5],PesqPict(cAli,iif(cTipoProc == "AVRC",'DB3_TOTAL','D1_TOTAL') )),;
		     	            aProdVl[oLbx2:nAt,2],;
		     	            transform(aProdVl[oLbx2:nAt,3],PesqPict(cAli,iif(cTipoProc == "AVRC",'DB3_QUANT','D1_QUANT') )),;
		     	            transform(aProdVl[oLbx2:nAt,4],PesqPict(cAli,iif(cTipoProc == "AVRC",'DB3_VUNIT','D1_VUNIT') )),;
		     	            transform(aProdVl[oLbx2:nAt,6],PesqPict(cAli,iif(cTipoProc == "AVRC",'DB3_TOTAL','D1_TOTAL') )) }}

		@ 025.2,069 BUTTON "OK" SIZE 35,15 OF oDlg Action oDlg:End()

		ACTIVATE MSDIALOG oDlg CENTER
	    lRet := .F.
		nErrItens := 2
	EndIf
Endif

if lRet //s๓ verificar isto, se o outro estiver Ok.
	//Produto com probela de valores unitแrios
	If !Empty(aProdZr)                                                     
		
		DEFINE MSDIALOG oDlg TITLE cTit2 FROM 000,000 TO 550,650 PIXEL

		@ 010,010 Say "Itens sem valor unitแrio:" PIXEL OF oDlg COLOR CLR_RED FONT oFont01
		@ 020,010 LISTBOX oLbx2 FIELDS HEADER ;
		   "Item","Produto","Produto Interno", "Vr Unitario", "Descri็ใo" ;
		   SIZE 310,230 OF oDlg PIXEL

		oLbx2:SetArray( aProdZr )
		oLbx2:bLine := {|| {aProdZr[oLbx2:nAt,1],;
		     	            aProdZr[oLbx2:nAt,2],;
		     	            aProdZr[oLbx2:nAt,3],;
		     	            transform(aProdZr[oLbx2:nAt,4],PesqPict(cAli,iif(cTipoProc == "AVRC",'DB3_VUNIT','D1_VUNIT') )),;
		     	            aProdZr[oLbx2:nAt,5] }}

		@ 025.2,069 BUTTON "OK" SIZE 35,15 OF oDlg Action oDlg:End()

		ACTIVATE MSDIALOG oDlg CENTER
	    lRet := .F.
		nErrItens := 2
	EndIf
Endif

Return lRet



Static Function Get2Menu()
Local aMenu := {}
Local aSub1 := {}
Local aSub2 := {}           

 
aSub1   := {{"Alterar"           ,"U_HFXML02M" ,0,3},; 
			{"Consulta Chave Xml","U_HFXML02X" ,0,3}}
                 
aMenu   := { {"Pesquisar"      ,"AxPesqui"   ,0,1,0,Nil},;
			 {"Vis. Registro"  ,"AxVisual"   ,0,2,0,Nil},;
			 {"&Visualiza NF"  ,"U_HFXML02V" ,0,2,0,Nil},;
			 {"Baixar Xml"     ,"U_HFXML02D" ,0,3,0,Nil},;
			 {"Gera &Pre Nota" ,"U_HFXML02P" ,0,4,0,Nil},;
			 {"Danfe"          ,"U_XMLPRTdoc",0,4,0,Nil},;
			 {"Exportar XML"   ,"U_HFXML02E" ,0,4,0,Nil},;
			 {"Fun็๕es XML"    , aSub1 		 ,0,5,0,Nil},;
			 {"Legenda"        ,"U_HFXML02L" ,0,3,0,Nil} }


/*
aMenu   := { {"Pesquisar"      ,"AxPesqui"   ,0,1,0,Nil},;
			 {"Vis. Registro"  ,"AxVisual"   ,0,2,0,Nil},;
			 {"Baixar Xml"     ,"U_HFXML02D" ,0,3,0,Nil},;
			 {"Gera Pre Nota"  ,"U_HFXML02P" ,0,4,0,Nil},;
			 {"Danfe"          ,"U_XMLPRTdoc",0,4,0,Nil},;
			 {"Exportar XML"   ,"U_HFXML02E" ,0,4,0,Nil},;
			 {"Alterar"        ,"U_HFXML02M" ,0,3,0,Nil},;
			 {"Legenda"        ,"U_HFXML02L" ,0,3,0,Nil} }

*/
Return(aMenu)


Static Function RancaBarras( cFile )
Local cRet := cFile

cRet := StrTran(cRet,"\","")
cRet := StrTran(cRet,"/","")

Return( cRet )


Static Function TrocaAspas( cCod )
Local cRet := cCod

cRet := StrTran(cRet,"'",'"')  //troca ' por " -> Isto serve para quando o c๓digo do produto vem com ', pois o SA5/SA7 ้ feito query a qual utiliza-se de '

Return( cRet )


Static Function DocDaChave( cChv, cFornOri, cLojaOri, cTipoNfo, cFormul, cCc )  //Pegar Documentos no SF2
Local aRet[2]
Local cQuery := ""
Local aArea  := GetArea()
Local cAliasSF2 := GetNextAlias()

aRet[1] := Substr("N/E"+space( len(SF2->F2_DOC ) ), 1, len(SF2->F2_DOC ) )
aRet[2] := space( len(SF2->F2_SERIE ) )

If .Not. Empty( cChv )
	cQuery := "SELECT SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_TIPO,SF2.F2_FORMUL "
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 "
	cQuery += "WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
	cQuery += "SF2.F2_CHVNFE = '"+cChv+"' AND "
	cQuery += "SF2.D_E_L_E_T_ = ' ' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2)

	DbSelectARea( cAliasSF2 )
	Do While .Not. ( cAliasSF2 )->( Eof() )
		aRet[1] := ( cAliasSF2 )->F2_DOC
		aRet[2] := ( cAliasSF2 )->F2_SERIE
		cFornOri:= ( cAliasSF2 )->F2_CLIENTE
		cLojaOri:= ( cAliasSF2 )->F2_LOJA
		cTipoNfo:= ( cAliasSF2 )->F2_TIPO
		cFormul := ( cAliasSF2 )->F2_FORMUL
		if empty( cCc )
			SD2->( dbSetOrder( 3 ) )
			if SD2->( dbSeek( ZBZ->ZBZ_FILIAL + ( cAliasSF2 )->F2_DOC + ( cAliasSF2 )->F2_SERIE + ( cAliasSF2 )->F2_CLIENTE + ( cAliasSF2 )->F2_LOJA ) )
				cCc := SD2->D2_CCUSTO
			endif
		endif
		( cAliasSF2 )->( dbSkip() )
	EndDo
EndIf

DbSelectArea(cAliasSF2)
DbCloseArea()
RestArea(aArea)
Return( aRet )


Static Function Sf3DaChave( cChv, cFornOri, cLojaOri, cTipoNfo, cFormul, cCc )  //Pegar Documentos no SF3
Local aRet[2]
Local cQuery := ""
Local aArea  := GetArea()
Local cAliasSF3 := GetNextAlias()
Local cFilSeek:= Iif(U_IsShared("SA2"),xFilial("SA2"),ZBZ->ZBZ_FILIAL)

SA2->( dbSetorder(1) )

aRet[1] := Substr("N/E"+space( len(SF3->F3_NFISCAL ) ), 1, len(SF3->F3_NFISCAL ) )
aRet[2] := space( len(SF3->F3_SERIE ) )

If .Not. Empty( cChv )
	cQuery := "SELECT SF3.F3_NFISCAL,SF3.F3_SERIE,SF3.F3_CLIEFOR,SF3.F3_LOJA,SF3.F3_TIPO,SF3.F3_FORMUL "
	cQuery += "FROM "+RetSqlName("SF3")+" SF3 "
	cQuery += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
	cQuery += "SF3.F3_CHVNFE = '"+cChv+"' AND "
	cQuery += "SF3.D_E_L_E_T_ = ' ' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3)

	DbSelectARea( cAliasSF3 )
	Do While .Not. ( cAliasSF3 )->( Eof() )
		aRet[1] := ( cAliasSF3 )->F3_NFISCAL
		aRet[2] := ( cAliasSF3 )->F3_SERIE
		SA2->( dbSeek( cFilSeek + ( cAliasSF3 )->F3_CLIEFOR + ( cAliasSF3 )->F3_LOJA )  )
		cCnpRem := SA2->A2_CGC
		cFornOri:= ( cAliasSF3 )->F3_CLIEFOR
		cLojaOri:= ( cAliasSF3 )->F3_LOJA
		if ( cAliasSF3 )->F3_TIPO $ "BD"
			cTipoNfo := ( cAliasSF3 )->F3_TIPO
			cFilSeek:= Iif(U_IsShared("SA1"),xFilial("SA1"),ZBZ->ZBZ_FILIAL)
			SA1->( dbSeek( cFilSeek + ( cAliasSF3 )->F3_CLIEFOR + ( cAliasSF3 )->F3_LOJA )  )
			cCnpRem := SA1->A1_CGC
		endif
		cFormul := ( cAliasSF3 )->F3_FORMUL
		if empty(cCc)
			SD1->( dbSetOrder( 1 ) )
			if SD1->( dbSeek( ZBZ->ZBZ_FILIAL + ( cAliasSF3 )->F3_NFISCAL + ( cAliasSF3 )->F3_SERIE + ( cAliasSF3 )->F3_CLIEFOR + ( cAliasSF3 )->F3_LOJA ) )
				cCc := SD1->D1_CC
			endif
		endif
		( cAliasSF3 )->( dbSkip() )
	EndDo
EndIf

DbSelectArea(cAliasSF3)
DbCloseArea()
RestArea(aArea)
Return( aRet )


Static Function ExistDoc( cNfOri, cSerOri, cFornOri, cLojaOri, cTipoNfo, cFormul, cCc )  //Ver se poe zeros a Frente ou nใo
Local aArea   := GetArea()
Local lAcho   := .T.
Local xNfOri  := cNfOri
Local xSerOri := cSerOri

DbSelectArea( "SF2" )
DbSetOrder( 1 )

lAcho := SF2->( DbSeek( xFilial("SF2") + xNfOri + xSerOri ) )

If .Not. lAcho
	xNfOri  := Substr( AllTrim( Str( val(xNfOri) ) ) + space(len(SF2->F2_DOC)), 1, len(SF2->F2_DOC) )
	xSerOri := Substr( AllTrim( Str( val(xSerOri) ) ) + space(len(SF2->F2_SERIE)), 1, len(SF2->F2_SERIE) )
	lAcho := SF2->( DbSeek( xFilial("SF2") + xNfOri + xSerOri ) )

	if .Not. lAcho
		xNfOri  := StrZero( Val(xNfOri), len(SF2->F2_DOC) )
		xSerOri := StrZero( Val(xSerOri), len(SF2->F2_SERIE) )
		lAcho   := SF2->( DbSeek( xFilial("SF2") + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := StrZero( Val(xNfOri), len(SF2->F2_DOC) )
		xSerOri := Substr( AllTrim( Str( val(xSerOri) ) ) + space(len(SF2->F2_SERIE)), 1, len(SF2->F2_SERIE) )
		lAcho   := SF2->( DbSeek( xFilial("SF2") + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := Substr( AllTrim( Str( val(xNfOri) ) ) + space(len(SF2->F2_DOC)), 1, len(SF2->F2_DOC) )
		xSerOri := StrZero( Val(xSerOri), len(SF2->F2_SERIE) )
		lAcho   := SF2->( DbSeek( xFilial("SF2") + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := Substr( AllTrim( Str( val(xNfOri), 6, 0 ) ) + space(len(SF2->F2_DOC)), 1, len(SF2->F2_DOC) )
		xSerOri := StrZero( Val(xSerOri), len(SF2->F2_SERIE) )
		lAcho   := SF2->( DbSeek( xFilial("SF2") + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := Substr( AllTrim( Str( val(xNfOri), 6, 0 ) ) + space(len(SF2->F2_DOC)), 1, len(SF2->F2_DOC) )
		xSerOri := Substr( AllTrim( Str( val(xSerOri) ) ) + space(len(SF2->F2_SERIE)), 1, len(SF2->F2_SERIE) )
		lAcho   := SF2->( DbSeek( xFilial("SF2") + xNfOri + xSerOri ) )
	Endif

EndIf
if lAcho
		cNfOri  := xNfOri
		cSerOri := xSerOri
		cFornOri:= SF2->F2_CLIENTE
		cLojaOri:= SF2->F2_LOJA
		cTipoNfo:= SF2->F2_TIPO
		cFormul := SF2->F2_FORMUL
		SD2->( dbSetOrder( 3 ) )
		if SD2->( dbSeek( SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
			cCc := SD2->D2_CCUSTO
		endif
Endif

RestArea(aArea)
Return( NIL )


Static Function ExistSf3( cNfOri, cSerOri, cFornOri, cLojaOri, cTipoNfo, cFormul, cCc )  //Ver se poe zeros a Frente ou nใo
Local aArea   := GetArea()
Local lAcho   := .T.
Local xNfOri  := cNfOri
Local xSerOri := cSerOri
Local cCod    := ""
Local cLoj    := ""
Local cFilSeek:= Iif(U_IsShared("SA2"),xFilial("SA2"),ZBZ->ZBZ_FILIAL)

SA2->( dbSetOrder( 3 ) )
If SA2->( DbSeek( cFilSeek + cCnpRem ) )
	cCod := SA2->A2_COD
	cLoj := SA2->A2_LOJA
	cFornOri:= SA2->A2_COD
	cLojaOri:= SA2->A2_LOJA
EndIf
If empty(cCod) .and. empty(cLoj) //para ver se ้ Bene ou Devole
	cFilSeek:= Iif(U_IsShared("SA1"),xFilial("SA1"),ZBZ->ZBZ_FILIAL)
	SA1->( dbSetOrder( 3 ) )
	If SA1->( DbSeek( cFilSeek + cCnpRem ) )
		cCod := SA1->A1_COD
		cLoj := SA1->A1_LOJA
		cFornOri:= SA1->A1_COD
		cLojaOri:= SA1->A1_LOJA
	EndIf
endif


DbSelectArea( "SF3" )
DbSetOrder( 4 )

lAcho := SF3->( DbSeek( ZBZ->ZBZ_FILIAL + cCod + cLoj + xNfOri + xSerOri ) )

If .Not. lAcho
	xNfOri  := Substr( AllTrim( Str( val(xNfOri) ) ) + space(len(SF3->F3_NFISCAL)), 1, len(SF3->F3_NFISCAL) )
	xSerOri := Substr( AllTrim( Str( val(xSerOri) ) ) + space(len(SF3->F3_SERIE)), 1, len(SF3->F3_SERIE) )
	lAcho := SF3->( DbSeek( ZBZ->ZBZ_FILIAL + cCod + cLoj + xNfOri + xSerOri ) )

	if .Not. lAcho
		xNfOri  := StrZero( Val(xNfOri), len(SF3->F3_NFISCAL) )
		xSerOri := StrZero( Val(xSerOri), len(SF3->F3_SERIE) )
		lAcho   := SF3->( DbSeek( ZBZ->ZBZ_FILIAL + cCod + cLoj + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := StrZero( Val(xNfOri), len(SF3->F3_NFISCAL) )
		xSerOri := Substr( AllTrim( Str( val(xSerOri) ) ) + space(len(SF3->F3_SERIE)), 1, len(SF3->F3_SERIE) )
		lAcho   := SF3->( DbSeek( ZBZ->ZBZ_FILIAL + cCod + cLoj + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := Substr( AllTrim( Str( val(xNfOri) ) ) + space(len(SF3->F3_NFISCAL)), 1, len(SF3->F3_NFISCAL) )
		xSerOri := StrZero( Val(xSerOri), len(SF3->F3_SERIE) )
		lAcho   := SF3->( DbSeek( ZBZ->ZBZ_FILIAL + cCod + cLoj + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := Substr( AllTrim( Str( val(xNfOri), 6, 0 ) ) + space(len(SF3->F3_NFISCAL)), 1, len(SF3->F3_NFISCAL) )
		xSerOri := StrZero( Val(xSerOri), len(SF3->F3_SERIE) )
		lAcho   := SF3->( DbSeek( ZBZ->ZBZ_FILIAL + cCod + cLoj + xNfOri + xSerOri ) )
	Endif

	if .Not. lAcho
		xNfOri  := Substr( AllTrim( Str( val(xNfOri), 6, 0 ) ) + space(len(SF3->F3_NFISCAL)), 1, len(SF3->F3_NFISCAL) )
		xSerOri := Substr( AllTrim( Str( val(xSerOri) ) ) + space(len(SF3->F3_SERIE)), 1, len(SF3->F3_SERIE) )
		lAcho   := SF3->( DbSeek( ZBZ->ZBZ_FILIAL + cCod + cLoj + xNfOri + xSerOri ) )
	Endif

EndIf
if lAcho
	cNfOri  := xNfOri
	cSerOri := xSerOri
	if SF3->F3_TIPO $ "BD"
		cFornOri := SF3->F3_CLIEFOR
		cLojaOri := SF3->F3_LOJA
		cTipoNfo := SF3->F3_TIPO
	endif
	cFormul := SF3->F3_FORMUL
	SD1->( dbSetOrder( 1 ) )
	if SD1->( dbSeek( SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA ) )
		cCc := SD1->D1_CC
	endif
Endif

RestArea(aArea)
Return( NIL )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML02CTEบ Autor ณEneovaldo Roveri Jr.บ Data ณ  13/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Menu de Notas de Conhecimento de Frete (CT-e)              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML02CTE
Local lOk := .T.     
Local aArea:= GetArea()
Local cMsg := "Gerando o Nota de Conhecimento de Transporte..."

If ZBZ->(FieldPos("ZBZ_STATUS"))>0 
	If ZBZ->ZBZ_STATUS <>"1"
		lOk:= .F.   
   		MsgStop("Esta rotina nใo pode ser executada em um registro com erros na importa็ใo.")
	EndIf	
EndIf

If ZBZ->(FieldPos("ZBZ_PROTC"))>0  .And. AllTrim(ZBZ->ZBZ_PROTC) <> ""
	lOk:= .F.   
	MsgStop("Este xml foi cancelado pelo emissor.Nใo pode ser gerada e pr้-nota.")
EndIf

If Empty(ZBZ->ZBZ_CODFOR) .Or. Empty(ZBZ->ZBZ_LOJFOR)
	lOk:= .F.   
	MsgStop("Este XML nใo possui fornecedor associado. Clique em A็๕es Relacionadas / Fun็๕es XML / Alterar e Associe o Fornecedor de Acordo com o CNPJ. Caso nใo Tenha Fornecedor Cadastrado com o CNPJ, fa็a-o no Cadastro de Fornecedor.")
EndIf

If lOk
	cXMLExp    := ZBZ->ZBZ_XML
	
	If ZBZ->ZBZ_MODELO == "55"
		U_MyAviso("Aviso","Este XML ้ modelo 55 (NF-e). Clique em gera pr้-nota.",{"OK"},2)
   	ELseIf ZBZ->ZBZ_MODELO == "57"
		//U_MyAviso("Aviso","Em Desenvolvimento",{"OK"},2)
		Processa( {|| XMLNFCTE() }, "Aguarde...", "Gerando a Nota de Conhecimento de Transporte ...",.F.)
	EndIf
    
EndIf
                       
RestArea(aArea)
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XMLNFCTE บ Autor ณ Eneovaldo Roveri Jrบ Data ณ  13/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ CTe dos Fornecedores                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function XMLNFCTE()
Local cError    := ""
Local cWarning  := ""
Local lRetorno  := .F.
Local aLinha    := {}
Local nX        := 0
Local nY        := 0
Local cDoc      := ""
Local lOk       := .T.
Local aProdOk   := {}
Local aProdNo   := {}
Local aProdVl   := {}
Local aProdZr   := {}
Local oDlg
Local aArea       := GetArea()
Local nTamProd    := TAMSX3("B1_COD")[1]
Local lPergunta   := .F.
Local cTesPcNf    := GetNewPar("MV_TESPCNF","") // Tes que nao necessita de pedido de compra amarrado
Local lPCNFE      := GetNewPar("MV_PCNFE",.F.)
Local nQuant      := 0
Local nVunit      := 0
Local nTotal      := 0
Local cUm         := "  "
Local nErrItens   := 0
Local nD1Item     := 0
Local oIcm
Local cKeyFe	  := SetKEY( VK_F3 ,  Nil )
Local cFornOri	  := space( len(SF1->F1_FORNECE) )
Local cLojaOri	  := space( len(SF1->F1_LOJA) )
Local cTipoNfo    := "N"
Local cFormul     := space( len(SF2->F2_FORMUL) )

Private oFont01   := TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
Private oXml
Private oDet, oOri
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.
Private aCabec      := {}
Private aItens      := {}
Private cProduto  := "" //nTamProd
Private cCnpjEmi  := ""
Private cCodEmit  := ""
Private cLojaEmit := ""
Private nFormCTE  := Val(GetNewPar("XM_FORMCTE","9"))
Private cEspecCte := GetNewPar("XM_ESP_CTE","CTE")
Private cModelo   := ZBZ->ZBZ_MODELO
Private aItXml    := {}
Private cAmarra   := GetNewPar("XM_DE_PARA","0")
Private aPerg     := {}
Private aCombo    := {}
Private nAliqCTE  := 0, nBaseCTE := 0, nPedagio := 0, lDetPed := .T.
Private cPCSol    := GetNewPar("XM_CSOL","A")
Private lNfOri    := .T. //( GetNewPar("XM_NFORI","N") == "S" )//Aqui sempre serแ pelo SF3 documento de entrada
Private cCnpRem   := ""                                        //pois a rotina MATA116 utiliza apenas entradis
Private lSerEmp   := .NOT. Empty( AllTrim(GetNewPar("XM_SEREMP","")) )
Private lTemFreXml:= .F., lTemDesXml := .F., lTemSegXml := .F.

cPref    := "CT-e"
cTAG     := "CTE"
nFormXML := nFormCte
cEspecXML:= cEspecCte
lPergunta:= .F.

cPerg := "IMPXML"
ValidPerg1(cPerg)


aParam   := {" "}
cParXMLExp := cNumEmp+"IMPXML"
cExt     := ".xml"
cNfes    := ""

aAdd( aCombo, "1=Padrใo(SA5/SA7)" )
aAdd( aCombo, "2=Customizada(ZB5)")
aAdd( aCombo, "3=Sem Amarra็ใo"   )

aadd(aPerg,{2,"Amarra็ใo Produto","",aCombo,120,".T.",.T.,".T."})

aParam[01] := ParamLoad(cParXMLExp,aPerg,1,aParam[01])

If cAmarra $ "0,4" //.And. !cModelo $ "57"  0,4 -> 4 - Pedido, pedir amarra็ใo
	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
	DbSelectArea("SF1")
	DbSetOrder(1)

	lSeekNF := DbSeek(cChaveF1)

	If lSeekNf
		U_MyAviso("Aten็ใo","Esta NFE jแ foi importada para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
		lRetorno := .F.
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	EndIf

	If !ParamBox(aPerg,"Importa XML - Amarra็ใo",@aParam,,,,,,,cParXMLExp,.T.,.T.)
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	Else 
   		cAmarra  := aParam[01]
	EndIf
EndIf

If lPergunta
	lContImp := Pergunte(cPerg,.T.)
	If !lContImp
		SetKEY( VK_F3 ,  cKeyFe )
		Return()
	EndIf
ELse
	lContImp:= .T.
EndIf

cTipoCPro := MV_PAR02
cTipoCPro := cAmarra
oXml := XmlParser(ZBZ->ZBZ_XML, "_", @cError, @cWarning )

If oXml == NIL .Or. !Empty(cError) .Or. !Empty(cWarning)
	MsgSTOP("XML Invalido ou Nใo Encontrado, a Importa็ใo Nใo foi Efetuada.")
	SetKEY( VK_F3 ,  cKeyFe )
	Return
EndIf

cTagTpEmiss:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPEMIS:TEXT"
cTagTpAmb  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_TPAMB:TEXT"
cTagCHId   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_ID:TEXT"
cTagSign   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_SIGNATURE"
cTagProt   := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_NPROT:TEXT"
cTagKey    := "oXml:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_CH"+cTAG+":TEXT"
cTagDocEmit:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_EMIT:_CNPJ:TEXT"

cTagDocXMl := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_N"+Left(cTAG,2)+":TEXT"
cTagSerXml := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_SERIE:TEXT"

If cModelo == "57"
		cTagDtEmit := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IDE:_DHEMI:TEXT"
		cTagDocDest:= "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_REM:_CNPJ:TEXT"
		cTagAliq   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS00:_PICMS:TEXT"
		//Incluindo a TAG ICMS20 pelo Analista Alexandro de Oliveira - 16/12/2014
		cTagAliq1  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS20:_PICMS:TEXT"
		If Type(cTagAliq)<> "U"
	   		nAliqCTE   := Val(&(cTagAliq))
	   	ElseIf Type(cTagAliq1)<>"U"
	   	    nAliqCTE  := Val(&(cTagAliq1))
	   	EndIf	
		cTagBase   := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS00:_VBC:TEXT"
		//Incluindo a TAG ICMS20 pelo Analista Alexandro de Oliveira - 16/12/2014
		cTagBase1  := "oXml:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_IMP:_ICMS:_ICMS20:_VBC:TEXT"
		If Type(cTagBase)<> "U"
	   		nBaseCTE   := Val(&(cTagBase))
	   	ElseIf Type(cTagBase1)<> "U"
	   		nBaseCTE   := Val(&(cTagBase1))
	   	EndIf
	   	nPedagio := 0
	   	If Type( "oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP" ) != "U"
			oDet := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP
			oDet := iif( ValType(oDet) == "O", {oDet}, oDet )
			For i := 1 to Len( oDet )
				If AllTRim( UPPER(oDet[i]:_XNOME:TEXT) ) $ "PEDAGIO,PED..GIO"
	   				nPedagio := Val(oDet[i]:_VCOMP:TEXT)
	   			EndIf
	   		Next i
	   	EndIf
Else
		cTagDtEmit := ""
		cTagDocDest:= ""
EndIf

cCodEmit  := ZBZ->ZBZ_CODFOR
cLojaEmit := ZBZ->ZBZ_LOJFOR
cDocXMl   := Iif(nFormXML > 0,StrZero(Val(&(cTagDocXMl)),nFormXML),&(cTagDocXMl))
cSerXml   := &(cTagSerXml)

//Alterado para atender ao empresa ITAMBษ - 16/10/2014
if ( GetNewPar("XM_SERXML","N") == "S" )
	If alltrim( cSerXml ) == '0' .or. alltrim( cSerXml ) == '00' .or. alltrim( cSerXml ) == '000'
		cSerXml := '   '
	EndIf
elseIf ( GetNewPar("XM_SERXML","N") == "Z" )
   	If Empty(cSerXml)
   	    cSerXml := '0'	
    Endif
endif
cSerXml := Substr(cSerXml + space(len(SF1->F1_SERIE)), 1, len(SF1->F1_SERIE) )
if lSerEmp
	cSerXml := ZBZ->ZBZ_SERIE
endif

cChaveXml := &(cTagKey)
cDtEmit   := &(cTagDtEmit)
dDataEntr := StoD(substr(cDtEmit,1,4)+Substr(cDtEmit,6,2)+Substr(cDtEmit,9,2))

aCabec := {}
aadd(aCabec,{"F1_DTDIGIT",dDataBase-90})
aadd(aCabec,{"F1_DTDIGIT",dDataBase  })		//dDataFim	   := aAutoCab[2,2]
aadd(aCabec,{""	         ,1          })		//nRotina      := aAutoCab[3,2]
aadd(aCabec,{"F1_FORNECE",space( len(SF1->F1_FORNECE) )})		//cFornOri	   := aAutoCab[4,2]
aadd(aCabec,{"F1_LOJA"   ,space( len(SF1->F1_LOJA) )   })		//cLojaOri	   := aAutoCab[5,2]
aadd(aCabec,{""          ,1          })		//nTipoOri	   := aAutoCab[6,2]
aadd(aCabec,{""          ,1          })		//lAglutProd     := If(aAutoCab[7,2]==1,.T.,.F.)
aadd(aCabec,{"F1_EST"    ,ZBZ->ZBZ_UF})		//cUFOri         := aAutoCab[8,2]
aadd(aCabec,{"F1_VALBRUT",0          })		//valoire := aAutoCab[9,2]
aadd(aCabec,{"F1_FORMUL" ,1          })		//Formulario p๓prio 1=Non        := aAutoCab[10,2]
aadd(aCabec,{"F1_DOC"    ,cDocXMl    })		//c116NumNF	    := If(l116Auto,aAutoCab[11,2],CriaVar("F1_DOC",.F.))
aadd(aCabec,{"F1_SERIE"  ,cSerXml    })		//c116SerNF	    := If(l116Auto,aAutoCab[12,2],CriaVar("F1_SERIE",.F.))
aadd(aCabec,{"F1_FORNECE",cCodEmit   })		//c116Fornece   := If(l116Auto,aAutoCab[13,2],CriaVar("F1_FORNECE",.F.))
aadd(aCabec,{"F1_LOJA"   ,cLojaEmit  })     //c116Loja	    := If(l116Auto,aAutoCab[14,2],CriaVar("F1_LOJA",.F.))
aadd(aCabec,{"D1_TES"    ,space(len(SD1->D1_TES))})     //c116Tes	    := If(l116Auto,aAutoCab[15,2],CriaVar("D1_TES",.F.))
aadd(aCabec,{"D1_BRICMS" ,0          })     //Base ICMS
aadd(aCabec,{"D1_ICMSRET",0          })     //ICMS Retido
aadd(aCabec,{"F1_ESPECIE",cEspecXML  })     //c116Especie   := If(l116Auto,aAutoCab[18,2],CriaVar("F1_ESPECIE",.F.))
aadd(aCabec,{"F1_CHVNFE" ,cChaveXml}) //nosso
aadd(aCabec,{"F1_VALPEDG",nPedagio }) //nosso
aadd(aCabec,{"NF_BASEICM",nBaseCTE   })     //Base ICMS
aadd(aCabec,{"NF_VALICM" ,nBaseCTE*(nAliqCte/100)})     //ICMS Retido
aadd(aCabec,{"F1_EMISSAO",dDataEntr }) 

lCadastra := .F.

Do while nErrItens < 2
 	nErrItens++
 	lRetorno := .T.
 	aLinha   := {}
 	aProdOk  := {}
 	aProdNo  := {}
 	aProdZr  := {}
 	aProdVl  := {}
 	aItens   := {}

	lRetorno := .T.
	cCnpRem := ""
	if lNfOri
		if Type(cTagDocDest) != "U"
			cCnpRem := &cTagDocDest
		endif
	endif

	oDet := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST
	cProdCte := Padr(GetNewPar("XM_PRODCTE","FRETE"),nTamProd)
    cProdCte :=Iif(Empty(cProdCte),Padr("FRETE",nTamProd),cProdCte)
	If cTipoCPro == "2" // Ararracao Customizada ZB5 Produto tem que estar Amarrados Tanto Cliente como Formecedor
		cProduto := ""

		DbSelectArea("ZB5")
		DbSetOrder(1)
		// Filial + CNPJ FORNECEDOR + Codigo do Produto do Fornecedor
		If DbSeek(xFilial("ZB5")+PADR(ZBZ->ZBZ_CNPJ,14)+cProdCte)
			cProduto := ZB5->ZB5_PRODFI
			lRetorno := .T.
			aadd(aProdOk,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		Else
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		EndIf

	//##################################################################
	ElseIf cTipoCPro == "1" // Amarracao Padrao SA5/SA7

		cProduto  := ""
		if empty( cCodEmit )
			cCodEmit  := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_COD")
			cLojaEmit := Posicione("SA2",3,xFilial("SA2")+ZBZ->ZBZ_CNPJ,"A2_LOJA")
		endif

		cAliasSA5 := GetNextAlias()

		cWhere := "%(SA5.A5_CODPRF IN ("
		cWhere += "'"+AllTrim(cProdCte)+"'"
		cWhere += ") )%"

		BeginSql Alias cAliasSA5

		SELECT	A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF, A5_PRODUTO, R_E_C_N_O_ 
				FROM %Table:SA5% SA5
				WHERE SA5.%notdel%
	    		AND A5_FORNECE = %Exp:cCodEmit%
	    		AND A5_LOJA = %Exp:cLojaEmit%
	    		AND %Exp:cWhere%
	    		ORDER BY A5_FILIAL, A5_FORNECE, A5_LOJA, A5_CODPRF
		EndSql

		DbSelectArea(cAliasSA5)
		Dbgotop()
        lFound := .F.
        cKeySa5:= xFilial("SA5")+cCodEmit+cLojaEmit+cProdCte
        While !(cAliasSA5)->(EOF())
			cKeyTMP := (cAliasSA5)->A5_FILIAL+(cAliasSA5)->A5_FORNECE+(cAliasSA5)->A5_LOJA+(cAliasSA5)->A5_CODPRF
			If 	AllTrim(cKeySa5) == AllTrim(cKeyTMP)
        		lFound := .T.
        		Exit
        	Endif
        	(cAliasSA5)->(DbSkip())
        Enddo


		If lFound
			cProduto := (cAliasSA5)->A5_PRODUTO

			lRetorno := .T.
			aadd(aProdOk,{cProduto,"PRESTACAO DE SERVICO - FRETE"} )
		Else
			cProduto := cProdCte
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		EndIf

		DbCloseArea()


	//##################################################################
	ElseIf cTipoCPro = "3" // Mesmo Codigo Nao requer amarracao SB1
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+cProdCte)
			cProduto := Substr(cProdCte,1,15)
			lRetorno := .T.
			aadd(aProdOk,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		Else
			aadd(aProdNo,{cProdCte,"PRESTACAO DE SERVICO - FRETE"} )
		EndIF
	EndIf

	If Type("oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		For i := 1 To Len(oOri)

			aLinha := {}
			cFornOri := space( len(SF1->F1_FORNECE) )
			cLojaOri := space( len(SF1->F1_LOJA) )
			cTipoNfo := "N"
			cFormul  := space( len(SF2->F2_FORMUL) )
			cNfOri   := oOri[i]:_NDOC:TEXT
			if Val(cNfOri) > 0
				cNfOri := StrZero( Val(cNfOri), len(SD1->D1_NFORI) )
			endif
			cSerOri := AllTrim( oOri[i]:_SERIE:TEXT )
			cCnpRem := ""

			if lNfOri
				if Type(cTagDocDest) != "U"
					cCnpRem := &cTagDocDest
				endif
				if .not. empty(cCnpRem)
					ExistSf3( @cNfOri, @cSerOri, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )
				endif
			else //aqui nunca entrarแ to for็ando o Bixo
				ExistDoc( @cNfOri, @cSerOri, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )
			endif
			aadd(aLinha,{"D1_NFORI"  ,cNfOri			     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_FORNECE",cFornOri				 ,Nil})
			aadd(aLinha,{"D1_LOJA"   ,cLojaOri				 ,Nil})
			aadd(aLinha,{"D1_TIPO"   ,cTipoNfo				 ,Nil})
			aadd(aLinha,{"D1_FORMUL" ,cFormul				 ,Nil})

			aadd(aItens,aLinha)
			if Empty( aCabec[4,2] )
				aCabec[4,2] := cFornOri
				aCabec[5,2] := cLojaOri
				aCabec[6,2] := iif( cTipoNfo $ "D|B", 2, 1 )
			endif
			cChaveF1 := ZBZ->ZBZ_FILIAL + cNfOri + cSerOri + cFornOri + cLojaOri + cTipoNfo
			SF1->( DbSetOrder(1) )
			If SF1->( DbSeek(cChaveF1) )
				If SF1->F1_DTDIGIT < aCabec[1,2]
					aCabec[1,2] := SF1->F1_DTDIGIT
				EndIf
			EndIf

		Next i

	ElseIf Type("oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		For i := 1 To Len(oOri)

            cCnpRem  := ""
			cFornOri := space( len(SF1->F1_FORNECE) )
			cLojaOri := space( len(SF1->F1_LOJA) )
			cTipoNfo := "N"
			cFormul  := space( len(SF2->F2_FORMUL) )
			aLinha := {}
			if lNfOri
				aDocDaChave := Sf3DaChave( oOri[i]:_CHAVE:TEXT, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )  //Pegar Documentos no SF3
			else  //aqui nunca entrarแ to for็ando o Bixo
				aDocDaChave := DocDaChave( oOri[i]:_CHAVE:TEXT, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )  //Pegar Documentos no SF2
			endif
			cNfOri := aDocDaChave[1]
			cSerOri := aDocDaChave[2]
			aadd(aLinha,{"D1_NFORI"  ,cNfOri			     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_FORNECE",cFornOri				 ,Nil})
			aadd(aLinha,{"D1_LOJA"   ,cLojaOri				 ,Nil})
			aadd(aLinha,{"D1_TIPO"   ,cTipoNfo				 ,Nil})
			aadd(aLinha,{"D1_FORMUL" ,cFormul				 ,Nil})

			aadd(aItens,aLinha)
			if Empty( aCabec[4,2] )
				aCabec[4,2] := cFornOri
				aCabec[5,2] := cLojaOri
				aCabec[6,2] := iif( cTipoNfo $ "D|B", 2, 1 )
			endif
			cChaveF1 := ZBZ->ZBZ_FILIAL + cNfOri + cSerOri + cFornOri + cLojaOri + cTipoNfo
			SF1->( DbSetOrder(1) )
			If SF1->( DbSeek(cChaveF1) )
				If SF1->F1_DTDIGIT < aCabec[1,2]
					aCabec[1,2] := SF1->F1_DTDIGIT
				EndIf
			EndIf


		Next i

	ElseIf Type("oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		For i := 1 To Len(oOri)

			aLinha := {}
			cFornOri := space( len(SF1->F1_FORNECE) )
			cLojaOri := space( len(SF1->F1_LOJA) )
			cTipoNfo := "N"
			cFormul  := space( len(SF2->F2_FORMUL) )
			cNfOri := oOri[i]:_NDOC:TEXT
			if Val(cNfOri) > 0
				cNfOri := StrZero( Val(cNfOri), len(SD1->D1_NFORI) )
			endif
			cSerOri := AllTrim( oOri[i]:_SERIE:TEXT )
			cCnpRem := ""
			if lNfOri
				if Type(cTagDocDest) != "U"
					cCnpRem := &cTagDocDest
				endif
				if .not. empty(cCnpRem)
					ExistSf3( @cNfOri, @cSerOri, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )
				endif
			else  //Aqui nunca entrarแ to for็ando o Bixo
				ExistDoc( @cNfOri, @cSerOri, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )
			endif
			aadd(aLinha,{"D1_NFORI"  ,cNfOri			     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_FORNECE",cFornOri				 ,Nil})
			aadd(aLinha,{"D1_LOJA"   ,cLojaOri				 ,Nil})
			aadd(aLinha,{"D1_TIPO"   ,cTipoNfo				 ,Nil})
			aadd(aLinha,{"D1_FORMUL" ,cFormul				 ,Nil})

			aadd(aItens,aLinha)
			if Empty( aCabec[4,2] )
				aCabec[4,2] := cFornOri
				aCabec[5,2] := cLojaOri
				aCabec[6,2] := iif( cTipoNfo $ "D|B", 2, 1 )
			endif
			cChaveF1 := ZBZ->ZBZ_FILIAL + cNfOri + cSerOri + cFornOri + cLojaOri + cTipoNfo
			SF1->( DbSetOrder(1) )
			If SF1->( DbSeek(cChaveF1) )
				If SF1->F1_DTDIGIT < aCabec[1,2]
					aCabec[1,2] := SF1->F1_DTDIGIT
				EndIf
			EndIf

		Next i

	ElseIf Type("oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE") != "U"
		oOri := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE  
		oOri := IIf(ValType(oOri)=="O",{oOri},oOri)

		For i := 1 To Len(oOri)

			aLinha   := {}
			cFornOri := space( len(SF1->F1_FORNECE) )
			cLojaOri := space( len(SF1->F1_LOJA) )
			cTipoNfo := "N"
			cFormul  := space( len(SF2->F2_FORMUL) )
			cCnpRem  := ""
			if lNfOri
				aDocDaChave := Sf3DaChave( oOri[i]:_CHAVE:TEXT, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )  //Pegar Documentos no SF3
			else  //aqui nunca entrarแ to for็ando o Bixo
				aDocDaChave := DocDaChave( oOri[i]:_CHAVE:TEXT, @cFornOri, @cLojaOri, @cTipoNfo, @cFormul )  //Pegar Documentos no SF2
			endif
			cNfOri := aDocDaChave[1]
			cSerOri := aDocDaChave[2]
			aadd(aLinha,{"D1_NFORI"  ,cNfOri			     ,Nil})
			aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
			aadd(aLinha,{"D1_FORNECE",cFornOri				 ,Nil})
			aadd(aLinha,{"D1_LOJA"   ,cLojaOri				 ,Nil})
			aadd(aLinha,{"D1_TIPO"   ,cTipoNfo				 ,Nil})
			aadd(aLinha,{"D1_FORMUL" ,cFormul				 ,Nil})

			aadd(aItens,aLinha)
			if Empty( aCabec[4,2] )
				aCabec[4,2] := cFornOri
				aCabec[5,2] := cLojaOri
				aCabec[6,2] := iif( cTipoNfo $ "D|B", 2, 1 )
			endif
			cChaveF1 := ZBZ->ZBZ_FILIAL + cNfOri + cSerOri + cFornOri + cLojaOri + cTipoNfo
			SF1->( DbSetOrder(1) )
			If SF1->( DbSeek(cChaveF1) )
				If SF1->F1_DTDIGIT < aCabec[1,2]
					aCabec[1,2] := SF1->F1_DTDIGIT
				EndIf
			EndIf

		Next i

	Else
		aLinha := {}
		cFornOri := space( len(SF1->F1_FORNECE) )
		cLojaOri := space( len(SF1->F1_LOJA) )
		cTipoNfo := "N"
		cFormul  := space( len(SF2->F2_FORMUL) )

		aadd(aLinha,{"D1_NFORI"  ,cNfOri			     ,Nil})
		aadd(aLinha,{"D1_SERIORI",cSerOri				 ,Nil})
		aadd(aLinha,{"D1_FORNECE",cFornOri				 ,Nil})
		aadd(aLinha,{"D1_LOJA"   ,cLojaOri				 ,Nil})
		aadd(aLinha,{"D1_TIPO"   ,cTipoNfo				 ,Nil})
		aadd(aLinha,{"D1_FORMUL" ,cFormul				 ,Nil})

		aadd(aItens,aLinha)

	EndIf
	
	aCabec[9,2] := VAL(oDet:_VTPREST:TEXT)
	if aCabec[9,2] == nBaseCTE //Conforme Zanete em 02/02/2015, se o Valor do Frete For Igual da Base do ICMS, nใo rateia o Pedagio nos itens
		lDetPed := .F.
//		if nPedagio > 0
//			nBaseCTE := nBaseCTE - nPedagio
//			if nBaseCTE > 0
//				aCabec[21,2] := nBaseCTE
//				aCabec[22,2] := nBaseCTE*(nAliqCte/100)
//			endif
//		endif
	endif

	If .not. empty( cProduto )
		if SB1->( DbSeek(xFilial("SB1")+cProduto) )
			If SB1->( FieldGet(FieldPos("B1_MSBLQL")) ) == "1"
				aadd(aProdNo,{cProduto,"Produto Bloqueado SB1->"+SB1->B1_DESC} )
			EndIf
			aCabec[15,2] := SB1->B1_TE
		ElseIf cTipoCPro != "3"
			aadd(aProdNo,{cProduto,"Nใo Cadastrado SB1->"+"PRESTACAO DE SERVICO - FRETE"} )
		EndIf
	EndIf

	if VAL(oDet:_VTPREST:TEXT) <= 0
		aadd(aProdZr, { "0001", cProdCte, cProduto, VAL(oDet:_VTPREST:TEXT), "PRESTACAO DE SERVICO - FRETE" } )
	endif

	aLinha := {}

	if .not. ItNaoEnc( "NFCF", aProdOk, aProdNo, aProdVl, @nErrItens, aProdZr )
	    lRetorno := .F.
		Loop
	endif

	cChaveF1 := ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_NOTA + ZBZ->ZBZ_SERIE + ZBZ->ZBZ_CODFOR + ZBZ->ZBZ_LOJFOR + ZBZ->ZBZ_TPDOC
	DbSelectArea("SF1")
	DbSetOrder(1)

	lSeekNF := DbSeek(cChaveF1)

	If !lSeekNf
		If ZBZ->ZBZ_PRENF $ "N|S"
			lOkGo := MsgYesNo("Pr้-nota gerada previamente mas foi excluida.Deseja prosseguir gerando novamente?","Aviso")
			If !lOkGo
				lRetorno := .F.
			EndIf
		EndIf
	Else
		U_MyAviso("Aten็ใo","Este CTE jแ foi importado para a Base!"+CRLF +"Chave :"+cChaveF1,{"OK"},3)
		lRetorno := .F.
	EndIf

 	Exit //s๓ para o nErrItens checar o erro, caso ele inclua pelo DePara a 2a vez estarแ certo e ele continuarแ com o aitens preenchido
EndDo

If lRetorno
	aCols    := {}
	aRetHead := {}
	aRetCol  := {}

	lSetPC := .F.

	If cModelo =='57'
//		If !Empty(cTesPcNf) .And. (Posicione("SB1",1,xFilial("SB1")+aItens[1][2][2],"B1_TE") $ AllTrim(cTesPcNf))
//			lSetPC := .T.
//		EndIf
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Inicio da Inclusao                                           |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lRetorno :=.T.// U_VisNota(cModelo, ZBZ->ZBZ_CNPJ,oXml, aCols, @aCabec, @aItens )
                         

	If lRetorno  
		xRet116 := .F.

		aAuxRot := aClone( aRotina )
		aRotina := get2Menu()    //Para nใo dar erro na rotina padrใo.

   		xRet116:= U_XMATA116(aCabec,aItens)

		aRotina := aClone( aAuxRot )

		lEditStat := .F.

		If lMsErroAuto .and. .Not. xRet116
			MOSTRAERRO()
			MsgSTOP("O documento de entrada nใo foi gerado.")
			lRetorno := .F.
		Else                              
		    lMsHelpAuto:=.F.
 
			If xRet116
				//If EditDocXml(cModelo,lSetPc,.F.,.F.)
				    U_MyAviso("Aviso","Gera็ใo da Nt de Frete Efetuada com Sucesso."+CRLF+" Utilize a op็ใo :"+CRLF+;
					"Movimento -> Nt. Conhec Frete"+CRLF+" para Verificar a Integridade dos Dados.",{"OK"},3)
					lEditStat := .T.
				//EndIf 
			EndIf	

			If lEditStat
				DbSelectArea("ZBZ")
				Reclock("ZBZ",.F.)
				ZBZ->ZBZ_PRENF  := Iif(Empty(SF1->F1_STATUS),'S','N')  
				ZBZ->ZBZ_TPDOC  := SF1->F1_TIPO
				ZBZ->ZBZ_CODFOR := SF1->F1_FORNECE
				ZBZ->ZBZ_LOJFOR := SF1->F1_LOJA						
				if FieldPos("ZBZ_MANIF") > 0
					ZBZ->ZBZ_MANIF	:= U_MANIFXML( AllTrim( ZBZ->ZBZ_CHAVE ), .T. )
				endif
				MsUnlock()     
			EndIf				
	
			lRetorno := .T.
		EndIf 
	EndIf
Endif
           
RestArea(aArea)
SetKEY( VK_F3 ,  cKeyFe )
Return


User Function ItNEnc( cTipoProc, aProdOk, aProdNo, aProdVl, nErrItens, aProdZr )
Local lRetorno := .T.
Private oFont01   := TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)

lRetorno := ItNaoEnc( cTipoProc, aProdOk, aProdNo, aProdVl, @nErrItens, aProdZr )

Return( lRetorno )


Static Function ChkTagNfe( cFileCfg )
Local nHandle := 0
Local cTags   := ""

If File(cFileCfg)
	Return( .T. )
EndIf

nHandle := FCreate(cFileCfg)

If nHandle <= 0
	Return( .F. )
Else
	cTags := U_HFXMLTAG()
	FWrite(nHandle, cTags)
	FClose(nHandle)
EndIf

Return( .T. )


User Function HF02CPG()  //GETESB
Local cRet := ""
Local nI   := 0
Private oDup

IF Type("oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_FAT") <> "U"
	oDup := oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_FAT
	oDup := IIf(ValType(oDup)=="O",{oDup},oDup)
	cRet += "FATURA" + CRLF
	For nI := 1 To Len(oDup)
		If Type( "oDup["+AllTrim(Str(nI))+"]:_nFat" ) <> "U"
			cRet += "FAT: " + oDup[nI]:_nFat:TEXT + " - "
		EndIf
		If Type( "oDup["+AllTrim(Str(nI))+"]:_vOrig" ) <> "U"
			cRet += "VR ORIG: "+oDup[nI]:_vOrig:TEXT + " - "
		EndIf
		If Type( "oDup["+AllTrim(Str(nI))+"]:_vDesc" ) <> "U"
			cRet += "DESC: "+oDup[nI]:_vDesc:TEXT + ""
		EndIf
		If Type( "oDup["+AllTrim(Str(nI))+"]:_vLiq" ) <> "U"
			cRet += "VR LIQ: "+oDup[nI]:_vLiq:TEXT + ""
		EndIf
		cRet += CRLF
	Next nI
	cRet += CRLF
EndIf


IF Type("oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP") <> "U"
	oDup := oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP
	oDup := IIf(ValType(oDup)=="O",{oDup},oDup)
	cRet += "DUPLICATAS" + CRLF
	For nI := 1 To Len(oDup)
		If Type( "oDup["+AllTrim(Str(nI))+"]:_nDup" ) <> "U"
			cRet += "DUP: " + oDup[nI]:_nDup:TEXT + " - "
		EndIf
		If Type( "oDup["+AllTrim(Str(nI))+"]:_dVenc" ) <> "U"
			cRet += "VENC: "+oDup[nI]:_dVenc:TEXT + " - "
		EndIf
		If Type( "oDup["+AllTrim(Str(nI))+"]:_vDup" ) <> "U"
			cRet += "VR: "+oDup[nI]:_vDup:TEXT + ""
		EndIf
		cRet += CRLF
	Next nI
EndIf

Return cRet


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_UPSTATXML()
        U_HF02CPG()
        U_HFXML02CTE()
        U_HFXML02ARC()
        U_HFXML02E()
        U_HFBOTFUN()
        U_COMP0012()
        U_HFXML02()
        U_HFXML02Z()
        U_HFXML02X()
        U_HFXML02V()
        U_HFXML02M()
        U_HFXML02D()
        U_HFXML02L()
        U_HFXML02P()
        U_HFTOPFUN()
        U_AUTOXML1()
        U_XMLPRTDOC()
        U_XGETFILS()
        U_WWY()
        U_WWW()
        U_UPFORXML()
        U_ITNENC()
        U_HFXMLSETCS()
        U_UPCONSXML()
	EndIF
Return(lRecursa)
