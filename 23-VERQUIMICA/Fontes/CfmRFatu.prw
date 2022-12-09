#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmRFatu  | Autor: Celso Ferrone Martins  | Data: 14/07/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Relatorio de Faturamento                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Danilo Busso							| Data: 14/07/2015 |||
||+-----------+------------------------------------------------------------+||
||| Descrição | Retirado o filtro por vendedor e adaptado para filtrar pela|||
|||			  |	zona do vendedor logado, os que estao no parâm. VQ_RELVEN  |||
|||			  |	não possuem restrição.									   |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmRFatu()

Local oReport
Local cTitulo1 := "Relatorio de Faturamento"
Local cTitulo2 := "Relatorio de Faturamento."
Private cEof   := Chr(13) + Chr(10)
Private cCodVenPg := U_CFMPGVEN()      
Private nTotCli	:= 0

oReport := TReport():New("CFMRFATU", cTitulo1, "CFMRFATU", {|oReport| PrintReport(oReport)}, cTitulo2)
oReport:SetLandScape() //Retrato
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

PutSX1("CFMRFATU","01","Resumo Por ?   ","","","MV_CHA","N",01,0,0,"C","",""   ,"","","MV_PAR01","Produto","","","","Cliente","","","","Vendedor","","","","Regiao","","","","Divisao","","")
PutSX1("CFMRFATU","02","Emissao de ?   ","","","MV_CHB","D",08,0,0,"G","",""   ,"","","MV_PAR02",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","03","Emissao ate ?  ","","","MV_CHC","D",08,0,0,"G","",""   ,"","","MV_PAR03",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","04","Produto de ?   ","","","MV_CHD","C",04,0,0,"G","","SBM","","","MV_PAR04",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","05","Produto ate ?  ","","","MV_CHE","C",04,0,0,"G","","SBM","","","MV_PAR05",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","06","Cliente de ?   ","","","MV_CHF","C",06,0,0,"G","","SA1","","","MV_PAR06",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","07","Cliente ate ?  ","","","MV_CHG","C",06,0,0,"G","","SA1","","","MV_PAR07",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","08","Vendedor de ?  ","","","MV_CHH","C",06,0,0,"G","","SA3","","","MV_PAR08",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","09","Vendedor ate ? ","","","MV_CHI","C",06,0,0,"G","","SA3","","","MV_PAR09",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","10","Regiao de ?    ","","","MV_CHJ","C",03,0,0,"G","","Z06","","","MV_PAR10",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","11","Regiao ate ?   ","","","MV_CHK","C",03,0,0,"G","","Z06","","","MV_PAR11",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","12","Divisao de ?   ","","","MV_CHL","C",06,0,0,"G","","ACY","","","MV_PAR12",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")
PutSX1("CFMRFATU","13","Divisao Ate ?  ","","","MV_CHM","C",06,0,0,"G","","ACY","","","MV_PAR13",""       ,"","","",""       ,"","","",""        ,"","","",""      ,"","","",""       ,"","")

Pergunte(oReport:uParam,.F.)

If !Empty(cCodVenPg)
	MV_PAR08 := cCodVenPg
	MV_PAR09 := cCodVenPg
EndIf

oReport:PrintDialog()

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+-----------------------+------------------------------+------------------+||
||| Programa: PrintReport | Autor: Celso Ferrone Martins | Data: 14/07/2015 |||
||+-----------+-----------+------------------------------+------------------+||
||| Descricao | Relatorio de Faturamento                                    |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function PrintReport(oReport)

Local oSection1// := oReport:Section(1)
Local oSection2// := oReport:Section(2)   
Local cFilReGrp := DBFILSA1()    

Local cQuery := ""               

Private aVendCli := {}

oSection1 := TRSection():New(oReport,"GERAL",{"TMP"})
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"CABNOME"     ,,"Relatorio" , "@!"    , 100,;
/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

If MV_PAR01 == 1 // PRODUTO
	cTitle2 := "Produto"
ElseIf MV_PAR01 == 2 // CLIENTE
	cTitle2 := "Cliente"
ElseIf MV_PAR01 == 3 // VENDEDOR
	cTitle2 := "Vendedor"
ElseIf MV_PAR01 == 4 // REGIAO
	cTitle2 := "Regiao"
ElseIf MV_PAR01 == 5 // DIVISAO
	cTitle2 := "Divisao"
EndIf

oSection2 := TRSection():New(oReport,cTitle2,{"TMP"})
oSection2:SetTotalInLine(.F.)           

TRCell():New(oSection2,"EMISSAO" , , "Emissao"    , PesqPict("SF2","F2_EMISSAO") , TamSX3("F2_EMISSAO")[1]+10,,,)
If MV_PAR01 != 2 // CLIENTE
	//TRCell():New(oSection2,"CLINOM"  , , "Cliente"    , PesqPict("SA1","A1_NOME"   ) , TamSX3("A1_NOME"   )[1],,,)
	TRCell():New(oSection2,"CLINOM"  , , "Cliente"    , PesqPict("SA1","A1_NREDUZ" ) , TamSX3("A1_NREDUZ" )[1],,,)
	oSection3 := TRSection():New(oReport,"CLINOM",{"TMP"})  
	oSection3:SetTotalInLine(.F.)                           
	TRCell():New(oSection3,"CLINOM"  , , "Cliente"    , PesqPict("SA1","A1_NREDUZ" ) , TamSX3("A1_NREDUZ" )[1],,,)
	TRCell():New(oSection3,"QTDCLI"  , , "Qtde.Cliente"    ,, ,,,,,)
EndIf
TRCell():New(oSection2,"PRONOM"  , , "Prod./Emb." , PesqPict("SB1","B1_DESC"   ) , TamSX3("B1_DESC"   )[1],,,)
//TRCell():New(oSection2,"QTDE"    , , "Quantidade" , PesqPict("SD2","D2_VQ_QTDE") , TamSX3("D2_VQ_QTDE")[1],,,"RIGHT",,"RIGHT")

TRCell():New(oSection2,"QTDEKG"  , , "Qtde.Kg"    , PesqPict("SD2","D2_QUANT"  ) , TamSX3("D2_QUANT"  )[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"QTDELT"  , , "Qtde.Lt"    , PesqPict("SD2","D2_QTSEGUM") , TamSX3("D2_QTSEGUM")[1],,,"RIGHT",,"RIGHT")

TRCell():New(oSection2,"UM"      , , "Un."        , PesqPict("SD2","D2_VQ_UM"  ) , TamSX3("D2_VQ_UM"  )[1],,,)
TRCell():New(oSection2,"TABELA"  , , "Tabela"     , PesqPict("SD2","D2_VQ_TABE") , TamSX3("D2_VQ_TABE")[1],,,)
TRCell():New(oSection2,"VALREAL" , , "Valor R$"   , PesqPict("SD2","D2_VQ_TOTA") , TamSX3("D2_VQ_TOTA")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VALDOLA" , , "Valor US$"  , PesqPict("SD2","D2_VQ_TOTA") , TamSX3("D2_VQ_TOTA")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"NOTA"    , , "Num. NF."   , PesqPict("SF2","F2_DOC"    ) , TamSX3("F2_DOC"    )[1],,,)
//TRCell():New(oSection2,"SERIE"   , , "Serie"      , PesqPict("SF2","F2_SERIE"  ) , TamSX3("F2_SERIE"  )[1],,,)
TRCell():New(oSection2,"CONDES"  , , "Condicao"   , PesqPict("SE4","E4_DESCRI" ) , TamSX3("E4_DESCRI" )[1],,,)
If MV_PAR01 != 3 // VENDEDOR
	TRCell():New(oSection2,"VENNOM"  , , "Vendedor"   , PesqPict("SA3","A3_NOME"   ) , 20/*TamSX3("A3_NOME"   )[1]*/,,,)
EndIf
If MV_PAR01 != 4 // REGIAO
	TRCell():New(oSection2,"REGIAO"  , , "Regiao"   , PesqPict("Z06","Z06_DESCRI"   ) , 20/*TamSX3("Z06_DESCRI")[1]+2*/,,,)
EndIf
If MV_PAR01 != 5 // DIVISAO
	TRCell():New(oSection2,"DIVISAO" , , "Divisao"  , PesqPict("ACY","ACY_DESCRI"   ) , 20/*TamSX3("ACY_DESCRI")[1]+2*/,,,)
EndIf

TRFunction():New(oSection2:Cell("QTDEKG")  ,"","SUM"    ,,"Sub-Total",PesqPict("SD2","D2_QUANT"  )  ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("QTDELT")  ,"","SUM"    ,,"Sub-Total",PesqPict("SD2","D2_QTSEGUM")  ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("VALREAL") ,"","SUM"    ,,"Sub-Total",PesqPict("SD2","D2_VQ_TOTA")  ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("VALDOLA") ,"","SUM"    ,,"Sub-Total",PesqPict("SD2","D2_VQ_TOTA")  ,,.T.,.T.,.F.,oSection2) 


//TRFunction():New(oSection2:Cell("PRONOM")  ,"","ONPRINT",,           ,"@!"                          ,,.T.,.T.,.F.,oSection2)
//TRFunction():New(oSection2:Cell("QTDE"  )  ,"","ONPRINT",,           ,PesqPict("SD2","D2_VQ_QTDE")  ,,.T.,.T.,.F.,oSection2)
//TRFunction():New(oSection2:Cell("UM"    )  ,"","ONPRINT",,           ,"@!"                          ,,.T.,.T.,.F.,oSection2)


cQuery := " SELECT * FROM (                                                          " + cEof 

cQuery += " SELECT                                                                   " + cEof 
cQuery += "    F2_VEND1                 AS VENCOD   ,                                " + cEof 
cQuery += "    A3_NOME                  AS VENNOM   ,                                " + cEof 
cQuery += "    F2_EMISSAO               AS EMISSAO  ,                                " + cEof 
cQuery += "    F2_CLIENTE               AS CLICOD   ,                                " + cEof 
cQuery += "    F2_LOJA                  AS CLILOJ   ,                                " + cEof 
cQuery += "    A1_NOME                  AS CLINOM   ,                                " + cEof 
cQuery += "    A1_NREDUZ                AS CLIRED   ,                                " + cEof 
cQuery += "    A1_REGIAO                AS REGIAO   ,                                " + cEof 
cQuery += "    A1_GRPVEN                AS DIVCOD   ,                                " + cEof 
cQuery += "    COALESCE(ACY_DESCRI,' ') AS DIVNOM   ,                                " + cEof
cQuery += "    D2_COD                   AS PROCOD   ,                                " + cEof 
cQuery += "    B1_DESC                  AS PRONOM   ,                                " + cEof 

cQuery += "    BM_GRUPO                 AS GRUCOD   ,                                " + cEof 
cQuery += "    BM_DESC                  AS GRUNOM   ,                                " + cEof 

cQuery += "    CASE B1_TIPO                                                          " + cEof 
cQuery += "       WHEN 'MP' THEN B1_COD                                              " + cEof 
cQuery += "       WHEN 'PA' THEN B1_VQ_MP                                            " + cEof 
cQuery += "       ELSE B1_COD                                                        " + cEof 
cQuery += "    END                      AS PRODMP   ,                                " + cEof 

cQuery += "    B1_VQ_EM                 AS PRODEM   ,                                " + cEof 

cQuery += "    D2_VQ_QTDE               AS QTDE     ,                                " + cEof 
cQuery += "    D2_VQ_UM                 AS UM       ,                                " + cEof 
cQuery += "    D2_VQ_TABE               AS TABELA   ,                                " + cEof 

//cQuery += "    D2_VQ_UNIT               AS VLRUNIT  ,                                " + cEof 
//cQuery += "    D2_VQ_TOTA               AS VLRTOTAL ,                                " + cEof 

cQuery += "    D2_PRCVEN                AS VLRUNIT  ,                                " + cEof 
cQuery += "    D2_TOTAL                 AS VLRTOTAL ,                                " + cEof 

cQuery += "    D2_DESCZFR               AS DESCZFR  ,                                " + cEof 

cQuery += "    D2_QUANT                 AS QTDEKG   ,                                " + cEof 
cQuery += "    D2_QTSEGUM               AS QTDELT ,                                " + cEof 

cQuery += "    COALESCE(M2_MOEDA2,1)    AS TXDOLAR  ,                                " + cEof 
cQuery += "    F2_COND                  AS CONCOD   ,                                " + cEof 
cQuery += "    E4_DESCRI                AS CONDES   ,                                " + cEof 
cQuery += "    F2_DOC                   AS NOTA     ,                                " + cEof 
cQuery += "    F2_SERIE                 AS SERIE    ,                                " + cEof 
cQuery += "    D2_QUANT                 AS QTDKG    ,                                " + cEof 
cQuery += "    D2_QTSEGUM               AS QTDLT                                     " + cEof 
cQuery += " FROM "+RetSqlName("SF2")+" SF2                                           " + cEof 
cQuery += "    INNER JOIN "+RetSqlName("SD2")+" SD2 ON                               " + cEof 
cQuery += "       SD2.D_E_L_E_T_ <> '*'                                              " + cEof 
cQuery += "       AND D2_FILIAL = '"+xFilial("SD2")+"'                               " + cEof
cQuery += "       AND D2_DOC   = F2_DOC                                              " + cEof 
cQuery += "       AND D2_SERIE = F2_SERIE                                            " + cEof 
//cQuery += "       AND D2_COD   BETWEEN '"+     MV_PAR04 +"' AND '"+     MV_PAR05 +"' " + cEof
cQuery += "    INNER JOIN " + RetSqlName("SF4") + " SF4 ON                           " + cEof 
cQuery += "       SF4.D_E_L_E_T_ <> '*'                                              " + cEof 
cQuery += "       AND F4_FILIAL  = '"+xFilial("SF4")+"'                              " + cEof 
cQuery += "       AND F4_CODIGO  = D2_TES                                            " + cEof 
cQuery += "       AND F4_DUPLIC = 'S'                                                " + cEof 
cQuery += "    INNER JOIN "+RetSqlName("SA3")+" SA3 ON                               " + cEof 
cQuery += "       SA3.D_E_L_E_T_ <> '*'                                              " + cEof 
cQuery += "       AND A3_FILIAL = '"+xFilial("SA3")+"'                               " + cEof
cQuery += "       AND A3_COD = F2_VEND1                                              " + cEof 
cQuery += "    INNER JOIN "+RetSqlName("SE4")+" SE4 ON                               " + cEof 
cQuery += "       SE4.D_E_L_E_T_ <> '*'                                              " + cEof 
cQuery += "       AND E4_FILIAL = '"+xFilial("SE4")+"'                               " + cEof
cQuery += "       AND E4_CODIGO = F2_COND                                            " + cEof 
cQuery += "    INNER JOIN "+RetSqlName("SB1")+" SB1 ON                               " + cEof 
cQuery += "       SB1.D_E_L_E_T_ <> '*'                                              " + cEof 
cQuery += "       AND B1_FILIAL = '"+xFilial("SB1")+"'                               " + cEof
cQuery += "       AND B1_COD = D2_COD                                                " + cEof 
cQuery += "       AND B1_GRUPO BETWEEN '"+     MV_PAR04 +"' AND '"+     MV_PAR05 +"' " + cEof   

cQuery += "    INNER JOIN " + RetSqlName("SBM")+" SBM ON                             " + cEof
cQuery += "       SBM.D_E_L_E_T_ <> '*'                                              " + cEof
cQuery += "       AND BM_FILIAL   = '"+xFilial("SBM")+"'                             " + cEof
cQuery += "       AND BM_GRUPO    = B1_GRUPO                                         " + cEof

cQuery += "    INNER JOIN "+RetSqlName("SA1")+" SA1 ON                               " + cEof 
cQuery += "       SA1.D_E_L_E_T_ <> '*'                                              " + cEof 
cQuery += "       AND A1_FILIAL = '"+xFilial("SA1")+"'                               " + cEof
cQuery += "       AND A1_COD = F2_CLIENTE                                            " + cEof 
cQuery += "       AND A1_LOJA = F2_LOJA                                              " + cEof 

If(Empty(cFilReGrp))
	cQuery += "       AND A1_REGIAO BETWEEN '"+    MV_PAR10 +"' AND '"+     MV_PAR11 +"' " + cEof 
	cQuery += "       AND A1_GRPVEN BETWEEN '"+    MV_PAR12 +"' AND '"+     MV_PAR13 +"' " + cEof 
Else
	cQuery += "       AND A1_REGIAO||A1_GRPVEN IN " + cFilReGrp + cEof 
EndIf


cQuery += "    LEFT  JOIN " + RetSqlName("ACY") + " ACY ON                           " + cEof
cQuery += "       ACY.D_E_L_E_T_ <> '*'                                              " + cEof
cQuery += "       AND ACY_FILIAL = '" + xFilial("ACY") + "'                          " + cEof
cQuery += "       AND ACY_GRPVEN = A1_GRPVEN                                         " + cEof
cQuery += "    LEFT  JOIN "+RetSqlName("SM2")+" SM2 ON                               " + cEof 
cQuery += "       SM2.D_E_L_E_T_ <> '*'                                              " + cEof 
cQuery += "       AND M2_DATA = F2_EMISSAO                                           " + cEof 
cQuery += " WHERE                                                                    " + cEof 
cQuery += "    SF2.D_E_L_E_T_ <> '*'                                                 " + cEof 
cQuery += "    AND F2_FILIAL = '"+xFilial("SF2")+"'                                  " + cEof
cQuery += "    AND F2_TIPO IN ('N')                                                  " + cEof 
cQuery += "    AND F2_VEND1 <> ' '                                                   " + cEof 
cQuery += "    AND F2_EMISSAO BETWEEN '"+dTos(MV_PAR02)+"' AND '"+dTos(MV_PAR03)+"'  " + cEof 
cQuery += "    AND F2_CLIENTE BETWEEN '"+     MV_PAR06 +"' AND '"+     MV_PAR07 +"'  " + cEof 
cQuery += "    AND F2_VEND1   BETWEEN '"+     MV_PAR08 +"' AND '"+     MV_PAR09 +"'  " + cEof                 
cQuery += " )                                                                        " + cEof

If MV_PAR01 == 1 // PRODUTO
//	cQuery += " ORDER BY PRODMP, EMISSAO, PRODEM, NOTA                               " + cEof 
	cQuery += " ORDER BY GRUCOD, EMISSAO, PRODEM, NOTA                               " + cEof 
ElseIf MV_PAR01 == 2 // CLIENTE
	cQuery += " ORDER BY CLICOD, EMISSAO, NOTA                                       " + cEof 
ElseIf MV_PAR01 == 3 // VENDEDOR
	cQuery += " ORDER BY VENCOD, EMISSAO, NOTA                                       " + cEof 
ElseIf MV_PAR01 == 4 // REGIAO
	cQuery += " ORDER BY REGIAO, EMISSAO, NOTA                                       " + cEof 
ElseIf MV_PAR01 == 5 // DIVISAO
	cQuery += " ORDER BY DIVCOD, EMISSAO, NOTA                                       " + cEof 
EndIf

cQuery := ChangeQuery(cQuery)

If Select("SF2TMP") > 0
	SF2TMP->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "SF2TMP"
	
nTotalReg := Contar("SF2TMP", "!Eof()")
SF2TMP->(DbGoTop())

oReport:SetMeter(nTotalReg)

cQuebra1 := ""
cNotaAnt := ""
nQtdKg   := 0
nQtdLt   := 0

While !SF2TMP->(Eof())
	
	If MV_PAR01 == 1 // PRODUTO
		cCondAtu := SF2TMP->GRUCOD
	ElseIf MV_PAR01 == 2 // CLIENTE
		cCondAtu := SF2TMP->CLICOD
	ElseIf MV_PAR01 == 3 // VENDEDOR
		cCondAtu := SF2TMP->VENCOD
	ElseIf MV_PAR01 == 4 // REGIAO
		cCondAtu := SF2TMP->REGIAO
	ElseIf MV_PAR01 == 5 // DIVISAO
		cCondAtu := SF2TMP->DIVCOD
	EndIf

	If cQuebra1 != cCondAtu
		
		If !Empty(cQuebra1)       
		
			nTotCliV := Len(aVendCli) 
			aVendCli := {}
			
//			oSection2:Cell("PRONOM" ):SetValue(AllTrim(Str(nQtdLt,18,2))+" L")
//			oSection2:Cell("QTDE"   ):SetValue(nQtdKg)
//			oSection2:Cell("UM"     ):SetValue("KG")

			//oSection2:PrintLine()
			
			//oReport:IncMeter()

			oSection1:Finish()
			oSection2:Finish()

			oReport:FatLine()     
			If MV_PAR01 == 3 
				oSection3:Init()
				oSection3:SetHeaderSection(.F.)
				oSection3:Cell("CLINOM"):SetValue("TOTAL DE CLIENTES:")
				oSection3:Cell("QTDCLI"):SetValue(nTotCliV)
				oSection3:PrintLine()
				oSection3:Finish()			
			EndIf
		EndIf

		nQtdKg := 0
		nQtdLt := 0 
		
		If MV_PAR01 == 1 // PRODUTO
			cQuebra1 := SF2TMP->GRUCOD
		ElseIf MV_PAR01 == 2 // CLIENTE
			cQuebra1 := SF2TMP->CLICOD
		ElseIf MV_PAR01 == 3 // VENDEDOR
			cQuebra1 := SF2TMP->VENCOD
		ElseIf MV_PAR01 == 4 // REGIAO
			cQuebra1 := SF2TMP->REGIAO
		ElseIf MV_PAR01 == 5 // DIVISAO
			cQuebra1 := SF2TMP->DIVCOD
		EndIf
		
		oSection1:Init()
		oSection1:SetHeaderSection(.F.)
		
		oReport:FatLine()

		If MV_PAR01 == 1 // PRODUTO
//			oSection1:Cell("CABNOME"):SetValue("Produto: "+SF2TMP->PRODMP+": "+Posicione("SB1",1,xFilial("SB1")+SF2TMP->PRODMP,"B1_DESC"))
			oSection1:Cell("CABNOME"):SetValue("Produto: "+SF2TMP->GRUCOD+": "+SF2TMP->GRUNOM)
		ElseIf MV_PAR01 == 2 // CLIENTE
			oSection1:Cell("CABNOME"):SetValue("Cliente: "+SF2TMP->CLICOD+": "+SF2TMP->CLIRED)
		ElseIf MV_PAR01 == 3 // VENDEDOR
			oSection1:Cell("CABNOME"):SetValue("Vendedor: "+SF2TMP->VENCOD+": "+SF2TMP->VENNOM)
		ElseIf MV_PAR01 == 4 // REGIAO
			oSection1:Cell("CABNOME"):SetValue("Regiao: "+SF2TMP->REGIAO+": "+Posicione("Z06",1,xFilial("Z06")+SF2TMP->REGIAO,"Z06_DESCRI"))
		ElseIf MV_PAR01 == 5 // DIVISAO
			oSection1:Cell("CABNOME"):SetValue("Divisao: "+SF2TMP->DIVCOD+": "+SF2TMP->DIVNOM)
		EndIf

		oSection1:PrintLine()
		
		oSection2:Init()
		oSection2:SetHeaderSection(.T.)
	EndIf

	If MV_PAR01 == 1 .And. !Empty(SF2TMP->PRODEM)
		cSectProd := Posicione("SB1",1,xFilial("SB1")+SF2TMP->PRODEM,"B1_DESC") 
	Else
		cSectProd := SF2TMP->PRONOM
	EndIf
		
	oSection2:Cell("EMISSAO"):SetValue(sTod(SF2TMP->EMISSAO))
	If MV_PAR01 != 2 // CLIENTE
		oSection2:Cell("CLINOM" ):SetValue(SF2TMP->CLIRED) 
	     
	   nPos := aScan(aVendCli,{|x|x == SF2TMP->(VENCOD+CLIRED+CLICOD+CLILOJ)})
	   	If nPos == 0  
		   	aAdd(aVendCli,SF2TMP->(VENCOD+CLIRED+CLICOD+CLILOJ))
	   	EndIf
	EndIf            
	  
	oSection2:Cell("PRONOM" ):SetValue(cSectProd)
//	oSection2:Cell("QTDE"   ):SetValue(SF2TMP->QTDE)
	oSection2:Cell("UM"     ):SetValue(SF2TMP->UM)
	oSection2:Cell("TABELA" ):SetValue(SF2TMP->TABELA)
	oSection2:Cell("VALREAL"):SetValue(SF2TMP->(VLRTOTAL))
	oSection2:Cell("VALDOLA"):SetValue(SF2TMP->((VLRTOTAL)/TXDOLAR))
	oSection2:Cell("NOTA"   ):SetValue(SF2TMP->NOTA)
//	oSection2:Cell("SERIE"  ):SetValue(SF2TMP->SERIE)
	oSection2:Cell("CONDES" ):SetValue(SF2TMP->CONDES)

	oSection2:Cell("QTDEKG" ):SetValue(SF2TMP->QTDEKG)
	oSection2:Cell("QTDELT" ):SetValue(SF2TMP->QTDELT)

	If MV_PAR01 != 3 // VENDEDOR
		oSection2:Cell("VENNOM" ):SetValue(SF2TMP->VENNOM)
	EndIf

	If MV_PAR01 != 4 // REGIAO
		oSection2:Cell("REGIAO" ):SetValue(Posicione("Z06",1,xFilial("Z06")+SF2TMP->REGIAO,"Z06_DESCRI"))
	EndIf

	If MV_PAR01 != 5 // DIVISAO
		oSection2:Cell("DIVISAO"):SetValue(SF2TMP->DIVNOM)
	EndIf                 


	nQtdKg += SF2TMP->QTDKG
	nQtdLt += SF2TMP->QTDLT

	oSection2:PrintLine()
	
	oReport:IncMeter()
	
	SF2TMP->(DbSkip())

EndDo

If !Empty(cQuebra1)
	oSection1:Finish()
	oSection2:Finish()    
	nTotCliV := Len(aVendCli) 
	aVendCli := {}
			If MV_PAR01 == 3 
				oSection3:Init()
				oSection3:SetHeaderSection(.F.)
				oSection3:Cell("CLINOM"):SetValue("TOTAL DE CLIENTES:")
				oSection3:Cell("QTDCLI"):SetValue(nTotCliV)
				oSection3:PrintLine()
				oSection3:Finish()			
			EndIf	
	oReport:FatLine()  
EndIf

If Select("SF2TMP") > 0
	SF2TMP->(DbCloseArea())
EndIf   

Return()

Static Function DBFILSA1()

Local aFiltro  := {}       
cDbReGrp := ""  
cRelVen := GetMv("VQ_RELVEN")

If(!(UPPER(cUserName) $ cRelVen))	
	DbSelectArea("SU7") ; DbSetOrder(4)
	DbSelectArea("Z12") ; DbSetOrder(1)
	
	If SU7->(DbSeek(xFilial("SU7") + __cUserId))
		If Z12->(DbSeek(xFilial("Z12")+SU7->U7_CODVEN))
			While !Z12->(Eof()) .And. Z12->(Z12_FILIAL+Z12_COD) == xFilial("Z12")+SU7->U7_CODVEN
				If !Empty(Z12->Z12_REGIAO) .Or. !Empty(Z12->Z12_GRUPO)
					aAdd(aFiltro,{Z12->Z12_REGIAO,Z12->Z12_GRUPO})
				EndIf
				Z12->(DbSkip())
			EndDo
		EndIf
	EndIf  
	
	If Len(aFiltro) > 0
		cDbReGrp := "('"
		For nX := 1 To Len(aFiltro) 
			If(nX == 1)
				cDbReGrp += aFiltro[nX][1]+aFiltro[nX][2]+"'" 
			Else
				cDbReGrp += ",'"+aFiltro[nX][1]+aFiltro[nX][2]+"'"
			Endif                                
		Next	
		cDbReGrp += ")"  
	EndIf     
EndIf
Return(cDbReGrp)