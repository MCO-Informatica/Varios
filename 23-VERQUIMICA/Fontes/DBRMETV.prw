#Include 'Protheus.ch'  
#Include 'TOPCONN.CH'       

User Function DBRMETV()
	Local oReport := nil
	Local cPerg:= Padr("METAVEN0",10)      
	Private cEof   := Chr(13) + Chr(10)
	Private _aDadosAux 	:= {}  
	Private _aDados		:= {}  
	Private _nPos		:= 0    
	Private cCodCli		:= ""
	Private cGrupoP		:= ""
	Private cRegCli		:= ""
	Private cGrpCli		:= ""      
	Private _struct		:= {}
	Private cArq		:= ""
	Private _cCodVend   := ""
	Private _cFilVend   := ""
	Private _nQtdCon	:= 0
	Private _nQtdCom	:= 0	
	Private _cUsers := GetMv("VQ_VISUCLI") 
	Private _lAllCli	:= (__cUserId $ _cUsers)  

	If !_lAllCli  
		_cCodVend := _getVended(Alltrim(__cUserID))  
		U_DBFILSA1()	
	EndIf

	AjustaSX1(cPerg)
	
	If(Pergunte(cPerg,.T.))
		While(!validaPrm())      
			Pergunte(cPerg,.T.)
		EndDo
		oReport := RptDef(cPerg)
		oReport:PrintDialog()
	EndIf	          
	
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection3:= Nil
	Local oSection4:= Nil   
	Local oSection5:= Nil
	Local oBreak
	Local oFunction
	
	oReport := TReport():New(cNome,"Consumo Estimado x Realizado",cNome,{|oReport| ReportPrint(oReport)},"Esse relatório é responsável por exibir informações do consumo estimado x consumo realizado")
	oReport:SetPortrait()
//	oReport:lHeaderVisible := .F.     
	oReport:SetTotalInLine(.F.)         
	   
	oSection1 := TRSection():New(oReport, "RMETAS")
	TRCell():New(oSection1,	"PARAM1"		,"TRBNCM",""  		,"@!",220)    
	
	oSection2 := TRSection():New(oReport, "RMETAS")
	TRCell():New(oSection2,	"PARAM2"		,"TRBNCM",""  		,"@!",220)    
		
	oSection3 := TRSection():New(oReport, "RMETAS")
	TRCell():New(oSection3,	"GRUPOPRODUTO"		,"TRBNCM","COD. GRUPO PRODUTO"  		,"@!",10)    
	TRCell():New(oSection3,	"NUMGRUPOP"	   		,"TRBNCM","GRUPO PRODUTO"  				,"@!",210)

	oSection4:= TRSection():New(oReport, "RMETAS")
	oSection4:SetTotalInLine(.F.)
	TRCell():New(oSection4,"CODCLIENTE"		,"TRBNCM","CODIGO" ,"@!"						,8		)
	TRCell():New(oSection4,"LJCLIENTE"		,"TRBNCM","LOJA"  		,"@!"						,2		)    
	TRCell():New(oSection4,"NMCLIENTE"		,"TRBNCM","NOME"  		,"@!"						,20		)    
	TRCell():New(oSection4,"GRPCLIENTE"		,"TRBNCM","DIVISAO"		,PesqPict("SD2","D2_UM")	,2	    )
	TRCell():New(oSection4,"REGCLIENTE"		,"TRBNCM","REGIAO"		,"@ 999,999,999,999"		,2	)
	TRCell():New(oSection4,"MV_PRODUTO"  	,"TRBNCM","PRODUTO"	,"@!"	,TamSX3("CT_PRODUTO")[1]		) 
	TRCell():New(oSection4,"MV_VQ_GAUT"  	,"TRBNCM","REGISTRO"	,"@!"						,1		) 
	TRCell():New(oSection4,"MV_QUANTIDADE"  ,"TRBNCM","QTD.ESTIMADA x PERIODO (MESES)"	,"@!"	,50		) 
	TRCell():New(oSection4,"MV_UNIDADEMEDIDA"	,"TRBNCM","UM.ESTIMADA"	,"@ 999,999,999,9999"		,2		) 
	TRCell():New(oSection4,"D2_QUANTIDADE"  	,"TRBNCM","QTD.VENDIDA"	,"@ 999,999,999,999"		,TamSX3("D2_QUANT")[1]	) 
	TRCell():New(oSection4,"D2_UNIDADEMEDIDA"  	,"TRBNCM","UM.VENDIDA"	,"@ 999,999,999,999"		,2		) 
   	TRCell():New(oSection4,"TOTREALIZADO"  		,"TRBNCM","REALIZADO(%)"	,"@!"					,10	)     		    	
                                                                                                     	
	oSection5:= TRSection():New(oReport, "RMETAS")                                     	
	TRCell():New(oSection5,"QTDCLICOM"		,"TRBNCM","" ,"@!"						,130)
	TRCell():New(oSection5,"D2_QUANTIDADE"  ,"TRBNCM","" ,"@ 999,999,999,999"		,TamSX3("D2_QUANT")[1]) 
   	TRCell():New(oSection5,"TOTREALIZADO"  	,"TRBNCM","" ,"@!"						,10)    

Return(oReport)

Static Function ReportPrint(oReport)     
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4) 
	Local oSection5 := oReport:Section(5)
	Local cQuery    := ""		
	Local cGrupoAt := ""   
	Local cGrupoAn	:= ""
	Local lPrim 	:= .T.	     
	Local nPeriodo := IIF(ROUND((MV_PAR04 - MV_PAR03)/30,0)==0,1,ROUND((MV_PAR04 - MV_PAR03)/30,0)) 
	Local nTotQtdE := 0
	Local nTotQtdR := 0  
	Local nPercRea := 0 
	Local nCont	:= 0   
	Local cDtMeta := ""
	Local cDtEmis := ""   
	Local cGrpDe	:= ""
	Local cGrpAte	:= ""      
	
	DbSelectArea("SBM"); DbSetOrder(1)
	If SBM->(DbSeek(xFilial("SBM")+ALLTRIM(MV_PAR05)))  	
		cGrpDe := SBM->BM_DESC
	EndIf
	
	If SBM->(DbSeek(xFilial("SBM")+ALLTRIM(MV_PAR06)))  	
		cGrpAte := SBM->BM_DESC
	EndIf
	
	IF(!EMPTY(MV_PAR01))
		cCodCli  := " AND (CODCLIENTE BETWEEN '" + AllTrim(MV_PAR01) + "' AND '" + IIF(EMPTY(MV_PAR02),"ZZZZZZZZ",AllTrim(MV_PAR02)) + "')" 
	ENDIF
	IF(!EMPTY(MV_PAR05)) 
		cGrupoP := " AND (GRUPOPRODUTO BETWEEN '" + AllTrim(MV_PAR05) + "'  AND '" + IIF(EMPTY(MV_PAR06),"ZZZZ",AllTrim(MV_PAR06)) + "')" 
	ENDIF
	IF(!EMPTY(MV_PAR07))
		cRegCli := " AND (REGCLIENTE BETWEEN '" + AllTrim(MV_PAR07)  + "' AND '" + IIF(EMPTY(MV_PAR10),"ZZZZ",AllTrim(MV_PAR08)) + "')" 
	ENDIF                                                                                                       
	IF(!EMPTY(MV_PAR09))
		cGrpCli := " AND (GRPCLIENTE BETWEEN '" + AllTrim(MV_PAR09) + "  ' AND '" + IIF(EMPTY(MV_PAR10),"ZZZZZZ",AllTrim(MV_PAR10)+"  ") + "')" 
	ENDIF	

	cQuery := vqGetQry()
	cQuery := AllTrim(cQuery)

	IF Select("TRBNCM") <> 0
		DbSelectArea("TRBNCM")
		DbCloseArea()
	ENDIF
		
	TCQUERY cQuery NEW ALIAS "TRBNCM"	
	
	dbSelectArea("TRBNCM")
	TRBNCM->(dbGoTop())
	
	oReport:SetMeter(TRBNCM->(LastRec()))	

	//Irei percorrer todos os meus registros 
	While !Eof()
	    nPos := aScan(_aDadosAux,{|x|x == TRBNCM->(CODCLIENTE+NMCLIENTE+LJCLIENTE+GRPCLIENTE+MV_VENDEDOR+REGCLIENTE+GRUPOPRODUTO+DESCGRUPOP+MV_PRODUTO)})
	    If nPos = 0   
        	aadd(_aDadosAux, TRBNCM->(CODCLIENTE+NMCLIENTE+LJCLIENTE+GRPCLIENTE+MV_VENDEDOR+REGCLIENTE+GRUPOPRODUTO+DESCGRUPOP+MV_PRODUTO) )  
        	
	    	aadd(_aDados, { TRBNCM->CODCLIENTE, ;
						   TRBNCM->NMCLIENTE, ;
						   TRBNCM->LJCLIENTE, ;
						   TRBNCM->GRPCLIENTE, ;
						   TRBNCM->MV_VENDEDOR, ;
						   TRBNCM->REGCLIENTE, ;
						   TRBNCM->GRUPOPRODUTO, ;
						   TRBNCM->DESCGRUPOP, ; 
						   TRBNCM->MV_PRODUTO, ;
						   TRBNCM->MV_VALOR, ;
  						   TRBNCM->MV_QUANTIDADE, ;
						   TRBNCM->D2_CODCLIENTE, ;
						   TRBNCM->D2_LOJA, ;
						   TRBNCM->A1_NOMECLI, ;
						   TRBNCM->A1_REGCLI, ;
						   TRBNCM->A1_GRPCLI, ;
						   TRBNCM->D2_UNIDADEMEDIDA, ;
						   TRBNCM->D2_QUANTIDADE, ;
						   TRBNCM->B1_GRUPOPRODUTO, ;
						   TRBNCM->BM_DESCGRUPO ,;
						   StoD(TRBNCM->MV_DATA),;
						   TRBNCM->MV_VQ_GAUT} ) 	    
			Else
				If _aDados[nPos][21] < StoD(TRBNCM->MV_DATA)
					_aDados[nPos][1] := TRBNCM->CODCLIENTE
					_aDados[nPos][2] := TRBNCM->NMCLIENTE
					_aDados[nPos][3] := TRBNCM->LJCLIENTE
					_aDados[nPos][4] := TRBNCM->GRPCLIENTE
					_aDados[nPos][5] := TRBNCM->MV_VENDEDOR
					_aDados[nPos][6] := TRBNCM->REGCLIENTE
					_aDados[nPos][7] := TRBNCM->GRUPOPRODUTO
					_aDados[nPos][8] := TRBNCM->DESCGRUPOP
					_aDados[nPos][9] := TRBNCM->MV_PRODUTO
					_aDados[nPos][10] := TRBNCM->MV_VALOR
					_aDados[nPos][11] := TRBNCM->MV_QUANTIDADE
					_aDados[nPos][12] := TRBNCM->D2_CODCLIENTE
					_aDados[nPos][13] := TRBNCM->D2_LOJA
					_aDados[nPos][14] := TRBNCM->A1_NOMECLI
					_aDados[nPos][15] := TRBNCM->A1_REGCLI
					_aDados[nPos][16] := TRBNCM->A1_GRPCLI	
					_aDados[nPos][17] := TRBNCM->D2_UNIDADEMEDIDA
					_aDados[nPos][18] := TRBNCM->D2_QUANTIDADE
					_aDados[nPos][19] := TRBNCM->B1_GRUPOPRODUTO
					_aDados[nPos][20] := TRBNCM->BM_DESCGRUPO
					_aDados[nPos][21] := StoD(TRBNCM->MV_DATA)
					_aDados[nPos][22] := TRBNCM->MV_VQ_GAUT 	  
				EndIf
	    EndIf   
	         
	    TRBNCM->(dbSkip())	
    EndDo

	dbSelectArea("TRBNCM")
	TRBNCM->(dbGoTop())
	 
//	While !Eof() 
	vqCriaTB()
	DBUSEAREA(.T.,,carq,"TTMPVQ5")  
	DbSelectArea("TTMPVQ5")	
	For nx := 1 To Len(_aDados)
		RecLock("TTMPVQ5",.T.)	   
			TTMPVQ5->GRPPRODUTO := _aDados[nX][7]
			TTMPVQ5->NUMGRUPOP	:= _aDados[nX][8]
			TTMPVQ5->CODCLIENTE	:= _aDados[nX][1]
			TTMPVQ5->LJCLIENTE	:= _aDados[nX][3]
			TTMPVQ5->NMCLIENTE	:= _aDados[nX][2]
			TTMPVQ5->GRPCLIENTE	:= _aDados[nX][4]
			TTMPVQ5->REGCLIENTE	:= _aDados[nX][6]
			TTMPVQ5->MV_QTDE	:= _aDados[nX][11]
			TTMPVQ5->MV_UM		:= ""
			TTMPVQ5->D2_QTDE	:= _aDados[nX][18]
			TTMPVQ5->D2_UM		:= _aDados[nX][17]
			TTMPVQ5->TOTRLZD	:= 0   
			TTMPVQ5->MV_PRODUTO := _aDados[nX][9]      
			TTMPVQ5->MV_VQ_GAUT := _aDados[nX][22]
		MsunLock()	
	Next   
	
TTMPVQ5->(DbGoTop())

        oSection1:Init()
        oSection2:Init()
		oSection1:Cell("PARAM1"):SetValue("Cliente De: " + MV_PAR01 + " Até: " + MV_PAR02 + "     Faturamento De: " + DTOC(MV_PAR03) + " Até: " + DTOC(MV_PAR04)) 
		oSection1:Printline()      
		oSection2:Cell("PARAM2"):SetValue("Grupo Produto De: " + AllTrim(cGrpDe) + "  Até: " + AllTrim(cGrpAte) + "    Regiao De: " + MV_PAR07 +" Até: " + MV_PAR08 + "    Divisao De: " + MV_PAR09 + " Até: " + MV_PAR10)
		oSection2:Printline()                                                                                          
        oSection1:Finish()
        oSection2:Finish()    
   	
While !Eof()      			
		oSection3:Init()
		oReport:IncMeter()    
		
		cGrupoAt := TTMPVQ5->GRPPRODUTO
		
		if(lPrim)
			cGrupoAn := cGrupoAt
			lPrim := .F.                                                                            
		EndIf
		
		IncProc("Imprimindo Grupo Produto : " + AllTrim(cGrupoAt)) 
		       
		oSection3:Cell("GRUPOPRODUTO"):SetValue(cGrupoAt)    
		oSection3:Cell("NUMGRUPOP"):SetValue(TTMPVQ5->NUMGRUPOP)
		  
		oSection3:Printline()
		
		oSection4:init()
		
		While (cGrupoAt == cGrupoAn)
			oReport:IncMeter()
			IncProc("Imprimindo Cliente " + AllTrim(TTMPVQ5->CODCLIENTE))  
			                                                                 
			oSection4:Cell("CODCLIENTE"):SetValue(TTMPVQ5->CODCLIENTE)
			oSection4:Cell("LJCLIENTE"):SetValue(TTMPVQ5->LJCLIENTE)
			oSection4:Cell("NMCLIENTE"):SetValue(TTMPVQ5->NMCLIENTE)
			
			oSection4:Cell("GRPCLIENTE"):SetValue(TTMPVQ5->GRPCLIENTE)
			oSection4:Cell("REGCLIENTE"):SetValue(TTMPVQ5->REGCLIENTE)  
			oSection4:Cell("MV_PRODUTO"):SetValue(TTMPVQ5->MV_PRODUTO)  
			oSection4:Cell("MV_VQ_GAUT"):SetValue(TTMPVQ5->MV_VQ_GAUT)
                             
			_nQtdCon += 1 		
			If (TTMPVQ5->D2_QTDE > 0)
				_nQtdCom += 1
			EndIf            
			
		   	cMtxPrd := ALLTRIM(TRANSFORM(TTMPVQ5->MV_QTDE, "@E 999,999,999")) + " x " + ALLTRIM(cValToChar(nPeriodo)) + " = " + ALLTRIM(TRANSFORM(TTMPVQ5->MV_QTDE * nPeriodo,"@E 999,999,999"))
		   	nMeta := TTMPVQ5->MV_QTDE * nPeriodo     
		   	
		   	nTotQtdE += nMeta
			nTotQtdR += TTMPVQ5->D2_QTDE                    
			
			oSection4:Cell("MV_QUANTIDADE"):SetValue(cMtxPrd)
			oSection4:Cell("MV_UNIDADEMEDIDA"):SetValue("KG")
			oSection4:Cell("D2_QUANTIDADE"):SetValue(TRANSFORM(TTMPVQ5->D2_QTDE, "@E 999,999,999"))     
			oSection4:Cell("D2_UNIDADEMEDIDA"):SetValue(TTMPVQ5->D2_UM)    
		   
			nTotRealizado := 0
			IF(!Empty(TTMPVQ5->MV_QTDE) .AND. !Empty(TTMPVQ5->D2_QTDE))
	        	nTotRealizado :=  (TTMPVQ5->D2_QTDE/nMeta)*100 
	        	nPercRea += nTotRealizado                                                                         
	  		ENDIF  
	  		
			oSection4:Cell("TOTREALIZADO"):SetValue(TRANSFORM(nTotRealizado,"@E 999999.99")+"%")    
			
			oSection4:Printline()
			cGrupoAn := cGrupoAt
			TTMPVQ5->(dbSkip())	
			cGrupoAt := TTMPVQ5->GRPPRODUTO   
			nCont += 1
 		EndDo  
		lPrim := .T.		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro  
 		oSection4:Finish()
 		//imprimo uma linha para separar uma NCM de outra 
// 		oReport:ThinLine()    
 		
		oSection5:init()    

		oSection5:Cell("QTDCLICOM"):SetValue("I=Importado / A=Automatico / M=Manual     Vendido Para: " + CVALTOCHAR(_nQtdCom) + " De " + CVALTOCHAR(_nQtdCon) + " Clientes          " + TRANSFORM(nTotQtdE, "@E 999,999,999"))  
		oSection5:Cell("D2_QUANTIDADE"):SetValue(TRANSFORM(nTotQtdR, "@E 999,999,999")) 
		oSection5:Cell("TOTREALIZADO"):SetValue(TRANSFORM((nTotQtdR/nTotQtdE)*100,"@E 999999.99")+"%")
		
		oSection5:Printline()
		oSection5:Finish()                               
		
		nTotQtdE := 0
		nTotQtdR := 0
	
 		//finalizo a primeira seção
		oSection3:Finish()   
	EndDo

Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Do Cliente ?"	  		, "", "", "mv_ch1", "C",6,0,0,"G","", "SA1CLI", "", "", "MV_PAR01")
	putSx1(cPerg, "02", "Até Cliente?"	  		, "", "", "mv_ch2", "C",6,0,0,"G","", "SA1CLI", "", "", "MV_PAR02")   
	putSx1(cPerg, "03", "Data Faturamento De?"	, "", "", "mv_ch5", "D",8,0,0,"G","", "", "", "", "MV_PAR03")   
	putSx1(cPerg, "04", "Data Faturamento Até?"	, "", "", "mv_ch6", "D",8,0,0,"G","", "", "", "", "MV_PAR04")   
	putSx1(cPerg, "05", "Grupo Produto De?"	  	, "", "", "mv_ch7", "C",4,0,0,"G","", "SBM", "", "", "MV_PAR05")   	
	putSx1(cPerg, "06", "Grupo Produto Até?"	, "", "", "mv_ch8", "C",4,0,0,"G","", "SBM", "", "", "MV_PAR06")
	putSx1(cPerg, "07", "Regiao Cliente De?"	, "", "", "mv_ch9", "C",3,0,0,"G","", "Z06", "", "", "MV_PAR07")
	putSx1(cPerg, "08", "Regiao Cliente Até?"	, "", "", "mv_ch10", "C",3,0,0,"G","","Z06", "", "", "MV_PAR08")
	putSx1(cPerg, "09", "Divisao Cliente De?"	, "", "", "mv_ch11", "C",4,0,0,"G","","ACY", "", "", "MV_PAR09")
	putSx1(cPerg, "10", "Divisao Cliente Até?"	, "", "", "mv_ch12", "C",4,0,0,"G","","ACY", "", "", "MV_PAR10")	
return                                                                                                                  

static function validaPrm()
	lRet := .T.
	cMsgErro := "" 
	
	If(Empty(MV_PAR03))
		cMsgErro += "Data Faturamento De? -> Não preenchida" + cEoF		
		lRet :=  .F.
	EndIf                                                  
	If(Empty(MV_PAR04))                            
		cMsgErro += "Data Faturamento Até? -> Não preenchida" + cEoF
		lRet :=  .F.
	EndIf                                                           
	If(MV_PAR04 < MV_PAR03)
		cMsgErro += "Data Faturamento De? -> NÃO PODE SER MENOR QUE o parâmetro -> Data Faturamento Até" + cEoF
		lRet :=  .F.
	EndIf                                                                                      
		   
	If(!lRet)
		MsgInfo(cMsgErro)
	EndIf                
	
return lRet  

Static Function vqGetQry()
Local cRet := ""

/*
cRet := " SELECT * FROM(	"   + CRLF
cRet += " SELECT "+ CRLF
cRet += " (CASE WHEN DOCCLIENTE IS NULL THEN 'SEM META' ELSE DOCCLIENTE END) AS DOCCLIENTE,"+ CRLF  
cRet += " (CASE WHEN MV_DATA IS NULL THEN 'SEM META' ELSE MV_DATA END) AS MV_DATA,"+ CRLF  
cRet += " CODCLIENTE,"+ CRLF
cRet += " NMCLIENTE,"+ CRLF
cRet += "(CASE D2_LOJA IS NULL THEN LJCLIENTE ELSE D2_LOJA END) AS LJCLIENTE,"+ CRLF
cRet += " GRPCLIENTE,"+ CRLF
cRet += " (CASE MV_VENDEDOR IS NULL THEN 'SEM META' ELSE MV_VENDEDOR END) AS MV_VENDEDOR,"+ CRLF //RETIRADO
cRet += " REGCLIENTE,"+ CRLF
cRet += " GRUPOPRODUTO,"+ CRLF
cRet += " DESCGRUPOP,"+ CRLF
cRet += " (CASE MV_PRODUTO IS NULL THEN ' ' ELSE MV_PRODUTO END) AS MV_PRODUTO,"+ CRLF
cRet += " (CASE MV_VQ_GAUT IS NULL THEN ' ' ELSE MV_VQ_GAUT END) AS MV_VQ_GAUT,"+ CRLF
cRet += " (CASE MV_VALOR IS NULL THEN 0 ELSE MV_VALOR END) AS MV_VALOR,"+ CRLF
cRet += " (CASE MV_QUANTIDADE IS NULL THEN 0 ELSE MV_QUANTIDADE END) AS MV_QUANTIDADE,"+ CRLF
cRet += " (CASE CODCLIENTE IS NULL THEN CODCLIENTE ELSE D2_CODCLIENTE END) AS D2_CODCLIENTE,"+ CRLF
cRet += " (CASE D2_LOJA IS NULL THEN LJCLIENTE ELSE D2_LOJA END) AS D2_LOJA,"+ CRLF
cRet += " (CASE A1_NOMCLI IS NULL THEN NMCLIENTE ELSE A1_NOMCLI END) AS A1_NOMECLI,"+ CRLF
cRet += " (CASE A1_REGCLI IS NULL THEN REGCLIENTE ELSE A1_REGCLI END) AS A1_REGCLI,"+ CRLF
cRet += " (CASE A1_GRPCLI IS NULL THEN GRPCLIENTE ELSE A1_GRPCLI END) AS A1_GRPCLI,"+ CRLF
cRet += " (CASE D2_UNIDADEMEDIDA IS NULL THEN 'KG' ELSE D2_UNIDADEMEDIDA END) AS D2_UNIDADEMEDIDA,"+ CRLF
cRet += " (CASE D2_QUANTIDADE IS NULL THEN 0 ELSE D2_QUANTIDADE END) AS D2_QUANTIDADE,"+ CRLF
cRet += " (CASE B1_GRUPOPRODUTO IS NULL THEN GRUPOPRODUTO ELSE B1_GRUPOPRODUTO END) AS B1_GRUPOPRODUTO,"+ CRLF
cRet += " (CASE BM_DESCGRUPO IS NULL THEN DESCGRUPOP ELSE BM_DESCGRUPO END) AS BM_DESCGRUPO "+ CRLF
cRet += " FROM ("+ CRLF
cRet += " SELECT "+ CRLF
cRet += " DOCCLIENTE,"+ CRLF
cRet += " (CASE MV_CODCLIENTE IS NULL THEN D2_CODCLIENTE ELSE MV_CODCLIENTE END) AS CODCLIENTE," + CRLF
cRet += " (CASE MV_NMCLIENTE IS NULL THEN A1_NOMECLI ELSE MV_NMCLIENTE END) AS NMCLIENTE,"+ CRLF
cRet += " (CASE MV_LOJA IS NULL THEN D2_LOJA ELSE MV_LOJA END) AS LJCLIENTE,"+ CRLF
cRet += " (CASE MV_GRUPO IS NULL THEN A1_GRPCLI ELSE MV_GRUPO END) AS GRPCLIENTE,MV_VENDEDOR,"+ CRLF
cRet += " (CASE MV_REGIAO IS NULL THEN A1_REGCLI ELSE MV_REGIAO END) AS REGCLIENTE,"+ CRLF
cRet += " (CASE MV_GRUPOP IS NULL THEN B1_GRUPOPRODUTO ELSE MV_GRUPOP END) AS GRUPOPRODUTO,"+ CRLF
cRet += " (CASE MV_DESCGRUPO IS NULL THEN B1_GRUPOPRODUTO ELSE MV_DESCGRUPO END) AS DESCGRUPOP,"+ CRLF
cRet += " MV_PRODUTO,"+ CRLF
cRet += " MV_VQ_GAUT,"+ CRLF
cRet += " MV_VALOR,"+ CRLF
cRet += " MV_QUANTIDADE,"+ CRLF
cRet += " D2_CODCLIENTE,"+ CRLF
cRet += " D2_LOJA,"+ CRLF
cRet += " A1_NOMECLI,"+ CRLF
cRet += " A1_REGCLI,"+ CRLF
cRet += " A1_GRPCLI,"+ CRLF
cRet += " D2_UNIDADEMEDIDA,"+ CRLF
cRet += " SUM(D2_QUANTIDADE) AS D2_QUANTIDADE,"+ CRLF
cRet += " B1_GRUPOPRODUTO,"+ CRLF
cRet += " BM_DESCGRUPO ,"+ CRLF
cRet += " MV_DATA"+ CRLF
cRet += " FROM("+ CRLF
cRet += " SELECT"+ CRLF
cRet += " * "+ CRLF
cRet += "  	FROM("+ CRLF
cRet += "  		SELECT"  + CRLF
cRet += "  		DOCCLIENTE,"+ CRLF
cRet += " 					MV_CODCLIENTE,"+ CRLF
cRet += " 					MV_CLIENTE,"+ CRLF
cRet += " 					MV_NMCLIENTE,"+ CRLF
cRet += " 					MV_LOJA,"+ CRLF
cRet += " 					MV_GRUPO,"+ CRLF
cRet += " 					MV_VENDEDOR,"+ CRLF
cRet += " 					MV_REGIAO,"+ CRLF
cRet += " 					MV_GRUPOP,"+ CRLF
cRet += " 					MV_DESCGRUPO,"+ CRLF
cRet += " 					MV_PRODUTO,"+ CRLF
cRet += " 					MV_VQ_GAUT,"+ CRLF
cRet += " 					MV_QUANTIDADE,"+ CRLF
cRet += " 					MV_VALOR,"+ CRLF
cRet += " 					CT_DESCRI,"+ CRLF
cRet += " 					MV_DATA,"+ CRLF
cRet += " 					D2_CODCLIENTE,"+ CRLF
cRet += " 					D2_LOJA,"+ CRLF
cRet += " 					A1_NOMECLI,"+ CRLF
cRet += " 					A1_REGCLI,"+ CRLF
cRet += " 					A1_GRPCLI,"+ CRLF
cRet += " 					D2_UNIDADEMEDIDA,"+ CRLF
cRet += " 					D2_QUANTIDADE,"+ CRLF
cRet += " 					D2_PRECOVENDA,"+ CRLF
cRet += " 					D2_TOTALVENDA,"+ CRLF
cRet += " 					D2_DTEMISSAO,"+ CRLF
cRet += " 					B1_GRUPOPRODUTO,"+ CRLF
cRet += " 					BM_DESCGRUPO "+ CRLF
cRet += " 					FROM"+ CRLF
cRet += " 						("+ CRLF
cRet += " 							SELECT" + CRLF
cRet += " 							D2_CLIENTE AS D2_CODCLIENTE,"	+ CRLF
cRet += " 							D2_LOJA AS D2_LOJA," 			+ CRLF
cRet += " 							A1_NREDUZ AS A1_NOMECLI,"			+ CRLF
cRet += " 							A1_REGIAO AS A1_REGCLI,"		+ CRLF
cRet += " 							A1_GRPVEN AS A1_GRPCLI,"		+ CRLF
cRet += " 							D2_UM AS D2_UNIDADEMEDIDA,"		+ CRLF
cRet += " 							SUM(D2_QUANT)AS D2_QUANTIDADE,"	+ CRLF
cRet += " 							SUM(D2_PRCVEN) AS D2_PRECOVENDA,"	+ CRLF
cRet += " 							SUM(D2_TOTAL)AS D2_TOTALVENDA,"		+ CRLF
cRet += " 							D2_EMISSAO AS D2_DTEMISSAO,"		+ CRLF
cRet += " 							B1_GRUPO AS B1_GRUPOPRODUTO,"		+ CRLF
cRet += " 							BM_DESC AS BM_DESCGRUPO" 		+ CRLF
cRet += " 							FROM SD2010 SD2" 				+ CRLF
cRet += " 								INNER JOIN SF2010 SF2 ON (SF2.D_E_L_E_T_ <> '*' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE)" + CRLF
cRet += " 								INNER JOIN SF4010 SF4 ON (SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = '01' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S')" + CRLF
cRet += " 								INNER JOIN SB1010 SB1 ON (SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SD2.D2_COD)" + CRLF
cRet += " 								INNER JOIN SA1010 SA1 ON (SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA)" + CRLF
cRet += " 								INNER JOIN SBM010 SBM ON (SBM.BM_GRUPO = SB1.B1_GRUPO)" + CRLF
cRet += " 							WHERE" + CRLF
cRet += " 								SD2.D_E_L_E_T_ <> '*'" + CRLF
cRet += " 								AND SF2.F2_TIPO IN ('N','C')" + CRLF
cRet += " 								AND SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"  + CRLF      
If !_lAllCli  
	cRet += " 								AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
EndIf
cRet += " 							GROUP BY D2_CLIENTE,D2_LOJA,A1_NREDUZ,A1_REGIAO,A1_GRPVEN,D2_UM,D2_EMISSAO,B1_GRUPO,BM_DESC"+ CRLF
cRet += " 							) VENDASSD2" + CRLF
cRet += " 							LEFT JOIN ("+ CRLF
cRet += " 								SELECT"+ CRLF
cRet += " 									CT_DOC AS DOCCLIENTE,"+ CRLF
cRet += " 									CT_CLIENTE AS MV_CODCLIENTE,"+ CRLF
cRet += " 									CT_NOMCLI AS MV_CLIENTE,"+ CRLF
cRet += " 									A1_NREDUZ AS MV_NMCLIENTE,"+ CRLF
cRet += " 									CT_LOJA AS MV_LOJA,"+ CRLF
cRet += " 									A1_GRPVEN AS MV_GRUPO,"+ CRLF
cRet += " 									CT_VEND AS MV_VENDEDOR,"+ CRLF
cRet += " 									A1_REGIAO AS MV_REGIAO,"+ CRLF
cRet += " 									CT_GRUPO AS MV_GRUPOP,"+ CRLF
cRet += " 									BM_DESC AS MV_DESCGRUPO,"+ CRLF
cRet += " 									CT_PRODUTO AS MV_PRODUTO,"+ CRLF
cRet += " 									CT_VQ_GAUT AS MV_VQ_GAUT,"+ CRLF
cRet += " 									MAX(CT_DATA)AS MV_DATA,"+ CRLF
cRet += " 									SUM(CT_QUANT) AS MV_QUANTIDADE,"+ CRLF
cRet += " 									SUM(CT_VALOR) AS MV_VALOR,"+ CRLF
cRet += " 									CT_DESCRI" + CRLF
cRet += " 								FROM SCT010 SCT" + CRLF
cRet += " 									INNER JOIN SA1010 SA1 on (SCT.CT_CLIENTE = SA1.A1_COD AND SCT.CT_LOJA = SA1.A1_LOJA)"+ CRLF
cRet += " 									LEFT JOIN SBM010 SBM ON (SCT.CT_GRUPO = SBM.BM_GRUPO)" + CRLF
cRet += " 									WHERE"   + CRLF
cRet += " 										1=1" + CRLF
cRet += " 										AND SCT.D_E_L_E_T_ <> '*'" + CRLF
cRet += " 										AND CT_DESCRI NOT IN ('SISTEMA ANTIGO ** NAO MEXER **          ')" + CRLF
If !_lAllCli  
		cRet += " 								AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
EndIf
cRet += " 									GROUP BY CT_DOC, CT_CLIENTE,CT_NOMCLI,A1_NREDUZ,CT_LOJA,A1_GRPVEN,CT_VEND,A1_REGIAO,CT_GRUPO,BM_DESC,CT_PRODUTO,CT_DESCRI,CT_VQ_GAUT"+ CRLF
cRet += " 								) VENDASSCT" + CRLF
cRet += " 									ON (VENDASSCT.MV_GRUPOP = VENDASSD2.B1_GRUPOPRODUTO AND VENDASSCT.MV_CODCLIENTE = VENDASSD2.D2_CODCLIENTE AND VENDASSCT.MV_LOJA = VENDASSD2.D2_LOJA)" + CRLF
cRet += " 							UNION ALL" + CRLF
cRet += " SELECT" + CRLF
cRet += "   DOCCLIENTE," + CRLF
cRet += "  	MV_CODCLIENTE," + CRLF
cRet += "  	MV_CLIENTE," + CRLF
cRet += "  	MV_NMCLIENTE," + CRLF
cRet += "  	MV_LOJA," + CRLF
cRet += "  	MV_GRUPO," + CRLF
cRet += "  	MV_VENDEDOR," + CRLF
cRet += "  	MV_REGIAO," + CRLF
cRet += "  	MV_GRUPOP," + CRLF
cRet += "  	MV_DESCGRUPO," + CRLF
cRet += "  	MV_PRODUTO," + CRLF
cRet += "  	MV_VQ_GAUT," + CRLF
cRet += "  	MV_QUANTIDADE," + CRLF
cRet += "  	MV_VALOR," + CRLF
cRet += "  	CT_DESCRI," + CRLF
cRet += "  	MV_DATA," + CRLF
cRet += "  	D2_CODCLIENTE," + CRLF
cRet += "  	D2_LOJA," + CRLF
cRet += "  	A1_NOMECLI," + CRLF
cRet += "  	A1_REGCLI," + CRLF
cRet += "  	A1_GRPCLI," + CRLF
cRet += "  	D2_UNIDADEMEDIDA," + CRLF
cRet += "  	D2_QUANTIDADE," + CRLF
cRet += "  	D2_PRECOVENDA," + CRLF
cRet += "  	D2_TOTALVENDA," + CRLF
cRet += "  	D2_DTEMISSAO," + CRLF
cRet += "  	B1_GRUPOPRODUTO," + CRLF
cRet += "  	BM_DESCGRUPO" + CRLF
cRet += " 	FROM ("+ CRLF
cRet += " 		SELECT"+ CRLF
cRet += " 			CT_DOC AS DOCCLIENTE,"+ CRLF
cRet += " 			CT_CLIENTE AS MV_CODCLIENTE,"+ CRLF
cRet += " 			CT_NOMCLI AS MV_CLIENTE,"+ CRLF
cRet += " 			A1_NREDUZ  AS MV_NMCLIENTE,"+ CRLF
cRet += " 			CT_LOJA AS MV_LOJA,"+ CRLF
cRet += " 			A1_GRPVEN AS MV_GRUPO,"+ CRLF
cRet += " 			CT_VEND AS MV_VENDEDOR,"+ CRLF
cRet += " 			A1_REGIAO AS MV_REGIAO,"+ CRLF
cRet += " 			CT_GRUPO AS MV_GRUPOP,"+ CRLF
cRet += " 			BM_DESC AS MV_DESCGRUPO,"+ CRLF
cRet += " 			CT_PRODUTO AS MV_PRODUTO,"+ CRLF
cRet += " 			CT_VQ_GAUT AS MV_VQ_GAUT,"+ CRLF
cRet += " 			MAX(CT_DATA)AS MV_DATA,"+ CRLF
cRet += " 			SUM(CT_QUANT)AS MV_QUANTIDADE,"+ CRLF
cRet += " 			SUM(CT_VALOR)AS MV_VALOR,"+ CRLF
cRet += " 			CT_DESCRI" + CRLF
cRet += " 		FROM SCT010 SCT" + CRLF
cRet += " 			INNER JOIN SA1010 SA1 on (SCT.CT_CLIENTE = SA1.A1_COD AND SCT.CT_LOJA = SA1.A1_LOJA)" + CRLF
cRet += " 			INNER JOIN SBM010 SBM ON (SCT.CT_GRUPO = SBM.BM_GRUPO) "+ CRLF
cRet += " 		WHERE   1=1" + CRLF
cRet += " 			AND SCT.D_E_L_E_T_ <> '*'" + CRLF
cRet += " 			AND CT_DESCRI NOT IN ('SISTEMA ANTIGO ** NAO MEXER **          ')" + CRLF   
If !_lAllCli  
	cRet += " 		AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
EndIf
cRet += " 		GROUP BY CT_DOC,CT_CLIENTE,CT_NOMCLI,A1_NREDUZ,CT_LOJA,A1_GRPVEN,CT_VEND,A1_REGIAO,CT_GRUPO,BM_DESC,CT_PRODUTO,CT_DESCRI,CT_VQ_GAUT"+ CRLF
cRet += " 	) VENDASSCT" + CRLF
cRet += " 		LEFT JOIN ("+ CRLF
cRet += " 			SELECT D2_CLIENTE AS D2_CODCLIENTE,"+ CRLF
cRet += " 				D2_LOJA AS D2_LOJA,"+ CRLF
cRet += " 				A1_NREDUZ AS A1_NOMECLI,"+ CRLF
cRet += " 				A1_REGIAO AS A1_REGCLI,"+ CRLF
cRet += " 				A1_GRPVEN AS A1_GRPCLI,"+ CRLF
cRet += " 				D2_UM AS D2_UNIDADEMEDIDA,"+ CRLF
cRet += " 				NULL AS D2_QUANTIDADE,"+ CRLF
cRet += " 				SUM(D2_PRCVEN)AS D2_PRECOVENDA,"+ CRLF
cRet += " 				SUM(D2_TOTAL)AS D2_TOTALVENDA,"+ CRLF
cRet += " 				D2_EMISSAO AS D2_DTEMISSAO,"+ CRLF
cRet += " 				B1_GRUPO AS B1_GRUPOPRODUTO,"+ CRLF
cRet += " 				BM_DESC AS BM_DESCGRUPO" + CRLF
cRet += " 			FROM SD2010 SD2" + CRLF
cRet += " 				INNER JOIN SF2010 SF2 ON (SF2.D_E_L_E_T_ <> '*' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE)" + CRLF
cRet += " 				INNER JOIN SF4010 SF4 ON (SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = '01' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S')" + CRLF
cRet += " 				INNER JOIN SB1010 SB1 ON (SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SD2.D2_COD) "+ CRLF
cRet += " 				INNER JOIN SA1010 SA1 ON (SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA)" + CRLF
cRet += " 				INNER JOIN SBM010 SBM ON (SBM.BM_GRUPO = SB1.B1_GRUPO)" + CRLF
cRet += " 					WHERE  1=1" + CRLF
cRet += " 						AND SD2.D_E_L_E_T_ <> '*'" + CRLF
cRet += " 						AND SF2.F2_TIPO IN ('N','C')" + CRLF
If !_lAllCli  
	cRet += " 								AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
EndIf
cRet += " 						GROUP BY D2_CLIENTE,D2_LOJA,A1_NREDUZ,A1_REGIAO,A1_GRPVEN,D2_UM,D2_EMISSAO,B1_GRUPO,BM_DESC"+ CRLF
cRet += " 			) VENDASSD2 "+ CRLF
cRet += " 				ON (VENDASSCT.MV_GRUPOP = VENDASSD2.B1_GRUPOPRODUTO AND VENDASSCT.MV_CODCLIENTE = VENDASSD2.D2_CODCLIENTE AND VENDASSCT.MV_LOJA = VENDASSD2.D2_LOJA) )"       						 				 	                                        + CRLF
cRet += " 				GROUP BY"+ CRLF
cRet += " 					DOCCLIENTE,"+ CRLF  
cRet += " 					MV_DATA,"+ CRLF  
cRet += " 					MV_CODCLIENTE,"+ CRLF
cRet += " 					MV_CLIENTE,"+ CRLF
cRet += " 					MV_NMCLIENTE,"+ CRLF
cRet += " 					MV_LOJA,"+ CRLF
cRet += " 					MV_GRUPO,"+ CRLF
cRet += " 					MV_VENDEDOR,"+ CRLF
cRet += " 					MV_REGIAO,"+ CRLF
cRet += " 					MV_GRUPOP,"+ CRLF
cRet += " 					MV_DESCGRUPO,"+ CRLF
cRet += " 					MV_PRODUTO,"+ CRLF
cRet += " 					MV_VQ_GAUT,"+ CRLF
cRet += " 					MV_QUANTIDADE,"+ CRLF
cRet += " 					MV_VALOR,"+ CRLF
cRet += " 					CT_DESCRI,"+ CRLF
cRet += " 					MV_DATA,"+ CRLF
cRet += " 					D2_CODCLIENTE,"+ CRLF
cRet += " 					D2_LOJA,"+ CRLF
cRet += " 					A1_NOMECLI,"+ CRLF
cRet += " 					A1_REGCLI,"+ CRLF
cRet += " 					A1_GRPCLI,"+ CRLF
cRet += " 					D2_UNIDADEMEDIDA,"+ CRLF
cRet += " 					D2_QUANTIDADE,"+ CRLF
cRet += " 					D2_PRECOVENDA,"+ CRLF
cRet += " 					D2_TOTALVENDA,"+ CRLF
cRet += " 					D2_DTEMISSAO,"+ CRLF
cRet += " 					B1_GRUPOPRODUTO,"+ CRLF
cRet += " 					BM_DESCGRUPO "+ CRLF                    
cRet += " 				ORDER BY MV_GRUPOP,MV_CLIENTE"+ CRLF          
cRet += " 				) " + CRLF
cRet += " 	GROUP BY "+ CRLF
cRet += " 		DOCCLIENTE,"+ CRLF 
cRet += " 		MV_DATA,"+ CRLF  
cRet += " 		(CASE MV_CODCLIENTE IS NULL THEN D2_CODCLIENTE ELSE MV_CODCLIENTE END),"+ CRLF
cRet += " 		(CASE MV_NMCLIENTE IS NULL THEN A1_NOMECLI ELSE MV_NMCLIENTE END),"+ CRLF
cRet += " 		(CASE MV_LOJA IS NULL THEN D2_LOJA ELSE MV_LOJA END),"+ CRLF
cRet += " 		MV_GRUPO,"+ CRLF
cRet += " 		MV_VENDEDOR,"+ CRLF
cRet += " 		MV_REGIAO,"+ CRLF
cRet += " 		(CASE MV_GRUPOP IS NULL THEN B1_GRUPOPRODUTO ELSE MV_GRUPOP END),"+ CRLF
cRet += " 		(CASE MV_DESCGRUPO IS NULL THEN BM_DESCGRUPO ELSE MV_DESCGRUPO END),"+ CRLF
cRet += " 		MV_PRODUTO,"+ CRLF
cRet += " 		MV_VQ_GAUT,"+ CRLF
cRet += " 		MV_VALOR,"+ CRLF
cRet += " 		MV_QUANTIDADE,"+ CRLF
cRet += " 		D2_CODCLIENTE,"+ CRLF
cRet += " 		D2_LOJA,"+ CRLF
cRet += " 		A1_NOMECLI,"+ CRLF
cRet += " 		A1_REGCLI,"+ CRLF
cRet += " 		A1_GRPCLI,"+ CRLF
cRet += " 		D2_UNIDADEMEDIDA,"+ CRLF
cRet += " 	    B1_GRUPOPRODUTO,"+ CRLF
cRet += " 		BM_DESCGRUPO,"+ CRLF
cRet += " 		MV_DATA"+ CRLF
cRet += " 	ORDER BY GRUPOPRODUTO,CODCLIENTE) " + CRLF
cRet += " 	WHERE 1=1 "+ CRLF
cRet += IIF(!Empty(cCodCli),AllTrim(cCodCli)," ")   + CRLF
cRet += IIF(!Empty(cGrupoP),AllTrim(cGrupoP), " ") + CRLF
cRet += IIF(!Empty(cRegCli),AllTrim(cRegCli), " ") + CRLF
cRet += IIF(!Empty(cGrpCli),AllTrim(cGrpCli)," ") + CRLF 
cRet += " ) GROUP BY " + CRLF 
cRet += "  DOCCLIENTE," + CRLF 
cRet += "  MV_DATA ," + CRLF 
cRet += "  CODCLIENTE," + CRLF 
cRet += "  NMCLIENTE," + CRLF                                            
cRet += "  MV_VENDEDOR," + CRLF 
cRet += "  D2_LOJA," + CRLF 
cRet += "  GRPCLIENTE," + CRLF 
cRet += "  REGCLIENTE," + CRLF 
cRet += "  GRUPOPRODUTO," + CRLF 
cRet += "  DESCGRUPOP," + CRLF 
cRet += "  MV_PRODUTO," + CRLF 
cRet += "  MV_VQ_GAUT," + CRLF 
cRet += "  MV_VALOR," + CRLF 
cRet += "  MV_QUANTIDADE," + CRLF 
cRet += "  D2_CODCLIENTE," + CRLF 
cRet += "  D2_LOJA," + CRLF 
cRet += "  A1_NOMECLI," + CRLF 
cRet += "  A1_REGCLI," + CRLF 
cRet += "  A1_GRPCLI," + CRLF 
cRet += "  D2_UNIDADEMEDIDA," + CRLF 
cRet += "  D2_QUANTIDADE," + CRLF 
cRet += "  B1_GRUPOPRODUTO," + CRLF 
cRet += " BM_DESCGRUPO  " + CRLF 
cRet += " ORDER BY GRUPOPRODUTO,CODCLIENTE " + CRLF 
*/
 //----> NOVA QUERY
 cRet += " SELECT * FROM(	 " + CRLF 
 cRet += " SELECT  " + CRLF 
 cRet += " (CASE WHEN DOCCLIENTE IS NULL THEN 'SEM META' ELSE DOCCLIENTE END) AS DOCCLIENTE, " + CRLF 
 cRet += " (CASE WHEN MV_DATA IS NULL THEN 'SEM META' ELSE MV_DATA END) AS MV_DATA, " + CRLF 
 cRet += " CODCLIENTE, " + CRLF 
 cRet += "  NMCLIENTE, " + CRLF 
 cRet += " (CASE WHEN D2_LOJA IS NULL THEN LJCLIENTE ELSE D2_LOJA END) AS LJCLIENTE, " + CRLF 
 cRet += " GRPCLIENTE, " + CRLF 
 cRet += " (CASE WHEN MV_VENDEDOR IS NULL THEN 'SEM META' ELSE MV_VENDEDOR END) AS MV_VENDEDOR, " + CRLF 
 cRet += " REGCLIENTE, " + CRLF 
 cRet += " GRUPOPRODUTO, " + CRLF 
 cRet += " DESCGRUPOP, " + CRLF 
 cRet += " (CASE WHEN MV_PRODUTO IS NULL THEN ' ' ELSE MV_PRODUTO END) AS MV_PRODUTO, " + CRLF 
 cRet += " (CASE WHEN MV_VQ_GAUT IS NULL THEN ' ' ELSE MV_VQ_GAUT END) AS MV_VQ_GAUT, " + CRLF 
 cRet += " (CASE WHEN MV_VALOR IS NULL THEN 0 ELSE MV_VALOR END) AS MV_VALOR, " + CRLF 
 cRet += " (CASE WHEN MV_QUANTIDADE IS NULL THEN 0 ELSE MV_QUANTIDADE END) AS MV_QUANTIDADE, " + CRLF 
 cRet += " (CASE WHEN CODCLIENTE IS NULL THEN CODCLIENTE ELSE D2_CODCLIENTE END) AS D2_CODCLIENTE, " + CRLF 
 cRet += " (CASE WHEN D2_LOJA IS NULL THEN LJCLIENTE ELSE D2_LOJA END) AS D2_LOJA, " + CRLF 
 cRet += " (CASE WHEN A1_NOMECLI IS NULL THEN NMCLIENTE ELSE A1_NOMECLI END) AS A1_NOMECLI, " + CRLF 
 cRet += " (CASE WHEN A1_REGCLI IS NULL THEN REGCLIENTE ELSE A1_REGCLI END) AS A1_REGCLI, " + CRLF 
 cRet += " (CASE WHEN A1_GRPCLI IS NULL THEN GRPCLIENTE ELSE A1_GRPCLI END) AS A1_GRPCLI, " + CRLF 
 cRet += " (CASE WHEN D2_UNIDADEMEDIDA IS NULL THEN 'KG' ELSE D2_UNIDADEMEDIDA END) AS D2_UNIDADEMEDIDA, " + CRLF 
 cRet += " (CASE WHEN D2_QUANTIDADE IS NULL THEN 0 ELSE D2_QUANTIDADE END) AS D2_QUANTIDADE, " + CRLF 
 cRet += " (CASE WHEN B1_GRUPOPRODUTO IS NULL THEN GRUPOPRODUTO ELSE B1_GRUPOPRODUTO END) AS B1_GRUPOPRODUTO, " + CRLF 
 cRet += " (CASE WHEN BM_DESCGRUPO IS NULL THEN DESCGRUPOP ELSE BM_DESCGRUPO END) AS BM_DESCGRUPO  " + CRLF 
 cRet += " FROM ( " + CRLF 
 cRet += " SELECT  " + CRLF 
 cRet += " DOCCLIENTE, " + CRLF 
 cRet += " (CASE WHEN MV_CODCLIENTE IS NULL THEN D2_CODCLIENTE ELSE MV_CODCLIENTE END) AS CODCLIENTE, " + CRLF 
 cRet += " (CASE WHEN MV_NMCLIENTE IS NULL THEN A1_NOMECLI ELSE MV_NMCLIENTE END) AS NMCLIENTE, " + CRLF 
 cRet += " (CASE WHEN MV_LOJA IS NULL THEN D2_LOJA ELSE MV_LOJA END) AS LJCLIENTE, " + CRLF 
 cRet += " (CASE WHEN MV_GRUPO IS NULL THEN A1_GRPCLI ELSE MV_GRUPO END) AS GRPCLIENTE,MV_VENDEDOR, " + CRLF 
 cRet += " (CASE WHEN MV_REGIAO IS NULL THEN A1_REGCLI ELSE MV_REGIAO END) AS REGCLIENTE, " + CRLF 
 cRet += " (CASE WHEN MV_GRUPOP IS NULL THEN B1_GRUPOPRODUTO ELSE MV_GRUPOP END) AS GRUPOPRODUTO, " + CRLF 
 cRet += " (CASE WHEN MV_DESCGRUPO IS NULL THEN B1_GRUPOPRODUTO ELSE MV_DESCGRUPO END) AS DESCGRUPOP, " + CRLF 
 cRet += " MV_PRODUTO, " + CRLF 
 cRet += " MV_VQ_GAUT, " + CRLF 
 cRet += " MV_VALOR, " + CRLF 
 cRet += " MV_QUANTIDADE, " + CRLF 
 cRet += " D2_CODCLIENTE, " + CRLF 
 cRet += " D2_LOJA, " + CRLF 
 cRet += " A1_NOMECLI, " + CRLF 
 cRet += " A1_REGCLI, " + CRLF 
 cRet += " A1_GRPCLI, " + CRLF 
 cRet += " D2_UNIDADEMEDIDA, " + CRLF 
 cRet += " SUM(D2_QUANTIDADE) AS D2_QUANTIDADE, " + CRLF 
 cRet += " B1_GRUPOPRODUTO, " + CRLF 
 cRet += " BM_DESCGRUPO , " + CRLF 
 cRet += " MV_DATA " + CRLF 
 cRet += " FROM( " + CRLF 
 cRet += " SELECT " + CRLF 
 cRet += " *  " + CRLF 
  	cRet += " FROM( " + CRLF 
  		cRet += " SELECT " + CRLF 
  		cRet += " DOCCLIENTE, " + CRLF 
 					cRet += " MV_CODCLIENTE, " + CRLF 
 					cRet += " MV_CLIENTE, " + CRLF 
 					cRet += " MV_NMCLIENTE, " + CRLF 
 					cRet += " MV_LOJA, " + CRLF 
 					cRet += " MV_GRUPO, " + CRLF 
 					cRet += " MV_VENDEDOR, " + CRLF 
 					cRet += " MV_REGIAO, " + CRLF 
 					cRet += " MV_GRUPOP, " + CRLF 
 					cRet += " MV_DESCGRUPO, " + CRLF 
 					cRet += " MV_PRODUTO, " + CRLF 
 					cRet += " MV_VQ_GAUT, " + CRLF 
 					cRet += " MV_QUANTIDADE, " + CRLF 
 					cRet += " MV_VALOR, " + CRLF 
 					cRet += " CT_DESCRI, " + CRLF 
 					cRet += " MV_DATA, " + CRLF 
 					cRet += " D2_CODCLIENTE, " + CRLF 
 					cRet += " D2_LOJA, " + CRLF 
 					cRet += " A1_NOMECLI, " + CRLF 
 					cRet += " A1_REGCLI, " + CRLF 
 					cRet += " A1_GRPCLI, " + CRLF 
 					cRet += " D2_UNIDADEMEDIDA, " + CRLF 
 					cRet += " D2_QUANTIDADE, " + CRLF 
 					cRet += " D2_PRECOVENDA, " + CRLF 
 					cRet += " D2_TOTALVENDA, " + CRLF 
 					cRet += " D2_DTEMISSAO, " + CRLF 
 					cRet += " B1_GRUPOPRODUTO, " + CRLF 
 					cRet += " BM_DESCGRUPO  " + CRLF 
 					cRet += " FROM " + CRLF 
 						cRet += " ( " + CRLF 
 							cRet += " SELECT " + CRLF 
 							cRet += " D2_CLIENTE AS D2_CODCLIENTE, " + CRLF 
 							cRet += " D2_LOJA AS D2_LOJA, " + CRLF 
 							cRet += " A1_NREDUZ AS A1_NOMECLI, " + CRLF 
 							cRet += " A1_REGIAO AS A1_REGCLI, " + CRLF 
 							cRet += " A1_GRPVEN AS A1_GRPCLI, " + CRLF 
 							cRet += " D2_UM AS D2_UNIDADEMEDIDA, " + CRLF 
 							cRet += " SUM(D2_QUANT)AS D2_QUANTIDADE, " + CRLF 
 							cRet += " SUM(D2_PRCVEN) AS D2_PRECOVENDA, " + CRLF 
 							cRet += " SUM(D2_TOTAL)AS D2_TOTALVENDA, " + CRLF 
 							cRet += " D2_EMISSAO AS D2_DTEMISSAO, " + CRLF 
 							cRet += " B1_GRUPO AS B1_GRUPOPRODUTO, " + CRLF 
 							cRet += " BM_DESC AS BM_DESCGRUPO " + CRLF 
 							cRet += " FROM SD2010 SD2 " + CRLF 
 								cRet += " INNER JOIN SF2010 SF2 ON (SF2.D_E_L_E_T_ <> '*' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE) " + CRLF 
 								cRet += " INNER JOIN SF4010 SF4 ON (SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = '01' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S') " + CRLF 
 								cRet += " INNER JOIN SB1010 SB1 ON (SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SD2.D2_COD) " + CRLF 
 								cRet += " INNER JOIN SA1010 SA1 ON (SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA) " + CRLF 
 								cRet += " INNER JOIN SBM010 SBM ON (SBM.BM_GRUPO = SB1.B1_GRUPO) " + CRLF 
 							cRet += " WHERE " + CRLF 
 								cRet += " SD2.D_E_L_E_T_ <> '*' " + CRLF 
 								cRet += " AND SF2.F2_TIPO IN ('N','C') " + CRLF 
 								cRet += " AND SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + CRLF 
								If !_lAllCli  
									cRet += " 								AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
								EndIf

 							cRet += " GROUP BY D2_CLIENTE,D2_LOJA,A1_NREDUZ,A1_REGIAO,A1_GRPVEN,D2_UM,D2_EMISSAO,B1_GRUPO,BM_DESC " + CRLF 
 							cRet += " ) VENDASSD2 " + CRLF 
 							cRet += " LEFT JOIN ( " + CRLF 
 								cRet += " SELECT " + CRLF 
 									cRet += " CT_DOC AS DOCCLIENTE, " + CRLF 
 									cRet += " CT_CLIENTE AS MV_CODCLIENTE, " + CRLF 
 									cRet += " CT_NOMCLI AS MV_CLIENTE, " + CRLF 
 									cRet += " A1_NREDUZ AS MV_NMCLIENTE, " + CRLF 
 									cRet += " CT_LOJA AS MV_LOJA, " + CRLF 
 									cRet += " A1_GRPVEN AS MV_GRUPO, " + CRLF 
 									cRet += " CT_VEND AS MV_VENDEDOR, " + CRLF 
 									cRet += " A1_REGIAO AS MV_REGIAO, " + CRLF 
 									cRet += " CT_GRUPO AS MV_GRUPOP, " + CRLF 
 									cRet += " BM_DESC AS MV_DESCGRUPO, " + CRLF 
 									cRet += " CT_PRODUTO AS MV_PRODUTO, " + CRLF 
 									cRet += " CT_VQ_GAUT AS MV_VQ_GAUT, " + CRLF 
 									cRet += " MAX(CT_DATA)AS MV_DATA, " + CRLF 
 									cRet += " SUM(CT_QUANT) AS MV_QUANTIDADE, " + CRLF 
 									cRet += " SUM(CT_VALOR) AS MV_VALOR, " + CRLF 
 									cRet += " CT_DESCRI " + CRLF 
 								cRet += " FROM SCT010 SCT " + CRLF 
 									cRet += " INNER JOIN SA1010 SA1 on (SCT.CT_CLIENTE = SA1.A1_COD AND SCT.CT_LOJA = SA1.A1_LOJA) " + CRLF 
 									cRet += " LEFT JOIN SBM010 SBM ON (SCT.CT_GRUPO = SBM.BM_GRUPO) " + CRLF 
 									cRet += " WHERE " + CRLF 
 										cRet += " 1=1 " + CRLF 
 										cRet += " AND SCT.D_E_L_E_T_ <> '*' " + CRLF 
 										cRet += " AND CT_DESCRI NOT IN ('SISTEMA ANTIGO ** NAO MEXER **          ') " + CRLF 
										If !_lAllCli  
												cRet += " 								AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
										EndIf
 									cRet += " GROUP BY CT_DOC, CT_CLIENTE,CT_NOMCLI,A1_NREDUZ,CT_LOJA,A1_GRPVEN,CT_VEND,A1_REGIAO,CT_GRUPO,BM_DESC,CT_PRODUTO,CT_DESCRI,CT_VQ_GAUT " + CRLF 
 								cRet += " ) VENDASSCT " + CRLF 
 									cRet += " ON (VENDASSCT.MV_GRUPOP = VENDASSD2.B1_GRUPOPRODUTO AND VENDASSCT.MV_CODCLIENTE = VENDASSD2.D2_CODCLIENTE AND VENDASSCT.MV_LOJA = VENDASSD2.D2_LOJA) " + CRLF 
 							cRet += " UNION ALL " + CRLF 
 cRet += " SELECT " + CRLF 
   cRet += " DOCCLIENTE, " + CRLF 
  	cRet += " MV_CODCLIENTE, " + CRLF 
  	cRet += " MV_CLIENTE, " + CRLF 
  	cRet += " MV_NMCLIENTE, " + CRLF 
  	cRet += " MV_LOJA, " + CRLF 
  	cRet += " MV_GRUPO, " + CRLF 
  	cRet += " MV_VENDEDOR, " + CRLF 
  	cRet += " MV_REGIAO, " + CRLF 
  	cRet += " MV_GRUPOP, " + CRLF 
  	cRet += " MV_DESCGRUPO, " + CRLF 
  	cRet += " MV_PRODUTO, " + CRLF 
  	cRet += " MV_VQ_GAUT, " + CRLF 
  	cRet += " MV_QUANTIDADE, " + CRLF 
  	cRet += " MV_VALOR, " + CRLF 
  	cRet += " CT_DESCRI, " + CRLF 
  	cRet += " MV_DATA, " + CRLF 
  	cRet += " D2_CODCLIENTE, " + CRLF 
  	cRet += " D2_LOJA, " + CRLF 
  	cRet += " A1_NOMECLI, " + CRLF 
  	cRet += " A1_REGCLI, " + CRLF 
  	cRet += " A1_GRPCLI, " + CRLF 
  	cRet += " D2_UNIDADEMEDIDA, " + CRLF 
  	cRet += " D2_QUANTIDADE, " + CRLF 
  	cRet += " D2_PRECOVENDA, " + CRLF 
  	cRet += " D2_TOTALVENDA, " + CRLF 
  	cRet += " D2_DTEMISSAO, " + CRLF 
  	cRet += " B1_GRUPOPRODUTO, " + CRLF 
  	cRet += " BM_DESCGRUPO " + CRLF 
 	cRet += " FROM ( " + CRLF 
 		cRet += " SELECT " + CRLF 
 			cRet += " CT_DOC AS DOCCLIENTE, " + CRLF 
 			cRet += " CT_CLIENTE AS MV_CODCLIENTE, " + CRLF 
 			cRet += " CT_NOMCLI AS MV_CLIENTE, " + CRLF 
 			cRet += " A1_NREDUZ  AS MV_NMCLIENTE, " + CRLF 
 			cRet += " CT_LOJA AS MV_LOJA, " + CRLF 
 			cRet += " A1_GRPVEN AS MV_GRUPO, " + CRLF 
 			cRet += " CT_VEND AS MV_VENDEDOR, " + CRLF 
 			cRet += " A1_REGIAO AS MV_REGIAO, " + CRLF 
 			cRet += " CT_GRUPO AS MV_GRUPOP, " + CRLF 
 			cRet += " BM_DESC AS MV_DESCGRUPO, " + CRLF 
 			cRet += " CT_PRODUTO AS MV_PRODUTO, " + CRLF 
 			cRet += " CT_VQ_GAUT AS MV_VQ_GAUT, " + CRLF 
 			cRet += " MAX(CT_DATA)AS MV_DATA, " + CRLF 
 			cRet += " SUM(CT_QUANT)AS MV_QUANTIDADE, " + CRLF 
 			cRet += " SUM(CT_VALOR)AS MV_VALOR, " + CRLF 
 			cRet += " CT_DESCRI " + CRLF 
 		cRet += " FROM SCT010 SCT " + CRLF 
 			cRet += " INNER JOIN SA1010 SA1 on (SCT.CT_CLIENTE = SA1.A1_COD AND SCT.CT_LOJA = SA1.A1_LOJA) " + CRLF 
 			cRet += " INNER JOIN SBM010 SBM ON (SCT.CT_GRUPO = SBM.BM_GRUPO)  " + CRLF 
 		cRet += " WHERE   1=1 " + CRLF 
 			cRet += " AND SCT.D_E_L_E_T_ <> '*' " + CRLF 
 			cRet += " AND CT_DESCRI NOT IN ('SISTEMA ANTIGO ** NAO MEXER **          ') " + CRLF 
			If !_lAllCli  
					cRet += " 								AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
			EndIf
 		cRet += " GROUP BY CT_DOC,CT_CLIENTE,CT_NOMCLI,A1_NREDUZ,CT_LOJA,A1_GRPVEN,CT_VEND,A1_REGIAO,CT_GRUPO,BM_DESC,CT_PRODUTO,CT_DESCRI,CT_VQ_GAUT " + CRLF 
 	cRet += " ) VENDASSCT " + CRLF 
 		cRet += " LEFT JOIN ( " + CRLF 
 			cRet += " SELECT D2_CLIENTE AS D2_CODCLIENTE, " + CRLF 
 				cRet += " D2_LOJA AS D2_LOJA, " + CRLF 
 				cRet += " A1_NREDUZ AS A1_NOMECLI, " + CRLF 
 				cRet += " A1_REGIAO AS A1_REGCLI, " + CRLF 
 				cRet += " A1_GRPVEN AS A1_GRPCLI, " + CRLF 
 				cRet += " D2_UM AS D2_UNIDADEMEDIDA, " + CRLF 
 				cRet += " NULL AS D2_QUANTIDADE, " + CRLF 
 				cRet += " SUM(D2_PRCVEN)AS D2_PRECOVENDA, " + CRLF 
 				cRet += " SUM(D2_TOTAL)AS D2_TOTALVENDA, " + CRLF 
 				cRet += " D2_EMISSAO AS D2_DTEMISSAO, " + CRLF 
 				cRet += " B1_GRUPO AS B1_GRUPOPRODUTO, " + CRLF 
 				cRet += " BM_DESC AS BM_DESCGRUPO " + CRLF 
 			cRet += " FROM SD2010 SD2 " + CRLF 
 				cRet += " INNER JOIN SF2010 SF2 ON (SF2.D_E_L_E_T_ <> '*' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE) " + CRLF 
 				cRet += " INNER JOIN SF4010 SF4 ON (SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = '01' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S') " + CRLF 
 				cRet += " INNER JOIN SB1010 SB1 ON (SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SD2.D2_COD)  " + CRLF 
 				cRet += " INNER JOIN SA1010 SA1 ON (SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA) " + CRLF 
 				cRet += " INNER JOIN SBM010 SBM ON (SBM.BM_GRUPO = SB1.B1_GRUPO) " + CRLF 
 					cRet += " WHERE  1=1 " + CRLF 
 						cRet += " AND SD2.D_E_L_E_T_ <> '*' " + CRLF 
 						cRet += " AND SF2.F2_TIPO IN ('N','C') " + CRLF 
						If !_lAllCli  
								cRet += " 								AND SA1.A1_VQ_VEND LIKE '%"+_cCodVend+"%'" + CRLF
						EndIf
 						cRet += " GROUP BY D2_CLIENTE,D2_LOJA,A1_NREDUZ,A1_REGIAO,A1_GRPVEN,D2_UM,D2_EMISSAO,B1_GRUPO,BM_DESC " + CRLF 
 			cRet += " ) VENDASSD2  " + CRLF 
 				cRet += " ON (VENDASSCT.MV_GRUPOP = VENDASSD2.B1_GRUPOPRODUTO AND VENDASSCT.MV_CODCLIENTE = VENDASSD2.D2_CODCLIENTE AND VENDASSCT.MV_LOJA = VENDASSD2.D2_LOJA) ) TRB0 " + CRLF 
 				cRet += " GROUP BY  " + CRLF 
				    cRet += " DOCCLIENTE, " + CRLF 
 					cRet += " MV_DATA, " + CRLF 
 					cRet += " MV_CODCLIENTE, " + CRLF 
 					cRet += " MV_CLIENTE, " + CRLF 
 					cRet += " MV_NMCLIENTE, " + CRLF 
 					cRet += " MV_LOJA, " + CRLF 
 					cRet += " MV_GRUPO, " + CRLF 
 					cRet += " MV_VENDEDOR, " + CRLF 
 					cRet += " MV_REGIAO, " + CRLF 
 					cRet += " MV_GRUPOP, " + CRLF 
 					cRet += " MV_DESCGRUPO, " + CRLF 
 					cRet += " MV_PRODUTO, " + CRLF 
 					cRet += " MV_VQ_GAUT, " + CRLF 
 					cRet += " MV_QUANTIDADE, " + CRLF 
 					cRet += " MV_VALOR, " + CRLF 
 					cRet += " CT_DESCRI, " + CRLF 
 					cRet += " MV_DATA, " + CRLF 
 					cRet += " D2_CODCLIENTE, " + CRLF 
 					cRet += " D2_LOJA, " + CRLF 
 					cRet += " A1_NOMECLI, " + CRLF 
 					cRet += " A1_REGCLI, " + CRLF 
 					cRet += " A1_GRPCLI, " + CRLF 
 					cRet += " D2_UNIDADEMEDIDA, " + CRLF 
 					cRet += " D2_QUANTIDADE, " + CRLF 
 					cRet += " D2_PRECOVENDA, " + CRLF 
 					cRet += " D2_TOTALVENDA, " + CRLF 
 					cRet += " D2_DTEMISSAO, " + CRLF 
 					cRet += " B1_GRUPOPRODUTO, " + CRLF 
 					cRet += " BM_DESCGRUPO  " + CRLF 
 				cRet += " ) TRB1 " + CRLF 
 	cRet += " GROUP BY  " + CRLF 
 		cRet += " DOCCLIENTE, " + CRLF 
 		cRet += " MV_DATA, " + CRLF 
 		cRet += " (CASE WHEN MV_CODCLIENTE IS NULL THEN D2_CODCLIENTE ELSE MV_CODCLIENTE END), " + CRLF 
 		cRet += " (CASE WHEN MV_NMCLIENTE IS NULL THEN A1_NOMECLI ELSE MV_NMCLIENTE END), " + CRLF 
 		cRet += " (CASE WHEN MV_LOJA IS NULL THEN D2_LOJA ELSE MV_LOJA END), " + CRLF 
 		cRet += " MV_GRUPO, " + CRLF 
 		cRet += " MV_VENDEDOR, " + CRLF 
 		cRet += " MV_REGIAO, " + CRLF 
 		cRet += " (CASE WHEN MV_GRUPOP IS NULL THEN B1_GRUPOPRODUTO ELSE MV_GRUPOP END), " + CRLF 
 		cRet += " (CASE WHEN MV_DESCGRUPO IS NULL THEN BM_DESCGRUPO ELSE MV_DESCGRUPO END), " + CRLF 
 		cRet += " MV_PRODUTO, " + CRLF 
 		cRet += " MV_VQ_GAUT, " + CRLF 
 		cRet += " MV_VALOR, " + CRLF 
 		cRet += " MV_QUANTIDADE, " + CRLF 
 		cRet += " D2_CODCLIENTE, " + CRLF 
 		cRet += " D2_LOJA, " + CRLF 
 		cRet += " A1_NOMECLI, " + CRLF 
 		cRet += " A1_REGCLI, " + CRLF 
 		cRet += " A1_GRPCLI, " + CRLF 
 		cRet += " D2_UNIDADEMEDIDA, " + CRLF 
 	    cRet += " B1_GRUPOPRODUTO, " + CRLF 
 		cRet += " BM_DESCGRUPO, " + CRLF 
 		cRet += " MV_DATA, " + CRLF 
		cRet += " MV_DESCGRUPO " + CRLF 
cRet += " ) TRB2  " + CRLF 
 	cRet += " WHERE 1=1  " + CRLF 
// cRet += " AND (GRUPOPRODUTO BETWEEN '1020'  AND '1020') " + CRLF 

cRet += IIF(!Empty(cCodCli),AllTrim(cCodCli)," ")   + CRLF
cRet += IIF(!Empty(cGrupoP),AllTrim(cGrupoP), " ") + CRLF
cRet += IIF(!Empty(cRegCli),AllTrim(cRegCli), " ") + CRLF
cRet += IIF(!Empty(cGrpCli),AllTrim(cGrpCli)," ") + CRLF 

 cRet += "  ) TRB3 " + CRLF 
 cRet += " GROUP BY  " + CRLF 
  cRet += " DOCCLIENTE, " + CRLF 
  cRet += " MV_DATA , " + CRLF 
  cRet += " CODCLIENTE, " + CRLF 
  cRet += " NMCLIENTE, " + CRLF 
  cRet += " MV_VENDEDOR, " + CRLF 
  cRet += " D2_LOJA, " + CRLF 
  cRet += " GRPCLIENTE, " + CRLF 
  cRet += " REGCLIENTE, " + CRLF 
  cRet += " GRUPOPRODUTO, " + CRLF 
  cRet += " DESCGRUPOP, " + CRLF 
  cRet += " MV_PRODUTO, " + CRLF 
  cRet += " MV_VQ_GAUT, " + CRLF 
  cRet += " MV_VALOR, " + CRLF 
  cRet += " MV_QUANTIDADE, " + CRLF 
  cRet += " D2_CODCLIENTE, " + CRLF 
  cRet += " D2_LOJA, " + CRLF 
  cRet += " LJCLIENTE, " + CRLF 
  cRet += " A1_NOMECLI, " + CRLF 
  cRet += " A1_REGCLI, " + CRLF 
  cRet += " A1_GRPCLI, " + CRLF 
  cRet += " D2_UNIDADEMEDIDA, " + CRLF 
  cRet += " D2_QUANTIDADE, " + CRLF 
  cRet += " B1_GRUPOPRODUTO, " + CRLF 
  cRet += " BM_DESCGRUPO   " + CRLF 
 cRet += " ORDER BY GRUPOPRODUTO,CODCLIENTE  " + CRLF 



MemoWrite("C:\temp\DBRMETV.txt",cRet)

Return cRet       

Static Function vqCriaTB()       

	AADD(_struct,{"GRPPRODUTO","C"	,TamSX3("BM_DESC")[1]		,0		})
	AADD(_struct,{"NUMGRUPOP"   ,"C"	,TamSX3("BM_DESC")[1]		,0		})
	AADD(_struct,{"CODCLIENTE"	,"C"	,TamSX3("D2_CLIENTE")[1]	,0		})   
	AADD(_struct,{"LJCLIENTE"	,"C"	,TamSX3("D2_LOJA")[1]		,0		})
	AADD(_struct,{"NMCLIENTE"	,"C"	,TamSX3("A1_NOME")[1]		,0		})
	AADD(_struct,{"GRPCLIENTE"  ,"C"	,TamSX3("CT_GRPCLI")[1]		,0		})
	AADD(_struct,{"REGCLIENTE"  ,"C"	,TamSX3("CT_REGIAO")[1]		,2		})
	AADD(_struct,{"MV_QTDE" 	,"N"	,10							,0		})
	AADD(_struct,{"MV_UM" 		,"C"	,TamSX3("D2_UM")[1]			,0		})
	AADD(_struct,{"D2_QTDE" 	,"N"	,10							,0		})    
	AADD(_struct,{"D2_UM" 		,"C"	,TamSX3("D2_UM")[1]			,0		})    
	AADD(_struct,{"TOTRLZD" 	,"N"	,10							,0		}) 
	AADD(_struct,{"MV_PRODUTO" 	,"C"	,TamSX3("CT_PRODUTO")[1]	,0		}) 	   
	AADD(_struct,{"MV_VQ_GAUT" 	,"C"	,TamSX3("CT_VQ_GAUT")[1]	,0		}) 	   
	
	cArq:=Criatrab(_struct,.T.)


Return     


Static Function _getVended(_cUsuario)
Local _cRet := ""

DbSelectArea("SA3"); DbSetOrder(7)         

If (SA3->(Dbseek(xFilial("SA3")+_cUsuario)))
	_cRet := SA3->A3_COD	
EndIf

Return _cRet
