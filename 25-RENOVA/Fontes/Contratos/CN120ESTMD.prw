#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120ESTMDºAutor  ³Carlos Tagliaferri  º Data ³  Fev/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Deleta titulos a pagar gerados diretamente pela medicao.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120ESTMD()
       
Local _aArea 	:= GetArea()
Local aAreaCNX  := CNX->(GetArea())

Local cNumContr := ""
Local cRevisao	:= ""
Local cNumMed	:= ""
Local aNumero	:= {} 
Local nCount	:= 0    
Local nReg		:= 0

/* NAO DELETA MAIS, AGORA O PADRÃO SE ENCARREGA DE EXCLUIR O TITULO.
Local aRotAuto := {}

Private lMsErroAuto := .F.

If !Empty(CND->CND_XTITPG)
	dbSelectArea("SE2")
	dbSetOrder(6)
	If dbSeek(xFilial("SE2") + CND->CND_FORNEC + CND->CND_LJFORN + ALLTRIM(CND->CND_XTITPG))
	                       
		BEGIN TRANSACTION
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui titulo a pagar                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AAdd( aRotAuto, { "E2_NUM"    , SE2->E2_NUM     , NIL } )
			AAdd( aRotAuto, { "E2_PREFIXO", SE2->E2_PREFIXO , NIL } )
			AAdd( aRotAuto, { "E2_NATUREZ", SE2->E2_NATUREZ	 , NIL } )
			AAdd( aRotAuto, { "E2_PARCELA", SE2->E2_PARCELA	 , NIL } )
			AAdd( aRotAuto, { "E2_TIPO"   , SE2->E2_TIPO    , NIL } )
			AAdd( aRotAuto, { "E2_FORNECE", SE2->E2_FORNECE , NIL } )
			AAdd( aRotAuto, { "E2_LOJA"   , SE2->E2_LOJA    , NIL } )
			AAdd( aRotAuto, { "E2_VALOR"  , SE2->E2_VALOR   , NIL } )
			AAdd( aRotAuto, { "E2_EMISSAO", SE2->E2_EMISSAO , NIL } )
			AAdd( aRotAuto, { "E2_VENCTO" , SE2->E2_VENCTO	 , NIL } )
			AAdd( aRotAuto, { "E2_VENCREA", SE2->E2_VENCREA	 , NIL } )

			MSExecAuto({|x,y,z| FINA050(x,y,z)}, aRotAuto,, 5)
	
			If lMsErroAuto 	
				DisarmTransaction()
				MOSTRAERRO()
				RestArea(_aArea)
				Return()
			EndIf
	
		END TRANSACTION
	EndIf                    
EndIf

// Estorno da Medicao
// Excluir registros da CNX

cNumContr 	:= CND->CND_CONTRA
cRevisao	:= CND->CND_REVISA
cNumMed		:= CND->CND_NUMMED
 */

/*
	Pesquisa os adiantementos para depois pesquisar os adiantamentos parciais gerados.
*/		
DbSelectArea('CNX')
CNX->(DbSetOrder(1))
If CNX->(DbSeek(xFilial('CNX') + cNumContr ))
	  
	While CNX->(!Eof()) .And. xFilial('CNX') == CNX->CNX_FILIAL .And. CNX->CNX_CONTRA == cNumContr  
	
		If cNumMed == CNX->CNX_NUMMED 

			Aadd( aNumero, CNX->CNX_NUMERO )
						
		EndIf
					                                                                                     
		CNX->(DbSkip())
	EndDo                 
	
EndIf

CNX->(DbGoTop())

If CNX->(DbSeek(xFilial('CNX') + cNumContr ))
	  
	While CNX->(!Eof()) .And. xFilial('CNX') == CNX->CNX_FILIAL .And. CNX->CNX_CONTRA == cNumContr  
	
		If Empty(CNX->CNX_XORIGE)
			nCount ++		
		EndIf        
		
		nReg := CNX->(Recno())
	
		If !Empty(CNX->CNX_XORIGE) .And. Ascan( aNumero, {|x| x== CNX->CNX_XORIGE } ) > 0

			RecLock('CNX',.F.)
				DbDelete()	
			CNX->(MsUnlock())		
						
		EndIf
					                                                                                     
		CNX->(DbSkip())

	EndDo                 
	
EndIf  

If nCount > 1
	CNX->( DbGoTo(nReg) )
	RecLock('CNX',.F.)
		DbDelete()	
	CNX->(MsUnlock())		
EndIf
		  		  		  
RestArea( aAreaCNX )
RestArea(_aArea)

Return()