#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110LOK  �Autor  �                				16/10/2015���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validar utilzia��o de campo Codigo de ���
��           �Imobilziado em Curso e Centro de Custo                      ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110LOK()

//Fontes Renova - Compatibiliza��o dos Fontes 23/10/2015
	Local aSavAre   := SaveArea1({"CT1","CTT"})
	Local cConta    := GDFieldGet("C1_CONTA")
	Local cCCusto   := GDFieldGet("C1_CC")
	Local cNivCon   := Nil
	Local cNivCus   := Nil
	Local lNiv      := .F.
//Final Fontes Renova
	Local _lRet     := .T.
	Local aAlias	:= GetArea()
	Local aSC1Alias	:= GetArea('SC1')
	Local _lExecuta := ParamIxb[1]
	Local _aArea  := GetArea()
	Local _lRet   := .T.
	Local nC1CC	 := GdFieldPos('C1_CC')

// Volta Trava
	Local nI
	Local cTipo
	Local nPosTip    := Ascan(aHeader,{|x| alltrim(x[2]) == "C1_XTIPO"})
	Local nPosTipFor := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_XFORESP"})
	Local nPosObs    := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_OBS"})
	Local nPosForne  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_FORNECE"})
	Local nPosLojFo  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_LOJA"})
	Local nPosQtd    := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_QUANT"})
	Local nPosVal    := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_VLESTIM"})

	If lCopia .AND. (Empty(_cAprovSC) .OR. Empty(cUnidReq))
		cUnidReq  := SC1->C1_UNIDREQ
		_cAprovSC := SC1->C1_XAPROV
	EndIf

	if nPosTip <= 0 .or. Len(aCols) <= 1
		_lRet := .T.
	else
		cTipo := aCols[1][nPosTip]

		for nI = 1 to Len(aCols)
			if !aCols[n][Len(aHeader)+1]  // a linha n�o esta deletada.
				if aCols[n][nPosTip] <> cTipo
					//MsgStop("Na solicita��o de compras voc� s� pode ter itens com o mesmo Tipo Compra, CENTRALIZADA ou DESCENTRALIZADA, Favor separar os itens em  duas Solicita��es de compras.","ATEN��O!!!")
					//_lRet := .F.
					exit
				endif
			endif
		next

	endif
//Fim Volta Trava

	If _lExecuta

		_nPosCON := aScan(aHeader,{|x| ALlTrim(x[2]) == "C1_CONTA"} )
		_nPosIMC := aScan(aHeader,{|x| ALlTrim(x[2]) == "C1_XIMCURS"} )
		_nPosPIC := aScan(aHeader,{|x| ALlTrim(x[2]) == "C1_XPROJIM"} )
		_nPosFore := aScan(aHeader,{|x| ALlTrim(x[2]) == "C1_XFORESP"} )  // Fornecedor Exclusivo "Sim/N�o"
		_nPosObse := aScan(aHeader,{|x| ALlTrim(x[2]) == "C1_XJUSTFO"} )  // Observa��o Fornecedor


		If	aCols[ n,(Len(aHeader)+1) ] // Se for deletado
			RestArea( aSC1Alias )
			RestArea( aAlias )
			Return (_lRet)
		EndIf

		If SUBSTR( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. Alltrim(aCols[n,_nPosIMC]) = 'N'
			MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" � de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a S-SIM!")
			_lRet := .F.
		EndIf

		If Substr( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. Empty(aCols[n,_nPosPIC])
			MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" � de Imobilizado em Cursos. Campo Cod. Proj. C. N�o pode ser em branco! Por favor, escolha o codigo do projeto de imobilizado em curso.")
			_lRet := .F.
		EndIf

		If SUBSTR( aCols[n,_nPosCON],1,7 ) <> '1232103' .AND. Alltrim(aCols[n,_nPosIMC]) = 'S'
			MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" N�o � de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a N-N�O!")
			_lRet := .F.
		EndIf

		If Substr( aCols[n,_nPosCON],1,7 ) <> '1232103' .AND. !Empty(aCols[n,_nPosPIC])
			MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" N�o � de Imobilizado em Cursos. Campo Cod. Proj. C. deve ser deixado em branco!")
			_lRet := .F.
		EndIf

		//Fontes Renova - Compatibiliza��o dos Fontes 23/10/2015
		If cConta == Nil .Or. cCCusto == Nil
			Return(.T.)
		Endif

		If Empty(cConta) .Or. Empty(cCCusto)
			Return(.T.)
		Endif

		cNivCon := Posicione("CT1", 1, xFilial("CT1") + cConta , "CT1_RGNV1")
		cNivCus := Posicione("CTT", 1, xFilial("CTT") + cCCusto, "CTT_CRGNV1")

		lNiv:= Alltrim(cNivCon)$cNivCus

		//Comentei as linhas abaixo conforme solicita��o do wellington para n�o dar mensagem de erro(07/12/2015-Gileno)
		//If cNivCon <> cNivCus
		//	Alert("Centro de Custo invalido, favor ajustar")
		//	_lRet := .F.
		//Endif

		//Final Fontes Renova
		// Valida��o Fornecedor Exclusivo - obrigada a preencher a observa��o

		If (aCols[n,_nPosFore]) = '1' .AND. Empty(aCols[n,_nPosObse])
			MsgInfo("O Campo 'Forn. Exclusivo.' foi preenchido com Sim, ser� necess�rio preencher o campo 'Justificativa Forn. exclusivo' detalhando o motivo da compra com esse Fornecedor")
			_lRet := .F.
		EndIf

		// Roberto 13/05/16
		// Valida o centro de custo de acordo com o Unidade requisitante
		// Ignora a valida��o quando n�o houver amarra��o
		dbSelectArea("SY3")
		dbSetOrder(1)
		IF dbSeek(XFILIAL("SY3")+CUNIDREQ)
			// Valida apenas se o cento de custo estiver preenchido
			if ! Empty(alltrim(SY3->Y3_XCCUSTO))
				IF !ALLTRIM(aCols[n][nC1CC]) $ ALLTRIM(SY3->Y3_XCCUSTO)
					ShowHelpDlg("RECOMG01", {"O Centro de Custo informado n�o pertence a Unidade Requisitante!",""},3,;
						{"Utilize outro c�digo de Centro de Custo.",""},3)
					_lRet := .F.
				Endif
			Endif
		Endif

	EndIf

// Soma o total da SC para apresentar na tela
	_nToSc := 0
	_nTotalSC := 0
	For _nToSc := 1 to len(aCols)
		If	! aCols[ _nToSc,(Len(aHeader)+1) ] // Se for deletado
			_nTotalSC += aCols[_nToSc,nPosQtd] * aCols[_nToSc,nPosVal]
		EndIf
	Next _nToSc

	//_oTotalSC:Refresh()

	RestArea( aSC1Alias )
	RestArea( aAlias )
	RestArea1(aSavAre) //Personalizado pela Renova


	If FunName() == 'ALTESP'
		If aCols[n][GDFieldPos("C1_FLAGGCT"	,aHeader)] == '2' .AND. aCols[n][Len(aCols[n])] == .T.
			Alert("N�o � poss�vel excluir itens lan�ados anteriormente","Aten��o")
			lRet := .F.
		Else
			lRet := .T.
		EndIf
	EndIf


Return(_lRet)
//--< fim de arquivo >----------------------------------------------------------------------
