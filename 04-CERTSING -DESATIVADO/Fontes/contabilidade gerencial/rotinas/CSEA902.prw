#include "PROTHEUS.CH"

#define UPD_LAST_UPDATED		"06/01/2014"

#DEFINE X3_USADO_EMUSO 			"€€€€€€€€€€€€€€ "	//TORNA USADO POR TODOS OS MODULOS
#DEFINE X3_USADO_USADOKEY 		"€€€€€€€€€€€€€€°"	//PERMITE ALTERAR SOMENTE O FORMATO E O BROWSE DO USO
#DEFINE X3_USADO_NAOUSADO 		"€€€€€€€€€€€€€€€"	//TORNA NAO USADO PELOS MODULOS
#DEFINE X3_RESER_ALTERA_MODO	"€€"               	//PERMITE ALTERAR OBRIGATORIO, BROWSE E FORMATO
#DEFINE X3_RESER_ALTERA_MODL	"þÀ"				//PERMITE ALTERAR ALTERAR USO E ALTERAR MODULOS
#DEFINE X3_RESER_ALTERA_TAM 	"–À"				//PERMITE ALTERAR ALTERAR USO E ALTERAR MODULOS E TAMANHO DO CAMPO
#DEFINE X3_RESER_ALT_TAM_DEC   "Ü+"					//PERMITE ALTERAR ALTERAR USO E ALTERAR MODULOS E TAMANHO DO CAMPO E DECIMAL
#DEFINE X3_RESER_NUMERICO 		"øÇ" 				//PERMITE ALTERAR ALTERAR USO E ALTERAR MODULOS E TAMANHO DO CAMPO E DECIMAL
#DEFINE X3_RESER_BROWSE			"ƒ€"				//PERMITE ALTERAR SOMENTE O BROWSE DO USO
#DEFINE X3_RESER_BROWSE_FORMATO	"›€"               	//PERMITE ALTERAR SOMENTE O FORMATO E O BROWSE DO USO
#DEFINE X3_RESER_OBRIGATORIO 	"Á€"				//TORNA OBRIGATORIO
#DEFINE X3_REVER_NAOOBRIGAT		"šÀ" 				//TORNA NAO OBRIGATORIO 

#DEFINE FX3_FILIAL		1
#DEFINE FX3_USADO_OBR  	2
#DEFINE FX3_USADO_NOBR	3
#DEFINE FX3_NUSADO		4


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CSEA902  ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ 21/01/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Executa as funcoes de atualizacao do ambiente               ³±±                
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³U_CSEA902 - PARA EXECUCAO PELA TELA DE ABERTURA DO REMOTE  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MAT00I01 - IMPORTACAO DE XML DE FORNECEDORES                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSEA902(cEmpAmb, cFilAmb)
	UPDMAIN(cEmpAmb, cFilAmb)
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDMAIN   ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ 06/01/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Executa as funcoes de atualizacao do ambiente               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³UPDMAIN                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UPDMAIN(cEmpAmb, cFilAmb)

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema."
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := "usuários  ou  jobs utilizando  o sistema.  É extremamente recomendavél  que  se  faça um"
Local   cDesc4    := "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
Local   cDesc5    := "ocorra eventuais falhas, esse backup seja ser restaurado."
Local   cDesc6    := "FUNCIONALIDADE: ENTIDADES CONTABEIS PARA O ORCAMENTO."
Local   cDesc7    := "VERSAO: 001 | DATA DE REFERENCIA: 06/01/2014"
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL
Private cMessage

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

cArqEmp := "SIGAMAT.EMP"
nModulo		:= 44
__cInterNet := NIL
__lPYME     := .F.

SET DELE ON

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
aAdd( aSay, cDesc6 )
aAdd( aSay, cDesc7 )

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
		If lAuto .OR. MsgYesNo("Confirma a atualização dos dicionários de dados v." + UPD_LAST_UPDATED + "? ", cTitulo)
			oProcess := MsNewProcess():New( { | lEnd | lOk := UPDProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

		If lAuto
			If lOk
				MsgStop( "Atualização Realizada.", "CSEA902" )
				dbCloseAll()
			Else
				MsgStop( "Atualização não Realizada.", "CSEA902" )
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
			MsgStop( "Atualização não Realizada.", "CSEA902" )
		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "CSEA902" )
	EndIf
EndIf

Return NIL



Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDPROC   ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao dos arquivos            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³GENERICO                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDProc(lEnd, aMarcadas)

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

If ( lOpen := UpdOpenSm0(.T.) )

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

			If !( lOpen := UpdOpenSm0(.F.) )
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += UPDAtuSX3()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza as perguntes de relatorios.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Grupo de Campos...")
			cTexto += UPDAtuSXG()
		    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza as perguntes de relatorios.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Perguntas de Relatorios...")
			cTexto += UPDAtuSX1()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += UPDAtuSX2()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza as tabelas genéricas.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Tabelas Auxiliares...")
			cTexto += UPDAtuSX5()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os parametros.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Parametros do Sistema...")
			cTexto += UPDAtuSX6()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Gatilhos do Sistema...")
			cTexto += UPDAtuSX7()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os folder's de cadastro.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Pastas/Guias de Cadastros/Telas...")
			cTexto += UPDAtuSXA()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza as consultas padroes.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Consultas Padroes...")
			cTexto += UPDAtuSXB()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os agendamentos 		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Configuração de Schedule...")
			cTexto += UPDAtuSXD()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza helps de campos.      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Atualizando helps de campos...")
			cTexto += UPDAtuHlp()
		
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CRLF
				EndIf
			Next nX
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.							 ³
			//|Neste ponto garante que os campos necessarios |
			//|aos indices existem na base de dados          |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcRegua(2)
			IncProc("Analisando Indices...")
			cTexto += UPDAtuSIX()
		
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CRLF
				EndIf
			Next nX
		
			RpcClearEnv()

		Next nI

	Endif
Else
	lRet := .F.
Endif

cTexto := "Log da atualizacao "+CRLF+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."


ACTIVATE MSDIALOG oDlg CENTER


Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSIX ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SIX                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME
Local cTexto := ''
Local lSIX   := .F.
Local lNew   := .F.
Local aSIX   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cAlias := ''

If (cPaisLoc == "BRA")
	aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}
Else
	aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}
EndIf

Aadd(aSIX,{"CV0","4","CV0_FILIAL+CV0_PLANO+CV0_DESC","Plano Contáb + Descrição","Plano Contáb + Descrição","Plano Contáb + Descrição","U","","CV0DESC","S"}) 

dbSelectArea("SIX")
dbSetOrder(1)
ProcRegua(Len(aSIX))
IncProc("Apagando Indices atualizados...")
cTabOk	:= ""

For i := 1 To Len( aSIX )
	If SIX->( MsSeek( aSIX[i,1] + aSIX[i,2] ) ) .and. !( aSIX[i,1] $ cTabOk ) .and. SX2->( MsSeek( aSIX[i,1] ) )
		cTabOk += aSIX[i,1] + "/"
		cArquivo := AllTrim( SX2->X2_PATH ) + AllTrim( SX2->X2_ARQUIVO )
	
		// Abrindo as tabelas em modo Exclusivo
		If Select( aSIX[i,1] ) > 0
			(aSIX[i,1])->( DbCloseArea() )
		EndIf
			// Acrescenta na lista de atualizacoes
		if ASCAN( aArqUpd, aSIX[i,1] ) == 0
			aAdd( aArqUpd, aSIX[i,1] )
		endif
			ChkFile( aSIX[i,1], .T., aSIX[i,1] )
		dbSelectArea( aSIX[i,1] )
		X31IndErase( aSIX[i,1], cArquivo, __cRdd )
		DbCloseArea()
	EndIf
Next i

// Atualizando o Dicionario de Indices
ProcRegua( Len( aSIX ) )
SIX->( dbSetOrder( 1 ) )
For i := 1 To Len( aSIX )
	If !Empty( aSIX[i,1] )
		lNew := ValidSIX(aSIX[i,1], aSIX[i,2], aSIX[i,3], aSIX[i,9]) //!SIX->( MsSeek( aSIX[i,1] + aSIX[i,2] ) )
			If lNew // .Or. !(UPPER( AllTrim(SIX->CHAVE) ) == UPPER( Alltrim(aSIX[i,3]) ))
				// Acrescenta na lista de atualizacoes
				if ASCAN( aArqUpd, aSIX[i,1] ) == 0
					aAdd( aArqUpd, aSIX[i,1] )
				endif
				lSIX := .T.
				If !(aSIX[i,1] $ cAlias)
				cAlias += aSIX[i,1] + "/"
			EndIf
		
			RecLock( "SIX", lNew )
			For j := 1 To Len( aSIX[i] )
			If FieldPos( aEstrut[j] ) > 0
					FieldPut( FieldPos(aEstrut[j] ), aSIX[i,j] )
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
			IncProc("Atualizando Indices...")
	EndIf
Next i
// Fim de Atualizando o Dicionario de Indices

If lSIX
	cTexto += "Indices atualizados  : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSX1 ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao dos SX1                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSX1()
//				X1_GRUPO   X1_ORDEM   X1_PERGUNT X1_PERSPA X1_PERENG  X1_VARIAVL X1_TIPO    X1_TAMANHO X1_DECIMAL X1_PRESEL
//				X1_GSC     X1_VALID   X1_VAR01   X1_DEF01  X1_DEFSPA1 X1_DEFENG1 X1_CNT01   X1_VAR02   X1_DEF02
//				X1_DEFSPA2 X1_DEFENG2 X1_CNT02   X1_VAR03  X1_DEF03   X1_DEFSPA3 X1_DEFENG3 X1_CNT03   X1_VAR04   X1_DEF04
// 				X1_DEFSPA4 X1_DEFENG4 X1_CNT04   X1_VAR05  X1_DEF05   X1_DEFSPA5 X1_DEFENG5 X1_CNT05   X1_F3      X1_GRPSXG X1_PYME
Local aSX1   := {}
Local aEstrut	:= {}
Local i      := 0
Local j      := 0
Local lSX1	 := .F.
Local cTexto := ''
Local nTamFil 	:= UPDTamSXG( "033", TamSX3( "E2_FILIAL" )[1] )[1]

If (cPaisLoc == "BRA")
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM"  ,"X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO"   ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
	"X1_GSC"    ,"X1_VALID"  ,"X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01"  ,"X1_VAR02"  ,"X1_DEF02"  ,;
	"X1_DEFSPA2","X1_DEFENG2","X1_CNT02"  ,"X1_VAR03" ,"X1_DEF03"  ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03"  ,"X1_VAR04"  ,"X1_DEF04",;
	"X1_DEFSPA4","X1_DEFENG4","X1_CNT04"  ,"X1_VAR05" ,"X1_DEF05"  ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05"  ,"X1_F3"     ,"X1_PYME","X1_GRPSXG",;
	"X1_HELP","X1_PICTURE","X1_IDFIL"}
Else
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM"  ,"X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO"   ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
	"X1_GSC"    ,"X1_VALID"  ,"X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01"  ,"X1_VAR02"  ,"X1_DEF02"  ,;
	"X1_DEFSPA2","X1_DEFENG2","X1_CNT02"  ,"X1_VAR03" ,"X1_DEF03"  ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03"  ,"X1_VAR04"  ,"X1_DEF04",;
	"X1_DEFSPA4","X1_DEFENG4","X1_CNT04"  ,"X1_VAR05" ,"X1_DEF05"  ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05"  ,"X1_F3"     ,"X1_PYME","X1_GRPSXG",;
	"X1_HELP","X1_PICTURE","X1_IDFIL"}
EndIf

//Exemplo:
// AADD(aSX1,{})
                                                                       	
ProcRegua(Len(aSX1))

dbSelectArea("SX1")
dbSetOrder(1)
For i:= 1 To Len(aSX1)
	If !Empty(aSX1[i][1])

		if ! dbSeek( Padr( aSX1[i,1] , Len( X1_GRUPO ) , ' ' ) + aSX1[i,2] )

			lSX1 := .T.
			RecLock("SX1",.T.)
			
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Perguntas de Relatorios...")
		EndIf
	EndIf
Next i

If lSX1
	cTexto += "Incluidas novas perguntas no SX1."+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSX2 ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX2                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSX2()
//X2_CHAVE X2_PATH X2_ARQUIVOC,X2_NOME,X2_NOMESPAC X2_NOMEENGC X2_DELET X2_MODO X2_TTS X2_ROTINA
Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath		:= ""
Local cNome		:= ""
Local cEmpr     := '' 
Local cFilPAD   := ""
Local cUniPAD   := ""
Local cEmpPAD   := ""
Local cAliasPAD	:= "" // DEFINIR

If (cPaisLoc == "BRA")
	aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO","X2_MODOUN","X2_MODOEMP"}
Else
	aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO","X2_MODOUN","X2_MODOEMP"}
EndIf

//Exemplo:
//AADD(aSX2, {})

// Busca o compartilhamento do Alias Padrao para as novas tabelas terem o mesmo compartilhamento
dbSelectArea("SX2")
dbSetOrder(1)
MsSeek(cAliasPAD)
cFilPAD	:= SX2->X2_MODO
cPath := SX2->X2_PATH
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )
If SX2->(FieldPos("X2_MODOUN")) > 0
	cUniPAD	:= SX2->X2_MODOUN
EndIf
If SX2->(FieldPos("X2_MODOEMP")) > 0
	cEmpPAD	:= SX2->X2_MODOEMP
EndIf

//Exemplo:
//AADD(aSX2, {})

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !MsSeek(aSX2[i,1])
			lSX2	:= .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH    := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			SX2->X2_MODO    := cModo
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Arquivos...")
		EndIf
	EndIf
Next i

If lSX2
	cTexto += "Incluidas novas perguntas no SX1."+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSX3 ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX3                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSX3()
//	X3_ARQUIVO X3_ORDEM   X3_CAMPO   X3_TIPO    X3_TAMANHO X3_DECIMAL X3_TITULO  X3_TITSPA  X3_TITENG
//  X3_DESCRIC X3_DESCSPA X3_DESCENG X3_PICTURE X3_VALID   X3_USADO   X3_RELACAO X3_F3      X3_NIVEL
//  X3_RESERV  X3_CHECK   X3_TRIGGER X3_PROPRI  X3_BROWSE  X3_VISUAL  X3_CONTEXT X3_OBRIGAT X3_VLDUSER
//  X3_CBOX    X3_CBOXSPA X3_CBOXENG X3_PICTVAR X3_WHEN    X3_INIBRW  X3_GRPSXG  X3_FOLDER

Local aSX3   	:= {}
Local aSX3Del  	:= {}
Local aEstrut	:= {}
Local aSX3Ordem := {} // Redefine apenas a ordem dos campos informado no array
Local i      	:= 0
Local j      	:= 0
Local lSX3		:= .F.
Local cTexto 	:= ''
Local cAlias 	:= ''
Local nI		:= 0 
Local aArea  	:= GetArea()
Local aAreaSX3	:= {}  
Local aSX3Alter := {}
Local aSX3F		:= {}
Local nTamFil 	:= UPDTAMSXG( "033", TamSX3( "E2_FILIAL" )[1] )[1]
Local nTamLocBem:= UPDTAMSXG( "058", 6)[1]
Local nTamConta	:= UPDTAMSXG( "003", 20)[1]
Local nTamCCusto:= UPDTAMSXG( "004", 9)[1]
Local nTamITCtb	:= UPDTAMSXG( "005", 9)[1]
Local nTamClVlr	:= UPDTAMSXG( "006", 9)[1]
Local nTamNota 	:= UPDTAMSXG( "018", 9)[1]
Local nTamCli 	:= UPDTAMSXG( "001", 6)[1]
Local nTamLoj 	:= UPDTAMSXG( "002", 2)[1]

aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER","X3_PYME"}

/* Identificando os campos do SX3 na matriz aEstrut
01-X3_ARQUIVO  02-X3_ORDEM	  03-X3_CAMPO    04-X3_TIPO     05-X3_TAMANHO  06-X3_DECIMAL  07-X3_TITULO  08-X3_TITSPA
09-X3_TITENG   10-X3_DESCRIC  11-X3_DESCSPA  12-X3_DESCENG  13-X3_PICTURE  14-X3_VALID    15-X3_USADO   16-X3_RELACAO
17-X3_F3       18-X3_NIVEL    19-X3_RESERV   20-X3_CHECK    21-X3_TRIGGER  22-X3_PROPRI   23-X3_BROWSE  24-X3_VISUAL
25-X3_CONTEXT  26-X3_OBRIGAT  27-X3_VLDUSER  28-X3_CBOX     29-X3_CBOXSPA  30-X3_CBOXENG  31-X3_PICTVAR 32-X3_WHEN
33-X3_INIBRW   34-X3_GRPSXG   35-X3_FOLDER   36-X3_PYME
*/

//Aadd(aSX3F,{"X3_USADO","X3_RESERV"})
Aadd(aSX3F,{X3_USADO_NAOUSADO	, X3_REVER_NAOOBRIGAT	}) //FILIAL						: FX3_FILIAL		1
Aadd(aSX3F,{X3_USADO_EMUSO		, X3_RESER_OBRIGATORIO	}) //USADO + OBRIGATORIO		: FX3_USADO_OBR  	2 
Aadd(aSX3F,{X3_USADO_EMUSO		, X3_REVER_NAOOBRIGAT	}) //USADO + NAO OBRIGATORIO	: FX3_USADO_NOBR	3
Aadd(aSX3F,{X3_USADO_NAOUSADO	, X3_REVER_NAOOBRIGAT	}) //NAO USADO					: FX3_NUSADO		4	
// aSX3F[FX3_FILIAL][1] 	/ aSX3F[FX3_FILIAL][2]
// aSX3F[FX3_USADO_OBR][1] 	/ aSX3F[FX3_USADO_OBR][2]
// aSX3F[FX3_USADO_NOBR][1] / aSX3F[FX3_USADO_NOBR][2]
// aSX3F[FX3_NUSADO][1] 	/ aSX3F[FX3_NUSADO][2]

//CT0 - Tabela de configuracao de entidades contabeis
Aadd(aSX3Alter	,{"CT0", ProxSX3("CT0","CT0_ID")		, "CT0_ID"		, "C", 002	, 0, "ID          "   	, "ID          "  , "ID          "   	, "Item da configuracao     "	, "Item da configuracion    "	, "Configuration item       "		, "@!"       , ""								, aSX3F[FX3_USADO_OBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_OBR][2]		, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CT0", ProxSX3("CT0","CT0_DESC")		, "CT0_DESC"	, "C", 030	, 0, "Descricao   "   	, "Descripcion "  , "Description "   	, "Descricao da entidade    "	, "Descripcion da ente      "	, "Entity's description     "		, "@!"       , ""								, aSX3F[FX3_USADO_OBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_OBR][2]		, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CT0", ProxSX3("CT0","CT0_CONTR")		, "CT0_CONTR"	, "C", 001	, 0, "Controla    "   	, "Controla    "  , "Control     "   	, "Controla entidade        "	, "Controla ente            "	, "Control entity           "		, "@!"       , "PERTENCE('12')"					, aSX3F[FX3_USADO_OBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_OBR][2]		, "", "", "", "S", "", "", "", ""	, "1-Sim;2-Nao"			, "1-Si;2-No"			, "1-Yes;2-No"			, "", ""															, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CT0", ProxSX3("CT0","CT0_ALIAS")		, "CT0_ALIAS"	, "C", 003	, 0, "Tabela      "   	, "Tabla       "  , "Table       "   	, "Tabela relacionada       "	, "Tabla relacionada        "	, "Related table            "		, "@!"       , ""								, aSX3F[FX3_USADO_OBR][1]	,   "" 		,    "HSPSX2"	, 1 , aSX3F[FX3_USADO_OBR][2]		, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "!(M->CT0_ALIAS $'CT1|CTT|CTD|CTH')"							, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CT0", ProxSX3("CT0","CT0_ENTIDA")	, "CT0_ENTIDA"	, "C", 002	, 0, "Entid.Plano "   	, "Entid.Plan  "  , "Plan Entity "   	, "Codigo da entidade       "	, "Codigo de la entidad     "	, "Entity's code            "		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})

//CV0 - Plano de entidades contabeis
Aadd(aSX3Alter	,{"CV0", ProxSX3("CV0","CV0_CODIGO")	, "CV0_CODIGO"	, "C", 025	, 0, "Codigo      "   	, "Codigo      "  , "Code        "   	, "Codigo da entidade       "	, "Codigo de ente           "	, "Code da entidade         "		, "@!"       , ""								, aSX3F[FX3_USADO_OBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_OBR][2]		, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "CTB050WHEN() .And. CTB050SX3('CV0_CODIGO')"					, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CV0", ProxSX3("CV0","CV0_ENTSUP")	, "CV0_ENTSUP"	, "C", 025	, 0, "Entid.Sup.  "   	, "Entid.Sup.  "  , "Higher Ent. "   	, "Entidade Superior        "	, "Entidad Superior         "	, "Higher Entity            "		, "@!"       , "CTB050SUP(,M->CV0_ENTSUP)"		, aSX3F[FX3_USADO_OBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_OBR][2]		, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "CTB050SX3('CV0_ENTSUP')"										, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CV0", ProxSX3("CV0","CV0_BLOQUE")	, "CV0_BLOQUE"	, "C", 001	, 0, "Bloqueada   "   	, "Bloqueada   "  , "Blocked     "   	, "Bloqueia codigo da Entida"	, "Bloquea codigo de Entidad"	, "Blocks Company Code      "		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "'2'" 	,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "", "S", "", "", "", ""	, "1-Sim;2-Nao"			, "1-Si;2-No"			, "1-Yes;2-No"			, "", ""															, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CV0", ProxSX3("CV0","CV0_LUCPER")	, "CV0_LUCPER"	, "C", 025	, 0, "Lucros/Perda"   	, "Ganan/Perdid"  , "Profit/Loss "   	, "Lucros e Perdas.         "	, "Ganancias y Perdidas     "	, "Profit/Losses            "		, "@!"       , "CTB105EntC(,M->CV0_LUCPER,,M->CV0_PLANO)"	, "€€€€€€€€€€€€€€ "	,   "" 	,    "CV0"		, 1 , "Ö€"							, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})
Aadd(aSX3Alter	,{"CV0", ProxSX3("CV0","CV0_PONTE ")	, "CV0_PONTE "	, "C", 025	, 0, "Conta Ponte."   	, "Cta. Ponte. "  , "Bridge Acc  "   	, "Conta Ponte.             "	, "Cuenta Ponte.            "	, "Bridge Account           "		, "@!"       , "CTB105EntC(,M->CV0_PONTE,,M->CV0_PLANO)"	, "€€€€€€€€€€€€€€ "	,   "" 	,    "CV0"		, 1 , "Ö€"							, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})

Aadd(aSX3Alter	,{"CV0", ProxSX3("CV0","CV0_BLOQUE")	, "CV0_BLOQUE"	, "C", 025	, 0, "Bloqueada   "   	, "Bloqueada   "  , "Blocked     "   	, "Bloqueia codigo da Entida"	, "Bloquea codigo de Entidad"	, "Blocks Company Code      "		, "@!"       , "CTB105EntC(,M->CV0_PONTE,,M->CV0_PLANO  "	, "€€€€€€€€€€€€€€ "	,   "" 	,    "CV0"		, 1 , "Ö€"							, "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})

Aadd(aSX3		,{"CV0", ProxSx3("CV0","CV0_ENT01")		, "CV0_ENT01"	, "C", 020 , 0	, "Conta Ctb."		, "Conta Ctb."		, "Conta Ctb."		, "Conta contabil           "  	, "Conta contabil           " 	, "Conta contabil    		"  		, "@!"       , "Ctb020cta()"					, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CT1"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "003" , "2", "S"})
Aadd(aSX3		,{"CV0", ProxSx3("CV0","CV0_E01DSC")	, "CV0_E01DSC"	, "C", 040 , 0	, "Desc.CTA"		, "Desc.CTA"		, "Desc.CTA"		, "Descr. conta contabil    "	, "Descr. conta contabil    "  	, "Descr. conta contabil    "  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

//CV2 - Cabecalho do orcamento contabil
Aadd(aSX3		,{"CV2", ProxSx3("CV2","CV2_MSBLQL")	, "CV2_MSBLQL"	, "C", 001 , 0	, "Bloqueado?"		, "Bloqueado?"		, "Bloqueado?"		, "Registro bloqueado?"			, "Registro bloqueado?"   		, "Registro bloqueado?"       		, "@!"       , "PERTENCE('12')"					, aSX3F[FX3_USADO_OBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_OBR][2]		, "", "", "",  "", "", "", "", ""	, "1-Sim;2-Nao"			, "1-Sim;2-Nao"			, "1-Sim;2-Nao"			, "", ""									  						, "", "" , "", "S"})
                            
//CV1 - Itens do orcamento contabil
Aadd(aSX3		,{"CV1", ProxSx3("CV1","CV1_OPER")		, "CV1_OPER"	, "C", 010 , 0	, "Operacao"		, "Operacao"		, "Operacao"		, "Operacao orcamentaria"		, "Operacao orcamentaria" 		, "Operacao orcamentaria"    		, "@!"       , "Vazio().Or.ExistCpo('AKF')"		, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "AKF"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})
Aadd(aSX3		,{"CV1", ProxSx3("CV1","CV1_TIPOIT")	, "CV1_TIPOIT"	, "C", 025 , 0	, "Tipo Item"		, "Tipo Item"		, "Tipo Item"		, "Tipo do item do orcamento"	, "Tipo do item do orcamento" 	, "Tipo do item do orcamento"    	, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""   		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})
Aadd(aSX3		,{"CV1", ProxSx3("CV1","CV1_DESCIT")	, "CV1_DESCIT"	, "C", 080 , 0	, "Det.item"		, "Det.item"		, "Det.item"		, "Detalhe do item do orcto."	, "Detalhe do item do orcto." 	, "Detalhe do item do orcto."    	, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""   		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "" , "", "S"})

//CT1 - Plano de Contas
Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_ENT05")		, "CT1_ENT05"	, "C", 025 , 0	, "Ag.Negocio"		, "Ag.Negocio"		, "Ag.Negocio"		, "Agente de negocio "       	, "Agente de negocio "       	, "Agente de negocio "       		, "@!"       , "CTB105EntC(,M->CT1_ENT05,,'05')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "040" , "2", "S"})
Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_E05DSC")	, "CT1_E05DSC"	, "C", 040 , 0	, "Desc.AGN"		, "Desc.AGN"		, "Desc.AGN"		, "Descr. Agente de Negocio "	, "Descr. Agente de Negocio "  	, "Descr. Agente de Negocio "  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_ENT06")		, "CT1_ENT06"	, "C", 025 , 0	, "Tp.Ativid."		, "Tp.Ativid."		, "Tp.Ativid."		, "Tipo de atividade "       	, "Tipo de atividade "       	, "Tipo de atividade "       		, "@!"       , "CTB105EntC(,M->CT1_ENT06,,'06')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".T."															, "", "042" , "2", "S"})
Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_E06DSC")	, "CT1_E06DSC"	, "C", 040 , 0	, "Desc.TPA"		, "Desc.TPA"		, "Desc.TPA"		, "Descr. Tipo de Atividade "	, "Descr. Tipos de Atividade"  	, "Descr. Tipos de Atividade"  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_ENT07")		, "CT1_ENT07"	, "C", 025 , 0	, "Prd.Comerc."		, "Prd.Comerc."		, "Prd.Comerc."		, "Produtos comercializados "	, "Produtos comercializados "	, "Produtos comercializados "		, "@!"       , "CTB105EntC(,M->CT1_ENT07,,'07')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "043" , "2", "S"})
Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_E07DSC")	, "CT1_E07DSC"	, "C", 040 , 0	, "Desc.PRD"		, "Desc.PRD"		, "Desc.PRD"		, "Descr. Prod. Comerciais  "	, "Descr. Prod. Comerciais  "  	, "Descr. Prod. Comerciais  "  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_ENT08")		, "CT1_ENT08"	, "C", 025 , 0	, "Canal Venda"		, "Canal Venda"		, "Canal Venda"		, "Canais de vendas "        	, "Canais de vendas "		 	, "Canais de vendas "				, "@!"       , "CTB105EntC(,M->CT1_ENT08,,'08')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "044" , "2", "S"})
Aadd(aSX3		,{"CT1", ProxSx3("CT1","CT1_E08DSC")	, "CT1_E08DSC"	, "C", 040 , 0	, "Desc.CNV"		, "Desc.CNV"		, "Desc.CNV"		, "Descr. Canais de Vendas  "	, "Descr. Canais de Vendas  "  	, "Descr. Canais de Vendas  "  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

//SZ2 - Canal de venda
Aadd(aSX3		,{"SZ2", ProxSx3("SZ2","Z2_EC08DB")		, "Z2_EC08DB"	, "C", 025 , 0	, "CNV.Deb.    "	, "CNV.Deb.    "	, "CNV.Deb.    "	, "CANAL VND. Debito        "  	, "CANAL VND. Debito        " 	, "CANAL VND. Debito        "		, "@!"       , "CTB105EntC(,M->Z2_EC08DB,,'08')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "044" , "2", "S"})
Aadd(aSX3		,{"SZ2", ProxSx3("SZ2","Z2_EC08CR")		, "Z2_EC08CR"	, "C", 025 , 0	, "CNV.Cred.   "	, "CNV.Cred.   "	, "CNV.Cred.   "	, "CANAL VND. Credito       "  	, "CANAL VND. Credito       " 	, "CANAL VND. Credito       "		, "@!"       , "CTB105EntC(,M->Z2_EC08CR,,'08')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ""															, "", "044" , "2", "S"})

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("CT1")
While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "CT1"
	IF Empty(SX3->X3_FOLDER)
		RecLock("SX3",.F.)
		SX3->X3_FOLDER := "1"
		MsUnlock()
	ENDIF
	SX3->(dbSkip())
End

//CTT - Centro de custos
Aadd(aSX3		,{"CTT", ProxSx3("CTT","CTT_ENT05")		, "CTT_ENT05"	, "C", 025 , 0	, "Ag.Negocio"		, "Ag.Negocio"		, "Ag.Negocio"		, "Agente de negocio "       	, "Agente de negocio "       	, "Agente de negocio "       		, "@!"       , "CTB105EntC(,M->CTT_ENT08,,'05')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "040" , "2", "S"})
Aadd(aSX3		,{"CTT", ProxSx3("CTT","CT1_E05DSC")	, "CTT_E05DSC"	, "C", 040 , 0	, "Desc.AGN"		, "Desc.AGN"		, "Desc.AGN"		, "Descr. Agente de Negocio "	, "Descr. Agente de Negocio "  	, "Descr. Agente de Negocio "  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

Aadd(aSX3		,{"CTT", ProxSx3("CTT","CTT_ENT06")		, "CTT_ENT06"	, "C", 025 , 0	, "Tp.Ativid."		, "Tp.Ativid."		, "Tp.Ativid."		, "Tipo de atividade "       	, "Tipo de atividade "       	, "Tipo de atividade "       		, "@!"       , "CTB105EntC(,M->CTT_ENT08,,'06')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "042" , "2", "S"})
Aadd(aSX3		,{"CTT", ProxSx3("CTT","CT1_E06DSC")	, "CTT_E06DSC"	, "C", 040 , 0	, "Desc.TPA"		, "Desc.TPA"		, "Desc.TPA"		, "Descr. Tipo de Atividade "	, "Descr. Tipos de Atividade"  	, "Descr. Tipos de Atividade"  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

Aadd(aSX3		,{"CTT", ProxSx3("CTT","CTT_ENT07")		, "CTT_ENT07"	, "C", 025 , 0	, "Prd.Comerc."		, "Prd.Comerc."		, "Prd.Comerc."		, "Produtos comercializados "	, "Produtos comercializados "	, "Produtos comercializados "		, "@!"       , "CTB105EntC(,M->CTT_ENT08,,'07')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "043" , "2", "S"})
Aadd(aSX3		,{"CTT", ProxSx3("CTT","CT1_E07DSC")	, "CTT_E07DSC"	, "C", 040 , 0	, "Desc.PRD"		, "Desc.PRD"		, "Desc.PRD"		, "Descr. Prod. Comerciais  "	, "Descr. Prod. Comerciais  "  	, "Descr. Prod. Comerciais  "  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

Aadd(aSX3		,{"CTT", ProxSx3("CTT","CTT_ENT08")		, "CTT_ENT08"	, "C", 025 , 0	, "Canal Venda"		, "Canal Venda"		, "Canal Venda"		, "Canais de vendas "        	, "Canais de vendas "		 	, "Canais de vendas "				, "@!"       , "CTB105EntC(,M->CTT_ENT08,,'08')", aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    "CV0"		, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "S", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".T."															, "", "044" , "2", "S"})
Aadd(aSX3		,{"CTT", ProxSx3("CTT","CT1_E08DSC")	, "CTT_E08DSC"	, "C", 040 , 0	, "Desc.CNV"		, "Desc.CNV"		, "Desc.CNV"		, "Descr. Canais de Vendas  "	, "Descr. Canais de Vendas  "  	, "Descr. Canais de Vendas  "  		, "@!"       , ""								, aSX3F[FX3_USADO_NOBR][1]	,   "" 		,    ""			, 1 , aSX3F[FX3_USADO_NOBR][2]		, "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", ".F."															, "", "" 	, "2", "S"})

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("CTT")
While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "CTT"
	IF Empty(SX3->X3_FOLDER)
		RecLock("SX3",.F.)
		SX3->X3_FOLDER := "1"
		MsUnlock()
	ENDIF
	SX3->(dbSkip())
End

dbSelectArea("SX3")
dbSetOrder(2)   

cAlias := ''
aSort(aSx3,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
ProcRegua(Len(aSX3))

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				If Ascan(aArqUpd,aSX3[i,1]) == 0
					aAdd(aArqUpd,aSX3[i,1])
				EndIf
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])		
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()        
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...")
		EndIf
	EndIf
Next i

aSort(aSX3Alter,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
ProcRegua(Len(aSX3Alter))

For i:= 1 To Len(aSX3Alter)
	If !Empty(aSX3Alter[i][1])
		If !dbSeek(aSX3Alter[i,3])
			lSX3	:= .T.
			If !(aSX3Alter[i,1]$cAlias)
				cAlias += aSX3Alter[i,1]+"/"
				If Ascan(aArqUpd,aSX3Alter[i,1]) == 0
					aAdd(aArqUpd,aSX3Alter[i,1])
				EndIf
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3Alter[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3Alter[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...")

		Else // Tratamento de alteracao para campos já existentes
		
			lSX3	:= .T.
			If !(aSX3Alter[i,1]$cAlias)
				cAlias += aSX3Alter[i,1]+"/"
				If Ascan(aArqUpd,aSX3Alter[i,1]) == 0
					aAdd(aArqUpd,aSX3Alter[i,1])
				EndIf
			EndIf

			RecLock("SX3",.F.)
			For j:=1 To Len(aSX3Alter[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3Alter[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...")
			
		EndIf
	EndIf
Next i

// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Exclusao de Campos 
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

For i := 1 To Len( aSX3Del )
	If !Empty( aSX3Del[i][1] )
		If dbSeek( aSX3Del[i,3] )
			lSX3	:= .T.
			If !( aSX3Del[i,1] $ cAlias )
				cAlias += aSX3Del[i,1]+"/"
				If Ascan(aArqUpd,aSX3Del[i,1]) == 0
					aAdd(aArqUpd,aSX3Del[i,1])
				EndIf
			EndIf

			RecLock("SX3")
			SX3->( dbDelete() )
			dbCommit()
			SX3->( MsUnLock() )
			IncProc("Atualizando Dicionario de Dados...")
		EndIf
	EndIf
Next i

If lSX3
	cTexto := "Tabelas atualizadas : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSX5 ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX5                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSX5()
//  "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"

Local aSX5   := {}
Local aSX5Alter   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX5	 := .F.
Local cTexto := ""	

If (cPaisLoc == "BRA")
	aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
Else
	aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
EndIf

//EXEMPLO
/*
Aadd(aSX5,{})
*/

ProcRegua(Len(aSX5))

dbSelectArea("SX5")
dbSetOrder(1)
For i:= 1 To Len(aSX5)
	If !Empty(aSX5[i][2])
		If !MsSeek(aSX5[i,1]+aSX5[i,2]+aSX5[i,3])
    		
    		lSX5 := .T.
			RecLock("SX5",.T.)
			
			For j:=1 To Len(aSX5[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX5[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Tabelas...")
		EndIf
	EndIf
Next i

For i:= 1 To Len(aSX5Alter)
	If !Empty(aSX5Alter[i][2])
		lGrava := !(MsSeek(aSX5Alter[i,1]+aSX5Alter[i,2]+aSX5Alter[i,3]))
		
		lSX5 := .T.
		RecLock("SX5",lGrava)
		
		For j:=1 To Len(aSX5Alter[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSX5Alter[i,j])
			EndIf
		Next j
		
		dbCommit()
		MsUnLock()
		IncProc("Atualizando Tabelas...")
	EndIf
Next i

If lSX5
	cTexto := "Arquivo de tabelas (SX5) atualizado."+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSX6 ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX6                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSX6()
//  X6_FIL   X6_VAR     X6_TIPO    X6_DESCRIC X6_DSCSPA  X6_DSCENG  X6_DESC1 X6_DSCSPA1 X6_DSCENG1
//  X6_DESC2 X6_DSCSPA2 X6_DSCENG2 X6_CONTEUD X6_CONTSPA X6_CONTENG X6_PROPRI

Local aSX6			:= {}
Local aSX6Alter		:= {}
Local aEstrut		:= {}
Local i				:= 0
Local j				:= 0
Local lSX6			:= .F.
Local cTexto 		:= ''
Local cAlias 		:= ''
Local nTamFilial 	:= UPDTAMSXG( "033", TamSX3( "E2_FILIAL" )[1] )[1]

If (cPaisLoc == "BRA")
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO",;
				"X6_DESCRIC","X6_DSCSPA","X6_DSCENG",;
				"X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
				"X6_DESC2","X6_DSCSPA2","X6_DSCENG2",;
				"X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"}
Else
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO",;
				"X6_DESCRIC","X6_DSCSPA","X6_DSCENG",;
				"X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
				"X6_DESC2","X6_DSCSPA2","X6_DSCENG2",;
				"X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"}
EndIf

		//50 caracteres por linha de descricao
		//  "12345678901234567890123456789012345678901234567890
AADD(aSX6,{	SPACE(nTamFilial),"MV_CSB1SEG","C",;
			"Segmentos de produtos que serao sincronizados ",;
			"Segmentos de produtos que serao sincronizados ",;
			"Segmentos de produtos que serao sincronizados ",;
			"com o cadastro da entidade contail 07 -PRD.COM",;
			"com o cadastro da entidade contail 07 -PRD.COM",;
			"com o cadastro da entidade contail 07 -PRD.COM",;
			"Separar os segmentos por '/'",;
			"Separar os segmentos por '/'",;
			"Separar os segmentos por '/'",;
			"0001/0002/0003/0004/0005/0006/0007/0008/0011/0012/0013/0014/0015",;
			"0001/0002/0003/0004/0005/0006/0007/0008/0011/0012/0013/0014/0015",;
			"0001/0002/0003/0004/0005/0006/0007/0008/0011/0012/0013/0014/0015",;
			"U"})

		//50 caracteres por linha de descricao
		//  "12345678901234567890123456789012345678901234567890
/*
AADD(aSX6,{	SPACE(nTamFilial),"MV_CSCV0SN","L",;
			"Indica se o botao de sincronizar cadastros sera ",;
			"Indica se o botao de sincronizar cadastros sera ",;
			"Indica se o botao de sincronizar cadastros sera ",;
			"exibido no browse dos cadastros de produtos, ",;
			"exibido no browse dos cadastros de produtos, ",;
			"exibido no browse dos cadastros de produtos, ",;
			"clientes e fornecedores, dependendo do usuario.",;
			"clientes e fornecedores, dependendo do usuario.",;
			"clientes e fornecedores, dependendo do usuario.",;
			"F",;
			"F",;
			"F",;
			"U"})
*/
		//50 caracteres por linha de descricao
		//  "12345678901234567890123456789012345678901234567890
/*
AADD(aSX6,{	SPACE(nTamFilial),"MV_CSCV0US","",;
			"Usuarios que poderao utilizar o recurso de ",;
			"Usuarios que poderao utilizar o recurso de ",;
			"Usuarios que poderao utilizar o recurso de ",;
			"sincronizar os cadastros de produtos, clientes e ",;
			"sincronizar os cadastros de produtos, clientes e ",;
			"sincronizar os cadastros de produtos, clientes e ",;
			"fornecedores com o cadastro de plano contabil.",;
			"fornecedores com o cadastro de plano contabil.",;
			"fornecedores com o cadastro de plano contabil.",;
			"",;
			"",;
			"",;
			"U"})
*/
ProcRegua(Len(aSX6))

dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !MsSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Parametros...")
		EndIf
	EndIf
Next i

For i:= 1 To Len(aSX6Alter)
	If !Empty(aSX6Alter[i][2])
		// Não encontrou, então inclui normalmente		
		If !dbSeek(aSX6Alter[i,1]+aSX6Alter[i,2])
			lSX6	:= .T.
			If !(aSX6Alter[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6Alter[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6Alter[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Parametros...")
		Else // Encontrou, então procede com a atualizacao
			lSX6	:= .T.
			If !(aSX6Alter[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.F.)
			For j:=1 To Len(aSX6Alter[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6Alter[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Parametros...")
		EndIf
	EndIf
Next i

If lSX6
	cTexto := "Incluidos novos parametros. Verifique as suas configuracoes e funcionalidades : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSX7 ³ Autor ³ --------------------  ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX7                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSX7()
//  X7_CAMPO X7_SEQUENC X7_REGRA X7_CDOMIN X7_TIPO X7_SEEK X7_ALIAS X7_ORDEM X7_CHAVE X7_PROPRI X7_CONDIC

Local aSX7   := {}
Local aSX7Del:= {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSX7	 := .F.

If (cPaisLoc == "BRA")
	aEstrut:= {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}
Else
	aEstrut:= {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}
EndIf

AADD(aSX7, {"CT1_ENT05","001","CV0->CV0_DESC","CT1_E05DSC","P","S","CV0",1,"xFilial('CV0')+'05'+M->CT1_ENT05","U","!EMPTY(M->CT1_ENT05)"})
AADD(aSX7, {"CT1_ENT06","001","CV0->CV0_DESC","CT1_E06DSC","P","S","CV0",1,"xFilial('CV0')+'06'+M->CT1_ENT06","U","!EMPTY(M->CT1_ENT06)"})
AADD(aSX7, {"CT1_ENT07","001","CV0->CV0_DESC","CT1_E07DSC","P","S","CV0",1,"xFilial('CV0')+'07'+M->CT1_ENT07","U","!EMPTY(M->CT1_ENT07)"})
AADD(aSX7, {"CT1_ENT08","001","CV0->CV0_DESC","CT1_E08DSC","P","S","CV0",1,"xFilial('CV0')+'08'+M->CT1_ENT08","U","!EMPTY(M->CT1_ENT08)"})
AADD(aSX7, {"CTT_ENT05","001","CV0->CV0_DESC","CTT_E05DSC","P","S","CV0",1,"xFilial('CV0')+'05'+M->CTT_ENT05","U","!EMPTY(M->CTT_ENT05)"})
AADD(aSX7, {"CTT_ENT06","001","CV0->CV0_DESC","CTT_E06DSC","P","S","CV0",1,"xFilial('CV0')+'06'+M->CTT_ENT06","U","!EMPTY(M->CTT_ENT06)"})
AADD(aSX7, {"CTT_ENT07","001","CV0->CV0_DESC","CTT_E07DSC","P","S","CV0",1,"xFilial('CV0')+'07'+M->CTT_ENT07","U","!EMPTY(M->CTT_ENT07)"})
AADD(aSX7, {"CTT_ENT08","001","CV0->CV0_DESC","CTT_E08DSC","P","S","CV0",1,"xFilial('CV0')+'08'+M->CTT_ENT08","U","!EMPTY(M->CTT_ENT08)"})
AADD(aSX7, {"CV0_ENT01","001","CT1->CT1_DESC01","CV0_E01DSC","P","S","CT1",1,"xFilial('CT1')+M->CV0_ENT01","U","!EMPTY(M->CV0_ENT01)"})

ProcRegua(Len(aSX7))

dbSelectArea("SX7")
dbSetOrder(1)
// Inclusao de Gatilhos
For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !MsSeek(aSX7[i,1]+aSX7[i,2])
			lSX7 := .T.
			If !(aSX7[i,1]$cAlias)
				cAlias += aSX7[i,1]+"/"
			EndIf
			RecLock("SX7",.T.)
			
			For j:=1 To Len(aSX7[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Gatilhos...")
		EndIf
	EndIf
Next i

// Exclusao de Gatilhos
For i:= 1 To Len( aSX7Del )
	If !Empty( aSX7Del[i][1] )
		If MsSeek( aSX7Del[i,1] + aSX7Del[i,2] )
			lSX7 := .T.
			If !( aSX7Del[i,1] $ cAlias )
				cAlias += aSX7Del[i,1] + "/"
			EndIf
			RecLock( "SX7" )
			SX7->( dbDelete() )
			dbCommit()
			SX7->( MsUnLock() )
			IncProc("Atualizando Gatilhos...")
		EndIf
	EndIf
Next i

If lSX7
	cTexto := "Gatilhos atualizados : "+cAlias+CRLF //
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSXA ³ Autor ³ --------------------  ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SXA                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSXA()
//"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"

Local aSXA   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local aSX3	 := {}
Local nX	 := 0
Local lSXA	 := .F.
Local cAlias := ''
Local cTexto := ""

If (cPaisLoc == "BRA")
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
Else
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
EndIf

/*EXEMPLO PARA ALTERAR PASTAS
aSXA:= 	{	{"AF1","3","Codigo Estruturado","Codigo Estruturado","Structured Number","S"},;
{"AF8","5","Codigo Estruturado","Codigo Estruturado","Structured Number","S"},;
{"AFF","2","Contratos","Contratos","Contratos","S"}	}
*/

AADD(aSXA,{"CT1","1","Principal","Principal","Principal","U"})
AADD(aSXA,{"CT1","2","Orcamento","Orcamento","Orcamento","U"})

AADD(aSXA,{"CTT","1","Principal","Principal","Principal","U"})
AADD(aSXA,{"CTT","2","Orcamento","Orcamento","Orcamento","U"})

ProcRegua(Len(aSXA))

dbSelectArea("SXA")
dbSetOrder(1)
For i:= 1 To Len(aSXA)
	If !Empty(aSXA[i][1])
		If !MsSeek(aSXA[i,1]+aSXA[i,2])
			lSXA := .T.
			
			If !(aSXA[i,1]$cAlias)
				cAlias += aSXA[i,1]+"/"
			EndIf
			
			RecLock("SXA",.T.)
			For j:=1 To Len(aSXA[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXA[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Folder de Cadastro...")
		EndIf
	EndIf
Next i

aSX3 := {}

dbSelectArea("SX3")
dbSetOrder(2)
For nx := 1 to Len(aSX3)
	If MsSeek(aSX3[nx][1])
		RecLock("SX3",.F.)
		SX3->X3_FOLDER := aSX3[nx][2]
		MsUnlock()
	EndIf
Next

If lSXA
	cTexto := "Atualizado arquivos de folders (SXA)."+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSXB ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SXB                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSXB()
//  XB_ALIAS XB_TIPO XB_SEQ XB_COLUNA XB_DESCRI XB_DESCSPA XB_DESCENG XB_CONTEM

Local aSXB   := {}
Local aAjSXB := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSXB   := .F.

If (cPaisLoc == "BRA")
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
Else
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
EndIf                   	

Aadd(aSXB,{"CT0PLN","1","01"	,"DB"	,"Entidades Contabeis "		,"Entidades Contabeis "		,"Entidades Contabeis "		,"CT0"})
Aadd(aSXB,{"CT0PLN","2","01"	,"01"	,"ID                  "		,"ID                  "		,"ID                  "		,""})
Aadd(aSXB,{"CT0PLN","4","01"	,"01"	,"ID                  "		,"ID                  "		,"ID                  "		,"CT0_ID"})
Aadd(aSXB,{"CT0PLN","4","01"	,"02"	,"Descricao           "		,"Descricao           "		,"Descricao           "		,"CT0_DESC"})
Aadd(aSXB,{"CT0PLN","4","01"	,"03"	,"Entid. Plano        "		,"Entid. Plano        "		,"Entid. Plano        "		,"CT0_ENTIDA"})
Aadd(aSXB,{"CT0PLN","5",""		,""	,""								,""								,""								,"CT0->CT0_ID"})
Aadd(aSXB,{"CT0PLN","5",""		,""	,""								,""								,""								,"CT0->CT0_ENTIDA"})

ProcRegua(Len(aSXB))

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !MsSeek(Padr(aSXB[i,1], Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			lSXB := .T.
			If !(aSXB[i,1]$cAlias)
				cAlias += aSXB[i,1]+"/"
			EndIf
			
			RecLock("SXB",.T.)
			
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Consultas Padroes...")
		EndIf
	EndIf
Next i

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aAjSXB)
	If !Empty(aAjSXB[i][1])
		If MsSeek(PadR(aAjSXB[i,1], Len(SXB->XB_ALIAS))+aAjSXB[i,2]+aAjSXB[i,3]+aAjSXB[i,4])
			If Upper(AllTrim(FieldGet(FieldPos(aAjSXB[i,5,1])))) # Upper(AllTrim(aAjSXB[i,5,2]))
				lSXB := .T.
				If !(aAjSXB[i,1]$cAlias)
					cAlias += aAjSXB[i,1]+"/"
				EndIf
				RecLock("SXB",.F.)
				If !Empty(FieldName(FieldPos(aAjSXB[i,5,1])))
					FieldPut(FieldPos(aAjSXB[i,5,1]),aAjSXB[i,5,2])
				EndIf
				dbCommit()
				MsUnLock()
				IncProc("Atualizando Consultas Padroes...")
			EndIf
		EndIf
	EndIf
Next i

If lSXB
	cTexto := "Consultas Padroes Atualizadas : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSXD ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SXD                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSXD()
Local aSXD   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSXD   := .F.

aEstrut:= { "XD_TIPO","XD_FUNCAO","XD_PERGUNT","XD_ORDBRZ","XD_ORDSPA","XD_ORDENG",;
			"XD_PROPRI","XD_TITBRZ","XD_TITSPA","XD_TITENG","XD_DESCBRZ","XD_DESCSPA",;
			"XD_DESCENG"}

//EXEMPLO
/*
AADD(aSXD,{"P","ATFA370","AFA370","","","",;
		   "S",;
		   "Contabilização Off-Line da deprec. do Ativo",;
		   "Contabilidad Off-Line deprec. del Activo",;
		   "Depreciation Asset Off-line Account",;
		   "Este programa tem como objetivo efetuar a contabilizacao off-line das depreciações do módulo Ativo Fixo",;
		   "Este programa tiene como objetivo efectuar la contabilidad off-line de las depreciaciones del módulo Activo Fijo",;
		   "The aim of this program is to account off-line the Fixed Asset module depreciations"})		   
*/

ProcRegua(Len(aSXD))

dbSelectArea("SXD")
dbSetOrder(1) // FUNCAO
For i:= 1 To Len(aSXD)
	If !Empty(aSXD[i][1])
		If !MsSeek(Padr(aSXD[i,2], Len(SXD->XD_FUNCAO)))
			lSXD := .T.
			If !(aSXD[i,2]$cAlias)
				cAlias += aSXD[i,2]+"/"
			EndIf
			
			RecLock("SXD",.T.)
			
			For j:=1 To Len(aSXD[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXD[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando configuracao do Scheduler.")
		EndIf
	EndIf
Next i

If lSXD
	cTexto := "Configuracoes do Schedule atualizadas: "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ProxSX3   ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna a próxima ordem disponivel no SX3 para o ALIAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProxSX3(cAlias,cCpo)

Local aArea 	:= GetArea()
Local aAreaSX3 	:= SX3->(GetArea())
Local nOrdem	:= 0
Local nPosOrdem	:= 0

Static aOrdem	:= {}

Default cCpo	:= ""

IF !Empty(cCpo)
	SX3->(DbSetOrder(2))
	IF SX3->(MsSeek(cCpo))
		nOrdem := Val(RetAsc(SX3->X3_ORDEM,3,.F.))
	ENDIF
ENDIF

IF Empty(cCpo) .OR. nOrdem == 0

	IF (nPosOrdem := aScan(aOrdem, {|aLinha| aLinha[1] == cAlias})) == 0
	
		SX3->(dbSetOrder(1))
		SX3->(MsSeek(cAlias))
		WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cAlias
			nOrdem++
			SX3->(dbSkip())
		END	
		nOrdem++
		AADD(aOrdem,{cAlias,nOrdem})
	
	ELSE
    	aOrdem[nPosOrdem][2]++
    	nOrdem := aOrdem[nPosOrdem][2]
    ENDIF

ENDIF

RestArea(aAreaSX3)
RestArea(aArea)
Return RetAsc(Str(nOrdem),2,.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ProxSIX   ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna a próxima ordem disponivel no SIX para o ALIAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProxSIX(cAlias)

Local aArea 	:= GetArea()
Local aAreaSIX 	:= SIX->(GetArea())
Local nOrdem	:= 0
Local nPosOrdem	:= 0

Static aOrdem	:= {}

DbSelectArea("SIX")
DbSetOrder(1)

IF (nPosOrdem := aScan(aOrdem, {|aLinha| aLinha[1] == cAlias})) == 0

	IF SIX->(MsSeek(cAlias))
		WHILE SIX->(!EOF()) .AND. SIX->INDICE == cAlias
			nOrdem := Val(RetAsc(SIX->ORDEM,2,.F.))
			SIX->(DbSkip())		
		END
	ENDIF

	nOrdem++
	AADD(aOrdem,{cAlias,nOrdem})	

ELSE
   	aOrdem[nPosOrdem][2]++
   	nOrdem := aOrdem[nPosOrdem][2]
ENDIF

RestArea(aAreaSIX)
RestArea(aArea)
Return RetAsc(Str(nOrdem),1,.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ValidSIX   ³ Autor ³ ----------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Valida a chave de indice ou nickname para inclusao do SIX      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION ValidSIX(cAlias, cOrdem, cChave, cNickName)
Local lRet 		:= .T.
Local aArea 	:= GetArea()
Local aAreaSIX  := SIX->(GetArea())

DbSelectArea("SIX")
DbSeek(cAlias)
While SIX->(!Eof()) .AND. SIX->INDICE == cAlias
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se jah existe um indice para o Alias e Ordem informados       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF SIX->INDICE == cAlias .AND. SIX->ORDEM == cOrdem
		lRet := .F.
		Exit
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se jah existe um indice para o Alias com a chave informada    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF SIX->INDICE == cAlias .AND. ALLTRIM(SIX->CHAVE) == ALLTRIM(cChave)
		lRet := .F.
		Exit
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se jah existe um indice para o Alias e NickName informados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF SIX->INDICE == cAlias .AND. ALLTRIM(SIX->NICKNAME) == ALLTRIM(cNickName)
		lRet := .F.
		Exit
	ENDIF

	SIX->(DbSkip())
End

RETURN lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUHlp  ³ Autor ³ ----------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da atualizacao dos helps de campos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUHlp()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpEsp	:= {}
Local cTexto	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adicionar aqui as tabelas atualizadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAlias	:= ""

// EXEMPLO
/*
aHelpPor :=	{	"Indica se devem ser considerados todos os",;
				" bens, independente de haver saldo a     ",;
				"depreciar, ou somente os bens com saldo  ",;
				"a depreciar."}                           
				
aHelpEng :=	{	"Indica se devem ser considerados todos os",;
				" bens, independente de haver saldo a     ",;
				"depreciar, ou somente os bens com saldo  ",;
				"a depreciar."}

aHelpEsp :=	{	"Indica se devem ser considerados todos os",;
				" bens, independente de haver saldo a     ",;
				"depreciar, ou somente os bens com saldo  ",;
				"a depreciar."}

PutSX1Help("P.ATR05008.",aHelpPor,aHelpEng,aHelpEsp)
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Help                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty(cAlias)
	cTexto := "Atualizados os helps de campos das tabelas: "+cAlias+CRLF
Endif

Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³UPDTamSXG ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao para obter o tamanho padrao do campo conforme SXG.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDTamSXG( cGrupo, nTamPad )

Local aRet

DbSelectArea( "SXG" )
DbSetOrder( 1 )

If DbSeek( cGrupo )
	nTamPad := SXG->XG_SIZE
	aRet := { nTamPad, "@!", nTamPad, nTamPad }
Else
	aRet := { nTamPad, "@!", nTamPad, nTamPad }
EndIf

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDATUSXG ³ Autor ³ --------------------- ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SXG                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ATUALIZACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDATUSXG()

Local aSXG   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSXG   := .F.

aEstrut:= { "XG_GRUPO","XG_DESCRI","XG_DESSPA","XG_DESENG","XG_SIZEMAX","XG_SIZEMIN","XG_SIZE","XG_PICTURE"}
			
// EXEMPLO
/*
AADD(aSXG,{"058","Local do bem","Local del bien","Asset Location",12,6,6,"@!"})
*/

ProcRegua(Len(aSXG))

dbSelectArea("SXG")
dbSetOrder(1) // FUNCAO
For i:= 1 To Len(aSXG)
	If !Empty(aSXG[i][1])
		If !MsSeek(Padr(aSXG[i,1],Len(SXG->XG_GRUPO)))
			lSXG := .T.
			If !(aSXG[i,1]$cAlias)
				cAlias += aSXG[i,1]+"/"
			EndIf
			
			RecLock("SXG",.T.)
			
			For j:=1 To Len(aSXG[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXG[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando grupo de campos")
		EndIf
	EndIf
Next i

If lSXG
	cTexto := "Grupo de campos atualizados: "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ESCEMPRESAºAutor  ³ Ernani Forastieri  º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Generica para escolha de Empresa, montado pelo SM0_ º±±
±±º          ³ Retorna vetor contendo as selecoes feitas.                 º±±
±±º          ³ Se nao For marcada nenhuma o vetor volta vazio.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EscEmpresa()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametro  nTipo                           ³
//³ 1  - Monta com Todas Empresas/Filiais      ³
//³ 2  - Monta so com Empresas                 ³
//³ 3  - Monta so com Filiais de uma Empresa   ³
//³                                            ³
//³ Parametro  aMarcadas                       ³
//³ Vetor com Empresas/Filiais pre marcadas    ³
//³                                            ³
//³ Parametro  cEmpSel                         ³
//³ Empresa que sera usada para montar selecao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


If !UpdOpenSM0(.F.)
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
@ 123, 90 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando máscara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Seleção"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Seleção" Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³MARCATODOSºAutor  ³ Ernani Forastieri  º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Auxiliar para marcar/desmarcar todos os itens do    º±±
±±º          ³ ListBox ativo                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³INVSELECAOºAutor  ³ Ernani Forastieri  º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Auxiliar para inverter selecao do ListBox Ativo     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³RETSELECAOºAutor  ³ Ernani Forastieri  º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Auxiliar que monta o retorno com as selecoes        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ MARCAMAS ºAutor  ³ Ernani Forastieri  º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar/desmarcar usando mascaras               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ VERTODOS ºAutor  ³ Ernani Forastieri  º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao auxiliar para verificar se estao todos marcardos    º±±
±±º          ³ ou nao                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³UpdOpenSM0º Autor ³ ------------------ º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³Funcao de processamento abertura do SM0 modo exclusivo      ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ATUALIZACAO                                                 ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UpdOpenSM0(lShared)

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
