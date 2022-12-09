#INCLUDE "Protheus.ch" 
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410STTS  º Autor ³ Anderson Goncalves º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para a geracao de boletos                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gold Hair                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/        

User Function M410STTS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cQuery 		:= Nil     
Local aArea   		:= GetArea()
Local aAreaC6a 		:= SC6->(GetArea())
Local aAreaC5a 		:= SC5->(GetArea())
Local aAreaC9a 		:= SC9->(GetArea()) 
Local aAreaF4a 		:= SF4->(GetArea()) 
Local aAreaE4a 		:= SE4->(GetArea())
Local aAreaB1a 		:= SB1->(GetArea()) 
Local aAreaB2a 	  	:= SB2->(GetArea()) 
Local aAreaXa2		:= SA2->(GetArea()) 
Local aAreaEE1		:= SE1->(GetArea())
Local nRecSC5	  	:= SC5->(Recno())    
Local oDlgMain		:= Nil  
Local nOpca			:= 0  
Local oOk 	   		:= LoadBitmap( GetResources(), "LBOK"       )
Local oNo 	   		:= LoadBitmap( GetResources(), "LBNO"       )
Private oListPed	:= Nil
Private aListPed	:= {}   
Private nValPed		:= 0  

Public aBoletosPdf	:= {} 
Public aBoetosAnt	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se sera gerado boleto bancario para este pedido            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC5->C5_X_FPAGT == "B"   
   
	If ALTERA .or. INCLUI
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona bancos para o uso em boleto                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT A6_COD, A6_AGENCIA, A6_NUMCON FROM "+RetSqlName("SA6")+" (NOLOCK) "
		cQuery += "WHERE A6_FILIAL = '" + xFilial("SA6") + "' "
		cQuery += "AND A6_XBOLE = 'S' "
		cQuery += "AND D_E_L_E_T_ = ' ' 
		cQuery += "ORDER BY A6_COD, A6_AGENCIA, A6_NUMCON
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o uso do Alias                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Select("QUERY") > 0
			QUERY->(dbCloseArea())
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre o arquivo temporario                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		TcQuery cQuery New Alias "QUERY"
		dbSelectArea("QUERY")
		QUERY->(dbGoTop())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array para selecao do banco                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While QUERY->(!EOF())
		
			aAdd(aListPed,{	.F.,;
							QUERY->A6_COD,;
							QUERY->A6_AGENCIA,;
							QUERY->A6_NUMCON })
							
			QUERY->(dbSkip())
		Enddo   
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha Alias                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		QUERY->(dbCloseArea())   
		
		If Len(aListPed) > 0
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta interface com o usuario                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DEFINE MSDIALOG oDlgMain TITLE OemtoAnsi("Boleto Bancário") FROM 195,188 TO 551,724 PIXEL
		
			@ 007,004 TO 157,261 LABEL " Selecione o banco para a geração do boleto " PIXEL OF oDlgMain
		
			@ 159,183 Button OemtoAnsi("&Ok") 		Size 037,012 PIXEL OF oDlgMain Action( If(TudoOk(),(nOpca:=1,oDlgMain:End()),))
			@ 159,223 Button OemtoAnsi("&Cancela") 	Size 037,012 PIXEL OF oDlgMain Action(oDlgMain:End())
		
			@ 016,007 ListBox oListPed Fields HEADER "","Banco","Agencia","Conta" Size 250,136 Of oDlgMain Pixel ColSizes 30,30,30;
			On DBLCLICK ( AtualMk() , oListPed:Refresh() )
			oListPed:SetArray(aListPed)
			oListPed:bLine := {|| { If(	aListPed[oListPed:nAT,01],oOk,oNo),;
										aListPed[oListPed:nAT,02],;
										aListPed[oListPed:nAT,03],;
										aListPed[oListPed:nAT,04]}}
		
			ACTIVATE MSDIALOG oDlgMain CENTERED 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Geracao do SE1                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nOpcA == 1
				MsgRun("Gerando Titulos, aguarde....","Aguarde...",{|| GeraSE1()}) 
				                                                                    
				dbSelectArea("SE1")
				SE1->(dbSetOrder(1))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Seleciona registros para geracao dos boletos                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cQuery := "SELECT R_E_C_N_O_ RECSE1 FROM "+RetSqlName("SE1")+" (NOLOCK) "
				cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
				cQuery += "AND E1_PREFIXO IS NOT NULL "
				cQuery += "AND E1_NUM = '"+SC5->C5_NUM+"' " 
				cQuery += "AND E1_ORIGEM = 'MATA410' "
				cQuery += "AND D_E_L_E_T_ = ' ' "  
				
				If Select("REGSE1") > 0
					REGSE1->(dbCloseArea())
				EndIf
				
				TcQuery cQuery New Alias "REGSE1"
				
				dbSelectArea("REGSE1")
				REGSE1->(dbGoTop())   
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Geracao dos boletos selecionados                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While REGSE1->(!EOF())
				
					aImpress := U_RFATR01(REGSE1->RECSE1)
					
					If aImpress <> Nil
						If Len(aImpress) > 0
							aAdd(aBoletosPdf,{aImpress[1],aImpress[2]}) 
						EndIf  
					Else
						Return Nil
					EndIf
					
					REGSE1->(dbSkip())
				
				Enddo
				     
				REGSE1->(dbCloseArea())   
				
				If Aviso("M410STTS","Deseja enviar os boletos por e-mail ao cliente?",{"&Sim","&Nao"},2,"WF",,"BMPPERG") == 1 
					For nX := 1 To Len(aBoletosPdf)
						CpyT2S( aBoletosPdf[nX,1], "\spool\", .T. )
					Next nX
					EnvMail(aBoletosPdf)	
				EndIf
				
			EndIf
		Else
		
			Aviso("MT410INC","Não existem bancos selecionados para a conclusão do processo, verifique o cadastro de bancos!",{"&Ok"},2,"Atenção")
			Return Nil
			
		EndIf
	ElseIf !INCLUI .or. !ALTERA
		cQuery := "UPDATE "+RetSqlName("SE1")+ " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
		cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
		cQuery += "AND E1_PREFIXO IS NOT NULL "
		cQuery += "AND E1_NUM = '"+SC5->C5_NUM+"' " 
		cQuery += "AND E1_ORIGEM = 'MATA410' "
		cQuery += "AND D_E_L_E_T_ = ' ' "  
		TcSqlExec(cQuery)
	EndIf
	
EndIf  

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtualMk   º Autor ³ Anderson Goncalves º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza marca da selecao do banco para a geracao de boletoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gold Hair                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/       

Static Function AtualMk() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
Local nX	:= 0

For nX := 1 To Len(aListPed)
	aListPed[nX,1] := .F.
Next nX

aListPed[oListPed:nAt,1] := .T.
oListPed:Refresh()

Return Nil   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraSE1   º Autor ³ Anderson Goncalves º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geracao do registro dentro da tabela SE1                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gold Hair                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/       

Static Function GeraSE1() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
Local nPosBco	:= Ascan(aListPed,{|x| x[1] == .T. })
Local aVenctos	:= {} 
Local cQuery	:= Nil  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona na tabela de bancos                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
dbSelectArea("SA6")
SA6->(dbSetOrder(1))
SA6->(dbSeek(xFilial("SA6")+aListPed[nPosBco,2]+aListPed[nPosBco,3]+aListPed[nPosBco,4] ))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o valor do pedido                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cQuery := "SELECT SUM(C6_VALOR) TOTAL FROM "+RetSqlName("SC6")+" (NOLOCK) "
cQuery += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
cQuery += "AND C6_NUM = '" + SC5->C5_NUM + "' "
cQuery += "AND D_E_L_E_T_ = ' ' "

If Select("QUERY") > 0
	QUERY->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "QUERY"
QUERY->(dbGoTop())    

nValPed := QUERY->TOTAL

QUERY->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna o valor e vencimento dos titulos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVenctos := Condicao((nValPed-(SC5->C5_X_TBO1+SC5->C5_X_TBO2)),SC5->C5_CONDPAG)  

For nY := 1 To 2
	For nX := 1 To Len(aVenctos)   
	
		aCabTit	:= {}
		aCabTit :={	{ "E1_FILIAL"	, xFilial("SE1")				, Nil },;
					{ "E1_PREFIXO"	, If(nY==1,"A  ","UNI")			, Nil },;
					{ "E1_NUM"		, SC5->C5_NUM					, Nil },;
					{ "E1_PARCELA"	, Str(nX,1)			 			, Nil },;
					{ "E1_TIPO"		, "   "    						, Nil },;
					{ "E1_NATUREZ"	, SA1->A1_NATUREZ	 			, Nil },;
					{ "E1_PORTADO"	, " "     		  	   			, Nil },;
					{ "E1_CLIENTE"	, SA1->A1_COD					, Nil },;
					{ "E1_LOJA"   	, SA1->A1_LOJA			 		, Nil },;
					{ "E1_NOMCLI"	, SA1->A1_NREDUZ 		 		, Nil },;
					{ "E1_EMISSAO"	, SC5->C5_EMISSAO		  		, Nil },;
					{ "E1_VENCTO"	, aVenctos[nX,1] 	   			, Nil },;
					{ "E1_VENCREA"	, DataValida(aVenctos[nX,1])	, Nil },;
					{ "E1_VALOR"  	, If(nY == 1,NoRound(aVenctos[nX,2]/2,2),Round(aVenctos[nX,2]/2,2))	, Nil },;
					{ "E1_SALDO"  	, If(nY == 1,NoRound(aVenctos[nX,2]/2,2),Round(aVenctos[nX,2]/2,2))	, Nil },;
					{ "E1_VLCRUZ" 	, If(nY == 1,NoRound(aVenctos[nX,2]/2,2),Round(aVenctos[nX,2]/2,2))	, Nil },;
					{ "E1_MOEDA" 	, 1				      			, Nil },;
					{ "E1_HIST"   	, " "          					, Nil },;
					{ "E1_ORIGEM" 	, "MATA410" 					, Nil },;
					{ "E1_TPSERV"	, "1"		   					, Nil },;
					{ "E1_NUMNOTA"	, ""							, Nil },;
					{ "E1_SERIE"	, ""							, Nil },;  
					{ "E1_PORTADO"	, SA6->A6_COD					, Nil },; 
	     			{ "E1_AGEDEP"  	, SA6->A6_AGENCIA				, Nil },; 
	    			{ "E1_CONTA"   	, SA6->A6_NUMCON   				, Nil }}
	    			
					lMsHelpAuto := .T.
					lMsErroAuto := .F.
					MSExecAuto({|x,y,z| FINA040(x,y,z)},aCabTit,3)
										
					If lMSErroAuto
						MostraErro()
					EndIf
	Next nX
Next nY 

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TudoOk    º Autor ³ Anderson Goncalves º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se foi selecionado algum banco                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gold Hair                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/       

Static Function TudoOk() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Local lRet := Nil  
Local nPos
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se algum banco foi selecionado                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
nPos := Ascan(aListPed,{|x| x[1] == .T.})
If nPos > 0
	lRet := .T.
Else
	lRet := .F.
	Aviso("M410STTS","Selecione pelo menos um registro para continuar!",{"&Ok"},2,"Atenção")
EndIf

Return(lRet)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnvMail   º Autor ³ Anderson Goncalves º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se foi selecionado algum banco                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gold Hair                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/       

Static Function EnvMail(aBoletos) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cEdit1 	:= Space(255)
Local cEdit2 	:= "GoldHair - Boleto(s) Ref. Pedido nº "+SC5->C5_NUM
Local cMemo1 	:= ""
Local oEdit1	:= Nil
Local oEdit2 	:= Nil
Local oMemo1	:= Nil   
Local cHtml		:= ""
Local _oDlg 	:= Nil  
Local cArquivo	:= "" 
Local aArquivo	:= {}

dbSelectArea("SA1")
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI) ))

cEdit1 := AllTrim(SA1->A1_EMAIL)
cEdit1 += Space(255-Len(AllTrim(SA1->A1_EMAIL)))   

For nX := 1 To Len(aBoletos)
	cArquivo += "\spool\"+AllTrim(aBoletos[nX,2])+"; "   
	aAdd(aArquivo,"\spool\"+AllTrim(aBoletos[nX,2]))
Next nX

cArquivo := SubStr(cArquivo,1,Len(cArquivo)-2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta interface com o usuario                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Formulário de Email") FROM 201,182 TO 688,968 PIXEL

@ 004,027 MsGet oEdit1 Var cEdit1 Size 317,009 COLOR CLR_BLACK PIXEL OF _oDlg
@ 004,349 Button OemtoAnsi("&Enviar") Size 037,012 PIXEL OF _oDlg Action(_oDlg:End())
@ 005,004 Say "Para:" Size 014,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 016,027 MsGet oEdit2 Var cEdit2 Size 317,009 COLOR CLR_BLACK PIXEL OF _oDlg
@ 017,004 Say "Assunto:" Size 022,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 030,004 Say "Anexos:" Size 021,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 030,027 Say cArquivo Size 317,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 042,004 Say "Observações" Size 033,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 054,003 GET oMemo1 Var cMemo1 MEMO Of _oDlg MULTILINE Size 383,183 COLORS 0, 16777215 HSCROLL PIXEL 

ACTIVATE MSDIALOG _oDlg CENTERED   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ monta html para corpo de email                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+Chr(13)+Chr(10)
cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">'+Chr(13)+Chr(10)
cHtml += '<head>'+Chr(13)+Chr(10)
cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+Chr(13)+Chr(10)
cHtml += '<title>Boletos</title>'+Chr(13)+Chr(10)
cHtml += '<style type="text/css">'+Chr(13)+Chr(10)
cHtml += '<!--'+Chr(13)+Chr(10)
cHtml += '.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; }'+Chr(13)+Chr(10)
cHtml += '.style8 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; font-style: italic; }'+Chr(13)+Chr(10)
cHtml += '.style9 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; font-style: italic; }'+Chr(13)+Chr(10)
cHtml += '.style10 {color: #896102}'+Chr(13)+Chr(10)
cHtml += '-->'+Chr(13)+Chr(10)
cHtml += '</style>'+Chr(13)+Chr(10)
cHtml += '</head>'+Chr(13)+Chr(10)

cHtml += '<body>'+Chr(13)+Chr(10)
cHtml += '<table width="703" border="0" align="center">'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#F8F6F7"><div align="center"><img src="https://lh5.googleusercontent.com/-4qgdM2r1w6I/UpP6WuBYZgI/AAAAAAAAAQU/RYFAapCN4ug/w440-h157/goldhair.bmp" width="329" height="120" /></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#FFFFFF">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td width="61" bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td width="632" bgcolor="#FFFFFF" class="style7"><div align="justify"><span class="style8">Prezado Cliente,</span></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style7"><div align="justify"><span class="style8">Você esta recebendo em anexo, boleto(s) referente ao pedido de vendas nº <strong>'+SC5->C5_NUM+'</strong>, duvidas ou mairores informações, entrem em contato com o nosso atendimento pelo telefone '+SM0->M0_TEL+'.</span></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8"><div align="justify">Observações:</div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8"><div align="justify">'+cMemo1+'</div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style9"><div align="right" class="style10"></div></td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">Atenciosamente</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style9">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">'+SM0->M0_NOME+'</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#F8F6F7" class="style9"><div align="right"><span class="style10">Workflow by Totvs11 - Gold Hair</span></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '</table>'+Chr(13)+Chr(10)
cHtml += '</body>'+Chr(13)+Chr(10)
cHtml += '</html>   '+Chr(13)+Chr(10)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia para o SendMail                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
Processa({|| U_SndMail2(cEdit1,cEdit2,cHtml,cArquivo,.F.)},"Enviando Email, aguarde...") //Email Destino,Assunto,Texto Html,Anexo,se eh job

Return Nil