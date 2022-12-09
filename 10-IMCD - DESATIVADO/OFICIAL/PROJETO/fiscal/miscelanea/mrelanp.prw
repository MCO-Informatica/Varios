#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCFGXFUN  ºAutor  ³Microsiga           º Data ³  07/14/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MRELANP()

Local nOpcA       := 0
Local aSays       := {}
Local aButtons    := {}
Local cCadastro   := "Relatório Auxiliar ANP"
Local cPerg       := "MRELANP"
Local aPergs := {}

aAdd( aPergs, { "Data Inicial            ?","                         ","                         ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aPergs, { "Data Final              ?","                         ","                         ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aPergs, { "Orgão de Relatorio      ?","                         ","                         ","mv_ch3","C",01,0,0,"C","","mv_par03","ANP","ANP","ANP","","","Policia Civil","Policia Civil","Policia Civil","","","Policia Federal","Policia Federal","Policia Federal","","",""})


Pergunte( cPerg, .F.)

aAdd( aSays, "Essa rotina gera relatório auxiliar ANP em Excel" )
aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
	Processa( { || MRELANPProc( mv_par01, mv_par02 ) }, "Gerando Relatório..." )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCFGXFUN  ºAutor  ³Microsiga           º Data ³  07/14/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MRELANPProc( dDataIni, dDataFim )

Local aAreaAtu := GetArea()

Local cQuery	:= ""
Local nCount	:= 0

Local cArqExcel := "C:\TEMP\MAPAS\"+CriaTrab(Nil,.F.)+".CSV"
Local cLinha	:= '"Tipo";"NCM";"NF";"Dt. Emissão";"Dt. Digitação";"Codigo Produto";"Produto";"Quantidade 1";"Unidade Medida 1";'
cLinha	+= '"Quantidade 2";"Unidade Medida 2";"CNPJ";"Fornecedor/Cliente";"Cidade";"UF";"Chave NFE";"Tipo de Frete";"Valor Unitário"'

MAKEDIR("C:\TEMP\MAPAS\")

cQuery := "SELECT	'E' 		TIPO, "
cQuery += "        	B1_POSIPI 	NCM, "
cQuery += "			D1_DOC 		NF, "
cQuery += "			D1_EMISSAO 	DATAE, "
cQuery += "			D1_DTDIGIT 	DATAD,"
cQuery += "			D1_COD 		COD, "
cQuery += "			B1_DESC 	PRODUTO, "
cQuery += "			D1_QUANT 	QTD,"
cQuery += "			D1_UM 		UM,"
cQuery += "			D1_QTSEGUM 	QTDS,"
cQuery += "			D1_SEGUM 	UMS,"
cQuery += "			A2_CGC 		CNPJ,"
cQuery += "			A2_NOME 	NOME,"
cQuery += "			A2_MUN 		CIDADE,"
cQuery += "			A2_EST 		UF,"
cQuery += "         F1_CHVNFE   CHVNFE,"
cQuery += "         F1_TPFRETE  TPFRETE,"
cQuery += "         D1_VUNIT VLRUNIT "
cQuery += "  FROM " + RetSQLName( "SD1" ) + " SD1 "
cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA2" ) + " SA2 ON A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SF1" ) + " SF1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND SF1.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D1_FILIAL   = '" + xFilial( "SD1" ) + "' "
cQuery += "   AND D1_DTDIGIT >= '" + DtoS( dDataIni ) + "' "
cQuery += "   AND D1_DTDIGIT <= '" + DtoS( dDataFim ) + "' "
if mv_par03 == 1
	cQuery += "   AND B1_ANP      = 'S' "
elseif mv_par03 == 2
	cQuery += "   AND B1_POLCIV   = 'S' "
else
	cQuery += "   AND B1_POLFED   = 'S' "
endif
cQuery += "   AND D1_TES NOT IN ('026','080','163') "
cQuery += "   AND SD1.D_E_L_E_T_ = ' ' "
cQuery += " UNION "
cQuery += "SELECT	'S' 		TIPO, "
cQuery += "       	B1_POSIPI 	NCM,"
cQuery += "			D2_DOC 		NF, "
cQuery += "			D2_EMISSAO 	DATAE, "
cQuery += "			D2_EMISSAO 	DATAD,"
cQuery += "			D2_COD 		COD, "
cQuery += "			B1_DESC 	PRODUTO, "
cQuery += "			D2_QUANT 	QTD,"
cQuery += "			D2_UM 		UM,"
cQuery += "			D2_QTSEGUM 	QTDS,"
cQuery += "			D2_SEGUM 	UMS,"
cQuery += "			A1_CGC 		CNPJ,"
cQuery += "			A1_NOME 	NOME,"
cQuery += "			A1_MUN 		CIDADE,"
cQuery += "			A1_EST 		UF,"
cQuery += "         F2_CHVNFE   CHVNFE,"
cQuery += "         F2_TPFRETE  TPFRETE,"
cQuery += "         D2_PRCVEN VLRUNIT "
cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA2 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SF2" ) + " SF2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SF2.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D2_FILIAL   = '" + xFilial( "SD2" ) + "' "
cQuery += "   AND D2_EMISSAO >= '" + DtoS( dDataIni ) + "' "
cQuery += "   AND D2_EMISSAO <= '" + DtoS( dDataFim ) + "' "
if mv_par03 == 1
	cQuery += "   AND B1_ANP      = 'S' "
elseif mv_par03 == 2
	cQuery += "   AND B1_POLCIV   = 'S' "
else
	cQuery += "   AND B1_POLFED   = 'S' "
endif
cQuery += "   AND D2_TES NOT IN ('518') "
cQuery += "   AND D2_DOC||D2_SERIE  NOT IN "
cQuery += "   ( SELECT C.D1_NFORI||C.D1_SERIORI FROM " + RetSQLName("SD1")+" C "
cQuery += "   WHERE C.D1_FILIAL = '" + xFilial( "SD1" ) + "' AND C.D1_NFORI = SD2.D2_DOC "
cQuery += "   AND C.D1_SERIORI = SD2.D2_SERIE AND C.D1_FORNECE|| D1_LOJA = D2_CLIENTE || D2_LOJA ) "
cQuery += "   AND SD2.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY NCM, TIPO "
//MEMOWRITE('D:\SQL.TXT',cQuery)
If Select( "TMP_ANP" ) > 0
	TMP_ANP->( dbCloseArea() )
Endif
dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ANP", .T., .F. )
TMP_ANP->( dbGoTop() )
TMP_ANP->( dbEval( { || nCount++ } ) )
TMP_ANP->( dbGoTop() )

If Empty( nCount )
	TMP_ANP->( dbCloseArea() )
	MsgStop( "Não existem registros para o relatório. Verifique!" )
	RestArea( aAreaAtu )
	Return
Endif

ProcRegua( nCount )

u_AcaLogx( cArqExcel, "MAPA ANP - " + DtoC( dDataIni ) + " - " + DtoC( dDataFim ) )
u_AcaLogx( cArqExcel, cLinha )

While TMP_ANP->( !Eof() )
	
	IncProc( "Gerando Relatório" )
	
	cLinha := 	'=("' + TMP_ANP->TIPO + '");' +;
	'=("' + TMP_ANP->NCM + '");' +;
	'=("' + TMP_ANP->NF + '");' +;
	'=("' + DtoC( StoD( TMP_ANP->DATAE ) )+ '");' +;
	'=("' + DtoC( StoD( TMP_ANP->DATAD ) )+ '");' +;
	'=("' + TMP_ANP->COD + '");' +;
	'=("' + TMP_ANP->PRODUTO + '");' +;
	'=("' + TransForm( TMP_ANP->QTD, "@E 99999999.99" ) + '");' +;
	'=("' + TMP_ANP->UM + '");' +;
	'=("' + TransForm( TMP_ANP->QTDS, "@E 99999999.99" ) + '");' +;
	'=("' + TMP_ANP->UMS + '");' +;
	'=("' + TMP_ANP->CNPJ + '");' +;
	'=("' + TMP_ANP->NOME + '");' +;
	'=("' + TMP_ANP->CIDADE + '");' +;
	'=("' + TMP_ANP->UF + '");' +;
	'=("' + TMP_ANP->CHVNFE + '");' +;
	'=("' + TMP_ANP->TPFRETE + '");' +;
	'=("' + TransForm( TMP_ANP->VLRUNIT, "@E 999.9999" ) + '")'
	
	u_AcaLogx( cArqExcel, cLinha )
	
	TMP_ANP->( dbSkip() )
End

TMP_ANP->( dbCloseArea() )

IF !( ApOleClient("MsExcel") )
	Alert("Excel não localizado. O Arquivo foi criado em: "+cArqExcel)
ELSE
	oExcelApp:= MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqExcel)
	oExcelApp:SetVisible(.T.)
	oExcelApp := oExcelApp:Destroy()
ENDIF

Return