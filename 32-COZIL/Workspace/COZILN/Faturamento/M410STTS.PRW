#include "rwmake.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M410STTS ³ Autor ³ Elvis Kinuta	      ³ Data ³28.01.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para gravacao do campo XFILTRO            ³±±
±±³          ³ que quando = 1 nao aparece no Painel                       ³±±
±±³          ³ EXECUCAO: GRAVACAO DOS ITENS		 	                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410STTS() 

Local cFilSC6  	:= xFilial("SC6")
Local cPedido  	:= SC5->C5_NUM      
Local _nOper    := PARAMIXB[1]
//Local cFilSC5  	:= xFilial("SC5")

//[William] - adaptacao 
Local cTpProd		:= ""                                                          
//[FIM - William] - adaptacao

	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(cFilSc6+cPedido)
		While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == cFilSc6+cPedido
			RecLock("SC6",.F.)                                                                                                 
			
				//VERIFICA O TIPO DO PRODUTO
				cTpProd		:= Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO, "B1_TIPO")
                    
   				//APENAS SERA GERADO PAINEL PEDIDO TIPOS: PA E PI			                                              
      			If cTpProd = "PA" .OR. cTpProd = "PI"
      				SC6->C6_XFILTRO	:= "2"
      			Else
      				SC6->C6_XFILTRO	:= "1"
      			EndIf
      			      							
				//RETIRA DO PAINEL OS PEDIDOS ANTIGOS DA COZIL COZINHAS LANCADOS NA COZIL EQUIPAMENTOS
				//ANTERIORES A 17/05/2012 (FILTRO = 1)  
				If xEmpresa() = "01" .And. SC5->C5_XTPPV = "S"				
					SC6->C6_XFILTRO	:= "1"
				EndIf
				
				//RETIRA OS PEDIDOS DE DEVOLUÇÃO, OBRA E SEM PAINEL DE TODAS AS EMPRESAS
				If SC5->C5_XTPPV = "O" .Or. SC5->C5_XTPPV = "B" .Or. SC5->C5_XTPPV = "S"    
					SC6->C6_XFILTRO := "1"				
				EndIf			

				If IsInCallStack('A410Copia') .and. _nOper == 6 // Identificar Cópia
					SC6->C6_XSTATUS := "1"				
					SC6->C6_XDTPRJ	:= CToD("  /  /    ")
					SC6->C6_XHRPRJ	:= ""
					SC6->C6_XDTAPR := CToD("  /  /    ")
					SC6->C6_XHRAPR	:= ""
					SC6->C6_XDTPCP := CToD("  /  /    ")
					SC6->C6_XHRPCP	:= ""
					SC6->C6_XDTDES := CToD("  /  /    ")
					SC6->C6_XHRDES	:= ""
					SC6->C6_XDTPRG	:= CToD("  /  /    ")
					SC6->C6_XHRPRG := ""
					SC6->C6_XDTCRT	:= CToD("  /  /    ")
					SC6->C6_XHRCRT	:= ""
					SC6->C6_XDTDOB	:= CToD("  /  /    ")
					SC6->C6_XHRDOB	:= ""
					SC6->C6_XDTALM	:= CToD("  /  /    ")
					SC6->C6_XHRALM	:= ""
					SC6->C6_XDTMTG	:= CToD("  /  /    ")
					SC6->C6_XHRMTG	:= ""
					SC6->C6_XDTEXP	:= CToD("  /  /    ")
					SC6->C6_XHREXP	:= ""
					SC6->C6_XDTLOG	:= CToD("  /  /    ")
					SC6->C6_XHRLOG	:= ""
					SC6->C6_XOBSPRJ	:= ""
					SC6->C6_XUSRDES	:= ""
					SC6->C6_XOBSAPR	:= ""
					SC6->C6_XOBSPCP	:= ""
					SC6->C6_XOBSDES	:= ""
					SC6->C6_XOBSPRG	:= ""
					SC6->C6_XOBSCRT	:= ""
					SC6->C6_XOBSDOB	:= ""
					SC6->C6_XOBSALM	:= ""
					SC6->C6_XOBSMTG	:= ""
					SC6->C6_XOBSEXP	:= ""
					SC6->C6_XOBSLOG	:= ""
				Endif

				SC6->C6_XALTERA := .F.
										      					        			
				//[FIM - William] - adaptacao   
				
			MsUnlock()
			dbSelectArea("SC6")
			dbSkip()
		EndDo
	EndIf

Return

