#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat006()
	Local oReport := nil
	Local cPerg:= Padr("RELAT006",10)
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
	
	oReport := TReport():New(cNome,"Liquidacao - Receber",cNome,{|oReport| ReportPrint(oReport)},"Liquidacao - Receber")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Liquidacao - Receber", {"SE1"}, , .F., .T.)
 	TRCell():New(oSection1,"E1_CLIENTE"		,"TRB","Código"  		,"@!",6)
	TRCell():New(oSection1,"E1_LOJA"		,"TRB","LJ"  		,"@!",2)
	TRCell():New(oSection1,"A1_NOME"		,"TRB","Cliente"  		,"@!",40)

	oSection2:= TRSection():New(oReport, "Itens", {"SE1"}, NIL, .F., .T.)     
	
	TRCell():New( oSection2, 'PRF',	    	'TRB', 'PRF',		        PesqPict( 'SE1', 'E1_PREFIXO' ),	3,,	 						    { || TRB->E1_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	   	'TRB', 'NUMERO',	        PesqPict( 'SE1', 'E1_NUM' ),		9,,						 	    { || TRB->E1_NUM } )
	TRCell():New( oSection2, 'PC',	   		'TRB', 'PC',		        PesqPict( 'SE1', 'E1_PARCELA' ),	1,,	 						    { || TRB->E1_PARCELA } )
	TRCell():New( oSection2, 'TIPO',		'TRB', 'TIPO',		        PesqPict( 'SE1', 'E1_TIPO' ),		1,,	 						    { || TRB->E1_TIPO } )
 	TRCell():New( oSection2, 'EMISSAO',	   	'TRB', 'EMISSAO',		    PesqPict( 'SE1', 'E1_EMISSAO' ),	8,,	 						    { || Substr(TRB->E1_EMISSAO,7,2)+"/"+Substr(TRB->E1_EMISSAO,5,2)+"/"+Substr(TRB->E1_EMISSAO,3,2) } )
 	TRCell():New( oSection2, 'BAIXA',	   	'TRB', 'BAIXA',		        PesqPict( 'SE5', 'E5_DATA' ),		8,,	 						    { || Substr(TRB->E5_DATA,7,2)+"/"+Substr(TRB->E5_DATA,5,2)+"/"+Substr(TRB->E5_DATA,3,2) } )
	TRCell():New( oSection2, 'EMITENTE',	'TRB', 'EMITENTE',	        "@!"						,		30,,						    { || TRB->E1_EMITCHQ } )
	TRCell():New( oSection2, 'VORIG',		'TRB', 'VL.ORIGINAL',		PesqPict( 'SE1', 'E1_VALOR' ),		12,, 						    { || TRB->E1_VALOR } )
	TRCell():New( oSection2, 'VPAGO',		'TRB', 'VL.PAGO',			PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E5_VALOR } )
  	TRCell():New( oSection2, 'SALDO',		'TRB', 'SALDO',				PesqPict( 'SE1', 'E1_VALOR' ),		12,, 						    { || Iif(_lExiste .or. TRB->E1_TIPO = "CH", 0, TRB->E1_SALDO) } )
	TRCell():New( oSection2, 'MOTIVO',	   	'TRB', 'MOTIVO',	        PesqPict( 'SE5', 'E5_MOTBX' ),		3,,						 	    { || TRB->E5_MOTBX } )
	TRCell():New( oSection2, 'OBSERVACAO', 	'TRB', 'OBSERVACAO',        "@",								30,,					 	    { || _cOBS } )
	TRCell():New( oSection2, 'STATUS', 		'TRB', 'STATUS', 	        "@",								10,,					 	    { || _cSTATUS } )

    oSection2:SetTotalInLine(.f.)    
    	
	TRFunction():New(oSection2:Cell("VORIG"),NIL,"SUM",,,,{ || Iif(_lExiste .or. TRB->E1_TIPO = "CH", 0, TRB->E1_VALOR) } ,.T.,.T.) 
	TRFunction():New(oSection2:Cell("VPAGO"),NIL,"SUM",,,,,.T.,.T.)    
	TRFunction():New(oSection2:Cell("SALDO"),NIL,"SUM",,,,{ || Iif(_lExiste .or. TRB->E1_TIPO = "CH", 0, TRB->E1_SALDO) } ,.T.,.T.) 


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
	    

	cQuery := "	SELECT E1_CLIENTE, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_LOJA, E1_VALOR, E5_VALOR, E1_VENCTO, E1_EMISSAO, E1_SALDO, A1_NOME, E5_NUMERO, E5_MOTBX, E1_NUMLIQ, E1_BCOCHQ, E1_AGECHQ, E1_CTACHQ, E5_DOCUMEN, E5_DATA, E1_EMITCHQ, E5_PARCELA, E5_PREFIXO, E5_TIPODOC "
	cQuery += "	FROM "+RETSQLNAME("SE1")+" SE1 "
  	cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SE5")+" SE5 ON SE5.D_E_L_E_T_='' AND E5_PREFIXO=E1_PREFIXO AND E5_NUMERO=E1_NUM AND E5_PARCELA=E1_PARCELA AND E5_TIPO=E1_TIPO AND E5_CLIFOR=E1_CLIENTE AND E5_LOJA=E1_LOJA"
   	cQuery += "	WHERE "
   	cQuery += "	(SE1.D_E_L_E_T_=' ' "
	cQuery += "	AND E5_SITUACA <> 'C' "
    cQuery += " AND E5_MOTBX = 'LIQ' AND E5_TIPODOC = 'BA'" 
	cQuery += " AND E5_DOCUMEN BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
 	cQuery += " AND E1_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND E1_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"')"
	cQuery += "	OR "
   	cQuery += "	(SE1.D_E_L_E_T_=' ' "
	cQuery += "	AND E5_SITUACA = ' ' "
	cQuery += " AND E1_NUMLIQ BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
 	cQuery += " AND E1_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND E1_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"')"
	cQuery += "	ORDER BY E1_CLIENTE, E1_EMISSAO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO "
  		

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
					
		cDoc 	:= TRB->E1_CLIENTE
		IncProc("Imprimindo "+alltrim(TRB->E1_CLIENTE))
		
		oSection1:Cell("E1_CLIENTE"):SetValue(TRB->E1_CLIENTE)
		oSection1:Cell("E1_LOJA"):SetValue(TRB->E1_LOJA)
		oSection1:Cell("A1_NOME"):SetValue(TRB->A1_NOME)
		oSection1:Printline()
		
		oSection2:init()
		
		While TRB->E1_CLIENTE == cDoc 
		
			_cPRFAnt := TRB->E1_PREFIXO
			_cNUMAnt := TRB->E1_NUM  
			_cPCAnt	 := TRB->E1_PARCELA
			  

			oReport:IncMeter()		
                                 
            _cOBS := Space(1)
            
            If !Empty(TRB->E5_DOCUMEN)
            	_cOBS := "Num.Liq.: "+TRB->E5_DOCUMEN  
            	_cSTATUS := "Baixado" 
            	If TRB->E5_VALOR < TRB->E1_VALOR 
            		_cSTATUS := "Baixa Parc."
            	Endif            	
            Endif
			
			If TRB->E5_TIPODOC = "BA" .AND. !Empty(TRB->E1_NUMLIQ)
				_cOBS := "Bco: "+AllTrim(TRB->E1_BCOCHQ)+ " Ag: "+ AllTrim(TRB->E1_AGECHQ)+ " Cta: "+AllTrim(TRB->E1_CTACHQ)
				_cSTATUS := "Gerado"
			Endif
		
			IncProc("Imprimindo "+alltrim(TRB->E1_CLIENTE))
			oSection2:Cell("PRF"):SetValue(TRB->E1_PREFIXO)
			oSection2:Printline()
	

 			TRB->(dbSkip())  
 			
 			If _cPRFAnt = TRB->E1_PREFIXO .and. _cNUMAnt = TRB->E1_NUM .and. _cPCAnt = TRB->E1_PARCELA  
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
	putSx1(cPerg, "03", "Do Cliente  ?"	  , "", "", "mv_ch3", "C", 6, 0, 0, "G", "", "SA1","", "", "mv_par03")
	putSx1(cPerg, "04", "Até Cliente ?"	  , "", "", "mv_ch4", "C", 6, 0, 0, "G", "", "SA1", "", "", "mv_par04")
	putSx1(cPerg, "05", "Data de  ?"	  , "", "", "mv_ch5", "D", 8, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Data ate ?"	  , "", "", "mv_ch6", "D", 8, 0, 0, "G", "", "", "", "", "mv_par06")
return