#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE DMPAPER_A4 9
#DEFINE CRLF (Chr(13)+Chr(10))

/*/{Protheus.doc} RCOMVEND
//TODO Relatório que demonstra as comissões por vendedor.
@author		Nelson Junior
@since		26/01/15
@version 	v001.02
@type		Function
@history	14/01/2020, Roberto Ramos, Problemas com variavel local e tambem aparecendo janela com a query do relatorio; 
/*/
User Function rComVend()

Local oReport
Private cCodVenPg := U_CFMPGVEN()

oReport := reportDef()
oReport:printDialog()

Return()

/*/{Protheus.doc} reportDef
//TODO Definições do Relatório que demonstra as comissões por vendedor.
@author		Nelson Junior
@since		26/01/15
@version 	v001.02
@type		Function
@history	14/01/2020, Roberto Ramos, Problemas com variavel local e tambem aparecendo janela com a query do relatorio; 
/*/
Static Function reportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4
Local oSection5
Local oSection6
Local oSection7
Local oSection8
Local cTitulo := 'Comissões por Vendedor'

oReport:=TReport():New("RCOMVEND", cTitulo, "RCOMVEND", {|oReport| PrintReport(oReport)}, "Demonstra as comissões por vendedores.")
oReport:SetPortrait() //Retrato
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()
oReport:HideParamPage()  

PutSX1("RCOMVEND","01","Emissão de"	,"","","MV_CH1","D",08,0,0,"G","",""   ,"","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSX1("RCOMVEND","02","Emissão ate","","","MV_CH2","D",08,0,0,"G","",""   ,"","","MV_PAR02","","","","","","","","","","","","","","","","","","","")
PutSX1("RCOMVEND","03","Vendedor"	,"","","MV_CH3","C",06,0,0,"G","","SA3","","","MV_PAR03","","","","","","","","","","","","","","","","","","","")
PutSX1("RCOMVEND","04","Divisão"	,"","","MV_CH4","C",06,0,0,"G","","ACY","","","MV_PAR04","","","","","","","","","","","","","","","","","","","")
PutSX1("RCOMVEND","05","Região"		,"","","MV_CH5","C",03,0,0,"G","","Z06","","","MV_PAR05","","","","","","","","","","","","","","","","","","","")
PutSX1("RCOMVEND","06","Tipo"		,"","","MV_CH6","N",01,0,0,"C","",""   ,"","","MV_PAR06","Detalhado","","","","Resumido","","","","","","","","","","","","","","")

Pergunte(oReport:uParam,.F.)

If !Empty(cCodVenPg) .AND. cCodVenPg <> '000001'
	MV_PAR03 := cCodVenPg
EndIf

oSection1 := TRSection():New(oReport)
oSection1:SetTotalInLine(.F.)

oSection2 := TRSection():New(oReport)
oSection2:SetTotalInLine(.F.)

oSection3 := TRSection():New(oReport)
oSection3:SetTotalInLine(.F.)

oSection4 := TRSection():New(oReport)
oSection4:SetTotalInLine(.F.)

oSection5 := TRSection():New(oReport)
oSection5:SetTotalInLine(.F.)

oSection6 := TRSection():New(oReport)
oSection6:SetTotalInLine(.F.)

oSection7 := TRSection():New(oReport)
oSection7:SetTotalInLine(.F.)

oSection8 := TRSection():New(oReport)
oSection8:SetTotalInLine(.F.)

TRCell():New(oSection1,"VENDEDOR",,"Vendedor","@!",254,,,"LEFT",,"LEFT")

TRCell():New(oSection2,"ZONA"	 ,,"Zona"	 ,"@!",254,,,"LEFT",,"LEFT")

TRCell():New(oSection3,"DIVISAO" ,,"Divisão" ,"@!",254,,,"LEFT",,"LEFT")

TRCell():New(oSection4,"EMISSAO",,"Emissão",PesqPict("SD2","D2_EMISSAO"),TamSX3("D2_EMISSAO")[1]+3,,,"LEFT",,"LEFT")
TRCell():New(oSection4,"NOTA",,"NF",PesqPict("SD2","D2_DOC"),TamSX3("D2_DOC")[1]+3,,,"LEFT",,"LEFT")
TRCell():New(oSection4,"PEDIDO",,"Pedido",PesqPict("SD2","D2_PEDIDO"),TamSX3("D2_PEDIDO")[1]+3,,,"LEFT",,"LEFT")
TRCell():New(oSection4,"CLIENTE",,"Cliente",PesqPict("SA1","A1_NREDUZ"),TamSX3("A1_NREDUZ")[1]+1,,,"LEFT",,"LEFT")
TRCell():New(oSection4,"ESTADO",,"Estado",PesqPict("SA1","A1_EST"),TamSX3("A1_EST")[1]+1,,,"LEFT",,"LEFT")
TRCell():New(oSection4,"MUNICIPIO",,"Municipio",PesqPict("SA1","A1_MUN"),TamSX3("A1_MUN")[1]+1,,,"LEFT",,"LEFT")
TRCell():New(oSection4,"PRODUTO",,"Produto",PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1]+1,,,"LEFT",,"LEFT")
TRCell():New(oSection4,"VLVENDA",,"Valor Venda",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"TABELA",,"Tabela",PesqPict("SD2","D2_VQ_TABE"),TamSX3("D2_VQ_TABE")[1]+1,,,"CENTER",,"CENTER")
TRCell():New(oSection4,"PERCOMIS",,"% Comis.",PesqPict("SD2","D2_COMIS1"),TamSX3("D2_COMIS1")[1]+1,,,"CENTER",,"CENTER")
TRCell():New(oSection4,"VLCOMIS",,"Valor Comis.",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")

TRCell():New(oSection5,"DESCRI",,"Total da Divisão",,35,,,"LEFT",,"LEFT")
TRCell():New(oSection5,"TAB_A",,"Tabela A",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"TAB_B",,"Tabela B",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"TAB_C",,"Tabela C",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"TAB_D",,"Tabela D",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"TAB_E",,"Tabela E",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection5,"TAB_TOT",,"Total",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")

TRCell():New(oSection6,"DESCRI",,"Total da Zona",,35,,,"LEFT",,"LEFT")
TRCell():New(oSection6,"TAB_A",,"Tabela A",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"TAB_B",,"Tabela B",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"TAB_C",,"Tabela C",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"TAB_D",,"Tabela D",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"TAB_E",,"Tabela E",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection6,"TAB_TOT",,"Total",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")

TRCell():New(oSection7,"DESCRI",,"Total do Vendedor",,35,,,"LEFT",,"LEFT")
TRCell():New(oSection7,"TAB_A",,"Tabela A",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"TAB_B",,"Tabela B",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"TAB_C",,"Tabela C",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"TAB_D",,"Tabela D",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"TAB_E",,"Tabela E",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection7,"TAB_TOT",,"Total",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")

TRCell():New(oSection8,"DESCRI",,"Total do Relatório",,35,,,"LEFT",,"LEFT")
TRCell():New(oSection8,"TAB_A",,"Tabela A",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection8,"TAB_B",,"Tabela B",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection8,"TAB_C",,"Tabela C",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection8,"TAB_D",,"Tabela D",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection8,"TAB_E",,"Tabela E",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")
TRCell():New(oSection8,"TAB_TOT",,"Total",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL")[1]+1,,,"RIGHT",,"RIGHT")

Return(oReport)

/*/{Protheus.doc} PrintReport
//TODO Impressão do Relatório que demonstra as comissões por vendedor.
@author		Nelson Junior
@since		26/01/15
@version 	v001.02
@type		Function
@history	14/01/2020, Roberto Ramos, Problemas com variavel local e tambem aparecendo janela com a query do relatorio; 
/*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local oSection4 := oReport:Section(4)
Local oSection5 := oReport:Section(5)
Local oSection6 := oReport:Section(6)
Local oSection7 := oReport:Section(7)
Local oSection8 := oReport:Section(8)

Local aDiviV := {}
Local aZonaV := {}
Local aVendV := {}
Local aRelaV := {}

Local aDiviC := {}
Local aZonaC := {}
Local aVendC := {}
Local aRelaC := {}

Local cDivi := ""
Local cZona := ""
Local cVend := ""
Local i

cQry := "SELECT "
cQry += "SF2.F2_VEND1, "
cQry += "SD2.D2_EMISSAO, "
cQry += "SD2.D2_DOC, "
cQry += "SD2.D2_PEDIDO, "
cQry += "SA1.A1_COD, "
cQry += "SA1.A1_LOJA, "
cQry += "SA1.A1_EST, "
cQry += "SA1.A1_MUN, "
cQry += "SA1.A1_REGIAO, "
cQry += "SA1.A1_GRPVEN, "
cQry += "SD2.D2_COD, "
cQry += "SD2.D2_TOTAL, "
cQry += "SD2.D2_VQ_TABE, "
cQry += "SD2.D2_COMIS1, "
cQry += "(SD2.D2_TOTAL*SD2.D2_COMIS1)/100 AS VLCOMIS "
cQry += "FROM "
cQry += RetSQLName("SF2")+" SF2 "
cQry += "JOIN "+RetSQLName("SD2")+" SD2 ON  SF2.F2_DOC = SD2.D2_DOC "
cQry += "								AND SF2.F2_SERIE = SD2.D2_SERIE "
cQry += "								AND SF2.F2_CLIENT = SD2.D2_CLIENTE "
cQry += "								AND SF2.F2_LOJA = SD2.D2_LOJA "
cQry += "								AND SD2.D_E_L_E_T_ <> '*' "
cQry += "								AND SD2.D2_COMIS1 <> 0 "
cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SD2.D2_TES = SF4.F4_CODIGO "
cQry += "								AND SF4.D_E_L_E_T_ <> '*' "
cQry += "								AND SF4.F4_DUPLIC = 'S' "
cQry += "JOIN "+RetSQLName("SA1")+" SA1 ON  SF2.F2_CLIENT = SA1.A1_COD "
cQry += "								AND SF2.F2_LOJA = SA1.A1_LOJA "
cQry += "								AND SA1.D_E_L_E_T_ <> '*' "
//
//Filtro - Divisão
If !Empty(MV_PAR04)
	cQry += "							AND SA1.A1_GRPVEN = '"+MV_PAR04+"' "
EndIf
//
//Filtro - Região
If !Empty(MV_PAR05)
	cQry += "							AND SA1.A1_REGIAO = '"+MV_PAR05+"' "
EndIf
//
cQry += "WHERE "
cQry += "SF2.D_E_L_E_T_ <> '*' "
cQry += "AND SF2.F2_VEND1 <> '' "
//
//Filtro - Emissão
If !Empty(MV_PAR01)
	cQry += "AND SF2.F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
EndIf
//
//Filtro - Vendedor
If !Empty(cCodVenPg) .AND. cCodVenPg <> '000001'
	MV_PAR03 := cCodVenPg
EndIf
If !Empty(MV_PAR03)
	cQry += "AND SF2.F2_VEND1 = '"+MV_PAR03+"' "
EndIf
//
//UNION para tratar as devoluções
cQry += "UNION ALL "
//
cQry += "SELECT "
cQry += "SF2.F2_VEND1, "
cQry += "SD1.D1_DTDIGIT AS D2_EMISSAO, "
cQry += "SD1.D1_DOC AS D2_DOC, "
cQry += "SD2.D2_PEDIDO, "
cQry += "SA1.A1_COD, "
cQry += "SA1.A1_LOJA, "
cQry += "SA1.A1_EST, "
cQry += "SA1.A1_MUN, "
cQry += "SA1.A1_REGIAO, "
cQry += "SA1.A1_GRPVEN, "
cQry += "SD2.D2_COD, "
cQry += "(SD1.D1_TOTAL-SD1.D1_VALDESC)*-1 AS D2_TOTAL, "
cQry += "SD2.D2_VQ_TABE, "
cQry += "SD2.D2_COMIS1, "
cQry += "(((SD1.D1_TOTAL-SD1.D1_VALDESC)*SD2.D2_COMIS1)/100)*-1 AS VLCOMIS "
cQry += "FROM "
cQry += RetSQLName("SF2")+" SF2 "
cQry += "JOIN "+RetSQLName("SD2")+" SD2 ON  SF2.F2_DOC = SD2.D2_DOC "
cQry += "								AND SF2.F2_SERIE = SD2.D2_SERIE "
cQry += "								AND SF2.F2_CLIENT = SD2.D2_CLIENTE "
cQry += "								AND SF2.F2_LOJA = SD2.D2_LOJA "
cQry += "								AND SD2.D_E_L_E_T_ <> '*' "
cQry += "								AND SD2.D2_COMIS1 <> 0 "
cQry += "JOIN "+RetSQLName("SA1")+" SA1 ON  SF2.F2_CLIENT = SA1.A1_COD "
cQry += "								AND SF2.F2_LOJA = SA1.A1_LOJA "
cQry += "								AND SA1.D_E_L_E_T_ <> '*' "
//
//Filtro - Divisão
If !Empty(MV_PAR04)
	cQry += "							AND SA1.A1_GRPVEN = '"+MV_PAR04+"' "
EndIf
//
//Filtro - Região
If !Empty(MV_PAR05)
	cQry += "							AND SA1.A1_REGIAO = '"+MV_PAR05+"' "
EndIf
//
cQry += "JOIN "+RetSQLName("SD1")+" SD1 ON  SD2.D2_DOC = SD1.D1_NFORI "
cQry += "								AND SD2.D2_SERIE = SD1.D1_SERIORI "
cQry += "								AND SD2.D2_ITEM = SD1.D1_ITEMORI "
cQry += "								AND SD2.D2_COD = SD1.D1_COD "
cQry += "								AND SD2.D2_CLIENTE = SD1.D1_FORNECE "
cQry += "								AND SD2.D2_LOJA = SD1.D1_LOJA "
cQry += "								AND SD1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SD1.D1_TES = SF4.F4_CODIGO "
cQry += "								AND SF4.D_E_L_E_T_ <> '*' "
cQry += "								AND SF4.F4_DUPLIC = 'S' "
cQry += "WHERE "
cQry += "SF2.D_E_L_E_T_ <> '*' "
cQry += "AND SF2.F2_VEND1 <> '' "
//
//Filtro - Emissão
If !Empty(MV_PAR01)
//	cQry += "AND SF2.F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
	cQry += "AND SD1.D1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
EndIf
//
//Filtro - Vendedor
If !Empty(MV_PAR03)
	cQry += "AND SF2.F2_VEND1 = '"+MV_PAR03+"' "
EndIf
//
cQry += "ORDER BY "
cQry += "F2_VEND1, "
cQry += "A1_REGIAO, "
cQry += "A1_GRPVEN, "
cQry += "D2_EMISSAO, "
cQry += "D2_DOC "

cQry := ChangeQuery(cQry)
//eecview(cQry) retirado da tela que demonstrava a query antes da impressão
TCQUERY cQry NEW ALIAS "QRY"
MemoWrite("C:\temp\rcomvend.txt",cQry)
//ALERT("teste")
 
DbSelectArea("QRY")

nTotalReg := Contar("QRY", "!EoF()")
QRY->(dbGoTop())

oReport:SetMeter(nTotalReg)

While QRY->(!EoF())
	//
	If cVend <> QRY->F2_VEND1
		//
		If !Empty(cVend)
			//
			oSection4:Finish()
			//
			oReport:IncRow()
			//
			//Início do total da Divisão
			oSection5:Init()
			oSection5:SetHeaderSection(.T.)
			//
			//Total de vendas
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aDiviV)
				nTabA += aDiviV[i][1]
				nTabB += aDiviV[i][2]
				nTabC += aDiviV[i][3]
				nTabD += aDiviV[i][4]
				nTabE += aDiviV[i][5]
				nTabT += aDiviV[i][6]
			Next
			//
			If !Empty(aDiviV)
				//
				oSection5:Cell("DESCRI"):SetValue("Total de vendas:")
				oSection5:Cell("TAB_A"):SetValue(nTabA)
				oSection5:Cell("TAB_B"):SetValue(nTabB)
				oSection5:Cell("TAB_C"):SetValue(nTabC)
				oSection5:Cell("TAB_D"):SetValue(nTabD)
				oSection5:Cell("TAB_E"):SetValue(nTabE)
				oSection5:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection5:PrintLine()
				EndIf
				//
				nTotalA := (100*nTabA)/nTabT
				nTotalB := (100*nTabB)/nTabT
				nTotalC := (100*nTabC)/nTabT
				nTotalD := (100*nTabD)/nTabT
				nTotalE := (100*nTabE)/nTabT
				//
			EndIf
			//
			//Total de comissões
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aDiviC)
				nTabA += aDiviC[i][1]
				nTabB += aDiviC[i][2]
				nTabC += aDiviC[i][3]
				nTabD += aDiviC[i][4]
				nTabE += aDiviC[i][5]
				nTabT += aDiviC[i][6]
			Next
			//
			If !Empty(aDiviV)
				//
				oSection5:Cell("DESCRI"):SetValue("Total de comissões:")
				oSection5:Cell("TAB_A"):SetValue(nTabA)
				oSection5:Cell("TAB_B"):SetValue(nTabB)
				oSection5:Cell("TAB_C"):SetValue(nTabC)
				oSection5:Cell("TAB_D"):SetValue(nTabD)
				oSection5:Cell("TAB_E"):SetValue(nTabE)
				oSection5:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection5:PrintLine()
				EndIf
				//
			EndIf
			//
			//Porcentagem (%) sobre o faturamento
			//
			If !Empty(aZonaV)
				//
				oSection5:Cell("DESCRI"):SetValue("% s/ faturamento:")
				oSection5:Cell("TAB_A"):SetValue(nTotalA)
				oSection5:Cell("TAB_B"):SetValue(nTotalB)
				oSection5:Cell("TAB_C"):SetValue(nTotalC)
				oSection5:Cell("TAB_D"):SetValue(nTotalD)
				oSection5:Cell("TAB_E"):SetValue(nTotalE)
				oSection5:Cell("TAB_TOT"):Hide()
				//
				If MV_PAR06 == 1
					oSection5:PrintLine()
				EndIf
				//
				oSection5:Cell("TAB_TOT"):Show()
				//
			EndIf
			//
			oSection5:Finish()
			//
			aDiviV := {}
			aDiviC := {}
			//
			//Fim do total da Divisão
			//
			//Início do total da Zona
			oSection6:Init()
			oSection6:SetHeaderSection(.T.)
			//
			//Total de vendas
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aZonaV)
				nTabA += aZonaV[i][1]
				nTabB += aZonaV[i][2]
				nTabC += aZonaV[i][3]
				nTabD += aZonaV[i][4]
				nTabE += aZonaV[i][5]
				nTabT += aZonaV[i][6]
			Next
			//
			If !Empty(aZonaV)
				//
				oSection6:Cell("DESCRI"):SetValue("Total de vendas:")
				oSection6:Cell("TAB_A"):SetValue(nTabA)
				oSection6:Cell("TAB_B"):SetValue(nTabB)
				oSection6:Cell("TAB_C"):SetValue(nTabC)
				oSection6:Cell("TAB_D"):SetValue(nTabD)
				oSection6:Cell("TAB_E"):SetValue(nTabE)
				oSection6:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection6:PrintLine()
				EndIf
				//
				nTotalA := (100*nTabA)/nTabT
				nTotalB := (100*nTabB)/nTabT
				nTotalC := (100*nTabC)/nTabT
				nTotalD := (100*nTabD)/nTabT
				nTotalE := (100*nTabE)/nTabT
				//
			EndIf
			//
			//Total de comissões
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aZonaC)
				nTabA += aZonaC[i][1]
				nTabB += aZonaC[i][2]
				nTabC += aZonaC[i][3]
				nTabD += aZonaC[i][4]
				nTabE += aZonaC[i][5]
				nTabT += aZonaC[i][6]
			Next
			//
			If !Empty(aZonaC)
				//
				oSection6:Cell("DESCRI"):SetValue("Total de comissões:")
				oSection6:Cell("TAB_A"):SetValue(nTabA)
				oSection6:Cell("TAB_B"):SetValue(nTabB)
				oSection6:Cell("TAB_C"):SetValue(nTabC)
				oSection6:Cell("TAB_D"):SetValue(nTabD)
				oSection6:Cell("TAB_E"):SetValue(nTabE)
				oSection6:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection6:PrintLine()
				EndIf
				//
			EndIf
			//
			//Porcentagem (%) sobre o faturamento
			//
			If !Empty(aZonaV)
				oSection6:Cell("DESCRI"):SetValue("% s/ faturamento:")
				oSection6:Cell("TAB_A"):SetValue(nTotalA)
				oSection6:Cell("TAB_B"):SetValue(nTotalB)
				oSection6:Cell("TAB_C"):SetValue(nTotalC)
				oSection6:Cell("TAB_D"):SetValue(nTotalD)
				oSection6:Cell("TAB_E"):SetValue(nTotalE)
				oSection6:Cell("TAB_TOT"):Hide()
				//
				If MV_PAR06 == 1
					oSection6:PrintLine()
				EndIf
				//
				oSection6:Cell("TAB_TOT"):Show()
			EndIf
			//
			oSection6:Finish()
			//
			aZonaV := {}
			aZonaC := {}
			//
			//Fim do total da Zona
			//
			//Início do total do Vendedor
			oSection7:Init()
			oSection7:SetHeaderSection(.T.)
			//
			//Total de vendas
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aVendV)
				nTabA += aVendV[i][1]
				nTabB += aVendV[i][2]
				nTabC += aVendV[i][3]
				nTabD += aVendV[i][4]
				nTabE += aVendV[i][5]
				nTabT += aVendV[i][6]
			Next
			//
			If !Empty(aVendV)
				oSection7:Cell("DESCRI"):SetValue("Total de vendas:")
				oSection7:Cell("TAB_A"):SetValue(nTabA)
				oSection7:Cell("TAB_B"):SetValue(nTabB)
				oSection7:Cell("TAB_C"):SetValue(nTabC)
				oSection7:Cell("TAB_D"):SetValue(nTabD)
				oSection7:Cell("TAB_E"):SetValue(nTabE)
				oSection7:Cell("TAB_TOT"):SetValue(nTabT)
				oSection7:PrintLine()
				//
				nTotalA := (100*nTabA)/nTabT
				nTotalB := (100*nTabB)/nTabT
				nTotalC := (100*nTabC)/nTabT
				nTotalD := (100*nTabD)/nTabT
				nTotalE := (100*nTabE)/nTabT
				//
			EndIf
			//
			//Total de comissões
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aVendC)
				nTabA += aVendC[i][1]
				nTabB += aVendC[i][2]
				nTabC += aVendC[i][3]
				nTabD += aVendC[i][4]
				nTabE += aVendC[i][5]
				nTabT += aVendC[i][6]
			Next
			//
			If !Empty(aVendC)
				oSection7:Cell("DESCRI"):SetValue("Total de comissões:")
				oSection7:Cell("TAB_A"):SetValue(nTabA)
				oSection7:Cell("TAB_B"):SetValue(nTabB)
				oSection7:Cell("TAB_C"):SetValue(nTabC)
				oSection7:Cell("TAB_D"):SetValue(nTabD)
				oSection7:Cell("TAB_E"):SetValue(nTabE)
				oSection7:Cell("TAB_TOT"):SetValue(nTabT)
				oSection7:PrintLine()
			EndIf
			//
			//Porcentagem (%) sobre o faturamento
			//
			If !Empty(aVendV)
				oSection7:Cell("DESCRI"):SetValue("% s/ faturamento:")
				oSection7:Cell("TAB_A"):SetValue(nTotalA)
				oSection7:Cell("TAB_B"):SetValue(nTotalB)
				oSection7:Cell("TAB_C"):SetValue(nTotalC)
				oSection7:Cell("TAB_D"):SetValue(nTotalD)
				oSection7:Cell("TAB_E"):SetValue(nTotalE)
				oSection7:Cell("TAB_TOT"):Hide()
				oSection7:PrintLine()
				oSection7:Cell("TAB_TOT"):Show()
			EndIf
			//
			oSection7:Finish()
			//
			aVendV := {}
			aVendC := {}
			//
			//Fim do total da Vendedor
			//
			oReport:IncRow()
			//
		EndIf
		//
		oReport:FatLine()
		//
		oSection1:Init()
		oSection1:SetHeaderSection(.F.)
		
		oSection1:Cell("VENDEDOR"):SetValue("Vendedor: "+AllTrim(QRY->F2_VEND1)+" - "+Posicione("SA3",1,xFilial("SA3")+QRY->F2_VEND1,"A3_NOME"))
		oSection1:Cell("VENDEDOR"):lBold := .T.
		oSection1:PrintLine()
		oSection1:Finish()
		//		
		oSection2:Init()
		oSection2:SetHeaderSection(.F.)
		
		oSection2:Cell("ZONA"):SetValue("Zona: "+AllTrim(QRY->A1_REGIAO)+" - "+Posicione("Z06",1,xFilial("Z06")+QRY->A1_REGIAO,"Z06_DESCRI"))
		//
		If MV_PAR06 == 1
			oSection2:PrintLine()
		EndIf
		//
		oSection2:Finish()
		//		
		oSection3:Init()
		oSection3:SetHeaderSection(.F.)
	
		oSection3:Cell("DIVISAO"):SetValue("Divisão: "+AllTrim(QRY->A1_GRPVEN)+" - "+Posicione("ACY",1,xFilial("ACY")+QRY->A1_GRPVEN,"ACY_DESCRI"))
		//
		If MV_PAR06 == 1
			oSection3:PrintLine()
		EndIf
		//
		oSection3:Finish()
		//
		oSection4:Init()
		oSection4:SetHeaderSection(.T.)
		//
	ElseIf cDivi <> QRY->A1_GRPVEN .Or. cZona <> QRY->A1_REGIAO
		//
		oSection4:Finish()
		//
		If MV_PAR06 == 1
			oReport:IncRow()
		EndIf
		//
		If cDivi <> QRY->A1_GRPVEN
			//
			//Início do total da Divisão
			oSection5:Init()
			oSection5:SetHeaderSection(.T.)
			//
			//Total de vendas
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aDiviV)
				nTabA += aDiviV[i][1]
				nTabB += aDiviV[i][2]
				nTabC += aDiviV[i][3]
				nTabD += aDiviV[i][4]
				nTabE += aDiviV[i][5]
				nTabT += aDiviV[i][6]
			Next
			//
			If !Empty(aDiviV)
				oSection5:Cell("DESCRI"):SetValue("Total de vendas:")
				oSection5:Cell("TAB_A"):SetValue(nTabA)
				oSection5:Cell("TAB_B"):SetValue(nTabB)
				oSection5:Cell("TAB_C"):SetValue(nTabC)
				oSection5:Cell("TAB_D"):SetValue(nTabD)
				oSection5:Cell("TAB_E"):SetValue(nTabE)
				oSection5:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection5:PrintLine()
				EndIf
				//
				nTotalA := (100*nTabA)/nTabT
				nTotalB := (100*nTabB)/nTabT
				nTotalC := (100*nTabC)/nTabT
				nTotalD := (100*nTabD)/nTabT
				nTotalE := (100*nTabE)/nTabT
				//
			EndIf
			//
			//Total de comissões
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aDiviC)
				nTabA += aDiviC[i][1]
				nTabB += aDiviC[i][2]
				nTabC += aDiviC[i][3]
				nTabD += aDiviC[i][4]
				nTabE += aDiviC[i][5]
				nTabT += aDiviC[i][6]
			Next
			//
			If !Empty(aDiviV)
				oSection5:Cell("DESCRI"):SetValue("Total de comissões:")
				oSection5:Cell("TAB_A"):SetValue(nTabA)
				oSection5:Cell("TAB_B"):SetValue(nTabB)
				oSection5:Cell("TAB_C"):SetValue(nTabC)
				oSection5:Cell("TAB_D"):SetValue(nTabD)
				oSection5:Cell("TAB_E"):SetValue(nTabE)
				oSection5:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection5:PrintLine()
				EndIf
				//
			EndIf
			//
			//Porcentagem (%) sobre o faturamento
			//
			If !Empty(aZonaV)
				oSection5:Cell("DESCRI"):SetValue("% s/ faturamento:")
				oSection5:Cell("TAB_A"):SetValue(nTotalA)
				oSection5:Cell("TAB_B"):SetValue(nTotalB)
				oSection5:Cell("TAB_C"):SetValue(nTotalC)
				oSection5:Cell("TAB_D"):SetValue(nTotalD)
				oSection5:Cell("TAB_E"):SetValue(nTotalE)
				oSection5:Cell("TAB_TOT"):Hide()
				//
				If MV_PAR06 == 1
					oSection5:PrintLine()
				EndIf
				//
				oSection5:Cell("TAB_TOT"):Show()
			EndIf
			//
			oSection5:Finish()
			//
			aDiviV := {}
			aDiviC := {}
			//
			//Fim do total da Divisão
		EndIf
		//
		If cZona <> QRY->A1_REGIAO
			//
			//Início do total da Zona
			oSection6:Init()
			oSection6:SetHeaderSection(.T.)
			//
			//Total de vendas
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aZonaV)
				nTabA += aZonaV[i][1]
				nTabB += aZonaV[i][2]
				nTabC += aZonaV[i][3]
				nTabD += aZonaV[i][4]
				nTabE += aZonaV[i][5]
				nTabT += aZonaV[i][6]
			Next
			//
			If !Empty(aZonaV)
				oSection6:Cell("DESCRI"):SetValue("Total de vendas:")
				oSection6:Cell("TAB_A"):SetValue(nTabA)
				oSection6:Cell("TAB_B"):SetValue(nTabB)
				oSection6:Cell("TAB_C"):SetValue(nTabC)
				oSection6:Cell("TAB_D"):SetValue(nTabD)
				oSection6:Cell("TAB_E"):SetValue(nTabE)
				oSection6:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection6:PrintLine()
				EndIf
				//
				nTotalA := (100*nTabA)/nTabT
				nTotalB := (100*nTabB)/nTabT
				nTotalC := (100*nTabC)/nTabT
				nTotalD := (100*nTabD)/nTabT
				nTotalE := (100*nTabE)/nTabT
				//
			EndIf
			//
			//Total de comissões
			nTabA := 0
			nTabB := 0
			nTabC := 0
			nTabD := 0
			nTabE := 0
			nTabT := 0
			//
			For i := 1 To Len(aZonaC)
				nTabA += aZonaC[i][1]
				nTabB += aZonaC[i][2]
				nTabC += aZonaC[i][3]
				nTabD += aZonaC[i][4]
				nTabE += aZonaC[i][5]
				nTabT += aZonaC[i][6]
			Next
			//
			If !Empty(aZonaC)
				oSection6:Cell("DESCRI"):SetValue("Total de comissões:")
				oSection6:Cell("TAB_A"):SetValue(nTabA)
				oSection6:Cell("TAB_B"):SetValue(nTabB)
				oSection6:Cell("TAB_C"):SetValue(nTabC)
				oSection6:Cell("TAB_D"):SetValue(nTabD)
				oSection6:Cell("TAB_E"):SetValue(nTabE)
				oSection6:Cell("TAB_TOT"):SetValue(nTabT)
				//
				If MV_PAR06 == 1
					oSection6:PrintLine()
				EndIf
				//
			EndIf
			//
			//Porcentagem (%) sobre o faturamento
			//
			If !Empty(aZonaV)
				oSection6:Cell("DESCRI"):SetValue("% s/ faturamento:")
				oSection6:Cell("TAB_A"):SetValue(nTotalA)
				oSection6:Cell("TAB_B"):SetValue(nTotalB)
				oSection6:Cell("TAB_C"):SetValue(nTotalC)
				oSection6:Cell("TAB_D"):SetValue(nTotalD)
				oSection6:Cell("TAB_E"):SetValue(nTotalE)
				oSection6:Cell("TAB_TOT"):Hide()
				//
				If MV_PAR06 == 1
					oSection6:PrintLine()
				EndIf
				//
				oSection6:Cell("TAB_TOT"):Show()
			EndIf
			//
			oSection6:Finish()
			//
			aZonaV := {}
			aZonaC := {}
			//
			//Fim do total da Zona
			//
		EndIf
		//
		If MV_PAR06 == 1
			oReport:FatLine()
		EndIf
		//
		oSection2:Init()
		oSection2:SetHeaderSection(.F.)
		
		oSection2:Cell("ZONA"):SetValue("Zona: "+AllTrim(QRY->A1_REGIAO)+" - "+Posicione("Z06",1,xFilial("Z06")+QRY->A1_REGIAO,"Z06_DESCRI"))
		//
		If MV_PAR06 == 1
			oSection2:PrintLine()
		EndIf
		//
		oSection2:Finish()
		//		
		oSection3:Init()
		oSection3:SetHeaderSection(.F.)
	
		oSection3:Cell("DIVISAO"):SetValue("Divisão: "+AllTrim(QRY->A1_GRPVEN)+" - "+Posicione("ACY",1,xFilial("ACY")+QRY->A1_GRPVEN,"ACY_DESCRI"))
		//
		If MV_PAR06 == 1
			oSection3:PrintLine()
		EndIf
		//
		oSection3:Finish()
		//
		oSection4:Init()
		oSection4:SetHeaderSection(.T.)
		//
	EndIf

	oSection4:Cell("EMISSAO"):SetValue(StoD(QRY->D2_EMISSAO))
	oSection4:Cell("NOTA"):SetValue(QRY->D2_DOC)
	oSection4:Cell("PEDIDO"):SetValue(QRY->D2_PEDIDO)
	oSection4:Cell("CLIENTE"):SetValue(AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->(A1_COD+A1_LOJA),"A1_NREDUZ")))
	oSection4:Cell("ESTADO"):SetValue(QRY->A1_EST)
	oSection4:Cell("MUNICIPIO"):SetValue(QRY->A1_MUN)
	oSection4:Cell("PRODUTO"):SetValue(AllTrim(Posicione("SB1",1,xFilial("SB1")+QRY->D2_COD,"B1_DESC")))
	oSection4:Cell("VLVENDA"):SetValue(QRY->D2_TOTAL)
	oSection4:Cell("TABELA"):SetValue(QRY->D2_VQ_TABE)
	oSection4:Cell("PERCOMIS"):SetValue(QRY->D2_COMIS1)
	oSection4:Cell("VLCOMIS"):SetValue(QRY->VLCOMIS)
	//
	If MV_PAR06 == 1
		oSection4:PrintLine()
	EndIf
	
	//TOTAL DE VENDAS - Divisão
	aaDD(aDiviV,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->D2_TOTAL, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->D2_TOTAL, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->D2_TOTAL, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->D2_TOTAL, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->D2_TOTAL, 0),; //TABELA E
				 QRY->D2_TOTAL})										   //TOTAL
	//
	//TOTAL DE comissões - Divisão
	aaDD(aDiviC,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->VLCOMIS, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->VLCOMIS, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->VLCOMIS, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->VLCOMIS, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->VLCOMIS, 0),; //TABELA E
				 QRY->VLCOMIS})										    //TOTAL
	//
	
	//TOTAL DE VENDAS - ZONA
	aaDD(aZonaV,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->D2_TOTAL, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->D2_TOTAL, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->D2_TOTAL, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->D2_TOTAL, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->D2_TOTAL, 0),; //TABELA E
				 QRY->D2_TOTAL})										   //TOTAL
	//
	//TOTAL DE comissões - ZONA
	aaDD(aZonaC,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->VLCOMIS, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->VLCOMIS, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->VLCOMIS, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->VLCOMIS, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->VLCOMIS, 0),; //TABELA E
				 QRY->VLCOMIS})										    //TOTAL
	//
	
	//TOTAL DE VENDAS - VENDEDOR
	aaDD(aVendV,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->D2_TOTAL, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->D2_TOTAL, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->D2_TOTAL, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->D2_TOTAL, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->D2_TOTAL, 0),; //TABELA E
				 QRY->D2_TOTAL})										   //TOTAL
	//
	//TOTAL DE comissões - VENDEDOR
	aaDD(aVendC,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->VLCOMIS, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->VLCOMIS, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->VLCOMIS, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->VLCOMIS, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->VLCOMIS, 0),; //TABELA E
				 QRY->VLCOMIS})										    //TOTAL
	//
	
	//TOTAL DE VENDAS - Relatório
	aaDD(aRelaV,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->D2_TOTAL, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->D2_TOTAL, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->D2_TOTAL, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->D2_TOTAL, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->D2_TOTAL, 0),; //TABELA E
				 QRY->D2_TOTAL})										   //TOTAL
	//
	//TOTAL DE comissões - Relatório
	aaDD(aRelaC,{If(AllTrim(QRY->D2_VQ_TABE) == "A", QRY->VLCOMIS, 0),; //TABELA A
				 If(AllTrim(QRY->D2_VQ_TABE) == "B", QRY->VLCOMIS, 0),; //TABELA B
				 If(AllTrim(QRY->D2_VQ_TABE) == "C", QRY->VLCOMIS, 0),; //TABELA C
				 If(AllTrim(QRY->D2_VQ_TABE) == "D", QRY->VLCOMIS, 0),; //TABELA D
				 If(AllTrim(QRY->D2_VQ_TABE) == "E", QRY->VLCOMIS, 0),; //TABELA E
				 QRY->VLCOMIS})										    //TOTAL
	//
	
	cDivi := QRY->A1_GRPVEN
	cZona := QRY->A1_REGIAO
	cVend := QRY->F2_VEND1

	oReport:IncMeter()
	
	QRY->(DbSkip())
	
	If QRY->(EoF())
		//
		oSection4:Finish()
		//
		If MV_PAR06 == 1
			oReport:IncRow()
		EndIf
		//
		//Início do total da Divisão
		oSection5:Init()
		oSection5:SetHeaderSection(.T.)
		//
		//Total de vendas
		nTabA := 0
		nTabB := 0
		nTabC := 0
		nTabD := 0
		nTabE := 0
		nTabT := 0
		//
		For i := 1 To Len(aDiviV)
			nTabA += aDiviV[i][1]
			nTabB += aDiviV[i][2]
			nTabC += aDiviV[i][3]
			nTabD += aDiviV[i][4]
			nTabE += aDiviV[i][5]
			nTabT += aDiviV[i][6]
		Next
		//
		If !Empty(aDiviV)
			oSection5:Cell("DESCRI"):SetValue("Total de vendas:")
			oSection5:Cell("TAB_A"):SetValue(nTabA)
			oSection5:Cell("TAB_B"):SetValue(nTabB)
			oSection5:Cell("TAB_C"):SetValue(nTabC)
			oSection5:Cell("TAB_D"):SetValue(nTabD)
			oSection5:Cell("TAB_E"):SetValue(nTabE)
			oSection5:Cell("TAB_TOT"):SetValue(nTabT)
			//
			If MV_PAR06 == 1
				oSection5:PrintLine()
			EndIf
			//
			nTotalA := (100*nTabA)/nTabT
			nTotalB := (100*nTabB)/nTabT
			nTotalC := (100*nTabC)/nTabT
			nTotalD := (100*nTabD)/nTabT
			nTotalE := (100*nTabE)/nTabT
			//
		EndIf
		//
		//Total de comissões
		nTabA := 0
		nTabB := 0
		nTabC := 0
		nTabD := 0
		nTabE := 0
		nTabT := 0
		//
		For i := 1 To Len(aDiviC)
			nTabA += aDiviC[i][1]
			nTabB += aDiviC[i][2]
			nTabC += aDiviC[i][3]
			nTabD += aDiviC[i][4]
			nTabE += aDiviC[i][5]
			nTabT += aDiviC[i][6]
		Next
		//
		If !Empty(aDiviV)
			oSection5:Cell("DESCRI"):SetValue("Total de comissões:")
			oSection5:Cell("TAB_A"):SetValue(nTabA)
			oSection5:Cell("TAB_B"):SetValue(nTabB)
			oSection5:Cell("TAB_C"):SetValue(nTabC)
			oSection5:Cell("TAB_D"):SetValue(nTabD)
			oSection5:Cell("TAB_E"):SetValue(nTabE)
			oSection5:Cell("TAB_TOT"):SetValue(nTabT)
			//
			If MV_PAR06 == 1
				oSection5:PrintLine()
			EndIf
			//
		EndIf
		//
		//Porcentagem (%) sobre o faturamento
		//
		If !Empty(aZonaV)
			oSection5:Cell("DESCRI"):SetValue("% s/ faturamento:")
			oSection5:Cell("TAB_A"):SetValue(nTotalA)
			oSection5:Cell("TAB_B"):SetValue(nTotalB)
			oSection5:Cell("TAB_C"):SetValue(nTotalC)
			oSection5:Cell("TAB_D"):SetValue(nTotalD)
			oSection5:Cell("TAB_E"):SetValue(nTotalE)
			oSection5:Cell("TAB_TOT"):Hide()
			//
			If MV_PAR06 == 1
				oSection5:PrintLine()
			EndIf
			//
			oSection5:Cell("TAB_TOT"):Show()
		EndIf
		//
		oSection5:Finish()
		//
		aDiviV := {}
		aDiviC := {}
		//
		//Fim do total da Divisão
		//
		//Início do total da Zona
		oSection6:Init()
		oSection6:SetHeaderSection(.T.)
		//
		//Total de vendas
		nTabA := 0
		nTabB := 0
		nTabC := 0
		nTabD := 0
		nTabE := 0
		nTabT := 0
		//
		For i := 1 To Len(aZonaV)
			nTabA += aZonaV[i][1]
			nTabB += aZonaV[i][2]
			nTabC += aZonaV[i][3]
			nTabD += aZonaV[i][4]
			nTabE += aZonaV[i][5]
			nTabT += aZonaV[i][6]
		Next
		//
		If !Empty(aZonaV)
			oSection6:Cell("DESCRI"):SetValue("Total de vendas:")
			oSection6:Cell("TAB_A"):SetValue(nTabA)
			oSection6:Cell("TAB_B"):SetValue(nTabB)
			oSection6:Cell("TAB_C"):SetValue(nTabC)
			oSection6:Cell("TAB_D"):SetValue(nTabD)
			oSection6:Cell("TAB_E"):SetValue(nTabE)
			oSection6:Cell("TAB_TOT"):SetValue(nTabT)
			//
			If MV_PAR06 == 1
				oSection6:PrintLine()
			EndIf
			//
			nTotalA := (100*nTabA)/nTabT
			nTotalB := (100*nTabB)/nTabT
			nTotalC := (100*nTabC)/nTabT
			nTotalD := (100*nTabD)/nTabT
			nTotalE := (100*nTabE)/nTabT
			//
		EndIf
		//
		//Total de comissões
		nTabA := 0
		nTabB := 0
		nTabC := 0
		nTabD := 0
		nTabE := 0
		nTabT := 0
		//
		For i := 1 To Len(aZonaC)
			nTabA += aZonaC[i][1]
			nTabB += aZonaC[i][2]
			nTabC += aZonaC[i][3]
			nTabD += aZonaC[i][4]
			nTabE += aZonaC[i][5]
			nTabT += aZonaC[i][6]
		Next
		//
		If !Empty(aZonaC)
			oSection6:Cell("DESCRI"):SetValue("Total de comissões:")
			oSection6:Cell("TAB_A"):SetValue(nTabA)
			oSection6:Cell("TAB_B"):SetValue(nTabB)
			oSection6:Cell("TAB_C"):SetValue(nTabC)
			oSection6:Cell("TAB_D"):SetValue(nTabD)
			oSection6:Cell("TAB_E"):SetValue(nTabE)
			oSection6:Cell("TAB_TOT"):SetValue(nTabT)
			//
			If MV_PAR06 == 1
				oSection6:PrintLine()
			EndIf
			//
		EndIf
		//
		//Porcentagem (%) sobre o faturamento
		//
		If !Empty(aZonaV)
			oSection6:Cell("DESCRI"):SetValue("% s/ faturamento:")
			oSection6:Cell("TAB_A"):SetValue(nTotalA)
			oSection6:Cell("TAB_B"):SetValue(nTotalB)
			oSection6:Cell("TAB_C"):SetValue(nTotalC)
			oSection6:Cell("TAB_D"):SetValue(nTotalD)
			oSection6:Cell("TAB_E"):SetValue(nTotalE)
			oSection6:Cell("TAB_TOT"):Hide()
			//
			If MV_PAR06 == 1
				oSection6:PrintLine()
			EndIf
			//
			oSection6:Cell("TAB_TOT"):Show()
		EndIf
		//
		oSection6:Finish()
		//
		aZonaV := {}
		aZonaC := {}
		//
		//Fim do total da Zona
		//
		//Início do total do Vendedor
		oSection7:Init()
		oSection7:SetHeaderSection(.T.)
		//
		//Total de vendas
		nTabA := 0
		nTabB := 0
		nTabC := 0
		nTabD := 0
		nTabE := 0
		nTabT := 0
		//
		For i := 1 To Len(aVendV)
			nTabA += aVendV[i][1]
			nTabB += aVendV[i][2]
			nTabC += aVendV[i][3]
			nTabD += aVendV[i][4]
			nTabE += aVendV[i][5]
			nTabT += aVendV[i][6]
		Next
		//
		If !Empty(aVendV)
			oSection7:Cell("DESCRI"):SetValue("Total de vendas:")
			oSection7:Cell("TAB_A"):SetValue(nTabA)
			oSection7:Cell("TAB_B"):SetValue(nTabB)
			oSection7:Cell("TAB_C"):SetValue(nTabC)
			oSection7:Cell("TAB_D"):SetValue(nTabD)
			oSection7:Cell("TAB_E"):SetValue(nTabE)
			oSection7:Cell("TAB_TOT"):SetValue(nTabT)
			oSection7:PrintLine()
			//
			nTotalA := (100*nTabA)/nTabT
			nTotalB := (100*nTabB)/nTabT
			nTotalC := (100*nTabC)/nTabT
			nTotalD := (100*nTabD)/nTabT
			nTotalE := (100*nTabE)/nTabT
			//
		EndIf
		//
		//Total de comissões
		nTabA := 0
		nTabB := 0
		nTabC := 0
		nTabD := 0
		nTabE := 0
		nTabT := 0
		//
		For i := 1 To Len(aVendC)
			nTabA += aVendC[i][1]
			nTabB += aVendC[i][2]
			nTabC += aVendC[i][3]
			nTabD += aVendC[i][4]
			nTabE += aVendC[i][5]
			nTabT += aVendC[i][6]
		Next
		//
		If !Empty(aVendC)
			oSection7:Cell("DESCRI"):SetValue("Total de comissões:")
			oSection7:Cell("TAB_A"):SetValue(nTabA)
			oSection7:Cell("TAB_B"):SetValue(nTabB)
			oSection7:Cell("TAB_C"):SetValue(nTabC)
			oSection7:Cell("TAB_D"):SetValue(nTabD)
			oSection7:Cell("TAB_E"):SetValue(nTabE)
			oSection7:Cell("TAB_TOT"):SetValue(nTabT)
			oSection7:PrintLine()
		EndIf
		//
		//Porcentagem (%) sobre o faturamento
		//
		If !Empty(aVendV)
			oSection7:Cell("DESCRI"):SetValue("% s/ faturamento:")
			oSection7:Cell("TAB_A"):SetValue(nTotalA)
			oSection7:Cell("TAB_B"):SetValue(nTotalB)
			oSection7:Cell("TAB_C"):SetValue(nTotalC)
			oSection7:Cell("TAB_D"):SetValue(nTotalD)
			oSection7:Cell("TAB_E"):SetValue(nTotalE)
			oSection7:Cell("TAB_TOT"):Hide()
			oSection7:PrintLine()
			oSection7:Cell("TAB_TOT"):Show()
		EndIf
		//
		oSection7:Finish()
		//
		aVendV := {}
		aVendC := {}
		//
		//Fim do total da Vendedor
		//
	EndIf
	//
EndDo

oReport:IncRow()
oReport:FatLine()
oReport:IncRow()

//Início do total do Relatório
oSection8:Init()
oSection8:SetHeaderSection(.T.)
//
//Total de vendas
nTabA := 0
nTabB := 0
nTabC := 0
nTabD := 0
nTabE := 0
nTabT := 0
//
For i := 1 To Len(aRelaV)
	nTabA += aRelaV[i][1]
	nTabB += aRelaV[i][2]
	nTabC += aRelaV[i][3]
	nTabD += aRelaV[i][4]
	nTabE += aRelaV[i][5]
	nTabT += aRelaV[i][6]
Next
//
If !Empty(aRelaV)
	oSection8:Cell("DESCRI"):SetValue("Total de vendas:")
	oSection8:Cell("TAB_A"):SetValue(nTabA)
	oSection8:Cell("TAB_B"):SetValue(nTabB)
	oSection8:Cell("TAB_C"):SetValue(nTabC)
	oSection8:Cell("TAB_D"):SetValue(nTabD)
	oSection8:Cell("TAB_E"):SetValue(nTabE)
	oSection8:Cell("TAB_TOT"):SetValue(nTabT)
	oSection8:PrintLine()
	//
	nTotalA := (100*nTabA)/nTabT
	nTotalB := (100*nTabB)/nTabT
	nTotalC := (100*nTabC)/nTabT
	nTotalD := (100*nTabD)/nTabT
	nTotalE := (100*nTabE)/nTabT
	//
EndIf
//
//Total de comissões
nTabA := 0
nTabB := 0
nTabC := 0
nTabD := 0
nTabE := 0
nTabT := 0
//
For i := 1 To Len(aRelaC)
	nTabA += aRelaC[i][1]
	nTabB += aRelaC[i][2]
	nTabC += aRelaC[i][3]
	nTabD += aRelaC[i][4]
	nTabE += aRelaC[i][5]
	nTabT += aRelaC[i][6]
Next
//
If !Empty(aRelaC)
	oSection8:Cell("DESCRI"):SetValue("Total de comissões:")
	oSection8:Cell("TAB_A"):SetValue(nTabA)
	oSection8:Cell("TAB_B"):SetValue(nTabB)
	oSection8:Cell("TAB_C"):SetValue(nTabC)
	oSection8:Cell("TAB_D"):SetValue(nTabD)
	oSection8:Cell("TAB_E"):SetValue(nTabE)
	oSection8:Cell("TAB_TOT"):SetValue(nTabT)
	oSection8:PrintLine()
EndIf
//
//Porcentagem (%) sobre o faturamento
//
If !Empty(aRelaV)
	oSection8:Cell("DESCRI"):SetValue("% s/ faturamento:")
	oSection8:Cell("TAB_A"):SetValue(nTotalA)
	oSection8:Cell("TAB_B"):SetValue(nTotalB)
	oSection8:Cell("TAB_C"):SetValue(nTotalC)
	oSection8:Cell("TAB_D"):SetValue(nTotalD)
	oSection8:Cell("TAB_E"):SetValue(nTotalE)
	oSection8:Cell("TAB_TOT"):Hide()
	oSection8:PrintLine()
	oSection8:Cell("TAB_TOT"):Show()
EndIf
//
oSection8:Finish()
//
aRelaV := {}
aRelaC := {}
//
//Fim do total do Relatório
//

QRY->(dbCloseArea())

Return()
