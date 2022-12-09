#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFIN002   ºAutor  ³Alexandre Sousa     º Data ³  05/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Estrutura para cadastro e manutencao de grupos de naturezas º±±
±±º          ³Utilizado no fluxo de caixa.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico clientes ACTUAL TREND - www.actualtrend.com.br   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AFIN002()
      
	Local aArea     := GetArea()
	Local aSizeAut  := MsAdvSize( .F. )
	Local aObjects  := {}
	Local aInfo     := {} 
	Local aObj      := {}  
	Local cDesc     := ""
	Local cChave    := ""
	Local cCampo    := ""
	Local cConteudo := ""
	Local cSeek     := ""
	Local cLast     := ""
	Local cTitulo   := ""
	Local cQuery    := ""
	LOCAL cVar      := ""                     
	LOCAL cMainPref := "" 
	Local nX        := 0
	Local nY        := 0
	Local nOpca     := 0       
	Local oDlg
	Local oTree
	Local oMenu
	Local oCombo 
	Local oOpc            

	Private cCadastro	:= OemToAnsi("Estrutura de Naturezas")
	Private lVisual		:= .F.
	Private lVis		:= .T.
	Private cStartGroup	:= "MAINGR" 
	Private lVisual		:= .F.
	Private aGrupoAtu	:= {}
	Private aGrupoExc	:= {}                   
	Private aGrupoBmp	:= { "FOLDER5", "FOLDER6" }
	Private lMoved		:= .F. 

	cTreeSeek		:= ""
	cStartGroup		:= "MAINGR"
	cMainPref		:= If( cStartGroup == "MAINGR", "0MA", "2GR" ) 
	aGrupoBmp		:= { "BMPGROUP", "BMPGROUP" } 

	AAdd( aObjects, { 100, 100, .T., .T. } ) 
	AAdd( aObjects, {  70, 100, .F., .T. } ) 
	aInfo := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 } 
	aObj  := MsObjSize( aInfo, aObjects, , .T. ) 

	DEFINE MSDIALOG oDlg FROM aSizeAut[7],00 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL 

	oTree := DbTree():New( aObj[1,1], aObj[1,2], aObj[1,3], aObj[1,4],oDlg,,,.T.)
	oTree:AddItem( PADR( "Estrutura de Naturezas para Fluxo", 100 ), "0MA-MAINGR", "FOLDER5","FOLDER5",,,2) //

	@ aObj[2,1] - 1, aObj[2,2] TO aObj[2,3], aObj[2,4] PIXEL 
         
	nLin := aObj[2,1] +  8 
	nCol := aObj[2,2] + 10 
	 
	MENU oMenu POPUP 
		MENUITEM "Anexa Natureza"	Action FT070Menu( @oTree, "INCRP", oMenu )
		MENUITEM "Exclui Natureza"	Action FT070Menu( @oTree, "EXCRP", oMenu )
		MENUITEM "Visualiza" 		Action FT070Menu( @oTree, "VISUA", oMenu )
		MENUITEM "Anexa grupo"		Action FT070Menu( @oTree, "INCGR", oMenu )
		MENUITEM "Exclui grupo"		Action FT070Menu( @oTree, "EXCGR", oMenu )
		MENUITEM "Pesquisa"			Action FT070Pesq( @oTree )
	ENDMENU
	
	oTree:bRClicked  := { |o,x,y| FT070MAct( o, x, y, oMenu ) } // Posição x,y em relação a Dialog 

	@ aObj[2,1] + 24, aObj[2,4] - 32 BUTTON oOpc PROMPT "Opcoes" ACTION FT070MAct( oTree, oOpc:nRight - 5, oOpc:nTop - 118, oMenu ) SIZE 27, 12 OF oDlg PIXEL
	@ aObj[2,1] + 40, aObj[2,4] - 32 BUTTON oOpc PROMPT "Naturezas" ACTION FManNat() SIZE 27, 12 OF oDlg PIXEL
	@ aObj[2,1] + 55, aObj[2,4] - 32 BUTTON oOpc PROMPT "Grupos"	 ACTION FManGRp() SIZE 27, 12 OF oDlg PIXEL

	DEFINE SBUTTON FROM aObj[2,1] + 7, aObj[2,4] - 65 TYPE 1 ENABLE OF oDlg ACTION ( nOpca := 1, oDlg:End() )
	DEFINE SBUTTON FROM aObj[2,1] + 7, aObj[2,4] - 33 TYPE 2 ENABLE OF oDlg ACTION ( nOpca := 0, oDlg:End() )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a rotina de construcao do Tree                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa( { || FT070Monta( @oTree, cStartGroup ) }, ,"Construindo estrutura..." )  //
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no usuario desejado                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( cTreeSeek ) 
		oTree:TreeSeek( "1US-" + cTreeSeek ) 
	EndIf 	

	ACTIVATE MSDIALOG oDlg ON INIT Eval(oTree:bChange)

	If nOpca == 1 .And. !lVisual 
		FT070Grava() 
	EndIf	

	RestArea(aArea)
	
Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FManNat   ºAutor  ³Alexandre Sousa     º Data ³  07/31/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao das naturezas                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FManNat()

	AxCadastro("PCX")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FManGRp   ºAutor  ³Alexandre Sousa     º Data ³  07/31/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao dos grupos.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FManGRp()

	AxCadastro("PCV")
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft070Menu ³ Autor ³ Sergio Silveira       ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acoes efetuadas pelo menu                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FT070Menu( ExpO1, ExpC1, ExpO2 )                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto Tree / ExpC1 -> Acao a ser efetuada        ³±±
±±³          ³ ExpO2 -> Objeto Menu                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ft070Menu( oTree, cAction, oMenu )

LOCAL cDesc        := ""
LOCAL cCargo       := ""
LOCAL nScan        := 0     
LOCAL nDeleted     := 0     
LOCAL nLoop        := 0 
LOCAL lFound       := .F.
                                                 
PRIVATE aRotina 
PRIVATE aGrpTmpExc := {} 
PRIVATE Inclui     := .T. // Nao retirar

Do Case 
Case cAction == "INCRP"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclusao do representante                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ConPad1( , , , "PCX" , , , .F. ) 
	
		cCargo := oTree:GetCargo() 
		lFound := oTree:TreeSeek( "1US-" + PCX->PCX_NATUR ) 
		
		oTree:TreeSeek( cCargo )
		                        
		If lFound
			Aviso( "Atencao", "A natureza '" + AllTrim( PCX->PCX_NATUR + "-" + ; //###
					 PCX->PCX_DESC ) + "' ja esta na estrutura !", { "Ok" }, 2 ) //###
		Else                       
		
			If Aviso( "Atencao", "Confirma a inclusao da natureza '" + AllTrim( PCX->PCX_NATUR + "-" + ; //###
					 PCX->PCX_DESC ) + "' ?", { "Sim", "Nao" }, 2 ) == 1  //"Sim"###"Nao"
	
				cDesc := PadR( PCX->PCX_NATUR + "-" + Capital( PCX->PCX_DESC ), 100 ) 
				oTree:AddItem( cDesc, "1US-" + PCX->PCX_NATUR,"BMPUSER","BMPUSER",,,2)   
				oTree:Refresh()
				
				cGrupo := SubStr( cCargo, 5, Len( PCV->PCV_GRPNAT ) )                           
				 
				FT070IncRep( cCargo, PCX->PCX_NATUR )  
			    
			EndIf			
		EndIf 

	EndIf
		
Case cAction == "VISUA"	

	cCargo := oTree:GetCargo()                       

	If Left( cCargo, 3 ) == "1US"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Visualizacao do natureza                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRotina := { { "Pesquisar","AxPesqui"  , 0 , 1},;  // //
					{ "Visualizar","AxVisual"  , 0 , 2} }  // //
		                
		PCX->( dbSetOrder( 1 ) ) //PCX_FILIAL, PCX_NATUR, R_E_C_N_O_, D_E_L_E_T_
	
		If PCX->( MsSeek( xFilial( "PCX" ) + SubStr( cCargo, 5, Len( PCX->PCX_NATUR ) ) ) )  
			AxVisual( "PCX", PCX->( Recno() ), 2 )	
		EndIf 
		
	ElseIf Left( cCargo, 3 ) == "2GR"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Visualizacao do Grupo                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRotina := { { "Pesquisar","AxPesqui"  , 0 , 1},;  // //
					{ "Visualizar","AxVisual"  , 0 , 2} }  // //
		                
		PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
		If PCV->( MsSeek( xFilial( "PCV" ) + SubStr( cCargo, 5, Len( PCV->PCV_GRPNAT ) ) ) )  
			AxVisual( "PCV", PCV->( Recno() ), 2 )	
		EndIf 
	
	EndIf 		
			
Case cAction == "EXCRP"

	cCargo := oTree:GetCargo() 
	PCX->( dbSetOrder( 1 ) )  //PCX_FILIAL, PCX_NATUR, R_E_C_N_O_, D_E_L_E_T_
	PCX->( MsSeek( xFilial( "PCX" ) + SubStr( cCargo, 5, Len( PCX->PCX_NATUR ) ) ) )   
	
	If Aviso( "Atencao", "Confirma a exclusao da natureza '" + AllTrim( PCX->PCX_NATUR + "-" + ; //###
		 PCX->PCX_DESC ) + "' ?", { "Sim", "Nao" }, 2 ) == 1  //"Sim"###"Nao"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclusao da natureza                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTree:DelItem() 	
		oTree:Refresh()		                    
		
		FT070ExcRep( cCargo, PCX->PCX_NATUR )  
		
	EndIf	
Case cAction == "EXCGR"                                              

	cCargo := oTree:GetCargo() 
	PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
	
	cGrupoExc := SubStr( cCargo, 5, Len( PCV->PCV_GRPNAT ) ) 
	PCV->( MsSeek( xFilial( "PCV" ) + cGrupoExc ) )   

	If Aviso( "Atencao", "Confirma a exclusa do Grupo '" + AllTrim( PCV->PCV_GRPNAT + "-" + ; //###
			 PCV->PCV_DESC ) + "STR0028", { "Sim", "Nao" }, 2 ) == 1  //"' ?"###"Sim"###"Nao"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclusao do Grupo                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTree:DelItem() 	
		oTree:Refresh()		
		                 
		aGrpTmpExc := {}                              
		
		FT070ExcGrp( cGrupoExc ) 
		
		nDeleted := 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui do grupo atual os grupos do array de exclusao         ³
		//³ temporario                                                   ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLoop := 1 To Len( aGrpTmpExc ) 
			If !( Empty( nScan := AScan( aGrupoAtu, { |x| x[1] == aGrpTmpExc[ nLoop ] } ) ) ) 
				ADel( aGrupoAtu, nScan ) 		
				nDeleted++ 
			EndIf 		
		Next nLoop
		
		ASize( aGrupoAtu, Len( aGrupoAtu ) - nDeleted ) 
		aGrpTmpExc := {} 
		
	EndIf		
Case cAction == "INCGR" 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclusao do Grupo                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ConPad1( ,,,"PCV", , , .F. ) 
	
		cCargo := oTree:GetCargo() 
		lFound := oTree:TreeSeek( "2GR-" + PCV->PCV_GRPNAT ) 
		
		oTree:TreeSeek( cCargo )
		                        
		If lFound
			Aviso( "Atencao", "O grupo '" + AllTrim( PCV->PCV_GRPNAT + "-" + ; //###
					 PCV->PCV_DESC ) + "' ja esta na estrutura !", { "Ok" }, 2 )  //###
		Else 
		
			If Aviso( "Atencao", "Atencao" + AllTrim( PCV->PCV_GRPNAT + "-" + ; //###
					 PCV->PCV_DESC ) + "' ?", { "Sim", "Nao" }, 2 ) == 1  //"Sim"###"Nao"
				cDesc := PadR( PCV->PCV_GRPNAT + "-" + Capital( PCV->PCV_DESC ), 100 ) 
				oTree:AddItem( cDesc, "2GR-" + PCV->PCV_GRPNAT, aGrupoBmp[1],aGrupoBmp[2],,,2) 
				oTree:TreeSeek( "2GR-" + PCV->PCV_GRPNAT ) 
				oTree:Refresh() 
				
				FT070IncGrp( cCargo, PCV->PCV_GRPNAT ) 
				
			EndIf
		EndIf
	
	EndIf 
	
Case cAction == "VISGR" 	 		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Visualizacao do Grupo                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRotina := { { "Pesquisar","AxPesqui"  , 0 , 1},;  // //
				{ "Visualizar","AxVisual"  , 0 , 2} }  // //
	                
	PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
	cCargo := oTree:GetCargo() 
	If PCV->( MsSeek( xFilial( "PCV" ) + SubStr( cCargo, 5, Len( PCV->PCV_GRPNAT ) ) ) )  
		AxVisual( "PCV", PCV->( Recno() ), 2 )	
	EndIf         
	
Case cAction == "RESET"	
	oTree:Reset()
EndCase 

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft070Chang³ Autor ³ Sergio Silveira       ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da TudoOk                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ft070Change( oTree ) 

cLast := oTree:GetCargo() 

Return( .T. )         
                                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070MAct ³ Autor ³ Sergio Silveira       ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de chamada do menu                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FT070MAct( ExpO1, ExpN1, ExpN2, ExpO2 )                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto Tree / ExpN1 -> Dimensao X                 ³±±
±±³          ³ ExpN2 -> Dimensao Y  / ExpO2 -> Objeto Menu                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                              
Static Function FT070MAct( oTree, nX, nY, oMenu )                               
                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desabilita todos os itens do menu                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AEval( oMenu:aItems, { |x| x:Disable() } ) 

cCargo := oTree:GetCargo() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilita as opcoes de acordo com a entidade do tree          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Left( cCargo, 3 ) == "1US"
	oMenu:aItems[3]:enable()  
	If !lVisual
		oMenu:aItems[2]:enable()  		
	EndIf 	
ElseIf Left( cCargo, 3 ) == "2GR"
	oMenu:aItems[3]:enable()  	
	If !lVisual 	
		oMenu:aItems[1]:enable()  
		oMenu:aItems[4]:enable()  
		oMenu:aItems[5]:enable()  	
	EndIf 	
ElseIf Left( cCargo, 3 ) == "0MA"
	If !lVisual 
		oMenu:aItems[4]:enable()  
	EndIf 	
EndIf 

oMenu:aItems[6]:enable() 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa o Menu PopUp                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMenu:Activate( nX, nY, oTree )
                                   
Return()   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070Pesq ³ Autor ³ Sergio Silveira       ³ Data ³14/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisa por entidades no Tree                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FT070Pesq( oTree )                                                       

LOCAL aItems     := {} 
LOCAL aSeek      := {} 

LOCAL cChavePesq := Space( 20 )        
LOCAL cChave     := Space( 20 )        		
LOCAL cVar       := ""

LOCAL nCombo     := 1 
LOCAL nOpca      := 0 

LOCAL oCombo          
LOCAL oDlg   
LOCAL oBut1 
LOCAL oBut2 
LOCAL oGetPesq 

AAdd( aItems, "Natureza" )
AAdd( aItems, "Grupo"    )

AAdd( aSeek, { "1US", 1, "@R XXXXXX", "Natureza", "PCX" } )
AAdd( aSeek, { "2GR", 1, "@R XXXXXX", "Grupo", "PCV" } )

DEFINE MSDIALOG oDlg TITLE CCADASTRO FROM 09,0 TO 21.2,43.5 OF oMainWnd

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
@   0, 0 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 30, 120 NOBORDER WHEN .F. PIXEL

@ 03, 40 SAY "STR0033"  FONT oBold PIXEL // "Pesquisar entidade" 

@ 14, 30 TO 16 ,400 LABEL '' OF oDlg   PIXEL

@ 23, 40 SAY "STR0034" SIZE 40, 09 PIXEL //"Entidade"
@ 23, 80 COMBOBOX oCombo VAR cVar ITEMS aItems SIZE 80, 10 OF oDlg PIXEL 
                                                      
@ 35, 40 SAY "STR0035"  SIZE 40, 09    PIXEL //"Chave "
@ 35, 80 MSGET oGetPesq1 VAR cChave WHEN .F. SIZE 80, 10 VALID .T. PIXEL 

@ 48, 40 SAY "STR0036" SIZE 40, 09    PIXEL //"Pesquisa "
@ 48, 80 MSGET oGetPesq VAR cChavePesq SIZE 80, 10 VALID .T. PIXEL F3 "XYZZYZ"

oGetPesq:bGotFocus := { || oGetPesq:oGet:Picture := aSeek[ oCombo:nAt, 3 ],;
		 cChave := aSeek[ oCombo:nAt, 4 ], oGetPesq:cF3 := aSeek[ oCombo:nAt, 5 ],;
		 oGetPesq1:Refresh() }   

DEFINE SBUTTON oBut1 FROM 67,  99  TYPE 1 ACTION ( nOpca := 1, nCombo := oCombo:nAt,;
		oDlg:End() ) ENABLE of oDlg

DEFINE SBUTTON oBut2 FROM 67, 132   TYPE 2 ACTION ( nOpca := 0,;
		oDlg:End() ) ENABLE of oDlg

ACTIVATE MSDIALOG oDlg CENTERED  
 
If nOpca == 1
	cChavePesq := RTRIM( cChavePesq ) 
	If !oTree:TreeSeek( aSeek[ nCombo, 1 ] + "-" + cChavePesq ) 
		Aviso( "STR0037", "STR0038", { "STR0022" } )  //"Atencao !"###"Entidade nao encontrada !"###"Ok"
	EndIf 
EndIf 

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070IncGrp³ Autor ³ Sergio Silveira      ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um grupo nos arrays de controle                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FT070IncGrp( cCargo, cGrupoNovo )

Local cGrupoSup := SubStr( cCargo, 5, Len( PCV->PCV_GRPNAT ) ) 
Local nScan     := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona ao array de grupos atuais                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( nScan := AScan( aGrupoAtu, { |x| x[1] == cGrupoNovo } )  ) 
	AAdd( aGrupoAtu, { cGrupoNovo, cGrupoSup, {}, {}, {} } ) 
Else
	Aviso( "STR0037", "STR0039", { "STR0022" } )    //"Atencao !"###"Inconsistencia no Array de Trabalho !"###"Ok"
EndIf 

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070ExcGrp³ Autor ³ Sergio Silveira      ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclui grupos dos arrays de controle                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FT070ExcGrp( cGrupoExc )

Local aBackGrpAtu  := AClone( aGrupoAtu ) 

Local cGrpExcRec := ""
Local cGrpSupRec := ""
Local nScanGrp  := 0 
Local nScanSup  := 0
Local nLoop     := 0  

nScanGrp := AScan( aGrupoAtu, { |x| x[1] == cGrupoExc } ) 

If Empty( nScanGrp ) 
	Aviso( "STR0037", "STR0039", { "STR0022" } )    //"Atencao !"###"Inconsistencia no Array de Trabalho !"###"Ok"
Else                         

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui no array de exclusao temporaria                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                              
	AAdd( aGrpTmpExc, cGrupoExc ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona ao grupo de excluidos                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( AScan( aGrupoExc, cGrupoExc ) ) 
		AAdd( aGrupoExc, cGrupoExc ) 	
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se outros grupos estavam abaixo deste e os exclui tambem ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ASort( aGrupoAtu,,, { |x,y| y[2] > x[2] } )  

	If !Empty( nScanSup := AScan( aGrupoAtu, { |x| x[2] == cGrupoExc } ) ) 
		For nLoop := nScanSup To Len( aGrupoAtu ) 
			If aGrupoAtu[ nLoop, 2 ] <> cGrupoExc .Or. Empty( aGrupoAtu[ nLoop, 2 ] ) 
				Exit			
		    EndIf
		    cGrpExcRec := aGrupoAtu[ nLoop,1 ] 
		    FT070ExcGrp( cGrpExcRec ) 
		Next nLoop	
	EndIf
EndIf
    
aGrupoAtu := aClone( aBackGrpAtu ) 

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070IncRep³ Autor ³ Sergio Silveira      ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui as naturezas nos arrays de controle                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FT070IncRep( cCargo, cRepres ) 

Local nScanGrp  := 0 
Local cGrupoAtu := SubStr( cCargo, 5, Len( PCV->PCV_GRPNAT ) ) 

If Empty( nScanGrp := AScan( aGrupoAtu, { |x| x[1] == cGrupoAtu } ) )
	Aviso( "STR0037", "STR0039", { "STR0022" } )    //"Atencao !"###"Inconsistencia no Array de Trabalho !"###"Ok"
Else                                                  
      
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui do array de excluidos deste grupo ( se existir )           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( nScanRepExc := AScan( aGrupoAtu[ nScanGrp, 4 ], cRepres ) )
		ADEL( aGrupoAtu[ nScanGrp, 4 ], nScanRepExc ) 	
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui no array de incluidos                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( nScanRepInc := AScan( aGrupoAtu[ nScanGrp, 3 ], cRepres ) )
		AADD( aGrupoAtu[ nScanGrp, 3 ], cRepres ) 	
	EndIf

EndIf 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070ExcRep³ Autor ³ Sergio Silveira      ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclui as nautrezas dos arrays de controle                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FT070ExcRep( cCargo, cRepres ) 
                        


Local nScanGrp     := 0                  
Local nScanRepInc  := 0 
Local nScanRepAtu  := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa primeiro o grupo no array de atuais                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nScanGrp := AScan( aGrupoAtu, { |x| !Empty( nScanRepInc := AScan( x[5], cRepres ) ) } ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao achar, pesquisa no de incluidos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( nScanGrp ) 
	nScanGrp := AScan( aGrupoAtu, { |x| !Empty( nScanRepInc := AScan( x[3], cRepres ) ) } )  
EndIf 

If !Empty( nScanGrp ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga do array incluidos                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( nScanRepInc := AScan( aGrupoAtu[ nScanGrp, 3 ], cRepres ) ) 
		ADEL( aGrupoAtu[ nScanGrp, 3 ], nScanRepInc ) 	
	EndIf 		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga do array atuais                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( nScanRepAtu := AScan( aGrupoAtu[ nScanGrp, 5 ], cRepres ) ) 
		ADEL( aGrupoAtu[ nScanGrp, 5 ], nScanRepAtu ) 	
	EndIf 		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui no array excluidos                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( AScan( aGrupoAtu[ nScanGrp, 4 ], cRepres ) ) 
		AADD( aGrupoAtu[ nScanGrp, 4 ], cRepres ) 	
	EndIf 		
	
EndIf 	 

Return( .T. ) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft070Grava³ Autor ³ Sergio Silveira       ³ Data ³16/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravacao da Estrutura de vendas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ft070Grava()

Local aArea      := GetArea()
Local aRepIncGrv := {}
Local aRepExcGrv := {}

Local cGrpBranco := Space( Len( PCX->PCX_GRPNAT ))
Local nLoop      := 0                             
Local nLoop2     := 0
Local nLoop3     := 0
Local nLoop4     := 0   

Begin Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa os grupos excluidos                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aGrupoExc ) 
	cGrupoExc := aGrupoExc[ nLoop ]
	If ValType( cGrupoExc ) == "C"
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os usuarios excluidos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSeekPCX := xFilial( "PCX" ) + cGrupoExc

    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem a lista de recnos                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRecno := {}
		PCX->( dbSetOrder( 2 ) ) //PCX_FILIAL, PCX_XGRPNAT, R_E_C_N_O_, D_E_L_E_T_
		If PCX->( dbSeek( cSeekPCX ) ) 				
			While !PCX->( Eof() ) .And. cSeekPCX == PCX->PCX_FILIAL + PCX->PCX_GRPNAT
				AAdd( aRecno, PCX->( Recno() ) ) 
				PCX->( dbSkip() ) 
			EndDo                                        
		EndIf                                                    

    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa a lista                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLoop2 := 1 To Len( aRecno ) 	
			PCX->( dbGoTo( aRecno[ nLoop2 ] ) ) 
			RecLock( "PCX", .F. ) 
			PCX->PCX_GRPNAT := cGrpBranco 				
            PCX->( MsUnlock() )   
    	Next nLoop2 

    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a tabela de grupos                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                  
		cSeekPCV := xFilial( "PCV" ) + cGrupoExc 
		PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
		If PCV->( dbSeek( cSeekPCV ) ) 
			RecLock( "PCV", .F. ) 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o grupo superior                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PCV->PCV_GRPSUP := cGrpBranco
					
		    PCV->( MsUnlock() ) 
			PCV->( dbSkip() ) 
		EndIf 	
	EndIf 
Next nLoop 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa os grupos incluidos                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aGrupoAtu ) 

	cGrupoAtu := aGrupoAtu[ nLoop, 1 ]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza a tabela de grupos                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cSeekPCV := xFilial( "PCV" ) + cGrupoAtu 
	PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
	If PCV->( dbSeek( cSeekPCV ) ) 
		      
		RecLock( "PCV", .F. ) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o grupo superior                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCV->PCV_GRPSUP := aGrupoAtu[ nLoop, 2 ] 						
	
	    PCV->( MsUnlock() ) 
		PCV->( dbSkip() ) 
		
	EndIf
	
	For nLoop4 := 1 To Len( aGrupoAtu[ nLoop, 3 ] ) 
		AAdd( aRepIncGrv, { cGrupoAtu, aGrupoAtu[ nLoop, 3, nLoop4 ] } ) 
	Next nLoop4 		

	For nLoop4 := 1 To Len( aGrupoAtu[ nLoop, 4 ] ) 
		AAdd( aRepExcGrv, aGrupoAtu[ nLoop, 4, nLoop4 ] ) 
	Next nLoop4 		
	
Next nLoop 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os usuarios excluidos                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop2 := 1 To Len( aRepExcGrv )        
	cUserExc := aRepExcGrv[ nLoop2 ]                                       
	If ValType( cUserExc ) == "C"        
		cSeekPCX := xFilial( "PCX" ) + cUserExc
		PCX->( dbSetOrder( 1 ) )  //PCX_FILIAL, PCX_NATUR, R_E_C_N_O_, D_E_L_E_T_
		If PCX->( dbSeek( cSeekPCX ) ) 				
			RecLock( "PCX", .F. ) 
			PCX->PCX_GRPNAT := cGrpBranco 				
			PCX->( MsUnlock() )   
		EndIf                
	EndIf                                       
Next nLoop2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os usuarios incluidos                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop3 := 1 To Len( aRepIncGrv )        
	cUserAtu := aRepIncGrv[ nLoop3, 2 ]                                       
	If ValType( cUserAtu ) == "C"        
		cSeekPCX := xFilial( "PCX" ) + cUserAtu
		PCX->( dbSetOrder( 1 ) )  //PCX_FILIAL, PCX_NATUR, R_E_C_N_O_, D_E_L_E_T_
		If PCX->( dbSeek( cSeekPCX ) ) 				
			RecLock( "PCX", .F. ) 
			PCX->PCX_GRPNAT := aRepIncGRv[ nLoop3, 1 ] 
			PCX->( MsUnlock() )   
		EndIf                
	EndIf                                       
Next nLoop3 

End Transaction 

RestArea(aArea)

Return( .T. ) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT070MontaºAutor  ³Alexandre Sousa     º Data ³  06/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta arvore.                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FT070Monta( oTree, cStartGroup ) 

	Local cCargo    := ""
	Local cSeekSup  := ""                
	Local cMainPref := ""

	Local nLoop     := 0      

	cStartGroup := If( ValType( cStartGroup ) == "C", cStartGroup, "MAINGR" ) 

	cMainPref := If( cStartGroup == "MAINGR", "0MA", "2GR" ) 
    
	oTree:TreeSeek( cMainPref + "-" + cStartGroup ) 
	cCargo := oTree:GetCargo() 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui os grupos que tem este grupo como superior            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
                                                
	aRecnoPCV := {}                     
                         
	If cStartGroup == "MAINGR" 
		PCV->( dbSetOrder( 2 ) ) //PCV_FILIAL, PCV_GRPSUP, R_E_C_N_O_, D_E_L_E_T_
		cSeekSup := xFilial( "PCV" ) + cStartGroup
		If PCV->( dbSeek( cSeekSup ) ) 
			While !PCV->( Eof() ) .And. PCV->PCV_FILIAL + PCV->PCV_GRPSUP == cSeekSup
				AAdd( aRecnoPCV, PCV->( RecNo() ) )	
				PCV->( dbSkip() ) 	
			EndDo 
		EndIf                 
	Else 	
		PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
		cSeekSup := xFilial( "PCV" ) + cStartGroup
		If PCV->( dbSeek( cSeekSup ) ) 
			AAdd( aRecnoPCV, PCV->( RecNo() ) )	
		EndIf                 
	EndIf 
	
	For nLoop := 1 To Len( aRecnoPCV ) 	                  
		PCV->( dbGoto( aRecnoPCV[ nLoop ] ) ) 
		FT070MonGr( @oTree, cCargo, PCV->PCV_GRPNAT ) 
	Next nLoop 	
                       
Return( .T. ) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT070MonGrºAutor  ³Alexandre Sousa     º Data ³  06/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta grupo.                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FT070MonGr( oTree, cCargo, cGrupoInc )
    
	Local aUserAtu   := {}
	Local aRecnoPCV  := {}        
	Local cSeekPCX   := ""
	Local cSeekSup   := ""                
	Local nLoop      := 0 

	#IFDEF TOP
		Local cQuery     := ""   
		Local cAliasQry  := ""
	#ENDIF 	

	PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
	If PCV->( MsSeek( xFilial( "PCV" ) + cGrupoInc ) )    
	 
		aUserAtu := {} 
		oTree:TreeSeek( cCargo ) 
		cDesc := PadR( PCV->PCV_GRPNAT + "-" + Capital( PCV->PCV_DESC ), 100 ) 
	
		oTree:AddItem( cDesc, "2GR-" + PCV->PCV_GRPNAT,aGrupoBmp[1],aGrupoBmp[2],,,2) 
		oTree:TreeSeek( "2GR-" + PCV->PCV_GRPNAT ) 
		
		cCargo := "2GR-" + PCV->PCV_GRPNAT
		                   
		#IFDEF TOP 
		         
			If TcSrvType() <> "AS/400" 
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inclui os naturezass                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAliasQry := CriaTrab( ,.F. ) 		

				cQuery := ""                          
				cQuery += "SELECT PCX_NATUR, PCX_DESC FROM " + RetSqlName( "PCX" ) + " PCX "
				cQuery += "WHERE "
				cQuery += "PCX_FILIAL='" + xFilial( "PCX" ) + "' AND "
				cQuery += "PCX_GRPNAT='" + PCV->PCV_GRPNAT  + "' AND "			
				cQuery += "PCX.D_E_L_E_T_<>'*' ORDER BY PCX_NATUR"
		
				dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. ) 
				
				If Alias() == cAliasQry 
					While !Eof()
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inclui no array de atuais ( ja existentes )                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AAdd( aUserAtu, PCX_NATUR ) 
						cDesc := PadR(  PCX_NATUR + "-" + Capital( PCX_DESC ), 100 ) 
						oTree:AddItem(  cDesc, "1US-" + PCX_NATUR,"BMPUSER","BMPUSER",,,2)   
						dbSkip()    	
					EndDo 					
					dbCloseArea()
					dbSelectArea( "PCX" ) 
				EndIf 
		
			Else 	
		#ENDIF 
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inclui as naturezas                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PCX->( dbSetOrder( 2 ) ) //PCX_FILIAL, PCX_XGRPNAT, R_E_C_N_O_, D_E_L_E_T_
				cSeekPCX := xFilial( "PCX" ) + PCV->PCV_GRPNAT
				If PCX->( dbSeek( cSeekPCX ) ) 
					While !PCX->( Eof() ) .And. cSeekPCX == PCX->PCX_FILIAL + PCX->PCX_GRPNAT
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inclui no array de atuais ( ja existentes )                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AAdd( aUserAtu, PCX->PCX_NATUR ) 
						cDesc := PadR( PCX->PCX_NATUR + "-" + Capital( PCX->PCX_DESC ), 100 ) 
						oTree:AddItem( cDesc, "1US-" + PCX->PCX_NATUR,"BMPUSER","BMPUSER",,,2)   
						
						PCX->( dbSkip() ) 	 
					EndDo 
			    EndIf 
			    
		#IFDEF TOP
			EndIf 	
		#ENDIF		    
				
		AAdd( aGrupoAtu, { PCV->PCV_GRPNAT, PCV->PCV_GRPSUP, {}, {}, aUserAtu } ) 	
		                                                  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui os grupos que tem este grupo como superior            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
	                                                
		aRecnoPCV := {} 
	            
		#IFDEF TOP 
		
			If TcSrvType() # "AS/400"
	
				cAliasQry := CriaTrab( ,.F. ) 		
				cQuery    := ""                          
				
				cQuery += "SELECT R_E_C_N_O_ PCVRECNO FROM " + RetSqlName( "PCV" ) + " "
				cQuery += "WHERE "
				cQuery += "PCV_FILIAL='" + xFilial( "PCV" ) + "' AND "
				cQuery += "PCV_GRPSUP='" + cGrupoInc        + "' AND "			
				cQuery += "D_E_L_E_T_<>'*' ORDER BY PCV_GRPNAT"
		
				dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. ) 
				
				If Alias() == cAliasQry 
					While !Eof()
						AAdd( aRecnoPCV, PCVRECNO ) 
						dbSkip()    	
					EndDo 					
					dbCloseArea()
					dbSelectArea( "PCV" ) 
				EndIf 
		
			Else
		#ENDIF 
				PCV->( dbSetOrder( 2 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
				cSeekSup := xFilial( "PCV" ) + cGrupoInc  
				If PCV->( dbSeek( cSeekSup ) ) 
					While !PCV->( Eof() ) .And. PCV->PCV_FILIAL + PCV->PCV_GRPSUP == cSeekSup
						AAdd( aRecnoPCV, PCV->( RecNo() ))
						PCV->( dbSkip() ) 	
					EndDo 
				EndIf
		#IFDEF TOP
			EndIf 	
		#ENDIF	
	
		For nLoop := 1 To Len( aRecnoPCV )
			PCV->( dbGoto( aRecnoPCV[ nLoop ] ) ) 
			FT070MonGr( @oTree, cCargo, PCV->PCV_GRPNAT )
		Next nLoop
	
	EndIf 
	
Return( .T. ) 
