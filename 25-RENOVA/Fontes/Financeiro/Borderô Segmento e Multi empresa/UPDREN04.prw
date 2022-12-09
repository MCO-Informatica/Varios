#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ UPDREN04 ∫ Autor ≥ TOTVS Protheus     ∫ Data ≥  19/08/2014 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de update dos dicion·rios para compatibilizaÁ„o     ≥±±
±±∫ Cadastro de borderÙ por empresa										  ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function UPDREN04(cEmpAmb,cFilAmb)

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZA«√O DE DICION¡RIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como funÁ„o fazer  a atualizaÁ„o  dos dicion·rios do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja n„o podem haver outros"
Local   cDesc3    := "usu·rios  ou  jobs utilizando  o sistema.  … extremamente recomendavÈl  que  se  faÁa um"
Local   cDesc4    := "BACKUP  dos DICION¡RIOS  e da  BASE DE DADOS antes desta atualizaÁ„o, para que caso "
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
		If lAuto .OR. MsgNoYes( "Confirma a atualizaÁ„o dos dicion·rios ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

		If lAuto
			If lOk
				MsgStop( "AtualizaÁ„o Realizada.", "UPDREN01" )
				dbCloseAll()
			Else
				MsgStop( "AtualizaÁ„o n„o Realizada.", "UPDREN01" )
				dbCloseAll()
			EndIf
		Else
			If lOk
				Final( "AtualizaÁ„o ConcluÌda." )
			Else
				Final( "AtualizaÁ„o n„o Realizada." )
			EndIf
		EndIf

		Else
			MsgStop( "AtualizaÁ„o n„o Realizada.", "UPDREN01" )

		EndIf

	Else
		MsgStop( "AtualizaÁ„o n„o Realizada.", "UPDREN01" )

	EndIf

EndIf

Return NIL


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ FSTProc  ∫ Autor ≥ TOTVS Protheus     ∫ Data ≥  24/09/2013 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravaÁ„o dos arquivos           ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ FSTProc    - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
				MsgStop( "AtualizaÁ„o da empresa " + aRecnoSM0[nI][2] + " n„o efetuada." )
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

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Atualiza o dicion·rio SX2         ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			oProcess:IncRegua1( "Dicion·rio de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2(@cTexto)

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Atualiza o dicion·rio SX3         ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			FSAtuSX3( @cTexto )
			
			//------------------------------------
			// Atualiza os helps
			//------------------------------------
			//oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			//FSAtuHlp( @cTexto )
			
			//------------------------------------
			// Atualiza o dicion·rio SX5
			//------------------------------------
			//oProcess:IncRegua1( "Dicionario de dados do sistema"  + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )//"Diccionario de tablas sistema"
			//FSAtuSX5( @cTexto )
			
			
			//------------------------------------
			// Atualiza o dicion·rio SX6
			//------------------------------------
			//oProcess:IncRegua1( "Dicion·rio de parametros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			//FSAtuSX6( @cTexto)
			
			
			
			//------------------------------------
			// Atualiza o dicion·rio SX7
			//------------------------------------
			oProcess:IncRegua1( "Dicion·rio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7( @cTexto)
			
			
			//------------------------------------
			// Atualiza o dicion·rio SXB
			//------------------------------------
			oProcess:IncRegua1( "Dicion·rio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB( @cTexto)
			

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Atualiza o dicion·rio SIX         ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			oProcess:IncRegua1( "Dicion·rio de Ìndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX( @cTexto )
			

			oProcess:IncRegua1( "Dicion·rio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/Ìndices" )

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
					MsgStop( "Ocorreu um erro desconhecido durante a atualizaÁ„o da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicion·rio e da tabela.", "ATEN«√O" )
					cTexto += "Ocorreu um erro desconhecido durante a atualizaÁ„o da estrutura da tabela : " + aArqUpd[nX] + CRLF
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
			cAux += "LOG DA ATUALIZACAO DOS DICION¡RIOS" + CRLF
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ FSAtuSX2 ∫ Autor ≥ TOTVS Protheus     ∫ Data ≥  24/09/2013 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX2 - Arquivos      ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ FSAtuSX2   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"  , "X2_NOMESPA", "X2_NOMEENG", ;
             "X2_DELET"  , "X2_MODO"   , "X2_TTS"    , "X2_ROTINA", "X2_PYME"   , "X2_UNICO"  , ;
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
	'Z03'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'Z03'+cEmpr																, ; //X2_ARQUIVO
	'BORDERO GERAL EMPRESAS'											, ; //X2_NOME
	'BORDERO GERAL EMPRESAS'											, ; //X2_NOMESPA
	'BORDERO GERAL EMPRESAS'											, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

// Atualizando dicion·rio
oProcess:SetRegua2(Len(aSX2))

DbSelectArea("SX2")
DbSetOrder(1)

For nI := 1 To Len(aSX2)

	oProcess:IncRegua2("Atualizando Arquivos (SX2)...")

	If !SX2->(DbSeek(aSX2[nI][1]))

		If !(aSX2[nI][1] $ cAlias)
			cAlias += aSX2[nI][1] + "/"
			cTexto += "Foi incluÌda a tabela " + aSX2[nI][1] + CRLF
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ FSAtuSX3 ∫ Autor ≥ TOTVS Protheus     ∫ Data ≥  24/09/2013 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX3 - Campos        ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ FSAtuSX3   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
// Z03 //
/////////

aAdd( aSX3, { ;
	'Z03'	, ; //X3_ARQUIVO
	'01'	, ; //X3_ORDEM
	'Z03_FILIAL', ; //X3_CAMPO
	'C', ; //X3_TIPO
	7, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Filial', ; //X3_TITULO
	'Sucursal', ; //X3_TITSPA
	'Branch', ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal', ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'	, ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	1, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'N', ; //X3_BROWSE
	'', ; //X3_VISUAL
	'', ; //X3_CONTEXT
	'', ; //X3_OBRIGAT
	'', ; //X3_VLDUSER
	'', ; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'033'	, ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''		} ) //X3_PYME

aAdd( aSX3, { ;
	'Z03'	, ; //X3_ARQUIVO
	'02'	, ; //X3_ORDEM
	'Z03_GRP', ; //X3_CAMPO
	'C', ; //X3_TIPO
	2, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Grupo', ; //X3_TITULO
	'Grupo', ; //X3_TITSPA
	'Grupo', ; //X3_TITENG
	'Grupo', ; //X3_DESCRIC
	'Grupo', ; //X3_DESCSPA
	'', ; //X3_DESCENG
	'', ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'A', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'Ä', ; //X3_OBRIGAT
	'', ; //X3_VLDUSER
	'', ; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME
aAdd( aSX3, { ;
	'Z03'	, ; //X3_ARQUIVO
	'03'	, ; //X3_ORDEM
	'Z03_NGRP', ; //X3_CAMPO
	'C', ; //X3_TIPO
	40, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Nome Grp', ; //X3_TITULO
	'Nome Grp', ; //X3_TITSPA
	'Nome Grp', ; //X3_TITENG
	'Nome Grp', ; //X3_DESCRIC
	'Nome Grp', ; //X3_DESCSPA
	'', ; //X3_DESCENG
	'', ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'V', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'', ; //X3_OBRIGAT
	'', ; //X3_VLDUSER
	'', ; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME	
	
aAdd( aSX3, { ;
	'Z03'	, ; //X3_ARQUIVO
	'04'	, ; //X3_ORDEM
	'Z03_EMP', ; //X3_CAMPO
	'C', ; //X3_TIPO
	3, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Empresa', ; //X3_TITULO
	'Empresa', ; //X3_TITSPA
	'Empresa', ; //X3_TITENG
	'Empresa', ; //X3_DESCRIC
	'Empresa', ; //X3_DESCSPA
	'Empresa', ; //X3_DESCENG
	'', ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'V', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'Ä', ; //X3_OBRIGAT
	'', ; //X3_VLDUSER
	'', ; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME	

aAdd( aSX3,{;
	'Z03'	,; //X3_ARQUIVO
	'05'	,; //X3_ORDEM
	'Z03_NEMP', ; //X3_CAMPO
	'C', ; //X3_TIPO
	40, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Nome Emp', ; //X3_TITULO
	'Nome Emp', ; //X3_TITSPA
	'Nome Emp', ; //X3_TITENG
	'Nome Empresa', ; //X3_DESCRIC
	'Nome Empresa', ; //X3_DESCSPA
	'Nome Empresa', ; //X3_DESCENG
	'', ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'V', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'', ; //X3_OBRIGAT
	'', ; //X3_VLDUSER
	'', ; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME

aAdd( aSX3,{;
	'Z03'	,; //X3_ARQUIVO
	'06'	,; //X3_ORDEM
	'Z03_UND', ; //X3_CAMPO
	'C', ; //X3_TIPO
	2, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Unidade', ; //X3_TITULO
	'Unidade', ; //X3_TITSPA
	'Unidade', ; //X3_TITENG
	'Unidade', ; //X3_DESCRIC
	'Unidade', ; //X3_DESCSPA
	'Unidade', ; //X3_DESCENG
	'', ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'V', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'', ; //X3_OBRIGAT
	'', ; //X3_VLDUSER
	'', ; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME

aAdd( aSX3, { ;
	'Z03'	, ; //X3_ARQUIVO
	'07'	, ; //X3_ORDEM
	'Z03_FIL', ; //X3_CAMPO
	'C', ; //X3_TIPO
	2, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Filial'	, ; //X3_TITULO
	'Filial'	, ; //X3_TITSPA
	'Filial'	, ; //X3_TITENG
	'Filial', ; //X3_DESCRIC
	'Filial', ; //X3_DESCSPA
	'Filial', ; //X3_DESCENG
	'', ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'V', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'', ; //X3_OBRIGAT
	''										,; //X3_VLDUSER
	'' ,; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME

aAdd(aSX3,{;
	'Z03'                  ,; //X3_ARQUIVO
	'08'                   ,; //X3_ORDEM
	'Z03_NFIL'           ,; //X3_CAMPO
	'C'                    ,; //X3_TIPO
	40 ,; //X3_TAMANHO
	0                      ,; //X3_DECIMAL
	'Nome Filial'             ,; //X3_TITULO
	'Nome Filial'             ,; //X3_TITSPA
	'Nome Filial'             ,; //X3_TITENG
	''                     ,; //X3_DESCRIC
	''                     ,; //X3_DESCSPA
	''                     ,; //X3_DESCENG
	''                   ,; //X3_PICTURE
	''      ,; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''                     ,; //X3_RELACAO
	''                  ,; //X3_F3
	0                      ,; //X3_NIVEL
	Chr(254) + Chr(192)    ,; //X3_RESERV
	''                     ,; //X3_CHECK
	'',; //X3_TRIGGER
	'U',; //X3_PROPRI
	'S',; //X3_BROWSE
	'V',; //X3_VISUAL
	'R',; //X3_CONTEXT
	'',; //X3_OBRIGAT
	'',; //X3_VLDUSER
	'',; //X3_CBOX
	'',; //X3_CBOXSPA
	'',; //X3_CBOXENG
	'',; //X3_PICTVAR
	'',; //X3_WHEN
	'',; //X3_INIBRW
	'',; //X3_GRPSXG
	'',; //X3_FOLDER
	''}) //X3_PYME

aAdd(aSX3        ,{;
	'Z03'        ,; //X3_ARQUIVO
	'09'         ,; //X3_ORDEM
	'Z03_BANCO' , ; //X3_CAMPO
	'C'          ,; //X3_TIPO
	3			, ; //X3_TAMANHO
	0,; //X3_DECIMAL
	'Banco', ; //X3_TITULO
	'Banco', ; //X3_TITSPA
	'Banco', ; //X3_TITENG
	'Banco',; //X3_DESCRIC
	'Banco',; //X3_DESCSPA
	'Banco',; //X3_DESCENG
	''	, ; //X3_PICTURE
	''														, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'Z03F3'	, ; //X3_F3
	0,; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'',; //X3_CHECK
	'S',; //X3_TRIGGER
	'U',; //X3_PROPRI
	'S',; //X3_BROWSE
	'A',; //X3_VISUAL
	'R',; //X3_CONTEXT
	'',; //X3_OBRIGAT
	'',; //X3_VLDUSER
	'',; //X3_CBOX
	'',; //X3_CBOXSPA
	'',; //X3_CBOXENG
	'',; //X3_PICTVAR
	'',; //X3_WHEN
	'',; //X3_INIBRW
	'',; //X3_GRPSXG
	'',; //X3_FOLDER
	''}) //X3_PYME
aAdd(aSX3,{;
	'Z03',; //X3_ARQUIVO
	'10' ,; //X3_ORDEM
	'Z03_AGENC',; //X3_CAMPO
	'C'  ,; //X3_TIPO
	5    ,; //X3_TAMANHO
	0    ,; //X3_DECIMAL
	'Agencia',; //X3_TITULO
	'Agencia',; //X3_TITSPA
	'Agencia',; //X3_TITENG
	'Agencia'        ,; //X3_DESCRIC
	'Agencia'        ,; //X3_DESCSPA
	'Agencia'        ,; //X3_DESCENG
	''      ,; //X3_PICTURE
	'',; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	''                  ,; //X3_RELACAO
	''                  ,; //X3_F3
	0                   ,; //X3_NIVEL
	Chr(254) + Chr(192) ,; //X3_RESERV
	''                  ,; //X3_CHECK
	''                  ,; //X3_TRIGGER
	'U'                 ,; //X3_PROPRI
	'S'                 ,; //X3_BROWSE
	'A'                 ,; //X3_VISUAL
	'R'                 ,; //X3_CONTEXT
	''                 ,; //X3_OBRIGAT
	''                  ,; //X3_VLDUSER
	'',; //X3_CBOX
	'',; //X3_CBOXSPA
	''  ,; //X3_CBOXENG
	''                  ,; //X3_PICTVAR
	''                  ,; //X3_WHEN
	''                  ,; //X3_INIBRW
	''                  ,; //X3_GRPSXG
	''                  ,; //X3_FOLDER
	''                  }) //X3_PYME
	
aAdd(aSX3,{;
	'Z03',; //X3_ARQUIVO
	'11' ,; //X3_ORDEM
	'Z03_NUMCON',; //X3_CAMPO
	'C'  ,; //X3_TIPO
	10    ,; //X3_TAMANHO
	0    ,; //X3_DECIMAL
	'Nro Conta',; //X3_TITULO
	'Nro Conta',; //X3_TITSPA
	'Nro Conta',; //X3_TITENG
	'Nro Conta'        ,; //X3_DESCRIC
	'Nro Conta'        ,; //X3_DESCSPA
	'Nro Conta'        ,; //X3_DESCENG
	''      ,; //X3_PICTURE
	'',; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	''                  ,; //X3_RELACAO
	''                  ,; //X3_F3
	0                   ,; //X3_NIVEL
	Chr(254) + Chr(192) ,; //X3_RESERV
	''                  ,; //X3_CHECK
	''                  ,; //X3_TRIGGER
	'U'                 ,; //X3_PROPRI
	'S'                 ,; //X3_BROWSE
	'A'                 ,; //X3_VISUAL
	'R'                 ,; //X3_CONTEXT
	''                 ,; //X3_OBRIGAT
	''                  ,; //X3_VLDUSER
	'',; //X3_CBOX
	'',; //X3_CBOXSPA
	''  ,; //X3_CBOXENG
	''                  ,; //X3_PICTVAR
	''                  ,; //X3_WHEN
	''                  ,; //X3_INIBRW
	''                  ,; //X3_GRPSXG
	''                  ,; //X3_FOLDER
	''                  }) //X3_PYME

aAdd(aSX3,{;
	'Z03',; //X3_ARQUIVO
	'12' ,; //X3_ORDEM
	'Z03_NOMEAG',; //X3_CAMPO
	'C'  ,; //X3_TIPO
	40    ,; //X3_TAMANHO
	0    ,; //X3_DECIMAL
	'Nome Agencia',; //X3_TITULO
	'Nome Agencia',; //X3_TITSPA
	'Nome Agencia',; //X3_TITENG
	'Nome Agencia'        ,; //X3_DESCRIC
	'Nome Agencia'        ,; //X3_DESCSPA
	'Nome Agencia'        ,; //X3_DESCENG
	''      ,; //X3_PICTURE
	'',; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	''                  ,; //X3_RELACAO
	''                  ,; //X3_F3
	0                   ,; //X3_NIVEL
	Chr(254) + Chr(192) ,; //X3_RESERV
	''                  ,; //X3_CHECK
	''                  ,; //X3_TRIGGER
	'U'                 ,; //X3_PROPRI
	'S'                 ,; //X3_BROWSE
	'A'                 ,; //X3_VISUAL
	'R'                 ,; //X3_CONTEXT
	''                 ,; //X3_OBRIGAT
	''                  ,; //X3_VLDUSER
	'',; //X3_CBOX
	'',; //X3_CBOXSPA
	''  ,; //X3_CBOXENG
	''                  ,; //X3_PICTVAR
	''                  ,; //X3_WHEN
	''                  ,; //X3_INIBRW
	''                  ,; //X3_GRPSXG
	''                  ,; //X3_FOLDER
	''                  }) //X3_PYME

aAdd(aSX3,{;
	'Z03',; //X3_ARQUIVO
	'13' ,; //X3_ORDEM
	'Z03_CONTR',; //X3_CAMPO
	'C'  ,; //X3_TIPO
	15    ,; //X3_TAMANHO
	0    ,; //X3_DECIMAL
	'Contrato',; //X3_TITULO
	'Contrato',; //X3_TITSPA
	'Contrato',; //X3_TITENG
	'Contrato'        ,; //X3_DESCRIC
	'Contrato'        ,; //X3_DESCSPA
	'Contrato'        ,; //X3_DESCENG
	''      ,; //X3_PICTURE
	'',; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	''                  ,; //X3_RELACAO
	''                  ,; //X3_F3
	0                   ,; //X3_NIVEL
	Chr(254) + Chr(192) ,; //X3_RESERV
	''                  ,; //X3_CHECK
	''                  ,; //X3_TRIGGER
	'U'                 ,; //X3_PROPRI
	'N'                 ,; //X3_BROWSE
	'A'                 ,; //X3_VISUAL
	'R'                 ,; //X3_CONTEXT
	''                 ,; //X3_OBRIGAT
	''                  ,; //X3_VLDUSER
	'',; //X3_CBOX
	'',; //X3_CBOXSPA
	''  ,; //X3_CBOXENG
	''                  ,; //X3_PICTVAR
	''                  ,; //X3_WHEN
	''                  ,; //X3_INIBRW
	''                  ,; //X3_GRPSXG
	''                  ,; //X3_FOLDER
	''                  }) //X3_PYME
	
aAdd(aSX3,{;
	'SE2',; //X3_ARQUIVO
	'XX' ,; //X3_ORDEM
	'E2_ZOK',; //X3_CAMPO
	'C'  ,; //X3_TIPO
	2    ,; //X3_TAMANHO
	0    ,; //X3_DECIMAL
	'OK Filtro',; //X3_TITULO
	'OK Filtro',; //X3_TITSPA
	'OK Filtro',; //X3_TITENG
	'OK Filtro'        ,; //X3_DESCRIC
	'OK Filtro'        ,; //X3_DESCSPA
	'OK Filtro'        ,; //X3_DESCENG
	''      ,; //X3_PICTURE
	'',; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)+;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	''                  ,; //X3_RELACAO
	''                  ,; //X3_F3
	0                   ,; //X3_NIVEL
	Chr(254) + Chr(192) ,; //X3_RESERV
	''                  ,; //X3_CHECK
	''                  ,; //X3_TRIGGER
	'U'                 ,; //X3_PROPRI
	'N'                 ,; //X3_BROWSE
	'A'                 ,; //X3_VISUAL
	'R'                 ,; //X3_CONTEXT
	''                 ,; //X3_OBRIGAT
	''                  ,; //X3_VLDUSER
	'',; //X3_CBOX
	'',; //X3_CBOXSPA
	''  ,; //X3_CBOXENG
	''                  ,; //X3_PICTVAR
	''                  ,; //X3_WHEN
	''                  ,; //X3_INIBRW
	''                  ,; //X3_GRPSXG
	''                  ,; //X3_FOLDER
	''                  }) //X3_PYME

aAdd( aSX3, { ;
	'Z03'	, ; //X3_ARQUIVO
	'XX'	, ; //X3_ORDEM
	'Z03_FILCON', ; //X3_CAMPO
	'C', ; //X3_TIPO
	2, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Fil Consolid'	, ; //X3_TITULO
	'Fil Consolid'	, ; //X3_TITSPA
	'Fil Consolid'	, ; //X3_TITENG
	'Fil Consolid', ; //X3_DESCRIC
	'Fil Consolid', ; //X3_DESCSPA
	'Fil Consolid', ; //X3_DESCENG
	'99', ; //X3_PICTURE
	'', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'A', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'', ; //X3_OBRIGAT
	''										,; //X3_VLDUSER
	'' ,; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME
	
	aAdd( aSX3, { ;
	'SA2'	, ; //X3_ARQUIVO
	'XX'	, ; //X3_ORDEM
	'A2_MINPUB', ; //X3_CAMPO
	'C', ; //X3_TIPO
	1, ; //X3_TAMANHO
	0, ; //X3_DECIMAL
	'Vl MÌn.Pub'	, ; //X3_TITULO
	'Vl MÌn.Pub'	, ; //X3_TITSPA
	'Vl MÌn.Pub'	, ; //X3_TITENG
	'Valor MÌn.PCC e IR EmpPub', ; //X3_DESCRIC
	'Valor MÌn.PCC e IR EmpPub', ; //X3_DESCSPA
	'Valor MÌn.PCC e IR EmpPub', ; //X3_DESCENG
	'@!', ; //X3_PICTURE
	'Pertence("12")', ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'2', ; //X3_RELACAO
	'', ; //X3_F3
	0, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	'', ; //X3_CHECK
	'', ; //X3_TRIGGER
	'U', ; //X3_PROPRI
	'S', ; //X3_BROWSE
	'A', ; //X3_VISUAL
	'R', ; //X3_CONTEXT
	'Ä', ; //X3_OBRIGAT
	''										,; //X3_VLDUSER
	'1=Sim;2=Nao' ,; //X3_CBOX
	'', ; //X3_CBOXSPA
	'', ; //X3_CBOXENG
	'', ; //X3_PICTVAR
	'', ; //X3_WHEN
	'', ; //X3_INIBRW
	'', ; //X3_GRPSXG
	'', ; //X3_FOLDER
	''}) //X3_PYME

	


// Atualizando dicion·rio
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

				cMsg := "O campo " + aSX3[nI][nPosCpo] + " est· com o " + SX3->( FieldName( nJ ) ) + ;
				" com o conte˙do" + CRLF + ;
				"[" + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
				"que ser· substituido pelo NOVO conte˙do" + CRLF + ;
				"[" + RTrim( AllToChar( aSX3[nI][nJ] ) ) + "]" + CRLF + ;
				"Deseja substituir ? "

				If      lTodosSim
					nOpcA := 1
				ElseIf  lTodosNao
					nOpcA := 2
				Else
					nOpcA := Aviso( "ATUALIZA«√O DE DICION¡RIOS E TABELAS", cMsg, { "Sim", "N„o", "Sim p/Todos", "N„o p/Todos" }, 3, "DiferenÁa de conte˙do - SX3" )
					lTodosSim := ( nOpcA == 3 )
					lTodosNao := ( nOpcA == 4 )

					If lTodosSim
						nOpcA := 1
						lTodosSim := MsgNoYes( "Foi selecionada a opÁ„o de REALIZAR TODAS alteraÁıes no SX3 e N√O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a aÁ„o [Sim p/Todos] ?" )
					EndIf

					If lTodosNao
						nOpcA := 2
						lTodosNao := MsgNoYes( "Foi selecionada a opÁ„o de N√O REALIZAR nenhuma alteraÁ„o no SX3 que esteja diferente da base e N√O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta aÁ„o [N„o p/Todos]?" )
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ FSAtuSIX ∫ Autor ≥ TOTVS Protheus     ∫ Data ≥  24/09/2013 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SIX - Indices       ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ FSAtuSIX   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
	'Z03'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z03_FILIAL+Z03_GRP+Z03_EMP+Z03_UND+Z03_FIL'													, ; //CHAVE
	'Emp + Filial + Unidade'															, ; //DESCRICAO
	'Emp + Filial + Unidade'															, ; //DESCSPA
	'Emp + Filial + Unidade'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

			
// Atualizando dicion·rio
oProcess:SetRegua2(Len(aSIX))

DbSelectArea("SIX")
SIX->(DbSetOrder(1))

For nI := 1 To Len(aSIX)

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		cTexto += "Õndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "") == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			cTexto += "Chave do Ìndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
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

	oProcess:IncRegua2( "Atualizando Ìndices..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥ESCEMPRESA∫Autor  ≥                    ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Generica para escolha de Empresa, montado pelo SM0_ ∫±±
±±∫          ≥ Retorna vetor contendo as selecoes feitas.                 ∫±±
±±∫          ≥ Se nao For marcada nenhuma o vetor volta vazio.            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function EscEmpresa()
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Parametro  nTipo                           ≥
//≥ 1  - Monta com Todas Empresas/Filiais      ≥
//≥ 2  - Monta so com Empresas                 ≥
//≥ 3  - Monta so com Filiais de uma Empresa   ≥
//≥                                            ≥
//≥ Parametro  aMarcadas                       ≥
//≥ Vetor com Empresas/Filiais pre marcadas    ≥
//≥                                            ≥
//≥ Parametro  cEmpSel                         ≥
//≥ Empresa que sera usada para montar selecao ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
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

oDlg:cToolTip := "Tela para M˙ltiplas SeleÁıes de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para AtualizaÁ„o"

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
Message "Inverter SeleÁ„o" Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "M·scara Empresa ( ?? )"  Of oDlg
@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando m·scara ( ?? )"    Of oDlg
@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando m·scara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a SeleÁ„o"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a SeleÁ„o" Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥MARCATODOS∫Autor  ≥                    ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Auxiliar para marcar/desmarcar todos os itens do    ∫±±
±±∫          ≥ ListBox ativo                                              ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥INVSELECAO∫Autor  ≥                    ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Auxiliar para inverter selecao do ListBox Ativo     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥RETSELECAO∫Autor  ≥                    ∫ Data ≥  27/09/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao Auxiliar que monta o retorno com as selecoes        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥ MARCAMAS ∫Autor  ≥                     ∫ Data ≥  20/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao para marcar/desmarcar usando mascaras               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥ VERTODOS ∫Autor  ≥                    ∫ Data ≥  20/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao auxiliar para verificar se estao todos marcardos    ∫±±
±±∫          ≥ ou nao                                                     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ MyOpenSM0∫ Autor ≥ TOTVS Protheus     ∫ Data ≥  24/09/2013 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento abertura do SM0 modo exclusivo     ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
	MsgStop( "N„o foi possÌvel a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN«√O" )
EndIf

Return lOpen

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX7
FunÁ„o de processamento da gravaÁ„o do SX7 - Gatilhos

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
	'Z03_BANCO'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CAGENC__1'				, ; //X7_REGRA
	'Z03_AGENC '															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC
	
aAdd( aSX7, { ;
	'Z03_BANCO'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'CNUMCON__1'				, ; //X7_REGRA
	'Z03_NUMCON'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'Z03_BANCO'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'CNOME__1'				, ; //X7_REGRA
	'Z03_NOMEAG'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC
	


//
// Atualizando dicion·rio
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
			AutoGrLog( "Foi incluÌdo o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
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
//AutoGrLog( CRLF + "Final da AtualizaÁ„o" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ FSAtuSXB ∫ Autor ≥ TOTVS Protheus     ∫ Data ≥  22/05/2014 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SXB - Consultas Pad ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ FSAtuSXB   - Gerado por EXPORDIC / Upd. V.4.7.2 EFS        ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
	'Z03F3'																, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'RE'																	, ; //XB_COLUNA
	'Z03 - BANCOS'													, ; //XB_DESCRI
	'Z03 - BANCOS'													, ; //XB_DESCSPA
	'Z03 - BANCOS'													, ; //XB_DESCENG
	'SA6'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'Z03F3'																, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	''															, ; //XB_DESCRI
	''															, ; //XB_DESCSPA
	''															, ; //XB_DESCENG
	'U_Z03F3()'																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'Z03F3 '																, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																	, ; //XB_COLUNA
	''														, ; //XB_DESCRI
	''														, ; //XB_DESCSPA
	''														, ; //XB_DESCENG
	'CBANCO__1'																		} ) //XB_CONTEM

	

//
// Atualizando dicion·rio
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				cTexto += "Foi incluÌda a consulta padr„o " + aSXB[nI][1] + CRLF
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

					cMsg := "A consulta padrao " + aSXB[nI][1] + " est· com o " + SXB->( FieldName( nJ ) ) + ;
					" com o conte˙do" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
					", e este È diferente do conte˙do" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZA«√O DE DICION¡RIOS E TABELAS", cMsg, { "Sim", "N„o", "Sim p/Todos", "N„o p/Todos" }, 3, "DiferenÁa de conte˙do - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a opÁ„o de REALIZAR TODAS alteraÁıes no SXB e N√O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a aÁ„o [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a opÁ„o de N√O REALIZAR nenhuma alteraÁ„o no SXB que esteja diferente da base e N√O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta aÁ„o [N„o p/Todos]?" )
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
   SX6->X6_DESCRIC := "Natureza utilizada pelos tÌtulos de IPTU."
   SX6->X6_DSCSPA  := "Natureza utilizada pelos tÌtulos de IPTU."
   SX6->X6_DSCENG  := "Natureza utilizada pelos tÌtulos de IPTU."
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
   SX6->X6_DESCRIC := "Natureza utilizada pelos tÌtulos de ICMS."
   SX6->X6_DSCSPA  := "Natureza utilizada pelos tÌtulos de ICMS."
   SX6->X6_DSCENG  := "Natureza utilizada pelos tÌtulos de ICMS."
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
   SX6->X6_DESCRIC := "Natureza utilizada pelos tÌtulos de ISS."
   SX6->X6_DSCSPA  := "Natureza utilizada pelos tÌtulos de ISS."
   SX6->X6_DSCENG  := "Natureza utilizada pelos tÌtulos de ISS."
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
   
Return cTexto


Static Function FSAtuHlp( cTexto )
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

cTexto  += "Õnicio da AtualizaÁ„o" + " " + "Helps de Campos" + CRLF + CRLF


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

//
// Helps Tabela SA1
//

aHlpPor := {}
aAdd( aHlpPor, 'Tipo da conta banc·ria' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "A2_XTPCONT    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "A2_XTPCONT" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Campo utilizado no momento da geraÁ„o do borderÙ onde:' )
aAdd( aHlpPor, '1-Classifica o modelo do tÌtulo autom·ticamente' )
aAdd( aHlpPor, '2-O tÌtulo n„o È considerado na geraÁ„o do borderÙ' )
aAdd( aHlpPor, '3-Classifica o tÌtulo no modelo de pagto 04 (Ordem de pagamento)' )
aAdd( aHlpPor, '4-Classifica o tÌtulo no modelo de pagto 13 (Concession·ria) ' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "E2_ZCODPGT    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "E2_ZCODPGT" + CRLF







cTexto += CRLF + "Final da AtualizaÁ„o" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return {}

Static Function FSAtuSX5( cTexto )
Local aEstrut   := {}
Local aSX5      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamFil   := Len( SX5->X5_FILIAL )

cTexto  += "InÌcio da atualizaÁ„o do SX5"  + CRLF + CRLF //"Õnicio da AtualizaÁ„o SX5"

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
	'DIVERSOS'																, ; //X5_DESCRI
	'DIVERSOS'																, ; //X5_DESCSPA
	'DIVERSOS'																} ) //X5_DESCENG


//
// Actualizando dicion·rio
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

cTexto += CRLF + "Final da adtualizaÁ„o" + " SX5" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF //"Final de ActualizaciÛn"

Return NIL



