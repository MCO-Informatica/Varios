#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CadVoucherº Autor ³ Darcio R. Sporl    º Data ³  14/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida o voucher informado no pedido do Hardware Avulso.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ValVouHA(aProdutos, cNumVou, nQtdVou)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicoes do aProduto ³
//³[1]Item              ³
//³[2]Codigo Produto    ³
//³[3]Quantidade        ³
//³[4]Valor Unitario    ³
//³[5]Valor com desconto³
//³[6]Valor Total       ³
//³[7]Data da Entrega   ³
//³[8]TES               ³
//³[9]Numero Voucher    ³
//³[10]Saldo Voucher    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nI		:= 0
Local lRet		:= .T.
Local cMensagem	:= ""

DbSelectArea("SZF")
DbSetOrder(1)	// ZF_FILIAL + ZF_COD
If !DbSeek(xFilial("SZF") + cNumVou)	// Verifico se o numero do voucher existe
	lRet		:= .F.
	cMensagem	:= "O voucher informado não existe."
Else
	If Date() > SZF->ZF_DTVALID			// Verifico se o voucher esta dentro da validade
		lRet 		:= .F.
		cMensagem	:= "O voucher informado está fora da validade."
	Else
		For nI := 1 To Len(aProdutos)	// Verifico se o voucher tem saldo para ser utilizado
			DbSelectArea("SZF")
			DbSetOrder(1)
			If DbSeek(xFilial("SZF") + aProdutos[nI, 9])
				If SZF->ZF_ATIVO == "N"
					lRet		:= .F.
					cMensagem	:= "O voucher informado não está ativo."
				Else
					If SZF->ZF_PRODUTO == aProdutos[nI, 2]
						If SZF->ZF_SALDO < Val(AllTrim(aProdutos[nI, 3]))
							lRet		:= .F.
							cMensagem	:= "O voucher informado não tem saldo para ser utilizado."
						EndIf
					Else
						lRet		:= .F.
						cMensagem	:= "O produto não corresponde ao produto cadastrado no voucher."
					EndIf
				EndIf
			Else
				lRet		:= .F.
				cMensagem	:= "O voucher informado não foi encontrado."
			EndIf
		Next nI
	EndIf
EndIf

Return({lRet, cMensagem})