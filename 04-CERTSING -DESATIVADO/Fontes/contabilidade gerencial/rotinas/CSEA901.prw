#INCLUDE "protheus.ch"
#INCLUDE "CSEA901.ch"
#INCLUDE "apwizard.ch"  
#INCLUDE 'FWBROWSE.CH'

#DEFINE USAPADRAO .T. 
/*/


š„„„„„„„„„„‚„„„„„„„„„„„„‚„„„„„„„‚„„„„„„„„„„„„„„„„„„„„„„„„„„„„‚„„„„„„‚„„„„„„„„„„¿
³Funcao    ³ CSEA901    ³ Autor ³ -------------------------- ³ Data ³ 25/11/13 ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Descri§£o ³ Wizard para criacao dos campos de utilizacao das entidades conta- ³
³          ³ beis nos modulos do ERP                                           ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Uso       ³ ATUALIZACAO SIGACTB                                               ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Parametros³ Nenhum                                                            ³
€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™


/*/
User Function CSEA901()

Local aSM0			:= {}

Private	cFirstEmp	:= ""
Private	cArqEmp		:= "SigaMat.Emp"
Private	nModulo		:= 34
Private	__cInterNet	:= Nil
Private nQtdEntid 	:= 1
Private nEntidIni 	:= 0
Private oMainWnd
Private cUserName 	:= ""
Private oGetDados

Private lChkRefaz	:= .F.
Private lChkATF		:= .T.
Private lChkCOM		:= .T.
Private lChkCTB		:= .T.
Private lChkEST		:= .T.
Private lChkFAT		:= .T.
Private lChkFIN		:= .T.
Private lChkGCT		:= .T.
Private lChkPCO		:= .T.
Private lMaxEnt		:= .F.

Private cMens		:=	STR0002 + CRLF +;	// "Esta rotina ira atualizar os dicionarios de dados"
						STR0003 + CRLF +;	// "para a utilizacao de novas entidades."
						STR0004 + CRLF +;	// "E importante realizar um backup completo dos dicionarios e base de dados, "
						STR0005 + CRLF +;	// "antes da execu§£o desta rotina."
						STR0006				// "Nao deve existir usuarios utilizando o sistema durante a atualizacao!"

Private cMessage
Private aArqUpd		:= {}
Private aREOPEN		:= {}
Private __lPyme		:= .F.
Private oWizard

#IFDEF TOP
	TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
#ENDIF

Set Dele On
If !ENTOpenSm0()
	Return(.F.)
EndIf

DbGoTop()

aSM0 := AdmAbreSM0()

RpcSetType(3)
RpcSetEnv( aSM0[1][1], aSM0[1][2] )
OpenSm0Excl()

//Habilita mensagem 
__cInterNet := ""

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Verifica quantas entidades j¡ existem no ambiente ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
IF (nEntidIni := GETMAXENT()) == 0 //Valida§£o para caso n£o consiga obter acesso a tabela
	Return .F.
ElseIf nEntidIni > 9
	lMaxEnt := .T.
EndIf

dbSelectArea("SXB")
dbSetOrder(1)
If !MsSeek(Padr('CT0SX3', Len(SXB->XB_ALIAS)))
	MsgInfo(STR0065, STR0001)  // "Ambiente do Ativo Fixo desatualizado, executar o U_UPDCTB" ###, "Atencao !"
	Return .F.
EndIf

dbSelectArea("SX3")
dbSetOrder(2)
If !MsSeek("CT0_ENTIDA") .Or. Alltrim(SX3->X3_WHEN)=="!(M->CT0_ID $ '01|02|03|04')"
	MsgInfo(STR0065, STR0001)  // "Ambiente do CTB desatualizado, executar o U_UPDCTB" ###, "Atencao !"
	Return .F.
EndIf

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Painel 1 - Tela inicial do Wizard 		            ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
oWizard := APWizard():New(STR0008/*<chTitle>*/,; // "Configura§£o de Entidades"
STR0010/*<chMsg>*/, ""/*<cTitle>*/, ; // "Essa ferramenta ir¡ efetuar a manuten§£o nos campos e par¢metros para as novas configura§µes"
cMens + CRLF + STR0013, ; // "Vocª dever¡ escolher o nºmero de entidades que ser£o inclu­das e a partir de qual ser¡ efetuada a inclus£o"
{||.T.} /*<bNext>*/ ,;
{||.T.}/*<bFinish>*/,;
.F./*<.lPanel.>*/, , , /*<.lNoFirst.>*/)
//{||.T.}/*<bNext>*/ ,;

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Painel 2 - Defini§£o das Novas Entidades            ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
oWizard:NewPanel(STR0008/*<chTitle>*/,; //"Configura§£o de Entidades"
STR0014/*<chMsg>*/,; // "Assistente para configura§£o de novas entidades no sistema"
{||.T.}/*<bBack>*/,;
{||ENTWZVLP2()} /*<bNext>*/ ,;
{||.T.}/*<bFinish>*/,;
.T./*<.lPanel.>*/ ,;
{|| EntGetNum()}/*<bExecute>*/) //Montagem da tela

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Painel 3 - Descri§£o das Novas Entidades            ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
oWizard:NewPanel(STR0008/*<chTitle>*/,; //"Configura§£o de Entidades"
STR0014/*<chMsg>*/,; // "Assistente para configura§£o de novas entidades no sistema"
{||.T.}/*<bBack>*/,;
{||ENTWZVLP3()} /*<bNext>*/ ,;
{||.T.}/*<bFinish>*/,;
.T./*<.lPanel.>*/ ,;
{|| EntGetDesc() }/*<bExecute>*/)

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Painel 4 - Acompanhamento do Processo               ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
oWizard:NewPanel(STR0015/*<chTitle>*/,;  //"Processamento..."
""/*<chMsg>*/,;
{||.F.} /*<bBack>*/,;
{||.F.}/*<bNext>*/ ,;
{||.T.}/*<bFinish>*/,;
.T./*<.lPanel.>*/ ,;
{| lEnd| ENTWIZREGU(@lEnd)}/*<bExecute>*/)

oWizard:Activate( .T./*<.lCenter.>*/,;
{||.T.}/*<bValid>*/,;
{||.T.}/*<bInit>*/,;
{||.T.}/*<bWhen>*/)

Return(.F.)

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTWIZPROCºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Funcao  de processamento da gravacao dos arquivos          º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function ENTWizProc(lEnd)
Local cTexto   := ''
Local cFile    := ""
Local cMask    := STR0009 //"Arquivos Texto (*.TXT) |*.txt|"
Local nRecno   := 0
Local nX       := 0
Local nRecAtu
Local aAreaSM0
Local lAbriu
Local oPanel    := oWizard:oMPanel[oWizard:nPanel]
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0() 

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Abre os arquivos das empresas³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
aSM0 := AdmAbreSM0()
oProcess:SetRegua1( Len( aSM0 ) )

RpcClearEnv()
OpenSm0Excl()

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Realiza as altera§µes nos dicion¡rios de dados³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
For nInc := 1 To 1/*Len( aSM0 )*/
	RpcSetType(3)
	RpcSetEnv( aSM0[nInc][1], aSM0[nInc][2] )

	aArqUpd  := {}
	
	oProcess:IncRegua1( STR0011 + aSM0[nInc][1] + "/"+ STR0012 + aSM0[nInc][2] )  //"Empresa : "###"Filial : "
	
	cTexto += Replicate("-",128)+CRLF
	cTexto += STR0011 + aSM0[nInc][1] + "/" + STR0012 + aSM0[nInc][2] + "-" + aSM0[nInc][6] + CRLF //"Empresa : "###" Filial : "
	
	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//³Atualiza o grupo de campos    .³
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	cTexto += CT0AtuSXG()

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//³Atualiza campos jah existentes.³
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	cTexto += CT0AtuSX3()

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//³Atualiza o dicionario de dados.³
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	cTexto += (ENTWizSX3())

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//³Atualiza o folders de cadastros³
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	cTexto += CT0AtuSXA()
	
	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//³Atualiza o Indice           .³
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	cTexto += ENTAtuSIX()

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//³Atualiza as consultas padroes.³
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	cTexto += EntAtuSXB()

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//³Inclui entidade             .³
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	cTexto += ENTAtuCT0()
	/*
	__SetX31Mode(.F.) //oProcess:SetRegua2(Len(aArqUpd))
	For nX := 1 To Len(aArqUpd)
		lAbriu := .F.
		IncProc(STR0028+aArqUpd[nx]+"]") //"Atualizando estruturas. Aguarde... [" //oProcess:IncRegua2(STR0028+aArqUpd[nx]+"]")
		If Select(aArqUpd[nx])>0
			lAbriu := .T.
			dbSelecTArea(aArqUpd[nx])
			dbCloseArea()
		EndIf
		X31UpdTable(aArqUpd[nx])
		If __GetX31Error()
			Alert(__GetX31Trace())
			MsgInfo(STR0023+ aArqUpd[nx] + STR0024,STR0001) //"Ocorreu um erro desconhecido durante a atualizacao da tabela : "###". Verifique a integridade do dicionario e da tabela."###"Atencao!"
			cTexto += STR0026+aArqUpd[nx] +CRLF //"Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "
			
		ElseIf ! lAbriu
			If Select(aArqUpd[nx])>0
				dbSelectArea(aArqUpd[nx])
				dbCloseArea()
			Endif
		EndIf
	Next nX
	*/
	RpcClearEnv()
	OpenSm0Excl()
Next

RpcSetEnv(aSM0[1][1],aSM0[1][2],,,,, { "AE1" })

cTexto     := STR0027+CRLF+cTexto	//	"Log da atualizacao "
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)

DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 280,130 OF oPanel PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont
DEFINE SBUTTON FROM 122,250 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oPanel PIXEL //Salva e Apaga //"Salvar Como..."

Return(.T.)

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTWizSX3 ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Funcao  de processamento da gravacao do SX3                º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function ENTWizSX3()

Local aSX3		:= {}
Local aEstrut	:= {}
Local lSX3		:= .F.
Local cTexto	:= ''
Local cAlias	:= ''
Local nContEstr	:= 1
Local nContItem	:= 1
Local nX		:= 0
Local nY		:= 0
Local nZ		:= 0
Local nNumEntid	 := nEntidIni
Local cGrpNum	:= ""
Local cEntidNum	:= ""
Local aArea		:= GetArea()
Local aAreaSX3	:= SX3->(GetArea())
Local aDisp		:= {}
Local cOrdem	:= ""
Local aTabATF	:= {{lChkATF},; //Checklist ATF ou Refaz Campos
					{"SN3","SN4","SN7","SNG","SNM","SNN","SNQ","SNR","SNS","SNV","SNX","SNW","SNY","FNE","FNF","FNU"},;	//Tabelas
					{"N3" ,"N4" ,"N7" ,"NG" ,"NM" ,"NN" ,"NQ" ,"NR" ,"NS" ,"NV" ,"NX" ,"NW" ,"NY" ,"FNE","FNF","FNU"}}	//Inicial dos campos
					// AS TABELAS DO ATIVO NAO ENTRAM NA REGRA DE DEBITO/CREDITO
					
Local aTabCOM	:= {{lChkCOM},; //Checklist Compras ou Refaz Campos
					{"SC1","SC7","SCY","SD1","SDE","SCH","SCX"},;	//Tabelas
					{"C1" ,"C7" ,"CY" ,"D1" ,"DE" ,"CH","CX"}}	//Inicial dos campos
					
Local aTabCTB	:= {{lChkCTB},; //Checklist Contabilidade ou Refaz Campos
					{"CT2","CT9","CTJ","CTK","CTZ","CV3","CV4"},;	//Tabelas
					{"CT2","CT9","CTJ","CTK","CTZ","CV3","CV4"}}	//Inicial dos campos
					// AS TABELAS CV9, CVD, CW1, CW2, CW3 NAO ENTRAM NA REGRA DE DEBITO/CREDITO
					// CV9 -> REGRA ESPECIFICA
					// CVD -> SOMENTE CONTA E CENTRO DE CUSTO
					// CW1 -> SOMENTE UM CAMPO POR ENTIDADE (SOMENTE DEVE SER CRIADO SE A ROTINA CTBA276-277-278 FOR ADEQUADA)
					// CW2 -> FORMATOS DE CAMPOS ESPECIFICOS (SOMENTE DEVEM SER CRIADOS SE A ROTINA CTBA276-277-278 FOR ADEQUADA)
					// CW3 -> NAO NECESSITA
					
Local aTabEST	:= {{lChkEST},; //Checklist Estoque ou Refaz Campos
					{"SB1","SC2","SCP","SCQ","SD3","SDG"},;	//Tabelas
					{"B1" ,"C2","CP" ,"CQ" ,"D3" ,"DG" }}	//Inicial dos campos
					
Local aTabFAT	:= {{lChkFAT},;	//Checklist Faturamento ou Refaz Campos
					{"SD2","AGG","AGH"},;		//Tabelas
					{"D2" ,"AGG","AGH" }}		//Inicial dos campos      
					
Local aTabFIN	:= {{lChkFIN},; //Checklist Financeiro ou Refaz Campos
					{"SE1","SE2","SE3","SE5","SE7","SEA","SED","SEF","SEH","SET","SEU","SEZ"},;	//Tabelas
					{"E1" ,"E2" ,"E3" ,"E5" ,"E7" ,"EA" ,"ED" ,"EF" ,"EH" ,"ET" ,"EU" ,"EZ" }}	//Inicial dos campos
					
Local aTabGCT	:= {{lChkGCT},;	//Checklist Gestao de Contratos ou Refaz Campos
					{"CNB","CNE"},;				//Tabelas
					{"CNB","CNE"}}				//Inicial dos campos
					
Local aTabGeral	:= {{.T.},; //Geracao Padrao
					{"SA1","SA2","SA6"},;	//Tabelas
					{"A1" ,"A2" ,"A6" }}	//Inicial dos campos
					
Local aTabALL	:= {aTabCOM,aTabCTB,aTabEST,aTabFAT,aTabFIN,aTabGCT,aTabGeral} // O modulo do ativo nao deve criar os campos com a dupla de debito/credito. Os campos do ativo sao criados de forma diferenciada.
Local aColsGet	:= ACLONE(oGetDados:aCols)
Local aHeader	:= ACLONE(oGetDados:aHeader)
Local nPosPlano	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_ID"}) 
Local nPosGrupo	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_GRPSXG"})
Local nPosF3	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_F3ENTI"})
Local nPosAlias	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_ALIAS"})

Local cPlano
Local cF3
Local cAliasEnt

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Tratamento para respeitar as configuracoes do usuario na criacao dos campos               					³
//³																												³
//³Grupo de campos 01 --> Campos que exibem o nome da entidade contabil, sem concatenacao com outras informacoes³
//³Exemplo: Conta contabil																						³
//³Grupo de campos 02 --> Campos que exibem a entidade contabil relacionada a algum tipo de informacao          ³
//³Exemplo: Cta.Desp.Dep (conta de despesa de depreciacao)														³
//³																												³		
//³Estrutura aColsGet:																							³
//³aColsGet[nX][13]: Titulo dos campos do grupo 01 		(descricao direta da entidade)							³	
//³aColsGet[nX][14]: Titulo dos campos do grupo 02 		(mnemonico da entidade + outras informacoes)			³
//³aColsGet[nX][15]: Descricao dos campos do grupo 01 	(descricao direta da entidade)							³
//³aColsGet[nX][16]: Descricao dos campos do grupo 02	(mnemonico da entidade + outras informacoes)			³
//³aColsGet[nX][17]: Help padrao para o campo																	³
//³aColsGet[nX][18]: Tamanho para criacao dos campos															³
//³																												³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Variaveis criadas como private para simplificar a sintaxe da chamada da    ³
//³funcao retorna as informacoes de titulos, descricao e help para uso no aSX3³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Carrega os arrays contendo os campos classificados como grupos 01 e 02     ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
Private _aGrpCpos	:= CSE901Cpos(Len(aColsGet),aColsGet[1][nPosPlano])

aEstrut := {"X3_ARQUIVO"	,"X3_ORDEM"		,"X3_CAMPO"		,"X3_TIPO"		,"X3_TAMANHO"	,"X3_DECIMAL"	,"X3_TITULO"	,"X3_TITSPA"	,"X3_TITENG"	,;
			"X3_DESCRIC"	,"X3_DESCSPA"	,"X3_DESCENG"	,"X3_PICTURE"	,"X3_VALID"		,"X3_USADO"		,"X3_RELACAO"	,"X3_F3"		,"X3_NIVEL"		,;
			"X3_RESERV"		,"X3_CHECK"		,"X3_TRIGGER"	,"X3_PROPRI"	,"X3_BROWSE"	,"X3_VISUAL"	,"X3_CONTEXT"	,"X3_OBRIGAT"	,"X3_VLDUSER"	,;
			"X3_CBOX"		,"X3_CBOXSPA"	,"X3_CBOXENG"	,"X3_PICTVAR"	,"X3_WHEN"		,"X3_INIBRW"	,"X3_GRPSXG"	,"X3_FOLDER"	,"X3_PYME"		}

For nX := 1 To Len(aColsGet) //La§o - Quantidade de entidades.

	cEntidNum	:= AllTrim(aColsGet[nX][nPosPlano]) //Numero corrente da entidade
	cGrpNum		:= aColsGet[nX][nPosGrupo]
	cF3			:= aColsGet[nX][nPosF3]
	cAliasEnt	:= aColsGet[nX][nPosAlias]

	//------------------------------------------
	// Campos padroes da contabilidade - INICIO
	//------------------------------------------
	//------------------------------------------
	// Funcao CSE901INFO(cCampo, nEntidade, nOpc)
	// nOpc	: 1 - Nome reduzido da entidade (04-12 caracteres)
	//		: 2 - Nome completo da entidade (12-25 caracteres)
	//		: 3 - Help padrao para a entidade
	//------------------------------------------
	//------------------------------------------
	
	Aadd(aSX3,{"CT1","00","CT1_ACET"+cEntidNum		,"C",1,0,"Aceita "+CSE901Info("CT1_ACET"+cEntidNum,nX,1)+"?"	,"Acepta "+CSE901Info("CT1_ACET"+cEntidNum,nX,1)+"?"	,"Accept "+CSE901Info("CT1_ACET"+cEntidNum,nX,1)+"?"	,"Aceita "+CSE901Info("CT1_ACET"+cEntidNum,nX,2)+"?" 	   		,"Acepta "+CSE901Info("CT1_ACET"+cEntidNum,nX,2)+"?"			,"Accept "+CSE901Info("CT1_ACET"+cEntidNum,nX,2)+"?"		,"@!","Pertence('12')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","'2'","",1,"€ €","","","S","N","A","R","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","S"})
	Aadd(aSX3,{"CT1","00","CT1_"+cEntidNum+"OBRG"	,"C",1,0,"Obrg."+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,1)+"?"	,"Oblig"+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,1)+"?"	,"Mand."+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,1)+"?"	,"Obrigat³ria "+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,2)+"?"	,"Obligat³ria "+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,2)+"?"	,"Mandatory "+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,2)+"?"	,"@!","Pertence('12')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","'2'","",1,"€ €","","","S","N","A","R","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","S"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe se a entidade "+CSE901Info("CT1_ACET"+cEntidNum,nX,2),;
				 "sera aceita no lancamento."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe se a entidade "+CSE901Info("CT1_ACET"+cEntidNum,nX,2),;
				 "sera aceita no lancamento."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe se a entidade "+CSE901Info("CT1_ACET"+cEntidNum,nX,2),;
				 "sera aceita no lancamento."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCT1_ACET"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe se a entidade "+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,2),;
				 "sera obrigatoria no lancamento"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe se a entidade "+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,2),;
				 "sera obrigatoria no lancamento"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe se a entidade "+CSE901Info("CT1_"+cEntidNum+"OBRG",nX,2),;
				 "sera obrigatoria no lancamento"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCT1_"+cEntidNum+"OBRG", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CT5","00","CT5_EC"+cEntidNum+"DB","C",200,0,CSE901Info("CT5_EC"+cEntidNum+"DB",nX,1)+"Debito"	,CSE901Info("CT5_EC"+cEntidNum+"DB",nX,1)+"Debito"	,CSE901Info("CT5_EC"+cEntidNum+"DB",nX,1)+"Debito"	,CSE901Info("CT5_EC"+cEntidNum+"DB",nX,2)+" Debito"		,CSE901Info("CT5_EC"+cEntidNum+"DB",nX,2)+" Debito"		,CSE901Info("CT5_EC"+cEntidNum+"DB",nX,2)+" Debito"		,"@!","Vazio() .Or. Ctb080Form()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","","","747","S"})
	Aadd(aSX3,{"CT5","00","CT5_EC"+cEntidNum+"CR","C",200,0,CSE901Info("CT5_EC"+cEntidNum+"CR",nX,1)+"Credito",CSE901Info("CT5_EC"+cEntidNum+"CR",nX,1)+"Credito"	,CSE901Info("CT5_EC"+cEntidNum+"CR",nX,1)+"Credito"	,CSE901Info("CT5_EC"+cEntidNum+"CR",nX,2)+" Credito"	,CSE901Info("CT5_EC"+cEntidNum+"CR",nX,2)+" Credito"	,CSE901Info("CT5_EC"+cEntidNum+"CR",nX,2)+" Credito"	,"@!","Vazio() .Or. Ctb080Form()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","","","747","S"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe "+CSE901Info("CT5_EC"+cEntidNum+"DB",nX,2)+" D©bito."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe "+CSE901Info("CT5_EC"+cEntidNum+"DB",nX,2)+" D©bito."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe "+CSE901Info("CT5_EC"+cEntidNum+"DB",nX,2)+" D©bito."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCT5_EC"+cEntidNum+"DB", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe "+CSE901Info("CT5_EC"+cEntidNum+"CR",nX,2)+" Credito."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe "+CSE901Info("CT5_EC"+cEntidNum+"CR",nX,2)+" Credito."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE 
	aPHelpEng := {"Informe "+CSE901Info("CT5_EC"+cEntidNum+"CR",nX,2)+" Credito."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCT5_EC"+cEntidNum+"CR", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CVX","00","CVX_NIV"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CVX_NIV"+cEntidNum,nX,1),CSE901Info("CVX_NIV"+cEntidNum,nX,1),CSE901Info("CVX_NIV"+cEntidNum,nX,1),CSE901Info("CVX_NIV"+cEntidNum,nX,2),CSE901Info("CVX_NIV"+cEntidNum,nX,2),CSE901Info("CVX_NIV"+cEntidNum,nX,2),"@!","","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","","",1,"€ €","","","","","","","","","","","","","","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe N­vel " + cEntidNum 	+ ": ",CSE901Info("CVX_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe N­vel " + cEntidNum 	+ ": ",CSE901Info("CVX_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe N­vel " + cEntidNum 	+ ": ",CSE901Info("CVX_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCVX_NIV"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CVY","00","CVY_NIV"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CVY_NIV"+cEntidNum,nX,1),CSE901Info("CVY_NIV"+cEntidNum,nX,1),CSE901Info("CVY_NIV"+cEntidNum,nX,1),CSE901Info("CVY_NIV"+cEntidNum,nX,2),CSE901Info("CVY_NIV"+cEntidNum,nX,2),CSE901Info("CVY_NIV"+cEntidNum,nX,2),"@!","","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","","",1,"€ €","","","","","","","","","","","","","","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe N­vel " + cEntidNum 	+ ": ",CSE901Info("CVY_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe N­vel " + cEntidNum 	+ ": ",CSE901Info("CVY_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe N­vel " + cEntidNum 	+ ": ",CSE901Info("CVY_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCVY_NIV"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CVZ","00","CVZ_NIV"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CVZ_NIV"+cEntidNum,nX,1),CSE901Info("CVZ_NIV"+cEntidNum,nX,1),CSE901Info("CVZ_NIV"+cEntidNum,nX,1),CSE901Info("CVZ_NIV"+cEntidNum,nX,2),CSE901Info("CVZ_NIV"+cEntidNum,nX,2),CSE901Info("CVZ_NIV"+cEntidNum,nX,2),"@!","","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","","",1,"€ €","","","","","","","","","","","","","","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe N­vel " + cEntidNum	+ ": "+CSE901Info("CVZ_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe N­vel " + cEntidNum	+ ": "+CSE901Info("CVZ_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe N­vel " + cEntidNum	+ ": "+CSE901Info("CVZ_NIV"+cEntidNum,nX,2)} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCVZ_NIV"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CTB","00","CTB_E"+cEntidNum+"DES","C",TamSXG(cGrpNum)[1],0,CSE901Info("CTB_E"+cEntidNum+"DES",nX,1)+"Dest."	,CSE901Info("CTB_E"+cEntidNum+"DES",nX,1)+"Dest."	,CSE901Info("CTB_E"+cEntidNum+"DES",nX,1)+"Dest."	,CSE901Info("CTB_E"+cEntidNum+"DES",nX,2)+" Destino"		,CSE901Info("CTB_E"+cEntidNum+"DES",nX,2)+" Destino" 		,CSE901Info("CTB_E"+cEntidNum+"DES",nX,2)+" Destino" 		,"@!",""							,"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬","",cF3,1,"ï¿½‚¬"	,"","","","S","","","","","","","","",""										,"",cGrpNum,"","N"})
	Aadd(aSX3,{"CTB","00","CTB_E"+cEntidNum+"INI","C",TamSXG(cGrpNum)[1],0,CSE901Info("CTB_E"+cEntidNum+"INI",nX,1)+"Ini."	,CSE901Info("CTB_E"+cEntidNum+"INI",nX,1)+"Ini."	,CSE901Info("CTB_E"+cEntidNum+"INI",nX,1)+"Ini."	,CSE901Info("CTB_E"+cEntidNum+"INI",nX,2)+" Inicial Origem"	,CSE901Info("CTB_E"+cEntidNum+"INI",nX,2)+" Inicial Origem"	,CSE901Info("CTB_E"+cEntidNum+"INI",nX,2)+" Inicial Origem"	,"@!","Vazio() .Or. CtbEntExis()"	,"‚¬‚¬‚¬‚¬€š‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬","",cF3,1,"€™€","","","","S","","","","","","","","",'TrocaF3("'+cAliasEnt+'","'+cEntidNum+'")'	,"",cGrpNum,"","N"})
	Aadd(aSX3,{"CTB","00","CTB_E"+cEntidNum+"FIM","C",TamSXG(cGrpNum)[1],0,CSE901Info("CTB_E"+cEntidNum+"FIM",nX,1)+"Fim"		,CSE901Info("CTB_E"+cEntidNum+"FIM",nX,1)+"Fim"		,CSE901Info("CTB_E"+cEntidNum+"FIM",nX,1)+"Fim"		,CSE901Info("CTB_E"+cEntidNum+"FIM",nX,2)+" Final Origem"	,CSE901Info("CTB_E"+cEntidNum+"FIM",nX,2)+" Final Origem"	,CSE901Info("CTB_E"+cEntidNum+"FIM",nX,2)+" Final Origem"	,"@!","Vazio() .Or. CtbEntExis()"	,"‚¬‚¬‚¬‚¬€š‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬","",cF3,1,"€™€","","","","S","","","","","","","","",'TrocaF3("'+cAliasEnt+'", "'+cEntidNum+'")'	,"",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"DES",nX,2)+ " Destino."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"DES",nX,2)+ " Destino."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"DES",nX,2)+ " Destino."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTB_E"+cEntidNum+"DES", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"INI",nX,2)+" Inicial Origem."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"INI",nX,2)+" Inicial Origem."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"INI",nX,2)+" Inicial Origem."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTB_E"+cEntidNum+"INI", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"FIM",nX,2)+" Inicial Origem."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"FIM",nX,2)+" Inicial Origem."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe "+CSE901Info("CTB_E"+cEntidNum+"FIM",nX,2)+" Inicial Origem."}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTB_E"+cEntidNum+"FIM", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CTQ","00","CTQ_E"+cEntidNum+"ORI"	,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,1)+"Ori"	,CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,1)+"Ori" ,CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,1)+"Ori" ,CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2)+" Origem"			,CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2)+" Origem"			,CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2)+" Origem"			,"@!","CtbEntExis()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"©+","","","","N","","","","","","","","","","",cGrpNum,"","N"})
	Aadd(aSX3,{"CTQ","00","CTQ_E"+cEntidNum+"PAR"	,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,1)+"Part"	,CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,1)+"Part",CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,1)+"Part",CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2)+" Partida"			,CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2)+" Partida"		,CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2)+" Partida"		,"@!","CtbEntExis()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"©+","","","","N","","","","","","","","","","",cGrpNum,"","N"})
	Aadd(aSX3,{"CTQ","00","CTQ_E"+cEntidNum+"CP"	,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CTQ_E"+cEntidNum+"CP",nX,1) +"CPar"	,CSE901Info("CTQ_E"+cEntidNum+"CP",nX,1) +"CPar",CSE901Info("CTQ_E"+cEntidNum+"CP",nX,1) +"CPar",CSE901Info("CTQ_E"+cEntidNum+"CP",nX,2) +" Contra-Partida"	,CSE901Info("CTQ_E"+cEntidNum+"CP",nX,2) +" Contra-Partida"	,CSE901Info("CTQ_E"+cEntidNum+"CP",nX,2) +" Contra-Partida"	,"@!","CtbEntExis()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"¥+","","","","N","","","","","","","","","","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2)+" Origem."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2)+" Origem."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2)+" Origem."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTQ_E"+cEntidNum+"ORI", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aHelpPor := {	"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2),;   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	 			 	"Origem para obter o valor a ser rateado."}
	aHelpEsp := {	"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2),;   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	 			 	"Origem para obter o valor a ser rateado."}
	aHelpEng := {	"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"ORI",nX,2),;   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	 			 	"Origem para obter o valor a ser rateado."}
	PutHelp("PCCTQ_E"+cEntidNum+"ORI", aHelpPor,aHelpEng,aHelpEsp,.T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2)+" Partida."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2)+" Partida."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2)+" Partida."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTQ_E"+cEntidNum+"PAR", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aHelpPor := {"Neste campo dever¡ ser informado"	,"a Entidade " + CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2) + " a ser"	,"Debitada/Creditada na gera§£o","dos lan§amentos de rateio."		,"Ser¡ Debitada/Creditada dependendo da"	,"Natureza do saldo resultante."		,"Se o Valor for devedor o Lan§amento"	,"ser¡ Credor e vice-versa.","Tecla <F3> disponivel para consulta"			,"do Cadastro de Entidade " + CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2) + "."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aHelpEsp := {"Neste campo dever¡ ser informado"	,"a Entidade " + CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2) + " a ser"	,"Debitada/Creditada na gera§£o","dos lan§amentos de rateio."		,"Ser¡ Debitada/Creditada dependendo da"	,"Natureza do saldo resultante."		,"Se o Valor for devedor o Lan§amento"	,"ser¡ Credor e vice-versa.","Tecla <F3> disponivel para consulta"			,"do Cadastro de Entidade " + CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2) + "."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aHelpEng := {"Neste campo dever¡ ser informado"	,"a Entidade " + CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2) + " a ser"	,"Debitada/Creditada na gera§£o","dos lan§amentos de rateio."		,"Ser¡ Debitada/Creditada dependendo da"	,"Natureza do saldo resultante."		,"Se o Valor for devedor o Lan§amento"	,"ser¡ Credor e vice-versa.","Tecla <F3> disponivel para consulta"			,"do Cadastro de Entidade " + CSE901Info("CTQ_E"+cEntidNum+"PAR",nX,2) + "."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCCTQ_E"+cEntidNum+"PAR", aHelpPor,aHelpEng,aHelpEsp,.T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"CP",nX,2)+" Contra-partida."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"CP",nX,2)+" Contra-partida."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe a Entidade "+CSE901Info("CTQ_E"+cEntidNum+"CP",nX,2)+" Contra-partida."}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTQ_E"+cEntidNum+"CP", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CV9","00","CV9_E"+cEntidNum+"ORI"	,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CV9_E"+cEntidNum+"ORI",nX,1)+"Ori"	,CSE901Info("CV9_E"+cEntidNum+"ORI",nX,1)+"Ori"		,CSE901Info("CV9_E"+cEntidNum+"ORI",nX,1)+"Ori"		,CSE901Info("CV9_E"+cEntidNum+"ORI",nX,2)+" Origem"			,CSE901Info("CV9_E"+cEntidNum+"ORI",nX,2)+" Origem"			,CSE901Info("CV9_E"+cEntidNum+"ORI",nX,2)+" Origem"			,"@!","","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"¥+","","","","S","","","","","","","","","","",cGrpNum,"","N"})
	Aadd(aSX3,{"CV9","00","CV9_E"+cEntidNum+"PAR"	,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CV9_E"+cEntidNum+"PAR",nX,1)+"Part"	,CSE901Info("CV9_E"+cEntidNum+"PAR",nX,1)+"Part"	,CSE901Info("CV9_E"+cEntidNum+"PAR",nX,1)+"Part"	,CSE901Info("CV9_E"+cEntidNum+"PAR",nX,2)+" Partida"		,CSE901Info("CV9_E"+cEntidNum+"PAR",nX,2)+" Partida"		,CSE901Info("CV9_E"+cEntidNum+"PAR",nX,2)+" Partida"		,"@!","","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"¥+","","","","S","","","","","","","","","","",cGrpNum,"","N"})
	Aadd(aSX3,{"CV9","00","CV9_E"+cEntidNum+"CP"	,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CV9_E"+cEntidNum+"CP" ,nX,1)+"CPar"	,CSE901Info("CV9_E"+cEntidNum+"CP" ,nX,1)+"CPar"	,CSE901Info("CV9_E"+cEntidNum+"CP" ,nX,1)+"CPar"	,CSE901Info("CV9_E"+cEntidNum+"CP" ,nX,2)+" Contra-Partida"	,CSE901Info("CV9_E"+cEntidNum+"CP" ,nX,2)+" Contra-Partida"	,CSE901Info("CV9_E"+cEntidNum+"CP" ,nX,2)+" Contra-Partida"	,"@!","","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"¥+","","","","S","","","","","","","","","","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"ORI",nX,2) + " Origem."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"ORI",nX,2) + " Origem."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"ORI",nX,2) + " Origem."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV9_E"+cEntidNum+"ORI", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"PAR",nX,2) + " Partida."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"PAR",nX,2) + " Partida."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"PAR",nX,2) + " Partida."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV9_E"+cEntidNum+"PAR", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"CP",nX,2) + " Contra-partida."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"CP",nX,2) + " Contra-partida."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV9_E"+cEntidNum+"CP",nX,2) + " Contra-partida."} 		// HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV9_E"+cEntidNum+"CP", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CV5","00","CV5_E"+cEntidNum+"ORI","C",TamSXG(cGrpNum)[1]	,0,CSE901Info("CV5_E"+cEntidNum+"ORI",nX,1)+"Orig.",CSE901Info("CV5_E"+cEntidNum+"ORI",nX,1)+"Orig."	,CSE901Info("CV5_E"+cEntidNum+"ORI",nX,1)+"Orig."	,CSE901Info("CV5_E"+cEntidNum+"ORI",nX,2)+" Origem"			,CSE901Info("CV5_E"+cEntidNum+"ORI",nX,2)+" Origem"			,CSE901Info("CV5_E"+cEntidNum+"ORI",nX,2)+" Origem"			,"@!"	,"CtbEntExis()"	,"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3	,1,"¦+","","","","S","A","R","","","","","","",""										,"",cGrpNum	,"","N"})
	Aadd(aSX3,{"CV5","00","CV5_E"+cEntidNum+"FIM","C",TamSXG(cGrpNum)[1]	,0,CSE901Info("CV5_E"+cEntidNum+"FIM",nX,1)+"Fin."	,CSE901Info("CV5_E"+cEntidNum+"FIM",nX,1)+"Fin."	,CSE901Info("CV5_E"+cEntidNum+"FIM",nX,1)+"Fin."	,CSE901Info("CV5_E"+cEntidNum+"FIM",nX,2)+" Orig. Fin"		,CSE901Info("CV5_E"+cEntidNum+"FIM",nX,2)+" Orig. Fin"		,CSE901Info("CV5_E"+cEntidNum+"FIM",nX,2)+" Orig. Fin"		,"@!"	,""				,"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3	,1,"¦+","","","","S","A","R","","","","","","",""										,"",cGrpNum	,"","N"})
	Aadd(aSX3,{"CV5","00","CV5_E"+cEntidNum+"DES","C",TamSXG(cGrpNum)[1]	,0,CSE901Info("CV5_E"+cEntidNum+"DES",nX,1)+"Dest.",CSE901Info("CV5_E"+cEntidNum+"DES",nX,1)+"Dest."	,CSE901Info("CV5_E"+cEntidNum+"DES",nX,1)+"Dest."	,CSE901Info("CV5_E"+cEntidNum+"DES",nX,2)+" Destino"		,CSE901Info("CV5_E"+cEntidNum+"DES",nX,2)+" Destino"		,CSE901Info("CV5_E"+cEntidNum+"DES",nX,2)+" Destino"		,"@!"	,"CtbEntExis()"	,"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3	,1,"¦+","","","","S","A","R","","","","","","","CtbOpCad(M->CV5_EMPDES,M->CV5_FILDES)"	,"",cGrpNum	,"","N"})
	Aadd(aSX3,{"CV5","00","CV5_E"+cEntidNum+"IGU","C",1						,0,CSE901Info("CV5_E"+cEntidNum+"IGU",nX,1)+"Igual",CSE901Info("CV5_E"+cEntidNum+"IGU",nX,1)+"Igual"	,CSE901Info("CV5_E"+cEntidNum+"IGU",nX,1)+"Igual"	,CSE901Info("CV5_E"+cEntidNum+"IGU",nX,2)+" Igual Origem"	,CSE901Info("CV5_E"+cEntidNum+"IGU",nX,2)+" Igual Origem"	,CSE901Info("CV5_E"+cEntidNum+"IGU",nX,2)+" Igual Origem"	,""		,""				,"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",""	,1,"¦+","","","",""	,""	,""	,"","","","","","",""										,"",""		,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"ORI",nX,2) + " Origem."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"ORI",nX,2) + " Origem."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"ORI",nX,2) + " Origem."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV5_E"+cEntidNum+"ORI", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"FIM",nX,2) + " Origem Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"FIM",nX,2) + " Origem Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"FIM",nX,2) + " Origem Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV5_E"+cEntidNum+"FIM", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"DES",nX,2) + " Destino."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"DES",nX,2) + " Destino."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"DES",nX,2) + " Destino."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV5_E"+cEntidNum+"DES", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"IGU",nX,2) + " Igual Origem."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"IGU",nX,2) + " Igual Origem."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV5_E"+cEntidNum+"IGU",nX,2) + " Igual Origem."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV5_E"+cEntidNum+"IGU", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CTA","00","CTA_ENTI"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,CSE901Info("CTA_ENTI"+cEntidNum,nX,1),CSE901Info("CTA_ENTI"+cEntidNum,nX,1),CSE901Info("CTA_ENTI"+cEntidNum,nX,1),CSE901Info("CTA_ENTI"+cEntidNum,nX,2),CSE901Info("CTA_ENTI"+cEntidNum,nX,2),CSE901Info("CTA_ENTI"+cEntidNum,nX,2),"","","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","","",1,"","","","","","","","","","","","","","","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {CSE901Info("CTA_ENTI"+cEntidNum,nX,3)}  // HELP PADRAO DA ENTIDADE
	aPHelpSpa := {CSE901Info("CTA_ENTI"+cEntidNum,nX,3)}  // HELP PADRAO DA ENTIDADE
	aPHelpEng := {CSE901Info("CTA_ENTI"+cEntidNum,nX,3)}  // HELP PADRAO DA ENTIDADE
	PutHelp("PCTA_ENTI"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CTS","00","CTS_E"+cEntidNum+"INI","C",TamSXG(cGrpNum)[1],0,CSE901Info("CTS_E"+cEntidNum+"INI",nX,1)+"Ini"		,CSE901Info("CTS_E"+cEntidNum+"INI",nX,1)+"Ini"		,CSE901Info("CTS_E"+cEntidNum+"INI",nX,1)+"Ini"		,CSE901Info("CTS_E"+cEntidNum+"INI",nX,2)+" Inicial"	,CSE901Info("CTS_E"+cEntidNum+"INI",nX,2)+" Inicial"	,CSE901Info("CTS_E"+cEntidNum+"INI",nX,2)+" Inicial"	,"@!","Vazio() .Or. CtbEntExis()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€š€","","","","S","","","","","","","","","","",cGrpNum,"","N"})
	Aadd(aSX3,{"CTS","00","CTS_E"+cEntidNum+"FIM","C",TamSXG(cGrpNum)[1],0,CSE901Info("CTS_E"+cEntidNum+"FIM",nX,1)+"Final"	,CSE901Info("CTS_E"+cEntidNum+"FIM",nX,1)+"Final"	,CSE901Info("CTS_E"+cEntidNum+"FIM",nX,1)+"Final"	,CSE901Info("CTS_E"+cEntidNum+"FIM",nX,2)+" Final"		,CSE901Info("CTS_E"+cEntidNum+"FIM",nX,2)+" Final"		,CSE901Info("CTS_E"+cEntidNum+"FIM",nX,2)+" Final"		,"@!","Vazio() .Or. CtbEntExis()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€š€","","","","S","","","","","","","","","","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CTS_E"+cEntidNum+"INI",nX,2) + " Inicial."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CTS_E"+cEntidNum+"INI",nX,2) + " Inicial."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CTS_E"+cEntidNum+"INI",nX,2) + " Inicial."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTS_E"+cEntidNum+"INI", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CTS_E"+cEntidNum+"FIM",nX,2) + " Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CTS_E"+cEntidNum+"FIM",nX,2) + " Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CTS_E"+cEntidNum+"FIM",nX,2) + " Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCTS_E"+cEntidNum+"FIM", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

	Aadd(aSX3,{"CV1","00","CV1_E"+cEntidNum+"INI","C",TamSXG(cGrpNum)[1],0,CSE901Info("CV1_E"+cEntidNum+"INI",nX,1)+"Ini"		,CSE901Info("CV1_E"+cEntidNum+"INI",nX,1)+"Ini"		,CSE901Info("CV1_E"+cEntidNum+"INI",nX,1)+"Ini"		,CSE901Info("CV1_E"+cEntidNum+"INI",nX,2)+" Inicial"	,CSE901Info("CV1_E"+cEntidNum+"INI",nX,2)+" Inicial"	,CSE901Info("CV1_E"+cEntidNum+"INI",nX,2)+" Inicial"	,"@!","Ctb390Vld()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ž€","","","","","","","","","","","","","CtbMovSaldo('CT0',,'"+cEntidNum+"')","",cGrpNum,"","N"})
	Aadd(aSX3,{"CV1","00","CV1_E"+cEntidNum+"FIM","C",TamSXG(cGrpNum)[1],0,CSE901Info("CV1_E"+cEntidNum+"FIM",nX,1)+"Final"	,CSE901Info("CV1_E"+cEntidNum+"FIM",nX,1)+"Final"	,CSE901Info("CV1_E"+cEntidNum+"FIM",nX,1)+"Final"	,CSE901Info("CV1_E"+cEntidNum+"FIM",nX,2)+" Final"		,CSE901Info("CV1_E"+cEntidNum+"FIM",nX,2)+" Final"		,CSE901Info("CV1_E"+cEntidNum+"FIM",nX,2)+" Final"		,"@!","Ctb390Vld()","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ž€","","","","","","","","","","","","","CtbMovSaldo('CT0',,'"+cEntidNum+"')","",cGrpNum,"","N"})

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV1_E"+cEntidNum+"INI",nX,2) + " Inicial."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV1_E"+cEntidNum+"INI",nX,2) + " Inicial."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV1_E"+cEntidNum+"INI",nX,2) + " Inicial."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV1_E"+cEntidNum+"INI", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				//1234567890123456789012345678901234567890 - 40 caracteres por linha
	aPHelpPor := {"Informe Entidade " + CSE901Info("CV1_E"+cEntidNum+"FIM",nX,2) + " Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpSpa := {"Informe Entidade " + CSE901Info("CV1_E"+cEntidNum+"FIM",nX,2) + " Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	aPHelpEng := {"Informe Entidade " + CSE901Info("CV1_E"+cEntidNum+"FIM",nX,2) + " Final."} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
	PutHelp("PCV1_E"+cEntidNum+"FIM", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)
	//------------------------------------------
	// Campos padroes da contabilidade - FIM
	//------------------------------------------

	//--------------------------------------------------------------
	// Campos Debito e Credito padroes para os modulos selecionados
	//--------------------------------------------------------------
	For nY := 1 To Len(aTabALL) //La§o - M³dulos selecionaveis

		If aTabALL[nY][1][1] == .T. //Valida§£o - M³dulo selecionado

			For nZ := 1 To Len(aTabAll[nY][2]) //La§o - Campos para gera§£o

				If AliasInDic(aTabALL[nY][2][nZ])

					Aadd(aSX3,{aTabALL[nY][2][nZ],"00",aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB","C",TamSXG(cGrpNum)[1],0, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,1)+"Deb."	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,1)+"Deb."	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,1)+"Deb."	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,2)+" Debito "	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,2)+" Debito "	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,2)+" Debito "	,"@!","CTB105EntC(,M->"+aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
					Aadd(aSX3,{aTabALL[nY][2][nZ],"00",aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"CR","C",TamSXG(cGrpNum)[1],0, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,1)+"Cred."	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,1)+"Cred."	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,1)+"Cred."	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,2)+" Credito "	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,2)+" Credito "	, CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,2)+" Credito "	,"@!","CTB105EntC(,M->"+aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"CR,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})

								//1234567890123456789012345678901234567890 - 40 caracteres por linha
					aPHelpPor := {CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,3)} // HELP PADRAO DA ENTIDADE
					aPHelpSpa := {CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,3)} // HELP PADRAO DA ENTIDADE
					aPHelpEng := {CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB",nX,3)} // HELP PADRAO DA ENTIDADE
					PutHelp("P"+aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"DB", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

								//1234567890123456789012345678901234567890 - 40 caracteres por linha
					aPHelpPor := {CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"CR",nX,3)} // HELP PADRAO DA ENTIDADE
					aPHelpSpa := {CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"CR",nX,3)} // HELP PADRAO DA ENTIDADE
					aPHelpEng := {CSE901Info(aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"CR",nX,3)} // HELP PADRAO DA ENTIDADE
					PutHelp("P"+aTabALL[nY][3][nZ]+"_EC"+cEntidNum+"CR", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				EndIf
			Next nZ
		EndIf
	Next nY

	//---------------------------
	// Campos especificos do PCO
	//---------------------------
	If lChkPCO
		Aadd(aSX3,{'AK2','00','AK2_ENT' + cEntidNum,'C',TamSXG(cGrpNum)[1],0	,CSE901Info('AK2_ENT' + cEntidNum,nX,1),CSE901Info('AK2_ENT' + cEntidNum,nX,1),CSE901Info('AK2_ENT' + cEntidNum,nX,1),CSE901Info('AK2_ENT' + cEntidNum,nX,2),CSE901Info('AK2_ENT' + cEntidNum,nX,2),CSE901Info('AK2_ENT' + cEntidNum,nX,2),'@!','Vazio() .Or. CTB105EntC(,M->AK2_ENT'+cEntidNum+',,"'+cEntidNum+'")','‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ','',cF3,1,Chr(150) + Chr(192),'','S','S','S','A','R','N','','','','','','','',cGrpNum,'','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('AK2_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('AK2_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('AK2_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PAK2_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

		Aadd(aSX3,{'AKC','00','AKC_ENT' + cEntidNum,'C',60,0					,CSE901Info('AKC_ENT' + cEntidNum,nX,1),CSE901Info('AKC_ENT' + cEntidNum,nX,1),CSE901Info('AKC_ENT' + cEntidNum,nX,1),CSE901Info('AKC_ENT' + cEntidNum,nX,2),CSE901Info('AKC_ENT' + cEntidNum,nX,2),CSE901Info('AKC_ENT' + cEntidNum,nX,2),'@!','PcoVldForm()','‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ','','CT0001',1,Chr(132) + Chr(128),'','','S','S','A','R','N','','','','','','','','','','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('AKC_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('AKC_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('AKC_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PAKC_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

		Aadd(aSX3,{'AKD','00','AKD_ENT' + cEntidNum,'C',TamSXG(cGrpNum)[1],0	,CSE901Info('AKD_ENT' + cEntidNum,nX,1),CSE901Info('AKD_ENT' + cEntidNum,nX,1),CSE901Info('AKD_ENT' + cEntidNum,nX,1),CSE901Info('AKD_ENT' + cEntidNum,nX,2),CSE901Info('AKD_ENT' + cEntidNum,nX,2),CSE901Info('AKD_ENT' + cEntidNum,nX,2),'@!','Vazio() .Or. CTB105EntC(,M->AKD_ENT'+cEntidNum+',,"'+cEntidNum+'")',"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ",'',cF3,1,Chr(150) + Chr(192),'','','S','S','A','R','N','','','','','','','',cGrpNum,'','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('AKD_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('AKD_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('AKD_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PAKD_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

		Aadd(aSX3,{'ALJ','00','ALJ_ENT' + cEntidNum,'C',TamSXG(cGrpNum)[1],0	,CSE901Info('ALJ_ENT' + cEntidNum,nX,1),CSE901Info('ALJ_ENT' + cEntidNum,nX,1),CSE901Info('ALJ_ENT' + cEntidNum,nX,1),CSE901Info('ALJ_ENT' + cEntidNum,nX,2),CSE901Info('ALJ_ENT' + cEntidNum,nX,2),CSE901Info('ALJ_ENT' + cEntidNum,nX,2),'@!','Vazio() .Or. CTB105EntC(,M->ALJ_ENT'+cEntidNum+',,"'+cEntidNum+'")',"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ",'',cF3,1,Chr(150) + Chr(192),'','','S','S','A','R','N','','','','','','','',cGrpNum,'','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('ALJ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('ALJ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('ALJ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PALJ_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

		Aadd(aSX3,{'AMJ','00','AMJ_ENT' + cEntidNum,'C',TamSXG(cGrpNum)[1],0	,CSE901Info('AMJ_ENT' + cEntidNum,nX,1),CSE901Info('AMJ_ENT' + cEntidNum,nX,1),CSE901Info('AMJ_ENT' + cEntidNum,nX,1),CSE901Info('AMJ_ENT' + cEntidNum,nX,2),CSE901Info('AMJ_ENT' + cEntidNum,nX,2),CSE901Info('AMJ_ENT' + cEntidNum,nX,2),'@!','Vazio() .Or. CTB105EntC(,M->AMJ_ENT'+cEntidNum+',,"'+cEntidNum+'")',"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ",'',cF3,1,Chr(150) + Chr(192),'','','S','S','A','R','N','','','','','','','',cGrpNum,'','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('AMJ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('AMJ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('AMJ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PAMJ_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

		Aadd(aSX3,{'AMK','00','AMK_ENT' + cEntidNum,'C',60,0					,CSE901Info('AMK_ENT' + cEntidNum,nX,1),CSE901Info('AMK_ENT' + cEntidNum,nX,1),CSE901Info('AMK_ENT' + cEntidNum,nX,1),CSE901Info('AMK_ENT' + cEntidNum,nX,2),CSE901Info('AMK_ENT' + cEntidNum,nX,2),CSE901Info('AMK_ENT' + cEntidNum,nX,2),'@!','PcoVldForm()','‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ','','CT0001',1,Chr(132) + Chr(128),'','','S','S','A','R','N','','','','','','','','','','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('AMK_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('AMK_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('AMK_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PAMK_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

		Aadd(aSX3,{'AKI','00','AKI_ENT' + cEntidNum,'C',60,0					,CSE901Info('AKI_ENT' + cEntidNum,nX,1),CSE901Info('AKI_ENT' + cEntidNum,nX,1),CSE901Info('AKI_ENT' + cEntidNum,nX,1),CSE901Info('AKI_ENT' + cEntidNum,nX,2),CSE901Info('AKI_ENT' + cEntidNum,nX,2),CSE901Info('AKI_ENT' + cEntidNum,nX,2),'@!','PcoVldForm()','‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ','','CT0001',1,Chr(134) + Chr(128),'','','S','S','A','R','N','','','','','','','','','','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('AKI_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('AKI_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('AKI_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PAKI_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

		Aadd(aSX3,{'AMZ','00','AMZ_ENT' + cEntidNum,'C',TamSXG(cGrpNum)[1],0	,CSE901Info('AMZ_ENT' + cEntidNum,nX,1),CSE901Info('AMZ_ENT' + cEntidNum,nX,1),CSE901Info('AMZ_ENT' + cEntidNum,nX,1),CSE901Info('AMZ_ENT' + cEntidNum,nX,2),CSE901Info('AMZ_ENT' + cEntidNum,nX,2),CSE901Info('AMZ_ENT' + cEntidNum,nX,2),'@!','Vazio() .Or. CTB105EntC(,M->AMZ_ENT'+cEntidNum+',,"'+cEntidNum+'")',"‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ",'',cF3,1,Chr(254) + Chr(192),'','','S','S','A','R','N','','','','','','','',cGrpNum,'','S'})
					//1234567890123456789012345678901234567890 - 40 caracteres por linha
		aPHelpPor := {CSE901Info('AMZ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpSpa := {CSE901Info('AMZ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		aPHelpEng := {CSE901Info('AMZ_ENT' + cEntidNum,nX,3)} // HELP PADRAO DA ENTIDADE
		PutHelp("PAMZ_ENT"+cEntidNum,aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	EndIf

	//------------------------------------------
	// Campos padroes do Ativo Fixo    - INICIO
	//------------------------------------------
	IF lChkATF

		For nY := 1 To Len(aTabATF[2]) //La§o - Tabelas atualizaveis dentro do modulo
	
			If AliasInDic(aTabATF[2][nY])

				DO CASE
				
					CASE aTabATF[2][nY] $ "SN3|SNG"

						//MODELO: N3_SUBCTA --> N3_ECxxCTA
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"CTA","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,1)+"Desp.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,1)+"Desp.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,1)+"Desp.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,2)+" Despesa.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,2)+" Despesa.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,2)+" Despesa.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"CTA,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,2)," de despesa"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,2)," de despesa"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CTA",nX,2)," de despesa"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"CTA", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)
	
						//MODELO: N3_SUBCCON --> N3_ECxxCON
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"CON","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)+" do bem.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"CON,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)," de classificacao do bem"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)," de classificacao do bem"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)," de classificacao do bem"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"CON", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: N3_SUBCDEP --> N3_ECxxDEP
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"DEP","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+" Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+" Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+" Desp.Depr.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"DEP,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de despesa de depreciacao"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de despesa de depreciacao"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de despesa de depreciacao"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"DEP", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: N3_SUBCCDE --> N3_ECxxCDE
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"CDE","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+" Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+" Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+" Depr.Acm.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"CDE,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"} // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"CDE", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: N3_SUBCDES  --> N3_ECxxDES
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"DES","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,1)+"Cr.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,1)+"Cr.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,1)+"Cr.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)+" Corr.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)+" Corr.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)+" Corr.Depr.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"DES,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)," de correcao de despesa de depreciacao"}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)," de correcao de despesa de depreciacao"}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)," de correcao de despesa de depreciacao"}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"DES", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: N3_SUBCCOR --> N3_ECxxCOR
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"COR","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,1)+"C.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,1)+"C.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,1)+"C.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)+" Corr.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)+" Corr.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)+" Corr.Bem","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"COR,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)," de correcao monetaria do bem"}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)," de correcao monetaria do bem"}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)," de correcao monetaria do bem"}  // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"COR", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)
					
					CASE aTabATF[2][nY] == "SNM"
	
						//MODELO: NM_ITBEM   --> NM_ECxxBEM
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"BEM","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,1)+"Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,1)+"Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,1)+"Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,2)+" do bem.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"BEM,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,2)," de classificacao do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,2)," de classificacao do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"BEM",nX,2)," de classificacao do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"BEM", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: NM_ITCORR  --> N3_ECxxCOR
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"COR","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,1)+"C.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,1)+"C.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,1)+"C.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)+" Corr.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)+" Corr.Bem",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)+" Corr.Bem","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"COR,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)," de correcao monetaria do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)," de correcao monetaria do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"COR",nX,2)," de correcao monetaria do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"COR", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: NM_ITDESP  --> NM_ECxxDSP
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"DSP","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,2)+" Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,2)+" Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,2)+" Desp.Depr.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"DSP,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,2)," de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,2)," de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DSP",nX,2)," de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"DSP", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: NM_ITCDEP  --> NM_ECxxDEP
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"DEP","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+" Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+" Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+" Depr.Acm.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"DEP,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"DEP", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: NM_ITCDES   --> NM_ECxxDES
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"DES","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,1)+"Cr.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,1)+"Cr.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,1)+"Cr.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)+" Corr.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)+" Corr.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)+" Corr.Depr.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"DES,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)," de correcao de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)," de correcao de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DES",nX,2)," de correcao de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"DES", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

					CASE aTabATF[2][nY] == "SNN"
	
						//MODELO: NN_SUBCCON   --> NN_ECxxCON
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"CON","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)+" do bem.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"CON,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)," de classificacao do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)," de classificacao do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CON",nX,2)," de classificacao do bem"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"CON", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: NN_SUBCDEP  --> NM_ECxxDEP
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"DEP","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+"Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+"Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)+"Desp.Depr.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"DEP,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"DEP",nX,2)," de despesa de depreciacao"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"DEP", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: NN_SUBCCDE  --> NM_ECxxCDE
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"CDE","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+".Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+".Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+".Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+"Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+"Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+"Depr.Acm.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"CDE,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"CDE", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)
					
					CASE aTabATF[2][nY] $ "SNQ|SNR"
					
						//MODELO: NQ_SUBCCDE  --> NQ_ECxxCDE
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_EC"+cEntidNum+"CDE","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+"Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+"Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)+"Depr.Acm.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_EC"+cEntidNum+"CDE,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_EC"+cEntidNum+"CDE",nX,2)," de depreciacao acumulada"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_EC"+cEntidNum+"CDE", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

					CASE aTabATF[2][nY] $ "SN4|SN7|SNS|SNV"

						//MODELO: N4_SUBCTA --> N4_ENTxx  
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_ENT"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1),CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1),CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1),CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2),CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2),CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2),"@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_ENT"+cEntidNum+",,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Entidade cont¡bil "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," do movimento"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Entidade cont¡bil "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," do movimento"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Entidade cont¡bil "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," do movimento"}   // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_ENT"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)
					
					CASE aTabATF[2][nY] $ "SNW|SNX|SNY"

						//MODELO: NW_NIV01   --> NW_NIVxx  
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_NIV"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,"Nivel "+cEntidNum,"Nivel "+cEntidNum,"Nivel "+cEntidNum,"Ent. Cont¡bil nivel "+cEntidNum,"Ent. Cont¡bil nivel "+cEntidNum,"Ent. Cont¡bil nivel "+cEntidNum,"@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_NIV"+cEntidNum+",,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Entidade cont¡bil de nivel"+cEntidNum+" do saldo"}
						aPHelpSpa := {"Entidade cont¡bil de nivel"+cEntidNum+" do saldo"}
						aPHelpEng := {"Entidade cont¡bil de nivel"+cEntidNum+" do saldo"}
						PutHelp("P"+aTabATF[3][nY]+"_NIV"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

					CASE aTabATF[2][nY] == "FNE"
	
						//MODELO: FNE_ENT01B   --> FNE_ENTxxB
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_ENT"+cEntidNum+"B","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,2)+" do bem ",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,2)+" do bem ",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,2)+" do bem ","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_ENT"+cEntidNum+"B,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,2)," de classificacao do bem"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,2)," de classificacao do bem"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"B",nX,2)," de classificacao do bem"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_ENT"+cEntidNum+"B", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: FNE_ENT01D  --> FNE_ENTxxD
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_ENT"+cEntidNum+"D","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,1)+"Ds.Dp",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,2)+" Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,2)+" Desp.Depr.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,2)+" Desp.Depr.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_ENT"+cEntidNum+"D,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,2)," de despesa de depreciacao"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,2)," de despesa de depreciacao"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"D",nX,2)," de despesa de depreciacao"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_ENT"+cEntidNum+"D", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

						//MODELO: FNE_ENT01A  --> FNE_ENTXXA
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_ENT"+cEntidNum+"A","C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,1)+"Dp.Ac",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,2)+" Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,2)+" Depr.Acm.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,2)+" Depr.Acm.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_ENT"+cEntidNum+"A,,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,2)," de depreciacao acumulada"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,2)," de depreciacao acumulada"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum+"A",nX,2)," de depreciacao acumulada"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_ENT"+cEntidNum+"A", aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

					CASE aTabATF[2][nY] == "FNF"
	
						//MODELO: FNF_ENT01    --> FNF_ENTXX
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_ENT"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1)+"Bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)+" do bem.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)+" do bem.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_ENT"+cEntidNum+",,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," de classificacao do bem"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," de classificacao do bem"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," de classificacao do bem"}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_ENT"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

					CASE aTabATF[2][nY] == "FNU"
	
						//MODELO: FNU_ITEM  --> FNU_ENTXX
						Aadd(aSX3,{aTabATF[2][nY],"00",aTabATF[3][nY]+"_ENT"+cEntidNum,"C",TamSXG(cGrpNum)[1],0,CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1)+"Prv.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1)+"Prv.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,1)+"Prv.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)+" de provisao.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)+" de provisao.",CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)+" de provisao.","@!","CTB105EntC(,M->"+aTabATF[3][nY]+"_ENT"+cEntidNum+",,'"+cEntidNum+"')","‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬‚¬ ","",cF3,1,"€ €","","","S","","","","","","","","","","","",cGrpNum,"","S"})
				 					 //1234567890123456789012345678901234567890 - 40 caracteres por linha	
						aPHelpPor := {"Informe Entidade contabil "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," de provisao."}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpSpa := {"Informe Entidade contabil "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," de provisao."}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						aPHelpEng := {"Informe Entidade contabil "+CSE901Info(aTabATF[3][nY]+"_ENT"+cEntidNum,nX,2)," de provisao."}    // HELP COM TEXTO COMPOSTO COM O NOME COMPLETO DA ENTIDADE
						PutHelp("P"+aTabATF[3][nY]+"_ENT"+cEntidNum, aPHelpPor, aPHelpEng, aPHelpSpa, .T.)

				ENDCASE
			EndIf
		Next nY
    Endif
	//------------------------------------------
	// Campos padroes do Ativo Fixo    - FIM   
	//------------------------------------------

Next nX

//----------------------------------------------------------
// Identifica ordem correta para inclus£o dos campos no SX3
//----------------------------------------------------------
For nX := 1 to Len(aSX3)

	SX3->(DbSetOrder(2)) // X3_CAMPO
	If SX3->(MsSeek(aSX3[nX,3]))
		aSX3[nX,2] := SX3->X3_ORDEM
	Else
		If (nY := aScan(aDisp, {|x| x[1] == aSX3[nX,1]})) == 0
			AADD(aDisp, { aSX3[nX,1], {} } )
			nY := Len(aDisp)
			SX3->(dbSetOrder(1)) // X3_ARQUIVO+X3_ORDEM
			For nZ := 1 to Val(RetAsc("Z9",2,.F.))
				cOrdem := RetAsc(Alltrim(str(nZ)),2,.T.)
				If !SX3->(MsSeek( aSX3[nX,1]+cOrdem ))
					AADD( aDisp[nY][2], cOrdem )
				EndIf
			Next
		EndIf
		If Len(aDisp[nY][2])<1
			cOrdem := "ZZ"
		Else
			cOrdem := aDisp[nY][2][1]
			ADel(aDisp[nY][2],1)
			ASize(aDisp[nY][2], len(aDisp[nY][2])-1)
		EndIf
		aSX3[nX,2] := cOrdem
	EndIf

Next nX

oProcess:SetRegua2(Len(aSX3))

//------------------------------
// Atualiza dicion¡rio de dados
//------------------------------
SX3->( DbSetOrder(2) )

For nContItem := 1 To Len(aSX3)

	cNomeCamp := AllTrim(aSX3[nContItem,3])

	lGrava := SX3->(!dbSeek(cNomeCamp))
	lSX3	:= .T.
	If ! (aSX3[nContItem,1] $ cAlias)
		If Len(cAlias) == 104
			cAlias += aSX3[nContItem,1]+"/"+CRLF+" "
		Else
			cAlias += aSX3[nContItem,1]+"/"
		EndIf
		If Ascan(aArqUpd,aSX3[nContItem,1]) == 0
			aAdd(aArqUpd,aSX3[nContItem,1])
		EndIf
	EndIf

	RecLock("SX3",lGrava)
	For nContEstr :=1 To Len(aSX3[nContEstr])
		If FieldPos(aEstrut[nContEstr])>0
			FieldPut(FieldPos(aEstrut[nContEstr]),aSX3[nContItem,nContEstr])
		EndIf
	Next nContEstr
	dbCommit()
	MsUnLock()
	oProcess:IncRegua2(STR0033)

Next nContItem

If lSX3
	cTexto := STR0007+cAlias+CRLF //'Tabelas atualizadas : '
EndIf

CTBUpdField("SX3", 2, "CT0_ENTIDA", "X3_WHEN", "CTB050WHEN()")
CTBUpdField("SX3", 2, "CT0_ALIAS ", "X3_WHEN", "!(M->CT0_ALIAS $ 'CT1|CTT|CTD|CTH')")
CTBUpdField("SX3", 2, "CTJ_ET05CR", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC05CR,,'05')")
CTBUpdField("SX3", 2, "CTJ_ET05DB", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC05DB,,'05')")
CTBUpdField("SX3", 2, "CTJ_ET06CR", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC06CR,,'06')")
CTBUpdField("SX3", 2, "CTJ_ET06DB", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC06DB,,'06')")
CTBUpdField("SX3", 2, "CTJ_ET07CR", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC07CR,,'07')")
CTBUpdField("SX3", 2, "CTJ_ET07DB", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC07DB,,'07')")
CTBUpdField("SX3", 2, "CTJ_ET08CR", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC08CR,,'08')")
CTBUpdField("SX3", 2, "CTJ_ET08DB", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC08DB,,'08')")
CTBUpdField("SX3", 2, "CTJ_ET09CR", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC09CR,,'09')")
CTBUpdField("SX3", 2, "CTJ_ET09DB", "X3_VALID", "CTB1XXEntC(,M->CTJ_EC09DB,,'09')")
CTBUpdField("SX3", 2, "CV0_LUCPER", "X3_VALID", "CTB105EntC(,M->CV0_LUCPER,,M->CV0_PLANO)")
CTBUpdField("SX3", 2, "CV0_PONTE ", "X3_VALID", "CTB105EntC(,M->CV0_PONTE,,M->CV0_PLANO)")

CTBUpdField("SX3", 2, "AK2_ENT05", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AK2_ENT05,,"05")')
CTBUpdField("SX3", 2, "AK2_ENT06", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AK2_ENT06,,"06")')
CTBUpdField("SX3", 2, "AK2_ENT07", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AK2_ENT07,,"07")')
CTBUpdField("SX3", 2, "AK2_ENT08", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AK2_ENT08,,"08")')
CTBUpdField("SX3", 2, "AK2_ENT09", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AK2_ENT09,,"09")')
CTBUpdField("SX3", 2, "AKD_ENT05", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AKD_ENT05,,"05")')
CTBUpdField("SX3", 2, "AKD_ENT06", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AKD_ENT06,,"06")')
CTBUpdField("SX3", 2, "AKD_ENT07", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AKD_ENT07,,"07")')
CTBUpdField("SX3", 2, "AKD_ENT08", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AKD_ENT08,,"08")')
CTBUpdField("SX3", 2, "AKD_ENT09", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AKD_ENT09,,"09")')
CTBUpdField("SX3", 2, "ALJ_ENT05", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->ALJ_ENT05,,"05")')
CTBUpdField("SX3", 2, "ALJ_ENT06", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->ALJ_ENT06,,"06")')
CTBUpdField("SX3", 2, "ALJ_ENT07", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->ALJ_ENT07,,"07")')
CTBUpdField("SX3", 2, "ALJ_ENT08", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->ALJ_ENT08,,"08")')
CTBUpdField("SX3", 2, "ALJ_ENT09", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->ALJ_ENT09,,"09")')
CTBUpdField("SX3", 2, "AMJ_ENT05", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMJ_ENT05,,"05")')
CTBUpdField("SX3", 2, "AMJ_ENT06", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMJ_ENT06,,"06")')
CTBUpdField("SX3", 2, "AMJ_ENT07", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMJ_ENT07,,"07")')
CTBUpdField("SX3", 2, "AMJ_ENT08", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMJ_ENT08,,"08")')
CTBUpdField("SX3", 2, "AMJ_ENT09", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMJ_ENT09,,"09")')
CTBUpdField("SX3", 2, "AMZ_ENT05", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMZ_ENT05,,"05")')
CTBUpdField("SX3", 2, "AMZ_ENT06", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMZ_ENT06,,"06")')
CTBUpdField("SX3", 2, "AMZ_ENT07", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMZ_ENT07,,"07")')
CTBUpdField("SX3", 2, "AMZ_ENT08", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMZ_ENT08,,"08")')
CTBUpdField("SX3", 2, "AMZ_ENT09", "X3_VALID", 'Vazio() .Or. CTB105EntC(,M->AMZ_ENT09,,"09")')

RestArea(aAreaSX3)
RestArea(aArea)
Return cTexto

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTAtuSIX ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Funcao de processamento da gravacao do SIX                 º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function ENTAtuSIX()
Local cTexto  := ''
Local lSIX    := .F.
Local lNew    := .F.
Local aSIX    := {}
Local aEstrut := {}
Local i       := 0
Local j       := 0
Local cAlias  := ''

aEstrut := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}

// Indice
Aadd(aSIX,{	"CV0","3","CV0_FILIAL+CV0_PLANO+CV0_ENTSUP",;
			"Plano Cont¡b + Entidade Superior",;
			"Plan Contabl + Entidad Superior",;
			"Accoun. Plan + Superior Entity",;
			"S","","","S"})

ProcRegua(Len(aSIX))

dbSelectArea("SIX")
dbSetOrder(1)

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !dbSeek(aSIX[i,1]+aSIX[i,2])
			lNew:= .T.
		Else
			lNew:= .F.
		EndIf

		If  lNew .OR.;
			!(UPPER(AllTrim(CHAVE))==UPPER(Alltrim(aSIX[i,3]))) .OR.;
			!(UPPER(AllTrim(NICKNAME))==UPPER(Alltrim(aSIX[i,9])))

			If Ascan(aArqUpd,aSIX[i,1]) == 0
				aAdd(aArqUpd,aSIX[i,1])
			EndIf
			lSIX := .T.

			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf

			RecLock("SIX",lNew)

			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf

		IncProc(STR0029) //"Atualizando Indices..."

	EndIf
Next i

If lSIX
	cTexto += STR0049+cAlias+CRLF //"Indices atualizados  : "
EndIf

Return cTexto

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTAtuCT0 ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Funcao  de processamento da gravacao da Entidade           º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function ENTAtuCT0()
Local aColsGet  := ACLONE(oGetDados:aCols)
Local cTexto 	:= ''
Local aSaveArea := GetArea()
Local nCont	:= 0
Local cAlias
Local cAux
Local cCpoSup
Local cCpoChv
Local cOrd1
Local cInd1
Local cOrd2
Local cInd2

dbSelectArea("CV0")
dbSetOrder(1)

dbSelectArea("CT0")
dbSetOrder(1)

oProcess:SetRegua1(Len(aColsGet))

For nCont := 1 To Len(aColsGet)
	If !dbSeek(xFilial("CT0")+aColsGet[nCont][1])
		dbSelectArea("CV0")
		If !Empty(aColsGet[nCont][11]) .And. !dbSeek(xFilial("CV0")+aColsGet[nCont][11])
			RecLock("CV0", .T.)
			CV0->CV0_FILIAL := xFilial("CV0")
			CV0->CV0_PLANO  := aColsGet[nCont][11]
			CV0->CV0_DESC 	:= aColsGet[nCont][12]
			CV0->CV0_DTIBLQ := Ctod("")
			CV0->CV0_DTFBLQ := dDatabase
			CV0->CV0_DTIEXI := Ctod("")
			CV0->CV0_DTFEXI := Ctod("")
			MsUnlock("CV0")
		EndIf
		dbSelectArea("CT0")
		RecLock("CT0",.T.)
		CT0->CT0_FILIAL := xFilial("CT0")
		CT0->CT0_ID	:= aColsGet[nCont][1]
		CT0->CT0_DESC   := aColsGet[nCont][2]
		CT0->CT0_DSCRES := aColsGet[nCont][3]
		CT0->CT0_CONTR  := aColsGet[nCont][4]
		CT0->CT0_ALIAS  := aColsGet[nCont][5]
		CT0->CT0_CPOCHV := aColsGet[nCont][6]
		CT0->CT0_CPODSC := aColsGet[nCont][7]
		CT0->CT0_ENTIDA := aColsGet[nCont][11]
		CT0->CT0_OBRIGA := "2"
		CT0->CT0_CPOSUP := aColsGet[nCont][8]
		CT0->CT0_GRPSXG := aColsGet[nCont][9]
		CT0->CT0_F3ENTI := aColsGet[nCont][10]

		IF CT0->(FieldPos("CT0_TITGC1")) > 0
			CT0->CT0_TITGC1 := aColsGet[nCont][13]		
		ENDIF

		IF CT0->(FieldPos("CT0_TITGC2")) > 0
			CT0->CT0_TITGC2 := aColsGet[nCont][14]		
		ENDIF

		IF CT0->(FieldPos("CT0_DSCGC1")) > 0
			CT0->CT0_DSCGC1 := aColsGet[nCont][15]		
		ENDIF

		IF CT0->(FieldPos("CT0_DSCGC2")) > 0
			CT0->CT0_DSCGC2 := aColsGet[nCont][16]		
		ENDIF

		IF CT0->(FieldPos("CT0_HLPPAD")) > 0
			CT0->CT0_HLPPAD := aColsGet[nCont][17]		
		ENDIF

		MsUnlock()

		cAlias  := Alltrim(aColsGet[nCont][5])

		If cAlias<>"CV0"
			cCpoSup := aColsGet[nCont][8]
			cCpoChv := aColsGet[nCont][6]
			If Left(cAlias,1)=='S'
				cAux:=substr(cAlias,2,2)
			Else
				cAux:=cAlias
			EndIf
			cOrd1 := ''
			cInd1 := Alltrim(cAux+"_FILIAL+"+cCpoChv)
			cOrd2 := ''
			cInd2 := Alltrim(cAux+"_FILIAL+"+cCpoSup)

			dbSelectArea("SIX")
			dbSetOrder(1)

			SIX->(dbSeek(cAlias))
			Do While !SIX->(Eof()) .And. SIX->INDICE==cAlias
				If Empty(cOrd1) .And. Left(SIX->CHAVE,len(cInd1))==cInd1
					cOrd1 := SIX->ORDEM
				EndIf
				If Empty(cOrd2) .And. Left(SIX->CHAVE,len(cInd2))==cInd2
					cOrd2 := SIX->ORDEM
				EndIf
				SIX->(dbSkip())
			EndDo

			If Empty(cOrd1)
				dbSelectArea("SX3")
				dbSetOrder(2)
				SX3->(dbSeek(cCpoChv))
				dbSelectArea("SIX")
				SIX->(dbSeek(cAlias))
				Do While !SIX->(Eof()) .And. SIX->INDICE==cAlias
					cOrd1 := SIX->ORDEM
					SIX->(dbSkip())
				EndDo
				cOrd1:=Soma1(cOrd1)
				RecLock("SIX",.T.)
				SIX->INDICE		:= cAlias
				SIX->ORDEM		:= cOrd1
				SIX->CHAVE		:= cInd1
				SIX->DESCRICAO	:= SX3->X3_TITULO
				SIX->DESCSPA	:= SX3->X3_TITSPA
				SIX->DESCENG	:= SX3->X3_TITENG
				SIX->PROPRI		:= 'U'
				SIX->NICKNAME	:= cAlias+"INDTMP1"
				SIX->SHOWPESQ	:= 'N'
				SIX->(dbCommit())
				SIX->(MsUnLock())
				If select(cAlias)>0
					dbSelectArea(cAlias)
					dbCloseArea()
				EndIf
				dbSelectArea(cAlias)
			EndIf

			If Empty(cOrd2)
				dbSelectArea("SX3")
				dbSetOrder(2)
				SX3->(dbSeek(cCpoSup))
				dbSelectArea("SIX")
				SIX->(dbSeek(cAlias))
				Do While !SIX->(Eof()) .And. SIX->INDICE==cAlias
					cOrd2 := SIX->ORDEM
					SIX->(dbSkip())
				EndDo
				cOrd2:=Soma1(cOrd2)
				RecLock("SIX",.T.)
				SIX->INDICE		:= cAlias
				SIX->ORDEM		:= cOrd2
				SIX->CHAVE		:= cInd2
				SIX->DESCRICAO	:= SX3->X3_TITULO
				SIX->DESCSPA	:= SX3->X3_TITSPA
				SIX->DESCENG	:= SX3->X3_TITENG
				SIX->PROPRI		:= 'U'
				SIX->NICKNAME	:= cAlias+"INDTMP2"
				SIX->SHOWPESQ	:= 'N'
				SIX->(dbCommit())
				SIX->(MsUnLock())
				If select(cAlias)>0
					dbSelectArea(cAlias)
					dbCloseArea()
				EndIf
				dbSelectArea(cAlias)
			EndIf
			
		EndIf

		dbSelectArea("CT0")

	EndIf
	oProcess:IncRegua2(STR0048)
Next

RestArea(aSaveArea)
Return cTexto

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTGetNum ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Monta gets para informa§£o do nºmero, entidade inicial e   º
º          ³ m³dulos para gera§£o.                                      º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function EntGetNum()
Local oPanel	:= Nil
Local nMaxEnt	:= GETMAXENT() 
Local oSayQtdEnt, oGetQtdEnt, oSayEntIni, oGetEntIni, oCheckRef, oCheckCTB, oCheckATF, oCheckCOM,;
      oCheckEST, oCheckFAT, oCheckFIN, oCheckGCT, oCheckPCO  

If lMaxEnt
	lChkRefaz := .T.
	nQtdEntid := 0
	nEntidIni := 0
EndIf

If nEntidIni == 5
	lChkRefaz := .F.
EndIf


//------------------------------------------------------------
// Campos para definicao da quantidade de entidades e modulos
//------------------------------------------------------------
oPanel   := oWizard:oMPanel[oWizard:nPanel]

oSayQtdEnt	:= TSay():New(005,008,{||STR0017},oPanel,,,,,,.T.,,,,,,,,,,) //"Total de Entidades a serem criadas:"
oGetQtdEnt	:= TGet():New(015,008,{|u| If(PCount() > 0,nQtdEntid := u,nQtdEntid)},oPanel,015,009,'@e 99',{|| ENTVldNum(nQtdEntid,nMaxEnt) }	,,,,,,.T.,,,{||!lMaxEnt},,,,,.F.,,"nQtdEntid",,,,,,,,,)

oSayEntIni	:= TSay():New(035,008,{||STR0018},oPanel,,,,,,.T.,,,,,,,,,,) //"Numera§£o da primeira entidade a ser criada:"
oGetEntIni	:= TGet():New(045,008,{|u| If(PCount() > 0,nEntidIni := u,nEntidIni)},oPanel,015,009,'@ 99',{|| .T. },,,,,,.T.,,,{||.F.},,,,.F.,.F.,,"nEntidIni",,,,,,,,,)
oCheckRef	:= TCheckBox():New(065,008,STR0066,bSETGET(lChkRefaz)	,oPanel,150,009,,,,,,,,.T.,,,{||!lMaxEnt}) //"Cria campo para entidades j¡ existentes"

oSayRefaz	:= TSay():New(080,008,{||STR0019},oPanel,,,,,,.T.,,,,,,,,,,) //"Definir os m³dulos para cria§£o:"
oCheckCTB   := TCheckBox():New(090,008,STR0043,bSETGET(lChkCTB)		,oPanel,050,009,,,,,,,,.T.,,,{|| .F. })	   //"Contabilidade"
oCheckATF	:= TCheckBox():New(100,008,STR0041,bSETGET(lChkATF)		,oPanel,050,009,,,,,,,,.T.,,,) //"Ativo Fixo"
oCheckCOM	:= TCheckBox():New(110,008,STR0042,bSETGET(lChkCOM)		,oPanel,050,009,,,,,,,,.T.,,,) //"Compras"
oCheckEST	:= TCheckBox():New(120,008,STR0044,bSETGET(lChkEST)		,oPanel,050,009,,,,,,,,.T.,,,) //"Estoque"
oCheckFAT	:= TCheckBox():New(130,008,STR0045,bSETGET(lChkFAT)		,oPanel,050,009,,,,,,,,.T.,,,) //"Faturamento"
oCheckFIN	:= TCheckBox():New(140,008,STR0046,bSETGET(lChkFIN)		,oPanel,050,009,,,,,,,,.T.,,,) //"Financeiro"
oCheckGCT	:= TCheckBox():New(090,108,STR0080,bSETGET(lChkGCT)		,oPanel,100,009,,,,,,,,.T.,,,) //"Gest£o de Contratos"
oCheckPCO	:= TCheckBox():New(100,108,STR0081,bSETGET(lChkPCO)		,oPanel,100,009,,,,,,,,.T.,,,) //"Controle Or§ament¡rio"

If lMaxEnt
	oCheckRef:bWhen  	:= {|| .F. }
	oGetQtdEnt:bWhen 	:= {|| .F. }
	oGetEntIni:bWhen  	:= {|| .F. }
EndIf 

If nEntidIni == 5
	oCheckRef:bWhen  := {|| .F. }
EndIf

Return

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTGetDescºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³  Monta grid para informa§£o das descri§µes das entidades   º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function EntGetDesc()
                                                                                                
Local nContItem := 1
Local oPanel 	:= oWizard:oMPanel[oWizard:nPanel]
Local nEntNew   := nEntidIni 
Local cLinOk	:= "U_CSE901Lk()"

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Monta grid para informativo das descri§µes por entidade      ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
Local aHeader 	:= {}
Local aCols 	:= {}
Local aAlterGDa	:= {"CT0_DESC","CT0_DSCRES","CT0_TITGC1", "CT0_TITGC2", "CT0_DSCGC1", "CT0_DSCGC2", "CT0_HLPPAD"}

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Dados padroes CERTISIGN                                      ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
Local aDadosPad	:= {}

//				"123456789012345678901234567890","1234567890","1234","123456789012"	,"123456789012"	,"1234567890123456789012345","1234567890123456789012345678901234567890"
AADD(aDadosPad,{"AGENTES DE NEGOCIOS"			,"AG.NEGOCIO","AGN.","AG.NEGOCIO"	,"AG.NEGOCIO"	,"AGENTE DE NEGOCIO"		,"ENTIDADE ORCAMENTARIA AGENTE DE NEGOCIO"	,25})
AADD(aDadosPad,{"TIPOS DE ATIVIDADES"			,"TP.ATIVID.","TPA.","TP.ATIVID."	,"TP.ATIVID."	,"TIPO DE ATIVIDADE"		,"ENTIDADE ORCAMENTARIA TIPO DE ATIVIDADE"	,25})
AADD(aDadosPad,{"PRODUTOS COMERCIALIZADOS"		,"PRD.COMERC","PRD.","PRD.COMERC"	,"PRD.COMERC"	,"PRODUTO COMERCIAL"		,"ENTIDADE ORCAMENTARIA PROD. COMERCIAL"	,25})
AADD(aDadosPad,{"CANAIS DE VENDAS"				,"CANAL VND.","CNV.","CANAL VND."	,"CANAL VND."	,"CANAL DE VENDA"			,"ENTIDADE ORCAMENTARIA CANAL DE VENDA"		,25})
AADD(aDadosPad,{"ENTIDADE CONTABIL 09"			,"ENT.CTB.09","E09.","ENT.CTB.09"	,"ENT.CTB.09"	,"ENTIDADE CTB.09"			,"ENTIDADE CONTABIL 09"                		,25})

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Cria aHeader e aCols da GetDados                             ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
//				cTitulo			,cCampo			,cPicture	,nTamanho	,nDecimais	,cValida§£o										,cUsado	,cTipo	,cF3		,cCntxt	,cCBox								,cRelacao
Aadd(aHeader,{	STR0030			,"CT0_ID"		,"!!"		,02			,0			,".F."											,"»"	,"C"	," "		,"R"	,""									,""		}) //Item
Aadd(aHeader,{	STR0031			,"CT0_DESC"		,"@!"		,30			,0			,"NaoVazio()"									,"»"	,"C"	," "		,"R"	,""									,""     }) //Descri§£o
Aadd(aHeader,{	STR0052			,"CT0_DSCRES"	,"@!"		,10			,0			,"NaoVazio()"									,"»"	,"C"	," "		,"R"	,""									,""     }) //Descricao Resumida
Aadd(aHeader,{	STR0032			,"CT0_CONTR"	,"@!"		,1			,0			,"NaoVazio().And. Pertence('12')"				,"»"	,"C"	," "		,"R"	,""									,""     }) //Controla
Aadd(aHeader,{	STR0053			,"CT0_ALIAS"	,"@!"		,3			,0			,"NaoVazio().And. ValidX2Alias(M->CT0_ALIAS)"	,"»"	,"C"	," "		,"R"	,""									,""     }) //Alias
Aadd(aHeader,{	STR0054			,"CT0_CPOCHV"	,"@!"		,10			,0			,"NaoVazio().And. ValidX3Cpo(M->CT0_CPOCHV)"	,"»"	,"C"	,"CT0SX3"	,"R"	,""									,""     }) //Campo Chave
Aadd(aHeader,{	STR0055			,"CT0_CPODSC"	,"@!"		,10			,0			,"NaoVazio().And. ValidX3Cpo(M->CT0_CPODSC)"	,"»"	,"C"	,"CT0SX3"	,"R"	,""									,""     }) //Desc. Campo
Aadd(aHeader,{	STR0059			,"CT0_CPOSUP"	,"@!"		,10			,0			,"Vazio() .Or. ValidX3Cpo(M->CT0_CPOSUP)"		,"»"	,"C"	,"CT0SX3"	,"R"	,""									,""     }) //Cpo.Ent.Sup.
Aadd(aHeader,{	STR0060			,"CT0_GRPSXG"	,"@!"		,3			,0			,"Vazio() .Or. ValidSXG(M->CT0_GRPSXG)"			,"»"	,"C"	," "		,"R"	,IIF(!lChkRefaz,AdmCBGrupo(),"")	,""     }) //Grp.Campos
Aadd(aHeader,{	STR0061			,"CT0_F3ENTI"	,"@!"		,6			,0			,"Vazio() .Or. ValidSXB(M->CT0_F3ENTI)"			,"»"	,"C"	," "		,"R"	,IIF(!lChkRefaz,AdmCBCPad(),"")	,""     }) //Cons. Padrao
Aadd(aHeader,{	STR0062			,"CT0_ENTIDA"	,"@!"		,2			,0			,".F."											,"»"	,"C"	," "		,"R"	,""									,""     }) //Plano
Aadd(aHeader,{	STR0063			,"CV0_DESC"		,"@!"		,30			,0			,""												,"»"	,"C"	," "		,"R"	,""									,""     }) //Desc. Plano
Aadd(aHeader,{	"Tit.GrpCp.01"	,"CT0_TITGC1"	,"@!"		,04			,0			,"NaoVazio()"									,"»"	,"C"	," "		,"V"	,""									,""     }) //Titulo para o grupo de campos 02 - 04 posicoes
Aadd(aHeader,{	"Tit.GrpCp.02"	,"CT0_TITGC2"	,"@!"		,12			,0			,"NaoVazio()"									,"»"	,"C"	," "		,"V"	,""									,""     }) //Titulo para o grupo de campos 01 - 12 posicoes
Aadd(aHeader,{	"Dsc.GrpCp.01"	,"CT0_DSCGC1"	,"@!"		,12			,0			,"NaoVazio()"									,"»"	,"C"	," "		,"V"	,""									,""     }) //Descricao para o grupo de campos 02 - 12 posicoes
Aadd(aHeader,{	"Dsc.GrpCp.02"	,"CT0_DSCGC2"	,"@!"		,25			,0			,"NaoVazio()"									,"»"	,"C"	," "		,"V"	,""									,""     }) //Descricao para o grupo de campos 01 - 25 posicoes
Aadd(aHeader,{	"Help padrao"	,"CT0_HLPPAD"	,"@!"		,40			,0			,"NaoVazio()"									,"»"	,"C"	," "		,"V"	,""									,""     }) //Help padrao para os campo da entidade            
Aadd(aHeader,{	"Tam.Inicial"	,"CT0_SXGTAM"	,"@E 99"	,02			,0			,"NaoVazio()"									,"»"	,"N"	," "		,"V"	,""									,""     }) //Tamanho para a criacao dos campos

If lChkRefaz
		//aCols := CT910RACol(aHeader)
		nEntNew := 5
		For nContItem := 1 to 4
		Do Case //obten§£o do nro do grupo
			Case nEntNew == 5  //Entidade 05
				cGrpNum := "040"
			Case nEntNew == 6  //Entidade 06
				cGrpNum := "042"
			Case nEntNew == 7  //Entidade 07
				cGrpNum := "043"
			Case nEntNew == 8  //Entidade 08
				cGrpNum := "044"
			Case nEntNew == 9  //Entidade 09
				cGrpNum := "045"
		EndCase
		aAdd(aCols,{	StrZero(nEntNew,2,0),;
						IIF(!USAPADRAO,Space(TamSx3("CT0_DESC")[1]),aDadosPad[nContItem][1]),;
						IIF(!USAPADRAO,Space(10),aDadosPad[nContItem][2]),;
						"1",;
						"CV0",;
						PADR("CV0_CODIGO",TamSx3("CT0_CPOCHV")[1]),;
						PADR("CV0_DESC",TamSx3("CT0_CPODSC")[1]),;
						PADR("CV0_ENTSUP",TamSx3("CT0_CPOSUP")[1]),;
						cGrpNum,;
						"CV0   ",;
						StrZero(nEntNew,2,0),;
						Upper(STR0062)+" "+StrZero(nEntNew,2,0),;
						IIF(!USAPADRAO,Space(aHeader[13][04])	,aDadosPad[nContItem][3]),;
						IIF(!USAPADRAO,Space(aHeader[14][04])	,aDadosPad[nContItem][4]),;
						IIF(!USAPADRAO,Space(aHeader[15][04])	,aDadosPad[nContItem][5]),;
						IIF(!USAPADRAO,Space(aHeader[16][04])	,aDadosPad[nContItem][6]),;
						IIF(!USAPADRAO,Space(aHeader[17][04])	,aDadosPad[nContItem][7]),;
						IIF(!USAPADRAO,6						,aDadosPad[nContItem][8]),;
						.F.}) //Plano
		nEntNew ++
	Next nContItem
Else 
	For nContItem := 1 to nQtdEntid
		Do Case //obten§£o do nro do grupo
			Case nEntNew == 5  //Entidade 05
				cGrpNum := "040"
			Case nEntNew == 6  //Entidade 06
				cGrpNum := "042"
			Case nEntNew == 7  //Entidade 07
				cGrpNum := "043"
			Case nEntNew == 8  //Entidade 08
				cGrpNum := "044"
			Case nEntNew == 9  //Entidade 09
				cGrpNum := "045"
		EndCase
		aAdd(aCols,{	StrZero(nEntNew,2,0),;
						IIF(!USAPADRAO,Space(TamSx3("CT0_DESC")[1]),aDadosPad[nContItem][1]),;
						IIF(!USAPADRAO,Space(10),aDadosPad[nContItem][2]),;
						"1",;
						"CV0",;
						PADR("CV0_CODIGO",TamSx3("CT0_CPOCHV")[1]),;
						PADR("CV0_DESC",TamSx3("CT0_CPODSC")[1]),;
						PADR("CV0_ENTSUP",TamSx3("CT0_CPOSUP")[1]),;
						cGrpNum,;
						"CV0   ",;
						StrZero(nEntNew,2,0),;
						Upper(STR0062)+" "+StrZero(nEntNew,2,0),;
						IIF(!USAPADRAO,Space(aHeader[13][04]),aDadosPad[nContItem][3]),;
						IIF(!USAPADRAO,Space(aHeader[14][04]),aDadosPad[nContItem][4]),;
						IIF(!USAPADRAO,Space(aHeader[15][04]),aDadosPad[nContItem][5]),;
						IIF(!USAPADRAO,Space(aHeader[16][04]),aDadosPad[nContItem][6]),;
						IIF(!USAPADRAO,Space(aHeader[17][04]),aDadosPad[nContItem][7]),;
						IIF(!USAPADRAO,6					  ,aDadosPad[nContItem][8]),;
						.F.}) //Plano
		nEntNew ++
	Next nContItem
EndIf

If lChkRefaz
	nOpcX := 0  
Else
	nOpcX := GD_UPDATE 
EndIf

//           MsNewGetDados():New(nSuperior	,nEsquerda	,nInferior	,nDireita	,nOpc	,cLinOk	,cTudoOk	,cIniCpos	,aAlterGDa					,nFreeze	,nMax	,cFieldOk	,cSuperDel	,cDelOk	,oDLG	,aHeader	,aCols)
oGetDados := MsNewGetDados():New(005		,005		,150		,300		,nOpcX	,cLinOk	,			,			,aAlterGDa					,			,5		,			,			,		,oPanel	,aHeader	,aCols)
oGetDados:SetEditLine(.F.)
SX3->(dbCloseArea())

Return

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTWIZREGUºAutor  ³Microsiga           º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Realiza o controle do obejto process da rotina             º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function ENTWIZREGU(lEnd)
Private oProcess
// Executa o processamento dos arquivos
dbSelectArea("SX2")
dbCloseArea()
dbSelectArea("SIX")
dbCloseArea()
dbSelectArea("SX3")
dbCloseArea()
oProcess:=	MsNewProcess():New( {|lEnd| ENTWIZPROC(oProcess) } )
oProcess:Activate()
Return

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTOpenSM0 ºAutor  ³TOTVS Protheus     º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Realiza abertura do SIGAMAT.EMP de forma exclusiva         º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                        º
ˆ¼


*/
Static Function ENTOpenSM0()
Local nLoop := 0
Local lOpen := .F.

For nLoop := 1 To 20
	dbUseArea(.T., , "SIGAMAT.EMP", "SM0", .T., .F.)
	If !Empty(Select("SM0"))
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit
	EndIf
	Sleep(500)
Next nLoop

If !lOpen
	Aviso( STR0001, STR0050 , {STR0051}, 2)	//"Atencao!"###"Nao foi possivel a abertura da tabela
EndIf                                       	//de empresas de forma exclusiva!"###"Finalizar"

Return lOpen

/*


‰‘‹‘‹‘»
ºPrograma  ³GETMAXENT ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Retorna a partir de qual Entidade poder¡ ser realizada a   º
º          ³ criacao                                                    º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function GETMAXENT()
Local nEntidIni := 0
Local nEntidMax := 0
Local aAreaSX2 	:= {} 
Local lExistCpo := .T.

aAreaSX2 := SX2->(GetArea())

dbSelectArea("SX2")
dbSetOrder(1)
If !MsSeek("CT0")
	RestArea(aAreaSX2)
	MsgInfo(STR0057+" CT0 "+STR0058,STR0001) //"Tabela"###"n£o encontrada"###"Aten§£o"
	Return(nEntidMax)
EndIf

DbSelectArea("CT0")
If !Empty(Select("CT0"))
	lOpen := .T.
EndIf

If !lOpen
	MsgInfo(STR0050,STR0001) //"Nao foi possivel a abertura da tabela de empresas de forma exclusiva!"###"Atencao!"
Else
	DbSelectArea("CT0")
	DbSetOrder(1)
	DbSeek(xFilial()+"01")
	While CT0->(!EOF())
		lExistCpo := .T.
		IF Val(CT0->CT0_ID) > 0
			
			If cPaisLoc == "PER" .and. Val(CT0->CT0_ID) >= 5 
				lExistCpo := CtbEntIniVar(CT0->CT0_ID)
			EndIf	
			nEntidIni := Val(CT0->CT0_ID)
			If nEntidIni > nEntidMax .and. IIF(cPaisLoc == "PER",lExistCpo, .T.)
				nEntidMax := nEntidIni
			EndIf
		Else
			Exit
		EndIf
		
		CT0->(DbSkip())
	EndDo
	
	If nEntidMax == 0
		MsgInfo(STR0036,STR0001) //"Nao foi possivel determinar a quantidade de entidades
	Else                         //parametrizadas no sistema!"###"Atencao!"
		nEntidMax++				 //Nºmero da pr³xima entidade
	EndIf
	
Endif

RestArea(aAreaSX2)
Return nEntidMax
/*


‰‘‹‘‹‘»
ºPrograma  ³ENTVldNum ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Validacao do numero de entidades a serem geradas ao sele-  º
º          ³ cionar outro campo.                                        º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function ENTVldNum(nNum, nEntidIni)
Local lRet := .T.
Local nEntidMax := 9 - (nEntidIni - 1)

If nNum > nEntidMax
	lRet := .F.
	MsgInfo(STR0038+AllTrim(Str(nEntidMax,0))+STR0039,STR0001) //'O nºmero m¡ximo de entidades adicionais permitidas no momento © de: ' ### ' entidades. Ajuste o nºmero'###'Atencao'
ElseIf !Empty(nNum) .And. lChkRefaz
	lRet := .F.
	MSGINFO(STR0077,STR0021) //"A op§£o refaz entidade n£o permite criar novas." ##"CTBWizard - Entidades"
ElseIf Empty(nNum) .And. !lChkRefaz                                            
	lRet := .F.
	MsgInfo(STR0040,STR0001) //"‰ necess¡rio informar pelo menos uma entidade!"###"Atencao"
EndIf

Return(lRet)

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTWZVLP2 ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Validacao dos dados inicias para parametrizacao de Entida- º
º          ³ des na mudan§a de tela (next)                              º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function ENTWZVLP2()

Local aArea := GetArea()
Local lRet	:= .T.
Local nEntidMax := 9 - (nEntidIni - 1)

If lChkRefaz .And. !Empty(nQtdEntid)
	lRet := .F.
	MSGINFO(STR0067,STR0021) // "A op§£o refaz entidade n£o permite criar novas."##"CTBWizard - Entidades"
ElseIf nEntidIni > 9 .Or. nQtdEntid > nEntidMax
	lRet := .F.
	MSGINFO(STR0035+AllTrim(Str(9,0))+STR0037,STR0021) //"A parametriza§£o excede o limite de 09 entidades
	//configur¡veis no sistema!" # "CTBWizard - Entidades"
Else
	If !lChkATF .And. !lChkCOM .And. !lChkCTB .And. !lChkEST .And. !lChkFAT .And. !lChkFIN .And. !lChkGCT .And. !lChkRefaz .And. !lChkPCO
		lRet := .F.
		MSGINFO(STR0047,STR0001) //"‰ necess¡rio selecionar pelo menos um m³dulo!"###"Aten§£o!"
	EndIf
ENDIF

RestArea(aArea)

Return lRet

/*


‰‘‹‘‹‘»
ºPrograma  ³ENTWZVLP3 ºAutor  ³TOTVS Protheus      º Data ³  02/11/10   º
˜ŠŠ¹
ºDesc.     ³ Validacao do grid de entidades a serem incluidas.          º
º          ³                                                            º
˜¹
ºUso       ³ ENTWIZUPD                                                  º
ˆ¼


*/
Static Function ENTWZVLP3()
Local lRet 		:= .T.
Local aColsGet	:= ACLONE(oGetDados:aCols)
Local nX		:= 0

For nX := 1 to Len(aColsGet)
	lRet := U_CSE901Lk(nX)
	If !lRet
		Exit
	ENdIf
Next nX

IF lRet
	lRet := MSGNOYES(STR0020,STR0021) //Confirma a parametriza§£o das novas entidades # CTBWizard - Entidades
ENDIF

Return lRet

/*/


š„„„„„„„„„„‚„„„„„„„„„„‚„„„„„„„‚„„„„„„„„„„„„„„„„„„„„„„„‚„„„„„„‚„„„„„„„„„„¿
³Fun€¡€¦o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Descri€¡€¦o ³Retorna um array com as informacoes das filias das empresas ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³ Uso      ³ Generico                                                   ³
€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™


/*/
Static Function AdmAbreSM0()
Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetAux		:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0:= FindFunction( "FWCodFil" )
Local nItens		:= 0

If lFWLoadSM0
	aRetAux	:= FWLoadSM0()
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
		IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
		"",;
		"",;
		"",;
		SM0->M0_NOME,;
		SM0->M0_FILIAL }
		
		aAdd( aRetAux, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ Reduz o array para processar somente empresas     ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
FOR nItens := 1 TO LEN(aRetAux)

	IF !Empty(aRetSM0) .AND. aScan(aRetSM0,{|aRetSM0| aRetSM0[1] == aRetAux[nItens][1]}) == 0

		AADD(aRetSM0,aRetAux[nItens])

	ELSEIF Empty(aRetSM0)

		AADD(aRetSM0,aRetAux[nItens])
	
	ENDIF

NEXT nItens

RestArea( aArea )
Return aRetSM0   

/*


š„„„„„„„„„„‚„„„„„„„„„„‚„„„„„„„‚„„„„„„„„„„„„„„„„„„„„„„„‚„„„„„„‚„„„„„„„„„„¿
³Fun€¡€¦o    ³CT0AtuSXG ³ Autor ³ --------------------- ³ Data ³ 18/06/07 ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Descri€¡€¦o ³ Funcao de processamento da gravacao do SXG                 ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³ Uso      ³ ATUALIZACAO SIGACT0                                        ³
€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™


*/
Static Function CT0AtuSXG()

Local aSXG   	:= {}
Local aSXGAlter := {}
Local aEstrut	:= {}
Local i      	:= 0
Local j      	:= 0
Local cTexto 	:= ''
Local cAlias 	:= ''
Local lSXG   	:= .F. 

aEstrut:= { "XG_GRUPO","XG_DESCRI","XG_DESSPA","XG_DESENG","XG_SIZEMAX","XG_SIZEMIN","XG_SIZE","XG_PICTURE"}
			
AADD(aSXG		,{"040","Entidade Contabil 05","Ente Contable 05","Accounting Entity 05",25,6,IIF(Len(oGetDados:aCols) >= 1, oGetDados:aCols[1][18], 6),"@!"})
AADD(aSXG		,{"042","Entidade Contabil 06","Ente Contable 06","Accounting Entity 06",25,6,IIF(Len(oGetDados:aCols) >= 2, oGetDados:aCols[2][18], 6),"@!"})
AADD(aSXG		,{"043","Entidade Contabil 07","Ente Contable 07","Accounting Entity 07",25,6,IIF(Len(oGetDados:aCols) >= 3, oGetDados:aCols[3][18], 6),"@!"})
AADD(aSXG		,{"044","Entidade Contabil 08","Ente Contable 08","Accounting Entity 08",25,6,IIF(Len(oGetDados:aCols) >= 4, oGetDados:aCols[4][18], 6),"@!"})
AADD(aSXG		,{"045","Entidade Contabil 09","Ente Contable 09","Accounting Entity 09",25,6,IIF(Len(oGetDados:aCols) >= 5, oGetDados:aCols[5][18], 6),"@!"})

AADD(aSXGAlter	,{"040","Entidade Contabil 05","Ente Contable 05","Accounting Entity 05",25,6,IIF(Len(oGetDados:aCols) >= 1, oGetDados:aCols[1][18], 6),"@!"})
AADD(aSXGAlter	,{"042","Entidade Contabil 06","Ente Contable 06","Accounting Entity 06",25,6,IIF(Len(oGetDados:aCols) >= 2, oGetDados:aCols[2][18], 6),"@!"})
AADD(aSXGAlter	,{"043","Entidade Contabil 07","Ente Contable 07","Accounting Entity 07",25,6,IIF(Len(oGetDados:aCols) >= 3, oGetDados:aCols[3][18], 6),"@!"})
AADD(aSXGAlter	,{"044","Entidade Contabil 08","Ente Contable 08","Accounting Entity 08",25,6,IIF(Len(oGetDados:aCols) >= 4, oGetDados:aCols[4][18], 6),"@!"})
AADD(aSXGAlter	,{"045","Entidade Contabil 09","Ente Contable 09","Accounting Entity 09",25,6,IIF(Len(oGetDados:aCols) >= 5, oGetDados:aCols[5][18], 6),"@!"})

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
			IncProc(STR0078)//"Atualizando grupo de campos"##"Atualizando grupo de campos"
			
		EndIf
	EndIf
Next i

ProcRegua(Len(aSXGAlter))

dbSelectArea("SXG")
dbSetOrder(1) // FUNCAO
For i:= 1 To Len(aSXGAlter)
	If !Empty(aSXGAlter[i][1])
		If MsSeek(Padr(aSXGAlter[i,1],Len(SXG->XG_GRUPO)))
			lSXG := .T.
			If !(aSXGAlter[i,1]$cAlias)
				cAlias += aSXGAlter[i,1]+"/"
			EndIf
			
			RecLock("SXG",.F.)
			
			For j:=1 To Len(aSXGAlter[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXGAlter[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0078)//"Atualizando grupo de campos"##"Atualizando grupo de campos"
			
		EndIf
	EndIf
Next i

If lSXG
	cTexto := STR0079+cAlias+CRLF //"Grupo de campos atualizados: "
EndIf

Return cTexto

/*


š„„„„„„„„„„‚„„„„„„„„„„‚„„„„„„„‚„„„„„„„„„„„„„„„„„„„„„„„‚„„„„„„‚„„„„„„„„„„¿
³Funcao    ³CT0AtuSX3 ³ Autor ³ --------------------- ³ Data ³ -------- ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Descricao ³Atualiza o tamanho de campos jah existentes e da CV0        ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Uso       ³ATUALIZACAO                                                 ³
€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™


*/
Static Function CT0AtuSX3()

LOCAL aGrupos 	:= {}
LOCAL nQtdEnt 	:= Len(oGetDados:aCols)
LOCAL nNumEnt 	:= 0  
LOCAL nX		:= 0
LOCAL nTamMax	:= 0
LOCAL lSX3		:= .F.

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ 1a Etapa: Ajusta tamanho dos campos jah existentes das entidades ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
AADD(aGrupos,{"040",TamSXG("040")[1]})
AADD(aGrupos,{"042",TamSXG("042")[1]})
AADD(aGrupos,{"043",TamSXG("043")[1]})
AADD(aGrupos,{"044",TamSXG("044")[1]})
AADD(aGrupos,{"045",TamSXG("045")[1]})

nNumEnt := IIF(Len(aGrupos)<nQtdEnt, Len(aGrupos), nQtdEnt)

DbSelectArea("SX3")
DbSetOrder(3) // X3_GRPSXG+X3_ARQUIVO+X3_ORDEM
FOR nX := 1 TO nNumEnt

	nTamMax := IIF(aGrupos[nX][2] > nTamMax, aGrupos[nX][2], nTamMax)

	SX3->(DbSeek(aGrupos[nX][1]))
	WHILE SX3->(!EOF()) .AND. SX3->X3_GRPSXG == aGrupos[nX][1]

		lSX3 := .T.

		RecLock("SX3",.F.)
			SX3->X3_TAMANHO := 	aGrupos[nX][2]
		MsUnLock()		
	
		IF Ascan(aArqUpd,SX3->X3_ARQUIVO) == 0
			aAdd(aArqUpd,SX3->X3_ARQUIVO)
		ENDIF

		SX3->(DbSkip())	
	END

NEXT nX

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³ 2a Etapa: Ajusta o tamanho do campo codigo do CV0                ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
DbSelectArea("SX3")
DbSetOrder(2) // X3_CAMPO
IF DbSeek("CV0_CODIGO")

	RecLock("SX3",.F.)
		SX3->X3_TAMANHO := 	nTamMax
	MsUnLock()

	IF Ascan(aArqUpd,SX3->X3_ARQUIVO) == 0
		aAdd(aArqUpd,SX3->X3_ARQUIVO)
	ENDIF

ENDIF

IF DbSeek("CV0_ENTSUP")

	RecLock("SX3",.F.)
		SX3->X3_TAMANHO := 	nTamMax
	MsUnLock()

	IF Ascan(aArqUpd,SX3->X3_ARQUIVO) == 0
		aAdd(aArqUpd,SX3->X3_ARQUIVO)
	ENDIF

ENDIF

If lSX3
	cTexto := "Campos vinculados aos grupos de campos atualizados"
EndIf

RETURN cTexto
/*


š„„„„„„„„„„‚„„„„„„„„„„‚„„„„„„„‚„„„„„„„„„„„„„„„„„„„„„„„‚„„„„„„‚„„„„„„„„„„¿
³Funcao    ³CT0AtuSXA ³ Autor ³ --------------------  ³ Data ³ -------- ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Descricao ³Funcao de processamento da gravacao do SXA                  ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Uso       ³ATUALIZACAO                                                 ³
€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™


*/
Static Function CT0ATUSXA()
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

AADD(aSXA,{"SA1",ProxSXA("SB1","Orcamento"),"Orcamento","Orcamento","Orcamento","S"})
AADD(aSXA,{"SA2",ProxSXA("SB1","Orcamento"),"Orcamento","Orcamento","Orcamento","S"})
AADD(aSXA,{"SA6",ProxSXA("SB1","Orcamento"),"Orcamento","Orcamento","Orcamento","S"})
AADD(aSXA,{"SB1",ProxSXA("SB1","Orcamento"),"Orcamento","Orcamento","Orcamento","S"})

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
		EndIf
	EndIf
Next i

aSX3 := {}

AADD(aSX3,{"A1_EC05DB",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC05CR",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC06DB",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC06CR",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC07DB",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC07CR",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC08DB",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC08CR",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC09DB",ProxSXA("SA1","Orcamento")})
AADD(aSX3,{"A1_EC09CR",ProxSXA("SA1","Orcamento")})

AADD(aSX3,{"A2_EC05DB",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC05CR",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC06DB",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC06CR",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC07DB",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC07CR",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC08DB",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC08CR",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC09DB",ProxSXA("SA2","Orcamento")})
AADD(aSX3,{"A2_EC09CR",ProxSXA("SA2","Orcamento")})

AADD(aSX3,{"A6_EC05DB",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC05CR",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC06DB",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC06CR",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC07DB",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC07CR",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC08DB",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC08CR",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC09DB",ProxSXA("SA6","Orcamento")})
AADD(aSX3,{"A6_EC09CR",ProxSXA("SA6","Orcamento")})

AADD(aSX3,{"B1_EC05DB",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC05CR",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC06DB",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC06CR",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC07DB",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC07CR",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC08DB",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC08CR",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC09DB",ProxSXA("SB1","Orcamento")})
AADD(aSX3,{"B1_EC09CR",ProxSXA("SB1","Orcamento")})

AADD(aSX3,{"CT5_AT01DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_AT01CR",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_AT02DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_AT02CR",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_AT03DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_AT03CR",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_AT04DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_AT04CR",ProxSXA("CT5","Entidades")})

AADD(aSX3,{"CT5_EC05DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC05CR",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC06DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC06CR",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC07DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC07CR",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC08DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC08CR",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC09DB",ProxSXA("CT5","Entidades")})
AADD(aSX3,{"CT5_EC09CR",ProxSXA("CT5","Entidades")})

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


š„„„„„„„„„„‚„„„„„„„„„„‚„„„„„„„‚„„„„„„„„„„„„„„„„„„„„„„„‚„„„„„„‚„„„„„„„„„„¿
³Funcao    ³ProxSXA   ³ Autor ³ --------------------- ³ Data ³ -------- ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Descricao ³Retorna a pr³xima ordem disponivel no SXA para o ALIAS      ³
ƒ„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„´
³Uso       ³ATUALIZACAO                                                 ³
€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™


*/
Static Function ProxSXA(cAlias,cFolder)

Local aArea 	:= GetArea()
Local aAreaSXA 	:= SXA->(GetArea())
Local nOrdem	:= 0
Local nPosOrdem	:= 0

Static aOrdem	:= {}

Default cFolder	:= ""

IF !Empty(cFolder)
	SXA->(DbSetOrder(1))
	IF SXA->(MsSeek(cAlias))
		While SXA->(!EOF()) .AND. SXA->XA_ALIAS == cAlias
			IF Alltrim(SXA->XA_DESCRIC) == Alltrim(cFolder)
				nOrdem := Val(RetAsc(SXA->XA_ORDEM,2,.F.))
			ENDIF
			SXA->(DbSkip())
		End
	ENDIF
ENDIF

IF Empty(cFolder) .OR. nOrdem == 0

	IF (nPosOrdem := aScan(aOrdem, {|aLinha| aLinha[1] == cAlias})) == 0
	
		SXA->(dbSetOrder(1))
		SXA->(MsSeek(cAlias))
		WHILE SXA->(!EOF()) .AND. SXA->XA_ALIAS == cAlias
			nOrdem++
			SXA->(dbSkip())
		END	
		nOrdem++
		AADD(aOrdem,{cAlias,nOrdem})
	
	ELSE
    	aOrdem[nPosOrdem][2]++
    	nOrdem := aOrdem[nPosOrdem][2]
    ENDIF

ENDIF

RestArea(aAreaSXA)
RestArea(aArea)
Return RetAsc(Str(nOrdem),1,.T.)

/*


‰‘‹‘‹‘»
ºPrograma  ³CTBA910   ºAutor  ³TOTVS Protheus      º Data ³  04/02/12   º
˜ŠŠ¹
ºDesc.     ³                                                            º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function CT910RACol(aHeader)

Local aCols  := {}
Local nX     := 0
Local aArea  := GetArea()
Local cAlias := ""
Local nCols  := 0 
Local aPlano := {}

CT0->(dbSetOrder(1)) //CT0_FILIAL+CT0_ID
CV0->(dbSetOrder(1)) //CV0_FILIAL+CV0_PLANO+CV0_CODIGO

CV0->(dbGoTop())
While CV0->(!Eof())
	
	If aSCan(aPlano,{|cPlano| Alltrim(cPlano) == CV0->CV0_PLANO }) <= 0
		aAdd(aPlano,CV0->CV0_PLANO)
	Else
		CV0->(dbSkip())
		Loop
	EndIf
	
	If CT0->(MsSeek( xFilial("CT0") + CV0->CV0_PLANO ))
		aAdd(aCols,Array(Len(aHeader)+1))
		nCols ++
		For nX := 1 To Len(aHeader)
			
			If "CT0" $ aHeader[nX][02]
				cAlias := "CT0"
			Else
				cAlias := "CV0"
			EndIf

			If ( aHeader[nX][10] != "V")
				aCols[nCols][nX] := (cAlias)->(FieldGet(FieldPos(aHeader[nX][2])))
			ElseIf (aHeader[nX][8] == "M") // Campo Memo
				aCols[nCols][nX] := MSMM((cAlias)->(&(cCPOMemo)), TamSX3(cMemo)[1] )
			Else
				aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
			Endif
			
		Next nX
		aCols[nCols][Len(aHeader)+1] := .F.
	EndIf
	CV0->(dbSkip())
EndDo

RestArea(aArea)
Return aCols

/*


‰‘‹‘‹‘»
ºPrograma  ³CSE901Lk  ºAutor  ³TOTVS Protheus      º Data ³  04/03/12   º
˜ŠŠ¹
ºDesc.     ³Valida§£o LinOk da rotina                                   º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                        º
ˆ¼


*/
User Function CSE901Lk(nLinha)
Local lRet      := .T.
Local aCols     := oGetDados:aCols
Local aHeader   := oGetDados:aHeader
Local nPosAlias := Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_ALIAS"})
Local aPos		:= {}
Local nPosChav  := Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_CPOCHV"})
Local nPosDesc  := Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_CPODSC"})
Local nPosSup   := Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_CPOSUP"})
Local nY        := 0

Default nLinha := oGetDados:nAt

aAdd(aPos,Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_CPOCHV"}))
aAdd(aPos,Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_CPODSC"}))
aAdd(aPos,Ascan(aHeader,{|x|Alltrim(x[2]) == "CT0_CPOSUP"}))


If lRet 
	For nY := 1 to Len(aHeader)
		IF Empty(aCols[nLinha,nY]) .And. nY<9 .And. nY>12
			MSGINFO(STR0022,STR0021) //Existem campos obrigat³rios n£o preenchidos # CTBWizard - Entidades
			lRet := .F.
			Exit
		ENDIF
	Next nY
EndIf   

If lRet
	For nY := 1 to Len(aPos) 
		If !Empty(aCols[nLinha][aPos[nY]])
			cPrefix := PrefixoCpo(aCols[nLinha][nPosAlias])
			If !(cPrefix $ aCols[nLinha][aPos[nY]])
				MSGINFO(STR0076,STR0021) //"O campo deve pertencer a tabela da nova entidade" # CTBWizard - Entidades
				lRet := .F.  
				Exit
			EndIf 
		EndIf
	Next nY
EndIf

Return lRet

/*


‰‘‹‘‹‘»
ºPrograma  ³CTBUpdField ºAutor³Marylly A. Silva	 º Data ³  10/05/12   º
˜ŠŠ¹
ºDesc.     ³Rotina para atualiza§£o de campos do SXx de informa§µes j¡  º
º          ³existentes no dicion¡rio de dados.                          º
˜¹
ºUso       ³ CTBA910                                                    º
ˆ¼


*/
Static Function CTBUpdField(cAlias, nOrder, cIndexKey, cField, uNewValue, uTestValue, bBlockValue)

Local aArea       := (cAlias)->(GetArea())
Local lRet        := .F.
Local nFieldPos   := 0
Local aStruct     := {}
Local nPosField   := 0
Local uValueField := 0

dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(nOrder))

// verifica se o registro existe no alias
If !(cAlias)->(dbSeek(cIndexKey))
	RestArea(aArea)
	Return lRet
EndIf

// verificar se o campo existe no alias
nFieldPos := (cAlias)->(FieldPos(cField))

If nFieldPos == 0
	RestArea(aArea)
	Return lRet
EndIf

aStruct := (cAlias)->(dbStruct())
nPosFIELD := aScan( aStruct ,{|aField|Alltrim(Upper(aField[1])) == Alltrim(Upper(cField)) } )
uValueField := (cAlias)->(FieldGet(nFieldPos))

If bBlockValue == Nil
	
	// teste por valor
	If uTestValue == Nil
		
		If nPosFIELD >0
			If aStruct[nPosFIELD][2] == "C"
				uValueField := AllTrim(uValueField)
				uTestValue  := AllTrim(uNewValue)
			EndIf
		EndIf
		
		// Somente atualiza se o valor gravado no campo (uValueField) for diferente do novo valor (uNewValue)
		lRet := !(uValueField == uTestValue)
		
		If lRet
			RecLock(cAlias, .F.)
			(cAlias)->(FieldPut(nFieldPos, uNewValue))
			MsUnlock()
		EndIf
		
		RestArea(aArea)
		
	Else
		
		If nPosFIELD >0
			// se for caracter deve retirar os brancos e maiusculas antes de comparar.
			If aStruct[nPosFIELD][2] == "C"
				uValueField := AllTrim(Upper(uValueField))
				uTestValue  := AllTrim(Upper(uTestValue))
			EndIf
		EndIf
		
		// se o teste existe, testa e altera o valor
		If uTestValue == uValueField
			RecLock(cAlias, .F.)
			(cAlias)->(FieldPut(nFieldPos, uNewValue))
			MsUnlock()
			
			RestArea(aArea)
			lRet := .T.
		EndIf
	EndIf
Else
	// teste por bloco - nao implementado
EndIf

RestArea(aArea)
Return lRet

/*


‰‘‹‘‹‘»
ºPrograma  ³CtbEntIniVar ºAutor  ³Microsiga        º Data ³  08/02/10   º
˜ŠŠ¹
ºDesc.     ³ Analise da existencia dos campos das novas entidades       º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function CtbEntIniVar(cIdEnt)
Local lExist := .F.
cIdEnt := StrZero(Val(cIdEnt),2)
lExist := CTJ->(FieldPos("CTJ_EC"+cIdEnt+"CR")>0 .And. FieldPos("CTJ_EC"+ cIdEnt + "DB")>0)
Return lExist

/*


‰‘‹‘‹‘»
ºPrograma  ³EntAtuSXB ºAutor  ³TOTVS Protheus      º Data ³  21/02/13   º
˜ŠŠ¹
ºDesc.     ³ Funcao de processamento da gravacao do SXB                 º
º          ³                                                            º
˜¹
ºUso       ³ AP                                                         º
ˆ¼


*/
Static Function EntAtuSXB()
Local aSXB   := {}
Local aAjSXB := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSXB   := .F.

aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}

/*EXEMPLO AJUSTE SXB
Aadd(aSXB,{"AJ8","1","01","DB","Consulta Gerencial","Consulta Gerencial","Consulta Gerencial","AJ8"})
Aadd(aSXB,{"AJ8","2","01","03","Codigo+Entidade Superior","Codigo+Entidade Superior","Codigo+Entidade Superior",""})
Aadd(aSXB,{"AJ8","4","01","01","Codigo","Codigo","Codigo","AJ8_CODPLA"})
Aadd(aSXB,{"AJ8","4","01","02","Codigo da Entidade","Codigo da Entidade","Codigo da Entidade","AJ8_CONTAG"})
Aadd(aSXB,{"AJ8","5","","","","","","AJ8->AJ8_CONTAG"})
Aadd(aSXB,{"AJ8","6","01","01","","","","PmsAJ8F3()"})
*/
/*
ou assim quando for para ajustar somente um campo
	aAdd(aAjSXB, {"AL1","4","01","03",{"XB_CONTEM", "AL1_DESCRI"}})
*/

Aadd(aSXB,{"CT0001","1","01","RE"	,"Entidades Adicionais"	,"Entes Adicionales"	,"Additional Entities"	,"CT0"			})
Aadd(aSXB,{"CT0001","2","01","01"	,""						,""						,""						,".T."			})
Aadd(aSXB,{"CT0001","5","01",""		,""						,""						,""						,"PCOF3PtLan()"	})

ProcRegua(Len(aSXB))

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !dbSeek(Padr(aSXB[i,1], Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
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
			IncProc(STR0082) //"Atualizando consultas padrµes..."
		EndIf
	EndIf
Next i

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aAjSXB)
	If !Empty(aAjSXB[i][1])
		If dbSeek(PadR(aAjSXB[i,1], Len(SXB->XB_ALIAS))+aAjSXB[i,2]+aAjSXB[i,3]+aAjSXB[i,4])
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
				IncProc(STR0082) // //"Atualizando consultas padrµes..."
			EndIf
		EndIf
	EndIf
Next i

If lSXB
	cTexto := STR0083+cAlias+CRLF //'Consultas padrµes atualizadas: '
EndIf

Return cTexto

/*


‰‘‹‘‹‘»
ºPrograma  ³CSE901InfoºAutor  ³TOTVS Protheus      º Data ³ ----------- º
˜ŠŠ¹
ºDesc.     ³Funcao que retorna as informacoes do campo em funcao de sua º
º          ³classificacao como grupo 01 ou grupo 02                     º
˜¹
ºUso       ³ CSEA901 - WIZARD DE CRIACAO DE NOVAS ENTIDADES CONTABEIS   º
ˆ¼


*/
STATIC FUNCTION CSE901Info(cCampo, nEntidade, nOpcInfo)

LOCAL nPosCpo	:= 0
LOCAL cGrupoCpo := 0
LOCAL cRetInfo	:= ""

IF (nPosCpo := aScan(_aGrpCpos,{|aGrpCpo| ALLTRIM(aGrpCpo[1]) == ALLTRIM(cCampo) })) > 0
	cGrupoCpo := _aGrpCpos[nPosCpo][2]
ELSE
	cGrupoCpo := "01"     
	ALERT("CAMPO NAO ENCONTRADO: "+ALLTRIM(cCampo))
ENDIF	

DO CASE

	CASE nOpcInfo == 1 // Titulo 

		IF cGrupoCpo == "01" 
			cRetInfo := oGetDados:aCols[nEntidade][13]
		ELSE
			cRetInfo := oGetDados:aCols[nEntidade][14]
		ENDIF			

	CASE nOpcInfo == 2 // Descricao

		IF cGrupoCpo == "01"
			cRetInfo := oGetDados:aCols[nEntidade][15]
		ELSE
			cRetInfo := oGetDados:aCols[nEntidade][16]
		ENDIF			
	
	CASE nOpcInfo == 3 // Help padrao  

		cRetInfo := oGetDados:aCols[nEntidade][17]
		
ENDCASE

RETURN cRetInfo

/*


‰‘‹‘‹‘»
ºPrograma  ³CSE901CposºAutor  ³TOTVS Protheus      º Data ³ ----------- º
˜ŠŠ¹
ºDesc.     ³Funcao que carrega os arrays aGrpCpo01 e aGrpCpo02 com os   º
º          ³campos conforme a sua classificao                           º
˜¹
ºUso       ³ CSEA901 - WIZARD DE CRIACAO DE NOVAS ENTIDADES CONTABEIS   º
ˆ¼


*/
STATIC FUNCTION CSE901Cpos(nQtdEnt,cFirtEnt)

Local aMatrizCpos 	:= {}
Local aGrpCpos		:= {}
Local cEntAtu		:= cFirtEnt
Local nPosEnt		:= 0
Local cCpoName		:= 0
Local nX			:= 0
Local nY			:= 0

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Carrega Matriz de campos com todos os campos que serao criados pelo Update ³
//³Os campos serao classificados como Grupo 01 e Grupo 02 para tratamento das ³
//³dos titulos e descricoes no SX3 - Dicionario de Dados					  ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Regra para definir se o campo serah classificado como Grupo 01 ou 02		  ³
//³Campos que pertencem ao grupo 01 - referencia direta ao nome da entidade   ³
//³Campos que pertencem ao grupo 02 - mnemonico da entidade + outros dados    ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
AADD(aMatrizCpos,{"A1_EC&&CR","01"})
AADD(aMatrizCpos,{"A1_EC&&DB","01"})
AADD(aMatrizCpos,{"AK2_ENT&&","02"})
AADD(aMatrizCpos,{"AKC_ENT&&","02"})
AADD(aMatrizCpos,{"AKD_ENT&&","02"})
AADD(aMatrizCpos,{"AKI_ENT&&","02"})
AADD(aMatrizCpos,{"ALJ_ENT&&","02"})
AADD(aMatrizCpos,{"AMJ_ENT&&","02"})
AADD(aMatrizCpos,{"AMK_ENT&&","02"})
AADD(aMatrizCpos,{"AMZ_ENT&&","02"})
AADD(aMatrizCpos,{"A2_EC&&CR","01"})
AADD(aMatrizCpos,{"A2_EC&&DB","01"})
AADD(aMatrizCpos,{"CT1_&&OBRG","01"})
AADD(aMatrizCpos,{"CT1_ACET&&","01"})
AADD(aMatrizCpos,{"CTA_ENTI&&","02"})
AADD(aMatrizCpos,{"CTB_E&&DES","02"})
AADD(aMatrizCpos,{"CTB_E&&FIM","02"})
AADD(aMatrizCpos,{"CTB_E&&INI","02"})
AADD(aMatrizCpos,{"A6_EC&&CR","01"})
AADD(aMatrizCpos,{"A6_EC&&DB","01"})
AADD(aMatrizCpos,{"CTQ_E&&CP","02"})
AADD(aMatrizCpos,{"CTQ_E&&ORI","02"})
AADD(aMatrizCpos,{"CTQ_E&&PAR","02"})
AADD(aMatrizCpos,{"CTS_E&&FIM","02"})
AADD(aMatrizCpos,{"CTS_E&&INI","02"})
AADD(aMatrizCpos,{"CV1_E&&FIM","02"})
AADD(aMatrizCpos,{"CV1_E&&INI","02"})
AADD(aMatrizCpos,{"CV5_E&&DES","02"})
AADD(aMatrizCpos,{"CV5_E&&FIM","02"})
AADD(aMatrizCpos,{"CV5_E&&IGU","02"})
AADD(aMatrizCpos,{"CV5_E&&ORI","02"})
AADD(aMatrizCpos,{"CV9_E&&CP","02"})
AADD(aMatrizCpos,{"CV9_E&&ORI","02"})
AADD(aMatrizCpos,{"CV9_E&&PAR","02"})
AADD(aMatrizCpos,{"CVX_NIV&&","02"})
AADD(aMatrizCpos,{"CVY_NIV&&","02"})
AADD(aMatrizCpos,{"CVZ_NIV&&","02"})
AADD(aMatrizCpos,{"FNE_ENT&&A","02"})
AADD(aMatrizCpos,{"FNE_ENT&&B","02"})
AADD(aMatrizCpos,{"FNE_ENT&&D","02"})
AADD(aMatrizCpos,{"FNF_ENT&&","02"})
AADD(aMatrizCpos,{"FNU_ENT&&","02"})
AADD(aMatrizCpos,{"AGG_EC&&CR","01"})
AADD(aMatrizCpos,{"AGG_EC&&DB","01"})
AADD(aMatrizCpos,{"AGH_EC&&CR","01"})
AADD(aMatrizCpos,{"AGH_EC&&DB","01"})
AADD(aMatrizCpos,{"B1_EC&&CR","01"})
AADD(aMatrizCpos,{"B1_EC&&DB","01"})
AADD(aMatrizCpos,{"C1_EC&&CR","01"})
AADD(aMatrizCpos,{"C1_EC&&DB","01"})
AADD(aMatrizCpos,{"C2_EC&&CR","01"})
AADD(aMatrizCpos,{"C2_EC&&DB","01"})
AADD(aMatrizCpos,{"C7_EC&&CR","01"})
AADD(aMatrizCpos,{"C7_EC&&DB","01"})
AADD(aMatrizCpos,{"CH_EC&&CR","01"})
AADD(aMatrizCpos,{"CH_EC&&DB","01"})
AADD(aMatrizCpos,{"CNB_EC&&CR","01"})
AADD(aMatrizCpos,{"CNB_EC&&DB","01"})
AADD(aMatrizCpos,{"N3_EC&&CDE","02"})
AADD(aMatrizCpos,{"N3_EC&&CON","02"})
AADD(aMatrizCpos,{"N3_EC&&COR","02"})
AADD(aMatrizCpos,{"N3_EC&&CTA","02"})
AADD(aMatrizCpos,{"N3_EC&&DEP","02"})
AADD(aMatrizCpos,{"N3_EC&&DES","02"})
AADD(aMatrizCpos,{"N4_ENT&&","02"})
AADD(aMatrizCpos,{"N7_ENT&&","02"})
AADD(aMatrizCpos,{"NG_EC&&CDE","02"})
AADD(aMatrizCpos,{"NG_EC&&CON","02"})
AADD(aMatrizCpos,{"NG_EC&&COR","02"})
AADD(aMatrizCpos,{"NG_EC&&CTA","02"})
AADD(aMatrizCpos,{"NG_EC&&DEP","02"})
AADD(aMatrizCpos,{"NG_EC&&DES","02"})
AADD(aMatrizCpos,{"NM_EC&&BEM","02"})
AADD(aMatrizCpos,{"NM_EC&&COR","02"})
AADD(aMatrizCpos,{"NM_EC&&DEP","02"})
AADD(aMatrizCpos,{"NM_EC&&DES","02"})
AADD(aMatrizCpos,{"NM_EC&&DSP","02"})
AADD(aMatrizCpos,{"NN_EC&&CDE","02"})
AADD(aMatrizCpos,{"NN_EC&&CON","02"})
AADD(aMatrizCpos,{"NN_EC&&DEP","02"})
AADD(aMatrizCpos,{"NQ_EC&&CDE","02"})
AADD(aMatrizCpos,{"NR_EC&&CDE","02"})
AADD(aMatrizCpos,{"NS_ENT&&","02"})
AADD(aMatrizCpos,{"NV_ENT&&","02"})
AADD(aMatrizCpos,{"NW_NIV&&","02"})
AADD(aMatrizCpos,{"NX_NIV&&","02"})
AADD(aMatrizCpos,{"NY_NIV&&","02"})
AADD(aMatrizCpos,{"CNE_EC&&CR","01"})
AADD(aMatrizCpos,{"CNE_EC&&DB","01"})
AADD(aMatrizCpos,{"CP_EC&&CR","01"})
AADD(aMatrizCpos,{"CP_EC&&DB","01"})
AADD(aMatrizCpos,{"CQ_EC&&CR","01"})
AADD(aMatrizCpos,{"CQ_EC&&DB","01"})
AADD(aMatrizCpos,{"CT2_EC&&CR","01"})
AADD(aMatrizCpos,{"CT2_EC&&DB","01"})
AADD(aMatrizCpos,{"CT5_EC&&CR","01"})
AADD(aMatrizCpos,{"CT5_EC&&DB","01"})
AADD(aMatrizCpos,{"CT9_EC&&CR","01"})
AADD(aMatrizCpos,{"CT9_EC&&DB","01"})
AADD(aMatrizCpos,{"CTJ_EC&&CR","01"})
AADD(aMatrizCpos,{"CTJ_EC&&DB","01"})
AADD(aMatrizCpos,{"CTK_EC&&CR","01"})
AADD(aMatrizCpos,{"CTK_EC&&DB","01"})
AADD(aMatrizCpos,{"CTZ_EC&&CR","01"})
AADD(aMatrizCpos,{"CTZ_EC&&DB","01"})
AADD(aMatrizCpos,{"CV3_EC&&CR","01"})
AADD(aMatrizCpos,{"CV3_EC&&DB","01"})
AADD(aMatrizCpos,{"CV4_EC&&CR","01"})
AADD(aMatrizCpos,{"CV4_EC&&DB","01"})
AADD(aMatrizCpos,{"CX_EC&&CR","01"})
AADD(aMatrizCpos,{"CX_EC&&DB","01"})
AADD(aMatrizCpos,{"CY_EC&&CR","01"})
AADD(aMatrizCpos,{"CY_EC&&DB","01"})
AADD(aMatrizCpos,{"D1_EC&&CR","01"})
AADD(aMatrizCpos,{"D1_EC&&DB","01"})
AADD(aMatrizCpos,{"D2_EC&&CR","01"})
AADD(aMatrizCpos,{"D2_EC&&DB","01"})
AADD(aMatrizCpos,{"D3_EC&&CR","01"})
AADD(aMatrizCpos,{"D3_EC&&DB","01"})
AADD(aMatrizCpos,{"DE_EC&&CR","01"})
AADD(aMatrizCpos,{"DE_EC&&DB","01"})
AADD(aMatrizCpos,{"DG_EC&&CR","01"})
AADD(aMatrizCpos,{"DG_EC&&DB","01"})
AADD(aMatrizCpos,{"E1_EC&&CR","01"})
AADD(aMatrizCpos,{"E1_EC&&DB","01"})
AADD(aMatrizCpos,{"E2_EC&&CR","01"})
AADD(aMatrizCpos,{"E2_EC&&DB","01"})
AADD(aMatrizCpos,{"E3_EC&&CR","01"})
AADD(aMatrizCpos,{"E3_EC&&DB","01"})
AADD(aMatrizCpos,{"E5_EC&&CR","01"})
AADD(aMatrizCpos,{"E5_EC&&DB","01"})
AADD(aMatrizCpos,{"E7_EC&&CR","01"})
AADD(aMatrizCpos,{"E7_EC&&DB","01"})
AADD(aMatrizCpos,{"EA_EC&&CR","01"})
AADD(aMatrizCpos,{"EA_EC&&DB","01"})
AADD(aMatrizCpos,{"ED_EC&&CR","01"})
AADD(aMatrizCpos,{"ED_EC&&DB","01"})
AADD(aMatrizCpos,{"EF_EC&&CR","01"})
AADD(aMatrizCpos,{"EF_EC&&DB","01"})
AADD(aMatrizCpos,{"EH_EC&&CR","01"})
AADD(aMatrizCpos,{"EH_EC&&DB","01"})
AADD(aMatrizCpos,{"ET_EC&&CR","01"})
AADD(aMatrizCpos,{"ET_EC&&DB","01"})
AADD(aMatrizCpos,{"EU_EC&&CR","01"})
AADD(aMatrizCpos,{"EU_EC&&DB","01"})
AADD(aMatrizCpos,{"EZ_EC&&CR","01"})
AADD(aMatrizCpos,{"EZ_EC&&DB","01"})

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//³Carrega array aGrpCpos com o conteudo da Matriz de campos explodida em     ³
//³funcao das entidades que serao criadas pela rotina.                        ³
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™

For nX := 1 to nQtdEnt

	For nY := 1 to Len(aMatrizCpos)

		cCpoName := aMatrizCpos[nY][1]
		nPosEnt	 := AT("&",cCpoName)
		cCpoName := Stuff(cCpoName,nPosEnt,2,cEntAtu)
		
		AADD(aGrpCpos,{cCpoName,aMatrizCpos[nY][2]})

	Next nY

	cEntAtu := SOMA1(cEntAtu)
	
Next nX

RETURN aGrpCpos