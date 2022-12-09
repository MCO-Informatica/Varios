#Include 'Protheus.ch'
#Include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPPRICOMPFบAutor  ณMarco - primainfo   บ Data ณ  13/03/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera os dados para comparacao de folha                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPPRICOMPF()

Local oReport
Local cFile := ""

// Declaracao de Variaveis
Private cPerg    := "GPPRICOMPF"
Private cString  := "SRA"
Private oGeraTxt
Private lcampos := .T. //Campos esperados da Query estao OK

fPriPerg()

pergunte(cPerg,.T.)

cFilDe    	:= mv_par01
cFilAte   	:= mv_par02
cMatDe    	:= mv_par03
cMatAte   	:= mv_par04
cCcDe     	:= mv_par05
cCcAte    	:= mv_par06
cSituacao  	:= fSqlIn(mv_par07,1)
cCategoria 	:= fSqlIn(mv_par08,1)
cPDDe     	:= mv_par09
cPDAte    	:= mv_par10              
nDif        := mv_par11
cRot		:= fSqlIn(mv_par12,3)
cAnoMesAtu	:= mv_par13
cAnoMesAnt	:= mv_par14

FwMsgRun(,{|oSay| Print(@oSay)},"Processando","Gerando arquivo...")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณprint     บAutor  ณMicrosiga           บ Data ณ  03/16/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Print()

Local oExcel		:= FWMSEXCEL():New()
Local nI			:= 0
Local _aStruct	:= {}
Local _aRow		:= {}
Local _aAlias		:= {GetNextAlias()}
Local aWSheet		:= {{"Compara Mes Anterior"}}				//05

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())           
	
	For xz := 1 to Len(_aStruct)
		If Alltrim(_aStruct[xz,1]) $ "RA_ADMISSA/RA_DEMISSA"  
			TCSetField(_aAlias[nI],_aStruct[xz,1], "D", 08, 0 )
		Endif
	Next xz
	
	aEval(_aStruct,{|x| oExcel:AddColumn(aWSheet[nI][1],aWSheet[nI][1],If(Empty(cTitulo:=Posicione("SX3",2,x[1],"X3_TITULO")),x[1],cTitulo),2,1)})
	//oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col1",2,1)
	(_aAlias[nI])->(DbGoTop())
	While (_aAlias[nI])->(!Eof())
		_aRow := Array(Len(_aStruct))
		nX := 0
		aEval(_aStruct,{|x| nX++,_aRow[nX] := (_aAlias[nI])->&(x[1])})
		oExcel:AddRow(aWSheet[nI][1],aWSheet[nI][1],_aRow)
		(_aAlias[nI])->(DbSkip())
	EndDo
	
Next

oExcel:Activate()

cFolder := cGetFile("XML | *.XML", OemToAnsi("Informe o diretorio.",1,7),,,,nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE))
cFile := cFolder+".XML"

oExcel:GetXMLFile(cFile)

MsgInfo("Arquivo gerado com sucesso, sera aberto apos o fechamento dessa mensagem." + CRLF + cFile)

If ApOleClient("MsExcel")
	oExcelApp:=MsExcel():New()
	oExcelApp:WorkBooks:Open(cFile)
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo("Excel nao instaldo!"+chr(13)+chr(10)+"Relatorio gerado com sucesso, arquivo gerado no diretorio abaixo: "+chr(13)+cFile)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPRMI002  บAutor  ณMicrosiga           บ Data ณ  02/15/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetTable(_cAlias,nTipo)

Local cQuery := ""
Local cTipoDB := UPPER(Alltrim(TCGetDB()))

cQuery := ""
cquery += " SELECT T.* FROM("
cquery += " SELECT RA_FILIAL,RA_CC,CTT_DESC01,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RA_SITFOLH,RA_ADMISSA,RA_DEMISSA,RA_BCDEPSA,RA_CTDEPSA,RV_COD,RV_DESC"
cquery += " ,NVL((SELECT ROUND(SUM(RD_VALOR),2) FROM "+RetSqlName("SRD") + " WHERE D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PD=RV_COD AND RD_PERIODO = '"+cAnoMesAnt+"' AND RD_ROTEIR  IN (" + cRot + ")),0) "
cquery += " +NVL((SELECT ROUND(SUM(RC_VALOR),2) FROM "+RetSqlName("SRC") + " WHERE D_E_L_E_T_ = ' ' AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND RC_PD=RV_COD AND RC_PERIODO = '"+cAnoMesAnt+"' AND RC_ROTEIR  IN (" + cRot + ")),0) VALOR_ANT"
cquery += " ,NVL((SELECT ROUND(SUM(RD_VALOR),2) FROM "+RetSqlName("SRD") + " WHERE D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PD=RV_COD AND RD_PERIODO = '"+cAnoMesAtu+"' AND RD_ROTEIR  IN (" + cRot + ")),0) "
cquery += " +NVL((SELECT ROUND(SUM(RC_VALOR),2) FROM "+RetSqlName("SRC") + " WHERE D_E_L_E_T_ = ' ' AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND RC_PD=RV_COD AND RC_PERIODO = '"+cAnoMesAtu+"' AND RC_ROTEIR  IN (" + cRot + ")),0) VALOR_ATU"
cquery += " ,NVL((SELECT ROUND(SUM(RD_HORAS),2) FROM "+RetSqlName("SRD") + " WHERE D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PD=RV_COD AND RD_PERIODO = '"+cAnoMesAnt+"' AND RD_ROTEIR  IN (" + cRot + ")),0) "
cquery += " +NVL((SELECT ROUND(SUM(RC_HORAS),2) FROM "+RetSqlName("SRC") + " WHERE D_E_L_E_T_ = ' ' AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND RC_PD=RV_COD AND RC_PERIODO = '"+cAnoMesAnt+"' AND RC_ROTEIR  IN (" + cRot + ")),0) QUANT_ANT"
cquery += " ,NVL((SELECT ROUND(SUM(RD_HORAS),2) FROM "+RetSqlName("SRD") + " WHERE D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PD=RV_COD AND RD_PERIODO = '"+cAnoMesAtu+"' AND RD_ROTEIR  IN (" + cRot + ")),0) "
cquery += " +NVL((SELECT ROUND(SUM(RC_HORAS),2) FROM "+RetSqlName("SRC") + " WHERE D_E_L_E_T_ = ' ' AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND RC_PD=RV_COD AND RC_PERIODO = '"+cAnoMesAtu+"' AND RC_ROTEIR  IN (" + cRot + ")),0) QUANT_ATU"
cquery += " ,NVL((SELECT MAX(RD_TIPO2) FROM "+RetSqlName("SRD") + " WHERE D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PD=RV_COD AND RD_DATARQ = '"+cAnoMesAnt+"'  AND RD_ROTEIR  IN (" + cRot + ")),NVL((SELECT MAX(RC_TIPO2) FROM "+RetSqlName("SRC") + " WHERE D_E_L_E_T_ = ' ' AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND RC_PD=RV_COD AND RC_PERIODO = '"+cAnoMesAnt+"'  AND RC_ROTEIR  IN (" + cRot + ")),'')) TIPO_ANT"
cquery += " ,NVL((SELECT MAX(RD_TIPO2) FROM "+RetSqlName("SRD") + " WHERE D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PD=RV_COD AND RD_DATARQ = '"+cAnoMesAtu+"'  AND RD_ROTEIR  IN (" + cRot + ")),NVL((SELECT MAX(RC_TIPO2) FROM "+RetSqlName("SRC") + " WHERE D_E_L_E_T_ = ' ' AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND RC_PD=RV_COD AND RC_PERIODO = '"+cAnoMesAnt+"'  AND RC_ROTEIR  IN (" + cRot + ")),'')) TIPO_ATU"
cquery += " FROM "+RetSqlName("SRA") + " SRA, "+RetSqlName("SRV") + " SRV, "+RetSqlName("CTT") + " CTT"
cquery += " WHERE"
cquery += "     SRA.D_E_L_E_T_ = ' '"
cquery += " AND SRV.D_E_L_E_T_ = ' '
cquery += " AND CTT.D_E_L_E_T_ = ' '
cQuery += " AND RA_CC = CTT_CUSTO"
cquery += " AND RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cquery += " AND RA_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
cquery += " AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"'"
cquery += " AND RV_COD BETWEEN '"+cPDDe+"' AND '"+cPDAte+"'"
cQuery += " AND RA_SITFOLH IN (" + cSituacao + ") "
cQuery += " AND RA_CATFUNC IN (" + cCategoria + ") "
cquery += " )T"
If nDif == 1
	cquery += " WHERE VALOR_ANT <> VALOR_ATU"
Else
   cquery += " WHERE (VALOR_ANT > 0 OR VALOR_ATU > 0)" 	
EndIf
cquery += " ORDER BY RA_FILIAL,RA_MAT,RV_COD" 

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .F.)
(_cAlias)->(DBGOTOP())

Return


Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPriPerg  บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPriPerg()

Local aRegs := {}
Local a_Area := getArea()

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Filial De ?             ','','','mv_ch1','C',02,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?             ','','','mv_ch2','C',02,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'03','Matricula De ?         ','','','mv_ch3','C',06,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?         ','','','mv_ch4','C',06,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De ?        ','','','mv_ch5','C',09,0,0,'G','             ','mv_par05','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?     ','','','mv_ch6','C',09,0,0,'G','NaoVazio     ','mv_par06','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'07','Situacoes  	?','','','mv_ch7','C',05,0,0,'G','fSituacao  ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'08','Categorias     	?','','','mv_ch8','C',15,0,0,'G','fCategoria ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'09','Verba De  ?          ','','','mv_ch9','C',03,0,0,'G','             ','mv_par09','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRV','' })
aAdd(aRegs,{ cPerg,'10','Verba Ate  ?         ','','','mv_cha','C',03,0,0,'G','NaoVazio     ','mv_par10','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRV','' })
Aadd(aRegs,{ cPerg,'11','Imprimir ?         ','','','mv_chb','N',01,0,1,'C','			  ','mv_par11','Diferen็as','Diferen็as','Diferen็as','','','Todos','Todos','Todos','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
aAdd(aRegs,{ cPerg,'12','Roteiros  ?           ','','','mv_chc','C',30,0,0,'G','fRoteiro(,,)    ','mv_par12','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'','' })
aAdd(aRegs,{ cPerg,'13','Periodo Atual  ?          ','','','mv_chd','C',06,0,0,'G','NaoVazio     ','mv_par13','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'RCH','' })
aAdd(aRegs,{ cPerg,'14','Periodo Anterior?        ','','','mv_che','C',06,0,0,'G','NaoVazio     ','mv_par14','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'RCH','' })

dbSelectArea("SX1")

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
	
Next

RestArea(a_Area)


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FSQLIN   บAutor  ณ Marco Antonio Silvaบ Data ณ  04/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Montar a Selecao da Clausula IN do SQL.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSqlIN( cTexto, nStep )

Local cRet := ""
Local i

cTexto := Rtrim( cTexto )

If Len( cTexto ) > 0
	For i := 1 To Len( cTexto ) Step nStep
		cRet += "'" + SubStr( cTexto, i, nStep ) + "'"
		
		If i + nStep <= Len( cTexto )
			cRet += ","
		EndIf
	Next
EndIf

Return( cRet )