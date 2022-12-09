#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE DMPAPER_A4 9
#DEFINE CRLF (Chr(13)+Chr(10))

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RMAPAANP  ∫Autor  ≥Nelson Junior       ∫ Data ≥  10/02/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥RelatÛrio com as informaÁıes que devem ser enviadas para a  ∫±±
±±∫          ≥ANP.                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function rMapaAnp()

Local oReport

oReport := reportDef()
oReport:printDialog()

Return()

Static Function reportDef()
Local oReport
Local oSection1
Local cTitulo	:= "Mapa ANP"

oReport := TReport():New("RMAPAANP", cTitulo, "RMAPAANP", {|oReport| PrintReport(oReport)}, "GeraÁ„o do Mapa ANP.")
oReport:SetLandScape() //Paisagem
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

PutSX1("RMAPAANP","01","PerÌodo de  ","","","MV_CH1","D",08,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSX1("RMAPAANP","02","PerÌodo ate ","","","MV_CH2","D",08,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","","","","")

Pergunte(oReport:uParam,.F.)

oSection1 := TRSection():New(oReport, "ANP")
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"OPERACAO"	,,"Op."					,"",50)
TRCell():New(oSection1,"ENT1"		,,""					,"",05)
TRCell():New(oSection1,"INST1"		,,"Inst 1"				,"",50)
TRCell():New(oSection1,"ENT2"		,,""					,"",05)
TRCell():New(oSection1,"INST2"		,,"Inst 2"				,"",50)
TRCell():New(oSection1,"ENT3"		,,""					,"",05)
TRCell():New(oSection1,"PRODUTO"	,,"Produto"				,"",50)
TRCell():New(oSection1,"ENT4"		,,""					,"",05)
TRCell():New(oSection1,"LT"			,,"LT"					,"",50)
TRCell():New(oSection1,"ENT5"		,,""					,"",05)
TRCell():New(oSection1,"KG"			,,"KG"					,"",50)
TRCell():New(oSection1,"ENT6"		,,""					,"",05)
TRCell():New(oSection1,"MODAL"		,,"Modal"				,"",50)
TRCell():New(oSection1,"ENT7"		,,""					,"",05)
TRCell():New(oSection1,"VEICULO"	,,"VeÌculo"				,"",50)
TRCell():New(oSection1,"ENT8"		,,""					,"",05)
TRCell():New(oSection1,"CNPJ"		,,"CNPJ Fornecedor"		,"",50)
TRCell():New(oSection1,"ENT9"		,,""					,"",05)
TRCell():New(oSection1,"LOCAL"		,,"Local"				,"",50)
TRCell():New(oSection1,"ENT10"		,,""					,"",05)
TRCell():New(oSection1,"ATIVIDADE"	,,"Ativ."				,"",50)
TRCell():New(oSection1,"ENT11"		,,""					,"",05)
TRCell():New(oSection1,"PAIS"		,,"PaÌs"				,"",50)
TRCell():New(oSection1,"ENT12"		,,""					,"",05)
TRCell():New(oSection1,"LI"			,,"LI"					,"",50)
TRCell():New(oSection1,"ENT13"		,,""					,"",05)
TRCell():New(oSection1,"DI"			,,"DI"					,"",50)
TRCell():New(oSection1,"ENT14"		,,""					,"",05)
TRCell():New(oSection1,"NOTA"		,,"Nota"				,"",50)
TRCell():New(oSection1,"ENT15"		,,""					,"",05)
TRCell():New(oSection1,"SERIE"		,,"SÈrie"				,"",50)
TRCell():New(oSection1,"ENT16"		,,""					,"",05)
TRCell():New(oSection1,"DATA"		,,"Data"				,"",50)
TRCell():New(oSection1,"ENT17"		,,""					,"",05)
TRCell():New(oSection1,"TS"			,,"TS"					,"",50)
TRCell():New(oSection1,"ENT18"		,,""					,"",05)
TRCell():New(oSection1,"CCP"		,,"CCP"					,"",50)
TRCell():New(oSection1,"ENT19"		,,""					,"",05)
TRCell():New(oSection1,"CMA"		,,"CMA"					,"",50)
TRCell():New(oSection1,"ENT20"		,,""					,"",05)
TRCell():New(oSection1,"UMC"		,,"UMC"					,"",50)
TRCell():New(oSection1,"ENT21"		,,""					,"",05)
TRCell():New(oSection1,"VC"			,,"VC"					,"",50)
TRCell():New(oSection1,"ENT22"		,,""					,"",05)
TRCell():New(oSection1,"P/OR"		,,"P/OR"				,"",50)
TRCell():New(oSection1,"ENT23"		,,""					,"",05)
TRCell():New(oSection1,"MASSA"		,,"Massa"				,"",50)
TRCell():New(oSection1,"ENT24"		,,""					,"",05)
TRCell():New(oSection1,"EMBALAGEM"	,,"Embalagem"			,"",50)
TRCell():New(oSection1,"ENT25"		,,""					,"",05)
TRCell():New(oSection1,"CHAVE"		,,"Chave acesso NF-E"	,"",50)
TRCell():New(oSection1,"ENT26"		,,""					,"",05)

Return(oReport)

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cTpFrete	:= ""
Local cQry		:= ""           

//Vendas
cQry := "SELECT "+Chr(13)+Chr(10)
cQry += "'C' AS ESPECIE, "+Chr(13)+Chr(10)
cQry += "SF2.F2_TIPO AS TIPO, "+Chr(13)+Chr(10)
cQry += "SF2.F2_CLIENTE AS CLIFOR, "+Chr(13)+Chr(10)
cQry += "SF2.F2_LOJA AS LOJA, "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP AS PRODUTO, "+Chr(13)+Chr(10)
cQry += "SUM(SD2.D2_QUANT) AS QTDKG, "+Chr(13)+Chr(10)
cQry += "SUM(SD2.D2_QTSEGUM) AS QTDLT, "+Chr(13)+Chr(10)
cQry += "SD2.D2_PRCVEN AS DENSIDADE, "+Chr(13)+Chr(10)
cQry += "SF2.F2_EMISSAO AS EMISSAO, "+Chr(13)+Chr(10)
cQry += "SF2.F2_CHVNFE AS CHAVENFE, "+Chr(13)+Chr(10)
cQry += "SF2.F2_TPFRETE AS FRETE "+Chr(13)+Chr(10)
cQry += "FROM "+Chr(13)+Chr(10)
cQry += RetSQLName("SF2")+" SF2 "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SD2")+" SD2 ON  SF2.F2_DOC = SD2.D2_DOC "+Chr(13)+Chr(10)
cQry += "                				AND SF2.F2_SERIE = SD2.D2_SERIE "+Chr(13)+Chr(10)
cQry += "                				AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "+Chr(13)+Chr(10)
cQry += "                				AND SF2.F2_LOJA = SD2.D2_LOJA "+Chr(13)+Chr(10)
cQry += "                				AND SD2.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD2.D2_COD = SB1.B1_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "                				AND SB5.B5_PRODANP = 'S' "+Chr(13)+Chr(10)

cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD2.D2_TES "+Chr(13)+Chr(10)
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "+Chr(13)+Chr(10)
//cQry += "                				AND SF4.F4_ESTOQUE = 'S' "
//cQry += "                				AND SF4.F4_DUPLIC = 'S' "

cQry += "WHERE "                                    +Chr(13)+Chr(10)       
cQry += "SF2.D_E_L_E_T_ <> '*' "   +Chr(13)+Chr(10)  
cQry += "AND SF2.F2_FILIAL = '" +xFilial("SF2")+ "' "+Chr(13)+Chr(10)
cQry += "AND SD2.D2_FILIAL = '" +xFilial("SD2")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "+Chr(13)+Chr(10)
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "+Chr(13)+Chr(10)
cQry += "AND SF2.F2_TIPO NOT IN ('C', 'I', 'P') "+Chr(13)+Chr(10)
cQry += "AND SF2.F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+Chr(13)+Chr(10)
cQry += "GROUP BY "+Chr(13)+Chr(10)
cQry += "SF2.F2_CLIENTE, "+Chr(13)+Chr(10)
cQry += "SF2.F2_LOJA, "+Chr(13)+Chr(10)
cQry += "SF2.F2_TIPO, "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP, "+Chr(13)+Chr(10)
cQry += "SD2.D2_PRCVEN, "+Chr(13)+Chr(10)
cQry += "SF2.F2_EMISSAO, "+Chr(13)+Chr(10)
cQry += "SF2.F2_CHVNFE, "+Chr(13)+Chr(10)
cQry += "SF2.F2_TPFRETE "+Chr(13)+Chr(10)

cQry += "UNION ALL "+Chr(13)+Chr(10)

//Compras
cQry += "SELECT "+Chr(13)+Chr(10)
cQry += "'B' AS ESPECIE, "+Chr(13)+Chr(10)
cQry += "SF1.F1_TIPO AS TIPO, "+Chr(13)+Chr(10)
cQry += "SF1.F1_FORNECE AS CLIFOR, "+Chr(13)+Chr(10)
cQry += "SF1.F1_LOJA AS LOJA, "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP AS PRODUTO, "+Chr(13)+Chr(10)
cQry += "SUM(SD1.D1_QUANT) AS QTDKG, "+Chr(13)+Chr(10)
cQry += "SUM(SD1.D1_QTSEGUM) AS QTDLT, "+Chr(13)+Chr(10)
cQry += "SB1.B1_CONV AS DENSIDADE, "+Chr(13)+Chr(10)
cQry += "SF1.F1_DTDIGIT AS EMISSAO, "+Chr(13)+Chr(10)
cQry += "SF1.F1_CHVNFE AS CHAVENFE, "+Chr(13)+Chr(10)
cQry += "' ' AS FRETE "+Chr(13)+Chr(10)
cQry += "FROM "+Chr(13)+Chr(10)
cQry += RetSQLName("SF1")+" SF1 "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SD1")+" SD1 ON  SF1.F1_DOC = SD1.D1_DOC "+Chr(13)+Chr(10)
cQry += "                				AND SF1.F1_SERIE = SD1.D1_SERIE "+Chr(13)+Chr(10)
cQry += "                				AND SF1.F1_FORNECE = SD1.D1_FORNECE "+Chr(13)+Chr(10)
cQry += "                				AND SF1.F1_LOJA = SD1.D1_LOJA "+Chr(13)+Chr(10)
cQry += "                				AND SD1.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD1.D1_COD = SB1.B1_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "                				AND SB5.B5_PRODANP = 'S' "+Chr(13)+Chr(10)

cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD1.D1_TES "+Chr(13)+Chr(10)
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "+Chr(13)+Chr(10)
//cQry += "                				AND SF4.F4_ESTOQUE = 'S' "
//cQry += "                				AND SF4.F4_DUPLIC = 'S'  "

cQry += "WHERE "+Chr(13)+Chr(10)
cQry += "SF1.D_E_L_E_T_ <> '*' "   +Chr(13)+Chr(10)  
cQry += "AND SF1.F1_FILIAL = '" +xFilial("SF1")+ "' "+Chr(13)+Chr(10)
cQry += "AND SD1.D1_FILIAL = '" +xFilial("SD1")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "+Chr(13)+Chr(10)
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "+Chr(13)+Chr(10)
cQry += "AND SF1.F1_TIPO NOT IN ('C', 'I', 'P') "+Chr(13)+Chr(10)
cQry += "AND SF1.F1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+Chr(13)+Chr(10)
cQry += "GROUP BY "+Chr(13)+Chr(10)
cQry += "SF1.F1_FORNECE, "+Chr(13)+Chr(10)
cQry += "SF1.F1_LOJA, "+Chr(13)+Chr(10)
cQry += "SF1.F1_TIPO, "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP, "+Chr(13)+Chr(10)
cQry += "SB1.B1_CONV, "+Chr(13)+Chr(10)
cQry += "SF1.F1_DTDIGIT, "+Chr(13)+Chr(10)
cQry += "SF1.F1_CHVNFE "+Chr(13)+Chr(10)

cQry += "UNION ALL "+Chr(13)+Chr(10)

//Saldo Inicial
cQry += "SELECT "+Chr(13)+Chr(10)
cQry += "'A' AS ESPECIE, "+Chr(13)+Chr(10)
cQry += "'' AS TIPO, "+Chr(13)+Chr(10)
cQry += "'' AS CLIFOR, "+Chr(13)+Chr(10)
cQry += "'' AS LOJA, "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP AS PRODUTO, "+Chr(13)+Chr(10)
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "+Chr(13)+Chr(10)
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "+Chr(13)+Chr(10)
cQry += "SB1.B1_CONV AS DENSIDADE, "+Chr(13)+Chr(10)
cQry += "'"+DtoS(MV_PAR01)+"' AS EMISSAO, "+Chr(13)+Chr(10)
cQry += "' ' AS CHAVENFE, "+Chr(13)+Chr(10)
cQry += "' ' AS FRETE "+Chr(13)+Chr(10)
cQry += "FROM "+Chr(13)+Chr(10)
cQry += RetSQLName("SB9")+" SB9 "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SB9.B9_COD = SB1.B1_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "                				AND SB5.B5_PRODANP = 'S' "+Chr(13)+Chr(10)
cQry += "WHERE "+Chr(13)+Chr(10)
cQry += "SB9.D_E_L_E_T_ <> '*' "  +Chr(13)+Chr(10)
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB9.B9_QINI > 0 "+Chr(13)+Chr(10)
cQry += "AND SB9.B9_DATA = '"+DtoS(MV_PAR01-1)+"' "+Chr(13)+Chr(10)
cQry += "GROUP BY "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP, "+Chr(13)+Chr(10)
cQry += "SB1.B1_CONV, "+Chr(13)+Chr(10)
cQry += "SB9.B9_DATA "+Chr(13)+Chr(10)

cQry += "UNION ALL "+Chr(13)+Chr(10)

//Saldo Final
cQry += "SELECT "+Chr(13)+Chr(10)
cQry += "'D' AS ESPECIE, "+Chr(13)+Chr(10)
cQry += "'' AS TIPO, "+Chr(13)+Chr(10)
cQry += "'' AS CLIFOR, "+Chr(13)+Chr(10)
cQry += "'' AS LOJA, "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP AS PRODUTO, "+Chr(13)+Chr(10)
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "+Chr(13)+Chr(10)
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "+Chr(13)+Chr(10)
cQry += "SB1.B1_CONV AS DENSIDADE, "+Chr(13)+Chr(10)
cQry += "SB9.B9_DATA AS EMISSAO, "+Chr(13)+Chr(10)
cQry += "' ' AS CHAVENFE, "+Chr(13)+Chr(10)
cQry += "' ' AS FRETE "+Chr(13)+Chr(10)
cQry += "FROM "+Chr(13)+Chr(10)
cQry += RetSQLName("SB9")+" SB9 "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SB9.B9_COD = SB1.B1_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "+Chr(13)+Chr(10)
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "+Chr(13)+Chr(10)
cQry += "                				AND SB5.B5_PRODANP = 'S' "+Chr(13)+Chr(10)
cQry += "WHERE "+Chr(13)+Chr(10)
cQry += "SB9.D_E_L_E_T_ <> '*' "   +Chr(13)+Chr(10)
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "+Chr(13)+Chr(10)
cQry += "AND SB9.B9_QINI > 0 "+Chr(13)+Chr(10)
cQry += "AND SB9.B9_DATA = '"+DtoS(MV_PAR02)+"' "+Chr(13)+Chr(10)
cQry += "GROUP BY "+Chr(13)+Chr(10)
cQry += "SB5.B5_CODANP, "+Chr(13)+Chr(10)
cQry += "SB1.B1_CONV, "+Chr(13)+Chr(10)
cQry += "SB9.B9_DATA "+Chr(13)+Chr(10)

cQry += "ORDER BY "+Chr(13)+Chr(10)
cQry += "ESPECIE, "+Chr(13)+Chr(10)
cQry += "EMISSAO "+Chr(13)+Chr(10)

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

TcQuery cQry New Alias "QRY"

DbSelectArea("QRY")
nTotalReg := Contar("QRY", "!Eof()")
QRY->(DbGoTop())

oReport:SetMeter(nTotalReg)

oSection1:Init()
oSection1:SetHeaderSection(.T.)

//A - SALDO INICIAL
//B - COMPRAS
//C - VENDAS
//D - SALDO FINAL

// sobra - 1021001 ( entrada - saldo a mais )
// perda - 1022004 ( requisicao -  )
// formulacao -  1022015 ( consumo para producao )


While QRY->(!Eof())
	//Dados dos clientes/fornecedores
	If AllTrim(QRY->ESPECIE) == "C"
		//
		If !AllTrim(QRY->TIPO) $ "D/B"
			//
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA1->A1_INSTANP
			_cInst1 := If(Empty(_cInst2),"1012002","1012001")
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA1->A1_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("PA2",1,xFilial("PA2")+SA1->A1_COD_MUN,"PA2_CODANP"),"")
			//
		Else
			//
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA2->A2_T_INST
			_cInst1 := If(Empty(_cInst2),"1012005","1012004")
			//	_cInst1 := If(Empty(_cInst2),"1011002","1011001")  // Alterado Felipe 06/7/15
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA2->A2_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("PA2",1,xFilial("PA2")+SA1->A1_COD_MUN,"PA2_CODANP"),"")
			//		
		EndIf
		//
	ElseIf AllTrim(QRY->ESPECIE) == "B"
		//
		If AllTrim(QRY->TIPO) $ "D/B"
			//
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+QRY->CLIFOR+QRY->LOJA))
			//        
			// Felipe - Armi          
			_cInst2 := SA1->A1_INSTANP
			_cInst1 := If(Empty(_cInst2),"1011005","1011004")
			// Original _cInst1 := If(Empty(_cInst2),"1012002","1012001")
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA1->A1_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("PA2",1,xFilial("PA2")+SA1->A1_COD_MUN,"PA2_CODANP"),"")
			//
		Else
			//
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA2->A2_T_INST
			
			If SA2->A2_EST = "EX"
				_cInst1 := "2011001"
			Else
				_cInst1 := If(Empty(_cInst2),"1011002","1011001")
			EndIf
			
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA2->A2_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("PA2",1,xFilial("PA2")+SA1->A1_COD_MUN,"PA2_CODANP"),"")
			//		
		EndIf
		//
	ElseIf AllTrim(QRY->ESPECIE) == "A"
		//
		_cInst2 := "0"
		_cInst1 := "3010003"
		_cCnpj  := "00000000000000"
		_cAtiv  := "0"
		_cLocal := "0"
		//
	ElseIf AllTrim(QRY->ESPECIE) == "D"
		//
		_cInst2 := "0"
		_cInst1 := "3020003"
		_cCnpj  := "00000000000000"
		_cAtiv  := "0"
		_cLocal := "0"
		//
	EndIf
	//
	_nQtdLt := If(QRY->QTDLT-Round(QRY->QTDLT, 0) >= 0.5, Ceiling(QRY->QTDLT), Round(QRY->QTDLT, 0))
	_nQtdKg := If(QRY->QTDKG-Round(QRY->QTDKG, 0) >= 0.5, Ceiling(QRY->QTDKG), Round(QRY->QTDKG, 0))
	
	//==================================================
	// Verifica o tipo de frete para vendas
	//==================================================
	// Por Anderson GonÁalves - AGM System em 19/03/21
	cTpFrete := ""
	If AllTrim(_cInst1) == "1012001" .or. AllTrim(_cInst1) == "1012002"  
		If QRY->FRETE == "C"
			cTpFrete := "10"
		Else
			cTpFrete := "11"
		EndIf
	EndIf
	
	oSection1:Cell("OPERACAO"):SetValue(_cInst1)				//Se for cliente 1012001 ou 1012002; Se for fornecedor 1011001 ou 1011002
	oSection1:Cell("ENT1"):SetValue("ent")						//ent
	oSection1:Cell("INST1"):SetValue("1032993") 				//Fixo, conforme orientaÁ„o do Ademir
	oSection1:Cell("ENT2"):SetValue("ent")						//ent
	oSection1:Cell("INST2"):SetValue(_cInst2)					//A1_INSTANP ou A2_T_INST
	oSection1:Cell("ENT3"):SetValue("ent")						//ent
	oSection1:Cell("PRODUTO"):SetValue(AllTrim(QRY->PRODUTO))	//Produto da NF
	oSection1:Cell("ENT4"):SetValue("ent")						//ent
	oSection1:Cell("LT"):SetValue(_nQtdLt)		   				//D1_QUANT ou D2_QUANT - Arredonda o valor para cima ou para baixo
	oSection1:Cell("ENT5"):SetValue("ent")						//ent
	oSection1:Cell("KG"):SetValue(_nQtdKg)						//D1_QTSEGUM ou D2_QTSEGUM - Arredonda o valor para cima ou para baixo
	oSection1:Cell("ENT6"):SetValue("ent")						//ent
	oSection1:Cell("MODAL"):SetValue(1) 						//Fixo, conforme orientaÁ„o do Ademir
	oSection1:Cell("ENT7"):SetValue("ent")						//ent
	oSection1:Cell("VEICULO"):SetValue("") 						//Em branco
	oSection1:Cell("ENT8"):SetValue("ent")						//ent
	oSection1:Cell("CNPJ"):SetValue(_cCnpj)						//A1_CGC ou A2_CGC
	oSection1:Cell("ENT9"):SetValue("ent")						//ent
	oSection1:Cell("LOCAL"):SetValue(_cLocal)					//CC2_CODANP
	oSection1:Cell("ENT10"):SetValue("ent")						//ent
	oSection1:Cell("ATIVIDADE"):SetValue(_cAtiv)				//Se instalaÁ„o 2 for vazio = "46842"
	oSection1:Cell("ENT11"):SetValue("ent")						//ent
	oSection1:Cell("PAIS"):SetValue("") 						//Em branco
	oSection1:Cell("ENT12"):SetValue("ent")						//ent
	oSection1:Cell("LI"):SetValue("") 							//Em branco
	oSection1:Cell("ENT13"):SetValue("ent")						//ent
	oSection1:Cell("DI"):SetValue("") 							//Em branco
	oSection1:Cell("ENT14"):SetValue("ent")						//ent
	oSection1:Cell("NOTA"):SetValue("")							//Em branco
	oSection1:Cell("ENT15"):SetValue("ent")						//ent
	oSection1:Cell("SERIE"):SetValue("")						//Em branco
	oSection1:Cell("ENT16"):SetValue("ent")						//ent
	oSection1:Cell("DATA"):SetValue(DtoC(StoD(QRY->EMISSAO)))	//F2_EMISSAO ou F1_DTDIGIT
	oSection1:Cell("ENT17"):SetValue("ent")						//ent
	oSection1:Cell("TS"):SetValue("")							//Em branco
	oSection1:Cell("ENT18"):SetValue("ent")						//ent
	oSection1:Cell("CCP"):SetValue("")							//Em branco
	oSection1:Cell("ENT19"):SetValue("ent")						//ent
	oSection1:Cell("CMA"):SetValue("")							//Em branco
	oSection1:Cell("ENT20"):SetValue("ent")						//ent
	oSection1:Cell("UMC"):SetValue(cTpFrete)					//Em branco
	oSection1:Cell("ENT21"):SetValue("ent")						//ent
	oSection1:Cell("VC"):SetValue("")							//Em branco
	oSection1:Cell("ENT22"):SetValue("ent")						//ent
	oSection1:Cell("P/OR"):SetValue("")							//Em branco
	oSection1:Cell("ENT23"):SetValue("ent")						//ent
	If AllTrim(_cInst1) == "1012001" .or. AllTrim(_cInst1) == "1012002"
		oSection1:Cell("MASSA"):SetValue(Transform(QRY->DENSIDADE,"@E 999,999.9999"))	//B1_CONV * 1000
	Else
		oSection1:Cell("MASSA"):SetValue(Transform(QRY->DENSIDADE*1000,"@E 999,999.9999"))	//B1_CONV * 1000
	EndIf
	oSection1:Cell("ENT24"):SetValue("ent")						//ent
	oSection1:Cell("EMBALAGEM"):SetValue("")					//Em branco
	oSection1:Cell("ENT25"):SetValue("ent")						//ent
	oSection1:Cell("CHAVE"):SetValue(AllTrim(QRY->CHAVENFE))	//Chave da NF eletrÙnica
	oSection1:Cell("ENT26"):SetValue("ent")						//ent
	//
	oSection1:PrintLine()
	//
	oReport:IncMeter()
	//
	QRY->(DbSkip())
	//
EndDo

oSection1:Finish()

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

Return()
