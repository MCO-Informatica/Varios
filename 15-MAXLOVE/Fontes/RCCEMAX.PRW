#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function RCCEMAX()
	Local oReport := nil
	Local cPerg:= Padr("RCCEMAX",10)
	
	AjustaSX1(cPerg)	
	Pergunte(cPerg,.F.)	          
		
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	
	oReport := TReport():New(cNome,"Compensacao",cNome,{|oReport| ReportPrint(oReport)},"Compensacao")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Compensacao", {"SE5"}, , .F., .T.)
	TRCell():New(oSection1,"E5_DATA"		,"TRB","Data da Compensação:"  		,"@!",8)
	
	oSection2:= TRSection():New(oReport, "Compensacao", {"SE5"}, NIL, .F., .T.)

	TRCell():New( oSection2, 'PRF',	       	'TRB', 'PRF',		        PesqPict( 'SE5', 'E5_PREFIXO' ),	3,,	 { || TRB->E5_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	    'TRB', 'NUMERO',			PesqPict( 'SE5', 'E5_NUMERO' ),		9,,	 { || TRB->E5_NUMERO } )
	TRCell():New( oSection2, 'PRC',	    	'TRB', 'PRC',		    	PesqPict( 'SE5', 'E5_PARCELA' ),	1,,	 { || TRB->E5_PARCELA } )
	TRCell():New( oSection2, 'TP',	    	'TRB', 'TP',		    	PesqPict( 'SE5', 'E5_TIPO' ),		3,,	 { || TRB->E5_TIPO } )
//	TRCell():New( oSection2, 'CLIFOR',	    'TRB', 'CLIENTE/FORNECEDOR',PesqPict( 'SE5', 'E5_CLIFOR' ),		6,,	 { || TRB->E5_CLIFOR } )
//	TRCell():New( oSection2, 'PR',	    	'TRB', 'P/R',		    	PesqPict( 'SE5', 'E5_RECPAG' ),		1,,	 { || TRB->E5_RECPAG } )
	TRCell():New( oSection2, 'COMPENSADO',	'TRB', 'COMPENSADO',		PesqPict( 'SE5', 'E5_VALOR' ),		14,	 { || TRB->E5_VALOR } )

	TRFunction():New(oSection2:Cell("COMPENSADO"),NIL,"SUM",,,,,.F.,.T.)    
	
	oReport:SetTotalInLine(.F.)    
   
 	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	      

	//Monto minha consulta conforme parametros passado
	cQuery := "	SELECT E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO,  E5_CLIFOR, E5_RECPAG, E5_VALOR "
	cQuery += "	FROM "+RETSQLNAME("SE5")+" SE5 "
//	cQuery += "	LEFT JOIN "+RETSQLNAME("SB1")+" SB1 ON SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD "
//	cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=D2_CLIENTE AND A1_LOJA= D2_LOJA "
	cQuery += "	WHERE SE5.D_E_L_E_T_=' ' "
	cQuery += "	AND E5_FILIAL='"+xFilial("SE5")+"' "
	cQuery += " AND E5_DATA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += "	ORDER BY E5_DATA, E5_CLIFOR "
  		
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRB") <> 0
		DbSelectArea("TRB")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRB"	
	
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	
	oReport:SetMeter(TRB->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cDoc 	:= TRB->E5_DATA
		IncProc("Imprimindo Movimentos "+alltrim(TRB->E5_DATA))
		
		//imprimo a primeira seção				
		oSection1:Cell("E5_DATA"):SetValue(TRB->E5_DATA)
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRB->E5_DATA == cDoc
			oReport:IncMeter()		
		
			IncProc("Imprimindo Movimentos "+alltrim(TRB->E5_DATA))
	//		oSection2:Cell("Código"):SetValue(TRB->D2_COD)
	//		oSection2:Cell("Descrição"):SetValue(TRB->B1_DESC)
			oSection2:Printline()
	
 			TRB->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()


 		oReport:ThinLine()

 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "Data de ?"	  , "", "", "mv_ch1", "D", tamSx3("E5_DATA")[1], 0, 0, "G", "", , "", "", "mv_par01")
	putSx1(cPerg, "02", "Data até ?"	  , "", "", "mv_ch2", "D", tamSx3("E5_DATA")[1], 0, 0, "G", "", , "", "", "mv_par02")
return