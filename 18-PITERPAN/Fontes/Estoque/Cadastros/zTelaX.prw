#include 'protheus.ch'
#include 'parmtype.ch'

user function zTelaX()

	Local oButton1
	Local oButton2
	Local oGet1
	Local cGet1 	:= Space(40) 	// Descricao
	Local oGet2
	Local cGet2 	:= Space(20) 	// codigo
	Local oGet3
	Local cGet3		:= 0 	// canal
	Local oGet4	
	Local cGet4		:= 0	// peso bruto
	Local oGet5	
	Local cGet5		:= Space(20)	// mp
	Local oGet6	
	Local cGet6		:= 0	// mp-custo/lk
	Local oGet7	
	Local cGet7		:= 0	// mp-custo/mil
	Local oGet8	
	Local cGet8		:= 0	// cavidades
	Local oGet9		
	Local cGet9		:= 0	// ciclo
	Local oGet10	
	Local cGet10	:= 0	// pc/h
	Local oGet11	
	Local cGet11	:= 0	// hora maq/custo
	Local oGet12	
	Local cGet12	:= 0	// mo-custo/mil
	Local oGet13	
	Local cGet13	:= Space(40)	// observacoes
	Local oGet14	
	Local cGet14	:= Space(20)	// maq tipo
	Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12, oSay13, oSay14
	
	Local _nOpc := 0
	
	DEFINE FONT oFont1 NAME "Arial" SIZE 0, -20 
	DEFINE FONT oFont2 NAME "Arial" SIZE 0, -20 BOLD
	Private _oDlg
	
	DEFINE MSDIALOG _oDlg TITLE "P l a n e j a m e n t o    d e    P r o d u t o" FROM 000, 000  TO 0410, 1040 COLORS 0, 16777215 PIXEL
	  
	oGroup1:= TGroup():New(0005,0005,0040,0510,'',_oDlg,,,.T.)
	oGroup2:= TGroup():New(0045,0005,0080,0510,'',_oDlg,,,.T.)
	oGroup3:= TGroup():New(0085,0005,0120,0510,'',_oDlg,,,.T.)
	oGroup4:= TGroup():New(0125,0005,0160,0510,'',_oDlg,,,.T.)
	
	    @ 007, 010 SAY oSay1 PROMPT "Descrição" 	SIZE 050, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 019, 010 MSGET oGet1 VAR cGet1 When .T. 	SIZE 300, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
	        
	    @ 007, 320 SAY oSay2 PROMPT "Código" 		SIZE 062, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 019, 320 MSGET oGet2 VAR cGet2  When .T. 	SIZE 180, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
	    
	    
	    @ 050, 010 SAY oSay3 PROMPT "Canal" 		SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 010 MSGET oGet3 VAR cGet3 Picture("@E999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 050, 110 SAY oSay4 PROMPT "Peso Bruto" 	SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 110 MSGET oGet4 VAR cGet4 Picture("@E999.999999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		    
		@ 050, 210 SAY oSay5 PROMPT "MP" 			SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 210 MSGET oGet5 VAR cGet5  When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 050, 310 SAY oSay6 PROMPT "MP-Custo/Kg" 	SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 310 MSGET oGet6 VAR cGet6 Picture("@E999.9999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 050, 410 SAY oSay7 PROMPT "MP-Custo/Mil" 	SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 410 MSGET oGet7 VAR cGet7 Picture("@E999.9999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		
		@ 090, 010 SAY oSay8 PROMPT "Cavidades" 	SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 010 MSGET oGet8 VAR cGet8 Picture("@E999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 090, 110 SAY oSay9 PROMPT "Ciclo"		 	SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 110 MSGET oGet9 VAR cGet9 Picture("@E999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		    
		@ 090, 210 SAY oSay10 PROMPT "PÇ/H" 			SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 210 MSGET oGet10 VAR cGet10 Picture("@E999,999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 090, 310 SAY oSay11 PROMPT "Hora Maq/Custo"	SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 310 MSGET oGet11 VAR cGet11 Picture("@E999.9999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 090, 410 SAY oSay12 PROMPT "MO-Custo/Mil" 	SIZE 090, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 410 MSGET oGet12 VAR cGet12 Picture("@E999.9999") When .T. 	SIZE 090, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		
		@ 130, 010 SAY oSay13 PROMPT "Observações" 	SIZE 070, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 142, 010 MSGET oGet13 VAR cGet13 When .T. SIZE 300, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
	        
	    @ 130, 320 SAY oSay14 PROMPT "Maq Tipo" 	 SIZE 062, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 142, 320 MSGET oGet14 VAR cGet14  When .T. SIZE 180, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		//@ 050, 240 SAY oSay8 PROMPT "MP-Custo/Mil" 	SIZE 052, 012 FONT oFont2 COLORS 0, 16777215 PIXEL
		//@ 063, 240 MSGET oGet8 VAR  When .T. 		SIZE 050, 012 FONT oFont1 COLORS 0, 16777215 PIXEL
	    
		
	    @ 180, 100 BUTTON oButton2 PROMPT "Pesquisar" Action( _nOpc := 2, _oDlg:End() ) 	SIZE 070, 015 FONT oFont2 PIXEL
	    @ 180, 200 BUTTON oButton1 PROMPT "Cancelar"  Action( _oDlg:End() ) 			    SIZE 070, 015 FONT oFont2 PIXEL
	    @ 180, 300 BUTTON oButton2 PROMPT "OK"        Action( _nOpc := 1, _oDlg:End() ) 	SIZE 070, 015 FONT oFont2 PIXEL
	  
	  ACTIVATE MSDIALOG _oDlg CENTERED
	   	/*
	  	If _nOpc = 1
	  	
	  		Reclock("ZZZ",.T.)
		 
		  		ZZZ->ZZZ_ZZZZZ	 	:= cGet1
		  		
		  	MsUnlock()
	  	endif
	  	*/
Return _nOpc
