#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDEXP
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDGUA01( cEmpAmb, cFilAmb )

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
Local   cMsg      := ""
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

	If GetVersao(.F.) < "12" .OR. ( FindFunction( "MPDicInDB" ) .AND. !MPDicInDB() )
		cMsg := "Este update NÃO PODE ser executado neste Ambiente." + CRLF + CRLF + ;
				"Os arquivos de dicionários se encontram em formato ISAM (" + GetDbExtension() + ") e este update está preparado " + ;
				"para atualizar apenas ambientes com dicionários no Banco de Dados."

		If lAuto
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( cMsg )
			ConOut( DToC(Date()) + "|" + Time() + cMsg )
		Else
			MsgInfo( cMsg )
		EndIf

		Return NIL
	EndIf

	If lAuto
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else

		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDEXP" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDEXP" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Realizada." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualização não Realizada." )

		EndIf

	Else
		Final( "Atualização não Realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
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

			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versão.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estação............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )

			//------------------------------------
			// Atualiza o dicionário SX2
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()

			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3()

			//------------------------------------
			// Atualiza o dicionário SIX
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()

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
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//------------------------------------
			// Atualiza os helps
			//------------------------------------
			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuHlp()

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

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
/*/{Protheus.doc} FSAtuSX2
Função de processamento da gravação do SX2 - Arquivos

@author TOTVS Protheus
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX2()
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cCpoUpd   := "X2_ROTINA /X2_UNICO  /X2_DISPLAY/X2_SYSOBJ /X2_USROBJ /X2_POSLGT /"
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela ZB1
//
aAdd( aSX2, { ;
	'ZB1'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZB1'+cEmpr																, ; //X2_ARQUIVO
	'REGRA COMISSAO - SFA'													, ; //X2_NOME
	'REGRA COMISSAO - SFA'													, ; //X2_NOMESPA
	'REGRA COMISSAO - SFA'													, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZB2
//
aAdd( aSX2, { ;
	'ZB2'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZB2'+cEmpr																, ; //X2_ARQUIVO
	'COMISSAO ACRESCIMO/DECRESSIMO'											, ; //X2_NOME
	'COMISSAO ACRESCIMO/DECRESSIMO'											, ; //X2_NOMESPA
	'COMISSAO ACRESCIMO/DECRESSIMO'											, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZB3
//
aAdd( aSX2, { ;
	'ZB3'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZB3'+cEmpr																, ; //X2_ARQUIVO
	'CLIENTE FRETE'															, ; //X2_NOME
	'CLIENTE FRETE'															, ; //X2_NOMESPA
	'CLIENTE FRETE'															, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZB4
//
aAdd( aSX2, { ;
	'ZB4'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZB4'+cEmpr																, ; //X2_ARQUIVO
	'TABELA X CONDICAO'														, ; //X2_NOME
	'TABELA X CONDICAO'														, ; //X2_NOMESPA
	'TABELA X CONDICAO'														, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZB5
//
aAdd( aSX2, { ;
	'ZB5'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZB5'+cEmpr																, ; //X2_ARQUIVO
	'PEDIDOS GUARANI'														, ; //X2_NOME
	'PEDIDOS GUARANI'														, ; //X2_NOMESPA
	'PEDIDOS GUARANI'														, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZB6
//
aAdd( aSX2, { ;
	'ZB6'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZB6'+cEmpr																, ; //X2_ARQUIVO
	'ITEM PEDIDO GUARANI'													, ; //X2_NOME
	'ITEM PEDIDO GUARANI'													, ; //X2_NOMESPA
	'ITEM PEDIDO GUARANI'													, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZBZ
//
aAdd( aSX2, { ;
	'ZBZ'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZBZ'+cEmpr																, ; //X2_ARQUIVO
	'REGRA COMISSAO - SFA'													, ; //X2_NOME
	'REGRA COMISSAO - SFA'													, ; //X2_NOMESPA
	'REGRA COMISSAO - SFA'													, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZZZ
//
aAdd( aSX2, { ;
	'ZZZ'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZZZ'+cEmpr																, ; //X2_ARQUIVO
	'REGRA COMISSAO - SFA'													, ; //X2_NOME
	'REGRA COMISSAO - SFA'													, ; //X2_NOMESPA
	'REGRA COMISSAO - SFA'													, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			AutoGrLog( "Foi incluída a tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf
			EndIf
		Next nJ
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			RecLock( "SX2", .F. )
			SX2->X2_UNICO := aSX2[nI][12]
			MsUnlock()

			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
			EndIf

			AutoGrLog( "Foi alterada a chave única da tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .F. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If PadR( aEstrut[nJ], 10 ) $ cCpoUpd
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf

			EndIf
		Next nJ
		MsUnLock()

	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local cX3Campo  := ""
Local cX3Dado   := ""
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

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


//
// Campos Tabela SA1
//
aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'D1'																	, ; //X3_ORDEM
	'A1_EMAILNF'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'E-mail NFe'															, ; //X3_TITULO
	'E-mail NFe'															, ; //X3_TITSPA
	'E-mail NFe'															, ; //X3_TITENG
	'E-mail NFe'															, ; //X3_DESCRIC
	'E-mail NFe'															, ; //X3_DESCSPA
	'E-mail NFe'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'J1'																	, ; //X3_ORDEM
	'A1_X_OBSFA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	80																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obs. p/ Fat.'															, ; //X3_TITULO
	'Obs. p/ Fat.'															, ; //X3_TITSPA
	'Obs. p/ Fat.'															, ; //X3_TITENG
	'Obs. p/ Faturamento'													, ; //X3_DESCRIC
	'Obs. p/ Faturamento'													, ; //X3_DESCSPA
	'Obs. p/ Faturamento'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'R5'																	, ; //X3_ORDEM
	'A1_XPERCFR'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Perc Frete'															, ; //X3_TITULO
	'Perc Frete'															, ; //X3_TITSPA
	'Perc Frete'															, ; //X3_TITENG
	'Perc Frete'															, ; //X3_DESCRIC
	'Perc Frete'															, ; //X3_DESCSPA
	'Perc Frete'															, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'R6'																	, ; //X3_ORDEM
	'A1_XPRACA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Praca'																	, ; //X3_TITULO
	'Praca'																	, ; //X3_TITSPA
	'Praca'																	, ; //X3_TITENG
	'Praca'																	, ; //X3_DESCRIC
	'Praca'																	, ; //X3_DESCSPA
	'Praca'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'R7'																	, ; //X3_ORDEM
	'A1_XPRXMEN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Prz Min Entr'															, ; //X3_TITULO
	'Prz Min Entr'															, ; //X3_TITSPA
	'Prz Min Entr'															, ; //X3_TITENG
	'Prz Min Entr'															, ; //X3_DESCRIC
	'Prz Min Entr'															, ; //X3_DESCSPA
	'Prz Min Entr'															, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'R8'																	, ; //X3_ORDEM
	'A1_XPRZMFT'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Prz Max Fatu'															, ; //X3_TITULO
	'Prz Max Fatu'															, ; //X3_TITSPA
	'Prz Max Fatu'															, ; //X3_TITENG
	'Prz Max Fatu'															, ; //X3_DESCRIC
	'Prz Max Fatu'															, ; //X3_DESCSPA
	'Prz Max Fatu'															, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'R9'																	, ; //X3_ORDEM
	'A1_XTPCFRE'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tp Calc Fret'															, ; //X3_TITULO
	'Tp Calc Fret'															, ; //X3_TITSPA
	'Tp Calc Fret'															, ; //X3_TITENG
	'Tp Calc Fret'															, ; //X3_DESCRIC
	'Tp Calc Fret'															, ; //X3_DESCSPA
	'Tp Calc Fret'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'0=Nao calcula;1=Calculo manual;2=Calculo automatico;3=Frete Embutido'		, ; //X3_CBOX
	'0=Nao calcula;1=Calculo manual;2=Calculo automatico;3=Frete Embutido'		, ; //X3_CBOXSPA
	'0=Nao calcula;1=Calculo manual;2=Calculo automatico;3=Frete Embutido'		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SA3
//
aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'A3_COMIS2'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Comis Superv'															, ; //X3_TITULO
	'Comis Superv'															, ; //X3_TITSPA
	'Comis Superv'															, ; //X3_TITENG
	'Comis Superv'															, ; //X3_DESCRIC
	'Comis Superv'															, ; //X3_DESCSPA
	'Comis Superv'															, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'A3_COMIS3'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Comis Gerent'															, ; //X3_TITULO
	'Comis Gerent'															, ; //X3_TITSPA
	'Comis Gerent'															, ; //X3_TITENG
	'Comis Gerent'															, ; //X3_DESCRIC
	'Comis Gerent'															, ; //X3_DESCSPA
	'Comis Gerent'															, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'81'																	, ; //X3_ORDEM
	'A3_RAMAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	4																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ramal'																	, ; //X3_TITULO
	'Ramal'																	, ; //X3_TITSPA
	'Ramal'																	, ; //X3_TITENG
	'Ramal'																	, ; //X3_DESCRIC
	'Ramal'																	, ; //X3_DESCSPA
	'Ramal'																	, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'84'																	, ; //X3_ORDEM
	'A3_XMETA'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Meta Regiao'															, ; //X3_TITULO
	'Meta Regiao'															, ; //X3_TITSPA
	'Meta Regiao'															, ; //X3_TITENG
	'Meta por Regiao (%)'													, ; //X3_DESCRIC
	'Meta por Regiao (%)'													, ; //X3_DESCSPA
	'Meta por Regiao (%)'													, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'A0'																	, ; //X3_ORDEM
	'A3_XAFV'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Envia AFV?'															, ; //X3_TITULO
	'Envia AFV?'															, ; //X3_TITSPA
	'Envia AFV?'															, ; //X3_TITENG
	'Envia AFV?'															, ; //X3_DESCRIC
	'Envia AFV?'															, ; //X3_DESCSPA
	'Envia AFV?'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	"'S'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'S=Sim;N=Nao'															, ; //X3_CBOX
	'S=Sim;N=Nao'															, ; //X3_CBOXSPA
	'S=Sim;N=Nao'															, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'A1'																	, ; //X3_ORDEM
	'A3_XTABS'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tabelas'																, ; //X3_TITULO
	'Tabelas'																, ; //X3_TITSPA
	'Tabelas'																, ; //X3_TITENG
	'Tabelas'																, ; //X3_DESCRIC
	'Tabelas'																, ; //X3_DESCSPA
	'Tabelas'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SC5
//
aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'C5_XTEMRED'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tem Redesp?'															, ; //X3_TITULO
	'Tem Redesp?'															, ; //X3_TITSPA
	'Tem Redesp?'															, ; //X3_TITENG
	'Tem Redespacho?'														, ; //X3_DESCRIC
	'Tem Redespacho?'														, ; //X3_DESCSPA
	'Tem Redespacho?'														, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"S"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	'Pertence("SN")'														, ; //X3_VLDUSER
	'S=Sim;N=Nao'															, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'C5_DTENTR'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Data Entrega'															, ; //X3_TITULO
	'Data Entrega'															, ; //X3_TITSPA
	'Data Entrega'															, ; //X3_TITENG
	'Data Entrega'															, ; //X3_DESCRIC
	'Data Entrega'															, ; //X3_DESCSPA
	'Data Entrega'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'C5_X_CPDES'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Condicao'																, ; //X3_TITULO
	'Condicao'																, ; //X3_TITSPA
	'Condicao'																, ; //X3_TITENG
	'Condicao de Pagamento'													, ; //X3_DESCRIC
	'Condicao de Pagamento'													, ; //X3_DESCSPA
	'Condicao de Pagamento'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'IF(!INCLUI,POSICIONE("SE4",1,XFILIAL("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"),"")', ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'C5_X_MENRO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Men Romaneio'															, ; //X3_TITULO
	'Men Romaneio'															, ; //X3_TITSPA
	'Men Romaneio'															, ; //X3_TITENG
	'Men Romaneio'															, ; //X3_DESCRIC
	'Men Romaneio'															, ; //X3_DESCSPA
	'Men Romaneio'															, ; //X3_DESCENG
	'@S45'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'texto().or.vazio()'													, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'C5_TPFREDE'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tp Frete Red'															, ; //X3_TITULO
	'Tp Frete Red'															, ; //X3_TITSPA
	'Tp Frete Red'															, ; //X3_TITENG
	'Tp Frete Red'															, ; //X3_DESCRIC
	'Tp Frete Red'															, ; //X3_DESCSPA
	'Tp Frete Red'															, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"D"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Pertence("RD")'														, ; //X3_VLDUSER
	'R=Por Conta Remetente;D=Por Conta Destinatario'						, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'C5_X_CODRE'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Regra Desc.'															, ; //X3_TITULO
	'Regra Desc.'															, ; //X3_TITSPA
	'Regra Desc.'															, ; //X3_TITENG
	'Regra Desconto'														, ; //X3_DESCRIC
	'Regra Desconto'														, ; //X3_DESCSPA
	'Regra Desconto'														, ; //X3_DESCENG
	'@R 99/999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'C5_X_VEND1'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	65																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome Vend1'															, ; //X3_TITULO
	'Nome Vend1'															, ; //X3_TITSPA
	'Nome Vend1'															, ; //X3_TITENG
	'Nome do Vendedor 1'													, ; //X3_DESCRIC
	'Nome do Vendedor 1'													, ; //X3_DESCSPA
	'Nome do Vendedor 1'													, ; //X3_DESCENG
	'@S45'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'IF(!INCLUI,POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_NOME"),"")'	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'2'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'38'																	, ; //X3_ORDEM
	'C5_USERINC'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	13																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Us. Inclusao'															, ; //X3_TITULO
	'Us. Inclusao'															, ; //X3_TITSPA
	'Us. Inclusao'															, ; //X3_TITENG
	'Us. Inclusao'															, ; //X3_DESCRIC
	'Us. Inclusao'															, ; //X3_DESCSPA
	'Us. Inclusao'															, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'SubStr(cUsuario,7,15)'													, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'69'																	, ; //X3_ORDEM
	'C5_X_BOX'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Box'																	, ; //X3_TITULO
	'Box'																	, ; //X3_TITSPA
	'Box'																	, ; //X3_TITENG
	'Box'																	, ; //X3_DESCRIC
	'Box'																	, ; //X3_DESCSPA
	'Box'																	, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'A1'																	, ; //X3_ORDEM
	'C5_HORA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hora'																	, ; //X3_TITULO
	'Hora'																	, ; //X3_TITSPA
	'Time'																	, ; //X3_TITENG
	'Horario de Lancamento'													, ; //X3_DESCRIC
	'Horario de Lancamento'													, ; //X3_DESCSPA
	'Horario de Lancamento'													, ; //X3_DESCENG
	'99:99'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'IF(!INCLUI,"",TIME())'													, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'E2'																	, ; //X3_ORDEM
	'C5_X_PBRUT'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	3																		, ; //X3_DECIMAL
	'Peso Bruto'															, ; //X3_TITULO
	'Peso Bruto'															, ; //X3_TITSPA
	'Peso Bruto'															, ; //X3_TITENG
	'Peso Bruto'															, ; //X3_DESCRIC
	'Peso Bruto'															, ; //X3_DESCSPA
	'Peso Bruto'															, ; //X3_DESCENG
	'@E 99,999,999.999'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'F4'																	, ; //X3_ORDEM
	'C5_XVALFRR'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'$ Frete Red'															, ; //X3_TITULO
	'$ Frete Red'															, ; //X3_TITSPA
	'$ Frete Red'															, ; //X3_TITENG
	'$ Frete Red'															, ; //X3_DESCRIC
	'$ Frete Red'															, ; //X3_DESCSPA
	'$ Frete Red'															, ; //X3_DESCENG
	'@E 999,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'F5'																	, ; //X3_ORDEM
	'C5_XDATALI'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Data Liberac'															, ; //X3_TITULO
	'Data Liberac'															, ; //X3_TITSPA
	'Data Liberac'															, ; //X3_TITENG
	'Data Liberac'															, ; //X3_DESCRIC
	'Data Liberac'															, ; //X3_DESCSPA
	'Data Liberac'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'F6'																	, ; //X3_ORDEM
	'C5_XOBS'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obs Gua'																, ; //X3_TITULO
	'Obs Gua'																, ; //X3_TITSPA
	'Obs Gua'																, ; //X3_TITENG
	'Obs Gua     Obs Gua'													, ; //X3_DESCRIC
	'Obs Gua'																, ; //X3_DESCSPA
	'Obs Gua'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'F7'																	, ; //X3_ORDEM
	'C5_XOBSINT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obs Int Gua'															, ; //X3_TITULO
	'Obs Int Gua'															, ; //X3_TITSPA
	'Obs Int Gua'															, ; //X3_TITENG
	'Obs Int Gua'															, ; //X3_DESCRIC
	'Obs Int Gua'															, ; //X3_DESCSPA
	'Obs Int Gua'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'F8'																	, ; //X3_ORDEM
	'C5_XOC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'OC Guarani'															, ; //X3_TITULO
	'OC Guarani'															, ; //X3_TITSPA
	'OC Guarani'															, ; //X3_TITENG
	'OC Guarani'															, ; //X3_DESCRIC
	'OC Guarani'															, ; //X3_DESCSPA
	'OC Guarani'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'F9'																	, ; //X3_ORDEM
	'C5_XDTPENT'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Pr En Gua'															, ; //X3_TITULO
	'Dt Pr En Gua'															, ; //X3_TITSPA
	'Dt Pr En Gua'															, ; //X3_TITENG
	'Dt Pr En Gua'															, ; //X3_DESCRIC
	'Dt Pr En Gua'															, ; //X3_DESCSPA
	'Dt Pr En Gua'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'H7'																	, ; //X3_ORDEM
	'C5_XPEDEMP'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ped Guarani'															, ; //X3_TITULO
	'Ped Guarani'															, ; //X3_TITSPA
	'Ped Guarani'															, ; //X3_TITENG
	'Ped Guarani'															, ; //X3_DESCRIC
	'Ped Guarani'															, ; //X3_DESCSPA
	'Ped Guarani'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SC6
//
aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'C6_X_PRLST'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	11																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Preco Tabela'															, ; //X3_TITULO
	'Pr Lista 2'															, ; //X3_TITSPA
	'Pr Lista 2'															, ; //X3_TITENG
	'Preco de Lista 2'														, ; //X3_DESCRIC
	'Preco de Lista 2'														, ; //X3_DESCSPA
	'Preco de Lista 2'														, ; //X3_DESCENG
	'@E 99,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'C6_X_DESCO'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Desc. Maximo'															, ; //X3_TITULO
	'Desc. Maximo'															, ; //X3_TITSPA
	'Desc. Maximo'															, ; //X3_TITENG
	'Desc. Maximo Permitido'												, ; //X3_DESCRIC
	'Desc. Maximo Permitido'												, ; //X3_DESCSPA
	'Desc. Maximo Permitido'												, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'C6_X_PBRUT'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	3																		, ; //X3_DECIMAL
	'Peso Bruto'															, ; //X3_TITULO
	'Peso Bruto'															, ; //X3_TITSPA
	'Peso Bruto'															, ; //X3_TITENG
	'Peso Bruto'															, ; //X3_DESCRIC
	'Peso Bruto'															, ; //X3_DESCSPA
	'Peso Bruto'															, ; //X3_DESCENG
	'@E 99,999,999.999'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'C6_ZPECUB'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	4																		, ; //X3_DECIMAL
	'Peso Cubado'															, ; //X3_TITULO
	'Peso Cubado'															, ; //X3_TITSPA
	'Peso Cubado'															, ; //X3_TITENG
	'Peso Cubado'															, ; //X3_DESCRIC
	'Peso Cubado'															, ; //X3_DESCSPA
	'Peso Cubado'															, ; //X3_DESCENG
	'@E 999,999,999.9999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'C6_ZCUBAGE'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	4																		, ; //X3_DECIMAL
	'Cubagem'																, ; //X3_TITULO
	'Cubagem'																, ; //X3_TITSPA
	'Cubagem'																, ; //X3_TITENG
	'Cubagem'																, ; //X3_DESCRIC
	'Cubagem'																, ; //X3_DESCSPA
	'Cubagem'																, ; //X3_DESCENG
	'@E 999,999,999.9999'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'A4'																	, ; //X3_ORDEM
	'C6_X_CTIMP'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Flag Imp'																, ; //X3_TITULO
	'Flag Imp'																, ; //X3_TITSPA
	'Flag Imp'																, ; //X3_TITENG
	'Flag Impressao'														, ; //X3_DESCRIC
	'Flag Impressao'														, ; //X3_DESCSPA
	'Flag Impressao'														, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'A5'																	, ; //X3_ORDEM
	'C6_X_TO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'TO'																	, ; //X3_TITULO
	'TO'																	, ; //X3_TITSPA
	'OT'																	, ; //X3_TITENG
	'Copia Tipo de Operacao'												, ; //X3_DESCRIC
	'Copia Tipo de Operacion'												, ; //X3_DESCSPA
	'Copy Operation type'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'CNIVEL > SX3->X3_NIVEL'												, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SC6'																	, ; //X3_ARQUIVO
	'A9'																	, ; //X3_ORDEM
	'C6_ICMSRET'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	9																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'ICMS Retido'															, ; //X3_TITULO
	'ICMS R tido'															, ; //X3_TITSPA
	'ICMS R tido'															, ; //X3_TITENG
	'ICMS R tido'															, ; //X3_DESCRIC
	'ICMS R tido'															, ; //X3_DESCSPA
	'ICMS R tido'															, ; //X3_DESCENG
	'@E 999,999.99'															, ; //X3_PICTURE
	'MaFisGet("IT_VALSOL")'													, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SE4
//
aAdd( aSX3, { ;
	'SE4'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'E4_XINDFIN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Coef Cond Pg'															, ; //X3_TITULO
	'Coef Cond Pg'															, ; //X3_TITSPA
	'Coef Cond Pg'															, ; //X3_TITENG
	'Coef Cond Pg'															, ; //X3_DESCRIC
	'Coef Cond Pg'															, ; //X3_DESCSPA
	'Coef Cond Pg'															, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SE4'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'E4_XPEDMIN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Pedido Min'															, ; //X3_TITULO
	'Pedido Min'															, ; //X3_TITSPA
	'Pedido Min'															, ; //X3_TITENG
	'Pedido Min'															, ; //X3_DESCRIC
	'Pedido Min'															, ; //X3_DESCSPA
	'Pedido Min'															, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SE4'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'E4_XPARCMI'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Parc Minima'															, ; //X3_TITULO
	'Parc Minima'															, ; //X3_TITSPA
	'Parc Minima'															, ; //X3_TITENG
	'Parc Minima'															, ; //X3_DESCRIC
	'Parc Minima'															, ; //X3_DESCSPA
	'Parc Minima'															, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SE4'																	, ; //X3_ARQUIVO
	'32'																	, ; //X3_ORDEM
	'E4_XPRZMED'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Prz Medio'																, ; //X3_TITULO
	'Prz Medio'																, ; //X3_TITSPA
	'Prz Medio'																, ; //X3_TITENG
	'Prz Medio'																, ; //X3_DESCRIC
	'Prz Medio'																, ; //X3_DESCSPA
	'Prz Medio'																, ; //X3_DESCENG
	'@E 99,999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SE4'																	, ; //X3_ARQUIVO
	'33'																	, ; //X3_ORDEM
	'E4_XPARCEL'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Parcelas'																, ; //X3_TITULO
	'Parcelas'																, ; //X3_TITSPA
	'Parcelas'																, ; //X3_TITENG
	'Parcelas'																, ; //X3_DESCRIC
	'Parcelas'																, ; //X3_DESCSPA
	'Parcelas'																, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SE4'																	, ; //X3_ARQUIVO
	'34'																	, ; //X3_ORDEM
	'E4_XDESCON'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Desconto'																, ; //X3_TITULO
	'Desconto'																, ; //X3_TITSPA
	'Desconto'																, ; //X3_TITENG
	'Desconto    Desconto'													, ; //X3_DESCRIC
	'Desconto'																, ; //X3_DESCSPA
	'Desconto'																, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SE4'																	, ; //X3_ARQUIVO
	'35'																	, ; //X3_ORDEM
	'E4_XAFV'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Envia AFV?'															, ; //X3_TITULO
	'Envia AFV?'															, ; //X3_TITSPA
	'Envia AFV?'															, ; //X3_TITENG
	'Envia AFV?'															, ; //X3_DESCRIC
	'Envia AFV?'															, ; //X3_DESCSPA
	'Envia AFV?'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"S"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'S=Sim;N=Nao'															, ; //X3_CBOX
	'S=Sim;N=Nao'															, ; //X3_CBOXSPA
	'S=Sim;N=Nao'															, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZB1
//
aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZB1_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZB1_REGRA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Regra'																	, ; //X3_TITULO
	'Regra'																	, ; //X3_TITSPA
	'Regra'																	, ; //X3_TITENG
	'Regra'																	, ; //X3_DESCRIC
	'Regra'																	, ; //X3_DESCSPA
	'Regra'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'GETSXENUM("ZB1","ZB1_REGRA")'											, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'copcao=="INCLUIR"'														, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZB1_TIPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'TP Comissao'															, ; //X3_TITULO
	'TP Comissao'															, ; //X3_TITSPA
	'TP Comissao'															, ; //X3_TITENG
	'TP Comissao'															, ; //X3_DESCRIC
	'TP Comissao'															, ; //X3_DESCSPA
	'TP Comissao'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'N=Flexivel;S=Verba;M=Margem'											, ; //X3_CBOX
	'N=Flexivel;S=Verba;M=Margem'											, ; //X3_CBOXSPA
	'N=Flexivel;S=Verba;M=Margem'											, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZB1_COMIS'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Comissao'																, ; //X3_TITULO
	'Comissao'																, ; //X3_TITSPA
	'Comissao'																, ; //X3_TITENG
	'Comissao'																, ; //X3_DESCRIC
	'Comissao'																, ; //X3_DESCSPA
	'Comissao'																, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZB1_FLEX'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Com Flex'																, ; //X3_TITULO
	'Com Flex'																, ; //X3_TITSPA
	'Com Flex'																, ; //X3_TITENG
	'Com Flex'																, ; //X3_DESCRIC
	'Com Flex'																, ; //X3_DESCSPA
	'Com Flex'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZB1_LBCOM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Local B Comi'															, ; //X3_TITULO
	'Local B Comi'															, ; //X3_TITSPA
	'Local B Comi'															, ; //X3_TITENG
	'Local B Comi'															, ; //X3_DESCRIC
	'Local B Comi'															, ; //X3_DESCSPA
	'Local B Comi'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'0=Tabela;1=Venda;2=Inicial'											, ; //X3_CBOX
	'0=Tabela;1=Venda;2=Inicial'											, ; //X3_CBOXSPA
	'0=Tabela;1=Venda;2=Inicial'											, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZB1_PVERBC'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'% Verba Cred'															, ; //X3_TITULO
	'% Verba Cred'															, ; //X3_TITSPA
	'% Verba Cred'															, ; //X3_TITENG
	'% Verba Cred'															, ; //X3_DESCRIC
	'% Verba Cred'															, ; //X3_DESCSPA
	'% Verba Cred'															, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB1'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZB1_DESCRI'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descricao'																, ; //X3_TITULO
	'Descricao'																, ; //X3_TITSPA
	'Descricao'																, ; //X3_TITENG
	'Descricao'																, ; //X3_DESCRIC
	'Descricao'																, ; //X3_DESCSPA
	'Descricao'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZB2
//
aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZB2_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZB2_REGRA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Regra'																	, ; //X3_TITULO
	'Regra'																	, ; //X3_TITSPA
	'Regra'																	, ; //X3_TITENG
	'Regra'																	, ; //X3_DESCRIC
	'Regra'																	, ; //X3_DESCSPA
	'Regra'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZB2_ITEM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Item'																	, ; //X3_TITULO
	'Item'																	, ; //X3_TITSPA
	'Item'																	, ; //X3_TITENG
	'Item'																	, ; //X3_DESCRIC
	'Item'																	, ; //X3_DESCSPA
	'Item'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'SOMA1(ACOLS[N-1,1])'													, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZB2_TIPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo Comissa'															, ; //X3_TITULO
	'Tipo Comissa'															, ; //X3_TITSPA
	'Tipo Comissa'															, ; //X3_TITENG
	'Tipo Comissa'															, ; //X3_DESCRIC
	'Tipo Comissa'															, ; //X3_DESCSPA
	'Tipo Comissa'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'A=Acressimo;D=Decressimo'												, ; //X3_CBOX
	'A=Acressimo;D=Decressimo'												, ; //X3_CBOXSPA
	'A=Acressimo;D=Decressimo'												, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZB2_FXINI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Fx inicial'															, ; //X3_TITULO
	'Fx inicial'															, ; //X3_TITSPA
	'Fx inicial'															, ; //X3_TITENG
	'Fx inicial'															, ; //X3_DESCRIC
	'Fx inicial'															, ; //X3_DESCSPA
	'Fx inicial'															, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZB2_FXFIN'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Fx Final'																, ; //X3_TITULO
	'Fx Final'																, ; //X3_TITSPA
	'Fx Final'																, ; //X3_TITENG
	'Fx Final'																, ; //X3_DESCRIC
	'Fx Final'																, ; //X3_DESCSPA
	'Fx Final'																, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZB2_COMINI'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Com Inicial'															, ; //X3_TITULO
	'Com Inicial'															, ; //X3_TITSPA
	'Com Inicial'															, ; //X3_TITENG
	'Com Inicial'															, ; //X3_DESCRIC
	'Com Inicial'															, ; //X3_DESCSPA
	'Com Inicial'															, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZB2_COMFIN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Com Final'																, ; //X3_TITULO
	'Com Final'																, ; //X3_TITSPA
	'Com Final'																, ; //X3_TITENG
	'Com Final'																, ; //X3_DESCRIC
	'Com Final'																, ; //X3_DESCSPA
	'Com Final'																, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB2'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZB2_BLQ'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Bloquear'																, ; //X3_TITULO
	'Bloquear'																, ; //X3_TITSPA
	'Bloquear'																, ; //X3_TITENG
	'Bloquear'																, ; //X3_DESCRIC
	'Bloquear'																, ; //X3_DESCSPA
	'Bloquear'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"S"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'N=Nao;S=Sim'															, ; //X3_CBOX
	'N=Nao;S=Sim'															, ; //X3_CBOXSPA
	'N=Nao;S=Sim'															, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZB3
//
aAdd( aSX3, { ;
	'ZB3'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZB3_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB3'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZB3_CLIENT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cliente'																, ; //X3_TITULO
	'Cliente'																, ; //X3_TITSPA
	'Cliente'																, ; //X3_TITENG
	'Cliente'																, ; //X3_DESCRIC
	'Cliente'																, ; //X3_DESCSPA
	'Cliente'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SA1'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'ExistCpo("SA1")'														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB3'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZB3_LOJA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Loja Cli'																, ; //X3_TITULO
	'Loja Cli'																, ; //X3_TITSPA
	'Loja Cli'																, ; //X3_TITENG
	'Loja Cli'																, ; //X3_DESCRIC
	'Loja Cli'																, ; //X3_DESCSPA
	'Loja Cli'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB3'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZB3_NOME'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome'																	, ; //X3_TITULO
	'Nome'																	, ; //X3_TITSPA
	'Nome'																	, ; //X3_TITENG
	'Nome'																	, ; //X3_DESCRIC
	'Nome'																	, ; //X3_DESCSPA
	'Nome'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB3'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZB3_TPFRET'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo Frete'															, ; //X3_TITULO
	'Tipo Frete'															, ; //X3_TITSPA
	'Tipo Frete'															, ; //X3_TITENG
	'Tipo Frete'															, ; //X3_DESCRIC
	'Tipo Frete'															, ; //X3_DESCSPA
	'Tipo Frete'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'C=Cif;F=Fob;S=Cif/Fob'													, ; //X3_CBOX
	'C=Cif;F=Fob;S=Cif/Fob'													, ; //X3_CBOXSPA
	'C=Cif;F=Fob;S=Cif/Fob'													, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB3'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZB3_PERC'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Perc Frete'															, ; //X3_TITULO
	'Perc Frete'															, ; //X3_TITSPA
	'Perc Frete'															, ; //X3_TITENG
	'Perc Frete'															, ; //X3_DESCRIC
	'Perc Frete'															, ; //X3_DESCSPA
	'Perc Frete'															, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZB4
//
aAdd( aSX3, { ;
	'ZB4'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZB4_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB4'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZB4_TABELA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tabela'																, ; //X3_TITULO
	'Tabela'																, ; //X3_TITSPA
	'Tabela'																, ; //X3_TITENG
	'Tabela'																, ; //X3_DESCRIC
	'Tabela'																, ; //X3_DESCSPA
	'Tabela'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'DA0'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'ExistCpo("DA0")'														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB4'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZB4_DESCRI'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descricao'																, ; //X3_TITULO
	'Descricao'																, ; //X3_TITSPA
	'Descricao'																, ; //X3_TITENG
	'Descricao'																, ; //X3_DESCRIC
	'Descricao'																, ; //X3_DESCSPA
	'Descricao'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB4'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZB4_COND'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Condicao'																, ; //X3_TITULO
	'Condicao'																, ; //X3_TITSPA
	'Condicao'																, ; //X3_TITENG
	'Condicao'																, ; //X3_DESCRIC
	'Condicao'																, ; //X3_DESCSPA
	'Condicao'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SE4'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'ExistCpo("SE4")'														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB4'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZB4_DESCCO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc Condica'															, ; //X3_TITULO
	'Desc Condica'															, ; //X3_TITSPA
	'Desc Condica'															, ; //X3_TITENG
	'Desc Condica'															, ; //X3_DESCRIC
	'Desc Condica'															, ; //X3_DESCSPA
	'Desc Condica'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZB5
//
aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZB5_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZB5_PEDEMP'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ped Empresa'															, ; //X3_TITULO
	'Ped Empresa'															, ; //X3_TITSPA
	'Ped Empresa'															, ; //X3_TITENG
	'Ped Empresa'															, ; //X3_DESCRIC
	'Ped Empresa'															, ; //X3_DESCSPA
	'Ped Empresa'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZB5_PEDSFA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ped SFA'																, ; //X3_TITULO
	'Ped SFA'																, ; //X3_TITSPA
	'Ped SFA'																, ; //X3_TITENG
	'Ped SFA'																, ; //X3_DESCRIC
	'Ped SFA'																, ; //X3_DESCSPA
	'Ped SFA'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZB5_SEQUEN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Sequencial'															, ; //X3_TITULO
	'Sequencial'															, ; //X3_TITSPA
	'Sequencial'															, ; //X3_TITENG
	'Sequencial'															, ; //X3_DESCRIC
	'Sequencial'															, ; //X3_DESCSPA
	'Sequencial'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZB5_CLIENT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cliente'																, ; //X3_TITULO
	'Cliente'																, ; //X3_TITSPA
	'Cliente'																, ; //X3_TITENG
	'Cliente'																, ; //X3_DESCRIC
	'Cliente'																, ; //X3_DESCSPA
	'Cliente'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZB5_STATUS'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Status'																, ; //X3_TITULO
	'Status'																, ; //X3_TITSPA
	'Status'																, ; //X3_TITENG
	'Status'																, ; //X3_DESCRIC
	'Status'																, ; //X3_DESCSPA
	'Status'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZB5_DTPED'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Data Pedido'															, ; //X3_TITULO
	'Data Pedido'															, ; //X3_TITSPA
	'Data Pedido'															, ; //X3_TITENG
	'Data Pedido'															, ; //X3_DESCRIC
	'Data Pedido'															, ; //X3_DESCSPA
	'Data Pedido'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZB5_ORIGEM'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Origem'																, ; //X3_TITULO
	'Origem'																, ; //X3_TITSPA
	'Origem'																, ; //X3_TITENG
	'Origem'																, ; //X3_DESCRIC
	'Origem'																, ; //X3_DESCSPA
	'Origem'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZB5_TPPED'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo Pedido'															, ; //X3_TITULO
	'Tipo Pedido'															, ; //X3_TITSPA
	'Tipo Pedido'															, ; //X3_TITENG
	'Tipo Pedido'															, ; //X3_DESCRIC
	'Tipo Pedido'															, ; //X3_DESCSPA
	'Tipo Pedido'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZB5_FRMPGT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Forma Pgto'															, ; //X3_TITULO
	'Forma Pgto'															, ; //X3_TITSPA
	'Forma Pgto'															, ; //X3_TITENG
	'Forma Pgto'															, ; //X3_DESCRIC
	'Forma Pgto'															, ; //X3_DESCSPA
	'Forma Pgto'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZB5_PLANO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Plano Pgto'															, ; //X3_TITULO
	'Plano Pgto'															, ; //X3_TITSPA
	'Plano Pgto'															, ; //X3_TITENG
	'Plano Pgto'															, ; //X3_DESCRIC
	'Plano Pgto'															, ; //X3_DESCSPA
	'Plano Pgto'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZB5_COND'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cond Pgto'																, ; //X3_TITULO
	'Cond Pgto'																, ; //X3_TITSPA
	'Cond Pgto'																, ; //X3_TITENG
	'Cond Pgto'																, ; //X3_DESCRIC
	'Cond Pgto'																, ; //X3_DESCSPA
	'Cond Pgto'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZB5_VEND'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Representant'															, ; //X3_TITULO
	'Representant'															, ; //X3_TITSPA
	'Representant'															, ; //X3_TITENG
	'Representant'															, ; //X3_DESCRIC
	'Representant'															, ; //X3_DESCSPA
	'Representant'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'ZB5_TRANSP'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Transportado'															, ; //X3_TITULO
	'Transportado'															, ; //X3_TITSPA
	'Transportado'															, ; //X3_TITENG
	'Transportado'															, ; //X3_DESCRIC
	'Transportado'															, ; //X3_DESCSPA
	'Transportado'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'ZB5_TABELA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tabela'																, ; //X3_TITULO
	'Tabela'																, ; //X3_TITSPA
	'Tabela'																, ; //X3_TITENG
	'Tabela'																, ; //X3_DESCRIC
	'Tabela'																, ; //X3_DESCSPA
	'Tabela'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'ZB5_DTSINC'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Sinc'																, ; //X3_TITULO
	'Dt Sinc'																, ; //X3_TITSPA
	'Dt Sinc'																, ; //X3_TITENG
	'Dt Sinc'																, ; //X3_DESCRIC
	'Dt Sinc'																, ; //X3_DESCSPA
	'Dt Sinc'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'ZB5_DTIMP'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Imp'																, ; //X3_TITULO
	'Dt Imp'																, ; //X3_TITSPA
	'Dt Imp'																, ; //X3_TITENG
	'Dt Imp'																, ; //X3_DESCRIC
	'Dt Imp'																, ; //X3_DESCSPA
	'Dt Imp'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'ZB5_HRIMP'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hora Imp'																, ; //X3_TITULO
	'Hora Imp'																, ; //X3_TITSPA
	'Hora Imp'																, ; //X3_TITENG
	'Hora Imp'																, ; //X3_DESCRIC
	'Hora Imp'																, ; //X3_DESCSPA
	'Hora Imp'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'ZB5_NUM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pedido'																, ; //X3_TITULO
	'Pedido'																, ; //X3_TITSPA
	'Pedido'																, ; //X3_TITENG
	'Pedido'																, ; //X3_DESCRIC
	'Pedido'																, ; //X3_DESCSPA
	'Pedido'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'ZB5_DTEFET'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Efetivac'															, ; //X3_TITULO
	'Dt Efetivac'															, ; //X3_TITSPA
	'Dt Efetivac'															, ; //X3_TITENG
	'Dt Efetivac'															, ; //X3_DESCRIC
	'Dt Efetivac'															, ; //X3_DESCSPA
	'Dt Efetivac'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'ZB5_HREFET'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hora Efetiva'															, ; //X3_TITULO
	'Hora Efetiva'															, ; //X3_TITSPA
	'Hora Efetiva'															, ; //X3_TITENG
	'Hora Efetiva'															, ; //X3_DESCRIC
	'Hora Efetiva'															, ; //X3_DESCSPA
	'Hora Efetiva'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'ZB5_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Valor Pedido'															, ; //X3_TITULO
	'Valor Pedido'															, ; //X3_TITSPA
	'Valor Pedido'															, ; //X3_TITENG
	'Valor Pedido'															, ; //X3_DESCRIC
	'Valor Pedido'															, ; //X3_DESCSPA
	'Valor Pedido'															, ; //X3_DESCENG
	'@E 999,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'ZB5_OK'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	4																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Marca'																	, ; //X3_TITULO
	'Marca'																	, ; //X3_TITSPA
	'Marca'																	, ; //X3_TITENG
	'Marca'																	, ; //X3_DESCRIC
	'Marca'																	, ; //X3_DESCSPA
	'Marca'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'ZB5_IMPORT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Import'																, ; //X3_TITULO
	'Import'																, ; //X3_TITSPA
	'Import'																, ; //X3_TITENG
	'Import'																, ; //X3_DESCRIC
	'Import'																, ; //X3_DESCSPA
	'Import'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'0=Pendente;1=Importado;2=Cancelado'									, ; //X3_CBOX
	'0=Pendente;1=Importado;2=Cancelado'									, ; //X3_CBOXSPA
	'0=Pendente;1=Importado;2=Cancelado'									, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'ZB5_FRETMB'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Frete MB'																, ; //X3_TITULO
	'Frete MB'																, ; //X3_TITSPA
	'Frete MB'																, ; //X3_TITENG
	'Frete MB'																, ; //X3_DESCRIC
	'Frete MB'																, ; //X3_DESCSPA
	'Frete MB'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'ZB5_OBS'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obs'																	, ; //X3_TITULO
	'Obs'																	, ; //X3_TITSPA
	'Obs'																	, ; //X3_TITENG
	'Obs'																	, ; //X3_DESCRIC
	'Obs'																	, ; //X3_DESCSPA
	'Obs'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'ZB5_OBSINT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obs Int'																, ; //X3_TITULO
	'Obs Int'																, ; //X3_TITSPA
	'Obs Int'																, ; //X3_TITENG
	'Obs Int'																, ; //X3_DESCRIC
	'Obs Int'																, ; //X3_DESCSPA
	'Obs Int'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'ZB5_OC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'OC'																	, ; //X3_TITULO
	'OC'																	, ; //X3_TITSPA
	'OC'																	, ; //X3_TITENG
	'OC'																	, ; //X3_DESCRIC
	'OC'																	, ; //X3_DESCSPA
	'OC'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'ZB5_DTPENT'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Prev Ent'															, ; //X3_TITULO
	'Dt Prev Ent'															, ; //X3_TITSPA
	'Dt Prev Ent'															, ; //X3_TITENG
	'Dt Prev Ent'															, ; //X3_DESCRIC
	'Dt Prev Ent'															, ; //X3_DESCSPA
	'Dt Prev Ent'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB5'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'ZB5_TPFRET'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'TP Frete'																, ; //X3_TITULO
	'TP Frete'																, ; //X3_TITSPA
	'TP Frete'																, ; //X3_TITENG
	'TP Frete    TP Frete'													, ; //X3_DESCRIC
	'TP Frete'																, ; //X3_DESCSPA
	'TP Frete'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZB6
//
aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZB6_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZB6_PEDEMP'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ped Emp'																, ; //X3_TITULO
	'Ped Emp'																, ; //X3_TITSPA
	'Ped Emp'																, ; //X3_TITENG
	'Ped Emp'																, ; //X3_DESCRIC
	'Ped Emp'																, ; //X3_DESCSPA
	'Ped Emp'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZB6_SEQUEN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Sequencia'																, ; //X3_TITULO
	'Sequencia'																, ; //X3_TITSPA
	'Sequencia'																, ; //X3_TITENG
	'Sequencia'																, ; //X3_DESCRIC
	'Sequencia'																, ; //X3_DESCSPA
	'Sequencia'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZB6_COD'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Produto'																, ; //X3_TITULO
	'Produto'																, ; //X3_TITSPA
	'Produto'																, ; //X3_TITENG
	'Produto'																, ; //X3_DESCRIC
	'Produto'																, ; //X3_DESCSPA
	'Produto'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZB6_DESCRI'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descricao'																, ; //X3_TITULO
	'Descricao'																, ; //X3_TITSPA
	'Descricao'																, ; //X3_TITENG
	'Descricao'																, ; //X3_DESCRIC
	'Descricao'																, ; //X3_DESCSPA
	'Descricao'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZB6_QTDVEN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Quantidade'															, ; //X3_TITULO
	'Quantidade'															, ; //X3_TITSPA
	'Quantidade'															, ; //X3_TITENG
	'Quantidade'															, ; //X3_DESCRIC
	'Quantidade'															, ; //X3_DESCSPA
	'Quantidade'															, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZB6_PRCVEN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Preco'																	, ; //X3_TITULO
	'Preco'																	, ; //X3_TITSPA
	'Preco'																	, ; //X3_TITENG
	'Preco'																	, ; //X3_DESCRIC
	'Preco'																	, ; //X3_DESCSPA
	'Preco'																	, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZB6_PRUNIT'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Preco Tabela'															, ; //X3_TITULO
	'Preco Tabela'															, ; //X3_TITSPA
	'Preco Tabela'															, ; //X3_TITENG
	'Preco Tabela'															, ; //X3_DESCRIC
	'Preco Tabela'															, ; //X3_DESCSPA
	'Preco Tabela'															, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZB6_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Valor Total'															, ; //X3_TITULO
	'Valor Total'															, ; //X3_TITSPA
	'Valor Total'															, ; //X3_TITENG
	'Valor Total'															, ; //X3_DESCRIC
	'Valor Total'															, ; //X3_DESCSPA
	'Valor Total'															, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZB6_VALIPI'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Valor Ipi'																, ; //X3_TITULO
	'Valor Ipi'																, ; //X3_TITSPA
	'Valor Ipi'																, ; //X3_TITENG
	'Valor Ipi'																, ; //X3_DESCRIC
	'Valor Ipi'																, ; //X3_DESCSPA
	'Valor Ipi'																, ; //X3_DESCENG
	'@E 999,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZB6_VALST'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Valor ST'																, ; //X3_TITULO
	'Valor ST'																, ; //X3_TITSPA
	'Valor ST'																, ; //X3_TITENG
	'Valor ST'																, ; //X3_DESCRIC
	'Valor ST'																, ; //X3_DESCSPA
	'Valor ST'																, ; //X3_DESCENG
	'@E 999,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZB6_IPI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'% IPI'																	, ; //X3_TITULO
	'% IPI'																	, ; //X3_TITSPA
	'% IPI'																	, ; //X3_TITENG
	'% IPI'																	, ; //X3_DESCRIC
	'% IPI'																	, ; //X3_DESCSPA
	'% IPI'																	, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZB6_NCM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'NCM'																	, ; //X3_TITULO
	'NCM'																	, ; //X3_TITSPA
	'NCM'																	, ; //X3_TITENG
	'NCM'																	, ; //X3_DESCRIC
	'NCM'																	, ; //X3_DESCSPA
	'NCM'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'ZB6_EMB'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Embalagem'																, ; //X3_TITULO
	'Embalagem'																, ; //X3_TITSPA
	'Embalagem'																, ; //X3_TITENG
	'Embalagem'																, ; //X3_DESCRIC
	'Embalagem'																, ; //X3_DESCSPA
	'Embalagem'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'ZB6_QTDEMB'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Qtde embalag'															, ; //X3_TITULO
	'Qtde embalag'															, ; //X3_TITSPA
	'Qtde embalag'															, ; //X3_TITENG
	'Qtde embalag'															, ; //X3_DESCRIC
	'Qtde embalag'															, ; //X3_DESCSPA
	'Qtde embalag'															, ; //X3_DESCENG
	'@E 99,999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'ZB6_ITEM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Item'																	, ; //X3_TITULO
	'Item'																	, ; //X3_TITSPA
	'Item'																	, ; //X3_TITENG
	'Item'																	, ; //X3_DESCRIC
	'Item'																	, ; //X3_DESCSPA
	'Item'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'ZB6_DESCON'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'% Desconto'															, ; //X3_TITULO
	'% Desconto'															, ; //X3_TITSPA
	'% Desconto'															, ; //X3_TITENG
	'% Desconto'															, ; //X3_DESCRIC
	'% Desconto'															, ; //X3_DESCSPA
	'% Desconto'															, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZB6'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'ZB6_VALDES'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Valor Desc'															, ; //X3_TITULO
	'Valor Desc'															, ; //X3_TITSPA
	'Valor Desc'															, ; //X3_TITENG
	'Valor Desc'															, ; //X3_DESCRIC
	'Valor Desc'															, ; //X3_DESCSPA
	'Valor Desc'															, ; //X3_DESCENG
	'@E 999,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZBZ
//
aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZBZ_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZBZ_001'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'C¢digo Vende'															, ; //X3_TITULO
	'C¢digo Vende'															, ; //X3_TITSPA
	'C¢digo Vende'															, ; //X3_TITENG
	'C¢digo Vende'															, ; //X3_DESCRIC
	'C¢digo Vende'															, ; //X3_DESCSPA
	'C¢digo Vende'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SA3'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'ExistCpo("SA3")'														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZBZ_002'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome do Agen'															, ; //X3_TITULO
	'Nome do Agen'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZBZ_003'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N£mero Dias'															, ; //X3_TITULO
	'N£mero Dias'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZBZ_004'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Flag Permiti'															, ; //X3_TITULO
	'Flag Permiti'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZBZ_005'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual q'															, ; //X3_TITULO
	'Percentual q'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZBZ_006'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N£mero de Di'															, ; //X3_TITULO
	'N£mero de Di'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZBZ_007'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N£mero de Di'															, ; //X3_TITULO
	'N£mero de Di'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZBZ_008'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Mostrar Esto'															, ; //X3_TITULO
	'Mostrar Esto'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZBZ_009'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Mostrar Comi'															, ; //X3_TITULO
	'Mostrar Comi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZBZ_010'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite Exce'															, ; //X3_TITULO
	'Permite Exce'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZBZ_011'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite Exce'															, ; //X3_TITULO
	'Permite Exce'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZBZ_012'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Bloquear ven'															, ; //X3_TITULO
	'Bloquear ven'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'ZBZ_013'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo de Pess'															, ; //X3_TITULO
	'Tipo de Pess'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'ZBZ_014'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo de Pess'															, ; //X3_TITULO
	'Tipo de Pess'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'ZBZ_015'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite alte'															, ; //X3_TITULO
	'Permite alte'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'ZBZ_016'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Verba Negati'															, ; //X3_TITULO
	'Verba Negati'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'ZBZ_017'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual d'															, ; //X3_TITULO
	'Percentual d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'ZBZ_018'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual d'															, ; //X3_TITULO
	'Percentual d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'ZBZ_019'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obriga justi'															, ; //X3_TITULO
	'Obriga justi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'ZBZ_020'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'C¢digo do PA'															, ; //X3_TITULO
	'C¢digo do PA'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'ZBZ_021'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'ZBZ_022'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'ZBZ_023'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'ZBZ_024'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Justificar N'															, ; //X3_TITULO
	'Justificar N'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'ZBZ_025'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exportar Pro'															, ; //X3_TITULO
	'Exportar Pro'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'ZBZ_026'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Desconto M x'															, ; //X3_TITULO
	'Desconto M x'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'ZBZ_027'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Acr‚scimo M '															, ; //X3_TITULO
	'Acr‚scimo M '															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'ZBZ_028'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Servidor FTP'															, ; //X3_TITULO
	'Servidor FTP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'ZBZ_029'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Porta FTP'																, ; //X3_TITULO
	'Porta FTP'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'ZBZ_030'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Usu rio FTP'															, ; //X3_TITULO
	'Usu rio FTP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'32'																	, ; //X3_ORDEM
	'ZBZ_031'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha FTP'																, ; //X3_TITULO
	'Senha FTP'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'33'																	, ; //X3_ORDEM
	'ZBZ_032'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta de rec'															, ; //X3_TITULO
	'Pasta de rec'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'34'																	, ; //X3_ORDEM
	'ZBZ_033'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta de env'															, ; //X3_TITULO
	'Pasta de env'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'35'																	, ; //X3_ORDEM
	'ZBZ_034'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Local da ima'															, ; //X3_TITULO
	'Local da ima'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'36'																	, ; //X3_ORDEM
	'ZBZ_035'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Login do sis'															, ; //X3_TITULO
	'Login do sis'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'37'																	, ; //X3_ORDEM
	'ZBZ_036'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha do sis'															, ; //X3_TITULO
	'Senha do sis'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'38'																	, ; //X3_ORDEM
	'ZBZ_037'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha para a'															, ; //X3_TITULO
	'Senha para a'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'39'																	, ; //X3_ORDEM
	'ZBZ_038'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Preposto'																, ; //X3_TITULO
	'Preposto'																, ; //X3_TITSPA
	'Preposto'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'9'																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'40'																	, ; //X3_ORDEM
	'ZBZ_039'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta de rec'															, ; //X3_TITULO
	'Pasta de rec'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'41'																	, ; //X3_ORDEM
	'ZBZ_040'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta envio'															, ; //X3_TITULO
	'Pasta envio'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'42'																	, ; //X3_ORDEM
	'ZBZ_041'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Flag Utiliza'															, ; //X3_TITULO
	'Flag Utiliza'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'43'																	, ; //X3_ORDEM
	'ZBZ_042'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'M¢dulo FTP'															, ; //X3_TITULO
	'M¢dulo FTP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'44'																	, ; //X3_ORDEM
	'ZBZ_043'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite digi'															, ; //X3_TITULO
	'Permite digi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'45'																	, ; //X3_ORDEM
	'ZBZ_044'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dias de carˆ'															, ; //X3_TITULO
	'Dias de carˆ'															, ; //X3_TITSPA
	'Dias de carˆ'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'99'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'46'																	, ; //X3_ORDEM
	'ZBZ_045'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite excl'															, ; //X3_TITULO
	'Permite excl'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'47'																	, ; //X3_ORDEM
	'ZBZ_046'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Bloqueia des'															, ; //X3_TITULO
	'Bloqueia des'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'48'																	, ; //X3_ORDEM
	'ZBZ_047'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tem RDV'																, ; //X3_TITULO
	'Tem RDV'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'49'																	, ; //X3_ORDEM
	'ZBZ_048'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Trava RDV'																, ; //X3_TITULO
	'Trava RDV'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'50'																	, ; //X3_ORDEM
	'ZBZ_049'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dias Max de'															, ; //X3_TITULO
	'Dias Max de'															, ; //X3_TITSPA
	'Dias Max de'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'51'																	, ; //X3_ORDEM
	'ZBZ_050'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Trava frete'															, ; //X3_TITULO
	'Trava frete'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'52'																	, ; //X3_ORDEM
	'ZBZ_051'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Trava pedido'															, ; //X3_TITULO
	'Trava pedido'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'53'																	, ; //X3_ORDEM
	'ZBZ_052'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Base para co'															, ; //X3_TITULO
	'Base para co'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'54'																	, ; //X3_ORDEM
	'ZBZ_053'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'ComissÆo m¡n'															, ; //X3_TITULO
	'ComissÆo m¡n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'55'																	, ; //X3_ORDEM
	'ZBZ_054'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dias para ma'															, ; //X3_TITULO
	'Dias para ma'															, ; //X3_TITSPA
	'Dias para ma'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'56'																	, ; //X3_ORDEM
	'ZBZ_055'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe apenas'															, ; //X3_TITULO
	'Exibe apenas'															, ; //X3_TITSPA
	'Exibe apenas'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'57'																	, ; //X3_ORDEM
	'ZBZ_056'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe descon'															, ; //X3_TITULO
	'Exibe descon'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'58'																	, ; //X3_ORDEM
	'ZBZ_057'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Recalcula it'															, ; //X3_TITULO
	'Recalcula it'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'59'																	, ; //X3_ORDEM
	'ZBZ_058'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Empresa'																, ; //X3_TITULO
	'Empresa'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'60'																	, ; //X3_ORDEM
	'ZBZ_059'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'NÆo exibe o'															, ; //X3_TITULO
	'NÆo exibe o'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'61'																	, ; //X3_ORDEM
	'ZBZ_060'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Altera‡Æo de'															, ; //X3_TITULO
	'Altera‡Æo de'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'62'																	, ; //X3_ORDEM
	'ZBZ_061'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Calcula fide'															, ; //X3_TITULO
	'Calcula fide'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'63'																	, ; //X3_ORDEM
	'ZBZ_062'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Determina o'															, ; //X3_TITULO
	'Determina o'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'64'																	, ; //X3_ORDEM
	'ZBZ_063'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual d'															, ; //X3_TITULO
	'Percentual d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'65'																	, ; //X3_ORDEM
	'ZBZ_064'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ocultar camp'															, ; //X3_TITULO
	'Ocultar camp'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'66'																	, ; //X3_ORDEM
	'ZBZ_065'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obriga digit'															, ; //X3_TITULO
	'Obriga digit'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'67'																	, ; //X3_ORDEM
	'ZBZ_066'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite reen'															, ; //X3_TITULO
	'Permite reen'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'68'																	, ; //X3_ORDEM
	'ZBZ_067'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Regra de blo'															, ; //X3_TITULO
	'Regra de blo'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'69'																	, ; //X3_ORDEM
	'ZBZ_068'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe entrad'															, ; //X3_TITULO
	'Exibe entrad'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'70'																	, ; //X3_ORDEM
	'ZBZ_069'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obriga digit'															, ; //X3_TITULO
	'Obriga digit'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'71'																	, ; //X3_ORDEM
	'ZBZ_070'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'CNPJ da empr'															, ; //X3_TITULO
	'CNPJ da empr'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'72'																	, ; //X3_ORDEM
	'ZBZ_071'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Oculta o val'															, ; //X3_TITULO
	'Oculta o val'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'73'																	, ; //X3_ORDEM
	'ZBZ_072'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Justifica t¡'															, ; //X3_TITULO
	'Justifica t¡'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'74'																	, ; //X3_ORDEM
	'ZBZ_073'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Indica se ‚'															, ; //X3_TITULO
	'Indica se ‚'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'75'																	, ; //X3_ORDEM
	'ZBZ_074'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Recalcula to'															, ; //X3_TITULO
	'Recalcula to'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'76'																	, ; //X3_ORDEM
	'ZBZ_075'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tabela padrÆ'															, ; //X3_TITULO
	'Tabela padrÆ'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'77'																	, ; //X3_ORDEM
	'ZBZ_076'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Libera a dig'															, ; //X3_TITULO
	'Libera a dig'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'78'																	, ; //X3_ORDEM
	'ZBZ_077'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	200																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Login do gma'															, ; //X3_TITULO
	'Login do gma'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'79'																	, ; //X3_ORDEM
	'ZBZ_078'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	200																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha gmail'															, ; //X3_TITULO
	'Senha gmail'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'80'																	, ; //X3_ORDEM
	'ZBZ_079'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'81'																	, ; //X3_ORDEM
	'ZBZ_080'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'82'																	, ; //X3_ORDEM
	'ZBZ_081'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'83'																	, ; //X3_ORDEM
	'ZBZ_082'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Indica se ut'															, ; //X3_TITULO
	'Indica se ut'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'84'																	, ; //X3_ORDEM
	'ZBZ_083'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Utiliza mapa'															, ; //X3_TITULO
	'Utiliza mapa'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'85'																	, ; //X3_ORDEM
	'ZBZ_084'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ignora versa'															, ; //X3_TITULO
	'Ignora versa'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'86'																	, ; //X3_ORDEM
	'ZBZ_085'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Email repres'															, ; //X3_TITULO
	'Email repres'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'87'																	, ; //X3_ORDEM
	'ZBZ_086'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Telefone rep'															, ; //X3_TITULO
	'Telefone rep'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'88'																	, ; //X3_ORDEM
	'ZBZ_087'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Utiliza Chec'															, ; //X3_TITULO
	'Utiliza Chec'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'89'																	, ; //X3_ORDEM
	'ZBZ_088'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Raio Check-i'															, ; //X3_TITULO
	'Raio Check-i'															, ; //X3_TITSPA
	'Raio Check-i'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'90'																	, ; //X3_ORDEM
	'ZBZ_089'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exige senha'															, ; //X3_TITULO
	'Exige senha'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'91'																	, ; //X3_ORDEM
	'ZBZ_090'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Quantidade d'															, ; //X3_TITULO
	'Quantidade d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'92'																	, ; //X3_ORDEM
	'ZBZ_091'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	255																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'URL WebServi'															, ; //X3_TITULO
	'URL WebServi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'93'																	, ; //X3_ORDEM
	'ZBZ_092'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Utiliza verb'															, ; //X3_TITULO
	'Utiliza verb'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'94'																	, ; //X3_ORDEM
	'ZBZ_093'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo para ca'															, ; //X3_TITULO
	'Tipo para ca'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'95'																	, ; //X3_ORDEM
	'ZBZ_094'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Habilita fla'															, ; //X3_TITULO
	'Habilita fla'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'96'																	, ; //X3_ORDEM
	'ZBZ_095'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Duplica‡Æo I'															, ; //X3_TITULO
	'Duplica‡Æo I'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'97'																	, ; //X3_ORDEM
	'ZBZ_096'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Troca Hist¢r'															, ; //X3_TITULO
	'Troca Hist¢r'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'98'																	, ; //X3_ORDEM
	'ZBZ_097'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe descon'															, ; //X3_TITULO
	'Exibe descon'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'99'																	, ; //X3_ORDEM
	'ZBZ_098'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Confirma CNP'															, ; //X3_TITULO
	'Confirma CNP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A0'																	, ; //X3_ORDEM
	'ZBZ_099'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Verifica a v'															, ; //X3_TITULO
	'Verifica a v'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A1'																	, ; //X3_ORDEM
	'ZBZ_100'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	''																		, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A2'																	, ; //X3_ORDEM
	'ZBZ_101'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibi t¡tulo'															, ; //X3_TITULO
	'Exibi t¡tulo'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A3'																	, ; //X3_ORDEM
	'ZBZ_102'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite alte'															, ; //X3_TITULO
	'Permite alte'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A4'																	, ; //X3_ORDEM
	'ZBZ_103'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exporta iten'															, ; //X3_TITULO
	'Exporta iten'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A5'																	, ; //X3_ORDEM
	'ZBZ_104'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'ComissÆo m¡n'															, ; //X3_TITULO
	'ComissÆo m¡n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A6'																	, ; //X3_ORDEM
	'ZBZ_105'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'ComissÆo m x'															, ; //X3_TITULO
	'ComissÆo m x'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A7'																	, ; //X3_ORDEM
	'ZBZ_106'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Comportament'															, ; //X3_TITULO
	'Comportament'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A8'																	, ; //X3_ORDEM
	'ZBZ_107'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Retira frete'															, ; //X3_TITULO
	'Retira frete'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'A9'																	, ; //X3_ORDEM
	'ZBZ_108'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ordena‡Æo do'															, ; //X3_TITULO
	'Ordena‡Æo do'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'B0'																	, ; //X3_ORDEM
	'ZBZ_119'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Modelo do PD'															, ; //X3_TITULO
	'Modelo do PD'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'B1'																	, ; //X3_ORDEM
	'ZBZ_110'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	140																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Observa‡Æo n'															, ; //X3_TITULO
	'Observa‡Æo n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'B2'																	, ; //X3_ORDEM
	'ZBZ_111'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	140																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Observa‡Æo n'															, ; //X3_TITULO
	'Observa‡Æo n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'B3'																	, ; //X3_ORDEM
	'ZBZ_112'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	140																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Observa‡Æo n'															, ; //X3_TITULO
	'Observa‡Æo n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'B4'																	, ; //X3_ORDEM
	'ZBZ_113'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Base do Calc'															, ; //X3_TITULO
	'Base do Calc'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'B5'																	, ; //X3_ORDEM
	'ZBZ_114'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Flag para c '															, ; //X3_TITULO
	'Flag para c '															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBZ'																	, ; //X3_ARQUIVO
	'B6'																	, ; //X3_ORDEM
	'ZBZ_115'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibir o val'															, ; //X3_TITULO
	'Exibir o val'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZZZ
//
aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZZZ_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZZZ_001'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'C¢digo Vende'															, ; //X3_TITULO
	'C¢digo Vende'															, ; //X3_TITSPA
	'C¢digo Vende'															, ; //X3_TITENG
	'C¢digo Vende'															, ; //X3_DESCRIC
	'C¢digo Vende'															, ; //X3_DESCSPA
	'C¢digo Vende'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SA3'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'ExistCpo("SA3")'														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZZZ_002'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome do Agen'															, ; //X3_TITULO
	'Nome do Agen'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZZZ_003'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N£mero Dias'															, ; //X3_TITULO
	'N£mero Dias'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZZZ_004'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Flag Permiti'															, ; //X3_TITULO
	'Flag Permiti'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZZZ_005'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual q'															, ; //X3_TITULO
	'Percentual q'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZZZ_006'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N£mero de Di'															, ; //X3_TITULO
	'N£mero de Di'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZZZ_007'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N£mero de Di'															, ; //X3_TITULO
	'N£mero de Di'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZZZ_008'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Mostrar Esto'															, ; //X3_TITULO
	'Mostrar Esto'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZZZ_009'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Mostrar Comi'															, ; //X3_TITULO
	'Mostrar Comi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZZZ_010'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite Exce'															, ; //X3_TITULO
	'Permite Exce'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZZZ_011'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite Exce'															, ; //X3_TITULO
	'Permite Exce'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZZZ_012'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Bloquear ven'															, ; //X3_TITULO
	'Bloquear ven'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'ZZZ_013'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo de Pess'															, ; //X3_TITULO
	'Tipo de Pess'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'ZZZ_014'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo de Pess'															, ; //X3_TITULO
	'Tipo de Pess'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'ZZZ_015'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite alte'															, ; //X3_TITULO
	'Permite alte'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'ZZZ_016'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Verba Negati'															, ; //X3_TITULO
	'Verba Negati'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'ZZZ_017'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual d'															, ; //X3_TITULO
	'Percentual d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'ZZZ_018'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual d'															, ; //X3_TITULO
	'Percentual d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'ZZZ_019'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obriga justi'															, ; //X3_TITULO
	'Obriga justi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'ZZZ_020'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'C¢digo do PA'															, ; //X3_TITULO
	'C¢digo do PA'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'ZZZ_021'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'ZZZ_022'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'ZZZ_023'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'ZZZ_024'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Justificar N'															, ; //X3_TITULO
	'Justificar N'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'ZZZ_025'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exportar Pro'															, ; //X3_TITULO
	'Exportar Pro'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'ZZZ_026'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Desconto M x'															, ; //X3_TITULO
	'Desconto M x'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'ZZZ_027'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Acr‚scimo M '															, ; //X3_TITULO
	'Acr‚scimo M '															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'ZZZ_028'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Servidor FTP'															, ; //X3_TITULO
	'Servidor FTP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'ZZZ_029'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Porta FTP'																, ; //X3_TITULO
	'Porta FTP'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'ZZZ_030'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Usu rio FTP'															, ; //X3_TITULO
	'Usu rio FTP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'32'																	, ; //X3_ORDEM
	'ZZZ_031'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha FTP'																, ; //X3_TITULO
	'Senha FTP'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'33'																	, ; //X3_ORDEM
	'ZZZ_032'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta de rec'															, ; //X3_TITULO
	'Pasta de rec'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'34'																	, ; //X3_ORDEM
	'ZZZ_033'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta de env'															, ; //X3_TITULO
	'Pasta de env'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'35'																	, ; //X3_ORDEM
	'ZZZ_034'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Local da ima'															, ; //X3_TITULO
	'Local da ima'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'36'																	, ; //X3_ORDEM
	'ZZZ_035'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Login do sis'															, ; //X3_TITULO
	'Login do sis'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'37'																	, ; //X3_ORDEM
	'ZZZ_036'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha do sis'															, ; //X3_TITULO
	'Senha do sis'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'38'																	, ; //X3_ORDEM
	'ZZZ_037'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha para a'															, ; //X3_TITULO
	'Senha para a'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'39'																	, ; //X3_ORDEM
	'ZZZ_038'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Preposto'																, ; //X3_TITULO
	'Preposto'																, ; //X3_TITSPA
	'Preposto'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'9'																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'40'																	, ; //X3_ORDEM
	'ZZZ_039'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta de rec'															, ; //X3_TITULO
	'Pasta de rec'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'41'																	, ; //X3_ORDEM
	'ZZZ_040'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Pasta envio'															, ; //X3_TITULO
	'Pasta envio'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'42'																	, ; //X3_ORDEM
	'ZZZ_041'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Flag Utiliza'															, ; //X3_TITULO
	'Flag Utiliza'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'43'																	, ; //X3_ORDEM
	'ZZZ_042'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'M¢dulo FTP'															, ; //X3_TITULO
	'M¢dulo FTP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'44'																	, ; //X3_ORDEM
	'ZZZ_043'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite digi'															, ; //X3_TITULO
	'Permite digi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'45'																	, ; //X3_ORDEM
	'ZZZ_044'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dias de carˆ'															, ; //X3_TITULO
	'Dias de carˆ'															, ; //X3_TITSPA
	'Dias de carˆ'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'99'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'46'																	, ; //X3_ORDEM
	'ZZZ_045'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite excl'															, ; //X3_TITULO
	'Permite excl'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'47'																	, ; //X3_ORDEM
	'ZZZ_046'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Bloqueia des'															, ; //X3_TITULO
	'Bloqueia des'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'48'																	, ; //X3_ORDEM
	'ZZZ_047'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tem RDV'																, ; //X3_TITULO
	'Tem RDV'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'49'																	, ; //X3_ORDEM
	'ZZZ_048'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Trava RDV'																, ; //X3_TITULO
	'Trava RDV'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'50'																	, ; //X3_ORDEM
	'ZZZ_049'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dias Max de'															, ; //X3_TITULO
	'Dias Max de'															, ; //X3_TITSPA
	'Dias Max de'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'51'																	, ; //X3_ORDEM
	'ZZZ_050'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Trava frete'															, ; //X3_TITULO
	'Trava frete'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'52'																	, ; //X3_ORDEM
	'ZZZ_051'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Trava pedido'															, ; //X3_TITULO
	'Trava pedido'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'53'																	, ; //X3_ORDEM
	'ZZZ_052'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Base para co'															, ; //X3_TITULO
	'Base para co'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'54'																	, ; //X3_ORDEM
	'ZZZ_053'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'ComissÆo m¡n'															, ; //X3_TITULO
	'ComissÆo m¡n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'55'																	, ; //X3_ORDEM
	'ZZZ_054'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dias para ma'															, ; //X3_TITULO
	'Dias para ma'															, ; //X3_TITSPA
	'Dias para ma'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'56'																	, ; //X3_ORDEM
	'ZZZ_055'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe apenas'															, ; //X3_TITULO
	'Exibe apenas'															, ; //X3_TITSPA
	'Exibe apenas'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'57'																	, ; //X3_ORDEM
	'ZZZ_056'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe descon'															, ; //X3_TITULO
	'Exibe descon'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'58'																	, ; //X3_ORDEM
	'ZZZ_057'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Recalcula it'															, ; //X3_TITULO
	'Recalcula it'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'59'																	, ; //X3_ORDEM
	'ZZZ_058'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Empresa'																, ; //X3_TITULO
	'Empresa'																, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'60'																	, ; //X3_ORDEM
	'ZZZ_059'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'NÆo exibe o'															, ; //X3_TITULO
	'NÆo exibe o'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'61'																	, ; //X3_ORDEM
	'ZZZ_060'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Altera‡Æo de'															, ; //X3_TITULO
	'Altera‡Æo de'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'62'																	, ; //X3_ORDEM
	'ZZZ_061'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Calcula fide'															, ; //X3_TITULO
	'Calcula fide'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'63'																	, ; //X3_ORDEM
	'ZZZ_062'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Determina o'															, ; //X3_TITULO
	'Determina o'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'64'																	, ; //X3_ORDEM
	'ZZZ_063'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Percentual d'															, ; //X3_TITULO
	'Percentual d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'65'																	, ; //X3_ORDEM
	'ZZZ_064'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ocultar camp'															, ; //X3_TITULO
	'Ocultar camp'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'66'																	, ; //X3_ORDEM
	'ZZZ_065'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obriga digit'															, ; //X3_TITULO
	'Obriga digit'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'67'																	, ; //X3_ORDEM
	'ZZZ_066'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite reen'															, ; //X3_TITULO
	'Permite reen'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'68'																	, ; //X3_ORDEM
	'ZZZ_067'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Regra de blo'															, ; //X3_TITULO
	'Regra de blo'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'69'																	, ; //X3_ORDEM
	'ZZZ_068'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe entrad'															, ; //X3_TITULO
	'Exibe entrad'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'70'																	, ; //X3_ORDEM
	'ZZZ_069'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Obriga digit'															, ; //X3_TITULO
	'Obriga digit'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'71'																	, ; //X3_ORDEM
	'ZZZ_070'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'CNPJ da empr'															, ; //X3_TITULO
	'CNPJ da empr'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'72'																	, ; //X3_ORDEM
	'ZZZ_071'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Oculta o val'															, ; //X3_TITULO
	'Oculta o val'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'73'																	, ; //X3_ORDEM
	'ZZZ_072'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Justifica t¡'															, ; //X3_TITULO
	'Justifica t¡'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'74'																	, ; //X3_ORDEM
	'ZZZ_073'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Indica se ‚'															, ; //X3_TITULO
	'Indica se ‚'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'75'																	, ; //X3_ORDEM
	'ZZZ_074'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Recalcula to'															, ; //X3_TITULO
	'Recalcula to'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'76'																	, ; //X3_ORDEM
	'ZZZ_075'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tabela padrÆ'															, ; //X3_TITULO
	'Tabela padrÆ'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'77'																	, ; //X3_ORDEM
	'ZZZ_076'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Libera a dig'															, ; //X3_TITULO
	'Libera a dig'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'78'																	, ; //X3_ORDEM
	'ZZZ_077'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	200																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Login do gma'															, ; //X3_TITULO
	'Login do gma'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'79'																	, ; //X3_ORDEM
	'ZZZ_078'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	200																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Senha gmail'															, ; //X3_TITULO
	'Senha gmail'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'80'																	, ; //X3_ORDEM
	'ZZZ_079'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'81'																	, ; //X3_ORDEM
	'ZZZ_080'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'82'																	, ; //X3_ORDEM
	'ZZZ_081'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fechamento d'															, ; //X3_TITULO
	'Fechamento d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'83'																	, ; //X3_ORDEM
	'ZZZ_082'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Indica se ut'															, ; //X3_TITULO
	'Indica se ut'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'84'																	, ; //X3_ORDEM
	'ZZZ_083'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Utiliza mapa'															, ; //X3_TITULO
	'Utiliza mapa'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'85'																	, ; //X3_ORDEM
	'ZZZ_084'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ignora versa'															, ; //X3_TITULO
	'Ignora versa'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'86'																	, ; //X3_ORDEM
	'ZZZ_085'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Email repres'															, ; //X3_TITULO
	'Email repres'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'87'																	, ; //X3_ORDEM
	'ZZZ_086'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Telefone rep'															, ; //X3_TITULO
	'Telefone rep'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'88'																	, ; //X3_ORDEM
	'ZZZ_087'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Utiliza Chec'															, ; //X3_TITULO
	'Utiliza Chec'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'89'																	, ; //X3_ORDEM
	'ZZZ_088'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Raio Check-i'															, ; //X3_TITULO
	'Raio Check-i'															, ; //X3_TITSPA
	'Raio Check-i'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'90'																	, ; //X3_ORDEM
	'ZZZ_089'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exige senha'															, ; //X3_TITULO
	'Exige senha'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'91'																	, ; //X3_ORDEM
	'ZZZ_090'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Quantidade d'															, ; //X3_TITULO
	'Quantidade d'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'92'																	, ; //X3_ORDEM
	'ZZZ_091'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	255																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'URL WebServi'															, ; //X3_TITULO
	'URL WebServi'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'93'																	, ; //X3_ORDEM
	'ZZZ_092'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Utiliza verb'															, ; //X3_TITULO
	'Utiliza verb'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'94'																	, ; //X3_ORDEM
	'ZZZ_093'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo para ca'															, ; //X3_TITULO
	'Tipo para ca'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'95'																	, ; //X3_ORDEM
	'ZZZ_094'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Habilita fla'															, ; //X3_TITULO
	'Habilita fla'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'96'																	, ; //X3_ORDEM
	'ZZZ_095'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Duplica‡Æo I'															, ; //X3_TITULO
	'Duplica‡Æo I'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'97'																	, ; //X3_ORDEM
	'ZZZ_096'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Troca Hist¢r'															, ; //X3_TITULO
	'Troca Hist¢r'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'98'																	, ; //X3_ORDEM
	'ZZZ_097'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibe descon'															, ; //X3_TITULO
	'Exibe descon'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'99'																	, ; //X3_ORDEM
	'ZZZ_098'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Confirma CNP'															, ; //X3_TITULO
	'Confirma CNP'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A0'																	, ; //X3_ORDEM
	'ZZZ_099'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Verifica a v'															, ; //X3_TITULO
	'Verifica a v'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A1'																	, ; //X3_ORDEM
	'ZZZ_100'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	''																		, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A2'																	, ; //X3_ORDEM
	'ZZZ_101'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibi t¡tulo'															, ; //X3_TITULO
	'Exibi t¡tulo'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A3'																	, ; //X3_ORDEM
	'ZZZ_102'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Permite alte'															, ; //X3_TITULO
	'Permite alte'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A4'																	, ; //X3_ORDEM
	'ZZZ_103'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exporta iten'															, ; //X3_TITULO
	'Exporta iten'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A5'																	, ; //X3_ORDEM
	'ZZZ_104'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'ComissÆo m¡n'															, ; //X3_TITULO
	'ComissÆo m¡n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A6'																	, ; //X3_ORDEM
	'ZZZ_105'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'ComissÆo m x'															, ; //X3_TITULO
	'ComissÆo m x'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A7'																	, ; //X3_ORDEM
	'ZZZ_106'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Comportament'															, ; //X3_TITULO
	'Comportament'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A8'																	, ; //X3_ORDEM
	'ZZZ_107'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Retira frete'															, ; //X3_TITULO
	'Retira frete'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'A9'																	, ; //X3_ORDEM
	'ZZZ_108'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ordena‡Æo do'															, ; //X3_TITULO
	'Ordena‡Æo do'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B0'																	, ; //X3_ORDEM
	'ZZZ_119'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Modelo do PD'															, ; //X3_TITULO
	'Modelo do PD'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B1'																	, ; //X3_ORDEM
	'ZZZ_110'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	140																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Observa‡Æo n'															, ; //X3_TITULO
	'Observa‡Æo n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B2'																	, ; //X3_ORDEM
	'ZZZ_111'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	140																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Observa‡Æo n'															, ; //X3_TITULO
	'Observa‡Æo n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B3'																	, ; //X3_ORDEM
	'ZZZ_112'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	140																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Observa‡Æo n'															, ; //X3_TITULO
	'Observa‡Æo n'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B4'																	, ; //X3_ORDEM
	'ZZZ_113'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Base do Calc'															, ; //X3_TITULO
	'Base do Calc'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B5'																	, ; //X3_ORDEM
	'ZZZ_114'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Flag para c '															, ; //X3_TITULO
	'Flag para c '															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B6'																	, ; //X3_ORDEM
	'ZZZ_115'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exibir o val'															, ; //X3_TITULO
	'Exibir o val'															, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
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
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B7'																	, ; //X3_ORDEM
	'ZZZ_117'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Inf Per Fret'															, ; //X3_TITULO
	'Inf Per Fret'															, ; //X3_TITSPA
	'Inf Per Fret'															, ; //X3_TITENG
	'PAR_INFORMAPERCENTUALFRET'												, ; //X3_DESCRIC
	'PAR_INFORMAPERCENTUALFRET'												, ; //X3_DESCSPA
	'PAR_INFORMAPERCENTUALFRET'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'S=Sim;N=Nao'															, ; //X3_CBOX
	'S=Sim;N=Nao'															, ; //X3_CBOXSPA
	'S=Sim;N=Nao'															, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZZZ'																	, ; //X3_ARQUIVO
	'B8'																	, ; //X3_ORDEM
	'ZZZ_120'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exb Frt Embu'															, ; //X3_TITULO
	'Exb Frt Embu'															, ; //X3_TITSPA
	'Exb Frt Embu'															, ; //X3_TITENG
	'PAR_EXIBEFRETEEMBUTE'													, ; //X3_DESCRIC
	'PAR_EXIBEFRETEEMBUTE'													, ; //X3_DESCSPA
	'PAR_EXIBEFRETEEMBUTE'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	"'N'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'S=Sim;N=Nao'															, ; //X3_CBOX
	'S=Sim;N=Nao'															, ; //X3_CBOXSPA
	'S=Sim;N=Nao'															, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME


//
// Atualizando dicionário
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
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
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo] )

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSIX()
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela SA1
//
aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'E'																		, ; //ORDEM
	'A1_FILIAL+A1_EST+A1_MUN'												, ; //CHAVE
	'ESTADO+CIDADE'															, ; //DESCRICAO
	'ESTADO+CIDADE'															, ; //DESCSPA
	'ESTADO+CIDADE'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'F'																		, ; //ORDEM
	'A1_FILIAL+A1_CEP'														, ; //CHAVE
	'CEP'																	, ; //DESCRICAO
	''																		, ; //DESCSPA
	''																		, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

//
// Tabela SA3
//
aAdd( aSIX, { ;
	'SA3'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'A3_FILIAL+A3_CEP'														, ; //CHAVE
	'CEP'																	, ; //DESCRICAO
	'CEP'																	, ; //DESCSPA
	'CEP'																	, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA3'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'A3_FILIAL+A3_SENHA'													, ; //CHAVE
	'Senha'																	, ; //DESCRICAO
	'Contrasena'															, ; //DESCSPA
	'Password'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA3'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'A3_FILIAL+A3_NREDUZ'													, ; //CHAVE
	'Nome Reduzid'															, ; //DESCRICAO
	'Nomb  Reduc.'															, ; //DESCSPA
	'Short Name'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA3'																	, ; //INDICE
	'E'																		, ; //ORDEM
	'A3_FILIAL+A3_EST+A3_MUN'												, ; //CHAVE
	'ESTADO+CIDADE'															, ; //DESCRICAO
	''																		, ; //DESCSPA
	''																		, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

//
// Tabela SC5
//
aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'C5_FILIAL+C5_LIBEROK'													, ; //CHAVE
	'Flag de liberacao'														, ; //DESCRICAO
	'Flag de liberacao'														, ; //DESCSPA
	'Flag de liberacao'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'C5_FILIAL+C5_XPEDEMP'													, ; //CHAVE
	'Ped Guarani'															, ; //DESCRICAO
	'Ped Guarani'															, ; //DESCSPA
	'Ped Guarani'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'C5XPEDEMP'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZB1
//
aAdd( aSIX, { ;
	'ZB1'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZB1_FILIAL+ZB1_REGRA'													, ; //CHAVE
	'Regra'																	, ; //DESCRICAO
	'Regra'																	, ; //DESCSPA
	'Regra'																	, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZB2
//
aAdd( aSIX, { ;
	'ZB2'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZB2_FILIAL+ZB2_REGRA+ZB2_ITEM'											, ; //CHAVE
	'Regra+Item'															, ; //DESCRICAO
	'Regra+Item'															, ; //DESCSPA
	'Regra+Item'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZB3
//
aAdd( aSIX, { ;
	'ZB3'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZB3_FILIAL+ZB3_CLIENT+ZB3_LOJA+ZB3_TPFRET'								, ; //CHAVE
	'Cliente+Loja Cli+Tipo Frete'											, ; //DESCRICAO
	'Cliente+Loja Cli+Tipo Frete'											, ; //DESCSPA
	'Cliente+Loja Cli+Tipo Frete'											, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZB4
//
aAdd( aSIX, { ;
	'ZB4'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZB4_FILIAL+ZB4_TABELA+ZB4_COND'										, ; //CHAVE
	'Tabela+Condicao'														, ; //DESCRICAO
	'Tabela+Condicao'														, ; //DESCSPA
	'Tabela+Condicao'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZB5
//
aAdd( aSIX, { ;
	'ZB5'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZB5_FILIAL+ZB5_PEDEMP'													, ; //CHAVE
	'Ped Empresa'															, ; //DESCRICAO
	'Ped Empresa'															, ; //DESCSPA
	'Ped Empresa'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZB6
//
aAdd( aSIX, { ;
	'ZB6'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZB6_FILIAL+ZB6_PEDEMP+ZB6_SEQUEN'										, ; //CHAVE
	'Ped Emp+Sequencia'														, ; //DESCRICAO
	'Ped Emp+Sequencia'														, ; //DESCSPA
	'Ped Emp+Sequencia'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZB6'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZB6_FILIAL+ZB6_PEDEMP+ZB6_COD'											, ; //CHAVE
	'Ped Emp+Produto'														, ; //DESCRICAO
	'Ped Emp+Produto'														, ; //DESCSPA
	'Ped Emp+Produto'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela ZBZ
//
aAdd( aSIX, { ;
	'ZBZ'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZBZ_FILIAL+ZBZ_001'													, ; //CHAVE
	'C¢digo Vende'															, ; //DESCRICAO
	'C¢digo Vende'															, ; //DESCSPA
	'C¢digo Vende'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZZZ
//
aAdd( aSIX, { ;
	'ZZZ'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZZZ_FILIAL+ZZZ_001'													, ; //CHAVE
	'C¢digo Vende'															, ; //DESCRICAO
	'C¢digo Vende'															, ; //DESCSPA
	'C¢digo Vende'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for alteração precisa apagar o indice do banco
		EndIf
	EndIf

	RecLock( "SIX", !lAlt )
	For nJ := 1 To Len( aSIX[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
		EndIf
	Next nJ
	MsUnLock()

	dbCommit()

	If lDelInd
		TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
	EndIf

	oProcess:IncRegua2( "Atualizando índices..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuHlp
Função de processamento da gravação dos Helps de Campos

@author TOTVS Protheus
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuHlp()
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

AutoGrLog( "Ínicio da Atualização" + " " + "Helps de Campos" + CRLF )


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

//
// Helps Tabela SA1
//
//
// Helps Tabela SA3
//
aHlpPor := {}
aAdd( aHlpPor, 'Comis Superv' )
aHlpEng := {}
aAdd( aHlpEng, 'Comis Superv' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comis Superv' )

PutSX1Help( "PA3_COMIS2 ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "A3_COMIS2" )

aHlpPor := {}
aAdd( aHlpPor, 'Comis Gerent' )
aHlpEng := {}
aAdd( aHlpEng, 'Comis Gerent' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comis Gerent' )

PutSX1Help( "PA3_COMIS3 ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "A3_COMIS3" )

aHlpPor := {}
aAdd( aHlpPor, 'Envia AFV?' )
aHlpEng := {}
aAdd( aHlpEng, 'Envia AFV?' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Envia AFV?' )

PutSX1Help( "PA3_XAFV   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "A3_XAFV" )

aHlpPor := {}
aAdd( aHlpPor, 'Tabelas' )
aHlpEng := {}
aAdd( aHlpEng, 'Tabelas' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tabelas' )

PutSX1Help( "PA3_XTABS  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "A3_XTABS" )

//
// Helps Tabela SC5
//
aHlpPor := {}
aAdd( aHlpPor, 'Informe se ocorrerá redespacho do' )
aAdd( aHlpPor, 'pedido(SIM ou NÃO).' )
aHlpEng := {}
aAdd( aHlpEng, 'Informe se ocorrerá redespacho do' )
aAdd( aHlpEng, 'pedido(SIM ou NÃO).' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Informe se ocorrerá redespacho do' )
aAdd( aHlpSpa, 'pedido(SIM ou NÃO).' )

PutSX1Help( "PC5_XTEMRED", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_XTEMRED" )

aHlpPor := {}
aAdd( aHlpPor, 'Tp Frete Red' )
aHlpEng := {}
aAdd( aHlpEng, 'Tp Frete Red' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tp Frete Red' )

PutSX1Help( "PC5_TPFREDE", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_TPFREDE" )

aHlpPor := {}
aAdd( aHlpPor, 'Informe a hora de saída' )
aHlpEng := {}
aAdd( aHlpEng, 'Informe a hora de saída' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Informe a hora de saída' )

PutSX1Help( "PC5_HORA   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_HORA" )

aHlpPor := {}
aAdd( aHlpPor, '$ Frete Red' )
aHlpEng := {}
aAdd( aHlpEng, '$ Frete Red' )
aHlpSpa := {}
aAdd( aHlpSpa, '$ Frete Red' )

PutSX1Help( "PC5_XVALFRR", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_XVALFRR" )

aHlpPor := {}
aAdd( aHlpPor, 'Obs Gua' )
aHlpEng := {}
aAdd( aHlpEng, 'Obs Gua' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obs Gua' )

PutSX1Help( "PC5_XOBS   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_XOBS" )

aHlpPor := {}
aAdd( aHlpPor, 'Obs Int Gua' )
aHlpEng := {}
aAdd( aHlpEng, 'Obs Int Gua' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obs Int Gua' )

PutSX1Help( "PC5_XOBSINT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_XOBSINT" )

aHlpPor := {}
aAdd( aHlpPor, 'OC Guarani' )
aHlpEng := {}
aAdd( aHlpEng, 'OC Guarani' )
aHlpSpa := {}
aAdd( aHlpSpa, 'OC Guarani' )

PutSX1Help( "PC5_XOC    ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_XOC" )

aHlpPor := {}
aAdd( aHlpPor, 'Dt Pr En GuaDt Pr En Gua' )
aHlpEng := {}
aAdd( aHlpEng, 'Dt Pr En GuaDt Pr En Gua' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dt Pr En GuaDt Pr En Gua' )

PutSX1Help( "PC5_XDTPENT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "C5_XDTPENT" )

//
// Helps Tabela SC6
//
//
// Helps Tabela SE4
//
aHlpPor := {}
aAdd( aHlpPor, 'Envia AFV?' )
aHlpEng := {}
aAdd( aHlpEng, 'Envia AFV?' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Envia AFV?' )

PutSX1Help( "PE4_XAFV   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "E4_XAFV" )

//
// Helps Tabela ZB1
//
aHlpPor := {}
aAdd( aHlpPor, 'Regra' )
aHlpEng := {}
aAdd( aHlpEng, 'Regra' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Regra' )

PutSX1Help( "PZB1_REGRA ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB1_REGRA" )

aHlpPor := {}
aAdd( aHlpPor, 'TP Comissao' )
aHlpEng := {}
aAdd( aHlpEng, 'TP Comissao' )
aHlpSpa := {}
aAdd( aHlpSpa, 'TP Comissao' )

PutSX1Help( "PZB1_TIPO  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB1_TIPO" )

aHlpPor := {}
aAdd( aHlpPor, 'Comissao' )
aHlpEng := {}
aAdd( aHlpEng, 'Comissao' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comissao' )

PutSX1Help( "PZB1_COMIS ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB1_COMIS" )

aHlpPor := {}
aAdd( aHlpPor, 'Com Flex' )
aHlpEng := {}
aAdd( aHlpEng, 'Com Flex' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Com Flex' )

PutSX1Help( "PZB1_FLEX  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB1_FLEX" )

aHlpPor := {}
aAdd( aHlpPor, 'Local B Comi' )
aHlpEng := {}
aAdd( aHlpEng, 'Local B Comi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Local B Comi' )

PutSX1Help( "PZB1_LBCOM ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB1_LBCOM" )

aHlpPor := {}
aAdd( aHlpPor, '% Verba Cred' )
aHlpEng := {}
aAdd( aHlpEng, '% Verba Cred' )
aHlpSpa := {}
aAdd( aHlpSpa, '% Verba Cred' )

PutSX1Help( "PZB1_PVERBC", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB1_PVERBC" )

aHlpPor := {}
aAdd( aHlpPor, 'Descricao' )
aHlpEng := {}
aAdd( aHlpEng, 'Descricao' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Descricao' )

PutSX1Help( "PZB1_DESCRI", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB1_DESCRI" )

//
// Helps Tabela ZB2
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial' )
aHlpEng := {}
aAdd( aHlpEng, 'Filial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Filial' )

PutSX1Help( "PZB2_FILIAL", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Regra' )
aHlpEng := {}
aAdd( aHlpEng, 'Regra' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Regra' )

PutSX1Help( "PZB2_REGRA ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_REGRA" )

aHlpPor := {}
aAdd( aHlpPor, 'Item' )
aHlpEng := {}
aAdd( aHlpEng, 'Item' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Item' )

PutSX1Help( "PZB2_ITEM  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_ITEM" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo Comissa' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo Comissa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo Comissa' )

PutSX1Help( "PZB2_TIPO  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_TIPO" )

aHlpPor := {}
aAdd( aHlpPor, 'Fx inicial' )
aHlpEng := {}
aAdd( aHlpEng, 'Fx inicial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fx inicial' )

PutSX1Help( "PZB2_FXINI ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_FXINI" )

aHlpPor := {}
aAdd( aHlpPor, 'Fx Final' )
aHlpEng := {}
aAdd( aHlpEng, 'Fx Final' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fx Final' )

PutSX1Help( "PZB2_FXFIN ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_FXFIN" )

aHlpPor := {}
aAdd( aHlpPor, 'Com Inicial' )
aHlpEng := {}
aAdd( aHlpEng, 'Com Inicial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Com Inicial' )

PutSX1Help( "PZB2_COMINI", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_COMINI" )

aHlpPor := {}
aAdd( aHlpPor, 'Com Final' )
aHlpEng := {}
aAdd( aHlpEng, 'Com Final' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Com Final' )

PutSX1Help( "PZB2_COMFIN", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_COMFIN" )

aHlpPor := {}
aAdd( aHlpPor, 'Bloquear' )
aHlpEng := {}
aAdd( aHlpEng, 'Bloquear' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Bloquear' )

PutSX1Help( "PZB2_BLQ   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB2_BLQ" )

//
// Helps Tabela ZB3
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial' )
aHlpEng := {}
aAdd( aHlpEng, 'Filial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Filial' )

PutSX1Help( "PZB3_FILIAL", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB3_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Cliente' )
aHlpEng := {}
aAdd( aHlpEng, 'Cliente' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Cliente' )

PutSX1Help( "PZB3_CLIENT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB3_CLIENT" )

aHlpPor := {}
aAdd( aHlpPor, 'Loja Cli' )
aHlpEng := {}
aAdd( aHlpEng, 'Loja Cli' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Loja Cli' )

PutSX1Help( "PZB3_LOJA  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB3_LOJA" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome' )
aHlpEng := {}
aAdd( aHlpEng, 'Nome' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Nome' )

PutSX1Help( "PZB3_NOME  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB3_NOME" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo Frete' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo Frete' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo Frete' )

PutSX1Help( "PZB3_TPFRET", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB3_TPFRET" )

aHlpPor := {}
aAdd( aHlpPor, 'Perc Frete' )
aHlpEng := {}
aAdd( aHlpEng, 'Perc Frete' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Perc Frete' )

PutSX1Help( "PZB3_PERC  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB3_PERC" )

//
// Helps Tabela ZB4
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial' )
aHlpEng := {}
aAdd( aHlpEng, 'Filial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Filial' )

PutSX1Help( "PZB4_FILIAL", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB4_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Tabela' )
aHlpEng := {}
aAdd( aHlpEng, 'Tabela' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tabela' )

PutSX1Help( "PZB4_TABELA", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB4_TABELA" )

aHlpPor := {}
aAdd( aHlpPor, 'Descricao' )
aHlpEng := {}
aAdd( aHlpEng, 'Descricao' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Descricao' )

PutSX1Help( "PZB4_DESCRI", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB4_DESCRI" )

aHlpPor := {}
aAdd( aHlpPor, 'Condicao' )
aHlpEng := {}
aAdd( aHlpEng, 'Condicao' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Condicao' )

PutSX1Help( "PZB4_COND  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB4_COND" )

aHlpPor := {}
aAdd( aHlpPor, 'Desc Condica' )
aHlpEng := {}
aAdd( aHlpEng, 'Desc Condica' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Desc Condica' )

PutSX1Help( "PZB4_DESCCO", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB4_DESCCO" )

//
// Helps Tabela ZB5
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial' )
aHlpEng := {}
aAdd( aHlpEng, 'Filial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Filial' )

PutSX1Help( "PZB5_FILIAL", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Ped Empresa' )
aHlpEng := {}
aAdd( aHlpEng, 'Ped Empresa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ped Empresa' )

PutSX1Help( "PZB5_PEDEMP", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_PEDEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Ped SFA' )
aHlpEng := {}
aAdd( aHlpEng, 'Ped SFA' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ped SFA' )

PutSX1Help( "PZB5_PEDSFA", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_PEDSFA" )

aHlpPor := {}
aAdd( aHlpPor, 'Sequencial' )
aHlpEng := {}
aAdd( aHlpEng, 'Sequencial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Sequencial' )

PutSX1Help( "PZB5_SEQUEN", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_SEQUEN" )

aHlpPor := {}
aAdd( aHlpPor, 'Cliente' )
aHlpEng := {}
aAdd( aHlpEng, 'Cliente' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Cliente' )

PutSX1Help( "PZB5_CLIENT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_CLIENT" )

aHlpPor := {}
aAdd( aHlpPor, 'Status' )
aHlpEng := {}
aAdd( aHlpEng, 'Status' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Status' )

PutSX1Help( "PZB5_STATUS", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_STATUS" )

aHlpPor := {}
aAdd( aHlpPor, 'Data Pedido' )
aHlpEng := {}
aAdd( aHlpEng, 'Data Pedido' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Data Pedido' )

PutSX1Help( "PZB5_DTPED ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_DTPED" )

aHlpPor := {}
aAdd( aHlpPor, 'Origem' )
aHlpEng := {}
aAdd( aHlpEng, 'Origem' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Origem' )

PutSX1Help( "PZB5_ORIGEM", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_ORIGEM" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo Pedido' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo Pedido' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo Pedido' )

PutSX1Help( "PZB5_TPPED ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_TPPED" )

aHlpPor := {}
aAdd( aHlpPor, 'Forma Pgto' )
aHlpEng := {}
aAdd( aHlpEng, 'Forma Pgto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Forma Pgto' )

PutSX1Help( "PZB5_FRMPGT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_FRMPGT" )

aHlpPor := {}
aAdd( aHlpPor, 'Plano Pgto' )
aHlpEng := {}
aAdd( aHlpEng, 'Plano Pgto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Plano Pgto' )

PutSX1Help( "PZB5_PLANO ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_PLANO" )

aHlpPor := {}
aAdd( aHlpPor, 'Cond Pgto' )
aHlpEng := {}
aAdd( aHlpEng, 'Cond Pgto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Cond Pgto' )

PutSX1Help( "PZB5_COND  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_COND" )

aHlpPor := {}
aAdd( aHlpPor, 'Representant' )
aHlpEng := {}
aAdd( aHlpEng, 'Representant' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Representant' )

PutSX1Help( "PZB5_VEND  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_VEND" )

aHlpPor := {}
aAdd( aHlpPor, 'Transportado' )
aHlpEng := {}
aAdd( aHlpEng, 'Transportado' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Transportado' )

PutSX1Help( "PZB5_TRANSP", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_TRANSP" )

aHlpPor := {}
aAdd( aHlpPor, 'Tabela' )
aHlpEng := {}
aAdd( aHlpEng, 'Tabela' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tabela' )

PutSX1Help( "PZB5_TABELA", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_TABELA" )

aHlpPor := {}
aAdd( aHlpPor, 'Dt Sinc' )
aHlpEng := {}
aAdd( aHlpEng, 'Dt Sinc' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dt Sinc' )

PutSX1Help( "PZB5_DTSINC", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_DTSINC" )

aHlpPor := {}
aAdd( aHlpPor, 'Dt Imp' )
aHlpEng := {}
aAdd( aHlpEng, 'Dt Imp' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dt Imp' )

PutSX1Help( "PZB5_DTIMP ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_DTIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora Imp' )
aHlpEng := {}
aAdd( aHlpEng, 'Hora Imp' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Hora Imp' )

PutSX1Help( "PZB5_HRIMP ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_HRIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Pedido' )
aHlpEng := {}
aAdd( aHlpEng, 'Pedido' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pedido' )

PutSX1Help( "PZB5_NUM   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_NUM" )

aHlpPor := {}
aAdd( aHlpPor, 'Dt Efetivac' )
aHlpEng := {}
aAdd( aHlpEng, 'Dt Efetivac' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dt Efetivac' )

PutSX1Help( "PZB5_DTEFET", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_DTEFET" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora Efetiva' )
aHlpEng := {}
aAdd( aHlpEng, 'Hora Efetiva' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Hora Efetiva' )

PutSX1Help( "PZB5_HREFET", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_HREFET" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor Pedido' )
aHlpEng := {}
aAdd( aHlpEng, 'Valor Pedido' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Valor Pedido' )

PutSX1Help( "PZB5_VALOR ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_VALOR" )

aHlpPor := {}
aAdd( aHlpPor, 'Marca' )
aHlpEng := {}
aAdd( aHlpEng, 'Marca' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Marca' )

PutSX1Help( "PZB5_OK    ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_OK" )

aHlpPor := {}
aAdd( aHlpPor, 'Import' )
aHlpEng := {}
aAdd( aHlpEng, 'Import' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Import' )

PutSX1Help( "PZB5_IMPORT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_IMPORT" )

aHlpPor := {}
aAdd( aHlpPor, 'Frete MB' )
aHlpEng := {}
aAdd( aHlpEng, 'Frete MB' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Frete MB' )

PutSX1Help( "PZB5_FRETMB", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_FRETMB" )

aHlpPor := {}
aAdd( aHlpPor, 'Obs' )
aHlpEng := {}
aAdd( aHlpEng, 'Obs' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obs' )

PutSX1Help( "PZB5_OBS   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_OBS" )

aHlpPor := {}
aAdd( aHlpPor, 'Obs Int' )
aHlpEng := {}
aAdd( aHlpEng, 'Obs Int' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obs Int' )

PutSX1Help( "PZB5_OBSINT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_OBSINT" )

aHlpPor := {}
aAdd( aHlpPor, 'OC' )
aHlpEng := {}
aAdd( aHlpEng, 'OC' )
aHlpSpa := {}
aAdd( aHlpSpa, 'OC' )

PutSX1Help( "PZB5_OC    ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_OC" )

aHlpPor := {}
aAdd( aHlpPor, 'Dt Prev Ent' )
aHlpEng := {}
aAdd( aHlpEng, 'Dt Prev Ent' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dt Prev Ent' )

PutSX1Help( "PZB5_DTPENT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_DTPENT" )

aHlpPor := {}
aAdd( aHlpPor, 'TP Frete' )
aHlpEng := {}
aAdd( aHlpEng, 'TP Frete' )
aHlpSpa := {}
aAdd( aHlpSpa, 'TP Frete' )

PutSX1Help( "PZB5_TPFRET", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB5_TPFRET" )

//
// Helps Tabela ZB6
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial' )
aHlpEng := {}
aAdd( aHlpEng, 'Filial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Filial' )

PutSX1Help( "PZB6_FILIAL", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Ped Emp' )
aHlpEng := {}
aAdd( aHlpEng, 'Ped Emp' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ped Emp' )

PutSX1Help( "PZB6_PEDEMP", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_PEDEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Sequencia' )
aHlpEng := {}
aAdd( aHlpEng, 'Sequencia' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Sequencia' )

PutSX1Help( "PZB6_SEQUEN", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_SEQUEN" )

aHlpPor := {}
aAdd( aHlpPor, 'Produto' )
aHlpEng := {}
aAdd( aHlpEng, 'Produto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Produto' )

PutSX1Help( "PZB6_COD   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Descricao' )
aHlpEng := {}
aAdd( aHlpEng, 'Descricao' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Descricao' )

PutSX1Help( "PZB6_DESCRI", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_DESCRI" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade' )
aHlpEng := {}
aAdd( aHlpEng, 'Quantidade' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Quantidade' )

PutSX1Help( "PZB6_QTDVEN", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_QTDVEN" )

aHlpPor := {}
aAdd( aHlpPor, 'Preco' )
aHlpEng := {}
aAdd( aHlpEng, 'Preco' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Preco' )

PutSX1Help( "PZB6_PRCVEN", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_PRCVEN" )

aHlpPor := {}
aAdd( aHlpPor, 'Preco Tabela' )
aHlpEng := {}
aAdd( aHlpEng, 'Preco Tabela' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Preco Tabela' )

PutSX1Help( "PZB6_PRUNIT", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_PRUNIT" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor Total' )
aHlpEng := {}
aAdd( aHlpEng, 'Valor Total' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Valor Total' )

PutSX1Help( "PZB6_VALOR ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_VALOR" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor Ipi' )
aHlpEng := {}
aAdd( aHlpEng, 'Valor Ipi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Valor Ipi' )

PutSX1Help( "PZB6_VALIPI", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_VALIPI" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor ST' )
aHlpEng := {}
aAdd( aHlpEng, 'Valor ST' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Valor ST' )

PutSX1Help( "PZB6_VALST ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_VALST" )

aHlpPor := {}
aAdd( aHlpPor, '% IPI' )
aHlpEng := {}
aAdd( aHlpEng, '% IPI' )
aHlpSpa := {}
aAdd( aHlpSpa, '% IPI' )

PutSX1Help( "PZB6_IPI   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_IPI" )

aHlpPor := {}
aAdd( aHlpPor, 'NCM' )
aHlpEng := {}
aAdd( aHlpEng, 'NCM' )
aHlpSpa := {}
aAdd( aHlpSpa, 'NCM' )

PutSX1Help( "PZB6_NCM   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_NCM" )

aHlpPor := {}
aAdd( aHlpPor, 'Embalagem' )
aHlpEng := {}
aAdd( aHlpEng, 'Embalagem' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Embalagem' )

PutSX1Help( "PZB6_EMB   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_EMB" )

aHlpPor := {}
aAdd( aHlpPor, 'Qtde embalag' )
aHlpEng := {}
aAdd( aHlpEng, 'Qtde embalag' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Qtde embalag' )

PutSX1Help( "PZB6_QTDEMB", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_QTDEMB" )

aHlpPor := {}
aAdd( aHlpPor, 'Item' )
aHlpEng := {}
aAdd( aHlpEng, 'Item' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Item' )

PutSX1Help( "PZB6_ITEM  ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_ITEM" )

aHlpPor := {}
aAdd( aHlpPor, '% Desconto' )
aHlpEng := {}
aAdd( aHlpEng, '% Desconto' )
aHlpSpa := {}
aAdd( aHlpSpa, '% Desconto' )

PutSX1Help( "PZB6_DESCON", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_DESCON" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor Desc' )
aHlpEng := {}
aAdd( aHlpEng, 'Valor Desc' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Valor Desc' )

PutSX1Help( "PZB6_VALDES", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZB6_VALDES" )

//
// Helps Tabela ZBZ
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial' )
aHlpEng := {}
aAdd( aHlpEng, 'Filial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Filial' )

PutSX1Help( "PZBZ_FILIAL", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'C¢digo Vende' )
aHlpEng := {}
aAdd( aHlpEng, 'C¢digo Vende' )
aHlpSpa := {}
aAdd( aHlpSpa, 'C¢digo Vende' )

PutSX1Help( "PZBZ_001   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_001" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome do Agen' )
aHlpEng := {}
aAdd( aHlpEng, 'Nome do Agen' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Nome do Agen' )

PutSX1Help( "PZBZ_002   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_002" )

aHlpPor := {}
aAdd( aHlpPor, 'N£mero Dias' )
aHlpEng := {}
aAdd( aHlpEng, 'N£mero Dias' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N£mero Dias' )

PutSX1Help( "PZBZ_003   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_003" )

aHlpPor := {}
aAdd( aHlpPor, 'Flag Permiti' )
aHlpEng := {}
aAdd( aHlpEng, 'Flag Permiti' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Flag Permiti' )

PutSX1Help( "PZBZ_004   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_004" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual q' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual q' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual q' )

PutSX1Help( "PZBZ_005   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_005" )

aHlpPor := {}
aAdd( aHlpPor, 'N£mero de Di' )
aHlpEng := {}
aAdd( aHlpEng, 'N£mero de Di' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N£mero de Di' )

PutSX1Help( "PZBZ_006   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_006" )

aHlpPor := {}
aAdd( aHlpPor, 'N£mero de Di' )
aHlpEng := {}
aAdd( aHlpEng, 'N£mero de Di' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N£mero de Di' )

PutSX1Help( "PZBZ_007   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_007" )

aHlpPor := {}
aAdd( aHlpPor, 'Mostrar Esto' )
aHlpEng := {}
aAdd( aHlpEng, 'Mostrar Esto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Mostrar Esto' )

PutSX1Help( "PZBZ_008   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_008" )

aHlpPor := {}
aAdd( aHlpPor, 'Mostrar Comi' )
aHlpEng := {}
aAdd( aHlpEng, 'Mostrar Comi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Mostrar Comi' )

PutSX1Help( "PZBZ_009   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_009" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite Exce' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite Exce' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite Exce' )

PutSX1Help( "PZBZ_010   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_010" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite Exce' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite Exce' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite Exce' )

PutSX1Help( "PZBZ_011   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_011" )

aHlpPor := {}
aAdd( aHlpPor, 'Bloquear ven' )
aHlpEng := {}
aAdd( aHlpEng, 'Bloquear ven' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Bloquear ven' )

PutSX1Help( "PZBZ_012   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_012" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo de Pess' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo de Pess' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo de Pess' )

PutSX1Help( "PZBZ_013   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_013" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo de Pess' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo de Pess' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo de Pess' )

PutSX1Help( "PZBZ_014   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_014" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite alte' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite alte' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite alte' )

PutSX1Help( "PZBZ_015   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_015" )

aHlpPor := {}
aAdd( aHlpPor, 'Verba Negati' )
aHlpEng := {}
aAdd( aHlpEng, 'Verba Negati' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Verba Negati' )

PutSX1Help( "PZBZ_016   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_016" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual d' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual d' )

PutSX1Help( "PZBZ_017   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_017" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual d' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual d' )

PutSX1Help( "PZBZ_018   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_018" )

aHlpPor := {}
aAdd( aHlpPor, 'Obriga justi' )
aHlpEng := {}
aAdd( aHlpEng, 'Obriga justi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obriga justi' )

PutSX1Help( "PZBZ_019   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_019" )

aHlpPor := {}
aAdd( aHlpPor, 'C¢digo do PA' )
aHlpEng := {}
aAdd( aHlpEng, 'C¢digo do PA' )
aHlpSpa := {}
aAdd( aHlpSpa, 'C¢digo do PA' )

PutSX1Help( "PZBZ_020   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_020" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZBZ_021   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_021" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZBZ_022   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_022" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZBZ_023   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_023" )

aHlpPor := {}
aAdd( aHlpPor, 'Justificar N' )
aHlpEng := {}
aAdd( aHlpEng, 'Justificar N' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Justificar N' )

PutSX1Help( "PZBZ_024   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_024" )

aHlpPor := {}
aAdd( aHlpPor, 'Exportar Pro' )
aHlpEng := {}
aAdd( aHlpEng, 'Exportar Pro' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exportar Pro' )

PutSX1Help( "PZBZ_025   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_025" )

aHlpPor := {}
aAdd( aHlpPor, 'Desconto M x' )
aHlpEng := {}
aAdd( aHlpEng, 'Desconto M x' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Desconto M x' )

PutSX1Help( "PZBZ_026   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_026" )

aHlpPor := {}
aAdd( aHlpPor, 'Acr‚scimo M ' )
aHlpEng := {}
aAdd( aHlpEng, 'Acr‚scimo M ' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Acr‚scimo M ' )

PutSX1Help( "PZBZ_027   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_027" )

aHlpPor := {}
aAdd( aHlpPor, 'Servidor FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Servidor FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Servidor FTP' )

PutSX1Help( "PZBZ_028   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_028" )

aHlpPor := {}
aAdd( aHlpPor, 'Porta FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Porta FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Porta FTP' )

PutSX1Help( "PZBZ_029   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_029" )

aHlpPor := {}
aAdd( aHlpPor, 'Usu rio FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Usu rio FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Usu rio FTP' )

PutSX1Help( "PZBZ_030   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_030" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha FTP' )

PutSX1Help( "PZBZ_031   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_031" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta de rec' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta de rec' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta de rec' )

PutSX1Help( "PZBZ_032   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_032" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta de env' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta de env' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta de env' )

PutSX1Help( "PZBZ_033   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_033" )

aHlpPor := {}
aAdd( aHlpPor, 'Local da ima' )
aHlpEng := {}
aAdd( aHlpEng, 'Local da ima' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Local da ima' )

PutSX1Help( "PZBZ_034   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_034" )

aHlpPor := {}
aAdd( aHlpPor, 'Login do sis' )
aHlpEng := {}
aAdd( aHlpEng, 'Login do sis' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Login do sis' )

PutSX1Help( "PZBZ_035   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_035" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha do sis' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha do sis' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha do sis' )

PutSX1Help( "PZBZ_036   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_036" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha para a' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha para a' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha para a' )

PutSX1Help( "PZBZ_037   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_037" )

aHlpPor := {}
aAdd( aHlpPor, 'Preposto' )
aHlpEng := {}
aAdd( aHlpEng, 'Preposto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Preposto' )

PutSX1Help( "PZBZ_038   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_038" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta de rec' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta de rec' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta de rec' )

PutSX1Help( "PZBZ_039   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_039" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta envio' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta envio' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta envio' )

PutSX1Help( "PZBZ_040   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_040" )

aHlpPor := {}
aAdd( aHlpPor, 'Flag Utiliza' )
aHlpEng := {}
aAdd( aHlpEng, 'Flag Utiliza' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Flag Utiliza' )

PutSX1Help( "PZBZ_041   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_041" )

aHlpPor := {}
aAdd( aHlpPor, 'M¢dulo FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'M¢dulo FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'M¢dulo FTP' )

PutSX1Help( "PZBZ_042   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_042" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite digi' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite digi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite digi' )

PutSX1Help( "PZBZ_043   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_043" )

aHlpPor := {}
aAdd( aHlpPor, 'Dias de carˆ' )
aHlpEng := {}
aAdd( aHlpEng, 'Dias de carˆ' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dias de carˆ' )

PutSX1Help( "PZBZ_044   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_044" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite excl' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite excl' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite excl' )

PutSX1Help( "PZBZ_045   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_045" )

aHlpPor := {}
aAdd( aHlpPor, 'Bloqueia des' )
aHlpEng := {}
aAdd( aHlpEng, 'Bloqueia des' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Bloqueia des' )

PutSX1Help( "PZBZ_046   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_046" )

aHlpPor := {}
aAdd( aHlpPor, 'Tem RDV' )
aHlpEng := {}
aAdd( aHlpEng, 'Tem RDV' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tem RDV' )

PutSX1Help( "PZBZ_047   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_047" )

aHlpPor := {}
aAdd( aHlpPor, 'Trava RDV' )
aHlpEng := {}
aAdd( aHlpEng, 'Trava RDV' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Trava RDV' )

PutSX1Help( "PZBZ_048   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_048" )

aHlpPor := {}
aAdd( aHlpPor, 'Dias Max de' )
aHlpEng := {}
aAdd( aHlpEng, 'Dias Max de' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dias Max de' )

PutSX1Help( "PZBZ_049   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_049" )

aHlpPor := {}
aAdd( aHlpPor, 'Trava frete' )
aHlpEng := {}
aAdd( aHlpEng, 'Trava frete' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Trava frete' )

PutSX1Help( "PZBZ_050   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_050" )

aHlpPor := {}
aAdd( aHlpPor, 'Trava pedido' )
aHlpEng := {}
aAdd( aHlpEng, 'Trava pedido' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Trava pedido' )

PutSX1Help( "PZBZ_051   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_051" )

aHlpPor := {}
aAdd( aHlpPor, 'Base para co' )
aHlpEng := {}
aAdd( aHlpEng, 'Base para co' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Base para co' )

PutSX1Help( "PZBZ_052   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_052" )

aHlpPor := {}
aAdd( aHlpPor, 'Comiss„o m¡n' )
aHlpEng := {}
aAdd( aHlpEng, 'Comiss„o m¡n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comiss„o m¡n' )

PutSX1Help( "PZBZ_053   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_053" )

aHlpPor := {}
aAdd( aHlpPor, 'Dias para ma' )
aHlpEng := {}
aAdd( aHlpEng, 'Dias para ma' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dias para ma' )

PutSX1Help( "PZBZ_054   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_054" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe apenas' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe apenas' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe apenas' )

PutSX1Help( "PZBZ_055   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_055" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe descon' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe descon' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe descon' )

PutSX1Help( "PZBZ_056   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_056" )

aHlpPor := {}
aAdd( aHlpPor, 'Recalcula it' )
aHlpEng := {}
aAdd( aHlpEng, 'Recalcula it' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Recalcula it' )

PutSX1Help( "PZBZ_057   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_057" )

aHlpPor := {}
aAdd( aHlpPor, 'Empresa' )
aHlpEng := {}
aAdd( aHlpEng, 'Empresa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Empresa' )

PutSX1Help( "PZBZ_058   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_058" )

aHlpPor := {}
aAdd( aHlpPor, 'N„o exibe o' )
aHlpEng := {}
aAdd( aHlpEng, 'N„o exibe o' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N„o exibe o' )

PutSX1Help( "PZBZ_059   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_059" )

aHlpPor := {}
aAdd( aHlpPor, 'Altera‡„o de' )
aHlpEng := {}
aAdd( aHlpEng, 'Altera‡„o de' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Altera‡„o de' )

PutSX1Help( "PZBZ_060   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_060" )

aHlpPor := {}
aAdd( aHlpPor, 'Calcula fide' )
aHlpEng := {}
aAdd( aHlpEng, 'Calcula fide' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Calcula fide' )

PutSX1Help( "PZBZ_061   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_061" )

aHlpPor := {}
aAdd( aHlpPor, 'Determina o' )
aHlpEng := {}
aAdd( aHlpEng, 'Determina o' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Determina o' )

PutSX1Help( "PZBZ_062   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_062" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual d' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual d' )

PutSX1Help( "PZBZ_063   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_063" )

aHlpPor := {}
aAdd( aHlpPor, 'Ocultar camp' )
aHlpEng := {}
aAdd( aHlpEng, 'Ocultar camp' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ocultar camp' )

PutSX1Help( "PZBZ_064   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_064" )

aHlpPor := {}
aAdd( aHlpPor, 'Obriga digit' )
aHlpEng := {}
aAdd( aHlpEng, 'Obriga digit' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obriga digit' )

PutSX1Help( "PZBZ_065   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_065" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite reen' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite reen' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite reen' )

PutSX1Help( "PZBZ_066   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_066" )

aHlpPor := {}
aAdd( aHlpPor, 'Regra de blo' )
aHlpEng := {}
aAdd( aHlpEng, 'Regra de blo' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Regra de blo' )

PutSX1Help( "PZBZ_067   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_067" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe entrad' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe entrad' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe entrad' )

PutSX1Help( "PZBZ_068   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_068" )

aHlpPor := {}
aAdd( aHlpPor, 'Obriga digit' )
aHlpEng := {}
aAdd( aHlpEng, 'Obriga digit' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obriga digit' )

PutSX1Help( "PZBZ_069   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_069" )

aHlpPor := {}
aAdd( aHlpPor, 'CNPJ da empr' )
aHlpEng := {}
aAdd( aHlpEng, 'CNPJ da empr' )
aHlpSpa := {}
aAdd( aHlpSpa, 'CNPJ da empr' )

PutSX1Help( "PZBZ_070   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_070" )

aHlpPor := {}
aAdd( aHlpPor, 'Oculta o val' )
aHlpEng := {}
aAdd( aHlpEng, 'Oculta o val' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Oculta o val' )

PutSX1Help( "PZBZ_071   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_071" )

aHlpPor := {}
aAdd( aHlpPor, 'Justifica t¡' )
aHlpEng := {}
aAdd( aHlpEng, 'Justifica t¡' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Justifica t¡' )

PutSX1Help( "PZBZ_072   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_072" )

aHlpPor := {}
aAdd( aHlpPor, 'Indica se ‚' )
aHlpEng := {}
aAdd( aHlpEng, 'Indica se ‚' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Indica se ‚' )

PutSX1Help( "PZBZ_073   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_073" )

aHlpPor := {}
aAdd( aHlpPor, 'Recalcula to' )
aHlpEng := {}
aAdd( aHlpEng, 'Recalcula to' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Recalcula to' )

PutSX1Help( "PZBZ_074   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_074" )

aHlpPor := {}
aAdd( aHlpPor, 'Tabela padr„' )
aHlpEng := {}
aAdd( aHlpEng, 'Tabela padr„' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tabela padr„' )

PutSX1Help( "PZBZ_075   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_075" )

aHlpPor := {}
aAdd( aHlpPor, 'Libera a dig' )
aHlpEng := {}
aAdd( aHlpEng, 'Libera a dig' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Libera a dig' )

PutSX1Help( "PZBZ_076   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_076" )

aHlpPor := {}
aAdd( aHlpPor, 'Login do gma' )
aHlpEng := {}
aAdd( aHlpEng, 'Login do gma' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Login do gma' )

PutSX1Help( "PZBZ_077   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_077" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha gmail' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha gmail' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha gmail' )

PutSX1Help( "PZBZ_078   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_078" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZBZ_079   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_079" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZBZ_080   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_080" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZBZ_081   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_081" )

aHlpPor := {}
aAdd( aHlpPor, 'Indica se ut' )
aHlpEng := {}
aAdd( aHlpEng, 'Indica se ut' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Indica se ut' )

PutSX1Help( "PZBZ_082   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_082" )

aHlpPor := {}
aAdd( aHlpPor, 'Utiliza mapa' )
aHlpEng := {}
aAdd( aHlpEng, 'Utiliza mapa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Utiliza mapa' )

PutSX1Help( "PZBZ_083   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_083" )

aHlpPor := {}
aAdd( aHlpPor, 'Ignora versa' )
aHlpEng := {}
aAdd( aHlpEng, 'Ignora versa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ignora versa' )

PutSX1Help( "PZBZ_084   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_084" )

aHlpPor := {}
aAdd( aHlpPor, 'Email repres' )
aHlpEng := {}
aAdd( aHlpEng, 'Email repres' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Email repres' )

PutSX1Help( "PZBZ_085   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_085" )

aHlpPor := {}
aAdd( aHlpPor, 'Telefone rep' )
aHlpEng := {}
aAdd( aHlpEng, 'Telefone rep' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Telefone rep' )

PutSX1Help( "PZBZ_086   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_086" )

aHlpPor := {}
aAdd( aHlpPor, 'Utiliza Chec' )
aHlpEng := {}
aAdd( aHlpEng, 'Utiliza Chec' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Utiliza Chec' )

PutSX1Help( "PZBZ_087   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_087" )

aHlpPor := {}
aAdd( aHlpPor, 'Raio Check-i' )
aHlpEng := {}
aAdd( aHlpEng, 'Raio Check-i' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Raio Check-i' )

PutSX1Help( "PZBZ_088   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_088" )

aHlpPor := {}
aAdd( aHlpPor, 'Exige senha' )
aHlpEng := {}
aAdd( aHlpEng, 'Exige senha' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exige senha' )

PutSX1Help( "PZBZ_089   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_089" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade d' )
aHlpEng := {}
aAdd( aHlpEng, 'Quantidade d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Quantidade d' )

PutSX1Help( "PZBZ_090   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_090" )

aHlpPor := {}
aAdd( aHlpPor, 'URL WebServi' )
aHlpEng := {}
aAdd( aHlpEng, 'URL WebServi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'URL WebServi' )

PutSX1Help( "PZBZ_091   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_091" )

aHlpPor := {}
aAdd( aHlpPor, 'Utiliza verb' )
aHlpEng := {}
aAdd( aHlpEng, 'Utiliza verb' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Utiliza verb' )

PutSX1Help( "PZBZ_092   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_092" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo para ca' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo para ca' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo para ca' )

PutSX1Help( "PZBZ_093   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_093" )

aHlpPor := {}
aAdd( aHlpPor, 'Habilita fla' )
aHlpEng := {}
aAdd( aHlpEng, 'Habilita fla' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Habilita fla' )

PutSX1Help( "PZBZ_094   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_094" )

aHlpPor := {}
aAdd( aHlpPor, 'Duplica‡„o I' )
aHlpEng := {}
aAdd( aHlpEng, 'Duplica‡„o I' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Duplica‡„o I' )

PutSX1Help( "PZBZ_095   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_095" )

aHlpPor := {}
aAdd( aHlpPor, 'Troca Hist¢r' )
aHlpEng := {}
aAdd( aHlpEng, 'Troca Hist¢r' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Troca Hist¢r' )

PutSX1Help( "PZBZ_096   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_096" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe descon' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe descon' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe descon' )

PutSX1Help( "PZBZ_097   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_097" )

aHlpPor := {}
aAdd( aHlpPor, 'Confirma CNP' )
aHlpEng := {}
aAdd( aHlpEng, 'Confirma CNP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Confirma CNP' )

PutSX1Help( "PZBZ_098   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_098" )

aHlpPor := {}
aAdd( aHlpPor, 'Verifica a v' )
aHlpEng := {}
aAdd( aHlpEng, 'Verifica a v' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Verifica a v' )

PutSX1Help( "PZBZ_099   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_099" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibi t¡tulo' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibi t¡tulo' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibi t¡tulo' )

PutSX1Help( "PZBZ_101   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_101" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite alte' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite alte' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite alte' )

PutSX1Help( "PZBZ_102   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_102" )

aHlpPor := {}
aAdd( aHlpPor, 'Exporta iten' )
aHlpEng := {}
aAdd( aHlpEng, 'Exporta iten' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exporta iten' )

PutSX1Help( "PZBZ_103   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_103" )

aHlpPor := {}
aAdd( aHlpPor, 'Comiss„o m¡n' )
aHlpEng := {}
aAdd( aHlpEng, 'Comiss„o m¡n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comiss„o m¡n' )

PutSX1Help( "PZBZ_104   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_104" )

aHlpPor := {}
aAdd( aHlpPor, 'Comiss„o m x' )
aHlpEng := {}
aAdd( aHlpEng, 'Comiss„o m x' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comiss„o m x' )

PutSX1Help( "PZBZ_105   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_105" )

aHlpPor := {}
aAdd( aHlpPor, 'Comportament' )
aHlpEng := {}
aAdd( aHlpEng, 'Comportament' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comportament' )

PutSX1Help( "PZBZ_106   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_106" )

aHlpPor := {}
aAdd( aHlpPor, 'Retira frete' )
aHlpEng := {}
aAdd( aHlpEng, 'Retira frete' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Retira frete' )

PutSX1Help( "PZBZ_107   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_107" )

aHlpPor := {}
aAdd( aHlpPor, 'Ordena‡„o do' )
aHlpEng := {}
aAdd( aHlpEng, 'Ordena‡„o do' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ordena‡„o do' )

PutSX1Help( "PZBZ_108   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_108" )

aHlpPor := {}
aAdd( aHlpPor, 'Modelo do PD' )
aHlpEng := {}
aAdd( aHlpEng, 'Modelo do PD' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Modelo do PD' )

PutSX1Help( "PZBZ_119   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_119" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa‡„o n' )
aHlpEng := {}
aAdd( aHlpEng, 'Observa‡„o n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Observa‡„o n' )

PutSX1Help( "PZBZ_110   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_110" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa‡„o n' )
aHlpEng := {}
aAdd( aHlpEng, 'Observa‡„o n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Observa‡„o n' )

PutSX1Help( "PZBZ_111   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_111" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa‡„o n' )
aHlpEng := {}
aAdd( aHlpEng, 'Observa‡„o n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Observa‡„o n' )

PutSX1Help( "PZBZ_112   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_112" )

aHlpPor := {}
aAdd( aHlpPor, 'Base do Calc' )
aHlpEng := {}
aAdd( aHlpEng, 'Base do Calc' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Base do Calc' )

PutSX1Help( "PZBZ_113   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_113" )

aHlpPor := {}
aAdd( aHlpPor, 'Flag para c ' )
aHlpEng := {}
aAdd( aHlpEng, 'Flag para c ' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Flag para c ' )

PutSX1Help( "PZBZ_114   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_114" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibir o val' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibir o val' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibir o val' )

PutSX1Help( "PZBZ_115   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZBZ_115" )

//
// Helps Tabela ZZZ
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial' )
aHlpEng := {}
aAdd( aHlpEng, 'Filial' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Filial' )

PutSX1Help( "PZZZ_FILIAL", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'C¢digo Vende' )
aHlpEng := {}
aAdd( aHlpEng, 'C¢digo Vende' )
aHlpSpa := {}
aAdd( aHlpSpa, 'C¢digo Vende' )

PutSX1Help( "PZZZ_001   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_001" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome do Agen' )
aHlpEng := {}
aAdd( aHlpEng, 'Nome do Agen' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Nome do Agen' )

PutSX1Help( "PZZZ_002   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_002" )

aHlpPor := {}
aAdd( aHlpPor, 'N£mero Dias' )
aHlpEng := {}
aAdd( aHlpEng, 'N£mero Dias' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N£mero Dias' )

PutSX1Help( "PZZZ_003   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_003" )

aHlpPor := {}
aAdd( aHlpPor, 'Flag Permiti' )
aHlpEng := {}
aAdd( aHlpEng, 'Flag Permiti' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Flag Permiti' )

PutSX1Help( "PZZZ_004   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_004" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual q' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual q' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual q' )

PutSX1Help( "PZZZ_005   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_005" )

aHlpPor := {}
aAdd( aHlpPor, 'N£mero de Di' )
aHlpEng := {}
aAdd( aHlpEng, 'N£mero de Di' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N£mero de Di' )

PutSX1Help( "PZZZ_006   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_006" )

aHlpPor := {}
aAdd( aHlpPor, 'N£mero de Di' )
aHlpEng := {}
aAdd( aHlpEng, 'N£mero de Di' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N£mero de Di' )

PutSX1Help( "PZZZ_007   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_007" )

aHlpPor := {}
aAdd( aHlpPor, 'Mostrar Esto' )
aHlpEng := {}
aAdd( aHlpEng, 'Mostrar Esto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Mostrar Esto' )

PutSX1Help( "PZZZ_008   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_008" )

aHlpPor := {}
aAdd( aHlpPor, 'Mostrar Comi' )
aHlpEng := {}
aAdd( aHlpEng, 'Mostrar Comi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Mostrar Comi' )

PutSX1Help( "PZZZ_009   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_009" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite Exce' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite Exce' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite Exce' )

PutSX1Help( "PZZZ_010   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_010" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite Exce' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite Exce' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite Exce' )

PutSX1Help( "PZZZ_011   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_011" )

aHlpPor := {}
aAdd( aHlpPor, 'Bloquear ven' )
aHlpEng := {}
aAdd( aHlpEng, 'Bloquear ven' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Bloquear ven' )

PutSX1Help( "PZZZ_012   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_012" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo de Pess' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo de Pess' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo de Pess' )

PutSX1Help( "PZZZ_013   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_013" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo de Pess' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo de Pess' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo de Pess' )

PutSX1Help( "PZZZ_014   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_014" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite alte' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite alte' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite alte' )

PutSX1Help( "PZZZ_015   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_015" )

aHlpPor := {}
aAdd( aHlpPor, 'Verba Negati' )
aHlpEng := {}
aAdd( aHlpEng, 'Verba Negati' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Verba Negati' )

PutSX1Help( "PZZZ_016   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_016" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual d' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual d' )

PutSX1Help( "PZZZ_017   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_017" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual d' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual d' )

PutSX1Help( "PZZZ_018   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_018" )

aHlpPor := {}
aAdd( aHlpPor, 'Obriga justi' )
aHlpEng := {}
aAdd( aHlpEng, 'Obriga justi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obriga justi' )

PutSX1Help( "PZZZ_019   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_019" )

aHlpPor := {}
aAdd( aHlpPor, 'C¢digo do PA' )
aHlpEng := {}
aAdd( aHlpEng, 'C¢digo do PA' )
aHlpSpa := {}
aAdd( aHlpSpa, 'C¢digo do PA' )

PutSX1Help( "PZZZ_020   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_020" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZZZ_021   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_021" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZZZ_022   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_022" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZZZ_023   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_023" )

aHlpPor := {}
aAdd( aHlpPor, 'Justificar N' )
aHlpEng := {}
aAdd( aHlpEng, 'Justificar N' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Justificar N' )

PutSX1Help( "PZZZ_024   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_024" )

aHlpPor := {}
aAdd( aHlpPor, 'Exportar Pro' )
aHlpEng := {}
aAdd( aHlpEng, 'Exportar Pro' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exportar Pro' )

PutSX1Help( "PZZZ_025   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_025" )

aHlpPor := {}
aAdd( aHlpPor, 'Desconto M x' )
aHlpEng := {}
aAdd( aHlpEng, 'Desconto M x' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Desconto M x' )

PutSX1Help( "PZZZ_026   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_026" )

aHlpPor := {}
aAdd( aHlpPor, 'Acr‚scimo M ' )
aHlpEng := {}
aAdd( aHlpEng, 'Acr‚scimo M ' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Acr‚scimo M ' )

PutSX1Help( "PZZZ_027   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_027" )

aHlpPor := {}
aAdd( aHlpPor, 'Servidor FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Servidor FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Servidor FTP' )

PutSX1Help( "PZZZ_028   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_028" )

aHlpPor := {}
aAdd( aHlpPor, 'Porta FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Porta FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Porta FTP' )

PutSX1Help( "PZZZ_029   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_029" )

aHlpPor := {}
aAdd( aHlpPor, 'Usu rio FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Usu rio FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Usu rio FTP' )

PutSX1Help( "PZZZ_030   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_030" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha FTP' )

PutSX1Help( "PZZZ_031   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_031" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta de rec' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta de rec' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta de rec' )

PutSX1Help( "PZZZ_032   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_032" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta de env' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta de env' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta de env' )

PutSX1Help( "PZZZ_033   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_033" )

aHlpPor := {}
aAdd( aHlpPor, 'Local da ima' )
aHlpEng := {}
aAdd( aHlpEng, 'Local da ima' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Local da ima' )

PutSX1Help( "PZZZ_034   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_034" )

aHlpPor := {}
aAdd( aHlpPor, 'Login do sis' )
aHlpEng := {}
aAdd( aHlpEng, 'Login do sis' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Login do sis' )

PutSX1Help( "PZZZ_035   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_035" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha do sis' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha do sis' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha do sis' )

PutSX1Help( "PZZZ_036   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_036" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha para a' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha para a' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha para a' )

PutSX1Help( "PZZZ_037   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_037" )

aHlpPor := {}
aAdd( aHlpPor, 'Preposto' )
aHlpEng := {}
aAdd( aHlpEng, 'Preposto' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Preposto' )

PutSX1Help( "PZZZ_038   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_038" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta de rec' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta de rec' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta de rec' )

PutSX1Help( "PZZZ_039   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_039" )

aHlpPor := {}
aAdd( aHlpPor, 'Pasta envio' )
aHlpEng := {}
aAdd( aHlpEng, 'Pasta envio' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Pasta envio' )

PutSX1Help( "PZZZ_040   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_040" )

aHlpPor := {}
aAdd( aHlpPor, 'Flag Utiliza' )
aHlpEng := {}
aAdd( aHlpEng, 'Flag Utiliza' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Flag Utiliza' )

PutSX1Help( "PZZZ_041   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_041" )

aHlpPor := {}
aAdd( aHlpPor, 'M¢dulo FTP' )
aHlpEng := {}
aAdd( aHlpEng, 'M¢dulo FTP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'M¢dulo FTP' )

PutSX1Help( "PZZZ_042   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_042" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite digi' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite digi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite digi' )

PutSX1Help( "PZZZ_043   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_043" )

aHlpPor := {}
aAdd( aHlpPor, 'Dias de carˆ' )
aHlpEng := {}
aAdd( aHlpEng, 'Dias de carˆ' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dias de carˆ' )

PutSX1Help( "PZZZ_044   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_044" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite excl' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite excl' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite excl' )

PutSX1Help( "PZZZ_045   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_045" )

aHlpPor := {}
aAdd( aHlpPor, 'Bloqueia des' )
aHlpEng := {}
aAdd( aHlpEng, 'Bloqueia des' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Bloqueia des' )

PutSX1Help( "PZZZ_046   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_046" )

aHlpPor := {}
aAdd( aHlpPor, 'Tem RDV' )
aHlpEng := {}
aAdd( aHlpEng, 'Tem RDV' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tem RDV' )

PutSX1Help( "PZZZ_047   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_047" )

aHlpPor := {}
aAdd( aHlpPor, 'Trava RDV' )
aHlpEng := {}
aAdd( aHlpEng, 'Trava RDV' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Trava RDV' )

PutSX1Help( "PZZZ_048   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_048" )

aHlpPor := {}
aAdd( aHlpPor, 'Dias Max de' )
aHlpEng := {}
aAdd( aHlpEng, 'Dias Max de' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dias Max de' )

PutSX1Help( "PZZZ_049   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_049" )

aHlpPor := {}
aAdd( aHlpPor, 'Trava frete' )
aHlpEng := {}
aAdd( aHlpEng, 'Trava frete' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Trava frete' )

PutSX1Help( "PZZZ_050   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_050" )

aHlpPor := {}
aAdd( aHlpPor, 'Trava pedido' )
aHlpEng := {}
aAdd( aHlpEng, 'Trava pedido' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Trava pedido' )

PutSX1Help( "PZZZ_051   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_051" )

aHlpPor := {}
aAdd( aHlpPor, 'Base para co' )
aHlpEng := {}
aAdd( aHlpEng, 'Base para co' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Base para co' )

PutSX1Help( "PZZZ_052   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_052" )

aHlpPor := {}
aAdd( aHlpPor, 'Comiss„o m¡n' )
aHlpEng := {}
aAdd( aHlpEng, 'Comiss„o m¡n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comiss„o m¡n' )

PutSX1Help( "PZZZ_053   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_053" )

aHlpPor := {}
aAdd( aHlpPor, 'Dias para ma' )
aHlpEng := {}
aAdd( aHlpEng, 'Dias para ma' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Dias para ma' )

PutSX1Help( "PZZZ_054   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_054" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe apenas' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe apenas' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe apenas' )

PutSX1Help( "PZZZ_055   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_055" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe descon' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe descon' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe descon' )

PutSX1Help( "PZZZ_056   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_056" )

aHlpPor := {}
aAdd( aHlpPor, 'Recalcula it' )
aHlpEng := {}
aAdd( aHlpEng, 'Recalcula it' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Recalcula it' )

PutSX1Help( "PZZZ_057   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_057" )

aHlpPor := {}
aAdd( aHlpPor, 'Empresa' )
aHlpEng := {}
aAdd( aHlpEng, 'Empresa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Empresa' )

PutSX1Help( "PZZZ_058   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_058" )

aHlpPor := {}
aAdd( aHlpPor, 'N„o exibe o' )
aHlpEng := {}
aAdd( aHlpEng, 'N„o exibe o' )
aHlpSpa := {}
aAdd( aHlpSpa, 'N„o exibe o' )

PutSX1Help( "PZZZ_059   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_059" )

aHlpPor := {}
aAdd( aHlpPor, 'Altera‡„o de' )
aHlpEng := {}
aAdd( aHlpEng, 'Altera‡„o de' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Altera‡„o de' )

PutSX1Help( "PZZZ_060   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_060" )

aHlpPor := {}
aAdd( aHlpPor, 'Calcula fide' )
aHlpEng := {}
aAdd( aHlpEng, 'Calcula fide' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Calcula fide' )

PutSX1Help( "PZZZ_061   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_061" )

aHlpPor := {}
aAdd( aHlpPor, 'Determina o' )
aHlpEng := {}
aAdd( aHlpEng, 'Determina o' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Determina o' )

PutSX1Help( "PZZZ_062   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_062" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual d' )
aHlpEng := {}
aAdd( aHlpEng, 'Percentual d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Percentual d' )

PutSX1Help( "PZZZ_063   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_063" )

aHlpPor := {}
aAdd( aHlpPor, 'Ocultar camp' )
aHlpEng := {}
aAdd( aHlpEng, 'Ocultar camp' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ocultar camp' )

PutSX1Help( "PZZZ_064   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_064" )

aHlpPor := {}
aAdd( aHlpPor, 'Obriga digit' )
aHlpEng := {}
aAdd( aHlpEng, 'Obriga digit' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obriga digit' )

PutSX1Help( "PZZZ_065   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_065" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite reen' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite reen' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite reen' )

PutSX1Help( "PZZZ_066   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_066" )

aHlpPor := {}
aAdd( aHlpPor, 'Regra de blo' )
aHlpEng := {}
aAdd( aHlpEng, 'Regra de blo' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Regra de blo' )

PutSX1Help( "PZZZ_067   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_067" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe entrad' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe entrad' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe entrad' )

PutSX1Help( "PZZZ_068   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_068" )

aHlpPor := {}
aAdd( aHlpPor, 'Obriga digit' )
aHlpEng := {}
aAdd( aHlpEng, 'Obriga digit' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Obriga digit' )

PutSX1Help( "PZZZ_069   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_069" )

aHlpPor := {}
aAdd( aHlpPor, 'CNPJ da empr' )
aHlpEng := {}
aAdd( aHlpEng, 'CNPJ da empr' )
aHlpSpa := {}
aAdd( aHlpSpa, 'CNPJ da empr' )

PutSX1Help( "PZZZ_070   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_070" )

aHlpPor := {}
aAdd( aHlpPor, 'Oculta o val' )
aHlpEng := {}
aAdd( aHlpEng, 'Oculta o val' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Oculta o val' )

PutSX1Help( "PZZZ_071   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_071" )

aHlpPor := {}
aAdd( aHlpPor, 'Justifica t¡' )
aHlpEng := {}
aAdd( aHlpEng, 'Justifica t¡' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Justifica t¡' )

PutSX1Help( "PZZZ_072   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_072" )

aHlpPor := {}
aAdd( aHlpPor, 'Indica se ‚' )
aHlpEng := {}
aAdd( aHlpEng, 'Indica se ‚' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Indica se ‚' )

PutSX1Help( "PZZZ_073   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_073" )

aHlpPor := {}
aAdd( aHlpPor, 'Recalcula to' )
aHlpEng := {}
aAdd( aHlpEng, 'Recalcula to' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Recalcula to' )

PutSX1Help( "PZZZ_074   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_074" )

aHlpPor := {}
aAdd( aHlpPor, 'Tabela padr„' )
aHlpEng := {}
aAdd( aHlpEng, 'Tabela padr„' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tabela padr„' )

PutSX1Help( "PZZZ_075   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_075" )

aHlpPor := {}
aAdd( aHlpPor, 'Libera a dig' )
aHlpEng := {}
aAdd( aHlpEng, 'Libera a dig' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Libera a dig' )

PutSX1Help( "PZZZ_076   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_076" )

aHlpPor := {}
aAdd( aHlpPor, 'Login do gma' )
aHlpEng := {}
aAdd( aHlpEng, 'Login do gma' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Login do gma' )

PutSX1Help( "PZZZ_077   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_077" )

aHlpPor := {}
aAdd( aHlpPor, 'Senha gmail' )
aHlpEng := {}
aAdd( aHlpEng, 'Senha gmail' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Senha gmail' )

PutSX1Help( "PZZZ_078   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_078" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZZZ_079   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_079" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZZZ_080   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_080" )

aHlpPor := {}
aAdd( aHlpPor, 'Fechamento d' )
aHlpEng := {}
aAdd( aHlpEng, 'Fechamento d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Fechamento d' )

PutSX1Help( "PZZZ_081   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_081" )

aHlpPor := {}
aAdd( aHlpPor, 'Indica se ut' )
aHlpEng := {}
aAdd( aHlpEng, 'Indica se ut' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Indica se ut' )

PutSX1Help( "PZZZ_082   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_082" )

aHlpPor := {}
aAdd( aHlpPor, 'Utiliza mapa' )
aHlpEng := {}
aAdd( aHlpEng, 'Utiliza mapa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Utiliza mapa' )

PutSX1Help( "PZZZ_083   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_083" )

aHlpPor := {}
aAdd( aHlpPor, 'Ignora versa' )
aHlpEng := {}
aAdd( aHlpEng, 'Ignora versa' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ignora versa' )

PutSX1Help( "PZZZ_084   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_084" )

aHlpPor := {}
aAdd( aHlpPor, 'Email repres' )
aHlpEng := {}
aAdd( aHlpEng, 'Email repres' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Email repres' )

PutSX1Help( "PZZZ_085   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_085" )

aHlpPor := {}
aAdd( aHlpPor, 'Telefone rep' )
aHlpEng := {}
aAdd( aHlpEng, 'Telefone rep' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Telefone rep' )

PutSX1Help( "PZZZ_086   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_086" )

aHlpPor := {}
aAdd( aHlpPor, 'Utiliza Chec' )
aHlpEng := {}
aAdd( aHlpEng, 'Utiliza Chec' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Utiliza Chec' )

PutSX1Help( "PZZZ_087   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_087" )

aHlpPor := {}
aAdd( aHlpPor, 'Raio Check-i' )
aHlpEng := {}
aAdd( aHlpEng, 'Raio Check-i' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Raio Check-i' )

PutSX1Help( "PZZZ_088   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_088" )

aHlpPor := {}
aAdd( aHlpPor, 'Exige senha' )
aHlpEng := {}
aAdd( aHlpEng, 'Exige senha' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exige senha' )

PutSX1Help( "PZZZ_089   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_089" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade d' )
aHlpEng := {}
aAdd( aHlpEng, 'Quantidade d' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Quantidade d' )

PutSX1Help( "PZZZ_090   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_090" )

aHlpPor := {}
aAdd( aHlpPor, 'URL WebServi' )
aHlpEng := {}
aAdd( aHlpEng, 'URL WebServi' )
aHlpSpa := {}
aAdd( aHlpSpa, 'URL WebServi' )

PutSX1Help( "PZZZ_091   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_091" )

aHlpPor := {}
aAdd( aHlpPor, 'Utiliza verb' )
aHlpEng := {}
aAdd( aHlpEng, 'Utiliza verb' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Utiliza verb' )

PutSX1Help( "PZZZ_092   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_092" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo para ca' )
aHlpEng := {}
aAdd( aHlpEng, 'Tipo para ca' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Tipo para ca' )

PutSX1Help( "PZZZ_093   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_093" )

aHlpPor := {}
aAdd( aHlpPor, 'Habilita fla' )
aHlpEng := {}
aAdd( aHlpEng, 'Habilita fla' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Habilita fla' )

PutSX1Help( "PZZZ_094   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_094" )

aHlpPor := {}
aAdd( aHlpPor, 'Duplica‡„o I' )
aHlpEng := {}
aAdd( aHlpEng, 'Duplica‡„o I' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Duplica‡„o I' )

PutSX1Help( "PZZZ_095   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_095" )

aHlpPor := {}
aAdd( aHlpPor, 'Troca Hist¢r' )
aHlpEng := {}
aAdd( aHlpEng, 'Troca Hist¢r' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Troca Hist¢r' )

PutSX1Help( "PZZZ_096   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_096" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibe descon' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibe descon' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibe descon' )

PutSX1Help( "PZZZ_097   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_097" )

aHlpPor := {}
aAdd( aHlpPor, 'Confirma CNP' )
aHlpEng := {}
aAdd( aHlpEng, 'Confirma CNP' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Confirma CNP' )

PutSX1Help( "PZZZ_098   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_098" )

aHlpPor := {}
aAdd( aHlpPor, 'Verifica a v' )
aHlpEng := {}
aAdd( aHlpEng, 'Verifica a v' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Verifica a v' )

PutSX1Help( "PZZZ_099   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_099" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibi t¡tulo' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibi t¡tulo' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibi t¡tulo' )

PutSX1Help( "PZZZ_101   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_101" )

aHlpPor := {}
aAdd( aHlpPor, 'Permite alte' )
aHlpEng := {}
aAdd( aHlpEng, 'Permite alte' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Permite alte' )

PutSX1Help( "PZZZ_102   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_102" )

aHlpPor := {}
aAdd( aHlpPor, 'Exporta iten' )
aHlpEng := {}
aAdd( aHlpEng, 'Exporta iten' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exporta iten' )

PutSX1Help( "PZZZ_103   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_103" )

aHlpPor := {}
aAdd( aHlpPor, 'Comiss„o m¡n' )
aHlpEng := {}
aAdd( aHlpEng, 'Comiss„o m¡n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comiss„o m¡n' )

PutSX1Help( "PZZZ_104   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_104" )

aHlpPor := {}
aAdd( aHlpPor, 'Comiss„o m x' )
aHlpEng := {}
aAdd( aHlpEng, 'Comiss„o m x' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comiss„o m x' )

PutSX1Help( "PZZZ_105   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_105" )

aHlpPor := {}
aAdd( aHlpPor, 'Comportament' )
aHlpEng := {}
aAdd( aHlpEng, 'Comportament' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Comportament' )

PutSX1Help( "PZZZ_106   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_106" )

aHlpPor := {}
aAdd( aHlpPor, 'Retira frete' )
aHlpEng := {}
aAdd( aHlpEng, 'Retira frete' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Retira frete' )

PutSX1Help( "PZZZ_107   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_107" )

aHlpPor := {}
aAdd( aHlpPor, 'Ordena‡„o do' )
aHlpEng := {}
aAdd( aHlpEng, 'Ordena‡„o do' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Ordena‡„o do' )

PutSX1Help( "PZZZ_108   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_108" )

aHlpPor := {}
aAdd( aHlpPor, 'Modelo do PD' )
aHlpEng := {}
aAdd( aHlpEng, 'Modelo do PD' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Modelo do PD' )

PutSX1Help( "PZZZ_119   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_119" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa‡„o n' )
aHlpEng := {}
aAdd( aHlpEng, 'Observa‡„o n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Observa‡„o n' )

PutSX1Help( "PZZZ_110   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_110" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa‡„o n' )
aHlpEng := {}
aAdd( aHlpEng, 'Observa‡„o n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Observa‡„o n' )

PutSX1Help( "PZZZ_111   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_111" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa‡„o n' )
aHlpEng := {}
aAdd( aHlpEng, 'Observa‡„o n' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Observa‡„o n' )

PutSX1Help( "PZZZ_112   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_112" )

aHlpPor := {}
aAdd( aHlpPor, 'Base do Calc' )
aHlpEng := {}
aAdd( aHlpEng, 'Base do Calc' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Base do Calc' )

PutSX1Help( "PZZZ_113   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_113" )

aHlpPor := {}
aAdd( aHlpPor, 'Flag para c ' )
aHlpEng := {}
aAdd( aHlpEng, 'Flag para c ' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Flag para c ' )

PutSX1Help( "PZZZ_114   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_114" )

aHlpPor := {}
aAdd( aHlpPor, 'Exibir o val' )
aHlpEng := {}
aAdd( aHlpEng, 'Exibir o val' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exibir o val' )

PutSX1Help( "PZZZ_115   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_115" )

aHlpPor := {}
aAdd( aHlpPor, 'Inf Per Fret' )
aHlpEng := {}
aAdd( aHlpEng, 'Inf Per Fret' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Inf Per Fret' )

PutSX1Help( "PZZZ_117   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_117" )

aHlpPor := {}
aAdd( aHlpPor, 'Exb Frt Embu' )
aHlpEng := {}
aAdd( aHlpEng, 'Exb Frt Embu' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Exb Frt Embu' )

PutSX1Help( "PZZZ_120   ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZZZ_120" )

AutoGrLog( CRLF + "Final da Atualização" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF )

Return {}


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
Local   aRet      := {}
Local   aSalvAmb  := GetArea()
Local   aSalvSM0  := {}
Local   aVetor    := {}
Local   cMascEmp  := "??"
Local   cVar      := ""
Local   lChk      := .F.
Local   lOk       := .F.
Local   lTeveMarc := .F.
Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc

Local   aMarcadas := {}


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

Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

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

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDEXP" ) ) ) ;
Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
oButCanc:SetCss( CSSBOTAO )

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
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)
Local lOpen := .F.
Local nLoop := 0

If FindFunction( "OpenSM0Excl" )
	For nLoop := 1 To 20
		If OpenSM0Excl(,.F.)
			lOpen := .T.
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
Else
	For nLoop := 1 To 20
		dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
EndIf

If !lOpen
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  03/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.2 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
Local cRet  := ""
Local cFile := NomeAutoLog()
Local cAux  := ""

FT_FUSE( cFile )
FT_FGOTOP()

While !FT_FEOF()

	cAux := FT_FREADLN()

	If Len( cRet ) + Len( cAux ) < 1048000
		cRet += cAux + CRLF
	Else
		cRet += CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
