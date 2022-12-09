#Include "protheus.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDprincipalบAutor  ณOpvs(Warleson)      บ Data ณ  28/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gerencia contas para abertura de atendimento por e-mail   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso: M๓dulo Service Desk - Certisign
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function CTSDK07()

Local aCoord
Local aScreenRes
Local nLista :=0
Local nX
Local aSX3Header := {}
Local cTitle:=''
Local nGDAction := 0
Local aSX3Cols := {}
Local nPanel

Private oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oBtn11,oBtn12,oBtn13,oBtn14,oBtn15
Private nLen
Private aStru
Private lOrdem := .T.
Private aCoord		:= FwGetDialogSize( oMainWnd )
Private oListBox
Private aListBox
Private aGAtend		:= {} 					// Lista dos Grupos de Atendimento
Private cGrupos 	:= ''
Private lAdmin 		:= .F.
Private lGrupoAdmin	:= .F.
Private lSupervisor	:= .F.
PRivate cMsg1
PRivate cMsg2
Private oOK := LoadBitmap(GetResources(),'BR_VERDE')
Private oNO := LoadBitmap(GetResources(),'BR_VERMELHO')
private nNext := 0
PRivate oTFont := TFont():New('Segoe UI',,-12,.T.)
Private oWin01,oWin02,oWin03
Private oScroll
Private oScrol2
Private cAlias:='SZR'
Private aTELA[0][0]
Private aGETS[0]
Private ldet := .F.
Private nOpc
Private oSX3
Private oEnc01
Private cMemo1 := space(200)
Private oMGet1
Private cMemo2 := space(200)
Private oMGet2
Private cMemo3 := space(200)
Private oMGet3
Private cMemo4 := space(200)
Private oMGet4
Private cMemo5 := space(200)
Private oMGet5
Private cMemo6 := space(200)
Private oMGet6
Private _cCodigo
Private _cConta
Private _cGrupo
Private _cAssunto
Private _cOcorrencia
Private _cAcao
Private _c2Ocorrencia
Private _c2Acao
Private _cRegra
Private _cAtivada
Private _cDesgrupo
Private _cDesAssunto
Private _cDesOcorren
Private _cDesAcao
Private _c2DesOcorren
Private _c2DesAcao
PRivate _cCampo := "ZR_SERVER,ZR_PASMAIL"
Private _cEmail :=""

Private oDlg

SetPrvt("oWin02","oGrp1","oBtn1","oBtn2","oBtn3")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da MsMGet()             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aAlterEnch	:= {}						// Campos que podem ser editados na Enchoice
Private aPos		  	:= {000,000,080,400}		// Dimensao da MsMget em relacao ao Dialog  (LinhaI,ColunaI,LinhaF,ColunaF)
Private nModelo		:= 3						// Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Private lF3 		  	:= .F.						// Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Private lMemoria		:= .T.						// Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Private lColumn		:= .F.						// Indica se a apresentacao dos campos sera em forma de coluna
Private caTela 		:= ""						// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Private lNoFolder	:= .F.							// Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Private lProperty	:= .F.							// Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes

Private aCamposEnc := {} //Campos da enchoice

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o operador for supervisorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Val(Posicione( "SU7", 4, xFilial("SU7") + __cUserID, "U7_TIPO")) == 2 //SUPERVISOR
	lSupervisor := .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe a senha for do ADMINISTRADOR ou o usuario pertencer ณ
//ณao grupo de administradores                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ( __cUserID == "000000" )
	lAdmin := .T.
Else
	// Para verificar se faz parte do grupo de administradores
	PswOrder(1)
	If (PswSeek(__cUserID) )
		aGrupos := Pswret(1)
		If ( Ascan(aGrupos[1][10],"000000") <> 0 )
			lGrupoAdmin := .T.
		Endif
	Endif
Endif

If AliasIndic("AG9")
	dbSelectArea("AG9")//Tabela de Amarra็ใo Operador X Grupos de Atendimento
	DbSetOrder(1)
	DbSeek(xFilial("AG9") + AllTrim(TkOperador()))
	While !AG9->(EOF()) .AND. AG9->AG9_FILIAL==xFilial("AG9") .AND. AllTrim(AG9->AG9_CODSU7)==AllTrim(TkOperador())
		aAdd(aGAtend,AG9->AG9_CODSU0)
		AG9->(DbSkip())
	Enddo
EndIf

if len(aGAtend) > 0
	For x:=1 to len(aGAtend)
		if !(x==len(aGAtend))
			cGrupos+= "'"+aGAtend[x]+"',"
		Else
			cGrupos+= "'"+aGAtend[x]+"'"
		Endif
	Next
endif

if !empty(cGrupos) .or. lAdmin .or. lGrupoAdmin .or. lSupervisor
	aListBox    := buscadados()
Else
	//Usuarios que nao possuem perfil de atendimento (ou seja nao ' um grupo associado a ele)
	aListBox    := {}
Endif

aStru := (cAlias)->(DbStruct())

DEFINE MSDIALOG oDlg FROM aCoord[1],aCoord[2] TO aCoord[3],aCoord[4] TITLE "" Color CLR_BLACK,CLR_WHITE PIXEL  STYLE nOR(WS_VISIBLE,WS_POPUP) FONT oTFont

oFWLayer := FWLayer():New()
oFWLayer:init(oDlg, .T. )
oFWLayer:addCollumn( "Col01", 30, .T. )
oFWLayer:addCollumn( "Col02", 70, .F. )

oFWLayer:addWindow( "Col01", "Win01", "Minhas Contas [ "+ALLTRIM(cUserName)+" ]", 100, .F., .T.,{||})
oWin01 := oFWLayer:getWinPanel('Col01','Win01')

oFWLayer:addWindow( "Col02", "Win02","Configura็๕es", 50, .F., .T., {|| })
oWin02 := oFWLayer:getWinPanel('Col02','Win02')

oFWLayer:addWindow( "Col02","Win03", "Regras da Caixa de Entrada", 50, .F., .T., {|| })
oWin03 := oFWLayer:getWinPanel('Col02','Win03')

oPanel1 := TPanel():New(0,1,"",oWin02,,.F.,.F.,,,037,200,.F.)
oBtn1:= TButton():New(0,0,"Novo",oPanel1,{||U_Contas_email(3)},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn1:SetCss("QPushButton{ }");oBtn1:Align := CONTROL_ALIGN_TOP
oBtn2:= TButton():New(15,0,"Alterar",oPanel1,{||U_Contas_email(4)},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn2:SetCss("QPushButton{ }");oBtn2:Align := CONTROL_ALIGN_TOP
oBtn3:= TButton():New(30,0,"Excluir",oPanel1,{||U_Contas_email(5)},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn3:SetCss("QPushButton{ }");oBtn3:Align := CONTROL_ALIGN_TOP
oBtn4:= TButton():New(45,0,"Legenda",oPanel1,{||BrwLegenda('Confirgurar e-mail',"Legenda", {{"BR_VERDE","Registro Ativo"},{"BR_VERMELHO",	"Registro bloqueado"}})},037,012,,oTfont,,.T.,,"",,,,.F. )
oBtn4:SetCss("QPushButton{ }");oBtn4:Align := CONTROL_ALIGN_TOP
oBtn5:= TButton():New(60,0,"Sair"	,oPanel1,{||oDlg:end()},037,012,,oTfont,,.T.,,"",,,,.F. )/*;oBtn5:SetCss("QPushButton{"+GetCSSResource()+"}")*/;oBtn5:Align := CONTROL_ALIGN_TOP
oPanel1:Align :=  CONTROL_ALIGN_LEFT

oScroll := TscrollArea():New(oWin03,0,0,oWin03:nHeight,oWin03:nWidth,.T.,.T.,.T.)
oScroll:Align:= CONTROL_ALIGN_ALLCLIENT

@00,00 MSPANEL oPanel SIZE oWin03:nHeight,20 OF oWin03
oPanel:Align := CONTROL_ALIGN_TOP

oPanel4 := TPanel():New(0,1,"",oScroll,,.F.,.F.,,,200,12,.F.)
oBtn11:= TButton():New(00,0,"Novo"	,oPanel4,{||cargovisor(3)},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn11:SetCss("QPushButton{ }");oBtn11:Align := CONTROL_ALIGN_LEFT
oBtn12:= TButton():New(15,0,"Detalhes",oPanel4,{||cargovisor(4)},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn12:SetCss("QPushButton{ }");oBtn12:Align := CONTROL_ALIGN_LEFT
oBtn14:= TButton():New(30,0,"Copiar",oPanel4,{||_cEmail := aListBox[oListBox:nAt,3],oBtn15:Disable()},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn14:SetCss("QPushButton{ }");oBtn14:Align := CONTROL_ALIGN_LEFT
oBtn15:= TButton():New(45,0,"Colar",oPanel4,{||Copia_regras()},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn15:SetCss("QPushButton{ }");oBtn15:Align := CONTROL_ALIGN_LEFT
oBtn13:= TButton():New(60,0,"Excluir",oPanel4,{||Exclui_Regra()},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn13:SetCss("QPushButton{ }");oBtn13:Align := CONTROL_ALIGN_LEFT

oBtn15:Disable() //Colar regras
oPanel4:Align :=  CONTROL_ALIGN_TOP

if empty(aListBox)
	aListBox:={{.F.,'','Nใo hแ contas para esse perfil...',0}}
	oBtn2:Disable()		// Alterar Conta
	oBtn3:Disable() 	// Excluir conta
	oBtn11:Disable()	// Nova Regra para a conta jแ criada
	oBtn15:Disable()
Else
	oBtn2:Enable()
	oBtn3:Enable()
	oBtn11:Enable()
	if !empty(_cEmail) .and. !(alltrim(_cEmail)==alltrim(aListBox[oListBox:nAt,3]))
		oBtn15:Enable()
	Else
		oBtn15:Disable()
	Endif
endif

if lAdmin .or. lGrupoAdmin
	// administrador ou grupo de administrador
	cMsg1:= "Escolha como os emails serใo tratatos. As regras serใo aplicadas na ordem exibida. Para que uma regra nใo seja executada,"
	cMsg2:=	"voc๊ pode desativแ-la ou excluํ-la."
Elseif lSupervisor
	cMsg1:= "Escolha como os emails serใo tratatos. As regras serใo aplicadas na ordem exibida. Para que uma regra nใo seja executada,"
	cMsg2:=	"voc๊ pode desativแ-la ou excluํ-la."
	oBtn1:Hide() //Novo conta
	oBtn2:Hide() //Alterar conta
	oBtn3:Hide() //Excluir Conta
Else
	cMsg1:= "As regras serใo aplicadas na ordem exibida."
	cMsg2:=	""
	
	oBtn1:Hide() //Novo conta
	oBtn2:Hide() //Alterar conta
	oBtn3:Hide() //Excluir conta
	oBtn11:Hide()//Nova regra
	oBtn12:Hide()//Detalhes da Regras
	oBtn13:Hide()//Exclusao de regras
	oBtn14:Hide()
	oBtn15:Hide()
endif

@02,0 SAY cMsg1 PIXEL OF oPanel
@10,0 SAY cMsg2 PIXEL OF oPanel
@ 25,0 LISTBOX oListBox FIELDS HEADER "","Grp","Endere็o de Email" ALIAS  "SZR" SIZE   50,50 PIXEL OF oWin01

oListBox:SetArray(aListBox)
oListBox:bLine := {||{IIf(aListBox[oListBox:nAt,1],oOk,oNo) , aListBox[oListBox:nAt,2],aListBox[oListBox:nAt,3]} }
oListBox:Refresh()
oListBox:Align := CONTROL_ALIGN_ALLCLIENT
oListBox:lUseDefaultColors:=.F.
oListBox:bChange:={||refrashGet(@oEnc01),cargovisor(2)}

aSX3Cols := X2LoadX3()

oScrol2 := TscrollBox():New(oWin02,0,0,oWin02:nHeight,oWin02:nWidth,.T.,.T.,.T.)
oScrol2:Align:= CONTROL_ALIGN_ALLCLIENT

nOpc:=2

nGDAction := GD_UPDATE
Aadd(aSX3Header,{"" ,"X3_RESERV","@BMP",10,0,"","","C","","","","",""})
Aadd(aSX3Header,{"-","ZS_UP"    ,"@BMP",1 ,0,"","","C","","","","",""})
Aadd(aSX3Header,{"+","ZS_DOWM"  ,"@BMP",1 ,0,"","","C","","","","",""})
Aadd(aSX3Header,{"Ordem","ZS_ORDEM"  ,"999",3 ,0,"U_ValidaOrdem()","","N","","","","",""})	//"Ordem"
Aadd(aSX3Header,{"Regra","ZS_REGRA"  ,""   ,40,0,"","","C","","","","",""})	//"Campo"Aadd(aSX3Header,{"Titulo","X3_TITULO" ,""   ,12,0,"","","C","","","","",""})	//"Titulo"


nReg:= recno(cAlias)

nLen := Len(aStru)

For nX := 1 To nLen
	if nOpc==3
		&(AllTrim(aStru[nX][1])) := CRIAVAR(AllTrim(aStru[nX][1]),.T.)
	Else
		&(AllTrim(aStru[nX][1])) := (cAlias)->(FieldGet(nX))
	Endif
Next

DbSelectArea( "SX3" )
DbSetOrder( 1 )	// X3_ARQUIVO+ZS_ORDEM
DbSeek(cAlias)

While !Eof() .AND. SX3->X3_ARQUIVO == cAlias
	If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
		If ALLTRIM(SX3->X3_CAMPO)$ _cCampo
			if lAdmin .or. lGrupoAdmin
				aAdd(aCamposEnc, SX3->X3_CAMPO )
			endif
		Else
			aAdd(aCamposEnc, SX3->X3_CAMPO )
		Endif
	Endif
	DbSkip()
End

aAdd(aCamposEnc,"NOUSER")

cAuxi 	:= cFilant
cFilant	:= '02' //Sao PAulo - (Motivo,Inicializador padrao de campo SX5 em exclusivo, estava dando mensagem de help de campo na tela) warleson 21/06
oEnc01	:= MsMGet():New(cAlias,nReg,nOpc,,,,aCamposEnc,aPos,,nModelo,,,,oWin02,lF3,lMemoria,lColumn,caTela,lNoFolder,lProperty)
cAuxi 	:= cFilant

oEnc01:oBox:Align := CONTROL_ALIGN_ALLCLIENT

For x:=1 to len(oEnc01:AENTRYCTRLS)
	if oEnc01:AENTRYCTRLS[X]:CSX1HLP=="ZR_PASMAIL"
		oEnc01:AENTRYCTRLS[x]:LPASSWORD:=.T. // Setar propriedade do campos como Senha Opvs(Warleson) 30/05/12
	Endif
Next


if !nOpc==3
	M->ZR_PASMAIL:='****************************************'
endif

oEnc01:REFRESH()

oMGet6     := TMultiGet():New(0,0,{|u|if(Pcount()>0,cMemo6:=u,cMemo6)},oScroll,150,200,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,.T.,.T.);oMGet6:lWordWrap:=.T.

oMGet6:Align :=  CONTROL_ALIGN_RIGHT
oGrp9:= TGroup():New(0,4,90,90,"",oMGet6,,,.T.,.F. )
oGrp9:Align:= CONTROL_ALIGN_ALLCLIENT

oSX3 := MsNewGetDados():New(0,0,oScroll:nHeight,oScroll:nWidth,nGDAction,,,,{"ZS_UP","ZS_DOWM","ZS_ORDEM"},,,,,,oScroll,aSX3Header,aSX3Cols,)
oSX3:SetEditLine(.F.)
oSX3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
bAction1:={|| nNext := X3Reorder(n,n-1,aCols),oSX3:oBrowse:bEditCol := bSX3Edit,"UP3"}
bAction2:={|| nNext := X3Reorder(n,n+1,aCols),oSX3:oBrowse:bEditCol := bSX3Edit,"DOWN3"}

oSX3:AddAction("ZS_UP",bAction1)
oSX3:AddAction("ZS_DOWM",bAction2)
bSX3Edit := {|| If(nNext > 0,(oSX3:oBrowse:nAt := n := nNext,oSX3:oBrowse:Refresh()),),oSX3:oBrowse:GoLeft()}
oSX3:bChange:={||CargoVisor(2)}

oSX3:OBROWSE:NCLRALTERROW:=  rgb(255,255,255)

oFWLayer:SetColSplit("Col01",CONTROL_ALIGN_RIGHT)

ACTIVATE DIALOG oDlg CENTERED ON INIT {||M->ZR_PASMAIL:=PswEncript(SZR->ZR_PASMAIL,1),oEnc01:AENTRYCTRLS[1]:SETFOCUS()}

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณX2LoadX3 บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Carrega Vetor para o  Grid Baseado no dicionarios de dadosบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function X2LoadX3()
	Local aRet := {}
 	Local cSQL  := ''
    Local cTRB  := ''

	cSQL += "SELECT * " + CRLF
	cSQL += "FROM " + RetSqlName('SZS') + " ZS " + CRLF
	cSQL += "WHERE ZS.D_E_L_E_T_= ' ' AND ZS_FILIAL = '" + xFilial('SZS') + "' AND ZS_EMAIL = '" + LTRIM(aListBox[oListBox:nAt,3]) + "' "
	cTRB := GetNextAlias()
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	IF .NOT. (cTRB)->( EOF() )
		While .NOT. (cTRB)->( EOF() )
			Aadd( aRet, { IIF( (cTRB)->ZS_ATIVA == "S","ENABLE","DISABLE" ),;
							"UP3",;
							"DOWN3",;
							Val( RetAsc( (cTRB)->ZS_ORDEM, 3, .F. ) ),;
							OemToAnsi( (cTRB)->ZS_REGRA ),.F.} )
			(cTRB)->( dbSkip() )
		End
		aRet := Asort(aRet,,,{|x,y| x[4] < y[4]})
	EndIF

	(cTRB)->( dbCloseArea() )        
    FErase( cTRB + GetDBExtension() )
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณX3Reorder  บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Ordena linha do Vetor/Grid                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function X3Reorder(nAt,nNext,aArray)

Local ni
Local nSkip
Local nPos
Local nDiff := 1
Local nLen
Local bWhile

if lAdmin .or. lGrupoAdmin .or. lSupervisor
	nLen := Len(aArray)
	
	If nNext > 0 .and. nNext <= nLen .and. nAt <> nNext
		If nAt < nNext
			nSkip := -1
			ni := nPos := nAt+1
			bWhile := {|| ni <= nLen .and. ni <= nNext}
		Else
			nSkip := 1
			ni := nPos := nAt-1
			bWhile := {|| ni > 0 .and. ni >= nNext}
		EndIf
		
		While Eval(bWhile)
			nPos := ni+(nSkip*nDiff)
			aArray[ni][4] := nPos
			salva_nova_ordem(aArray[ni][5],nPos)
			nDiff := 1
			ni += nSkip*(-1)
		End
		
		If nNext > 0 .and. nNext <= nLen
			aArray[nAt][4] := nNext
			salva_nova_ordem(aArray[nAt][5],nNext)
			aArray := Asort(aArray,,,{|x,y| x[4] < y[4]})
		Else
			nNext := 0
		EndIf
	Else
		nNext := 0
	EndIf
Endif

Return nNext

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณbuscadados บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Seleciona/Filtra as contas de e-mail parao Browser        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function buscadados

local aRet	:= {}
Local aArea	:= GetArea()

cQuery := "Select ZR_ATIVO,ZR_GRPSDK,ZR_CTAMAIL,R_E_C_N_O_ "+CRLF
cQuery += "FROM "+RetSqlName("SZR")+" "+CRLF
cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cQuery += "AND ZR_FILIAL = '"+XFILIAL('SZR')+"'"

if lAdmin .or. lGrupoAdmin
	// administrador ou grupo de administrador
Else
	if !empty(cGrupos)
		cQuery += "AND ZR_GRPSDK IN("+cGrupos+")"
	endif
endif
cQuery := ChangeQuery(cQuery)

IF Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
ENDIF

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )

DbSelectArea("TRB")

While ("TRB")->(!Eof())
	aAdd(aRet,{ZR_ATIVO=='S',ZR_GRPSDK,UPPER(ZR_CTAMAIL),R_E_C_N_O_ })
	("TRB")->(dbSkip())
EndDo

("TRB" )->(dbCloseArea())

restArea(aArea)
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณrefrashGet บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza informa็๕es da Tela                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function refrashGet(oEnc01)

aArea:= GetArea()

SZR->(dbgoto(aListbox[oListBox:nAt][4]))

For nX := 1 To nLen
	if nOpc==3
		&(AllTrim(aStru[nX][1])) := CRIAVAR(AllTrim(aStru[nX][1]),.T.)
	Else
		
		M->&(AllTrim(aStru[nX][1])) := (cAlias)->(FieldGet(nX))
		
		//Campos virtuais
		if !empty(M->ZR_GRPSDK)
			M->ZR_DSCGRUP:= POSICIONE("SU0",1,XFILIAL("SU0")+M->ZR_GRPSDK,"U0_NOME")
		Else
			M->ZR_DSCGRUP:= space(50)
		endif
		if !empty(M->ZR_ASSSDK) .and. !empty(aListBox[oListBox:nAt][2])
			M->ZR_DESCASS:= TABELA("T1",ALLTRIM(M->ZR_ASSSDK))
		else
			M->ZR_DESCASS:= space(50)
		endif
		if !empty(M->ZR_OCOSDK)
			M->ZR_DESCOCO:= POSICIONE("SU9",2,XFILIAL("SU9")+M->ZR_OCOSDK ,"U9_DESC")
		Else
			M->ZR_DESCOCO:= space(50)
		endif
		if !empty(M->ZR_ACASDK)
			M->ZR_DESCACA:= POSICIONE("SUQ",1,XFILIAL("SUQ")+M->ZR_ACASDK,"UQ_DESC")
		Else
			M->ZR_DESCACA:= space(50)
		Endif
		
		if !empty(M->ZR_OCOSDK2)
			M->ZR_DESCOC2:= POSICIONE("SU9",2,XFILIAL("SU9")+M->ZR_OCOSDK2 ,"U9_DESC")
		Else
			M->ZR_DESCOC2:= space(50)
		endif
		if !empty(M->ZR_ACASDK2)
			M->ZR_DESCAC2:= POSICIONE("SUQ",1,XFILIAL("SUQ")+M->ZR_ACASDK2,"UQ_DESC")
		Else
			M->ZR_DESCAC2:= space(50)
		Endif
		
	Endif
	
Next
oEnc01:REFRESH()

aSX3Cols := X2LoadX3() // Carrega regras

if empty(aSX3Cols)
	lOrdem:=.F.
	aSx3Cols := {{"DISABLE","UP3","DOWN3",1,'Nใo Existem Regras Para Essa Caixa de Entrada',.F.}}
	oBtn12:disable()	// Detalhes
	oBtn13:disable()	// Excluir
	oBtn14:disable()
	
	cargovisor(2)
Else
	lOrdem := .T.
	oBtn12:Enable()
	oBtn13:Enable()
	oBtn14:Enable()
Endif

oSX3:ACOLS:= aClone(aSX3Cols)
oSX3:refresh()

if !empty(_cEmail) .and. !(alltrim(_cEmail)==alltrim(aListBox[oListBox:nAt,3]))
	oBtn15:Enable()
Else
	oBtn15:Disable()
Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณContas_email บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface estilo Axcadastro (CRUD)                        บฑฑ
ฑฑบ          ณ                                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Contas_email(_nOpc)

// _nOpc:= 1 // Pesqui
// _nOpc:= 2 // Visual
// _nOpc:= 3 // Inclui
// _nOpc:= 4 // Altera
// _nOpc:= 5 // Deleta


default _nOpc:= 3
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da MsMGet()             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aAlterEnch	:= {}						// Campos que podem ser editados na Enchoice
Private aPos		  	:= {000,000,080,400}		// Dimensao da MsMget em relacao ao Dialog  (LinhaI,ColunaI,LinhaF,ColunaF)
Private nModelo		:= 3						// Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Private lF3 		  	:= .F.						// Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Private lMemoria		:= .T.						// Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Private lColumn		:= .F.						// Indica se a apresentacao dos campos sera em forma de coluna
Private caTela 		:= ""						// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Private lNoFolder	:= .F.							// Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Private lProperty	:= .F.							// Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
SetPrvt("oDlg1","oSay9","oSay10","oSay11","oSay12","oGrp1","oSay1","oSay2","oSay3","oMGet1","oMGet2")
SetPrvt("oGrp2","oSay4","oSay5","oSay6","oSay7","oSay8","oGet1","oGet2","oGet3","oGet4","oGet5","oGet6")
SetPrvt("oGet8","oGet9","oCBox1","oGet10","oGet11")

Private lRet := .F.

aVirtual:={} //campos virtuais

aArea:= GetArea()

oTFont := TFont():New('Segoe UI',,-12)
oTFont2 := TFont():New('Segoe UI',,-16)

DEFINE MSDIALOG oDlg1 FROM 0,0 TO 474,660 TITLE "" Color CLR_BLACK,CLR_WHITE PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP) FONT oTFont

oFWLayer := FWLayer():New()
oFWLayer:init(oDlg1, .F. )
oFWLayer:addCollumn( "Col_01",100, .F.)

oFWLayer:addWindow( "Col_01", "Win_01", "Editar Conta...", 100, .F., .T.,{||})
oWin_01 := oFWLayer:getWinPanel('Col_01','Win_01')

aCamposEnc := {} //Campos da enchoice

nReg:= recno(cAlias)

nLen := Len(aStru)


For nX := 1 To nLen
	if _nOpc==3
		M->&(AllTrim(aStru[nX][1])) := CRIAVAR(AllTrim(aStru[nX][1]),.T.)
		//	Aadd(aRet, { AllTrim(aStru[nX][1]), (cAlias)->(FieldGet(nX)) } )
	Else
		M->&(AllTrim(aStru[nX][1])) := (cAlias)->(FieldGet(nX))
	Endif
Next

nReg:= recno(cAlias)


DbSelectArea( "SX3" )
DbSetOrder( 1 )	// X3_ARQUIVO+ZS_ORDEM
DbSeek(cAlias)

While !Eof() .AND. SX3->X3_ARQUIVO == cAlias
	If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
		aAdd(aCamposEnc, SX3->X3_CAMPO )
		If (X3_VISUAL=='V') .AND. _nopc==3
			aAdd(aVirtual,{X3_CAMPO,TAMSX3(X3_CAMPO)[1]})
		ENDIF
		
	Endif
	DbSkip()
End

//aAdd(aCamposEnc,"NOUSER")

oPanel21 := TPanel():New(0,1,"",oWin_01,,.F.,.F.,,,200,12,.F.)
oBtn31:= TButton():New(0,0,"&Confirmar",oPanel21,{||lRet:=.T.,confirma(_nOpc)},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn31:SetCss("QPushButton{ }");oBtn31:Align := CONTROL_ALIGN_LEFT
oBtn32:= TButton():New(15,0,"C&ancelar",oPanel21,{||lRet:=.F.,oDlg1:End()},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn32:SetCss("QPushButton{ }");oBtn32:Align := CONTROL_ALIGN_LEFT
oPanel21:Align :=  CONTROL_ALIGN_TOP

oScrol6 := TscrollBox():New(oWin_01,0,0,oWin_01:nHeight,oWin_01:nWidth,.T.,.F.,.T.)
oScrol6:Align:= CONTROL_ALIGN_ALLCLIENT

if _nOpc == 4 //Alteracao
	aEval(aCamposEnc,{|x|IIF(!(ALLTRIM(x)=='ZR_CTAMAIL'),aAdd(aAlterEnch,x),)})// Permissao de altera็ใo
Else
	aEval(aCamposEnc,{|x|aAdd(aAlterEnch,x)})
Endif
oEnc02:= MsMGet():New(cAlias,nReg,_nOpc,,,,aCamposEnc,aPos,aAlterEnch,nModelo,,,,oScrol6,lF3,lMemoria,lColumn,caTela,lNoFolder,lProperty)

oEnc02:oBox:Align := CONTROL_ALIGN_ALLCLIENT
oEnc02:AENTRYCTRLS[3]:LPASSWORD:=.T. // Setar propriedade do campos como Senha Opvs(Warleson) 30/05/12

if !_nOpc==3
	M->ZR_PASMAIL:=PswEncript(SZR->ZR_PASMAIL,1)
Else
	M->ZR_PASMAIL:= CRIAVAR('ZR_PASMAIL')
endif
For x:=1 to len(aVirtual)
	M->&(aVirtual[x][1]):= SPACE(aVirtual[x][2])
Next

oEnc02:REFRESH()

ACTIVATE DIALOG oDlg1 CENTERED ON INIT {||M->ZR_PASMAIL:=PswEncript(SZR->ZR_PASMAIL,1),oEnc02:AENTRYCTRLS[1]:SETFOCUS()}

If lRet .and. _nOpc==3 //Inclui
	GravaDados(_nOpc)
	msgAlert('Registro Incluido com Sucesso!')
	refrashGet(@oEnc01)
ElseIf lRet .and. _nOpc==4 //Altera
	GravaDados(_nOpc)
	msgAlert('Registro Alterado com Sucesso!')
	refrashGet(@oEnc01)
ElseIf lRet .and. _nOpc==5 //Deleta
	if MsgNoYes('Serแ excluido a Conta '+ALLTRIM(aListBox[oListBox:nAt,3])+' e suas regras de Caixa de Entrada.'+CRLF+'Confirma exclusใo do Registro?')
		GravaDados(_nOpc)
		msgAlert('Registro Excluido com Sucesso!')
	Endif
	refrashGet(@oEnc01)
Else
	// Botao Cancelar
	refrashGet(@oEnc01)
	Return
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaDadosบAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ "Update" dos novos dados na base                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function GravaDados(_nOpc)

local lGrava
local aArea

IF _nOpc==3
	lGrava:=.T. // INCLUSAO
Else
	lGrava:=.F.
	
	if _nOpc==5 //Exclusao - Entao apagar  as regras relacionados a Conta
		aArea:= GetArea()
		dbselectArea('SZS')
		dbsetorder(1)
		SZS->(dbgotop())
		if dbseek(XFILIAL('SZS')+LTRIM(aListBox[oListBox:nAt,3]))
			While SZS->(!EOF()) .and. ALLTRIM(SZS->ZS_EMAIL)==ALLTRIM(aListBox[oListBox:nAt,3])
				RecLock('SZS',.F.)
				SZS->(DBDELETE())
				MsUnLock()
				SZS->(dbskip())
			Enddo
		Endif
		RestArea(aArea)
	Endif
Endif

RecLock(cAlias,lGrava)
if !(_nopc==5) //EXCLUSAO
	For x:=1 to len(aCamposEnc)
		If !(aCamposEnc[X]=='ZR_PASMAIL')
			SZR->&(aCamposEnc[X]):= M->&(aCamposEnc[X])
		Else
			SZR->&(aCamposEnc[X]):= PswEncript(M->&(aCamposEnc[X]),0)
		Endif
	Next
Else //INCLUSAO/ALTERACAO
	SZR->(DBDELETE())
Endif
MsUnLock()

aListBox    := buscadados()
if empty(aListBox)
	dbselectarea('SZR')
	dbgobottom('SZR')
	aListBox:={{.F.,'','Nใo hแ contas para esse perfil...',recno()}}
	oBtn2:Disable()		// Alterar Conta
	oBtn3:Disable() 	// Excluir conta
	oBtn11:Disable()	// Nova Regra para a conta jแ criada
	if !empty(_cEmail) .and. !(alltrim(_cEmail)==alltrim(aListBox[oListBox:nAt,3]))
		oBtn15:Enable()
	Else
		oBtn15:Disable()
	Endif
Else
	oBtn2:Enable()
	oBtn3:Enable()
	oBtn11:Enable()
	if !empty(_cEmail) .and. !(alltrim(_cEmail)==alltrim(aListBox[oListBox:nAt,3]))
		oBtn15:Enable()
	Else
		oBtn15:Disable()
	Endif
endif
oListBox:SetArray(aListBox)
oListBox:bLine := {||{IIf(aListBox[oListBox:nAt,1],oOk,oNo) , aListBox[oListBox:nAt,2],aListBox[oListBox:nAt,3]} }
oListBox:Refresh()
oListBox:Align := CONTROL_ALIGN_ALLCLIENT
oListBox:lUseDefaultColors:=.F.
oListBox:bChange:={||refrashGet(@oEnc01),cargovisor(2)}
oListBox:nAt:=1
refrashGet(@oEnc01)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaContaบAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo de Inclusao                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function ValidaConta()
lRet:= .F.
dbsetorder(2)

IF DBSEEK(XFILIAL("SZR")+M->ZR_CTAMAIL)
	lRet:=.F.
	MsgAlert('Conta jแ Existe!')
Else
	lRet:=.T.
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณconfirma บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valida็ใo de Tela (tudoOK)                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function confirma(_nOpc)

if _nOpc==3 .or. _nOpc==4 //Inclusao ou alteracao
	If !Obrigatorio(aGets,aTela)
		//			MsgAlert('ษ necessแrio informar o conte๚do de todos os campos obrigat๓rios!')
		Return
	Else
		oDlg1:End()
	Endif
Else
	oDlg1:End()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaOrdem บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valida a Ordem digitado pelo Usuario                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ValidaOrdem()
Local lRet := .F.

If M->ZS_ORDEM > 0 .and. M->ZS_ORDEM <= Len(aCols) //.and. aCols[M->ZS_ORDEM][1] == "ENABLE"
	If aCols[n][4] <> M->ZS_ORDEM
		o:bEditCol := {|| X3Reorder(n,M->ZS_ORDEM,aCols),o:Refresh(),o:GoLeft()}
	EndIf
	lRet := .T.
else
	ApMsgAlert("Nใo serแ possํvel alterar a ordem para esta posi็ใo.")
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvalidaOK บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ Valida็ใo de Inclusa/Alteracao (tudoOK) 	                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function validaOK

if !empty(cMemo1) .or. !empty(cMemo2) .or. !empty(cMemo3)
	if empty(_cGrupo) .or. empty(_cAssunto) .or. empty(_cOcorrencia) .or. empty(_c2Ocorrencia) .or. empty(_cRegra) .or. empty(_cAtivada)
		MsgAlert('ษ necessแrio informar o conte๚do de todos os campos obrigat๓rios!')
		Return
	Endif
Else
	MsgAlert('ษ necessแrio informar o conte๚do das palavras chaves!')
	Return
Endif
oDlg5:end()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcargovisorบAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega Variaveis para montar                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function cargovisor(_nXOpc)

if _nXOpc==3 //Inclusao
	_cCodigo		:= IIF(lOrdem,len(oSX3:ACOLS)+1,1)  //ZS_ORDEM
	_cConta			:= LTRIM(aListBox[oListBox:nAt,3]) //ZS_EMAIL
	_cGrupo   		:= CRIAVAR("ZS_GRUPO")
	_cDesgrupo		:= SPACE(30)
	_cAssunto		:= CRIAVAR("ZS_ASSUNTO")
	_cDesAssunto	:= SPACE(30)
	_cOcorrencia	:= CRIAVAR("ZS_OCORREN")
	_cDesOcorren	:= SPACE(30)
	_cAcao			:= CRIAVAR("ZS_ACAO")
	_cDesAcao		:= SPACE(55)
	_c2Ocorrencia	:= CRIAVAR("ZS_OCORRE2")
	_c2DesOcorren	:= SPACE(30)
	_c2Acao			:= CRIAVAR("ZS_ACAO2")
	_c2DesAcao		:= SPACE(55)
	_cRegra			:= CRIAVAR("ZS_REGRA")
	_cAtivada		:= 'S' //ZS_ATIVA
	cMemo1:=space(200)   // Palavras Chaves,Endereco
	cMemo2:=space(200)   // Palavras Chaves,Assunto
	cMemo3:=space(200)   // Palavras Chaves,Corpo
	
	Chama_a_Tela(_nXOpc)
	
Else //Visualizacao ou Alteracao.
	
	dbselectarea('SZS')
	dbsetorder(1)
	if dbseek(XFILIAL('SZS')+LTRIM(aListBox[oListBox:nAt,3])+STR(oSX3:ACOLS[OsX3:NAt][4],3,0))
		
		_cCodigo		:= SZS->ZS_ORDEM
		_cConta			:= SZS->ZS_EMAIL
		_cGrupo   		:= SZS->ZS_GRUPO
		_cDesgrupo		:= POSICIONE("SU0",1,XFILIAL("SU0")+_cGrupo,"U0_NOME")
		_cAssunto		:= SZS->ZS_ASSUNTO
		if !empty(_cAssunto) .and. !empty(aListBox[oListBox:nAt][2])
			_cDesAssunto	:= TABELA("T1",ALLTRIM(_cAssunto))
		endif
		_cOcorrencia	:= SZS->ZS_OCORREN
		_cDesOcorren	:= POSICIONE("SU9",2,XFILIAL("SU9")+_cOcorrencia ,"U9_DESC")
		_cAcao			:= SZS->ZS_ACAO
		_cDesAcao		:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_cAcao,"UQ_DESC")
		_c2Ocorrencia	:= SZS->ZS_OCORRE2
		_c2DesOcorren	:= POSICIONE("SU9",2,XFILIAL("SU9")+_c2Ocorrencia ,"U9_DESC")
		_c2Acao			:= SZS->ZS_ACAO2
		_c2DesAcao		:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_c2Acao,"UQ_DESC")
		_cRegra			:= SZS->ZS_REGRA
		_cAtivada		:= SZS->ZS_ATIVA
		cMemo1			:= SZS->ZS_ENDEREC
		cMemo2			:= SZS->ZS_ASSUNT2
		cMemo3			:= SZS->ZS_CORPO
	Else
		cMemo6:=""
		oMGet6:Refresh()
		Return
	Endif
	
	if _nXOpc==4 //alteracao
		Chama_a_Tela()
	Else //visualizacao
		cMemo6 := "Quando a mensagem chega, e :"+CRLF
		cMemo6 += " "+CRLF
		If !empty(cMemo1)
			cMemo6 += "Inclui estas palavras no endere็o do remetente..."+CRLF+cMemo1+CRLF
			cMemo6 += " "+CRLF
		Endif
		If !empty(cMemo2)
			cMemo6 += "Inclui estas palavras no assunto..."+CRLF+cMemo2+CRLF
			cMemo6 += " "+CRLF
		Endif
		If !empty(cMemo3)
			cMemo6 += "Inclui estas palavras no corpo..."+CRLF+cMemo3+CRLF
			cMemo6 += " "+CRLF
		Endif
		cMemo6 += "Fa็a o seguinte:"+CRLF
		cMemo6 += "Redirecionar o atendimento para..."+CRLF
		cMemo6 += "Grupo		: "+_cGrupo+'-'+_cDesgrupo+CRLF
		cMemo6 += "Assunto		: "+_cAssunto+'-'+_cDesAssunto+CRLF
		cMemo6 += "Ocorr๊ncia	: "+_cOcorrencia+'-'+_cDesOcorren+CRLF
		if !empty(_cAcao)
			cMemo6 += "A็ใo		: "+_cAcao+'-'+_cDesAcao+CRLF
		endif
		cMemo6 += " "+CRLF
		cMemo6 += "Ocorr๊ncia de Retorno:"+CRLF+_c2Ocorrencia+'-'+_c2DesOcorren+CRLF
		if !empty(_c2Acao)
			cMemo6 += "A็ใo de Retorno: "+CRLF+_c2Acao+'-'+_c2DesAcao+CRLF
		endif
		oMGet6:Refresh()
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChama_a_Tela     บAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Teda de detalhes das Regras da caixa de entrada            บฑฑ
ฑฑบ          ณ Gravacao de novo regras                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function Chama_a_Tela(_nYOpc)

SetPrvt("oDlg5`","oSay9","oSay10","oSay11","oSay12","oGrp1","oSay1","oSay2","oSay3","oMGet1","oMGet2")
SetPrvt("oGrp2","oSay4","oSay5","oSay6","oSay7","oSay8","oGet1","oGet2","oGet3","oGet4","oGet5","oGet6")
SetPrvt("oGet8","oGet9","oCBox1","oGet10","oGet11")

oTFont := TFont():New('Segoe UI',,-12)
oTFont2 := TFont():New('Segoe UI',,-16)
lRet:=.F.

DEFINE MSDIALOG oDlg5 FROM 0,0 TO 474,660 TITLE "" Color CLR_BLACK,CLR_WHITE PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP) FONT oTFont

oFWLayer := FWLayer():New()
oFWLayer:init(oDlg5, .F. )
oFWLayer:addCollumn( "Col_01",100, .F.)

oFWLayer:addWindow( "Col_01", "Win_01", "Editar Regra...", 100, .F., .T.,{||})
oWin_01 := oFWLayer:getWinPanel('Col_01','Win_01')

oWin_01:OFONT:= oTFont

oPanel41 := TPanel():New(0,1,"",oWin_01,,.F.,.F.,,,200,12,.F.)
oBtn41:= TButton():New(0,0,"&Confirmar",oPanel41,{||lRet:=.T.,validaOK()},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn41:SetCss("QPushButton{ }");oBtn41:Align := CONTROL_ALIGN_LEFT
oBtn42:= TButton():New(15,0,"C&ancelar",oPanel41,{||lRet:=.F.,oDlg5:End()},037,012,,oTfont,,.T.,,"",,,,.F. );oBtn42:SetCss("QPushButton{ }");oBtn42:Align := CONTROL_ALIGN_LEFT
oPanel41:Align :=  CONTROL_ALIGN_TOP

oSayCodigo	:= TSay():New( 020,004,{||"Ordem"},oWin_01,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
@ 19,28 MSGET oGetCodigo VAR _cCodigo SIZE 30,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oSayConta   := TSay():New( 020,062,{||"Conta"},oWin_01,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
@ 19,80 MSGET oGetconta VAR _cConta SIZE 241,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oGrp1      := TGroup():New( 036,004,222,140,"Quando a mensagem chega, e :",oWin_01,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 055-5,07,{||"Inclui estas palavras no endere็o do remetente..."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
oSay2      := TSay():New( 113-5,07,{||"Inclui estas palavras no assunto..."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
oSay3      := TSay():New( 169-5,07,{||"Inclui estas palavras no corpo..."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)

oMGet1     := TMultiGet():New( 059,007,{|u|if(Pcount()>0,cMemo1:=u,cMemo1)},oGrp1,129,044,oTFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,.T.,.T.);oMGet1:lWordWrap:=.T.
oMGet2     := TMultiGet():New( 116,007,{|u|if(Pcount()>0,cMemo2:=u,cMemo2)},oGrp1,129,044,oTFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,.T.,.T.);oMGet2:lWordWrap:=.T.
oMGet3     := TMultiGet():New( 172,007,{|u|if(Pcount()>0,cMemo3:=u,cMemo3)},oGrp1,129,044,oTFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,.T.,.T.);oMGet3:lWordWrap:=.T.

oGrp2      := TGroup():New( 036,133+12,172,320,"Fa็a o seguinte:",oWin_01,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay4      := TSay():New( 046,137+12,{||"Redirecionar o atendimento para..."},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)

oSay5      := TSay():New(55,137+12,{||"Grupo"},oGrp2,,,.F.,.F.,.F.,.T.,rgb(0,0,255),CLR_WHITE,032,008)
@ 62,149 MSGET oGet1 VAR _cGrupo 	SIZE 45,8 OF oWin_01 PIXEL PICTURE('@!') F3 'GRUPO' Valid Eval({||_cDesgrupo := POSICIONE("SU0",1,XFILIAL("SU0")+_cGrupo,"U0_NOME"),EXISTCPO('SU0',_cGrupo)})
@ 62,198 MSGET oGet7 VAR _cDesgrupo SIZE 116,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oSay6      := TSay():New(74,137+12,{||"Assunto"},oGrp2,,,.F.,.F.,.F.,.T.,rgb(0,0,255),CLR_WHITE,032,008)
@ 81,149 MSGET oGet2 VAR _cAssunto 		SIZE 45,8 OF oWin_01 PIXEL PICTURE('@!') F3 'SBJNEW' Valid Eval({||_cDesAssunto:= IIF(!empty(_cAssunto) .and. !empty(aListBox[oListBox:nAt][2]),TABELA("T1",ALLTRIM(_cAssunto)),''),IIF(!empty(_cAssunto),EXISTCPO('SX5','T1'+_cAssunto),.T.)})
@ 81,198 MSGET oGet8 VAR _cDesAssunto 	SIZE 116,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oSay7      := TSay():New(93,137+12,{||"Ocorr๊ncia"},oGrp2,,,.F.,.F.,.F.,.T.,rgb(0,0,255),CLR_WHITE,032,008)
@ 100,149 MSGET oGet3 VAR _cOcorrencia SIZE 45,8 OF oWin_01 PIXEL PICTURE('@!') F3 'SU9NE2';
Valid Eval({||_cDesOcorren:= POSICIONE("SU9",2,XFILIAL("SU9")+_cOcorrencia ,"U9_DESC"),_cAcao:= POSICIONE('SUR',1,XFILIAL('SUR')+_cOcorrencia+'0000001'+'0000002','UR_CODSOL'),_cDesAcao:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_cAcao,"UQ_DESC"),IIF(!empty(_cOcorrencia),EXISTCPO('SU9',_cOcorrencia,2),.T.)})

@ 100,198 MSGET oGet9 VAR _cDesOcorren SIZE 116,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oSay8      := TSay():New( 112,137+12,{||"A็ใo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
@ 119,149 MSGET oGet4  VAR _cAcao 	SIZE 45,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F. Valid Eval({||_cDesAcao:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_cAcao,"UQ_DESC"),IIF(!empty(_cAcao),EXISTCPO('SUQ',_cAcao),.T.)})

@ 119,198 MSGET oGet10 VAR _cDesAcao SIZE 116,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oSay9      := TSay():New( 131,137+12,{||"Ocorr๊ncia de Retorno"},oGrp2,,,.F.,.F.,.F.,.T.,rgb(0,0,255),CLR_WHITE,100,008)
@ 138,149 MSGET oGet5 VAR _c2Ocorrencia SIZE 45,8 OF oWin_01 PIXEL PICTURE('@!') F3 'SU9NE2';
Valid Eval({||_c2DesOcorren:= POSICIONE("SU9",2,XFILIAL("SU9")+_c2Ocorrencia ,"U9_DESC"),_c2Acao:= POSICIONE('SUR',1,XFILIAL('SUR')+_c2Ocorrencia+'0000001'+'0000002','UR_CODSOL'),_c2DesAcao:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_c2Acao,"UQ_DESC"),IIF(!empty(_c2Ocorrencia),EXISTCPO('SU9',_c2Ocorrencia,2),.T.)})

@ 138,198 MSGET oGet7 VAR _c2DesOcorren SIZE 116,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oSay9      := TSay():New( 150,137+12,{||"A็ใo de Retorno"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
@ 157,149 MSGET oGet6 VAR _c2Acao 	SIZE 45,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F. Valid Eval({||_c2DesAcao:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_c2Acao,"UQ_DESC"),IIF(!empty(_c2Acao),EXISTCPO('SUQ',_c2Acao),.T.)})
@ 157,198 MSGET oGet8 VAR _c2DesAcao SIZE 116,8 OF oWin_01 PIXEL PICTURE('@!') WHEN .F.

oSay9      := TSay():New( 178-3,132+12,{||"Nome da regra:"},oWin_01,,,.F.,.F.,.F.,.T.,rgb(0,0,255),CLR_WHITE,200,008)

@ 184,144 MSGET oGet9 VAR _cRegra SIZE 177,8 OF oWin_01 PIXEL PICTURE('@!') Valid validaRegra(_nYOpc,_cRegra)

oSay10     := TSay():New( 208-11,132+12,{||"Ativada"},oWin_01,,,.F.,.F.,.F.,.T.,rgb(0,0,255),CLR_WHITE,032,008)
oCBox1     := tComboBox():New(220-15,132+12,{|u|if(PCount()>0,_cAtivada:=u,_cAtivada)},{'Sim','Nใo'},52,10,oWin_01,,{||},,,,.T.,,,,,,,,,'_cAtivada')

ACTIVATE DIALOG oDlg5 CENTERED ON INIT oMGet1:SETFOCUS()

if lRet //Confirmou
	dbselectarea('SZS')
	RecLock('SZS',_nYOpc==3)
	SZS->ZS_ORDEM	:= _cCodigo
	SZS->ZS_EMAIL	:= _cConta
	SZS->ZS_GRUPO	:= _cGrupo
	SZS->ZS_ASSUNTO	:= _cAssunto
	SZS->ZS_OCORREN	:= _cOcorrencia
	SZS->ZS_OCORRE2	:= _c2Ocorrencia
	SZS->ZS_ACAO	:= _cAcao
	SZS->ZS_ACAO2	:= _c2Acao
	SZS->ZS_REGRA	:= _cRegra
	SZS->ZS_ATIVA	:= _cAtivada
	SZS->ZS_ENDEREC	:= cMemo1 // Palavras Chaves,Endereco
	SZS->ZS_ASSUNT2 := cMemo2 // Palavras Chaves,Assunto
	SZS->ZS_CORPO   := cMemo3 // Palavras Chaves,Corpo
	MsUnLock()
	refrashGet(oEnc01)
	cargovisor(2)
	//	MsgAlert('Regra: '+IIF(_nYOpc==3,'Incluํda','Alterada')+' com sucesso!')
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExclui_RegraบAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Acao do botao excluir regra                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function Exclui_Regra()

local nCont:=0

if MsgNoYes('Serแ excluido a Regra '+oSX3:ACOLS[OsX3:NAt][5]+CRLF+'Confirma exclusใo?')
	
	dbselectarea('SZS')
	dbsetorder(1)
	if dbseek(XFILIAL('SZS')+LTRIM(aListBox[oListBox:nAt,3])+STR(oSX3:ACOLS[OsX3:NAt][4],3,0))
		RecLock('SZS',.F.)
		SZS->(DBDELETE())
		MsUnLock()
		
		
		//Reajuste posicoes do grid
		SZS->(dbgotop())
		if dbseek(XFILIAL('SZS')+LTRIM(aListBox[oListBox:nAt,3]))
			While SZS->(!EOF()) .and. ALLTRIM(SZS->ZS_EMAIL)==ALLTRIM(aListBox[oListBox:nAt,3])
				nCont++
				RecLock('SZS',.F.)
				SZS->ZS_ORDEM	:= nCont
				MsUnLock()
				SZS->(dbskip())
			Enddo
		Endif
		
		refrashGet(@oEnc01)
		cargovisor(2)
		msgAlert('Regra Excluida com Sucesso!')
	Else
		msgAlert('*_*_*_*_ ATENCAO _*_*_*_*'+CRLF+' Regra nใo Encontrada!')
	endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณsalva_nova_ordemบAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Grava em Banco de dados a nova ordem apontada pelo usuarioบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function salva_nova_ordem(cRegra,nPos)
CursorWait()
dbselectarea('SZS')
dbsetorder(2)
if dbseek(XFILIAL('SZS')+LTRIM(cRegra)+LTRIM(aListBox[oListBox:nAt,3]))
	RecLock('SZS',.F.)
	SZS->ZS_ORDEM	:= nPos
	MsUnLock()
	refrashGet(oEnc01)
	cargovisor(2)
Else
	msgAlert('*_*_*_*_ ATENCAO _*_*_*_*'+CRLF+' Regra nใo Encontrada!')
Endif
CursorArrow()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAPLICA_REGRAบAutor  ณOpvs(Warleson)บ Data ณ  06/18/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aplicac a Regra armazenda na Tabela SZS                    บฑฑ
ฑฑบ          ณ Chamda pelo programa CTSDK06A                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USer Function APLICA_REGRA(cPara,cDe,cAssunto,cMsg,cGrpSdk,cAssSdk,cOcoSdk,cAcaSdk,cOcoSdk2,cAcaSdk2)

local cAlias		:= 'SZS'
local cRegra		:= ''
local cSeparador	:= ','
Local cString 		:= ''
Local cPesq			:= ''
Local nPos1			:= ''
Local nPos2			:= ''
Local cPalavra		:= ''
local aRemetente
local aMensagem
local aAssunto

aArea:= GetArea()

dbselectarea("SZR")
SZR->(dbsetorder(2))
SZR->(dbgotop())

IF SZR->(DbSeek(xFilial("SZR")+cPara))
	If AllTrim(SZR->ZR_ATIVO)== "S"
		dbselectArea('SZS')
		SZS->(dbsetorder(1))
		SZS->(dbgotop())
		If SZS->(dbseek(XFILIAL('SZS')+cPara))
			While SZS->(!EOF()) .and. ALLTRIM(SZS->ZS_EMAIL)==ALLTRIM(SZR->ZR_CTAMAIL)
				
				If ALLTRIM(SZS->ZS_ATIVA)== "S"
					
					//Carrega Regra
					cMemo1:=	SZS->ZS_ENDEREC // Palavras Chaves,Endereco
					cMemo2:=	SZS->ZS_ASSUNT2 // Palavras Chaves,Assunto
					cMemo3:=	SZS->ZS_CORPO   // Palavras Chaves,Corpo
					
					_cRegra			:= SZS->ZS_REGRA
					_cGrupo   		:= SZS->ZS_GRUPO
					_cDesgrupo		:= POSICIONE("SU0",1,XFILIAL("SU0")+_cGrupo,"U0_NOME")
					_cAssunto		:= SZS->ZS_ASSUNTO
					
					if !empty(_cAssunto)
						_cDesAssunto	:= TABELA("T1",ALLTRIM(_cAssunto))
					Endif
					
					_cOcorrencia	:= SZS->ZS_OCORREN
					_cDesOcorren	:= POSICIONE("SU9",2,XFILIAL("SU9")+_cOcorrencia ,"U9_DESC")
					_cAcao			:= SZS->ZS_ACAO
					_cDesAcao		:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_cAcao,"UQ_DESC")
					_c2Ocorrencia	:= SZS->ZS_OCORRE2
					_c2DesOcorren	:= POSICIONE("SU9",2,XFILIAL("SU9")+_c2Ocorrencia ,"U9_DESC")
					_c2Acao			:= SZS->ZS_ACAO2
					_c2DesAcao		:= POSICIONE("SUQ",1,XFILIAL("SUQ")+_c2Acao,"UQ_DESC")
					
					cRegra := "Regra: "+_cRegra+CRLF
					cRegra += "Quando a mensagem chega, e :"+CRLF
					cRegra += " "+CRLF
					If !empty(cMemo1)
						cRegra += "Inclui estas palavras no endere็o do remetente..."+CRLF+cMemo1+CRLF
						cRegra += " "+CRLF
					Endif
					If !empty(cMemo2)
						cRegra += "Inclui estas palavras no assunto..."+CRLF+cMemo2+CRLF
						cRegra += " "+CRLF
					Endif
					If !empty(cMemo3)
						cRegra += "Inclui estas palavras no corpo..."+CRLF+cMemo3+CRLF
						cRegra += " "+CRLF
					Endif
					cRegra += "Fa็a o seguinte:"+CRLF
					cRegra += "Redirecionar o atendimento para..."+CRLF
					cRegra += "Grupo		: "+_cGrupo+'-'+_cDesgrupo+CRLF
					cRegra += "Assunto		: "+_cAssunto+'-'+_cDesAssunto+CRLF
					cRegra += "Ocorr๊ncia	: "+_cOcorrencia+'-'+_cDesOcorren+CRLF
					if !empty(_cAcao)
						cRegra += "A็ใo		: "+_cAcao+'-'+_cDesAcao+CRLF
					endif
					cRegra += " "+CRLF
					cRegra += "Ocorr๊ncia de Retorno:"+CRLF+_c2Ocorrencia+'-'+_c2DesOcorren+CRLF
					if !empty(_c2Acao)
						cRegra += "A็ใo de Retorno: "+CRLF+_c2Acao+'-'+_c2DesAcao+CRLF
					endif
					
					//Teste 1 - Remetente
					aRemetente:= StrTokArr(SZS->ZS_ENDEREC,cSeparador)
					
					if !empty(aRemetente)
						For x:=1 to len(aRemetente)
							cString 	:= aRemetente[x]
							cPesq		:= '"'
							nPos1		:= at(cPesq,cString)
							nPos2		:= rat(cPesq,cString)
							if nPos1>0 .and. nPos2>0
								cPalavra:= Substr(cString,nPos1+1,(nPos2-nPos1)-1)
								if cPalavra $ cDe
									//Redireciona Chamado
									cGrpSdk		:= _cGrupo
									cAssSdk		:= _cAssunto
									cOcoSdk		:= _cOcorrencia
									cAcaSdk		:= _cAcao
									cOcoSdk2	:= _c2Ocorrencia
									cAcaSdk2	:= _c2Acao
									Return cRegra
								Endif
							Endif
						Next
					Endif
					//Teste 2 - Assunto
					aAssunto:= StrTokArr(SZS->ZS_ASSUNT2,cSeparador)
					if !empty(aAssunto)
						For x:=1 to len(aAssunto)
							cString 	:= aAssunto[x]
							cPesq		:= '"'
							nPos1		:= at(cPesq,cString)
							nPos2		:= rat(cPesq,cString)
							if nPos1>0 .and. nPos2>0
								cPalavra:= Substr(cString,nPos1+1,(nPos2-nPos1)-1)
								if cPalavra$cAssunto
									//Redireciona Chamado
									cGrpSdk		:= _cGrupo
									cAssSdk		:= _cAssunto
									cOcoSdk		:= _cOcorrencia
									cAcaSdk		:= _cAcao
									cOcoSdk2	:= _c2Ocorrencia
									cAcaSdk2	:= _c2Acao
									Return cRegra
								Endif
							Endif
						Next
					Endif
					//Teste 3 - Corpo da Mensagem
					aMensagem:= StrTokArr(SZS->ZS_CORPO,cSeparador)
					
					if !empty(aMensagem)
						For x:=1 to len(aMensagem)
							cString 	:= aMensagem[x]
							cPesq		:= '"'
							nPos1		:= at(cPesq,cString)
							nPos2		:= rat(cPesq,cString)
							if nPos1>0 .and. nPos2>0
								cPalavra:= Substr(cString,nPos1+1,(nPos2-nPos1)-1)
								if cPalavra$cMsg
									//Redireciona Chamado
									cGrpSdk		:= _cGrupo
									cAssSdk		:= _cAssunto
									cOcoSdk		:= _cOcorrencia
									cAcaSdk		:= _cAcao
									cOcoSdk2	:= _c2Ocorrencia
									cAcaSdk2	:= _c2Acao
									Return cRegra
								Endif
							Endif
						Next
					Endif
				Endif
				SZS->(dbskip())
			Enddo
		Endif
	Endif
Endif
//RetArea(aArea) 
RestArea(aArea)

Return cRegra

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ASSUNTONEW     บAutor  ณMichel W. Mosca บ Data ณ  21/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta padrao para selecionar o assunto do atendimento.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Adaptado da funcao TMK510SUBJ por opvs(Warleson) 19/06/02

User Function ASSUNTONEW()

Local oDlgSu9														// Tela
Local oLbx1                                                         // Listbox
Local nPosLbx  := 0                                                 // Posicao do List
Local aItems   := {}                                                // Array com os itens
Local nPos     := 0                                                 // Posicao no array
Local lRet     := .F.                                               // Retorno da funcao
Local cCodSubject := ""		//Codigos de assuntos validos para o atendimento
Local cValor	:= ""

If ReadVar()=="M->ZR_ASSSDK"
	cValor:= M->ZR_GRPSDK
Else
	cValor:= _cGrupo
Endif

DbSelectArea("SKK")
DbSetOrder(1)
DbSeek(xFilial("SKK")+cValor)
While !EOF() .AND. SKK->KK_CODSU0 == cValor
	cCodSubject += SKK->KK_CODSKQ + "/"
	DbSkip()
End
DbSelectArea("SKK")
DbCloseArea()

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial("SX5") + "T1")
While !EOF() .AND. SX5->X5_TABELA == "T1"
	If SX5->X5_CHAVE $ cCodSubject
		aAdd(aItems, {SX5->X5_CHAVE, X5DESCRI()})
	End
	DbSkip()
End

If Len(aItems) > 0
	DEFINE MSDIALOG oDlgSu9 FROM  50,003 TO 260,500 TITLE "Assuntos" PIXEL  //"Assuntos"
	
	@ 03,10 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER ;
	"C๓digo",;	//"C๓digo"
	"Chave",;	//"Chave"
	SIZE 233,80 OF oDlgSu9 PIXEL NOSCROLL
	oLbx1:SetArray(aItems)
	oLbx1:bLine:={||{aItems[oLbx1:nAt,1],;
	aItems[oLbx1:nAt,2] }}
	
	oLbx1:BlDblClick := {||(lRet:= .T.,nPos:= oLbx1:nAt, oDlgSu9:End())}
	oLbx1:Refresh()
	
	DEFINE SBUTTON FROM 88,175 TYPE 1 ENABLE OF oDlgSu9 ACTION (lRet:= .T.,nPos := oLbx1:nAt,oDlgSu9:End())
	DEFINE SBUTTON FROM 88,210 TYPE 2 ENABLE OF oDlgSu9 ACTION (lRet:= .F.,oDlgSu9:End())
	
	ACTIVATE MSDIALOG oDlgSu9 CENTERED
Else
	Help(" ",1,"ASSUNTOS" )
	lRet := .F.
EndIf

If lRet
	DbSelectArea("SX5")
	DbSetOrder(1)
	lRet := DbSeek(xFilial("SX5") + "T1" + aItems[nPos,1])
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_Copia_regras   บAutor  ณOpvs(Warleson) บ Data ณ  06/22/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Replica regras de uma conta de e-mail para outra conta     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function Copia_regras()

Local _ZS_ORDEM,_ZS_EMAIL,_ZS_GRUPO,_ZS_ASSUNTO,_ZS_OCORREN,_ZS_OCORRE2,_ZS_ACAO,	_ZS_ACAO2,_ZS_REGRA,_ZS_ATIVA,_ZS_ENDEREC,_ZS_ASSUNT2,_ZS_CORPO
local _aArea	:= GetArea()
Local lGrava	:= .T. // .T. para inclusao, .F. para alteracao
Local lConfirma	:= .F. // .T. para gravar inclusao ou alteracao, .F. para ignorar o registro
local nCont		:= 0
local aArea

if !empty(_cEmail) .and. !(alltrim(_cEmail)==alltrim(aListBox[oListBox:nAt,3]))
	dbselectArea('SZS')
	dbsetorder(1)
	SZS->(dbgotop())
	if dbseek(XFILIAL('SZS')+LTRIM(_cEmail))
		if MsgNoYes('Confirma c๓pia da(s) regra(s)?'+CRLF+'De: '+ALLTRIM(_cEmail )+CRLF+'Para: '+ALLTRIM(aListBox[oListBox:nAt,3]))
			CursorWait()
			
			While SZS->(!EOF()) .and. ALLTRIM(SZS->ZS_EMAIL)==ALLTRIM(_cEmail )
				aArea:= GetArea()
				
				_ZS_REGRA	:= SZS->ZS_REGRA
				_ZS_EMAIL	:= LTRIM(aListBox[oListBox:nAt,3])
				_ZS_GRUPO	:= SZS->ZS_GRUPO
				_ZS_ASSUNTO	:= SZS->ZS_ASSUNTO
				_ZS_OCORREN	:= SZS->ZS_OCORREN
				_ZS_OCORRE2	:= SZS->ZS_OCORRE2
				_ZS_ACAO	:= SZS->ZS_ACAO
				_ZS_ACAO2	:= SZS->ZS_ACAO2
				_ZS_ATIVA	:= SZS->ZS_ATIVA
				_ZS_ENDEREC	:= SZS->ZS_ENDEREC
				_ZS_2ASSUNT := SZS->ZS_ASSUNT2
				_ZS_CORPO   := SZS->ZS_CORPO
				
				dbselectArea('SZS')
				dbsetorder(2)
				SZS->(dbgotop())
				if dbseek(XFILIAL('SZS')+LTRIM(_ZS_REGRA)+_ZS_EMAIL)
					if MsgNoYes('Sobrescrever regra?'+CRLF+'De: '+ALLTRIM(_cEmail )+CRLF+'Para: '+ALLTRIM(_ZS_EMAIL)+CRLF+'Regra: '+ALLTRIM(_ZS_REGRA))
						lGrava		:= .F.
						lConfirma	:= .T.
						_ZS_ORDEM	:= SZS-> ZS_ORDEM
					Else
						lConfirma	:= .F.
					Endif
				Else
					lGrava		:= .T.
					lConfirma	:= .T.
					_ZS_ORDEM	:= IIF(lOrdem,len(oSX3:ACOLS)+1,1)
				Endif
				
				If lConfirma
					RecLock('SZS',lGrava)
					SZS->ZS_ORDEM	:= _ZS_ORDEM
					SZS->ZS_EMAIL	:= _ZS_EMAIL
					SZS->ZS_GRUPO	:= _ZS_GRUPO
					SZS->ZS_ASSUNTO	:= _ZS_ASSUNTO
					SZS->ZS_OCORREN	:= _ZS_OCORREN
					SZS->ZS_OCORRE2	:= _ZS_OCORRE2
					SZS->ZS_ACAO	:= _ZS_ACAO
					SZS->ZS_ACAO2	:= _ZS_ACAO2
					SZS->ZS_REGRA	:= _ZS_REGRA
					SZS->ZS_ATIVA	:= _ZS_ATIVA
					SZS->ZS_ENDEREC	:= _ZS_ENDEREC
					SZS->ZS_ASSUNT2 := _ZS_2ASSUNT
					SZS->ZS_CORPO   := _ZS_CORPO
					MsUnLock()
				Endif
				refrashGet(@oEnc01)
				cargovisor(2)
				
				RestArea(aArea)
				SZS->(dbskip())
			Enddo
			_cEmail:=""
			oBtn15:Disable()//Colar
			CursorArrow()
			msgAlert('C๓pia da(s) regra(s) finalizada(s) com sucesso!')
		Else
			RestArea(_aArea)
			Return
		Endif
	Else
		msgAlert('*_*_*_*_ ATENCAO _*_*_*_*'+CRLF+' Regra nใo Encontrada!')
	Endif
	RestArea(_aArea)
Else
	msgAlert('*_*_*_*_ ATENCAO _*_*_*_*'+CRLF+'Nenhuma Regra Copiada!')
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvalidaregra   บAutor  ณOpvs(Warleson)  บ Data ณ  06/22/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Nome (na inclusao/Alteracao da Regra                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function ValidaRegra(_nYOpc,_cRegra)

local lRet	:= .F.
local aArea

if _nYOpc==3 //Inclusao
	
	dbselectArea('SZS')
	dbsetorder(2)
	SZS->(dbgotop())
	if dbseek(XFILIAL('SZS')+LTRIM(_cRegra)+LTRIM(aListBox[oListBox:nAt,3]))
		msgAlert('*_*_*_*_ ATENCAO _*_*_*_*'+CRLF+' Jแ existe uma regra com esse nome!')
		lRet	:= .F.
	Else
		lRet :=	.T.
	Endif
Else //Alteracao
	
	aArea := GetArea()
	If !(XFILIAL('SZS')+LTRIM(_cRegra)+LTRIM(aListBox[oListBox:nAt,3])==(SZS->ZS_FILIAL+SZS->ZS_REGRA+SZS->ZS_EMAIL))
		dbsetorder(2)
		SZS->(dbgotop())
		if dbseek(XFILIAL('SZS')+LTRIM(_cRegra)+LTRIM(aListBox[oListBox:nAt,3]))
			msgAlert('*_*_*_*_ ATENCAO _*_*_*_*'+CRLF+' Jแ existe uma regra com esse nome!')
			lRet	:= .F.
		Else
			lRet	:= .T.
		Endif
	Else
		lRet	:= .T.
	Endif
	RestArea(aArea)
Endif

Return lRet
