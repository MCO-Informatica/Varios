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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PM100ROT  ºAutor  ³Alexandre Sousa     º Data ³  09/13/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. para adicionar botoes na tela de gerenciamento de orc. º±±
±±º          ³utilizado para criar o botao copiar orcamentos.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PM100ROT()
	

	Local a_Ret := {}
	
	Aadd(a_Ret, { "Versão","U_LPMSA03"  , 0 , 1,,.F.})
	Aadd(a_Ret, { "Copiar","U_PMSA002"  , 0 , 1,,.F.})
	Aadd(a_Ret, { "Consulta","U_CPMS002"  , 0 , 1,,.F.})
	Aadd(a_Ret, { "Followup","U_PMSA003"  , 0 , 1,,.F.})

Return a_Ret


User Function PMSA002()

	PMS100Dlg("AF1",AF1->(Recno()),3)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMS100Dlg³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Inclusao,Alteracao,Visualizacao e Exclusao       ³±±
±±³          ³ de Orcamentos.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PMSA100, SIGAPMS                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PMS100Dlg(cAlias,nReg,nOpcx)

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
Local nStack    := GetSX8Len() //incluido variavel e função para tratar a reserva do codigo de orçamento LH-ACTUAL 29/08/2016

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
PRIVATE nIndent		:= 1 //PMS_SHEET_INDENT

nstack1 := nstack  // varial recebe conteudo da nstack para poder ser tratado nas funções do fonte LH-ACTUAL 29/08/2016
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

	// utiliza a funcao axInclui para incluir o Orcamento.
	If l100Inclui
		If ExistBlock("PMA100Inc")
			If ExecBlock("PMA100Inc")
				Return						
			EndIf
		EndIf
		
		RegtoMemory("AF1")
		M->AF1_DESCRI := 'TESTE'
		

//		If lContinua := ! ( AxInclui(cAlias,nReg,nOpcx,,,,"PMS100OK()") <> 1 )
		If lContinua :=  ( ATMK001(cAlias) )

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
					MENUITEM "Reajustar Custo" ACTION (Pms100AltCus(),RestArea(aAreaAF1),Eval(bRefresh))
					MENUITEM "Recalculo do Custo" ACTION (PMS100ReCalc(),RestArea(aAreaAF1),Eval(bRefresh)) //
					MENUITEM "Recodificar" ACTION (RecodeOrc(@oTree, cArquivo), Eval(bRefresh)) //
					MENUITEM "Substituir" ACTION (Processa({|| PMS100Subs()}) , Eval(bRefresh)) //
				EndIf
			ENDMENU

//			For nZ	:=	1	To Len(oMenu2:aItems)
//				AAdd(aMenuAt,{ATA_FERRAMENTAS+"A"+STRZERO(nZ,2),1,oMenu2:aItems[nZ]:cCaption,oMenu2:aItems[nZ]:bAction,oMenu2,Nil})
//			Next
		
			MENU oMenu POPUP
				MENUITEM "Incluir EDT" ACTION (PMS100to101(3,@oTree,"1",cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Incluir Tarefa" ACTION (PMS100to101(3,@oTree,"2",cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Alterar" ACTION (PMS100to101(4,@oTree,,cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Visualizar" ACTION PMS100to101(2,@oTree,,cArquivo) //
				MENUITEM "Excluir" ACTION (PMS100to101(5,@oTree,,cArquivo,@lRefresh),If(lRefresh, (RestArea(aAreaAF1),Eval(bRefresh)), Nil)) //
				MENUITEM "Copiar EDT/Tarefa de Orcamento" ACTION (PMS100Import(oTree,cArquivo,1),RestArea(aAreaAF1),Eval(bRefresh)) //
				MENUITEM "Copiar EDT/Tarefa de Projeto" ACTION (PMS100Import(oTree,cArquivo,2),RestArea(aAreaAF1),Eval(bRefresh)) //
				MENUITEM "Importar Composicao" ACTION (If(PMS101Cmp(AF8->(RecNo()),@oTree,cArquivo),(RestArea(aAreaAF1),Eval(bRefresh)),Nil)) //
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
				MENUITEM "Visualizar" ACTION PMS100to101(2,@oTree,,cArquivo) //

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

		AAdd(aMenu, {"Atalhos",  {|| SetAtalho(aMenuAt,aMenu,.T.)}, "ATALHO", "Atalhos"})  //##
	
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
			PMS100Dlg(cAlias, nReg, nOpcx)
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK260ROT  ºAutor  ³Microsiga           º Data ³  08/20/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para transformar prospect em cliente.                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ATMK001(c_alias)

	Private aRotina			:= {}
	Private cCadastro		:= "Gerenciamento de Orçamentos"
	Private l_INCLUI		:= .F.
	Private l_ALTERA		:= .F.
	Private l_EXCLUI		:= .F.
	Private l_TERMO			:= .F.
	Private l_CANCEL		:= .F.
	Private c_EOL			:= chr(13)+chr(10)

	Private c_alias1		:= c_alias
	Private c_alias2		:= "CTT"

	Private c_cpoitem		:= "CTT_XITEM"
	Private c_chave1		:= Iif(c_alias='SA1', {"A1_COD"}, {"CTT_CUSTO"})
	Private c_chave2		:= {"AF1_ORCAME"}
	Private c_cpofil1		:= ''
	Private c_cpofil2		:= ''
	Private l_gravou		:= .F.

	AAdd(aRotina, {"Pesquisar"	, "AxPesqui"  	, 0, 1})
	AAdd(aRotina, {"Visualizar"	, "U_FGEN057a"	, 0, 2})
	AAdd(aRotina, {"Incluir"	, "U_FGEN057a"	, 0, 3})
	AAdd(aRotina, {"Alterar"	, "U_FGEN057a"	, 0, 4})
	AAdd(aRotina, {"Excluir"	, "U_FGEN057a"	, 0, 5})

	dbSelectArea(c_alias1)
	DbSetOrder (1)

	c_ret := FGEN057a(c_alias1, (c_alias1)->(Recno()), 3)

//	mBrowse( 6, 1,22,75,c_alias1,,,,,2)

	If c_alias = 'SA1'
		If l_gravou
			RecLock('SUS', .F.)
			SUS->US_STATUS	:= '6'
			SUS->US_CODCLI 	:= SA1->A1_COD
			SUS->US_LOJACLI	:= SA1->A1_LOJA
			SUS->US_DTCONV	:= dDataBase
			MsUnLock()
		EndIf
	EndIf


Return c_ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGEN057a  ºAutor  ³Alexandre Sousa     º Data ³  26/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chamada das funcoes responsaveis.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FGEN057a(cAlias, nRecno, nOpc)

	c_ret := Manutcon(cAlias, nRecno, nOpc)

Return c_ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Manutcon  ºAutor  ³Alexandre Sousa     º Data ³  26/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chamada das rotinas e chamada da Mod 2.                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Manutcon(cAlias, nRecno, nOpc, c_item2alias)

	Local cLinOK   := "AllwaysTrue"
	Local cTudoOK  := "AllwaysTrue"
	Local nOpcE    := nOpc
	Local nOpcG    := nOpc
	Local cFieldOK := "AllwaysTrue"
	Local lVirtual := .T.
	Local nLinhas  := 99
	Local nFreeze  := 0
	Local lRet     := .T.
	Local oCt_Item := "+"+c_cpoitem

	Private aAlter  		:= {}
	Private aCols			:= {}
	Private aHeader			:= {}
	Private aCpoEnchoice	:= {}
	Private aAltEnchoice	:= {}
	Private aAlt			:= {}
	Private c_Alterados		:= ''

	RegToMemory(c_alias1, (nOpc==3))
	RegToMemory(c_alias2, (nOpc==3))

	If nOpc == 3
		l_INCLUI := .T.
		If c_alias1 = 'SA1'
			M->&(c_chave1[1]) := U_FGEN003(c_alias1, c_chave1[1])
		Else
			M->&(c_chave1[1]) := U_AFAT001()
		EndIf
	ElseIf nOpc == 4
		l_ALTERA := .T.
	ElseIf nOpc == 5
		l_EXCLUI := .T.
	EndIf
	
	CriaHeader()
	CriaCols(nOpc,oCt_Item)
	
	If c_alias1 = 'SA1'
		M->A1_NOME := SUS->US_NOME
		M->A1_NREDUZ := SUS->US_NREDUZ
		M->A1_END := SUS->US_END
		M->A1_TIPO  := SUS->US_TIPO
		M->A1_NUN := SUS->US_MUN
		M->A1_BAIRRO := SUS->US_BAIRRO
		M->A1_EST := SUS->US_EST
	Else
		M->AF1_DESCRI	:= AF1->AF1_DESCRI
		M->AF1_CLIENT 	:= AF1->AF1_CLIENT
		M->AF1_LOJA		:= AF1->AF1_LOJA
		M->AF1_XPROSP	:= AF1->AF1_XPROSP
		M->AF1_XLOJAP	:= AF1->AF1_XLOJAP
		M->AF1_XNOMEC	:= AF1->AF1_XNOMEC

		M->AF1_VALID := AF1->AF1_VALID
		M->AF1_TPORC  := AF1->AF1_TPORC
		M->AF1_NMAX  := AF1->AF1_NMAX
		M->AF1_NMAXF3  := AF1->AF1_NMAXF3
		M->AF1_TRUNCA  := AF1->AF1_TRUNCA
		M->AF1_BDI  := AF1->AF1_BDI
		M->AF1_VALBDI  := AF1->AF1_VALBDI
		M->AF1_BDIPAD  := AF1->AF1_BDIPAD
		M->AF1_TIPO  := AF1->AF1_TIPO
		M->AF1_CODORC  := AF1->AF1_CODORC
		M->AF1_RECALC  := AF1->AF1_RECALC
		M->AF1_AUTCUS  := AF1->AF1_AUTCUS
		M->AF1_CTRUSR  := AF1->AF1_CTRUSR
		M->AF1_XMIDIA  := AF1->AF1_XMIDIA
	  //	M->AF1_XVEND  := AF1->AF1_XVEND           comentado para nao copiar o codigo do vendedor ao fazer a copia do orçamento !!!! - luiz henrique 06/02/2015
		M->AF1_XDTPRP  := AF1->AF1_XDTPRP
		M->AF1_XENDOB  := AF1->AF1_XENDOB
 		M->AF1_XBROBR  := AF1->AF1_XBROBR
  		M->AF1_XMUNO  := AF1->AF1_XMUNO
		M->AF1_XCEPOB  := AF1->AF1_XCEPOB
 		M->AF1_XESTOB  := AF1->AF1_XESTOB
  		M->AF1_XCOMPO  := AF1->AF1_XCOMPO
		M->AF1_XREFOB  := AF1->AF1_XREFOB
	EndIf
	

	lRet := FGEN004(cCadastro,c_alias1,c_alias2,aCpoEnchoice,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aAlter,oCt_Item)

	If lRet
		If nOpc == 3  
           If MsgYesNo("Confirma a gravação dos dados?", cCadastro)
              Processa({||GrvDados()}, cCadastro, "Gravando os dados, aguarde...")
              l_gravou := .T.
           EndIf
		ElseIf nOpc == 4
			If MsgYesNo("Confirma a alteração dos dados?", cCadastro)
				Processa({||AltDados()}, cCadastro, "Alterando os dados, aguarde...")
			EndIf
		ElseIf nOpc == 5
			If MsgYesNo("Confirma a exclusão dos dados?", cCadastro)
				Processa({||ExcDados()}, cCadastro, "Excluindo os dados, aguarde...")
			EndIf
		EndIf
	EndIf
	l_INCLUI	:= .F.
	l_EXCLUI	:= .F.
	l_ALTERA	:= .F.

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaHeaderºAutor  ³Alexandre Sousa     º Data ³  26/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega array para Mod2                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaHeader()

	aHeader      := {}
	aCpoEnchoice := {}
	aAltEnchoice := {}
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(c_alias2)
	
	c_cpofil2 := SX3->X3_Campo

	While !SX3->(EOF()) .And. SX3->X3_Arquivo == c_alias2
	
	   If X3Uso(SX3->X3_Usado)    .And.;
	   	      cNivel >= SX3->X3_Nivel
	
	      AAdd(aHeader, {Trim(SX3->X3_Titulo),;
	                     SX3->X3_Campo       ,;
	                     SX3->X3_Picture     ,;
	                     SX3->X3_Tamanho     ,;
	                     SX3->X3_Decimal     ,;
	                     SX3->X3_Valid       ,;
	                     SX3->X3_Usado       ,;
	                     SX3->X3_Tipo        ,;
	                     SX3->X3_Arquivo     ,;
	                     SX3->X3_Context})
	      Aadd(aAlter, SX3->X3_Campo)
	   EndIf
	   SX3->(dbSkip())
	
	End
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(c_alias1)
	
	c_cpofil1 := SX3->X3_Campo

	While !SX3->(EOF()) .And. SX3->X3_Arquivo == c_alias1
	   If X3Uso(SX3->X3_Usado) .And. cNivel >= SX3->X3_Nivel
	      // Campos da Enchoice.
	      AAdd(aCpoEnchoice, X3_Campo)
	      // Campos da Enchoice que podem ser editadas.
	      // Se tiver algum campo que nao deve ser editado, nao incluir aqui.
	      AAdd(aAltEnchoice, X3_Campo)
	   EndIf
	   SX3->(dbSkip())
	End

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGCS701   ºAutor  ³Alexandre Sousa     º Data ³  26/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria um array para o Modelo2.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaCols(nOpc,oTpItem)

	Local nQtdCpo := 0
	Local i       := 0
	Local nCols   := 0            
	Local cCpoItem:= Alltrim(Substr(oTpItem,2,10))
	Local cItem   := '' 
	
	Local c_chv1 := '' 
	Local c_chv2 := '' 
	
	aeval(c_chave1, {|x| c_chv1+=AllTrim(x)+"+"})
	aeval(c_chave2, {|x| c_chv2+=AllTrim(x)+"+"})

	c_chv1 := SubStr(c_chv1, 1, len(c_chv1)-1)
	c_chv2 := SubStr(c_chv2, 1, len(c_chv2)-1)
	
	nQtdCpo := Len(aHeader)
	aCols   := {}
	aAlt    := {}
	
	If nOpc == 3       // Inclusao.
	
	   AAdd(aCols, Array(nQtdCpo+1))
	
	   For i := 1 To nQtdCpo
	       aCols[1][i] := CriaVar(aHeader[i][2]) 
	   Next
	   aCols[1][nQtdCpo+1] := .F. 
	 Else
	
	   dbSelectArea(c_alias2)
	   DbSetOrder(1)
	   dbSeek(xFilial(c_alias2) + (c_alias1)->&(c_chv1))
	
	   While !EOF() .And. (c_alias1)->&(c_cpofil1) == xFilial(c_alias2) .And. (c_alias2)->&(c_chv2) == (c_alias1)->&(c_chv1)
	
	      AAdd(aCols, Array(nQtdCpo+1))
	      nCols++
	
	      For i := 1 To nQtdCpo
	          If aHeader[i][10] <> "V"
	             aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))
	           Else
	             aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
	          EndIf
	      Next
	
	      aCols[nCols][nQtdCpo+1] := .F.
	
	      AAdd(aAlt, Recno())
	
	      dbSelectArea(c_alias2)
	      dbSkip()
	
	   End
	
	EndIf
 
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGCS701   ºAutor  ³Alexandre Sousa     º Data ³  26/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os dados do contrato.                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvDados()

	Local bCampo := {|nField| Field(nField)}
	Local i      := 0
	Local y      := 0
	Local nItem  := 0

	ProcRegua(Len(aCols) + FCount())
	
	// Grava o registro da tabela Pai, obtendo o valor de cada campo
	// a partir da var. de memoria correspondente.
	dbSelectArea(c_alias1)
	RecLock(c_alias1, .T.)
	For i := 1 To FCount()
	    IncProc()
	    If "FILIAL" $ FieldName(i)
	       FieldPut(i, xFilial(c_alias1))
	     Else
	       FieldPut(i, M->&(Eval(bCampo,i)))
	    EndIf
	Next
	MSUnlock()
	
	// Grava os registros da tabela Filho.
	

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltDados  ºAutor  ³Alexandre Sousa     º Data ³  27/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera os dados do contrato.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AltDados()

	Local i      := 0
	Local y      := 0
	
	ProcRegua(Len(aCols) + FCount())
	
	dbSelectArea(c_alias1)
	RecLock(c_alias1, .F.)
	
	For i := 1 To FCount()
	    IncProc()
	    If "FILIAL" $ FieldName(i)
	       FieldPut(i, xFilial(c_alias1))
	     Else
	       FieldPut(i, M->&(fieldname(i)))
	    EndIf
	Next
	MSUnlock()
	    
	n_posrec := 0
	For i := 1 To Len(aCols)
		
		If i <= Len(aAlt)
			DbSelectArea(c_alias2)
			&(c_alias2+'->(DbGoto('+STR(aAlt[i])+'))')
			n_posrec := Ascan(aAlt, &(c_alias2+'->('+STR(Recno())+')'))
		EndIf
		
		If n_posrec > 0
			dbGoTo(aAlt[i])
			RecLock(c_alias2, .F.)
			If aCols[i][Len(aHeader)+1]
				dbDelete()
			Else
				For y := 1 To Len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
				Next
			EndIf
			MSUnlock()
		Else
	       If !aCols[i][Len(aHeader)+1]
	          RecLock(c_alias2, .T.)
	          For y := 1 To Len(aHeader)
			    If "FILIAL" $ FieldName(i)
			       FieldPut(i, xFilial(c_alias2))
			     Else
			       FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			    EndIf
	          Next
		       For j := 1 to len(c_chave2)
		       		(c_alias2)->&(c_chave2[j]) := (c_alias1)->&(c_chave1[j])
		       Next
	          MSUnlock()
	       EndIf
	    EndIf
	    n_posrec := 0
	Next

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExcDados  ºAutor  ³Alexandre Sousa     º Data ³  27/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui o registro nas duas tabelas.                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExcDados()
    
	Local c_chv1 := ''
	Local c_chv2 := ''
	
	aeval(c_chave1, {|x| c_chv1+=AllTrim(x)+"+"})
	aeval(c_chave2, {|x| c_chv2+=AllTrim(x)+"+"})

	c_chv1 := SubStr(c_chv1, 1, len(c_chv1)-1)
	c_chv2 := SubStr(c_chv2, 1, len(c_chv2)-1)
	
	ProcRegua(Len(aCols)+1)
	
	dbSelectArea(c_alias2)
	DbSetOrder(1)
	dbSeek(xFilial(c_alias2) + (c_alias1)->&(c_chv1))
	
	While !EOF() .And. (c_alias1)->&(c_cpofil1) == xFilial(c_alias2) .And. (c_alias2)->&(c_chv2) == (c_alias1)->&(c_chv1)
	   IncProc()
	   RecLock(c_alias2, .F.)
	   dbDelete()
	   MSUnlock()
	   dbSkip()
	End
	
	dbSelectArea(c_alias1)
	DbSetOrder(1)
	IncProc()
	RecLock(c_alias1, .F.)
	dbDelete()
	MSUnlock()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGEN004   ºAutor  ³Alexandre Martins   º Data ³  03/24/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Generica Modelo3, com inclusao de mais parametros.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico OmniLink.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FGEN004(cTitulo,cAlias1       ,cAlias2   ,aMyEncho    ,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aAlter,c_item, aButtons)

	Local aPosObj    	:= {} 
	Local aObjects   	:= {}                        
	Local aSize      	:= MsAdvSize()
	Local lRet, nOpca 	:= 0,cSaveMenuh,nReg:=(cAlias1)->(Recno())
	local oDlg

	Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
							bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
	Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

	c_item := If(c_item==Nil,"", c_item)
	nOpcE := If(nOpcE==Nil,3,nOpcE)
	nOpcG := If(nOpcG==Nil,3,nOpcG)
	lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
	nLinhas:=Iif(nLinhas==Nil,99,nLinhas)

	oDlg := TDialog():New(aSize[7],00,aSize[6]+aSize[7]-145,aSize[5],OemToAnsi(cTitulo),,,,,,,,oMainWnd,.T.)

	aObjects := {}
	AAdd( aObjects, { 100, 100, .T., .t. } )
//	AAdd( aObjects, { 30, 30, .T., .t. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	EnChoice(cAlias1,nReg,nOpcE,,,,aMyEncho,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},aAltEnchoice,3,,,,,,lVirtual)
//	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcG,cLinOk,cTudoOk,"+"+c_item,.T.,aAlter,,,nLinhas,cFieldOk)
	
	If !Empty(c_item) .and. nOpcE == 3
		a_Area := SX3->(GetArea())
		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek(SubStr(c_item,2,10))
		aCols[01,01] := Replicate("0", SX3->X3_TAMANHO-1)+"1"
		RestArea(a_Area)
	EndIf

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End())},{||oDlg:End()},,aButtons)

	lRet:=(nOpca==1)    
	//incluido bloco abaixo para tratar os codigos sequenciais na rotina apcfg110 controle das numeracoes LH-ACTUAL 29/08/16
		 if lRet     //se verdadeiro confirma o registro reservado e faz a inclusao 
      		While GetSX8Len() > nStack1   
			ConfirmSx8()
	        EndDo
    	 else                  //se falso exclui o registro reservado
	   		While GetSX8Len() > nStack1   
			RollBackSX8()
	  		EndDo
   		endif    
   	// fim do bloco - LH-ACTUAL  29/08/16 	
Return lRet
