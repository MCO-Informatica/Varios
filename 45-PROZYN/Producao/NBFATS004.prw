#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณParcial de Vendas บAutor  ณDenisVarellaบ Data ณ  28/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de relat๓rio Fretes sobre vendas		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NBFAT004()

Local cPerg		:= PadR("NBFAT004",10)    
       
AjustaSX1(cPerg)
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
Local j
Local i
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := PADR(cPerg,10)
aSx1   :={}

AADD(	aSx1,{ cPerg,"01","Data NF Saํda De				","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"02","Data NF Saํda At้			","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"03","Data Digit. CT-e De			","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"04","Data Digit. CT-e At้			","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"05","Vendedor De					","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(	aSx1,{ cPerg,"06","Vendedor At้					","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})

For i := 1 to Len(aSx1)
	If !dbSeek(cPerg+aSx1[i,2])
		RecLock("SX1",.T.)
		For j := 1 To FCount()
			If j <= Len(aSx1[i])
				FieldPut(j,aSx1[i,j])
			Else
				Exit
			EndIf
		Next
		MsUnlock()
	EndIf
Next

dbSelectArea(_sAlias)

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

Private _nHandle  := FCreate(_cArquivo)


If Select("FSV") > 0
	DbSelectArea("FSV")
	DbCloseArea()
EndIf

BeginSql alias "FSV"
	SELECT A3_COD,A3_NOME,F1_FORNECE,A2_NOME,F2_EMISSAO,D1_NFSAIDA,F1_DOC,F1_DTDIGIT,F1_VALBRUT FROM %table:SF2% F2
	INNER JOIN %table:SD1% D1 ON D1.D1_FILIAL = %xfilial:SD1% AND D1_NFSAIDA = F2_DOC AND D1.%notDel%
	INNER JOIN %table:SF1% F1 ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND F1.%notDel%
	INNER JOIN %table:SA2% A2 ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND A2.%notDel%
	INNER JOIN %table:SA3% A3 ON A3_COD = F2_VEND1 AND A3.%notDel%
	WHERE F2.%notDel% and F2.F2_FILIAL = %xfilial:SF2% AND
	F2.F2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% AND
	F1.F1_DTDIGIT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% AND
	F2.F2_VEND1 BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
	ORDER BY A3_COD,F2_EMISSAO,D1_DTDIGIT
EndSql

If FSV->(!Eof())
	_lRet := .T.
EndIf

oExcel:AddworkSheet("PARยMETROS")
oExcel:AddTable("PARยMETROS","PARยMETROS")
oExcel:AddColumn("PARยMETROS","PARยMETROS","PARAMETROS",1,1)
oExcel:AddColumn("PARยMETROS","PARยMETROS","VALOR",1,1)
oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data NF Saํda De',;
DTOC(mv_par01)})
oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data NF Saํda At้',;
DTOC(mv_par02)})
oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Digit. CT-e De',;
DTOC(mv_par03)})
oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Digit. CT-e At้',;
DTOC(mv_par04)})
oExcel:AddRow("PARยMETROS","PARยMETROS",{'Vendedor De',;
mv_par05})
oExcel:AddRow("PARยMETROS","PARยMETROS",{'Vendedor At้',;
mv_par06})

oExcel:AddworkSheet("Fretes Sobre Vendas")
oExcel:AddTable("Fretes Sobre Vendas","Fretes Sobre Vendas")
oExcel:AddColumn("Fretes Sobre Vendas","Fretes Sobre Vendas","Vendedor",1,1)
oExcel:AddColumn("Fretes Sobre Vendas","Fretes Sobre Vendas","Transportadora",1,1)
oExcel:AddColumn("Fretes Sobre Vendas","Fretes Sobre Vendas","Emissใo NF Saํda",1,1)
oExcel:AddColumn("Fretes Sobre Vendas","Fretes Sobre Vendas","Nota Fiscal Saํda",1,1)
oExcel:AddColumn("Fretes Sobre Vendas","Fretes Sobre Vendas","CT-e",1,1)
oExcel:AddColumn("Fretes Sobre Vendas","Fretes Sobre Vendas","Data de Digita็ใo",1,1)
oExcel:AddColumn("Fretes Sobre Vendas","Fretes Sobre Vendas","Valor",1,2)

FSV->(DbGotOP())

While !FSV->(EOF())
oExcel:AddRow("Fretes Sobre Vendas","Fretes Sobre Vendas",{FSV->A3_NOME,;
FSV->A2_NOME,;
DTOC(STOD(FSV->F2_EMISSAO)),;
FSV->D1_NFSAIDA,;
FSV->F1_DOC,;
DTOC(STOD(FSV->F1_DTDIGIT)),;
FSV->F1_VALBRUT})

FSV->(DbSKip())
Enddo

FSV->(DbCloseArea())

oExcel:Activate()
oExcel:GetXMLFile(_cArquivo+".xml")

__CopyFile(_cArquivo+".xml",_cPathExcel+"FreteSobreVendas - "+_cArquivo+".xml")

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cPathExcel+"FreteSobreVendas - "+_cArquivo+".xml") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

Return

Plan02()