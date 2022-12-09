#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA450I   ºAutor  ³Microsiga           º Data ³  01/27/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de Entrada- Liberacao de Credito de Pedido de        º±±
±±º          ³   Venda para gravar status do Painel de Pedido no SC6      º±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

//IMPORTANTE!!!!!!!!!!!!!

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄA8¿
//³ESTE FONTE ESTA COM ALGUMAS PARTES         ³
//³COMENTADAS.                                ³
//³ELAS SAO DA CUSTOMIZACAO DE VERIFICACAO DE ³
//³ESTOQUE NO PAINEL DE PEDIDO.               ³
//³                                           ³
//³FORAM COMENTADAS POIS O ESTOQUE AINDA NAO  ³
//³ESTA FUNCIONANDO CORRETAMENTE.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄA8Ù
ENDDOC*/
            


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³APOS 17/05/2012 NAO SERA MAS UTILIZADA A ROTINA³
//³DE APROVACAO DE CREDITO, ASSIM ESTE FONTE NAO  ³
//³SERA MAIS UTILIZADO                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

User Function MTA450I()
/*
	dbSelectArea("SC9")
	While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == SC9->C9_FILIAL+SC9->C9_PEDIDO 

	//_nQtdlib	:= SC9->C9_QTDLIB  		//VARIAVEIS UTILIZADAS PARA VERIFICACAO DE ESTOQUE
	//_cBlest		:= SC9->C9_BLEST

	RecLock("SC6",.F.)
	
		//VERIFICA SE O ITEM ESTA APTO A MUDANCA DE STATUS.
		If SC6->C6_XALTERA == .T.
		
			//If _cBlest =	" " 
			//	SC6->C6_XSTATUS := "7"
			//ElseIf _cBlest =="10"   
			//	SC6->C6_XSTATUS := "7"  
			//Else                  
				SC6->C6_XSTATUS := "1"
			//EndIf 
			SC6->C6_XALTERA := .F.
			
		EndIf                  
	
	MsUnlock()
	        
dbSelectArea("SC6")
	dbSkip()
EndDo
*/
 Return()
