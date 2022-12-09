#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | CSQRYPCO            | AUTOR | Gesse Santos |  DATA |30/05/2014  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Extracao do movimento PCO -                                     |//
//|           |                                                                 |//
//+-----------------------------------------------------------------------------+//
//| Especifico para CertiSign                                                   |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
//  -  translate(CT1_E06DSC,'âàãáÁÂÀÃéêÉÊíÍóôõÓÔÕüúÜÚÇç','aaaaAAAAeeEEiIoooOOOuuUUCc')
User Function CSQRYPCO()
local cPerg   := "CSQRYPCO04"
LOCAL aParamBox := {}
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
local cTitulo := "Extracao dados - Orcado x Realizado"
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "CSQRYPCO04"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
LOCAL dData	 := dDataBase
Local aAux          := {}
Local __cQry := ""
Local cTpMv := ""
Static aPergRet := {}

aadd(aParamBox,{6,"Pasta para Gravacao do CSV"      ,padr("",150),"",,"",90 ,.T.,"",alltrim("c:\"),GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
aAdd(aParamBox,{1,"Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aadd(aParamBox,{2,"Planilha"          ,1, {"   ","Despesas","Receitas"} , 50, '.T.', .T.})
aadd(aParamBox,{2,"Tipo Movimento"    ,1, {"   ","Orcado","Realizado"}  , 50, '.T.', .T.})


lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy,, cLoad, lCanSave, lUserSave)
if lRet
	cTpMv := ""
	if alltrim(mv_par05) $  "Orcado#Realizado"
		cTpMv := iif(alltrim(mv_par05)=="Realizado","R","O")
		if alltrim(mv_par04) $ "Despesas*Ambas"
			__cQry := ""
			__cQry := BuildQ("D",dtos(mv_par02),dtos(mv_par03),cTpMv)
			MsgRun("Orcado x Real - Selecionando movimentos de despesa..." ,,{|| procPCO(__cQry,"D") })
			//procPCO(__cQry,"D")
			alert("Planilha de despesas gerada corretamente!")
			
		endif
		if alltrim(mv_par04) $ "Receitas*Ambas"
			__cQry := ""
			__cQry := BuildQ("R",dtos(mv_par02),dtos(mv_par03),cTpMv)
			MsgRun("Orcado x Real - Selecionando movimentos de receita..." ,,{|| procPCO(__cQry,"R") })
			//procPCO(__cQry,"R")
			alert("Planilha de receitas gerada corretamente!")
			
		endif
	endif
endif

return()

//---------------------------------------------------------
static function procPCO(cQryAtu,cTp)
Local aStru    := {}
Local aColsTmp := {}
Local i
cQryAtu := ChangeQuery(cQryAtu)
If !Empty(Select("TRB"))
	dbSelectArea("TRB")
	dbCloseArea()
Endif
//TCQUERY cQryAtu New Alias "TRB"
//dbGoTop()
//dbUseArea ( [ lNew], [ cRdd], [ cArq], [ cAlias], [ lShare], [ lReadOnly] )
cQryAtu := ChangeQuery(cQryAtu)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryAtu),"TRB",.F.,.F.)
dbSelectArea("TRB")
aStru  := trb->(dbStruct())
For nX :=  1 To Len(aStru)
	If aStru[nX][2] == "N"
		TcSetField("TRB",aStru[nX][1],aStru[nX][2],17,2)
	EndIf
Next nX
TcSetField("TRB","DATALCT","C",10)

dbSelectArea("TRB")
dbGoTop()

__cPlan := "\dirdoc\Query_"+cTp+"_"+dtos(date()) +"_"+ substr(time(),1,2)+substr(time(),4,2)+".dbf"
copy to &__cPlan  VIA "DBFCDXADS"
dbSelectArea("TRB")
dbCloseArea()
dbUseArea(.T.,"DBFCDXADS",__cPlan,"TRB",.F.,.F.)
dbGoTop()

FillPco(cTp)

dbCloseArea()
cpys2t(__cPlan, alltrim(mv_par01), .T. )
sleep(5000)
ferase(__cPlan)
return()

//--------------------------------------
Static function BuildQ(cTipo,cDtIni,cDtFim,cModel)
Local __cQry := ""
if cTipo == "R"
	__cQry := ""
	if cModel == "O"
		__cQry := __cQry + " SELECT "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CV1_DTFIM AS DATALCT,"
		__cQry := __cQry + " CV1_ORCMTO AS LOTE,"
		__cQry := __cQry + " CV1_CT1FIM AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DESCCTA,     "
		__cQry := __cQry + " (CV1_VALOR)   AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CASE WHEN CV1_DESCIT = ' ' THEN CT1_DESC01 ELSE CV1_DESCIT END AS HIST,"
		__cQry := __cQry + " CV1_TIPOIT AS TPITEM,"
		__cQry := __cQry + " CV1_CTTFIM AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CV1_CTDFIM AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CV1_CTHFIM AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Orcado' AS CLAS,"
		__cQry := __cQry + " 'Receitas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, '00000' AS SEQUEN,"
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD, '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CV1010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CV1_CT1FIM = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CV1_CTTFIM = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CV1_CTDFIM = CTD_ITEM   AND CD.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CV1_CTHFIM = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " AND CV1_DTFIM BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND SUBSTR(CV1_CT1FIM,1,1) = '3'  ORDER BY DATALCT  "
	else
		__cQry := __cQry + " SELECT "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,  "
		__cQry := __cQry + " CT2_CREDIT AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " '                         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCC AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMC  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLCR AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Receitas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCC    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMC  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLCR = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01' AND CT1_CLASSE = '2' "
		__cQry := __cQry + " AND CT2_CREDIT IN ('310102001','310501001',
		__cQry := __cQry + " '310502001','310101001','310101005','310101905', "
		__cQry := __cQry + " '310101101','310101105','310101205','310101111','310101112', "
		__cQry := __cQry + " '310101115','310101201','310101114','310101201','310503001', "
		__cQry := __cQry + " '310101501','310101141','310101003','310101801','310101901')
		__cQry := __cQry + " UNION "
		__cQry := __cQry + " SELECT"
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,  "
		__cQry := __cQry + " CT2_DEBITO AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " ((CT2_VALOR) * -1 ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " '                         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCD AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Receitas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Debito' AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " AND CT2_DATA  BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01' AND CT1_CLASSE = '2' "
		__cQry := __cQry + " AND CT2_DEBITO IN ('310102001','310501001',
		__cQry := __cQry + " '310502001','310101001','310101005','310101905', "
		__cQry := __cQry + " '310101101','310101105','310101205','310101111','310101112', "
		__cQry := __cQry + " '310101115','310101201','310101114','310101201','310503001', "
		__cQry := __cQry + " '310101501','310101141','310101003','310101801','310101901')
		__cQry := __cQry + " ORDER BY DATALCT "
	endif
else
	__cQry := ""
	if cModel == "O"
		__cQry := __cQry + " SELECT "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CV1_DTFIM AS DATALCT,"
		__cQry := __cQry + " CV1_ORCMTO AS LOTE,"
		__cQry := __cQry + " CV1_CT1FIM AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CV1_VALOR)   AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CASE WHEN CV1_DESCIT = ' ' THEN CT1_DESC01 ELSE CV1_DESCIT END AS HIST,"
		__cQry := __cQry + " CV1_TIPOIT AS TPITEM,"
		__cQry := __cQry + " CV1_CTTFIM AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CV1_CTDFIM AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CV1_CTHFIM AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Orcado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, '00000' AS SEQUEN,"
		__cQry := __cQry + " 'Debito' AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD, '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CV1010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CV1_CT1FIM = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CV1_CTTFIM = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CV1_CTDFIM = CTD_ITEM   AND CD.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CV1_CTHFIM = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CV1_DTFIM BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND SUBSTR(CV1_CT1FIM,1,1) >= '4' ORDER BY DATALCT  "
	else
		__cQry := __cQry + " SELECT  "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,      "
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_DEBITO AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCD AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Debito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01' "
		__cQry := __cQry + " AND CT2_CCD NOT IN ('010110A','070103B','040202B','80000000') "
		__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) >= '4' "
		__cQry := __cQry + " UNION"
		__cQry := __cQry + " SELECT"
		__cQry := __cQry + " '000000'  AS ATIVIDADE,"
		__cQry := __cQry + " 'BOARD'   AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_DEBITO AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,     "
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,      "
		__cQry := __cQry + " CT2_CCD AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,     "
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,      "
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Debito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV     "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'     "
		__cQry := __cQry + " AND CT2_CCD = '010110A'   "
		__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) >= '4'  "
		__cQry := __cQry + " UNION      "
		__cQry := __cQry + " SELECT     "
		__cQry := __cQry + " 'D00006'  AS ATIVIDADE,"
		__cQry := __cQry + " 'MARKETING'  AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,    "
		__cQry := __cQry + " CT2_DEBITO AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,     "
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,      "
		__cQry := __cQry + " CT2_CCD AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,     "
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,      "
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,     "
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Debito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV  "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '   "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '   "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '   "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '   "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'     "
		__cQry := __cQry + " AND CT2_CCD = '070103B'  AND CT1_ENT06 <> 'D00001' "
		__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) >= '4' "
		__cQry := __cQry + " UNION  "
		__cQry := __cQry + " SELECT "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_DEBITO AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCD AS CCUSTO,  "
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Debito' AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'     "
		__cQry := __cQry + " AND CT2_CCD = '070103B'  AND CT1_ENT06 = 'D00001' "
		__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) >= '4'  "
		__cQry := __cQry + " UNION      "
		__cQry := __cQry + " SELECT     "
		__cQry := __cQry + " 'D00011'  AS ATIVIDADE,"
		__cQry := __cQry + " 'PROJETO MEIO DE PAGAMENTO'  AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_DEBITO AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCD AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC,  CT2_SEQUEN AS SEQUEN,      "
		__cQry := __cQry + " 'Debito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '  "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '  "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '  "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '  "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'    "
		__cQry := __cQry + " AND CT2_CCD = '040202B' AND CT2_DEBITO = '420111017'"
		__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) >= '4'"
		__cQry := __cQry + " UNION "
		__cQry := __cQry + " SELECT "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_DEBITO AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCD AS CCUSTO,  "
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,  "
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Debito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV  "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'    "
		__cQry := __cQry + " AND CT2_CCD = '040202B' AND CT2_DEBITO <> '420111017'"
		__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) >= '4'  "
		__cQry := __cQry + " UNION "
		__cQry := __cQry + " SELECT  "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_CREDIT AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " ((CT2_VALOR) * -1 ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCC AS CCUSTO,  "
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMC  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLCR AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,  "
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,    "
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV  "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCC    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMC  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLCR = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'    "
		__cQry := __cQry + " AND CT2_CCC NOT IN ('010110A','070103B','040202B') "
		__cQry := __cQry + " AND SUBSTR(CT2_CREDIT,1,1) >= '4'  "
		__cQry := __cQry + " UNION "
		__cQry := __cQry + " SELECT  "
		__cQry := __cQry + " '000000'  AS ATIVIDADE,"
		__cQry := __cQry + " 'BOARD'   AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_CREDIT AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " ((CT2_VALOR) * -1 ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCC AS CCUSTO,  "
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMC  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLCR AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,  "
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV"
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCC    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMC  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLCR = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01' "
		__cQry := __cQry + " AND CT2_CCC = '010110A'  "
		__cQry := __cQry + " AND SUBSTR(CT2_CREDIT,1,1) >= '4' "
		__cQry := __cQry + " UNION     "
		__cQry := __cQry + " SELECT    "
		__cQry := __cQry + " 'D00006'  AS ATIVIDADE,"
		__cQry := __cQry + " 'MARKETING'  AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_CREDIT AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " ((CT2_VALOR) * -1 ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCC AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMC  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLCR AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCC    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMC  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLCR = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01' "
		__cQry := __cQry + " AND CT2_CCC = '070103B' AND CT1_ENT06 <> 'D00001'"
		__cQry := __cQry + " AND SUBSTR(CT2_CREDIT,1,1) >= '4' "
		__cQry := __cQry + " UNION     "
		__cQry := __cQry + " SELECT    "
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,"
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_CREDIT AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " ((CT2_VALOR) * -1 ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCC AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMC  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLCR AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV"
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCC    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMC  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLCR = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01' "
		__cQry := __cQry + " AND CT2_CCC = '070103B' AND CT1_ENT06 = 'D00001'"
		__cQry := __cQry + " AND SUBSTR(CT2_CREDIT,1,1) >= '4'"
		__cQry := __cQry + " UNION "
		__cQry := __cQry + " SELECT"
		__cQry := __cQry + " 'D00011'  AS ATIVIDADE,     "
		__cQry := __cQry + " 'PROJETO MEIO DE PAGAMENTO'  AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_CREDIT AS CONTA,"
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " ((CT2_VALOR) * -1 ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCC AS CCUSTO,"
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMC  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLCR AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,"
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV"
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCC    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMC  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLCR = CTH_CLVL   AND CH.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01' "
		__cQry := __cQry + " AND CT2_CCC = '040202B' AND CT2_CREDIT = '420111017'    "
		__cQry := __cQry + " AND SUBSTR(CT2_CREDIT,1,1) >= '4'"
		__cQry := __cQry + " UNION "
		__cQry := __cQry + " SELECT"
		__cQry := __cQry + " CT1_ENT06 AS ATIVIDADE,     "
		__cQry := __cQry + " CT1_E06DSC AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_CREDIT AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " ((CT2_VALOR) * -1 ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCC AS CCUSTO,  "
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMC  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLCR AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,  "
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Credito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV  "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCC    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMC  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLCR = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'    "
		__cQry := __cQry + " AND CT2_CCC = '040202B' AND CT2_CREDIT <> '420111017'"
		__cQry := __cQry + " AND SUBSTR(CT2_CREDIT,1,1) >= '4'  "
		__cQry := __cQry + " UNION "
		__cQry := __cQry + " SELECT  "
		__cQry := __cQry + " 'C00011'  AS ATIVIDADE,"
		__cQry := __cQry + " '(-) COMISSOES S/ VENDAS'   AS DESCRATV,"
		__cQry := __cQry + " CT2_DATA AS DATALCT,"
		__cQry := __cQry + " CT2_LOTE  AS LOTE,"
		__cQry := __cQry + " CT2_DEBITO AS CONTA,  "
		__cQry := __cQry + " CT1_DESC01 AS DCTA,"
		__cQry := __cQry + " (CT2_VALOR ) AS VALOR,"
		__cQry := __cQry + " '"+space(60)+"' AS FORNECE, '      ' AS CODIGO, '              ' AS CNPJ,"
		__cQry := __cQry + " CT2_HIST AS HIST,"
		__cQry := __cQry + " 'DESPESAS DA AREA         '  AS TPITEM,"
		__cQry := __cQry + " CT2_CCD AS CCUSTO,  "
		__cQry := __cQry + " CTT_DESC01 AS DESCCC,"
		__cQry := __cQry + " CT2_ITEMD  AS CRESULT,"
		__cQry := __cQry + " CTD_DESC01 AS DSCRES,"
		__cQry := __cQry + " CT2_CLVLDB AS PRJTO,"
		__cQry := __cQry + " CTH_DESC01 AS DPRJ,"
		__cQry := __cQry + " 'Realizado' AS CLAS,"
		__cQry := __cQry + " 'Despesas' AS MODELO,  "
		__cQry := __cQry + " CV.R_E_C_N_O_ AS REC, CT2_SEQUEN AS SEQUEN,"
		__cQry := __cQry + " 'Debito'  AS ORIGEM, '                        ' AS CPROD, '                         ' AS DPROD,  '      ' AS CCANAL, '                    ' AS DCANAL  "
		__cQry := __cQry + " FROM CT2010 CV  "
		__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTT010 CT ON CT2_CCD    = CTT_CUSTO  AND CT.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTD010 CD ON CT2_ITEMD  = CTD_ITEM   AND CD.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " LEFT JOIN CTH010 CH ON CT2_CLVLDB = CTH_CLVL   AND CH.D_E_L_E_T_ = ' '"
		__cQry := __cQry + " WHERE CV.D_E_L_E_T_ = ' ' "
		__cQry := __cQry + " AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		__cQry := __cQry + " AND CT2_MOEDLC = '01'    "
		__cQry := __cQry + " AND CT2_CCD = '80000000' "
		__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) >= '4' ORDER BY DATALCT "
	endif
endif
//memowrite("c:\intel\qry.txt",__cQry)

Return(__cQry)

//----------Preenche o tipo item-------------------------------------------
static function xTpItem()

if alltrim(trb->conta) $ "420104001*420107002*420104003*420105001*420104004*420108003*420109014*420109013*420109008"
	trb->tpitem   := "DESPESAS COMPARTILHADAS"
endif

if alltrim(trb->codigo) $ "FK*133950*127805*132785*116526*112143*113802*000166*TOPCLE*122948*133881*137859*000141*BRASTE*000162"
	trb->tpitem   := "DESPESAS COMPARTILHADAS"
endif

//MARIA MARLENE MATIAS CALIXTO
if alltrim(trb->conta) == "420104002" .and.	alltrim(trb->codigo) <> "112976"
	trb->tpitem   := "DESPESAS COMPARTILHADAS"
endif
return()

//----------Preenche dados com base na sequencia-------------------------------------------
static function xPrcSeq()
if !empty(trb->sequen)
	// somente para despesa
	ctk->(dbseek(xfilial("CTK") + trb->sequen ))
	do case
		case alltrim(ctk->ctk_tabori) $ "SE1*SE2*SE5"
			while !ctk->(eof()) .and. ctk->ctk_sequen == trb->sequen
				if val(ctk->ctk_recdes) == int(trb->rec)
					do case
						case alltrim(ctk->ctk_tabori) == "SE1"
							se1->(dbgoto(val(alltrim(ctk->ctk_recori))))
							trb->fornece := se1->e1_nomcli
							sa1->(dbseek(xfilial("SA1") + se1->e1_cliente + se1->e1_loja ))
							trb->codigo := se1->e1_cliente +"-"+ se1->e1_loja
							trb->cnpj   := sa1->a1_cgc
							xCanal(se1->e1_vend1)
							
						case alltrim(ctk->ctk_tabori) == "SE2"
							se2->(dbgoto(val(alltrim(ctk->ctk_recori))))
							trb->fornece := se2->e2_nomfor
							sa2->(dbseek(xfilial("SA2") + se2->e2_fornece + se2->e2_loja ))
							trb->codigo := se2->e2_fornece +"-"+ se2->e2_loja
							trb->cnpj   := sa2->a2_cgc
						case alltrim(ctk->ctk_tabori) == "SE5"
							se5->(dbgoto(val(alltrim(ctk->ctk_recori))))
							if empty(se5->e5_benef)
								trb->fornece := se5->e5_histor
							else
								trb->fornece := se5->e5_benef
							endif
					endcase
					exit
				endif
				ctk->(dbskip())
			end-while
		case alltrim(ctk->ctk_tabori) == "SF1"
			sf1->(dbgoto(val(alltrim(ctk->ctk_recori))))
			if sf1->f1_tipo $ "BD"
				sa1->(dbsetorder(1))
				sa1->(dbseek(xfilial("SA1") + sf1->f1_fornece+sf1->f1_loja ))
				trb->fornece := sa1->a1_nome
				trb->codigo := sa1->a1_cod +"-"+ sa1->a1_loja
				trb->cnpj   := sa1->a1_cgc
			else
				sa2->(dbsetorder(1))
				sa2->(dbseek(xfilial("SA2") + sf1->f1_fornece+sf1->f1_loja ))
				trb->fornece := sa2->a2_nome
				trb->codigo := sa2->a2_cod +"-"+ sa2->a2_loja
				trb->cnpj   := sa2->a2_cgc
			endif
		case alltrim(ctk->ctk_tabori) == "SF2"
			sf2->(dbgoto(val(alltrim(ctk->ctk_recori))))
			if sf2->f2_tipo $ "BD"
				sa2->(dbsetorder(1))
				sa2->(dbseek(xfilial("SA2") + sf2->f2_cliente+sf2->f2_loja ))
				trb->fornece := sa2->a2_nome
				trb->codigo := sa2->a2_cod +"-"+ sa2->a2_loja
				trb->cnpj   := sa2->a2_cgc
				if ctk->ctk_lp == "610"
					sd2->(dbsetorder(3))
					sd2->(dbseek(alltrim(ctk->ctk_key)))
					xSegto(alltrim(sd2->d2_cod))
				endif
			else
				sa1->(dbsetorder(1))
				sa1->(dbseek(xfilial("SA1") + sf2->f2_cliente+sf2->f2_loja ))
				trb->fornece := sa1->a1_nome
				trb->codigo := sa1->a1_cod +"-"+ sa1->a1_loja
				trb->cnpj   := sa1->a1_cgc
				xCanal(sf2->f2_vend1)
				if ctk->ctk_lp == "610"
					sd2->(dbsetorder(3))
					sd2->(dbseek(alltrim(ctk->ctk_key)))
					xSegto(alltrim(sd2->d2_cod))
				endif
			endif
		case alltrim(ctk->ctk_tabori) == "SN3"
			trb->fornece := "ATIVO IMOBILIZADO"
		case alltrim(ctk->ctk_tabori) == "SRZ"
			trb->fornece := "FOLHA"
		case alltrim(ctk->ctk_tabori) == "XX5"
			trb->fornece := "IMPORTACAO TXT"
	endcase
	
else
	trb->fornece := "LANCAMENTO MANUAL"
endif
return()

//----------Preenche centro de custos -------------------------------------------
static function xPrcCC()
if !empty(trb->ccusto)
	// Aplica as demais exceções - Danielle - 30/06/2014
	// exceção por centro de custo
	__cListCC := ""
	__cListCC := __cListCC + "*70000008*70000009*70000011*70000012*70000014*70000015*70000016*70000020*70000021*"
	__cListCC := __cListCC + "*70000022*70000023*70000024*70000025*70000026*70000027*70000028*70000029*70000030*"
	__cListCC := __cListCC + "*70000031*70000032*70000033*70000034*70000035*70000036*70000037*70000038*70000039*"
	__cListCC := __cListCC + "*70000040*70000041*70000042*70000043*70000044*70000045*"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) CUSTO SYMANTEC RESELLER"
		trb->atividade := "C00003"
	endif
	__cListCC := ""
	__cListCC := __cListCC + "*50000000*70000018*70000019"
	__cListCC := __cListCC + "*70000046*70000047*70000048*70000049"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) CUSTO SYMANTEC SOFTWARE LICENSE"
		trb->atividade := "C00002"
	endif
	__cListCC := ""
	__cListCC := __cListCC + "*60000025*60000040"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) CUSTO WORKFLOW"
		trb->atividade := "C00004"
	endif
	__cListCC := ""
	__cListCC := __cListCC + "*30000076"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) CUSTO GED"
		trb->atividade := "C00009"
	endif
	__cListCC := ""
	__cListCC := __cListCC + "*30000001*90000000"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) OUTROS CUSTOS"
		trb->atividade := "C00012"
	endif
	__cListCC := ""
	__cListCC := __cListCC + "*90000002"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) OUTROS CUSTOS CORPORATIVO"
		trb->atividade := "C00012"
	endif
	__cListCC := ""
	__cListCC := __cListCC + "*90000001"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) OUTROS CUSTOS MARKETING"
		trb->atividade := "C00012"
	endif
	__cListCC := ""
	__cListCC := __cListCC + "*60000000"
	if alltrim(trb->ccusto) $ __cListCC
		trb->descratv  := "(-) CUSTO SDK"
		trb->atividade := "C00006"
	endif
endif

return()

//----------Preenche fornecedor -------------------------------------------
static function xPrcFor()
if !empty(trb->codigo)
	if substr(trb->codigo,1,6) $ "129070*130238"
		trb->descratv  := "ADMINISTRATIVAS"
		trb->atividade := "D00009"
	endif
	if substr(trb->codigo,1,6) $ "*114296"
		trb->descratv  := "PESSOAL"
		trb->atividade := "D00001"
	endif
endif

// Regra do JOAO
if alltrim(trb->conta) == "420110006" .and.  substr(trb->codigo,1,6) == "103692" .and. alltrim(trb->ccusto) == "061201B"
	trb->descratv  := "ADMINISTRATIVAS"
	trb->atividade := "D00009"
endif

//fim exceção por fornecedor
if !empty(trb->ccusto)
	// exceção fornecedor + centro custo
	if alltrim(trb->ccusto) == "060202B"
		if substr(trb->codigo,1,6) $ "*000016*125638*125639*100831"
			trb->descratv  := "DATA CENTER"
			trb->atividade := "D00006"
		endif
	endif
	if alltrim(trb->ccusto) == "060206B"
		if substr(trb->codigo,1,6) $ "*000047*127280"
			trb->descratv  := "SAC"
			trb->atividade := "D00007"
		endif
	endif
endif


return()

//----------Preenche a data -------------------------------------------
static function xPrcData()
trb->datalct := SUBSTR(trb->datalct,7,2)+"/"+SUBSTR(trb->datalct,5,2)+"/"+SUBSTR(trb->datalct,3,2)
return()



//----------Preencher dados adicionais -------------------------------------------
static function FillPco(__cDC)
local __cListCC := ""
local __nCount
ctk->(dbsetorder(1))
sa1->(dbsetorder(1))
sa2->(dbsetorder(1))
dbselectarea("TRB")
Count to __nCount
trb->(dbgotop())
while !trb->(eof())
	
	//MsgRun("Sequencia contabil... " + trb->sequen ,,{|| xPrcSeq() })
	xPrcSeq()
	//MsgRun("Centro Custos... " + trb->ccusto ,,{|| xPrcCC() })
	xPrcCC()
	//MsgRun("Fornecedor... " + trb->codigo ,,{|| xPrcFor() })
	xPrcFor()
	//MsgRun("Data... " + SUBSTR(trb->datalct,7,2)+"/"+SUBSTR(trb->datalct,5,2)+"/"+SUBSTR(trb->datalct,3,2) ,,{|| xPrcData() })
	xPrcData()         
	
	xTpItem()
	memowrite(alltrim(mv_par01)+"log_recno.txt",str(trb->(recno()))+" de "+ str(__nCount))
	trb->(dbskip())
end-while

return()

static function xSegto(__cPrd)
sb1->(dbseek(xfilial("SB1") + __cPrd ))
if !empty(sb1->b1_xseg)
	sz1->(dbseek(xfilial("SZ1") + sb1->b1_xseg, .t. ))
	trb->cprod := sb1->b1_xseg + sb1->b1_filial + sb1->b1_cod
	trb->dprod := upper(sz1->z1_descseg)
endif
return()

static function xCanal(__cVen)
sa3->(dbsetorder(1))
sz2->(dbsetorder(1))
if !empty(__cVen)
	sa3->(dbseek(xfilial("SA3") + __cVen ))
	sz2->(dbseek(xfilial("SZ2") + sa3->a3_xcanal, .t.))
	trb->ccanal := sz2->z2_ec08db
	trb->dcanal := upper(sz2->z2_canal)
endif
return()

user function xBldUpd()
local __cUpdate := ""
local __xComm
for __i := 1 to getmv("ZZ_RULE000")
	__nOrder := __i
	__xComm := 'getMv("ZZ_RULE' +alltrim(strzero(__nOrder,3))+ '")'
	alert(__xComm)
	__cUpdate := &(__xComm)
	alert(__cUpdate)
next __i
return(__cUpdate)

// Criacao da tabela
static function xMkSx2()
Local aArea := GetArea()
dbselectarea("SX2")
if !sx2->(dbseek("SZ0"))
	
endif
RestArea(aArea)
return()

// Criacao dos indices
static function xMkSix()
return()

// Criacao dos campos
static function xMkSx3()
return()

// prova de conceito - CT2 para AKD
user function CT2TOAKD()
local cPerg   := "CT2TOAKD01"
LOCAL aParamBox := {}
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
local cTitulo := "Extracao dados -gesse Realizado"
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "CT2TOAKD01"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
LOCAL dData	 := dDataBase
Local aAux          := {}
Local __cQry := ""
Local cTpMv := ""
local __nCount

Static aPergRet := {}


aAdd(aParamBox,{1,"Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data

lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy,, cLoad, lCanSave, lUserSave)
if lRet
	
	cDtIni := dtos(mv_par01)
	cDtFim := dtos(mv_par02)
	
	dbUseArea(.T.,"TOPCONN","AKDTMP","AKDTMP",.F.,.F.)
	
	//	__cQry := " INSERT INTO AKDTMP ( R_E_C_N_O, AKD_CC, AKD_CLVLR, AKD_ITCTB, AKD_ENT05,AKD_ENT06, AKD_ENT07, AKD_ENT08, AKD_ENT09, "
	//	__cQry := __cQry + " AKD_FILIAL, AKD_STATUS,AKD_LOTE,AKD_ID, AKD_DATA, AKD_CO, AKD_CLASSE, AKD_OPER, AKD_TIPO, AKD_TPSALD,AKD_HIST, "
	//	__cQry := __cQry + " AKD_PROCES, AKD_CHAVE, AKD_USER,AKD_COSUP, AKD_VALOR1, AKD_FILORI  ) "
	
	__cQry := __cQry + " SELECT  C2.R_E_C_N_O_ AS  R_E_C_N_O,  "
	__cQry := __cQry + " CT2_CCD      AS AKD_CC, "
	__cQry := __cQry + " CT2_ITEMD    AS AKD_ITCTB, "
	__cQry := __cQry + " CT2_CLVLDB   AS AKD_CLVLR,  "
	__cQry := __cQry + " '                         ' AS AKD_ENT05, "
	__cQry := __cQry + " CT1_ENT06                   AS AKD_ENT06, "
	__cQry := __cQry + " '                         ' AS AKD_ENT07, "
	__cQry := __cQry + " '                         ' AS AKD_ENT08, "
	__cQry := __cQry + " '                         ' AS AKD_ENT09, "
	__cQry := __cQry + " '02' AS AKD_FILIAL,  "
	__cQry := __cQry + " '1' AS AKD_STATUS,  "
	__cQry := __cQry + " SUBSTR(CT2_DOC,3,4)||CT2_LOTE AS AKD_LOTE,  "
	__cQry := __cQry + " '    ' AS AKD_ID, "
	__cQry := __cQry + " CT2_DATA AS AKD_DATA, "
	__cQry := __cQry + " CT2_DEBITO AS AKD_CO, "
	__cQry := __cQry + " SUBSTR(CT2_DEBITO,1,2) AS AKD_CLASSE, "
	__cQry := __cQry + " SUBSTR(CT2_DEBITO,1,4) AS AKD_OPER, "
	__cQry := __cQry + " CASE WHEN CT1_NORMAL = '1' THEN '2' ELSE '1' END AS AKD_TIPO, "
	__cQry := __cQry + " '1' AS AKD_TPSALD,  "
	__cQry := __cQry + " CT2_HIST AS AKD_HIST, "
	__cQry := __cQry + " '000000' AS AKD_PROCES, "
	__cQry := __cQry + " 'AKDAKD1020000'||CT2_LOTE||CT2_LINHA AS AKD_CHAVE,  "
	__cQry := __cQry + " '000000' AS AKD_USER,     "
	__cQry := __cQry + " SUBSTR(CT2_DEBITO,1,6) AS AKD_COSUP, "
	__cQry := __cQry + " CT2_VALOR AS AKD_VALOR1,    "
	__cQry := __cQry + " '02' AS AKD_FILORI     "
	__cQry := __cQry + " FROM CT2010 C2 "
	__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_DEBITO = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
	__cQry := __cQry + " WHERE  "
	__cQry := __cQry + " C2.D_E_L_E_T_ = ' ' AND  "
	__cQry := __cQry + " CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	__cQry := __cQry + " AND CT2_MOEDLC = '01'  "
	__cQry := __cQry + " AND CT2_TPSALD ='1'  "
	__cQry := __cQry + " AND CT2_DC IN ('1','3')  "
	__cQry := __cQry + " AND SUBSTR(CT2_DEBITO,1,1) > '2'   "
	__cQry := __cQry + " UNION   "
	__cQry := __cQry + " SELECT  C2.R_E_C_N_O_ AS  R_E_C_N_O, "
	__cQry := __cQry + " CT2_CCC      AS AKD_CC, "
	__cQry := __cQry + " CT2_ITEMC    AS AKD_ITCTB, "
	__cQry := __cQry + " CT2_CLVLCR   AS AKD_CLVLR,  "
	__cQry := __cQry + " '                         ' AS AKD_ENT05, "
	__cQry := __cQry + " CT1_ENT06                   AS AKD_ENT06, "
	__cQry := __cQry + " '                         ' AS AKD_ENT07, "
	__cQry := __cQry + " '                         ' AS AKD_ENT08, "
	__cQry := __cQry + " '                         ' AS AKD_ENT09, "
	__cQry := __cQry + " '02' AS AKD_FILIAL, "
	__cQry := __cQry + " '1' AS AKD_STATUS, "
	__cQry := __cQry + " SUBSTR(CT2_DOC,3,4)||CT2_LOTE AS AKD_LOTE,  "
	__cQry := __cQry + " '    ' AS AKD_ID, "
	__cQry := __cQry + " CT2_DATA AS AKD_DATA, "
	__cQry := __cQry + " CT2_CREDIT AS AKD_CO, "
	__cQry := __cQry + " SUBSTR(CT2_CREDIT,1,2) AS AKD_CLASSE, "
	__cQry := __cQry + " SUBSTR(CT2_CREDIT,1,4) AS AKD_OPER, "
	__cQry := __cQry + " CASE WHEN CT1_NORMAL = '1' THEN '2' ELSE '1' END AS AKD_TIPO, "
	__cQry := __cQry + " '1' AS AKD_TPSALD, "
	__cQry := __cQry + " CT2_HIST AS AKD_HIST, "
	__cQry := __cQry + " '000000' AS AKD_PROCES, "
	__cQry := __cQry + " 'AKDAKD1020000'||CT2_LOTE||CT2_LINHA AS AKD_CHAVE, "
	__cQry := __cQry + " '000000' AS AKD_USER, "
	__cQry := __cQry + " SUBSTR(CT2_CREDIT,1,6) AS AKD_COSUP, "
	__cQry := __cQry + " CT2_VALOR AS AKD_VALOR1,  "
	__cQry := __cQry + " '02' AS AKD_FILORI  "
	__cQry := __cQry + " FROM CT2010 C2 "
	__cQry := __cQry + " LEFT JOIN CT1010 C1 ON CT2_CREDIT = CT1_CONTA  AND C1.D_E_L_E_T_ = ' ' "
	__cQry := __cQry + " WHERE "
	__cQry := __cQry + " C2.D_E_L_E_T_ = ' ' AND  "
	__cQry := __cQry + " CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	__cQry := __cQry + " AND CT2_MOEDLC = '01' "
	__cQry := __cQry + " AND CT2_TPSALD ='1' "
	__cQry := __cQry + " AND CT2_DC IN ('2','3') "
	__cQry := __cQry + " AND SUBSTR(CT2_CREDIT,1,1) > '2' "
	
	memowrite("c:\pco\qry_tmp.txt",__cQry)
	alert("delete")
	TcSqlExec("DELETE FROM AKDTMP")
	alert("inicio")
	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,__cQry),"TRB",.F.,.F.)
	dbSelectArea("TRB")
	aStru  := trb->(dbStruct())
	For nX :=  1 To Len(aStru)
		If aStru[nX][2] == "N"
			TcSetField("TRB",aStru[nX][1],aStru[nX][2],17,2)
		EndIf
	Next nX
	
	dbSelectArea("TRB")
	count to __nCount
	
	dbGoTop()
	xComm := ""
	alert(time())
	cv3->(dbsetorder(2))
	__nSeqId := 1
	while !trb->(eof())
		dbselectarea("AKDTMP")
		RecLock("AKDTMP",.t.)
		for ii := 1 to len(aStru)
			/*
			__cRec := substr(alltrim(str(trb->r_e_c_n_o))+space(17),1,17)
			__nRec := 0
			__cFornece := ""
			__cConta := ""
			if cv3->(dbseek(xfilial("CV3") + __cRec  ))
			if !empty(cv3->cv3_tabori)
			do case
			case alltrim(cv3->cv3_tabori)  == "SF2"
			sf2->(dbgoto(val(cv3->cv3_recori)))
			if sf2->f2_tipo $ "BD"
			__cFornece := sf2->f2_cliente
			endif
			case alltrim(cv3->cv3_tabori)  == "SF1"
			sf1->(dbgoto(val(cv3->cv3_recori)))
			if !sf1->f1_tipo $ "BD"
			__cFornece := sf1->f1_fornece
			endif
			case alltrim(cv3->cv3_tabori)  == "SE2"
			se2->(dbgoto(val(cv3->cv3_recori)))
			__cFornece := se2->e2_fornece
			endcase
			endif
			endif
			*/
			if !alltrim(astru[ii][1]) $ "AKD_DATA*AKD_ID"
				xComm := "akdtmp->"+alltrim(astru[ii][1]) + " := trb-> " +alltrim(astru[ii][1])
				&(xComm)
			else
				do case
					case alltrim(astru[ii][1]) == "AKD_DATA"
						akdtmp->akd_data := stod(trb->akd_data)
					case alltrim(astru[ii][1]) == "AKD_ID"
						akdtmp->akd_id := strzero( (__nSeqId % 9999),4)
						/*
						case alltrim(astru[ii][1]) == "AKD_ENT06"
						if empty(__cFornece)
						xComm := "akdtmp->"+alltrim(astru[ii][1]) + " := trb-> " +alltrim(astru[ii][1])
						&(xComm)
						else
						__cConta := &("trb->"+alltrim(astru[ii][1]))
						
						endif
						*/
				endcase
			endif
		next ii
		__nSeqId++
		memowrite("c:\pco\log_recno.txt",str(trb->(recno()))+" de "+ str(__nCount))
		trb->(dbskip())
	end-while
	// BOARD 
	alert(time())
	TcSqlExec(" UPDATE AKDTMP SET AKD_ENT06 = '000000' WHERE AKD_CC = '010110A' ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'D00006' WHERE AKD_CC = '070103B' AND  AKD_ENT06 = 'D00001' ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'D00011' WHERE AKD_CC = '040202B' AND  AKD_CO = '420111017' ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00011' WHERE AKD_CC = '80000000' ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00003' WHERE AKD_CC IN ('70000008','70000009','70000011','70000012','70000014','70000015','70000016','70000020','70000021') ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00003' WHERE AKD_CC IN ('70000022','70000023','70000024','70000025','70000026','70000027','70000028','70000029','70000030') ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00003' WHERE AKD_CC IN ('70000022','70000023','70000024','70000025','70000026','70000027','70000028','70000029','70000030') ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00003' WHERE AKD_CC IN ('70000031','70000032','70000033','70000034','70000035','70000036','70000037','70000038','70000039') ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00003' WHERE AKD_CC IN ('70000040','70000041','70000042','70000043','70000044','70000045') ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00002' WHERE AKD_CC IN ('50000000','70000018','70000019','70000046','70000047','70000048','70000049') ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00004' WHERE AKD_CC IN ('60000025','60000040') ")

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00009' WHERE AKD_CC IN ('30000076','__________') ") // ficou apenas um centro de custos

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00012' WHERE AKD_CC IN ('30000001','90000000') ") 

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00012' WHERE AKD_CC IN ('90000002','__________') ") // ficou apenas um centro de custos

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00012' WHERE AKD_CC IN ('90000001','__________') ") // ficou apenas um centro de custos

	TcSQLExec(" UPDATE AKDTMP SET AKD_ENT06 = 'C00006' WHERE AKD_CC IN ('60000000','__________') ") // ficou apenas um centro de custos

	alert(time())
endif
return()
