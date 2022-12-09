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
	cQuery+= " AND A1_COD BETWEEN 'C00001' AND 'C99999' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SA2" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(A2_COD) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SA2") +  " A2   " +CRLF
	cQuery+= " WHERE A2_FILIAL='"+XFilial("SA2")+"' AND A2.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND A2_COD BETWEEN 'F00001' AND 'F99999' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SA4" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(A4_COD) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SA4") +  " A4   " +CRLF
	cQuery+= " WHERE A4_FILIAL='"+XFilial("SA4")+"' AND A4.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND A4_COD < 'A' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SC5" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C5_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC5") +  " C5   " +CRLF
	cQuery+= " WHERE C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C5_NUM < 'A' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SE1" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(E1_IDCNAB) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SE1") +  " E1   " +CRLF
	cQuery+= " WHERE E1_FILIAL='"+XFilial("SE1")+"' AND E1.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND E1_IDCNAB < '9' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SC2" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C2_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC2") +  " C2   " +CRLF
	cQuery+= " WHERE C2_FILIAL='"+XFilial("SC2")+"' AND C2.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C2_NUM > '1799' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SW0" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(W0__NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SW0") +  " W0   " +CRLF
	cQuery+= " WHERE W0_FILIAL='"+XFilial("SW0")+"' AND W0.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND W0__NUM > '000396' " +CRLF
	lFoi := .T.
ElseIf cAlias $ "SW6" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(W6_HAWB) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SW6") +  " W6   " +CRLF
	cQuery+= " WHERE W6_FILIAL='"+XFilial("SW6")+"' AND W6.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND W6_HAWB BETWEEN '00000000000000001' AND '99999999999999999' " +CRLF
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
