#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: TK271SQL | Autor: Felipe Pieroni          | Data: 23/05/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | PE de entrada para realizar o filtro dos operadores conf   |||
|||           | usuarios logados                                           |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function TK271SQL()

Local _cAlias  := ParamIxb[1]
Local _aArea   := GetArea()
Local _cFiltro := ""
Local _cOperado := ""
Local _cSuperv  := ""
Local cCodUser := RetCodUsr()

If _cAlias == "SUA"
	
	cQuery := " SELECT "
	cQuery += "    U7_COD, "
	cQuery += "    U7_TIPO, "
	cQuery += "    U7_CODVEN "
	cQuery += " FROM  "+ RetSqlName("SU7") +" SU7 "
	cQuery += " WHERE "
	cQuery += "    SU7.D_E_L_E_T_ <> '*' "
	cQuery += "    AND U7_CODUSU = '"+alltrim(cCodUser)+"' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .T., .T.)
	dbSelectArea("TRB")
	
	If !TRB->(Eof())
		_cOperado := TRB->U7_COD
		_cSuperv  := TRB->U7_TIPO
	EndIf
	
	TRB->(DbCloseArea())
	
	If _cSuperv <> '2'
		_cFiltro := "UA_OPERADO = "+_cOperado
	EndIf
//	U_CFMFILSA1()
EndIf

RestArea(_aArea)

Return _cFiltro