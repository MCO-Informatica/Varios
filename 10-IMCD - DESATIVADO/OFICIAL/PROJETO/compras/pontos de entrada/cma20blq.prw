#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CMA20BLQ  ºAutor  ³Junior Carvalho     º Data ³  30/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina valida o Valor do Unitário do Pedido convertido no  º±±
±±º          ³ valor do Dia da Emissão da Nota, essa rotina só faz a      º±±
±±º          ³ validação para pedidos com moeda diferente de Real.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function  CMA20BLQ()

Local lRet := PARAMIXB[1]
Local nDecimalPC:= TamSX3("C7_PRECO")[2]
local txMoeda := 0

IF !( IsInCallStack("U_CENTNFEXM") )   // TIRAR QUANDO A FABRITECH RESOLVER
	If lRet
		If SC7->C7_MOEDA <> 1
			
			//dEmisNF := IIF( IsInCallStack("U_CENTNFEXM") , __dDataE , dDEmissao )
			dEmisNF := dDEmissao
			dbselectarea("SM2")
			DbSetOrder(1)
			If DbSeek(dEmisNF)
				
				Do Case
					Case SC7->C7_MOEDA == 2
						txMoeda := SM2->M2_MOEDA2
					Case SC7->C7_MOEDA == 4
						txMoeda := SM2->M2_MOEDA4
					Case SC7->C7_MOEDA == 5
						txMoeda := SM2->M2_MOEDA5
					Case SC7->C7_MOEDA == 6
						txMoeda := SM2->M2_MOEDA6
				EndCase
				
				dbSelectArea("AIC")
				dbSetOrder(2)
				MsSeek(xFilial("AIC")+Space(8)+SC7->C7_PRODUTO)
				
				nPrecoPCM2 := SC7->C7_PRECO
				nPrecoNFM2 := SD1->D1_VUNIT /  txMoeda
				
				lRet := ROUND(nPrecoNFM2,nDecimalPC) >= ROUND(nPrecoPCM2,nDecimalPC)*(1+(AIC->AIC_PPRECO)/100)
			Else
				Alert("Pedido Bloqueado pois não há Moeda Cadastrada do Dia - "+DTOC(dEmisNF))
			Endif
		Endif
		
	Endif
Endif

Return(lRet)
