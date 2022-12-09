#include "topconn.ch"
#include "dbtree.ch"
#include "mproject.ch"
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
#define TOOL_AVANCAR_CAL    STR0P39 //"Avancar"
#define TOOL_CANCEL         STR0P34 //"Cancelar" 
#define TOOL_COLUNAS        STR0P05 //"Colunas"
#define TOOL_CORES          STR0P40 //"Cores"
#define TOOL_DATA           STR0P41 //"Data"
#define TOOL_DOCUMENTOS     STR0P10 //"Docum."
#define TOOL_FERRAMENTAS    STR0P06 //"Ferramentas"
#define TOOL_FILTRO         STR0P03 //"Filtro"
#define TOOL_IMPRIMIR       STR0P33 //"Imprimir"
#define TOOL_OPCOES         STR0P42 //"Opcoes"
#define TOOL_ORC_ESTRUTURA  STR0P27 //"Estrut."
#define TOOL_ORC_IMPRESSAO  STR0P13 //"Imprimir"
#define TOOL_ORC_INFO       STR0P12 //"Inform."
#define TOOL_PESQUISAR      STR0P09 //"Pesquisar"
#define TOOL_PROJ_APONT     STR0P11 //"Apont."
#define TOOL_PROJ_CONSULTAS STR0P02 //"Consultas"
#define TOOL_PROJ_ESTRUTURA STR0P07 //"Estrut."
#define TOOL_PROJ_EXECUCAO  STR0P04 //"Execucao"
#define TOOL_PROJ_INFO      STR0P01 //"Inform."
#define TOOL_PROJ_PROG_FIS  STR0P32 //"Prg. Fis."
#define TOOL_PROJ_USUARIOS  STR0P08 //"Usuarios"
#define TOOL_REAJUS_CUSTO   STR0P28 //"Custo"
#define TOOL_RETROCEDER_CAL STR0P43 //"Retroceder"
#define TOOL_SAIR           STR0P35 //"Sair"

// tooltips dos botoes da toolbar
#define TIP_AVANCAR_CAL     STR0P44 //"Avancar Calendario"
#define TIP_CANCEL          STR0P37 //"Cancelar"
#define TIP_COLUNAS         STR0P18 //"Configurar colunas"
#define TIP_CORES           STR0P45 //"Configurar cores do grafico"
#define TIP_DATA            STR0P46 //"Data"
#define TIP_DOCUMENTOS      STR0P23 //"Documentos"
#define TIP_FERRAMENTAS     STR0P19 //"Ferramentas"
#define TIP_FILTRO          STR0P16 //"Filtrar visualizacao"
#define TIP_IMPRIMIR        STR0P36 //"Imprimir"
#define TIP_OPCOES          STR0P47 //"Opcoes do Grafico"
#define TIP_ORC_ESTRUTURA   STR0P29 //"Estrutura do Orcamento" 
#define TIP_ORC_IMPRESSAO   STR0P26 //"Impressao do Orcamento"
#define TIP_ORC_INFO        STR0P25 //"Informacoes do Orcamento"
#define TIP_PESQUISAR       STR0P22 //"Pesquisar"
#define TIP_PROJ_APONT      STR0P24 //"Apontamentos do Projeto"
#define TIP_PROJ_CONSULTAS  STR0P15 //"Consultas"
#define TIP_PROJ_ESTRUTURA  STR0P20 //"Estrutura do Projeto"
#define TIP_PROJ_EXECUCAO   STR0P17 //"Gerenciamento de execucao"
#define TIP_PROJ_INFO       STR0P14 //"Informacoes do Projeto"
#define TIP_PROJ_PROG_FIS   STR0P31 //"Progresso Fisico do Projeto"
#define TIP_PROJ_USUARIOS   STR0P21 //"Usuarios"
#define TIP_REAJUS_CUSTO    STR0P30 //"Reajustar Custo Previsto"
#define TIP_RETROCEDER_CAL  STR0P48 //"Retroceder Calendario"
#define TIP_SAIR            STR0P38 //"Sair"

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

//#include "pmsicons.ch"
/*/                                                                                                                                                                                                                                                                                                                                 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                                                                                                                                                                                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                                                                                                                                                                                                                     
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±                                                                                                                                                                                                                                                     
±±³Fun‡…o    ³ PMSA110  ³ Autor ³ Edson Maricate        ³ Data ³ 09-02-2001 ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Descri‡…o ³ Programa de geracao de Projetos a partir dos Orcamentos.     ³±±                                                                                                                                                                                                                                                     
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
User Function PMSA110()
                                                                                                                                                                                                                                                                                                                                    
PRIVATE cCadastro	:= "Preparacao do Projeto"                                                                                                                                                                                                                                                                        
PRIVATE aRotina := MenuDef()
PRIVATE nDlgPln := PMS_VIEW_TREE

Private l_jafez := .F.
                                                                                                                                                                                                                                                                                                                                    
If AMIIn(44)                                                                                                                                                                                                                                                                                                                        
	dbSelectArea("AF1")                                                                                                                                                                                                                                                                                                         
	dbSetOrder(1)                                                                                                                                                                                                                                                                                                               
	mBrowse(6,1,22,75,"AF1",,,,,,PmsAF1Color())                                                                                                                                                                                                                                                                                 
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
Return                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                    
/*/                                                                                                                                                                                                                                                                                                                                 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                                                                                                                                                                                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                                                                                                                                                                                                                     
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±                                                                                                                                                                                                                                                     
±±³Fun‡…o    ³PMS110Gera³ Autor ³ Edson Maricate        ³ Data ³ 09-02-2001 ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Descri‡…o ³ Efetua a gravacao dos arquivos de projetos com base no orcam.³±±                                                                                                                                                                                                                                                     
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
Static Function PMS110Gera()                                                                                                                                                                                                                                                                                                        
Local cMvGer	 := GetMv("MV_FASEGER")                                                                                                                                                                                                                                                                                             
Local cFaseOrc	 := Substr(cMvGer,AT("ORC=",cMvGer)+4,2)                                                                                                                                                                                                                                                                            
Local cFasePrj	 := Substr(cMvGer,AT("PROJ=",cMvGer)+5,2)                                                                                                                                                                                                                                                                           
Local bCampo 	:= {|n| FieldName(n) }                                                                                                                                                                                                                                                                                              
Local nX,nY,nA,nI                                                                                                                                                                                                                                                                                                                   
Local aPredec	:=	{}                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                    
PcoIniLan("000350")                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                    
Begin Transaction                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                    
dbSelectArea("AF8")                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                    
For nI:= 1 to FCount()                                                                                                                                                                                                                                                                                                              
	If FieldName(nI) <> "AF8_PROJET"                                                                                                                                                                                                                                                                                            
		&("M->"+FieldName(nI)):= CriaVar(FieldName(nI))                                                                                                                                                                                                                                                                     
	EndIf                                                                                                                                                                                                                                                                                                                       
Next                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                    
//RegToMemory("AF8",.T.)                                                                                                                                                                                                                                                                                                            
RecLock("AF8",.T.)                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                    
For nx := 1 TO FCount()                                                                                                                                                                                                                                                                                                             
	nPosCpo := AF1->(FieldPos("AF1_"+Substr(AF8->(FieldName(nx)),5)))                                                                                                                                                                                                                                                           
	If FieldName(nX) <> "AF8_PROJET"                                                                                                                                                                                                                                                                                            
		If nPosCpo > 0                                                                                                                                                                                                                                                                                                      
			FieldPut(nx,AF1->(FieldGet(nPosCpo)))                                                                                                                                                                                                                                                                       
		Else                                                                                                                                                                                                                                                                                                                
			FieldPut(nx,M->&(EVAL(bCampo,nx)))                                                                                                                                                                                                                                                                          
		EndIf                                                                                                                                                                                                                                                                                                               
	EndIf                                                                                                                                                                                                                                                                                                                       
Next nx                                                                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                    
AF8->AF8_FILIAL := xFilial("AF8")                                                                                                                                                                                                                                                                                                   
AF8->AF8_PROJET	:= UPPER(MV_PAR01)
AF8->AF8_DATA	:= dDataBase                                                                                                                                                                                                                                                                                                        
AF8->AF8_DESCRI	:= AF1->AF1_DESCRI
AF8->AF8_REVISA	:= StrZero(1, TamSX3("AF8_REVISA")[1])                                                                                                                                                                                                                                                                              
AF8->AF8_TPPRJ	:= AF1->AF1_TPORC                                                                                                                                                                                                                                                                                                   
AF8->AF8_FASE	:= cFasePrj                                                                                                                                                                                                                                                                                                         
AF8->AF8_PRJREV	:= CriaVar("AF8_PRJREV")                                                                                                                                                                                                                                                                                            
AF8->AF8_CALEND	:= MV_PAR03                                                                                                                                                                                                                                                                                                         
AF8->AF8_LOCPAD	:= MV_PAR02                                                                                                                                                                                                                                                                                                         
MsUnlock()                                                                                                                                                                                                                                                                                                                          
MsMM(,,,MsMM(AF1->AF1_CODMEM),1,,,"AF8", "AF8_CODMEM")                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                    
PmsCopyCon("AF1",AF1->(Recno()))                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                    
If ExistBlock("PM110AF8")                                                                                                                                                                                                                                                                                                           
	ExecBlock("PM110AF8",.F.,.F.)                                                                                                                                                                                                                                                                                               
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
PmsAvalPrj("AF8" ,1 ,.F.)                                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                    
PmsIncProc(.T.)                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                    
dbSelectArea("AF5")                                                                                                                                                                                                                                                                                                                 
dbSetOrder(3)                                                                                                                                                                                                                                                                                                                       
dbSeek(xFilial()+AF1->AF1_ORCAME)                                                                                                                                                                                                                                                                                                   
AF2->(MsSeek(xFilial()+AF1->AF1_ORCAME))                                                                                                                                                                                                                                                                                            
While !Eof() .And. xFilial()+AF1->AF1_ORCAME==;                                                                                                                                                                                                                                                                                     
	AF5->AF5_FILIAL+AF5->AF5_ORCAME                                                                                                                                                                                                                                                                                             
		                                                                                                                                                                                                                                                                                                                    
	RegToMemory("AFC",.T.)                                                                                                                                                                                                                                                                                                      
	RecLock("AFC",.T.)                                                                                                                                                                                                                                                                                                          
	For nx := 1 TO FCount()                                                                                                                                                                                                                                                                                                     
		nPosCpo := AF5->(FieldPos("AF5_"+Substr(AFC->(FieldName(nx)),5)))                                                                                                                                                                                                                                                   
		If nPosCpo > 0                                                                                                                                                                                                                                                                                                      
			FieldPut(nx,AF5->(FieldGet(nPosCpo)))                                                                                                                                                                                                                                                                       
		Else                                                                                                                                                                                                                                                                                                                
			FieldPut(nx,M->&(EVAL(bCampo,nx)))                                                                                                                                                                                                                                                                          
		EndIf                                                                                                                                                                                                                                                                                                               
	Next nx                                                                                                                                                                                                                                                                                                                     
	AFC->AFC_FILIAL	:= xFilial("AFC")                                                                                                                                                                                                                                                                                           
	AFC->AFC_PROJET	:= UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                          
	AFC->AFC_REVISA	:= StrZero(1, TamSX3("AFC_REVISA")[1])                                                                                                                                                                                                                                                                      
	If AF5->AF5_NIVEL == "001"                                                                                                                                                                                                                                                                                                  
		AFC->AFC_EDT	:= UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                  
	EndIf                                                                                                                                                                                                                                                                                                                       
	If AF5->AF5_NIVEL == "002"                                                                                                                                                                                                                                                                                                  
		AFC->AFC_EDTPAI	:= UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                  
	Else                                                                                                                                                                                                                                                                                                                        
		If AF5->AF5_NIVEL <> "001"                                                                                                                                                                                                                                                                                          
			AFC->AFC_EDTPAI	:= AF5->AF5_EDTPAI                                                                                                                                                                                                                                                                          
		EndIf                                                                                                                                                                                                                                                                                                               
	EndIf                                                                                                                                                                                                                                                                                                                       
	AFC->AFC_CALEND	:= MV_PAR03                                                                                                                                                                                                                                                                                                 
	MsUnlock()                                                                                                                                                                                                                                                                                                                  
	MSMM(,TamSx3("AFC_OBS")[1],,MSMM(AF5->AF5_CODMEM,80),1,,,"AFC","AFC_CODMEM")                                                                                                                                                                                                                                                
	PmsCopyCon("AF5",AF5->(Recno()))                                                                                                                                                                                                                                                                                            
	                                                                                                                                                                                                                                                                                                                            
	If ExistBlock("PM110AFC")                                                                                                                                                                                                                                                                                                   
		ExecBlock("PM110AFC",.F.,.F.)                                                                                                                                                                                                                                                                                       
	EndIf                                                                                                                                                                                                                                                                                                                       
	                                                                                                                                                                                                                                                                                                                            
	dbSelectArea("AF5")                                                                                                                                                                                                                                                                                                         
	dbSkip()                                                                                                                                                                                                                                                                                                                    
	                                                                                                                                                                                                                                                                                                                            
	PmsIncProc(.T.)                                                                                                                                                                                                                                                                                                             
End                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                    
dbSelectArea("AF2")                                                                                                                                                                                                                                                                                                                 
dbSetOrder(1)                                                                                                                                                                                                                                                                                                                       
dbSeek(xFilial()+AF1->AF1_ORCAME)                                                                                                                                                                                                                                                                                                   
While !Eof() .And. xFilial()+AF1->AF1_ORCAME==;                                                                                                                                                                                                                                                                                     
	AF2->AF2_FILIAL+AF2->AF2_ORCAME                                                                                                                                                                                                                                                                                             
	RegToMemory("AF9",.T.)                                                                                                                                                                                                                                                                                                      
	RecLock("AF9",.T.)                                                                                                                                                                                                                                                                                                          
	For nx := 1 TO FCount()                                                                                                                                                                                                                                                                                                     
		nPosCpo := AF2->(FieldPos("AF2_"+Substr(AF9->(FieldName(nx)),5)))                                                                                                                                                                                                                                                   
		If nPosCpo > 0                                                                                                                                                                                                                                                                                                      
			FieldPut(nx,AF2->(FieldGet(nPosCpo)))                                                                                                                                                                                                                                                                       
		Else                                                                                                                                                                                                                                                                                                                
			FieldPut(nx,M->&(EVAL(bCampo,nx)))                                                                                                                                                                                                                                                                          
		EndIf                                                                                                                                                                                                                                                                                                               
	Next nx                                                                                                                                                                                                                                                                                                                     
	AF9->AF9_FILIAL := xFilial("AF9")                                                                                                                                                                                                                                                                                           
	AF9->AF9_PROJET	:= UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                          
	AF9->AF9_REVISA	:= StrZero(1, TamSX3("AF9_REVISA")[1])                                                                                                                                                                                                                                                                      
	If AF2->AF2_NIVEL == "002"                                                                                                                                                                                                                                                                                                  
		AF9->AF9_EDTPAI	:= UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                  
	EndIf                                                                                                                                                                                                                                                                                                                       
	AF9->AF9_CALEND	:= If(Empty(AF2->AF2_CALEND),MV_PAR03,AF2->AF2_CALEND)                                                                                                                                                                                                                                                      
	AF9->AF9_START	:= dDataBase                                                                                                                                                                                                                                                                                                
	AF9->AF9_FINISH := dDataBase                                                                                                                                                                                                                                                                                                
	AF9->AF9_HUTEIS := AF2->AF2_HDURAC                                                                                                                                                                                                                                                                                          
	MsUnlock()                                                                                                                                                                                                                                                                                                                  
	MSMM(,TamSx3("AF9_OBS")[1],,MSMM(AF2->AF2_CODMEM,80),1,,,"AF9","AF9_CODMEM")                                                                                                                                                                                                                                                
	                                                                                                                                                                                                                                                                                                                            
	PmsCopyCon("AF2",AF2->(Recno()))                                                                                                                                                                                                                                                                                            
	                                                                                                                                                                                                                                                                                                                            
	If ExistBlock("PM110AF9")                                                                                                                                                                                                                                                                                                   
		ExecBlock("PM110AF9",.F.,.F.)                                                                                                                                                                                                                                                                                       
	EndIf                                                                                                                                                                                                                                                                                                                       
	                                                                                                                                                                                                                                                                                                                            
	                                                                                                                                                                                                                                                                                                                            
	PmsIncProc(.T.)                                                                                                                                                                                                                                                                                                             
	                                                                                                                                                                                                                                                                                                                            
	dbSelectArea("AF3")                                                                                                                                                                                                                                                                                                         
	dbSetOrder(1)                                                                                                                                                                                                                                                                                                               
	dbSeek(xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA)                                                                                                                                                                                                                                                                           
	While !Eof() .And.xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA==;                                                                                                                                                                                                                                                              
		AF3->AF3_FILIAL+AF3->AF3_ORCAME+AF3->AF3_TAREFA                                                                                                                                                                                                                                                                     
		RegToMemory("AFA",.T.)                                                                                                                                                                                                                                                                                              
		RecLock("AFA",.T.)                                                                                                                                                                                                                                                                                                  
		For nx := 1 TO FCount()                                                                                                                                                                                                                                                                                             
			nPosCpo := AF3->(FieldPos("AF3_"+Substr(AFA->(FieldName(nx)),5)))                                                                                                                                                                                                                                           
			If nPosCpo > 0                                                                                                                                                                                                                                                                                              
				FieldPut(nx,AF3->(FieldGet(nPosCpo)))                                                                                                                                                                                                                                                               
			Else                                                                                                                                                                                                                                                                                                        
				FieldPut(nx,M->&(EVAL(bCampo,nx)))                                                                                                                                                                                                                                                                  
			EndIf                                                                                                                                                                                                                                                                                                       
		Next nx                                                                                                                                                                                                                                                                                                             
		                                                                                                                                                                                                                                                                                                                    
		If AF3->(FieldPos("AF3_RECURS"))>0 .and. ! Empty(AF3->AF3_RECURS)                                                                                                                                                                                                                                                   
			If AFA->(FieldPos("AFA_RECURS"))>0                                                                                                                                                                                                                                                                          
				AFA->AFA_FIX := "2"                                                                                                                                                                                                                                                                                 
			EndIf                                                                                                                                                                                                                                                                                                       
		EndIf                                                                                                                                                                                                                                                                                                               
		                                                                                                                                                                                                                                                                                                                    
		AFA->AFA_FILIAL := xFilial("AFA")                                                                                                                                                                                                                                                                                   
		AFA->AFA_PROJET	:= UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                  
		AFA->AFA_REVISA := StrZero(1, TamSX3("AFA_REVISA")[1])                                                                                                                                                                                                                                                              
		If AFA->(FieldPos("AFA_DTAPRO")) > 0 .And. AF3->AF3_ACUMUL$"5/6"                                                                                                                                                                                                                                                    
			AFA->AFA_DTAPRO	:= AF9->AF9_START                                                                                                                                                                                                                                                                           
		EndIf                                                                                                                                                                                                                                                                                                               
		                                                                                                                                                                                                                                                                                                                    
		MsUnlock()                                                                                                                                                                                                                                                                                                          
		                                                                                                                                                                                                                                                                                                                    
		PmsCopyCon(Alias(),Recno())                                                                                                                                                                                                                                                                                         
		                                                                                                                                                                                                                                                                                                                    
		If ExistBlock("PM110AFA")                                                                                                                                                                                                                                                                                           
			ExecBlock("PM110AFA",.F.,.F.)                                                                                                                                                                                                                                                                               
		EndIf                                                                                                                                                                                                                                                                                                               
		                                                                                                                                                                                                                                                                                                                    
		dbSelectArea("AF3")                                                                                                                                                                                                                                                                                                 
		dbSkip()                                                                                                                                                                                                                                                                                                            
		PmsIncProc(.T.)                                                                                                                                                                                                                                                                                                     
	End                                                                                                                                                                                                                                                                                                                         
	                                                                                                                                                                                                                                                                                                                            
	DbSelectArea("AF7")                                                                                                                                                                                                                                                                                                         
	DbSetOrder(1)                                                                                                                                                                                                                                                                                                               
	If MsSeek(xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA)                                                                                                                                                                                                                                                                        
		Aadd(aPredec,{AF9->(Recno()),{}})                                                                                                                                                                                                                                                                                   
		While !Eof() .And.xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA==;                                                                                                                                                                                                                                                      
			AF7->AF7_FILIAL+AF7->AF7_ORCAME+AF7->AF7_TAREFA                                                                                                                                                                                                                                                             
			AAdd(aPredec[Len(aPredec)][2],AF7->(Recno()))                                                                                                                                                                                                                                                               
			dbSelectArea("AF7")                                                                                                                                                                                                                                                                                         
			dbSkip()                                                                                                                                                                                                                                                                                                    
			PmsIncProc(.T.)                                                                                                                                                                                                                                                                                             
		EndDo                                                                                                                                                                                                                                                                                                               
		                                                                                                                                                                                                                                                                                                                    
	Endif                                                                                                                                                                                                                                                                                                                       
	                                                                                                                                                                                                                                                                                                                            
	DbSelectArea("AF4")                                                                                                                                                                                                                                                                                                         
	DbSetOrder(1)                                                                                                                                                                                                                                                                                                               
	MsSeek(xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA)                                                                                                                                                                                                                                                                           
	While !Eof() .And.xFilial()+AF2->AF2_ORCAME+AF2->AF2_TAREFA==;                                                                                                                                                                                                                                                              
		AF4->AF4_FILIAL+AF4->AF4_ORCAME+AF4->AF4_TAREFA                                                                                                                                                                                                                                                                     
		RegToMemory("AFB",.T.)                                                                                                                                                                                                                                                                                              
		RecLock("AFB",.T.)                                                                                                                                                                                                                                                                                                  
		For nx := 1 TO FCount()                                                                                                                                                                                                                                                                                             
			nPosCpo := AF4->(FieldPos("AF4_"+Substr(AFB->(FieldName(nx)),5)))                                                                                                                                                                                                                                           
			If nPosCpo > 0                                                                                                                                                                                                                                                                                              
				FieldPut(nx,AF4->(FieldGet(nPosCpo)))                                                                                                                                                                                                                                                               
			Else                                                                                                                                                                                                                                                                                                        
				FieldPut(nx,M->&(EVAL(bCampo,nx)))                                                                                                                                                                                                                                                                  
			EndIf                                                                                                                                                                                                                                                                                                       
		Next nx                                                                                                                                                                                                                                                                                                             
		AFB->AFB_FILIAL := xFilial()                                                                                                                                                                                                                                                                                        
		AFB->AFB_PROJET := UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                  
		AFB->AFB_REVISA := StrZero(1, TamSX3("AFB_REVISA")[1])                                                                                                                                                                                                                                                              
		MsUnlock()                                                                                                                                                                                                                                                                                                          
		If ExistBlock("PM110AFB")                                                                                                                                                                                                                                                                                           
			ExecBlock("PM110AFB",.F.,.F.)                                                                                                                                                                                                                                                                               
		EndIf                                                                                                                                                                                                                                                                                                               
		                                                                                                                                                                                                                                                                                                                    
		dbSelectArea("AF4")                                                                                                                                                                                                                                                                                                 
		dbSkip()                                                                                                                                                                                                                                                                                                            
		PmsIncProc(.T.)                                                                                                                                                                                                                                                                                                     
	End                                                                                                                                                                                                                                                                                                                         
	                                                                                                                                                                                                                                                                                                                            
	dbSelectArea("AF2")                                                                                                                                                                                                                                                                                                         
	dbSkip()                                                                                                                                                                                                                                                                                                                    
	PmsIncProc(.T.)                                                                                                                                                                                                                                                                                                             
End                                                                                                                                                                                                                                                                                                                                 
//Gravar as predecessoras so no final apra evitar erro de chave estrangeira                                                                                                                                                                                                                                                         
For nA:=1 To Len(aPredec)                                                                                                                                                                                                                                                                                                           
	AF9->(MsGoTo(aPredec[nA,1]))                                                                                                                                                                                                                                                                                                
	For nY:=1 To Len(aPredec[nA,2])                                                                                                                                                                                                                                                                                             
		AF7->(MsGoTo(aPredec[nA,2,nY]))                                                                                                                                                                                                                                                                                     
		RegToMemory("AFD",.T.)                                                                                                                                                                                                                                                                                              
		RecLock("AFD",.T.)                                                                                                                                                                                                                                                                                                  
		For nx := 1 TO FCount()                                                                                                                                                                                                                                                                                             
			nPosCpo := AF7->(FieldPos("AF7_"+Substr(AFD->(FieldName(nx)),5)))                                                                                                                                                                                                                                           
			If nPosCpo > 0                                                                                                                                                                                                                                                                                              
				FieldPut(nx,AF7->(FieldGet(nPosCpo)))                                                                                                                                                                                                                                                               
			Else                                                                                                                                                                                                                                                                                                        
				FieldPut(nx,M->&(EVAL(bCampo,nx)))                                                                                                                                                                                                                                                                  
			EndIf                                                                                                                                                                                                                                                                                                       
		Next nx                                                                                                                                                                                                                                                                                                             
		                                                                                                                                                                                                                                                                                                                    
		AFD->AFD_FILIAL := xFilial("AFD")                                                                                                                                                                                                                                                                                   
		AFD->AFD_PROJET := UPPER(MV_PAR01)                                                                                                                                                                                                                                                                                  
		AFD->AFD_REVISA := StrZero(1, TamSX3("AFD_REVISA")[1])                                                                                                                                                                                                                                                              
		MsUnlock()                                                                                                                                                                                                                                                                                                          
		                                                                                                                                                                                                                                                                                                                    
		If ExistBlock("PM110AFD")                                                                                                                                                                                                                                                                                           
			ExecBlock("PM110AFD",.F.,.F.)                                                                                                                                                                                                                                                                               
		EndIf                                                                                                                                                                                                                                                                                                               
	Next nY                                                                                                                                                                                                                                                                                                                     
Next nX                                                                                                                                                                                                                                                                                                                             
RecLock("AF1",.F.)                                                                                                                                                                                                                                                                                                                  
AF1->AF1_FASE	:= cFaseOrc                                                                                                                                                                                                                                                                                                         
MsUnlock()                                                                                                                                                                                                                                                                                                                          
PmsAF8Calc(AF8->(RecNo()),MV_PAR04,MV_PAR05,.T.)                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                    
// Ponto de Entrada para a gravação de campos do usuario                                                                                                                                                                                                                                                                            
If ExistBlock("PMA110GERA")                                                                                                                                                                                                                                                                                                         
	ExecBlock("PMA110GERA",.F.,.F.)                                                                                                                                                                                                                                                                                             
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
// Ponto de Entrada para a gravação de campos do usuario no Template                                                                                                                                                                                                                                                                
If ExistTemplate("PMA110GERA")                                                                                                                                                                                                                                                                                                      
	ExecTemplate("PMA110GERA",.F.,.F.)                                                                                                                                                                                                                                                                                          
EndIf                                                                                                                                                                                                                                                                                                                               
End Transaction                                                                                                                                                                                                                                                                                                                     
AF9->(DbSetOrder(2))                                                                                                                                                                                                                                                                                                                
AF9->(MsSeek(xFilial()+AF8->AF8_PROJET+AF8->AF8_REVISA))                                                                                                                                                                                                                                                                            
While !AF9->(Eof()) .And. xFilial('AF9')+AF8->AF8_PROJET+AF8->AF8_REVISA== AF9->AF9_Filial+AF9->AF9_PROJET+AF9->AF9_REVISA                                                                                                                                                                                                          
	PcoDetLan("000350","01","PMSA110")                                                                                                                                                                                                                                                                                          
	AF9->(DbSkip())                                                                                                                                                                                                                                                                                                             
Enddo                                                                                                                                                                                                                                                                                                                               
PcoFinLan("000350")                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                    
Return .T.                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                    
/*/                                                                                                                                                                                                                                                                                                                                 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                                                                                                                                                                                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                                                                                                                                                                                                                     
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±                                                                                                                                                                                                                                                     
±±³Fun‡…o    ³PMS110Aval ³ Autor ³Fabio Rogerio Pereira  ³ Data ³ 07-05-2002³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Descri‡…o ³ Efetua a validacao do orcamento 							    ³±±                                                                                                                                                                                                                       
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
User Function PMSA110a() 
Local cProjet  := ""                                                                                                                                                                                                                                                                                                                
Local aAreaSX1 := {}                                                                                                                                                                                                                                                                                                                
Local lRet := .T.                                                                                                                                                                                                                                                                                                                   
Local c_Ret := ''
Private cCompl := .F.                         
                                                                                                                                                                                                                                                                                                                                    
If l_jafez
	Return
EndIf

If ExistBlock("PMA110Orc")                                                                                                                                                                                                                                                                                                          
	If ExecBlock("PMA110Orc", .T., .T.)                                                                                                                                                                                                                                                                                         
		If __lSX8                                                                                                                                                                                                                                                                                                           
			RollBackSX8()                                                                                                                                                                                                                                                                                               
		EndIf                                                                                                                                                                                                                                                                                                               
		lRet := .F.                                                                                                                                                                                                                                                                                                         
	EndIf                                                                                                                                                                                                                                                                                                                       
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
// validacao de arquivo vazio                                                                                                                                                                                                                                                                                                       
If lRet                                                                                                                                                                                                                                                                                                                             
	If AF1->(BOF()) .AND. AF1->(EOF())                                                                                                                                                                                                                                                                                          
		HELP(" " , 1 , "ARQVAZIO")                                                                                                                                                                                                                                                                                          
		lRet := .F.                                                                                                                                                                                                                                                                                                         
	Endif                                                                                                                                                                                                                                                                                                                       
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
If lRet .AND. !PmsOrcUser(AF1->AF1_ORCAME, , Padr(AF1->AF1_ORCAME, Len(AF5->AF5_EDT)), "  ", 2, "PROJET")                                                                                                                                                                                                                           
	Aviso("Usuário sem permissão", "Usuário sem permissão para gerar projeto deste orçamento. Verifique as permissões do usuário na estrutura principal do orçamento.", {"Fechar"}, 2) //######                                                                                                            
	lRet := .F.                                                                                                                                                                                                                                                                                                                 
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
If lRet .AND. !PmsVldFase("AF1", AF1->AF1_ORCAME, "43")                                                                                                                                                                                                                                                                             
	lRet := .F.                                                                                                                                                                                                                                                                                                                 
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
If lRet                                                                                                                                                                                                                                                                                                                             
	cProjet  := CriaVar("AF8_PROJET", .T.)                                                                                                                                                                                                                                                                                      
	aAreaSX1 := SX1->(GetArea())                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                    
	dbSelectArea("SX1")                                                                                                                                                                                                                                                                                                         
	dbSetOrder(1)                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
	If SX1->(MsSeek( PADR( "PS110A" , LEN( x1_grupo ) , ' ' )+ "01"))                                                                                                                                                                                                                                                           
		Reclock("SX1", .F.)                                                                                                                                                                                                                                                                                                 
		SX1->X1_CNT01 := cProjet                                                                                                                                                                                                                                                                                            
		MsUnlock()                                                                                                                                                                                                                                                                                                          
	EndIf                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                    
	//If FindFunction('SetMVValue')                                                                                                                                                                                                                                                                                             
	//	SetMVValue("PS110A", "MV_PAR01", cProjet)                                                                                                                                                                                                                                                                           
	//Endif                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                    
	RestArea(aAreaSX1)                                                                                                                                                                                                                                                                                                          

	Pergunte("PS110A", .F.)

	DbSelectArea('SM0')
	
	c_compqy := " and  substring(AF8_PROJET, 2,1) in ('0','1','2','3','4','5','6','7','8','9') "
	c_compqy += " and  substring(AF8_PROJET, 3,1) in ('0','1','2','3','4','5','6','7','8','9')"
	c_compqy += " and  substring(AF8_PROJET, 4,1) in ('0','1','2','3','4','5','6','7','8','9')"
	c_compqy += " and  substring(AF8_PROJET, 5,1) in ('0','1','2','3','4','5','6','7','8','9')"
	c_compqy += " and  substring(AF8_PROJET, 6,1) in ('0','1','2','3','4','5','6','7','8','9')"
	c_compqy += " and  substring(AF8_PROJET, 7,1) in ('0','1','2','3','4','5','6','7','8','9')"
	c_compqy += " and  substring(AF8_PROJET, 8,1) in ('0','1','2','3','4','5','6','7','8','9')"
	c_compqy += " and  substring(AF8_PROJET, 9,1) in ('0','1','2','3','4','5','6','7','8','9')"
	c_compqy += " and  substring(AF8_PROJET, 10,1) in ('0','1','2','3','4','5','6','7','8','9')"

  //	If SM0->M0_CODIGO = '01' .and. SM0->M0_CODFIL = '04' //LISONDA             
		If SM0->M0_CODIGO = '01' .and. SM0->M0_CODFIL = '01' //LISONDA       LH ACTUAL 14/10/2016
		c_Ret := FGEN003('AF8', 'AF8_PROJET', "AF8_PROJET like 'L0%' and LEN(AF8_PROJET) = 10 " + c_compqy, 10)
		If c_Ret = '0000000001'
			c_Ret = 'L000000001'
		EndIf
	ElseIf SM0->M0_CODIGO = '01' .and. SM0->M0_CODFIL = '02' //PLAYPISO
		c_Ret := FGEN003('AF8', 'AF8_PROJET', "AF8_PROJET like 'P0%' and LEN(AF8_PROJET) = 10 "  + c_compqy, 10)
		If c_Ret = '0000000001'
			c_Ret = 'P000000001'
		EndIf
	Else //LISONDA RJ
		c_Ret := FGEN003('AF8', 'AF8_PROJET', "AF8_PROJET like 'R0%' "  + c_compqy, 10)
		If c_Ret = '0000000001'
			c_Ret = 'R000000001'
		EndIf
	EndIf

	MV_PAR01 := c_Ret //U_FGEN003('AF8', 'AF8_PROJET', "AF8_PROJET like " + "", )
	MV_PAR05 := dDataBase
	MV_PAR03 := '000'
	
	If MsgYesNo("Confirma a geração de projeto para esse orçamento? ", "A T E N Ç Ã O")
	
		l_jafez := .T.
	
		If Empty(AF1->AF1_CLIENT)
			DbSelectArea('SUS')
			DbSetOrder(1)
			If DbSeek(xFilial('SUS')+AF1->(AF1_XPROSP+AF1_XLOJAP))
				If Empty(SUS->US_CODCLI)
					nopc := 3
					M->A1_NOME := 'XXXXXX'
					n_opc := ATMK001('SA1') //GRAVA UM NOVO CLIENTE
					If !n_opc
						return
					EndIf
					RecLock('AF1', .F.)
					AF1->AF1_CLIENT	:= SUS->US_CODCLI
					AF1->AF1_LOJA	:= SUS->US_LOJACLI
					MsUnLock()
				Else
					RecLock('AF1', .F.)
					AF1->AF1_CLIENT	:= SUS->US_CODCLI
					AF1->AF1_LOJA	:= SUS->US_LOJACLI
					MsUnLock()
				EndIf
			Else
				msgalert('Prospect não localizado!', 'A T E N Ç Ã O')
				Return
			EndIf
		EndIf

		DbSelectArea('SA1')
		DbSetOrder(1)
		DbSeek(xFilial('SA1')+AF1->(AF1_CLIENT+AF1_LOJA))
		
		If MSGYESNO('Esse projeto será um complemento de OBRA existente? Verifique se existe um contrato e a OBRA esta ativa!!!', 'A T E N Ç Ã O')
		    c_query := " SELECT CTT_CUSTO, CTT_DESC01, CTT_XEND FROM "+RetSqlName('CTT')+" "
		    c_query += " where CTT_XCONT1+CTT_XLJCT1 in (select A1_COD+A1_LOJA from SA1010 where A1_CGC = '"+SA1->A1_CGC+"' and D_E_L_E_T_ <> '*')"
		    c_query += " and D_E_L_E_T_ <> '*'  "

			c_custo := U_FGEN008(c_query,{{"OBRA", "DESCRICAO", "ENDERECO"},{"CTT_CUSTO", "CTT_DESC01", "CTT_XEND"}},"Obras do cliente",1)

		  	If c_custo = nil
				If !CadNewCC()
	 				l_jafez := .F.
	 				Return
	 			EndIf
	  		Else
				DbSelectArea('CTT')
				DbSetOrder(1) 		
				If !DbSeek(xFilial('CTT')+c_custo)
					If !CadNewCC()
						l_jafez := .F.
						Return
					EndIf
				else
					cCompl := .T.   
                    nVLRC0 := CTT->CTT_XVLR
                    nVLRC1 := CTT->CTT_XVLRC1  
                    nVLRC2 := CTT->CTT_XVLRC2
                    nVLRC3 := CTT->CTT_XVLRC3
                    nVLRC4 := CTT->CTT_XVLRC4

				    RecLock('CTT', .F.)
					    CTT->CTT_XVLR += busca_vlrt(AF1->AF1_ORCAME)
	 				
		 				if Empty(CTT->CTT_XVLRC1)
		 					CTT->CTT_XVLRC1 := busca_vlrt(AF1->AF1_ORCAME)
		 				else
		 					if Empty(CTT->CTT_XVLRC2)
		 						CTT->CTT_XVLRC2 := busca_vlrt(AF1->AF1_ORCAME) 
		 					else
		 						if Empty(CTT->CTT_XVLRC3)
		 							CTT->CTT_XVLRC3 := busca_vlrt(AF1->AF1_ORCAME)
		 					    else
		 					    	if Empty(CTT->CTT_XVLRC4)
		 								CTT->CTT_XVLRC4 := busca_vlrt(AF1->AF1_ORCAME)
		 							EndIf	
		 					    EndIf
		 				 	EndIf
		 				EndIf	 	
	 				MsUnLock()   
				  	nOpcCTT := AxAltera('CTT',CTT->(RecNo()),3,,)	
					if nOpcCTT == 3
						RecLock('CTT', .F.)
							CTT->CTT_XVLR 	:= nVLRC0
		                    CTT->CTT_XVLRC1 := nVLRC1  
		                    CTT->CTT_XVLRC2 := nVLRC2  
		                    CTT->CTT_XVLRC3 := nVLRC3  
		                    CTT->CTT_XVLRC4 := nVLRC4  
						MsUnlock()
						cCompl := .F.
						l_jafez := .F.
						Return
					EndIf
				EndIf
			EndIf
		Else
			If !CadNewCC()
				l_jafez := .F.
				Return
			EndIf
		EndIf
		
		RecLock('CTT', .F.)
		CTT->CTT_XCONT1 := SA1->A1_COD
		CTT->CTT_XLJCT1 := SA1->A1_LOJA
		CTT->CTT_MSBLQL := '1'
		MsUnLock()

		If !Empty(MV_PAR01)                                                                                                                                                                                                                                                                                                 
			If ExistBlock("PMA110INC")                                                                                                                                                                                                                                                                                  
				If ExecBlock("PMA110INC", .T., .T.)
                                                                                                                                                                                                                                                                                                                                    
					If __lSX8
						ConfirmSX8()
					EndIf
                                                                                                                                                                                                                                                                                                                                    
					lRet := .F.                                                                                                                                                                                                                                                                                 
				End                                                                                                                                                                                                                                                                                                 
			EndIf                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                    
			If lRet                                                                                                                                                                                                                                                                                                     
				Processa({||PMS110Gera()}, "Gerando Projeto...") //
                                                                                                                                                                                                                                                                                                                                    
				If __lSX8                                                                                                                                                                                                                                                                                           
					ConfirmSX8()                                                                                                                                                                                                                                                                                
				EndIf                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
			EndIf                                                                                                                                                                                                                                                                                                       
		Else                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                    
			If __lSX8                                                                                                                                                                                                                                                                                                   
				RollBackSX8()                                                                                                                                                                                                                                                                                       
			EndIf                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                    
			Help(1, " ", "OBRIGAT", , , 3, 0)                                                                                                                                                                                                                                                                           
		EndIf
		
		RecLock('AF8', .F.)
		AF8->AF8_CODOBR := CTT->CTT_CUSTO
		AF8->AF8_CLIENT := SA1->A1_COD
		AF8->AF8_LOJA	:= SA1->A1_LOJA
		AF8->AF8_XPROP  := AF1->AF1_XPROP
		AF8->AF8_CLASSE	:= 	AF1->AF1_XCLASS
//		AF8->AF8_DESCA1 := GetAdvFval("SA1", "A1_NOME", xFilial("SA1")+SA1->(A1_COD+A1_LOJA), 1, '')
		AF8->AF8_ENDENT	:= AF1->AF1_XENDOB  
		//adionada para levar o conteudo do campo af1 municipio para af8 municipio 08/03/2013 - luiz henrique 
		AF8->AF8_MUNOBR := AF1->AF1_XMUNO  
		MsUnLock()
		
		RecLock('AF1', .F.)
		AF1->AF1_FASE := '08'
		AF1->AF1_XPROJ := AF8->AF8_PROJET
		AF1->AF1_XOBRA := CTT->CTT_CUSTO
		MsUnLock()
  
		EnviaEmail()		
	Else                                                                                                                                                                                                                                                                                                                        
		If __lSX8                                                                                                                                                                                                                                                                                                           
			RollBackSX8()                                                                                                                                                                                                                                                                                               
		EndIf                                                                                                                                                                                                                                                                                                               
	EndIf                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                    

EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
Return lRet                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                    
/*/                                                                                                                                                                                                                                                                                                                                 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                                                                                                                                                                                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                                                                                                                                                                                                                     
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±                                                                                                                                                                                                                                                     
±±³Fun‡…o    ³PMSSelAF3OP³ Autor ³Adriano Ueda           ³ Data ³ 26/04/2005³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Descri‡…o ³ Validação do produto para o usuário selecionar o opcional    ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Parametros³Nenhum                                                        ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Retorno   ³ .T., nenhum problema ocorreu                                 ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³ Uso      ³Generico                                                      ³±±                                                                                                                                                                                                                                                     
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±                                                                                                                                                                                                                                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                                                                                                                                                                                                                     
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                                                                                                                                                                                                                                                     
*/                                                                                                                                                                                                                                                                                                                                  
Static Function PMSSelAF3Opc()                                                                                                                                                                                                                                                                                                             
Local lRet := .T.                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                    
Local nPosProdut := aScan(aHeader, {|x| AllTrim(x[2])=="AF3_PRODUT"})                                                                                                                                                                                                                                                               
Local nPosOpc    := aScan(aHeader, {|x| AllTrim(x[2])=="AF3_OPC"})                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                    
Local cProduto := ""                                                                                                                                                                                                                                                                                                                
Local cRet := ""                                                                                                                                                                                                                                                                                                                    
Local aRetorOpc := {}                                                                                                                                                                                                                                                                                                               
Local cProdPai := ""                                                                                                                                                                                                                                                                                                                
Local cProdAnt := ""                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                    
If (nPosOpc > 0)                                                                                                                                                                                                                                                                                                                    
	cProduto := M->AF3_PRODUT                                                                                                                                                                                                                                                                                                   
	MarkOpc(cProduto, @cRet, aRetorOpc, cProdPai, cProdAnt, , , , 1 )                                                                                                                                                                                                                                                           
	                                                                                                                                                                                                                                                                                                                            
	aCols[n][nPosOpc] := cRet                                                                                                                                                                                                                                                                                                   
EndIf                                                                                                                                                                                                                                                                                                                               
Return lRet                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                    
/*/                                                                                                                                                                                                                                                                                                                                 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                                                                                                                                                                                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                                                                                                                                                                                                                     
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±                                                                                                                                                                                                                                                     
±±³Fun‡…o    ³PMSSelAFAOP³ Autor ³Adriano Ueda           ³ Data ³ 26/04/2005³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Descri‡…o ³ Validação do produto para o usuário selecionar o opcional    ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Parametros³Nenhum                                                        ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³Retorno   ³ .T., nenhum problema ocorreu                                 ³±±                                                                                                                                                                                                                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                                                                                                                                                                                                                                     
±±³ Uso      ³Generico                                                      ³±±                                                                                                                                                                                                                                                     
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±                                                                                                                                                                                                                                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                                                                                                                                                                                                                     
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                                                                                                                                                                                                                                                     
*/                                                                                                                                                                                                                                                                                                                                  
Static Function PMSSelAFAOpc()                                                                                                                                                                                                                                                                                                             
Local lRet := .T.                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                    
Local nPosProdut := aScan(aHeader, {|x| AllTrim(x[2])=="AFA_PRODUT"})                                                                                                                                                                                                                                                               
Local nPosOpc    := aScan(aHeader, {|x| AllTrim(x[2])=="AFA_OPC"})                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                    
Local cProduto := ""                                                                                                                                                                                                                                                                                                                
Local cRet := ""                                                                                                                                                                                                                                                                                                                    
Local aRetorOpc := {}                                                                                                                                                                                                                                                                                                               
Local cProdPai := ""                                                                                                                                                                                                                                                                                                                
Local cProdAnt := ""                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                    
If (nPosOpc > 0)                                                                                                                                                                                                                                                                                                                    
	cProduto := M->AFA_PRODUT                                                                                                                                                                                                                                                                                                   
	MarkOpc(cProduto, @cRet, aRetorOpc, cProdPai, cProdAnt, , , , 1 )                                                                                                                                                                                                                                                           
	                                                                                                                                                                                                                                                                                                                            
	aCols[n][nPosOpc] := cRet                                                                                                                                                                                                                                                                                                   
EndIf                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
lRet := PMS203ValP() //valido a alteracao do codigo do produto se houver planejamento                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                    
Return lRet                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                    
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
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados         ³±±                                                                                                                                                                                                                                                       
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
Local aRotina 	:= {	{ "Pesquisar","AxPesqui"  , 0 , 1, 0, .F.},; //
						{ "Visualizar","PMS100Dlg" , 0 , 2},; //
						{ "Gerar","U_PMSA110a", 0 , 3} } //
Return(aRotina)

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
	Private cCadastro		:= "Cadastro de Clientes - Atualização de Obra"
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
	Private c_chave2		:= {"CTT_XCONT1"}
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
		M->A1_NOME		:= SUS->US_NOME
		M->A1_NREDUZ	:= SUS->US_NREDUZ
		M->A1_END		:= SUS->US_END
		M->A1_TIPO		:= SUS->US_TIPO
		M->A1_NUN		:= SUS->US_MUN
		M->A1_BAIRRO	:= SUS->US_BAIRRO
		M->A1_EST		:= SUS->US_EST
		
		M->A1_ENDENT	:= AF1->AF1_XENDOB
		M->A1_BAIRROE	:= AF1->AF1_XBROBR
		M->A1_MUNE		:= AF1->AF1_XMUNO
		M->A1_ESTE		:= AF1->AF1_XESTOB
		M->A1_XCOMPE	:= AF1->AF1_XCOMPO
		M->A1_XREFENT	:= AF1->AF1_XREFOB
		M->A1_CEPE		:= AF1->AF1_XCEPOB
	Else
		M->CTT_DESC01	:= AF1->AF1_DESCRI
		M->CTT_XEND		:= AF1->AF1_XENDOB
		M->CTT_XMUN		:= AF1->AF1_XMUNO
		M->CTT_XUF		:= AF1->AF1_XESTOB
		M->CTT_XBAIRR	:= AF1->AF1_XBROBR       
		M->CTT_XCEP		:= AF1->AF1_XCEPOB
		M->CTT_XCOMP	:= AF1->AF1_XCOMPO
		M->CTT_XREF		:= AF1->AF1_XREFOB

		M->CTT_XCONT1	:= SA1->A1_COD
		M->CTT_XLJCT1	:= SA1->A1_LOJA  
		M->CTT_XVLR		:= busca_vlrt(AF1->AF1_ORCAME)
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

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK260ROT  ºAutor  ³Microsiga           º Data ³  08/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia o email para os responsaveis.                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnviaEmail()

	Local l_Continua	:= .T.
	
	Private c_texto 	  := ''
	Private c_msgerro	  := ''
	Private c_Org   	  := "\HTML\PMSA110.htm"   
	Private c_OrgComp     := "\HTML\PMSA110Comp.htm"
	Private c_Arq         := "\HTML\PMSA110Dir.htm"
	Private c_ArqComp     := "\HTML\PMSA110DirComp.htm"
	Private c_Dest   	  := "C:\siga.html"
	Private c_DestComp 	  := "C:\sigacomp.html"
	Private c_DestDir	  := "C:\dirsiga.html"
	Private c_DestDirC    := "C:\dirsigacomp.html"
	Private c_para		  := GetMV("MV_XMAILOB")
	Private c_maildir     := GetMV("MV_XMAILDI")
	Private c_CodProj     := ''
	Private c_CodEdt      := ''  
	Private c_ccusto      := 'm'
	Private c_ValObra     := ''
	Private c_Filial	  := ''
	Private c_NmFilial    := ''   
	Private clCusto		  := '' 
	Private clMark        := ''       
	Private nVlTotal      := 0
	Private nVlCust       := 0

    cNome_user := Busca_nome(__cuserid)

	c_ccusto  := CTT->CTT_CUSTO
	c_CodProj := AF8->AF8_PROJET//Posicione('AF8',8,xFilial('AF8')+CTT->CTT_CUSTO,'AF8_PROJET')
	c_CodEdt  := Posicione('AFC',4,xFilial('AFC')+c_CodProj+c_CodProj,'AFC_EDT')
	c_ValObra := TRANSFORM(Posicione('AFC',4,xFilial('AFC')+c_CodProj+c_Codedt,'AFC_TOTAL'), "@E 999,999,999.99")
	c_Filial  := Posicione('AF8',8,xFilial('AF8')+CTT->CTT_CUSTO,'AF8_MSFIL')      

	if !cCompl
		fArq(c_Org, c_Dest)
		If !U_FGEN010(c_para,"Inclusao de nova OBRA - Num: "+CTT->CTT_CUSTO+" Usuario: "+cnome_user+" ",c_texto,,.t.)	
			Return c_msgerro
		EndIf   
	else
		fArq(c_OrgComp,c_DestComp)  
		If !U_FGEN010(c_para,"Inclusao de novo COMPLEMENTO DE OBRA - Num: "+CTT->CTT_CUSTO+" Usuario: "+cnome_user+" ",c_texto,,.t.)	
			Return c_msgerro
		EndIf  
	EndIf	

	clAliasCTT := PMSASQLCUST()
	(clAliasCTT)->(DbGoTop())

	clCusto := 'R$ ' + Transform((clAliasCTT)->AFC_CUSTO, "@E 999,999,999.99")
	clMark  := 'R$ ' + Transform((clAliasCTT)->AFC_VALBDI, "@E 999,999,999.99") + ' - '
	nVlTotal:= (clAliasCTT)->AFC_TOTAL
	nVlCust := (clAliasCTT)->AFC_CUSTO
	
	clMark  += Str(Round(((nVlTotal/nVlCust)-1)*100,0)) + '%'
    
    c_texto := ''
    
    if !cCompl
		fArq(c_Arq, c_DestDir)    
		If !U_FGEN010(c_maildir,"Inclusao de nova OBRA - Num: "+CTT->CTT_CUSTO+" Usuario: "+cnome_user+" ",c_texto,,.t.)	
			Return c_msgerro
		EndIf 
	else
		fArq(c_ArqComp, c_DestDirC)    
		If !U_FGEN010(c_maildir,"Inclusao de novo COMPLEMENTO DE OBRA - Num: "+CTT->CTT_CUSTO+" Usuario: "+cnome_user+" ",c_texto,,.t.)	
			Return c_msgerro
		EndIf
	EndIf
Return ""  

Static Function PMSASQLCUST()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select AFC_CUSTO, AFC_VALBDI, AFC_TOTAL from %Table:AFC% AFC
 		inner join %Table:AF8% AF8 on AF8_PROJET=AFC_EDT AND AF8_REVISA=AFC_REVISA AND AF8.%NotDel% AND AF8_PROJET=%EXP:c_CodProj%
   		where AFC.%NotDel% 

	EndSql

Return(clAliasSql)     

Static Function fArq(c_FileOrig, c_FileDest)

	Local l_Ret 	:= .T.
	Local c_Buffer	:= ""
	Local n_Posicao	:= 0
	Local n_QtdReg	:= 0
	Local n_RegAtu	:= 0

	If !File(c_FileOrig)
		l_Ret := .F.
		MsgStop("Arquivo [ "+c_FileOrig+" ] não localizado.", "Não localizou")
	Else
		
		Ft_fuse( c_FileOrig ) 		// Abre o arquivo
		Ft_FGoTop()
		n_QtdReg := Ft_fLastRec()
		
		nHandle	:= MSFCREATE( c_FileDest )

		///////////////////////////////////
		// Carregar o array com os itens //
		///////////////////////////////////
		While !ft_fEof() .And. l_Ret
			
			c_Buffer := ft_fReadln()
			
			FWrite(nHandle, &("'" + c_Buffer + "'"))
			c_texto += &("'" + c_Buffer + "'")
			ft_fSkip()
			
		Enddo
		
		FClose(nHandle)

	Endif
	
Return l_Ret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Busca_NomeºAutor  ³Jean Cavalcante     º Data ³  09/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca o Nome do Usuário Logado.				              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Busca_Nome(c_User) 

	c_user := Iif(c_User=Nil, __CUSERID, c_user)

	_aUser := {}
	psworder(1)
	pswseek(c_user)
	_aUser := PSWRET()

	_cnome		:= Substr(_aUser[1,4],1,50)

Return(_cnome) 


Static Function CadNewCC()
	
	l_Ret := .T.
	n_opc := .F.
	
//	While(!n_opc)

		n_opc := ATMK001('CTT')
		If !n_opc
			msgalert('O cadastro da OBRA é obrigatório', 'A T E N Ç Ã O')
			l_Ret := .F.
		Else
			RecLock('AF1', .F.)
			AF1->AF1_XENDOB	:= Iif(Empty(AF1->AF1_XENDOB), CTT->CTT_XEND, AF1->AF1_XENDOB)
			AF1->AF1_XMUNO	:= Iif(Empty(AF1->AF1_XMUNO),  CTT->CTT_XMUN, AF1->AF1_XMUNO)
			AF1->AF1_XESTOB	:= Iif(Empty(AF1->AF1_XESTOB), CTT->CTT_XUF, AF1->AF1_XESTOB)
			AF1->AF1_XBROBR	:= Iif(Empty(AF1->AF1_XBROBR), CTT->CTT_XBAIRR, AF1->AF1_XBROBR)
			AF1->AF1_XCEPOB	:= Iif(Empty(AF1->AF1_XCEPOB), CTT->CTT_XCEP, AF1->AF1_XCEPOB)
			AF1->AF1_XCOMPO	:= Iif(Empty(AF1->AF1_XCOMPO), CTT->CTT_XCOMP, AF1->AF1_XCOMPO)
			AF1->AF1_XREFOB	:= Iif(Empty(AF1->AF1_XREFOB), CTT->CTT_XREF, AF1->AF1_XREFOB)
			MsUnLock()
		EndIf
		
//	EndDo

Return l_Ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGEN003   ºAutor  ³Alexandre Martins   º Data ³  09/26/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o proximo numero do alias informado.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FGEN003(c_Alias, c_campo, c_where, n_tam)

	Local c_Ret   := ""
	Local c_query := ""
	Local n_taman := Iif(n_tam=nil, 0, n_tam)
	Local a_Area  := GetArea()
	Local a_AreaX3:= SX3->(GetArea())

	c_where 	  := Iif(c_where=Nil, '', c_where)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o tamanho do campo              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If n_taman = 0
		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek(c_campo)
		n_taman := SX3->X3_TAMANHO
	EndIf

	c_query := "select max(" + c_campo + ") as NUM from "+RetSqlName(c_Alias)+" where "
	If !Empty(c_where)
		c_query += " " + c_where
	EndIf

	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "QRY"

	If QRY->(EOF()) .or. Empty(QRY->NUM)
		c_Ret 	:= StrZero(1,n_taman)
	Else
		c_Ret	:= substr(QRY->NUM,1,1) + StrZero(val(substr(QRY->NUM,2,9))+1,9)
	EndIf

	RestArea(a_AreaX3)
	RestArea(a_Area)
	
Return c_Ret



Static Function busca_vlrt(c_orcame)

	Local n_Ret := 0
	
	DbSelectArea('AF5')
	DbSetOrder(3)  //AF5_FILIAL, AF5_ORCAME, AF5_NIVEL, R_E_C_N_O_, D_E_L_E_T_
	
	If DbSeek(xFilial('AF5')+c_orcame+"001")
		n_Ret := AF5->AF5_TOTAL
	EndIf
	
Return n_Ret