#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD11100I  ºAutor  ³Henio Brasil        º Data ³  31/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a gravacao do pedido de compra,       º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SD1100I()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nRecno	:= Recno()
Local aArea		:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local cChapa	:= ''   
Local cCtaCont	:= SB1->B1_CTABEM 
Local cCtaDesp	:= SB1->B1_CTADDEP
Local cCtaDAcu	:= SB1->B1_CTADACU      
Local nTaxaDep	:= SB1->B1_TXADEP 
Local cHistPad	:= 'NF:'+SF1->F1_SERIE+' '+SF1->F1_DOC+' '+Alltrim(SA2->A2_NOME) 
/* 
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verifica se o usuario deseja vincular cotacoes ao pedido            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
If SF1->F1_TIPO == 'N' .And. SD1->D1_TP == 'AF' 	// .And. ; 
	nOpca	:= Aviso("Atualização Ativo","Deseja atualizar dados do Ativo Fixo?",{"Sim","Não"}) 	// == '1' 
	If nOpca == 1 
		cChapa:= Right(SN1->N1_CBASE,6) 
		// If  nOptAft=='1' 
	   If !Empty(cCtaCont) .Or. !Empty(cCtaDesp) .Or. !Empty(cCtaDAcu) .Or. !Empty(nTaxaDep) 
			 DbSelectArea("SN1") 
			 If RecLock("SN1",.F.) 
				 SN1->N1_CHAPA = cChapa		  
	          MsUnlock() 
	    	 Endif 
			 DbSelectArea("SN3") 
			 If RecLock("SN3",.F.) 
				 SN3->N3_CCONTAB 	:= cCtaCont
				 SN3->N3_CDEPREC 	:= cCtaDesp
				 SN3->N3_CCDEPR 	:= cCtaDAcu
				 SN3->N3_TXDEPR1	:= nTaxaDep
				 SN3->N3_HISTOR	:= cHistPad			 
				 SN3->N3_CCUSTO 	:= '00' 
	          MsUnlock() 
	    	 Endif 
	     Else 
	     	 MsgAlert("Atenção ! Cadastro de Produtos Inconsistente! Será preciso efetuar a Classificação manualmente.")  
		Endif 
	Endif    
EndIf

RestArea(aAreaSD1)
RestArea(aArea)
Return