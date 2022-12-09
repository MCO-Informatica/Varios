#INCLUDE "PROTHEUS.CH"
#INCLUDE "UPDCUSTO.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ TESTE    บ Autor ณ TOTVS Protheus     บ Data ณ  17/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de update dos dicionแrios para compatibiliza็ใo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ TESTE      - Gerado por EXPORDIC / Upd. V.4.10.7 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UPDCUSTO( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := STR0001 //"ATUALIZAวรO DE DICIONมRIOS E TABELAS"
Local   cDesc1    := STR0002 //"Esta rotina tem como fun็ใo fazer  a atualiza็ใo  dos dicionแrios do Sistema ( SX?/SIX )"
Local   cDesc2    := STR0003 //"Este processo deve ser executado em modo EXCLUSIVO, ou seja nใo podem haver outros"
Local   cDesc3    := STR0004 //"usuแrios  ou  jobs utilizando  o sistema.  ษ extremamente recomendav้l  que  se  fa็a um"
Local   cDesc4    := STR0005 //"BACKUP  dos DICIONมRIOS  e da  BASE DE DADOS antes desta atualiza็ใo, para que caso "
Local   cDesc5    := STR0006 //"ocorra eventuais falhas, esse backup seja ser restaurado."
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
		If lAuto .OR. MsgNoYes( STR0007, cTitulo ) //"Confirma a atualiza็ใo dos dicionแrios ?"
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, STR0008, STR0009, .F. ) //"Atualizando"###"Aguarde, atualizando ..."
			oProcess:Activate()

		If lAuto
			If lOk
				MsgStop( STR0011, "TESTE" ) //"Atualiza็ใo Realizada."
				dbCloseAll()
			Else
				MsgStop( STR0011, "TESTE" ) //"Atualiza็ใo nใo Realizada."
				dbCloseAll()
			EndIf
		Else
			If lOk
				Final( STR0010 ) //"Atualiza็ใo Concluํda."
			Else
				Final( STR0011 ) //"Atualiza็ใo nใo Realizada."
			EndIf
		EndIf

		Else
			MsgStop( STR0011, "TESTE" ) //"Atualiza็ใo nใo Realizada."

		EndIf

	Else
		MsgStop( STR0011, "TESTE" ) //"Atualiza็ใo nใo Realizada."

	EndIf

EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSTProc  บ Autor ณ TOTVS Protheus     บ Data ณ  17/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da grava็ใo dos arquivos           ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSTProc    - Gerado por EXPORDIC / Upd. V.4.10.7 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSTProc( lEnd, aMarcadas )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := STR0012 + "(*.TXT)|*.txt|" //"Arquivos Texto"
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
				MsgStop( STR0013 + aRecnoSM0[nI][2] + STR0014 ) //"Atualiza็ใo da empresa "###" nใo efetuada."
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			cTexto += Replicate( "-", 128 ) + CRLF
			cTexto += STR0015 + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF + CRLF //"Empresa : "

			oProcess:SetRegua1( 8 )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX3         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			FSAtuSX3( @cTexto )

			oProcess:IncRegua1( STR0018 + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." ) //"Dicionแrio de dados"
			oProcess:IncRegua2( STR0019 ) //"Atualizando campos/ํndices"

			// Alteracao fisica dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( STR0020 + aArqUpd[nX] + STR0021, STR0022 ) //"Ocorreu um erro desconhecido durante a atualiza็ใo da tabela : "###". Verifique a integridade do dicionแrio e da tabela."###"ATENวรO"
					cTexto += STR0023 + aArqUpd[nX] + CRLF //"Ocorreu um erro desconhecido durante a atualiza็ใo da estrutura da tabela : "
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza os helps                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( STR0031 + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." ) //"Helps de Campo"
			FSAtuHlp( @cTexto )

			RpcClearEnv()

		Next nI

		If MyOpenSm0(.T.)

			cAux += Replicate( "-", 128 ) + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += STR0032 + CRLF //"LOG DA ATUALIZACAO DOS DICIONมRIOS"
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF
			cAux += STR0033 + CRLF //" Dados Ambiente"
			cAux += " --------------------"  + CRLF
			cAux += STR0034 + cEmpAnt + "/" + cFilAnt  + CRLF //" Empresa / Filial...: "
			cAux += STR0035 + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF //" Nome Empresa.......: "
			cAux += STR0036 + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF //" Nome Filial........: "
			cAux += STR0037 + DtoC( dDataBase )  + CRLF //" DataBase...........: "
			cAux += STR0038 + DtoC( Date() )  + " / " + Time()  + CRLF //" Data / Hora Inicio.: "
			cAux += STR0039 + GetEnvServer()  + CRLF //" Environment........: "
			cAux += STR0040 + GetSrvProfString( "StartPath", "" )  + CRLF //" StartPath..........: "
			cAux += STR0041 + GetSrvProfString( "RootPath" , "" )  + CRLF //" RootPath...........: "
			cAux += STR0042 + GetVersao(.T.)  + CRLF //" Versao.............: "
			cAux += STR0043 + __cUserId + " " +  cUserName + CRLF //" Usuario TOTVS .....: "
			cAux += STR0044 + GetComputerName() + CRLF //" Computer Name......: "

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				cAux += " "  + CRLF
				cAux += STR0045 + CRLF //" Dados Thread"
				cAux += " --------------------"  + CRLF
				cAux += STR0046 + aInfo[nPos][1] + CRLF //" Usuario da Rede....: "
				cAux += STR0047 + aInfo[nPos][2] + CRLF //" Estacao............: "
				cAux += STR0048 + aInfo[nPos][5] + CRLF //" Programa Inicial...: "
				cAux += STR0039 + aInfo[nPos][6] + CRLF //" Environment........: "
				cAux += STR0049 + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) )  + CRLF //" Conexao............: "
			EndIf
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF

			cTexto := cAux + cTexto + CRLF

			cTexto += Replicate( "-", 128 ) + CRLF
			cTexto += STR0050 + DtoC( Date() ) + " / " + Time()  + CRLF //" Data / Hora Final.: "
			cTexto += Replicate( "-", 128 ) + CRLF

			cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cTexto )

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title STR0051 From 3, 0 to 340, 417 Pixel //"Atualizacao concluida."

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX3 บ Autor ณ TOTVS Protheus     บ Data ณ  17/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX3 - Campos        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX3   - Gerado por EXPORDIC / Upd. V.4.10.7 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX3( cTexto )
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

cTexto  += STR0055 + " SX3" + CRLF + CRLF //"Inicio da Atualizacao"

aEstrut := { "X3_ARQUIVO", "X3_ORDEM"  , "X3_CAMPO"  , "X3_TIPO"   , "X3_TAMANHO", "X3_DECIMAL", ;
             "X3_TITULO" , "X3_TITSPA" , "X3_TITENG" , "X3_DESCRIC", "X3_DESCSPA", "X3_DESCENG", ;
             "X3_PICTURE", "X3_VALID"  , "X3_USADO"  , "X3_RELACAO", "X3_F3"     , "X3_NIVEL"  , ;
             "X3_RESERV" , "X3_CHECK"  , "X3_TRIGGER", "X3_PROPRI" , "X3_BROWSE" , "X3_VISUAL" , ;
             "X3_CONTEXT", "X3_OBRIGAT", "X3_VLDUSER", "X3_CBOX"   , "X3_CBOXSPA", "X3_CBOXENG", ;
             "X3_PICTVAR", "X3_WHEN"   , "X3_INIBRW" , "X3_GRPSXG" , "X3_FOLDER" , "X3_PYME"   }

//
// Tabela SB0
//
aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'B0_PRV1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda1'															, ; //X3_TITULO
	'Prc. Venta 1'															, ; //X3_TITSPA
	'Sale Price 1'															, ; //X3_TITENG
	'Preco de Venda 1'														, ; //X3_DESCRIC
	'Precio de Venta 01'													, ; //X3_DESCSPA
	'Sale Price  1'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'B0_PRV2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda2'															, ; //X3_TITULO
	'Prc. Venta 2'															, ; //X3_TITSPA
	'Sale Price 2'															, ; //X3_TITENG
	'Preco de venda 2'														, ; //X3_DESCRIC
	'Precio de Venta 02'													, ; //X3_DESCSPA
	'Sale Price  2'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'B0_PRV3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda3'															, ; //X3_TITULO
	'Prc. Venta 3'															, ; //X3_TITSPA
	'Sale Price 3'															, ; //X3_TITENG
	'Preco de venda 3'														, ; //X3_DESCRIC
	'Precio de Venta 03'													, ; //X3_DESCSPA
	'Sale Price  3'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'B0_PRV4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda4'															, ; //X3_TITULO
	'Prc. Venta 4'															, ; //X3_TITSPA
	'Sale Price 4'															, ; //X3_TITENG
	'Preco de venda 4'														, ; //X3_DESCRIC
	'Precio de Venta 04'													, ; //X3_DESCSPA
	'Sale Price  4'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'B0_PRV5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda5'															, ; //X3_TITULO
	'Prc. Venta 5'															, ; //X3_TITSPA
	'Sale Price 5'															, ; //X3_TITENG
	'Preco de venda 5'														, ; //X3_DESCRIC
	'Precio de Venta 05'													, ; //X3_DESCSPA
	'Sale Price  5'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'B0_PRV6'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda6'															, ; //X3_TITULO
	'Prc. Venta 6'															, ; //X3_TITSPA
	'Sale Price 6'															, ; //X3_TITENG
	'Preco de venda 6'														, ; //X3_DESCRIC
	'Precio de Venta 06'													, ; //X3_DESCSPA
	'Sale Price  6'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'B0_PRV7'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda7'															, ; //X3_TITULO
	'Prc. Venta 7'															, ; //X3_TITSPA
	'Sale Price 7'															, ; //X3_TITENG
	'Preco de venda 7'														, ; //X3_DESCRIC
	'Precio de Venta 07'													, ; //X3_DESCSPA
	'Sale Price  7'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'B0_PRV8'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda8'															, ; //X3_TITULO
	'Prc. Venta 8'															, ; //X3_TITSPA
	'Sale Price 8'															, ; //X3_TITENG
	'Preco de venda 8'														, ; //X3_DESCRIC
	'Precio de Venta 08'													, ; //X3_DESCSPA
	'Sale Price  8'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB0'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'B0_PRV9'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda9'															, ; //X3_TITULO
	'Prc. Venta 9'															, ; //X3_TITSPA
	'Sale Price 9'															, ; //X3_TITENG
	'Preco de venda 9'														, ; //X3_DESCRIC
	'Precio de Venta 09'													, ; //X3_DESCSPA
	'Sale Price  9'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB1
//
aAdd( aSX3, { ;
	'SB1'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'B1_PRV1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda'															, ; //X3_TITULO
	'Precio Venta'															, ; //X3_TITSPA
	'Sales Price'															, ; //X3_TITENG
	'Preco de Venda'														, ; //X3_DESCRIC
	'Precio de Venta'														, ; //X3_DESCSPA
	'Sales Price'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A010Preco()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB1'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'B1_CUSTD'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Custo Stand.'															, ; //X3_TITULO
	'Costo Estand'															, ; //X3_TITSPA
	'Std.Cost'																, ; //X3_TITENG
	'Custo Standard'														, ; //X3_DESCRIC
	'Costo Estandar'														, ; //X3_DESCSPA
	'Standard Cost'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB1'																	, ; //X3_ARQUIVO
	'D2'																	, ; //X3_ORDEM
	'B1_QTMIDIA'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde. Midia'															, ; //X3_TITULO
	'Cant.Med Com'															, ; //X3_TITSPA
	'Media Qtty.'															, ; //X3_TITENG
	'Qtde. Midia'															, ; //X3_DESCRIC
	'Cant.Medios Comunic.'													, ; //X3_DESCSPA
	'Media Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(144) + Chr(130) + Chr(240) + ;
	Chr(128) + Chr(128) + Chr(192) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'2'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB1'																	, ; //X3_ARQUIVO
	'G6'																	, ; //X3_ORDEM
	'B1_LOTVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde Venda'															, ; //X3_TITULO
	'Ctd. Venta'															, ; //X3_TITSPA
	'Sal. Qtty.'															, ; //X3_TITENG
	'Qtde. minima de venda'													, ; //X3_DESCRIC
	'Ctd. minima de venta'													, ; //X3_DESCSPA
	'Sal. Minimum Quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB2
//
aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'B2_QFIM'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Fim Mes'															, ; //X3_TITULO
	'Ctd. Fin Mes'															, ; //X3_TITSPA
	'Qty.End Mnth'															, ; //X3_TITENG
	'Saldo em qtde no fim mes'												, ; //X3_DESCRIC
	'Saldo en Ctd. al Fin Mes'												, ; //X3_DESCSPA
	'Balance at end of month'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'B2_QATU'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Atual'															, ; //X3_TITULO
	'Saldo Actual'															, ; //X3_TITSPA
	'Curr.Balance'															, ; //X3_TITENG
	'Saldo atual'															, ; //X3_DESCRIC
	'Saldo Actual'															, ; //X3_DESCSPA
	'Current Balance'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'B2_CM1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unitario'															, ; //X3_TITULO
	'Cost.Unitari'															, ; //X3_TITSPA
	'Unit Cost'																, ; //X3_TITENG
	'Custo Unitario do produto'												, ; //X3_DESCRIC
	'Costo Unitario de Produc.'												, ; //X3_DESCSPA
	'Product Unit Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'IsProdMod(M->B2_COD)'													, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'B2_CM2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Uni.2a M'															, ; //X3_TITULO
	'Cos.Uni.2a M'															, ; //X3_TITSPA
	'Unit Cost C2'															, ; //X3_TITENG
	'Custo unit. na 2a moeda'												, ; //X3_DESCRIC
	'Costo Unit. en 2a. Moneda'												, ; //X3_DESCSPA
	'Unit Cost in 2nd Currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'IsProdMod(M->B2_COD)'													, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'B2_CM3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Uni.3a M'															, ; //X3_TITULO
	'Cos.Uni.3a M'															, ; //X3_TITSPA
	'Unit Cost C3'															, ; //X3_TITENG
	'Custo unit. na 3a moeda'												, ; //X3_DESCRIC
	'Costo Unit. en 3a. Moneda'												, ; //X3_DESCSPA
	'Unit Cost in 3rd Currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'IsProdMod(M->B2_COD)'													, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'B2_CM4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Uni.4a M'															, ; //X3_TITULO
	'Cos.Uni.4a M'															, ; //X3_TITSPA
	'Unit Cost C4'															, ; //X3_TITENG
	'Custo unit. na 4a moeda'												, ; //X3_DESCRIC
	'Costo Unit. en 4a. Moneda'												, ; //X3_DESCSPA
	'Unit Cost in Currency 4'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'IsProdMod(M->B2_COD)'													, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'B2_CM5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Uni.5a M'															, ; //X3_TITULO
	'Cos.Uni.5a M'															, ; //X3_TITSPA
	'Unit Cost C5'															, ; //X3_TITENG
	'Custo unit. na 5a moeda'												, ; //X3_DESCRIC
	'Costo Unit. en 5a. Moneda'												, ; //X3_DESCSPA
	'Unit Cost in Currency 5'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'IsProdMod(M->B2_COD)'													, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'B2_QEMPN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Emp. NF'															, ; //X3_TITULO
	'Ctd.Resr.Fac'															, ; //X3_TITSPA
	'Qty.All.Inv.'															, ; //X3_TITENG
	'Qtde Empenhada para N.F.s'												, ; //X3_DESCRIC
	'Cantidad Reservada p/Fact'												, ; //X3_DESCSPA
	'Quantity Allocated Inv.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'B2_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd 2a. UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cantidad 2a. Unidad Medid'												, ; //X3_DESCSPA
	'Quantity in Second Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'B2_RESERVA'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Reserva'															, ; //X3_TITULO
	'Ctd. Reserva'															, ; //X3_TITSPA
	'Reserve Qty.'															, ; //X3_TITENG
	'Quantidade Reservada'													, ; //X3_DESCRIC
	'Cantidad Reservada'													, ; //X3_DESCSPA
	'Quantity Reserved'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'B2_QPEDVEN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Ped.Vend'															, ; //X3_TITULO
	'Ctd.Ped.Vent'															, ; //X3_TITSPA
	'Quantity S.O'															, ; //X3_TITENG
	'Quantidade Pedido Vendas'												, ; //X3_DESCRIC
	'Cantidad Pedido de Ventas'												, ; //X3_DESCSPA
	'Sales Order Quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'B2_SALPEDI'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Prevista'															, ; //X3_TITULO
	'Ctd.Prevista'															, ; //X3_TITSPA
	'Expected Qty'															, ; //X3_TITENG
	'Qtde prevista p/ entrar'												, ; //X3_DESCRIC
	'Ctd. Prevista para Entrar'												, ; //X3_DESCSPA
	'Expected Inflow'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'33'																	, ; //X3_ORDEM
	'B2_QTNP'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Ter.Ns.Pd'															, ; //X3_TITULO
	'Ctd.3o.Nu.Pd'															, ; //X3_TITSPA
	'3rd Py O Pow'															, ; //X3_TITENG
	'Qtd. Terc. em Nosso Poder'												, ; //X3_DESCRIC
	'Ctd.de 3o.en Nuestro Pode'												, ; //X3_DESCSPA
	'Quant.3rd Party our Posse'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'34'																	, ; //X3_ORDEM
	'B2_QNPT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Ns.Pd.Ter'															, ; //X3_TITULO
	'Ctd.Nu.Pd.3o'															, ; //X3_TITSPA
	'Our Qty 3rdP'															, ; //X3_TITENG
	'Qtd. Nosso em Poder Terc.'												, ; //X3_DESCRIC
	'Ctd.Nuestra en Poder de3o'												, ; //X3_DESCSPA
	'Our Quant.w/ 3rd Parties'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'35'																	, ; //X3_ORDEM
	'B2_QTER'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Pod.3'															, ; //X3_TITULO
	'Saldo Pod.3o'															, ; //X3_TITSPA
	'Bal.3rd Part'															, ; //X3_TITENG
	'Saldo Poder 3.'														, ; //X3_DESCRIC
	'Saldo Poder Tercero'													, ; //X3_DESCSPA
	'Balance 3rd Parties'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'36'																	, ; //X3_ORDEM
	'B2_QFIM2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Fim Mes 2'															, ; //X3_TITULO
	'Ctd.Fin Mes2'															, ; //X3_TITSPA
	'Qty.End Mth2'															, ; //X3_TITENG
	'Qtd. Fim mes 2a UM'													, ; //X3_DESCRIC
	'Ctd. Fin Mes 2a. UM'													, ; //X3_DESCSPA
	'Quantity Month End  UM2'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'37'																	, ; //X3_ORDEM
	'B2_QACLASS'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.a Endere'															, ; //X3_TITULO
	'Ctd.a Encami'															, ; //X3_TITSPA
	'Amt.to be Ad'															, ; //X3_TITENG
	'Quantidade a Enderecar'												, ; //X3_DESCRIC
	'Cantidad a encaminar'													, ; //X3_DESCSPA
	'Amount to be Address.'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(152) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'39'																	, ; //X3_ORDEM
	'B2_CMFF1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit.FIFO1'															, ; //X3_TITULO
	'C Unit.FIFO1'															, ; //X3_TITSPA
	'FIFO1 Unit C'															, ; //X3_TITENG
	'Custo Unit. do prod. FIFO'												, ; //X3_DESCRIC
	'Costo Unit. prod. FIFO'												, ; //X3_DESCSPA
	'Unit Cost of FIFO prod.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(146) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'IIF(Subs(M->B2_COD,1,3)!="MOD",.F.,.T.)'								, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'40'																	, ; //X3_ORDEM
	'B2_CMFF2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit.FIFO2'															, ; //X3_TITULO
	'C Unit.FIFO2'															, ; //X3_TITSPA
	'FIFO2 Unit C'															, ; //X3_TITENG
	'Custo Unit. do prod. FIFO'												, ; //X3_DESCRIC
	'Costo Unit. prod. FIFO'												, ; //X3_DESCSPA
	'Unit Cost of FIFO prod.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(146) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'IIF(Subs(M->B2_COD,1,3)!="MOD",.F.,.T.)'								, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'41'																	, ; //X3_ORDEM
	'B2_CMFF3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit.FIFO3'															, ; //X3_TITULO
	'C Unit.FIFO3'															, ; //X3_TITSPA
	'FIFO3 Unit C'															, ; //X3_TITENG
	'Custo Unit. do prod. FIFO'												, ; //X3_DESCRIC
	'Costo Unit. prod. FIFO'												, ; //X3_DESCSPA
	'Unit Cost of FIFO prod.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(146) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'IIF(Subs(M->B2_COD,1,3)!="MOD",.F.,.T.)'								, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'42'																	, ; //X3_ORDEM
	'B2_CMFF4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit.FIFO4'															, ; //X3_TITULO
	'C Unit.FIFO4'															, ; //X3_TITSPA
	'FIFO4 Unit C'															, ; //X3_TITENG
	'Custo Unit. do prod. FIFO'												, ; //X3_DESCRIC
	'Costo Unit. prod. FIFO'												, ; //X3_DESCSPA
	'Unit Cost of FIFO prod.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(146) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'IIF(Subs(M->B2_COD,1,3)!="MOD",.F.,.T.)'								, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'43'																	, ; //X3_ORDEM
	'B2_CMFF5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit.FIFO5'															, ; //X3_TITULO
	'C Unit.FIFO5'															, ; //X3_TITSPA
	'FIFO5 Unit C'															, ; //X3_TITENG
	'Custo Unit. do prod. FIFO'												, ; //X3_DESCRIC
	'Costo Unit. prod. FIFO'												, ; //X3_DESCSPA
	'Unit Cost of FIFO prod.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(146) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'IIF(Subs(M->B2_COD,1,3)!="MOD",.F.,.T.)'								, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'49'																	, ; //X3_ORDEM
	'B2_QEMPSA'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Emp. SA'															, ; //X3_TITULO
	'Ctd.Prev.SD'															, ; //X3_TITSPA
	'Expected SA'															, ; //X3_TITENG
	'Quantidade Prevista SA'												, ; //X3_DESCRIC
	'Cantidad Prevista SD'													, ; //X3_DESCSPA
	'Quantity Expected for SA'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'51'																	, ; //X3_ORDEM
	'B2_SALPPRE'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Prev. OP'															, ; //X3_TITULO
	'Ctd.Prev. OP'															, ; //X3_TITSPA
	'Est.Qty.PO'															, ; //X3_TITENG
	'Qtde prevista OP Prevista'												, ; //X3_DESCRIC
	'Ctd prevista OP Prevista'												, ; //X3_DESCSPA
	'Est. qty. Estim. PO'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'53'																	, ; //X3_ORDEM
	'B2_QEMPN2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Emp.NF 2'															, ; //X3_TITULO
	'Ctd.Res.Fac2'															, ; //X3_TITSPA
	'Qty.All.Inv2'															, ; //X3_TITENG
	'Qtde Empenhada P/ NF 2aUM'												, ; //X3_DESCRIC
	'Cantidad Reserva.p/Fact.2'												, ; //X3_DESCSPA
	'Quantity Allocated Inv. 2'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'55'																	, ; //X3_ORDEM
	'B2_QPEDVE2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Pd.Ve.2UM'															, ; //X3_TITULO
	'Ctd.Ped.Ven2'															, ; //X3_TITSPA
	'Qty. S.O 2Um'															, ; //X3_TITENG
	'Qtde Pedido Vendas 2a UM'												, ; //X3_DESCRIC
	'Cantidad Pedido Ventas 2'												, ; //X3_DESCSPA
	'Quantity of Sales Order 2'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'57'																	, ; //X3_ORDEM
	'B2_QFIMFF'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Fim Mes'															, ; //X3_TITULO
	'Ctd. Fin Mes'															, ; //X3_TITSPA
	'Qty.End Mnth'															, ; //X3_TITENG
	'Saldo em qtde no fim mes'												, ; //X3_DESCRIC
	'Saldo en Ctd. al Fin Mes'												, ; //X3_DESCSPA
	'Balance at end of Month'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'58'																	, ; //X3_ORDEM
	'B2_SALPED2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Prev.2UM'															, ; //X3_TITULO
	'Ctd.Prev.2UM'															, ; //X3_TITSPA
	'Exp.Qty.2UOM'															, ; //X3_TITENG
	'Qtde Prevista 2a UM'													, ; //X3_DESCRIC
	'Ctde Prevista 2a UM'													, ; //X3_DESCSPA
	'Quantity Antecipated 2UOM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'59'																	, ; //X3_ORDEM
	'B2_QEMPPRJ'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Emp.Prj.'															, ; //X3_TITULO
	'Ctd.Rev.Pry.'															, ; //X3_TITSPA
	'All Qt Prj'															, ; //X3_TITENG
	'Quantidade Empenhada Prj.'												, ; //X3_DESCRIC
	'Cantidad Reservada Pry.'												, ; //X3_DESCSPA
	'Commt.Amount Prj'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'62'																	, ; //X3_ORDEM
	'B2_QEMPPR2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt Emp Prj 2'															, ; //X3_TITULO
	'Ct Res Pry 2'															, ; //X3_TITSPA
	'All Amt Pr 2'															, ; //X3_TITENG
	'Quant Empenhada Proj 2 UM'												, ; //X3_DESCRIC
	'Cant Reservada Proy 2 UM'												, ; //X3_DESCSPA
	'Allocated Amt Proj 2 UM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'64'																	, ; //X3_ORDEM
	'B2_CMFIM1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 1a M'															, ; //X3_TITULO
	'C Unit 1a M'															, ; //X3_TITSPA
	'Unit C 1st M'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product Unit Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'65'																	, ; //X3_ORDEM
	'B2_CMFIM2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 2a M'															, ; //X3_TITULO
	'C Unit 2a M'															, ; //X3_TITSPA
	'Unit C 2nd M'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product Unit Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'66'																	, ; //X3_ORDEM
	'B2_CMFIM3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 3a M'															, ; //X3_TITULO
	'C Unit 3a M'															, ; //X3_TITSPA
	'Unit C 3rd M'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product Unit Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'67'																	, ; //X3_ORDEM
	'B2_CMFIM4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 4a M'															, ; //X3_TITULO
	'C Unit 4a M'															, ; //X3_TITSPA
	'Unit C 4th M'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product Unit Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB2'																	, ; //X3_ARQUIVO
	'68'																	, ; //X3_ORDEM
	'B2_CMFIM5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 5a M'															, ; //X3_TITULO
	'C Unit 5a M'															, ; //X3_TITSPA
	'Unit C 5th M'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product Unit Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB3
//
aAdd( aSX3, { ;
	'SB3'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'B3_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.da Media'															, ; //X3_TITULO
	'Valor Promed'															, ; //X3_TITSPA
	'Aver.Value'															, ; //X3_TITENG
	'Valor da media do mes'													, ; //X3_DESCRIC
	'Valor Promedio del Mes'												, ; //X3_DESCSPA
	'Monthly Average Value'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB4
//
aAdd( aSX3, { ;
	'SB4'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'B4_PRV1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda'															, ; //X3_TITULO
	'Precio Venta'															, ; //X3_TITSPA
	'Sales Price'															, ; //X3_TITENG
	'Preco de Venda'														, ; //X3_DESCRIC
	'Precio de Venta'														, ; //X3_DESCSPA
	'Sales Price'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB4'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'B4_PRV2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda2'															, ; //X3_TITULO
	'Prc. Venta 2'															, ; //X3_TITSPA
	'Sale Price 2'															, ; //X3_TITENG
	'Preco de venda 2'														, ; //X3_DESCRIC
	'Precio de Venta 2'														, ; //X3_DESCSPA
	'Price of Sale 2'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB4'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'B4_PRV3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda3'															, ; //X3_TITULO
	'Prc. Venta 3'															, ; //X3_TITSPA
	'Sale Price 3'															, ; //X3_TITENG
	'Preco de venda 3'														, ; //X3_DESCRIC
	'Precio de Venta 3'														, ; //X3_DESCSPA
	'Price of Sale 3'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB4'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'B4_PRV4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda4'															, ; //X3_TITULO
	'Prc. Venta 4'															, ; //X3_TITSPA
	'Sale Price 4'															, ; //X3_TITENG
	'Preco de venda 4'														, ; //X3_DESCRIC
	'Precio de Venta 4'														, ; //X3_DESCSPA
	'Price of Sale 4'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB4'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'B4_PRV5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda5'															, ; //X3_TITULO
	'Prc. Venta 5'															, ; //X3_TITSPA
	'Sale Price 5'															, ; //X3_TITENG
	'Preco de venda 5'														, ; //X3_DESCRIC
	'Precio de Venta 5'														, ; //X3_DESCSPA
	'Price of Sale 5'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB4'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'B4_PRV6'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda6'															, ; //X3_TITULO
	'Prc. Venta 6'															, ; //X3_TITSPA
	'Sale Price 6'															, ; //X3_TITENG
	'Preco de venda 6'														, ; //X3_DESCRIC
	'Precio de Venta 6'														, ; //X3_DESCSPA
	'Price of Sale 6'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB4'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'B4_PRV7'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda7'															, ; //X3_TITULO
	'Prc. Venta 7'															, ; //X3_TITSPA
	'Sale Price 7'															, ; //X3_TITENG
	'Preco de venda 7'														, ; //X3_DESCRIC
	'Precio de Venta 7'														, ; //X3_DESCSPA
	'Price of Sale 7'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB5
//
aAdd( aSX3, { ;
	'SB5'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'B5_PRV2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda2'															, ; //X3_TITULO
	'Prc. Venta 2'															, ; //X3_TITSPA
	'Sale Price 2'															, ; //X3_TITENG
	'Preco de venda 2'														, ; //X3_DESCRIC
	'Precio de Venta 2'														, ; //X3_DESCSPA
	'Price of Sale 2'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo() .and. A010Preco()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'2'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB5'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'B5_PRV3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda3'															, ; //X3_TITULO
	'Prc. Venta 3'															, ; //X3_TITSPA
	'Sale Price 3'															, ; //X3_TITENG
	'Preco de venda 3'														, ; //X3_DESCRIC
	'Precio de Venta 3'														, ; //X3_DESCSPA
	'Price of Sale 3'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo() .and. A010Preco()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'2'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB5'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'B5_PRV4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda4'															, ; //X3_TITULO
	'Prc. Venta 4'															, ; //X3_TITSPA
	'Sale Price 4'															, ; //X3_TITENG
	'Preco de venda 4'														, ; //X3_DESCRIC
	'Precio de Venta 4'														, ; //X3_DESCSPA
	'Price of Sale 4'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo() .and. A010Preco()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'2'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB5'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'B5_PRV5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda5'															, ; //X3_TITULO
	'Prc. Venta 5'															, ; //X3_TITSPA
	'Sale Price 5'															, ; //X3_TITENG
	'Preco de venda 5'														, ; //X3_DESCRIC
	'Precio de Venta 5'														, ; //X3_DESCSPA
	'Price of Sale 5'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo() .and. A010Preco()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'2'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB5'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'B5_PRV6'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda6'															, ; //X3_TITULO
	'Prc. Venta 6'															, ; //X3_TITSPA
	'Sale Price 6'															, ; //X3_TITENG
	'Preco de venda 6'														, ; //X3_DESCRIC
	'Precio de Venta 6'														, ; //X3_DESCSPA
	'Price of Sale 6'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo() .and. A010Preco()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'2'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB5'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'B5_PRV7'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda7'															, ; //X3_TITULO
	'Prc. Venta 7'															, ; //X3_TITSPA
	'Sale Price 7'															, ; //X3_TITENG
	'Preco de venda 7'														, ; //X3_DESCRIC
	'Precio de Venta 7'														, ; //X3_DESCSPA
	'Price of Sale 7'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo() .and. A010Preco()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'2'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB6
//
aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'B6_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'B6_PRUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Unit.'															, ; //X3_TITULO
	'Prc Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco Unitario'														, ; //X3_DESCRIC
	'Precio Unitario'														, ; //X3_DESCSPA
	'Unit Price'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'B6_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Seg.UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Meas.Uni'															, ; //X3_TITENG
	'Quant. Seg. Unid. Medida'												, ; //X3_DESCRIC
	'Cantidad 2a Unidad Medida'												, ; //X3_DESCSPA
	'Qty 2nd Unit of Measure'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'B6_QULIB'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant.Lib.'															, ; //X3_TITULO
	'Ctd.Aprobada'															, ; //X3_TITSPA
	'Approved'																, ; //X3_TITENG
	'Quantidade Liberada'													, ; //X3_DESCRIC
	'Cantidad Aprobada'														, ; //X3_DESCSPA
	'Approved Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'B6_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo Poder Terceiros'													, ; //X3_DESCRIC
	'Saldo en Poder Terceros'												, ; //X3_DESCSPA
	'Balance in 3rd Parties'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'37'																	, ; //X3_ORDEM
	'B6_CUSRP1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Reposicao'															, ; //X3_TITULO
	'C Reposicion'															, ; //X3_TITSPA
	'Replac.Cost'															, ; //X3_TITENG
	'Custo de Reposicao'													, ; //X3_DESCRIC
	'Costo de Reposicion'													, ; //X3_DESCSPA
	'Replacement Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'38'																	, ; //X3_ORDEM
	'B6_CUSRP2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.2a M'															, ; //X3_TITULO
	'C Repos.2a M'															, ; //X3_TITSPA
	'Rep.Cst.2.C.'															, ; //X3_TITENG
	'Custo de Reposicao 2a M'												, ; //X3_DESCRIC
	'Costo de Repos. 2a Mon.'												, ; //X3_DESCSPA
	'Replac.Cost 2nd Currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'39'																	, ; //X3_ORDEM
	'B6_CUSRP3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.3a M'															, ; //X3_TITULO
	'C Repos.3a M'															, ; //X3_TITSPA
	'Rep.Cst.3.C.'															, ; //X3_TITENG
	'Custo de Reposicao 3a M'												, ; //X3_DESCRIC
	'Costo de Repos. 3a Mon.'												, ; //X3_DESCSPA
	'Replac.Cost 3rd Currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'40'																	, ; //X3_ORDEM
	'B6_CUSRP4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.4a M'															, ; //X3_TITULO
	'C Repos.4a M'															, ; //X3_TITSPA
	'Rep.Cst.4.C.'															, ; //X3_TITENG
	'Custo de Reposicao 4a M'												, ; //X3_DESCRIC
	'Costo de Repos. 4a Mon.'												, ; //X3_DESCSPA
	'Replac.Cost 4th Currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB6'																	, ; //X3_ARQUIVO
	'41'																	, ; //X3_ORDEM
	'B6_CUSRP5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.5a M'															, ; //X3_TITULO
	'C Repos.5a M'															, ; //X3_TITSPA
	'Rep.Cst.5.C.'															, ; //X3_TITENG
	'Custo de Reposicao 5a M'												, ; //X3_DESCRIC
	'Costo de Repos. 5a Mon.'												, ; //X3_DESCSPA
	'Replac.Cost 5th Currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB7
//
aAdd( aSX3, { ;
	'SB7'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'B7_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade inventariada'												, ; //X3_DESCRIC
	'Cantidad Inventariada'													, ; //X3_DESCSPA
	'Quantity in Stock'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo().and.A270Conv()'												, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB7'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'B7_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na 2a unidade medida'												, ; //X3_DESCRIC
	'Cantidad 2a Unidad Medida'												, ; //X3_DESCSPA
	'Quantity 2nd Unit Meas.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo().and.A270Conv()'												, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB8
//
aAdd( aSX3, { ;
	'SB8'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'B8_QTDORI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Original'															, ; //X3_TITULO
	'Ctd.Original'															, ; //X3_TITSPA
	'Original Qty'															, ; //X3_TITENG
	'Quantidade Original'													, ; //X3_DESCRIC
	'Cantidad Original'														, ; //X3_DESCSPA
	'Original Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB8'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'B8_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Lote'															, ; //X3_TITULO
	'Sldo Lote'																, ; //X3_TITSPA
	'Lot Balance'															, ; //X3_TITENG
	'Saldo do Lote'															, ; //X3_DESCRIC
	'Saldo del Lote'														, ; //X3_DESCSPA
	'Lot Balance'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB8'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'B8_QACLASS'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Distrib'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade a Distribuir'												, ; //X3_DESCRIC
	'Cantidad para Distribuir'												, ; //X3_DESCSPA
	'Quantity to Distribute'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB8'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'B8_SALDO2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Sdo.Lote 2UM'															, ; //X3_TITULO
	'Sdo Lote2'																, ; //X3_TITSPA
	'2UM Lot Bal.'															, ; //X3_TITENG
	'Saldo do Lote 2a UM'													, ; //X3_DESCRIC
	'Saldo del Lote 2a UM'													, ; //X3_DESCSPA
	'2nd UM Lot Balance'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB8'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'B8_QTDORI2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Orig.2UM'															, ; //X3_TITULO
	'Ctd.Orig.2UM'															, ; //X3_TITSPA
	'Oirg.Qty 2'															, ; //X3_TITENG
	'Quantidade Original 2a UM'												, ; //X3_DESCRIC
	'Cantidad Original 2a UM'												, ; //X3_DESCSPA
	'Original Quantity 2nd SU'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB8'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'B8_QACLAS2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Dist.2UM'															, ; //X3_TITULO
	'Cantidad 2'															, ; //X3_TITSPA
	'Quantity 2'															, ; //X3_TITENG
	'Qtde a Distribuir 2a UM'												, ; //X3_DESCRIC
	'Cantidad Distribuir 2a UM'												, ; //X3_DESCSPA
	'Quantity to Distribute 2'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SB9
//
aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'B9_QINI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Inic.Mes'															, ; //X3_TITULO
	'Ctd.Inic.Mes'															, ; //X3_TITSPA
	'Mth.Int.Qty.'															, ; //X3_TITENG
	'Qtde inicial no mes'													, ; //X3_DESCRIC
	'Ctd. Inicial en el Mes'												, ; //X3_DESCSPA
	'Month Initial Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'AQtdGr220() .And. A220SegUM()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'B9_QISEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Ini.2a UM'															, ; //X3_TITULO
	'Ctd.Ini.2aUM'															, ; //X3_TITSPA
	'Beg.2 U.Meas'															, ; //X3_TITENG
	'Qtde Incial na 2a. UM'													, ; //X3_DESCRIC
	'Ctd. Inicial en 2a. UM'												, ; //X3_DESCSPA
	'Beginn. Quantity 2nd UM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'AQtdGr220() .And. Positivo() .And. A220PriUM()'						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'B9_CUSTD'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Custo Stand.'															, ; //X3_TITULO
	'Costo Estand'															, ; //X3_TITSPA
	'Std. Cost'																, ; //X3_TITENG
	'Custo Standard'														, ; //X3_DESCRIC
	'Costo Estandar'														, ; //X3_DESCSPA
	'Standard Cost'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'AQtdGr220() .And. Positivo()'											, ; //X3_VALID
	Chr(188) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(250) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'B9_CM1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 1a M'															, ; //X3_TITULO
	'C Unit 1a M'															, ; //X3_TITSPA
	'1st Un.Cost'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product unit cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'AQtdGr220()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'B9_CM2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 2a M'															, ; //X3_TITULO
	'C Unit 2a M'															, ; //X3_TITSPA
	'2nd Un.Cost'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product unit cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'AQtdGr220()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'B9_CM3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 3a M'															, ; //X3_TITULO
	'C Unit 3a M'															, ; //X3_TITSPA
	'3rd Un.Cost'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product unit cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'AQtdGr220()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'B9_CM4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 4a M'															, ; //X3_TITULO
	'C Unit 4a M'															, ; //X3_TITSPA
	'4th Un.Cost'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product unit cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'AQtdGr220()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SB9'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'B9_CM5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Unit 5a M'															, ; //X3_TITULO
	'C Unit 5a M'															, ; //X3_TITSPA
	'5th Un.Cost'															, ; //X3_TITENG
	'Custo unitario do produto'												, ; //X3_DESCRIC
	'Costo unitario producto'												, ; //X3_DESCSPA
	'Product unit cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'AQtdGr220()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBA
//
aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'BA_Q01'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 01'															, ; //X3_TITULO
	'Ctd. Mes 01'															, ; //X3_TITSPA
	'Qty Month 01'															, ; //X3_TITENG
	'Quantidade Mes Janeiro'												, ; //X3_DESCRIC
	'Cantidad Mes de Enero'													, ; //X3_DESCSPA
	'Quantity in January'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'BA_Q02'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 02'															, ; //X3_TITULO
	'Ctd. Mes 02'															, ; //X3_TITSPA
	'Qty.Month 02'															, ; //X3_TITENG
	'Quantidade Mes Fevereiro'												, ; //X3_DESCRIC
	'Cantidad Mes de Febrero'												, ; //X3_DESCSPA
	'Quantity in February'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'BA_Q03'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 03'															, ; //X3_TITULO
	'Ctd. Mes 03'															, ; //X3_TITSPA
	'Qty.Month 03'															, ; //X3_TITENG
	'Quantidade Mes Marco'													, ; //X3_DESCRIC
	'Cantidad Mes de Marzo'													, ; //X3_DESCSPA
	'Quantity in March'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'BA_Q04'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 04'															, ; //X3_TITULO
	'Ctd. Mes 04'															, ; //X3_TITSPA
	'Qty.Month 04'															, ; //X3_TITENG
	'Quantidade Mes Abril'													, ; //X3_DESCRIC
	'Cantidad Mes de Abril'													, ; //X3_DESCSPA
	'Quantity in April'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'BA_Q05'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 05'															, ; //X3_TITULO
	'Ctd. Mes 05'															, ; //X3_TITSPA
	'Qty.Month 05'															, ; //X3_TITENG
	'Quantidade Mes Maio'													, ; //X3_DESCRIC
	'Cantidad Mes de Mayo'													, ; //X3_DESCSPA
	'Quantity in May'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'BA_Q06'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 06'															, ; //X3_TITULO
	'Ctd. Mes 06'															, ; //X3_TITSPA
	'Qty.Month 06'															, ; //X3_TITENG
	'Quantidade Mes Junho'													, ; //X3_DESCRIC
	'Cantidad Mes de Junio'													, ; //X3_DESCSPA
	'Quantity in June'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'BA_Q07'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 07'															, ; //X3_TITULO
	'Ctd. Mes 07'															, ; //X3_TITSPA
	'Qty.Month 07'															, ; //X3_TITENG
	'Quantidade Mes Julho'													, ; //X3_DESCRIC
	'Cantidad Mes de Julio'													, ; //X3_DESCSPA
	'Quantity in July'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'BA_Q08'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 08'															, ; //X3_TITULO
	'Ctd. Mes 08'															, ; //X3_TITSPA
	'Qty.Month 08'															, ; //X3_TITENG
	'Quantidade Mes Agosto'													, ; //X3_DESCRIC
	'Cantidad Mes de Agosto'												, ; //X3_DESCSPA
	'Quantity in August'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'BA_Q09'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 09'															, ; //X3_TITULO
	'Ctd. Mes 09'															, ; //X3_TITSPA
	'Qty.Month 09'															, ; //X3_TITENG
	'Quantidade Mes Setembro'												, ; //X3_DESCRIC
	'Cantidad Mes de Setiembre'												, ; //X3_DESCSPA
	'Quantity in September'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'BA_Q10'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 10'															, ; //X3_TITULO
	'Ctd. Mes 10'															, ; //X3_TITSPA
	'Qty.Month 10'															, ; //X3_TITENG
	'Quantidade Mes Outubro'												, ; //X3_DESCRIC
	'Cantidad Mes de Octubre'												, ; //X3_DESCSPA
	'Quantity in October'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'BA_Q11'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 11'															, ; //X3_TITULO
	'Ctd. Mes 11'															, ; //X3_TITSPA
	'Qty.Month 11'															, ; //X3_TITENG
	'Quantidade Mes Novembro'												, ; //X3_DESCRIC
	'Cantidad Mes de Noviembre'												, ; //X3_DESCSPA
	'Quantity in November'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'BA_Q12'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Mes 12'															, ; //X3_TITULO
	'Ctd. Mes 12'															, ; //X3_TITSPA
	'Qty.Month 12'															, ; //X3_TITENG
	'Quantidade Mes Dezembro'												, ; //X3_DESCRIC
	'Cantidad Mes de Diciembre'												, ; //X3_DESCSPA
	'Quantity in December'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'BA_VALOR01'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Janeiro'															, ; //X3_TITULO
	'Vlr Enero'																, ; //X3_TITSPA
	'Jan.Value'																, ; //X3_TITENG
	'Valor Venda Janeiro'													, ; //X3_DESCRIC
	'Valor Venta Enero'														, ; //X3_DESCSPA
	'January Sales Price'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'BA_VALOR03'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Marco'																, ; //X3_TITULO
	'Vlr Marzo'																, ; //X3_TITSPA
	'Mar.Value'																, ; //X3_TITENG
	'Valor Venda Marco'														, ; //X3_DESCRIC
	'Valor Venta Marzo'														, ; //X3_DESCSPA
	'March Sales Price'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'BA_VALOR05'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Maio'																, ; //X3_TITULO
	'Vlr Mayo'																, ; //X3_TITSPA
	'May Value'																, ; //X3_TITENG
	'Valor Venda Maio'														, ; //X3_DESCRIC
	'Valor Venta Mayo'														, ; //X3_DESCSPA
	'May Sales Price'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'BA_VALOR06'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Junho'																, ; //X3_TITULO
	'Vlr Junio'																, ; //X3_TITSPA
	'Value June'															, ; //X3_TITENG
	'Valor Venda Junho'														, ; //X3_DESCRIC
	'Valor Venta Junio'														, ; //X3_DESCSPA
	'June Sales Value'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'BA_VALOR07'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Julho'																, ; //X3_TITULO
	'Vlr Julio'																, ; //X3_TITSPA
	'Jul.Value'																, ; //X3_TITENG
	'Valor Venda Julho'														, ; //X3_DESCRIC
	'Valor Venta Julio'														, ; //X3_DESCSPA
	'July Sales Value'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'BA_VALOR09'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Setembro'															, ; //X3_TITULO
	'Vlr Septiemb'															, ; //X3_TITSPA
	'Sep.Value'																, ; //X3_TITENG
	'Valor Venda Setembro'													, ; //X3_DESCRIC
	'Valor Venta Septiembre'												, ; //X3_DESCSPA
	'September Sales Value'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'BA_VALOR10'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Outubro'															, ; //X3_TITULO
	'Vlr Octubre'															, ; //X3_TITSPA
	'Oct.Value'																, ; //X3_TITENG
	'Valor Venda Outubro'													, ; //X3_DESCRIC
	'Valor Venta Octubre'													, ; //X3_DESCSPA
	'October Sales Value'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBA'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'BA_VALOR11'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Novembro'															, ; //X3_TITULO
	'Vlr Noviembr'															, ; //X3_TITSPA
	'Nov.Value'																, ; //X3_TITENG
	'Valor Venda Novembro'													, ; //X3_DESCRIC
	'Valor Venta Noviembre'													, ; //X3_DESCSPA
	'November Sales Value'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBB
//
aAdd( aSX3, { ;
	'SBB'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'BB_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor'																	, ; //X3_TITULO
	'Valor'																	, ; //X3_TITSPA
	'Value'																	, ; //X3_TITENG
	'Valor do Produto'														, ; //X3_DESCRIC
	'Valor del Producto'													, ; //X3_DESCSPA
	'Product Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(253) + Chr(200) + Chr(132) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(153) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBC
//
aAdd( aSX3, { ;
	'SBC'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'BC_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Perda'																, ; //X3_TITULO
	'Ctd. Perdida'															, ; //X3_TITSPA
	'Loss Qty.'																, ; //X3_TITENG
	'Quantidade da Perda'													, ; //X3_DESCRIC
	'Cantidad de la Perdida'												, ; //X3_DESCSPA
	'Quantity of Loss'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A685QTDUM() .AND. Positivo()'											, ; //X3_VALID
	Chr(136) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBC'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'BC_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Perd 2UM'															, ; //X3_TITULO
	'Ctd Perd 2UM'															, ; //X3_TITSPA
	'Loss Qty 2UM'															, ; //X3_TITENG
	'Quantidade Perda 2a.U.M.'												, ; //X3_DESCRIC
	'Cantidad Perdida 2a.U.M.'												, ; //X3_DESCSPA
	'Destination quant. 2nd UM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A685QTDUM() .AND. POSITIVO()'											, ; //X3_VALID
	Chr(136) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBC'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'BC_QTDDEST'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Destino'															, ; //X3_TITULO
	'Ctd. Destino'															, ; //X3_TITSPA
	'Destinat.Qty'															, ; //X3_TITENG
	'Quantidade Destino'													, ; //X3_DESCRIC
	'Cantidad Destino'														, ; //X3_DESCSPA
	'Quantity Target'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A685QTDUM() .AND. Positivo()'											, ; //X3_VALID
	Chr(136) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBC'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'BC_QTDDES2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Dest 2UM'															, ; //X3_TITULO
	'Ctd Dest 2UM'															, ; //X3_TITSPA
	'Dest Qty 2UM'															, ; //X3_TITENG
	'Quantidade Destino 2a.U.M'												, ; //X3_DESCRIC
	'Cantidade Destino 2a.U.M'												, ; //X3_DESCSPA
	'Destination quant. 2nd UM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A685QTDUM() .AND. POSITIVO()'											, ; //X3_VALID
	Chr(136) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBD
//
aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'BD_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'BD_QT2UM'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant. 2 UM'															, ; //X3_TITULO
	'Ctd. 2a UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Quantidade 2 UM'														, ; //X3_DESCRIC
	'Cantidad 2a Unidad Medida'												, ; //X3_DESCSPA
	'Quantity 2nd Meas. Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'BD_QINI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Inicio'															, ; //X3_TITULO
	'Ctd. Inicial'															, ; //X3_TITSPA
	'Ini.Quantity'															, ; //X3_TITENG
	'Quantidade Inicio'														, ; //X3_DESCRIC
	'Cantidad Inicial'														, ; //X3_DESCSPA
	'Initial Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .AND. A221QUANT()'											, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'BD_QINI2UM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Ini 2 UM'															, ; //X3_TITULO
	'Ctd.Ini 2aUM'															, ; //X3_TITSPA
	'Ini.Qty S.U.'															, ; //X3_TITENG
	'Quantidade Inicio 2 UM'												, ; //X3_DESCRIC
	'Cantidad Inicio 2a U.Med.'												, ; //X3_DESCSPA
	'Ini. Quantity 2 Meas.Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .AND. A221QUANT()'											, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'BD_CUSINI1'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.1a M'															, ; //X3_TITULO
	'Cos.Ini.1Mon'															, ; //X3_TITSPA
	'Int. Cst C1'															, ; //X3_TITENG
	'Custo Ini. na 1a Moeda'												, ; //X3_DESCRIC
	'Costo Inicial 1a. Moneda'												, ; //X3_DESCSPA
	'Initial Cost Currency 1'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'BD_CUSINI2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.2a M'															, ; //X3_TITULO
	'Cos.Ini.2Mon'															, ; //X3_TITSPA
	'Int. Cst C2'															, ; //X3_TITENG
	'Custo Ini. na 2a Moeda'												, ; //X3_DESCRIC
	'Costo Inicial 2a. Moneda'												, ; //X3_DESCSPA
	'Initial Cost Currency 2'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'BD_CUSINI3'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.3a M'															, ; //X3_TITULO
	'Cos.Ini.3Mon'															, ; //X3_TITSPA
	'Int. Cst C3'															, ; //X3_TITENG
	'Custo Ini. na 3a Moeda'												, ; //X3_DESCRIC
	'Costo Inicial 3a. Moneda'												, ; //X3_DESCSPA
	'Initial Cost Currency 3'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'BD_CUSINI4'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.4a M'															, ; //X3_TITULO
	'Cos.Ini.4Mon'															, ; //X3_TITSPA
	'Int. Cst C4'															, ; //X3_TITENG
	'Custo Ini. na 4a Moeda'												, ; //X3_DESCRIC
	'Costo Inicial 4a. Moneda'												, ; //X3_DESCSPA
	'Initial Cost Currency 4'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'BD_CUSINI5'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.5a M'															, ; //X3_TITULO
	'Cos.Ini.5Mon'															, ; //X3_TITSPA
	'Int. Cst C5'															, ; //X3_TITENG
	'Custo Ini. na 5a Moeda'												, ; //X3_DESCRIC
	'Costo Inicial 5a. Moneda'												, ; //X3_DESCSPA
	'Initial Cost Currency 5'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'BD_QFIM'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Final'															, ; //X3_TITULO
	'Ctd. Final'															, ; //X3_TITSPA
	'Final Qty.'															, ; //X3_TITENG
	'Quantidade Final'														, ; //X3_DESCRIC
	'Cantidad Final'														, ; //X3_DESCSPA
	'Final quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'BD_QFIM2UM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Fim 2 UM'															, ; //X3_TITULO
	'Ctd.Fin 2aUM'															, ; //X3_TITSPA
	'Final2nd S.U'															, ; //X3_TITENG
	'Quantidade Final 2 UM'													, ; //X3_DESCRIC
	'Cantidad Final 2a. U.Med.'												, ; //X3_DESCSPA
	'Final Quantity 2 Meas.Uni'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'BD_CUSFIM1'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fim.1a M'															, ; //X3_TITULO
	'Cos.Fin.1Mon'															, ; //X3_TITSPA
	'Fin. Cst C1'															, ; //X3_TITENG
	'Custo Final na 1a Moeda'												, ; //X3_DESCRIC
	'Costo Final en 1a. Moneda'												, ; //X3_DESCSPA
	'Final Cost in Currency 1'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'BD_CUSFIM2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fim.2a M'															, ; //X3_TITULO
	'Cos.Fin.2Mon'															, ; //X3_TITSPA
	'Fin. Cst C2'															, ; //X3_TITENG
	'Custo Final na 2a Moeda'												, ; //X3_DESCRIC
	'Costo Final en 2a. Moneda'												, ; //X3_DESCSPA
	'Final Cost in Currency 2'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'BD_CUSFIM3'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fim.3a M'															, ; //X3_TITULO
	'Cos.Fin.3Mon'															, ; //X3_TITSPA
	'Fin. Cst C3'															, ; //X3_TITENG
	'Custo Final na 3a Moeda'												, ; //X3_DESCRIC
	'Costo Final en 3a. Moneda'												, ; //X3_DESCSPA
	'Final Cost in Currency 3'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'BD_CUSFIM4'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fim.4a M'															, ; //X3_TITULO
	'Cos.Fin.4Mon'															, ; //X3_TITSPA
	'Fin. Cst C4'															, ; //X3_TITENG
	'Custo Final na 4a Moeda'												, ; //X3_DESCRIC
	'Costo Final en 4a. Moneda'												, ; //X3_DESCSPA
	'Final Cost in Currency 4'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBD'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'BD_CUSFIM5'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fim.5a M'															, ; //X3_TITULO
	'Cos.Fin.5Mon'															, ; //X3_TITSPA
	'Final Cst C5'															, ; //X3_TITENG
	'Custo Final na 5a Moeda'												, ; //X3_DESCRIC
	'Costo Final en 5a. Moneda'												, ; //X3_DESCSPA
	'Final Cost in currency 5'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBF
//
aAdd( aSX3, { ;
	'SBF'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'BF_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade no Endedeco'												, ; //X3_DESCRIC
	'Cantidad en Ubicacion'													, ; //X3_DESCSPA
	'Quantity in Address'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(172) + Chr(212) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBF'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'BF_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd 2a. UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cantidad 2a Unidad Medid'												, ; //X3_DESCSPA
	'Quantity in Second Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBH
//
aAdd( aSX3, { ;
	'SBH'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'BH_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Utilizada'													, ; //X3_DESCRIC
	'Cantidad Utilizada'													, ; //X3_DESCSPA
	'Quantity Used'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBI
//
aAdd( aSX3, { ;
	'SBI'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'BI_PRV'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda'															, ; //X3_TITULO
	'Prc. Venta'															, ; //X3_TITSPA
	'Sale Price'															, ; //X3_TITENG
	'Preco de Venda'														, ; //X3_DESCRIC
	'Precio de Venta'														, ; //X3_DESCSPA
	'Sale Price'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(132) + Chr(128) + Chr(160) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBJ
//
aAdd( aSX3, { ;
	'SBJ'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'BJ_QINI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Inic.Mes'															, ; //X3_TITULO
	'Ctd.Inic.Mes'															, ; //X3_TITSPA
	'Mth.Int.Qty.'															, ; //X3_TITENG
	'Qtde inicial no mes'													, ; //X3_DESCRIC
	'Ctd. Inicial en el Mes'												, ; //X3_DESCSPA
	'Month Initial Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBJ'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'BJ_QISEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Ini.2a UM'															, ; //X3_TITULO
	'Ct.Ini.2a UM'															, ; //X3_TITSPA
	'In.Qt.Mt.2UM'															, ; //X3_TITENG
	'Qtde inicial no mes 2a.UM'												, ; //X3_DESCRIC
	'Ctd.Inicial en el Mes 2UM'												, ; //X3_DESCSPA
	'Int.Quantity in Month 2UM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBK
//
aAdd( aSX3, { ;
	'SBK'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'BK_QINI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Inic.Mes'															, ; //X3_TITULO
	'Ctd.Inic.Mes'															, ; //X3_TITSPA
	'Mth.Int.Qty.'															, ; //X3_TITENG
	'Qtde inicial no mes'													, ; //X3_DESCRIC
	'Ctd. Inicial en el Mes'												, ; //X3_DESCSPA
	'Month Initial Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBK'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'BK_QISEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Ini.2a UM'															, ; //X3_TITULO
	'Ct.Ini.2a UM'															, ; //X3_TITSPA
	'In.Qt.Mt.2UM'															, ; //X3_TITENG
	'Qtde inicial no mes 2a.UM'												, ; //X3_DESCRIC
	'Ctd.Inicial en el Mes 2UM'												, ; //X3_DESCSPA
	'Int.Quantity in Month 2UM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBL
//
aAdd( aSX3, { ;
	'SBL'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'BL_TOTCUST'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Tot.Custo'																, ; //X3_TITULO
	'Total Costo'															, ; //X3_TITSPA
	'Total Cost'															, ; //X3_TITENG
	'Total do Custo'														, ; //X3_DESCRIC
	'Total de Costo'														, ; //X3_DESCSPA
	'Total Cost'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(160) + Chr(173) + Chr(160) + Chr(160) + Chr(160) + ;
	Chr(162) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBL'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'BL_QTDFOR1'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd formula1'															, ; //X3_TITULO
	'Ctd formula1'															, ; //X3_TITSPA
	'Qty Formula1'															, ; //X3_TITENG
	'Qtd resultado da formula1'												, ; //X3_DESCRIC
	'Ctd resultado de formula1'												, ; //X3_DESCSPA
	'Formula 1 Result Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBL'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'BL_QTDFOR2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd formula2'															, ; //X3_TITULO
	'Ctd formula2'															, ; //X3_TITSPA
	'Qty Formula2'															, ; //X3_TITENG
	'Qtd resultado da formula2'												, ; //X3_DESCRIC
	'Ctd resultado de formula2'												, ; //X3_DESCSPA
	'Formula 2 Result Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBL'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'BL_QTDFOR3'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd formula3'															, ; //X3_TITULO
	'Ctd formula3'															, ; //X3_TITSPA
	'Qty Formula3'															, ; //X3_TITENG
	'Qtd resultado da formula3'												, ; //X3_DESCRIC
	'Ctd resultado de formula3'												, ; //X3_DESCSPA
	'Formula 3 Result Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SBL'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'BL_QTDFOR4'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd formula4'															, ; //X3_TITULO
	'Ctd formula4'															, ; //X3_TITSPA
	'Qty Formula4'															, ; //X3_TITENG
	'Qtd resultado da formula4'												, ; //X3_DESCRIC
	'Ctd resultado de formula4'												, ; //X3_DESCSPA
	'Formula 4 Result Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(160) + Chr(160) + Chr(160) + Chr(160) + Chr(160) + ;
	Chr(160) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(160) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBU
//
aAdd( aSX3, { ;
	'SBU'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'BU_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade do Item'													, ; //X3_DESCRIC
	'Cantidad del Item'														, ; //X3_DESCSPA
	'Item Quantity'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'NaoVazio()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(214) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SBZ
//
aAdd( aSX3, { ;
	'SBZ'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'BZ_CUSTD'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Custo Stand.'															, ; //X3_TITULO
	'Costo Estand'															, ; //X3_TITSPA
	'Std.Cost'																, ; //X3_TITENG
	'Custo Standard'														, ; //X3_DESCRIC
	'Costo Estandar'														, ; //X3_DESCSPA
	'Standard Cost'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(188) + Chr(255) + Chr(132) + Chr(129) + Chr(128) + ;
	Chr(139) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC0
//
aAdd( aSX3, { ;
	'SC0'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'C0_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Qtd. reservada/Saldo'													, ; //X3_DESCRIC
	'Cantidad Reservada'													, ; //X3_DESCSPA
	'Quantity Reserved'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A430Quant() .And. A430LotQtd()'										, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'a430Vld()'																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC0'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'C0_QTDORIG'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Original'															, ; //X3_TITULO
	'Ctd.Original'															, ; //X3_TITSPA
	'Orig.Qty.'																, ; //X3_TITENG
	'Quantidade Original'													, ; //X3_DESCRIC
	'Cantidad Original'														, ; //X3_DESCSPA
	'Original Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC0'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'C0_QTDPED'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Em.Ped.'															, ; //X3_TITULO
	'Cant.En Ped.'															, ; //X3_TITSPA
	'Order Qty'																, ; //X3_TITENG
	'Quantidade em Pedido'													, ; //X3_DESCRIC
	'Cantidad en Pedido'													, ; //X3_DESCSPA
	'Order Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC0'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'C0_QTDELIM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Eliminada'															, ; //X3_TITULO
	'Ct.Eliminada'															, ; //X3_TITSPA
	'Rem.Qtty.'																, ; //X3_TITENG
	'Quantidade eliminada'													, ; //X3_DESCRIC
	'Cantidad eliminada'													, ; //X3_DESCSPA
	'Removed Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC1
//
aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'C1_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da SC'														, ; //X3_DESCRIC
	'Cantidad de la SC'														, ; //X3_DESCSPA
	'Quantity Purchase Requis.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo().and.A110QtdGra().and.A110valid("Q").And.A100Segum().And.PMSQtdeSC()', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C1_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd 2a. UM'															, ; //X3_TITSPA
	'2nd M.U.Qty.'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity in 2 Meas.Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'(positivo().or.Vazio()).and.A110QtdGra().And.A100Segum().And.PMSQtdeSC()'	, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'C1_QUJE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant.em Ped'															, ; //X3_TITULO
	'Ctd.en Pedid'															, ; //X3_TITSPA
	'Order Qty.'															, ; //X3_TITENG
	'Quantidade em Pedido'													, ; //X3_DESCRIC
	'Cantidad en Pedido'													, ; //X3_DESCSPA
	'Quantity in Orders'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(152) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'39'																	, ; //X3_ORDEM
	'C1_QUJE2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Seg.Ped.'															, ; //X3_TITULO
	'Ctd.Seg.Ped.'															, ; //X3_TITSPA
	'Order Qty'																, ; //X3_TITENG
	'Quantidade Seg. em Pedido'												, ; //X3_DESCRIC
	'Cantidad Seg. en Pedido'												, ; //X3_DESCSPA
	'Order Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'47'																	, ; //X3_ORDEM
	'C1_VUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Unitario'															, ; //X3_TITULO
	'Val Unitario'															, ; //X3_TITSPA
	'Unit Vl.'																, ; //X3_TITENG
	'Valor Unitario'														, ; //X3_DESCRIC
	'Valor Unitario'														, ; //X3_DESCSPA
	'Unit Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(132) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(134) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'51'																	, ; //X3_ORDEM
	'C1_QTDORIG'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Original'															, ; //X3_TITULO
	'Cant. Orig.'															, ; //X3_TITSPA
	'Org. Qtty.'															, ; //X3_TITENG
	'Quantidade Original'													, ; //X3_DESCRIC
	'Cantidad Original'														, ; //X3_DESCSPA
	'Original Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(160) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(136)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(156) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'52'																	, ; //X3_ORDEM
	'C1_PRECO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Unitario'															, ; //X3_TITULO
	'Prc Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco unitario do item'												, ; //X3_DESCRIC
	'Precio unitario del item'												, ; //X3_DESCSPA
	'Item Unit Price'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A113Preco(M->C1_PRECO)'												, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC1'																	, ; //X3_ARQUIVO
	'55'																	, ; //X3_ORDEM
	'C1_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Val.Total'																, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Valor total do item'													, ; //X3_DESCRIC
	'Valor total del item'													, ; //X3_DESCSPA
	'Item Total Item'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A113Total(M->C1_TOTAL)'												, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC2
//
aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C2_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da OP'														, ; //X3_DESCRIC
	'Cantidad de la Ord. Prod.'												, ; //X3_DESCSPA
	'Production Order Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'AQtdGrade() .And. A650Quant() .And. Positivo() .Or. Vazio()'			, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'C2_QUJE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Produzid'															, ; //X3_TITULO
	'Ctd.Producid'															, ; //X3_TITSPA
	'Produced Qty'															, ; //X3_TITENG
	'Qtde Produzida'														, ; //X3_DESCRIC
	'Cantidad Producida'													, ; //X3_DESCSPA
	'Quantity Produced'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'C2_VINI1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Inicial'															, ; //X3_TITULO
	'Vlr. Inicial'															, ; //X3_TITSPA
	'Init. Value'															, ; //X3_TITENG
	'Valor inicial'															, ; //X3_DESCRIC
	'Valor Inicial'															, ; //X3_DESCSPA
	'Initial Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'57'																	, ; //X3_ORDEM
	'C2_QTUPROG'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde Ult.MRP'															, ; //X3_TITULO
	'Ctd Ult. MRP'															, ; //X3_TITSPA
	'Qty.Lst.Date'															, ; //X3_TITENG
	'Qtde Rep. Ultimo MRP'													, ; //X3_DESCRIC
	'Ctd. Rep. Ultimo MRP'													, ; //X3_DESCSPA
	'Last MRP Repos. Qty'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'67'																	, ; //X3_ORDEM
	'C2_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd 2a UM'																, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.U.Meas.'															, ; //X3_TITENG
	'Quantidade 2a UM da OP'												, ; //X3_DESCRIC
	'Cantidad 2a. UM de la OP'												, ; //X3_DESCSPA
	'2nd. Meas.Unit Prod.Order'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A650QtSeg().And.AQtdGrade()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'68'																	, ; //X3_ORDEM
	'C2_VINIFF1'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Inicial'															, ; //X3_TITULO
	'Vlr. Inicial'															, ; //X3_TITSPA
	'Initi. Value'															, ; //X3_TITENG
	'Valor inicial'															, ; //X3_DESCRIC
	'Valor Inicial'															, ; //X3_DESCSPA
	'Initial Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'69'																	, ; //X3_ORDEM
	'C2_VINIFF2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Inicial'															, ; //X3_TITULO
	'Vlr. Inicial'															, ; //X3_TITSPA
	'Initi. Value'															, ; //X3_TITENG
	'Valor inicial'															, ; //X3_DESCRIC
	'Valor Inicial'															, ; //X3_DESCSPA
	'Initial Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'70'																	, ; //X3_ORDEM
	'C2_VINIFF3'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Inicial'															, ; //X3_TITULO
	'Vlr. Inicial'															, ; //X3_TITSPA
	'Initi. Value'															, ; //X3_TITENG
	'Valor inicial'															, ; //X3_DESCRIC
	'Valor Inicial'															, ; //X3_DESCSPA
	'Initial Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'71'																	, ; //X3_ORDEM
	'C2_VINIFF4'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Inicial'															, ; //X3_TITULO
	'Vlr. Inicial'															, ; //X3_TITSPA
	'Initi. Value'															, ; //X3_TITENG
	'Valor inicial'															, ; //X3_DESCRIC
	'Valor Inicial'															, ; //X3_DESCSPA
	'Initial Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC2'																	, ; //X3_ARQUIVO
	'72'																	, ; //X3_ORDEM
	'C2_VINIFF5'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Inicial'															, ; //X3_TITULO
	'Vlr. Inicial'															, ; //X3_TITSPA
	'Initi. Value'															, ; //X3_TITENG
	'Valor inicial'															, ; //X3_DESCRIC
	'Valor Inicial'															, ; //X3_DESCSPA
	'Initial Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC3
//
aAdd( aSX3, { ;
	'SC3'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'C3_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade pedida'														, ; //X3_DESCRIC
	'Cantidad Pedida'														, ; //X3_DESCSPA
	'Quantity Lost'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A125QtdGra().and.positivo().and.A125Quant(M->C3_QUANT).and.MaFisRef("IT_QUANT","MT120",M->C3_QUANT)', ; //X3_VALID
	Chr(168) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC3'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C3_PRECO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Unitario'															, ; //X3_TITULO
	'Prc Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco unitario do item'												, ; //X3_DESCRIC
	'Precio unitario del item'												, ; //X3_DESCSPA
	'Unit Price of Item'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo().and.A125Preco(M->C3_PRECO).and.MaFisRef("IT_PRCUNI","MT120",M->C3_PRECO)', ; //X3_VALID
	Chr(168) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC3'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'C3_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Valor total do item'													, ; //X3_DESCRIC
	'Valor Total del Item'													, ; //X3_DESCSPA
	'Item Total Value'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A125Total(M->C3_TOTAL).and.MaFisRef("IT_VALMERC","MT120",M->C3_TOTAL)'		, ; //X3_VALID
	Chr(168) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC3'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'C3_QUJE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Entregue'															, ; //X3_TITULO
	'Ctd. Entrega'															, ; //X3_TITSPA
	'Qty.Delivery'															, ; //X3_TITENG
	"Quantidade ja' entregue"												, ; //X3_DESCRIC
	'Cantidad ya Entregada'													, ; //X3_DESCSPA
	'Quantity already deliverd'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC3'																	, ; //X3_ARQUIVO
	'40'																	, ; //X3_ORDEM
	'C3_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Cant. 2a UM'															, ; //X3_TITSPA
	'Qty. 2nd UoM'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cant. en la Segunda Unida'												, ; //X3_DESCSPA
	'Quantity in second unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A125QtdGra().and.(Positivo().or.Vazio()).and.A100Segum()'				, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC3'																	, ; //X3_ARQUIVO
	'41'																	, ; //X3_ORDEM
	'C3_QTIMP'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Imp.'																, ; //X3_TITULO
	'Cant. Imp.'															, ; //X3_TITSPA
	'Print Qty.'															, ; //X3_TITENG
	'Quantidade de impressใo'												, ; //X3_DESCRIC
	'Cantidad de impresion'													, ; //X3_DESCSPA
	'Print quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(222) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC4
//
aAdd( aSX3, { ;
	'SC4'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'C4_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da previsao'												, ; //X3_DESCRIC
	'Cantidad de la Prevision'												, ; //X3_DESCSPA
	'Forecast Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo().and.a700qtdgra()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC4'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'C4_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor'																	, ; //X3_TITULO
	'Valor'																	, ; //X3_TITSPA
	'Value'																	, ; //X3_TITENG
	'Valor da previsao'														, ; //X3_DESCRIC
	'Valor de la Prevision'													, ; //X3_DESCSPA
	'Estimated Value'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo().and.a700qtdgra()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC6
//
aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'C6_QTDVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Vendida'													, ; //X3_DESCRIC
	'Cantidad Vendida'														, ; //X3_DESCSPA
	'Quantity Sold'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A410QTDGRA() .AND. A410SegUm().and.A410MultT().and.a410Refr("C6_QTDVEN")'	, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'C6_PRCVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Unitario'															, ; //X3_TITULO
	'Prc Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco Unitario Liquido'												, ; //X3_DESCRIC
	'Precio Unitario Neto'													, ; //X3_DESCSPA
	'Net Unit Price'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A410QtdGra() .And. A410MultT() .And. A410Zera()'						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'C6_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Grand Total'															, ; //X3_TITENG
	'Valor Total do Item'													, ; //X3_DESCRIC
	'Valor Total del Item'													, ; //X3_DESCSPA
	'Item Grand Total'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A410MultT()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C6_QTDLIB'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Liberada'															, ; //X3_TITULO
	'Ctd Aprobada'															, ; //X3_TITSPA
	'Amt Approved'															, ; //X3_TITENG
	'Quantidade Liberada'													, ; //X3_DESCRIC
	'Cantidad Aprobada'														, ; //X3_DESCSPA
	'Amount Approved'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A410QTDGRA() .AND. A440Qtdl() .and. a410MultT().and.a410Refr("C6_QTDLIB")'	, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'C6_QTDLIB2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Lib 2aUM'															, ; //X3_TITULO
	'Ctd.Lib 2aUM'															, ; //X3_TITSPA
	'Qt.Rls.2UoM'															, ; //X3_TITENG
	'Quantidade Liberada 2a UM'												, ; //X3_DESCRIC
	'Cantidad Aprobada 2a UM'												, ; //X3_DESCSPA
	'Quantity Released 2nd UOM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'C6_UNSVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Ven 2 UM'															, ; //X3_TITULO
	'Ctd.Ven 2aUM'															, ; //X3_TITSPA
	'Qty.Sold 2UM'															, ; //X3_TITENG
	'Quant. Vend. na 2 Unid M.'												, ; //X3_DESCRIC
	'Ctd. Vend. en 2a.Unid.Med'												, ; //X3_DESCSPA
	'Quantity Sold 2 Meas.Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A410Quant().and.(positivo().or.vazio())'								, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'C6_QTDENT2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Seg Ent.'															, ; //X3_TITULO
	'Ctd.Seg Ent.'															, ; //X3_TITSPA
	'Qty.2nd Del.'															, ; //X3_TITENG
	'Qtd.Seg. UM Entregue'													, ; //X3_DESCRIC
	'Ctd. Seg. UM Entregada'												, ; //X3_DESCSPA
	'Sec. Unit Delivered Qtt.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(152) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'C6_QTDENT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Entregue'															, ; //X3_TITULO
	'Ctd.Entregad'															, ; //X3_TITSPA
	'Qty.Delivery'															, ; //X3_TITENG
	'Quantidade Entregue'													, ; //X3_DESCRIC
	'Cantidad Entregada'													, ; //X3_DESCSPA
	'Quantity Delivered'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(152) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'36'																	, ; //X3_ORDEM
	'C6_PRUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Lista'																, ; //X3_TITULO
	'Precio Lista'															, ; //X3_TITSPA
	'Price List'															, ; //X3_TITENG
	'Preco Unitario de Tabela'												, ; //X3_DESCRIC
	'Precio Unitario de Tabla'												, ; //X3_DESCSPA
	'Unit List Price'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A410MultT()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'62'																	, ; //X3_ORDEM
	'C6_QTDRESE'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Reserva'															, ; //X3_TITULO
	'Ctd. Reserva'															, ; //X3_TITSPA
	'Reserv. Qty.'															, ; //X3_TITENG
	'Quant. Reservada'														, ; //X3_DESCRIC
	'Cantidad Reservada'													, ; //X3_DESCSPA
	'Allocated Quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'82'																	, ; //X3_ORDEM
	'C6_QTDEMP'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt Empenhada'															, ; //X3_TITULO
	'Ctd.Reservad'															, ; //X3_TITSPA
	'Qty.Employed'															, ; //X3_TITENG
	'Quantidade Empenhada'													, ; //X3_DESCRIC
	'Cantidad Reservada'													, ; //X3_DESCSPA
	'Alloccated Quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(152) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'83'																	, ; //X3_ORDEM
	'C6_QTDEMP2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt Seg. Emp'															, ; //X3_TITULO
	'Ctd Seg. Res'															, ; //X3_TITSPA
	'Qty.2dn All.'															, ; //X3_TITENG
	'Qtd. Seg. UN Empenhada'												, ; //X3_DESCRIC
	'Ctd. Seg. UN Reservada'												, ; //X3_DESCSPA
	'Sec. Unit Allocated Qtt.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(152) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC7
//
aAdd( aSX3, { ;
	'SC7'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C7_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade pedida'														, ; //X3_DESCRIC
	'Cantidad Pedida'														, ; //X3_DESCSPA
	'Loss Quantity'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A120QTDGRA().AND.Positivo().And.A120Quant(M->C7_QUANT).And.MaFisRef("IT_QUANT","MT120",M->C7_QUANT).And.a120Tabela()', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC7'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'C7_PRECO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Unitario'															, ; //X3_TITULO
	'Prc.Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco unitario do item'												, ; //X3_DESCRIC
	'Precio Unitario del Item'												, ; //X3_DESCSPA
	'Unit Price of Item'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo().and.A120Preco(M->C7_PRECO).And.MaFisRef("IT_PRCUNI","MT120",M->C7_PRECO)', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC7'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'C7_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Valor total do item'													, ; //X3_DESCRIC
	'Valor Total del Item'													, ; //X3_DESCSPA
	'Item Total Value'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A120Total(M->C7_TOTAL).And.MaFisRef("IT_VALMERC","MT120",M->C7_TOTAL)'		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC7'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'C7_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd 2a. UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity in Second Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A120QtdGra().and.(Positivo().or.Vazio()).and.A100Segum().And.a120Tabela()'	, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC7'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'C7_QUJE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Entregue'															, ; //X3_TITULO
	'Ctd. Entrega'															, ; //X3_TITSPA
	'Qty.Delivery'															, ; //X3_TITENG
	"Quantidade ja' entregue"												, ; //X3_DESCRIC
	'Cantidad ya Entregada'													, ; //X3_DESCSPA
	'Qty already delivered'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC7'																	, ; //X3_ARQUIVO
	'51'																	, ; //X3_ORDEM
	'C7_QTDACLA'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.a Classi'															, ; //X3_TITULO
	'Ctd.a Clasif'															, ; //X3_TITSPA
	'Qty.to Class'															, ; //X3_TITENG
	'Qtde a Classificar'													, ; //X3_DESCRIC
	'Cantidad a Clasificar'													, ; //X3_DESCSPA
	'Quantity to Be Classified'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC7'																	, ; //X3_ARQUIVO
	'61'																	, ; //X3_ORDEM
	'C7_QTDSOL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde da SC'															, ; //X3_TITULO
	'Ctd.de SC'																, ; //X3_TITSPA
	'Pur.Req.Qty'															, ; //X3_TITENG
	'Quantidade pedida da SC'												, ; //X3_DESCRIC
	'Cantidad pedida de SC'													, ; //X3_DESCSPA
	'Purchase Request Qty'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC8
//
aAdd( aSX3, { ;
	'SC8'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'C8_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade cotada'														, ; //X3_DESCRIC
	'Cantidad Cotizada'														, ; //X3_DESCSPA
	'Quantity Valuated'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(153) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC8'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'C8_QTDCTR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.p/ Ctr.'															, ; //X3_TITULO
	'Ctd.p/Contr.'															, ; //X3_TITSPA
	'Contr. Qty'															, ; //X3_TITENG
	'Quantidade para Contrato'												, ; //X3_DESCRIC
	'Cantidad para Contrato'												, ; //X3_DESCSPA
	'Contract Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC8'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C8_PRECO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Unitar'															, ; //X3_TITULO
	'Prc Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco unitario do item'												, ; //X3_DESCRIC
	'Precio Unitario del Item'												, ; //X3_DESCSPA
	'Unit Price of Item'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(153) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC8'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'C8_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Total Item'															, ; //X3_TITULO
	'Total Item'															, ; //X3_TITSPA
	'Item Total'															, ; //X3_TITENG
	'Valor total do item'													, ; //X3_DESCRIC
	'Valor Total del Item'													, ; //X3_DESCSPA
	'Total Value of Item'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A150Total(M->C8_TOTAL).And.MaFisRef("IT_VALMERC","MT150",M->C8_TOTAL)'		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(153) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC8'																	, ; //X3_ARQUIVO
	'44'																	, ; //X3_ORDEM
	'C8_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cantidad en la 2a. Unidad'												, ; //X3_DESCSPA
	'Quantity in Second Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo().or.Vazio()'													, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SC9
//
aAdd( aSX3, { ;
	'SC9'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C9_QTDLIB'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt Liberada'															, ; //X3_TITULO
	'Ctd.Aprobad.'															, ; //X3_TITSPA
	'Approved Qty'															, ; //X3_TITENG
	'Quantidade Liberada'													, ; //X3_DESCRIC
	'Cantidad Aprobada'														, ; //X3_DESCSPA
	'Quantity Released'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC9'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'C9_QTDRESE'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Reserva'															, ; //X3_TITULO
	'Ctd.Reservad'															, ; //X3_TITSPA
	'Reserved'																, ; //X3_TITENG
	'Qtd.Reservada'															, ; //X3_DESCRIC
	'Cantidad Reservada'													, ; //X3_DESCSPA
	'Allocated Quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC9'																	, ; //X3_ARQUIVO
	'44'																	, ; //X3_ORDEM
	'C9_QTDLIB2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt Liberada2'															, ; //X3_TITULO
	'Ctd.Aprobad2'															, ; //X3_TITSPA
	'Approv.Qty 2'															, ; //X3_TITENG
	'Quantidade Liberada 2Unid'												, ; //X3_DESCRIC
	'Cantidad Aprobada 2.UM'												, ; //X3_DESCSPA
	'Quantity Released 2nd'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCC
//
aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'CC_QINI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Inicio'															, ; //X3_TITULO
	'Ctd.Inicio'															, ; //X3_TITSPA
	'Initial qty.'															, ; //X3_TITENG
	'Quantidade Inicial'													, ; //X3_DESCRIC
	'Cantidad Inicial'														, ; //X3_DESCSPA
	'Initial quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo().And.A228Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'CC_QINI2UM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Ini 2aUM'															, ; //X3_TITULO
	'Ctd.Ini 2aUM'															, ; //X3_TITSPA
	'Ini.Qty2ndUM'															, ; //X3_TITENG
	'Quantidade Inicial 2aUM'												, ; //X3_DESCRIC
	'Cantidad Inicial 2aUM'													, ; //X3_DESCSPA
	'Initial quantity 2nd UofM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo().And.A228Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(190) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'CC_VINIFF1'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.1a M'															, ; //X3_TITULO
	'Cos.Ini.1a M'															, ; //X3_TITSPA
	'IniCost 1stC'															, ; //X3_TITENG
	'Custo Ini. na 1a. Moeda'												, ; //X3_DESCRIC
	'Costo Ini. en 1a. Moneda'												, ; //X3_DESCSPA
	'Initial cost in 2nd crcy'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(190) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'CC_VINIFF2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.2a M'															, ; //X3_TITULO
	'Cos.Ini.2a M'															, ; //X3_TITSPA
	'IniCost 2ndC'															, ; //X3_TITENG
	'Custo Ini. na 2a. Moeda'												, ; //X3_DESCRIC
	'Costo Ini. en 2a. Moneda'												, ; //X3_DESCSPA
	'Initial cost in 2nd crcy'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(190) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'CC_VINIFF3'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.3a M'															, ; //X3_TITULO
	'Cos.Ini.3a M'															, ; //X3_TITSPA
	'IniCost 3rdC'															, ; //X3_TITENG
	'Custo Ini. na 3a. Moeda'												, ; //X3_DESCRIC
	'Costo Ini. en 3a. Moned'												, ; //X3_DESCSPA
	'Initial cost in 3rd crcy'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'CC_VINIFF4'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.4a M'															, ; //X3_TITULO
	'Cos.Ini.4a M'															, ; //X3_TITSPA
	'IniCost 4thC'															, ; //X3_TITENG
	'Custo Ini. na 4a. Moeda'												, ; //X3_DESCRIC
	'Costo Ini. en 4a. Moneda'												, ; //X3_DESCSPA
	'Initial cost in 4th crcy'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'CC_VINIFF5'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Ini.5a M'															, ; //X3_TITULO
	'Cos.Ini.5a M'															, ; //X3_TITSPA
	'IniCost 5thC'															, ; //X3_TITENG
	'Custo Ini. na 5a. Moeda'												, ; //X3_DESCRIC
	'Costo Ini. en 5a. Moneda'												, ; //X3_DESCSPA
	'Initial cost in 5th crcy'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'CC_QFIM'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Final'																, ; //X3_TITULO
	'Ctd.Final'																, ; //X3_TITSPA
	'Final qty.'															, ; //X3_TITENG
	'Quantidade Final'														, ; //X3_DESCRIC
	'Cantidad Final'														, ; //X3_DESCSPA
	'Final quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo().And.A228Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'CC_QFIM2UM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Fin.2aUM'															, ; //X3_TITULO
	'Ctd.Fin.2aUM'															, ; //X3_TITSPA
	'End Qty2ndUM'															, ; //X3_TITENG
	'Quantidade Final 2aUM'													, ; //X3_DESCRIC
	'Cantidad Final 2aUM'													, ; //X3_DESCSPA
	'End quantity 2nd UofM'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo().And.A228Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'CC_VFIMFF1'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fin.1a M'															, ; //X3_TITULO
	'Cos.Fin.1a M'															, ; //X3_TITSPA
	'EndCost 1stC'															, ; //X3_TITENG
	'Custo Fin. na 1a. Moeda'												, ; //X3_DESCRIC
	'Costo Fin. en 1a. Moned'												, ; //X3_DESCSPA
	'End cost in 1st currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'CC_VFIMFF2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fin.2a M'															, ; //X3_TITULO
	'Cos.Fin.2a M'															, ; //X3_TITSPA
	'EndCost 2ndC'															, ; //X3_TITENG
	'Custo Fin. na 2a. Moeda'												, ; //X3_DESCRIC
	'Costo Fin. en 2a. Moneda'												, ; //X3_DESCSPA
	'End cost in 2nd currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'CC_VFIMFF3'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fin.3a M'															, ; //X3_TITULO
	'Cos.Fin.3a M'															, ; //X3_TITSPA
	'EndCost 3rdC'															, ; //X3_TITENG
	'Custo Fin. na 3a. Moeda'												, ; //X3_DESCRIC
	'Costo Fin. en 3a. Moneda'												, ; //X3_DESCSPA
	'End cost in 3rd currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'CC_VFIMFF4'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fin.4a M'															, ; //X3_TITULO
	'Cos.Fin.4a M'															, ; //X3_TITSPA
	'EndCost 4thC'															, ; //X3_TITENG
	'Custo Fin. na 4a. Moeda'												, ; //X3_DESCRIC
	'Costo Fin. en 4a. Moneda'												, ; //X3_DESCSPA
	'End cost in 4th currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCC'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'CC_VFIMFF5'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cus.Fin.5a M'															, ; //X3_TITULO
	'Cos.Fin.5a M'															, ; //X3_TITSPA
	'EndCost 5thC'															, ; //X3_TITENG
	'Custo Fin. na 5a. Moeda'												, ; //X3_DESCRIC
	'Costo Fin. en 5a. Moneda'												, ; //X3_DESCSPA
	'End cost in 5th currency'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCE
//
aAdd( aSX3, { ;
	'SCE'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'CE_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Entrega'															, ; //X3_TITULO
	'Ctd. Entrega'															, ; //X3_TITSPA
	'Qty Delivery'															, ; //X3_TITENG
	'Quantidade p/ Entrega'													, ; //X3_DESCRIC
	'Cantidad para Entregar'												, ; //X3_DESCSPA
	'Quantity for Delivery'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo() .And. A160Grade()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCI
//
aAdd( aSX3, { ;
	'SCI'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'CI_PRECO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Sugerido'															, ; //X3_TITULO
	'Prc.Sugerido'															, ; //X3_TITSPA
	'Sugg.Prc.'																, ; //X3_TITENG
	'Pre็o Sugerido'														, ; //X3_DESCRIC
	'Precio Sugerido'														, ; //X3_DESCSPA
	'Price Suggested'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'V'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SCK
//
aAdd( aSX3, { ;
	'SCK'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'CK_QTDVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Vendida'													, ; //X3_DESCRIC
	'Cantidad Vendida'														, ; //X3_DESCSPA
	'Quantity Sold'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. a415QtdVen()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCK'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'CK_PRCVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Unitario'															, ; //X3_TITULO
	'Prc.Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco Unitario Liquido'												, ; //X3_DESCRIC
	'Precio Unitario Neto'													, ; //X3_DESCSPA
	'Net Unit Price'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'a415PrcVen()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCK'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'CK_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Grand Total'															, ; //X3_TITENG
	'Valor Total do Item'													, ; //X3_DESCRIC
	'Valor Total del Item'													, ; //X3_DESCSPA
	'Item Grand Total'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCK'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'CK_PRUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Lista'																, ; //X3_TITULO
	'Precio Lista'															, ; //X3_TITSPA
	'Price List'															, ; //X3_TITENG
	'Preco Unitario de Tabela'												, ; //X3_DESCRIC
	'Precio Unitario de Tabla'												, ; //X3_DESCSPA
	'Unit List Price'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCL
//
aAdd( aSX3, { ;
	'SCL'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'CL_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Vendida'													, ; //X3_DESCRIC
	'Cantidad Vendida'														, ; //X3_DESCSPA
	'Quantity Sold'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A415SCLQtd()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCO
//
aAdd( aSX3, { ;
	'SCO'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'CO_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Amount'																, ; //X3_TITENG
	'Quantidade do produto'													, ; //X3_DESCRIC
	'Cantidad del producto'													, ; //X3_DESCSPA
	'Product Amt'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(134) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCO'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'CO_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor Total'															, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Valor Total'															, ; //X3_DESCRIC
	'Valor Total'															, ; //X3_DESCSPA
	'Total Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(134) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCP
//
aAdd( aSX3, { ;
	'SCP'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'CP_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da SA'														, ; //X3_DESCRIC
	'Cantidad de la RD'														, ; //X3_DESCSPA
	'SA Quantity'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo().And.A100Segum()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCP'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'CP_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Ctd. en Segunda Unidad'												, ; //X3_DESCSPA
	'Quantity in 2nd Unit Meas'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'(positivo().or.Vazio()).And.A100Segum()'								, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCP'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'CP_QUJE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant.Atend.'															, ; //X3_TITULO
	'Ctd.Atenc.'															, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Atandida'													, ; //X3_DESCRIC
	'Cantidad Atendida'														, ; //X3_DESCSPA
	'Delivered Quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCP'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'CP_SALBLQ'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Bloq.'															, ; //X3_TITULO
	'Saldo Bloq.'															, ; //X3_TITSPA
	'BlnceBlocked'															, ; //X3_TITENG
	'Saldo SA Bloqueado'													, ; //X3_DESCRIC
	'Saldo SA Bloqueado'													, ; //X3_DESCSPA
	'SA blocked balance'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCQ
//
aAdd( aSX3, { ;
	'SCQ'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'CQ_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da SA'														, ; //X3_DESCRIC
	'Cantidad de la RD'														, ; //X3_DESCSPA
	'Qty. of Warehouse Request'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCQ'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'CQ_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Ctd. en Segunda Unidad'												, ; //X3_DESCSPA
	'Qty 2nd Unit Measure'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'(positivo().or.Vazio()).And.A100Segum()'								, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(153) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCQ'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'CQ_QTDISP'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant.Disp.'															, ; //X3_TITULO
	'Cant.Disp.'															, ; //X3_TITSPA
	'Qty Availab.'															, ; //X3_TITENG
	'Quantidade Disponivel'													, ; //X3_DESCRIC
	'Cantidad Disponible'													, ; //X3_DESCSPA
	'Quantity on the Hand'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(153) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCR
//
aAdd( aSX3, { ;
	'SCR'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'CR_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor Total'															, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Grand Total'															, ; //X3_TITENG
	'Valor Total'															, ; //X3_DESCRIC
	'Valor Total'															, ; //X3_DESCSPA
	'Grand Total'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(160) + Chr(160) + Chr(160) + Chr(160) + Chr(160) + ;
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCS
//
aAdd( aSX3, { ;
	'SCS'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'CS_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo na Data'															, ; //X3_DESCRIC
	'Saldo en la Fecha'														, ; //X3_DESCSPA
	'Balance on Date'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCT
//
aAdd( aSX3, { ;
	'SCT'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'CT_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da Meta'													, ; //X3_DESCRIC
	'Cantidad de la Meta'													, ; //X3_DESCSPA
	'Target Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCW
//
aAdd( aSX3, { ;
	'SCW'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'CW_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo'																	, ; //X3_DESCRIC
	'Saldo'																	, ; //X3_DESCSPA
	'Balance'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SCY
//
aAdd( aSX3, { ;
	'SCY'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'CY_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade pedida'														, ; //X3_DESCRIC
	'Cantidad Pedida'														, ; //X3_DESCSPA
	'Loss Quantity'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo().And.A120Quant(M->CY_QUANT).And.MaFisRef("IT_QUANT","MT120",M->CY_QUANT).And.a120Tabela()', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCY'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'CY_PRECO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Unitario'															, ; //X3_TITULO
	'Prc.Unitario'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Preco unitario do item'												, ; //X3_DESCRIC
	'Precio Unitario del Item'												, ; //X3_DESCSPA
	'Unit Price of Item'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo().and.A120Preco(M->CY_PRECO).And.MaFisRef("IT_PRCUNI","MT120",M->CY_PRECO)', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCY'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'CY_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Valor total do item'													, ; //X3_DESCRIC
	'Valor Total del Item'													, ; //X3_DESCSPA
	'Item Total Value'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A120Total(M->CY_TOTAL).And.MaFisRef("IT_VALMERC","MT120",M->CY_TOTAL)'		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCY'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'CY_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd 2a. UM'															, ; //X3_TITSPA
	'2nd Unit Mea'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity in Second Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'(Positivo().or.Vazio()).and.A100Segum().And.a120Tabela()'				, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCY'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'CY_QUJE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Entregue'															, ; //X3_TITULO
	'Ctd. Entreg.'															, ; //X3_TITSPA
	'Qty.Delivery'															, ; //X3_TITENG
	"Quantidade ja' entregue"												, ; //X3_DESCRIC
	'Cantidad ya Entregada'													, ; //X3_DESCSPA
	'Qty already delivered'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCY'																	, ; //X3_ARQUIVO
	'51'																	, ; //X3_ORDEM
	'CY_QTDACLA'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.a Classi'															, ; //X3_TITULO
	'Ctd. p Clasi'															, ; //X3_TITSPA
	'Qty.to Class'															, ; //X3_TITENG
	'Qtde a Classificar'													, ; //X3_DESCRIC
	'Cantidad por Clasificar'												, ; //X3_DESCSPA
	'Quantity to Be Classified'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SCY'																	, ; //X3_ARQUIVO
	'61'																	, ; //X3_ORDEM
	'CY_QTDSOL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde da SC'															, ; //X3_TITULO
	'Ctd.de SC'																, ; //X3_TITSPA
	'Pur.Req.Qty'															, ; //X3_TITENG
	'Quantidade pedida da SC'												, ; //X3_DESCRIC
	'Cantidad pedida de SC'													, ; //X3_DESCSPA
	'Purchase Request Qty'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SD1
//
aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'D1_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade do Produto'													, ; //X3_DESCRIC
	'Cantidad del Producto'													, ; //X3_DESCSPA
	'Product Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A103TOLER().And.Positivo().And.A100SegUm().And.MaFisRef("IT_QUANT","MT100",M->D1_QUANT)', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'D1_VUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Unitario'															, ; //X3_TITULO
	'Valor Unit.'															, ; //X3_TITSPA
	'Unit Value'															, ; //X3_TITENG
	'Valor Unitario'														, ; //X3_DESCRIC
	'Valor Unitario'														, ; //X3_DESCSPA
	'Unit Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A103TOLER().And.NaoVazio().AND.Positivo().And.MaFisRef("IT_PRCUNI","MT100",M->D1_VUNIT)', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'D1_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Grand Total'															, ; //X3_TITENG
	'Valor Total'															, ; //X3_DESCRIC
	'Valor Total'															, ; //X3_DESCSPA
	'Grand Total'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A103Total(M->D1_TOTAL) .and. MaFisRef("IT_VALMERC","MT100",M->D1_TOTAL)'	, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'38'																	, ; //X3_ORDEM
	'D1_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde 2a UM'															, ; //X3_TITULO
	'Ctd 2a. UM'															, ; //X3_TITSPA
	'2nd.U. Meas.'															, ; //X3_TITENG
	'Segunda Unidade de Medida'												, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'2nd. Unit of Measure'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A100SegUm().and.positivo().or.vazio()'									, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'44'																	, ; //X3_ORDEM
	'D1_QTDEDEV'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde Devol.'															, ; //X3_TITULO
	'Ctd. Devuel.'															, ; //X3_TITSPA
	'Qty.Returned'															, ; //X3_TITENG
	'Qtde Devolvida'														, ; //X3_DESCRIC
	'Cantidad Devuelta'														, ; //X3_DESCSPA
	'Quantity Returned'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'B0'																	, ; //X3_ORDEM
	'D1_QTDPEDI'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde Pedido'															, ; //X3_TITULO
	'Ctd.Pedido'															, ; //X3_TITSPA
	'Qty Ordered'															, ; //X3_TITENG
	'Qtde em Pedido de Compras'												, ; //X3_DESCRIC
	'Ctd.en Pedido de Compras'												, ; //X3_DESCSPA
	'Purchase Order Quantity'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'D7'																	, ; //X3_ORDEM
	'D1_QTPCCEN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Vinc.PCC.'															, ; //X3_TITULO
	'Ct.Vinc.PCC.'															, ; //X3_TITSPA
	'Qt.Bind.PCC.'															, ; //X3_TITENG
	'Qt.Vinc.Ped.Compra Centr'												, ; //X3_DESCRIC
	'Ct.Vinc.Ped.Compra Centr'												, ; //X3_DESCSPA
	'Qty. Bind tp Central. Pur'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'K0'																	, ; //X3_ORDEM
	'D1_CUSRP4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.4a M'															, ; //X3_TITULO
	'C Repos.4a M'															, ; //X3_TITSPA
	'Repl.C.4th C'															, ; //X3_TITENG
	'Custo de Reposicao 4a M'												, ; //X3_DESCRIC
	'Costo de Reposicion 4a M'												, ; //X3_DESCSPA
	'Replenishment Cost 4th C'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'K5'																	, ; //X3_ORDEM
	'D1_CUSRP1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Reposicao'															, ; //X3_TITULO
	'C Reposicion'															, ; //X3_TITSPA
	'Replen. Cost'															, ; //X3_TITENG
	'Custo de Reposicao'													, ; //X3_DESCRIC
	'Costo de Reposicion'													, ; //X3_DESCSPA
	'Replenishment Cost'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'K7'																	, ; //X3_ORDEM
	'D1_CUSRP5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.5a M'															, ; //X3_TITULO
	'C Repos.5a M'															, ; //X3_TITSPA
	'Repl.C.5th C'															, ; //X3_TITENG
	'Custo de Reposicao 5a M'												, ; //X3_DESCRIC
	'Costo de Reposicion 5a M'												, ; //X3_DESCSPA
	'Replenishment Cost 5th C.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD1'																	, ; //X3_ARQUIVO
	'M2'																	, ; //X3_ORDEM
	'D1_CUSRP3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.3a M'															, ; //X3_TITULO
	'C Repos.3a M'															, ; //X3_TITSPA
	'Repl.C.3rd C'															, ; //X3_TITENG
	'Custo de Reposicao 3a M'												, ; //X3_DESCRIC
	'Costo de Reposicion 3a M'												, ; //X3_DESCSPA
	'Replenishment Cost 3rd C'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SD2
//
aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'D2_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade do Produto'													, ; //X3_DESCRIC
	'Cantidad del Producto'													, ; //X3_DESCSPA
	'Product Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo().and. A100SegUm().And.MaFisRef("IT_QUANT","MT100",M->D2_QUANT)'	, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'D2_PRCVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Unitario'															, ; //X3_TITULO
	'Valor Unit.'															, ; //X3_TITSPA
	'Unit Value'															, ; //X3_TITENG
	'Valor Unitario'														, ; //X3_DESCRIC
	'Valor Unitario'														, ; //X3_DESCSPA
	'Unit Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'NaoVazio().And.MaFisRef("IT_PRCUNI","MT100",M->D2_PRCVEN)'				, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'D2_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Grand Total'															, ; //X3_TITENG
	'Valor Total'															, ; //X3_DESCRIC
	'Valor Total'															, ; //X3_DESCSPA
	'Grand Total'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A920Total(M->D2_TOTAL) .and. MaFisRef("IT_VALMERC","MT100",M->D2_TOTAL)'	, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'D2_CUSTO1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Custo'																	, ; //X3_TITULO
	'Costo'																	, ; //X3_TITSPA
	'Cost'																	, ; //X3_TITENG
	'Custo'																	, ; //X3_DESCRIC
	'Costo'																	, ; //X3_DESCSPA
	'Cost'																	, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'35'																	, ; //X3_ORDEM
	'D2_PRUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Prc Tabela'															, ; //X3_TITULO
	'Precio Tabla'															, ; //X3_TITSPA
	'Price List'															, ; //X3_TITENG
	'Preco de Tabela'														, ; //X3_DESCRIC
	'Precio de Tabla'														, ; //X3_DESCSPA
	'Table Price'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'36'																	, ; //X3_ORDEM
	'D2_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde 2a UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Unit Mea'															, ; //X3_TITENG
	'Segunda Unidade de Medida'												, ; //X3_DESCRIC
	'Segunda Unidad de Medida'												, ; //X3_DESCSPA
	'2nd. Unit of Measure'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'43'																	, ; //X3_ORDEM
	'D2_QTDEDEV'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde Devol.'															, ; //X3_TITULO
	'Ctd. Devuel.'															, ; //X3_TITSPA
	'Qty.Returned'															, ; //X3_TITENG
	'Qtde Devolvida'														, ; //X3_DESCRIC
	'Cantidad Devuelta'														, ; //X3_DESCSPA
	'Quantity Returned'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'C5'																	, ; //X3_ORDEM
	'D2_VARPRUN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Var.Prc.Unit'															, ; //X3_TITULO
	'Var.Prc.Unit'															, ; //X3_TITSPA
	'Un.pr.var.'															, ; //X3_TITENG
	'Variacao do Preco Unit.'												, ; //X3_DESCRIC
	'Variacion del Precio Unit'												, ; //X3_DESCSPA
	'Unit price variation'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'D0'																	, ; //X3_ORDEM
	'D2_QTDEFAT'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	16																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant.Fatur.'															, ; //X3_TITULO
	'Cantidad Fac'															, ; //X3_TITSPA
	'Quant.Invoic'															, ; //X3_TITENG
	'Quantidade ja faturada'												, ; //X3_DESCRIC
	'Cantidad ya Facturada'													, ; //X3_DESCSPA
	'Quantity Invoiced'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'D1'																	, ; //X3_ORDEM
	'D2_QTDAFAT'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	16																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant. a Fat'															, ; //X3_TITULO
	'Cant. a Fac.'															, ; //X3_TITSPA
	'Qty to Inv.'															, ; //X3_TITENG
	'Quantidade a faturar'													, ; //X3_DESCRIC
	'Cantidad a Facturar'													, ; //X3_DESCSPA
	'Quantity to Be Invoiced'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'D9'																	, ; //X3_ORDEM
	'D2_CUSRP1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Reposicao'															, ; //X3_TITULO
	'C Reposic.'															, ; //X3_TITSPA
	'Replac.Cost'															, ; //X3_TITENG
	'Custo de Reposicao'													, ; //X3_DESCRIC
	'Costo de Reposicion'													, ; //X3_DESCSPA
	'Replacem. Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'E0'																	, ; //X3_ORDEM
	'D2_CUSRP2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.2a M'															, ; //X3_TITULO
	'C Repos.2a M'															, ; //X3_TITSPA
	'Rep.C.2ndM'															, ; //X3_TITENG
	'Custo de Reposicao 2a M'												, ; //X3_DESCRIC
	'Costo de Repos. 2a Mon.'												, ; //X3_DESCSPA
	'Replacem. Cost 2nd M'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'E1'																	, ; //X3_ORDEM
	'D2_CUSRP3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.3a M'															, ; //X3_TITULO
	'C Repos.3a M'															, ; //X3_TITSPA
	'Rep.C.3rdM'															, ; //X3_TITENG
	'Custo de Reposicao 3a M'												, ; //X3_DESCRIC
	'Costo de Repos. 3a Mon.'												, ; //X3_DESCSPA
	'Replacem. Cost 3rd M'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'E2'																	, ; //X3_ORDEM
	'D2_CUSRP4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.4a M'															, ; //X3_TITULO
	'C Repos.4a M'															, ; //X3_TITSPA
	'Rep.C.4thM'															, ; //X3_TITENG
	'Custo de Reposicao 4a M'												, ; //X3_DESCRIC
	'Costo de Repos. 4a Mon.'												, ; //X3_DESCSPA
	'Replacem. Cost 4th M'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'E3'																	, ; //X3_ORDEM
	'D2_CUSRP5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.5a M'															, ; //X3_TITULO
	'C Repos.5a M'															, ; //X3_TITSPA
	'Rep.C.5thM'															, ; //X3_TITENG
	'Custo de Reposicao 5a M'												, ; //X3_DESCRIC
	'Costo de Reposic. 5a M'												, ; //X3_DESCSPA
	'Replacem. Cost 5th M'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD2'																	, ; //X3_ARQUIVO
	'F6'																	, ; //X3_ORDEM
	'D2_PRUNDA'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Unit DA'															, ; //X3_TITULO
	'Val Unit DA'															, ; //X3_TITSPA
	'DA UnitValue'															, ; //X3_TITENG
	'Valor Unitario D. A.'													, ; //X3_DESCRIC
	'Valor Unitario D. A.'													, ; //X3_DESCSPA
	'D.A. unit value'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SD3
//
aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'D3_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Amount'																, ; //X3_TITENG
	'Quantidade do Movimento'												, ; //X3_DESCRIC
	'Cantidad del Movimiento'												, ; //X3_DESCSPA
	'Transaction Amt'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A240Quant()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'D3_CUSTO1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Custo'																	, ; //X3_TITULO
	'Costo'																	, ; //X3_TITSPA
	'Cost'																	, ; //X3_TITENG
	'Custo'																	, ; //X3_DESCRIC
	'Costo'																	, ; //X3_DESCSPA
	'Cost'																	, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'A240Custo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'D3_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a UM'															, ; //X3_TITSPA
	'Amt 2nd Unt'															, ; //X3_TITENG
	'Qtde na Segunda Unidade'												, ; //X3_DESCRIC
	'Cant en la Segunda Unidad'												, ; //X3_DESCSPA
	'Amt in Second Unit'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'AQtdGrade().And.A240PriUm()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'65'																	, ; //X3_ORDEM
	'D3_CUSRP1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Reposicao'															, ; //X3_TITULO
	'C Reposicion'															, ; //X3_TITSPA
	'Replen Cost'															, ; //X3_TITENG
	'Custo de Reposicao'													, ; //X3_DESCRIC
	'Costo de Reposicion'													, ; //X3_DESCSPA
	'Replenishment Cost'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'66'																	, ; //X3_ORDEM
	'D3_CUSRP2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.2a M'															, ; //X3_TITULO
	'C Repos.2a M'															, ; //X3_TITSPA
	'Repl.C.2nd C'															, ; //X3_TITENG
	'Custo de Reposicao 2a M'												, ; //X3_DESCRIC
	'Costo de Reposicion 2a M'												, ; //X3_DESCSPA
	'Replenishment Cost 2nd C'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'67'																	, ; //X3_ORDEM
	'D3_CUSRP3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.3a M'															, ; //X3_TITULO
	'C Repos.3a M'															, ; //X3_TITSPA
	'Repl.C.3rd C'															, ; //X3_TITENG
	'Custo de Reposicao 3a M'												, ; //X3_DESCRIC
	'Costo de Reposicion 3a M'												, ; //X3_DESCSPA
	'Replenishment Cost 3rd C'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'68'																	, ; //X3_ORDEM
	'D3_CUSRP4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.4a M'															, ; //X3_TITULO
	'C Repos.4a M'															, ; //X3_TITSPA
	'Repl.C.4th C'															, ; //X3_TITENG
	'Custo de Reposicao 4a M'												, ; //X3_DESCRIC
	'Costo de Reposicion 4a M'												, ; //X3_DESCSPA
	'Replenishment Cost 4th C'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'69'																	, ; //X3_ORDEM
	'D3_CUSRP5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C Repos.5a M'															, ; //X3_TITULO
	'C Repos.5a M'															, ; //X3_TITSPA
	'Repl.C.5th C'															, ; //X3_TITENG
	'Custo de Reposicao 5a M'												, ; //X3_DESCRIC
	'Costo de Reposicion 5a M'												, ; //X3_DESCSPA
	'Replenishment Cost 5th C.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD3'																	, ; //X3_ARQUIVO
	'77'																	, ; //X3_ORDEM
	'D3_CMFIXO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Cst.Fixo'																, ; //X3_TITULO
	'Cst.Fijo'																, ; //X3_TITSPA
	'Fixed Cost'															, ; //X3_TITENG
	'Custo Unitario Fixo'													, ; //X3_DESCRIC
	'Costo Unitario Fijo'													, ; //X3_DESCSPA
	'Fixed Unit Cost'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SD4
//
aAdd( aSX3, { ;
	'SD4'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'D4_QSUSP'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Suspensa'															, ; //X3_TITULO
	'Ctd.Suspensa'															, ; //X3_TITSPA
	'Held Qty.'																, ; //X3_TITENG
	'Quantidade suspensa'													, ; //X3_DESCRIC
	'Cantidad Suspensa'														, ; //X3_DESCSPA
	'Quantity Interrupted'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD4'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'D4_QTDEORI'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Empenho'															, ; //X3_TITULO
	'Ctd. Empeno'															, ; //X3_TITSPA
	'Alloc.Qty.'															, ; //X3_TITENG
	'Quantidade Empenhada'													, ; //X3_DESCRIC
	'Cantidad Empenada'														, ; //X3_DESCSPA
	'Allocation Quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A380Quant() .AND. A380PRIUM()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD4'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'D4_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Sal. Empenho'															, ; //X3_TITULO
	'Sal. Empeno'															, ; //X3_TITSPA
	'Alloc.Blc.'															, ; //X3_TITENG
	'Saldo da Qtd. Empenhada'												, ; //X3_DESCRIC
	'Saldo de la Ctd. Empenada'												, ; //X3_DESCSPA
	'Allocated Balance'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A380Quant()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD4'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'D4_SLDEMP'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Sal. Empenho'															, ; //X3_TITULO
	'Sal. Empeno'															, ; //X3_TITSPA
	'Alloc. Bal.'															, ; //X3_TITENG
	'Saldo Qtde. Empenhada'													, ; //X3_DESCRIC
	'Saldo Cant. Empenada'													, ; //X3_DESCSPA
	'Allocated Qty. Balance'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD4'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'D4_EMPROC'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Processo'															, ; //X3_TITULO
	'Ctd Proceso'															, ; //X3_TITSPA
	'Process Qty'															, ; //X3_TITENG
	'Quantidade em Processo'												, ; //X3_DESCRIC
	'Cantidad en Proceso'													, ; //X3_DESCSPA
	'Amount under process'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(134) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SD5
//
aAdd( aSX3, { ;
	'SD5'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'D5_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A390QUANT()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD5'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'D5_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Unit Mea'															, ; //X3_TITENG
	'Quantidade 2a UM'														, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity in 2nd Meas.Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A390QTSEG()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SD6
//
aAdd( aSX3, { ;
	'SD6'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'D6_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Contratada'													, ; //X3_DESCRIC
	'Cantidad Contratada'													, ; //X3_DESCSPA
	'Quantity Contracted'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD6'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'D6_VRUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor Unit.'															, ; //X3_TITULO
	'Valor Unit.'															, ; //X3_TITSPA
	'Unit Value'															, ; //X3_TITENG
	'Valor Unitario'														, ; //X3_DESCRIC
	'Valor Unitario'														, ; //X3_DESCSPA
	'Unit Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SD7
//
aAdd( aSX3, { ;
	'SD7'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'D7_QTDE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Inicial'													, ; //X3_DESCRIC
	'Cantidad Inicial'														, ; //X3_DESCSPA
	'Initial Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A175Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD7'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'D7_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo'																	, ; //X3_DESCRIC
	'Saldo'																	, ; //X3_DESCSPA
	'Balance'																, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD7'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'D7_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd 2a UM'																, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Unit Mea'															, ; //X3_TITENG
	'Quantidade Inicial 2a UM'												, ; //X3_DESCRIC
	'Cantidad Inicial 2a. UM'												, ; //X3_DESCSPA
	'Beginn. Quantity 2 U.M.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'A175QUANT().And.Positivo()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD7'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'D7_SALDO2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo 2a UM'															, ; //X3_TITULO
	'Saldo 2a. UM'															, ; //X3_TITSPA
	'Balance 2UM'															, ; //X3_TITENG
	'Saldo 2a UM'															, ; //X3_DESCRIC
	'Saldo 2a. UM'															, ; //X3_DESCSPA
	'Balance 2nd Unit of Meas.'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SD8
//
aAdd( aSX3, { ;
	'SD8'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'D8_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD8'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'D8_QT2UM'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant. 2 UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Unit Mea'															, ; //X3_TITENG
	'Quantidade 2 UM'														, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity 2nd Unit Meas.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD8'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'D8_CUSTO1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Custo'																	, ; //X3_TITULO
	'Costo 1a.Mon'															, ; //X3_TITSPA
	'Cost'																	, ; //X3_TITENG
	'Custo na 1a Moeda'														, ; //X3_DESCRIC
	'Costo en la 1a. Moneda'												, ; //X3_DESCSPA
	'Cost in 1st Currency'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(146) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD8'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'D8_QTDDEV'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant. Dev.'															, ; //X3_TITULO
	'Ctd. Devuel.'															, ; //X3_TITSPA
	'Returned Qty'															, ; //X3_TITENG
	'Quantidade Devolvida'													, ; //X3_DESCRIC
	'Cantidades Devueltas'													, ; //X3_DESCSPA
	'Quantity Returned'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(146) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD8'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'D8_QFIMDEV'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Devoluca'															, ; //X3_TITULO
	'Ctd.Devoluc.'															, ; //X3_TITSPA
	'Return qty.'															, ; //X3_TITENG
	'Qtd.Devolucao Final'													, ; //X3_DESCRIC
	'Ctd.Devolucion Final'													, ; //X3_DESCSPA
	'Final return quantity'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SD8'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'D8_SD1DEV'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde NF Orig'															, ; //X3_TITULO
	'Ctd. Fac.Or.'															, ; //X3_TITSPA
	'Src.Inv.Qty.'															, ; //X3_TITENG
	'Qtde Devevolucao NF Orig.'												, ; //X3_DESCRIC
	'Ctd. Devol.Fac.Orig.'													, ; //X3_DESCSPA
	'Src.Inv.Return Qty.'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDA
//
aAdd( aSX3, { ;
	'SDA'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'DA_QTDORI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Original'															, ; //X3_TITULO
	'Ctd.Original'															, ; //X3_TITSPA
	'Original Qty'															, ; //X3_TITENG
	'Qtd Original a Distribuir'												, ; //X3_DESCRIC
	'Ctd.Original por Distribu'												, ; //X3_DESCSPA
	'Orig. Quant.to Distribute'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(172) + Chr(213) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(139) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(136)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(134) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDA'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'DA_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo a Distribuir'													, ; //X3_DESCRIC
	'Saldo a Distribuir'													, ; //X3_DESCSPA
	'Balance to Distribute'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(172) + Chr(213) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(139) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(136)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(134) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDA'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'DA_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo 2a UM'															, ; //X3_TITULO
	'Saldo 2a UM'															, ; //X3_TITSPA
	'Balance 2 UM'															, ; //X3_TITENG
	'Saldo a Distribuir 2a UM'												, ; //X3_DESCRIC
	'Saldo a Distribuir 2a UM'												, ; //X3_DESCSPA
	'Bal.to Distribute 2nd UOM'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(172) + Chr(213) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(139) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(136)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDA'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'DA_QTDORI2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Ori 2aUM'															, ; //X3_TITULO
	'Ctd.Ori.2aUM'															, ; //X3_TITSPA
	'Original Qty'															, ; //X3_TITENG
	'Qtd Original 2a UM'													, ; //X3_DESCRIC
	'Ctd. Original 2a UM'													, ; //X3_DESCSPA
	'Origin.Quant.2nd Un.Meas.'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(172) + Chr(213) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(139) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(136)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDB
//
aAdd( aSX3, { ;
	'SDB'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'DB_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Distribu'															, ; //X3_TITULO
	'Ctd.Distrib.'															, ; //X3_TITSPA
	'Distr. Qty.'															, ; //X3_TITENG
	'Qtd Distribuida'														, ; //X3_DESCRIC
	'Cantidad Distribuida'													, ; //X3_DESCSPA
	'Quantity Distributed'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A265QSegum()'											, ; //X3_VALID
	Chr(172) + Chr(213) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(139) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDB'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'DB_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Unit Mea'															, ; //X3_TITENG
	'Quantidade 2a UM'														, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity in 2nd Meas.Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A265QSegum()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDB'																	, ; //X3_ARQUIVO
	'59'																	, ; //X3_ORDEM
	'DB_QTDORI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Original'															, ; //X3_TITULO
	'Ctd.Original'															, ; //X3_TITSPA
	'OriginalQty.'															, ; //X3_TITENG
	'Quantidade Original'													, ; //X3_DESCRIC
	'Cantidad Original'														, ; //X3_DESCSPA
	'Original Amount'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDC
//
aAdd( aSX3, { ;
	'SDC'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'DC_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da Composicao'												, ; //X3_DESCRIC
	'Cantidad de Composicion'												, ; //X3_DESCSPA
	'Quantity of composition'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(152) + Chr(152) + Chr(132) + Chr(128) + Chr(128) + ;
	Chr(129) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDC'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'DC_QTDORIG'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Original'															, ; //X3_TITULO
	'Ctd.Original'															, ; //X3_TITSPA
	'Original Qty'															, ; //X3_TITENG
	'Quantidade Original'													, ; //X3_DESCRIC
	'Cantidad Original'														, ; //X3_DESCSPA
	'Original Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(144) + Chr(136) + Chr(132) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDC'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'DC_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Unit Mea'															, ; //X3_TITENG
	'Quantidade 2a UM'														, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity in 2nd Meas.Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDD
//
aAdd( aSX3, { ;
	'SDD'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'DD_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade Movimentada'												, ; //X3_DESCRIC
	'Cantidad Movida'														, ; //X3_DESCSPA
	'Quantity Moved'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A275Quant()'											, ; //X3_VALID
	Chr(172) + Chr(212) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDD'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'DD_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo do Bloqueio'														, ; //X3_DESCRIC
	'Saldo del Bloqueo'														, ; //X3_DESCSPA
	'Blocked Balance'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(212) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDD'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'DD_QTDORIG'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Orig.'															, ; //X3_TITULO
	'Ctd.Original'															, ; //X3_TITSPA
	'Original Qty'															, ; //X3_TITENG
	'Qtd. Original do Bloqueio'												, ; //X3_DESCRIC
	'Ctd. Original del Bloqueo'												, ; //X3_DESCSPA
	'Original Quant.Blockage'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(172) + Chr(212) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDD'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'DD_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. 2a UM'															, ; //X3_TITULO
	'Ctd. 2a. UM'															, ; //X3_TITSPA
	'2nd.Unit Mea'															, ; //X3_TITENG
	'Quantidade 2a UM'														, ; //X3_DESCRIC
	'Cantidad 2a.Unidad Medida'												, ; //X3_DESCSPA
	'Quantity in 2nd Meas.Unit'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A275Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDD'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'DD_SALDO2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo 2a UM'															, ; //X3_TITULO
	'Saldo 2a UM'															, ; //X3_TITSPA
	'Balance 2SU'															, ; //X3_TITENG
	'Saldo do Bloqueio 2a UM'												, ; //X3_DESCRIC
	'Saldo del Bloqueo 2a UM'												, ; //X3_DESCSPA
	'Blocked Balance 2nd UM'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(172) + Chr(212) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(240) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDF
//
aAdd( aSX3, { ;
	'SDF'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'DF_QTDSUG'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Sugerida'															, ; //X3_TITULO
	'Ctd Sugerida'															, ; //X3_TITSPA
	'Qty Suggest.'															, ; //X3_TITENG
	'Quantidade Sugerida'													, ; //X3_DESCRIC
	'Cantidad Sugerida'														, ; //X3_DESCSPA
	'Quantity Suggested'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(250) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDF'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'DF_QTDINF'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Infor.'															, ; //X3_TITULO
	'Ctd. Inform.'															, ; //X3_TITSPA
	'Qty Informed'															, ; //X3_TITENG
	'Quantidade Informada'													, ; //X3_DESCRIC
	'Cantidad Informada'													, ; //X3_DESCSPA
	'Quantity Informed'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(250) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDF'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'DF_VLRTOT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor Total'															, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Grand Total'															, ; //X3_TITENG
	'Valor Total do Item'													, ; //X3_DESCRIC
	'Valor Total del Item'													, ; //X3_DESCSPA
	'Item Grand Total'														, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(250) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDG
//
aAdd( aSX3, { ;
	'SDG'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'DG_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor Total'															, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Valor Total do Movimento'												, ; //X3_DESCRIC
	'Valor Total del Movimient'												, ; //X3_DESCSPA
	'Transaction Total Value'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo() .And. TMSA070Val()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'TMSA070Whn()'															, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDG'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'DG_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo'																	, ; //X3_DESCRIC
	'Saldo'																	, ; //X3_DESCSPA
	'Balance'																, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'TMSA070Whn()'															, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SDH
//
aAdd( aSX3, { ;
	'SDH'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'DH_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDH'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'DH_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo'																	, ; //X3_DESCRIC
	'Saldo'																	, ; //X3_DESCSPA
	'Balance'																, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDH'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'DH_QTDNF'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd Doc.Entr'															, ; //X3_TITULO
	'Cant. Doc.En'															, ; //X3_TITSPA
	'Qty Doc Entr'															, ; //X3_TITENG
	'Quantidade do Documento'												, ; //X3_DESCRIC
	'Cantidad de Documento'													, ; //X3_DESCSPA
	'Document Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'V'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SDL
//
aAdd( aSX3, { ;
	'SDL'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'DL_CANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant'																	, ; //X3_TITULO
	'Cantid'																, ; //X3_TITSPA
	'Amount'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Amount'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(215) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDN
//
aAdd( aSX3, { ;
	'SDN'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'DN_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quant.'																, ; //X3_TITULO
	'Cant.'																	, ; //X3_TITSPA
	'Amt'																	, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Amount'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(199) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SDP
//
aAdd( aSX3, { ;
	'SDP'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'DP_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Prevista'															, ; //X3_TITULO
	'Cant.Previst'															, ; //X3_TITSPA
	'Amt.Estimat.'															, ; //X3_TITENG
	'Quantidade Prevista'													, ; //X3_DESCRIC
	'Cantidad Prevista'														, ; //X3_DESCSPA
	'Amount Estimated'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDP'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'DP_QTDENT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd.Entregue'															, ; //X3_TITULO
	'Cant.Entreg.'															, ; //X3_TITSPA
	'Amt.Deliver.'															, ; //X3_TITENG
	'Quantidade Entregue'													, ; //X3_DESCRIC
	'Cantidad Entregada'													, ; //X3_DESCSPA
	'Amount Delivered'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SDQ
//
aAdd( aSX3, { ;
	'SDQ'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'DQ_CM1'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C.Unitario'															, ; //X3_TITULO
	'C.Unitario'															, ; //X3_TITSPA
	'Unit Cost'																, ; //X3_TITENG
	'Custo Unitario 1a Moeda'												, ; //X3_DESCRIC
	'Costo Unitario 1a Moneda'												, ; //X3_DESCSPA
	'1st Currency Unit Cost'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDQ'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'DQ_CM2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C.Unit.2a M'															, ; //X3_TITULO
	'C.Unit.2a M'															, ; //X3_TITSPA
	'Un.C.2nd.Cur'															, ; //X3_TITENG
	'Custo Unitario 2a Moeda'												, ; //X3_DESCRIC
	'Costo Unitario 2a Moneda'												, ; //X3_DESCSPA
	'2nd Currency Unit Cost'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDQ'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'DQ_CM3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C.Unit.3a M'															, ; //X3_TITULO
	'C.Unit.3a M'															, ; //X3_TITSPA
	'Un.C.3rd.Cur'															, ; //X3_TITENG
	'Custo Unitario 3a Moeda'												, ; //X3_DESCRIC
	'Costo Unitario 3a Moneda'												, ; //X3_DESCSPA
	'3rd Currency Unit Cost'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDQ'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'DQ_CM4'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C.Unit.4a M'															, ; //X3_TITULO
	'C.Unit.4a M'															, ; //X3_TITSPA
	'Un.C.4th Cur'															, ; //X3_TITENG
	'Custo Unitario 4a Moeda'												, ; //X3_DESCRIC
	'Costo Unitario 4a Moneda'												, ; //X3_DESCSPA
	'4th Currency Unit Cost'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDQ'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'DQ_CM5'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'C.Unit. 5a M'															, ; //X3_TITULO
	'C.Unit. 5a M'															, ; //X3_TITSPA
	'Un.C.5th Cur'															, ; //X3_TITENG
	'Custo Unitario 5a Moeda'												, ; //X3_DESCRIC
	'Costo Unitario 5a Moneda'												, ; //X3_DESCSPA
	'5th Currency Unit Cost'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SDT
//
aAdd( aSX3, { ;
	'SDT'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'DT_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade do Produto'													, ; //X3_DESCRIC
	'Cantidad del Producto'													, ; //X3_DESCSPA
	'Product Quantity'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDT'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'DT_VUNIT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Unitario'															, ; //X3_TITULO
	'Vlr.Unitario'															, ; //X3_TITSPA
	'Unit Value'															, ; //X3_TITENG
	'Valor Unitario'														, ; //X3_DESCRIC
	'Valor Unitario'														, ; //X3_DESCSPA
	'Unit Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SDT'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'DT_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr.Total'																, ; //X3_TITULO
	'Vlr.Total'																, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Valor Total'															, ; //X3_DESCRIC
	'Valor Total'															, ; //X3_DESCSPA
	'Total Value'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SDY
//
aAdd( aSX3, { ;
	'SDY'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'DY_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor'																	, ; //X3_TITULO
	'Valor'																	, ; //X3_TITSPA
	'Value'																	, ; //X3_TITENG
	'Valor'																	, ; //X3_DESCRIC
	'Valor'																	, ; //X3_DESCSPA
	'Value'																	, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(150) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SF2
//
aAdd( aSX3, { ;
	'SF2'																	, ; //X3_ARQUIVO
	'50'																	, ; //X3_ORDEM
	'F2_VARIAC'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Variacao'																, ; //X3_TITULO
	'Variacion'																, ; //X3_TITSPA
	'Variation'																, ; //X3_TITENG
	'Variacao'																, ; //X3_DESCRIC
	'Variacion'																, ; //X3_DESCSPA
	'Variation'																, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SFA
//
aAdd( aSX3, { ;
	'SFA'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'FA_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor'																	, ; //X3_TITULO
	'Valor'																	, ; //X3_TITSPA
	'Value'																	, ; //X3_TITENG
	'Valor de Apropriacao'													, ; //X3_DESCRIC
	'Valor de Apropiacion'													, ; //X3_DESCSPA
	'Appropriation Value'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SFA'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'FA_TOTTRIB'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Tot Trib'															, ; //X3_TITULO
	'Vlr Tot Trib'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Vlr Tot Trib'															, ; //X3_DESCRIC
	'Vlr Tot Trib'															, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(198) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SFA'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'FA_TOTSAI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vlr Total'																, ; //X3_TITULO
	'Vlr Total'																, ; //X3_TITSPA
	'Grand Total'															, ; //X3_TITENG
	'Vlr Total'																, ; //X3_DESCRIC
	'Vlr Total'																, ; //X3_DESCSPA
	'Grand Total'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(198) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SFE
//
aAdd( aSX3, { ;
	'SFE'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'FE_VALBASE'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Valor Base'															, ; //X3_TITULO
	'Valor Base'															, ; //X3_TITSPA
	'Base  Value'															, ; //X3_TITENG
	'Valor Base Disponivel'													, ; //X3_DESCRIC
	'Valor Base Disponible'													, ; //X3_DESCSPA
	'Available Base Value'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(144) + Chr(136) + Chr(132) + Chr(130) + Chr(129) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(147) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SFK
//
aAdd( aSX3, { ;
	'SFK'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'FK_QTDE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(130) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SFN
//
aAdd( aSX3, { ;
	'SFN'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'FN_QTDE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(135) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SFO
//
aAdd( aSX3, { ;
	'SFO'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'FO_SALDO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo'																	, ; //X3_TITULO
	'Saldo'																	, ; //X3_TITSPA
	'Balance'																, ; //X3_TITENG
	'Saldo da Guia'															, ; //X3_DESCRIC
	'Saldo de la Guia'														, ; //X3_DESCSPA
	'Delivery Bill Balance'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SFO'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'FO_SALDATU'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Atual'															, ; //X3_TITULO
	'Saldo Actual'															, ; //X3_TITSPA
	'Cur. Bal.'																, ; //X3_TITENG
	'Saldo Atual da Guia'													, ; //X3_DESCRIC
	'Saldo Actual de la Guia'												, ; //X3_DESCSPA
	'Del. Bill Cur. Balance'												, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SFQ
//
aAdd( aSX3, { ;
	'SFQ'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'FQ_SABTPIS'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Ab.PIS'															, ; //X3_TITULO
	'Saldo Ds.PIS'															, ; //X3_TITSPA
	'Blc PIS'																, ; //X3_TITENG
	'Saldo a abater - PIS'													, ; //X3_DESCRIC
	'Saldo Descontar - PIS'													, ; //X3_DESCSPA
	'Blc.to disc. - PIS'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	'1'																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SFQ'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'FQ_SABTCSL'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Ab.CSL'															, ; //X3_TITULO
	'Saldo Ds.CSL'															, ; //X3_TITSPA
	'Blc.CSLL'																, ; //X3_TITENG
	'Saldo a abater - CSLL'													, ; //X3_DESCRIC
	'Saldo Descontar - CSLL'												, ; //X3_DESCSPA
	'Blc.to disc. - CSLL'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	'1'																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SFQ'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'FQ_SABTCOF'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Saldo Ab.COF'															, ; //X3_TITULO
	'Saldo Ds.COF'															, ; //X3_TITSPA
	'Balc.COF'																, ; //X3_TITENG
	'Saldo a abater - Cofins'												, ; //X3_DESCRIC
	'Saldo Descontar - Cofins'												, ; //X3_DESCSPA
	'Blc.to disc. - COFINS'													, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	'1'																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(128) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SFT
//
aAdd( aSX3, { ;
	'SFT'																	, ; //X3_ARQUIVO
	'89'																	, ; //X3_ORDEM
	'FT_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	16																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade do item'													, ; //X3_DESCRIC
	'Cantidad de items'														, ; //X3_DESCSPA
	'Item Quantity'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SFT'																	, ; //X3_ARQUIVO
	'90'																	, ; //X3_ORDEM
	'FT_PRCUNIT'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Pre็o Unit.'															, ; //X3_TITULO
	'Precio Unit.'															, ; //X3_TITSPA
	'Unit Price'															, ; //X3_TITENG
	'Pre็o Unitแrio'														, ; //X3_DESCRIC
	'Precio Unitแrio'														, ; //X3_DESCSPA
	'Unit Price'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(148) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SFT'																	, ; //X3_ARQUIVO
	'92'																	, ; //X3_ORDEM
	'FT_TOTAL'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	16																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Vlr Total'																, ; //X3_TITULO
	'Vlr Total'																, ; //X3_TITSPA
	'Total Value'															, ; //X3_TITENG
	'Vlr Total Item'														, ; //X3_DESCRIC
	'Vlr Total Item'														, ; //X3_DESCSPA
	'Item Total Value'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SFW
//
aAdd( aSX3, { ;
	'SFW'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'FW_TOTRET'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Vl. Disp'																, ; //X3_TITULO
	'Vl. Disp'																, ; //X3_TITSPA
	'Avail.Value'															, ; //X3_TITENG
	'Valor'																	, ; //X3_DESCRIC
	'Valor'																	, ; //X3_DESCSPA
	'Value'																	, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SG1
//
aAdd( aSX3, { ;
	'SG1'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'G1_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'NaoVazio().And.If(ModType(nModulo)=="I",AVMA200QUANT(M->G1_QUANT,M->G1_COMP),MA200Quant(M->G1_QUANT,M->G1_COMP))', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(155) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SG4
//
aAdd( aSX3, { ;
	'SG4'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'G4_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(158) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SG7
//
aAdd( aSX3, { ;
	'SG7'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'G7_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SGA
//
aAdd( aSX3, { ;
	'SGA'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'GA_PRCVEN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	18																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Preco Venda'															, ; //X3_TITULO
	'Precio Venta'															, ; //X3_TITSPA
	'Sales Price'															, ; //X3_TITENG
	'Preco de Venda'														, ; //X3_DESCRIC
	'Precio de Venta'														, ; //X3_DESCSPA
	'Sale Price'															, ; //X3_DESCENG
	'@E 99,999,999,999.999999'												, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SGB
//
aAdd( aSX3, { ;
	'SGB'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'GB_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(132) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SGG
//
aAdd( aSX3, { ;
	'SGG'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'GG_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Quantity'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'NaoVazio().And.If(ModType(nModulo)=="I",AVMA202QUANT(M->GG_QUANT,M->GG_COMP),MA202Quant(M->GG_QUANT,M->GG_COMP))', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SGJ
//
aAdd( aSX3, { ;
	'SGJ'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'GJ_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde. do PV'															, ; //X3_TITULO
	'Cant. del PV'															, ; //X3_TITSPA
	'SO Amount'																, ; //X3_TITENG
	'Quantidade do PV'														, ; //X3_DESCRIC
	'Cantidad del PV'														, ; //X3_DESCSPA
	'Sales Order Amount'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SGJ'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'GJ_QEMPN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde. Emp.'															, ; //X3_TITULO
	'Ctd. Emp.'																, ; //X3_TITSPA
	'Alloc.Qty'																, ; //X3_TITENG
	'Qtde. Empenhada do PV'													, ; //X3_DESCRIC
	'Ctd. Empenada del PV'													, ; //X3_DESCSPA
	'SO Allocated Amount'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SGJ'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'GJ_QEMPN2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtde. Emp. 2'															, ; //X3_TITULO
	'Ctd. Emp.'																, ; //X3_TITSPA
	'Alloc.Qty 2'															, ; //X3_TITENG
	'Qtde. Empenhada 2a. UM'												, ; //X3_DESCRIC
	'Ctd. Empenada 2a. UM'													, ; //X3_DESCSPA
	'2nd MU Allocated Amount'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'N'																		} ) //X3_PYME

//
// Tabela SGO
//
aAdd( aSX3, { ;
	'SGO'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'GO_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Amount'																, ; //X3_TITENG
	'Quantidade enviada'													, ; //X3_DESCRIC
	'Cantidad enviada'														, ; //X3_DESCSPA
	'Amount Sent'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(156) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SGO'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'GO_QTSEGUM'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Seg. UM'															, ; //X3_TITULO
	'Ctd. Seg. UM'															, ; //X3_TITSPA
	'Amt Sec MU'															, ; //X3_TITENG
	'Qtd. Segunda unid. medida'												, ; //X3_DESCRIC
	'Ctd. Segunda unid. medida'												, ; //X3_DESCSPA
	'Amt Second Meas. Unit'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(156) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SH6
//
aAdd( aSX3, { ;
	'SH6'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'H6_QTDPROD'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Prod.'															, ; //X3_TITULO
	'Ctd. Prod.'															, ; //X3_TITSPA
	'Qty.Produced'															, ; //X3_TITENG
	'Quantidade Produzida'													, ; //X3_DESCRIC
	'Cantidad Producida'													, ; //X3_DESCSPA
	'Quantity Produced'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A680Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SH6'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'H6_QTDPERD'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qtd. Perda'															, ; //X3_TITULO
	'Ctd. Perdida'															, ; //X3_TITSPA
	'Qty Loss'																, ; //X3_TITENG
	'Quantidade Perdida'													, ; //X3_DESCRIC
	'Cantidad Perdida'														, ; //X3_DESCSPA
	'Quantity Lost'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A680Quant() .And. DigiPerda(M->H6_PRODUTO,M->H6_OP,M->H6_QTDPERD)', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SH6'																	, ; //X3_ARQUIVO
	'39'																	, ; //X3_ORDEM
	'H6_QTDPRO2'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Qt.Prod. 2UM'															, ; //X3_TITULO
	'Ctd. Prod. 2'															, ; //X3_TITSPA
	'Qty.Produc.2'															, ; //X3_TITENG
	'Quantidade Produzida 2aUM'												, ; //X3_DESCRIC
	'Cantidad Producida 2a UM'												, ; //X3_DESCSPA
	'Quantity Produced 2nd UOM'												, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo() .And. A680Quant()'											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SH8
//
aAdd( aSX3, { ;
	'SH8'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'H8_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade a Produzir'													, ; //X3_DESCRIC
	'Cantidad a Producir'													, ; //X3_DESCSPA
	'Quantity to Produce'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SHC
//
aAdd( aSX3, { ;
	'SHC'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'HC_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade da previsao'												, ; //X3_DESCRIC
	'Cantidad de la Prevision'												, ; //X3_DESCSPA
	'Quantity Forecast'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'positivo().and.a750QtdGra().and.ShcVldMax()'							, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(159) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SHD
//
aAdd( aSX3, { ;
	'SHD'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'HD_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Quantity'																, ; //X3_TITENG
	'Quantidade a Produzir'													, ; //X3_DESCRIC
	'Cantidad a Producir'													, ; //X3_DESCSPA
	'Quantity to Produce'													, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(154) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SHM
//
aAdd( aSX3, { ;
	'SHM'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'HM_CANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade P'															, ; //X3_TITULO
	'Cuantidad Pr'															, ; //X3_TITSPA
	'Product Amt.'															, ; //X3_TITENG
	'Quantidade Produto'													, ; //X3_DESCRIC
	'Cantidad Producto'														, ; //X3_DESCSPA
	'Product Amount'														, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(222) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SHN
//
aAdd( aSX3, { ;
	'SHN'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'HN_CANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Amount'																, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Cantidad'																, ; //X3_DESCSPA
	'Amount'																, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(223) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Tabela SHY
//
aAdd( aSX3, { ;
	'SHY'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'HY_QUANT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	6																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Cantidad'																, ; //X3_TITSPA
	'Amount'																, ; //X3_TITENG
	'Quantidade Alocada'													, ; //X3_DESCRIC
	'Cantidad Destinada'													, ; //X3_DESCSPA
	'Amt Placed'															, ; //X3_DESCENG
	'@E 99999999.999999'													, ; //X3_PICTURE
	'Positivo()'															, ; //X3_VALID
	Chr(128) + Chr(144) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(222) + Chr(128)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	''																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

//
// Atualizando dicionแrio
//

nPosArq := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x ) == "X3_GRPSXG"  } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajsuta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				cTexto += STR0061 + aSX3[nI][nPosCpo] + STR0062 //"O tamanho do campo "###" nao atualizado e foi mantido em ["
				cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF
				cTexto += STR0063 + SX3->X3_GRPSXG + "]" + CRLF + CRLF //"   por pertencer ao grupo de campos ["
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq] $ cAlias )
		cAlias += aSX3[nI][nPosArq] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == nPosOrd  // Ordem
				FieldPut( FieldPos( aEstrut[nJ] ), cSeqAtu )

			ElseIf FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		cTexto += STR0064 + aSX3[nI][nPosCpo] + CRLF //"Criado o campo "

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam] <> SXG->XG_SIZE
					aSX3[nI][nPosTam] := SXG->XG_SIZE
					cTexto +=  STR0061 + aSX3[nI][nPosCpo] + STR0062 //"O tamanho do campo "###" nao atualizado e foi mantido em ["
					cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF
					cTexto +=  STR0063 + SX3->X3_GRPSXG + "]" + CRLF + CRLF //"   por pertencer ao grupo de campos ["
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			//
			// Se o campo estiver diferente da estrutura
			//
			If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
				PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), " ", "" ), 250 ) <> ;
				PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , " ", "" ), 250 ) .AND. ;
				AllTrim( SX3->( FieldName( nJ ) ) ) <> "X3_ORDEM"

				cMsg := STR0065 + aSX3[nI][nPosCpo] + STR0066 + SX3->( FieldName( nJ ) ) + ; //"O campo "###" estแ com o "
				STR0067 + CRLF + ; //" com o conte๚do"
				"[" + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
				STR0068 + CRLF + ; //"que serแ substituido pelo NOVO conte๚do"
				"[" + RTrim( AllToChar( aSX3[nI][nJ] ) ) + "]" + CRLF + ;
				STR0069 //"Deseja substituir ? "

				If      lTodosSim
					nOpcA := 1
				ElseIf  lTodosNao
					nOpcA := 2
				Else
					nOpcA := Aviso( STR0001, cMsg, { STR0070, STR0071, STR0072, STR0073 }, 3, STR0074 ) //"ATUALIZAวรO DE DICIONมRIOS E TABELAS"###"Sim"###"Nใo"###"Sim p/Todos"###"Nใo p/Todos"###"Diferen็a de conte๚do - SX3"
					lTodosSim := ( nOpcA == 3 )
					lTodosNao := ( nOpcA == 4 )

					If lTodosSim
						nOpcA := 1
						lTodosSim := MsgNoYes( STR0075 + CRLF + STR0076 ) //"Foi selecionada a op็ใo de REALIZAR TODAS altera็๕es no SX3 e NรO MOSTRAR mais a tela de aviso."###"Confirma a a็ใo [Sim p/Todos] ?"
					EndIf

					If lTodosNao
						nOpcA := 2
						lTodosNao := MsgNoYes( STR0077 + CRLF + STR0078 ) //"Foi selecionada a op็ใo de NรO REALIZAR nenhuma altera็ใo no SX3 que esteja diferente da base e NรO MOSTRAR mais a tela de aviso."###"Confirma esta a็ใo [Nใo p/Todos]?"
					EndIf

				EndIf

				If nOpcA == 1
					cTexto += STR0079 + aSX3[nI][nPosCpo] + CRLF //"Alterado o campo "
					cTexto += "   " + PadR( SX3->( FieldName( nJ ) ), 10 ) + STR0080 + AllToChar( SX3->( FieldGet( nJ ) ) ) + "]" + CRLF //" de ["
					cTexto += STR0081 + AllToChar( aSX3[nI][nJ] )          + "]" + CRLF + CRLF //"            para ["

					RecLock( "SX3", .F. )
					FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
					dbCommit()
					MsUnLock()
				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( STR0082 ) //"Atualizando Campos de Tabelas (SX3)..."

Next nI

cTexto += CRLF + STR0060 + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF //"Final da Atualizacao"

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuHlp บ Autor ณ TOTVS Protheus     บ Data ณ  17/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao dos Helps de Campos    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuHlp   - Gerado por EXPORDIC / Upd. V.4.10.7 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuHlp( cTexto )
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

cTexto  += STR0055 + " " + STR0137 + CRLF + CRLF //"Inicio da Atualizacao"###"Helps de Campos"


oProcess:IncRegua2( STR0115 ) //"Atualizando Helps de Campos ..."

//
// Helps Tabela SB0
//
aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV1   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 2.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV2   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV3   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 4.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV4   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 5.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV5   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 6.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV6   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV6" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 7.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV7   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV7" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 8.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV8   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV8" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda 9.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB0_PRV9   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B0_PRV9" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB1
//
aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda do produto. Existe mais 6' )
aAdd( aHlpPor, 'tabelas no arquivo SB5 (Dados' )
aAdd( aHlpPor, 'Adicionaisdo Produto).' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB1_PRV1   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B1_PRV1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Standard ou Custo Padrao do' )
aAdd( aHlpPor, 'produto. Deve ser informado apenas para' )
aAdd( aHlpPor, 'Mat้rias-Primas e Maos-de-Obra.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB1_CUSTD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B1_CUSTD" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Indica a quantidade unitaria da midia' )
aAdd( aHlpPor, 'para uma unidade do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB1_QTMIDIA", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B1_QTMIDIA" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informe neste campo a quantidade mํnima' )
aAdd( aHlpPor, 'para venda do produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB1_LOTVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B1_LOTVEN" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB2
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo  em  quantidade no fim do m๊s' )
aAdd( aHlpPor, 'paraemissใo de relat๓rios.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QFIM   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QFIM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade atual (ON-LINE) do produto em' )
aAdd( aHlpPor, 'estoque no Armazem.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QATU   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QATU" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitแrio m้dio atual do produto.' )
aAdd( aHlpPor, 'Este campo s๓ deve ser informado' )
aAdd( aHlpPor, 'paraitens sem saldo, pois o sistema' )
aAdd( aHlpPor, 'necessita dos custos para valoriza็ใo' )
aAdd( aHlpPor, 'das requisi็๕es.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CM1    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CM1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitแrio do produto na segunda' )
aAdd( aHlpPor, 'moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CM2    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CM2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitแrio do produto na terceira' )
aAdd( aHlpPor, 'moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CM3    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CM3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitแrio do produto na quarta' )
aAdd( aHlpPor, 'moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CM4    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CM4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitแrio do produto na quinta' )
aAdd( aHlpPor, 'moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CM5    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CM5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade acumulada das Ordens de' )
aAdd( aHlpPor, 'Pro-du็ใo  geradas a partir  de  Pedidos' )
aAdd( aHlpPor, 'deVenda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QEMPN  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QEMPN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Reservada  pelo  Controle' )
aAdd( aHlpPor, 'deReservas e/ou atrav้s  da  Libera็ใo' )
aAdd( aHlpPor, 'dePedidos sem bloqueio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_RESERVA", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_RESERVA" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade em Pedidos de Venda nใo' )
aAdd( aHlpPor, 'libe-rados e/ou Pedidos liberados   com' )
aAdd( aHlpPor, 'Blo-queio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QPEDVEN", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QPEDVEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo das Solicita็๖es/Pedidos de  Com-' )
aAdd( aHlpPor, 'pra e/ou Ordens de Produ็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_SALPEDI", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_SALPEDI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de Terceiros em nosso Poder.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QTNP   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QTNP" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade nossa em Poder Terceiros.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QNPT   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QNPT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade em poder de 3. sem movimen-' )
aAdd( aHlpPor, 'ta็ใo de Estoque.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QTER   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QTER" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo em quantidade no fim do m๊s na' )
aAdd( aHlpPor, 'se-gunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QFIM2  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QFIM2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, "Quantidade a Endere็ar. Estes campo e'" )
aAdd( aHlpPor, 'atualizado a partir do Saldos a Distri-' )
aAdd( aHlpPor, 'buir.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QACLASS", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QACLASS" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Unitario do Produto FIFO.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CMFF1  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CMFF1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Unitario do Produto FIFO da' )
aAdd( aHlpPor, '2a. moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CMFF2  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CMFF2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Unitario do Produto FIFO da' )
aAdd( aHlpPor, '3a. moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CMFF3  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CMFF3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Unitario do Produto FIFO da' )
aAdd( aHlpPor, '4a. moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CMFF4  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CMFF4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Unitario do Produto FIFO da' )
aAdd( aHlpPor, '5a. moeda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_CMFF5  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_CMFF5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Prevista Pelas Solicita็๕es' )
aAdd( aHlpPor, 'ao Almoxarifado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QEMPSA ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QEMPSA" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo das Solicita็๖es/Pedidos de' )
aAdd( aHlpPor, 'Comprae/ou Ordens de Produ็ใo Previstas' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_SALPPRE", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_SALPPRE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade acumulada das Ordens de' )
aAdd( aHlpPor, 'Pro-du็ใo  geradas a partir  de  Pedidos' )
aAdd( aHlpPor, 'deVenda na Segunda Unidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QEMPN2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QEMPN2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade em Pedidos de Venda nใo' )
aAdd( aHlpPor, 'libe-rados e/ou Pedidos liberados   com' )
aAdd( aHlpPor, 'Blo-queio na Segunda Unidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QPEDVE2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QPEDVE2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo  em  quantidade no fim do m๊s' )
aAdd( aHlpPor, 'paraemissใo de relat๓rios.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QFIMFF ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QFIMFF" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo das Solicita็๕es/Pedidos de compra' )
aAdd( aHlpPor, 'e/ou Ordens de Produ็ใo. Na 2a. Unidade' )
aAdd( aHlpPor, 'de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_SALPED2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_SALPED2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Empenhada do Produto atrav้s' )
aAdd( aHlpPor, 'de um PROJETO.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QEMPPRJ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QEMPPRJ" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade empenhada no projeto/tarefa' )
aAdd( aHlpPor, 'na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB2_QEMPPR2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B2_QEMPPR2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB3
//
aHlpPor := {}
aAdd( aHlpPor, 'Valoriza็ใo  da  m้dia de consumo' )
aAdd( aHlpPor, 'mensaldo produto multiplicado pelo custo' )
aAdd( aHlpPor, 'stan-dard do ๚ltimo m๊s fechado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB3_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B3_TOTAL" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB4
//
aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB4_PRV1   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B4_PRV1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda 2, para utilizแ-lo no' )
aAdd( aHlpPor, 'pe-dido de venda digitar 2 no campo' )
aAdd( aHlpPor, 'tabela.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB4_PRV2   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B4_PRV2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda 3, para utilizแ-lo no' )
aAdd( aHlpPor, 'Pedido de Venda , digitar 3 no campo' )
aAdd( aHlpPor, 'tabela.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB4_PRV3   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B4_PRV3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda 4, para utilizแ-lo no' )
aAdd( aHlpPor, 'Pedido de Venda, digitar 4 no campo' )
aAdd( aHlpPor, 'tabela.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB4_PRV4   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B4_PRV4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda 5, para utilizแ-lo no' )
aAdd( aHlpPor, 'pedido de venda, digitar 5 no campo' )
aAdd( aHlpPor, 'tabela.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB4_PRV5   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B4_PRV5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o  de  venda 6, para utilizแ-lo no' )
aAdd( aHlpPor, 'pedido de venda, digitar 6  no   campo' )
aAdd( aHlpPor, 'tabela.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB4_PRV6   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B4_PRV6" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda 7, para utilizแ-lo no' )
aAdd( aHlpPor, 'pedido de vendas , digitar 7 no campo' )
aAdd( aHlpPor, 'tabela.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB4_PRV7   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B4_PRV7" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB5
//
aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda  tabela  2.  Sugerido' )
aAdd( aHlpPor, 'porocasiใo do pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB5_PRV2   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B5_PRV2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda  tabela  3.  Sugerido' )
aAdd( aHlpPor, 'porocasiใo do pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB5_PRV3   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B5_PRV3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda  tabela  4.  Sugerido' )
aAdd( aHlpPor, 'porocasiใo do pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB5_PRV4   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B5_PRV4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de  venda  tabela  5. Sugerido' )
aAdd( aHlpPor, 'porocasiใo do pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB5_PRV5   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B5_PRV5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de  venda  tabela  6. Sugerido' )
aAdd( aHlpPor, 'porocasiใo do pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB5_PRV6   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B5_PRV6" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de  venda  tabela  7. Sugerido' )
aAdd( aHlpPor, 'porocasiใo do pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB5_PRV7   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B5_PRV7" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB6
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade originalmente' )
aAdd( aHlpPor, 'enviada/recebi-da do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Preco Unitario do Produto em/de Poder' )
aAdd( aHlpPor, 'deTerceiros.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_PRUNIT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_PRUNIT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unid. de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Liberada pelo faturamento.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_QULIB  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_QULIB" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo referente a uma entrada de' )
aAdd( aHlpPor, 'poder de terceiros.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_SALDO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_CUSRP1 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_CUSRP1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 2.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_CUSRP2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_CUSRP2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_CUSRP3 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_CUSRP3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 4.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_CUSRP4 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_CUSRP4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 5.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB6_CUSRP5 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B6_CUSRP5" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB7
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade inventariada em estoque.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB7_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B7_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do produto na segunda' )
aAdd( aHlpPor, 'unidadede medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB7_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B7_QTSEGUM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB8
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Original do Lote.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB8_QTDORI ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B8_QTDORI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo do Lote (em quantidade).' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB8_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B8_SALDO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do Lote/Sub-Lote aguardando' )
aAdd( aHlpPor, 'Distribui็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB8_QACLASS", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B8_QACLASS" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB8_SALDO2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B8_SALDO2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Original do Lote na Segunda' )
aAdd( aHlpPor, 'Unidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB8_QTDORI2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B8_QTDORI2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do Lote/Sub-Lote aguardando' )
aAdd( aHlpPor, 'Distribui็ใo na Segunda Unidade de' )
aAdd( aHlpPor, 'Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB8_QACLAS2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B8_QACLAS2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SB9
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo em quantidade no ํnicio do m๊s' )
aAdd( aHlpPor, 'para fins de reprocessamento e Kardex.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_QINI   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_QINI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_QISEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_QISEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo standard ou custo padrใo do' )
aAdd( aHlpPor, 'produto. Deve ser informado apenas para' )
aAdd( aHlpPor, 'mat้rias primas e mใo-de-obra.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_CUSTD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_CUSTD" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Medio Historico na Moeda 1' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_CM1    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_CM1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Medio Historico na Moeda 2' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_CM2    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_CM2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Medio Historico na Moeda 3' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_CM3    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_CM3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Medio Historico na Moeda 4' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_CM4    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_CM4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Medio Historico na Moeda 5' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PB9_CM5    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "B9_CM5" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBA
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de produtos a ser vendido no' )
aAdd( aHlpPor, 'm๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q01    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q01" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q02    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q02" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q03    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q03" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q04    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q04" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q05    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q05" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q06    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q06" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q07    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q07" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q08    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q08" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q09    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q09" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q10    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q10" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q11    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q11" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Vide help do m๊s 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_Q12    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_Q12" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de vendas do m๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR01", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR01" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de vendas do m๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR03", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR03" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de vendas do m๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR05", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR05" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de vendas do M๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR06", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR06" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de vendas do m๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR07", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR07" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de vendas do m๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR09", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR09" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de vendas do m๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR10", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR10" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de venda do m๊s.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBA_VALOR11", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BA_VALOR11" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBB
//
aHlpPor := {}
aAdd( aHlpPor, 'Valor do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBB_VALOR  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BB_VALOR" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBC
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de perda para o motivo' )
aAdd( aHlpPor, 'digitado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBC_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BC_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na 2a. unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBC_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BC_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade destino do apontamento da' )
aAdd( aHlpPor, 'perda. Campo usado para produtos que' )
aAdd( aHlpPor, 'tenham UM diferente do produto origem.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBC_QTDDEST", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BC_QTDDEST" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de destino na 2a. unidade de' )
aAdd( aHlpPor, 'medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBC_QTDDES2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BC_QTDDES2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBD
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do produto na Segunda' )
aAdd( aHlpPor, 'Unidadede Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_QT2UM  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_QT2UM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Inicial do Produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_QINI   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_QINI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Inicial do Produto na' )
aAdd( aHlpPor, 'SegundaUnidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_QINI2UM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_QINI2UM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Inicial na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSINI1", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSINI1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Inicial na Moeda 2.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSINI2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSINI2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Inicial na Moeda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSINI3", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSINI3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Inicial na Moeda 4.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSINI4", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSINI4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Inicial na Moeda 5.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSINI5", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSINI5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Final do Produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_QFIM   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_QFIM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Final do Produto na Segunda' )
aAdd( aHlpPor, 'Unidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_QFIM2UM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_QFIM2UM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Final na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSFIM1", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSFIM1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Final na Moeda 2.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSFIM2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSFIM2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Final na Moeda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSFIM3", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSFIM3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Final na Moeda 4.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSFIM4", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSFIM4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo Final na Moeda 5.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBD_CUSFIM5", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BD_CUSFIM5" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBF
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade estocada neste Endere็o.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBF_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BF_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBF_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BF_QTSEGUM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBH
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Utilizada do Componente para' )
aAdd( aHlpPor, 'uma unidade do Produto da Sugestใo de' )
aAdd( aHlpPor, 'Or็amento.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBH_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BH_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBI
//
aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de venda do produto. Existe mais 6' )
aAdd( aHlpPor, 'tabelas no arquivo SB5 (Dados' )
aAdd( aHlpPor, 'Adicionaisdo Produto).' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBI_PRV    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BI_PRV" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBJ
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo em quantidade no ํnicio do m๊s' )
aAdd( aHlpPor, 'para fins de reprocessamento e Kardex.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBJ_QINI   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BJ_QINI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo em quantidade na segunda unidade' )
aAdd( aHlpPor, 'de medida no inicio do mes para fins de' )
aAdd( aHlpPor, 'reprocessamento.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBJ_QISEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BJ_QISEGUM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBK
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo em quantidade no ํnicio do m๊s' )
aAdd( aHlpPor, 'para fins de reprocessamento e Kardex.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBK_QINI   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BK_QINI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo em quantidade na segunda unidade' )
aAdd( aHlpPor, 'de medida no inicio do mes para fins de' )
aAdd( aHlpPor, 'reprocessamento.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBK_QISEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BK_QISEGUM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBL
//
aHlpPor := {}
aAdd( aHlpPor, 'Total acumulado do custo para' )
aAdd( aHlpPor, 'classifica็ใo XYZ' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBL_TOTCUST", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BL_TOTCUST" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade sugerida pela formula eleita.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBL_QTDFOR1", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BL_QTDFOR1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade sugerida pela segunda' )
aAdd( aHlpPor, 'formulaeleita.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBL_QTDFOR2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BL_QTDFOR2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade sugerida pela terceira' )
aAdd( aHlpPor, 'formula eleita.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBL_QTDFOR3", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BL_QTDFOR3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade sugerida pela quarta formula' )
aAdd( aHlpPor, 'eleita.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBL_QTDFOR4", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BL_QTDFOR4" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBU
//
aHlpPor := {}
aAdd( aHlpPor, 'Campo equivalente ao existente no' )
aAdd( aHlpPor, 'cadastro de Estruturas.' )
aAdd( aHlpPor, 'Quantidade do componente a ser' )
aAdd( aHlpPor, 'adicionado na estrutura do produto a' )
aAdd( aHlpPor, 'ser criado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBU_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BU_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SBZ
//
aHlpPor := {}
aAdd( aHlpPor, 'Custo Standard ou Custo Padrao do' )
aAdd( aHlpPor, 'produto. Deve ser informado apenas para' )
aAdd( aHlpPor, 'Mat้rias-Primas e Maos-de-Obra.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PBZ_CUSTD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "BZ_CUSTD" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC0
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade reservada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC0_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C0_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade original da reserva' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC0_QTDORIG", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C0_QTDORIG" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da reserva de material que' )
aAdd( aHlpPor, 'se encontra colocada em pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC0_QTDPED ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C0_QTDPED" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Indica qual o saldo da reserva eliminado' )
aAdd( aHlpPor, 'pela op็ใo "zera saldo remanescente".' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC0_QTDELIM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C0_QTDELIM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC1
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade total de  material da' )
aAdd( aHlpPor, 'solicita็ใo de compras. Caso esta' )
aAdd( aHlpPor, 'solicita็ใo possuir saldo comprometido,' )
aAdd( aHlpPor, 'a quantidade nใo poderแ ser inferior ao' )
aAdd( aHlpPor, 'saldo comprometido.' )
aAdd( aHlpPor, 'Caso exista fator de conversใo entre as' )
aAdd( aHlpPor, 'unidades de medida a conversใo ้ feita' )
aAdd( aHlpPor, 'automaticamente.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do material solicitada na' )
aAdd( aHlpPor, 'segunda unidade de medida.' )
aAdd( aHlpPor, 'Caso exista fator de conversใo entre as' )
aAdd( aHlpPor, 'unidades de medida a conversใo ้ feita' )
aAdd( aHlpPor, 'automaticamente.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ pedida do material' )
aAdd( aHlpPor, 'solici-tado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_QUJE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_QUJE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ entregue na segunda' )
aAdd( aHlpPor, 'unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_QUJE2  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_QUJE2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor unitแrio do item a ser solicitado,' )
aAdd( aHlpPor, 'este valor ้ um valor estimado que serve' )
aAdd( aHlpPor, 'para reserva de valores nos or็amentos.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_VUNIT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_VUNIT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Original.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_QTDORIG", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_QTDORIG" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informe o Pre็o Unitแrio do Produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_PRECO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_PRECO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor total do item composto por valor' )
aAdd( aHlpPor, 'unitแrio multiplicado pela quantidade.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC1_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C1_TOTAL" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC2
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade original  da  ordem de' )
aAdd( aHlpPor, 'produ-็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ produzida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_QUJE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_QUJE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor na primeira moeda requisitado' )
aAdd( aHlpPor, 'paraesta OP, utilizado para' )
aAdd( aHlpPor, 'reprocessamento(recแlculo).' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_VINI1  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_VINI1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade reprogramada pelo MRP' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_QTUPROG", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_QTUPROG" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor inicial do custo FIFO.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_VINIFF1", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_VINIFF1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor inicial do custo FIFO na 2a. moeda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_VINIFF2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_VINIFF2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor inicial do custo FIFO na 3a. moeda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_VINIFF3", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_VINIFF3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor inicial do custo FIFO na 4a. moeda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_VINIFF4", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_VINIFF4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor inicial do custo FIFO na 5a. moeda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC2_VINIFF5", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C2_VINIFF5" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC3
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do Contrato de Parceria.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC3_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C3_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o do Contrato de Parceria.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC3_PRECO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C3_PRECO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Total do Contrato de Parceria.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC3_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C3_TOTAL" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ entregue na primeira' )
aAdd( aHlpPor, 'unidade de medida' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC3_QUJE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C3_QUJE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC3_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C3_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de impress๕es.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC3_QTIMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C3_QTIMP" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC4
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da previsใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC4_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C4_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da previsใo de venda  de um' )
aAdd( aHlpPor, 'deter-minado produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC4_VALOR  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C4_VALOR" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC6
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade original do pedido.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDVEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o unitแrio lํquido. Pre็o de  tabela' )
aAdd( aHlpPor, 'com aplica็ใo dos descontos e acr้scimos' )
aAdd( aHlpPor, 'financeiros.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_PRCVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_PRCVEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor total do ํtem lํquido, jแ' )
aAdd( aHlpPor, 'considerado todos os descontos e  com' )
aAdd( aHlpPor, 'base na quantidade.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_VALOR  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_VALOR" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Campo utilizado para informar a' )
aAdd( aHlpPor, 'quantidade a ser liberada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDLIB ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDLIB" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Campo utilizado para informar a' )
aAdd( aHlpPor, 'quantidade a ser liberada na segunda' )
aAdd( aHlpPor, 'unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDLIB2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDLIB2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade original do pedido na unidade' )
aAdd( aHlpPor, 'secundแria.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_UNSVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_UNSVEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade entregue na segunda unidade' )
aAdd( aHlpPor, 'de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDENT2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDENT2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ entregue/faturada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDENT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDENT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor do pre็o unitแrio da tabela.' )
aAdd( aHlpPor, 'Utilizado tamb้m para venda a Zona' )
aAdd( aHlpPor, 'Franca, quando necessแrio imprimir o' )
aAdd( aHlpPor, 'valor  do desconto de 7% de acordo com' )
aAdd( aHlpPor, 'incentivos fiscais.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_PRUNIT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_PRUNIT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade reservada vinculada a este' )
aAdd( aHlpPor, 'item do pedido de venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDRESE", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDRESE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade liberada por้m nใo faturada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDEMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDEMP" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade empenhada na segunda unidade' )
aAdd( aHlpPor, 'de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC6_QTDEMP2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C6_QTDEMP2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC7
//
aHlpPor := {}
aAdd( aHlpPor, 'Informe a quantidade do material' )
aAdd( aHlpPor, 'solicitada para o fornecedor deste' )
aAdd( aHlpPor, 'pedido de compra/autoriza็ใo de entrega.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC7_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C7_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o unitแrio bruto do ํtem do pedido' )
aAdd( aHlpPor, 'de compra/autoriza็ใo de entrega' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC7_PRECO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C7_PRECO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informe o resultado do produto da' )
aAdd( aHlpPor, 'quantidade sobre o pre็o unitแrio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC7_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C7_TOTAL" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade pedida na segunda unidade' )
aAdd( aHlpPor, 'demedida. O programa calcula a' )
aAdd( aHlpPor, 'quantidadequando existir no campo fator' )
aAdd( aHlpPor, 'de conver-sใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC7_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C7_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ entregue do material. Este' )
aAdd( aHlpPor, 'campo ้ atualizado automaticamente pelo' )
aAdd( aHlpPor, 'sistema.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC7_QUJE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C7_QUJE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de material em processo de' )
aAdd( aHlpPor, 'recebimento. Esta informa็ใo somente ้' )
aAdd( aHlpPor, 'utilizada quanto utiliza-se a rotina de' )
aAdd( aHlpPor, 'recebimento de material (MATA140).' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC7_QTDACLA", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C7_QTDACLA" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informa a quantidade da solicita็ใo de' )
aAdd( aHlpPor, 'compra vinculada a este pedido de' )
aAdd( aHlpPor, 'compra. Este campo ้ preenchido' )
aAdd( aHlpPor, 'automaticamente pelo sistema quando' )
aAdd( aHlpPor, 'informa-se a solicita็ใo de compra.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC7_QTDSOL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C7_QTDSOL" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC8
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade cotada. Sugerido pelo' )
aAdd( aHlpPor, 'sistemacom base na solicita็ใo de' )
aAdd( aHlpPor, 'compras.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC8_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C8_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade a ser considerada para' )
aAdd( aHlpPor, 'gera็ao automแtica do Contrato de' )
aAdd( aHlpPor, 'Parceria.' )
aAdd( aHlpPor, 'Esta informa็ใo ้ muito utํl quando o' )
aAdd( aHlpPor, 'fornecedor do material oferece melhores' )
aAdd( aHlpPor, 'condi็๕es, caso a quantidade adquirida' )
aAdd( aHlpPor, 'seja maior que a necessidade do' )
aAdd( aHlpPor, 'material. Neste caso o sistema criarแ' )
aAdd( aHlpPor, 'automแticamente um contrato de parceria,' )
aAdd( aHlpPor, 'e quando houver demanda do material' )
aAdd( aHlpPor, 'poderแ ser atendida por uma autoriza็ใo' )
aAdd( aHlpPor, 'de entrega.' )
aAdd( aHlpPor, 'Quando a quantidade informada for maior' )
aAdd( aHlpPor, 'que a necessidade da solicita็ใo de' )
aAdd( aHlpPor, 'compra e o Produto permitir a inclusใo' )
aAdd( aHlpPor, 'do  mesmo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC8_QTDCTR ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C8_QTDCTR" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o unitแrio bruto (com desconto)' )
aAdd( aHlpPor, 'acordado com o fornecedor do produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC8_PRECO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C8_PRECO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informe o resultado do produto entre a' )
aAdd( aHlpPor, 'quantidade e o pre็o unitแrio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC8_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C8_TOTAL" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Segunda Unidade de Medida.' )
aAdd( aHlpPor, 'Sugerido pelo sistema com base na' )
aAdd( aHlpPor, 'solicita็ใo de compras.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC8_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C8_QTSEGUM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SC9
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade liberada do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC9_QTDLIB ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C9_QTDLIB" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade reserva pela reserva de' )
aAdd( aHlpPor, 'material.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC9_QTDRESE", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C9_QTDRESE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade liberada na segunda unidade' )
aAdd( aHlpPor, 'de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PC9_QTDLIB2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "C9_QTDLIB2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCC
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Inicial do Produto.' )
aHlpEng := {}
aAdd( aHlpEng, 'Beginning Quantity of the Product.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Cantidad Inicial de Producto.' )

PutHelp( "PCC_QINI   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_QINI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Inicial do Produto na' )
aAdd( aHlpPor, 'Segunda Unidade de Medida' )
aHlpEng := {}
aAdd( aHlpEng, 'Beginning Quantity of the Product' )
aAdd( aHlpEng, 'in the Second Unit of Measure' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Cantidad Inicial de Producto en' )
aAdd( aHlpSpa, 'la Segunda Unidad de Medida.' )

PutHelp( "PCC_QINI2UM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_QINI2UM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo na Moeda 1.' )
aHlpEng := {}
aAdd( aHlpEng, 'Fifo Cost in Currency 1.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Costo Fifo en la moneda 1.' )

PutHelp( "PCC_VINIFF1", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VINIFF1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo na Moeda 2.' )
aHlpEng := {}
aAdd( aHlpEng, 'Fifo Cost in Currency 2.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Costo Fifo en la moneda 2.' )

PutHelp( "PCC_VINIFF2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VINIFF2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo na Moeda 3.' )
aHlpEng := {}
aAdd( aHlpEng, 'Fifo Cost in Currency 3.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Costo Fifo en la moneda 3.' )

PutHelp( "PCC_VINIFF3", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VINIFF3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo na Moeda 4.' )
aHlpEng := {}
aAdd( aHlpEng, 'Fifo Cost in Currency 4.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Costo Fifo en la moneda 4.' )

PutHelp( "PCC_VINIFF4", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VINIFF4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo na Moeda 5.' )
aHlpEng := {}
aAdd( aHlpEng, 'Fifo Cost in Currency 5.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Costo Fifo en la moneda 5.' )

PutHelp( "PCC_VINIFF5", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VINIFF5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Final' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCC_QFIM   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_QFIM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Final 2a. unidade de medida' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCC_QFIM2UM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_QFIM2UM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Final Fifo na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCC_VFIMFF1", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VFIMFF1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Final Fifo na Moeda 2.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCC_VFIMFF2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VFIMFF2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Final Fifo na Moeda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCC_VFIMFF3", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VFIMFF3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Final Fifo na Moeda 4' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCC_VFIMFF4", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VFIMFF4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Final Fifo na Moeda 5' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCC_VFIMFF5", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CC_VFIMFF5" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCE
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade entregue pelo Fornecedor' )
aAdd( aHlpPor, 'para esta cota็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCE_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CE_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCI
//
//
// Helps Tabela SCK
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Vendida.' )
aAdd( aHlpPor, '< F4 > Disponํvel para acessar os' )
aAdd( aHlpPor, 'componentes do item.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCK_QTDVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CK_QTDVEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Venda' )
aAdd( aHlpPor, '< F4 > Diponํvel para consulta a posi็ใo' )
aAdd( aHlpPor, 'de estoque' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCK_PRCVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CK_PRCVEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor Total do Item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCK_VALOR  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CK_VALOR" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o de Lista' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCK_PRUNIT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CK_PRUNIT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCL
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do componente utilizado em 1' )
aAdd( aHlpPor, 'unidade do produto pai.' )
aAdd( aHlpPor, '< F4 > Disponํvel' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCL_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CL_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCO
//
//
// Helps Tabela SCP
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade total do material solicitado' )
aAdd( aHlpPor, 'na primeira unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCP_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CP_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade total do material solicitado' )
aAdd( aHlpPor, 'na segunda unidade de medida. Caso o' )
aAdd( aHlpPor, 'produto tenha FATOR DE CONVERSAO' )
aAdd( aHlpPor, 'cadastrado, esta campo ้ calculado' )
aAdd( aHlpPor, 'automaticamente.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCP_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CP_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, "Quantidade Atendida das SA's." )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCP_QUJE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CP_QUJE" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCQ
//
aHlpPor := {}
aAdd( aHlpPor, 'Identifica a Quantidade da Solicita็ใo' )
aAdd( aHlpPor, 'ao Almoxarifado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCQ_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CQ_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Identifica a Quantidade da Segunda' )
aAdd( aHlpPor, 'Unidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCQ_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CQ_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Identifica a Quantidade Disponivel.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCQ_QTDISP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CQ_QTDISP" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCR
//
aHlpPor := {}
aAdd( aHlpPor, 'Valor total do documento de al็ada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCR_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CR_TOTAL" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCS
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo do aprovador' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCS_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CS_SALDO" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCT
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Vendida a ser apurada' )
aAdd( aHlpPor, 'na Meta de Venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCT_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CT_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCW
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCW_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CW_SALDO" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SCY
//
aHlpPor := {}
aAdd( aHlpPor, 'Informe a quantidade do material' )
aAdd( aHlpPor, 'solicitada para o fornecedor deste' )
aAdd( aHlpPor, 'pedido de compra/ autoriza็ใo de' )
aAdd( aHlpPor, 'entrega.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCY_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CY_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o unitแrio bruto do ํtem do pedido' )
aAdd( aHlpPor, 'de compra/autoriza็ใo de entrega' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCY_PRECO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CY_PRECO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informe o resultado do produto da' )
aAdd( aHlpPor, 'quantidade sobre o pre็o unitแrio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCY_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CY_TOTAL" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade pedida na segunda unidade' )
aAdd( aHlpPor, 'demedida. O programa calcula a' )
aAdd( aHlpPor, 'quantidadequando existir no campo fator' )
aAdd( aHlpPor, 'de conver-sใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCY_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CY_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ entregue do material. Este' )
aAdd( aHlpPor, 'campo ้ atualizado automaticamente pelo' )
aAdd( aHlpPor, 'sistema.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCY_QUJE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CY_QUJE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de material em processo de' )
aAdd( aHlpPor, 'recebimento. Esta informa็ใo somente ้' )
aAdd( aHlpPor, 'utilizada quanto utiliza-se a rotina de' )
aAdd( aHlpPor, 'recebimento de material (MATA140).' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCY_QTDACLA", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CY_QTDACLA" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informa a quantidade de impress๕es do' )
aAdd( aHlpPor, 'pedido de compra/autoriza็ใo de entrega.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PCY_QTDSOL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "CY_QTDSOL" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD1
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade entregue do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor unitแrio do ํtem.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_VUNIT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_VUNIT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor total da nota fiscal.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_TOTAL" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade devolvida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_QTDEDEV", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_QTDEDEV" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do pedido de compras ou' )
aAdd( aHlpPor, 'autoriza็ao de entrega vinculado a este' )
aAdd( aHlpPor, 'item do documento de entrada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_QTDPEDI", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_QTDPEDI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'x' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_QTPCCEN", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_QTPCCEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 4.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_CUSRP4 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_CUSRP4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_CUSRP1 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_CUSRP1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 5.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_CUSRP5 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_CUSRP5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_CUSRP3 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D1_CUSRP3" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD2
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor do Pre็o de Venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_PRCVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_PRCVEN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor total da nota fiscal.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_TOTAL" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo relativo ao produto em moeda' )
aAdd( aHlpPor, 'corrente.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_CUSTO1 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_CUSTO1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o unitแrio de tabela.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_PRUNIT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_PRUNIT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Devolvida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_QTDEDEV", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_QTDEDEV" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor da varia็ใo do preco unitario de' )
aAdd( aHlpPor, 'venda. Utilizado no cแlculo do reajuste' )
aAdd( aHlpPor, 'de pre็o.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_VARPRUN", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_VARPRUN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ faturada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_QTDEFAT", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_QTDEFAT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade a faturar.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_QTDAFAT", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_QTDAFAT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_CUSRP1 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_CUSRP1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 2.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_CUSRP2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_CUSRP2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_CUSRP3 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_CUSRP3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 4.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_CUSRP4 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_CUSRP4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 5.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_CUSRP5 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_CUSRP5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor unitario D. A.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD2_PRUNDA ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D2_PRUNDA" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD3
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de produto movimentado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo total da movimenta็ใo na moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_CUSTO1 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_CUSTO1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_CUSRP1 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_CUSRP1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 2.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_CUSRP2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_CUSRP2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 3.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_CUSRP3 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_CUSRP3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 4.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_CUSRP4 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_CUSRP4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo de Reposicao na Moeda 5.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_CUSRP5 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_CUSRP5" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitario Fixo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD3_CMFIXO ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D3_CMFIXO" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD4
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade suspensa de requisi็๖es' )
aAdd( aHlpPor, 'empe-nhadas.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD4_QSUSP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D4_QSUSP" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade original de requisi็๖es' )
aAdd( aHlpPor, 'empe-nhadas.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD4_QTDEORI", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D4_QTDEORI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo do empenho.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD4_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D4_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo para composi็ใo da quantidade' )
aAdd( aHlpPor, 'empenhada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD4_SLDEMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D4_SLDEMP" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD5
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Movimenta็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD5_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D5_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD5_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D5_QTSEGUM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD6
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD6_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D6_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor Unitแrio' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD6_VRUNIT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D6_VRUNIT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD7
//
aHlpPor := {}
aAdd( aHlpPor, 'Este  campo deve conter a Quantidade do' )
aAdd( aHlpPor, 'Produto Enviada ao CQ.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD7_QTDE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D7_QTDE" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo dos movimentos da baixa do CQ.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD7_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D7_SALDO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD7_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D7_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo do movimentos na segunda unidade' )
aAdd( aHlpPor, 'de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD7_SALDO2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D7_SALDO2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SD8
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do Movimento por Lote Fifo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD8_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D8_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do movimento por Lote Fifo' )
aAdd( aHlpPor, 'na Segunda Unidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD8_QT2UM  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D8_QT2UM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo Fifo na Moeda 1.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD8_CUSTO1 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D8_CUSTO1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Devolvida do Movimento.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD8_QTDDEV ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D8_QTDDEV" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade devolucao Final' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD8_QFIMDEV", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D8_QFIMDEV" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade dos lotes de entrada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD8_SD1DEV ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "D8_SD1DEV" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDA
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Original do movimento de' )
aAdd( aHlpPor, 'Sal-dos a distribuir.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDA_QTDORI ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DA_QTDORI" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo que ainda falta ser distribuido' )
aAdd( aHlpPor, 'nomovimento de Saldos a Distribuir.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDA_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DA_SALDO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDA_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DA_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Original do movimento de' )
aAdd( aHlpPor, 'Sal-dos a distribuir na 2a UM.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDA_QTDORI2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DA_QTDORI2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDB
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade a ser distribuida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDB_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DB_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDB_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DB_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade original da O.S. WMS se' )
aAdd( aHlpPor, 'ocorrer finaliza็ใo a menor (coletores' )
aAdd( aHlpPor, 'radiofrequ๊ncia).' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDB_QTDORI ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DB_QTDORI" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDC
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo da Composi็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDC_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DC_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Original da composi็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDC_QTDORIG", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DC_QTDORIG" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDC_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DC_QTSEGUM" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDD
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade a ser bloqueada/Liberada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDD_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DD_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo do Bloqueio' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDD_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DD_SALDO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Original do bloqueio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDD_QTDORIG", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DD_QTDORIG" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade na segunda unidade de medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDD_QTSEGUM", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DD_QTSEGUM" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo do Bloqueio na Segunda Unidade de' )
aAdd( aHlpPor, 'Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDD_SALDO2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DD_SALDO2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDF
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Sugerida Menos Quantidade em' )
aAdd( aHlpPor, 'Estoque e Quantidade de Pedidos' )
aAdd( aHlpPor, 'Pendentes.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDF_QTDSUG ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DF_QTDSUG" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Informada pelo Usuแrio' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDF_QTDINF ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DF_QTDINF" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor total do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDF_VLRTOT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DF_VLRTOT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDG
//
aHlpPor := {}
aAdd( aHlpPor, 'Valor Total do Movimento.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDG_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DG_TOTAL" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDG_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DG_SALDO" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDH
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade adquirida do produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDH_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DH_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo do movimento de cobertura.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDH_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DH_SALDO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do Documento de Origem.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDH_QTDNF  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DH_QTDNF" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDL
//
//
// Helps Tabela SDN
//
//
// Helps Tabela SDP
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Prevista em Pedido de Compra' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDP_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DP_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade jแ entregue do Pedido de' )
aAdd( aHlpPor, 'Compra' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDP_QTDENT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DP_QTDENT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDQ
//
aHlpPor := {}
aAdd( aHlpPor, 'Custo unitario na 1a moeda a ser' )
aAdd( aHlpPor, 'utilizado no calculo da reavalia็ใo do' )
aAdd( aHlpPor, 'custo m้dio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDQ_CM1    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DQ_CM1" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitario na 2a moeda a ser' )
aAdd( aHlpPor, 'utilizado no calculo da reavalia็ใo do' )
aAdd( aHlpPor, 'custo m้dio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDQ_CM2    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DQ_CM2" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitario na 3a moeda a ser' )
aAdd( aHlpPor, 'utilizado no calculo da reavalia็ใo do' )
aAdd( aHlpPor, 'custo m้dio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDQ_CM3    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DQ_CM3" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitario na 4a moeda a ser' )
aAdd( aHlpPor, 'utilizado no calculo da reavalia็ใo do' )
aAdd( aHlpPor, 'custo m้dio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDQ_CM4    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DQ_CM4" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Custo unitario na 5a moeda a ser' )
aAdd( aHlpPor, 'utilizado no calculo da reavalia็ใo do' )
aAdd( aHlpPor, 'custo m้dio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PDQ_CM5    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "DQ_CM5" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SDT
//
//
// Helps Tabela SDY
//
//
// Helps Tabela SF2
//
aHlpPor := {}
aAdd( aHlpPor, 'este campo deve conter a Varia็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PF2_VARIAC ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "F2_VARIAC" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SFA
//
aHlpPor := {}
aAdd( aHlpPor, 'Valor do estorno/baixa do CIAP.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFA_VALOR  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FA_VALOR" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SFE
//
aHlpPor := {}
aAdd( aHlpPor, 'Valor base da baixa do titulo que sera' )
aAdd( aHlpPor, 'utilizado para calcular o valor da' )
aAdd( aHlpPor, 'retencao' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFE_VALBASE", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FE_VALBASE" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SFK
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFK_QTDE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FK_QTDE" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SFN
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFN_QTDE   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FN_QTDE" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SFO
//
aHlpPor := {}
aAdd( aHlpPor, 'Saldo da Guia' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFO_SALDO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FO_SALDO" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Saldo Atual da Guia' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFO_SALDATU", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FO_SALDATU" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SFQ
//
//
// Helps Tabela SFT
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFT_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FT_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Pre็o unitแrio do item.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFT_PRCUNIT", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FT_PRCUNIT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Valor total do item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PFT_TOTAL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "FT_TOTAL" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SFW
//
//
// Helps Tabela SG1
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do componente necessแrio' )
aAdd( aHlpPor, 'paraa produ็ใo da quantidade base de um' )
aAdd( aHlpPor, 'con-junto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PG1_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "G1_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SG4
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do Produto na composi็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PG4_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "G4_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SG7
//
aHlpPor := {}
aAdd( aHlpPor, 'Usado apenas para integra็ใo PREACTOR.' )
aAdd( aHlpPor, 'Quantidade de Ferramenta a ser' )
aAdd( aHlpPor, 'utilizadana opera็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PG7_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "G7_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SGA
//
aHlpPor := {}
aAdd( aHlpPor, 'Valor a ser somado no Pre็o de Venda' )
aAdd( aHlpPor, 'quando utilizado este opcional.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PGA_PRCVEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "GA_PRCVEN" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SGB
//
aHlpPor := {}
aAdd( aHlpPor, 'Usado apenas para integra็ใo PREACTOR.' )
aAdd( aHlpPor, 'Define a quantidade de ferramenta dis-' )
aAdd( aHlpPor, 'ponivel para aquele turno/perํodo defi-' )
aAdd( aHlpPor, 'nido no calendario.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PGB_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "GB_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SGG
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do componente necessแrio para' )
aAdd( aHlpPor, 'a produ็ใo da quantidade base de um' )
aAdd( aHlpPor, 'conjunto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PGG_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "GG_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SGJ
//
aHlpPor := {}
aAdd( aHlpPor, 'Informe a Quantidade do Pedido de Venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PGJ_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "GJ_QUANT" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informe a Quantidade Empenhada para o' )
aAdd( aHlpPor, 'Pedido de Venda.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PGJ_QEMPN  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "GJ_QEMPN" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Informe a Quantidade Empenhada para o' )
aAdd( aHlpPor, 'Pedido de Venda, na segunda unidade de' )
aAdd( aHlpPor, 'medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PGJ_QEMPN2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "GJ_QEMPN2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SGO
//
//
// Helps Tabela SH6
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade produzida durante a opera็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PH6_QTDPROD", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "H6_QTDPROD" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade perdida durante a execu็ใo' )
aAdd( aHlpPor, 'daopera็ใo.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PH6_QTDPERD", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "H6_QTDPERD" + CRLF //"Atualizado o Help do campo "

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade produzida durante a opera็ใo' )
aAdd( aHlpPor, 'na Segunda Unidade de Medida.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PH6_QTDPRO2", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "H6_QTDPRO2" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SH8
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade alocada em uma opera็ao da' )
aAdd( aHlpPor, 'carga de mแquina.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PH8_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "H8_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SHC
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade a ser analizada.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PHC_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "HC_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SHD
//
aHlpPor := {}
aAdd( aHlpPor, 'Identifica a Quantidade a Produzir.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PHD_QUANT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "HD_QUANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SHM
//
//
// Helps Tabela SHN
//
aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PHN_CANT   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += STR0116 + "HN_CANT" + CRLF //"Atualizado o Help do campo "

//
// Helps Tabela SHY
//
cTexto += CRLF + STR0060 + " " + STR0137 + CRLF + Replicate( "-", 128 ) + CRLF + CRLF //"Final da Atualizacao"###"Helps de Campos"

Return {}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณESCEMPRESAบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para escolha de Empresa, montado pelo SM0_ บฑฑ
ฑฑบ          ณ Retorna vetor contendo as selecoes feitas.                 บฑฑ
ฑฑบ          ณ Se nao For marcada nenhuma o vetor volta vazio.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscEmpresa()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametro  nTipo                           ณ
//ณ 1  - Monta com Todas Empresas/Filiais      ณ
//ณ 2  - Monta so com Empresas                 ณ
//ณ 3  - Monta so com Filiais de uma Empresa   ณ
//ณ                                            ณ
//ณ Parametro  aMarcadas                       ณ
//ณ Vetor com Empresas/Filiais pre marcadas    ณ
//ณ                                            ณ
//ณ Parametro  cEmpSel                         ณ
//ณ Empresa que sera usada para montar selecao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

oDlg:cToolTip := STR0117 //"Tela para M๚ltiplas Sele็๕es de Empresas/Filiais"

oDlg:cTitle   := STR0118 //"Selecione a(s) Empresa(s) para Atualiza็ใo"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", STR0119 Size 178, 095 Of oDlg Pixel //"Empresa"
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt STR0120   Message  Size 40, 007 Pixel Of oDlg; //"Todos"###"Marca / Desmarca Todos"
on Click MarcaTodos( lChk, @aVetor, oLbx )

@ 123, 10 Button oButInv Prompt STR0122  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ; //"&Inverter"
Message STR0123 Of oDlg //"Inverter Sele็ใo"

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt STR0119 Size  40, 08 Of oDlg Pixel //"Empresa"
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message STR0124  Of oDlg //"Mแscara Empresa ( ?? )"
@ 123, 50 Button oButMarc Prompt STR0125    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ; //"&Marcar"
Message STR0126    Of oDlg //"Marcar usando mแscara ( ?? )"
@ 123, 80 Button oButDMar Prompt STR0127 Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ; //"&Desmarcar"
Message STR0128 Of oDlg //"Desmarcar usando mแscara ( ?? )"

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop STR0129  Enable Of oDlg //"Confirma a Sele็ใo"
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop STR0130 Enable Of oDlg //"Abandona a Sele็ใo"
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCATODOSบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para marcar/desmarcar todos os itens do    บฑฑ
ฑฑบ          ณ ListBox ativo                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณINVSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para inverter selecao do ListBox Ativo     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณRETSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar que monta o retorno com as selecoes        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ MARCAMAS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para marcar/desmarcar usando mascaras               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ VERTODOS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para verificar se estao todos marcardos    บฑฑ
ฑฑบ          ณ ou nao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MyOpenSM0บ Autor ณ TOTVS Protheus     บ Data ณ  17/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento abertura do SM0 modo exclusivo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.10.7 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MyOpenSM0(lShared)

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex( "SIGAMAT.IND" )
		Exit
	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen
	MsgStop( STR0052 + ; //"Nใo foi possํvel a abertura da tabela "
	IIf( lShared, STR0053, STR0054 ), STR0022 ) //"de empresas (SM0)."###"de empresas (SM0) de forma exclusiva."###"ATENวรO"
EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
