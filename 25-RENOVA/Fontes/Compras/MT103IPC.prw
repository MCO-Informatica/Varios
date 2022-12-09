#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IPC  ºAutor  ³Totvs               º Data ³  16/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada para preencher dados adicionais na impor-  º±±
±±º          ³tacao dos pedidos de compra, no documento de entrada.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103IPC()

//Local _lExecuta := PARAMIXB[1]
Local aAlias := GetArea()
Local aSC7Alias := SC7->(GetArea())
Local _nCntFor := 0

//If _lExecuta = 1 //FB - 15/03/16 - Alterado pois soh executava quando fosse a primeira linha do acols.

	For _nCntFor := 1 To Len(aHeader)   
	
		Do Case
			Case Trim(aHeader[_nCntFor,2]) == "D1_XCONTRA"    //Fontes Renova - Compatibilização 23/10/2015
				aCols[Len(aCols),_nCntFor] := SC7->C7_XCONTRA //Fontes Renova - Compatibilização 23/10/2015
			Case Trim(aHeader[_nCntFor,2]) == "D1_NATURE"     //Fontes Renova - Compatibilização 23/10/2015
				aCols[Len(aCols),_nCntFor] := SC7->C7_NATURE //Fontes Renova - Compatibilização 23/10/2015 
			Case Trim(aHeader[_nCntFor,2]) == "D1_XIMCURS"
				aCols[Len(aCols),_nCntFor] := SC7->C7_XIMCURS
			Case Trim(aHeader[_nCntFor,2]) == "D1_XPROJIM"
				aCols[Len(aCols),_nCntFor] := SC7->C7_XPROJIM
		EndCase
		
	Next _nCntFor
	
//EndIf

RestArea( aSC7Alias )
RestArea( aAlias )

Return Nil