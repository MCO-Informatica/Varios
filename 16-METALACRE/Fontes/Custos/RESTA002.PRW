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

aadd(_aCpoCusto,{"AA1","","X","AA1_CC","N"})
aadd(_aCpoCusto,{"AAH","","X","AAH_CCUSTO","N"})
aadd(_aCpoCusto,{"ABS","","X","ABS_CCUSTO","N"})
aadd(_aCpoCusto,{"AF2","","X","AF2_CCUSTO","N"})
aadd(_aCpoCusto,{"AF9","","X","AF9_CCUSTO","N"})
aadd(_aCpoCusto,{"AGG","","X","AGG_CC","N"})
aadd(_aCpoCusto,{"AGH","","X","AGH_CC","N"})
aadd(_aCpoCusto,{"AK2","","X","AK2_CC","N"})
aadd(_aCpoCusto,{"AKD","","X","AKD_CC","N"})
aadd(_aCpoCusto,{"AKX","","X","AKX_CC_FIN","N"})
aadd(_aCpoCusto,{"AKX","","X","AKX_CC_INI","N"})
aadd(_aCpoCusto,{"ALN","","X","ALN_CC","N"})
aadd(_aCpoCusto,{"ALO","","X","ALO_CC","N"})
aadd(_aCpoCusto,{"ALP","","X","ALP_CC","N"})
aadd(_aCpoCusto,{"ALX","","X","ALX_CC","N"})
aadd(_aCpoCusto,{"AMJ","","X","AMJ_CC","N"})
aadd(_aCpoCusto,{"AMY","","X","AMY_CCSUP","N"})
aadd(_aCpoCusto,{"AMY","","X","AMY_CCUSTO","N"})
aadd(_aCpoCusto,{"AMZ","","X","AMZ_CC","N"})
aadd(_aCpoCusto,{"BAU","","X","BAU_CC","N"})
aadd(_aCpoCusto,{"BCE","","X","BCE_CC","N"})
aadd(_aCpoCusto,{"BD5","","X","BD5_CC","N"})
aadd(_aCpoCusto,{"BD6","","X","BD6_CC","N"})
aadd(_aCpoCusto,{"BD7","","X","BD7_CC","N"})
aadd(_aCpoCusto,{"BE4","","X","BE4_CC","N"})
aadd(_aCpoCusto,{"BI3","","X","BI3_CC","N"})
aadd(_aCpoCusto,{"BMS","","X","BMS_CC","N"})
aadd(_aCpoCusto,{"BSQ","","X","BSQ_CC","N"})
aadd(_aCpoCusto,{"BT6","","X","BT6_CC","N"})
aadd(_aCpoCusto,{"CB0","","X","CB0_CC","N"})
aadd(_aCpoCusto,{"CF6","","X","CF6_CODCCS","N"})
aadd(_aCpoCusto,{"CF8","","X","CF8_CODCCS","N"})
aadd(_aCpoCusto,{"CL2","","X","CL2_CCUS","N"})
aadd(_aCpoCusto,{"CNB","","X","CNB_CC","N"})
aadd(_aCpoCusto,{"CNE","","X","CNE_CC","N"})
aadd(_aCpoCusto,{"CNW","","X","CNW_CC","N"})
aadd(_aCpoCusto,{"CNZ","","X","CNZ_CC","N"})
aadd(_aCpoCusto,{"CO1","","X","CO1_CC","N"})
aadd(_aCpoCusto,{"CO5","","X","CO5_CODARE","N"})
aadd(_aCpoCusto,{"COJ","","X","COJ_CUSTO","N"})
aadd(_aCpoCusto,{"CQ2","","X","CQ2_CCUSTO","N"})
aadd(_aCpoCusto,{"CQ3","","X","CQ3_CCUSTO","N"})
aadd(_aCpoCusto,{"CQ4","","X","CQ4_CCUSTO","N"})
aadd(_aCpoCusto,{"CQ5","","X","CQ5_CCUSTO","N"})
aadd(_aCpoCusto,{"CQ6","","X","CQ6_CCUSTO","N"})
aadd(_aCpoCusto,{"CQ7","","X","CQ7_CCUSTO","N"})
aadd(_aCpoCusto,{"CQ8","","X","CQ8_CODIGO","N"})
aadd(_aCpoCusto,{"CQ9","","X","CQ9_CODIGO","N"})
aadd(_aCpoCusto,{"CQB","","X","CQB_CCUSTO","N"})
aadd(_aCpoCusto,{"CQE","","X","CQE_CUSTO","N"})
aadd(_aCpoCusto,{"CQK","","X","CQK_CCC","N"})
aadd(_aCpoCusto,{"CQK","","X","CQK_CCD","N"})
aadd(_aCpoCusto,{"CT1","","X","CT1_CC","N"})
aadd(_aCpoCusto,{"CT2","","X","CT2_CCC","N"})
aadd(_aCpoCusto,{"CT2","","X","CT2_CCD","N"})
aadd(_aCpoCusto,{"CT3","","X","CT3_CUSTO","N"})
aadd(_aCpoCusto,{"CT4","","X","CT4_CUSTO","N"})
aadd(_aCpoCusto,{"CT9","","X","CT9_CCC","N"})
aadd(_aCpoCusto,{"CT9","","X","CT9_CCD","N"})
aadd(_aCpoCusto,{"CTA","","X","CTA_CUSTO","N"})
aadd(_aCpoCusto,{"CTB","","X","CTB_CCDES","N"})
aadd(_aCpoCusto,{"CTB","","X","CTB_CTTFIM","N"})
aadd(_aCpoCusto,{"CTB","","X","CTB_CTTINI","N"})
aadd(_aCpoCusto,{"CTI","","X","CTI_CUSTO","N"})
aadd(_aCpoCusto,{"CTJ","","X","CTJ_CCC","N"})
aadd(_aCpoCusto,{"CTJ","","X","CTJ_CCD","N"})
aadd(_aCpoCusto,{"CTK","","X","CTK_CCC","N"})
aadd(_aCpoCusto,{"CTK","","X","CTK_CCD","N"})
aadd(_aCpoCusto,{"CTQ","","X","CTQ_CCCPAR","N"})
aadd(_aCpoCusto,{"CTQ","","X","CTQ_CCORI","N"})
aadd(_aCpoCusto,{"CTQ","","X","CTQ_CCPAR","N"})
aadd(_aCpoCusto,{"CTS","","X","CTS_CTTFIM","N"})
aadd(_aCpoCusto,{"CTS","","X","CTS_CTTINI","N"})
//aadd(_aCpoCusto,{"CTT","","X","CTT_CCLP","N"})
//aadd(_aCpoCusto,{"CTT","","X","CTT_CCPON","N"})
//aadd(_aCpoCusto,{"CTT","","X","CTT_CCRED","N"})
//aadd(_aCpoCusto,{"CTT","","X","CTT_CCSUP","N"})
//aadd(_aCpoCusto,{"CTT","","X","CTT_CCVM","N"})
//aadd(_aCpoCusto,{"CTT","","X","CTT_CUSTO","N"})
aadd(_aCpoCusto,{"CTU","","X","CTU_CODIGO","N"})
aadd(_aCpoCusto,{"CTV","","X","CTV_CUSTO","N"})
aadd(_aCpoCusto,{"CTW","","X","CTW_CUSTO","N"})
aadd(_aCpoCusto,{"CTY","","X","CTY_CUSTO","N"})
aadd(_aCpoCusto,{"CTZ","","X","CTZ_CUSTO","N"})
aadd(_aCpoCusto,{"CV1","","X","CV1_CTTFIM","N"})
aadd(_aCpoCusto,{"CV1","","X","CV1_CTTINI","N"})
aadd(_aCpoCusto,{"CV3","","X","CV3_CCC","N"})
aadd(_aCpoCusto,{"CV3","","X","CV3_CCD","N"})
aadd(_aCpoCusto,{"CV4","","X","CV4_CCC","N"})
aadd(_aCpoCusto,{"CV4","","X","CV4_CCD","N"})
aadd(_aCpoCusto,{"CV5","","X","CV5_CTTDES","N"})
aadd(_aCpoCusto,{"CV5","","X","CV5_CTTFIM","N"})
aadd(_aCpoCusto,{"CV5","","X","CV5_CTTORI","N"})
aadd(_aCpoCusto,{"CV6","","X","CV6_CCC","N"})
aadd(_aCpoCusto,{"CV6","","X","CV6_CCD","N"})
aadd(_aCpoCusto,{"CV9","","X","CV9_CCCPAR","N"})
aadd(_aCpoCusto,{"CV9","","X","CV9_CCORI","N"})
aadd(_aCpoCusto,{"CV9","","X","CV9_CCPAR","N"})
aadd(_aCpoCusto,{"CVD","","X","CVD_CUSTO","N"})
aadd(_aCpoCusto,{"CVX","","X","CVX_NIV02","N"})
aadd(_aCpoCusto,{"CVY","","X","CVY_NIV02","N"})
aadd(_aCpoCusto,{"CVZ","","X","CVZ_NIV02","N"})
aadd(_aCpoCusto,{"CW1","","X","CW1_CCUSTO","N"})
aadd(_aCpoCusto,{"CW2","","X","CW2_CTTPAR","N"})
aadd(_aCpoCusto,{"CWK","","X","CWK_CC","N"})
aadd(_aCpoCusto,{"CX0","","X","CX0_CC","N"})
aadd(_aCpoCusto,{"CXP","","X","CXP_CC","N"})
aadd(_aCpoCusto,{"CYB","","X","CYB_CDCECS","N"})
aadd(_aCpoCusto,{"CYI","","X","CYI_CDCECS","N"})
aadd(_aCpoCusto,{"DBC","","X","DBC_CC","N"})
aadd(_aCpoCusto,{"DBK","","X","DBK_CC","N"})
aadd(_aCpoCusto,{"DBL","","X","DBL_CC","N"})
aadd(_aCpoCusto,{"DFA","","X","DFA_CC","N"})
aadd(_aCpoCusto,{"DFA","","X","DFA_CC2","N"})
aadd(_aCpoCusto,{"DFZ","","X","DFZ_CC","N"})
aadd(_aCpoCusto,{"DFZ","","X","DFZ_CC2","N"})
aadd(_aCpoCusto,{"DH1","","X","DH1_CC","N"})
aadd(_aCpoCusto,{"DT7","","X","DT7_CC","N"})
aadd(_aCpoCusto,{"FJ0","","X","FJ0_CCUSTO","N"})
aadd(_aCpoCusto,{"FK1","","X","FK1_CCUSTO","N"})
aadd(_aCpoCusto,{"FK2","","X","FK2_CCUSTO","N"})
aadd(_aCpoCusto,{"FK5","","X","FK5_CCUSTO","N"})
aadd(_aCpoCusto,{"FK8","","X","FK8_CCC","N"})
aadd(_aCpoCusto,{"FK8","","X","FK8_CCD","N"})
aadd(_aCpoCusto,{"FKM","","X","FKM_CUSTO","N"})
aadd(_aCpoCusto,{"FL5","","X","FL5_CC","N"})
aadd(_aCpoCusto,{"FLE","","X","FLE_CUSTO","N"})
aadd(_aCpoCusto,{"FLF","","X","FLF_CC","N"})
aadd(_aCpoCusto,{"FLG","","X","FLG_CUSTO","N"})
aadd(_aCpoCusto,{"FLH","","X","FLH_CC","N"})
aadd(_aCpoCusto,{"FLP","","X","FLP_CCUSTO","N"})
aadd(_aCpoCusto,{"FN9","","X","FN9_CCBEMD","N"})
aadd(_aCpoCusto,{"FN9","","X","FN9_CCCDD","N"})
aadd(_aCpoCusto,{"FN9","","X","FN9_CCCORD","N"})
aadd(_aCpoCusto,{"FN9","","X","FN9_CCDAD","N"})
aadd(_aCpoCusto,{"FN9","","X","FN9_CCDDD","N"})
aadd(_aCpoCusto,{"FN9","","X","FN9_CCDESD","N"})
aadd(_aCpoCusto,{"FNE","","X","FNE_ENT02A","N"})
aadd(_aCpoCusto,{"FNE","","X","FNE_ENT02B","N"})
aadd(_aCpoCusto,{"FNE","","X","FNE_ENT02D","N"})
aadd(_aCpoCusto,{"FNF","","X","FNF_ENT02","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCBEMD","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCBEMO","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCCDD","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCCDO","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCCORD","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCCORO","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCDAD","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCDAO","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCDDD","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCDDO","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCDESD","N"})
aadd(_aCpoCusto,{"FNS","","X","FNS_CCDESO","N"})
aadd(_aCpoCusto,{"FNU","","X","FNU_CUSTO","N"})
aadd(_aCpoCusto,{"FNZ","","X","FNZ_CCCDEP","N"})
aadd(_aCpoCusto,{"FNZ","","X","FNZ_CCCDES","N"})
aadd(_aCpoCusto,{"FNZ","","X","FNZ_CCCORR","N"})
aadd(_aCpoCusto,{"FNZ","","X","FNZ_CCDESP","N"})
aadd(_aCpoCusto,{"FNZ","","X","FNZ_CCUSTO","N"})
aadd(_aCpoCusto,{"FNZ","","X","FNZ_CUSTBE","N"})
aadd(_aCpoCusto,{"FO6","","X","FO6_CC","N"})
aadd(_aCpoCusto,{"FRK","","X","FRK_CCUSTO","N"})
aadd(_aCpoCusto,{"FW6","","X","FW6_CC","N"})
aadd(_aCpoCusto,{"FWN","","X","FWN_CCUSTO","N"})
aadd(_aCpoCusto,{"G3R","","X","G3R_CCUSTO","N"})
aadd(_aCpoCusto,{"G48","","X","G48_CCUSTO","N"})
aadd(_aCpoCusto,{"GW3","","X","GW3_CC","N"})
aadd(_aCpoCusto,{"JAF","","X","JAF_CCUSTO","N"})
aadd(_aCpoCusto,{"JCJ","","X","JCJ_CCUSTO","N"})
aadd(_aCpoCusto,{"JDN","","X","JDN_CCUSTO","N"})
aadd(_aCpoCusto,{"NN1","","X","NN1_CC","N"})
aadd(_aCpoCusto,{"NN2","","X","NN2_CC","N"})
aadd(_aCpoCusto,{"NN3","","X","NN3_CC","N"})
aadd(_aCpoCusto,{"NN7","","X","NN7_CCD","N"})
aadd(_aCpoCusto,{"NN9","","X","NN9_CC","N"})
aadd(_aCpoCusto,{"NO1","","X","NO1_CCC","N"})
aadd(_aCpoCusto,{"NOA","","X","NOA_CC","N"})
aadd(_aCpoCusto,{"NP6","","X","NP6_CC","N"})
aadd(_aCpoCusto,{"NP9","","X","NP9_CCUSTO","N"})
aadd(_aCpoCusto,{"NQD","","X","NQD_CC","N"})
aadd(_aCpoCusto,{"NSS","","X","NSS_CC","N"})
aadd(_aCpoCusto,{"NSZ","","X","NSZ_CCUSTO","N"})
aadd(_aCpoCusto,{"NUE","","X","NUE_CC","N"})
aadd(_aCpoCusto,{"NUS","","X","NUS_CC","N"})
aadd(_aCpoCusto,{"NVM","","X","NVM_CC","N"})
aadd(_aCpoCusto,{"NVS","","X","NVS_CCUSTO","N"})
aadd(_aCpoCusto,{"NVU","","X","NVU_CCUSTO","N"})
aadd(_aCpoCusto,{"NZQ","","X","NZQ_GRPJUR","N"})
aadd(_aCpoCusto,{"O0F","","X","O0F_CCUSTO","N"})
aadd(_aCpoCusto,{"OH7","","X","OH7_CCCUST","N"})
aadd(_aCpoCusto,{"OH8","","X","OH8_CCCUST","N"})
aadd(_aCpoCusto,{"OHB","","X","OHB_CCUSTD","N"})
aadd(_aCpoCusto,{"OHB","","X","OHB_CCUSTO","N"})
aadd(_aCpoCusto,{"OHE","","X","OHE_CCCUST","N"})
aadd(_aCpoCusto,{"OHF","","X","OHF_CCUSTO","N"})
aadd(_aCpoCusto,{"OHG","","X","OHG_CCUSTO","N"})
aadd(_aCpoCusto,{"RA2","","X","RA2_CC","N"})
aadd(_aCpoCusto,{"RA5","","X","RA5_CC","N"})
aadd(_aCpoCusto,{"RA8","","X","RA8_CC","N"})
aadd(_aCpoCusto,{"RB8","","X","RB8_CC","N"})
aadd(_aCpoCusto,{"RBA","","X","RBA_CC","N"})
aadd(_aCpoCusto,{"RBD","","X","RBD_CC","N"})
aadd(_aCpoCusto,{"RBE","","X","RBE_CC","N"})
aadd(_aCpoCusto,{"RBH","","X","RBH_CC","N"})
aadd(_aCpoCusto,{"RBT","","X","RBT_CC","N"})
aadd(_aCpoCusto,{"RBU","","X","RBU_CC","N"})
aadd(_aCpoCusto,{"RC1","","X","RC1_CC","N"})
aadd(_aCpoCusto,{"RC6","","X","RC6_CC","N"})
aadd(_aCpoCusto,{"RCZ","","X","RCZ_CCUSTO","N"})
aadd(_aCpoCusto,{"RD0","","X","RD0_CC","N"})
aadd(_aCpoCusto,{"RE0","","X","RE0_CC","N"})
aadd(_aCpoCusto,{"REL","","X","REL_CC","N"})
aadd(_aCpoCusto,{"REP","","X","REP_CC","N"})
aadd(_aCpoCusto,{"RF7","","X","RF7_CC","N"})
aadd(_aCpoCusto,{"RFA","","X","RFA_CC","N"})
aadd(_aCpoCusto,{"RFC","","X","RFC_CC","N"})
aadd(_aCpoCusto,{"RFF","","X","RFF_CC","N"})
aadd(_aCpoCusto,{"RFG","","X","RFG_CC","N"})
aadd(_aCpoCusto,{"RFH","","X","RFH_CC","N"})
aadd(_aCpoCusto,{"RFK","","X","RFK_CC","N"})
aadd(_aCpoCusto,{"RG1","","X","RG1_CC","N"})
aadd(_aCpoCusto,{"RG2","","X","RG2_CC","N"})
aadd(_aCpoCusto,{"RGB","","X","RGB_CC","N"})
aadd(_aCpoCusto,{"RGW","","X","RGW_CCUSTO","N"})
aadd(_aCpoCusto,{"RHH","","X","RHH_CC","N"})
aadd(_aCpoCusto,{"RHQ","","X","RHQ_CC","N"})
aadd(_aCpoCusto,{"RHT","","X","RHT_CC","N"})
aadd(_aCpoCusto,{"RJ3","","X","RJ3_COD","N"})
aadd(_aCpoCusto,{"RJ5","","X","RJ5_CC","N"})
aadd(_aCpoCusto,{"RJ5","","X","RJ5_COD","N"})
aadd(_aCpoCusto,{"SA5","","X","A5_CCUSTO","N"})
aadd(_aCpoCusto,{"SB1","","X","B1_CC","N"})
aadd(_aCpoCusto,{"SB1","","X","B1_CCCUSTO","N"})
aadd(_aCpoCusto,{"SBC","","X","BC_CC","N"})
aadd(_aCpoCusto,{"SC1","","X","C1_CC","N"})
aadd(_aCpoCusto,{"SC2","","X","C2_CC","N"})
aadd(_aCpoCusto,{"SC3","","X","C3_CC","N"})
aadd(_aCpoCusto,{"SC6","","X","C6_CC","N"})
aadd(_aCpoCusto,{"SC6","","X","C6_CCUSTO","N"})
aadd(_aCpoCusto,{"SC7","","X","C7_CC","N"})
aadd(_aCpoCusto,{"SCH","","X","CH_CC","N"})
aadd(_aCpoCusto,{"SCP","","X","CP_CC","N"})
aadd(_aCpoCusto,{"SCQ","","X","CQ_CC","N"})
aadd(_aCpoCusto,{"SCT","","X","CT_CCUSTO","N"})
aadd(_aCpoCusto,{"SCX","","X","CX_CC","N"})
aadd(_aCpoCusto,{"SCY","","X","CY_CC","N"})
aadd(_aCpoCusto,{"SD1","","X","D1_CC","N"})
aadd(_aCpoCusto,{"SD2","","X","D2_CCUSTO","N"})
aadd(_aCpoCusto,{"SD3","","X","D3_CC","N"})
aadd(_aCpoCusto,{"SDE","","X","DE_CC","N"})
aadd(_aCpoCusto,{"SDG","","X","DG_CC","N"})
aadd(_aCpoCusto,{"SE1","","X","E1_CCC","N"})
aadd(_aCpoCusto,{"SE1","","X","E1_CCD","N"})
aadd(_aCpoCusto,{"SE1","","X","E1_CCUSTO","N"})
aadd(_aCpoCusto,{"SE2","","X","E2_CCC","N"})
aadd(_aCpoCusto,{"SE2","","X","E2_CCD","N"})
aadd(_aCpoCusto,{"SE2","","X","E2_CCUSTO","N"})
aadd(_aCpoCusto,{"SE3","","X","E3_CCC","N"})
aadd(_aCpoCusto,{"SE3","","X","E3_CCD","N"})
aadd(_aCpoCusto,{"SE3","","X","E3_CCUSTO","N"})
aadd(_aCpoCusto,{"SE5","","X","E5_CCC","N"})
aadd(_aCpoCusto,{"SE5","","X","E5_CCD","N"})
aadd(_aCpoCusto,{"SE5","","X","E5_CCUSTO","N"})
aadd(_aCpoCusto,{"SE7","","X","E7_CCC","N"})
aadd(_aCpoCusto,{"SE7","","X","E7_CCD","N"})
aadd(_aCpoCusto,{"SE7","","X","E7_CCUSTO","N"})
aadd(_aCpoCusto,{"SEA","","X","EA_CCC","N"})
aadd(_aCpoCusto,{"SEA","","X","EA_CCD","N"})
aadd(_aCpoCusto,{"SED","","X","ED_CCC","N"})
aadd(_aCpoCusto,{"SED","","X","ED_CCD","N"})
aadd(_aCpoCusto,{"SEF","","X","EF_CCC","N"})
aadd(_aCpoCusto,{"SEF","","X","EF_CCD","N"})
aadd(_aCpoCusto,{"SEH","","X","EH_CCC","N"})
aadd(_aCpoCusto,{"SEH","","X","EH_CCD","N"})
aadd(_aCpoCusto,{"SEH","","X","EH_CCUSTO","N"})
aadd(_aCpoCusto,{"SET","","X","ET_CC","N"})
aadd(_aCpoCusto,{"SET","","X","ET_CCC","N"})
aadd(_aCpoCusto,{"SET","","X","ET_CCD","N"})
aadd(_aCpoCusto,{"SEU","","X","EU_CCC","N"})
aadd(_aCpoCusto,{"SEU","","X","EU_CCD","N"})
aadd(_aCpoCusto,{"SEU","","X","EU_GRPJUR","N"})
aadd(_aCpoCusto,{"SEW","","X","EW_CCUSTO","N"})
aadd(_aCpoCusto,{"SEZ","","X","EZ_CCUSTO","N"})
aadd(_aCpoCusto,{"SGS","","X","GS_CC","N"})
aadd(_aCpoCusto,{"SH1","","X","H1_CCUSTO","N"})
aadd(_aCpoCusto,{"SH9","","X","H9_CCUSTO","N"})
aadd(_aCpoCusto,{"SHB","","X","HB_CC","N"})
aadd(_aCpoCusto,{"SI1","","X","I1_CC","N"})
aadd(_aCpoCusto,{"SI2","","X","I2_CCC","N"})
aadd(_aCpoCusto,{"SI2","","X","I2_CCD","N"})
aadd(_aCpoCusto,{"SI3","","X","I3_CUSTO","N"})
aadd(_aCpoCusto,{"SI4","","X","I4_CUSTO","N"})
aadd(_aCpoCusto,{"SI9","","X","I9_CCC","N"})
aadd(_aCpoCusto,{"SI9","","X","I9_CCD","N"})
aadd(_aCpoCusto,{"SIA","","X","IA_CC","N"})
aadd(_aCpoCusto,{"SIB","","X","IB_CCC","N"})
aadd(_aCpoCusto,{"SIB","","X","IB_CCD","N"})
aadd(_aCpoCusto,{"SIB","","X","IB_ORIGEMC","N"})
aadd(_aCpoCusto,{"SIC","","X","IC_CCC","N"})
aadd(_aCpoCusto,{"SIC","","X","IC_CCD","N"})
aadd(_aCpoCusto,{"SL2","","X","L2_CCUSTO","N"})
aadd(_aCpoCusto,{"SLJ","","X","LJ_CCUSTO","N"})
aadd(_aCpoCusto,{"SLR","","X","LR_CCUSTO","N"})
aadd(_aCpoCusto,{"SN3","","X","N3_CCCDEP","N"})
aadd(_aCpoCusto,{"SN3","","X","N3_CCCDES","N"})
aadd(_aCpoCusto,{"SN3","","X","N3_CCCORR","N"})
aadd(_aCpoCusto,{"SN3","","X","N3_CCDESP","N"})
aadd(_aCpoCusto,{"SN3","","X","N3_CCUSTO","N"})
aadd(_aCpoCusto,{"SN3","","X","N3_CUSTBEM","N"})
aadd(_aCpoCusto,{"SN4","","X","N4_CCUSTO","N"})
aadd(_aCpoCusto,{"SN4","","X","N4_CCUSTOT","N"})
aadd(_aCpoCusto,{"SN6","","X","N6_CCUSTO","N"})
aadd(_aCpoCusto,{"SN7","","X","N7_CCUSTO","N"})
aadd(_aCpoCusto,{"SNA","","X","NA_CCUSTO","N"})
aadd(_aCpoCusto,{"SNC","","X","NC_CCUSTO","N"})
aadd(_aCpoCusto,{"SNG","","X","NG_CCCDEP","N"})
aadd(_aCpoCusto,{"SNG","","X","NG_CCCDES","N"})
aadd(_aCpoCusto,{"SNG","","X","NG_CCCORR","N"})
aadd(_aCpoCusto,{"SNG","","X","NG_CCDESP","N"})
aadd(_aCpoCusto,{"SNG","","X","NG_CCUSTO","N"})
aadd(_aCpoCusto,{"SNG","","X","NG_CUSTBEM","N"})
aadd(_aCpoCusto,{"SNM","","X","NM_CCCDEP","N"})
aadd(_aCpoCusto,{"SNM","","X","NM_CCCDES","N"})
aadd(_aCpoCusto,{"SNM","","X","NM_CCCORR","N"})
aadd(_aCpoCusto,{"SNM","","X","NM_CCDESP","N"})
aadd(_aCpoCusto,{"SNM","","X","NM_CCUSTO","N"})
aadd(_aCpoCusto,{"SNM","","X","NM_CUSTBEM","N"})
aadd(_aCpoCusto,{"SNN","","X","NN_CCCDEP","N"})
aadd(_aCpoCusto,{"SNN","","X","NN_CCDESP","N"})
aadd(_aCpoCusto,{"SNN","","X","NN_CUSTBEM","N"})
aadd(_aCpoCusto,{"SNR","","X","NR_CCCDEP","N"})
aadd(_aCpoCusto,{"SNS","","X","NS_CCUSTO","N"})
aadd(_aCpoCusto,{"SNV","","X","NV_CC","N"})
aadd(_aCpoCusto,{"SNW","","X","NW_NIV02","N"})
aadd(_aCpoCusto,{"SNX","","X","NX_NIV02","N"})
aadd(_aCpoCusto,{"SNY","","X","NY_NIV02","N"})
aadd(_aCpoCusto,{"SO3","","X","O3_CATIV","N"})
aadd(_aCpoCusto,{"SOC","","X","OC_CC","N"})
aadd(_aCpoCusto,{"SP0","","X","P0_CC","N"})
aadd(_aCpoCusto,{"SP2","","X","P2_CC","N"})
aadd(_aCpoCusto,{"SP2","","X","P2_CCPER01","N"})
aadd(_aCpoCusto,{"SP2","","X","P2_CCPER02","N"})
aadd(_aCpoCusto,{"SP2","","X","P2_CCPER03","N"})
aadd(_aCpoCusto,{"SP2","","X","P2_CCPER04","N"})
aadd(_aCpoCusto,{"SP5","","X","P5_CC","N"})
aadd(_aCpoCusto,{"SP8","","X","P8_CC","N"})
aadd(_aCpoCusto,{"SPB","","X","PB_CC","N"})
aadd(_aCpoCusto,{"SPC","","X","PC_CC","N"})
aadd(_aCpoCusto,{"SPG","","X","PG_CC","N"})
aadd(_aCpoCusto,{"SPH","","X","PH_CC","N"})
aadd(_aCpoCusto,{"SPI","","X","PI_CC","N"})
aadd(_aCpoCusto,{"SPK","","X","PK_CC","N"})
aadd(_aCpoCusto,{"SPL","","X","PL_CC","N"})
aadd(_aCpoCusto,{"SPN","","X","PN_CC","N"})
aadd(_aCpoCusto,{"SPY","","X","PY_CC","N"})
aadd(_aCpoCusto,{"SQ3","","X","Q3_CC","N"})
aadd(_aCpoCusto,{"SQ4","","X","Q4_CC","N"})
aadd(_aCpoCusto,{"SQB","","X","QB_CC","N"})
aadd(_aCpoCusto,{"SQG","","X","QG_CC","N"})
aadd(_aCpoCusto,{"SQS","","X","QS_CC","N"})
aadd(_aCpoCusto,{"SR0","","X","R0_CC","N"})
aadd(_aCpoCusto,{"SR1","","X","R1_CC","N"})
aadd(_aCpoCusto,{"SRA","","X","RA_CC","N"})
aadd(_aCpoCusto,{"SRC","","X","RC_CC","N"})
aadd(_aCpoCusto,{"SRD","","X","RD_CC","N"})
aadd(_aCpoCusto,{"SRE","","X","RE_CCD","N"})
aadd(_aCpoCusto,{"SRE","","X","RE_CCP","N"})
aadd(_aCpoCusto,{"SRI","","X","RI_CC","N"})
aadd(_aCpoCusto,{"SRK","","X","RK_CC","N"})
aadd(_aCpoCusto,{"SRL","","X","RL_CC","N"})
aadd(_aCpoCusto,{"SRO","","X","RO_CC","N"})
aadd(_aCpoCusto,{"SRR","","X","RR_CC","N"})
aadd(_aCpoCusto,{"SRT","","X","RT_CC","N"})
aadd(_aCpoCusto,{"SRZ","","X","RZ_CC","N"})
aadd(_aCpoCusto,{"SS4","","X","S4_CC","N"})
aadd(_aCpoCusto,{"SS4","","X","S4_CCCUSTO","N"})
aadd(_aCpoCusto,{"SS7","","X","S7_CCC","N"})
aadd(_aCpoCusto,{"SS7","","X","S7_CCD","N"})
aadd(_aCpoCusto,{"ST1","","X","T1_CCUSTO","N"})
aadd(_aCpoCusto,{"ST9","","X","T9_CCUSTO","N"})
aadd(_aCpoCusto,{"STC","","X","TC_CCUSTO","N"})
aadd(_aCpoCusto,{"STI","","X","TI_CCUSFIM","N"})
aadd(_aCpoCusto,{"STI","","X","TI_CCUSINI","N"})
aadd(_aCpoCusto,{"STJ","","X","TJ_CCUSTO","N"})
aadd(_aCpoCusto,{"STO","","X","TO_CCUSFIM","N"})
aadd(_aCpoCusto,{"STO","","X","TO_CCUSINI","N"})
aadd(_aCpoCusto,{"STP","","X","TP_CCUSTO","N"})
aadd(_aCpoCusto,{"STS","","X","TS_CCUSTO","N"})
aadd(_aCpoCusto,{"STW","","X","TW_CCUSTO","N"})
aadd(_aCpoCusto,{"SV7","","X","V7_CCUS","N"})
aadd(_aCpoCusto,{"SW1","","X","W1_CTCUSTO","N"})
aadd(_aCpoCusto,{"SW3","","X","W3_CTCUSTO","N"})
aadd(_aCpoCusto,{"TAA","","X","TAA_CCUSTO","N"})
aadd(_aCpoCusto,{"TAF","","X","TAF_CCUSTO","N"})
aadd(_aCpoCusto,{"TER","","X","TER_CCUSTO","N"})
aadd(_aCpoCusto,{"TFS","","X","TFS_CC","N"})
aadd(_aCpoCusto,{"TFT","","X","TFT_CC","N"})
aadd(_aCpoCusto,{"TI0","","X","TI0_CCUSTO","N"})
aadd(_aCpoCusto,{"TJ1","","X","TJ1_CC","N"})
aadd(_aCpoCusto,{"TJ2","","X","TJ2_CC","N"})
aadd(_aCpoCusto,{"TJ5","","X","TJ5_CC","N"})
aadd(_aCpoCusto,{"TK1","","X","TK1_CC","N"})
aadd(_aCpoCusto,{"TK2","","X","TK2_CC","N"})
aadd(_aCpoCusto,{"TK3","","X","TK3_CC","N"})
aadd(_aCpoCusto,{"TKF","","X","TKF_CODCC","N"})
aadd(_aCpoCusto,{"TKS","","X","TKS_CCCJN","N"})
aadd(_aCpoCusto,{"TLA","","X","TLA_CC","N"})
aadd(_aCpoCusto,{"TLC","","X","TLC_CCFIM","N"})
aadd(_aCpoCusto,{"TLC","","X","TLC_CCINI","N"})
aadd(_aCpoCusto,{"TLD","","X","TLD_CC","N"})
aadd(_aCpoCusto,{"TLJ","","X","TLJ_AREA","N"})
aadd(_aCpoCusto,{"TLJ","","X","TLJ_CC","N"})
aadd(_aCpoCusto,{"TLL","","X","TLL_CC","N"})
aadd(_aCpoCusto,{"TLM","","X","TLM_CC","N"})
aadd(_aCpoCusto,{"TLN","","X","TLN_CC","N"})
aadd(_aCpoCusto,{"TLO","","X","TLO_CC","N"})
aadd(_aCpoCusto,{"TLP","","X","TLP_CC","N"})
aadd(_aCpoCusto,{"TLR","","X","TLR_CC","N"})
aadd(_aCpoCusto,{"TM0","","X","TM0_CC","N"})
aadd(_aCpoCusto,{"TM5","","X","TM5_CC","N"})
aadd(_aCpoCusto,{"TMK","","X","TMK_CC","N"})
aadd(_aCpoCusto,{"TMV","","X","TMV_CC","N"})
aadd(_aCpoCusto,{"TMW","","X","TMW_CCATE","N"})
aadd(_aCpoCusto,{"TMW","","X","TMW_CCDE","N"})
aadd(_aCpoCusto,{"TMY","","X","TMY_NOVCC","N"})
aadd(_aCpoCusto,{"TN0","","X","TN0_CC","N"})
aadd(_aCpoCusto,{"TNC","","X","TNC_CC","N"})
aadd(_aCpoCusto,{"TNI","","X","TNI_CC","N"})
aadd(_aCpoCusto,{"TNN","","X","TNN_CC","N"})
aadd(_aCpoCusto,{"TNO","","X","TNO_AREA","N"})
aadd(_aCpoCusto,{"TNQ","","X","TNQ_AREA","N"})
aadd(_aCpoCusto,{"TO0","","X","TO0_CC","N"})
aadd(_aCpoCusto,{"TOB","","X","TOB_CC","N"})
aadd(_aCpoCusto,{"TOC","","X","TOC_CC","N"})
aadd(_aCpoCusto,{"TOH","","X","TOH_CC","N"})
aadd(_aCpoCusto,{"TP9","","X","TP9_CCUSTO","N"})
aadd(_aCpoCusto,{"TPN","","X","TPN_CCUSTO","N"})
aadd(_aCpoCusto,{"TPP","","X","TPP_CCUSTO","N"})
aadd(_aCpoCusto,{"TPW","","X","TPW_CCUSTO","N"})
aadd(_aCpoCusto,{"TQ2","","X","TQ2_CCORIG","N"})
aadd(_aCpoCusto,{"TQ2","","X","TQ2_CCUSTO","N"})
aadd(_aCpoCusto,{"TQA","","X","TQA_CCUSTO","N"})
aadd(_aCpoCusto,{"TQB","","X","TQB_CCUSTO","N"})
aadd(_aCpoCusto,{"TQN","","X","TQN_CCUSTO","N"})
aadd(_aCpoCusto,{"TR2","","X","TR2_CCUSTO","N"})
aadd(_aCpoCusto,{"TRF","","X","TRF_CCUSTO","N"})
aadd(_aCpoCusto,{"TRX","","X","TRX_CCUSTO","N"})
aadd(_aCpoCusto,{"TS2","","X","TS2_CCUSTO","N"})
aadd(_aCpoCusto,{"TSJ","","X","TSJ_CCUCON","N"})
aadd(_aCpoCusto,{"TSV","","X","TSV_CCUSTO","N"})
aadd(_aCpoCusto,{"TSX","","X","TSX_CCUSTO","N"})
aadd(_aCpoCusto,{"TT1","","X","TT1_CCATE","N"})
aadd(_aCpoCusto,{"TT1","","X","TT1_CCDE","N"})
aadd(_aCpoCusto,{"TTH","","X","TTH_CCUSTO","N"})
aadd(_aCpoCusto,{"TUH","","X","TUH_CCUSTO","N"})
aadd(_aCpoCusto,{"TV2","","X","TV2_CODFRE","N"})
aadd(_aCpoCusto,{"TVJ","","X","TVJ_CCUSTO","N"})
aadd(_aCpoCusto,{"TVL","","X","TVL_CCUSTO","N"})
aadd(_aCpoCusto,{"TY4","","X","TY4_CC","N"})
aadd(_aCpoCusto,{"TYA","","X","TYA_CC","N"})
aadd(_aCpoCusto,{"VAI","","X","VAI_CC","N"})
aadd(_aCpoCusto,{"VBH","","X","VBH_CC","N"})
aadd(_aCpoCusto,{"VDE","","X","VDE_CCUSTO","N"})
aadd(_aCpoCusto,{"VE4","","X","VE4_CENCUS","N"})
aadd(_aCpoCusto,{"VEC","","X","VEC_CENCUS","N"})
aadd(_aCpoCusto,{"VEM","","X","VEM_CENCUS","N"})
aadd(_aCpoCusto,{"VEN","","X","VEN_CENCUS","N"})
aadd(_aCpoCusto,{"VO3","","X","VO3_CENCUS","N"})
aadd(_aCpoCusto,{"VO4","","X","VO4_CENCUS","N"})
aadd(_aCpoCusto,{"VS1","","X","VS1_CENCUS","N"})
aadd(_aCpoCusto,{"VS3","","X","VS3_CENCUS","N"})
aadd(_aCpoCusto,{"VSC","","X","VSC_CENCUS","N"})
aadd(_aCpoCusto,{"VV0","","X","VV0_CCUSTO","N"})
aadd(_aCpoCusto,{"VV1","","X","VV1_CC","N"})
aadd(_aCpoCusto,{"VVA","","X","VVA_CENCUS","N"})
aadd(_aCpoCusto,{"VVG","","X","VVG_CENCUS","N"})
aadd(_aCpoCusto,{"VZ1","","X","VZ1_CENCUS","N"})


//novo 01020167 e o velho 30020029
 

aCcusto := {}
aadd(aCcusto,{"4.1.000.003","8.8.888.888"})
aadd(aCcusto,{"4.1.000.012","8.8.888.888"})
aadd(aCcusto,{"4.1.000.013","8.8.888.888"})
aadd(aCcusto,{"4.1.000.016","8.8.888.888"})
aadd(aCcusto,{"4.1.000.029","8.8.888.888"})
aadd(aCcusto,{"4.1.000.046","8.8.888.888"})
aadd(aCcusto,{"4.1.000.058","8.8.888.888"})
aadd(aCcusto,{"4.1.000.072","8.8.888.888"})
aadd(aCcusto,{"4.1.000.073","8.8.888.888"})
aadd(aCcusto,{"4.1.000.074","8.8.888.888"})
aadd(aCcusto,{"4.1.000.075","8.8.888.888"})
aadd(aCcusto,{"4.1.000.082","8.8.888.888"})
aadd(aCcusto,{"4.1.000.087","8.8.888.888"})
aadd(aCcusto,{"4.1.000.108","8.8.888.888"})
aadd(aCcusto,{"4.1.000.117","8.8.888.888"})
aadd(aCcusto,{"4.1.000.119","8.8.888.888"})
aadd(aCcusto,{"4.1.000.120","8.8.888.888"})
aadd(aCcusto,{"4.1.000.121","8.8.888.888"})
aadd(aCcusto,{"4.1.000.122","8.8.888.888"})
aadd(aCcusto,{"4.1.000.125","8.8.888.888"})
aadd(aCcusto,{"4.1.000.126","8.8.888.888"})
aadd(aCcusto,{"4.1.000.135","8.8.888.888"})
aadd(aCcusto,{"4.1.000.136","8.8.888.888"})
aadd(aCcusto,{"4.1.000.137","8.8.888.888"})
aadd(aCcusto,{"4.1.000.139","8.8.888.888"})
aadd(aCcusto,{"4.1.000.140","8.8.888.888"})
aadd(aCcusto,{"4.1.000.146","8.8.888.888"})
aadd(aCcusto,{"4.1.000.149","8.8.888.888"})
aadd(aCcusto,{"4.1.000.151","8.8.888.888"})
aadd(aCcusto,{"4.1.000.157","8.8.888.888"})
aadd(aCcusto,{"4.1.000.158","8.8.888.888"})
aadd(aCcusto,{"4.1.000.160","8.8.888.888"})
aadd(aCcusto,{"4.1.000.161","8.8.888.888"})
aadd(aCcusto,{"4.1.000.162","8.8.888.888"})
aadd(aCcusto,{"4.1.000.166","8.8.888.888"})
aadd(aCcusto,{"4.1.000.167","8.8.888.888"})
aadd(aCcusto,{"4.1.000.168","8.8.888.888"})
aadd(aCcusto,{"4.1.000.169","8.8.888.888"})
aadd(aCcusto,{"4.1.000.180","8.8.888.888"})
aadd(aCcusto,{"4.1.000.184","8.8.888.888"})



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
