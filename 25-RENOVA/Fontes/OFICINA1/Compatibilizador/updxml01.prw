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


User Function UPDXML01( cEmpAmb, cFilAmb )

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
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDXML01" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDXML01" )
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
			MsgStop( "Atualização não Realizada.", "UPDXML01" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "UPDXML01" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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

			RpcSetType( 3 )
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

						Begin Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oProcess:IncRegua1( "Analisando Gatilhos..." + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." ) 		
			GeraSX7()

			End Transaction
			
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
			// Atualiza o dicionário SX6
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()

			//------------------------------------
			// Atualiza o dicionário SXB
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB()

			//------------------------------------
			// Atualiza o dicionário SX5
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de tabelas sistema" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX5()

			//------------------------------------
			// Atualiza o dicionário SX9
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de relacionamentos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX9()

			//------------------------------------
			// Atualiza o dicionário SX1
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de perguntas" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX1()

			//------------------------------------
			// Atualiza os helps
			//------------------------------------
			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuHlp()
			FSAtuHlpX1()

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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ UPDAtuSX2  º Autor ³ Felipi Marques     º Data ³  19/08/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SX2 - Arquivos      	³±±
±±º          ³                                                            	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ UPDAtuSX2                                                   	³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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
             "X2_POSLGT" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

// Tabela SDS
aAdd( aSX2, { ;
	'SDS'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SDS'+cEmpr																, ; //X2_ARQUIVO
	'Cabeçalho importação XML NF-e'											, ; //X2_NOME
	'Encabez importacion XML e-Fact'										, ; //X2_NOMESPA
	'XML INv-e Import Header'												, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	'S'																		, ; //X2_PYME
	'DS_FILIAL+DS_DOC+DS_SERIE+DS_FORNEC+DS_LOJA'							, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	'1'																		, ; //X2_POSLGT
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	2																		} ) //X2_MODULO

//
// Tabela SDT
//
aAdd( aSX2, { ;
	'SDT'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SDT'+cEmpr																, ; //X2_ARQUIVO
	'Itens importação XML NF-e'												, ; //X2_NOME
	'Items importacion XML e-Fact'											, ; //X2_NOMESPA
	'Inv-e XML Import Items'												, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	'S'																		, ; //X2_PYME
	'DT_FILIAL+DT_DOC+DT_SERIE+DT_FORNEC+DT_LOJA+DT_ITEM'					, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	'1'																		, ; //X2_POSLGT
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	2																		} ) //X2_MODULO

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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³  UPDAtuSX3 º Autor ³ Felipi Marques     º Data ³  19/08/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SX3 - Campos        	³±±
±±º          ³                                                           	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ UPDAtuSX3                                                	³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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
Local lTodosSim := .T.
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
             { "X3_AGRUP"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


// --- ATENÇÃO ---
// Coloque .F. na 2a. posição de cada elemento do array, para os dados do SX3
// que não serão atualizados quando o campo já existir.

// Campos Tabela SA1
If !SX3->(dbSeek('A1_ULTA5'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SA1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SA1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'A1_ULTA5'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 1																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Ult ProdxFor'														, .T. }, ; //X3_TITULO
		{ 'Ult ProdxFor'														, .T. }, ; //X3_TITSPA
		{ 'Ult ProdxFor'														, .T. }, ; //X3_TITENG
		{ 'Ult ProdutoXFornece XML'												, .T. }, ; //X3_DESCRIC
		{ 'Ult ProdutoXFornece XML'												, .T. }, ; //X3_DESCSPA
		{ 'Ult ProdutoXFornece XML'												, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ 'Pertence("12")'														, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ '"1"'																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ '1=Sim;2=Nao'															, .T. }, ; //X3_CBOX
		{ '1=Sim;2=Nao'															, .T. }, ; //X3_CBOXSPA
		{ '1=Sim;2=Nao'															, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ ''																	, .T. }, ; //X3_POSLGT
		{ ''																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf	
// Campos Tabela SA2
If !SX3->(dbSeek('A2_ULTA5'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SA2'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SA2'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'A2_ULTA5'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 1																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Ult ProdxFor'														, .T. }, ; //X3_TITULO
		{ 'Ult ProdxFor'														, .T. }, ; //X3_TITSPA
		{ 'Ult ProdxFor'														, .T. }, ; //X3_TITENG
		{ 'Ult ProdutoXFornece XML'												, .T. }, ; //X3_DESCRIC
		{ 'Ult ProdutoXFornece XML'												, .T. }, ; //X3_DESCSPA
		{ 'Ult ProdutoXFornece XML'												, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ 'Pertence("12")'														, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ '"1"'																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ '1=Sim;2=Nao'															, .T. }, ; //X3_CBOX
		{ '1=Sim;2=Nao'															, .T. }, ; //X3_CBOXSPA
		{ '1=Sim;2=Nao'															, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ ''																	, .T. }, ; //X3_POSLGT
		{ ''																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf	

// Campos Tabela SA5  
If !SX3->(dbSeek('A5_TESBP'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SA5'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	
	aAdd( aSX3, { ;
		{ 'SA5'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'A5_TESBP'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 3																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'TE p/ Bonif.'														, .T. }, ; //X3_TITULO
		{ 'TE p/ Bonif.'														, .T. }, ; //X3_TITSPA
		{ 'TE for Bonus'														, .T. }, ; //X3_TITENG
		{ 'Tp.Entr. p/ Bonificação'												, .T. }, ; //X3_DESCRIC
		{ 'Tp.Entr. p/ Bonificación'											, .T. }, ; //X3_DESCSPA
		{ 'Inflow code for Bonus'												, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ 'MaAvalTes("E",M->A5_TESBP) .And. MT060VlNFe()'						, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ 'SF4'																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('A5_UMNFE'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SA5'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SA5'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'A5_UMNFE'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 1																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'UM p/ NFe'															, .T. }, ; //X3_TITULO
		{ 'UM p/ NFe'															, .T. }, ; //X3_TITSPA
		{ 'UM p/ NFe'															, .T. }, ; //X3_TITENG
		{ 'Unidade de Medida p/ NFe'											, .T. }, ; //X3_DESCRIC
		{ 'Unidad de Medida p/ NFe'												, .T. }, ; //X3_DESCSPA
		{ 'Unit of Measure for NFe'												, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ 'Pertence("12")'														, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ '"1"'																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ '1=1ª UM;2=2ª UM'														, .T. }, ; //X3_CBOX
		{ '1=1ª UM;2=2ª UM'														, .T. }, ; //X3_CBOXSPA
		{ '1=1ª UM;2=2ª UM'														, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('A5_TESCP'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SA5'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	
	aAdd( aSX3, { ;
		{ 'SA5'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'A5_TESCP'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 3																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'TE p/ Compl.'														, .T. }, ; //X3_TITULO
		{ 'TE p/ Compl.'														, .T. }, ; //X3_TITSPA
		{ 'TE for Compl'														, .T. }, ; //X3_TITENG
		{ 'Tp.Entr. p/ Compl. Preço'											, .T. }, ; //X3_DESCRIC
		{ 'Tp.Entr. p/ Compl. Precio'											, .T. }, ; //X3_DESCSPA
		{ 'Inflow code price compl.'											, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ 'MaAvalTes("E",M->A5_TESCP)'											, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ 'SF4'																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf	
// Campos Tabela SA7
If !SX3->(dbSeek("A7_UMNFE"))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SA7'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)

	aAdd( aSX3, { ;
		{ 'SA7'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'A7_UMNFE'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 1																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'UM p/ NFe'															, .T. }, ; //X3_TITULO
		{ 'UM p/ NFe'															, .T. }, ; //X3_TITSPA
		{ 'UM p/ NFe'															, .T. }, ; //X3_TITENG
		{ 'Unidade de Medida p/ NFe'											, .T. }, ; //X3_DESCRIC
		{ 'Unidad de Medida p/ NFe'												, .T. }, ; //X3_DESCSPA
		{ 'Unit of Measure for NFe'												, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ 'Pertence("12")'														, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ '"1"'																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ '1=1ª UM;2=2ª UM'														, .T. }, ; //X3_CBOX
		{ '1=1ª UM;2=2ª UM'														, .T. }, ; //X3_CBOXSPA
		{ '1=1ª UM;2=2ª UM'														, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
// Campos Tabela SC7
If !SX3->(dbSeek('C7_IDTSS'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SC7'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)

	aAdd( aSX3, { ;
		{ 'SC7'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'C7_IDTSS'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 15																	, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'ID TSS'																, .T. }, ; //X3_TITULO
		{ 'ID TSS'																, .T. }, ; //X3_TITSPA
		{ 'ID TSS'																, .T. }, ; //X3_TITENG
		{ 'ID TSS Totvs'														, .T. }, ; //X3_DESCRIC
		{ 'ID TSS Totvs'														, .T. }, ; //X3_DESCSPA
		{ 'ID TSS Totvs'														, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ ''																	, .T. }, ; //X3_VISUAL
		{ ''																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf	
If !SX3->(dbSeek('C7_TPCOLAB'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SC7'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)

	aAdd( aSX3, { ;
		{ 'SC7'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'C7_TPCOLAB'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 3																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Tp. Mens'															, .T. }, ; //X3_TITULO
		{ 'Tp. Mens'															, .T. }, ; //X3_TITSPA
		{ 'Tp. Mens'															, .T. }, ; //X3_TITENG
		{ 'Tp. Mensagem'														, .T. }, ; //X3_DESCRIC
		{ 'Tipo mensaje'														, .T. }, ; //X3_DESCSPA
		{ 'Type Message'														, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'M'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ ''																	, .T. }, ; //X3_VISUAL
		{ ''																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ '1'																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf

//Campos Tabela SD1
If !SX3->(dbSeek('D1_TPIMP'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)

	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_TPIMP'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 1																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Tp. doc. imp'														, .T. }, ; //X3_TITULO
		{ 'Tp. doc. imp'														, .T. }, ; //X3_TITSPA
		{ 'Imp.Doc.Tp.'															, .T. }, ; //X3_TITENG
		{ 'Tipo documento importação'											, .T. }, ; //X3_DESCRIC
		{ 'Tipo documento importacio'											, .T. }, ; //X3_DESCSPA
		{ 'Import document type'												, .T. }, ; //X3_DESCENG
		{ '9'																	, .T. }, ; //X3_PICTURE
		{ "Pertence('01')"														, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ '0=Declaraçao de importaçao;1=Declaraçao simplificada de importaçao'		, .T. }, ; //X3_CBOX
		{ '0=Declaracion de importacion;1=Declaracion simplificada de importacion'	, .T. }, ; //X3_CBOXSPA
		{ '0=Import statement;1=Simplified import statement'					, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ ''																	, .T. }, ; //X3_POSLGT
		{ ''																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_NDI'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_NDI'																, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 12																	, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'No. da DI/DA'														, .T. }, ; //X3_TITULO
		{ 'No. DI/DA'															, .T. }, ; //X3_TITSPA
		{ 'DI/DA No'															, .T. }, ; //X3_TITENG
		{ 'No. da DI/DA'														, .T. }, ; //X3_DESCRIC
		{ 'No. de la DI/DA'														, .T. }, ; //X3_DESCSPA
		{ 'DI/DA No'															, .T. }, ; //X3_DESCENG
		{ '@R 99.99999999-99'													, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ ''																	, .T. }, ; //X3_POSLGT
		{ ''																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_LOCDES'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_LOCDES'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 30																	, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Descr.Local'															, .T. }, ; //X3_TITULO
		{ 'Descr.Local'															, .T. }, ; //X3_TITSPA
		{ 'Loc. Desc.'															, .T. }, ; //X3_TITENG
		{ 'Descricao do Local'													, .T. }, ; //X3_DESCRIC
		{ 'Descripcion del Local'												, .T. }, ; //X3_DESCSPA
		{ 'Location Description'												, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ ''																	, .T. }, ; //X3_POSLGT
		{ ''																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_UFDES'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_UFDES'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 2																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'UF Desembara'														, .T. }, ; //X3_TITULO
		{ 'Est Despacho'														, .T. }, ; //X3_TITSPA
		{ 'Clear. Sate'															, .T. }, ; //X3_TITENG
		{ 'UF do Desembaraco'													, .T. }, ; //X3_DESCRIC
		{ 'Estado del Despacho'													, .T. }, ; //X3_DESCSPA
		{ 'Clearance State'														, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ ''																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ ''																	, .T. }, ; //X3_POSLGT
		{ ''																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_DTDI'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_DTDI'																, .T. }, ; //X3_CAMPO
		{ 'D'																	, .T. }, ; //X3_TIPO
		{ 8																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Registro DI'															, .T. }, ; //X3_TITULO
		{ 'Registro DI'															, .T. }, ; //X3_TITSPA
		{ 'DI Record'															, .T. }, ; //X3_TITENG
		{ 'Registro D.I.'														, .T. }, ; //X3_DESCRIC
		{ 'Registro D.I.'														, .T. }, ; //X3_DESCSPA
		{ 'DI Record'															, .T. }, ; //X3_DESCENG
		{ ''																	, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ ''																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_DTDES'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_DTDES'															, .T. }, ; //X3_CAMPO
		{ 'D'																	, .T. }, ; //X3_TIPO
		{ 8																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Dt Desembar.'														, .T. }, ; //X3_TITULO
		{ 'Fch Despacho'														, .T. }, ; //X3_TITSPA
		{ 'Clear. Date'															, .T. }, ; //X3_TITENG
		{ 'Dt.Desembar.'														, .T. }, ; //X3_DESCRIC
		{ 'Fch.Despacho'														, .T. }, ; //X3_DESCSPA
		{ 'Clearance Date'														, .T. }, ; //X3_DESCENG
		{ ''																	, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ ''																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_CODEXP'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_CODEXP'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 6																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Exportador'															, .T. }, ; //X3_TITULO
		{ 'Exportador'															, .T. }, ; //X3_TITSPA
		{ 'Exporter'															, .T. }, ; //X3_TITENG
		{ 'Cod Exportador'														, .T. }, ; //X3_DESCRIC
		{ 'Cod.Exportador'														, .T. }, ; //X3_DESCSPA
		{ 'Exporter Code'														, .T. }, ; //X3_DESCENG
		{ '@!'																	, .T. }, ; //X3_PICTURE
		{ ''		                                            				, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ 'SA2'																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(150) + Chr(192)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ 'S'																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_NADIC'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
aAdd( aSX3, { ;
	{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
	{ cOrdem																, .T. }, ; //X3_ORDEM
	{ 'D1_NADIC'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 3																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Adicao'																, .T. }, ; //X3_TITULO
	{ 'Adicion'																, .T. }, ; //X3_TITSPA
	{ 'Addition'															, .T. }, ; //X3_TITENG
	{ 'Adicao'																, .T. }, ; //X3_DESCRIC
	{ 'Adicao'																, .T. }, ; //X3_DESCSPA
	{ 'Adicao'																, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_SQADIC'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_SQADIC'															, .T. }, ; //X3_CAMPO
		{ 'C'																	, .T. }, ; //X3_TIPO
		{ 3																		, .T. }, ; //X3_TAMANHO
		{ 0																		, .T. }, ; //X3_DECIMAL
		{ 'Seq Adicao'															, .T. }, ; //X3_TITULO
		{ 'Sec Suma'															, .T. }, ; //X3_TITSPA
		{ 'Addition Seq'														, .T. }, ; //X3_TITENG
		{ 'Seq Adicao'															, .T. }, ; //X3_DESCRIC
		{ 'Sec Suma'															, .T. }, ; //X3_DESCSPA
		{ 'Addition Sequence'													, .T. }, ; //X3_DESCENG
		{ '999'																	, .T. }, ; //X3_PICTURE
		{ ''																	, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_BCIMP'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_BCIMP'															, .T. }, ; //X3_CAMPO
		{ 'N'																	, .T. }, ; //X3_TIPO
		{ 15																	, .T. }, ; //X3_TAMANHO
		{ 2																		, .T. }, ; //X3_DECIMAL
		{ 'Vlr BC Impor'														, .T. }, ; //X3_TITULO
		{ 'Vlr BC Impor'														, .T. }, ; //X3_TITSPA
		{ 'ImportBCAmt'															, .T. }, ; //X3_TITENG
		{ 'Vlr BC Importacao'													, .T. }, ; //X3_DESCRIC
		{ 'Vlr.BC Importación'													, .T. }, ; //X3_DESCSPA
		{ 'Import BC Amount'													, .T. }, ; //X3_DESCENG
		{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
		{ 'Positivo()'															, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ '0'																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ ''																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ ''																	, .T. }, ; //X3_VISUAL
		{ ''																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_VDESDI'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_VDESDI'															, .T. }, ; //X3_CAMPO
		{ 'N'																	, .T. }, ; //X3_TIPO
		{ 15																	, .T. }, ; //X3_TAMANHO
		{ 2																		, .T. }, ; //X3_DECIMAL
		{ 'Vlr Desconto'														, .T. }, ; //X3_TITULO
		{ 'Vlr Descuent'														, .T. }, ; //X3_TITSPA
		{ 'Discount Vl.'														, .T. }, ; //X3_TITENG
		{ 'Valor Desconto'														, .T. }, ; //X3_DESCRIC
		{ 'Valor Descuento'														, .T. }, ; //X3_DESCSPA
		{ 'Discount Value'														, .T. }, ; //X3_DESCENG
		{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
		{ 'Positivo()'															, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ 'S'																	, .T. }, ; //X3_PROPRI
		{ 'N'																	, .T. }, ; //X3_BROWSE
		{ 'A'																	, .T. }, ; //X3_VISUAL
		{ 'R'																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ ''																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_DSPAD'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_DSPAD'															, .T. }, ; //X3_CAMPO
		{ 'N'																	, .T. }, ; //X3_TIPO
		{ 15																	, .T. }, ; //X3_TAMANHO
		{ 2																		, .T. }, ; //X3_DECIMAL
		{ 'Vlr Desp.Adu'														, .T. }, ; //X3_TITULO
		{ 'Vlr Gast.Adu'														, .T. }, ; //X3_TITSPA
		{ 'CustmExpAmt'															, .T. }, ; //X3_TITENG
		{ 'Vlr Desp.Aduaneira'													, .T. }, ; //X3_DESCRIC
		{ 'Vlr.gasto aduanero'													, .T. }, ; //X3_DESCSPA
		{ 'CustomsExpenseAmount'												, .T. }, ; //X3_DESCENG
		{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
		{ 'Positivo()'															, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ ''																	, .T. }, ; //X3_PROPRI
		{ 'S'																	, .T. }, ; //X3_BROWSE
		{ ''																	, .T. }, ; //X3_VISUAL
		{ ''																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf
If !SX3->(dbSeek('D1_VLRII'))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek('SD1'))
	SX3->(dbSkip(-1))
	cOrdem := Soma1(SX3->X3_ORDEM)
	aAdd( aSX3, { ;
		{ 'SD1'																	, .T. }, ; //X3_ARQUIVO
		{ cOrdem																, .T. }, ; //X3_ORDEM
		{ 'D1_VLRII'															, .T. }, ; //X3_CAMPO
		{ 'N'																	, .T. }, ; //X3_TIPO
		{ 15																	, .T. }, ; //X3_TAMANHO
		{ 2																		, .T. }, ; //X3_DECIMAL
		{ 'Vlr Imp.Impo'														, .T. }, ; //X3_TITULO
		{ 'Vlr Imp.Impo'														, .T. }, ; //X3_TITSPA
		{ 'ImpoImpAmt'															, .T. }, ; //X3_TITENG
		{ 'Vlr Imp.Importacao'													, .T. }, ; //X3_DESCRIC
		{ 'Vlr Imp.Importación'													, .T. }, ; //X3_DESCSPA
		{ 'Import Imp. Amount'													, .T. }, ; //X3_DESCENG
		{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
		{ 'Positivo()'															, .T. }, ; //X3_VALID
		{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
		Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
		{ ''																	, .T. }, ; //X3_RELACAO
		{ ''																	, .T. }, ; //X3_F3
		{ 1																		, .T. }, ; //X3_NIVEL
		{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
		{ ''																	, .T. }, ; //X3_CHECK
		{ ''																	, .T. }, ; //X3_TRIGGER
		{ ''																	, .T. }, ; //X3_PROPRI
		{ ''																	, .T. }, ; //X3_BROWSE
		{ ''																	, .T. }, ; //X3_VISUAL
		{ ''																	, .T. }, ; //X3_CONTEXT
		{ ''																	, .T. }, ; //X3_OBRIGAT
		{ ''																	, .T. }, ; //X3_VLDUSER
		{ ''																	, .T. }, ; //X3_CBOX
		{ ''																	, .T. }, ; //X3_CBOXSPA
		{ ''																	, .T. }, ; //X3_CBOXENG
		{ ''																	, .T. }, ; //X3_PICTVAR
		{ ''																	, .T. }, ; //X3_WHEN
		{ ''																	, .T. }, ; //X3_INIBRW
		{ ''																	, .T. }, ; //X3_GRPSXG
		{ ''																	, .T. }, ; //X3_FOLDER
		{ ''																	, .T. }, ; //X3_CONDSQL
		{ ''																	, .T. }, ; //X3_CHKSQL
		{ 'N'																	, .T. }, ; //X3_IDXSRV
		{ 'N'																	, .T. }, ; //X3_ORTOGRA
		{ ''																	, .T. }, ; //X3_TELA
		{ '1'																	, .T. }, ; //X3_POSLGT
		{ 'N'																	, .T. }, ; //X3_IDXFLD
		{ ''																	, .T. }, ; //X3_AGRUP
		{ 'S'																	, .T. }} ) //X3_PYME
EndIf


// Campos Tabela SDS
aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '01'																	, .T. }, ; //X3_ORDEM
	{ 'DS_FILIAL'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 2																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Filial'																, .T. }, ; //X3_TITULO
	{ 'Sucursal'															, .T. }, ; //X3_TITSPA
	{ 'Branch'																, .T. }, ; //X3_TITENG
	{ 'Filial do Sistema'													, .T. }, ; //X3_DESCRIC
	{ 'Sucursal'															, .T. }, ; //X3_DESCSPA
	{ 'Branch of the System'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '033'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '02'																	, .T. }, ; //X3_ORDEM
	{ 'DS_TIPO'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 1																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Tipo da Nota'														, .T. }, ; //X3_TITULO
	{ 'Tipo Factura'														, .T. }, ; //X3_TITSPA
	{ 'Invoice Type'														, .T. }, ; //X3_TITENG
	{ 'Tipo da Nota'														, .T. }, ; //X3_DESCRIC
	{ 'Tipo Factura'														, .T. }, ; //X3_DESCSPA
	{ 'Invoice Type'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ 'Pertence("NODBCT")'													, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ 'S'																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ 'N=Normal;O=Bonificação;D=Devolução;B=Beneficiamento;C=Compl. Preço;T=Transporte', .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '03'																	, .T. }, ; //X3_ORDEM
	{ 'DS_DOC'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 9																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Numero'																, .T. }, ; //X3_TITULO
	{ 'Num. de Doc.'														, .T. }, ; //X3_TITSPA
	{ 'Invoice'																, .T. }, ; //X3_TITENG
	{ 'Numero do documento'													, .T. }, ; //X3_DESCRIC
	{ 'Numero de documento'													, .T. }, ; //X3_DESCSPA
	{ 'Invoice Number'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(131) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '018'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '04'																	, .T. }, ; //X3_ORDEM
	{ 'DS_SERIE'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 3																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Serie'																, .T. }, ; //X3_TITULO
	{ 'Serie'																, .T. }, ; //X3_TITSPA
	{ 'Series'																, .T. }, ; //X3_TITENG
	{ 'Serie do Documento'													, .T. }, ; //X3_DESCRIC
	{ 'Serie del Documento'													, .T. }, ; //X3_DESCSPA
	{ 'Document Series'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(130) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '05'																	, .T. }, ; //X3_ORDEM
	{ 'DS_FORNEC'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Forn/Cliente'														, .T. }, ; //X3_TITULO
	{ 'Prov/Cliente'														, .T. }, ; //X3_TITSPA
	{ 'Sup/Cust'															, .T. }, ; //X3_TITENG
	{ 'Código do Forn/Cliente'												, .T. }, ; //X3_DESCRIC
	{ 'Codigo de Prov/Cliente'												, .T. }, ; //X3_DESCSPA
	{ 'Supplier/Customer Code'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(131) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '001'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '06'																	, .T. }, ; //X3_ORDEM
	{ 'DS_LOJA'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 2																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Loja'																, .T. }, ; //X3_TITULO
	{ 'Tienda'																, .T. }, ; //X3_TITSPA
	{ 'Unit'																, .T. }, ; //X3_TITENG
	{ 'Loja do Forn/Cliente'												, .T. }, ; //X3_DESCRIC
	{ 'Tienda de Prov/Cliente'												, .T. }, ; //X3_DESCSPA
	{ 'Supplier/Customer Store'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(131) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '002'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '07'																	, .T. }, ; //X3_ORDEM
	{ 'DS_NOMEFOR'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 40																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Nome'																, .T. }, ; //X3_TITULO
	{ 'Nombre'																, .T. }, ; //X3_TITSPA
	{ 'Name'																, .T. }, ; //X3_TITENG
	{ 'Nome Fornecedor/Cliente'												, .T. }, ; //X3_DESCRIC
	{ 'Nome Proveedor/Cliente'												, .T. }, ; //X3_DESCSPA
	{ 'Nome Customer/Supplier'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ 'If(FindFunction("NOMEFORIni"),NOMEFORIni(),A140IBusFC(SDS->DS_TIPO))'	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'V'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ 'NOMEFORIni()'														, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '08'																	, .T. }, ; //X3_ORDEM
	{ 'DS_CNPJ'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'CNPJ For/Cli'														, .T. }, ; //X3_TITULO
	{ 'CNPJ Pro/Cli'														, .T. }, ; //X3_TITSPA
	{ 'CNPJ Cus/Sup'														, .T. }, ; //X3_TITENG
	{ 'CNPJ Fornecedor/Cliente'												, .T. }, ; //X3_DESCRIC
	{ 'CNPJ Proveedor/Cliente'												, .T. }, ; //X3_DESCSPA
	{ 'CNPJ Customer/Supplier'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ 'A140IPict()'															, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '09'																	, .T. }, ; //X3_ORDEM
	{ 'DS_EMISSA'															, .T. }, ; //X3_CAMPO
	{ 'D'																	, .T. }, ; //X3_TIPO
	{ 8																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'DT Emissao'															, .T. }, ; //X3_TITULO
	{ 'Fch Emision'															, .T. }, ; //X3_TITSPA
	{ 'Issue Date'															, .T. }, ; //X3_TITENG
	{ 'Data de Emissao da NF'												, .T. }, ; //X3_DESCRIC
	{ 'Fecha de Emision Factura'											, .T. }, ; //X3_DESCSPA
	{ 'Invoice Issue Date'													, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ 'ddatabase'															, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(131) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '10'																	, .T. }, ; //X3_ORDEM
	{ 'DS_FORMUL'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 1																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Form. Prop.'															, .T. }, ; //X3_TITULO
	{ 'Form. Propio'														, .T. }, ; //X3_TITSPA
	{ 'Proper Form'															, .T. }, ; //X3_TITENG
	{ 'Formulario Proprio'													, .T. }, ; //X3_DESCRIC
	{ 'Planilla Propia'														, .T. }, ; //X3_DESCSPA
	{ 'Proper Form'															, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(144) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '11'																	, .T. }, ; //X3_ORDEM
	{ 'DS_ESPECI'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 5																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Espec.Docum.'														, .T. }, ; //X3_TITULO
	{ 'Especie Doc.'														, .T. }, ; //X3_TITSPA
	{ 'Document Ty.'														, .T. }, ; //X3_TITENG
	{ 'Espécie do Documento'												, .T. }, ; //X3_DESCRIC
	{ 'Especie del Documento'												, .T. }, ; //X3_DESCSPA
	{ 'Type of Document'													, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ '42'																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ ''																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '12'																	, .T. }, ; //X3_ORDEM
	{ 'DS_EST'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 2																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Estado'																, .T. }, ; //X3_TITULO
	{ 'Estado'																, .T. }, ; //X3_TITSPA
	{ 'State'																, .T. }, ; //X3_TITENG
	{ 'Estado de emissao da NF'												, .T. }, ; //X3_DESCRIC
	{ 'Estado Emisor Factura'												, .T. }, ; //X3_DESCSPA
	{ 'State of Invoice Issue'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(146) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '010'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '13'																	, .T. }, ; //X3_ORDEM
	{ 'DS_STATUS'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 1																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Status'																, .T. }, ; //X3_TITULO
	{ 'Status'																, .T. }, ; //X3_TITSPA
	{ 'Status'																, .T. }, ; //X3_TITENG
	{ 'Status do Registro'													, .T. }, ; //X3_DESCRIC
	{ 'Status do Registro'													, .T. }, ; //X3_DESCSPA
	{ 'Status do Registro'													, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '14'																	, .T. }, ; //X3_ORDEM
	{ 'DS_ARQUIVO'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 80																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Arquivo'																, .T. }, ; //X3_TITULO
	{ 'Arquivo'																, .T. }, ; //X3_TITSPA
	{ 'File'																, .T. }, ; //X3_TITENG
	{ 'Nome do Arquivo XML'													, .T. }, ; //X3_DESCRIC
	{ 'Nome do Arquivo XML'													, .T. }, ; //X3_DESCSPA
	{ 'Nome do Arquivo XML'													, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '15'																	, .T. }, ; //X3_ORDEM
	{ 'DS_USERIMP'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 25																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Usuario'																, .T. }, ; //X3_TITULO
	{ 'Usuario'																, .T. }, ; //X3_TITSPA
	{ 'User'																, .T. }, ; //X3_TITENG
	{ 'Usuario na importacao'												, .T. }, ; //X3_DESCRIC
	{ 'Usuario na importacao'												, .T. }, ; //X3_DESCSPA
	{ 'Usuario na importacao'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '16'																	, .T. }, ; //X3_ORDEM
	{ 'DS_DATAIMP'															, .T. }, ; //X3_CAMPO
	{ 'D'																	, .T. }, ; //X3_TIPO
	{ 8																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Data Import.'														, .T. }, ; //X3_TITULO
	{ 'Data Import.'														, .T. }, ; //X3_TITSPA
	{ 'Data Import.'														, .T. }, ; //X3_TITENG
	{ 'Data importacao do XML'												, .T. }, ; //X3_DESCRIC
	{ 'Data importacao do XML'												, .T. }, ; //X3_DESCSPA
	{ 'Data importacao do XML'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '17'																	, .T. }, ; //X3_ORDEM
	{ 'DS_HORAIMP'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 5																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Hora Import.'														, .T. }, ; //X3_TITULO
	{ 'Hora Import.'														, .T. }, ; //X3_TITSPA
	{ 'Hour Import.'														, .T. }, ; //X3_TITENG
	{ 'Hora importacao XML'													, .T. }, ; //X3_DESCRIC
	{ 'Hora importacao XML'													, .T. }, ; //X3_DESCSPA
	{ 'Hora importacao XML'													, .T. }, ; //X3_DESCENG
	{ '99:99'																, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '18'																	, .T. }, ; //X3_ORDEM
	{ 'DS_USERPRE'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 25																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Usuario'																, .T. }, ; //X3_TITULO
	{ 'User'																, .T. }, ; //X3_TITSPA
	{ 'User'																, .T. }, ; //X3_TITENG
	{ 'Usuário res. Ger. Pre-NF'											, .T. }, ; //X3_DESCRIC
	{ 'Usuário res. Ger. Pre-NF'											, .T. }, ; //X3_DESCSPA
	{ 'Usuário res. Ger. pré-NF'											, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '19'																	, .T. }, ; //X3_ORDEM
	{ 'DS_DATAPRE'															, .T. }, ; //X3_CAMPO
	{ 'D'																	, .T. }, ; //X3_TIPO
	{ 8																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Data Pre NF'															, .T. }, ; //X3_TITULO
	{ 'Data Pre NF'															, .T. }, ; //X3_TITSPA
	{ 'Data Pre NF'															, .T. }, ; //X3_TITENG
	{ 'Data de geracao de Pre-NF'											, .T. }, ; //X3_DESCRIC
	{ 'Data de geracao de Pre-NF'											, .T. }, ; //X3_DESCSPA
	{ 'Data de geracao de Pre-NF'											, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '20'																	, .T. }, ; //X3_ORDEM
	{ 'DS_HORAPRE'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 5																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Hora Pre NF'															, .T. }, ; //X3_TITULO
	{ 'Hora Pre NF'															, .T. }, ; //X3_TITSPA
	{ 'Hora Pre NF'															, .T. }, ; //X3_TITENG
	{ 'Hora de geração da Pre-NF'											, .T. }, ; //X3_DESCRIC
	{ 'Hora de geração da Pre-NF'											, .T. }, ; //X3_DESCSPA
	{ 'Hora de geração da Pre-NF'											, .T. }, ; //X3_DESCENG
	{ '99:99'																, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '21'																	, .T. }, ; //X3_ORDEM
	{ 'DS_CHAVENF'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 44																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Chave Acess.'														, .T. }, ; //X3_TITULO
	{ 'Chave Acess.'														, .T. }, ; //X3_TITSPA
	{ 'Chave Acess.'														, .T. }, ; //X3_TITENG
	{ 'Chave de Acesso da NF'												, .T. }, ; //X3_DESCRIC
	{ 'Chave de Acesso da NF'												, .T. }, ; //X3_DESCSPA
	{ 'Chave de Acesso da NF'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '22'																	, .T. }, ; //X3_ORDEM
	{ 'DS_VERSAO'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 5																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Versao da Nf'														, .T. }, ; //X3_TITULO
	{ 'Versao da Nf'														, .T. }, ; //X3_TITSPA
	{ 'Versao da Nf'														, .T. }, ; //X3_TITENG
	{ 'Versao Layout da NFe'												, .T. }, ; //X3_DESCRIC
	{ 'Versao Layout da NFe'												, .T. }, ; //X3_DESCSPA
	{ 'Versao Layout da NFe'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '23'																	, .T. }, ; //X3_ORDEM
	{ 'DS_FRETE'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Frete'															, .T. }, ; //X3_TITULO
	{ 'Valor Flete'															, .T. }, ; //X3_TITSPA
	{ 'Freight Val.'														, .T. }, ; //X3_TITENG
	{ 'Valor do frete'														, .T. }, ; //X3_DESCRIC
	{ 'Valor del Flete'														, .T. }, ; //X3_DESCSPA
	{ 'Freight Value'														, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '24'																	, .T. }, ; //X3_ORDEM
	{ 'DS_SEGURO'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Seguro'															, .T. }, ; //X3_TITULO
	{ 'Seguro'																, .T. }, ; //X3_TITSPA
	{ 'Insurance'															, .T. }, ; //X3_TITENG
	{ 'Valor do Seguro'														, .T. }, ; //X3_DESCRIC
	{ 'Valor del Seguro'													, .T. }, ; //X3_DESCSPA
	{ 'Insurance Value'														, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '25'																	, .T. }, ; //X3_ORDEM
	{ 'DS_DESPESA'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Despesas'														, .T. }, ; //X3_TITULO
	{ 'Valor Gastos'														, .T. }, ; //X3_TITSPA
	{ 'Expen.Am.'															, .T. }, ; //X3_TITENG
	{ 'Valor das despesas'													, .T. }, ; //X3_DESCRIC
	{ 'Valor de los Gastos'													, .T. }, ; //X3_DESCSPA
	{ 'Expense Amount'														, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '26'																	, .T. }, ; //X3_ORDEM
	{ 'DS_DESCONT'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Descontos'															, .T. }, ; //X3_TITULO
	{ 'Descuentos'															, .T. }, ; //X3_TITSPA
	{ 'Discounts'															, .T. }, ; //X3_TITENG
	{ 'Descontos da nota fiscal'											, .T. }, ; //X3_DESCRIC
	{ 'Descuentos de la Factura'											, .T. }, ; //X3_DESCSPA
	{ 'Invoice Discounts'													, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '27'																	, .T. }, ; //X3_ORDEM
	{ 'DS_TRANSP'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Transp.'																, .T. }, ; //X3_TITULO
	{ 'Transp.'																, .T. }, ; //X3_TITSPA
	{ 'Carrier'																, .T. }, ; //X3_TITENG
	{ 'Codigo da Transportadora'											, .T. }, ; //X3_DESCRIC
	{ 'Cod. de la Transportadora'											, .T. }, ; //X3_DESCSPA
	{ 'Carrier Code'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '28'																	, .T. }, ; //X3_ORDEM
	{ 'DS_PLACA'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 8																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Placa'																, .T. }, ; //X3_TITULO
	{ 'Matricula'															, .T. }, ; //X3_TITSPA
	{ 'LicensePlate'														, .T. }, ; //X3_TITENG
	{ 'Placa Veiculo'														, .T. }, ; //X3_DESCRIC
	{ 'Matricula del Vehiculo'												, .T. }, ; //X3_DESCSPA
	{ 'Vehicle License Plate'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '29'																	, .T. }, ; //X3_ORDEM
	{ 'DS_PLIQUI'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 11																	, .T. }, ; //X3_TAMANHO
	{ 4																		, .T. }, ; //X3_DECIMAL
	{ 'Peso Liquido'														, .T. }, ; //X3_TITULO
	{ 'Peso Neto'															, .T. }, ; //X3_TITSPA
	{ 'Net Weight'															, .T. }, ; //X3_TITENG
	{ 'Peso Liquido da N.F.'												, .T. }, ; //X3_DESCRIC
	{ 'Peso Neto de la Fact.'												, .T. }, ; //X3_DESCSPA
	{ 'NF Net Weight'														, .T. }, ; //X3_DESCENG
	{ '@E 999,999.9999'														, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '30'																	, .T. }, ; //X3_ORDEM
	{ 'DS_PBRUTO'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 11																	, .T. }, ; //X3_TAMANHO
	{ 4																		, .T. }, ; //X3_DECIMAL
	{ 'Peso Bruto'															, .T. }, ; //X3_TITULO
	{ 'Peso Bruto'															, .T. }, ; //X3_TITSPA
	{ 'Gross Weight'														, .T. }, ; //X3_TITENG
	{ 'Peso Bruto da N.F.'													, .T. }, ; //X3_DESCRIC
	{ 'Peso Bruto Factura'													, .T. }, ; //X3_DESCSPA
	{ 'Inv. Gross Weight'													, .T. }, ; //X3_DESCENG
	{ '@E 999,999.9999'														, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '31'																	, .T. }, ; //X3_ORDEM
	{ 'DS_ESPECI1'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Especie 1'															, .T. }, ; //X3_TITULO
	{ 'Especie 1'															, .T. }, ; //X3_TITSPA
	{ 'Species 1'															, .T. }, ; //X3_TITENG
	{ 'Especie 1'															, .T. }, ; //X3_DESCRIC
	{ 'Especie 1'															, .T. }, ; //X3_DESCSPA
	{ 'Species 1'															, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '32'																	, .T. }, ; //X3_ORDEM
	{ 'DS_ESPECI2'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Especie 2'															, .T. }, ; //X3_TITULO
	{ 'Especie 2'															, .T. }, ; //X3_TITSPA
	{ 'Species 2'															, .T. }, ; //X3_TITENG
	{ 'Especie 2'															, .T. }, ; //X3_DESCRIC
	{ 'Especie 2'															, .T. }, ; //X3_DESCSPA
	{ 'Species 2'															, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '33'																	, .T. }, ; //X3_ORDEM
	{ 'DS_VOLUME1'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Volume 1'															, .T. }, ; //X3_TITULO
	{ 'Volumen 1'															, .T. }, ; //X3_TITSPA
	{ 'Volume 1'															, .T. }, ; //X3_TITENG
	{ 'Volume 1'															, .T. }, ; //X3_DESCRIC
	{ 'Volumen 1'															, .T. }, ; //X3_DESCSPA
	{ 'Volume 1'															, .T. }, ; //X3_DESCENG
	{ '@E 999999'															, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '34'																	, .T. }, ; //X3_ORDEM
	{ 'DS_TPFRETE'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 1																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Tipo de fret'														, .T. }, ; //X3_TITULO
	{ 'Tipo Flete'															, .T. }, ; //X3_TITSPA
	{ 'Tp.Freight'															, .T. }, ; //X3_TITENG
	{ 'Indica tipo de frete'												, .T. }, ; //X3_DESCRIC
	{ 'Indica el tipo de flete'												, .T. }, ; //X3_DESCSPA
	{ 'Ind.Type of Freight'													, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '35'																	, .T. }, ; //X3_ORDEM
	{ 'DS_ESPECI3'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Especie 3'															, .T. }, ; //X3_TITULO
	{ 'Especie 3'															, .T. }, ; //X3_TITSPA
	{ 'Species 3'															, .T. }, ; //X3_TITENG
	{ 'Especie 3'															, .T. }, ; //X3_DESCRIC
	{ 'Especie 3'															, .T. }, ; //X3_DESCSPA
	{ 'Species 3'															, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '36'																	, .T. }, ; //X3_ORDEM
	{ 'DS_ESPECI4'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Especie 4'															, .T. }, ; //X3_TITULO
	{ 'Especie 4'															, .T. }, ; //X3_TITSPA
	{ 'Species 4'															, .T. }, ; //X3_TITENG
	{ 'Especie 4'															, .T. }, ; //X3_DESCRIC
	{ 'Especie 4'															, .T. }, ; //X3_DESCSPA
	{ 'Species 4'															, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '37'																	, .T. }, ; //X3_ORDEM
	{ 'DS_VALMERC'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr. Mercad.'														, .T. }, ; //X3_TITULO
	{ 'Vlr. Mercad.'														, .T. }, ; //X3_TITSPA
	{ 'Goods Value'															, .T. }, ; //X3_TITENG
	{ 'Valor da Mercadoria'													, .T. }, ; //X3_DESCRIC
	{ 'Valor de la Mercaderia'												, .T. }, ; //X3_DESCSPA
	{ 'Goods Value'															, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '38'																	, .T. }, ; //X3_ORDEM
	{ 'DS_VOLUME2'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Volume 2'															, .T. }, ; //X3_TITULO
	{ 'Volumen 2'															, .T. }, ; //X3_TITSPA
	{ 'Volume 2'															, .T. }, ; //X3_TITENG
	{ 'Volume 2'															, .T. }, ; //X3_DESCRIC
	{ 'Volumen 2'															, .T. }, ; //X3_DESCSPA
	{ 'Volume 2'															, .T. }, ; //X3_DESCENG
	{ '@E 999999'															, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '39'																	, .T. }, ; //X3_ORDEM
	{ 'DS_VOLUME3'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Volume 3'															, .T. }, ; //X3_TITULO
	{ 'Volumen 3'															, .T. }, ; //X3_TITSPA
	{ 'Volume 3'															, .T. }, ; //X3_TITENG
	{ 'Volume 3'															, .T. }, ; //X3_DESCRIC
	{ 'Volumen 3'															, .T. }, ; //X3_DESCSPA
	{ 'Volume 3'															, .T. }, ; //X3_DESCENG
	{ '@E 999999'															, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '40'																	, .T. }, ; //X3_ORDEM
	{ 'DS_VOLUME4'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Volume 4'															, .T. }, ; //X3_TITULO
	{ 'Volumen 4'															, .T. }, ; //X3_TITSPA
	{ 'Volume 4'															, .T. }, ; //X3_TITENG
	{ 'Volume 4'															, .T. }, ; //X3_DESCRIC
	{ 'Volumen 4'															, .T. }, ; //X3_DESCSPA
	{ 'Volume 4'															, .T. }, ; //X3_DESCENG
	{ '@E 999999'															, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '41'																	, .T. }, ; //X3_ORDEM
	{ 'DS_DOCLOG'															, .T. }, ; //X3_CAMPO
	{ 'M'																	, .T. }, ; //X3_TIPO
	{ 80																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Log'																	, .T. }, ; //X3_TITULO
	{ 'Log'																	, .T. }, ; //X3_TITSPA
	{ 'Log'																	, .T. }, ; //X3_TITENG
	{ 'Log. da Ocorrencia'													, .T. }, ; //X3_DESCRIC
	{ 'Log. de la Ocurrencia'												, .T. }, ; //X3_DESCSPA
	{ 'Occurrence Log'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '42'																	, .T. }, ; //X3_ORDEM
	{ 'DS_OK'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 2																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Ok'																	, .T. }, ; //X3_TITULO
	{ 'Ok'																	, .T. }, ; //X3_TITSPA
	{ 'Ok'																	, .T. }, ; //X3_TITENG
	{ 'Ok'																	, .T. }, ; //X3_DESCRIC
	{ 'Ok'																	, .T. }, ; //X3_DESCSPA
	{ 'Ok'																	, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '43'																	, .T. }, ; //X3_ORDEM
	{ 'DS_BASEICM'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Base p/ ICMS'														, .T. }, ; //X3_TITULO
	{ 'Base p/ ICMS'														, .T. }, ; //X3_TITSPA
	{ 'ICMS T.Base'															, .T. }, ; //X3_TITENG
	{ 'Base de calculo para ICMS'											, .T. }, ; //X3_DESCRIC
	{ 'Base de calculo para ICMS'											, .T. }, ; //X3_DESCSPA
	{ 'ICMS Tax Base'														, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(32)						, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '44'																	, .T. }, ; //X3_ORDEM
	{ 'DS_VALICM'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Valor ICMS'															, .T. }, ; //X3_TITULO
	{ 'Valor ICMS'															, .T. }, ; //X3_TITSPA
	{ 'ICMS Value'															, .T. }, ; //X3_TITENG
	{ 'Valor do ICMS'														, .T. }, ; //X3_DESCRIC
	{ 'Valor del ICMS'														, .T. }, ; //X3_DESCSPA
	{ 'ICMS Value'															, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(32)						, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '45'																	, .T. }, ; //X3_ORDEM
	{ 'DS_XMLDOC'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 9																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Doc XML Imp'															, .T. }, ; //X3_TITULO
	{ 'Doc XML Imp'															, .T. }, ; //X3_TITSPA
	{ 'Doc XML Imp'															, .T. }, ; //X3_TITENG
	{ 'Doc XML Importacao'													, .T. }, ; //X3_DESCRIC
	{ 'Doc XML Importacao'													, .T. }, ; //X3_DESCSPA
	{ 'Doc XML Importacao'													, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(32)						, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '46'																	, .T. }, ; //X3_ORDEM
	{ 'DS_XMLSER'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 3																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Serie XML Im'														, .T. }, ; //X3_TITULO
	{ 'Serie XML Im'														, .T. }, ; //X3_TITSPA
	{ 'Serie XML Im'														, .T. }, ; //X3_TITENG
	{ 'Serie do doc XML Importac'											, .T. }, ; //X3_DESCRIC
	{ 'Serie do doc XML Importac'											, .T. }, ; //X3_DESCSPA
	{ 'Serie do doc XML Importac'											, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(32)						, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME


aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '47'																	, .T. }, ; //X3_ORDEM
	{ 'DS_NFXML'															, .T. }, ; //X3_CAMPO
	{ 'M'																	, .T. }, ; //X3_TIPO
	{ 80																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'XML Arquivo'  														, .T. }, ; //X3_TITULO
	{ 'XML Arquivo' 														, .T. }, ; //X3_TITSPA
	{ 'XML Arquivo' 														, .T. }, ; //X3_TITENG
	{ 'XML Arquivo'  														, .T. }, ; //X3_DESCRIC
	{ 'XML Arquivo' 														, .T. }, ; //X3_DESCSPA
	{ 'XML Arquivo' 														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDS'																	, .T. }, ; //X3_ARQUIVO
	{ '48'																	, .T. }, ; //X3_ORDEM
	{ 'DS_STAPED'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 1																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Status Pedido'														, .T. }, ; //X3_TITULO
	{ 'Status Pedido'														, .T. }, ; //X3_TITSPA
	{ 'Status Pedido'														, .T. }, ; //X3_TITENG
	{ 'Status Pedido'														, .T. }, ; //X3_DESCRIC
	{ 'Status Pedido'														, .T. }, ; //X3_DESCSPA
	{ 'Status Pedido'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ 'Pertence("12345")'													, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ 'S'																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ '1=Recebido o xml;2=Ped Associado;3=WF Enviado;4=WF Retornado;5=Manifestado', .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME


//
// Campos Tabela SDT
//
aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '01'																	, .T. }, ; //X3_ORDEM
	{ 'DT_FILIAL'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 2																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Filial'																, .T. }, ; //X3_TITULO
	{ 'Sucursal'															, .T. }, ; //X3_TITSPA
	{ 'Branch'																, .T. }, ; //X3_TITENG
	{ 'Filial do Sistema'													, .T. }, ; //X3_DESCRIC
	{ 'Sucursal'															, .T. }, ; //X3_DESCSPA
	{ 'Branch of the System'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '033'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '02'																	, .T. }, ; //X3_ORDEM
	{ 'DT_ITEM'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 4																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Item NF'																, .T. }, ; //X3_TITULO
	{ 'Item Factura'														, .T. }, ; //X3_TITSPA
	{ 'NF Item'																, .T. }, ; //X3_TITENG
	{ 'Item da Nota Fiscal'													, .T. }, ; //X3_DESCRIC
	{ 'Item de la Factura'													, .T. }, ; //X3_DESCSPA
	{ 'Item of Invoice'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(134) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '03'																	, .T. }, ; //X3_ORDEM
	{ 'DT_COD'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 15																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Produto'																, .T. }, ; //X3_TITULO
	{ 'Producto'															, .T. }, ; //X3_TITSPA
	{ 'Product'																, .T. }, ; //X3_TITENG
	{ 'Codigo do Produto'													, .T. }, ; //X3_DESCRIC
	{ 'Codigo del Producto'													, .T. }, ; //X3_DESCSPA
	{ 'Code of Product'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ 'SDTCOD'																, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(129) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ 'S'																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '030'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '04'																	, .T. }, ; //X3_ORDEM
	{ 'DT_DESC'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 30																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Desc. Prod.'															, .T. }, ; //X3_TITULO
	{ 'Desc. Prod.'															, .T. }, ; //X3_TITSPA
	{ 'Desc. Prod.'															, .T. }, ; //X3_TITENG
	{ 'Descricao do Produto'												, .T. }, ; //X3_DESCRIC
	{ 'Descricao do Produto'												, .T. }, ; //X3_DESCSPA
	{ 'Descricao do Produto'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ 'POSICIONE("SB1",1,(XFILIAL("SB1")+SDT->DT_COD),"B1_DESC")'			, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'V'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ '.F.'																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '05'																	, .T. }, ; //X3_ORDEM
	{ 'DT_PRODFOR'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 20																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Prd. For/Cli'														, .T. }, ; //X3_TITULO
	{ 'Prd. For/Cli'														, .T. }, ; //X3_TITSPA
	{ 'Prd. For/Cli'														, .T. }, ; //X3_TITENG
	{ 'Cod. Prod. do Forn/Cli'												, .T. }, ; //X3_DESCRIC
	{ 'Cod. Prod. do Forn/Cli'												, .T. }, ; //X3_DESCSPA
	{ 'Cod. Prod. do Forn/Cli'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '06'																	, .T. }, ; //X3_ORDEM
	{ 'DT_DESCFOR'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 30																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Desc For/Cli'														, .T. }, ; //X3_TITULO
	{ 'Desc For/Cli'														, .T. }, ; //X3_TITSPA
	{ 'Desc For/Cli'														, .T. }, ; //X3_TITENG
	{ 'Desc. Produto Forn/Cli'												, .T. }, ; //X3_DESCRIC
	{ 'Desc. Produto Forn/Cli'												, .T. }, ; //X3_DESCSPA
	{ 'Desc. Produto Forn/Cli'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '07'																	, .T. }, ; //X3_ORDEM
	{ 'DT_FORNEC'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Forn/Cliente'														, .T. }, ; //X3_TITULO
	{ 'Provee/Clien'														, .T. }, ; //X3_TITSPA
	{ 'Suppl/Custom'														, .T. }, ; //X3_TITENG
	{ 'Codigo do Forn/Cliente'												, .T. }, ; //X3_DESCRIC
	{ 'Codigo de Proveed/Cliente'											, .T. }, ; //X3_DESCSPA
	{ 'Supplier/Customer´s Code'											, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(144) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '001'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '08'																	, .T. }, ; //X3_ORDEM
	{ 'DT_LOJA'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 2																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Loja'																, .T. }, ; //X3_TITULO
	{ 'Tienda'																, .T. }, ; //X3_TITSPA
	{ 'Unit'																, .T. }, ; //X3_TITENG
	{ 'Loja do Forn/Cliente'												, .T. }, ; //X3_DESCRIC
	{ 'Tienda de Provee/Cliente'											, .T. }, ; //X3_DESCSPA
	{ 'Supplier/Customer Unit'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(144) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '002'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '09'																	, .T. }, ; //X3_ORDEM
	{ 'DT_DOC'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 9																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Documento'															, .T. }, ; //X3_TITULO
	{ 'Documento'															, .T. }, ; //X3_TITSPA
	{ 'Document'															, .T. }, ; //X3_TITENG
	{ 'Numero do Documento/Nota'											, .T. }, ; //X3_DESCRIC
	{ 'Num. del Doc/Factura'												, .T. }, ; //X3_DESCSPA
	{ 'Document/Invoice Number'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(144) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '018'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '10'																	, .T. }, ; //X3_ORDEM
	{ 'DT_SERIE'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 3																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Serie'																, .T. }, ; //X3_TITULO
	{ 'Serie'																, .T. }, ; //X3_TITSPA
	{ 'Series'																, .T. }, ; //X3_TITENG
	{ 'Serie da Nota Fiscal'												, .T. }, ; //X3_DESCRIC
	{ 'Serie de la Factura'													, .T. }, ; //X3_DESCSPA
	{ 'Invoice Series'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(144) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '11'																	, .T. }, ; //X3_ORDEM
	{ 'DT_CNPJ'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'CNPJ For/Cli'														, .T. }, ; //X3_TITULO
	{ 'CNPJ For/Cli'														, .T. }, ; //X3_TITSPA
	{ 'CNPJ For/Cli'														, .T. }, ; //X3_TITENG
	{ 'CNPJ For/Cli'														, .T. }, ; //X3_DESCRIC
	{ 'CNPJ For/Cli'														, .T. }, ; //X3_DESCSPA
	{ 'CNPJ For/Cli'														, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '12'																	, .T. }, ; //X3_ORDEM
	{ 'DT_QUANT'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 11																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Quantidade'															, .T. }, ; //X3_TITULO
	{ 'Cantidad'															, .T. }, ; //X3_TITSPA
	{ 'Quantity'															, .T. }, ; //X3_TITENG
	{ 'Quantidade do Produto'												, .T. }, ; //X3_DESCRIC
	{ 'Cantidad del Producto'												, .T. }, ; //X3_DESCSPA
	{ 'Product Quantity'													, .T. }, ; //X3_DESCENG
	{ '@E 99999999.99'														, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '13'																	, .T. }, ; //X3_ORDEM
	{ 'DT_VUNIT'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Unitario'														, .T. }, ; //X3_TITULO
	{ 'Valor Unit.'															, .T. }, ; //X3_TITSPA
	{ 'Unit Value'															, .T. }, ; //X3_TITENG
	{ 'Valor Unitario'														, .T. }, ; //X3_DESCRIC
	{ 'Valor Unitario'														, .T. }, ; //X3_DESCSPA
	{ 'Unit Value'															, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(155) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '14'																	, .T. }, ; //X3_ORDEM
	{ 'DT_TOTAL'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Total'															, .T. }, ; //X3_TITULO
	{ 'Valor Total'															, .T. }, ; //X3_TITSPA
	{ 'Grand Total'															, .T. }, ; //X3_TITENG
	{ 'Valor Total'															, .T. }, ; //X3_DESCRIC
	{ 'Valor Total'															, .T. }, ; //X3_DESCSPA
	{ 'Grand Total'															, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(155) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '15'																	, .T. }, ; //X3_ORDEM
	{ 'DT_PEDIDO'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Num. Pedido'															, .T. }, ; //X3_TITULO
	{ 'Num. Pedido'															, .T. }, ; //X3_TITSPA
	{ 'Num. Pedido'															, .T. }, ; //X3_TITENG
	{ 'Numero do Pedido Compra'												, .T. }, ; //X3_DESCRIC
	{ 'Numero do Pedido Compra'												, .T. }, ; //X3_DESCSPA
	{ 'Numero do Pedido Compra'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '16'																	, .T. }, ; //X3_ORDEM
	{ 'DT_ITEMPC'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 4																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Item PC'																, .T. }, ; //X3_TITULO
	{ 'Item PC'																, .T. }, ; //X3_TITSPA
	{ 'Item PC'																, .T. }, ; //X3_TITENG
	{ 'Item Pedido de Compra'												, .T. }, ; //X3_DESCRIC
	{ 'Item Pedido de Compra'												, .T. }, ; //X3_DESCSPA
	{ 'Item Pedido de Compra'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '17'																	, .T. }, ; //X3_ORDEM
	{ 'DT_NFORI'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 9																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Docto. Orig.'														, .T. }, ; //X3_TITULO
	{ 'Fact. Orig.'															, .T. }, ; //X3_TITSPA
	{ 'Original Inv'														, .T. }, ; //X3_TITENG
	{ 'Documento Original'													, .T. }, ; //X3_DESCRIC
	{ 'Factura Original'													, .T. }, ; //X3_DESCSPA
	{ 'Original Document'													, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ 'NaoVazio().And. IIF(FindFunction("NFORIValid"),NFORIValid(),A140IValNF())', .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ '018'																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '18'																	, .T. }, ; //X3_ORDEM
	{ 'DT_SERIORI'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 3																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Serie Orig.'															, .T. }, ; //X3_TITULO
	{ 'Serie Orig.'															, .T. }, ; //X3_TITSPA
	{ 'Series'																, .T. }, ; //X3_TITENG
	{ 'Serie do Doc. Original'												, .T. }, ; //X3_DESCRIC
	{ 'Serie del Documento'													, .T. }, ; //X3_DESCSPA
	{ 'Orig. Doc. Series'													, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ 'IIF(FindFunction("NFORIValid"),NFORIValid(),A140IValNF())'			, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '19'																	, .T. }, ; //X3_ORDEM
	{ 'DT_ITEMORI'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 4																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'It.Doc Orig.'														, .T. }, ; //X3_TITULO
	{ 'Item Doc Ori'														, .T. }, ; //X3_TITSPA
	{ 'Item'																, .T. }, ; //X3_TITENG
	{ 'Item do Docto. de Origem'											, .T. }, ; //X3_DESCRIC
	{ 'Item Documento de Origem'											, .T. }, ; //X3_DESCSPA
	{ 'Item of Origin Document'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '20'																	, .T. }, ; //X3_ORDEM
	{ 'DT_VALFRE'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Frete'															, .T. }, ; //X3_TITULO
	{ 'Valor Flete'															, .T. }, ; //X3_TITSPA
	{ 'Freight Val.'														, .T. }, ; //X3_TITENG
	{ 'Valor do frete'														, .T. }, ; //X3_DESCRIC
	{ 'Valor del Flete'														, .T. }, ; //X3_DESCSPA
	{ 'Freight Value'														, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '21'																	, .T. }, ; //X3_ORDEM
	{ 'DT_SEGURO'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Seguro'															, .T. }, ; //X3_TITULO
	{ 'Seguro'																, .T. }, ; //X3_TITSPA
	{ 'Insurance'															, .T. }, ; //X3_TITENG
	{ 'Vlr.Seguro'															, .T. }, ; //X3_DESCRIC
	{ 'Valor del Seguro'													, .T. }, ; //X3_DESCSPA
	{ 'Insurance Value'														, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '22'																	, .T. }, ; //X3_ORDEM
	{ 'DT_DESPESA'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr.Despesas'														, .T. }, ; //X3_TITULO
	{ 'Valor Gastos'														, .T. }, ; //X3_TITSPA
	{ 'Expen.Am.'															, .T. }, ; //X3_TITENG
	{ 'Valor das despesas'													, .T. }, ; //X3_DESCRIC
	{ 'Valor de los Gastos'													, .T. }, ; //X3_DESCSPA
	{ 'Expense Amount'														, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '23'																	, .T. }, ; //X3_ORDEM
	{ 'DT_VALDESC'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Desconto'															, .T. }, ; //X3_TITULO
	{ 'Descuento'															, .T. }, ; //X3_TITSPA
	{ 'Discount'															, .T. }, ; //X3_TITENG
	{ 'Valor do Desconto no Item'											, .T. }, ; //X3_DESCRIC
	{ 'Valor del Descuento Item'											, .T. }, ; //X3_DESCSPA
	{ 'Item Discount Value'													, .T. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '24'																	, .T. }, ; //X3_ORDEM
	{ 'DT_PICM'																, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 5																		, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Aliq. ICMS'															, .T. }, ; //X3_TITULO
	{ 'Alic. ICMS'															, .T. }, ; //X3_TITSPA
	{ 'ICMS Percent'														, .T. }, ; //X3_TITENG
	{ 'Aliquota de ICMS'													, .T. }, ; //X3_DESCRIC
	{ 'Alicuota de ICMS'													, .T. }, ; //X3_DESCSPA
	{ 'ICMS Percentage'														, .T. }, ; //X3_DESCENG
	{ '@E 99.99'															, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(32)						, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '25'																	, .T. }, ; //X3_ORDEM
	{ 'DT_TPIMP'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 1																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Tp. doc. imp'														, .T. }, ; //X3_TITULO
	{ 'Tp. doc. imp'														, .T. }, ; //X3_TITSPA
	{ 'Imp.Doc.Tp.'															, .T. }, ; //X3_TITENG
	{ 'Tipo documento importação'											, .T. }, ; //X3_DESCRIC
	{ 'Tipo documento importacio'											, .T. }, ; //X3_DESCSPA
	{ 'Import document type'												, .T. }, ; //X3_DESCENG
	{ '9'																	, .T. }, ; //X3_PICTURE
	{ "Pertence('01')"														, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ '0=Declaraçao de importaçao;1=Declaraçao simplificada de importaçao'		, .T. }, ; //X3_CBOX
	{ '0=Declaracion de importacion;1=Declaracion simplificada de importacion'	, .T. }, ; //X3_CBOXSPA
	{ '0=Import statement;1=Simplified import statement'					, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '26'																	, .T. }, ; //X3_ORDEM
	{ 'DT_BSPIS'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Base PIS'															, .T. }, ; //X3_TITULO
	{ 'Base PIS'															, .T. }, ; //X3_TITSPA
	{ 'PIS Basis'															, .T. }, ; //X3_TITENG
	{ 'Base PIS importação'													, .T. }, ; //X3_DESCRIC
	{ 'Base PIS importacion'												, .T. }, ; //X3_DESCSPA
	{ 'Import PIS Basis'													, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '27'																	, .T. }, ; //X3_ORDEM
	{ 'DT_NDI'																, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 12																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'No. da DI/DA'														, .T. }, ; //X3_TITULO
	{ 'No. DI/DA'															, .T. }, ; //X3_TITSPA
	{ 'DI/DA No'															, .T. }, ; //X3_TITENG
	{ 'No. da DI/DA'														, .T. }, ; //X3_DESCRIC
	{ 'No. de la DI/DA'														, .T. }, ; //X3_DESCSPA
	{ 'DI/DA No'															, .T. }, ; //X3_DESCENG
	{ '@R 99.99999999-99'													, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '28'																	, .T. }, ; //X3_ORDEM
	{ 'DT_ALPIS'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 5																		, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Alíq. PIS'															, .T. }, ; //X3_TITULO
	{ 'Alic. PIS'															, .T. }, ; //X3_TITSPA
	{ 'PIS Rate'															, .T. }, ; //X3_TITENG
	{ 'Alíquota PIS importação'												, .T. }, ; //X3_DESCRIC
	{ 'Alicuota PIS importacion'											, .T. }, ; //X3_DESCSPA
	{ 'Import PIS Rate'														, .T. }, ; //X3_DESCENG
	{ '@E 99.99'															, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '29'																	, .T. }, ; //X3_ORDEM
	{ 'DT_VLPIS'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Val. PIS'															, .T. }, ; //X3_TITULO
	{ 'Val. PIS'															, .T. }, ; //X3_TITSPA
	{ 'PIS Value'															, .T. }, ; //X3_TITENG
	{ 'Valor PIS importação'												, .T. }, ; //X3_DESCRIC
	{ 'Valor PIS importacion'												, .T. }, ; //X3_DESCSPA
	{ 'Import PIS Value'													, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '30'																	, .T. }, ; //X3_ORDEM
	{ 'DT_BSCOF'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Base Cofins'															, .T. }, ; //X3_TITULO
	{ 'Base COFINS'															, .T. }, ; //X3_TITSPA
	{ 'COFINS Basis'														, .T. }, ; //X3_TITENG
	{ 'Base Cofins importação'												, .T. }, ; //X3_DESCRIC
	{ 'Base COFINS importacion'												, .T. }, ; //X3_DESCSPA
	{ 'Import COFINS Basis'													, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '31'																	, .T. }, ; //X3_ORDEM
	{ 'DT_ALCOF'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 5																		, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Alíq. Cofins'														, .T. }, ; //X3_TITULO
	{ 'Alic. COFINS'														, .T. }, ; //X3_TITSPA
	{ 'COFINS Rate'															, .T. }, ; //X3_TITENG
	{ 'Alíquota Cofins importa.'											, .T. }, ; //X3_DESCRIC
	{ 'Alicuota COFINS import.'												, .T. }, ; //X3_DESCSPA
	{ 'Import COFINS Rate'													, .T. }, ; //X3_DESCENG
	{ '@E 99.99'															, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '32'																	, .T. }, ; //X3_ORDEM
	{ 'DT_VLCOF'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 14																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Val. Cofins'															, .T. }, ; //X3_TITULO
	{ 'Val. COFINS'															, .T. }, ; //X3_TITSPA
	{ 'COFINS Value'														, .T. }, ; //X3_TITENG
	{ 'Valor Cofins importação'												, .T. }, ; //X3_DESCRIC
	{ 'Valor COFINS importacion'											, .T. }, ; //X3_DESCSPA
	{ 'Import COFINS Value'													, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(158) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '33'																	, .T. }, ; //X3_ORDEM
	{ 'DT_LOCDES'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 30																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Descr.Local'															, .T. }, ; //X3_TITULO
	{ 'Descr.Local'															, .T. }, ; //X3_TITSPA
	{ 'Loc. Desc.'															, .T. }, ; //X3_TITENG
	{ 'Descricao do Local'													, .T. }, ; //X3_DESCRIC
	{ 'Descripcion del Local'												, .T. }, ; //X3_DESCSPA
	{ 'Location Description'												, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '34'																	, .T. }, ; //X3_ORDEM
	{ 'DT_UFDES'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 2																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'UF Desembara'														, .T. }, ; //X3_TITULO
	{ 'Est Despacho'														, .T. }, ; //X3_TITSPA
	{ 'Clear. Sate'															, .T. }, ; //X3_TITENG
	{ 'UF do Desembaraco'													, .T. }, ; //X3_DESCRIC
	{ 'Estado del Despacho'													, .T. }, ; //X3_DESCSPA
	{ 'Clearance State'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ ''																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ ''																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '35'																	, .T. }, ; //X3_ORDEM
	{ 'DT_DTDI'																, .T. }, ; //X3_CAMPO
	{ 'D'																	, .T. }, ; //X3_TIPO
	{ 8																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Registro DI'															, .T. }, ; //X3_TITULO
	{ 'Registro DI'															, .T. }, ; //X3_TITSPA
	{ 'DI Record'															, .T. }, ; //X3_TITENG
	{ 'Registro D.I.'														, .T. }, ; //X3_DESCRIC
	{ 'Registro D.I.'														, .T. }, ; //X3_DESCSPA
	{ 'DI Record'															, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '36'																	, .T. }, ; //X3_ORDEM
	{ 'DT_DTDES'															, .T. }, ; //X3_CAMPO
	{ 'D'																	, .T. }, ; //X3_TIPO
	{ 8																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Dt Desembar.'														, .T. }, ; //X3_TITULO
	{ 'Fch Despacho'														, .T. }, ; //X3_TITSPA
	{ 'Clear. Date'															, .T. }, ; //X3_TITENG
	{ 'Dt.Desembar.'														, .T. }, ; //X3_DESCRIC
	{ 'Fch.Despacho'														, .T. }, ; //X3_DESCSPA
	{ 'Clearance Date'														, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '37'																	, .T. }, ; //X3_ORDEM
	{ 'DT_CODEXP'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 6																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Exportador'															, .T. }, ; //X3_TITULO
	{ 'Exportador'															, .T. }, ; //X3_TITSPA
	{ 'Exporter'															, .T. }, ; //X3_TITENG
	{ 'Cod Exportador'														, .T. }, ; //X3_DESCRIC
	{ 'Cod.Exportador'														, .T. }, ; //X3_DESCSPA
	{ 'Exporter Code'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''		                                            				, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ 'SA2'																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(150) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ 'S'																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '38'																	, .T. }, ; //X3_ORDEM
	{ 'DT_NADIC'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 3																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Adicao'																, .T. }, ; //X3_TITULO
	{ 'Adicion'																, .T. }, ; //X3_TITSPA
	{ 'Addition'															, .T. }, ; //X3_TITENG
	{ 'Adicao'																, .T. }, ; //X3_DESCRIC
	{ 'Adicao'																, .T. }, ; //X3_DESCSPA
	{ 'Adicao'																, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '39'																	, .T. }, ; //X3_ORDEM
	{ 'DT_SQADIC'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 3																		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Seq Adicao'															, .T. }, ; //X3_TITULO
	{ 'Sec Suma'															, .T. }, ; //X3_TITSPA
	{ 'Addition Seq'														, .T. }, ; //X3_TITENG
	{ 'Seq Adicao'															, .T. }, ; //X3_DESCRIC
	{ 'Sec Suma'															, .T. }, ; //X3_DESCSPA
	{ 'Addition Sequence'													, .T. }, ; //X3_DESCENG
	{ '999'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '40'																	, .T. }, ; //X3_ORDEM
	{ 'DT_BCIMP'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 15																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr BC Impor'														, .T. }, ; //X3_TITULO
	{ 'Vlr BC Impor'														, .T. }, ; //X3_TITSPA
	{ 'ImportBCAmt'															, .T. }, ; //X3_TITENG
	{ 'Vlr BC Importacao'													, .T. }, ; //X3_DESCRIC
	{ 'Vlr.BC Importación'													, .T. }, ; //X3_DESCSPA
	{ 'Import BC Amount'													, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ '0'																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '41'																	, .T. }, ; //X3_ORDEM
	{ 'DT_VDESDI'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 15																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr Desconto'														, .T. }, ; //X3_TITULO
	{ 'Vlr Descuent'														, .T. }, ; //X3_TITSPA
	{ 'Discount Vl.'														, .T. }, ; //X3_TITENG
	{ 'Valor Desconto'														, .T. }, ; //X3_DESCRIC
	{ 'Valor Descuento'														, .T. }, ; //X3_DESCSPA
	{ 'Discount Value'														, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '42'																	, .T. }, ; //X3_ORDEM
	{ 'DT_DSPAD'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 15																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr Desp.Adu'														, .T. }, ; //X3_TITULO
	{ 'Vlr Gast.Adu'														, .T. }, ; //X3_TITSPA
	{ 'CustmExpAmt'															, .T. }, ; //X3_TITENG
	{ 'Vlr Desp.Aduaneira'													, .T. }, ; //X3_DESCRIC
	{ 'Vlr.gasto aduanero'													, .T. }, ; //X3_DESCSPA
	{ 'CustomsExpenseAmount'												, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '43'																	, .T. }, ; //X3_ORDEM
	{ 'DT_VLRII'															, .T. }, ; //X3_CAMPO
	{ 'N'																	, .T. }, ; //X3_TIPO
	{ 15																	, .T. }, ; //X3_TAMANHO
	{ 2																		, .T. }, ; //X3_DECIMAL
	{ 'Vlr Imp.Impo'														, .T. }, ; //X3_TITULO
	{ 'Vlr Imp.Impo'														, .T. }, ; //X3_TITSPA
	{ 'ImpoImpAmt'															, .T. }, ; //X3_TITENG
	{ 'Vlr Imp.Importacao'													, .T. }, ; //X3_DESCRIC
	{ 'Vlr Imp.Importación'													, .T. }, ; //X3_DESCSPA
	{ 'Import Imp. Amount'													, .T. }, ; //X3_DESCENG
	{ '@E 999,999,999,999.99'												, .T. }, ; //X3_PICTURE
	{ 'Positivo()'															, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ ''																	, .T. }, ; //X3_PROPRI
	{ ''																	, .T. }, ; //X3_BROWSE
	{ ''																	, .T. }, ; //X3_VISUAL
	{ ''																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ 'N'																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .T. }, ; //X3_ARQUIVO
	{ '44'																	, .T. }, ; //X3_ORDEM
	{ 'DT_ORIGIN'															, .T. }, ; //X3_CAMPO
	{ 'C'																	, .T. }, ; //X3_TIPO
	{ 1																  		, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Reg.Original'														, .T. }, ; //X3_TITULO
	{ 'Reg.Original'														, .T. }, ; //X3_TITSPA
	{ 'Reg.Original'														, .T. }, ; //X3_TITENG
	{ 'Reg.Original'														, .T. }, ; //X3_DESCRIC
	{ 'Reg.Original'														, .T. }, ; //X3_DESCSPA
	{ 'Reg.Original'														, .T. }, ; //X3_DESCENG
	{ '@!'																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 1																		, .T. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'S'																	, .T. }, ; //X3_PROPRI
	{ 'N'																	, .T. }, ; //X3_BROWSE
	{ 'A'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ '1'																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ 'S'																	, .T. }} ) //X3_PYME


// Atualizando dicionário
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
					lTodosSim := .T.
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
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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

// Tabela SDS
aAdd( aSIX, { ;
	'SDS'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'DS_FILIAL+DS_DOC+DS_SERIE+DS_FORNEC+DS_LOJA'							, ; //CHAVE
	'Num. Doc + Serie + Forn/Cliente + Loja'								, ; //DESCRICAO
	'Num. Doc + Serie + Prov/Client + Tienda'								, ; //DESCSPA
	'Doc.No. + Seires + Sup/Client + Store'									, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SDS'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'DS_FILIAL+DS_CHAVENF'													, ; //CHAVE
	'Chave Acess.'															, ; //DESCRICAO
	'Clave Acces'															, ; //DESCSPA
	'Access Key'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SDS'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'DS_FILIAL+DS_XMLDOC+DS_XMLSER+DS_FORNEC+DS_LOJA'						, ; //CHAVE
	'Doc XML Imp+Serie XML Im+Forn/Cliente+Loja'							, ; //DESCRICAO
	'Doc XML Imp+Serie XML Im+Prov/Cliente+Tienda'							, ; //DESCSPA
	'Doc XML Imp+Serie XML Im+Prov/Cliente+Tienda'							, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

// Tabela SDT
aAdd( aSIX, { ;
	'SDT'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'DT_FILIAL+DT_CNPJ+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE'					, ; //CHAVE
	'CNPJ For/Cli + Forn/Cliente + loja + Documento + Serie'				, ; //DESCRICAO
	'CNPJ Prov/Cl + Prov/Clien + Tienda + Documento + Serie'				, ; //DESCSPA
	'Sup/Cli CNPJ + Supp/Custm. + Unit + Document + Series'					, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SDT'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_PRODFOR'				, ; //CHAVE
	'Forn/Cliente + loja + Documento + Serie + Prd. For/Cli'				, ; //DESCRICAO
	'Prov/Clien + Tienda + Documento + Serie + Prd. Prov/Cl'				, ; //DESCSPA
	'Supp/Custm. + Unit + Document + Series + Sup/Cli Prd.'					, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SDT'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_COD'					, ; //CHAVE
	'Forn/Cliente + loja + Documento + Serie + Produto'						, ; //DESCRICAO
	'Prov/Clien + Tienda + Documento + Serie + Producto'					, ; //DESCSPA
	'Supp/Custm. + Unit + Document + Series + Product'						, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SDT'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'DT_FILIAL+DT_PEDIDO+DT_ITEMPC'											, ; //CHAVE
	'Numero PC+Item'														, ; //DESCRICAO
	'Nr.PedCompra+Item'														, ; //DESCSPA
	'PO Number+Item'														, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SDT'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_COD+DT_ITEM'			, ; //CHAVE
	'Forn/Cliente + loja + Documento + Serie + Produto + Item'				, ; //DESCRICAO
	'Forn/Cliente + loja + Documento + Serie + Produto + Item'				, ; //DESCSPA
	'Forn/Cliente + loja + Documento + Serie + Produto + Item'				, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ 

// Atualizando dicionário
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
/*/{Protheus.doc} FSAtuSX6
Função de processamento da gravação do SX6 - Parâmetros

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6()
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

AutoGrLog( "Ínicio da Atualização" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_BDOWNFE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Cabecalho da requisicao para chamada do WebService'					, ; //X6_DESCRIC
	'Cabecalho da requisicao para chamada do WebService'					, ; //X6_DSCSPA
	'Cabecalho da requisicao para chamada do WebService'					, ; //X6_DSCENG
	'que realiza o download do XML da NFe.'									, ; //X6_DESC1
	'que realiza o download do XML da NFe.'									, ; //X6_DSCSPA1
	'que realiza o download do XML da NFe.'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'<downloadNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'	, ; //X6_CONTEUD
	'<downloadNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'	, ; //X6_CONTSPA
	'<downloadNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_BEVECHV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Cabecalho da requisicao do XML enviado para a SEFA'					, ; //X6_DESCRIC
	'Cabecalho da requisicao do XML enviado para a SEFA'					, ; //X6_DSCSPA
	'Cabecalho da requisicao do XML enviado para a SEFA'					, ; //X6_DSCENG
	'Z para a realizacao do manifesto do destinatario.'						, ; //X6_DESC1
	'Z para a realizacao do manifesto do destinatario.'						, ; //X6_DSCSPA1
	'Z para a realizacao do manifesto do destinatario.'						, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'<envEvento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'		, ; //X6_CONTEUD
	'<envEvento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'		, ; //X6_CONTSPA
	'<envEvento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_BNFECHV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Cabecalho do xml a ser enviado para o WebService'						, ; //X6_DESCRIC
	'Cabecalho do xml a ser enviado para o WebService'						, ; //X6_DSCSPA
	'Cabecalho do xml a ser enviado para o WebService'						, ; //X6_DSCENG
	'da SEFAZ nfeDistDFeInteresse, responsavel por capt'					, ; //X6_DESC1
	'da SEFAZ nfeDistDFeInteresse, responsavel por capt'					, ; //X6_DSCSPA1
	'da SEFAZ nfeDistDFeInteresse, responsavel por capt'					, ; //X6_DSCENG1
	'urar as chaves das NFe s.'												, ; //X6_DESC2
	'urar as chaves das NFe s.'												, ; //X6_DSCSPA2
	'urar as chaves das NFe s.'												, ; //X6_DSCENG2
	'<distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'		, ; //X6_CONTEUD
	'<distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'		, ; //X6_CONTSPA
	'<distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_CODCIEN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigos de Evento que serao contemplados pela roti'					, ; //X6_DESCRIC
	'Codigos de Evento que serao contemplados pela roti'					, ; //X6_DSCSPA
	'Codigos de Evento que serao contemplados pela roti'					, ; //X6_DSCENG
	'na. WebService que realiza o manifesto da nota'						, ; //X6_DESC1
	'na. WebService que realiza o manifesto da nota'						, ; //X6_DSCSPA1
	'na. WebService que realiza o manifesto da nota'						, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'210210|'																, ; //X6_CONTEUD
	'210210|'																, ; //X6_CONTSPA
	'210210|'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_DESCIEN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Descricao dos Eventos contemplados pela rotina que'					, ; //X6_DESCRIC
	'Descricao dos Eventos contemplados pela rotina que'					, ; //X6_DSCSPA
	'Descricao dos Eventos contemplados pela rotina que'					, ; //X6_DSCENG
	'realizam o manifesto do destinatario junto a SEFA'						, ; //X6_DESC1
	'realizam o manifesto do destinatario junto a SEFA'						, ; //X6_DSCSPA1
	'realizam o manifesto do destinatario junto a SEFA'						, ; //X6_DSCENG1
	'Z.'																	, ; //X6_DESC2
	'Z.'																	, ; //X6_DSCSPA2
	'Z.'																	, ; //X6_DSCENG2
	'Ciencia da Operacao|'													, ; //X6_CONTEUD
	'Ciencia da Operacao|'													, ; //X6_CONTSPA
	'Ciencia da Operacao|'													, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_EDOWNFE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Rodape da requisicao que realiza o download do XML'					, ; //X6_DESCRIC
	'Rodape da requisicao que realiza o download do XML'					, ; //X6_DSCSPA
	'Rodape da requisicao que realiza o download do XML'					, ; //X6_DSCENG
	'da NFe'																, ; //X6_DESC1
	'da NFe'																, ; //X6_DSCSPA1
	'da NFe'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'</downloadNFe>'														, ; //X6_CONTEUD
	'</downloadNFe>'														, ; //X6_CONTSPA
	'</downloadNFe>'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_EEVECHV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Rodape da requisicao do XML enviado para a SEFAZ p'					, ; //X6_DESCRIC
	'Rodape da requisicao do XML enviado para a SEFAZ p'					, ; //X6_DSCSPA
	'Rodape da requisicao do XML enviado para a SEFAZ p'					, ; //X6_DSCENG
	'ara a realizacao do manifesto do destinatario.'						, ; //X6_DESC1
	'ara a realizacao do manifesto do destinatario.'						, ; //X6_DSCSPA1
	'ara a realizacao do manifesto do destinatario.'						, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'</envEvento>'															, ; //X6_CONTEUD
	'</envEvento>'															, ; //X6_CONTSPA
	'</envEvento>'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_ENFECHV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Rodape do xml a ser enviado para o WebService da S'					, ; //X6_DESCRIC
	'Rodape do xml a ser enviado para o WebService da S'					, ; //X6_DSCSPA
	'Rodape do xml a ser enviado para o WebService da S'					, ; //X6_DSCENG
	'EFAZ nfeDistDFeInteresse, responsavel por capturar'					, ; //X6_DESC1
	'EFAZ nfeDistDFeInteresse, responsavel por capturar'					, ; //X6_DSCSPA1
	'EFAZ nfeDistDFeInteresse, responsavel por capturar'					, ; //X6_DSCENG1
	'as chaves das NFe s.'													, ; //X6_DESC2
	'as chaves das NFe s.'													, ; //X6_DSCSPA2
	'as chaves das NFe s.'													, ; //X6_DSCENG2
	'</distDFeInt>'															, ; //X6_CONTEUD
	'</distDFeInt>'															, ; //X6_CONTSPA
	'</distDFeInt>'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_ENVSTAT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Status de retorno da SEFAZ validos para retorno.'						, ; //X6_DESCRIC
	'Status de retorno da SEFAZ validos para retorno.'						, ; //X6_DSCSPA
	'Status de retorno da SEFAZ validos para retorno.'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'128|135|136'															, ; //X6_CONTEUD
	'128|135|136'															, ; //X6_CONTSPA
	'128|135|136'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_HSM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parametro que verifica se utiliza HSM para assinat'					, ; //X6_DESCRIC
	'Parametro que verifica se utiliza HSM para assinat'					, ; //X6_DSCSPA
	'Parametro que verifica se utiliza HSM para assinat'					, ; //X6_DSCENG
	'ura do XML'															, ; //X6_DESC1
	'ura do XML'															, ; //X6_DSCSPA1
	'ura do XML'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_HSMLABE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Utilizado apenas caso seja utilizado HSM para a as'					, ; //X6_DESCRIC
	'Utilizado apenas caso seja utilizado HSM para a as'					, ; //X6_DSCSPA
	'Utilizado apenas caso seja utilizado HSM para a as'					, ; //X6_DSCENG
	'sinatura do XML.'														, ; //X6_DESC1
	'sinatura do XML.'														, ; //X6_DSCSPA1
	'sinatura do XML.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_HSMSLOT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Utilizado apenas caso haja necessidade de HSM para'					, ; //X6_DESCRIC
	'Utilizado apenas caso haja necessidade de HSM para'					, ; //X6_DSCSPA
	'Utilizado apenas caso haja necessidade de HSM para'					, ; //X6_DSCENG
	'a assinatura do XML.'													, ; //X6_DESC1
	'a assinatura do XML.'													, ; //X6_DSCSPA1
	'a assinatura do XML.'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_IMPSCH'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Schema resposta da Sefaz para verificar o evento d'					, ; //X6_DESCRIC
	'Schema resposta da Sefaz para verificar o evento d'					, ; //X6_DSCSPA
	'Schema resposta da Sefaz para verificar o evento d'					, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd'								, ; //X6_CONTEUD
	'resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd'								, ; //X6_CONTSPA
	'resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd'								, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_KEYLABE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Utilizado apenas caso seja utilizado HSM para a as'					, ; //X6_DESCRIC
	'Utilizado apenas caso seja utilizado HSM para a as'					, ; //X6_DSCSPA
	'Utilizado apenas caso seja utilizado HSM para a as'					, ; //X6_DSCENG
	'sinatura do XML.'														, ; //X6_DESC1
	'sinatura do XML.'														, ; //X6_DSCSPA1
	'sinatura do XML.'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_LIBSPED'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se Limpa DS_STATUS quando todos os itens da'					, ; //X6_DESCRIC
	'Indica se Limpa DS_STATUS quando todos os itens da'					, ; //X6_DSCSPA
	'Indica se Limpa DS_STATUS quando todos os itens da'					, ; //X6_DSCENG
	'amarração Fornecedor x Produto e não tem ponto de'						, ; //X6_DESC1
	'amarração Fornecedor x Produto e não tem ponto de'						, ; //X6_DSCSPA1
	'amarração Fornecedor x Produto e não tem ponto de'						, ; //X6_DSCENG1
	'entrada para amarração do Pedido Compras'								, ; //X6_DESC2
	'entrada para amarração do Pedido Compras'								, ; //X6_DSCSPA2
	'entrada para amarração do Pedido Compras'								, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_LIMSEF'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Limite de dias para baixar Documentos da Sefaz'						, ; //X6_DESCRIC
	'Limite de dias para baixar Documentos da Sefaz'						, ; //X6_DSCSPA
	'Limite de dias para baixar Documentos da Sefaz'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'90'																	, ; //X6_CONTEUD
	'90'																	, ; //X6_CONTSPA
	'90'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_LOTEXML'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Lote XML enviado para o manifesto do destinatario.'					, ; //X6_DESCRIC
	'Lote XML enviado para o manifesto do destinatario.'					, ; //X6_DSCSPA
	'Lote XML enviado para o manifesto do destinatario.'					, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000000000000001'														, ; //X6_CONTEUD
	'000000000000001'														, ; //X6_CONTSPA
	'000000000000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_ORGAO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Orgao a ser enviado a requisicao para realizar o m'					, ; //X6_DESCRIC
	'Orgao a ser enviado a requisicao para realizar o m'					, ; //X6_DSCSPA
	'Orgao a ser enviado a requisicao para realizar o m'					, ; //X6_DSCENG
	'anifesto do destinatario.'												, ; //X6_DESC1
	'anifesto do destinatario.'												, ; //X6_DSCSPA1
	'anifesto do destinatario.'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'91'																	, ; //X6_CONTEUD
	'91'																	, ; //X6_CONTSPA
	'91'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_SCHCHV'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Schemas de retorno da SEFAZ onde devem ser realiza'					, ; //X6_DESCRIC
	'Schemas de retorno da SEFAZ onde devem ser realiza'					, ; //X6_DSCSPA
	'Schemas de retorno da SEFAZ onde devem ser realiza'					, ; //X6_DSCENG
	'dos o manifesto do destinatario para realizar o do'					, ; //X6_DESC1
	'dos o manifesto do destinatario para realizar o do'					, ; //X6_DSCSPA1
	'dos o manifesto do destinatario para realizar o do'					, ; //X6_DSCENG1
	'wnload do XML.'														, ; //X6_DESC2
	'wnload do XML.'														, ; //X6_DSCSPA2
	'wnload do XML.'														, ; //X6_DSCENG2
	'resNFe_v1.00.xsd|resEvento_v1.00.xsd'									, ; //X6_CONTEUD
	'resNFe_v1.00.xsd|resEvento_v1.00.xsd'									, ; //X6_CONTSPA
	'resNFe_v1.00.xsd|resEvento_v1.00.xsd'									, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_SEMACHV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nome do arquivo de Semáforo MCOMR01/02/03'								, ; //X6_DESCRIC
	'Nome do arquivo de Semáforo MCOMR01/02/03'								, ; //X6_DSCSPA
	'Nome do arquivo de Semáforo MCOMR01/02/03'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SEMXML'																, ; //X6_CONTEUD
	'SEMXML'																, ; //X6_CONTSPA
	'SEMXML'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_SEQEVEN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sequencia do Evento enviada pelo WebService.'							, ; //X6_DESCRIC
	'Sequencia do Evento enviada pelo WebService.'							, ; //X6_DSCSPA
	'Sequencia do Evento enviada pelo WebService.'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01'																	, ; //X6_CONTEUD
	'01'																	, ; //X6_CONTSPA
	'01'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_WSCHV'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Instancia da classe utilizada para consumir o meto'					, ; //X6_DESCRIC
	'Instancia da classe utilizada para consumir o meto'					, ; //X6_DSCSPA
	'Instancia da classe utilizada para consumir o meto'					, ; //X6_DSCENG
	'do que captura as chaves das notas emitidas contra'					, ; //X6_DESC1
	'do que captura as chaves das notas emitidas contra'					, ; //X6_DSCSPA1
	'do que captura as chaves das notas emitidas contra'					, ; //X6_DSCENG1
	'o solicitante.'														, ; //X6_DESC2
	'o solicitante.'														, ; //X6_DSCSPA2
	'o solicitante.'														, ; //X6_DSCENG2
	'WSNFeDistribuicaoDFe():New()'											, ; //X6_CONTEUD
	'WSNFeDistribuicaoDFe():New()'											, ; //X6_CONTSPA
	'WSNFeDistribuicaoDFe():New()'											, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_WSEVENT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Instancia do WebService que realiza a ciencia da o'					, ; //X6_DESCRIC
	'Instancia do WebService que realiza a ciencia da o'					, ; //X6_DSCSPA
	'Instancia do WebService que realiza a ciencia da o'					, ; //X6_DSCENG
	'peracao da NFe atraves do WS da SEFAZ.'								, ; //X6_DESC1
	'peracao da NFe atraves do WS da SEFAZ.'								, ; //X6_DSCSPA1
	'peracao da NFe atraves do WS da SEFAZ.'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'WSRecepcaoEvento():New()'												, ; //X6_CONTEUD
	'WSRecepcaoEvento():New()'												, ; //X6_CONTSPA
	'WSRecepcaoEvento():New()'												, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_XMLAMB'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo Ambiente a ser utilizado pelos WebServices da'					, ; //X6_DESCRIC
	'Tipo Ambiente a ser utilizado pelos WebServices da'					, ; //X6_DSCSPA
	'Tipo Ambiente a ser utilizado pelos WebServices da'					, ; //X6_DSCENG
	'SEFAZ. 1=Producao, 2=Homologacao'										, ; //X6_DESC1
	'SEFAZ. 1=Producao, 2=Homologacao'										, ; //X6_DSCSPA1
	'SEFAZ. 1=Producao, 2=Homologacao'										, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_XMLNSU'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero do ultimo numero sequencial unico(NSU) impo'					, ; //X6_DESCRIC
	'Numero do ultimo numero sequencial unico(NSU) impo'					, ; //X6_DSCSPA
	'Numero do ultimo numero sequencial unico(NSU) impo'					, ; //X6_DSCENG
	'rtado pela rotina que realiza o download das chave'					, ; //X6_DESC1
	'rtado pela rotina que realiza o download das chave'					, ; //X6_DSCSPA1
	'rtado pela rotina que realiza o download das chave'					, ; //X6_DSCENG1
	's da NFe.'																, ; //X6_DESC2
	's da NFe.'																, ; //X6_DSCSPA2
	's da NFe.'																, ; //X6_DSCENG2
	'000000000000000'														, ; //X6_CONTEUD
	'000000000000000'														, ; //X6_CONTSPA
	'000000000000000'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_XMLUF'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da Unidade Federal (UF) a ser utilizado pel'					, ; //X6_DESCRIC
	'Codigo da Unidade Federal (UF) a ser utilizado pel'					, ; //X6_DSCSPA
	'Codigo da Unidade Federal (UF) a ser utilizado pel'					, ; //X6_DSCENG
	'os WebServices da SEFAZ.'												, ; //X6_DESC1
	'os WebServices da SEFAZ.'												, ; //X6_DSCSPA1
	'os WebServices da SEFAZ.'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'31'																	, ; //X6_CONTEUD
	'31'																	, ; //X6_CONTSPA
	'31'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_COMCOL2'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica para quais documentos TOTVS Colab. será'						, ; //X6_DESCRIC
	'Indica para cuales documentos TOTVS Colab. se'							, ; //X6_DSCSPA
	'Indicates for which TOTVS Colab. documents the'						, ; //X6_DSCENG
	'processada a geração automática (N=Compra;D=Devol.'					, ; //X6_DESC1
	'procesara la generacion automática (N=Compra;D=Dev'					, ; //X6_DSCSPA1
	'automatic generation will be processed (N=Purchase'					, ; //X6_DSCENG1
	'C=Complemento;O=Bonificação;T=CTe;B=Beneficia.)'						, ; //X6_DESC2
	'C=Complemento;O=Bonificacion;T=CTe;B=Beneficia.)'						, ; //X6_DSCSPA2
	'D=Return;C=Complement;O=Bonus;T=CTe;B=Benefit.)'						, ; //X6_DSCENG2
	'NDCOTB'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'NDCOTB'																, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLCFBN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identifica os CFOPs de venda que serão'								, ; //X6_DESCRIC
	'Identifica los CFOP de venta que seran'								, ; //X6_DSCSPA
	'Identifies the sales CFOPs  that will be'								, ; //X6_DSCENG
	'tratados como beneficiamento na importação'							, ; //X6_DESC1
	'tratados como  beneficio en la importacion'							, ; //X6_DSCSPA1
	'treated as processing in the import'									, ; //X6_DSCENG1
	'dos XML de NFe.'														, ; //X6_DESC2
	'de los XML de Fact-e'													, ; //X6_DSCSPA2
	'of XML of Elec. Invoice.'												, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLCFDV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identifica os CFOPs de venda que serão'								, ; //X6_DESCRIC
	'Identifica los CFOP de venta que seran'								, ; //X6_DSCSPA
	'Identifies the sales CFOPs  that will be'								, ; //X6_DSCENG
	'tratados como devolucao na importação'									, ; //X6_DESC1
	'tratados como devolucion en la importacion'							, ; //X6_DSCSPA1
	'treated as return in the import'										, ; //X6_DSCENG1
	'dos XML de NFe.'														, ; //X6_DESC2
	'de los XML de Fact-e.'													, ; //X6_DSCSPA2
	'of XML of Elec. Invoice.'												, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLCFPC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identifica os CFOPs de venda que serão'								, ; //X6_DESCRIC
	'Identifica los CFOPs de venta que seran'								, ; //X6_DSCSPA
	'Identifies sales CFOPs to be'											, ; //X6_DSCENG
	'tratados como bonificação na importação'								, ; //X6_DESC1
	'tratados como bonificacion en la importacion'							, ; //X6_DSCSPA1
	'considered as bonus in'												, ; //X6_DSCENG1
	'dos XML de NFe.'														, ; //X6_DESC2
	'de los XML de e-Fact.'													, ; //X6_DSCSPA2
	'NFe XML import.'														, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLCPCT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identifica o código da cond. de pagto que'								, ; //X6_DESCRIC
	'Identifica el codigo del producto de flete que'						, ; //X6_DSCSPA
	'Identifies the freight product code to be used'						, ; //X6_DSCENG
	'será utilizada na geração de documentos'								, ; //X6_DESC1
	'se utilizara en la generacion de documentos'							, ; //X6_DSCSPA1
	'to generate documents of'												, ; //X6_DSCENG1
	'de transporte via TOTVS Colaboração.'									, ; //X6_DESC2
	'de transporte via TOTVS Colaboracion.'									, ; //X6_DSCSPA2
	'transportation via TOTVS Collaboration.'								, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLPASM'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Senha do Email XML'													, ; //X6_DESCRIC
	'Senha do Email XML'													, ; //X6_DSCSPA
	'Senha do Email XML'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLPFCT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identifica o código do produto de frete que'							, ; //X6_DESCRIC
	'Identifica el codigo del producto de flete que'						, ; //X6_DSCSPA
	'Identifies the freight product code to be used'						, ; //X6_DSCENG
	'será utilizado na geração de documentos de'							, ; //X6_DESC1
	'se utilizara en la generacion de documentos de'						, ; //X6_DSCSPA1
	'to generate documents of'												, ; //X6_DSCENG1
	'transporte via TOTVS Colaboração.'										, ; //X6_DESC2
	'transporte via TOTVS Colaboracion.'									, ; //X6_DSCSPA2
	'transportation via TOTVS Collaboration.'								, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLPOP'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco do servidor POP3'												, ; //X6_DESCRIC
	'Endereco do servidor POP3'												, ; //X6_DSCSPA
	'Endereco do servidor POP3'												, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLPORP'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Porta do servidor POP'													, ; //X6_DESCRIC
	'Porta do servidor POP'													, ; //X6_DSCSPA
	'Porta do servidor POP'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLPORS'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Porta do servidor SMTP'												, ; //X6_DESCRIC
	'Porta do servidor SMTP'												, ; //X6_DSCSPA
	'Porta do servidor SMTP'												, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLPXF'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Validação se a rotina de importação de xml'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Importar produto sem fornecedor'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLSSL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Usa SSL Seguro'														, ; //X6_DESCRIC
	'Usa SSL Seguro'														, ; //X6_DSCSPA
	'Usa SSL Seguro'														, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLTECT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identifica o tipo de entrada que deve ser'								, ; //X6_DESCRIC
	'Identifica el tipo de entrada que debe'								, ; //X6_DSCSPA
	'Identifies the inflow type to be used'									, ; //X6_DSCENG
	'utilizado para geração de documentos de'								, ; //X6_DESC1
	'utilizarse para generacion de documentos de'							, ; //X6_DSCSPA1
	'to generate documents of'												, ; //X6_DSCENG1
	'transporte via TOTVS Colaboração.'										, ; //X6_DESC2
	'transporte via TOTVS Colaboracion.'									, ; //X6_DSCSPA2
	'transportation via TOTVS Collaboration.'								, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLTIME'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Timeout SMTP'															, ; //X6_DESCRIC
	'Timeout SMTP'															, ; //X6_DSCSPA
	'Timeout SMTP'															, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'60'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLUSRM'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Usuario que ira realizar a autenticação'								, ; //X6_DESCRIC
	'Usuario que ira realizar a autenticação'								, ; //X6_DSCSPA
	'Usuario que ira realizar a autenticação'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLVPRO'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Alteração do produto ja apto a gerar pre nota'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	''																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'0'																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0050101'																, ; //X6_FIL
	'ES_XMLNSU'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero do ultimo numero sequencial unico(NSU) impo'					, ; //X6_DESCRIC
	'Numero do ultimo numero sequencial unico(NSU) impo'					, ; //X6_DSCSPA
	'Numero do ultimo numero sequencial unico(NSU) impo'					, ; //X6_DSCENG
	'rtado pela rotina que realiza o download das chave'					, ; //X6_DESC1
	'rtado pela rotina que realiza o download das chave'					, ; //X6_DSCSPA1
	'rtado pela rotina que realiza o download das chave'					, ; //X6_DSCENG1
	's da NFe.'																, ; //X6_DESC2
	's da NFe.'																, ; //X6_DSCSPA2
	's da NFe.'																, ; //X6_DSCENG2
	'000000000000000'														, ; //X6_CONTEUD
	'000000000000000'														, ; //X6_CONTSPA
	'000000000000000'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0050101'																, ; //X6_FIL
	'ES_XMLUF'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da Unidade Federal (UF) a ser utilizado pel'					, ; //X6_DESCRIC
	'Codigo da Unidade Federal (UF) a ser utilizado pel'					, ; //X6_DSCSPA
	'Codigo da Unidade Federal (UF) a ser utilizado pel'					, ; //X6_DSCENG
	'os WebServices da SEFAZ.'												, ; //X6_DESC1
	'os WebServices da SEFAZ.'												, ; //X6_DSCSPA1
	'os WebServices da SEFAZ.'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'29'																	, ; //X6_CONTEUD
	'31'																	, ; //X6_CONTSPA
	'31'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
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
		AutoGrLog( "Foi incluído o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]" )
	Else
		lContinua := .T.
		lReclock  := .F.
		If !StrTran( SX6->X6_CONTEUD, " ", "" ) == StrTran( aSX6[nI][13], " ", "" )

			cMsg := "O parâmetro " + aSX6[nI][2] + " está com o conteúdo" + CRLF + ;
			"[" + RTrim( StrTran( SX6->X6_CONTEUD, " ", "" ) ) + "]" + CRLF + ;
			", que é será substituido pelo NOVO conteúdo " + CRLF + ;
			"[" + RTrim( StrTran( aSX6[nI][13]   , " ", "" ) ) + "]" + CRLF + ;
			"Deseja substituir ? "

			If      lTodosSim
				nOpcA := 1
			ElseIf  lTodosNao
				nOpcA := 2
			Else
				nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SX6" )
				lTodosSim := ( nOpcA == 3 )
				lTodosNao := ( nOpcA == 4 )

				If lTodosSim
					nOpcA := 1
					lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SX6 e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
				EndIf

				If lTodosNao
					nOpcA := 2
					lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SX6 que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
				EndIf

			EndIf

			lContinua := ( nOpcA == 1 )

			If lContinua
				AutoGrLog( "Foi alterado o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " de [" + ;
				AllTrim( SX6->X6_CONTEUD ) + "]" + " para [" + AllTrim( aSX6[nI][13] ) + "]" )
			EndIf

		Else
			lContinua := .F.
		EndIf
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

AutoGrLog( CRLF + "Final da Atualização" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXB
Função de processamento da gravação do SXB - Consultas Padrao

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXB()

Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SDTCOD","1","01","DB","Produto XML P x F   ","Produto XML P x F   ","Produto XML P x F   ","SB1                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","2","01","01","Codigo              ","Codigo              ","Product             ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","2","02","03","Descricao + Codigo  ","Descripcion + Codigo","Description + Produc","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","01","Codigo              ","Codigo              ","Product             ","B1_COD                                                                                                                                                                                                                                                    ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","02","Descricao           ","Descripcion         ","Description         ","B1_DESC                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","03","Tipo                ","Tipo                ","Type                ","B1_TIPO                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","04","Unidade             ","Unidad              ","Measure Unit        ","B1_UM                                                                                                                                                                                                                                                     ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","05","Fator Conv.         ","Factor Conv.        ","Conv. Factor        ","B1_CONV                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","06","Seg.Un.Medi.        ","2a. Unid.Med        ","2nd.U.Meas.         ","B1_SEGUM                                                                                                                                                                                                                                                  ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","07","Tipo de Conv        ","Tipo de Conv        ","Type                ","B1_TIPCONV                                                                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","01","08","Pos.IPI/NCM         ","Pos.IPI/NCM         ","NCM Pos.            ","B1_POSIPI                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","02","01","Descricao           ","Descripcion         ","Description         ","B1_DESC                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","02","02","Codigo              ","Codigo              ","Product             ","B1_COD                                                                                                                                                                                                                                                    ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","02","03","Tipo                ","Tipo                ","Type                ","B1_TIPO                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","02","04","Unidade             ","Unidad              ","Measure Unit        ","B1_UM                                                                                                                                                                                                                                                     ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","4","02","05","Pos.IPI/NCM         ","Pos.IPI/NCM         ","NCM Pos.            ","B1_POSIPI                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","5","01","  ","                    ","                    ","                    ","SB1->B1_COD                                                                                                                                                                                                                                               ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SDTCOD","5","02","  ","                    ","                    ","                    ","SB1->B1_DESC                                                                                                                                                                                                                                              ","                                                                                                                                                                                                                                                          "})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)

AutoGrLog( CRLF + "Final da Atualização" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX5
Função de processamento da gravação do SX5 - Indices

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX5()
Local aEstrut   := {}
Local aSX5      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamFil   := Len( SX5->X5_FILIAL )

AutoGrLog( "Ínicio da Atualização SX5" + CRLF )

aEstrut := { "X5_FILIAL", "X5_TABELA", "X5_CHAVE", "X5_DESCRI", "X5_DESCSPA", "X5_DESCENG" }

aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'E3'																	, ; //X5_TABELA
	'052'																	, ; //X5_CHAVE
	'Documentos não processados'						                    , ; //X5_DESCRI
	'Documentos no procesados'							                    , ; //X5_DESCSPA
	'Non processed documents'		                       					} ) //X5_DESCENG
	

aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'E3'																	, ; //X5_TABELA
	'053'																	, ; //X5_CHAVE
	'Documentos disponíveis'	                    						, ; //X5_DESCRI
	'Documentos disponibles'                     							, ; //X5_DESCSPA
	'Available documents'	                     							} ) //X5_DESCENG

aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'42'																	, ; //X5_TABELA
	'CTE'																	, ; //X5_CHAVE
	'Conhecimento de Transporte Eletrônico'	          						, ; //X5_DESCRI
	'DConhecimento de Transporte Eletrônico'      							, ; //X5_DESCSPA
	'Conhecimento de Transporte Eletrônico'	      							} ) //X5_DESCENG
	
// Atualizando dicionário

oProcess:SetRegua2( Len( aSX5 ) )

dbSelectArea( "SX5" )
SX5->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX5 )

	oProcess:IncRegua2( "Atualizando tabelas..." )

	If !SX5->( dbSeek( PadR( aSX5[nI][1], nTamFil ) + aSX5[nI][2] + aSX5[nI][3] ) )
		AutoGrLog( "Item da tabela criado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] )
		RecLock( "SX5", .T. )
	Else
		AutoGrLog( "Item da tabela alterado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] )
		RecLock( "SX5", .F. )
	EndIf

	For nJ := 1 To Len( aSX5[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
		EndIf
	Next nJ

	MsUnLock()

	aAdd( aArqUpd, aSX5[nI][1] )

	If !( aSX5[nI][1] $ cAlias )
		cAlias += aSX5[nI][1] + "/"
	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX5" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX1
Função de processamento da gravação do SX1 - Perguntas

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX1()
Local aEstrut   := {}
Local aSX1      := {}
Local aStruDic  := SX1->( dbStruct() )
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTam1     := Len( SX1->X1_GRUPO )
Local nTam2     := Len( SX1->X1_ORDEM )

AutoGrLog( "Ínicio da Atualização " + cAlias + CRLF )

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }

// Perguntas COM160
aAdd( aSX1, { ;
	'COM160'																, ; //X1_GRUPO
	'01'																	, ; //X1_ORDEM
	'Fornecedor De ?'														, ; //X1_PERGUNT
	'¿De Proveedor ?'														, ; //X1_PERSPA
	'Supplier From ?'														, ; //X1_PERENG
	'MV_CH1'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	6																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR01'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'SA2'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'COM160'																, ; //X1_GRUPO
	'02'																	, ; //X1_ORDEM
	'Fornecedor Ate ?'														, ; //X1_PERGUNT
	'¿A Proveedor ?'														, ; //X1_PERSPA
	'Supplier To ?'															, ; //X1_PERENG
	'MV_CH2'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	6																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR02'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ZZZZZZ'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'SA2'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'COM160'																, ; //X1_GRUPO
	'03'																	, ; //X1_ORDEM
	'Dt Entrega De ?'														, ; //X1_PERGUNT
	'¿De Fc Entrega ?'														, ; //X1_PERSPA
	'Delivery Date From ?'													, ; //X1_PERENG
	'MV_CH3'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR03'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20010101'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'COM160'																, ; //X1_GRUPO
	'04'																	, ; //X1_ORDEM
	'Dt Entrega Ate ?'														, ; //X1_PERGUNT
	'¿A Fc Entrega ?'														, ; //X1_PERSPA
	'Delivery Date To ?'													, ; //X1_PERENG
	'MV_CH4'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR04'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20490101'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL


// Perguntas MTA140I
aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'01'																	, ; //X1_ORDEM
	'Da Nota Fiscal ?'														, ; //X1_PERGUNT
	'¿De Factura ?'															, ; //X1_PERSPA
	'From invoice ?'														, ; //X1_PERENG
	'MV_CH1'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	9																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par01'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	'018'																	, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'02'																	, ; //X1_ORDEM
	'Ate a Nota Fiscal ?'													, ; //X1_PERGUNT
	'¿A Factura ?'															, ; //X1_PERSPA
	'To invoice ?'															, ; //X1_PERENG
	'MV_CH2'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	9																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par02'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ZZZZZZZZZ'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	'018'																	, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'03'																	, ; //X1_ORDEM
	'Da Serie ?'															, ; //X1_PERGUNT
	'¿De Serie ?'															, ; //X1_PERSPA
	'From series ?'															, ; //X1_PERENG
	'MV_CH3'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	3																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par03'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'04'																	, ; //X1_ORDEM
	'Ate Serie ?'															, ; //X1_PERGUNT
	'¿A Serie ?'															, ; //X1_PERSPA
	'To series ?'															, ; //X1_PERENG
	'MV_CH4'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	3																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par04'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ZZZ'																	, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'05'																	, ; //X1_ORDEM
	'Fornecedor De ?'														, ; //X1_PERGUNT
	'¿De Proveedor ?'														, ; //X1_PERSPA
	'Supplier From ?'														, ; //X1_PERENG
	'MV_CH5'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	6																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par05'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	'001'																	, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'06'																	, ; //X1_ORDEM
	'Fornecedor Ate ?'														, ; //X1_PERGUNT
	'¿A Proveedor ?'														, ; //X1_PERSPA
	'Supplier To ?'															, ; //X1_PERENG
	'MV_CH6'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	6																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par06'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ZZZZZZ'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	'001'																	, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'07'																	, ; //X1_ORDEM
	'Dt Emissao Inicial ?'													, ; //X1_PERGUNT
	'¿Fc Emision Inicial ?'													, ; //X1_PERSPA
	'Start Issue Date ?'													, ; //X1_PERENG
	'MV_CH7'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par07'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20010101'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'08'																	, ; //X1_ORDEM
	'Dt Emissao Final ?'													, ; //X1_PERGUNT
	'¿Fch Emision final ?'													, ; //X1_PERSPA
	'Final Issue Date ?'													, ; //X1_PERENG
	'MV_CH8'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par08'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20490101'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'09'																	, ; //X1_ORDEM
	'Dt Importacao Inicial ?'												, ; //X1_PERGUNT
	'¿Fc Importacion Inicial ?'												, ; //X1_PERSPA
	'Start Import Date ?'													, ; //X1_PERENG
	'MV_CH9'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par09'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20010101'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'10'																	, ; //X1_ORDEM
	'Dt Importacao Final ?'													, ; //X1_PERGUNT
	'¿Fc Importacion Final ?'												, ; //X1_PERSPA
	'End Import Date ?'														, ; //X1_PERENG
	'MV_CHA'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par10'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20490101'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'11'																	, ; //X1_ORDEM
	'Mostra Gerados ?'														, ; //X1_PERGUNT
	'¿Muestra Generados ?'													, ; //X1_PERSPA
	'Displays Generated ?'													, ; //X1_PERENG
	'MV_CHB'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par11'																, ; //X1_VAR01
	'Sim'																	, ; //X1_DEF01
	'Si'																	, ; //X1_DEFSPA1
	'Yes'																	, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	'Nao'																	, ; //X1_DEF02
	'No'																	, ; //X1_DEFSPA2
	'No'																	, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL
/*
aAdd( aSX1, { ;
	'MTA140I'																, ; //X1_GRUPO
	'12'																	, ; //X1_ORDEM
	'Status Pedido'															, ; //X1_PERGUNT
	'Status Pedido'															, ; //X1_PERSPA
	'Status Pedido'															, ; //X1_PERENG
	'MV_CHC'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par12'																, ; //X1_VAR01
	'Recebido o xml'														, ; //X1_DEF01      
	'Recebido o xml'														, ; //X1_DEFSPA1
	'Recebido o xml'														, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	'Ped Associado'															, ; //X1_DEF02
	'Ped Associado'															, ; //X1_DEFSPA2
	'Ped Associado'															, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	'WF Enviado'															, ; //X1_DEF03
	'WF Enviado'															, ; //X1_DEFSPA3
	'WF Enviado'															, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	'WF Retornado'															, ; //X1_DEF04
	'WF Retornado'															, ; //X1_DEFSPA4
	'WF Retornado'															, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	'Manifestado'															, ; //X1_DEF05
	'Manifestado'															, ; //X1_DEFSPA5
	'Manifestado'															, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL
*/
//
// Atualizando dicionário
//

nPosPerg:= aScan( aEstrut, "X1_GRUPO"   )
nPosOrd := aScan( aEstrut, "X1_ORDEM"   )
nPosTam := aScan( aEstrut, "X1_TAMANHO" )
nPosSXG := aScan( aEstrut, "X1_GRPSXG"  )

oProcess:SetRegua2( Len( aSX1 ) )

dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX1 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX1[nI][nPosSXG]  )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX1[nI][nPosSXG] ) )
			If aSX1[nI][nPosTam] <> SXG->XG_SIZE
				aSX1[nI][nPosTam] := SXG->XG_SIZE
				AutoGrLog( "O tamanho da pergunta " + aSX1[nI][nPosPerg] + " / " + aSX1[nI][nPosOrd] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				"   por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	oProcess:IncRegua2( "Atualizando perguntas..." )

	If !SX1->( dbSeek( PadR( aSX1[nI][nPosPerg], nTam1 ) + PadR( aSX1[nI][nPosOrd], nTam2 ) ) )
		AutoGrLog( "Pergunta Criada. Grupo/Ordem " + aSX1[nI][nPosPerg] + "/" + aSX1[nI][nPosOrd] )
		RecLock( "SX1", .T. )
	Else
		AutoGrLog( "Pergunta Alterada. Grupo/Ordem " + aSX1[nI][nPosPerg] + "/" + aSX1[nI][nPosOrd] )
		RecLock( "SX1", .F. )
	EndIf

	For nJ := 1 To Len( aSX1[nI] )
		If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
			SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aSX1[nI][nJ] ) )
		EndIf
	Next nJ

	MsUnLock()

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX1" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX9
Função de processamento da gravação do SX9 - Relacionamento

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX9()
Local aEstrut   := {}
Local aSX9      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX9->X9_DOM )
Local   nIdentSC7 := 1

AutoGrLog( "Ínicio da Atualização" + " SX9" + CRLF )

aEstrut := { "X9_DOM"    , "X9_IDENT"  , "X9_CDOM"   , "X9_EXPDOM" , "X9_EXPCDOM", "X9_PROPRI" , "X9_LIGDOM" , ;
             "X9_LIGCDOM", "X9_CONDSQL", "X9_USEFIL" , "X9_VINFIL" , "X9_CHVFOR" , "X9_ENABLE" }


DbSelectArea ("SX9")
SX9->(DbSetOrder (1))
SX9->(DbSeek("SC7"))
While !SX9->(EOF()) .And. SX9->X9_DOM == "SC7"
	nIdentSC7 := nIdentSC7 + 1
	SX9->(DbSkip())
End
			 
// Domínio SC7
aAdd( aSX9, { ;
		'SC7'																	, ; //X9_DOM
		STRZero(nIdentSC7,3)													, ; //X9_IDENT
		'SDT'																	, ; //X9_CDOM
		'C7_NUM+C7_ITEM'														, ; //X9_EXPDOM
		'DT_PEDIDO+DT_ITEMPC'													, ; //X9_EXPCDOM
		'S'																		, ; //X9_PROPRI
		'1'																		, ; //X9_LIGDOM
		'1'																		, ; //X9_LIGCDOM
		''																		, ; //X9_CONDSQL
		'S'																		, ; //X9_USEFIL
		'S'																		, ; //X9_VINFIL
		'S'																		, ; //X9_CHVFOR
		'S'																		} ) //X9_ENABLE


// Domínio SDS
aAdd( aSX9, { ;
	'SDS'																	, ; //X9_DOM
	'001'																	, ; //X9_IDENT
	'SDT'																	, ; //X9_CDOM
	'DS_DOC+DS_SERIE+DS_FORNEC+DS_LOJA'										, ; //X9_EXPDOM
	'DT_DOC+DT_SERIE+DT_FORNEC+DT_LOJA'										, ; //X9_EXPCDOM
	'S'																		, ; //X9_PROPRI
	'1'																		, ; //X9_LIGDOM
	'N'																		, ; //X9_LIGCDOM
	''																		, ; //X9_CONDSQL
	'S'																		, ; //X9_USEFIL
	'S'																		, ; //X9_VINFIL
	'S'																		, ; //X9_CHVFOR
	'S'																		} ) //X9_ENABLE

aAdd( aSX9, { ;
	'SDS'																	, ; //X9_DOM
	'002'																	, ; //X9_IDENT
	'SF1'																	, ; //X9_CDOM
	'DS_DOC+DS_SERIE+DS_FORNEC+DS_LOJA'										, ; //X9_EXPDOM
	'F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA'									, ; //X9_EXPCDOM
	'S'																		, ; //X9_PROPRI
	'1'																		, ; //X9_LIGDOM
	'1'																		, ; //X9_LIGCDOM
	''																		, ; //X9_CONDSQL
	'S'																		, ; //X9_USEFIL
	'S'																		, ; //X9_VINFIL
	'S'																		, ; //X9_CHVFOR
	'S'																		} ) //X9_ENABLE

// Domínio SDT
aAdd( aSX9, { ;
	'SDT'																	, ; //X9_DOM
	'001'																	, ; //X9_IDENT
	'SD1'																	, ; //X9_CDOM
	'DT_DOC+DT_SERIE+DT_FORNEC+DT_LOJA+DT_COD+DT_ITEM'						, ; //X9_EXPDOM
	'D1_DOC+D1_SERIE+D1_FORNEC+D1_LOJA+D1_COD+D1_ITEM'						, ; //X9_EXPCDOM
	'S'																		, ; //X9_PROPRI
	'1'																		, ; //X9_LIGDOM
	'1'																		, ; //X9_LIGCDOM
	''																		, ; //X9_CONDSQL
	'S'																		, ; //X9_USEFIL
	'S'																		, ; //X9_VINFIL
	'S'																		, ; //X9_CHVFOR
	'S'																		} ) //X9_ENABLE

// Atualizando dicionário
oProcess:SetRegua2( Len( aSX9 ) )

dbSelectArea( "SX9" )
dbSetOrder( 2 )

For nI := 1 To Len( aSX9 )

	If !SX9->( dbSeek( PadR( aSX9[nI][3], nTamSeek ) + PadR( aSX9[nI][1], nTamSeek ) ) )

		If !( aSX9[nI][1]+aSX9[nI][3] $ cAlias )
			cAlias += aSX9[nI][1]+aSX9[nI][3] + "/"
		EndIf

		RecLock( "SX9", .T. )
		For nJ := 1 To Len( aSX9[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX9[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

		AutoGrLog( "Foi incluído o relacionamento " + aSX9[nI][1] + "/" + aSX9[nI][3] )

		oProcess:IncRegua2( "Atualizando Arquivos (SX9)..." )

	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX9" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuHlp
Função de processamento da gravação dos Helps de Campos

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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
// Helps Tabela SA2
//
//
// Helps Tabela SA5
//
aHlpPor := {}
aAdd( aHlpPor, 'Tp.Entr. para Bonificação.' )

PutHelp( "PA5_TESBP  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "A5_TESBP" )

aHlpPor := {}
aAdd( aHlpPor, 'Unidade de Medida para NFe.' )

PutHelp( "PA5_UMNFE  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "A5_UMNFE" )

aHlpPor := {}
aAdd( aHlpPor, 'Tp.Entr. para Compl. Preço.' )

PutHelp( "PA5_TESCP  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "A5_TESCP" )

//
// Helps Tabela SA7
//
aHlpPor := {}
aAdd( aHlpPor, 'Unidade de Medida para NFe.' )

PutHelp( "PA7_UMNFE  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "A7_UMNFE" )

//
// Helps Tabela SC7
//
aHlpPor := {}
aAdd( aHlpPor, 'Número do ID TSS para o' )
aAdd( aHlpPor, 'Totvs .' )

PutHelp( "PC7_IDTSS  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "C7_IDTSS" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo de Mensagem para o' )
aAdd( aHlpPor, 'TOTVS.' )

PutHelp( "PC7_TPCOLAB", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "C7_TPCOLAB" )

//
// Helps Tabela SDS
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial do Sistema.' )

PutHelp( "PDS_FILIAL ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo da nota.' )

PutHelp( "PDS_TIPO   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_TIPO" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do documento.' )

PutHelp( "PDS_DOC    ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_DOC" )

aHlpPor := {}
aAdd( aHlpPor, 'Série do documento.' )

PutHelp( "PDS_SERIE  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_SERIE" )

aHlpPor := {}
aAdd( aHlpPor, 'Código identificador do fornecedor' )
aAdd( aHlpPor, 'ou cliente.' )

PutHelp( "PDS_FORNEC ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_FORNEC" )

aHlpPor := {}
aAdd( aHlpPor, 'Loja do Fornecedor/Cliente.' )

PutHelp( "PDS_LOJA   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_LOJA" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome do fornecedor/cliente.' )

PutHelp( "PDS_NOMEFOR", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_NOMEFOR" )

aHlpPor := {}
aAdd( aHlpPor, 'CNPJ do Fornecedor/Cliente.' )

PutHelp( "PDS_CNPJ   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_CNPJ" )

aHlpPor := {}
aAdd( aHlpPor, 'Data de Emissão da NF.' )

PutHelp( "PDS_EMISSA ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_EMISSA" )

aHlpPor := {}
aAdd( aHlpPor, 'Fomulário próprio.' )

PutHelp( "PDS_FORMUL ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_FORMUL" )

aHlpPor := {}
aAdd( aHlpPor, 'Especie do Documento.' )

PutHelp( "PDS_ESPECI ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_ESPECI" )

aHlpPor := {}
aAdd( aHlpPor, 'Estado de emissao da NF.' )

PutHelp( "PDS_EST    ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_EST" )

aHlpPor := {}
aAdd( aHlpPor, 'Status do registro.' )

PutHelp( "PDS_STATUS ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_STATUS" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome do Arquivo XML.' )

PutHelp( "PDS_ARQUIVO", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_ARQUIVO" )

aHlpPor := {}
aAdd( aHlpPor, 'Usuário responsável pela importação da' )
aAdd( aHlpPor, 'Nota Fiscal Eletrônica' )

PutHelp( "PDS_USERIMP", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_USERIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Data importacao do XML.' )

PutHelp( "PDS_DATAIMP", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_DATAIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora importação do XML.' )

PutHelp( "PDS_HORAIMP", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_HORAIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Usuário responsável pela geração da' )
aAdd( aHlpPor, 'pré-nota.' )

PutHelp( "PDS_USERPRE", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_USERPRE" )

aHlpPor := {}
aAdd( aHlpPor, 'Data de geração da Pré-Nota de Entrada' )

PutHelp( "PDS_DATAPRE", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_DATAPRE" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora de geração da Pré-Nota de Entrada' )

PutHelp( "PDS_HORAPRE", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_HORAPRE" )

aHlpPor := {}
aAdd( aHlpPor, 'Chave de acesso da Nota Fiscal' )
aAdd( aHlpPor, 'Eletrônica' )

PutHelp( "PDS_CHAVENF", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_CHAVENF" )

aHlpPor := {}
aAdd( aHlpPor, 'Versao Layout da NFe.' )

PutHelp( "PDS_VERSAO ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_VERSAO" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor  do frete da nota fiscal' )
aAdd( aHlpPor, 'do fornecedor.' )

PutHelp( "PDS_FRETE  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_FRETE" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor do seguro do' )
aAdd( aHlpPor, 'documento de entrada.' )

PutHelp( "PDS_SEGURO ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_SEGURO" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor das despesas adicionais' )
aAdd( aHlpPor, 'da  nota fiscal do fornecedor.' )

PutHelp( "PDS_DESPESA", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_DESPESA" )

aHlpPor := {}
aAdd( aHlpPor, 'Descontos da nota fiscal.' )

PutHelp( "PDS_DESCONT", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_DESCONT" )

aHlpPor := {}
aAdd( aHlpPor, 'Código de identificação' )
aAdd( aHlpPor, 'da transportadora.' )

PutHelp( "PDS_TRANSP ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_TRANSP" )

aHlpPor := {}
aAdd( aHlpPor, 'Placa do Veículo.' )

PutHelp( "PDS_PLACA  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_PLACA" )

aHlpPor := {}
aAdd( aHlpPor, 'Peso líquido da mercadoria' )
aAdd( aHlpPor, 'impresso na nota fiscal.' )

PutHelp( "PDS_PLIQUI ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_PLIQUI" )

aHlpPor := {}
aAdd( aHlpPor, 'Peso bruto da mercadoria' )
aAdd( aHlpPor, 'impresso na nota fiscal.' )

PutHelp( "PDS_PBRUTO ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_PBRUTO" )

aHlpPor := {}
aAdd( aHlpPor, 'Espécie ou volume de embalagem 1.' )
aAdd( aHlpPor, 'Ex.: caixas.' )

PutHelp( "PDS_ESPECI1", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_ESPECI1" )

aHlpPor := {}
aAdd( aHlpPor, 'Espécie ou volume de embalagem 2.' )
aAdd( aHlpPor, 'Ex.: caixas.' )

PutHelp( "PDS_ESPECI2", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_ESPECI2" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de volume na espécie 1.' )

PutHelp( "PDS_VOLUME1", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_VOLUME1" )

aHlpPor := {}
aAdd( aHlpPor, 'Indica tipo de frete.' )

PutHelp( "PDS_TPFRETE", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_TPFRETE" )

aHlpPor := {}
aAdd( aHlpPor, 'Espécie ou volume de embalagem 3.' )
aAdd( aHlpPor, 'Ex.: caixas.' )

PutHelp( "PDS_ESPECI3", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_ESPECI3" )

aHlpPor := {}
aAdd( aHlpPor, 'Espécie ou volume de embalagem 4.' )
aAdd( aHlpPor, 'Ex.: caixas.' )

PutHelp( "PDS_ESPECI4", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_ESPECI4" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor da mercadoria da nota fiscal.' )

PutHelp( "PDS_VALMERC", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_VALMERC" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de volume na espécie 2.' )

PutHelp( "PDS_VOLUME2", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_VOLUME2" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de volume na espécie 3.' )

PutHelp( "PDS_VOLUME3", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_VOLUME3" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de volume na espécie 4.' )

PutHelp( "PDS_VOLUME4", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_VOLUME4" )

aHlpPor := {}
aAdd( aHlpPor, 'Detalhes da ocorrência para geração' )
aAdd( aHlpPor, 'da Pré-Nota ou Doc. Entrada.' )

PutHelp( "PDS_DOCLOG ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_DOCLOG" )

aHlpPor := {}
aAdd( aHlpPor, 'Flag utilizada para marcar/desmarcar os' )
aAdd( aHlpPor, 'documentos importados para geração de do' )

PutHelp( "PDS_OK     ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_OK" )

aHlpPor := {}
aAdd( aHlpPor, 'Base de cálculo para o ICMS.' )

PutHelp( "PDS_BASEICM", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_BASEICM" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor do ICMS da nota fiscal.' )

PutHelp( "PDS_VALICM ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_VALICM" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero do documento do xml de importação' )

PutHelp( "PDS_XMLDOC ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_XMLDOC" )

aHlpPor := {}
aAdd( aHlpPor, 'Serie do doc XML Importacao' )

PutHelp( "PDS_XMLSER ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DS_XMLSER" )

//
// Helps Tabela SDT
//
aHlpPor := {}
aAdd( aHlpPor, 'Filial do Sistema.' )

PutHelp( "PDT_FILIAL ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Item da Nota Fiscal.' )

PutHelp( "PDT_ITEM   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_ITEM" )

aHlpPor := {}
aAdd( aHlpPor, 'Codigo do Produto.' )

PutHelp( "PDT_COD    ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Descrição do produto.' )

PutHelp( "PDT_DESC   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_DESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Codigo do Produto do Fornecedor/Cliente.' )

PutHelp( "PDT_PRODFOR", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_PRODFOR" )

aHlpPor := {}
aAdd( aHlpPor, 'Descrição do Produto Fornecedor/Cliente.' )

PutHelp( "PDT_DESCFOR", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_DESCFOR" )

aHlpPor := {}
aAdd( aHlpPor, 'Codigo do Fornecedor/Cliente.' )

PutHelp( "PDT_FORNEC ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_FORNEC" )

aHlpPor := {}
aAdd( aHlpPor, 'Loja do Fornecedor/Cliente.' )

PutHelp( "PDT_LOJA   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_LOJA" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero do Documento/Nota.' )

PutHelp( "PDT_DOC    ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_DOC" )

aHlpPor := {}
aAdd( aHlpPor, 'Serie da Nota Fiscal.' )

PutHelp( "PDT_SERIE  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_SERIE" )

aHlpPor := {}
aAdd( aHlpPor, 'CNPJ do Fornecedor/Cliente.' )

PutHelp( "PDT_CNPJ   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_CNPJ" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do Produto.' )

PutHelp( "PDT_QUANT  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_QUANT" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor unitário do item.' )

PutHelp( "PDT_VUNIT  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_VUNIT" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor Total.' )

PutHelp( "PDT_TOTAL  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_TOTAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do pedido de compra.' )

PutHelp( "PDT_PEDIDO ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_PEDIDO" )

aHlpPor := {}
aAdd( aHlpPor, 'Item do pedido de compra.' )

PutHelp( "PDT_ITEMPC ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_ITEMPC" )

aHlpPor := {}
aAdd( aHlpPor, 'Nota fiscal original quando' )
aAdd( aHlpPor, 'entrada de devolução de vendas.' )

PutHelp( "PDT_NFORI  ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_NFORI" )

aHlpPor := {}
aAdd( aHlpPor, 'Série da nota fiscal original quando' )
aAdd( aHlpPor, 'entrada de uma devolução de vendas.' )

PutHelp( "PDT_SERIORI", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_SERIORI" )

aHlpPor := {}
aAdd( aHlpPor, 'Item da Nota Fiscal Original quando' )
aAdd( aHlpPor, 'entrada de uma devolução de vendas.' )

PutHelp( "PDT_ITEMORI", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_ITEMORI" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor  do frete.' )

PutHelp( "PDT_VALFRE ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_VALFRE" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor do seguro.' )

PutHelp( "PDT_SEGURO ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_SEGURO" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor das despesas.' )

PutHelp( "PDT_DESPESA", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_DESPESA" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor de Desconto do item.' )

PutHelp( "PDT_VALDESC", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_VALDESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual de ICMS sobre o produto.' )

PutHelp( "PDT_PICM   ", aHlpPor, {}, {}, .T. )
AutoGrLog( "Atualizado o Help do campo " + "DT_PICM" )

AutoGrLog( CRLF + "Final da Atualização" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF )

Return {}


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuHlpX1
Função de processamento da gravação dos Helps de Perguntas

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuHlpX1()
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

AutoGrLog( "Ínicio da Atualização" + " " + "Helps de Perguntas" + CRLF )


oProcess:IncRegua2( "Atualizando Helps de Perguntas ..." )

//
// Helps Perguntas COM160
//
//
// Helps Perguntas MTA140I
//
AutoGrLog( CRLF + "Final da Atualização" + " " + "Helps de Perguntas" + CRLF + Replicate( "-", 128 ) + CRLF )

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

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), oDlg:End()  ) ;
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
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  14/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX7  ³ Autor ³ Felipi Marques                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX7()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"DT_COD" , "001" , "SB1->B1_DESC" , "DT_DESC" , "P" , "S" , "SB1" , 01 , "XFILIAL('SB1')+M->DT_COD","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)    
AutoGrLog( CRLF + 'SX7 : ' + cTexto  + CHR(13) + CHR(10))

Return NIL
