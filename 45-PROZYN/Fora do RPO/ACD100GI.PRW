/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACD100GI  ºAutor  ³NBC                 º Data ³  17/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada da geraçao da Ordem de Separacao          º±±
±±º          ³ Utilizada para gerar array com as quantiadades fracionadas º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD100GI()
	Local nQtdEmb := SB1->B1_QE //SB1 esta posicionado
	Local nQtdMul := 0
	Local nQtdDif := 0
	Local aArea   := GetArea()

	//O ponto de entrada esta posicionado ente o Reclock e o msunlock da CB8

	//Pegar a quantidade por embalagem do produto e calcular diferença
	nQtdMul := Int(CB8->CB8_QTDORI/nQtdEmb)
	nQtdDif := CB8->CB8_QTDORI % nQtdEmb   
	nQtdB01 := int(nQtdDif)
	nQtdB02 := nQtdDif - int(nQtdDif)
    If Localiza(SD4->D4_COD)
       AViso('Com Endereço',SD4->D4_COD,{'OK'})
	else
       AViso('Sem Endereço',SD4->D4_COD,{'OK'})
	EndIf	   
    AViso('Endereço',CB8->CB8_LCALIZ,{'OK'})
	If nQtdDif > 0

		//Gravar a diferença restante que não seja multiplo da embalagem para criar uma nova ord sep
		DbSelectArea("SZT")
		DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP+ZT_ITEM+ZT_PROD+ZT_LOCAL+ZT_LOTECTL

		RecLock("SZT", .T.)

		SZT->ZT_FILIAL  := CB8->CB8_FILIAL
		SZT->ZT_ORDSEP  := CB8->CB8_ORDSEP
		SZT->ZT_ITEM    := CB8->CB8_ITEM
		SZT->ZT_PROD    := CB8->CB8_PROD
		SZT->ZT_LOCAL   := CB8->CB8_LOCAL
		SZT->ZT_LOTECTL := CB8->CB8_LOTECT
		SZT->ZT_LCALIZ  := CB8->CB8_LCALIZ
		SZT->ZT_QTDORI  := CB8->CB8_QTDORI
		SZT->ZT_QTDMUL  := nQtdMul * nQtdEmb //Multiplicar para obter a quantidade em unidades
		SZT->ZT_QTDDIF  := nQtdDif   
		SZT->ZT_QTDB01  := nQtdB01 
		SZT->ZT_QTDB02  := nQtdB02 	
		SZT->ZT_DATA    := Date()
		SZT->ZT_HORA    := Time()
		SZT->ZT_USUARIO := cUserName
		SZT->ZT_OP		:= CB8->CB8_OP

		SZT->(MsUnlock())

		//Se houver fraçao, mudar a quantidade para o valor multiplo
		CB8->CB8_QTDORI := nQtdMul * nQtdEmb
		CB8->CB8_SALDOS := nQtdMul * nQtdEmb

		If nEmbalagem == 1
			CB8->CB8_SALDOE := nQtdMul * nQtdEmb
		EndIf

		//Se a quantidade multipla for 0, deletar item da CB8
		If SZT->ZT_QTDMUL == 0
			CB8->(DbSetOrder(1))//CB8_FILIAL, CB8_ORDSEP, CB8_ITEM, CB8_SEQUEN, CB8_PROD, R_E_C_N_O_, D_E_L_E_T_
			If CB8->(DbSeek(xFilial("CB8")+SZT->ZT_ORDSEP+SZT->ZT_ITEM))
				RecLock("CB8",.F.)
				CB8->(DbDelete())
				CB8->(MsUnlock())
			EndIf
		EndIf
	

	EndIf

	RestArea(aArea)

Return
