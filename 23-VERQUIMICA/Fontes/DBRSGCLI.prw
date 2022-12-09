#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"   
#DEFINE DMPAPER_A4 9
#DEFINE CRLF CHR(13)+CHR(10)        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DBRSGCLI  ºAutor ³Danilo Alves Del Busso ºData³  25/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Clientes por Segmento de Atividade            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function DBRSGCLI()   

Local oReport     
Private _cFilRegV 	 := ""
Private _cFilGrpV    := ""  
Private _cFilZ06 	 := ""
Private _cFilAcy	 := ""
Private _cUsuario	 := Upper(Alltrim(__cUserID))
Private _cCodVend    := _getVended(_cUsuario)       // Código do Vendedor  
Private _aFilRegV	 := U__getRegV(_cCodVend)		// Filtra as regioes de vendas do vendedor
Private _aFilGrpV	 := U__getGrpV(_cCodVend)		// Filtra as grupo de vendas do vendedor                
Private _cUsrLibA	 := _cUsuario $ GetMv("VQ_CONVEN") 

oReport := reportDef()
oReport:printDialog()

Return()

Static Function reportDef()

Local oReport
Local oSection1
Local oSection2
Local cTitulo 	:= 'Segmentos Cliente'    
Local cQuery 	:= ""   
Local nTotalReg := 0       
Local cFilSA1 	:= "RelSg"
                      
oReport := TReport():New("DBRSGCLI", cTitulo, "DBRSGCLI", {|oReport| Processa( {|| PrintReport(oReport)})}, "Relatorio de Clientes por Segmentos")
oReport:SetLandScape() //Retrato
oReport:SetTotalInLine(.T.)
oReport:ShowHeader()

PutSX1("DBRSGCLI","01","Cliente de  	","","","MV_CH1","C",6 ,0,0,"G","","SA1"/*"CONPADRAO"*/,"","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","02","Cliente ate 	","","","MV_CH2","C",6 ,0,0,"G","","SA1"/*"CONPADRAO"*/,"","","MV_PAR02","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","03","Regiao de    	","","","MV_CH3","C",3 ,0,0,"G","","Z06"/*"CONPADRAO"*/,"","","MV_PAR03","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","04","Regiao ate      ","","","MV_CH4","C",3 ,0,0,"G","","Z06"/*"CONPADRAO"*/,"","","MV_PAR04","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","05","Divisao de      ","","","MV_CH5","C",4 ,0,0,"G","","ACY"/*"CONPADRAO"*/,"","","MV_PAR05","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","06","Divisao ate     ","","","MV_CH6","C",4 ,0,0,"G","","ACY"/*"CONPADRAO"*/,"","","MV_PAR06","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","07","Ativ. 1 de      ","","","MV_CH7","C",6 ,0,0,"G","","T3"/*"CONPADRAO"*/,"","","MV_PAR07","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","08","Ativ. 1 ate     ","","","MV_CH8","C",6 ,0,0,"G","","T3"/*"CONPADRAO"*/,"","","MV_PAR08","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","09","Ativ. 2 de      ","","","MV_CH9","C",6 ,0,0,"G","","T3"/*"CONPADRAO"*/,"","","MV_PAR09","","","","","","","","","","","","","","","","","","","")
PutSX1("DBRSGCLI","10","Ativ. 2 ate     ","","","MV_CH10","C",6,0,0,"G","","T3"/*"CONPADRAO"*/,"","","MV_PAR10","","","","","","","","","","","","","","","","","","","")
If (!_cUsrLibA)    
	
	DbSelectArea("Z06") ; DbSetOrder(1)
	Set Filter To
	_cFilZ06 := ""  
	If Len(_aFilRegV) > 0
		_cFilZ06 := "Z06_FILIAL='" + xFilial("Z06") + "'"
		For nX := 1 To Len(_aFilRegV)
			If nX == 1
				_cFilZ06 += ".And.("
			Else
				_cFilZ06 += ".Or."
			EndIf
			_cFilZ06 += "(Z06_CODIGO='"+_aFilRegV[nX] + "')"       
		Next
		_cFilZ06 += ")"     
		DbSelectArea("Z06")
		Set Filter To &(_cFilZ06)
	EndIf
		
	DbSelectArea("ACY") ; DbSetOrder(1)
	Set Filter To
	_cFilACY := ""  
	If Len(_aFilGrpV) > 0
		_cFilACY := "ACY_FILIAL='" + xFilial("ACY") + "'"
		For nX := 1 To Len(_aFilGrpV)
			If nX == 1
				_cFilACY += ".And.("
			Else
				_cFilACY += ".Or."
			EndIf
			_cFilACY += "(ACY_GRPVEN='"+_aFilGrpV[nX] + "')"  
		Next
		_cFilACY += ")"    
		DbSelectArea("ACY")
		Set Filter To &(_cFilACY)
	EndIf
EndIf

Pergunte(oReport:uParam,.F.)
  
oSection1 := TRSection():New(oReport, "Segmentos Clientes")                 
TRCell():New(oSection1,"CODIGO"			,,"Codigo"			,"@!",6,,,,,)
TRCell():New(oSection1,"LOJA"			,,"Loja"			,"@!",2,,,,,)
TRCell():New(oSection1,"RAZAOSOCIAL"	,,"Razao Social"	,"@!",20,,,,,)
TRCell():New(oSection1,"NOME"			,,"Nome"			,"@!",40,,,,,)
TRCell():New(oSection1,"CODREGIAO"		,,"Cod. Regiao"		,"@!",3,,,,,)
TRCell():New(oSection1,"DESREGIAO"		,,"Regiao"			,"@!",40,,,,,)
TRCell():New(oSection1,"CODDIVISAO"		,,"Cod. Divisao"	,"@!",4,,,,,)
TRCell():New(oSection1,"DESDIVISAO"		,,"Divisao"			,"@!",20,,,,,)
TRCell():New(oSection1,"CODATIV1"		,,"Cod.Ativ 1"		,"@!",6,,,,,)
TRCell():New(oSection1,"DESATIV1"		,,"Atividade 1"	  	,"@!",20,,,,,)
TRCell():New(oSection1,"CODATIV2"		,,"Cod.Ativ 2"		,"@!",6,,,,,)
TRCell():New(oSection1,"DESATIV2"		,,"Atividade 2"		,"@!",20,,,,,)     

oSection2 := TRSection():New(oReport, "Total Cliente")       
TRCell():New(oSection2,"TOTALCLIENTE"			,,"TOTAL DE CLIENTES"			,"@!",80,,,,,)


Return(oReport)

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)  
Local oSection2 := oReport:Section(2)

Local nLinha	:= 0  
Local aCodCli	:= {}
Local cCliAnt	:= ""

cQuery := "SELECT 		" 		+ CRLF
cQuery += " A1_COD 		" 		+ CRLF
cQuery += " ,A1_LOJA 	" 		+ CRLF
cQuery += " ,A1_NREDUZ 	" 		+ CRLF
cQuery += " ,A1_NOME 	" 		+ CRLF
cQuery += " ,A1_REGIAO 	" 		+ CRLF
cQuery += " ,Z06_DESCRI " 		+ CRLF
cQuery += " ,A1_GRPVEN 	" 		+ CRLF
cQuery += " ,ACY_DESCRI " 		+ CRLF
cQuery += " ,A1_SATIV1 	" 		+ CRLF
cQuery += " ,A1_SATIV2 	" 		+ CRLF
cQuery += " FROM SA1010 SA1  " 	+ CRLF
cQuery += "   INNER JOIN Z06010 Z06 ON (SA1.A1_REGIAO = Z06.Z06_CODIGO AND Z06.D_E_L_E_T_ <> '*') " + CRLF
cQuery += "   INNER JOIN ACY010 ACY ON (SA1.A1_GRPVEN = ACY.ACY_GRPVEN AND ACY.D_E_L_E_T_ <> '*') " + CRLF
cQuery += " WHERE 		"		+ CRLF
cQuery += "   SA1.D_E_L_E_T_ <> '*' " 	+ CRLF    
cQuery += "   AND SA1.A1_COD BETWEEN '"+MV_PAR01+"' AND '" 	 + IIF(!Empty(MV_PAR02),AllTrim(MV_PAR02),"ZZZZZZ") 	+ "'" + CRLF 
cQuery += "	 AND  (SA1.A1_REGIAO BETWEEN '"+MV_PAR03+"' AND '" + IIF(!Empty(MV_PAR04),AllTrim(MV_PAR04),"ZZZ") 		+ "'" + IIF(!_cUsrLibA," AND SA1.A1_REGIAO 	IN ("+_cFilRegV+")) ", " )") 	+ CRLF             
cQuery += "	 AND  (SA1.A1_GRPVEN BETWEEN '"+MV_PAR05+"' AND '" + IIF(!Empty(MV_PAR06),AllTrim(MV_PAR06),"ZZZZ") 	+ "'" + IIF(!_cUsrLibA," AND SA1.A1_GRPVEN 	IN ("+_cFilGrpV+"))", ")") 	+ CRLF             
cQuery += "	 AND SA1.A1_SATIV1 BETWEEN '"+MV_PAR07+"' AND '" + IIF(!Empty(MV_PAR08),AllTrim(MV_PAR08),"ZZZZZZ") 	+ "'" + CRLF             
cQuery += "	 AND SA1.A1_SATIV2 BETWEEN '"+MV_PAR09+"' AND '" + IIF(!Empty(MV_PAR10),AllTrim(MV_PAR10),"ZZZZZZ") 	+ "'" + CRLF    
cQuery += " ORDER BY SA1.A1_NREDUZ, SA1.A1_COD, SA1.A1_LOJA"

cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "QRY"

DbSelectArea("QRY")                                                                               	
nTotalReg := Contar("QRY", "!Eof()")   
ProcRegua( nTotalReg )
QRY->(DbGoTop())

oReport:SetMeter(nTotalReg)

While QRY->(!Eof())  
		oSection1:Init()
		oReport:IncMeter()		
		oSection1:Cell("CODIGO"):SetValue(QRY->A1_COD)              
		oSection1:Cell("LOJA"):SetValue(QRY->A1_LOJA)     
		oSection1:Cell("RAZAOSOCIAL"):SetValue(QRY->A1_NREDUZ)       
		oSection1:Cell("NOME"):SetValue(QRY->A1_NOME)        
		oSection1:Cell("CODREGIAO"):SetValue(QRY->A1_REGIAO)    
		oSection1:Cell("DESREGIAO"):SetValue(QRY->Z06_DESCRI) 
		oSection1:Cell("CODDIVISAO"):SetValue(QRY->A1_GRPVEN)  
		oSection1:Cell("DESDIVISAO"):SetValue(QRY->ACY_DESCRI)      
		
		If (!Empty(QRY->A1_SATIV1))
			oSection1:Cell("CODATIV1"):SetValue(QRY->A1_SATIV1)       
			DbSelectArea("SX5"); DbSetOrder(1)                           
			If SX5->(DbSeek(xFilial("SX5")+"T3"+QRY->A1_SATIV1))
				oSection1:Cell("DESATIV1"):SetValue(SX5->X5_DESCRI)    
			EndIf                                                   
		Else                                                       
			oSection1:Cell("CODATIV1"):SetValue("")                
			oSection1:Cell("DESATIV1"):SetValue("")
		EndIf

		If (!Empty(QRY->A1_SATIV2))
			oSection1:Cell("CODATIV2"):SetValue(QRY->A1_SATIV2)       
			DbSelectArea("SX5"); DbSetOrder(1)
			If SX5->(DbSeek(xFilial("SX5")+"T3"+QRY->A1_SATIV2))
				oSection1:Cell("DESATIV2"):SetValue(SX5->X5_DESCRI)
			EndIf
		Else                                                       
			oSection1:Cell("CODATIV2"):SetValue("")                
			oSection1:Cell("DESATIV2"):SetValue("")
		EndIf
                       
		If aScan(aCodCli, Alltrim(QRY->A1_COD)) == 0
			aadd(aCodCli, Alltrim(QRY->A1_COD))
		EndIf

		oSection1:Printline()
    IncProc(OemToAnsi("Registrando Linha: " + cValToChar(nLinha) + ' - ' + cValToChar(nTotalReg) ))  		
	QRY->(DbSkip())
EndDo        
oSection1:Finish()  
oReport:FatLine()
oSection2:Init()   
oSection2:Cell("TOTALCLIENTE"):SetValue(cValToChar(Len(aCodCli)))    
oSection2:Printline()
oSection2:Finish()

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

Return()          

Static Function _getVended(_cUsuario)
Local _cRet := ""

DbSelectArea("SA3"); DbSetOrder(7)         

If (SA3->(Dbseek(xFilial("SA3")+_cUsuario)))
	_cRet := SA3->A3_COD	
EndIf

Return _cRet