#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F440ABM   º Autor ³ Denis Varella      Data ³ 05/03/2018   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Customização de comissão para preenchimento correteo da SE3 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function F440ABM()  
	If Select("tVEND") > 0
   		tVEND->(DBCloseArea())
   	EndIf
		
	BeginSql alias "tVEND"
		Select E3_VEND,R_E_C_N_O_ FROM %Table:SE3%
		WHERE E3_NUM = %Exp:SF1->F1_DOC% and
		E3_PREFIXO = %Exp:SF1->F1_SERIE% and
		E3_CODCLI = %Exp:SF1->F1_FORNECE% and
		E3_LOJA = %Exp:SF1->F1_LOJA% and
		E3_TIPO = 'AB-' and 
		E3_DATA = '' and
		%notDel%
	EndSql             
	
	While tVEND->(!Eof()) 
		DbSelectArea("SE3")
		SE3->(DbGoTo(tVEND->R_E_C_N_O_))
			RecLock("SE3",.F.)
				SE3->E3_COMIS	:= (SE3->E3_BASE / 100 * SE3->E3_PORC * -1)
			MsUnlock()
	tVend->(dbskip())
	EndDo   
   
	If Select("VEND") > 0
   		tVend->(DBCloseArea())
   	EndIf
Return