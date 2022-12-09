#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FWPrintSetup.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPCPR002  ºAutor  ³ Derik Santos      º Data ³  05/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±        
±±ºDesc.     ³ Rotina para impressão dos rotulos dos produtos              º±±
±±ºDesc.     ³ Essa etiqueta é específica para Prozyn.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPR002(lImpWiz, aCodEti)

	Private _aSavArea	:= GetArea()
	Private _cRotina	:= "RPCPR002"
	Private _cAlias		:= ""
	Private _cAlias2	:= ""	
	Private oFont1		:= TFont():New('Arial',,028,,.F.,,,,,.F. ) //Título até 11 caracteres
	Private oFont2		:= TFont():New('Arial',,016,,.T.,,,,,.F. ) //Sub-título
	Private oFont3		:= TFont():New('Arial',,042,,.T.,,,,,.F. ) //Título acima de 14 caracteres
	Private oFont4		:= TFont():New('Arial',,010,,.F.,,,,,.F. ) //Sub-título
	Private oFont5		:= TFont():New('Arial',,008,,.T.,,,,,.F. ) //Descritivo (Negrito)
	Private oFont6		:= TFont():New('Arial',,008,,.F.,,,,,.F. ) //Descritivo (Negrito)   
	Private oFont7		:= TFont():New('Arial',,022,,.T.,,,,,.F. ) //Descritivo (Negrito)
	Private _lPreview	:= .T.                         
	Private cPerg		:= "RPCPR002"

	Default lImpWiz		:= .F. 
	Default aCodEti		:= {}

	//Chama a rotina para criação de parametros do relatório
	ValidPerg()

	If lImpWiz .And. Len(aCodEti) > 0 
		If IsNewEtiq()

			//Executa o nova etiqueta
			U_PZCVR001()
		Else
			Processa({|lEnd| ImpEtiqueta(lImpWiz, aCodEti)},_cRotina,"Aguarde... Processando a impressão da(s) etiqueta(s)...",.T.)
		EndIf	
	Else
		//Abre tela de parametros para definição do usuário
		If Pergunte(cPerg,.T.)	
			If IsNewEtiq()

				//Executa o nova etiqueta
				U_PZCVR001(lImpWiz, aCodEti)
			Else
				Processa({|lEnd| ImpEtiqueta(lImpWiz, aCodEti)},_cRotina,"Aguarde... Processando a impressão da(s) etiqueta(s)...",.T.)
			EndIf
		EndIf

	EndIf

	//Restauro a área de trabalho original
	RestArea(_aSavArea)

Return()

Static Function ImpEtiqueta(lImpWiz, aCodEti)

	Local nTotLin		:= 0
	Private oPrinter

	Default lImpWiz		:= .F. 
	Default aCodEti		:= {}	

	_cAlias	:= GetNextAlias()
	//Seleciono as etiquetas a serem impressas
	_cQuery	:= "SELECT * " 
	_cQuery	+= "FROM " + RetSqlName("SC2") + " SC2 "
	_cQuery	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery	+= "ON SC2.D_E_L_E_T_='' "
	_cQuery	+= "AND SC2.C2_FILIAL='01' "
	_cQuery	+= "AND SB1.D_E_L_E_T_='' "
	_cQuery	+= "AND SB1.B1_FILIAL='"+xFilial("SB1")+"' "
	_cQuery	+= "AND SC2.C2_PRODUTO=SB1.B1_COD "
	_cQuery	+= "WHERE SC2.C2_NUM+C2_ITEM+C2_SEQUEN='"+mv_par01+"' "
	_cQuery	+= "AND SC2.C2_LOTECTL='"+mv_par02+"' " 

	_cQuery	:= ChangeQuery(_cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
	dbSelectArea(_cAlias)

	If (_cAlias)->(EOF())
		MsgAlert("Não há etiquetas a serem impressas!",_cRotina+"_001")
		Return()
	Else
		If oPrinter == Nil
			lPreview := .T.
			oPrinter := FWMSPrinter():New('Rotulo_Prozyn',,.F.,,.T.,,,)
			oPrinter:Setup()  //Abre tela para definição da impressora
			oPrinter:SetLandScape()
			oPrinter:SetPaperSize(9)
		EndIf

		If mv_par04 = 0
			_nQntde := (_cAlias)->C2_QUANT
			_nVolum := (_cAlias)->B1_QE
			_nQtdeI := Ceiling(_nQntde / _nVolum)
		Else
			_nQtdeI := mv_par04
		EndIf
		_cCodPro:= RTRIM((_cAlias)->B1_COD)

		_cDeeti := mv_par07
		_cAteeti:= RTRIM(mv_par08)

		For n := 1 To _nQtdeI 
			oPrinter:StartPage() 

			Private cCodFra		:= ""
			Private cFrases		:= ""
			Private _cCompos 	:= ""

			IF mv_par03 = 2 .AND. !Empty((_cAlias)->B1_DESCIN)	
				oPrinter:SayAlign(0002, 0000, RTRIM((_cAlias)->B1_DESCIN)				 		  ,oFont3, 800,0060,,2,0)
			ElseIf mv_par03 = 3 .AND. !Empty((_cAlias)->B1_DESCES)
				oPrinter:SayAlign(0002, 0000, RTRIM((_cAlias)->B1_DESCES)				 		  ,oFont3, 800,0060,,2,0)
			ElseIf mv_par03 = 4 .AND. !Empty((_cAlias)->B1_DESCOUT)
				oPrinter:SayAlign(0002, 0000, RTRIM((_cAlias)->B1_DESCOUT)				 		  ,oFont3, 800,0060,,2,0)
			Else
				oPrinter:SayAlign(0002, 0000, RTRIM((_cAlias)->B1_DESC)	 				 		  ,oFont3, 800,0060,,2,0)
			EndIf

			oPrinter:Line    (0045, 0000, 0045, 0800,0,"-4")

			IF MV_PAR03 = 2
				oPrinter:SayAlign(0050, 0020,"BATCH NUMBER:"        								  ,oFont4,0330,0060,,0,1)  
			ELSEIF MV_PAR03 = 3
				oPrinter:SayAlign(0050, 0020,"LOTE:"        								  ,oFont4,0330,0060,,0,1)  
			ELSEIF MV_PAR03 = 4
				oPrinter:SayAlign(0050, 0020,"LOTE:"        								  ,oFont4,0330,0060,,0,1)  
			ELSE
				oPrinter:SayAlign(0050, 0020,"LOTE:"        								  ,oFont4,0330,0060,,0,1)  
			ENDIF

			oPrinter:SayAlign(0060, 0020,(_cAlias)->C2_LOTECTL      					 	  ,oFont7,0330,0060,,0,1)		    

			_cPeso := (POSICIONE("SB1", 1, xFilial("SB1") + (_cAlias)->B1_COD, "B1_PESOEMB"))
			// Armazenar a Unidade de medida do Produto para posterior validação por CR - Valdimari Martins - 20/02/2017

			IF MV_PAR09 = 1 
				_cUnid := " "+(POSICIONE("SB1", 1, xFilial("SB1") + (_cAlias)->B1_COD, "B1_UM"))
			ELSE
				_cUnid := " "+(POSICIONE("SB1", 1, xFilial("SB1") + (_cAlias)->B1_COD, "B1_SEGUM"))
			ENDIF



			IF MV_PAR03 = 2
				oPrinter:SayAlign(0050, 0125,"PROD.CODE:"        								  ,oFont4,0330,0070,,0,1)  
			ELSEIF MV_PAR03 = 3
				oPrinter:SayAlign(0050, 0125,"COD.PROD:"        								  ,oFont4,0330,0070,,0,1)  
			ELSEIF MV_PAR03 = 4
				oPrinter:SayAlign(0050, 0125,"COD.PROD:"        								  ,oFont4,0330,0070,,0,1)  
			ELSE
				oPrinter:SayAlign(0050, 0125,"COD.PROD:"        								  ,oFont4,0330,0070,,0,1)  
			ENDIF


			oPrinter:SayAlign(0060, 0125,(_cAlias)->C2_PRODUTO      					 	  ,oFont7,0330,0070,,0,1) 

			IF MV_PAR03 = 2                                                             
				// Validação da Unidade de Medida por CR - Valdimari Martins - 20/02/2017
				If Alltrim(_cUnid) == "KG"
					oPrinter:SayAlign(0050, 0225,"NET WEIGHT:"    								  ,oFont4,0330,0060,,0,1)
				Else	
					oPrinter:SayAlign(0050, 0225,"CONTENT:"	    								  ,oFont4,0330,0060,,0,1)  				    	
				Endif
				IF mv_par06 = 0
					oPrinter:SayAlign(0060, 0205,StrTran(TRANSFORM((_cAlias)->B1_PESO,"@E 9,999.999"),",",".")+_cUnid ,oFont7,0330,0060,,0,1)		    
				ELSE 
					oPrinter:SayAlign(0060, 0205,StrTran(TRANSFORM(mv_par06,"@E 9,999.999"),",",".")+_cUnid ,oFont7,0330,0060,,0,1)	    
				ENDIF
			ELSEIF MV_PAR03 = 3
				If Alltrim(_cUnid) == "KG"
					oPrinter:SayAlign(0050, 0225,"PESO NETO:"    								  ,oFont4,0330,0060,,0,1)   					    
				Else	
					oPrinter:SayAlign(0050, 0225,"CONTENIDO:"    								  ,oFont4,0330,0060,,0,1)				    	
				Endif
				IF mv_par06 = 0
					oPrinter:SayAlign(0060, 0205,TRANSFORM((_cAlias)->B1_PESO,"@E 9,999.999")+_cUnid ,oFont7,0330,0060,,0,1)		    			    		
				ELSE 
					oPrinter:SayAlign(0060, 0205,TRANSFORM(mv_par06,"@E 9,999.999")+_cUnid ,oFont7,0330,0060,,0,1)		    
				ENDIF		    
			ELSEIF MV_PAR03 = 4                                                                                      
				If Alltrim(_cUnid) == "KG"
					oPrinter:SayAlign(0050, 0225,"PESO LIQ:"    								  ,oFont4,0330,0060,,0,1)					    
				Else	
					oPrinter:SayAlign(0050, 0225,"CONTEÚDO:"    								  ,oFont4,0330,0060,,0,1)					    
				Endif
				IF mv_par06 = 0
					oPrinter:SayAlign(0060, 0205,TRANSFORM((_cAlias)->B1_PESO,"@E 9,999.999")+_cUnid ,oFont7,0330,0060,,0,1)			    		
				ELSE 
					oPrinter:SayAlign(0060, 0205,TRANSFORM(mv_par06,"@E 9,999.999")+_cUnid ,oFont7,0330,0060,,0,1)		    
				ENDIF
			ELSE
				If Alltrim(_cUnid) == "KG"
					oPrinter:SayAlign(0050, 0225,"PESO LIQ:"    								  ,oFont4,0330,0060,,0,1)					  
				Else	
					oPrinter:SayAlign(0050, 0225,"CONTEÚDO:"    								  ,oFont4,0330,0060,,0,1)
				Endif
				IF mv_par06 = 0
					oPrinter:SayAlign(0060, 0205,TRANSFORM(_cPeso,"@E 9,999.999")+_cUnid ,oFont7,0330,0060,,0,1)		    
				ELSE 
					oPrinter:SayAlign(0060, 0205,TRANSFORM(mv_par06,"@E 99,999.999")+_cUnid ,oFont7,0330,0060,,0,1)		    			    		
				ENDIF
			ENDIF

			IF MV_PAR03 = 2
				oPrinter:SayAlign(0050, 0335,"MANUFACTURE DATE:"  								  ,oFont4,0330,0060,,0,1)				    
			ELSEIF MV_PAR03 = 3           
				oPrinter:SayAlign(0050, 0320,"FECHA DE ELABORACIÓN:" 						  ,oFont4,0330,0060,,0,1)				    
			ELSEIF MV_PAR03 = 4
				oPrinter:SayAlign(0050, 0335,"FABRICAÇÃO:"  								  ,oFont4,0330,0060,,0,1)				    
			ELSE
				oPrinter:SayAlign(0050, 0335,"FABRICAÇÃO:"  								  ,oFont4,0330,0060,,0,1)				   
			ENDIF

			oPrinter:SayAlign(0060, 0335,DTOC(STOD((_cAlias)->C2_EMISSAO))   			  ,oFont7,0330,0060,,0,1)		    			    


			IF MV_PAR03 = 2
				oPrinter:SayAlign(0050, 0430,"EXPIRATION DATE:"    								  ,oFont4,0330,0060,,0,1)				    
			ELSEIF MV_PAR03 = 3           
				oPrinter:SayAlign(0050, 0430,"VALIDEZ:"    								  ,oFont4,0330,0060,,0,1)				    
			ELSEIF MV_PAR03 = 4
				oPrinter:SayAlign(0050, 0430,"VALIDADE:"    								  ,oFont4,0330,0060,,0,1)				    
			ELSE
				oPrinter:SayAlign(0050, 0430,"VALIDADE:"    								  ,oFont4,0330,0060,,0,1)				   
			ENDIF

			oPrinter:SayAlign(0060, 0430,DTOC(STOD((_cAlias)->C2_DTVALID))   			  ,oFont7,0330,0060,,0,1)		    			    

			oPrinter:SayAlign(0050, 0525,"#EMB"      									  ,oFont4,0330,0060,,0,1) 		      			    

			If lImpWiz
				
				//Recupera o total de linhas
				If nTotLin == 0
					nTotLin := GetQtdEtiq(MV_PAR01)
				EndIf
				
				oPrinter:SayAlign(0060, 0525,AllTrim(GetPosEtiq(aCodEti[n])) + "/" + AllTrim(Str(nTotLin))    ,oFont7,0330,0040,,0,1)
				
			Else
				If !Empty(mv_par07) .AND. !Empty(mv_par08)
					If _cDeeti == 1
						oPrinter:SayAlign(0060, 0525,Transform(_cDeeti,"@E 999") + "/" + AllTrim(_cAteeti)    ,oFont7,0330,0060,,0,1)
						_cDeeti += 1
					Else
						oPrinter:SayAlign(0060, 0525,Transform(_cDeeti,"@E 999") + "/" + AllTrim(_cAteeti)    ,oFont7,0330,0060,,0,1)			    		
						_cDeeti += 1
					EndIf
				Else
					oPrinter:SayAlign(0060, 0525,AllTrim(Str(n)) + "/" + AllTrim(Str(_nQtdeI))    ,oFont7,0330,0040,,0,1)			    	
				EndIf
			EndIf
			
			If (_cAlias)->B1_TRANSGE == "1"

				If mv_par03 = 2
					oPrinter:SayBitmap(0046,0600, "\00-pictogramas\TRANSGÊNICOING.bmp", 100, 100)
				ElseIf mv_par03 = 3
					oPrinter:SayBitmap(0046,0600, "\00-pictogramas\TRANSGÊNICOESP.bmp", 100, 100)
				ElseIf mv_par03 = 4
					oPrinter:SayBitmap(0046,0600, "\00-pictogramas\TRANSGÊNICO.bmp", 100, 100)
				Else
					oPrinter:SayBitmap(0046,0600, "\00-pictogramas\TRANSGÊNICO.bmp", 100, 100)
				EndIf    
			ENDIF

			oPrinter:SayBitmap(0046,0710,RTRIM((_cAlias)->B1_PICTOG), 80, 80)		    

			_nLin:=90
			_cDescPO := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASPO") 
			_cDEscIN := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASIN") 
			_cDescES := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASES") 
			_cDEscOU := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASOU")

			If mv_par03 = 2
				oPrinter:Say(_nLin, 0020,"DESCRIPTION: "         ,oFont5)
				oPrinter:Say(_nLin, 0080,_cDescIN ,oFont6)			    

			ElseIf mv_par03 = 3
				oPrinter:Say(_nLin, 0020,"DESCRIPCIÓN: "         ,oFont5)
				oPrinter:Say(_nLin, 0080,_cDescES ,oFont6)			    

			ElseIf mv_par03 = 4
				oPrinter:Say(_nLin, 0020,"DESCRIÇÃO: "         ,oFont5)
				oPrinter:Say(_nLin, 0080,_cDescOU ,oFont6)			    

			Else
				oPrinter:Say(_nLin, 0020,"DESCRIÇÃO: "         ,oFont5)
				oPrinter:Say(_nLin, 0080,_cDescPO ,oFont6)
			EndIf    

			_nLin+=15			   
			_cCompos := POSICIONE("SZO", 1, xFilial("SZO") + (_cAlias)->B1_CODCOM, "ZO_DESC")

			If mv_par03 = 2
				oPrinter:Say(_nLin, 0020,"COMPOSITION: "        , oFont5)
			ElseIf mv_par03 = 3
				oPrinter:Say(_nLin, 0020,"COMPOSICIÓN: "        , oFont5) 
			ElseIf mv_par03 = 4
				oPrinter:Say(_nLin, 0020,"COMPOSIÇÃO: "        , oFont5)
			Else
				oPrinter:Say(_nLin, 0020,"COMPOSIÇÃO: "        , oFont5)
			EndIf    

			For nXi := 1 To MLCount(_cCompos,120)
				oPrinter:Say(_nLin,0080,MemoLine(_cCompos,120,nXi),oFont6)
				_nLin += 10
			Next nXi
			_nLin += 5                                  

			// - Inicio mudança solicitada pela qualidade em 151217			   

			IF !EMPTY((_cAlias)->B1_HALAL) 

				If mv_par03 = 2
					oPrinter:Say(_nLin, 0020,"CERTIFIED HALAL: "      , oFont5)
				ElseIf mv_par03 = 3
					oPrinter:Say(_nLin, 0020,"CERTIFICADO HALAL: "      , oFont5)
				ElseIf mv_par03 = 4
					oPrinter:Say(_nLin, 0020,"CERTIFICADO HALAL: "      , oFont5)
				Else
					oPrinter:Say(_nLin, 0020,"CERTIFICADO HALAL: "      , oFont5)
				EndIf    

				oPrinter:Say(_nLin, 0110,(_cAlias)->B1_HALAL        , oFont6)		     		     		    		    

				_cAlergenico := (_cAlias)->B1_ALERGEN
				IF MV_PAR03 = 2
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERIN")     , oFont5)			    	
				ELSEIF MV_PAR03 =3
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERES")     , oFont5)			    	
				ELSEIF MV_PAR03 =4
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALEROU")     , oFont5)			    	
				ELSE
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERPO")     , oFont5)			    	
				ENDIF			        

				IF (_cAlias)->B1_GLUTEN = "1" 	
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0490,"CONTAIN GLUTEN"        , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0490,"CONTIENE GLUTEN"        , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0490,"CONTEM GLÚTEN"        , oFont5)
					Else
						oPrinter:Say(_nLin, 0490,"CONTEM GLÚTEN"        , oFont5)
					EndIf    
				ELSE
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0490,"GLUTEN-FREE"    , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0490,"NO CONTIENE GLUTEN"    , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0490,"NÃO CONTEM GLÚTEN"    , oFont5)
					Else
						oPrinter:Say(_nLin, 0490,"NÃO CONTEM GLÚTEN"    , oFont5)
					EndIf	        		

				ENDIF

			ELSE
				_cAlergenico := (_cAlias)->B1_ALERGEN
				IF MV_PAR03 = 2
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERIN")     , oFont5)			    	
				ELSEIF MV_PAR03 =3
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERES")     , oFont5)			    	
				ELSEIF MV_PAR03 =4
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALEROU")     , oFont5)			    	
				ELSE
					oPrinter:Say(_nLin, 0190,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERPO")     , oFont5)
				ENDIF

				IF (_cAlias)->B1_GLUTEN = "1" 	
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0490,"CONTAIN GLUTEN"        , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0490,"CONTIENE GLUTEN"        , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0490,"CONTEM GLÚTEN"        , oFont5)
					Else
						oPrinter:Say(_nLin, 0490,"CONTEM GLÚTEN"        , oFont5)
					EndIf    
				ELSE
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0490,"GLUTEN-FREE"    , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0490,"NO CONTIENE GLUTEN"    , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0490,"NÃO CONTEM GLÚTEN"    , oFont5)
					Else
						oPrinter:Say(_nLin, 0490,"NÃO CONTEM GLÚTEN"    , oFont5)
					EndIf	        		

				ENDIF

			ENDIF	
			_nLin += 25
			// - termino mudança solicitada pela qualidade em 151217

			dbSelectArea(_cAlias)	

			_cManuPO := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUPO") 
			_cManuIN := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUIN") 
			_cManuES := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUES") 
			_cManuOU := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUOU")

			IF mv_par03 = 2 //.AND. !EMPTY(_cManuIN)
				oPrinter:Say(_nLin, 0020,"HANDLING: ", oFont5)			 
				oPrinter:Say(_nLin, 0090,_cManuIN,     oFont6)			
			ELSEIF mv_par03 = 3  //.AND. !EMPTY(_cManuES)
				oPrinter:Say(_nLin, 0020,"FORMA DE USO: ", oFont5)			
				oPrinter:Say(_nLin, 0090,_cManuES  ,   oFont6)			
			ELSEIF mv_par03 = 4  //.AND. !EMPTY(_cManuOU)
				oPrinter:Say(_nLin, 0020,"MANUSEIO: ", oFont5)			
				oPrinter:Say(_nLin, 0090,_cManuOU  ,   oFont6)			
			ELSE
				oPrinter:Say(_nLin, 0020,"MANUSEIO: ", oFont5)			
				oPrinter:Say(_nLin, 0090,_cManuPO  ,   oFont6)			
			ENDIF

			_nLin += 15                                                                                                                                         

			If mv_par03 = 2
				oPrinter:Say(_nLin, 0020,"EMERGENCY: "        , oFont5)
			ElseIf mv_par03 = 3
				oPrinter:Say(_nLin, 0020,"EMERGENCIA: "        , oFont5)
			ElseIf mv_par03 = 4
				oPrinter:Say(_nLin, 0020,"EMERGÊNCIA: "        , oFont5)
			Else
				oPrinter:Say(_nLin, 0020,"EMERGÊNCIA: "        , oFont5)
			EndIf



			If mv_par03 = 2
				cEmer:="Emergency phone number: + 55 11 3732-0000. The chemical product safety data sheet for this product can be obtained by the email prozyn@prozyn.com.br."
			ElseIf mv_par03 = 3
				cEmer:="Teléfono de emergencia: + 55 11 3732-0000. La ficha de información de seguridad de productos químicos de este producto puede obtenerse en el correo electrónico prozyn@prozyn.com.br."				
			ElseIf mv_par03 = 4
				cEmer:="Telefone de emergência (11)3732-0000 - A ficha de informações de segurança de produtos químicos deste produto pode ser obtida no e-mail prozyn@prozyn.com.br"				
			Else
				cEmer:="Telefone de emergência (11)3732-0000 - A ficha de informações de segurança de produtos químicos deste produto pode ser obtida no e-mail prozyn@prozyn.com.br"				
			EndIf				

			For nXi := 1 To MLCount(cEmer,140)
				oPrinter:Say(_nLin,0090,MemoLine(cEmer,140,nXi),oFont6)
				_nLin += 10
			Next nXi

			IF (_cAlias)->B1_XDESTIN = "1"
				If mv_par03 = 2
					oPrinter:Say(_nLin, 0020,"Product not intended for human consumption in the way it is presented.", oFont6)
				ElseIf mv_par03 = 3
					oPrinter:Say(_nLin, 0020,"Producto no destinado al consumo humano en la forma en que se presenta.", oFont6)
				ElseIf mv_par03 = 4
					oPrinter:Say(_nLin, 0020,"Produto não destinado para o consumo humano na forma como se apresenta.", oFont6)
				Else
					oPrinter:Say(_nLin, 0020,"Produto não destinado para o consumo humano na forma como se apresenta.", oFont6)
				EndIf					 			    
			ENDIF

			_nLin += 05 

			DbSelectArea("SZ8")
			DbSetOrder(2) //filial+codproduto
			dbGoTop()
			If Dbseek(xFilial("SZ8") + RTRIM((_cAlias)->B1_COD))
				While !EOF() .and.  SZ8->Z8_FILIAL == XFILIAL("SZ8") .AND. SZ8->Z8_CODPRO == RTRIM((_cAlias)->B1_COD) 

					cCFrase := SZ8->Z8_CODFRA
					IF mv_par03 = 2 .AND. !EMPTY(POSICIONE("SZ7", 1, xFilial("SZ7") + cCFrase, "Z7_DESCIN"))
						cFrases += RTRIM(POSICIONE("SZ7", 1, xFilial("SZ7") + cCFrase, "Z7_DESCIN")) + ". " 			    			
					ElseIF mv_par03 = 3 .AND. !EMPTY(POSICIONE("SZ7", 1, xFilial("SZ7") + cCFrase, "Z7_DESCES"))
						cFrases += RTRIM(POSICIONE("SZ7", 1, xFilial("SZ7") + cCFrase, "Z7_DESCES")) + ". " 			    		
					ElseIF mv_par03 = 3 .AND. !EMPTY(POSICIONE("SZ7", 1, xFilial("SZ7") + cCFrase, "Z7_DESCOUT"))
						cFrases += RTRIM(POSICIONE("SZ7", 1, xFilial("SZ7") + cCFrase, "Z7_DESCOUT")) + ". " 			    		
					Else 
						cFrases += RTRIM(POSICIONE("SZ7", 1, xFilial("SZ7") + cCFrase, "Z7_DESC")) + ". "
					EndIf				    		

					dbSelectArea("SZ8")
					dbSetOrder(2)
					DbSkip()
				Enddo
			EndIf

			For nXi := 1 To MLCount(cFrases,120)
				oPrinter:Say(_nLin,0020,MemoLine(cFrases,120,nXi),oFont6)
				_nLin += 10
			Next nXi	     		     		    

			oPrinter:MSBAR("EAN13",22,3,(_cAlias)->B1_CODBAR,oPrinter,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)

			If lImpWiz .And. Len(aCodEti) > 0
				oPrinter:MSBAR("CODE128",22,22, aCodEti[n], oPrinter,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)
				oPrinter:Say(295, 0285,aCodEti[n], oFont6)   
				
				cPallet := POSICIONE("CB0",1,xFilial("CB0")+aCodEti[n],"CB0->CB0_PALLET")  //imprime cod etiqueta do pallet.
				
				If !Empty(cPallet)  
					oPrinter:Say(295, 0165,"E.P.:"+ cPallet, oFont6) 
				endif
				
			EndIf

			oPrinter:EndPage()
		Next
		dbSelectArea(_cAlias)
		(_cAlias)->(dbSkip())
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

	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aRegs :={}

	AADD(aRegs,{cPerg,"01","Ordem de Produção     ?","","","mv_ch1","C",11,0,3,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Lote                  ?","","","mv_ch2","C",10,0,3,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Idioma                ?","","","mv_ch3","C",10,0,3,"C","","mv_par03","","","","","","Inglês","","","","","Espanhol","","","","","Outros","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Quantidade Etiqueta   ?","","","mv_ch4","N",09,0,3,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","#EMB                  ?","","","mv_ch5","C",10,0,3,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","#Peso                 ?","","","mv_ch6","N",10,0,3,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Rotulo de             ?","","","mv_ch7","N",03,0,3,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Rotulo ate            ?","","","mv_ch8","C",03,0,3,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Pallet                ?","","","mv_ch9","C",03,0,3,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","CB3",""})

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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IsNewEtiq ºAutor  ³ Derik Santos      º Data ³  09/01/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±        
±±ºDesc.     ³ Verifica se é a nova etiqueta					           º±±
±±ºDesc.     ³ 											                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function IsNewEtiq()

	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .F.

	cQuery	:= "SELECT * "+CRLF 
	cQuery	+= "FROM " + RetSqlName("SC2") + " SC2 "+CRLF

	cQuery	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 "+CRLF
	cQuery	+= "ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= "AND SB1.B1_COD = SC2.C2_PRODUTO "+CRLF
	cQuery	+= "AND SB1.D_E_L_E_T_= ' ' "+CRLF

	cQuery	+= "WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF 
	cQuery	+= "AND SC2.C2_NUM+C2_ITEM+C2_SEQUEN='"+mv_par01+"' "+CRLF
	cQuery	+= "AND SC2.C2_LOTECTL='"+mv_par02+"' "+CRLF
	cQuery	+= "AND SC2.D_E_L_E_T_ = ' ' "  +CRLF

	cQuery	:= ChangeQuery(cQuery)


	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		If (cArqTmp)->B1_YCATGOR == '02'
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GetQtdEtiqºAutor  ³ Microsiga	      º Data ³  09/01/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±        
±±ºDesc.     ³ Retorna a quantidade de etiqueta					           º±±
±±ºDesc.     ³ 											                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetQtdEtiq(cOp)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local nRet		:= 0

cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("CB0")+" CB0 "+CRLF
cQuery	+= " WHERE CB0.CB0_FILIAL = '"+xFilial("CB0")+"' " +CRLF
cQuery	+= " AND CB0.CB0_OP = '"+cOp+"' " +CRLF
cQuery	+= " AND D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

If (cArqTmp)->(!Eof()) 
	nRet := (cArqTmp)->CONTADOR
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf
RestArea(aArea)
Return nRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GetPosEtiqºAutor  ³ Microsiga	     º Data ³  09/01/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±        
±±ºDesc.     ³ Retorna a posição da etiqueta					           º±±
±±ºDesc.     ³ 											                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetPosEtiq(cCodEti)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local cRet		:= ""

Default cCodEti	:= ""

cQuery	:= " SELECT CB0_YSEQEM FROM "+RetSqlName("CB0")+" CB0 "+CRLF
cQuery	+= " WHERE CB0.CB0_FILIAL = '"+xFilial("CB0")+"' " +CRLF
cQuery	+= " AND CB0.CB0_CODETI = '"+cCodEti+"' " +CRLF
cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

If (cArqTmp)->(!Eof()) 
	cRet := (cArqTmp)->CB0_YSEQEM
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return cRet
