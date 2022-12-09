#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"
#Include "AP5MAIL.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBICODE.CH"
#INCLUDE "SHELL.CH"

/*/
+---------------------------------------------------------------------------+
| Programa  ≥ XMLCCE   ∫ Autor ≥                    ∫ Data ≥        2012    |
+---------------------------------------------------------------------------+
| Descricao ≥ Carta de correÁ„o			                                    |
+---------------------------------------------------------------------------+
| Uso       ≥ FATURAMENTO                                                   |
|           ≥                                                               |
|           ≥ ESTE PROGRAMA EMITE A CARTA DE CORRECAO ELETRONICA BASEADO    |
|           ≥ NAS TABELAS SPED050 E SPED150, E UTILIZA DUAS SP (STORED      |
|           ≥ PROCEDURES) PARA BUSCAR OS DADOS DESSAS TABELAS               |
|           ≥                                                               |
|           ≥ **** ATENCAO ****                                             |
|           ≥ OLHE AS ROTINAS DE FORMATACAO DE TEXTO NO FINAL DESTE PROGRAMA|
+---------------------------------------------------------------------------+
/*/
User Function XMLCCE()                    

	SetPrvt("TAMANHO,WNREL,ARETURN,NLASTKEY,NTIPO,NTIPOA,CSTRING")
	SetPrvt("LEND,TITULO,TITULO2,CDESC1,CDESC2,CDESC3,CPERG")
	SetPrvt("NOMEPROG,M_PAG,aResult,aLinhas,vQuery")
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Define Variaveis                                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	Tamanho  := "P"
	wnRel    := 'XMLCCE'
	aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
	nLastKey := 0
	nTipo    := 18
	cString  :="SA1"
	lEnd     :=.F.
	cDesc1   := "Este relatorio ira imprimir a CARTA DE CORRE«√O ELETRONICA (CC-e)"
	cDesc2   := ""
	cDesc3   := ""
	cPerg    := ""
	nomeprog := "XMLCCE"
	nLastKey := 0
	cabec1   := ""
	cabec2   := ""
	m_pag    := 01                 
	aResult  := {}                                 
	aLinhas  := {}                                
	vQuery   := ""   
	_cTitArq := ""  
	NmBanco  := ""

    // CRIACAO DE PARAMETRO PARA FORMATAR A INSTANCIA DO BANCO...
    If Empty(NmBanco)
       FSAtuSX6()
    Endif

    DBSELECTAREA("SX6")
    DBSETORDER(1)
	DBSEEK("  MV_BCOSPED")
    NmBanco := ALLTRIM(SX6->X6_CONTEUD)

    // CRIACAO DE PERGUNTAS
    cPerg	 := Padr( "XMLCCE", LEN( SX1->X1_GRUPO ) )
    ValidPerg(cPerg)
	IF !Pergunte(cPerg,.T.)
		Return
	Endif                                                             

	titulo   := "CARTA DE CORRE«√O ELETRONICA - CCe"
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Mv_par01  -  Nota                                            ≥
	//≥Mv_par02  -  Serie                                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Envia controle para a funcao SETPRINT                        ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	Processa({|| GeraCCE()},"Gera Dados para impress„o")  
	If !Empty(aResult[1])
		RptStatus({|| ImpCCE()},"Imprimindo RelatÛrio")
	Else
		MsgInfo("DANFE n„o tem carta de correÁ„o... VERIFIQUE!!") 
	EndIf	

Return


//-------------------------------------------------------------------------------------------------
Static Function GeraCCE()
	Local cError   := ""
	Local cWarning := ""
	Local oXml     := NIL
	
	vNfeId  := mv_par02+mv_par01
    vNfeChv := ""            
    
	// verifica se existe a SP, e se n„o cria
	IF !TCSPExist("CCE_PEGA_NFEID")
		vQuery := " CREATE PROCEDURE CCE_PEGA_NFEID( "
		vQuery += " @IN_STR  CHAR(255), "
		vQuery += " @OUT_STR VARCHAR(8000) OUTPUT " 
		vQuery += " ) "
		vQuery += " WITH RECOMPILE "
		vQuery += " AS BEGIN "
		vQuery += " 	SELECT @OUT_STR = SUBSTRING( "
		vQuery += " 	CONVERT(TEXT,CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX),XML_SIG))),  "
		vQuery += " 	CHARINDEX('infNFe Id=', CONVERT(TEXT,CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX),XML_SIG))))+14, 44) "
		vQuery += " 	FROM "+NmBanco+".dbo.SPED050 "
		vQuery += " 	WHERE NFE_ID = @IN_STR "
		vQuery += " 	AND D_E_L_E_T_ <> '*' "
		vQuery += " END "
		_cret:=  TcSQLExec(vQuery)
		If _CRet#0
			_cRet = TCSQLERROR()
			While !Empty(_cRet)
				APMsgAlert(AllTrim(_cRet),"XMLCCE  - 93. Erro na criacao da SP1. Contactar Administrador do Sistema ")
				_cRet = TCSQLERROR()
			EndDo 
		EndIf                                                                          
	EndIf	
                             
	IF !TCSPExist("CCE_DADOS_CCE")
		vQuery := " Create Procedure CCE_DADOS_CCE ( "
		vQuery += "         @IN_STR char(255), "
		vQuery += "         @VERSAO varchar(4) Output, "
		vQuery += " 		@ID_LOTE varchar(1) Output, "
		vQuery += " 		@ID_EVENTO varchar(54) Output, "
		vQuery += " 		@ORGAO varchar(2) Output, "
		vQuery += " 		@AMBIENTE varchar(1) Output, "
		vQuery += " 		@CNPJ varchar(14) Output, "
		vQuery += " 		@CHAVE_ACESSO varchar(44) Output, "
		vQuery += " 		@DATA_EVENTO varchar(10) Output, "
		vQuery += " 		@HORA_EVENTO varchar(8) Output, "
		vQuery += " 		@COD_EVENTO varchar(6) Output, "
		vQuery += " 		@SEQ_EVENTO varchar(1) Output, "
		vQuery += " 		@VERSAO_EVENTO varchar(3) Output, "
		vQuery += " 		@DET_EVENTO varchar(4) Output, "
		vQuery += " 		@DESC_EVENTO varchar(17) Output, "
		vQuery += " 		@CORRECAO varchar(8000) Output, "
		vQuery += " 		@COND_USO varchar(8000) Output,"
		vQuery += " 		@PROTOCOL varchar(15) Output  "
		vQuery += " 		 ) "
		vQuery += " 		WITH RECOMPILE "
		vQuery += " 		AS BEGIN "
		vQuery += " 		SELECT "
		vQuery += " 		@VERSAO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('versao=', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+8, 4), "
		vQuery += " 		@ID_LOTE = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<idLote>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+8, 1), "
		vQuery += " 		@ID_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<infEvento Id=', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+15, 54), "
		vQuery += " 		@ORGAO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<cOrgao>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+8, 2), "
		vQuery += " 		@AMBIENTE = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),  "
		vQuery += " 		CHARINDEX('<tpAmb>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+7, 1), "
		vQuery += " 		@CNPJ = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<CNPJ>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+6, 14), "
		vQuery += " 		@CHAVE_ACESSO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<chNFE>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+7, 44), "
		vQuery += " 		@DATA_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<dhEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+10, 10), "
		vQuery += " 		@HORA_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<dhEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+21, 8), "
		vQuery += " 		@COD_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<tpEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+10, 6), "
		vQuery += " 		@SEQ_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<nSeqEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+12, 1), "
		vQuery += " 		@VERSAO_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),  "
		vQuery += " 		CHARINDEX('<verEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+11, 3), "
		vQuery += " 		@DET_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<detEvento versao=', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+19, 4), "
		vQuery += " 		@DESC_EVENTO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<descEvento>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+12, 17), "
		vQuery += " 		@CORRECAO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))),  "
		vQuery += " 		CHARINDEX('<xCorrecao>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+11, "
		vQuery += " 		CHARINDEX('</xCorrecao>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))- "
		vQuery += " 		CHARINDEX('<xCorrecao>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))-11 ), "
		vQuery += " 		@COND_USO = substring(CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))), "
		vQuery += " 		CHARINDEX('<xCondUso>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))+10," 
		vQuery += " 		CHARINDEX('</xCondUso>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))- "
		vQuery += " 		CHARINDEX('<xCondUso>', CONVERT(TEXT,CONVERT(VARCHAR(max),CONVERT(VARBINARY(max),XML_SIG))))-10 ),      "
		vQuery += "         @PROTOCOL = CONVERT(TEXT,STR(CONVERT(varchar(15), CAST(PROTOCOLO AS decimal(15,0))),15,0))             "
		vQuery += " 		FROM "+NmBanco+".dbo.SPED150 "
		vQuery += " 		WHERE NFE_CHV = @IN_STR "
		vQuery += " 		AND D_E_L_E_T_ <> '*' "
		vQuery += " 		END	 "

		_cret:=  TcSQLExec(vQuery)
		If _CRet#0
			_cRet = TCSQLERROR()
			While !Empty(_cRet)
				APMsgAlert(AllTrim(_cRet),"XMLCCE - 168. Erro na criacao da SP2. Contactar Administrador do Sistema ")
				_cRet = TCSQLERROR()
			EndDo 
		EndIf
	EndIf	

	IF TCSPExist("CCE_PEGA_NFEID")
		aResult := TCSPEXEC("CCE_PEGA_NFEID",vNfeId)
		IF empty(aResult)
			MsgInfo("Erro na execuÁ„o da Stored Procedure : "+TcSqlError()+" - Linha 68 - Avise ao Suporte TÈcnico" ) 
			Return
		EndIf	
	EndIf	
	                                  
	vNfeChv := AllTrim(aResult[1])
	aResult := {}
	If !Empty(vNfeChv)
		IF TCSPExist("CCE_DADOS_CCE")
			aResult := TCSPEXEC("CCE_DADOS_CCE",vNfeChv )
			IF empty(aResult)
				MsgInfo("Erro na execuÁ„o da Stored Procedure : "+TcSqlError()+" - Linha 79 - Avise ao suporte Tecnico") 
				Return
			Endif	
		EndIf	
	EndIf	
Return(.t.)
//-------------------------------------------------------------------------------------------------
Static Function ImpCCE()
	///----------------------------------    COMECA A IMPRESSAO   -------------------
	nLin       := 10000
	nCol	   := 800
	nPage	   := 1
	nHeight    := 08
	lBold	   := .F.
	lUnderLine := .F.
	lPixel	   := .T.
	lPrint	   := .F.
	aUF        := {}                
	*------------------------------*
	* Define Fontes a serem usados     *
	*------------------------------*

	//oFont	:= TFont():New( "Arial"  ,,_xsize ,,_xnegrito,,,,, lUnderLine ) 
	oFtA07	:= TFont():New( "Arial"  ,,07     ,,.f.      ,,,,, .f.  )
	oFtA07N	:= TFont():New( "Arial"  ,,07     ,,.t.      ,,,,, .f.  )
	oFtA08	:= TFont():New( "Arial"  ,,08     ,,.f.      ,,,,, .f.  )
	oFtA08N	:= TFont():New( "Arial"  ,,08     ,,.t.      ,,,,, .f.  )
	oFtA09	:= TFont():New( "Arial"  ,,09     ,,.f.      ,,,,, .f.  )
	oFtA09N	:= TFont():New( "Arial"  ,,09     ,,.t.      ,,,,, .f.  )
	oFtA10	:= TFont():New( "Arial"  ,,10     ,,.f.      ,,,,, .f.  )
	oFtA10N	:= TFont():New( "Arial"  ,,10     ,,.t.      ,,,,, .f.  )
	oFtA12	:= TFont():New( "Arial"  ,,12     ,,.f.      ,,,,, .f.  )
	oFtA12N	:= TFont():New( "Arial"  ,,12     ,,.t.      ,,,,, .f.  )
	oFtA14	:= TFont():New( "Arial"  ,,14     ,,.f.      ,,,,, .f.  )
	oFtA14N	:= TFont():New( "Arial"  ,,14     ,,.t.      ,,,,, .f.  )

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Preenchimento do Array de UF                                            ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})

	nLin := 3000
			
	lAdjustToLegacy := .F. 
	lDisableSetup  := .T.           
	_cTitArq := MV_PAR01+MV_PAR02    //+"_CARTA_DE_CORRECAO_ELETRONICA"

	oPrn := FWMSPrinter():New(_cTitArq, 6, lAdjustToLegacy, , lDisableSetup)			
	oPrn:LPDFASPNG := .F.	
	oPrn:SetResolution(72)
	oPrn:SetPortrait()
	oPrn:SetPaperSize(9)  // a4
	oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior 
	oPrn:cPathPDF := "C:\ARQS\" // Caso seja utilizada impress„o em IMP_PDF		 
		
	If nLin>480
		Cabecario()
	Endif         

	oPrn:Say(nLin ,0210 ,"CARTA DE CORRE«√O", 		oFta14N, 100 )                                  
	nlin+=40                        	

    oPrn:Box(118,0005,360,0570)  // quadro geral
    oPrn:Box(118,0005,148,0570)  // quadro serie/nota/emissao
    oPrn:Box(148,0005,210,0570)  // quadro cnpj/chave/orgao     
    oPrn:Box(210,0005,239,0570)  // quadro ambiente/id/data-hora         
    oPrn:Box(239,0005,275,0570)  // quadro cod evento/seq/protocolo
    oPrn:Box(275,0005,305,0570)  // quadro INFORMA«’ES DA CARTA DE CORRE«√O
    oPrn:Box(340,0005,360,0570)  // quadro TEXTO DA CARTA DE CORRE«√O

	oPrn:Line(118,0115,275,0115)    // linha de vertical  (NF/CHAVE/ID/SEQ)
	oPrn:Line(239,0205,275,0205)    // linha de vertical  (PROTOCOLO)
	oPrn:Line(118,0455,275,0455)    // linha de vertical  (EMISSAO/DATA/VERSAO)  
    
	oPrn:Say(nLin ,0010 ,"Serie"       ,oFta12, 100 )                                  
	oPrn:Say(nLin ,0120 ,"Nota Fiscal" ,oFta12, 100 )                                  
	oPrn:Say(nLin ,0460 ,"Emiss„o Nota",oFta12, 100 )                                  
	nlin+=10                        	
	oPrn:Say(nLin ,0010 ,MV_PAR02  , 	oFta12, 100 )   
	oPrn:Say(nLin ,0120 ,MV_PAR01  , 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0460 ,DTOC(POSICIONE("SF2",1,XFILIAL("SF2")+MV_PAR01+MV_PAR02,"F2_EMISSAO")), 	oFta12, 100 )                                  
	nlin+=20                        	
	oPrn:Say(nLin ,0010 ,"CNPJ"                    , 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0120 ,"Chave de Acesso da NF-E" ,	oFta12, 100 )                                  
	oPrn:Say(nLin ,0460 ,"Org„o"                   ,	oFta12, 100 )                                  
	nlin+=10                        	
	oPrn:Say(nLin ,0010 ,aResult[6]                 , 	oFta12, 100 )                                  
    oPrn:Say(nLin ,0120 ,TransForm(SUBSTRING(aResult[3],9,44),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFtA12, 100)
	oPrn:Say(nLin ,0460 ,aResult[4]+" - "+aUF[aScan(aUF,{|x| x[2] == aResult[4]})][01], 	oFta12, 100 )                                  
	nlin+=30                        	
	oPrn:Code128C(nlin, 0120,SUBSTRING(aResult[3],9,44), 28 )
	nlin+=20
	oPrn:Say(nLin ,0010 ,"Ambiente"  , 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0120 ,"Id"        ,	oFta12, 100 )                                  
	oPrn:Say(nLin ,0460 ,"Data/Hora" ,  oFta12, 100 )                                  
	nlin+=10                        	
	oPrn:Say(nLin ,0010 ,IIF(ALLTRIM(aResult[5])=="1","1-ProduÁ„o","2-Homolog"), 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0120 ,aResult[3], 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0460 ,SUBSTRING(aResult[8],9,2)+"/"+ SUBSTRING(aResult[8],6,2)+"/"+SUBSTRING(aResult[8],1,4)+"-"+aResult[9]  , 	oFta12, 100 )                                  
	nlin+=25                        	
	oPrn:Say(nLin ,0010 ,"Cod. Evento"  ,	oFta12, 100 )                                  
	oPrn:Say(nLin ,0120 ,"Seq. Evento"  ,	oFta12, 100 )                                  
	oPrn:Say(nLin ,0230 ,"Protocolo"    ,	oFta12, 100 )                                  
	oPrn:Say(nLin ,0460 ,"Vers„o Evento",	oFta12, 100 )                                  
	nlin+=10                        	
	oPrn:Say(nLin ,0010 ,aResult[10], 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0120 ,aResult[11], 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0230 ,aResult[17], 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0460 ,aResult[12], 	oFta12, 100 )                                  
	nlin+=30                        	
	oPrn:Say(nLin ,0190 ,"INFORMA«’ES DA CARTA DE CORRE«√O",		oFta12N, 100 )                                  
	nlin+=20                        	
	oPrn:Say(nLin ,0010 ,"Vers„o",			oFta12, 100 )                                  
	oPrn:Say(nLin ,0210 ,"Descr. Evento",	oFta12, 100 )                                  
	nlin+=10                        	
	oPrn:Say(nLin ,0010 ,aResult[13], 	oFta12, 100 )                                  
	oPrn:Say(nLin ,0210 ,aResult[14], 	oFta12, 100 )                                  
	nlin+=30                        	
	oPrn:Say(nLin ,0190 ,"TEXTO DA CARTA DE CORRE«√O",			oFta12N, 100 )                                  
	nlin+=20                        	
    oPrn:Line(nLin-20,0005,nLin+10,0005)    // linha de vertical  
    oPrn:Line(nLin-20,0570,nlin+10,0570)    // linha de vertical 

	vTexto := u_FormtText(aResult[15], 100, aLinhas)
    For vInd := 1 to len(aLinhas)
	    oPrn:Line(nLin,0005,nLin+10,0005)    // linha de vertical 
		oPrn:Say(nLin ,0010 ,aLinhas[vInd, 1], 	oFta12, 100 )  // impresao do que foi corrigido na nota		
  	    oPrn:Line(nLin,0570,nlin+10,0570)    // linha de vertical 
		nlin+=10                        	
	Next    	

	aLinhas := {}	
	nLin +=30
    oPrn:Line(nLin-30,0005,nLin+10,0005)    // linha de vertical  
    oPrn:Line(nLin-30,0570,nlin+10,0570)    // linha de vertical 
    oPrn:Box(NLIN-15,0005,NLIN+5,0570)  // quadro CONDICOES
	oPrn:Say(nLin ,0190 ,"CONDI«’ES DE USO DA CARTA DE CORRE«√O",	oFta12N, 100 )                                  
	nlin+=20                        	
    oPrn:Line(nLin-20,0005,nLin+10,0005)    // linha de vertical  
    oPrn:Line(nLin-20,0570,nlin+10,0570)    // linha de vertical 
	vTexto := u_FormtText(aResult[16], 100, aLinhas)
    For vInd := 1 to len(aLinhas)
	    oPrn:Line(nLin,0005,nLin+10,0005)    // linha de vertical 
		oPrn:Say(nLin ,0010 ,aLinhas[vInd, 1], 	oFta12, 100 )		
  	    oPrn:Line(nLin,0570,nlin+10,0570)    // linha de vertical 
		nlin+=10                        	
	Next    	
    oPrn:Say(nLin-1,0005,Replicate("_",108),oFta12)                   
	oPrn:SaveAllasJpeg("C:\ARQS\"+_cTitArq,1500,1500)

    If MV_PAR03 = 2
		SetPgEject(.F.) // Funcao pra n„o ejetar pagina em branco 
		oPrn:Setup()   // para configurar impressora - comentar se quiser gerar o PDF direto.
		oPrn:Preview() // Visualiza relatorio na tela     
	//	oPrn:Print() // Visualiza relatorio na tela
		Ms_Flush()             

    ElseIf mv_par03 = 1

	    oPrn:cPathPdf := 'C:\ARQS\'
	    oPrn:Preview()//Visualiza antes de imprimir
		cArquivo := AllTrim(oPrn:cPathPdf+_cTitArq+".PDF")
        CpyT2S( cArquivo, "\PDF\" )          

   	    oPrn:cPathPdf := '\PDF\'
		cAccount  	:= Rtrim(SuperGetMv("MV_RELACNT")) 
		cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
		cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))

        cClEm       := POSICIONE("SF2",1,XFILIAL("SF2")+MV_PAR01+MV_PAR02,"F2_CLIENTE")
        cLjEm       := POSICIONE("SF2",1,XFILIAL("SF2")+MV_PAR01+MV_PAR02,"F2_LOJA")
        cTpEm       := POSICIONE("SF2",1,XFILIAL("SF2")+MV_PAR01+MV_PAR02,"F2_TIPO")
        cpara       := mv_par04
        
//        IF cTpEm $ "N'
//       		cPara    	:= POSICIONE("SA1",1,XFILIAL("SA1")+cClEm+cLjEm,"A1_EMAIL")
//        ELSEIF cTpEm $ "D/B'
//       		cPara    	:= POSICIONE("SA2",1,XFILIAL("SA2")+cClEm+cLjEm,"A2_EMAIL")
//        ENDIF

		cDe 	 	:= Rtrim(SuperGetMv("MV_RELFROM"))
		cArquivo := AllTrim(oPrn:cPathPdf+_cTitArq+".PDF")
		aAnexos  := {cArquivo}
        cVal1 := _cTitArq

//		oPrn:SaveAllasJpeg("C:\ARQS\"+_cTitArq,1500,1500)

		If File(cArquivo)
			EnvMail(cAccount	,cPassword	,cServer	,cDe,;
								cPara		,'Carta de CorreÁ„o - CCe',;
								'Anexo arquivo em Formato PDF, da Carta de CorreÁ„o, referente a nota fiscal N∫ '+cVal1+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
								'Favor n„o responder este e-mail.', aAnexos)                             
	   ELSE
	        MSGSTOP("F...")
	   Endif

    
      FreeObj(oPrn)
       oPrn:= Nil
*/
    Endif

Return .T.

//-------------------------------------------------------------------------------------------------
Static function Cabecario()

	_cNomLogo := FisxLogo("1")
	_nLarg    := 150  //ajusta a largura do logo
	_nAlt     := 35   //ajusta a altura do logo                              

	If nlin<10000
		oPrn:EndPage()
		oPrn:StartPage()
	Endif                    

	nLin := 30
	oPrn:SayBitmap( nlin  , 0010 , _cNomLogo     , _nLarg , _nAlt )
	nLin += 5
	oPrn:Say( nLin+5, 0495 , "Data : " + Dtoc(dDataBase)   , oFtA07 , 100 )      
	nLin += 10
	oPrn:Say( nLin+5, 0495 , "Pagina : " + StrZero(npage,3)     , oFtA07 , 100 )
	nLin += 10
	
  	oPrn:Say(nLin+710 , 0005 , nomeprog                      ,oFtA07, 100)
	oPrn:Say(nLin+710 , 0495 ,"Hora : " + Time()             ,oFtA07, 100)      
	oPrn:Say(nLin+720 , 0005 ,"TOTVS/V."+ SubStr(cVersao,1,6),oFtA07, 100)

	npage++
	nLin := 90    

Return(.t.)


User FUNCTION FormtText(cMemo, nLen)

//----------------------------------------------------------------------------
// Objetivo      : Formata linhas do campo memo                               *
// Observacao    :                                                            *
// Sintaxe       : FormtText(@cMemo, nLen)                                   *
// Parametros    : cMemo ----> texto memo a ser formatado                     *
//                 nLen  ----> tamanho de colunas por linha                   *
// Retorno       : array aLinhas - retorna o texto linha a linha              *
// Fun. chamadas : CalcSpaces()                                               *
// Arquivo fonte : Memo.prg                                                   *
// Arq. de dados : -                                                          *
// Veja tambÇm   : MemoWindow()                                               *
//----------------------------------------------------------------------------
LOCAL nLin, cLin, lInic, lFim, aWords:={}, cNovo:="", cWord, lContinua, nTotLin

   lInic:=.T.
   lFim:=.F.
   nTotLin:=MLCOUNT(cMemo, nLen)
   FOR nLin:=1 TO nTotLin

      cLin:=RTRIM(MEMOLINE(cMemo, nLen, nLin)) //recuperar

      IF EMPTY(cLin) //Uma linha em branco ->Considerar um par†grafo vazio
         IF lInic  //Inicio de paragrafo
           aWords:={}  //Limpar o vetor de palavras
           lInic:=.F.
         ELSE
            AADD(aWords, CHR(13)+CHR(10)) //Incluir quebra de linha
         ENDIF
         AADD(aWords, CHR(13)+CHR(10)) //Incluir quebra de linha
         lFim:=.T.
      ELSE
         IF lInic  //Inicio de paragrafo
            aWords:={} //Limpar o vetor de palavras
            //Incluir a primeira palavra com os espacos que a antecedem
            cWord:=""
            WHILE SUBSTR(cLin, 1, 1)==" "
               cWord+=" "
               cLin:=SUBSTR(cLin, 2)
            END
            IF(nNext:=AT(SPACE(1), cLin))<>0
               cWord+=SUBSTR(cLin, 1, nNext-1)
            ENDIF
            AADD(aWords, cWord)
            cLin:=SUBSTR(cLin, nNext+1)
            lInic:=.F.
         ENDIF
         //Retirar as demais palavras da linha
         WHILE(nNext:=AT(SPACE(1), cLin))<>0
            IF !EMPTY(cWord:=SUBSTR(cLin, 1, nNext-1))
               IF cWord=="," .AND. !EMPTY(aWords)
                  aWords[LEN(aWords)]+=cWord
               ELSE
                  AADD(aWords, cWord)
               ENDIF
            ENDIF
            cLin:=SUBSTR(cLin, nNext+1)
         END
         IF !EMPTY(cLin) //Incluir a ultima palavra
            IF cLin=="," .AND. !EMPTY(aWords)
               aWords[LEN(aWords)]+=cLin
            ELSE
               AADD(aWords, cLin)
            ENDIF
         ENDIF
         IF nLin==nTotLin  //Foi a ultima linha -> Finalizar o paragrafo
            lFim:=.T.
         ELSEIF RIGHT(cLin, 1)=="." //Considerar que o 'ponto' finaliza paragrafo
            AADD(aWords, CHR(13)+CHR(10))
            lFim:=.T.
         ENDIF
      ENDIF

      IF lFim
         IF LEN(aWords)>0
            nNext:=1
            nAuxLin:=1
            WHILE nAuxLin<=LEN(aWords)
               //Montar uma linha formatada
               lContinua:=.T.
               nTot:=0
               WHILE lContinua
                  nTot+=(IF(nTot=0, 0, 1)+LEN(aWords[nNext]))
                  IF nNext==LEN(aWords)
                     lContinua:=.F.
                  ELSEIF (nTot+1+LEN(aWords[nNext+1]))>=nLen
                     lContinua:=.F.
                  ELSE
                     nNext++
                  ENDIF
               END
               IF nNext==LEN(aWords)  //Ultima linha ->Nao formata
                  FOR nAux:=nAuxLin TO nNext
                     cNovo+=(IF(nAux==nAuxLin, "", " ")+aWords[nAux])
                  NEXT
               ELSE //Formatar
                  FOR nAux:=nAuxLin TO nNext
                     cNovo+=(CalcSpaces(nNext-nAuxLin, nLen-nTot-1, nAux-nAuxLin)+aWords[nAux])
                  NEXT
                  cNovo+=" "
               ENDIF
               nNext++
               nAuxLin:=nNext
            END
         ENDIF

         lFim:=.F.  //Indicar que o fim do paragrafo foi processado
         lInic:=.T. //Forcar inicio de paragrafo

      ENDIF

   NEXT

   //Retirar linhas em branco no final
   WHILE LEN(cNovo)>2 .AND. (RIGHT(cNovo, 2)==CHR(13)+CHR(10))
      cNovo:=LEFT(cNovo, LEN(cNovo)-2)
   END

	For vInd := 0 to (len(cNovo)/nLen)
		AADD(aLinhas, {Substr(cNovo, (vInd*nLen)+1, nLen) } )
	Next		

RETURN(cNovo)


Static FUNCTION CalcSpaces(nQt, nTot, nPos)
//----------------------------------------------------------------------------
// Objetivo      : Calcula espacos necessarios para completar a linha         *
// Observacao    :                                                            *
// Sintaxe       : CalcSpaces(nQt, nTot, nPos)                                *
// Parametros    : nQt  ---> quantidade de separacoes que devem existir       *
//                 nTot ---> total de caracteres em branco excedentes a serem *
//                           distribuidos                                     *
//                 nPos ---> a posicao de uma separacao em particular         *
//                           (comecando do zero)                              *
// Retorno       : a separacao ja pronta de posicao nPos                      *
// Fun. chamadas : -                                                          *
// Arquivo fonte : Memo.prg                                                   *
// Arq. de dados : -                                                          *
// Veja tambÇm   : MemoWindow()                                               *
//----------------------------------------------------------------------------
LOCAL cSpaces,; //Retorno de espacos
      nDist,;   //Total de espacos excedentes a distribuir em cada separacao
      nLim      //Ate que posicao devera conter o resto da divisao

   IF nPos==0
      cSpaces:=""
   ELSE
      nDist:=INT(nTot/nQt)
      nLim:=nTot-(nQt*nDist)
      cSpaces:=REPL(SPACE(1), 1+nDist+IF(nPos<=nLim, 1, 0))
   ENDIF

RETURN cSpaces


Static Function ValidPerg(cPerg)

sAlias := Alias()
aRegs  := {}
i := j := 0

dbSelectArea("SX1")
dbSetOrder(1)

//GRUPO,ORDEM,PERGUNTA              ,PERGUNTA,PERGUNTA,VARIAVEL,TIPO,TAMANHO,DECIMAL,PRESEL,GSC,VALID,VAR01,DEF01,DEFSPA01,DEFING01,CNT01,VAR02,DEF02,DEFSPA02,DEFING02,CNT02,VAR03,DEF03,DEFSPA03,DEFING03,CNT03,VAR04,DEF04,DEFSPA04,DEFING04,CNT04,VAR05,DEF05,DEFSPA05,DEFING05,CNT05,F3,GRPSXG
AADD(aRegs,{cPerg,"01","Da Nota           ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Serie             ?","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Envia Email       ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Sim","","","","","N„o","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Email             ?","","","mv_ch4","C",70,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(sAlias)

// criacao de parametro no sx6
Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ ENVEMAIL ≥ Autor ≥ Ricardo Cavalini      ≥ Data ≥25/01/2010≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Envia e-mail                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico                                                 ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function EnvMail(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,aAttach)

Local cEmailTo := ""							// E-mail de destino
Local cEmailBcc:= ""							// E-mail de copia
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := ALLTRIM(cPassword)	        // Senha de acesso

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense≥
//≥que somente ela recebeu aquele email, tornando o email mais personalizado.   ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

cEmailTo := cEmail

If At(";",cEmail) > 0 // existe um segundo e-mail.
	cEmailBcc:= SubStr(cEmail,At(";",cEmail)+1,Len(cEmail))
Endif	

CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult

// Se a conexao com o SMPT esta ok
If lResult

	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenhaTK)	
	Else
		lRet := .T.	
    Endif    

	cAnexos:=''
	For nI:=1 to Len(aAttach)
	  cAnexos+=aAttach[nI]+";"  
	Next

	cAnexos:=Left(cAnexos,Len(cAnexos)-1)
	
	If lRet
		SEND MAIL FROM cFrom ;
		TO      	cEmailTo;
		SUBJECT 	cAssunto;
		BODY    	cMensagem;
		ATTACHMENT  cAnexos  ;
		RESULT lResult
					//danfe_000055024_000055024.pdf
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
				Help(" ",1,'Erro no Envio do Email',,cError+ " " + cEmailTo,4,5)	//AtenÁ„o
		Endif

	Else
		GET MAIL ERROR cError
		Help(" ",1,'AutenticaÁ„o',,cError,4,5)  //"Autenticacao"
		MsgStop('Erro de AutenticaÁ„o','Verifique a conta e a senha para envio') 		 //"Erro de autenticaÁ„o","Verifique a conta e a senha para envio"
	Endif
		
	DISCONNECT SMTP SERVER
	
//	For nI:=1 To Len(aAttach) 
//		FErase(aAttach[nI]) 
//	Next

Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
Endif

Return(lResult)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa ≥ FSAtuSX6 ∫ Autor ≥ Microsiga          ∫ Data ≥  04/11/09   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Descricao≥ Funcao de processamento da gravacao do SX6 - Par‚metros    ≥±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±≥ Uso      ≥ FSAtuSX6 - V.2.5                                           ≥±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function FSAtuSX6()
Local aSX6    := {}
Local aEstrut := {}
Local nI      := 0
Local nJ      := 0
Local cAlias  := ''
Local cTexto  := 'Inicio da Atualizacao do SX6' + CRLF + CRLF
Local lReclock  := .T.
Local lContinua := .T. 
Local nTamSeek  := LEN(SX6->X6_FIL)

aEstrut := { 'X6_FIL'    , 'X6_VAR'   , 'X6_TIPO'   , 'X6_DESCRIC'       , 'X6_DSCSPA'        , 'X6_DSCENG'        , 'X6_DESC1'  , 'X6_DSCSPA1',;
             'X6_DSCENG1', 'X6_DESC2' , 'X6_DSCSPA2', 'X6_DSCENG2'       , 'X6_CONTEUD', 'X6_CONTSPA', 'X6_CONTENG', 'X6_PROPRI' }

// PARAMETRO DO BANCO SPED
aAdd( aSX6,{ '  '		 ,'MV_BCOSPED', 'C'      	,'NOME DO BANCO SPED','NOME DO BANCO SPED','NOME DO BANCO SPED',''          ,''            ,; 
	         ''          ,''          , ''          , ''                 , ''         , ''           , ''          , 'U' })

// Atualizando dicion·rio
//oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( 'SX6' )
dbSetOrder( 1 )
For nI := 1 To Len( aSX6 )
	If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamSeek ) + aSX6[nI][2] ) )

		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + '/'
		EndIf

		RecLock( 'SX6', .T. )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

		cTexto += 'Foi incluÌdo o parametro ' + aSX6[nI][1] + '/' + aSX6[nI][2] + CRLF
//		oProcess:IncRegua2( 'Atualizando Arquivos (SX6)...')
	EndIf
Next nI

// CRIA TELA PARA AJUSTE NO PARAMETRO, COLOCAR NOME DO BANCO SPED
if empty(Rtrim(SuperGetMv("MV_BCOSPED"))) 
   u_ATPARAM()
endif

Return cTexto

// ALTERA PARAMETRO
User Function ATPARAM()
SetPrvt("oDlg2,__cCodPrd")
oDlg2     := Nil
__cCodPrd := space(20)
DEFINE MSDIALOG oDlg2 TITLE "Nome do banco de dados SPED" From 000,000 to 240,410 OF oDlg2 PIXEL

//@ 000,000 To 240,410 Dialog oDlg2 Title "Nome do banco de dados SPED"            

@ 030,015 SAY OemToAnsi("MV_BCOSPED") OF oDlg2 pixel
@ 030,050 Get __cCodPrd   SIZE 050,10 OF oDlg2 pixel

DEFINE SBUTTON  FROM 100,015 TYPE 1 ACTION (_EpOk())  ENABLE OF oDlg2 PIXEL //Salva e Apaga
DEFINE SBUTTON  FROM 100,130 TYPE 2 ACTION (_EpFech())  ENABLE OF oDlg2 PIXEL //Salva e Apaga

ACTIVATE MSDIALOG oDlg2 CENTER
return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ _EpOK     ≥ Autor ≥ RICARDO CAVALINI   ≥ Data ≥ 02/02/2010 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ BOTAO PARA CONFIRMA A ALTERACAO.                           ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function _EpOk()

Dbselectarea("SX6")
DbSetOrder(1)
If Dbseek("  MV_BCOSPED")
   Reclock("SX6",.F.)
    SX6->X6_CONTEUD  := __cCodPrd 
    SX6->X6_CONTSPA  := __cCodPrd     
    SX6->X6_CONTENG  := __cCodPrd     
   MsUnlock("SX6")     
Endif
Close(oDlg2)
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ _EPFECH  ≥ Autor ≥ RICARDO CAVALINI   ≥ Data ≥ 02/02/2010 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ BOTAO PARA FECHAR A TELA SEM GRAVAR                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static function _EPFech()
Close(oDlg2)
Return