#include "TOPCONN.CH"
#include "rwmake.ch"

User Function RESTA002()   



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Funcao    :  RESTA002| Autor : Claudenilson Dias    | Data : 20.04.06   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Descricao : Troca codido do Centro de Custo nas tabelas indicadas        ±±
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

_cMsg1  := "Este programa tem a finalidade de trocar os codigos de centros de custos existentes por outros"
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

@ 000,00 TO 320,520 DIALOG oDlg TITLE "Troca de Codigo de Centros de Custos"

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

_aCpoCusto := {}

aadd(_cCpoCusto,{"AA1","","X","AA1_CC","N"})
aadd(_cCpoCusto,{"AAH","","X","AAH_CCUSTO","N"})
aadd(_cCpoCusto,{"ABS","","X","ABS_CCUSTO","N"})
aadd(_cCpoCusto,{"AF2","","X","AF2_CCUSTO","N"})
aadd(_cCpoCusto,{"AF9","","X","AF9_CCUSTO","N"})
aadd(_cCpoCusto,{"AGG","","X","AGG_CC","N"})
aadd(_cCpoCusto,{"AGH","","X","AGH_CC","N"})
aadd(_cCpoCusto,{"AK2","","X","AK2_CC","N"})
aadd(_cCpoCusto,{"AKD","","X","AKD_CC","N"})
aadd(_cCpoCusto,{"AKX","","X","AKX_CC_FIN","N"})
aadd(_cCpoCusto,{"AKX","","X","AKX_CC_INI","N"})
aadd(_cCpoCusto,{"ALN","","X","ALN_CC","N"})
aadd(_cCpoCusto,{"ALO","","X","ALO_CC","N"})
aadd(_cCpoCusto,{"ALP","","X","ALP_CC","N"})
aadd(_cCpoCusto,{"ALX","","X","ALX_CC","N"})
aadd(_cCpoCusto,{"AMJ","","X","AMJ_CC","N"})
aadd(_cCpoCusto,{"AMY","","X","AMY_CCSUP","N"})
aadd(_cCpoCusto,{"AMY","","X","AMY_CCUSTO","N"})
aadd(_cCpoCusto,{"AMZ","","X","AMZ_CC","N"})
aadd(_cCpoCusto,{"BAU","","X","BAU_CC","N"})
aadd(_cCpoCusto,{"BCE","","X","BCE_CC","N"})
aadd(_cCpoCusto,{"BD5","","X","BD5_CC","N"})
aadd(_cCpoCusto,{"BD6","","X","BD6_CC","N"})
aadd(_cCpoCusto,{"BD7","","X","BD7_CC","N"})
aadd(_cCpoCusto,{"BE4","","X","BE4_CC","N"})
aadd(_cCpoCusto,{"BI3","","X","BI3_CC","N"})
aadd(_cCpoCusto,{"BMS","","X","BMS_CC","N"})
aadd(_cCpoCusto,{"BSQ","","X","BSQ_CC","N"})
aadd(_cCpoCusto,{"BT6","","X","BT6_CC","N"})
aadd(_cCpoCusto,{"CB0","","X","CB0_CC","N"})
aadd(_cCpoCusto,{"CF6","","X","CF6_CODCCS","N"})
aadd(_cCpoCusto,{"CF8","","X","CF8_CODCCS","N"})
aadd(_cCpoCusto,{"CL2","","X","CL2_CCUS","N"})
aadd(_cCpoCusto,{"CNB","","X","CNB_CC","N"})
aadd(_cCpoCusto,{"CNE","","X","CNE_CC","N"})
aadd(_cCpoCusto,{"CNW","","X","CNW_CC","N"})
aadd(_cCpoCusto,{"CNZ","","X","CNZ_CC","N"})
aadd(_cCpoCusto,{"CO1","","X","CO1_CC","N"})
aadd(_cCpoCusto,{"CO5","","X","CO5_CODARE","N"})
aadd(_cCpoCusto,{"COJ","","X","COJ_CUSTO","N"})
aadd(_cCpoCusto,{"CQ2","","X","CQ2_CCUSTO","N"})
aadd(_cCpoCusto,{"CQ3","","X","CQ3_CCUSTO","N"})
aadd(_cCpoCusto,{"CQ4","","X","CQ4_CCUSTO","N"})
aadd(_cCpoCusto,{"CQ5","","X","CQ5_CCUSTO","N"})
aadd(_cCpoCusto,{"CQ6","","X","CQ6_CCUSTO","N"})
aadd(_cCpoCusto,{"CQ7","","X","CQ7_CCUSTO","N"})
aadd(_cCpoCusto,{"CQ8","","X","CQ8_CODIGO","N"})
aadd(_cCpoCusto,{"CQ9","","X","CQ9_CODIGO","N"})
aadd(_cCpoCusto,{"CQB","","X","CQB_CCUSTO","N"})
aadd(_cCpoCusto,{"CQE","","X","CQE_CUSTO","N"})
aadd(_cCpoCusto,{"CQK","","X","CQK_CCC","N"})
aadd(_cCpoCusto,{"CQK","","X","CQK_CCD","N"})
aadd(_cCpoCusto,{"CT1","","X","CT1_CC","N"})
aadd(_cCpoCusto,{"CT2","","X","CT2_CCC","N"})
aadd(_cCpoCusto,{"CT2","","X","CT2_CCD","N"})
aadd(_cCpoCusto,{"CT3","","X","CT3_CUSTO","N"})
aadd(_cCpoCusto,{"CT4","","X","CT4_CUSTO","N"})
aadd(_cCpoCusto,{"CT9","","X","CT9_CCC","N"})
aadd(_cCpoCusto,{"CT9","","X","CT9_CCD","N"})
aadd(_cCpoCusto,{"CTA","","X","CTA_CUSTO","N"})
aadd(_cCpoCusto,{"CTB","","X","CTB_CCDES","N"})
aadd(_cCpoCusto,{"CTB","","X","CTB_CTTFIM","N"})
aadd(_cCpoCusto,{"CTB","","X","CTB_CTTINI","N"})
aadd(_cCpoCusto,{"CTI","","X","CTI_CUSTO","N"})
aadd(_cCpoCusto,{"CTJ","","X","CTJ_CCC","N"})
aadd(_cCpoCusto,{"CTJ","","X","CTJ_CCD","N"})
aadd(_cCpoCusto,{"CTK","","X","CTK_CCC","N"})
aadd(_cCpoCusto,{"CTK","","X","CTK_CCD","N"})
aadd(_cCpoCusto,{"CTQ","","X","CTQ_CCCPAR","N"})
aadd(_cCpoCusto,{"CTQ","","X","CTQ_CCORI","N"})
aadd(_cCpoCusto,{"CTQ","","X","CTQ_CCPAR","N"})
aadd(_cCpoCusto,{"CTS","","X","CTS_CTTFIM","N"})
aadd(_cCpoCusto,{"CTS","","X","CTS_CTTINI","N"})
aadd(_cCpoCusto,{"CTT","","X","CTT_CCLP","N"})
aadd(_cCpoCusto,{"CTT","","X","CTT_CCPON","N"})
aadd(_cCpoCusto,{"CTT","","X","CTT_CCRED","N"})
aadd(_cCpoCusto,{"CTT","","X","CTT_CCSUP","N"})
aadd(_cCpoCusto,{"CTT","","X","CTT_CCVM","N"})
aadd(_cCpoCusto,{"CTT","","X","CTT_CUSTO","N"})
aadd(_cCpoCusto,{"CTU","","X","CTU_CODIGO","N"})
aadd(_cCpoCusto,{"CTV","","X","CTV_CUSTO","N"})
aadd(_cCpoCusto,{"CTW","","X","CTW_CUSTO","N"})
aadd(_cCpoCusto,{"CTY","","X","CTY_CUSTO","N"})
aadd(_cCpoCusto,{"CTZ","","X","CTZ_CUSTO","N"})
aadd(_cCpoCusto,{"CV1","","X","CV1_CTTFIM","N"})
aadd(_cCpoCusto,{"CV1","","X","CV1_CTTINI","N"})
aadd(_cCpoCusto,{"CV3","","X","CV3_CCC","N"})
aadd(_cCpoCusto,{"CV3","","X","CV3_CCD","N"})
aadd(_cCpoCusto,{"CV4","","X","CV4_CCC","N"})
aadd(_cCpoCusto,{"CV4","","X","CV4_CCD","N"})
aadd(_cCpoCusto,{"CV5","","X","CV5_CTTDES","N"})
aadd(_cCpoCusto,{"CV5","","X","CV5_CTTFIM","N"})
aadd(_cCpoCusto,{"CV5","","X","CV5_CTTORI","N"})
aadd(_cCpoCusto,{"CV6","","X","CV6_CCC","N"})
aadd(_cCpoCusto,{"CV6","","X","CV6_CCD","N"})
aadd(_cCpoCusto,{"CV9","","X","CV9_CCCPAR","N"})
aadd(_cCpoCusto,{"CV9","","X","CV9_CCORI","N"})
aadd(_cCpoCusto,{"CV9","","X","CV9_CCPAR","N"})
aadd(_cCpoCusto,{"CVD","","X","CVD_CUSTO","N"})
aadd(_cCpoCusto,{"CVX","","X","CVX_NIV02","N"})
aadd(_cCpoCusto,{"CVY","","X","CVY_NIV02","N"})
aadd(_cCpoCusto,{"CVZ","","X","CVZ_NIV02","N"})
aadd(_cCpoCusto,{"CW1","","X","CW1_CCUSTO","N"})
aadd(_cCpoCusto,{"CW2","","X","CW2_CTTPAR","N"})
aadd(_cCpoCusto,{"CWK","","X","CWK_CC","N"})
aadd(_cCpoCusto,{"CX0","","X","CX0_CC","N"})
aadd(_cCpoCusto,{"CXP","","X","CXP_CC","N"})
aadd(_cCpoCusto,{"CYB","","X","CYB_CDCECS","N"})
aadd(_cCpoCusto,{"CYI","","X","CYI_CDCECS","N"})
aadd(_cCpoCusto,{"DBC","","X","DBC_CC","N"})
aadd(_cCpoCusto,{"DBK","","X","DBK_CC","N"})
aadd(_cCpoCusto,{"DBL","","X","DBL_CC","N"})
aadd(_cCpoCusto,{"DFA","","X","DFA_CC","N"})
aadd(_cCpoCusto,{"DFA","","X","DFA_CC2","N"})
aadd(_cCpoCusto,{"DFZ","","X","DFZ_CC","N"})
aadd(_cCpoCusto,{"DFZ","","X","DFZ_CC2","N"})
aadd(_cCpoCusto,{"DH1","","X","DH1_CC","N"})
aadd(_cCpoCusto,{"DT7","","X","DT7_CC","N"})
aadd(_cCpoCusto,{"FJ0","","X","FJ0_CCUSTO","N"})
aadd(_cCpoCusto,{"FK1","","X","FK1_CCUSTO","N"})
aadd(_cCpoCusto,{"FK2","","X","FK2_CCUSTO","N"})
aadd(_cCpoCusto,{"FK5","","X","FK5_CCUSTO","N"})
aadd(_cCpoCusto,{"FK8","","X","FK8_CCC","N"})
aadd(_cCpoCusto,{"FK8","","X","FK8_CCD","N"})
aadd(_cCpoCusto,{"FKM","","X","FKM_CUSTO","N"})
aadd(_cCpoCusto,{"FL5","","X","FL5_CC","N"})
aadd(_cCpoCusto,{"FLE","","X","FLE_CUSTO","N"})
aadd(_cCpoCusto,{"FLF","","X","FLF_CC","N"})
aadd(_cCpoCusto,{"FLG","","X","FLG_CUSTO","N"})
aadd(_cCpoCusto,{"FLH","","X","FLH_CC","N"})
aadd(_cCpoCusto,{"FLP","","X","FLP_CCUSTO","N"})
aadd(_cCpoCusto,{"FN9","","X","FN9_CCBEMD","N"})
aadd(_cCpoCusto,{"FN9","","X","FN9_CCCDD","N"})
aadd(_cCpoCusto,{"FN9","","X","FN9_CCCORD","N"})
aadd(_cCpoCusto,{"FN9","","X","FN9_CCDAD","N"})
aadd(_cCpoCusto,{"FN9","","X","FN9_CCDDD","N"})
aadd(_cCpoCusto,{"FN9","","X","FN9_CCDESD","N"})
aadd(_cCpoCusto,{"FNE","","X","FNE_ENT02A","N"})
aadd(_cCpoCusto,{"FNE","","X","FNE_ENT02B","N"})
aadd(_cCpoCusto,{"FNE","","X","FNE_ENT02D","N"})
aadd(_cCpoCusto,{"FNF","","X","FNF_ENT02","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCBEMD","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCBEMO","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCCDD","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCCDO","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCCORD","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCCORO","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCDAD","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCDAO","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCDDD","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCDDO","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCDESD","N"})
aadd(_cCpoCusto,{"FNS","","X","FNS_CCDESO","N"})
aadd(_cCpoCusto,{"FNU","","X","FNU_CUSTO","N"})
aadd(_cCpoCusto,{"FNZ","","X","FNZ_CCCDEP","N"})
aadd(_cCpoCusto,{"FNZ","","X","FNZ_CCCDES","N"})
aadd(_cCpoCusto,{"FNZ","","X","FNZ_CCCORR","N"})
aadd(_cCpoCusto,{"FNZ","","X","FNZ_CCDESP","N"})
aadd(_cCpoCusto,{"FNZ","","X","FNZ_CCUSTO","N"})
aadd(_cCpoCusto,{"FNZ","","X","FNZ_CUSTBE","N"})
aadd(_cCpoCusto,{"FO6","","X","FO6_CC","N"})
aadd(_cCpoCusto,{"FRK","","X","FRK_CCUSTO","N"})
aadd(_cCpoCusto,{"FW6","","X","FW6_CC","N"})
aadd(_cCpoCusto,{"FWN","","X","FWN_CCUSTO","N"})
aadd(_cCpoCusto,{"G3R","","X","G3R_CCUSTO","N"})
aadd(_cCpoCusto,{"G48","","X","G48_CCUSTO","N"})
aadd(_cCpoCusto,{"GW3","","X","GW3_CC","N"})
aadd(_cCpoCusto,{"JAF","","X","JAF_CCUSTO","N"})
aadd(_cCpoCusto,{"JCJ","","X","JCJ_CCUSTO","N"})
aadd(_cCpoCusto,{"JDN","","X","JDN_CCUSTO","N"})
aadd(_cCpoCusto,{"NN1","","X","NN1_CC","N"})
aadd(_cCpoCusto,{"NN2","","X","NN2_CC","N"})
aadd(_cCpoCusto,{"NN3","","X","NN3_CC","N"})
aadd(_cCpoCusto,{"NN7","","X","NN7_CCD","N"})
aadd(_cCpoCusto,{"NN9","","X","NN9_CC","N"})
aadd(_cCpoCusto,{"NO1","","X","NO1_CCC","N"})
aadd(_cCpoCusto,{"NOA","","X","NOA_CC","N"})
aadd(_cCpoCusto,{"NP6","","X","NP6_CC","N"})
aadd(_cCpoCusto,{"NP9","","X","NP9_CCUSTO","N"})
aadd(_cCpoCusto,{"NQD","","X","NQD_CC","N"})
aadd(_cCpoCusto,{"NSS","","X","NSS_CC","N"})
aadd(_cCpoCusto,{"NSZ","","X","NSZ_CCUSTO","N"})
aadd(_cCpoCusto,{"NUE","","X","NUE_CC","N"})
aadd(_cCpoCusto,{"NUS","","X","NUS_CC","N"})
aadd(_cCpoCusto,{"NVM","","X","NVM_CC","N"})
aadd(_cCpoCusto,{"NVS","","X","NVS_CCUSTO","N"})
aadd(_cCpoCusto,{"NVU","","X","NVU_CCUSTO","N"})
aadd(_cCpoCusto,{"NZQ","","X","NZQ_GRPJUR","N"})
aadd(_cCpoCusto,{"O0F","","X","O0F_CCUSTO","N"})
aadd(_cCpoCusto,{"OH7","","X","OH7_CCCUST","N"})
aadd(_cCpoCusto,{"OH8","","X","OH8_CCCUST","N"})
aadd(_cCpoCusto,{"OHB","","X","OHB_CCUSTD","N"})
aadd(_cCpoCusto,{"OHB","","X","OHB_CCUSTO","N"})
aadd(_cCpoCusto,{"OHE","","X","OHE_CCCUST","N"})
aadd(_cCpoCusto,{"OHF","","X","OHF_CCUSTO","N"})
aadd(_cCpoCusto,{"OHG","","X","OHG_CCUSTO","N"})
aadd(_cCpoCusto,{"RA2","","X","RA2_CC","N"})
aadd(_cCpoCusto,{"RA5","","X","RA5_CC","N"})
aadd(_cCpoCusto,{"RA8","","X","RA8_CC","N"})
aadd(_cCpoCusto,{"RB8","","X","RB8_CC","N"})
aadd(_cCpoCusto,{"RBA","","X","RBA_CC","N"})
aadd(_cCpoCusto,{"RBD","","X","RBD_CC","N"})
aadd(_cCpoCusto,{"RBE","","X","RBE_CC","N"})
aadd(_cCpoCusto,{"RBH","","X","RBH_CC","N"})
aadd(_cCpoCusto,{"RBT","","X","RBT_CC","N"})
aadd(_cCpoCusto,{"RBU","","X","RBU_CC","N"})
aadd(_cCpoCusto,{"RC1","","X","RC1_CC","N"})
aadd(_cCpoCusto,{"RC6","","X","RC6_CC","N"})
aadd(_cCpoCusto,{"RCZ","","X","RCZ_CCUSTO","N"})
aadd(_cCpoCusto,{"RD0","","X","RD0_CC","N"})
aadd(_cCpoCusto,{"RE0","","X","RE0_CC","N"})
aadd(_cCpoCusto,{"REL","","X","REL_CC","N"})
aadd(_cCpoCusto,{"REP","","X","REP_CC","N"})
aadd(_cCpoCusto,{"RF7","","X","RF7_CC","N"})
aadd(_cCpoCusto,{"RFA","","X","RFA_CC","N"})
aadd(_cCpoCusto,{"RFC","","X","RFC_CC","N"})
aadd(_cCpoCusto,{"RFF","","X","RFF_CC","N"})
aadd(_cCpoCusto,{"RFG","","X","RFG_CC","N"})
aadd(_cCpoCusto,{"RFH","","X","RFH_CC","N"})
aadd(_cCpoCusto,{"RFK","","X","RFK_CC","N"})
aadd(_cCpoCusto,{"RG1","","X","RG1_CC","N"})
aadd(_cCpoCusto,{"RG2","","X","RG2_CC","N"})
aadd(_cCpoCusto,{"RGB","","X","RGB_CC","N"})
aadd(_cCpoCusto,{"RGW","","X","RGW_CCUSTO","N"})
aadd(_cCpoCusto,{"RHH","","X","RHH_CC","N"})
aadd(_cCpoCusto,{"RHQ","","X","RHQ_CC","N"})
aadd(_cCpoCusto,{"RHT","","X","RHT_CC","N"})
aadd(_cCpoCusto,{"RJ3","","X","RJ3_COD","N"})
aadd(_cCpoCusto,{"RJ5","","X","RJ5_CC","N"})
aadd(_cCpoCusto,{"RJ5","","X","RJ5_COD","N"})
aadd(_cCpoCusto,{"SA5","","X","A5_CCUSTO","N"})
aadd(_cCpoCusto,{"SB1","","X","B1_CC","N"})
aadd(_cCpoCusto,{"SB1","","X","B1_CCCUSTO","N"})
aadd(_cCpoCusto,{"SBC","","X","BC_CC","N"})
aadd(_cCpoCusto,{"SC1","","X","C1_CC","N"})
aadd(_cCpoCusto,{"SC2","","X","C2_CC","N"})
aadd(_cCpoCusto,{"SC3","","X","C3_CC","N"})
aadd(_cCpoCusto,{"SC6","","X","C6_CC","N"})
aadd(_cCpoCusto,{"SC6","","X","C6_CCUSTO","N"})
aadd(_cCpoCusto,{"SC7","","X","C7_CC","N"})
aadd(_cCpoCusto,{"SCH","","X","CH_CC","N"})
aadd(_cCpoCusto,{"SCP","","X","CP_CC","N"})
aadd(_cCpoCusto,{"SCQ","","X","CQ_CC","N"})
aadd(_cCpoCusto,{"SCT","","X","CT_CCUSTO","N"})
aadd(_cCpoCusto,{"SCX","","X","CX_CC","N"})
aadd(_cCpoCusto,{"SCY","","X","CY_CC","N"})
aadd(_cCpoCusto,{"SD1","","X","D1_CC","N"})
aadd(_cCpoCusto,{"SD2","","X","D2_CCUSTO","N"})
aadd(_cCpoCusto,{"SD3","","X","D3_CC","N"})
aadd(_cCpoCusto,{"SDE","","X","DE_CC","N"})
aadd(_cCpoCusto,{"SDG","","X","DG_CC","N"})
aadd(_cCpoCusto,{"SE1","","X","E1_CCC","N"})
aadd(_cCpoCusto,{"SE1","","X","E1_CCD","N"})
aadd(_cCpoCusto,{"SE1","","X","E1_CCUSTO","N"})
aadd(_cCpoCusto,{"SE2","","X","E2_CCC","N"})
aadd(_cCpoCusto,{"SE2","","X","E2_CCD","N"})
aadd(_cCpoCusto,{"SE2","","X","E2_CCUSTO","N"})
aadd(_cCpoCusto,{"SE3","","X","E3_CCC","N"})
aadd(_cCpoCusto,{"SE3","","X","E3_CCD","N"})
aadd(_cCpoCusto,{"SE3","","X","E3_CCUSTO","N"})
aadd(_cCpoCusto,{"SE5","","X","E5_CCC","N"})
aadd(_cCpoCusto,{"SE5","","X","E5_CCD","N"})
aadd(_cCpoCusto,{"SE5","","X","E5_CCUSTO","N"})
aadd(_cCpoCusto,{"SE7","","X","E7_CCC","N"})
aadd(_cCpoCusto,{"SE7","","X","E7_CCD","N"})
aadd(_cCpoCusto,{"SE7","","X","E7_CCUSTO","N"})
aadd(_cCpoCusto,{"SEA","","X","EA_CCC","N"})
aadd(_cCpoCusto,{"SEA","","X","EA_CCD","N"})
aadd(_cCpoCusto,{"SED","","X","ED_CCC","N"})
aadd(_cCpoCusto,{"SED","","X","ED_CCD","N"})
aadd(_cCpoCusto,{"SEF","","X","EF_CCC","N"})
aadd(_cCpoCusto,{"SEF","","X","EF_CCD","N"})
aadd(_cCpoCusto,{"SEH","","X","EH_CCC","N"})
aadd(_cCpoCusto,{"SEH","","X","EH_CCD","N"})
aadd(_cCpoCusto,{"SEH","","X","EH_CCUSTO","N"})
aadd(_cCpoCusto,{"SET","","X","ET_CC","N"})
aadd(_cCpoCusto,{"SET","","X","ET_CCC","N"})
aadd(_cCpoCusto,{"SET","","X","ET_CCD","N"})
aadd(_cCpoCusto,{"SEU","","X","EU_CCC","N"})
aadd(_cCpoCusto,{"SEU","","X","EU_CCD","N"})
aadd(_cCpoCusto,{"SEU","","X","EU_GRPJUR","N"})
aadd(_cCpoCusto,{"SEW","","X","EW_CCUSTO","N"})
aadd(_cCpoCusto,{"SEZ","","X","EZ_CCUSTO","N"})
aadd(_cCpoCusto,{"SGS","","X","GS_CC","N"})
aadd(_cCpoCusto,{"SH1","","X","H1_CCUSTO","N"})
aadd(_cCpoCusto,{"SH9","","X","H9_CCUSTO","N"})
aadd(_cCpoCusto,{"SHB","","X","HB_CC","N"})
aadd(_cCpoCusto,{"SI1","","X","I1_CC","N"})
aadd(_cCpoCusto,{"SI2","","X","I2_CCC","N"})
aadd(_cCpoCusto,{"SI2","","X","I2_CCD","N"})
aadd(_cCpoCusto,{"SI3","","X","I3_CUSTO","N"})
aadd(_cCpoCusto,{"SI4","","X","I4_CUSTO","N"})
aadd(_cCpoCusto,{"SI9","","X","I9_CCC","N"})
aadd(_cCpoCusto,{"SI9","","X","I9_CCD","N"})
aadd(_cCpoCusto,{"SIA","","X","IA_CC","N"})
aadd(_cCpoCusto,{"SIB","","X","IB_CCC","N"})
aadd(_cCpoCusto,{"SIB","","X","IB_CCD","N"})
aadd(_cCpoCusto,{"SIB","","X","IB_ORIGEMC","N"})
aadd(_cCpoCusto,{"SIC","","X","IC_CCC","N"})
aadd(_cCpoCusto,{"SIC","","X","IC_CCD","N"})
aadd(_cCpoCusto,{"SL2","","X","L2_CCUSTO","N"})
aadd(_cCpoCusto,{"SLJ","","X","LJ_CCUSTO","N"})
aadd(_cCpoCusto,{"SLR","","X","LR_CCUSTO","N"})
aadd(_cCpoCusto,{"SN3","","X","N3_CCCDEP","N"})
aadd(_cCpoCusto,{"SN3","","X","N3_CCCDES","N"})
aadd(_cCpoCusto,{"SN3","","X","N3_CCCORR","N"})
aadd(_cCpoCusto,{"SN3","","X","N3_CCDESP","N"})
aadd(_cCpoCusto,{"SN3","","X","N3_CCUSTO","N"})
aadd(_cCpoCusto,{"SN3","","X","N3_CUSTBEM","N"})
aadd(_cCpoCusto,{"SN4","","X","N4_CCUSTO","N"})
aadd(_cCpoCusto,{"SN4","","X","N4_CCUSTOT","N"})
aadd(_cCpoCusto,{"SN6","","X","N6_CCUSTO","N"})
aadd(_cCpoCusto,{"SN7","","X","N7_CCUSTO","N"})
aadd(_cCpoCusto,{"SNA","","X","NA_CCUSTO","N"})
aadd(_cCpoCusto,{"SNC","","X","NC_CCUSTO","N"})
aadd(_cCpoCusto,{"SNG","","X","NG_CCCDEP","N"})
aadd(_cCpoCusto,{"SNG","","X","NG_CCCDES","N"})
aadd(_cCpoCusto,{"SNG","","X","NG_CCCORR","N"})
aadd(_cCpoCusto,{"SNG","","X","NG_CCDESP","N"})
aadd(_cCpoCusto,{"SNG","","X","NG_CCUSTO","N"})
aadd(_cCpoCusto,{"SNG","","X","NG_CUSTBEM","N"})
aadd(_cCpoCusto,{"SNM","","X","NM_CCCDEP","N"})
aadd(_cCpoCusto,{"SNM","","X","NM_CCCDES","N"})
aadd(_cCpoCusto,{"SNM","","X","NM_CCCORR","N"})
aadd(_cCpoCusto,{"SNM","","X","NM_CCDESP","N"})
aadd(_cCpoCusto,{"SNM","","X","NM_CCUSTO","N"})
aadd(_cCpoCusto,{"SNM","","X","NM_CUSTBEM","N"})
aadd(_cCpoCusto,{"SNN","","X","NN_CCCDEP","N"})
aadd(_cCpoCusto,{"SNN","","X","NN_CCDESP","N"})
aadd(_cCpoCusto,{"SNN","","X","NN_CUSTBEM","N"})
aadd(_cCpoCusto,{"SNR","","X","NR_CCCDEP","N"})
aadd(_cCpoCusto,{"SNS","","X","NS_CCUSTO","N"})
aadd(_cCpoCusto,{"SNV","","X","NV_CC","N"})
aadd(_cCpoCusto,{"SNW","","X","NW_NIV02","N"})
aadd(_cCpoCusto,{"SNX","","X","NX_NIV02","N"})
aadd(_cCpoCusto,{"SNY","","X","NY_NIV02","N"})
aadd(_cCpoCusto,{"SO3","","X","O3_CATIV","N"})
aadd(_cCpoCusto,{"SOC","","X","OC_CC","N"})
aadd(_cCpoCusto,{"SP0","","X","P0_CC","N"})
aadd(_cCpoCusto,{"SP2","","X","P2_CC","N"})
aadd(_cCpoCusto,{"SP2","","X","P2_CCPER01","N"})
aadd(_cCpoCusto,{"SP2","","X","P2_CCPER02","N"})
aadd(_cCpoCusto,{"SP2","","X","P2_CCPER03","N"})
aadd(_cCpoCusto,{"SP2","","X","P2_CCPER04","N"})
aadd(_cCpoCusto,{"SP5","","X","P5_CC","N"})
aadd(_cCpoCusto,{"SP8","","X","P8_CC","N"})
aadd(_cCpoCusto,{"SPB","","X","PB_CC","N"})
aadd(_cCpoCusto,{"SPC","","X","PC_CC","N"})
aadd(_cCpoCusto,{"SPG","","X","PG_CC","N"})
aadd(_cCpoCusto,{"SPH","","X","PH_CC","N"})
aadd(_cCpoCusto,{"SPI","","X","PI_CC","N"})
aadd(_cCpoCusto,{"SPK","","X","PK_CC","N"})
aadd(_cCpoCusto,{"SPL","","X","PL_CC","N"})
aadd(_cCpoCusto,{"SPN","","X","PN_CC","N"})
aadd(_cCpoCusto,{"SPY","","X","PY_CC","N"})
aadd(_cCpoCusto,{"SQ3","","X","Q3_CC","N"})
aadd(_cCpoCusto,{"SQ4","","X","Q4_CC","N"})
aadd(_cCpoCusto,{"SQB","","X","QB_CC","N"})
aadd(_cCpoCusto,{"SQG","","X","QG_CC","N"})
aadd(_cCpoCusto,{"SQS","","X","QS_CC","N"})
aadd(_cCpoCusto,{"SR0","","X","R0_CC","N"})
aadd(_cCpoCusto,{"SR1","","X","R1_CC","N"})
aadd(_cCpoCusto,{"SRA","","X","RA_CC","N"})
aadd(_cCpoCusto,{"SRC","","X","RC_CC","N"})
aadd(_cCpoCusto,{"SRD","","X","RD_CC","N"})
aadd(_cCpoCusto,{"SRE","","X","RE_CCD","N"})
aadd(_cCpoCusto,{"SRE","","X","RE_CCP","N"})
aadd(_cCpoCusto,{"SRI","","X","RI_CC","N"})
aadd(_cCpoCusto,{"SRK","","X","RK_CC","N"})
aadd(_cCpoCusto,{"SRL","","X","RL_CC","N"})
aadd(_cCpoCusto,{"SRO","","X","RO_CC","N"})
aadd(_cCpoCusto,{"SRR","","X","RR_CC","N"})
aadd(_cCpoCusto,{"SRT","","X","RT_CC","N"})
aadd(_cCpoCusto,{"SRZ","","X","RZ_CC","N"})
aadd(_cCpoCusto,{"SS4","","X","S4_CC","N"})
aadd(_cCpoCusto,{"SS4","","X","S4_CCCUSTO","N"})
aadd(_cCpoCusto,{"SS7","","X","S7_CCC","N"})
aadd(_cCpoCusto,{"SS7","","X","S7_CCD","N"})
aadd(_cCpoCusto,{"ST1","","X","T1_CCUSTO","N"})
aadd(_cCpoCusto,{"ST9","","X","T9_CCUSTO","N"})
aadd(_cCpoCusto,{"STC","","X","TC_CCUSTO","N"})
aadd(_cCpoCusto,{"STI","","X","TI_CCUSFIM","N"})
aadd(_cCpoCusto,{"STI","","X","TI_CCUSINI","N"})
aadd(_cCpoCusto,{"STJ","","X","TJ_CCUSTO","N"})
aadd(_cCpoCusto,{"STO","","X","TO_CCUSFIM","N"})
aadd(_cCpoCusto,{"STO","","X","TO_CCUSINI","N"})
aadd(_cCpoCusto,{"STP","","X","TP_CCUSTO","N"})
aadd(_cCpoCusto,{"STS","","X","TS_CCUSTO","N"})
aadd(_cCpoCusto,{"STW","","X","TW_CCUSTO","N"})
aadd(_cCpoCusto,{"SV7","","X","V7_CCUS","N"})
aadd(_cCpoCusto,{"SW1","","X","W1_CTCUSTO","N"})
aadd(_cCpoCusto,{"SW3","","X","W3_CTCUSTO","N"})
aadd(_cCpoCusto,{"TAA","","X","TAA_CCUSTO","N"})
aadd(_cCpoCusto,{"TAF","","X","TAF_CCUSTO","N"})
aadd(_cCpoCusto,{"TER","","X","TER_CCUSTO","N"})
aadd(_cCpoCusto,{"TFS","","X","TFS_CC","N"})
aadd(_cCpoCusto,{"TFT","","X","TFT_CC","N"})
aadd(_cCpoCusto,{"TI0","","X","TI0_CCUSTO","N"})
aadd(_cCpoCusto,{"TJ1","","X","TJ1_CC","N"})
aadd(_cCpoCusto,{"TJ2","","X","TJ2_CC","N"})
aadd(_cCpoCusto,{"TJ5","","X","TJ5_CC","N"})
aadd(_cCpoCusto,{"TK1","","X","TK1_CC","N"})
aadd(_cCpoCusto,{"TK2","","X","TK2_CC","N"})
aadd(_cCpoCusto,{"TK3","","X","TK3_CC","N"})
aadd(_cCpoCusto,{"TKF","","X","TKF_CODCC","N"})
aadd(_cCpoCusto,{"TKS","","X","TKS_CCCJN","N"})
aadd(_cCpoCusto,{"TLA","","X","TLA_CC","N"})
aadd(_cCpoCusto,{"TLC","","X","TLC_CCFIM","N"})
aadd(_cCpoCusto,{"TLC","","X","TLC_CCINI","N"})
aadd(_cCpoCusto,{"TLD","","X","TLD_CC","N"})
aadd(_cCpoCusto,{"TLJ","","X","TLJ_AREA","N"})
aadd(_cCpoCusto,{"TLJ","","X","TLJ_CC","N"})
aadd(_cCpoCusto,{"TLL","","X","TLL_CC","N"})
aadd(_cCpoCusto,{"TLM","","X","TLM_CC","N"})
aadd(_cCpoCusto,{"TLN","","X","TLN_CC","N"})
aadd(_cCpoCusto,{"TLO","","X","TLO_CC","N"})
aadd(_cCpoCusto,{"TLP","","X","TLP_CC","N"})
aadd(_cCpoCusto,{"TLR","","X","TLR_CC","N"})
aadd(_cCpoCusto,{"TM0","","X","TM0_CC","N"})
aadd(_cCpoCusto,{"TM5","","X","TM5_CC","N"})
aadd(_cCpoCusto,{"TMK","","X","TMK_CC","N"})
aadd(_cCpoCusto,{"TMV","","X","TMV_CC","N"})
aadd(_cCpoCusto,{"TMW","","X","TMW_CCATE","N"})
aadd(_cCpoCusto,{"TMW","","X","TMW_CCDE","N"})
aadd(_cCpoCusto,{"TMY","","X","TMY_NOVCC","N"})
aadd(_cCpoCusto,{"TN0","","X","TN0_CC","N"})
aadd(_cCpoCusto,{"TNC","","X","TNC_CC","N"})
aadd(_cCpoCusto,{"TNI","","X","TNI_CC","N"})
aadd(_cCpoCusto,{"TNN","","X","TNN_CC","N"})
aadd(_cCpoCusto,{"TNO","","X","TNO_AREA","N"})
aadd(_cCpoCusto,{"TNQ","","X","TNQ_AREA","N"})
aadd(_cCpoCusto,{"TO0","","X","TO0_CC","N"})
aadd(_cCpoCusto,{"TOB","","X","TOB_CC","N"})
aadd(_cCpoCusto,{"TOC","","X","TOC_CC","N"})
aadd(_cCpoCusto,{"TOH","","X","TOH_CC","N"})
aadd(_cCpoCusto,{"TP9","","X","TP9_CCUSTO","N"})
aadd(_cCpoCusto,{"TPN","","X","TPN_CCUSTO","N"})
aadd(_cCpoCusto,{"TPP","","X","TPP_CCUSTO","N"})
aadd(_cCpoCusto,{"TPW","","X","TPW_CCUSTO","N"})
aadd(_cCpoCusto,{"TQ2","","X","TQ2_CCORIG","N"})
aadd(_cCpoCusto,{"TQ2","","X","TQ2_CCUSTO","N"})
aadd(_cCpoCusto,{"TQA","","X","TQA_CCUSTO","N"})
aadd(_cCpoCusto,{"TQB","","X","TQB_CCUSTO","N"})
aadd(_cCpoCusto,{"TQN","","X","TQN_CCUSTO","N"})
aadd(_cCpoCusto,{"TR2","","X","TR2_CCUSTO","N"})
aadd(_cCpoCusto,{"TRF","","X","TRF_CCUSTO","N"})
aadd(_cCpoCusto,{"TRX","","X","TRX_CCUSTO","N"})
aadd(_cCpoCusto,{"TS2","","X","TS2_CCUSTO","N"})
aadd(_cCpoCusto,{"TSJ","","X","TSJ_CCUCON","N"})
aadd(_cCpoCusto,{"TSV","","X","TSV_CCUSTO","N"})
aadd(_cCpoCusto,{"TSX","","X","TSX_CCUSTO","N"})
aadd(_cCpoCusto,{"TT1","","X","TT1_CCATE","N"})
aadd(_cCpoCusto,{"TT1","","X","TT1_CCDE","N"})
aadd(_cCpoCusto,{"TTH","","X","TTH_CCUSTO","N"})
aadd(_cCpoCusto,{"TUH","","X","TUH_CCUSTO","N"})
aadd(_cCpoCusto,{"TV2","","X","TV2_CODFRE","N"})
aadd(_cCpoCusto,{"TVJ","","X","TVJ_CCUSTO","N"})
aadd(_cCpoCusto,{"TVL","","X","TVL_CCUSTO","N"})
aadd(_cCpoCusto,{"TY4","","X","TY4_CC","N"})
aadd(_cCpoCusto,{"TYA","","X","TYA_CC","N"})
aadd(_cCpoCusto,{"VAI","","X","VAI_CC","N"})
aadd(_cCpoCusto,{"VBH","","X","VBH_CC","N"})
aadd(_cCpoCusto,{"VDE","","X","VDE_CCUSTO","N"})
aadd(_cCpoCusto,{"VE4","","X","VE4_CENCUS","N"})
aadd(_cCpoCusto,{"VEC","","X","VEC_CENCUS","N"})
aadd(_cCpoCusto,{"VEM","","X","VEM_CENCUS","N"})
aadd(_cCpoCusto,{"VEN","","X","VEN_CENCUS","N"})
aadd(_cCpoCusto,{"VO3","","X","VO3_CENCUS","N"})
aadd(_cCpoCusto,{"VO4","","X","VO4_CENCUS","N"})
aadd(_cCpoCusto,{"VS1","","X","VS1_CENCUS","N"})
aadd(_cCpoCusto,{"VS3","","X","VS3_CENCUS","N"})
aadd(_cCpoCusto,{"VSC","","X","VSC_CENCUS","N"})
aadd(_cCpoCusto,{"VV0","","X","VV0_CCUSTO","N"})
aadd(_cCpoCusto,{"VV1","","X","VV1_CC","N"})
aadd(_cCpoCusto,{"VVA","","X","VVA_CENCUS","N"})
aadd(_cCpoCusto,{"VVG","","X","VVG_CENCUS","N"})
aadd(_cCpoCusto,{"VZ1","","X","VZ1_CENCUS","N"})


//novo 01020167 e o velho 30020029
 

aCcusto := {}
aadd(aCcusto,{"300000","1.1.000.001"})
aadd(aCcusto,{"301200","1.1.012"})
aadd(aCcusto,{"301201","1.1.012.001"})
aadd(aCcusto,{"301202","1.1.012.002"})
aadd(aCcusto,{"301203","1.1.012.003"})
aadd(aCcusto,{"301204","1.1.012.004"})
aadd(aCcusto,{"301205","1.1.012.005"})
aadd(aCcusto,{"301206","1.1.012.006"})
aadd(aCcusto,{"301700","1.1.017"})
aadd(aCcusto,{"301701","1.1.017.001"})
aadd(aCcusto,{"301702","1.1.017.002"})
aadd(aCcusto,{"301703","1.1.017.003"})
aadd(aCcusto,{"301704","1.1.017.004"})
aadd(aCcusto,{"301705","1.1.017.005"})
aadd(aCcusto,{"301706","1.1.017.006"})
aadd(aCcusto,{"301707","1.1.017.007"})
aadd(aCcusto,{"301708","1.1.017.008"})
aadd(aCcusto,{"301709","1.1.017.009"})
aadd(aCcusto,{"301710","1.1.017.010"})
aadd(aCcusto,{"301800","1.1.018"})
aadd(aCcusto,{"301801","1.1.018.001"})
aadd(aCcusto,{"301900","1.1.019"})
aadd(aCcusto,{"301901","1.1.019.001"})
aadd(aCcusto,{"301902","1.1.019.002"})
aadd(aCcusto,{"301903","1.1.019.003"})
aadd(aCcusto,{"301904","1.1.019.004"})
aadd(aCcusto,{"301905","1.1.019.005"})
aadd(aCcusto,{"301906","1.1.019.006"})
aadd(aCcusto,{"301907","1.1.019.007"})
aadd(aCcusto,{"301908","1.1.019.008"})
aadd(aCcusto,{"302200","1.1.022"})
aadd(aCcusto,{"302201","1.1.022.001"})
aadd(aCcusto,{"302202","1.1.022.002"})
aadd(aCcusto,{"302203","1.1.022.003"})
aadd(aCcusto,{"302101","1.1.022.004"})
aadd(aCcusto,{"302204","1.1.022.005"})
aadd(aCcusto,{"302102","1.1.022.006"})
aadd(aCcusto,{"302205","1.1.022.007"})
aadd(aCcusto,{"302103","1.1.022.008"})
aadd(aCcusto,{"301300","1.2.013"})
aadd(aCcusto,{"301301","1.2.013.001"})
aadd(aCcusto,{"301302","1.2.013.002"})
aadd(aCcusto,{"301303","1.2.013.003"})
aadd(aCcusto,{"301304","1.2.013.004"})
aadd(aCcusto,{"301305","1.2.013.005"})
aadd(aCcusto,{"301306","1.2.013.006"})
aadd(aCcusto,{"301307","1.2.013.007"})
aadd(aCcusto,{"301308","1.2.013.008"})
aadd(aCcusto,{"301309","1.2.013.009"})
aadd(aCcusto,{"301310","1.2.013.010"})
aadd(aCcusto,{"301500","1.2.015"})
aadd(aCcusto,{"301501","1.2.015.001"})
aadd(aCcusto,{"301502","1.2.015.002"})
aadd(aCcusto,{"301505","1.2.015.003"})
aadd(aCcusto,{"301506","1.2.015.004"})
aadd(aCcusto,{"301507","1.2.015.005"})
aadd(aCcusto,{"301508","1.2.015.006"})
aadd(aCcusto,{"301509","1.2.015.007"})
aadd(aCcusto,{"301510","1.2.015.008"})
aadd(aCcusto,{"301511","1.2.015.009"})
aadd(aCcusto,{"301512","1.2.015.010"})
aadd(aCcusto,{"301513","1.2.015.011"})
aadd(aCcusto,{"301514","1.2.015.012"})
aadd(aCcusto,{"301515","1.2.015.013"})
aadd(aCcusto,{"301516","1.2.015.014"})
aadd(aCcusto,{"301517","1.2.015.015"})
aadd(aCcusto,{"301518","1.2.015.016"})
aadd(aCcusto,{"301662","1.2.015.017"})
aadd(aCcusto,{"301520","1.2.015.018"})
aadd(aCcusto,{"301521","1.2.015.019"})
aadd(aCcusto,{"301522","1.2.015.020"})
aadd(aCcusto,{"301664","1.2.015.021"})
aadd(aCcusto,{"301661","1.2.015.022"})
aadd(aCcusto,{"301525","1.2.015.023"})
aadd(aCcusto,{"301503","1.2.015.024"})
aadd(aCcusto,{"301504","1.2.015.025"})
aadd(aCcusto,{"301526","1.2.015.026"})
aadd(aCcusto,{"301527","1.2.015.027"})
aadd(aCcusto,{"301528","1.2.015.028"})
aadd(aCcusto,{"301529","1.2.015.029"})
aadd(aCcusto,{"301530","1.2.015.030"})
aadd(aCcusto,{"301531","1.2.015.031"})
aadd(aCcusto,{"301532","1.2.015.032"})
aadd(aCcusto,{"301533","1.2.015.033"})
aadd(aCcusto,{"301534","1.2.015.034"})
aadd(aCcusto,{"301535","1.2.015.035"})
aadd(aCcusto,{"301536","1.2.015.036"})
aadd(aCcusto,{"301600","1.2.016"})
aadd(aCcusto,{"301601","1.2.016.001"})
aadd(aCcusto,{"301603","1.2.016.002"})
aadd(aCcusto,{"301604","1.2.016.003"})
aadd(aCcusto,{"301605","1.2.016.004"})
aadd(aCcusto,{"301606","1.2.016.005"})
aadd(aCcusto,{"301607","1.2.016.006"})
aadd(aCcusto,{"301608","1.2.016.007"})
aadd(aCcusto,{"301609","1.2.016.008"})
aadd(aCcusto,{"301610","1.2.016.009"})
aadd(aCcusto,{"301611","1.2.016.010"})
aadd(aCcusto,{"301612","1.2.016.011"})
aadd(aCcusto,{"301613","1.2.016.012"})
aadd(aCcusto,{"301614","1.2.016.013"})
aadd(aCcusto,{"301615","1.2.016.014"})
aadd(aCcusto,{"301616","1.2.016.015"})
aadd(aCcusto,{"301617","1.2.016.016"})
aadd(aCcusto,{"301618","1.2.016.017"})
aadd(aCcusto,{"301619","1.2.016.018"})
aadd(aCcusto,{"301620","1.2.016.019"})
aadd(aCcusto,{"301621","1.2.016.020"})
aadd(aCcusto,{"301622","1.2.016.021"})
aadd(aCcusto,{"301660","1.2.016.022"})
aadd(aCcusto,{"301623","1.2.016.023"})
aadd(aCcusto,{"301624","1.2.016.024"})
aadd(aCcusto,{"301625","1.2.016.025"})
aadd(aCcusto,{"301626","1.2.016.026"})
aadd(aCcusto,{"301627","1.2.016.027"})
aadd(aCcusto,{"301628","1.2.016.028"})
aadd(aCcusto,{"301629","1.2.016.029"})
aadd(aCcusto,{"301630","1.2.016.030"})
aadd(aCcusto,{"301631","1.2.016.031"})
aadd(aCcusto,{"301632","1.2.016.032"})
aadd(aCcusto,{"301602","1.2.016.033"})
aadd(aCcusto,{"301633","1.2.016.034"})
aadd(aCcusto,{"301634","1.2.016.035"})
aadd(aCcusto,{"301635","1.2.016.036"})
aadd(aCcusto,{"301636","1.2.016.037"})
aadd(aCcusto,{"301637","1.2.016.038"})
aadd(aCcusto,{"301638","1.2.016.039"})
aadd(aCcusto,{"301639","1.2.016.040"})
aadd(aCcusto,{"301640","1.2.016.041"})
aadd(aCcusto,{"301641","1.2.016.042"})
aadd(aCcusto,{"301642","1.2.016.043"})
aadd(aCcusto,{"301643","1.2.016.044"})
aadd(aCcusto,{"301644","1.2.016.045"})
aadd(aCcusto,{"301645","1.2.016.046"})
aadd(aCcusto,{"301646","1.2.016.047"})
aadd(aCcusto,{"301647","1.2.016.048"})
aadd(aCcusto,{"301648","1.2.016.049"})
aadd(aCcusto,{"301649","1.2.016.050"})
aadd(aCcusto,{"301650","1.2.016.051"})
aadd(aCcusto,{"301651","1.2.016.052"})
aadd(aCcusto,{"301652","1.2.016.053"})
aadd(aCcusto,{"301653","1.2.016.054"})
aadd(aCcusto,{"301654","1.2.016.055"})
aadd(aCcusto,{"301655","1.2.016.056"})
aadd(aCcusto,{"301656","1.2.016.057"})
aadd(aCcusto,{"301657","1.2.016.058"})
aadd(aCcusto,{"301658","1.2.016.059"})
aadd(aCcusto,{"301659","1.2.016.060"})
aadd(aCcusto,{"302800","1.2.028"})
aadd(aCcusto,{"302801","1.2.028.001"})
aadd(aCcusto,{"302802","1.2.028.002"})
aadd(aCcusto,{"302803","1.2.028.003"})
aadd(aCcusto,{"302804","1.2.028.004"})
aadd(aCcusto,{"302805","1.2.028.005"})
aadd(aCcusto,{"302806","1.2.028.006"})
aadd(aCcusto,{"302807","1.2.028.007"})
aadd(aCcusto,{"302808","1.2.028.008"})
aadd(aCcusto,{"302809","1.2.028.009"})
aadd(aCcusto,{"302810","1.2.028.010"})
aadd(aCcusto,{"302811","1.2.028.011"})
aadd(aCcusto,{"302812","1.2.028.012"})
aadd(aCcusto,{"302813","1.2.028.013"})
aadd(aCcusto,{"302814","1.2.028.014"})
aadd(aCcusto,{"302815","1.2.028.015"})
aadd(aCcusto,{"302816","1.2.028.016"})
aadd(aCcusto,{"302817","1.2.028.017"})
aadd(aCcusto,{"302818","1.2.028.018"})
aadd(aCcusto,{"302900","1.2.029"})
aadd(aCcusto,{"302901","1.2.029.001"})
aadd(aCcusto,{"302902","1.2.029.002"})
aadd(aCcusto,{"302903","1.2.029.003"})
aadd(aCcusto,{"302904","1.2.029.004"})
aadd(aCcusto,{"302905","1.2.029.005"})

*/
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

For nPos := 1 To Len(_aCpoCusto)
	If SX2->(dbSeek(_aCpoCusto[nPos,1]))
		_aCpoCusto[nPos][2] := upper(X2_ARQUIVO)
		_aCpoCusto[nPos][3] := upper(X2_MODO)
	Endif
Next

// verificando a existencia da tabela no array proveniente no DATABASE
// somente tabelas existentes devem ser processadas

oProcess:SetRegua1(len(_aCpoCusto)) //Alimenta a primeira barra de progresso

For i:= 1 to len(_aCpoCusto)
	oProcess:IncRegua1("Analisando Tabelas")
	
	nPos := aScan(_aArqtrf,{ |X| alltrim(upper(X[1])) == alltrim(upper(_aCpoCusto[i][2])) })
	If nPos <> 0
		_aCpoCusto[i][5] := "S"
	Endif
Next


oProcess:SetRegua1(len(_aCpoCusto)) //Alimenta a primeira barra de progresso
	
_lErro := .f.
	
For i:= 1 to len(_aCpoCusto)
	oProcess:IncRegua1("Atualizando - "+_aCpoCusto[i][2] + " Campo " + _aCpoCusto[i][4])
		
	if _aCpoCusto[i][5]  == "S"
			
		_lOpen := .f.
			
		if  select(_aCpoCusto[i][1]) > 0
			// Tabela ja aberta
			DbSelectArea(_aCpoCusto[i][1])
		Else
			// tabela nao esta aberta
			// tem que abrit para fechar depois
				
			_cArqtrf   := RetArq(__cRDD,_aCpoCusto[i][2])
			_cArqAlias := _aCpoCusto[i][1]
				
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
			
		if nReg > 0  .and. fieldpos(_aCpoCusto[i][4]) > 0
				
			_cTabNome  := alltrim(upper(_aCpoCusto[i][2]))
			_cModoUso  := alltrim(upper(_aCpoCusto[i][3]))
			_cCpoNome  := alltrim(upper(_aCpoCusto[i][4]))
				
				
			_cCpoFil := substr(_cCpoNome,1,at("_",_cCpoNome))+"FILIAL"
				
			if _cModoUso == "C"
				_cFilTab   := space(02)
			Else
				_cFilTab   := xFilial(_aCpoCusto[i][1])
			Endif
				
			nReg := Len(aCcusto)  
			oProcess:SetRegua2(nReg) //Alimenta a primeira barra de progresso
			For nProd := 1 To Len(aCcusto)
				oProcess:IncRegua2(" Novo: " + aCcusto[nProd,2] + " Velho: " + aCcusto[nProd,1] + " - ("+AllTrim(Str(nProd))+")")
								
				_cCodNovo	:=	aCcusto[nProd,2] 
				_cCodVelho	:=	aCcusto[nProd,1]				
				
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
			//alert("Campo "+_aCpoCusto[i][4]+" inexistente na tabela ou tabela vazia ")
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