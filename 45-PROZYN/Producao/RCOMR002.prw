#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FWPrintSetup.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMR002  ºAutor  ³ Derik Santos      º Data ³  05/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para impressão dos rotulos para as MP                º±±
±±ºDesc.     ³ Essa etiqueta é específica para Prozyn.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCOMR002()
	
	Private _aSavArea	:= GetArea()
	Private _cRotina	:= "RCOMR002"
	Private _cAlias		:= ""
	Private _cAlias2	:= ""	
	Private oFont1		:= TFont():New('Arial',,028,,.F.,,,,,.F. ) //Título até 11 caracteres
	Private oFont2		:= TFont():New('Arial',,016,,.T.,,,,,.F. ) //Sub-título
	Private oFont3		:= TFont():New('Arial',,024,,.T.,,,,,.F. ) //Título acima de 14 caracteres
	Private oFont4		:= TFont():New('Arial',,010,,.F.,,,,,.F. ) //Sub-título
	Private oFont5		:= TFont():New('Arial',,008,,.T.,,,,,.F. ) //Descritivo (Negrito)
	Private oFont6		:= TFont():New('Arial',,008,,.F.,,,,,.F. ) //Descritivo (Negrito)
	Private _lPreview	:= .T.
	Private cPerg		:= "RCOMR002"

	
	//Chama a rotina para criação de parametros do relatório
	ValidPerg()

	//Abre tela de parametros para definição do usuário
	If Pergunte(cPerg,.T.)	
		Processa({|lEnd| ImpEtiqueta()},_cRotina,"Aguarde... Processando a impressão da(s) etiqueta(s)...",.T.)
	EndIf
	
	//Restauro a área de trabalho original
	RestArea(_aSavArea)

Return()

Static Function ImpEtiqueta()

	Local n := 0

	If mv_par09 = 1
		_cEstoque = "S"
	Else
		_cEstoque = "N"
	EndIf
	
	Private oPrinter
	_cAlias	:= GetNextAlias()
    //Seleciono as etiquetas a serem impressas
	_cQuery	:= " SELECT * "
	_cQuery	+= " FROM " + RetSqlName("SD1") + " SD1 "
	_cQuery	+= " INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery	+= " ON SD1.D_E_L_E_T_='' "
	_cQuery	+= " AND SB1.D_E_L_E_T_='' "
	_cQuery	+= " AND SD1.D1_FILIAL='"+xFilial("SB1")+"' "
	If mv_par08 = 1
		_cQuery	+= " AND SD1.D1_TP='MP' "
	EndIf
	_cQuery	+= " AND SB1.D_E_L_E_T_='' "
	_cQuery	+= " AND SB1.B1_FILIAL='"+xFilial("SB1")+"' "
	_cQuery	+= " AND SD1.D1_COD=SB1.B1_COD "
	_cQuery	+= " INNER JOIN " + RetSqlName("SB8") + " SB8 "
	_cQuery	+= " ON SB8.D_E_L_E_T_='' "
	_cQuery	+= " AND SB8.B8_FILIAL='"+xFilial("SB1")+"' "
	_cQuery	+= " AND SB8.B8_PRODUTO=SD1.D1_COD "
	_cQuery	+= " AND SB8.B8_LOTECTL=SD1.D1_LOTECTL "
	_cQuery	+= " AND SB8.B8_LOCAL=SD1.D1_LOCAL "
	_cQuery	+= " AND SD1.D1_DOC='"+mv_par01+"' "
	_cQuery	+= " AND SD1.D1_SERIE= '"+mv_par02+"' "
	_cQuery	+= " AND SD1.D1_FORNECE='"+mv_par03+"' "
	_cQuery	+= " AND SD1.D1_LOJA = '"+mv_par04+"'
	_cQuery	+= " INNER JOIN SF4010 SF4 "
	_cQuery	+= " ON SF4.F4_CODIGO = SD1.D1_TES "
	_cQuery	+= " AND SF4.F4_ESTOQUE = '"+_cEstoque+"' "
	_cQuery	+= " AND SF4.D_E_L_E_T_='' "


	_cQuery	:= ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
	dbSelectArea(_cAlias)

	If (_cAlias)->(EOF())
		MsgAlert("Não há etiquetas a serem impressas!",_cRotina+"_001")
		Return()
	Else
		
			If oPrinter == Nil
				lPreview := .T.
				oPrinter := FWMSPrinter():New('DataMax',,.F.,,.T.,,,)
		     	//oPrinter:Setup()  //Abre tela para definição da impressora
			   	oPrinter:SetPortrait()
				oPrinter:SetPaperSize(9)
			    oPrinter:cPrinter := "ZDesigner GC420t (EPL)"
			EndIf
While !EOF()
			If mv_par06 = 0
				_nQtde   := (_cAlias)->D1_QUANT
				_nQtProd := (_cAlias)->B1_QE
				_nQtdeI  := Ceiling(_nQtde / _nQtProd)
			Else	
				_nQtdeI := mv_par06
			EndIf
			_cCodPro:= RTRIM((_cAlias)->B1_COD)
			
	  		For n := 1 To _nQtdeI 
			oPrinter:StartPage() 
				
			Private cCodFra		:= ""
			Private cFrases		:= ""
			Private _cCompos 	:= "" 

			 IF mv_par05 = 2 .AND. !Empty((_cAlias)->B1_DESCIN)	
			 	oPrinter:SayAlign(0002, 0000, RTRIM((_cAlias)->B1_DESCIN)				 		  ,oFont3, 0230,0060,,2,0)
			 ElseIf mv_par05 = 3 .AND. !Empty((_cAlias)->B1_DESCES)
			 	oPrinter:SayAlign(0002, 0000, RTRIM((_cAlias)->B1_DESCES)				 		  ,oFont3, 0230,0060,,2,0)
			 ElseIf mv_par05 = 4 .AND. !Empty((_cAlias)->B1_DESCOUT)
			 	oPrinter:SayAlign(0002, 0000, RTRIM((_cAlias)->B1_DESCOUT)				 		  ,oFont3, 0230,0060,,2,0)
			 Else
			 	oPrinter:SayAlign(0000, 0000, RTRIM((_cAlias)->B1_DESC)	 				 		  ,oFont3, 0220,00030,,2,1)
			 EndIf
			  
			    oPrinter:Line    (0045, 0000, 0045, 0800,0,"-4")
			    
			    IF MV_PAR05 = 2
				    oPrinter:SayAlign(0050, 0010,"LOTE:"        								  ,oFont4,0330,0060,,0,1)  
			    ELSEIF MV_PAR05 = 3
				    oPrinter:SayAlign(0050, 0010,"LOTE:"        								  ,oFont4,0330,0060,,0,1)  
			    ELSEIF MV_PAR05 = 4
				    oPrinter:SayAlign(0050, 0010,"LOTE:"        								  ,oFont4,0330,0060,,0,1)  
			    ELSE
				    oPrinter:SayAlign(0050, 0005,"LOTE:"        								  ,oFont4,0330,0060,,0,1)  
			    ENDIF
			    
			    oPrinter:SayAlign(0060, 0005,(_cAlias)->D1_LOTECTL      					  ,oFont2,0330,0060,,0,1)		    
			    
			    IF MV_PAR05 = 2
				    oPrinter:SayAlign(0050, 0110,"NET WEIGHT:"    								  ,oFont4,0330,0060,,0,1)
			    	oPrinter:SayAlign(0060, 0110,TRANSFORM((_cAlias)->B1_PESO,"@E 9.999,99")+"KG" ,oFont2,0330,0060,,0,1)		    
			    ELSEIF MV_PAR05 = 3
				    oPrinter:SayAlign(0050, 0110,"PESO NETO:"    								  ,oFont4,0330,0060,,0,1)
				    oPrinter:SayAlign(0060, 0110,TRANSFORM((_cAlias)->B1_PESO,"@E 9,999.99")+"KG" ,oFont2,0330,0060,,0,1)		    
			    ELSEIF MV_PAR05 = 4
				    oPrinter:SayAlign(0050, 0110,"PESO LIQ:"    								  ,oFont4,0330,0060,,0,1)
				    oPrinter:SayAlign(0060, 0110,TRANSFORM((_cAlias)->B1_PESO,"@E 9,999.99")+"KG" ,oFont2,0330,0060,,0,1)		    
			    ELSE
				    oPrinter:SayAlign(0050, 0110,"PESO LIQ:"    								  ,oFont4,0330,0060,,0,1)
	   			    oPrinter:SayAlign(0060, 0110,TRANSFORM((_cAlias)->B1_PESO,"@E 9,999.99")+"KG" ,oFont2,0330,0060,,0,1)		    	
			    ENDIF
			    			    
			    IF MV_PAR05 = 2
				    oPrinter:SayAlign(0080, 0005,"MANUFACTURE:"  								  ,oFont4,0330,0060,,0,1)
			    ELSEIF MV_PAR05 = 3
				    oPrinter:SayAlign(0080, 0005,"MANUFACTURA:"  								  ,oFont4,0330,0060,,0,1)
			    ELSEIF MV_PAR05 = 4
				    oPrinter:SayAlign(0080, 0005,"FABRICAÇÃO:"  								  ,oFont4,0330,0060,,0,1)
			    ELSE
				    oPrinter:SayAlign(0090, 0005,"FABRICAÇÃO:"  								  ,oFont4,0330,0060,,0,1)
			    ENDIF
			    oPrinter:SayAlign(0100, 0005,DTOC(STOD((_cAlias)->D1_DATORI))      			  ,oFont2,0330,0060,,0,1)		    
			    
			    oPrinter:SayAlign(0080, 0110,"VALIDADE:"    								  ,oFont4,0330,0060,,0,1) 
			    oPrinter:SayAlign(0090, 0110,DTOC(STOD((_cAlias)->B8_DTVALID))   			  ,oFont2,0330,0060,,0,1)		    
		    
   			    _cCod := RTRIM((_cAlias)->B1_COD) 		    		    		    		    		    		     		     		    
			    oPrinter:MSBAR("CODE128",02,12,_cCod,oPrinter,.T.,,.T.,0.021,0.5,.F.,NIL,NIL,.F.) 

  			    _cLote := RTRIM((_cAlias)->D1_LOTECTL) 		    		    		    		    		    		     		     		    
			    oPrinter:MSBAR("CODE128",10,1,_cLote,oPrinter,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)
	    
				oPrinter:EndPage()
			Next                   
			
			dbSelectArea(_cAlias)
			(_cAlias)->(dbSkip())
//DbSkip()
EndDo
	EndIf
 	
	If lPreview
		oPrinter:Preview()
	EndIf
	
	FreeObj(oPrinter)
	oPrinter := Nil

dbSelectArea(_cAlias)
dbCloseArea()
	
Return()   

Static Function ValidPerg()

Local i := 0
Local j := 0

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

AADD(aRegs,{cPerg,"01","Nota Fiscal           ?","","","mv_ch1","C",09,0,3,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF102","",""})
AADD(aRegs,{cPerg,"02","Serie                 ?","","","mv_ch2","C",03,0,3,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Fornecedor            ?","","","mv_ch3","C",06,0,3,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
AADD(aRegs,{cPerg,"04","Loja                  ?","","","mv_ch4","C",06,0,3,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Idioma                ?","","","mv_ch5","C",10,0,3,"C","","mv_par05","","","","","","Inglês","","","","","Espanhol","","","","","Outros","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Quantidade Etiqueta   ?","","","mv_ch6","N",03,0,3,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","#EMB                  ?","","","mv_ch7","C",10,0,3,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Somente MP            ?","","","mv_ch8","C",10,0,3,"C","","mv_par08","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Somente Mov. Estoque  ?","","","mv_ch9","C",10,0,3,"C","","mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount() 
		
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif                                                                          
Next

dbSelectArea(_sAlias)

Return()