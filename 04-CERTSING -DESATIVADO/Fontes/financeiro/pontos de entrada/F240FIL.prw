#INCLUDE 'PROTHEUS.CH' 
#INCLUDE 'RWMAKE.CH'

//------------------------------------------------------------------------------------
/*/{Protheus.doc} F240FIL
Ponto de entrada que realiza o filtro do Bordero atraves do 
	Tipo do Documento selecionado pelo usuario

						  
@return			cFiltro		Retorna a condicao do E2_TIPO com os titulos selecionados						

@author	Douglas Parreja
@since		22/06/2015
@version	11.8
/*/
//------------------------------------------------------------------------------------
User Function F240FIL()
             
	Local aRet		:= {}
	Local aRetorno	:= {}  
	Local nX 		:= 0    
	Local cPerg		:= ""
	Local cFiltro	:= ""
	Local cOpc		:= ""
    Local lOk		:= .F.   

  
	aMvPar := F240ArmMV()
  
	//----------------------------------------------------------
	// Montagem e Validacao da TELA                                                  
	//---------------------------------------------------------- 
	While !lOk    
	
		aRet		:= F240Tela()
		aRetorno 	:= F240Valida( aRet )   
		
		lOk			:= aRetorno[1] 
		cOpc		:= aRetorno[2] 
	
	EndDo

	//----------------------------------------------------------
	// Validacao para realizar o filtro a ser exibido na tela
	// referente aos documentos selecionados                                                 
	//----------------------------------------------------------  
    If lOk .And. Len(aRet) > 0 .And. !Empty(cOpc)
    
		//------------------------------------
		// cOpc=3 Anulando Ponto de Entrada 
	 	//------------------------------------   
	  	If cOpc <> "3"     
	  	
		  	//------------------------------------
			// Botao Seleciona Todos 
		   	//------------------------------------
			If cOpc == "1"	
				aRet := F240MarcTd()   	//retorna com os documentos exibidos na tela   			
			EndIf  
			
			For nX :=1 To Len(aRet[2])                     
				If !Empty(cPerg)
		  			cPerg += "|"
		        EndIf
				cPerg += aRet[2][nX]			                           
			Next
	
			cFiltro := "E2_TIPO $ '"+cPerg+"' 
		 	//Alert(cFiltro) 	// - alert para o usuario verificar o titulo clicado (efeito de teste).
		 EndIf 

	EndIf
                    
	F240AtuMV( aMvPar )
	
Return (cFiltro)   

//----------------------------------------------------------------------------
/*/{Protheus.doc} F240Tela
Funcao responsavel para exibir a tela.

					  						 
@author	Douglas Parreja
@since		22/06/2015
@version	11.8
/*/
//----------------------------------------------------------------------------
Static Function F240Tela()
   
	Local oDlg       
	Local oChk
	Local lChk1    	:= .F.    
	Local lChk2    	:= .F.    
	Local lChk3    	:= .F.    
	Local lChk4    	:= .F. 
	Local lChk5    	:= .F. 
	Local lChk6    	:= .F.     
	Local lChk7    	:= .F.    
	Local lChk8    	:= .F.    
	Local lChk9    	:= .F.    
	Local lChk10	:= .F. 
	Local lChk11    := .F. 
	Local lChk12   	:= .F. 
	Local lChk13    := .F.    
	Local lChk14    := .F.    
	Local lChk15    := .F.    
	Local lChk16    := .F. 
	Local lChk17    := .F. 
	Local lChk18    := .F. 
	Local lChk19    := .F. 
	Local lChk20    := .F. 
	Local lChk21    := .F. 
	Local lChk22    := .F. 
	Local lChk23    := .F. 
	Local lChk24    := .F. 
	Local lChk25    := .F. 
	Local lChk26    := .F. 
	Local lChk27    := .F. 

	Local aTpDoc	:= {}   
	Local aRet		:= {}
	Local cOpcao	:= ""
	
	//+---------------------------------------
	//| Definição da janela e seus conteúdos
	//+---------------------------------------
	DEFINE MSDIALOG oDlg TITLE "Parâmetros Tipo de Documento - F240FIL" FROM 0,0 TO 290,552 OF oDlg PIXEL     
	
	@ 06,06 TO 140,200 LABEL "Selecione abaixo o Tipo do documento que deseja realizar o filtro:" OF oDlg PIXEL	
	
	@ 35, 20 CHECKBOX oChk VAR lChk1 PROMPT "131" SIZE 35,8 PIXEL OF oDlg ;		// 1
			ON CLICK(Iif(lChk1,aAdd(aTpDoc,"131"), "" ))               
	        	         
	@ 35, 50 CHECKBOX oChk VAR lChk2 PROMPT "BEN" SIZE 35,8 PIXEL OF oDlg ;		// 2			
	         ON CLICK(Iif(lChk2,aAdd(aTpDoc,"BEN"), "" ))     
	         
	@ 35, 80 CHECKBOX oChk VAR lChk3 PROMPT "BOL" SIZE 35,8 PIXEL OF oDlg ;		// 3
	         ON CLICK(Iif(lChk3,aAdd(aTpDoc,"BOL"), "" ))    
	          
	@ 35, 110 CHECKBOX oChk VAR lChk4 PROMPT "CH " SIZE 35,8 PIXEL OF oDlg ;	// 4
	         ON CLICK(Iif(lChk4,aAdd(aTpDoc,"CH "), "" ))     

	@ 35, 140 CHECKBOX oChk VAR lChk5 PROMPT "DEV" SIZE 35,8 PIXEL OF oDlg ;	// 5
	         ON CLICK(Iif(lChk5,aAdd(aTpDoc,"DEV"), "" ))     
	         
	@ 35, 170 CHECKBOX oChk VAR lChk6 PROMPT "DP " SIZE 35,8 PIXEL OF oDlg ;	// 6
	         ON CLICK(Iif(lChk6,aAdd(aTpDoc,"DP "), "" ))                       
	         
    //--------------------------------------------------------------------------	                                                                            
	// Linha 2         
    //--------------------------------------------------------------------------
	
	@ 65, 20 CHECKBOX oChk VAR lChk7 PROMPT "FAT" SIZE 35,8 PIXEL OF oDlg ; 	// 1	
	         ON CLICK(Iif(lChk7,aAdd(aTpDoc,"FAT"), "" ))     

   	         
	@ 65, 50 CHECKBOX oChk VAR lChk8 PROMPT "FER" SIZE 35,8 PIXEL OF oDlg ;		// 2
	         ON CLICK(Iif(lChk8,aAdd(aTpDoc,"FER"), "" ))     	
	         
	@ 65, 80 CHECKBOX oChk VAR lChk9 PROMPT "FOL" SIZE 35,8 PIXEL OF oDlg ;		// 3
	         ON CLICK(Iif(lChk9,aAdd(aTpDoc,"FOL"), "" ))     
	         	         	         	         	         	         	         	         
	@ 65, 110 CHECKBOX oChk VAR lChk10 PROMPT "FT " SIZE 35,8 PIXEL OF oDlg ;	// 4
	         ON CLICK(Iif(lChk10,aAdd(aTpDoc,"FT "), "" )) 

	@ 65, 140 CHECKBOX oChk VAR lChk11 PROMPT "INS" SIZE 35,8 PIXEL OF oDlg ;	// 5
	         ON CLICK(Iif(lChk11,aAdd(aTpDoc,"INS"), "" )) 
	         
	@ 65, 170 CHECKBOX oChk VAR lChk12 PROMPT "IR " SIZE 35,8 PIXEL OF oDlg ;	// 6
	         ON CLICK(Iif(lChk12,aAdd(aTpDoc,"IR "), "" ))               
	            
    //--------------------------------------------------------------------------	         
	// Linha 3                                                                  
    //--------------------------------------------------------------------------
	         
	@ 95, 20 CHECKBOX oChk VAR lChk13 PROMPT "IRF" SIZE 35,8 PIXEL OF oDlg ;	// 1
	         ON CLICK(Iif(lChk13,aAdd(aTpDoc,"IRF"), "" )) 
	         
	@ 95, 50 CHECKBOX oChk VAR lChk14 PROMPT "IS " SIZE 35,8 PIXEL OF oDlg ;	// 2
	         ON CLICK(Iif(lChk14,aAdd(aTpDoc,"IS "), "" )) 
	         
	@ 95, 80 CHECKBOX oChk VAR lChk15 PROMPT "ISS" SIZE 35,8 PIXEL OF oDlg ;	// 3
	         ON CLICK(Iif(lChk15,aAdd(aTpDoc,"ISS"), "" )) 

	@ 95, 110 CHECKBOX oChk VAR lChk16 PROMPT "NF " SIZE 35,8 PIXEL OF oDlg ;	// 4
	         ON CLICK(Iif(lChk16,aAdd(aTpDoc,"NF "), "" )) 
	         
	@ 95, 140 CHECKBOX oChk VAR lChk17 PROMPT "PA " SIZE 35,8 PIXEL OF oDlg ;	// 5
	         ON CLICK(Iif(lChk17,aAdd(aTpDoc,"PA "), "" )) 	         
	                                                      
	@ 95, 170 CHECKBOX oChk VAR lChk18 PROMPT "PEN" SIZE 35,8 PIXEL OF oDlg ;	// 6
	         ON CLICK(Iif(lChk18,aAdd(aTpDoc,"PEN"), "" )) 
	         
    //--------------------------------------------------------------------------
	// Linha 4
    //--------------------------------------------------------------------------  
    		         
	@ 125, 20 CHECKBOX oChk VAR lChk19 PROMPT "PI " SIZE 35,8 PIXEL OF oDlg ;	// 1
	         ON CLICK(Iif(lChk19,aAdd(aTpDoc,"PI "), "" )) 
	         
	@ 125, 50 CHECKBOX oChk VAR lChk20 PROMPT "PIS" SIZE 35,8 PIXEL OF oDlg ;	// 2
	         ON CLICK(Iif(lChk20,aAdd(aTpDoc,"PIS"), "" )) 
	         
	@ 125, 80 CHECKBOX oChk VAR lChk21 PROMPT "RC " SIZE 35,8 PIXEL OF oDlg ;	// 3
	         ON CLICK(Iif(lChk21,aAdd(aTpDoc,"RC "), "" )) 
	         
	@ 125, 110 CHECKBOX oChk VAR lChk22 PROMPT "RES" SIZE 35,8 PIXEL OF oDlg ;	// 4
	         ON CLICK(Iif(lChk22,aAdd(aTpDoc,"RES"), "" )) 
	         
	@ 125, 140 CHECKBOX oChk VAR lChk23 PROMPT "TF " SIZE 35,8 PIXEL OF oDlg ;	// 5
	         ON CLICK(Iif(lChk23,aAdd(aTpDoc,"TF "), "" )) 
	         
	@ 125, 170 CHECKBOX oChk VAR lChk24 PROMPT "TX " SIZE 35,8 PIXEL OF oDlg ;	// 6
	         ON CLICK(Iif(lChk24,aAdd(aTpDoc,"TX "), "" )) 	         	         	         	         	         	         	                 	         	         	         	         

	//--------------------------------------------------------------------------
	// Botões
    //-------------------------------------------------------------------------- 	         
	         	      	         
	@ 040,235 BUTTON "&Marcar todos"   	SIZE 36,16 PIXEL ACTION (cOpcao:="1",oDlg:End())	                                           
	@ 100,235 BUTTON "&Ok"       		SIZE 36,16 PIXEL ACTION (cOpcao:="2",oDlg:End())
	@ 120,235 BUTTON "&Cancelar" 		SIZE 36,16 PIXEL ACTION (cOpcao:="3",IIf(msgyesno("Deseja anular o Ponto de entrada?","Tipo de Documento PEF240FIL"),oDlg:End(),(cOpcao:="4",oDlg:End())))   

	ACTIVATE MSDIALOG oDlg CENTER

	aAdd(aRet,cOpcao)                          
	aAdd(aRet,aTpDoc)

Return aRet

//----------------------------------------------------------------------------
/*/{Protheus.doc} F240Valida
Funcao responsavel para validar se foi marcado o tipo do documento e qual
operacao que esta sendo realizada.

					  						 
@author	Douglas Parreja
@since		22/06/2015
@version	11.8
/*/
//----------------------------------------------------------------------------
Static Function F240Valida( aRet )
    
	Local cOpc	 	:= ""
	Local aRetVal 	:= {}
	Local lRet		     
	Default aRet	:= {}
	
	If Len(aRet) > 0
	                  
		If Len(aRet[1]) > 0 
			cOpc := aRet[1]		// Qual operacao do botao foi realizada 
							
			If !empty(cOpc) 

				//-------------------------------------------------------------------------------------
				// cOPc=4	(Cancela 'Nao' - Deseja voltar para a tela e selecionar tipo do documento)   
				//-------------------------------------------------------------------------------------
				If cOpc == "4" 
					lRet := .F. 
				//---------------------
				// cOpc=2	(Ok)	   
				//---------------------			
				ElseIf cOpc == "2"
					If Len(aRet[2]) > 0   	
						lRet := .T.			//Tem registro selecionado
					Else
				   		msgAlert("Não informado nenhum tipo de Documento, por favor selecione.","Tipo de Documento PEF240FIL")  
				   		lRet := .F. 
					EndIf
				//-------------------------------------------------------------------------------------
				// cOpc=1 	(Selecionado todos)
				// cOpc = 3	(Cancela 'Sim' - Deseja anular ponto de entrada (padrao))     
				//-------------------------------------------------------------------------------------
				Else	
					lRet := .T.    
					
				EndIf
			EndIf
		EndIf
	EndIf 

	aAdd(aRetVal, lRet)
	aAdd(aRetVal, cOpc)
								
Return aRetVal

//----------------------------------------------------------------------------
/*/{Protheus.doc} F240MarcTd
Funcao responsavel para retornar o array contendo todos os tipos de documentos.

Obs.: Na tela é somente exibido e validado quando usuário clicar 
em cada checkbox.

					  						 
@author	Douglas Parreja
@since		22/06/2015
@version	11.8
/*/
//----------------------------------------------------------------------------
Static Function F240MarcTd()

	Local aTpDoc  := {}
	Local aRetDoc := {}
	
	aAdd(aTpDoc,"131")
	aAdd(aTpDoc,"BEN")
	aAdd(aTpDoc,"BOL")
	aAdd(aTpDoc,"CH ")
	aAdd(aTpDoc,"DEV")
	aAdd(aTpDoc,"DP ")
	aAdd(aTpDoc,"FAT")
	aAdd(aTpDoc,"FER")
	aAdd(aTpDoc,"FOL")
	aAdd(aTpDoc,"FT ")
	aAdd(aTpDoc,"INS")
	aAdd(aTpDoc,"IR ")
	aAdd(aTpDoc,"IRF")
	aAdd(aTpDoc,"IS ")
	aAdd(aTpDoc,"ISS")
	aAdd(aTpDoc,"NF ")
	aAdd(aTpDoc,"PA ")
	aAdd(aTpDoc,"PEN")
	aAdd(aTpDoc,"PI ")
	aAdd(aTpDoc,"PIS")
	aAdd(aTpDoc,"RC ")
	aAdd(aTpDoc,"RES")
	aAdd(aTpDoc,"TF ")
	aAdd(aTpDoc,"TX ")

	//----------------------------------------------------------	 
	// Retornar no mesmo padrao da funcao F240Tela
	//---------------------------------------------------------- 
	aAdd(aRetDoc,"")
	aAdd(aRetDoc,aTpDoc)

Return aRetDoc  

//----------------------------------------------------------------------------
/*/{Protheus.doc} F240ArmMV
Funcao responsavel para armazenar em array os valores do MV_PAR

Obs.: Realizado essa funcao porque o Parambox apos executado ele sobrepoem 
mv_par com o que foi executado e ao retornar para o FINA240 exibe erro.


						  
@return			aMvPar		Retorno contendo os valores do MV_PAR 
							 
@author	Douglas Parreja
@since		18/06/2015
@version	11.8
/*/
//----------------------------------------------------------------------------
Static Function F240ArmMV()

	Local aMvPar := {}
    
	aAdd(aMvPar,M->MV_PAR01) 
	aAdd(aMvPar,M->MV_PAR02) 
	aAdd(aMvPar,M->MV_PAR03) 
	aAdd(aMvPar,M->MV_PAR04) 
	aAdd(aMvPar,M->MV_PAR05) 
	aAdd(aMvPar,M->MV_PAR06) 
	aAdd(aMvPar,M->MV_PAR07) 
	aAdd(aMvPar,M->MV_PAR08) 
	aAdd(aMvPar,M->MV_PAR09) 
	aAdd(aMvPar,M->MV_PAR10) 
	aAdd(aMvPar,M->MV_PAR11) 
	aAdd(aMvPar,M->MV_PAR12) 
	aAdd(aMvPar,M->MV_PAR13) 
	aAdd(aMvPar,M->MV_PAR14) 
	aAdd(aMvPar,M->MV_PAR15) 

Return aMvPar

//----------------------------------------------------------------------------
/*/{Protheus.doc} F240AtuMV
Funcao responsavel para atualizar o MV_PAR após execução do Parambox.

Obs.: Realizado essa funcao porque o Parambox apos executado ele sobrepoem 
mv_par com o que foi executado e ao retornar para o FINA240 exibe erro.

						  						 
@author	Douglas Parreja
@since		18/06/2015
@version	11.8
/*/
//----------------------------------------------------------------------------
Static Function F240AtuMV( aMvPar )

	Default aMvPar := {}
    
    If Len(aMvPar) > 0               
		mv_par01 := aMvPar[1]
		mv_par02 := aMvPar[2]
		mv_par03 := aMvPar[3]
		mv_par04 := aMvPar[4]
		mv_par05 := aMvPar[5]
		mv_par06 := aMvPar[6]
		mv_par07 := aMvPar[7]
		mv_par08 := aMvPar[8]
		mv_par09 := aMvPar[9]
		mv_par10 := aMvPar[10]
		mv_par11 := aMvPar[11]
		mv_par12 := aMvPar[12]
		mv_par13 := aMvPar[13]
		mv_par14 := aMvPar[14]
		mv_par15 := aMvPar[15]

	EndIf
	
Return                      



