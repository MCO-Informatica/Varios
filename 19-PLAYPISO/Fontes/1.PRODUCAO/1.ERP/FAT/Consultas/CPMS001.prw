#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOPCONN.ch"

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

// INCLUIDO PARA TRADUÇÃO DE PORTUGAL

STATIC __lBlind		:= IsBlind()


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
±±ºPrograma  ³CPMS001   ºAutor  ³Alexandre Sousa     º Data ³  08/25/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta personalisada de clientes e prospects.             º±±
±±º          ³Facilitador para utilizacao do comercial.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico clientes ACTUAL TREND - www.actualtrend.com.br   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CPMS001()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define variaveis...                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL _oDlgPesPro
	LOCAL _oTipoPes
	LOCAL _nOpca      := 0
	LOCAL _aVetPad    := { {"ENABLE","","","","","","","","","","",""} }
	LOCAL _oBrowPro
	//LOCAL _bRefresh   := { || If(!Empty(_cChave),AT42Pesquisa(AllTrim(_cChave),Subs(_cTipoPes,1,1),_lChkChk,_lChkAtivo,_aBrowPro,_aVetPad,_oBrowPro,lBloqueia,_lChkCod),.T.), If( Empty(_aBrowPro[1,2]) .And. !Empty(_cChave),.F.,.T. )  }
	LOCAL _bRefresh   
	LOCAL _cValid     := "{|| Eval(_bRefresh) }"
	//LOCAL _bOK        := { || IF(!Empty(_cChave),(_nLin := _oBrowPro:nAt, _nOpca := 1,_oDlgPesPro:End()),Help("",1,"PLSMCON")) }
	LOCAL _bOK        := { ||(FECHABRW(_oBrowPro, nat), _oDlgPesPro:End()) }
	LOCAL _bCanc      := { || _nOpca := 3,_oDlgPesPro:End() }
	LOCAL _oGetChave
	LOCAL _aTipoPes   := {}
	LOCAL _cTipoPes   := ""
	LOCAL _oChkChk
	LOCAL _lChkChk    := .F.
	LOCAL _oChkCod
	LOCAL _oChkBlo                                    	
	LOCAL _lChkAtivo  :=  .F.//
	LOCAL _nLin       := 1
	LOCAL _aButtons 	 := {}
	LOCAL _oBmp	 	 := Nil
	
	Private NAT := 1
	
	Private _cChave     := Iif(EMPTY(M->AF1_CLIENTE), ALLTRIM(M->AF1_XPROSP), alltrim(M->AF1_CLIENT)) + Space(100)
	Private _lChkCod    := Iif(Empty(_cChave), .F., .T.)
	_bRefresh   := { || AT42Pesquisa(AllTrim(_cChave),Subs(_cTipoPes,1,1),_lChkChk,_lChkAtivo,_aBrowPro,_aVetPad,_oBrowPro,lBloqueia,_lChkCod), If(Empty(_aBrowPro[1,2]) .And. !Empty(_cChave),.F.,.T. )  }

	PRIVATE cCadastro	:= "Gerenciamento de Projetos"
	
	PRIVATE aMemos  := {{"AF8_CODMEM","AF8_OBS"}}
	PRIVATE aCores  := PmsAF8Color()
	PRIVATE nDlgPln := PMS_VIEW_TREE

	Set Key VK_F12 To FAtiva()

	PRIVATE _aBrowPro   := {}

	lBloqueia:= .F.
	
	PRIVATE aOpcoes  := {}
	
	_aBrowPro := aClone(_aVetPad)
	
	
	_cChamada := Upper(ReadVar())
	
	_aTipoPes   := {	"1-Todos",;
			OemToAnsi("2-Clientes"),;     
			OemToAnsi("3-Prospects")}
	
	// Condicao para filtrar a Pesquisa
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Botoes da Barra Superior            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd(_aButtons,{"ANALITICO"  ,{|| FG42Visual(_aBrowPro,_oBrowPro) }, "Visualiza Cadastro da Entidade", "Visual"} )
	AAdd(_aButtons,{"HISTORIC"  	 ,{|| VerPrjs(_aBrowPro,_oBrowPro) }, "Visualiza os orçamentos anteriores da Entidade", "Visual"} )
	AAdd(_aButtons,{"NOVACELULA"  	 ,{|| NovoPrp(_aBrowPro,_oBrowPro) }, "Incluir novo PROSPECT", "Novo"} )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define dialogo...                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG _oDlgPesPro TITLE "Pesquisa de Clientes/Prospects" FROM 008.2,000 TO 26.5,100 OF GetWndDefault()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta objeto que recebera o a chave de pesquisa  ...                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oGetChave := TGet():New(020,103,{ | U | IF( PCOUNT() == 0, _cChave, _cChave := U ) },_oDlgPesPro,210,008 ,"@!S30",&_cValid,nil,nil,nil,nil,nil,.T.,nil,.F.,nil,.F.,nil,nil,.F.,nil,nil,_cChave)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Browse...                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oBrowPro := TcBrowse():New( 043, 008, 378, 078,,,, _oDlgPesPro,,,,,,,,,,,, .F.,, .T.,, .F., )
	
	_oBrowPro:AddColumn(TcColumn():New("",nil,;
	         nil,nil,nil,nil,015,.T.,.F.,nil,nil,nil,.T.,nil))
	         _oBrowPro:ACOLUMNS[1]:BDATA     := { || _aBrowPro[_oBrowPro:nAt,1] }
	_oBrowPro:AddColumn(TcColumn():New("Entidade",nil,;
	         nil,nil,nil,nil,050,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrowPro:ACOLUMNS[2]:BDATA     := { || _aBrowPro[_oBrowPro:nAt,2] }
	_oBrowPro:AddColumn(TcColumn():New(OemToAnsi("Codigo"),nil,;
	         nil,nil,nil,nil,160,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrowPro:ACOLUMNS[3]:BDATA     := { || _aBrowPro[_oBrowPro:nAt,3] }
	_oBrowPro:AddColumn(TcColumn():New("Loja",nil,;
	         nil,nil,nil,nil,030,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrowPro:ACOLUMNS[4]:BDATA     := { || _aBrowPro[_oBrowPro:nAt,4] }
	_oBrowPro:AddColumn(TcColumn():New(OemToAnsi("Nome"),nil,;
	         nil,nil,nil,nil,100,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrowPro:ACOLUMNS[5]:BDATA     := { || _aBrowPro[_oBrowPro:nAt,5] }
	
	@ 020,008 COMBOBOX _oTipoPes  Var _cTipoPes 	ITEMS _aTipoPes 	SIZE 090,010 OF _oDlgPesPro PIXEL COLOR CLR_HBLUE
	@ 018,319 CHECKBOX _oChkCod   Var _lChkCod 		PROMPT OemToAnsi("Pesquisar Por Código") 	PIXEL SIZE 080, 010 OF _oDlgPesPro
//	@ 030,319  CHECKBOX _oChkChk   Var _lChkChk 		PROMPT "Pesquisar Palavra Chave" 	PIXEL SIZE 080, 010 OF _oDlgPesPro
	
	
	@ 126,010 BitMap _oBmp ResName "BR_VERDE" 	OF _oDlgPesPro Size 10,10 NoBorder When .F. Pixel 
	@ 126,020 SAY OemToAnsi("Cliente") OF _oDlgPesPro PIXEL 
	
	@ 126,120 BitMap _oBmp ResName "BR_VERMELHO" 	OF _oDlgPesPro Size 10,10 NoBorder When .F. Pixel 
	@ 126,130 SAY OemToAnsi("Prospect") OF _oDlgPesPro PIXEL 
	
	_oBrowPro:SetArray(_aBrowPro)
	_oBrowPro:BLDBLCLICK := _bOK
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa o Dialogo...                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AT42Pesquisa(AllTrim(_cChave),Subs('1',1,1),.F.,.F.,_aBrowPro,{ {"ENABLE","","","","","","","","","","",""} },_oBrowPro,.F.,_lChkCod)	
	
	ACTIVATE MSDIALOG _oDlgPesPro CENTERED ON INIT Eval({ || EnChoiceBar(_oDlgPesPro,_bOK,_bCanc,.F.,_aButtons) })
	
	If _nOpca == 1
	   If !Empty(_aBrowPro[_nLin,2])
	      SB1->(DbGoTo(_aBrowPro[_nLin,06]))
	   Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorno da Funcao...                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AT42PesquisaºAutor³Eduardi Barbosa     º Data ³  23/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de pesquisa de Produtos na Base de dados             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OmniLink                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AT42Pesquisa(_cChave,_cTipoPes,_lChkChk,_lChkAtivo,_aBrowPro,_aVetPad,_oBrowPro,lBloqueia,_lChkCod)
LOCAL cSQL      := ""
LOCAL cRetBA1
LOCAL cDataBase := AllTrim(TCGetDB())
LOCAL cNomeEmp  := ""
LOCAL cNomeUsr  := ""
LOCAL nFor   
LOCAL lTroca    := .F.                       
Local oCond		 := Nil
Local _oFlag

Local oSimAf	 := LoadBitmap(GetResources(),"BR_VERDE")
Local oNaoAf	 := LoadBitmap(GetResources(),"BR_VERMELHO")

If Empty(_cChave)
	Return(.T.)
EndIf

If '"' $ _cChave .Or. ;
   "'" $ _cChave
   Aviso( "Caracter Invalido", ;
          "Existem caracteres invalidos em sua pesquisa.",;
          { "Ok" }, 2 ) 	                                                                    
   Return(.F.)
Endif   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa resultado...                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aBrowPro := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua busca...                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If substr(_cTipoPes,1,1) = '1'
	cSQL := " SELECT 	'SA1' as ENTIDADE, "
	cSQL += " 			A1_COD as CODIGO, "
	cSQL += " 			A1_LOJA as LOJA, "
	cSQL += " 			 A1_NOME as NOME, "
	cSQL += " 			SA1.R_E_C_N_O_	AS REC "                     	
	cSQL += " FROM " + RetSQLName("SA1") + " SA1 "
	cSQL += " WHERE    A1_FILIAL ='"+xFilial("SA1")+"' " 
	cSQL += " and      " + Iif(_lChkCod, "A1_COD  LIKE '%"+AllTrim(_cChave)+"%'  ", "A1_NOME  LIKE '%"+AllTrim(_cChave)+"%'")
	cSQL += " and      SA1.D_E_L_E_T_=' ' and A1_MSBLQL <> '1'"
	cSQL += " union all "
	cSQL += " SELECT 	'SUS' as ENTIDADE, "
	cSQL += " 			US_COD AS CODIGO, "
	cSQL += " 			US_LOJA AS LOJA, "
	cSQL += " 			 US_NOME AS NOME, "
	cSQL += " 			SUS.R_E_C_N_O_	AS REC "                     	
	cSQL += " FROM " + RetSQLName("SUS") + " SUS "
	cSQL += " WHERE    US_FILIAL ='"+xFilial("SUS")+"' " 
	cSQL += " and      " + Iif(_lChkCod, "US_COD  LIKE '%"+AllTrim(_cChave)+"%'  ", "US_NOME  LIKE '%"+AllTrim(_cChave)+"%'")
	cSQL += " and      SUS.D_E_L_E_T_=' ' "
	cSQL += " ORDER BY NOME "

ElseIf substr(_cTipoPes,1,1) = '2'
	cSQL := " SELECT 	'SA1' as ENTIDADE, "
	cSQL += " 			A1_COD as CODIGO, "
	cSQL += " 			A1_LOJA as LOJA, "
	cSQL += " 			 A1_NOME as NOME, "
	cSQL += " 			SA1.R_E_C_N_O_	AS REC "                     	
	cSQL += " FROM " + RetSQLName("SA1") + " SA1 "
	cSQL += " WHERE    A1_FILIAL ='"+xFilial("SA1")+"' " 
	cSQL += " and      " + Iif(_lChkCod, "A1_COD  LIKE '%"+AllTrim(_cChave)+"%'  ", "A1_NOME  LIKE '%"+AllTrim(_cChave)+"%'")
	cSQL += " and      SA1.D_E_L_E_T_=' ' and A1_MSBLQL <> '1' "
	cSQL += " ORDER BY A1_NOME "
ElseIf substr(_cTipoPes,1,1) = '3'
	cSQL := " SELECT 	'SUS' as ENTIDADE, "
	cSQL += " 			US_COD AS CODIGO, "
	cSQL += " 			US_LOJA AS LOJA, "
	cSQL += " 			 US_NOME AS NOME, "
	cSQL += " 			SUS.R_E_C_N_O_	AS REC "                     	
	cSQL += " FROM " + RetSQLName("SUS") + " SUS "
	cSQL += " WHERE    US_FILIAL ='"+xFilial("SUS")+"' " 
	cSQL += " and      " + Iif(_lChkCod, "US_COD  LIKE '%"+AllTrim(_cChave)+"%'  ", "US_NOME  LIKE '%"+AllTrim(_cChave)+"%'")
	cSQL += " and      SUS.D_E_L_E_T_=' ' "
	cSQL += " ORDER BY US_NOME "
EndIf

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
EndIf

MemoWrite("PesqPro.sql",cSQL)
TCQUERY cSQL New ALIAS "QRY"

DbSelectArea("QRY")
DbGoTop()

While QRY->(!EOF())

	If QRY->ENTIDADE = 'SA1'
		_oFlag := oSimAF
	Else
		_oFlag := oNaoAf
	EndIf
	aadd(_aBrowPro,{	_oFlag,;
						QRY->ENTIDADE    ,;
						QRY->CODIGO    ,;
						QRY->LOJA ,;
						QRY->NOME     ,;
						QRY->REC })
	QRY->(DbSkip())
EndDo

DbSelectArea("QRY")
DbCloseArea("QRY")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Testa resultado da pesquisa...                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(_aBrowPro) == 0
   _aBrowPro := aClone(_aVetPad)   
Endif       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza browse...                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_oBrowPro:SetArray(_aBrowPro)
_oBrowPro:Refresh() 
_oBrowPro:SetFocus()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Rotina...                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FG42VisualºAutor  ³Jonas L. Souza Jr   º Data ³  08/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualiza cadastro do Produto                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OmniLink                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FG42Visual(_aBrowPro,_oBrowPro)
Local _aArea := GetArea()

If _aBrowPro[_oBrowPro:nAt,02] = 'SA1'
	SA1->(DbGoTo(_aBrowPro[_oBrowPro:nAt,06]))
	AxVisual("SA1",SA1->(RECNO()), 2)
ElseIf _aBrowPro[_oBrowPro:nAt,02] = 'SUS'
	SUS->(DbGoTo(_aBrowPro[_oBrowPro:nAt,06]))
	AxVisual("SUS",SUS->(RECNO()), 2)
Else
	ApMsgStop(OemToAnsi("Selecione um registro válido!"),"Consulta de Entidade")
Endif

RestArea(_aArea)
Return


Static Function VerPrjs(_aBrowPro,_oBrowPro)

	Local c_wherf1 := ''
	Local c_wherf8 := ''

	If _aBrowPro[_oBrowPro:nAt,02] = 'SA1'
		SA1->(DbGoTo(_aBrowPro[_oBrowPro:nAt,06]))  
		c_wherf1 := "where (AF1_CLIENT = '"+SA1->A1_COD+"' and AF1_LOJA = '"+SA1->A1_LOJA+"') or AF1_CLIENT+AF1_LOJA in (select A1_COD+A1_LOJA from SA1010 where A1_CGC = '"+SA1->A1_CGC+"') "
		c_wherf8 := "where (AF8_CLIENT = '"+SA1->A1_COD+"' and AF8_LOJA = '"+SA1->A1_LOJA+"') or AF8_CLIENT+AF8_LOJA in (select A1_COD+A1_LOJA from SA1010 where A1_CGC = '"+SA1->A1_CGC+"') "
	ElseIf _aBrowPro[_oBrowPro:nAt,02] = 'SUS'
		SUS->(DbGoTo(_aBrowPro[_oBrowPro:nAt,06]))
		c_wherf1 := "where AF1_XPROSP = '"+SUS->US_COD+"' and AF1_XLOJAP = '"+SUS->US_LOJA+"' "
		c_wherf8 := "where AF8_CLIENT = '"+SUS->US_COD+"' and AF8_LOJA = '"+SUS->US_LOJA+"' "
	Else
		ApMsgStop(OemToAnsi("Selecione um registro válido!"),"Consulta de Entidade")
		Return
	Endif

    c_query := " select 'AF1' as ENTIDADE, AF1_FILIAL as FILIAL, AF1_ORCAME as NUM, convert(varchar(10), convert(datetime, AF1_DATA), 103)  as DATA , AF1_DESCRI as DESCR, AF1_FASE as STATUS, AF1_XOBRA as OBRA "
    c_query += " from AF1010  "
    c_query += c_wherf1 //" where  AF1_CLIENT = '00000	1'  "
    c_query += " and    D_E_L_E_T_ <> '*'  "
    c_query += " UNION ALL "

    c_query += " select 'AF8' as ENTIDADE, AF8_FILIAL as FILIAL, AF8_PROJET as NUM, convert(varchar(10), convert(datetime, AF8_DATA), 103)  as DATA, AF8_DESCRI as DESCR, AF8_FASE as STATUS, AF8_CODOBR as OBRA  "
    c_query += " from AF8010 "
    c_query += c_wherf8 //" where  AF8_CLIENT = '000001' "
    c_query += " and    D_E_L_E_T_ <> '*' "

	FGEN008(c_query , {{"", "Filial","Numero", "Data", "Descrição", "Status", "Obra"}, {"OBRA", "FILIAL","NUM", "DATA", "DESCR", "STATUS", "OBRA"}}, "Historico da entidade")
	
Return

Static Function fechabrw(_oBrowPro, nAt)

	If _aBrowPro[_oBrowPro:nAt,02] = 'SA1'
		M->AF1_CLIENT 	:= _aBrowPro[_oBrowPro:nAt,03]
		M->AF1_LOJA		:= _aBrowPro[_oBrowPro:nAt,04]
		M->AF1_XPROSP	:= ''
		M->AF1_XLOJAP	:= ''
		M->AF1_XNOMEC	:= _aBrowPro[_oBrowPro:nAt,05]
	Else
		M->AF1_CLIENT 	:= ''
		M->AF1_LOJA		:= ''
		M->AF1_XPROSP	:= _aBrowPro[_oBrowPro:nAt,03]
		M->AF1_XLOJAP	:= _aBrowPro[_oBrowPro:nAt,04]
		M->AF1_XNOMEC	:= _aBrowPro[_oBrowPro:nAt,05]
	EndIf
	_nLin := _oBrowPro:nAt
	_nOpca := 1
	
Return


Static Function NovoPrp(_aBrowPro,_oBrowPro)

	AxInclui('SUS', SUS->(Recno()), 3)
	_cChave     := alltrim(SUS->US_COD) + Space(100)
	_lChkCod    := Iif(Empty(_cChave), .F., .T.)
	
	AT42Pesquisa(AllTrim(_cChave),Subs('1',1,1),.F.,.F.,_aBrowPro,{ {"ENABLE","","","","","","","","","","",""} },_oBrowPro,.F.,_lChkCod)	

Return

Static Function FGEN008(c_Query, a_campos, c_tit, n_pos)

	Local aVetor   := {}
	Local cTitulo  := Iif( c_tit = Nil, "Título", c_tit)
	Local nPos		:= Iif(n_pos = Nil, 1, n_pos)
	Local n_x		:= 0
	Local c_Lst		:= ''       
	
	Local _oFlag
	Local oSimAf	 := LoadBitmap(GetResources(),"BR_VERDE")
	Local oNaoAf	 := LoadBitmap(GetResources(),"")  
	
	LOCAL _oBmp	 	 := Nil
	LOCAL _oDlgPesPro
	
//	Local c_Query := "select distinct EA_FILIAL, EA_NUMBOR from "+RetSqlName("SEA")+" where EA_FILIAL = '"+xFilial("SEA")+"' EA_CART = 'R' and D_E_L_E_T_ <> '*'"
//	Local a_campos := {{"Filial", "Bordero" }, {"EA_FILIAL", "EA_NUMBOR"}}
//	Local c_tit := "Consulta de Borderos"

	Private oDlg	:= Nil
	Private oLbx	:= Nil
	Private c_Ret	:= ''
	Private aSalvAmb := GetArea()

 	If Select("QRX") > 0
		DbSelectArea("QRX")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRX"

	//+-------------------------------------+
	//| Carrega o vetor conforme a condicao | 
	//+-------------------------------------+     
	
	DbSelectArea("QRX")
	DbGoTop()

	While QRX->(!EOF())
		aAdd(aVetor, Array(len(a_campos[2])))
		
		If QRX->OBRA <> ' '
			_oFlag := oSimAF	
	  	Else
			_oFlag := oNaoAf
		EndIf
		
		For n_x := 1 to len(a_campos[2])
			if n_x = 1
				aVetor[len(aVetor),n_x] := _oFlag
			else		
				aVetor[len(aVetor),n_x] := &("QRX->"+a_campos[2,n_x])  
			EndIf	
		Next  
		
		QRX->(dbSkip())
	End

	If Len( aVetor ) == 0
	   Aviso( cTitulo, "Nao existe dados para a consulta", {"Ok"} )
	   Return
	Endif

	//+-----------------------------------------------+
	//| Limitado a dez colunas                        |
	//+-----------------------------------------------+
	c_A := IIf(len(a_campos[1])>=1,a_campos[1,1],'' )
	c_B := IIf(len(a_campos[1])>=2,a_campos[1,2],'' )
	c_C := IIf(len(a_campos[1])>=3,a_campos[1,3],'' )
	c_D := IIf(len(a_campos[1])>=4,a_campos[1,4],'' )
	c_E := IIf(len(a_campos[1])>=5,a_campos[1,5],'' )
	c_F := IIf(len(a_campos[1])>=6,a_campos[1,6],'' )
	c_G := IIf(len(a_campos[1])>=7,a_campos[1,7],'' )
	c_H := IIf(len(a_campos[1])>=8,a_campos[1,8],'' )
	c_I := IIf(len(a_campos[1])>=9,a_campos[1,9],'' )
	c_J := IIf(len(a_campos[1])>=10,a_campos[1,10],'' )

	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 240,500 PIXEL
	@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D, c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (AbrePrj(oLbx:AARRAY[oLbx:NAT][nPos], oLbx:AARRAY[oLbx:NAT][len(oLbx:AARRAY[oLbx:NAT])])) SIZE 230,095 OF oDlg PIXEL	
	
	@ 110,010 BitMap _oBmp ResName "BR_VERDE" 	OF oDlg Size 10,10 NoBorder When .F. Pixel 
	@ 110,020 SAY OemToAnsi("OBRA") OF oDlg PIXEL 
	
 /*	@ 110,120 BitMap _oBmp ResName "BR_VERMELHO" 	OF oDlg Size 10,10 NoBorder When .F. Pixel 
	@ 110,130 SAY OemToAnsi("") OF oDlg PIXEL 
  */	                                                			
	oLbx:SetArray( aVetor )
		                    
	c_Lst := '{|| {aVetor[oLbx:nAt,1],'
	For n_x := 2 to len(a_campos[2])-1
		c_Lst += '     aVetor[oLbx:nAt,'+Str(n_x)+'],'
	Next
	c_Lst += '    aVetor[oLbx:nAt,'+Str(len(a_campos[2]))+']}}'

	oLbx:bLine := &c_Lst
	c_Ret := &c_Lst                 
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg Centered
	
	RestArea( aSalvAmb )

Return c_Ret


Static Function AbrePrj(c_codprj, c_enti)

	If c_enti = 'AF1'
		DbSelectArea('AF1')
		DbSetOrder(1)
		DbSeek(xFilial('AF1')+c_codprj)
		AxVisual('AF1', AF1->(Recno()), 2)
//		msgalert('vai abrir o orcamento : ' + c_codprj)
	ELSE
		DbSelectArea("AF9")
	
		DbSelectArea('AF8')
		DbSetOrder(1)
		DbSeek(xfilial('AF8')+c_codprj)
			AxVisual('AF8', AF8->(Recno()), 2)
//		PMS200Dlg('AF8', AF8->(Recno()), 2)
	EndIf

Return
