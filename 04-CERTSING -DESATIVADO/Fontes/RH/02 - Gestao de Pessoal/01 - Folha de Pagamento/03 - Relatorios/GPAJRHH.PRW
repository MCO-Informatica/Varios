#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/

1 - Confirmar Verbas -
2 - Round no Oracle
3 - Backup do RHH
4 - Confirmar se ja nao integrou com a folha

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPAJRHH  บ Autor ณ Primainfo          บ Data ณ  26/09/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza Bases INSS e FGTS Dissidio 09/2019                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Clientes Prima Informatica                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GPAJRHH()

Local cQuery 	:= ""

cQuery 	+= " SELECT W.* FROM("
cQuery 	+= " SELECT T.*"
cQuery 	+= " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RHH_VALOR * -1 ELSE RHH_VALOR END)"
cQuery 	+= " FROM RHH010 B, SRV010 C"
cQuery 	+= " WHERE B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RHH_VB = RV_COD"
cQuery 	+= " AND RHH_FILIAL = FIL"
cQuery 	+= " AND RHH_MAT = MAT"
cQuery 	+= " AND RHH_MESANO = MESANO"
cQuery 	+= " AND RHH_DATA = CDATA"
cQuery 	+= " AND RV_TIPOCOD IN ('1','2')"
cQuery 	+= " AND RV_INSS = 'S'"
cQuery 	+= " ),0) BINSSC"
cQuery 	+= " ,NVL((SELECT SUM(RHH_VALOR)"
cQuery 	+= " FROM RHH010 B"
cQuery 	+= " WHERE B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RHH_FILIAL = FIL"
cQuery 	+= " AND RHH_MAT = MAT"
cQuery 	+= " AND RHH_MESANO = MESANO"
cQuery 	+= " AND RHH_DATA = CDATA"
cQuery 	+= " AND RHH_VERBA = '338'"
cQuery 	+= " ),0) BINSSE"
cQuery 	+= " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RHH_VALOR * -1 ELSE RHH_VALOR END)"
cQuery 	+= " FROM RHH010 B, SRV010 C"
cQuery 	+= " WHERE B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RHH_VB = RV_COD"
cQuery 	+= " AND RHH_FILIAL = FIL"
cQuery 	+= " AND RHH_MAT = MAT"
cQuery 	+= " AND RHH_MESANO = MESANO"
cQuery 	+= " AND RHH_DATA = CDATA"
cQuery 	+= " AND RV_TIPOCOD IN ('1','2')"
cQuery 	+= " AND RV_FGTS = 'S'"
cQuery 	+= " ),0) BFGTSC"
cQuery 	+= " ,NVL((SELECT SUM(RHH_VALOR)"
cQuery 	+= " FROM RHH010 B"
cQuery 	+= " WHERE B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RHH_FILIAL = FIL"
cQuery 	+= " AND RHH_MAT = MAT"
cQuery 	+= " AND RHH_MESANO = MESANO"
cQuery 	+= " AND RHH_DATA = CDATA"
cQuery 	+= " AND RHH_VERBA = '337'"
cQuery 	+= " ),0) BFGTSE"
cQuery 	+= " ,NVL((SELECT SUM(RHH_VALOR)"
cQuery 	+= " FROM RHH010 B"
cQuery 	+= " WHERE B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RHH_FILIAL = FIL"
cQuery 	+= " AND RHH_MAT = MAT"
cQuery 	+= " AND RHH_MESANO = MESANO"
cQuery 	+= " AND RHH_DATA = CDATA"
cQuery 	+= " AND RHH_VERBA = '850'"
cQuery 	+= " ),0) INSSEMP"
cQuery 	+= " ,NVL((SELECT SUM(RHH_VALOR)"
cQuery 	+= " FROM RHH010 B"
cQuery 	+= " WHERE B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RHH_FILIAL = FIL"
cQuery 	+= " AND RHH_MAT = MAT"
cQuery 	+= " AND RHH_MESANO = MESANO"
cQuery 	+= " AND RHH_DATA = CDATA"
cQuery 	+= " AND RHH_VERBA = '851'"
cQuery 	+= " ),0) INSSTERC"
cQuery 	+= " ,NVL((SELECT SUM(RHH_VALOR)"
cQuery 	+= " FROM RHH010 B"
cQuery 	+= " WHERE B.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RHH_FILIAL = FIL"
cQuery 	+= " AND RHH_MAT = MAT"
cQuery 	+= " AND RHH_MESANO = MESANO"
cQuery 	+= " AND RHH_DATA = CDATA"
cQuery 	+= " AND RHH_VERBA = '852'"
cQuery 	+= " ),0) INSSACID"
cQuery 	+= " FROM("
cQuery 	+= " SELECT DISTINCT RHH_FILIAL FIL,RHH_MAT MAT,RA_NOME,RA_CATEFD,RHH_MESANO MESANO,RHH_DATA CDATA,RHH_CC CC"
cQuery 	+= " FROM RHH010 A, SRA010 D"
cQuery 	+= " WHERE A.D_E_L_E_T_ = ' '"
cQuery 	+= " AND D.D_E_L_E_T_ = ' '"
cQuery 	+= " AND RA_FILIAL = RHH_FILIAL"
cQuery 	+= " AND RA_MAT = RHH_MAT"
cQuery 	+= " AND RHH_MESANO = '201909'"
cQuery 	+= " )T"
cQuery 	+= " )W"
cQuery 	+= " WHERE ROUND(BINSSE,2) <> ROUND(BINSSC,2) OR ROUND(BFGTSE,2) <> ROUND(BFGTSC,2)"
TCQuery cQuery New Alias "WSRA"

BEGIN TRANSACTION

While !WSRA->(Eof())
	If WSRA->BINSSC <> WSRA->RA_BINSSE
		//APAGA AS VERBAS DE BASE DE INSS
		TCSQLEXEC("UPDATE RHH010 SET D_E_L_E_T_ = '*',R_E_C_D_E_L_ = R_E_C_N_O_ WHERE RHH_FILIAL = '"+WSRA->FIL+"' AND RHH_MAT = '"+WSRA->MAT+"' AND RHH_MESANO = '"+WSRA->MESANO+"' AND RHH_FILIAL = '"+WSRA->FIL+"' AND RHH_DATA = '"+WSRA->CDATA+"' AND RHH_VERBA IN ('338','850','851','852')")
		TCSQLEXEC("COMMIT")

		//Cria novas verbas de INSS
		fcriaRHH("722","338",WSRA->BINSSC) //BASE INSS ACIMA
		fcriaRHH("743","850",Round(WSRA->BINSSC * 0.2,2)) //INSS EMPRESA
		fcriaRHH("744","851",Round(WSRA->BINSSC*0.058,2)) //INSS TERCEIROS
		fcriaRHH("745","852",Round(WSRA->BINSSC*0.005,2)) //INSS ACIDENTE
	Endif

	If WSRA->BFGTSC <> WSRA->RA_BFGTSE
		//APAGA AS VERBAS DE BASE DE INSS
		TCSQLEXEC("UPDATE RHH010 SET D_E_L_E_T_ = '*',R_E_C_D_E_L_ = R_E_C_N_O_ WHERE RHH_FILIAL = '"+WSRA->FIL+"' AND RHH_MAT = '"+WSRA->MAT+"' AND RHH_MESANO = '"+WSRA->MESANO+"' AND RHH_FILIAL = '"+WSRA->FIL+"' AND RHH_DATA = '"+WSRA->CDATA+"' AND RHH_VERBA IN ('337','339')")
		TCSQLEXEC("COMMIT")

		//Cria novas verbas de INSS
		fcriaRHH("731","337",WSRA->BINSSC) //BASE FGTS
		fcriaRHH("732","339",Round(WSRA->BINSSC * IIF(WSRA->RA_CATEFD = "103",0.02,0.08),2)) //FGTS A RECOLHER
	Endif

	WSRA->(dbSkip())
Enddo

WSRA->(dbCloseArea())

End Transaction

WSRA->(dbCloseArea())

Alert("Processo Concluido")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfcriaRHH  บAutor  ณMicrosiga           บ Data ณ  09/26/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fcriaRHH(cPd1,cPd2,n_Val)

dbSelectArea("RHH")
RecLock("RHH",.t.)

RHH->RHH_FILIAL	:= WSRA->FIL
RHH->RHH_MAT	:= WSRA->MAT
RHH->RHH_CC		:= WSRA->CC
RHH->RHH_VB		:= cPd1
RHH->RHH_DATA	:= WSRA->CDATA
RHH->RHH_VERBA	:= cPd2
RHH->RHH_CALC	:= n_Val
RHH->RHH_VALOR	:= n_Val
RHH->RHH_TPOAUM	:= "003"
RHH->RHH_COMPL_ := "S"
RHH->RHH_SEMANA := "  "
RHH->RHH_INTEGR	:= "S"
RHH->RHH_MESANO	:= WSRA->MESANO
RHH->RHH_TIPO1	:= "V"
RHH->RHH_TIPO2	:= "C"

RHH->(MsUnlock())

Return