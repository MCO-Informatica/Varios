
#Include "rwmake.ch"
         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450GRV ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Incluindo Processos a Partir da OS   .                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT450GRV()
Local lOk := .T.
lok := U_AT450PV(.T.)
lOk := U_AT450ET(.T.)
LOK := U_AT450OP(.T.)
lok := U_AT450CC(.T.)
LOK := U_AT450VC(.T.)
Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450PV  ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ INCLUINDO PEDIDO DE VENDAS                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT450PV(lOkPV)

Local aArea      := (GetArea())           

Local aItGrPed   := {}      
Local aGerouPV   := {}       
Local aUserCpoPv := {}
Local aDadosCFO  := {}
Local aHeadC6    := {}
Local aColsC6    := {}
Local aFabric    := {}

Local cCfo       := ""
Local bCampo	:= { |nCPO| Field(nCPO) }
Local lTecXSC5   := (ExistBlock("TECXSC5"))
Local lAtCpPvOs  := (ExistBlock("ATCPPVOS"))
Local lAt410Grv  := (ExistBlock("AT410GRV"))
Local lGerouPV   := .F.
Local lInclBack  := .F. 
Local lAT450GIT  := ExistBlock( "AT450GIT" ) 

Local nCntFor    := 0
Local nCntFor2   := 0
Local nPIteAB7   := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_ITEM"})
Local nPPrdAB7   := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_CODPRO"})
Local nPMem1AB7  := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_MEMO2"})
Local nPMem2AB7  := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_MEMO4"})
Local nOpcAB7    := 0
Local nPosUsrCpo := 0
Local nAcolC6    := 0
Local nItSc6     := 0
Local nRecnoAB6  := 0 
Local nAcao      := 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o Pedido de Vendas                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lOkPV = .T. 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta aHeader do SC6                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC6",.T.)
		While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
			If (  ((X3Uso(SX3->X3_USADO) .And. ;
					!( Trim(SX3->X3_CAMPO) == "C6_NUM" ) .And.;
					Trim(SX3->X3_CAMPO) != "C6_QTDEMP"  .And.;
					Trim(SX3->X3_CAMPO) != "C6_QTDENT") .And.;
					cNivel >= SX3->X3_NIVEL) .Or.;
					Trim(SX3->X3_CAMPO)=="C6_NUMOS"  .Or. ;
					Trim(SX3->X3_CAMPO)=="C6_NUMOSFA".Or. ;
					Trim(SX3->X3_CAMPO)=="C6_NUMOP"  .Or. ;
					Trim(SX3->X3_CAMPO)=="C6_ITEMOP" .Or. ;
					Trim(SX3->X3_CAMPO)=="C6_OP" )
				Aadd(aHeadC6,{ Trim(SX3->X3_TITULO),;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									If(Trim(SX3->X3_CAMPO)$"C6_NUMOS#C6_NUMOSFA",".F.",SX3->X3_VALID),;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_ARQUIVO,;
									SX3->X3_CONTEXT } )
				If ( AllTrim(SX3->X3_CAMPO)=="C6_ITEM" )
					nItSc6 := Len(aHeadC6)
				EndIf
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
		RestArea(aArea)
  	    dbSelectArea("AB7")
     	dbSetOrder(1)
    	MsSeek(xFilial("AB7")+AB6->AB6_NUMOS)
    	While ( !Eof() .And. AB7->AB7_FILIAL == xFilial("AB7") .And.;
    							AB7->AB7_NUMOS== AB6->AB6_NUMOS )
								
			lGerouPV := .F.								
								
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve gerar pedidos deste item            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AB6->AB6_GPI=.T.  //!Empty( AScan( aItGrPed, AB7->AB7_ITEM ) ) 
	
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona Registros                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+AB6->AB6_CODCLI+AB6->AB6_LOJA)
				RecLock("SA2")
	
				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+AB7->AB7_CODPRS)
	
				dbSelectArea("SB2")
				dbSetOrder(1)
				MsSeek(xFilial("SB2")+AB7->AB7_CODPRS+AB7->AB7_ALMOX)
	
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+AB7->AB7_TS)
	           
	            dbSelectArea("SC5")
				dbSetOrder(1)
				IF MsSeek(xFilial("SC5")+"B" + SUBSTR(AB6->AB6_NUMOS,2,5))
				  nAcao:=2
				endif  
	            
			   //	dbSelectArea("AA3")
			   //	dbSetOrder(1)
			   //	MsSeek(xFilial("AA3")+AB8->AB8_CODCLI+AB8->AB8_LOJA+AB8->AB8_CODPRD+AB8->AB8_NUMSER)
			   	If AB7->AB7_CUSTOS > 0 
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Preenche o aCols do SC6                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aadd(aColsC6,Array(Len(aHeadC6)+1))
					nAcols := Len(aColsC6)
					aColsC6[nAcols,Len(aHeadC6)+1] := .F.
					
					lGerouPV := .T.
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define o CFO                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aDadosCFO := {}
				 	Aadd(aDadosCfo,{"OPERNF","S"})
				 	Aadd(aDadosCfo,{"TPCLIFOR",SA2->A2_TIPO})					
				 	Aadd(aDadosCfo,{"UFDEST"  ,SA2->A2_EST})
					cCfo := MaFisCfo(,SF4->F4_CF,aDadosCfo)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Alimenta os campos definidos pelo usuario            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aUserCpoPv := {}
					
					If lATCPPVOS 
						aUserCpoPv := ExecBlock( "ATCPPVOS", .F., .F., { "1" } )
					EndIf
					
					For nCntFor := 1 To Len(aHeadC6)
						Do Case
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
								aColsC6[nAcols,nCntFor] := "01"
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_CODPRS
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_CODISS" )
								aColsC6[nAcols,nCntFor] := SB1->B1_CODISS
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_UM" )
								aColsC6[nAcols,nCntFor] := SB1->B1_UM
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_QTSAI
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRCVEN" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_CUSTOS
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_VALOR" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_CUSTOS*AB7->AB7_QTSAI
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_TES" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_TS
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_CF" )
								aColsC6[nAcols,nCntFor] := cCfo 
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_LOTECTL" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_RI
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_SEGUM" )
								aColsC6[nAcols,nCntFor] := SB1->B1_SEGUM
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_LOCAL" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_ALMOX
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_LOCALIZ" )
								aColsC6[nAcols,nCntFor] := ""
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMSERI" )
								aColsC6[nAcols,nCntFor] := ""
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
								aColsC6[nAcols,nCntFor] := AB6->AB6_VENCTO
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PEDCLI" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_NUMOS
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_DESSAI
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRUNIT" )
								aColsC6[nAcols,nCntFor] := AtVlrPagto(AB7->AB7_CODPRO,AB7->AB7_CUSTOS,"C", .T.)
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMOS" )
								aColsC6[nAcols,nCntFor] := AB7->AB7_NUMOS+AB7->AB7_ITEM
							Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
								aColsC6[nAcols,nCntFor] := "Rem.p/Ordem S." + ab6->ab6_numos
							OtherWise
								aColsC6[nAcols,nCntFor] := CriaVar(aHeadC6[nCntFor,2],.T.)
						EndCase
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Preenche os campos de usuario                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty( nPosUsrCpo := aScan( aUserCpoPV, { |x| AllTrim( x[1] ) == AllTrim(aHeadC6[nCntFor,2] ) } ) )
							aColsC6[nAcols,nCntFor] := aUserCpoPV[ nPosUsrCpo, 2 ]  
						EndIf 					
						
					Next nCntFor
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria um array por item                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty( nScanIt := AScan( aGerouPV, { |x| x[1] == AB7->AB7_ITEM } ) ) 
					AAdd( aGerouPV, { AB7->AB7_ITEM, .F., "5" } )                             
				Else				
					aGerouPV[ nScanIt, 2 ] := If( aGerouPV[ nScanIt, 2 ], .T., lGerouPV )
				EndIf									
				
			EndIf 				   
				
			dbSelectArea("AB7")
			dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara para grava PV do Cliente                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( Len(aColsC6) > 0 )
			aHeader := aHeadC6
			aCols   := aColsC6
			cItSc6  := "01"
			For nCntFor := 1 To Len(aCols)
				aCols[nCntFor][nItSc6] := cItSc6
				cItSc6 := Soma1(cItSc6,2)
			Next nCntFor
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava Pedido para o Fornecedor                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+AB6->AB6_CODCLI+AB6->AB6_LOJA)
			RecLock("SA2")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria as Variaveis do Pedido de Venda                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC5")
			For nCntFor := 1 To FCount()
				M->&(EVAL(bCampo,nCntFor)) := CriaVar(FieldName(nCntFor),.T.)
			Next nCntFor
		    M->C5_NUM	  := "B" + SUBSTR(AB6->AB6_NUMOS,2,5)
			M->C5_TIPO    := "B"
			M->C5_EMISSAO := AB6->AB6_EMISSA
			M->C5_CLIENTE := AB6->AB6_CODCLI
			M->C5_LOJAENT := AB6->AB6_LOJA
			M->C5_LOJACLI := AB6->AB6_LOJA
			M->C5_TIPOCLI := "R"
			M->C5_CONDPAG := AB6->AB6_CONPAG 
			M->C5_TABELA  := AB6->AB6_TABELA 
			M->C5_MOEDA   := AB6->AB6_MOEDA 
			M->C5_DESC1   := AB6->AB6_DESC1
			M->C5_DESC2   := AB6->AB6_DESC2
			M->C5_DESC3   := AB6->AB6_DESC3
			M->C5_DESC4   := AB6->AB6_DESC4
			M->C5_COTCLI  := "Rem.p/Ordem S." + ab6->ab6_numos
			M->C5_AGINT   := "000000"
			M->C5_VEND1	  := "000001"
			M->C5_ESTENT  := "SP"
			M->C5_TRANSP  := "000000"
			M->C5_CONTATO := "000000"
			M->C5_CLIENT  := AB6->AB6_CODCLI
			M->C5_STSBLQ  :="1"
	
			lInclBack  := INCLUI 
			INCLUI     := .T.
			
			If lAt410Grv			
				Execblock("AT410GRV",.F.,.F.,{1})
			EndIf
			IF nAcao=1
				  a410Grava("SC5","SC6")
			ENDIF  
			If ( __lSx8 )
				ConfirmSx8()
			EndIf
			EvalTrigger()
			
			INCLUI := lInclBack 
			             
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia um e-mail automatico                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MEnviaMail( "010", { 1, SC5->C5_NUM, SA2->A2_COD + "/" + SA2->A2_LOJA + "-" + AllTrim(SA2->A2_NOME), AB6->AB6_NUMOS } )  
			
		EndIf
	EndIf
Return lOkpv

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450PV  ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ INCLUINDO ESTRUTURA DE PRODUTO                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION AT450ET(lOkET)

Return lOkET
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450PV  ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ INCLUINDO ORDEM DE PRODUCAO                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION AT450OP(lOkOP)
local cProcura
Local aArea      := (GetArea())  


dbSelectArea("AB7")
DbSetOrder(1)
MsSeek(xFilial("AB7")+AB6->AB6_NUMOS)
While ( !Eof() .And. AB7->AB7_FILIAL == xFilial("AB7") .And.;
    							AB7->AB7_NUMOS== AB6->AB6_NUMOS )
	IF AB7->AB7_PV="      "       
	  cProcura:=AB6->AB6_NUMOS+"01"+"EST" 
	else
	  cProcura:=AB6->AB6_NUMOS+"01"+"CAS"
	endif  
	DbSelectArea("SC2")
	dbSetOrder(1)
	If MsSeek(xfilial("SC2")+cProcura)     	
	else
	  	    Reclock("SC2",.T.)
			SC2->C2_FILIAL :=xfilial("SC2") 
			SC2->C2_NUM :=AB6->AB6_NUMOS
			SC2->C2_ITEM:="01" 
			IF AB7->AB7_PV="      "
			  SC2->C2_OBS :="Material para Estoque" 
		      SC2->C2_SEQUEN :="EST"
			ELSE
			  SC2->C2_PEDIDO :=AB7->AB7_PV
			  SC2->C2_ITEMPV :=AB7->AB7_ITPV
			  SC2->C2_DESTINA:="P"
			  SC2->C2_OBS    :="Material Empenhado em Venda"
			  SC2->C2_SEQUEN :="CAS"
			ENDIF  
		    SC2->C2_PRODUTO:=AB7->AB7_CODPRE    
	        SC2->C2_LOCAL  :=AB7->AB7_ALMOX
	        SC2->C2_QUANT  :=AB7->AB7_QTENT
	        SC2->C2_UM     :="PC"
	        SC2->C2_DATPRI :=AB6->AB6_EMISSA
	        SC2->C2_DATPRF :=AB6->AB6_VENCTO
	        SC2->C2_EMISSAO:=AB6->AB6_EMISSA
	        SC2->C2_PRIOR  :="500"
	        SC2->C2_SEQPAI :="000"
	        SC2->C2_TPOP  :="F"
    	    MSUnlock()
	ENDIF 
	dbSelectArea("AB7")
	dbSkip()
EndDo
RestArea(aArea)
Return lOkOP     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450CC  ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ INCLUINDO OS CASADA                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION AT450CC(lOkOP)
local cProcura
Local aArea      := (GetArea())  
lOCAL cRegistro

dbSelectArea("AB7")
DbSetOrder(1)
MsSeek(xFilial("AB7")+AB6->AB6_NUMOS)
IF (!Eof() .And. AB7->AB7_FILIAL == xFilial("AB7") .And.;
   							AB7->AB7_NUMOS== AB6->AB6_NUMOS )
IF AB7->AB7_PV="      " .OR. AB7->AB7_TIPO="5"   
ELSE
  dbSelectArea("SZK")
  DbSetOrder(4)
  IF MsSeek(xFilial("SZK")+"OS"+AB6->AB6_NUMOS+"01 "+"PV"+AB7->AB7_PV+AB7->AB7_ITPV)
    Reclock("SZK",.F.)
  ELSE
    Reclock("SZK",.T.)
  ENDIF
  SZK->ZK_FILIAL :=xfilial("SZK") 
  SZK->ZK_TIPO   :="PV"                        	// TIPO 
  SZK->ZK_REF    :=AB7->AB7_PV                 	// PEDIDO
  SZK->ZK_REFITEM:=AB7->AB7_ITPV               	// ITEM PEDIDO
  SZK->ZK_NOME   :=AB7->AB7_NREDUZ             	// CLIENTE
  SZK->ZK_COD    :=AB7->AB7_CODPRE             	// CODIGO PRODUTO
  SZK->ZK_DESCRI :=AB7->AB7_DESENT             	// DESCRICAO
  SZK->ZK_QTD    :=AB7->AB7_QTDVDA             	// QUANTIDADE VENDA
  SZK->ZK_PRAZO  :=AB7->AB7_PRAZOV             	// PRAZO VENDA
  SZK->ZK_TIPO2  :="OS"                       	// TIPO2 
  SZK->ZK_OC     :=AB6->AB6_NUMOS             	// NUMERO OS
  SZK->ZK_ITEM   :="01"                        	// ITEM OS
  SZK->ZK_FORN   :=AB6->AB6_NREDUZ            	// FORNECEDOR
  SZK->ZK_QTC    :=AB7->AB7_QTENT              	// QUANTIDADE CASADA
  SZK->ZK_PRAZOC :=AB6->AB6_VENCTO             	// PRAZO ENTRADA
  SZK->ZK_QTS    :=AB7->AB7_QTENT              	// QUANTIDADE PENDENTE
  SZK->ZK_DT_VINC:=AB6->AB6_EMISSA				// DATA DA VINCULACAO
  SZK->ZK_CONTROL:="AOS"						// METODO
  SZK->ZK_STATUS :="1"							// STATUS DA OS
  MsUnLock()
  RestArea(aArea)
ENDIF
ENDIF
// TRATA CONTROLE DE PROCESSO
IF AB7->AB7_PV="      " .OR. AB7->AB7_TIPO="5"   
ELSE
  dbselectarea("PC2")
  dbSetOrder(4)
  MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000005")
  if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SZK->ZK_REF .AND. SUBSTRING(SZK->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000005"
       cRegistro:=PC2->PC2_CTR
       // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
        U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000005","000008",SZK->ZK_QTC,"Aguardando Amarracao","","","Ok Disposto OS",cRegistro) 
       MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000008")
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA ORDEM DE COMPRA E COLOCA EM AGUARDANDO RECEBIMENTO
        U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000008","000009",SZK->ZK_QTC,"Aguardando Fat Rem. Benef","","","OS:"+AB6->AB6_NUMOS+" - 01 - "+AB6->AB6_NREDUZ,cRegistro) 
  endif 
  RestArea(aArea)
ENDIF





Return lOkOP     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450VC  ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Amarracao de codigos alternativos                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION AT450VC(lOkOP)
local cProcura
Local aArea      := (GetArea())  
dbSelectArea("PA1")
DbSetOrder(1)
MsSeek(xFilial("PA1")+AB7->AB7_CODPRE+AB7->AB7_CODPRS)
IF (!Eof() .And. AB7->AB7_CODPRE == PA1->PA1_PROD .And.;
   							AB7->AB7_CODPRS== PA1->PA1_ALTERN)
ELSE
    IF AB7->AB7_CODPRS<>AB7->AB7_CODPRE
    If MsgYesNo("Deseja amarrar produto -->" + AB7->AB7_CODPRS + " como Pai do Produto -->" + AB7->AB7_CODPRE + " ","Rotinas Automáticas")
      Reclock("PA1",.T.)
      PA1->PA1_PROD:=AB7->AB7_CODPRE
      PA1->PA1_ALTERN:=AB7->AB7_CODPRS
      PA1->PA1_DESC:=AB7->AB7_DESENT
      PA1->PA1_DSCALT:=AB7->AB7_DESSAI
      PA1->PA1_SEQ:=.F.
      MsUnLock()  
    endif
    ENDIF
ENDIF  
RestArea(aArea)
Return lOkOP     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450VV  ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Amarracao por carga                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION AT450VV()
Local aArea   := (GetArea())  
lOCAL aPtc:={}
If MsgYesNo("Este Programa tem com objetivo alimentar automaticamente os produtos coligados. Esta regra sera baseada em ordens de servicos. Deseja continuar?","Rotinas Automáticas")
  dbSelectArea("AB7")
  DbSetOrder(1)
  Do while !Eof() 
    dbSelectArea("PA1")
    DbSetOrder(1)
    MsSeek(xFilial("PA1")+AB7->AB7_CODPRE+AB7->AB7_CODPRS)
    IF (!Eof() .And. AB7->AB7_CODPRE == PA1->PA1_PROD .And.;
   	    						AB7->AB7_CODPRS== PA1->PA1_ALTERN)
    ELSE
      IF AB7->AB7_CODPRS<>AB7->AB7_CODPRE
        If MsgYesNo("Deseja amarrar produto -->" + AB7->AB7_CODPRS + " como Pai do Produto -->" + AB7->AB7_CODPRE + " ","Rotinas Automáticas")
          Reclock("PA1",.T.)
          PA1->PA1_PROD:=AB7->AB7_CODPRE
          PA1->PA1_ALTERN:=AB7->AB7_CODPRS
          PA1->PA1_DESC:=AB7->AB7_DESENT
          PA1->PA1_DSCALT:=AB7->AB7_DESSAI
          PA1->PA1_SEQ:=.F.
          MsUnLock()  
        endif
      ENDIF
    ENDIF
    dbSelectArea("AB7")
    dbSkip()
  EndDo
endif
/*
If MsgYesNo("Este Programa tem com objetivo alimentar automaticamente os produtos coligados. Esta regra sera baseada em RANHURAS SIMILARES. Deseja continuar?","Rotinas Automáticas")
  dbSelectArea("SB1")
  DbSetOrder(1)
  aPtc
  for x=1 to len(trim(cCodigo))
   if substr(cCodigo,x,1)="FE" 
     aAdd(aPtc, substr(cCodigo,nPosi,x-1)) 
   nPosi:=x+1
 endif
next
*/
RestArea(aArea)    
Return    

