#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � UPDREN01 � Autor � TOTVS Protheus     � Data �  19/08/2014 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de update dos dicion�rios para compatibiliza��o     ���
��� Campos utilizados no ponto de entrada do Border� por segmento         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function UPDREN01(cEmpAmb,cFilAmb)

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZA��O DE DICION�RIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como fun��o fazer  a atualiza��o  dos dicion�rios do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja n�o podem haver outros"
Local   cDesc3    := "usu�rios  ou  jobs utilizando  o sistema.  � extremamente recomendav�l  que  se  fa�a um"
Local   cDesc4    := "BACKUP  dos DICION�RIOS  e da  BASE DE DADOS antes desta atualiza��o, para que caso "
Local   cDesc5    := "ocorra eventuais falhas, esse backup seja ser restaurado."
Local   cDesc6    := ""
Local   cDesc7    := ""
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )
Local   cTexto    := ""

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
		If lAuto .OR. MsgNoYes( "Confirma a atualiza��o dos dicion�rios ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()
			
			If lAuto
				If lOk
					MsgStop( "Atualiza��o Realizada.", "UPDREN01" )
					dbCloseAll()
				Else
					MsgStop( "Atualiza��o n�o Realizada.", "UPDREN01" )
					dbCloseAll()
				EndIf
			Else
				If lOk
					Final( "Atualiza��o Conclu�da." )
				Else
					Final( "Atualiza��o n�o Realizada." )
				EndIf
			EndIf
			
		Else
			MsgStop( "Atualiza��o n�o Realizada.", "UPDREN01" )
			
		EndIf
		
	Else
		MsgStop( "Atualiza��o n�o Realizada.", "UPDREN01" )
		
	EndIf
	
EndIf

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSTProc  � Autor � TOTVS Protheus     � Data �  24/09/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da grava��o dos arquivos           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSTProc    - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				MsgStop( "Atualiza��o da empresa " + aRecnoSM0[nI][2] + " n�o efetuada." )
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
			
			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX2         �
			//������������������������������������
			//oProcess:IncRegua1( "Dicion�rio de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			//FSAtuSX2(@cTexto)
			
			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX3         �
			//������������������������������������
			FSAtuSX3( @cTexto )
			
			//------------------------------------
			// Atualiza os helps
			//------------------------------------
			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuHlp( @cTexto )
			
			//------------------------------------
			// Atualiza o dicion�rio SX5
			//------------------------------------
			oProcess:IncRegua1( "Dicionario de dados do sistema"  + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )//"Diccionario de tablas sistema"
			FSAtuSX5( @cTexto )
			
			
			//------------------------------------
			// Atualiza o dicion�rio SX6
			//------------------------------------
			oProcess:IncRegua1( "Dicion�rio de parametros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6( @cTexto)
			
			
			
			//------------------------------------
			// Atualiza o dicion�rio SX7
			//------------------------------------
			//oProcess:IncRegua1( "Dicion�rio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			//FSAtuSX7( @cTexto)
			
			
			//------------------------------------
			// Atualiza o dicion�rio SXB
			//------------------------------------
			//oProcess:IncRegua1( "Dicion�rio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			//FSAtuSXB( @cTexto)
			
			
			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SIX         �
			//������������������������������������
			//oProcess:IncRegua1( "Dicion�rio de �ndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			//FSAtuSIX( @cTexto )
			
			
			oProcess:IncRegua1( "Dicion�rio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/�ndices" )
			
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
					MsgStop( "Ocorreu um erro desconhecido durante a atualiza��o da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicion�rio e da tabela.", "ATEN��O" )
					cTexto += "Ocorreu um erro desconhecido durante a atualiza��o da estrutura da tabela : " + aArqUpd[nX] + CRLF
				EndIf
				
				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf
				
			Next nX
			
			RpcClearEnv()
			
		Next nI
		
		If MyOpenSm0(.T.)
			
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += "LOG DA ATUALIZACAO DOS DICION�RIOS" + CRLF
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX2 � Autor � TOTVS Protheus     � Data �  24/09/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX2 - Arquivos      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX2   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX2(cTexto)
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SX2" + CRLF + CRLF

{ "X2_DELET"  , "X2_MODO"   , "X2_TTS"    , "X2_ROTINA", "X2_PYME"   , "X2_UNICO"  , ;
  "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }

DbSelectArea("SX2")
SX2->(DbSetOrder(1))
SX2->(DbGoTop())

cPath := SX2->X2_PATH
cPath := If(Right(AllTrim(cPath),1) <> "\", PadR(AllTrim(cPath) + "\", Len(cPath)),cPath)
cEmpr := SubStr(SX2->X2_ARQUIVO,4)

//
// Tabela PB6
//
aAdd( aSX2, { ;
'PB6'																	, ; //X2_CHAVE
cPath																	, ; //X2_PATH
'PB6'+cEmpr																, ; //X2_ARQUIVO
'POLITICA DE VENDAS E  COMPRAS'											, ; //X2_NOME
'POLITICA DE VENDAS E  COMPRAS'											, ; //X2_NOMESPA
'POLITICA DE VENDAS E  COMPRAS'											, ; //X2_NOMEENG
0																		, ; //X2_DELET
'C'																		, ; //X2_MODO
''																		, ; //X2_TTS
''																		, ; //X2_ROTINA
''																		, ; //X2_PYME
'PB6_FILIAL+PB6_COD'													, ; //X2_UNICO
'E'																		, ; //X2_MODOEMP
'E'																		, ; //X2_MODOUN
0																		} ) //X2_MODULO

// Atualizando dicion�rio
oProcess:SetRegua2(Len(aSX2))

DbSelectArea("SX2")
DbSetOrder(1)

For nI := 1 To Len(aSX2)
	
	oProcess:IncRegua2("Atualizando Arquivos (SX2)...")
	
	If !SX2->(DbSeek(aSX2[nI][1]))
		
		If !(aSX2[nI][1] $ cAlias)
			cAlias += aSX2[nI][1] + "/"
			cTexto += "Foi inclu�da a tabela " + aSX2[nI][1] + CRLF
		EndIf
		
		RecLock("SX2",.T.)
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
		
		If  !(StrTran(Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			If MSFILE(RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX3 � Autor � TOTVS Protheus     � Data �  24/09/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX3 - Campos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX3   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX3(cTexto)
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


/////////
// SA2 //
/////////

aAdd( aSX3, { ;
'SA2'																	, ; //X3_ARQUIVO
'XX'																	, ; //X3_ORDEM
'A2_XTPCONT'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
1																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Tp Conta Bco'															, ; //X3_TITULO
'Tp Conta Bco'															, ; //X3_TITSPA
'Tp Conta Bco'															, ; //X3_TITENG
'Tp Conta Bco'															, ; //X3_DESCRIC
'Tp Conta Bco'												, ; //X3_DESCSPA
'Tp Conta Bco'												, ; //X3_DESCENG
'@!'																		, ; //X3_PICTURE
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
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
'Pertence("123")'													, ; //X3_VLDUSER
'1=Conta Corrente;2=Conta Investimento;3=Poupan�a'   			, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
'2'																		, ; //X3_FOLDER
''																		} ) //X3_PYME



/////////
// SE2 //
/////////


aAdd( aSX3, { ;
'SE2'																	, ; //X3_ARQUIVO
'XX'																	, ; //X3_ORDEM
'E2_XCODPGT'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
1																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'C�d Bor Aut'															, ; //X3_TITULO
'C�d Bor Aut'															, ; //X3_TITSPA
'C�d Bor Aut'															, ; //X3_TITENG
'C�d pagto Bor Aut'															, ; //X3_DESCRIC
'C�d pagto Bor Aut'												, ; //X3_DESCSPA
'C�d pagto Bor Aut'												, ; //X3_DESCENG
'@!'																		, ; //X3_PICTURE
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
'S'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
'Pertence("1234")'													, ; //X3_VLDUSER
'1=Autom�tico;2=N�o Considera;3=Ordem Pagto;4=Concession�ria'   , ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		} ) //X3_PYME

/////////
// SEA //
/////////


aAdd( aSX3, { ;
'SEA'																	, ; //X3_ARQUIVO
'XX'																	, ; //X3_ORDEM
'EA_XIDPROC'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
2																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Ident Proces'															, ; //X3_TITULO
'Ident Proces'															, ; //X3_TITSPA
'Ident Proces'															, ; //X3_TITENG
'Ident Processament'															, ; //X3_DESCRIC
'Ident Processament'												, ; //X3_DESCSPA
'Ident Processament'												, ; //X3_DESCENG
'@!'																		, ; //X3_PICTURE
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
''													, ; //X3_VLDUSER
''   , ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		} ) //X3_PYME




// Atualizando dicion�rio
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
	
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
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
			
			//
			// Se o campo estiver diferente da estrutura
			//
			If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
				PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), " ", "" ), 250 ) <> ;
				PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , " ", "" ), 250 ) .AND. ;
				AllTrim( SX3->( FieldName( nJ ) ) ) <> "X3_ORDEM"
				
				cMsg := "O campo " + aSX3[nI][nPosCpo] + " est� com o " + SX3->( FieldName( nJ ) ) + ;
				" com o conte�do" + CRLF + ;
				"[" + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
				"que ser� substituido pelo NOVO conte�do" + CRLF + ;
				"[" + RTrim( AllToChar( aSX3[nI][nJ] ) ) + "]" + CRLF + ;
				"Deseja substituir ? "
				
				If      lTodosSim
					nOpcA := 1
				ElseIf  lTodosNao
					nOpcA := 2
				Else
					nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SX3" )
					lTodosSim := ( nOpcA == 3 )
					lTodosNao := ( nOpcA == 4 )
					
					If lTodosSim
						nOpcA := 1
						lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SX3 e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
					EndIf
					
					If lTodosNao
						nOpcA := 2
						lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SX3 que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSIX � Autor � TOTVS Protheus     � Data �  24/09/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SIX - Indices       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSIX   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSIX(cTexto)
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SIX" + CRLF + CRLF

aEstrut := {"INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA" ,;
"DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ"}

//
// Tabela PB6
//
aAdd( aSIX, { ;
'PB6'																	, ; //INDICE
'1'																		, ; //ORDEM
'PB6_FILIAL+PB6_COD'													, ; //CHAVE
'Filial+Codigo'															, ; //DESCRICAO
'Filial+Codigo'															, ; //DESCSPA
'Filial+Codigo'															, ; //DESCENG
'U'																		, ; //PROPRI
''																		, ; //F3
''																		, ; //NICKNAME
'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
'PB6'																	, ; //INDICE
'2'																		, ; //ORDEM
'PB6_FILIAL+PB6_TIPO+PB6_B1GRP'											, ; //CHAVE
'Filial+Tipo+Grupo'														, ; //DESCRICAO
'Filial+Tipo+Grupo'														, ; //DESCSPA
'Filial+Tipo+Grupo'														, ; //DESCENG
'U'																		, ; //PROPRI
''																		, ; //F3
''																		, ; //NICKNAME
'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
'PB6'																	, ; //INDICE
'3'																		, ; //ORDEM
'PB6_FILIAL+PB6_TIPO+PB6_A1GRP'											, ; //CHAVE
'Filial+Tipo+GrupoCliente'												, ; //DESCRICAO
'Filial+Tipo+GrupoCliente'												, ; //DESCSPA
'Filial+Tipo+GrupoCliente'												, ; //DESCENG
'U'																		, ; //PROPRI
''																		, ; //F3
''																		, ; //NICKNAME
'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
'PB6'																	, ; //INDICE
'4'																		, ; //ORDEM
'PB6_FILIAL+PB6_TIPO+PB6_CLIENT+PB6_LOJA'								, ; //CHAVE
'Filial+Tipo+Cliente+Loja'												, ; //DESCRICAO
'Filial+Tipo+Cliente+Loja'												, ; //DESCSPA
'Filial+Tipo+Cliente+Loja'												, ; //DESCENG
'U'																		, ; //PROPRI
''																		, ; //F3
''																		, ; //NICKNAME
'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
'PB6'																	, ; //INDICE
'5'																		, ; //ORDEM
'PB6_FILIAL+PB6_DESCR'													, ; //CHAVE
'Filial+Descricao'														, ; //DESCRICAO
'Filial+Descricao'														, ; //DESCSPA
'Filial+Descricao'														, ; //DESCENG
'U'																		, ; //PROPRI
''																		, ; //F3
''																		, ; //NICKNAME
'S'																		} ) //SHOWPESQ

// Atualizando dicion�rio
oProcess:SetRegua2(Len(aSIX))

DbSelectArea("SIX")
SIX->(DbSetOrder(1))

For nI := 1 To Len(aSIX)
	
	lAlt    := .F.
	lDelInd := .F.
	
	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		cTexto += "�ndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "") == ;
			StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			cTexto += "Chave do �ndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
			lDelInd := .T. // Se for alteracao precisa apagar o indice do banco
		Else
			cTexto += "Indice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
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
	
	oProcess:IncRegua2( "Atualizando �ndices..." )
	
Next nI

cTexto += CRLF + "Final da Atualizacao" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �ESCEMPRESA�Autor  �                    � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Generica para escolha de Empresa, montado pelo SM0_ ���
���          � Retorna vetor contendo as selecoes feitas.                 ���
���          � Se nao For marcada nenhuma o vetor volta vazio.            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function EscEmpresa()
//��������������������������������������������Ŀ
//� Parametro  nTipo                           �
//� 1  - Monta com Todas Empresas/Filiais      �
//� 2  - Monta so com Empresas                 �
//� 3  - Monta so com Filiais de uma Empresa   �
//�                                            �
//� Parametro  aMarcadas                       �
//� Vetor com Empresas/Filiais pre marcadas    �
//�                                            �
//� Parametro  cEmpSel                         �
//� Empresa que sera usada para montar selecao �
//����������������������������������������������
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

oDlg:cToolTip := "Tela para M�ltiplas Sele��es de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza��o"

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
Message "Inverter Sele��o" Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "M�scara Empresa ( ?? )"  Of oDlg
@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando m�scara ( ?? )"    Of oDlg
@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando m�scara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Sele��o"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Sele��o" Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �MARCATODOS�Autor  �                    � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para marcar/desmarcar todos os itens do    ���
���          � ListBox ativo                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �INVSELECAO�Autor  �                    � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para inverter selecao do ListBox Ativo     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �RETSELECAO�Autor  �                    � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar que monta o retorno com as selecoes        ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � MARCAMAS �Autor  �                     � Data �  20/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para marcar/desmarcar usando mascaras               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � VERTODOS �Autor  �                    � Data �  20/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao auxiliar para verificar se estao todos marcardos    ���
���          � ou nao                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � MyOpenSM0� Autor � TOTVS Protheus     � Data �  24/09/2013 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento abertura do SM0 modo exclusivo     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	MsgStop( "N�o foi poss�vel a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN��O" )
EndIf

Return lOpen

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX7
Fun��o de processamento da grava��o do SX7 - Gatilhos

@author TOTVS Protheus
@since  28/08/2014
@obs    Gerado por EXPORDIC - V.4.22.9.6 EFS / Upd. V.4.19.11 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX7()
Local aEstrut   := {}
Local aAreaSX3  := SX3->( GetArea() )
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

cTexto  := "Inicio da Atualizacao" + " SX7" + CRLF + CRLF

aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
"X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

aAdd( aSX7, { ;
'C5_CLIENTE'															, ; //X7_CAMPO
'004'																	, ; //X7_SEQUENC
'U_RFATM04D(M->C5_CLIENTE,M->C5_LOJACLI,"SA1")'				, ; //X7_REGRA
'C5_XPB6COD'															, ; //X7_CDOMIN
'P'																		, ; //X7_TIPO
'N'																		, ; //X7_SEEK
''																		, ; //X7_ALIAS
0																		, ; //X7_ORDEM
''																		, ; //X7_CHAVE
'U'																		, ; //X7_PROPRI
''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
'C5_LOJACLI'															, ; //X7_CAMPO
'004'																	, ; //X7_SEQUENC
'U_RFATM04D(M->C5_CLIENTE,M->C5_LOJACLI,"SA1")'				, ; //X7_REGRA
'C5_XPB6COD'															, ; //X7_CDOMIN
'P'																		, ; //X7_TIPO
'N'																		, ; //X7_SEEK
''																		, ; //X7_ALIAS
0																		, ; //X7_ORDEM
''																		, ; //X7_CHAVE
'U'																		, ; //X7_PROPRI
''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
'A1_XGRECON'															, ; //X7_CAMPO
'001'																	, ; //X7_SEQUENC
'cTod("  /  /    ")'																	, ; //X7_REGRA
'A1_VENCLC'															, ; //X7_CDOMIN
'P'																		, ; //X7_TIPO
'N'																		, ; //X7_SEEK
''																		, ; //X7_ALIAS
0																		, ; //X7_ORDEM
''																		, ; //X7_CHAVE
'U'																		, ; //X7_PROPRI
''																		} ) //X7_CONDIC


//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )
	
	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )
		
		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			AutoGrLog( "Foi inclu�do o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
		EndIf
		
		RecLock( "SX7", .T. )
	Else
		
		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			AutoGrLog( "Foi alterado o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
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
	
	If SX3->( dbSeek( SX7->X7_CAMPO ) )
		RecLock( "SX3", .F. )
		SX3->X3_TRIGGER := "S"
		MsUnLock()
	EndIf
	
	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )
	
Next nI

RestArea( aAreaSX3 )

cTexto += CRLF + "Final da Atualizacao" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
//AutoGrLog( CRLF + "Final da Atualiza��o" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSXB � Autor � TOTVS Protheus     � Data �  22/05/2014 ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SXB - Consultas Pad ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSXB   - Gerado por EXPORDIC / Upd. V.4.7.2 EFS        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSXB( cTexto )
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

cTexto  += "Inicio da Atualizacao" + " SXB" + CRLF + CRLF

aEstrut := { "XB_ALIAS",  "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , ;
"XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM" }

//
// Consulta PB6ENT
//

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'1'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'DB'																	, ; //XB_COLUNA
'Politicas de Compra'													, ; //XB_DESCRI
'Politicas de Compra'													, ; //XB_DESCSPA
'Politicas de Compra'													, ; //XB_DESCENG
'PB6'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Filial+codigo'															, ; //XB_DESCRI
'Filial+codigo'															, ; //XB_DESCSPA
'Filial+codigo'															, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'05'																	, ; //XB_COLUNA
'Filial+descricao'														, ; //XB_DESCRI
'Filial+descricao'														, ; //XB_DESCSPA
'Filial+descricao'														, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Codigo'																, ; //XB_DESCENG
'PB6_COD'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Descricao'																, ; //XB_DESCRI
'Descricao'																, ; //XB_DESCSPA
'Descricao'																, ; //XB_DESCENG
'PB6_DESCR'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Codigo'																, ; //XB_DESCENG
'PB6_COD'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Descricao'																, ; //XB_DESCRI
'Descricao'																, ; //XB_DESCSPA
'Descricao'																, ; //XB_DESCENG
'PB6_DESCR'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'5'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'PB6->PB6_COD'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6ENT'																, ; //XB_ALIAS
'6'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
"PB6_TIPO='P'"															} ) //XB_CONTEM

//
// Consulta PB6SAI
//


aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'1'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'DB'																	, ; //XB_COLUNA
'Politica de Vendas'													, ; //XB_DESCRI
'Politica de Vendas'													, ; //XB_DESCSPA
'Politica de Vendas'													, ; //XB_DESCENG
'PB6'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Filial+codigo'															, ; //XB_DESCRI
'Filial+codigo'															, ; //XB_DESCSPA
'Filial+codigo'															, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'05'																	, ; //XB_COLUNA
'Filial+descricao'														, ; //XB_DESCRI
'Filial+descricao'														, ; //XB_DESCSPA
'Filial+descricao'														, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Codigo'																, ; //XB_DESCENG
'PB6_COD'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Descricao'																, ; //XB_DESCRI
'Descricao'																, ; //XB_DESCSPA
'Descricao'																, ; //XB_DESCENG
'PB6_DESCR'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Codigo'																, ; //XB_DESCENG
'PB6_COD'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Descricao'																, ; //XB_DESCRI
'Descricao'																, ; //XB_DESCSPA
'Descricao'																, ; //XB_DESCENG
'PB6_DESCR'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'5'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'PB6->PB6_COD'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'PB6SAI'																, ; //XB_ALIAS
'6'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
"PB6_TIPO='R'"															} ) //XB_CONTEM

//
// Consulta SA1
//
aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'1'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'DB'																	, ; //XB_COLUNA
'Cliente'																, ; //XB_DESCRI
'Cliente'																, ; //XB_DESCSPA
'Customer'																, ; //XB_DESCENG
'SA1'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Nome'																	, ; //XB_DESCRI
'Nombre'																, ; //XB_DESCSPA
'Name'																	, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'03'																	, ; //XB_SEQ
'03'																	, ; //XB_COLUNA
'CNPJ/CPF'																, ; //XB_DESCRI
'CNPJ/CPF'																, ; //XB_DESCSPA
'CNPJ/CPF'																, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'3'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Cadastra Novo'															, ; //XB_DESCRI
'Incluye Nuevo'															, ; //XB_DESCSPA
'Add New'																, ; //XB_DESCENG
'01'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
'A1_COD'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Loja'																	, ; //XB_DESCRI
'Tienda'																, ; //XB_DESCSPA
'Store'																	, ; //XB_DESCENG
'A1_LOJA'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'03'																	, ; //XB_COLUNA
'Nome'																	, ; //XB_DESCRI
'Nombre'																, ; //XB_DESCSPA
'Name'																	, ; //XB_DESCENG
'A1_NOME'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'04'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
'A1_COD'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'05'																	, ; //XB_COLUNA
'Loja'																	, ; //XB_DESCRI
'Tienda'																, ; //XB_DESCSPA
'Store'																	, ; //XB_DESCENG
'A1_LOJA'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
'06'																	, ; //XB_COLUNA
'Nome'																	, ; //XB_DESCRI
'Nombre'																, ; //XB_DESCSPA
'Name'																	, ; //XB_DESCENG
'A1_NOME'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'03'																	, ; //XB_SEQ
'07'																	, ; //XB_COLUNA
'CNPJ/CPF'																, ; //XB_DESCRI
'CNPJ/CPF'																, ; //XB_DESCSPA
'CNPJ/CPF'																, ; //XB_DESCENG
'A1_CGC'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'03'																	, ; //XB_SEQ
'08'																	, ; //XB_COLUNA
'Nome'																	, ; //XB_DESCRI
'Nombre'																, ; //XB_DESCSPA
'Name'																	, ; //XB_DESCENG
'A1_NOME'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'5'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'SA1->A1_COD'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'SA1PB6'																	, ; //XB_ALIAS
'5'																		, ; //XB_TIPO
'02'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'SA1->A1_LOJA'															} ) //XB_CONTEM

//
// Consulta SBM
//
aAdd( aSXB, { ;
'SBMPB6'																	, ; //XB_ALIAS
'1'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'DB'																	, ; //XB_COLUNA
'Grupo'																	, ; //XB_DESCRI
'Grupo'																	, ; //XB_DESCSPA
'Group'																	, ; //XB_DESCENG
'SBM'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'SBMPB6'																	, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'SBMPB6'																	, ; //XB_ALIAS
'3'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Cadastra Novo'															, ; //XB_DESCRI
'Registra Nuevo'														, ; //XB_DESCSPA
'Add New'																, ; //XB_DESCENG
'01'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'SBMPB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
'SBM->BM_GRUPO'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'SBMPB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Descricao'																, ; //XB_DESCRI
'Descripcion'															, ; //XB_DESCSPA
'Description'															, ; //XB_DESCENG
'SBM->BM_DESC'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'SBMPB6'																	, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'03'																	, ; //XB_COLUNA
'Marca'																	, ; //XB_DESCRI
'Marca'																	, ; //XB_DESCSPA
'Brand'																	, ; //XB_DESCENG
'SBM->BM_CODMAR'														} ) //XB_CONTEM

aAdd( aSXB, { ;
'SBMPB6'																	, ; //XB_ALIAS
'5'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'SBM->BM_GRUPO'															} ) //XB_CONTEM

//
// Consulta SE4SAI
//
aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'1'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'DB'																	, ; //XB_COLUNA
'COND PGTO X PRZ MED'													, ; //XB_DESCRI
'COND PGTO X PRZ MED'													, ; //XB_DESCSPA
'COND PGTO X PRZ MED'													, ; //XB_DESCENG
'SE4'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
'E4_CODIGO'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Cond. Pagto'															, ; //XB_DESCRI
'Cond. Pago'															, ; //XB_DESCSPA
'Payment Term'															, ; //XB_DESCENG
'E4_COND'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'03'																	, ; //XB_COLUNA
'Descricao'																, ; //XB_DESCRI
'Descripcion'															, ; //XB_DESCSPA
'Description'															, ; //XB_DESCENG
'E4_DESCRI'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'04'																	, ; //XB_COLUNA
'Prazo Medio'															, ; //XB_DESCRI
'Prazo Medio'															, ; //XB_DESCSPA
'Prazo Medio'															, ; //XB_DESCENG
'E4_PRZMED'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'5'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'SE4->E4_CODIGO'														} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4SAI'																, ; //XB_ALIAS
'6'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'U_RFATM04G()'  														} ) //XB_CONTEM


aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'1'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'DB'																	, ; //XB_COLUNA
'COND PGTO X PRZ MED'												, ; //XB_DESCRI
'COND PGTO X PRZ MED'												, ; //XB_DESCSPA
'COND PGTO X PRZ MED'												, ; //XB_DESCENG
'SE4'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'2'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'01'																	, ; //XB_COLUNA
'Codigo'																, ; //XB_DESCRI
'Codigo'																, ; //XB_DESCSPA
'Code'																	, ; //XB_DESCENG
'E4_CODIGO'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'02'																	, ; //XB_COLUNA
'Cond. Pagto'															, ; //XB_DESCRI
'Cond. Pago'															, ; //XB_DESCSPA
'Payment Term'														, ; //XB_DESCENG
'E4_COND'																} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'03'																	, ; //XB_COLUNA
'Descricao'															, ; //XB_DESCRI
'Descripcion'															, ; //XB_DESCSPA
'Description'															, ; //XB_DESCENG
'E4_DESCRI'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'4'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
'04'																	, ; //XB_COLUNA
'Prazo Medio'															, ; //XB_DESCRI
'Prazo Medio'															, ; //XB_DESCSPA
'Prazo Medio'															, ; //XB_DESCENG
'E4_PRZMED'															} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'5'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'SE4->E4_CODIGO'														} ) //XB_CONTEM

aAdd( aSXB, { ;
'SE4FOR'																, ; //XB_ALIAS
'6'																		, ; //XB_TIPO
'01'																	, ; //XB_SEQ
''																		, ; //XB_COLUNA
''																		, ; //XB_DESCRI
''																		, ; //XB_DESCSPA
''																		, ; //XB_DESCENG
'U_RFATM008("","")'  														} ) //XB_CONTEM





//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )
	
	If !Empty( aSXB[nI][1] )
		
		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )
			
			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				cTexto += "Foi inclu�da a consulta padr�o " + aSXB[nI][1] + CRLF
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
				
				//
				// Se o campo estiver diferente da estrutura
				//
				If aEstrut[nJ] == SXB->( FieldName( nJ ) ) .AND. ;
					!StrTran( AllToChar( SXB->( FieldGet( nJ ) ) ), " ", "" ) == ;
					StrTran( AllToChar( aSXB[nI][nJ]            ), " ", "" )
					
					cMsg := "A consulta padrao " + aSXB[nI][1] + " est� com o " + SXB->( FieldName( nJ ) ) + ;
					" com o conte�do" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
					", e este � diferente do conte�do" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "
					
					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )
						
						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SXB e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
						EndIf
						
						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SXB que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
						EndIf
						
					EndIf
					
					If nOpcA == 1
						RecLock( "SXB", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						dbCommit()
						MsUnLock()
						
						If !( aSXB[nI][1] $ cAlias )
							cAlias += aSXB[nI][1] + "/"
							cTexto += "Foi Alterada a consulta padrao " + aSXB[nI][1] + CRLF
						EndIf
						
					EndIf
					
				EndIf
				
			Next
			
		EndIf
		
	EndIf
	
	oProcess:IncRegua2( "Atualizando Consultas Padroes (SXB)..." )
	
Next nI

cTexto += CRLF + "Final da Atualizacao" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return aClone( aSXB )


*------------------------*
Static Function fsAtuSX6()
*------------------------*
Local cTexto         := ''

IF !SX6->(DbSeek(xFilial()+"ZZ_NATIPTU"))
	RecLock("SX6",.T.)
	SX6->X6_FIL     := "  "
	SX6->X6_VAR     := "ZZ_NATIPTU"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Natureza utilizada pelos t�tulos de IPTU."
	SX6->X6_DSCSPA  := "Natureza utilizada pelos t�tulos de IPTU."
	SX6->X6_DSCENG  := "Natureza utilizada pelos t�tulos de IPTU."
	SX6->X6_DESC1   := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCSPA1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCENG1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_CONTEUD := "2328"
	SX6->X6_CONTSPA := ""
	SX6->X6_CONTENG := ""
	SX6->X6_PROPRI  := "S"
	SX6->X6_PYME    := "N"
	cTexto += CRLF + "Parametro ZZ_NATIPTU incluso com sucesso." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
Else
	cTexto += CRLF + "Parametro ZZ_NATIPTU existente no dicionario." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
EndIf

IF !SX6->(DbSeek(xFilial()+"ZZ_NATICMS"))
	RecLock("SX6",.T.)
	SX6->X6_FIL     := "  "
	SX6->X6_VAR     := "ZZ_NATICMS"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Natureza utilizada pelos t�tulos de ICMS."
	SX6->X6_DSCSPA  := "Natureza utilizada pelos t�tulos de ICMS."
	SX6->X6_DSCENG  := "Natureza utilizada pelos t�tulos de ICMS."
	SX6->X6_DESC1   := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCSPA1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCENG1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_CONTEUD := "2411"
	SX6->X6_CONTSPA := ""
	SX6->X6_CONTENG := ""
	SX6->X6_PROPRI  := "S"
	SX6->X6_PYME    := "N"
	cTexto += CRLF + "Parametro ZZ_NATICMS incluso com sucesso." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
Else
	cTexto += CRLF + "Parametro ZZ_NATICMS existente no dicionario." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
EndIf

IF !SX6->(DbSeek(xFilial()+"ZZ_NATISS"))
	RecLock("SX6",.T.)
	SX6->X6_FIL     := "  "
	SX6->X6_VAR     := "ZZ_NATISS"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Natureza utilizada pelos t�tulos de ISS."
	SX6->X6_DSCSPA  := "Natureza utilizada pelos t�tulos de ISS."
	SX6->X6_DSCENG  := "Natureza utilizada pelos t�tulos de ISS."
	SX6->X6_DESC1   := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCSPA1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCENG1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_CONTEUD := "2411"
	SX6->X6_CONTSPA := ""
	SX6->X6_CONTENG := ""
	SX6->X6_PROPRI  := "S"
	SX6->X6_PYME    := "N"
	cTexto += CRLF + "Parametro ZZ_NATISS incluso com sucesso." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
Else
	cTexto += CRLF + "Parametro ZZ_NATISS existente no dicionario." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
EndIf

IF !SX6->(DbSeek(xFilial()+"ZZ_NATCONC"))
	RecLock("SX6",.T.)
	SX6->X6_FIL     := "  "
	SX6->X6_VAR     := "ZZ_NATCONC"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Natureza utilizada pelos t�tulos de concession�ria"
	SX6->X6_DSCSPA  := "Natureza utilizada pelos t�tulos de concession�ria"
	SX6->X6_DSCENG  := "Natureza utilizada pelos t�tulos de concession�ria"
	SX6->X6_DESC1   := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCSPA1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_DSCENG1 := "Usado pelo PE F240TBOR(separar naturezas com /)"
	SX6->X6_CONTEUD := "2318/2319"
	SX6->X6_CONTSPA := ""
	SX6->X6_CONTENG := ""
	SX6->X6_PROPRI  := "S"
	SX6->X6_PYME    := "N"
	cTexto += CRLF + "Parametro ZZ_NATCONC incluso com sucesso." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
Else
	cTexto += CRLF + "Parametro ZZ_NATCONC existente no dicionario." + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF
EndIf


Return cTexto


Static Function FSAtuHlp( cTexto )
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

cTexto  += "�nicio da Atualiza��o" + " " + "Helps de Campos" + CRLF + CRLF


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

//
// Helps Tabela SA1
//

aHlpPor := {}
aAdd( aHlpPor, 'Tipo da conta banc�ria' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "A2_XTPCONT    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "A2_XTPCONT" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Campo utilizado no momento da gera��o do border� onde:' )
aAdd( aHlpPor, '1-Classifica o modelo do t�tulo autom�ticamente' )
aAdd( aHlpPor, '2-O t�tulo n�o � considerado na gera��o do border�' )
aAdd( aHlpPor, '3-Classifica o t�tulo no modelo de pagto 04 (Ordem de pagamento)' )
aAdd( aHlpPor, '4-Classifica o t�tulo no modelo de pagto 13 (Concession�ria) ' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "E2_XCODPGT    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "E2_XCODPGT" + CRLF


aHlpPor := {}
aAdd( aHlpPor, 'Identificador do processamento. Utilizado pelo ponto de entrada F240TBOR' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "EA_XIDPROC    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "EA_XIDPROC" + CRLF





cTexto += CRLF + "Final da Atualiza��o" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return {}

Static Function FSAtuSX5( cTexto )
Local aEstrut   := {}
Local aSX5      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamFil   := Len( SX5->X5_FILIAL )

cTexto  += "In�cio da atualiza��o do SX5"  + CRLF + CRLF //"�nicio da Atualiza��o SX5"

aEstrut := { "X5_FILIAL", "X5_TABELA", "X5_CHAVE", "X5_DESCRI", "X5_DESCSPA", "X5_DESCENG" }

// Tabela 00
//
/*
aAdd( aSX5, { ;
'  '																	, ; //X5_FILIAL
'00'																	, ; //X5_TABELA
'58'																	, ; //X5_CHAVE
'FORMA DE LANCAMENTO - SISPAG'														, ; //X5_DESCRI
'FORMA DE ASIENTO - SISPAG'														, ; //X5_DESCSPA
'ENTRY FORM - SISPAG'														} ) //X5_DESCENG
*/
//
// Tabela 58
//
aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'58'																	, ; //X5_TABELA
	'ZZ'																, ; //X5_CHAVE
	'BORDERO POR SEGMENTO'													, ; //X5_DESCRI
	'BORDERO POR SEGMENTO'																, ; //X5_DESCSPA
	'BORDERO POR SEGMENTO'																} ) //X5_DESCENG
	
aAdd( aSX5, { ;
	'  '																	, ; //X5_FILIAL
	'58'																	, ; //X5_TABELA
	'ZU'																, ; //X5_CHAVE
	'BORDERO UNICO EMPRESA'																, ; //X5_DESCRI
	'BORDERO UNICO EMPRESA'																, ; //X5_DESCSPA
	'BORDERO UNICO EMPRESA'																} ) //X5_DESCENG


//
// Actualizando dicion�rio
//
oProcess:SetRegua2( Len( aSX5 ) )

dbSelectArea( "SX5" )
SX5->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX5 )
	
	oProcess:IncRegua2( "Atualizando tabelas" ) //"Actualizando tablas..."
	
	If !SX5->( dbSeek( PadR( aSX5[nI][1], nTamFil ) + aSX5[nI][2] + aSX5[nI][3] ) )
		cTexto += "Item criado"   + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] + CRLF // "Item de la tabla creado. Tabla "
		RecLock( "SX5", .T. )
	Else
		cTexto += "Item modificado"  + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] + CRLF //"Item de la tabla modificado. Tabla "
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

cTexto += CRLF + "Final da adtualiza��o" + " SX5" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF //"Final de Actualizaci�n"

Return NIL
