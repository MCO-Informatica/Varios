#INCLUDE 'PROTHEUS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100LOK º Autor ³  Junior Carvalho   º Data ³  17/07/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para validar o Centro e Custo e Conta     º±±
±±º          ³ Contabil -                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function MT100LOK()

	Local lRet := .T.
	Local cCContab	:= ""
	Local cCCusto	:= ""
	Local cRateio	:= ""
	Local cItemCTA	:= ""
	Local cPrd		:= ""
	Local cFabric	:= ""
	Local cItemCC	:= ""
	Local cCodProd	:= ""
	Local cxItemCTA	:= ""
	local cCodST    := ""
	local cCodFCI   := ""


	IF IsInCallStack("IMPORTCOL")
		Return(lRet)
	ENDIF

	If !aCols[n] [len(aCols[n])]

		cCContab	:= Alltrim(aCols[n,GDFIELDPOS("D1_CONTA")])
		cCCusto		:= Alltrim(aCols[n,GDFIELDPOS("D1_CC")])
		cRateio		:= Alltrim(aCols[n,GDFIELDPOS("D1_RATEIO" )])
		cItemCTA	:= Alltrim(aCols[n,GDFIELDPOS("D1_ITEMCTA")])
		cPrd		:= Alltrim(aCols[n,GDFIELDPOS("D1_COD")])
		cFabric		:= Alltrim(aCols[n,GDFIELDPOS("D1_FABRIC")])
		cItemCC		:= Alltrim(aCols[n,GDFIELDPOS("D1_ITEMCTA")])

		cCodProd	:= Alltrim(aCols[n,GDFIELDPOS("D1_COD")])
		cxItemCTA	:= Alltrim(aCols[n,GDFIELDPOS("D1_XITEMCT")]) // INCLUIDO EM 03.05.16 POR SANDRA NISHIDA
		cCodFCI     := Alltrim(aCols[n,GDFIELDPOS("D1_FCICOD")])
		cCodST      := Alltrim(aCols[n,GDFIELDPOS("D1_CLASFIS")])

		//	aCols[n,GDFIELDPOS("D1_XINTSD3")] := CTOD('  /   /  ')

		If cTipo == 'C' .and. Alltrim(CESPECIE) $ 'CTE|CTR|NFS'
			aCols[n,GDFIELDPOS("D1_CLASFIS")] := '000'
			aCols[n,GDFIELDPOS("D1_LOCAL")] := '01'
		Endif

		If cRateio == "2"

			If Empty(cCContab)
				Aviso("MT100LOK - Atencao!","Conta Contabil em Branco.",{"Voltar"},1)
				lRet := .F.
			Else
				dbSelectArea("CT1")
				dbSetOrder(1)
				If MSSEEK(xFilial("CT1")+cCContab,.T.)
					If (CT1->CT1_CCOBRG == "1" .OR. substr(cCContab,1,1)$'3567' )
						If Empty(cCCusto)
							Aviso("MT100LOK - Atencao!","Centro de custo obrigatório para está conta contabil. ",{"Voltar"},1)
							lRet := .F.
						Endif
						IF !(cEmpAnt $ '02|04')
							If Empty(cItemCTA)
								Aviso("PE-MT100LOK","Item Contabil é obrigatório. ",{"Voltar"},1)
								lRet := .F.
							Endif

							If (substr(cCContab,1,1) <>'1' .OR. substr(cCContab,1,1) <> '2') .AND. !Empty(cXItemCta)
								Aviso("PE-MT100LOK","Campo Item Cont AF nao deve ser preenchido para produtos diferente de tipo AI - Ativo Fixo",{"Voltar"},1)
								lRet := .F.
							Endif

						ENDIF
					ElseIf !(cEmpAnt $ '02|04')
						if SUBSTR(cCContab,1,1) $'12' .AND. (!Empty(cCCusto)  .OR. !Empty(cItemCTA))  // ALTERADO EM 160516 POR SANDRA NISHIDA, trava para item contabil.
							Aviso("MT100LOK","CCusto ou Item Cont nao pode ser preenchido para esta conta contabil. ",{"Voltar"},1)
							lRet := .F.
							// ALTERADO EM 03.05.16 POR SANDRA NISHIDA - INCLUIDO VALIDACAO PARA ITEM CONTABIL PARA ATIVO FIXO.
						ElseIf SUBSTR(cCContab,1,1) $'12' .AND. Empty(cXItemCta).and. substr(cCodProd,1,2)$'AI'
							Aviso("PE-MT100LOK","Campo XItem Contabil deve ser preenchido para produtos tipo AI - Ativo Fixo",{"Voltar"},1)
							lRet := .F.
						ElseIf  !SUBSTR(cCContab,1,1) $'12' .AND. !Empty(cXItemCta)
							Aviso("PE-MT100LOK","Campo Item Cont AF nao deve ser preenchido para produtos diferente de tipo AI - Ativo Fixo",{"Voltar"},1)
							lRet := .F.
						Endif
					Endif
				EndIf
			EndIf
		EndIf

		IF cTipo $ 'N|C' .AND. lRet
			lRet := U_VLDLICFOR( CA100FOR, CLOJA )
		Endif

		//luiz validação de fabricante
		SB1->(DbSeek(xFilial("SB1")+cPrd))

		IF SB1->B1_TIPO $ "MR/MA"
			IF Empty(cFabric) .AND. cTipo == "N"
				Aviso("MT100LOK","Este produto exige o preenchimento do campo Fabricante.",{"Voltar"},1)
				lRet := .F.
			ENDIF

			IF ( cEmpAnt == '04' )
				IF DDATABASE >= STOD('20210801') 
					lRet := FCIUTILS():validaFci(cCodST, cCodFCI, "MT100LOK")
				ENDIF
			ELSE
				lRet := FCIUTILS():validaFci(cCodST, cCodFCI, "MT100LOK")
			ENDIF
		ENDIF

	ENDIF


Return(lRet)
