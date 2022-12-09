#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPR100   º Autor ³ Renato Ruy         º Data ³  11/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera Arquivo em PDF dos lançamentos de Remuneração 		  º±±
±±º          ³ de Parceiros.                                              º±±
±±º          ³ Relatório de Resumo de Lançamentos                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA031G(xRecno)

Local lAdjustToLegacy := .F.
Local lDisableSetup   := .T.
Local lFound    	  := .F.
Local lJob			  := .F.
Local cRootPath		  := ""
Local cFile 		  := ""
Local cEmpP			  := "01"
Local cFilP			  := "02"

Private oFont10N
Private oFont10
Private nLin	      := 40
Private oPrinter

Default xRecno := 0

If select("SX6") == 0
	//Abre a conexão com a empresa
	RpcSetType(3)
	RpcSetEnv(cEmpP,cFilP)
	
	ZZ6->(DbGoTo(xRecno))
	cRootPath := "/system/"
	lJob := .T.
Else
	cRootPath := GetTempPath()
Endif

oFont10N := TFont():New("Arial"     ,08,08,,.T.,,,,,.F.)   // Negrito
oFont10  := TFont():New("Arial"     ,08,08,,.F.,,,,,.F.)   // Normal

lAdjustToLegacy := .F. 
lDisableSetup   := .T.

//Gero nome do arquivo
cFile := StrTran(AllTrim(NoAcento( ZZ6->ZZ6_PERIOD + " - " + ZZ6->ZZ6_CODENT + " - " + ZZ6->ZZ6_DESENT )),"/","-")

oPrinter := FWMSPrinter():New(cFile+".rel", IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrinter:SetResolution(72) //Resolução da página
oPrinter:SetViewPDF(.F.)   //Não exibe a página gerada
oPrinter:SetLandscape()    //Relatório no formato paisagem
oPrinter:SetPaperSize(2)	// A4
oPrinter:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior 
oPrinter:cPathPDF := cRootPath  // Caso seja utilizada impressão em IMP_PDF.

SZ3->(DbSetOrder(1))
lFound := SZ3->(DbSeek( xFilial("SZ3") + ZZ6->ZZ6_CODENT))

//Gera relatório sintético de postos.
If lJob
	ConOut("Processando o relatorio do parceiro: "+ ZZ6->ZZ6_CODENT)
	if lFound .And. AllTrim(SZ3->Z3_TIPENT) == "9"
		CRPA31G1(lJob)
	//Gera relatório aglutinado de AC.
	ElseIf lFound .And. AllTrim(SZ3->Z3_TIPENT) $ "2/5"
		CRPA31G2(lJob)
	//Gera relatório aglutinado de Canal ou Federação.
	ElseIf lFound .And. AllTrim(SZ3->Z3_TIPENT) $ "1/8"
		CRPA31G3(lJob)
	//Gera relatório aglutinado de Campanha ou Clube do revendedor.
	Else
		CRPA31G4(lJob)
	Endif
Elseif lFound .And. AllTrim(SZ3->Z3_TIPENT) == "9"
	Processa( {|| CRPA31G1(lJob) }, "Gerando Relatorio do CCR em PDF...")
//Gera relatório aglutinado de AC.
ElseIf lFound .And. AllTrim(SZ3->Z3_TIPENT) $ "2/5"
	Processa( {|| CRPA31G2(lJob) }, "Gerando Relatorio da AC em PDF...")
//Gera relatório aglutinado de Canal ou Federação.
ElseIf lFound .And. AllTrim(SZ3->Z3_TIPENT) $ "1/8"
	Processa( {|| CRPA31G3(lJob) }, "Gerando Relatorio Canal/Federação em PDF...")
//Gera relatório aglutinado de Campanha ou Clube do revendedor.
Else
	Processa( {|| CRPA31G4(lJob) }, "Gerando Relatorio do Parceiro em PDF...")
Endif

oPrinter:Preview() // Gera arquivo

//Caso o sistema não consiga gerar no temp, utilizo o caminho informado pelo usuário.
cRootPath := oPrinter:cPathPDF

FreeObj(oPrinter) // Limpa o objeto
oPrinter := Nil

//Gravo o arquivo pdf na base de conhecimento.
If lJob
	CRPA031F( cFile,cRootPath,lJob)
Else
	Processa( {|| CRPA031F( cFile,cRootPath) }, "Criando a Base de Conhecimento...")
Endif

Return

/*           
----------------------------------------------------------------------------
| Rotina    | SvArqSdk     | Autor | Gustavo Prudente | Data | 20.05.2015  |
|--------------------------------------------------------------------------| 
| Rotina    | CRPA031F     |Adequada| Renato Ruy   	  | Data | 11.02.2016  |
|--------------------------------------------------------------------------|
| Descricao | Grava os arquivos anexos no banco de conhecimento            |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function CRPA031F( cFile,cRootPath, lJob)

Local aArea		:= GetArea()
Local cDirDoc	:= MsDocPath()

If !lJob
	IncProc( "Gerando o arquivo e adicionando a Base de Conhecimento.")
	ProcessMessage()
Endif

//Aguarda o sistema gerar arquivo na máquina local.
Sleep( 5000 )

DbSelectArea("ACB")
DbSetOrder(2) 

__CopyFile( cRootPath + cFile + ".pdf", cDirDoc + "\" + cFile + ".pdf" )

// Inclui registro no banco de conhecimento e verifico se ja existe para não duplicar.
ACB->(DbSetOrder(2))
If !ACB->(DbSeek(xFilial("ACB") + cFile + ".pdf" ))
	DbSelectArea("ACB")
	RecLock("ACB",.T.)
	ACB_FILIAL := xFilial("ACB")
	ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
	ACB_OBJETO	:= cFile + ".pdf"
	ACB_DESCRI	:= cFile
	MsUnLock()         
	
	ConfirmSx8()
	                   
	// Inclui amarração entre registro do banco e entidade
	DbSelectArea("AC9")
	RecLock("AC9",.T.)
	AC9_FILIAL	:= xFilial("AC9")
	AC9_FILENT	:= xFilial("ZZ6")
	AC9_ENTIDA	:= "ZZ6"
	AC9_CODENT	:= ZZ6->ZZ6_PERIOD + ZZ6->ZZ6_CODENT
	AC9_CODOBJ	:= ACB->ACB_CODOBJ
	MsUnLock()         
EndIf

RestArea( aArea )

Return .T.

// Renato Ruy - 12/02/2016
// Relatório Sintético de Postos

Static Function CRPA31G1(lJob)

Local cQuery := ""
Local Cabec1 := ""
Local cImpLin:= ""
Local nQuant := 0
Local nValHar:= 0
Local nValSof:= 0
Local nValFat:= 0
Local nTotal := 0

If !lJob
	IncProc( "Selecionando dados do CCR: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

cQuery := " SELECT  Z6_PRODUTO, "
cQuery += " Z6_DESCRPR, "
cQuery += " Z6_CODCCR, "
cQuery += " SUM(QUANT) Quant, "
cQuery += " Z6_CODAC, "
cQuery += " SUM(BASE_HARDWARE) BASE_HARDWARE, "
cQuery += " SUM(BASE_SOFTWARE) BASE_SOFTWARE, "
cQuery += " SUM(BASE_COMISSAO) BASE_COMISSAO, "
cQuery += " SUM(VALOR_COMISSAO) VALOR_COMISSAO "
cQuery += " From (SELECT "
cQuery += " Z6_PRODUTO, "
cQuery += " SUM(CASE WHEN Z6_VALCOM  > 0 THEN 1 WHEN Z6_VALCOM < 0 THEN -1 ELSE 0 END) QUANT , "
cQuery += " Z6_DESCRPR, "
cQuery += " Z6_CODCCR, "
cQuery += " Z6_PEDGAR, "
cQuery += " Z6_PEDSITE, "
cQuery += " Z6_CODAC, "
cQuery += " SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE, "
cQuery += " SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE, "
cQuery += " SUM(Z6_BASECOM) BASE_COMISSAO, "
cQuery += " SUM(Z6_VALCOM) VALOR_COMISSAO "
cQuery += " FROM " + RetSQLName("SZ6") + " SZ6 "
cQuery += " JOIN SZ3010 SZ3 ON SZ3.Z3_FILIAL = ' ' AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SZF010 SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0 "
cQuery += " LEFT JOIN SZ5010 SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' 'AND SZ5.Z5_PRODGAR > '0' "
cQuery += " LEFT JOIN SZH010 SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SZ3010 SZ32 ON SZ32.Z3_FILIAL = ' ' AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_CODGAR > '0' AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' ' "
cQuery += " WHERE "
cQuery += " SZ6.D_E_L_E_T_ = ' '  "
cQuery += " AND Z6_FILIAL = ' '  "
cQuery += " AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' "
cQuery += " AND Z6_CODCCR = '" +ZZ6->ZZ6_CODENT+"' "
cQuery += " AND z6_tpentid = '4' "
cQuery += " GROUP BY "
cQuery += " Z6_PRODUTO, "
cQuery += " Z6_DESCRPR, "
cQuery += " Z6_CODCCR, "
cQuery += " Z6_PEDGAR, "
cQuery += " Z6_PEDSITE, "
cQuery += " Z6_CODAC) "
cQuery += " GROUP BY  "
cQuery += " Z6_PRODUTO, "
cQuery += " Z6_DESCRPR, "
cQuery += " Z6_CODCCR, "
cQuery += " Z6_CODAC "
cQuery += " ORDER BY Z6_CODCCR,Z6_PRODUTO "

If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf

PLSQuery( cQuery, "SZ6TMP" )

If SZ6TMP->(Eof())
	
	//Renato Ruy - 24/02/17
	//Verifica se o parceiro tem campanha, ja que o mesmo nao efetuou validacoes no mes.
	cQuery := " SELECT  ' ' Z6_PRODUTO, "
	cQuery += " 'Sem Validacoes do parceiro' Z6_DESCRPR, "
	cQuery += " Z3_CODENT Z6_CODCCR, "
	cQuery += " 0 Quant, "
	cQuery += " Z3_CODAC Z6_CODAC, "
	cQuery += " 0 BASE_HARDWARE, "
	cQuery += " 0 BASE_SOFTWARE, "
	cQuery += " 0 BASE_COMISSAO, "
	cQuery += " 0 VALOR_COMISSAO "
	cQuery += " From " + RetSqlName("SZ3")
	cQuery += " Where "
	cQuery += " Z3_FILIAL = ' ' AND "
	cQuery += " Z3_CODENT = '" + ZZ6->ZZ6_CODENT + "' AND "
	cQuery += " Z3_CODPAR > ' ' AND "
	cQuery += " D_E_L_E_T_ = ' '"
	
	If Select("SZ6TMP") > 0
		SZ6TMP->( DbCloseArea() )
	EndIf
	
	PLSQuery( cQuery, "SZ6TMP" )
	
	If SZ6TMP->(Eof())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.')
		SZ6TMP->( DbCloseArea() )
		Return(.F.)
	Endif
	
EndIf

SZ6TMP->(dbGoTop())

oPrinter:StartPage()
nLin := 40

oPrinter:Say( nLin += 10 , 001 ,  "CCR: " + ZZ6->ZZ6_DESENT, oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  "Cód. Produto"	   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 106 ,  "Descrição Produto"		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 416 ,  "Quantidade"				, oFont10N   , 100 )
oPrinter:Say( nLin		 , 476 ,  "Valor Hardware"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 556 ,  "Valor Software"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 626 ,  "Valor Faturado"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 696 ,  "Valor Comissão"   		, oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )

If !lJob
	IncProc( "Imprimindo o relatório do CCR: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

While !EOF("SZ6TMP")
	
	If nLin > 550 // Salto de Página. Neste caso o formulario tem 55 linhas...
		oPrinter:EndPage()   //Finaliza página atual
		oPrinter:StartPage() //Cria uma nova página
		nLin := 40
		//Imprime o cabeçalho da página
		oPrinter:Say( nLin += 10 , 001 ,  "Cód. Produto"	   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 106 ,  "Descrição Produto"		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 416 ,  "Quantidade"				, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 476 ,  "Valor Hardware"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 556 ,  "Valor Software"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 626 ,  "Valor Faturado"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 696 ,  "Valor Comissão"   		, oFont10N   , 100 )
		oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
	Endif
	
	//Grava registros
	oPrinter:Say( nLin += 10 , 001 ,  SZ6TMP->Z6_PRODUTO	    						   		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 106 ,  SZ6TMP->Z6_DESCRPR	    						   		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 416 ,  Transform(SZ6TMP->QUANT 			,"@E 999,999,999") 		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 476 ,  Transform(SZ6TMP->BASE_HARDWARE 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 556 ,  Transform(SZ6TMP->BASE_SOFTWARE 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 626 ,  Transform(SZ6TMP->BASE_COMISSAO 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 696 ,  Transform(SZ6TMP->VALOR_COMISSAO 	,"@E 999,999,999.99")   , oFont10   , 100 )
	
	//Guarda valores para totalizador
	cImpLin 	:= ""
	nQuant  	+= SZ6TMP->QUANT
	nValHar  	+= SZ6TMP->BASE_HARDWARE
	nValSof  	+= SZ6TMP->BASE_SOFTWARE
	nValFat  	+= SZ6TMP->BASE_COMISSAO
	nTotal		+= SZ6TMP->VALOR_COMISSAO
	
	DbSelectArea("SZ6TMP")
	SZ6TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

//Fecha Arquivo usado
If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf

//Imprime Totais
oPrinter:Say( nLin		 , 001 ,  Replicate("_",220)									, oFont10   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  "SUBTOTAL"											, oFont10   , 100 )
oPrinter:Say( nLin 		 , 416 ,  Transform(nQuant 			,"@E 999,999,999")			, oFont10   , 100 )
oPrinter:Say( nLin		 , 476 ,  Transform(nValHar 			,"@E 999,999,999.99")   , oFont10   , 100 )
oPrinter:Say( nLin		 , 556 ,  Transform(nValSof 			,"@E 999,999,999.99")   , oFont10   , 100 )
oPrinter:Say( nLin		 , 626 ,  Transform(nValFat			,"@E 999,999,999.99")   	, oFont10   , 100 )
oPrinter:Say( nLin		 , 696 ,  Transform(nTotal 			,"@E 999,999,999.99")	  	, oFont10   , 100 )



oPrinter:Say( nLin += 30 , 640 ,  "Total: " 						   	, oFont10N   , 100 )
oPrinter:Say( nLin 		 , 696 ,  Transform(nTotal,"@E 999,999,999.99")	, oFont10	 , 100 )


If !Empty(SZ3->Z3_CODPAR)
    If !lJob
		IncProc( "Selecionando informação da campanha para o CCR: " + ZZ6->ZZ6_CODENT + ".")
		ProcessMessage()
	Endif
	
	cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND Z6_CODENT IN "+FormatIn(AllTrim(SZ3->Z3_CODPAR),",")+" AND z6_tpentid = '7' "

	If Select("TMP2") > 0
		TMP2->(DbCloseArea())
	EndIf
	PLSQuery( cQuery2, "TMP2" )
	
	oPrinter:Say( nLin += 10 , 640 ,  "Campanha: "				   				, oFont10N  , 100 )
	oPrinter:Say( nLin		 , 696 ,  Transform(TMP2->Z6_VALCOM,"@E 999,999,999.99")	, oFont10   , 100 )
	
	nTotal += TMP2->Z6_VALCOM
EndIf

If !lJob
	IncProc( "Selecionando informação da Visita Externa para o CCR: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND Z6_CODENT = '"+AllTrim(ZZ6->ZZ6_CODENT)+"' AND z6_tpentid = 'B' "

If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf
PLSQuery( cQuery2, "TMP2" )

oPrinter:Say( nLin += 10 , 640 ,  "Visita Externa: "				   				, oFont10N  , 100 )
oPrinter:Say( nLin		 , 696 ,  Transform(TMP2->Z6_VALCOM,"@E 999,999,999.99")	, oFont10   , 100 )

nTotal += TMP2->Z6_VALCOM


If AllTrim(ZZ6->ZZ6_CODAC) == "CACB" .OR. AllTrim(SUBSTR(ZZ6->ZZ6_CODAC,1,4)) == "FECO"
	If !lJob
		IncProc( "Selecionando informação da Federação para o CCR: " + ZZ6->ZZ6_CODENT + ".")
		ProcessMessage()
	Endif
	
	If 	ZZ6->ZZ6_CODENT  == "054404"
	    
	    cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND Z6_CODCCR IN ('054404','054581') AND z6_tpentid = '8' "
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP3" )
	    	
    Elseif ZZ6->ZZ6_CODENT  == "054807"
    
    	cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054807' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND z6_tpentid = '8' "
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP3" )
		
    Elseif ZZ6->ZZ6_CODENT  == "054595"
    
    	cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054595' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND z6_tpentid = '8' "
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP3" )
	
	Elseif ZZ6->ZZ6_CODENT  == "054331"
    
    	cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054331' AND D_E_L_E_T_ = ' ') AND z6_tpentid = '8' "
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP3" )
    	
    Else
    	cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 JOIN " + RetSQLName("SZ3") + " SZ32 ON SZ32.Z3_FILIAL = SZ6.Z6_FILIAL AND SZ32.Z3_CODENT = SZ6.Z6_CODENT AND SZ32.Z3_RETPOS != 'N' AND SZ32.D_E_L_E_T_ = ' ' WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND Z6_CODCCR   = '"+ZZ6->ZZ6_CODENT+"' AND z6_tpentid = '8' "
    	If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP3" )
    Endif 
		
	oPrinter:Say( nLin += 10 , 640 ,  "Federação: "				   						, oFont10N  , 100 )
	oPrinter:Say( nLin		 , 696 ,  Iif(ZZ6->ZZ6_CODENT $ "054581/054730/054461/054578/075379",'0', Transform(TMP3->Z6_VALCOM,"@E 999,999,999.99")) 	, oFont10   , 100 )
	
	nTotal += TMP3->Z6_VALCOM
EndIf

//Renato Ruy - 12/09/2017
//Gera total geral da AR
If ZZ6->ZZ6_VALAR > 0
	nTotal += ZZ6->ZZ6_VALAR
	oPrinter:Say( nLin += 10 , 640 ,  "Total AR: "	 				   				, oFont10N  , 100 )
	oPrinter:Say( nLin		 , 696 ,  Transform(ZZ6->ZZ6_VALAR,"@E 999,999,999.99")	, oFont10   , 100 )
Endif

oPrinter:Say( nLin += 10 , 640 ,  "Total Geral: " 				   				, oFont10N  , 100 )
oPrinter:Say( nLin		 , 696 ,  Transform(nTotal,"@E 999,999,999.99") 	 	, oFont10   , 100 )

Return

// Renato Ruy - 12/02/2016
// Relatório Sintético de AC

Static Function CRPA31G2(lJob)

Local cQuery := ""
Local Cabec1 := ""
Local cImpLin:= ""
Local nQuant := 0
Local nValHar:= 0
Local nValSof:= 0
Local nValFat:= 0
Local nTotal := 0
Local cCodPar:= ""

If !lJob
	IncProc( "Selecionando dados da AC: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

cQuery := " SELECT   Z6_PRODUTO,  "
cQuery += "          Z6_DESCRPR,  "
cQuery += "          Z6_CODCCR,  "
cQuery += "          Count(*) Quant,  "
cQuery += "          Z6_CODAC,  "
cQuery += "          SUM(BASE_HARDWARE) BASE_HARDWARE,  "
cQuery += "          SUM(BASE_SOFTWARE) BASE_SOFTWARE,  "
cQuery += "          SUM(BASE_COMISSAO) BASE_COMISSAO,  "
cQuery += "          SUM(VALOR_COMISSAO) VALOR_COMISSAO  "
cQuery += "          From (SELECT  Z6_PRODUTO,  "
cQuery += "                        Z6_DESCRPR,  "
cQuery += "                        Z6_CODENT Z6_CODCCR,  "
cQuery += "                        Z6_PEDGAR,  "
cQuery += "                        Z6_PEDSITE,  "
cQuery += "                        Z6_CODAC,  "
cQuery += "                        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,  "
cQuery += "                        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,  "
cQuery += "                        SUM(Z6_BASECOM) BASE_COMISSAO,  "
cQuery += "                        SUM(Z6_VALCOM) VALOR_COMISSAO  "
cQuery += "                        FROM " + RetSQLName("SZ6") + " SZ6 "
cQuery += "                        WHERE  SZ6.D_E_L_E_T_ = ' '   AND "
cQuery += "                        Z6_FILIAL = ' '   AND "
cQuery += "                        Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND "
cQuery += "                        Z6_CODAC = '" +ZZ6->ZZ6_CODENT+ "' AND "
cQuery += "                        z6_tpentid IN ('2','5')  "
cQuery += "                        GROUP BY  Z6_PRODUTO,  Z6_DESCRPR,  Z6_CODENT,  Z6_PEDGAR,  Z6_PEDSITE,  Z6_CODAC)  "
cQuery += " GROUP BY   Z6_PRODUTO,  Z6_DESCRPR,  Z6_CODCCR,  Z6_CODAC  "
cQuery += " ORDER BY Z6_CODCCR,COUNT(*),Z6_PRODUTO "

If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf 

PLSQuery( cQuery, "SZ6TMP" )

If SZ6TMP->(Eof())
	MsgInfo('Não foi possível encontrar registros com os parâmetros informados.')
	SZ6TMP->( DbCloseArea() )
	Return(.F.)
EndIf

SZ6TMP->(dbGoTop())

oPrinter:StartPage()
nLin := 40

oPrinter:Say( nLin += 10 , 001 ,  "AC: " + ZZ6->ZZ6_DESENT , oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  "Quantidade"				, oFont10N   , 100 )
oPrinter:Say( nLin 		 , 066 ,  "Cód. Produto"	   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 166 ,  "Descrição Produto"		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 476 ,  "Valor Hardware"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 556 ,  "Valor Software"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 626 ,  "Valor Faturado"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 696 ,  "Valor Comissão"   		, oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )

If !lJob
	IncProc( "Imprimindo o relatório da AC: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

While !EOF("SZ6TMP")
	
	If nLin > 550 // Salto de Página. Neste caso o formulario tem 55 linhas...
		oPrinter:EndPage()   //Finaliza página atual
		oPrinter:StartPage() //Cria uma nova página
		nLin := 40
		//Imprime o cabeçalho da página
		oPrinter:Say( nLin += 10 , 001 ,  "Quantidade"				, oFont10N   , 100 )
		oPrinter:Say( nLin 		 , 066 ,  "Cód. Produto"	   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 166 ,  "Descrição Produto"		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 476 ,  "Valor Hardware"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 556 ,  "Valor Software"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 626 ,  "Valor Faturado"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 696 ,  "Valor Comissão"   		, oFont10N   , 100 )
		oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
	Endif
	
	//Grava registros
	oPrinter:Say( nLin += 10 , 001 ,  Transform(SZ6TMP->QUANT 			,"@E 999,999,999") 		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 066 ,  SZ6TMP->Z6_PRODUTO	    						   		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 166 ,  SZ6TMP->Z6_DESCRPR	    						   		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 476 ,  Transform(SZ6TMP->BASE_HARDWARE 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 556 ,  Transform(SZ6TMP->BASE_SOFTWARE 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 626 ,  Transform(SZ6TMP->BASE_COMISSAO 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 696 ,  Transform(SZ6TMP->VALOR_COMISSAO 	,"@E 999,999,999.99")   , oFont10   , 100 )
	
	//Guarda valores para totalizador
	cImpLin 	:= ""
	nQuant  	+= SZ6TMP->QUANT
	nValHar  	+= SZ6TMP->BASE_HARDWARE
	nValSof  	+= SZ6TMP->BASE_SOFTWARE
	nValFat  	+= SZ6TMP->BASE_COMISSAO
	nTotal		+= SZ6TMP->VALOR_COMISSAO
	
	DbSelectArea("SZ6TMP")
	SZ6TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

//Fecha Arquivo usado
If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf

//Imprime Totais
oPrinter:Say( nLin 		 , 001 ,  Replicate("_",220)									, oFont10   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Transform(nQuant 			,"@E 999,999,999")			, oFont10   , 100 )
oPrinter:Say( nLin 		 , 066 ,  "==================== SUBTOTAL ===================="	, oFont10   , 100 )
oPrinter:Say( nLin		 , 476 ,  Transform(nValHar 			,"@E 999,999,999.99")   , oFont10   , 100 )
oPrinter:Say( nLin		 , 556 ,  Transform(nValSof 			,"@E 999,999,999.99")   , oFont10   , 100 )
oPrinter:Say( nLin		 , 626 ,  Transform(nValFat			,"@E 999,999,999.99")   	, oFont10   , 100 )
oPrinter:Say( nLin		 , 696 ,  Transform(nTotal 			,"@E 999,999,999.99")	  	, oFont10   , 100 )


oPrinter:Say( nLin += 30 , 640 ,  "Total: " 						   	, oFont10N   , 100 )
oPrinter:Say( nLin 		 , 696 ,  Transform(nTotal,"@E 999,999,999.99")	, oFont10	 , 100 )

If AllTrim(ZZ6->ZZ6_CODENT) $ "SIN/NOT/BR/SINRJ"

	//AJUSTA CODIGO DE PARCEIROS PARA BUSCAR NA SZ6
	If Select("QCRPR132") > 0
		QCRPR132->(DbCloseArea())
	EndIf
	
	BeginSql Alias "QCRPR132"
	SELECT  Z3_CODPAR
		FROM SZ3010 SZ3 
		WHERE
		Z3_FILIAL = ' ' AND
		Z3_TIPENT = '9' AND
		Z3_CODAC = %Exp:AllTrim(ZZ6->ZZ6_CODENT)% AND
		Z3_ATIVO = 'N' AND
		SZ3.D_E_L_E_T_ = ' '
		GROUP BY Z3_CODPAR
	EndSql 
	
	While !QCRPR132->(EOF())
		
		If !Empty(QCRPR132->Z3_CODPAR)
			cCodPar := Iif(!Empty(cCodPar),cCodPar+","+AllTrim(QCRPR132->Z3_CODPAR),AllTrim(QCRPR132->Z3_CODPAR)) 
		EndIf
		
		QCRPR132->(DbSkip())
	EndDo
	
	//Formata Para query
	cCodPar := "% " + FormatIn(cCodPar,",") + " %"

    //Busca valor das AR's descredenciadas.
	If Select("QCRPR31G") > 0
		QCRPR31G->(DbCloseArea())
	EndIf
	
	BeginSql Alias "QCRPR31G"
 	
 	SELECT  SUM(Z6_VALCOM) VALDESC,
 			MAX((SELECT SUM(Z6_VALCOM) FROM SZ6010 WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:ZZ6->ZZ6_PERIOD% AND D_E_L_E_T_ = ' ' AND Z6_TPENTID = '7' AND Z6_CODENT IN %Exp:cCodPar% )) CAMPANHA
    		FROM SZ3010 SZ3 
			JOIN SZ6010 SZ6
			ON Z6_FILIAL = ' '
			AND Z6_PERIODO = %Exp:ZZ6->ZZ6_PERIOD%
			AND Z6_TPENTID = '4'
			AND Z6_CODAC = %Exp:AllTrim(ZZ6->ZZ6_CODENT)%
			AND Z3_CODENT = Z6_CODCCR
			AND SZ6.D_E_L_E_T_ = ' '
			WHERE
			Z3_FILIAL = ' ' AND
			Z3_TIPENT = '9' AND
			Z3_ATIVO = 'N' AND
			SZ3.D_E_L_E_T_ = ' '
	EndSql

	oPrinter:Say( nLin += 10 , 640 ,  "Descredenciadas: "				   				, oFont10N   , 100 )
	oPrinter:Say( nLin 		 , 696 ,  Transform(QCRPR31G->VALDESC,"@E 999,999,999.99")	, oFont10	 , 100 )	
	
	oPrinter:Say( nLin += 10 , 640 ,  "Campanha: "				   				, oFont10N   , 100 )
	oPrinter:Say( nLin 		 , 696 ,  Transform(QCRPR31G->CAMPANHA,"@E 999,999,999.99")	, oFont10	 , 100 )
	
	nTotal += QCRPR31G->VALDESC + QCRPR31G->CAMPANHA

Elseif AllTrim(ZZ6->ZZ6_CODENT) $ "FEN"

	//Renato Ruy - 20/03/2018
	//Buscar visita externa para remunerar na AC
	BeginSql Alias "TMPVIS"
		SELECT 	SUM(Z6_VALCOM) VALVIS
		FROM %Table:SZ6% SZ6
		WHERE Z6_FILIAL = ' '
		AND Z6_PERIODO = %Exp:ZZ6->ZZ6_PERIOD%
		AND Z6_TPENTID = 'B'
		AND Z6_CODCCR = '054615'
		AND SZ6.%NOTDEL%	
	EndSql
	If TMPVIS->VALVIS > 0
		nTotal += TMPVIS->VALVIS
		oPrinter:Say( nLin += 10 , 640 ,  "Visita Ext.: " 				   					, oFont10N  , 100 )
		oPrinter:Say( nLin		 , 696 ,  Transform(TMPVIS->VALVIS,"@E 999,999,999.99") , oFont10   , 100 )
	Endif
	TMPVIS->(DbCloseArea())
	
EndIf

oPrinter:Say( nLin += 10 , 640 ,  "Total Geral: " 				   				, oFont10N  , 100 )
oPrinter:Say( nLin		 , 696 ,  Transform(nTotal,"@E 999,999,999.99") 	 	, oFont10   , 100 )

Return

// Renato Ruy - 15/02/2016
// Relatório Sintético de Canal ou Federação.

Static Function CRPA31G3(lJob)

Local cQuery := ""
Local Cabec1 := ""
Local cImpLin:= ""
Local nQuant := 0
Local nValHar:= 0
Local nValSof:= 0
Local nValFat:= 0
Local nTotal := 0

If !lJob
	IncProc( "Selecionando dados do Canal/Federação: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

cQuery := " SELECT Z6_DESENT, "
cQuery += " Z6_PRODUTO, "
cQuery += " SUM(Z6_VLRPROD) Z6_VALFAT, "
cQuery += " SUM(Z6_BASECOM) Z6_VALLIQ, "
cQuery += " SUM(Z6_VALCOM) Z6_VALCOM, "
cQuery += " SUM(Z6_VLRABT) Z6_VLRABT, "
cQuery += " COUNT(*) QUANTIDADE "
cQuery += " FROM SZ6010 SZ6 "
cQuery += " JOIN SZ3010 SZ3 ON SZ3.Z3_FILIAL = ' ' AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' ' "
  	cQuery += " LEFT JOIN SZF010 SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0 "
cQuery += " LEFT JOIN SZ5010 SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' 'AND SZ5.Z5_PRODGAR > '0' "
cQuery += " LEFT JOIN SZH010 SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SZ3010 SZ32 ON SZ32.Z3_FILIAL = ' ' AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_CODGAR > '0' AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' ' "
cQuery += " WHERE "
cQuery += " Z6_FILIAL = ' ' AND "
cQuery += " Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND "
cQuery += " Z6_CODENT = '" +ZZ6->ZZ6_CODENT+"' AND "
cQuery += " Z6_TPENTID = '"+Iif(AllTrim(SZ3->Z3_TIPENT)=="1","1","8")+"' AND "
cQuery += " SZ6.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY Z6_DESENT,Z6_PRODUTO  "
cQuery += " ORDER BY Z6_DESENT "

If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf

PLSQuery( cQuery, "SZ6TMP" )

If SZ6TMP->(Eof())
	MsgInfo('Não foi possível encontrar registros com os parâmetros informados.')
	SZ6TMP->( DbCloseArea() )
	Return(.F.)
EndIf

SZ6TMP->(dbGoTop())

oPrinter:StartPage()
nLin := 40

oPrinter:Say( nLin += 10 , 001 ,  "Canal/Federação: " + ZZ6->ZZ6_DESENT , oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  "Quantidade"				, oFont10N   , 100 )
oPrinter:Say( nLin 		 , 066 ,  "Cód. Produto"	   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 176 ,  "Total Faturado"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 256 ,  "Descontos"		   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 326 ,  "Total Liquido"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 396 ,  "Total Comissão"   		, oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )

If !lJob
	IncProc( "Imprimindo o relatório do Canal/Federação: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

While !EOF("SZ6TMP")
	
	If nLin > 550 // Salto de Página. Neste caso o formulario tem 55 linhas...
		oPrinter:EndPage()   //Finaliza página atual
		oPrinter:StartPage() //Cria uma nova página
		nLin := 40
		//Imprime o cabeçalho da página
		oPrinter:Say( nLin += 10 , 001 ,  "Quantidade"				, oFont10N   , 100 )
		oPrinter:Say( nLin 		 , 066 ,  "Cód. Produto"	   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 176 ,  "Total Faturado"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 256 ,  "Descontos"		   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 326 ,  "Total Liquido"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 396 ,  "Total Comissão"   		, oFont10N   , 100 )
		oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
	Endif
	
	//Grava registros
	oPrinter:Say( nLin += 10 , 001 ,  Transform(SZ6TMP->QUANTIDADE		,"@E 999,999,999") 		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 066 ,  SZ6TMP->Z6_PRODUTO	    						   		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 176 ,  Transform(SZ6TMP->Z6_VALFAT	 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 256 ,  Transform(SZ6TMP->Z6_VLRABT	 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 326 ,  Transform(SZ6TMP->Z6_VALLIQ	 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 396 ,  Transform(SZ6TMP->Z6_VALCOM	 	,"@E 999,999,999.99")   , oFont10   , 100 )
	
	//Guarda valores para totalizador
	cImpLin 	:= ""
	nQuant  	+= SZ6TMP->QUANTIDADE
	nValHar  	+= SZ6TMP->Z6_VALFAT
	nValSof  	+= SZ6TMP->Z6_VLRABT
	nValFat  	+= SZ6TMP->Z6_VALLIQ
	nTotal		+= SZ6TMP->Z6_VALCOM
	
	DbSelectArea("SZ6TMP")
	SZ6TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

//Fecha Arquivo usado
If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf

//Imprime Totais
oPrinter:Say( nLin 		 , 001 ,  Replicate("_",220)									, oFont10   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Transform(nQuant 			,"@E 999,999,999")			, oFont10   , 100 )
oPrinter:Say( nLin 		 , 066 ,  "SUBTOTAL"											, oFont10   , 100 )
oPrinter:Say( nLin		 , 176 ,  Transform(nValHar 			,"@E 999,999,999.99")   , oFont10   , 100 )
oPrinter:Say( nLin		 , 256 ,  Transform(nValSof 			,"@E 999,999,999.99")   , oFont10   , 100 )
oPrinter:Say( nLin		 , 326 ,  Transform(nValFat			,"@E 999,999,999.99")   	, oFont10   , 100 )
oPrinter:Say( nLin		 , 396 ,  Transform(nTotal 			,"@E 999,999,999.99")	  	, oFont10   , 100 )



oPrinter:Say( nLin += 30 , 340 ,  "Total: " 						   	, oFont10N   , 100 )
oPrinter:Say( nLin 		 , 396 ,  Transform(nTotal,"@E 999,999,999.99")	, oFont10	 , 100 )

oPrinter:Say( nLin += 10 , 340 ,  "Total Geral: " 				   				, oFont10N  , 100 )
oPrinter:Say( nLin		 , 396 ,  Transform(nTotal,"@E 999,999,999.99") 	 	, oFont10   , 100 )

Return

// Renato Ruy - 15/02/2016
// Relatório Sintético de Campanha do Contador ou Clube do Revendedor.

Static Function CRPA31G4(lJob)

Local cQuery := ""
Local Cabec1 := ""
Local cImpLin:= ""
Local nQuant := 0
Local nValHar:= 0
Local nValSof:= 0
Local nValFat:= 0
Local nTotal := 0

If !lJob
	IncProc( "Selecionando dados do Parceiro: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

cQuery := " SELECT Z6_DESREDE, 
cQuery += " max(CASE WHEN TRIM(Z6_CODENT) IN ('46','156','2274') THEN 'CONTROLE DE VENDAS BORTOLIN' "
cQuery += " WHEN TRIM(Z6_CODAC) = 'ICP' THEN 'REDE ICP-SEGUROS - MARKETPLACE' "
cQuery += " ELSE Z6_DESENT END) Z6_DESENT, "
cQuery += "  Z6_PRODUTO, SUM(Z6_VLRPROD) Z6_VALFAT, SUM(Z6_VALCOM) Z6_VALCOM, COUNT(*) QUANTIDADE FROM SZ6010 "
cQuery += " WHERE "
cQuery += " Z6_FILIAL = ' ' AND "
cQuery += " Z6_PERIODO = '"+ZZ6->ZZ6_PERIOD+"' AND "
If AllTrim(ZZ6->ZZ6_CODENT) == "46"
	cQuery += " Z6_CODENT IN ('46','156','2274') AND "
ElseIf AllTrim(ZZ6->ZZ6_CODENT) == "1158"
	cQuery += " Z6_CODAC = 'ICP' AND "
Else
	cQuery += " Z6_CODENT = '" +ZZ6->ZZ6_CODENT+"' AND "
EndIf
cQuery += " Z6_TPENTID IN ('7','10')  AND "
cQuery += " D_E_L_E_T_ = ' ' " 
If AllTrim(ZZ6->ZZ6_CODENT) == "46" .OR. AllTrim(ZZ6->ZZ6_CODENT) == "1158" 
cQuery += " GROUP BY  Z6_DESREDE, Z6_PRODUTO "
cQuery += " Order by  Z6_DESREDE, Z6_PRODUTO "
Else
cQuery += " GROUP BY  Z6_DESREDE, Z6_DESENT, Z6_PRODUTO "
cQuery += " Order by  Z6_DESREDE, Z6_DESENT, Z6_PRODUTO "
EndIf

If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf

PLSQuery( cQuery, "SZ6TMP" )

If SZ6TMP->(Eof())
	MsgInfo('Não foi possível encontrar registros com os parâmetros informados.')
	SZ6TMP->( DbCloseArea() )
	Return(.F.)
EndIf

SZ6TMP->(dbGoTop())

oPrinter:StartPage()
nLin := 40

Cabec1 += PADR("TOTAL FAT. "	 ,19 ," ")  + "|"
Cabec1 += PADR("TOTAL COM. "	 ,19 ," ")  + "|"

oPrinter:Say( nLin += 10 , 001 ,  "Parceiro: " + ZZ6->ZZ6_DESENT , oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  "Quantidade"				, oFont10N   , 100 )
oPrinter:Say( nLin 		 , 066 ,  "Cód. Produto"	   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 176 ,  "Total Faturado"   		, oFont10N   , 100 )
oPrinter:Say( nLin		 , 256 ,  "Total Comissão"   		, oFont10N   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )

If !lJob
	IncProc( "Imprimindo o relatório do Parceiro: " + ZZ6->ZZ6_CODENT + ".")
	ProcessMessage()
Endif

While !EOF("SZ6TMP")
	
	If nLin > 550 // Salto de Página. Neste caso o formulario tem 55 linhas...
		oPrinter:EndPage()   //Finaliza página atual
		oPrinter:StartPage() //Cria uma nova página
		nLin := 40
		//Imprime o cabeçalho da página
		oPrinter:Say( nLin += 10 , 001 ,  "Quantidade"				, oFont10N   , 100 )
		oPrinter:Say( nLin 		 , 066 ,  "Cód. Produto"	   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 176 ,  "Total Faturado"   		, oFont10N   , 100 )
		oPrinter:Say( nLin		 , 256 ,  "Total Comissão"   		, oFont10N   , 100 )
		oPrinter:Say( nLin += 10 , 001 ,  Replicate("_",220)	    , oFont10N   , 100 )
	Endif
	
	//Grava registros
	oPrinter:Say( nLin += 10 , 001 ,  Transform(SZ6TMP->QUANTIDADE		,"@E 999,999,999") 		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 066 ,  SZ6TMP->Z6_PRODUTO	    						   		, oFont10   , 100 )
	oPrinter:Say( nLin		 , 176 ,  Transform(SZ6TMP->Z6_VALFAT	 	,"@E 999,999,999.99")   , oFont10   , 100 )
	oPrinter:Say( nLin		 , 256 ,  Transform(SZ6TMP->Z6_VALCOM	 	,"@E 999,999,999.99")   , oFont10   , 100 )
	
	//Guarda valores para totalizador
	cImpLin 	:= ""
	nQuant  	+= SZ6TMP->QUANTIDADE
	nValHar  	+= SZ6TMP->Z6_VALFAT
	nTotal		+= SZ6TMP->Z6_VALCOM
	
	DbSelectArea("SZ6TMP")
	SZ6TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

//Fecha Arquivo usado
If Select("SZ6TMP") > 0
	SZ6TMP->( DbCloseArea() )
EndIf

//Imprime Totais
oPrinter:Say( nLin 		 , 001 ,  Replicate("_",220)									, oFont10   , 100 )
oPrinter:Say( nLin += 10 , 001 ,  Transform(nQuant 			,"@E 999,999,999")			, oFont10   , 100 )
oPrinter:Say( nLin 		 , 066 ,  "SUBTOTAL"											, oFont10   , 100 )
oPrinter:Say( nLin		 , 176 ,  Transform(nValHar 			,"@E 999,999,999.99")   , oFont10   , 100 )
oPrinter:Say( nLin		 , 256 ,  Transform(nTotal 			,"@E 999,999,999.99")	  	, oFont10   , 100 )



oPrinter:Say( nLin += 30 , 200 ,  "Total: " 						   	, oFont10N   , 100 )
oPrinter:Say( nLin 		 , 256 ,  Transform(nTotal,"@E 999,999,999.99")	, oFont10	 , 100 )

oPrinter:Say( nLin += 10 , 200 ,  "Total Geral: " 				   				, oFont10N  , 100 )
oPrinter:Say( nLin		 , 256 ,  Transform(nTotal,"@E 999,999,999.99") 	 	, oFont10   , 100 )

Return

