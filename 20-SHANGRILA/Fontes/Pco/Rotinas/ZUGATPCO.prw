#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*
* Funcao		:	ZUCTGPCO
* Autor			:	Jo?o Zabotto
* Data			: 	17/04/2014
* Descricao		:	Rotina responsavel por criar gatilho para o cadastro de verba
* Retorno		: 	
*/
User Function ZUGATPCO( cEmpAmb, cFilAmb )

	Local   aSay      := {}
	Local   aButton   := {}
	Local   aMarcadas := {}
	Local   cTitulo   := "ATUALIZA??O DE DICION?RIOS E TABELAS"
	Local   cDesc1    := "Esta rotina tem como fun??o fazer  a atualiza??o  dos dicion?rios do Sistema ( SX?/SIX )"
	Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja n?o podem haver outros"
	Local   cDesc3    := "usu?rios  ou  jobs utilizando  o sistema.  ? extremamente recomendav?l  que  se  fa?a um"
	Local   cDesc4    := "BACKUP  dos DICION?RIOS  e da  BASE DE DADOS antes desta atualiza??o, para que caso "
	Local   cDesc5    := "ocorra eventuais falhas, esse backup seja ser restaurado."
	Local   cDesc6    := ""
	Local   cDesc7    := ""
	Local   lOk       := .F.
	Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

	Private oMainWnd  := NIL
	Private oProcess  := NIL

	#IFDEF TOP
		TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
	#ENDIF

	__cInterNet := NIL
	__lPYME     := .F.

	Set Dele On

// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
	aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
	aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

	If lAuto
		lOk := .T.
	Else
		FormBatch(  cTitulo,  aSay,  aButton )
	EndIf

	If lOk
		If lAuto
			aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
		Else
			aMarcadas := EscEmpresa()
		EndIf

		If !Empty( aMarcadas )
			If lAuto .OR. MsgNoYes( "Confirma a atualiza??o dos dicion?rios ?", cTitulo )
				oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
				oProcess:Activate()

				If lAuto
					If lOk
						MsgStop( "Atualiza??o Realizada.", "ZUPDPPCO" )
						dbCloseAll()
					Else
						MsgStop( "Atualiza??o n?o Realizada.", "ZUPDPPCO" )
						dbCloseAll()
					EndIf
				Else
					If lOk
						Final( "Atualiza??o Conclu?da." )
					Else
						Final( "Atualiza??o n?o Realizada." )
					EndIf
				EndIf

			Else
				MsgStop( "Atualiza??o n?o Realizada.", "ZUPDPPCO" )

			EndIf

		Else
			MsgStop( "Atualiza??o n?o Realizada.", "ZUPDPPCO" )

		EndIf

	EndIf

Return NIL


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
??? Programa ? FSTProc  ? Autor ? TOTVS Protheus     ? Data ?  17/04/2014 ???
?????????????????????????????????????????????????????????????????????????͹??
??? Descricao? Funcao de processamento da grava??o dos arquivos           ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
??? Uso      ? FSTProc    - Gerado por EXPORDIC / Upd. V.4.10.5 EFS       ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function FSTProc( lEnd, aMarcadas )
	Local   aInfo     := {}
	Local   aRecnoSM0 := {}
	Local   cAux      := ""
	Local   cFile     := ""
	Local   cFileLog  := ""
	Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
	Local   cTCBuild  := "TCGetBuild"
	Local   cTexto    := ""
	Local   cTopBuild := ""
	Local   lOpen     := .F.
	Local   lRet      := .T.
	Local   nI        := 0
	Local   nPos      := 0
	Local   nRecno    := 0
	Local   nX        := 0
	Local   oDlg      := NIL
	Local   oFont     := NIL
	Local   oMemo     := NIL

	Private aArqUpd   := {}

	If ( lOpen := MyOpenSm0(.T.) )

		dbSelectArea( "SM0" )
		dbGoTop()

		While !SM0->( EOF() )
		// So adiciona no aRecnoSM0 se a empresa for diferente
			If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
					.AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
				aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
			EndIf
			SM0->( dbSkip() )
		End

		SM0->( dbCloseArea() )

		If lOpen

			For nI := 1 To Len( aRecnoSM0 )

				If !( lOpen := MyOpenSm0(.F.) )
					MsgStop( "Atualiza??o da empresa " + aRecnoSM0[nI][2] + " n?o efetuada." )
					Exit
				EndIf

				SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

				RpcSetType( 3 )
				RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

				lMsFinalAuto := .F.
				lMsHelpAuto  := .F.

				cTexto += Replicate( "-", 128 ) + CRLF
				cTexto += "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF + CRLF

				oProcess:SetRegua1( 8 )

			//??????????????????????????????????Ŀ
			//?Atualiza o dicion?rio SX6         ?
			//????????????????????????????????????
				oProcess:IncRegua1( "Dicion?rio de par?metros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
				FSAtuSX7( @cTexto )

				RpcClearEnv()

			Next nI

			If MyOpenSm0(.T.)

				cAux += Replicate( "-", 128 ) + CRLF
				cAux += Replicate( " ", 128 ) + CRLF
				cAux += "LOG DA ATUALIZACAO DOS DICION?RIOS" + CRLF
				cAux += Replicate( " ", 128 ) + CRLF
				cAux += Replicate( "-", 128 ) + CRLF
				cAux += CRLF
				cAux += " Dados Ambiente" + CRLF
				cAux += " --------------------"  + CRLF
				cAux += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
				cAux += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
				cAux += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
				cAux += " DataBase...........: " + DtoC( dDataBase )  + CRLF
				cAux += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
				cAux += " Environment........: " + GetEnvServer()  + CRLF
				cAux += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
				cAux += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
				cAux += " Versao.............: " + GetVersao(.T.)  + CRLF
				cAux += " Usuario TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
				cAux += " Computer Name......: " + GetComputerName() + CRLF

				aInfo   := GetUserInfo()
				If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
					cAux += " "  + CRLF
					cAux += " Dados Thread" + CRLF
					cAux += " --------------------"  + CRLF
					cAux += " Usuario da Rede....: " + aInfo[nPos][1] + CRLF
					cAux += " Estacao............: " + aInfo[nPos][2] + CRLF
					cAux += " Programa Inicial...: " + aInfo[nPos][5] + CRLF
					cAux += " Environment........: " + aInfo[nPos][6] + CRLF
					cAux += " Conexao............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) )  + CRLF
				EndIf
				cAux += Replicate( "-", 128 ) + CRLF
				cAux += CRLF

				cTexto := cAux + cTexto + CRLF

				cTexto += Replicate( "-", 128 ) + CRLF
				cTexto += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
				cTexto += Replicate( "-", 128 ) + CRLF

				cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cTexto )

				Define Font oFont Name "Mono AS" Size 5, 12

				Define MsDialog oDlg Title "Atualizacao concluida." From 3, 0 to 340, 417 Pixel

				@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont

				Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
				Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
					MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

				Activate MsDialog oDlg Center

			EndIf

		EndIf

	Else

		lRet := .F.

	EndIf

Return lRet


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
??? Programa ? FSAtuSX7 ? Autor ? TOTVS Protheus     ? Data ?  16/05/2014 ???
?????????????????????????????????????????????????????????????????????????͹??
??? Descricao? Funcao de processamento da gravacao do SX7 - Gatilhos      ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
??? Uso      ? FSAtuSX7   - Gerado por EXPORDIC / Upd. V.4.10.5 EFS       ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function FSAtuSX7( cTexto )
Local aEstrut   := {}
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

cTexto  += "Inicio da Atualizacao" + " SX7" + CRLF + CRLF

aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
             "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

//
// Campo RV_LCTOP
//
aAdd( aSX7, { ;
	'RV_LCTOP'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	"IF(!Empty(M->RV_LCTOP  ),'01' , '')"									, ; //X7_REGRA
	'RV_LANCPCO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Atualizando dicion?rio
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			cTexto += "Foi inclu?do o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] + CRLF
		EndIf

		RecLock( "SX7", .T. )
		For nJ := 1 To Len( aSX7[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

	EndIf
	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Rotina    ?ESCEMPRESA?Autor  ? Ernani Forastieri  ? Data ?  27/09/04   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Funcao Generica para escolha de Empresa, montado pelo SM0_ ???
???          ? Retorna vetor contendo as selecoes feitas.                 ???
???          ? Se nao For marcada nenhuma o vetor volta vazio.            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Generico                                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function EscEmpresa()
//????????????????????????????????????????????Ŀ
//? Parametro  nTipo                           ?
//? 1  - Monta com Todas Empresas/Filiais      ?
//? 2  - Monta so com Empresas                 ?
//? 3  - Monta so com Filiais de uma Empresa   ?
//?                                            ?
//? Parametro  aMarcadas                       ?
//? Vetor com Empresas/Filiais pre marcadas    ?
//?                                            ?
//? Parametro  cEmpSel                         ?
//? Empresa que sera usada para montar selecao ?
//??????????????????????????????????????????????
	Local   aSalvAmb := GetArea()
	Local   aSalvSM0 := {}
	Local   aRet     := {}
	Local   aVetor   := {}
	Local   oDlg     := NIL
	Local   oChkMar  := NIL
	Local   oLbx     := NIL
	Local   oMascEmp := NIL
	Local   oMascFil := NIL
	Local   oButMarc := NIL
	Local   oButDMar := NIL
	Local   oButInv  := NIL
	Local   oSay     := NIL
	Local   oOk      := LoadBitmap( GetResources(), "LBOK" )
	Local   oNo      := LoadBitmap( GetResources(), "LBNO" )
	Local   lChk     := .F.
	Local   lOk      := .F.
	Local   lTeveMarc:= .F.
	Local   cVar     := ""
	Local   cNomEmp  := ""
	Local   cMascEmp := "??"
	Local   cMascFil := "??"

	Local   aMarcadas  := {}


	If !MyOpenSm0(.F.)
		Return aRet
	EndIf


	dbSelectArea( "SM0" )
	aSalvSM0 := SM0->( GetArea() )
	dbSetOrder( 1 )
	dbGoTop()

	While !SM0->( EOF() )

		If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
			aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
		EndIf

		dbSkip()
	End

	RestArea( aSalvSM0 )

	Define MSDialog  oDlg Title "" From 0, 0 To 270, 396 Pixel

	oDlg:cToolTip := "Tela para M?ltiplas Sele??es de Empresas/Filiais"

	oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza??o"

	@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
	oLbx:SetArray(  aVetor )
	oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
		aVetor[oLbx:nAt, 2], ;
		aVetor[oLbx:nAt, 4]}}
	oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
	oLbx:cToolTip   :=  oDlg:cTitle
	oLbx:lHScroll   := .F. // NoScroll

	@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos"   Message  Size 40, 007 Pixel Of oDlg;
		on Click MarcaTodos( lChk, @aVetor, oLbx )

	@ 123, 10 Button oButInv Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message "Inverter Sele??o" Of oDlg

// Marca/Desmarca por mascara
	@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
	@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
		Message "M?scara Empresa ( ?? )"  Of oDlg
	@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message "Marcar usando m?scara ( ?? )"    Of oDlg
	@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message "Desmarcar usando m?scara ( ?? )" Of oDlg

	Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Sele??o"  Enable Of oDlg
	Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Sele??o" Enable Of oDlg
	Activate MSDialog  oDlg Center

	RestArea( aSalvAmb )
	dbSelectArea( "SM0" )
	dbCloseArea()

Return  aRet


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Rotina    ?MARCATODOS?Autor  ? Ernani Forastieri  ? Data ?  27/09/04   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Funcao Auxiliar para marcar/desmarcar todos os itens do    ???
???          ? ListBox ativo                                              ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Generico                                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
	Local  nI := 0

	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := lMarca
	Next nI

	oLbx:Refresh()

Return NIL


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Rotina    ?INVSELECAO?Autor  ? Ernani Forastieri  ? Data ?  27/09/04   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Funcao Auxiliar para inverter selecao do ListBox Ativo     ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Generico                                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function InvSelecao( aVetor, oLbx )
	Local  nI := 0

	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := !aVetor[nI][1]
	Next nI

	oLbx:Refresh()

Return NIL


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Rotina    ?RETSELECAO?Autor  ? Ernani Forastieri  ? Data ?  27/09/04   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Funcao Auxiliar que monta o retorno com as selecoes        ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Generico                                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function RetSelecao( aRet, aVetor )
	Local  nI    := 0

	aRet := {}
	For nI := 1 To Len( aVetor )
		If aVetor[nI][1]
			aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
		EndIf
	Next nI

Return NIL


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Rotina    ? MARCAMAS ?Autor  ? Ernani Forastieri  ? Data ?  20/11/04   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Funcao para marcar/desmarcar usando mascaras               ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Generico                                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
	Local cPos1 := SubStr( cMascEmp, 1, 1 )
	Local cPos2 := SubStr( cMascEmp, 2, 1 )
	Local nPos  := oLbx:nAt
	Local nZ    := 0

	For nZ := 1 To Len( aVetor )
		If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
			If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
				aVetor[nZ][1] :=  lMarDes
			EndIf
		EndIf
	Next

	oLbx:nAt := nPos
	oLbx:Refresh()

Return NIL


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Rotina    ? VERTODOS ?Autor  ? Ernani Forastieri  ? Data ?  20/11/04   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Funcao auxiliar para verificar se estao todos marcardos    ???
???          ? ou nao                                                     ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Generico                                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function VerTodos( aVetor, lChk, oChkMar )
	Local lTTrue := .T.
	Local nI     := 0

	For nI := 1 To Len( aVetor )
		lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
	Next nI

	lChk := IIf( lTTrue, .T., .F. )
	oChkMar:Refresh()

Return NIL


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
??? Programa ? MyOpenSM0? Autor ? TOTVS Protheus     ? Data ?  17/04/2014 ???
?????????????????????????????????????????????????????????????????????????͹??
??? Descricao? Funcao de processamento abertura do SM0 modo exclusivo     ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
??? Uso      ? MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.10.5 EFS       ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function MyOpenSM0(lShared)

	Local lOpen := .F.
	Local nLoop := 0

	For nLoop := 1 To 20
		dbUseArea( .T., , "SIGAMAT.EMP", "SM0", .T., .F. )

		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf

		Sleep( 500 )

	Next nLoop

	If !lOpen
		MsgStop( "N?o foi poss?vel a abertura da tabela " + ;
			IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN??O" )
	EndIf

Return .T.


/////////////////////////////////////////////////////////////////////////////
