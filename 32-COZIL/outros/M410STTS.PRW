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
Local cFilSC5  	:= xFilial("SC5")
Local cPedido  	:= SC5->C5_NUM      

//[William] - adaptacao 
Local cTpProd		:= ""                                                          
//[FIM - William] - adaptacao

	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(cFilSc6+cPedido)
		While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == cFilSc6+cPedido
			RecLock("SC6",.F.)                                                                                                 
			
				//[William] 
				
				//VERIFICA O TIPO DO PRODUTO
				cTpProd		:= Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO, "B1_TIPO")
                    
   				//APENAS SERA GERADO PAINEL PEDIDO TIPOS: PA E PI			                                              
      			If cTpProd = "PA" .OR. cTpProd = "PI"
      				SC6->C6_XFILTRO	:= "2"
      			Else
      				SC6->C6_XFILTRO	:= "1"
      			EndIf
      			      							
				//A PARTIR DE 17/05/2012 NENHUM PEDIDO DA EMPRESA COZIL COZINHAS IRA GERAR PAINEL DE  
				//PEDIDOS. PARA TANTO SERA COLOCADO FILTRO = 1
				If xEmpresa() = "02" .And. SC5->C5_EMISSAO >= CToD("17/05/2012")
					SC6->C6_XFILTRO	:= "1"
				EndIf
				
				//RETIRA DO PAINEL OS PEDIDOS ANTIGOS DA COZIL COZINHAS LANCADOS NA COZIL EQUIPAMENTOS
				//ANTERIORES A 17/05/2012 (FILTRO = 1)  
				If xEmpresa() = "01" .And. SC5->C5_XTPPV = "S"				
					SC6->C6_XFILTRO	:= "1"
				EndIf
				
                //RETIRA OS PEDIDOS DE REMESSA, RETORNO E SEM PAINEL DE TODAS AS EMPRESAS
				If SC5->C5_XTPPV = "R" .Or. SC5->C5_XTPPV = "O"  
					SC6->C6_XFILTRO := "1"				
				EndIf			
						      		 
				SC6->C6_XALTERA := .F.
										      					        			
				//[FIM - William] - adaptacao   
				
			MsUnlock()
			dbSelectArea("SC6")
			dbSkip()
		EndDo
	EndIf

Return

