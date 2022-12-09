//#include "PMSA100.CH"
#include "protheus.ch"     
#include "rwmake.ch"
#include "TCBROWSE.CH"
//#include "pmsicons.ch"

//#define STR0008  "Fechar"
//#define STR0002  
//#define STR0003  "Visualizar"

Static STR0001 := "Preparacao do Projeto"
Static STR0004 := "Gerar"
Static STR0005 := "Gerando Projeto..."
Static STR0006 := "Usuário sem permissão"
Static STR0007 := "Usuário sem permissão para gerar projeto deste orçamento. Verifique as permissões do usuário na estrutura principal do orçamento."

STATIC __lBlind		:= IsBlind()

	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

// Melhoria de performance
#command PMS_TRUNCA <val1>, <val2>, <val3>, <val4>, <val5>, <Dec1>, <Dec2>, <Dec3>, <Dec4>, <Dec5>, <QtTsk>, <Trunca>, <Total> TO <var1>, <var2>, <var3>, <var4>, <var5>	;
																																												;
  => if <Total>																																							  		;
   ; 	if <Trunca>$"13"																																						;
   ; 		<var1>+=NoRound(<val1>,<Dec1>)																																		;
   ; 		<var2>+=NoRound(<val2>,<Dec2>)																																		;
   ; 		<var3>+=NoRound(<val3>,<Dec3>)																																		;
   ; 		<var4>+=NoRound(<val4>,<Dec4>)																																		;
   ; 		<var5>+=NoRound(<val5>,<Dec5>)																																		;
   ; 	else																																									;
   ; 		<var1>+=Round(<val1>,<Dec1>)																																		;
   ; 		<var2>+=Round(<val2>,<Dec2>)																																		;
   ; 		<var3>+=Round(<val3>,<Dec3>)																																		;
   ; 		<var4>+=Round(<val4>,<Dec4>)																																		;
   ; 		<var5>+=Round(<val5>,<Dec5>)																																		;
   ; 	endif																																									;
   ; elseif <Trunca>$"1"																																						;
   ; 	<var1>+=NoRound(<val1>*<QtTsk>,<Dec1>)																																	;
   ; 	<var2>+=NoRound(<val2>*<QtTsk>,<Dec2>)																																	;
   ; 	<var3>+=NoRound(<val3>*<QtTsk>,<Dec3>)																																	;
   ; 	<var4>+=NoRound(<val4>*<QtTsk>,<Dec4>)																																	;
   ; 	<var5>+=NoRound(<val5>*<QtTsk>,<Dec5>)																																	;
   ; elseif <Trunca>$"2"					   																																	;
   ; 	<var1>+=Round(<val1>*<QtTsk>,<Dec1>)																																	;
   ; 	<var2>+=Round(<val2>*<QtTsk>,<Dec2>)																																	;
   ; 	<var3>+=Round(<val3>*<QtTsk>,<Dec3>)																																	;
   ; 	<var4>+=Round(<val4>*<QtTsk>,<Dec4>)																																	;
   ; 	<var5>+=Round(<val5>*<QtTsk>,<Dec5>)																																	;
   ; elseif <Trunca>$"3"					 																																	;
   ; 	<var1>+=NoRound(NoRound(<val1>,<Dec1>)*<QtTsk>,<Dec1>)																													;
   ; 	<var2>+=NoRound(NoRound(<val2>,<Dec2>)*<QtTsk>,<Dec2>)																													;
   ; 	<var3>+=NoRound(NoRound(<val3>,<Dec3>)*<QtTsk>,<Dec3>)																													;
   ; 	<var4>+=NoRound(NoRound(<val4>,<Dec4>)*<QtTsk>,<Dec4>)																													;
   ; 	<var5>+=NoRound(NoRound(<val5>,<Dec5>)*<QtTsk>,<Dec5>)																													;
   ; else									  																																	;
   ; 	<var1>+=Round(Round(<val1>,<Dec1>)*<QtTsk>,<Dec1>)																														;
   ; 	<var2>+=Round(Round(<val2>,<Dec2>)*<QtTsk>,<Dec2>)																														;
   ; 	<var3>+=Round(Round(<val3>,<Dec3>)*<QtTsk>,<Dec3>)																														;
   ; 	<var4>+=Round(Round(<val4>,<Dec4>)*<QtTsk>,<Dec4>)																														;
   ; 	<var5>+=Round(Round(<val5>,<Dec5>)*<QtTsk>,<Dec5>)																														;
   ; endif


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PMSA100  ³ Autor ³ Edson Maricate        ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de manutecao de orcamentos de projetos.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// modo de visualização do projeto
#define PMS_VIEW_TREE  1
#define PMS_VIEW_SHEET 2

// tarefa e EDT
#define PMS_TASK  1
#define PMS_WBS   2

// separador de path
#define PMS_PATH_SEP If(IsSrvUnix(), "/", "\")

// separador de extensão
#define PMS_EXT_SEP "."

// extensão do arquivo de planilha,
// tanto de orçamento quanto para projeto
#define PMS_SHEET_EXT  PMS_EXT_SEP + "pln"
#define PMS_BITMAP_EXT PMS_EXT_SEP + "bmp"

// valor de indentação na configuração de colunas (modo planilha)
#define PMS_SHEET_INDENT 4

// data mínima e data máxima
#define PMS_MAX_DATE   CToD("31/12/2050")
#define PMS_MIN_DATE   CToD("01/01/1980")

// hora mínima e hora máxima
#define PMS_MIN_HOUR "00:00"
#define PMS_MAX_HOUR "23:59"

// inicializadores
#define PMS_EMPTY_DATE   CToD("  /  /    ")
#define PMS_EMPTY_STRING ""

// folders
#define PMS_PROFILE_DIR PMS_PATH_SEP + "profile"

// item alocado na tarefa
#define PMS_ITEM_UNKNOWN  0
#define PMS_ITEM_PRODUCT  1
#define PMS_ITEM_RESOURCE 2
#define PMS_ITEM_RESOURCE_PRODUCT PMS_ITEM_RESOURCE + PMS_ITEM_PRODUCT

//
// constantes ad hoc
//

// constantes utilizadas na toolbar

// constantes contendo os nome de arquivos
// de bitmaps, utilizadas na toolbar
#define BMP_AVANCAR_CAL     "PMSSETADIR"
#define BMP_CANCEL          "CANCEL"
#define BMP_COLUNAS         "SDUFIELDS"
#define BMP_CORES           "PMSCOLOR"
#define BMP_DATA            "BTCALEND"
#define BMP_DOCUMENTOS      "CLIPS"
#define BMP_FERRAMENTAS     "INSTRUME"
#define BMP_FILTRO          "FILTRO"
#define BMP_IMPRIMIR        "IMPRESSAO"
#define BMP_OPCOES          "NCO"
#define BMP_ORC_ESTRUTURA   "SDUSTRUCT"
#define BMP_ORC_IMPRESSAO   "IMPRESSAO"
#define BMP_ORC_INFO        "UPDWARNING"
#define BMP_PESQUISAR       "PESQUISA"
#define BMP_PROJ_APONT      "NCO"
#define BMP_PROJ_CONSULTAS  "GRAF2D"
#define BMP_PROJ_ESTRUTURA  "SDUSTRUCT"
#define BMP_PROJ_EXECUCAO   "PROJETPMS"
#define BMP_PROJ_INFO       "UPDWARNING"
#define BMP_PROJ_PROG_FIS   "SELECTALL"
#define BMP_PROJ_USUARIOS   "BMPUSER"
#define BMP_REAJUS_CUSTO    "PRECO"
#define BMP_RETROCEDER_CAL  "PMSSETAESQ"
#define BMP_SAIR            "CANCEL"

//
// definicao dos resources utilizados no PMS
//
#define BMP_EDT1             "BPMSEDT1"
#define BMP_EDT2             "BPMSEDT2"
#define BMP_EDT3             "BPMSEDT3"
#define BMP_EDT4             "BPMSEDT4"
#define BMP_TASK1            "PMSTASK1"
#define BMP_TASK2            "PMSTASK2"
#define BMP_TASK3            "PMSTASK3"
#define BMP_TASK4            "PMSTASK4"
#define BMP_USER             "BMPUSER"
#define BMP_USER_PQ          "BMPUSER_PQ"
#define BMP_EXPALL           "PMSEXPALL"
#define BMP_EXPCMP           "PMSEXPCMP"
#define BMP_SHORTCUTMINUS    "SHORTCUTMINUS"
#define BMP_SHORTCUTPLUS     "SHORTCUTPLUS"
#define BMP_CLIPS_PQ         "CLIPS_PQ"
#define BMP_RELAC_DIREITA_PQ "RELACIONAMENTO_DIREITA_PQ"
#define BMP_SETA_UP          "PMSSETAUP"
#define BMP_SETA_DOWN        "PMSSETADOWN"
#define BMP_SETA_TOP         "PMSSETATOP"
#define BMP_ZOOM_OUT         "PMSZOOMOUT"
#define BMP_ZOOM_IN          "PMSZOOMIN"
#define BMP_SETA_BOTTOM      "PMSSETABOT"
#define BMP_IMPRESSAO        "IMPRESSAO"
#define BMP_SETA_DIREITA     "PMSSETADIR"
#define BMP_SETA_ESQUERDA    "PMSSETAESQ"
#define BMP_SALVAR           "SALVAR"
#define BMP_RELOAD           "RELOAD"
#define BMP_PESQUISA         "PESQUISA"
#define BMP_RELATORIO        "RELATORIO"
#define BMP_DOCUMENT         "PMSDOC"
#define BMP_RECURSO          "BPMSREC"
#define BMP_MATERIAL         "PMSMATE"
#define BMP_FAIXA_SUPERIOR   "PMSSUPE"
#define BMP_PROJETOAP        "PROJETOAP"
#define BMP_FAIXA_SUP_PADRAO "FAIXASUPERIOR"

#define BMP_EDT4_INCLUIDO    "BPMSEDT4I"
#define BMP_EDT4_EXCLUIDO    "BPMSEDT4E"
#define BMP_EDT4_ALTERADO    "BPMSEDT4A"

#define BMP_TASK3_INCLUIDO    "BPMSTSK3I"
#define BMP_TASK3_EXCLUIDO    "BPMSTSK3E"
#define BMP_TASK3_ALTERADO    "BPMSTSK3A"

#define BMP_BUDGET            "BUDGET"
#define BMP_INTERROGACAO      "S4WB016N"

#define BMP_RECURSO_INCLUIDO  "BPMSRECI"
#define BMP_RECURSO_EXCLUIDO  "BPMSRECE"
#define BMP_RECURSO_ALTERADO  "BPMSRECA"

#define BMP_RELACIONAMENTO_INCLUIDO "BPMSRELAI"
#define BMP_RELACIONAMENTO_ALTERADO "BPMSRELAA"
#define BMP_RELACIONAMENTO_EXCLUIDO "BPMSRELAE"

#define BMP_CHECKED                 "CHECKED"
#define BMP_NOCHECKED               "NOCHECKED"
#define BMP_SDUPROP                 "SDUPROP"

#define BMP_NEXT                    "NEXT"
#define BMP_PROCESSA                "PROCESSA"

#define BMP_TRIANGULO_DOWN          "TRIDOWN"
#define BMP_TRIANGULO_UP            "TRIUP"
#define BMP_TRIANGULO_LEFT          "TRILEFT"
#define BMP_TRIANGULO_RIGHT         "TRIRIGHT"

#define BMP_LOGIN                   "LOGIN"

#define BMP_EXCEL                   "MDIEXCEL"
#define BMP_OUTLOOK "OUTLOOK"

#define BMP_OPEN                    "OPEN"
#define BMP_E5                      "E5"

#define BMP_OK                      "OK"
#define BMP_CANCELA                 "CANCEL"

#define BMP_RELACIONAMENTO_DIREITA  "RELACIONAMENTO_DIREITA"

#define BMP_TOOLBAR                 "TOOLBAR"
#define BMP_TABLE                   "BMPTABLE"
#define BMP_TABLE_PQ                "BMPTABLE_PQ"

#define BMP_CHECKBOX                 "LBOK"
#define BMP_UNCHECKBOX               "LBNO"

#define BMP_CINZA                    "BR_CINZA"
#define BMP_VERDE                    "BR_VERDE"
#define BMP_VERMELHO                 "BR_VERMELHO"
#define BMP_AMARELO                  "BR_AMARELO"
#define BMP_AZUL                     "BR_AZUL"

#define BMP_SIMULACAO_ALOCACAO_RECURSOS "GRAF2D"

// as constantes abaixo estao presentes
// no arquivo pmsicona.ch

// seus nomes comecam com STR0P para evitar
// conflito com strings ja existentes

// descricoes dos botoes da toolbar
#define TOOL_AVANCAR_CAL    "Avancar"
#define TOOL_CANCEL         "Cancelar"
#define TOOL_COLUNAS        "Colunas"
#define TOOL_CORES          "Cores"
#define TOOL_DATA           "Data"
#define TOOL_DOCUMENTOS     "Docum."
#define TOOL_FERRAMENTAS    "Ferramentas"
#define TOOL_FILTRO         "Filtro"
#define TOOL_IMPRIMIR       "Imprimir"
#define TOOL_OPCOES         "Opcoes"
#define TOOL_ORC_ESTRUTURA  "Estrut."
#define TOOL_ORC_IMPRESSAO  "Imprimir"
#define TOOL_ORC_INFO       "Inform."
#define TOOL_PESQUISAR      "Pesquisar"
#define TOOL_PROJ_APONT     "Apont."
#define TOOL_PROJ_CONSULTAS "Consultas"
#define TOOL_PROJ_ESTRUTURA "Estrut."
#define TOOL_PROJ_EXECUCAO  "Execucao"
#define TOOL_PROJ_INFO      "Inform."
#define TOOL_PROJ_PROG_FIS  "Prg. Fis."
#define TOOL_PROJ_USUARIOS  "Usuarios"
#define TOOL_REAJUS_CUSTO   "Custo"
#define TOOL_RETROCEDER_CAL "Retroceder"
#define TOOL_SAIR           "Sair"

// tooltips dos botoes da toolbar
#define TIP_AVANCAR_CAL     "Avancar Calendario"
#define TIP_CANCEL          "Cancelar"
#define TIP_COLUNAS         "Configurar colunas"
#define TIP_CORES           "Configurar cores do grafico"
#define TIP_DATA            "Data"
#define TIP_DOCUMENTOS      "Documentos"
#define TIP_FERRAMENTAS     "Ferramentas"
#define TIP_FILTRO          "Filtrar visualizacao"
#define TIP_IMPRIMIR        "Imprimir"
#define TIP_OPCOES          "Opcoes do Grafico"
#define TIP_ORC_ESTRUTURA   "Estrutura do Orcamento"
#define TIP_ORC_IMPRESSAO   "Impressao do Orcamento"
#define TIP_ORC_INFO        "Informacoes do Orcamento"
#define TIP_PESQUISAR      	 "Pesquisar"
#define TIP_PROJ_APONT      "Apontamentos do Projeto"
#define TIP_PROJ_CONSULTAS  "Consultas"
#define TIP_PROJ_ESTRUTURA  "Estrutura do Projeto"
#define TIP_PROJ_EXECUCAO   "Gerenciamento de execucao"
#define TIP_PROJ_INFO       "Informacoes do Projeto"
#define TIP_PROJ_PROG_FIS   "Progresso Fisico do Projeto"
#define TIP_PROJ_USUARIOS   "Usuarios"
#define TIP_REAJUS_CUSTO    "Reajustar Custo Previsto"
#define TIP_RETROCEDER_CAL  "Retroceder Calendario"
#define TIP_SAIR            "Sair"

// constantes para o array de simulações
// de tarefas na realocação
#define SIM_QTDELEM   16
#define SIM_RECAF9     1
#define SIM_START      2
#define SIM_HORAI      3
#define SIM_FINISH     4
#define SIM_HORAF      5
#define SIM_REVISA     6
#define SIM_RECURS     7
#define SIM_ALOC       8
#define SIM_PRIORI     9
#define SIM_HDURAC    10
#define SIM_QUANT     11
#define SIM_PROJETO   12
#define SIM_TAREFA    13
#define SIM_CALEND    14
#define SIM_DESCRI    15
#define SIM_PREDEC    16

#define ATA_PROJINFO       "0100."
#define ATA_COLUNAS        "0200."
#define ATA_FERRAMENTAS    "0300."
#define ATA_FILTRO         "0400."
#define ATA_PROJ_CONSULTAS "0500."
#define ATA_PROJ_ESTRUTURA "0600."
#define ATA_DOCUMENTOS     "0700."
#define ATA_PROJ_EXECUCAO  "0800."
#define ATA_PROJ_PROG_FIS  "0900."
#define ATA_PROJ_APONT     "1000."

User Function PMSAL100(nCallOpcx)

PRIVATE cCadastro	:= "Orcamentos"
PRIVATE aMemos  :={{"AF1_CODMEM","AF1_OBS"}}
PRIVATE aCores  := PmsAF1Color()
PRIVATE nDlgPln := PMS_VIEW_TREE

PRIVATE aHandCOT	:= {}
PRIVATE aRotina := MenuDef()

Set Key VK_F12 To FAtiva()

	Pergunte("PMA100",.F.)
	nDlgPln := mv_par01
	dbSelectArea("AF1")
	dbSetOrder(1)
	If nCallOpcx <> Nil
		U_PMSAL1a("AF1",AF1->(Recno()),nCallOpcx)    
	Else
		mBrowse(6,1,22,75,"AF1",,,,,,aCores)
	Endif                                    
    //comentado bloco abaixo , pois a mesma tratativa sera feita via JOB apos expediente LH ACTUAL 18/01/17
    /*
	//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170110]
	SZ2->(dbCommit())
	cQuery := "UPDATE "
	cQuery += RetSqlName("SZ2")+" "	
	cQuery += "SET 		Z2_DTFIM  = '"+Dtos(dDatabase)+ "', Z2_HRFIM = '"+time()+"' "
	cQuery += "WHERE 	Z2_USR	  = '"+__cuserid+"' AND Z2_NOMEUSR = '"+cusername+"' "
	cQuery += "			AND Z2_DTINI = '"+Dtos(dDatabase)+"' "  
	cQuery += "			AND Z2_DTFIM = ' ' "
	cQuery += "			AND D_E_L_E_T_=' ' "					
	TcSqlExec(cQuery)
	//fim bloco [Mauro Nagata, Actual Trend, 20170110]
    */


Set Key VK_F12 To 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100Leg³ Autor ³  Fabio Rogerio Pereira ³ Data ³ 18-03-2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Exibicao de Legendas                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PMSA100, SIGAPMS                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100Leg(cAlias,nReg,nOpcx)
Local aLegenda:= {}
Local i       := 0

For i:= 1 To Len(aCores)
	Aadd(aLegenda,{aCores[i,2],aCores[i,3]})
Next i
                             
BrwLegenda(cCadastro,"Legenda" ,aLegenda) //

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAL1a  ³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Inclusao,Alteracao,Visualizacao e Exclusao       ³±±
±±³          ³ de Orcamentos.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PMSA100, SIGAPMS                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMSAL1a(cAlias,nReg,nOpcx)

Local oTree 
Local nz
Local lOk
Local oDlg
Local l100Inclui	:= .F.
Local l100Visual	:= .F.
Local l100Altera	:= .F.
Local l100Exclui	:= .F.
Local lContinua 	:= .T.
Local cArquivo		:= CriaTrab(,.F.)
Local lConfExcTe  := .T.
Local cSearch     := Space(TamSX3("AFC_DESCRI")[1])
Local lRefresh := .T.
Local aAreaAF1
Local aMenuAt	:=	{}
Local lChgCols	:=	.F.

PRIVATE aBAtalhos	:=	{}
PRIVATE bBlocoAtalho:=	{}
Private lEmAtalho	:=	.F.
PRIVATE cCmpPLN
PRIVATE cArqPLN
PRIVATE cPLNVer := ''
PRIVATE cPLNDescri	:= ''
PRIVATE lSenha		:= .F.
PRIVATE cPLNSenha	:= ""                      
PRIVATE nFreeze		:= 0
PRIVATE nIndent		:= PMS_SHEET_INDENT

PRIVATE cArqAux := cArquivo

// define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)
Do Case
	Case aRotina[nOpcx][4] == 2
		l100Visual 	:= .T.
	Case aRotina[nOpcx][4] == 3
		Inclui		:= .T.
		l100Inclui	:= .T.
	Case aRotina[nOpcx][4] == 4
		Altera		:= .T.
		l100Altera	:= .T.
	Case aRotina[nOpcx][4] == 5
		lOk			:= .F.	
		l100Exclui	:= .T.
		l100Visual	:= .T.
EndCase
//henrique 30/06
If l100Exclui 

	If !Empty(AF1->AF1_XVERS)
		DbSelectArea('SZ2')
		DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+AF1->AF1_XVERS)
		  //  if AF1->AF1_FASE <>'01' .OR. AF1->AF1_FASE <>'03'
		 //	msgAlert('Para excluir esse orçamento FASE DEVE SER ALTERADA PARA 01 OU 03 e a a versão deve ser FECHADA !!!', "A T E N Ç Ã O")      
		 //	return
		 //	endif
				If Empty(SZ2->Z2_DTFIM)
				msgAlert('Para excluir esse orçamento é necessário que seja FECHADA a versão!!!', "A T E N Ç Ã O")
				Return
		     	ENDIF
		 ENDIF
	ENDIF	
endif
				//henrique 30/06
//If l100Exclui .or. l100Altera
   if l100Altera // henrique
	If !Empty(AF1->AF1_XVERS)
		DbSelectArea('SZ2')
		DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+AF1->AF1_XVERS)
			If !Empty(SZ2->Z2_DTFIM)
				msgAlert('Para alterar esse orçamento é necessário que seja criada uma nova versão!!!', "A T E N Ç Ã O")
				Return
			ElseIf SZ2->Z2_USR <> __cuserid
				msgAlert('O usuário: '+Alltrim(SZ2->Z2_NOMEUSR)+' está alterando esse orçamento, é necessário que ele encerre essa versão para que outro usuário possa alterar!!!', "A T E N Ç Ã O")
				Return
			EndIf
		Else
			msgAlert('Para alterar esse orçamento é necessário que seja criada uma nova versão!!!', "A T E N Ç Ã O")
			Return
		EndIf
	Else
		msgAlert('Para alterar esse orçamento é necessário que seja criada uma nova versão!!!', "A T E N Ç Ã O")
		Return
	EndIf


EndIf


If l100Exclui
	// verifica o evento de Exclusao no Fase atual.
	If !PmsVldFase("AF1",AF1->AF1_ORCAME,"12")
		lContinua := .F.
	EndIf
EndIf


If l100Altera

	// verifica o evento de alteracao no Fase atual.
	If !PmsVldFase("AF1",AF1->AF1_ORCAME,"11")
		lContinua := .F.
	EndIf
	If lContinua .And. ExistBlock("PMS100A3")
		ExecBlock("PMS100A3",.F.,.F.)
	EndIf
EndIf

If lContinua

	// utiliza a funcao axInclui para incluir o Orcamento.
	If l100Inclui
		If ExistBlock("PMA100Inc")
			If ExecBlock("PMA100Inc")
				Return						
			EndIf
		EndIf
		
		If lContinua := ! ( AxInclui(cAlias,nReg,nOpcx,,,,"U_aPMSAL100()") <> 1 )

			If ExistBlock("PMA100Prj")
				ExecBlock("PMA100Prj", .F., .F.)			
			EndIf
	
			// Cria um registro na lista de EDTs
			DbSelectArea("AF5")

			RecLock("AF5",.T.)
			AF5->AF5_FILIAL	:= xFilial("AF5")
			AF5->AF5_ORCAME	:= AF1->AF1_ORCAME
			AF5->AF5_EDT    := AF1->AF1_ORCAME
			AF5->AF5_DESCRI	:= AF1->AF1_DESCRI
			AF5->AF5_NIVEL	:= "001"
			AF5->AF5_UM		:= "UN"
			AF5->AF5_QUANT	:= 1
			MsUnlock() 
			
			// cria os direitos de acesso para o usuario que criou o orçamento
			DbSelectArea("AJF")

			RecLock("AJF",.T.)
			AJF->AJF_FILIAL := xFilial("AJF")
			AJF->AJF_ORCAME := AF1->AF1_ORCAME
			AJF->AJF_EDT	:= AF5->AF5_EDT
			AJF->AJF_USER	:= __cUserID
			AJF->AJF_ESTRUT	:= "3"
			AJF->AJF_DOCUME	:= "4"
			AJF->AJF_PROJET	:= "2"  
			MsUnlock()
	
			DbSelectArea("AF1")

		EndIf
	EndIf
    
	If lContinua
		If !l100Visual
			MENU oMenu2 POPUP
				If l100Inclui .Or. l100Altera
					MENUITEM "Reajustar Custo" ACTION (Pms100AltCus(),RestArea(aAreaAF1),Eval(bRefresh)) //
					MENUITEM "Recalculo do Custo" ACTION (u_LIS100ReCalc(),RestArea(aAreaAF1),Eval(bRefresh)) //
					MENUITEM "Recodificar" ACTION (RecodeOrc(@oTree, cArquivo), Eval(bRefresh)) //
					MENUITEM "Substituir" ACTION (Processa({|| PMS100Subs()}) , Eval(bRefresh)) //
				EndIf
			ENDMENU

			For nZ	:=	1	To Len(oMenu2:aItems)
				AAdd(aMenuAt,{ATA_FERRAMENTAS+"A"+STRZERO(nZ,2),1,oMenu2:aItems[nZ]:cCaption,oMenu2:aItems[nZ]:bAction,oMenu2,Nil})
			Next
		
			MENU oMenu POPUP
				MENUITEM "Incluir EDT" ACTION (PMS100to101(3,@oTree,"1",cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Incluir Tarefa" ACTION (PMS100to101(3,@oTree,"2",cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Alterar" ACTION (PMS100to101(4,@oTree,,cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Visualizar" ACTION PMS100to101(2,@oTree,,cArquivo) //"Visualizar"
				MENUITEM "Excluir" ACTION (PMS100to101(5,@oTree,,cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Copiar EDT/Tarefa de Orcamento" ACTION (PMS100Import(oTree,cArquivo,1),RestArea(aAreaAF1),Eval(bRefresh)) //
				MENUITEM "Copiar EDT/Tarefa de Projeto" ACTION (PMS100Import(oTree,cArquivo,2),RestArea(aAreaAF1),Eval(bRefresh)) //
				MENUITEM "Importar Composição" ACTION (If(LIS101CMP(AF8->(RecNo()),@oTree,cArquivo),(RestArea(aAreaAF1),Eval(bRefresh)),Nil)) //
				MENUITEM "Trocar EDT Pai" ACTION (PMS100ChangeEDT(@oTree,cArquivo),RestArea(aAreaAF1),Eval(bRefresh)) //
				MENUITEM "Associar Composicao" ACTION (If(PMS101Cmp2(AF8->(RecNo()),@oTree,cArquivo),(RestArea(aAreaAF1),Eval(bRefresh)),Nil))  //

				If nDlgPln == PMS_VIEW_TREE
					MENUITEM "Procurar..." ACTION Procurar(oTree, @cSearch, cArquivo) //
					MENUITEM "Procurar proxima" ACTION ProcurarP(oTree, @cSearch, cArquivo) //
				EndIf
			ENDMENU
			
			For nZ	:=	1	To Len(oMenu:aItems)
				AAdd(aMenuAt,{ATA_PROJ_ESTRUTURA+"A"+STRZERO(nZ,2),1,oMenu:aItems[nZ]:cCaption,oMenu:aItems[nZ]:bAction,oMenu,Nil})
			Next
				

			If nDlgPln == PMS_VIEW_TREE
				// modo arvore
				aMenu := {;
				         {TIP_ORC_INFO,      {||PmsOrcInf()}, BMP_ORC_INFO, TOOL_ORC_INFO},;
				         {TIP_FERRAMENTAS,   {||A100CtrMenu(@oMenu,oTree,l100Visual,cArquivo, oMenu2, nDlgPln),oMenu2:Activate(35,45,oDlg)}, BMP_FERRAMENTAS, TOOL_FERRAMENTAS},;
				         {TIP_ORC_ESTRUTURA, {||A100CtrMenu(@oMenu,oTree,l100Visual,cArquivo, , nDlgPln),oMenu:Activate(75,45,oDlg) }, BMP_ORC_ESTRUTURA, TOOL_ORC_ESTRUTURA}} //"Estrutura"
			Else
				// modo planilha
				aMenu := {;
				         {TIP_ORC_INFO,      {||PmsOrcInf()}, BMP_ORC_INFO, TOOL_ORC_INFO},;
				         {TIP_COLUNAS,       {||Iif(lChgCols := PMC050Cfg("", 0, 0),oDlg:End(), Nil)}, BMP_COLUNAS, TOOL_COLUNAS},;
				         {TIP_FERRAMENTAS,   {||A100CtrMenu(@oMenu,oTree,l100Visual,cArquivo, oMenu2, nDlgPln),oMenu2:Activate(35,45,oDlg)}, BMP_FERRAMENTAS, TOOL_FERRAMENTAS},;
				         {TIP_ORC_ESTRUTURA, {||A100CtrMenu(@oMenu,oTree,l100Visual,cArquivo, , nDlgPln),oMenu:Activate(105,45,oDlg) }, BMP_ORC_ESTRUTURA, TOOL_ORC_ESTRUTURA}} //"Estrutura"
			EndIf
		Else
			MENU oMenu POPUP
				MENUITEM "Visualizar" ACTION PMS100to101(2,@oTree,,cArquivo) //"Visualizar"

				If nDlgPln == PMS_VIEW_TREE
					MENUITEM "Procurar..." ACTION Procurar(oTree, @cSearch, cArquivo) //"Procurar..."
					MENUITEM "Procurar proxima" ACTION ProcurarP(oTree, @cSearch, cArquivo) //"Procurar proxima"
				EndIf
			ENDMENU

			For nZ	:=	1	To Len(oMenu:aItems)
				AAdd(aMenuAt,{ATA_PROJ_ESTRUTURA+"A"+STRZERO(nZ,2),1,oMenu:aItems[nZ]:cCaption,oMenu:aItems[nZ]:bAction,oMenu,Nil})
			Next

			
			If nDlgPln == PMS_VIEW_TREE
				// modo arvore
				aMenu := {;
				         {TIP_ORC_INFO,      {||PmsOrcInf()}, BMP_ORC_INFO, TOOL_ORC_INFO},;
				         {TIP_ORC_ESTRUTURA, {||A100CtrMenu(@oMenu,oTree,l100Visual,cArquivo,,nDlgPln),oMenu:Activate(75,45,oDlg) }, BMP_ORC_ESTRUTURA, TOOL_ORC_ESTRUTURA}}
			Else
				// modo planilha
				aMenu := {;
				         {TIP_ORC_INFO,      {||PmsOrcInf()}, BMP_ORC_INFO, TOOL_ORC_INFO},;
				         {TIP_COLUNAS,       {||Iif(lChgCols := PMC050Cfg("", 0, 0),oDlg:End(), Nil)}, BMP_COLUNAS, TOOL_COLUNAS},;
				         {TIP_ORC_ESTRUTURA, {||A100CtrMenu(@oMenu,oTree,l100Visual,cArquivo,,nDlgPln),oMenu:Activate(75,45,oDlg) }, BMP_ORC_ESTRUTURA, TOOL_ORC_ESTRUTURA}}
			EndIf
		EndIf
		If l100Exclui		
			If ExistBlock("PMA100EX")
				lConfExcTe := ExecBlock("PMA100EX", .F., .F.)
			EndIf
		EndIf

		AAdd(aMenu, {"Atalhos",  {|| SetAtalho(aMenuAt,aMenu,.T.)}, "ATALHO", "Atalhos"})  //"Atalhos"##"Atalhos"
	
		// le os atalhos desde o profile
		CarregaAtalhos(aMenu,aMenuAt,Iif(l100Visual,"V","A")	)
		
		// configura as teclas de atalho
	 	SetAtalho(aMenuAt,aMenu,.F.)


		aAreaAF1 := AF1->(GetArea())
		
		If lConfExcTe
			If nDlgPln == PMS_VIEW_SHEET
				aCampos := {{"AF2_TAREFA","AF5_EDT",8,,,.F.,"",},{"AF2_DESCRI","AF5_DESCRI",55,,,.F.,"",150}}
				//A100ChkPln(@aCampos)
				
				//
				// MV_PMSCPLN
				//				
				// 1 - a configuração da planilha é utilizada exclusivamente pelo usuário que criou
				// 2 - a configuração da planilha é utilizada por qualquer usuário (default)
				//
				
				If GetNewPar("MV_PMSCPLN", 2) == 1
					A100Opn(@aCampos, "\profile\pmsa100." + __cUserID)
				Else
					A100Opn(@aCampos)
				EndIf
				
				PmsPlanAF1(cCadastro,aCampos,@cArquivo,,,@lOk,aMenu,@oDlg,,nIndent)
			Else 
				PmsDlgAF1(cCadastro,@oMenu,@oTree,,{||A100CtrMenu(@oMenu,oTree,l100Visual,cArquivo,,nDlgPln)},@lOk,aMenu,@oDlg)
			EndIf
		Else
			lOk := .T.
		EndIf

		// grava os atalhos no profile.
		GravaAtalhos(aMenuAt,Iif(l100Visual,"V","A")	)

		If ExistBlock("PMA100Sa")
			ExecBlock("PMA100Sa", .F., .F., {nOpcx})		
		EndIf

		If lChgCols
			U_PMSAL1a(cAlias, nReg, nOpcx)
		Else
			If l100Exclui .And. lOk
				Begin Transaction
					MaExclAF1(,AF1->(RECNO()))
				End Transaction	
			EndIf
			If l100Altera
				If ExistBlock("PMS100A4")
					ExecBlock("PMS100A4",.F.,.F.)
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

FreeUsedCode(.T.)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100to101³ Autor ³ Cristiano G.da Cunha ³ Data ³ 15.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de controle de chamada da PMSA101.( Incl/Excl/Alt/Vis. ³±±
±±³          ³de tarefas).                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100,SIGAPMS                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100to101(nOpc,oTree,cEDT,cArquivo,lRefresh)

Local aArea		:= GetArea()
//Local cLastItem	:= "00"
Local cOrcamento
Local cNivAtu
Local cTrfAtu
Local cNivelAF5

Local aGetCpos


If oTree!= Nil
	cAlias	:= SubStr(oTree:GetCargo(),1,3)
	nRecAlias	:= Val(SubStr(oTree:GetCargo(),4,12))
Else 
	cAlias := (cArquivo)->ALIAS
	nRecAlias := (cArquivo)->RECNO
	If nOpc == 3
		If cAlias == "AF2"
			Aviso("Opcao invalida.","A tarefa e o ultimo elemento na estrutura do projeto. Novos niveis e tarefas so poderao ser adicionados a uma EDT.",{"Ok"},2) //######
			Return
		EndIf
	EndIf
Endif

dbSelectArea(cAlias)
dbGoto(nRecAlias)
Do Case
	Case nOpc == 3
		If cEDT == "1"
			cNivelAF2 := If(cAlias=="AF5",AF5->AF5_NIVEL,"000")
			If cNivelAF2 <> "000"
				cOrcamento	:= AF5->AF5_ORCAME
				cNivAtu		:= AF5->AF5_NIVEL
				cTrfAtu		:= AF5->AF5_EDT
			EndIf
			aGetCpos := {	{"AF5_ORCAME",AF1->AF1_ORCAME,.F.},;
							{"AF5_EDTPAI",cTrfAtu,.F.}}
		   
			If GetNewPar("MV_PMSTCOD","1")=="2"
				aAdd(aGetCpos,{"AF5_EDT",PmsNumAF5(AF1->AF1_ORCAME,cNivelAF2,cTrfAtu,,.F.),.F.})
			EndIf
										
			nRecAF2	:= PMSA101(3,aGetCpos,cNivelAF2,@lRefresh)
			If nRecAF2 <> Nil .And. cArquivo == Nil
				PMSTreeOrc(@oTree)
			EndIf
		Else
			cNivelAF5 := If(cAlias=="AF5",AF5->AF5_NIVEL,"000")
			If cNivelAF5 <> "000"
				cOrcamento	:= AF5->AF5_ORCAME
				cNivAtu		:= AF5->AF5_NIVEL
				cTrfAtu		:= AF5->AF5_EDT
			EndIf

			aGetCpos := {	{"AF2_ORCAME",AF1->AF1_ORCAME,.F.},;
							{"AF2_EDTPAI",cTrfAtu,.F.}}

			If AF2->(FieldPos('AF2_BDI')) > 0 
				If AF1->(FieldPos('AF1_BDIPAD')) > 0 
					aAdd(aGetCpos,{"AF2_BDI",AF1->AF1_BDIPAD,.T.})
				Else
					aAdd(aGetCpos,{"AF2_BDI",AF1->AF1_BDI,.T.})
				EndIf
			EndIf
			If GetNewPar("MV_PMSTCOD","1")=="2"
				aAdd(aGetCpos,{"AF2_TAREFA",PmsNumAF2(AF1->AF1_ORCAME,cNivelAF5,cTrfAtu,,.F.),.F.})
			EndIf

			nRecAF2	:= PMSA103(3,aGetCpos,cNivelAF5,@lRefresh)
		EndIf
	Case nOpc == 2 .And. cAlias == "AF5"
		PMSA101(2,,"000",@lRefresh)
	Case nOpc == 2 .And. cAlias == "AF2"
		PMSA103(2,,"000",@lRefresh)
	Case nOpc == 4 .And. cAlias == "AF5"
		PMSA101(4,,"000",@lRefresh)
	Case nOpc == 4 .And. cAlias == "AF2"
		PMSA103(4,,"000",@lRefresh)
	Case nOpc == 5 .And. cAlias == "AF5"
		PMSA101(5,,"000",@lRefresh)
	Case nOpc == 5 .And. cAlias == "AF2"
		PMSA103(5,,"000",@lRefresh)
EndCase

FreeUsedCode(.T.)

RestArea(aArea)
Return	
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100Alt³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de alteracao no cadastro do Orcamento.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100,SIGAPMS                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function myPMS100Alt(cAlias,nReg,nOpcx)
Local nOpc
Local aCposAlt	:= {"AF1_FASE","AF1_TRUNCA","AF1_BDI","AF1_ENCARG","AF1_SALBAS"}
Local aOldVal	:= {}
Local lRecalc	:= .F.
Local nx

// verifica o evento de alteracao no Fase atual.
If !PmsVldFase("AF1",AF1->AF1_ORCAME,"11")
	Return
EndIf

If PmsOrcUser(AF1->AF1_ORCAME,,Padr(AF1->AF1_ORCAME,Len(AF5->AF5_EDT)),"  ",3,"ESTRUT")

	If !Empty(AF1->AF1_XVERS)
		DbSelectArea('SZ2')
		DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+AF1->AF1_XVERS)
			If !Empty(SZ2->Z2_DTFIM)
				msgAlert('Para alterar esse orçamento é necessário que seja criada uma nova versão!!!', "A T E N Ç Ã O")
				Return
			ElseIf SZ2->Z2_USR <> __cuserid
				msgAlert('O usuário: '+Alltrim(SZ2->Z2_NOMEUSR)+' está alterando esse orçamento, é necessário que ele encerre essa versão para que outro usuário possa alterar!!!', "A T E N Ç Ã O")
				Return
			EndIf
		Else
			msgAlert('Para alterar esse orçamento é necessário que seja criada uma nova versão!!!', "A T E N Ç Ã O")
			Return
		EndIf
	Else
		msgAlert('Para alterar esse orçamento é necessário que seja criada uma nova versão!!!', "A T E N Ç Ã O")
		Return
	EndIf

	If ExistBlock("PMS100A1")
		ExecBlock("PMS100A1",.F.,.F.)
	EndIf
	
	For nx := 1 to Len(aCposAlt)
		If AF1->(FieldPos(aCposAlt[nx])) > 0
			aAdd(aOldVal,{aCposAlt[nx],AF1->(FieldGet(AF1->(FieldPos(aCposAlt[nx]))))})
		EndIf
	Next
	nOpc := AxAltera(cAlias,nReg,nOpcx,,,,,"U_aPMSAL100()")
	
	If nOpc == 1
	
		// verifica a existencia do ponto de entrada PMS100A2
		If ExistBlock("PMS100A2")
			ExecBlock("PMS100A2",.F.,.F.,{nOpc})
		EndIf
	
		For nX := 1 to Len(aCposAlt)
			If AF1->(FieldPos(aCposAlt[nX])) > 0 .AND. (nPos := aScan( aOldVal,{|xValor| xValor[1] == aCposAlt[nX]}))>0
				If aOldVal[nPos][2] <> AF1->(FieldGet(AF1->(FieldPos(aCposAlt[nX]))))
					lRecalc := (Aviso("Atencao!","Foram alteradas algumas configurações que podem influenciar diretamente no custo deste orçamento. Voce deseja recalcular o custo neste momento ?",{"Sim","Mais Tarde"},2)==1) //#########"Mais Tarde"
					Exit
				EndIf
			EndIf
		Next nX
		
		If (AF1->(FieldPos("AF1_RECALC"))>0.And.AF1->AF1_RECALC=="1") .Or. AF1->(FieldPos("AF1_RECALC"))<=0 .Or. lRecalc
			u_LIS100ReCalc()
		EndIf
		
	EndIf  
	//COMENTADO BLOCO ABAIXO , POIS esse tratamento sera feito via JOB apos expediente  LH ACTUAL 18/01/17
	/*
	//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170110]
	SZ2->(dbCommit())
	cQuery := "UPDATE "
	cQuery += RetSqlName("SZ2")+" "	
	cQuery += "SET 		Z2_DTFIM  = '"+Dtos(dDatabase)+ "', Z2_HRFIM = '"+time()+"' "
	cQuery += "WHERE 	Z2_USR	  = '"+__cuserid+"' AND Z2_NOMEUSR = '"+cusername+"' "
	cQuery += "			AND Z2_DTINI = '"+Dtos(dDatabase)+"' "  
	cQuery += "			AND Z2_DTFIM = ' ' "
	cQuery += "			AND D_E_L_E_T_=' ' "					
	TcSqlExec(cQuery)
	//fim bloco [Mauro Nagata, Actual Trend, 20170110]
	*/ 
Else
	Aviso("Usuário sem permissão","Usuário sem permissão para alteração nos usuários do orçamento. Verifique as permissões do usuário na estrutura principal do orçamento.",{"Fechar"},2) //######
EndIf

	
	
Return nOpc
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100Cli³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida o codigo do cliente digitado.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100,SIGAPMS                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100Cli()
Local lRet 

If Empty(M->AF1_LOJA)
	lRet := Vazio() .Or. ExistCpo("SA1",M->AF1_CLIENT)
Else
	lRet := Vazio() .Or. ExistCpo("SA1",M->AF1_CLIENT+M->AF1_LOJA)
EndIf


Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100Ok³ Autor ³ Edson Maricate          ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao TudoOk do cadastro de Orcamentos.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100,SIGAPMS                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function aPMSAL100()

Local lRet	:= .T.


If !Empty(M->AF1_CLIENT) .And. Empty(M->AF1_LOJA)
	HELP("   ",1,"PMSA10001")
	lRet := .F.
EndIf

If Empty(M->AF1_CLIENT) .And. !Empty(M->AF1_LOJA)
	HELP("   ",1,"PMSA10002")
	lRet := .F.
EndIf

If !MayIUseCode("AF1" + xFilial("AF1") + M->AF1_ORCAME)
	lRet := .F.
EndIf

If M->AF1_FASE = '04' .and. Empty(M->AF1_XDTPRP)
	msgAlert('Verifique a data da proposta', 'A T E N Ç Ã O')
	lRet := .F.
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A100CtrMenu³ Autor ³ Edson Maricate       ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que controla as propriedades do Menu PopUp.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A100CtrMenu(oMenu,oTree,lVisual,cArquivo,oMenu2,nDlgPln)
Local aArea		:= GetArea()
Local cAlias
Local nRecView
If oTree == Nil
	cAlias	:= (cArquivo)->ALIAS
	nRecView	:= (cArquivo)->RECNO
Else
	cAlias	:= SubStr(oTree:GetCargo(),1,3)
	nRecView	:= Val(SubStr(oTree:GetCargo(),4,12))
EndIf

dbSelectArea(cAlias)
dbGoto(nRecView)

If !lVisual

	If oMenu2 <> Nil
		oMenu2:aItems[1]:Enable()
		oMenu2:aItems[2]:Enable()
		oMenu2:aItems[4]:Enable()
	EndIf

	Do Case 
		Case cAlias == "AF5" .And. AF5->AF5_NIVEL=="001"
			If PmsOrcUser(AF5->AF5_ORCAME,,AF5->AF5_EDT,AF5->AF5_EDTPAI,3,"ESTRUT")
				oMenu:aItems[1]:Enable()
				oMenu:aItems[2]:Enable()
				oMenu:aItems[3]:Enable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Disable()
				oMenu:aItems[6]:Enable()
				oMenu:aItems[7]:Enable()
				oMenu:aItems[8]:Enable()
				oMenu:aItems[10]:Disable()

				If oMenu2 <> Nil
					oMenu2:aItems[3]:Enable()
				EndIf				
			ElseIf PmsOrcUser(AF5->AF5_ORCAME,,AF5->AF5_EDT,AF5->AF5_EDTPAI,2,"ESTRUT")
				oMenu:aItems[1]:Disable()
				oMenu:aItems[2]:Disable()
				oMenu:aItems[3]:Enable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Disable()
				oMenu:aItems[6]:Disable()
				oMenu:aItems[7]:Disable()
				oMenu:aItems[8]:Disable()
				oMenu:aItems[10]:Disable()

				If oMenu2 <> Nil
					oMenu2:aItems[3]:Enable()
				EndIf								
			Else
				oMenu:aItems[1]:Disable()
				oMenu:aItems[2]:Disable()
				oMenu:aItems[3]:Disable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Disable()
				oMenu:aItems[6]:Disable()
				oMenu:aItems[7]:Disable()
				oMenu:aItems[8]:Disable()
				oMenu:aItems[10]:Disable()

				If oMenu2 <> Nil
					oMenu2:aItems[3]:Disable()
				EndIf								
			EndIf

		Case cAlias == "AF5" .And. AF5->AF5_NIVEL!="001"
			If PmsOrcUser(AF5->AF5_ORCAME,,AF5->AF5_EDT,AF5->AF5_EDTPAI,3,"ESTRUT")
				oMenu:aItems[1]:Enable()
				oMenu:aItems[2]:Enable()
				oMenu:aItems[3]:Enable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Enable()
				oMenu:aItems[6]:Enable()
				oMenu:aItems[7]:Enable()
				oMenu:aItems[8]:Enable()
				oMenu:aItems[10]:Disable()

				If oMenu2 <> Nil
					oMenu2:aItems[3]:Enable()
				EndIf								
			ElseIf PmsOrcUser(AF5->AF5_ORCAME,,AF5->AF5_EDT,AF5->AF5_EDTPAI,2,"ESTRUT")
				oMenu:aItems[1]:Disable()
				oMenu:aItems[2]:Disable()
				oMenu:aItems[3]:Enable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Disable()
				oMenu:aItems[6]:Disable()
				oMenu:aItems[7]:Disable()
				oMenu:aItems[8]:Disable()
				oMenu:aItems[10]:Disable()

				If oMenu2 <> Nil
					oMenu2:aItems[3]:Enable()
				EndIf								
			Else
				oMenu:aItems[1]:Disable()
				oMenu:aItems[2]:Disable()
				oMenu:aItems[3]:Disable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Disable()
				oMenu:aItems[6]:Disable()
				oMenu:aItems[7]:Disable()
				oMenu:aItems[8]:Disable()
				oMenu:aItems[10]:Disable()

				If oMenu2 <> Nil
					oMenu2:aItems[3]:Disable()
				EndIf								
			EndIf
			
		Case cAlias == "AF2" 
			If PmsOrcUser(AF2->AF2_ORCAME,AF2->AF2_TAREFA,,AF2->AF2_EDTPAI,3,"ESTRUT")
				oMenu:aItems[1]:Disable()
				oMenu:aItems[2]:Disable()
				oMenu:aItems[3]:Enable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Enable()
				oMenu:aItems[6]:Disable()
				oMenu:aItems[7]:Disable()
				oMenu:aItems[8]:Disable()
				oMenu:aItems[10]:Enable()
				If oMenu2 <> Nil
					oMenu2:aItems[3]:Enable()
				EndIf							
			ElseIf PmsOrcUser(AF2->AF2_ORCAME,AF2->AF2_TAREFA,,AF2->AF2_EDTPAI,3,"ESTRUT")
				oMenu:aItems[1]:Disable()
				oMenu:aItems[2]:Disable()
				oMenu:aItems[3]:Enable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Disable()
				oMenu:aItems[6]:Disable()
				oMenu:aItems[7]:Disable()
				oMenu:aItems[8]:Disable()
				oMenu:aItems[10]:Enable()
				If oMenu2 <> Nil
					oMenu2:aItems[3]:Enable()
				EndIf							
			Else
				oMenu:aItems[1]:Disable()
				oMenu:aItems[2]:Disable()
				oMenu:aItems[3]:Disable()
				oMenu:aItems[4]:Enable()
				oMenu:aItems[5]:Disable()
				oMenu:aItems[6]:Disable()
				oMenu:aItems[7]:Disable()
				oMenu:aItems[8]:Disable()
				oMenu:aItems[10]:Disable()
			EndIf
		Otherwise
			oMenu:aItems[1]:Disable()
			oMenu:aItems[2]:Disable()
			oMenu:aItems[3]:Disable()
			oMenu:aItems[4]:Disable()
			oMenu:aItems[5]:Disable()
			oMenu:aItems[6]:Disable()
			oMenu:aItems[7]:Disable()
			oMenu:aItems[8]:Disable()
			oMenu:aItems[10]:Disable()

			If oMenu2 <> Nil
				oMenu2:aItems[3]:Disable()
			EndIf							
	EndCase
	
EndIf

RestArea(aArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FAtiva   ³ Autor ³ Edson Maricate        ³ Data ³ 18.10.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama a&pergunte                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PMSA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FAtiva()
Pergunte("PMA100",.T.)
nDlgPln := mv_par01

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A100ChkPln³ Autor ³ Cristiano G. da Cunha ³ Data ³ 15.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica quais os campos que devem aparecer na planilha.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function A100ChkPln(aCampos,cMV1,cMV2)

Local cCampos
DEFAULT cMV1 := "MV_PMSPLNA"
DEFAULT cMV2 := "MV_PMSPLNB"

dbSelectArea("SX6")
dbSetOrder(1)
If !( dbSeek( "  " + cMV1 ) )
	RecLock("SX6",.T.)
	Replace X6_FIL    With "  "
	Replace X6_VAR    With cMV1
	Replace X6_TIPO   With "C"
	Replace X6_CONTEUD  With "_HDURAC#_CALEND#"
	Replace X6_CONTENG  With ""
	Replace X6_CONTSPA  With ""
	Replace X6_DESCRIC  With "Parametro que indica quais os campos que devem  "
	Replace X6_DESC1    With "aparecer na planilha do programa PMSA100.       "
	
	Replace X6_DSCSPA   With "Parametro que indica  los campos que deben  "
	Replace X6_DSCSPA1  With "aparecer en la planilla del programa PMSA100.    " 

	
	Replace X6_DSCENG   With "This parameter indicates the fields that must be" 
	Replace X6_DSCENG1  With "displayed in PMSA100 program`s worksheet.       " 

EndIf

dbSelectArea("SX6")
dbSetOrder(1)
If !( dbSeek( "  " + cMV2 ) )
	RecLock("SX6",.T.)
	Replace X6_FIL    With "  "
	Replace X6_VAR    With cMV2
	Replace X6_TIPO   With "C"
	Replace X6_CONTEUD  With ""
	Replace X6_CONTENG  With ""
	Replace X6_CONTSPA  With ""
	Replace X6_DESCRIC  With "Parametro que indica quais os campos que devem  "
	Replace X6_DESC1    With "aparecer na planilha do programa PMSA100.       "
	
	Replace X6_DSCSPA   With "Parametro que indica  los campos que deben  "
	Replace X6_DSCSPA1  With "aparecer en la planilla del programa PMSA100.    " 
	
	Replace X6_DSCENG   With "This parameter indicates the fields that must be" 
	Replace X6_DSCENG1  With "displayed in PMSA100 program`s worksheet.       " 
EndIf

cCampos := Alltrim(GetMv(cMV1))
cCampos += Alltrim(GetMv(cMV2))

While !Empty(AllTrim(cCampos))
	If AT("#",cCampos) > 0
		cAux := Substr(cCampos,1,AT("#",cCampos)-1)
		aAdd(aCampos,{"AF2"+cAux,"AF5"+cAux,,,,.F.,"",})
	    cCampos := Substr(cCampos,AT("#",cCampos)+1,Len(cCampos)-AT("#",cCampos))
	 Else
	 	cCampos := ''
	 EndIf
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100Import³ Autor ³Fabio Rogerio Pereira³ Data ³ 09-01-2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa de copia de EDT/Tarefas de outro orcamento           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100Import(oTree,cArquivo,nOrcPrj)
Local lRet     := .F.
Local aImport  := {}
Local aArea    := GetArea()
Local aAreaAF1 := AF1->(GetArea())
Local aAreaAF2 := AF2->(GetArea())
Local aAreaAF5 := AF5->(GetArea())

Local aMarkPrj := {}
                  
If oTree != Nil
	cAlias:= SubStr(oTree:GetCargo(),1,3)
	nRecno:= Val(SubStr(oTree:GetCargo(),4,12))
Else
	cAlias := (cArquivo)->ALIAS
	nRecNo := (cArquivo)->RECNO
EndIf

// exibe uma tela de selecao dos orcamentos/projetos para importacao
If nOrcPrj == 1
	aImport := PmsSelTsk("Selecione a EDT/Tarefa","AF1/AF5/AF2","AF5/AF2","Selecao Invalida","AF1",,,.T.,,@aMarkPrj) //###
Else
	aImport := PmsSelTsk("Selecione a EDT/Tarefa","AF8/AFC/AF9","AFC/AF9","Selecao Invalida",,,,.T.,,@aMarkPrj) //###
EndIf

If ExistBlock("PM100Cpy")
	lRet := ExecBlock("PM100Cpy", .F., .F.)

	If lRet
		RestArea(aArea)
		Return !lRet
	EndIf
EndIf

If (Len(aImport) > 0)
       Processa({|| lRet := PmsOrcCopy(cAlias,nRecno,aImport[1],aImport[2],nOrcPrj,aMarkPrj)}, "Copiando estrutura...")  //
EndIf

If ExistBlock("PM100POC")
	ExecBlock("PM100POC", .F., .F.)
EndIf

RestArea(aAreaAF5)
RestArea(aAreaAF2)
RestArea(aAreaAF1)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100ETarefa³ Autor ³Fabio Rogerio Pereira³ Data ³29.04.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa o array com os itens a serem copiados.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100ETarefa(cOrcame,cChave,cCampo,nOrdem)
Local aArea		:= GetArea()
Local aStru     := {}
Local aAreaAF2	:= AF2->(GetArea())
Local aAreaAF3	:= AF3->(GetArea())
Local aAreaAF4	:= AF4->(GetArea())
Local aAreaAF7	:= AF7->(GetArea())
Local aTarefas	:= {}
Local nTarefa   := 0
Local nItem		:= 0

DEFAULT cOrcame:= AF2->AF2_ORCAME
DEFAULT cCampo := AF2->AF2_TAREFA
DEFAULT cCampo := "AF2->AF2_TAREFA"
DEFAULT nOrdem := 1

dbSelectArea("AF2")
dbSetOrder(nOrdem)
dbSeek(xFilial("AF2") + cOrcame + cChave,.T.)

While !Eof() .And. (AF2->AF2_FILIAL == xFilial("AF2")) .And. (AF2->AF2_ORCAME == cOrcame) .And. (&(cCampo) == cChave)

	// inicializa o array da tarefa
	aStru := AF2->(dbStruct())
  	aAdd(aTarefas,{AF2->AF2_TAREFA,Array(Len(aStru)),{},{},{},{}})
  
  	nTarefa:= Len(aTarefas)


	// armazena os dados da tarefa
	dbSelectArea("AF2")
	AEval(aStru,{|cValue,nX|aTarefas[nTarefa,2,nX]:= {aStru[nX,1],FieldGet(FieldPos(aStru[nX,1]))}})

	// pesquisa todos os produtos da tarefa
	dbSelectArea("AF3")
	dbSetOrder(1)
	dbSeek(xFilial("AF3") + AF2->AF2_ORCAME + AF2->AF2_TAREFA)
	aStru := AF3->(dbStruct())

	While !Eof() .And. (AF3->AF3_FILIAL+AF3->AF3_ORCAME+AF3->AF3_TAREFA == ;
						xFilial("AF3")+AF2->AF2_ORCAME+AF2->AF2_TAREFA)

		aAdd(aTarefas[nTarefa,3],Array(Len(aStru)))
		nItem:= Len(aTarefas[nTarefa,3])
		
		AEval(aStru,{|cValue,nX|aTarefas[nTarefa,3,nItem,nX]:= {aStru[nX,1],FieldGet(FieldPos(aStru[nX,1]))}})

		dbSelectArea("AF3")
		dbSkip()
	End
	
	// pesquisa todas as despesas da tarefa
	dbSelectArea("AF4")
	dbSetOrder(1)
	dbSeek(xFilial("AF4") + AF2->AF2_ORCAME + AF2->AF2_TAREFA)
	aStru := AF4->(dbStruct())

	While !Eof() .And. (AF4->AF4_FILIAL+AF4->AF4_ORCAME+AF4->AF4_TAREFA == ;
						xFilial("AF4")+AF2->AF2_ORCAME+AF2->AF2_TAREFA)

		aAdd(aTarefas[nTarefa,4],Array(Len(aStru)))
		nItem:= Len(aTarefas[nTarefa,4])
		
		AEval(aStru,{|cValue,nX|aTarefas[nTarefa,4,nItem,nX]:= {aStru[nX,1],FieldGet(FieldPos(aStru[nX,1]))}})
		dbSelectArea("AF4")
		dbSkip()
	End

	// pesquisa todas os relacionamentos da tarefa
	dbSelectArea("AF7")
	dbSetOrder(1)
	dbSeek(xFilial("AF7") + AF2->AF2_ORCAME + AF2->AF2_TAREFA)
	aStru := AF7->(dbStruct())

	While !Eof() .And. (AF7->AF7_FILIAL+AF7->AF7_ORCAME+AF7->AF7_TAREFA == ;
						xFilial("AF7")+AF2->AF2_ORCAME+AF2->AF2_TAREFA)

		aAdd(aTarefas[nTarefa,5],Array(Len(aStru)))
		nItem:= Len(aTarefas[nTarefa,5])
		
		AEval(aStru,{|cValue,nX|aTarefas[nTarefa,5,nItem,nX]:= {aStru[nX,1],FieldGet(FieldPos(aStru[nX,1]))}})
		
		dbSelectArea("AF7")
		dbSkip()
	End

	// pesquisa todos os documentos da tarefa
	dbSelectArea("AC9")
	dbSetOrder(2)
	dbSeek(xFilial("AC9") + "AF2" + AF2->AF2_FILIAL + AF2->AF2_ORCAME + AF2->AF2_TAREFA)

	aStru := AC9->(dbStruct())

	While !Eof() .And. (AllTrim(AC9->AC9_FILIAL + AC9->AC9_ENTIDA + AC9->AC9_FILENT + AC9->AC9_CODENT) == ;
						 AllTrim(xFilial("AC9") + "AF2" + xFilial("AF2") + AF2->AF2_ORCAME+AF2->AF2_TAREFA))

		aAdd(aTarefas[nTarefa,6],Array(Len(aStru)))
		nItem:= Len(aTarefas[nTarefa,6])
		
		AEval(aStru,{|cValue,nX|aTarefas[nTarefa,6,nItem,nX]:= {aStru[nX,1],FieldGet(FieldPos(aStru[nX,1]))}})
		
		dbSelectArea("AC9")
		dbSkip()
	End

	dbSelectArea("AF2")
	dbSkip()
End

RestArea(aAreaAF2)
RestArea(aAreaAF3)
RestArea(aAreaAF4)
RestArea(aAreaAF7)
RestArea(aArea)

Return(aTarefas)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100EEDT   ³ Autor ³Fabio Rogerio Pereira³ Data ³30.04.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa o array com os itens a serem copiados.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100EEDT(cChave,aEDT)
Local aArea		:= GetArea()
Local aStru     := {}
Local aAreaAF2	:= AF2->(GetArea())
Local aAreaAF5	:= AF5->(GetArea())
Local nEDT      := 0
Local nItem     := 0

dbSelectArea("AF5")
dbSetOrder(1)
If MsSeek(xFilial("AF5") + cChave,.T.)

	aStru := AF5->(dbStruct())
	aAdd(aEDT,{AF5->AF5_EDT,Array(Len(aStru)),{},{}})
	nEDT:= Len(aEDT)

	// armazena os dados da edt
	dbSelectArea("AF5")
	AEval(aStru,{|cValue,nX|aEDT[nEDT,2,nX]:= {aStru[nX,1],FieldGet(FieldPos(aStru[nX,1]))}})

	// pesquisa todos os documentos da tarefa
	dbSelectArea("AC9")
	dbSetOrder(2)
	dbSeek(xFilial("AC9") + "AF5" + AF5->AF5_FILIAL + AF5->AF5_ORCAME + AF5->AF5_EDT)

	aStru := AC9->(dbStruct())

	While !Eof() .And. (AllTrim(AC9->AC9_FILIAL + AC9->AC9_ENTIDA + AC9->AC9_FILENT + AC9->AC9_CODENT) == ;
						AllTrim(xFilial("AC9") + "AF5" + xFilial("AF5") + AF5->AF5_ORCAME+AF5->AF5_EDT))

		aAdd(aEDT[nEDT,3],Array(Len(aStru)))
		nItem:= Len(aEDT[nEDT,3])
		
		AEval(aStru,{|cValue,nX|aEDT[nEDT,3,nItem,nX]:= {aStru[nX,1],FieldGet(FieldPos(aStru[nX,1]))}})
		
		dbSelectArea("AC9")
		dbSkip()
	End

	// pesquisa todas as tarefas da edt
	dbSelectArea("AF2")
	dbSetOrder(2)
	If MsSeek(xFilial("AF2") + AF5->AF5_ORCAME + AF5->AF5_EDT)
		aEDT[nEDT,4]:= Pms100ETarefa(AF2->AF2_ORCAME,AF2->AF2_EDTPAI,"AF2->AF2_EDTPAI",2)
	EndIf
EndIf

dbSelectArea("AF5")
dbSetOrder(2)
If MsSeek(xFilial("AF5")+cChave)
	While !Eof() .And. (xFilial("AF5")+cChave == AF5->AF5_FILIAL+AF5->AF5_ORCAME+AF5->AF5_EDTPAI) .And. !Empty(AF5_EDTPAI)
		Pms100EEDT(AF5->AF5_ORCAME+AF5->AF5_EDT,@aEDT)
		dbSelectArea("AF5")
		dbSkip()
	End
EndIf

RestArea(aAreaAF2)
RestArea(aAreaAF5)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100AltCus³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que altera os custos do orcamento.			            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100AltCus()
Local lRet		:= .F.
Local aParam1   := {}
Local aParam2   := {}
Local aTipos    := {"Atualizar do Cadastro","Aplicar Percentual","Atualizar Custos Por Projeto (Manual)","Atualizar Custos Por Tarefa (Manual)"} //#########
Local aCalculo  := {"Acrescimo","Descrescimo"} //###
Local cFiltroB1 := ""
Local cFiltroAF3:= ""

// ponto de entrada utilizado para customizar
// o cálculo de custo
If ExistBlock("PMS100AC")
	Return ExecBlock("PMS100AC", .F., .F.)
EndIf

If ExistTemplate("PMS100AC")
	ExecTemplate("PMS100AC",.F.,.F.)
Else

	// verifica o evento de alteracao no Fase atual
	If !PmsVldFase("AF1",AF1->AF1_ORCAME,"11") .Or. !ParamBox( {	{3,"Tipo de Reajuste",1,aTipos,130,"",.F.},;       //
																	{1,"Produto De",CriaVar("B1_COD",.F.),"@!","","SB1","",80,.F.},;  //
																	{1,"Produto Ate",Replicate("Z",TamSX3("B1_COD")[1]),"@!","","SB1","",80,.F.},;  //
																	{1,"Tipo Produto",CriaVar("B1_TIPO",.F.),"@!","","02","",10,.F.},;  //
																	{1,"Grupo De",CriaVar("B1_GRUPO",.F.),"@!","","SBM","",40,.F.},;  //
																	{1,"Grupo Ate",Replicate("Z",TamSX3("B1_GRUPO")[1]),"@!","","SBM","",40,.F.}},"Parametros",@aParam1)  //###

		Return(.F.)
	EndIf

	// filtra o arquivo de produtos para pesquisa otimizada
	cFiltroB1 := 	"B1_COD   >= '" + aParam1[2] + "' .And. B1_COD   <= '" + aParam1[3] + "' .And. " +;
					"B1_GRUPO >= '" + aParam1[5] + "' .And. B1_GRUPO <= '" + aParam1[6] + "'"

	
	If !Empty(aParam1[4])
		cFiltroB1+= " .And. B1_TIPO == '" + aParam1[4] + "'"
	EndIf

	// filtra os produtos do orcamento/projeto para pesquisa otimizada
	cFiltroAF3:= "AF3_FILIAL == '" + xFilial("AF3") + "' .And. " +;
			   "AF3_ORCAME == '" + AF1->AF1_ORCAME + "' .And. "+;
				 "AF3_PRODUT >= '" + aParam1[2] + "' .And. AF3_PRODUT <= '" + aParam1[3] + "'"
	

	Do Case
		Case (aParam1[1] == 1)
			Processa({||lRet:= Pms100ACCad(cFiltroAF3,cFiltroB1)},"Atualizando custos. Aguarde...") //
		
		Case (aParam1[1] == 2)

			If ParamBox( { {3,"Tipo de Calculo",1,aCalculo ,100,"",.T.},;  //
	 				       {1,"Percentual Reajuste",0,"9999.99","Mv_Par02 > 0","","",100,.T.}},"Parametros",@aParam2)  //
	    	
				Processa({||lRet:= Pms100APerc(cFiltroAF3,cFiltroB1,aParam2)},"Atualizando custos. Aguarde...") //
			EndIf
		
		
		Case (aParam1[1] == 3) .Or. (aParam1[1] == 4)
			lRet:= Pms100AManual(cFiltroAF3,cFiltroB1,aParam1)
		
	EndCase

	If lRet

		// atualiza os custos das tarefas e das edts
		u_LIS100ReCalc()
	EndIf
EndIf


Return(.F.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100ACCad     ³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que altera os custos do orcamento c/cadastro de prod/recurs.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100ACCad(cFiltroAF3,cFiltroB1)
Local nCusto   := 0          
Local cDesc    := ""
Local cAliasQry:= ""


//#IFDEF TOP
//	cAliasQry := CriaTrab( ,.F.) 
		
//	cQuery := 	"SELECT * FROM "  + RetSqlName( "AF3" ) + " WHERE D_E_L_E_T_=' ' "
	
//	If !Empty(cFiltroAF3)
//		cQuery+= " AND " + cFiltroAF3
//	EndIf
                            
//	If !Empty(cFiltroB1)
//		cQuery+= " AND AF3_PRODUT IN (SELECT B1_COD FROM " + RetSqlName( "SB1" ) + " WHERE D_E_L_E_T_= ' ' AND " + cFiltroB1 + ")"
//    EndIf
    
//	cQuery += " ORDER BY 1"
//	cQuery := PMSChangeQuery( cQuery ) 
	
//	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. ) 
		
//#ELSE
	cAliasQry := "AF3"

	// filtra o arquivo de produtos para pesquisa otimizada
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbClearFilter()
	
	If !Empty(cFiltroB1)
		DbSetFilter({||&(cFiltroB1)},cFiltroB1)
	EndIf
	
	// filtra os produtos do orcamento/projeto para pesquisa otimizada
	DbSelectArea(cAliasQry)
	DbSetOrder(1)
	MsSeek(xFilial("AF3") + AF1->AF1_ORCAME)
//#ENDIF

While !Eof() .And. &(cFiltroAF3)
	If AF3->(FieldPos("AF3_RECALC")) <=	0 .or. (AF3->(FieldPos("AF3_RECALC")) > 0 .And. AF3->AF3_RECALC != "2")
		If RetArqProd((cAliasQry)->AF3_PRODUT)
			nCusto:= Posicione("SB1",1,xFilial("SB1") + (cAliasQry)->AF3_PRODUT,"B1_CUSTD")
		Else
			nCusto:= Posicione("SBZ",1,xFilial("SBZ") + (cAliasQry)->AF3_PRODUT,"BZ_CUSTD")
		Endif	

		cDesc := AllTrim(SB1->B1_DESC)
					
		If (nCusto > 0)
			//#IFDEF TOP
			//	DbSelectArea("AF3")
			//	DbSetOrder(1)
			//	MsSeek(xFilial("AF3") + AF1->AF1_ORCAME + (cAliasQry)->AF3_TAREFA + (cAliasQry)->AF3_ITEM) //FILIAL+ORCAMENTO/PROJETO+TAREFA+ITEM
			//#ENDIF
		
			RecLock("AF3",.F.)			
			Replace AF3->AF3_CUSTD With nCusto
			MsUnlock()
		EndIf
	EndIf			        
	IncProc("Atualizando " + cDesc) //
			
	dbSelectArea(cAliasQry)
	dbSkip()
End
	
//#IFNDEF TOP
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbClearFilter()




//#ENDIF                   

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100APerc     ³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que altera os custos do orcamento aplicando percentual.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100APerc(cFiltroAF3,cFiltroB1,aParam)        
Local nCusto  := 0                                
Local cDesc   := ""
Local cAliasQry:= ""

//#IFDEF TOP
//	cAliasQry := CriaTrab( ,.F.) 
		
//	cQuery := 	"SELECT * FROM "  + RetSqlName( "AF3" ) + " WHERE D_E_L_E_T_=' ' "
	
//	If !Empty(cFiltroAF3)
//		cQuery+= " AND " + cFiltroAF3
//	EndIf
                            
//	If !Empty(cFiltroB1)
//		cQuery+= " AND AF3_PRODUT IN (SELECT B1_COD FROM " + RetSqlName( "SB1" ) + " WHERE D_E_L_E_T_= ' ' AND " + cFiltroB1 + ")"
//    EndIf
    
//	cQuery += " ORDER BY 1"
//	cQuery := PMSChangeQuery( cQuery ) 
	
//	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. ) 
		
//#ELSE
	cAliasQry := "AF3"

	// filtra o arquivo de produtos para pesquisa otimizada
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbClearFilter()
	
	If !Empty(cFiltroB1)
		DbSetFilter({||&(cFiltroB1)},cFiltroB1)
	EndIf
	
	// filtra os produtos do orcamento para pesquisa otimizada
	DbSelectArea("AF3")
	DbSetOrder(1)
	MsSeek(xFilial("AF3") + AF1->AF1_ORCAME)
//#ENDIF

While !Eof() .And. &(cFiltroAF3)
	cDesc := AllTrim(Posicione("SB1",1,xFilial("SB1") + (cAliasQry)->AF3_PRODUT,"B1_DESC"))
	If AF3->(FieldPos("AF3_RECALC")) <=	0 .or. (AF3->(FieldPos("AF3_RECALC")) > 0 .And. AF3->AF3_RECALC != "2")
		If aParam[1] == 1
			nCusto:= (cAliasQry)->AF3_CUSTD + (((cAliasQry)->AF3_CUSTD * aParam[2]) / 100)
		Else	
			nCusto:= (cAliasQry)->AF3_CUSTD - (((cAliasQry)->AF3_CUSTD * aParam[2]) / 100)
		EndIf
	
		If (nCusto > 0)
			//#IFDEF TOP
			//	DbSelectArea("AF3")
			//	DbSetOrder(1)
			//	MsSeek(xFilial("AF3") + AF1->AF1_ORCAME + (cAliasQry)->AF3_TAREFA + (cAliasQry)->AF3_ITEM) //FILIAL+ORCAMENTO/PROJETO+TAREFA+ITEM
			//#ENDIF

			RecLock("AF3",.F.)
			Replace AF3->AF3_CUSTD With nCusto
			MsUnlock()
		EndIf         
	EndIf
		
	IncProc("Atualizando " + cDesc)  //
	dbSelectArea(cAliasQry)
	dbSkip()
End

//#IFNDEF TOP
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbClearFilter()




//#ENDIF                   
	
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100AManual   ³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que altera os custos do projeto manualmente.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100AManual(cFiltroAF3,cFiltroB1,aParam)
Local lRet     := .F.
Local oProdutos
Local oDlg
Local aProdutos:= {}
Local aObjects := {}
Local aPosObj  := {}
Local aSize    := MsAdvSize(.T.)
Local nPos     := 0 
Local cDesc    := ""
Local cTarefa  := ""
Local cPict    := PesqPict("AF3","AF3_CUSTD")
Local cAliasQry:= ""

Local nQuantAF3:= 0

//#IFDEF TOP
//	cAliasQry := CriaTrab( ,.F.) 
		
//	cQuery := 	"SELECT * FROM "  + RetSqlName( "AF3" ) + " WHERE D_E_L_E_T_=' ' "
	
//	If !Empty(cFiltroAF3)
//		cQuery+= " AND " + cFiltroAF3
//	EndIf
                            
//	If !Empty(cFiltroB1)
//		cQuery+= " AND AF3_PRODUT IN (SELECT B1_COD FROM " + RetSqlName( "SB1" ) + " WHERE D_E_L_E_T_= ' ' AND " + cFiltroB1 + ")"
//    EndIf
    
//	cQuery += " ORDER BY 1"
//	cQuery := PMSChangeQuery( cQuery ) 
	
//	DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. ) 
//	DbGoTop()	
//#ELSE
	cAliasQry := "AF3"

	// filtra o arquivo de produtos para pesquisa otimizada
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbClearFilter()
	
	If !Empty(cFiltroB1)
		DbSetFilter({||&(cFiltroB1)},cFiltroB1)
	EndIf
	
	// filtra os produtos do orcamento para pesquisa otimizada
	DbSelectArea("AF3")
	DbSetOrder(1)
	MsSeek(xFilial("AF3") + AF1->AF1_ORCAME)

//#ENDIF

While !Eof() .And. &(cFiltroAF3)
	cDesc    := AllTrim(Posicione("SB1",1,xFilial("SB1") + (cAliasQry)->AF3_PRODUT,"B1_DESC"))
	cTarefa  := Posicione("AF2",1,xFilial("AF2") + AF1->AF1_ORCAME + (cAliasQry)->AF3_TAREFA,"AF2_DESCRI")
	nQuantAF2:= Posicione("AF2",1,xFilial("AF2") + AF1->AF1_ORCAME + (cAliasQry)->AF3_TAREFA,"AF2_QUANT")
	nQuantAF3:= PmsAF3Quant(AF1->AF1_ORCAME,(cAliasQry)->AF3_TAREFA,(cAliasQry)->AF3_PRODUT,nQuantAF2,(cAliasQry)->AF3_QUANT,,,If(AF3->(FieldPos("AF3_RECURS"))>0,(cAliasQry)->AF3_RECURS,""))
	
	If aParam[1] == 3 //Orcamento
		nPos:= aScan(aProdutos,{|x| x[1] == (cAliasQry)->AF3_PRODUT})
		If (nPos > 0)
			aProdutos[nPos][5]+= nQuantAF3
		Else
			Aadd(aProdutos,{(cAliasQry)->AF3_PRODUT,cDesc,"","",nQuantAF3,(cAliasQry)->AF3_CUSTD})
		EndIf
			
	ElseIf aParam[1] == 4	//Tarefa

		nPos:= aScan(aProdutos,{|x| x[1]+x[3] == (cAliasQry)->AF3_PRODUT + (cAliasQry)->AF3_TAREFA})
		If (nPos > 0)
			aProdutos[nPos][5]+= nQuantAF3
		Else
			Aadd(aProdutos,{(cAliasQry)->AF3_PRODUT,cDesc,(cAliasQry)->AF3_TAREFA,cTarefa,nQuantAF3,(cAliasQry)->AF3_CUSTD})
		EndIf
	EndIf
			
	dbSelectArea(cAliasQry)
	dbSkip()
End

If (Len(aProdutos) == 0)
	Aadd(aProdutos,{"","","","",0,0})
EndIf

aAdd( aObjects, { 100, 100, .T., .T., .T. } )  

aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 } 
aPosObj:= MsObjSize( aInfo, aObjects, .T.,.F. )  

DEFINE MSDIALOG oDlg TITLE "Atualizacao de Custo" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL //

	@ aPosObj[1,1] , aPosObj[1,2] LISTBOX oProdutos FIELDS	COLSIZES 50,120,50,120,80,80 HEADER "Produto","Descricao","Tarefa","Descricao","Quantidade","Custo Unitario" SIZE aPosObj[1,3] , aPosObj[1,4] DESIGN  OF oDlg PIXEL  ////,,,,,
	oProdutos:SetArray(aProdutos)
	oProdutos:bLine     := { || {aProdutos[oProdutos:nAT,1],aProdutos[oProdutos:nAT,2],aProdutos[oProdutos:nAT,3],aProdutos[oProdutos:nAT,4],Transform(aProdutos[oProdutos:nAT,5],cPict),Transform(aProdutos[oProdutos:nAT,6],cPict)}}
	oProdutos:blDblClick:= { || Pms100ChgCusto(@aProdutos,oProdutos,oDlg)}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| lRet:= .T. , Processa({||Pms100GrvCusto(cFiltroAF3,aProdutos,aParam)},"Atualizando custos. Aguarde..."),oDlg:End() },{||oDlg:End()}) //

//#IFNDEF TOP
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbClearFilter()

//#ENDIF                   

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100ChgCusto  ³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que altera os custos do projeto manualmente.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                        	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100ChgCusto(aArray,oObj)        
Local oDlg
Local oGet
Local oGet1
Local nCusto:= 0

DEFINE MSDIALOG oDlg TITLE "Atualizacao de Custo" FROM 001,001 TO 150, 250 OF oMainWnd PIXEL //
    @002,002 TO 50,125 LABEL "Custos" OF oDlg PIXEL //

	@010,005 SAY "Custo Atual" PIXEL SIZE 50,8 OF oDlg  //
	@010,055 MSGET oGet1 VAR aArray[oObj:nAT][6] PICTURE PesqPict("AF3","AF3_CUSTD") PIXEL SIZE 60,8 OF oDlg WHEN .F.
	oGet1:cSX1Hlp := "PMSA1003"

	@025,005 SAY "Custo Novo" PIXEL SIZE 50,8 OF oDlg //
	@025,055 MSGET oGet VAR nCusto PICTURE PesqPict("AF3","AF3_CUSTD") PIXEL SIZE 60,8 OF oDlg
	oGet:cSX1Hlp := "PMSA1004"

	DEFINE SBUTTON FROM 55, 60   TYPE 1 ENABLE OF oDlg ACTION (aArray[oObj:nAT][6]:= nCusto,oDlg:End())
	DEFINE SBUTTON FROM 55, 90   TYPE 2 ENABLE OF oDlg ACTION (oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100GrvCusto  ³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que grava os custos do projeto manualmente.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100GrvCusto(cFiltroAF3,aProdutos,aParam)
Local nView:= 0

// grava o custo dos produtos orcamento
For nView:= 1 To Len(aProdutos)
	If (aParam[1] == 3)    //Orcamento
		dbSelectArea("AF3")
		dbSetOrder(2)
		If MsSeek(xFilial("AF3") + AF1->AF1_ORCAME,.T.)
			While !Eof() .And. &(cFiltroAF3)
				If (AF3->AF3_PRODUT == aProdutos[nView][1])
					RecLock("AF3",.F.)
					Replace AF3->AF3_CUSTD With aProdutos[nView][6]
					MsUnLock()
				EndIf
						
				dbSkip()
			End
		EndIf  
	ElseIf (aParam[1] == 4) //Tarefa
		dbSelectArea("AF3")
		dbSetOrder(1)
		If MsSeek(xFilial("AF3") + AF1->AF1_ORCAME + aProdutos[nView][3])
			While !Eof() .And. (xFilial("AF3") + AF1->AF1_ORCAME + aProdutos[nView][3] == AF3->AF3_FILIAL + AF3->AF3_ORCAME + AF3->AF3_TAREFA)
				If (aProdutos[nView][1] == AF3->AF3_PRODUT)
					RecLock("AF3",.F.)
					Replace AF3->AF3_CUSTD With aProdutos[nView][6]
					MsUnLock()
				EndIf
			
				dbSkip()
			End
		EndIf  
	EndIf	
	
	IncProc("Atualizando " + aProdutos[nView][2]) //
Next

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100AEDT      ³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que atualiza os custos totais das Tarefas/EDT.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100AEDT()  
Local aArea:= GetArea()

If (AF1->(FieldPos("AF1_AUTCUS"))>0.And.(Empty(AF1->AF1_AUTCUS) .OR. AF1->AF1_AUTCUS=="1")) .Or.AF1->(FieldPos("AF1_AUTCUS"))<=0
	Processa({||Pms100AuxEDT()},"Atualizando Custos da EDT. Aguarde...") //
EndIf

RestArea(aArea)

Return( .T. )

Static Function PmsA100Fix(cSQL, cDB)
Local c,s,a,i,pc,cc,t,j,lc

cDB:=AllTrim(Upper(cDB))

if cDB=="INFORMIX"
	
	cSQL:=StrTran(cSQL,"LTRIM ( ","TRIM ( ")
	cSQL:=StrTran(cSQL,"VALUES (","")
	cSQL:=StrTran(cSQL,";);",";")
	cSQL:=StrTran(cSQL,"numeric","decimal(31,12)")
	
	s:=''
	a:=cSQL
	i:=AT("ROUND", a)
	do while i>0
		pc:=1
		cc:=0
		s:=s+left(a,i-1)
		t:=""
		j:=i+7
		lc:=-1
		do while j<len(a) .and. pc>0
			j:=j+1
			c:=substr(a,j,1)
			do case
				case c=')'
					pc--
				case c='('
					pc++
				case c=',' .and. pc==1
					cc++
					lc:=j
			endcase
		enddo
		if pc>0
			a:=substr(a,i)
			i:=0
		else
			if cc=2
				a:="TRUNC ( "+substr(a, i+8, lc-i-8)+")"+substr(a,j+1)
			else
				s:=s+"ROUND ( "
				a:=substr(a,i+8)
			endif
			i:=AT("ROUND", a)
		endif
	enddo
	cSQL:=s+a
	
elseif cDB=="ORACLE"
	
	cSQL:=StrTran(cSQL,"= ''","is null")
	cSQL:=StrTran(cSQL,"<> ''","is not null")
	cSQL:=StrTran(cSQL,"numeric","decimal(31,12)")
	
	s:=''
	a:=cSQL
	i:=AT("ROUND", a)
	do while i>0
		pc:=1
		cc:=0
		s:=s+left(a,i-1)
		t:=""
		j:=i+7
		lc:=-1
		do while j<len(a) .and. pc>0
			j:=j+1
			c:=substr(a,j,1)
			do case
				case c=')'
					pc--
				case c='('
					pc++
				case c=',' .and. pc==1
					cc++
					lc:=j
			endcase
		enddo
		if pc>0
			a:=substr(a,i)
			i:=0
		else
			if cc=2
				a:="TRUNC ( "+substr(a, i+8, lc-i-8)+")"+substr(a,j+1)
			else
				s:=s+"ROUND ( "
				a:=substr(a,i+8)
			endif
			i:=AT("ROUND", a)
		endif
	enddo
	cSQL:=s+a
	
elseif cDB=="DB2"
	
	cSQL:=StrTran(cSQL,"set vfim_CUR  = 0 ;","set fim_CUR = 0;")
	cSQL:=StrTran(cSQL,"vTx1 DECIMAL( 31 , 12 ) ;","vTx1 DOUBLE;")
	cSQL:=StrTran(cSQL,"vTx2 DECIMAL( 31 , 12 ) ;","vTx2 DOUBLE;")
	cSQL:=StrTran(cSQL,"vTx3 DECIMAL( 31 , 12 ) ;","vTx3 DOUBLE;")
	cSQL:=StrTran(cSQL,"vTx4 DECIMAL( 31 , 12 ) ;","vTx4 DOUBLE;")
	cSQL:=StrTran(cSQL,"vTx5 DECIMAL( 31 , 12 ) ;","vTx5 DOUBLE;")
	cSQL:=StrTran(cSQL,"set vfim_CUR  = 0 ;","set fim_CUR  = 0 ;")
	
	s:=''
	a:=cSQL
	i:=AT("ROUND", a)
	do while i>0
		pc:=1
		cc:=0
		s:=s+left(a,i-1)
		t:=""
		j:=i+7
		lc:=-1
		do while j<len(a) .and. pc>0
			j:=j+1
			c:=substr(a,j,1)
			do case
				case c=')'
					pc--
				case c='('
					pc++
				case c=',' .and. pc==1
					cc++
					lc:=j
			endcase
		enddo
		if pc>0
			a:=substr(a,i)
			i:=0
		else
			if cc=2
				a:="TRUNC ( "+substr(a, i+8, lc-i-8)+")"+substr(a,j+1)
			else
				s:=s+"ROUND ( "
				a:=substr(a,i+8)
			endif
			i:=AT("ROUND", a)
		endif
	enddo
	cSQL:=s+a
	
elseif cDB=="SYBASE"
	
	cSQL:=StrTran(cSQL,"numeric","decimal(31,12)")
	
elseif cDB=="MSSQL"
	
	cSQL:=StrTran(cSQL,"numeric","decimal(31,12)")
	
else
	
	cSQL:=StrTran(cSQL,"numeric","decimal(31,12)")
	
endif

Return cSQL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100Exec      ³ Autor ³ Marcelo Akama        ³ Data ³ 09-12-2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza os custos totais das Tarefas/EDT com SQL                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100Exec(cFil, cOrcamento, cPmsCust, cDtBase, aDec, nAtuTarefa, nAtuEDT, cTmp1, cTmp2, cProc)
Local cSQL   := ''
Local cRet   := 1
Local lRet   :=.t.
Local aResult:={}

Local cAF1:=RetSQLName("AF1")
Local cAF3:=RetSQLName("AF3")
Local cAF2:=RetSQLName("AF2")
Local cAF4:=RetSQLName("AF4")
Local cSM2:=RetSQLName("SM2")
Local cAF5:=RetSQLName("AF5")                  

Local cSqlProc := ''
	
	memowrite('log'+cProc+'.txt', 'esta acessando a rotina nesse momento')  	
    
if !TCSPExist( cProc )

	cSQL:=cSQL+"create procedure "+cProc+" (@IN_AtuAF2 int, @IN_AtuAF5 int, @OUT_Ret int output) as"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"declare @DtConv	char(8)			-- Data da conversão"+CRLF
	cSQL:=cSQL+"declare @trunc	char(1)			-- Tipo arredondamento/truncamento"+CRLF
	cSQL:=cSQL+"declare @BDIPad	decimal(31,12)	-- BDI padrão do projeto"+CRLF
	cSQL:=cSQL+"declare @Nivel	varchar(250)	-- Nivel"+CRLF
	cSQL:=cSQL+"declare @i		int"+CRLF
	cSQL:=cSQL+"declare @j		int"+CRLF
	cSQL:=cSQL+"declare @k		int"+CRLF
	cSQL:=cSQL+"declare @DtAux	char(8)			-- Data"+CRLF
	cSQL:=cSQL+"declare @Dt1	char(8)			-- Data 1"+CRLF
	cSQL:=cSQL+"declare @Dt2	char(8)			-- Data 2"+CRLF
	cSQL:=cSQL+"declare @Moeda	int				-- Moeda"+CRLF
	cSQL:=cSQL+"declare @Tx1	decimal(31,12)	-- TX1"+CRLF
	cSQL:=cSQL+"declare @Tx2	decimal(31,12)	-- TX2"+CRLF
	cSQL:=cSQL+"declare @Tx3	decimal(31,12)	-- TX3"+CRLF
	cSQL:=cSQL+"declare @Tx4	decimal(31,12)	-- TX4"+CRLF
	cSQL:=cSQL+"declare @Tx5	decimal(31,12)	-- TX5"+CRLF
	cSQL:=cSQL+"declare @Vl1	decimal(31,12)	-- Valor 1"+CRLF
	cSQL:=cSQL+"declare @Vl2	decimal(31,12)	-- Valor 2"+CRLF
	cSQL:=cSQL+"declare @Vl3	decimal(31,12)	-- Valor 3"+CRLF
	cSQL:=cSQL+"declare @Vl4	decimal(31,12)	-- Valor 4"+CRLF
	cSQL:=cSQL+"declare @Vl5	decimal(31,12)	-- Valor 5"+CRLF
	cSQL:=cSQL+"declare @BDI	decimal(31,12)	-- BDI"+CRLF
	cSQL:=cSQL+"declare @EDT	varchar(250)	-- EDT"+CRLF
	cSQL:=cSQL+"declare @EDTPai	varchar(250)	-- EDTPai"+CRLF
	cSQL:=cSQL+"declare @Task	varchar(250)	-- Tarefa"+CRLF
	cSQL:=cSQL+"declare @Dt		datetime"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"declare @fim_CUR	int			-- Indica fim do cursor no DB2"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"select @OUT_Ret=0"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"select @DtConv=ltrim(AF1_DTCONV), @trunc=ltrim(AF1_TRUNCA), @BDIPad=AF1_BDIPAD"+CRLF
	cSQL:=cSQL+"from "+cAF1+""+CRLF
	cSQL:=cSQL+"where AF1_FILIAL='"+cFil+"' and AF1_ORCAME='"+cOrcamento+"' and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"if @trunc='' select @trunc='1'"+CRLF
	cSQL:=cSQL+"if ltrim(@DtConv)='' select @DtConv='"+cDtBase+"'"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"begin transaction"+CRLF
	cSQL:=cSQL+"	"+CRLF
	cSQL:=cSQL+"	if @IN_AtuAF2<>0"+CRLF
	cSQL:=cSQL+"		begin"+CRLF
	cSQL:=cSQL+"	"+CRLF
	cSQL:=cSQL+"			-- Recursos"+CRLF
	cSQL:=cSQL+"			insert into "+cTmp1+" (TAREFA,VALOR,QUANT,VALOR1,VALOR2,VALOR3,VALOR4,VALOR5,MOEDA,DTCONV,TX1,TX2,TX3,TX4,TX5)"+CRLF
	cSQL:=cSQL+"			select"+CRLF
	cSQL:=cSQL+"				AF3_TAREFA as TAREFA,"+CRLF
	cSQL:=cSQL+"				AF3_QUANT*AF3_CUSTD as VALOR,"+CRLF
	cSQL:=cSQL+"				AF2_QUANT as QUANT,"+CRLF
	cSQL:=cSQL+"				0 as VALOR1,"+CRLF
	cSQL:=cSQL+"				0 as VALOR2,"+CRLF
	cSQL:=cSQL+"				0 as VALOR3,"+CRLF
	cSQL:=cSQL+"				0 as VALOR4,"+CRLF
	cSQL:=cSQL+"				0 as VALOR5,"+CRLF
	cSQL:=cSQL+"				AF3_MOEDA as MOEDA,"+CRLF
	cSQL:=cSQL+"				'' as DTCONV,"+CRLF
	cSQL:=cSQL+"				1.0 as TX1, AF2_TXMO2 as TX2, AF2_TXMO3 as TX3, AF2_TXMO4 as TX4, AF2_TXMO5 as TX5"+CRLF
	cSQL:=cSQL+"			from "+cAF3+" a, "+cAF2+" b"+CRLF
	cSQL:=cSQL+"			where AF3_FILIAL='"+cFil+"' and AF3_ORCAME='"+cOrcamento+"'  and a.D_E_L_E_T_<>'*' and b.D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"			and AF3_FILIAL=AF2_FILIAL and AF3_ORCAME=AF2_ORCAME and AF3_TAREFA=AF2_TAREFA"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			-- Despesas"+CRLF
	cSQL:=cSQL+"			insert into "+cTmp1+" (TAREFA,VALOR,QUANT,VALOR1,VALOR2,VALOR3,VALOR4,VALOR5,MOEDA,DTCONV,TX1,TX2,TX3,TX4,TX5)"+CRLF
	cSQL:=cSQL+"			select"+CRLF
	cSQL:=cSQL+"				AF4_TAREFA as TAREFA,"+CRLF
	cSQL:=cSQL+"				AF4_VALOR as VALOR,"+CRLF
	cSQL:=cSQL+"				AF2_QUANT as QUANT,"+CRLF
	cSQL:=cSQL+"				0 as VALOR1,"+CRLF
	cSQL:=cSQL+"				0 as VALOR2,"+CRLF
	cSQL:=cSQL+"				0 as VALOR3,"+CRLF
	cSQL:=cSQL+"				0 as VALOR4,"+CRLF
	cSQL:=cSQL+"				0 as VALOR5,"+CRLF
	cSQL:=cSQL+"				AF4_MOEDA as MOEDA,"+CRLF
	cSQL:=cSQL+"				'' as DTCONV,"+CRLF
	cSQL:=cSQL+"				1.0 as TX1, AF2_TXMO2 as TX2, AF2_TXMO3 as TX3, AF2_TXMO4 as TX4, AF2_TXMO5 as TX5"+CRLF
	cSQL:=cSQL+"			from "+cAF4+" a, "+cAF2+" b"+CRLF
	cSQL:=cSQL+"			where AF4_FILIAL='"+cFil+"' and AF4_ORCAME='"+cOrcamento+"' and a.D_E_L_E_T_<>'*' and b.D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"			and AF4_FILIAL=AF2_FILIAL and AF4_ORCAME=AF2_ORCAME and AF4_TAREFA=AF2_TAREFA"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			update "+cTmp1+" set DTCONV=@DtConv"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			-- Atualiza a taxa de conversão das moedas quando não informado"+CRLF
	cSQL:=cSQL+"			declare cur cursor for select DTCONV from "+cTmp1+" where TX2=0 or TX3=0 or TX4=0 or TX5=0 group by DTCONV"+CRLF
	cSQL:=cSQL+"			open cur"+CRLF
	cSQL:=cSQL+"			fetch next from cur into @DtAux"+CRLF
	cSQL:=cSQL+"			while @@FETCH_STATUS = 0"+CRLF
	cSQL:=cSQL+"				begin"+CRLF
	cSQL:=cSQL+"					select @Tx2=0, @Tx3=0, @Tx4=0, @Tx5=0"+CRLF
	cSQL:=cSQL+"					select @Tx2=M2_MOEDA2, @Tx3=M2_MOEDA3, @Tx4=M2_MOEDA4, @Tx5=M2_MOEDA5 from "+cSM2+" where D_E_L_E_T_<>'*' and M2_DATA=@DtAux"+CRLF
	cSQL:=cSQL+"					if @Tx2=0 select @Tx2=1"+CRLF
	cSQL:=cSQL+"					if @Tx3=0 select @Tx3=1"+CRLF
	cSQL:=cSQL+"					if @Tx4=0 select @Tx4=1"+CRLF
	cSQL:=cSQL+"					if @Tx5=0 select @Tx5=1"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set TX2=@Tx2 where DTCONV=@DtAux and TX2=0"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set TX3=@Tx3 where DTCONV=@DtAux and TX3=0"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set TX4=@Tx4 where DTCONV=@DtAux and TX4=0"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set TX5=@Tx5 where DTCONV=@DtAux and TX5=0"+CRLF
	cSQL:=cSQL+"					select @fim_CUR=0"+CRLF
	cSQL:=cSQL+"					fetch next from cur into @DtAux"+CRLF
	cSQL:=cSQL+"				end"+CRLF
	cSQL:=cSQL+"			close cur"+CRLF
	cSQL:=cSQL+"			deallocate cur"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			-- Atualiza os valores"+CRLF
	cSQL:=cSQL+"			update "+cTmp1+" set VALOR1=VALOR    , VALOR2=VALOR/TX2    , VALOR3=VALOR/TX3    , VALOR4=VALOR/TX4    , VALOR5=VALOR/TX5     where MOEDA=1"+CRLF
	cSQL:=cSQL+"			update "+cTmp1+" set VALOR1=VALOR*TX2, VALOR2=VALOR        , VALOR3=VALOR*TX2/TX3, VALOR4=VALOR*TX2/TX4, VALOR5=VALOR*TX2/TX5 where MOEDA=2"+CRLF
	cSQL:=cSQL+"			update "+cTmp1+" set VALOR1=VALOR*TX3, VALOR2=VALOR*TX3/TX2, VALOR3=VALOR        , VALOR4=VALOR*TX3/TX4, VALOR5=VALOR*TX3/TX5 where MOEDA=3"+CRLF
	cSQL:=cSQL+"			update "+cTmp1+" set VALOR1=VALOR*TX4, VALOR2=VALOR*TX4/TX2, VALOR3=VALOR*TX4/TX3, VALOR4=VALOR        , VALOR5=VALOR*TX4/TX5 where MOEDA=4"+CRLF
	cSQL:=cSQL+"			update "+cTmp1+" set VALOR1=VALOR*TX5, VALOR2=VALOR*TX5/TX2, VALOR3=VALOR*TX5/TX3, VALOR4=VALOR*TX5/TX4, VALOR5=VALOR         where MOEDA=5"+CRLF
	cSQL:=cSQL+"			"+CRLF
	cSQL:=cSQL+"			-- Arredonta/Trunca"+CRLF
	cSQL:=cSQL+"			if '"+cPmsCust+"'='1'	-- Custo total"+CRLF
	cSQL:=cSQL+"				if @trunc='1' or @trunc='3' -- Trunca"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set"+CRLF
	cSQL:=cSQL+"						VALOR1=round(VALOR1,"+ltrim(str(aDec[1]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR2=round(VALOR2,"+ltrim(str(aDec[2]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR3=round(VALOR3,"+ltrim(str(aDec[3]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR4=round(VALOR4,"+ltrim(str(aDec[4]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR5=round(VALOR5,"+ltrim(str(aDec[5]))+",1)"+CRLF
	cSQL:=cSQL+"				else -- Arredonda"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set"+CRLF
	cSQL:=cSQL+"						VALOR1=round(VALOR1,"+ltrim(str(aDec[1]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR2=round(VALOR2,"+ltrim(str(aDec[2]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR3=round(VALOR3,"+ltrim(str(aDec[3]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR4=round(VALOR4,"+ltrim(str(aDec[4]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR5=round(VALOR5,"+ltrim(str(aDec[5]))+")"+CRLF
	cSQL:=cSQL+"			else	-- Custo unitário"+CRLF
	cSQL:=cSQL+"				if @trunc='1' -- Trunca unitário do item"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set"+CRLF
	cSQL:=cSQL+"						VALOR1=round(VALOR1*QUANT,"+ltrim(str(aDec[1]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR2=round(VALOR2*QUANT,"+ltrim(str(aDec[2]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR3=round(VALOR3*QUANT,"+ltrim(str(aDec[3]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR4=round(VALOR4*QUANT,"+ltrim(str(aDec[4]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR5=round(VALOR5*QUANT,"+ltrim(str(aDec[5]))+",1)"+CRLF
	cSQL:=cSQL+"				else if @trunc='2'	-- Arredonda unitário do item"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set"+CRLF
	cSQL:=cSQL+"						VALOR1=round(VALOR1*QUANT,"+ltrim(str(aDec[1]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR2=round(VALOR2*QUANT,"+ltrim(str(aDec[2]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR3=round(VALOR3*QUANT,"+ltrim(str(aDec[3]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR4=round(VALOR4*QUANT,"+ltrim(str(aDec[4]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR5=round(VALOR5*QUANT,"+ltrim(str(aDec[5]))+")"+CRLF
	cSQL:=cSQL+"				else if @trunc='3'	-- Trunca unitário da tarefa"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set"+CRLF
	cSQL:=cSQL+"						VALOR1=round(round(VALOR1,"+ltrim(str(aDec[1]))+",1)*QUANT,"+ltrim(str(aDec[1]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR2=round(round(VALOR2,"+ltrim(str(aDec[2]))+",1)*QUANT,"+ltrim(str(aDec[2]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR3=round(round(VALOR3,"+ltrim(str(aDec[3]))+",1)*QUANT,"+ltrim(str(aDec[3]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR4=round(round(VALOR4,"+ltrim(str(aDec[4]))+",1)*QUANT,"+ltrim(str(aDec[4]))+",1),"+CRLF
	cSQL:=cSQL+"						VALOR5=round(round(VALOR5,"+ltrim(str(aDec[5]))+",1)*QUANT,"+ltrim(str(aDec[5]))+",1)"+CRLF
	cSQL:=cSQL+"				else	-- Arredonda unitário da tarefa"+CRLF
	cSQL:=cSQL+"					update "+cTmp1+" set"+CRLF
	cSQL:=cSQL+"						VALOR1=round(round(VALOR1,"+ltrim(str(aDec[1]))+")*QUANT,"+ltrim(str(aDec[1]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR2=round(round(VALOR2,"+ltrim(str(aDec[2]))+")*QUANT,"+ltrim(str(aDec[2]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR3=round(round(VALOR3,"+ltrim(str(aDec[3]))+")*QUANT,"+ltrim(str(aDec[3]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR4=round(round(VALOR4,"+ltrim(str(aDec[4]))+")*QUANT,"+ltrim(str(aDec[4]))+"),"+CRLF
	cSQL:=cSQL+"						VALOR5=round(round(VALOR5,"+ltrim(str(aDec[5]))+")*QUANT,"+ltrim(str(aDec[5]))+")"+CRLF
	cSQL:=cSQL+"			"+CRLF
	cSQL:=cSQL+"			-- Pega valor de BDI"+CRLF
	cSQL:=cSQL+"			insert into "+cTmp2+" (TAREFA2,EDTPAI,BDI,FLAG,UTIBDI)"+CRLF
	cSQL:=cSQL+"			select"+CRLF
	cSQL:=cSQL+"				AF2_TAREFA as TAREFA2,"+CRLF
	cSQL:=cSQL+"				AF2_EDTPAI as EDTPAI,"+CRLF
	cSQL:=cSQL+"				AF2_BDI as BDI,"+CRLF
	cSQL:=cSQL+"				0 as FLAG,"+CRLF
	cSQL:=cSQL+"				AF2_UTIBDI as UTIBDI"+CRLF
	cSQL:=cSQL+"			from "+cAF2+""+CRLF
	cSQL:=cSQL+"			where AF2_FILIAL='"+cFil+"' and AF2_ORCAME='"+cOrcamento+"' and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			update "+cTmp2+" set FLAG=1 where BDI<>0 or UTIBDI='2'  -- atualiza flag"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			-- Se não tiver BDI cadastrado, pega das EDT's pais, se ainda não tiver, pega BDI padrão do orçamento"+CRLF
	cSQL:=cSQL+"			declare cur_bdi cursor for select EDTPAI from "+cTmp2+" where FLAG=0 group by EDTPAI"+CRLF
	cSQL:=cSQL+"			open cur_bdi"+CRLF
	cSQL:=cSQL+"			fetch next from cur_bdi into @EDT"+CRLF
	cSQL:=cSQL+"			while @@FETCH_STATUS = 0"+CRLF
	cSQL:=cSQL+"				begin"+CRLF
	cSQL:=cSQL+"					select @BDI=AF5_BDITAR, @EDTPai=AF5_EDTPAI from "+cAF5+" where AF5_EDT=@EDT and AF5_FILIAL='"+cFil+"' and AF5_ORCAME='"+cOrcamento+"' and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"--					while exists(select FLAG from "+cTmp2+" where FLAG=0 and EDTPAI=@EDT and ltrim(EDTPAI)<>'')"+CRLF
	cSQL:=cSQL+"					select @i=count(*) from "+cTmp2+" where FLAG=0 and EDTPAI=@EDT and ltrim(EDTPAI)<>''"+CRLF
	cSQL:=cSQL+"					while @i>0"+CRLF
	cSQL:=cSQL+"						begin"+CRLF
	cSQL:=cSQL+"							update "+cTmp2+" set BDI=@BDI, EDTPAI=@EDTPai where FLAG=0 and EDTPAI=@EDT"+CRLF
	cSQL:=cSQL+"							update "+cTmp2+" set FLAG=1 where FLAG=0 and BDI<>0"+CRLF
	cSQL:=cSQL+"							update "+cTmp2+" set BDI=@BDIPad, FLAG=1 where FLAG=0 and ltrim(EDTPAI)=''"+CRLF
	cSQL:=cSQL+"							select @EDT=@EDTPai"+CRLF
	cSQL:=cSQL+"							select @BDI=AF5_BDITAR, @EDTPai=AF5_EDTPAI from "+cAF5+" where AF5_EDT=@EDT and AF5_FILIAL='"+cFil+"' and AF5_ORCAME='"+cOrcamento+"' and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"							select @i=count(*) from "+cTmp2+" where FLAG=0 and EDTPAI=@EDT and ltrim(EDTPAI)<>''"+CRLF
	cSQL:=cSQL+"						end"+CRLF
	cSQL:=cSQL+"					select @fim_CUR=0"+CRLF
	cSQL:=cSQL+"					fetch next from cur_bdi into @EDT"+CRLF
	cSQL:=cSQL+"				end"+CRLF
	cSQL:=cSQL+"			close cur_bdi"+CRLF
	cSQL:=cSQL+"			deallocate cur_bdi"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			-- Atualiza o custo das tarefas"+CRLF
	cSQL:=cSQL+"			declare cur_tsk cursor for"+CRLF
	cSQL:=cSQL+"				select AF2_TAREFA from "+cAF2+""+CRLF
	cSQL:=cSQL+"				where AF2_FILIAL='"+cFil+"' and AF2_ORCAME='"+cOrcamento+"' and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"				group by AF2_TAREFA"+CRLF
	cSQL:=cSQL+"			open cur_tsk"+CRLF
	cSQL:=cSQL+"			fetch next from cur_tsk into @Task"+CRLF
	cSQL:=cSQL+"			while @@FETCH_STATUS = 0"+CRLF
	cSQL:=cSQL+"				begin"+CRLF
	cSQL:=cSQL+"					select @Tx1=0, @Tx2=0, @Tx3=0, @Tx4=0, @Tx5=0, @BDI=0"+CRLF
	cSQL:=cSQL+"					select @Tx1=sum(VALOR1), @Tx2=sum(VALOR2), @Tx3=sum(VALOR3), @Tx4=sum(VALOR4), @Tx5=sum(VALOR5) from "+cTmp1+" where TAREFA=@Task group by TAREFA"+CRLF
	cSQL:=cSQL+"					select @BDI=BDI from "+cTmp2+" where TAREFA2=@Task"+CRLF
	cSQL:=cSQL+"					select @Tx1=isnull(@Tx1,0), @Tx2=isnull(@Tx2,0), @Tx3=isnull(@Tx3,0), @Tx4=isnull(@Tx4,0), @Tx5=isnull(@Tx5,0), @BDI=isnull(@BDI,0)"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"					update "+cAF2+" set"+CRLF
	cSQL:=cSQL+"						AF2_CUSTO =isnull(@Tx1,0),"+CRLF
	cSQL:=cSQL+"						AF2_CUSTO2=isnull(@Tx2,0),"+CRLF
	cSQL:=cSQL+"						AF2_CUSTO3=isnull(@Tx3,0),"+CRLF
	cSQL:=cSQL+"						AF2_CUSTO4=isnull(@Tx4,0),"+CRLF
	cSQL:=cSQL+"						AF2_CUSTO5=isnull(@Tx5,0),"+CRLF
	cSQL:=cSQL+"						AF2_VALBDI=round((isnull(@Tx1,0)*isnull(@BDI,0)/100)+0.0000001 ,"+ltrim(str(aDec[1]))+"),"+CRLF
	cSQL:=cSQL+"						AF2_TOTAL =round((isnull(@Tx1,0)*(1+(isnull(@BDI,0)/100)))+0.0000001 ,"+ltrim(str(aDec[1]))+")"+CRLF
	cSQL:=cSQL+"					where AF2_FILIAL='"+cFil+"' and AF2_ORCAME='"+cOrcamento+"' and AF2_TAREFA=@Task and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"					select @fim_CUR=0"+CRLF
	cSQL:=cSQL+"					fetch next from cur_tsk into @Task"+CRLF
	cSQL:=cSQL+"				end"+CRLF
	cSQL:=cSQL+"			close cur_tsk"+CRLF
	cSQL:=cSQL+"			deallocate cur_tsk"+CRLF
	cSQL:=cSQL+"			"+CRLF
	cSQL:=cSQL+"		end"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"	if @IN_AtuAF5<>0"+CRLF
	cSQL:=cSQL+"		begin"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			-- zera custo das EDT's"+CRLF
	cSQL:=cSQL+"			update "+cAF5+" set AF5_CUSTO=0, AF5_CUSTO2=0, AF5_CUSTO3=0, AF5_CUSTO4=0, AF5_CUSTO5=0, AF5_VALBDI=0, AF5_TOTAL=0"+CRLF
	cSQL:=cSQL+"			where AF5_FILIAL='"+cFil+"' and AF5_ORCAME='"+cOrcamento+"' and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"			declare cur_lvl cursor for"+CRLF
	cSQL:=cSQL+"				select AF5_NIVEL from "+cAF5+""+CRLF
	cSQL:=cSQL+"				where AF5_FILIAL='"+cFil+"' and AF5_ORCAME='"+cOrcamento+"' and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"				group by AF5_NIVEL"+CRLF
	cSQL:=cSQL+"				order by AF5_NIVEL DESC"+CRLF
	cSQL:=cSQL+"			open cur_lvl"+CRLF
	cSQL:=cSQL+"			fetch next from cur_lvl into @Nivel"+CRLF
	cSQL:=cSQL+"			while @@FETCH_STATUS = 0"+CRLF
	cSQL:=cSQL+"				begin"+CRLF
	cSQL:=cSQL+"					declare cur_elv cursor for"+CRLF
	cSQL:=cSQL+"						select AF5_EDT from "+cAF5+""+CRLF
	cSQL:=cSQL+"						where AF5_FILIAL='"+cFil+"' and AF5_ORCAME='"+cOrcamento+"' and AF5_NIVEL=@Nivel and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"						group by AF5_EDT"+CRLF
	cSQL:=cSQL+"					open cur_elv"+CRLF
	cSQL:=cSQL+"					fetch next from cur_elv into @EDT"+CRLF
	cSQL:=cSQL+"					while @@FETCH_STATUS = 0"+CRLF
	cSQL:=cSQL+"						begin"+CRLF
	cSQL:=cSQL+"							select @Tx1=0, @Tx2=0, @Tx3=0, @Tx4=0, @Tx5=0, @Vl1=0, @Vl2=0, @Vl3=0, @Vl4=0, @Vl5=0, @BDI=0, @BDIPad=0"+CRLF
	cSQL:=cSQL+"							select @Tx1=sum(AF2_CUSTO), @Tx2=sum(AF2_CUSTO2), @Tx3=sum(AF2_CUSTO3), @Tx4=sum(AF2_CUSTO4), @Tx5=sum(AF2_CUSTO5), @BDI=sum(AF2_VALBDI)"+CRLF
	cSQL:=cSQL+"								from "+cAF2+" where AF2_FILIAL='"+cFil+"' and AF2_ORCAME='"+cOrcamento+"' and AF2_EDTPAI=@EDT and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"							select @Vl1=sum(AF5_CUSTO), @Vl2=sum(AF5_CUSTO2), @Vl3=sum(AF5_CUSTO3), @Vl4=sum(AF5_CUSTO4), @Vl5=sum(AF5_CUSTO5), @BDIPad=sum(AF5_VALBDI)"+CRLF
	cSQL:=cSQL+"								from "+cAF5+" where AF5_FILIAL='"+cFil+"' and AF5_ORCAME='"+cOrcamento+"' and AF5_EDTPAI=@EDT and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+"							select @Tx1=isnull(@Tx1,0), @Tx2=isnull(@Tx2,0), @Tx3=isnull(@Tx3,0), @Tx4=isnull(@Tx4,0), @Tx5=isnull(@Tx5,0), @BDI=isnull(@BDI,0)"+CRLF
	cSQL:=cSQL+"							select @Vl1=isnull(@Vl1,0), @Vl2=isnull(@Vl2,0), @Vl3=isnull(@Vl3,0), @Vl4=isnull(@Vl4,0), @Vl5=isnull(@Vl5,0), @BDIPad=isnull(@BDIPad,0)"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"							update "+cAF5+" set"+CRLF
	cSQL:=cSQL+"								AF5_CUSTO =isnull(@Tx1,0)+isnull(@Vl1,0),"+CRLF
	cSQL:=cSQL+"								AF5_CUSTO2=isnull(@Tx2,0)+isnull(@Vl2,0),"+CRLF
	cSQL:=cSQL+"								AF5_CUSTO3=isnull(@Tx3,0)+isnull(@Vl3,0),"+CRLF
	cSQL:=cSQL+"								AF5_CUSTO4=isnull(@Tx4,0)+isnull(@Vl4,0),"+CRLF
	cSQL:=cSQL+"								AF5_CUSTO5=isnull(@Tx5,0)+isnull(@Vl5,0),"+CRLF
	cSQL:=cSQL+"								AF5_VALBDI=isnull(@BDI,0)+isnull(@BDIPad,0),"+CRLF
	cSQL:=cSQL+"								AF5_TOTAL =isnull(@Tx1,0)+isnull(@BDI,0)+isnull(@Vl1,0)+isnull(@BDIPad,0)"+CRLF
	cSQL:=cSQL+"							where AF5_FILIAL='"+cFil+"' and AF5_ORCAME='"+cOrcamento+"' and AF5_EDT=@EDT and D_E_L_E_T_<>'*'"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"							select @fim_CUR=0"+CRLF
	cSQL:=cSQL+"							fetch next from cur_elv into @EDT"+CRLF
	cSQL:=cSQL+"						end"+CRLF
	cSQL:=cSQL+"					close cur_elv"+CRLF
	cSQL:=cSQL+"					deallocate cur_elv"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"					select @fim_CUR=0"+CRLF
	cSQL:=cSQL+"					fetch next from cur_lvl into @Nivel"+CRLF
	cSQL:=cSQL+"				end"+CRLF
	cSQL:=cSQL+"			close cur_lvl"+CRLF
	cSQL:=cSQL+"			deallocate cur_lvl"+CRLF
	cSQL:=cSQL+"		end"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"commit"+CRLF
	cSQL:=cSQL+""+CRLF
	cSQL:=cSQL+"select @OUT_Ret=1"+CRLF
	
	memowrite("C:\PMSAL100.sql", cSQL)
	
	cSQL:=MsParse(cSQL,Alltrim(TcGetDB()))
	
	if cSQL=''
		if !__lBlind
 			MsgAlert('Erro criando a Stored Procedure:'+" "+cProc+": "+MsParseError())  //
		endif
	else
	
		cSQL:=PmsA100Fix(cSQL, Alltrim(TcGetDB()))
		
		cRet:=TcSqlExec(cSQL)
		if cRet <> 0
			if !__lBlind
	 			MsgAlert('Erro criando a Stored Procedure:'+" "+cProc+": "+TCSqlError())  //
			endif
			lRet := .f.	
		endif
	endif
else
	cRet:=0
endif

if cRet=0
	aResult := TCSPExec( cProc, nAtuTarefa, nAtuEDT )
	if empty(aResult)
		if !__lBlind
			MsgAlert('Erro executando a Stored Procedure'+" "+cProc+": "+TCSqlError())  //
		endif
		lRet := .f.
	elseif aResult[1] != 1
		if !__lBlind
			MsgAlert('Erro atualizando custos'+": "+TCSqlError())   //
		endif
		lRet := .f.
	endif
endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100AuxEDT    ³ Autor ³Fabio Rogerio Pereira ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que atualiza os custos totais das Tarefas/EDT.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100AuxEDT()
Local aAreaAF2		:= {}
Local aCustoAF2		:= {}
Local aVal			:= {}
Local cOrcamento	:= AF1->AF1_ORCAME
Local nRecAF2		:= 0

Local lSQL		:= Upper(TcSrvType()) != "AS/400" .and. Upper(TcSrvType()) != "ISERIES"
Local lBlock	:= ExistBlock("PMAF2CST")
Local cTrunca	:= "1"
Local cPmsCust	:= SuperGetMv("MV_PMSCUST",.F.,"1")
Local lTotal	:= cPmsCust=="1"
Local nRec		:= 0
Local dDtConv	:= iif(empty(AF1->AF1_DTCONV), dDataBase, AF1->AF1_DTCONV)
Local aTX2M		:= {0,0,0,0,0}
Local aStruct	:= {}
Local cArqTrab  := ""
Local cPaiOld
Local nCusto
Local nMoeda
Local nQuantTrf
Local n1,n2,n3,n4,n5,n6
Local cTmp1		:=CriaTrab(nil,.F.)
Local cTmp2		:=CriaTrab(nil,.F.)
Local cProc		:='PMS100_'+CriaTrab(nil,.F.)
Local aFields:={}
Local aDecCst	:= {0,0,0,0,0}

aDecCst[1]:=TamSX3("AF2_CUSTO")[2]
aDecCst[2]:=TamSX3("AF2_CUSTO2")[2]
aDecCst[3]:=TamSX3("AF2_CUSTO3")[2]
aDecCst[4]:=TamSX3("AF2_CUSTO4")[2]
aDecCst[5]:=TamSX3("AF2_CUSTO5")[2]

If ExistTemplate("PMAAF2CTrf") // Se existir template

	dbSelectArea("AF2")
	dbSetOrder(1)
	If MsSeek(xFilial("AF2") + cOrcamento)
		PmsNewProc("ORC",cOrcamento)

		While !Eof() .And. (xFilial("AF2") + cOrcamento == AF2->AF2_FILIAL + AF2->AF2_ORCAME)
			ExecTemplate("PMAAF2CTrf",.F.,.F.,{AF2->AF2_ORCAME,AF2->AF2_TAREFA})

			If lBlock
				nRecAF2 := AF2->( Recno() )
				ExecBlock("PMAF2CST", .F., .F.)
				AF2->( dbgoto( nRecAF2 ) )
			EndIf

			// atualiza o custo das edts pais
			aAreaAF2:= AF2->(GetArea())
			PmsAvalAF2("AF2")
			RestArea(aAreaAF2)

			dbSkip()
			PmsIncProc(.T.,,"ORC")
		End
	EndIf
else // recálculo novo

	if AF1->(FieldPos("AF1_TRUNCA")) > 0
		cTrunca:=AF1->AF1_TRUNCA
	endif
	ASIZE(aCustoAF2,5)
	ASIZE(aVal,5)

	// Calcula custo das tarefas
 // comentado por alexandre em 11/03 para teste de utilizacao em producao
	if lSQL // Se for diferente de AS/400, recalcula com SQL

		// Criacao das tabelas temporárias
        
		if Alltrim(Upper(TcGetDb()))=="INFORMIX"
			TCSqlExec('CREATE TABLE '+cTmp1+' ( TAREFA    char('+ltrim(str(TamSX3("AF2_TAREFA")[1]))+'), VALOR decimal(31,12), QUANT decimal(31,12), VALOR1 decimal(31,12), VALOR2 decimal(31,12), VALOR3 decimal(31,12), VALOR4 decimal(31,12), VALOR5 decimal(31,12), MOEDA decimal(31,12), DTCONV    char(8), TX1 decimal(31,12), TX2 decimal(31,12), TX3 decimal(31,12), TX4 decimal(31,12), TX5 decimal(31,12) )' )
		elseif Alltrim(Upper(TcGetDb()))=="DB2"
			TCSqlExec('CREATE TABLE '+cTmp1+' ( TAREFA varchar('+ltrim(str(TamSX3("AF2_TAREFA")[1]))+'), VALOR double, QUANT decimal(31,12), VALOR1 decimal(31,12), VALOR2 decimal(31,12), VALOR3 decimal(31,12), VALOR4 decimal(31,12), VALOR5 decimal(31,12), MOEDA decimal(31,12), DTCONV varchar(8), TX1 double, TX2 double, TX3 double, TX4 double, TX5 double )' )
		else                              
			TCSqlExec('DROP TABLE '+cTmp1)	
		   	TCSqlExec('CREATE TABLE '+cTmp1+' ( TAREFA varchar('+ltrim(str(TamSX3("AF2_TAREFA")[1]))+'), VALOR numeric(31,12), QUANT numeric(31,12), VALOR1 numeric(31,12), VALOR2 numeric(31,12), VALOR3 numeric(31,12), VALOR4 numeric(31,12), VALOR5 numeric(31,12), MOEDA numeric(31,12), DTCONV varchar(8), TX1 numeric(31,12), TX2 numeric(31,12), TX3 numeric(31,12), TX4 numeric(31,12), TX5 numeric(31,12) )' )	
		endif

		if Alltrim(Upper(TcGetDb()))=="INFORMIX"
			TCSqlExec('CREATE TABLE '+cTmp2+' ( TAREFA2    char('+ltrim(str(TamSX3("AF2_TAREFA")[1]))+'), EDTPAI    char('+ltrim(str(TamSX3("AF2_EDTPAI")[1]))+'), BDI decimal(31,12), FLAG integer, UTIBDI    char('+ltrim(str(TamSX3("AF2_UTIBDI")[1]))+') )' )
		else                         
			TCSqlExec('DROP TABLE '+cTmp2) 
			TCSqlExec('CREATE TABLE '+cTmp2+' ( TAREFA2 varchar('+ltrim(str(TamSX3("AF2_TAREFA")[1]))+'), EDTPAI varchar('+ltrim(str(TamSX3("AF2_EDTPAI")[1]))+'), BDI numeric(31,12), FLAG integer, UTIBDI varchar('+ltrim(str(TamSX3("AF2_UTIBDI")[1]))+') )' )
		endif

		if !lBlock // Se não tiver ponto de entrada, calcula também as EDT's
			Pms100Exec(AF2->(xFilial()), cOrcamento, cPmsCust, DTOS(dDataBase), aDecCst, 1, 1, cTmp1, cTmp2, cProc)
		else
			// Atualiza tarefas
			Pms100Exec(AF2->(xFilial()), cOrcamento, cPmsCust, DTOS(dDataBase), aDecCst, 1, 0, cTmp1, cTmp2, cProc)

			AF2->(MsSeek(xFilial()+cOrcamento,.T.))
 			do while AF2->AF2_ORCAME=cOrcamento .and. !AF2->(Eof())
				// ponto de entrada para que o cliente customizar o calculo do custo da tarefa
				nRecAF2 := AF2->( Recno() )
				ExecBlock("PMSXCust") // calcula o custo
				AF2->( dbgoto( nRecAF2 ) )

				AF2->(DbSkip())
			enddo

			// Atualiza EDT's
			Pms100Exec(AF2->(xFilial()), cOrcamento, cPmsCust, DTOS(dDataBase), aDecCst, 0, 1, cTmp1, cTmp2, cProc)
		endif

		MsErase(cTmp1,,"TOPCONN")
		MsErase(cTmp2,,"TOPCONN")

		if TcSqlExec('DROP PROCEDURE '+cProc)<>0
			if !__lBlind
				MsgAlert('Erro excluindo procedure'+" "+cProc+": "+TCSqlError())   //'Erro excluindo procedure'
			endif
		endif

	else
  // comentado por alexandre para teste de utilizacao em producao

		nProcRegua:=0

		dbSelectArea("AF2")
		dbSetOrder(1)
		dbSeek(xFilial()+cOrcamento)
		nRec:=AF2->(RecNo())
		While !Eof() .And. xFilial()+cOrcamento == AF2_FILIAL+AF2_ORCAME
			nProcRegua++
			dbSkip()
		End
		nProcRegua--

		dbSelectArea("AF5")
		dbSetOrder(1)
		dbSeek(xFilial()+cOrcamento)
		nRec:=AF5->(RecNo())
		While !Eof() .And. xFilial()+cOrcamento == AF5_FILIAL+AF5_ORCAME
			nProcRegua++ 
			dbSkip()
		End
		nProcRegua--

		ProcRegua(nProcRegua)
	
		AAdd( aStruct, { "TRB_NIVEL", "C", Len( AF5->AF5_NIVEL ), 0 } )
		AAdd( aStruct, { "TRB_EDT"  , "C", Len( AF5->AF5_EDT ), 0 } )
		AAdd( aStruct, { "TRB_RECNO", "N", 10, 0 } )

		cArqTrab := CriaTrab( aStruct, .T. )

		dbUseArea(.T.,,cArqTrab,"TRAB",.F.,.F.)
		index on DESCEND(TRB_NIVEL)+TRB_EDT to (cArqTrab)
		TRAB->(DbSetOrder(1))
		dbSelectArea("TRAB")
		
		AF5->(dbSetOrder(3))
		AF5->(MsSeek(xFilial()+cOrcamento,.T.))
		do while AF5->AF5_FILIAL=xFilial("AF5") .and. AF5->AF5_ORCAME=cOrcamento .and. !AF5->(Eof())
			TRAB->(RecLock("TRAB",.T.))
			TRAB->TRB_NIVEL:= AF5->AF5_NIVEL
			TRAB->TRB_EDT  := AF5->AF5_EDT
			TRAB->TRB_RECNO:= AF5->(Recno())
			TRAB->(MsUnLock())
			AF5->(DbSkip())
		enddo
		
		AF2->(dbSetOrder(1))
		AF3->(dbSetOrder(1))
		AF4->(dbSetOrder(1))
		
		AF2->(MsSeek(xFilial("AF2")+cOrcamento,.T.))
		AF3->(MsSeek(xFilial("AF3")+AF2->AF2_ORCAME+AF2->AF2_TAREFA,.T.))
		AF4->(MsSeek(xFilial("AF4")+AF2->AF2_ORCAME+AF2->AF2_TAREFA,.T.))
		do while AF2->AF2_FILIAL=xFilial("AF2") .and. AF2->AF2_ORCAME=cOrcamento .and. !AF2->(Eof())
			aTX2M[1]:=1
			aTX2M[2]:=AF2->AF2_TXMO2
			aTX2M[3]:=AF2->AF2_TXMO3
			aTX2M[4]:=AF2->AF2_TXMO4
			aTX2M[5]:=AF2->AF2_TXMO5
			
			nQuantTrf:=AF2->AF2_QUANT
			
			aCustoAF2[1]:=0; aCustoAF2[2]:=0; aCustoAF2[3]:=0; aCustoAF2[4]:=0; aCustoAF2[5]:=0
			
            // Pula tarefas que não existem
			do while AF3->AF3_ORCAME=AF2->AF2_ORCAME .and. AF3->AF3_TAREFA<AF2->AF2_TAREFA .and. !AF3->(Eof())
				AF3->(DbSkip())
			enddo
			// Recursos
			do while AF3->AF3_ORCAME=AF2->AF2_ORCAME .and. AF3->AF3_TAREFA=AF2->AF2_TAREFA .and. !AF3->(Eof())
				nCusto:=AF3->AF3_CUSTD*AF3->AF3_QUANT
				nMoeda:=AF3->AF3_MOEDA
				
				aVal[1] := if(aTX2M[1]==0, xMoeda(nCusto,nMoeda,1,dDtConv,aDecCst[1]), xMoeda(nCusto,nMoeda,1,,aDecCst[1],aTX2M[nMoeda],aTX2M[1]))
				aVal[2] := if(aTX2M[2]==0, xMoeda(nCusto,nMoeda,2,dDtConv,aDecCst[2]), xMoeda(nCusto,nMoeda,2,,aDecCst[2],aTX2M[nMoeda],aTX2M[2]))
				aVal[3] := if(aTX2M[3]==0, xMoeda(nCusto,nMoeda,3,dDtConv,aDecCst[3]), xMoeda(nCusto,nMoeda,3,,aDecCst[3],aTX2M[nMoeda],aTX2M[3]))
				aVal[4] := if(aTX2M[4]==0, xMoeda(nCusto,nMoeda,4,dDtConv,aDecCst[4]), xMoeda(nCusto,nMoeda,4,,aDecCst[4],aTX2M[nMoeda],aTX2M[4]))
				aVal[5] := if(aTX2M[5]==0, xMoeda(nCusto,nMoeda,5,dDtConv,aDecCst[5]), xMoeda(nCusto,nMoeda,5,,aDecCst[5],aTX2M[nMoeda],aTX2M[5]))
				
				PMS_TRUNCA aVal[1], aVal[2], aVal[3], aVal[4], aVal[5], aDecCst[1], aDecCst[2], aDecCst[3], aDecCst[4], aDecCst[5], nQuantTrf, cTrunca, lTotal TO aCustoAF2[1], aCustoAF2[2], aCustoAF2[3], aCustoAF2[4], aCustoAF2[5]
				
				AF3->(DbSkip())
			enddo
            // Pula tarefas que não existem
			do while AF4->AF4_ORCAME=AF2->AF2_ORCAME .and. AF4->AF4_TAREFA<AF2->AF2_TAREFA .and. !AF4->(Eof())
				AF4->(DbSkip())
			enddo
			// Tarefas
			do while AF4->AF4_ORCAME=AF2->AF2_ORCAME .and. AF4->AF4_TAREFA=AF2->AF2_TAREFA .and. !AF4->(Eof())
				nCusto:=AF4->AF4_VALOR
				nMoeda:=AF4->AF4_MOEDA
				
				aVal[1] := if(aTX2M[1]==0, xMoeda(nCusto,nMoeda,1,dDtConv,aDecCst[1]), xMoeda(nCusto,nMoeda,1,,aDecCst[1],aTX2M[nMoeda],aTX2M[1]))
				aVal[2] := if(aTX2M[2]==0, xMoeda(nCusto,nMoeda,2,dDtConv,aDecCst[2]), xMoeda(nCusto,nMoeda,2,,aDecCst[2],aTX2M[nMoeda],aTX2M[2]))
				aVal[3] := if(aTX2M[3]==0, xMoeda(nCusto,nMoeda,3,dDtConv,aDecCst[3]), xMoeda(nCusto,nMoeda,3,,aDecCst[3],aTX2M[nMoeda],aTX2M[3]))
				aVal[4] := if(aTX2M[4]==0, xMoeda(nCusto,nMoeda,4,dDtConv,aDecCst[4]), xMoeda(nCusto,nMoeda,4,,aDecCst[4],aTX2M[nMoeda],aTX2M[4]))
				aVal[5] := if(aTX2M[5]==0, xMoeda(nCusto,nMoeda,5,dDtConv,aDecCst[5]), xMoeda(nCusto,nMoeda,5,,aDecCst[5],aTX2M[nMoeda],aTX2M[5]))
				
				PMS_TRUNCA aVal[1], aVal[2], aVal[3], aVal[4], aVal[5], aDecCst[1], aDecCst[2], aDecCst[3], aDecCst[4], aDecCst[5], nQuantTrf, cTrunca, lTotal TO aCustoAF2[1], aCustoAF2[2], aCustoAF2[3], aCustoAF2[4], aCustoAF2[5]
				
				AF4->(DbSkip())
			enddo

			AF2->(RecLock("AF2",.F.))
			AF2->AF2_CUSTO := aCustoAF2[1]
			AF2->AF2_CUSTO2:= aCustoAF2[2]
			AF2->AF2_CUSTO3:= aCustoAF2[3]
			AF2->AF2_CUSTO4:= aCustoAF2[4]
			AF2->AF2_CUSTO5:= aCustoAF2[5]	
			AF2->AF2_VALBDI:= aCustoAF2[1]*iif(AF2->AF2_BDI<>0,AF2->AF2_BDI,PmsGetBDIPad('AF5',AF2->AF2_ORCAME,,AF2->AF2_EDTPAI, AF2->AF2_UTIBDI ))/100
			AF2->AF2_TOTAL := aCustoAF2[1]+AF2->AF2_VALBDI
			AF2->(MsUnLock())

			// ponto de entrada para que o cliente possa customizar o calculo do custo da tarefa
			if lBlock
				nRecAF2 := AF2->( Recno() )
				ExecBlock("PMAF2CST") // calcula o custo   
				AF2->( dbgoto( nRecAF2 ) )
			endif
			
			AF2->(DbSkip())
			
			IncProc()
		enddo
		
		AF5->(DbSetOrder(2))
		AF2->(DbSetOrder(2))
		TRAB->(DbGoTop())
		do while !TRAB->(Eof())
			n1:=n2:=n3:=n4:=n5:=n6:=0
			
			if AF5->(MsSeek(xFilial("AF5") + cOrcamento + TRAB->TRB_EDT))
				do while !AF5->(Eof()) .And. (xFilial("AF5") + cOrcamento + TRAB->TRB_EDT == AF5->AF5_FILIAL + AF5->AF5_ORCAME + AF5->AF5_EDTPAI)
					n1 += AF5->AF5_CUSTO
					n2 += AF5->AF5_CUSTO2
					n3 += AF5->AF5_CUSTO3
					n4 += AF5->AF5_CUSTO4
					n5 += AF5->AF5_CUSTO5
					n6 += AF5->AF5_VALBDI
					AF5->(DbSkip())
				enddo
			endif
			
			if AF2->(MsSeek(xFilial("AF2") + cOrcamento + TRAB->TRB_EDT))
				do while !AF2->(Eof()) .And. (xFilial("AF2") + cOrcamento + TRAB->TRB_EDT == AF2->AF2_FILIAL + AF2->AF2_ORCAME + AF2->AF2_EDTPAI)
					n1 += AF2->AF2_CUSTO
					n2 += AF2->AF2_CUSTO2
					n3 += AF2->AF2_CUSTO3
					n4 += AF2->AF2_CUSTO4
					n5 += AF2->AF2_CUSTO5
					n6 += AF2->AF2_VALBDI
					AF2->(DbSkip())
				enddo
			endif
			
			AF5->(DbGoto(TRAB->TRB_RECNO))
			RecLock("AF5",.F.)
			AF5->AF5_CUSTO	:= n1
			AF5->AF5_CUSTO2	:= n2
			AF5->AF5_CUSTO3	:= n3
			AF5->AF5_CUSTO4	:= n4
			AF5->AF5_CUSTO5	:= n5
			AF5->AF5_VALBDI	:= n6
			AF5->AF5_TOTAL := n1+n6
			AF5->(MsUnlock())
			
			TRAB->(DbSkip())

			IncProc()
		enddo
		
		TRAB->(DbCloseArea())
		
		FErase(AllTrim(cArqTrab)+GetDBExtension())
		FErase(AllTrim(cArqTrab)+OrdBagExt())
	endif  // comentado por alexandre para teste de utilizacao em producao
EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100ChangeEDT  ³ Autor ³ Fabio Rogerio Pereira  ³ Data ³ 17/10/2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Realiza a troca da EDTPai da EDT/Tarefa selecionada.			        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                         			            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100ChangeEDT(oTree,cArquivo)
Local cAlias  := ""
Local cNivel  := ""
Local cEDTPai := ""
Local cEDTAnt := ""
Local nRecno  := 0
Local aEDT    := {}
Local aArea   := GetArea()
Local lRet    := .F.
Local cOldCode := ""

Local cEDTOrig := ""
Local cEDTDest := ""
Local cOrcamento := ""

// verifica o alias e recno do item selecionado
If oTree != Nil
	cAlias:= SubStr(oTree:GetCargo(),1,3)
	nRecno:= Val(SubStr(oTree:GetCargo(),4,12))
Else
	cAlias := (cArquivo)->ALIAS
	nRecNo := (cArquivo)->RECNO
EndIf

// somente permite a alteracao da EDT Pai de EDT's e Tarefas
If !(cAlias $ "AF2/AF5")
	Return(.F.)
EndIf

// valida o nivel e a data de inicializacao real da EDT/Tarefa selecionada.
// nao permite a troca da EDT principal e tambem de itens que ja foram
// iniciados.
dbSelectArea(cAlias)
dbGoTo(nRecNo)
If &(cAlias + "->"+cAlias+"_NIVEL") == "001"
	Return(.F.)
EndIf

If cAlias == "AF5"
	cOrcamento := AF5->AF5_ORCAME
	cEDTOrig   := AF5->AF5_EDT
Else
	cOrcamento := AF2->AF2_ORCAME
	cEDTOrig   := AF2->AF2_EDTPAI
EndIf	

// exibe uma tela de selecao dos projetos para importacao
aEDT := 	PmsSelTsk("Selecione a nova EDT","AF1/AF5/AF2","AF5","Selecao Invalida","AF1",AF1->AF1_ORCAME,.F.,.F.) // //

If (Len(aEDT) > 0)
	lRet:= .T.
    
	AF5->(dbGoTo(aEDT[2]))
	cEDTPai:= AF5->AF5_EDT
	cNivel := StrZero(Val(AF5->AF5_NIVEL) + 1, TamSX3("AF5_NIVEL")[1])

	Do Case
		Case cAlias == "AF2"
			dbSelectArea("AF2")
			dbGoTo(nRecNo)
			RecLock("AF2",.F.)
			
			cEDTAnt:= AF2->AF2_EDTPAI
			If GetMV("MV_PMSTCOD") == "2"		
				cOldCode := AF2->AF2_TAREFA			
				AF2->AF2_TAREFA := PMSNumAF2(AF2->AF2_ORCAME,;
				                             PMSGetNivOrc(AF2->AF2_ORCAME,cEDTPai),;
				                             cEDTPai)
			EndIf			
			Replace AF2->AF2_EDTPAI With cEDTPai
			Replace AF2->AF2_NIVEL  With cNivel
			MsUnLock() 
			
			If GetMV("MV_PMSTCOD") == "2"			
				AF2AtuCode(AF2->AF2_FILIAL, AF2->AF2_ORCAME, cOldCode, AF2->AF2_TAREFA)
			EndIf
						
			// executa o recalculo do custo das tarefas e edt
			PmsAF2CusEDT(AF2->AF2_ORCAME,cEDTAnt)
			
			// executa o recalculo do custo das tarefas e edt
			PmsAF2CusEDT(AF5->AF5_ORCAME,AF5->AF5_EDT)
			
		Case cAlias == "AF5"
			// Verifica se a operação de troca de EDT
			// não causa uma referência circular
			If !PMSAF5CheckRef(cOrcamento, cEDTOrig, cEDTPai)
				dbSelectArea("AF5")
				dbGoTo(nRecNo)
				RecLock("AF5",.F.)
				cEDTAnt:= AF5->AF5_EDT
	
				// altera o codigo da EDT se o modo de codigo for automatico
				If GetMV("MV_PMSTCOD") == "2"
					cOldCode := AF5->AF5_EDT			
					AF5->AF5_EDT := PMSNumAF5(AF5->AF5_ORCAME,;
					                          PMSGetNivOrc(AF5->AF5_ORCAME, cEDTPai),;
					                          cEDTPai)
				EndIf
				Replace AF5->AF5_EDTPAI With cEDTPai
				Replace AF5->AF5_NIVEL  With cNivel
				MsUnLock()
				
				// recodificar as tarefas se o modo de codigo for automatico
				If GetMV("MV_PMSTCOD") == "2"			
					PMSAF5Cod(AF5->AF5_ORCAME, AF5->AF5_EDT, cEDTAnt)
				EndIf     
				
				If GetMV("MV_PMSTCOD") == "2"			
					AF5RecRelTables(AF5->AF5_FILIAL, AF5->AF5_ORCAME, cOldCode, AF5->AF5_EDT)
				EndIf
				
				// recalcular os niveis abaixo dela
				PMSAF5Nivel(AF5->AF5_ORCAME, cEdtAnt, AF5->AF5_NIVEL)

				// executa o recalculo do custo das tarefas e edt
				PmsAF2CusEDT(AF5->AF5_ORCAME,AF5->AF5_EDT)
			Else
				Aviso("Troca nao efetuada",;
				      "Esta operacao de troca de EDT pai nao pode ser realizada pois causa uma referencia circular.",;
				      { "Ok" }, 2)  //##
			
				lRet := .F.
			EndIf
	EndCase
	
EndIf

RestArea(aArea)
Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A100Opn ³ Autor ³ Adriano Ueda           ³ Data ³ 04-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Abre o arquivo de configuracoes, se nao encontrar cria o arq. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPMS                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A100Opn(aCampos,cArquivo,cMV1,cMV2)
Local cCampos
Local aCampos2	:= {}
Local aFile     := {}

DEFAULT cArquivo := "\PROFILE\PMSA100"
DEFAULT cMV1 := "MV_PMSPLNA"
DEFAULT cMV2 := "MV_PMSPLNB"

If !File(cArquivo + PMS_SHEET_EXT)
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !( dbSeek( "  " + cMV1 ) )
		RecLock("SX6",.T.)
		Replace X6_FIL    With "  "
		Replace X6_VAR    With cMV1
		Replace X6_TIPO   With "C"
		Replace X6_CONTEUD  With "_HDURAC#_CALEND#"
		Replace X6_CONTENG  With ""
		Replace X6_CONTSPA  With ""
		Replace X6_DESCRIC  With "Parametro que indica quais os campos que devem  "
		Replace X6_DESC1    With "aparecer na planilha do programa PMSA100.       "
		
		Replace X6_DSCSPA   With "Parametro que indica  los campos que deben  "
		Replace X6_DSCSPA1  With "aparecer en la planilla del programa PMSA100.    " 
	
		
		Replace X6_DSCENG   With "This parameter indicates the fields that must be" 
		Replace X6_DSCENG1  With "displayed in PMSA100 program`s worksheet.       " 
	
	EndIf
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !( dbSeek( "  " + cMV2 ) )
		RecLock("SX6",.T.)
		Replace X6_FIL    With "  "
		Replace X6_VAR    With cMV2
		Replace X6_TIPO   With "C"
		Replace X6_CONTEUD  With ""
		Replace X6_CONTENG  With ""
		Replace X6_CONTSPA  With ""
		Replace X6_DESCRIC  With "Parametro que indica quais os campos que devem  "
		Replace X6_DESC1    With "aparecer na planilha do programa PMSA100.       "
		
		Replace X6_DSCSPA   With "Parametro que indica  los campos que deben  "
		Replace X6_DSCSPA1  With "aparecer en la planilla del programa PMSA100.    " 
		
		Replace X6_DSCENG   With "This parameter indicates the fields that must be" 
		Replace X6_DSCENG1  With "displayed in PMSA100 program`s worksheet.       " 
	EndIf
	
	cCampos := Alltrim(GetMv(cMV1))
	cCampos += Alltrim(GetMv(cMV2))
	cCmpPln	:= cCampos	
	While !Empty(AllTrim(cCampos))
		If AT("#",cCampos) > 0
			cAux := Substr(cCampos,1,AT("#",cCampos)-1)
			aAdd(aCampos,{"AF2"+cAux,"AF5"+cAux,,,,.F.,"",})
			aAdd(aCampos2,{,Substr(cAux,2,Len(cAux)-1)})
		    cCampos := Substr(cCampos,AT("#",cCampos)+1,Len(cCampos)-AT("#",cCampos))
		 Else
		 	cCampos := ''
		 EndIf
	End
	GravaOrc(aCampos2, {}, cArquivo, 1)	
	cArqPLN	:= AllTrim(cArquivo + PMS_SHEET_EXT)	

Else

	If ReadSheetFile(AllTrim(cArquivo + PMS_SHEET_EXT), aFile)

		// {versao, campos, senha, descricao, freeze, indent}
		cPLNVer    := aFile[1]
		cArqPLN    := AllTrim(cArquivo + PMS_SHEET_EXT)
		cCmpPLN    := aFile[2]
		cPLNSenha  := aFile[3]
		cPLNDescri := aFile[4]
		nFreeze    := aFile[5]
		nIndent    := aFile[6]
		lSenha := !Empty(aFile[3])		

		If lSenha
			cCmpPLN    := Embaralha(cCmpPLN, 0)
			cPLNDescri := Embaralha(cPLNDescri, 0)
		EndIf

		C050ChkPln(@aCampos)
	Else
		Aviso("Falha na Abertura.", "Erro na abertura do arquivo. Verifique a existencia do arquivo selecionado.",{"Ok"},2) //###
	EndIf
	If AllTrim(cPLNVer) != "001" .And. AllTrim(cPLNVer) != "002"
		Aviso("Falha no Arquivo.", "Estrutura do arquivo incompativel. Verifique o arquivo selecionado.",{"Ok"},2 )  //###
		cCmpPLN	:= ''
	EndIf
EndIf        

Return( NIL )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100ReC³ Autor ³ Reynaldo Miyashita     ³ Data ³ 06.12.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Refaz todo calculo o custo do orcamento.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPMS                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LIS100ReCalc()

	If AF1->(FieldPos("AF1_RECALC")) > 0 .And. AF1->AF1_RECALC != "1"
		RecLock("AF1",.F.)
			AF1->AF1_RECALC := "1"
		MsUnlock()
	EndIf
		
	If (AF1->(FieldPos("AF1_RECALC")) > 0 .And. AF1->AF1_RECALC=="1") .Or. AF1->(FieldPos("AF1_RECALC")) <= 0

		// verifica a existencia do ponto de entrada PMS100A2 do Template - Recalculo dos encargos
		If ExistTemplate("PMS100A2")
			ExecTemplate("PMS100A2",.F.,.F.)
		EndIf
	
		If HasTemplate("CCT") .And. ;
		   GetMv("MV_PMSCUST") == "2" .And. ;
		   GetNewPar("MV_CCTUNIT", "1")	== "2" //.And. ;
		   //GetNewPar("MV_CCTBDIU", "1") == "2"

			MsgRun("Recalculando o orçamento...", "Aguarde", ;
			       {|| T_CctNwBuCost(AF1->AF1_ORCAME) })
			       
			//
			//
		Else
	
			// atualiza os custos das tarefas e das edts
			Processa({||Pms100AuxEDT()},"Atualizando Custos da EDT. Aguarde...") //
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Incluido por Alexandre em 27/09/2010                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		DbSelectArea("AF5")
//		DbSetOrder(1) //AF5_FILIAL, AF5_ORCAME, AF5_EDT, AF5_ORDEM, R_E_C_N_O_, D_E_L_E_T_
//		DbSeek(xFilial('AF5')+AF1->AF1_ORCAME)
//		While AF5->(!EOF()) .and. AF5->AF5_FILIAL = xFilial('AF5') .and. AF5->AF5_ORCAME = AF1->AF1_ORCAME
//			If AF5->AF5_BDITAR <> 0
//				RecLock('AF5')
//				AF5->AF5_BDITAR := (AF5->AF5_VALBDI/AF5->AF5_CUSTO)*100
//				MsUnLock()
//			EndIf
//			AF5->(DbSkip())
//		EndDo

		If AF1->(FieldPos("AF1_RECALC")) > 0 
			RecLock("AF1",.F.)
				AF1->AF1_RECALC := "2"
			MsUnlock()
		EndIf
	EndIf
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAF5Che³ Autor ³ Adriano Ueda           ³ Data ³ 20/01/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se é a partir da EDT destino é possível             ³±±
±±³          ³ chegar a EDT de origem, ou seja, ela percorre a              ³±±
±±³          ³ a árvore na ordem inversa, até chegar na EDT                 ³±±
±±³          ³ principal ou encontrar a EDT origem.                         ³±±
±±³          ³                                                              ³±±
±±³          ³ Assume que a EDT origem e a EDT destino pertencem ao mesmo   ³±±
±±³          ³ orçamento.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cOrcamento - código do orçamento no qual será checada        ³±±
±±³          ³ a referência.                                                ³±±
±±³          ³                                                              ³±±
±±³          ³ cEDTOrigem - a EDT a ser verificada (como a árvore é         ³±±
±±³          ³ percorrida do nó folha até o raiz, este é o possível ponto   ³±±
±±³          ³ de término).                                                 ³±±
±±³          ³                                                              ³±±
±±³          ³ cEDTDestino - a EDT inicial, onde começará a ser verificada  ³±±
±±³          ³ a árvore. Como a função é recursiva, poderá ser igual ao     ³±±
±±³          ³ código do orçamento.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ - Retorna .T. se a EDT origem é igual a EDT destino ou a EDT ³±±
±±³          ³ destino não for encontrada na base de dados.                 ³±±
±±³          ³ - Retorna .F. se a EDT destino não foi encontrada percorrendo³±±
±±³          ³ a árvore na ordem inversa ou, ainda, se a EDT destino for    ³±±
±±³          ³ igual ao código do orçamento.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPMS                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMSAF5CheckRef(cOrcamento, cEDTOrig, cEDTDest)
Local aArea    := GetArea()
Local aAreaAF5 := AF5->(GetArea())
Local cEDTProx := ""
Local lRet     := .T.   

	// a EDT origem e EDT destino não podem
	// ser a mesma
	If cEDTOrig  == cEDTDest
		lRet := .T.	
	Else
		// se a EDT destino for igual o orçamento
		// a EDT origem não foi encontrada
		If AllTrim(cEDTDest) == AllTrim(cOrcamento)
			lRet := .F.
		Else
			AF5->(dbSetOrder(1)) 	// AF5_FILIAL + AF5_ORCAME + AF5_EDT
			If AF5->(MsSeek(xFilial("AF5") + cOrcamento + cEDTDest))
				cEDTProx := AF5->AF5_EDTPAI
				lRet := PMSAF5CheckRef(cOrcamento, cEDTOrig, cEDTProx) 	
			EndIf
		
		EndIf
	EndIf
	RestArea(aAreaAF5)
	RestArea(aArea)
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pms100Usr ³ Autor ³Edson Maricate              ³ Data ³ 26-12-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de configuracao dos usuarios do Projeto.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100Usr(cAlias,nReg,nOpcx)
Local oDlg
Local oMenu
Local oTree
Local cArquivo

	If PmsOrcUser(AF1->AF1_ORCAME,,Padr(AF1->AF1_ORCAME,Len(AF5->AF5_EDT)),"  ",3,"ESTRUT")
		
		MENU oMenu POPUP
			MENUITEM "Incluir Usuario" ACTION (PmsUsrDlg(@oTree,nOpcx,1,cArquivo),Eval(bRefresh))  //
			MENUITEM "Alterar Propriedades" ACTION PmsUsrDlg(@oTree,nOpcx,2,cArquivo) //
			MENUITEM "Excluir Usuario" ACTION (PmsUsrDlg(@oTree,nOpcx,3,cArquivo),Eval(bRefresh))  //
		ENDMENU
		
		aMenu := {;
		         {TIP_ORC_INFO,      {||PmsOrcInf()}, BMP_ORC_INFO, TOOL_ORC_INFO},;
		         {TIP_PROJ_USUARIOS, {||Pms100UMenu(@oMenu,@oTree,nOpcx,cArquivo),oMenu:Activate(100,45,oDlg) }, BMP_PROJ_USUARIOS, TOOL_PROJ_USUARIOS}}
		
		PmsDlgAF1(cCadastro,@oMenu,@oTree,"AF5/AF2/USR",{||Pms100UMenu(@oMenu,@oTree,nOpcx,cArquivo)},,aMenu,@oDlg)
	Else
		Aviso("Usuário sem permissão","Usuário sem permissão para alteração nos usuários do orçamento. Verifique as permissões do usuário na estrutura principal do orçamento.",{"Fechar"},2) //######
	EndIf
	                              
Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsUsrCtrMenu³ Autor ³Edson Maricate       ³ Data ³ 29-12-2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que controla as propriedades do Menu PopUp.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pms100UMenu(oMenu,oTree,nOpcx)
Local aArea		:= GetArea()
Local cAlias	:= SubStr(oTree:GetCargo(),1,3)
Local nRecView	:= Val(SubStr(oTree:GetCargo(),4,12))

dbSelectArea(cAlias)
dbGoto(nRecView)


// se for visualizacao desabilita as opcoes.³
If (aRotina[nOpcx,4] == 2)
	oMenu:aItems[1]:Disable()
	oMenu:aItems[2]:Disable()
	oMenu:aItems[3]:Disable()
Else
	Do Case 
		Case cAlias == "AF1"
			oMenu:aItems[1]:Disable()
			oMenu:aItems[2]:Disable()
			oMenu:aItems[3]:Disable()
		Case cAlias == "AF5"
			oMenu:aItems[1]:Enable()
			oMenu:aItems[2]:Disable()
			oMenu:aItems[3]:Disable()
		Case cAlias == "AF2"
			oMenu:aItems[1]:Enable()
			oMenu:aItems[2]:Disable()
			oMenu:aItems[3]:Disable()
		OtherWise
			oMenu:aItems[1]:Disable()
			oMenu:aItems[2]:Enable()
			oMenu:aItems[3]:Enable()
	EndCase
EndIf
	
RestArea(aArea)
Return             

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSUsrDlg   ³ Autor ³ Edson Maricate      ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa de Inclusao,Alteracao,Visualizacao e Exclusao        ³±±
±±³          ³dos Usuarios do Projeto                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMSUsrDlg(oTree,nOpcx,nMenuItem)

Local aArea		:= GetArea()
Local cAlias	:= SubStr(oTree:GetCargo(),1,3)
Local nReg		:= Val(SubStr(oTree:GetCargo(),4,12))
Local oDlg
Local oEnchoice
Local nRecAJF
Local nOpc2		:= 2
Local lInclui	:= .F.
Local lVisual	:= .F.
Local lAltera	:= .F.
Local lExclui	:= .F.
Local lContinua	:= .T.
Local lOk		:= .F.

// define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)
Do Case

	// Inclusao
	Case nMenuItem == 1
		lInclui	:= .T.
		Inclui	:= .T.
		Altera	:= .F.
		nOpc2		:= 3

	// Alteracao
	Case nMenuItem == 2
		lAltera	:= .T.
		Altera	:= .T.
		Inclui  := .F.
		nOpc2		:= 4

	// Exclusao
	Case nMenuItem == 3
		lExclui	:= .T.
		lVisual	:= .T.
		nOpc2		:= 5
EndCase

dbSelectArea(cAlias)
dbGoto(nReg)
If cAlias=="AF5"
	cAlias := "AJF"
EndIf
If cAlias=="AF2"
	cAlias := "AJG"
EndIf
RegToMemory(cAlias,lInclui)

If !lInclui
	If !SoftLock(cAlias)
		lContinua := .F.
	Else
		nRecAJF := (cAlias)->(RecNo())
	Endif
EndIf

If lContinua
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 8,0 TO 29,78 OF oMainWnd
		oEnchoice := MsMGet():New(cAlias,nReg,nOpc2,,,,,{16,1,158,307},,3,,,,oDlg,,,)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||If(Obrigatorio(oEnchoice:aGets,oEnchoice:aTela),(lOk:=.T.,oDlg:End()),Nil)},{|| oDlg:End()}) CENTERED
EndIf

Begin Transaction
	If (lInclui.Or.lAltera.Or.lExclui).And. lOk
		If lContinua
			PMSUsrGrv(cAlias,lExclui,nRecAJF)
		EndIf
	EndIf
End Transaction

RestArea(aArea)
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSUsrGrv   ³ Autor ³ Edson Maricate      ³ Data ³ 29-12-2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa de gravacao dos usuarios do Projeto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMSUsrGrv(cAlias,lDeleta,nRecAJF)
Local nx
Local bCampo 	:= {|n| FieldName(n) }
Local aArea		:= GetArea()

If !lDeleta
	If nRecAJF <> Nil
		(cAlias)->(dbGoto(nRecAJF))
		RecLock(cAlias,.F.)
	Else
		RecLock(cAlias,.T.)
	EndIf
	For nx := 1 TO FCount()
		FieldPut(nx,M->&(EVAL(bCampo,nx)))
	Next nx
	FieldPut(FieldPos(cAlias+"_FILIAL"),xFilial(cAlias))
	dbCommit()
	MsUnlock()
Else
	(cAlias)->(dbGoto(nRecAJF))
	RecLock(cAlias,.F.,.T.)
	dbDelete()
	MsUnlock()
EndIf

RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RecodeOrc      ³ Autor ³Adriano Ueda          ³ Data ³ 26/01/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que gera um novo codigo para EDT/TAREFA do orçamento.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RecodeOrc(oTree, cArquivo)
	Local lReturn  := .F.
	Local lContinua:= .T.
	Local cAlias   := ""
	Local nRecno   := 0
	Local lOk      := .F.     
	Local lEdtPai  := .F.
	Local cNivel   := ""
	Local cGetPict := ""

	Local cOldCode := ""
	Local cNewCode := ""

	Local cOrcame := ""
	Local cEDT     := ""
		
	Local oDlg     := Nil
	Local oGet     := Nil
	Local oNewCode := ""

	If oTree != Nil
		cAlias := SubStr(oTree:GetCargo(), 1, 3)
		nRecno := Val(SubStr(oTree:GetCargo(), 4, 12))
	Else
		cAlias := (cArquivo)->ALIAS
		nRecNo := (cArquivo)->RECNO
	EndIf

	Do Case
		Case cAlias == "AF5"
			dbSelectArea("AF5")
			dbGoTo(nRecNo)

			cOldCode := AF5->AF5_EDT
			cNewCode := Space(TamSX3("AF5_EDT")[1])
			
			cNivelAF5 := If(cAlias == "AF5", AF5->AF5_NIVEL, "000")
			
			cGetPict := ""//X3Picture("AF5_EDT")
			
			cOrcame := AF5->AF5_ORCAME
			
			// se for a EDT Principal do Orçamento
			If Padr(AF5->AF5_ORCAME, TamSX3("AF5_EDT")[1]) == AF5->AF5_EDT .And.;
			   Empty(AF5->AF5_EDTPAI) .And.;
				 AF5->AF5_NIVEL == StrZero(1, TamSX3("AF5_NIVEL")[1])
				lEdtPai := .T.
			EndIf
			
		Case cAlias == "AF2"
			dbSelectArea("AF2")
			dbGoTo(nRecNo)
			
			cOldCode := AF2->AF2_TAREFA
			cNewCode := Space(TamSX3("AF2_TAREFA")[1])
			
			cGetPict := "" //X3Picture("AF2_TAREFA")
			
			cOrcame := AF2->AF2_ORCAME
	
		Otherwise
			lContinua := .F.
			
	EndCase

	If lContinua

		If GetMV("MV_PMSTCOD") == "1" .AND. !lEdtPai
			Define MsDialog oDlg Title "Recodificar Tarefa/EDT" From 0, 0 To 125, 300;
			  Of oMainWnd Pixel //
		
				// codigo atual
				@ 010, 005 Say "Codigo atual:" Of oDlg Pixel //
				@ 009, 045 MSGet cOldCode Of oDlg Size 100, 08 Pixel ReadOnly
				
				// novo codigo
				@ 022, 005 Say "Novo codigo:" Of oDlg Pixel //
				
				If cAlias == "AF2"
					@ 021, 045 MSGet oNewCode Var cNewCode;
					           Valid !ExistOrcTrf(cOrcame, cNewCode) Of oDlg;
					           Picture cGetPict Size 100, 08 Pixel
				Else
					@ 021, 045 MSGet oNewCode Var cNewCode;
					           Valid !ExistOrcEDT(cOrcame, cNewCode) Of oDlg;
					           Picture cGetPict Size 100, 08 Pixel
				EndIf
		
				// OK
				@ 038, 065 Button "OK" Size 35 ,11 FONT oDlg:oFont;
				           Action (lOk := .T., oDlg:End()) Of oDlg Pixel;
				           When !Empty(cNewCode)
		
				// Cancelar
				@ 038, 110 Button "Cancelar" Size 35 ,11 FONT oDlg:oFont;
				           Action (lOk := .F., oDlg:End()) Of oDlg Pixel //
			Activate MsDialog oDlg On Init oNewCode:SetFocus() Centered
		Else
			lOk := .T.
		EndIf

		// cursor ampulheta
		CursorWait()
		
		If lOk
		
			lReturn  := .T.
			
			If cAlias == "AF2"
	
				dbSelectArea("AF2")
				dbGoTo(nRecNo)

				// gera o codigo automatico
				If GetMV("MV_PMSTCOD") == "2"
					cNewCode := PMSNumAF2(AF2->AF2_ORCAME,;
			                          PMSGetNivOrc(AF2->AF2_ORCAME, AF2->AF2_EDTPAI),;
					                      AF2->AF2_EDTPAI,;
					                      AF2->AF2_TAREFA,;
					                      .F.)
				EndIf		
	
				Begin Transaction			
					Reclock(cAlias, .F.)
						AF2->AF2_TAREFA := cNewCode
					MsUnlock()
	
					// libera os codigo reservados
					FreeUsedCode(.T.)
				
					// atualiza a tarefa das outras tabelas relacionadas
					AF2RecRelTables(AF2->AF2_FILIAL, AF2->AF2_ORCAME, cOldCode, cNewCode)
				End Transaction  
				
			Else
			
				dbSelectArea("AF5")
				dbGoTo(nRecNo)
				
				// se for EDT Principal, deve recodificar as EDT/tarefas filhas
				If lEdtPai
					Begin Transaction
						
						// atualiza a TAREFA/EDT filhas da EDT
						AF5ReCode(cGetPict, Padr(cOrcame, TamSX3("AF5_EDT")[1]), cOrcame, cNivelAF5)
					End Transaction
				Else
					
					// gera o codigo automatico
					If GetMV("MV_PMSTCOD") == "2"
						cNewCode := PMSNumAF5(AF5->AF5_ORCAME,;
						                      PMSGetNivOrc(AF5->AF5_ORCAME, AF5->AF5_EDTPAI),;
						                      AF5->AF5_EDTPAI,;
						                      AF5->AF5_EDT,;
						                      .F.)
					EndIf
				
					Begin Transaction
						
						Reclock("AF5", .F.)
							AF5->AF5_EDT := cNewCode
						MsUnlock()
						
						// libera o codigo reservado
						FreeUsedCode(.T.)
						
						cNewCode := AF5->AF5_EDT
						
						// atualiza a EDT PAI das tarefas-filhas
						AF5AtuTrf(AF5->AF5_FILIAL, AF5->AF5_ORCAME, cOldCode, cNewCode)
							
						// atualiza a EDT PAI das EDT Filhas e a EDT das outras tabelas relacionadas
						AF5RecRelTables(AF5->AF5_FILIAL, AF5->AF5_ORCAME, cOldCode, cNewCode)
						
						// atualiza a TAREFA/EDT filhas da EDT
						AF5ReCode(cGetPict, cNewCode, cOrcame, cNivelAF5)
						
					End Transaction
				EndIf
			EndIf
		EndIf
		
		// cursor seta
		CursorArrow()
		
	EndIf
Return lReturn

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AF5ReCode       ³ Autor ³Reynaldo Miyashita    ³ Data ³ 16/01/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que gera um novos codigos para EDT/TAREFA filhas referentes ³±±
±±³          ³ ao codigo da EDT informado do Orçamento.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AF5ReCode(cGetPict, cNewCode, cOrcame, cNivelAF5)
Local nLoop   := 0
Local aFilhos := {}
Local aParam  := {}
Local aConfig := {}
Local cCodigo := ""
Local cEDTPai := ""
    
	// obtem todas EDT filhas
	dbSelectArea("AF5")
	dbSetOrder(2)
	dbSeek(xFilial("AF5") + cOrcame + cNewCode)
	While AF5->(!Eof()) .And. ;
	      AF5->(AF5_FILIAL + AF5_ORCAME + AF5_EDTPAI) ==;
				xFilial("AF5") + cOrcame + cNewCode
	      
		aAdd(aFilhos ,{ "AF5" ;
					   ,iIf(Empty(AF5->AF5_ORDEM), "000", AF5->AF5_ORDEM);
					   ,AF5->AF5_EDT ;
					   ,AF5->(recno()) } )
		dbSkip()
	End
	
	// obtem todas tarefas filhas
	dbSelectArea("AF2")
	dbSetOrder(2)
	dbSeek(xFilial("AF2") + cOrcame + cNewCode)
	While AF2->(!Eof()) .AND. ;
		AF2->(AF2_FILIAL + AF2_ORCAME + AF2_EDTPAI)==;
		xFilial("AF2")+ cOrcame + cNewCode
		aAdd(aFilhos ,{"AF2",;
		               If(Empty(AF2->AF2_ORDEM), "000", AF2->AF2_ORDEM),;
		               AF2->AF2_TAREFA,;
		               AF2->(recno())})
		dbSkip()
	End
	
	// ordena por nivel e codigo EDT/Tarefa
	aSort(aFilhos,,, {|x, y| x[2]+x[3] < y[2]+y[3] })
	
	cCodigo := cNewCode
	For nLoop := 1 To len(aFilhos)
		If aFilhos[nLoop][1] == "AF5"
				
			dbSelectArea("AF5")
			dbGoto(aFilhos[nLoop][4])
			
			cEDTPai := AF5->AF5_EDTPAI
			
			// se for a EDT Principal do Orçamento
			If padr(AF5->AF5_ORCAME,TamSX3("AF5_EDT")[1]) == cCodigo
				cCodigo := ""
				cEdtPai := ""
			EndIf
		
			If GetMV("MV_PMSTCOD") == "1"
				aParam  :=  {;
				             {1, "Orçamento", cOrcame, "@!",,"", ".F.", 55 ,.F.},; //
				             {1, "Cod. Anterior:", AF5->AF5_EDT, "@!",,"", ".F.", 55 ,.F.},; //
				             {1, "Novo Codigo:", Space(TamSX3("AF5_EDT")[1]), "@!" ,'ExistChav("AF5", "' + cOrcame + '"+ mv_par03 ) .And.FreeForUse("AF5","'+ cOrcame + '" + mv_par03)',"","", 55 ,.T.}; //
				            }
				aConfig := {}
				
				If ParamBox(aParam, "Renomear codigo da EDT", aConfig,,,.F.,90,15,,ProcName(0)+"AF5",.F.) //
					cCodigo := aConfig[3]
				Else
					Exit
				EndIf
				
			EndIf
			
			If GetMV("MV_PMSTCOD") == "2"
				cCodigo := PMSNumAF5(AF5->AF5_ORCAME,;
				                     PMSGetNivOrc(AF5->AF5_ORCAME, AF5->AF5_EDTPAI),;
				                     cEdtPai,;
				                     cCodigo,;
					                   .F.)
			EndIf
			
			Reclock("AF5", .F.)
				AF5->AF5_EDT := cCodigo
			MsUnlock()
			
			// libera o codigo reservado
			FreeUsedCode(.T.)
		 	
			cCodigo := AF5->AF5_EDT
			
			// atualiza a EDT PAI das tarefas-filhas
			AF5AtuTrf(AF5->AF5_FILIAL, AF5->AF5_ORCAME, aFilhos[nLoop][3], cCodigo)
				
			// atualiza a EDT PAI das EDT Filhas e a EDT das outras tabelas relacionadas
			AF5RecRelTables(AF5->AF5_FILIAL, AF5->AF5_ORCAME, aFilhos[nLoop][3], cCodigo)
			
			// atualiza a TAREFA/EDT filhas da EDT
			AF5ReCode(cGetPict, cCodigo, cOrcame, cNivelAF5)
				
		EndIf
		
		If aFilhos[nLoop][1] == "AF2"
			dbSelectArea("AF2")
			dbGoto(aFilhos[nLoop][4])
			
			cEDTPai := AF2->AF2_EDTPAI
			
			// se for a EDT Principal do orçamento
			If padr(AF2->AF2_ORCAME,TamSX3("AF2_TAREFA")[1]) == cCodigo
				cCodigo := ""
				cEdtPai := ""
			EndIf
		
			If GetMV("MV_PMSTCOD") == "1"
				aParam  :=  {;                                                                                                                                                                                        
				             {1, "Orçamento:", cOrcame, "@!",,"", ".F.", 55 ,.F.},; //              
							 {1, "Cod. Anterior:", AF2->AF2_TAREFA, "@!",,"", ".F.", 55 ,.F.},; // 
							 {1, "Novo Codigo:", Space(TamSX3("AF2_TAREFA")[1]), "@!" ,'ExistChav("AF2", "' + cOrcame + '"+ mv_par03 ) .And.FreeForUse("AF2","'+ cOrcame + '" + mv_par03)',"","", 55 ,.T.}; // "Novo Codigo:" 
							}
				aConfig := {}
				
				If ParamBox(aParam, "Renomear codigo da Tarefa", aConfig,,,.F.,90,15,,ProcName(0)+"AF2",.F.) // 
					cCodigo := aConfig[3]
				Else
					Exit
				EndIf
			EndIf
			
			If GetMV("MV_PMSTCOD") == "2"
				cCodigo := PMSNumAF2(AF2->AF2_ORCAME,;
				                     PMSGetNivOrc(AF2->AF2_ORCAME, AF2->AF2_EDTPAI),;
				                     cEDTPai,;
				                     cCodigo,;
				                     .F.)
			EndIf
			Reclock("AF2", .F.)
				AF2->AF2_TAREFA := cCodigo
			MsUnlock()
						
			// libera o codigo reservado
			FreeUsedCode(.T.)
        	
			// atualiza a TAREFA das outras tabelas relacionadas
			AF2RecRelTables(AF2->AF2_FILIAL, AF2->AF2_ORCAME, aFilhos[nLoop][3], cCodigo)
		EndIf

	Next nLoop
		
Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ExistOrcE ³ Autor ³ Adriano Ueda         ³ Data ³ 26/01/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para verificar a existencia de determinada tarefa.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cOrcame  : codigo do orçamento                               ³±±
±±³          ³ cTarefa  : codigo da tarefa                                  ³±±
±±³          ³ lMensagem: indica se exibira o help de ja gravado            ³±±
±±³          ³            (default: .T.)                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExistOrcEDT(cOrcame, cEDT, lMensagem)
	Local aAreaAF5 := AF5->(GetArea())
	Default lMensagem := .T.
	
	dbSelectArea("AF5")
	AF5->(dbSetOrder(1))
	
	If AF5->(Msseek(xFilial("AF5") + cOrcame + cEDT))
		If lMensagem
			Help(" ", 1, "JAGRAVADO")
		EndIf
		
		lRet := .T.
	Else
		If !(FreeForUse("AF5", cOrcame + cEDT))
			MsgAlert("Código Reservado!") //
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	EndIf

	RestArea(aAreaAF5)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AF5AtuTrf ³ Autor ³ Adriano Ueda         ³ Data ³ 26/01/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para verificar a existencia de determinada tarefa.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cOrcame  : codigo do orçamento                               ³±±
±±³          ³ cTarefa  : codigo da tarefa                                  ³±±
±±³          ³ lMensagem: indica se exibira o help de ja gravado            ³±±
±±³          ³            (default: .T.)                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AF5AtuTrf(cFil, cOrcame, cEDT, cNewEDT)
	Local aParam, aCamposUsr
	Local aCampos := {}
	
	aAdd(aCampos, {"AF2", 2, "AF2_FILIAL+AF2_ORCAME+AF2_EDTPAI",;
	               "AF2_EDTPAI", cFil + cOrcame + cEDT, cNewEDT})
	// AF2_FILIAL+AF2_ORCAME+AF2_EDTPAI+AF2_ORDEM
	
	//Ponto de Entrada para manipulacao do array aCampos
	//passado aCampos e aParam contendo os parametros recebidos pela funcao
	aParam := { cFil, cOrcame, cEDT, cNewEDT}

	If ExistBlock("PM100AF5")
		aCamposUsr := ExecBlock("PM100AF5", .F., .F., {aCampos, aParam})	
		AEval( aCamposUsr, { |x| AAdd( aCampos, x ) } )
	EndIf

	PMSAltera(aCampos)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMS100SubsºAutor  ³Reynaldo Miyashita  º Data ³  10.03.2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que substitui um produto/recurso por outro informadoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMSA100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100Subs()
Local aArea    := GetArea()
Local aAreaSB1 := {}
Local aParam   := {}
Local lUpdate  := .F.
Local aRetCus  := {}

	aParam := PMSSubRec()
	
	If ! Empty(aParam)
	
		// Substituir o produto 
		If aParam[1]
			dbSelectArea("SB1")
			dbSetOrder(1)
			MSSeek(xFilial("SB1")+aParam[3])
		EndIf
		
		// Substituir o recurso
		If aParam[4]
			dbSelectArea("AE8")
			dbSetOrder(1)
			MSSeek(xFilial("AE8")+aParam[6])
		EndIf
		
		ProcRegua( AF2->(LastRec()) )
		
		//
		// busca tarefa a tarefa
		//
		dbSelectArea("AF2")
		dbSetOrder(1)
		MSSeek(xFilial("AF2")+AF1->AF1_ORCAME)
		While AF2->(!Eof()) .AND. (AF2->(AF2_FILIAL+AF2_ORCAME)==xFilial("AF2")+AF1->AF1_ORCAME)

			IncProc()
		
			//
			// busca os produtos e/ou recursos 
			//
			dbSelectArea("AF3")
			dbSetOrder(1)
			MSSeek(xFilial("AF2")+AF2->AF2_ORCAME+AF2->AF2_TAREFA)
			While AF3->(!Eof()) .AND. (AF3->AF3_FILIAL+AF3->AF3_ORCAME+AF3->AF3_TAREFA==xFilial("AF3")+AF2->AF2_ORCAME+AF2->AF2_TAREFA)
	
				// substitui o produto
				If aParam[1] .and. (AF3->(FieldPos("AF3_RECURS")) == 0 .OR. AF3->(FieldPos("AF3_RECURS")) > 0 .And. Empty(AF3->AF3_RECURS))
					If aParam[2] == AF3->AF3_PRODUT 
						RecLock("AF3",.F.)
							AF3->AF3_PRODUT := SB1->B1_COD
							AF3->AF3_MOEDA	:= Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD"))
							AF3->AF3_CUSTD	:= RetFldProd(SB1->B1_COD,"B1_CUSTD")
				
							If ExistTemplate("CCT100_0")
								ExecTemplate("CCT100_0",.F.,.F.)
							EndIf
							
						MsUnlock()
						
						lUpdate := .T.
					EndIf
				EndIf

				// substitui o recurso
				If aParam[4] .AND. (AF3->(FieldPos("AF3_RECURS")) > 0  .And. !Empty(AF3->AF3_RECURS))
					If aParam[5] == AF3->AF3_RECURS
						RecLock("AF3",.F.)
							AF3->AF3_RECURS	:= AE8->AE8_RECURS
							AF3->AF3_PRODUT := AE8->AE8_PRODUT
							AF3->AF3_CUSTD  := AE8->AE8_VALOR
							
							If Empty(AF3->AF3_PRODUT)
								AF3->AF3_MOEDA := 1
							Else
								aAreaSB1 := SB1->(GetArea())
								dbSelectArea("SB1")
								dbSetOrder(1)
								If MSSeek(xFilial("SB1")+AF3->AF3_PRODUT)
									AF3->AF3_MOEDA := Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD"))
									If AF3->AF3_CUSTD == 0
										AF3->AF3_CUSTD := Val(RetFldProd(SB1->B1_COD,"B1_CUSTD"))
									EndIf
								Else
									AF3->AF3_MOEDA := 1
									AF3->AF3_CUSTD := 0
								EndIf
								RestArea(aAreaSB1)
							EndIf
				
							If ExistTemplate("CCT100_0")
								ExecTemplate("CCT100_0",.F.,.F.)
							EndIf
							
						MsUnlock()
						
						lUpdate := .T.
						
					EndIf
				EndIf
				
				dbSelectArea("AF3")
				dbSkip()
			End
			
			If lUpdate
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Grava o custo da tarefa.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ExistTemplate("PMAAF2CTrf")
					ExecTemplate("PMAAF2CTrf",.F.,.F.,{AF2->AF2_ORCAME,AF2->AF2_TAREFA})
				Else
					aRetCus	:= PmsAF2CusTrf(0,AF2->AF2_ORCAME, AF2->AF2_TAREFA)
					RecLock("AF2",.F.)
					Replace AF2->AF2_CUSTO  With aRetCus[1]
					Replace AF2->AF2_CUSTO2 With aRetCus[2]
					Replace AF2->AF2_CUSTO3 With aRetCus[3]
					Replace AF2->AF2_CUSTO4 With aRetCus[4]
					Replace AF2->AF2_CUSTO5 With aRetCus[5]
				    If AF2->(FieldPos('AF2_VALBDI')) > 0 
						AF2->AF2_VALBDI:= aRetCus[1]*IF(AF2->AF2_BDI<>0,AF2->AF2_BDI,PmsGetBDIPad('AF5',AF2->AF2_ORCAME,,AF2->AF2_EDTPAI, If(AF2->(FieldPos('AF2_UTIBDI')) > 0, AF2->AF2_UTIBDI, "1") ))/100
						AF2->AF2_TOTAL := aRetCus[1]+AF2->AF2_VALBDI
					EndIf
					MsUnlock()  
				 EndIf
			    
				PmsAvalAF2("AF2")
				lUpdate := .F.
			EndIf
			
			dbSelectArea("AF2")
			dbSkip()
		End
		
	EndIf

	RestArea(aArea)

Return( .T. )
                
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³30/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Local aRotina 	:= {}
Local aUsRotina	:=	{}

aRotina 	:= {	{ "Pesquisar","AxPesqui"  , 0 , 1,,.F.},; 	//"Pesquisar"
							{ "Visualizar","U_PMSAL1a" , 0 , 2},; 	//"Visualizar"
							{ "Incluir","U_PMSAL1a" , 0 , 3},; 	//
							{ "Alt.Cadastro","U_myPMS100Alt" , 0 , 4},; //
							{ "Alt.Estrutura","U_PMSAL1a" , 0 , 4},; //
							{ "Excluir","U_PMSAL1a" , 0 , 5},;
							{ "Usuarios","Pms100Usr" , 0 , 5},;
							{ "Legenda","PMS100Leg" , 0 , 2, ,.F.}}      //

If AMIIn(44)
	// adiciona botoes do usuario na EnchoiceBar
	If ExistBlock( "PM100ROT" )
		If ValType( aUsRotina := ExecBlock( "PM100ROT", .F., .F. ) ) == "A"
			AEval( aUsRotina, { |x| AAdd( aRotina, x ) } )
		EndIf
	EndIf
EndIf

Return(aRotina)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSPlanAF1³ Autor ³ Cristiano G. da Cunha ³ Data ³ 15.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta uma planilha para visualizacao do orcamento             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cTitle : Titulo da janela                                     ³±±
±±³          ³aCampos: Array contendo os campos a serem visualizados        ³±±
±±³          ³         [1] : Nome do campo AF2                              ³±±
±±³          ³         [2] : Nome do campo AF5                              ³±±
±±³          ³         [3] : Tamanho do campo ( opcional )                  ³±±
±±³          ³         [4] : Decimal do campo ( opcional )                  ³±±
±±³          ³         [5] : Titulo  do campo ( opcional )                  ³±±
±±³          ³         [6] : Permite edicao ( .T./.F. )                     ³±±
±±³          ³         [7] : Validacao                                      ³±±
±±³          ³cArquivo : Nome do arquivo temporario                         ³±±
±±³          ³aButtons : Botoes auxiliares                                  ³±±
±±³          ³         [1] : Titulo do Botao                                ³±±
±±³          ³         [2] : CodeBlock a ser executado                      ³±±
±±³          ³         [3] : Nome do recurso ( BITMAP )                     ³±±
±±³          ³nFreze   : Congelar colunas do Browse                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PmsPlanAF1(cTitle,aCampos,cArquivo,aButtons,nFreze,lConfirma,aMenu,oDlg,lExcel,nIndent)
Local aBOD      := {}
Local aAuxRet
Local aExpand	:= {}
Local nTop      := oMainWnd:nTop+35
Local nLeft     := oMainWnd:nLeft+10
Local nBottom   := oMainWnd:nBottom-12
Local nRight    := oMainWnd:nRight-10
Local oBrowse
Local oMais		:=	LoadBitmap( GetResources(), BMP_SHORTCUTPLUS )
Local oMenos	:= 	LoadBitmap( GetResources(), BMP_SHORTCUTMINUS )
Local oAll		:= 	LoadBitmap( GetResources(), BMP_EXPALL )
Local oCmp		:= 	LoadBitmap( GetResources(), BMP_EXPCMP )
Local nX        := 0

PRIVATE aStru		:= {}
PRIVATE aHeader := {}
PRIVATE aAuxCps	:= aClone(aCampos)
PRIVATE bRefresh	:= {|| (LISPmsAtu(cArquivo,nNivelMax,,aExpand,nIndent),oBrowse:Refresh()) }
PRIVATE bRefreshAll	:= bRefresh //bRefreshAll - sem utilizacao

DEFAULT lExcel	:= .F.                                                    
DEFAULT nIndent := PMS_SHEET_INDENT

RegToMemory("AF1",.F.)
RegToMemory("AF3",.T.)
RegToMemory("AF4",.T.)
RegToMemory("AF5",.F.)
RegToMemory("AF7",.F.)

If ExistBlock("PMSAF102")
	cArquivo := ExecBlock("PMSAF102", .F., .F., {cArquivo})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ExecBlock para inclusao de botoes customizados       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("PMSAF1BD")
	aBOD := ExecBlock("PMSAF1BD",.F.,.F.)
	For nx := 1 to Len(aBOD)
		aAdd(aMenu,{aBOD[nx,1],aBOD[nx,2],aBOD[nx,3],aBOD[nx,4]})
	Next nX
EndIf

For nx := 1 to Len(aCampos)
	dbSelectArea("SX3")
	dbSetOrder(2)
	If MsSeek(aCampos[nx][1])
		aAdd(aHeader,{If(Empty(aCampos[nx][5]),X3TITULO(),aCampos[nx][5]),"X"+Substr(X3_CAMPO,2,Len(X3_CAMPO)-1),X3_PICTURE,If(aCampos[nx][3]!=Nil,aCampos[nx][3],X3_TAMANHO),If(aCampos[nx][4]!=Nil,aCampos[nx][4],X3_DECIMAL),aCampos[nx][7]+"('"+aCampos[nx][1]+"','"+aCampos[nx][2]+"','"+cArquivo+"')",X3_USADO,X3_TIPO,cArquivo,X3_CONTEXT})
		aAdd(aStru,{"X"+Substr(X3_CAMPO,2,Len(X3_CAMPO)),X3_TIPO,X3_TAMANHO,X3_DECIMAL})
	ElseIf MsSeek(aCampos[nx][2])
		aAdd(aHeader,{If(Empty(aCampos[nx][5]),X3TITULO(),aCampos[nx][5]),"XF2"+Substr(X3_CAMPO,4,Len(X3_CAMPO)-1),X3_PICTURE,If(aCampos[nx][3]!=Nil,aCampos[nx][3],X3_TAMANHO),If(aCampos[nx][4]!=Nil,aCampos[nx][4],X3_DECIMAL),aCampos[nx][7]+"('"+aCampos[nx][1]+"','"+aCampos[nx][2]+"','"+cArquivo+"')",X3_USADO,X3_TIPO,cArquivo,X3_CONTEXT})
		aAdd(aStru,{"XF2"+Substr(X3_CAMPO,4,Len(X3_CAMPO)),X3_TIPO,X3_TAMANHO,X3_DECIMAL})
	ElseIf Substr(aCampos[nx][1],1,1) == "$"
		aAdd(aStru,aClone(&(Substr(aCampos[nx][1],2,Len(aCampos[nx][1])-1)+"(1)")))
	ElseIf Substr(aCampos[nx][1],1,1) == "%"
//%123456789012%C%99%2%12345678901234567890123456789012345%123456789012345678901234567890123456789012345678901234567890
		aAdd(aStru,{"FORM"+StrZero(nx,2,0),Substr(aCampos[nx][1],15,1),Val(Substr(aCampos[nx][1],17,2)),Val(Substr(aCampos[nx][1],20,2))})
	EndIf
Next
aAdd(aStru,{"CTRLNIV","C",1,0})
aAdd(aStru,{"L_I_XO","C",1,0})
aAdd(aStru,{"ALIAS","C",3,0})
aAdd(aStru,{"RECNO","N",14,0})
aAdd(aStru,{"FLAG","L",1,0})

dbCreate(cArquivo,aStru)
dbUseArea(.T.,,cArquivo,cArquivo,.F.,.F.)

nNivelMax := LISPmsAtu(cArquivo,If(AF1->AF1_NMAX>0,AF1->AF1_NMAX,1),,aExpand,nIndent)

DEFINE FONT oFont NAME "Arial" SIZE 0, -10 
DEFINE MSDIALOG oDlg TITLE cTitle OF oMainWnd PIXEL FROM nTop,nLeft TO nBottom,nRight
oDlg:lMaximized := .T.

If SetMdiChild()
	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	
	
	nCol := 1
	For nx := 1 to Len(aMenu)
		oBtn := TBtnBmp():NewBar( aMenu[nx][3],aMenu[nx][3],,,aMenu[nx][1], aMenu[nx][2],.T.,oBar,,,aMenu[nx][1])
		oBtn:cTitle := aMenu[nx][4]	
	Next
	
	oBtn := TBtnBmp():NewBar( BMP_EXCEL,BMP_EXCEL,,,"Exportar para o Microsoft Excel", {||PmsPlnExcel(aCampos,,nNivelMax,2,cArquivo)},.T.,oBar,,,"Exportar para o Microsoft Excel") //
	oBtn:cTitle := "Excel"
	
	oBtn := TBtnBmp():NewBar(BMP_IMPRIMIR, BMP_IMPRIMIR,,, TIP_IMPRIMIR,  {|| U_RPMS260(cArquivo,aCampos,cTitle) },.T.,oBar,,, TIP_IMPRIMIR)
	oBtn:cTitle := TOOL_IMPRIMIR
	
	oBtn := TBtnBmp():NewBar( BMP_INTERROGACAO,BMP_INTERROGACAO,, ,"Help" ,{|| HelProg() },.T.,oBar,, ,"Help")
	oBtn:cTitle := "Help"

	If lConfirma<>Nil
		// OK
		oBtn := TBtnBmp():NewBar( BMP_OK,BMP_OK,,,"OK"+" < Ctrl-O >", {|| (lConfirma:=.T.,oDlg:End()) },.T.,oBar,,,"OK"+" < Ctrl-O >")
		oBtn:cTitle := "OK"
	EndIf
	
	// Sair
	//oBtn := TBtnBmp():NewBar( BMP_CANCELA,BMP_CANCELA,,,"Sair"+" < Ctrl-X >", {|| oDlg:End() },.T.,oBar,,,"Sair"+" < Ctrl-X >")
	//linha acima subtituida pela linha abaixo [Mauro Nagata, Actual Trend, 10/08/2012]
	oBtn := TBtnBmp():NewBar( BMP_CANCELA,BMP_CANCELA,,,"Sair"+" < Ctrl-X >", {|| If(ValNivEDT(cArquivo),oDlg:End(),oDlg:Refresh()) },.T.,oBar,,,"Sair"+" < Ctrl-X >")
	oBtn:cTitle := "Sair"
Else
	oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,1245,23,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP
	@00,00 BITMAP oBmp1 RESNAME BMP_FAIXA_SUPERIOR SIZE 1200,50 NOBORDER PIXEL Of oPanel
	oBmp1:align:= CONTROL_ALIGN_TOP

	nCol := 2
	For nx := 1 to Len(aMenu)
		oBtn := TButton():New( 10, nCol,aMenu[nx][4],oPanel,aMenu[nx][2],24,12, , , ,.T.)
		oBtn:cToolTip := aMenu[nx][1]
		nCol += 24
	Next

	oBtn := TButton():New( 10, nCol,"Excel" ,oPanel,{||PmsPlnExcel(aCampos,,nNivelMax,2,cArquivo)},24,12, , , ,.T.)
	oBtn:cToolTip := "Exportar para o Microsoft Excel"
	nCol += 24
	
	oBtn := TButton():New( 10, nCol,TOOL_IMPRIMIR,oPanel,{|| U_RPMS260(cArquivo,aCampos,cTitle) },24,12, , , ,.T.)
	oBtn:cToolTip := TIP_IMPRIMIR
	nCol += 24

	oBtn := TButton():New( 10, nCol,"Help",oPanel,{|| HelProg() },24,12, , , ,.T.)
	oBtn:cToolTip := "Help"
	nCol += 24

	If lConfirma<>Nil
		// OK
		oBtn := TButton():New( 10, nCol,"OK",oPanel,{|| (lConfirma:=.T.,oDlg:End()) },24,12, , , ,.T.)
		oBtn:cToolTip := "OK" + " < Ctrl-O >"
		nCol += 24
	EndIf
	
	// Sair
	oBtn := TButton():New( 10, nCol,"Sair",oPanel,{|| oDlg:End() },24,12, , , ,.T.)
	oBtn:cToolTip := "Sair"+" < Ctrl-X >"
	nCol += 24
EndIf




dbSelectArea(cArquivo)
dbGotop()
nAlias	:= Select()
oBrowse := TcBrowse():New( 14, 1, (nRight/2)-2,(nBottom/2)-40, , , , oDlg, ,,,,{|| PmsExpOrc(cArquivo,aExpand,@nNivelMax),(LISPmsAtu(cArquivo,nNivelMax,,aExpand,nIndent),oBrowse:Refresh()) },,oFont,,,,, .F.,cArquivo, .T.,, .F., , ,.F. )
oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oBrowse:AddColumn( TCColumn():New( "",{ || If((cArquivo)->CTRLNIV=="-",oMenos,If((cArquivo)->CTRLNIV=="+",oMais,If((cArquivo)->CTRLNIV=="*",oAll,If((cArquivo)->CTRLNIV=="!",oCmp,Nil) )))},,,,"RIGHT" , 6, .T., .F.,,,, .T., ))
oBrowse:AddColumn( TCColumn():New( "",{ || PmsOrcBmp((cArquivo)->ALIAS,(cArquivo)->RECNO ) },,,, "LEFT", 15, .T., .F.,,,, .T., ))

For nx := 1 to Len(aCampos)
	If Substr(aCampos[nx][1],1,1)=="$"
		aAuxRet := &(Substr(aCampos[nx][1],2,Len(aCampos[nx][1])-1)+"(2)")
		oBrowse:AddColumn( TCColumn():New( aAuxRet[1], FieldWBlock( aAuxRet[2] , nAlias ),AllTrim(aAuxRet[3]),,, if(aAuxRet[5]=="N","RIGHT","LEFT"), If(aCampos[nx][8]!=Nil,aCampos[nx][8],If(aAuxRet[4]>Len(aAuxRet[1]),(aAuxRet[4]*3),(LEN(aAuxRet[1])*3))), .F., .F.,,,, .F., ) )
	ElseIf Substr(aCampos[nx][1],1,1)=="%"
//%123456789012%C%99%2%12345678901234567890123456789012345%123456789012345678901234567890123456789012345678901234567890
		oBrowse:AddColumn( TCColumn():New( Trim(Substr(aCampos[nx][1],2,12)), FieldWBlock( "FORM"+StrZero(nx,2,0) , nAlias ) ,Substr(aCampos[nx][1],22,35),,, if(Substr(aCampos[nx][1],15,1)=="N","RIGHT","LEFT"), If(Val(Substr(aCampos[nx][1],17,2))>Len(AllTrim(Substr(aCampos[nx][1],2,12))),(Val(Substr(aCampos[nx][1],17,2))*3),(Len(AllTrim(Substr(aCampos[nx][1],2,12)))*3)), .F., .F.,,,, .F., ) )
	Else
		dbSelectArea("SX3")
		dbSetOrder(2)
		If MsSeek(aCampos[nx][1])
			oBrowse:AddColumn( TCColumn():New( Trim(x3titulo()), FieldWBlock( "X"+Substr(X3_CAMPO,2,Len(X3_CAMPO)), nAlias ),AllTrim(X3_PICTURE),,, if(X3_TIPO=="N","RIGHT","LEFT"), If(aCampos[nx][8]!=Nil,aCampos[nx][8],If(X3_TAMANHO>Len(X3_TITULO),(X3_TAMANHO*5),(LEN(X3_TITULO)*5))), .F., .F.,,,, .F., ) )
		ElseIf MsSeek(aCampos[nx][2])
			oBrowse:AddColumn( TCColumn():New( Trim(x3titulo()), FieldWBlock( "XF2"+Substr(X3_CAMPO,4,Len(X3_CAMPO)), nAlias ),AllTrim(X3_PICTURE),,, if(X3_TIPO=="N","RIGHT","LEFT"), If(aCampos[nx][8]!=Nil,aCampos[nx][8],If(X3_TAMANHO>Len(X3_TITULO),(X3_TAMANHO*4),(LEN(X3_TITULO)*4))), .F., .F.,,,, .F., ) )
		EndIf
	EndIf
Next
oBrowse:AddColumn( TCColumn():New( "",{|| " " },,,, "LEFT", 5, .T., .F.,,,, .T., ))
dbSelectArea(cArquivo)
If nFreze	<>	Nil
	oBrowse:nFreeze	:=	nFreze
Endif

oBrowse:Refresh()
ACTIVATE MSDIALOG oDlg

dbSelectArea(cArquivo)
dbCloseArea()

Return lConfirma

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LISPmsAtu ³ Autor ³ Cristiano G. da Cunha ³ Data ³ 15.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Executa a atualizacao do arquivo de trabalho.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LISPmsAtu(cArquivo,nNivelMax,lRecno,aExpand,nIndent)
Local nNivelAtu		:= 1
Local aArea			:= GetArea()
Local aAreaTMP
Local aProcForm		:= {}
Local nX := 0
Local nY := 0

DEFAULT nNivelMax	:= 1
DEFAULT lRecNo		:= .T.
DEFAULT nIndent		:= PMS_SHEET_INDENT

CursorWait()

dbSelectArea(cArquivo)
If LastRec() > 0 
	nNivelMax := 10000
EndIf
aAreaTMP	:= GetArea()
If !InTransact()
	Zap
	Pack
Else
	While !EOF()
		RecLock(cArquivo,.F.)
		DbDelete()
		MsUnLock()
		DbSkip()             
	Enddo			
Endif	

RecLock(cArquivo,.T.)
(cArquivo)->XF2_TAREFA := AF1->AF1_ORCAME
(cArquivo)->XF2_DESCRI := AF1->AF1_DESCRI
If lRecNo
	(cArquivo)->RECNO := AF1->(RecNo())
	(cArquivo)->ALIAS := "AF1"
EndIf
AF5->(dbSetOrder(3))
If AF5->(MsSeek(xFilial()+AF1->AF1_ORCAME+"001"))
	For nx := 1 to Len(aAuxCps)
		If aAuxCps[nx][1]=="AF2_DESCRI"
			If AF5->(FieldPos(aAuxCps[nx][2])) > 0		
				FieldPut(FieldPos("X"+Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),SPACE((VAL(AF5->AF5_NIVEL)-1)*nIndent)+AF5->(FieldGet(FieldPos(aAuxCps[nx][2]))))
			Endif
		ElseIf Substr(aAuxCps[nx][1],1,1)=="%"
			aAdd(aProcForm,nx)
		Else
			If Substr(aAuxCps[nx][1],1,1)=="$"
				FieldPut(FieldPos(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),&(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)+"(3,'AF5',AF5->(RecNo()))"))
			Else
				If Substr(aAuxCps[nx][1],1,1)!="|"
					// se o campo existe na tabela AF5 e se existe o campo na tabela "planilha" a qual vai ser gravado
					If AF5->(FieldPos(aAuxCps[nx][2])) > 0 .and. FieldPos("XF2"+Substr(aAuxCps[nX][2],4,Len(aAuxCps[nX][2])-1))>0
						FieldPut(FieldPos("XF2"+Substr(aAuxCps[nX][2],4,Len(aAuxCps[nX][2])-1)),AF5->(FieldGet(FieldPos(aAuxCps[nX][2]))))
					EndIf
				Endif
			Endif
		EndIf
	Next

	If !PMSPlnCalc(@aProcForm, @aAuxCps, cArquivo)
		Return
	EndIf
EndIf
If nNivelMax <> 2000
	(cArquivo)->CTRLNIV	:= "*"
Else
	(cArquivo)->CTRLNIV	:= "!"
EndIf
MsUnlock()
If aExpand != Nil
	aAdd(aExpand,{(cArquivo)->ALIAS+(cArquivo)->XF2_TAREFA,.T.})	
EndIf


MsUnlock()

dbSelectArea("AF5")
dbSetOrder(3)
MsSeek(xFilial()+AF1->AF1_ORCAME+"001")
While !Eof() .And. AF5->AF5_FILIAL+AF5->AF5_ORCAME+AF5->AF5_NIVEL == ;
					xFilial("AF5")+AF1->AF1_ORCAME+"001"
	PmsAddPOrc(AF5->AF5_ORCAME+AF5->AF5_EDT,cArquivo,@nNivelAtu,nNivelMax,lRecNo,aExpand,nIndent)
	dbSelectArea("AF5")
	dbSkip()
End

CursorArrow()

RestArea(aAreaTmp)
RestArea(aArea)
Return nNivelAtu
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LIS101CMP³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que importa o cadastro de composicoes para uma deter- ³±±
±±³          ³ minada EDT do Orcamento.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA101                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LIS101CMP(nRecAF1,oTree,cArquivo)
Local oDlg
Local oDescri
Local n101Quant  := 0
Local cUM        := ''
Local cDescri    := ''
Local c101Compos := SPACE(Len(AE1->AE1_COMPOS))
Local oBold
Local oUM
Local oBmp
Local lOk        := .F.
Local cAlias     := ""
Local nRecAlias  := 0
Local cTarefa    := Space(TamSx3("AF2_TAREFA")[1])
Local oQuant     := Nil

If oTree != Nil

	// verifica os dados da EDT/Tarefa posicionada no tree
	cAlias:= SubStr(oTree:GetCargo(),1,3)
	nRecAlias:= Val(SubStr(oTree:GetCargo(),4,12))
Else
	cAlias := (cArquivo)->ALIAS
	nRecAlias := (cArquivo)->RECNO
EndIf


If cAlias == "AF5"
	dbSelectArea(cAlias)
	dbGoto(nRecAlias)

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 114,150 TO 450,600 TITLE cCadastro Of oMainWnd PIXEL

		@   0,  0 BITMAP oBmp RESNAME BMP_PROJETOAP oF oDlg SIZE 70,255 NOBORDER WHEN .F. PIXEL
		@  17, 43 TO 18 ,245 LABEL '' OF oDlg PIXEL
		@   6, 50 SAY 'Importar Composicao' Of oDlg PIXEL SIZE 69, 08 FONT oBold //
			
		@  30,  55 SAY 'Cod. Composicao' Of oDlg PIXEL SIZE 58, 08 //'Cod. Composicao'
		@  29, 105 MSGET c101Compos Picture PesqPict('AE1','AE1_COMPOS') F3 'AE1';
		           Valid Vazio(c101Compos) .Or. RefDlg(@c101Compos,@cDescri,@oDescri,@cUM,@oUM) .And.;
		           (oQuant:SetFocus(), .T.);
		           OF oDlg PIXEL SIZE 92, 08 HASBUTTON
			
		@  50,  55 SAY 'Descricao' Of oDlg PIXEL SIZE 43, 08 //
		@  49,105 GET oDescri VAR cDescri MEMO SIZE 106,33 PIXEL OF oDlg //READONLY
			
		@  95,  55 SAY 'Unid. de Medida' Of oDlg PIXEL SIZE 80, 08 //
		@  94, 105 MSGET oUM VAR cUM Picture PesqPict('AE1','AE1_UM') OF oDlg When .F. PIXEL SIZE 25, 08
			
		@  115,  55 SAY 'Quantidade' Of oDlg PIXEL SIZE 45, 08 //
		@  114, 105 MSGET oQuant Var n101Quant Picture PesqPict('AF2','AF2_QUANT') Valid Positivo(n101Quant) OF oDlg PIXEL SIZE 60, 08 HASBUTTON
		   
		If GetMv("MV_PMSTCOD") == "1"
	
			// codificacao manual
			@ 135,  55 Say 'Importar Composicao' Of oDlg Pixel Size 45, 08
			@ 134, 105 MSGET cTarefa Picture PesqPict("AF2", "AF2_TAREFA") Valid !ExistOrcTrf((cAlias)->AF5_ORCAMENTO, cTarefa) Of oDlg Pixel Size 60, 08
    
			@ 155, 131 BUTTON 'Confirma' SIZE 35 ,11  FONT oDlg:oFont ACTION  (lOk:=.T.,oDlg:End()) OF oDlg PIXEL When !Empty(c101Compos) .And. !Empty(n101Quant) .And. !Empty(cTarefa)//
		Else
			@ 155, 131 BUTTON 'Confirma' SIZE 35 ,11  FONT oDlg:oFont ACTION  (lOk:=.T.,oDlg:End()) OF oDlg PIXEL When !Empty(c101Compos) .And. !Empty(n101Quant) //"Confirma"
		EndIf
		
		@ 155, 171 BUTTON 'Cancela' SIZE 35 ,11  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  //

	ACTIVATE MSDIALOG oDlg CENTERED

	If lOk 
		Begin Transaction

			If GetMv("MV_PMSTCOD") == "2"
				// codificacao automatica
				cTarefa := PmsNumAF5(AF5->AF5_ORCAME,AF5->AF5_NIVEL,AF5->AF5_EDT)
			EndIf

			// verifica a existencia do ponto de entrada PMA101CP
			If ExistBlock("PMA101CP")
				ExecBlock("PMA101CP",.F.,.F.,{ 'AF5',AF5->(RecNo()),AE1->(RecNo()),n101Quant })
			EndIf

			If GetMv("MV_PMSCUST") == "2" //1-custo total  2-custo unitario
				nRecAF2 := PMS101IMPOR(nRecAF1,AF5->AF5_NIVEL,c101Compos, 1,cTarefa,AF5->AF5_EDT,,,,, n101Quant,,cDescri)
			Else
				nRecAF2 := PMS101IMPOR(nRecAF1,AF5->AF5_NIVEL,c101Compos,n101Quant,cTarefa,AF5->AF5_EDT,,,,, n101Quant,,cDescri)
			EndIf
		End Transaction
	EndIf
EndIf

Return lOk

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS101IMPOR³ Autor ³ Edson Maricate       ³ Data ³ 09-02-2001              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que importa/associa a composicao no Orcamento.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cItemAF3 : numero do item produto da tabela AF3                            ³±±
±±³          ³cItemAF4 : numero do item da despesa da tabela AF4                         ³±±
±±³          ³lMantProd : mantem os produtos da tarefa associada(utilizado se associacao)³±±
±±³          ³cItemRec : numero do item recurso da tabela AF3                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMS101CMP                                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS101IMPOR(nRecAF1,cNivelAtu,cCompos,nQuant,cTarefa,cEDTPAI,lCriaAF2,cItemAF3,cItemAF4,nRecAF2,nGravaQuant, cOrcame,cDescri,lSub,lMantProd,cItemRec)

Local aArea     := GetArea()
Local aAreaAE1  := AE1->(GetArea())
Local aAreaAE2  := AE2->(GetArea())
Local aAreaAF2  := AF2->(GetArea())
Local aAreaAE3  := AE3->(GetArea())
Local aAreaAE4  := AE4->(GetArea())
Local aAreaSB1  := SB1->(GetArea())
Local nRetAF2   := 0
Local nAuxAF2   := 0
Local cNivelTrf := cNivelAtu
Local bCampo    := {|n| FieldName(n) }
Local nx
Local lPadrao   := .T.
Local cAux      := ""

DEFAULT lCriaAF2 := .T.
DEFAULT cItemAF3 := "00"
DEFAULT cItemAF4 := "00"
DEFAULT cItemRec := "00"
DEFAULT cOrcame  := AF1->AF1_ORCAME
DEFAULT lSub 	  := .F.
DEFAULT lMantProd := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

dbSelectArea("AE1")
dbSetOrder(1)
If dbSeek(xFilial()+cCompos)
	If lCriaAF2
		If nRecAF2 == Nil              
			RegToMemory("AF2",.T.)		
			cNivelTrf := StrZero(Val(cNivelTrf) + 1, TamSX3("AF2_NIVEL")[1])
			RecLock("AF2",.T.)
			For nx := 1 TO FCount()
				FieldPut(nx,M->&(EVAL(bCampo,nx)))
			Next nx
			AF2->AF2_FILIAL := xFilial("AF2")
			AF2->AF2_ORCAME := AF1->AF1_ORCAME
			AF2->AF2_NIVEL  := cNivelTrf

			If GetMv("MV_PMSTCOD") == "1"

				// codificacao manual
				AF2->AF2_TAREFA := cTarefa			
			Else
				AF2->AF2_TAREFA := PmsNumAF2(AF1->AF1_ORCAME, cNivelAtu, cEDTPai)
			EndIf
			
			AF2->AF2_DESCRI:= IIf(cDescri==Nil .Or.Empty(cDescri),AE1->AE1_DESCRI,cDescri)
			AF2->AF2_UM     := AE1->AE1_UM
			AF2->AF2_QUANT  := nGravaQuant
			AF2->AF2_COMPOS := cCompos
			AF2->AF2_TPMEDI := "4"
			AF2->AF2_EDTPAI := cEDTPai
			AF2->AF2_GRPCOM := AE1->AE1_GRPCOM
			AF2->AF2_PRIORI := AE1->AE1_PRIORI
	
			If ExistTemplate("CCT101_0")
				ExecTemplate("CCT101_0",.F.,.F.,{cCompos,lSub})
			EndIf
			MsUnlock()
		Else

			AF2->(dbGoto(nRecAF2))
			RecLock("AF2",.F.)
			AF2->AF2_DESCRI := IIf(cDescri==Nil .Or.Empty(cDescri),AE1->AE1_DESCRI,cDescri)
			AF2->AF2_UM     := AE1->AE1_UM
			AF2->AF2_QUANT  := nGravaQuant
			AF2->AF2_COMPOS := cCompos
			AF2->AF2_GRPCOM := AE1->AE1_GRPCOM
			AF2->AF2_PRIORI := AE1->AE1_PRIORI
	
			If ExistTemplate("CCT101_0")
				ExecTemplate("CCT101_0",.F.,.F.,{cCompos,lSub})
			EndIf

			MsUnlock()
			
			AF3->(DbSetOrder(1))
			AF3->(DbSeek(xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA))
			While AF3->(!Eof()) .And. xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA == ;
								AF3->(AF3_FILIAL+AF3_ORCAME+AF3_TAREFA)
				If !lMantProd // mantem produto/recurso/despesa?
					RecLock("AF3",.F.,.T.)
					AF3->(DbDelete())
					AF3->(MsUnlock())
				Else
					//guarda o ultimo item do produto/recurso da tarefa
					If !Empty(AF3->AF3_RECURS)
						cItemRec := AF3->AF3_ITEM
					Else
						cItemAF3 := AF3->AF3_ITEM
					EndIf
				EndIf
				AF3->(DbSkip())
			EndDo
	
			AF4->(DbSetOrder(1))
			AF4->(DbSeek(xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA))
			While AF4->(!Eof()) .And. xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA == ;
								AF4->(AF4_FILIAL+AF4_ORCAME+AF4_TAREFA)
				If !lMantProd // mantem produto/recurso/despesa?
					RecLock("AF4",.F.,.T.)
					AF4->(DbDelete())
					AF4->(MsUnlock())
				Else
					//guarda o ultimo item da despesa da tarefa
					cItemAF4 := AF4->AF4_ITEM
				EndIf
				AF4->(DbSkip())
			EndDo
		EndIf

		RegToMemory("AF2",.F.)
		nRetAF2	:= AF2->(RecNo())
		
	EndIf

	FkCommit()
	
	dbSelectArea("AE2")
	dbSetOrder(1)
	dbSeek(xFilial()+cCompos)
	While !Eof() .And. xFilial()+cCompos == AE2->AE2_FILIAL+AE2->AE2_COMPOS
		//Ponto de entrada utilizado para gravar no Recurso da Tarefa valores do Orcamento do Boletim
		lPadrao := .T.
		If ExistBlock("PMA101E2")
			If AF3->(FieldPos("AF3_RECURS"))>0 .And.;
			   AE2->(FieldPos("AE2_RECURS"))>0 .And.;
			   !Empty(AE2->AE2_RECURS)
				cAux := Soma1(cItemRec)
			Else
				cAux := Soma1(cItemAF3)
			EndIf

			If ExecBlock("PMA101E2",.F.,.F.,{cAux})==.T.
				lPadrao := .F.
				If AF3->(FieldPos("AF3_RECURS"))>0 .And.;
				   AE2->(FieldPos("AE2_RECURS"))>0 .And.;
				   !Empty(AE2->AE2_RECURS)
					cItemRec := cAux
				Else
					cItemAF3 := cAux
				EndIf
			EndIf
		EndIf

		If lPadrao
			RegToMemory("AF3",.T.)		
			RecLock("AF3",.T.)
			For nx := 1 TO FCount()
				FieldPut(nx,M->&(EVAL(bCampo,nx)))
			Next nx
			AF3->AF3_FILIAL := xFilial("AF3")
			AF3->AF3_ORCAME := IF(lCriaAF2,AF2->AF2_ORCAME,cOrcame)
			AF3->AF3_TAREFA := IF(lCriaAF2,AF2->AF2_TAREFA,cTarefa)
			AF3->AF3_PRODUT := AE2->AE2_PRODUT
			AF3->AF3_QUANT  := PmsAF3Quant(AF3->AF3_ORCAME,AF3->AF3_TAREFA,AF3->AF3_PRODUT,nQuant,AE2->AE2_QUANT,,.T.)
			If !ExistTemplate("CCTAF3QUANT") .And. GetMV("MV_PMSCUST")=="2"
				AF3->AF3_QUANT := nQuant * AE2->AE2_QUANT
			EndIf
			SB1->(dbSeek(xFilial()+AE2->AE2_PRODUT))
			AF3->AF3_MOEDA  := Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD"))
			AF3->AF3_CUSTD  := RetFldProd(SB1->B1_COD,"B1_CUSTD")
			AF3->AF3_ACUMUL := "3"
			AF3->AF3_COMPOS := cCompos
			AF3->AF3_QTSEGU := AE2->AE2_QTSEGU
	
			If AF3->(FieldPos("AF3_RECURS")) > 0  .And. AE2->(FieldPos("AE2_RECURS"))>0 .And. !Empty(AE2->AE2_RECURS)
				If Empty(AE2->AE2_PRODUT)
					AF3->AF3_MOEDA	:= 1
				Endif
				AF3->AF3_RECURS	:= AE2->AE2_RECURS
				AE8->(dbSetOrder(1))
				AE8->(dbSeek(xFilial()+AE2->AE2_RECURS))
				If AE8->AE8_VALOR >0 .AND. ( AE8->AE8_PRODUT == AE2->AE2_PRODUT .OR. Empty(AE2->AE2_PRODUT) )
					AF3->AF3_CUSTD := AE8->AE8_VALOR
				EndIf
				cItemRec      := Soma1(cItemRec)
				AF3->AF3_ITEM := cItemRec
			Else
				cItemAF3      := Soma1(cItemAF3)
				AF3->AF3_ITEM := cItemAF3
			EndIf
			// Rever gravacao da 2a UM!!!
	
			If ExistTemplate("CCT101_1")
				ExecTemplate("CCT101_1",.F.,.F.,{cCompos,lSub})
			EndIf
			
			MsUnlock()
		EndIf
		
		dbSelectArea("AE2")
		dbSkip()
	End

	dbSelectArea("AE3")
	dbSetOrder(1)
	dbSeek(xFilial()+cCompos)
	While !Eof() .And. xFilial()+cCompos == AE3->AE3_FILIAL+AE3->AE3_COMPOS

		//Ponto de entrada utilizado para gravar na Despesa da Tarefa valores do Orcamento do Boletim
		lPadrao := .T.
		If ExistBlock("PMA101E3")
			cAux := Soma1(cItemAF4)
			If ExecBlock("PMA101E3",.F.,.F.,{cAux})==.T.
				lPadrao  := .F.
				cItemAF4 := cAux
			EndIf
		EndIf

		If lPadrao
			cItemAF4 := Soma1(cItemAF4)
			RegToMemory("AF4",.T.)		
			RecLock("AF4",.T.)
			For nx := 1 TO FCount()
				FieldPut(nx,M->&(EVAL(bCampo,nx)))
			Next nx
			AF4->AF4_FILIAL := xFilial("AF4")
			AF4->AF4_ORCAME := AF2->AF2_ORCAME
			AF4->AF4_ITEM   := cItemAF4
			AF4->AF4_TAREFA := AF2->AF2_TAREFA
			AF4->AF4_DESCRI := AE3->AE3_DESCRI
			AF4->AF4_MOEDA  := AE3->AE3_MOEDA
			AF4->AF4_VALOR  := PmsAF4Valor(nQuant,AE3->AE3_VALOR,.T.)
			AF4->AF4_TIPOD  := AE3->AE3_TIPOD
			AF4->AF4_COMPOS := cCompos
	
			If ExistTemplate("CCT101_2")
				ExecTemplate("CCT101_2",.F.,.F.,{cCompos})
			EndIf
	
			MsUnlock()
		EndIf

    	dbSelectArea("AE3")
		dbSkip()
	End

 	// grava o custo da tarefa
	If ExistTemplate("PMAAF2CTrf")
		ExecTemplate("PMAAF2CTrf",.F.,.F.,{AF2->AF2_ORCAME,AF2->AF2_TAREFA})
	Else
		aRetCus	:= PmsAF2CusTrf(0,AF2->AF2_ORCAME, AF2->AF2_TAREFA)
		RecLock("AF2",.F.)
		Replace AF2->AF2_CUSTO  With aRetCus[1]
		Replace AF2->AF2_CUSTO2 With aRetCus[2]
		Replace AF2->AF2_CUSTO3 With aRetCus[3]
		Replace AF2->AF2_CUSTO4 With aRetCus[4]
		Replace AF2->AF2_CUSTO5 With aRetCus[5]
		AF2_VALBDI:= aRetCus[1]*IIf(AF2->AF2_BDI <> 0,AF2->AF2_BDI,PmsGetBDIPad('AF2',AF2->AF2_ORCAME,,AF2->AF2_EDTPAI))/100
		AF2_TOTAL := aRetCus[1]+AF2->AF2_VALBDI
		MsUnLock()										

	 EndIf
    
	PmsAvalAF2("AF2")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a existencia do ponto de entrada PMA101IMP.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("PMA101IMP")
		ExecBlock("PMA101IMP",.F.,.F.,{cCompos,nQuant})
	EndIf
	
	If ExistTemplate("PMA101IMP")
		ExecTemplate("PMA101IMP",.F.,.F.,{cCompos})
	EndIf
	

	dbSelectArea("AE4")
	dbSetOrder(1)
	dbSeek(xFilial()+cCompos)
	While !Eof() .And. xFilial()+cCompos == AE4->AE4_FILIAL+AE4->AE4_COMPOS
		If lCriaAF2
			nAuxAF2 := PMS101IMPOR(nRecAF1,cNivelTrf,AE4->AE4_SUBCOM,AE4->AE4_QUANT*nQuant,AF2->AF2_TAREFA,cEDTPai,.F.,@cItemAF3,@cItemAF4,AF2->(Recno()),nGravaQuant,cOrcame,cDescri,.T.,,@cItemRec)
		Else
			nAuxAF2 := PMS101IMPOR(nRecAF1,cNivelTrf,AE4->AE4_SUBCOM,AE4->AE4_QUANT*nQuant,cTarefa,cEDTPai,.F.,@cItemAF3,@cItemAF4,AF2->(Recno()),nGravaQuant,cOrcame,cDescri,.T.,,@cItemRec)
		EndIf
		dbSelectArea("AE4")
		dbSkip()
	End

EndIf

RestArea(aAreaAF2)
RestArea(aAreaAE1)
RestArea(aAreaAE2)
RestArea(aAreaAE3)
RestArea(aAreaAE4)
RestArea(aAreaSB1)
RestArea(aArea)

Return nRetAF2
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAF2CusTrf³Autor ³Fabio Rogerio Pereira  ³ Data ³ 08-05-2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de calculo do custo da tarefa 							 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMSAF2CusTrf(nGet,cOrcame,cTarefa)
Local aArea    := GetArea()
Local aAreaAF1 := AF1->(GetArea())
Local nX       := 0
Local aCusto   := {0,0,0,0,0}
Local nPCod    := 0
Local nPItem   := 0
Local nPQuant  := 0
Local nPCustd  := 0
Local nPValor  := 0
Local nPMoedaP := 0
Local nPMoedaD := 0
Local aColsPrd := {}
Local aColsDes := {}      
Local aColsRec := {}
Local nQuantAF3:= 0
Local nValorAF4:= 0
Local nFaz	   := 0
Local aTX2M	   := {0,0,0,0,0}
Local aDecCst  := {0,0,0,0,0}
Local nCusto   := 0 

DEFAULT nGet    := 0
DEFAULT cOrcame := AF2->AF2_ORCAME
DEFAULT cTarefa := AF2->AF2_TAREFA

 
// formata para o tamanho do campo de acordo com o sx3.
cOrcame := padr( cOrcame ,TamSX3("AF2_ORCAME")[1] )
cTarefa := padr( cTarefa ,TamSX3("AF2_TAREFA")[1] )

aDecCst[1]:=TamSX3("AF2_CUSTO")[2]
aDecCst[2]:=TamSX3("AF2_CUSTO2")[2]
aDecCst[3]:=TamSX3("AF2_CUSTO3")[2]
aDecCst[4]:=TamSX3("AF2_CUSTO4")[2]
aDecCst[5]:=TamSX3("AF2_CUSTO5")[2]

//
// define a forma de arredondar ou truncar os valores
//
dbSelectArea("AF1")
DbSetOrder(1)
MsSeek(xFilial()+cOrcame)

cTrunca := iIf( Empty(AF1->AF1_TRUNCA) ,"1" ,AF1->AF1_TRUNCA)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se esta sendo chamado atraves de getdados ou nao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Type("aCols") == "A") .And. (Type("aHeader") == "A") .And. (nGet > 0)

	If (nGet == 1) //getdados de produtos
		nPCod    := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPQuant  := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd  := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPMoedaP := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_MOEDA"})	
		nPMoedaD := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_MOEDA"})
		nPItem   := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_ITEM"})
		nPValor  := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_VALOR"})
		nPCod2   := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPMoedaP2:= aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_MOEDA"})
		nPQuant2 := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd2 := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPRec2	 := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_RECURS"})	
        aColsPrd := aClone(aCols)
        aColsDes := aClone(aColsSV[2])
        aColsRec := aClone(aColsSV[4])
         
	ElseIf (nGet == 2) //Getdados de despesas
		nPValor   := aScan(aHeader,{|x| AllTrim(x[2]) == "AF4_VALOR"})
		nPMoedaD  := aScan(aHeader,{|x| AllTrim(x[2]) == "AF4_MOEDA"})
		nPItem    := aScan(aHeader,{|x| AllTrim(x[2]) == "AF4_ITEM"})
		nPCod     := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPMoedaP  := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_MOEDA"})
		nPQuant   := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd   := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPCod2    := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPMoedaP2 := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_MOEDA"})
		nPQuant2  := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd2  := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPRec2	  := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_RECURS"})		
        aColsPrd  := aClone(aColsSV[1])
        aColsDes  := aClone(aCols)
        aColsRec := aClone(aColsSV[4])        
	ElseIf (nGet == 4) //Getdados de alocacao de recursos
		nPCod     := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPQuant   := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd   := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPMoedaP  := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_MOEDA"})	
		nPMoedaD  := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_MOEDA"})
		nPItem    := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_ITEM"})
		nPValor   := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_VALOR"})
		nPCod2    := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPMoedaP2 := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_MOEDA"})
		nPQuant2  := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd2  := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPRec2	  := aScan(aHeader,{|x| AllTrim(x[2]) == "AF3_RECURS"})
        aColsPrd:= aClone(aColsSV[1])
        aColsDes:= aClone(aColsSV[2])
        aColsRec:= aClone(aCols)
        
	Else
		nPCod    := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPQuant  := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd  := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPMoedaP := aScan(aHeaderSV[1],{|x| AllTrim(x[2]) == "AF3_MOEDA"})	
		nPMoedaD := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_MOEDA"})
		nPItem   := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_ITEM"})
		nPValor  := aScan(aHeaderSV[2],{|x| AllTrim(x[2]) == "AF4_VALOR"})
		nPCod2   := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_PRODUT"})
		nPMoedaP2:= aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_MOEDA"})
		nPQuant2 := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_QUANT"})
		nPCustd2 := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_CUSTD"})	
		nPRec2	 := aScan(aHeaderSV[4],{|x| AllTrim(x[2]) == "AF3_RECURS"})
		aColsPrd := aClone(aColsSV[1])
		aColsDes := aClone(aColsSV[2])
		aColsRec := aClone(aColsSV[4])

	EndIf	

	aTX2M[1]:=1
	aTX2M[2]:=M->AF2_TXMO2
	aTX2M[3]:=M->AF2_TXMO3
	aTX2M[4]:=M->AF2_TXMO4
	aTX2M[5]:=M->AF2_TXMO5

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o custo dos produtos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nPQuant > 0) .And. (nPCustd > 0)
		For nX:= 1 To Len(aColsPrd)
			If !aColsPrd[nX][Len(aColsPrd[nX])]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a quantidade do produto.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nQuantAF3	:= PmsAF3Quant(cOrcame,cTarefa,aColsPrd[nX,nPCod],M->AF2_QUANT,aColsPrd[nX,nPQuant],M->AF2_HDURAC,,"")
				nCusto      := nQuantAF3*aColsPrd[nX,nPCustd]
				For nFaz :=1 to 5
					If aTX2M[nFaz] != 0
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, aColsPrd[nX,nPMoedaP], nFaz, If(!Empty(AF1->AF1_DTCONV),AF1->AF1_DTCONV,Nil), aDecCst[nFaz], aTX2M[aColsPrd[nX,nPMoedaP]], aTX2M[nFaz]), aDecCst[nFaz], M->AF2_QUANT)
					Else
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, aColsPrd[nX,nPMoedaP], nFaz, If(!Empty(AF1->AF1_DTCONV),AF1->AF1_DTCONV,Nil), aDecCst[nFaz]), aDecCst[nFaz], M->AF2_QUANT)
					EndIf
				Next nFaz
			EndIf
		Next nX
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o custo das despesas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nPValor > 0)
		For nX:= 1 To Len(aColsDes)
			If !aColsDes[nX][Len(aColsDes[nX])]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o valor da despesa.     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nValorAF4 := PmsAF4Valor(M->AF2_QUANT,aColsDes[nX,nPValor])
				nCusto    := nValorAF4
				For nFaz :=1 to 5
					If aTX2M[nFaz] != 0
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, aColsDes[nX,nPMoedaD], nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz], aTX2M[aColsDes[nX,nPMoedaD]], aTX2M[nFaz]), aDecCst[nFaz], M->AF2_QUANT)
					Else
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, aColsDes[nX,nPMoedaD], nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz]), aDecCst[nFaz], M->AF2_QUANT)
					Endif
				Next nFaz
   			EndIf
		Next nX
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o custo do recurso   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nPQuant2 > 0) .And. (nPCustd2 > 0)
		For nX:= 1 To Len(aColsRec)
			If !aColsRec[nX][Len(aColsRec[nX])]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a quantidade do produto.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nQuantAF3	:= PmsAF3Quant(cOrcame,cTarefa,aColsRec[nX,nPCod2],M->AF2_QUANT,aColsRec[nX,nPQuant2],M->AF2_HDURAC,,aColsRec[nX,nPRec2])
				nCusto      := nQuantAF3*aColsRec[nX,nPCustd2]
				For nFaz := 1 to 5
					If aTX2M[nFaz] != 0
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, aColsRec[nX,nPMoedaP2], nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz], aTX2M[aColsRec[nX,nPMoedaP2]], aTX2M[nFaz]), aDecCst[nFaz], M->AF2_QUANT)
					Else
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, aColsRec[nX,nPMoedaP2], nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz]), aDecCst[nFaz], M->AF2_QUANT)
					EndIf
				Next nFaz
   			EndIf
		Next nX
	EndIf
Else
	If !Empty(cOrcame) .And. !Empty(cTarefa)
	
		aTX2M[1] := 1
		aTX2M[2] := AF2->AF2_TXMO2
		aTX2M[3] := AF2->AF2_TXMO3
		aTX2M[4] := AF2->AF2_TXMO4
		aTX2M[5] := AF2->AF2_TXMO5

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica os custos dos produtos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AF3")
		dbSetOrder(1)
		If MsSeek(xFilial("AF3") + cOrcame + cTarefa)
			While !Eof() .And. (xFilial("AF3") + cOrcame + cTarefa == AF3->AF3_FILIAL + AF3->AF3_ORCAME + AF3->AF3_TAREFA)
			
				If !Empty( AF3->AF3_PRODUT )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica a quantidade do produto.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nQuantAF3 := PmsAF3Quant(AF3->AF3_ORCAME,AF3->AF3_TAREFA,AF3->AF3_PRODUT,AF2->AF2_QUANT,AF3->AF3_QUANT,AF2->AF2_HDURAC)
					nCusto    := AF3->AF3_CUSTD * nQuantAF3
					
					For nFaz :=1 to Iif(len(aTX2M) < 5, len(aTX2M), 5)
						If nFaz <= len(aCusto) .and. nFaz > 0 .and. nFaz <= len(aTX2M) .and. nFaz <= len(aDecCst)
							n_moeda := Iif(AF3->AF3_MOEDA=0, 1, AF3->AF3_MOEDA)
							If aTX2M[nFaz] != 0  
								aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, n_moeda, nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz], aTX2M[n_moeda], aTX2M[nFaz]), aDecCst[nFaz], AF2->AF2_QUANT)
							Else
								aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, AF3->AF3_MOEDA, nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz]), aDecCst[nFaz], AF2->AF2_QUANT)
							EndIf
						EndIf
					Next nFaz
				EndIf
				AF3->(dbSkip())
			EndDo
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica os custos das despesas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AF4")
		dbSetOrder(1)
		If MsSeek(xFilial("AF4") + cOrcame + cTarefa)
			While !Eof() .And. (xFilial("AF4") + cOrcame + cTarefa == AF4->AF4_FILIAL + AF4->AF4_ORCAME + AF4->AF4_TAREFA)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o valor da despesa.     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nValorAF4 := PmsAF4Valor(AF2->AF2_QUANT,AF4->AF4_VALOR)
				nCusto    := nValorAF4
				For nFaz := 1 to 5
					If aTX2M[nFaz] != 0
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, AF4->AF4_MOEDA, nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz], aTX2M[AF4->AF4_MOEDA], aTX2M[nFaz]), aDecCst[nFaz], AF2->AF2_QUANT)
					Else
						aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, AF4->AF4_MOEDA, nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz]), aDecCst[nFaz], AF2->AF2_QUANT)
					EndIf
				Next nFaz
				AF4->(dbSkip())
			EndDo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica os custos dos RECURSOS.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AF3")
		dbSetOrder(1)
		If MsSeek(xFilial("AF3") + cOrcame + cTarefa)
			While !Eof() .And. (xFilial("AF3") + cOrcame + cTarefa == AF3->AF3_FILIAL + AF3->AF3_ORCAME + AF3->AF3_TAREFA)
			
				If Empty( AF3->AF3_PRODUT )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica a quantidade do RECURSO.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nQuantAF3 := PmsAF3Quant(AF3->AF3_ORCAME,AF3->AF3_TAREFA,AF3->AF3_PRODUT,AF2->AF2_QUANT,AF3->AF3_QUANT,AF2->AF2_HDURAC,,AF3->AF3_RECURS)
					nCusto    := AF3->AF3_CUSTD * nQuantAF3
					For nFaz := 1 to 5
						If aTX2M[nFaz] != 0
							aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, AF3->AF3_MOEDA, nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz], aTX2M[AF3->AF3_MOEDA], aTX2M[nFaz]), aDecCst[nFaz], AF2->AF2_QUANT)
						Else
							aCusto[nFaz] += PmsTrunca(cTrunca, xMoeda(nCusto, AF3->AF3_MOEDA, nFaz, If(!Empty(AF1->AF1_DTCONV), AF1->AF1_DTCONV, Nil), aDecCst[nFaz]), aDecCst[nFaz], AF2->AF2_QUANT)
						EndIf
					Next nFaz
				EndIf
				AF3->(dbSkip())
			EndDo
		EndIf
	EndIf
EndIf

RestArea(aAreaAF1)
RestArea(aArea)
Return(aCusto)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSTRUNCA³ Autor ³ Daniel Sobreira        ³ Data ³ 09-09-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de Truncamento ou Arredondamento dos Valores					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PMSA100, PMSA200                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMSTrunca(cTrunca, nValor, nCasasDec,nQuantTrf)
Local nValFin := 0
Local cPmsCust := SuperGetMv("MV_PMSCUST",.F.,"1") //Indica se utiliza o custo pela quantidade unitaria ou total

	If nQuantTrf <> Nil .And. cPmsCust <> "1"
		If cTrunca == "1"
			 // truncar
			nValFin := NoRound(nValor, nCasasDec)
		ElseIf cTrunca == "3"
			nValFin := NoRound(NoRound(nValor/nQuantTrf, nCasasDec)*nQuantTrf, nCasasDec)
		ElseIf cTrunca == "4"
			nValFin := Round(Round(nValor/nQuantTrf,nCasasDec)*nQuantTrf, nCasasDec)
		Else
			// arredondar
			nValFin := Round(nValor, nCasasDec)		
		EndIf
	Else            
		//
		// Truncar por Item ou Truncar por Tarefa
		If cTrunca $ "13"
			 // truncar
			nValFin := NoRound(nValor, nCasasDec)
		Else
			// arredondar
			nValFin := Round(nValor, nCasasDec)		
		EndIf
	EndIf
	
Return nValFin



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsAF3Quant³ Autor ³ Fabio Rogerio Pereira  ³ Data ³26-07-2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que calcula a quantidade do produto do orcamento		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PmsAF3Quant(cOrcame,cTarefa,cProduto,nQuantTsk,nQuantPrd,nDuracTsk,lCompos,cRecurso,lProduc)
Local nRet    := 0
Local cPmsCust:= GetMV("MV_PMSCUST") //Indica se utiliza o custo pela quantidade unitaria ou total

DEFAULT cOrcame  := AF1->AF1_ORCAME
DEFAULT cTarefa  := AF2->AF2_TAREFA
DEFAULT cProduto := AF3->AF3_PRODUT
DEFAULT cRecurso := If(AF3->(FieldPos("AF3_RECURS")>0),AF3->AF3_RECURS,"")
DEFAULT nQuantTsk:= 1
DEFAULT nQuantPrd:= 1
DEFAULT nDuracTsk:= AF2->AF2_HDURAC
DEFAULT lCompos  := .F.
DEFAULT lProduc  := .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica qual o tipo do calculo sera utilizado 1= Padrao 2=Template³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistTemplate("CCTAF3QUANT") .And. (GetMV("MV_PMSCCT") == "2")
	nRet:= ExecTemplate("CCTAF3QUANT",.F.,.F.,{cOrcame,cTarefa,cProduto,nQuantTsk,nQuantPrd,nDuracTsk,lCompos,cRecurso,lProduc})
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for importacao de composicao deve calcular o valor       ³
	//³ proporcional da quantidade do produto em relacao da tarefa  ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If lCompos
		nRet:= nQuantTsk * nQuantPrd
	Else
		nRet:= IIf(cPmsCust == "1",nQuantPrd,nQuantTsk * nQuantPrd)
	EndIf
EndIf

Return(nRet)
                                       

Static Function ValNivEDT()

Local lRet := .T.
Local nRecno := (cArqAux)->(Recno())

(cArqAux)->(DbGoTop())
Do While !((cArqAux)->(Eof()))
   If "ERR" $ (cArqAux)->(XF2_TAREFA)
      lRet := .F.          
      MsgBox("Estrutura Inválida ["+AllTrim((cArqAux)->(XF2_TAREFA))+"]. Antes de finalizar o orçamento, corrija a estrutura",AllTrim((cArqAux)->(XF2_TAREFA)),"ALERT")
      Exit
   EndIf        
   (cArqAux)->(DbSkip())
EndDo                           
(cArqAux)->(DbGoto(nRecno))

Return lRet