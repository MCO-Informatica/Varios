#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE DMPAPER_A4 9
#DEFINE CRLF CHR(13)+CHR(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DEBCREVEN ∫Autor  ≥Nelson Junior       ∫ Data ≥  10/06/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥RelatÛrio de dÈbito/crÈdito dos vendedores                  ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function DebCreVen()

Local oReport

oReport := reportDef()
oReport:printDialog()

Return()

Static Function reportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4
Local cTitulo := 'RelDC'
 
oReport := TReport():New("DEBCREVEN", cTitulo, "DEBCREVEN", {|oReport| PrintReport(oReport)}, "Demonstra os dÈbitos e crÈditos dos vendedores.")
oReport:SetLandScape() //Retrato
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

PutSX1("DEBCREVEN","01","PerÌodo de  ","","","MV_CH1","D",08,0,0,"G","",""   ,"","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSX1("DEBCREVEN","02","PerÌodo ate ","","","MV_CH2","D",08,0,0,"G","",""   ,"","","MV_PAR02","","","","","","","","","","","","","","","","","","","")
PutSX1("DEBCREVEN","03","Vendedor    ","","","MV_CH3","C",06,0,0,"G","","SA3","","","MV_PAR03","","","","","","","","","","","","","","","","","","","")
PutSX1("DEBCREVEN","04","Divis„o     ","","","MV_CH4","C",06,0,0,"G","","ACY","","","MV_PAR04","","","","","","","","","","","","","","","","","","","")
PutSX1("DEBCREVEN","05","Regi„o      ","","","MV_CH5","C",03,0,0,"G","","Z06","","","MV_PAR05","","","","","","","","","","","","","","","","","","","")
PutSX1("DEBCREVEN","06","Produto     ","","","MV_CH6","C",15,0,0,"G","","SB1","","","MV_PAR06","","","","","","","","","","","","","","","","","","","")
PutSX1("DEBCREVEN","07","Cliente     ","","","MV_CH7","C",06,0,0,"G","","SA1","","","MV_PAR07","","","","","","","","","","","","","","","","","","","")
PutSX1("DEBCREVEN","08","Loja        ","","","MV_CH8","C",02,0,0,"G","",""   ,"","","MV_PAR08","","","","","","","","","","","","","","","","","","","")

Pergunte(oReport:uParam,.F.)

oSection1 := TRSection():New(oReport,"Vendedor")
oSection1:SetTotalInLine(.F.)

oSection2 := TRSection():New(oReport,"Zona")
oSection2:SetTotalInLine(.F.)

oSection3 := TRSection():New(oReport,"Divis„o")
oSection3:SetTotalInLine(.F.)

oSection4 := TRSection():New(oReport,"Divis„o")
oSection4:SetTotalInLine(.F.)

oSection5 := TRSection():New(oReport,"Total Divis„o")
oSection5:SetTotalInLine(.F.)

oSection6 := TRSection():New(oReport,"Total Regi„o")
oSection6:SetTotalInLine(.F.)

oSection7 := TRSection():New(oReport,"Total Vendedor")
oSection7:SetTotalInLine(.F.)

TRCell():New(oSection1,"VENDEDOR"	,,"Vendedor",	PesqPict('SA3',"A3_NOME"),		TamSX3("A3_NOME")[1]+1,;
/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

TRCell():New(oSection2,"REGIAO"		,,"Zona",		"",								100,;
/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

TRCell():New(oSection3,"GRPVEN"		,,"Divis„o",	"",								100,;
/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

TRCell():New(oSection4,"EMISSAO"	,,"Emiss„o",	PesqPict('Z04',"Z04_EMISSA"),	TamSX3("Z04_EMISSA"	)[1]+3,,,,,)
TRCell():New(oSection4,"NOTA"		,,"NF",			PesqPict('Z04',"Z04_DOC"),		TamSX3("Z04_DOC"	)[1]+3,,,,,)
TRCell():New(oSection4,"SERIE"		,,"SÈrie",		PesqPict('Z04',"Z04_SERIE"),	TamSX3("Z04_SERIE"	)[1]+1,,,,,)
TRCell():New(oSection4,"CLIENTE"	,,"Cliente",	PesqPict('SA1',"A1_NOME"),		TamSX3("A1_NOME"	)[1]+1,,,,,)
TRCell():New(oSection4,"PRODUTO"	,,"Produto",	PesqPict('Z04',"Z04_COD"),		TamSX3("Z04_COD"	)[1]+1,,,,,)
TRCell():New(oSection4,"QTDE"		,,"Quantidade",	PesqPict('Z04',"Z04_QUANT"),	TamSX3("Z04_QUANT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"COND"		,,"Cond.Pagto",	PesqPict('SE4',"E4_DESCRI"),	TamSX3("E4_DESCRI"	)[1]+1,,,,,)
TRCell():New(oSection4,"UM"			,,"UM",			PesqPict('Z04',"Z04_UM"),		TamSX3("Z04_UM"		)[1]+1,,,,,)
TRCell():New(oSection4,"TABELA"		,,"Tabela",		PesqPict('Z04',"Z04_TABELA"),	TamSX3("Z04_TABELA"	)[1]+1,,,"CENTER",,"CENTER")
TRCell():New(oSection4,"VLRTAB"		,,"Vlr. Tab.",	PesqPict('Z04',"Z04_VALTAB"),	TamSX3("Z04_VALTAB"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"VLRVEN"		,,"Vlr. Ven.",	PesqPict('Z04',"Z04_VALNOT"),	TamSX3("Z04_VALNOT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"DEBITO"		,,"DÈbito",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"CREDITO"	,,"CrÈdito",	PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"SALDO"		,,"Saldo",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"OBSERV"		,,"ObservaÁ„o",	PesqPict('Z04',"Z04_OBSERV"),	TamSX3("Z04_OBSERV"	)[1]-15,,,,,)

//TOTALIZADOR DIVIS√O
TRCell():New(oSection5,"EMISSAO"	,,"Emiss„o",	PesqPict('Z04',"Z04_EMISSA"),	TamSX3("Z04_EMISSA"	)[1]+3,,,,,)
TRCell():New(oSection5,"NOTA"		,,"NF",			PesqPict('Z04',"Z04_DOC"),		TamSX3("Z04_DOC"	)[1]+3,,,,,)
TRCell():New(oSection5,"SERIE"		,,"SÈrie",		PesqPict('Z04',"Z04_SERIE"),	TamSX3("Z04_SERIE"	)[1]+1,,,,,)
TRCell():New(oSection5,"CLIENTE"	,,"Cliente",	PesqPict('SA1',"A1_NOME"),		TamSX3("A1_NOME"	)[1]+1,,,,,)
TRCell():New(oSection5,"PRODUTO"	,,"Produto",	PesqPict('Z04',"Z04_COD"),		TamSX3("Z04_COD"	)[1]+1,,,,,)
TRCell():New(oSection5,"QTDE"		,,"Quantidade",	PesqPict('Z04',"Z04_QUANT"),	TamSX3("Z04_QUANT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"COND"		,,"Cond.Pagto",	PesqPict('SE4',"E4_DESCRI"),	TamSX3("E4_DESCRI"	)[1]+1,,,,,)
TRCell():New(oSection5,"UM"			,,"UM",			PesqPict('Z04',"Z04_UM"),		TamSX3("Z04_UM"		)[1]+1,,,,,)
TRCell():New(oSection5,"TABELA"		,,"Tabela",		PesqPict('Z04',"Z04_TABELA"),	TamSX3("Z04_TABELA"	)[1]+1,,,"CENTER",,"CENTER")
TRCell():New(oSection5,"VLRTAB"		,,"Vlr. Tab.",	PesqPict('Z04',"Z04_VALTAB"),	TamSX3("Z04_VALTAB"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"VLRVEN"		,,"Vlr. Ven.",	PesqPict('Z04',"Z04_VALNOT"),	TamSX3("Z04_VALNOT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"DEBITO"		,,"DÈbito",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection5,"CREDITO"	,,"CrÈdito",	PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection5,"SALDO"		,,"Saldo",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection5,"OBSERV"		,,"ObservaÁ„o",	PesqPict('Z04',"Z04_OBSERV"),	TamSX3("Z04_OBSERV"	)[1]-15,,,		,,		 ,,,,,,.T.)

//TOTALIZADOR REGI√O
TRCell():New(oSection6,"EMISSAO"	,,"Emiss„o",	PesqPict('Z04',"Z04_EMISSA"),	TamSX3("Z04_EMISSA"	)[1]+3,,,,,)
TRCell():New(oSection6,"NOTA"		,,"NF",			PesqPict('Z04',"Z04_DOC"),		TamSX3("Z04_DOC"	)[1]+3,,,,,)
TRCell():New(oSection6,"SERIE"		,,"SÈrie",		PesqPict('Z04',"Z04_SERIE"),	TamSX3("Z04_SERIE"	)[1]+1,,,,,)
TRCell():New(oSection6,"CLIENTE"	,,"Cliente",	PesqPict('SA1',"A1_NOME"),		TamSX3("A1_NOME"	)[1]+1,,,,,)
TRCell():New(oSection6,"PRODUTO"	,,"Produto",	PesqPict('Z04',"Z04_COD"),		TamSX3("Z04_COD"	)[1]+1,,,,,)
TRCell():New(oSection6,"QTDE"		,,"Quantidade",	PesqPict('Z04',"Z04_QUANT"),	TamSX3("Z04_QUANT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"COND"		,,"Cond.Pagto",	PesqPict('SE4',"E4_DESCRI"),	TamSX3("E4_DESCRI"	)[1]+1,,,,,)
TRCell():New(oSection6,"UM"			,,"UM",			PesqPict('Z04',"Z04_UM"),		TamSX3("Z04_UM"		)[1]+1,,,,,)
TRCell():New(oSection6,"TABELA"		,,"Tabela",		PesqPict('Z04',"Z04_TABELA"),	TamSX3("Z04_TABELA"	)[1]+1,,,"CENTER",,"CENTER")
TRCell():New(oSection6,"VLRTAB"		,,"Vlr. Tab.",	PesqPict('Z04',"Z04_VALTAB"),	TamSX3("Z04_VALTAB"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"VLRVEN"		,,"Vlr. Ven.",	PesqPict('Z04',"Z04_VALNOT"),	TamSX3("Z04_VALNOT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"DEBITO"		,,"DÈbito",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection6,"CREDITO"	,,"CrÈdito",	PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection6,"SALDO"		,,"Saldo",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection6,"OBSERV"		,,"ObservaÁ„o",	PesqPict('Z04',"Z04_OBSERV"),	TamSX3("Z04_OBSERV"	)[1]-15,,,		,,		 ,,,,,,.T.)

//TOTALIZADOR VENDEDOR
TRCell():New(oSection7,"EMISSAO"	,,"Emiss„o",	PesqPict('Z04',"Z04_EMISSA"),	TamSX3("Z04_EMISSA"	)[1]+3,,,,,)
TRCell():New(oSection7,"NOTA"		,,"NF",			PesqPict('Z04',"Z04_DOC"),		TamSX3("Z04_DOC"	)[1]+3,,,,,)
TRCell():New(oSection7,"SERIE"		,,"SÈrie",		PesqPict('Z04',"Z04_SERIE"),	TamSX3("Z04_SERIE"	)[1]+1,,,,,)
TRCell():New(oSection7,"CLIENTE"	,,"Cliente",	PesqPict('SA1',"A1_NOME"),		TamSX3("A1_NOME"	)[1]+1,,,,,)
TRCell():New(oSection7,"PRODUTO"	,,"Produto",	PesqPict('Z04',"Z04_COD"),		TamSX3("Z04_COD"	)[1]+1,,,,,)
TRCell():New(oSection7,"QTDE"		,,"Quantidade",	PesqPict('Z04',"Z04_QUANT"),	TamSX3("Z04_QUANT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"COND"		,,"Cond.Pagto",	PesqPict('SE4',"E4_DESCRI"),	TamSX3("E4_DESCRI"	)[1]+1,,,,,)
TRCell():New(oSection7,"UM"			,,"UM",			PesqPict('Z04',"Z04_UM"),		TamSX3("Z04_UM"		)[1]+1,,,,,)
TRCell():New(oSection7,"TABELA"		,,"Tabela",		PesqPict('Z04',"Z04_TABELA"),	TamSX3("Z04_TABELA"	)[1]+1,,,"CENTER",,"CENTER")
TRCell():New(oSection7,"VLRTAB"		,,"Vlr. Tab.",	PesqPict('Z04',"Z04_VALTAB"),	TamSX3("Z04_VALTAB"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"VLRVEN"		,,"Vlr. Ven.",	PesqPict('Z04',"Z04_VALNOT"),	TamSX3("Z04_VALNOT"	)[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"DEBITO"		,,"DÈbito",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection7,"CREDITO"	,,"CrÈdito",	PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection7,"SALDO"		,,"Saldo",		PesqPict('Z04',"Z04_VALOR"),	TamSX3("Z04_VALOR"	)[1]+1,,,"RIGHT",,"RIGHT",,,,,,.T.)
TRCell():New(oSection7,"OBSERV"		,,"ObservaÁ„o",	PesqPict('Z04',"Z04_OBSERV"),	TamSX3("Z04_OBSERV"	)[1]-15,,,		,,		 ,,,,,,.T.)

/*TRFunction():New(oSection4:Cell("DEBITO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.T.,.F.,oSection4)
TRFunction():New(oSection4:Cell("CREDITO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.T.,.F.,oSection4)
TRFunction():New(oSection4:Cell("SALDO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.T.,.F.,oSection4)

TRFunction():New(oSection4:Cell("DEBITO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.F.,.F.,oSection1)
TRFunction():New(oSection4:Cell("CREDITO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.F.,.F.,oSection1)
TRFunction():New(oSection4:Cell("SALDO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.F.,.F.,oSection1)

TRFunction():New(oSection4:Cell("DEBITO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.F.,.F.,oSection2)
TRFunction():New(oSection4:Cell("CREDITO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.F.,.F.,oSection2)
TRFunction():New(oSection4:Cell("SALDO"),"","SUM",,"",PesqPict("Z04","Z04_VALOR"),,.T.,.F.,.F.,oSection2)*/

Return(oReport)

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local oSection4 := oReport:Section(4)
Local oSection5 := oReport:Section(5)
Local oSection6 := oReport:Section(6)
Local oSection7 := oReport:Section(7)
Local cVendedor	:= ""
Local cRegiao	:= ""
Local cGrpVen	:= ""
//
Local nVlrAnt   := 0
//
Local nSaldDiv  := 0
Local nTotDivD  := 0
Local nTotDivC  := 0
//
Local nSaldReg  := 0
Local nTotRegD  := 0
Local nTotRegC  := 0
//
Local nSaldVen  := 0
Local nTotVenD  := 0
Local nTotVenC  := 0
//
cQry := " SELECT                                        "+CRLF
cQry += "    Z04_VENDED ,                               "+CRLF
cQry += "    A1_REGIAO  ,                               "+CRLF
cQry += "    A1_GRPVEN  ,                               "+CRLF
cQry += "    Z04_EMISSA ,                               "+CRLF
cQry += "    Z04_DOC    ,                               "+CRLF
cQry += "    Z04_SERIE  ,                               "+CRLF
cQry += "    E4_DESCRI  ,                               "+CRLF
cQry += "    Z04_CLIENT ,                               "+CRLF
cQry += "    Z04_LOJA   ,                               "+CRLF
cQry += "    A1_NOME    ,                               "+CRLF
cQry += "    Z04_COD    ,                               "+CRLF
cQry += "    B1_DESC    ,                               "+CRLF
cQry += "    Z04_QUANT  ,                               "+CRLF
cQry += "    Z04_UM     ,                               "+CRLF
cQry += "    Z04_TABELA ,                               "+CRLF
cQry += "    Z04_VALTAB ,                               "+CRLF
cQry += "    Z04_VALNOT ,                               "+CRLF
cQry += "    CASE                                       "+CRLF
cQry += "       WHEN Z04_TIPODC = 'D' THEN Z04_VALOR*-1 "+CRLF
cQry += "       ELSE Z04_VALOR                          "+CRLF
cQry += "    END Z04_VALOR ,                            "+CRLF
cQry += "    Z04_OBSERV                                 "+CRLF
cQry += " FROM " + RetSQLName("Z04")+" Z04              "+CRLF
cQry += "    INNER JOIN " + RetSQLName("SA1")+" SA1 ON  "+CRLF
cQry += "       SA1.D_E_L_E_T_ <> '*'                   "+CRLF
cQry += "       AND A1_FILIAL = '"+xFilial("SA1")+"'    "+CRLF
cQry += "       AND A1_COD    = Z04_CLIENT              "+CRLF
cQry += "       AND A1_LOJA   = Z04_LOJA                "+CRLF
cQry += "    LEFT JOIN " + RetSQLName("SB1")+" SB1 ON   "+CRLF
cQry += "       SB1.D_E_L_E_T_ <> '*'                   "+CRLF
cQry += "       AND B1_FILIAL = '"+xFilial("SB1")+"'    "+CRLF
cQry += "       AND B1_COD  = Z04_COD                   "+CRLF
cQry += "    INNER JOIN " + RetSQLName("SF2")+" SF2 ON  "+CRLF
cQry += "       SF2.D_E_L_E_T_ <> '*'                   "+CRLF
cQry += "       AND F2_FILIAL = '"+xFilial("SF2")+"'    "+CRLF
cQry += "       AND F2_DOC    = Z04_DOC                 "+CRLF
cQry += "       AND F2_SERIE  = Z04_SERIE               "+CRLF
cQry += "    INNER JOIN " + RetSQLName("SE4")+" SE4 ON  "+CRLF
cQry += "       SE4.D_E_L_E_T_ <> '*'                   "+CRLF
cQry += "       AND E4_FILIAL = '"+xFilial("SE4")+"'    "+CRLF
cQry += "       AND E4_CODIGO  = F2_COND                "+CRLF
cQry += " WHERE                                         "+CRLF
cQry += "    Z04.D_E_L_E_T_ <> '*'                      "+CRLF
cQry += "    AND Z04_FILIAL = '"+xFilial("Z04")+"'      "+CRLF
cQry += "    AND Z04_EMISSA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+CRLF
//
//Filtro Vendedor
If __cUserID $ "000000/"+GetMV("MV_USRDBCR", .F.)
	//
	If !Empty(MV_PAR03)
		cQry += "    AND Z04_VENDED = '"+MV_PAR03+"' "+CRLF
	EndIf
	//
Else
	//
	SA3->(DbSetOrder(7))
	SA3->(DbSeek(xFilial("SA3")+__cUserID))
	//
	cQry += "    AND Z04_VENDED = '"+SA3->A3_COD+"' "+CRLF	
	//
EndIf
//
//Filtro Divis„o
If !Empty(MV_PAR04)
	cQry += "    AND Z04_GRPVEN = '"+MV_PAR04+"' "+CRLF
EndIf
//
//Filtro Regi„o
If !Empty(MV_PAR05)
	cQry += "    AND Z04_REGIAO = '"+MV_PAR05+"' "+CRLF
EndIf
//
//Filtro Produto
If !Empty(MV_PAR06)
	cQry += "    AND Z04_COD    = '"+MV_PAR06+"' "+CRLF
EndIf
//
//Filtro Cliente
If !Empty(MV_PAR07)
	cQry += "    AND Z04_CLIENT = '"+MV_PAR07+"' "+CRLF
	cQry += "    AND Z04_LOJA   = '"+MV_PAR08+"' "+CRLF
EndIf
//

cQry += "ORDER BY Z04_VENDED, A1_REGIAO, A1_GRPVEN, Z04_EMISSA, Z04_HRLANC, Z04_DOC "+CRLF

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

TcQuery cQry New Alias "QRY"

DbSelectArea("QRY")
nTotalReg := Contar("QRY", "!Eof()")
QRY->(DbGoTop())

oReport:SetMeter(nTotalReg)

While QRY->(!Eof())

	If cVendedor <> QRY->Z04_VENDED .Or. cRegiao <> QRY->A1_REGIAO .Or. cGrpVen <> QRY->A1_GRPVEN
		oSection1:Init()
		oSection1:SetHeaderSection(.F.)
			
		If cVendedor <> QRY->Z04_VENDED
			oReport:IncRow()
			oReport:FatLine()
			//
			oSection1:Cell("VENDEDOR"):SetValue("Vendedor: "+QRY->Z04_VENDED+" - "+Posicione("SA3",1,xFilial("SA3")+QRY->Z04_VENDED,"A3_NOME"))
			oSection1:PrintLine()
		EndIf
		
		oSection2:Init()
		oSection2:SetHeaderSection(.F.)
		
		oSection2:Cell("REGIAO"):SetValue("Zona: "+AllTrim(QRY->A1_REGIAO)+" - "+Posicione("Z06",1,xFilial("Z06")+QRY->A1_REGIAO,"Z06_DESCRI"))
		oSection2:PrintLine()
		
		oSection3:Init()
		oSection3:SetHeaderSection(.F.)
		
		oSection3:Cell("GRPVEN"):SetValue("Divis„o: "+AllTrim(QRY->A1_GRPVEN)+" - "+Posicione("ACY",1,xFilial("ACY")+QRY->A1_GRPVEN,"ACY_DESCRI"))
		oSection3:PrintLine()
		
		oSection4:Init()
		oSection4:SetHeaderSection(.T.)
		
		oSection4:Cell("EMISSAO"):Hide()
		oSection4:Cell("NOTA"):Hide()
		oSection4:Cell("SERIE"):Hide()
		oSection4:Cell("CLIENTE"):Hide()
		oSection4:Cell("PRODUTO"):Hide()
		oSection4:Cell("QTDE"):Hide()
		oSection4:Cell("COND"):Hide()
		oSection4:Cell("UM"):Hide()
		oSection4:Cell("TABELA"):Hide()
		oSection4:Cell("VLRTAB"):Hide()
		oSection4:Cell("VLRVEN"):Hide()
		oSection4:Cell("DEBITO"):Hide()
		oSection4:Cell("CREDITO"):Hide()
		//  
		If (cVendedor <> QRY->Z04_VENDED)
			_nSaldo := SldAntVd(QRY->Z04_VENDED, QRY->A1_REGIAO, QRY->A1_GRPVEN)		
	
			//
			nVlrAnt  += _nSaldo
			//
			nSaldDiv += _nSaldo
			nSaldReg += _nSaldo
			nSaldVen += _nSaldo
			//     
		EndIf
		oSection4:Cell("SALDO"):SetValue(_nSaldo)
		oSection4:Cell("OBSERV"):SetValue("SALDO ANTERIOR")
		oSection4:PrintLine()
		//
		oSection4:Cell("EMISSAO"):Show()
		oSection4:Cell("NOTA"):Show()
		oSection4:Cell("SERIE"):Show()
		oSection4:Cell("CLIENTE"):Show()
		oSection4:Cell("PRODUTO"):Show()
		oSection4:Cell("QTDE"):Show()
		oSection4:Cell("COND"):Show()
		oSection4:Cell("UM"):Show()
		oSection4:Cell("TABELA"):Show()
		oSection4:Cell("VLRTAB"):Show()
		oSection4:Cell("VLRVEN"):Show()
		oSection4:Cell("DEBITO"):Show()
		oSection4:Cell("CREDITO"):Show()
	EndIf
	
	If cGrpVen <> QRY->A1_GRPVEN
		oReport:IncRow()
	EndIf

	oSection4:Cell("EMISSAO"):SetValue(DtoC(StoD(QRY->Z04_EMISSA)))
	oSection4:Cell("NOTA"):SetValue(QRY->Z04_DOC)
	oSection4:Cell("SERIE"):SetValue(QRY->Z04_SERIE)
	oSection4:Cell("CLIENTE"):SetValue(QRY->A1_NOME)
	oSection4:Cell("PRODUTO"):SetValue(QRY->Z04_COD)
	oSection4:Cell("QTDE"):SetValue(QRY->Z04_QUANT)
	oSection4:Cell("COND"):SetValue(QRY->E4_DESCRI)
	oSection4:Cell("UM"):SetValue(AllTrim(QRY->Z04_UM))
	oSection4:Cell("TABELA"):SetValue(QRY->Z04_TABELA)
	oSection4:Cell("VLRTAB"):SetValue(QRY->Z04_VALTAB)
	oSection4:Cell("VLRVEN"):SetValue(QRY->Z04_VALNOT)

	If QRY->Z04_VALOR < 0
		oSection4:Cell("DEBITO"):SetValue(QRY->Z04_VALOR)
		oSection4:Cell("CREDITO"):SetValue(0)
		//
		_nSaldo  += QRY->Z04_VALOR
		//
		nTotDivD += QRY->Z04_VALOR
		nTotRegD += QRY->Z04_VALOR
		nTotVenD += QRY->Z04_VALOR
	Else
		oSection4:Cell("DEBITO"):SetValue(0)
		oSection4:Cell("CREDITO"):SetValue(QRY->Z04_VALOR)
		//
		_nSaldo  += QRY->Z04_VALOR
		//
		nTotDivC += QRY->Z04_VALOR
		nTotRegC += QRY->Z04_VALOR
		nTotVenC += QRY->Z04_VALOR
	EndIf
	oSection4:Cell("SALDO"):SetValue(_nSaldo)
	oSection4:Cell("OBSERV"):SetValue(QRY->Z04_OBSERV)

	oSection4:PrintLine()

	cVendedor := QRY->Z04_VENDED
	cRegiao	  := QRY->A1_REGIAO
	cGrpVen	  := QRY->A1_GRPVEN

	QRY->(DbSkip())

	If cVendedor <> QRY->Z04_VENDED .Or. cRegiao <> QRY->A1_REGIAO .Or. cGrpVen <> QRY->A1_GRPVEN
		//
		oSection4:Finish()
		oSection3:Finish()
		oSection2:Finish()
		//
		oReport:FatLine()
		//
		oSection5:Init()
		oSection5:SetHeaderSection(.F.)
		oSection5:Cell("DEBITO"):SetValue(nTotDivD)
		oSection5:Cell("CREDITO"):SetValue(nTotDivC)
		//oSection5:Cell("SALDO"):SetValue(nSaldDiv+nTotDivD+nTotDivC)  
		oSection5:Cell("SALDO"):SetValue(_nSaldo)
		oSection5:Cell("OBSERV"):lBold := .T.
		oSection5:Cell("OBSERV"):SetValue("TOTAL DIVIS√O "+cGrpVen)
		oSection5:PrintLine()
		oSection5:Finish()
		oReport:ThinLine()
		//
		nSaldDiv := 0
		nTotDivD := 0
		nTotDivC := 0
		//
		oSection6:Init()
		oSection6:SetHeaderSection(.F.)
		oSection6:Cell("DEBITO"):SetValue(nTotRegD)
		oSection6:Cell("CREDITO"):SetValue(nTotRegC)
//		oSection6:Cell("SALDO"):SetValue(nSaldReg+nTotRegD+nTotRegC)
		oSection6:Cell("SALDO"):SetValue(_nSaldo)
		oSection6:Cell("OBSERV"):lBold := .T.
		oSection6:Cell("OBSERV"):SetValue("TOTAL REGI√O "+cRegiao)
		oSection6:PrintLine()
		oSection6:Finish()
		oReport:ThinLine()
		//
		nSaldReg := 0
		nTotRegD := 0
		nTotRegC := 0
		//
		If cVendedor <> QRY->Z04_VENDED
			oSection1:Finish()

			oReport:FatLine()			
			oSection7:Init()
			oSection7:SetHeaderSection(.F.)
			oSection7:Cell("DEBITO"):SetValue(nTotVenD)
			oSection7:Cell("CREDITO"):SetValue(nTotVenC)
			_nSaldo := nSaldVen+nTotVenD+nTotVenC
			oSection7:Cell("SALDO"):SetValue(_nSaldo)
			oSection7:Cell("OBSERV"):SetValue("TOTAL VENDEDOR "+cVendedor)
			oSection7:PrintLine()
			oSection7:Finish()
			oReport:FatLine()
			//
			nSaldVen := 0
			nTotVenD := 0
			nTotVenC := 0
			//
		EndIf
		//
		nVlrAnt := 0
		//
		oReport:IncRow()
		oReport:IncRow()
		//
	EndIf

	oReport:IncMeter()

EndDo

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: SldAntVd  | Autor: Celso Ferrone Martins  | Data: 10/06/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Pega saldo anterior do debito/credito                      |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function SldAntVd(_cVend, _cRegiao, _cGrpVen)

Local nSldAnt  := 0
Local dUltFech := cTod("  /  /  ")

/*
cQuery := " SELECT "
cQuery += " * "
cQuery += " FROM ( "
cQuery += "    SELECT "
cQuery += "       Z05_VALOR "
cQuery += "    FROM " + RetSqlName("Z05") + " Z05 "
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += "    AND Z05_DATA < '"+DtoS(MV_PAR01)+"' "
cQuery += "    AND Z05_VENDED = '"+_cVend+"' "
//cQuery += "    AND Z05_REGIAO = '"+_cRegiao+"' "
//cQuery += "    AND Z05_GRPVEN = '"+_cGrpVen+"' "
cQuery += " ORDER BY Z05_DATA DESC "
cQuery += " ) "
cQuery += " WHERE "
cQuery += " ROWNUM = 1 "

cQuery := ChangeQuery(cQuery)

If Select("TMPZ05") > 0
	TMPZ05->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPZ05"

If !TMPZ05->(Eof())
	nSldAnt := TMPZ05->Z05_VALOR
EndIf

If Select("TMPZ05") > 0
	TMPZ05->(DbCloseArea())
EndIf
*/
cQuery := " SELECT "
cQuery += "    MAX(Z05_DATA) AS ULTFECH"
cQuery += " FROM "+RetSqlName("Z05")
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += "    AND Z05_FILIAL = '"+xFilial("Z05")+"' "
cQuery += "    AND Z05_DATA   < '"+DtoS(MV_PAR01)+"' "

cQuery := ChangeQuery(cQuery)

If Select("TMPDAT") > 0
	TMPDAT->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPDAT"

If !TMPDAT->(Eof())
	dUltFech := sTod(TMPDAT->ULTFECH)
EndIf

If Select("TMPDAT") > 0
	TMPDAT->(DbCloseArea())
EndIf

cQuery := ""
cQuery += " SELECT SUM(VALOR) AS VALOR FROM ( "
cQuery += " SELECT (CASE WHEN Z05_TIPODC = 'D' THEN SUM(Z05_VALOR)*-1 ELSE SUM(Z05_VALOR) END) AS VALOR FROM " + RetSqlName("Z05") + " Z05 "
cQuery += " WHERE "
cQuery += " Z05.D_E_L_E_T_ <> '*' AND Z05_DATA BETWEEN '"+DtoS((dUltFech+1))+"' AND '"+DtoS((MV_PAR01-1))+"' "
cQuery += " AND Z05_VENDED = '"+_cVend+"' "
cQuery += " GROUP BY Z05_VENDED, Z05_REGIAO, Z05_GRPVEN, Z05_TIPODC "

If dUltFech+1 <= MV_PAR01-1
	cQuery += " UNION ALL "
	
	cQuery += " SELECT (CASE WHEN Z04_TIPODC = 'D' THEN SUM(Z04_VALOR) *-1 ELSE SUM(Z04_VALOR) END) AS VALOR FROM " + RetSQLName("Z04")+" Z04 "
	cQuery += " WHERE "
	cQuery += " D_E_L_E_T_ <> '*' AND Z04_EMISSA BETWEEN '"+DtoS((dUltFech+1))+"' AND '"+DtoS((MV_PAR01-1))+"' "
	cQuery += " AND Z04_VENDED = '"+_cVend+"' "
	cQuery += " GROUP BY Z04_VENDED, Z04_REGIAO, Z04_GRPVEN, Z04_TIPODC "
EndIf

cQuery += " ) TRB "

cQuery := ChangeQuery(cQuery)
//MemoWrite("C:\temp\debcre.txt",cQuery)

If Select("TMPZ05") > 0
	TMPZ05->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPZ05"

If !TMPZ05->(Eof())
	nSldAnt := TMPZ05->VALOR
EndIf

If Select("TMPZ05") > 0
	TMPZ05->(DbCloseArea())
EndIf


Return(nSldAnt)
