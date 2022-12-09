#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณTTD2 บAutor  ณOsmairStellzer           บ Data ณ  20/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de Nf.s canceladas:           					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function NBFIS005()

Local cPerg		:= PadR("NBFIS005",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)

	Processa( {|| Plan03() },"Aguarde" ,"Processando...")

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
AADD(	aSx1,{ cPerg,"01","Data Emissใo De?"			,"mv_par01"	,"D",8,0,0, "G","", 	"mv_par01","","","","","","" } )
AADD(	aSx1,{ cPerg,"02","Data Emissใo At้?"			,"mv_par02"	,"D",8,0,0, "G","",		"mv_par02","","","","","","" } )

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
ฑฑณFuno	 ณ Plan03()       ณ Autor ณ AF Custom       ณ Data ณ 27/11/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
cQuery += "F3_NFISCAL NF_FISCAL, " +  Chr(13)
cQuery += "F3_SERIE NF_SERIE, " + Chr(13)
cQuery += "F3_EMISSAO DATA_EMISSAO, " + Chr(13)
cQuery += "F3_DTCANC DATA_CANCELAMENTO, " + Chr(13)
cQuery += "F3_CFO CFOP, " + Chr(13)
cQuery += "F3_ESTADO ESTADO,  " + Chr(13)
cQuery += "F3_OBSERV OBSERVACOES, " + Chr(13) 
cQuery += "F3_CHVNFE CHV_NFE,  " + Chr(13)
cQuery += "F3_PROTOC PROTOC_DOC " + Chr(13)
cQuery += "FROM SF3010 F3 " + Chr(13)
cQuery += "WHERE F3.D_E_L_E_T_ <> '*' AND " + Chr(13)
cQuery += "F3_EMISSAO BETWEEN '" + dTOS(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND " + Chr(13)
cQuery += "F3_DTCANC <> '' " + Chr(13)
cQuery += "ORDER BY F3.F3_SERIE, F3.F3_NFISCAL " + Chr(13)

memowrite("GERAI",cQuery)

TcQuery cQuery New Alias (cAliasF3:=GetNextAlias())

If (cAliasF3)->(!Eof())
	_lRet := .T.
EndIf


oExcel:AddworkSheet("PARยMETROS")
oExcel:AddTable("PARยMETROS","PARยMETROS")
oExcel:AddColumn("PARยMETROS","PARยMETROS","PARAMETROS",1,1)
oExcel:AddColumn("PARยMETROS","PARยMETROS","VALOR",1,1)

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Emissใo De',;
DTOC(mv_par01)})

oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Emissใo At้',;
DTOC(mv_par02)})

oExcel:AddworkSheet("RELATำRIO")
oExcel:AddTable("RELATำRIO","NF CANCELADA")
oExcel:AddColumn("RELATำRIO","NF CANCELADA","NOTA",1,1)
oExcel:AddColumn("RELATำRIO","NF CANCELADA","SERIE",1,1) 
oExcel:AddColumn("RELATำRIO","NF CANCELADA","DATA EMISSรO",1,1)
oExcel:AddColumn("RELATำRIO","NF CANCELADA","DATA CANCELAMENTO",1,1)
oExcel:AddColumn("RELATำRIO","NF CANCELADA","CFOP",1,1)
oExcel:AddColumn("RELATำRIO","NF CANCELADA","ESTADO",1,1)
oExcel:AddColumn("RELATำRIO","NF CANCELADA","OBSERVAวีES",1,1)
oExcel:AddColumn("RELATำRIO","NF CANCELADA","CHV_NFE",1,1)
oExcel:AddColumn("RELATำRIO","NF CANCELADA","PROTOCOLO_DOCUMENTO",1,1)

(cAliasF3)->(DbGotOP())

While !(cAliasF3)->(EOF())

oExcel:AddRow("RELATำRIO","NF CANCELADA",{(cAliasF3)->NF_FISCAL,;
(cAliasF3)->NF_SERIE,;
(cAliasF3)->DATA_EMISSAO,;
(cAliasF3)->DATA_CANCELAMENTO,;
(cAliasF3)->CFOP,;
(cAliasF3)->ESTADO,;
(cAliasF3)->OBSERVACOES,;
(cAliasF3)->CHV_NFE,;
(cAliasF3)->PROTOC_DOC})

(cAliasF3)->(DbSKip())
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