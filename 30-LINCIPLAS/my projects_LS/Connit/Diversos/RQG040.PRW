#include "rwmake.ch"
#include "topconn.ch"   
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "protheus.ch"

user Function RPTDETAIL(pccod,pcfil,pnmes)

    nreg  := 0
    cquery := "SELECT COALESCE(QTD,0) AS 'QTD' FROM VW_VENDAMES WHERE MES=MONTH(GETDATE())-" + STR(pnmes) +" AND ANO=YEAR(GETDATE()) AND D2_COD='" + pccod + ;
	          "' AND D2_FILIAL='" + pcfil + "'"

	TcQuery cquery NEW ALIAS "QRYCONT"

	QRYCONT->(dbgotop())
	nReg := iif(!eof(), QRYCONT->qtd, 0)
	QRYCONT->(dbclosearea())

return nreg