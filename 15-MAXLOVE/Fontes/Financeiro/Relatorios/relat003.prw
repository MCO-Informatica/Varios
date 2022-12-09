#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} relat003
Relatorio - Compensacao entre Carteiras
@type function
@version  1.0
@author fabio.favaretto
@since 8/2/2022
/*/

User Function relat003()
	Local oReport := nil
	Local cPerg:= Padr("RELAT003",10)
	Public cNomeCF     

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
	
	oReport := TReport():New(cNome,"Compensacao entre Carteiras",cNome,{|oReport| ReportPrint(oReport)},"Relatório Compensacao")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oSection1:= TRSection():New(oReport, "Compensacao entre Carteiras", {"SE5"}, , .F., .T.)
// 	TRCell():New(oSection1,"E5_IDENTEE"		,"TRB","Compensação"  		,"@!",9)
//	TRCell():New(oSection1,"E5_DATA"		,"TRB","Data"  		,"@!",9)
    

	oSection2:= TRSection():New(oReport, "Itens", {"SE5"}, NIL, .F., .T.)     
	
 //	TRCell():New( oSection2, 'Data',	   	'TRB', 'Data',		        PesqPict( 'SE5', 'E5_DATA' ),		8,,	 						    { || TRB->E5_DATA } )
	TRCell():New( oSection2, 'PRF',	    	'TRB', 'PRF',		        PesqPict( 'SE5', 'E5_PREFIXO' ),	3,,	 						    { || TRB->E5_PREFIXO } )
	TRCell():New( oSection2, 'NUMERO',	   	'TRB', 'NUMERO',	        PesqPict( 'SE5', 'E5_NUMERO' ),		9,,						 	    { || TRB->E5_NUMERO } )
	TRCell():New( oSection2, 'PC',	   		'TRB', 'PC',		        PesqPict( 'SE5', 'E5_PARCELA' ),	1,,	 						    { || TRB->E5_PARCELA } )
	TRCell():New( oSection2, 'TIPO',		'TRB', 'TIPO',		        PesqPict( 'SE5', 'E5_TIPO' ),		1,,	 						    { || TRB->E5_TIPO } )
	TRCell():New( oSection2, 'CLIFOR',		'TRB', 'CLIENTE/FORNECEDOR',PesqPict( 'SE5', 'E5_CLIFOR' ),		30,, 						    { || cNomeCF } )
	TRCell():New( oSection2, 'P/R',	   		'TRB', 'P/R',		        PesqPict( 'SE5', 'E5_RECPAG' ),		1,,	 						    { || TRB->E5_RECPAG } )
	TRCell():New( oSection2, 'PAGAR',		'TRB', 'TIT A PAGAR',		PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E2_VALOR } )
	TRCell():New( oSection2, 'RECEBER',		'TRB', 'VL TIT A RECEBER',	PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E1_VALOR } )
	TRCell():New( oSection2, 'COMPENSADO',	'TRB', 'COMPENSADO',		PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || TRB->E5_VALOR } )
	//TRCell():New( oSection2, 'ACOMPENSAR',	'TRB', 'A COMPENSAR',		PesqPict( 'SE5', 'E5_VALOR' ),		12,, 							{ || Iif(TRB->E5_RECPAG='R', TRB->E1_SALDO, TRB->E2_SALDO) } )
	TRCell():New( oSection2, 'ACOMPENSAR',	'TRB', 'A COMPENSAR',		PesqPict( 'SE5', 'E5_VALOR' ),		12,, 						    { || Iif(TRB->E5_RECPAG='R', IIF(TRB->E5_XSLDSE1>0 .OR. TRB->E5_XSLDSE1>=TRB->E1_SALDO,TRB->E5_XSLDSE1,TRB->E1_VALOR-TRB->E5_VALOR), IIF(TRB->E5_XSLDSE2>0 .OR. TRB->E5_XSLDSE2>=TRB->E2_SALDO,TRB->E5_XSLDSE2,TRB->E2_VALOR - TRB->E5_VALOR)) } )//{ || Iif(TRB->E5_RECPAG='R', TRB->E1_SALDO, TRB->E2_SALDO) } )

	//oSection2:Cell('ACOMPENSAR'):Hide()

    oSection2:SetTotalInLine(.f.)    
    	
	TRFunction():New(oSection2:Cell("PAGAR"),NIL,"SUM",,,,,.T.,.F.)    
	TRFunction():New(oSection2:Cell("RECEBER"),NIL,"SUM",,,,,.T.,.F.)    
	TRFunction():New(oSection2:Cell("COMPENSADO"),NIL,"SUM",,,,{ || Iif(TRB->E5_RECPAG='R', TRB->E5_VALOR, 0) } ,.T.,.F.)    
	//TRFunction():New(oSection2:Cell("SALDO"),NIL,"SUM",,,,,.T.,.F.)    
	TRFunction():New(oSection2:Cell("ACOMPENSAR"),NIL,"SUM",,,,,.T.,.F.)    
	
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

	cQuery := "	SELECT E5_IDENTEE, E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, A1_NOME, E5_RECPAG, E5_VALOR, E2_VALOR, E1_VALOR, E1_SALDO, E2_SALDO, E5_XSLDSE1, E5_XSLDSE2 "
	cQuery += "	FROM "+RETSQLNAME("SE5")+" SE5 "
  	cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E5_CLIFOR AND A1_LOJA=E5_LOJA "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SE2")+" SE2 ON SE2.D_E_L_E_T_='' AND E5_PREFIXO=E2_PREFIXO AND E5_NUMERO=E2_NUM AND E5_PARCELA=E2_PARCELA AND E5_TIPO=E2_TIPO AND E5_CLIFOR=E2_FORNECE AND E5_LOJA=E2_LOJA "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SE1")+" SE1 ON SE1.D_E_L_E_T_='' AND E5_PREFIXO=E1_PREFIXO AND E5_NUMERO=E1_NUM AND E5_PARCELA=E1_PARCELA AND E5_TIPO=E1_TIPO AND E5_CLIFOR=E1_CLIENTE AND E5_LOJA=E1_LOJA"
  	cQuery += "	WHERE SE5.D_E_L_E_T_=' ' "
	cQuery += "	AND E5_SITUACA NOT IN ('C','X') "
	cQuery += " AND E5_MOTBX = 'CEC' " 
    cQuery += " AND E5_TIPODOC = 'BA' "
 	cQuery += " AND E5_IDENTEE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND E5_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"
	cQuery += "	ORDER BY E5_IDENTEE, E5_DATA, E5_RECPAG, E5_CLIFOR "
  		
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
					
		cDoc 	:= TRB->E5_IDENTEE
		IncProc("Imprimindo "+alltrim(TRB->E5_IDENTEE))
		
   //	oSection1:Cell("E5_IDENTEE"):SetValue(TRB->E5_IDENTEE)  
		oReport:PrintText("Num.Compensação: "+TRB->E5_IDENTEE + "      Data: "+Substr(TRB->E5_DATA,7,2)+"/"+Substr(TRB->E5_DATA,5,2)+"/"+Substr(TRB->E5_DATA,3,2)) 
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
	
		While TRB->E5_IDENTEE == cDoc
			oReport:IncMeter()		

			If TRB->E5_RECPAG == "R"
				SA1->(MsSeek(xFilial("SA1")+ TRB->E5_CLIFOR+TRB->E5_LOJA))
				cNomeCF := SA1->A1_NREDUZ  
				
			Else
				SA2->(MsSeek(xFilial("SA2")+TRB->E5_CLIFOR+ TRB->E5_LOJA))
				cNomeCF := SA2->A2_NREDUZ
			Endif	
 		
			IncProc("Imprimindo "+alltrim(TRB->E5_IDENTEE))
			oSection2:Cell("PRF"):SetValue(TRB->E5_PREFIXO)
			oSection2:Printline()
	

 			TRB->(dbSkip())
 		EndDo		
 		oSection2:Finish()
 		oReport:ThinLine()

		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "Da Compensação  ?"	  , "", "", "mv_ch1", "C", 6, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Até Compensação ?"	  , "", "", "mv_ch2", "C", 6, 0, 0, "G", "", "", "", "", "mv_par02")
	putSx1(cPerg, "03", "Data de  ?"	  , "", "", "mv_ch3", "D", 8, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Data ate ?"	  , "", "", "mv_ch4", "D", 8, 0, 0, "G", "", "", "", "", "mv_par04")
return
