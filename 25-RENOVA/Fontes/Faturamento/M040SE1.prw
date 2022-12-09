#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M040SE1   ºAutor  ³Jeremias            º Data ³  18/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ESTE PONTO DE ENTRADA ESTA GRAVANDO O CENTRO DE CUSTO,      ±±
±±º          ³ PROJETO, CAMADA E CLASSE ORCAMENTARIA NO TITULO SE1        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M040SE1()

Local aArea    := SE1->(GetArea()) 
Local aAreaSD2 := SD2->(GetArea())

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+SF2->(F2_SERIE+F2_DOC))

//While SE1->(!Eof()) .And. SF2->(F2_FILIAL+F2_SERIE+F2_DOC) == xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM
While SE1->(!Eof()) .And. SF2->(F2_SERIE+F2_DOC+F2_CLIENTE) == SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_CLIENTE
//	If Empty(SE1->E1_CREDIT)    
		DbSelectArea("SC6")
		DbSetOrder(4)
		DbSeek(xFilial("SC6")+SF2->(F2_DOC+F2_SERIE))
			SE1->(RecLock("SE1",.F.))
				SE1->E1_CLVLCR := SC6->C6_XCLASS
				SE1->E1_CCC    := SC6->C6_XCCUSTO 
				SE1->E1_ITEMC  := SC6->C6_XITEM
				SE1->E1_EC05CR := SC6->C6_EC05CR  
				SE1->(MsUnlock())
//	EndIf

	SE1->(dbSkip())
EndDo
	
RestArea(aArea)
RestArea(aAreaSD2)

Return