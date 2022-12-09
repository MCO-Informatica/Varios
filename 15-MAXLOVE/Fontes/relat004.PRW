#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat004()
	Local oReport := nil
	Local cPerg:= Padr("RELAT004",10)
	Public _cOBS 
	Public _lExiste
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
	
	oReport := TReport():New(cNome,"Relacao de Baixas - Pagar",cNome,{|oReport| ReportPrint(oReport)},"Rel. Baixas - Pagar")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Baixas a Pagar", {"SE5"}, , .F., .T.)
 	TRCell():New(oSection1,"E5_CLIFOR"		,"TRB","Código"  		,"@!",6)
	TRCell():New(oSection1,"A2_NOME"		,"TRB","Fornecedor"  		,"@!",40)

	oSection2:= TRSection():New(oReport, "Itens", {"SE5"}, NIL, .F., .T.)     
	
	TRCell():New( oSection2, 'PRF',	    	'TRB', 'PRF',		        PesqPict( 'SE5', 'E5_PREFIXO' ),	3,,	 						    { || TRB->E5_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	   	'TRB', 'NUMERO',	        PesqPict( 'SE5', 'E5_NUMERO' ),		9,,						 	    { || TRB->E5_NUMERO } )
	TRCell():New( oSection2, 'PC',	   		'TRB', 'PC',		        PesqPict( 'SE5', 'E5_PARCELA' ),	1,,	 						    { || TRB->E5_PARCELA } )
	TRCell():New( oSection2, 'TIPO',		'TRB', 'TIPO',		        PesqPict( 'SE5', 'E5_TIPO' ),		1,,	 						    { || TRB->E5_TIPO } )
 	TRCell():New( oSection2, 'EMISSAO',	   	'TRB', 'EMISSAO',		    PesqPict( 'SE2', 'E2_EMISSAO' ),	8,,	 						    { || Substr(TRB->E2_EMISSAO,7,2)+"/"+Substr(TRB->E2_EMISSAO,5,2)+"/"+Substr(TRB->E2_EMISSAO,3,2) } )
 	TRCell():New( oSection2, 'VENCTO',	   	'TRB', 'VENCTO',		    PesqPict( 'SE2', 'E2_VENCTO' ),		8,,	 						    { || Substr(TRB->E2_VENCTO,7,2)+"/"+Substr(TRB->E2_VENCTO,5,2)+"/"+Substr(TRB->E2_VENCTO,3,2) } )
 	TRCell():New( oSection2, 'BAIXA',	   	'TRB', 'BAIXA',		        PesqPict( 'SE5', 'E5_DATA' ),		8,,	 						    { || Substr(TRB->E5_DATA,7,2)+"/"+Substr(TRB->E5_DATA,5,2)+"/"+Substr(TRB->E5_DATA,3,2) } )
	TRCell():New( oSection2, 'VORIG',		'TRB', 'VL.ORIGINAL',		PesqPict( 'SE2', 'E2_VALOR' ),		12,, 						    { || TRB->E2_VALOR } )
	TRCell():New( oSection2, 'VPAGO',		'TRB', 'VL.PAGO',			PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E5_VALOR } )
	TRCell():New( oSection2, 'SALDO',		'TRB', 'SALDO',				PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E2_SALDO } )
	TRCell():New( oSection2, 'TPDOC',	   	'TRB', 'TPDOC',		        PesqPict( 'SE5', 'E5_TIPODOC' ),	3,,						 	    { || TRB->E5_TIPODOC } )
	TRCell():New( oSection2, 'MOTIVO',	   	'TRB', 'MOTIVO',	        PesqPict( 'SE5', 'E5_MOTBX' ),		3,,						 	    { || TRB->E5_MOTBX } )
	TRCell():New( oSection2, 'HISTORICO', 	'TRB', 'HISTORICO',            "@",								100,,					 	    { || _cOBS } )

    oSection2:SetTotalInLine(.f.)    
  
    TRFunction():New(oSection2:Cell("VORIG"),NIL,"SUM",,,,{ || Iif(_lExiste, 0, TRB->E2_VALOR) } ,.T.,.T.) 
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
	Local _cPRFAnt  := ""
	Local _cNUMAnt  := ""  
	Local _cPCAnt	:= ""
	Local _cTipoAnt := ""
	Local _cTpDocAnt := ""  

	cQuery := "	SELECT E5_CLIFOR, E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_LOJA, E5_RECPAG, E5_VALOR, E2_VALOR, E2_VENCTO, E2_EMISSAO, E2_SALDO, A2_NOME, E5_MOTBX, E5_TIPODOC, E5_IDENTEE, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DOCUMEN, E5_SEQ, E5_HISTOR "
	cQuery += "	FROM "+RETSQLNAME("SE5")+" SE5 "
  	cQuery += "	LEFT JOIN "+RETSQLNAME("SA2")+" SA2 ON SA2.D_E_L_E_T_='' AND A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=E5_CLIFOR AND A2_LOJA=E5_LOJA "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SE2")+" SE2 ON SE2.D_E_L_E_T_='' AND E5_PREFIXO=E2_PREFIXO AND E5_NUMERO=E2_NUM AND E5_PARCELA=E2_PARCELA AND E5_TIPO=E2_TIPO AND E5_CLIFOR=E2_FORNECE AND E5_LOJA=E2_LOJA "
  	cQuery += "	WHERE SE5.D_E_L_E_T_=' ' "
	cQuery += "	AND E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','E2') "
	cQuery += "	AND E5_SITUACA NOT IN ('C','X','E') "
	cQuery += " AND E5_RECPAG = 'P' " 
 	cQuery += " AND E5_CLIFOR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND E5_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"
	cQuery += " AND E2_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"
	cQuery += " AND E5_NUMERO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"  
 	If !Empty(mv_par09) // Deseja imprimir apenas os tipos do parametro 09
		cQuery += " 		AND E5_PREFIXO IN "+FormatIn(mv_par09,";")
	ElseIf !Empty(Mv_par10) // Deseja excluir os tipos do parametro 10
		cQuery += " 		AND E5_PREFIXO NOT IN "+FormatIn(mv_par10,";")  
	EndIf
	
	If !Empty(Mv_par11) // Deseja imprimir os tipos de baixa
		cQuery += " 		AND E5_MOTBX IN "+FormatIn(mv_par11,";")
	EndIf  
	
	cQuery += "	ORDER BY E5_CLIFOR, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_DATA "
  		
	IF Select("TRB") <> 0
		DbSelectArea("TRB")
		DbCloseArea()
	ENDIF
	
	TCQUERY cQuery NEW ALIAS "TRB"	
	
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	
	oReport:SetMeter(TRB->(LastRec()))	
    
	_nSaldoAnt := 0  

	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		oSection1:Init()

		oReport:IncMeter()
					
		cDoc 	:= TRB->E5_CLIFOR
		IncProc("Imprimindo "+alltrim(TRB->E5_CLIFOR))
		
		oSection1:Cell("E5_CLIFOR"):SetValue(TRB->E5_CLIFOR)
		oSection1:Cell("A2_NOME"):SetValue(TRB->A2_NOME)
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		While TRB->E5_CLIFOR == cDoc
			
			_cPRFAnt := TRB->E5_PREFIXO
			_cNUMAnt := TRB->E5_NUMERO  
			_cPCAnt	 := TRB->E5_PARCELA  
			_cTPAnt	 := TRB->E5_TIPO
								
			oReport:IncMeter()		
                                 
            _cOBS := Space(1)
            
            If !Empty(TRB->E5_DOCUMEN)
            	_cOBS := "Doc: "+TRB->E5_DOCUMEN+" - "+TRB->E5_HISTOR
            Endif
			
			Do Case
				Case TRB->E5_MOTBX = "CEC"
					_cOBS := "Num.Comp.: "+TRB->E5_IDENTEE+" - "+TRB->E5_HISTOR
				Case TRB->E5_MOTBX = "NOR"
					_cOBS := "Bco: "+AllTrim(TRB->E5_BANCO)+ " Ag: "+ AllTrim(TRB->E5_AGENCIA)+ " Cta: "+AllTrim(TRB->E5_CONTA)+" - "+TRB->E5_HISTOR
				Case TRB->E5_MOTBX = "DEB"
					_cOBS := "Bco: "+AllTrim(TRB->E5_BANCO)+ " Ag: "+ AllTrim(TRB->E5_AGENCIA)+ " Cta: "+AllTrim(TRB->E5_CONTA)+" - "+TRB->E5_HISTOR
			EndCase
				
		
			IncProc("Imprimindo "+alltrim(TRB->E5_CLIFOR))
			oSection2:Cell("PRF"):SetValue(TRB->E5_PREFIXO)
			oSection2:Printline()
	
			TRB->(dbSkip())
 			
 			If _cPRFAnt = TRB->E5_PREFIXO .and. _cNUMAnt = TRB->E5_NUMERO .and. _cPCAnt = TRB->E5_PARCELA .and. _cTPAnt = TRB->E5_TIPO  
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
	putSx1(cPerg, "05", "Dt.Emissao de  ?"	  , "", "", "mv_ch5", "D", 8, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Dt.Emissão ate ?"	  , "", "", "mv_ch6", "D", 8, 0, 0, "G", "", "", "", "", "mv_par06")
	putSx1(cPerg, "07", "Do Titulo ?"	  , "", "", "mv_ch7", "C", 9, 0, 0, "G", "", "", "", "", "mv_par07")
	putSx1(cPerg, "08", "Ate Titulo ?"	  , "", "", "mv_ch8", "C", 9, 0, 0, "G", "", "", "", "", "mv_par08")   
	putSx1(cPerg, "09", "Imprimir Prefixos"  , "", "", "mv_ch9", "C", 50, 0, 0, "G", "", "", "", "", "mv_par09")
	putSx1(cPerg, "10", "Não imprimir Prefixos","","", "mv_ch10", "C", 50, 0, 0, "G", "", "", "", "", "mv_par10")
	putSx1(cPerg, "11", "Imprimir Tipos de Baixa","","", "mv_ch11", "C", 50, 0, 0, "G", "", "", "", "", "mv_par11")
return