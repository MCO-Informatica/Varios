#INCLUDE "PROTHEUS.CH"

Static oMsMGet, oMsGetD

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  08/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HDA050()

// 1=Ativo;2=Manutencao;3=Estocado;4=Baixado
Local aCores		:= {	{ "U11->U11_STATUS=='1'",	"BR_VERDE"		},;
							{ "U11->U11_STATUS=='2'",	"BR_VERMELHO"	};
						 }


PRIVATE aRotina := {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
						{ "Visualizar",	"U_HD050Vis",	0, 2	},;
						{ "Incluir",	"U_HD050Inc",	0, 3	},;
						{ "Alterar",	"U_HD050Alt",	0, 4, 2	},;
						{ "Excluir",	"U_HD050Exc",	0, 5, 1	},;
						{ "Legenda",	"U_HD050Leg",	0, 2	};
						 }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o cabecalho da tela de atualizacoes                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE cCadastro := "Classifica็ใo dos Chamados"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Endereca a funcao de BROWSE                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
mBrowse(0,0,0,0,"U11",,,,,,aCores)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HD050Vis(cAlias, nReg, nOpc)

Local oDlg
Local aButtons		:= {}
Local aHeader		:= {}
Local aCols			:= {}
Local nI			:= 0
Local aCampos		:= {}
Local nWidth		:= oMainWnd:nClientWidth * .99
Local nHeight		:= oMainWnd:nClientHeight * .95
Local cCampo		:= ""

// Dados para a MsMGet
RegToMemory(cAlias,.F.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U11") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U11"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

// Dados para a MsNewGetDados
SX3->( MsSeek("U12") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U12"
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

U12->( DbSetOrder(1) )
U12->( MsSeek( xFilial("U12")+U11->U11_CODCLA ) )
While	U12->( !Eof() ) .AND.;
		U12->U12_FILIAL == xFilial("U12") .AND.;
		U12->U12_CODCLA == U11->U11_CODCLA
		
	Aadd( aCols, Array( Len(aHeader)+1 ) )
	For nI := 1 To Len(aHeader)
		cCampo := aHeader[nI][2]
		If aHeader[nI][10] <> "V"
			aCols[Len(aCols)][nI] := U12->(&cCampo)
		Else
			aCols[Len(aCols)][nI] := Criavar( aHeader[nI][2], .T. )
		Endif
	Next nI
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	U12->( DbSkip() )
End

//Aadd(aButtons,{ "FERRAM",	{|| MDP90Copy() }, "Copia os agendados de uma dia para outro dia.", "Copiar" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| oDlg:End() },{|| oDlg:End() },,aButtons)

oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/4),(nWidth/2)},,3,,,,oDlg)

oMsGetD := MsNewGetDados():New((nHeight/4),000,(nHeight/2)-15,(nWidth/2),,,,,,,4096,,,,oDlg,aHeader,aCols)

ACTIVATE DIALOG oDlg CENTERED

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HD050Inc(cAlias, nReg, nOpc)

Local oDlg
Local aButtons		:= {}
Local aHeader		:= {}
Local aCols			:= {}
Local nI			:= 0
Local aCampos		:= {}
Local nWidth		:= oMainWnd:nClientWidth * .99
Local nHeight		:= oMainWnd:nClientHeight * .95
Local cCampo		:= ""

Private aGets[0][0],aTela[0]

// Dados para a MsMGet
RegToMemory(cAlias,.T.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U11") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U11"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

// Dados para a MsNewGetDados
SX3->( MsSeek("U12") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U12"
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

aCols :=  Array( 1, Len(aHeader)+1 )
For nI := 1 To Len(aHeader)
	aCols[1][nI] := Criavar( aHeader[nI][2], .T. )
Next nI
aCols[1][Len(aHeader)+1] := .F.


Aadd(aButtons,{ "FERRAM",	{|| U_HD050Calc() }, "Calcula o SLA da classifica็ใo do chamado.", "SLA" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| IIF(Obrigatorio(aGets,aTela),(HWGrv(aCampos,oMsGetD,nOpc),oDlg:End()),AllWaysTrue()) },{|| (HWSai(),oDlg:End()) },,aButtons)

oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/4),(nWidth/2)},,3,,,,oDlg)

oMsGetD := MsNewGetDados():New((nHeight/4),000,(nHeight/2)-15,(nWidth/2),GD_INSERT+GD_DELETE+GD_UPDATE,"U_HDLINOK()",,,,,4096,"U_HDFIELOK()",,"U_HDDELOK()",oDlg,aHeader,aCols)

ACTIVATE DIALOG oDlg CENTERED

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HD050Alt(cAlias, nReg, nOpc)

Local oDlg
Local aButtons		:= {}
Local aHeader		:= {}
Local aCols			:= {}
Local nI			:= 0
Local aCampos		:= {}
Local nWidth		:= oMainWnd:nClientWidth * .99
Local nHeight		:= oMainWnd:nClientHeight * .95
Local cCampo		:= ""

Private aGets[0][0],aTela[0]

// Dados para a MsMGet
RegToMemory(cAlias,.F.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U11") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U11"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

// Dados para a MsNewGetDados
SX3->( MsSeek("U12") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U12"
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

U12->( DbSetOrder(1) )
U12->( MsSeek( xFilial("U12")+U11->U11_CODCLA ) )
While	U12->( !Eof() ) .AND.;
		U12->U12_FILIAL == xFilial("U12") .AND.;
		U12->U12_CODCLA == U11->U11_CODCLA
		
	Aadd( aCols, Array( Len(aHeader)+1 ) )
	For nI := 1 To Len(aHeader)
		cCampo := aHeader[nI][2]
		If aHeader[nI][10] <> "V"
			aCols[Len(aCols)][nI] := U12->(&cCampo)
		Else
			aCols[Len(aCols)][nI] := Criavar( aHeader[nI][2], .T. )
		Endif
	Next nI
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	U12->( DbSkip() )
End


Aadd(aButtons,{ "FERRAM",	{|| U_HD050Calc() }, "Calcula o SLA da classifica็ใo do chamado.", "SLA" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| IIF(Obrigatorio(aGets,aTela),(HWGrv(aCampos,oMsGetD,nOpc),oDlg:End()),AllWaysTrue()) },{|| oDlg:End() },,aButtons)

oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/4),(nWidth/2)},,3,,,,oDlg)

oMsGetD := MsNewGetDados():New((nHeight/4),000,(nHeight/2)-15,(nWidth/2),GD_INSERT+GD_DELETE+GD_UPDATE,"U_HDLINOK()",,,,,4096,"U_HDFIELOK()",,"U_HDDELOK()",oDlg,aHeader,aCols)

ACTIVATE DIALOG oDlg CENTERED

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HD050Exc(cAlias, nReg, nOpc)

Local oDlg
Local aButtons		:= {}
Local aHeader		:= {}
Local aCols			:= {}
Local nI			:= 0
Local aCampos		:= {}
Local nWidth		:= oMainWnd:nClientWidth * .99
Local nHeight		:= oMainWnd:nClientHeight * .95
Local cCampo		:= ""

// Dados para a MsMGet
RegToMemory(cAlias,.F.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U11") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U11"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

// Dados para a MsNewGetDados
SX3->( MsSeek("U12") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U12"
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

U12->( DbSetOrder(1) )
U12->( MsSeek( xFilial("U12")+U11->U11_CODCLA ) )
While	U12->( !Eof() ) .AND.;
		U12->U12_FILIAL == xFilial("U12") .AND.;
		U12->U12_CODCLA == U11->U11_CODCLA
		
	Aadd( aCols, Array( Len(aHeader)+1 ) )
	For nI := 1 To Len(aHeader)
		cCampo := aHeader[nI][2]
		If aHeader[nI][10] <> "V"
			aCols[Len(aCols)][nI] := U12->(&cCampo)
		Else
			aCols[Len(aCols)][nI] := Criavar( aHeader[nI][2], .T. )
		Endif
	Next nI
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	U12->( DbSkip() )
End

//Aadd(aButtons,{ "FERRAM",	{|| MDP90Copy() }, "Copia os agendados de uma dia para outro dia.", "Copiar" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| (HWExc(),oDlg:End()) },{|| oDlg:End() },,aButtons)

oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/4),(nWidth/2)},,3,,,,oDlg)

oMsGetD := MsNewGetDados():New((nHeight/4),000,(nHeight/2)-15,(nWidth/2),,,,,,,4096,,,,oDlg,aHeader,aCols)

ACTIVATE DIALOG oDlg CENTERED

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  05/25/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HDFIELOK()

Local cVar		:= ReadVar()
Local cCont		:= &( cVar )
Local aCols		:= Aclone(oMsGetD:aCols)
Local aHeader	:= Aclone(oMsGetD:aHeader)
Local nPSlaEtp	:= Ascan( aHeader, { |x| AllTrim(x[2])=="U12_SLAETP" } )

Do Case
	Case cVar == "M->U12_CODETP"
		M->U12_CODETP := StrZero(Val(cCont),4)
	Case cVar == "M->U12_SLAETP"
		M->U12_SLAETP := StrZero( Val( SubStr(M->U12_SLAETP,1,3)),3) + ":" + StrZero(Val(SubStr(M->U12_SLAETP,5,2)),2)
		If Val(SubStr(cCont,4,2)) > 60
			MsgStop("Formato de hora invalido...")
			Return(.F.)                                
		Endif
		M->U11_SLACLA := U_HFormat( U_NtoH( U_HtoN(M->U11_SLACLA) + U_HtoN(cCont) - U_HtoN(aCols[oMsGetD:nAt][nPSlaEtp]) ), 3, 2, ":")
Endcase

oMsMGet:Refresh()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHDA050    บAutor  ณMicrosiga           บ Data ณ  08/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function HDDELOK()

Local aCols		:= Aclone(oMsGetD:aCols)
Local aHeader	:= Aclone(oMsGetD:aHeader)
Local nPSlaEtp	:= Ascan( aHeader, { |x| AllTrim(x[2])=="U12_SLAETP" } )

If aCols[oMsGetD:nAt][Len(aCols[oMsGetD:nAt])]
	M->U11_SLACLA := U_HFormat( U_NtoH( U_HtoN(M->U11_SLACLA) + U_HtoN(aCols[oMsGetD:nAt][nPSlaEtp]) ), 3, 2, ":")
Else
	M->U11_SLACLA := U_HFormat( U_NtoH( U_HtoN(M->U11_SLACLA) - U_HtoN(aCols[oMsGetD:nAt][nPSlaEtp]) ), 3, 2, ":")
Endif

oMsMGet:Refresh()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HDLINOK()

Local aCols	:= oMsGetD:aCols
Local nI	:= 0

For nI := 1 To Len(aCols)
	If Empty(aCols[nI][oMsGetD:nAt])
		MsgStop("Campo obrigat๓rio nใo preenchido...")
		Return(.F.)
	Endif
Next nI

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050     บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HWGrv(aCampos,oMsGetD,nOpc)

Local nI		:= 0
Local nJ		:= 0
Local cCampo	:= ""
Local nPCpo		:= 0
Local aHeader	:= Aclone(oMsGetD:aHeader)
Local aCols		:= {}
Local nPCodEtp	:= Ascan( aHeader, { |x| AllTrim(x[2])=="U12_CODETP" } )
Local nContReg	:= 0

U_HD050Calc()

aCols := Aclone(oMsGetD:aCols)

Begin Transaction
	
	// Grava a tabela de HD050wares
	U11->( RecLock("U11", INCLUI) )
	
	If INCLUI
		RollBackSX8()
		U11->U11_FILIAL	:= xFilial("U11")
		U11->U11_CODCLA	:= GetSXENum("U11", "U11_CODCLA")
		ConfirmSX8()
	Endif
	
	For nI := 1 To Len(aCampos)
		cCampo := aCampos[nI]
		U11->(&cCampo) := M->(&cCampo)
	Next nI
	
	U11->( MsUnLock() )
	
	
	// Grava a tabela de softwares instalados nos HD050wares
	U12->( DbSetOrder(1) )
	For nJ := 1 To Len(aCols)
		
		If Empty(aCols[nJ][nPCodEtp])
			Loop
		Endif
		
		If aCols[nJ][Len(aCols[nJ])]
			
			If INCLUI
				Loop
			Endif
			
			If U12->( MsSeek( xFilial("U12")+U11->U11_CODCLA+aCols[nJ][nPCodEtp] ) )
				U12->( RecLock("U12", .F. ) )
				U12->( DbDelete() )
				U12->( MsUnLock() )
			Endif
			
			Loop			
		Endif
		
		If ALTERA
			U12->( MsSeek( xFilial("U12")+U11->U11_CODCLA+aCols[nJ][nPCodEtp] ) )
			U12->( RecLock("U12", U12->(!Found()) ) )
		Else
			U12->( RecLock("U12", .T. ) )
		Endif
		
		U12->U12_FILIAL := xFilial("U12")
		U12->U12_CODCLA := U11->U11_CODCLA
		
		For nI := 1 To Len(aHeader)
			cCampo := AllTrim(aHeader[nI][2])
			nPCpo := Ascan( aHeader, { |x| AllTrim(x[2])==cCampo } )
			If nPCpo > 0 .AND. nPCpo <= Len(aCols[nJ]) .AND. aHeader[nI][10] <> "V"
				U12->(&cCampo) := aCols[nJ][nPCpo]
			Endif
		Next nI
		U12->( MsUnLock() )
		
	Next nJ
	
End Transaction

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HWExc()

Begin Transaction
	
	// Apaga os softwares instalados
	U12->( DbSetOrder(1) )
	U12->( MsSeek( xFilial("U12")+M->U11_CODCLA ) )
	While	U12->( !Eof() ) .AND.;
			U12->U12_FILIAL == xFilial("U12") .AND.;
			U12->U12_CODCLA == M->U11_CODCLA
		
		U12->( RecLock("U12", .F.) )
		U12->( DbDelete() )
		U12->( MsUnLock() )
		
		U12->( DbSkip() )
	End
	
	// Apaga o HD050aware
	U11->( RecLock("U11", .F.) )
	U11->( DbDelete() )
	U11->( MsUnLock() )
End Transaction

Return(.F.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HWSai()
RollBackSX8()
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHD050WARE  บAutor  ณMicrosiga           บ Data ณ  06/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HD050Leg()

// 1=Ativo;2=Manutencao;3=Estocado;4=Baixado

BrwLegenda(cCadastro,"Legenda", {	{"BR_VERDE",	"Classifica็ใo Ativa"},;
									{"BR_VERMELHO",	"Bloqueado ou Cancelado"};
								  };
			)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHDA050    บAutor  ณMicrosiga           บ Data ณ  08/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HD050Calc()

Local aHeader	:= Aclone(oMsGetD:aHeader)
Local aCols		:= Aclone(oMsGetD:aCols)
Local nPCodEtp	:= Ascan( aHeader, { |x| AllTrim(x[2])=="U12_CODETP" } )
Local nPSlaEtp	:= Ascan( aHeader, { |x| AllTrim(x[2])=="U12_SLAETP" } )
Local nI		:= 0

Asort( aCols,,, { |x,y| x[1]<y[1] } )

While nI < Len(aCols)
	nI++
	If aCols[nI][Len(aCols[nI])]
		Adel( aCols, nI )
		Asize( aCols, Len(aCols)-1 )
		nI--
	Endif
End

M->U11_SLACLA := ""
For nI := 1 To Len(aCols)
	aCols[nI][nPCodEtp] := StrZero( nI*5, 4 )
	M->U11_SLACLA := U_HFormat( U_NtoH( U_HtoN(M->U11_SLACLA) + U_HtoN(aCols[nI][nPSlaEtp]) ), 3, 2, ":")
Next nI

oMsGetD:aCols := Aclone(aCols)
oMsGetD:Refresh()

Return(.T.)
