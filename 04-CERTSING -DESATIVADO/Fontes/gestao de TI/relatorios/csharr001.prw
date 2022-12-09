# Include "Protheus.ch"

#DEFINE X3_USADO_EMUSO 		"€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO 	"€€€€€€€€€€€€€€€"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณCSHARR001   บAutor  ณMarcelo Celi Marquesบ Data ณ 04/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de Hardwares.							          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CSHARR001()
Local oReport     
Local cTitulo := "Listagem de Hardware"

aCposU00 := GetCpos("U00",,{"U00_FILIAL"})
aCposU05 := GetCpos("U05","U05_FILIAL|U05_CODHRD")
          
If Len(aCposU00)>0 .And. Len(aCposU05)>0 
	oReport:= ReportDef(cTitulo,aCposU00,aCposU05)
	oReport:PrintDialog()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณReportDef   บAutor  ณMarcelo Celi Marquesบ Data ณ 04/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de Hardwares.							          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef(cTitulo,aCposU00,aCposU05)
Local oReport 
Local oSection1
Local oSection2

Local oCell         
Local aOrdem := {}
Local nX

Local cPergunte := "CSHARR001"

AtuSx1(cPergunte)
Pergunte(cPergunte,.F.)      

oReport:= TReport():New(cPergunte,cTitulo,cPergunte, {|oReport| ReportPrint(oReport,aCposU00,aCposU05)},cTitulo)
oReport:SetTotalInLine(.F.)
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"Propriedades do Hardware"			,{},aOrdem,,,,,,.T.,,,,.T.,,,,,5) 
oSection1 :SetTotalInLine(.F.)                                

oSection2 := TRSection():New(oReport,"Softwares Vinculados ao Hardware"	,{},aOrdem,,,,,,.T.,,,) 
oSection2 :SetTotalInLine(.F.)                                

For nX:=1 to Len(aCposU00)                              
	TRCell():New(oSection1,	aCposU00[nX]	,""	,U00->(RetTitle(aCposU00[nX]))	,PesqPict("U00",aCposU00[nX])	,Tamsx3(aCposU00[nX])[1]+If(IsCombo(aCposU00[nX]),15,0),,) 
Next nX

For nX:=1 to Len(aCposU05)                              
	TRCell():New(oSection2,	aCposU05[nX]	,""	,U05->(RetTitle(aCposU05[nX]))	,PesqPict("U05",aCposU05[nX])	,Tamsx3(aCposU05[nX])[1]+If(IsCombo(aCposU05[nX]),15,0),,) 
Next nX

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณReportPrint บAutor  ณMarcelo Celi Marquesบ Data ณ 04/10/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de Ativos.								          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport,aCposU00,aCposU05)
Local oSection1 := oReport:Section(1) 
Local nOrdem    := oReport:Section(1):GetOrder() 
Local oSection2 := oReport:Section(2) 
Local nX		:= 0
Local nY		:= 0
Local cQuery	:= ""

cQuery := "SELECT U00_DESHRD, R_E_C_N_O_ AS RECU00 FROM "+RetSqlName("U00")+" U00 "
cQuery += "			WHERE 	U00.D_E_L_E_T_ = '' "                           
cQuery += "				AND U00_CODHRD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 
cQuery += "				AND U00_TIPHRD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
If MV_PAR05<>3
	cQuery += "				AND U00_PROPRI = '"+Alltrim(Str(MV_PAR05))+"' " 
EndIf                                                              
If MV_PAR06<>5
	cQuery += "				AND U00_STATUS = '"+Alltrim(Str(MV_PAR06))+"' " 
EndIf                                                              
cQuery += "				AND U00_CODLOC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " 
cQuery += "				AND U00_CODFUN BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' " 
cQuery += "				AND U00_FILIAL BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' " 
cQuery += "			ORDER BY U00_DESHRD "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBU00", .F., .T.)

oReport:SetMeter(TRBU00->(RecCount()))
Do While !TRBU00->(Eof())	
	// Se cancelado pelo usuario                            	     
	If oReport:Cancel()
		Exit			
	Else	                              
		U00->(dbGoto(TRBU00->RECU00))
		For nX:=1 to Len(aCposU00) 
			cConteudo := CSFormat("U00",aCposU00[nX])		       
			oSection1:Cell(aCposU00[nX]):SetValue(cConteudo)			
		Next nX
		oSection1:Init() 
		oSection1:PrintLine()
		
		cQuery := "SELECT U05_CODCOM, R_E_C_N_O_ AS RECU05 FROM "+RetSqlName("U05")+" U05 "
		cQuery += "			WHERE 	U05.D_E_L_E_T_ = '' "                           
		cQuery += "				AND U05_FILIAL = '"+U00->U00_FILIAL+"' " 
		cQuery += "				AND U05_CODHRD = '"+U00->U00_CODHRD+"' " 
		cQuery += "			ORDER BY U05_CODCOM "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBU05", .F., .T.)
		Do While !TRBU05->(Eof())	
        	U05->(dbGoto(TRBU05->RECU05))
        	For nX:=1 to Len(aCposU05)        
				oSection2:Cell(aCposU05[nX]):SetValue(U05->&(aCposU05[nX]))			
			Next nX
			oSection2:Init() 
			oSection2:PrintLine()				
			TRBU05->(dbSkip())
		EndDo
		TRBU05->(dbCloseArea())
		
		oSection1:Finish() 
		oSection2:Finish() 
		
		oReport:EndPage() 
		
	 EndIf
	 TRBU00->(dbSkip())
EndDo	           
TRBU00->(dbCloseArea())
			
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณAtuSx1      บAutor  ณMarcelo Celi Marquesบ Data ณ 04/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo dos SX1.								          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuSx1(cPerg)
Local aHlpPor := {}
aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"01","Do Hardware?","","","mv_ch1","C",TamSX3("U00_CODHRD")[1],0,1,;   
				"G","","U00_01","","S","mv_par01","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""		)
PutSx1(cPerg,	"02","At้ Hardware?","","","mv_ch2","C",TamSX3("U00_CODHRD")[1],0,1,;   
				"G","","U00_01","","S","mv_par02","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"03","Tipo de?","","","mv_ch3","C",TamSX3("U00_TIPHRD")[1],0,1,;   
				"G","","U06_01","","S","mv_par03","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"04","Tipo At้?","","","mv_ch4","C",TamSX3("U00_TIPHRD")[1],0,1,;   
				"G","","U06_01","","S","mv_par04","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"05","Propriedade?","","","mv_ch5","N",TamSX3("U00_PROPRI")[1],0,1,;   
				"C","","","","S","mv_par05","Empresa","","","","Particular","","","Ambos","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"06","Status?","","","mv_ch6","N",TamSX3("U00_STATUS")[1],0,1,;   
				"C","","","","S","mv_par06","Ativo","","","","Manuten็ใo","","","Estocado","","","Baixado","","","Todos","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"07","Local de?","","","mv_ch7","C",TamSX3("U00_CODLOC")[1],0,1,;   
				"G","","SZ3","","S","mv_par07","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"08","Local At้?","","","mv_ch8","C",TamSX3("U00_CODLOC")[1],0,1,;   
				"G","","SZ3","","S","mv_par08","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"09","Funcionแrio de?","","","mv_ch9","C",TamSX3("U00_CODFUN")[1],0,1,;   
				"G","","RD001","","S","mv_par09","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"10","Funcionแrio At้?","","","mv_chA","C",TamSX3("U00_CODFUN")[1],0,1,;   
				"G","","RD001","","S","mv_par10","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"11","Filial de?","","","mv_chB","C",TamSX3("U00_FILIAL")[1],0,1,;   
				"G","","","","S","mv_par11","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"12","Filial At้?","","","mv_chC","C",TamSX3("U00_FILIAL")[1],0,1,;   
				"G","","","","S","mv_par12","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณGetCpos     บAutor  ณMarcelo Celi Marquesบ Data ณ 04/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณAlimenta array e retorna com campos do alias informado.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCpos(cAlias,cExcecao,aIncluir)
Local aCpos := {}
Local aArea := GetArea()   
Local nX	:= 0

Default cExcecao := ""     
Default aIncluir := {}

aCpos	:= aIncluir    

SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias))
Do While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias
    If !(SX3->X3_CAMPO $ cExcecao) .And. SX3->X3_USADO == X3_USADO_EMUSO .And. SX3->X3_CONTEXT <> "V" .And. Ascan(aCpos,{|x| x==SX3->X3_CAMPO})==0
    	aAdd(aCpos,SX3->X3_CAMPO)
    EndIf
	SX3->(dbSkip())
EndDo

RestArea(aArea)
Return aCpos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณCSFormat    บAutor  ณMarcelo Celi Marquesบ Data ณ 04/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณPega o conteudo do campo e retorna a combo caso use.	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CSFormat(cAlias,cCampo)		       
Local cConteudo := (cAlias)->&(cCampo)                    
If IsCombo(cCampo)
	cConteudo:=x3Combo(cCampo,(cAlias)->&(cCampo))
EndIf
Return cConteudo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIsCombo     บAutor  ณMarcelo Celi Marquesบ Data ณ 04/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณRetorna se ้ combo.									      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IsCombo(cCampo)		       
Local lRet := .F.
Local aArea		:= GetArea()
SX3->(dbSetOrder(2))
If SX3->(dbSeek(cCampo)) .And. !Empty(SX3->X3_CBOX)
	lRet := .T.
EndIf
RestArea(aArea)
Return lRet

