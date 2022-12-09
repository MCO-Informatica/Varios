#Include 'Protheus.ch'
#Include 'Report.ch'

/*
------------------------------------------------------------------------------------------------------------
Função            : AAPCOM88
Tipo        : Funcao do usuario
Descrição   : Relatório de compra por Fornecedor com Total.
Uso               : COMPRAS
Parâmetros  :
Retorno     :
------------------------------------------------------------------------------------------------------------
Atualizações:
- 26/08/2014 - Willer - Construção inicial do fonte
------------------------------------------------------------------------------------------------------------
*/

//U_AAPCOM88()

User Function AAPCOM88()

      Local oReport               //CRIANDO VARIAVEL
      Local cPerg  := "AAPCOM88" //CRIANDO VARIAVEL

       //|Cria as Perguntas |
       FP001(cPerg)
     
       Pergunte(cPerg, .F. )
       oReport := ReportDef()
       oReport:SetLandscape()
       oReport:PrintDialog()

Static Function ReportDef()

      Local oReport     //CRIANDO VARIAVEL
      Local oSecCE     //CRIANDO VARIAVEL
      Local oBreak    //CRIANDO VARIAVEL
            
oReport := TReport():New("AAPCOM88" , "Relatório de Compras por Fornecedor x Produtos","AAPCOM88",{|oReport| PrintReport(oReport)})

oSecCE := TRSection():New(oReport)

oReport:oPage:nPaperSize               := 9   // MODIFICACAO DE LETRA E TAMANHO DE FONTE
oReport:nFontBody                      := 07
oReport:nLineHeight                        := 60
oReport:cFontBody                          := "Arial"
oReport:nFontBody                          := 10
      
        
        TRCell():New(oSecCE,"F1_FILIAL", "SF1", "Filial" ,, 13)  //CELULAR APRESENTADAS NO RELATÓRIO  (ORDEM DE CAMPO / ALIAS / E NOME DE EXIBIÇÃO)
        TRCell():New(oSecCE,"F1_FORNECE", "SF1", "Fornecedor" ,, 13)
        TRCell():New(oSecCE,"A2_NOME", "SA2", "Razão Social" ,, 26 )
        TRCell():New(oSecCE,"F1_EMISSAO" ,    "", 'Emissao'		,PesqPict("SF1","F1_EMISSAO"),,)
        TRCell():New(oSecCE,"F1_DOC" ,    "", 'Nota'				,PesqPict("SF1","F1_DOC") ,,)
        TRCell():New(oSecCE,"F1_SERIE" ,    "", 'Serie'			,PesqPict("SF1","F1_SERIE"),,)
        TRCell():New(oSecCE,"D1_COD" ,    "", 'Código'			,PesqPict("SD1","D1_COD"),,)
        TRCell():New(oSecCE,"B1_DESC" ,    "", 'Descrição'		,PesqPict("SB1","B1_DESC"),,)
        TRCell():New(oSecCE,"B1_UM" ,    "", 'Un'				,PesqPict("SB1","B1_UM"),,)
        TRCell():New(oSecCE,"D1_QUANT" ,    "", 'Qtde'			,PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")	    [1],/*lPixel*/,,,,"RIGHT")								// Quantidade Real
        TRCell():New(oSecCE,"D1_VUNIT" ,    "", 'Unitario'		,PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")	    [1],/*lPixel*/,,,,"RIGHT")								// Quantidade Real
        TRCell():New(oSecCE,"D1_TOTAL" ,    "", 'Total'			,PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")	    [1],/*lPixel*/,,,,"RIGHT")								// Quantidade Real


       	oSecCE:Cell("F1_DOC"):lHeaderSize := .F.
	   	oSecCE:Cell("F1_DOC"):nSize := 9	
       	oSecCE:Cell("F1_EMISSAO"):lHeaderSize := .F.
	   	oSecCE:Cell("F1_EMISSAO"):nSize := 10
       	oSecCE:Cell("D1_QUANT"):lHeaderSize := .F.
	   	oSecCE:Cell("D1_QUANT"):nSize := 12
       	oSecCE:Cell("D1_VUNIT"):lHeaderSize := .F.
	   	oSecCE:Cell("D1_VUNIT"):nSize := 12
       	oSecCE:Cell("D1_TOTAL"):lHeaderSize := .F.
	   	oSecCE:Cell("D1_TOTAL"):nSize := 12

       	oBreak1 := TRBreak():New(oSecCE,oSecCE:Cell("F1_DOC"),"TOTAL NF:",.F.,)

		TRFunction():New(oSecCE:Cell("D1_QUANT"),NIL,"SUM",oBreak1 , NIL,NIL  ,PesqPict("SD1","D1_QUANT"),.F.,.F.)
        TRFunction():New(oSecCE:Cell("D1_TOTAL"),NIL,"SUM",oBreak1 , NIL,NIL  ,PesqPict("SD1","D1_TOTAL"),.F.,.F.)

		oReport:setTotalInLine(.F.) //POSICIONA O TOTAL EMBAIXO DO CAMPO REFERENCIADONA SOMA

Return oReport


Static Function PrintReport (oReport)
     
      Local oSecCE        := oReport:Section(1)  // CRIANDO VARIAVEIS
      Local cDatIni       := ""
      Local cDatFin       := ""
      Local cForIni       := ""
      
       oSecCE:BeginQuery()                
     
       cDatIni             := DtoS (mv_par01) // PARAMETRO PARA INFORMAR A DATA "DtoS"
       cDatFin             := DtoS (mv_par02)
       cForIni             := mv_par03+MV_PAR04
      
       BeginSql Alias "QRYSF1"   // INICIO DA EXECUÇÃO DA QUERY NO BANCO
      
       SELECT F1_FILIAL,
       F1_FORNECE,
       A2_NOME,
       F1_EMISSAO,
       F1_DOC,
       F1_SERIE,
       D1_COD,
       B1_DESC,
       B1_UM,
       D1_QUANT,
       D1_VUNIT,
       D1_TOTAL
FROM   SF1010 SF1
       INNER JOIN SD1010 SD1
               ON SD1.D1_FILIAL = SF1.F1_FILIAL
                  AND SD1.D1_DOC = SF1.F1_DOC
                  AND SD1.D1_SERIE = SF1.F1_SERIE
                  AND SD1.%NotDel%
                  AND SD1.D1_FILIAL = %xFilial:SD1%
       INNER JOIN SA2010 SA2
               ON SA2.A2_COD = SF1.F1_FORNECE
                  AND SA2.A2_FILIAL = %xFilial:SA2%
                  AND SA2.A2_LOJA = SF1.F1_LOJA
                  AND SA2.%NotDel%
       INNER JOIN SB1010 SB1
               ON SB1.B1_COD = SD1.D1_COD
                  AND SB1.B1_FILIAL = %xFilial:SB1%
                  AND SB1.%NotDel%
WHERE  F1_FORNECE+F1_LOJA = %exp:cForIni%
                  AND SF1.F1_FILIAL = %xFilial:SF1%
                  AND SF1.%NotDel%       
                  AND SF1.F1_DUPL <> ''
                  AND F1_EMISSAO BETWEEN %exp:cDatIni% AND %exp:cDatFin%
ORDER BY F1_FILIAL,
          F1_FORNECE,
          A2_NOME,
          F1_EMISSAO,
          F1_DOC,
          D1_COD

EndSql

oSecCE:EndQuery() // FINAL DA EXECUÇÃO DA QUERY NO BANCO
oSecCE:SetParentQuery()
oSecCE:Print()

Static Function FP001(cPerg)  //PERGUNTAS RELATÓRIO

       PutSx1(cPerg,"01", "Periodo De           ","" , "","mv_ch01" ,"D" ,08,0,0,"G", "", "" ,,, "MV_PAR01" , "" , "" , "" ,, "" , "" , "" , "" , "" , "" ,"" ,"" ,"" ,"" ,"" ,"" ,{"Data Emissão inicial" },{},{}, "")
       PutSx1(cPerg,"02", "Periodo Ate          ","" , "","mv_ch02" ,"D" ,08,0,0,"G", "NaoVazio()", "" , "" , "" , "MV_PAR02" , "" , "" , "" , "" , "" , "" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,{"Data Emissão final" },{},{},"")
       PutSx1(cPerg,"03", "Fornecedor           ","" , "","mv_ch03" ,"C" ,06                   ,0,0,"G", "", "SA2" , "" , "" , "MV_PAR03" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,{"Codigo Fornecedor" },{},{},"")
       PutSx1(cPerg,"04", "Loja                 ","" , "","mv_ch04" ,"C" ,02                   ,0,0,"G", "", ""    , "" , "" , "MV_PAR04" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,{"Loja Fornecedor" },{},{},"")

Return
