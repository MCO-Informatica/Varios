#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmCteEn  | Autor: Celso Ferrone Martins  | Data: 17/03/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Relatorio de Frete de Compras.                             |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmCteEn()

Local oReport
Local cTitulo1 := "RELATORIO DE FRETES CONTRATADOS - COMPRAS"
Local cTitulo2 := "RELATORIO DE FRETES CONTRATADOS - COMPRAS"
Private cEof   := Chr(13) + Chr(10)

oReport := TReport():New("CFMCTEEN", cTitulo1, "CFMCTEEN", {|oReport| PrintReport(oReport)}, cTitulo2)
oReport:SetLandScape() //Retrato
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

PutSX1("CFMCTEEN","01","Emissao de        ","","","MV_CHA","D",08,0,0,"G","",""   ,"","","MV_PAR01",""   ,"","","",""   ,"","","",""     ,"","","","","","","","","","")
PutSX1("CFMCTEEN","02","Emissao ate       ","","","MV_CHB","D",08,0,0,"G","",""   ,"","","MV_PAR02",""   ,"","","",""   ,"","","",""     ,"","","","","","","","","","")
PutSX1("CFMCTEEN","03","Transportadora    ","","","MV_CHC","C",06,0,0,"G","","SA2","","","MV_PAR03",""   ,"","","",""   ,"","","",""     ,"","","","","","","","","","")
PutSX1("CFMCTEEN","04","Loja              ","","","MV_CHD","C",02,0,0,"G","",""   ,"","","MV_PAR04",""   ,"","","",""   ,"","","",""     ,"","","","","","","","","","")
PutSX1("CFMCTEEN","05","Fretes Contratados","","","MV_CHE","N",01,0,0,"C","",""   ,"","","MV_PAR05","Sim","","","","Nao","","","","Todos","","","","","","","","","","")
PutSX1("CFMCTEEN","06","Vencimento de     ","","","MV_CHF","D",08,0,0,"G","",""   ,"","","MV_PAR06",""   ,"","","",""   ,"","","",""     ,"","","","","","","","","","")
PutSX1("CFMCTEEN","07","Vencimento ate    ","","","MV_CHG","D",08,0,0,"G","",""   ,"","","MV_PAR07",""   ,"","","",""   ,"","","",""     ,"","","","","","","","","","")

//PutSX1("CFMCTEEN","03","Vencimento de      ","","","MV_CH3","D",08,0,0,"G","",""   ,"","","MV_PAR03","","","","","","","","","","","","","","","","","","","")
//PutSX1("CFMCTEEN","04","Vencimento ate     ","","","MV_CH4","D",08,0,0,"G","",""   ,"","","MV_PAR04","","","","","","","","","","","","","","","","","","","")
//PutSX1("CFMCTEEN","07","Placa              ","","","MV_CH7","C",07,0,0,"G","",""   ,"","","MV_PAR07",""         ,"","","",""         ,"","","","","","","","","","","","","","")
//

oSection1 := TRSection():New(oReport,"GERAL",{"TMP"})
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"TRANSP"     ,,"Transportadora" , PesqPict('SA4',"A4_NOME")    , TamSX3("A4_NOME")[1]+10,;
/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)


oSection2 := TRSection():New(oReport,"TRANSPORTADORA",{"TMP"})
oSection2:SetTotalInLine(.F.)

TRCell():New(oSection2,"F2_EMISSAO" , , "Emissao"       , PesqPict("SF2","F2_EMISSAO") , TamSX3("F2_EMISSAO")[1]+2,,,)
TRCell():New(oSection2,"E2_VENCREA" , , "Vencimento"    , PesqPict("SE2","E2_VENCREA") , TamSX3("E2_VENCREA")[1]+2,,,)
TRCell():New(oSection2,"Z11_DOC"    , , "NF.CTE"        , PesqPict("Z11","Z11_DOC")    , TamSX3("Z11_DOC")   [1]+2,,,)
TRCell():New(oSection2,"Z11_SERIE"  , , "Serie"         , PesqPict("Z11","Z11_SERIE")  , TamSX3("Z11_SERIE") [1]+2,,,)
TRCell():New(oSection2,"F2_DOC"     , , "Num. NF."      , PesqPict("SF2","F2_DOC")     , TamSX3("F2_DOC"    )[1]+2,,,)
TRCell():New(oSection2,"F2_SERIE"   , , "Serie"         , PesqPict("SF2","F2_SERIE")   , TamSX3("F2_SERIE"  )[1]+2,,,)
TRCell():New(oSection2,"Z11_NUMPV"  , , "Pedido"        , PesqPict("Z11","Z11_NUMPV")  , TamSX3("Z11_NUMPV" )[1]+2,,,)
TRCell():New(oSection2,"A2_NOME"    , , "Fornecedor"    , PesqPict("SA2","A2_NOME")    , TamSX3("A2_NOME"   )[1]+2,,,)
TRCell():New(oSection2,"Z11_COMPLE" , , "Observacao"    , "@!"                         , 15                       ,,,)
//TRCell():New(oSection2,"F2_VALBRUT" , , "Valor Nf."   , PesqPict("SF2","F2_VALBRUT") , TamSX3("F2_VALBRUT")[1]+2,,,"RIGHT")
TRCell():New(oSection2,"C7_VQ_VFRE" , , "Vl.Contratado" , PesqPict("SC7","C7_VQ_VFRE") , TamSX3("C7_VQ_VFRE")[1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"Z11_VALOR"  , , "Vl.Pago"       , PesqPict("Z11","Z11_VALOR")  , TamSX3("Z11_VALOR") [1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VLR_E_ICMS" , , "Vl.c/Imposto"  , PesqPict("Z11","Z11_ICMS")   , TamSX3("Z11_ICMS"  )[1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"Z11_ICMS"   , , "Imposto"       , PesqPict("Z11","Z11_ICMS"  ) , TamSX3("Z11_ICMS"  )[1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"TRANSP2"    , , "Transportadora", PesqPict('SA4',"A4_NOME")    , TamSX3("A4_NOME"   )[1]+2,,,)
TRCell():New(oSection2,"C7_VQ_TFRE" , , "Tipo Frete"    , "@!"                         , 20                       ,,,)

//TRFunction():New(oSection2:Cell("F2_VALBRUT"),"","SUM",,"Total Vendedor",PesqPict("SF2","F2_VALBRUT"),,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("C7_VQ_VFRE"),"","SUM",,"Total Vendedor",PesqPict("SC7","C7_VQ_VFRE"),,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("Z11_VALOR") ,"","SUM",,"Total Vendedor",PesqPict("Z11","Z11_VALOR") ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("Z11_ICMS")  ,"","SUM",,"Total Vendedor",PesqPict("Z11","Z11_ICMS")  ,,.T.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("VLR_E_ICMS"),"","SUM",,"Total Vendedor",PesqPict("Z11","Z11_ICMS")  ,,.T.,.T.,.F.,oSection2)


oSection3 := TRSection():New(oReport,"TRANSPORTADORA",{"TMP"})
oSection3:SetTotalInLine(.F.)

TRCell():New(oSection3,"F2_EMISSAO" , , "Emissao"       , PesqPict("SF2","F2_EMISSAO") , TamSX3("F2_EMISSAO")[1]+2,,,)
TRCell():New(oSection3,"E2_VENCREA" , , "Vencimento"    , PesqPict("SE2","E2_VENCREA") , TamSX3("E2_VENCREA")[1]+2,,,)
TRCell():New(oSection3,"Z11_DOC"    , , "NF.CTE"        , PesqPict("Z11","Z11_DOC")    , TamSX3("Z11_DOC")   [1]+2,,,)
TRCell():New(oSection3,"Z11_SERIE"  , , "Serie"         , PesqPict("Z11","Z11_SERIE")  , TamSX3("Z11_SERIE") [1]+2,,,)
TRCell():New(oSection3,"F2_DOC"     , , "Num. NF."      , PesqPict("SF2","F2_DOC")     , TamSX3("F2_DOC"    )[1]+2,,,)
TRCell():New(oSection3,"F2_SERIE"   , , "Serie"         , PesqPict("SF2","F2_SERIE")   , TamSX3("F2_SERIE"  )[1]+2,,,)
TRCell():New(oSection3,"Z11_NUMPV"  , , "Pedido"        , PesqPict("Z11","Z11_NUMPV")  , TamSX3("Z11_NUMPV" )[1]+2,,,)
TRCell():New(oSection3,"A2_NOME"    , , "Fornecedor"    , PesqPict("SA2","A2_NOME")    , TamSX3("A2_NOME"   )[1]+2,,,)
TRCell():New(oSection3,"Z11_COMPLE" , , "Observacao"    , "@!"                         , 15                       ,,,)
//TRCell():New(oSection3,"F2_VALBRUT" , , "Valor Nf."   , PesqPict("SF2","F2_VALBRUT") , TamSX3("F2_VALBRUT")[1]+2,,,"RIGHT")
TRCell():New(oSection3,"C7_VQ_VFRE" , , "Vl.Contratado" , PesqPict("SC7","C7_VQ_VFRE") , TamSX3("C7_VQ_VFRE")[1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection3,"Z11_VALOR"  , , "Vl.Pago"       , PesqPict("Z11","Z11_VALOR")  , TamSX3("Z11_VALOR" )[1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection3,"VLR_E_ICMS" , , "Vl.c/Imposto"  , PesqPict("Z11","Z11_ICMS")   , TamSX3("Z11_ICMS"  )[1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection3,"Z11_ICMS"   , , "Imposto"       , PesqPict("Z11","Z11_ICMS")   , TamSX3("Z11_ICMS"  )[1]+2,,,"RIGHT",,"RIGHT")
TRCell():New(oSection3,"TRANSP2"    , , "Transportadora", PesqPict('SA4',"A4_NOME")    , TamSX3("A4_NOME"   )[1]+2,,,)
TRCell():New(oSection3,"C7_VQ_TFRE" , , "Tipo Frete"    , "@!"                         , 20                       ,,,)

Pergunte(oReport:uParam,.F.)

oReport:PrintDialog()

Return()


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local nValSobra := 0
Local aNumCte   := {}
Local cQuery 	:= ""

cQuery += " SELECT                                          " + cEof
cQuery += "   SF8.F8_DTDIGIT           AS EMISSAO,          " + cEof
cQuery += "   SE2FR.E2_VENCREA         AS VENCTO,           " + cEof
cQuery += "   SF8.F8_NFDIFRE           AS NF_CTE,           " + cEof
cQuery += "   SF8.F8_SEDIFRE           AS SER_CTE,          " + cEof
cQuery += "   SF8.F8_TRANSP            AS TRANSP,           " + cEof
cQuery += "   SF8.F8_LOJTRAN           AS LOJ_TRANSP,       " + cEof
cQuery += "   SF8.F8_NFORIG            AS NF_ORI,           " + cEof
cQuery += "   SF8.F8_SERORIG           AS SER_ORI,          " + cEof
cQuery += "   SF8.F8_FORNECE           AS FORNECE,          " + cEof
cQuery += "   SF8.F8_LOJA              AS LOJA,             " + cEof
//cQuery += "   SD1NF.D1_PEDIDO          AS PEDIDO,           " + cEof
cQuery += "   SA2NF.A2_NOME            AS NOME_FOR,         " + cEof
cQuery += "   COALESCE(C7_NUM    ,' ') AS PEDIDO,           " + cEof
cQuery += "   COALESCE(C7_QUANT  ,0  ) AS C7_QUANT,         " + cEof
cQuery += "   COALESCE(C7_VQ_TRAN,' ') AS C7_VQ_TRAN,       " + cEof
cQuery += "   COALESCE(C7_VQ_VFRE,0  ) AS C7_VQ_VFRE,       " + cEof
cQuery += "   COALESCE(C7_VQ_TFRE,' ') AS C7_VQ_TFRE,       " + cEof   

cQuery += "   SD1NF.D1_UM              AS UMEDIDA_SD1, 		" + cEof    //DANILO BUSSO 
cQuery += "   SD1NF.D1_QUANT           AS QUANTIDADE_SD1,	" + cEof    //DANILO BUSSO

//cQuery += "   SD1FR.D1_TOTAL           AS TOTAL_FR,         " + cEof
//cQuery += "   SD1FR.D1_VALICM          AS VLR_ICM,          " + cEof
cQuery += "   SUM(SD1FR.D1_TOTAL)           AS TOTAL_FR,         " + cEof
cQuery += "   SUM(SD1FR.D1_VALICM)          AS VLR_ICM,          " + cEof
cQuery += "   SA2FR.A2_NOME            AS NOME_TRA,          " + cEof
cQuery += "   SF1FR.F1_TPCTE           " + cEof
                                                            
cQuery += " FROM "+RetSqlName("SF8")+" SF8                  " + cEof
                                                            
cQuery += "   INNER JOIN "+RetSqlName("SD1")+" SD1NF ON     " + cEof
cQuery += "     SD1NF.D_E_L_E_T_ <> '*'                     " + cEof
cQuery += "     AND SD1NF.D1_FILIAL  = '"+xFilial("SD1")+"' " + cEof
cQuery += "     AND SD1NF.D1_DOC     = SF8.F8_NFORIG        " + cEof
cQuery += "     AND SD1NF.D1_SERIE   = SF8.F8_SERORIG       " + cEof
cQuery += "     AND SD1NF.D1_FORNECE = SF8.F8_FORNECE       " + cEof
cQuery += "     AND SD1NF.D1_LOJA    = SF8.F8_LOJA          " + cEof
cQuery += "     AND SD1NF.D1_TIPO    = 'N'                  " + cEof
                                                            
cQuery += "   INNER JOIN "+RetSqlName("SA2")+" SA2NF ON     " + cEof
cQuery += "     SA2NF.D_E_L_E_T_  <> '*'                    " + cEof
cQuery += "     AND SA2NF.A2_FILIAL = '"+xFilial("SA2")+"'  " + cEof
cQuery += "     AND SA2NF.A2_COD    = SD1NF.D1_FORNECE      " + cEof
cQuery += "     AND SA2NF.A2_LOJA   = SD1NF.D1_LOJA         " + cEof
                                                            
cQuery += "   LEFT JOIN "+RetSqlName("SC7")+" SC7 ON        " + cEof
cQuery += "     SC7.D_E_L_E_T_ <> '*'                       " + cEof
cQuery += "     AND SC7.C7_FILIAL   = '"+xFilial("SC7")+"'  " + cEof
cQuery += "     AND SC7.C7_NUM      = SD1NF.D1_PEDIDO       " + cEof
cQuery += "     AND SC7.C7_ITEM = SD1NF.D1_ITEMPC         " + cEof 

cQuery += "   INNER JOIN "+RetSqlName("SD1")+" SD1FR ON     " + cEof
cQuery += "     SD1FR.D_E_L_E_T_ <> '*'                     " + cEof
cQuery += "     AND SD1FR.D1_FILIAL  = '"+xFilial("SD1")+"' " + cEof
cQuery += "     AND SD1FR.D1_DOC     = SF8.F8_NFDIFRE       " + cEof
cQuery += "     AND SD1FR.D1_SERIE   = SF8.F8_SEDIFRE       " + cEof
cQuery += "     AND SD1FR.D1_FORNECE = SF8.F8_TRANSP        " + cEof
cQuery += "     AND SD1FR.D1_LOJA    = SF8.F8_LOJTRAN       " + cEof
cQuery += "     AND SD1FR.D1_TIPO    = 'C'                  " + cEof    
cQuery += "   INNER JOIN "+RetSqlName("SF1")+" SF1FR ON     " + cEof    
cQuery += "   	SF1FR.D_E_L_E_T_ <> '*'       				" + cEof    
cQuery += "     AND SF1FR.F1_FILIAL = '"+xFilial("SF1")+"'	" + cEof    
cQuery += "     AND SF1FR.F1_DOC 	= SD1FR.D1_DOC       	" + cEof    
cQuery += "     AND SF1FR.F1_SERIE 	= SD1FR.D1_SERIE       	" + cEof    
cQuery += "     AND SF1FR.F1_FORNECE = SD1FR.D1_FORNECE     " + cEof    
cQuery += "     AND SF1FR.F1_LOJA = SD1FR.D1_LOJA        	" + cEof    
cQuery += "   INNER JOIN "+RetSqlName("SA2")+" SA2FR ON     " + cEof
cQuery += "     SA2FR.D_E_L_E_T_  <> '*'                    " + cEof
cQuery += "     AND SA2FR.A2_FILIAL = '"+xFilial("SA2")+"'  " + cEof
cQuery += "     AND SA2FR.A2_COD    = SD1FR.D1_FORNECE      " + cEof
cQuery += "     AND SA2FR.A2_LOJA   = SD1FR.D1_LOJA         " + cEof
cQuery += "   INNER JOIN "+RetSqlName("SE2")+" SE2FR ON     " + cEof
cQuery += "     SE2FR.D_E_L_E_T_  <> '*'                    " + cEof
cQuery += "     AND SE2FR.E2_FILIAL = '"+xFilial("SE2")+"'  " + cEof
cQuery += "     AND SE2FR.E2_NUM     = SD1FR.D1_DOC         " + cEof
cQuery += "     AND SE2FR.E2_PREFIXO = SD1FR.D1_SERIE       " + cEof
cQuery += "     AND SE2FR.E2_FORNECE = SD1FR.D1_FORNECE     " + cEof
cQuery += "     AND SE2FR.E2_LOJA    = SD1FR.D1_LOJA        " + cEof
cQuery += "     AND SE2FR.E2_VENCREA BETWEEN '"+DTos(MV_PAR06)+"' AND '"+DTos(MV_PAR07)+"' "
cQuery += " WHERE                                           " + cEof
cQuery += "   SF8.D_E_L_E_T_ <> '*'                         " + cEof
cQuery += "   AND F8_FILIAL = '"+xFilial("SF8")+"'          " + cEof
cQuery += "   AND F8_DTDIGIT BETWEEN '"+DTos(MV_PAR01)+"' AND '"+DTos(MV_PAR02)+"' " + cEof
If !Empty(MV_PAR03)
	cQuery += "   AND F8_TRANSP  = '"+MV_PAR03+"'               " + cEof
	cQuery += "   AND F8_LOJTRAN = '"+MV_PAR04+"'               " + cEof 
EndIf    
cQuery += " GROUP BY SF8.F8_DTDIGIT, SE2FR.E2_VENCREA, SF8.F8_NFDIFRE, SF8.F8_SEDIFRE, SF8.F8_TRANSP, SF8.F8_LOJTRAN, SF8.F8_NFORIG, SF8.F8_SERORIG, SF8.F8_FORNECE, SF8.F8_LOJA, SA2NF.A2_NOME, C7_NUM,C7_QUANT, C7_VQ_TRAN, C7_VQ_VFRE, C7_VQ_TFRE, SD1NF.D1_UM, SD1NF.D1_QUANT, SA2FR.A2_NOME, SF1FR.F1_TPCTE   " + cEof
cQuery += " ORDER BY SF8.F8_TRANSP, SF8.F8_DTDIGIT, SF8.F8_NFDIFRE, SF8.F8_SEDIFRE, SF8.F8_LOJTRAN, SF8.F8_NFORIG, SF8.F8_SERORIG, SF8.F8_FORNECE, SF8.F8_LOJA" 

cQuery := ChangeQuery(cQuery)

If Select("SF8TMP") > 0
	SF8TMP->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "SF8TMP"
	
nTotalReg := Contar("SF8TMP", "!Eof()")
SF8TMP->(DbGoTop())

oReport:SetMeter(nTotalReg)

cQuebra1 := ""
cNotaAnt := ""

While !SF8TMP->(Eof())

	If MV_PAR05 == 1 .And. Empty(SF8TMP->C7_VQ_TRAN)
		SF8TMP->(DbSkip())
		Loop
	ElseIf MV_PAR05 == 2 .And. !Empty(SF8TMP->C7_VQ_TRAN)
		SF8TMP->(DbSkip())
		Loop
	EndIf
	
	If cQuebra1 != SF8TMP->TRANSP
		
		If !Empty(cQuebra1)
			oSection1:Finish()
			oSection2:Finish()

			oReport:FatLine()		
			oSection3:Init()
			oSection3:SetHeaderSection(.F.)
			oSection3:Cell("Z11_COMPLE"):SetValue("FALTA/SOBRA")
			oSection3:Cell("Z11_VALOR"):SetValue(nValSobra)
			oSection3:PrintLine()
			oSection3:Finish()
			oReport:FatLine()
			nValSobra := 0
		EndIf
		
		cQuebra1 := SF8TMP->TRANSP
		oSection1:Init()
		oSection1:SetHeaderSection(.F.)
		
		oReport:FatLine()
		oSection1:Cell("TRANSP"):SetValue("Transportadora: "+SF8TMP->TRANSP+": "+SF8TMP->NOME_TRA)
		oSection1:PrintLine()
		
		oSection2:Init()
		oSection2:SetHeaderSection(.T.)
	EndIf

		nPos := aScan(aNumCte,{|x|x == SF8TMP->(NF_CTE+SER_CTE+FORNECE)})
  		If (nPos == 0 .OR. SF8TMP->C7_VQ_TFRE=="T") 
	  		 		
			aAdd(aNumCte,SF8TMP->(NF_CTE+SER_CTE+FORNECE))
			cNotaAnt  := SF8TMP->(NF_CTE+SER_CTE+FORNECE)            
			nValFrete := IIF(SF8TMP->F1_TPCTE == 'C', 0, SF8TMP->C7_VQ_VFRE)
			
			If !(nPos > 0)  
				oSection2:Cell("Z11_ICMS"):SetValue(SF8TMP->(VLR_ICM))
				oSection2:Cell("VLR_E_ICMS"):SetValue(SF8TMP->(TOTAL_FR))  
				oSection2:Cell("Z11_VALOR"):SetValue(SF8TMP->(TOTAL_FR-VLR_ICM)) 
				
				nValSobra += If(SF8TMP->C7_VQ_TFRE=="T", nValFrete * (QUANTIDADE_SD1 / 1000),nValFrete) 
				nValSobra -= SF8TMP->(TOTAL_FR-VLR_ICM)     		
			Else     
				If(SF8TMP->C7_VQ_TFRE=="T" .AND. SF8TMP->(NF_CTE+SER_CTE+FORNECE) == cNotaAnt )  
					nValSobra += If(SF8TMP->C7_VQ_TFRE=="T",SF8TMP->(C7_VQ_VFRE * (QUANTIDADE_SD1 / 1000)),nValFrete)  
				Else
					nValSobra += SF8TMP->(TOTAL_FR-VLR_ICM)
				EndIf
				oSection2:Cell("Z11_ICMS"):SetValue(0)
				oSection2:Cell("VLR_E_ICMS"):SetValue(0)      
				oSection2:Cell("Z11_VALOR"):SetValue(0) 
			EndIF
			oSection2:Cell("C7_VQ_TFRE"):SetValue(If(SF8TMP->C7_VQ_TFRE=="T","Frete Por Tonelada","Frete Fechado"))

			IIF(SF8TMP->F1_TPCTE == 'C', oSection2:Cell("C7_VQ_VFRE"):SetValue(0),	oSection2:Cell("C7_VQ_VFRE"):SetValue(If(SF8TMP->C7_VQ_TFRE=="T",SF8TMP->(C7_VQ_VFRE * (QUANTIDADE_SD1 / 1000)),SF8TMP->C7_VQ_VFRE))) // C7_QUANT  //DANILO BUSSO 28/10/2015
		
		Else   
	    oSection2:Cell("C7_VQ_VFRE"):SetValue(0)//Danilo Busso 02/12/2015
		oSection2:Cell("Z11_VALOR"):SetValue(0)
		oSection2:Cell("Z11_ICMS"):SetValue(0)
		oSection2:Cell("VLR_E_ICMS"):SetValue(0)
	EndIf
		
	oSection2:Cell("Z11_DOC"):SetValue(SF8TMP->NF_CTE)
	oSection2:Cell("Z11_SERIE"):SetValue(SF8TMP->SER_CTE)
	oSection2:Cell("E2_VENCREA"):SetValue(DtoC(StoD(SF8TMP->VENCTO)))
	oSection2:Cell("F2_DOC"):SetValue(SF8TMP->NF_ORI)
	oSection2:Cell("F2_SERIE"):SetValue(SF8TMP->SER_ORI)
	oSection2:Cell("F2_EMISSAO"):SetValue(DtoC(StoD(SF8TMP->EMISSAO)))
	oSection2:Cell("A2_NOME"):SetValue(SF8TMP->NOME_FOR)
	oSection2:Cell("Z11_NUMPV"):SetValue(SF8TMP->PEDIDO)

//	oSection2:Cell("Z11_COMPLE"):SetValue(If(SF8TMP->OBSCTE=="N","Normal",If(SF8TMP->OBSCTE=="E","Entrada","Complemento"))) 

//	If SF8TMP->OBSCTE != "E"   
//	Else
//		oSection2:Cell("C7_VQ_VFRE"):SetValue(0)
//	EndIf

	oSection2:Cell("TRANSP2"):SetValue(SF8TMP->NOME_TRA)
	
	oSection2:PrintLine()
	
	oReport:IncMeter()
	SF8TMP->(DbSkip())
EndDo

If !Empty(cQuebra1)
	oSection1:Finish()
	oSection2:Finish()
	
	oReport:FatLine()			
	oSection3:Init()
	oSection3:SetHeaderSection(.F.)
	oSection3:Cell("Z11_COMPLE"):SetValue("FALTA/SOBRA")
	oSection3:Cell("Z11_VALOR"):SetValue(nValSobra)
//	oSection3:Cell("C7_VQ_VFRE"):SetValue(nValSobra)
	oSection3:PrintLine()
	oSection3:Finish()
	oReport:FatLine()
	
EndIf

If Select("SF8TMP") > 0
	SF8TMP->(DbCloseArea())
EndIf

Return()
