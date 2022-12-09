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
±±ºPrograma  ³CPMS002   ºAutor  ³Bruno S. Parreira   º Data ³  06/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta personalisada de clientes, orçamentos, projeto     º±±
±±º          ³e centro de custo.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico clientes ACTUAL TREND - www.actualtrend.com.br   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CPMS002()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define variaveis...                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL _oDlgPes
	LOCAL _oTipoPes
	LOCAL _nOpca      := 0
	LOCAL _aVetPad    := { {"ENABLE","","","","","","","","","","",""} }
	LOCAL _oBrow
	LOCAL _bRefresh   
	LOCAL _cValid     := "{|| Eval(_bRefresh) }"
	LOCAL _bOK        := ""
	LOCAL _bCanc      := { || _nOpca := 3,_oDlgPes:End() }
	LOCAL _oGetChave
	LOCAL _aTipoPes   := {}
	LOCAL _cTipoPes   := ""
	LOCAL _oChkChk
	LOCAL _lChkChk    := .F.
	LOCAL _oChkEnd
	LOCAL _oChkBlo                                    	
	LOCAL _lChkAtivo  :=  .F.
	LOCAL _nLin       := 1
	LOCAL _aButtons 	 := {}
	LOCAL _oBmp	 	 := Nil
	
	Private NAT := 1
	
	Private _cChave     := "" + Space(100)
	Private _lChkEnd    := Iif(Empty(_cChave), .T., .F.)
	_bRefresh   := { || AT42Pesquisa(AllTrim(_cChave),Subs(_cTipoPes,1,1),_lChkChk,_lChkAtivo,_aBrow,_aVetPad,_oBrow,lBloqueia,_lChkEnd), If(Empty(_aBrow[1,3]) .And. !Empty(_cChave),.F.,.T. )  }

	PRIVATE cCadastro	:= "Gerenciamento de Projetos"
	
	PRIVATE aMemos  := {{"AF8_CODMEM","AF8_OBS"}}
	PRIVATE aCores  := PmsAF8Color()
	PRIVATE nDlgPln := PMS_VIEW_TREE

	Set Key VK_F12 To FAtiva()

	PRIVATE _aBrow   := {}

	lBloqueia:= .F.
	
	PRIVATE aOpcoes  := {}
	
	_aBrow := aClone(_aVetPad)
	
	
	_cChamada := Upper(ReadVar())
	
	_aTipoPes   := {	"1-Todos",;
			"2-Clientes",;     
			"3-Orçamento",;
			"4-Projeto",; 
			"5-Obra"}
	// Condicao para filtrar a Pesquisa
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Botoes da Barra Superior            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd(_aButtons,{"ANALITICO"  ,{|| FG42Visual(_aBrow,_oBrow) }, "Visualiza Cadastro da Entidade", "Visual"} )	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define dialogo...                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG _oDlgPes TITLE "Pesquisa de Cadastros de Clientes, Orçamentos, Projetos e Obras" FROM 008.2,000 TO 26.5,100 OF GetWndDefault()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta objeto que recebera o a chave de pesquisa  ...                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oGetChave := TGet():New(020,103,{ | U | IF( PCOUNT() == 0, _cChave, _cChave := U ) },_oDlgPes,210,008 ,"@!S30",&_cValid,nil,nil,nil,nil,nil,.T.,nil,.F.,nil,.F.,nil,nil,.F.,nil,nil,_cChave)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Browse...                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oBrow := TcBrowse():New( 043, 008, 378, 078,,,, _oDlgPes,,,,,,,,,,,, .F.,, .T.,, .F., )
	
	_oBrow:AddColumn(TcColumn():New("",nil,nil,nil,nil,nil,015,.T.,.F.,nil,nil,nil,.T.,nil))
	         _oBrow:ACOLUMNS[1]:BDATA     := { || _aBrow[_oBrow:nAt,1] }
	_oBrow:AddColumn(TcColumn():New(OemToAnsi("Filial"),nil,nil,nil,nil,nil,040,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrow:ACOLUMNS[2]:BDATA     := { || _aBrow[_oBrow:nAt,2] }
	_oBrow:AddColumn(TcColumn():New(OemToAnsi("Codigo"),nil,nil,nil,nil,nil,100,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrow:ACOLUMNS[3]:BDATA     := { || _aBrow[_oBrow:nAt,3] }
	_oBrow:AddColumn(TcColumn():New(OemToAnsi("Nome"),nil,nil,nil,nil,nil,100,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrow:ACOLUMNS[4]:BDATA     := { || _aBrow[_oBrow:nAt,4] }
	_oBrow:AddColumn(TcColumn():New(OemToAnsi("Endereco"),nil,nil,nil,nil,nil,030,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrow:ACOLUMNS[5]:BDATA     := { || _aBrow[_oBrow:nAt,5] }                  
	_oBrow:AddColumn(TcColumn():New(OemToAnsi("Entidade"),nil,nil,nil,nil,nil,030,.F.,.F.,nil,nil,nil,.F.,nil))
	         _oBrow:ACOLUMNS[6]:BDATA     := { || _aBrow[_oBrow:nAt,6] }                  
	
	@ 020,008 COMBOBOX _oTipoPes  Var _cTipoPes 	ITEMS _aTipoPes 	SIZE 090,010 OF _oDlgPes PIXEL COLOR CLR_HBLUE
	@ 018,319 CHECKBOX _oChkEnd   Var _lChkEnd 		PROMPT OemToAnsi("Pesquisar Por Endereco") 	PIXEL SIZE 080, 010 OF _oDlgPes
//	@ 030,319  CHECKBOX _oChkChk   Var _lChkChk 		PROMPT "Pesquisar Palavra Chave" 	PIXEL SIZE 080, 010 OF _oDlgPes
	
	@ 126,010 BitMap _oBmp ResName "BR_VERDE" 	OF _oDlgPes Size 10,10 NoBorder When .F. Pixel 
	@ 126,020 SAY OemToAnsi("Cliente") OF _oDlgPes PIXEL 
	
	@ 126,100 BitMap _oBmp ResName "BR_CINZA" 	OF _oDlgPes Size 10,10 NoBorder When .F. Pixel 
	@ 126,110 SAY OemToAnsi("Orçamento") OF _oDlgPes PIXEL
	
	@ 126,190 BitMap _oBmp ResName "BR_AMARELO" 	OF _oDlgPes Size 10,10 NoBorder When .F. Pixel 
	@ 126,200 SAY OemToAnsi("Projeto") OF _oDlgPes PIXEL 
	
	@ 126,280 BitMap _oBmp ResName "BR_AZUL" 	OF _oDlgPes Size 10,10 NoBorder When .F. Pixel 
	@ 126,290 SAY OemToAnsi("Obra") OF _oDlgPes PIXEL  
	
	_oBrow:SetArray(_aBrow)
	//_oBrow:BLDBLCLICK := _bOK
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa o Dialogo...                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AT42Pesquisa(AllTrim(_cChave),Subs('1',1,1),.F.,.F.,_aBrow,{ {"ENABLE","","","","","","","","","","",""} },_oBrow,.F.,_lChkEnd)	
	
	ACTIVATE MSDIALOG _oDlgPes CENTERED ON INIT Eval({ || EnChoiceBar(_oDlgPes,_bOK,_bCanc,.F.,_aButtons) })
	
	If _nOpca == 1
	   If !Empty(_aBrow[_nLin,2])
	      SB1->(DbGoTo(_aBrow[_nLin,06]))
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
±±ºPrograma  ³AT42PesquisaºAutor³Bruno S. Parreira   º Data ³  23/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de pesquisa de Produtos na Base de dados             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico clientes ACTUAL TREND - www.actualtrend.com.br   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AT42Pesquisa(_cChave,_cTipoPes,_lChkChk,_lChkAtivo,_aBrow,_aVetPad,_oBrow,lBloqueia,_lChkEnd)
	LOCAL cSQL      := ""
	LOCAL cRetBA1
	LOCAL cDataBase := AllTrim(TCGetDB())
	LOCAL cNomeEmp  := ""
	LOCAL cNomeUsr  := ""
	LOCAL nFor   
	LOCAL lTroca    := .F.                       
	Local oCond		:= Nil
	Local _oFlag

	Private oCliAf	:= LoadBitmap(GetResources(),"BR_VERDE")
	Private oPrjAf	:= LoadBitmap(GetResources(),"BR_CINZA")
	Private oOrcAf	:= LoadBitmap(GetResources(),"BR_AMARELO")
	Private oCCAf	:= LoadBitmap(GetResources(),"BR_AZUL")

	If Empty(_cChave)
		Return(.T.)
	EndIf

	If '"' $ _cChave .Or. "'" $ _cChave
   		Aviso( "Caracter Invalido","Existem caracteres invalidos em sua pesquisa.", { "Ok" }, 2 ) 	                                                                    
   		Return(.F.)
	Endif   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa resultado...                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aBrow := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua busca...                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

	If substr(_cTipoPes,1,1) = '1'
		cSQL := " SELECT 	'SA1' as ENTIDADE, "
		cSQL += " 			A1_COD as CODIGO, "
		cSQL += " 			 A1_NOME as NOME, "
		cSQL += " 			 A1_END as ENDERECO, "
		cSQL += " 			SA1.R_E_C_N_O_	AS REC, A1_MSFIL as FILORI "                     	
		cSQL += " FROM " + RetSQLName("SA1") + " SA1 "
		cSQL += " WHERE    A1_FILIAL ='"+xFilial("SA1")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "A1_END  LIKE '%"+AllTrim(_cChave)+"%'  ", "A1_NOME  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      SA1.D_E_L_E_T_=' ' and A1_MSBLQL <> '1'"
		cSQL += " union all "
		cSQL += " SELECT 	'AF8' as ENTIDADE, "
		cSQL += " 			AF8_PROJET AS CODIGO, "
		cSQL += " 			AF8_DESCRI AS NOME, "
		cSQL += " 			AF8_ENDENT AS ENDERECO, "
		cSQL += " 			AF8.R_E_C_N_O_	AS REC, AF8_MSFIL  as FILORI "                     	
		cSQL += " FROM " + RetSQLName("AF8") + " AF8 "
		cSQL += " WHERE    AF8_FILIAL ='"+xFilial("AF8")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "AF8_ENDENT  LIKE '%"+AllTrim(_cChave)+"%'  ", "AF8_DESCRI  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      AF8.D_E_L_E_T_=' ' "       
		cSQL += " union all "
		cSQL += " SELECT 	'AF1' as ENTIDADE, "
		cSQL += " 			AF1_ORCAME AS CODIGO, "
		cSQL += " 			AF1_DESCRI AS NOME, "
		cSQL += " 			AF1_XENDOB AS ENDERECO, "
		cSQL += " 			AF1.R_E_C_N_O_	AS REC, AF1_MSFIL  as FILORI "                     	
		cSQL += " FROM " + RetSQLName("AF1") + " AF1 "
		cSQL += " WHERE    AF1_FILIAL ='"+xFilial("AF1")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "AF1_XENDOB  LIKE '%"+AllTrim(_cChave)+"%'  ", "AF1_DESCRI  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      AF1.D_E_L_E_T_=' ' "
		cSQL += " union all "
		cSQL += " SELECT 	'CTT' as ENTIDADE, "
		cSQL += " 			CTT_CUSTO AS CODIGO, "
		cSQL += " 			CTT_DESC01 AS NOME, "   
		cSQL += " 			CTT_XEND AS ENDERECO, "
		cSQL += " 			CTT.R_E_C_N_O_	AS REC, CTT_MSFIL  as FILORI "                     	
		cSQL += " FROM " + RetSQLName("CTT") + " CTT "
		cSQL += " WHERE    CTT_FILIAL ='"+xFilial("CTT")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "CTT_XEND  LIKE '%"+AllTrim(_cChave)+"%'  ", "CTT_DESC01  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      CTT.D_E_L_E_T_=' ' "
		cSQL += " ORDER BY NOME "
	ElseIf substr(_cTipoPes,1,1) = '2'
		cSQL := " SELECT 	'SA1' as ENTIDADE, "
		cSQL += " 			A1_COD as CODIGO, "
		cSQL += " 			 A1_NOME as NOME, "   
		cSQL += " 			 A1_END as ENDERECO, "
		cSQL += " 			SA1.R_E_C_N_O_	AS REC, A1_MSFIL  as FILORI "                     	
		cSQL += " FROM " + RetSQLName("SA1") + " SA1 "
		cSQL += " WHERE    A1_FILIAL ='"+xFilial("SA1")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "A1_END  LIKE '%"+AllTrim(_cChave)+"%'  ", "A1_NOME  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      SA1.D_E_L_E_T_=' ' and A1_MSBLQL <> '1'"
		cSQL += " ORDER BY A1_NOME "      
	ElseIf substr(_cTipoPes,1,1) = '3'	
		cSQL += " SELECT 	'AF8' as ENTIDADE, "
		cSQL += " 			AF8_PROJET AS CODIGO, "
		cSQL += " 			AF8_DESCRI AS NOME, "  
		cSQL += " 			AF8_ENDENT AS ENDERECO, "
		cSQL += " 			AF8.R_E_C_N_O_	AS REC, AF8_MSFIL  as FILORI "
		cSQL += " FROM " + RetSQLName("AF8") + " AF8 "
		cSQL += " WHERE    AF8_FILIAL ='"+xFilial("AF8")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "AF8_ENDENT  LIKE '%"+AllTrim(_cChave)+"%'  ", "AF8_DESCRI  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      AF8.D_E_L_E_T_=' ' "
		cSQL += " ORDER BY AF8_DESCRI"   
	ElseIf substr(_cTipoPes,1,1) = '4'
		cSQL += " SELECT 	'AF1' as ENTIDADE, "
		cSQL += " 			AF1_ORCAME AS CODIGO, "
		cSQL += " 			AF1_DESCRI AS NOME, " 
		cSQL += " 			AF1_XENDOB AS ENDERECO, "
		cSQL += " 			AF1.R_E_C_N_O_	AS REC, AF1_MSFIL  as FILORI "                     	
		cSQL += " FROM " + RetSQLName("AF1") + " AF1 "
		cSQL += " WHERE    AF1_FILIAL ='"+xFilial("AF1")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "AF1_XENDOB  LIKE '%"+AllTrim(_cChave)+"%'  ", "AF1_DESCRI  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      AF1.D_E_L_E_T_=' ' "
		cSQL += " ORDER BY AF1_DESCRI"
	ElseIf substr(_cTipoPes,1,1) = '5'	
		cSQL += " SELECT 	'CTT' as ENTIDADE, "
		cSQL += " 			CTT_CUSTO AS CODIGO, "
		cSQL += " 			CTT_DESC01 AS NOME, "  
		cSQL += " 			CTT_XEND AS ENDERECO, "
		cSQL += " 			CTT.R_E_C_N_O_	AS REC, CTT_MSFIL  as FILORI "                     	
		cSQL += " FROM " + RetSQLName("CTT") + " CTT "
		cSQL += " WHERE    CTT_FILIAL ='"+xFilial("CTT")+"' " 
		cSQL += " and      " + Iif(_lChkEnd, "CTT_XEND  LIKE '%"+AllTrim(_cChave)+"%'  ", "CTT_DESC01  LIKE '%"+AllTrim(_cChave)+"%'")
		cSQL += " and      CTT.D_E_L_E_T_=' ' "
		cSQL += " ORDER BY CTT_DESC01 "	
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
			_oFlag := oCliAF
		ElseIf QRY->ENTIDADE = 'AF8' 
			_oFlag := oOrcAf
		ElseIf QRY->ENTIDADE = 'AF1'
			_oFlag := oPrjAf
		ElseIf QRY->ENTIDADE = 'CTT'
			_oFlag := oCCAf	
		EndIf            
	
		aadd(_aBrow,{	_oFlag,;
					QRY->FILORI  ,;
					QRY->CODIGO  ,;
					QRY->NOME    ,;
					QRY->ENDERECO,;
					QRY->ENTIDADE,;
					QRY->REC})
		QRY->(DbSkip())
	EndDo

	DbSelectArea("QRY")
	DbCloseArea("QRY")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Testa resultado da pesquisa...                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(_aBrow) == 0
   		_aBrow := aClone(_aVetPad)   
	Endif       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza browse...                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oBrow:SetArray(_aBrow)
	_oBrow:Refresh() 
	_oBrow:SetFocus()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FG42VisualºAutor  ³Bruno S. Parreira   º Data ³  08/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualiza cadastro do Produto                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico clientes ACTUAL TREND - www.actualtrend.com.br   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FG42Visual(_aBrow,_oBrow)
	Local _aArea := GetArea()

	If _aBrow[_oBrow:nAt,06] = 'SA1'
		SA1->(DbGoTo(_aBrow[_oBrow:nAt,07]))
		AxVisual("SA1",SA1->(RECNO()), 2)
	ElseIf _aBrow[_oBrow:nAt,06] = 'AF1'
		AF1->(DbGoTo(_aBrow[_oBrow:nAt,07]))
		AxVisual("AF1",AF8->(RECNO()), 2)
	ElseIf _aBrow[_oBrow:nAt,06] = 'AF8'
		AF8->(DbGoTo(_aBrow[_oBrow:nAt,07]))
		AxVisual("AF8",AF1->(RECNO()), 2) 
	ElseIf _aBrow[_oBrow:nAt,06] = 'CTT'
		CTT->(DbGoTo(_aBrow[_oBrow:nAt,07]))
		AxVisual("CTT",CTT->(RECNO()), 2)
	Else
		ApMsgStop(OemToAnsi("Selecione um registro válido!"),"Consulta de Entidade")
	Endif

	RestArea(_aArea)
Return