#include "Protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³João Zabotto      º Data ³  23/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mensagens adicionais para a danfe.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PE01NFESEFAZ
	Local xArea	    := GetArea()
	Local aProd		:= PARAMIXB[1]
	Local cMensCli	:= PARAMIXB[2]
	Local cMensFis	:= PARAMIXB[3]
	Local aDest 	:= PARAMIXB[4]
	Local aNota 	:= PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl		:= PARAMIXB[7]
	Local aTransp	:= PARAMIXB[8]
	Local aEntrega	:= PARAMIXB[9]
	Local aRetirada	:= PARAMIXB[10]
	Local aVeiculo	:= PARAMIXB[11]
	Local aReboque	:= PARAMIXB[12]
	Local aRet      := {}

	Local cDescaux  := ''

	If aNota[4] == "1"     && Mensagens para as notas ficais de SAIDA.

		&& Adiciono o codigo + loja do cliente a razão social do cliente impressa na danfe
		aDest[2]:= SF2->(F2_CLIENTE + "/" + F2_LOJA) + "-"  + aDest[2]

		&&Adiciona a mensagem do endereco de entrega
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

			If !Empty(SA1->A1_ENDENT)
				If Alltrim(SA1->A1_END) != Alltrim(SA1->A1_ENDENT)

					cMensCli += " LOCAL DE ENTREGA: "+Alltrim(SA1->A1_ENDENT)

					If !Empty(SA1->A1_BAIRROE)
						cMensCli += " Bairro: "+Alltrim(SA1->A1_BAIRROE)
					EndIf

					If !EMpty(SA1->A1_MUN)
						cMensCli += " Mun: "+Alltrim(SA1->A1_MUN)
					EndIf

					If !EMpty(SA1->A1_EST)
						cMensCli += " UF: "+Alltrim(SA1->A1_EST)
					EndIf

					If !Empty(SA1->A1_CEP)
						cMensCli += " CEP:"+Alltrim(SA1->A1_CEP)
					EndIf
				EndIf
			EndIf
		EndIf
		&&Fim mensagem do endereco de entrega

		&&Bloco de codigo para trazer o valor liquido do titulos
		nX := 0
		For nX := 1 to Len(aDupl)
			nAbatim := 0

			SE1->(DbSetOrder(1))
			If SE1->(DbSeek(xFilial("SE1")+aDupl[nX][1]))

				while SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA == aDupl[nX][1]

					If Alltrim(SE1->E1_TIPO) == "NF"
						nAbatim := (SE1->E1_VALOR - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA))
					EndIf

					SE1->(DbSkip())
				End

				if nAbatim > 0
					aDupl[nX][3] := nAbatim
				EndIf

			EndIf
		Next nX

		If aNota[5] == "N"
			lAddMsg := .F.

			&& Adiciona mensagem de PIS e COFINS RETIDO
			For nX := 1 to Len(aProd)
				If Alltrim(aProd[nX][7]) == "5101"
					lAddMsg := .T.
				EndIf
				SB1->(DbSetORder(1))
				If SB1->(DbSeek(xFilial('SB1') + aProd[nX,2]))
					cDescaux:= U_GETPDESC(aProd[nX,2])
					If !Empty(cDescaux)
						aProd[nX,4]:= cDescaux
					EndIf
				EndIf
			Next nX

			If lAddMsg
				If SF2->F2_VALPIS > 0 .AND. SF2->F2_VALCOFI > 0
					cMensFis += " RETENÇÃO de 0,10% PIS R$ " + Alltrim(Transform(SF2->F2_VALPIS, "@999,999,999.99"))
					cMensFis += " RETENÇÃO de 0,50% COFINS R$ " + Alltrim(Transform(SF2->F2_VALCOFI, "@999,999,999.99"))
				EndIf
			EndIf
			&& Fim mensagem de PIS e COFINS RETIDO.

			nX:= 0
			For nX := 1 to Len(aInfoItem)
				If !aInfoItem[nX,1] $ cMensFis
					If !"Ped.Venda: " $ cMensFis
						cMensFis += "Ped.Venda: " + aInfoItem[nX,1]
					Else
						cMensFis+= '/' +  aInfoItem[nX,1]
					EndIf
				EndIf
			Next nX
		EndIf

		SZZ->(DbSetOrder(1))
		If SZZ->(DbSeek(xFilial('SZZ') + SF2->('S' + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)))
			While !SZZ->(Eof()) .And. SF2->('S' + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) == ;
					SZZ->(ZZ_TIPODOC + ZZ_DOC + ZZ_SERIE + ZZ_CLIFOR + ZZ_LOJA)

				If !AllTrim(SZZ->ZZ_CODMENS) $ cMensCli
					cMensCli += AllTrim(SZZ->ZZ_TXTMENS) + '/'
				EndIf
				SZZ->(DbSkip())
			EndDo
		EndIf
	Else && Mensagens para as notas ficais de ENTRADA.

	EndIf

	RestArea(xArea)

	Return({aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque})

