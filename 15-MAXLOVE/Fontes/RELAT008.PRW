#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat008()
	Local oReport := nil
	Local cPerg:= Padr("RELAT008",10) 
	
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
	
	oReport := TReport():New(cNome,"Romaneio",cNome,{|oReport| ReportPrint(oReport)},"Relatório Romaneio")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Romaneio", {"SD2"}, , .F., .T.)
	TRCell():New(oSection1,"D2_DOC"		,"TRBSD2","Romaneio"  		,"@!",9)
	TRCell():New(oSection1,"D2_SERIE"   ,"TRBSD2"," "	,"@!",3)
	
	oSection2:= TRSection():New(oReport, "Romaneio", {"SD2"}, NIL, .F., .T.)

	TRCell():New( oSection2, 'Quant.',	    	'TRBSD2', 'Quant.',		        PesqPict( 'SD2', 'D2_QUANT' ),	8,,	 						 	    { || TRBSD2->D2_QUANT } )
	TRCell():New( oSection2, 'Código',	 	    'TRBSD2', 'Código',			    PesqPict( 'SD2', 'D2_COD' ),	15,,	 						 	{ || TRBSD2->D2_QUANT } )
	TRCell():New( oSection2, 'Descrição',	    'TRBSD2', 'Descrição',		    PesqPict( 'SB1', 'B1_DESC' ),	40,,	 						 	{ || TRBSD2->B1_DESC } )
	TRCell():New( oSection2, 'Val.Unit.',	    'TRBSD2', 'Val.Unit.',			PesqPict( 'SD2', 'D2_PRCVEN' ),	8,,	 						 	    { || TRBSD2->D2_PRCVEN } )
	TRCell():New( oSection2, 'Val.Total',	    'TRBSD2', 'Val.Total',			PesqPict( 'SD2', 'D2_TOTAL' ),	8,,	 						 	    { || TRBSD2->D2_TOTAL } )

	TRFunction():New(oSection2:Cell("Val.Total"),NIL,"SUM",,,,,.T.,.F.)    
	
	oReport:SetTotalInLine(.F.)    
   
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cEnd      := "" 
	Local cCidade   := ""  
	Local cCGC		:= ""
	Local cTel		:= ""
	Local lPrim 	:= .T. 
	Local _cPrefSE1	:= "" 
	Local _aVencto  := {}
	Local n	    

	cQuery := "	SELECT D2_DOC, D2_SERIE, D2_EMISSAO, D2_QUANT ,D2_COD, D2_CLIENTE, D2_LOJA, B1_DESC, D2_PRCVEN, D2_TOTAL, A1_COD, A1_LOJA, A1_NOME, A1_END, A1_TIPO, A1_MUN, A1_EST, A1_BAIRRO, A1_CGC, A1_INSCR, A1_DDD, A1_TEL, A1_CONTATO, A1_CEP "
	cQuery += "	FROM "+RETSQLNAME("SD2")+" SD2 "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SB1")+" SB1 ON SB1.D_E_L_E_T_='' AND B1_COD=D2_COD "
 	cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA "
	cQuery += "	WHERE SD2.D_E_L_E_T_=' ' "
//	cQuery += "	AND D2_FILIAL='"+xFilial("SD2")+"' "
	cQuery += " AND D2_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
 	cQuery += " AND D2_SERIE = '"+mv_par03+"'"
	cQuery += "	ORDER BY D2_DOC, D2_SERIE "
  		
	IF Select("TRBSD2") <> 0
		DbSelectArea("TRBSD2")
		DbCloseArea()
	ENDIF
	
	TCQUERY cQuery NEW ALIAS "TRBSD2"	
	
	dbSelectArea("TRBSD2")
	TRBSD2->(dbGoTop())
	
	oReport:SetMeter(TRBSD2->(LastRec()))	

	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		oSection1:Init()

		oReport:IncMeter()
					
		cDoc 	:= TRBSD2->D2_DOC
		IncProc("Imprimindo Romaneio "+alltrim(TRBSD2->D2_DOC))
		
		cEnd := Alltrim(TRBSD2->A1_END)    
   	    If !Empty(TRBSD2->A1_BAIRRO)
   	    	cEnd := cEnd+" - "+AllTrim(TRBSD2->A1_BAIRRO)
   	    ElseIf !Empty(TRBSD2->A1_CEP)
		    cEnd := cEnd+" Cep : "+Substr(TRBSD2->A1_CEP,1,5)+"-"+Substr(TRBSD2->A1_CEP,6,3)
		Endif
		
		
		cCidade := Alltrim(TRBSD2->A1_MUN)    
   	    If !Empty(TRBSD2->A1_EST)
   	    	cCidade := cCidade+"/"+AllTrim(TRBSD2->A1_EST)
   	    Endif

		cCGC := transform(TRBSD2->A1_CGC,If(Len(AllTrim(TRBSD2->A1_CGC))==14,"@R 99.999.999/9999-99","@R 999.999.999-99"))
		cTel := "(" + alltrim(TRBSD2->A1_DDD) + ") " + transform(TRBSD2->A1_TEL,"@R 9999-9999")
		
		oSection1:Cell("D2_DOC"):SetValue(TRBSD2->D2_DOC)
		oSection1:Cell("D2_SERIE"):SetValue(TRBSD2->D2_SERIE)

		oReport:PrintText(" ")    
		oReport:PrintText("Cliente:   "+TRBSD2->A1_COD+"/"+TRBSD2->A1_LOJA+" - "+TRBSD2->A1_NOME)    
   		oReport:PrintText("Endereço:  "+cEnd)    
   		oReport:PrintText("Cidade/UF: "+cCidade)    
   		oReport:PrintText("Cgc/Cpf:   "+cCGC)    
   		oReport:PrintText("Inscr.Est: "+TRBSD2->A1_INSCR)    
        oReport:PrintText("Tel:       "+cTel)  
        oReport:PrintText("Contato:   "+TRBSD2->A1_CONTATO)  
        oReport:PrintText("Emissão:   "+Substr(TRBSD2->D2_EMISSAO,7,2)+"/"+Substr(TRBSD2->D2_EMISSAO,5,2)+"/"+Substr(TRBSD2->D2_EMISSAO,3,2)) 
  		oReport:PrintText(" ")    
 		oReport:ThinLine()
 		oReport:PrintText(" ")    
 		oReport:PrintText("Vencimento(s):")    
 		oReport:PrintText(" ")    

		If TRBSD2->D2_SERIE$"1  "
			_cPrefSE1 := "AT "
		ElseIf TRBSD2->D2_SERIE$"2  "
			_cPrefSE1 := "MA "
		ElseIf TRBSD2->D2_SERIE$"3  "
			_cPrefSE1 := "DR "
		ElseIf TRBSD2->D2_SERIE$"1F "
			_cPrefSE1 := "1F "
		ElseIf TRBSD2->D2_SERIE$"2F "
			_cPrefSE1 := "2F "
		ElseIf TRBSD2->D2_SERIE$"3F "
			_cPrefSE1 := "3F "
		EndIf
		
		dbSelectArea("SE1")
		dbSetOrder(2)
		If dbSeek(xFilial("SE1")+TRBSD2->(D2_CLIENTE+D2_LOJA+_cPrefSE1+D2_DOC),.f.)
			
			While Eof() == .f. .And. SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == TRBSD2->(D2_CLIENTE+D2_LOJA+_cPrefSE1+D2_DOC)
				
				AADD(_aVencto,{SE1->E1_VENCTO,SE1->E1_VALOR})
				
				dbSelectArea("SE1")
				dbSkip()
			EndDo
		EndIf
		
		For n:= 1 To Len(_aVencto)
			
			oReport:PrintText( Dtoc(_aVencto[n,1]) +Space(5)+Transform(_aVencto[n,2],PesqPict("SE1","E1_VALOR")) )
					
		Next
		
		_aVencto := {}
        
		dbSelectArea("TRBSD2")
 		
 		oReport:PrintText(" ")    
 		oReport:ThinLine()
   				
		oSection1:Printline()
		
		oSection2:init()
		
		While TRBSD2->D2_DOC == cDoc
			oReport:IncMeter()		
		
			IncProc("Imprimindo itens "+alltrim(TRBSD2->D2_COD))
			oSection2:Cell("Código"):SetValue(TRBSD2->D2_COD)
			oSection2:Cell("Descrição"):SetValue(TRBSD2->B1_DESC)
			oSection2:Printline()
	
 			TRBSD2->(dbSkip())
 		EndDo		
 		oSection2:Finish()
 		oReport:ThinLine()

		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "Romaneio de ?"	  , "", "", "mv_ch1", "C", tamSx3("D2_DOC")[1], 0, 0, "G", "", "SD2", "", "", "mv_par01")
	putSx1(cPerg, "02", "Romaneio ate?"	  , "", "", "mv_ch2", "C", tamSx3("D2_DOC")[1], 0, 0, "G", "", "SD2", "", "", "mv_par02")
	putSx1(cPerg, "03", "Da Serie ?"	  , "", "", "mv_ch3", "C", tamSx3("D2_SERIE")[1], 0, 0, "G", "", "", "", "", "mv_par03")
return