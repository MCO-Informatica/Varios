#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  07/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HDA070()

Local cFilBrw	:= ""
Local aCores	:= {}

If !U_TILicenca()
	Return(.F.)
Endif

Private aRotina		:= {}
Private cCadastro	:= "Atendimento de chamados internos (Help Desk TI)"
Private aPswRet		:= Aclone( PSWRET(1) )

If Valtype(aPswRet) <> "A"
	MsgStop("Problemas com cadastro de usu�rios do sistema...")
	Return(.F.)
Endif

U10->( DbSetOrder(1) )		// U10_FILIAL+U10_CODUSR
IF U10->( !MsSeek( xFilial("U10")+aPswRet[1][1] ) )
	MsgStop("Usu�rio n�o cadastrado para realizar atendimento de chamados...")
	Return(.F.)
Endif

U09->( DbSetOrder(1) )		// U09_FILIAL+U09_CODGRU
IF U09->( !MsSeek( xFilial("U09")+U10->U10_CODGRU ) )
	MsgStop("Grupo de analista/atendente n�o localizado...")
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

aRotina	:= {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
{ "Visualizar",	"U_HD070Vis",	0, 2	},;
{ "Atender",	"U_HD070Ate",	0, 3	},;
{ "Executar",	"U_HD070Exe",	0, 4, 2	},;
{ "Encaminhar",	"U_HD070Enc",	0, 4, 2	},;
{ "HardWare",	"U_HD070Hrd",	0, 4, 2	},;
{ "Banco    ",	"MsDocument",	0, 4,0,NIL},;
{ "Terceiros",	"U_HD070Ter",	0, 4, 2	},;
{ "Legenda",	"U_HD070Leg",	0, 6	};
}

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
cFilBrw := "@U02_FILIAL = '"+xFilial("U02")+"' AND U02_GRUATD = '"+U09->U09_CODGRU+"' AND U02_TECCOD = '"+U10->U10_CODUSR+"' AND D_E_L_E_T_ = ' '"

DbSelectArea("U02")

SET FILTER TO &cFilBrw

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
User Function HD070Vis(cAlias,nReg,nOpc)

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
User Function HD070Ate(cAlias,nReg,nOpc)

Local oDlg, oFolder, oLbx, oLbxEtp, oComCha
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .85
Local aButtons	:= {}
Local aLbx		:= {}
Local aLbxEtp	:= {}
Local oVerde	:= LoaDbitmap(GetResources(),"BR_VERDE")
Local oAmarelo	:= LoaDbitmap(GetResources(),"BR_AMARELO")
Local oVermelho	:= LoaDbitmap(GetResources(),"BR_VERMELHO")
Local cFilAte	:= ""
Local cGruCla	:= Space(6)
Local cDesCla	:= ""
Local cGruSeg	:= Space(6)
Local cDesSeg	:= ""
Local cComCha	:= ""

Private oGruCla, oDesCla, oGruSeg, oDesSeg

If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif

If HD70Penden() > U10->U10_PENDEN
	MsgStop("Aten��o, voc� tem chamados pendentes que bloqueiam sua a��o de executar um novo chamado...")
	Return(.F.)
Endif

// Dados para a MsMGet
RegToMemory(cAlias,.T.)

DEFINE FONT oFonte NAME "Courier New" SIZE 0,14 BOLD

Aadd(aButtons,{ "FILTRO",	{|| (cFilAte:=BuildExpr("U02",oDlg,cFilAte),HDDadosAte(@oLbx, cFilAte, oMsMGet, @cGruSeg, @cGruCla, @cDesCla, @oLbxEtp)) }, "Filtra os dados apresentados para os chamados...", "Filtrar" } )
//Aadd(aButtons,{ "AUTOM",	{|| (HDDadosAte(@oLbx, cFilAte, oMsMGet, @cGruSeg, @cGruCla, @cDesCla, @oLbxEtp)) }, "Consulta os dados apresentados para os chamados...", "Atualizar" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| HD70GrvAte(cGruSeg,cGruCla,oLbxEtp,cComCha),oDlg:End() },{|| U02->(DbGoto(nReg)),oDlg:End() },,aButtons)

@ 015,000 FOLDER oFolder ITEMS "Lista de chamados pendentes", "Dados do seu chamado para atendimento", "Reclassifica��o da atividade" OF oDlg SIZE (nWidth/2)+2,(nHeight/2)-15 PIXEL

Aadd( aLbx, { oVerde, "", "", "", "", "", "", "", "", "" } )

@ 000,000 LISTBOX oLbx FIELDS HEADER "", "Data", "Hora", "SLA 1", "Time 1", "SLA 2", "Time 2", "Descri��o", "Classifica��o", "C�digo" SIZE (nWidth/2),(nHeight/2)-40 OF oFolder:aDialogs[1] PIXEL

oLbx:SetArray(aLbx)
oLbx:bLine := {||{	aLbx[oLbx:nAt][1],;
aLbx[oLbx:nAt][2],;
aLbx[oLbx:nAt][3],;
aLbx[oLbx:nAt][4],;
aLbx[oLbx:nAt][5],;
aLbx[oLbx:nAt][6],;
aLbx[oLbx:nAt][7],;
aLbx[oLbx:nAt][8],;
aLbx[oLbx:nAt][9],;
aLbx[oLbx:nAt][10];
}}
oLbx:aColSizes := { 5,35,20,20,20,20,20,200,200,50 }
If U10->U10_TIPUSR == "1" .OR. U10->U10_PRIESC == "2"
	oLbx:bChange := { || HDChangAte(oLbx,oMsMGet,@cGruSeg,@cDesSeg,@cGruCla,@cDesCla,@oLbxEtp) }
	//	oLbx:bChange := { || u_AtuHora()}
Else
	oLbx:bChange := { || AllWaysTrue() }
	
Endif

oMsMGet := MsMGet():New(cAlias,U10->(RecNo()),2,,,,,{000,000,(nHeight/2)-40,(nWidth/2)},,3,,,,oFolder:aDialogs[2])

@ 005,005 TO 045,(nWidth/2)-5 LABEL "Objetivo do chamado" OF oFolder:aDialogs[3] PIXEL

@ 017,010	SAY "Segmento do Grupo" OF oFolder:aDialogs[3] PIXEL FONT oFonte
@ 015,090	MSGET oGruSeg VAR cGruSeg OF oFolder:aDialogs[3] SIZE 040,5 PIXEL FONT oFonte F3 "U16_01" VALID VldGruSeg(cGruSeg, @cDesSeg, @oDesSeg, @cGruCla, @oGruCla, @cDesCla, @oDesCla)
@ 015,140	MSGET oDesSeg VAR cDesSeg OF oFolder:aDialogs[3] SIZE (nWidth/2)-150,5 PIXEL FONT oFonte READONLY

@ 032,010	SAY "Classifica��o Chamado" OF oFolder:aDialogs[3] PIXEL FONT oFonte
@ 030,090	MSGET oGruCla VAR cGruCla OF oFolder:aDialogs[3] SIZE 040,5 PIXEL FONT oFonte F3 "U11_01" VALID VldGruCla(cGruCla, @cDesCla, @oDesCla, @oLbxEtp)
@ 030,140	MSGET oDesCla VAR cDesCla OF oFolder:aDialogs[3] SIZE (nWidth/2)-150,5 PIXEL FONT oFonte READONLY

Aadd( aLbxEtp, { "", "", "" } )

@ 055,005 LISTBOX oLbxEtp FIELDS HEADER "Etapa", "Descri��o", "SLA" SIZE (nWidth/2)-10,(nHeight/6)-15 OF oFolder:aDialogs[3] PIXEL

oLbxEtp:SetArray(aLbxEtp)
oLbxEtp:bLine := {||{	aLbxEtp[oLbxEtp:nAt][1],;
aLbxEtp[oLbxEtp:nAt][2],;
aLbxEtp[oLbxEtp:nAt][3];
}}

@ (nHeight/6)+50,005 TO (nHeight/2)-50,(nWidth/2)-5 LABEL "Dados complementares ao chamado" OF oFolder:aDialogs[3] PIXEL

@ (nHeight/6)+60,010 GET oComCha VAR cComCha MEMO OF oFolder:aDialogs[3] SIZE (nWidth/2)-20,(nHeight/2)-((nHeight/4)+65) PIXEL FONT oFonte

//DEFINE TIMER oTimer INTERVAL 3000 ACTION ( HDDadosAte(@oLbx, cFilAte, oMsMGet, @cGruSeg, @cDesSeg, @cGruCla, @cDesCla, @oLbxEtp), HD70Etapa(@oLbxEtp) ) OF oDlg
//oTimer:Activate()

ACTIVATE DIALOG oDlg CENTERED ON INIT ( HDDadosAte(@oLbx, cFilAte, oMsMGet, @cGruSeg, @cDesSeg, @cGruCla, @cDesCla, @oLbxEtp), HD70Etapa(@oLbxEtp) )

//Envia e-mail para operador que realizou abertura do chamado U08

cMail := Posicione("U08", 1, xFilial("U08")+U02->U02_USRCOD, "U08_USRMAI")
If !empty(cMail)
	MailRetor("", {alltrim(cMail)}, .F.,MSMM(U02->U02_CODHIS),U02->U02_CODCHA)
EndIf

// Enibe o loop da tela na rotina de INCLUSAO
MBRCHGLOOP(.F.)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  08/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldGruSeg(cGruSeg, cDesSeg, oDesSeg, cGruCla, oGruCla, cDesCla, oDesCla)

If Empty(cGruSeg)
	MsgStop("O c�digo do segmento do grupo n�o pode ser vazio...")
	Return(.F.)
Endif

U16->( DbSetOrder(1) )
If U16->( !MsSeek( xFilial("U16")+cGruSeg ) )
	MsgStop("C�digo do segmento do grupo n�o localizado no cadastro...")
	Return(.F.)
Endif

If U16->U16_CODGRU <> U09->U09_CODGRU
	MsgStop("C�digo do segmento n�o pertence a este grupo de atendimento...")
	Return(.F.)
Endif

cDesSeg := U16->U16_DESSEG
oDesSeg:Refresh()

U11->( DbSetOrder(1) )
If U11->( !MsSeek( xFilial("U11")+cGruCla ) ) .OR. U11->U11_CODSEG <> U02->U02_GRUSEG .OR. U11->U11_STATUS <> "1"
	cGruCla := Space(6)
	oGruCla:Refresh()
	cDesCla := ""
	oDesCla:Refresh()
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  08/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldGruCla(cGruCla, cDesCla, oDesCla, oLbxEtp)

If Empty(cGruCla)
	MsgStop("O c�digo da classifica��o n�o pode ser vazio...")
	Return(.F.)
Endif

U11->( DbSetOrder(1) )
If U11->( !MsSeek( xFilial("U11")+cGruCla ) )
	MsgStop("C�digo da classifica��o n�o localizado no cadastro...")
	Return(.F.)
Endif

If U11->U11_CODGRU <> U09->U09_CODGRU
	MsgStop("C�digo da classifica��o n�o pertence ao segmento do grupo de atendimento...")
	Return(.F.)
Endif

cDesCla := U11->U11_DESCLA
oDesCla:Refresh()

HD70Etapa(@oLbxEtp, cGruCla)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  08/16/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HDDadosAte(oLbx, cFilAte, oMsMGet, cGruSeg, cDesSeg, cGruCla, cDesCla, oLbxEtp)

Local aLbx		:= {}
Local cQuery	:= ""
Local cOrdPri	:= AllTrim( GetNewPar( "MV_HDPRIO", "U07,U11,U13" ) )
Local cOrdem	:= ""
Local nI		:= 0
Local oVerde	:= LoaDbitmap(GetResources(),"BR_VERDE")
Local oAmarelo	:= LoaDbitmap(GetResources(),"BR_AMARELO")
Local oVermelho	:= LoaDbitmap(GetResources(),"BR_VERMELHO")

U10->( DbSetOrder(1) )		// U10_FILIAL+U10_CODUSR
U10->( !MsSeek( xFilial("U10")+aPswRet[1][1] ) )

U09->( DbSetOrder(1) )		// U09_FILIAL+U09_CODGRU
U09->( !MsSeek( xFilial("U09")+U10->U10_CODGRU ) )

If Len(cOrdPri) == 11
	For nI := 1 To Len(cOrdPri) Step(4)
		cOrdem += "U02.U02_PRI"+SubStr(cOrdPri,nI,3)+", "
	Next nI
Endif

If Len(cOrdem) <> Len("U02.U02_PRIU07, U02.U02_PRIU11, U02.U02_PRIU13, ")
	cOrdem := "U02.U02_PRIU07, U02.U02_PRIU11, U02.U02_PRIU13, "
Endif

cQuery	:=	" SELECT   U02.R_E_C_N_O_, U11_DESCLA " +;
" FROM	   " + RetSQLName("U02") + " U02, " + RetSQLName("U11") + " U11, " + RetSQLName("U16") + " U16 " +;
" WHERE	   U02.U02_FILIAL = '" + xFilial("U02") + "' AND " +;
"          U02.U02_GRUATD = '" + U09->U09_CODGRU + "' AND " +;
"          U02.U02_TECCOD = ' ' AND " +;
"          U02.D_E_L_E_T_ = ' ' AND " +;
"          U16.U16_FILIAL = '" + xFilial("U16") + "' AND " +;
"          U16.U16_CODSEG = U02.U02_GRUSEG AND " +;
"          U16.D_E_L_E_T_ = ' ' AND " +;
"          U11.U11_FILIAL = '" + xFilial("U11") + "' AND " +;
"          U11.U11_CODCLA = U02.U02_GRUCLA AND " +;
"          U11.D_E_L_E_T_ = ' ' " +;
" ORDER BY U02.U02_FILIAL, " + cOrdem + "U02.U02_DATCHA, U02.U02_HORCHA "

PLSQuery( cQuery, "U02TMP" )

While U02TMP->( !Eof() )
	
	U02->( DbGoTo( U02TMP->R_E_C_N_O_ ) )
	
	If !Empty(cFilAte) .AND. !&("U02->("+cFilAte+")")
		U02TMP->( DbSkip() )
		Loop
	Endif
	
	U02->( Aadd( aLbx, { Nil, U02_DATCHA, U02_HORCHA, U02_SLAABR, U02_TIMABR, U02_SLAATD, U02_TIMATD, U02_DESCHA, U02TMP->U11_DESCLA, U02_CODCHA } ) )
	
	If U_HtoN(U02->U02_TIMABR) == 0
		
		aLbx[Len(aLbx)][5] := U_HFormat( U_NtoH( U_HtoN(Time()) - U_HtoN(U02->U02_HORCHA) ), 2, 2, ":")
		
		Do Case
			Case U02->U02_DATCHA < Date()
				aLbx[Len(aLbx)][1] := oVermelho
			Case U_HtoN(aLbx[Len(aLbx)][5]) > U_HtoN(aLbx[Len(aLbx)][4])
				aLbx[Len(aLbx)][1] := oVermelho
			Case U_HtoN(aLbx[Len(aLbx)][5]) > U_HtoN(aLbx[Len(aLbx)][4])/2
				aLbx[Len(aLbx)][1] := oAmarelo
			Otherwise
				aLbx[Len(aLbx)][1] := oVerde
		Endcase
	Endif
	
	If U_HtoN(U02->U02_TIMABR) <> 0
		
		aLbx[Len(aLbx)][7] := U_HFormat( U_NtoH( U_HtoN(Time()) - U_HtoN(U02->U02_HORCHA) + U_HtoN(U02->U02_TIMABR) ), 2, 2, ":")
		
		Do Case
			Case U02->U02_DATCHA < Date()
				aLbx[Len(aLbx)][1] := oVermelho
			Case U_HtoN(aLbx[Len(aLbx)][7]) > U_HtoN(aLbx[Len(aLbx)][6])
				aLbx[Len(aLbx)][1] := oVermelho
			Case U_HtoN(aLbx[Len(aLbx)][7]) > U_HtoN(aLbx[Len(aLbx)][6])/2
				aLbx[Len(aLbx)][1] := oAmarelo
			Otherwise
				aLbx[Len(aLbx)][1] := oVerde
		Endcase
	Endif
	
	U02TMP->( DbSkip() )
End

U02TMP->( DbGoTop() )
U02->( DbGoTo( U02TMP->R_E_C_N_O_ ) )

M->U02_DESHIS := MSMM(U02->U02_CODHIS)
M->U02_GRUDAT := CriaVar("U02_GRUDAT",.T.)
M->U02_GRUDSE := CriaVar("U02_GRUDSE",.T.)
M->U02_GRUDCL := CriaVar("U02_GRUDCL",.T.)
M->U02_DESNES := CriaVar("U02_DESNES",.T.)
oMsMGet:Refresh()

cGruCla	:= U02->U02_GRUCLA
oGruCla:Refresh()
U11->( DbSetOrder(1) )
U11->( MsSeek( xFilial("U11")+U02->U02_GRUCLA ) )
cDesCla := U11->U11_DESCLA
oDesCla:Refresh()

cGruSeg	:= U02->U02_GRUSEG
oGruSeg:Refresh()
U16->( DbSetOrder(1) )
U16->( MsSeek( xFilial("U16")+U02->U02_GRUSEG ) )
cDesSeg := U16->U16_DESSEG
oDesSeg:Refresh()

U02TMP->( DbCloseArea() )

If Len(aLbx) == 0
	Aadd( aLbx, { oVerde, "", "", "", "", "", "", "", "", "" } )
Endif

oLbx:SetArray(aLbx)
oLbx:bLine := {||{	aLbx[oLbx:nAt][1],;
aLbx[oLbx:nAt][2],;
aLbx[oLbx:nAt][3],;
aLbx[oLbx:nAt][4],;
aLbx[oLbx:nAt][5],;
aLbx[oLbx:nAt][6],;
aLbx[oLbx:nAt][7],;
aLbx[oLbx:nAt][8],;
aLbx[oLbx:nAt][9],;
aLbx[oLbx:nAt][10];
}}
oLbx:Refresh()

HD70Etapa(@oLbxEtp)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  08/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HD70Etapa(oLbxEtp,cGruCla)

Local aLbxEtp	:= {}

Default cGruCla	:= U02->U02_GRUCLA

U12->( DbSetOrder(1) )
U12->( MsSeek( xFilial("U12")+cGruCla ) )

While	U12->( !Eof() ) .AND.;
	U12->U12_FILIAL == xFilial("U12") .AND.;
	U12->U12_CODCLA == cGruCla
	
	Aadd( aLbxEtp, {	U12->U12_CODETP,;
	U12->U12_DESETP,;
	U12->U12_SLAETP } )
	
	U12->( DbSkip() )
End
U12->( DbCloseArea() )

If Len(aLbxEtp) == 0
	Aadd( aLbxEtp, { "", "", "" } )
Endif

oLbxEtp:SetArray(aLbxEtp)
oLbxEtp:bLine := {||{	aLbxEtp[oLbxEtp:nAt][1],;
aLbxEtp[oLbxEtp:nAt][2],;
aLbxEtp[oLbxEtp:nAt][3];
}}
oLbxEtp:Refresh()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  08/19/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HDChangAte(oLbx,oMsMGet,cGruSeg,cDesSeg,cGruCla,cDesCla,oLbxEtp)

DbSelectArea("U02")
U02->( DbSetOrder(1) )
U02->( MsSeek( xFilial("U02")+oLbx:aArray[oLbx:nAt][10] ) )

cGruCla	:= U02->U02_GRUCLA
oGruCla:Refresh()
U11->( DbSetOrder(1) )
U11->( MsSeek( xFilial("U11")+U02->U02_GRUCLA ) )
cDesCla := U11->U11_DESCLA
oDesCla:Refresh()

cGruSeg	:= U02->U02_GRUSEG
oGruSeg:Refresh()
U16->( DbSetOrder(1) )
U16->( MsSeek( xFilial("U16")+U02->U02_GRUSEG ) )
cDesSeg := U16->U16_DESSEG
oDesSeg:Refresh()

M->U02_DESHIS := MSMM(U02->U02_CODHIS)
M->U02_GRUDAT := CriaVar("U02_GRUDAT",.T.)
M->U02_GRUDSE := CriaVar("U02_GRUDSE",.T.)
M->U02_GRUDCL := CriaVar("U02_GRUDCL",.T.)
M->U02_DESNES := CriaVar("U02_DESNES",.T.)
oMsMGet:Refresh()

HD70Etapa(@oLbxEtp)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  08/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HD70Penden()

Local nPend		:= 0
Local cQuery	:= ""

cQuery	:=	" SELECT  COUNT(*) U02_QTDCHAM " +;
" FROM    " + RetSQLName("U02") + " " +;
" WHERE   U02_FILIAL = '" + xFilial("U02") + "' AND " +;
"         U02_TECCOD = '" + U10->U10_CODUSR + "' AND " +;
"         U02_EXECUT < 100 AND " +;
" D_E_L_E_T_ = ' ' "
PLSQuery( cQuery, "U02TMP" )
nPend := U02TMP->U02_QTDCHAM
U02TMP->( DbCloseArea() )

Return(nPend)


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
User Function HD070Exe(cAlias,nReg,nOpc)

Local oDlg, oFolder, oMsGetD
Local oDesHis
Local cDesHis	:= MSMM( U02->U02_CODHIS )
Local oComHis
Local cComHis	:= ""
Local oExecut
Local nExecut	:= U02->U02_EXECUT
Local oClaCha
Local cClaCha	:= U02->U02_CLACHA
Local oDesCla
Local cDesCla	:= Posicione("U15", 1, xFilial("U15")+cClaCha, "U15_DESCLA")
Local lOk		:= .F.
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .8
Local aHeader	:= {}
Local aCols		:= {}
Local nUsado	:= 0
Local cCampo	:= 0
Local aButtons	:= {}
Local aPara		:= {}
Local cEmail	:= ""


If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif

DEFINE FONT oFonte NAME "Courier New" SIZE 0,14 BOLD

If AllTrim(U02->U02_STATUS) <> "2"
	MsgStop("Somente chamados em atendimetno poder�o ter execu��o das etapas...")
	Return(.F.)
Endif

If U02->U02_EXECUT == 100
	MsgStop("Chamado 100% conclu�do n�o pode mais ser executado...")
	Return(.F.)
Endif

U15->( DbSetOrder(1) )		// U15_FILIAL+U15_CODCLA
U15->( MsSeek( xFilial("U15")+U02->U02_GRUCLA ) )

U16->( DbSetOrder(1) )		// U16_FILIAL+U16_CODSEG
U16->( MsSeek( xFilial("U15")+U02->U02_GRUSEG ) )

// Dados para a MsNewGetDados
SX3->( MsSeek("U14") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U14"
	If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
		Aadd(aHeader, {	AllTrim(SX3->(X3Titulo())),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT } )
	Endif
	
	SX3->( DbSkip() )
End

U14->( DbSetOrder(1) )		// U14_FILIAL+U14_CODCHA+U14_CODETP
U14->( MsSeek( xFilial("U14")+U02->U02_CODCHA ) )
While	U14->( !Eof() ) .AND.;
	U14->U14_FILIAL == xFilial("U14") .AND.;
	U14->U14_CODCHA == U02->U02_CODCHA
	
	Aadd( aCols, Array( Len(aHeader)+1 ) )
	For nI := 1 To Len(aHeader)
		cCampo := aHeader[nI][2]
		If aHeader[nI][10] <> "V"
			aCols[Len(aCols)][nI] := U14->(&cCampo)
		Else
			aCols[Len(aCols)][nI] := Criavar( aHeader[nI][2], .T. )
		Endif
	Next nI
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	U14->( DbSkip() )
End


While .T.
	DEFINE DIALOG oDlg TITLE "Executando etapas do atendimento"  SIZE nWidth, nHeight PIXEL
	
	Aadd(aButtons,{ "SDUIMPORT",	{|| IIF(HD70Encerra(@oMsGetD,cComHis,cClaCha),oDlg:End(),.T.) }, "Encerra a Etapa/Chamado.", "Encerrar" } )
	Aadd(aButtons,{ "BMPGROUP",		{|| IIF(HD70TroTec(@oMsGetD,cComHis,cClaCha,nExecut),oDlg:End(),.T.) }, "Transfere o chamado para outro analista.", "Transferir" } )
	
	EnchoiceBar( oDlg, {|| (lOk:=.T.,oDlg:End()) }, {|| (lOk:=.F.,oDlg:End())},,aButtons )
	
	@ 015,000 FOLDER oFolder ITEMS "Execu��o", "Hist�rico" OF oDlg SIZE (nWidth/2)+2,(nHeight/2)-15 PIXEL
	
	oMsGetD := MsNewGetDados():New(005,005,(nHeight/6),(nWidth/2)-5,GD_INSERT+GD_DELETE+GD_UPDATE,,,,,,4096,,,,oFolder:aDialogs[1],aHeader,aCols)
	
	@ (nHeight/6)+07, 005 SAY "Complemento do Hist�rico" OF oFolder:aDialogs[1] PIXEL FONT oFonte
	@ (nHeight/6)+15, 005 GET oComHis VAR cComHis OF oFolder:aDialogs[1] MEMO SIZE (nWidth/2)-10,(nHeight/6) PIXEL FONT oFonte
	
	@ (nHeight/2)-75, 005 TO (nHeight/2)-50,(nWidth/2)-05 LABEL "Controle da Etapa" OF oFolder:aDialogs[1] PIXEL
	
	@ (nHeight/2)-63, 010 SAY "Precentual de execuss�o" OF oFolder:aDialogs[1] PIXEL FONT oFonte
	@ (nHeight/2)-65, 100 GET oExecut VAR nExecut OF oFolder:aDialogs[1] SIZE 30,5 PIXEL PICTURE "999" VALID (nExecut>0 .AND. nExecut<100)
	
	@ (nHeight/2)-63, 150 SAY "Classifica��o da ocorr�ncia" OF oFolder:aDialogs[1] PIXEL FONT oFonte
	@ (nHeight/2)-65, 250 MSGET oClaCha VAR cClaCha OF oFolder:aDialogs[1] SIZE 040,5 PIXEL PICTURE "999999" F3 "U15_01" VALID (;
	cDesCla := Posicione("U15", 1, xFilial("U15")+cClaCha, "U15_DESCLA" ),;
	oDesCla:Refresh(),;
	ExistCpo("U15",cClaCha) )
	@ (nHeight/2)-65, 300 MSGET oDesCla VAR cDesCla OF oFolder:aDialogs[1] SIZE (nWidth/2)-310,5 PIXEL PICTURE "@!" READONLY
	
	@ 005, 005 GET oDesHis VAR cDesHis OF oFolder:aDialogs[2] MEMO SIZE (nWidth/2)-10,(nHeight/2)-50 READONLY PIXEL FONT oFonte
	
	ACTIVATE DIALOG oDlg CENTERED
	
	If lOk
		
		If Empty(cClaCha)
			MsgStop("� obrigat�rio fazer a classifica��o do chamado...")
			Loop
		Endif
		
		U02->( RecLock("U02",.F.) )
		U02->U02_EXECUT := nExecut
		U02->U02_CLACHA := cClaCha
		If !Empty(cComHis)
			cComHis := cDesHis + CRLF + PadR(">>> COMPLEMENTO, POR: " + AllTrim(U10->U10_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
			MSMM(,80,,cComHis,1,,,"U02","U02_CODHIS")
		Endif
		U02->( MsUnLock() )
		Exit
	Else
		Exit
	Endif
End

cMail := Posicione("U08", 1, xFilial("U08")+U02->U02_USRCOD, "U08_USRMAI")
If !empty(cMail)
	MailRetor("", {alltrim(cMail)}, .F.,MSMM(U02->U02_CODHIS),U02->U02_CODCHA)
EndIf



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
User Function HD070Enc(cAlias,nReg,nOpc)


Local oDlg
Local oDesHis
Local cDesHis	:= MSMM( U02->U02_CODHIS )
Local oComHis
Local cComHis	:= ""

Local oGruAtd
Local cGruAtd	:= U02->U02_GRUATD
Local oDGruAt
Local cDGruAt	:= Posicione("U09", 1, xFilial("U09")+cGruAtd, "U09_DESGRU")

Local oGruSeg
Local cGruSeg	:= U02->U02_GRUSEG
Local oDGruSe
Local cDGruSe	:= Posicione("U16", 1, xFilial("U16")+cGruSeg, "U16_DESSEG")

Local oGruCla
Local cGruCla	:= U02->U02_GRUCLA
Local oDGruCl
Local cDGruCl	:= Posicione("U11", 1, xFilial("U11")+cGruCla, "U11_DESCLA")

Local aStruct	:= U02->( DbStruct() )
Local cCampo	:= ""
Local aDados	:= {}
Local lOk		:= .F.
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .8
Local nI		:= 0
Local nRecU02	:= U02->( RecNo() )
Local nRecU09	:= U09->( RecNo() )
Local nRecU16	:= U16->( RecNo() )
Local nRecU11	:= U11->( RecNo() )
Local nNCodCha	:= ""
Local nPos		:= 0
Local nLenSX8	:= 0

If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif

DEFINE FONT oFonte NAME "Courier New" SIZE 0,14 BOLD

If AllTrim(U02->U02_STATUS) <> "2" .OR. U02->U02_EXECUT == 100
	MsgStop("Somente chamados em atendimetno poder�o ser transferidos para outra fila...")
	Return(.F.)
Endif

While .T.
	
	DEFINE DIALOG oDlg TITLE "Transfer�ncia de chamado"  SIZE nWidth, nHeight PIXEL
	
	EnchoiceBar( oDlg, {|| (lOk:=.T.,oDlg:End()) }, {|| (lOk:=.F.,oDlg:End())} )
	
	@ 020, 005 SAY "Complemento do Hist�rico" OF oDlg PIXEL FONT oFonte
	@ 030, 005 GET oComHis VAR cComHis OF oDlg MEMO SIZE (nWidth/4)-10,(nHeight/7) PIXEL FONT oFonte
	
	@ 020, (nWidth/4) SAY "Reapontamento de fila de atendimento" OF oDlg PIXEL FONT oFonte
	@ 030, (nWidth/4) TO (nHeight/7)+30, (nWidth/2)-5 OF oDlg PIXEL
	
	//@ 035, (nWidth/4)+005 SAY "Grupo de atendimento - (fila)" OF oDlg PIXEL FONT oFonte
	@ 036, (nWidth/4)+005/*271*/  SAY "Grupo de atendimento - (fila)" OF oDlg PIXEL FONT oFonte
	/*
	@ 045, (nWidth/4)+005 MSGET oGruAtd VAR cGruAtd OF oDlg SIZE 040,5 PIXEL PICTURE "999999" F3 "U09_01" VALID (;
	cDGruAt := Posicione("U09", 1, xFilial("U09")+cGruAtd, "U09_DESGRU"),;
	oDGruAt:Refresh(),;
	cGruSeg := Space(6),;
	oGruSeg:Refresh(),;
	cDGruSe := "",;
	oDGruSe:Refresh(),;
	cGruCla := Space(6),;
	oGruCla:Refresh(),;
	cDGruCl := "",;
	oDGruCl:Refresh(),;
	HD070CpoVal("cGruAtd",cGruAtd) )
	*/
	@ 045, (nWidth/4)+005 MSGET oGruAtd VAR cGruAtd OF oDlg SIZE 040,5 PIXEL PICTURE "999999" F3 "U09_01" VALID (;
	cDGruAt := Posicione("U09", 1, xFilial("U09")+cGruAtd, "U09_DESGRU"),;
	oDGruAt:Refresh(),;
	cGruSeg := Space(6),;
	oGruSeg:Refresh(),;
	cDGruSe := "",;
	oDGruSe:Refresh(),;
	cGruCla := Space(6),;
	oGruCla:Refresh(),;
	cDGruCl := "",;
	oDGruCl:Refresh(),;
	HD070CpoVal("cGruAtd",cGruAtd) )
	
	@ 045, (nWidth/4)+050 MSGET oDGruAt VAR cDGruAt OF oDlg SIZE ((nWidth/2)-10)-((nWidth/4)+050),5 PIXEL PICTURE "@!" READONLY
	
	
	//	@ (nHeight/7)-20, (nWidth/4)+005 SAY "Segmento do grupo de atendimento" OF oDlg PIXEL FONT oFonte
	@ 56, (nWidth/4)+005 SAY "Segmento do grupo de atendimento" OF oDlg PIXEL FONT oFonte
	/*
	@ (nHeight/7)-10, (nWidth/4)+005 MSGET oGruSeg VAR cGruSeg OF oDlg SIZE 040,5 PIXEL PICTURE "999999" F3 "U16_01" VALID (;
	cDGruSe := Posicione("U16", 1, xFilial("U16")+cGruSeg, "U16_DESSEG"),;
	oDGruSe:Refresh(),;
	cGruCla := Space(6),;
	oGruCla:Refresh(),;
	cDGruCl := "",;
	oDGruCl:Refresh(),;
	HD070CpoVal("cGruSeg",cGruSeg) )
	*/
	@ 65, (nWidth/4)+005 MSGET oGruSeg VAR cGruSeg OF oDlg SIZE 040,5 PIXEL PICTURE "999999" F3 "U16_01" VALID (;
	cDGruSe := Posicione("U16", 1, xFilial("U16")+cGruSeg, "U16_DESSEG"),;
	oDGruSe:Refresh(),;
	cGruCla := Space(6),;
	oGruCla:Refresh(),;
	cDGruCl := "",;
	oDGruCl:Refresh(),;
	HD070CpoVal("cGruSeg",cGruSeg) )
	
	//@ (nHeight/7)-10, (nWidth/4)+050 MSGET oDGruSe VAR cDGruSe OF oDlg SIZE ((nWidth/2)-10)-((nWidth/4)+050),5 PIXEL PICTURE "@!" READONLY
	@ 65, (nWidth/4)+050 MSGET oDGruSe VAR cDGruSe OF oDlg SIZE ((nWidth/2)-10)-((nWidth/4)+050),5 PIXEL PICTURE "@!" READONLY
	
	//@ (nHeight/7)+05, (nWidth/4)+005 SAY "Classifica��o do chamado" OF oDlg PIXEL FONT oFonte
	@ 76, (nWidth/4)+005 SAY "Classifica��o do chamado" OF oDlg PIXEL FONT oFonte
	/*
	@ (nHeight/7)+15, (nWidth/4)+005 MSGET oGruCla VAR cGruCla OF oDlg SIZE 040,5 PIXEL PICTURE "999999" F3 "U11_01" VALID (;
	cDGruCl := Posicione("U11", 1, xFilial("U11")+cGruCla, "U11_DESCLA"),;
	oDGruCl:Refresh(),;
	HD070CpoVal("cGruCla",cGruCla) )
	*/
	@ 85, (nWidth/4)+005 MSGET oGruCla VAR cGruCla OF oDlg SIZE 040,5 PIXEL PICTURE "999999" F3 "U11_01" VALID (;
	cDGruCl := Posicione("U11", 1, xFilial("U11")+cGruCla, "U11_DESCLA"),;
	oDGruCl:Refresh(),;
	HD070CpoVal("cGruCla",cGruCla) )
	
	//@ (nHeight/7)+15, (nWidth/4)+050 MSGET oDGruCl VAR cDGruCl OF oDlg SIZE ((nWidth/2)-10)-((nWidth/4)+050),5 PIXEL PICTURE "@!" READONLY
	@ 85, (nWidth/4)+050 MSGET oDGruCl VAR cDGruCl OF oDlg SIZE ((nWidth/2)-10)-((nWidth/4)+050),5 PIXEL PICTURE "@!" READONLY
	
	@ (nHeight/5.1)+10, 005 SAY "Hist�rico do Chamado" OF oDlg PIXEL FONT oFonte
	@ (nHeight/5.1)+20, 005 GET oDesHis VAR cDesHis OF oDlg MEMO SIZE (nWidth/2)-10,((nHeight/2)-20)-((nHeight/5.1)+20) READONLY PIXEL FONT oFonte
	
	ACTIVATE DIALOG oDlg CENTERED
	
	If lOk
		If cGruAtd == U02->U02_GRUATD
			MsgStop("O grupo de atendimetno selecionado n�o pode ser o mesmo do chamado...")
			Loop
		Endif
		
		If Empty(cComHis)
			MsgStop("O complemento do hist�rico n�p pode ser vazio para tranfer�ncia do chamado...")
			Loop
		Endif
		
		U09->( DbSetOrder(1) )		// U09_FILIAL+U09_CODGRU
		If U09->( !MsSeek( xFilial("U09")+cGruAtd ) )
			MsgStop("Grupo de atendimento inv�lido para tranfer�ncia do chamado...")
			Loop
		Endif
		
		U16->( DbSetOrder(1) )		// U16_FILIAL+U16_CODSEG
		If U16->( !MsSeek( xFilial("U16")+cGruSeg ) )
			MsgStop("Segmento do grupo de atendimento inv�lido na tranfer�ncia do chamado...")
			Loop
		Endif
		
		U11->( DbSetOrder(1) )		// U11_FILIAL+U11_CODCLA
		If U11->( !MsSeek( xFilial("U11")+cGruCla ) )
			MsgStop("Classifica��o do chamado para o grupo de atendimento inv�lido na tranfer�ncia do chamado...")
			Loop
		Endif
		
		For nI := 1 To Len(aStruct)
			cCampo := aStruct[nI][1]
			Aadd( aDados, { cCampo, U02->(&cCampo) } )
		Next nI
		
		Begin Transaction
		
		cComHis := cDesHis + CRLF + PadR(">>> TROCA DE FILA, POR: " + AllTrim(U10->U10_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
		MSMM(,80,,cDesHis,1,,,"U02","U02_CODHIS")
		
		U02->( RecLock("U02",.T.) )
		For nI := 1 To Len(aStruct)
			cCampo := aStruct[nI][1]
			nPos := Ascan( aDados, { |x| x[1]==cCampo } )
			If nPos > 0
				U02->(&cCampo) := aDados[nPos][2]
			Endif
		Next nI
		
		U02->U02_CODCHA := GetSxeNum("U02","U02_CODCHA")
		While ( GetSX8Len() > nLenSX8 )
			ConfirmSx8()
		End
		U02->U02_GRUATD	:= U09->U09_CODGRU
		U02->U02_GRUSEG	:= U16->U16_CODSEG
		U02->U02_GRUCLA	:= U11->U11_CODCLA
		U02->U02_TECCOD	:= ""
		U02->U02_HORANA	:= ""
		U02->U02_DATANA	:= CtoD("//")
		U02->U02_EXECUT	:= 0
		U02->U02_SLAABR	:= U09->U09_SLAOPE
		U02->U02_SLAATD	:= U11->U11_SLACLA
		U02->U02_PRIU11	:= U11->U11_PRIORI
		U02->U02_CLACHA	:= ""
		MSMM(,80,,cDesHis,1,,,"U02","U02_CODHIS")
		U02->( MsUnLock() )
		nNCodCha := U02->U02_CODCHA
		
		U02->( DbGoTo(nRecU02) )
		
		U02->( RecLock("U02",.F.) )
		U02->U02_TRACK	:= nNCodCha
		U02->U02_STATUS	:= "5"
		U02->U02_EXECUT	:= 100
		U02->( MsUnLock() )
		
		End Transaction
		
		cMail := Posicione("U08", 1, xFilial("U08")+U02->U02_USRCOD, "U08_USRMAI")
		If !empty(cMail)
			MailRetor("", {alltrim(cMail)}, .F.,MSMM(U02->U02_CODHIS),U02->U02_CODCHA)
		EndIf
		
		
	Endif
	Exit
End

U02->( DbGoTo( nRecU02 ) )
U09->( DbGoTo( nRecU09 ) )
U16->( DbGoTo( nRecU16 ) )
U11->( DbGoTo( nRecU11 ) )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD070Hrd(cAlias,nReg,nOpc)

Local oDlg
Local aButtons	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local nI		:= 0
Local oDesHis
Local cDesHis	:= MSMM( U02->U02_CODHIS )
Local oCodHrd
Local cCodHrd	:= CriaVar("U00_CODHRD",.F.)
Local oMarca
Local cMarca	:= CriaVar("U00_MARCA",.F.)
Local oLocal
Local cLocal	:= CriaVar("U00_CODLOC",.F.)
Local oSetor
Local cSetor	:= CriaVar("U00_SETOR",.F.)
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .8

If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif

If U02->U02_STATUS <> "2" .OR. U02->U02_EXECUT == 100
	MsgStop("Aten��o, Somente chamado em atendimento pode entrar no passo de Hardware.")
	Return(.F.)
Endif

If U09->U09_HARD <> "1"
	MsgStop("Aten��o, Sua equipe n�o tem permiss�o de realizar manuten��o em hardware.")
	Return(.F.)
Endif

DEFINE FONT oFonte NAME "Courier New" SIZE 0,14 BOLD

Private oMsGetD

// Dados para a MsNewGetDados
SX3->( MsSeek("U03") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U03"
	If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
		Aadd(aHeader, {	AllTrim(SX3->(X3Titulo())),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT } )
	Endif
	
	SX3->( DbSkip() )
End

U03->( DbSetOrder(2) )
If U03->( MsSeek( xFilial("U03")+U02->U02_CODCHA ) )
	U00->( DbSetOrder(1) )
	If U00->( MsSeek( xFilial("U00")+U03->U03_CODHRD ) )
		cCodHrd	:= U00->U00_CODHRD
		cMarca	:= U00->U00_MARCA
		cLocal	:= U00->U00_CODLOC
		cSetor	:= U00->U00_SETOR
	Endif
Endif
While	U03->( !Eof() ) .AND.;
	U03->U03_FILIAL == xFilial("U03") .AND.;
	U03->U03_CODCHA == U02->U02_CODCHA
	
	Aadd(aCols, Array( Len(aHeader)+1 ) )
	For nI := 1 To Len(aHeader)
		cCampo := aHeader[nI][2]
		If aHeader[nI][10] <> "V"
			aCols[Len(aCols)][nI] := U03->(&cCampo)
		Else
			If aHeader[nI][2] == "U03_DESPRO "
				aCols[Len(aCols)][nI] := Posicione("SB1", 1, xFilial("SB1")+U03->U03_CODPRO, "B1_DESC")
			Else
				aCols[Len(aCols)][nI] := Criavar( aHeader[nI][2], .T. )
			Endif
		Endif
	Next nI
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	U03->( DbSkip() )
End

If Len(aCols) == 0
	aCols :=  Array( 1, Len(aHeader)+1 )
	For nI := 1 To Len(aHeader)
		aCols[1][nI] := Criavar( aHeader[nI][2], .F. )
	Next nI
	aCols[1][Len(aHeader)+1] := .F.
	aCols[1][Ascan( aHeader, { |x| AllTrim(x[2])=="U03_ITEM" } )] := StrZero(Len(aCols),3)
Endif

//Aadd(aButtons,{ "FERRAM",	{|| MDP90Copy() }, "Copia os agendados de uma dia para outro dia.", "Copiar" } )

DEFINE DIALOG oDlg TITLE "Complemento de chamado"  SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| (HD70GrvHard(oMsGetD,cCodHrd),oDlg:End()) },{|| (oDlg:End()) },,aButtons)

@ 018, 005 SAY "Hist�rico do Chamado" OF oDlg PIXEL
@ 028, 005 GET oDesHis VAR cDesHis OF oDlg MEMO SIZE (nWidth/2)-10,(nHeight/8) READONLY PIXEL FONT oFonte

@ (nHeight/5.3),005 TO (nHeight/4.2),(nWidth/2)-5 LABEL "Equipamento para manuten��o" OF oDlg PIXEL
@ (nHeight/4.8),010 SAY "C�digo" OF oDlg PIXEL
@ (nHeight/4.8),030 MSGET oCodHrd VAR cCodHrd SIZE 030,9 OF oDlg PIXEL F3 "U00_01" VALID (U00->(cMarca:=U00_MARCA,cLocal:=U00_CODLOC,cSetor:=U00_SETOR),ExistCPO("U00",cCodHrd))
@ (nHeight/4.8),070 MSGET oMarca VAR cMarca SIZE 100,9 OF oDlg PIXEL READONLY
@ (nHeight/4.8),180 MSGET oLocal VAR cLocal SIZE 100,9 OF oDlg PIXEL READONLY
@ (nHeight/4.8),290 MSGET oSetor VAR cSetor SIZE 100,9 OF oDlg PIXEL READONLY

oMsGetD := MsNewGetDados():New((nHeight/4),005,(nHeight/2)-35,(nWidth/2)-5,GD_INSERT+GD_DELETE+GD_UPDATE,,,,,,4096,"U_TecFilOK(@oMsGetD)",,,oDlg,aHeader,aCols)

ACTIVATE DIALOG oDlg CENTERED

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/17/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TecFilOK(oMsGetD)

oMsGetD:aCols[oMsGetD:nAt][Ascan( aHeader, { |x| AllTrim(x[2])=="U03_ITEM" } )] := StrZero(oMsGetD:nAt,3)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HELPDESK  �Autor  �Microsiga           � Data �  07/17/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HD70GrvHard(oMsGetD,cCodHrd)

Local aCols		:= Aclone( oMsGetD:aCols )
Local aHeader	:= Aclone( oMsGetD:aHeader )
Local nI		:= 0
Local nJ		:= 0
Local nPItem	:= Ascan( aHeader, { |x| AllTrim(x[2])=="U03_ITEM" } )

U03->( DbSetOrder(1) )		// U03_FILIAL+U03_CODHRD+U03_CODCHA+U03_ITEM+U03_CODPRO
For nJ := 1 To Len(aCols)
	
	U03->( MsSeek( xFilial("U03")+cCodHrd+U02->U02_CODCHA+aCols[nJ][nPItem] ) )
	
	If aCols[nJ][Len(aCols[nJ])] .AND. U03->( Found() )
		U03->( RecLock("U03", .F. ) )
		U03->( DbDelete() )
		U03->( MsUnLock() )
		Loop
	Endif
	
	U03->( RecLock("U03", U03->(!Found()) ) )
	
	U03->U03_FILIAL := xFilial("U03")
	U03->U03_CODHRD := cCodHrd
	U03->U03_CODCHA := U02->U02_CODCHA
	
	For nI := 1 To Len(aHeader)
		cCampo := AllTrim(aHeader[nI][2])
		nPCpo := Ascan( aHeader, { |x| AllTrim(x[2])==cCampo } )
		If nPCpo > 0 .AND. nPCpo <= Len(aCols[nJ]) .AND. aHeader[nI][10] <> "V"
			U03->(&cCampo) := aCols[nJ][nPCpo]
		Endif
	Next nI
	U03->( MsUnLock() )
Next nJ

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
User Function HD070Leg()

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
Static Function HD70GrvAte(cGruSeg, cGruCla, oLbxEtp, cComCha)

Local cDesHis	:= ""
Local aLbxEtp	:= Aclone( oLbxEtp:aArray )
Local nI		:= 0

DbSelectArea("U02")
cDesHis	:= MSMM(U02->U02_CODHIS)

If cGruCla <> U02->U02_GRUCLA
	cDesHis += CRLF + PadR(">>> RECLASSIFICADO, POR: " + AllTrim(U10->U10_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF
Endif

cDesHis += CRLF + PadR(">>> ATENDIDO, POR: " + AllTrim(U10->U10_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComCha + CRLF + CRLF

Begin Transaction

U02->( RecLock("U02",.F.) )
U02->U02_GRUSEG	:= cGruSeg
U02->U02_GRUCLA	:= cGruCla
U02->U02_STATUS	:= "2"
U02->U02_TECCOD	:= U10->U10_CODSIS
U02->U02_DATANA	:= Date()
U02->U02_HORANA	:= Time()
U02->U02_EXECUT	:= 25
U02->U02_TIMABR	:= U_HFormat( U_NtoH(((U02->U02_DATANA - U02->U02_DATCHA) * 24) + (U_HtoN(U02_HORANA) - U_HtoN(U02_HORCHA))), 3, 2, ":" )
U02->( MsUnLock() )

MSMM(,80,,cDesHis,1,,,"U02","U02_CODHIS")

For nI := 1 To Len(aLbxEtp)
	U14->( RecLock("U14",.T.) )
	U14->U14_FILIAL := xFilial("U14")
	U14->U14_CODCHA := U02->U02_CODCHA
	U14->U14_CODETP := aLbxEtp[nI][1]
	U14->U14_DESETP := aLbxEtp[nI][2]
	U14->U14_SLAETP := aLbxEtp[nI][3]
	If nI == 1
		U14->U14_TECETP := U10->U10_CODSIS
		U14->U14_TECNOM := U10->U10_NOMUSR
		U14->U14_DATETP := U02->U02_DATANA
		U14->U14_HORETP := U02->U02_HORANA
	Endif
	U14->( MsUnLock() )
Next nI

End Transaction

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  09/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HD70Encerra(oMsGetD,cComHis,cClaCha)

Local aHeader	:= Aclone(oMsGetD:aHeader)
Local aCols		:= Aclone(oMsGetD:aCols)
Local nI		:= 0
Local nPTecEtp	:= Ascan( aHeader, { |x| Alltrim(x[2])=="U14_TECETP" } )
Local lFimCha	:= Len(aCols) == 1
Local cCampo	:= ""
Local nTotHor	:= 0
Local cDesHis	:= MSMM( U02->U02_CODHIS )

If nPTecEtp == 0
	MsgStop("Erro estrutural no sistema, falta o campo U14_TECETP...")
	Return(.F.)
Endif

If !lFimCha
	For nI := 1 To Len(aCols)
		If Empty(aCols[nI][nPTecEtp])
			Exit
		Endif
	Next nI
	If nI > Len(aCols)
		lFimCha := .T.
		nI := Len(aCols)
	Endif
Endif

If Empty(cClaCha)
	MsgStop("� obrigat�rio fazer a classifica��o do chamado...")
	Return(.F.)
Endif

If lFimCha .AND. Empty(cComHis)
	MsgStop("O encerramento da ultima etapa encerra o chamado e por esse motivo o hist�rico � obrigat�rio...")
	Return(.F.)
Endif

U14->( DbSetOrder(1) )		// U14_FILIAL+U14_CODCHA+U14_CODETP
If U14->( !MsSeek( xFilial("U14")+U02->U02_CODCHA ) )
	MsgStop("Erro na localiza��o do chamado...")
	Return(.F.)
Endif
While	U14->( !Eof() ) .AND.;
	U14->U14_FILIAL == xFilial("U14") .AND.;
	U14->U14_CODCHA == U02->U02_CODCHA
	
	If Empty(U14->U14_TECETP) .AND. Len(aCols) > 1
		U14->( DbSkip(-1) )
		Exit
	Else
		cTecEtp := U14->U14_TECETP
		cTecNom := U14->U14_TECNOM
	Endif
	
	U14->( DbSkip() )
End

If lFimCha
	U14->( DbSkip(-1) )
Endif

Begin Transaction
U14->( RecLock("U14",.F.) )
U14->U14_DATFET := Date()
U14->U14_HORFET := Time()
U14->U14_TIMETP := U_HFormat( U_NtoH( ((U14->U14_DATFET - U14->U14_DATETP) * 24) + (U_HtoN(U14->U14_HORFET) - U_HtoN(U14->U14_HORETP)) ), 3, 2, ":")
U14->( MsUnLock() )

cDatFet := U14->U14_DATFET
cHorFet := U14->U14_HORFET

If Len(aCols) > 1 .AND. !lFimCha
	U14->( DbSkip() )
	U14->( RecLock("U14",.F.) )
	U14->U14_TECETP := cTecEtp
	U14->U14_TECNOM := cTecNom
	U14->U14_DATETP := cDatFet
	U14->U14_HORETP := cHorFet
	U14->( MsUnLock() )
Endif

U02->( RecLock("U02",.F.) )
If lFimCha
	U14->( DbSetOrder(1) )		// U14_FILIAL+U14_CODCHA+U14_CODETP
	U14->( MsSeek( xFilial("U14")+U02->U02_CODCHA ) )
	While	U14->( !Eof() ) .AND.;
		U14->U14_FILIAL == xFilial("U14") .AND.;
		U14->U14_CODCHA == U02->U02_CODCHA
		
		nTotHor += U_HtoN(U14->U14_TIMETP)
		
		U14->( DbSkip() )
	End
	
	U02->U02_EXECUT := 100
	U02->U02_DATFIM := cDatFet
	U02->U02_HORFIM := cHorFet
	U02->U02_TIMATD := U_NtoH(nTotHor)
	cComHis := cDesHis + CRLF + PadR(">>> CHAMADO ENCERRADO, POR: " + AllTrim(U10->U10_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
Else
	cComHis := cDesHis + CRLF + PadR(">>> ETAPA ENCERRADA, POR: " + AllTrim(U10->U10_LOGSIS) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
Endif
U02->U02_CLACHA := cClaCha
MSMM(,80,,cComHis,1,,,"U02","U02_CODHIS")
U02->( MsUnLock() )
End Transaction

aCols := {}
U14->( DbSetOrder(1) )		// U14_FILIAL+U14_CODCHA+U14_CODETP
U14->( MsSeek( xFilial("U14")+U02->U02_CODCHA ) )
While	U14->( !Eof() ) .AND.;
	U14->U14_FILIAL == xFilial("U14") .AND.;
	U14->U14_CODCHA == U02->U02_CODCHA
	
	Aadd( aCols, Array( Len(aHeader)+1 ) )
	For nI := 1 To Len(aHeader)
		cCampo := aHeader[nI][2]
		If aHeader[nI][10] <> "V"
			aCols[Len(aCols)][nI] := U14->(&cCampo)
		Else
			aCols[Len(aCols)][nI] := Criavar( aHeader[nI][2], .T. )
		Endif
	Next nI
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	U14->( DbSkip() )
End

oMsGetD:aCols := Aclone( aCols )
oMsGetD:ForceRefresh()

Return(lFimCha)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  09/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HD70TroTec(oMsGetD,cComHis,cClaCha,nExecut)

Local aHeader	:= Aclone(oMsGetD:aHeader)
Local aCols		:= Aclone(oMsGetD:aCols)
Local nI		:= 0
Local nPTecEtp	:= Ascan( aHeader, { |x| Alltrim(x[2])=="U14_TECETP" } )
Local cDesHis	:= MSMM( U02->U02_CODHIS )
Local nRecU10	:= U10->( RecNo() )
Local cLogSis	:= U10->U10_LOGSIS
Local cQuery	:= ""


If nPTecEtp == 0
	MsgStop("Erro estrutural no sistema, falta o campo U14_TECETP...")
	Return(.F.)
Endif

If Empty(cComHis)
	MsgStop("� obrigat�rio informar o hist�rico para realizar a transfer�ncia do chamado...")
	Return(.F.)
Endif

If !ConPad1(,,,'U10_01',,,.F.)
	Return(.F.)
Endif

If U10->( Eof() )
	U10->( DbGoTo(nRecU10) )
	Return(.F.)
Endif

U14->( DbSetOrder(1) )		// U14_FILIAL+U14_CODCHA+U14_CODETP
If U14->( !MsSeek( xFilial("U14")+U02->U02_CODCHA ) )
	MsgStop("Erro na localiza��o do chamado...")
	Return(.F.)
Endif

If Len(aCols) > 1
	While	U14->( !Eof() ) .AND.;
		U14->U14_FILIAL == xFilial("U14") .AND.;
		U14->U14_CODCHA == U02->U02_CODCHA
		
		If Empty(U14->U14_TECETP)
			U14->( DbSkip(-1) )
			Exit
		Endif
		
		U14->( DbSkip() )
	End
Endif

Begin Transaction
U14->( RecLock("U14",.F.) )
U14->U14_TECETP := U10->U10_CODUSR
U14->U14_TECNOM := U10->U10_NOMUSR
U14->( MsUnLock() )

U02->( RecLock("U02",.F.) )
U02->U02_TECCOD := U10->U10_CODUSR
U02->U02_EXECUT := nExecut
cComHis := cDesHis + CRLF + PadR(">>> CHAMADO TRANSFERIDO, POR: " + AllTrim(cLogSis) + " EM " + DtoC(dDataBase) + " AS " + Time() + " " + Replicate("-",80),80) + CRLF + CRLF + cComHis + CRLF + CRLF + CRLF
U02->U02_CLACHA := cClaCha
MSMM(,80,,cComHis,1,,,"U02","U02_CODHIS")
U02->( MsUnLock() )
End Transaction

U10->( DbGoTo(nRecU10) )

cQuery	:=	"SELECT * FROM ( SELECT R_E_C_N_O_ " +;
" FROM     " + RetSqlName("U02") +;
" WHERE    U02_FILIAL = '"+xFilial("U02")+"' AND U02_GRUATD = '"+U09->U09_CODGRU+"' AND U02_TECCOD = '"+U10->U10_CODUSR+"' AND D_E_L_E_T_ = ' ') WHERE ROWNUM <= 1"
PLSQuery( cQuery, "U02TMP" )
U02->( DbGoTo( U02TMP->R_E_C_N_O_ ) )
U02TMP->( DbCloseArea() )
DbSelectArea("U02")

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  09/16/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD070Ter(cAlias,nReg,nOpc)

Local aParam	:= {}
Local aCpos		:= {}

Aadd(aParam, {|| (M->U02_DESHIS:=MSMM(U02->U02_CODHIS),.T.) } )					// Executa Antes da interface
Aadd(aParam, {|| .T.} )					// Executa somente para Exclusao
Aadd(aParam, {|| U_HD70GrvTer() } )		// Executa dentro da transacao depois da gravacao
Aadd(aParam, {|| .T.} )					// Executa fora da transacao depois da gravacao

If U10->U10_TIPUSR <> "1"
	MsgStop("Rotina exclusiva para administradores do sistema...")
	Return(.F.)
Endif

SX3->( DbSetOrder(4) )		// X3_ARQUIVO+X3_FOLDER+X3_ORDEM
SX3->( MsSeek( cAlias+"3" ) )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == cAlias .AND. SX3->X3_FOLDER == "3"
	
	Aadd( aCpos, SX3->X3_CAMPO )
	
	SX3->( DbSkip() )
End

//AxAltera(cAlias,nReg,nOpc)
AxAltera(cAlias,nReg,nOpc,,aCpos,,,,,,,aParam)

//AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons,aParam,aAuto,lVirtual,lMaximized)

Return(.T.)

User Function HD70GrvTer()
MSMM(,80,,M->U02_INFORM,1,,,"U02","U02_CODINF")
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
User Function HD070Imp(cAlias,nReg,nOpc)

Local wnrel   	:= "HELPD01"			// Nome do Arquivo utilizado no Spool
Local Titulo 	:= "Emiss�o do(s) chamados em relat�rio"
Local cDesc1 	:= "Relat�rio usado para emiss�o de um ou todos os chamados."
Local cDesc2 	:= ""
Local cDesc3 	:= "A emiss�o ocorrer� baseada nos par�metros do relat�rio"
Local nomeprog	:= "HELPD01.PRW"		// Nome do programa
Local cString 	:= "U02"				// Alias utilizado na Filtragem
Local lDic    	:= .F.					// Habilita/Desabilita Dicionario
Local lComp   	:= .F.					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro 	:= .T.					// Habilita/Desabilita o Filtro

Private Tamanho := "P"					// P/M/G
Private Limite  := 80					// 80/132/220
Private aReturn := { "Zebrado",;		// [1] Reservado para Formulario
1,;				// [2] Reservado para N� de Vias
"Administrador",;	// [3] Destinatario
2,;				// [4] Formato => 1-Comprimido 2-Normal
1,;	    		// [5] Midia   => 1-Disco 2-Impressora
1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1...
"",;				// [7] Expressao do Filtro
1 } 				// [8] Ordem a ser selecionada
// [9]..[10]..[n] Campos a Processar (se houver)
Private m_pag   := 1					// Contador de Paginas
Private nLastKey:= 0					// Controla o cancelamento da SetPrint e SetDefault
Private cPerg   := "HLPD01"				// Pergunta do Relatorio
Private aOrdem  := {}					// Ordem do Relatorio

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
AjustaSX1(cPerg)
Pergunte(cPerg, .F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

RptStatus({|lEnd| ImpHelpDesk(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpSLR64  �Autor  �Armando M. Tessaroli� Data �  25/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de impressao dos dados.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Sao Lucas                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpHelpDesk(lEnd,wnrel,cString,nomeprog,Titulo)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao Do Cabecalho e Rodape    �
//����������������������������������������������������������������
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cbCont	:= 0			// Numero de Registros Processados
Local cbText	:= SPACE(10)	// Mensagem do Rodape
Local cCabec1	:= ""			// Label dos itens
Local cCabec2	:= "" 			// Label dos itens

//�������������������������������������������������������Ŀ
//�Declaracao de variaveis especificas para este relatorio�
//���������������������������������������������������������
Local cQuery	:= ""			// Armazena a expressao da query para top
Local nQtd		:= 0			// Contator de chamados emitidos
Local aMemo		:= {}			// Recupera o conteudo do campo memo para impressao
Local nI		:= 0			// Controle de loop
Local aStatus	:= {}			// Armazena os Status de acordo com o SX3
Local nDias		:= 0			// Dias de evolucao do projeto
Local dEntrega	:= dDataBase	// Data prevista para entrega da atividade
Local nRecU10	:= U10->( RecNo() )

Aadd( aStatus, {"","Aberto","Em Analise","Encerrado","Reabertura","Encaminhado"} )

cQuery	:=	" SELECT          U02_CODCHA, U02_DATCHA, U02_STATUS, U02_TECCOD, U02_USRLOG, U02_DESCHA, U02_CODHIS, U02_CHATER, U02_EXECUT, U02_HORTER, U02_CONTAT " +;
" FROM            " + RetSQLName("U02") + " U02 " +;
" WHERE           U02.U02_FILIAL = '" + xFilial("U02") + "' AND "
If (ValType(Mv_Par01) == "N" .AND. Mv_Par01 == 1) .OR. (ValType(Mv_Par01) == "C" .AND. Mv_Par01 == "1")
	cQuery	+=	"             U02.R_E_C_N_O_ = " + AllTrim( Str( U02->( Recno() ) ) ) + " AND "
Else
	If !Empty(Mv_Par02)
		cQuery	+=	"         U02.U02_USRCOD = '" + Mv_Par02 + "' AND "
	Endif
	If !Empty(Mv_Par03)
		cQuery	+=	"         U02.U02_USRGRU = '" + Mv_Par03 + "' AND "
	Endif
	If Str(Mv_Par04,1) $ "1,2,3"
		cQuery	+=	"         U02.U02_STATUS = " + AllTrim(Str(Mv_Par04)) + " AND "
	ElseIf Str(Mv_Par04,1) == "5"
		cQuery	+=	"         U02.U02_STATUS IN ('1','2') AND " +;
		"         U02.U02_EXECUT < 100 AND "
	Endif
	If !Empty(Mv_Par05)
		cQuery	+=	"         U02.U02_CODPRJ = '" + Mv_Par05 + "' AND "
	Endif
Endif
cQuery	+=	"                 U02.D_E_L_E_T_ = ' ' " +;
" ORDER BY        U02.U02_CODCHA "

PLSQuery( cQuery, "U02TMP" )

SetRegua( U02TMP->( RecCount() ) )

While U02TMP->( !Eof() )
	IncRegua("Imprimindo chamados " + AllTrim(Str(nQtd++)) )
	ProcessMessage()
	
	If lEnd
		@Prow()+1,000 PSay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Considera filtro do usuario                                  �
	//����������������������������������������������������������������
	If (!Empty(aReturn[7])) .AND. (!&(aReturn[7]))
		SB9TMP->( DbSkip() )
		Loop
	Endif
	
	U10->( DbSetOrder(1) )
	U10->( MsSeek( xFilial("U10")+U02TMP->U02_TECCOD ) )
	
	If Mv_Par06 == 1		// Analitico
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay U02TMP->U02_CODCHA
		@ nLi,PCol()+2	PSay AllTrim(U02TMP->U02_DESCHA)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay Replicate("-",80)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay U02TMP->U02_DATCHA
		@ nLi,PCol()+2	PSay PadR(aStatus[1][Val(U02TMP->U02_STATUS)+1], 10)
		@ nLi,PCol()+2	PSay PadR(U02TMP->U02_USRLOG,15)
		@ nLi,PCol()+2	PSay PadR(U10->U10_NOMUSR,15)
		@ nLi,PCol()+2	PSay PadR(U02TMP->U02_CHATER,10)
		@ nLi,PCol()+2	PSay Str(U02TMP->U02_EXECUT,3) + " %"
		
		aMemo := LineMemo(U02TMP->U02_CODHIS,80)
		For nI := 1 To Len(aMemo)
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,000	PSay aMemo[nI]
		Next nI
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay __PrtFatLine()
		
		// Pula uma linha
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	Else
		Tamanho := "P"					// P/M/G
		Limite  := 80					// 80/132/220
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay Str(U02TMP->U02_EXECUT,3) + " %"
		@ nLi,PCol()+1	PSay PadR(aStatus[1][Val(U02TMP->U02_STATUS)+1], 10)
		@ nLi,PCol()+1	PSay U02TMP->U02_CODCHA
		@ nLi,PCol()+1	PSay U02TMP->U02_DESCHA
		@ nLi,PCol()+1	PSay U02TMP->U02_DATCHA
		@ nLi,PCol()+1	PSay PadR(U02TMP->U02_HORTER,05)
		nDias := ((Val(SubStr(U02TMP->U02_HORTER,1,2))*(100-U02TMP->U02_EXECUT)/100)/6)
		nDias += (((Val(SubStr(U02TMP->U02_HORTER,4,2))/60)*(100-U02TMP->U02_EXECUT)/100)/6)
		For nI := 1 To nDias
			If DOW(dEntrega + nI) == 1 .OR. DOW(dEntrega + nI) == 7
				nDias ++
			Endif
		Next nI
		dEntrega := dEntrega + nDias
		@ nLi,PCol()+1	PSay dEntrega
		@ nLi,PCol()+1	PSay PadR(U10->U10_NOMUSR,10)
		@ nLi,PCol()+1	PSay PadR(U02TMP->U02_CHATER,10)
		
		If !Empty(U02TMP->U02_CONTAT)
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,026		PSay PadR(U02TMP->U02_CONTAT,110)
		Endif
	Endif
	
	U02TMP->( DbSkip() )
End
U02TMP->( DbCloseArea() )


If nLi == 0
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi+1,000 PSay "N�o h� informa��es para imprimir este relat�rio"
Endif

Roda(cbCont,cbText,Tamanho)

Set Device To Screen
If ( aReturn[5] = 1 )
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

U10->( DbGoTo(nRecU10) )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LineMemo  �Autor  �Armando M. Tessaroli� Data �  05/02/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta o texto conforme foi digitado pelo operador e quebra  ���
���          �as linhas no tamanho especificado sem cortar palavras e     ���
���          �devolve um array com os textos a serem impressos.           ���
�������������������������������������������������������������������������͹��
���Parametros� cCodigo - Codigo de referencia da gravacao do memo         ���
���          � nTaM    - Tamanho maximo de colunas do texto               ���
�������������������������������������������������������������������������͹��
���Uso       � Call Center                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LineMemo(cCodigo,nTam)

Local cString	:= MSMM(cCodigo,nTam)		// Carrega o memo da base de dados
Local nI		:= 0    					// Contador dos caracteres
Local nL		:= 0						// Contador das linhas
Local cLinha	:= ""						// Guarda a linha editada no campo memo
Local aLinhas	:= {}						// Array com o memo dividido em linhas
Local nJ		:= 0						// Contador das linhas

For nI := 1 TO Len(cString)
	
	// Codigo do complemtno do enter, preciso ignorar este caracter.
	If Asc(SubStr(cString,nI,1)) == 10
		Loop
	Endif
	
	If (Asc(SubStr(cString,nI,1)) <> 13) .AND. (nL < nTam)
		// Enquanto n�o houve enter na digitacao e a linha nao atingiu o tamanho maximo
		cLinha+=SubStr(cString,nI,1)
		nL++
	Else
		// Se a linha atingiu o tamanho maximo ela vai entrar no array
		If Asc(SubStr(cString,nI,1)) <> 13 .AND. Asc(SubStr(cString,nI,1)) <> 45
			nI--
			For nJ := Len(cLinha) To 1 Step -1
				// Verifica se a ultima palavra da linha foi quebrada, entao retira e passa pra frente
				If SubStr(cLinha,nJ,1) <> " "
					nI--
					nL--
				Else
					Exit
				EndIf
			Next nJ
			// Se a palavra for maior que o tamanho maximo entao ela vai ser quebrada
			If nL <=0
				nL := Len(cLinha)
			EndIf
		EndIf
		
		// Testa o valor de nL para proteger o fonte e insere a linha no array
		If nL >= 0
			cLinha := SubStr(cLinha,1,nL)
			AADD(aLinhas, cLinha)
			cLinha := ""
			nL := 0
		Endif
	EndIf
Next nI

// Se o nL > 0, eh porque o usuario nao deu enter no fim do memo e eu adiciono a linha no array.
If nL >= 0
	cLinha := SubStr(cLinha,1,nL)
	AADD(aLinhas, cLinha)
	cLinha := ""
	nL := 0
Endif

Return(aLinhas)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AJUSTASX1 �Autor  �Grupo Sao Lucas     � Data �  31/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria o pergunte padrao                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Sao Lucas                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(cPerg)

Local aRegs	:=	{}

Aadd(aRegs,{cPerg,"01","Apenas Chamado Posicionado",	"","","MV_CH1","N",01,0,0,"C","","Mv_Par01","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Usu�rio",						"","","MV_CH2","C",06,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Setor",							"","","MV_CH3","C",06,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Status",						"","","MV_CH4","N",01,0,0,"C","","Mv_Par04","Aberto","","","","","Em an�lise","","","","","Encerrado","","","","","Todos","","","","","Pendencias","","","","","Encaminhado","","","",""})
Aadd(aRegs,{cPerg,"05","Projeto de Terceiros",			"","","MV_CH5","C",10,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Tipo de Apresenta��o",			"","","MV_CH6","N",01,0,0,"C","","Mv_Par06","Anal�tico","","","","","Sint�tico","","","","","","","","","","","","","","","","","","","","","","","",""})

PlsVldPerg( aRegs )

Return()



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA070    �Autor  �Microsiga           � Data �  10/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HD070CpoVal(cCampo,cChave)

DEFAULT cCampo	:= ""
DEFAULT cChave	:= ""

If Empty(cCampo)
	Return(.F.)
Endif

If Empty(cChave)
	Return(.T.)
Endif

Do Case
	Case cCampo == "cGruAtd"
		U09->( DbSetOrder(1) )
		If U09->( !MsSeek( xFilial("U09")+cChave ) )
			MsgStop("O registro informado n�o foi localizado na tabela de grupos...")
			Return(.F.)
		Endif
		
	Case cCampo == "cGruSeg"
		U16->( DbSetOrder(1) )
		If U16->( !MsSeek( xFilial("U16")+cChave ) )
			MsgStop("O registro informado n�o foi localizado na tabela de segmento...")
			Return(.F.)
		Endif
		
		If U16->U16_CODGRU <> U09->U09_CODGRU
			MsgStop("Segmento n�o pertence ao grupo informado no chamado...")
			Return(.F.)
		Endif
		
		If U16->U16_STATUS <> "1"
			MsgStop("Segmento n�o liberado para uso...")
			Return(.F.)
		Endif
		
	Case cCampo == "cGruCla"
		U11->( DbSetOrder(1) )
		If U11->( !MsSeek( xFilial("U11")+cChave ) )
			MsgStop("O registro informado n�o foi localizado na tabela de objetivos...")
			Return(.F.)
		Endif
		
		If U11->U11_CODSEG <> U16->U16_CODSEG
			MsgStop("Classifica��o n�o pertence ao segmento do grupo informado no chamado...")
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
���Programa  �MailRetor �Autor  �Opvs (Gabriel)      � Data �  08/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envia e-mail de feedback de atendimento                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MailRetor(cEstPara,aPara,lNew,cComHis,cCodCha)

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

cAssunto := "FeedBack do Atendimento C�digo "+cCodCha
cMsg :=  cComHis

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
