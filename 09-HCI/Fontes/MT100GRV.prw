/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GRV  ºAutor  ³Rogerio Nagy        º Data ³  08/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui Produto x Fornecedor na inclusao da NF entrada com   º±±
±±º          ³dados do Quality, se nao existir e o parametro 05 estiver Okº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100GRV() 

Local nPosSB1 := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})   
Local nIndSA2 := SA2->(IndexOrd())
Local nIndSA5 := SA5->(IndexOrd())
Local nIndSB1 := SB1->(IndexOrd())
Local nRecSA2 := SA2->(Recno())
Local nRecSA5 := SA5->(Recno())
Local nRecSB1 := SB1->(Recno())

SA5->(dbSetOrder(1))
SB1->(dbSetOrder(1))
SA2->(dbSetOrder(1))
SA2->(MsSeek(xFilial("SA2")+cA100For + cLoja ))  

If lAmarra
	For nConta := 1 To Len(aCols)    
		If !SA5->(MsSeek(xFilial("SA5")+cA100For + cLoja + aCols[nConta,nPosSB1] )) 
			SB1->(MsSeek(xFilial("SB1")+aCols[nConta,nPosSB1]))  
			RecLock("SA5",.T.)
			SA5->A5_FILIAL  := xFilial("SA5")
			SA5->A5_FORNECE := cA100For 	
			SA5->A5_LOJA    := cLoja		
			SA5->A5_NOMEFOR := SA2->A2_NOME
			SA5->A5_PRODUTO := SB1->B1_COD
			SA5->A5_NOMPROD := SB1->B1_DESC
			SA5->A5_TEMPLIM := 6
			SA5->A5_SITU	:= "C"
			SA5->A5_FABREV  := "F" 
			MsUnlock()
		EndIf
	Next nConta
Endif                                                                               

SA2->(DbSetOrder(nIndSA2))
SA5->(DbSetOrder(nIndSA5))
SB1->(DbSetOrder(nIndSB1))
SA2->(DbGoTo(nRecSA2))
SA5->(DbGoTo(nRecSA5))
SB1->(DbGoTo(nRecSB1))

Return .t.