
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA261D3   ºAutor  ³Robson bueno        º Data ³  08/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Amarra norma de material na sb1 pela codificacao           º±±
±±º          ³ inteligente                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA261D3()
RecLock('SD3', .F.)
SD3->D3_LOTEFOR :=aCols[n,23]
MsUnlock() 
SD5->(dbSetOrder(3))
If SD5->(dbSeek(xFilial('SD5')+SD3->D3_NUMSEQ+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL,.F.))
  RecLock('SD5', .F.)
  SD5->D5_LOTEFOR :=aCols[n,23]
  MsUnlock()
EndIf
SB8->(dbSetOrder(3))
If SB8->(dbSeek(xFilial('SB8')+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL+SD3->D3_NUMLOTE,.F.))
  RecLock('SB8', .F.)
  SB8->B8_LOTEFOR :=aCols[n,23]
  MsUnlock()
EndIf


/*
RecLock('SD5', .F.)
SD5->D5_LOTEFOR :=aCols[n,22]
MsUnlock()
RecLock('SB8', .F.)
SB8->B8_LOTEFOR :=aCols[n,22]
MsUnlock()
*/
Return .T.    

   