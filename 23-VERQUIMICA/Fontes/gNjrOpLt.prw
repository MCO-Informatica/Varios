#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GNJROPLT  ºAutor  ³Nelson Junior       º Data ³  06/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho do campo D3_OP para inserção do lote, conforme      º±±
±±º          ³sugestão da matéria prima empenhada (SD4).                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function gNjrOpLt(_cTipo, _cNumOp)

Local aAreaSd3 := SD3->(GetArea())
Local _VarRet := ""

cQry := "SELECT D4_PRODUTO, "
cQry += "D4_LOTECTL, "
cQry += "D4_DTVALID, "
cQry += "D4_DATA "
cQry += "FROM "
cQry += "( SELECT * "
cQry += "FROM "
cQry += RetSqlName("SD4")+" "
cQry += "WHERE "
cQry += "D_E_L_E_T_ <> '*' "
cQry += "AND D4_COD LIKE '02%' "
cQry += "AND D4_OP = '"+_cNumOp+"' ) TRB "
//cQry += "ORDER BY "
//cQry += "D4_QTDEORI DESC ) "
//cQry += "WHERE "
//cQry += "ROWNUM = 1 "

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "QRY"

QRY->(dbGoTop())

If !QRY->(EoF())
	If _cTipo == 1
		_VarRet := QRY->D4_LOTECTL
	ElseIf _cTipo == 2
		_VarRet := StoD(QRY->D4_DTVALID)
	ElseIf _cTipo == 3
		_VarRet := StoD(QRY->D4_DATA)
	EndIf
EndIf

If MV_PAR01 <> 1
	If Subs(QRY->D4_PRODUTO,1,4)$"01VS"
		If _cTipo == 1
			_VarRet := QRY->D4_LOTECTL
		ElseIf _cTipo == 2
			_VarRet := (dDataBase+365)
		ElseIf _cTipo == 3
			_VarRet := StoD(QRY->D4_DATA)
		EndIf
	EndIf
EndIf

QRY->(dbCloseArea())

RestArea(aAreaSd3)

Return(_VarRet)
