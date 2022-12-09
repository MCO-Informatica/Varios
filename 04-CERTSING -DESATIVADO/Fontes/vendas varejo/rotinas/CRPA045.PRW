#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma: CRPA045    ºAutor  ³Renato Ruy Bernardo º Data ³  01/11/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para atualizar consumo do voucher.				  º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPA045()

Local aPergs 	:= {}
Local cCodRec 	:= space(08)
Local lRet
Local nI		:= 0

Private aVouchers:= {}
Private aRet 	:= {}
Private cPedIn	:= ""
Private cPerg   := "CRP045"

//ValidPerg()
//pergunte(cPerg,.T.)  

aAdd( aPergs ,{11,"Vouchers"		,"",'.T.','.T.',.F.})

If !ParamBox(aPergs ,"Atualiza Consumo de Vouchers",aRet)
	Alert("A atualizacao foi cancelada!")
	Return
EndIf

//Cria um array para não estourar a quantidade de pedidos
aVouchers := StrToArray(aRet[1],chr(13)+chr(10))

Processa( {|| GerReg() }, "Selecionando registros...")

Return

//Processamento do relatório

Static Function GerReg

Local nI	:= 0

	SZG->(DbSetOrder(1)) //Filial + Voucher
	SZF->(DbSetOrder(2)) //Filial + Voucher

For nI := 1 To Len(aVouchers)
	
	If SZF->(DbSeek( xFilial("SZF") + aVouchers[nI] )) .And. !Empty(aVouchers[nI])
		
		//Restaura o saldo
		Reclock("SZF",.F.)
			SZF->ZF_SALDO := 1
		SZF->(MsUnlock())
		
		If Select("QCRPA027") > 0
			DbSelectArea("QCRPA027")
			QCRPA027->(DbCloseArea())
		EndIf
		
		BeginSql Alias "QCRPA027"
			SELECT ZG_NUMVOUC VOUCHER, R_E_C_N_O_ RECNOZG FROM SZG010
			WHERE
			ZG_FILIAL = ' ' AND
			ZG_NUMVOUC = %Exp:SZF->ZF_COD% AND
			D_E_L_E_T_ = ' '
		EndSql
		
		SZG->(DbGoTo(QCRPA027->RECNOZG))
		
		If SZG->ZG_NUMVOUC == QCRPA027->VOUCHER .And. QCRPA027->RECNOZG > 0
			//Restaura o saldo
			If Reclock("SZG",.F.)
					DbDelete()
				SZG->(MsUnlock())
			Endif
		Endif
		
	Endif
Next

MsgInfo("A atualização dos saldos foi finalizada!")

Return 