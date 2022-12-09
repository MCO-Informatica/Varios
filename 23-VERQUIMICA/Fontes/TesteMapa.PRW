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

User Function TESTEMAPA()

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
           

//Vendas
cQry := "SELECT "
cQry += "'C' AS ESPECIE, "
cQry += "SF2.F2_TIPO AS TIPO, "
cQry += "SF2.F2_CLIENTE AS CLIFOR, "
cQry += "SF2.F2_LOJA AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SD2.D2_QUANT) AS QTDKG, "
cQry += "SUM(SD2.D2_QTSEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "SF2.F2_EMISSAO AS EMISSAO, "
cQry += "SF2.F2_CHVNFE AS CHAVENFE "
cQry += "FROM "
cQry += RetSQLName("SF2")+" SF2 "
cQry += "JOIN "+RetSQLName("SD2")+" SD2 ON  SF2.F2_DOC = SD2.D2_DOC "
cQry += "                				AND SF2.F2_SERIE = SD2.D2_SERIE "
cQry += "                				AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
cQry += "                				AND SF2.F2_LOJA = SD2.D2_LOJA "
cQry += "                				AND SD2.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD2.D2_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "

cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD2.D2_TES "
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "
//cQry += "                				AND SF4.F4_ESTOQUE = 'S' "
//cQry += "                				AND SF4.F4_DUPLIC = 'S' "

cQry += "WHERE "                                           
cQry += "SF2.D_E_L_E_T_ <> '*' "      
cQry += "AND SF2.F2_FILIAL = '" +xFilial("SF2")+ "' "
cQry += "AND SD2.D2_FILIAL = '" +xFilial("SD2")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "
cQry += "AND SF2.F2_TIPO NOT IN ('C', 'I', 'P') "
cQry += "AND SF2.F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQry += "GROUP BY "
cQry += "SF2.F2_CLIENTE, "
cQry += "SF2.F2_LOJA, "
cQry += "SF2.F2_TIPO, "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SF2.F2_EMISSAO, "
cQry += "SF2.F2_CHVNFE "

cQry += "UNION ALL "

//Compras
cQry += "SELECT "
cQry += "'B' AS ESPECIE, "
cQry += "SF1.F1_TIPO AS TIPO, "
cQry += "SF1.F1_FORNECE AS CLIFOR, "
cQry += "SF1.F1_LOJA AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SD1.D1_QUANT) AS QTDKG, "
cQry += "SUM(SD1.D1_QTSEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "SF1.F1_DTDIGIT AS EMISSAO, "
cQry += "SF1.F1_CHVNFE AS CHAVENFE "
cQry += "FROM "
cQry += RetSQLName("SF1")+" SF1 "
cQry += "JOIN "+RetSQLName("SD1")+" SD1 ON  SF1.F1_DOC = SD1.D1_DOC "
cQry += "                				AND SF1.F1_SERIE = SD1.D1_SERIE "
cQry += "                				AND SF1.F1_FORNECE = SD1.D1_FORNECE "
cQry += "                				AND SF1.F1_LOJA = SD1.D1_LOJA "
cQry += "                				AND SD1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD1.D1_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "

cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD1.D1_TES "
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "
//cQry += "                				AND SF4.F4_ESTOQUE = 'S' "
//cQry += "                				AND SF4.F4_DUPLIC = 'S'  "

cQry += "WHERE "
cQry += "SF1.D_E_L_E_T_ <> '*' "     
cQry += "AND SF1.F1_FILIAL = '" +xFilial("SF1")+ "' "
cQry += "AND SD1.D1_FILIAL = '" +xFilial("SD1")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "
cQry += "AND SF1.F1_TIPO NOT IN ('C', 'I', 'P') "
cQry += "AND SF1.F1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQry += "GROUP BY "
cQry += "SF1.F1_FORNECE, "
cQry += "SF1.F1_LOJA, "
cQry += "SF1.F1_TIPO, "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SF1.F1_DTDIGIT, "
cQry += "SF1.F1_CHVNFE "

cQry += "UNION ALL "

//Saldo Inicial
cQry += "SELECT "
cQry += "'A' AS ESPECIE, "
cQry += "'' AS TIPO, "
cQry += "'' AS CLIFOR, "
cQry += "'' AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "'"+DtoS(MV_PAR01)+"' AS EMISSAO, "
cQry += "RPAD('0', 44, '0') AS CHAVENFE "
cQry += "FROM "
cQry += RetSQLName("SB9")+" SB9 "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SB9.B9_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "WHERE "
cQry += "SB9.D_E_L_E_T_ <> '*' "  
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SB9.B9_QINI > 0 "
cQry += "AND SB9.B9_DATA = '"+DtoS(MV_PAR01-1)+"' "
cQry += "GROUP BY "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SB9.B9_DATA "

cQry += "UNION ALL "

//Saldo Final
cQry += "SELECT "
cQry += "'D' AS ESPECIE, "
cQry += "'' AS TIPO, "
cQry += "'' AS CLIFOR, "
cQry += "'' AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "SB9.B9_DATA AS EMISSAO, "
cQry += "RPAD('0', 44, '0') AS CHAVENFE "
cQry += "FROM "
cQry += RetSQLName("SB9")+" SB9 "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SB9.B9_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "WHERE "
cQry += "SB9.D_E_L_E_T_ <> '*' "   
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SB9.B9_QINI > 0 "
cQry += "AND SB9.B9_DATA = '"+DtoS(MV_PAR02)+"' "
cQry += "GROUP BY "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SB9.B9_DATA "

cQry += "ORDER BY "
cQry += "ESPECIE, "
cQry += "EMISSAO "

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
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN),"CC2_CODANP"),"")
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
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA2->(A2_EST+A2_COD_MUN),"CC2_CODANP"),"")
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
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN),"CC2_CODANP"),"")
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
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA2->(A2_EST+A2_COD_MUN),"CC2_CODANP"),"")
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
	//
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
	oSection1:Cell("UMC"):SetValue("")							//Em branco
	oSection1:Cell("ENT21"):SetValue("ent")						//ent
	oSection1:Cell("VC"):SetValue("")							//Em branco
	oSection1:Cell("ENT22"):SetValue("ent")						//ent
	oSection1:Cell("P/OR"):SetValue("")							//Em branco
	oSection1:Cell("ENT23"):SetValue("ent")						//ent
	oSection1:Cell("MASSA"):SetValue(QRY->DENSIDADE*1000)		//B1_CONV * 1000
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