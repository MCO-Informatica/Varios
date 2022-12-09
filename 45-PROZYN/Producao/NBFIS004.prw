#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºFuncao    ³Autor  ³ Newbridge                     º Data ³  18/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geracao de relatório DEVOLUCAO VENDA                        º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function NBFIS004()

Local cPerg		:= PadR("NBFIS004",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)

	Processa( {|| Plan04() },"Aguarde" ,"Processando...")

EndIf

Return() 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    º Data ³             º±±
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
AADD(	aSx1,{ cPerg,"01","Data Digitação De?"			,"mv_par01"	,"D",8,0,0, "G","", 	"mv_par01","","","","","","" } )
AADD(	aSx1,{ cPerg,"02","Data Digitação Até?"			,"mv_par02"	,"D",8,0,0, "G","",		"mv_par02","","","","","","" } )
AADD(	aSx1,{ cPerg,"03","Cliente De?"		        	,"mv_par03"	,"C",6,0,0, "G","",		"mv_par03","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"04","Cliente Até?"		    	,"mv_par04"	,"C",6,0,0, "G","",		"mv_par04","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"05","Produto De?"					,"mv_par05"	,"C",15,0,0, "G","",	"mv_par05","","","","","SB1","" } )
AADD(	aSx1,{ cPerg,"06","Produto Até?"				,"mv_par06"	,"C",15,0,0, "G","",	"mv_par06","","","","","SB1","" } )

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
±±³Fun‡„o	 ³ Plan04()       ³ Autor ³ AF Custom       ³ Data ³ 27/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Plan04()
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
cQuery += "D1_DOC NOTA,  " + Chr(13)
cQuery += "D1_TIPO TIPO, " + Chr(13)
cQuery += "D1_FORNECE CLIENTE, " + Chr(13)
cQuery += "D1_LOJA LJ_CLIENTE, " + Chr(13)
cQuery += "CASE WHEN D1_TIPO = 'D'  " + Chr(13)
cQuery += "THEN (SELECT A2_NREDUZ FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND A2_COD = SD1.D1_FORNECE AND A2_LOJA = SD1.D1_LOJA AND A2_FILIAL='' )  " + Chr(13)
cQuery += "ELSE (SELECT A1_NREDUZ FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD1.D1_FORNECE AND A1_LOJA = SD1.D1_LOJA) END NREDUZ,  " + Chr(13)
cQuery += "D1_COD COD_PROD, " + Chr(13)
cQuery += "B1_DESC PRODUTO,  " + Chr(13)
cQuery += "B1_DESC DESCRIC,  " + Chr(13)
cQuery += "D1_QUANT QUANT, " + Chr(13)
cQuery += "D1_VUNIT VLR_UNIT, " + Chr(13)
cQuery += "D1_TOTAL TOTAL, " + Chr(13)
//VENDEDOR
//cQuery += "CASE WHEN D1_TIPO = 'D'  " + Chr(13)
//cQuery += "THEN (SELECT F2_VEND1 FROM SF2010 WHERE D_E_L_E_T_ <> '*' AND F2_SERIE = SD1.D1_SERIORI AND F2_DOC = SD1.D1_NFORI AND F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_LOJA = SD1.D1_LOJA )  " + Chr(13)
//cQuery += "ELSE (' ') END VENDEDOR,  " + Chr(13)

cQuery += "D1_VALFRE VLRFRETE,  " + Chr(13)
cQuery += "D1_DESPESA VLRDESP,  " + Chr(13)
cQuery += "D1_SEGURO VLR_SEG, " + Chr(13)
cQuery += "D1_VALDESC VLRDESC,  " + Chr(13)
cQuery += "D1_VALICM VLRICMS,  " + Chr(13)
cQuery += "D1_ICMSCOM ICMS_COMP, " + Chr(13)
cQuery += "D1_VALIPI VLRIPI,       " + Chr(13)
cQuery += "D1_VALIMP5 VLR_COF,  " + Chr(13)
cQuery += "D1_VALIMP6 VLR_PIS,  " + Chr(13)
cQuery += "D1_CUSTO CUSTO  " + Chr(13)
cQuery += "FROM SD1010 SD1 " + Chr(13)
cQuery += "INNER JOIN SB1010 SB1 ON  " + Chr(13)
cQuery += "SB1.D_E_L_E_T_ <> '*'  " + Chr(13)
cQuery += "AND SD1.D1_COD = SB1.B1_COD  " + Chr(13)
cQuery += "INNER JOIN SF4010 SF4 ON  " + Chr(13)
cQuery += "SD1.D1_TES = SF4.F4_CODIGO  " + Chr(13)
cQuery += "AND SF4.D_E_L_E_T_ <> '*' " + Chr(13)

cQuery += "AND SF4.F4_DUPLIC = 'S' " + Chr(13)

cQuery += "INNER JOIN SF1010 SF1 ON  " + Chr(13)
cQuery += "SF1.F1_SERIE = SD1.D1_SERIE AND  " + Chr(13)
cQuery += "SF1.F1_DOC = SD1.D1_DOC AND " + Chr(13)
cQuery += "SF1.F1_DTDIGIT = SD1.D1_DTDIGIT AND " + Chr(13)
cQuery += "SF1.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "WHERE SD1.D_E_L_E_T_ <> '*' AND " + Chr(13)
cQuery += "SD1.D1_TIPO = 'D' AND  " + Chr(13)
cQuery += "SD1.D1_DTDIGIT BETWEEN '" + dTOS(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND " + Chr(13)
cQuery += "SD1.D1_FORNECE BETWEEN'" + mv_par03 + "' AND '" + mv_par04 + "' AND " + Chr(13)
cQuery += "SD1.D1_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' " + Chr(13)

memowrite("GERENTR",cQuery)

TcQuery cQuery New Alias (cAliasD2:=GetNextAlias())

If (cAliasD2)->(!Eof())
	_lRet := .T.
EndIf


oExcel:AddworkSheet("PARÂMETROS")
oExcel:AddTable("PARÂMETROS","PARÂMETROS")
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","PARAMETROS",1,1)
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","VALOR",1,1)

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Data Digitação De',;
DTOC(mv_par01)})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Data Digitação Até',;
DTOC(mv_par02)})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'liente De',;
mv_par03})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Cliente Até',;
mv_par04})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Produto De',;
mv_par05})

oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Produto Até',;
mv_par06})

oExcel:AddworkSheet("RELATÓRIO")
oExcel:AddTable("RELATÓRIO","DEVOLUÇÃO")
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","DIGITAC",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","NOTA",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","TIPO",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","CLIENTE",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","LJ_CLIENTE",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","NREDUZ",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","COD_PROD",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","PRODUTO",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","DESCRIC",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","QUANT",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLR_UNIT",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","TOTAL",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLRFRETE",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLRDESP",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLR_SEG",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLRDESC",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLRICMS",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","ICMS_COMP",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLRIPI",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLR_COF",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","VLR_PIS",1,1)
oExcel:AddColumn("RELATÓRIO","DEVOLUÇÃO","CUSTO",1,1)

(cAliasD2)->(DbGotOP())

While !(cAliasD2)->(EOF())

oExcel:AddRow("RELATÓRIO","DEVOLUÇÃO",{(cAliasD2)->DIGITAC,;
(cAliasD2)->NOTA,;
(cAliasD2)->TIPO,;
(cAliasD2)->CLIENTE,;
(cAliasD2)->LJ_CLIENTE,;
(cAliasD2)->NREDUZ,;
(cAliasD2)->COD_PROD,;
(cAliasD2)->PRODUTO,;
(cAliasD2)->DESCRIC,;
(cAliasD2)->QUANT,;
(cAliasD2)->VLR_UNIT,;
(cAliasD2)->TOTAL,;
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

Plan04()