#include "dbtree.ch"
#include "TCBROWSE.CH"
#include "protheus.ch"

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
#define TIP_PESQUISAR       "Pesquisar"
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CPMS002  ³ Autor ³ Alexandre Sousa        ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de visualizacao de orcamentos revisados e alterados ³±±
±±³          ³ gravados pelo controle de versoes.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico LISONDA.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CPMS003(cAlias,nReg,nOpcx)

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

DbSelectArea('ZF1')
DbGoto(nReg)

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


If lContinua

	If lContinua
		If l100Visual
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

		AAdd(aMenu, {"Atalhos",  {|| SetAtalho(aMenuAt,aMenu,.T.)}, "ATALHO", "Atalhos"})  //"Atalhos"##"Atalhos"
	
		// le os atalhos desde o profile
		CarregaAtalhos(aMenu,aMenuAt,Iif(l100Visual,"V","A")	)
		
		// configura as teclas de atalho
	 	SetAtalho(aMenuAt,aMenu,.F.)


		aAreaAF1 := AF1->(GetArea())
		
		If lConfExcTe
			If nDlgPln == PMS_VIEW_SHEET
				aCampos := {{"ZF2_TAREFA","ZF5_EDT",8,,,.F.,"",},{"ZF2_DESCRI","ZF5_DESCRI",55,,,.F.,"",150}}
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
PRIVATE bRefresh	:= {|| (PmsAtuPOrc(cArquivo,nNivelMax,,aExpand,nIndent),oBrowse:Refresh()) }
PRIVATE bRefreshAll	:= bRefresh //bRefreshAll - sem utilizacao

DEFAULT lExcel	:= .F.                                                    
DEFAULT nIndent := PMS_SHEET_INDENT


RegToMemory("ZF1",.F.)
RegToMemory("ZF3",.T.)
RegToMemory("ZF4",.T.)
RegToMemory("ZF5",.F.)
RegToMemory("ZF7",.F.)

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

nNivelMax := PmsAtuPOrc(cArquivo,If(ZF1->ZF1_NMAX>0,ZF1->ZF1_NMAX,1),,aExpand,nIndent)

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
	oBtn := TBtnBmp():NewBar( BMP_CANCELA,BMP_CANCELA,,,"Sair"+" < Ctrl-X >", {|| oDlg:End() },.T.,oBar,,,"Sair"+" < Ctrl-X >")
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
oBrowse := TcBrowse():New( 14, 1, (nRight/2)-2,(nBottom/2)-40, , , , oDlg, ,,,,{|| PmsExpOrc(cArquivo,aExpand,@nNivelMax),(PmsAtuPOrc(cArquivo,nNivelMax,,aExpand,nIndent),oBrowse:Refresh()) },,oFont,,,,, .F.,cArquivo, .T.,, .F., , ,.F. )
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSDlgAF1³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta a Dialog de visualizacao do Orcamento                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PmsDlgAF1(cTitle,oMenu,oTree,cFilhos,bChange,lConfirma,aMenu,oDlg)

Local oPanel
Local aSVAlias		:= {}
Local aEnch[12]
Local nTop      := oMainWnd:nTop+35
Local nLeft     := oMainWnd:nLeft+10
Local nBottom   := oMainWnd:nBottom-12
Local nRight    := oMainWnd:nRight-10
Local nOldEnch	:= 10
Local oFont
Local aButtons  := {}
Local nX        := 0

PRIVATE bRefresh	:= {|| PMSTreeOrc(@oTree,,cFilhos,Nil,.T.),Eval(oTree:bChange)}
PRIVATE bRefreshAll	:= bRefresh //bRefreshAll - sem utilizacao

DEFAULT bChange := {|| Nil }
DEFAULT cFilhos := "ZF1,ZF5,ZF2,ZF7"// Alias que sao amarrados ao TREE

If ExistBlock("PMSAF101")
	cFilhos := ExecBlock("PMSAF101", .F., .F., {cFilhos})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ExecBlock para inclusao de botoes customizados       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("PMSAF1BD")
	aButtons := ExecBlock("PMSAF1BD",.F.,.F.)
	For nx := 1 to Len(aButtons)
		aAdd(aMenu,{aButtons[nx,1],aButtons[nx,2],aButtons[nx,3],aButtons[nx,4]})
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as variaveis de memoria do AF1.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("ZF1",.F.)
RegToMemory("ZF3",.T.)
RegToMemory("ZF4",.T.)
RegToMemory("ZF5",.F.)
RegToMemory("ZF7",.F.)
If ("ACB" $ cFilhos)
	RegToMemory("ACB",.T.)
EndIf

If "USR"$cFilhos
	RegToMemory("AJG",.T.)
	RegToMemory("AJF",.T.)
EndIf                  

DEFINE FONT oFont NAME "Arial" SIZE 0, -10
DEFINE MSDIALOG oDlg TITLE cTitle OF oMainWnd PIXEL FROM nTop,nLeft TO nBottom,nRight
oDlg:lMaximized := .T.
 
If SetMdiChild()
	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	
	For nx := 1 to Len(aMenu)
		oBtn := TBtnBmp():NewBar( aMenu[nx][3],aMenu[nx][3],,,aMenu[nx][1], aMenu[nx][2],.T.,oBar,,,aMenu[nx][1])
		oBtn:cTitle := aMenu[nx][4]
	Next
	
	oBtn := TBtnBmp():NewBar( BMP_INTERROGACAO,BMP_INTERROGACAO,, ,"Help" ,{|| HelProg() },.T.,oBar,, ,"HELP")
	oBtn:cTitle := "Help"

	If lConfirma<>Nil
		// Ok
		oBtn := TBtnBmp():NewBar( BMP_OK,BMP_OK,,,"OK"+" < Ctrl-O >", {|| (lConfirma:=.T.,oDlg:End()) },.T.,oBar,,,"OK"+" < Ctrl-O >")
		oBtn:cTitle := "OK"
	EndIf    
	
	// Sair
	oBtn := TBtnBmp():NewBar( BMP_CANCELA,BMP_CANCELA,,,"SAIR"+" < Ctrl-X >", {|| oDlg:End() },.T.,oBar,,,"SAIR"+" < Ctrl-X >")
	oBtn:cTitle := "SAIR"
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
	oBtn := TButton():New( 10, nCol,"SAIR",oPanel,{|| oDlg:End() },24,12, , , ,.T.)
	oBtn:cToolTip := "SAIR"+" < Ctrl-X >"
	nCol += 24
EndIf

oPanel := TPanel():New(14,152,'',oDlg,oDlg:oFont, .T., .T.,, ,(nRight-nLeft)/2-152,((oDLg:nBottom-oDLg:nTop)/2)-38,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT
lOneColumn := If((nRight-nLeft)/2-178>312,.F.,.T.)

aAdd(aSVAlias,"ZF2")
aEnch[1]:= MsMGet():New("ZF2",ZF2->(RecNo()),2,,,,,{0,0,((oDlg:nBottom-oDlg:nTop)/2)-40,(nRight-nLeft)/2-152},,3,,,,oPanel,,,lOneColumn)
aEnch[1]:Hide()

aAdd(aSVAlias,"ZF5")
aEnch[5]:= MsMGet():New("ZF5",ZF5->(RecNo()),2,,,,,{0,0,((oDlg:nBottom-oDlg:nTop)/2)-40,(nRight-nLeft)/2-152},,3,,,,oPanel,,,lOneColumn)
aEnch[5]:Hide()

aAdd(aSVAlias,"ZF1")
aEnch[10]:= MsMGet():New("ZF1",ZF1->(RecNo()),2,,,,,{0,0,((oDlg:nBottom-oDlg:nTop)/2)-40,(nRight-nLeft)/2-152},,3,,,,oPanel,,,lOneColumn)

oTree := dbTree():New(14, 2,((oDLg:nBottom-oDLg:nTop)/2)-25, 150, oDlg,,,.T.)
oTree:Align := CONTROL_ALIGN_LEFT
oTree:bChange := {|| PMSViewOrc(@oTree,@aSVAlias,@aEnch,{0,0,((oDlg:nBottom-oDlg:nTop)/2)-40,(nRight-nLeft)/2-152},@nOldEnch,@oPanel),Eval(bChange)}
oTree:SetFont(oFont)
oTree:lShowHint:= .F. 

PMSTreeOrc(@oTree,,cFilhos,Nil,.T.)

ACTIVATE MSDIALOG oDlg

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSViewOrc³ Autor ³ Edson Maricate        ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que monta o a Tarefa no Tree do Orcamento.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PMSViewOrc(oTree,aSVAlias,aEnch,aPos,nOldEnch,oPanel)

Local cAlias	:= SubStr(oTree:GetCargo(),1,3)
Local nRecView	:= Val(SubStr(oTree:GetCargo(),4,12))
Local nPosAlias	:= aScan(aSVAlias,cAlias)
Local lOneColumn:= If(aPos[4]-aPos[2]>312,.F.,.T.)

If nRecView <> 0
	aEnch[nOldEnch]:Hide()
	dbSelectArea(cAlias)
	MsGoto(nRecView)
	RegToMemory(cAlias,.F.)
	Do Case
		Case cAlias == "ZF3"
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial()+ZF3->ZF3_PRODUT))
			M->ZF3_TIPO	:= SB1->B1_TIPO
			M->ZF3_UM	:= SB1->B1_UM
			M->ZF3_SEGUM := SB1->B1_SEGUM
			M->ZF3_DESCRI:= SB1->B1_DESC
		Case cAlias == "ZF4"
			SX5->(dbSetOrder(1))
			SX5->(MsSeek(xFilial()+"FD"+ZF4->ZF4_TIPOD))
			M->ZF4_DESCTP := X5DESCRI()
			M->ZF4_SIMBMO := GetMv("MV_SIMB"+Alltrim(STR(ZF4->ZF4_MOEDA,2,0)))
		Case cAlias == "ZF7"
			ZF2->(dbSetOrder(1)) //ZF2_FILIAL, ZF2_ORCAME, ZF2_XREV, ZF2_TAREFA, ZF2_ORDEM, R_E_C_N_O_, D_E_L_E_T_
			ZF2->(MsSeek(xFilial()+ZF7->ZF7_ORCAME+ZF7->ZF7_XREV+ZF7->ZF7_PREDEC)) // Verificar
			M->ZF7_DESCRI := ZF2->ZF2_DESCRI
		Case cAlias == "AJ1"
			ZF5->(dbSetOrder(1))//ZF5_FILIAL, ZF5_ORCAME, ZF5_XREV, ZF5_EDT, ZF5_ORDEM, R_E_C_N_O_, D_E_L_E_T_
			ZF5->(MsSeek(xFilial()+AJ1->AJ1_ORCAME+ZF1->ZF1_XREV+AJ1->AJ1_PREDEC)) // Verificar
			M->AJ1_DESCRI := ZF5->ZF5_DESCRI
		Case cAlias == "AJ2"
			ZF2->(dbSetOrder(1)) //ZF2_FILIAL, ZF2_ORCAME, ZF2_XREV, ZF2_TAREFA, ZF2_ORDEM, R_E_C_N_O_, D_E_L_E_T_
			ZF2->(MsSeek(xFilial()+AJ2->AJ2_ORCAME+ZF1->ZF1_XREV+AJ2->AJ2_PREDEC)) // Verificar
			M->AJ2_DESCRI := ZF2->ZF2_DESCRI
		Case cAlias == "AJ3"
			ZF5->(dbSetOrder(1)) //ZF5_FILIAL, ZF5_ORCAME, ZF5_XREV, ZF5_EDT, ZF5_ORDEM, R_E_C_N_O_, D_E_L_E_T_
			ZF5->(MsSeek(xFilial()+AJ3->AJ3_ORCAME+ZF1->ZF1_XREV+AJ3->AJ3_PREDEC)) // Verificar
			M->AJ3_DESCRI := ZF5->ZF5_DESCRI
	EndCase	
	If nPosAlias > 0
		Do Case
			Case cAlias == "ZF2"
				aEnch[1]:EnchRefreshAll()
				aEnch[1]:Show()
				nOldEnch:=1
			Case cAlias == "ZF3"
				aEnch[2]:EnchRefreshAll()
				aEnch[2]:Show()
				noldEnch:=2
			Case cAlias == "ZF4"
				aEnch[3]:EnchRefreshAll()
				aEnch[3]:Show()
				noldEnch:=3				
			Case cAlias == "ZF7"
				aEnch[4]:EnchRefreshAll()
				aEnch[4]:Show()
				noldEnch:=4				
			Case cAlias == "ZF5"
				aEnch[5]:EnchRefreshAll()
				aEnch[5]:Show()
				noldEnch:=5				
			Case cAlias == "ACB"
				aEnch[6]:EnchRefreshAll()
				aEnch[6]:Show()
				noldEnch:=6
			Case cAlias == "AJ1"
				aEnch[7]:EnchRefreshAll()
				aEnch[7]:Show()
				noldEnch:=7
			Case cAlias == "AJ2"
				aEnch[8]:EnchRefreshAll()
				aEnch[8]:Show()
				noldEnch:=8
			Case cAlias == "AJ3"
				aEnch[9]:EnchRefreshAll()
				aEnch[9]:Show()
				noldEnch:=9
			Case cAlias == "ZF1"
				aEnch[10]:EnchRefreshAll()
				aEnch[10]:Show()
				noldEnch:=10
			Case cAlias == "AJF"
				aEnch[11]:EnchRefreshAll()
				aEnch[11]:Show()
				noldEnch:=11
			Case cAlias == "AJG"
				aEnch[12]:EnchRefreshAll()
				aEnch[12]:Show()
				noldEnch:=12
		EndCase
	Else
		Do Case
			Case cAlias == "ZF3"
				aAdd(aSVAlias,"ZF3")
				oPanel:Hide()
				aEnch[2]:= MsMGet():New("ZF3",ZF3->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				SB1->(dbSetOrder(1))
				SB1->(MsSeek(xFilial()+ZF3->ZF3_PRODUT))
				M->ZF3_TIPO	:= SB1->B1_TIPO
				M->ZF3_UM	:= SB1->B1_UM
				M->ZF3_SEGUM := SB1->B1_SEGUM
				M->ZF3_DESCRI:= SB1->B1_DESC
				aEnch[2]:EnchRefreshAll()
				nOldEnch:=2				
			Case cAlias == "ZF4"
				aAdd(aSVAlias,"ZF4")
				oPanel:Hide()
				aEnch[3]:= MsMGet():New("ZF4",ZF4->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				SX5->(dbSetOrder(1))
				SX5->(MsSeek(xFilial()+"FD"+ZF4->ZF4_TIPOD))
				M->ZF4_DESCTP := X5DESCRI()
				M->ZF4_SIMBMO := GetMv("MV_SIMB"+Alltrim(STR(ZF4->ZF4_MOEDA,2,0)))
				aEnch[3]:EnchRefreshAll()				
				nOldEnch:=3				
			Case cAlias == "ZF7"
				aAdd(aSVAlias,"ZF7")
				oPanel:Hide()				
				aEnch[4]:= MsMGet():New("ZF7",ZF7->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				ZF2->(dbSetOrder(1))
				ZF2->(MsSeek(xFilial()+ZF7->ZF7_ORCAME+ZF1->ZF1_XREV+ZF7->ZF7_PREDEC)) // Verificar
				M->ZF7_DESCRI := ZF2->ZF2_DESCRI
				aEnch[4]:EnchRefreshAll()
				nOldEnch:=4
			Case cAlias == "ACB"
				aAdd(aSVAlias,"ACB")
				oPanel:Hide()
				aEnch[6]:= MsMGet():New("ACB",ZF7->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				nOldEnch:=6
			Case cAlias == "AJ1"
				aAdd(aSVAlias,"AJ1")
				oPanel:Hide()
				aEnch[7]:= MsMGet():New("AJ1",AJ1->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				nOldEnch:=7
			Case cAlias == "AJ2"
				aAdd(aSVAlias,"AJ2")
				oPanel:Hide()
				aEnch[8]:= MsMGet():New("AJ2",AJ2->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				nOldEnch:=8
			Case cAlias == "AJ3"
				aAdd(aSVAlias,"AJ3")
				oPanel:Hide()
				aEnch[9]:= MsMGet():New("AJ3",AJ3->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				nOldEnch:=9
			Case cAlias == "AJF"
				aAdd(aSVAlias,"AJF")
				oPanel:Hide()
				aEnch[11]:= MsMGet():New("AJF",AJF->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				nOldEnch:=11
			Case cAlias == "AJG"
				aAdd(aSVAlias,"AJG")
				oPanel:Hide()
				aEnch[12]:= MsMGet():New("AJG",AJF->(RecNo()),2,,,,,aPos,,3,,,,oPanel,,,lOneColumn)
				oPanel:Show()
				nOldEnch:=12
		EndCase
	EndIf
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsTreeOrc³ Autor ³ Edson Maricate        ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que realiza a montagem do Tree da Estrutura do Orcamen ³±±
±±³          ³to atual.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPMS                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PMSTreeOrc(oTree,aEstrutura,cFilhos,bCondicao,lReset)
Local lRet

PmsNewProc()
lRet := Processa({||AuxTreeOrc(oTree,aEstrutura,cFilhos,bCondicao,lReset)},"AGUARDE")

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AuxTreeOrc³ Autor ³ Cristiano G. da Cunha ³ Data ³ 17.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que monta o Tree do Orcamento por EDT                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AuxTreeOrc(oTree,aEstrutura,cFilhos,bCondicao,lReset)

Local aArea		:= GetArea()
Local lViewCod	:= GetMV("MV_PMSVCOD")
Local cChaveAnt 

DEFAULT cFilhos 	:= "ZF1,ZF5,ZF2,ZF3,ZF4,ZF7"// Alias que sao amarrados ao TREE
DEFAULT lReset 		:= .T.                                                    


If lReset
	cChaveAnt := oTree:GetCargo()
	oTree:BeginUpdate()
	oTree:Reset()
	oTree:EndUpdate()
EndIf
oTree:Hide()
oTree:BeginUpdate()
oTree:TreeSeek("")
oTree:AddItem(OemToAnsi(ZF1->ZF1_DESCRI),"ZF1"+StrZero(ZF1->(RecNo()),12),BMP_TABLE_PQ,BMP_TABLE_PQ,,,1)

dbSelectArea("ZF5")
dbSetOrder(3)
MsSeek(xFilial()+ZF1->ZF1_ORCAME+"001")
While !Eof() .And. ZF5->ZF5_FILIAL+ZF5->ZF5_ORCAME+ZF5->ZF5_NIVEL == ;
					xFilial("ZF5")+ZF1->ZF1_ORCAME+"001"
	If ZF5->ZF5_XREV = SZ2->Z2_NUMREV
		PMSOrcTrf(@oTree,ZF5->ZF5_ORCAME+ZF5->ZF5_EDT,,cFilhos, bCondicao,, 2,lViewCod,"ZF1"+StrZero(ZF1->(RecNo()),12))
	EndIf
	
	dbSkip()
End

oTree:EndUpdate()
oTree:TreeSeek(cChaveAnt)
oTree:Show()

RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsOrcTrf³ Autor ³ Michel Dantas          ³ Data ³ 23-07-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que monta o a Tarefa no Tree do Orcamento.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSA100                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PMSOrcTrf(oTree,cChave,aEstrutura,cFilhos,bCondicao,nPaiMat,nNivel,lViewCod,cSeekAdd)

Local nx		:= 0
Local aArea		:= GetArea()
Local aAreaAF5	:= ZF5->(GetArea())
Local aAreaAF2	:= ZF2->(GetArea())
Local aAuxArea  := {}
Local aDocAF5	:= {}

Local aNodes := {}
Local nNode  := 0


If ZF5->ZF5_XREV <> SZ2->Z2_NUMREV
	Return
EndIf

If PmsOrcUser(ZF5->ZF5_ORCAME,,ZF5->ZF5_EDT,ZF5->ZF5_EDTPAI,1,"ESTRUT")
	PmsIncProc(.T.,1)
	oTree:TreeSeek(cSeekAdd)
	oTree:AddItem(If(lViewCod,Alltrim(ZF5->ZF5_EDT)+"-","")+Alltrim(Substr(ZF5->ZF5_DESCRI,1,50)),"ZF5"+StrZero(ZF5->(RecNo()),12),BMP_EDT4,BMP_EDT4,,,2)
	cSeekAdd := "ZF5"+StrZero(ZF5->(RecNo()),12)
	oTree:TreeSeek(cSeekAdd)
	
	If "USR"$cFilhos
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Insere os usuarios do Projeto no Tree                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AJF")
		dbSetOrder(1)
		MsSeek(xFilial()+ZF5->ZF5_ORCAME+ZF1->ZF1_XREV+ZF5->ZF5_EDT)
		While !Eof() .And. AJF->AJF_FILIAL+AJF->AJF_ORCAME+AJF->AJF_EDT==xFilial()+ZF5->ZF5_ORCAME+ZF5->ZF5_EDT
			oTree:AddItem(UsrRetName(AJF->AJF_USER),"AJF"+StrZero(AJF->(RecNo()),12),BMP_USER_PQ,BMP_USER_PQ,,,2)
			dbSkip()
		End
	EndIf
	
		
	If "ACB"$cFilhos
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Insere os documentos da EDT no Tree                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MsDocument("ZF5",ZF5->(RecNo()),3,,4,@aDocAF5)
		For nx := 1 to Len(aDocAF5)
			ACB->(dbGoto(aDocAF5[nx]))
			oTree:AddItem(Substr(ACB->ACB_DESCRI,1,50),"ACB"+StrZero(ACB->(RecNo()),12),BMP_CLIPS_PQ,BMP_CLIPS_PQ,,,2)
		Next
	EndIf
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui os Relacionamentos AF7                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "ZF7"$cFilhos
		aAuxArea := ZF2->(GetArea())
		ZF2->(dbSetOrder(1))	
		dbSelectArea("AJ2")
		dbSetOrder(1)
		MsSeek(xFilial()+cChave)
		While !Eof() .And. AJ2->AJ2_FILIAL+AJ2->AJ2_ORCAME+AJ2->AJ2_EDT == ;
							xFilial("AJ2")+cChave
			ZF2->(MsSeek(xFilial()+AJ2->AJ2_ORCAME+AJ2->AJ2_PREDEC))
			oTree:AddItem(ZF2->ZF2_DESCRI,"AJ2"+StrZero(AJ2->(RecNo()),12),BMP_RELAC_DIREITA_PQ,BMP_RELAC_DIREITA_PQ,,,2)
			dbSelectArea("AJ2")
			dbSkip()
		EndDo
		RestArea(aAuxArea)	
		aAuxArea := ZF5->(GetArea())
		ZF5->(dbSetOrder(1))	
		dbSelectArea("AJ3")
		dbSetOrder(1)
		MsSeek(xFilial()+cChave)
		While !Eof() .And. AJ3->AJ3_FILIAL+AJ3->AJ3_ORCAME+AJ3->AJ3_EDT == ;
							xFilial("AJ3")+cChave
			ZF5->(MsSeek(xFilial()+AJ3->AJ3_ORCAME+AJ3->AJ3_EDT))
			oTree:AddItem(ZF5->ZF5_DESCRI,"AJ3"+StrZero(AJ3->(RecNo()),12),BMP_RELAC_DIREITA_PQ,BMP_RELAC_DIREITA_PQ,,,2)
			dbSelectArea("AJ3")
			dbSkip()
		EndDo
		RestArea(aAuxArea)	
	EndIf
EndIf	

dbSelectArea("ZF2")
dbSetOrder(2)
MsSeek(xFilial()+cChave)
While !Eof() .And. ZF2->ZF2_FILIAL+ZF2->ZF2_ORCAME+ZF2->ZF2_EDTPAI == ;
					xFilial("ZF2")+cChave
	If ZF2->ZF2_XREV = SZ2->Z2_NUMREV
		If PmsOrcUser(ZF2->ZF2_ORCAME,ZF2->ZF2_ORCAME,,ZF2->ZF2_EDTPAI,1,"ESTRUT")
			aAdd(aNodes, {PMS_TASK,;
			              ZF2->(Recno()),;
			IIf(Empty(ZF2->ZF2_ORDEM), "000", ZF2->ZF2_ORDEM),;
			              ZF2->ZF2_TAREFA})
		EndIf
	EndIf
	dbSkip()
End	


dbSelectArea("ZF5")
dbSetOrder(2)
MsSeek(xFilial()+cChave)
While !Eof() .And. ZF5->ZF5_FILIAL+ZF5->ZF5_ORCAME+ZF5->ZF5_EDTPAI == ;
					xFilial("ZF5")+cChave
	If ZF5->ZF5_XREV = SZ2->Z2_NUMREV
		aAdd(aNodes, {PMS_WBS,;
		              ZF5->(Recno()),;
		IIf(Empty(ZF5->ZF5_ORDEM), "000", ZF5->ZF5_ORDEM),;
		              ZF5->ZF5_EDT})
	EndIf
	dbSkip()
EndDo

aSort(aNodes, , , {|x, y| x[3]+x[4] < y[3]+y[4]})

For nNode := 1 To Len(aNodes)
	If aNodes[nNode][1] = PMS_TASK
		ZF2->(dbGoto(aNodes[nNode][2]))
		
		PMSAdd2Trf(@oTree,ZF2->ZF2_ORCAME+ZF2->ZF2_TAREFA,aEstrutura,cFilhos,bCondicao,,;
		           nNivel,lViewCod,cSeekAdd)
	Else
		ZF5->(dbGoto(aNodes[nNode][2]))

		PMSOrcTrf(@oTree,ZF5->ZF5_ORCAME+ZF5->ZF5_EDT,aEstrutura,cFilhos,bCondicao,,;
		          nNivel,lViewCod,cSeekAdd)		
	EndIf
Next

RestArea(aAreaAF2)
RestArea(aAreaAF5)
RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAdd2Trf³ Autor ³ Michel Dantas         ³ Data ³ 23-07-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que monta a tarefa no Tree do Orcamento.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSXFUN                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PmsAdd2Trf(oTree,cChave,aEstrutura,cFilhos,bCondicao,nPaiEdt,nNivel,lViewCod,cSeekAdd)

Local nx
Local aDocAF2	:= {}
Local aArea		:= GetArea()
Local aAreaAF2	:= ZF2->(GetArea())
Local aAreaAF3	:= ZF3->(GetArea())
Local aAreaAF4	:= ZF4->(GetArea())
Local aAreaAF5	:= ZF5->(GetArea())

PmsIncProc(.T.,1)


oTree:TreeSeek(cSeekAdd)
oTree:AddItem(If(lViewCod,AllTrim(ZF2->ZF2_TAREFA)+"-","")+AllTrim(Substr(ZF2->ZF2_DESCRI,1,50)),"ZF2"+StrZero(ZF2->(RecNo()),12),BMP_TASK3,BMP_TASK3,,,2)
oTree:TreeSeek("ZF2"+StrZero(ZF2->(RecNo()),12))

If "USR"$cFilhos
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Insere os usuarios do Projeto no Tree                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("AJG")
	dbSetOrder(1)
	MsSeek(xFilial()+ZF2->ZF2_ORCAME+ZF2->ZF2_TAREFA)
	While !Eof() .And. AJG->AJG_FILIAL+AJG->AJG_ORCAME+AJG->AJG_TAREFA==xFilial()+ZF2->ZF2_ORCAME+ZF2->ZF2_TAREFA
		oTree:AddItem(UsrRetName(AJG->AJG_USER),"AJG"+StrZero(AJG->(RecNo()),12),BMP_USER_PQ,BMP_USER_PQ,,,2)
		dbSkip()
	End
EndIf


If "ACB"$cFilhos
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Insere os documentos da Tarefa no Tree                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsDocument("ZF2",ZF2->(RecNo()),3,,4,@aDocAF2)
	For nx := 1 to Len(aDocAF2)
		ACB->(dbGoto(aDocAF2[nx]))
		oTree:AddItem(Substr(ACB->ACB_DESCRI,1,50),"ACB"+StrZero(ACB->(RecNo()),12),BMP_CLIPS_PQ,BMP_CLIPS_PQ,,,2)
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os produtos da tarefa AF3                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "ZF3"$cFilhos
	SB1->(dbSetOrder(1))
	dbSelectArea("ZF3")
	dbSetOrder(1)
	MsSeek(xFilial()+cChave)
	While !Eof() .And. ZF3->ZF3_FILIAL+ZF3->ZF3_ORCAME+ZF3->ZF3_TAREFA == ;
						xFilial("ZF3")+cChave
		If ZF3->ZF3_XREV = SZ2->Z2_NUMREV
			SB1->(MsSeek(xFilial()+ZF3->ZF3_PRODUT))
			oTree:AddItem(SB1->B1_DESC,"ZF3"+StrZero(ZF3->(RecNo()),12),BMP_MATERIAL,BMP_MATERIAL,,,2)
		EndIf
		dbSkip()
	End	
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui as despesas da tarefa AF4                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "ZF4"$cFilhos
	dbSelectArea("ZF4")
	dbSetOrder(1)
	MsSeek(xFilial()+cChave)
	While !Eof() .And. ZF4->ZF4_FILIAL+ZF4->ZF4_ORCAME+ZF4->ZF4_TAREFA == ;
						xFilial("ZF4")+cChave
		If ZF4->ZF4_XREV = SZ2->Z2_NUMREV
			oTree:AddItem(ZF4->ZF4_DESCRI,"ZF4"+StrZero(AFB->(RecNo()),12),BMP_BUDGET,BMP_BUDGET,,,2)
		EndIf
		dbSkip()
	End	
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os Relacionamentos AF7                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "ZF7"$cFilhos
	aAuxArea := ZF2->(GetArea())
	ZF2->(dbSetOrder(1))	
	dbSelectArea("ZF7")
	dbSetOrder(1)
	MsSeek(xFilial()+cChave)
	While !Eof() .And. ZF7->ZF7_FILIAL+ZF7->ZF7_ORCAME+ZF7->ZF7_TAREFA == ;
						xFilial("ZF7")+cChave
		If ZF7->ZF7_XREV = SZ2->Z2_NUMREV
			ZF2->(MsSeek(xFilial()+ZF7->ZF7_ORCAME+ZF7->ZF7_PREDEC))
			oTree:AddItem(ZF2->ZF2_DESCRI,"ZF7"+StrZero(ZF7->(RecNo()),12),BMP_RELAC_DIREITA_PQ,BMP_RELAC_DIREITA_PQ,,,2)
		Endif
		dbSelectArea("ZF7")
		dbSkip()
	EndDo
	RestArea(aAuxArea)	
	aAuxArea := ZF5->(GetArea())
	ZF5->(dbSetOrder(1))	
	dbSelectArea("AJ1")
	dbSetOrder(1)
	MsSeek(xFilial()+cChave)
	While !Eof() .And. AJ1->AJ1_FILIAL+AJ1->AJ1_ORCAME+AJ1->AJ1_TAREFA == ;
						xFilial("AJ1")+cChave

		ZF5->(MsSeek(xFilial()+AJ1->AJ1_ORCAME+AJ1->AJ1_PREDEC))
		If ZF5->ZF5_XREV = SZ2->Z2_NUMREV
			oTree:AddItem(ZF5->ZF5_DESCRI,"AJ1"+StrZero(AJ1->(RecNo()),12),BMP_RELAC_DIREITA_PQ,BMP_RELAC_DIREITA_PQ,,,2)
		EndIf
		dbSelectArea("AJ1")
		dbSkip()
	EndDo
	RestArea(aAuxArea)	
EndIf
	
RestArea(aAreaAF2)
RestArea(aAreaAF3)
RestArea(aAreaAF4)
RestArea(aAreaAF5)
RestArea(aArea)

Return
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
			aAdd(aCampos,{"ZF2"+cAux,"ZF5"+cAux,,,,.F.,"",})
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C050ChkPln³ Autor ³ Cristiano G. da Cunha ³ Data ³ 25.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica quais os campos que devem aparecer na planilha.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSC050                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C050ChkPln(aCampos)
Local cCampos := cCmpPLN

While !Empty(AllTrim(cCampos))
	If AT("#",cCampos) > 0
		cAux := Substr(cCampos,1,AT("#",cCampos)-1)
		If Substr(cAux,2,1)$"$%|"
			aAdd(aCampos,{Substr(cAux,2,Len(cAux)-1),Substr(cAux,2,Len(cAux)-1),,,,.F.,"",})
		Else
			aAdd(aCampos,{"ZF2"+cAux,"ZF5"+cAux,,,,.F.,"",})
		EndIf
		cCampos := Substr(cCampos,AT("#",cCampos)+1,Len(cCampos)-AT("#",cCampos))
	Else
		cCampos := ''
	EndIf
End

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GravaOrc  ³ Autor ³ Adriano Ueda         ³ Data ³ 15-10-2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava os campos, formulas e variaveis em arquivo             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1 : Campos e formulas a serem gravados                    ³±±
±±³          ³ExpA2 : Variaveis a serem gravadas                            ³±±
±±³          ³ExpC3 : Arquivo a ser salvo (pode ou nao conter a extensao    ³±±
±±³          ³        .pln - a extensao nao e obrigatoria)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³ a variavel cVersao indica a versao do arquivo                ³±±
±±³          ³                                                              ³±±
±±³          ³ 001 - arquivo nao codificado                                 ³±±
±±³          ³ 002 - arquivo codificado                                     ³±±
±±³          ³                                                              ³±±
±±³          ³ lSenha indica se o arquivo sera protegido ou nao             ³±±
±±³          ³ .T. - o arquivo sera gravado com os dados codificados        ³±±
±±³          ³ .F. - o arquivo sera gravado sem os dados codificados        ³±±
±±³          ³                                                              ³±±
±±³          ³ cPLNSenha contem a senha para acessar o arquivo              ³±±
±±³          ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaOrc(aCampos, aVars, cArquivo, nStart)
Local cMvFldPln  := ""
Local cWrite
Local nCount := 0   

Default nStart := 3

// campos e formulas
For nCount := nStart to Len(aCampos)
	cMvFldPln += ("_"+aCampos[nCount][2]+"#")
Next

// variaveis
For nCount := 1 To Len(aVars)
	If !Empty(aVars[nCount][1])
		If Chr(0) $ aVars[nCount][8]
			cMvFldPln += RetNulos(aVars[nCount][8]) +"#"
		Else
			cMvFldPln += aVars[nCount][8] +"#"
		Endif
	EndIf
Next

// acrescenta extensao ao arquivo se nao existir
// no nome do arquivo
If Upper(Right(AllTrim(cArquivo), 4)) != Upper(PMS_SHEET_EXT)
	cArquivo := AllTrim(cArquivo) + PMS_SHEET_EXT
EndIf

// Codifica o arquivo
If lSenha
	cWrite := Embaralha(cMvFldPln, 1)+Chr(13)+Chr(10)
	cWrite += "002"+Chr(13)+Chr(10)  // arquivo codificado
	cWrite += cPLNSenha+Chr(13)+Chr(10)
	cWrite += Embaralha(cPLNDescri, 1)
Else
	cWrite := cMvFldPln+Chr(13)+Chr(10)
	cWrite += "001"+Chr(13)+Chr(10)  // arquivo nao codificado (default)
	cWrite += cPLNDescri
EndIf

If Type("nFreeze") == "U"
	cWrite += CRLF + "0"
Else
	cWrite += CRLF + AllTrim(Str(nFreeze))
EndIf

If Type("nIndent") == "U"
	cWrite += CRLF + "4"
Else
	cWrite += CRLF + AllTrim(Str(nIndent))
EndIf

MemoWrit(cArquivo,cWrite)
cCmpPLN	:= cMvFldPln
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAtuPOrc³ Autor ³ Cristiano G. da Cunha ³ Data ³ 15.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Executa a atualizacao do arquivo de trabalho.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PmsAtuPOrc(cArquivo,nNivelMax,lRecno,aExpand,nIndent)
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
(cArquivo)->XF2_TAREFA := ZF1->ZF1_ORCAME
(cArquivo)->XF2_DESCRI := ZF1->ZF1_DESCRI
If lRecNo
	(cArquivo)->RECNO := ZF1->(RecNo())
	(cArquivo)->ALIAS := "ZF1"
EndIf

ZF5->(dbSetOrder(3))
If ZF5->(MsSeek(xFilial()+ZF1->ZF1_ORCAME+"001"))
	While ZF5->ZF5_ORCAME = ZF1->ZF1_ORCAME .and. ZF5->ZF5_NIVEL = "001" .and. ZF5->(!EOF())
		If ZF5->ZF5_XREV = SZ2->Z2_NUMREV
			Exit
		EndIf
		ZF5->(DbSkip())
	EndDo

	For nx := 1 to Len(aAuxCps)
		If aAuxCps[nx][1]=="ZF2_DESCRI"
			If ZF5->(FieldPos(aAuxCps[nx][2])) > 0	
				FieldPut(FieldPos("X"+Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),SPACE((VAL(ZF5->ZF5_NIVEL)-1)*nIndent)+ZF5->(FieldGet(FieldPos(aAuxCps[nx][2]))))
			Endif
		ElseIf Substr(aAuxCps[nx][1],1,1)=="%"
			aAdd(aProcForm,nx)
		Else
			If Substr(aAuxCps[nx][1],1,1)=="$"
				FieldPut(FieldPos(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),&(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)+"(3,'ZF5',ZF5->(RecNo()))"))
			Else
				If Substr(aAuxCps[nx][1],1,1)!="|"
					// se o campo existe na tabela AF5 e se existe o campo na tabela "planilha" a qual vai ser gravado
					If ZF5->(FieldPos(aAuxCps[nx][2])) > 0 .and. FieldPos("XF2"+Substr(aAuxCps[nX][2],4,Len(aAuxCps[nX][2])-1))>0
						FieldPut(FieldPos("XF2"+Substr(aAuxCps[nX][2],4,Len(aAuxCps[nX][2])-1)),ZF5->(FieldGet(FieldPos(aAuxCps[nX][2]))))
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

dbSelectArea("ZF5")
dbSetOrder(3)
MsSeek(xFilial()+ZF1->ZF1_ORCAME+"001")
While !Eof() .And. ZF5->ZF5_FILIAL+ZF5->ZF5_ORCAME+ZF5->ZF5_NIVEL == ;
					xFilial("ZF5")+ZF1->ZF1_ORCAME+"001"
	If ZF5->ZF5_XREV = SZ2->Z2_NUMREV
		PmsAddPOrc(ZF5->ZF5_ORCAME+ZF5->ZF5_EDT,cArquivo,@nNivelAtu,nNivelMax,lRecNo,aExpand,nIndent)
	EndIf
	dbSelectArea("ZF5")
	dbSkip()
End

CursorArrow()

RestArea(aAreaTmp)
RestArea(aArea)
Return nNivelAtu
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | PMSPlnCalc   ³ Autor ³ Adriano Ueda           ³ Data ³ 06-04-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Realiza o calculo de campos e formulas da planilha                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aProcForm -                                                       ³±±
±±³          ³ aAuxCps   -                                                       ³±±
±±³          ³ cArquivo  -                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Uso restrito a funcao PMSAddPlan()                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMSPlnCalc(aProcForm, aAuxCps, cArquivo)
	Local nCntLet := 0
	Local nCount  := 0
	Local cBlock  := ""
	Local nx      := 0
	Local ny      := 0
	Local bBlock  := ErrorBlock({|e| ChecErro(e)}) // salva o manipulador de erro padrao
	
	
	For nx := 1 to Len(aProcForm)
		nCntLet := 0
		nCount := 0						
	
		For ny := 1 to Len(aAuxCps)
			If Substr(aAuxCps[ny][1], 1, 1) # "|"
				nCntLet++
				If nCntLet > 26
					nCntLet	:= 1
					nCount++
				EndIf
				If nCount > 0
					If Upper(AllTrim((cArquivo)->(FieldName(1))))=="CTRLNIV"
						&(Chr(64+nCntLet)+Chr(48+nCount)) := (cArquivo)->(FieldGet(ny+1))
					Else
						&(Chr(64+nCntLet)+Chr(48+nCount)) := (cArquivo)->(FieldGet(ny))
					EndIf
				Else
					If Upper(AllTrim((cArquivo)->(FieldName(1))))=="CTRLNIV"
						&(Chr(64+nCntLet)) := (cArquivo)->(FieldGet(ny+1))
					Else
						&(Chr(64+nCntLet)) := (cArquivo)->(FieldGet(ny))
					EndIf
				EndIf
			EndIf
		Next
	
		If RepVar(@cBlock, Substr(aAuxCps[aProcForm[nx]][1],58,60))==-1
			Alert("Erro processando o campo " + Substr(aAuxCps[aProcForm[nx]][1],2,12)+;//
			"="+cBlock)
			Return .F.
		EndIf
  
		Begin Sequence
			FieldPut(FieldPos("FORM"+StrZero(aProcForm[nx],2,0)), &(cBlock))
			
			// recalcula as formulas anteriores (somente as formulas)
			// este recalculo e necessario para formulas que utilizam
			// formulas ainda nao calculadas

			// o recalculo deve ser feito apos o calculo da formula atual
			cBlock := ""
			nCntLet := 0
			nCount := 0
	
			For ny := 1 to Len(aAuxCps)
				If Substr(aAuxCps[ny][1], 1, 1) # "|"
					nCntLet++
					If nCntLet > 26
						nCntLet	:= 1
						nCount++
					EndIf
          
					If Substr(aAuxCps[ny][1],1,1)=="%"
						If RepVar(@cBlock, Substr(aAuxCps[ny][1],58,60))==-1
							Alert("Erro processando o campo " + Substr(aAuxCps[ny][1],2,12)+"="+cBlock)//
							MsUnlock()
							Return .F.
						EndIf
					Else
						Loop
					EndIf								

					If nCount > 0
						&(Chr(64+nCntLet)+Chr(48+nCount)) := &(cBlock)
					Else
						&(Chr(64+nCntLet)) := &(cBlock)
					EndIf
						
					FieldPut(FieldPos("FORM"+StrZero(ny,2,0)), &(cBlock))
				EndIf
			Next		
		Recover
			ErrorBlock(bBlock)								
			Return .F.
		End Sequence
		//FieldPut(FieldPos("FORM"+StrZero(aProcForm[nx],2,0)),&(cBlock))
	Next
	
	// restaura o manipulador de erros padrao
	ErrorBlock(bBlock)
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAddPOrc³ Autor ³ Cristiano G. da Cunha ³ Data ³ 15.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria o registro no arquivo de trabalho.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PmsAddPOrc(cChave,cArquivo,nNivelAtu,nNivelMax,lRecno,aExpand,nIndent)
Local aProcForm 	:= {}
Local aArea			:= GetArea()
Local aAreaAF2		:= ZF2->(GetArea())
Local aAreaAF5		:= ZF5->(GetArea())
Local lFilho 		:= .F.
Local aRecPai		:= {} 
Local lSeekFilho 	:= .F.
Local nPosS		
Local nX := 0
Local ny := 0

Local aNodes := {}
Local nNode  := 0

Default nIndent	:= PMS_SHEET_INDENT


If ZF5->ZF5_XREV <> SZ2->Z2_NUMREV
	Return
EndIf

If nNivelMax >= Val(ZF5->ZF5_NIVEL)
	If PmsOrcUser(ZF5->ZF5_ORCAME,,ZF5->ZF5_EDT,ZF5->ZF5_EDTPAI,1,"ESTRUT")
		If Val(ZF5->ZF5_NIVEL) > nNivelAtu
			nNivelAtu := Val(ZF5->ZF5_NIVEL)
		EndIf
		RecLock(cArquivo,.T.)
		aRecPai := (cArquivo)->(GetArea())	
		For nx := 1 to Len(aAuxCps)
			If aAuxCps[nx][1]=="ZF2_DESCRI"
				If ZF5->(FieldPos(aAuxCps[nx][2])) > 0
					FieldPut(FieldPos("X"+Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),SPACE((VAL(ZF5->ZF5_NIVEL)-1)*nIndent)+ZF5->(FieldGet(FieldPos(aAuxCps[nx][2]))))
				Endif
			Else
				If Substr(aAuxCps[nx][1],1,1)=="$"
					FieldPut(FieldPos(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),&(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)+"(3,'ZF5',ZF5->(RecNo()))"))
				ElseIf Substr(aAuxCps[nx][1],1,1)=="%"
					aAdd(aProcForm,nx)
				Else
					If Substr(aAuxCps[nx][1],1,1)!="|"
						If ZF5->(FieldPos(aAuxCps[nx][2])) > 0
							FieldPut(FieldPos("X"+Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),ZF5->(FieldGet(FieldPos(aAuxCps[nx][2]))))
						Endif
					Endif
				EndIf
			EndIf
		Next
	
		dbSelectArea(cArquivo)
		(cArquivo)->CTRLNIV	:= "+"
		If lRecNo
			(cArquivo)->RECNO := ZF5->(RecNo())
			(cArquivo)->ALIAS := "ZF5"
		EndIf
		
		If !PMSPlnCalc(@aProcForm, @aAuxCps, cArquivo)
			Return	
		EndIf
	
		MsUnlock()
	EndIf		
EndIf
	
ZF2->(dbSetOrder(2))
ZF5->(dbSetOrder(2))
lSeekFilho := ZF2->(MsSeek(xFilial()+cChave)) .Or. ZF5->(MsSeek(xFilial()+cChave))

If aExpand == Nil .Or. Empty(aExpand).Or.(nPosS := aScan(aExpand,{|x| x[1]==(cArquivo)->ALIAS+(cArquivo)->XF2_TAREFA} ) > 0 .And.;
	aExpand[aScan(aExpand,{|x| x[1]==(cArquivo)->ALIAS+(cArquivo)->XF2_TAREFA} )][2]) .Or. nNivelMax<10000
	dbSelectArea("ZF2")
	dbSetOrder(2)
	MsSeek(xFilial()+cChave)
	While !Eof() .And. ZF2->ZF2_FILIAL+ZF2->ZF2_ORCAME+ZF2->ZF2_EDTPAI ==;
						xFilial("ZF2")+cChave
		If ZF2->ZF2_XREV = SZ2->Z2_NUMREV
		
			If PmsOrcUser(ZF2->ZF2_ORCAME,ZF2->ZF2_TAREFA,,ZF2->ZF2_EDTPAI,1,"ESTRUT")
				lSeekFilho 	:= .T.
				If nNivelMax >= Val(ZF2->ZF2_NIVEL)
					If Val(ZF2->ZF2_NIVEL) > nNivelAtu
						nNivelAtu := Val(ZF2->ZF2_NIVEL)
					EndIf
		
					aAdd(aNodes, {PMS_TASK,;
					              ZF2->(Recno()),;
					IIf(Empty(ZF2->ZF2_ORDEM), "000", ZF2->ZF2_ORDEM),;
					              ZF2->ZF2_TAREFA})
				EndIf
			EndIf
		EndIf
		dbSelectArea("ZF2")
		dbSkip()
	End
				
	dbSelectArea("ZF5")
	dbSetOrder(2)
	MsSeek(xFilial()+cChave)
	While !Eof() .And. ZF5->ZF5_FILIAL+ZF5->ZF5_ORCAME+ZF5->ZF5_EDTPAI ==;
						xFilial("ZF5")+cChave
		If ZF5->ZF5_XREV = SZ2->Z2_NUMREV
			lSeekFilho 	:= .T.
			If nNivelMax >= Val(ZF5->ZF5_NIVEL)
				aAdd(aNodes, {PMS_WBS,;
				              ZF5->(Recno()),;
				IIf(Empty(ZF5->ZF5_ORDEM), "000", ZF5->ZF5_ORDEM),;
				              ZF5->ZF5_EDT})
			EndIf
		EndIf

		dbSelectArea("ZF5")
		dbSkip()
	End
	
	aSort(aNodes, , , {|x, y| x[3]+x[4] < y[3]+y[4]})

	For nNode := 1 To Len(aNodes)
	
		If aNodes[nNode][1] == PMS_TASK
			// Tarefa	
			ZF2->(dbGoto(aNodes[nNode][2]))
		
			lFilho := .T.
			RecLock(cArquivo,.T.)
			For nx := 1 to Len(aAuxCps)
				If aAuxCps[nx][1]=="ZF2_DESCRI"
			   		FieldPut(FieldPos("X"+Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),SPACE((VAL(ZF2->ZF2_NIVEL)-1)*nIndent)+ZF2->(FieldGet(FieldPos(aAuxCps[nx][1]))))
				Else
					If Substr(aAuxCps[nx][1],1,1)=="$"
						FieldPut(FieldPos(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),&(Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)+"(3,'ZF2',ZF2->(RecNo()))"))
					ElseIf Substr(aAuxCps[nx][1],1,1)=="%"
						aAdd(aProcForm,nx)						
					Else
						If Substr(aAuxCps[nx][1],1,1)!="|"
							If ZF2->(FieldPos(aAuxCps[nx][1]))>0
								FieldPut(FieldPos("X"+Substr(aAuxCps[nx][1],2,Len(aAuxCps[nx][1])-1)),ZF2->(FieldGet(FieldPos(aAuxCps[nx][1]))))
							EndIf
						Endif
					EndIf
				EndIf
			Next

			dbSelectArea(cArquivo)
			If lRecNo
				(cArquivo)->RECNO := ZF2->(RecNo())
				(cArquivo)->ALIAS := "ZF2"
			EndIf
			
			If !PMSPlnCalc(@aProcForm, @aAuxCps, cArquivo)
				Return
			EndIf

			MsUnlock()
			
		Else
			// EDT
			ZF5->(dbGoto(aNodes[nNode][2]))
			
			lFilho := .T.
			PmsAddPOrc(ZF5->ZF5_ORCAME+ZF5->ZF5_EDT,cArquivo,@nNivelAtu,nNivelMax,lRecno,aExpand,nIndent)
		EndIf
	Next
	
	If lFilho .And. !Empty(aRecPai)
		RestArea(aRecPai)
		RecLock(cArquivo,.F.)
		(cArquivo)->CTRLNIV	:= "-"
		MsUnlock()
		If aExpand != Nil
			aAdd(aExpand,{(cArquivo)->ALIAS+(cArquivo)->XF2_TAREFA,.T.})
		EndIf
	EndIf
EndIf

If !lSeekFilho	.And. !Empty(aRecPai) 
	RestArea(aRecPai)
	RecLock(cArquivo,.F.)
	(cArquivo)->CTRLNIV	:= " "
	MsUnlock()
EndIf


RestArea(aAreaAF5)
RestArea(aAreaAF2)
RestArea(aArea)
Return

