#include "protheus.ch"
#Include "TOPCONN.CH"

User Function RFATG01()

Local  _cCodigo  := NIL
Local  _LFoi     := .F.
Local  _cQuery   := ""
			

If M->A1_PESSOA$"F"		
	_cQuery:= " SELECT MAX(A1_COD) CODIGO " +CRLF
	_cQuery+= " FROM " + RetSqlName("SA1") +  " A1  " +CRLF
	_cQuery+= " WHERE A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF   
	_cQuery+= " AND A1_COD BETWEEN '100001' AND '199999' " +CRLF
	lFoi := .T.
M->A1_PESSOA$"J"	
	_cQuery:= " SELECT MAX(A1_COD) CODIGO " +CRLF
	_cQuery+= " FROM " + RetSqlName("SA1") +  " A1  " +CRLF
	_cQuery+= " WHERE A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF   
	_cQuery+= " AND A1_COD BETWEEN '200001' AND '199999' " +CRLF
	lFoi := .T.
M->A1_PESSOA$"E"	
	_cQuery:= " SELECT MAX(A1_COD) CODIGO " +CRLF
	_cQuery+= " FROM " + RetSqlName("SA1") +  " A1  " +CRLF
	_cQuery+= " WHERE A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF   
	_cQuery+= " AND A1_COD BETWEEN '300001' AND '199999' " +CRLF
	lFoi := .T.

EndIf	

If lFoi
	DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "TMPSSS", .F., .T. )
			  
	If !Empty(TMPSSS->CODIGO)
		_cCodigo := Soma1(TMPSSS->CODIGO,6)
	Endif
	
	TMPSSS->(dbCloseArea())
Endif

return (_cCodigo)
