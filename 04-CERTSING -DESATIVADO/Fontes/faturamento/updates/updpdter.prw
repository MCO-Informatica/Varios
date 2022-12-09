#INCLUDE "PROTHEUS.CH"
    
/*
---------------------------------------------------------------------------
| Rotina    | UPDPDTER    | Autor | Gustavo Prudente | Data | 30.09.2013  |
|-------------------------------------------------------------------------|
| Descricao | Atualiza dicionario de dados com os campos de poder de      |
|           | terceiros.                                                  |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - aParSch[ 1 ] - Codigo da empresa.                   |
|           |         aParSch[ 2 ] - Codigo da filial.                    |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function UPDPDTER( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Deleted On

// Mensagens de Tela Inicial
aAdd( aSay, "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )" 	)
aAdd( aSay, "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros" 		)
aAdd( aSay, "usuários  ou  jobs utilizando  o sistema.  É extremamente recomendavél  que  se  faça um" 	)
aAdd( aSay, "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso " 		)
aAdd( aSay, "ocorra eventuais falhas, esse backup seja ser restaurado." )

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
			oProcess := MsNewProcess():New( { | lEnd | lOk := ProcAtuSXS( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

		If lAuto
			If lOk
				MsgStop( "Atualização Realizada.", "UPDPESQHIST" )
				dbCloseAll()
			Else
				MsgStop( "Atualização não Realizada.", "UPDPESQHIST" )
				dbCloseAll()
			EndIf
		Else
			If lOk
				Final( "Atualização Concluída." )
			Else
				Final( "Atualização não Realizada." )
			EndIf
		EndIf

		Else
			MsgStop( "Atualização não Realizada.", "UPDPESQHIST" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "UPDPESQHIST" )

	EndIf

EndIf

Return NIL

                         
/*
----------------------------------------------------------------------------
| Rotina    | ProcAtuSXS  | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Processa atualizacao de dicionario de dados.                 |
|--------------------------------------------------------------------------|
| Parametros| EXPA1 - Indica se pode finalizar o processamento.            |
|           | EXPA2 - Array com empresas e filiais para processamento.     |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function ProcAtuSXS( lEnd, aMarcadas )
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

			// Processa atualizacao do dicionario SX2
			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			UpdSX2( @cTexto )

			// Processa atualizacao do dicionário SX3 
			UpdSX3( @cTexto )

			// Processa atualizacao do dicionário SIX       
			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			UpdSIX( @cTexto )

			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

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
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					cTexto += "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] + CRLF
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			// Processa atualizacao do dicionário SX5        
			oProcess:IncRegua1( "Dicionário de tabelas" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			UpdSX5( @cTexto )

			// Processa atualizacao do dicionário SX6    
			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			UpdSX6( @cTexto )

			// Processa atualizacao do dicionário SX7 
			oProcess:IncRegua1( "Dicionário de gatilhos disparadores" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			UpdSX7( @cTexto )

			// Processa atualizacao do dicionário SXB
			oProcess:IncRegua1( "Dicionário de consulta padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			UpdSXB( @cTexto )

			// Processa atualizacao dos helps
			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			UpdHlp( @cTexto )

			RpcClearEnv()

		Next nI

		If MyOpenSm0(.T.)

			cAux += Replicate( "-", 128 ) + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += "LOG DA ATUALIZACAO DOS DICIONÁRIOS" + CRLF
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
----------------------------------------------------------------------------
| Rotina    | UpdSX2      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do SX2                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdSX2( cTexto )
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
             "X2_MODULO" }

dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )

cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela SZT
//

/*
aAdd( aSX2, { ;
	'SZT'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZT'+cEmpr																, ; //X2_ARQUIVO
	'ENTIDADE COMMON NAME'													, ; //X2_NOME
	'ENTIDADE COMMON NAME'													, ; //X2_NOMESPA
	'ENTIDADE COMMON NAME'													, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	0																		} ) //X2_MODULO
*/

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
			cTexto += "Foi incluída a tabela " + aSX2[nI][1] + CRLF
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
----------------------------------------------------------------------------
| Rotina    | UpdSX3      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do SX3                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdSX3( cTexto )
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

cTexto  += "Inicio da Atualizacao" + " SX3" + CRLF + CRLF

aEstrut := { "X3_ARQUIVO", "X3_ORDEM"  , "X3_CAMPO"  , "X3_TIPO"   , "X3_TAMANHO", "X3_DECIMAL", ;
             "X3_TITULO" , "X3_TITSPA" , "X3_TITENG" , "X3_DESCRIC", "X3_DESCSPA", "X3_DESCENG", ;
             "X3_PICTURE", "X3_VALID"  , "X3_USADO"  , "X3_RELACAO", "X3_F3"     , "X3_NIVEL"  , ;
             "X3_RESERV" , "X3_CHECK"  , "X3_TRIGGER", "X3_PROPRI" , "X3_BROWSE" , "X3_VISUAL" , ;
             "X3_CONTEXT", "X3_OBRIGAT", "X3_VLDUSER", "X3_CBOX"   , "X3_CBOXSPA", "X3_CBOXENG", ;
             "X3_PICTVAR", "X3_WHEN"   , "X3_INIBRW" , "X3_GRPSXG" , "X3_FOLDER" , "X3_PYME"   }

/*
aAdd( aSX3, { ;
	'SZT'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZT_FILIAL'																, ; //X3_CAMPO
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
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
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
	''																		} ) //X3_PYME
*/

AADD(aSX3,	{ 	"SZ5","83","Z5_FORNECE","C", 06, 00, "Fornecedor  ","Fornecedor  ","Fornecedor  ","Fornecedor               ","Fornecedor               ",;
				"Fornecedor               ", "@!" } )
    
AADD(aSX3,	{ 	"SZ5","84","Z5_LOJA"   ,"C", 02, 00, "Loja"        ,"Loja"        ,"Loja"        ,"Loja"                     ,"Loja"                     ,;
				"Loja"                     , "@!" } )

AADD(aSX3,	{ 	"SZ5","85","Z5_CODPD"  ,"C", 06, 00, "Codigo PD   ","Codigo PD   ","Codigo PD   ","Codigo PD                ","Codigo PD                ",;
				"Codigo PD                ", "@!" } )

AADD(aSX3,	{ 	"SZ5","86","Z5_NFDEV"  ,"C", 09, 00, "NF Devolucao","NF Devolucao","NF Devolucao","NF Devolucao             ","NF Devolucao             ",;
				"NF Devolucao             ", "@!" } )
//
// Atualizando dicionário
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
	If Len(aSX3[nI]) >= nPosSXG .And. !Empty( aSX3[nI,nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI,nPosSXG] ) )
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
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI,nPosSXG]
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

			//
			// Se o campo estiver diferente da estrutura
			//
			If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
				PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), " ", "" ), 250 ) <> ;
				PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , " ", "" ), 250 ) .AND. ;
				AllTrim( SX3->( FieldName( nJ ) ) ) <> "X3_ORDEM"

				cMsg := "O campo " + aSX3[nI][nPosCpo] + " está com o " + SX3->( FieldName( nJ ) ) + ;
				" com o conteúdo" + CRLF + ;
				"[" + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
				"que será substituido pelo NOVO conteúdo" + CRLF + ;
				"[" + RTrim( AllToChar( aSX3[nI][nJ] ) ) + "]" + CRLF + ;
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
					cTexto += "Alterado o campo " + aSX3[nI][nPosCpo] + CRLF
					cTexto += "   " + PadR( SX3->( FieldName( nJ ) ), 10 ) + " de [" + AllToChar( SX3->( FieldGet( nJ ) ) ) + "]" + CRLF
					cTexto += "            para [" + AllToChar( aSX3[nI][nJ] )          + "]" + CRLF + CRLF

					RecLock( "SX3", .F. )
					FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
					dbCommit()
					MsUnLock()
				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
----------------------------------------------------------------------------
| Rotina    | UpdSIX      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do SIX                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdSIX( cTexto )
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
// Cria indices para pesquisa por Common Name
//
/*AAdd( aSIX, { ;
	'SZT'						, ; //INDICE
	'5'							, ; //ORDEM
	'ZT_FILIAL+ZT_CONTTEC' 		, ; //CHAVE
	'E-Mail'   					, ; //DESCRICAO
	'E-Mail'   					, ; //DESCSPA
	'E-Mail'    				, ; //DESCENG
	'U'							, ; //PROPRI
	''							, ; //F3
	'ZT_CONTTEC'				, ; //NICKNAME
	'S'							} ) //SHOWPESQ
*/
//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		RecLock( "SIX", .T. )
		lDelInd := .F.
		cTexto += "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
	Else
		lAlt := .F.
		RecLock( "SIX", .F. )
	EndIf

	If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "") == ;
	    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
		aAdd( aArqUpd, aSIX[nI][1] )

		If lAlt
			lDelInd := .T. // Se for alteracao precisa apagar o indice do banco
			cTexto += "Índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
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

	oProcess:IncRegua2( "Atualizando índices..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL

/*
----------------------------------------------------------------------------
| Rotina    | UpdSX5      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do SX5                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdSX5( cTexto )
Local aEstrut   := {}
Local aSX5      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX5->X5_FILIAL )

cTexto  += "Inicio da Atualizacao" + " SX5" + CRLF + CRLF

aEstrut := {"X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}

//AAdd( aSX5, {xFilial("SX5"),"T5","SZT","COMMON NAME","COMMON NAME","COMMON NAME"})

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX5 ) )

dbSelectArea( "SX5" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX5 )
	lContinua := .F.
	lReclock  := .F.

	If !SX5->( dbSeek( PadR( aSX5[nI][1], nTamFil ) + aSX5[nI][2] + aSX5[nI][3] ) )
		lContinua := .T.
		lReclock  := .T.
		cTexto += "Foi incluído a tabela" + aSX5[nI][2] + " chave [" + aSX5[nI][3] + "]"+ CRLF
	EndIf

	If lContinua
		If !( aSX5[nI][1] $ cAlias )
			cAlias += aSX5[nI][1] + "/"
		EndIf

		RecLock( "SX5", lReclock )
		For nJ := 1 To Len( aSX5[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SX5)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX5" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL

/*
----------------------------------------------------------------------------
| Rotina    | UpdSX6      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do SX6                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdSX6( cTexto )

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
                                                                                    
/*
AAdd( aSX6, { " ","MV_UDASSUN","C",;
"Codigo padrao para o assunto no Telemarketing.","Codigo padrao para o assunto no Telemarketing.","Codigo padrao para o assunto no Telemarketing.",;
"Parametro utilizado na rotina CSFA010.prw","Parametro utilizado na rotina CSFA010.prw","Parametro utilizado na rotina CSFA010.prw",;
"","","","ATR001","ATR001","ATR001","U",""})
*/

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

cTexto += CRLF + "Final da Atualizacao" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL

/*
----------------------------------------------------------------------------
| Rotina    | UpdSX7      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do SX7                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdSX7( cTexto )

Local aEstrut   := {}
Local aSX7      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

cTexto  += "Inicio da Atualizacao" + " SX7" + CRLF + CRLF

aEstrut := { "X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI" }

/*
AAdd( aSX7, { "ZT_UF     ","001","SX5->X5_DESCRI","ZT_ESTADO ","P","S","SX5",1,'xFilial("SX5")+"12"+M->ZT_UF',"","U" })
*/

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )
	lContinua := .F.
	lReclock  := .F.

	If !SX7->( dbSeek( aSX7[nI][1] + aSX7[nI][2] ) )
		lContinua := .T.
		lReclock  := .T.
		cTexto += "Foi incluído o gatilhos " + aSX7[nI][1] + aSX7[nI][2] + " Sequencia [" + AllTrim( aSX7[nI][2] ) + "]"+ CRLF
	EndIf

	If lContinua
		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
		EndIf

		RecLock( "SX7", lReclock )
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
----------------------------------------------------------------------------
| Rotina    | UpdSXB      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do SXB                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdSXB( cTexto )
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamVar   := Len( SXB->XB_ALIAS )

cTexto  += "Inicio da Atualizacao" + " SXB" + CRLF + CRLF

aEstrut := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }

/*
AAdd( aSXB, {"SZT","1","01","DB","Common Name"        ,"Common Name"        ,"Common Name"        ,"SZT"           ,""})
AAdd( aSXB, {"SZT","2","01","01","Codigo"             ,"Codigo"             ,"Codigo             ",""              ,""})
AAdd( aSXB, {"SZT","2","02","02","Common Name+Produto","Common Name+Produto","Common Name+Produto",""              ,""})
AAdd( aSXB, {"SZT","4","01","01","Codigo"             ,"Codigo"             ,"Codigo"             ,"ZT_CODIGO"     ,""})
AAdd( aSXB, {"SZT","4","01","02","Empresa"            ,"Empresa"            ,"Empresa"            ,"ZT_EMPRESA"    ,""})
AAdd( aSXB, {"SZT","4","01","03","Common Name"        ,"Common Name"        ,"Common Name"        ,"ZT_COMMON"     ,""})
AAdd( aSXB, {"SZT","4","01","04","Produto"            ,"Produto"            ,"Produto"            ,"ZT_PRODUT"     ,""})
AAdd( aSXB, {"SZT","4","02","01","Codigo"             ,"Codigo"             ,"Codigo"             ,"ZT_CODIGO"     ,""})
AAdd( aSXB, {"SZT","4","02","02","Empresa"            ,"Empresa"            ,"Empresa"            ,"ZT_EMPRESA"    ,""})
AAdd( aSXB, {"SZT","4","02","03","Common Name"        ,"Common Name"        ,"Common Name"        ,"ZT_COMMON"     ,""})
AAdd( aSXB, {"SZT","4","02","04","Produto"            ,"Produto"            ,"Produto"            ,"ZT_PRODUT"     ,""})
AAdd( aSXB, {"SZT","5","01",""  ,""                   ,""                   ,""                   ,"SZT->ZT_CODIGO",""})
*/

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )
	lContinua := .F.
	lReclock  := .F.

	If !SXB->( dbSeek( PadR( aSXB[nI][1], nTamVar ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )
		lContinua := .T.
		lReclock  := .T.
		cTexto += "Foi incluído a consulta padrão " + aSXB[nI][1] + " " + CRLF
	EndIf

	If lContinua
		If !( aSXB[nI][1] $ cAlias )
			cAlias += aSXB[nI][1] + "/"
		EndIf

		RecLock( "SXB", lReclock )
		For nJ := 1 To Len( aSXB[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SXB)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL

/*
----------------------------------------------------------------------------
| Rotina    | UpdHlp      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao de processamento da gravacao do Helps de Campos       |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function UpdHlp( cTexto )
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

cTexto  += "Inicio da Atualizacao" + " " + "Helps de Campos" + CRLF + CRLF

oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

/*
aHlpPor := {}
aAdd( aHlpPor, 'Código do registro.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZT_CODIGO ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZT_CODIGO " + CRLF
*/

cTexto += CRLF + "Final da Atualizacao" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return {}


/*
----------------------------------------------------------------------------
| Rotina    | UpdSX3      | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao Generica para escolha de Empresa, montado pelo SM0_   |
|           | Retorna vetor contendo as selecoes feitas.                   |
|           | Se nao For marcada nenhuma o vetor volta vazio.              |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function EscEmpresa()

// Parametro  nTipo                           
// 1  - Monta com Todas Empresas/Filiais      
// 2  - Monta so com Empresas                 
// 3  - Monta so com Filiais de uma Empresa   
//                                            
// Parametro  aMarcadas                       
// Vetor com Empresas/Filiais pre marcadas    
//                                            
// Parametro  cEmpSel                         
// Empresa que sera usada para montar selecao 

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
@ 123, 45 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
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



/*
----------------------------------------------------------------------------
| Rotina    | MarcaTodos  | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao Auxiliar para marcar/desmarcar todos os itens do      |
|           | ListBox ativo.                                               |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
----------------------------------------------------------------------------
| Rotina    | InvSelecao  | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao Auxiliar para inverter selecao do ListBox Ativo       |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


/*
----------------------------------------------------------------------------
| Rotina    | RetSelecao  | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao Auxiliar que monta o retorno com as selecoes          |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
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
----------------------------------------------------------------------------
| Rotina    | MarcaMas    | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Funcao para marcar e desmarcar usando mascaras               |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
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
----------------------------------------------------------------------------
| Rotina    | VerTodos    | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Verifica se estao todos marcados ou desmarcados              |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
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
----------------------------------------------------------------------------
| Rotina    | MyOpenSM0   | Autor | TOTVS Protheus   | Data | 30.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Abertura de SM0 em modo exclusivo.                           |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
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
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen