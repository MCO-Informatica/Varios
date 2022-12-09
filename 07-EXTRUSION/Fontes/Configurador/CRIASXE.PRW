#include "protheus.ch"
#Include "TOPCONN.CH"

User Function CRIASXE()

Local cNum      := NIL
Local aArea     := getarea()
Local aArea2    := GetArea()
Local cAlias    := paramixb[1]
Local cCpoSx8   := paramixb[2]
Local cAliasSx8 := paramixb[3]
Local nOrdSX8   := paramixb[4]
Local cUsa      := "SE1"
Local cEmpFat:= cFilAnt
Local lFoi := .F.  

If cEmpFat$"0101" .And. cAlias $ "SC5" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C5_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC5") +  " C5   " +CRLF
	cQuery+= " WHERE C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C5_NUM BETWEEN 'A00001' AND 'A99999' " +CRLF
	lFoi := .T.
ElseIf cEmpFat$"0102" .And. cAlias $ "SC5" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C5_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC5") +  " C5   " +CRLF
	cQuery+= " WHERE C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C5_NUM BETWEEN 'B00001' AND 'B99999' " +CRLF
	lFoi := .T.
ElseIf cEmpFat$"0103" .And. cAlias $ "SC5" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C5_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC5") +  " C5   " +CRLF
	cQuery+= " WHERE C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C5_NUM BETWEEN 'C00001' AND 'C99999' " +CRLF
	lFoi := .T.
ElseIf cEmpFat$"0104" .And. cAlias $ "SC5" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C5_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC5") +  " C5   " +CRLF
	cQuery+= " WHERE C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C5_NUM BETWEEN 'D00001' AND 'D99999' " +CRLF
	lFoi := .T.
ElseIf cEmpFat$"0101" .And. cAlias $ "SC7" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C7_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC7") +  " C7   " +CRLF
	cQuery+= " WHERE C7_FILIAL='"+XFilial("SC7")+"' AND C7.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C7_NUM BETWEEN 'A00001' AND 'A99999' " +CRLF
	lFoi := .T.
ElseIf cEmpFat$"0102" .And. cAlias $ "SC7" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C7_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC7") +  " C7   " +CRLF
	cQuery+= " WHERE C7_FILIAL='"+XFilial("SC7")+"' AND C7.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C7_NUM BETWEEN 'B00001' AND 'B99999' " +CRLF
	lFoi := .T.
ElseIf cEmpFat$"0103" .And. cAlias $ "SC7" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C7_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC7") +  " C7   " +CRLF
	cQuery+= " WHERE C7_FILIAL='"+XFilial("SC7")+"' AND C7.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C7_NUM BETWEEN 'C00001' AND 'C99999' " +CRLF
	lFoi := .T.
ElseIf cEmpFat$"0104" .And. cAlias $ "SC7" .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )	
	cQuery:= " SELECT MAX(C7_NUM) CODIGO " +CRLF
	cQuery+= " FROM " + RetSqlName("SC7") +  " C7   " +CRLF
	cQuery+= " WHERE C7_FILIAL='"+XFilial("SC7")+"' AND C7.D_E_L_E_T_<>'*'  " +CRLF   
	cQuery+= " AND C7_NUM BETWEEN 'D00001' AND 'D99999' " +CRLF
	lFoi := .T.
EndIf	

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
