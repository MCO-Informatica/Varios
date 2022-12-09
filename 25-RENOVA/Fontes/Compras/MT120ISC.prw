#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
;±±ºPrograma  ³MT120ISC  ºAutor  ³Totvs               º Data ³  16/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada para preencher dados adicionais na impor-  º±±
±±º          ³tacao dos solicitações de compra, no documento de entrada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120ISC()

Local aAlias := GetArea()
Local aSC1Alias := SC1->(GetArea())
Local _nCntFor := 0

For _nCntFor := 1 To Len(aHeader)
	
	Do Case                                              
		Case Trim(aHeader[_nCntFor,2]) == "C7_XCONTRA"    //Fontes Renova - Compatibilização 23/10/2015
			aCols[Len(aCols),_nCntFor] := SC1->C1_XCONTRA //Fontes Renova - Compatibilização 23/10/2015
		Case Trim(aHeader[_nCntFor,2]) == "C7_XIMCURS"
			aCols[Len(aCols),_nCntFor] := SC1->C1_XIMCURS
		Case Trim(aHeader[_nCntFor,2]) == "C7_XPROJIM"
			aCols[Len(aCols),_nCntFor] := SC1->C1_XPROJIM
	EndCase
	
Next _nCntFor

RestArea( aSC1Alias )
RestArea( aAlias )

Return Nil