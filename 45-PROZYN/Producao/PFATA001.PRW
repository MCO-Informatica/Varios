#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA001   ³Autor  ³Henio Brasil        ³ Data ³ 30/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pto Entrada para validar conteudo do prdido momentos antes  º±±
±±º          ³de gerar NF de faturamento                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºChamada   ³MATA410 - Inclusao de Pedido de Vendas                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºEmpresa   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PFATA001(nOpcW) 

Local lReturn 	:= .T.
Local cQryFci	:= ""  
Local cEnvFci	:= "QryFci" 
Local aArea  	:= GetArea() 
Local aAreaC6	:= SC6->(GetArea()) 
Local cPedido	:= SC5->C5_NUM                    
Local dPeriodo	:= Left(Dtos(MonthSub(dDataBase,2)),6) 		// 20180530  Dtos(dDataBase)  
Local cFCIVI    := SuperGetMV("MV_FCIVI",,"")  // Cfop a excluir desta validação
Local cFCIVE    := SuperGetMV("MV_FCIVE",,"")  // Cfop a excluir desta validação 
Local cFCICAME  := SuperGetMV("MV_FCICAME",,"")  // Produtos proveniente da lista de reolucao CAMEX. Exceçao.
//Local cFCICL    := SuperGetMV("MV_FCICL",,"")  // Produtos proveniente da lista de reolucao CAMEX. Exceçao.
Local cFCICL    := ("3/5/8") // origem produtos que deverao calcular FCI os diferentes dessa origem serão liberados. 


Default nOpcW := 0 

/* 
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Tratamento se a Liberacao for pela rotina de liberacao padrao MATA440   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                                             
If FunName()<>"MATA440"  
	Return(.T.)   
Endif 

/* 
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Tratamento se a Liberacao for pela rotina Wizard de Faturamento MATA410 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
If FunName()<>"MATA410C"  
	Return(.T.)   
Endif 

/* 
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Valida o Codigo CFD para validacao de dados da FCI                 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/         
DbSelectArea("SC6")
SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+cPedido))

DbSelectArea("SB1")     
SB1->(DbSetOrder(1))

	While SC6->(!Eof()) .And. SC6->C6_NUM = cPedido
		SB1->(DbSeek(xFilial("SB1")+Alltrim(SC6->C6_PRODUTO)))
	
		If ((AllTrim(SC6->C6_CF) $ cFCIVI) .OR. (AllTrim(SC6->C6_CF) $ cFCIVE)); //Desconsiderar operacoes como Amostra que não precisa validar FCI
		     .AND. (SUBSTRING(SC6->C6_CLASFIS,1,1) $ cFCICL) .AND. SB1->B1_TIPO =='PA'
			 
			 	//Desconsiderar Classificaçõoes com 600, 700, etc  
			    //.AND. (AllTrim(SC6->C6_CLASFIS) $ cFCICL) //Desconsiderar Classificaçõoes com 600, 700, etc
			If !AllTrim(SC6->C6_PRODUTO) $ cFCICAME
		
				cCodPrd	:= Alltrim(SC6->C6_PRODUTO)
				cDesPrd	:= Alltrim(SC6->C6_DESCRI)

				//cQryFci := "SELECT 	TOP 1 SUBSTRING(CFD_PERCAL,3,4)+SUBSTRING(CFD_PERCAL,1,2) as DATATU, CFD_FCICOD AS FCICOD FROM "+RetSqlName("CFD")+ " CFD "
				//cQryFci += " WHERE 	D_E_L_E_T_ = ' ' AND CFD_COD = '"+cCodPrd+"' GROUP BY CFD_FCICOD, SUBSTRING(CFD_PERCAL,3,4)+SUBSTRING(CFD_PERCAL,1,2), CFD_FCICOD "
				//cQryFci += " ORDER 	BY SUBSTRING(CFD_PERCAL,3,4)+SUBSTRING(CFD_PERCAL,1,2) DESC "
				//DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQryFci),cEnvFci,.F.,.F.)


				cQryFci := "SELECT 	TOP 1 SUBSTRING(CFD_PERVEN,3,4)+SUBSTRING(CFD_PERVEN,1,2) as DATATU, CFD_FCICOD AS FCICOD FROM "+RetSqlName("CFD")+ " CFD "
				cQryFci += "INNER JOIN "+RetSqlName("SB1")+ " B1 ON B1_COD  =  CFD_COD "
				cQryFci += " WHERE 	CFD.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' AND B1_TIPO  = 'PA' AND CFD_COD = '"+cCodPrd+"' GROUP BY CFD_FCICOD, SUBSTRING(CFD_PERVEN,3,4)+SUBSTRING(CFD_PERVEN,1,2), CFD_FCICOD "
				cQryFci += " ORDER 	BY SUBSTRING(CFD_PERVEN,3,4)+SUBSTRING(CFD_PERVEN,1,2) DESC "
				DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQryFci),cEnvFci,.F.,.F.)
	
				
				If !(cEnvFci)->(Eof())
	
					If nOpcW <> 1
						If (cEnvFci)->FCICOD <> SC6->C6_FCICOD .OR. ((cEnvFci)->FCICOD == SC6->C6_FCICOD .AND. ((cEnvFci)->DATATU <> dPeriodo .and. (cEnvFci)->DATATU <> Left(Dtos(dDataBase),6) ))
		                	Aviso(ProcName()+" - Atenção!!!","FCI divergente para este item. Verifique!", {"Ok"})
							lReturn := .F.  
							A001Show(cCodPrd,cDesPrd)
						EndIf
					
					Else
						A001Show(cCodPrd,cDesPrd)
					EndIf
					
				Else        
			     	Aviso(ProcName()+" - Atenção!!!","FCI inexistente para este item. Verifique!", {"Ok"})
				    If nOpcW <> 1
		        		lReturn := .F.
					EndIf
				EndIf
				QryFci->(DbCloseArea())
			Else
				If nOpcW == 1
			   		Aviso(ProcName()+" - Atenção!!!","Produto proveniente da lista de resolução CAMEX dispensado da FCI.", {"Ok"})
			    EndIf
			EndIf
			
		Else
		
		 	If nOpcW == 1
        		Aviso(ProcName()+" - Atenção!!!","Esta operação não exige FCI. Verifique!", {"Ok"})
		    EndIf
			
		EndIf
		
	SC6->(DbSkip())

EndDo
 
RestArea(aArea) 
RestArea(aAreaC6) 
Return(lReturn)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A001Show  ³Autor  ³Henio Brasil        ³ Data ³ 30/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pto Entrada para validar conteudo do prdido momentos antes  º±±
±±º          ³de gerar NF de faturamento                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºEmpresa   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A001Show(cCodPrd,cDesPrd) 

Local cQryFci2	:= ""
Local cEnvFci2	:= "QryFci2" 

Local oDlgEd 
Local aVetPrd	:= {} 
Local nOpcC		:= 0           
Define Font oFont2 Name "Ms Sans Serif" Size 0,-9 Bold 

cQryFci2:= "SELECT 	TOP 3 SUBSTRING(CFD_PERVEN,3,4)+SUBSTRING(CFD_PERVEN,1,2) as DATATU, CFD_FCICOD AS FCICOD, CFD_CONIMP, CFD_ORIGEM FROM "+RetSqlName("CFD")+" "
cQryFci2+= " WHERE 	D_E_L_E_T_ = ' ' AND CFD_COD = '"+cCodPrd+"' "
cQryFci2+= " ORDER 	BY SUBSTRING(CFD_PERVEN,3,4)+SUBSTRING(CFD_PERVEN,1,2) DESC "
DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQryFci2),cEnvFci2,.F.,.F.)
If (cEnvFci2)->(!Eof())
	/*
	cMensag	:= "Este item :"+SC6->C6_ITEM+" - "+cCodPrd+" do pedido possui código de FCI divergente ref tabela FCI do sistema."
	cMensag	+= ""+vEnter
	cMensag	+= "Dados Entrados: "+vEnter		*/  
	While (cEnvFci2)->(!Eof())
		// cMensag	+= "Periodo: "+(cEnvFci2)->DATATU+" | Produto: "+(cEnvFci2)->FCICOD+" "+vEnter  
		Aadd(aVetPrd , 	{(cEnvFci2)->DATATU,(cEnvFci2)->FCICOD, AllTrim(Str((cEnvFci2)->CFD_CONIMP)), (cEnvFci2)->CFD_ORIGEM } )  
		(cEnvFci2)->(DbSkip())	
	Enddo 
	// MsgAlert(cMensag,FunName()+" - Validação de FCI") 
Endif
QryFci2->(DbCloseArea()) 

cTraco := Replicate("-",200)
Define MsDialog oDlgEd From 005, 006 To 200,490 Title "Dados da FCI " Pixel 

@ 008, 14 Say	"Produto: "+cCodPrd	Size 055,008 Font oFont2 Of oDlgEd Pixel     
@ 008, 80 Say	"Descric: "+cDesPrd	Size 125,008 Font oFont2 Of oDlgEd Pixel     
@ 012, 14 Say	cTraco		Size 200,08 Font oFont2 Of oDlgEd Pixel     

@ 020, 14 Say	"Periodo " 	Size 055, 08 Font oFont2 Of oDlgEd Pixel  
@ 020, 76 Say	"Cod FCI "	Size 055, 08 Font oFont2 Of oDlgEd Pixel     
@ 020, 188 Say	"% "	Size 055, 08 Font oFont2 Of oDlgEd Pixel     
@ 020, 195 Say	"Orig "	Size 055, 08 Font oFont2 Of oDlgEd Pixel     
@ 024, 14 Say	cTraco		Size 200,08 Font oFont2 Of oDlgEd Pixel     


cDesVet1 := aVetPrd[1][1]+Space(30)+aVetPrd[1][2]+Space(3)+aVetPrd[1][3]+Space(3)+aVetPrd[1][4]
// @ 020,014  MsGet   oCodFci Var cDesVet1 Size  200,08 Pixel Of oDlgEd Picture "@!"  When .F.
@ 032,014  Say   oCodFci Var cDesVet1 Size  200,08 Pixel Of oDlgEd Picture "@!"   
If Len(aVetPrd) > 1                          
	cDesVet2 := aVetPrd[2][1]+Space(30)+aVetPrd[2][2]+Space(3)+aVetPrd[2][3]+Space(3)+aVetPrd[2][4] 
	// @ 035,014  MsGet oCodFci	Var cDesVet2 Size  200,08 Pixel Of oDlgEd Picture "@!"  When .F.
	@ 044,014  Say oCodFci	Var cDesVet2 Size  200,08 Pixel Of oDlgEd Picture "@!"   
Endif               
If Len(aVetPrd) > 2                               
	cDesVet3 := aVetPrd[3][1]+Space(30)+aVetPrd[3][2]+Space(3)+aVetPrd[2][3]+Space(3)+aVetPrd[2][4]
	// @ 050,014  MsGet oCodFci	Var cDesVet3 Size  200,08 Pixel Of oDlgEd Picture "@!"  When .F.
	@ 056,014  Say oCodFci	Var cDesVet3 Size  200,08 Pixel Of oDlgEd Picture "@!"   
Endif 
Define SButton 	From 80,206 Type 1 Action (nOpcC:=1, oDlgEd:End()) Enable Of oDlgEd		// 80,175
// Define SButton 	From 80,206 Type 2 Action (nOpcC:=2, oDlgEd:End()) Enable Of oDlgEd 
Activate MsDialog oDlgEd Centered
Return
