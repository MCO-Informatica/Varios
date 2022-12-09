//Devolução de Compras
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³                   º Data ³  Maio/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada após a gravacao da NF de Saida             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Infosol                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                      A T U A L I Z A C A O                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      |ANALISTA          |ALTERACAO                                º±±
±±º          |                  |                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()
Local a_Area	:= GetArea()
Local c_Pedido	:= SC5->C5_NUM  
Local c_DOC 	:= SF2->F2_DOC  
Local c_Serie	:= SF2->F2_SERIE
Local c_ClieNf	:= SF2->F2_CLIENTE
Local c_LojaNf	:= SF2->F2_LOJA 


DBSELECTAREA("SC6")
DBSETORDER(1)
IF (DBSEEK(XFILIAL("SC6")+c_Pedido))

	WHILE (SC6->(!EOF())) .AND. (SC6->C6_FILIAL+SC6->C6_NUM == XFILIAL("SC6")+c_Pedido)
	   	    	
		DBSELECTAREA("SD2")
		DBSETORDER(3)
		IF (DBSEEK(XFILIAL("SD2")+c_Doc+c_Serie+c_ClieNf+c_LojaNf+SC6->C6_PRODUTO+SC6->C6_ITEM))	
	     
		   	RECLOCK("SD2",.F.)
			SD2->D2_CCUSTO	:= SC6->C6_CC
			SD2->D2_CLVL	:= SC6->C6_CLVL
			SD2->D2_ITEMCC	:= SC6->C6_ITEMCTA
			SD2->D2_EC05CR	:= SC6->C6_EC05CR
                                                                            

			MSUNLOCK()

		ENDIF
		
		DBSELECTAREA("SC6")
		SC6->(DBSKIP())
	
	ENDDO

ENDIF

RestArea(a_Area)

Return()