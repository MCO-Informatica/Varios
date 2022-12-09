#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA60FIL   ºAutor  ³  Daniel   Gondran  º Data ³  21/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra clientes que nao devem gerar bordero                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA060                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA60FIL
	Local cPortad := " "
	Local cRet	  := "SE1->E1_XAR <> '1'"

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "FA60FIL" , __cUserID )

	//U_MsgGet60( "Clientes", "Considera Clientes que nao envia titulos ao banco?", @cPortad,,{|| .t.}, "@!" )

	// se sim enviar todos os clientes, se nao enviar somente a1_notbco = 'S'
	//"POSICIONE('SA1',1,XFILIAL('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,'A1_NOTBCO') == 'S'
	// SA1->A1_XAR <> 'S' // SOMENTE VAI SE NAO FOR ANTECIPACAO DE RECEBIVEL
	//If cPortad == "N"
	cRet := "POSICIONE('SA1',1,XFILIAL('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,'A1_NOTBCO') $'S/ ' .AND. SE1->E1_XAR <> '1'"
	//Endif

Return (cRet)


User Function MsgGet60( cTitle, cText, uVar, cIcoFile, bValidGet, cPict, cF3 )

	Local oDlg
	Local lOk	:= .f.
	Local oGet  

	DEFAULT uVar	  	:= ""
	DEFAULT cText	  	:= ""
	DEFAULT cTitle   	:= "Atenção"
	DEFAULT bValidGet	:= {||.T.}
	DEFAULT cIcoFile 	:= "WATCH"
	DEFAULT cPict	  	:= ""

	DEFINE MSDIALOG oDlg FROM 10, 20 TO 18, 59.5 TITLE cTitle OF GetWndDefault()

	@ 0.4, 4 SAY cText OF oDlg SIZE 120, 20
	@ 2.2, 4 MSGET oGet VAR uVar SIZE 120, 10 OF oDlg PICTURE cPict F3 cF3
	oGet:bGotFocus := {|| oGet:SetPos(0)}
	oGet:Set3dLook()
	oGet:bValid := bValidGet

	@ 0.5, 1 ICON RESOURCE cIcoFile OF oDlg

	@ 4, 20 BUTTON "&Ok" OF oDlg SIZE 35, 12 ; //"&Ok"
	ACTION ( lOk := .T., oDlg:End() )

	@ 4, 29 BUTTON "&Cancela" OF oDlg SIZE 35, 12 ; //"&Cancela"
	ACTION ( lOk := .F. , oDlg:End() ) CANCEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return lOk
