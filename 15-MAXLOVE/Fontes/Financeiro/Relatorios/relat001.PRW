#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'



/*/{Protheus.doc} relat001
 Relatorio Posicao de Fornecedor
@type function
@version 1.0  
@author fabio.favaretto
@since 8/2/2022
@return 
/*/
User Function relat001()
	Local oReport := nil
	Local cPerg:= Padr("RELAT001",10)
	Public _cOBS 
	Public _cMotivo
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
	
	oReport := TReport():New(cNome,"Posicao de Fornecedor",cNome,{|oReport| ReportPrint(oReport)},"Posicao de Fornecedor")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Posicao de Fornecedor", {"SE2"}, , .F., .T.)
 	TRCell():New(oSection1,"E2_FORNECE"		,"TRB","Código"  		,"@!",6)
	TRCell():New(oSection1,"E2_LOJA"		,"TRB","LJ"  		,"@!",2)
	TRCell():New(oSection1,"A2_NOME"		,"TRB","Fornecedor"  		,"@!",40)

	oSection2:= TRSection():New(oReport, "Itens", {"SE2"}, NIL, .F., .T.)     
	
	TRCell():New( oSection2, 'PRF',	    	'TRB', 'PRF',		        PesqPict( 'SE2', 'E2_PREFIXO' ),	3,,	 						    { || TRB->E2_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	   	'TRB', 'NUMERO',	        PesqPict( 'SE2', 'E2_NUM' ),		9,,						 	    { || TRB->E2_NUM } )
	TRCell():New( oSection2, 'PC',	   		'TRB', 'PC',		        PesqPict( 'SE2', 'E2_PARCELA' ),	1,,	 						    { || TRB->E2_PARCELA } )
	TRCell():New( oSection2, 'TIPO',		'TRB', 'TIPO',		        PesqPict( 'SE2', 'E2_TIPO' ),		1,,	 						    { || TRB->E2_TIPO } )
 	TRCell():New( oSection2, 'EMISSAO',	   	'TRB', 'EMISSAO',		    PesqPict( 'SE2', 'E2_EMISSAO' ),	8,,	 						    { || Substr(TRB->E2_EMISSAO,7,2)+"/"+Substr(TRB->E2_EMISSAO,5,2)+"/"+Substr(TRB->E2_EMISSAO,3,2) } )
 	TRCell():New( oSection2, 'VENCTO',	   	'TRB', 'VENCTO',		    PesqPict( 'SE2', 'E2_VENCTO' ),		8,,	 						    { || Substr(TRB->E2_VENCTO,7,2)+"/"+Substr(TRB->E2_VENCTO,5,2)+"/"+Substr(TRB->E2_VENCTO,3,2) } )
 	TRCell():New( oSection2, 'BAIXA',	   	'TRB', 'BAIXA',		        PesqPict( 'SE2', 'E2_BAIXA' ),		8,,	 						    { || Substr(TRB->E2_BAIXA,7,2)+"/"+Substr(TRB->E2_BAIXA,5,2)+"/"+Substr(TRB->E2_BAIXA,3,2) } )
	TRCell():New( oSection2, 'VORIG',		'TRB', 'VL.ORIGINAL',		PesqPict( 'SE2', 'E2_VALOR' ),		12,, 						    { || TRB->E2_VALOR } )
	TRCell():New( oSection2, 'VPAGO',		'TRB', 'VL.PAGO',			PesqPict( 'SE2', 'E2_SALDO' ),		12,, 						    { || TRB->E2_VALOR - TRB->E2_SALDO } )
	TRCell():New( oSection2, 'SALDO',		'TRB', 'SALDO',				PesqPict( 'SE2', 'E2_VALOR' ),		12,, 						    { || Iif(_lExiste, 0, TRB->E2_SALDO) } )
	TRCell():New( oSection2, 'MOTIVO',	   	'TRB', 'MOTIVO',	        "@!"						,		3,,						 	    { || _cMotivo } )
	TRCell():New( oSection2, 'OBSERVACAO', 	'TRB', 'OBSERVACAO',        "@",								30,,					 	    { || _cOBS } )

    oSection2:SetTotalInLine(.f.)    
  
    TRFunction():New(oSection2:Cell("VORIG"),NIL,"SUM",,,,{ || Iif(_lExiste, 0 ,TRB->E2_VALOR) } ,.T.,.T.) 
	TRFunction():New(oSection2:Cell("VPAGO"),NIL,"SUM",,,,,.T.,.T.)  
	TRFunction():New(oSection2:Cell("SALDO"),NIL,"SUM",,,,{ || Iif(_lExiste, 0, TRB->E2_SALDO) } ,.T.,.T.) 
 	
	oReport:SetTotalInLine(.F.)    
   
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local lPrim 	:= .T.	    

	cQuery := "	SELECT E2_FORNECE, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_LOJA, E2_BAIXA, E2_VALOR, E2_VENCTO, E2_EMISSAO, E2_SALDO, A2_NOME "
	cQuery += "	FROM "+RETSQLNAME("SE2")+" SE2 "
   	cQuery += "	LEFT JOIN "+RETSQLNAME("SA2")+" SA2 ON SA2.D_E_L_E_T_='' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA "
  	cQuery += "	WHERE SE2.D_E_L_E_T_=' ' "
 	cQuery += " AND E2_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND E2_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"
 	cQuery += " AND E2_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"  
 	If !Empty(mv_par07) // Deseja imprimir apenas os tipos do parametro 07
		cQuery += " 		AND E2_TIPO IN "+FormatIn(mv_par07,";")
	ElseIf !Empty(Mv_par08) // Deseja Excluir os tipos do parametro 08
		cQuery += " 		AND E2_TIPO NOT IN "+FormatIn(mv_par08,";")
	EndIf 
	cQuery += " AND E2_VENCTO BETWEEN '"+Dtos(mv_par09)+"' AND '"+Dtos(mv_par10)+"'"
	cQuery += " AND E2_EMISSAO BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"'"
	cQuery += "	ORDER BY E2_FORNECE, E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO "
  		
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
		
			_cPRFAnt := TRB->E2_PREFIXO
			_cNUMAnt := TRB->E2_NUM  
			_cPCAnt	 := TRB->E2_PARCELA  
		
			oReport:IncMeter()		
                                 
            _cOBS := Space(1)  
            _cMotivo := Space(3) 
            
	        If !Empty(TRB->E2_BAIXA)    
	        
		        dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+TRB->E2_PREFIXO+TRB->E2_NUM+TRB->E2_PARCELA+TRB->E2_TIPO+TRB->E2_FORNECE+TRB->E2_LOJA+"01")
			 
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
		
					
	   		IncProc("Imprimindo "+alltrim(TRB->E2_FORNECE))
			oSection2:Cell("PRF"):SetValue(TRB->E2_PREFIXO)
			oSection2:Printline()
	

 			TRB->(dbSkip())     
 			
 			If _cPRFAnt = TRB->E2_PREFIXO .and. _cNUMAnt = TRB->E2_NUM .and. _cPCAnt = TRB->E2_PARCELA  
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
	putSx1(cPerg, "01", "Do Fornecedor  ?"	  , "", "", "mv_ch1", "C", 6, 0, 0, "G", "", "SA2","", "", "mv_par01")
	putSx1(cPerg, "02", "Até Fornecedor ?"	  , "", "", "mv_ch2", "C", 6, 0, 0, "G", "", "SA2", "", "", "mv_par02")
	putSx1(cPerg, "03", "Dt.Baixa de  ?"	  , "", "", "mv_ch3", "D", 8, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Dt.Baixa ate ?"	  , "", "", "mv_ch4", "D", 8, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Do Titulo ?"	  , "", "", "mv_ch5", "C", 9, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Até Titulo ?"	  , "", "", "mv_ch6", "C", 9, 0, 0, "G", "", "", "", "", "mv_par06")   
	putSx1(cPerg, "07", "Imprimir Tipos"  , "", "", "mv_ch7", "C", 50, 0, 0, "G", "", "", "", "", "mv_par07")
	putSx1(cPerg, "08", "Não imprimir Tipos","","", "mv_ch8", "C", 50, 0, 0, "G", "", "", "", "", "mv_par08")  
	putSx1(cPerg, "09", "Dt.Vencto de  ?"	  , "", "", "mv_ch9", "D", 8, 0, 0, "G", "", "", "", "", "mv_par09")
	putSx1(cPerg, "10", "Dt.Vencto ate ?"	  , "", "", "mv_ch10","D", 8, 0, 0, "G", "", "", "", "", "mv_par10")
	putSx1(cPerg, "11", "Dt.Emissão de  ?"	  , "", "", "mv_ch11","D", 8, 0, 0, "G", "", "", "", "", "mv_par11")
	putSx1(cPerg, "12", "Dt.Emissão ate ?"	  , "", "", "mv_ch12","D", 8, 0, 0, "G", "", "", "", "", "mv_par12")

return
