#Include "protheus.ch"
#Include "topconn.ch"
#Include "rwmake.ch"
#include "ap5mail.ch"
#include "TbiConn.ch"
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#Define STR_PULA    Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MOrdServ � Autor � RICARDO CAVALINI   � Data �  13/12/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Esta fun��o cria a tela de Ordem de servico no modulo do   ���
���          � call center, visandoa documentacao da mesma.               ���
�������������������������������������������������������������������������͹��
���Uso       � call center --> Verion                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cEstrPrc()
//������������������������������������������������������Ŀ
//� Define Variaveis                                     �
//��������������������������������������������������������
Local aCores    := {}
Local aLegenda  := {}
PUBLIC _ctmp       := TIME()

// montagem das bolinhas coloridas
aCores:= {	{'!Empty(G1_COD)'  , 'ENABLE'           },;
			{'Empty(G1_COD) '  , 'DISABLE'          }}

Private aRotina := MenuDef()

//������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes           �
//��������������������������������������������������������
PRIVATE cCadastro := "Formacao Preco Estrutura - Verion"
//������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                          �
//��������������������������������������������������������
mBrowse(6,1,22,75,"SG1",,,,,,aCores)

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ZOrdServ � Autor � RICARDO CAVALINI   � Data �  13/12/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Esta fun��o cria a tela de Ordem de servico no modulo do   ���
���          � call center, visandoa documentacao da mesma.               ���
�������������������������������������������������������������������������͹��
���Uso       � call center --> Verion                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function rOrdServ(_nmnu)
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


local RC
Local nX
local gl
Local oRadio,oStatus,oStatu1,oStatu2,oStatu3,oStatu4,oPatente,oStatus,oTpLog
Local cStatus,cStatu1,cStatu2,cStatu3,cStatu4,cParente,cStatus
Local aPages	    := {"HEADER"}
Local aTitles	    := {}  // FOLDER�S DO PROGRAMA
Local aArrayF4	    := {}
Local aArrayline    := {}
Local aHeadCpos	    := {}
Local _cCD1         := ""
Local _CCT  		:= 0
Local _CCT3			:= ""
Local _cCt2 		:= ""
Private aCab        := {}
Private aItem       := {}
Private aReg        := {}
Private APOSOBJ     := {}                                                                                                  
Private aOper       := {"","1-Conserto","2-Estoque","3-Manutencao","4-Montagem","5-Transformacao","6-Usinagem","7-Fabrica","8-Eletronica"}
Private aOpGr       := {"","S-Sim","N-Nao"}
Private lMsErroAuto := .f.
Private oDlg
STATIC aBrwLF
STATIC aNFCab
Public _nvis        := _nmnu
Public cUsuMAST     := ""
aTpLogr             := {}

DEFINE FONT oBold NAME  "Times New Roman"    SIZE 0,20  BOLD

aSizeAut := MsAdvSize(,.F.,400)
aObjects := {}
aRecSF3	 := {}
AAdd( aObjects, { 000, 041, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 000, 075, .T., .F. } )
aInfo      := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj    := MsObjSize( aInfo, aObjects )
l103Class  := .F.
// Tratamento de combobox e radio
csitu      := ccivi   := _cTpLog := cStat  := ctpci := ""
oSitu      := oTitSex := ocivi   := oTpLog := oStat := otpci := ""
nTitSex    := NDEBITO := ndesfol := 1
_nDtConta  := 0

// Tela Principal do atendimento contribui��es Call Center
DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Estrutura" OF oMainWnd PIXEL
_cPrdOs   := SG1->G1_COD
_cDPrdOs  := POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_DESC")
__NVERCOM := POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_VERCOM")
__NCSTAND := POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_CUSTD")
__NUPRCOM := POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_UPRC")
__NFATOR  := POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_FATOR")
__CTPMOED := POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_TPMOEDA")
__CGRUPO  := POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_GRUPO")
__NGRFAT  := POSICIONE("SBM",1,XFILIAL("SBM")+__CGRUPO,"BM_FATOR")
__CGRMOED := POSICIONE("SBM",1,XFILIAL("SBM")+__CGRUPO,"BM_MOEDA")

@ 010,010 SAY OemToAnsi("Produto")               OF oDlg PIXEL SIZE 045,006
@ 010,045 MSGET _cPrdOs                          OF oDlg PIXEL SIZE 070,006 when .f.
@ 010,120 MSGET _cDPrdOs                         OF oDlg PIXEL SIZE 195,006 WHEN .F.

@ 025,010 SAY OemToAnsi("Vlr.Compra")            OF oDlg PIXEL SIZE 045,006
@ 025,045 MSGET __NVERCOM Picture "9999,999.99"  OF oDlg PIXEL SIZE 070,006 when .f.
@ 025,175 SAY OemToAnsi("C.Stand")               OF oDlg PIXEL SIZE 045,006
@ 025,215 MSGET __NCSTAND Picture "9999,999.99"  OF oDlg PIXEL SIZE 070,006 when .f.
@ 025,350 SAY OemToAnsi("Ult.Preco")             OF oDlg PIXEL SIZE 045,006
@ 025,390 MSGET __NUPRCOM Picture "9999,999.99"  OF oDlg PIXEL SIZE 070,006 when .f.

@ 040,010 SAY OemToAnsi("Fator PRD")             OF oDlg PIXEL SIZE 045,006
@ 040,045 MSGET __NFATOR Picture "9999,999.99"   OF oDlg PIXEL SIZE 070,006 when .f.
@ 040,175 SAY OemToAnsi("Moeda PRD")             OF oDlg PIXEL SIZE 045,006
@ 040,215 MSGET __CTPMOED                        OF oDlg PIXEL SIZE 070,006 when .f.
@ 040,350 SAY OemToAnsi("Grupo PRD")             OF oDlg PIXEL SIZE 045,006
@ 040,390 MSGET __CGRUPO                         OF oDlg PIXEL SIZE 070,006 when .f.

@ 055,010 SAY OemToAnsi("Fator Grp")             OF oDlg PIXEL SIZE 045,006
@ 055,045 MSGET __NGRFAT Picture "9999,999.99"   OF oDlg PIXEL SIZE 070,006 when .f.
@ 055,175 SAY OemToAnsi("Moeda Grp")             OF oDlg PIXEL SIZE 045,006
@ 055,215 MSGET __CGRMOED                        OF oDlg PIXEL SIZE 070,006 when .f.

aTitlex  := {}
aTitlex  := XVERESTR(SG1->G1_COD)
__NOMTIT := "{"                                                                                   
                                                                                   
for gl := 1 to len(aTitlex)         
    IF len(aTitlex) > 1                   
       IF GL < len(aTitlex) 
          __NOMTIT += '"'+aTitlex[GL,1] +'",'                                                                                   
       ELSE 
         __NOMTIT += '"'+aTitlex[GL,1] +'"}'                                                                                          
       ENDIF 
    
    ELSE
        __NOMTIT += '"'+aTitlex[GL,1] +'"}'                                                                                   
    ENDIF    

NEXT

ATITLES := &__NOMTIT

//��������������������������������������������������������������Ŀ
//�Define a area do rodape da rotina                             �
//����������������������������������������������������������������
oFolder := TFolder():New(075,004,aTitles,aPages,oDlg,,,, .T., .F.,646,190,)

//acerto no folder para nao perder o foco
For nX := 1 to Len(oFolder:aDialogs)
	DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nX]
Next nX


FOR RC := 1 TO LEN(ATITLES)
__CCMPRA := ATITLES[RC]
cquer5   := ""

//��������������������������������������������������������������Ŀ
//�Folder de modificacao                                     �
//����������������������������������������������������������������
oFolder:aDialogs[RC]:oFont := oDlg:oFont
// Campos do Grid Contatos
aHeadSZD  := {}
acolSZD   := {}
nOpc      := 0
nusado    := 0

Aadd(aHeadSZD ,{"Produto"    ,"PRODUTO"    ,PesqPict("SB1","B1_COD"    ,15),15,0,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Quantidade" ,"QUANTIDADE" ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"N",,""})
Aadd(aHeadSZD ,{"Prd_Moeda"  ,"MOEDA"      ,PesqPict("SB1","B1_TPMOEDA",01),01,0,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Prd_Fator"  ,"PRDFATOR"   ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Vlr.Compras","VLRCOMPRAS" ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"N",,""})
Aadd(aHeadSZD ,{"Vlr.Custand","VLRCUSTAND" ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"N",,""})
Aadd(aHeadSZD ,{"Vlr.Ult.Prc","VLRULTIMOP" ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"N",,""})
Aadd(aHeadSZD ,{"Vlr.Custo"  ,"VLRCUSTOPR" ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"N",,""})
Aadd(aHeadSZD ,{"Grupo"      ,"GRUPO"      ,PesqPict("SB1","B1_GRUPO"  ,06),06,0,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Grp_Moeda"  ,"GRPMOEDA"   ,PesqPict("SB1","B1_TPMOEDA",01),01,0,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Grp_Fator"  ,"GRPFATOR"   ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Estrutura"  ,"ESTRUTURA"  ,PesqPict("SB1","B1_ESTRUT" ,03),03,0,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Bloqueado"  ,"BLOQUEADO"  ,PesqPict("SB1","B1_MSBLQL" ,03),03,0,"",USADO,"C",,""})
Aadd(aHeadSZD ,{"Vlr.Bruto"  ,"VLRBRUTO"   ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"N",,""})
Aadd(aHeadSZD ,{"Qtd_x_Bruto","VLRTOTAL"   ,PesqPictQt("C2_QUANT"      ,14),14,2,"",USADO,"N",,""})


// SELECT dos CONTATOS DA EMPRESA CONTRIBUINTE
cquer5 := "SELECT G1_COMP,G1_QUANT,B1_TPMOEDA,B1_FATOR,B1_VERCOM,B1_CUSTD,B1_UPRC,B1_VLCUSTO,B1_GRUPO,BM_MOEDA,BM_FATOR,"
cquer5 += " 	  (CASE B1_ESTRUT "
cquer5 += " 	   WHEN '1' THEN 'KIT' "
cquer5 += " 	   WHEN '2' THEN 'SUB_KIT'"
cquer5 += " 	   ELSE 'PECA'             "
cquer5 += " 	   END)'B1_ESTRUT',         "
cquer5 += "     (CASE B1_MSBLQL         "
cquer5 += " 	   WHEN '1' THEN 'SIM'      "
cquer5 += " 	   WHEN '2' THEN 'NAO' "
cquer5 += " 	   ELSE 'NAO' "
cquer5 += " 	   END) 'B1_MSBLQL', "
cquer5 += " B1_VLBRUTO,(G1_QUANT*B1_VLBRUTO) TOT_ESTR "
cquer5 += " FROM "+RetSqlName("SG1")+" G1 (NOLOCK) "
cquer5 += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON B1_COD = G1_COMP AND B1.D_E_L_E_T_ = '' "
cquer5 += " INNER JOIN "+RetSqlName("SBM")+" BM (NOLOCK) ON BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = '' "
cquer5 += " WHERE G1_COD = '" + __CCMPRA + "' AND G1.D_E_L_E_T_ = '' "
cquer5 += " ORDER BY 1"

	
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuer5 NEW ALIAS "QUER5"
	
// Arquivo Temporario resultado do Select nas tabelas: Socio,Endereco,Empresa
DBSELECTAREA("QUER5")
DBGOTOP()
While !Eof()
		aAuxSZD := {}
		
		_cCT01  := quer5->G1_COMP   
		_cCT02  := quer5->G1_QUANT  
		_cCT03  := quer5->B1_TPMOEDA
		_CCT04  := quer5->B1_FATOR
		_cCT05  := quer5->B1_VERCOM
		_cCT06  := quer5->B1_CUSTD
		_cCT07  := quer5->B1_UPRC
		_CCT08  := quer5->B1_VLCUSTO
		_CCT09  := quer5->B1_GRUPO
		_CCT10  := quer5->BM_MOEDA
		_CCT11  := quer5->BM_FATOR
		_CCT12  := quer5->B1_ESTRUT
		_CCT13  := quer5->B1_MSBLQL
		_CCT14  := quer5->B1_VLBRUTO
		_CCT15  := quer5->TOT_ESTR

		AADD(aAuxSZD ,_cCT01)
		AADD(aAuxSZD ,_cCT02)
		AADD(aAuxSZD ,_cCT03)
		AADD(aAuxSZD ,_cCT04)
		AADD(aAuxSZD ,_cCT05)
		AADD(aAuxSZD ,_cCT06)
		AADD(aAuxSZD ,_cCT07)
		AADD(aAuxSZD ,_cCT08)
		AADD(aAuxSZD ,_cCT09)
		AADD(aAuxSZD ,_cCT10)
		AADD(aAuxSZD ,_cCT11)
		AADD(aAuxSZD ,_cCT12)
		AADD(aAuxSZD ,_cCT13)
		AADD(aAuxSZD ,_cCT14)
		AADD(aAuxSZD ,_cCT15)
		AADD(aAuxSZD ,.F.)
		
		Aadd(aColSZD,aAuxSZD)
		
		DbSkip()
End
	
DBSELECTAREA("QUER5")
DBCLOSEAREA("QUER5")
	

// Monta Grid de Contatos Vazio.
oOcorSZD := MsNewGetDados():New(000,000,175,645,nOpc,"U_ASZvLinOk","U_ASZvTUDOK","",,,999,"AllwaysTrue","","AllwaysTrue",oFolder:aDialogs[rc],aHeadSZD,acolSZD)
NEXT

// Grupo de Bot�es do Cabe�alho da tela Principal
SButton():New(025, 610, 01, {|| Executa(_nmnu)    },,.T.,"Cofirma")
SButton():New(040, 610, 02, {|| oDlg:End()        },,.T.,"Cancela")
SButton():New(055, 610, 13, {|| VERPLAxx()        },,.T.,"Planilha")
ACTIVATE DIALOG oDlg CENTER
Return

//��������������������������������������������������������������Ŀ
//�Fun��o do Bot�o(OK) do Cabe�alho da tela Principal           �
//����������������������������������������������������������������
Static Function Executa(_nmnu)
oDlg:End()
Return

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Marco Bianchi         � Data �01/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados         ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()

Private aRotina := {{ "Pesquisar"   ,"AxPesqui"         ,0,1,0,.F.},;
					{ "Visualizar"  ,"u_rOrdServ(1)"	,0,2,0,NIL},;
					{ "Legenda"     ,"u_LEGx80()"       ,0,5,0,NIL} }
Return(aRotina)

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �          � Autor � Ricardo Cavalini      � Data �20/12/2012���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcoes genericas usadas nos folder. Funcoes tais          ���
���          � valida��o, preenchimento de telas, etc....                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// -----------------------------  FIM FOLDER SERV EXECUTADO  -------------------------- //
// FUNCAO NA VALIDACAO DA LINHA DO FOLDER MODIFICACAO
USER FUNCTION ASZvLinOk()
lSZD2 := .T.
oOcorSZD:Refresh()
Return lSZD2

// -------------------------------------------------
// FUNCAO NA VALIDACAO DA TODO O FOLDER MODIFICACAO
USER FUNCTION ASZvTUDOk()
lSZD2T := .T.
Return(lSZD2T)                                         


//==========================================
// ACHA OS SUB KIT DA ESTRUTURA PRINCIPAL
//==========================================
STATIC FUNCTION XVERESTR(PRDVER)

__ATITU := {}
AADD(__ATITU,{PRDVER})

_cquery := ""
_cquery := "SELECT G1_COD,G1_COMP FROM " + RetSqlName("SG1") + " G11B (NOLOCK) "
_cquery += "INNER JOIN " + RetSqlName("SB1") + " B11B (NOLOCK) ON B11B.B1_COD = G11B.G1_COMP AND B11B.B1_ESTRUT IN ('1','2') AND B11B.D_E_L_E_T_ = '' AND G11B.D_E_L_E_T_ = '' "
_cquery += "WHERE G1_COD =  '" + PRDVER + "' AND G11B.D_E_L_E_T_ = '' "
_cquery += "UNION ALL "
_cquery += "SELECT G1_COD,G1_COMP FROM  " + RetSqlName("SG1") + " G11A (NOLOCK) "
_cquery += "INNER JOIN  " + RetSqlName("SB1") + " B11A (NOLOCK) ON B11A.B1_COD = G11A.G1_COMP AND B11A.B1_ESTRUT IN ('1','2') AND B11A.D_E_L_E_T_ = '' AND G11A.D_E_L_E_T_ = '' "
_cquery += "WHERE G1_COD IN ( SELECT G1_COMP FROM  " + RetSqlName("SG1") + " G11B (NOLOCK) "
_cquery += "INNER JOIN  " + RetSqlName("SB1") + " B11B (NOLOCK) ON B11B.B1_COD = G11B.G1_COMP AND B11B.B1_ESTRUT IN ('1','2') AND B11B.D_E_L_E_T_ = '' AND G11A.D_E_L_E_T_ = '' "
_cquery += "WHERE G1_COD =  '" + PRDVER + "' AND G11B.D_E_L_E_T_ = '') "
_cquery += "UNION ALL "
_cquery += "SELECT G1_COD,G1_COMP FROM  " + RetSqlName("SG1") + " G12B (NOLOCK) "
_cquery += "INNER JOIN  " + RetSqlName("SB1") + " B12B (NOLOCK) ON B12B.B1_COD = G12B.G1_COMP AND B12B.B1_ESTRUT IN ('1','2') AND B12B.D_E_L_E_T_ = '' AND G12B.D_E_L_E_T_ = '' "
_cquery += "WHERE G1_COD IN (SELECT G1_COMP FROM  " + RetSqlName("SG1") + "   G11A (NOLOCK) "
_cquery += "INNER JOIN  " + RetSqlName("SB1") + "  B11A (NOLOCK) ON B11A.B1_COD = G11A.G1_COMP AND B11A.B1_ESTRUT IN ('1','2') AND B11A.D_E_L_E_T_ = '' "
_cquery += "WHERE G1_COD IN ( SELECT G1_COMP FROM  " + RetSqlName("SG1") + " G11B (NOLOCK) "
_cquery += "INNER JOIN  " + RetSqlName("SB1") + " B11B (NOLOCK) ON B11B.B1_COD = G11B.G1_COMP AND B11B.B1_ESTRUT IN ('1','2') AND B11B.D_E_L_E_T_ = '' "
_cquery += "WHERE G1_COD =  '" + PRDVER + "' AND G11B.D_E_L_E_T_ = '') AND G11A.D_E_L_E_T_ = '')  AND G12B.D_E_L_E_T_ = '' "

//TCQuery Abre uma workarea com o resultado da query
TCQUERY _cquery NEW ALIAS "VBESTR"



// Arquivo Temporario resultado do Select nas tabelas: Socio,Endereco,Empresa
DBSELECTAREA("VBESTR")
DBGOTOP()
While !Eof()
      
      _CCVERPR := VBESTR->G1_COMP
      AADD(__ATITU,{_CCVERPR})
      
    DBSELECTAREA("VBESTR")  
	DbSkip()
	Loop
End

DBSELECTAREA("VBESTR")
DBCLOSEAREA("VBESTR")
RETURN(__ATITU)

// GERACAO DE PLANILHA EXCELL....
// CONFORME TELA APRESENTADA.....

/*/{Protheus.doc} zTstExc1
Fun��o que cria um exemplo de FWMsExcel
@author Atilio
@since 06/08/2016
@version 1.0
    @example
    u_zTstExc1()
/*/
 
STATIC FUNCTION VERPLAxx()
Local aArea        := GetArea()
    
    local JP
    Local cQuery        := ""
    Local oFWMsExcel
    Local oExcel
    Local cArquivo    := GetTempPath()+'zTstExc1.xml'
    
    aTitler  := XVERESTR(SG1->G1_COD)
 
    //Criando o objeto que ir� gerar o conte�do do Excel
    oFWMsExcel := FWMSExcel():New()

	FOR JP := 1 TO LEN(ATITLEr)
        __CXMPRA  := ATITLEr[JP,1]
        __CABAVER := "ABA - " + __CXMPRA + " - "+ Str(JP)
        __CABASUB := __CXMPRA 

    	//CRIANDO A ABA - Produtos
	    oFWMsExcel:AddworkSheet(__CABAVER)

        //Criando a Tabela
         oFWMsExcel:AddTable(__CABAVER,__CABASUB)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Produto"     ,1)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Quantidade"  ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Prd_Moeda"   ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Prd_Fator"   ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Vlr.Compras" ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Vlr.Stand"   ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Vlr.Ult.Prc" ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Vlr.Custo"   ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Grupo"       ,1)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Grp_Moeda"   ,1)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Grp_Fator"   ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Prd_Fator"   ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Estrutura"   ,1)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Bloqueado"   ,1)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Vlr.Bruto"   ,2)
        oFWMsExcel:AddColumn(__CABAVER,__CABASUB,"Qtd_X_Bruto" ,2)


		// SELECT dos CONTATOS DA EMPRESA CONTRIBUINTE
		cquer7 := "SELECT G1_COMP,G1_QUANT,B1_TPMOEDA,B1_FATOR,B1_VERCOM,B1_CUSTD,B1_UPRC,B1_VLCUSTO,B1_GRUPO,BM_MOEDA,BM_FATOR,"
		cquer7 += " 	  (CASE B1_ESTRUT "
		cquer7 += " 	   WHEN '1' THEN 'KIT' "
		cquer7 += " 	   WHEN '2' THEN 'SUB_KIT'"
		cquer7 += " 	   ELSE 'PECA'             "
		cquer7 += " 	   END)'B1_ESTRUT',         "
		cquer7 += "     (CASE B1_MSBLQL         "
		cquer7 += " 	   WHEN '1' THEN 'SIM'      "
		cquer7 += " 	   WHEN '2' THEN 'NAO' "
		cquer7 += " 	   ELSE 'NAO' "
		cquer7 += " 	   END) 'B1_MSBLQL', "
		cquer7 += " B1_VLBRUTO,(G1_QUANT*B1_VLBRUTO) TOT_ESTR "
		cquer7 += " FROM "+RetSqlName("SG1")+" G1 (NOLOCK) "
		cquer7 += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON B1_COD = G1_COMP AND B1.D_E_L_E_T_ = '' "
		cquer7 += " INNER JOIN "+RetSqlName("SBM")+" BM (NOLOCK) ON BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = '' "
		cquer7 += " WHERE G1_COD = '" + __CXMPRA + "' AND G1.D_E_L_E_T_ = '' "
		cquer7 += " ORDER BY 1"

	
		//TCQuery Abre uma workarea com o resultado da query
		TCQUERY cQuer7 NEW ALIAS "QRYPRO"

        //Criando as Linhas... Enquanto n�o for fim da query
        While !(QRYPRO->(EoF()))
            oFWMsExcel:AddRow(__CABAVER,__CABASUB,{QRYPRO->G1_COMP    ,;
                                                   QRYPRO->G1_QUANT   ,;
                                                   QRYPRO->B1_TPMOEDA ,;
                                                   QRYPRO->B1_FATOR   ,;
                                                   QRYPRO->B1_VERCOM  ,;
                                                   QRYPRO->B1_CUSTD   ,;
                                                   QRYPRO->B1_UPRC    ,;
                                                   QRYPRO->B1_VLCUSTO ,;
                                                   QRYPRO->B1_GRUPO   ,;
                                                   QRYPRO->BM_MOEDA   ,;
                                                   QRYPRO->BM_FATOR   ,;                                 
                                                   QRYPRO->B1_ESTRUT  ,;
                                                   QRYPRO->B1_MSBLQL  ,;
                                                   QRYPRO->B1_VLBRUTO ,;
                                                   QRYPRO->TOT_ESTR   ,;
            })
         
            //Pulando Registro
            QRYPRO->(DbSkip())
        End
        
		DBSELECTAREA("QRYPRO")
		DBCLOSEAREA("QRYPRO")
     NEXT   
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
     
    RestArea(aArea)
Return