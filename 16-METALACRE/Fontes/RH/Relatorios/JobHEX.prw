#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

#DEFINE HEX_MATR	001	
#DEFINE HEX_NOME	002	
#DEFINE HEX_NDPT	003	
#DEFINE HEX_CCUS	004
#DEFINE HEX_500H	005	
#DEFINE HEX_500V	006	
#DEFINE HEX_600H	007	
#DEFINE HEX_600V	008	
#DEFINE HEX_100H	009	
#DEFINE HEX_100V	010	
#DEFINE HEX_INTH	011	
#DEFINE HEX_INTV	012	
#DEFINE HEX_ADNH	013
#DEFINE HEX_ADNV	014	
#DEFINE HEX_DSRV	015
#DEFINE HEX_ENCV	016	
#DEFINE HEX_ACUV	017	
#DEFINE HEX_SALA	018	
#DEFINE HEX_DATA	019

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ JobHEX   ∫Autor  ≥ Luiz Alberto       ∫ Data ≥  Ago/18     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Job Horas Extras               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function JobHEX()
Local aEmpresa := {{'01','01'}}

For nI := 1 To Len(aEmpresa)
	If Select("SX2") <> 0
		Processa( {|| RunProc() } )			
    Else
		RpcSetType( 3 )
		RpcSetEnv( aEmpresa[nI,1], aEmpresa[nI,2] )
	
		Processa( {|| RunProc() } )			
	
		RpcClearEnv()
	Endif
Next
Return
   	 
Static Function RunProc()
Local aArea := GetArea()

ConOut(OemToAnsi("Inicio Job Horas Extras " + Dtoc(date()) +" - " + Time()))
	
cEmailTo := GetNewPar("MV_XHEX","glaucia.financeiro@mssamazonia.com.br;fabiana.financeiro@mssamazonia.com.br;deivis@mssamazonia.com.br;joao@mssamazonia.com.br" )
cEmailTo := 'lalberto@3lsystems.com.br'

cMesAtu:= Str(Year(Date()),4)+StrZero(Month(Date()),2)			//Str(Year(MonthSub(Date(),1)),4)+StrZero(Month(MonthSub(Date(),1)),2)
cMesAn1:= Str(Year(MonthSub(Date(),1)),4)+StrZero(Month(MonthSub(Date(),1)),2)
cMesAn2:= Str(Year(MonthSub(Date(),2)),4)+StrZero(Month(MonthSub(Date(),2)),2)

cTxtAnt:= MesExtenso(Date())+'/'+Str(Year(Date()),4)
cTxtAn1:= MesExtenso(MonthSub(Date(),1))+'/'+Str(Year(MonthSub(Date(),1)),4)
cTxtAn2:= MesExtenso(MonthSub(Date(),2))+'/'+Str(Year(MonthSub(Date(),2)),4)

// Periodo Atual

cQuery := " SELECT PO_DATAINI, PO_DATAFIM "
cQuery += " FROM "+RetSqlName("SPO")+" PO "
cQuery += " WHERE PO.PO_FILIAL = '" + xFilial("SPO") + "' AND PO.D_E_L_E_T_ = '' "
cQuery += " AND '" + DtoS(Date()) + "' BETWEEN PO.PO_DATAINI AND PO.PO_DATAFIM "
	
TCQUERY cQuery NEW ALIAS "DPER"   

TcSetField("DPER",'PO_DATAINI','D')
TcSetField("DPER",'PO_DATAFIM','D')
			
dPerAtualIni	:=	DPER->PO_DATAINI
dPerAtualFim	:=	DPER->PO_DATAFIM

DPER->(dbCloseArea())

// Periodo Anterior

dPerOld	:=	(dPerAtualIni - 1)

cQuery := " SELECT PO_DATAINI, PO_DATAFIM "
cQuery += " FROM "+RetSqlName("SPO")+" PO "
cQuery += " WHERE PO.PO_FILIAL = '" + xFilial("SPO") + "' AND PO.D_E_L_E_T_ = '' "
cQuery += " AND '" + DtoS(dPerOld) + "' BETWEEN PO.PO_DATAINI AND PO.PO_DATAFIM "
	
TCQUERY cQuery NEW ALIAS "DPER"   

TcSetField("DPER",'PO_DATAINI','D')
TcSetField("DPER",'PO_DATAFIM','D')
			
dPerAnterIni	:=	DPER->PO_DATAINI
dPerAnterFim	:=	DPER->PO_DATAFIM

DPER->(dbCloseArea())

// Titulo Atual

cTitAtual	:=	'Periodo: De ' + DtoC(dPerAtualIni) + ' Ate ' + DtoC(dPerAtualFim)
	
// Titulo Periodo Anterior
	
cTitAnter	:=	'Periodo: De ' + DtoC(dPerAnterIni) + ' Ate ' + DtoC(dPerAnterFim)

cTxtPer:= MesExtenso(dPerOld)+'/'+Str(Year(dPerOld),4)


cQuery :=" SELECT LEFT(SRD.RD_DATARQ,6) RD_DATPGT,  " +CRLF
cQuery +=" 		RA_MAT,  " +CRLF
cQuery +=" 		RA_NOME,   " +CRLF
cQuery +=" 		RA_DEPTO,  " +CRLF
cQuery +=" 		SQB.QB_DESCRIC,  " +CRLF
cQuery +=" 		(SELECT TOP 1 R3_VALOR FROM " + RetSqlName("SR3") + " SR3 WHERE R3_MAT = SRA.RA_MAT AND LEFT(R3_DATA,6) <= SRD.RD_DATARQ AND SR3.D_E_L_E_T_= '' ORDER BY R3_DATA DESC) SALARIO, " +CRLF
cQuery +=" 		RD_PD,                                                                                                                                                 " +CRLF
cQuery +=" 		RV_DESC,  " +CRLF
cQuery +=" 		RD_HORAS,  " +CRLF
cQuery +=" 		RD_VALOR, " +CRLF
cQuery +=" 		RA_SITFOLH,  "  +CRLF
cQuery +=" 		RA_CATFUNC,  " +CRLF
cQuery +=" 		RA_CC ,  " +CRLF
cQuery +=" 		RD_PROCES ,  " +CRLF
cQuery +=" 		RD_PERIODO ,  " +CRLF
cQuery +=" 		RD_ROTEIR ,  " +CRLF
cQuery +=" 		RD_SEMANA " +CRLF
cQuery +=" FROM " + RetSqlName("SRD") + " SRD, " + RetSqlName("SRA") + " SRA, " + RetSqlName("SRV") + " SRV, " + RetSqlName("SQB") + " SQB " +CRLF
cQuery +=" WHERE 	SRA.RA_MAT = SRD.RD_MAT AND  " +CRLF
cQuery +=" 		SRD.RD_PD = SRV.RV_COD AND  " +CRLF
cQuery +=" 		SRD.RD_PD IN('023','024','025','026','027') " +CRLF
cQuery +=" 		AND SQB.QB_DEPTO = SRA.RA_DEPTO " +CRLF
cQuery +=" 		AND LEFT(SRD.RD_DATARQ,6) IN('" + cMesAn1 + "','" + cMesAn2 + "') "  +CRLF
cQuery +=" 		AND SRD.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SRA.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SRV.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SQB.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SRA.RA_SITFOLH <> 'D' " +CRLF

cQuery +=" UNION ALL " +CRLF                       
     
cQuery +=" SELECT 	'ATUAL' RD_DATPGT,  " +CRLF
cQuery +=" 		RA_MAT,  " +CRLF
cQuery +=" 		RA_NOME,  " +CRLF
cQuery +=" 		RA_DEPTO,  " +CRLF
cQuery +=" 		SQB.QB_DESCRIC,  " +CRLF
cQuery +=" 		RA_SALARIO SALARIO, " +CRLF
cQuery +=" 		SP9.P9_CODFOL,  " +CRLF
cQuery +=" 		P9_DESC,  " +CRLF
cQuery +=" 		PC_QUANTC PC_HORAS,  " +CRLF
cQuery +=" 		0 PC_VALOR, " +CRLF
cQuery +=" 		RA_SITFOLH,  " +CRLF
cQuery +=" 		RA_CATFUNC,  " +CRLF
cQuery +=" 		RA_CC ,  " +CRLF
cQuery +=" 		PC_PROCES ,  " +CRLF
cQuery +=" 		PC_PERIODO ,  " +CRLF
cQuery +=" 		PC_ROTEIR ,  " +CRLF
cQuery +=" 		PC_SEMANA " +CRLF
cQuery +=" FROM " + RetSqlName("SPC") + " SPC, " + RetSqlName("SRA") + " SRA, " + RetSqlName("SP9") + " SP9, " + RetSqlName("SQB") + " SQB, " + RetSqlName("SPO") + " SPO " +CRLF
cQuery +=" WHERE 	SRA.RA_MAT = SPC.PC_MAT AND  " +CRLF
cQuery +=" 		SPC.PC_PD = SP9.P9_CODIGO AND  " +CRLF
cQuery +=" 		SP9.P9_CODFOL IN('023','024','025','026','027') " +CRLF
cQuery +=" 		AND SQB.QB_DEPTO = SRA.RA_DEPTO " +CRLF
cQuery +=" 		AND SPC.PC_DATA BETWEEN SPO.PO_DATAINI AND SPO.PO_DATAFIM " 
cQuery +="		AND SPO.D_E_L_E_T_ = '' AND '" + DtoS(Date()) + "'  BETWEEN PO_DATAINI AND PO_DATAFIM " //" + DtoS(Date()) + "
cQuery +=" 		AND SPC.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SRA.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SP9.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SQB.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SRA.RA_SITFOLH <> 'D' " +CRLF

cQuery +=" UNION ALL " +CRLF

cQuery +=" SELECT 'ATUAL' RD_DATPGT,  " +CRLF
cQuery +=" 		RA_MAT,  " +CRLF
cQuery +=" 		RA_NOME,  " +CRLF
cQuery +=" 		RA_DEPTO,  " +CRLF
cQuery +=" 		SQB.QB_DESCRIC,  " +CRLF
cQuery +=" 		RA_SALARIO SALARIO, " +CRLF
cQuery +=" 		SP9.P9_CODFOL,  " +CRLF
cQuery +=" 		P9_DESC,  " +CRLF
cQuery +=" 		PH_QUANTC PH_HORAS,  " +CRLF
cQuery +=" 		0 PH_VALOR, " +CRLF
cQuery +=" 		RA_SITFOLH,  " +CRLF
cQuery +=" 		RA_CATFUNC,  " +CRLF
cQuery +=" 		RA_CC ,  " +CRLF
cQuery +=" 		PH_PROCES ,  " +CRLF
cQuery +=" 		PH_PERIODO ,  " +CRLF
cQuery +=" 		PH_ROTEIR ,  " +CRLF
cQuery +=" 		PH_SEMANA " +CRLF
cQuery +=" FROM " + RetSqlName("SPH") + " SPH, " + RetSqlName("SRA") + " SRA, " + RetSqlName("SP9") + " SP9, " + RetSqlName("SQB") + " SQB, " + RetSqlName("SPO") + " SPO " +CRLF
cQuery +=" WHERE 	SRA.RA_MAT = SPH.PH_MAT AND  " +CRLF
cQuery +=" 		SPH.PH_PD = SP9.P9_CODIGO AND  " +CRLF
cQuery +=" 		SP9.P9_CODFOL IN('023','024','025','026','027') " +CRLF
cQuery +=" 		AND SQB.QB_DEPTO = SRA.RA_DEPTO " +CRLF
cQuery +=" 		AND SPH.PH_DATA BETWEEN SPO.PO_DATAINI AND SPO.PO_DATAFIM " 
cQuery +="		AND SPO.D_E_L_E_T_ = '' AND '" + DtoS(Date()) + "'  BETWEEN PO_DATAINI AND PO_DATAFIM " //" + DtoS(Date()) + "
cQuery +=" 		AND SPH.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SRA.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SP9.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SQB.D_E_L_E_T_ = '' " +CRLF
cQuery +=" 		AND SRA.RA_SITFOLH <> 'D' " +CRLF

If !Empty(dPerOld)
	cQuery +=" UNION ALL" +CRLF                       

	cQuery +=" SELECT 'PEROLD' RD_DATPGT,  " +CRLF
	cQuery +=" 		RA_MAT,  " +CRLF
	cQuery +=" 		RA_NOME,  " +CRLF
	cQuery +=" 		RA_DEPTO,  " +CRLF
	cQuery +=" 		SQB.QB_DESCRIC,  " +CRLF
	cQuery +=" 		RA_SALARIO SALARIO, " +CRLF
	cQuery +=" 		SP9.P9_CODFOL,  " +CRLF
	cQuery +=" 		P9_DESC,  " +CRLF
	cQuery +=" 		PC_QUANTC PC_HORAS,  " +CRLF
	cQuery +=" 		0 PC_VALOR, " +CRLF
	cQuery +=" 		RA_SITFOLH,  " +CRLF
	cQuery +=" 		RA_CATFUNC,  " +CRLF
	cQuery +=" 		RA_CC ,  " +CRLF
	cQuery +=" 		PC_PROCES ,  " +CRLF
	cQuery +=" 		PC_PERIODO ,  " +CRLF
	cQuery +=" 		PC_ROTEIR ,  " +CRLF
	cQuery +=" 		PC_SEMANA " +CRLF
	cQuery +=" FROM " + RetSqlName("SPC") + " SPC, " + RetSqlName("SRA") + " SRA, " + RetSqlName("SP9") + " SP9, " + RetSqlName("SQB") + " SQB, " + RetSqlName("SPO") + " SPO " +CRLF
	cQuery +=" WHERE 	SRA.RA_MAT = SPC.PC_MAT AND  " +CRLF
	cQuery +=" 		SPC.PC_PD = SP9.P9_CODIGO AND  " +CRLF
	cQuery +=" 		SP9.P9_CODFOL IN('023','024','025','026','027') " +CRLF
	cQuery +=" 		AND SQB.QB_DEPTO = SRA.RA_DEPTO " +CRLF
	cQuery +=" 		AND SPC.PC_DATA BETWEEN SPO.PO_DATAINI AND SPO.PO_DATAFIM " 
	cQuery +="		AND SPO.D_E_L_E_T_ = '' AND '" + DtoS(dPerOld) + "'  BETWEEN PO_DATAINI AND PO_DATAFIM " //" + DtoS(Date()) + "
	cQuery +=" 		AND SPC.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SRA.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SP9.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SQB.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SRA.RA_SITFOLH <> 'D' " +CRLF
	
	cQuery +=" UNION ALL " +CRLF
	
	cQuery +=" SELECT 'PEROLD' RD_DATPGT,  " +CRLF
	cQuery +=" 		RA_MAT,  " +CRLF
	cQuery +=" 		RA_NOME,  " +CRLF
	cQuery +=" 		RA_DEPTO,  " +CRLF
	cQuery +=" 		SQB.QB_DESCRIC,  " +CRLF
	cQuery +=" 		RA_SALARIO SALARIO, " +CRLF
	cQuery +=" 		SP9.P9_CODFOL,  " +CRLF
	cQuery +=" 		P9_DESC,  " +CRLF
	cQuery +=" 		PH_QUANTC PH_HORAS,  " +CRLF
	cQuery +=" 		0 PH_VALOR, " +CRLF
	cQuery +=" 		RA_SITFOLH,  " +CRLF
	cQuery +=" 		RA_CATFUNC,  " +CRLF
	cQuery +=" 		RA_CC ,  " +CRLF
	cQuery +=" 		PH_PROCES ,  " +CRLF
	cQuery +=" 		PH_PERIODO ,  " +CRLF
	cQuery +=" 		PH_ROTEIR ,  " +CRLF
	cQuery +=" 		PH_SEMANA " +CRLF
	cQuery +=" FROM " + RetSqlName("SPH") + " SPH, " + RetSqlName("SRA") + " SRA, " + RetSqlName("SP9") + " SP9, " + RetSqlName("SQB") + " SQB, " + RetSqlName("SPO") + " SPO " +CRLF
	cQuery +=" WHERE 	SRA.RA_MAT = SPH.PH_MAT AND  " +CRLF
	cQuery +=" 		SPH.PH_PD = SP9.P9_CODIGO AND  " +CRLF
	cQuery +=" 		SP9.P9_CODFOL IN('023','024','025','026','027') " +CRLF
	cQuery +=" 		AND SQB.QB_DEPTO = SRA.RA_DEPTO " +CRLF
	cQuery +=" 		AND SPH.PH_DATA BETWEEN SPO.PO_DATAINI AND SPO.PO_DATAFIM " 
	cQuery +="		AND SPO.D_E_L_E_T_ = '' AND '" + DtoS(dPerOld) + "'  BETWEEN PO_DATAINI AND PO_DATAFIM " //" + DtoS(Date()) + "
	cQuery +=" 		AND SPH.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SRA.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SP9.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SQB.D_E_L_E_T_ = '' " +CRLF
	cQuery +=" 		AND SRA.RA_SITFOLH <> 'D' " +CRLF
Endif
cQuery +=" ORDER BY RD_DATPGT, RA_MAT " +CRLF

cQuery := ChangeQuery(cQuery) 	// otimiza a query de acordo c/ o banco 	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CHKV",.T.,.T.)

aHExtra	:= {}

dbSelectArea("CHKV")
Count To nReg
dbGoTop()
ProcRegua(nReg)
While CHKV->(!Eof())
	IncProc("Aguarde Processando os Dados")

	SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+CHKV->RA_MAT))
	
	nAchou := Ascan(aHExtra,{|X| X[1]==CHKV->RA_MAT .And. x[19]==CHKV->RD_DATPGT })
	
	If Empty(nAchou)
		AAdd(aHExtra,{	CHKV->RA_MAT,;
						CHKV->RA_NOME,;
						CHKV->QB_DESCRIC,;
						CHKV->RA_CC,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						Iif(Empty(CHKV->SALARIO),SRA->RA_SALARIO,CHKV->SALARIO),;
						CHKV->RD_DATPGT})
		
		nAchou := Len(aHExtra)
						
	Endif                     
	
	If CHKV->RD_PD == '023'
		aHExtra[nAchou,HEX_ADNH] += CHKV->RD_HORAS
		aHExtra[nAchou,HEX_ADNV] := Round(((((aHExtra[nAchou,HEX_SALA]/220)*35)/100) * aHExtra[nAchou,HEX_ADNH]),2)
	ElseIf CHKV->RD_PD == '024'
		aHExtra[nAchou,HEX_500H] += CHKV->RD_HORAS
		aHExtra[nAchou,HEX_500V] := Round(((aHExtra[nAchou,HEX_SALA]/220) * aHExtra[nAchou,HEX_500H])*1.5,2)
	ElseIf CHKV->RD_PD == '025'
		aHExtra[nAchou,HEX_600H] += CHKV->RD_HORAS
		aHExtra[nAchou,HEX_600V] := Round(((aHExtra[nAchou,HEX_SALA]/220) * aHExtra[nAchou,HEX_600H])*1.6,2)
	ElseIf CHKV->RD_PD == '026'
		aHExtra[nAchou,HEX_100H] += CHKV->RD_HORAS
		aHExtra[nAchou,HEX_100V] := Round(((aHExtra[nAchou,HEX_SALA]/220) * aHExtra[nAchou,HEX_100H])*2,2)
	ElseIf CHKV->RD_PD == '027'
		aHExtra[nAchou,HEX_INTH] += CHKV->RD_HORAS
		aHExtra[nAchou,HEX_INTV] := Round(((aHExtra[nAchou,HEX_SALA]/220) * aHExtra[nAchou,HEX_INTH])*1.5,2)
	Endif                                         
	
	aHExtra[nAchou,HEX_DSRV] := Round(((aHExtra[nAchou,HEX_ADNV]+aHExtra[nAchou,HEX_500V]+aHExtra[nAchou,HEX_600V]+aHExtra[nAchou,HEX_100V]+aHExtra[nAchou,HEX_INTV])/25)*5,2)
	aHExtra[nAchou,HEX_ENCV] := Round(((aHExtra[nAchou,HEX_ADNV]+aHExtra[nAchou,HEX_500V]+aHExtra[nAchou,HEX_600V]+aHExtra[nAchou,HEX_100V]+aHExtra[nAchou,HEX_INTV])*36.47)/100,2)
	aHExtra[nAchou,HEX_ACUV] := Round(aHExtra[nAchou,HEX_DSRV]+aHExtra[nAchou,HEX_ENCV]+aHExtra[nAchou,HEX_ADNV]+aHExtra[nAchou,HEX_500V]+aHExtra[nAchou,HEX_600V]+aHExtra[nAchou,HEX_100V]+aHExtra[nAchou,HEX_INTV],2)
	
	CHKV->(dbSkip(1))
Enddo
CHKV->(dbCloseArea())     

aSort(aHExtra  ,,, { |x,y| x[HEX_ACUV] > y[HEX_ACUV]} )      

cCabecalho := ''
cCabecalho += ' <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">' 
cCabecalho += ' <html> '
cCabecalho += ' <head> '
cCabecalho += '   <meta content="text/html; charset=ISO-8859-1" '
cCabecalho += '  http-equiv="content-type"> '
cCabecalho += '   <title>WorkFlow MetalSete</title> '
cCabecalho += ' </head> '
cCabecalho += ' <body> '
cCabecalho += ' <table '
cCabecalho += '  style="font-family: Helvetica,Arial,sans-serif; width: 100%; text-align: left; margin-left: auto; margin-right: 0px;" '
cCabecalho += '  border="1" cellpadding="2" cellspacing="2"> '
cCabecalho += '   <tbody> '
cCabecalho += '     <tr style="font-weight: bold;" align="center"> '
cCabecalho += '       <td colspan="17" rowspan="1"><big><big><img '
cCabecalho += '  style="width: 541px; height: 120px;" alt="" '
cCabecalho += '  src="http://www.metalsete.ind.br/home_4.png"><br> '
cCabecalho += '       </big></big></td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr style="font-weight: bold;" align="center"> '
cCabecalho += '       <td colspan="17" rowspan="1"><big><big>Relatorio '
cCabecalho += ' de Horas Extras - ' + cTitAtual +'</big></big></td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr style="font-weight: bold;" align="center"> '
cCabecalho += '       <td style="background-color: rgb(255, 255, 204);" '
cCabecalho += '  colspan="17" rowspan="1">Horas Extras</td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); text-align: center;"><span '
cCabecalho += '  style="font-weight: bold;">Matricula</span></td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Nome Funcionario</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Departamento</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Centro Custos</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Horas 50%</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Valor 50%</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Horas 60%</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Valor 60%</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Horas 100%</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Valor 100%</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Horas Inter</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Valor Inter</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Horas Ad.Not.</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Valor Ad.Not.</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">DSR</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Encargos</td> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;">Acumulado</td> '
cCabecalho += '  </tr> '

cRodape    := '      <tr> '
cRodape    += '      <td style="background-color: rgb(255, 255, 204);" '
cRodape    += ' colspan="17" rowspan="1"><small><small><span '
cRodape    += ' style="font-weight: bold;">Data Envio:</span> '
cRodape    += 'Hora Envio:&nbsp;</small></small></td> '
cRodape    += '    </tr> '
cRodape    += '  </tbody> '
cRodape    += '</table> '
cRodape    += '<br style="font-family: Helvetica,Arial,sans-serif;"> '
cRodape    += '</body>                                                 '
cRodape    += '</html> '

cNomRespo := UsrFullName(__cUserId)
cEmaRespo := UsrRetMail(__cUserId)

xCabecalho	:= cCabecalho
xRodape     := cRodape
xItens      := ''



xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(Date()))+'</span>'
xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'

aTotais := {0,0,0,0,0,0,0,0,0,0,0,0,0}
	
For nVenda := 1 To Len(aHExtra)     
    If AllTrim(aHExtra[nVenda,HEX_DATA]) == 'ATUAL'
		xItens  +=  '        <tr> '
		xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">'+aHExtra[nVenda,HEX_MATR]+'</span></td> '
		xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">'+aHExtra[nVenda,HEX_NOME]+'</span></td> '
		xItens  +=  '          <td style="text-align: left;">'+aHExtra[nVenda,HEX_NDPT]+'</td> '
		xItens  +=  '          <td style="text-align: left;">'+aHExtra[nVenda,HEX_CCUS]+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_500H],'@E 9,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_500V],'@E 999,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_600H],'@E 9,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_600V],'@E 999,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_100H],'@E 9,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_100V],'@E 999,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_INTH],'@E 9,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_INTV],'@E 999,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_ADNH],'@E 9,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_ADNV],'@E 999,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_DSRV],'@E 999,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_ENCV],'@E 999,999.99')+'</td> '
		xItens  +=  '          <td style="text-align: right;">'+TransForm(aHExtra[nVenda,HEX_ACUV],'@E 999,999.99')+'</td> '
		xItens  +=  '        </tr> '      
	
		aTotais[1]	+=	aHExtra[nVenda,HEX_500H]
		aTotais[2]	+=	aHExtra[nVenda,HEX_500V]
		aTotais[3]	+=	aHExtra[nVenda,HEX_600H]
		aTotais[4]	+=	aHExtra[nVenda,HEX_600V]
		aTotais[5]	+=	aHExtra[nVenda,HEX_100H]
		aTotais[6]	+=	aHExtra[nVenda,HEX_100V]
		aTotais[7]	+=	aHExtra[nVenda,HEX_INTH]
		aTotais[8]	+=	aHExtra[nVenda,HEX_INTV]
		aTotais[9]	+=	aHExtra[nVenda,HEX_ADNH]
		aTotais[10]	+=	aHExtra[nVenda,HEX_ADNV]
		aTotais[11]	+=	aHExtra[nVenda,HEX_DSRV]
		aTotais[12]	+=	aHExtra[nVenda,HEX_ENCV]
		aTotais[13]	+=	aHExtra[nVenda,HEX_ACUV]
	Endif
Next

xItens  +=  '        <tr> '
xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">Totais</span></td> '
xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;"></span></td> '
xItens  +=  '          <td style="text-align: left;"></td> '
xItens  +=  '          <td style="text-align: left;"></td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[1],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[2],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[3],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[4],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[5],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[6],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[7],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[8],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[9],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[10],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[11],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[12],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[13],'@E 999,999.99')+'</td> '
xItens  +=  '        </tr> '

If !Empty(dPerOld)
	// Tratamento 2 Meses Anteriores Busca Total
	
	aTotais := {0,0,0,0,0,0,0,0,0,0,0,0,0}
	
	For nVenda := 1 To Len(aHExtra)     
	    If aHExtra[nVenda,HEX_DATA] == 'PEROLD'
			aTotais[1]	+=	aHExtra[nVenda,HEX_500H]
			aTotais[2]	+=	aHExtra[nVenda,HEX_500V]
			aTotais[3]	+=	aHExtra[nVenda,HEX_600H]
			aTotais[4]	+=	aHExtra[nVenda,HEX_600V]
			aTotais[5]	+=	aHExtra[nVenda,HEX_100H]
			aTotais[6]	+=	aHExtra[nVenda,HEX_100V]
			aTotais[7]	+=	aHExtra[nVenda,HEX_INTH]
			aTotais[8]	+=	aHExtra[nVenda,HEX_INTV]
			aTotais[9]	+=	aHExtra[nVenda,HEX_ADNH]
			aTotais[10]	+=	aHExtra[nVenda,HEX_ADNV]
			aTotais[11]	+=	aHExtra[nVenda,HEX_DSRV]
			aTotais[12]	+=	aHExtra[nVenda,HEX_ENCV]
			aTotais[13]	+=	aHExtra[nVenda,HEX_ACUV]
		Endif
	Next
	
	xItens  +=  '        <tr> '
	xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">Total:</span></td> '
	xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">'+cTitAnter+'</span></td> '
	xItens  +=  '          <td style="text-align: left;"></td> '
	xItens  +=  '          <td style="text-align: left;"></td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[1],'@E 9,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[2],'@E 999,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[3],'@E 9,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[4],'@E 999,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[5],'@E 9,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[6],'@E 999,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[7],'@E 9,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[8],'@E 999,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[9],'@E 9,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[10],'@E 999,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[11],'@E 999,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[12],'@E 999,999.99')+'</td> '
	xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[13],'@E 999,999.99')+'</td> '
	xItens  +=  '        </tr> '
Endif

// Tratamento 2 Meses Anteriores Busca Total

aTotais := {0,0,0,0,0,0,0,0,0,0,0,0,0}

For nVenda := 1 To Len(aHExtra)     
    If aHExtra[nVenda,HEX_DATA] == cMesAn1
		aTotais[1]	+=	aHExtra[nVenda,HEX_500H]
		aTotais[2]	+=	aHExtra[nVenda,HEX_500V]
		aTotais[3]	+=	aHExtra[nVenda,HEX_600H]
		aTotais[4]	+=	aHExtra[nVenda,HEX_600V]
		aTotais[5]	+=	aHExtra[nVenda,HEX_100H]
		aTotais[6]	+=	aHExtra[nVenda,HEX_100V]
		aTotais[7]	+=	aHExtra[nVenda,HEX_INTH]
		aTotais[8]	+=	aHExtra[nVenda,HEX_INTV]
		aTotais[9]	+=	aHExtra[nVenda,HEX_ADNH]
		aTotais[10]	+=	aHExtra[nVenda,HEX_ADNV]
		aTotais[11]	+=	aHExtra[nVenda,HEX_DSRV]
		aTotais[12]	+=	aHExtra[nVenda,HEX_ENCV]
		aTotais[13]	+=	aHExtra[nVenda,HEX_ACUV]
	Endif
Next

xItens  +=  '        <tr> '
xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">Total Mes/Ano:</span></td> '
xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">'+cTxtAn1+'</span></td> '
xItens  +=  '          <td style="text-align: left;"></td> '
xItens  +=  '          <td style="text-align: left;"></td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[1],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[2],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[3],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[4],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[5],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[6],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[7],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[8],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[9],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[10],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[11],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[12],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[13],'@E 999,999.99')+'</td> '
xItens  +=  '        </tr> '

// 2 Meses Atras

aTotais := {0,0,0,0,0,0,0,0,0,0,0,0,0}

For nVenda := 1 To Len(aHExtra)     
    If aHExtra[nVenda,HEX_DATA] == cMesAn2
		aTotais[1]	+=	aHExtra[nVenda,HEX_500H]
		aTotais[2]	+=	aHExtra[nVenda,HEX_500V]
		aTotais[3]	+=	aHExtra[nVenda,HEX_600H]
		aTotais[4]	+=	aHExtra[nVenda,HEX_600V]
		aTotais[5]	+=	aHExtra[nVenda,HEX_100H]
		aTotais[6]	+=	aHExtra[nVenda,HEX_100V]
		aTotais[7]	+=	aHExtra[nVenda,HEX_INTH]
		aTotais[8]	+=	aHExtra[nVenda,HEX_INTV]
		aTotais[9]	+=	aHExtra[nVenda,HEX_ADNH]
		aTotais[10]	+=	aHExtra[nVenda,HEX_ADNV]
		aTotais[11]	+=	aHExtra[nVenda,HEX_DSRV]
		aTotais[12]	+=	aHExtra[nVenda,HEX_ENCV]
		aTotais[13]	+=	aHExtra[nVenda,HEX_ACUV]
	Endif
Next

xItens  +=  '        <tr> '
xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">Total Mes/Ano:</span></td> '
xItens  +=  '          <td style="text-align: left;"><span style="font-weight: bold;">'+cTxtAn2+'</span></td> '
xItens  +=  '          <td style="text-align: left;"></td> '
xItens  +=  '          <td style="text-align: left;"></td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[1],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[2],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[3],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[4],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[5],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[6],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[7],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[8],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[9],'@E 9,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[10],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[11],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[12],'@E 999,999.99')+'</td> '
xItens  +=  '          <td style="text-align: right;">'+TransForm(aTotais[13],'@E 999,999.99')+'</td> '
xItens  +=  '        </tr> '

      

WrkHextra(cNomRespo,cEmailTo,'CONTROLE HORA EXTRA ' + cTxtAnt,xCabecalho+xItens+xRodape)

RestArea(aArea)
Return


Static Function WrkHextra(cNomRespo,cEmaRespo,cAssunto,mCorpo,lContrato)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= cEmaRespo
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
DEFAULT lContrato := .f.

//cPara := 'lalberto@3lsystems.com.br;fernando.it@mssamazonia.com.br'

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense≥
	//≥que somente ela recebeu aquele email, tornando o email mais personalizado.   ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
	
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)	
		Else
			lRet := .T.	
	    Endif    
		
//				BCC			'glaucia.financeiro@mssamazonia.com.br';
		If lRet
			If !lContrato
				SEND MAIL FROM cFrom ;
				TO      	cPara;                  
				SUBJECT 	cAssunto;
				BODY    	mCorpo;
				RESULT lResult
			Else
				SEND MAIL FROM cFrom ;
				TO      	cPara;                  
				SUBJECT 	cAssunto;
				BODY    	mCorpo;
				RESULT lResult
			Endif	
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
					Conout('Erro no Envio do Email '+cError+ " " + cPara)	//AtenÁ„o
			Endif
	
		Else
			GET MAIL ERROR cError
			Conout('AutenticaÁ„o '+cError)  //"Autenticacao"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Conout('Erro no Envio do Email '+cError)      //Atencao
	Endif
Return .t.