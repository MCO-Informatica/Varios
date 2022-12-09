#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat053()
	Local oReport := nil
	Local cPerg:= Padr("RELAT053",10)
	
	
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
	oReport := TReport():New(cNome,"Relatório Apontamento Horas  " ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F. 	
	
	
	//Monstando a primeira seção
	
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SZ4"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_COLAB"		,"TRBAPT"	,"Colaborador"		,"@!"				,50)
	TRCell():New(oSection1,"TMP_HRSCONT"	,"TRBAPT"	,"Horas"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLRCONT"	,"TRBAPT"	,"Valor"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	
	TRFunction():New(oSection1:Cell("TMP_HRSCONT")	,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("TMP_VLRCONT")	,NIL,"SUM",,,,,.T.,.F.)
	
	oSection2:= TRSection():New(oReport, 	"NCM",	 	{"SZ4"}, 	, .F.	, 	.T.)
	TRCell():New(oSection2,"TMP_COLAB"		,"TRBAPT"	,"Colaborador"		,"@!"				,50)
	TRCell():New(oSection2,"TMP_HRSCONT"	,"TRBAPT"	,"Horas"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_VLRCONT"	,"TRBAPT"	,"Valor"	,"@E 999,999,999.99",14,,,,,"RIGHT")
		
	TRFunction():New(oSection2:Cell("TMP_HRSCONT")	,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection2:Cell("TMP_VLRCONT")	,NIL,"SUM",,,,,.T.,.F.)
	
	oSection3:= TRSection():New(oReport, 	"NCM",	 	{"SZ4"}, 	, .F.	, 	.T.)
	TRCell():New(oSection3,"TMP_COLAB"		,"TRBAPT"	,"Colaborador"		,"@!"				,50)
	TRCell():New(oSection3,"TMP_HRSCONT"	,"TRBAPT"	,"Horas"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection3,"TMP_VLRCONT"	,"TRBAPT"	,"Valor"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	
	TRFunction():New(oSection3:Cell("TMP_HRSCONT")	,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection3:Cell("TMP_VLRCONT")	,NIL,"SUM",,,,,.T.,.F.)
	

	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText("Subtotal Contrato ")	
	
	oSection2:SetPageBreak(.F.)
	oSection2:SetTotalText("Subtotal Proposta ")
	
	oSection3:SetPageBreak(.F.)
	oSection3:SetTotalText("Total Geral ")
					
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)	 
	Local oSection2 := oReport:Section(2)	
	Local oSection3 := oReport:Section(3) 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	
	
	Local cQuery2   := ""		
	
	      

	//Monto minha consulta conforme parametros passado
	
	cQuery := " SELECT Z4_COLAB AS 'TMP_COLAB', SUM(Z4_QTDHRS) AS 'TMP_HRSCONT', SUM(Z4_TOTVLR) AS 'TMP_VLRCONT' "
	cQuery += " 	FROM SZ4010 "
	cQuery += " 	WHERE D_E_L_E_T_ <> '*' AND  Z4_ITEMCTA NOT IN ('PROPOSTA','ADMINISTRACAO') AND "  
	cQuery += " 	Z4_DATA		  >= '" + DTOS(MV_PAR01) + "' AND  "
	cQuery += " 	Z4_DATA    	  <= '" + DTOS(MV_PAR02) + "' " 
	cQuery += " 	GROUP BY  Z4_COLAB ORDER BY Z4_COLAB "
	

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBAPT") <> 0
		DbSelectArea("TRBAPT")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBAPT"	
	
	dbSelectArea("TRBAPT")
	TRBAPT->(dbGoTop())
	
	oReport:SetMeter(TRBAPT->(LastRec()))
	
	oReport:SkipLine(3)	
	oReport:FatLine()
	oReport:PrintText("RESUMO CONTRATOS") 
	oReport:FatLine()

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBAPT->TMP_COLAB
		IncProc("Imprimindo Apontamento Horas "+alltrim(TRBAPT->TMP_COLAB))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_COLAB"):SetValue(TRBAPT->TMP_COLAB)
		oSection1:Cell("TMP_HRSCONT"):SetValue(TRBAPT->TMP_HRSCONT)
		oSection1:Cell("TMP_VLRCONT"):SetValue(TRBAPT->TMP_VLRCONT)	
		oReport:ThinLine()
		oSection1:Printline()
		TRBAPT->(dbSkip())
 		
	Enddo
	
	oSection1:Finish()
	
	/////////////////////////////////////////////////////////////////////////////////////////
	cQuery := " SELECT Z4_COLAB AS 'TMP_COLAB', SUM(Z4_QTDHRS) AS 'TMP_HRSCONT', SUM(Z4_TOTVLR) AS 'TMP_VLRCONT' "
	cQuery += " 	FROM SZ4010 "
	cQuery += " 	WHERE D_E_L_E_T_ <> '*' AND  Z4_ITEMCTA IN ('PROPOSTA') AND "  
	cQuery += " 	Z4_DATA		  >= '" + DTOS(MV_PAR01) + "' AND  "
	cQuery += " 	Z4_DATA    	  <= '" + DTOS(MV_PAR02) + "' " 
	cQuery += " 	GROUP BY  Z4_COLAB ORDER BY Z4_COLAB "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBAPT") <> 0
		DbSelectArea("TRBAPT")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBAPT"	
	
	dbSelectArea("TRBAPT")
	TRBAPT->(dbGoTop())
	
	oReport:SetMeter(TRBAPT->(LastRec()))	
	oReport:SkipLine(5)	
	oReport:FatLine()
	oReport:PrintText("RESUMO PROPOSTAS") 
	oReport:FatLine()
	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection2:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBAPT->TMP_COLAB
		IncProc("Imprimindo Apontamento Horas "+alltrim(TRBAPT->TMP_COLAB))
		
		//imprimo a primeira seção				
		oSection2:Cell("TMP_COLAB"):SetValue(TRBAPT->TMP_COLAB)
		oSection2:Cell("TMP_HRSCONT"):SetValue(TRBAPT->TMP_HRSCONT)
		oSection2:Cell("TMP_VLRCONT"):SetValue(TRBAPT->TMP_VLRCONT)	
		oReport:ThinLine()
		oSection2:Printline()
		TRBAPT->(dbSkip())
 		
	Enddo
	
	
	//imprimo uma linha para separar uma NCM de outra
 		
 	//finalizo a primeira seção
	oSection2:Finish()
	
	/////////////////////////////////////////////////////////////////////
	//Monto minha consulta conforme parametros passado
	
	cQuery := " SELECT Z4_COLAB AS 'TMP_COLAB', SUM(Z4_QTDHRS) AS 'TMP_HRSCONT', SUM(Z4_TOTVLR) AS 'TMP_VLRCONT' "
	cQuery += " 	FROM SZ4010 "
	cQuery += " 	WHERE D_E_L_E_T_ <> '*' AND  Z4_ITEMCTA NOT IN ('ADMINISTRACAO') AND "  
	cQuery += " 	Z4_DATA		  >= '" + DTOS(MV_PAR01) + "' AND  "
	cQuery += " 	Z4_DATA    	  <= '" + DTOS(MV_PAR02) + "' " 
	cQuery += " 	GROUP BY  Z4_COLAB ORDER BY Z4_COLAB "
	

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBAPT") <> 0
		DbSelectArea("TRBAPT")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBAPT"	
	
	dbSelectArea("TRBAPT")
	TRBAPT->(dbGoTop())
	
	oReport:SetMeter(TRBAPT->(LastRec()))	
	oReport:SkipLine(5)	
	oReport:FatLine()
	oReport:PrintText("RESUMO GERAL") 
	oReport:FatLine()
	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection3:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBAPT->TMP_COLAB
		IncProc("Imprimindo Apontamento Horas "+alltrim(TRBAPT->TMP_COLAB))
		
		//imprimo a primeira seção				
		oSection3:Cell("TMP_COLAB"):SetValue(TRBAPT->TMP_COLAB)
		oSection3:Cell("TMP_HRSCONT"):SetValue(TRBAPT->TMP_HRSCONT)
		oSection3:Cell("TMP_VLRCONT"):SetValue(TRBAPT->TMP_VLRCONT)	
		oReport:ThinLine()
		oSection3:Printline()
		TRBAPT->(dbSkip())
 		
	Enddo
	
	oSection3:Finish()
	
	
Return

static function ajustaSx1(cPerg)

	putSx1(cPerg, "01", "Data de?"	  	  , "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Data até?"	  	  , "", "", "mv_ch2", "D", 08, 0, 0, "G", "", "", "", "", "mv_par02")
	
return













