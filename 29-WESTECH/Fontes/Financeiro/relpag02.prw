
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relpag02()
	Local oReport := nil
	Local cPerg:= "RELPAG02"
	
	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.T.)	 
		
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oSection3:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Pagamento efetivo",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()    
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F. 	
	
	
	//Monstando a primeira seção
	//Neste exemplo, a primeira seção será composta por duas colunas, código da NCM e sua descrição
	//Iremos disponibilizar para esta seção apenas a tabela SYD, pois quando você for em personalizar
	//e entrar na primeira seção, você terá todos os outros campos disponíveis, com isso, será
	//permitido a inserção dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas você
	//terá toda a liberdade de modificá-los via relatorio. 
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SE5"}, 			, .F.	, 	.T.)
	
	TRCell():New(oSection1,"TMP_NATUREZA"	,"TRBFIN","Naureza"	   		,"@!"				,13)  
	TRCell():New(oSection1,"TMP_DESCRI"		,"TRBFIN","Descr.Nat."	  	,"@!"				,30)  
		
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Contas a Pagar - Geral", {"SE2"}, NIL, .F., .T.)   
	 TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBFIN","Contrato"		,"@!"				,30)
	TRCell():New(oSection2,"TMP_NTITULO"	,"TRBFIN","Título"			,"@!"				,15)
	TRCell():New(oSection2,"TMP_DATA"		,"TRBFIN","Data"			,"@!"				,19)
	TRCell():New(oSection2,"TMP_VALOR"		,"TRBFIN","Valor"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_FORNECE"	,"TRBFIN","Cod.Forn."		,"@!"				,10)
	TRCell():New(oSection2,"TMP_EMPRESA"	,"TRBFIN","Empresa"			,"@!"				,40)
	//TRCell():New(oSection2,"TMP_HISTOR"		,"TRBFIN","Historico"		,"@!"				,40)
	TRCell():New(oSection2,"TMP_TIPO"		,"TRBFIN","Tipo"			,""					,6)
	TRCell():New(oSection2,"TMP_BANCO"		,"TRBFIN","Banco"			,""					,15)
	TRCell():New(oSection2,"TMP_AGENCIA"	,"TRBFIN","Agencia"			,""					,20)
	TRCell():New(oSection2,"TMP_NOME"		,"TRBFIN","Nome"			,""					,30)
	TRCell():New(oSection2,"TMP_CONTA"		,"TRBFIN","Conta"			,""					,15)
	
	oSection3:= TRSection():New(oReport, "Contas a Pagar - Geral", {"SE5"}, NIL, .F., .T.)   
	TRCell():New(oSection3,""				,"TRBFIN2",""				,"@!"				,28)
	//TRCell():New(oSection3,"E5_TIPODOC"		,"TRBFIN2","Título"			,"@!"				,15)
	TRCell():New(oSection3,"E5_NUMERO"		,"TRBFIN","Título"			,"@!"				,15)
	TRCell():New(oSection3,"TP_DATA"		,"TRBFIN2","Data"			,"@!"				,15)
	TRCell():New(oSection3,"E5_VALOR"		,"TRBFIN2","Valor"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection3,"E5_DOCUMEN"		,"TRBFIN2","Documento"		,"@!"				,25)
	//TRCell():New(oSection2,"TMP_HISTOR"		,"TRBFIN","Historico"		,"@!"				,40)
	//TRCell():New(oSection3,"E5_TIPO"		,"TRBFIN2","Tipo"			,""					,6)
			
	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_NATUREZA) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	

	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local oSection3 := oReport:Section(3)	 
	Local cQuery    := ""	
	Local cQuery2    := ""		
	Local cNcm      := "" 
	Local cNat		:= ""  
	Local lPrim 	:= .T.	
	Local cTitulo 	:= ""
	Local cFornece	:= ""
	oSection2:SetHeaderSection(.T.)
	//oSection3:SetHeaderSection(.T.)
	
	//Monto minha consulta conforme parametros passado
	// ------ CONTAS A RECEBER FULL
 
 
	
	cQuery := " SELECT DISTINCT  E2_XXIC AS 'TMP_CONTRATO', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATA', IIF(E5_RECPAG = 'R', -E5_VALOR, E5_VALOR)  AS 'TMP_VALOR', "
	cQuery += " ED_DESCRIC AS 'TMP_DESCRI', E5_NATUREZ AS 'TMP_NATUREZA', E2_BASEIRF AS 'TMP_BASEIRF', E2_BASEPIS AS 'TMP_BASEPIS', "
	cQuery += " E5_FORNECE AS 'TMP_FORNECE', E2_NOMFOR AS 'TMP_EMPRESA', "
	cQuery += " E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' "
	cQuery += " FROM SE5010 "
	cQuery += " LEFT JOIN SE2010 ON SE2010.E2_NUM = SE5010.E5_NUMERO AND SE2010.E2_FORNECE = SE5010.E5_FORNECE AND SE2010.E2_LOJA = SE5010.E5_LOJA "
	cQuery += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA "     
	cQuery += "	LEFT JOIN SED010 ON SED010.ED_CODIGO = E5_NATUREZ "
    cQuery += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND E5_VALOR <> 0 AND " 
	 cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
	 cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' AND  "    
	 cQuery += " E5_FORNECE		  >= '" + MV_PAR03 + "' AND  "
	 cQuery += " E5_FORNECE    	  <= '" + MV_PAR04 + "' AND  " 
	 cQuery += " E5_NATUREZ		  >= '" + MV_PAR05 + "' AND  "
	 cQuery += " E5_NATUREZ    	  <= '" + MV_PAR06 + "' AND  "
	 cQuery += " E5_DATA    >= '" + DTOS(MV_PAR07) + "' AND  "
	 cQuery += " E5_DATA    <= '" + DTOS(MV_PAR08) + "' AND  "
	 cQuery += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('PA','VL') AND E5_BANCO <> '' OR " 
	 cQuery += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND E5_VALOR <> 0 AND "  
	 cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
	 cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' AND  "   
	 cQuery += " E5_FORNECE		  >= '" + MV_PAR03 + "' AND  "
	 cQuery += " E5_FORNECE    	  <= '" + MV_PAR04 + "' AND  "  
	 cQuery += " E5_NATUREZ		  >= '" + MV_PAR05 + "' AND  "
	 cQuery += " E5_NATUREZ    	  <= '" + MV_PAR06 + "' AND  "
	 cQuery += " E5_DATA    >= '" + DTOS(MV_PAR07) + "' AND  "
	 cQuery += " E5_DATA    <= '" + DTOS(MV_PAR08) + "' AND  "
	 cQuery += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' "
	 cQuery += " OR "
	 cQuery += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND E5_VALOR <> 0 AND "  
	 cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
	 cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' AND  "   
	 cQuery += " E5_FORNECE		  >= '" + MV_PAR03 + "' AND  "
	 cQuery += " E5_FORNECE    	  <= '" + MV_PAR04 + "' AND  "  
	 cQuery += " E5_NATUREZ		  >= '" + MV_PAR05 + "' AND  "
	 cQuery += " E5_NATUREZ    	  <= '" + MV_PAR06 + "' AND  "
	 cQuery += " E5_DATA    >= '" + DTOS(MV_PAR07) + "' AND  "
	 cQuery += " E5_DATA    <= '" + DTOS(MV_PAR08) + "' AND  "
	 cQuery += " E5_RECPAG = 'R' AND E5_TIPO IN ('PA') AND E5_MOTBX IN ('DEB') AND E5_BANCO <> '' ORDER BY 6,3 "
 
 //cQuery += "E5_RECPAG = 'P' AND E2_BAIXA <> '' AND E5_TIPODOC IN ('PA','VL') " 

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBFIN") <> 0
		DbSelectArea("TRBFIN")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBFIN"	
	
	dbSelectArea("TRBFIN")
	TRBFIN->(dbGoTop())
	
	oReport:SetMeter(TRBFIN->(LastRec()))	
	

	//****************************************
	cQuery2 := " SELECT E5_TIPODOC, E5_TIPO, E5_MOTBX, CAST(E5_DATA AS DATE) AS 'TP_DATA', E5_VALOR, E5_DOCUMEN, E5_BANCO, E5_RECPAG, E5_NUMERO, E5_FORNECE "
	cQuery2 += "  FROM SE5010 " 
	cQuery2 += "  WHERE "
	cQuery2 += " SE5010.D_E_L_E_T_ <> '*' AND E5_TIPODOC = 'BA' AND E5_MOTBX = 'CMP' AND E5_BANCO = '' AND "
	cQuery2 += " E5_FORNECE		  >= '" + MV_PAR03 + "' AND  "
	cQuery2 += " E5_FORNECE    	  <= '" + MV_PAR04 + "' AND  " 
	cQuery2 += " E5_DATA    >= '" + DTOS(MV_PAR07) + "' AND  "
	cQuery2 += " E5_DATA    <= '" + DTOS(MV_PAR08) + "'  "
	cQuery2 += " ORDER BY E5_DATA "
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBFIN2") <> 0
		DbSelectArea("TRBFIN2")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery2 NEW ALIAS "TRBFIN2"	
	
	dbSelectArea("TRBFIN2")
	TRBFIN2->(dbGoTop())
	
	oReport:SetMeter(TRBFIN2->(LastRec()))
	
	
	//*****************************************

	//Irei percorrer todos os meus registros
	While TRBFIN->(!Eof())
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBFIN->TMP_NATUREZA
	
		IncProc("Imprimindo Recebimento Efetito"+alltrim(TRBFIN->TMP_NATUREZA))
		
		//imprimo a primeira seção				
	
		oSection1:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)
		oSection1:Cell("TMP_DESCRI"):SetValue(TRBFIN->TMP_DESCRI)
					
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_NATUREZA == cNcm 
			oReport:IncMeter()		

			IncProc("Imprimindo Recebimento efetivo "+alltrim(TRBFIN->TMP_NATUREZA))
			
			cTitulo := alltrim(TRBFIN->TMP_NTITULO)
			cFornece:= alltrim(TRBFIN->TMP_FORNECE)
			
			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)	
			oSection2:Cell("TMP_NTITULO"):SetValue(TRBFIN->TMP_NTITULO)	
			oSection2:Cell("TMP_DATA"):SetValue(TRBFIN->TMP_DATA)	
			oSection2:Cell("TMP_VALOR"):SetValue(TRBFIN->TMP_VALOR)  
			oSection2:Cell("TMP_FORNECE"):SetValue(TRBFIN->TMP_FORNECE)
			oSection2:Cell("TMP_EMPRESA"):SetValue(TRBFIN->TMP_EMPRESA)
			//oSection2:Cell("TMP_HISTOR"):SetValue(TRBFIN->TMP_HISTOR)
			oSection2:Cell("TMP_TIPO"):SetValue(TRBFIN->TMP_TIPO)
			oSection2:Cell("TMP_BANCO"):SetValue(TRBFIN->TMP_BANCO)
			oSection2:Cell("TMP_AGENCIA"):SetValue(TRBFIN->TMP_AGENCIA)
			oSection2:Cell("TMP_NOME"):SetValue(TRBFIN->TMP_NOME)
			oSection2:Cell("TMP_CONTA"):SetValue(TRBFIN->TMP_CONTA)
			
			oSection2:Printline()
			
			
			//inicializo a segunda seção
			oSection3:init()
			dbSelectArea("TRBFIN2")
			TRBFIN2->(dbGoTop())
			
			While TRBFIN2->(!Eof()) 
				
				oReport:IncMeter()		
				
				IncProc("Imprimindo Recebimento efetivo "+alltrim(TRBFIN2->E5_NUMERO))
				
				if alltrim(TRBFIN2->E5_numero) == cTitulo .AND. alltrim(TRBFIN2->E5_FORNECE) == cFornece 
					oSection3:Cell("E5_NUMERO"):SetValue(TRBFIN2->E5_NUMERO)
					oSection3:Cell("TP_DATA"):SetValue(TRBFIN2->TP_DATA)
					oSection3:Cell("E5_DOCUMEN"):SetValue(TRBFIN2->E5_DOCUMEN)	
					oSection3:Cell("E5_VALOR"):SetValue(TRBFIN2->E5_VALOR)	
					oSection3:Printline()
					//msginfo( TRBFIN2->E5_DOCUMEN )
				endif
				TRBFIN2->(dbSkip())
				
			enddo
			
			oReport:ThinLine()
		
			
			TRBFIN->(dbSkip())
 		EndDo	
 		oReport:ThinLine()
 		oSection3:Finish()
 			
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		
	Enddo
	oSection1:Finish()
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
   	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Fornecedor de ?"	  , "", "", "mv_ch3", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par03")
	putSx1(cPerg, "04", "Fornecedor até?"	  , "", "", "mv_ch4", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par04")
	putSx1(cPerg, "05", "Natureza de ?"	  	, "", "", "mv_ch5", "C", 13, 0, 0, "G", "", "SED", "", "", "mv_par05")
	putSx1(cPerg, "06", "Natureza até?"	  	, "", "", "mv_ch6", "C", 13, 0, 0, "G", "", "SED", "", "", "mv_par06")
	putSx1(cPerg, "07", "Data de?"  	  	  , "", "", "mv_ch7", "D", 08, 0, 0, "G", "", "", "", "", "mv_par07")
	putSx1(cPerg, "08", "Data ate?"  	      , "", "", "mv_ch8", "D", 08, 0, 0, "G", "", "", "", "", "mv_par08")
return



