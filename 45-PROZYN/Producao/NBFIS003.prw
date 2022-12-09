#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºFuncao    ³ ºAutor  ³                             º Data ³  23/03/17   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³Geracao de relatório de Vendas                              º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function NBFIS003()

Local cPerg		:= PadR("NBFIS003",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)

	Processa( {|| Plan03() },"Aguarde" ,"Processando...")

EndIf

Return() 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    º Data ³             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±                                                                         ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {} 
local i:=0

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","Data Emissão De?"			,"mv_par01"	,"D",8,0,0, "G","", 	"mv_par01","","","","","","" } )
AADD(	aSx1,{ cPerg,"02","Data Emissão Até?"			,"mv_par02"	,"D",8,0,0, "G","",		"mv_par02","","","","","","" } )
AADD(	aSx1,{ cPerg,"03","Fornec/Cliente De?"			,"mv_par03"	,"C",6,0,0, "G","",		"mv_par03","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"04","Fornec/Cliente Até?"			,"mv_par04"	,"C",6,0,0, "G","",		"mv_par04","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"07","Produto De?"					,"mv_par05"	,"C",15,0,0, "G","",	"mv_par05","","","","","SB1","" } )
AADD(	aSx1,{ cPerg,"08","Produto Até?"				,"mv_par06"	,"C",15,0,0, "G","",	"mv_par06","","","","","SB1","" } )

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
			SX1->X1_PRESEL		:= aSx1[i][8] //Pre seleção do combo
			SX1->X1_GSC			:= aSx1[i][9] //Tipo de componente
			SX1->X1_VAR01		:= aSx1[i][10]//Variavel que carrega resposta
			SX1->X1_DEF01		:= aSx1[i][11]//Definições do combo-box
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Plan02()       ³ Autor ³ AF Custom       ³ Data ³ 27/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Plan03()
Local _cPathExcel:="C:\TEMP\"
Local  _cPath 	  := AllTrim(GetTempPath())
Local  _cArquivo  := CriaTrab(,.F.)
Local oExcel := Fwmsexcel():new() 
Local oFWMsExcel
Local cURLXML:= ''
Local cQuery:=""

Private _nHandle  := FCreate(_cArquivo)

cQuery := "SELECT  " + Chr(13)
cQuery += " SUBSTRING(D2_EMISSAO,7,2) + '/' + SUBSTRING(D2_EMISSAO,5,2) + '/' + SUBSTRING(D2_EMISSAO,1,4) as DT_EMISSAO , " +  Chr(13)
cQuery += "D2_DOC NOTA,  " + Chr(13)
cQuery += "D2_TIPO TIPO, " + Chr(13)
cQuery += "D2_CLIENTE COD_CLI, " + Chr(13)
cQuery += "D2_LOJA LJ_CLI, " + Chr(13)
cQuery += "CASE WHEN D2_TIPO <> 'B' AND D2_TIPO <> 'D'  " + Chr(13)
cQuery += "THEN (SELECT A1_NREDUZ FROM  SA1010  WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD2.D2_CLIENTE AND A1_LOJA = SD2.D2_LOJA) " + Chr(13) 
cQuery += "ELSE (SELECT A2_NREDUZ FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND A2_COD = SD2.D2_CLIENTE AND A2_LOJA = SD2.D2_LOJA) END FORN_CLI,  " + Chr(13)
cQuery += "F2_EST UF, " + Chr(13) 
cQuery += "D2_COD COD_PROD, " + Chr(13)
cQuery += "B1_DESC PRODUTO, " + Chr(13) 
cQuery += "D2_QUANT QUANT, " + Chr(13)
cQuery += "D2_PRCVEN VLR_UNIT, " + Chr(13)
cQuery += "D2_TOTAL TOTAL, " + Chr(13)
cQuery += "F2_VEND1 VENDEDOR, " + Chr(13) 
cQuery += "D2_VALFRE VLRFRETE, " + Chr(13) 
cQuery += "D2_DESPESA VLRDESP, " + Chr(13) 
cQuery += "D2_SEGURO VLR_SEG, " + Chr(13)
cQuery += "D2_DESCON VLRDESC,  " + Chr(13)
cQuery += "D2_VALICM VLRICMS,  " + Chr(13)
cQuery += "D2_ICMSCOM ICMS_COMP, " + Chr(13)
cQuery += "D2_VALIPI VLRIPI,       " + Chr(13)
cQuery += "D2_VALIMP5 VLR_COF,  " + Chr(13)
cQuery += "D2_VALIMP6 VLR_PIS,  " + Chr(13)
cQuery += "D2_CUSTO1 CUSTO  " + Chr(13)
cQuery += "FROM SD2010 SD2 " + Chr(13)
cQuery += "INNER JOIN SB1010 SB1 ON  " + Chr(13)
cQuery += "SB1.D_E_L_E_T_ <> '*' AND SD2.D2_COD = SB1.B1_COD " + Chr(13) 

cQuery += "INNER JOIN SF4010 SF4 ON  " + Chr(13)
cQuery += "SD2.D2_TES = SF4.F4_CODIGO  " + Chr(13)
cQuery += "AND SF4.D_E_L_E_T_ <> '*' " + Chr(13)       


cQuery += "AND SF4.F4_DUPLIC = 'S' " + Chr(13)

cQuery += "INNER JOIN SF2010 SF2 ON  " + Chr(13)
cQuery += "SF2.F2_SERIE = SD2.D2_SERIE AND  " + Chr(13)
cQuery += "SF2.F2_DOC = SD2.D2_DOC AND " + Chr(13)
cQuery += "SF2.F2_CLIENTE = SD2.D2_CLIENTE AND " + Chr(13)
cQuery += "SF2.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "WHERE SD2.D_E_L_E_T_ <> '*' AND  " + Chr(13)
cQuery += "SD2.D2_EMISSAO BETWEEN '" + dTOS(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND " + Chr(13)
cQuery += "SD2.D2_CLIENTE BETWEEN'" + mv_par03 + "' AND '" + mv_par04 + "' AND " + Chr(13)
cQuery += "SD2.D2_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' " + Chr(13)

memowrite("GERSAI1",cQuery)

TcQuery cQuery New Alias (cAliasD2:=GetNextAlias())

If (cAliasD2)->(!Eof())
	_lRet := .T.
EndIf


oExcel:AddworkSheet("PARÂMETROS")
oExcel:AddTable("PARÂMETROS","PARÂMETROS")
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","PARAMETROS",1,1)
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","VALOR",1,1)

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Data Emissão De',;
DTOC(mv_par01)})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Data Emissão Até',;
DTOC(mv_par02)})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Fornec/Cliente De',;
mv_par03})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Fornec/Cliente Até',;
mv_par04})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Produto De',;
mv_par05})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Produto Até',;
mv_par06})

oExcel:AddworkSheet("RELATÓRIO")
oExcel:AddTable("RELATÓRIO","VENDAS")
oExcel:AddColumn("RELATÓRIO","VENDAS","DATA EMISSÃO",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","NOTA",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","TIPO",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","CÓD. CLIENTE",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","LJ CLIENTE",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","FORN_CLIENTE",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","UF",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","CÓD.PRODUTO",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","PRODUTO",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","QUANT",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR_UNIT",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","TOTAL",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VENDEDOR",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR FRETE",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR DESPESA",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR SEGURO",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR DESCONTO",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR ICMS",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","ICMS COMP",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR IPI",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR COFINS",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","VLR PIS",1,1)
oExcel:AddColumn("RELATÓRIO","VENDAS","CUSTO",1,1)

(cAliasD2)->(DbGotOP())

While !(cAliasD2)->(EOF())

oExcel:AddRow("RELATÓRIO","VENDAS",{(cAliasD2)->DT_EMISSAO,;
(cAliasD2)->NOTA,;
(cAliasD2)->TIPO,;
(cAliasD2)->COD_CLI,;
(cAliasD2)->LJ_CLI,;
(cAliasD2)->FORN_CLI,;
(cAliasD2)->UF,;
(cAliasD2)->COD_PROD,;
(cAliasD2)->PRODUTO,;
(cAliasD2)->QUANT,;
(cAliasD2)->VLR_UNIT,;
(cAliasD2)->TOTAL,;
(cAliasD2)->VENDEDOR,;
(cAliasD2)->VLRFRETE,;
(cAliasD2)->VLRDESP,;
(cAliasD2)->VLR_SEG,;
(cAliasD2)->VLRDESC,;
(cAliasD2)->VLRICMS,;
(cAliasD2)->ICMS_COMP,;
(cAliasD2)->VLRIPI,;
(cAliasD2)->VLR_COF,;
(cAliasD2)->VLR_PIS,;
(cAliasD2)->CUSTO})

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

Plan03()