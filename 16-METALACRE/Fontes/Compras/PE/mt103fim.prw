#include "Protheus.ch"
#Define cENTER      Chr(13) + Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³ Luiz Alberto       º Data ³  02/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Corrigir Lote de Notas de Devolução  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103FIM()
Local nOpcao    := PARAMIXB[1] 		// Opção Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2] 		//
Local aArea	:= GetArea()
Local cNfSaida	:= ''
Local cSeSaida	:= ''    
Local cClSaida	:= ''
Local cLjSaida	:= ''
Local lProduzX  := GetNewPar("MV_PRDOPX",.T.)

If nConfirma == 1 .and. nOpcao == 3   
	If SF1->F1_TIPO == 'D'	// Somente para Notas de Entrada por Devolução
		If SD1->(dbSetOrder(1), dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			While SD1->(!Eof()) .And. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) .And. SD1->D1_FILIAL == xFilial("SD1")
				cLoteAnt	:= SD1->D1_LOTECTL
				
				If !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI)	// Se Estiver Feito o Retorno por Rotina Padrão Então os 3 Campos estarão preenchidos
					If SD2->(dbSetOrder(3), dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SF1->F1_FORNECE+SF1->F1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI))
						cLoteCtl := SD2->D2_LOTECTL
						
						// Preenche a Nota e Serie de Saida
						
						If Empty(cNfSaida)
							cNfSaida	:= SD2->D2_DOC
							cSeSaida	:= SD2->D2_SERIE
							cClSaida	:= SD2->D2_CLIENTE
							cLjSaida 	:= SD2->D2_LOJA
						Endif
						
						
						
						// Altera o Lote Gerado Automaticamente na SD1
						If RecLock("SD1",.f.)
							SD1->D1_LOTECTL	:= cLoteCtl
							SD1->(MsUnlock())
						Endif
						
						// Localizar a Movimentação na SD5 para Ajuste do Lote
						
						If SD5->(dbSetOrder(2), dbSeek(xFilial("SD5")+SD1->D1_COD+SD1->D1_LOCAL+cLoteAnt))
							If RecLock("SD5",.f.)
								SD5->D5_LOTECTL	:= cLoteCtl
								SD5->(MsUnlock())
							Endif
						Endif
						
						// Localizar a Movimentação na SB8 para Ajuste do Lote
						
						If SB8->(dbSetOrder(3), dbSeek(xFilial("SB8")+SD1->D1_COD+SD1->D1_LOCAL+cLoteAnt))
							If RecLock("SB8",.f.)
								SB8->B8_LOTECTL	:= cLoteCtl
								SB8->(MsUnlock())
							Endif
						Endif
					Endif
				Endif
				
				SD1->(dbSkip(1))
			Enddo 
		Endif
	ElseIf lProduzX .And. SF1->F1_TIPO == 'N'	// se Apontamento Automatico de OP's iniciadas em X estiver habilitado
/*		aNumOP	:=	{}
		
		If SD1->(dbSetOrder(1), dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			While SD1->(!Eof()) .And. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) .And. SD1->D1_FILIAL == xFilial("SD1")
				If !Empty(SD1->D1_OP) .And. Left(SD1->D1_OP,1) == 'X'
					AAdd(aNumOp,{SD1->D1_OP,SD1->D1_QUANT,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_LOCAL})
				Endif
				
				SD1->(dbSkip(1))
			Enddo
		Endif
	
		Begin Transaction
		
		If !Empty(Len(aNumOp))
			ProcRegua(Len(aNumOp))
			For nI:=1 to Len(aNumOp)
				IncProc("Aguarde Processando OP's -> " + aNumOp[nI,1] + "...Aguarde.")
		
				If SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+aNumOp[nI,1]))
					cFil := SC2->C2_FILIAL
					cNum := SC2->C2_NUM
					cIte := SC2->C2_ITEM
					cSeq := SC2->C2_SEQUEN
					nSld := (SC2->C2_QUANT - SC2->C2_QUJE)   
					nQtd := aNumOp[nI,2]          
					cLoc := aNumOp[nI,7]          
					
					SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			
					aDados := {}
					aAdd(aDados,{'D3_TM'     ,'010'                           ,Nil})
					aAdd(aDados,{'D3_COD'    ,SC2->C2_PRODUTO                 ,Nil})
					aAdd(aDados,{'D3_UM'     ,SB1->B1_UM                      ,Nil})
					aAdd(aDados,{'D3_QUANT'  ,nQtd                            ,Nil})
					aAdd(aDados,{'D3_LOCAL'  ,SC2->C2_LOCAL                   ,Nil})
					aAdd(aDados,{'D3_LOTECTL',aNumOp[nI,3]                    ,Nil})
					aAdd(aDados,{'D3_CONTA'  ,SB1->B1_CONTA                   ,Nil})
					aAdd(aDados,{'D3_EMISSAO',dDataBase                       ,Nil})
					aAdd(aDados,{'D3_TIPO'   ,SB1->B1_TIPO                    ,Nil})
					aAdd(aDados,{'D3_OP'     ,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) ,Nil})
					aAdd(aDados,{'D3_DOC'    ,aNumOp[nI,3]                    ,Nil})
					aAdd(aDados,{'D3_CC'     ,SC2->C2_CC                      ,Nil})
					aAdd(aDados,{'D3_PARCTOT',Iif(nQtd>=nSld,'T','P')         ,Nil})
					aAdd(aDados,{'D3_USUARIO',AllTrim(cUserName)+' *'         ,Nil})
			
				 	lMSErroAuto := .F.
			
					MSExecAuto({|x,y| mata250(x,y)},aDados,3)
					If lMsErroAuto
						MsgInfo("Falha No Processamento, Informe o T.I.!")
						Mostraerro()
						DisarmTransaction()
						Return .T.
					EndIf				
				Endif
				
			Next nI
		EndIf
		End Transaction
		
		MsgInfo("Processamento Finalizado!")
		
		Return */
	Endif
Endif
RestArea(aArea)
Return .t.
