#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410I   ºAutor  ³WILLIAM LUIZ        º Data ³  01/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de Entrada - APOS A GRAVACAO DOS ITENS DO PV         º±±
±±º          ³        										    º±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA410I()
	               
	Local cTpProd := ""
		//CHECA SE O ITEM DO PEDIDO DE VENDA FOI ALTERADO.
		//CASO TENHA SIDO ALTERADO MARCA O ITEM COMO 'EM PROJETOS' (COM. PUBLICO), OU 'EM DESENVOLVIMENTO' (COM. PRIVADO)
		//RESETA AS DATAS E HORAS DAS LIBERACOES ANTERIORMENTE EFETUADAS.
		     
		RecLock("SC6",.F.)
			If SC6->C6_XALTERA = .T.			
				                  						
				SC6->C6_XSTATUS 	:= "1"                 // Em todos os casos o status passa para projetos								  

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
				SC6->C6_XDTALM	:= CToD("  /  /    ")
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
				
				//VERIFICA O TIPO DO PRODUTO
				cTpProd		:= Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO, "B1_TIPO")
                    				
				//APENAS SERA GERADO PAINEL PEDIDO TIPOS: PA E PI			                                              
      			If cTpProd = "PA" .OR. cTpProd = "PI"
      				SC6->C6_XFILTRO	:= "2"
      			Else
      				SC6->C6_XFILTRO	:= "1"
      			EndIf
											
			EndIf                         			
			
			//RETIRA DO PAINEL OS PEDIDOS 
			//ANTIGOS DA COZIL COZINHAS LANCADOS NA COZIL EQUIPAMENTOS
			//ANTERIORES A 17/05/2012 (FILTRO = 1)  
			If xEmpresa() = "01" .And. SC5->C5_XTPPV = "S"				
				SC6->C6_XFILTRO	:= "1"
			EndIf			
						
			//RETIRA OS PEDIDOS DE DEVOLUÇÃO, OBRA E SEM PAINEL DE TODAS AS EMPRESAS
			If SC5->C5_XTPPV = "O" .Or. SC5->C5_XTPPV = "B" .Or. SC5->C5_XTPPV = "S"    
				SC6->C6_XFILTRO := "1"				
			EndIf			

			If IsInCallStack('A410Copia') // .and. _nOper == 6 // Identificar Cópia
				SC6->C6_XSTATUS := "1"				
			Endif

			//VOLTA FLAG DE ALTERACAO PARA .F.
			SC6->C6_XALTERA := .F.			
			
			//COPIA O COMPO SETOR COMERCIAL PARA O ITEM DO PEDIDO (UTILIZADO NA CUSTOMIZACAO DO PAINEL)
			SC6->C6_XTPPV := SC5->C5_XTPPV
						
		MsUnlock()
   		
Return()
