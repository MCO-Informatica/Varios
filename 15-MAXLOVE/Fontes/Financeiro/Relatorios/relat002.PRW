#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'


/*/{Protheus.doc} relat002
Relatorio - Relacao de Baixas - Receber
@type function
@version  1.0
@author fabio.favaretto
@since 8/2/2022
/*/
User Function relat002()
	Local oReport := nil
	Local cPerg:= Padr("RELAT002",10)
	Public _cOBS  
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
	
	oReport := TReport():New(cNome,"Relacao de Baixas - Receber",cNome,{|oReport| ReportPrint(oReport)},"Rel. Baixas - Receber")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Baixas a Receber", {"SE5"}, , .F., .T.)
 	TRCell():New(oSection1,"E5_CLIFOR"		,"TRB","Código"  		,"@!",6)
	TRCell():New(oSection1,"E5_LOJA"		,"TRB",""  			,"@!",2)
	TRCell():New(oSection1,"A1_NOME"		,"TRB","Cliente"  		,"@!",40)

	oSection2:= TRSection():New(oReport, "Itens", {"SE5"}, NIL, .F., .T.)     
	
	TRCell():New( oSection2, 'PRF',	    	'TRB', 'PRF',		        PesqPict( 'SE5', 'E5_PREFIXO' ),	3,,	 						    { || TRB->E5_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	   	'TRB', 'NUMERO',	        PesqPict( 'SE5', 'E5_NUMERO' ),		9,,						 	    { || TRB->E5_NUMERO } )
	TRCell():New( oSection2, 'PC',	   		'TRB', 'PC',		        PesqPict( 'SE5', 'E5_PARCELA' ),	1,,	 						    { || TRB->E5_PARCELA } )
	TRCell():New( oSection2, 'TIPO',		'TRB', 'TIPO',		        PesqPict( 'SE5', 'E5_TIPO' ),		1,,	 						    { || TRB->E5_TIPO } )
 	TRCell():New( oSection2, 'EMISSAO',	   	'TRB', 'EMISSAO',		    PesqPict( 'SE1', 'E1_EMISSAO' ),	8,,	 						    { || Substr(TRB->E1_EMISSAO,7,2)+"/"+Substr(TRB->E1_EMISSAO,5,2)+"/"+Substr(TRB->E1_EMISSAO,3,2) } )
 	TRCell():New( oSection2, 'VENCTO',	   	'TRB', 'VENCTO',		    PesqPict( 'SE1', 'E1_VENCTO' ),		8,,	 						    { || Substr(TRB->E1_VENCTO,7,2)+"/"+Substr(TRB->E1_VENCTO,5,2)+"/"+Substr(TRB->E1_VENCTO,3,2) } )
 	TRCell():New( oSection2, 'BAIXA',	   	'TRB', 'BAIXA',		        PesqPict( 'SE5', 'E5_DATA' ),		8,,	 						    { || Substr(TRB->E5_DATA,7,2)+"/"+Substr(TRB->E5_DATA,5,2)+"/"+Substr(TRB->E5_DATA,3,2) } )
	TRCell():New( oSection2, 'VORIG',		'TRB', 'VL.ORIGINAL',		PesqPict( 'SE1', 'E1_VALOR' ),		12,, 						    { || TRB->E1_VALOR } )
	TRCell():New( oSection2, 'VPAGO',		'TRB', 'VL.RECEBIDO',		PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || IIF(!TRB->E5_MOTBX$"BEC.DAP.DAV.NFC",TRB->E5_VALOR,0) } )
	TRCell():New( oSection2, 'VDESC',		'TRB', 'VL.DESCTO',			PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || IIF(TRB->E5_MOTBX$"BEC.DAP.DAV.NFC",TRB->E5_VALOR,0) } )
	TRCell():New( oSection2, 'SALDO',		'TRB', 'SALDO ATUAL',		PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E1_SALDO } )
	TRCell():New( oSection2, 'TPDOC',	   	'TRB', 'TPDOC',		        PesqPict( 'SE5', 'E5_TIPODOC' ),	3,,						 	    { || TRB->E5_TIPODOC } )
	TRCell():New( oSection2, 'MOTIVO',	   	'TRB', 'MOTIVO',	        PesqPict( 'SE5', 'E5_MOTBX' ),		3,,						 	    { || TRB->E5_MOTBX } )
	TRCell():New( oSection2, 'HISTORICO', 	'TRB', 'HISTORICO',         "@",								30,,					 	    { || _cOBS } )

    oSection2:SetTotalInLine(.f.)    
   
	TRFunction():New(oSection2:Cell("VORIG"),NIL,"SUM",,,,{ || Iif(_lExiste, 0, TRB->E1_VALOR) } ,.T.,.T.) 
	TRFunction():New(oSection2:Cell("VPAGO"),NIL,"SUM",,,,,.T.,.T.)    
	TRFunction():New(oSection2:Cell("VDESC"),NIL,"SUM",,,,,.T.,.T.)    
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
	Local _cPRFAnt  := ""
	Local _cNUMAnt  := ""  
	Local _cPCAnt	:= ""
	Local _cTipoAnt := ""
	Local _cTpDocAnt := ""  

   

	cQuery := "	SELECT E5_CLIFOR, E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_LOJA, E5_RECPAG, E5_VALOR, E5_SEQ, E1_VALOR, E1_VENCTO, E1_EMISSAO, E1_SALDO, A1_NOME, E5_MOTBX, E5_TIPODOC, E5_IDENTEE, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DOCUMEN "
	cQuery += "	FROM "+RETSQLNAME("SE5")+" SE5 "
  	cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E5_CLIFOR AND A1_LOJA=E5_LOJA "
    cQuery += "	LEFT JOIN "+RETSQLNAME("SE1")+" SE1 ON SE1.D_E_L_E_T_='' AND E5_PREFIXO=E1_PREFIXO AND E5_NUMERO=E1_NUM AND E5_PARCELA=E1_PARCELA AND E5_TIPO=E1_TIPO AND E5_CLIFOR=E1_CLIENTE AND E5_LOJA=E1_LOJA"
  	cQuery += "	WHERE SE5.D_E_L_E_T_=' ' "
	cQuery += "	AND E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE', 'E1') "
	cQuery += "	AND E5_SITUACA NOT IN ('C','X','E') "
	cQuery += " AND E5_RECPAG = 'R' " 
  	cQuery += " AND E5_CLIFOR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND E5_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"
    cQuery += " AND E1_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"
 	cQuery += " AND E5_NUMERO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"   
	
	If !Empty(mv_par09) // Deseja imprimir apenas os tipos do parametro 09
		cQuery += " 		AND E5_TIPO IN "+FormatIn(mv_par09,";")
	ElseIf !Empty(Mv_par10) // Deseja excluir os tipos do parametro 10
		cQuery += " 		AND E5_TIPO NOT IN "+FormatIn(mv_par10,";")  
	EndIf
	
	If !Empty(Mv_par11) // Deseja imprimir os tipos de baixa
		cQuery += " 		AND E5_MOTBX IN "+FormatIn(mv_par11,";")
	EndIf

	cQuery += "	ORDER BY E5_CLIFOR, E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO "
  		
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
					
		cDoc 	:= TRB->E5_CLIFOR
		IncProc("Imprimindo "+alltrim(TRB->E5_CLIFOR))
		
		oSection1:Cell("E5_CLIFOR"):SetValue(TRB->E5_CLIFOR)
		oSection1:Cell("E5_LOJA"):SetValue(TRB->E5_LOJA)
		oSection1:Cell("A1_NOME"):SetValue(TRB->A1_NOME)
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		While TRB->E5_CLIFOR == cDoc  

		
			_cPRFAnt := TRB->E5_PREFIXO
			_cNUMAnt := TRB->E5_NUMERO  
			_cPCAnt	 := TRB->E5_PARCELA
			  
			oReport:IncMeter()		
                                 
            _cOBS := Space(1)
            
            If !Empty(TRB->E5_DOCUMEN)
            	_cOBS := "Doc: "+TRB->E5_DOCUMEN
            Endif
			
			Do Case
				Case TRB->E5_MOTBX = "CEC"
					_cOBS := "Num.Comp.: "+TRB->E5_IDENTEE
				Case TRB->E5_MOTBX = "NOR"
					_cOBS := "Bco: "+AllTrim(TRB->E5_BANCO)+ " Ag: "+ AllTrim(TRB->E5_AGENCIA)+ " Cta: "+AllTrim(TRB->E5_CONTA)
				Case TRB->E5_MOTBX = "DEB"
					_cOBS := "Bco: "+AllTrim(TRB->E5_BANCO)+ " Ag: "+ AllTrim(TRB->E5_AGENCIA)+ " Cta: "+AllTrim(TRB->E5_CONTA)
				Case TRB->E5_MOTBX = "BEC"
					_cOBS := "DESCONTO BONIFICACAO/CREDITO"
				Case TRB->E5_MOTBX = "DAP"
					_cOBS := "DESCONTO A PRAZO"
				Case TRB->E5_MOTBX = "DAV"
					_cOBS := "DESCONTO A VISTA"
				Case TRB->E5_MOTBX = "NFC"
					_cOBS := "DESCONTO NOTA FISCAL CANCELADA"

			EndCase
		  
		
			IncProc("Imprimindo "+alltrim(TRB->E5_CLIFOR))
			oSection2:Cell("PRF"):SetValue(TRB->E5_PREFIXO)
			oSection2:Printline()
	

 			TRB->(dbSkip()) 
 			
 			If _cPRFAnt = TRB->E5_PREFIXO .and. _cNUMAnt = TRB->E5_NUMERO .and. _cPCAnt = TRB->E5_PARCELA  
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
	putSx1(cPerg, "01", "Do Cliente  ?"	  , "", "", "mv_ch1", "C", 6, 0, 0, "G", "", "SA1","", "", "mv_par01")
	putSx1(cPerg, "02", "Até Cliente ?"	  , "", "", "mv_ch2", "C", 6, 0, 0, "G", "", "SA1", "", "", "mv_par02")
	putSx1(cPerg, "03", "Dt.Baixa de  ?"	  , "", "", "mv_ch3", "D", 8, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Dt.Baixa ate ?"	  , "", "", "mv_ch4", "D", 8, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Dt.Emissão de  ?"	  , "", "", "mv_ch5", "D", 8, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Dt.Emissão ate ?"	  , "", "", "mv_ch6", "D", 8, 0, 0, "G", "", "", "", "", "mv_par06")
	putSx1(cPerg, "07", "Do Titulo ?"	  , "", "", "mv_ch7", "C", 9, 0, 0, "G", "", "", "", "", "mv_par07")
	putSx1(cPerg, "08", "Até Titulo ?"	  , "", "", "mv_ch8", "C", 9, 0, 0, "G", "", "", "", "", "mv_par08")
	putSx1(cPerg, "09", "Imprimir Tipos"  , "", "", "mv_ch9", "C", 50, 0, 0, "G", "", "", "", "", "mv_par09")
	putSx1(cPerg, "10", "Não imprimir Tipos","","", "mv_ch10", "C", 50, 0, 0, "G", "", "", "", "", "mv_par10")    
	putSx1(cPerg, "11", "Imprimir Tipos de Baixa","","", "mv_ch11", "C", 50, 0, 0, "G", "", "", "", "", "mv_par11")
return
