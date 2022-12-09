#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'


User Function relEmp()

	Local oReport 	:= nil
	Local cPerg:= Padr("relEmp",10)
	
	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.F.)
	
	PswOrder( 1 ) // Ordena por user ID //
        
	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf 
	
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
	
	
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	
	Local oSection3:= Nil
	Local oSection4:= Nil
	
	Local oSection5:= Nil
	Local oSection6:= Nil
	Local oSection7:= Nil
	
	
	
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Controle de Empréstimo",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()     
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
	TRCell():New(oSection1,"TMP_BANCO"		,"TRBFIN"	,	"Nº Banco"  		,"@!"	,	6)
	TRCell():New(oSection1,"TMP_BCONOM"		,"TRBFIN"	,	"Banco"  			,"@!"	,	30)
	TRCell():New(oSection1,"TMP_AGENCIA"	,"TRBFIN"	,	"Agência"  			,"@!"	,	10)
	TRCell():New(oSection1,"TMP_CONTA"		,"TRBFIN"	,	"Conta"  			,"@!"	,	15)
		
			
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Controle de Empréstimo", {"SE5"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_DATA"		,"TRBFIN","Data"			,"@!"				,18)
	TRCell():New(oSection2,"TMP_NATUREZA"	,"TRBFIN","Natureza"		,"@!"				,18)
	TRCell():New(oSection2,"TMP_CREDITO"	,"TRBFIN","Entrada"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_DEBITO"		,"TRBFIN","Saída"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_SALDO"		,"TRBFIN","Saldo"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	
	oSection3:= TRSection():New(oReport, 	"NCM2",	 	{"SE5"}, 			, .F.	, 	.T.)
	TRCell():New(oSection3,"TMP_BANCO2"		,"TRBFIN2"	,	"Nº Banco"  		,"@!"	,	6)
	TRCell():New(oSection3,"TMP_BCONOM2"	,"TRBFIN2"	,	"Banco"  			,"@!"	,	30)
	TRCell():New(oSection3,"TMP_AGENCIA2"	,"TRBFIN2"	,	"Agência"  			,"@!"	,	10)
	TRCell():New(oSection3,"TMP_CONTA2"		,"TRBFIN2"	,	"Conta"  			,"@!"	,	15)
		
			
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection4:= TRSection():New(oReport, "Controle de Empréstimo", {"SE5"}, NIL, .F., .T.)
	TRCell():New(oSection4,"TMP_DATA2"		,"TRBFIN2","Data"			,"@!"				,18)
	TRCell():New(oSection4,"TMP_NATUREZA2"	,"TRBFIN2","Natureza"		,"@!"				,18)
	TRCell():New(oSection4,"TMP_CREDITO2"	,"TRBFIN2","Entrada"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection4,"TMP_DEBITO2"	,"TRBFIN2","Saída"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection4,"TMP_SALDO2"		,"TRBFIN2","Saldo"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	
	
	oSection5:= TRSection():New(oReport, "Controle de Empréstimo", {"SE5"}, NIL, .F., .T.)
	TRCell():New(oSection5,"TMP_TOTENT"	,"TRBFIN5","SubTotal Entrada"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection5,"TMP_TOTSAI"	,"TRBFIN5","SubTotal Saída"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection5,"TMP_SLDTOT"	,"TRBFIN5","Saldo"					,"@E 999,999,999.99",22,,,,,"RIGHT")
	
	oSection6:= TRSection():New(oReport, "Controle de Empréstimo", {"SE5"}, NIL, .F., .T.)
	TRCell():New(oSection6,"TMP_TOTENT6"	,"TRBFIN6","SubTotal Entrada"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection6,"TMP_TOTSAI6"	,"TRBFIN6","SubTotal Saída"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection6,"TMP_SLDTOT6"	,"TRBFIN6","Saldo"					,"@E 999,999,999.99",22,,,,,"RIGHT")
	
		
	oSection7:= TRSection():New(oReport, "Controle de Empréstimo", {"SE5"}, NIL, .F., .T.)
	TRCell():New(oSection7,"TMP_TOTENT7"	,"TRBFIN7","Total Entrada"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection7,"TMP_TOTSAI7"	,"TRBFIN7","Total Saída"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection7,"TMP_SLDTOT7"	,"TRBFIN7","Saldo"				,"@E 999,999,999.99",22,,,,,"RIGHT")

	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")	
	
	oSection3:SetPageBreak(.F.)
	oSection3:SetTotalText(" ")	
	
	oSection5:SetPageBreak(.F.)
	oSection5:SetTotalText(" ")
	
	
	oSection6:SetPageBreak(.F.)
	oSection6:SetTotalText(" ")	
	
	oSection7:SetPageBreak(.F.)
	oSection7:SetTotalText(" ")
	
			
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	
	
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4)	
	
	Local oSection5 := oReport:Section(5)
	Local oSection6 := oReport:Section(6)	
	Local oSection7 := oReport:Section(7)
	
	 
	Local cQuery    := ""		
	Local cNcm      := "" 
	
	Local cQuery2    := ""		
	Local cNcm2      := "" 
	
	Local cQuery5   := ""
	Local cQuery6   := ""	
	Local cQuery7   := ""

	
	  
	Local lPrim 	:= .T.	
	oSection2:SetHeaderSection(.T.)
	oSection5:SetHeaderSection(.T.)
	oSection6:SetHeaderSection(.F.)
	
	
	PswOrder( 1 ) // Ordena por user ID //
        
	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf       

	//Monto minha consulta conforme parametros passado
	// ------ CONTAS A PAGAR Provisões
	
	
	
	cQuery := "SELECT  CAST(convert(varchar(30),E5_DATA,102) AS DATE) AS 'TMP_DATA', E5_MOEDA AS 'TMP_MOEDA', E5_NATUREZ AS 'TMP_NATUREZA', E5_BANCO AS 'TMP_BANCO', A6_NOME AS 'TMP_BCONOM', "
	cQuery += "		 E5_AGENCIA AS 'TMP_AGENCIA', E5_CONTA AS 'TMP_CONTA', E5_RECPAG AS 'TMP_RECPAG', "
	cQuery += "		 IIF(E5_RECPAG = 'P', E5_VALOR, 0) AS 'TMP_CREDITO', IIF(E5_RECPAG = 'R', -E5_VALOR, 0)  AS 'TMP_DEBITO', "
	cQuery += "		 SUM(IIF(E5_RECPAG = 'P', E5_VALOR, -E5_VALOR)) OVER(ORDER BY E5_DATA  ROWS UNBOUNDED PRECEDING)  AS 'TMP_SALDO' "
	cQuery += "	FROM SE5010 "
	cQuery += "	INNER JOIN SA6010 ON SE5010.E5_BANCO = SA6010.A6_COD " 
	cQuery += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND E5_BANCO IN ('115')  ORDER BY  E5_DATA "
	
	cQuery2 := "SELECT  CAST(convert(varchar(30),E5_DATA,102) AS DATE) AS 'TMP_DATA2', E5_MOEDA AS 'TMP_MOEDA2', E5_NATUREZ AS 'TMP_NATUREZA2', E5_BANCO AS 'TMP_BANCO2', A6_NOME AS 'TMP_BCONOM2', "
	cQuery2 += "		 E5_AGENCIA AS 'TMP_AGENCIA2', E5_CONTA AS 'TMP_CONTA2', E5_RECPAG AS 'TMP_RECPAG2', "
	cQuery2 += "		 IIF(E5_RECPAG = 'P', E5_VALOR, 0) AS 'TMP_CREDITO2', IIF(E5_RECPAG = 'R', -E5_VALOR, 0)  AS 'TMP_DEBITO2', "
	cQuery2 += "		 SUM(IIF(E5_RECPAG = 'P', E5_VALOR, -E5_VALOR)) OVER(ORDER BY E5_DATA  ROWS UNBOUNDED PRECEDING)  AS 'TMP_SALDO2' "
	cQuery2 += "	FROM SE5010 "
	cQuery2 += "	INNER JOIN SA6010 ON SE5010.E5_BANCO = SA6010.A6_COD " 
	cQuery2 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND E5_BANCO IN ('117')  ORDER BY  E5_DATA "
	
	cQuery5 := "SELECT   SUM(IIF(E5_RECPAG = 'P', E5_VALOR, 0)) AS 'TMP_TOTENT', "
	cQuery5 += "		 SUM(IIF(E5_RECPAG = 'R', -E5_VALOR, 0))  AS 'TMP_TOTSAI', "
	cQuery5 += "		 SUM(IIF(E5_RECPAG = 'P', E5_VALOR, -E5_VALOR)) AS 'TMP_SLDTOT' "
	cQuery5 += "	FROM SE5010 
	cQuery5 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND E5_BANCO IN ('115')  GROUP BY E5_BANCO " 
	
	cQuery6 := "SELECT   SUM(IIF(E5_RECPAG = 'P', E5_VALOR, 0)) AS 'TMP_TOTENT6', "
	cQuery6 += "		 SUM(IIF(E5_RECPAG = 'R', -E5_VALOR, 0))  AS 'TMP_TOTSAI6', "
	cQuery6 += "		 SUM(IIF(E5_RECPAG = 'P', E5_VALOR, -E5_VALOR)) AS 'TMP_SLDTOT6' "
	cQuery6 += "	FROM SE5010 
	cQuery6 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND E5_BANCO IN ('117')  GROUP BY E5_BANCO " 
	
	
	cQuery7 := "SELECT   SUM(IIF(E5_RECPAG = 'P', E5_VALOR, 0)) AS 'TMP_TOTENT7', "
	cQuery7 += "		 SUM(IIF(E5_RECPAG = 'R', -E5_VALOR, 0))  AS 'TMP_TOTSAI7', "
	cQuery7 += "		 SUM(IIF(E5_RECPAG = 'P', E5_VALOR, -E5_VALOR)) AS 'TMP_SLDTOT7' "
	cQuery7 += "	FROM SE5010 
	cQuery7 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND E5_BANCO IN ('115','117')  " 
	
	
	
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

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBFIN->TMP_BANCO
		IncProc("Imprimindo Controle de Empréstimo"+alltrim(TRBFIN->TMP_BANCO))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_BANCO"):SetValue(TRBFIN->TMP_BANCO)
		oSection1:Cell("TMP_BCONOM"):SetValue(TRBFIN->TMP_BCONOM)
		oSection1:Cell("TMP_AGENCIA"):SetValue(TRBFIN->TMP_AGENCIA)
		oSection1:Cell("TMP_CONTA"):SetValue(TRBFIN->TMP_CONTA)
		
	
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_BANCO == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo Controle de Empréstimo "+alltrim(TRBFIN->TMP_BANCO))
			
				
			oSection2:Cell("TMP_DATA"):SetValue(TRBFIN->TMP_DATA)	
			oSection2:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)	
						
			oSection2:Cell("TMP_CREDITO"):SetValue(TRBFIN->TMP_CREDITO)
			oSection2:Cell("TMP_CREDITO"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_DEBITO"):SetValue(TRBFIN->TMP_DEBITO)
			oSection2:Cell("TMP_DEBITO"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_SALDO"):SetValue(TRBFIN->TMP_SALDO)
			oSection2:Cell("TMP_SALDO"):SetAlign("RIGHT")
			
			

			oSection2:Printline()

 			TRBFIN->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
	//*****************************************************************************
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

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection3:Init()

		oReport:IncMeter()
					
		cNcm2 	:= TRBFIN2->TMP_BANCO2
		IncProc("Imprimindo Controle de Empréstimo"+alltrim(TRBFIN2->TMP_BANCO2))
		
		//imprimo a primeira seção				
		oSection3:Cell("TMP_BANCO2"):SetValue(TRBFIN2->TMP_BANCO2)
		oSection3:Cell("TMP_BCONOM2"):SetValue(TRBFIN2->TMP_BCONOM2)
		oSection3:Cell("TMP_AGENCIA2"):SetValue(TRBFIN2->TMP_AGENCIA2)
		oSection3:Cell("TMP_CONTA2"):SetValue(TRBFIN2->TMP_CONTA2)
		
	
		oSection3:Printline()
		
		//inicializo a segunda seção
		oSection4:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN2->TMP_BANCO2 == cNcm2
			oReport:IncMeter()		
		
			IncProc("Imprimindo Controle de Empréstimo "+alltrim(TRBFIN2->TMP_BANCO2))
			
				
			oSection4:Cell("TMP_DATA2"):SetValue(TRBFIN2->TMP_DATA2)	
			oSection4:Cell("TMP_NATUREZA2"):SetValue(TRBFIN2->TMP_NATUREZA2)	
						
			oSection4:Cell("TMP_CREDITO2"):SetValue(TRBFIN2->TMP_CREDITO2)
			oSection4:Cell("TMP_CREDITO2"):SetAlign("RIGHT")
			
			oSection4:Cell("TMP_DEBITO2"):SetValue(TRBFIN2->TMP_DEBITO2)
			oSection4:Cell("TMP_DEBITO2"):SetAlign("RIGHT")
			
			oSection4:Cell("TMP_SALDO2"):SetValue(TRBFIN2->TMP_SALDO2)
			oSection4:Cell("TMP_SALDO2"):SetAlign("RIGHT")
			
			

			oSection4:Printline()

 			TRBFIN2->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection4:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection3:Finish()
	Enddo
	
	//*****************************************************************
	IF Select("TRBFIN5") <> 0
		DbSelectArea("TRBFIN5")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery5 NEW ALIAS "TRBFIN5"	
	
	dbSelectArea("TRBFIN5")
	TRBFIN5->(dbGoTop())
	
	oReport:SetMeter(TRBFIN5->(LastRec()))	

	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
		//Irei percorrer todos os meus registros
		
		//inicializo a primeira seção
		oSection5:Init()
	
		oReport:IncMeter()
						
			
		IncProc("Imprimindo Controle de Empréstimo")
			
		//imprimo a primeira seção				
		oSection5:Cell("TMP_TOTENT"):SetValue(TRBFIN5->TMP_TOTENT)
		oSection5:Cell("TMP_TOTSAI"):SetValue(TRBFIN5->TMP_TOTSAI)
		oSection5:Cell("TMP_SLDTOT"):SetValue(TRBFIN5->TMP_SLDTOT)
		
		oSection5:Printline()
		
		TRBFIN5->(dbSkip())	
	 	//imprimo uma linha para separar uma NCM de outra
	 	oReport:ThinLine()
	 	//finalizo a primeira seção
		oSection5:Finish()
	
 			
	Enddo
	
	//*****************************************************************
	IF Select("TRBFIN6") <> 0
		DbSelectArea("TRBFIN6")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery6 NEW ALIAS "TRBFIN6"	
	
	dbSelectArea("TRBFIN6")
	TRBFIN6->(dbGoTop())
	
	oReport:SetMeter(TRBFIN6->(LastRec()))	

	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
		//Irei percorrer todos os meus registros
		
		//inicializo a primeira seção
		oSection6:Init()
	
		oReport:IncMeter()
						
			
		IncProc("Imprimindo Controle de Empréstimo")
			
		//imprimo a primeira seção				
		oSection6:Cell("TMP_TOTENT6"):SetValue(TRBFIN6->TMP_TOTENT6)
		oSection6:Cell("TMP_TOTSAI6"):SetValue(TRBFIN6->TMP_TOTSAI6)
		oSection6:Cell("TMP_SLDTOT6"):SetValue(TRBFIN6->TMP_SLDTOT6)
		
		oSection6:Printline()
		
		TRBFIN6->(dbSkip())	
	 	//imprimo uma linha para separar uma NCM de outra
	 	oReport:ThinLine()
	 	//finalizo a primeira seção
		oSection6:Finish()
	
 			
	Enddo
	


	//*****************************************************************
	IF Select("TRBFIN7") <> 0
		DbSelectArea("TRBFIN7")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery7 NEW ALIAS "TRBFIN7"	
	
	dbSelectArea("TRBFIN7")
	TRBFIN7->(dbGoTop())
	
	oReport:SetMeter(TRBFIN7->(LastRec()))	
	
	
	
	//Irei percorrer todos os meus registros
	
	//inicializo a primeira seção
	oSection7:Init()

	oReport:IncMeter()
					
		
	IncProc("Imprimindo Controle de Empréstimo")
		
	//imprimo a primeira seção				
	oSection7:Cell("TMP_TOTENT7"):SetValue(TRBFIN7->TMP_TOTENT7)
	oSection7:Cell("TMP_TOTSAI7"):SetValue(TRBFIN7->TMP_TOTSAI7)
	oSection7:Cell("TMP_SLDTOT7"):SetValue(TRBFIN7->TMP_SLDTOT7)
	
	oSection7:Printline()
		
 	//imprimo uma linha para separar uma NCM de outra
 	oReport:ThinLine()
 	//finalizo a primeira seção
	oSection7:Finish()
	

Return



static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Banco de ?"	  , "", "", "mv_ch1", "C", 3, 0, 0, "G", "", "SA6", "", "", "mv_par01")
	putSx1(cPerg, "02", "Banco até?"	  , "", "", "mv_ch2", "C", 3, 0, 0, "G", "", "SA6", "", "", "mv_par02")
	
return



