#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat005()
	Local oReport := nil
	Local cPerg:= Padr("RELAT005",10)
	Public _cOBS
	Public _cMotivo
	Public _lExiste  := .F.  
    
	
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
	
	oReport := TReport():New(cNome,"Posicao de Cliente",cNome,{|oReport| ReportPrint(oReport)},"Posicao de Cliente")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Posicao de Cliente", {"SE1"}, , .F., .T.)
 	TRCell():New(oSection1,"E1_CLIENTE"		,"TRB","Código"  		,"@!",6)
	TRCell():New(oSection1,"E1_LOJA"		,"TRB","LJ"  		,"@!",2)
	TRCell():New(oSection1,"A1_NOME"		,"TRB","Cliente"  		,"@!",40)

	oSection2:= TRSection():New(oReport, "Itens", {"SE1"}, NIL, .F., .T.)     
	
	TRCell():New( oSection2, 'PRF',	    	'TRB', 'PRF',		        PesqPict( 'SE1', 'E1_PREFIXO' ),	3,,	 						    { || TRB->E1_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	   	'TRB', 'NUMERO',	        PesqPict( 'SE1', 'E1_NUM' ),		9,,						 	    { || TRB->E1_NUM } )
	TRCell():New( oSection2, 'PC',	   		'TRB', 'PC',		        PesqPict( 'SE1', 'E1_PARCELA' ),	1,,	 						    { || TRB->E1_PARCELA } )
	TRCell():New( oSection2, 'TIPO',		'TRB', 'TIPO',		        PesqPict( 'SE1', 'E1_TIPO' ),		1,,	 						    { || TRB->E1_TIPO } )
 	TRCell():New( oSection2, 'EMISSAO',	   	'TRB', 'EMISSAO',		    PesqPict( 'SE1', 'E1_EMISSAO' ),	8,,	 						    { || Substr(TRB->E1_EMISSAO,7,2)+"/"+Substr(TRB->E1_EMISSAO,5,2)+"/"+Substr(TRB->E1_EMISSAO,3,2) } )
 	TRCell():New( oSection2, 'VENCTO',	   	'TRB', 'VENCTO',		    PesqPict( 'SE1', 'E1_VENCTO' ),		8,,	 						    { || Substr(TRB->E1_VENCTO,7,2)+"/"+Substr(TRB->E1_VENCTO,5,2)+"/"+Substr(TRB->E1_VENCTO,3,2) } )
 	TRCell():New( oSection2, 'BAIXA',	   	'TRB', 'BAIXA',		        PesqPict( 'SE1', 'E1_BAIXA' ),		8,,	 						    { || Substr(TRB->E1_BAIXA,7,2)+"/"+Substr(TRB->E1_BAIXA,5,2)+"/"+Substr(TRB->E1_BAIXA,3,2) } )
	TRCell():New( oSection2, 'VORIG',		'TRB', 'VL.ORIGINAL',		PesqPict( 'SE1', 'E1_VALOR' ),		12,, 						    { || TRB->E1_VALOR } )
	TRCell():New( oSection2, 'VPAGO',		'TRB', 'VL.RECEBIDO',		PesqPict( 'SE1', 'E1_VALOR' ),		12,, 						    { || TRB->E1_VALOR - TRB->E1_SALDO } )
  	TRCell():New( oSection2, 'SALDO',		'TRB', 'SALDO ATUAL',		PesqPict( 'SE1', 'E1_VALOR' ),		12,, 						    { || TRB->E1_SALDO } )
	TRCell():New( oSection2, 'MOTIVO',	   	'TRB', 'MOTIVO',	        "@!"						 ,		3,,						 	    { || _cMotivo } )
	TRCell():New( oSection2, 'OBSERVACAO', 	'TRB', 'OBSERVACAO',        "@",								30,,					 	    { || _cOBS } )

    oSection2:SetTotalInLine(.f.)    
    
    TRFunction():New(oSection2:Cell("VORIG"),NIL,"SUM",,,,{ || Iif(_lExiste, 0 ,TRB->E1_VALOR) } ,.T.,.T.) 
	TRFunction():New(oSection2:Cell("VPAGO"),NIL,"SUM",,,,,.T.,.T.)    
	TRFunction():New(oSection2:Cell("SALDO"),NIL,"SUM",,,,{ || Iif(_lExiste, 0, TRB->E1_SALDO) } ,.T.,.T.) 
	
	oReport:SetTotalInLine(.F.)    
   
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local lPrim 	:= .T.	    

	cQuery := "	SELECT E1_CLIENTE, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_LOJA, E1_VALOR, E1_BAIXA, E1_VENCTO, E1_EMISSAO, E1_SALDO, A1_NOME "
	cQuery += "	FROM "+RETSQLNAME("SE1")+" SE1 "
  	cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA "
   	cQuery += "	WHERE SE1.D_E_L_E_T_=' ' " 
 	cQuery += " AND E1_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND E1_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"
 	cQuery += " AND E1_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"  
 	If !Empty(mv_par07) // Deseja imprimir apenas os tipos do parametro 07
		cQuery += " 		AND E1_TIPO IN "+FormatIn(mv_par07,";")
	ElseIf !Empty(Mv_par08) // Deseja Excluir os tipos do parametro 08
		cQuery += " 		AND E1_TIPO NOT IN "+FormatIn(mv_par08,";")
	EndIf 
	cQuery += " AND E1_VENCTO BETWEEN '"+Dtos(mv_par09)+"' AND '"+Dtos(mv_par10)+"'"
	cQuery += " AND E1_EMISSAO BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"'"

	cQuery += "	ORDER BY E1_CLIENTE, E1_EMISSAO, E1_NUM, E1_PARCELA, E1_TIPO "
  		
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
            _cMotivo := Space(3) 
            
	        If !Empty(TRB->E1_BAIXA)    
	        
		        dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+TRB->E1_PREFIXO+TRB->E1_NUM+TRB->E1_PARCELA+TRB->E1_TIPO+TRB->E1_CLIENTE+TRB->E1_LOJA+"01")
		
				    If !Empty(E5_DOCUMEN)
		            	_cOBS := "Doc: "+E5_DOCUMEN
		            Endif
					
					Do Case
						Case E5_MOTBX = "CEC"
							_cOBS := "Num.Comp.: "+E5_IDENTEE
						Case E5_MOTBX = "NOR"
							_cOBS := "Bco: "+AllTrim(E5_BANCO)+ " Ag: "+ AllTrim(E5_AGENCIA)+ " Cta: "+AllTrim(E5_CONTA)
					EndCase   
	
				  	_cMotivo := E5_MOTBX
				  		 
				Endif
				
				DbSelectArea("TRB")
			
			Endif
			
		
			IncProc("Imprimindo "+alltrim(TRB->E1_CLIENTE))
			oSection2:Cell("PRF"):SetValue(TRB->E1_PREFIXO)
			oSection2:Printline()
	

 			TRB->(dbSkip()) 
 			
 			If _cPRFAnt = TRB->E1_PREFIXO .and. _cNUMAnt = TRB->E1_NUM .and. _cPCAnt = TRB->E1_PARCELA  
 				_lExiste := .t.  
 			Else
				_lExiste := .f.
			Endif
 		EndDo		
 		oSection2:Finish()
 		oReport:ThinLine()

		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "Do Cliente  ?"	  , "", "", "mv_ch1", "C", 6, 0, 0, "G", "", "SA1","", "", "mv_par01")
	putSx1(cPerg, "02", "Até Cliente ?"	  , "", "", "mv_ch2", "C", 6, 0, 0, "G", "", "SA1", "", "", "mv_par02")
	putSx1(cPerg, "03", "Dt.Baixa de  ?"  , "", "", "mv_ch3", "D", 8, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Dt.Baixa ate ?"  , "", "", "mv_ch4", "D", 8, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Do Titulo ?"	  , "", "", "mv_ch5", "C", 9, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Até Titulo ?"	  , "", "", "mv_ch6", "C", 9, 0, 0, "G", "", "", "", "", "mv_par06")   
	putSx1(cPerg, "07", "Imprimir Tipos"  , "", "", "mv_ch7", "C", 50, 0, 0, "G", "", "", "", "", "mv_par07")
	putSx1(cPerg, "08", "Não imprimir Tipos","","", "mv_ch8", "C", 50, 0, 0, "G", "", "", "", "", "mv_par08") 
	putSx1(cPerg, "09", "Dt.Vencto de  ?"	  , "", "", "mv_ch9", "D", 8, 0, 0, "G", "", "", "", "", "mv_par09")
	putSx1(cPerg, "10", "Dt.Vencto ate ?"	  , "", "", "mv_ch10","D", 8, 0, 0, "G", "", "", "", "", "mv_par10")
	putSx1(cPerg, "11", "Dt.Emissão de  ?"	  , "", "", "mv_ch11","D", 8, 0, 0, "G", "", "", "", "", "mv_par11")
	putSx1(cPerg, "12", "Dt.Emissão ate ?"	  , "", "", "mv_ch12","D", 8, 0, 0, "G", "", "", "", "", "mv_par12")

return