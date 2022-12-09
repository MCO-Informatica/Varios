#include "RWmake.ch"
#INCLUDE "COLORS.CH"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณRFATR104  บAutor  ณMarcos Floridi Leme บ Data ณ  26/01/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de Movimenta็๕es de NFs / Fretes   	          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 GrandVivant                                    บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATR104()

Processa({||RFATRR104(),"Processando... Favor Aguardar."})

Static Function RFATRR104()

Local 	cQry2:= ""
Local _x:=1
Private cPerg    := "RFATR104"


ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

cQry2:= " SELECT "
cQry2+= " CONVERT(CHAR,CAST(F2_EMISSAO AS DATETIME) ,103) DTEMISSAO, "
cQry2+= " F2_DOC NF, "
cQry2+= " F2_SERIE SERIE, "
cQry2+= " F2_CLIENTE COD_CLI, "
cQry2+= " A1_NOME CLIENTE, "
cQry2+= " A1_MUN DESTINO, "
cQry2+= " A1_EST UF, "
cQry2+= " F2_VALBRUT VL_BRUTO, F2_TRANSP COD_TRANSP,A4_NOME TRANSP, F2_TPFRETE TP_FRT,F2_REDESP REDESP, F2_X_NOMRD NOM_REDESP, F2_XVALFRR VL_REDESP, ISNULL(D1_TOTAL,0) CUSTO_CTE, "
cQry2+= " ISNULL((D1_TOTAL/F2_VALBRUT)*100,0) PERC_FRT,F2_VOLUME1 VOLUME ,F2_PBRUTO PESO, "
cQry2+= " ISNULL(D1_FORNECE,'') COD_FOR_CTE, ISNULL(A2_NOME,'') FORN_CTE, ISNULL(D1_DOC,'') NUM_CTE, ISNULL(D1_NFORI,'') NF_ORIG,ISNULL(D1_SERIORI,'') SERIE_ORIG "
cQry2+= " FROM SF2010 "
cQry2+= " LEFT JOIN SA1010 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SA1010.D_E_L_E_T_ = '' "
cQry2+= " LEFT JOIN SA4010 ON A4_COD = F2_TRANSP AND SA4010.D_E_L_E_T_ = '' "
cQry2+= " LEFT JOIN SD1010 ON D1_FILIAL = F2_FILIAL AND SUBSTRING(D1_NFORI,4,6) = F2_DOC  AND SD1010.D_E_L_E_T_ = '' "
cQry2+= " LEFT JOIN SA2010 ON A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2010.D_E_L_E_T_ = '' "
cQry2+= " WHERE SF2010.D_E_L_E_T_ = '' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND F2_TIPO = 'N' AND F2_SERIE BETWEEN'"+MV_PAR03+"' AND '"+MV_PAR04+"' AND F2_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
cQry2+= " F2_TRANSP BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND F2_REDESP BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND D1_DOC BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
cQry2+= " ORDER BY F2_EMISSAO, A4_COD, A1_COD, F2_DOC "

TcQuery cQry2 New Alias "QRY1"

DbSelectArea("QRY1")
DbGotop()
ProcRegua(QRY1->(RecCount()))
If !QRY1->(Eof())
	_aStru := QRY1->(DbStruct())
	oExcel    := FWMSEXCEL():New()
	oExcel:SetFontSize(09)    	
	oExcel:AddworkSheet("MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02))
	oExcel:AddTable ("MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),"MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02))
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),"MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),_aStru[_x,1],3,2)
		ElseIf _aStru[_x,2] == "C"
			If "/" $ _aStru[_x,1]
				oExcel:AddColumn("MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),"MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),_aStru[_x,1],1,4)
			Else
				oExcel:AddColumn("MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),"MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),_aStru[_x,1],1,1)
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
		
		oExcel:AddRow("MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),"MOV-NF-CTE - "+DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02),_aLinha)
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg  บAutor  ณMarcos Floridi Leme Data ณ  10/04/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida e cria as perguntas selecionadas                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa Principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

Local i:=1
Local j:=1
_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
aRegs :={}

AADD(aRegs,{cPerg,"01","De Data                       ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Data                      ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De Serie                      ","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"04","At้ Serie                     ","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"05","De Cliente                    ","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""}) 
AADD(aRegs,{cPerg,"06","At้ Cliente                   ","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""}) 
AADD(aRegs,{cPerg,"07","De Transportadora             ","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(aRegs,{cPerg,"08","At้ Transportadora            ","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(aRegs,{cPerg,"09","De Redespacho                 ","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(aRegs,{cPerg,"10","At้ Redespacho                ","","","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(aRegs,{cPerg,"11","De CTE                        ","","","mv_chb","C",09,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"12","At้ CTE                       ","","","mv_chc","C",09,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"13","Tipo					      ","","","mv_chd","C",01,0,0,"C","","mv_par13","Padrao","","","","","Fiscal","","","","","","","","","","","","","","","","","","","",""})


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
