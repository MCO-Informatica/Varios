#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HDA080()

Local cFiltro	:= ""
Local aCores	:= {}


If !U_TILicenca()
	Return(.F.)
Endif

Private aRotina		:= {}
Private cCadastro	:= "Chamados internos (Help Desk TI)"
Private lAdmin		:= .F.
Private aPswRet		:= Aclone( PSWRET(1) )

If Valtype(aPswRet) <> "A"
	MsgStop("Problemas com cadastro de usu�rios do sistema...")
	Return(.F.)
Endif

// USUARIOS
U08->( DbSetOrder(3) )		// U08_FILIAL+U08_CODSIS
IF U08->( !MsSeek( xFilial("U08")+aPswRet[1][1] ) )
	MsgStop("Usu�rio n�o cadastrado para realizar abertura de chamados...")
	Return(.F.)
Endif

// GRUPO DE USUARIOS
U07->( DbSetOrder(1) )		// U07_FILIAL+U07_CODGRU
IF U07->( !MsSeek( xFilial("U07")+U08->U08_CODGRU ) )
	MsgStop("Grupo de usu�rio n�o cadastrado para realizar abertura de chamados...")
	Return(.F.)
Endif



aCores	:= {	{"VAL(U02->U02_STATUS) == 1 .AND. VAL(U02->U02_REABRE) == 0", "BR_VERDE"   },;	// Aberto
{"VAL(U02->U02_STATUS) == 2 .AND. U02->U02_EXECUT == 100", "BR_BRANCO"},;		// 100 concluido a aguardando valida��o
{"VAL(U02->U02_STATUS) == 2 .AND. VAL(U02->U02_REABRE) == 0", "BR_AMARELO"},;	// Em analise depois de aberto
{"VAL(U02->U02_STATUS) == 2 .AND. VAL(U02->U02_REABRE) == 1", "BR_LARANJA"},;	// Em analise depois de REaberto
{"VAL(U02->U02_STATUS) == 4 .AND. VAL(U02->U02_REABRE) == 1", "BR_VERMELHO"},;	// REabertura de chamado
{"VAL(U02->U02_STATUS) == 3 .AND. VAL(U02->U02_REABRE) == 0", "BR_AZUL"},;		// Encerrado depois de aberto
{"VAL(U02->U02_STATUS) == 3 .AND. VAL(U02->U02_REABRE) == 1", "BR_MARRON" },; 	// Encerrado depois de REaberto
{"VAL(U02->U02_STATUS) == 5 .AND. VAL(U02->U02_REABRE) == 0", "BR_CINZA" }; 	// Encaminhado
}


// 1=Aberto;2=Em Analise;3=Encerrado;4=Reabertura;5=Encaminhado



aRotina	:= {	{ "Pesquisar",		"AxPesqui", 	0, 1	},;
{ "Visualizar",		"U_HD080Vis",	0, 2	},;
{ "Incluir",		"U_HD080Inc",	0, 3	},;
{ "Reabrir",		"U_HD080Rea",	0, 4, 2	},;
{ "Complementar",	"U_HD080Com",	0, 4, 2	},;
{ "Validar",		"U_HD080Val",	0, 4, 2	},;
{ "Tracker",		"U_HD080Tra",	0, 2	},;
{ "Banco    ",		"U_HD080Anx",	0, 4    },;
{ "Legenda",		"U_HD080Leg",	0, 6	};
}


//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
cFiltro := "@U02_FILIAL = '"+xFilial("U02")+"' AND U02_USRGRU = '"+U07->U07_CODGRU+"' AND D_E_L_E_T_ = ' '"
DbSelectArea("U02")
DbSetOrder(9)

SET FILTER TO &cFiltro

mBrowse(,,,,"U02",,,,,,aCores)

U02->( DbClearFilter() )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080Vis(cAlias,nReg,nOpc)

AxVisual( cAlias, nReg, nOpc )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080Inc(cAlias,nReg,nOpc)

Local aParam	:= {}
Local cQuery	:= ""
Local cLog		:= ""
Local nOpca

cQuery :=	" SELECT   U02.U02_CODCHA, U02.U02_DATCHA " +;
" FROM     " + RetSQLName("U02") + " U02 " +;
" WHERE    U02.U02_FILIAL = '" + xFilial("U02") + "' AND " +;
"          U02.U02_USRGRU = '" + U08->U08_CODGRU + "' AND " +;
"          U02.U02_STATUS = '2' AND " +;
"          U02.U02_EXECUT = 100 AND " +;
"          U02.D_E_L_E_T_ = ' ' " +;
" ORDER BY U02.U02_CODCHA, U02.U02_DATCHA "
PLSQuery( cQuery, "U02TMP" )
While U02TMP->( !Eof() )
	
	cLog += "Chamado " + U02TMP->U02_CODCHA + " aberto no dia " + DtoC(U02TMP->U02_DATCHA) + CRLF
	
	U02TMP->( DbSkip() )
End
U02TMP->( DbCloseArea() )

If !Empty(cLog)
	cLog :=	"Aten��o, seu setor possui os chamados abaixo para serem validados." + CRLF +;
	"Para abrir um novo chamado � necess�rio validar os chamados j� solucionados." + CRLF + CRLF +;
	cLog
	MsgStop(cLog)
	Return(.F.)
Endif

Aadd(aParam, {|| .T.} )					// Executa Antes da interface
Aadd(aParam, {|| .T.} )					// Executa somente para Exclusao
Aadd(aParam, {|| U_HD80Grv() } )		// Executa dentro da transacao depois da gravacao
Aadd(aParam, {|| .T.} )					// Executa fora da transacao depois da gravacao

//Function AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized)

nOpca := AxInclui( cAlias, nReg, nOpc,,,,,,,, aParam  )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080Com(cAlias,nReg,nOpc)

Local oDlg
Local oDesHis
Local cDesHis	:= MSMM( U02->U02_CODHIS )
Local oComHis
Local cComHis	:= ""
Local lOk		:= .F.
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .8

If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif

DEFINE FONT oFonte NAME "Courier New" SIZE 0,14 BOLD

If !(AllTrim(U02->U02_STATUS) $ "1,2") .OR. U02->U02_EXECUT == 100
	MsgStop("Somente chamados em aberto ou em atendimetno poder�o ter o hist�rico complementado...")
	Return(.F.)
Endif

DEFINE DIALOG oDlg TITLE "Complemento de chamado"  SIZE nWidth, nHeight PIXEL

EnchoiceBar( oDlg, {|| (lOk:=.T.,oDlg:End())}, {|| (lOk:=.F.,oDlg:End())})


@ 020, 005 SAY "Complemento do Hist�rico" OF oDlg PIXEL FONT oFonte
@ 030, 005 GET oComHis VAR cComHis OF oDlg MEMO SIZE (nWidth/2)-10,(nHeight/6) PIXEL FONT oFonte

@ (nHeight/4.7)+15, 005 SAY "Hist�rico do Chamado" OF oDlg PIXEL FONT oFonte
@ (nHeight/4.7)+25, 005 GET oDesHis VAR cDesHis OF oDlg MEMO SIZE (nWidth/2)-10,(nHeight/5) READONLY PIXEL FONT oFonte

ACTIVATE DIALOG oDlg CENTERED

If lOk .AND. !Empty(cComHis)
	cComHis := cDesHis + CRLF + PadR(">>> COMPLEMENTO, POR: " + AllTrim(U08->U08_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
	MSMM(,80,,cComHis,1,,,"U02","U02_CODHIS")
	If nOpca == 1
		//Envia e-mail para operador que realizou atendimento do chamado U10
		cMail := Posicione("U10", 1, xFilial("U10")+U02->U02_TECCOD, "U10_USRMAI")
		If !empty(cMail)
			MailResp("", {alltrim(cMail)}, .F.,MSMM(U02->U02_CODHIS),U02->U02_CODCHA)
		EndIf
	Endif
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080Val(cAlias,nReg,nOpc)

Local oDlg
Local oDesHis
Local cDesHis	:= MSMM( U02->U02_CODHIS )
Local oComHis
Local cComHis	:= ""
Local nOpcA		:= 0
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .8
Local aButtons	:= {}

If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif

DEFINE FONT oFonte NAME "Courier New" SIZE 0,14 BOLD

If AllTrim(U02->U02_STATUS) <> "2" .OR. U02->U02_EXECUT <> 100
	MsgStop("Este chamado n�o est� no passo de valida��o...")
	Return(.F.)
Endif

Aadd(aButtons,{ "EXCLUIR",	{|| (nOpcA:=1,oDlg:End()) }, "Estorna o chamado para o pa�o de an�lise/execu��o...", "Estorna" } )

While .T.
	DEFINE DIALOG oDlg TITLE "Valida��o/Estorno do chamado" SIZE nWidth, nHeight PIXEL
	
	EnchoiceBar( oDlg, {|| (nOpcA:=2,oDlg:End()) }, {|| (nOpcA:=0,oDlg:End()) },,aButtons )
	
	@ 020, 005 SAY "Complemento do Hist�rico" OF oDlg PIXEL FONT oFonte
	@ 030, 005 GET oComHis VAR cComHis OF oDlg MEMO SIZE (nWidth/2)-10,(nHeight/6) PIXEL FONT oFonte
	
	@ (nHeight/4.7)+15, 005 SAY "Hist�rico do Chamado" OF oDlg PIXEL FONT oFonte
	@ (nHeight/4.7)+25, 005 GET oDesHis VAR cDesHis OF oDlg MEMO SIZE (nWidth/2)-10,(nHeight/5) READONLY PIXEL FONT oFonte
	oDesHis:lWordWrap := .F.
	
	ACTIVATE DIALOG oDlg CENTERED
	
	If Empty(cComHis)
		MsgStop("Complemento do hist�rico � obrigat�rio para estornar ou validar o chamado...")
		Loop
	Endif
	
	Do Case
		Case nOpcA == 0		// Cancela operacao
			Exit
			
		Case nOpcA == 1		// Estorna o chamado
			
			If !MsgYesNo("Confirma estorno do chamado ao passo de an�lise e execu��o ???")
				Loop
			Endif
			
			Begin Transaction
			U14->( DbSetOrder(1) )		// U14_FILIAL+U14_CODCHA+U14_CODETP
			If U14->( !MsSeek( xFilial("U14")+U02->U02_CODCHA ) )
				MsgStop("Erro na localiza��o do chamado...")
				Return(.F.)
			Endif
			While	U14->( !Eof() ) .AND.;
				U14->U14_FILIAL == xFilial("U14") .AND.;
				U14->U14_CODCHA == U02->U02_CODCHA
				U14->( DbSkip() )
			End
			U14->( DbSkip(-1) )
			
			U14->( RecLock("U14",.F.) )
			U14->U14_DATFET := CtoD("//")
			U14->U14_HORFET := ""
			U14->U14_TIMETP := ""
			U14->( MsUnLock() )
			
			U02->( RecLock("U02",.F.) )
			U02->U02_EXECUT := 50
			U02->U02_DATFIM := CtoD("//")
			U02->U02_HORFIM := ""
			U02->U02_TIMATD := ""
			U02->( MsUnLock() )
			
			cComHis := cDesHis + CRLF + PadR(">>> ESTORNADO, POR: " + AllTrim(U08->U08_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
			MSMM(,80,,cComHis,1,,,"U02","U02_CODHIS")
			//Envia e-mail para operador que realizou atendimento do chamado U10
			
			End Transaction
			
		Case nOpcA == 2		// Valida o chamado
			
			If !MsgYesNo("Confirma valida��o e encerramento do chamado?")
				Loop
			Endif
			
			Begin Transaction
			U02->( RecLock("U02",.F.) )
			U02->U02_VALUSR := U08->U08_CODUSR
			U02->U02_VALNOM := U08->U08_NOMUSR
			U02->U02_STATUS := "3"
			U02->( MsUnLock() )
			
			cComHis := cDesHis + CRLF + PadR(">>> ENCERRADO, POR: " + AllTrim(U08->U08_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
			MSMM(,80,,cComHis,1,,,"U02","U02_CODHIS")
			End Transaction
			
	Endcase
	
	Exit
End
If nOpca == 1
	cMail := Posicione("U10", 1, xFilial("U10")+U02->U02_TECCOD, "U10_USRMAI")
	If !empty(cMail)
		MailResp("", {alltrim(cMail)}, .F.,MSMM(U02->U02_CODHIS),U02->U02_CODCHA)
	EndIf
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080Rea(cAlias,nReg,nOpc)

Local aParam	:= {}
Local cQuery	:= ""
Local cLog		:= ""
Local aCpos		:= {}
Local cTrack	:=	U02->U02_CODCHA
Local cOldHis	:= MSMM( U02->U02_CODHIS )
Local nOpca

If U02->U02_STATUS <> "3"
	MsgStop("Aten��o, somente chamados encerrados podem ser reabertos...")
	Return(.F.)
Endif

If !Empty(U02->U02_TRACK)
	MsgStop("Aten��o, Este chamado j� foi reaberto e somente o ultimo da fila poder� dar sequencia...")
	Return(.F.)
Endif

cQuery :=	" SELECT   U02.U02_CODCHA, U02.U02_DATCHA " +;
" FROM     " + RetSQLName("U02") + " U02 " +;
" WHERE    U02.U02_FILIAL = '" + xFilial("U02") + "' AND " +;
"          U02.U02_USRGRU = '" + U08->U08_CODGRU + "' AND " +;
"          U02.U02_STATUS = '2' AND " +;
"          U02.U02_EXECUT = 100 AND " +;
"          U02.D_E_L_E_T_ = ' ' " +;
" ORDER BY U02.U02_CODCHA, U02.U02_DATCHA "
PLSQuery( cQuery, "U02TMP" )
While U02TMP->( !Eof() )
	
	cLog += "Chamado " + U02TMP->U02_CODCHA + " aberto no dia " + DtoC(U02TMP->U02_DATCHA) + CRLF
	
	U02TMP->( DbSkip() )
End
U02TMP->( DbCloseArea() )

If !Empty(cLog)
	cLog :=	"Aten��o, seu setor possui os chamados abaixo para serem validados." + CRLF +;
	"Para reabrir um chamado � necess�rio validar os chamados j� solucionados." + CRLF + CRLF +;
	cLog
	MsgStop(cLog)
	Return(.F.)
Endif

Aadd( aCpos, "U02_DESCHA" )
Aadd( aCpos, "U02_DESHIS" )
Aadd( aCpos, "U02_PRIU13" )

Aadd(aParam, {|| U_IniReabre() } )					// Executa Antes da interface
Aadd(aParam, {|| .T.} )								// Executa depois da declaracao das variaveis
Aadd(aParam, {|| U_HD80Grv(cTrack,cOldHis) } )		// Executa dentro da transacao depois da gravacao
Aadd(aParam, {|| .T.} )								// Executa fora da transacao depois da gravacao

//Function AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized)

nOpca := AxInclui( cAlias, nReg, nOpc,,,aCpos,,,,, aParam  )

If nOpca == 1
	//Envia e-mail para operador que realizou atendimento do chamado U10
	cMail := Posicione("U10", 1, xFilial("U10")+U02->U02_TECCOD, "U10_USRMAI")
	If !empty(cMail)
		MailResp("", {alltrim(cMail)}, .F.,MSMM(U02->U02_CODHIS),U02->U02_CODCHA)
	EndIf
EndIf

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  08/13/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IniReabre()

M->U02_DESCHA := U02->U02_DESCHA
M->U02_DESHIS := ""
M->U02_GRUATD := U02->U02_GRUATD
M->U02_GRUSEG := U02->U02_GRUSEG
M->U02_GRUCLA := U02->U02_GRUCLA
M->U02_PRIU13 := U02->U02_PRIU13

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080Leg()

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERDE",	"Chamado Aberto"},;
{"BR_AMARELO",	"Em an�lise depois de aberto"  },;
{"BR_LARANJA",	"Em an�lise depois de REaberto"},;
{"BR_BRANCO",	"100% concluido a aguardando valida��o"},;
{"BR_VERMELHO",	"REabertura de chamado"},;
{"BR_AZUL",		"Encerrado depois de aberto"},;
{"BR_MARRON",	"Encerrado depois de REaberto" },;
{"BR_CINZA",	"Encaminhado para outro analista" };
})

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o proximo numero do chamado.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD80Grv(cTrack,cOldHis)

Local nLenSX8	:= GetSX8Len()
Local cDesHis	:= M->U02_DESHIS

Default cTrack	:= ""
Default cOldHis	:= ""

U02->U02_CODCHA	:= GetSxeNum("U02","U02_CODCHA")

While ( GetSX8Len() > nLenSX8 )
	ConfirmSx8()
End

U02->U02_SLAABR	:= U09->U09_SLAOPE
U02->U02_SLAATD	:= U11->U11_SLACLA
U02->U02_PRIU07	:= U07->U07_PRIORI
U02->U02_PRIU11	:= U11->U11_PRIORI

If !Empty(cTrack)
	cDesHis	:=	cOldHis + CRLF + PadR(">>> REABERTO, POR: " + AllTrim(U08->U08_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cDesHis
	U02->U02_REABRE := "1"
Else
	cDesHis	:=	PadR(">>> ABERTURA, POR: " + AllTrim(U08->U08_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cDesHis
Endif

If !Empty(cDesHis)
	cDesHis += CRLF + CRLF + CRLF
Endif

MSMM(,80,,cDesHis,1,,,"U02","U02_CODHIS")

cNewCha	:= U02->U02_CODCHA

U02->( MsUnLock() )

If !Empty(cTrack)
	U02->( DbSetOrder(1) )
	If U02->( MsSeek( xFilial("U02")+cTrack ) )
		U02->( RecLock("U02",.F.) )
		U02->U02_TRACK := cNewCha
		U02->( MsUnLock() )
	Endif
Endif

U02->( MsSeek( xFilial("U02")+cNewCha ) )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA080    �Autor  �Microsiga           � Data �  09/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080Tra()

MsgStop("Mostra a sequencia de chamados reabertos...")

MsgStop("Em desenvolvimento...")

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA080    �Autor  �Microsiga           � Data �  10/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD080CpoVal(cCampo)

DEFAULT cCampo	:= ""

If Empty(cCampo)
	cCampo := SubStr(ReadVar(),4)
Endif

Do Case
	Case cCampo == "U02_GRUATD"
		U09->( DbSetOrder(1) )
		If U09->( !MsSeek( xFilial("U09")+M->U02_GRUATD ) )
			MsgStop("O registro informado n�o foi localizado na tabela de grupos...")
			Return(.F.)
		Endif
		
	Case cCampo == "U02_GRUSEG"
		U16->( DbSetOrder(1) )
		If U16->( !MsSeek( xFilial("U16")+M->U02_GRUSEG ) )
			MsgStop("O registro informado n�o foi localizado na tabela de segmento...")
			Return(.F.)
		Endif
		
		If U16->U16_CODGRU <> M->U02_GRUATD
			MsgStop("Segmento n�o pertence ao grupo informado no chamado...")
			Return(.F.)
		Endif
		
		If U16->U16_STATUS <> "1"
			MsgStop("Segmento n�o liberado para uso...")
			Return(.F.)
		Endif
		
	Case cCampo == "U02_GRUCLA"
		U11->( DbSetOrder(1) )
		If U11->( !MsSeek( xFilial("U11")+M->U02_GRUCLA ) )
			MsgStop("O registro informado n�o foi localizado na tabela de objetivos...")
			Return(.F.)
		Endif
		
		If U11->U11_CODSEG <> M->U02_GRUSEG
			MsgStop("Objetivo n�o pertence ao segmento do grupo informado no chamado...")
			Return(.F.)
		Endif
		
		If U11->U11_STATUS <> "1"
			MsgStop("Objetivo n�o liberado para uso...")
			Return(.F.)
		Endif
		
Endcase

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MailResp�Autor  �Microsiga           � Data �  08/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envio de e-mail de Complemento de Atendimento para responsavel�
���          �pelo mesmo                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MailResp(cEstPara,aPara,lNew,cComHis,cCodCha)

Local lResulConn := .T.
Local lResulSend := .T.
Local lResult := .T.
Local cError := ""
Local cServer   := Trim(GetMV('MV_RELSERV'))   // Ex.: smtp.ig.com.br ou
Local cConta    := Trim(GetMV('MV_RELACNT'))   // Conta Autenticacao Ex.: fuladetal@fulano.com.br
Local cPsw      := Trim(GetMV('MV_RELAPSW'))   // Senha de acesso Ex.: 123abc
Local lRelauth  := SuperGetMv("MV_RELAUTH",, .F.) // Parametro que indica se existe autenticacao no e-mail
Local lRet     := .F.        // Se tem autorizacao para o envio de e-mail
Local cDe := cConta
Local cAssunto := ""
Local cMsg := ""
Local aArea := GetArea()

Default lNew := .f.

cAssunto := "Complemento do Atendimento C�digo "+cCodCha
cMsg := cComHis

lResulConn := MailSmtpOn( cServer, cConta, cPsw, 60)
If !lResulConn // Exibe mensagem de erro de nao houver conex�o
	cError := MailGetErr()
	
	MsgAlert("Falha na conexao "+cError)
	
	Return(.F.)
Endif

If lRelauth
	lResult := MailAuth(Alltrim(cConta), Alltrim(cPsw))
	
	If !lResult
		//	nA := At("@",cConta)
		//	cUser := If(nA>0,Subs(cConta,1,nA-1),cConta)
		lResult := MailAuth(Alltrim(cConta), Alltrim(cPsw))
	Endif
Endif

If lResult
	
	lResulSend:= MailSend(cConta,aPara,{},{},cAssunto,cMsg,{},.F.)
	IF !lResulSend
		cError := MailGetErr()
		MsgAlert("Falha no envio do e-mail " + cError)
	EndIf
Else
	MsgAlert("Falha no envio do e-mail " + cError)
Endif

MailSmtpOff()

IF lResulSend
	MsgInfo("E-mail enviado com sucesso" + cError)
	
ENDIF

RestArea(aArea)

RETURN lResulSend

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HD080Anx  �Autor  �Microsiga           � Data �  08/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Anexa Documento ao Chamado                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function HD080Anx(cAlias,nReg,nOpc)
Local cComHis := ""
Local cDesHis	:= MSMM( U02->U02_CODHIS )

//Fun��o que anexa arquivos ao registro posicionado da tabela
If MsDocument(cAlias,nReg,nOpc)
	cComHis := cDesHis + CRLF + PadR(">>> ANEXADO ARQUIVO, POR: " + AllTrim(U08->U08_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
	MSMM(,80,,cComHis,1,,,"U02","U02_CODHIS")
	//Envia e-mail para operador que realizou atendimento do chamado U10
	cMail := Posicione("U10", 1, xFilial("U10")+U02->U02_TECCOD, "U10_USRMAI")
	If !empty(cMail)
		MailResp("", {alltrim(cMail)}, .F.,MSMM(U02->U02_CODHIS),U02->U02_CODCHA)
	EndIf
EndIf

Return