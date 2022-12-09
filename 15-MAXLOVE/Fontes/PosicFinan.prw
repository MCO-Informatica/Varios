#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#INCLUDE 'TOPCONN.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³POSICFINAN          º Autor ³ MCINFOTECº Data ³  2017       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de posicação financeira a Receber ou a Pagar      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function POSICFINAN()

	Local oReport
	Local cPerg		:= ""
	Local cAlias 	:= getNextAlias()

	Local aBoxParam 	:= {}
	Local aRetPAram 	:= {}
	
	Private nTpRecPag	:= 0

	Aadd(aBoxParam,{3,"Posição Financeira ?",1,{"A Receber","A Pagar"},70,,.F.})

	If !ParamBox(aBoxParam, "Posição Financeira", @aRetParam)
		Return
	Endif

	nTpRecPag := mv_par01
	
	If nTpRecPag = 1
		cPerg		:= Padr( "FINANREC", LEN( SX1->X1_GRUPO ) )
	 Else
		cPerg		:= Padr( "FINANPAG", LEN( SX1->X1_GRUPO ) )
	EndIf
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.f. )

	oReport := reportDef(cAlias, cPerg)
	oReport:printDialog()

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

	local cTitle  := "Relatório de Posição Financeira - " + IIF(nTpRecPag = 1," A Receber","A Pagar")
	local cHelp   := "Permite gerar relatório de Posição financeira"
	local oReport
	local oSection1
	local aOrdem	  := {}

	If nTpRecPag = 1
		 aOrdem	  := {OemToAnsi("Cliente + Titulo"),OemToAnsi("Vencimento + Cliente "),OemToAnsi("Emissao + Cliente")}
	 Else		
		 aOrdem	  := {OemToAnsi("Fornecedor + Titulo"),OemToAnsi("Vencimento + Fornecedor "),OemToAnsi("Emissao + Fornecedor")}
	EndIf

	oReport := TReport():New(cPerg,cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira seção
	oSection1 := TRSection():New(oReport,"Titulos",{"TMPFIN"},aOrdem)

	TRCell():New(oSection1,"FILORI"			, "TMPFIN", "Filial"		,"@!"				,07		)
	TRCell():New(oSection1,"EMPRESA"		, "TMPFIN", "Empresa"		,"@!"				,15		)

	If nTpRecPag = 1
		TRCell():New(oSection1,"CLIFOR"			, "TMPFIN", "Cod.Cliente"	,"@!"				,06		)
		TRCell():New(oSection1,"LOJA"	      	, "TMPFIN", "Loja"			,"@!"				,02		)
		TRCell():New(oSection1,"NOME"   		, "TMPFIN", "Cliente"		,"@!"				,15		)
	 Else
		TRCell():New(oSection1,"CLIFOR"			, "TMPFIN", "Cod.Fornec"	,"@!"				,06		)
		TRCell():New(oSection1,"LOJA"	      	, "TMPFIN", "Loja"			,"@!"				,02		)
		TRCell():New(oSection1,"NOME"   		, "TMPFIN", "Forcecedor"	,"@!"				,15		)
	EndIf	
	
	TRCell():New(oSection1,"PREFIXO"   		, "TMPFIN", "Prefixo"		,"@!"				,03		)
	TRCell():New(oSection1,"TITULO"    		, "TMPFIN", "Tiulo"			,"@!"				,09		)
	TRCell():New(oSection1,"PARCELA"   		, "TMPFIN", "Parcela"		,"@!"				,01		)
	TRCell():New(oSection1,"TIPO"      		, "TMPFIN", "Tipo"			,"@!"				,03		)
	TRCell():New(oSection1,"PEDIDO"    		, "TMPFIN", "Pedido"		,"@!"				,08		)
	TRCell():New(oSection1,"EMISSAO" 		, "TMPFIN", "Emissao"		,"@D"				,15		)
	TRCell():New(oSection1,"VCTO"    		, "TMPFIN", "Vencimento"	,"@D"				,15		)
	TRCell():New(oSection1,"BAIXA"    		, "TMPFIN", "Baixa"			,"@D"				,15		)
	TRCell():New(oSection1,"VLRTIT"			, "TMPFIN", "Val.Titulo"	,"@E 999,999,999.99"		,17		)
	TRCell():New(oSection1,"VLRBAX"			, "TMPFIN", "Val.Baixas"	,"@E 999,999,999.99"		,17		)
	TRCell():New(oSection1,"VLRSLD"			, "TMPFIN", "Saldo"			,"@E 999,999,999.99"		,17		)
	TRCell():New(oSection1,"NUMLIQ"    		, "TMPFIN", "N.Liquid."		,"@!"				,09		)
	TRCell():New(oSection1,"MOTIVO"    		, "TMPFIN", "Motivo"		,"@!"				,15		)

                                  
	oReport:SetTotalInLine(.F.)


	TRFunction():New(oSection1:Cell("VLRTIT"),"TOTAL GERAL" ,"SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection1:Cell("VLRBAX"),"TOTAL GERAL" ,"SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection1:Cell("VLRSLD"),"TOTAL GERAL" ,"SUM",,,"@E 999,999,999.99",,.F.,.T.)  

	//Aqui, farei uma quebra  por seção
	//oSection1:SetPageBreak(.T.)

Return(oReport)


        
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)
              
	Local oSection1 := oReport:Section(1)
	Local cQuery
	Local cTitulo	:= oReport:Title() 
	Local nOrdem 	:= oSection1:GetOrder()

	If nOrdem = 1 
		oBreak := TRBreak():New( oSection1,oSection1:Cell("CLIFOR"), iif(nTpRecPag = 1,"Total Cliente","Total Fornecedor"))
	ElseIf	 nOrdem = 2
		oBreak := TRBreak():New( oSection1,oSection1:Cell("VCTO") ,"Vencimento")
	ElseIf	 nOrdem = 2
		oBreak := TRBreak():New( oSection1,oSection1:Cell("EMISSAO") ,"Emissão")
	EndIf	
	
	TRFunction():New(oSection1:Cell("VLRTIT")	, , "SUM"  , oBreak, , , , .F. ,.F.,.F.  )
	TRFunction():New(oSection1:Cell("VLRBAX")	, , "SUM"  , oBreak, , , , .F. ,.F.,.F.  )
	TRFunction():New(oSection1:Cell("VLRSLD")	, , "SUM"  , oBreak, , , , .F. ,.F.,.F.  )


	cQuery := " SELECT 	FILIAL, CLIFOR, LOJA, NOME , PREFIXO, NUM, PARCELA, TIPO,
	cQuery += " PEDIDO, EMISSAO, VENCTO, DTBAIXA ,VALOR , SLDMV, VLBXLIQ, FILORIG, NUMLIQ, 
	cQuery += " 	CASE 
  	cQuery += "      WHEN TMP.TIPO IN ('AB-','IR-','IN-','IS-','PI-','CF-','CS-','FU-','FE-','RA ','NCC') THEN 
   	cQuery += "          CASE WHEN MOEDA <= 1 THEN (VALOR*-1) END 
   	cQuery += "       ELSE
	cQuery += "              CASE WHEN MOEDA <= 1 THEN  VALOR  END 
   	cQuery += "  END 'VALTIT', 
   	cQuery += "  CASE 
   	cQuery += "      WHEN TMP.TIPO IN ('AB-','IR-','IN-','IS-','PI-','CF-','CS-','FU-','FE-','RA ','NCC') THEN 
   	cQuery += "          CASE WHEN MOEDA <= 1 THEN  ((VALOR-SLDMV)*-1) END 
   	cQuery += "      ELSE 
   	cQuery += "          CASE WHEN MOEDA <= 1 THEN (VALOR-SLDMV) END 
   	cQuery += "     END 'SALDO',  
	cQuery += "  HIST, MOTBX, E1SALDO
	cQuery += "  FROM  


	If nTpRecPag = 1
		cQuery += "        (SELECT 	SE1.E1_FILIAL 'FILIAL', SE1.E1_CLIENTE 'CLIFOR', SE1.E1_LOJA 'LOJA',  
   		cQuery += " 					 	SE1.E1_NOMCLI 'NOME', 
   		cQuery += "     				SE1.E1_PREFIXO 'PREFIXO', SE1.E1_NUM 'NUM', SE1.E1_PARCELA 'PARCELA', 
   		cQuery += " 					   SE1.E1_TIPO 'TIPO', SE1.E1_PEDIDO 'PEDIDO', SE1.E1_BAIXA 'DTBAIXA',
   		cQuery += " 					   SE1.E1_EMISSAO 'EMISSAO', SE1.E1_VENCREA 'VENCTO', SE1.E1_VALOR 'VALOR',
		cQuery += "    					SE1.E1_VALLIQ 'VLBXLIQ', SE1.E1_FILORIG 'FILORIG', SE1.E1_NUMLIQ 'NUMLIQ', SE1.E1_SALDO 'E1SALDO',

   		cQuery += "    CAST ((ISNULL((SELECT  
   		cQuery += "    ISNULL(SUM(CASE WHEN E5_TIPODOC IN ('ES','MT') THEN (E5_VALOR*-1) ELSE E5_VALOR END),0) 
   		cQuery += "    FROM " + RetSqlName("SE5") + " A       
   		cQuery += "     WHERE       
   		cQuery += "      	A.D_E_L_E_T_ = ' ' AND 
   		cQuery += "      	A.E5_PREFIXO = SE1.E1_PREFIXO AND 
   		cQuery += "      	A.E5_NUMERO = SE1.E1_NUM AND 
   		cQuery += "      	A.E5_PARCELA = SE1.E1_PARCELA AND 
   		cQuery += "      	A.E5_CLIFOR = SE1.E1_CLIENTE AND 
   		cQuery += "     	A.E5_LOJA = SE1.E1_LOJA AND 
   		cQuery += "      	A.E5_TIPO = SE1.E1_TIPO AND 
   		cQuery += "      	A.E5_SITUACA  <> 'C'  AND 
   		cQuery += "        SE1.E1_MOEDA = 1 AND  
   		cQuery += "      	A.E5_TIPODOC in ('VL' , 'BA' , 'V2' , 'CP' , 'LJ', 'ES', 'DC', 'MT' )),0)) AS NUMERIC(14,2)) 'SLDMV', 

		cQuery += "    ISNULL((SELECT TOP 1  
   		cQuery += "     ISNULL( A.E5_MOTBX,'') 
   		cQuery += "     FROM " + RetSqlName("SE5") + " A       
   		cQuery += "      WHERE       
   		cQuery += "       	A.D_E_L_E_T_ = ' ' AND 
   		cQuery += "       	A.E5_PREFIXO = SE1.E1_PREFIXO AND 
		cQuery += "        	A.E5_NUMERO = SE1.E1_NUM AND 
   		cQuery += "       	A.E5_PARCELA = SE1.E1_PARCELA AND 
   		cQuery += "       	A.E5_CLIFOR = SE1.E1_CLIENTE AND 
   		cQuery += "      	A.E5_LOJA = SE1.E1_LOJA AND 
   		cQuery += "       	A.E5_TIPO = SE1.E1_TIPO AND 
   		cQuery += "       	A.E5_SITUACA  <> 'C'  AND 
   		cQuery += "        SE1.E1_MOEDA = 1 AND  
   		cQuery += "       	A.E5_TIPODOC in ('VL' , 'BA' , 'V2' , 'CP' , 'LJ', 'ES', 'DC', 'MT' )),'') 'MOTBX', 

		cQuery += " SE1.E1_MOEDA 'MOEDA',
		cQuery += " SE1.E1_HIST 'HIST' 

   		cQuery += "  FROM " + RetSqlName("SE1") + " SE1        
		cQuery += "  WHERE SE1.E1_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' 
		cQuery += "    AND SE1.E1_PREFIXO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' 
		cQuery += "    AND SE1.E1_NUM     BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' 
		cQuery += "    AND SE1.E1_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' 
		cQuery += "    AND SE1.E1_VENCREA BETWEEN '"+DTOS(mv_par09)+"' AND '"+DTOS(mv_par10)+"' 
  		If mv_par13 = 1 //abertos
  		  cQuery += "   AND SE1.E1_SALDO <> 0
  		ElseIf mv_par13 = 2 //baixados
  		  cQuery += "   AND SE1.E1_SALDO = 0
		  cQuery += "    AND SE1.E1_BAIXA   BETWEEN '"+DTOS(mv_par11)+"' AND '"+DTOS(mv_par12)+"' 
		EndIf  		  
  		cQuery += "    AND SE1.D_E_L_E_T_ = ''
		cQuery += "  ) TMP    

   Else

		cQuery += "        (SELECT 	SE2.E2_FILIAL 'FILIAL', SE2.E2_FORNECE 'CLIFOR', SE2.E2_LOJA 'LOJA',  
   		cQuery += " 					 	SE2.E2_NOMFOR 'NOME', 
   		cQuery += "     				SE2.E2_PREFIXO 'PREFIXO', SE2.E2_NUM 'NUM', SE2.E2_PARCELA 'PARCELA', 
   		cQuery += " 					   SE2.E2_TIPO 'TIPO', '' 'PEDIDO', SE2.E2_BAIXA 'DTBAIXA',
   		cQuery += " 					   SE2.E2_EMISSAO 'EMISSAO', SE2.E2_VENCREA 'VENCTO', SE2.E2_VALOR 'VALOR',
		cQuery += "    					SE2.E2_VALLIQ 'VLBXLIQ', SE2.E2_FILORIG 'FILORIG', '' 'NUMLIQ', SE2.E2_SALDO 'E1SALDO',

   		cQuery += "    CAST ((ISNULL((SELECT  
   		cQuery += "    ISNULL(SUM(CASE WHEN E5_TIPODOC IN ('ES','MT') THEN (E5_VALOR*-1) ELSE E5_VALOR END),0) 
   		cQuery += "    FROM " + RetSqlName("SE5") + " A       
   		cQuery += "     WHERE       
   		cQuery += "      	A.D_E_L_E_T_ = ' ' AND 
   		cQuery += "      	A.E5_PREFIXO = SE2.E2_PREFIXO AND 
   		cQuery += "      	A.E5_NUMERO = SE2.E2_NUM AND 
   		cQuery += "      	A.E5_PARCELA = SE2.E2_PARCELA AND 
   		cQuery += "      	A.E5_CLIFOR = SE2.E2_FORNECE AND 
   		cQuery += "     	A.E5_LOJA = SE2.E2_LOJA AND 
   		cQuery += "      	A.E5_TIPO = SE2.E2_TIPO AND 
   		cQuery += "      	A.E5_SITUACA  <> 'C'  AND 
   		cQuery += "        SE2.E2_MOEDA = 1 AND  
   		cQuery += "      	A.E5_TIPODOC in ('VL' , 'BA' , 'V2' , 'CP' , 'LJ', 'ES', 'DC', 'MT' )),0)) AS NUMERIC(14,2)) 'SLDMV', 

		cQuery += "    ISNULL((SELECT TOP 1  
   		cQuery += "     ISNULL( A.E5_MOTBX,'') 
   		cQuery += "     FROM " + RetSqlName("SE5") + " A       
   		cQuery += "      WHERE       
   		cQuery += "       	A.D_E_L_E_T_ = ' ' AND 
   		cQuery += "       	A.E5_PREFIXO = SE2.E2_PREFIXO AND 
		cQuery += "        	A.E5_NUMERO = SE2.E2_NUM AND 
   		cQuery += "       	A.E5_PARCELA = SE2.E2_PARCELA AND 
   		cQuery += "       	A.E5_CLIFOR = SE2.E2_FORNECE AND 
   		cQuery += "      	A.E5_LOJA = SE2.E2_LOJA AND 
   		cQuery += "       	A.E5_TIPO = SE2.E2_TIPO AND 
   		cQuery += "       	A.E5_SITUACA  <> 'C'  AND 
   		cQuery += "        SE2.E2_MOEDA = 1 AND  
   		cQuery += "       	A.E5_TIPODOC in ('VL' , 'BA' , 'V2' , 'CP' , 'LJ', 'ES', 'DC', 'MT' )),'') 'MOTBX', 

		cQuery += " SE2.E2_MOEDA 'MOEDA',
		cQuery += " SE2.E2_HIST 'HIST' 

   		cQuery += "  FROM " + RetSqlName("SE2") + " SE2        
		cQuery += "  WHERE SE2.E2_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' 
		cQuery += "    AND SE2.E2_PREFIXO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' 
		cQuery += "    AND SE2.E2_NUM     BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' 
		cQuery += "    AND SE2.E2_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' 
		cQuery += "    AND SE2.E2_VENCREA BETWEEN '"+DTOS(mv_par09)+"' AND '"+DTOS(mv_par10)+"' 
		cQuery += "    AND SE2.E2_BAIXA   BETWEEN '"+DTOS(mv_par11)+"' AND '"+DTOS(mv_par12)+"' 
  		If mv_par13 = 1 //abertos
  		  cQuery += "   AND SE2.E2_SALDO <> 0
  		ElseIf mv_par13 = 2 //baixados
  		  cQuery += "   AND SE2.E2_SALDO = 0
		EndIf  		  
  		cQuery += "    AND SE2.D_E_L_E_T_ = ''
		cQuery += "  ) TMP    

	EndIf

	If nOrdem = 1 
		cQuery += " ORDER BY TMP.FILIAL,TMP.CLIFOR,TMP.LOJA,TMP.PREFIXO,TMP.NUM,TMP.PARCELA,TMP.TIPO 
	ElseIf nOrdem = 2 
		cQuery += " ORDER BY TMP.FILIAL,TMP.VENCTO,TMP.CLIFOR,TMP.LOJA,TMP.PREFIXO,TMP.NUM,TMP.PARCELA,TMP.TIPO 
	ElseIf nOrdem = 3 
		cQuery += " ORDER BY TMP.FILIAL,TMP.EMISSAO,TMP.CLIFOR,TMP.LOJA,TMP.PREFIXO,TMP.NUM,TMP.PARCELA,TMP.TIPO 
	EndIf
 
	IF Select("TMPFIN") <> 0
		DbSelectArea("TMPFIN")
		DbCloseArea()
	ENDIF

	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., 'TOPCONN', TcGenQry( , ,cQuery ),"TMPFIN", .F., .T. )

	oReport:SetMeter(TMPFIN->(LastRec()))

	oReport:SetTitle(cTitulo)

	DbSelectArea("TMPFIN")
	TMPFIN->(DbGoTop())

	While TMPFIN->(!Eof())
	
		If oReport:Cancel()
			Exit
		EndIf
   
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
	
		IncProc("Imprimindo ....")
	
		oSection1:Cell("FILORI")	:SetValue(TMPFIN->FILORIG)
		oSection1:Cell("EMPRESA")	:SetValue(Alltrim(FWFilialName(cEmpAnt,TMPFIN->FILORIG,1)))
		oSection1:Cell("CLIFOR")	:SetValue(TMPFIN->CLIFOR)
		oSection1:Cell("LOJA")		:SetValue(TMPFIN->LOJA)
		oSection1:Cell("NOME")		:SetValue(TMPFIN->NOME)
		oSection1:Cell("PREFIXO")	:SetValue(TMPFIN->PREFIXO)
		oSection1:Cell("TITULO")	:SetValue(TMPFIN->NUM)
		oSection1:Cell("PARCELA")	:SetValue(TMPFIN->PARCELA)
		oSection1:Cell("TIPO")		:SetValue(TMPFIN->TIPO)
		oSection1:Cell("PEDIDO")	:SetValue(TMPFIN->PEDIDO)
		oSection1:Cell("EMISSAO")	:SetValue(stod(TMPFIN->EMISSAO))
		oSection1:Cell("VCTO")		:SetValue(stod(TMPFIN->VENCTO))
		oSection1:Cell("BAIXA")	    :SetValue(stod(TMPFIN->DTBAIXA))
		oSection1:Cell("VLRTIT")	:SetValue(TMPFIN->VALTIT)
		oSection1:Cell("VLRBAX")	:SetValue(TMPFIN->SLDMV)
		oSection1:Cell("VLRSLD")	:SetValue(TMPFIN->SALDO)
		oSection1:Cell("NUMLIQ")	:SetValue(TMPFIN->NUMLIQ)
		oSection1:Cell("MOTIVO")	:SetValue(VerMotivo(TMPFIN->MOTBX))

		oSection1:Printline()


		DbSelectArea("TMPFIN")
		TMPFIN->(dbSkip())

	End

	oReport:ThinLine()

	//finalizo a primeira seção
	oSection1:Finish()
	
	IF Select("TMPFIN") <> 0
		DbSelectArea("TMPFIN")
		DbCloseArea()
	ENDIF

	
return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
Static Function ValidPerg(cPerg)

	sAlias := Alias()
	aRegs := {}
	i := j := 0

	dbSelectArea("SX1")
	dbSetOrder(1)

				  //GRUPO,ORDEM,PERGUNTA              ,PERGUNTA,PERGUNTA,VARIAVEL,TIPO,TAMANHO,DECIMAL,PRESEL,GSC,VALID,VAR01,DEF01,DEFSPA01,DEFING01,CNT01,VAR02,DEF02,DEFSPA02,DEFING02,CNT02,VAR03,DEF03,DEFSPA03,DEFING03,CNT03,VAR04,DEF04,DEFSPA04,DEFING04,CNT04,VAR05,DEF05,DEFSPA05,DEFING05,CNT05,F3,GRPSXG
	If nTpRecPag = 1
		AADD(aRegs,{cPerg,"01","Cliente de        ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
		AADD(aRegs,{cPerg,"02","Cliente Ate       ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
	Else
		AADD(aRegs,{cPerg,"01","Fornec. de        ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
		AADD(aRegs,{cPerg,"02","Fornec. Ate       ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
	EndIf
	AADD(aRegs,{cPerg,"03","Prefixo de        ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Prefixo Ate       ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Titulo  de        ?","","","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Titulo  Ate       ?","","","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Dta Emissao  De   ?","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Dta Emissao  Ate  ?","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Dta Vencto   De   ?","","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"10","Dta Vencto   Ate  ?","","","mv_chA","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"11","Dta Baixa    De   ?","","","mv_chB","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Dta Baixa    Ate  ?","","","mv_chC","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","Tipo Saldos       ?","","","mv_chD","N",01,0,0,"C","","mv_par13","Abertos","","","","","Baixados","","","","","Ambos","","","","","",""})


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

Return

Static Function VerMotivo(cMotivo)

	Local cDescMot		:= ""
	Local aMotBx 		:= ReadMotBx()
	Local aMotBaixas 	:= {}
	Local nI				:= 0
	
	For nI := 1 to Len(aMotBx)
		AADD( aMotBaixas,{substr(aMotBx[nI],01,03),substr(aMotBx[nI],07,10)})
	Next


	If ! Empty(cMotivo)
		If cMotivo == "NOR"
			cDescMot := OemToAnsi("Normal")
		Elseif cMotivo == "DEV"
			cDescMot := OemToAnsi("Devolução")
		Elseif cMotivo == "DAC"
			cDescMot := OemToAnsi("Dação")
		Elseif cMotivo == "VEN"
			cDescMot := OemToAnsi("Vendor")
		Elseif cMotivo == "CMP"
			cDescMot := OemToAnsi("Compensação")
		Elseif cMotivo == "CEC"
			cDescMot := OemToAnsi("Comp Carteiras")
		Elseif cMotivo == "DEB"
			cDescMot := OemToAnsi("Debito C/C")
		Elseif cMotivo == "LIQ"
			cDescMot := OemToAnsi("Liquidação")
		Elseif cMotivo == "FAT"
			cDescMot := OemToAnsi("Faturado")
		Else
			IF (nT := ascan(aMotBaixas,{|x| x[1]= cMotivo })) > 0
				cDescMot := aMotBaixas [nT][2]
			Endif
		Endif
	Endif
		

Return(cDescMot)						