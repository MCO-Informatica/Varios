#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110LOK º Autor ³  Junior Carvalho   º Data ³  17/07/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para validar o Centro e Custo e Conta     º±±
±±º          ³ Contabil                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT110LOK()
	Local lRet  := .T.
	Local cCContab	  := Alltrim(aCols[n,GDFIELDPOS("C1_CONTA")])
	Local cCCusto	  := Alltrim(aCols[n,GDFIELDPOS("C1_CC")])
	Local cItemCTA	  := Alltrim(aCols[n,GDFIELDPOS("C1_ITEMCTA")])
	Local cXItemCta	  := Alltrim(aCols[n,GDFIELDPOS("C1_XITEMCT")]) // INCLUIDO EM 03.05.16 POR SANDRA NISHIDA
	Local cCodProd	  := Alltrim(aCols[n,GDFIELDPOS("C1_PRODUTO")])
	Local cCodFABR	  := Alltrim(aCols[n,GDFIELDPOS("C1_FABR")])
	Local cCodFABRLOJ := Alltrim(aCols[n,GDFIELDPOS("C1_FABRLOJ")])
	Local cCodIMPOR	  := Alltrim(aCols[n,GDFIELDPOS("C1_IMPORT")])
	Local cCodFORN	  := Alltrim(aCols[n,GDFIELDPOS("C1_FORNECE")])
	Local cCodFORNLOJ := Alltrim(aCols[n,GDFIELDPOS("C1_LOJA")])
	Local cViaTransp  := Alltrim(aCols[n,GDFIELDPOS("C1_XVIAEMB")])

	IF !ISINCALLSTACK("PCPA107") .OR. !ISINCALLSTACK("MATA700") .OR. !ISINCALLSTACK("MATA712")  //MRP

		Return(lRet)

	ENDIF

	If !aCols[n] [len(aCols[n])] .and. !ISINCALLSTACK("EICSI400")

		IF cCodIMPOR == "S"
			if cEmpAnt == '02'
				chkfile("SA5")
				SA5->(dbSetOrder(1))

				If SA5->(DBSeek(xFilial()+AvKey(cCodFORN,"W1_FORN")+AvKey(cCodFORNLOJ,"W1_FORLOJ")+AvKey(cCodProd,"W1_COD_I")+AvKey(cCodFABR,"W1_FABR")+AVKEY(cCodFABRLOJ, "W1_FABLOJ")))
					If SA5->A5_XBLOQ == "1" //sim
						Aviso("PE-MT110LOK","Registro bloqueado para uso. Falta liberação da área responsável",{"Voltar"},1)
						lRet := .F.
					Endif
				Else
					Aviso("PE-MT110LOK","Não existe cadastro Produto x Fornecedor. Favor revisar o cadastro.",{"Voltar"},1)
					lRet := .F.
				Endif

			endif

			IF Empty(cCodFORN) .OR. Empty(cCodFORNLOJ)
				Aviso("PE-MT110LOK","Fornecedor é obrigatorio quando produto for importado.",{"Voltar"},1)
				lRet := .F.
			Endif

			if empty(cViaTransp)
				Aviso("PE-MT110LOK","Via de transporte é obrigatório quando o produto for importado",{"Voltar"},1)
				lRet := .F.
			endif

			if Empty(cCodFABR)
				aCols[n,GDFIELDPOS("C1_FABR")]    := cCodForn
				aCols[n,GDFIELDPOS("C1_FABRLOJ")] := cCodFornLoj
			endif



		Endif

		IF Empty(cCContab)
			Aviso("PE-MT110LOK","Conta Contabil é obrigatório ",{"Voltar"},1)
			lRet := .F.
		Else
			dbSelectArea("CT1")
			dbSetOrder(1)

			If MSSEEK(xFilial("CT1")+cCContab,.T.)
				If (CT1->CT1_CCOBRG == "1"  .OR. substr(cCContab,1,1) $'3567')
					If Empty(cCCusto) // alterado em 19.12.14 por sandra
						Aviso("PE1-MT110LOK","Centro de custo obrigatório para está conta contabil ",{"Voltar"},1)
						lRet := .F.
					EndIf
					IF !(cEmpAnt $ '02|04')
						If Empty(cItemCTA)
							Aviso("PE2-MT110LOK","Item Contabil é obrigatório. ",{"Voltar"},1)
							lRet := .F.
						ENDIF

						If !substr(cCContab,1,1)$'12' .AND. !Empty(cXItemCta)
							Aviso("PE3-MT110LOK","Campo Item Cont AF nao deve ser preenchido para produtos diferente de tipo AI - Ativo Fixo",{"Voltar"},1)
							lRet := .F.
						Endif
					Endif
				Elseif !(cEmpAnt $ '02|04')
					If substr(cCContab,1,1) $'12' .AND. !Empty(cCCusto)
						Aviso("PE4-MT110LOK","CCusto nao pode ser preenchido para esta conta contabil ",{"Voltar"},1)
						lRet := .F.
						// ALTERADO EM 03.05.16 POR SANDRA NISHIDA - INCLUIDO VALIDACAO PARA ITEM CONTABIL PARA ATIVO FIXO.
					ElseIf substr(cCContab,1,1) $'12' .AND. Empty(cXItemCta) .and. substr(cCodProd,1,2)$'AI'
						Aviso("PE5-MT110LOK","Campo Item Cont AF deve ser preenchido para produtos tipo AI - Ativo Fixo",{"Voltar"},1)
						lRet := .F.
					ElseIf !substr(cCContab,1,1)$'12' .AND. !Empty(cXItemCta)
						Aviso("PE6-MT110LOK","Campo Item Cont AF nao deve ser preenchido para produtos diferente de tipo AI - Ativo Fixo",{"Voltar"},1)
						lRet := .F.
					Endif
				Endif
			EndIf
			CT1->(DBCLOSEAREA())
		Endif
	EndIf

Return(lRet)
