#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DLGQTDAB  ºAutor  ³Eduardo Felipe      º Data ³  04/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Passa a quantidade a ser ressuprida                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DLGQTDAB()

LOCAL cProduto  := PARAMIXB[1] //= Codigo do produto, cLocDest, cEstDest, cEndDest, nQtdAbas, aEndAbast
LOCAL cLocal    := PARAMIXB[2] //= Local referente ao endereço a ser reabastecido
LOCAL cStrDest  := PARAMIXB[3] //= Estrutura física referente ao endereço a ser reabastecido
LOCAL cEndDest  := PARAMIXB[4] //= Endereço a ser reabastecido
LOCAL nQTDAbast := PARAMIXB[5] //= Quantidade a ser transferida no processo de reabastecimento
LOCAL nQTDNorm  := 0
LOCAL lUM1      := .T.
LOCAL aAReaDC2  := DC2->( GetArea() )
LOCAL aAReaDC3  := DC3->( GetArea() )
LOCAL aAReaSB1  := SB1->( GetArea() )
LOCAL aAReaSB5  := SB5->( GetArea() )
LOCAL aAreaSBF  := SBF->( GetArea() )
LOCAL cEndOri   := PARAMIXB[6][1][5]
LOCAL nQtDest   := 0

SBF->( dbSetOrder(1) )
If SBF->( dbSeek(xFilial('SBF')+cLocal+cEndOri+cProduto) )
	nQtDest := SBF->BF_QUANT
EndIF

DC3->( dbSetOrder(2) )

If DC3->( dbSeek(xFIlial('DC3')+cProduto+cLocal+cStrDest) )
	
	DC2->( dbSetOrder(1) )
	
	If DC2->( dbSeek(xFIlial('DC2')+DC3->DC3_CODNOR) )
		
		SB5->( dbSetOrder(1) )
		
		If SB5->( dbSeek(xFIlial('SB5')+cProduto ))
			
			lUM1:= Iif ( SB5->B5_UMIND == '1',.t.,.f. )
			
			If lUM1
				nQTDNorm := DC2->( DC2_LASTRO * DC2_CAMADA )
			Else
				SB1->( dbSetOrder(1) )
				If SB1->( dbSeek(xFIlial('SB1')+cProduto ) )
					
					If SB1->B1_TIPCONV == 'D'
						nQTDNorm := DC2->( DC2_LASTRO * DC2_CAMADA )	* SB1->B1_CONV
					Else
						nQTDNorm := DC2->( DC2_LASTRO * DC2_CAMADA )	/ SB1->B1_CONV
					EndIf
					
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
EndIF

If nQTDNorm > 0
	If nQtDest < nQTDNorm
		nQTDNorm := nQtDest
	EndIF
	RestArea( aAReaDC2 )
	RestArea( aAReaDC3 )
	RestArea( aAReaSB1 )
	RestArea( aAReaSB5 )
	RestArea( aAreaSBF )
	Return nQTDNorm
Else
	Alert(' Nao foi possivel reabastecer com a norma de picking')
	RestArea( aAReaDC2 )
	RestArea( aAReaDC3 )
	RestArea( aAReaSB1 )
	RestArea( aAReaSB5 )
	RestArea( aAreaSBF )
	Return nQTDAbast
EndIF

Return