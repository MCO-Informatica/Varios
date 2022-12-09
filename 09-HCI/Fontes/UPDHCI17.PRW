#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDHCI17
Função de update de dicionários para compatibilização

@author Bruna Zechetti
@since  22/10/14
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDHCI17( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := "usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça um"
Local   cDesc4    := "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
Local   cDesc5    := "ocorram eventuais falhas, esse backup possa ser restaurado."
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
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDHCI17" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDHCI17" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Concluída." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			MsgStop( "Atualização não Realizada.", "UPDHCI17" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "UPDHCI17" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  29/07/14
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
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
		// Só adiciona no aRecnoSM0 se a empresa for diferente
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
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
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
			
			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3( @cTexto )


			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

			// Alteração física dos arquivos
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
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					cTexto += "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] + CRLF
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//------------------------------------
			// Atualiza o dicionário SX6
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6( @cTexto )
			
			RpcClearEnv()

		Next nI

		If MyOpenSm0(.T.)

			cAux += Replicate( "-", 128 ) + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF
			cAux += " Dados Ambiente" + CRLF
			cAux += " --------------------"  + CRLF
			cAux += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
			cAux += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
			cAux += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
			cAux += " DataBase...........: " + DtoC( dDataBase )  + CRLF
			cAux += " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
			cAux += " Environment........: " + GetEnvServer()  + CRLF
			cAux += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
			cAux += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
			cAux += " Versão.............: " + GetVersao(.T.)  + CRLF
			cAux += " Usuário TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
			cAux += " Computer Name......: " + GetComputerName() + CRLF

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				cAux += " "  + CRLF
				cAux += " Dados Thread" + CRLF
				cAux += " --------------------"  + CRLF
				cAux += " Usuário da Rede....: " + aInfo[nPos][1] + CRLF
				cAux += " Estação............: " + aInfo[nPos][2] + CRLF
				cAux += " Programa Inicial...: " + aInfo[nPos][5] + CRLF
				cAux += " Environment........: " + aInfo[nPos][6] + CRLF
				cAux += " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) )  + CRLF
			EndIf
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF

			cTexto := cAux + cTexto + CRLF

			cTexto += Replicate( "-", 128 ) + CRLF
			cTexto += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
			cTexto += Replicate( "-", 128 ) + CRLF

			cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cTexto )

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

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

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  29/07/14
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
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
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

cTexto  += "Ínicio da Atualização" + " SX3" + CRLF + CRLF

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_PYME"   , 0 } }


aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )

//
// Campos Tabela SZQ
//
aAdd( aSX3, { ;
	{ 'SZQ'																		, .T. }, ; //X3_ARQUIVO
	{ '37'																		, .T. }, ; //X3_ORDEM
	{ 'ZQ_XOBS'																	, .T. }, ; //X3_CAMPO
	{ 'M'																		, .T. }, ; //X3_TIPO
	{ 10																		, .T. }, ; //X3_TAMANHO
	{ 0																			, .T. }, ; //X3_DECIMAL
	{ 'Obs.Dia'																	, .T. }, ; //X3_TITULO
	{ 'Obs.Dia'																	, .T. }, ; //X3_TITSPA
	{ 'Obs.Dia'																	, .T. }, ; //X3_TITENG
	{ 'Observacao do dia'														, .T. }, ; //X3_DESCRIC
	{ 'Observacao do dia'														, .T. }, ; //X3_DESCSPA
	{ 'Observacao do dia'														, .T. }, ; //X3_DESCENG
	{ ''																		, .T. }, ; //X3_PICTURE
	{ ''																		, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)						, .T. }, ; //X3_USADO
	{ ''																		, .T. }, ; //X3_RELACAO
	{ ''																		, .T. }, ; //X3_F3
	{ 0																			, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)														, .T. }, ; //X3_RESERV
	{ ''																		, .T. }, ; //X3_CHECK
	{ ''																		, .T. }, ; //X3_TRIGGER
	{ 'U'																		, .T. }, ; //X3_PROPRI
	{ 'N'																		, .T. }, ; //X3_BROWSE
	{ 'A'																		, .T. }, ; //X3_VISUAL
	{ 'R'																		, .T. }, ; //X3_CONTEXT
	{ ''																		, .T. }, ; //X3_OBRIGAT
	{ ''																		, .T. }, ; //X3_VLDUSER
	{ ''																		, .T. }, ; //X3_CBOX
	{ ''																		, .T. }, ; //X3_CBOXSPA
	{ ''																		, .T. }, ; //X3_CBOXENG
	{ ''																		, .T. }, ; //X3_PICTVAR
	{ ''																		, .T. }, ; //X3_WHEN
	{ ''																		, .T. }, ; //X3_INIBRW
	{ ''																		, .T. }, ; //X3_GRPSXG
	{ ''																		, .T. }, ; //X3_FOLDER
	{ ''																		, .T. }, ; //X3_CONDSQL
	{ ''																		, .T. }, ; //X3_CHKSQL
	{ ''																		, .T. }, ; //X3_IDXSRV
	{ 'N'																		, .T. }, ; //X3_ORTOGRA
	{ ''																		, .T. }, ; //X3_TELA
	{ ''																		, .T. }, ; //X3_POSLGT
	{ 'N'																		, .T. }, ; //X3_IDXFLD
	{ ''																		, .T. }, ; //X3_PYME
	{ ''																		, .T. }} ) //X3_AGRUP

aAdd( aSX3, { ;
	{ 'SZQ'																		, .T. }, ; //X3_ARQUIVO
	{ '38'																		, .T. }, ; //X3_ORDEM
	{ 'ZQ_XHISTOR'																, .T. }, ; //X3_CAMPO
	{ 'M'																		, .T. }, ; //X3_TIPO
	{ 10																		, .T. }, ; //X3_TAMANHO
	{ 0																			, .T. }, ; //X3_DECIMAL
	{ 'Historico'																, .T. }, ; //X3_TITULO
	{ 'Historico'																, .T. }, ; //X3_TITSPA
	{ 'Historico'																, .T. }, ; //X3_TITENG
	{ 'Historico de atendimento'												, .T. }, ; //X3_DESCRIC
	{ 'Historico de atendimento'												, .T. }, ; //X3_DESCSPA
	{ 'Historico de atendimento'												, .T. }, ; //X3_DESCENG
	{ ''																		, .T. }, ; //X3_PICTURE
	{ ''																		, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)						, .T. }, ; //X3_USADO
	{ 'Iif(!INCLUI,MSMM(SZQ->ZQ_HISTOR),"")'									, .T. }, ; //X3_RELACAO
	{ ''																		, .T. }, ; //X3_F3
	{ 0																			, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)														, .T. }, ; //X3_RESERV
	{ ''																		, .T. }, ; //X3_CHECK
	{ ''																		, .T. }, ; //X3_TRIGGER
	{ 'U'																		, .T. }, ; //X3_PROPRI
	{ 'S'																		, .T. }, ; //X3_BROWSE
	{ 'A'																		, .T. }, ; //X3_VISUAL
	{ 'R'																		, .T. }, ; //X3_CONTEXT
	{ ''																		, .T. }, ; //X3_OBRIGAT
	{ ''																		, .T. }, ; //X3_VLDUSER
	{ ''																		, .T. }, ; //X3_CBOX
	{ ''																		, .T. }, ; //X3_CBOXSPA
	{ ''																		, .T. }, ; //X3_CBOXENG
	{ ''																		, .T. }, ; //X3_PICTVAR
	{ ''																		, .T. }, ; //X3_WHEN
	{ ''																		, .T. }, ; //X3_INIBRW
	{ ''																		, .T. }, ; //X3_GRPSXG
	{ ''																		, .T. }, ; //X3_FOLDER
	{ ''																		, .T. }, ; //X3_CONDSQL
	{ ''																		, .T. }, ; //X3_CHKSQL
	{ ''																		, .T. }, ; //X3_IDXSRV
	{ 'N'																		, .T. }, ; //X3_ORTOGRA
	{ ''																		, .T. }, ; //X3_TELA
	{ ''																		, .T. }, ; //X3_POSLGT
	{ 'N'																		, .T. }, ; //X3_IDXFLD
	{ ''																		, .T. }, ; //X3_PYME
	{ ''																		, .T. }} ) //X3_AGRUP

aAdd( aSX3, { ;
	{ 'SZQ'																		, .F. }, ; //X3_ARQUIVO
	{ '07'																		, .F. }, ; //X3_ORDEM
	{ 'ZQ_NOME'																	, .F. }, ; //X3_CAMPO
	{ 'C'																		, .F. }, ; //X3_TIPO
	{ 15																		, .F. }, ; //X3_TAMANHO
	{ 0																			, .F. }, ; //X3_DECIMAL
	{ 'Cliente'																	, .F. }, ; //X3_TITULO
	{ 'Cliente'																	, .F. }, ; //X3_TITSPA
	{ 'Cliente'																	, .F. }, ; //X3_TITENG
	{ 'Cliente'																	, .F. }, ; //X3_DESCRIC
	{ 'Cliente'																	, .F. }, ; //X3_DESCSPA
	{ 'Cliente'																	, .F. }, ; //X3_DESCENG
	{ '@!'																		, .F. }, ; //X3_PICTURE
	{ ''																		, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)						, .F. }, ; //X3_USADO
	{ ''																		, .F. }, ; //X3_RELACAO
	{ ''																		, .F. }, ; //X3_F3
	{ 0																			, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)														, .F. }, ; //X3_RESERV
	{ ''																		, .F. }, ; //X3_CHECK
	{ ''																		, .F. }, ; //X3_TRIGGER
	{ 'U'																		, .F. }, ; //X3_PROPRI
	{ 'S'																		, .F. }, ; //X3_BROWSE
	{ 'A'																		, .F. }, ; //X3_VISUAL
	{ 'R'																		, .F. }, ; //X3_CONTEXT
	{ ''																		, .F. }, ; //X3_OBRIGAT
	{ ''																		, .F. }, ; //X3_VLDUSER
	{ ''																		, .F. }, ; //X3_CBOX
	{ ''																		, .F. }, ; //X3_CBOXSPA
	{ ''																		, .F. }, ; //X3_CBOXENG
	{ ''																		, .F. }, ; //X3_PICTVAR
	{ '.F.'																		, .T. }, ; //X3_WHEN
	{ ''																		, .F. }, ; //X3_INIBRW
	{ ''																		, .F. }, ; //X3_GRPSXG
	{ ''																		, .F. }, ; //X3_FOLDER
	{ ''																		, .F. }, ; //X3_CONDSQL
	{ ''																		, .F. }, ; //X3_CHKSQL
	{ ''																		, .F. }, ; //X3_IDXSRV
	{ 'N'																		, .F. }, ; //X3_ORTOGRA
	{ ''																		, .F. }, ; //X3_TELA
	{ ''																		, .F. }, ; //X3_POSLGT
	{ 'N'																		, .F. }, ; //X3_IDXFLD
	{ ''																		, .F. }, ; //X3_PYME
	{ ''																		, .F. }} ) //X3_AGRUP

aAdd( aSX3, { ;
	{ 'SZQ'																		, .F. }, ; //X3_ARQUIVO
	{ '08'																		, .F. }, ; //X3_ORDEM
	{ 'ZQ_CNPJ'																	, .F. }, ; //X3_CAMPO
	{ 'C'																		, .F. }, ; //X3_TIPO
	{ 14																		, .F. }, ; //X3_TAMANHO
	{ 0																			, .F. }, ; //X3_DECIMAL
	{ 'CNPJ'																	, .F. }, ; //X3_TITULO
	{ 'CNPJ'																	, .F. }, ; //X3_TITSPA
	{ 'CNPJ'																	, .F. }, ; //X3_TITENG
	{ 'CNPJ'												   					, .F. }, ; //X3_DESCRIC
	{ 'CNPJ'																	, .F. }, ; //X3_DESCSPA
	{ 'CNPJ'																	, .F. }, ; //X3_DESCENG
	{ '@R 99.999.999/9999-99'													, .F. }, ; //X3_PICTURE
	{ ''																		, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)						, .F. }, ; //X3_USADO
	{ ''																		, .F. }, ; //X3_RELACAO
	{ ''																		, .F. }, ; //X3_F3
	{ 0																			, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)														, .F. }, ; //X3_RESERV
	{ ''																		, .F. }, ; //X3_CHECK
	{ ''																		, .F. }, ; //X3_TRIGGER
	{ 'U'																		, .F. }, ; //X3_PROPRI
	{ 'S'																		, .F. }, ; //X3_BROWSE
	{ 'A'																		, .F. }, ; //X3_VISUAL
	{ 'R'																		, .F. }, ; //X3_CONTEXT
	{ ''																		, .F. }, ; //X3_OBRIGAT
	{ ''																		, .F. }, ; //X3_VLDUSER
	{ ''																		, .F. }, ; //X3_CBOX
	{ ''																		, .F. }, ; //X3_CBOXSPA
	{ ''																		, .F. }, ; //X3_CBOXENG
	{ ''																		, .F. }, ; //X3_PICTVAR
	{ '.F.'																		, .T. }, ; //X3_WHEN
	{ ''																		, .F. }, ; //X3_INIBRW
	{ ''																		, .F. }, ; //X3_GRPSXG
	{ ''																		, .F. }, ; //X3_FOLDER
	{ ''																		, .F. }, ; //X3_CONDSQL
	{ ''																		, .F. }, ; //X3_CHKSQL
	{ ''																		, .F. }, ; //X3_IDXSRV
	{ 'N'																		, .F. }, ; //X3_ORTOGRA
	{ ''																		, .F. }, ; //X3_TELA
	{ ''																		, .F. }, ; //X3_POSLGT
	{ 'N'																		, .F. }, ; //X3_IDXFLD
	{ ''																		, .F. }, ; //X3_PYME
	{ ''																		, .F. }} ) //X3_AGRUP

aAdd( aSX3, { ;
	{ 'SZQ'																		, .T. }, ; //X3_ARQUIVO
	{ '11'																		, .T. }, ; //X3_ORDEM
	{ 'ZQ_PROJETO'																, .T. }, ; //X3_CAMPO
	{ 'C'																		, .T. }, ; //X3_TIPO
	{ 06																		, .T. }, ; //X3_TAMANHO
	{ 0																			, .T. }, ; //X3_DECIMAL
	{ 'Projeto'																	, .T. }, ; //X3_TITULO
	{ 'Projeto'																	, .T. }, ; //X3_TITSPA
	{ 'Projeto'																	, .T. }, ; //X3_TITENG
	{ 'Codigo do Projeto'														, .T. }, ; //X3_DESCRIC
	{ 'Codigo do Projeto'														, .T. }, ; //X3_DESCSPA
	{ 'Codigo do Projeto'														, .T. }, ; //X3_DESCENG
	{ '@!'																		, .T. }, ; //X3_PICTURE
	{ ''																		, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)						, .T. }, ; //X3_USADO
	{ ''																		, .T. }, ; //X3_RELACAO
	{ 'AD1'																		, .T. }, ; //X3_F3
	{ 0																			, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)														, .T. }, ; //X3_RESERV
	{ ''																		, .T. }, ; //X3_CHECK
	{ ''																		, .T. }, ; //X3_TRIGGER
	{ 'U'																		, .T. }, ; //X3_PROPRI
	{ 'N'																		, .T. }, ; //X3_BROWSE
	{ 'A'																		, .T. }, ; //X3_VISUAL
	{ 'R'																		, .T. }, ; //X3_CONTEXT
	{ ''																		, .T. }, ; //X3_OBRIGAT
	{ ''																		, .T. }, ; //X3_VLDUSER
	{ ''																		, .T. }, ; //X3_CBOX
	{ ''																		, .T. }, ; //X3_CBOXSPA
	{ ''																		, .T. }, ; //X3_CBOXENG
	{ ''																		, .T. }, ; //X3_PICTVAR
	{ ''																		, .T. }, ; //X3_WHEN
	{ ''																		, .T. }, ; //X3_INIBRW
	{ ''																		, .T. }, ; //X3_GRPSXG
	{ ''																		, .T. }, ; //X3_FOLDER
	{ ''																		, .T. }, ; //X3_CONDSQL
	{ ''																		, .T. }, ; //X3_CHKSQL
	{ ''																		, .T. }, ; //X3_IDXSRV
	{ 'N'																		, .T. }, ; //X3_ORTOGRA
	{ ''																		, .T. }, ; //X3_TELA
	{ ''																		, .T. }, ; //X3_POSLGT
	{ 'N'																		, .T. }, ; //X3_IDXFLD
	{ ''																		, .T. }, ; //X3_PYME
	{ ''																		, .T. }} ) //X3_AGRUP

//
// Atualizando dicionário
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq][1]+x[nPosOrd][1]+x[nPosCpo][1] < y[nPosArq][1]+y[nPosOrd][1]+y[nPosCpo][1] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG][1] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG][1] ) )
			If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
				aSX3[nI][nPosTam][1] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq][1] $ cAlias )
		cAlias += aSX3[nI][nPosArq][1] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq][1] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo][1], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq][1] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq][1]

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
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo][1] )

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG][1]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
					aSX3[nI][nPosTam][1] := SXG->XG_SIZE
					AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NÃO atualizado e foi mantido em [" + ;
					AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF + ;
					"   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF )
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
			If aSX3[nI][nJ][2]
				cX3Campo := AllTrim( aEstrut[nJ][1] )
				cX3Dado  := SX3->( FieldGet( aEstrut[nJ][2] ) )

				If  aEstrut[nJ][2] > 0 .AND. ;
					PadR( StrTran( AllToChar( cX3Dado ), " ", "" ), 250 ) <> ;
					PadR( StrTran( AllToChar( aSX3[nI][nJ][1] ), " ", "" ), 250 ) .AND. ;
					!cX3Campo == "X3_ORDEM"

					cMsg := "O campo " + aSX3[nI][nPosCpo][1] + " está com o " + cX3Campo + ;
					" com o conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( cX3Dado ) ) + "]" + CRLF + ;
					"que será substituído pelo NOVO conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( aSX3[nI][nJ][1] ) ) + "]" + CRLF + ;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SX3" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SX3 e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SX3 que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						AutoGrLog( "Alterado campo " + aSX3[nI][nPosCpo][1] + CRLF + ;
						"   " + PadR( cX3Campo, 10 ) + " de [" + AllToChar( cX3Dado ) + "]" + CRLF + ;
						"            para [" + AllToChar( aSX3[nI][nJ][1] )           + "]" + CRLF )

						RecLock( "SX3", .F. )
						FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] )
						MsUnLock()
					EndIf

				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX6
Função de processamento da gravação do SX6 - Parâmetros

@author TOTVS Protheus
@since  29/07/14
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6( cTexto )
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

cTexto  += "Ínicio da Atualização" + " SX6" + CRLF + CRLF

aEstrut := { "X6_FIL"    , "X6_VAR"  , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , "X6_DSCSPA1",;
             "X6_DSCENG1", "X6_DESC2", "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", "X6_CONTENG", "X6_PROPRI" , "X6_PYME" }

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_HC017DC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define a data de corte para demonstracao dos '							, ; //X6_DESCRIC
	'Define a data de corte para demonstracao dos '							, ; //X6_DSCSPA
	'Define a data de corte para demonstracao dos '							, ; //X6_DSCENG
	'processos de follow up (TRB da SZQ).'									, ; //X6_DESC1
	'processos de follow up (TRB da SZQ).'									, ; //X6_DSCSPA1
	'processos de follow up (TRB da SZQ).'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20150101'																, ; //X6_CONTEUD
	'20150101'																, ; //X6_CONTSPA
	'20150101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( "SX6" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )
	lContinua := .F.
	lReclock  := .F.

	If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
		lContinua := .T.
		lReclock  := .T.
		cTexto += "Foi incluído o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]"+ CRLF
	EndIf

	If lContinua
		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + "/"
		EndIf

		RecLock( "SX6", lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SX6)..." )

Next nI

cTexto += CRLF + "Final da Atualização" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
             Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
//---------------------------------------------
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

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

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
Message "Inverter Seleção" Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando máscara ( ?? )"    Of oDlg
@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando máscara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Seleção"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Seleção" Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Função auxiliar para inverter a seleção do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Função auxiliar para verificar se estão todos marcados ou não

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Função de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  29/07/14
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
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
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
