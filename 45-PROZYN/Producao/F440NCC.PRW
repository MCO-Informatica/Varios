#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F440COM   º Autor ³ Denis Varella      Data ³ 18/12/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Customização de comissão para preenchimento correteo da SE3 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function F440NCC()  
   
	If Select("tVEND") > 0
   		tVEND->(DBCloseArea())
   	EndIf
		
	BeginSql alias "tVEND"
		Select E3_VEND,R_E_C_N_O_ FROM %Table:SE3%
		WHERE E3_NUM = %Exp:SF1->F1_DOC% and
		E3_PREFIXO = %Exp:SF1->F1_SERIE% and
		E3_CODCLI = %Exp:SF1->F1_FORNECE% and
		E3_LOJA = %Exp:SF1->F1_LOJA% and 
		E3_DATA = '' and
		%notDel%
	EndSql             
	
	While tVEND->(!Eof()) 
		DbSelectArea("SE3")
		SE3->(DbGoTo(tVEND->R_E_C_N_O_))
			RecLock("SE3",.F.)
				SE3->E3_PIS		:= (SF1->F1_VALIMP6 * -1)
				SE3->E3_COFINS	:= (SF1->F1_VALIMP5 * -1)
				SE3->E3_IPI		:= (SF1->F1_VALIPI * -1)
				SE3->E3_ICMS	:= (SF1->F1_VALICM * -1)
				SE3->E3_BASEBRU	:= (SF1->F1_VALBRUT * -1)      
				SE3->E3_PORC	:= POSICIONE('SA3',1,xFilial('SA3')+SE3->E3_VEND,"A3_COMIS")
				SE3->E3_ACRVEN1	:= (SF1->F1_VALBRUT / 100 * POSICIONE("SE4",1,xFilial("SE4")+SF1->F1_COND,"E4_ACRVEN1") * -1)
				SE3->E3_BASE	:= ((SF1->F1_VALBRUT + SE3->E3_PIS + SE3->E3_COFINS + SE3->E3_ICMS + SE3->E3_IPI + SE3->E3_ACRVEN1) * -1)  
				SE3->E3_COMIS	:= (SE3->E3_BASE / 100 * SE3->E3_PORC)
			MsUnlock()
	tVend->(dbskip())
	EndDo   
   
	If Select("VEND") > 0
   		tVend->(DBCloseArea())
   	EndIf
Return