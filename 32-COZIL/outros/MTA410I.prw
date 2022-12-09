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
				                  						
				If (SC5->C5_XTPPV = "L")
					SC6->C6_XSTATUS 	:= "1"                 // No caso de licitacoes o status passa para projetos
				Else
					SC6->C6_XSTATUS 	:= "3"                 // Para Status do Painel do Pedido de Venda ir para desenvolvimento	
				EndIF
								  
				SC6->C6_XDTPRJ	:= CToD("  /  /    ")
				SC6->C6_XHRPRJ	:= ""
				SC6->C6_XDTAPR := CToD("  /  /    ")
				SC6->C6_XHRAPR	:= ""
				SC6->C6_XDTDES := CToD("  /  /    ")
				SC6->C6_XHRDES	:= ""
				SC6->C6_XDTPRG	:= CToD("  /  /    ")
				SC6->C6_XHRPRG := ""
				SC6->C6_XDTCRT	:= CToD("  /  /    ")
				SC6->C6_XHRCRT	:= ""
				SC6->C6_XDTMTG	:= CToD("  /  /    ")
				SC6->C6_XHRMTG	:= ""
				SC6->C6_XDTEXP	:= CToD("  /  /    ")
				SC6->C6_XHREXP	:= ""
				SC6->C6_XDTLOG	:= CToD("  /  /    ")
				SC6->C6_XHRLOG	:= ""
				SC6->C6_XOBSPRJ	:= ""
				SC6->C6_XUSRDES	:= ""
				SC6->C6_XOBSAPR	:= ""
				SC6->C6_XOBSDES	:= ""
				SC6->C6_XOBSPRG	:= ""
				SC6->C6_XOBSCRT	:= ""
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
						
			//RETIRA OS PEDIDOS DE REMESSA E RETORNO DE TODAS AS EMPRESAS
			If SC5->C5_XTPPV = "R" .Or. SC5->C5_XTPPV = "O"   
				SC6->C6_XFILTRO := "1"				
			EndIf			
			
			//VOLTA FLAG DE ALTERACAO PARA .F.
			SC6->C6_XALTERA := .F.			
			
			//COPIA O COMPO SETOR COMERCIAL PARA O ITEM DO PEDIDO (UTILIZADO NA CUSTOMIZACAO DO PAINEL)
			SC6->C6_XTPPV := SC5->C5_XTPPV
						
		MsUnlock()
   		
Return()