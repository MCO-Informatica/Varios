
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT300PRC  ºAutor  ³Microsiga           º Data ³  09/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento Oportunidade de Vendas (ADM CRM de Vendas)     º±±
±±º          ³ Ponto de Entrada                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FT300PRC()

Local cQuery 	 := ''
Local aPara 	 := {} 
Local aArea		 := GetArea()
local cMailVe 	 := ""
local oModel     := PARAMIXB[1]
Local oMdlAD1    := oModel:GetModel("AD1MASTER")
Local nOperation := oModel:GetOperation()


If SuperGetMV("MV_XENVMAI") == .F.     //DESABILITA ENVIO DE EMAIL NO APONTAMENTO

	Return .T.    

EndIf
	
If nOperation == 3   

//pega email do vendedor amarrado a oportunidade     

	cQuery :="SELECT R_E_C_N_O_ "
	cQuery +="FROM  "  + RetSQLName("ZCE")
	cQuery +=" WHERE ZCE_FILIAL = '"+xFilial("ZCE")+"' AND "
	cQuery +="ZCE_ESTATU = '' AND "
	cQuery +="ZCE_ESTNOV = '"+M->AD1_STAGE+"'AND "
	cQuery +="D_E_L_E_T_ = ' ' "
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZCE",.F.,.T.)
	
	If  !TRBZCE->(eof())
		ZCE->(dbGoTo(TRBZCE->R_E_C_N_O_ ))
		aPara:= StrtoKarr(ZCE->ZCE_EMAIl,";")
		
		// tratamento para enviar email para o vendedor amarrado a oportunidade quando na inclusï¿½o de oportunidade nova
		IF ( ZCE->ZCE_RESOPT == "S")
	
			cMailVe	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+AD1->AD1_VEND,"A3_EMAIL"))
			aAdd(aPara,cMailVe)
		
		ENDIF

 		u_EnvMail(M->AD1_STAGE,aPara,.T.)
		
	Endif
	TRBZCE->(dbCloseArea())  
		 
		
EndIf
restArea(aArea)

Return .T.
