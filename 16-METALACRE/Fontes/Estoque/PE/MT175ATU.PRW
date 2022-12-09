#include 'Protheus.ch'
#INCLUDE "TopConn.ch"  
#INCLUDE "RWMAKE.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT175ATU  ºAutor  ³Bruno Daniel Abrigo º Data ³  28/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos liberar\rejeitar baixa CQ            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MT175ATU()
//Considerando que ponto de entrada sempre dever guardar as areas e restaurar antes de sair
//D7-> JA POSICIONADA
//Avaliar todos os pontos com a palavra ERRO
Local nEmQuant	:=0
Local nEmQtOri	:=0
Local lRet	  	:=.T.
Local nPosSeq	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_SEQ"})
Local nPosTip	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_TIPO"})
Local nPosEst	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_ESTORNO"})
Local nPosLote	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_LOTECTL"})
Local nPosProd	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_PRODUTO"})
Local nPosQtd	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_QTDE"})
Local nPosAlmox	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_LOCDEST"})
Local nPosAlOri	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_LOCAL"})
Local nPosQtdSld:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_SALDO"}) 
Local nPosNumSeq:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_NUMSEQ"})    
Local nPosLib	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_LIBERA"})  
Local nPosOP	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D7_TEMOP"})
Local lOk		:=.F.                 
Local nSaldo    := 0
Private aAreaSD4:=SD4->(GetArea())
Private aAreaSD7:=SD7->(GetArea())
Private aAreaSB1:=SB1->(GetArea())
Private aAreaSC2:=SC2->(GetArea())
Private aArea   :=GetArea()
Private nQtdOri := aCols[1,nPosQtd] 
Private	lEmpPrev		:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)


If cEmpAnt <> '01'
	Return
Endif


If lEstorno              
	FOR IK := 1 TO LEN(ACOLS)
		nSaldo := ACOLS[IK,nPosQtdSld] 
	NEXT IK 
	
	RestAllArea()
	Return lRet
Endif

// aqui vai fazer o link com o lote e a OP   
// vai pegar a linha e vai confrontar com a tabela nova.
	FOR IK := 1 TO LEN(ACOLS)  
		IF !EMPTY(ACOLS[IK,nPosEst]) .OR. ACOLS[IK,nPosTip] <> 1  .OR. (ACOLS[IK,nPosOP]) 
		
		ELSE
			nSaldo := ACOLS[IK,nPosQtdSld]  
			If ACOLS[IK,nPosTip] == 1  .AND. !(ACOLS[IK,nPosOP]) 
				ACOLS[IK,nPosOP] := .T.
				dbSelectarea("SC2")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SC2") + ALLTRIM(SD7->D7_LOTECTL))   
				DO WHILE !SC2->(EOF()) .AND. (SC2->C2_NUM+SC2->C2_ITEM) == ALLTRIM(SD7->D7_LOTECTL)
	            	IF ALLTRIM(SC2->C2_PRODUTO) == ALLTRIM(SD7->D7_PRODUTO)
						DBSELECTAREA("Z07")
						Z07->(DBGOTOP())
						RECLOCK("Z07",.T.)
						Z07->Z07_FILIAL := xFilial("SD7")
						Z07->Z07_PRODUT := SC2->C2_PRODUTO
						Z07->Z07_DESCP  := SUBSTR(U_PROCURA(SC2->C2_PRODUTO,"B1_DESC","SB1","B1_COD"),1,50)
						Z07->Z07_QTDEL  := ACOLS[IK,nPosQTD]
						Z07->Z07_LOCAL  := ACOLS[IK,nPosAlmox] 
						Z07->Z07_OP     := SUBSTR(ALLTRIM(SD7->D7_LOTECTL),1,6)
						Z07->Z07_ITEM   := SUBSTR(ALLTRIM(SD7->D7_LOTECTL),7,2)
						Z07->Z07_QTDEO  := SC2->C2_QUJE
						Z07->Z07_ENTREG := SC2->C2_EMISSAO
						Z07->Z07_SALDO  := ACOLS[IK,nPosQTD] - SC2->C2_QUJE
						Z07->Z07_SEQ    := SC2->C2_SEQUEN    
						Z07->Z07_LOTE   := SD7->D7_LOTECTL
						Z07->(MSUNLOCK())	
	                     
						If !empty(SC2->C2_PEDIDO)
							DBSELECTAREA("SC9")
							DBSETORDER(1)
							IF DBSEEK(XFILIAL("SC9") + SC2->C2_PEDIDO + SC2->C2_ITEMPV )
								IF ALLTRIM(SC2->C2_PRODUTO) == ALLTRIM(SC9->C9_PRODUTO)
									RECLOCK("SC9",.F.)
									SC9->C9_LOTECTL := SD7->D7_LOTECTL
									
									// Busca Saldo do Lote	3L Systems 21-07-15       
									// Libera o Pedido Apenas se o Saldo do Lote For Igual ou Superior a Quantidade do Pedido de Vendas
									
									nSaldo:=ACOLS[IK,nPosQTD]
									If SB8->(dbSetOrder(3), dbSeek(xFilial("SB8")+SC9->C9_PRODUTO+SC9->C9_LOCAL+SC2->C2_NUM+SC2->C2_ITEM))
										While SB8->(!EOF()) .And. AllTrim(xFilial("SB8")+SC9->C9_PRODUTO+SC9->C9_LOCAL+SC2->C2_NUM+SC2->C2_ITEM)==AllTrim(SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL))
											nSaldo+=SB8SALDO(,,,,,lEmpPrev,,,.T.)
											
											SB8->(dbSkip(1))
										Enddo
									Endif

									If nSaldo >= SC9->C9_QTDLIB									
										SC9->C9_BLEST   := '' 
									Endif
									SC9->(MSUNLOCK())
								ENDIF
							ENDIF   
							
							DBSELECTAREA("SC6")
							DBSETORDER(1)
							IF DBSEEK(XFILIAL("SC6") + SC2->C2_PEDIDO + SC2->C2_ITEMPV )
								IF ALLTRIM(SC2->C2_PRODUTO) == ALLTRIM(SC6->C6_PRODUTO)
									RECLOCK("SC6",.F.)
									SC6->C6_LOTECTL := SD7->D7_LOTECTL
									SC6->(MSUNLOCK())
								ENDIF
							ENDIF 
							
					    ENDIF
 /*
						DBSELECTAREA("SD4")
						DBSETORDER(2) // OP + CODIGO + LOCAL
						IF DBSEEK(XFILIAL("SD4") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_PRODUTO + SC2->C2_LOCAL )
							RECLOCK("SD4",.F.)
								SD4->D4_LOTECTL := SD7->D7_LOTECTL
							SD4->(MSUNLOCK())
						ENDIF
					                   */
/*						DBSELECTAREA("SD7")
						RECLOCK("SD7",.F.)
						SD7->D7_TEMOP := .T.
						SD7->(MSUNLOCK()) */
	    			ENDIF
					DBSELECTAREA("SC2")
					SC2->(DBSKIP())
				ENDDO	
			ENDIF	
		ENDIF
	NEXT IK 


 
	 
	
	
	
	
	
RestAllArea()

                                                                  

// fim
Static Function RestAllArea()

RestArea(aArea)
RestArea(aAreaSD4)
RestArea(aAreaSD7)
RestArea(aAreaSB1)
RestArea(aAreaSC2)

Return


