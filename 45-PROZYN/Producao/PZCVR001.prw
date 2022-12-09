#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FWPrintSetup.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PZCVR001  ºAutor  ³ MIcrosiga	     º Data ³  10/01/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±        
±±ºDesc.     ³ Rotina para impressão dos rotulos dos produtos (Pet´s)      º±±
±±ºDesc.     ³ Essa etiqueta é específica para Prozyn.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PZCVR001(lImpWiz, aCodEti)

	Private _aSavArea	:= GetArea()
	Private _cRotina	:= "PZCVR001"
	Private _cAlias		:= ""
	Private _cAlias2	:= ""	
	Private oFont1		:= TFont():New('Arial',,028,,.F.,,,,,.F. ) //Título até 11 caracteres
	Private oFont2		:= TFont():New('Arial',,016,,.T.,,,,,.F. ) //Sub-título
	Private oFont3		:= TFont():New('Arial',,042,,.T.,,,,,.F. ) //Título acima de 14 caracteres
	Private oFont4		:= TFont():New('Arial',,010,,.F.,,,,,.F. ) //Sub-título
	Private oFont5		:= TFont():New('Arial',,008,,.T.,,,,,.F. ) //Descritivo (Negrito)
	Private oFont6		:= TFont():New('Arial',,008,,.F.,,,,,.F. ) //Descritivo (Negrito)   
	Private oFontTrIm	:= TFont():New('Arial',,005,,.F.,,,,,.F. ) //Descritivo (Negrito)	
	Private oFont7		:= TFont():New('Arial',,022,,.T.,,,,,.F. ) //Descritivo (Negrito)
	Private _lPreview	:= .T.                         
	Private cPerg		:= "RPCPR002"

	Default lImpWiz		:= .F. 
	Default aCodEti		:= {}

	//Chama a rotina para criação de parametros do relatório
	Processa({|lEnd| ImpEtiqueta(lImpWiz, aCodEti)},_cRotina,"Aguarde... Processando a impressão da(s) etiqueta(s)...",.T.)

	//Restauro a área de trabalho original
	RestArea(_aSavArea)

Return()

Static Function ImpEtiqueta(lImpWiz, aCodEti)

	Local cTexFix	:= ""
	Local cTextTran	:= ""
	Local nColGaran	:= 0
	Local nXi		:= 0
	Local n			:= 0

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

			oPrinter:Line    (0045, 0000, 0045, 0620,0,"-4")

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
				oPrinter:SayAlign(0050, 0335,"FECHA DE ELABORACIÓN:"						  ,oFont4,0330,0060,,0,1)				    
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
				//oPrinter:SayBitmap(0140,0450, "\00-pictogramas\transenico3.bmp", 100, 100)
				oPrinter:SayBitmap(0155,0440, "\00-pictogramas\transenico3.bmp", 75, 50)

				/*cTextTran := ""
				cTextTran := "Contém amido de milho transgênico. Espécies doadoras de gene: Bacillus thuringiensis, Streptomyces viridochromogenes, Agrobacterium tumefaciens e Zea mays."
				For nXi := 1 To MLCount(Alltrim(cTextTran),35)
				oPrinter:Say(0190+(nXi*5),0440,MemoLine(Alltrim(cTextTran),35,nXi),oFontTrIm)
				Next nXi*/
			ENDIF

			oPrinter:SayBitmap(0155,550,RTRIM((_cAlias)->B1_PICTOG), 80, 80)		    

			//Imagem ministerio da agricultura	
			oPrinter:SayBitmap(0020,0650, "\00-pictogramas\MinisAgricAlimAnim.bmp", 180, 180)
			//oPrinter:SayBitmap(0046,0650, "\00-pictogramas\MinisAgricAlimAnim.bmp", 155, 155)

			//Niveis de garantia inicio
			If mv_par03 = 2
				oPrinter:Say(90, 510,"LEVELS OF WARRANTY"        , oFont5)
				oPrinter:Say(103, 542,"(%) OU G/ KG"   		     , oFont5)
				oPrinter:Say(103, 450,"INGREDIENTS"   		     , oFont5)
			ElseIf mv_par03 = 3
				oPrinter:Say(90, 510,"NIVELES DE GARANTÍA"        , oFont5)
				oPrinter:Say(103, 542,"(%) OU G/ KG"   		     , oFont5)
				oPrinter:Say(103, 450,"INGREDIENTES"   		     , oFont5)
			ElseIf mv_par03 = 4
				oPrinter:Say(90, 510,"NÍVEIS DE GARANTIA"        , oFont5)
				oPrinter:Say(103, 542,"(%) OU G/ KG"   		     , oFont5)
				oPrinter:Say(103, 450,"INGREDIENTES"   		     , oFont5)
			Else
				oPrinter:Say(90, 510,"NÍVEIS DE GARANTIA"        , oFont5)
				oPrinter:Say(103, 542,"(%) OU G/ KG"   		     , oFont5)
				oPrinter:Say(103, 450,"INGREDIENTES"   		     , oFont5)
			EndIf			    

			oPrinter:Say(113, 450,(_cAlias)->B1_Y1GAING   		     , oFont6)
			oPrinter:Say(123, 450,(_cAlias)->B1_Y2GAING   		     , oFont6)
			oPrinter:Say(133, 450,(_cAlias)->B1_Y3GAING   		     , oFont6)
			oPrinter:Say(113, 542,(_cAlias)->B1_Y1GAUNI   		     , oFont6)
			oPrinter:Say(123, 542,(_cAlias)->B1_Y21GAUN   		     , oFont6)
			oPrinter:Say(133, 542,(_cAlias)->B1_Y31GAUN   		     , oFont6)


			oPrinter:Line(95,0445,95,620)
			oPrinter:Line(105,0445,105,620)

			If !Empty((_cAlias)->B1_Y1GAING ) .Or. !Empty((_cAlias)->B1_Y1GAUNI) 
				oPrinter:Line(115,0445,115,620)
				nColGaran +=20
			EndIf

			If !Empty((_cAlias)->B1_Y2GAING) .Or. !Empty((_cAlias)->B1_Y21GAUN )
				oPrinter:Line(125,0445,125,620)
				nColGaran +=10
			EndIf

			If !Empty((_cAlias)->B1_Y3GAING) .Or. !Empty((_cAlias)->B1_Y31GAUN)
				oPrinter:Line(135,0445,135,620)
				nColGaran +=10
			EndIf

			oPrinter:Line(95,537,95+nColGaran,537)


			//Niveis de garantia fim

			_nLin:=90
			_cDescPO := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASPO") 
			_cDEscIN := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASIN") 
			_cDescES := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASES") 
			_cDEscOU := POSICIONE("SZ9", 1, xFilial("SZ9") + (_cAlias)->B1_DESCETI, "Z9_CLASOU")

			If mv_par03 = 2
				oPrinter:Say(_nLin, 0020,"CLASSIFICATION: "         ,oFont5)
				oPrinter:Say(_nLin, 0090,_cDescIN ,oFont6)			    

			ElseIf mv_par03 = 3
				oPrinter:Say(_nLin, 0020,"CLASIFICACIÓN: "         ,oFont5)
				oPrinter:Say(_nLin, 0090,_cDescES ,oFont6)			    

			ElseIf mv_par03 = 4
				oPrinter:Say(_nLin, 0020,"CLASSIFICAÇÃO: "         ,oFont5)
				oPrinter:Say(_nLin, 0090,_cDescOU ,oFont6)			    

			Else
				oPrinter:Say(_nLin, 0020,"CLASSIFICAÇÃO: "         ,oFont5)
				oPrinter:Say(_nLin, 0090,_cDescPO ,oFont6)
			EndIf    

			_nLin+=10			   
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

			For nXi := 1 To MLCount(Alltrim(_cCompos),80)
				oPrinter:Say(_nLin,0080,MemoLine(Alltrim(_cCompos),80,nXi),oFont6)
				_nLin += 10
			Next nXi


			If (_cAlias)->B1_TRANSGE == "1"
				//_nLin+=10
				If mv_par03 = 2
					cTextTran	:= "Contains genetically modified corn starch. Gene donor species: Bacillus thuringiensis, Streptomyces viridochromogenes, Agrobacterium tumefaciens e Zea mays."
				ElseIf mv_par03 = 3
					cTextTran	:= "Contiene almidón de maíz trangénico. Especies donantes de genes: Bacillus thuringiensis, Streptomyces viridochromogenes, Agrobacterium tumefaciens e Zea mays."
				ElseIf mv_par03 = 4
					cTextTran	:= "Contém amido de milho transgênico. Espécies doadoras de gene: Bacillus thuringiensis, Streptomyces viridochromogenes, Agrobacterium tumefaciens e Zea mays."
				Else
					cTextTran	:= "Contém amido de milho transgênico. Espécies doadoras de gene: Bacillus thuringiensis, Streptomyces viridochromogenes, Agrobacterium tumefaciens e Zea mays."
				EndIf    

				For nXi := 1 To MLCount(cTextTran,90)
					oPrinter:Say(_nLin,0020,MemoLine(cTextTran,90,nXi),oFont6)
					_nLin += 10
				Next nXi

			ENDIF

			//_nLin += 5                                  

			//_nLin += 25
			// - termino mudança solicitada pela qualidade em 151217

			/*dbSelectArea(_cAlias)	

			_cManuPO := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUPO") 
			_cManuIN := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUIN") 
			_cManuES := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUES") 
			_cManuOU := POSICIONE("SZA", 1, xFilial("SZA") + (_cAlias)->B1_MANUSEI, "ZA_MANUOU")*/

			IF mv_par03 = 2 //.AND. !EMPTY(_cManuIN)
				oPrinter:Say(_nLin, 0020,"SPECIES OF ANIMAL TO WHICH IT IS DESTINED: ", oFont5)			 
				oPrinter:Say(_nLin, 0193,cmbDesc((_cAlias)->B1_YANIMAL, 'B1_YANIMAL'),     oFont6)			

				oPrinter:Say(_nLin, 0255,"INDICATION OF USE: ", oFont5)
				oPrinter:Say(_nLin, 0333,(_cAlias)->B1_YINDUSO,     oFont6)

			ELSEIF mv_par03 = 3  //.AND. !EMPTY(_cManuES)
				oPrinter:Say(_nLin, 0020,"ESPECIE ANIMAL A LA QUE SE DESTINA: ", oFont5)			
				oPrinter:Say(_nLin, 0175,cmbDesc((_cAlias)->B1_YANIMAL, 'B1_YANIMAL')  ,   oFont6)			

				oPrinter:Say(_nLin, 0250,"INDICACIÓN DE USO: ", oFont5)
				oPrinter:Say(_nLin, 0330,(_cAlias)->B1_YINDUSO,     oFont6)

			ELSEIF mv_par03 = 4  //.AND. !EMPTY(_cManuOU)
				oPrinter:Say(_nLin, 0020,"ESPÉCIE ANIMAL A QUE SE DESTINA: ", oFont5)			
				oPrinter:Say(_nLin, 0165,cmbDesc((_cAlias)->B1_YANIMAL, 'B1_YANIMAL')  ,   oFont6)		

				oPrinter:Say(_nLin, 0250,"INDICAÇÃO DE USO: ", oFont5)
				oPrinter:Say(_nLin, 0330,(_cAlias)->B1_YINDUSO,     oFont6)

			ELSE
				oPrinter:Say(_nLin, 0020,"ESPÉCIE ANIMAL A QUE SE DESTINA: ", oFont5)			
				oPrinter:Say(_nLin, 00165,cmbDesc((_cAlias)->B1_YANIMAL, 'B1_YANIMAL')  ,   oFont6)			

				oPrinter:Say(_nLin, 0250,"INDICAÇÃO DE USO: ", oFont5)
				oPrinter:Say(_nLin, 0330,(_cAlias)->B1_YINDUSO,     oFont6)

			ENDIF

			_nLin += 10                                                                                                                                         

			If mv_par03 = 2
				oPrinter:Say(_nLin, 0020,"RESTRICTIONS AND RECOMMENDATIONS: "        , oFont5)
				oPrinter:Say(_nLin, 0180,(_cAlias)->B1_YRESREC        , oFont6)
			ElseIf mv_par03 = 3
				oPrinter:Say(_nLin, 0020,"RESTRICCIONES Y RECOMENDACIONES: "        , oFont5)
				oPrinter:Say(_nLin, 0170,(_cAlias)->B1_YRESREC        , oFont6)
			ElseIf mv_par03 = 4
				oPrinter:Say(_nLin, 0020,"RESTRIÇÕES E RECOMENDAÇÕES: "        , oFont5)
				oPrinter:Say(_nLin, 0150,(_cAlias)->B1_YRESREC        , oFont6)
			Else
				oPrinter:Say(_nLin, 0020,"RESTRIÇÕES E RECOMENDAÇÕES: "        , oFont5)
				oPrinter:Say(_nLin, 0150,(_cAlias)->B1_YRESREC        , oFont6)
			EndIf

			_nLin += 10                                                                                                                                         

			If mv_par03 = 2
				oPrinter:Say(_nLin, 0020,"CONSERVATION MODE:"        , oFont5)
				For nXi := 1 To MLCount((_cAlias)->B1_YMODCON,90)

					If nXi == 1
						oPrinter:Say(_nLin, 0130,MemoLine((_cAlias)->B1_YMODCON,90,nXi)     , oFont6)
					Else
						oPrinter:Say(_nLin,0020,MemoLine((_cAlias)->B1_YMODCON,90,nXi)		,oFont6)
					EndIf
					_nLin += 10
				Next nXi					

			ElseIf mv_par03 = 3
				oPrinter:Say(_nLin, 0020,"MODO DE CONSERVACIÓN:"        , oFont5)
				For nXi := 1 To MLCount((_cAlias)->B1_YMODCON,90)

					If nXi == 1
						oPrinter:Say(_nLin, 0130,MemoLine((_cAlias)->B1_YMODCON,90,nXi)     , oFont6)
					Else
						oPrinter:Say(_nLin,0020,MemoLine((_cAlias)->B1_YMODCON,90,nXi)		,oFont6)
					EndIf
					_nLin += 10
				Next nXi					

			ElseIf mv_par03 = 4
				oPrinter:Say(_nLin, 0020,"MODO DE CONSERVAÇÃO: "        , oFont5)
				For nXi := 1 To MLCount((_cAlias)->B1_YMODCON,90)

					If nXi == 1
						oPrinter:Say(_nLin, 0130,MemoLine((_cAlias)->B1_YMODCON,90,nXi)     , oFont6)
					Else
						oPrinter:Say(_nLin,0020,MemoLine((_cAlias)->B1_YMODCON,90,nXi)		,oFont6)
					EndIf
					_nLin += 10
				Next nXi					

			Else
				oPrinter:Say(_nLin, 0020,"MODO DE CONSERVAÇÃO: "        , oFont5)
				For nXi := 1 To MLCount((_cAlias)->B1_YMODCON,90)

					If nXi == 1
						oPrinter:Say(_nLin, 0130,MemoLine((_cAlias)->B1_YMODCON,90,nXi)     , oFont6)
					Else
						oPrinter:Say(_nLin,0020,MemoLine((_cAlias)->B1_YMODCON,90,nXi)		,oFont6)
					EndIf
					_nLin += 10
				Next nXi					

			EndIf


			If mv_par03 = 2
				cTexFix := "PRODUCT EXEMPT REGISTERED IN THE MINISTRY OF AGRICULTURE, LIVESTOCK AND FOOD SUPPLY."
			ElseIf mv_par03 = 3
				cTexFix := "TEXTO FIJO EN EL FUENTE: PRODUCTO EXENTO DE REGISTRO EN EL MINISTERIO DE AGRICULTURA, PECUARIA Y ABASTECIMIENTO."
			ElseIf mv_par03 = 4
				cTexFix := "PRODUTO ISENTO DE REGISTRO NO MINISTÉRIO DA AGRICULTURA, PECUÁRIA E ABASTECIMENTO."
			Else
				cTexFix := "PRODUTO ISENTO DE REGISTRO NO MINISTÉRIO DA AGRICULTURA, PECUÁRIA E ABASTECIMENTO."
			EndIf

			_nLin += 5
			For nXi := 1 To MLCount(cTexFix,90)
				oPrinter:Say(_nLin,0020,MemoLine(cTexFix,90,nXi),oFont6)
				_nLin += 10
			Next nXi


			// - Inicio mudança solicitada pela qualidade em 151217			   

			_cAlergenico := (_cAlias)->B1_ALERGEN

			If !Empty(_cAlergenico)
				IF MV_PAR03 = 2
					oPrinter:Say(_nLin, 0020,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERIN")     , oFont5)			    	
				ELSEIF MV_PAR03 =3
					oPrinter:Say(_nLin, 0020,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERES")     , oFont5)			    	
				ELSEIF MV_PAR03 =4
					oPrinter:Say(_nLin, 0020,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALEROU")     , oFont5)			    	
				ELSE
					oPrinter:Say(_nLin, 0020,POSICIONE("SZB", 1, xFilial("SZB") + _cAlergenico, "ZB_ALERPO")     , oFont5)
				ENDIF

				IF (_cAlias)->B1_GLUTEN = "1" 	
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0330,"CONTAIN GLUTEN"        , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0330,"CONTIENE GLUTEN"        , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0330,"CONTEM GLÚTEN"        , oFont5)
					Else
						oPrinter:Say(_nLin, 0330,"CONTEM GLÚTEN"        , oFont5)
					EndIf    
				ELSE
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0330,"GLUTEN-FREE"    , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0330,"NO CONTIENE GLUTEN"    , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0330,"NÃO CONTEM GLÚTEN"    , oFont5)
					Else
						oPrinter:Say(_nLin, 0330,"NÃO CONTEM GLÚTEN"    , oFont5)
					EndIf	        		
				ENDIF

			Else

				IF (_cAlias)->B1_GLUTEN = "1" 	
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0020,"CONTAIN GLUTEN"        , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0020,"CONTIENE GLUTEN"        , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0020,"CONTEM GLÚTEN"        , oFont5)
					Else
						oPrinter:Say(_nLin, 0020,"CONTEM GLÚTEN"        , oFont5)
					EndIf    
				ELSE
					If mv_par03 = 2
						oPrinter:Say(_nLin, 0020,"GLUTEN-FREE"    , oFont5)
					ElseIf mv_par03 = 3
						oPrinter:Say(_nLin, 0020,"NO CONTIENE GLUTEN"    , oFont5)
					ElseIf mv_par03 = 4
						oPrinter:Say(_nLin, 0020,"NÃO CONTEM GLÚTEN"    , oFont5)
					Else
						oPrinter:Say(_nLin, 0330,"NÃO CONTEM GLÚTEN"    , oFont5)
					EndIf	        		
				ENDIF


			EndIf



			_nLin += 10
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
			_nLin += 10
			oPrinter:Say(_nLin, 0020,"INDÚSTRIA BRASILEIRA", oFont6)

			_nLin += 10 

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

			oPrinter:MSBAR("EAN13",20,3,(_cAlias)->B1_CODBAR,oPrinter,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)

			If lImpWiz .And. Len(aCodEti) > 0
				oPrinter:MSBAR("CODE128",22,22, aCodEti[n], oPrinter,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)
				oPrinter:Say(295, 0285,aCodEti[n], oFont6)
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
	
	Local j	:= 0
	Local i	:= 0
	
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



Static Function cmbDesc(cChave, cCampo, cConteudo)
	Local aArea       := GetArea()
	Local aCombo      := {}
	Local nAtual      := 1
	Local cDescri     := ""
	Default cChave    := ""
	Default cCampo    := ""
	Default cConteudo := ""

	//Se o campo e o conteúdo estiverem em branco, ou a chave estiver em branco, não há descrição a retornar
	If (Empty(cCampo) .And. Empty(cConteudo)) .Or. Empty(cChave)
		cDescri := ""
	Else
		//Se tiver campo
		If !Empty(cCampo)
			aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)

			//Percorre as posições do combo
			For nAtual := 1 To Len(aCombo)
				//Se for a mesma chave, seta a descrição
				If Alltrim(cChave) $ Alltrim(aCombo[nAtual][1])
					cDescri := Separa(Alltrim(aCombo[nAtual][1]),"=")[2]
				EndIf
			Next

			//Se tiver conteúdo
		ElseIf !Empty(cConteudo)
			aCombo := StrTokArr(cConteudo, ';')

			//Percorre as posições do combo
			For nAtual := 1 To Len(aCombo)
				//Se for a mesma chave, seta a descrição
				If cChave == SubStr(aCombo[nAtual], 1, At('=', aCombo[nAtual])-1)
					cDescri := SubStr(aCombo[nAtual], At('=', aCombo[nAtual])+1, Len(aCombo[nAtual]))
				EndIf
			Next
		EndIf
	EndIf

	RestArea(aArea)
Return cDescri




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