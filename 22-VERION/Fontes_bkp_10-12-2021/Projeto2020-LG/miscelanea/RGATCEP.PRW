#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGATCEP   ºAutor  ³Sergio Rodrigues    º Data ³17/10/07	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho para atualizar campos de endereco atraves do CEP	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gatilho						                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  
User Function RGATCEP(cChave, aCpoAtu)

Local cOldArea	:= GetArea()
Local __oDlg             
Local __oFont
Private __cEndereco	
Private __cNumero
Private __cBairro
Private __cCidade
Private __cEstado                                          

	If !Empty(cChave)
		dbSelectArea("BC9")
		dbSetOrder(1)	//BC9_FILIAL + BC9_CEP
		If dbSeek(xFilial("BC9")+cChave)
		   __cEndereco	:= ALLTRIM(BC9_TIPOLG)+" "+ALLTRIM(BC9_END)
		   __cNumero	:= SPACE(5)
		   __cBairro	:= ALLTRIM(BC9_BAIRRO)
		   __cCidade	:= ALLTRIM(BC9_MUN)
		   __cEstado    := BC9_EST

           DEFINE FONT __oFont NAME "Arial" SIZE 0, -12 BOLD
		
		   DEFINE MSDIALOG __oDlg TITLE OEMTOANSI("Confirmação do Endereço") FROM 0,0 TO 200,400 OF oMainWnd PIXEL
		   @005,010 SAY OEMTOANSI("ENDEREÇO") 	OF __oDlg PIXEL FONT __oFont
		   @015,010 SAY __cEndereco				OF __oDlg PIXEL FONT __oFont COLOR CLR_HBLUE
		   @005,150 SAY OEMTOANSI("NÚMERO")		OF __oDlg PIXEL FONT __oFont
		   @015,150 GET __cNumero PICTURE "@!"  OF __oDlg PIXEL
		   
		   @030,010 SAY OEMTOANSI("BAIRRO")		OF __oDlg PIXEL FONT __oFont
		   @040,010 SAY __cBairro				OF __oDlg PIXEL FONT __oFont COLOR CLR_HBLUE
		   
		   @055,010 SAY OEMTOANSI("CIDADE")		OF __oDlg PIXEL FONT __oFont
		   @065,010 SAY __cCidade				OF __oDlg PIXEL FONT __oFont COLOR CLR_HBLUE
		   @055,150 SAY OEMTOANSI("ESTADO")		OF __oDlg PIXEL FONT __oFont
		   @065,150 SAY __cEstado				OF __oDlg PIXEL FONT __oFont COLOR CLR_HBLUE

           DEFINE SBUTTON __oBut1 FROM 085,130 TYPE 1 ENABLE OF __oDlg PIXEL ACTION(IIF(!Empty(__cNumero),(fAtualiza(aCpoAtu),__oDlg:End()),.F.))
           DEFINE SBUTTON __oBut1 FROM 085,165 TYPE 2 ENABLE OF __oDlg PIXEL ACTION(__oDlg:End())

		   ACTIVATE DIALOG __oDlg CENTERED	   
		Else
		   MsgInfo("CEP não localizado. Tecla [F3] disponível.")
		EndIf
    EndIf
    
	RestArea(cOldArea)

Return cChave

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDesc.     ³Funcao de atualizacao dos campos de endereco				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RGATCEP						                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  
Static Function fAtualiza(aCpoAtu) 
M->&(aCpoAtu[1]):= PADR(__cEndereco+" "+__cNumero,40,Space(1))
M->&(aCpoAtu[2]):= PADR(__cBairro,25,Space(1))
M->&(aCpoAtu[3]):= PADR(__cCidade,25,Space(1))
M->&(aCpoAtu[4]):= __cEstado                                  
Return