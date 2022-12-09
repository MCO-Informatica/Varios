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

//------------- -------------------------------------------------------
/*/{Protheus.doc} UPDSZR
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDSZR( cEmpAmb, cFilAmb )

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

		If !FWAuthAdmin()
			Final( "Atualização não Realizada." )
		EndIf

		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDSZR" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDSZR" )
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
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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


			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()


			FSAtuSX3()


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


			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()

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
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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

aAdd( aSX2, {'SZR',cPath,'SZR'+cEmpr,'REL MARGEM','REL MARGEM','REL MARGEM','E','','','','','','','','','','','E','E',0} )
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
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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


aAdd( aSX3, {'SD2','S5','D2_XNFVEN','C',9,0,'NF FT Triang','NF FT Triang','NF FT Triang','NF FT Triangular','NF FT Triangular','NF FT Triangular','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SD2','S7','D2_XNFVITE','C',2,0,'It nf Triang','It nf Triang','It nf Triang','It nf Triangulacao','It nf Triangulacao','It nf Triangulacao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','01','ZR_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'SZR','02','ZR_NREDUZ','C',20,0,'N Fantasia','Nom Fantasia','Trade Name','Nome Reduzido do cliente','Nom. Reducido del Cliente','Customer Short Name','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(147) + Chr(128),'','','','S','A','R','','Existchav("SA1",M->A1_NREDUZ,5)','','','','','','','','1','','','S','N','','1','N','','S','S'} )
aAdd( aSX3, {'SZR','03','ZR_MUN','C',60,0,'Municipio','Municipio','Municipality','Municipio do cliente','Municipio del cliente','Customer Municipality','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(147) + Chr(128),'','','','N','','','','','','','','','','','','1','','','S','N','','1','N','','S','S'} )
aAdd( aSX3, {'SZR','04','ZR_CODSEG','C',6,0,'Cod.Segmento','Cod.Segmento','Segment Code','Código do Segmento','Código del segmento','Segment Code','@!',"VAZIO() .OR. (ExistCpo('AOV',M->A1_CODSEG)    .And. CRMA620VLD(M->A1_CODSEG))",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','AOVP',1,Chr(198) + Chr(128),'','S','','S','A','R','','','','','','','','','','1','','','N','','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','05','ZR_CDRDES','C',6,0,'Reg. Cliente','Reg. Cliente','Cust.Region','Regiao do Cliente','Region del Cliente','Customer Region','@!','ExistCpo("DUY",M->A1_CDRDES,1)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','DUY',1,Chr(134) + Chr(128),'','S','','N','','','','','','','','','','','','1','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','06','ZR_DESSEG','C',40,0,'Descrição','Descripción','Description','Descrição do Segmento','Descripción del segmento','Segment Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(151) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','N','','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','07','ZR_VREDUZ','C',25,0,'N.Reduz.Vend','N.Reduz.Vend','N.Reduz.Vend','Nome Reduzido do Vendedor','Nombre Reducido Vendedor',"Seller's Short Name",'','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(146) + Chr(192),'','','','S','A','R','','Existchav("SA3",M->A3_NREDUZ,9)','','','','','','','','1','','','S','N','','1','N','','S','S'} )
aAdd( aSX3, {'SZR','08','ZR_QUANT','N',11,5,'Quantidade','Cantidad','Quantity','Quantidade do Produto','Cantidad del Producto','Product Quantity','@E 99,999.99999','Positivo().and. A100SegUm().And.MaFisRef("IT_QUANT","MT100",M->D2_QUANT)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(155) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','09','ZR_PRCVEN','N',14,5,'Vlr.Unitario','Valor Unit.','Unit Value','Valor Unitario','Valor Unitario','Unit Value','@E 99,999,999.99999','Positivo().And.NaoVazio().And.MaFisRef("IT_PRCUNI","MT100",M->D2_PRCVEN)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(155) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','10','ZR_TOTAL','N',15,6,'Vlr.Total','Valor Total','Grand Total','Valor Total','Valor Total','Grand Total','@E 99,999,999.999999','Positivo().And.A920Total(M->D2_TOTAL) .and. MaFisRef("IT_VALMERC","MT100",M->D2_TOTAL)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(155) + Chr(128),'','','','N','A','R','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','11','ZR_TOTAL1','N',15,6,'Vlr.Tot.Fr.c','Vlr.Tot.Fr.c','Vlr.Tot.Fr.c','Vlr.Tot.Fr.CIF','Vlr.Tot.Fr.CIF','Vlr.Tot.Fr.CIF','@E 99,999,999.999999','A103Total(M->D1_TOTAL) .and. MaFisRef("IT_VALMERC","MT100",M->D1_TOTAL)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(155) + Chr(128),'','','','N','A','R','','Positivo()','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','12','ZR_VALIPI','N',14,2,'Vlr.IPI','Vlr. IPI','IPI Value','Valor do IPI do Item','Valor del IPI del Item','Item IPI Value','@E 99,999,999,999.99','Positivo().And.MaFisRef("IT_VALIPI","MT100",M->D2_VALIPI)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(154) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','13','ZR_VALICM','N',14,2,'Vlr.ICMS','Vlr. ICMS','ICMS Value','Valor do ICM do Item','Valor del ICMS del Item',"Item's ICMS Value",'@E 99,999,999,999.99','Positivo().And.MaFisRef("IT_VALICM","MT100",M->D2_VALICM)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(154) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','14','ZR_CF','C',5,0,'Cod. Fiscal','Cod. Fiscal','Fiscal Code','Codigo Fiscal da Operacao','Codigo Fiscal Operacion','Operation Fiscal Code','@9','NaoVazio().and.AvalCFO("SD2",M->D2_CF) .and. MaFisRef("IT_CF","MT100",M->D2_CF)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','13',1,Chr(131) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','15','ZR_PICM','N',5,2,'Aliq. ICMS','Alic. ICMS','ICMS Rate','Alíquota de ICMS','Alicuota de ICMS','ICMS Tax Rate','@E 99.99','Positivo().And.MaFisRef("IT_ALIQICM","MT100",M->D2_PICM)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(154) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','16','ZR_DOC','C',9,0,'Num. Docto.','Nro. Doc.','Doc. Number','Numero do Documento/Nota','Numero del documento','Document/Invoice Number','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(128) + Chr(128),'','','','N','','','','','','','','','','','018','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','16','ZR_CUSTO1','N',14,5,'Custo','Costo','Cost','Custo','Costo','Cost','@E 99,999,999.99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(154) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','18','ZR_VALIMP5','N',14,2,'Valor Imp. 5','Valor Imp. 5','Tax Value 5','Valor do Imposto 5','Valor del Impuesto 5','Tax Value 5','@E  99,999,999,999.99','MaFisRef("IT_VALCF2","MT100",M->D2_VALIMP5)',Chr(144) + Chr(136) + Chr(132) + Chr(130) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(152) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','18','ZR_VALFRE','N',14,2,'Vlr. Frete','Vlr.Flete','Freight Vl.','Valor do Frete','Valor del Flete','Freight Value','@E 999,999,999.99','MaFisRef("IT_FRETE","MT100",M->D2_VALFRE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(154) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','19','ZR_VALIMP6','N',14,2,'Valor Imp. 6','Valor Imp. 6','Tax Value 6','Valor do Imposto 6','Valor del Impuesto 6','Tax Value 6','@E  99,999,999,999.99','MaFisRef("IT_VALPS2","MT100",M->D2_VALIMP6)',Chr(144) + Chr(136) + Chr(132) + Chr(130) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(152) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','21','ZR_DESCRI','C',50,0,'Descricao','Descripcion','Description','Descricao da Cond. Pagto','Descripci¾n Cond. Pago','Payment Terms Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(147) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','22','ZR_EMISSAO','D',8,0,'DT Emissao','Fch Emision','Issue Date','Data de Emissao da NF','Fecha de Emisión Factura','Invoice Issue Date','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'ddatabase','',1,Chr(131) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','23','ZR_EST','C',2,0,'Estado','Estado','State','Estado Destino do Materia','Estado Destino Mercaderia','Destination State Goods','@!','ExistCpo("SX5","12"+M->F2_EST).And.MaFisRef("NF_UFDEST","MT100",M->F2_UF)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','010','','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','24','ZR_DUPLIC','C',1,0,'Gera Dupl.','Gen. Titulo','Gener.Tr.Nt?','S - para gerar duplicata','S: para Generar Titulo','S- to generate Trade Note','!','pertence("SN")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(131) + Chr(128),'','','','N','','','','','S=Sim;N=Nao','S=Si;N=No','S=Yes;N=No','','','','','1','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','25','ZR_ESTOQUE','C',1,0,'Atu.Estoque','Act. Stock','Updte Stock?','S-sim/N-nao','S: Si; N: No.','S-Yes/N-No','!','pertence("SN") .and. IIF(ALTERA,A080ALMOV(SF4->F4_CODIGO),.T.)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(131) + Chr(128),'','','','N','','','','','S=Sim;N=Nao','S=Si;N=No','S=Yes;N=No','','','','','1','','','N','N','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','26','ZR_DESCINT','C',60,0,'Descr. Int.','Descr. Int.','Descr. Int.','Descricao Interna do Prod','Descricao Interna do Prod','Descricao Interna do Prod','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','S','U','S','A','R','€','','','','','','','','','1','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','27','ZR_ACRVEN1','N',5,2,'Decres. Com.','Decres. Com.','Decres. Com.','Descréscimo na comissão','Descréscimo na comissão','Descréscimo na comissão','@E 99.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','28','ZR_DIFAL','N',14,2,'ICMS Difal','ICMS Difal','Difal ICMS','ICMS Comple. UF Destino','ICMS Comple. UF Destino','Target State Compl. ICMS','@E 99,999,999,999.99','MaFisRef("IT_DIFAL","MT100",M->D2_DIFAL)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','N','','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','29','ZR_ICMSCOM','N',14,2,'ICMS Comple.','ICMS Comple.','Comp.ICMS','Valor ICMS Complementar','Valor ICMS Complementario','Complementary ICMS Value','@E 99,999,999,999.99','MaFisRef("IT_VALCMP","MT100",M->D2_ICMSCOM)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','N','','','1','N','','N','S'} )
aAdd( aSX3, {'SZR','30','ZR_XNFVEN','C',9,0,'NF FT Triang','NF FT Triang','NF FT Triang','NF FT Triangular','NF FT Triangular','NF FT Triangular','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','31','ZR_XNFVITE','C',2,0,'It NF Triang','It NF Triang','It NF Triang','It NF Triangular','It NF Triangular','It NF Triangular','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','32','ZR_TPOPER','C',1,0,'Tipo Operac','Tipo Operac','Tipo Operac','Tipo Operacao','Tipo Operacao','Tipo Operacao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','D=Devolucao;V=Venda','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','33','ZR_COD','C',6,0,'Codigo','Codigo','Code','Codigo do Cliente','Codigo del Cliente','Customer´s Code','@!','IIF(Empty(M->A1_LOJA),.T.,ExistChav("SA1",M->A1_COD+M->A1_LOJA,,"EXISTCLI"))',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(176),'GETSXENUM( "SA1","A1_COD")','',1,Chr(131) + Chr(128),'','','','S','V','R','','','','','','','A030WHEN()','','001','1','','','S','N','','1','N','','S','S'} )
aAdd( aSX3, {'SZR','34','ZR_LJCLIFO','C',2,0,'Lj Clie For','Lj Clie For','Lj Clie For','Lj Clie For','Lj Clie For','Lj Clie For','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','35','ZR_CODPROD','C',15,0,'Cod Prod','Cod Prod','Cod Prod','Cod Prod','Cod Prod','Cod Prod','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','36','ZR_VCOD','C',6,0,'Cod Vendedor','Cod Vendedor','Cod Vendedor','Cod Vendedor','Cod Vendedor','Cod Vendedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','37','ZR_REGIAO','C',3,0,'Regiao','Regiao','Regiao','Regiao','Regiao','Regiao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','38','ZR_FRTCIF','N',15,6,'Frete CIF','Frete CIF','Frete CIF','Frete CIF','Frete CIF','Frete CIF','@E 99,999,999.999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','39','ZR_DTVALID','D',8,0,'Dt.Vld.Lote','Dt.Vld.Lote','Dt.Vld.Lote','Dt.Vld.Lote','Dt.Vld.Lote','Dt.Vld.Lote','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','40','ZR_VNOME','C',40,0,'Nom.Comp.Ven','Nom.Comp.Ven','Nom.Comp.Ven','Nome Vendedor','Nome Vendedor','Nome Vendedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','41','ZR_COMOD','C',1,0,'Comodite','Comodite','Comodite','Comodite','Comodite','Comodite','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','42','ZR_GRPVEN','C',6,0,'Grp Vendas','Grp Vendas','Grp Vendas','Grp Vendas','Grp Vendas','Grp Vendas','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','43','ZR_DESCGV','C',30,0,'Desc Grp Ven','Desc Grp Ven','Desc Grp Ven','Desc Grp Ven','Desc Grp Ven','Desc Grp Ven','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','44','ZR_PAIS','C',3,0,'Cod Pais','Cod Pais','Cod Pais','Cod Pais','Cod Pais','Cod Pais','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','45','ZR_DSCPAIS','C',25,0,'Desc Pais','Desc Pais','Desc Pais','Desc Pais','Desc Pais','Desc Pais','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','46','ZR_CODGRPR','C',4,0,'Cod Grp Prod','Cod Grp Prod','Cod Grp Prod','Cod Grp Prod','Cod Grp Prod','Cod Grp Prod','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','47','ZR_DESCGRP','C',30,0,'Desc Grupo','Desc Grupo','Desc Grupo','Desc Grupo produto','Desc Grupo produto','Desc Grupo produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','48','ZR_MOEDA','N',2,0,'Moeda','Moeda','Moeda','Moeda','Moeda','Moeda','99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','49','ZR_TXMOEDA','N',11,4,'Tx Moeda','Tx Moeda','Tx Moeda','Tx Moeda','Tx Moeda','Tx Moeda','@E 999,999.9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','50','ZR_UNIDVEN','C',6,0,'Unid Venda','Unid Venda','Unid Venda','Unid Venda','Unid Venda','Unid Venda','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','51','ZR_DECUNVN','C',40,0,'Desc Unid Ve','Desc Unid Ve','Desc Unid Ve','Desc Unid Venda','Desc Unid Venda','Desc Unid Venda','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','52','ZR_DESCON','N',12,2,'Desconto','Desconto','Desconto','Desconto','Desconto','Desconto','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','53','ZR_DESCZFC','N',14,2,'Val.Cof.ZFM','Val.Cof.ZFM','Val.Cof.ZFM','Val.Cof.ZFM','Val.Cof.ZFM','Val.Cof.ZFM','@E 99,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','54','ZR_DESCZFP','N',14,2,'Val.Pis.ZFM','Val.Pis.ZFM','Val.Pis.ZFM','Val.Pis.ZFM','Val.Pis.ZFM','Val.Pis.ZFM','@E 99,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','55','ZR_DESCZFR','N',14,2,'Desc.Z.Franc','Desc.Z.Franc','Desc.Z.Franc','Desc.Z.Franc','Desc.Z.Franc','Desc.Z.Franc','@E 99,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','56','ZR_LOTECTL','C',20,0,'Lote produto','Lote produto','Lote produto','Lote produto','Lote produto','Lote produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','57','ZR_NCM','C',10,0,'NCM','NCM','NCM','NCM','NCM','NCM','@R 9999.99.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','58','ZR_DESPESA','N',12,2,'Vlr Despesas','Vlr Despesas','Vlr Despesas','Vlr Despesas','Vlr Despesas','Vlr Despesas','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','59','ZR_SEGURO','N',12,2,'Valor Seguro','Valor Seguro','Valor Seguro','Valor Seguro','Valor Seguro','Valor Seguro','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','59','ZR_TTFRT','N',12,2,'Frete Total ','Frete Total ','Frete Total ','Frete Total ','Frete Total ','Frete Total ','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SZR','59','ZR_TTITNF','N',12,2,'Vlr.Tot.item','Vlr.Tot.item','Vlr.Tot.item','Vlr.Tot.item','Vlr.Tot.item','Vlr.Tot.item','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )


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
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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

aAdd( aSIX, {'SZR','1','ZR_FILIAL+ZR_DOC','Num. Docto.','Nro. Doc.','Doc. Number','U','','','S'} )
aAdd( aSIX, {'SZR','2','ZR_FILIAL+ZR_CODPROD+ZR_XNFVEN+ZR_XNFVITE','Cod Prod+NF FT Triang+It NF Triang','Cod Prod+NF FT Triang+It NF Triang','Cod Prod+NF FT Triang+It NF Triang','U','','','N'} )
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
/*/{Protheus.doc} FSAtuSX6
Função de processamento da gravação do SX6 - Parâmetros

@author TOTVS Protheus
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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

aAdd( aSX6, {'  ','MV_CFVTRG','C','CFOP´S REFERENTE FATURAMENTO DE OPER TRIANGULAR','','','REF ROTINA XINTMGFAT','','','','','','5122;6122','','','U','','','','','',''} )
aAdd( aSX6, {'  ','MV_EMAITRG','C','','','','','','','','','','daniel@newbridge.srv.br','','','U','','','','','',''} )
aAdd( aSX6, {'  ','MV_EXCMARG','C','CFOP´S EXCLUIDOS DA GERAÇÃO DA TABELA SZR','','','REF ROTINA XINTMGFAT','','','','','','5551','','','U','','','','','',''} )
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
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDSZR" ) ) ) ;
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
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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
@since  07/03/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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
