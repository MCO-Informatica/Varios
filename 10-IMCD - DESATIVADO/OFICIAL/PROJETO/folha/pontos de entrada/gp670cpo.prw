#include "rwmake.ch"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? GP670CPO ? Autor ?RONALDO KHOURI? Data ? 22/11/2007  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Inclusao do Historico/Funcionario                        ???
???          ? no titulos a pagar                                         ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? MAKENI                                             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function GP670CPO()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "GP670CPO" , __cUserID )

	HIST := ""
	reclock("SE2",.f.)
	IF RC1->RC1_MAT > "000000"
		HIST := POSICIONE("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT,"RA_NOME")
	ELSE
		HIST := RC1->RC1_DESCRI
	ENDIF

	SE2->E2_HIST := HIST       
	SE2->E2_GRUPO := "000001"


	msUnlock()

Return()
