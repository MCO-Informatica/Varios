#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณTTD2 บAutor  ณDenisVarella          บ Data ณ  23/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de relat๓rio NF de Entrada           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NBFIS002()

Local cPerg		:= PadR("NBFIS002",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)

	Processa( {|| Plan02() },"Aguarde" ,"Processando...")

EndIf

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {} 
local i:=0

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","Data Digita็ใo De?"			,"mv_par01"	,"D",8,0,0, "G","", 	"mv_par01","","","","","","" } )
AADD(	aSx1,{ cPerg,"02","Data Digita็ใo At้?"			,"mv_par02"	,"D",8,0,0, "G","",		"mv_par02","","","","","","" } )
AADD(	aSx1,{ cPerg,"03","Fornec/Cliente De?"			,"mv_par03"	,"C",6,0,0, "G","",		"mv_par03","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"04","Fornec/Cliente At้?"			,"mv_par04"	,"C",6,0,0, "G","",		"mv_par04","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"07","Produto De?"					,"mv_par05"	,"C",15,0,0, "G","",	"mv_par05","","","","","SB1","" } )
AADD(	aSx1,{ cPerg,"08","Produto At้?"				,"mv_par06"	,"C",15,0,0, "G","",	"mv_par06","","","","","SB1","" } )

If SX1->X1_GRUPO != cPerg
	For I := 1 To Len( aSx1 )
		If !SX1->( DBSeek( aSx1[I][1] + aSx1[I][2] ) )
			Reclock( "SX1", .T. )                                               
			SX1->X1_GRUPO		:= aSx1[i][1] //Grupo
			SX1->X1_ORDEM		:= aSx1[i][2] //Ordem do campo
			SX1->X1_PERGUNT		:= aSx1[i][3] //Pergunta
			SX1->X1_PERSPA		:= aSx1[i][3] //Pergunta Espanhol
	   		SX1->X1_PERENG		:= aSx1[i][3] //Pergunta Ingles
			SX1->X1_VARIAVL		:= aSx1[i][4] //Variavel do campo
			SX1->X1_TIPO		:= aSx1[i][5] //Tipo de valor
			SX1->X1_TAMANHO		:= aSx1[i][6] //Tamanho do campo
			SX1->X1_DECIMAL		:= aSx1[i][7] //Formato numerico
			SX1->X1_PRESEL		:= aSx1[i][8] //Pre sele็ใo do combo
			SX1->X1_GSC			:= aSx1[i][9] //Tipo de componente
			SX1->X1_VAR01		:= aSx1[i][10]//Variavel que carrega resposta
			SX1->X1_DEF01		:= aSx1[i][11]//Defini็๕es do combo-box
			SX1->X1_DEF02		:= aSx1[i][12]
			SX1->X1_DEF03		:= aSx1[i][13]
			SX1->X1_DEF04		:= aSx1[i][14]
			SX1->X1_VALID		:= aSx1[i][15]
			SX1->X1_F3			:= aSx1[i][16]
			MsUnlock()
		Endif
	Next
Endif

RestArea(aRea)

Return(cPerg)	

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณ Plan02()       ณ Autor ณ AF Custom       ณ Data ณ 27/11/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Plan02()
Local _cPathExcel:="C:\TEMP\"
Local  _cPath 	  := AllTrim(GetTempPath())
Local  _cArquivo  := CriaTrab(,.F.)
Local oExcel := Fwmsexcel():new() 
Local oFWMsExcel
Local cURLXML:= ''
Local cQuery:=""

Private _nHandle  := FCreate(_cArquivo)

cQuery := "SELECT  " + Chr(13)
cQuery += "SUBSTRING(D1_DTDIGIT,7,2) + '/' + SUBSTRING(D1_DTDIGIT,5,2) + '/' + SUBSTRING(D1_DTDIGIT,1,4) as DIGITAC , " +  Chr(13)
cQuery += "SUBSTRING(D1_EMISSAO,7,2) + '/' + SUBSTRING(D1_EMISSAO,5,2) + '/' + SUBSTRING(D1_EMISSAO,1,4) as DT_EMISSAO , " +  Chr(13)
cQuery += "D1_DOC NOTA,  " + Chr(13)
cQuery += "A4_COD COD_TRAN, " + Chr(13)
cQuery += "A4_NREDUZ TRANSPOR, " + Chr(13)
cQuery += "D1_TIPO TIPO, " + Chr(13)
cQuery += "D1_FORNECE FORN_CLI, " + Chr(13)
cQuery += "D1_LOJA LJ_FORNEC, " + Chr(13)
cQuery += "CASE WHEN D1_TIPO <> 'B' AND D1_TIPO <> 'D'  " + Chr(13)
cQuery += "THEN (SELECT A2_NREDUZ FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND A2_COD = SD1.D1_FORNECE AND A2_LOJA = SD1.D1_LOJA AND A2_FILIAL='' )  " + Chr(13)
cQuery += "ELSE (SELECT A1_NREDUZ FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD1.D1_FORNECE AND A1_LOJA = SD1.D1_LOJA) END NREDUZ,  " + Chr(13)
cQuery += "CASE WHEN D1_TIPO <> 'B' AND D1_TIPO <> 'D'  " + Chr(13)
cQuery += "THEN (SELECT A2_CGC FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND A2_COD = SD1.D1_FORNECE AND A2_LOJA = SD1.D1_LOJA AND A2_FILIAL='' )  " + Chr(13)
cQuery += "ELSE (SELECT A1_CGC FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD1.D1_FORNECE AND A1_LOJA = SD1.D1_LOJA) END CNPJ,  " + Chr(13)
cQuery += "F1_EST ESTADO, " + Chr(13)
cQuery += "D1_COD COD_PROD, " + Chr(13)
cQuery += "B1_DESC PRODUTO,  " + Chr(13)
cQuery += "B1_DESC DESCRIC,  " + Chr(13)
cQuery += "B1_TIPO TP_PROD,  " + Chr(13)
cQuery += "B1_POSIPI NCM, " + Chr(13)
cQuery += "D1_LOCAL ALMOX,  " + Chr(13)
cQuery += "D1_QUANT QUANT, " + Chr(13)
cQuery += "D1_VUNIT VLR_UNIT, " + Chr(13)
cQuery += "D1_TOTAL TOTAL, " + Chr(13)
cQuery += "D1_TES TES, " + Chr(13)
cQuery += "D1_CF CFOP,  " + Chr(13)
cQuery += "F4_ESTOQUE ESTOQUE,  " + Chr(13)
cQuery += "D1_IDENTB6 P_TERCE,  " + Chr(13)
cQuery += "F4_DUPLIC DUPLIC,  " + Chr(13)
cQuery += "D1_VALFRE VLRFRETE,  " + Chr(13)
cQuery += "D1_DESPESA VLRDESP,  " + Chr(13)
cQuery += "D1_SEGURO VLR_SEG, " + Chr(13)
cQuery += "D1_VALDESC VLRDESC,  " + Chr(13)
cQuery += "D1_CUSTO CUSTO,  " + Chr(13)
cQuery += "D1_CLASFIS CLA_FISC,  " + Chr(13)
cQuery += "D1_PICM ALIQICMS,  " + Chr(13)
cQuery += "D1_VALICM VLRICMS,  " + Chr(13)
cQuery += "D1_ICMSCOM ICMS_COMP, " + Chr(13)
cQuery += "F4_CREDICM APUR_ICMS,  " + Chr(13)
cQuery += "D1_IPI ALIQIPI,    " + Chr(13)
cQuery += "D1_VALIPI VLRIPI,       " + Chr(13)
cQuery += "F4_CREDIPI APUR_IPI, " + Chr(13)
cQuery += "F4_CTIPI CST_IPI, " + Chr(13)
cQuery += "F4_CSTPIS CST_PIS, " + Chr(13)
cQuery += "F4_CSTCOF CST_COF,  " + Chr(13)
cQuery += "D1_BASIMP5 BAS_COF,  " + Chr(13)
cQuery += "D1_ALQIMP5 ALQ_COF, " + Chr(13)
cQuery += "D1_VALIMP5 VLR_COF,  " + Chr(13)
cQuery += "D1_BASIMP6 BAS_PIS,  " + Chr(13)
cQuery += "D1_ALQIMP6 ALQ_PIS,  " + Chr(13)
cQuery += "D1_VALIMP6 VLR_PIS,  " + Chr(13)
cQuery += "D1_VALISS VLR_ISS,  " + Chr(13)
cQuery += "F1_RECISS REC_ISS,  " + Chr(13)
cQuery += "D1_VALIRR VLR_IR,  " + Chr(13)
cQuery += "D1_VALINS VLR_INSS, " + Chr(13)
cQuery += "D1_SERIORI SER_ORIG,  " + Chr(13)
cQuery += "D1_NFORI NF_ORIG,  " + Chr(13)
cQuery += "D1_ITEMORI IT_ORIG, " + Chr(13)
cQuery += "D1_LOTECTL LOTE, " + Chr(13)
cQuery += " SUBSTRING(D1_DTVALID,7,2) + '/' + SUBSTRING(D1_DTVALID,5,2) + '/' + SUBSTRING(D1_DTVALID,1,4) as DT_VALID, " +  Chr(13)
cQuery += "F1_CHVNFE CHAVE_NFE, " + Chr(13)
cQuery += "F1_ESPECIE ESPECIE, " + Chr(13)
cQuery += "F1_FORMUL FORM_PROPRIO " + Chr(13)
cQuery += "FROM SD1010 SD1 " + Chr(13)
cQuery += "INNER JOIN SB1010 SB1 ON  " + Chr(13)
cQuery += "SB1.D_E_L_E_T_ <> '*'  " + Chr(13)
cQuery += "AND SD1.D1_COD = SB1.B1_COD  " + Chr(13)
cQuery += "INNER JOIN SF4010 SF4 ON  " + Chr(13)
cQuery += "SD1.D1_TES = SF4.F4_CODIGO  " + Chr(13)
cQuery += "AND SF4.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "INNER JOIN SF1010 SF1 ON  " + Chr(13)
cQuery += "SF1.F1_SERIE = SD1.D1_SERIE AND  " + Chr(13)
cQuery += "SF1.F1_DOC = SD1.D1_DOC AND " + Chr(13)
cQuery += "SF1.F1_DTDIGIT = SD1.D1_DTDIGIT AND " + Chr(13)
cQuery += "SF1.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "LEFT JOIN SA4010 SA4 ON " + Chr(13)
cQuery += "SA4.A4_COD = SF1.F1_TRANSP AND " + Chr(13)
cQuery += "SA4.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "WHERE SD1.D_E_L_E_T_ <> '*' AND " + Chr(13)
cQuery += "SD1.D1_DTDIGIT BETWEEN '" + dTOS(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND " + Chr(13)
cQuery += "SD1.D1_FORNECE BETWEEN'" + mv_par03 + "' AND '" + mv_par04 + "' AND " + Chr(13)
cQuery += "SD1.D1_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' " + Chr(13)

memowrite("NF_ENTRADA",cQuery)

TcQuery cQuery New Alias (cAliasD2:=GetNextAlias())

If (cAliasD2)->(!Eof())
	_lRet := .T.
EndIf


oExcel:AddworkSheet("PARยMETROS")
oExcel:AddTable("PARยMETROS","PARยMETROS")
oExcel:AddColumn("PARยMETROS","PARยMETROS","PARAMETROS",1,1)
oExcel:AddColumn("PARยMETROS","PARยMETROS","VALOR",1,1)

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Digita็ใo De',;
DTOC(mv_par01)})

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Digita็ใo At้',;
DTOC(mv_par02)})

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Fornec/Cliente De',;
mv_par03})

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Fornec/Cliente At้',;
mv_par04})

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Produto De',;
mv_par05})

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Produto At้',;
mv_par06})

oExcel:AddworkSheet("RELATำRIO")
oExcel:AddTable("RELATำRIO","RELATำRIO")
oExcel:AddColumn("RELATำRIO","RELATำRIO","DIGITAC",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","DT_EMISSAO",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","NOTA",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","COD_TRAN",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","TRANSPOR",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","TIPO",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","FORN_CLI",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","LJ_FORNEC",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","NREDUZ",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CNPJ",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ESTADO",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","COD_PROD",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","PRODUTO",1,1)
//oExcel:AddColumn("RELATำRIO","RELATำRIO","DESCRIC",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","TP_PROD",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","NCM",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ALMOX",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","QUANT",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLR_UNIT",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","TOTAL",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","TES",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CFOP",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ESTOQUE",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","P_TERCE",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","DUPLIC",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLRFRETE",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLRDESP",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLR_SEG",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLRDESC",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CUSTO",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CLA_FISC",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ALIQICMS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLRICMS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ICMS_COMP",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","APUR_ICMS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ALIQIPI",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLRIPI",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","APUR_IPI",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CST_IPI",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CST_PIS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CST_COF",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","BAS_COF",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ALQ_COF",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLR_COF",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","BAS_PIS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ALQ_PIS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLR_PIS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLR_ISS ",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","REC_ISS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLR_IR",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","VLR_INSS",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","SER_ORIG",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","NF_ORIG",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","IT_ORIG",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","LOTE",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","DT_VALID",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","CHAVE_NFE",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","ESPECIE",1,1)
oExcel:AddColumn("RELATำRIO","RELATำRIO","FORM_PROPRIO",1,1)

(cAliasD2)->(DbGotOP())

While !(cAliasD2)->(EOF())

oExcel:AddRow("RELATำRIO","RELATำRIO",{(cAliasD2)->DIGITAC,;
(cAliasD2)->DT_EMISSAO,;
(cAliasD2)->NOTA,;
(cAliasD2)->COD_TRAN,;
(cAliasD2)->TRANSPOR,;
(cAliasD2)->TIPO,;
(cAliasD2)->FORN_CLI,;
(cAliasD2)->LJ_FORNEC,;
(cAliasD2)->NREDUZ,;
(cAliasD2)->CNPJ,;
(cAliasD2)->ESTADO,;  
(cAliasD2)->COD_PROD,;
(cAliasD2)->PRODUTO,;
(cAliasD2)->TP_PROD,;
(cAliasD2)->NCM,;
(cAliasD2)->ALMOX,;
(cAliasD2)->QUANT,;
(cAliasD2)->VLR_UNIT,;
(cAliasD2)->TOTAL,;
(cAliasD2)->TES,;
(cAliasD2)->CFOP,;
(cAliasD2)->ESTOQUE,;
(cAliasD2)->P_TERCE,;
(cAliasD2)->DUPLIC,;
(cAliasD2)->VLRFRETE,;
(cAliasD2)->VLRDESP,;
(cAliasD2)->VLR_SEG,;
(cAliasD2)->VLRDESC,;
(cAliasD2)->CUSTO,;
(cAliasD2)->CLA_FISC,;
(cAliasD2)->ALIQICMS,;
(cAliasD2)->VLRICMS,;
(cAliasD2)->ICMS_COMP,;
(cAliasD2)->APUR_ICMS,;
(cAliasD2)->ALIQIPI,;
(cAliasD2)->VLRIPI,;
(cAliasD2)->APUR_IPI,;
(cAliasD2)->CST_IPI,;
(cAliasD2)->CST_PIS,;
(cAliasD2)->CST_COF,;
(cAliasD2)->BAS_COF,;
(cAliasD2)->ALQ_COF,;
(cAliasD2)->VLR_COF,;
(cAliasD2)->BAS_PIS,;
(cAliasD2)->ALQ_PIS,;
(cAliasD2)->VLR_PIS,;
(cAliasD2)->VLR_ISS ,;
(cAliasD2)->REC_ISS,;
(cAliasD2)->VLR_IR,;
(cAliasD2)->VLR_INSS,;
(cAliasD2)->SER_ORIG,;
(cAliasD2)->NF_ORIG,;
(cAliasD2)->IT_ORIG,;
(cAliasD2)->LOTE,;
(cAliasD2)->DT_VALID,;
(cAliasD2)->CHAVE_NFE,;
(cAliasD2)->ESPECIE,;
(cAliasD2)->FORM_PROPRIO})

/*
oExcel:AddRow("RELATำRIO","RELATำRIO",{(cAliasD2)->DIGITAC,;
(cAliasD2)->DT_EMISSAO,;
(cAliasD2)->NOTA,;
(cAliasD2)->COD_TRAN,;
(cAliasD2)->TRANSPOR,;
(cAliasD2)->TIPO,;
(cAliasD2)->FORN_CLI,;
(cAliasD2)->LJ_FORNEC,;
(cAliasD2)->NREDUZ,;
(cAliasD2)->CNPJ,;
(cAliasD2)->ESTADO,;  
(cAliasD2)->COD_PROD,;
(cAliasD2)->PRODUTO,;
(cAliasD2)->DESCRIC,;
(cAliasD2)->TP_PROD,;
(cAliasD2)->NCM,;
(cAliasD2)->ALMOX,;
(cAliasD2)->QUANT,;
(cAliasD2)->VLR_UNIT,;
(cAliasD2)->TOTAL,;
(cAliasD2)->TES,;
(cAliasD2)->CFOP,;
(cAliasD2)->ESTOQUE,;
(cAliasD2)->P_TERCE,;
(cAliasD2)->DUPLIC,;
(cAliasD2)->VLRFRETE,;
(cAliasD2)->VLRDESP,;
(cAliasD2)->VLR_SEG,;
(cAliasD2)->VLRDESC,;
(cAliasD2)->CUSTO,;
(cAliasD2)->CLA_FISC,;
(cAliasD2)->ALIQICMS,;
(cAliasD2)->VLRICMS,;
(cAliasD2)->ICMS_COMP,;
(cAliasD2)->APUR_ICMS,;
(cAliasD2)->ALIQIPI,;
(cAliasD2)->VLRIPI,;
(cAliasD2)->APUR_IPI,;
(cAliasD2)->CST_IPI,;
(cAliasD2)->CST_PIS,;
(cAliasD2)->CST_COF,;
(cAliasD2)->BAS_COF,;
(cAliasD2)->ALQ_COF,;
(cAliasD2)->VLR_COF,;
(cAliasD2)->BAS_PIS,;
(cAliasD2)->ALQ_PIS,;
(cAliasD2)->VLR_PIS,;
(cAliasD2)->VLR_ISS ,;
(cAliasD2)->REC_ISS,;
(cAliasD2)->VLR_IR,;
(cAliasD2)->VLR_INSS,;
(cAliasD2)->SER_ORIG,;
(cAliasD2)->NF_ORIG,;
(cAliasD2)->IT_ORIG,;
(cAliasD2)->LOTE,;
(cAliasD2)->DT_VALID,;
(cAliasD2)->CHAVE_NFE,;
(cAliasD2)->ESPECIE,;
(cAliasD2)->FORM_PROPRIO})

*/

(cAliasD2)->(DbSKip())
Enddo


oExcel:Activate()
oExcel:GetXMLFile(_cArquivo+".xml")

__CopyFile(_cArquivo+".xml",_cPathExcel+_cArquivo+".xml")

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cPathExcel+_cArquivo+".xml") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

Return

Plan02()