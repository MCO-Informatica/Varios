#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'topconn.ch'
#include "rwmake.ch"

user function zRelPLN01()

	Local oReport := nil
	private cPerg:=  "PRPLN01" 

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
	Local oSection4:= Nil
	//Local oSection5:= Nil
	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatório Planejamento de Comntrato",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Calibri"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.
	

	//Monstando a 1a. seção
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"CTD"}, 			, .F.	, 	.T.)
	TRCell():New(oSection1,"TP1_ITEMIC"		,"TRBSGC",	"Contrato"  		,"@!"	,	24)
	TRCell():New(oSection1,"TP1_NPROP"		,"TRBSGC",	"Proposta"  		,"@!"	,	15)
	TRCell():New(oSection1,"TP1_XEQUIP"		,"TRBSGC",	"Op.Unit."  		,"@!"	,	30)
	TRCell():New(oSection1,"TP1_XNREDU"		,"TRBSGC",	"Cliente" 	 		,"@!"	,	30)
	TRCell():New(oSection1,"TP1_DTEXIS"		,"TRBSGC",	"Abertura"  		,"@!"	,	16)
	TRCell():New(oSection1,"TP1_DTEXSF"		,"TRBSGC",	"Final"  			,"@!"	,	16)
	TRCell():New(oSection1,"TP1_XCUPRR"		,"TRBSGC",	"Custo Producao" 	,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection1,"TP1_XCUTOR"		,"TRBSGC",	"Custo Total"  		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection1,"TP1_XVDCIR"		,"TRBSGC",	"Venda c/ Tributos" ,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection1,"TP1_XVDSIR"		,"TRBSGC",	"Venda s/ Tributos" ,"@E 999,999,999.99",22,,,,,"RIGHT")

	//Monstando a 2a. seção
	oSection2:= TRSection():New(oReport, "Gestao de Contratos", {"SZC"}, NIL, .F., .T.)
	TRCell():New(oSection2,""				,"TRBSGC3","NÍVEL 1"				,""				,5)
	TRCell():New(oSection2,"TP2_IDPLAN"		,"TRBSGC2","IDPLAN"				,"@!"				,15)
	TRCell():New(oSection2,"TP2_DESCRI"		,"TRBSGC2","Descrição"			,"@!"				,80)
	TRCell():New(oSection2,"TP2_QUANTR"		,"TRBSGC2","Quantidade"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TP2_UNITR"		,"TRBSGC2","Vlr.Unitário"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TP2_TOTALR"		,"TRBSGC2","Vlr.Total"			,"@E 999,999,999.99",22,,,,,"RIGHT")
		
	//Monstando a 3a. seção
	oSection3:= TRSection():New(oReport, "Gestao de Contratos", {"SZD"}, NIL, .F., .T.)
	TRCell():New(oSection3,""				,"TRBSGC3","NÍVEL 2"			,""					,10)
	TRCell():New(oSection3,"TP3_IDPLAN"		,"TRBSGC3","IDPLAN"				,"@!"				,15)
	TRCell():New(oSection3,"TP3_IDPLSUB"	,"TRBSGC3","IDPLSUB"			,"@!"				,15)
	TRCell():New(oSection3,"TP3_DESCRI"		,"TRBSGC3","Descrição"			,"@!"				,70)
	TRCell():New(oSection3,"TP3_QUANTR"		,"TRBSGC3","Quantidade"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection3,"TP3_UNITR"		,"TRBSGC3","Vlr.Unitário"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection3,"TP3_TOTALR"		,"TRBSGC3","Vlr.Total"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	

	//Monstando a 4a. seção
	oSection4:= TRSection():New(oReport, "Gestao de Contratos", {"SZO"}, NIL, .F., .T.)
	TRCell():New(oSection4,""				,"TRBSGC3","NÍVEL 3"				,""				,15)
	TRCell():New(oSection4,"TP4_IDPLSUB"	,"TRBSGC4","IDPLSUB"				,"@!"			,15)
	TRCell():New(oSection4,"TP4_IDPLSB2"	,"TRBSGC4","IDPLSB2"				,"@!"			,15)
	TRCell():New(oSection4,"TP4_DESCRI"		,"TRBSGC4","Descrição"			,"@!"				,70)
	TRCell():New(oSection4,"TP4_QUANTR"		,"TRBSGC4","Quantidade"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection4,"TP4_UNITR"		,"TRBSGC4","Vlr.Unitário"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection4,"TP4_TOTALR"		,"TRBSGC4","Vlr.Total"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	
	//Monstando a 5a. seção
	oSection5:= TRSection():New(oReport, "Gestao de Contratos", {"SZU"}, NIL, .F., .T.)
	TRCell():New(oSection5,""				,"TRBSGC5","NÍVEL 4"			,""					,20)
	TRCell():New(oSection5,"TP5_IDPLSB2"	,"TRBSGC5","IDPLSB2"			,"@!"				,20)
	TRCell():New(oSection5,"TP5_IDPLSB3"	,"TRBSGC5","IDPLSB3"			,"@!"				,15)
	TRCell():New(oSection5,"TP5_DESCRI"		,"TRBSGC5","Descrição"			,"@!"				,70)
	TRCell():New(oSection5,"TP5_QUANTR"		,"TRBSGC5","Quantidade"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection5,"TP5_UNITR"		,"TRBSGC5","Vlr.Unitário"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection5,"TP5_TOTALR"		,"TRBSGC5","Vlr.Total"			,"@E 999,999,999.99",22,,,,,"RIGHT")


	/*
	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_CONTRATO) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_SALDO")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	*/

	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4)
	Local oSection5 := oReport:Section(5)
	Local cQuery    := ""
	Local cQuery2    := ""
	Local cQuery3    := ""
	Local cQuery4    := ""
	Local cQuery5    := ""
	Local cNcm      := ""
	Local cNcm2     := ""
	Local cID2     := ""
	Local cNcm3     := ""
	Local cID3    := ""
	Local cNcm4     := ""
	Local cID4    := ""
	Local lPrim 	:= .T.

	oSection2:SetHeaderSection(.T.)
	oSection3:SetHeaderSection(.T.)
	oSection4:SetHeaderSection(.T.)
	oSection5:SetHeaderSection(.T.)

	//Monto minha consulta conforme parametros passado
	/*
	cQuery := "  SELECT CTD_ITEM AS 'TP1_ITEM', CTD_NPROP AS 'TP1_NPROP', CTD_XEQUIP AS 'TP1_XEQUIP', CTD_XCLIEN AS 'TP1_XCLIEN', CTD_XNREDU AS 'TP1_XNREDU', "
	cQuery += " 	CTD_XCUPRR AS 'TP1_XCUPRR', CTD_XCUTOR AS 'TP1_XCUTOR', CTD_XVDSIR AS 'TP1_XVDSIR', CTD_XVDCIR AS 'TP1_XVDCIR', "
	cQuery += " 	CTD_DTEXIS AS 'TP1_DTEXIS', CTD_DTEXSF AS 'TP1_DTEXSF', "
	cQuery += " 	CTD_XIDPM AS 'TP1_XIDPM', CTD_XNOMPM AS 'TP1_NOMPM', "
	cQuery += " 	ZC_IDPLAN AS 'TP2_IDPLAN', ZC_ITEMIC AS 'TP2_ITEMIC', ZC_DESCRI AS 'TP2_DESCRI', ZC_QUANTR AS 'TP2_QUANTR', ZC_UNITR  AS 'TP2_UNITR', ZC_TOTALR  AS 'TP2_TOTALR' "
	cQuery += " 	,ZD_IDPLAN AS 'TP3_IDPLAN', ZD_ITEMIC AS 'TP3_ITEMIC', ZD_DESCRI AS 'TP3_DESCRI', ZD_QUANTR AS 'TP3_QUANTR', ZD_UNITR AS 'TP3_UNITR', ZD_TOTALR AS 'TP3_TOTALR', ZD_IDPLSUB AS 'TP3_IDPLSUB' "
	cQuery += " 	,ZO_IDPLSUB AS 'TP4_IDPLSUB', ZO_ITEMIC AS 'TP4_ITEMIC', ZO_DESCRI AS 'TP4_DESCRI', ZO_QUANTR  AS 'TP4_QUANTR', ZO_UNITR AS 'TP4_UNITR', ZO_TOTALR AS 'TP4_TOTALR', ZO_IDPLSB2 AS 'TP4_IDPLSB2' "
	//cQuery += " 	,ZU_IDPLSB2 AS 'TP5_IDPLSB2', ZU_ITEMIC AS 'TP5_ITEMIC', ZU_DESCRI AS 'TP5_DESCRI', ZU_QUANTR AS 'TP5_QUANTR', ZU_UNITR AS 'TP5_UNITR', ZU_TOTALR AS 'TP5_TOTALR', ZU_IDPLSB3  AS 'TP5_IDPLSB3' "
	cQuery += "  FROM CTD010 "
	cQuery += "  LEFT JOIN SZC010 ON CTD010.CTD_ITEM = SZC010.ZC_ITEMIC " 
	cQuery += "  LEFT JOIN SZD010 ON SZC010.ZC_ITEMIC = SZD010.ZD_ITEMIC AND SZC010.ZC_IDPLAN = SZD010.ZD_IDPLAN "
	cQuery += "  LEFT JOIN SZO010 ON SZD010.ZD_ITEMIC = SZO010.ZO_ITEMIC AND SZD010.ZD_IDPLSUB = SZO010.ZO_IDPLSUB "
	//cQuery += "  LEFT JOIN SZU010 ON SZO010.ZO_ITEMIC = SZU010.ZU_ITEMIC AND SZO010.ZO_IDPLSB2 = SZU010.ZU_IDPLSB2 "
	cQuery += "  WHERE CTD010.D_E_L_E_T_ <> '*' AND SZC010.D_E_L_E_T_ <> '*' AND SZD010.D_E_L_E_T_ <> '*' AND " 
	cQuery += "  		SZO010.D_E_L_E_T_ <> '*'  AND " //AND SZU010.D_E_L_E_T_ <> '*'
	cQuery += "		CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND SUBSTRING(CTD_ITEM,9,2) >= '15' "
	cQuery += "  		ORDER BY CTD_ITEM, ZC_IDPLAN, ZD_IDPLSUB, ZO_IDPLSB2  " //--, ZD_IDPLSUB, ZO_IDPLSB2, ZU_IDPLSB3
	*/

	// DETALHES - CTD
	cQuery := "  SELECT CTD_ITEM AS 'TP1_ITEMIC', CTD_NPROP AS 'TP1_NPROP', CTD_XEQUIP AS 'TP1_XEQUIP', CTD_XCLIEN AS 'TP1_XCLIEN', CTD_XNREDU AS 'TP1_XNREDU', "
	cQuery += " 		CTD_XCUPRR AS 'TP1_XCUPRR', CTD_XCUTOR AS 'TP1_XCUTOR', CTD_XVDSIR AS 'TP1_XVDSIR', CTD_XVDCIR AS 'TP1_XVDCIR', "
	cQuery += " 		CAST(CTD_DTEXIS AS DATE) AS 'TP1_DTEXIS', CAST(CTD_DTEXSF AS DATE) AS 'TP1_DTEXSF',  "
	cQuery += " 		CTD_XIDPM AS 'TP1_XIDPM', CTD_XNOMPM AS 'TP1_NOMPM'  "
	cQuery += " 	 FROM CTD010  "
	cQuery += " 	 WHERE CTD010.D_E_L_E_T_ <> '*' AND  " 
	cQuery += "		CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND SUBSTRING(CTD_ITEM,9,2) >= '15' " 
	cQuery += " 		ORDER BY CTD_ITEM "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC") <> 0
		DbSelectArea("TRBSGC")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSGC"

	dbSelectArea("TRBSGC")
	TRBSGC->(dbGoTop())
	
	
	oReport:SetMeter(TRBSGC->(LastRec()))
	
	// DETALHES - SZC
	
	cQuery2 := "  SELECT "
	cQuery2 += "  	ZC_IDPLAN AS 'TP2_IDPLAN', ZC_ITEMIC AS 'TP2_ITEMIC', ZC_DESCRI AS 'TP2_DESCRI', ZC_QUANTR AS 'TP2_QUANTR', ZC_UNITR  AS 'TP2_UNITR', ZC_TOTALR  AS 'TP2_TOTALR'  "
	cQuery2 += "  FROM SZC010  "
	cQuery2 += "  WHERE SZC010.D_E_L_E_T_ <> '*' AND "
 	cQuery2 += "		ZC_ITEMIC >= '" + MV_PAR01 + "' AND ZC_ITEMIC <= '" + MV_PAR02 + "' AND SUBSTRING(ZC_ITEMIC,9,2) >= '15' " 
	cQuery2 += "  	ORDER BY ZC_IDPLAN  "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC2") <> 0
		DbSelectArea("TRBSGC2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery2 NEW ALIAS "TRBSGC2"

	dbSelectArea("TRBSGC2")
	TRBSGC2->(dbGoTop())
	
	oReport:SetMeter(TRBSGC2->(LastRec()))
	
	//****************************
	
	// DETALHES - SZD
	cQuery3 := " SELECT "
	cQuery3 += "  	ZD_IDPLAN AS 'TP3_IDPLAN', ZD_ITEMIC AS 'TP3_ITEMIC', ZD_DESCRI AS 'TP3_DESCRI', ZD_QUANTR AS 'TP3_QUANTR', ZD_UNITR AS 'TP3_UNITR', ZD_TOTALR AS 'TP3_TOTALR', ZD_IDPLSUB AS 'TP3_IDPLSUB'  "
	cQuery3 += "  FROM SZD010 "
	cQuery3 += "  WHERE  SZD010.D_E_L_E_T_ <> '*' AND "
	cQuery3 += "		ZD_ITEMIC >= '" + MV_PAR01 + "' AND ZD_ITEMIC <= '" + MV_PAR02 + "' AND SUBSTRING(ZD_ITEMIC,9,2) >= '15' "  	
	cQuery3 += "  	ORDER BY  ZD_IDPLAN,ZD_IDPLSUB "
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC3") <> 0
		DbSelectArea("TRBSGC3")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery3 NEW ALIAS "TRBSGC3"

	dbSelectArea("TRBSGC3")
	TRBSGC3->(dbGoTop())
	
	
	oReport:SetMeter(TRBSGC3->(LastRec()))
	
	// DETALHES - SZO
	cQuery4 := " SELECT "
	cQuery4 += " ZO_IDPLSUB AS 'TP4_IDPLSUB', ZO_ITEMIC AS 'TP4_ITEMIC', ZO_DESCRI AS 'TP4_DESCRI', ZO_QUANTR  AS 'TP4_QUANTR', ZO_UNITR AS 'TP4_UNITR', ZO_TOTALR AS 'TP4_TOTALR', ZO_IDPLSB2 AS 'TP4_IDPLSB2'  "
	cQuery4 += " FROM SZO010 "
	cQuery4 += " WHERE 	SZO010.D_E_L_E_T_ <> '*' AND " 
	cQuery4 += "		ZO_ITEMIC >= '" + MV_PAR01 + "' AND ZO_ITEMIC <= '" + MV_PAR02 + "' AND SUBSTRING(ZO_ITEMIC,9,2) >= '15' "  
	cQuery4 += " ORDER BY  ZO_IDPLSUB,ZO_IDPLSB2 "
		
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC4") <> 0
		DbSelectArea("TRBSGC4")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery4 NEW ALIAS "TRBSGC4"

	dbSelectArea("TRBSGC4")
	TRBSGC4->(dbGoTop())
	
	oReport:SetMeter(TRBSGC4->(LastRec()))
	//****************************
	
	// DETALHES - SZU
	cQuery5 := " SELECT "
	cQuery5 += " ZU_IDPLSB2 AS 'TP5_IDPLSB2', ZU_ITEMIC AS 'TP5_ITEMIC', ZU_DESCRI AS 'TP5_DESCRI', ZU_QUANTR  AS 'TP5_QUANTR', ZU_UNITR AS 'TP5_UNITR', ZU_TOTALR AS 'TP5_TOTALR', ZU_IDPLSB3 AS 'TP4_IDPLSB3'  "
	cQuery5 += " FROM SZU010 "
	cQuery5 += " WHERE 	SZU010.D_E_L_E_T_ <> '*' AND " 
	cQuery5 += "		ZU_ITEMIC >= '" + MV_PAR01 + "' AND ZU_ITEMIC <= '" + MV_PAR02 + "' AND SUBSTRING(ZU_ITEMIC,9,2) >= '15' "  
	cQuery5 += " ORDER BY  ZU_IDPLSB2,ZU_IDPLSB3 "
		
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC5") <> 0
		DbSelectArea("TRBSGC5")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery5 NEW ALIAS "TRBSGC5"

	dbSelectArea("TRBSGC5")
	TRBSGC5->(dbGoTop())
	
	oReport:SetMeter(TRBSGC5->(LastRec()))
	//****************************
	
	
	
	//Irei percorrer todos os meus registros
	While TRBSGC->(!Eof()) 
	
		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= alltrim(TRBSGC->TP1_ITEMIC)
		IncProc("Imprimindo Sumario "+alltrim(TRBSGC->TP1_ITEMIC))

		//imprimo a primeira seção
		oSection1:Cell("TP1_ITEMIC"):SetValue(TRBSGC->TP1_ITEMIC)
		oSection1:Cell("TP1_NPROP"):SetValue(TRBSGC->TP1_NPROP)
		oSection1:Cell("TP1_XEQUIP"):SetValue(TRBSGC->TP1_XEQUIP)
		oSection1:Cell("TP1_XNREDU"):SetValue(TRBSGC->TP1_XNREDU)
		oSection1:Cell("TP1_DTEXIS"):SetValue(TRBSGC->TP1_DTEXIS)
		oSection1:Cell("TP1_DTEXSF"):SetValue(TRBSGC->TP1_DTEXSF)
		oSection1:Cell("TP1_XCUPRR"):SetValue(TRBSGC->TP1_XCUPRR)
		oSection1:Cell("TP1_XCUTOR"):SetValue(TRBSGC->TP1_XCUTOR)
		oSection1:Cell("TP1_XVDCIR"):SetValue(TRBSGC->TP1_XVDCIR)
		oSection1:Cell("TP1_XVDSIR"):SetValue(TRBSGC->TP1_XVDSIR)

		oSection1:Printline()
		oReport:ThinLine()
		
				
		//inicializo a segunda seção
		oSection2:init()
		
		
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBSGC2->(!Eof()) .and. alltrim(TRBSGC2->TP2_ITEMIC) == cNcm 
		
			oReport:IncMeter()
			cNcm2 	:= alltrim(TRBSGC2->TP2_ITEMIC)
			cID2    := alltrim(TRBSGC2->TP2_IDPLAN)
			IncProc("Imprimindo Sumario "+alltrim(TRBSGC2->TP2_ITEMIC))

			oSection2:Cell("TP2_IDPLAN"):SetValue(TRBSGC2->TP2_IDPLAN)
			oSection2:Cell("TP2_DESCRI"):SetValue(TRBSGC2->TP2_DESCRI)

			oSection2:Cell("TP2_QUANTR"):SetValue(TRBSGC2->TP2_QUANTR)
			oSection2:Cell("TP2_QUANTR"):SetAlign("RIGHT")

			oSection2:Cell("TP2_UNITR"):SetValue(TRBSGC2->TP2_UNITR)
			oSection2:Cell("TP2_UNITR"):SetAlign("RIGHT")

			oSection2:Cell("TP2_TOTALR"):SetValue(TRBSGC2->TP2_TOTALR)
			oSection2:Cell("TP2_TOTALR"):SetAlign("TP2_TOTALR")

			oSection2:Printline()
			
			//inicializo a 3a. seção
			
			oSection3:init()
			oReport:ThinLine()
			
			
			TRBSGC3->(dbgotop())
			
			While TRBSGC3->(!Eof()) 
				oReport:IncMeter()
				cNcm3 	:= alltrim(TRBSGC3->TP3_ITEMIC)
				cID3    := alltrim(TRBSGC3->TP3_IDPLSUB)
				IncProc("Imprimindo Sumario "+alltrim(TRBSGC3->TP3_IDPLAN))
				
								
				if alltrim(TRBSGC3->TP3_ITEMIC) == Alltrim(cNcm2) .AND. alltrim(TRBSGC3->TP3_IDPLAN) == alltrim(cID2) 
				
					oSection3:Cell("TP3_IDPLAN"):SetValue(TRBSGC3->TP3_IDPLAN)
					oSection3:Cell("TP3_IDPLSUB"):SetValue(TRBSGC3->TP3_IDPLSUB)
					oSection3:Cell("TP3_DESCRI"):SetValue(TRBSGC3->TP3_DESCRI)
		
					oSection3:Cell("TP3_QUANTR"):SetValue(TRBSGC3->TP3_QUANTR)
					oSection3:Cell("TP3_QUANTR"):SetAlign("RIGHT")
		
					oSection3:Cell("TP3_UNITR"):SetValue(TRBSGC3->TP3_UNITR)
					oSection3:Cell("TP3_UNITR"):SetAlign("RIGHT")
		
					oSection3:Cell("TP3_TOTALR"):SetValue(TRBSGC3->TP3_TOTALR)
					oSection3:Cell("TP3_TOTALR"):SetAlign("TP3_TOTALR")
					
					oSection3:Printline()
					//inicializo a 4a. seção
				
					oSection4:init()
					oReport:ThinLine()
					
					TRBSGC4->(dbgotop())
					
					
					While TRBSGC4->(!Eof())  
						oReport:IncMeter()
						cNcm4 	:= alltrim(TRBSGC4->TP4_ITEMIC)
						cID4    := alltrim(TRBSGC4->TP4_IDPLSB2)
						
						IncProc("Imprimindo Sumario "+alltrim(TRBSGC4->TP4_IDPLSUB))
						
						if  alltrim(TRBSGC4->TP4_ITEMIC) == Alltrim(cNcm3) .AND. alltrim(TRBSGC4->TP4_IDPLSUB) == alltrim(cID3)  
						
							oSection4:Cell("TP4_IDPLSUB"):SetValue(TRBSGC4->TP4_IDPLSUB)
							oSection4:Cell("TP4_IDPLSB2"):SetValue(TRBSGC4->TP4_IDPLSB2)
							oSection4:Cell("TP4_DESCRI"):SetValue(TRBSGC4->TP4_DESCRI)
				
							oSection4:Cell("TP4_QUANTR"):SetValue(TRBSGC4->TP4_QUANTR)
							oSection4:Cell("TP4_QUANTR"):SetAlign("RIGHT")
				
							oSection4:Cell("TP4_UNITR"):SetValue(TRBSGC4->TP4_UNITR)
							oSection4:Cell("TP4_UNITR"):SetAlign("RIGHT")
				
							oSection4:Cell("TP4_TOTALR"):SetValue(TRBSGC4->TP4_TOTALR)
							oSection4:Cell("TP4_TOTALR"):SetAlign("TP4_TOTALR")
							
							oSection4:Printline()
							
							//
							oSection5:init()
							//oReport:ThinLine()
							TRBSGC5->(dbgotop())
							
							While TRBSGC5->(!Eof()) 
								oReport:IncMeter()
								
								IncProc("Imprimindo Sumario "+alltrim(TRBSGC5->TP5_IDPLSB2))
								
								if  alltrim(TRBSGC5->TP5_ITEMIC) == Alltrim(cNcm4) .AND. alltrim(TRBSGC5->TP5_IDPLSB2) == alltrim(cID4)  
						
									oSection5:Cell("TP5_IDPLSB2"):SetValue(TRBSGC5->TP5_IDPLSB2)
									oSection5:Cell("TP5_IDPLSB3"):SetValue(TRBSGC5->TP5_IDPLSB3)
									oSection5:Cell("TP5_DESCRI"):SetValue(TRBSGC5->TP5_DESCRI)
						
									oSection5:Cell("TP5_QUANTR"):SetValue(TRBSGC5->TP5_QUANTR)
									oSection5:Cell("TP5_QUANTR"):SetAlign("RIGHT")
						
									oSection5:Cell("TP5_UNITR"):SetValue(TRBSGC5->TP5_UNITR)
									oSection5:Cell("TP5_UNITR"):SetAlign("RIGHT")
						
									oSection5:Cell("TP5_TOTALR"):SetValue(TRBSGC5->TP5_TOTALR)
									oSection5:Cell("TP5_TOTALR"):SetAlign("TP5_TOTALR")
									
									//oSection5:Printline()
									//
								ENDIF
								TRBSGC5->(dbSkip())	
								
							enddo
							oSection5:Finish()
							oReport:ThinLine()
							//
						ENDIF
						TRBSGC4->(dbSkip())	
						
					enddo
					oSection4:Finish()
					//oReport:SkipLine() 
					oReport:ThinLine()
					
				endif
				TRBSGC3->(dbSkip())	
				//oReport:SkipLine() 
				oReport:ThinLine()
					
			enddo
			oSection3:Finish()	
			TRBSGC2->(dbSkip())	
			//oReport:SkipLine() 
			oReport:ThinLine()
					
 		EndDo
 		oSection2:Finish()	
 		TRBSGC->(dbSkip())
 		//oReport:SkipLine() 	
 		oReport:ThinLine()
	

			
 	Enddo
	oSection1:Finish()
	oReport:ThinLine()
	
	
 	
	
Return

static function ajustaSx1(cPerg)

	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Coordenador de ?"	  , "", "", "mv_ch3", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par03")
	putSx1(cPerg, "04", "Coordenador de ?"	  , "", "", "mv_ch4", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par04")


return