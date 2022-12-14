#INCLUDE "Protheus.ch"
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯屯淹屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北? Programa  | UpdGe38   ? Autor ? Otacilio A. Junior ? Data ? 27/Mai/2008 罕?
北掏屯屯屯屯屯赝屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北? Desc.     矨tualizador de dicionarios para corrigir o tamnaho dos campos罕?
北?           矹A1_RG, JA2_RG, JBJ_RG, JC1_RG, JCR_RG e JHP_RG, JHH_CONTEXT.罕?
北掏屯屯屯屯屯赝屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北? Uso       ? GE                                                          罕?
北韧屯屯屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
User Function UpdGE38() //Para maiores detalhes sobre a utilizacao deste fonte leia o boletim

cArqEmp := "Sigamat.emp"
__cInterNet := Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd

Set Dele On

lHistorico 	:= MsgYesNo("Deseja efetuar a atualiza玢o do dicion醨io? Esta rotina deve ser utilizada em modo exclusivo! Faca um backup dos dicion醨ios e da base de dados antes da atualiza玢o para eventuais falhas de atualiza玢o!", "Aten玢o")

If lHistorico
	Processa({|lEnd| GEProc(@lEnd)},"Processando","Aguarde, preparando os arquivos",.F.)
	Final("Atualiza玢o efetuada!")
endif
	
Return

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噮o    矴EProc    ? Autor ? Otacilio A. Junior   ? Data ? 08/Fev/08 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噮o ? Funcao de processamento da gravacao dos arquivos           潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Atualizacao GE                                             潮?
北滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?*/
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
IncProc("Verificando integridade dos dicion醨ios....")
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
			RPCSetType(3)	// N鉶 consome licensa de uso
			RpcSetEnv (SM0->M0_CODIGO, SM0->M0_CODFIL,,,"GE",,)
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
			
			ProcRegua(3)

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			//矨tualiza o dicionario de dados.?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			IncProc("Analisando Dicion醨io de Dados...")
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
					Aviso("Aten玢o!","Ocorreu um erro desconhecido durante a atualiza玢o da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicion醨io e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualiza玢o da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
			Next nX

			//Utiliza o Select Area para forcar a criacao das tabelas
			dbSelectArea("JA1")
			dbSelectArea("JA2")
			dbSelectArea("JBJ")
			dbSelectArea("JC1")
			dbSelectArea("JCR")
			dbSelectArea("JHP")
		   		
		Next nI 
		If lOpen
			cTexto := "Log da atualiza玢o "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualiza玢o conclu韉a." From 3,0 to 340,417 PIXEL
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噮o    ?  AtuSX3  ? Autor ? Otacilio A. Junior   ? Data ? 08/02/08  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噮o ? Funcao de processamento da gravacao do SX3 - Campos        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Atualizacao GE                                             潮?
北滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
if SX3->( dbSeek("JA1_RG") ) .AND. !SX3->X3_TAMANHO == 15
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 15
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JA1' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JA1")
endif

if SX3->( dbSeek("JA2_RG") ) .AND. !SX3->X3_TAMANHO == 15
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 15
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JA2' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JA2")
endif

if SX3->( dbSeek("JBJ_RG") ) .AND. !SX3->X3_TAMANHO == 15
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 15
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JBJ' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JBJ")
endif

if SX3->( dbSeek("JC1_RG") ) .AND. !SX3->X3_TAMANHO == 15
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 15
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JC1' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JC1")
endif

if SX3->( dbSeek("JCR_RG") ) .AND. !SX3->X3_TAMANHO == 15
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 15
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JCR' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JCR")
endif

if SX3->( dbSeek("JHH_CODEXT") ) .AND. !SX3->X3_TAMANHO == 15
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 15
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JHH' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JHH")
endif

if SX3->( dbSeek("JHP_RG") ) .AND. !SX3->X3_TAMANHO == 15
	RecLock("SX3",.F.)
	SX3->X3_TAMANHO := 15
	SX3->( msUnlock() )
	cTexto += 'Alterada a estrutura da tabela : JHP' + CHR(13)+CHR(10)
	AADD(aArqUpd,"JHP")
endif

Return cTexto         

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矼yOpenSM0Ex? Autor ? Otacilio A. Junior   ? Data ?08/02/2008潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Efetua a abertura do SM0 exclusivo                         潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Atualizacao GE                                             潮?         
北滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
	Aviso( "Aten玢o !", "N鉶 foi poss韛el a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen )
