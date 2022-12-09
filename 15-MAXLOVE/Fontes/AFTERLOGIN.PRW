#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

#Define STR_PULA		Chr(13)+Chr(10)

User Function AfterLogin()
	Local cSql:= ""

    cSql := "UPDATE "+RetSqlName("SL1")+" SET L1_DESCNF = 0, L1_SITUA = 'RX' WHERE L1_SITUA = 'ER' AND D_E_L_E_T_ =''"
    
    //TcSqlExec(cSql) //----> ZERA O CAMPO DE DESCONTO DA VENDA VINDA DO E-COMMERCE (VTEX)

	/*If StoD(GetMv("MV_XDTRISCO")) < Date() //----> VERIFICA SE JÁ RODOU O RISCO NO DIA

		U_RFINA99() //----> ATUALIZA O RISCO DE CREDITO UMA VEZ AO DIA

		PutMv("MV_XDTRISCO",DtoS(Date()))

	EndIf*/

Return




Return
