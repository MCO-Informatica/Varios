#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F440COM   º Autor ³ Denis Varella      Data ³ 23/11/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Customização de comissão para preenchimento correteo da SE3 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function F440COM()   
Local nFreteNF := 0
Local nFreteD1 := 0
                                                                         
	nFreteNF := SF2->F2_FRETE
	
	/*	 Tratamento do indice customizadao - ocorrencia na 12.1.017 - Deo 16/04/18
	If POSICIONE("SD1",18,xFilial("SD1")+SF2->F2_DOC,"D1_TOTAL") > 0
		nFreteD1 := POSICIONE("SD1",18,xFilial("SD1")+SF2->F2_DOC,"D1_TOTAL")     
	EndIf    
      */         

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Contabilizar todos os fretes vinculados a esta nota³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DbSelectArea("SD1")
    DbOrderNickName("COMIFRE") //D1_FILIAL+D1_NFSAIDA+D1_FORNECE+D1_LOJA+D1_DOC+D1_ITEM  
    If SD1->(DbSeek(xFilial("SD1")+SF2->F2_DOC)) 
    	While !SD1->(Eof()) .AND. SD1->(D1_FILIAL+D1_NFSAIDA) == xFilial("SD1")+SF2->F2_DOC
    		nFreteD1 += SD1->D1_TOTAL 
    		SD1->(DbSkip())
    	EndDo	    
    EndIf
      
	If Select("tVEND") > 0
   		tVEND->(DBCloseArea())
   	EndIf
		
	BeginSql alias "tVEND"
		Select E3_VEND,R_E_C_N_O_ FROM %Table:SE3%
		WHERE E3_NUM = %Exp:SF2->F2_DOC% and
		E3_PREFIXO = %Exp:SF2->F2_SERIE% and 
		E3_TIPO != 'AB-' and
		E3_CODCLI = %Exp:SF2->F2_CLIENTE% and
		E3_LOJA = %Exp:SF2->F2_LOJA% and 
		E3_DATA = '' and
		%notDel%
	EndSql      
	
	While tVEND->(!Eof()) 
		DbSelectArea("SE3")
		SE3->(DbGoTo(tVEND->R_E_C_N_O_))
			RecLock("SE3",.F.)
				SE3->E3_FRETENF := nFreteNF
				SE3->E3_FRETED1 := nFreteD1
				SE3->E3_PIS		:= SF2->F2_VALIMP6
				SE3->E3_COFINS	:= SF2->F2_VALIMP5
				SE3->E3_IPI		:= SF2->F2_VALIPI
				SE3->E3_ICMS	:= SF2->F2_VALICM
				SE3->E3_BASEBRU	:= SF2->F2_VALBRUT
				SE3->E3_ACRVEN1	:= SF2->F2_VALBRUT / 100 * POSICIONE("SE4",1,xFilial("SE4")+SF2->F2_COND,"E4_ACRVEN1")
				SE3->E3_BASE	:= (SE3->E3_BASEBRU - SE3->E3_PIS - SE3->E3_COFINS - SE3->E3_ICMS - SE3->E3_IPI - nFreteNF - nFreteD1 - SE3->E3_ACRVEN1)    
				SE3->E3_COMIS	:= (SE3->E3_BASE / 100 * SE3->E3_PORC)
			MsUnlock()
	tVEND->(dbskip())
	EndDo   
   
	If Select("tVEND") > 0
   		tVEND->(DBCloseArea())
   	EndIf
Return
