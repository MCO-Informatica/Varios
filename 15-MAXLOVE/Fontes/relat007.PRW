#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat007()
	Local oReport := nil
	Local cPerg:= Padr("RELAT007",10)
	Public _cOBS     
	Public _cSTATUS  
	Public _lExiste := .f.   
	
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
	
	oReport := TReport():New(cNome,"Liquidacao - Pagar",cNome,{|oReport| ReportPrint(oReport)},"Liquidacao - Pagar")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Liquidacao - Receber", {"SE2"}, , .F., .T.)
 	TRCell():New(oSection1,"E2_FORNECE"		,"TRB","Código"  		,"@!",6)
	TRCell():New(oSection1,"E2_LOJA"		,"TRB","LJ"  		,"@!",2)
	TRCell():New(oSection1,"A2_NOME"		,"TRB","Fornecedor"  		,"@!",40)

	oSection2:= TRSection():New(oReport, "Itens", {"SE2"}, NIL, .F., .T.)     
	
	TRCell():New( oSection2, 'PRF',	    	'TRB', 'PRF',		        PesqPict( 'SE2', 'E2_PREFIXO' ),	3,,	 						    { || TRB->E2_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	   	'TRB', 'NUMERO',	        PesqPict( 'SE2', 'E2_NUM' ),		9,,						 	    { || TRB->E2_NUM } )
	TRCell():New( oSection2, 'PC',	   		'TRB', 'PC',		        PesqPict( 'SE2', 'E2_PARCELA' ),	1,,	 						    { || TRB->E2_PARCELA } )
	TRCell():New( oSection2, 'TIPO',		'TRB', 'TIPO',		        PesqPict( 'SE2', 'E2_TIPO' ),		1,,	 						    { || TRB->E2_TIPO } )
 	TRCell():New( oSection2, 'EMISSAO',	   	'TRB', 'EMISSAO',		    PesqPict( 'SE2', 'E2_EMISSAO' ),	8,,	 						    { || Substr(TRB->E2_EMISSAO,7,2)+"/"+Substr(TRB->E2_EMISSAO,5,2)+"/"+Substr(TRB->E2_EMISSAO,3,2) } )
 	TRCell():New( oSection2, 'BAIXA',	   	'TRB', 'BAIXA',		        PesqPict( 'SE5', 'E5_DATA' ),		8,,	 						    { || Substr(TRB->E5_DATA,7,2)+"/"+Substr(TRB->E5_DATA,5,2)+"/"+Substr(TRB->E5_DATA,3,2) } )
	TRCell():New( oSection2, 'VORIG',		'TRB', 'VL.ORIGINAL',		PesqPict( 'SE2', 'E2_VALOR' ),		12,, 						    { || TRB->E2_VALOR } )
	TRCell():New( oSection2, 'VPAGO',		'TRB', 'VL.PAGO',			PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E5_VALOR } )
	TRCell():New( oSection2, 'SALDO',		'TRB', 'SALDO',				PesqPict( 'SE2', 'E2_VALOR' ),		12,, 						    { ||  Iif(_lExiste .or. TRB->E2_TIPO = "CH", 0, TRB->E2_SALDO) } )
	TRCell():New( oSection2, 'OBSERVACAO', 	'TRB', 'OBSERVACAO',        "@",								30,,					 	    { || _cOBS } )
	TRCell():New( oSection2, 'STATUS', 		'TRB', 'STATUS', 	        "@",								10,,					 	    { || _cSTATUS } )

    oSection2:SetTotalInLine(.f.)    
    
    
   	TRFunction():New(oSection2:Cell("VORIG"),NIL,"SUM",,,,{ || Iif(_lExiste .or. TRB->E2_TIPO $ "CH .CR .TED.BLE", 0, TRB->E2_VALOR) } ,.T.,.T.) 
	TRFunction():New(oSection2:Cell("VPAGO"),NIL,"SUM",,,,,.T.,.T.)    
	TRFunction():New(oSection2:Cell("SALDO"),NIL,"SUM",,,,{ || Iif(_lExiste .or. TRB->E2_TIPO $ "CH .CR .TED.BLE", 0, TRB->E2_SALDO) } ,.T.,.T.) 
	

	oReport:SetTotalInLine(.F.)    
   
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local lPrim 	:= .T.	
	Local _cPRFAnt  := ""
	Local _cNUMAnt  := ""  
	Local _cPCAnt	:= ""
	    
    

	cQuery := "	SELECT E2_FORNECE, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_LOJA, E2_VALOR, E5_VALOR, E2_VENCTO, E2_EMISSAO, E2_SALDO, A2_NOME, E5_MOTBX, E2_NUMLIQ, E2_BCOCHQ, E2_AGECHQ, E2_CTACHQ, E5_DOCUMEN, E5_DATA, E5_TIPODOC "
	cQuery += "	FROM "+RETSQLNAME("SE2")+" SE2 "
  	cQuery += "	LEFT JOIN "+RETSQLNAME("SA2")+" SA2 ON SA2.D_E_L_E_T_='' AND A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SE5")+" SE5 ON SE5.D_E_L_E_T_='' AND E2_PREFIXO=E5_PREFIXO AND E2_NUM=E5_NUMERO AND E2_PARCELA=E5_PARCELA AND E2_TIPO=E5_TIPO AND E2_FORNECE=E5_CLIFOR AND E2_LOJA=E5_LOJA "
   	cQuery += "	WHERE "
   	cQuery += "	(SE2.D_E_L_E_T_=' ' "
	cQuery += "	AND E5_SITUACA <> 'C' "
    cQuery += " AND E5_MOTBX = 'LIQ' AND E5_TIPODOC = 'BA'" 
	cQuery += " AND E5_DOCUMEN BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
 	cQuery += " AND E2_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND E2_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"')"
	cQuery += "	OR "
   	cQuery += "	(SE2.D_E_L_E_T_=' ' "
 //	cQuery += "	AND E5_SITUACA = ' ' "
	cQuery += " AND E2_NUMLIQ BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
 	cQuery += " AND E2_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND E2_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"')"
	cQuery += "	ORDER BY E2_FORNECE, E2_EMISSAO, E2_NUM, E2_PARCELA, E2_TIPO "
  		

	IF Select("TRB") <> 0
		DbSelectArea("TRB")
		DbCloseArea()
	ENDIF
	
	TCQUERY cQuery NEW ALIAS "TRB"	
	
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	
	oReport:SetMeter(TRB->(LastRec()))	

	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		oSection1:Init()

		oReport:IncMeter()
					
		cDoc 	:= TRB->E2_FORNECE
		IncProc("Imprimindo "+alltrim(TRB->E2_FORNECE))
		
		oSection1:Cell("E2_FORNECE"):SetValue(TRB->E2_FORNECE)
		oSection1:Cell("E2_LOJA"):SetValue(TRB->E2_LOJA)
		oSection1:Cell("A2_NOME"):SetValue(TRB->A2_NOME)
		oSection1:Printline()
		
		oSection2:init()
		
		While TRB->E2_FORNECE == cDoc  

			oReport:IncMeter()		

			_cPRFAnt := TRB->E2_PREFIXO
			_cNUMAnt := TRB->E2_NUM  
			_cPCAnt	 := TRB->E2_PARCELA
            _cOBS := Space(1)
            
            If !Empty(TRB->E5_DOCUMEN)
            	_cOBS := "Num.Liq.: "+TRB->E5_DOCUMEN  
            	_cSTATUS := "Baixado" 
            	If TRB->E5_VALOR < TRB->E2_VALOR 
            		_cSTATUS := "Baixa Parc."
            	Endif            	
            Endif
			
			If !Empty(TRB->E2_NUMLIQ)
				_cOBS := "Num.Liq.: "+TRB->E2_NUMLIQ+" - Bco: "+AllTrim(TRB->E2_BCOCHQ)+ " Ag: "+ AllTrim(TRB->E2_AGECHQ)+ " Cta: "+AllTrim(TRB->E2_CTACHQ)
				_cSTATUS := "Gerado"
			Endif
		
			IncProc("Imprimindo "+alltrim(TRB->E2_FORNECE))
			oSection2:Cell("PRF"):SetValue(TRB->E2_PREFIXO)
			oSection2:Printline()
	

 			TRB->(dbSkip())   
 			
 			If _cPRFAnt = TRB->E2_PREFIXO .and. _cNUMAnt = TRB->E2_NUM .and. _cPCAnt = TRB->E2_PARCELA 
 				_lExiste	:= .t.
 			Else
				_lExiste 	:= .f.
			Endif

 		EndDo		
 		oSection2:Finish()
 		oReport:ThinLine()

		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "Da Liquidacao ?" , "", "", "mv_ch1", "C", 6, 0, 0, "G", "", "","", "", "mv_par01")
	putSx1(cPerg, "02", "Até Liquidacao?" , "", "", "mv_ch2", "C", 6, 0, 0, "G", "", "", "", "", "mv_par02")
	putSx1(cPerg, "03", "Do Fornecedor  ?"	  , "", "", "mv_ch3", "C", 6, 0, 0, "G", "", "SA2","", "", "mv_par03")
	putSx1(cPerg, "04", "Até Fornecedor ?"	  , "", "", "mv_ch4", "C", 6, 0, 0, "G", "", "SA2", "", "", "mv_par04")
	putSx1(cPerg, "05", "Data de  ?"	  , "", "", "mv_ch5", "D", 8, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Data ate ?"	  , "", "", "mv_ch6", "D", 8, 0, 0, "G", "", "", "", "", "mv_par06")
return
