#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmRComp  | Autor: Celso Ferrone Martins  | Data: 19/09/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Danilo Busso         			   		| Data: 25/09/2015 |||
||+-----------+------------------------------------------------------------+||
||| Descricao | Alterado o Nome Fantasia para o Nome Reduzido do Fornecedor|||
|||			  | e adiconado o nome do produto                              |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmRComp()

Local oReport
Local cTitulo1 := "RELATORIO DE COMPRAS"
Local cTitulo2 := "RELATORIO DE COMPRAS"
Private cEof   := Chr(13) + Chr(10)

oReport := TReport():New("CFMRCOMP", cTitulo1, "CFMRCOMP", {|oReport| PrintReport(oReport)}, cTitulo2)
oReport:SetLandScape() //Retrato
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

PutSX1("CFMRCOMP","01","Emissao de       ","","","MV_CHA","D",08,0,0,"G",""                               ,""   ,"","","MV_PAR01",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","02","Emissao ate      ","","","MV_CHB","D",08,0,0,"G",""                               ,""   ,"","","MV_PAR02",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","03","Fornecedor de    ","","","MV_CHC","C",06,0,0,"G",   "Vazio() .Or. ExistCpo('SA2')","SA2","","","MV_PAR03",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","04","Fornecedor ate   ","","","MV_CHD","C",06,0,0,"G","NaoVazio() .Or. ExistCpo('SA2')","SA2","","","MV_PAR04",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","05","Grupo Produto de ","","","MV_CHE","C",05,0,0,"G",   "Vazio() .Or. ExistCpo('SBM')","SBM","","","MV_PAR05",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","06","Grupo Produto ate","","","MV_CHF","C",05,0,0,"G","NaoVazio() .Or. ExistCpo('SBM')","SBM","","","MV_PAR06",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","07","Produto de       ","","","MV_CHE","C",15,0,0,"G",   "Vazio() .Or. ExistCpo('SB1')","SB1","","","MV_PAR07",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","08","Produto ate      ","","","MV_CHF","C",15,0,0,"G","NaoVazio() .Or. ExistCpo('SB1')","SB1","","","MV_PAR08",""          ,"","","",""       ,"","","","" ,"","","","","","","","","","")
PutSX1("CFMRCOMP","09","Tipo de Relatorio","","","MV_CHG","N",01,0,0,"C",""                               ,""   ,"","","MV_PAR09","Fornecedor","","","","Produto","","","","" ,"","","","","","","","","","")

Pergunte(oReport:uParam,.F.)

oReport:PrintDialog()

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+-----------------------+------------------------------+------------------+||
||| Programa: PrintReport | Autor: Celso Ferrone Martins | Data: 16/09/2015 |||
||+-----------+-----------+------------------------------+------------------+||
||| Descricao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function PrintReport(oReport)

Local oSection1
Local oSection2
Local cTitle2
Local cQuery := ""

oSection1 := TRSection():New(oReport,"GERAL",{"TMP"})
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"CABNOME"     ,,"Relatorio" , "@!"    , 100,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

If MV_PAR09 == 1 // PRODUTO
	cTitle2 := "Fornecedor"
Else
	cTitle2 := "Produto"
EndIf

oSection2 := TRSection():New(oReport,cTitle2,{"TMP"})
oSection2:SetTotalInLine(.F.)


TRCell():New(oSection2,"NOTA"      , , "NOTA"         , PesqPict("SF1","F1_DOC"    ) , TamSX3("F1_DOC"    )[1],,,)
TRCell():New(oSection2,"SERIE"     , , "SER"          , PesqPict("SF1","F1_SERIE"  ) , TamSX3("F1_SERIE"  )[1],,,)
TRCell():New(oSection2,"PEDIDO"    , , "PEDIDO"       , PesqPict("SC7","C7_NUM"    ) , TamSX3("C7_NUM"    )[1],,,)
TRCell():New(oSection2,"PREVISAO"  , , "PR.ENTREGA"   , PesqPict("SC7","C7_DATPRF" ) , TamSX3("C7_DATPRF" )[1],,,)
TRCell():New(oSection2,"ENTRADA"   , , "DT.ENTRADA"   , PesqPict("SF1","F1_DTDIGIT") , TamSX3("F1_DTDIGIT")[1],,,)
If MV_PAR09 == 1
	TRCell():New(oSection2,"MP_DESCRI" , , "PRODUTO"      , PesqPict("SB1","B1_DESC"   ) , TamSX3("B1_DESC"   )[1],,,)
	TRCell():New(oSection2,"EM_DESCRI" , , "EMBALAGEM"    , PesqPict("SB1","B1_DESC"   ) , TamSX3("B1_DESC"   )[1]-10,,,)
Else
	TRCell():New(oSection2,"FOR_NOME"  , , "FORNECEDOR"   , PesqPict("SA2","A2_NREDUZ"   ) , TamSX3("A2_NREDUZ"   )[1],,,)
EndIf
TRCell():New(oSection2,"PA_CODIGO"        , , "PRODUTO"     , PesqPict("SB1","B1_COD"     ) , TamSX3("B1_COD"     )[1],,,)
TRCell():New(oSection2,"UM"        , , "UM"           , PesqPict("SD1","D1_UM"     ) , TamSX3("D1_UM"     )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"QUANT"     , , "QTDE."        , PesqPict("SD1","D1_QUANT"  ) , TamSX3("D1_QUANT"  )[1],,,"RIGHT",,"RIGHT")
//TRCell():New(oSection2,"SEGUM"     , , "UM2"          , PesqPict("SD1","D1_SEGUM"  ) , TamSX3("D1_SEGUM"  )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"QTSEGUM"   , , "QTDE.2"       , PesqPict("SD1","D1_QTSEGUM") , TamSX3("D1_QTSEGUM")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VAL_UNIT"  , , "VL.UNIT.R$"   , PesqPict("SD1","D1_VUNIT"  ) , TamSX3("D1_VUNIT"  )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VAL_UNIT2" , , "VL.UNIT.Us$"  , PesqPict("SD1","D1_VUNIT"  ) , TamSX3("D1_VUNIT"  )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VAL_TOTAL" , , "TOTAL R$"     , PesqPict("SD1","D1_TOTAL"  ) , TamSX3("D1_TOTAL"  )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"PER_ICMS"  , , "%.ICMS"       , PesqPict("SD1","D1_PICM"   ) , TamSX3("D1_PICM"   )[1],,,"RIGHT",,"RIGHT")
//TRCell():New(oSection2,"VAL_ICMS"  , , "VL.ICMS"      , PesqPict("SD1","D1_VALICM" ) , TamSX3("D1_VALICM" )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VAL_IPI"   , , "VL.IPI"       , PesqPict("SD1","D1_VALIPI" ) , TamSX3("D1_VALIPI" )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"CONDICAO"  , , "COND.PGTO."   , PesqPict("SE4","E4_DESCRI" ) , TamSX3("E4_DESCRI" )[1],,,)
TRCell():New(oSection2,"TIPO_FRET" , , "FRETE"        , PesqPict("SF1","F1_TPFRETE") , TamSX3("F1_TPFRETE")[1],,,)

TRFunction():New(oSection2:Cell("QUANT"    ) ,"","SUM" ,,"Sub-Total",PesqPict("SD1","D1_QUANT"  )  ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("QTSEGUM"  ) ,"","SUM" ,,"Sub-Total",PesqPict("SD1","D1_QTSEGUM")  ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("VAL_TOTAL") ,"","SUM" ,,"Sub-Total",PesqPict("SD1","D1_TOTAL"  )  ,,.T.,.T.,.F.,oSection2)
//TRFunction():New(oSection2:Cell("VAL_ICMS" ) ,"","SUM" ,,"Sub-Total",PesqPict("SD1","D1_VALICM" )  ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("VAL_IPI"  ) ,"","SUM" ,,"Sub-Total",PesqPict("SD1","D1_VALIPI" )  ,,.T.,.T.,.F.,oSection2)

cQuery := " SELECT                                                                     " + cEof
cQuery += "   SF1.F1_DOC                          AS NOTA     ,                        " + cEof
cQuery += "   SF1.F1_SERIE                        AS SERIE    ,                        " + cEof
cQuery += "   SF1.F1_EMISSAO                      AS EMISSAO  ,                        " + cEof
cQuery += "   SA2.A2_COD                          AS FOR_COD  ,                        " + cEof
cQuery += "   SA2.A2_LOJA                         AS FOR_LOJA ,                        " + cEof
cQuery += "   SA2.A2_NREDUZ                       AS FOR_NOME ,                        " + cEof
cQuery += "   SC7.C7_NUM                          AS PEDIDO   ,                        " + cEof
cQuery += "   SC7.C7_DATPRF                       AS PREVISAO ,                        " + cEof
cQuery += "   SF1.F1_DTDIGIT                      AS ENTRADA  ,                        " + cEof
cQuery += "   SBM.BM_GRUPO AS MP_CODIGO,                        " + cEof
cQuery += "   SBM.BM_DESC  AS MP_DESCRI,                        " + cEof
cQuery += "   SB1.B1_COD                          AS PA_CODIGO,                        " + cEof
cQuery += "   SB1.B1_DESC                         AS PA_DESCRI,                        " + cEof
cQuery += "   SB1.B1_CONV                         AS PA_CONV  ,                        " + cEof
cQuery += "   COALESCE(SB1EM.B1_COD ,' ')         AS EM_CODIGO,                        " + cEof
cQuery += "   COALESCE(SB1EM.B1_DESC,' ')         AS EM_DESCRI,                        " + cEof
cQuery += "   SD1.D1_UM                           AS UM       ,                        " + cEof
cQuery += "   SD1.D1_SEGUM                        AS SEGUM    ,                        " + cEof
cQuery += "   SD1.D1_QUANT                        AS QUANT    ,                        " + cEof
cQuery += "   SD1.D1_QTSEGUM                      AS QTSEGUM  ,                        " + cEof
cQuery += "   SD1.D1_VUNIT                        AS VAL_UNIT ,                        " + cEof
cQuery += "   SD1.D1_TOTAL                        AS VAL_TOTAL,                        " + cEof
cQuery += "   SD1.D1_PICM                         AS PER_ICMS ,                        " + cEof
cQuery += "   SD1.D1_VALICM                       AS VAL_ICMS ,                        " + cEof
cQuery += "   SD1.D1_VALIPI                       AS VAL_IPI  ,                        " + cEof
cQuery += "   SE4.E4_DESCRI                       AS CONDICAO ,                        " + cEof
cQuery += "   COALESCE(SM2.M2_MOEDA2,1)           AS TX_MOEDA2,                        " + cEof
cQuery += "   SF1.F1_TPFRETE                      AS TIPO_FRET                         " + cEof
cQuery += " FROM "+RetSqlName("SF1")+" SF1                                             " + cEof
cQuery += "   INNER JOIN "+RetSqlName("SD1")+" SD1 ON                                  " + cEof
cQuery += "     SD1.D_E_L_E_T_ <> '*'                                                  " + cEof
cQuery += "     AND SD1.D1_FILIAL  = '"+xFilial("SD1")+"'                              " + cEof
cQuery += "     AND SD1.D1_DOC     = SF1.F1_DOC                                        " + cEof
cQuery += "     AND SD1.D1_SERIE   = SF1.F1_SERIE                                      " + cEof
cQuery += "     AND SD1.D1_FORNECE = SF1.F1_FORNECE                                    " + cEof
cQuery += "     AND SD1.D1_LOJA    = SF1.F1_LOJA                                       " + cEof
cQuery += "   LEFT JOIN "+RetSqlName("SC7")+" SC7 ON                                   " + cEof
cQuery += "     SC7.D_E_L_E_T_ <> '*'                                                  " + cEof
cQuery += "     AND SC7.C7_FILIAL  = '"+xFilial("SC7")+"'                              " + cEof
cQuery += "     AND SC7.C7_NUM     = SD1.D1_PEDIDO                                     " + cEof
cQuery += "     AND SC7.C7_ITEM    = SD1.D1_ITEMPC                                     " + cEof
cQuery += "   INNER JOIN "+RetSqlName("SB1")+" SB1 ON                                  " + cEof
cQuery += "     SB1.D_E_L_E_T_ <> '*'                                                  " + cEof
cQuery += "     AND SB1.B1_FILIAL  = '"+xFilial("SB1")+"'                              " + cEof
cQuery += "     AND SB1.B1_COD     = SD1.D1_COD                                        " + cEof
cQuery += "     AND SB1.B1_GRUPO   BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"'       " + cEof
cQuery += "     AND SB1.B1_COD     BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"'       " + cEof
cQuery += "   LEFT JOIN "+RetSqlName("SB1")+" SB1MP ON                                 " + cEof
cQuery += "     SB1MP.D_E_L_E_T_ <> '*'                                                " + cEof
cQuery += "     AND SB1MP.B1_FILIAL  = '"+xFilial("SB1")+"'                            " + cEof
cQuery += "     AND SB1MP.B1_COD     = SB1.B1_VQ_MP                                    " + cEof
cQuery += "   LEFT JOIN "+RetSqlName("SB1")+" SB1EM ON                                 " + cEof
cQuery += "     SB1EM.D_E_L_E_T_ <> '*'                                                " + cEof
cQuery += "     AND SB1EM.B1_FILIAL  = '"+xFilial("SB1")+"'                            " + cEof
cQuery += "     AND SB1EM.B1_COD     = SB1.B1_VQ_EM                                    " + cEof
cQuery += "   INNER JOIN "+RetSqlName("SA2")+" SA2 ON                                  " + cEof
cQuery += "     SA2.D_E_L_E_T_ <> '*'                                                  " + cEof
cQuery += "     AND SA2.A2_FILIAL  = '"+xFilial("SA2")+"'                              " + cEof
cQuery += "     AND SA2.A2_COD     = SF1.F1_FORNECE                                    " + cEof
cQuery += "     AND SA2.A2_LOJA    = SF1.F1_LOJA                                       " + cEof
cQuery += "   INNER JOIN "+RetSqlName("SF4")+" SF4 ON                                  " + cEof
cQuery += "     SF4.D_E_L_E_T_ <> '*'                                                  " + cEof
cQuery += "     AND SF4.F4_FILIAL  = '"+xFilial("SF4")+"'                              " + cEof
cQuery += "     AND SF4.F4_CODIGO  = SD1.D1_TES                                        " + cEof
//cQuery += "     AND SF4.F4_ESTOQUE = 'S'                                               " + cEof
cQuery += "   LEFT JOIN "+RetSqlName("SM2")+" SM2 ON                                   " + cEof
cQuery += "     SM2.D_E_L_E_T_ <> '*'                                                  " + cEof
cQuery += "     AND SM2.M2_DATA    = SF1.F1_EMISSAO                                    " + cEof
cQuery += "   INNER JOIN "+RetSqlName("SBM")+" SBM ON                                   " + cEof
cQuery += "     SBM.D_E_L_E_T_ <> '*'                                                   " + cEof
cQuery += "     AND SBM.BM_GRUPO    = SB1.B1_GRUPO	                                    " + cEof
cQuery += "   INNER JOIN "+RetSqlName("SE4")+" SE4 ON                                  " + cEof
cQuery += "     SE4.D_E_L_E_T_ <> '*'                                                  " + cEof
cQuery += "     AND SE4.E4_FILIAL  = '"+xFilial("SE4")+"'                              " + cEof
cQuery += "     AND SE4.E4_CODIGO  = SF1.F1_COND                                       " + cEof
cQuery += " WHERE                                                                      " + cEof
cQuery += "   SF1.D_E_L_E_T_ <> '*'                                                    " + cEof
cQuery += "   AND SF1.F1_FILIAL = '"+xFilial("SF1")+"'                                 " + cEof
cQuery += "   AND SF1.F1_DTDIGIT BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' " + cEof
cQuery += "   AND SF1.F1_FORNECE BETWEEN '"+     MV_PAR03 +"' AND '"+     MV_PAR04 +"' " + cEof
cQuery += "   AND SF1.F1_TIPO = 'N'                                                    " + cEof
If MV_PAR09 == 1
	cQuery += " ORDER BY SA2.A2_NOME, SA2.A2_COD, SA2.A2_LOJA, SF1.F1_DTDIGIT, SBM.BM_DESC  " + cEof
Else
	cQuery += " ORDER BY COALESCE(SB1MP.B1_DESC,SB1.B1_DESC), SF1.F1_DTDIGIT, SA2.A2_NOME, SA2.A2_COD, SA2.A2_LOJA  " + cEof
EndIf

cQuery := ChangeQuery(cQuery)

If Select("SF1TMP") > 0
	SF1TMP->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "SF1TMP"
	
nTotalReg := Contar("SF1TMP", "!Eof()")
SF1TMP->(DbGoTop())

oReport:SetMeter(nTotalReg)

cQuebra1 := ""
cNotaAnt := ""

While !SF1TMP->(Eof())

	If MV_PAR09 == 1 //Fornecedor
		cCondAtu := SF1TMP->(FOR_COD+FOR_LOJA)
	Else // Produto
		cCondAtu := SF1TMP->MP_DESCRI
	EndIf

	If cQuebra1 != cCondAtu
		
		If !Empty(cQuebra1)
			
			oSection1:Finish()
			oSection2:Finish()

			oReport:FatLine()
		EndIf

		oSection1:Init()
		oSection1:SetHeaderSection(.F.)
		
		oReport:FatLine()

		If MV_PAR09 == 1 // Fornecedor
			cQuebra1 := SF1TMP->(FOR_COD+FOR_LOJA)
			oSection1:Cell("CABNOME"):SetValue("Fornecedor: "+SF1TMP->(FOR_COD+FOR_LOJA)+": "+SF1TMP->FOR_NOME)
		Else             // Produto
			cQuebra1 := SF1TMP->MP_DESCRI
			oSection1:Cell("CABNOME"):SetValue("Produto: "+SF1TMP->MP_CODIGO+": "+SF1TMP->MP_DESCRI)
		EndIf

		oSection1:PrintLine()
		
		oSection2:Init()
		oSection2:SetHeaderSection(.T.)
	EndIf
	oSection2:Cell("NOTA"      ):SetValue(SF1TMP->NOTA)
	oSection2:Cell("SERIE"     ):SetValue(SF1TMP->SERIE)
	oSection2:Cell("PEDIDO"    ):SetValue(SF1TMP->PEDIDO)
	oSection2:Cell("PREVISAO"  ):SetValue(sTod(SF1TMP->PREVISAO))
	oSection2:Cell("ENTRADA"   ):SetValue(sTod(SF1TMP->ENTRADA))
	If MV_PAR09 == 1
		oSection2:Cell("MP_DESCRI" ):SetValue(SF1TMP->MP_DESCRI)
		cDescEm := ""
		If SubStr(SF1TMP->PA_CODIGO,1,2) == "01"
			cDescEm := SF1TMP->EM_DESCRI
		ElseIf SubStr(SF1TMP->PA_CODIGO,1,2) == "02"
			cDescEm := "GRANEL"
		ElseIf SubStr(SF1TMP->PA_CODIGO,1,2) == "03"
			cDescEm := SF1TMP->PA_DESCRI
		Else
			cDescEm := SF1TMP->PA_DESCRI
		EndIf
		oSection2:Cell("EM_DESCRI" ):SetValue(cDescEm)
	Else
		oSection2:Cell("FOR_NOME"  ):SetValue(SF1TMP->FOR_NOME)
	EndIf        
	oSection2:Cell("PA_CODIGO"  ):SetValue(SF1TMP->PA_CODIGO) //DANILO BUSSO 25/09/2015
	oSection2:Cell("UM"        ):SetValue(SF1TMP->UM)
	oSection2:Cell("QUANT"     ):SetValue(SF1TMP->QUANT)
	oSection2:Cell("QTSEGUM"   ):SetValue(SF1TMP->QTSEGUM)
	oSection2:Cell("VAL_UNIT"  ):SetValue(SF1TMP->VAL_UNIT)
	oSection2:Cell("VAL_UNIT2" ):SetValue(SF1TMP->(VAL_UNIT/TX_MOEDA2))
	oSection2:Cell("VAL_TOTAL" ):SetValue(SF1TMP->VAL_TOTAL)
	oSection2:Cell("PER_ICMS"  ):SetValue(SF1TMP->PER_ICMS)
	oSection2:Cell("VAL_IPI"   ):SetValue(SF1TMP->VAL_IPI)
	oSection2:Cell("CONDICAO"  ):SetValue(SF1TMP->CONDICAO)
	oSection2:Cell("TIPO_FRET" ):SetValue(SF1TMP->TIPO_FRET)       

	oSection2:PrintLine()
	oReport:IncMeter()

	SF1TMP->(DbSkip())
EndDo

If !Empty(cQuebra1)
	oSection1:Finish()
	oSection2:Finish()
	
	oReport:FatLine()			
EndIf

If Select("SF1TMP") > 0
	SF1TMP->(DbCloseArea())
EndIf

Return()