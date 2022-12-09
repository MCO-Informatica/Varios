#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'

user function zTelaW()
	Local oButton1
	Local oButton2
	
    Local nOpcao      := 0
	Local oPesq
	Private oGet1
	Private cGet1 		:= Space(80) // Descricao
	Private oGet2
	Private cGet2 		:= Space(30) 	// codigo
	Private oGet3
	Private cGet3		:= Space(07) 	// canal
	Private oGet4	
	Private cGet4		:= 0	// peso bruto
	Private oGet5	
	Private cGet5		:= Space(20)	// mp
	Private oGet6	
	Private cGet6		:= 0	// mp-custo/lk
	Private oGet7	
	Private cGet7		:= 0	// mp-custo/mil
	Private oGet8	
	Private cGet8		:= Space(05)	// cavidades
	Private oGet9		
	Private cGet9		:= Space(05)	// ciclo
	Private oGet10	
	Private cGet10		:= Space(10)	// pc/h
	Private oGet11	
	Private cGet11		:= 0	// hora maq/custo
	Private oGet12	
	Private cGet12		:= 0	// mo-custo/mil
	Private oGet13	
	Private cGet13		:= Space(40)	// observacoes
	Private oGet14	
	Private cGet14		:= Space(20)	// maq tipo
	Private _oDlg
	Private _oDlg0
	Private _nOpc 		:= 0
	
	

	zTelaX()
	
	
return

Static function zTelaPesq()

	Private cPesq 	:= SZ1->Z1_PRODBAS 	// Descricao

	DEFINE MSDIALOG _oDlg0 TITLE "TELA" FROM 000, 000  TO 0150, 0450 COLORS 0, 16777215 PIXEL
	DEFINE FONT oFont1 NAME "Arial" SIZE 0, -20 
	DEFINE FONT oFont2 NAME "Arial" SIZE 0, -20 BOLD
		
	oGroup1:= TGroup():New(0005,0005,0070,0220,'PESQUISAR',_oDlg0,,,.T.)
	
	@ 015, 010 SAY oSay1 PROMPT "SELECIONE O CÓDIGO" 						SIZE 200, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 025, 010 MSGET oPesq VAR cPesq When .T. Picture "@!" Pixel F3 "SZ1" 	SIZE 200, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
	
	@ 045, 030 BUTTON oButton2 PROMPT "PESQUISAR" Action( zAltZZZ() ) 	SIZE 070, 015 FONT oFont2 PIXEL
	@ 045, 110 BUTTON oButton2 PROMPT "FECHAR" Action( _oDlg0:End() ) 	SIZE 070, 015 FONT oFont2 PIXEL

	ACTIVATE MSDIALOG _oDlg0 CENTERED
	
		
Return

static function zAltZZZ()
	Local aArea       := GetArea()
    Local aAreaB1     := SZ1->(GetArea())
    Local nOpcao      := 0

    Private cCadastro 
   
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1)) //Z1_PRODBAS
	SZ1->(DbGoTop())
	    
		If SZ1->(DbSeek(xFilial("SZ1")+Alltrim(cPesq)),.F.)
		
			nOpcao := zCarregar()
	        If nOpcao == 1
	            MsgInfo("PRODUTO ATUALIZADO", "ATENÇÃO")	
	   
	        EndIf
	    Else
	        MsgInfo("PRODUTO NÃO ENCONTRADO", "ATENÇÃO")	
	    EndIf

	_oDlg0:End()
    RestArea(aAreaB1)
    RestArea(aArea)

Return


static function zTelaX()
	Local oButton1
	Local oButton2
	
	Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12, oSay13, oSay14
	
	DEFINE FONT oFont1 NAME "Arial" SIZE 0, -20 
	DEFINE FONT oFont2 NAME "Arial" SIZE 0, -20 BOLD
	DEFINE MSDIALOG _oDlg TITLE "ENGENHARIA DE PRODUTO" FROM 000, 000  TO 0410, 1040 COLORS 0, 16777215 PIXEL
	  
	oGroup1:= TGroup():New(0005,0005,0040,0510,'',_oDlg,,,.T.)
	oGroup2:= TGroup():New(0045,0005,0080,0510,'',_oDlg,,,.T.)
	oGroup3:= TGroup():New(0085,0005,0150,0510,'',_oDlg,,,.T.)
	oGroup4:= TGroup():New(0155,0005,0160,0510,'',_oDlg,,,.T.)
	
	    @ 007, 010 SAY oSay1 PROMPT "DESCRIÇÃO" 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 019, 010 MSGET oGet1 VAR cGet1 When .T. 	SIZE 300, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
	        
	    @ 007, 320 SAY oSay2 PROMPT "CÓDIGO" 		SIZE 062, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 019, 320 MSGET oGet2 VAR cGet2  When .T. 	SIZE 180, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
	    
	    
	    @ 050, 010 SAY oSay3 PROMPT "CANAL" 		SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 010 MSGET oGet3 VAR cGet3 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 050, 110 SAY oSay4 PROMPT "PESO BRUTO" 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 110 MSGET oGet4 VAR cGet4 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		    
		@ 050, 210 SAY oSay5 PROMPT "MP" 			SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 210 MSGET oGet5 VAR cGet5  When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 050, 310 SAY oSay6 PROMPT "MP-CUSTO/KG" 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 310 MSGET oGet6 VAR cGet6 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 050, 410 SAY oSay7 PROMPT "MP-CUSTO/MIL" 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 062, 410 MSGET oGet7 VAR cGet7 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		
		@ 090, 010 SAY oSay8 PROMPT "CAVIDADES" 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 010 MSGET oGet8 VAR cGet8 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 090, 110 SAY oSay9 PROMPT "CICLO"		 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 110 MSGET oGet9 VAR cGet9 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		    
		@ 090, 210 SAY oSay10 PROMPT "PÇ/H" 			SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 210 MSGET oGet10 VAR cGet10  When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 090, 310 SAY oSay11 PROMPT "HR-MAQ/CUSTO"	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 310 MSGET oGet11 VAR cGet11 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 090, 410 SAY oSay12 PROMPT "MO-CUSTO/MIL" 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 102, 410 MSGET oGet12 VAR cGet12 When .T. 	SIZE 090, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		
		@ 130, 010 SAY oSay13 PROMPT "OBSERVAÇÕES" 	SIZE 090, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 142, 010 MSGET oGet13 VAR cGet13 When .T. SIZE 300, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
	        
	    @ 130, 320 SAY oSay14 PROMPT "MAQ.TIPO" 	 SIZE 062, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 142, 320 MSGET oGet14 VAR cGet14  When .T. SIZE 180, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
		
		//@ 050, 240 SAY oSay8 PROMPT "MP-Custo/Mil" 	SIZE 052, 015 FONT oFont2 COLORS 0, 16777215 PIXEL
		//@ 063, 240 MSGET oGet8 VAR  When .T. 		SIZE 050, 015 FONT oFont1 COLORS 0, 16777215 PIXEL
	    
		
		@ 180, 070 BUTTON oButton1 PROMPT "PESQUISAR" Action( zTelaPesq() ) 			SIZE 070, 015 FONT oFont2 PIXEL
	    @ 180, 170 BUTTON oButton1 PROMPT "CANCELAR" Action( _oDlg:End() ) 			SIZE 070, 015 FONT oFont2 PIXEL
	    @ 180, 270 BUTTON oButton2 PROMPT "CONFIRMAR" Action( zAltCad() ) 	SIZE 070, 015 FONT oFont2 PIXEL
	    @ 180, 370 BUTTON oButton2 PROMPT "FECHAR" Action( _oDlg:End() ) 	SIZE 070, 015 FONT oFont2 PIXEL
	  
	  ACTIVATE MSDIALOG _oDlg CENTERED
	   
return  _nOpc

Static function zCarregar()

	cGet1 	:= SZ1->Z1_DESCBAS // Descricao
	cGet2 	:= SZ1->Z1_PRODBAS
	GetdRefresh()
 
Return 

Static function zAltCad()
	
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1)) //Z1_PRODBAS

	DbSelectArea("SZ1")
	If SZ1->(DbSeek(xFilial("SZ1")+Alltrim(cGet2)),.F.)
		Reclock("SZ1",.F.)
			 
	  		SZ1->Z1_DESCBAS	 	:= cGet1	//descricao
	  		SZ1->Z1_PRODBAS		:= cGet2	//codigo
	  		SZ1->Z1_CANAL		:= cGet3	//canal
	  		SZ1->Z1_PESOBRU		:= cGet4	//peso bruto
	  		SZ1->Z1_COMPOSI		:= cGet5	//materia prima
	  		SZ1->Z1_CUSTOMO		:= cGet6	//custo por quilo
	  		SZ1->Z1_CUSTOMP		:= cGet7	//custo por milheiro
	  		SZ1->Z1_CAVIDAD		:= cGet8	//cavidades
	  		SZ1->Z1_CICLO		:= cGet9	//ciclos
	  		SZ1->Z1_PCSHRS		:= cGet10	//pecas por hora
	  		SZ1->Z1_CUSTOTC		:= cGet11	//custo hora maquina
	  		SZ1->Z1_CUSTOTO		:= cGet12	//custo mao obra milheiro
	  		SZ1->Z1_OBSERVA		:= cGet13	//observacoes
	  		SZ1->Z1_MAQ1		:= cGet14	//tipo maquina
	  							
	  		
			  		
	  	MsUnlock()
	  	MsgInfo("ALTERAÇÃO FINALIZADA.", "ATENÇÃO")
	Else
			Reclock("SZ1",.t.)
			 
	  		SZ1->Z1_FILIAL		:= xFilial("SZ1")
	  		SZ1->Z1_DESCBAS	 	:= cGet1	//descricao
	  		SZ1->Z1_PRODBAS		:= cGet2	//codigo
	  		SZ1->Z1_CANAL		:= cGet3	//canal
	  		SZ1->Z1_PESOBRU		:= cGet4	//peso bruto
	  		SZ1->Z1_COMPOSI		:= cGet5	//materia prima
	  		SZ1->Z1_CUSTOMO		:= cGet6	//custo por quilo
	  		SZ1->Z1_CUSTOMP		:= cGet7	//custo por milheiro
	  		SZ1->Z1_CAVIDAD		:= cGet8	//cavidades
	  		SZ1->Z1_CICLO		:= cGet9	//ciclos
	  		SZ1->Z1_PCSHRS		:= cGet10	//pecas por hora
	  		SZ1->Z1_CUSTOTC		:= cGet11	//custo hora maquina
	  		SZ1->Z1_CUSTOTO		:= cGet12	//custo mao obra milheiro
	  		SZ1->Z1_OBSERVA		:= cGet13	//observacoes
	  		SZ1->Z1_MAQ1		:= cGet14	//tipo maquina
	  							
	  		
			  		
	  	MsUnlock()
	  	MsgInfo("INCLUSÃO FINALIZADA.", "ATENÇÃO")
	
	EndIf
				
Return