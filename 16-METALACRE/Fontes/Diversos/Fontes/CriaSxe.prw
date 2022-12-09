#include "protheus.ch"
#Include "TOPCONN.CH"

user function CRIASXE()
Local cNum := NIL
Local aArea := getarea()
Local aArea2 := GetArea()
Local cAlias    := paramixb[1]
Local cCpoSx8   := paramixb[2]
Local cAliasSx8 := paramixb[3]
Local nOrdSX8   := paramixb[4]
Local cUsa := "SE1"
Local lFoi := .F.  

If cAlias $ "SA1" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(A1_COD) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SA1") +  " A1   " +CRLF
	cQuery+= " WHERE A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND A1_COD NOT IN('APLICA','999999') " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SA2" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(A2_COD) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SA2") +  " A2   " +CRLF
	cQuery+= " WHERE A2_FILIAL='"+XFilial("SA2")+"' AND A2.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND LEFT(A2_COD,1) = '0' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SA4" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(A4_COD) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SA4") +  " A4   " +CRLF
	cQuery+= " WHERE A4_FILIAL='"+XFilial("SA4")+"' AND A4.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND LEFT(A4_COD,1) = '0' " +CRLF
	lFoi := .T.
Endif	
	
If lFoi
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSSS", .F., .T. )
			  
	If !Empty(TMPSSS->CODIGO)
		cNum := Soma1(TMPSSS->CODIGO,6)
	Endif
	
	TMPSSS->(dbCloseArea())
Endif
restarea(aArea2)	
restarea(aArea)

return cNum