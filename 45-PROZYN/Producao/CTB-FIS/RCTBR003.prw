#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBR003  ºAutor  ³Edmilson  º Data ³		      05/02/18    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE CONTABILIDADE - EXCEL                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCTBR003

Private cPerg		:= "RCTBR003"

ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

cQry := "SELECT CONVERT(CHAR(10),CONVERT(DATE,CT2_DATA),103) AS DATA,CT2_LOTE,CT2_DEBITO,CT2_VALOR *-1 AS VALOR,CT2_HIST,CT2_CCD "
cQry += "FROM " + RetSqlName("CT2") + " CT2 ," + RetSqlName("CT1") + " CT1 " 
cQry += "WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQry += "AND CT2_DEBITO > '30000000000000' "
cQry += "AND CT2_TPSALD = '1' "
cQry += "AND CT2_MOEDLC = '01' "
cQry += "AND CT2_DEBITO=CT1_CONTA "
cQry += "AND CT2.D_E_L_E_T_ <> '*' "
cQry += "AND CT1.D_E_L_E_T_ <> '*' " 
cQry += "UNION ALL "
cQry += "SELECT CONVERT(CHAR(10),CONVERT(DATE,CT2_DATA),103) AS DATA,CT2_LOTE,CT2_CREDIT,CT2_VALOR AS VALOR,CT2_HIST,CT2_CCC "
cQry += "FROM " + RetSqlName("CT2") + " CT2 ," + RetSqlName("CT1") + " CT1 "
cQry += "WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQry += "AND CT2_CREDIT > '30000000000000' "
cQry += "AND CT2_TPSALD = '1' "
cQry += "AND CT2_MOEDLC = '01' "
cQry += "AND CT2_CREDIT=CT1_CONTA "
cQry += "AND CT2.D_E_L_E_T_ <> '*' "
cQry += "AND CT1.D_E_L_E_T_ <> '*' "  

TcQuery cQry New Alias "QRY1"

DbSelectArea("QRY1")
DbGotop()
ProcRegua(QRY1->(RecCount()))
If !QRY1->(Eof())
	_aStru := QRY1->(DbStruct())
	oExcel    := FWMSEXCEL():New()
	oExcel:AddworkSheet("RELAT. POR CC")
	oExcel:AddTable ("RELAT. POR CC","RELAT. POR CC")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("RELAT. POR CC","RELAT. POR CC",_aStru[_x,1],3,2)
		ElseIf _aStru[_x,2] == "C"
			If "/" $ _aStru[_x,1]
				oExcel:AddColumn("RELAT. POR CC","RELAT. POR CC",_aStru[_x,1],1,4)
			Else
				oExcel:AddColumn("RELAT. POR CC","RELAT. POR CC",_aStru[_x,1],1,1)
			EndIf
		EndIf
	Next
	
	While !QRY1->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			_aLinha[_x] := QRY1->&(_cCpo)
		Next
		
		oExcel:AddRow("RELAT. POR CC","RELAT. POR CC",_aLinha)
		QRY1->(DbSkip())
	EndDo
	
	
	oExcel:Activate()
	_cFile := (CriaTrab(NIL, .F.) + ".xml")
	While File(_cFile)
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
	EndDo
	oExcel:GetXMLFile(_cFile)
	oExcel:DeActivate()
	If !(File(_cFile))
		_cFile := ""
		QRY1->(DbCloseArea())
		Break
	EndIf
	_cFileTMP := (GetTempPath() + _cFile)
	If !(__CopyFile(_cFile , _cFileTMP))
		fErase( _cFile )
		_cFile := ""
		QRY1->(DbCloseArea())
		Break
	EndIf
	fErase(_cFile)
	_cFile := _cFileTMP
	If !(File(_cFile))
		_cFile := ""
		QRY1->(DbCloseArea())
		Break
	EndIf
	oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open(_cFile)
	oMsExcel:SetVisible(.T.)
	oMsExcel := oMsExcel:Destroy()
	
	FreeObj(oExcel)
	oExcel := NIL
	
EndIf
QRY1->(DbCloseArea())

Return 

Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

aAdd(aRegs,{cPerg,"01","De Data    ?","","","mv_ch1","D",08,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Até Data   ?","","","mv_ch2","D",08,0,0,"G","naovazio()","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return