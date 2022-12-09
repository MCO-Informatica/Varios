#INCLUDE "FIVEWIN.CH"

#DEFINE _ENTER CHR(13)+CHR(10)
/*                                                          
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA                                 ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data         |BOPS:		      ���
�������������������������������������������������������������������������Ĵ��
���      01  �Robson Bueno da Dilva     �25/05/2017    |00000098907       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CARM690  � Autor � Robson Bueno          � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carga M�quina                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = Informa que sera executado em batch. Default = .F. ���
���          � ExpL2 = Informa se as datas do SC2 serao atualizadas pelo  ���
���          �         Carga Maquina.Default = .T.                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static lIsBatch   := .f.    //Inicializacao da variavel static indicando que o processamento nao eh batch
Static __nSetupAt := 0		//Inicializacao da variavel static indicando o valor do setup atual
Static bBlock
User Function CARM690(lBat,lAtuSC2)
Local i,k
Local nKey
Local nHdl
Local nTentativas	:= 0
Local cArqFerram
Local cCargaFile
Local cArqSH8
Local cBuffer
Local cKeyFerram
Local cKeySH8
Local cSalvaCab
Local cSalvaAviso
Local mv_par06Old
Local dDataOld
Local dDataIni
Local dDataFim
Local lOk			:= .T.
Local lFalse		:= .F.
Local lTrue			:= .T.
Local lContinua		:= .F.
Local aCampSH8
Local aCampSHE
Local aRet 			:= Array(9)
Local aRecursos 	:= {}
Local aTamSX3		:= {}
Local nTamSX1       := Len(SX1->X1_GRUPO)
Local cTexto        := ""
Local bProcess      := {|oCenterPanel|U_C690Aloc(@aRet,@aRecursos,@lOk,,oCenterPanel)}
Local aInfoProc     := {}
Local lUsaNewPrc := If(FindFunction('UsaNewPrc'),UsaNewPrc(),.F.)
Local cEmp690     	:= Alltrim(STR(U_C690FNum(FwCodFil())))

PRIVATE cSeqCarga :=GetMV("MV_SEQCARG",,Space(6))
PRIVATE l690AtuSC2:= .T.
//��������������������������������������������������������������Ŀ
//� Define qual a precisao utilizada pelo SIGAPCP                �
//����������������������������������������������������������������
PRIVATE nPrecisao := GETMV("MV_PRECISA")

//��������������������������������������������������������������Ŀ
//� Define variavel para selecao de recursos                     �
//����������������������������������������������������������������
PRIVATE cRecSele  := ""

PRIVATE lReprocessa := .F.  // Flag para ReAlocar Carga Maquina
PRIVATE lAlterou    := .F.  // Flag para informar se alterou alguma prioridade

PRIVATE aOcorrencia := {}

PRIVATE aRecDepend  := {}  // Array que ira controlar operacoes com recursos dependentes (G2_TPLINHA="D")

PRIVATE cDirPcp                                      
PRIVATE cNameCarga	:= "CARGA"+If(Empty(cEmp690),cNumEmp,cEmp690)//Nome do arquivo de Carga
PRIVATE cNameFerr	:= "FERR" +If(Empty(cEmp690),cNumEmp,cEmp690)//Nome do arquivo de Ferramenta

//��������������������������������������������������������������Ŀ
//� Estas variaveis indicam para as funcoes de validacao qual    �
//� programa as esta chamando                                    �
//����������������������������������������������������������������
PRIVATE l240:=.F.,l250 :=.F.,l241:=.F.,l242:=.F.,l261:=.F.,l185:=.F.,l650:=.F.

DEFAULT lBat	:= .f.
DEFAULT lAtuSC2	:= .t.

lIsBatch 	:= ( lBat .or. IsBlind())
l690AtuSC2	:= lAtuSC2
AjustaSX1()
//��������������������������������������������������������������Ŀ
//� Verifica a permissao do programa em relacao aos modulos      �
//����������������������������������������������������������������
If AMIIn(10)
	PRIVATE cTipoTemp	:=GetMV("MV_TPHR")

	//��������������������������������������������������������������Ŀ
	//� Flag que indica se rodou alocacao ou nao                     �
	//����������������������������������������������������������������
	PRIVATE lAlocou:=.F.

	If ! ChkPcp()
		Return
	Endif	

	//��������������������������������������������������������������Ŀ
	//� Diretorio do processamento                                   �
	//����������������������������������������������������������������
	If GetMV("MV_PROCPCP",.T.)
		cDirPcp := Alltrim(GetMV("MV_PROCPCP"))
		If U_C690NmL(cDirPcp)
			help(" ", 1, "C690NLONGO",,"MV_PROCPCP " + cDirPCP,4,0)
			Return
		Endif
	Else
		cDirPcp := Alltrim(GetMV("MV_DIRPCP"))
		If U_C690NmL(cDirPcp)		
			help(" ", 1, "C690NLONGO",,"MV_DIRPCP " + cDirPCP,4,0)
			Return
		Endif
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Diretorio dos dados                                          �
	//����������������������������������������������������������������
	PRIVATE cDirDados	:= Alltrim(GetMV("MV_DIRPCP"))

	If U_C690NmL(cDirDados)		
		help(" ", 1, "C690NLONGO",,"MV_DIRPCP " + cDirDados,4,0)
		Return
	Endif

	// Preenche a pergunta MTC69015 com a variavel dDataBase
	dbSelectArea("SX1")
	dbSeek("MTC69015")
	If Found()
		RecLock("SX1",.F.)
		Replace X1_CNT01 With DTOC(dDataBase)
		MsUnLock()
	EndIf

	cDrvCarga := __LocalDriver

	//����������������������������������������������������������������������������������������������������Ŀ
	//� Parametros utilizados                                                                              �
	//� mv_par01 - 1 - Alocacao pelo Fim   2 - Pelo inicio                                                 �
	//� mv_par02 - Periodo  10 a 999 dias                                                                  �
	//� mv_par03 - 1 - Utiliza Ferramenta  2 - Nao Utiliza                                                 �
	//� mv_par04 - 1 - Considera Saldo OP  2 - Considera Saldo da Operacao                                 �
	//� mv_par05 - 1 - Considera OPs Sacramentadas  2 - Nao considera                                      �
	//� mv_par06 - 1 - Uma cor para cada OP  2 - OPs Sacr. em Verm. e Normais em Azul                      �
	//� mv_par07/08 - Data de Entrega de/ate                                                               �
	//� mv_par09/10 - Ordens de Producao de/ate                                                            �
	//� mv_par11/12 - Produto de/ate                                                                       �
	//� mv_par13/14 - Grupo de/ate                                                                         �
	//� mv_par15    - Data Inicial                                                                         �
	//� mv_par16/17 - Tipo produto de/ate                                                                  �
	//� mv_par18    - Avalia Ocorrencia : Durante/Final                                                    �
	//� mv_par19    - Filtra recursos 1 - Sim 2 - Nao                                                      �
	//� mv_par20    - Seleciona Cal. Alternativo 1 - Sim 2 - Nao                                           �
	//� mv_par21    - Aloca OPS 1 - Firmes 2 - Previstas 3 - Ambas                                         �
	//� mv_par22    - Mostra Carga Maquina apos processamento 1-Sim; 2-Nao                                 �
	//� mv_par23    - Saida do Grafico 1-Protheus;2-Escolher;3-MS-Project se existir;4-Protheus sem quebra �
	//� mv_par24    - Mostra recurso sem alocacao  1-Sim; 2=Nao                                            �
	//� mv_par25/26 - Linha de Producao de/ate                                                             �
	//� mv_par27    - Desalocar OP parcialmente alocada 1 - Sim 2 - Nao (Somente para alocacao pelo FIM)   �
	//� mv_par28    - Ignorar operac. seguintes         1 - Sim 2 - Nao (Somente para alocacao pelo INICIO)�
	//� mv_par29    - Ao termino do processamento       1 - Retorna ao menu 2 - Retorna aos parametros     �
	//������������������������������������������������������������������������������������������������������
	U_C690Qst(.F.)

	Private dDataPar  := mv_par15   // Data utilizada para inicio da Carga de Maquina
	Private lMaqXQuant:= .F.        // Verifica se utiliza Maquina de acordo com as quantidades
	Private nIntQtd   :=  9         // Utilizado quando lMaqXQuant == .T. (IBRATIN)
	Private nDecQtd   :=  2         // Utilizado quando lMaqXQuant == .T. (IBRATIN)

	IF GETMV("MV_MAQXQTD",.T.)
		lMaqXQuant := .T.       // Especifico para IBRATIN
		aTamSX3 := TamSX3("Z1_QUANT")
		nIntQtd := aTamSX3[1]
		nDecQtd := aTamSX3[2]
	Endif

	// Preenche a pergunta MTA69101 com a pergunta MTC69006
	dbSelectArea("SX1")
	dbSeek("MTA69101")
	If Found()
		RecLock("SX1",.F.)
		Replace X1_PRESEL With mv_par06
		MsUnLock()
	EndIf

	Private lShowOCR := .F., lOcorreu := .F., cSavScrOCR, dDataBrowse := dDataPar
	Private oRegua
	Private nRegua:=0
	Private nTotRegua:=0
	If !U_C690IsBt()
		If (GetRPORelease() >= "R1.1" .And. lUsaNewPrc)
		  bBlock:={|| oCenterPanel:IncRegua1() }
		Else
		  bBlock:={|| oRegua:Set(++nRegua),SysRefresh()}
		EndIf
	EndIf

	//������������������������������������������������������������������������Ŀ
	//� Verifica se esta em modo exclusivo para a filial                       �
	//��������������������������������������������������������������������������
	If !(lContinua := OpenSemSH8() )
		Help(" ",1,"SH8EmUso")
	Else
		If Empty(cDirPcp)
			dbSelectArea("SX2")
			dbSeek("SH8")
			If Found()
				cDirPcp := Alltrim(SX2->X2_PATH)
				GetMV("MV_PROCPCP")
				PutMV("MV_PROCPCP",cDirPcp)
			EndIf
		Else
			cDirPcp += IIf( Right(cDirPcp,1) # "\" , "\" , "" )
		EndIf
		If Empty(cDirDados)
			dbSelectArea("SX2")
			dbSeek("SH8")
			If Found()
				cDirDados := Alltrim(SX2->X2_PATH)
				GetMV("MV_DIRPCP")
				PutMV("MV_DIRPCP",cDirDados)
			EndIf
		Else
			cDirDados += IIf( Right(cDirDados,1) # "\" , "\" , "" )
		EndIf
		lOk:=A690DirProc()
		If lOk
			If !lBat
				If IsBlind()
					BatchProcess("Carga Maquina v.02","Efetuando processamento...","MTC690",{ ||U_C690Aloc(@aRet,@aRecursos,@lOk)}) 					 //"Carga Maquina"###"Efetuando processamento..."
				Else
					If (0=1 .And. lUsaNewPrc)
						cTexto := OemToAnsi("Este programa aloca todos os recursos utilizados nas Ordens de Produ��o e no per�odo") +_ENTER        //"Este programa aloca todos os recursos utilizados nas Ordens de Produ��o e no per�odo"
						cTexto += OemToAnsi("definidos atrav�s dos par�metros. Ap�s a execu��o da rotina o usu�rio poder�") +_ENTER        //"definidos atrav�s dos par�metros. Ap�s a execu��o da rotina o usu�rio poder�"
						cTexto += OemToAnsi("rodar o relat�rio de Carga M�quina e conferir a aloca��o.")                //"rodar o relat�rio de Carga M�quina e conferir a aloca��o."
						//��������������������������������������������������������Ŀ
						//� AInfoProc                                              |
						//� AInfoProc[1] - Titulo                                  |
						//� AInfoProc[2] - Bloco de Codigo a ser Executado         |
						//� AInfoProc[3] - Resource (BitMap)                       |
						//� AInfoProc[4,1] - Array contendo Cabecalho              |
						//� AInfoProc[4,2] - Array contendo os Itens               |
						//����������������������������������������������������������
						Aadd(aInfoProc,{"Visualizar",{|oCenterPanel| U_C690Mtr(oCenterPanel) },"WATCH"})
						Aadd(aInfoProc,{"Relatorio" ,{|oCenterPane| U_C690Rprt(oCenterPanel) },"RELATORIO"})
						//�����������������������������������������������������������������������������������������������Ŀ
						//� Sintaxe da tNewProcess():New( cFunction, cTitle, bProcess, cDescription, cPerg, aInfoCustom ) |
						//�������������������������������������������������������������������������������������������������
						oTProces := tNewProcess():New( "CARMC690",OemToAnsi("Acerto do Invent�rio"),bProcess,cTexto,"MTC690",aInfoProc,,,,,.T.) 	//
					Else
						aButton := Array(6)
						DEFINE MSDIALOG oDlg FROM  100,100 TO 300,665 TITLE OemToAnsi("Carga de M�quina v.02") PIXEL	//"Carga de M�quina"
						@ 10,015 TO 58,266 LABEL "" OF oDlg  PIXEL
						@ 21,025 SAY OemToAnsi("Este programa aloca todos os recursos utilizados nas Ordens de Produ��o e no per�odo") SIZE 215,8 OF oDlg PIXEL	//"Este programa aloca todos os recursos utilizados nas Ordens de Produ��o e no per�odo"
						@ 31,025 SAY OemToAnsi("definidos atrav�s dos par�metros. Ap�s a execu��o da rotina o usu�rio poder�") SIZE 215,8 OF oDlg PIXEL	//"definidos atrav�s dos par�metros. Ap�s a execu��o da rotina o usu�rio poder�"
						@ 41,025 SAY OemToAnsi("rodar o relat�rio de Carga M�quina e conferir a aloca��o.") SIZE 215,8 OF oDlg PIXEL	//"rodar o relat�rio de Carga M�quina e conferir a aloca��o."
						@ 65,015 METER oRegua VAR nRegua TOTAL nTotRegua SIZE 251,8 OF oDlg NOPERCENTAGE PIXEL

						@ 82,020 BUTTON aButton[1] Prompt OemToAnsi("&Ocorr�ncias") ACTION u_C690ShOc() SIZE 44,11 OF oDlg PIXEL	//"&Ocorr�ncias"

						DEFINE SBUTTON aButton[2] FROM 82,100 TYPE  1 ACTION (U_C690Btn(.F.), U_C690Aloc(@aRet,@aRecursos,@lOk)	, U_C690Btn(.T.),If(mv_par29==1,oDlg:End(),)) ENABLE OF oDlg PIXEL
						DEFINE SBUTTON aButton[3] FROM 82,135 TYPE  5 ACTION (U_C690Btn(.F.), U_C690Qst(.T.), u_C690Btn(.T.)) ENABLE OF oDlg PIXEL
						DEFINE SBUTTON aButton[4] FROM 82,170 TYPE 15 ACTION (U_C690Btn(.F.), u_C690Vis(), If(lReprocessa, U_C690Aloc(@aRet,@aRecursos,@lOk),), U_C690Btn(.T.)) ENABLE OF oDlg PIXEL
						DEFINE SBUTTON aButton[5] FROM 82,205 TYPE  6 ACTION (U_C690Btn(.F.), u_C690Relt(), u_C690Btn(.T.)) ENABLE OF oDlg PIXEL
						DEFINE SBUTTON aButton[6] FROM 82,240 TYPE  2 ACTION (oDlg:End()) ENABLE OF oDlg PIXEL

						ACTIVATE MSDIALOG oDlg CENTERED
					EndIf
				EndIf
			Else
				A690Aloc(@aRet,@aRecursos,@lOk)
			EndIf
		EndIf
	EndIf
	If Select("FER") > 0
		dbSelectArea("FER")
		dbCloseArea()
	EndIf

	If Select("CARGA") > 0
		dbSelectArea("CARGA")
		dbCloseArea()
	EndIf


    If lContinua
		ClosSemSH8()
	EndIf                                    
	
	//������������������������������������������������������������������������Ŀ
	//� Copia arquivos de processamento para diretorio dos dados               �
	//��������������������������������������������������������������������������
	If cDirPCP != cDirDados .And. lOk
		A690CopyFile()
	EndIf
	dbSelectArea("SC2")
EndIf
//Atencao: este return nunca podera ser informado com Nil, para nao
//gerar problemas com o scheduler(nao finalizando a conexao)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690Btn    � Autor � Robson Bueno         � Data �29/08/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ativa/Desativa botoes enquanto processa                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lAction : True->Ativa / False->Desativa                    ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP       � Carga Maquina                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690Btn(lAction)
aEval(aButton, If(lAction, {|_1| _1:Enable()}, {|_1| _1:Disable()}))
dDataBrowse := If(Type("dDataPar") = "D", dDataPar, dDataBase)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C690Sup2  � Autor � Robson Bueno Silva   � Data � 10/12/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o Mesmo Produto Em Questao p/ Lancar ou Nao    ���
���          � Tempo de SetUp.                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690SUp2( cOp,cProduto )
Local cAlias  := Alias(),;
	nRecord := 0,;
	nOrder  := 0

If (SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD == xFilial( "SC2" )+cOP)
	lBack := !(SC2->C2_PRODUTO == cProduto)
Else
	dbSelectArea( "SC2" )
	nRecord := Recno()
	nOrder  := IndexOrd()
	dbSetOrder(1)
	If DbSeek( xFilial( "SC2" )+cOp,.F. )
		lBack := !(SC2->C2_PRODUTO == cProduto)
	Else
		lBack := .T.
	EndIf
	dbSetOrder(nOrder)
	dbGoTo(nRecord)
	dbSelectArea(cAlias)
EndIf
Return(lBack)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690Sdv     Autor � Robson Bueno Silva    � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que divide as alocacoes de acordo com a disponibili-���
���          � dade do calendario.                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690Sdv(cCal,nAtual,nDuracao,nStrLen,cCalCop)
Local aBack  := {}
Local nMinSz   := 0,;
	nBitUsed := 0,;
	nBitAloc := 0,;
	nBitRslt := 0
Local lLoop    := .T.,;
	lDoing   := .F.
Local nBackAtual:=nAtual
Local lMudaSoma:=.F.

If (nDuracao > 0) .And. ;
		((nMinSz := C690ChA( cCalCop,nDuracao,nAtual,0,(nStrLen*8) )) > 0)
	While lLoop .And. (nMinSz > 0)
		nPosINI  := If((MV_PAR01 == 1),((nAtual-nMinSz)+1),nAtual)
		//�������������������������������������������������������������
		//�Ajusta Bit Inicial para alocacao pelo Fim em uma Alocacao  �
		//�pelo Inicio (Situacao que ocorre quando h� sobreposicao em �
		//�uma alocacao e a operacao a ser alocada nao ultrapassa a   �
		//�operacao anterior, nao atinge o nBitLimit).                �
		//�������������������������������������������������������������
		If lMudaPraFim .And. (MV_PAR01 == 1 )
			nPosINI -= If((nPosINI-1) > nMinSz,1,0)	
		EndIf
		nBitUsed := Look4Bit( cCal,nPosINI,nMinSz,nStrLen )
		If ((nMinSz-nBitUsed) == nDuracao)
			lLoop  := .F.
			lDoing := .T.
		Else
			If lMudaPraFim .And. nPosIni+nDuracao <= nBackAtual
				lMudaSoma:=.T.
			EndIf
			nAtual += If((MV_PAR01 == 1 .And. !lMudaSoma),(-1),1)
			nMinSz := C690ChA( cCalCop,nDuracao,nAtual,nMinSz,(nStrLen*8) )
		EndIf
	EndDo
	If lDoing
		nPosINI  := If((MV_PAR01 == 1),((nAtual-nMinSz)+1),nAtual)
		//�������������������������������������������������������������
		//�Ajusta Bit Inicial para alocacao pelo Fim em uma Alocacao  �
		//�pelo Inicio (Situacao que ocorre quando h� sobreposicao em �
		//�uma alocacao e a operacao a ser alocada nao ultrapassa a   �
		//�operacao anterior, nao atinge o nBitLimit).                �
		//�������������������������������������������������������������
		If lMudaPraFim .And. (MV_PAR01 == 1 )
			nPosINI -= If((nPosINI-1) > nMinSz,1,0)	
		EndIf
		nPosATU  := nPosINI
		nBitUsed := 0
		While (nMinSz > 0) .And. lDoing
			nBitRslt := u_Bit2On( cCal,nPosATU,1,nStrLen )
			Do Case
			Case (nBitRslt == 1)
				If (nPosINI == 0)
					nPosINI := nPosATU
				EndIf
				nBitUsed++
				nBitAloc++
			Case (nBitRslt == 0)
				If (nPosINI >= 1) .And. (nBitUsed >= 1)
					aAdd( aBack,{ nPosINI,nBitUsed } )
				Endif
				nPosINI  := 0
				nBitUsed := 0
			OtherWise
				aBack  := {}
				lDoing := .F.
			EndCase
			nMinSz--
			nPosATU++
		EndDo
		If (nPosINI >= 1)
			aAdd( aBack,{ nPosINI,nBitUsed } )
		Endif
		If !(nBitAloc == nDuracao)
			aBack := {}
		EndIf
	EndIf
EndIf
Return(C690SRt(aBack))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690SRt   � Autor � Robson Bueno Silva    � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta o Retorno do Array aSubDiv, Conforme Selecao de     ���
���          � Carga Pelo Inicio Ou Fim                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C690SRt( aBack )
If (MV_PAR01 == 1)
	ASort( aBack,,,{ | aX,aY | aX[1] > aY[1] })
EndIf
Return(aBack)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690ChA   � Autor � Robson Bueno Silva    � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica o Espaco Minimo p/ a Alocacao de uma operacao e   ���
���          � impede alocacoes fragmentadas                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C690ChA(cCalCop,nSize,nInicio,nValue,nLen,lOk)
Local nPosINI  := 0,;
	nAvail   := 0,;
	nMinSz   := If((nValue == 0),nSize,nValue),;
	lError   := .F.,;
	lTesting := .T.

If (nSize > 0)
	nPosINI := If((MV_PAR01 == 1),((nInicio-nMinSz)+1),nInicio)
	lError  := If((MV_PAR01 == 1),!(nPosINI >= 1 .And. nPosIni < nLen),!((nPosINI+nMinSz) <= nLen))
	While lTesting .And. !lError
		nAvail := (nMinSz-Look4Bit( cCalCop,nPosINI,nMinSz,(nLen/8) ))
		Do Case
		Case (nAvail == nSize)
			lTesting := .F.
		Case (nAvail >  nSize)
			nMinSz--
		OtherWise
			nMinSz++
		EndCase
		nPosINI := If((MV_PAR01 == 1),((nInicio-nMinSz)+1),nInicio)
		lError  := If((MV_PAR01 == 1),!(nPosINI >= 1 .And. nPosIni < nLen),!((nPosINI+nMinSz) <= nLen))
	EndDo
EndIf
Return(If(lError,0,nMinSz))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690FDs     � Autor � Ricardo Dutra       � Data � 02/09/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o registro e bit da ferramenta disponivel p/ aloc. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1=C690FDs(ExpC1,ExpN2,ExpN3,ExpN4)                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Retorno:                                           ���
���          �      ExpA1[1] = numero do registro disponivel, 0 nao disp. ���
���          �      ExpA1[2] = primeiro bit disponivel                    ���
���          � ExpC1 = Codigo da ferramenta a ser pesquisada              ���
���			 � ExpN1 = Inicio do periodo a ser pesquisado	              ���
���			 � ExpN2 = Numero de unidades de alocacao (15 min) a pesquisar���
���			 � ExpN3 = Modo de Alocacao (1 - inicio , 0 - fim)            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690FDs(cFerr,nIni,nUnid,cUltFerr,aRet,cCalcOP)
LOCAL cBuffer			// buffer para leitura de arquivo binario
LOCAL i					// contador auxiliar
LOCAL k					// contador auxiliar
LOCAL lOk				// inresultado do teste do registro em relacao ao periodo de alocacao
LOCAL aRegs := {}		// array com o primeiro e ultimo registros da ferramenta
LOCAL nBitAtu			// bit atual de alocacao
LOCAL nBitDisp			// primeiro bit disponivel para alocacao
LOCAl nReg				// registro escolhido para alocacao
LOCAL aRetorno := {}	// array de retorno
LOCAL aRetDisp := {}
Local nUltFerr, nFirst := 0, aFerSubDiv
Local nH4Recno := SH4->(RecNo())

If ! SH4->(dbSeek(xFilial("SH4") + cFerr)) .Or. SH4->H4_QUANT == 0
	SH4->(dbGoto(nH4Recno))
	Return({0, 0})
Endif
SH4->(dbGoto(nH4Recno))

aRetorno := Array(2)

//��������������������������������������������������������Ŀ
//� Obtem o primeiro e ultimo registro da ferramenta       �
//����������������������������������������������������������
aRegs := U_C690FRg(cFerr,aRet)

//��������������������������������������������������������Ŀ
//� VerIfica a disponibilidade da ferramenta para o periodo�
//����������������������������������������������������������
lOk := .F.
cBuffer := Space(aRet[4])         // com o tamanho do periodo total
nBitAtu := If(mv_par01 = 1 , 0 , aRet[4]*8)      // bit final do periodo
nReg     := 0 	// indica estouro do calendario

// Alterado para que a ferramenta utilizada seja a mesma utilizada na ultima
// operacao (se aquela estiver entre as melhores opcoes).
nUltFerr := Val(Substr(cUltFerr,7,6))
If cFerr == Substr(cUltFerr,1,6) .And. ( nUltFerr >= aRegs[1] .Or. nUltFerr <= aRegs[2] )
	nFirst := nUltFerr
EndIf

For i:= aRegs[1] TO aRegs[2]		// para cada registro da ferramenta

	If nFirst # 0
		If i == aRegs[1]
			k := nFirst
		ElseIf i == nFirst
			k := aRegs[1]
		Else
			k := i
		EndIf
	Else
		k := i
	EndIf

	//��������������������������������������������������������Ŀ
	//� Le o registro atual da ferramenta                      �
	//����������������������������������������������������������
	FSeek(aRet[6],(k - 1) * aRet[4],0)	// o arquivo e contado a partir de zero
	If FRead(aRet[6],@cBuffer,aRet[4]) # aRet[4] .And. !lShowOCR .And. aRet[8] > 0
		cBuffer := Pad(cBuffer, aRet[4])
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
	EndIf

	//���������������������������������������������������������Ŀ
	//� Se estiver disponivel, sai, senao procura o proximo bit �
	//�����������������������������������������������������������
	If u_Bit2On(cBuffer,nIni,nUnid,aRet[4]) == 1
		lOk     := .T.
		nReg    := k
		nBitAtu := nIni
		Exit
	Else
		//���������������������������������������������������������Ŀ
		//� Se nao estiver disponivel no periodo desejado, procura o�
		//� proximo bit disponivel                                  �
		//�����������������������������������������������������������
		If mv_par01 == 1
			nBitDisp := u_NextBtFr(cBuffer,nIni+nUnid-1,aRet)
		Else
			//nBitDisp := u_NextBtFr(cBuffer,nIni,aRet)
			aRetDisp := U_C690Sdv(cBuffer,nIni,nUnid,aRet[4],cCalcOP)
			If Empty(aRetDisp)
				nBitDisp := -1
			Else
				nBitDisp := aRetDisp[1,1]
				If TRB->TPALOCF=="2" .AND. !Empty(TRB->SETUP) .AND. u_Bit2On(cBuffer,nBitDisp,nUnid-U_C690T2B(TRB->SETUP),aRet[4]) == 1								
					nBitDisp -= U_C690SupG()
				EndIf
			EndIf
		EndIf
		//�������������������������������������������������������������������Ŀ
		//� Avalia se a ferramenta esta totalmente disponivel, se nao estiver �
		//� busca proximo espaco vazio, hoje o programa ainda nao sub-divide  �
		//� a operacao de acordo com a disponibilidade da ferramenta.         �
		//���������������������������������������������������������������������
		/*
		aFerSubDiv := u_C690Sdv(cBuffer, nBitDisp, nUnid, aRet[4],cCalcOP)
		If Empty(aFerSubDiv)
			nBitDisp := -1
		ElseIf aFerSubDiv[1][2] < nUnid
			nBitDisp := -1
			While .T.
				nBitDisp := aFerSubDiv[Len(aFerSubDiv)][1]+aFerSubDiv[Len(aFerSubDiv)][2]-1
				aFerSubDiv := U_C690Sdv(cBuffer, nBitDisp, nUnid, aRet[4],cCalcOP)
				If Empty(aFerSubDiv)
					nBitDisp := -1
					Exit
				EndIf
				If aFerSubDiv[1][2] == nUnid
					Exit
				EndIf
			End
		EndIf
        */
		If nBitDisp # -1
			//���������������������������������������������������������Ŀ
			//� VerIfica se o primeiro bit disponivel e'melhor que o bit�
			//� atualmente escolhido de acordo com o modo de alocacao   �
			//�����������������������������������������������������������
			If mv_par01 = 1
				If nBitDisp > nBitAtu
					nBitAtu := nBitDisp
					nReg    := k
				Endif
			Else
				If nBitDisp < nBitAtu
					nBitAtu := nBitDisp
					nReg    := k
				Endif
			Endif
		Endif
	Endif
Next

//�����������������������������������������������������������������Ŀ
//� Compoe o array de retorno: {registro escolhido,bit disponivel}  �
//�������������������������������������������������������������������
aRetorno[1] := nReg
aRetorno[2] := nBitAtu
Return aRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690FRg     � Autor � Ricardo Dutra       � Data � 13/09/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna array com o 1o. e ultimo registro da ferramenta    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1=C690FRg(ExpC1)                                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = ExpA1[1] - primeiro registro                       ���
���          �         ExpA1[2] - ultimo registro                         ���
���			 � ExpC1 = Ferramenta                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690FRg(cFerram,aRet)
LOCAL cBuffer 		// string para leitura do arquivo de indice
LOCAL nPosicao		// posicao da ferramenta no arquivo de indice
LOCAL nPI			// posicao do 1o. byte com o valor da posicao do registro da ferr. desejada
LOCAL aRegFerr 		// array de retorno

aRegFerr := Array(2)

//��������������������������������������������������������Ŀ
//� Le o aruivo de indice de ferramentas                   �
//����������������������������������������������������������
cBuffer := Space(aRet[8] * 11)
FSeek(aRet[7],0,0)
If FRead(aRet[7],@cBuffer,aRet[8] * 11) # ( aRet[8] * 11 ) .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf

//��������������������������������������������������������Ŀ
//� Localiza o primeiro registro da ferramenta             �
//����������������������������������������������������������
nPosicao:= At(cFerram,cBuffer)
nPI := aRet[8] * 7 + 1
nPI := nPI + ( ( ( nPosicao - 1 ) / 7 ) * 4 )
aRegFerr[1] := Bin2I(Substr(cBuffer,nPI,2))
aRegFerr[2] := Bin2I(Substr(cBuffer,nPI+2,2))

Return aRegFerr

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690Flc     � Autor � Ricardo Dutra       � Data � 02/09/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Aloca/Desaloca a ferramenta no periodo desejado            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � C690Flc(ExpC1,ExpN1,ExpN2,ExpN3,ExpL1)                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo da ferramenta a ser alocada/desalocado      ���
���			 � ExpN1 = Inicio do periodo a ser alocado/desalocado 		  ���
���			 � ExpN2 = Fim do periodo a ser alocado/desalocado            ���
���			 � ExpN3 = Registro do arquivo de ferramenta a ser alocado    ���
���			 � ExpL1 = Define o modo de atualizacao: .T. - aloca          ���
���			 �                                    	  .F. - desaloca      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C690Flc(cFerram,nIni,nUnid,nReg,lAloc,aRet)

LOCAL nByteIni						// byte inicial do registro a atualizar
LOCAL cBuffer						// buffer para leitura do arquivo binario

cBuffer := Space(aRet[4])			// numero de bytes necessarios para periodo

//��������������������������������������������������������Ŀ
//� Calcula o byte inicial do registro para alocacao       �
//����������������������������������������������������������
nByteIni := (nReg-1) * aRet[4]

//��������������������������������������������������������Ŀ
//� Posiciona a arquivo para ler o registro disponivel     �
//����������������������������������������������������������
FSeek(aRet[6],nByteIni,0)			// posiciona o arquivo para ler
If FRead(aRet[6],@cBuffer,aRet[4]) # aRet[4] .And. !lShowOCR		// le o registro de alocacao de ferramenta
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf

//��������������������������������������������������������Ŀ
//� Se for alocar,set os bits correspondentes,senao reseta �
//����������������������������������������������������������
If lAloc
	StuffBit(@cBuffer,nIni,nUnid,aRet[4])		// aloca os bits corespondentes
Else
	UnStuff2(@cBuffer,nIni,nUnid,aRet[4])		// desaloca os bits correspondentes
Endif

//��������������������������������������������������������Ŀ
//� Grava os bits atualizados no arquivo de ferramenta     �
//����������������������������������������������������������
FSeek(aRet[6],nByteIni,0)			// posiciona o arquivo para gravar
If FWrite(aRet[6],cBuffer,aRet[4]) < aRet[4] .And. !lShowOCR
	Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690ShOc   � Autor � Ary Medeiros         � Data �          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Revis�o  � Waldemiro L. Lustosa                     � Data � 13/09/95 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690ShOc()
Local cFile, cString
Local cAlias := Alias()
Local i,aOcorr:={}
Local oDlg,oOcorr
Local lExibeOcor := .T.
Local nHdl

cFile := cDirPcp+cNameCarga+".OCR"
nHdl  := fOpen(cFile,2+64)

If ExistBlock("u_C690OCOR")
	lExibeOcor := ExecBlock("u_C690OCOR", .F., .F., cFile)
	If ValType(lExibeOcor) == "L" .And. ! lExibeOcor
		Return Nil
	Endif
Endif		

If !File(cFile)
	cString := OemToAnsi("Nenhuma ocorr�ncia encontrada ...")	//"Nenhuma ocorr�ncia encontrada ..."
	AADD(aOcorr,cString+Space(63-Len(cString)))
Else
	cString := MemoRead(cFile)
	nNumLinhas := MlCount(cString)
	// Monta array para ListBox
	For i:=1 to nNumLinhas
		AADD(aOcorr,OemToAnsi(MemoLine(cString,63,i)))
	Next i
EndIf
If Len(aOcorr) > 0
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Ocorr�ncias") From 8,05 To 20,65 OF oMainWnd	//"Ocorr�ncias"
	@ 1,001 LISTBOX oOcorr Fields HEADER Space(63) SIZE 190,70
	oOcorr:SetArray(aOcorr)
	oOcorr:bLine := { || {aOcorr[oOcorr:nAT]} }
	DEFINE SBUTTON FROM 18,202 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
	DEFINE SBUTTON FROM 31,202 TYPE 6 ACTION (A690ImpOcorr(aOcorr),oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
EndIf
fClose(nHdl)
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690ASH8    � Autor � Robson Bueno Silv   � Data � 14/09/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de gravacao do SH8 - Operacoes Alocadas.            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � C690ASH8(EC1,EA1,EA2,EN1,EN2,EN3,EN4,EN5,EN6,EN7)          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = 01.Codigo do Recurso                               ���
���          � ExpA1 = 02.Array com a Data e Hora Inicial da Alocacao     ���
���          � ExpA2 = 03.Array com a Data e Hora Final da Alocacao       ���
���          � ExpN1 = 04.Bit Inicial da Alocacao                         ���
���          � ExpN2 = 05.Bit Final da Alocacao                           ���
���          � ExpN3 = 06.Qtde de Desdobramento                           ���
���          � ExpN4 = 07.Numeros dos Desdobramentos                      ���
���          � ExpN5 = 08.Bits Usados na Operacao                         ���
���          � ExpN6 = 09.Posicao em Arquivo Binario                      ���
���          � ExpN7 = 10.Quantidade a Produzir 						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690ASH8(cRecurso, aDtHrIni, aDtHrFim, nInicio, nFim, nNumDes, nSubDiv, nDurDesdob, nIndSubDiv,nQuant, nSetup,nTempEnd)
Local cAlias := Alias(), nIndexOrd := IndexOrd()
Local cABC   := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Local nRecTRB, cOpAnt, nRecSH8, nRecCARGA
Local lSeqCarg   := SH8->(FieldPos("H8_SEQCARG")) > 0
Local nPosDepend := 0
Local lMT690GSH8 := ExistBlock("MT690GSH8")      
Local cNCTRAB    := Nil
local nBitIniGuarda:=0
Static lSh8Setup   := Nil
Static lSh8TempEnd := Nil

Default nSetup  := 0
Default nTempEnd:= 0

If lSh8Setup == Nil
	lSh8Setup := (SH8->(FieldPos("H8_SETUP")) > 0) .And. (CARGA->(FieldPos("H8_SETUP")) > 0) .And. (SHD->(FieldPos("HD_SETUP")) > 0)
Endif	

If lSh8TempEnd == Nil
	lSh8TempEnd := (SH8->(FieldPos("H8_TEMPEND")) > 0) .And. (CARGA->(FieldPos("H8_TEMPEND")) > 0) .And. (SHD->(FieldPos("HD_TEMPEND")) > 0)
Endif	

nIndSubDiv := IIf( nIndSubDiv == NIL, 0, nIndSubDiv )

If (nPosDepend := aScan(aRecDepend, {|x| x[1] == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD})) == 0
	Aadd(aRecDepend, {TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD, cRecurso, U_C690RcLn(cRecurso), TRB->TPLINHA})
Else
	aRecDepend[nPosDepend, 4] := TRB->TPLINHA
Endif             

cNCTRAB := U_C690CrCT(cRecurso)
if Empty(cNCTRAB)
	cNCTRAB := TRB->CTRAB
EndIf

IF cRecurso="SF-02"
  nBitIniGuarda:=nInicio
ENDIF
////// incluir fun��o de acerto de bits com base nas regras de compras e produto
dbSelectArea("SH8")
dbAppend()
Replace H8_FILIAL 	With xFilial("SH8"),;
		H8_OP 		With TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,;
		H8_OPER 	With TRB->OPERAC,;
		H8_RECURSO 	With cRecurso,;
		H8_FERRAM 	With TRB->FERRAM,;
		H8_DTINI 	With aDtHrIni[1],;
		H8_HRINI 	With aDtHrIni[2],;
		H8_DTFIM 	With aDtHrFim[1],;
		H8_HRFIM 	With aDtHrFim[2],;
		H8_BITINI 	With nInicio,;
		H8_BITFIM 	With nFim,;
		H8_SEQPAI 	With TRB->SEQPAI,;
		H8_QUANT 	With nQuant,;
		H8_DESDOBR 	With IIf( nSubDiv == 0, StrZero(nNumDes,3), StrZero(nNumDes,3)+Substr(cABC,nSubDiv,1) ),;
		H8_BITUSO 	With nDurDesdob,;
		H8_SUBDIV 	With nIndSubDiv,;
		H8_CTRAB 	With cNCTRAB,;
		H8_ROTEIRO 	With TRB->CODIGO,;
		H8_SEQROTA 	With TRB->SEQROTA
If lSeqCarg
	Replace  H8_SEQCARG With cSeqCarga
EndIf

If lSh8Setup
	Replace H8_SETUP With nSetup
Endif

If lSh8TempEnd
	Replace H8_TEMPEND With nTempEnd
Endif    

cNCTRAB := U_C690CrCT(cRecurso)
if Empty(cNCTRAB)
	cNCTRAB := TRB->CTRAB
EndIf
dbSelectArea("CARGA")
dbAppend()
Replace H8_FILIAL 	With xFilial("SH8"),;
		H8_OP 		With TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,;
		H8_OPER 	With TRB->OPERAC,;
		H8_RECURSO 	With cRecurso,;
		H8_FERRAM 	With TRB->FERRAM,;
		H8_DTINI 	With aDtHrIni[1],;
		H8_HRINI 	With aDtHrIni[2],;
		H8_DTFIM 	With aDtHrFim[1],;
		H8_HRFIM 	With aDtHrFim[2],;
		H8_BITINI 	With nInicio,;
		H8_BITFIM 	With nFim,;
		H8_SEQPAI 	With TRB->SEQPAI,;
		H8_QUANT 	With TRB->QTDPROD,;
		H8_DESDOBR 	With IIf( nSubDiv == 0, StrZero(nNumDes,3), StrZero(nNumDes,3)+Substr(cABC,nSubDiv,1) ),;
		H8_BITUSO 	With nDurDesdob,;
		H8_SUBDIV 	With nIndSubDiv,;
		H8_CTRAB 	With cNCTRAB,;
		H8_ROTEIRO 	With TRB->CODIGO,;
		H8_SEQROTA 	With TRB->SEQROTA
If lSeqCarg
	Replace  H8_SEQCARG With cSeqCarga
EndIf

If lSh8Setup
	Replace H8_SETUP With nSetup
Endif	

If lSh8TempEnd
	Replace H8_TEMPEND With nTempEnd
Endif

dbSelectArea("TRB")
Replace OPERALOC With .T.

If lMT690GSH8
	ExecBlock("MT690GSH8",.F.,.F.)
EndIf	

If lMaqXQuant
	If TRB->QTDALOC != 0
		nRecTRB  := RecNo()
		cOpAnt   := TRB->OPAGLUT
		nRecSH8  := SH8->(RecNo())
		nRecCARGA:= CARGA->(RecNo())
		dbSkip()
		While !Eof()
			If cOpAnt == TRB->OPAGLUT .And. !Empty(cOpAnt)
				Replace TRB->RECURSO  With cRecurso
				Replace TRB->RECAGLUT With cRecurso
				Replace TRB->OPERALOC With .T. 
				
				cNCTRAB := U_C690CrCT(cRecurso)
				if Empty(cNCTRAB)
					cNCTRAB := TRB->CTRAB
				EndIf

				dbSelectArea("SH8")
				dbAppend()
				Replace H8_FILIAL 	With xFilial("SH8"),;
						H8_OP 		With TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,;
						H8_OPER 	With TRB->OPERAC,;
						H8_RECURSO 	With cRecurso,;
						H8_FERRAM 	With TRB->FERRAM,;
						H8_DTINI 	With aDtHrIni[1],;
						H8_HRINI 	With aDtHrIni[2],;
						H8_DTFIM 	With aDtHrFim[1],;
						H8_HRFIM 	With aDtHrFim[2],;
						H8_BITINI 	With nInicio,;
						H8_BITFIM 	With nFim,;
						H8_SEQPAI 	With TRB->SEQPAI,;
						H8_QUANT 	With TRB->QTDPROD,;
						H8_DESDOBR 	With IIf( nSubDiv == 0, StrZero(nNumDes,3), StrZero(nNumDes,3)+Substr(cABC,nSubDiv,1) ),;
						H8_BITUSO 	With nDurDesdob,;
						H8_SUBDIV 	With nIndSubDiv,;
						H8_CTRAB 	With cNCTRAB,;
						H8_ROTEIRO 	With TRB->CODIGO,;
						H8_SEQROTA 	With TRB->SEQROTA
				If lSeqCarg
					Replace  H8_SEQCARG With cSeqCarga
				EndIf

				If lSh8Setup
					Replace H8_SETUP With nSetup
				Endif	

				If lSh8TempEnd
					Replace H8_TEMPEND With nTempEnd
				Endif
				
				cNCTRAB := U_C690CrCT(cRecurso)
				if Empty(cNCTRAB)
					cNCTRAB := TRB->CTRAB
				EndIf
				
				dbSelectArea("CARGA")
				dbAppend()
				Replace H8_FILIAL 	With xFilial("SH8"),;
						H8_OP 		With TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,;
						H8_OPER 	With TRB->OPERAC,;
						H8_RECURSO 	With cRecurso,;
						H8_FERRAM 	With TRB->FERRAM,;
						H8_DTINI 	With aDtHrIni[1],;
						H8_HRINI 	With aDtHrIni[2],;
						H8_DTFIM 	With aDtHrFim[1],;
						H8_HRFIM 	With aDtHrFim[2],;
						H8_BITINI 	With nInicio,;
						H8_BITFIM 	With nFim,;
						H8_SEQPAI 	With TRB->SEQPAI,;
						H8_QUANT 	With TRB->QTDPROD,;
						H8_DESDOBR 	With IIf( nSubDiv == 0, StrZero(nNumDes,3), StrZero(nNumDes,3)+Substr(cABC,nSubDiv,1) ),;
						H8_BITUSO 	With nDurDesdob,;
						H8_SUBDIV 	With nIndSubDiv,;
						H8_CTRAB 	With cNCTRAB,;
						H8_ROTEIRO 	With TRB->CODIGO,;
						H8_SEQROTA 	With TRB->SEQROTA
				If lSeqCarg
					Replace  H8_SEQCARG With cSeqCarga
				EndIf

				If lSh8Setup
					Replace H8_SETUP With nSetup
				Endif	

				If lSh8TempEnd
					Replace H8_TEMPEND With nTempEnd
				Endif

				dbSelectArea("TRB")
				nRecTRB  := RecNo()
			Else
				Exit
			Endif
			dbSelectArea("TRB")
			dbSkip()
		End
		dbGoto(nRecTRB)
		SH8->(dbGoto(nRecSH8))
		CARGA->(dbGoto(nRecCARGA))
	Endif
Endif
dbSelectArea(cAlias)
dbSetOrder(nIndexOrd)
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690FSC2    � Autor � Robson Bueno Silv   � Data � 20/09/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Condicao para IndRegua do SC2.                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690FSC2()
Local xRet
Local cNumDe:=Substr(mv_par09,1,Len(SC2->C2_NUM))
Local cIteDe:=Substr(mv_par09,Len(SC2->C2_NUM)+1,Len(SC2->C2_ITEM))
Local cSeqDe:=Substr(mv_par09,Len(SC2->C2_NUM)+Len(SC2->C2_ITEM)+1,Len(SC2->C2_SEQUEN))
Local cNumAte:=Substr(mv_par10,1,Len(SC2->C2_NUM))
Local cIteAte:=Substr(mv_par10,Len(SC2->C2_NUM)+1,Len(SC2->C2_ITEM))
Local cSeqAte:=Substr(mv_par10,Len(SC2->C2_NUM)+Len(SC2->C2_ITEM)+1,Len(SC2->C2_SEQUEN))
Local cTipoOp:=IF(mv_par21==1," F",IF(mv_par21==2,"P"," FP"))
Local cItGrDe := Right(mv_par09,Len(SC2->C2_ITEMGRD))
Local cItGrAte:= Right(mv_par10,Len(SC2->C2_ITEMGRD))
Local cStatus:=If(mv_par05==1,"N ","NS ")
xRet := 'DTOS(C2_DATRF) == "'+Space(08)+'"'
xRet += '.And.C2_QUJE+C2_PERDA < C2_QUANT .And. C2_STATUS $ "'+cStatus+'"'
xRet += '.And.DTOS(C2_DATPRF) >= "'+DTOS(mv_par07)+'" .And. DTOS(C2_DATPRF) <= "'+DTOS(mv_par08)+'"'
xRet += '.And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= "' + cNumDe +cIteDe +cSeqDe +cItGrDe  + '"'
xRet += '.And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= "' + cNumAte+cIteAte+cSeqAte+cItGrAte + '"'
xRet += '.And.C2_PRODUTO >= "'+mv_par11+'" .And. C2_PRODUTO <= "'+mv_par12+'" .And. C2_TPOP $ "'+cTipoOp+'"'
If ExistBlock("u_C690FSC2")
	cRetBlock := ExecBlock("u_C690FSC2",.F.,.F.,xRet)
	If ValType(cRetBlock) == "C"
		xRet := cRetBlock
	EndIf
EndIf
Return xRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690SIni    � Autor � Robson Bueno Silv   � Data � 24/09/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula Bit Ideal para Alocacao de uma Operacao pelo Inicio���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690SIni(cChaveSH8,nTempSob,cTpSobre,aRet)
Local i, aRecAloc := {}, cString, cCalStr, nHora, nInicio, nFim
Local cCalend, nAscan, nBitIni, nBitFim, lFirst := .T., nRet := -99999
Local nPecasBit, nBitSobr, nDurTotal, nQuantProd, cRecurso

dbSelectArea("CARGA")
dbSetOrder(1)
dbSeek(xFilial("SH8")+cChaveSH8)
If !Found()
	Return nRet
EndIf

While !Eof() .And. xFilial("SH8")+cChaveSH8 == H8_FILIAL+H8_OP+H8_OPER
	nAscan := Ascan( aRecAloc, { |x| x[1] == H8_RECURSO } )
	If nAscan == 0
		cString := Space(aRet[4])
		cCalStr := Space(aRet[4])
		cRecurso := H8_RECURSO
		FSeek(aRet[5],PosiMaq(cRecurso,aRet[2])*aRet[4])
		If FRead(aRet[5],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		FSeek(aRet[5],PosiMaq(cRecurso,aRet[2])*aRet[4])
		If FRead(aRet[5],@cCalStr,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		Aadd( aRecAloc, { cRecurso, cString, cCalStr, NIL, NIL, 0, H8_QUANT})
		nAscan := Len( aRecAloc )
	EndIf

	nHora := Val(Substr(H8_HRINI,1,2)+"."+Substr(H8_HRINI,4,2))
	nInicio:= U_DtHr2Bit(H8_DTINI,nHora)
	If nInicio < 1
		nInicio := 1
	Endif
	nHora := Val(Substr(H8_HRFIM,1,2)+"."+Substr(H8_HRFIM,4,2))
	nFim := U_DtHr2Bit(H8_DTFIM,nHora)
	cCalend := aRecAloc[ nAscan ][2]
	StuffBit(@cCalend,nInicio,nFim-nInicio,aRet[4])
	aRecAloc[ nAscan ][2] := cCalend
	If aRecAloc[ nAscan ][4] == NIL
		aRecAloc[ nAscan ][4] := nInicio
	ElseIf aRecAloc[ nAscan ][4] > nInicio
		aRecAloc[ nAscan ][4] := nInicio
	EndIf
	If aRecAloc[ nAscan ][5] == NIL
		aRecAloc[ nAscan ][5] := nFim
	ElseIf aRecAloc[ nAscan ][5] < nFim
		aRecAloc[ nAscan ][5] := nFim
	EndIf
	aRecAloc[ nAscan ][6] += H8_BITUSO
	dbSkip()
End

If !Empty( aRecAloc )

	If nTempSob > 0

		nQuantProd := aRecAloc[1][7]
		nDurTotal := 0

		If Len( aRecAloc ) == 1
			nDurTotal := aRecAloc[1][6]
			nBitLimit := aRecAloc[1][5]
		Else
			For i := 1 to Len( aRecAloc )
				nDurTotal += aRecAloc[i][6]
				nBitLimit := IIf( aRecAloc[i][5] > nBitLimit, aRecAloc[i][5], nBitLimit )
			Next i
		EndIf

		nPecasBit := nQuantProd / nDurTotal

		nBit1Peca := Int( 1 / nPecasBit )+IIf( ( ( 1 / nPecasBit ) - Int( 1 / nPecasBit ) ) > 0, 1, 0)

		If cTpSobre == "1"
			nBitSobr := Int( nTempSob / nPecasBit )
		ElseIf cTpSobre == "2"
//		nBitSobr := NoRound( ( nDurTotal * nTempSob ) / 100 ,0)
			nBitSobr := NoRound( ( nDurTotal * nTempSob ) ,0)
		ElseIf cTpSobre == "3" .Or. cTpSobre == " "
			nBitSobr := U_C690T2B( nTempSob )
		EndIf

		If Len( aRecAloc ) == 1
			nRet := C690B1Ps(aRecAloc[1][2], aRecAloc[1][3], nBitSobr, aRecAloc[1][4], aRecAloc[1][5],aRet)
		Else
			nRet := U_C690B2Ps(aRecAloc,nBitSobr,aRet,IIf(cTpSobre=="1",.T.,.F.))
		EndIf

	Else
		nRet := aRet[4] * 8
		For i := 1 to Len( aRecAloc )
			nRet := IIf( aRecAloc[i][4] < nRet, aRecAloc[i][4], nRet )
		Next i
	EndIf

EndIf  

Return nRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690SFim    � Autor � Robson Bueno Silv   � Data � 02/10/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula Bit Ideal para Alocacao de uma Operacao pelo Fim   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690SFim(cOp,cOper,aRet,nRecTRB)
Local i, aRecAloc := {}, cString, cCalStr, nHora, nInicio, nFim
Local cCalend, nAscan, nBitIni, nBitFim, lFirst := .T., nRet := -99999
Local nPecasBit, nBitSobr, nDurTotal, nQuantProd, nRecAntTRB, nBitUtil := 0
Local aTest := {}

dbSelectArea("CARGA")
dbSetOrder(1)
dbSeek(xFilial("SH8")+cOp+cOper)
If !Found()
	Return nRet
EndIf

While !Eof() .And. xFilial("SH8")+cOp+cOper == H8_FILIAL+H8_OP+H8_OPER
	nAscan := Ascan( aRecAloc, { |x| x[1] == H8_RECURSO } )
	If nAscan == 0
		cString := Space(aRet[4])
		cCalStr := Space(aRet[4])
		FSeek(aRet[5],PosiMaq(H8_RECURSO,aRet[2])*aRet[4])
		If FRead(aRet[5],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		FSeek(aRet[5],PosiMaq(H8_RECURSO,aRet[2])*aRet[4])
		If FRead(aRet[5],@cCalStr,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		Aadd( aRecAloc, { H8_RECURSO, cString, cCalStr, NIL, NIL, 0, H8_QUANT})
		nAscan := Len( aRecAloc )
	EndIf

	nHora := Val(Substr(H8_HRINI,1,2)+"."+Substr(H8_HRINI,4,2))
	nInicio:= U_DtHr2Bit(H8_DTINI,nHora)
	If nInicio < 1
		nInicio := 1
	Endif
	nHora := Val(Substr(H8_HRFIM,1,2)+"."+Substr(H8_HRFIM,4,2))
	nFim := U_DtHr2Bit(H8_DTFIM,nHora)
	cCalend := aRecAloc[ nAscan ][2]
	StuffBit(@cCalend,nInicio,nFim-nInicio,aRet[4])
	aRecAloc[ nAscan ][2] := cCalend
	If aRecAloc[ nAscan ][4] == NIL
		aRecAloc[ nAscan ][4] := nInicio
	ElseIf aRecAloc[ nAscan ][4] > nInicio
		aRecAloc[ nAscan ][4] := nInicio
	EndIf
	If aRecAloc[ nAscan ][5] == NIL
		aRecAloc[ nAscan ][5] := nFim
	ElseIf aRecAloc[ nAscan ][5] < nFim
		aRecAloc[ nAscan ][5] := nFim
	EndIf
	aRecAloc[ nAscan ][6] += H8_BITUSO
	dbSkip()
End

If !Empty( aRecAloc )

	If TRB->TEMPSOB > 0

		dbSelectArea("TRB")
		nRecAntTRB := Recno()
		dbGoto(nRecTRB)

		nQuantProd := TRB->QTDPROD

		// Calcula Tempo de Dura��o baseado no Tipo de Operacao
		If AllTrim(TRB->TPOPER) $ " 1" .Or. Empty(TRB->TPOPER)         // BOPS 00000064408  // TRB->TPOPER == " " .Or. TRB->TPOPER == "1"
			nTemp := TRB->QTDPROD * ( IIf( TRB->TEMPAD == 0, 1, TRB->TEMPAD) / IIf( TRB->LOTEPAD == 0, 1, TRB->LOTEPAD ) )
			dbSelectArea("SH1")
			dbSeek(xFilial("SH1")+TRB->RECURSO)
			If Found() .And. H1_MAOOBRA # 0
				nTemp := nTemp / H1_MAOOBRA
			EndIf
			dbSelectArea("TRB")
			nDurTotal := U_C690T2B( nTemp )
			If nDurTotal == 0
				If SH1->(Found()) .And. SH1->H1_MAOOBRA > 1
					U_C690Ocor(14,.F.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,TRB->LOTEPAD,TRB->TEMPAD,SH1->H1_MAOOBRA,nTemp*60,TRB->QTDPROD)
				Else
					U_C690Ocor(15,.F.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,TRB->LOTEPAD,TRB->TEMPAD,nTemp*60,TRB->QTDPROD)
				EndIf
				Return -99999
			EndIf
		ElseIf AllTrim(TRB->TPOPER) $ "23"   // BOPS 00000064408  // TRB->TPOPER == "2" .Or. TRB->TPOPER == "3"
			nDurTotal := U_C690T2B( IIf( TRB->TEMPAD == 0 , 1 , TRB->TEMPAD ) )
			If nDurTotal == 0
				Return -99999
			EndIf
		EndIf

		If nDurTotal == Nil
			Return -99999	// BOPS 00000064408  //
		Endif

		dbGoto(nRecAntTRB)

		nPecasBit := nQuantProd / nDurTotal

		nBit1Peca := Int( 1 / nPecasBit )+IIf( ( ( 1 / nPecasBit ) - Int( 1 / nPecasBit ) ) > 0, 1, 0)

		For i := 1 to Len( aRecAloc )
			nBitUtil += aRecAloc[i][6]
		Next i

		nBitSobr := 0
		cTpSobre := TRB->TPSOBRE
		nTempSob := TRB->TEMPSOB

		If cTpSobre == "1"
			nBitSobr := Int( nTempSob / nPecasBit )
		ElseIf cTpSobre == "2"
			nBitSobr := NoRound( ( nDurTotal * nTempSob ) / 100 ,0)
		ElseIf cTpSobre == "3" .Or. cTpSobre == " "
			nBitSobr := U_C690T2B( nTempSob )
		EndIf

		nBitSobr := nDurTotal-nBitSobr

		If Len( aRecAloc ) == 1
			nRet := C690B1Ps(aRecAloc[1][2], aRecAloc[1][3], nBitSobr, aRecAloc[1][4], aRecAloc[1][5],aRet)
		Else
			nRet := U_C690B2Ps(aRecAloc,nBitSobr,aRet,IIf(cTpSobre=="1",.T.,.F.))
		EndIf

	Else
		nRet := aRet[4] * 8
		For i := 1 to Len( aRecAloc )
			nRet := IIf( aRecAloc[i][4] < nRet, aRecAloc[i][4], nRet )
		Next i

	EndIf

	nRet--

EndIf

Return nRet

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �C690B1Ps       � Autor � Robson Bueno Silv � Data � 24/09/95 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Busca qual a posicao em que o N-esimo bit foi alocado.      ���
���          � (Retorna o Bit seguinte `a posicao).                        ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function C690B1Ps(cString,cCalStr,nQtdBit,nBitIni,nBitFim,aRet)
Local nNextBit, nOk

nNextBit := u_NextBtFr(cCalStr, nBitIni,aRet,.T.)
While nQtdBit > 0
	If nNextBit == -1
		Exit
	EndIf
	If nNextBit >= nBitFim
		nNextBit := nBitFim
		Exit
	EndIf
	nOk := u_Bit2On(cString,nNextBit,1,aRet[4])
	If nOk == 0      // Ocupado
		nQtdBit--
	ElseIf nOk == -1
		nNextBit := -1
		Exit
	Endif
	nNextBit++
	If u_Bit2On(cCalStr,nNextBit,1,aRet[4]) # 1 .And. nQtdBit > 0
		nNextBit := u_NextBtFr(cCalStr, nNextBit,aRet,.T.)
	EndIf
End

Return nNextBit
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �C690B2Ps          Autor � Robson Bueno Silv� Data � 24/09/95 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Busca qual a posi��o em que o N-�simo bit foi alocado em    ���
���          � uma opera��o com desdobramentos.                            ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function C690B2Ps(aRecAloc,nBitSobr,aRet,lBit1Peca)
Local i,k,nNextBit,nStrOk, nCalOk, nNumRec, nUltimoBit := 0,nPosicao:=0
Local cCond := ".T.", nPrimeiroBit := 0

lBit1Peca := IIf( lBit1Peca == NIL, .F., lBit1Peca)

If mv_par01 == 2
	ASort( aRecAloc,,, { |x, y| x[4] < y[4] } )
	nBit := aRecAloc[1][4]
	nNumRec := 1
	For i := 2 to Len( aRecAloc )
		If aRecAloc[1][4] == aRecAloc[i][4]
			nNumRec++
		Else
			Exit
		EndIf
	Next i
	For i := 1 to Len( aRecAloc )
		If  aRecAloc[i][5] > nUltimoBit
			nUltimoBit:=aRecAloc[i][5]
			nPosicao:=i
		EndIf
	Next i

	//�������������������������������������������������������������������Ŀ
	//�Foi alterado o calendario desta funcao para considerar o calendario�
	//�do recurso que iniciou primeiro. Bops 00000125933                  �
	//���������������������������������������������������������������������
	//nBit:=C690B1Ps(aRecAloc[nPosicao,2],aRecAloc[1,3],nBitSobr,nBit,nUltimoBit,aRet)
	nBit:=C690B1Ps(aRecAloc[1,2],aRecAloc[1,3],nBitSobr,nBit,nUltimoBit,aRet)
Else
	ASort( aRecAloc,,, { |x, y| x[5] > y[5] } )
	nBit := aRecAloc[1][5] - 1
	nNumRec := 1
	For i := 2 to Len( aRecAloc )
		If aRecAloc[1][5] == aRecAloc[i][5]
			nNumRec++
		Else
			Exit
		EndIf
	Next i
	nPrimeiroBit := aRet[4] * 8
	For i := 1 to Len( aRecAloc )
		nPrimeiroBit := IIf( aRecAloc[i][4] < nPrimeiroBit, aRecAloc[i][4], nPrimeiroBit )
	Next i
	While nBitSobr > 0 .Or. nBit1Peca > ( aRecAloc[1][5] - nBit )
		For i := 1 to nNumRec
			nStrOk := u_Bit2On(aRecAloc[i][2],nBit,1,aRet[4])
			nCalOk := u_Bit2On(aRecAloc[i][3],nBit,1,aRet[4])
			If nStrOk == 0 .And. nCalOk == 1
				nBitSobr--
			EndIf
			If nBitSobr <= 0 .And. nBit1Peca <= ( aRecAloc[1][5] - nBit )
				Exit
			EndIf
		Next i
		If nBitSobr > 0 .Or. nBit1Peca > ( aRecAloc[1][5] - nBit )
			nBit--
			If nBit == nPrimeiroBit - 1
				Exit
			EndIf
			If nNumRec < Len( aRecAloc )
				k := nNumRec
				For i := k to Len( aRecAloc )
					If nBit == aRecAloc[i][5]
						nNumRec++
					Else
						Exit
					EndIf
				Next i
			EndIf
		EndIf
	End
EndIf
Return nBit
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690CalB    � Autor � Robson Bueno Silv   � Data � 02/10/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula Bit Inicial para aloca��o pelo Fim em uma Aloca��o ���
���          � pelo Inicio (Situacao que ocorre quando h� sobreposi��o em ���
���          � uma aloca��o e a opera��o a ser alocada n�o ultrapassa a   ���
���          � opera��o anterior, n�o atinge o nBitLimit).                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690CalB(aAlter,aSecun,aRet)
Local nRet := aRet[4]*8, nBit, lOk := .F., i

For i := 1 to Len(aAlter) + 1 // principal e alternativos
	If i == 1
		cString := Space(aRet[4])
		FSeek(aRet[1],PosiMaq(TRB->RECURSO,aRet[2])*aRet[4])
		If FRead(aRet[1],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		nBit := u_NextBtFr(cString,nBitLimit,aRet)
	Else
		cString := Space(aRet[4])
		FSeek(aRet[1],PosiMaq(aAlter[i-1],aRet[2])*aRet[4])
		If FRead(aRet[1],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		nBit := u_NextBtFr(cString,nBitLimit,aRet)
	EndIf
	If nBit # -1
		nRet := IIf( nBit < nRet, nBit, nRet )
		lOk := .T.
	EndIf
Next i
If !lOk .And. !Empty(aSecun)
	For i := 1 to Len(aSecun) // secundarios
		cString := Space(aRet[4])
		FSeek(aRet[1],PosiMaq(aSecun[i],aRet[2])*aRet[4])
		If FRead(aRet[1],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		nBit := u_NextBtFr(cString,nBitLimit,aRet)
		If nBit # -1
			nRet := IIf( nBit < nRet, nBit, nRet )
			lOk := .T.
		EndIf
	Next i
EndIf

If !lOk
	nRet := -1
Else
	nBit1Peca := nRet-nBitLimit+1
EndIf

Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C690Ajst   � Autor � Robson Bueno Silv   � Data � 10/10/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o que verifica se, em uma aloca��o pelo Fim, a Opera- ���
���          � ��o alocada esta respeitando o Tempo de Sobreposi��o, caso ���
���          � n�o esteja, desfaz a opera��o, retorna outro valor para    ���
���          � nBit e for�a o reinicio do processamento desta Opera��o.   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690Ajst(aRet,lFirstAjust,nBitAjust)
Local nRet, cAlias := Alias(), nRecTRB, nSeqAloc, nTempSob, cTpSobre
Local nRecAntTRB,cOp

nSeqAloc := Val(TRB->SEQALOC)
cOp := TRB->OPNUM+TRB->ITEM+TRB->SEQPAI+TRB->ITEMGRD
dbSelectArea("TRB")
nRecTRB := Recno()
dbSetOrder(2)
dbSeek(StrZero(nSeqAloc-1,7),.T.)
While !Bof()
	If OPERALOC .And. Recno() # nRecTRB .And. cOp == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD
		If TEMPSOB # 0 .Or. !Empty(TPSOBRE)
			nTempSob :=	TRB->TEMPSOB
			cTpSobre := TRB->TPSOBRE
			nRecAntTRB := Recno()
		EndIf
		Exit
	EndIf
	dbSkip(-1)
End

dbSelectArea("TRB")
dbSetOrder(1)
dbGoto(nRecTRB)

If nRecAntTRB # NIL
	nRet := U_C690Sjt(OPNUM+ITEM+SEQUEN+ITEMGRD+OPERAC,nTempSob,cTpSobre,aRet,nRecAntTRB,@lFirstAjust,@nBitAjust)
EndIf

nRet := IIf( nRet == NIL, 1, nRet )

dbSelectArea(cAlias)
Return IIf( nRet > 0, .T., .F.)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690SAjus   � Autor � Robson Bueno Silv   � Data � 10/10/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o que verifica se, em uma aloca��o pelo Fim, a Opera- ���
���          � ��o alocada esta respeitando o Tempo de Sobreposi��o, caso ���
���          � n�o esteja, desfaz a opera��o, retorna outro valor para    ���
���          � nBit e for�a o reinicio do processamento desta Opera��o.   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C690Sjt(cChaveSH8,nTempSob,cTpSobre,aRet,nRecAntTRB,lFirstAjust,nBitAjust)
Local i, aRecAloc := {}, cString, cCalStr, nHora, nInicio, nFim
Local cCalend, nAscan, nBitIni, nBitFim, lFirst := .T., nRet := -99999
Local nPecasBit, nBitSobr, nDurTotal, nQuantProd, cRecurso, nRetSH8
Local nIniAnt, nRecTRB

dbSelectArea("CARGA")
dbSetOrder(1)
dbSeek(xFilial("SH8")+cChaveSH8)
If !Found()
	Return nRet
EndIf

While !Eof() .And. xFilial("SH8")+cChaveSH8 == H8_FILIAL+H8_OP+H8_OPER
	nAscan := Ascan( aRecAloc, { |x| x[1] == H8_RECURSO } )
	If nAscan == 0
		cString := Space(aRet[4])
		cCalStr := Space(aRet[4])
		cRecurso := H8_RECURSO
		FSeek(aRet[5],PosiMaq(cRecurso,aRet[2])*aRet[4])
		If FRead(aRet[5],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		FSeek(aRet[5],PosiMaq(cRecurso,aRet[2])*aRet[4])
		If FRead(aRet[5],@cCalStr,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		Aadd( aRecAloc, { cRecurso, cString, cCalStr, NIL, NIL, 0, H8_QUANT})
		nAscan := Len( aRecAloc )
	EndIf

	nHora := Val(Substr(H8_HRINI,1,2)+"."+Substr(H8_HRINI,4,2))
	nInicio:= U_DtHr2Bit(H8_DTINI,nHora)
	If nInicio < 1
		nInicio := 1
	Endif
	nHora := Val(Substr(H8_HRFIM,1,2)+"."+Substr(H8_HRFIM,4,2))
	nFim := U_DtHr2Bit(H8_DTFIM,nHora)
	cCalend := aRecAloc[ nAscan ][2]
	StuffBit(@cCalend,nInicio,nFim-nInicio,aRet[4])
	aRecAloc[ nAscan ][2] := cCalend
	If aRecAloc[ nAscan ][4] == NIL
		aRecAloc[ nAscan ][4] := nInicio
	ElseIf aRecAloc[ nAscan ][4] > nInicio
		aRecAloc[ nAscan ][4] := nInicio
	EndIf
	If aRecAloc[ nAscan ][5] == NIL
		aRecAloc[ nAscan ][5] := nFim
	ElseIf aRecAloc[ nAscan ][5] < nFim
		aRecAloc[ nAscan ][5] := nFim
	EndIf
	aRecAloc[ nAscan ][6] += H8_BITUSO
	dbSkip()
End

If !Empty( aRecAloc )

	If nTempSob > 0

		nQuantProd := aRecAloc[1][7]
		nDurTotal := 0

		If Len( aRecAloc ) == 1
			nDurTotal := aRecAloc[1][6]
			nBitLimit := aRecAloc[1][5]
		Else
			For i := 1 to Len( aRecAloc )
				nDurTotal += aRecAloc[i][6]
				nBitLimit := IIf( aRecAloc[i][5] > nBitLimit, aRecAloc[i][5], nBitLimit )
			Next i
		EndIf

		nPecasBit := nQuantProd / nDurTotal

		nBit1Peca := Int( 1 / nPecasBit )+IIf( ( ( 1 / nPecasBit ) - Int( 1 / nPecasBit ) ) > 0, 1, 0)

		If cTpSobre == "1"
			nBitSobr := Int( nTempSob / nPecasBit )
		ElseIf cTpSobre == "2"
			nBitSobr := NoRound( ( nDurTotal * nTempSob ) / 100 ,0)
		ElseIf cTpSobre == "3" .Or. cTpSobre == " "
			nBitSobr := U_C690T2B( nTempSob )
		EndIf

		mv_par01 := 2
		If Len( aRecAloc ) == 1
			nRet := C690B1Ps(aRecAloc[1][2], aRecAloc[1][3], nBitSobr, aRecAloc[1][4], aRecAloc[1][5],aRet)
		Else
			nRet := U_C690B2Ps(aRecAloc,nBitSobr,aRet,IIf(cTpSobre=="1",.T.,.F.))
		EndIf
		mv_par01 := 1

	Else
		nRet := aRet[4] * 8
		For i := 1 to Len( aRecAloc )
			nRet := IIf( aRecAloc[i][4] < nRet, aRecAloc[i][4], nRet )
		Next i
	EndIf

EndIf

dbSelectArea("TRB")
nRecTRB := Recno()
dbGoto(nRecAntTRB)
dbSelectArea("CARGA")
dbSetOrder(1)
dbSeek(xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+TRB->OPERAC)
If !Found()
	Return nRet
EndIf

nIniAnt := aRet[4] * 8

While !Eof() .And. xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+TRB->OPERAC == H8_FILIAL+H8_OP+H8_OPER
	nHora := Val(Substr(H8_HRINI,1,2)+"."+Substr(H8_HRINI,4,2))
	nInicio:= U_DtHr2Bit(H8_DTINI,nHora)
	If nInicio < 1
		nInicio := 1
	Endif
	nIniAnt := IIf( nInicio < nIniAnt, nInicio, nIniAnt )
	dbSkip()
End

dbSelectArea("TRB")
dbGoto(nRecTRB)

If lFirstAjust
	lFirstAjust := .F.
	If nRet > nIniAnt
		If nRet+Int( Sqrt( nRet - nIniAnt )) > nIniAnt
			nBitAjust := Int( Sqrt( nRet - nIniAnt ) )
		EndIf
	EndIf
EndIf

Return IIf( nRet <= nIniAnt, nRet, -1 )
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690DSH8     � Autor � Robson Bueno Silv  � Data � 11/10/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Desfaz toda a aloca��o.                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
Local i, j, k, cBuffer, cRecurso, cString, nNumSubDiv

U_C690NAl(TRB->(OPNUM+ITEM+SEQUEN+ITEMGRD), .T.)

If mv_par03 == 1 .And. !Empty( aFerram )
	For i := 1 to Len(aSubDiv)
		//�����������������������������������������������Ŀ
		//� DesAloca o registro de ferramenta disponivel  �
		//�������������������������������������������������
		For k := 1 to Len( aFerram )
			U_C690Flc(aFerram[k],aSubDiv[i,1],aSubDiv[i,2],aRegFerr[i,1],.F.,aRet)
		Next k
	Next i
Endif

// Desfaz marcas no Arquivo TRB
dbSelectArea("TRB")
Replace OPERALOC With .F.

// Desfaz SH8 e Arquivos Binarios:
dbSelectArea("SH8")
dbSetOrder(1)
dbSeek(xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
While !Eof() .And. TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD == H8_OP
	FSeek( nSubDivHdl,SH8->H8_SUBDIV)
	cBuffer := Space(13)
	If FRead( nSubDivHdl,@cBuffer,13) # 13 .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
	EndIf
	If cBuffer # TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD
	*	Alert("You have dangerous problems with your Binary File !!!")
		Help(" ",1,"C690ErrBin",,RetTitle("H6_OP") + ": " + TRB->(OPNUM+ITEM+SEQUEN+ITEMGRD),05,38)
		Return .F.
	EndIf
	cRecurso := Space(6)
	If FRead( nSubDivHdl,@cRecurso,6) # 6 .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
	EndIf
	nNumSubDiv := Space(3)
	If FRead( nSubDivHdl,@nNumSubDiv,3) # 3 .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
	EndIf
	nNumSubDiv := Val(nNumSubDiv)
	For j := 1 to nNumSubDiv
		cBuffer := Space(12)
		If FRead( nSubDivHdl,@cBuffer,12) # 12 .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		FSeek(aRet[1],PosiMaq(cRecurso,aRet[2])*aRet[4])
		cString := Space(aRet[4])
		If FRead(aRet[1],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		UnStuff2(@cString,Val(Substr(cBuffer,1,6)),Val(Substr(cBuffer,7,6)),aRet[4])
		FSeek(aRet[1],PosiMaq(cRecurso,aRet[2])*aRet[4])
		If FWrite(aRet[1],cString,aRet[4]) < aRet[4] .And. !lShowOCR
			Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
		EndIf
	Next j
	RecLock("SH8",.F.)
	dbDelete()
	MsUnLock()
	dbSkip()
End

dbSelectArea("CARGA")
dbSetOrder(1)
dbSeek(xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
While !Eof() .And. TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD == H8_OP
	RecLock("CARGA",.F.)
	dbDelete()
	MsUnLock()
	dbSkip()
End

Return NIL

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CriaTrab � Autor � Jorge Queiroz         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria arquivo de trabalho                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpC1 := CriaTrab(ExpA1,ExpL1)                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Nome do Arquivo criado, devolvido pela funcao.     ���
���          � ExpA1 = Array multidimensional contendo os campos a criar. ���
���          �         {Nome,Tipo,Tamanho,Decimal}                        ���
���          � ExpL1 = Condicional (.T. Cria o arquivo .F. Nao Cria)      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACOM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function NewCrTb(aCampos,lCriaDbf,cDir)
LOCAL cNomeArq:=cDir+CriaTrab(NIL,.F.)
lCriaDbf := IIF(lCriaDBF==NIL,.T.,lCriaDbf)
While FILE(cNomeArq+IIF(lCriaDBF,GetDBExtension(),OrdBagExt()))
	cNomeArq:=cDir+CriaTrab(NIL,.F.)
End
IF lCriaDBF
	dbCreate(cNomeArq,aCampos, __cRDDNTTS )
ENDIF
Return cNomeArq

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690FArq     � Autor � Robson Bueno Silv  � Data � 05/12/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fecha Arquivos e Apaga-os do Winchester.                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690FArq(aArray)
Local i
For i := 1 to Len(aArray)
	FClose(aArray[i][1])
	If File(aArray[i][2])
		FErase(aArray[i][2])
	EndIf
Next i
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Bit2On      � Autor � Robson Bueno Silv  � Data � 12/12/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa a fun��o BitOn validando os par�metros             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Bit2On(x,y,k,z)
Return IIf(y>0,BitOn(x,y,k,z),-1)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � UnStuff2    � Autor � Robson Bueno Silv  � Data � 27/12/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa a fun��o UnStuff validando os par�metros           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function UnStuff2(x,y,k,z)
Return IIf(y>0,IIf(k>0,IIf(Len(x)==z,UnStuff(@x,y,k,z),-1),-1),-1)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690HrCt  � Autor � Rodrigo de A. Sartorio� Data � 14/05/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tranforma o tempo normal em tempo centesimal               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpN1=C690HrCt(ExpC2)                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Retorna o tempo centesimal                         ���
���          � ExpC2 = Tempo a ser transformado Ex. "02.30"               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690HrCt(nTempo)
If cTipoTemp # "C"
	nTempo:=Int(nTempo)+(((nTempo-Int(nTempo))/60)*100)
EndIf
Return nTempo

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C690AtCg    � Autor � Robson Bueno Silv  � Data � 25/01/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o que atualiza arquivos bin�rios da Carga e Ferramen. ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690AtCg(cCalStr, aRecursos, cUltFerr, aRet, cRecurso, aSubDiv, aFerram, aRegFerr,lIlimitado)
Local i, l, cString, nPosAsBin := 1, nPosArray, nInicio, nFim, aDtHrIni, aDtHrFim
Local nIniLocFer,nFimLocFer,nTmpBitAux
Local aProcess := {}
Local lOneAloc := .T.
lIlimitado:= IF(lIlimitado == NIL,.F.,lIlimitado)

// Caso recurso nao seja ilimitado
If !lIlimitado
	cString := Space(aRet[4])
	cCalStr := Space(aRet[4])
	FSeek(aRet[1],PosiMaq(cRecurso,aRet[2])*aRet[4])
	If FRead(aRet[1],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
	EndIf
	FSeek(aRet[5],Posimaq(cRecurso,aRet[2])*aRet[4])
	If FRead(aRet[5],@cCalStr,aRet[4]) # aRet[4] .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
	EndIf

	If aRecursos[nPosAsBin][1] # TRB->RECURSO
		nPosAsBin := U_C690AsBn( aRecursos, TRB->RECURSO )
	EndIf
	If nPosAsBin > 0
		For i:= 1 to Len(aSubDiv)
			StuffBit(@cString,aSubDiv[i][1],aSubDiv[i][2],aRet[4])
			nPosArray := Ascan( aRecursos[ nPosAsBin ][4] , { |x| x[1] == TRB->PRODUTO } )
			If nPosArray == 0
				Aadd( aRecursos[ nPosAsBin ][4], { TRB->PRODUTO, TRB->OPERAC, { aSubDiv[i][1], aSubDiv[i][1]+aSubDiv[i][2]-1,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,cRecurso }} )
			Else
				Aadd( aRecursos[ nPosAsBin ][4][ nPosArray ], { aSubDiv[i][1], aSubDiv[i][1]+aSubDiv[i][2]-1,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,cRecurso } )
			EndIf
			If mv_par03 == 1 .And. !Empty(aFerram)
				//��������������������������������������������Ŀ
				//� Aloca o registro de ferramenta disponivel  �
				//����������������������������������������������
				For l := 1 to Len( aFerram )
					If Empty(AsCan(aProcess,{|x|x[1]==TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD}))
						Aadd(aProcess,{TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,TRB->TPALOCF})
						lOneAloc := .T.
					Else
						If TRB->TPALOCF=="1"
							Loop
						EndIf
					EndIf				
					//��������������������������������������������Ŀ
					//� Verifica a alocacao da ferramenta          �
					//����������������������������������������������
					If TRB->TPALOCF=="1"		//Aloca ferramenta somente durante Setup
						nIniLocFer := aSubDiv[i,1]
						nFimLocFer := U_C690SupG()
					ElseIf TRB->TPALOCF=="2" .And. lOneAloc   //Aloca ferramenta somente durante Operacao
						lOneAloc   := .F.
						nIniLocFer := aSubDiv[i,1]+U_C690SupG()
						nFimLocFer := aSubDiv[i,2]-U_C690SupG()		   			
					Else
						nIniLocFer := aSubDiv[i,1]
						nFimLocFer := aSubDiv[i,2]
					EndIf

					U_C690Flc(aFerram[l],nIniLocFer,nFimLocFer,aRegFerr[i,l],.T.,aRet)
					nInicio := nIniLocFer
					nFim    := nIniLocFer+nFimLocFer
					aDtHrIni:=u_Bit2DtHr(nInicio,dDataPar)
					aDtHrFim:=u_Bit2DtHr(nFim,dDataPar)

					dbSelectArea("FER")
					dbAppend()

					Replace  HE_FILIAL With xFilial("SHE"),;
						HE_PRODUTO With TRB->PRODUTO,;
						HE_CODIGO With TRB->CODIGO,;
						HE_OPERAC With TRB->OPERAC,;
						HE_FERRAM With aFerram[l],;
						HE_DTINI With aDtHrIni[1],;
						HE_HRINI With aDtHrIni[2],;
						HE_DTFIM With aDtHrFim[1],;
						HE_HRFIM With aDtHrFim[2],;
						HE_OP With TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD

				Next l
				cUltFerr := aFerram[1]+StrZero(aRegFerr[i,1],6)
			EndIf
		Next i
	EndIf
	//������������������������������������������������������Ŀ
	//� Grava String com a operacao alocada                  �
	//��������������������������������������������������������
	FSeek(aRet[1],PosiMaq(cRecurso,aRet[2])*aRet[4])
	If FWrite(aRet[1],cString,aRet[4]) < aRet[4] .And. !lShowOCR
		Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
	EndIf
EndIf
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690Ocor  � Autor � Ary Medeiros          � Data �          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Revis�o  � Waldemiro L. Lustosa                     � Data � 13/09/95 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690Ocor(nTipo,lPergunta,uVar1,uVar2,uVar3,uVar4,uVar5,uVar6,uVar7)
Local i, nHdl,cAlias := Alias(), cFile, nTamArq, nLin, nTamText
Local  cVarText
Local cBuffer, cText := "", lRet := .T.
Local cProduto := ""
Local oDlg,oOcorr,aOcorr:={}

Static lContOcor := Nil

lPergunta := IIf( lPergunta == NIL , .F. , lPergunta )
lOcorreu  := .T.
cFile := cDirPcp+cNameCarga+".OCR"
If !File(cFile)
	lShowOCR := (MV_PAR18 == 1)
	nHdl := MSFCREATE(cFile,1)
Else
	nHdl := FOpen(cFile,2+64)
Endif

If !U_C690IsBt() .And. (fError() <> 0) .And. (lContOcor==Nil)
	lContOcor := MsgYesNo("N�o foi poss�vel a Abertura/Cria��o do arquivo "+cNameCarga+".OCR"+" no diret�rio "+cDirPcp+". Verifique com o Administrado de Rede as permiss�es de acesso ao Arquivo\Diret�rio informados."+" Devido a essa inconsist�ncia n�o ser� poss�vel exibir o Log de Ocorr�ncias do Carga M�quina. Deseja prosseguir o processamento ?","Aten��o") //"N�o foi poss�vel a Abertura\Cria��o do arquivo "##" no diret�rio "##". Verifique com o Administrado de Rede as permiss�es de acesso ao Arquivo\Diret�rio informados."##" Devido a essa inconsist�ncia n�o ser� poss�vel exibir o Log de Ocorr�ncias do Carga M�quina. Deseja prosseguir o processamento ?"##"Aten��o"
	If !lContOcor
		Final("Processamento Cancelado !!!") //"Processamento Cancelado !!!"	
	EndIf
EndIf

If (lContOcor == Nil)
	If nTipo == 1
		U_C690AdLn(@cText,"N�o existem Recursos cadastrados. Processamento cancelado.")	//"N�o existem Recursos cadastrados. Processamento cancelado."
	ElseIf nTipo == 2
		U_C690AdLn(@cText,"O calend�rio "+uVar1+", cadastrado no Recurso "+uVar2+", n�o existe.")	//"O calend�rio "###", cadastrado no Recurso "###", n�o existe."
		U_C690AdLn(@cText,"Processamento cancelado.")	//"Processamento cancelado."
	ElseIf nTipo == 3
		uVar2 := Alltrim(uVar2)
		U_C690AdLn(@cText,"N�o existe Roteiro de Opera��o Padr�o "+uVar1+" para o Produto "+IIf( Len(uVar2) < 7, uVar2+"," , "" ))	//"N�o existe Roteiro de Opera��o Padr�o "###" para o Produto "
		U_C690AdLn(@cText,IIf( Len(uVar2) >= 7, uVar2+",", "")+" ele ser� desconsiderado."+uVar3+")")	//" ele ser� desconsiderado."
	ElseIf nTipo == 4
		U_C690AdLn(@cText,"N�o h� Ordens de Produ��o selecionadas para Aloca��o.")	//"N�o h� Ordens de Produ��o selecionadas para Aloca��o."
	ElseIf nTipo == 5
		U_C690AdLn(@cText,"A Ordem de Produ��o "+uVar1+" n�o pode ser alocada porque tem")	//"A Ordem de Produ��o "###" n�o pode ser alocada porque tem"
		If uVar2 == dDataPar
			U_C690AdLn(@cText,"Data Prevista de Entrega no dia "+Dtoc(uVar2)+" (igual a data base).")	//"Data Prevista de Entrega no dia "###" (igual a data base)."
		Else
			U_C690AdLn(@cText,"Data Prevista de Entrega no dia "+Dtoc(uVar2)+" (anterior a data base).")	//"Data Prevista de Entrega no dia "###" (anterior a data base)."
		EndIf
	ElseIf nTipo == 6
		uVar3 := Alltrim(uVar3)
		U_C690AdLn(@cText,"O Recurso "+uVar1+", cadastrado na Opera��o "+uVar2+" do Roteiro de")	//"O Recurso "###", cadastrado na Opera��o "###" do Roteiro de"
		U_C690AdLn(@cText,"Opera��es do Produto "+uVar3+", n�o foi encontrado no")	//"Opera��es do Produto "###", n�o foi encontrado no"
		U_C690AdLn(@cText,"Cadastro de Recursos, esta opera��o ser� desconsiderada.")	//"Cadastro de Recursos, esta opera��o ser� desconsiderada."
	ElseIf nTipo == 7
		uVar4 := Alltrim(uVar4)
		If uVar1 == "S"
			cVarText := "Secund�rio"	//"Secund�rio"
		Else
			cVarText := "Alternativo"	//"Alternativo"
		EndIf
		U_C690AdLn(@cText,"O Recurso "+cVarText+" "+uVar2+", cadastrado na Opera��o "+uVar3+" do Roteiro de")	//"O Recurso "###", cadastrado na Opera��o "###" do Roteiro de"
		U_C690AdLn(@cText,"Opera��es do Produto "+uVar4+", n�o foi encontrado no")	//"Opera��es do Produto "###", n�o foi encontrado no"
		U_C690AdLn(@cText,"Cadastro de Recursos, ele ser� desconsiderado.")	//"Cadastro de Recursos, ele ser� desconsiderado."
	ElseIf nTipo == 8
		cProduto := Alltrim(TRB->PRODUTO)+") "
		U_C690AdLn(@cText,"N�o foi poss�vel alocar a Opera��o "+uVar1+" (OP "+uVar2+" Produto")	//"N�o foi poss�vel alocar a Opera��o "###" (OP "###" Produto"
		If uVar3
			uVar3 := .F.
			U_C690AdLn(@cText,cProduto+"dentro do per�odo definido na Carga  M�quina,  provavelmente  o  pe-") //"dentro do per�odo definido na Carga  M�quina,  provavelmente  o  pe-"
			U_C690AdLn(@cText,"r�odo entre a Data Prevista de Entrega e a Data Base n�o seja")	//"r�odo entre a Data Prevista de Entrega e a Data Base n�o seja"
			U_C690AdLn(@cText,"suficiente para a aloca��o das opera��es.")	//"suficiente para a aloca��o das opera��es."
		Else
			U_C690AdLn(@cText,"dentro do per�odo definido para a Carga M�quina.")	//"dentro do per�odo definido para a Carga M�quina."
		EndIf
	ElseIf nTipo == 9
		cProduto := Alltrim(TRB->PRODUTO)+") "
		U_C690AdLn(@cText,"N�o foi poss�vel alocar a Opera��o "+uVar1+" (OP "+uVar2+" Produto"	)	//"N�o foi poss�vel alocar a Opera��o "###" (OP "###" Produto"	
		U_C690AdLn(@cText,cProduto+"dentro do per�odo definido para a Carga M�quina.")	//"dentro do per�odo definido para a Carga M�quina."
	ElseIf nTipo == 10
		U_C690AdLn(@cText,"N�o h� ferramentas "+uVar1+" dispon�veis para aloca��o da opera��o "+uVar2)	//"N�o h� ferramentas "###" dispon�veis para aloca��o da opera��o "
		U_C690AdLn(@cText," (OP "+uVar3+").")	//" (OP "
	ElseIf nTipo == 11
		U_C690AdLn(@cText,"A Opera��o "+uVar1+" n�o pode ser alocada na melhor posi��o")	//"A Opera��o "###" n�o pode ser alocada na melhor posi��o"
		U_C690AdLn(@cText,"do Recurso "+uVar2+", pois n�o h� ferramenta "+uVar3+" dispon�vel")	//"do Recurso "###", pois n�o h� ferramenta "###" dispon�vel"
		U_C690AdLn(@cText," (OP "+uVar4+").")	//" (OP "
	ElseIf nTipo == 12
		cProduto := Alltrim(TRB->PRODUTO)+") "
		U_C690AdLn(@cText,"N�o foi poss�vel alocar a Opera��o "+uVar1+" (OP "+uVar2+" Produto")	//"N�o foi poss�vel alocar a Opera��o "###" (OP "###" Produto"
		If uVar3
			uVar3 := .F.
			U_C690AdLn(@cText,cProduto+"dentro do per�odo definido na Carga M�quina,  esta  opera��o  est�  u-")	//"dentro do per�odo definido na Carga M�quina,  esta  opera��o  est�  u-"
			U_C690AdLn(@cText,"tilizando desdobramento e sobreposi��o para ser alocada, aumen-")	//"tilizando desdobramento e sobreposi��o para ser alocada, aumen-"
			U_C690AdLn(@cText,"te o Tempo de Desdobramento ou utilize Desdobramento Proporcio-")	//"te o Tempo de Desdobramento ou utilize Desdobramento Proporcio-"
			U_C690AdLn(@cText,"para tentar solucionar esta Ocorr�ncia (Detectei "+Alltrim(Str(uVar4,4))+" desdobra-")	//"para tentar solucionar esta Ocorr�ncia (Detectei "###" desdobra-"
			U_C690AdLn(@cText,"mentos para apenas "+Alltrim(Str(uVar5+1,4))+" Recursos - Principal e Alternativos).")	//"mentos para apenas "###" Recursos - Principal e Alternativos)."
		Else
			U_C690AdLn(@cText,"do per�odo definido na Carga M�quina (Ver dica acima).")	//"do per�odo definido na Carga M�quina (Ver dica acima)."
		EndIf
	ElseIf nTipo == 13
		U_C690AdLn(@cText,"A ferramenta "+uVar1[1]+" tem "+Str(uVar2,4,0)+" pe�as dispon�veis. Na montagem dos")	//"A ferramenta "###" tem "###" pe�as dispon�veis. Na montagem dos"
		U_C690AdLn(@cText,"Arquivos de trabalho foi detectado um bloqueio desta ferramenta")	//"Arquivos de trabalho foi detectado um bloqueio desta ferramenta"
		U_C690AdLn(@cText,"de "+Str(uVar1[2],4,0)+" pe�as. Todas as pe�as desta ferramenta foram bloqueadas")	//"de "###" pe�as. Todas as pe�as desta ferramenta foram bloqueadas"
		U_C690AdLn(@cText,"(Per�odo entre "+Dtoc(uVar1[3])+" �s "+StrTran(Str(uVar1[4],5,2),".",":")+" e "+Dtoc(uVar1[5])+" �s "+StrTran(Str(uVar1[4],5,2),".",":")+").")	//"(Per�odo entre "###" �s "###" e "###" �s "
	ElseIf nTipo == 14
		cProduto := Alltrim(TRB->PRODUTO)+") "
		U_C690AdLn(@cText,"N�o foi poss�vel alocar a Opera��o "+uVar1+" "+" (OP "+" "+uVar2+" Produto")	//"N�o foi poss�vel alocar a Opera��o "###" (OP "###" Produto"
		U_C690AdLn(@cText,cProduto+"pois com um Lote Padr�o de "+Str(uVar3,6,0)+", um Tempo Padr�o de "+Str(uVar4,6,2)+", e  com")	//"pois com um Lote Padr�o de "###", um Tempo Padr�o de "###", e  com"
		U_C690AdLn(@cText,"o Campo Efici�ncia (M�o de Obra) preenchido com "+Str(uVar5,3,0)+"  (no Cadas-")	//"o Campo Efici�ncia (M�o de Obra) preenchido com "###"  (no Cadas-"
		U_C690AdLn(@cText,"tro de Recursos), o  Sistema n�o consegue alocar  uma  Opera��o")	//"tro de Recursos), o  Sistema n�o consegue alocar  uma  Opera��o"
		U_C690AdLn(@cText,"que  dura "+IIf(Int(uVar6)==Round(uVar6,4),Str(uVar6,11,0),Str(uVar6,7,4))+" minutos  (para "+IIf(Int(uVar7)==uVar7,Str(uVar7,12,0),Str(uVar7,8,4))+", e  com")	//"que  dura "###" minutos  (para "###"  pe�as  nesta"
		U_C690AdLn(@cText,"OP), pois o Per�odo M�nimo da Carga M�quina � de "+Str(60/nPrecisao,2,0)+" minutos.")	//"OP), pois o Per�odo M�nimo da Carga M�quina � de "###" minutos."
	ElseIf nTipo == 15
		cProduto := Alltrim(TRB->PRODUTO)+") "
		U_C690AdLn(@cText,"N�o foi poss�vel alocar a Opera��o "+uVar1+" "+" (OP "+uVar2+" Produto")	//"N�o foi poss�vel alocar a Opera��o "###" (OP "###" Produto"
		U_C690AdLn(@cText,cProduto+"pois com um Lote Padr�o de "+Str(uVar3,6,0)+", um Tempo Padr�o de "+Str(uVar4,6,2)+",")	//"pois com um Lote Padr�o de "###", um Tempo Padr�o de "###","
		U_C690AdLn(@cText,"o Sistema n�o consegue alocar uma Opera��o que dura "+IIf(Int(uVar5)==Round(uVar5,4),Str(uVar5,11,0),Str(uVar5,7,4))+" ")	//"o Sistema n�o consegue alocar uma Opera��o que dura "###" "
		U_C690AdLn(@cText," minutos (para "+IIf(Int(uVar6)==uVar6,Str(uVar6,12,0),Str(uVar6,8,4))+" pe�as nesta OP), pois o Per�odo M�nimo")	//" minutos (para "###" pe�as nesta OP), pois o Per�odo M�nimo"
		U_C690AdLn(@cText,"da Carga M�quina � de "+Str(60/nPrecisao,2,0)+" minutos.")	//"da Carga M�quina � de "###" minutos."
	EndIf
                             
	If !Empty(nTipo)
		U_C690AdLn(@cText,Space(10)	)
	EndIf

	nTamArq := FSeek(nHdl,0,2)
	nLin := nTamArq / 65
	nTamText := Len(cText) / 65

	If !U_C690IsBt() .And. lPergunta .And. (MV_PAR18 == 1)
		For i := 1 to nTamText
			AADD(aOcorr,OemToAnsi(Substr(cText,1+(65*(i-1)),63)))
		Next i

		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Ocorr�ncias Durante Aloca��o") From 8,05 To 22,55 STYLE DS_MODALFRAME OF oMainWnd	//"Ocorr�ncias Durante Aloca��o"
		@ 1,002 LISTBOX oOcorr Fields HEADER Space(63) SIZE 170,50
		oOcorr:SetArray(aOcorr)
		oOcorr:bLine := { || {aOcorr[oOcorr:nAT]} }
		@ 75,010 TO 75,185 LABEL "" OF oDlg PIXEL
		@ 82,010 BUTTON OemToAnsi("&Interrompe Processamento") ACTION (oDlg:End(),lRet:=.F.) SIZE 80,11 OF oDlg PIXEL	//"&Interrompe Processamento"
		@ 82,105 BUTTON OemToAnsi("&Continua Processamento") ACTION oDlg:End() SIZE 80,11 OF oDlg PIXEL	//"&Continua Processamento"
		ACTIVATE MSDIALOG oDlg
	EndIf

	nTamArq := FSeek(nHdl,0,2)
	nLin := nTamArq / 65
	nTamText := Len(cText) / 65
	If nLin+nTamText < 10
		FSeek(nHdl,0,0)
		For i := 1 to nLin
			cBuffer := Space(65)
			If FRead(nHdl,@cBuffer,65) # 65 .And. !lShowOCR
				Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
			EndIf
		Next i
	EndIf
	FSeek(nHdl,0,2)
	If FWrite(nHdl,cText,Len(cText)) < Len(cText) .And. !lShowOCR
		Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
	EndIf
	FClose(nHdl)
EndIf
dbSelectArea(cAlias)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690AdLn    � Autor � Robson Bueno Silv   � Data � 13/09/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que adiciona espaco e caracteres de Enter e fim de  ���
���          � linha nas linhas do Registro de Ocorrencia.                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690AdLn(cText,cLine)

Local cEnter     := Chr(13) + Chr(10)
Local nLoop      := 0

Do While .T. .And. nLoop <= 200
	If Space(2) $ cLine
		cLine := StrTran(cLine, Space(2), Space(1))
		nLoop ++
		Loop
	Else
		Exit
	EndIf
EndDo

If Len(cLine) <= 63
	cText += cLine + Space(63-Len(cLine)) + cEnter
Else
	cText += SubStr(cLine, 01, 63) + cEnter
	ctext += SubStr(cLine, 64, Len(cLine)) + cEnter
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CloseSH8   � Autor �Rodrigo de A Sartorio� Data � 03/07/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que fecha o SH8 e o retira da variavel cFopened e da���
���          � abertura do MNU.                                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CloseSH8()   

If Select("SH8") > 0
	dbSelectArea("SH8")
	RetIndex("SH8")
	dbCloseArea()
EndIf
	UnLockByName("SH8USO"+cNumEmp,.T.,.T.,.T.)
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690ASC2    � Autor � Robson Bueno Silv   � Data � 16/09/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Atualizacao do SC2 - Ordens de Produ��o          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690ASC2()
Local lOk := .F.
Local lImpRel := .F.
Local oChk
PRIVATE oDlg2
PRIVATE oMeter,nMeter:=0,nTotMeter:=0,oSay
PRIVATE bIncre:={|| oMeter:Set(++nMeter),SysRefresh()}
If !U_C690IsBt()
	DEFINE MSDIALOG oDlg2 FROM  100,100 TO 360,580 TITLE OemToAnsi("Aten��o") PIXEL	//"Aten��o"
	@ 10,015 TO 80,215 LABEL "" OF oDlg2  PIXEL
	@ 21,030 SAY oSay VAR OemToAnsi("Carga M�quina efetuada com sucesso !") SIZE 180,8 OF oDlg2  PIXEL	//"Carga M�quina efetuada com sucesso !"
	oSay:SetColor(CLR_HRED,GetSysColor(15))
	@ 31,030 SAY OemToAnsi("O cadastro de Solicita��es de Compra e o Cadastro de Requisi��es") SIZE 180,8 OF oDlg2 PIXEL	//"O cadastro de Solicita��es de Compra e o Cadastro de Requisi��es"
	@ 41,030 SAY OemToAnsi("Empenhadas n�o foram atualizados, voc� quer atualiz�-los agora ?") SIZE 180,8 OF oDlg2 PIXEL	//"Empenhadas n�o foram atualizados, voc� quer atualiz�-los agora ?"
	@ 61,030 CHECKBOX oChk VAR lImpRel PROMPT "Imprime Lista de Faltas" SIZE 66, 10 OF oDlg2 PIXEL //"Imprime Lista de Faltas"

	@ 90,015 METER oMeter VAR nMeter TOTAL nTotMeter SIZE 200,8 OF oDlg2 NOPERCENTAGE PIXEL
	DEFINE SBUTTON FROM 110,188 TYPE 2 ACTION oDlg2:End() ENABLE OF oDlg2
	DEFINE SBUTTON FROM 110,150 TYPE 1 ACTION (ProcASC2(),lOk:=.T.,oDlg2:End()) ENABLE OF oDlg2
	ACTIVATE MSDIALOG oDlg2
	If lOk .And. lImpRel
		MATR350()
		U_C690Qst(.F.) // Chamo pergunte para restaurar os mv_pars depois da impressao do relatorio
	Endif	
ElseIf l690AtuSC2
	u_ProcASC2()
EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ProcASC2   � Autor �Rodrigo de A Sartorio� Data � 03/07/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa Atualizacao do SC2 - Ordens de Produ��o           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ProcASC2()
Local cAlias	:= Alias(), nIndexOrd := IndexOrd(), cOp, cOpPos
Local cFilSC2	:= U_C690FSC2()
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local lAltGra	:= posicione("SX1", 1, PADR("MTA650",nTamSX1)+"01", "X1_PRESEL") == 1

dbSelectArea("CARGA")
dbSetOrder(1)
dbSelectArea("SC1")
dbSetOrder(4)
dbSelectArea("SD4")
dbSetOrder(2)
dbSelectArea("SC2")
dbSeek(xFilial("SC2") + mv_par09, .T.)
If !U_C690IsBt()
	oMeter:nTotal:=nTotMeter:= LastRec()
EndIf
While !Eof() .And. xFilial("SC2") == C2_FILIAL .And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= mv_par10
	If !U_C690IsBt()
		EVAL(bIncre)
	EndIf
	// Filtra as Ordens de Producao de Acordo com os parametros selecionados
	If !&(cFilSC2)
		dbSkip()
		Loop
	EndIf
	// Desconsiderando as OPs j� sacramentadas, pois elas tem informa��es no Arquivo "CARGA"
	// corretas apenas para visualiza��o, as informa��es corretas para processamento j� foram
	// utilizadas anteriormente e est�o no Arquivo "SH8".
	If C2_STATUS == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	EndIf
	cOp := C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	dbSelectArea("CARGA")
	dbSeek(xFilial("SH8")+cOp)
	If Found()
		dbSelectArea("SC2")
		RecLock("SC2",.F.)
		Replace  C2_DATAJI  With CARGA->H8_DTINI,;
			C2_HORAJI  With CARGA->H8_HRINI,;
			C2_RECURSO With CARGA->H8_RECURSO
		MsUnLock()
		dbSelectArea("CARGA")
		cOpPos := Substr(cOp,1,8)+StrZero(Val(Substr(cOp,9,3))+1,3)
		dbSeek(xFilial("SH8")+cOpPos,.T.)
		dbSkip(-1)
		dbSelectArea("SC2")
		RecLock("SC2",.F.)
		Replace  C2_DATAJF with CARGA->H8_DTFIM,;
			C2_HORAJF with CARGA->H8_HRFIM
		MsUnLock()
	Else
		dbSelectArea("SC2")
		dbSkip()
		Loop
	Endif
	//-- Atualiza datas das SC`s
	dbSelectArea("SC1")
	dbSeek(xFilial("SC1")+cOp)
	While C1_FILIAL+C1_OP == xFilial("SC1")+cOp
		If !Empty(SC2->C2_DATAJI)
			RecLock("SC1",.F.)
			Replace C1_DATPRF with SC2->C2_DATAJI
			MsUnlock()
		EndIf
		//-- Atualiza datas das cotacoes
		dbSelectArea("SC8")
		dbSetOrder(3)
		dbSeek(xFilial("SC8")+SC1->(C1_COTACAO+C1_PRODUTO))
		While !EOF() .And. C8_FILIAL+C8_NUM+C8_PRODUTO == xFilial("SC8")+SC1->(C1_COTACAO+C1_PRODUTO)
			RecLock("SC8",.F.)
			Replace C8_DATPRF With SC2->C2_DATAJI
			MsUnLock()
			dbSkip()
		End
		dbSelectArea("SC1")
		dbSkip()
	End
	//-- Atualiza datas das AE`s
	dbSelectArea("SC7")
	dbSetOrder(8)
	dbSeek(xFilial("SC7")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	While ! Eof() .And. Alltrim(C7_FILIAL+If(!lAltGra,C7_OP,Left(C7_OP,Len(cOp)))) == Alltrim(xFilial("SC7")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+If(lAltGra,"",SC2->C2_ITEMGRD))
		If C7_TIPO == 2
			RecLock("SC7", .F.)
			Replace C7_DATPRF With SC2->C2_DATAJI
			MsUnlock()
		EndIf
		dbSkip()
	End
	//-- Atualiza datas dos empenhos
	dbSelectArea("SD4")
	dbSeek(xFilial("SD4")+cOp)
	While D4_FILIAL+D4_OP == xFilial("SD4")+cOp
		If !Empty(SC2->C2_DATAJI)
			RecLock("SD4",.F.)
			Replace D4_DATA with SC2->C2_DATAJI
			MsUnlock()
		EndIf
		dbSkip()
	End
	dbSelectArea("SC2")
	//Ponto de entrada ap�s as atualizacoes de datas no SC2, SC1 e SD4
	If ExistBlock("MT690DAT")
		ExecBlock("MT690DAT",.F.,.F.,{cOP,C2_DATAJI,C2_DATAJF})
	EndIf
	dbSkip()
End
If !U_C690IsBt()
	EVAL(bIncre)
EndIf
a690CheckSC2(.F.)
dbSelectArea("SC1")
dbSetOrder(1)
dbSelectArea("SD4")
dbSetOrder(1)
dbSelectArea(cAlias)
dbSetOrder(nIndexOrd)
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C690Relt   � Autor �Rodrigo de A Sartorio� Data � 03/07/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que fecha o SH8, chama o relatorio de carga m�quina,���
���          � abre o arquivo como exclusivo novamente e volta para o Dlg.���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690Relt()
If ExistBlock("C690NREL")
    ExecBlock("C690NREL",.F.,.F.)
Else
	dbSelectArea("SB1")
	MATR815()    
Endif		

If OpenSemSH8()
	U_C690Qst(.F.)
	
	//-- Fecha/Libera Semaforo SH8
	ClosSemSH8()
Else
	oDlg:End()
EndIf
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690NomeLongo� Autor � Robson Bueno       � Data �05/07/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica de diret�rio � nome longo                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cPath  : Nome do diret�rio a ser checado                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP       �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function C690NmL(cPath)
Local x
Local nTmp := 0
Local lRet := .F.
For x := 1 to Len(cPath)
	If (nTmp := If(SubStr(cPath, x, 1) $ ":\", 0, nTmp + 1)) > 8
		lRet := .T.
		Exit
	Endif
Next
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690RcLn   � Autor � Robson Bueno         � Data �11/03/2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a linha de producao de um recurso                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cRecurso: Recurso a ter a linha retornada                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP       �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690RcLn(cRecurso)
Local aSave := {SH1->(IndexOrd()), SH1->(RecNo()), Alias()}
Local cRet  := ""
dbSelectArea("SH1")
dbSetOrder(1)
If dbSeek(xFilial("SH1") + cRecurso)
	cRet := SH1->H1_LINHAPR
Endif
dbSetOrder(  aSave[1])
dbGoto(      aSave[2])
dbSelectArea(aSave[3])
Return(cRet)	

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690NAl        � Autor � Robson Bueno     � Data �09/12/2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna ou seta OP como NAO alocada                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cOp    : OP a retornar ou setar                            ���
���          � lInclui: Se .T. inclui a OP na lista das NAO alocadas      ���
���          � lReseta: Reseta variaveis STATICs                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP       �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690NAl(cOp, lInclui, lReseta)
Static  aOps    := {}
Local   nSeek   := 0
Default lInclui := .F.
Default lReseta := .F.

If lReseta
	aOps := {}
	Return(.T.)
Endif

nSeek := aScan(aOps, cOp)

If lInclui .And. nSeek == 0
	Aadd(aOps, cOp)
	Return(.F.)
Else
	Return(nSeek > 0)
Endif

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690IsBt       � Autor �Erike Y. da Silva � Data �27/04/2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna variavel static que indica se o processamento esta ���
���          � sendo executado em batch ou nao usando lBat e IsBlind()    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690?     �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690IsBt()
Return lIsBatch

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690SupG       � Autor �Erike Y. da Silva � Data �16/05/2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna variavel static com o valor do setup atual, caso   ���
���          � exista.                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690?     �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690SupG(nSetup)	
Return __nSetupAt := If(nSetup==NIL,__nSetupAt,nSetup)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690Mtr        � Autor �Microsiga         � Data �17/12/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria Regua de processamento para a visualizacao do Carga   ���
���          � Maquina.                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690?                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690Mtr(oCenterPanel)
Local oButMeter

@ 45,030 TO 100,320 LABEL "Executa Visualiza��o" OF oCenterPanel  PIXEL //"Executa Visualiza��o"
@ 65,050 METER oRegua VAR nRegua TOTAL nTotRegua SIZE 251,8 OF oCenterPanel NOPERCENTAGE PIXEL
bBlock := {|| oRegua:Set(++nRegua),SysRefresh()}
DEFINE SBUTTON oButMeter FROM 80,050 TYPE 1 ACTION (oButMeter:lActive := .F., U_C690Vis(),U_C690ClSc(oButMeter)) ENABLE OF oCenterPanel PIXEL

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690ClSc       � Autor �Microsiga         � Data �17/12/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Limpa Objetos na Tela                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690?                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C690ClSc(oButton)

oButton:lActive := .T.
If (oRegua<>Nil)
	oRegua:Set(0)
EndIf
SysRefresh()

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690Rprt       � Autor �Microsiga         � Data �17/12/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa chamada do Relatorio                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CARMC690?                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C690Rprt(oCenterPanel)
Local oButReport

@ 45,030 TO 100,320 LABEL "Executa Relat�rio" OF oCenterPanel  PIXEL //"Executa Relat�rio"
DEFINE SBUTTON oButReport FROM 80,050 TYPE 1 ACTION (oButReport:lActive := .F., U_C690Relt(),U_C690ClSc(oButReport)) ENABLE OF oCenterPanel PIXEL

Return Nil    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C690FNum    � Autor � Anieli Rodrigues    � Data � 12.08.   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao utilizada para converter as filiais com codigo      ���
���          � caracter para codigo numerico /  GESTAO DE EMPRESAS        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo da Filial                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA330                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C690FNum(cFil)
Local aAreaAnt  := GetArea()
Local aAreaSM0  := SM0->(GetArea())
Local nRet      := Val(cFil)
Local cSeek     := ''
Local nContador := 100

If cFil > '99' .or. nRet > 99
	dbSelectArea("SM0")
	dbSetOrder(1)
	dbSeek(cSeek:=FWGrpCompany())
	Do While !Eof() .And. cSeek == SM0->M0_CODIGO
		If AllTrim(cFil) == AllTrim(SM0->M0_CODFIL)
			nRet := nContador
			Exit		
		EndIf
		nContador++
		dbSkip()	
	EndDo
EndIf	

RestArea(aAreaSM0)
RestArea(aAreaAnt)             
Return nRet     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CarregaCT �Michele Girardi             �Data	|26/11/2013   ���
�������������������������������������������������������������������������͹��
���Uso       � CARMC690                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function C690CrCT(cNRecurso)

Local cCTrab 

if mv_par31 == 1
     Return Nil
EndIf

dbSelectArea("SH1")
dbSetOrder(1)
DbSeek(xFilial("SH1")+cNRecurso)

if !Empty(SH1->H1_CTRAB)
	cCTrab := SH1->H1_CTRAB
	Return cCTrab	
EndIf

return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AjustaSX1 �Autor�A�cio Ferreira Gomes  �Data	|23/09/2009   ���
�������������������������������������������������������������������������͹��
���Uso       � CARMC690                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AjustaSX1()

Local cString :=""
Local cChave  :="" 

Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}

/*---------------Parametro Considera CT recurso---------------*/
Aadd( aHelpPor, "Indica se ser� considerado o centro de  " )
Aadd( aHelpPor, "trabalho do recurso ou da opera��o.     " )


PutSx1( "MTC690","31","Considera centro de trabalho?","","","mv_chv",;
		"N",1,0,1,"C","","","","","mv_par31","Opera��o","","","","Recurso","","","","","","","","","","","",;
		aHelpPor,aHelpEng,aHelpSpa)
/*---------------Parametro Considera CT recurso---------------*/			


DbselectArea("SX1")
DbSeek("MTC690",.F.)
While (!Eof() .and. Alltrim(X1_GRUPO) == "MTC690" )
cChave := Alltrim(X1_GRUPO)+X1_ORDEM
RecLock("SX1",.F.)
	If cChave == "MTC69001"
		cString := "Pelo Inicio"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69003"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69004"
		cString := "Ordem Produ��o"
		Replace X1_DEF01 With OEMToANSI(cString)
		cString := "Opera��o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69005"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69006"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69019"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69020"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69022"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69023"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69024"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69027"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	ElseIf cChave == "MTC69028"
		cString := "N�o"
		Replace X1_DEF02 With OEMToANSI(cString)
	EndIf
MsUnlock()
DbSkip()	
End
    
          
Return			



