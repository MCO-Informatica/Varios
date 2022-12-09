#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REN00001 บAutor  ณDanilo Jos้ Grodzickiบ Dataณ  16/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as tabelas ZZC000, ZZT000, ZZM000 e ZZR.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova Energia S.A.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function REN00001()
 // ESSE ROTINA Sำ PODE SER EXECUTADA PELO FORMULAS, POIS PRECISA PASSAR PELO TOP PARA TER ACESSO AO BD.

Local nRet
Local cQuery

if MsgYesNo("Cria a tabela ZZC000","ATENวรO")  // Dados da cota็ใo.
	
	cQuery := "DROP TABLE ZZC000"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("DROP ZZC000 - Erro.","ATENวรO")
		Return Nil
	endif
	
	cQuery := "CREATE TABLE ZZC000 ( "
	cQuery += "ZZC_CODIGO char(6) NULL, "
	cQuery += "ZZC_VALOR number NULL, "
	cQuery += "ZZC_DATA char(8) NULL, "
	cQuery += "ZZC_FORNEC char(6) NULL, "
	cQuery += "ZZC_DESFOR char(40) NULL, "
	cQuery += "ZZC_DTINCL char(8) NULL, "
	cQuery += "ZZC_HRINCL char(8) NULL, "
	cQuery += "ZZC_STATUS char(5) NULL, "
	cQuery += "ZZC_DTLEIT char(8) NULL, "
	cQuery += "ZZC_HRLEIT char(8) NULL, "
	cQuery += "ZZC_LOGERR char(100) NULL "
	cQuery += ")"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("CREATE ZZC000 - Erro.","ATENวรO")
		Return Nil
	endif
	
	ApMsgInfo("Tabela ZZC000 criada com sucesso.","SUCESSO")
	
endif

if MsgYesNo("Cria a tabela ZZT000","ATENวรO")  // Tํtulos.
	
	cQuery := "DROP TABLE ZZT000"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("DROP ZZT000 - Erro.","ATENวรO")
		Return Nil
	endif
	
	cQuery := "CREATE TABLE ZZT000 ( "
	cQuery += "ZZT_FILIAL char(7) NULL, "
	cQuery += "ZZT_PREFIX char(3) NULL, "
	cQuery += "ZZT_NUM char(9) NULL, "
	cQuery += "ZZT_TIPO char(3) NULL, "
	cQuery += "ZZT_PARCEL char(3) NULL, "
	cQuery += "ZZT_FORNEC char(6) NULL, "
	cQuery += "ZZT_LOJA char(2) NULL, "
	cQuery += "ZZT_EMISSA char(8) NULL, "
	cQuery += "ZZT_VENCTO char(8) NULL, "
	cQuery += "ZZT_VENREA char(8) NULL, "
	cQuery += "ZZT_VALOR number NULL, "
	cQuery += "ZZT_NATURE char(10) NULL, "
	cQuery += "ZZT_CCD char(9) NULL, "
	cQuery += "ZZT_CLASSE char(11) NULL, "
	cQuery += "ZZT_CAMADA char(9) NULL, "
	cQuery += "ZZT_PROJET char(9) NULL, "
	cQuery += "ZZT_CONTAD char(20) NULL, "
	cQuery += "ZZT_USUARI char(25) NULL, "
	cQuery += "ZZT_DTINCL char(8) NULL, "
	cQuery += "ZZT_HRINCL char(8) NULL, "
	cQuery += "ZZT_STATUS char(5) NULL, "
	cQuery += "ZZT_DTLEIT char(8) NULL, "
	cQuery += "ZZT_HRLEIT char(8) NULL, "
	cQuery += "ZZT_LOGERR char(100) NULL, "
	cQuery += "ZZT_STACOM char(5) NULL "
	cQuery += ")"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("CREATE ZZT000 - Erro.","ATENวรO")
		Return Nil
	endif
	
	ApMsgInfo("Tabela ZZT000 criada com sucesso.","SUCESSO")
	
endif

if MsgYesNo("Cria a tabela ZZM000","ATENวรO")  // Libera็ใo da medi็ใo.
	
	cQuery := "DROP TABLE ZZM000"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("DROP ZZM000 - Erro.","ATENวรO")
		Return Nil
	endif
	
	cQuery := "CREATE TABLE ZZM000 ( "
	cQuery += "ZZM_FILIAL char(7) NULL, "
	cQuery += "ZZM_COD char(6) NULL, "
	cQuery += "ZZM_NUMCON char(15) NULL, "
	cQuery += "ZZM_REVISAO char(03) NULL, "
	cQuery += "ZZM_DATA char(8) NULL, "
	cQuery += "ZZM_STATUS char(3) NULL, "
	cQuery += "ZZM_DTINCL char(8) NULL, "
	cQuery += "ZZM_HRINCL char(8) NULL "
	cQuery += ")"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("CREATE ZZM000 - Erro.","ATENวรO")
		Return Nil
	endif
	
	ApMsgInfo("Tabela ZZM000 criada com sucesso.","SUCESSO")
	
endif

IF MsgYesNo("Cria a tabela ZZR000","ATENวรO")  // Rateio Titulos Entidades.
	
	/*
	cQuery := "DROP TABLE ZZR000"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("DROP ZZR000 - Erro.","ATENวรO")
		Return Nil
	endif
	  */
	cQuery := "CREATE TABLE CXJA88_HOM.ZZR000 ( "
	cQuery += "ZZR_FILIAL char(7) NULL, "
	cQuery += "ZZR_PREFIX char(3) NULL, "
	cQuery += "ZZR_NUM char(9) NULL, "
	cQuery += "ZZR_TIPO char(3) NULL, "
	cQuery += "ZZR_PARCEL char(3) NULL, "
	cQuery += "ZZR_FORNEC char(6) NULL, "
	cQuery += "ZZR_LOJA char(2) NULL, "
	cQuery += "ZZR_VALOR number NULL, "
	cQuery += "ZZR_NATURE char(10) NULL, "
	cQuery += "ZZR_CCD char(9) NULL, "
	cQuery += "ZZR_CLASSE char(11) NULL, "
	cQuery += "ZZR_CAMADA char(9) NULL, "
	cQuery += "ZZR_PROJET char(9) NULL, "
	cQuery += "ZZR_CONTAD char(20) NULL, "
	cQuery += "ZZR_USUARI char(25) NULL, "
	cQuery += "ZZR_DTINCL char(8) NULL, "
	cQuery += "ZZR_HRINCL char(8) NULL, "
	cQuery += "ZZR_STATUS char(5) NULL, "
	cQuery += "ZZR_DTLEIT char(8) NULL, "
	cQuery += "ZZR_HRLEIT char(8) NULL, "
	cQuery += "ZZR_LOGERR char(100) NULL, "
	cQuery += "ZZR_STACOM char(5) NULL "
	cQuery += ")"
	nRet   := TCSqlExec(cQuery)
	if nRet < 0
		MsgAlert("CREATE ZZR000 - Erro.","ATENวรO")
		Return Nil
	endif
	
	ApMsgInfo("Tabela ZZR000 criada com sucesso.","SUCESSO")
	
ENDIF

Return Nil
