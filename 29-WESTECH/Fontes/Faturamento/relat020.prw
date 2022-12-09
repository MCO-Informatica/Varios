#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat020()
	Local oReport := nil
	Local cPerg:= Padr("RELAT020",10)
	
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
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Tributos (Contas a Pagar)",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SE2"}, 			, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_DTVENC",	"TRBFIN",	"Ano/Mês Entrada"  		,"@!"	,	16)
	
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Tributos (Contas a Pagar)", {"SE2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_NATUREZA"	,"TRBFIN","Código"			,"@!"				,10)
	TRCell():New(oSection2,"TMP_DESCNAT"	,"TRBFIN","Natureza"		,"@!"				,30)
	TRCell():New(oSection2,"TMP_TIPO"		,"TRBFIN","Tipo"			,"@!"				,03)
	TRCell():New(oSection2,"TMP_VALOR"		,"TRBFIN","Valor"			,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_SALDO"		,"TRBFIN","Saldo"			,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_VENCTO"		,"TRBFIN","Vencimento"		,""					,12)   
	TRCell():New(oSection2,"TMP_VENCREAL"	,"TRBFIN","Venc. REAL"		,""					,12)
	TRCell():New(oSection2,"TMP_BAIXA"		,"TRBFIN","Baixa"			,""					,12)
	

	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_DTVENC) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_SALDO")		,NIL,"SUM",oBreak1,,,,.F.,.T.)

	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	
	oSection2:SetHeaderSection(.T.)
	      

	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO
	
	cQuery := "SELECT	E2_TIPO as 'TMP_TIPO', E2_NATUREZ as 'TMP_NATUREZA', ED_DESCRIC as 'TMP_DESCNAT',   "
	cQuery += "		CAST(E2_VENCTO as Date) as 'TMP_VENCTO',  "
	cQuery += "		CAST(E2_VENCREA as Date) as 'TMP_VENCREAL',  "
	cQuery += "		IIF(E2_TIPO = 'PA' AND E2_BAIXA <> '', -E2_VALOR, E2_VALOR)  as 'TMP_VALOR', "
	cQuery += "		E2_SALDO AS 'TMP_SALDO',  "
	cQuery += "		E2_BAIXA AS 'TMP_BAIXA',  "
	cQuery += "		CONVERT(VARCHAR(4),YEAR(E2_VENCTO))+'/'+CONVERT(VARCHAR(2),MONTH(E2_VENCTO)) AS 'TMP_DTVENC' "
	cQuery += "	FROM SE2010  "  
	cQuery += "	INNER JOIN SED010 ON SE2010.E2_NATUREZ = ED_CODIGO "
	cQuery += "	WHERE  SE2010.D_E_L_E_T_ <> '*' AND  "
	cQuery += " E2_VENCTO    >= '" + DTOS(MV_PAR01) + "' AND  " 
	cQuery += " E2_VENCTO    <= '" + DTOS(MV_PAR02) + "' AND  "  
	cQuery += " E2_VENCREA   >= '" + DTOS(MV_PAR03) + "' AND  " 
	cQuery += " E2_VENCREA   <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " E2_NATUREZ    >= '" + MV_PAR05 + "' AND  " 
	cQuery += " E2_NATUREZ    <= '" + MV_PAR06 + "'  " 
	cQuery += "	ORDER BY  E2_VENCTO, E2_NATUREZ, E2_BAIXA   "
	
	

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
					
		cNcm 	:= TRBFIN->TMP_DTVENC
		IncProc("Tributos"+alltrim(TRBFIN->TMP_DTVENC))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_DTVENC"):SetValue(TRBFIN->TMP_DTVENC)

		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_DTVENC == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo Tributos (Contas a Pagar)"+alltrim(TRBFIN->TMP_DTVENC))
			//oSection2:Cell("TMP_DOC"):SetValue(TRBFIN->TMP_DOC)	
			oSection2:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)	
			oSection2:Cell("TMP_DESCNAT"):SetValue(TRBFIN->TMP_DESCNAT)
			oSection2:Cell("TMP_TIPO"):SetValue(TRBFIN->TMP_TIPO)
				
			oSection2:Cell("TMP_VALOR"):SetValue(TRBFIN->TMP_VALOR)
			oSection2:Cell("TMP_VALOR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_SALDO"):SetValue(TRBFIN->TMP_SALDO)
			oSection2:Cell("TMP_SALDO"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_VENCTO"):SetValue(TRBFIN->TMP_VENCTO)
			
			oSection2:Cell("TMP_VENCREAL"):SetValue(TRBFIN->TMP_VENCREAL)
			
			IF TMP_BAIXA = ""
				oSection2:Cell("TMP_BAIXA"):SetValue("")
			ELSE
				oSection2:Cell("TMP_BAIXA"):SetValue(Substr(TRBFIN->TMP_BAIXA,7,2) + "/" + Substr(TRBFIN->TMP_BAIXA,5,2) + "/" + Substr(TRBFIN->TMP_BAIXA,1,4))
			ENDIF
			
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
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Vencimento de?"  	  , "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Vencimento até?"  	  , "", "", "mv_ch2", "D", 08, 0, 0, "G", "", "", "", "", "mv_par02")  
	putSx1(cPerg, "03", "Venc. Real de?"  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Venc. Real até?"  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Natureza de ?"		  , "", "", "mv_ch5", "C", 10, 0, 0, "G", "", "SED", "", "", "mv_par05")
	putSx1(cPerg, "06", "Natureza até?"		  , "", "", "mv_ch6", "C", 10, 0, 0, "G", "", "SED", "", "", "mv_par06")
return




