#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#DEFINE APOS {  15,  1, 70, 315 }

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF1100I   �Autor � ROBERTA HELENA ALONSO  � Data � 07/03/12 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. na confirmacao da nota fiscal de entrada, utilizado   ���
���          � para gravacao da descricao do fornecedor/cliente           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico para Delgo               - Compras              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SF1100I()

	Local aCtaContab := {}
	Local cCtaContab := ""
	Local cDescCTA   := ""
	Local cHistCta	 := ""
	Local cClaDesp	 := ""
	Local cDClDesp	 := ""


	Local cMsgErro	 := ""
	Local aDataTela	 := {}
	Local lret       := .T.
	Local aASF1		 := SF1->(GetArea())
	Local aACT1		 := CT1->(GetArea())
	Local lAtivo 	 := .F.
    Local cBaseIni 	 := ""
    Local cBaseFim 	 := ""

	_cAlias := Alias()
	_nRecno := Recno()
	_nIndex := IndexOrd()

	_cFor  := SF1->F1_FORNECE
	_cLoj  := SF1->F1_LOJA
	_cPref := SF1->F1_PREFIXO
	_cNum  := SF1->F1_DUPL

	DbSelectArea("SF1")
	If FieldPos("F1_NOMFOR")<>0
		If SF1->F1_TIPO $ "D|B"
			RecLock("SF1",.F.)
			SF1->F1_NOMFOR 	:= Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NREDUZ")
			MsUnLock()
		Else
			RecLock("SF1",.F.)
			SF1->F1_NOMFOR 	:= Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NREDUZ")
			MsUnLock()
		EndIf   
	EndIf

	CtaContab(aCtaContab, @cMsgErro)

	If ascan(aCtaContab, { |x| x[1] == ""} ) <> 0
		Help(NIL, NIL, "Conta contábil não cadastrada", NIL, "Conta contábil não cadastrada")
		lret := .F.
	ElseIf Len(aCtaContab) == 0
		Help(NIL, NIL, "Não encontrado conta contábil", NIL, "Conta contábil não encontrada")
		lret := .F.
	elseIf Len(aCtaContab) == 1
		cCtaContab := aCtaContab[1,1]
		cDescCTA := POSICIONE("CT1",1,FwxFilial("CT1")+cCtaContab,"CT1_DESC01")
		If !IsBLind()
			aDataTela := Mostratela()
			cHistCta	 := aDataTela[1]
			cClaDesp	 := aDataTela[2]
			cDClDesp	 := aDataTela[3]
		EndIf
	Else
		Help(NIL, NIL, "Ha mais de uma conta contabil nesta NF.", NIL, cMsgErro)
		lret := .F.
	EndIf

	/*
	//Gravando a origem nos titulos de todos os tipos (nf, tx, ncc, ndc, etc)

	DbSelecTArea("SE2")   
	_cSE2Alias := Alias()
	_nSE2Recno := Recno()
	_nSE2Index := IndexOrd()

	DbSetORder(1)       //prefixo, num, parcela, tipo, fornece, loja.
	If DbSeek(xFilial("SE2") + _cPref + _cNum)
	While !EOF() .and. (xFilial("SE2") + _cPref + _cNum) == SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM
	Reclock("SE2",.F.)
	E2_ORIGF   := SE2->E2_FILORIG
	MsUnLock()
	DbSkip()
	Enddo
	Endif	
	*/
	//gravando o total de parcelas no titulo
	DbSelecTArea("SE2")
	DbSetORder(6)       //fornecedor, loja, pref, titulo, parcela, tipo
	If DbSeek(xFilial("SE2") + _cFor + _cLoj + _cPref + _cNum)
		_nQtdTit := 0 
		While !EOF() .and. _cFor + _cLoj + _cPref + _cNum == SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO +SE2->E2_NUM
			If SE2->E2_TIPO == "NF " 
				_nQtdTit := _nQtdTit + 1  
				If SE2->(RecLock("SE2",.F.))
					If SD1->(FieldPos("D1_NUMPO"))<>0
						SE2->E2_NUMPO   := SD1->D1_NUMPO	
					EndIf
					SE2->E2_CTAINFO := cCtaContab
					SE2->E2_YDESCCO := cDescCTA
					SE2->E2_HIST2   := cHistCta
					SE2->E2_HIST    := cHistCta
					SE2->E2_YCLDESP := cClaDesp
					SE2->E2_YDCLDES := cDClDesp
					SE2->(MsUnLock())
				EndIf
			Endif
			DbSelectArea("SE2")		
			DbSkip()
		Enddo

		If _nQtdTit > 1
			DbSelecTArea("SE2")
			DbSetORder(6)       //fornecedor, loja, pref, titulo, parcela, tipo
			If DbSeek(xFilial("SE2") + _cFor + _cLoj + _cPref + _cNum)
				While !EOF() .and. _cFor + _cLoj + _cPref + _cNum == SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO +SE2->E2_NUM
					IF SE2->E2_TIPO == "NF "
						If Reclock("SE2",.F.)
							If SD1->(FieldPos("D1_NUMPO"))<>0	
								E2_NUMPO   := SD1->D1_NUMPO	
							EndIf
							E2_RSOCIAL := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE + SE2->E2_LOJA,"A2_NOME")
							E2_CTAINFO := cCtaContab
							E2_YDESCCO := cDescCTA
							E2_HIST2   := cHistCta
							E2_YCLDESP := cClaDesp
							E2_YDCLDES := cDClDesp
							MsUnLock()	
						EndIf
					Endif
					DbSkip()
				Enddo
			Endif	
		Endif
	Endif


    DbSelectArea("SN1")
    SN1->(DbSetOrder(8))
	If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA )))
		While SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA )

			If SN1->(DbSeek(xFilial("SN1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_ESPECIE+SF1->F1_DOC+SF1->F1_SERIE+SD1->D1_ITEM,.F.))
			
    			if !lAtivo
					cBaseIni := SN1->N1_CBASE
				EndIf
				cBaseFim := SN1->N1_CBASE
				lAtivo := .t.

				SN1->(RecLock("SN1",.F.))
				SN1->N1_CHAPA := SN1->N1_CBASE
				SN1->(MsUnlock())

			EndIf

			SD1->(DbSkip())
		End 
	EndIf
	If lAtivo
		U_FichaAtivo(cBaseIni, cBaseFim)
	EndIf


	SF1->(RestArea(aASF1))
	CT1->(RestArea(aACT1))
	/*
	DbSelectArea(_cSE2Alias)
	DbSetOrder(_nSE2Index)
	DbGoTo(_nSE2Recno)
	*/
	DbSelectArea(_cAlias)
	DbSetOrder(_nIndex)
	DbGoTo(_nRecno)

Return lret


Static Function CtaContab(aCtaContab, cMsgErro)
	Local aArea := GetArea()
	Local aSD1	:= SD1->(GetArea())
	Local aSF4	:= SF4->(GetArea())
	Local aSB1	:= SB1->(GetArea())
	Local aSED	:= SED->(GetArea())
	Local lRet	:= .F.
	Local cCtaNatureza := ""

	If !Empty(SED->ED_CODIGO) .And. !Empty(SE2->E2_NATUREZ)
		cCtaNatureza := AllTrim(SED->ED_CONTA)
	EndIf

	SED->(DbSetOrder(1)) //ED_FILIAL+ED_CODIGO

	//ED_CONTA - conta


	SF4->(DbSetOrder(1)) // F4_FILIAL+F4_CODIGO
	SD1->(DbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SB1->(DbSetOrder(1)) 
	If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA )))
		While SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA )
			If SF4->(DbSeek(FwxFilial("SF4") + SD1->D1_TES))
				If SF4->F4_ESTOQUE == "S"
					If SB1->(DbSeek(FwxFilial("SB1") + SD1->D1_COD))
						If ascan(aCtaContab, { |x| x[1] == AllTrim(SB1->B1_CONTA) } ) == 0 
							AADD(aCtaContab, { AllTrim(SB1->B1_CONTA) , SB1->B1_COD})
						else
							If Empty(cMsgErro)
								cMsgErro += "Produto: " + aCtaContab[1,2] + " Conta: " + aCtaContab[1,1]  + CHR(13) + CHR(10)
							EndIf
							cMsgErro += "Produto: " + SB1->B1_COD + " Conta: " + SB1->B1_CONTA + CHR(13) + CHR(10)
						EndIf
					EndIf
				Else 
					If ascan(aCtaContab, { |x| x[1] == cCtaNatureza } ) == 0 
						AADD(aCtaContab, {cCtaNatureza, "NATUREZA"})
					EndIf
				EndIf
			EndIf 
			SD1->(DbSkip())
		End 
	EndIf 

	SD1->(RestArea(aSD1))
	SF4->(RestArea(aSF4))
	SB1->(RestArea(aSB1))
	SED->(RestArea(aSED))

	RestArea(aArea)
Return lRet

Static Function Mostratela()
	Local nJanAltu := 200
	Local nJanLarg := 400
	Local oDlgPvt  := Nil
	Local oSayCta  := NIL
	Local oGetCta  := Nil

	Local oSayCla  := NIL
	Local oGetCla  := Nil
	Local cGetCta  := SPace(100)
	Local cGetCLa  := Space(6)
	Local oGetdes  := Nil
	Local cGetdes  := Space(55)
	Local aDataTela := {}


	DEFINE MSDIALOG oDlgPvt TITLE "Historico conta contabil" FROM 000, 000  TO nJanAltu, nJanLarg PIXEL

	@ 013, 006   SAY   oSayCta PROMPT "Mensagem Historico da Conta Contabil:"        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt   PIXEL
	@ 020, 006   MSGET oGetCta VAR    cGetCta           SIZE (nJanLarg/2)-12, 014 OF oDlgPvt PICTURE "@!" PIXEL

	@ 043, 006   SAY   oSayCla PROMPT "Classe Despesa:"        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt  PIXEL			         
	@ 050, 006   MSGET oGetCla VAR    cGetCla   F3 "Z1"  Valid GatDesc(cGetCla,@cGetDes)  SIZE (nJanLarg/8)-12, 007 OF oDlgPvt  PIXEL
	@ 065, 006   MSGET oGetdes VAR    cGetDes  SIZE (nJanLarg/2)-12, 007  WHEN AllWaysFalse() OF oDlgPvt  PIXEL

	//Bot�es
	@ (nJanAltu/2)-18, 006 BUTTON oBtnConf PROMPT "Confirmar"             SIZE (nJanLarg/2)-12, 015 OF oDlgPvt ACTION (oDlgPvt:End()) PIXEL


	ACTIVATE MSDIALOG oDlgPvt CENTERED

	AADD(aDataTela, cGetCta)
	AADD(aDataTela, cGetCla)
	AADD(aDataTela, cGetDes)

Return aDataTela


Static Function GatDesc(cGetCla,cGetDes)


	If !Empty(cGetCla)
		If SX5->(DbSeek(FwxFilial("SX5") + "Z1" + AllTrim(cGetCla)))
			cGetDes := SX5->X5_DESCRI
		else
			cGetDes := Space(55)
		EndIf
	Else
		cGetDes := Space(55)
	EndIf

Return .T.
