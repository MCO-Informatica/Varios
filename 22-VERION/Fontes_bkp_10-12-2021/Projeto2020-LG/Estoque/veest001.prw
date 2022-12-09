#include "FileIO.ch"

// execblock("veest001")
User Function VEEST001()
Local aCabec     := { { "GRUPO", "CODIGO", "DESCRICAO", "NCM", "LOCAL", "UNIDADE", "QUANTIDADE", "VAL COMPRA", "VAL VENDA", "MOEDA", "VAL UNIT CONTABIL" } }
Local aItens     := {}
Local cPerg      := "VEEST001"

GeraX1(@cPerg)
If Pergunte(cPerg, .T.)
	cSql := "          SELECT  B1_GRUPO, B2_COD, B1_DESC, B1_POSIPI, B2_LOCAL, B1_UM, B2_QATU, B1_VERCOM, B1_VERVEN, BM_MOEDA, B2_VERVALC  "
	cSql += "            FROM " + RetSqlName("SB2") + " SB2 "
	cSql += "            JOIN " + RetSqlName("SB1") + " SB1 "
	cSql += "              ON SB2.D_E_L_E_T_ = ' ' "
	cSql += "             AND SB2.B2_FILIAL  = '" + xFilial("SB2") + "' "
	cSql += "             AND SB1.D_E_L_E_T_ = ' ' "
	cSql += "             AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cSql += "             AND SB1.B1_COD     = SB2.B2_COD "
	cSql += "       LEFT JOIN " + RetSqlName("SBM") + " SBM "
	cSql += "              ON SBM.D_E_L_E_T_ = ' ' "
	cSql += "             AND SBM.BM_FILIAL  = '" + xFilial("SBM") + "' "
	cSql += "             AND SBM.BM_GRUPO   = SB1.B1_GRUPO "
	cSql += "           WHERE SB2.B2_LOCAL   BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cSql += "             AND SB1.B1_COD     BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cSql += "             AND SB1.B1_GRUPO   BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	cSql += "        ORDER BY B1_GRUPO, B2_COD "

	DbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cSql)),"TMPEST",.T.,.F.)
		While !TMPEST->(Eof())
			AAdd(aItens, {B1_GRUPO, B2_COD, B1_DESC, B1_POSIPI, B2_LOCAL, B1_UM, B2_QATU, B1_VERCOM, B1_VERVEN, BM_MOEDA, B2_VERVALC})
			TMPEST->(DbSkip())
		End
		
	TMPEST->(DbCloseArea())
	
	Processa( { || U_MkExcWB( aItens, aCabec )}, "Criando planilha....")

EndIf

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MkExcWB   ºAutor  ³André Cruz          º Data ³  20100208   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria um arquivo XML para o Excel no diretório indicado,    º±±
±±º          ³ o no diretório informado pelo parâmetro                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros³ aItens: Matriz MxN que contém os dados a serem colocados   º±±
±±º          ³         na planilha                                        º±±
±±º          ³ aCabec: Cabeçalho da planilha colocado na primeira linha   º±±
±±º          ³ lCabec: Indica se a primiera linha da matriz corresponde   º±±
±±º          ³         ao cabeçalho da planilha                           º±±
±±º          ³ cDirSrv:Diretório no servidor onde será salvo o arquivo    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorna   ³O nome do arquivo salvo no servidor ou Nil, caso não seja   º±±
±±º          ³possivel efetuar a gravação                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MkExcWB( aItens, aCabec )
Local cCreate   := AllTrim( Str( Year( dDataBase ) ) ) + "-" + AllTrim( Str( Month( dDataBase ) ) ) + "-" + AllTrim( Str( Day( dDataBase ) ) ) + "T" + SubStr( Time(), 1, 2 ) + ":" + SubStr( Time(), 4, 2 ) + ":" + SubStr( Time(), 7, 2 ) + "Z" // string de data no formato <Ano>-<Mes>-<Dia>T<Hora>:<Minuto>:<Segundo>Z
Local cFileName := CriaTrab( , .F. )+".xml"
Local i, j
Local cWorkBook := ""
Local cRow      := ""
Local nQtdLine  := 0

aCabec := Iif(aCabec == Nil, {}, aCabec)

If Empty(aCabec) .and. ValType(aHeader) == "A"
	nQtdLine := Len( aHeader )
	AAdd(aCabec, {})
	For i := 1 To nQtdLine
		AAdd( aCabec[1], aHeader[i][1] )
	Next
EndIf

ConOut("Criando o arquivo " + cFileName + ".")
If ( nHandle := FCreate( "\system\"+cFileName , FC_NORMAL ) ) != -1
	ConOut("Arquivo criado com sucesso.")
Else
	MsgAlert("Não foi possivel criar a planilha. Por favor, verifique se existe espaço em disco ou você possui pemissão de escrita no diretório \system\", "Erro de criação de arquivo")
	ConOut("Não foi possivel criar a planilha no diretório \system\")
EndIf

ProcRegua(Len(aItens)+Len(aCabec))
nFields := Iif(!Empty(aCabec),Len(aItens[1]),Len(aCabec[1]))

cWorkBook := "<?xml version=" + Chr(34) + "1.0" + Chr(34) + "?>" + Chr(13) + Chr(10)
cWorkBook += "<?mso-application progid=" + Chr(34) + "Excel.Sheet" + Chr(34) + "?>" + Chr(13) + Chr(10)
cWorkBook += "<Workbook xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:spreadsheet" + Chr(34) + " " + Chr(13) + Chr(10)
cWorkBook += "	xmlns:o=" + Chr(34) + "urn:schemas-microsoft-com:office:office" + Chr(34) + " " + Chr(13) + Chr(10)
cWorkBook += "	xmlns:x=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + " " + Chr(13) + Chr(10)
cWorkBook += "	xmlns:ss=" + Chr(34) + "urn:schemas-microsoft-com:office:spreadsheet" + Chr(34) + " " + Chr(13) + Chr(10)
cWorkBook += "	xmlns:html=" + Chr(34) + "http://www.w3.org/TR/REC-html40" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "	<DocumentProperties xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:office" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "		<Author>" + AllTrim(SubStr(cUsuario,7,15)) + "</Author>" + Chr(13) + Chr(10)
cWorkBook += "		<LastAuthor>" + AllTrim(SubStr(cUsuario,7,15)) + "</LastAuthor>" + Chr(13) + Chr(10)
cWorkBook += "		<Created>" + cCreate + "</Created>" + Chr(13) + Chr(10)
cWorkBook += "		<Company>Microsiga Intelligence</Company>" + Chr(13) + Chr(10)
cWorkBook += "		<Version>11.6568</Version>" + Chr(13) + Chr(10)
cWorkBook += "	</DocumentProperties>" + Chr(13) + Chr(10)
cWorkBook += "	<ExcelWorkbook xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "		<WindowHeight>9345</WindowHeight>" + Chr(13) + Chr(10)
cWorkBook += "		<WindowWidth>11340</WindowWidth>" + Chr(13) + Chr(10)
cWorkBook += "		<WindowTopX>480</WindowTopX>" + Chr(13) + Chr(10)
cWorkBook += "		<WindowTopY>60</WindowTopY>" + Chr(13) + Chr(10)
cWorkBook += "		<ProtectStructure>False</ProtectStructure>" + Chr(13) + Chr(10)
cWorkBook += "		<ProtectWindows>False</ProtectWindows>" + Chr(13) + Chr(10)
cWorkBook += "	</ExcelWorkbook>" + Chr(13) + Chr(10)
cWorkBook += "	<Styles>" + Chr(13) + Chr(10)
cWorkBook += "		<Style ss:ID=" + Chr(34) + "Default" + Chr(34) + " ss:Name=" + Chr(34) + "Normal" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "			<Alignment ss:Vertical=" + Chr(34) + "Bottom" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "			<Borders/>" + Chr(13) + Chr(10)
cWorkBook += "			<Font/>" + Chr(13) + Chr(10)
cWorkBook += "			<Interior/>" + Chr(13) + Chr(10)
cWorkBook += "			<NumberFormat/>" + Chr(13) + Chr(10)
cWorkBook += "			<Protection/>" + Chr(13) + Chr(10)
cWorkBook += "		</Style>" + Chr(13) + Chr(10)
cWorkBook += "	<Style ss:ID=" + Chr(34) + "s21" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "		<NumberFormat ss:Format=" + Chr(34) + "Short Date" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "	</Style>" + Chr(13) + Chr(10)
cWorkBook += "	</Styles>" + Chr(13) + Chr(10)
cWorkBook += " <Worksheet ss:Name=" + Chr(34) + "Plan1" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "		<Table x:FullColumns=" + Chr(34) + "1" + Chr(34) + " x:FullRows=" + Chr(34) + "1" + Chr(34) + ">" + Chr(13) + Chr(10)

FWrite(nHandle, cWorkBook)
cWorkBook := ""

/* Linha de Cabeçalho */
nQtdLine := Len( aCabec )
For i := 1 To nQtdLine
	cRow += "			<Row>" + Chr(13) + Chr(10)
	nLenLine := Len(aCabec[i])
	For j := 1 To nLenLine
		cRow += "				<Cell><Data ss:Type=" + Chr(34) + "String" + Chr(34) + ">" + AllTrim(aCabec[i][j]) + "</Data></Cell>" + Chr(13) + Chr(10)
	Next
	cRow += "			</Row>" + Chr(13) + Chr(10)
	FWrite(nHandle, cRow)
	cRow := ""
   IncProc()
Next


nQtdLine := Len(aItens)
For i := 1 To nQtdLine
	cRow := "			<Row>" + Chr(13) + Chr(10)
	nLenLine := Len(aItens[i])
	For j := 1 To nLenLine
		cRow += "				" + FS_GetCell(aItens[i][j]) + Chr(13) + Chr(10)
	Next
	cRow += "			</Row>" + Chr(13) + Chr(10)
	FWrite(nHandle, cRow)
	cRow := ""
   IncProc()
Next

cWorkBook += "		</Table>" + Chr(13) + Chr(10)
cWorkBook += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "			<PageSetup>" + Chr(13) + Chr(10)
cWorkBook += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "			</PageSetup>" + Chr(13) + Chr(10)
cWorkBook += "			<Selected/>" + Chr(13) + Chr(10)
cWorkBook += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
cWorkBook += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
cWorkBook += "		</WorksheetOptions>" + Chr(13) + Chr(10)
cWorkBook += "	</Worksheet>" + Chr(13) + Chr(10)
cWorkBook += "	<Worksheet ss:Name=" + Chr(34) + "Plan2" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "			<PageSetup>" + Chr(13) + Chr(10)
cWorkBook += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "			</PageSetup>" + Chr(13) + Chr(10)
cWorkBook += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
cWorkBook += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
cWorkBook += "		</WorksheetOptions>" + Chr(13) + Chr(10)
cWorkBook += "	</Worksheet>" + Chr(13) + Chr(10)
cWorkBook += "	<Worksheet ss:Name=" + Chr(34) + "Plan3" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
cWorkBook += "			<PageSetup>" + Chr(13) + Chr(10)
cWorkBook += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
cWorkBook += "			</PageSetup>" + Chr(13) + Chr(10)
cWorkBook += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
cWorkBook += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
cWorkBook += "		</WorksheetOptions>" + Chr(13) + Chr(10)
cWorkBook += "	</Worksheet>" + Chr(13) + Chr(10)
cWorkBook += "</Workbook>" + Chr(13) + Chr(10)

FWrite(nHandle, cWorkBook)
cWorkBook := ""
FClose(nHandle)

CpyS2T("\system\"+cFileName, AllTrim(GetTempPath()))
FErase("\system\"+cFileName)

If !ApOleClient("MsExcel")
    MsgStop("O arquivo " + AllTrim(GetTempPath()) + "\" + cFileName + " será criado, mas não poderá ser aberto automaticamente nesse computador pois não foi encontrado o Microsoft Excel." , "Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
Else
    oExcelApp:= MsExcel():New()
    oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+cFileName)
    oExcelApp:SetVisible(.T.)
EndIf

Return Nil


Static Function FS_GetCell( xVar )
Local cRet  := ""
Local cType := ValType(xVar)

If cType == "U"
	cRet := "<Cell><Data ss:Type=" + Chr(34) + "General" + Chr(34) + "></Data></Cell>"
ElseIf cType == "C"
	cRet := "<Cell><Data ss:Type=" + Chr(34) + "String" + Chr(34) + ">" + AllTrim( xVar ) + "</Data></Cell>"
ElseIf cType == "N"
	cRet := "<Cell><Data ss:Type=" + Chr(34) + "Number" + Chr(34) + ">" + AllTrim( Str( xVar ) ) + "</Data></Cell>"
ElseIf cType == "D"
	xVar := DToS( xVar )
           //<Cell ss:StyleID=              "s21"              ><Data ss:Type=              "DateTime"              >    2006                  -    12                    -    27                    T00:00:00.000</Data></Cell>
	cRet := "<Cell ss:StyleID=" + Chr(34) + "s21" + Chr(34) + "><Data ss:Type=" + Chr(34) + "DateTime" + Chr(34) + ">" + SubStr(xVar, 1, 4) + "-" + SubStr(xVar, 5, 2) + "-" + SubStr(xVar, 7, 2) + "T00:00:00.000</Data></Cell>"
Else
	cRet := "<Cell><Data ss:Type=" + Chr(34) + "Boolean" + Chr(34) + ">" + Iif ( xVar , "=VERDADEIRO" ,  "=FALSO" ) + "</Data></Cell>"
EndIf

Return cRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraX1   ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica as perguntas incluindo-as caso nao existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Uso Generico.                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  0          1          2          3          4          5          6          7          8          9
0            X1_GRUPO   X1_ORDEM   X1_PERGUNT X1_PERSPA  X1_PERENG  X1_VARIAVL X1_TIPO    X1_TAMANHO X1_DECIMAL
1 X1_PRESEL  X1_GSC     X1_VALID   X1_VAR01   X1_DEF01   X1_DEFSPA1 X1_DEFENG1 X1_CNT01   X1_VAR02   X1_DEF02
2 X1_DEFSPA2 X1_DEFENG2 X1_CNT02   X1_VAR03   X1_DEF03   X1_DEFSPA3 X1_DEFENG3 X1_CNT03   X1_VAR04   X1_DEF04
3 X1_DEFSPA4 X1_DEFENG4 X1_CNT04   X1_VAR05   X1_DEF05   X1_DEFSPA5 X1_DEFENG5 X1_CNT05   X1_F3      X1_PYME
3 X1_GRPSXG  X1_HELP    X1_PICTURE X1_IDFIL
/*/

Static Function GeraX1(cPerg)
Local aArea    := GetArea()
Local aRegs    := {}
Local i        := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))
//             1      2     3                               4   5   6         7    8   9   10  11   12  13          14  15  16  17                 18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38     39  40  41                             42  43  
AAdd( aRegs, { cPerg, "01", "Armazem De ?",                 "", "", "mv_ch1", "C", 02, 00, 00, "G", "", "mv_par01", "", "", "", "00",              "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    "", "", "P."+cPerg+StrZero(i++,2)+".", "", "" } )
AAdd( aRegs, { cPerg, "02", "Armazem Até ?",                "", "", "mv_ch2", "C", 02, 00, 00, "G", "", "mv_par02", "", "", "", "99",              "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    "", "", "P."+cPerg+StrZero(i++,2)+".", "", "" } )
AAdd( aRegs, { cPerg, "03", "Produto De ?",                 "", "", "mv_ch3", "C", 15, 00, 00, "G", "", "mv_par03", "", "", "", "               ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "", "P."+cPerg+StrZero(i++,2)+".", "", "" } )
AAdd( aRegs, { cPerg, "04", "Produto Ate ?",                "", "", "mv_ch4", "C", 15, 00, 00, "G", "", "mv_par04", "", "", "", "ZZZZZZZZZZZZZZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "", "P."+cPerg+StrZero(i++,2)+".", "", "" } )
AAdd( aRegs, { cPerg, "05", "Grupo de ?",                   "", "", "mv_ch5", "C", 04, 00, 00, "G", "", "mv_par05", "", "", "", "    ",            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", "", "P."+cPerg+StrZero(i++,2)+".", "", "" } )
AAdd( aRegs, { cPerg, "06", "Grupo Até ?",                  "", "", "mv_ch6", "C", 04, 00, 00, "G", "", "mv_par06", "", "", "", "9999",            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", "", "P."+cPerg+StrZero(i++,2)+".", "", "" } )

DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aRegs)
    If !DbSeek( cPerg + aRegs[i][2] )
        RecLock( "SX1", .T. )
        For j := 1 to FCount()
            If j <= Len( aRegs[i] )
               FieldPut( j, aRegs[i][j] )
            Endif
        Next
        MsUnlock()

        aHelpPor := {}; aHelpSpa := {}; aHelpEng := {}

        If i==1
            AADD( aHelpPor, "Informe o armazem                       " )
            AADD( aHelpPor, "Inicial para Filtrar os dados do        " )
            AADD( aHelpPor, "Relatório.                              " )
        ElseIf i==2
            AADD( aHelpPor, "Informe o armazem                       " )
            AADD( aHelpPor, "Final para Filtrar os dados do          " )
            AADD( aHelpPor, "Relatório.                              " )
        ElseIf i==3
            AADD( aHelpPor, "Informe ou Selecione o Código do        " )
            AADD( aHelpPor, "Produto   Inicial para Filtrar os dados " )
            AADD( aHelpPor, "do Relatório.                           " )
        ElseIf i==4
            AADD( aHelpPor, "Informe ou Selecione o Código do        " )
            AADD( aHelpPor, "Produto   Final para Filtrar os dados do" )
            AADD( aHelpPor, "Relatório.                              " )
        ElseIf i==5
            AADD( aHelpPor, "Informe ou Selecione o Código do Grupo  " )
            AADD( aHelpPor, "de Produtos Inicial para Filtrar os     " )
            AADD( aHelpPor, "dados do Relatório.                     " )
        ElseIf i==6
            AADD( aHelpPor, "Informe ou Selecione o Código do Grupo  " )
            AADD( aHelpPor, "de Pordutos Final para Filtrar os dados " )
            AADD( aHelpPor, "do Relatório.                           " )
        EndIf
        PutSX1Help( "P." + cPerg + StrZero( i, 2 ) + ".", aHelpPor, aHelpEng, aHelpSpa )
    EndIf

Next

RestArea(aArea)
Return Nil
