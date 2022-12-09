#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |Updge34   ºAutor  ³ Otacilio A. Junior º Data ³ 07/Fev/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizador de dicionarios para corrigir o tamnaho dos      º±±
±±º          ³JBL_ITEM E JD2_ITEM E JCG_ITEM, JCH_ITEM e JCW_ITEM.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GE                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UpdGE34() //Para maiores detalhes sobre a utilizacao deste fonte leia o boletim

cArqEmp := "Sigamat.emp"
__cInterNet := Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd

Set Dele On

lHistorico 	:= MsgYesNo("Deseja efetuar a atualização do dicionário? Esta rotina deve ser utilizada em modo exclusivo! Faca um backup dos dicionários e da base de dados antes da atualização para eventuais falhas de atualização!", "Atenção")

If lHistorico
	Processa({|lEnd| GEProc(@lEnd)},"Processando","Aguarde, preparando os arquivos",.F.)
	Final("Atualização efetuada!")
endif
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEProc    ³ Autor ³ Otacilio A. Junior   º Data ³ 08/Fev/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEProc(lEnd)
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cFile     :="" //Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}				     
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo   := 49 				//SIGAGE - GESTAO EDUCACIONAL

/********************************************************************************************
Inicia o processamento.
********************************************************************************************/
ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If ( lOpen := MyOpenSm0Ex() )

	dbSelectArea("SM0")
	dbGotop()
	While !Eof() 
		If ( nI := Ascan( aRecnoSM0, {|x| x[2] == M0_CODIGO} ) ) == 0 
			aAdd(aRecnoSM0,{Recno(),M0_CODIGO,{}})
			nI := Len(aRecnoSM0)
		EndIf
		
		aAdd( aRecnoSM0[nI,3], SM0->M0_CODFIL )
		
		dbSkip()
	EndDo	
		
	If lOpen
		For nI := 1 To Len(aRecnoSM0)

			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RPCSetType(3)	// Não consome licensa de uso
			RpcSetEnv (SM0->M0_CODIGO, SM0->M0_CODFIL,,,"GE",,)
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
			
			ProcRegua(3)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionário de Dados...")
			cTexto += AtuSX3()

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
					Aviso("Atenção!","Ocorreu um erro desconhecido durante a atualização da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionário e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
			Next nX

			//Utiliza o Select Area para forcar a criacao das tabelas
			dbSelectArea("JBL")
			dbSelectArea("JD2")
			dbSelectArea("JCG")
			dbSelectArea("JCH")
		   
			// Atualiza a base de dados da empresa para cada filial
			For nX := 1 To Len(aRecnoSM0[nI,3])

				RpcSetType(3)
				RpcSetEnv (aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX],,,"GE",,)
				lMsFinalAuto := .F.

				IncProc( dtoc( Date() )+" "+Time()+" "+"Início - Atualizando Tabelas")
				Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Atualizando Tabelas")
		
				cTexto+= AtuBase(aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX])
			  
				IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Atualizando Tabelas")
				Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Atualizando Tabelas")

				RpcClearEnv()
			Next nX
			
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
			
		Next nI 
		If lOpen
			cTexto := "Log da atualização "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualização concluída." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
		EndIf 
	EndIf
EndIf 	

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  AtuSX3  ³ Autor ³ Otacilio A. Junior   ³ Data ³ 08/02/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3 - Campos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSX3()
Local aEstrut        := {}              //Array com a estrutura da tabela SX3
Local cTexto         := ''				//String para msg ao fim do processo

/*******************************************************************************************
Define a estrutura do array
*******************************************/
aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
			"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
			"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
			"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

/*******************************************************************************************
Seleciona as informacoes de alguns campos para uso posterior
*******************************************/
if SX3->( dbSeek("JD2_ITEM") ) .AND. SX3->X3_TAMANHO != 3
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 3
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JD2' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JD2")
endif

if SX3->( dbSeek("JBL_ITEM") ) .AND. SX3->X3_TAMANHO != 3
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 3
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JBL' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JBL")
endif

if SX3->( dbSeek("JCG_ITEM") ) .AND. SX3->X3_TAMANHO != 3
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 3
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JCG' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JCG")
endif

if SX3->( dbSeek("JCH_ITEM") ) .AND. SX3->X3_TAMANHO != 3
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 3
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JCH' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JCH")
endif

if SX3->( dbSeek("JCW_ITEM") ) .AND. SX3->X3_TAMANHO != 3
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 3
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JCW' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JCW")
endif

Return cTexto         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³ Otacilio A. Junior   ³ Data ³08/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±         
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MyOpenSM0Ex()

Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) 	
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 

If !lOpen
	Aviso( "Atenção !", "Não foi possível a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AtuBase   ³ Autor ³ Otacilio A. Junior   ³ Data ³ 08/02/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Prepara as Empresas para Processo de Atualizacao	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AtuBase(cEmp, cFil)
Local aAlias := GetArea() 
Local cTexto := '' 				//Exibira o log ao final do processo
Local lMSSQL := "MSSQL"$Upper(TCGetDB())
Local lMySQL := "MYSQL"$Upper(TCGetDB())

IncProc( dtoc(dDataBase) + " " + Time()+ " Inicio Atualização da Base de Dados ")
cTexto += dtoc( Date() )+" "+Time()+" Início Atualização da Base de Dados "+cEmp + " " +cFil+CHR(13)+CHR(10)

//Atualiza todos os campos ITEM incluindo 0 (zero) a esquerda

//Atualiza tabela JBL
dbSelectArea("JBL")
if lMSSQL //SQL
	TCSQLExec( " UPDATE " + RetSQLName("JBL") + " SET JBL_ITEM = ('0'+JBL_ITEM) WHERE LEN(JBL_ITEM) < 3 AND JBL_ITEM <> ' ' " )
elseif lMySQL //MySQL
	TCSQLExec( " UPDATE " + RetSQLName("JBL") + " SET JBL_ITEM = concat('0',JBL_ITEM) WHERE LEN(JBL_ITEM) < 3 AND JBL_ITEM <> ' ' " )
else
	TCSQLExec( " UPDATE " + RetSQLName("JBL") + " SET JBL_ITEM = ('0'||TRIM(JBL_ITEM)) WHERE LENGTH(TRIM(JBL_ITEM)) < 3 AND JBL_ITEM <> ' ' " )
endif
TCSQLExec( " UPDATE " + RetSQLName("JBL") + " SET JBL_ITEM = '"+Space(TamSX3("JBL_ITEM")[1])+"' WHERE JBL_ITEM = ' ' " )
TCSQLExec( "Commit" )

//Atualiza tabela JD2
dbSelectArea("JD2")      
if lMSSQL //SQL
	TCSQLExec( " UPDATE " + RetSQLName("JD2") + " SET JD2_ITEM = ('0'+JD2_ITEM) WHERE LEN(JD2_ITEM) < 3 AND JD2_ITEM <> ' ' " )
elseif lMySQL //MySQL
	TCSQLExec( " UPDATE " + RetSQLName("JD2") + " SET JD2_ITEM = concat('0',JD2_ITEM) WHERE LEN(JD2_ITEM) < 3 AND JD2_ITEM <> ' ' " )
else
	TCSQLExec( " UPDATE " + RetSQLName("JD2") + " SET JD2_ITEM = ('0'||TRIM(JD2_ITEM)) WHERE LENGTH(TRIM(JD2_ITEM)) < 3 AND JD2_ITEM <> ' ' " )
endif
TCSQLExec( " UPDATE " + RetSQLName("JD2") + " SET JD2_ITEM = '"+Space(TamSX3("JD2_ITEM")[1])+"' WHERE JD2_ITEM = ' ' " )
TCSQLExec( "Commit" )

//Atualiza tabela JCG
dbSelectArea("JCG")
if JCG->( FieldPos( "JCG_ITEM" ) ) > 0
	if lMSSQL //SQL
		TCSQLExec( " UPDATE " + RetSQLName("JCG") + " SET JCG_ITEM = ('0'+JCG_ITEM) WHERE LEN(JCG_ITEM) < 3 AND JCG_ITEM <> ' ' " )
	elseif lMySQL //MySQL
		TCSQLExec( " UPDATE " + RetSQLName("JCG") + " SET JCG_ITEM = concat('0',JCG_ITEM) WHERE LEN(JCG_ITEM) < 3 AND JCG_ITEM <> ' ' " )
	else
		TCSQLExec( " UPDATE " + RetSQLName("JCG") + " SET JCG_ITEM = ('0'||TRIM(JCG_ITEM)) WHERE LENGTH(TRIM(JCG_ITEM)) < 3 AND JCG_ITEM <> ' ' " )
	endif
	TCSQLExec( " UPDATE " + RetSQLName("JCG") + " SET JCG_ITEM = '"+Space(TamSX3("JCG_ITEM")[1])+"' WHERE JCG_ITEM = ' ' " )
	TCSQLExec( "Commit" )
endif

//Atualiza tabela JCH
dbSelectArea("JCH")
if JCH->( FieldPos( "JCH_ITEM" ) ) > 0
	if lMSSQL //SQL
		TCSQLExec( " UPDATE " + RetSQLName("JCH") + " SET JCH_ITEM = ('0'+JCH_ITEM) WHERE LEN(JCH_ITEM) < 3 AND JCH_ITEM <> ' ' " )
	elseif lMySQL //MySQL
		TCSQLExec( " UPDATE " + RetSQLName("JCH") + " SET JCH_ITEM = concat('0',JCH_ITEM) WHERE LEN(JCH_ITEM) < 3 AND JCH_ITEM <> ' ' " )
	else
		TCSQLExec( " UPDATE " + RetSQLName("JCH") + " SET JCH_ITEM = ('0'||TRIM(JCH_ITEM)) WHERE LENGTH(TRIM(JCH_ITEM)) < 3 AND JCH_ITEM <> ' ' " )
	endif
	TCSQLExec( " UPDATE " + RetSQLName("JCH") + " SET JCH_ITEM = '"+Space(TamSX3("JCH_ITEM")[1])+"' WHERE JCH_ITEM = ' ' " )
	TCSQLExec( "Commit" )
endif

//Atualiza tabela JCW
dbSelectArea("JCW")
if JCW->( FieldPos( "JCW_ITEM" ) ) > 0
	if lMSSQL //SQL
		TCSQLExec( " UPDATE " + RetSQLName("JCW") + " SET JCW_ITEM = ('0'+JCW_ITEM) WHERE LEN(JCW_ITEM) < 3 AND JCW_ITEM <> ' ' " )
	elseif lMySQL //MySQL
		TCSQLExec( " UPDATE " + RetSQLName("JCW") + " SET JCW_ITEM = concat('0',JCW_ITEM) WHERE LEN(JCW_ITEM) < 3 AND JCW_ITEM <> ' ' " )
	else
		TCSQLExec( " UPDATE " + RetSQLName("JCW") + " SET JCW_ITEM = ('0'||TRIM(JCW_ITEM)) WHERE LENGTH(TRIM(JCW_ITEM)) < 3 AND JCW_ITEM <> ' ' " )
	endif
	TCSQLExec( " UPDATE " + RetSQLName("JCW") + " SET JCW_ITEM = '"+Space(TamSX3("JCW_ITEM")[1])+"' WHERE JCW_ITEM = ' ' " )
	TCSQLExec( "Commit" )
endif

IncProc( dtoc(dDataBase) + " " + Time()+ " Fim Atualização da Base de Dados")
cTexto+=dtoc( Date() )+" "+Time()+" "+"Fim Atualização da Base de Dados "+cEmp + " " +cFil+CHR(13)+CHR(10)

RestArea(aAlias)
Return(cTexto)