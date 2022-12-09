#include 'TOTVS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOPXVENDAS บAutor  ณ Adinfo Consultoria บ Data ณ  20/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de OP amarrado a nota fiscal emitida no dia da      บฑฑ
ฑฑบ          ณprodu็ใo da OP.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProjeto Verion                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function OPVENDAG()
//base programa ES_POSEST

Local aSays := {}, aButtons := {}
Local nOpca := 0
Private cPerg := "OPXVENDAS"
Private lEnd  := .T.
Private nRegs :=0
Private aDtINI 	:= {}	//array com a data do primeiro fechamento
Private aMeses	:= {}	//array com os meses para calculo (12)
Private cCadastro := 'Geracao de planilha excel com as OPดs amarrada com as vendas'
Private nMeses
Private nTotalRec
Private nRowCount
nlHandle  := 0

AjustaSX1(cPerg)

AADD(aSays,OemToAnsi( "	Este programa tem o objetivo de gerar uma planilha " ) )
AADD(aSays,OemToAnsi( "em Excel com as OPดs e as vendas amarradas a elas.  " ) )
AADD(aSays,OemToAnsi( "" ) )
AADD(aSays,OemToAnsi( "" ) )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa o log de processamento                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ProcLogIni( aButtons )

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| (nOpca:= 1, FechaBatch()) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons ,,,470)

If nOpca == 1
	Pergunte(cPerg,.F.)
	
	Processa( {|| lEnd :=  GeraQRY() })
	IF !lEnd
		Processa( {|| GeraXML() })
	Endif
Endif

return

Static Function GeraQRY()
Local cQuery 	:= ''
Local cQuerr 	:= ''
Local cQuerj 	:= ''
Local cQuerS 	:= ''
Local lRet  	:= .F.

// TRATAMENTO DAS MOVIMENTACOES INTERNAS COM ORDEM DE PRODUCAO
cQuery := " SELECT D3_EMISSAO, D3_DOC, D3_OP, D3_CF, D3_COD, D3_QUANT, D3_UM, D3_CUSTO1"
cQuery += " FROM "+RetSqlName("SD3")
cQuery += " WHERE D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuery += " AND D3_OP <> ''"
cQuery += " ORDER BY D3_DOC,D3_EMISSAO,D3_OP,D3_CUSTO1"

IF Select("TRB")>0
	DbSelectArea("TRB")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
TcSetField("TRB", "D3_EMISSAO", "D", 08, 0)
nRowCount := 0 // n๚mero de linhas excel
dbSelectArea("TRB")
Dbgotop()
While !Eof()
	nRowCount ++
	DbSelectArea("TRB")
	DbsKip()
End

// TRATAMENTO DAS MOVIMENTACOES INTERNAS DE TRANSFORMACวรO A IDENTIFICAR
cQuerr := " SELECT D3_EMISSAO, D3_DOC, D3_OP, D3_CF, D3_COD, D3_QUANT, D3_UM, D3_CUSTO1,D3_TM,D3_CLIENTE"
cQuerr += " FROM "+RetSqlName("SD3")
cQuerr += " WHERE D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuerr += " AND D3_OP = '' AND D3_TM IN ('501','002')"
cQuerr += " ORDER BY D3_DOC,D3_EMISSAO, D3_TM, D3_CUSTO1"

IF Select("TRR") > 0
	DbSelectArea("TRR")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuerr), "TRR", .F., .T.)
TcSetField("TRR", "D3_EMISSAO", "D", 08, 0)

dbSelectArea("TRR")
Dbgotop()
While !Eof()
	nRowCount ++
	DbSelectArea("TRR")
	DbsKip()
End

If nRowCount == 0
	lRet := .T.
	MsgStop("Nใo existe registros no intervalo dos parametros.")
Endif

// TRATAMENTO DAS NOTAS DE SAIDAS
cQuerJ := " SELECT D2_EMISSAO,D2_DOC,D2_OP,D2_CF,D2_COD,D2_QUANT,D2_UM,D2_CUSTO1,D2_TES,D2_TOTAL,D2_VALICM,D2_VALIMP5,D2_VALIMP6,D2_CLIENTE,D2_LOJA,D2_PEDIDO"
cQuerJ += " FROM "+RetSqlName("SD2")
cQuerJ += " WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuerJ += " AND D2_OP = '' AND D2_TIPO = 'N' "
cQuerJ += " AND D2_TES IN ('504','516','517','518','519','521','526','528','529','530','532','535','536','542','633','634')"
cQuerJ += " ORDER BY D2_DOC,D2_EMISSAO,D2_TES"

IF Select("TRD") > 0
	DbSelectArea("TRD")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuerJ), "TRD", .F., .T.)
TcSetField("TRD", "D2_EMISSAO", "D", 08, 0)

dbSelectArea("TRD")
Dbgotop()
While !Eof()
	nRowCount ++
	DbSelectArea("TRD")
	DbsKip()
End

If nRowCount == 0
	lRet := .T.
	MsgStop("Nใo existe registros no intervalo dos parametros.")
Endif

// TRATAMENTO DAS NOTAS DE SAIDAS SERVICO
cQuerS := " SELECT D2_EMISSAO,D2_DOC,D2_OP,D2_CF,D2_COD,D2_QUANT,D2_UM,D2_CUSTO1,D2_TES,D2_TOTAL,D2_VALICM,D2_VALIMP5,D2_VALIMP6,D2_CLIENTE,D2_LOJA,D2_PEDIDO"
cQuerS += " FROM "+RetSqlName("SD2")
cQuerS += " WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuerS += " AND D2_OP = '' AND D2_TIPO = 'N' "
cQuerS += " AND D2_TES IN ('502','830')"
cQuerS += " ORDER BY D2_DOC,D2_EMISSAO,D2_TES"

IF Select("TRS") > 0
	DbSelectArea("TRS")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuerS), "TRS", .F., .T.)
TcSetField("TRS", "D2_EMISSAO", "D", 08, 0)

dbSelectArea("TRS")
Dbgotop()
While !Eof()
	nRowCount ++
	DbSelectArea("TRS")
	DbsKip()
End

If nRowCount == 0
	lRet := .T.
	MsgStop("Nใo existe registros no intervalo dos parametros.")
Endif

// TRATAMENTO DAS MOVIMENTACOES INTERNAS DE AJUSTE DE IMPORTACOES
cQuerr := " SELECT D3_EMISSAO, D3_DOC, D3_OP, D3_CF, D3_COD, D3_QUANT, D3_UM, D3_CUSTO1,D3_TM,D3_CLIENTE"
cQuerr += " FROM "+RetSqlName("SD3")
cQuerr += " WHERE D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuerr += " AND D3_OP = '' AND D3_TM IN ('502','004')"
cQuerr += " ORDER BY D3_DOC,D3_EMISSAO, D3_TM, D3_CUSTO1"

IF Select("TRW") > 0
	DbSelectArea("TRW")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuerr), "TRW", .F., .T.)
TcSetField("TRW", "D3_EMISSAO", "D", 08, 0)

dbSelectArea("TRW")
Dbgotop()
While !Eof()
	nRowCount ++
	DbSelectArea("TRW")
	DbsKip()
End

If nRowCount == 0
	lRet := .T.
	MsgStop("Nใo existe registros no intervalo dos parametros.")
Endif

nRowCount := nRowCount * 2 //duplica linhas para evitar erros no excel

return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_PMSSR  บAutor  ณMicrosiga           บ Data ณ  07/31/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraXML()
Local clArqExl	:= criatrab(,.f.) + '.xml'//"ES_POSEST.XML"
Local clArq3  	:= ""
Local cDirTemp    := GetTempPath()

nRegs := 10 //cArqTmp->(RECCOUNT())

IF Right(Alltrim(cDirTemp),1) # "\"
	cDirTemp := Alltrim(cDirTemp)+"\"
Endif

nlHandle := FCreate(Alltrim(cDirTemp) + clArqExl)

If FERROR() != 0
	Alert("Nใo foi possํvel abrir ou criar o arquivo: " + clArqExl )
	return
else
	
	clArq3	:= '<?xml version="1.0"?>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<?mso-application progid="Excel.Sheet"?>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' xmlns:o="urn:schemas-microsoft-com:office:office"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <Author>Gelson</Author>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <LastAuthor>Gelson</LastAuthor>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <Created>2012-10-26T22:20:39Z</Created>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <LastSaved>2012-10-26T23:04:19Z</LastSaved>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <Version>14.00</Version>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' </DocumentProperties>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <AllowPNG/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' </OfficeDocumentSettings>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <WindowHeight>7995</WindowHeight>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <WindowWidth>20115</WindowWidth>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <WindowTopX>240</WindowTopX>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <WindowTopY>75</WindowTopY>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <ProtectStructure>False</ProtectStructure>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <ProtectWindows>False</ProtectWindows>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' </ExcelWorkbook>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Styles>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="Default" ss:Name="Normal">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	//--------------------------------------------------------------------------------------------------
	clArq3	:= '<Style ss:ID="s93">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	//--------------------------------------------------------------------------------------------------
	clArq3	:= '<Style ss:ID="s94">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	//----------------------------------------------------------------------------------------------
	clArq3	:= '<Style ss:ID="s95">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Borders/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= 'ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Interior ss:Color="#92CDDC" ss:Pattern="Solid"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="s96">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="s97" ss:Name="Separador de milhares">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	//	clArq3	+= '<NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CRLF
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="s98">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= 'ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Interior ss:Color="#FAC090" ss:Pattern="Solid"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="s99">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11" ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="s16">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Interior ss:Color="#002060" ss:Pattern="Solid"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="s88">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<NumberFormat ss:Format="_-* #,##0_-;\-* #,##0_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Style ss:ID="s37">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Styles>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' <Worksheet ss:Name="Op x Vendas">'+CRLF //nome da planilha
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <Table ss:ExpandedColumnCount="74" ss:ExpandedRowCount="' + alltrim(str(nRowCount)) + '" x:FullColumns="1"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   x:FullRows="1" ss:DefaultColumnWidth="87.75" ss:DefaultRowHeight="15">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="64.5"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="79.5"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="66.00"/>'+CRLF //largura da coluna: documento
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="74.25"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="66.00"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="66.75" ss:Span="1"/>'+CRLF //59
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Column ss:Index="10" ss:AutoFitWidth="0" ss:Width="206.25"/>'+CRLF  //largura da coluna: Descri็ใo
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Row ss:Height="15.75">'+CRLF //Altura da linha
	FWRITE(nlHandle, clArq3)
	//cabe็alho das linhas / colunas
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Data Emissao</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Cod. Cliente</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Cliente</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Documento</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Ord Producao</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Tipo RE/DE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Moeda</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Grupo</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Produto</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Descricao</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Quantidade</Data></Cell>'+CRLF //???
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">UM</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Custo Unitario</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Custo Total</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Fator Conv</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Valor Compra</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Valor Venda</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Euro</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Dolar</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Cod.Vendedor</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Nome Vendedor</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Numero NF</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Valor Bruto</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Valor Liq. NF</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Tipo Movimenta็ใo</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </Row>		'+CRLF
	FWRITE(nlHandle, clArq3)

	DbSelectArea("TRB")
	dbgotop()
	While !Eof()
		
		_cDocAnt := TRB->D3_DOC
		While !Eof() .and. _cDocAnt == TRB->D3_DOC
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+TRB->D3_COD)
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM")+SB1->B1_GRUPO)
			
			_cCodCli   := ""
			_cNomeCli  := ""
			_cCodVend  := ""
			_cNomeVend := ""
			_cNF       := ""
			_nValLiqNF := 0
			_nValBruto := 0
			_nMoeda4   := 0
			_nMoeda2   := 0
			
			If TRB->D3_CF == "PR0"
				DbSelectArea("SD2")
				DbsetOrder(6)
				DbSeek(xFilial("SD2")+TRB->D3_COD+"01"+DTOS(TRB->D3_EMISSAO),.T.)
				_lContinua := .T.
				While !Eof() .and. SD2->D2_EMISSAO >= TRB->D3_EMISSAO .and. _lContinua
					If TRB->D3_COD == SD2->D2_COD .AND. SD2->D2_EMISSAO >= TRB->D3_EMISSAO //.AND. TRB->D3_QUANT == SD2->D2_QUANT
						
						DbSelectArea("SA1")
						DbSetOrder(1)
						DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						
						DbSelectArea("SC5")
						DbSetOrder(1)
						DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
						
						DbSelectArea("SA3")
						DbSetOrder(1)
						DbSeek(xFilial("SA3")+SC5->C5_VEND1)
						
						DbSelectArea("SM2")
						DbSetOrder(1)
						DbSeek(DTOS(SD2->D2_EMISSAO))
						
						_cCodCli   := SD2->D2_CLIENTE+"/"+SD2->D2_LOJA
						_cNomeCli  := SA1->A1_NOME
						_cCodVend  := SC5->C5_VEND1
						_cNomeVend := SA3->A3_NOME
						_nMoeda4   := SM2->M2_MOEDA4
						_nMoeda2   := SM2->M2_MOEDA2
						_cNF       := SD2->D2_DOC
						_nValBruto := SD2->D2_TOTAL
						_nValLiqNF := SD2->D2_TOTAL-SD2->D2_VALICM-SD2->D2_VALIMP5-SD2->D2_VALIMP6
						_lContinua := .F.
					Endif
					
					DbSelectArea("SD2")
					DbSkip()
				Enddo
			Endif
			
			clArq3	:= '   <Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + DTOC(TRB->D3_EMISSAO) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRB->D3_DOC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRB->D3_OP + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRB->D3_CF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + ALLTRIM(SBM->BM_MOEDA) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_GRUPO + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRB->D3_COD + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_DESC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRB->D3_QUANT,'@E 999999,999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRB->D3_UM + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRB->D3_CUSTO1/TRB->D3_QUANT,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRB->D3_CUSTO1,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SBM->BM_FATOR,'@E 99'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERCOM,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERVEN,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda4,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda2,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValBruto,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValLiqNF,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '   </Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			DbSelectArea('TRB')
			DbSkip()
			
		End
		LinhaBranca()
		LinhaBranca()
	End
	
	LinhaBranca()
	clArq3	:= '   <Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String"> TRANSFORMAวรO </Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	LinhaBranca()
	
	// IMPRESSAO DA TRANSFORMACAO (SD3) TM = 002 / 501
	nnrrq := 0
	DbSelectArea("TRR")
	dbgotop()
	While !Eof()
		_cDocAnt := Substr(TRR->D3_DOC,1,5)
		While !Eof() .and. _cDocAnt == Substr(TRR->D3_DOC,1,5)
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+TRR->D3_COD)
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM")+SB1->B1_GRUPO)
			
			_cCodCli   := ""
			_cNomeCli  := ""
			_cCodVend  := ""
			_cNomeVend := ""
			_cNF       := ""
			_nValLiqNF := 0
			_nValBruto := 0
			_nMoeda4   := 0
			_nMoeda2   := 0
			_cNomeCli  := TRR->D3_CLIENTE
			_nMoeda4   := SM2->M2_MOEDA4
			_nMoeda2   := SM2->M2_MOEDA2
			_cTrrTm    := TRR->D3_TM
			
			//			IF  TRR->D3_TM == "501" .and. nnrrq = 0
			//  				nnrrq++
			//			    LinhaBranca()
			//			    LinhaBranca()
			//			ENDIF
			
			/*
			If TRB->D3_CF == "PR0"
			DbSelectArea("SD2")
			DbsetOrder(6)
			DbSeek(xFilial("SD2")+TRB->D3_COD+"01"+DTOS(TRB->D3_EMISSAO),.T.)
			_lContinua := .T.
			While !Eof() .and. SD2->D2_EMISSAO >= TRB->D3_EMISSAO .and. _lContinua
			If TRB->D3_COD == SD2->D2_COD .AND. SD2->D2_EMISSAO >= TRB->D3_EMISSAO //.AND. TRB->D3_QUANT == SD2->D2_QUANT
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
			
			DbSelectArea("SA3")
			DbSetOrder(1)
			DbSeek(xFilial("SA3")+SC5->C5_VEND1)
			
			DbSelectArea("SM2")
			DbSetOrder(1)
			DbSeek(DTOS(SD2->D2_EMISSAO))
			
			_cCodCli   := SD2->D2_CLIENTE+"/"+SD2->D2_LOJA
			_cNomeCli  := SA1->A1_NOME
			_cCodVend  := SC5->C5_VEND1
			_cNomeVend := SA3->A3_NOME
			_nMoeda4   := SM2->M2_MOEDA4
			_nMoeda2   := SM2->M2_MOEDA2
			_cNF       := SD2->D2_DOC
			_nValBruto := SD2->D2_TOTAL
			_nValLiqNF := SD2->D2_TOTAL-SD2->D2_VALICM-SD2->D2_VALIMP5-SD2->D2_VALIMP6
			_lContinua := .F.
			Endif
			
			DbSelectArea("SD2")
			DbSkip()
			Enddo
			Endif
			*/
			
			clArq3	:= '   <Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + DTOC(TRR->D3_EMISSAO) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRR->D3_DOC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRR->D3_OP + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRR->D3_CF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + ALLTRIM(SBM->BM_MOEDA) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_GRUPO + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRR->D3_COD + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_DESC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRR->D3_QUANT,'@E 999999,999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRR->D3_UM + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRR->D3_CUSTO1/TRR->D3_QUANT,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRR->D3_CUSTO1,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SBM->BM_FATOR,'@E 99'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERCOM,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERVEN,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda4,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda2,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValBruto,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValLiqNF,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="String">'+_cTrrTm+'</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '   </Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			DbSelectArea('TRR')
			DbSkip()
		End
	End


	LinhaBranca()
	clArq3	:= '   <Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String"> IMPORTAวOES </Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	LinhaBranca()
	
	// IMPRESSAO DA IMPORTACOES (SD23) TM = 004 / 502
	nnrrq := 0
	DbSelectArea("TRW")
	dbgotop()
	While !Eof()
		_cDocAnt := Substr(TRW->D3_DOC,1,5)
		While !Eof() .and. _cDocAnt == Substr(TRW->D3_DOC,1,5)
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+TRW->D3_COD)
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM")+SB1->B1_GRUPO)
			
			_cCodCli   := ""
			_cNomeCli  := ""
			_cCodVend  := ""
			_cNomeVend := ""
			_cNF       := ""
			_nValLiqNF := 0
			_nValBruto := 0
			_nMoeda4   := 0
			_nMoeda2   := 0
			_cNomeCli  := TRW->D3_CLIENTE
			_nMoeda4   := SM2->M2_MOEDA4
			_nMoeda2   := SM2->M2_MOEDA2
			_cTrrTm    := TRW->D3_TM
			
			//			IF  TRR->D3_TM == "501" .and. nnrrq = 0
			//  				nnrrq++
			//			    LinhaBranca()
			//			    LinhaBranca()
			//			ENDIF
			
			/*
			If TRB->D3_CF == "PR0"
			DbSelectArea("SD2")
			DbsetOrder(6)
			DbSeek(xFilial("SD2")+TRB->D3_COD+"01"+DTOS(TRB->D3_EMISSAO),.T.)
			_lContinua := .T.
			While !Eof() .and. SD2->D2_EMISSAO >= TRB->D3_EMISSAO .and. _lContinua
			If TRB->D3_COD == SD2->D2_COD .AND. SD2->D2_EMISSAO >= TRB->D3_EMISSAO //.AND. TRB->D3_QUANT == SD2->D2_QUANT
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
			
			DbSelectArea("SA3")
			DbSetOrder(1)
			DbSeek(xFilial("SA3")+SC5->C5_VEND1)
			
			DbSelectArea("SM2")
			DbSetOrder(1)
			DbSeek(DTOS(SD2->D2_EMISSAO))
			
			_cCodCli   := SD2->D2_CLIENTE+"/"+SD2->D2_LOJA
			_cNomeCli  := SA1->A1_NOME
			_cCodVend  := SC5->C5_VEND1
			_cNomeVend := SA3->A3_NOME
			_nMoeda4   := SM2->M2_MOEDA4
			_nMoeda2   := SM2->M2_MOEDA2
			_cNF       := SD2->D2_DOC
			_nValBruto := SD2->D2_TOTAL
			_nValLiqNF := SD2->D2_TOTAL-SD2->D2_VALICM-SD2->D2_VALIMP5-SD2->D2_VALIMP6
			_lContinua := .F.
			Endif
			
			DbSelectArea("SD2")
			DbSkip()
			Enddo
			Endif
			*/
			
			clArq3	:= '   <Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + DTOC(TRW->D3_EMISSAO) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRW->D3_DOC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRW->D3_OP + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRW->D3_CF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + ALLTRIM(SBM->BM_MOEDA) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_GRUPO + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRW->D3_COD + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_DESC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRW->D3_QUANT,'@E 999999,999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRW->D3_UM + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRW->D3_CUSTO1/TRW->D3_QUANT,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRW->D3_CUSTO1,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SBM->BM_FATOR,'@E 99'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERCOM,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERVEN,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda4,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda2,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValBruto,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValLiqNF,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="String">'+_cTrrTm+'</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '   </Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			DbSelectArea('TRW')
			DbSkip()
		End
	End


    // TRATAMENTO DE REVENDA (SD2)
	LinhaBranca()
	clArq3	:= '   <Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">REVENDAS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	LinhaBranca()
	
	// IMPRESSAO DA REVENDA TES ('504','516','517','518','519','521','526','528','529','530','532','535','536','542','633','634') 
	nnrrq := 0
	DbSelectArea("TRD")
	dbgotop()
	While !Eof()
		_cDocAnt := TRD->D2_DOC
		While !Eof() .and. _cDocAnt == TRD->D2_DOC
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+TRD->D2_COD)
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM")+SB1->B1_GRUPO)

			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+TRD->D2_CLIENTE+TRD->D2_LOJA)
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+TRD->D2_PEDIDO)
			
			DbSelectArea("SA3")
			DbSetOrder(1)
			DbSeek(xFilial("SA3")+SC5->C5_VEND1)
			
			DbSelectArea("SM2")
			DbSetOrder(1)
			DbSeek(DTOS(TRD->D2_EMISSAO))
			
			_cCodCli   := TRD->D2_CLIENTE+"/"+TRD->D2_LOJA
			_cNomeCli  := SA1->A1_NOME
			_cCodVend  := SC5->C5_VEND1
			_cNomeVend := SA3->A3_NOME
			_nMoeda4   := SM2->M2_MOEDA4
			_nMoeda2   := SM2->M2_MOEDA2
			_cNF       := TRD->D2_DOC
			_nValBruto := TRD->D2_TOTAL
			_nValLiqNF := TRD->D2_TOTAL-TRD->D2_VALICM-TRD->D2_VALIMP5-TRD->D2_VALIMP6
			_lContinua := .F.

			clArq3	:= '   <Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + DTOC(TRD->D2_EMISSAO) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRD->D2_DOC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRD->D2_OP + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRD->D2_CF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + ALLTRIM(SBM->BM_MOEDA) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_GRUPO + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRD->D2_COD + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_DESC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRD->D2_QUANT,'@E 999999,999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRD->D2_UM + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRD->D2_CUSTO1/TRD->D2_QUANT,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRD->D2_CUSTO1,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SBM->BM_FATOR,'@E 99'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERCOM,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERVEN,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda4,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda2,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValBruto,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValLiqNF,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '   </Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			DbSelectArea('TRD')
			DbSkip()
		End
	End
	LinhaBranca()
	
    // TRATAMENTO DE SERVICOS (SD2)
	LinhaBranca()
	clArq3	:= '   <Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">SERVICOS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	LinhaBranca()
	
	// IMPRESSAO DE SERVICOS TES ('502','830') 
	nnrrq := 0
	DbSelectArea("TRS")
	dbgotop()
	While !Eof()
		_cDocAnt := TRS->D2_DOC
		While !Eof() .and. _cDocAnt == TRS->D2_DOC
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+TRS->D2_COD)
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM")+SB1->B1_GRUPO)

			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+TRS->D2_CLIENTE+TRS->D2_LOJA)
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+TRS->D2_PEDIDO)
			
			DbSelectArea("SA3")
			DbSetOrder(1)
			DbSeek(xFilial("SA3")+SC5->C5_VEND1)
			
			DbSelectArea("SM2")
			DbSetOrder(1)
			DbSeek(DTOS(TRS->D2_EMISSAO))
			
			_cCodCli   := TRS->D2_CLIENTE+"/"+TRS->D2_LOJA
			_cNomeCli  := SA1->A1_NOME
			_cCodVend  := SC5->C5_VEND1
			_cNomeVend := SA3->A3_NOME
			_nMoeda4   := SM2->M2_MOEDA4
			_nMoeda2   := SM2->M2_MOEDA2
			_cNF       := TRS->D2_DOC
			_nValBruto := TRS->D2_TOTAL
			_nValLiqNF := TRS->D2_TOTAL-TRS->D2_VALICM-TRS->D2_VALIMP5-TRS->D2_VALIMP6
			_lContinua := .F.

			clArq3	:= '   <Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + DTOC(TRS->D2_EMISSAO) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeCli + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRS->D2_DOC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRS->D2_OP + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRS->D2_CF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + ALLTRIM(SBM->BM_MOEDA) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_GRUPO + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRS->D2_COD + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + SB1->B1_DESC + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRS->D2_QUANT,'@E 999999,999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + TRS->D2_UM + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRS->D2_CUSTO1/TRS->D2_QUANT,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(TRS->D2_CUSTO1,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SBM->BM_FATOR,'@E 99'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERCOM,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(SB1->B1_VERVEN,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda4,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nMoeda2,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cCodVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNomeVend + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s93"><Data ss:Type="String">' + _cNF + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValBruto,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '    <Cell ss:StyleID="s94"><Data ss:Type="Number">' + ALLTRIM(STRTRAN(Transform(_nValLiqNF,'@E 999999999.9999'),",",".")) + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			clArq3	:= '   </Row>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			DbSelectArea('TRD')
			DbSkip()
		End
	End

	
	clArq3	:= ' </Table>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <PageSetup>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Header x:Margin="0.31496062000000002"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Footer x:Margin="0.31496062000000002"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </PageSetup>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Print>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <ValidPrinterInfo/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <PaperSizeIndex>9</PaperSizeIndex>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <HorizontalResolution>-1</HorizontalResolution>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <VerticalResolution>-1</VerticalResolution>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </Print>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Selected/>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <Panes>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    <Pane>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '     <Number>3</Number>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '     <ActiveRow>2</ActiveRow>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '     <ActiveCol>4</ActiveCol>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '    </Pane>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   </Panes>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <ProtectObjects>False</ProtectObjects>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '   <ProtectScenarios>False</ProtectScenarios>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '  </WorksheetOptions>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' </Worksheet>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '</Workbook>'+CRLF
	FWRITE(nlHandle, clArq3)

	fClose(nlHandle)
	
	// ABERTURA DO EXCELL
	If File(Alltrim(cDirTemp) + clArqExl)
		If ApOleClient("MsExcel")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(Alltrim(cDirTemp) + clArqExl) // Abre uma planilha
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
		Else
			ApMsgStop( "Nao foi possivel Abrir Microsoft Excel.", "ATENวรO" )
		Endif
	Endif
Endif

return

Static Function LinhaBranca()
// Linha em Branco
clArq3	:= ' <Row>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
FWRITE(nlHandle, clArq3)
clArq3	:= ' </Row>'+CRLF
FWRITE(nlHandle, clArq3)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ Adinfo Consultoria บ Data ณ  20/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Grupo de perguntas                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)
Local aRegs     := {}
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
aAdd(aRegs,{cPerg,'01' ,'Data De'			   ,'Data De'							 	,'Data De'						 	,'mv_ch1','D'  ,08     ,0      ,0     ,'G','                                ','MV_PAR01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'',''})
aAdd(aRegs,{cPerg,'02' ,'Data Ate'			   ,'Data Ate'							 	,'Data Ate'						 	,'mv_ch2','D'  ,08     ,0      ,0     ,'G','                                ','MV_PAR02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'',''})
ValidPerg(aRegs,cPerg)
return