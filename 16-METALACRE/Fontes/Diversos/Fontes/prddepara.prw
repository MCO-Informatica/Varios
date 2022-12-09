#include "TOPCONN.CH"
#include "rwmake.ch"

User Function prddepara()   


// 20/4/2006 - baseado na versão 8.11

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Funcao    :  PRDDEPARA| Autor : Claudenilson Dias    | Data : 20.04.06   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Descricao : Troca codido do produto nas tabelas indicadas                ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Uso       : TODAS AS ROTINAS                                             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

//If !UPPER(ALLTRIM(SUBSTR(cusuario,7,15))) $ "ADMINISTRADOR/EDUARDO/RAIOL/LIMA/AFONSO"
//     Alert(substr(cUSUARIO,7,15)+" Usuario nao autorizado a usar esta rotina!!!")
//     Return nil
//EndIf

_cAreexp    := Alias()
_nRecexp    := Recno()
_cIndexp    := IndexOrd()
_nNumCorr   := 0
lEnd        := .f.

_cMsg1  := "Este programa tem a finalidade de trocar os codigos de produtos existentes por outros"
_cMsg2  := "definidos pelo usuário em tabelas pre-existentes.                                     "
_cMsg3  := ""
_cMsg4  := ""
_cMsg5  := ""
_cMsg6  := ""
_cMsg7  := ""
_cMsg8  := ""
_cMsg9  := ""
_cMsg10 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha a tela de processamento..........                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 000,00 TO 320,520 DIALOG oDlg TITLE "Troca de Codigo de Produtos"

@ 020,010 Say _cMsg1
@ 030,010 Say _cMsg2
@ 040,010 Say _cMsg3
@ 050,010 Say _cMsg4
@ 060,010 Say _cMsg5
@ 070,010 Say _cMsg6
@ 080,010 Say _cMsg7
@ 090,010 Say _cMsg8
@ 110,010 Say _cMsg9
@ 125,010 Say _cMsg10

@ 010,005 TO 135,260

//@ 145,010 BmpButton Type 05  ACTION _Param()
@ 145,060 BmpButton Type 01  ACTION OkProc(@lEnd)
@ 145,110 BmpButton Type 02  ACTION Close(oDlg)


ACTIVATE DIALOG oDlg CENTERED

dbselectarea(_cAreexp)
dbsetorder(_cIndexp)
dbgoto(_nRecexp)

Return nil


//************************************
Static Function OkProc(lEnd)
//************************************
  
  
	oProcess := MsNewProcess():New( { || RunProc(@lEnd) } , "Processando De Para" , "Aguarde..." , .F. )
    oProcess:Activate()

Return(nil)


//************************************
Static Function RunProc(lEnd)
//************************************

_lTOP := .f.

If __cRDD == "TOPCONN"
   _lTOP := .t.
Endif

If ! _lTop
	alert("Programa desenvolvido apenas para a versão SQL !!!")
	return nil
Endif


_cCodVelho := ''
_cCodNovo  := ''
_cCodEmp   := cEmpAnt
_cCodFil   := xFilial()


// vetor com os campos a serem substituidos
// 1 - Chave do Sx2
// 2 - Nome do arquivo no SX2
// 3 - Modo E - Exclusivo ou C - Compartilhado (X - Nao encontrado no SX2)
// 4 - Nome do campo
// 5 - Existe "S" ou nao "N" o arquivo no database

_aCpoPro := {}
aadd(_aCpoPro,{"AA3", "" ,"X" ,"AA3_CODPRO","N"})
aadd(_aCpoPro,{"AA4", "" ,"X" ,"AA4_CODPRO","N"})
aadd(_aCpoPro,{"AA4", "" ,"X" ,"AA4_PRODAC","N"})
aadd(_aCpoPro,{"AA6", "" ,"X" ,"AA6_CODPRO","N"})
aadd(_aCpoPro,{"AA6", "" ,"X" ,"AA6_PRODUT","N"})
aadd(_aCpoPro,{"AA7", "" ,"X" ,"AA7_CODPRO","N"})
aadd(_aCpoPro,{"AAB", "" ,"X" ,"AAB_CODPRO","N"})
aadd(_aCpoPro,{"AAC", "" ,"X" ,"AAC_CODPRO","N"})
aadd(_aCpoPro,{"AAF", "" ,"X" ,"AAF_CODPRO","N"})
aadd(_aCpoPro,{"AAF", "" ,"X" ,"AAF_PRODAC","N"})
aadd(_aCpoPro,{"AAH", "" ,"X" ,"AAH_CODPRO","N"})
aadd(_aCpoPro,{"AAI", "" ,"X" ,"AAI_CODPRO","N"})
aadd(_aCpoPro,{"AAK", "" ,"X" ,"AAK_CODPRO","N"})
aadd(_aCpoPro,{"AAK", "" ,"X" ,"AAK_CODCOM","N"})
aadd(_aCpoPro,{"AAL", "" ,"X" ,"AAL_CODCOM","N"})
aadd(_aCpoPro,{"AAL", "" ,"X" ,"AAL_CODPRO","N"})
aadd(_aCpoPro,{"AAN", "" ,"X" ,"AAN_CODPRO","N"})
aadd(_aCpoPro,{"AAO", "" ,"X" ,"AAO_CODPRO","N"})
aadd(_aCpoPro,{"AB2", "" ,"X" ,"AB2_CODPRO","N"})
aadd(_aCpoPro,{"AB4", "" ,"X" ,"AB4_CODPRO","N"})
aadd(_aCpoPro,{"AB5", "" ,"X" ,"AB5_CODPRO","N"})
aadd(_aCpoPro,{"AB7", "" ,"X" ,"AB7_CODPRO","N"})
aadd(_aCpoPro,{"AB8", "" ,"X" ,"AB8_CODPRO","N"})
aadd(_aCpoPro,{"AB8", "" ,"X" ,"AB8_CODPRD","N"})
aadd(_aCpoPro,{"AB9", "" ,"X" ,"AB9_CODPRO","N"})
aadd(_aCpoPro,{"ABA", "" ,"X" ,"ABA_CODPRO","N"})
aadd(_aCpoPro,{"ABA", "" ,"X" ,"ABA_ANTPRO","N"})
aadd(_aCpoPro,{"ABC", "" ,"X" ,"ABC_CODPRO","N"})
aadd(_aCpoPro,{"ABD", "" ,"X" ,"ABD_CODPRO","N"})
aadd(_aCpoPro,{"ABE", "" ,"X" ,"ABE_CODPRO","N"})
aadd(_aCpoPro,{"ABG", "" ,"X" ,"ABG_CODPRO","N"})
aadd(_aCpoPro,{"ABH", "" ,"X" ,"ABH_CODPRO","N"})
aadd(_aCpoPro,{"ACL", "" ,"X" ,"ACL_CODPRO","N"})
aadd(_aCpoPro,{"ACN", "" ,"X" ,"ACN_CODPRO","N"})
aadd(_aCpoPro,{"ACP", "" ,"X" ,"ACP_CODPRO","N"})
aadd(_aCpoPro,{"ACQ", "" ,"X" ,"ACQ_CODPRO","N"})
aadd(_aCpoPro,{"ACR", "" ,"X" ,"ACR_CODPRO","N"})
aadd(_aCpoPro,{"ACX", "" ,"X" ,"ACX_CODPRO","N"})
aadd(_aCpoPro,{"AD1", "" ,"X" ,"AD1_CODPRO","N"})
aadd(_aCpoPro,{"AD6", "" ,"X" ,"AD6_CODPRO","N"})
aadd(_aCpoPro,{"ADB", "" ,"X" ,"ADB_CODPRO","N"})
aadd(_aCpoPro,{"ADC", "" ,"X" ,"ADC_CODPRO","N"})
aadd(_aCpoPro,{"AE2", "" ,"X" ,"AE2_PRODUT","N"})
aadd(_aCpoPro,{"AE8", "" ,"X" ,"AE8_PRODUT","N"})
aadd(_aCpoPro,{"AE8", "" ,"X" ,"AE8_PRDREA","N"})
aadd(_aCpoPro,{"AF3", "" ,"X" ,"AF3_PRODUT","N"})
aadd(_aCpoPro,{"AF9", "" ,"X" ,"AF9_PRODFA","N"})
aadd(_aCpoPro,{"AFA", "" ,"X" ,"AFA_PRODUT","N"})
aadd(_aCpoPro,{"AFA", "" ,"X" ,"AFA_PRODFA","N"})
aadd(_aCpoPro,{"AFB", "" ,"X" ,"AFB_PRODFA","N"})
aadd(_aCpoPro,{"AFG", "" ,"X" ,"AFG_COD   ","N"})
aadd(_aCpoPro,{"AFH", "" ,"X" ,"AFH_COD   ","N"})
aadd(_aCpoPro,{"AFI", "" ,"X" ,"AFI_COD   ","N"})
aadd(_aCpoPro,{"AFJ", "" ,"X" ,"AFJ_COD   ","N"})
aadd(_aCpoPro,{"AFK", "" ,"X" ,"AFK_PRDDE ","N"})
aadd(_aCpoPro,{"AFK", "" ,"X" ,"AFK_PRDATE","N"})
aadd(_aCpoPro,{"AFL", "" ,"X" ,"AFL_COD   ","N"})
aadd(_aCpoPro,{"AFM", "" ,"X" ,"AFM_COD   ","N"})
aadd(_aCpoPro,{"AFN", "" ,"X" ,"AFN_COD   ","N"})
aadd(_aCpoPro,{"AFO", "" ,"X" ,"AFO_COD   ","N"})
aadd(_aCpoPro,{"AFS", "" ,"X" ,"AFS_COD   ","N"})
aadd(_aCpoPro,{"AFU", "" ,"X" ,"AFU_COD   ","N"})
aadd(_aCpoPro,{"AH1", "" ,"X" ,"AH1_PRODUT","N"})
aadd(_aCpoPro,{"AH1", "" ,"X" ,"AH1_MASTER","N"})
aadd(_aCpoPro,{"AH2", "" ,"X" ,"AH2_PRODUT","N"})
aadd(_aCpoPro,{"AH3", "" ,"X" ,"AH3_PRODUT","N"})
aadd(_aCpoPro,{"AH4", "" ,"X" ,"AH4_PRODUT","N"})
aadd(_aCpoPro,{"AH5", "" ,"X" ,"AH5_PRODUT","N"})
aadd(_aCpoPro,{"AH6", "" ,"X" ,"AH6_PRODUT","N"})
aadd(_aCpoPro,{"AH7", "" ,"X" ,"AH7_PRODUT","N"})
aadd(_aCpoPro,{"AH8", "" ,"X" ,"AH8_CODPRO","N"})
aadd(_aCpoPro,{"AH8", "" ,"X" ,"AH8_PRODUT","N"})
aadd(_aCpoPro,{"AHA", "" ,"X" ,"AHA_PRODUT","N"})
aadd(_aCpoPro,{"AHB", "" ,"X" ,"AHB_PRODUT","N"})
aadd(_aCpoPro,{"AHE", "" ,"X" ,"AHE_CODPRO","N"})
aadd(_aCpoPro,{"AHE", "" ,"X" ,"AHE_PRODUT","N"})
aadd(_aCpoPro,{"AI2", "" ,"X" ,"AI2_CODPRO","N"})
aadd(_aCpoPro,{"AIB", "" ,"X" ,"AIB_CODPRO","N"})
aadd(_aCpoPro,{"AIB", "" ,"X" ,"AIB_CODPRF","N"})
aadd(_aCpoPro,{"AIC", "" ,"X" ,"AIC_PRODUT","N"})
aadd(_aCpoPro,{"AJ7", "" ,"X" ,"AJ7_COD   ","N"})
aadd(_aCpoPro,{"AJA", "" ,"X" ,"AJA_PRODUT","N"})
aadd(_aCpoPro,{"AJC", "" ,"X" ,"AJC_COD   ","N"})
aadd(_aCpoPro,{"DA1", "" ,"X" ,"DA1_CODPRO","N"})
aadd(_aCpoPro,{"DA2", "" ,"X" ,"DA2_PROD  ","N"})
aadd(_aCpoPro,{"DB3", "" ,"X" ,"DB3_CODPRO","N"})
aadd(_aCpoPro,{"DBN", "" ,"X" ,"DBN_CODPRO","N"})
aadd(_aCpoPro,{"DC3", "" ,"X" ,"DC3_CODPRO","N"})
aadd(_aCpoPro,{"DCF", "" ,"X" ,"DCF_CODPRO","N"})
aadd(_aCpoPro,{"DCG", "" ,"X" ,"DCG_CODPRO","N"})
aadd(_aCpoPro,{"DCH", "" ,"X" ,"DCH_CODPRO","N"})
aadd(_aCpoPro,{"DCN", "" ,"X" ,"DCN_PROD  ","N"})
aadd(_aCpoPro,{"DCP", "" ,"X" ,"DCP_CODPRO","N"})
aadd(_aCpoPro,{"DE5", "" ,"X" ,"DE5_CODPRO","N"})
aadd(_aCpoPro,{"DE7", "" ,"X" ,"DE7_CODPRO","N"})
aadd(_aCpoPro,{"DE7", "" ,"X" ,"DE7_PRDEMB","N"})
aadd(_aCpoPro,{"DF2", "" ,"X" ,"DF2_CODPRO","N"})
aadd(_aCpoPro,{"DF3", "" ,"X" ,"DF3_CODPRO","N"})
aadd(_aCpoPro,{"DF4", "" ,"X" ,"DF4_CODPRO","N"})
aadd(_aCpoPro,{"DT0", "" ,"X" ,"DT0_CODPRO","N"})
aadd(_aCpoPro,{"DT1", "" ,"X" ,"DT1_CODPRO","N"})
aadd(_aCpoPro,{"DT8", "" ,"X" ,"DT8_CODPRO","N"})
aadd(_aCpoPro,{"DTC", "" ,"X" ,"DTC_CODPRO","N"})
aadd(_aCpoPro,{"DTE", "" ,"X" ,"DTE_CODPRO","N"})
aadd(_aCpoPro,{"DTK", "" ,"X" ,"DTK_CODPRO","N"})
aadd(_aCpoPro,{"DTV", "" ,"X" ,"DTV_CODPRO","N"})
aadd(_aCpoPro,{"DU5", "" ,"X" ,"DU5_CODPRO","N"})
aadd(_aCpoPro,{"DUC", "" ,"X" ,"DUC_CODPRO","N"})
aadd(_aCpoPro,{"DUH", "" ,"X" ,"DUH_CODPRO","N"})
aadd(_aCpoPro,{"DUI", "" ,"X" ,"DUI_CODPRO","N"})
aadd(_aCpoPro,{"DUI", "" ,"X" ,"DUI_PRDCIF","N"})
aadd(_aCpoPro,{"DUM", "" ,"X" ,"DUM_CODPRO","N"})
aadd(_aCpoPro,{"DV1", "" ,"X" ,"DV1_CODPRO","N"})
aadd(_aCpoPro,{"DVC", "" ,"X" ,"DVC_CODPRO","N"})
aadd(_aCpoPro,{"DVD", "" ,"X" ,"DVD_CODPRO","N"})
aadd(_aCpoPro,{"DVD", "" ,"X" ,"DVD_PRDTAB","N"})
aadd(_aCpoPro,{"DVF", "" ,"X" ,"DVF_CODPRO","N"})
aadd(_aCpoPro,{"DVJ", "" ,"X" ,"DVJ_CODPRO","N"})
aadd(_aCpoPro,{"DVO", "" ,"X" ,"DVO_CODPRO","N"})
aadd(_aCpoPro,{"DVQ", "" ,"X" ,"DVQ_CODPRO","N"})
aadd(_aCpoPro,{"DVR", "" ,"X" ,"DVR_CODPRO","N"})
aadd(_aCpoPro,{"ED1", "" ,"X" ,"ED1_PROD  ","N"})
aadd(_aCpoPro,{"ED2", "" ,"X" ,"ED2_ITEM  ","N"})
aadd(_aCpoPro,{"ED2", "" ,"X" ,"ED2_PROD  ","N"})
aadd(_aCpoPro,{"ED2", "" ,"X" ,"ED2_INAT  ","N"})
aadd(_aCpoPro,{"ED3", "" ,"X" ,"ED3_PROD  ","N"})
aadd(_aCpoPro,{"ED4", "" ,"X" ,"ED4_ITEM  ","N"})
aadd(_aCpoPro,{"ED6", "" ,"X" ,"ED6_PROD  ","N"})
aadd(_aCpoPro,{"ED7", "" ,"X" ,"ED7_DE    ","N"})
aadd(_aCpoPro,{"ED7", "" ,"X" ,"ED7_PARA  ","N"})
aadd(_aCpoPro,{"EDC", "" ,"X" ,"EDC_PROD  ","N"})
aadd(_aCpoPro,{"EDD", "" ,"X" ,"EDD_PROD  ","N"})
aadd(_aCpoPro,{"EDD", "" ,"X" ,"EDD_INAT_E","N"})
aadd(_aCpoPro,{"EDE", "" ,"X" ,"EDE_PROD  ","N"})
aadd(_aCpoPro,{"EEI", "" ,"X" ,"EEI_COD_I ","N"})
aadd(_aCpoPro,{"EI2", "" ,"X" ,"EI2_PRODUT","N"})
aadd(_aCpoPro,{"EI8", "" ,"X" ,"EI8_COD_I ","N"})
aadd(_aCpoPro,{"EXA", "" ,"X" ,"EXA_COD_I ","N"})
aadd(_aCpoPro,{"EXH", "" ,"X" ,"EXH_COD_I ","N"})
aadd(_aCpoPro,{"EXN", "" ,"X" ,"EXN_PROD  ","N"})
aadd(_aCpoPro,{"JBF", "" ,"X" ,"JBF_CODPRO","N"})
aadd(_aCpoPro,{"JEF", "" ,"X" ,"JEF_CODMAT","N"})
aadd(_aCpoPro,{"JEG", "" ,"X" ,"JEG_CODMAT","N"})
aadd(_aCpoPro,{"MAK", "" ,"X" ,"MAK_CODPRO","N"})
aadd(_aCpoPro,{"N06", "" ,"X" ,"N06_PRODUT","N"})
aadd(_aCpoPro,{"N07", "" ,"X" ,"N07_PRODUT","N"})
aadd(_aCpoPro,{"N08", "" ,"X" ,"N08_PRODUT","N"})
aadd(_aCpoPro,{"N30", "" ,"X" ,"N30_VACINA","N"})
aadd(_aCpoPro,{"N38", "" ,"X" ,"N38_CODIGO","N"})
aadd(_aCpoPro,{"N3A", "" ,"X" ,"N3A_CODIGO","N"})
aadd(_aCpoPro,{"N55", "" ,"X" ,"N55_PRODUT","N"})
aadd(_aCpoPro,{"NM1", "" ,"X" ,"NM1_PROD  ","N"})
aadd(_aCpoPro,{"NM2", "" ,"X" ,"NM2_PROD  ","N"})
aadd(_aCpoPro,{"NM5", "" ,"X" ,"NM5_PROD  ","N"})
aadd(_aCpoPro,{"NM6", "" ,"X" ,"NM6_PROD  ","N"})
aadd(_aCpoPro,{"QE0", "" ,"X" ,"QE0_PRODUT","N"})
aadd(_aCpoPro,{"QE6", "" ,"X" ,"QE6_PRODUT","N"})
aadd(_aCpoPro,{"QE7", "" ,"X" ,"QE7_PRODUT","N"})
aadd(_aCpoPro,{"QE8", "" ,"X" ,"QE8_PRODUT","N"})
aadd(_aCpoPro,{"QE9", "" ,"X" ,"QE9_PRODUT","N"})
aadd(_aCpoPro,{"QEA", "" ,"X" ,"QEA_PRODUT","N"})
aadd(_aCpoPro,{"QEB", "" ,"X" ,"QEB_PRODUT","N"})
aadd(_aCpoPro,{"QEC", "" ,"X" ,"QEC_PRODUT","N"})
aadd(_aCpoPro,{"QEH", "" ,"X" ,"QEH_PRODUT","N"})
aadd(_aCpoPro,{"QEK", "" ,"X" ,"QEK_PRODUT","N"})
aadd(_aCpoPro,{"QEL", "" ,"X" ,"QEL_PRODUT","N"})
aadd(_aCpoPro,{"QEM", "" ,"X" ,"QEM_PRODUT","N"})
aadd(_aCpoPro,{"QEN", "" ,"X" ,"QEN_PRODUT","N"})
aadd(_aCpoPro,{"QEP", "" ,"X" ,"QEP_PRODUT","N"})
aadd(_aCpoPro,{"QER", "" ,"X" ,"QER_PRODUT","N"})
aadd(_aCpoPro,{"QEV", "" ,"X" ,"QEV_PRODUT","N"})
aadd(_aCpoPro,{"QEW", "" ,"X" ,"QEW_PRODUT","N"})
aadd(_aCpoPro,{"QEY", "" ,"X" ,"QEY_PRODUT","N"})
aadd(_aCpoPro,{"QEZ", "" ,"X" ,"QEZ_PRODUT","N"})
aadd(_aCpoPro,{"QF2", "" ,"X" ,"QF2_PRODUT","N"})
aadd(_aCpoPro,{"QF3", "" ,"X" ,"QF3_PRODUT","N"})
aadd(_aCpoPro,{"QF4", "" ,"X" ,"QF4_PRODUT","N"})
aadd(_aCpoPro,{"QF5", "" ,"X" ,"QF5_PRODUT","N"})
aadd(_aCpoPro,{"QF6", "" ,"X" ,"QF6_PRODUT","N"})
aadd(_aCpoPro,{"QI2", "" ,"X" ,"QI2_CODPRO","N"})
aadd(_aCpoPro,{"QK1", "" ,"X" ,"QK1_PRODUT","N"})
aadd(_aCpoPro,{"QL4", "" ,"X" ,"QL4_PRODUT","N"})
aadd(_aCpoPro,{"QP6", "" ,"X" ,"QP6_CODSIM","N"})
aadd(_aCpoPro,{"QP6", "" ,"X" ,"QP6_PRODUT","N"})
aadd(_aCpoPro,{"QP7", "" ,"X" ,"QP7_PRODUT","N"})
aadd(_aCpoPro,{"QP8", "" ,"X" ,"QP8_PRODUT","N"})
aadd(_aCpoPro,{"QP9", "" ,"X" ,"QP9_PRODUT","N"})
aadd(_aCpoPro,{"QPA", "" ,"X" ,"QPA_PRODUT","N"})
aadd(_aCpoPro,{"QPB", "" ,"X" ,"QPB_PRODUT","N"})
aadd(_aCpoPro,{"QPC", "" ,"X" ,"QPC_PRODUT","N"})
aadd(_aCpoPro,{"QPH", "" ,"X" ,"QPH_PRODUT","N"})
aadd(_aCpoPro,{"QPK", "" ,"X" ,"QPK_PRODUT","N"})
aadd(_aCpoPro,{"QPL", "" ,"X" ,"QPL_PRODUT","N"})
aadd(_aCpoPro,{"QPM", "" ,"X" ,"QPM_PRODUT","N"})
aadd(_aCpoPro,{"QPN", "" ,"X" ,"QPN_PRODUT","N"})
aadd(_aCpoPro,{"QPR", "" ,"X" ,"QPR_PRODUT","N"})
aadd(_aCpoPro,{"QPY", "" ,"X" ,"QPY_PRODUT","N"})
aadd(_aCpoPro,{"QPZ", "" ,"X" ,"QPZ_PRODUT","N"})
aadd(_aCpoPro,{"QQ1", "" ,"X" ,"QQ1_PRODUT","N"})
aadd(_aCpoPro,{"QQ2", "" ,"X" ,"QQ2_CODIGO","N"})
aadd(_aCpoPro,{"QQ2", "" ,"X" ,"QQ2_PRODUT","N"})
aadd(_aCpoPro,{"QQ4", "" ,"X" ,"QQ4_PRODUT","N"})
aadd(_aCpoPro,{"QQ6", "" ,"X" ,"QQ6_PRODUT","N"})
aadd(_aCpoPro,{"QQ7", "" ,"X" ,"QQ7_PRODUT","N"})
aadd(_aCpoPro,{"QQC", "" ,"X" ,"QQC_CODSIM","N"})
aadd(_aCpoPro,{"QQG", "" ,"X" ,"QQG_RASTRO","N"})
aadd(_aCpoPro,{"QQG", "" ,"X" ,"QQG_PRODUT","N"})
aadd(_aCpoPro,{"QQH", "" ,"X" ,"QQH_PRODUT","N"})
aadd(_aCpoPro,{"QQK", "" ,"X" ,"QQK_PRODUT","N"})
aadd(_aCpoPro,{"RA1", "" ,"X" ,"RA1_PROD  ","N"})
aadd(_aCpoPro,{"SA5", "" ,"X" ,"A5_PRODUTO","N"})
aadd(_aCpoPro,{"SA7", "" ,"X" ,"A7_PRODUTO","N"})
aadd(_aCpoPro,{"SA7", "" ,"X" ,"A7_CODCLI ","N"})
aadd(_aCpoPro,{"SAB", "" ,"X" ,"AB_PRODUTO","N"})
aadd(_aCpoPro,{"SAC", "" ,"X" ,"AC_PRODUTO","N"})
aadd(_aCpoPro,{"SAI", "" ,"X" ,"AI_PRODUTO","N"})
aadd(_aCpoPro,{"SB0", "" ,"X" ,"B0_COD    ","N"})
aadd(_aCpoPro,{"SB1", "" ,"X" ,"B1_COD","N"})
aadd(_aCpoPro,{"SB1", "" ,"X" ,"B1_XEMPPAD","N"})
aadd(_aCpoPro,{"SB1", "" ,"X" ,"B1_PRODPAI","N"})
aadd(_aCpoPro,{"SB2", "" ,"X" ,"B2_COD    ","N"})
aadd(_aCpoPro,{"SB3", "" ,"X" ,"B3_COD    ","N"})
aadd(_aCpoPro,{"SB5", "" ,"X" ,"B5_COD    ","N"})
aadd(_aCpoPro,{"SB6", "" ,"X" ,"B6_PRODUTO","N"})
aadd(_aCpoPro,{"SB7", "" ,"X" ,"B7_COD    ","N"})
aadd(_aCpoPro,{"SB8", "" ,"X" ,"B8_PRODUTO","N"})
aadd(_aCpoPro,{"SB9", "" ,"X" ,"B9_COD    ","N"})
aadd(_aCpoPro,{"SBA", "" ,"X" ,"BA_COD    ","N"})
aadd(_aCpoPro,{"SBB", "" ,"X" ,"BB_PRODUTO","N"})
aadd(_aCpoPro,{"SBC", "" ,"X" ,"BC_PRODUTO","N"})
aadd(_aCpoPro,{"SBC", "" ,"X" ,"BC_CODDEST","N"})
aadd(_aCpoPro,{"SBD", "" ,"X" ,"BD_PRODUTO","N"})
aadd(_aCpoPro,{"SBE", "" ,"X" ,"BE_CODPRO ","N"})
aadd(_aCpoPro,{"SBF", "" ,"X" ,"BF_PRODUTO","N"})
aadd(_aCpoPro,{"SBG", "" ,"X" ,"BG_PRODUTO","N"})
aadd(_aCpoPro,{"SBH", "" ,"X" ,"BH_PRODUTO","N"})
aadd(_aCpoPro,{"SBH", "" ,"X" ,"BH_CODCOMP","N"})
aadd(_aCpoPro,{"SBJ", "" ,"X" ,"BJ_COD    ","N"})
aadd(_aCpoPro,{"SBK", "" ,"X" ,"BK_COD    ","N"})
aadd(_aCpoPro,{"SBL", "" ,"X" ,"BL_PRODUTO","N"})
aadd(_aCpoPro,{"SBU", "" ,"X" ,"BU_COMP   ","N"})
aadd(_aCpoPro,{"SC0", "" ,"X" ,"C0_PRODUTO","N"})
aadd(_aCpoPro,{"SC1", "" ,"X" ,"C1_PRODUTO","N"})
aadd(_aCpoPro,{"SC2", "" ,"X" ,"C2_PRODUTO","N"})
aadd(_aCpoPro,{"SC3", "" ,"X" ,"C3_PRODUTO","N"})
aadd(_aCpoPro,{"SC4", "" ,"X" ,"C4_PRODUTO","N"})
aadd(_aCpoPro,{"SC6", "" ,"X" ,"C6_PRODUTO","N"})
aadd(_aCpoPro,{"SC7", "" ,"X" ,"C7_PRODUTO","N"})
aadd(_aCpoPro,{"SC8", "" ,"X" ,"C8_PRODUTO","N"})
aadd(_aCpoPro,{"SC9", "" ,"X" ,"C9_PRODUTO","N"})
aadd(_aCpoPro,{"SCA", "" ,"X" ,"CA_PRODUTO","N"})
aadd(_aCpoPro,{"SCE", "" ,"X" ,"CE_PRODUTO","N"})
aadd(_aCpoPro,{"SCK", "" ,"X" ,"CK_PRODUTO","N"})
aadd(_aCpoPro,{"SCL", "" ,"X" ,"CL_PRODUTO","N"})
aadd(_aCpoPro,{"SCP", "" ,"X" ,"CP_PRODUTO","N"})
aadd(_aCpoPro,{"SCQ", "" ,"X" ,"CQ_PRODUTO","N"})
aadd(_aCpoPro,{"SCT", "" ,"X" ,"CT_PRODUTO","N"})
aadd(_aCpoPro,{"SD1", "" ,"X" ,"D1_COD    ","N"})
aadd(_aCpoPro,{"SD2", "" ,"X" ,"D2_COD    ","N"})
aadd(_aCpoPro,{"SD3", "" ,"X" ,"D3_COD    ","N"})
aadd(_aCpoPro,{"SD4", "" ,"X" ,"D4_COD    ","N"})
aadd(_aCpoPro,{"SD5", "" ,"X" ,"D5_PRODUTO","N"})
aadd(_aCpoPro,{"SD6", "" ,"X" ,"D6_PRODUTO","N"})
aadd(_aCpoPro,{"SD7", "" ,"X" ,"D7_PRODUTO","N"})
aadd(_aCpoPro,{"SD8", "" ,"X" ,"D8_PRODUTO","N"})
aadd(_aCpoPro,{"SDA", "" ,"X" ,"DA_PRODUTO","N"})
aadd(_aCpoPro,{"SDB", "" ,"X" ,"DB_PRODUTO","N"})
aadd(_aCpoPro,{"SDC", "" ,"X" ,"DC_PRODUTO","N"})
aadd(_aCpoPro,{"SDD", "" ,"X" ,"DD_PRODUTO","N"})
aadd(_aCpoPro,{"SDF", "" ,"X" ,"DF_PRODUTO","N"})
aadd(_aCpoPro,{"SDH", "" ,"X" ,"DH_PRODUTO","N"})
aadd(_aCpoPro,{"SFK", "" ,"X" ,"FK_PRODUTO","N"})
aadd(_aCpoPro,{"SFM", "" ,"X" ,"FM_PRODUTO","N"})
aadd(_aCpoPro,{"SFT", "" ,"X" ,"FT_PRODUTO","N"}) 
aadd(_aCpoPro,{"SG1", "" ,"X" ,"G1_COD    ","N"}) 
aadd(_aCpoPro,{"SG1", "" ,"X" ,"G1_COMP   ","N"})
aadd(_aCpoPro,{"SG2", "" ,"X" ,"G2_PRODUTO","N"})
aadd(_aCpoPro,{"SG4", "" ,"X" ,"G4_CODIGO ","N"})
aadd(_aCpoPro,{"SG5", "" ,"X" ,"G5_PRODUTO","N"})
aadd(_aCpoPro,{"SG7", "" ,"X" ,"G7_PRODUTO","N"})
aadd(_aCpoPro,{"SGC", "" ,"X" ,"GC_PRODUTO","N"})
aadd(_aCpoPro,{"SGF", "" ,"X" ,"GF_PRODUTO","N"})
aadd(_aCpoPro,{"SGG", "" ,"X" ,"GG_COD    ","N"})
aadd(_aCpoPro,{"SGG", "" ,"X" ,"GG_COMP   ","N"})
aadd(_aCpoPro,{"SH3", "" ,"X" ,"H3_PRODUTO","N"})
aadd(_aCpoPro,{"SH6", "" ,"X" ,"H6_PRODUTO","N"})
aadd(_aCpoPro,{"SHC", "" ,"X" ,"HC_PRODUTO","N"})
aadd(_aCpoPro,{"SHE", "" ,"X" ,"HE_PRODUTO","N"})
aadd(_aCpoPro,{"SHG", "" ,"X" ,"HG_COD    ","N"})
aadd(_aCpoPro,{"SHG", "" ,"X" ,"HG_CODORI ","N"})
aadd(_aCpoPro,{"SJ3", "" ,"X" ,"J3_PRODUTO","N"})
aadd(_aCpoPro,{"SJ5", "" ,"X" ,"J5_COD_I  ","N"})
aadd(_aCpoPro,{"SL2", "" ,"X" ,"L2_PRODUTO","N"})
aadd(_aCpoPro,{"SL3", "" ,"X" ,"L3_PRODUTO","N"})
aadd(_aCpoPro,{"SLA", "" ,"X" ,"LA_PRODUTO","N"})
aadd(_aCpoPro,{"SLC", "" ,"X" ,"LC_PRODUTO","N"})
aadd(_aCpoPro,{"SLK", "" ,"X" ,"LK_CODIGO ","N"})
aadd(_aCpoPro,{"SLN", "" ,"X" ,"LN_COD    ","N"})
aadd(_aCpoPro,{"SLR", "" ,"X" ,"LR_PRODUTO","N"})
aadd(_aCpoPro,{"SO2", "" ,"X" ,"O2_PRODUTO","N"})
aadd(_aCpoPro,{"SO4", "" ,"X" ,"O4_PRODUTO","N"})
aadd(_aCpoPro,{"SO7", "" ,"X" ,"O7_PRODUTO","N"})
aadd(_aCpoPro,{"SO9", "" ,"X" ,"O9_PRODUTO","N"})
aadd(_aCpoPro,{"ST9", "" ,"X" ,"T9_CODESTO","N"})
aadd(_aCpoPro,{"STR", "" ,"X" ,"TR_PRODUTO","N"})
aadd(_aCpoPro,{"STY", "" ,"X" ,"TY_PRODUTO","N"})
aadd(_aCpoPro,{"SU2", "" ,"X" ,"U2_COD    ","N"})
aadd(_aCpoPro,{"SUB", "" ,"X" ,"UB_PRODUTO","N"})
aadd(_aCpoPro,{"SUD", "" ,"X" ,"UD_PRODUTO","N"})
aadd(_aCpoPro,{"SUF", "" ,"X" ,"UF_PRODUTO","N"})
aadd(_aCpoPro,{"SUG", "" ,"X" ,"UG_PRODUTO","N"})
aadd(_aCpoPro,{"SUW", "" ,"X" ,"UW_PRODUTO","N"})
aadd(_aCpoPro,{"SV1", "" ,"X" ,"V1_CARB   ","N"})
aadd(_aCpoPro,{"SV1", "" ,"X" ,"V1_MOTOR  ","N"})
aadd(_aCpoPro,{"SV1", "" ,"X" ,"V1_CAMBIO ","N"})
aadd(_aCpoPro,{"SW3", "" ,"X" ,"W3_COD_I  ","N"})
aadd(_aCpoPro,{"SWN", "" ,"X" ,"WN_PRODUTO","N"})
aadd(_aCpoPro,{"SWS", "" ,"X" ,"WS_COD_I  ","N"})
aadd(_aCpoPro,{"SWT", "" ,"X" ,"WT_COD_I  ","N"})
aadd(_aCpoPro,{"SYG", "" ,"X" ,"YG_ITEM   ","N"})
aadd(_aCpoPro,{"SYV", "" ,"X" ,"YV_MACHINE","N"})
aadd(_aCpoPro,{"SYX", "" ,"X" ,"YX_COD_I  ","N"})
aadd(_aCpoPro,{"SYX", "" ,"X" ,"YX_MACHINE","N"})
aadd(_aCpoPro,{"TAS", "" ,"X" ,"TAS_CODPRO","N"})
aadd(_aCpoPro,{"TAT", "" ,"X" ,"TAT_CODMAT","N"})
aadd(_aCpoPro,{"TAX", "" ,"X" ,"TAX_CODRES","N"})
aadd(_aCpoPro,{"TB5", "" ,"X" ,"TB5_CODPRO","N"})
aadd(_aCpoPro,{"TBA", "" ,"X" ,"TBA_CODRES","N"})
aadd(_aCpoPro,{"TBA", "" ,"X" ,"TBA_CODPRO","N"})
aadd(_aCpoPro,{"TN3", "" ,"X" ,"TN3_CODEPI","N"})
aadd(_aCpoPro,{"TNB", "" ,"X" ,"TNB_CODEPI","N"})
aadd(_aCpoPro,{"TNF", "" ,"X" ,"TNF_CODEPI","N"})
aadd(_aCpoPro,{"TNX", "" ,"X" ,"TNX_EPI   ","N"})
aadd(_aCpoPro,{"TOH", "" ,"X" ,"TOH_CODEPI","N"})
aadd(_aCpoPro,{"TP9", "" ,"X" ,"TP9_CODEST","N"})
aadd(_aCpoPro,{"TPK", "" ,"X" ,"TPK_CODPRO","N"})
aadd(_aCpoPro,{"TPY", "" ,"X" ,"TPY_CODPRO","N"})
aadd(_aCpoPro,{"VAB", "" ,"X" ,"VAB_CODPEC","N"})
aadd(_aCpoPro,{"VE4", "" ,"X" ,"VE4_CDPRFD","N"})
aadd(_aCpoPro,{"Z06", "" ,"X" ,"Z06_PROD","N"})
aadd(_aCpoPro,{"Z07", "" ,"X" ,"Z07_PRODUT","N"})
aadd(_aCpoPro,{"SZ2", "" ,"X" ,"Z2_CODPROD","N"})
aadd(_aCpoPro,{"SZ8", "" ,"X" ,"Z8_PRODUTO","N"})
aadd(_aCpoPro,{"SZ1", "" ,"X" ,"Z1_PRODUT","N"})
aadd(_aCpoPro,{"PWC", "" ,"X" ,"PWC_COD","N"})
aadd(_aCpoPro,{"PWD", "" ,"X" ,"PWD_COD","N"})
aadd(_aCpoPro,{"PWE", "" ,"X" ,"PWE_COD","N"})
aadd(_aCpoPro,{"PWI", "" ,"X" ,"PWI_PRODUT","N"})
aadd(_aCpoPro,{"PWL", "" ,"X" ,"PWL_COD","N"})
aadd(_aCpoPro,{"PWM", "" ,"X" ,"PWM_COD","N"})
aadd(_aCpoPro,{"PWN", "" ,"X" ,"PWN_COD","N"})
aadd(_aCpoPro,{"PWR", "" ,"X" ,"PWR_PRODUT","N"})
aadd(_aCpoPro,{"Z06", "" ,"X" ,"Z06_PROD","N"})
aadd(_aCpoPro,{"SZ2", "" ,"X" ,"Z2_CODPROD","N"})
aadd(_aCpoPro,{"SZI", "" ,"X" ,"ZI_PRODUTO","N"})
aadd(_aCpoPro,{"ZZ5", "" ,"X" ,"ZZ5_CODEPI","N"})
aadd(_aCpoPro,{"ZZ6", "" ,"X" ,"ZZ6_CODEPI","N"})
aadd(_aCpoPro,{"ZZ7", "" ,"X" ,"ZZ7_CODEPI","N"})   

//novo 01020167 e o velho 30020029
 

aProdutos := {}
Aadd(aProdutos,{'CABO1,50','CABO1,50 3395'})

_aArqtmp := {}
_aArqtrf := {}
_nCtdite := 0
_lProcOk := .f.

// verica as tabelas existentes no DATABASE e gera um array com o nome das tabelas

cQuery := "SELECT name as NOME FROM sysobjects WHERE sysstat & 0xf in (3) and name not like '#%' and name not like '%_BKP' and name not like 'TOP_%'ORDER BY name"
TCQUERY cQuery NEW ALIAS "TRBEXP"

Count To nReg

dbSelectArea("TRBEXP")
dbgotop()

procregua(nReg)

Do While ! eof()
	incproc("Selecionando Tabelas para Processar  - "+TRBEXP->NOME)
	_nCtdite ++
	aadd(_aArqtrf,{alltrim(upper(TRBEXP->NOME)),strzero(_nCtdite,5)})
	dbskip()
Enddo

dbSelectArea("TRBEXP")
dbclosearea()

// verficar no sx2 o nome das tabelas e o modo de utilização

dbselectarea("SX2")
dbSetOrder(1)

For nPos := 1 To Len(_aCpoPro)
	If SX2->(dbSeek(_aCpoPro[nPos,1]))
		_aCpoPro[nPos][2] := upper(X2_ARQUIVO)
		_aCpoPro[nPos][3] := upper(X2_MODO)
	Endif
Next

// verificando a existencia da tabela no array proveniente no DATABASE
// somente tabelas existentes devem ser processadas

oProcess:SetRegua1(len(_aCpoPro)) //Alimenta a primeira barra de progresso

For i:= 1 to len(_aCpoPro)
	oProcess:IncRegua1("Analisando Tabelas")
	
	nPos := aScan(_aArqtrf,{ |X| alltrim(upper(X[1])) == alltrim(upper(_aCpoPro[i][2])) })
	If nPos <> 0
		_aCpoPro[i][5] := "S"
	Endif
Next


oProcess:SetRegua1(len(_aCpoPro)) //Alimenta a primeira barra de progresso
	
_lErro := .f.
	
For i:= 1 to len(_aCpoPro)
	oProcess:IncRegua1("Atualizando - "+_aCpoPro[i][2] + " Campo " + _aCpoPro[i][4])
		
	if _aCpoPro[i][5]  == "S"
			
		_lOpen := .f.
			
		if  select(_aCpoPro[i][1]) > 0
			// Tabela ja aberta
			DbSelectArea(_aCpoPro[i][1])
		Else
			// tabela nao esta aberta
			// tem que abrit para fechar depois
				
			_cArqtrf   := RetArq(__cRDD,_aCpoPro[i][2])
			_cArqAlias := _aCpoPro[i][1]
				
			If MSFile(_cArqtrf,,__cRDD) // TABELA EXISTE NO DATABASE
				if ! chkfile(_cArqAlias,.f.)
					msgbox("!! Tabela "+_cArqtrf+" nao disponivel para exportacao !!!",,"STOP")
					loop
				Else
					_lOpen := .t.
				Endif
			Else
				loop
			EndIf
		Endif 
			
		Count To nReg
			
		if nReg > 0  .and. fieldpos(_aCpoPro[i][4]) > 0
				
			_cTabNome  := alltrim(upper(_aCpoPro[i][2]))
			_cModoUso  := alltrim(upper(_aCpoPro[i][3]))
			_cCpoNome  := alltrim(upper(_aCpoPro[i][4]))
				
				
			_cCpoFil := substr(_cCpoNome,1,at("_",_cCpoNome))+"FILIAL"
				
			if _cModoUso == "C"
				_cFilTab   := space(02)
			Else
				_cFilTab   := xFilial(_aCpoPro[i][1])
			Endif
				
			nReg := Len(aProdutos)  
			oProcess:SetRegua2(nReg) //Alimenta a primeira barra de progresso
			For nProd := 1 To Len(aProdutos)
				oProcess:IncRegua2(" Novo: " + aProdutos[nProd,2] + " Velho: " + aProdutos[nProd,1] + " - ("+AllTrim(Str(nProd))+")")
								
				_cCodNovo	:=	aProdutos[nProd,2] 
				_cCodVelho	:=	aProdutos[nProd,1]				
				
				_cQuery := "UPDATE "+_cTabNome+" SET "+_cCpoNome+ " = '"+_cCodNovo+"' WHERE "+_cCpoNome+" = '"+_cCodVelho+"' "
				_cQuery += " AND "+_cCpoFil+ " = '"+_cFilTab+"' AND D_E_L_E_T_ <> '*' "
					
				_nRetSql := tcsqlexec(_cQuery)
					
				if _nRetSql < 0
					_lErro := .f.
					_lCont := msgyesno("Houveram erros na execucao do comando: "+chr(13)+chr(13)+_cQuery+chr(13)+chr(13)+" Continua Processamento ??")
					if ! _lCont
								
						_lErro := .t.
								
						if _lOpen
							dbclosearea()
						Endif
								
						Exit
								
					Endif
				Endif
			Next
		Else
			//alert("Campo "+_aCpoPro[i][4]+" inexistente na tabela ou tabela vazia ")
		Endif
			
		if _lOpen
			dbclosearea()
		Endif
	Endif
Next				
	
If  _lerro
	Alert("Houveram erros que impediram a mudanca de codigo na tabela SB1."+chr(13)+chr(13)+"Verifique as tabelas modificadas ate interrupcao !!")
Endif

Return nil
