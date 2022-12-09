#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ UPDSZZCS บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de update dos dicionแrios para compatibiliza็ใo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ UPDSZZCS   - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UPDSZZCS( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAวรO DE DICIONมRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como fun็ใo fazer  a atualiza็ใo  dos dicionแrios do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja nใo podem haver outros"
Local   cDesc3    := "usuแrios  ou  jobs utilizando  o sistema.  ษ extremamente recomendav้l  que  se  fa็a um"
Local   cDesc4    := "BACKUP  dos DICIONมRIOS  e da  BASE DE DADOS antes desta atualiza็ใo, para que caso "
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
		If lAuto .OR. MsgNoYes( "Confirma a atualiza็ใo dos dicionแrios ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

		If lAuto
			If lOk
				MsgStop( "Atualiza็ใo Realizada.", "UPDSZZCS" )
				dbCloseAll()
			Else
				MsgStop( "Atualiza็ใo nใo Realizada.", "UPDSZZCS" )
				dbCloseAll()
			EndIf
		Else
			If lOk
				Final( "Atualiza็ใo Concluํda." )
			Else
				Final( "Atualiza็ใo nใo Realizada." )
			EndIf
		EndIf

		Else
			MsgStop( "Atualiza็ใo nใo Realizada.", "UPDSZZCS" )

		EndIf

	Else
		MsgStop( "Atualiza็ใo nใo Realizada.", "UPDSZZCS" )

	EndIf

EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSTProc  บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da grava็ใo dos arquivos           ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSTProc    - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
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
				MsgStop( "Atualiza็ใo da empresa " + aRecnoSM0[nI][2] + " nใo efetuada." )
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

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX2         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX3         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			FSAtuSX3( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SIX         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de ํndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX( @cTexto )

			oProcess:IncRegua1( "Dicionแrio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/ํndices" )

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
					MsgStop( "Ocorreu um erro desconhecido durante a atualiza็ใo da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionแrio e da tabela.", "ATENวรO" )
					cTexto += "Ocorreu um erro desconhecido durante a atualiza็ใo da estrutura da tabela : " + aArqUpd[nX] + CRLF
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX6         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de parโmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX7         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SXB         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de consultas padrใo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB( @cTexto )

			RpcClearEnv()

		Next nI

		If MyOpenSm0(.T.)

			cAux += Replicate( "-", 128 ) + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += "LOG DA ATUALIZACAO DOS DICIONมRIOS" + CRLF
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX2 บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX2 - Arquivos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX2   - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX2( cTexto )
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SX2" + CRLF + CRLF

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"  , "X2_NOMESPA", "X2_NOMEENG", ;
             "X2_DELET"  , "X2_MODO"   , "X2_TTS"    , "X2_ROTINA", "X2_PYME"   , "X2_UNICO"  , ;
             "X2_MODOEMP", "X2_MODOUN", "X2_MODULO" }

dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela SZZ
//
aAdd( aSX2, { ;
	'SZZ'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZZ'+cEmpr																, ; //X2_ARQUIVO
	'CADASTRO DE INVENTARIOS DE ATI'										, ; //X2_NOME
	'CADASTRO DE INVENTARIOS DE ATI'										, ; //X2_NOMESPA
	'CADASTRO DE INVENTARIOS DE ATI'										, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			cTexto += "Foi incluํda a tabela " + aSX2[nI][1] + CRLF
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
		dbCommit()
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
				cTexto += "Foi alterada chave unica da tabela " + aSX2[nI][1] + CRLF
			Else
				cTexto += "Foi criada   chave unica da tabela " + aSX2[nI][1] + CRLF
			EndIf
		EndIf

	EndIf

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX3 บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX3 - Campos        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX3   - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
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
Local nI        := 0
Local nJ        := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

cTexto  += "Inicio da Atualizacao" + " SX3" + CRLF + CRLF

aEstrut := { "X3_ARQUIVO", "X3_ORDEM"  , "X3_CAMPO"  , "X3_TIPO"   , "X3_TAMANHO", "X3_DECIMAL", ;
             "X3_TITULO" , "X3_TITSPA" , "X3_TITENG" , "X3_DESCRIC", "X3_DESCSPA", "X3_DESCENG", ;
             "X3_PICTURE", "X3_VALID"  , "X3_USADO"  , "X3_RELACAO", "X3_F3"     , "X3_NIVEL"  , ;
             "X3_RESERV" , "X3_CHECK"  , "X3_TRIGGER", "X3_PROPRI" , "X3_BROWSE" , "X3_VISUAL" , ;
             "X3_CONTEXT", "X3_OBRIGAT", "X3_VLDUSER", "X3_CBOX"   , "X3_CBOXSPA", "X3_CBOXENG", ;
             "X3_PICTVAR", "X3_WHEN"   , "X3_INIBRW" , "X3_GRPSXG" , "X3_FOLDER" , "X3_PYME"   }

//
// Tabela SZZ
//
aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZZ_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Filial'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	"xFilial('SZZ')"														, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_FILIAL')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZZ_TIPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo'																	, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Tipo'																	, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"If(ISINCALLSTACK('u_CSATV1INC'),_cTipoAtv,'')"							, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'1=Informa็ใo;2=Software;3=Fํsico;4=Servi็os;5=Intangํveis;6=Pessoas'		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZZ_CODIGO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Codigo'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Codigo'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"ExistChav('SZZ',M->ZZ_COD)"											, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"u_GetNewCodigo('SZZ')"													, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
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
	'SZZ'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZZ_PARTIC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Particip.'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Participante'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"Vazio() .Or. ExistCpo('RD0',M->ZZ_PARTIC,,,,.F.)"						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'RD0'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'u_CSGetPess()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_PARTIC')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZZ_CODSFT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Software'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Software'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"Vazio() .Or. ExistCpo('U04',M->ZZ_CODSFT,,,,.F.)"						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'U04XIS'																, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'u_CSGetSoft()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CODSFT')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZZ_CODHRD'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hardware'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Hardware'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"Vazio() .Or. ExistCpo('U00',M->ZZ_CODHRD,,,,.F.)"						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'U00XIS'																, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'u_CSGetHard()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CODHRD')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZZ_NOME'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome'																	, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Nome'																	, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_NOME')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZZ_FUNCAO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fun็ใo'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Fun็ใo'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_FUNCAO')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZZ_FGCHAV'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ger.Chaves'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Func. Gerencia Chaves'													, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZI'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_FGCHAV')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZZ_SUPERI'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Superior Ime'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Superior Imediato'														, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_SUPERI')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZZ_AVALDE'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Aval.Desempe'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Niv. Aval. Desempenho'													, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 999.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_AVALDE')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZZ_CLASS'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Classifica็ใ'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Classifica็ใo'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"ExistCpo('SX5','ZH'+M->ZZ_CLASS)"										, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZH'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetFATV(,'C')"														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CLASS')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZZ_DSCLAS'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc.Classif'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Descri็ใo Classif.'													, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_DSCLAS')"										, ; //X3_WHEN
	"Posicione('SX5',1,xFilial('SX5')+'ZH'+SZZ->ZZ_CLASS,'X5_DESCRI')"		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'ZZ_PREST'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Prest.Serv'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Prestador Servi็o'														, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"Vazio() .Or. ExistCpo('SA2',M->ZZ_PREST,,,,.F.)"						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SA2'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_PREST')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'ZZ_LOJA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Loja'																	, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Loja'																	, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"ExistCpo('SA2',M->ZZ_PREST+M->ZZ_LOJA)"								, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_LOJA')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'ZZ_CONTR'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Contrato'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Contrato'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"Vazio() .Or. ExistCpo('CN9',M->ZZ_CONTR,,,,.F.)"						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'CN9'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'u_CSGetServ()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CONTR')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'ZZ_EXPIR'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Exp.Contr'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Expiracao Contrato'													, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_EXPIR')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'ZZ_REVIS'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Revisใo'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Revisใo Contrato'														, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	''																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_REVIS')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'ZZ_IDENT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	254																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Identifica็ใ'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Identifica็ใo'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_IDENT')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'ZZ_MARCA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Marca/Modelo'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Marca/Modelo'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_MARCA')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'ZZ_ENTID1'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ent.Respons.'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Entidade'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	'u_CSGetProp()'															, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'1=Participantes;2=Cargos/Funcoes;3=Departamentos'		, ; //X3_CBOX
	'1=Participantes;2=Cargos/Funcoes;3=Departamentos'		, ; //X3_CBOXSPA
	'1=Participantes;2=Cargos/Funcoes;3=Departamentos'		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_ENTID1')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'ZZ_PROPRI'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Responsavel'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Responsavel'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
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
	'SZZ'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'ZZ_FORMAT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Natureza'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Natureza'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"ExistCpo('SX5','ZE'+M->ZZ_FORMAT)"										, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZE'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	"u_CSGetFATV(,'F')"														, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_FORMAT')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'ZZ_DSFORM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc.Formato'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Descri็ใo Formato'														, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_DSFORM')"										, ; //X3_WHEN
	"Posicione('SX5',1,xFilial('SX5')+'ZE'+SZZ->ZZ_FORMAT,'X5_DESCRI')"		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'ZZ_ENTLOC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ent.Local'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Entidade Local'														, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	'u_CSGetLoca(.F.)'														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'1=Filiais;2=Postos Atendimento;3=Data Center Backup'					, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_ENTLOC')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'ZZ_LOCAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Local'																	, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Localiza็ใo'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
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
	'SZZ'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'ZZ_SUBNIVE'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Sub Nivel'																, ; //X3_TITULO
	'Sub Nivel'																, ; //X3_TITSPA
	'Sub Nivel'																, ; //X3_TITENG
	'Sub Nivel'																, ; //X3_DESCRIC
	'Sub Nivel'																, ; //X3_DESCSPA
	'Sub Nivel'																, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
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
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'ZZ_LOCCON'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Contigencia'															, ; //X3_TITULO
	'Contigencia'															, ; //X3_TITSPA
	'Contigencia'															, ; //X3_TITENG
	'Contigencia'															, ; //X3_DESCRIC
	'Contigencia'															, ; //X3_DESCSPA
	'Contigencia'															, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	'u_CSGetLoca(.T.)'														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'1=Filiais;2=Postos Atendimento;3=Data Center Backup'					, ; //X3_CBOX
	'1=Filiais;2=Postos Atendimento;3=Data Center Backup'					, ; //X3_CBOXSPA
	'1=Filiais;2=Postos Atendimento;3=Data Center Backup'					, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'ZZ_LOCCONT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Local Contig'															, ; //X3_TITULO
	'Local Contig'															, ; //X3_TITSPA
	'Local Contig'															, ; //X3_TITENG
	'Local Contigencia'														, ; //X3_DESCRIC
	'Local Contigencia'														, ; //X3_DESCSPA
	'Local Contigencia'														, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
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
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'ZZ_SBNVCON'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Sb Nv Contig'															, ; //X3_TITULO
	'Sb Nv Contig'															, ; //X3_TITSPA
	'Sb Nv Contig'															, ; //X3_TITENG
	'Sub Nivel Contingencia'												, ; //X3_DESCRIC
	'Sub Nivel Contingencia'												, ; //X3_DESCSPA
	'Sub Nivel Contingencia'												, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
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
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'ZZ_QTDLIC'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Qtd. Licen็a'															, ; //X3_TITULO
	'Qtd. Licen็a'															, ; //X3_TITSPA
	'Qtd. Licen็a'															, ; //X3_TITENG
	'Qtde Licen็as'															, ; //X3_DESCRIC
	'Qtde Licen็as'															, ; //X3_DESCSPA
	'Qtde Licen็as'															, ; //X3_DESCENG
	'@E 99,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_QTDLIC')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'32'																	, ; //X3_ORDEM
	'ZZ_USOAPL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	16																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Polit. Uso'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Polit.Uso Aplicavel'													, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'QDH'																	, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_USOAPL')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'33'																	, ; //X3_ORDEM
	'ZZ_CONHEC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Conhecimento'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Conhecimento'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('P')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CONHEC')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'34'																	, ; //X3_ORDEM
	'ZZ_HABILI'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Habilidade'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Habilidade'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('P')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_HABILI')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'35'																	, ; //X3_ORDEM
	'ZZ_CONFID'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Confidencial'															, ; //X3_TITULO
	'Confidencial'															, ; //X3_TITSPA
	'Confidencial'															, ; //X3_TITENG
	'Confidencialidade'														, ; //X3_DESCRIC
	'Confidencialidade'														, ; //X3_DESCSPA
	'Confidencialidade'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('N')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CONFID')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'36'																	, ; //X3_ORDEM
	'ZZ_INTEGR'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Integridade'															, ; //X3_TITULO
	'Integridade'															, ; //X3_TITSPA
	'Integridade'															, ; //X3_TITENG
	'Integridade'															, ; //X3_DESCRIC
	'Integridade'															, ; //X3_DESCSPA
	'Integridade'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('N')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_INTEGR')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'37'																	, ; //X3_ORDEM
	'ZZ_DISPON'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Disponibilid'															, ; //X3_TITULO
	'Disponibilid'															, ; //X3_TITSPA
	'Disponibilid'															, ; //X3_TITENG
	'Disponibilidade'														, ; //X3_DESCRIC
	'Disponibilidade'														, ; //X3_DESCSPA
	'Disponibilidade'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('NP')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_DISPON')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'38'																	, ; //X3_ORDEM
	'ZZ_VLMERC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Val. Mercado'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Valor Mercado'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('I')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_VLMERC')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'39'																	, ; //X3_ORDEM
	'ZZ_RENTAB'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Integridade'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Integridade'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('I')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_RENTAB')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'40'																	, ; //X3_ORDEM
	'ZZ_CUSTO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Custo'																	, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Custo'																	, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	"Pertence('12345')"														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'1'"																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	"u_CSGetVATV('I')"														, ; //X3_VLDUSER
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOX
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXSPA
	'5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante'						, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CUSTO')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'41'																	, ; //X3_ORDEM
	'ZZ_VALOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Valor'																	, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Valor'																	, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@E 99'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'1'																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_VALOR')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'42'																	, ; //X3_ORDEM
	'ZZ_DSVAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Importancia'															, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Importancia'															, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	"'Irrelevante'"															, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_DSVAL')"											, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'43'																	, ; //X3_ORDEM
	'ZZ_ORIGEM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Origem'																, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Origem'																, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	'Funname()'																, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_ORIGEM')"										, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	'S'																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'44'																	, ; //X3_ORDEM
	'ZZ_CODGRP'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Grupo'																	, ; //X3_TITULO
	''																		, ; //X3_TITSPA
	''																		, ; //X3_TITENG
	'Grupo'																	, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	"Vazio() .Or. ExistCpo('U07',M->ZZ_CODGRP,,,,.F.)"						, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(32)						, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'U07_01'																, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'S'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	"u_CSVlAlAtv('SZZ','ZZ_CODGRP')"										, ; //X3_WHEN
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
				cTexto += "O tamanho do campo " + aSX3[nI][nPosCpo] + " nao atualizado e foi mantido em ["
				cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF
				cTexto += "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF
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

		cTexto += "Criado o campo " + aSX3[nI][nPosCpo] + CRLF

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam] <> SXG->XG_SIZE
					aSX3[nI][nPosTam] := SXG->XG_SIZE
					cTexto +=  "O tamanho do campo " + aSX3[nI][nPosCpo] + " nao atualizado e foi mantido em ["
					cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF
					cTexto +=  "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			If nJ <> nPosOrd  // Ordem
				cTexto += "Alterado o campo " + aSX3[nI][nPosCpo] + CRLF
				cTexto += "   " + PadR( SX3->( FieldName( nJ ) ), 10 ) + " de [" + AllToChar( SX3->( FieldGet( nJ ) ) ) + "]" + CRLF
				cTexto += "            para [" + AllToChar( aSX3[nI][nJ] )          + "]" + CRLF + CRLF

				RecLock( "SX3", .F. )
				FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
				dbCommit()
				MsUnLock()
			EndIf
		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSIX บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SIX - Indices       ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSIX   - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSIX( cTexto )
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SIX" + CRLF + CRLF

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela SZZ
//
aAdd( aSIX, { ;
	'SZZ'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZZ_FILIAL+ZZ_CODIGO'													, ; //CHAVE
	'FILIAL+CODIGO'															, ; //DESCRICAO
	'FILIAL+CODIGO'															, ; //DESCSPA
	'FILIAL+CODIGO'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZZ'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZZ_FILIAL+ZZ_NOME'														, ; //CHAVE
	'FILIAL+NOME'															, ; //DESCRICAO
	'FILIAL+NOME'															, ; //DESCSPA
	'FILIAL+NOME'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZZ'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'ZZ_FILIAL+ZZ_TIPO+ZZ_CODIGO'											, ; //CHAVE
	'FILIAL+TIPO+CODIGO'													, ; //DESCRICAO
	'FILIAL+TIPO+CODIGO'													, ; //DESCSPA
	'FILIAL+TIPO+CODIGO'													, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	''																		} ) //SHOWPESQ

//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		RecLock( "SIX", .T. )
		lDelInd := .F.
		cTexto += "อndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
	Else
		lAlt := .F.
		RecLock( "SIX", .F. )
	EndIf

	If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "") == ;
	    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
		aAdd( aArqUpd, aSIX[nI][1] )

		If lAlt
			lDelInd := .T. // Se for alteracao precisa apagar o indice do banco
			cTexto += "อndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
		EndIf

		For nJ := 1 To Len( aSIX[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
			EndIf
		Next nJ

		If lDelInd
			TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] ) // Exclui sem precisar baixar o TOP
		EndIf

	EndIf

	dbCommit()
	MsUnLock()

	oProcess:IncRegua2( "Atualizando ํndices..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX6 บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX6 - Parโmetros    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX6   - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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

cTexto  += "Inicio da Atualizacao" + " SX6" + CRLF + CRLF

aEstrut := { "X6_FIL"    , "X6_VAR"  , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , "X6_DSCSPA1",;
             "X6_DSCENG1", "X6_DESC2", "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", "X6_CONTENG", "X6_PROPRI" , "X6_PYME" }

aAdd( aSX6, { ;
	'	 '																	, ; //X6_FIL
	'MV_RESP1'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CertiSign'																, ; //X6_CONTEUD
	'CertiSign'																, ; //X6_CONTSPA
	'CertiSign'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_APDPROJ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indice se o item Avalia็ใo de Projetos deve ser'						, ; //X6_DESCRIC
	'Indique si el item Evaluac. de Proy. debe ser'							, ; //X6_DSCSPA
	'Enter if the item Project Evaluation must be'							, ; //X6_DSCENG
	'exibido no Portal (1=Sim; 2=Nใo)'										, ; //X6_DESC1
	'exhibido en el Portal (1=Si; 2=No)'									, ; //X6_DSCSPA1
	'displayed in the Portal (1=Yes; 2=No)'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_APDVDAT'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Verificar data de inicio e datas limite de'							, ; //X6_DESCRIC
	'Verificar fecha inicial y fechas limite de'							, ; //X6_DSCSPA
	'Check initial date and limit dates for'								, ; //X6_DSCENG
	'resposta para so permitir que a avaliacao seja'						, ; //X6_DESC1
	'respuesta para solo permitir que la evaluac. sea'						, ; //X6_DSCSPA1
	'answers. It allows the assessment to be'								, ; //X6_DSCENG1
	'seja preenchida caso esteja dentro do prazo.'							, ; //X6_DESC2
	'rellenada si esta dentro del plazo.'									, ; //X6_DSCSPA2
	'filled only within the term.'											, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_BAN001'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nome do banco para baixas quando o codigo da bande'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'deira for 001'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'VISA'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_BAN002'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nome do banco para baixas quando o codigo da bande'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'ira for 002'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'REDECARD'																, ; //X6_CONTEUD
	'REDECARD'																, ; //X6_CONTSPA
	'REDECARD'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_BAN007'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nome do banco para baixas quando o codigo da bande'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'ira for 007'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'REDECARD'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_BSCREPC'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define a base de calculo para Credito de Pis/Cofin'					, ; //X6_DESCRIC
	'Define base de calculo para Credito de Pis/Cofin'						, ; //X6_DSCSPA
	'Establishes Pis/Cofin credit calc. base'								, ; //X6_DSCENG
	'sobre Deprecia็ใo de Ativo. 1= Valor do bem'							, ; //X6_DESC1
	'bajo Deprec. de Activo. 1= Valor de bien'								, ; //X6_DSCSPA1
	'on Asset Depreciation. 1=Fixed Asset Value'							, ; //X6_DSCENG1
	'Imobilizado 2= Valor de Aquisi็ใo do Ativo'							, ; //X6_DESC2
	'Inmobilizado 2= Valor de Adquis. del Activo'							, ; //X6_DSCSPA2
	'2=Asset Acquisition Value'												, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_BTNRIMP'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DESCRIC
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DSCSPA
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DSCENG
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DESC1
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DSCSPA1
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DSCENG1
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DESC2
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DSCSPA2
	'Rotina refernete a Re-Impressao de propostas'							, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CCPCEP'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Parametro para ligar a consistencia do CEP da'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'tabela PA7 na Importacao de Clientes CertiSign'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CCPESTR'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define se ira pesquisar estrutura de produtos no'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Processo de Conversao de Pedidos de Vendas'							, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'CertiSign'																, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CHATWS'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Webservice do Chat'													, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://192.168.16.10:9090/ChatProviderService/ChatProvider'			, ; //X6_CONTEUD
	'http://192.168.16.10:9090/ChatProviderService/ChatProvider'			, ; //X6_CONTSPA
	'http://192.168.16.110:9090/ChatProviderService/ChatProvider'			, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CHKSOLI'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica se utiliza controle de solicitantes'							, ; //X6_DESCRIC
	'Indica si utiliza control de solicitudes'								, ; //X6_DSCSPA
	'It indicates if it uses requestors control for'						, ; //X6_DSCENG
	'para COMPRAS.'															, ; //X6_DESC1
	'para COMPRAS.'															, ; //X6_DSCSPA1
	'PURCHASES.'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_COMPNF'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Caminho a ser gravado o espelho da Danfe na rotina'					, ; //X6_DESCRIC
	'Caminho a ser gravado o espelho da Danfe na rotina'					, ; //X6_DSCSPA
	'Caminho a ser gravado o espelho da Danfe na rotina'					, ; //X6_DSCENG
	'de integracao GAR.'													, ; //X6_DESC1
	'de integracao GAR.'													, ; //X6_DSCSPA1
	'de integracao GAR.'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://hera.certintra.com.br/espelhonf/'								, ; //X6_CONTEUD
	'http://hera.certintra.com.br/espelhonf/'								, ; //X6_CONTSPA
	'http://hera.certintra.com.br/espelhonf/'								, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CT350QY'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'habilita a qry na efetua็ใo'											, ; //X6_DESCRIC
	'habilita la query en la efectuacion'									, ; //X6_DSCSPA
	'Enables query in accomplishment.'										, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CT350TC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'controle trace log na efetiva็ใo'										, ; //X6_DESCRIC
	'control trace log en la concrecion'									, ; //X6_DSCSPA
	'Trace log control in accomplishment.'									, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CT350VL'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica T= Atualiza os Saldos durante a Efetivacao'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de Pre-Lancamentos'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBSER'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Controle de Semafoo para processamento simultaneo.'					, ; //X6_DESCRIC
	'Controle de Semafoo para processamento simultaneo.'					, ; //X6_DSCSPA
	'Controle de Semafoo para processamento simultaneo.'					, ; //X6_DSCENG
	'CTB'																	, ; //X6_DESC1
	'CTB'																	, ; //X6_DSCSPA1
	'CTB'																	, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBSPRC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define se executa ou nao proc para o fcont'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_DESCFIN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se o desconto financeiro sera aplicado inte'					, ; //X6_DESCRIC
	'Indica si el descuento financiero se aplicara'							, ; //X6_DSCSPA
	'It indicates whether the financial deduction is to'					, ; //X6_DSCENG
	'gral ("I") no primeiro pagamento, ou proporcional'						, ; //X6_DESC1
	'integral  ("I") en el primer pago o proporcional'						, ; //X6_DSCSPA1
	'be paid fully (F) on the first payment or'								, ; //X6_DSCENG1
	'("P") ao valor pago en cada parcela.'									, ; //X6_DESC2
	'("P") al valor pagado en cada cuota.'									, ; //X6_DSCSPA2
	'proportional (P) to the amt. paid on each installm'					, ; //X6_DSCENG2
	'I'																		, ; //X6_CONTEUD
	'I'																		, ; //X6_CONTSPA
	'I'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FIN401D'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Executa dele็ใo fisica no reprocessamento dos dado'					, ; //X6_DESCRIC
	'Ejecuta borrado fisico en el reproc. de los datos'						, ; //X6_DSCSPA
	'It removes physically when reprocessing'								, ; //X6_DSCENG
	's da integra็ใo FIN X GPE para SEFIP. Aplica-se ap'					, ; //X6_DESC1
	'de la integracion FIN vs. GPE para SEFIP. Solo se'						, ; //X6_DSCSPA1
	'integration data FIN vs. GPE for SEFIP. Applied'						, ; //X6_DSCENG1
	'enas para bases TOPCONNECT (exceto AS400)'								, ; //X6_DESC2
	'aplica para bases TOPCONNECT (excepto AS400)'							, ; //X6_DSCSPA2
	'only to TOPCONNECT (except AS400)'										, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FNRESP1'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Fone do resposavel pela impressao de propostas'						, ; //X6_DESCRIC
	'Fone do resposavel pela impressao de propostas'						, ; //X6_DSCSPA
	'Fone do resposavel pela impressao de propostas'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'11-9-99999999'															, ; //X6_CONTEUD
	'11-9-99999999'															, ; //X6_CONTSPA
	'11-9-99999999'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FTPEND'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parโmetro de endere็o do FTP'											, ; //X6_DESCRIC
	'Parametro de direccion del FTP'										, ; //X6_DSCSPA
	'FTP address parameter'													, ; //X6_DSCENG
	'"localhost" - padrใo do sistema'										, ; //X6_DESC1
	'"localhost" - estandar del sistema'									, ; //X6_DSCSPA1
	'"localhost" - system default'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'192.168.16.30'															, ; //X6_CONTEUD
	'192.168.16.30'															, ; //X6_CONTSPA
	'192.168.16.30'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FTPPASS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parโmetro do password do FTP'											, ; //X6_DESCRIC
	'Parametro de contrasena del FTP'										, ; //X6_DSCSPA
	'FTP password parameter'												, ; //X6_DSCENG
	'"test@test.com" - padrใo do sistema'									, ; //X6_DESC1
	'"test@test.com" - estandar del sistema'								, ; //X6_DSCSPA1
	'"test@test.com" - system default'										, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'"teste@test.com"'														, ; //X6_CONTEUD
	'"teste@test.com"'														, ; //X6_CONTSPA
	'"teste@test.com"'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FTPPORT'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Parโmetro de compressใo do arquivo'									, ; //X6_DESCRIC
	'Parametro de compresion del archivo'									, ; //X6_DSCSPA
	'File compression parameter'											, ; //X6_DSCENG
	'21 - padrใo do sistema'												, ; //X6_DESC1
	'21 - estandar del sistema'												, ; //X6_DSCSPA1
	'21 - system default'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'21'																	, ; //X6_CONTEUD
	'23'																	, ; //X6_CONTSPA
	'23'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FTPUSER'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parโmetro do usuแrio do FTP'											, ; //X6_DESCRIC
	'Parametro del usuario del FTP'											, ; //X6_DSCSPA
	'FTP user parameter'													, ; //X6_DSCENG
	'"Anonymous" - padrใo do sistema'										, ; //X6_DESC1
	'"Anonymous" - estandar del sistema'									, ; //X6_DSCSPA1
	'"Anonymous" - system default'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'anonymous'																, ; //X6_CONTEUD
	'anonymous'																, ; //X6_CONTSPA
	'anonymous'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_GARBKFI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Reinicio do Faturamento On Line.'										, ; //X6_DESCRIC
	'Reinicio do Faturamento On Line.'										, ; //X6_DSCSPA
	'Reinicio do Faturamento On Line.'										, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'00:05'																	, ; //X6_CONTEUD
	'00:05'																	, ; //X6_CONTSPA
	'00:05'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_GARBKIN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Pausa no Faturamento On Line.'											, ; //X6_DESCRIC
	'Pausa no Faturamento On Line.'											, ; //X6_DSCSPA
	'Pausa no Faturamento On Line.'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'22:00'																	, ; //X6_CONTEUD
	'22:00'																	, ; //X6_CONTSPA
	'22:00'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_GARLOG'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se gera LOG na pasta proclog da integr GAR.'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'0=desliga;1-liga'														, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	'N'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_GARTXTD'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'numero de dias anteriores que a rotina deve'							, ; //X6_DESCRIC
	'numero de dias anteriores que a rotina deve'							, ; //X6_DSCSPA
	'numero de dias anteriores que a rotina deve'							, ; //X6_DSCENG
	'considerar para geracao do arquivo, este'								, ; //X6_DESC1
	'considerar para geracao do arquivo, este'								, ; //X6_DSCSPA1
	'considerar para geracao do arquivo, este'								, ; //X6_DSCENG1
	'par usado para gerar info. do passado'									, ; //X6_DESC2
	'par usado para gerar info. do passado'									, ; //X6_DSCSPA2
	'par usado para gerar info. do passado'									, ; //X6_DSCENG2
	'6'																		, ; //X6_CONTEUD
	'6'																		, ; //X6_CONTSPA
	'6'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_GARTXTH'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica o horario diario de execucao da Rotina de'						, ; //X6_DESCRIC
	'Indica o horario diario de execucao da Rotina de'						, ; //X6_DSCSPA
	'Indica o horario diario de execucao da Rotina de'						, ; //X6_DSCENG
	'JOB.'																	, ; //X6_DESC1
	'JOB.'																	, ; //X6_DSCSPA1
	'JOB.'																	, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'00:01'																	, ; //X6_CONTEUD
	'00:01'																	, ; //X6_CONTSPA
	'00:01'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ICMS'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define a natureza a ser utilizada na gera็ใo'							, ; //X6_DESCRIC
	'Define modalidad que se utilizara en generacion'						, ; //X6_DSCSPA
	'It defines the class to be used during automatic'						, ; //X6_DSCENG
	'automแtica do tํtulo com o valor do ICMS apurado'						, ; //X6_DESC1
	'automแtica del titulo con valor del ICMS calculado'					, ; //X6_DSCSPA1
	'generation of bill with ICMS amount calculated'						, ; //X6_DSCENG1
	'no perํodo pela rotina de apura็ใo - MATA953.'							, ; //X6_DESC2
	'en el periodo por la rutina de calculo - MATA953.'						, ; //X6_DSCSPA2
	'in the period by the calculation routine -MATA953.'					, ; //X6_DSCENG2
	'SF410032'																, ; //X6_CONTEUD
	'SF410032'																, ; //X6_CONTSPA
	'SF410032'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_IMPPROP'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Rotina referente a impressao de propostas'								, ; //X6_DESCRIC
	'Rotina referente a impressao de propostas'								, ; //X6_DSCSPA
	'Rotina referente a impressao de propostas'								, ; //X6_DSCENG
	'Rotina referente a impressao de propostas'								, ; //X6_DESC1
	'Rotina referente a impressao de propostas'								, ; //X6_DSCSPA1
	'Rotina referente a impressao de propostas'								, ; //X6_DSCENG1
	'Rotina referente a impressao de propostas'								, ; //X6_DESC2
	'Rotina referente a impressao de propostas'								, ; //X6_DSCSPA2
	'Rotina referente a impressao de propostas'								, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_INCECUL'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar se o contribuinte ้ optante do incentivo'						, ; //X6_DESCRIC
	'Informar si el contribuy. es optante del incentivo'					, ; //X6_DSCSPA
	'Inform if taxpayer chose incentive to'									, ; //X6_DSCENG
	'a cultura para que seja gerada a TAG'									, ; //X6_DESC1
	'a la cultura para que se genere la TAG'								, ; //X6_DSCSPA1
	'culture in order to generate the TAG'									, ; //X6_DSCENG1
	'<IncentivadorCultural>.'												, ; //X6_DESC2
	'<IncentivadorCultural>.'												, ; //X6_DSCSPA2
	'<CulturalIncentive>'													, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LIMDMAT'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Limite de dedu็ใo para a licen็a-maternidade.'							, ; //X6_DESCRIC
	'Limite de deduccion para licencia por maternidad.'						, ; //X6_DSCSPA
	'Deduction threshold for maternity leave.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'24500.00'																, ; //X6_CONTEUD
	'24500.00'																, ; //X6_CONTSPA
	'24500.00'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LJLVFIS'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define se utiliza novo conceito para geracao SF3'						, ; //X6_DESCRIC
	'Define si utiliza nuevo concepto para generac. SF3'					, ; //X6_DSCSPA
	'Defines if new concept for SF3 generation is used'						, ; //X6_DSCENG
	'1= conceito antigo, 2= conceito novo'									, ; //X6_DESC1
	'1= concepto antiguo, 2= concepto nuevo'								, ; //X6_DSCSPA1
	'1= old concept, 2= new concept'										, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MATHARD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'MR'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MDTGPE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Integracao do SIGAMDT com o SIGAGPE'									, ; //X6_DESCRIC
	'Integracion del SIGAMDT con el SIGAGPE'								, ; //X6_DSCSPA
	'Integration of SIGAMDT with SIGAGPE'									, ; //X6_DSCENG
	'Informar S=Sim ou N=Nao'												, ; //X6_DESC1
	'Informar S=Si o N=No'													, ; //X6_DSCSPA1
	'Enter S=Yes or N=No'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MUDATRT'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica se devera alterar o nome fํsico das tabelas'					, ; //X6_DESCRIC
	'Indica si se modifica el nombre fisico de tablas'						, ; //X6_DSCSPA
	'It indicates if physical name of temporary tables'						, ; //X6_DSCENG
	'temporarias utilizadas nas SPs T=Alterar F=Nใo'						, ; //X6_DESC1
	'temporarias utilizadas en las SP T=Modifica F=No'						, ; //X6_DSCSPA1
	'used in SPs must be changed.  T=Change F=Do Not'						, ; //X6_DSCENG1
	'Alterar'																, ; //X6_DESC2
	'Modificar'																, ; //X6_DSCSPA2
	'Change'																, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MULNATS'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita a gera็ใo dos rateios financeiros para'						, ; //X6_DESCRIC
	'Habilita generacion de prorrateos financieros para'					, ; //X6_DSCSPA
	'Enables generation of financial apportionment for'						, ; //X6_DSCENG
	'integra็ใo com NFE mesmo com natureza simples mas'						, ; //X6_DESC1
	'integracion con FactE aun c modalidad simple pero'						, ; //X6_DSCSPA1
	'integration with NFE even with simple class but'						, ; //X6_DSCENG1
	'com rateios de CC por itens no doc. de entrada.'						, ; //X6_DESC2
	'con prorrateos de CC por items en doc. de entrada'						, ; //X6_DSCSPA2
	'with CC apportionment per itens in inflow document'					, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NESPEC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica o tipo de documento fiscal utilizado na'						, ; //X6_DESCRIC
	'Indica el tipo de documento fiscal utilizado para'						, ; //X6_DSCSPA
	'Indicates the type of fiscal document used when'						, ; //X6_DSCENG
	'emissao de notas fiscais simplificadas de servico'						, ; //X6_DESC1
	'emitir facturas simplificadas de servicio al gene-'					, ; //X6_DSCSPA1
	'generating simplified service invoices'								, ; //X6_DSCENG1
	'na geracao da Dief-RJ.'												, ; //X6_DESC2
	'rar la DIEF-RJ.'														, ; //X6_DSCSPA2
	'in the generation of DIEF-RJ.'											, ; //X6_DSCENG2
	'NF'																	, ; //X6_CONTEUD
	'NF'																	, ; //X6_CONTSPA
	'NF'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NUMLIN'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Limita o numero de linhas do documento no lancamen'					, ; //X6_DESCRIC
	'Limita el numero de lineas del documento en el'						, ; //X6_DSCSPA
	'It limits the number of rows in the document'							, ; //X6_DSCENG
	'to contabil de integracao (automatico).'								, ; //X6_DESC1
	'asiento contable de integracion (automatico).'							, ; //X6_DSCSPA1
	'during the accounting integration entry (automatic'					, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'9999'																	, ; //X6_CONTEUD
	'9999'																	, ; //X6_CONTSPA
	'9999'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_OPTSIMP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar se o contribuinte ้ optante do Simples'						, ; //X6_DESCRIC
	'Informar si el contribuy. es optante del Simples'						, ; //X6_DSCSPA
	'Inform if taxpayer chose for Simples Nacional'							, ; //X6_DSCENG
	'nacional para que seja gerada a TAG'									, ; //X6_DESC1
	'nacional para que se genere la TAG'									, ; //X6_DSCSPA1
	'in order to generate the TAG'											, ; //X6_DSCENG1
	'<OptanteSimplesNacional>.'												, ; //X6_DESC2
	'<OptanteSimplesNacional>.'												, ; //X6_DSCSPA2
	'<ChoseSimplesNacional>'												, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PERCFGC'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Parametro para configurar contribuicao do FGTS'						, ; //X6_DESCRIC
	'Parametro para configurar contribucion de FGTS'						, ; //X6_DSCSPA
	'Parameter to configure FGTS contribution'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0.5'																	, ; //X6_CONTEUD
	'0.5'																	, ; //X6_CONTSPA
	'0.5'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PROCSP'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica se a manutencao de Store Procedures sera'						, ; //X6_DESCRIC
	'Indica se a manutencao de Store Procedures sera'						, ; //X6_DSCSPA
	'Indica se a manutencao de Store Procedures sera'						, ; //X6_DSCENG
	'realizadas por processor. (T = Sim ou F = a Nao)'						, ; //X6_DESC1
	'realizadas por processor. (T = Sim ou F = a Nao)'						, ; //X6_DSCSPA1
	'realizadas por processor. (T = Sim ou F = a Nao)'						, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PVCONTR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Gera pedido de venda por atraves do modulo de'							, ; //X6_DESCRIC
	'Gera pedido de venda por atraves do modulo de'							, ; //X6_DSCSPA
	'Gera pedido de venda por atraves do modulo de'							, ; //X6_DSCENG
	'gestao de contratos? (S/N)'											, ; //X6_DESC1
	'gestao de contratos? (S/N)'											, ; //X6_DSCSPA1
	'gestao de contratos? (S/N)'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'S'																		, ; //X6_CONTSPA
	'S'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_REGIESP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar o Regime especial de tributa็ใo para'							, ; //X6_DESCRIC
	'Informar el regimen especial de tributacion para'						, ; //X6_DSCSPA
	'Enter taxation special system to'										, ; //X6_DSCENG
	'que seja gerada a TAG <RegimeEspecialTributacao>.'						, ; //X6_DESC1
	'que se genere la TAG <RegimenEspecialTributacion>.'					, ; //X6_DSCSPA1
	'generate the TAG<TaxationSpecialSystem>'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_REMMES'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ano e mes de competencia para calculo de'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'remuneracao de parceiros - CRPA020.prw'								, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'201305'																, ; //X6_CONTEUD
	'201305'																, ; //X6_CONTSPA
	'201305'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RESP1'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Responsavel pelas geracao de propostas comerciais'						, ; //X6_DESCRIC
	'Responsavel pelas geracao de propostas comerciais'						, ; //X6_DSCSPA
	'Responsavel pelas geracao de propostas comerciais'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CertiSign'																, ; //X6_CONTEUD
	'CertiSign'																, ; //X6_CONTSPA
	'CertiSign'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RNDRNE'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Padrao de arredondamento para o ISS:'									, ; //X6_DESCRIC
	'Estandar de redondeo para el ISS:'										, ; //X6_DSCSPA
	'Rounding standard for ISS:'											, ; //X6_DSCENG
	'F = normal, T = padrao utilizado pela'									, ; //X6_DESC1
	'F = normal, T = utilizado por la'										, ; //X6_DSCSPA1
	'F = normal, T = standard used by the'									, ; //X6_DSCENG1
	'Prefeitura de Sao Paulo.'												, ; //X6_DESC2
	'Alcaldia de Sao Paulo.'												, ; //X6_DSCSPA2
	'Municipality of Sao Paulo.'											, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SALFDED'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Verbas a deduzir p/o Salario Familia no SEFIP.'						, ; //X6_DESCRIC
	'Conceptos por deducir p/ la Asig. Fam. en SEFIP.'						, ; //X6_DSCSPA
	'Funds deducted for Family Allowance in SEFIP.'							, ; //X6_DSCENG
	'Informar a(s) verba(s) em seqüencia e sem espacos.'					, ; //X6_DESC1
	'Informar el(los) concepto(s) en sec. y sin esp.'						, ; //X6_DSCSPA1
	'Indicate funds sequentially and with no spaces.'						, ; //X6_DSCENG1
	'Exemplo: 400 ou 400450 ou 400450500.'									, ; //X6_DESC2
	'Ejemplo: 400 o 400450 o 400450500.'									, ; //X6_DSCSPA2
	'Example: 400 or 400450 or 400450500.'									, ; //X6_DSCENG2
	'129'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SALMDED'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Verbas a deduzir p/o Salario Maternidade no SEFIP.'					, ; //X6_DESCRIC
	'Concep. por deducir p/la Asig. por Mat. en SEFIP.'						, ; //X6_DSCSPA
	'Funds deducted for Maternity Allowance in SEFIP.'						, ; //X6_DSCENG
	'Informar a(s) verba(s) em seqüencia e sem espacos.'					, ; //X6_DESC1
	'Informar el(los) concep. en secuencia y sin esp.'						, ; //X6_DSCSPA1
	'Indicate funds sequentially and with no spaces.'						, ; //X6_DSCENG1
	'Exemplo: 400 ou 400450 ou 400450500.'									, ; //X6_DESC2
	'Ejemplo: 400 o 400450 o 400450500.'									, ; //X6_DSCSPA2
	'Example: 400 or 400450 or 400450500.'									, ; //X6_DSCENG2
	'131'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SPDCOMP'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Parโmetro de compressใo do arquivo'									, ; //X6_DESCRIC
	'Parametro de compresion del archivo'									, ; //X6_DSCSPA
	'File compression parameter'											, ; //X6_DSCENG
	'.T. = Sim / .F. = Nใo'													, ; //X6_DESC1
	'.T. = Si / .F. = No'													, ; //X6_DSCSPA1
	'T = Yes / F = No'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SPDFDIR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Diret๓rio do FTP'														, ; //X6_DESCRIC
	'Directorio del FTP'													, ; //X6_DSCSPA
	'FTP diretory'															, ; //X6_DSCENG
	'Ex: "\web\ftpdped"'													, ; //X6_DESC1
	'Ej: "\web\ftpdped"'													, ; //X6_DSCSPA1
	'Ex: "\web\ftpdped"'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'"D:\totvs\Protheus_Data10\web\ftpsped"'								, ; //X6_CONTEUD
	'"D:\totvs\Protheus_Data10\web\ftpsped"'								, ; //X6_CONTSPA
	'"D:\totvs\Protheus_Data10\web\ftpsped"'								, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SPEDDOW'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Parโmetro de verifica็ใo de download via client'						, ; //X6_DESCRIC
	'Parametro de verificacion de download por client'						, ; //X6_DSCSPA
	'Download per customer checking parameter'								, ; //X6_DSCENG
	'.T. = Sim / .F. = Nใo'													, ; //X6_DESC1
	'.T. = Si / .F. = No'													, ; //X6_DSCSPA1
	'T = Yes / F = No'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SPEDEXC'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Informar a quantidade de horas, conforme'								, ; //X6_DESCRIC
	'Informar la cantidad de horas, segun'									, ; //X6_DSCSPA
	'Enter number of hours, according to SEFAZ of'							, ; //X6_DSCENG
	'a SEFAZ de cada estado determina, para'								, ; //X6_DESC1
	'el SEFAZ que cada estado determina, para'								, ; //X6_DSCSPA1
	'each state determines, to'												, ; //X6_DSCENG1
	'possibilitar o cancelamento da NFe.'									, ; //X6_DESC2
	'permitir la anulacion de la eFact.'									, ; //X6_DSCSPA2
	'enable cancellation of NFe.'											, ; //X6_DSCENG2
	'24'																	, ; //X6_CONTEUD
	'24'																	, ; //X6_CONTSPA
	'24'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'7'																		, ; //X6_CONTEUD
	'7'																		, ; //X6_CONTSPA
	'7'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SPTCATE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Na importacao de SUSPECT, define quais registros'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'serao convertidos em PROSPECT'											, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'categoria 1=Adm.Vendas,2=TeleVendas,3=SAC'								, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SPTUNIC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Valida Suspect Duplicado?  TMKGRVAC.PRW'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'.T. PARA VALIDAR'														, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'.F. PARA NAO VALIDAR'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TIPCONT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define quais sao os tipos de processos do Gar que'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'serao considerados na contagem de certificados'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'verificados para compor saldo mensal - CRPA050.prw'					, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CAMPCO;VALIDA'															, ; //X6_CONTEUD
	'CAMPCO;VALIDA'															, ; //X6_CONTSPA
	'CAMPCO;VALIDA'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TIPGAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipos de processos Gar - CRPA020.prw'									, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'VALIDA;HWAVUL;ENTMID;CAMPCO;CLUBRE;VERIFI'								, ; //X6_CONTEUD
	'VALIDA;HWAVUL;ENTMID;CAMPCO;CLUBRE;VERIFI'								, ; //X6_CONTSPA
	'VALIDA;HWAVUL;ENTMID;CAMPCO;CLUBRE;VERIFI'								, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TKMAXKB'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Tamanho maximo do anexo enviado nos emails do'							, ; //X6_DESCRIC
	'Tamano maximo del anexo enviado en los emails de'						, ; //X6_DSCSPA
	'Maximum size of the annex sent in e-mails of'							, ; //X6_DSCENG
	'teleatendiento (Service-Desk) em Kilobytes.'							, ; //X6_DESC1
	'teleatencion (Service-Desk) en Kilobytes.'								, ; //X6_DSCSPA1
	'Service-Desk in Kilobytes.'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3000'																	, ; //X6_CONTEUD
	'3000'																	, ; //X6_CONTSPA
	'3000'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TMKSEAN'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Determina o nํvel de acesso do usuแrio a mแquina'						, ; //X6_DESCRIC
	'Determina el nivel de acc. del usuario a la maq.'						, ; //X6_DSCSPA
	'It determines user access level to server'								, ; //X6_DSCENG
	'servidora e mแquina cliente no momento da sele็ใo'						, ; //X6_DESC1
	'serv. y maq. cliente en el momento de la selecc.'						, ; //X6_DSCSPA1
	'machine and client machine upon selection of'							, ; //X6_DSCENG1
	'de anexo de envio do workflow do teleatendimento.'						, ; //X6_DESC2
	'de anexo de envio del workflow de la teleatencion.'					, ; //X6_DSCSPA2
	'sending attachment of  Call Center workflow.'							, ; //X6_DSCENG2
	'3'																		, ; //X6_CONTEUD
	'3'																		, ; //X6_CONTSPA
	'3'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TMKVCGC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Validar o CNPJ entre as entidades Clientes (SA1),'						, ; //X6_DESCRIC
	'Validar el RFC entre las entidades Clientes (SA1),'					, ; //X6_DSCSPA
	'Validate CNPJ among Customers companies (SA1).'						, ; //X6_DSCENG
	'Prospects (SUS) e Suspects (ACH).'										, ; //X6_DESC1
	'Prospects (SUS) y Suspects (ACH).'										, ; //X6_DSCSPA1
	'Prospectus (Sus) and Suspectus (ACH).'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TRFPMSP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parametro para enviar para as NF de servico para a'					, ; //X6_DESCRIC
	'Parametro para enviar para as NF de servico para a'					, ; //X6_DSCSPA
	'Parametro para enviar para as NF de servico para a'					, ; //X6_DSCENG
	'Prefeitura de Sao Paulo.'												, ; //X6_DESC1
	'Prefeitura de Sao Paulo.'												, ; //X6_DSCSPA1
	'Prefeitura de Sao Paulo.'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TRNDISS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Determina se o arredondamento do ISS devera ser'						, ; //X6_DESCRIC
	'Determina se o arredondamento do ISS devera ser'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'efetuado por documento ou  por item, em que:'							, ; //X6_DESC1
	'efetuado por documento ou  por item, em que:'							, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'1 = por documento; 2 = por item.'										, ; //X6_DESC2
	'1 = por documento; 2 = por item.'										, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_UDASSUN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo padrao para o assunto no Telemarketing.'						, ; //X6_DESCRIC
	'Codigo padrao para o assunto no Telemarketing.'						, ; //X6_DSCSPA
	'Codigo padrao para o assunto no Telemarketing.'						, ; //X6_DSCENG
	'Parametro utilizado na rotina CSFA010.prw'								, ; //X6_DESC1
	'Parametro utilizado na rotina CSFA010.prw'								, ; //X6_DSCSPA1
	'Parametro utilizado na rotina CSFA010.prw'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'ATR001'																, ; //X6_CONTEUD
	'ATR001'																, ; //X6_CONTSPA
	'ATR001'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_USERIMP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Usuarios com permissao para impressao de propostas'					, ; //X6_DESCRIC
	'Usuarios com permissao para impressao de propostas'					, ; //X6_DSCSPA
	'Usuarios com permissao para impressao de propostas'					, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000001/000445'															, ; //X6_CONTEUD
	'000001/000445'															, ; //X6_CONTSPA
	'000001/000445'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_USERMOT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parametro criado para Controle de acesso aos'							, ; //X6_DESCRIC
	'Parametro criado para Controle de acesso aos'							, ; //X6_DSCSPA
	'Parametro criado para Controle de acesso aos'							, ; //X6_DSCENG
	'usuarios com permissao de uso do motivo de baixa'						, ; //X6_DESC1
	'usuarios com permissao de uso do motivo de baixa'						, ; //X6_DSCSPA1
	'usuarios com permissao de uso do motivo de baixa'						, ; //X6_DSCENG1
	'DACAO e CANCTO (FA070TIT.PRW)'											, ; //X6_DESC2
	'DACAO e CANCTO (FA070TIT.PRW)'											, ; //X6_DSCSPA2
	'DACAO e CANCTO (FA070TIT.PRW)'											, ; //X6_DSCENG2
	'cfreitas,cfreitas2,cfreitas3,jmollo'									, ; //X6_CONTEUD
	'cfreitas,cfreitas2,cfreitas3,jmollo'									, ; //X6_CONTSPA
	'cfreitas,cfreitas2,cfreitas3,jmollo'									, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VISAALI'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Numero do Contrato do Vale Alimentacao'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'860904'																, ; //X6_CONTEUD
	'860904'																, ; //X6_CONTSPA
	'860904'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VISACNP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Layout Visa Vale'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VISAREF'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Numero de Contrato do Vale Refeicao'									, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'860804'																, ; //X6_CONTEUD
	'860804'																, ; //X6_CONTSPA
	'860804'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XCBOAT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ativa Combo. 1=Sim; 2=Nao'												, ; //X6_DESCRIC
	'Ativa Combo. 1=Sim; 2=Nao'												, ; //X6_DSCSPA
	'Ativa Combo. 1=Sim; 2=Nao'												, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XCPENTR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo de condicao de pagamento que sera'								, ; //X6_DESCRIC
	'Codigo de condicao de pagamento que sera'								, ; //X6_DSCSPA
	'Codigo de condicao de pagamento que sera'								, ; //X6_DSCENG
	'utilizada para geracao de pedidos de vendas'							, ; //X6_DESC1
	'utilizada para geracao de pedidos de vendas'							, ; //X6_DSCSPA1
	'utilizada para geracao de pedidos de vendas'							, ; //X6_DSCENG1
	'com a opcao de entrega a domicilio.'									, ; //X6_DESC2
	'com a opcao de entrega a domicilio.'									, ; //X6_DSCSPA2
	'com a opcao de entrega a domicilio.'									, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XCPSITE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe a condicao de pagamento padrao utilizada'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'no site hardware avulso.'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0=000,1=030,2=2X ,3=3XA,4=4XA,5=5XA,6=6XA'								, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XDIAPRC'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'365'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XDISSDK'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Metodo de baixa de emails'												, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'deleted'																, ; //X6_CONTEUD
	'deleted'																, ; //X6_CONTSPA
	'deleted'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XENVMAI'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'HABILITA/DESABILITA ENVIO DE EMAIL NO APONTAMENTO'						, ; //X6_DESCRIC
	'HABILITA/DESABILITA ENVIO DE EMAIL NO APONTAMENTO'						, ; //X6_DSCSPA
	'HABILITA/DESABILITA ENVIO DE EMAIL NO APONTAMENTO'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XESPECI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Devera ser informada a especie da Notal Fiscal de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada, referente a devolucao.'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SPED'																	, ; //X6_CONTEUD
	'SPED'																	, ; //X6_CONTSPA
	'SPED'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XGARERP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'WebService integracao GAR para atualizacao dos'						, ; //X6_DESCRIC
	'WebService integracao GAR para atualizacao dos'						, ; //X6_DSCSPA
	'WebService integracao GAR para atualizacao dos'						, ; //X6_DSCENG
	'postos.'																, ; //X6_DESC1
	'postos.'																, ; //X6_DSCSPA1
	'postos.'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP'	, ; //X6_CONTEUD
	'https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP'	, ; //X6_CONTSPA
	'https://gestaoar.certisign.com.br/WSIntegracaoERP/IntegracaoGARERP'	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XNATAME'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza utilizada em vendas com cartao de credito'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'bandeira American Express'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'FT010012'																, ; //X6_CONTEUD
	'FT010012'																, ; //X6_CONTSPA
	'FT010012'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XNATRED'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza utilizada em vendas com cartao de credito'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'bandeira mastercard'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'FT010014'																, ; //X6_CONTEUD
	'FT010014'																, ; //X6_CONTSPA
	'FT010014'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XNATVIS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza utilizada em vendas com cartao de credito'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'bandeira visa'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'FT010013'																, ; //X6_CONTEUD
	'FT010013'																, ; //X6_CONTSPA
	'FT010013'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XNOTVV'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco de email que sera notificado caso seja'						, ; //X6_DESCRIC
	'Endereco de email que sera notificado caso seja'						, ; //X6_DSCSPA
	'Endereco de email que sera notificado caso seja'						, ; //X6_DSCENG
	'encontrada inconsistencia no processamento do'							, ; //X6_DESC1
	'encontrada inconsistencia no processamento do'							, ; //X6_DSCSPA1
	'encontrada inconsistencia no processamento do'							, ; //X6_DSCENG1
	'pedido originados do portal de vendas.'								, ; //X6_DESC2
	'pedido originados do portal de vendas.'								, ; //X6_DSCSPA2
	'pedido originados do portal de vendas.'								, ; //X6_DSCENG2
	'sistemascorporativos@certisign.com.br'									, ; //X6_CONTEUD
	'sistemascorporativos@certisign.com.br'									, ; //X6_CONTSPA
	'sistemascorporativos@certisign.com.br'									, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XPOSGRU'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identifica o codigo do grupo referente aos Postos'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de Entrega.'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XSECWAI'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Numero de Segundos de espera antes de distribuir'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'nova thread para faturamento de registro de cnab'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XSERGAR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'SERIE PARA EMISSAO NF PODER TERCEIRO GAR'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTABPRC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe a o codigo da tabela de preco generica que'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'sera utilizada via web service.'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'002,010,011,012,013,014,015,016,017,018,019,020,021,022'				, ; //X6_CONTEUD
	'002'																	, ; //X6_CONTSPA
	'002'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTABSIT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tabelas que estao disponiveis no site de Vendas'						, ; //X6_DESCRIC
	'Tabelas que estao disponiveis no site de Vendas'						, ; //X6_DSCSPA
	'Tabelas que estao disponiveis no site de Vendas'						, ; //X6_DSCENG
	'Varejo.'																, ; //X6_DESC1
	'Varejo.'																, ; //X6_DSCSPA1
	'Varejo.'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'002'																	, ; //X6_CONTEUD
	'002'																	, ; //X6_CONTSPA
	'002'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTABVV'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da tabela de preco padrao que sera'								, ; //X6_DESCRIC
	'Codigo da tabela de preco padrao que sera'								, ; //X6_DSCSPA
	'Codigo da tabela de preco padrao que sera'								, ; //X6_DSCENG
	'considerada pelo carrinho de compras.'									, ; //X6_DESC1
	'considerada pelo carrinho de compras.'									, ; //X6_DSCSPA1
	'considerada pelo carrinho de compras.'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'002'																	, ; //X6_CONTEUD
	'002'																	, ; //X6_CONTSPA
	'002'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTESDEG'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES para devolucao dos produtos poder terceiro do'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'GAR'																	, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'008'																	, ; //X6_CONTEUD
	'008'																	, ; //X6_CONTSPA
	'008'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTESDEV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES utilizdo para devolucao de Poder de Terceiros.'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'008'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTESREG'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES para remessa poder terceiro para o GAR'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'611'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTESREM'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES utilizado para busca das notas emitidas para'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Poder de Terceiros (remessa).'											, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTESSAI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES utilizado para o faturamento final via web'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'service.'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTESWEB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar o TES padrao de venda pelo webservice,'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'pois o mesmo sera utilizado na inclusao de pedidos'					, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'via webservice.'														, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'501'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTPCSUB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de produtos que entram no tratamento da ST'						, ; //X6_DESCRIC
	'Tipo de produtos que entram no tratamento da ST'						, ; //X6_DSCSPA
	'Tipo de produtos que entram no tratamento da ST'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'MR'																	, ; //X6_CONTEUD
	'MR'																	, ; //X6_CONTSPA
	'MR'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XTPDEVO'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Devera ser informado o tipo de documento de entrad'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'a referente a devolucao de poder de terceiros.'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XUFCSUB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'UF de cliente que entram no tratamento da ST'							, ; //X6_DESCRIC
	'UF de cliente que entram no tratamento da ST'							, ; //X6_DSCSPA
	'UF de cliente que entram no tratamento da ST'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SP'																	, ; //X6_CONTEUD
	'SP'																	, ; //X6_CONTSPA
	'SP'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XVENSIT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe qual o vendedor padrao do site hardware av'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'ulso.'																	, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'VA0001'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XWSHUB'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco do webservice de intregracao com o hub'						, ; //X6_DESCRIC
	'Endereco do webservice de intregracao com o hub'						, ; //X6_DSCSPA
	'Endereco do webservice de intregracao com o hub'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://10.100.0.59:8080/VVHub/VVHubService'							, ; //X6_CONTEUD
	'http://200.219.128.28:8080/VVHub/VVHubService'							, ; //X6_CONTSPA
	'http://200.219.128.28:8080/VVHub/VVHubService'							, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XWSVEVA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco de webservice com o carrinho de compras.'						, ; //X6_DESCRIC
	'Endereco de webservice com o carrinho de compras.'						, ; //X6_DSCSPA
	'Endereco de webservice com o carrinho de compras.'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://checkout-teste.certisign.com.br/VendasWS/services/HAWSProviderService', ; //X6_CONTEUD
	'http://200.219.128.28:8080/VendasWS/services/HAWSProviderService'		, ; //X6_CONTSPA
	'http://200.219.128.28:8080/VendasWS/services/HAWSProviderService'		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XWSVVPR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco do WebService de integracao com o vendas'						, ; //X6_DESCRIC
	'Endereco do WebService de integracao com o vendas'						, ; //X6_DSCSPA
	'Endereco do WebService de integracao com o vendas'						, ; //X6_DSCENG
	'varejo Protheus.'														, ; //X6_DESC1
	'varejo Protheus.'														, ; //X6_DSCSPA1
	'varejo Protheus.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://192.168.16.10:1803/ws/HARDWAREAVULSOPROVIDER.apw'				, ; //X6_CONTEUD
	'http://192.168.16.131:90/ws/HARDWAREAVULSOPROVIDER.APW'				, ; //X6_CONTSPA
	'http://192.168.16.131:90/ws/HARDWAREAVULSOPROVIDER.APW'				, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SDK_CODCTT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Contato do cliente de abertura do chamado para o S'					, ; //X6_DESCRIC
	'Contato do cliente de abertura do chamado para o S'					, ; //X6_DSCSPA
	'Contato do cliente de abertura do chamado para o S'					, ; //X6_DSCENG
	'ervice Desk.'															, ; //X6_DESC1
	'ervice Desk.'															, ; //X6_DSCSPA1
	'ervice Desk.'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'013067'																, ; //X6_CONTEUD
	'013067'																, ; //X6_CONTSPA
	'013067'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SDK_CODENT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Cliente para abertura de chamado via email para o'						, ; //X6_DESCRIC
	'Cliente para abertura de chamado via email para o'						, ; //X6_DSCSPA
	'Cliente para abertura de chamado via email para o'						, ; //X6_DSCENG
	'service Desk.'															, ; //X6_DESC1
	'service Desk.'															, ; //X6_DSCSPA1
	'service Desk.'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'99AKJ701'																, ; //X6_CONTEUD
	'99AKJ701'																, ; //X6_CONTSPA
	'99AKJ701'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SDK_OCORRE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'CODIGO DA CORRENCIA - IMPORTACAO DE MAINLING'							, ; //X6_DESCRIC
	'CODIGO DA CORRENCIA - IMPORTACAO DE MAINLING'							, ; //X6_DSCSPA
	'CODIGO DA CORRENCIA - IMPORTACAO DE MAINLING'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'003153'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SDK_SENOPE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Senha do operador de recepcao do email.'								, ; //X6_DESCRIC
	'Senha do operador de recepcao do email.'								, ; //X6_DSCSPA
	'Senha do operador de recepcao do email.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'123456'																, ; //X6_CONTEUD
	'123456'																, ; //X6_CONTSPA
	'123456'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'TLV_COPMAI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Emailดs que receberao copia da confirmacao de'							, ; //X6_DESCRIC
	'Emailดs que receberao copia da confirmacao de'							, ; //X6_DSCSPA
	'Emailดs que receberao copia da confirmacao de'							, ; //X6_DSCENG
	'Liberacao de Pedidos incluidos atraves das rotinas'					, ; //X6_DESC1
	'Liberacao de Pedidos incluidos atraves das rotinas'					, ; //X6_DSCSPA1
	'Liberacao de Pedidos incluidos atraves das rotinas'					, ; //X6_DSCENG1
	'de Televendas.'														, ; //X6_DESC2
	'de Televendas.'														, ; //X6_DSCSPA2
	'de Televendas.'														, ; //X6_DSCENG2
	'rpierro@certisign.com.br,garaujo@certisign.com.br,bsouza@certisign.com.br,asilva@certisign.com.br,cristiano.sacramento@certisign.com.br,carolina.goncalves@certisign.com.br,veronica.cristina@certisign.com.br', ; //X6_CONTEUD
	'rpierro@certisign.com.br,garaujo@certisign.com.br,fmartins@certisign.com.br,bsouza@certisign.com.br,asilva@certisign.com.br,carolina.goncalves@certisign.com.br,veronica.cristina@certisign.com.br', ; //X6_CONTSPA
	'rpierro@certisign.com.br,garaujo@certisign.com.br,fmartins@certisign.com.br,bsouza@certisign.com.br,asilva@certisign.com.br,carolina.goncalves@certisign.com.br,veronica.cristina@certisign.com.br', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'01'																	, ; //X6_FIL
	'MV_CCPFIL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DESCRIC
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCSPA
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCENG
	'o EDI de Pedidos.'														, ; //X6_DESC1
	'o EDI de Pedidos.'														, ; //X6_DSCSPA1
	'o EDI de Pedidos.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'01'																	, ; //X6_FIL
	'MV_CODREG'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do regime tributario do emitente da Nf-e'						, ; //X6_DESCRIC
	'Codigo del reg. tributario del emitente de e-Fact'						, ; //X6_DSCSPA
	'Tax system code of NF-e issuer'										, ; //X6_DSCENG
	'1-Simples Nacional; 2-Simples Nacional- Excesso de'					, ; //X6_DESC1
	'1-Simples Nacional; 2-Simples Nacional- Exceso de'						, ; //X6_DSCSPA1
	'1-Simples Nacional; 2-Simples Nacional- Excess of'						, ; //X6_DSCENG1
	'sub-limite de receita bruta; 3- Regime Nacional'						, ; //X6_DESC2
	'sublimite de ingreso bruto; 3- Regimen Nacional'						, ; //X6_DSCSPA2
	'gross income sublimit; 3- National System'								, ; //X6_DSCENG2
	'3'																		, ; //X6_CONTEUD
	'3'																		, ; //X6_CONTSPA
	'3'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'01'																	, ; //X6_FIL
	'MV_ICMVENC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar a quantidade de dias uteis para pgto.ICMS'					, ; //X6_DESCRIC
	'Informar cantidad de dias habiles para pago de'						, ; //X6_DSCSPA
	'Inform the number of working days for payment of'						, ; //X6_DSCENG
	'e periodo de apuracao, a ser utilizado no calculo'						, ; //X6_DESC1
	'ICMS y periodo de computo usado en el calculo'							, ; //X6_DSCSPA1
	'value added tax and the period of calculation.'						, ; //X6_DSCENG1
	'do custo de entrada nas moedas 2, 3, 4 e 5.'							, ; //X6_DESC2
	'de costo de entrada en las monedas 2, 3, 4 y 5.'						, ; //X6_DSCSPA2
	'used in calculation of entry cost in curr.2,3,4,5.'					, ; //X6_DSCENG2
	'05,1'																	, ; //X6_CONTEUD
	'05,1'																	, ; //X6_CONTSPA
	'05,1'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'01'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'168'																	, ; //X6_CONTSPA
	'168'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'02'																	, ; //X6_FIL
	'MV_CCPFIL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'o EDI de Pedidos.'														, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'02'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'168'																	, ; //X6_CONTEUD
	'168'																	, ; //X6_CONTSPA
	'168'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'02'																	, ; //X6_FIL
	'MV_SPEDURL'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://192.168.16.131:8080/ws'											, ; //X6_CONTEUD
	'http://192.168.16.131:8080/ws'											, ; //X6_CONTSPA
	'http://192.168.16.131:8080/ws'											, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'02'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data da ultimo calculo da depreciacao de ativos'						, ; //X6_DESCRIC
	'Fecha del ultimo calculo de la depreciacion de'						, ; //X6_DSCSPA
	'Fixed assets depreciation last calculation'							, ; //X6_DSCENG
	'imobilizados.'															, ; //X6_DESC1
	'activos fijos.'														, ; //X6_DSCSPA1
	'date.'																	, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20130228'																, ; //X6_CONTEUD
	'20130228'																, ; //X6_CONTSPA
	'20130228'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'03'																	, ; //X6_FIL
	'MV_CCPFIL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DESCRIC
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCSPA
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCENG
	'o EDI de Pedidos.'														, ; //X6_DESC1
	'o EDI de Pedidos.'														, ; //X6_DSCSPA1
	'o EDI de Pedidos.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'03'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'7'																		, ; //X6_CONTEUD
	'7'																		, ; //X6_CONTSPA
	'7'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'04'																	, ; //X6_FIL
	'MV_CCPFIL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DESCRIC
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCSPA
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCENG
	'o EDI de Pedidos.'														, ; //X6_DESC1
	'o EDI de Pedidos.'														, ; //X6_DSCSPA1
	'o EDI de Pedidos.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'04'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'7'																		, ; //X6_CONTEUD
	'7'																		, ; //X6_CONTSPA
	'7'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'05'																	, ; //X6_FIL
	'MV_CCPFIL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DESCRIC
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCSPA
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCENG
	'o EDI de Pedidos.'														, ; //X6_DESC1
	'o EDI de Pedidos.'														, ; //X6_DSCSPA1
	'o EDI de Pedidos.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'05'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'7'																		, ; //X6_CONTEUD
	'7'																		, ; //X6_CONTSPA
	'7'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'06'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'7'																		, ; //X6_CONTEUD
	'7'																		, ; //X6_CONTSPA
	'7'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'07'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'7'																		, ; //X6_CONTEUD
	'7'																		, ; //X6_CONTSPA
	'7'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'09'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'RS'																	, ; //X6_CONTEUD
	'RS'																	, ; //X6_CONTSPA
	'RS'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'10'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'SP'																	, ; //X6_CONTEUD
	'SP'																	, ; //X6_CONTSPA
	'SP'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'11'																	, ; //X6_FIL
	'MV_CCPFIL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DESCRIC
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCSPA
	'Determina se esta Filial tem permissao de executar'					, ; //X6_DSCENG
	'o EDI de Pedidos.'														, ; //X6_DESC1
	'o EDI de Pedidos.'														, ; //X6_DSCSPA1
	'o EDI de Pedidos.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'11'																	, ; //X6_FIL
	'MV_CODREG'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do regime tributario do emitente da Nf-e'						, ; //X6_DESCRIC
	'Codigo del reg. tributario del emitente de e-Fact'						, ; //X6_DSCSPA
	'Tax system code of NF-e issuer'										, ; //X6_DSCENG
	'1-Simples Nacional; 2-Simples Nacional- Excesso de'					, ; //X6_DESC1
	'1-Simples Nacional; 2-Simples Nacional- Exceso de'						, ; //X6_DSCSPA1
	'1-Simples Nacional; 2-Simples Nacional- Excess of'						, ; //X6_DSCENG1
	'sub-limite de receita bruta; 3- Regime Nacional'						, ; //X6_DESC2
	'sublimite de ingreso bruto; 3- Regimen Nacional'						, ; //X6_DSCSPA2
	'gross income sublimit; 3- National System'								, ; //X6_DSCENG2
	'3'																		, ; //X6_CONTEUD
	'3'																		, ; //X6_CONTSPA
	'3'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'11'																	, ; //X6_FIL
	'MV_ICMVENC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar a quantidade de dias uteis para pgto.ICMS'					, ; //X6_DESCRIC
	'Informar cantidad de dias habiles para pago de'						, ; //X6_DSCSPA
	'Inform the number of working days for payment of'						, ; //X6_DSCENG
	'e periodo de apuracao, a ser utilizado no calculo'						, ; //X6_DESC1
	'ICMS y periodo de computo usado en el calculo'							, ; //X6_DSCSPA1
	'value added tax and the period of calculation.'						, ; //X6_DSCENG1
	'do custo de entrada nas moedas 2, 3, 4 e 5.'							, ; //X6_DESC2
	'de costo de entrada en las monedas 2, 3, 4 y 5.'						, ; //X6_DSCSPA2
	'used in calculation of entry cost in curr.2,3,4,5.'					, ; //X6_DSCENG2
	'05,1'																	, ; //X6_CONTEUD
	'05,1'																	, ; //X6_CONTSPA
	'05,1'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'11'																	, ; //X6_FIL
	'MV_SPEDEXP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define o n๚mero de dias que o sistema irแ'								, ; //X6_DESCRIC
	'Define el numero de dias que el sistema'								, ; //X6_DSCSPA
	'It defines number of days the system will'								, ; //X6_DSCENG
	'esperar para excluir a NFe da base'									, ; //X6_DESC1
	'esperara para borrar la eFact de la base'								, ; //X6_DSCSPA1
	'consider to delete the NFe of the database.'							, ; //X6_DSCENG1
	'de dados. (Default: 0 - nใo apaga)'									, ; //X6_DESC2
	'de datos. (Estandart: 0 - no borra)'									, ; //X6_DSCSPA2
	'(Ddefault: 0 - do not delete)'											, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'168'																	, ; //X6_CONTSPA
	'168'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME

//
// Atualizando dicionแrio
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
		cTexto += "Foi incluํdo o parโmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conte๚do [" + AllTrim( aSX6[nI][13] ) + "]"+ CRLF
	Else
		lContinua := .T.
		lReclock  := .F.
		cTexto += "Foi alterado o parโmetro " + aSX6[nI][1] + aSX6[nI][2] + " de [" + ;
		AllTrim( SX6->X6_CONTEUD ) + "]" + " para [" + AllTrim( aSX6[nI][13] ) + "]" + CRLF
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

cTexto += CRLF + "Final da Atualizacao" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX7 บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX7 - Gatilhos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX7   - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
// Campo ZZ_PREST
//
aAdd( aSX7, { ;
	'ZZ_PREST'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'Posicione("SA2",1,xFilial("SA2") + M->ZZ_PREST,"A2_LOJA")'				, ; //X7_REGRA
	'ZZ_LOJA'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			cTexto += "Foi incluํdo o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] + CRLF
		EndIf

		RecLock( "SX7", .T. )
	Else

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			cTexto += "Foi alterado o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] + CRLF
		EndIf

		RecLock( "SX7", .F. )
	EndIf

	For nJ := 1 To Len( aSX7[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
		EndIf
	Next nJ

	dbCommit()
	MsUnLock()

	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSXB บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXB - Consultas Pad ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSXB   - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSXB( cTexto )
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SXB" + CRLF + CRLF

aEstrut := { "XB_ALIAS",  "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , ;
             "XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM" }
//
// Consulta SZZ
//
aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Ativos'																, ; //XB_DESCRI
	'Ativos'																, ; //XB_DESCSPA
	'Ativos'																, ; //XB_DESCENG
	'SZZ'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Filial+Codigo'															, ; //XB_DESCRI
	'Filial+Codigo'															, ; //XB_DESCSPA
	'Filial+Codigo'															, ; //XB_DESCENG
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Codigo'																, ; //XB_DESCENG
	'ZZ_CODIGO'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Nome'																	, ; //XB_DESCRI
	'Nome'																	, ; //XB_DESCSPA
	'Nome'																	, ; //XB_DESCENG
	'ZZ_NOME'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'ZZ_CODIGO'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'6'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	"If(ISINCALLSTACK('u_CSATV1IMP'),ZZ_TIPO==_cTipoAtv,.T.)"				} ) //XB_CONTEM

//
// Consulta U00XIS
//
aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Hardware'																, ; //XB_DESCRI
	'Hardware'																, ; //XB_DESCSPA
	'Hardware'																, ; //XB_DESCENG
	'U00'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cod Hardware+cod Har'													, ; //XB_DESCRI
	'Cod Hardware+cod Har'													, ; //XB_DESCSPA
	'Cod Hardware+cod Har'													, ; //XB_DESCENG
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'3'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cadastra Novo'															, ; //XB_DESCRI
	'Incluye Nuevo'															, ; //XB_DESCSPA
	'Add New'																, ; //XB_DESCENG
	'01'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cod Hardware'															, ; //XB_DESCRI
	'Cod Hardware'															, ; //XB_DESCSPA
	'Cod Hardware'															, ; //XB_DESCENG
	'U00_CODHRD'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Descr. Hard.'															, ; //XB_DESCRI
	'Descr. Hard.'															, ; //XB_DESCSPA
	'Descr. Hard.'															, ; //XB_DESCENG
	'U00_DESHRD'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Marca'																	, ; //XB_DESCRI
	'Marca'																	, ; //XB_DESCSPA
	'Marca'																	, ; //XB_DESCENG
	'U00_MARCA'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'04'																	, ; //XB_COLUNA
	'Setor'																	, ; //XB_DESCRI
	'Setor'																	, ; //XB_DESCSPA
	'Setor'																	, ; //XB_DESCENG
	'U00_SETOR'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'U00->U00_CODHRD'														} ) //XB_CONTEM

aAdd( aSXB, { ;
	'U00XIS'																, ; //XB_ALIAS
	'6'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	"&(U_SCFiltGTI('U00','U00_CODGRP'))"									} ) //XB_CONTEM
	
	//
// Consulta U00XIS
//
/*aAdd( aSXB, { ;
	'SM0'																, ; //XB_ALIAS
	'6'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Hardware'																, ; //XB_DESCRI
	'Hardware'																, ; //XB_DESCSPA
	'Hardware'																, ; //XB_DESCENG
	'Iif(IsInCallSteak("U_CSATVA01"),M0_CODFIL <> "06" .And. M0_CODFIL <> "07" .And. M0_CODFIL <> "08","")'	} ) //XB_CONTEM*/


//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				cTexto += "Foi incluํda a consulta padrใo " + aSXB[nI][1] + CRLF
			EndIf

			RecLock( "SXB", .T. )

			For nJ := 1 To Len( aSXB[nI] )
				If !Empty( FieldName( FieldPos( aEstrut[nJ] ) ) )
					FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
				EndIf
			Next nJ

			dbCommit()
			MsUnLock()

		Else

			//
			// Verifica todos os campos
			//
			For nJ := 1 To Len( aSXB[nI] )

				RecLock( "SXB", .F. )
				FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
				dbCommit()
				MsUnLock()

				If !( aSXB[nI][1] $ cAlias )
					cAlias += aSXB[nI][1] + "/"
					cTexto += "Foi Alterada a consulta padrao " + aSXB[nI][1] + CRLF
				EndIf

			Next

		EndIf

	EndIf

	oProcess:IncRegua2( "Atualizando Consultas Padroes (SXB)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


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

oDlg:cToolTip := "Tela para M๚ltiplas Sele็๕es de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza็ใo"

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
Message "Inverter Sele็ใo" Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Mแscara Empresa ( ?? )"  Of oDlg
@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando mแscara ( ?? )"    Of oDlg
@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando mแscara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Sele็ใo"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Sele็ใo" Enable Of oDlg
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
ฑฑบ Programa ณ MyOpenSM0บ Autor ณ TOTVS Protheus     บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento abertura do SM0 modo exclusivo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.10.4 EFS       ณฑฑ
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
	MsgStop( "Nใo foi possํvel a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENวรO" )
EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
