#INCLUDE "totvs.ch" 

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA100  º Autor ³ Microsiga      	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Entidades								      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPA100()

	PRIVATE aRotina := {	{ "Pesquisar"			,	"AxPesqui"			,	0, 1	},;
							{ "Visualizar"		,	"U_COM010Visu"	,	0, 2	},;
							{ "Incluir"			,	"U_COM010Incl"	,	0, 3	},;
							{ "Alterar"			,	"U_COM010Alte"	,	0, 4, 2},;
							{ "Excluir"			,	"U_COM010Dele"	,	0, 5, 1},;
							{ "Contatos"			,	"U_COM010Cont"	,	0, 6, 2},;
							{ "Camp.Incentivo"	,   "U_CRPA038"		,	0, 7	},;
							{ "Ent. s/ regras"	,	"U_CRPR020"		,	0, 8, 	},;
							{ "Vinc. Fornecedor"	,   "U_CRPA054"		,	0, 9	}}
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o cabecalho da tela de atualizacoes       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	PRIVATE cCadastro := "Cadastro de Entidades"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de brownse			         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	mBrowse(0,0,0,0,"SZ3")

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010Visu º Autor ³ Microsiga      	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Visualizar Cadastro de Entidades						      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010Visu(cAlias,nReg,nOpc)

	Local oDlg
	Local aButtons	:= {}
	Local nI		:= 0
	Local aHeader	:= {}
	Local aCols		:= {}
	Local nUsado	:= 0
	Local nHeight	:= oMainWnd:nClientHeight//*.90
	Local nWidth	:= oMainWnd:nClientWidth//*.98

	Private oMsGetD
    
	SX3->( DbSetOrder(1) )
	SX3->( MsSeek( "SZ4" ) )
	While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "SZ4"
		If X3uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader, {	SX3->X3_TITULO,;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
			nUsado++
		Endif
		
		SX3->( DbSkip() )
	End
	
	SZ4->( DbSetOrder(1) )		// Z4_FILIAL+Z4_CODENT
	SZ4->( MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT ) )
	While	SZ4->( !Eof() ) .AND.;
			SZ4->Z4_FILIAL == xFilial("SZ4") .AND.;
			SZ4->Z4_CODENT == SZ3->Z3_CODENT
		
		Aadd(aCols,Array(nUsado+1))
		For nI := 1 To nUsado
			If ( aHeader[nI][10] !=  "V" )
				aCols[Len(aCols)][nI] := SZ4->( FieldGet(FieldPos(aHeader[nI][2])) )
			Else
				aCols[Len(aCols)][nI] := CriaVar(aHeader[nI][2],.T.)
			EndIf
		Next nI
		
		aCols[Len(aCols)][nUsado+1] := .F.      
		SZ4->( DbSkip() )
	End
	
	RegToMemory(cAlias,.F.)

	// Define visualizacao da Enchoice no padrao das versoes anteriores a P11
	If GetMv("MV_ENCHOLD") == "2"
	     PutMv("MV_ENCHOLD","1")
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO nHeight, nWidth OF oMainWnd PIXEL
	
	//Aadd(aButtons,{ "TK_FONE",	{|| U_COM010Cont() }, "Gerência de contatos...", "Contatos" } )
	
	EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aButtons)
	
	MsMGet():New(cAlias,nReg,nOpc,,,,,{30,0,(nHeight/3),(nWidth/2)},,3,,,,oDlg)
	
	oMsGetD := MsNewGetDados():New((nHeight/4),0,(nHeight/2)-15,(nWidth/2),,,,,,,4096,,,,oDlg,aHeader,aCols)

	// Define visualizacao da Enchoice para o padrao P11
	If GetMv("MV_ENCHOLD") == "1"
	     PutMv("MV_ENCHOLD","2")
	Endif
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010Incl º Autor ³ Microsiga     	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Incluir Cadastro de Entidades						      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010Incl(cAlias,nReg,nOpc)

	Local oDlg
	Local aButtons	:= {}
	Local nI		:= 0
	Local aHeader	:= {}
	Local aCols		:= {}
	Local nUsado	:= 0
	Local nHeight	:= oMainWnd:nClientHeight//*.90
	Local nWidth	:= oMainWnd:nClientWidth//*.98
	
	Private oMsGetD
	
	SX3->( DbSetOrder(1) )
	SX3->( MsSeek( "SZ4" ) )
	While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "SZ4"
		If X3uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader, {	SX3->X3_TITULO,;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
			nUsado++
		Endif
		
		SX3->( DbSkip() )
	End
	
	Aadd(aCols,Array(nUsado+1))
	For nI := 1 To nUsado
		aCols[1][nI] := Criavar( aHeader[nI][2], .F. )
	Next nI
	aCols[1][Len(aHeader)+1] := .F.
	
	RegToMemory(cAlias,.T.)
	                                      
	// Define visualizacao da Enchoice no padrao das versoes anteriores a P11
	If GetMv("MV_ENCHOLD") == "2"
	     PutMv("MV_ENCHOLD","1")
	Endif

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO nHeight, nWidth OF oMainWnd PIXEL
	
	//Aadd(aButtons,{ "TK_FONE",	{|| U_COM010Cont() }, "Gerência de contatos...", "Contatos" } )
	
	EnchoiceBar(oDlg,{|| IIF(COM010GRV(cAlias, .T., oMsGetD),oDlg:End(),.F.) },{|| oDlg:End(),RollBackSX8() },,aButtons)
	
	MsMGet():New(cAlias,nReg,nOpc,,,,,{30,0,(nHeight/4),(nWidth/2)},,3,,,,oDlg)
	
	oMsGetD := MsNewGetDados():New((nHeight/4),0,(nHeight/2)-15,(nWidth/2),GD_INSERT+GD_DELETE+GD_UPDATE,,,,,,4096,,,,oDlg,aHeader,aCols)
	oMsGetD:lCanEditLine := .F.

	// Define visualizacao da Enchoice para o padrao P11
	If GetMv("MV_ENCHOLD") == "1"
	     PutMv("MV_ENCHOLD","2")
	Endif
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010Alte º Autor ³ Microsiga      	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Alterar Cadastro de Entidades						      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010Alte(cAlias,nReg,nOpc)

	Local oDlg
	Local aButtons	:= {}
	Local nI		:= 0
	Local aHeader	:= {}
	Local aCols		:= {}
	Local nUsado	:= 0
	Local cTabAnt	:= SZ3->Z3_CODTAB
	Local nHeight	:= oMainWnd:nClientHeight//*.90
	Local nWidth	:= oMainWnd:nClientWidth//*.98
	
	Private oMsGetD
	
	SX3->( DbSetOrder(1) )
	SX3->( MsSeek( "SZ4" ) )
	While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "SZ4"
		If X3uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader, {	SX3->X3_TITULO,;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
			nUsado++
		Endif
		
		SX3->( DbSkip() )
	End
	
	SZ4->( DbSetOrder(1) )		// Z4_FILIAL+Z4_CODENT
	SZ4->( MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT ) )
	While	SZ4->( !Eof() ) .AND.;
			SZ4->Z4_FILIAL == xFilial("SZ4") .AND.;
			SZ4->Z4_CODENT == SZ3->Z3_CODENT
		
		Aadd(aCols,Array(nUsado+1))
		For nI := 1 To nUsado
			If ( aHeader[nI][10] !=  "V" )
				aCols[Len(aCols)][nI] := SZ4->( FieldGet(FieldPos(aHeader[nI][2])) )
			Else
				aCols[Len(aCols)][nI] := CriaVar(aHeader[nI][2],.T.)
			EndIf
		Next nI
		aCols[Len(aCols)][nUsado+1] := .F.
		SZ4->( DbSkip() )
	End
	
	RegToMemory(cAlias,.F.)

	// Define visualizacao da Enchoice no padrao das versoes anteriores a P11
	If GetMv("MV_ENCHOLD") == "2"
	     PutMv("MV_ENCHOLD","1")
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO nHeight, nWidth OF oMainWnd PIXEL
	
	Aadd(aButtons,{ "TK_FONE",	{|| U_COM010Cont() }, "Gerência de contatos...", "Contatos" } )
	
	EnchoiceBar(oDlg,{|| IIF(COM010GRV(cAlias, .F., oMsGetD, nReg),oDlg:End(),.F.) },{|| oDlg:End(),RollBackSX8() },,aButtons)
	
	MsMGet():New(cAlias,nReg,nOpc,,,,,{30,0,(nHeight/4),(nWidth/2)},,3,,,,oDlg)
	
	oMsGetD := MsNewGetDados():New((nHeight/4),0,(nHeight/2)-15,(nWidth/2),GD_INSERT+GD_DELETE+GD_UPDATE,,,,,,4096,,,,oDlg,aHeader,aCols)
	oMsGetD:lCanEditLine := .F.

	// Define visualizacao da Enchoice para o padrao P11
	If GetMv("MV_ENCHOLD") == "1"
	     PutMv("MV_ENCHOLD","2")
	Endif
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010Dele º Autor ³ Microsiga      	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Deletar Cadastro de Entidades						      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010Dele(cAlias,nReg,nOpc)

	Local oDlg
	Local aButtons	:= {}
	Local nI		:= 0
	Local aHeader	:= {}
	Local aCols		:= {}
	Local nUsado	:= 0
	Local nHeight	:= oMainWnd:nClientHeight//*.90
	Local nWidth	:= oMainWnd:nClientWidth//*.98

	Private oMsGetD
	
	If !Empty(SZ3->Z3_CODTAB) .And. SZ3->Z3_TIPENT == "5"
		Alert("Existem tabelas de preço vinculada e por isso não poderá ser excluido!")
		Return
	Endif
	
	SX3->( DbSetOrder(1) )
	SX3->( MsSeek( "SZ4" ) )
	While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "SZ4"
		If X3uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader, {	SX3->X3_TITULO,;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
			nUsado++
		Endif
		
		SX3->( DbSkip() )
	End
	
	SZ4->( DbSetOrder(1) )		// Z4_FILIAL+Z4_CODENT
	SZ4->( MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT ) )
	While	SZ4->( !Eof() ) .AND.;
			SZ4->Z4_FILIAL == xFilial("SZ4") .AND.;
			SZ4->Z4_CODENT == SZ3->Z3_CODENT
		
		Aadd(aCols,Array(nUsado+1))
		For nI := 1 To nUsado
			If ( aHeader[nI][10] !=  "V" )
				aCols[Len(aCols)][nI] := SZ4->( FieldGet(FieldPos(aHeader[nI][2])) )
			Else
				aCols[Len(aCols)][nI] := CriaVar(aHeader[nI][2],.T.)
			EndIf
		Next nI
		aCols[Len(aCols)][nUsado+1] := .F.
		SZ4->( DbSkip() )
	End
	
	RegToMemory(cAlias,.F.)

	// Define visualizacao da Enchoice no padrao das versoes anteriores a P11
	If GetMv("MV_ENCHOLD") == "2"
	     PutMv("MV_ENCHOLD","1")
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO nHeight, nWidth OF oMainWnd PIXEL
	
	//Aadd(aButtons,{ "TK_FONE",	{|| U_COM010Cont() }, "Gerência de contatos...", "Contatos" } )
	
	EnchoiceBar(oDlg, {|| COM010Excl(),oDlg:End() }, {|| oDlg:End() },,aButtons)
	
	MsMGet():New(cAlias,nReg,nOpc,,,,,{30,0,(nHeight/4),(nWidth/2)},,3,,,,oDlg)
	
	oMsGetD := MsNewGetDados():New((nHeight/4),0,(nHeight/2)-15,(nWidth/2),,,,,,,4096,,,,oDlg,aHeader,aCols)

	// Define visualizacao da Enchoice para o padrao P11
	If GetMv("MV_ENCHOLD") == "1"
	     PutMv("MV_ENCHOLD","2")
	Endif
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010When  º Autor ³ Microsiga         º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Cadastro de Entidades							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010When(cCampo)

	Local lRet	:= .T.
	Local nPPorSft	:= Ascan( aHeader, { |x| AllTrim(x[2])=="Z4_PORSOFT" } )
	Local nPValSft	:= Ascan( aHeader, { |x| AllTrim(x[2])=="Z4_VALSOFT" } )
	Local nPPorHdr	:= Ascan( aHeader, { |x| AllTrim(x[2])=="Z4_PORHARD" } )
	Local nPValHdr	:= Ascan( aHeader, { |x| AllTrim(x[2])=="Z4_VALHARD" } )
	
	Do Case

		Case cCampo == "Z4_PORSOFT" .AND. nPValSft > 0
			lRet := Empty(aCols[n][nPValSft])
		
		Case cCampo == "Z4_VALSOFT" .AND. nPPorSft > 0
			lRet := Empty(aCols[n][nPPorSft])

		Case cCampo == "Z4_PORHARD" .AND. nPValHdr > 0
			lRet := Empty(aCols[n][nPValHdr])
		
		Case cCampo == "Z4_VALHARD" .AND. nPPorHdr > 0
			lRet := Empty(aCols[n][nPPorHdr])
		
	Endcase

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010GRV  º Autor ³ Microsiga      	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava Cadastro de Entidades							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function COM010GRV(cAlias, lNovo, oMsGetD, nReg)

	Local aCols		:= Aclone( oMsGetD:aCols )
	Local aHeader	:= Aclone( oMsGetD:aHeader )
	Local nX		:= 0
	Local nI		:= 0
	Local nJ		:= 0
	Local nJ		:= 0
	Local cTabAnt	:= Iif(lNovo,"",SZ3->Z3_CODTAB)
	Local aStruSZ3	:= SZ3->( DbStruct() )
	Local nPCatPro	:= Ascan( aHeader, { |x|, AllTrim(x[2])=="Z4_CATPROD" } )
	Local cLogErro	:= COM010Valid(oMsGetD)           
	Local lFaixa	:= .F.
	Local cCampAlt	:= ""
	Default nReg	:= 0
	
	If !Empty(cLogErro)
		MsgStop(cLogErro)
		Return(.F.)
	Endif
	
	If nReg <> 0
		SZ3->( DbGoTo(nReg) )
	Endif
	
	//Renato Ruy - 13/04/2018
	//Verificação para tabela de preço regionalizada
	//Somente pode existir uma tabela vinculada neste caso
	/*If !Empty(M->Z3_ESTADO) .And. M->Z3_TIPENT == "5"
		aTabela := StrToArray(M->Z3_CODTAB,",")
		
		If Len(aTabela) > 1
			Alert("Somente pode existir uma tabela vinculada, quando o grupo esta vinculado a uma Unidade Federativa!")
			Return
		Endif
		
		Beginsql Alias "TMPEST"
		
			//Apaga os registros da Filial 01
			SELECT Z3_CODENT FROM %TABLE:SZ3%
			WHERE
			Z3_FILIAL = %xFilial:SZ3% AND
			Z3_TIPENT = '5' AND
			Z3_ESTADO = %Exp:M->Z3_ESTADO% AND
			Z3_CODENT != %Exp:M->Z3_CODENT% AND
			%NOTDEL%
			
		Endsql
		
		If !Empty(TMPEST->Z3_CODENT)
			Alert("Uma Unidade Federativa já está vinculada ao grupo: "+TMPEST->Z3_CODENT)
			TMPEST->(DbCloseArea())
			Return
		Endif
		
		TMPEST->(DbCloseArea())
		
	Endif*/
	
	If M->Z3_TIPENT == "5" .And. Empty(M->Z3_CODGAR)
		MsgStop("O campo Ent no GAR não pode estar vazio. Por gentileza, verifique e tente novamente.")
		Return .F.
	EndIf

	
	Begin Transaction
		
		SZ3->( RecLock("SZ3", lNovo) )
		For nI := 1 To Len(aStruSZ3)
			Do Case
				Case AllTrim(aStruSZ3[nI][1]) == "Z3_FILIAL" .AND. lNovo
					SZ3->Z3_FILIAL	:= xFilial("SZ3")
				Otherwise
					//Renato Ruy 14/02/2017
					//Verifica campos alterados para enviar para o calculo
					If AllTrim(aStruSZ3[nI][1]) $ "Z3_CODCCR|Z3_CODAC|Z3_CODCAN|Z3_CODCAN2|Z3_CODFED" .And. &("SZ3->"+aStruSZ3[nI][1]) != &("M->"+aStruSZ3[nI][1])
						cCampAlt += aStruSZ3[nI][1] + "|"
					EndIf
					&("SZ3->"+aStruSZ3[nI][1])	:= &("M->"+aStruSZ3[nI][1])
					
			Endcase
		Next nI
		SZ3->Z3_ENVSITE := ""
		SZ3->( MsUnLock() )
		
		// Primeiro apaga os deletados da base de dados
		If !lNovo
			For nI := 1 To Len(aCols)
				If Empty(aCols[nI][nPCatPro])
					Loop
				Endif
				If aCols[nI][Len(aCols[nI])]
					SZ4->( DbSetOrder(1) )		// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
					If SZ4->( MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT+aCols[nI][nPCatPro] ) )
						SZ4->( RecLock("SZ4", .F. ) )
						SZ4->( DbDelete() )
						SZ4->( MsUnLock() )
					Endif
				Endif
			Next nI
		Endif
		
		// Agora comeca a fazer as gravacoes do que restou.
		For nI := 1 To Len(aCols)
			If Empty(aCols[nI][nPCatPro])
				Loop
			Endif
			
			If aCols[nI][Len(aCols[nI])]
				Loop
			Endif

			If aCols[nI][nPCatPro] $ "F1F2F3F4F5F6"
				lFaixa	:= .T.
			Endif

			If !lNovo
				SZ4->( DbSetOrder(1) )		// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
				SZ4->( MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT+aCols[nI][nPCatPro] ) )
				SZ4->( RecLock("SZ4", SZ4->( !Found() ) ) )
			Else
				SZ4->( RecLock("SZ4", lNovo) )
			Endif
			
			SZ4->Z4_FILIAL	:= xFilial("SZ4")
			SZ4->Z4_CODENT	:= SZ3->Z3_CODENT
			For nJ := 1 To Len(aHeader)
				If aHeader[nJ][10] <> "V"
					//Renato Ruy - 13/06/2018
					//Envia para recalculo quando existe alteracao no cadastro
					If SZ4->&(aHeader[nJ][2]) <> aCols[nI][nJ]
						cCampAlt += aHeader[nJ][2] + "|"	
					Endif
					
					SZ4->&(aHeader[nJ][2]) := aCols[nI][nJ]
				Endif
			Next nJ
			SZ4->( MsUnLock() )
		Next nI
        
		If lFaixa
			u_COM010SALDO(SZ3->Z3_CODENT)
		Endif
		
	ConfirmSX8()
	
	End Transaction
	
	If M->Z3_TIPENT $ "5"
		//MsAguarde({|| u_InfSite()	},"Comunicando com o HUB")
		MsAguarde({|| U_CSTA070(SZ3->Z3_CODGAR,cTabAnt ,SZ3->Z3_CODTAB,,SZ3->Z3_ESTADO)	},"Comunicando com o HUB")
	EndIf
	
	//Renato Ruy - 14/02/2016
	//Alterado para fazer o recalculo online do pedidos de periodos em aberto em backgroud.
	If !Empty(cCampAlt)
		StartJob("U_COMAON10",GetEnvServer(),.F.,SZ3->Z3_CODENT,SZ3->Z3_TIPENT,cCampAlt,cUserName)
	EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010Excl º Autor ³ Microsiga      	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Excluir Cadastro de Entidades						      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function COM010Excl()

	Local cQuery	:= ""
	Local cLog		:= ""
	Local lInfSite	:= .F.
	Local cGrupo	:= ""
	Local cTabAnt	:= ""
	
	cQuery	:=	" SELECT  COUNT(*) Z3_QTDLOC " +;
				" FROM    "+RetSqlName("SZ3")+" " +;
				" WHERE   Z3_FILIAL = '" + xFilial("SZ3") + "' AND " +;
				"         (Z3_CODCAN = '" + SZ3->Z3_CODENT + "' OR " +;
				"         Z3_CODAR = '" + SZ3->Z3_CODENT + "' OR " +;
				"         Z3_CODCCR = '" + SZ3->Z3_CODENT + "' OR " +;
				"         Z3_CODAC = '" + SZ3->Z3_CODENT + "') AND " +;
				"         D_E_L_E_T_ = ' ' "
	PLSQuery( cQuery, "SZ3TMP" )
	If SZ3TMP->Z3_QTDLOC > 0
		cLog += "Quantidade de alocações do registro nas entidades "+Alltrim(Str(SZ3TMP->Z3_QTDLOC))+CRLF
	Endif
	SZ3TMP->( DbCloseArea() )
	
	cQuery	:=	" SELECT  COUNT(*) Z6_QTDLOC " +;
				" FROM    "+RetSqlName("SZ6")+" " +;
				" WHERE   Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
				"         Z6_CODENT = '" + SZ3->Z3_CODENT + "' AND " +;
				"         D_E_L_E_T_ = ' ' "
	PLSQuery( cQuery, "SZ6TMP" )
	If SZ6TMP->Z6_QTDLOC > 0
		cLog += "Quantidade de alocações do registro em comissões "+Alltrim(Str(SZ6TMP->Z6_QTDLOC))+CRLF
	Endif
	SZ6TMP->( DbCloseArea() )
	
	If !Empty(cLog)
		cLog := "Não será possível excluir este registro, pois o mesmo possui os vinculos abaixo:"+CRLF+CRLF+cLog
		MsgStop(cLog)
		Return(.F.)
	Endif
	
	Begin Transaction
		
		AC8->( DbSetOrder(2) )		// AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
		AC8->( MsSeek( xFilial("AC8")+"SZ3"+xFilial("SZ3")+PadR(SZ3->Z3_CODENT,Len(AC8->AC8_CODENT)) ) )
		
		While	AC8->( !Eof() ) .AND.;
				AC8->AC8_FILIAL == xFilial("AC8") .AND.;
				AC8->AC8_ENTIDA == "SZ3" .AND.;
				AC8->AC8_FILENT == xFilial("SZ3") .AND.;
				AC8->AC8_CODENT == PadR(SZ3->Z3_CODENT,Len(AC8->AC8_CODENT))
				
			AC8->( RecLock("AC8",.F.) )
				AC8->( DbDelete() )
			AC8->( MsUnLock() )
			
			AC8->( DbSkip() )
		End
		
		SZ4->( DbSetOrder(1) )		// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
		SZ4->( MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT ) )
		
		While	SZ4->( !Eof() ) .AND.;
				SZ4->Z4_FILIAL == xFilial("SZ4") .AND.;
				SZ4->Z4_CODENT == SZ3->Z3_CODENT
			
			SZ4->( RecLock("SZ4",.F.) )
			SZ4->( DbDelete() )
			SZ4->( MsUnLock() )
			
			SZ4->( DbSkip() )
		End
		
		If SZ3->Z3_TIPENT $ "2,5"
			lInfSite := .T.	
			
			//Armazena Grupo e tabelas a serem excluidas
			cGrupo	:= SZ3->Z3_CODGAR
			cTabAnt	:= SZ3->Z3_CODTAB
			
			//SZ3->( RecLock("SZ3",.F.) )
			//SZ3->Z3_ENVSITE := ""
			//SZ3->( MsUnLock() ) 
			
		EndIf
		
		SZ3->( RecLock("SZ3",.F.) )
		SZ3->( DbDelete() )
		SZ3->( MsUnLock() )
		
	End Transaction
	
	If lInfSite .And. !Empty(cGrupo)
		MsAguarde({|| U_CSTA070(cGrupo,cTabAnt,"",,"")	},"Comunicando com o HUB")	
		//MsAguarde({|| u_InfSite()	},"Comunicando com o HUB")
	EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010Valid º Autor ³ Microsiga         º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Cadastro de Entidades							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function COM010Valid(oMsGetD)

	Local aCols		:= Aclone( oMsGetD:aCols )
	Local aHeader	:= Aclone( oMsGetD:aHeader )
	Local nI		:= 0
	Local nPCatPro	:= Ascan( aHeader, { |x|, AllTrim(x[2])== "Z4_CATPROD" } )
	Local cLog		:= ""
	Local cCatPro	:= ""          
	Local lCatPro	:= .F.
	
	aCols := Asort( aCols,,, { |x,y| x[1]<y[1] } )
			
	For nI := 1 To Len(aCols)
		If aCols[nI][Len(aCols[nI])]
			Loop
		Endif
		If Empty(aCols[nI][nPCatPro])
			Loop
		Endif
		If Empty(cCatPro)
			cCatPro := aCols[nI][nPCatPro]
			Loop
		Endif
		If !(AllTrim(cCatPro) $ "F1F2F3F4F5F6")
			lCatPro := .T.
		Endif
		If AllTrim(cCatPro) <> AllTrim(aCols[nI][nPCatPro])
			cCatPro := aCols[nI][nPCatPro]
		Else
			cLog += "Não é permitido lançar categoria de produto repetida para a mesma entidade."
		Endif
		//If AllTrim(cCatPro) $ "F1F2F3" .And. lCatPro
		//	cLog += "Não é permitido lançar regra de remuneração normal e de faixas pra mesma entidade."
		//Endif
	Next nI
	
	If !Empty(cLog)
		cLog := "Corrija as divergências cadastrais abaixo:" + CRLF + CRLF + cLog
	Endif

Return(cLog)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010ok    º Autor ³ Microsiga         º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Cadastro de Entidades							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010ok(cCampo)

	Local lRet	:= .F.
	Local aTabela := {}
	
	SZ3->( DbSetOrder(1) )
	
	Do Case
		Case cCampo == "Z3_CODCAN"
			If SZ3->( MsSeek( xFilial("SZ3")+M->Z3_CODCAN ) )
				If SZ3->Z3_TIPENT == "1"
					lRet := .T.
				Else
					MsgStop("Este código não pertence a um CANAL...")
				Endif
			Else
				MsgStop("Código do CANAL não localizado na base...")
			Endif
			
		Case cCampo == "Z3_CODAR"
			If SZ3->( MsSeek( xFilial("SZ3")+M->Z3_CODAR ) )
				If SZ3->Z3_TIPENT == "3"
					lRet := .T.
				Else
					MsgStop("Este código não pertence a um AR...")
				Endif
			Else
				MsgStop("Código do AR não localizado na base...")
			Endif
			
		Case cCampo == "Z3_CODAC"
			If SZ3->( MsSeek( xFilial("SZ3")+M->Z3_CODAC ) )
				If SZ3->Z3_TIPENT == "2"
					lRet := .T.
				Else
					MsgStop("Este código não pertence a um AC...")
				Endif
			Else
				MsgStop("Código do AC não localizado na base...")
			Endif
					 
			
	Endcase
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010SALDO º Autor ³ Microsiga         º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Adiciona registro de saldo de certificados verificados     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010SALDO(cCodEnt)

	Local nAno := Year(dDataBase)
	
	SZV->( DbSetOrder(1) )		// ZV_FILIAL+ZV_CODENT+ZV_SALANO
	If SZV->( !MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT+Str(nAno,4,0) ) )
		SZV->( RecLock("SZV",.T.) )
		SZV->ZV_FILIAL 	:= xFilial("SZV")
		SZV->ZV_CODENT 	:= cCodEnt
		SZV->ZV_DESENT	:= Posicione("SZ3",1,xFilial("SZV")+cCodEnt,"SZ3->Z3_DESENT")
		SZV->ZV_SALANO 	:= AllTrim(Str(nAno))
	  	SZV->ZV_SALACU 	:= 0
		SZV->ZV_LOGALT	:= "Automática (CRPA100) - "+DtoC(dDataBase)+" - "+Time()+" - INCLUIDO"
		SZV->( MsUnLock() )
	Endif	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
MANUTENCAO DE CONTATOS
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010Cont º Autor ³ Microsiga      	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³         												      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COM010Cont()

	Local oDlg
	Local aButtons	:= {}
	Local nHeight	:= oMainWnd:nClientHeight*.8
	Local nWidth	:= oMainWnd:nClientWidth*.8
	Local oCodCon
	Local cCodCon	:= Space(6)
	Local oNomCon
	Local cNomCon	:= Space(60)
	Local oBVincula
	Local oBExclui
	Local lVincula	:= .F.
	Local lExclui	:= .F.
	Local oLbxCont
	Local aContatos	:= {}
	Local oEnch
	Local aExclui	:= {}
	
	Aadd( aContatos, {"",""} )
	
	RegToMemory("SU5",.F.)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO nHeight, nWidth OF oMainWnd PIXEL
	
	//Aadd(aButtons,{ "TK_FONE",	{|| U_COM010Cont() }, "Gerência de contatos...", "Contatos" } )
	
	EnchoiceBar(oDlg, {|| COM010CtGrv(oLbxCont,aExclui),oDlg:End() }, {|| oDlg:End() },,aButtons)
	
	@ 15, 02 To (nHeight/7)-5, (nWidth/4) LABEL "Vínculo dos Contatos" OF oDlg PIXEL
	
	@ 25, 005 SAY "Contato" OF oDlg PIXEL
	@ 25, 030 MSGET oCodCon VAR cCodCon OF oDlg SIZE 40,5 PIXEL VALID Com010CodCon(oLbxCont,@oEnch,@lVincula,@lExclui,@cCodCon,@cNomCon) F3 "SU5"
	
	@ 37, 005 SAY "Nome" OF oDlg PIXEL
	@ 37, 030 GET oNomCon VAR cNomCon OF oDlg SIZE 165,5 PIXEL READONLY
	
	@ 52, 125 BUTTON oBVincula PROMPT "Vincular" SIZE 30,10 ACTION Com010VincAct(@oLbxCont,@oEnch,@lVincula,@lExclui,@cCodCon,@cNomCon) OF oDlg PIXEL WHEN lVincula
	
	@ 52, 165 BUTTON oBExclui PROMPT "Excluir" SIZE 30,10 ACTION Com010ActExcl(@aExclui,@oLbxCont,@oEnch,@lVincula,@lExclui,@cCodCon,@cNomCon,@oCodCon,@oNomCon) OF oDlg PIXEL WHEN lExclui
	
	@ 15, (nWidth/4)+2 LISTBOX oLbxCont FIELDS HEADER "Contato", "Nome" SIZE(nWidth/4),(nHeight/7)-17 OF oDlg PIXEL
	oLbxCont:SetArray(aContatos)
	oLbxCont:bLine := {||{;
					aContatos[oLbxCont:nAt][1],;
					aContatos[oLbxCont:nAt][2];
					}}
	oLbxCont:bChange := { || Com010Chang(@oLbxCont,@oEnch,@lVincula,@lExclui,@cCodCon,@cNomCon,@oCodCon,@oNomCon) }
	
	oEnch := MsMGet():New("SU5",SU5->(RecNo()),2,,,,,{(nHeight/7),0,(nHeight/2),(nWidth/2)+3},,3,,,,oDlg)
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT Com010AtuCont(@oLbxCont,@oEnch,@lVincula,@lExclui,@cCodCon,@cNomCon,@oCodCon,@oNomCon)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Com010AtuCont º Autor ³ Microsiga        º Data ³ 10/07/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                          							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Com010AtuCont(oLbxCont,oEnch,lVincula,lExclui,cCodCon,cNomCon,oCodCon,oNomCon)

	Local aContatos	:= {}
	Local cQuery	:= ""
	
	cQuery	:=	" SELECT    SU5.U5_CODCONT, SU5.U5_CONTAT " +;
				" FROM      " + RetSqlName("AC8") + " AC8, " + RetSqlName("SU5") + " SU5 " +;
				" WHERE     AC8.AC8_FILIAL = '" + xFilial("AC8") + "' AND " +;
				"           AC8.AC8_FILENT = '" + xFilial("SZ3") + "' AND " +;
				"           AC8.AC8_ENTIDA = 'SZ3' AND " +;
				"           AC8.AC8_CODENT = '" + SZ3->Z3_CODENT + "' AND " +;
				"           AC8.D_E_L_E_T_ = ' ' AND " +;
				"           SU5.U5_FILIAL = '" + xFilial("SU5") + "' AND " +;
				"           SU5.U5_CODCONT = AC8.AC8_CODCON AND " +;
				"           SU5.D_E_L_E_T_ = ' ' " +;
				" ORDER BY  SU5.U5_CONTAT "
	
	PLSQuery( cQuery, "SU5TMP" )
	
	While SU5TMP->( !Eof() )
		
		Aadd( aContatos, { SU5TMP->U5_CODCONT, SU5TMP->U5_CONTAT } )
		
		SU5TMP->( DbSkip() )
	End
	SU5TMP->( DbCloseArea() )
	
	If Len(aContatos) == 0
		Aadd( aContatos, {"",""} )
		SU5->( DbGoto(0) )
		cCodCon := Space(Len(SU5->U5_CODCONT))
		cNomCon := Space(Len(SU5->U5_CONTAT))
	Else
		SU5->( DbSetOrder(1) )
		SU5->( MsSeek( xFilial("SU5")+aContatos[1][1] ) )
		cCodCon := SU5->U5_CODCONT
		cNomCon := SU5->U5_CONTAT
	Endif
	
	oCodCon:Refresh()
	oNomCon:Refresh()
	
	oLbxCont:SetArray(aContatos)
	oLbxCont:bLine := {||{;
					aContatos[oLbxCont:nAt][1],;
					aContatos[oLbxCont:nAt][2];
					}}
	oLbxCont:Refresh()
	
	oEnch:Refresh()
	
	If !Empty(cCodCon) .AND. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lVincula := .T.
	Else
		lVincula := .F.
	Endif
	
	If Empty(cCodCon) .OR. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lExclui := .F.
	Else
		lExclui := .T.
	Endif
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Com010CodCon  º Autor ³ Microsiga        º Data ³ 10/07/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                          							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Com010CodCon(oLbxCont,oEnch,lVincula,lExclui,cCodCon,cNomCon)

	Local aContatos	:= Aclone( oLbxCont:aArray )
	Local nPos		:= 0
	
	SU5->( DbSetOrder(1) )
	If Empty(cCodCon) .OR. SU5->( !MsSeek( xFilial("SU5")+cCodCon ) )
		If Empty(aContatos[1][1])
			SU5->( DbGoto(0) )
		Else
			SU5->( !MsSeek( xFilial("SU5")+aContatos[oLbxCont:nAt][1] ) )
		Endif
		oEnch:Refresh()
		MsgStop("Código de contato invalido...")
		Return(.F.)
	Else
		cNomCon := SU5->U5_CONTAT
		
		nPos := Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } )
		
		If nPos == 0
			If Empty(aContatos[oLbxCont:nAt][1])
				SU5->( DbGoto(0) )
			Else
				SU5->( MsSeek( xFilial("SU5")+aContatos[oLbxCont:nAt][1] ) )
			Endif
		Else
			SU5->( MsSeek( xFilial("SU5")+cCodCon ) )
		Endif
	Endif
	
	oEnch:Refresh()
	
	If !Empty(cCodCon) .AND. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lVincula := .T.
	Else
		lVincula := .F.
	Endif
	
	If Empty(cCodCon) .OR. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lExclui := .F.
	Else
		lExclui := .T.
	Endif
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Com010VincAct º Autor ³ Microsiga        º Data ³ 10/07/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                          							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Com010VincAct(oLbxCont,oEnch,lVincula,lExclui,cCodCon,cNomCon)

	Local nPos		:= 0
	Local aContatos	:= Aclone( oLbxCont:aArray )
	
	SU5->( DbSetOrder(1) )
	If Empty(cCodCon) .OR. SU5->( !MsSeek( xFilial("SU5")+cCodCon ) )
		If Empty(aContatos[1][1])
			SU5->( DbGoto(0) )
		Else
			SU5->( !MsSeek( xFilial("SU5")+aContatos[oLbxCont:nAt][1] ) )
		Endif
		oEnch:Refresh()
		MsgStop("Código de contato invalido...")
		Return(.F.)
	Else
		nPos := Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } )
		If nPos > 0
			If Empty(aContatos[nPos][1])
				SU5->( DbGoto(0) )
			Else
				SU5->( !MsSeek( xFilial("SU5")+aContatos[nPos][1] ) )
			Endif
			oEnch:Refresh()
			MsgStop("Contato já incluido na lista de contatos da entidade...")
			Return(.F.)
		Endif
		
		If Len(aContatos) == 1 .AND. Empty(aContatos[1][1])
			aContatos[1][1] := SU5->U5_CODCONT
			aContatos[1][2] := SU5->U5_CONTAT
		Else
			Aadd( aContatos, { SU5->U5_CODCONT, SU5->U5_CONTAT } )
		Endif
		
	Endif
	
	Asort( aContatos,,, { |x,y| x[2]<y[2] } )
	
	oLbxCont:SetArray(aContatos)
	oLbxCont:bLine := {||{;
					aContatos[oLbxCont:nAt][1],;
					aContatos[oLbxCont:nAt][2];
					}}
	
	nPos := Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } )
	
	If nPos > 0
		oLbxCont:nAt := nPos
	Endif
	
	oLbxCont:Refresh()
	
	oEnch:Refresh()
	
	If !Empty(cCodCon) .AND. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lVincula := .T.
	Else
		lVincula := .F.
	Endif
	
	If Empty(cCodCon) .OR. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lExclui := .F.
	Else
		lExclui := .T.
	Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Com010Chang   º Autor ³ Microsiga        º Data ³ 10/07/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                          							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Com010Chang(oLbxCont,oEnch,lVincula,lExclui,cCodCon,cNomCon,oCodCon,oNomCon)

	Local aContatos	:= Aclone( oLbxCont:aArray )
	
	SU5->( DbSetOrder(1) )
	If Empty(aContatos[oLbxCont:nAt][1]) .OR. SU5->( !MsSeek( xFilial("SU5")+aContatos[oLbxCont:nAt][1] ) )
		SU5->( DbGoto(0) )
		cCodCon := Space(Len(SU5->U5_CODCONT))
		cNomCon := Space(Len(SU5->U5_CONTAT))
	Else
		cCodCon := SU5->U5_CODCONT
		cNomCon := SU5->U5_CONTAT
	Endif
	
	oCodCon:Refresh()
	oNomCon:Refresh()
	oEnch:Refresh()
	
	If !Empty(cCodCon) .AND. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lVincula := .T.
	Else
		lVincula := .F.
	Endif
	
	If Empty(cCodCon) .OR. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lExclui := .F.
	Else
		lExclui := .T.
	Endif
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Com010ActExcl º Autor ³ Microsiga        º Data ³ 10/07/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                          							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Com010ActExcl(aExclui,oLbxCont,oEnch,lVincula,lExclui,cCodCon,cNomCon,oCodCon,oNomCon)

	Local aContatos	:= Aclone( oLbxCont:aArray )
	Local nAt		:= oLbxCont:nAt
	
	Aadd( aExclui, { aContatos[nAt][1], aContatos[nAt][2] } )
	
	Adel( aContatos, nAt )
	
	Asize( aContatos, Len(aContatos)-1 )
	
	If Len(aContatos) == 0
		Aadd( aContatos, {"",""} )
		nAt := 1
	Endif
	
	If nAt > 1
		nAt--
		If nAt > Len(aContatos)
			nAt := Len(aContatos)
		Endif
	Endif
	
	Asort( aContatos,,, { |x,y| x[2]<y[2] } )
	
	SU5->( DbSetOrder(1) )
	If Empty(aContatos[nAt][1]) .OR. SU5->( !MsSeek( xFilial("SU5")+aContatos[nAt][1] ) )
		SU5->( DbGoto(0) )
		cCodCon := Space(Len(SU5->U5_CODCONT))
		cNomCon := Space(Len(SU5->U5_CONTAT))
	Else
		cCodCon := SU5->U5_CODCONT
		cNomCon := SU5->U5_CONTAT
	Endif
	
	oCodCon:Refresh()
	oNomCon:Refresh()
	
	oLbxCont:SetArray(aContatos)
	oLbxCont:bLine := {||{;
					aContatos[oLbxCont:nAt][1],;
					aContatos[oLbxCont:nAt][2];
					}}
	
	oLbxCont:nAt := nAt
	
	oLbxCont:Refresh()
	
	oEnch:Refresh()
	
	If !Empty(cCodCon) .AND. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lVincula := .T.
	Else
		lVincula := .F.
	Endif
	
	If Empty(cCodCon) .OR. Ascan( aContatos, { |x| Alltrim(x[1]) == Alltrim(cCodCon) } ) == 0
		lExclui := .F.
	Else
		lExclui := .T.
	Endif
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COM010CtGrv   º Autor ³ Microsiga        º Data ³ 10/07/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                          							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function COM010CtGrv(oLbxCont,aExclui)

	Local nI		:= 0
	Local aContatos	:= Aclone( oLbxCont:aArray )
	
	AC8->( DbSetOrder(2) )		// AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
	For nI := 1 To Len(aContatos)
		
		If AC8->( !MsSeek( xFilial("AC8")+"SZ3"+xFilial("SZ3")+PadR(SZ3->Z3_CODENT,Len(AC8->AC8_CODENT))+aContatos[nI][1] ) )
			
			AC8->( RecLock("AC8",.T.) )
				AC8->AC8_FILIAL	:= xFilial("AC8")
				AC8->AC8_ENTIDA	:= "SZ3"
				AC8->AC8_FILENT	:= xFilial("SZ3")
				AC8->AC8_CODENT	:= SZ3->Z3_CODENT
				AC8->AC8_CODCON	:= aContatos[nI][1]
			AC8->( MsUnLock() )
			
		Endif
		
	Next nI
	
	For nI := 1 To Len(aExclui)
		
		If AC8->( MsSeek( xFilial("AC8")+"SZ3"+xFilial("SZ3")+PadR(SZ3->Z3_CODENT,Len(AC8->AC8_CODENT))+aExclui[nI][1] ) )
			
			AC8->( RecLock("AC8",.F.) )
				AC8->( DbDelete() )
			AC8->( MsUnLock() )
			
		Endif
	
	Next nI
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMAON10   ºAutor  ³Renato Ruy         º Data ³  06/26/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fazer o recalculo Online para pedidos de periodos em abertoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Remuneracao de Parceiros                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ComaOn10(cCodEnt,cTipEnt,cCampAlt,cUsrNome)

Local cWhere 	:= ""
Local cPeriodo 	:= ""
Local nContar 	:= 0
Local aPedidos	:= {} 

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

cWhere := Iif(cTipEnt == "9", "% AND Z6_CODCCR = '" + cCodEnt + "' %", "% AND Z6_CODENT = '" + cCodEnt + "' %")

//Renato Ruy - 13/06/2018
//Quando houver alteracoes no CCR, efetua calculo
If cTipEnt == "9"
	cTipEnt := "4"
Endif

If cTipEnt $ "1/2/4/7/8/9"

	DbSelectArea("SZ5")

	If Select("COM010") > 0
		DbSelectArea("COM010")
		COM010->(DbCloseArea())
	EndIf
	
	//Renato Ruy - 25/02/2017
	//Para o mes em aberto nao efetua recalculo, somente marca como alterado.		
	BeginSql Alias "COM010"
			
		SELECT Z6_PERIODO, Z6_RECORI 
		From %Table:SZ6% SZ6
		Where
		Z6_Filial = %xFilial:SZ6%
		And Z6_PERIODO = %Exp:AllTrim(getmv("MV_REMMES"))% 
		And Z6_TPENTID = %Exp:cTipEnt%
		And Z6_TIPO IN ('VERIFI','RENOVA')
		And D_E_L_E_T_ = ' '
		%Exp:cWhere%
		Group by Z6_PERIODO, Z6_RECORI
		
	EndSql
	
	DbSelectArea("COM010")
	COM010->(DbGoTop())
	
	While !COM010->(EOF())
		
		SZ5->(DbGoTo(Val(COM010->Z6_RECORI)))
		
		//Grava o Tipo 7 que foi alterado cadastro e o campo alterado.
		RecLock("SZ5",.F.)
			SZ5->Z5_COMISS := "1"
			SZ5->Z5_OBSCOM := Date()+"-"+Time()+"-"+cCampAlt
		SZ5->(MsUnlock())
		
		COM010->(DbSkip())
	Enddo
		

	If Select("COMAON") > 0
		DbSelectArea("COMAON")
		COMAON->(DbCloseArea())
	EndIf
	
	//Renato Ruy - 23/09/2016
	//Mes atual em aberto no parametro MV_REMMES não é calculado.		
	cPeriodo := "% And Z6_PERIODO = '"+Iif(SubStr(getmv("MV_REMMES"),5,2)=="12",Soma1(SubStr(getmv("MV_REMMES"),1,4))+"01",Soma1(getmv("MV_REMMES")))+"' %"
	
	BeginSql Alias "COMAON"
			
		SELECT Z6_PERIODO, Z6_RECORI 
		From %Table:SZ6% SZ6
		Where
		Z6_Filial = %xFilial:SZ6%
		%Exp:cPeriodo%
		And Z6_TPENTID = %Exp:cTipEnt%
		And Z6_TIPO IN ('VERIFI','RENOVA')
		And D_E_L_E_T_ = ' '
		%Exp:cWhere%
		Group by Z6_PERIODO, Z6_RECORI
		
	EndSql
	
	While !COMAON->(EOF())
		
		SZ5->(DbGoTo(Val(COMAON->Z6_RECORI)))

		//Grava o Tipo 7 que foi alterado cadastro e o campo alterado.
		RecLock("SZ5",.F.)
			SZ5->Z5_COMISS := "1"
			SZ5->Z5_OBSCOM := DtoC(Date())+"-"+Time()+"-"+cCampAlt
		SZ5->(MsUnlock())
		
		COMAON->(DbSkip())
	Enddo
		
EndIf

Return