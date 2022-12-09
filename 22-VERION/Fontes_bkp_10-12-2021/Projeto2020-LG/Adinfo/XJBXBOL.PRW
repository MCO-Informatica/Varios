#INCLUDE 'PROTHEUS.CH'
#include "topconn.ch"


USER FUNCTION XJBXBOL(cXEmp)
Local Baixa     := ''
Local cQuery    := ''
Local dDtPend   := ''

Default cXEmp := '01'

    RPCSetEnv(cXEmp, "01", /*cUserId*/, /*cPasswd*/, "FIN")
    Baixa   := GetNextAlias()
    dDtPend := DtoS ( dDataBase - 1 )
    
    cQuery := " SELECT E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_VALOR, E1_SALDO   "
    cQuery += " FROM " + RETSQLNAME("SE1") + " SE1 (NOLOCK) "
    cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 (NOLOCK) ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA "
    cQuery += " WHERE SE1.D_E_L_E_T_ = '' "
    cQuery += " AND SE1.E1_XDTPROC <> '' "
    cQuery += " AND SE1.E1_VENCREA <= '" + dDtPend + "' "
    cQuery += " AND SE1.E1_BAIXA = '' "
    
    If Select(BAIXA) > 0
		(BAIXA)->(DbCloseArea())
	Endif  

    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery), BAIXA ,.F.,.T.)
	
	dbSelectArea(BAIXA)   
	
	(BAIXA) -> (dbGoTop())

    DO WHILE ! (BAIXA)->(EOF())
        u_XRBOL001((BAIXA)->E1_CLIENTE, (BAIXA)->E1_LOJA, (BAIXA)->E1_PREFIXO, (BAIXA)->E1_NUM, '', '', "JOBP")
        (BAIXA)->(DBSKIP())
    ENDDO

    If Select(BAIXA) > 0
		(BAIXA)->(DbCloseArea())
	Endif  
    RPCClearEnv()
RETURN
