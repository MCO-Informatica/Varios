#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410GET  � Autor � Giane - ADV Brasil � Data �  11/02/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada antes da montagem da tela do pedido       ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / pedido de vendas                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M410GET

	Local cCampo 	:= ""
	Local nPMoeda	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XMOEDA"})
	Local nPTaxa 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XTAXA"})
	Local nPPrc  	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
	Local nPValor	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
	Local nPPruni	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT"})
	Local nPPrcMoe	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XPRUNIT"})
	Local nPQtd 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local nPosMed 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XMEDIO"})
	Local nPosTxa  	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XTAXA"})
	Local nPosICM  	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XICMEST"})
	Local nPosPIS  	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XPISCOF"})
	Local nPosVINF 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XVLRINF" })
	Local nPosPrd 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })

	Local _aArea	:= GetArea()
	Local nReg		:= SC6->(Recno())
	Local nMoeda	:= 1
	Local i := 0

	For i:= 1 to len(aCols)

		If !aCols[i][Len(aHeader)+1] //item nao esta deletado

			nMoeda := aCols[i,nPMoeda]
			xMedio	:= aCols[i,nPosMed]
			nTaxa	:= aCols[i,nPosTxa]
			cCond	:= M->C5_CONDPAG
			nAliqIMP :=  aCols[i,nPosICM] + aCols[i,nPosPIS]
			cPrd	:= aCols[i,nPosPrd]
			nQtd := aCols[i,nPQtd]
			nPreco := aCols[i,nPPrc]

			If nMoeda > 1
				IF xMedio != 'S' .AND. cCond != '000'
					cCampo := 'M2_MOEDA' + ALLTRIM(STR(nMoeda,1))

					IF(nAliqIMP > 0)
						nAliqIMP := ( nAliqImp / 100 )
					Endif

					nTaxa := 0

					DbSelectArea("SM2")
					DbSetOrder(1)
					If DbSeek(dDataBase)
						nTaxa := &cCampo
					ENDIF

					//altera valores no pedido de vendas
					if nTaxa != 0  .and. nTaxa <>  aCols[i,nPTaxa]

						if aCols[i,nPosVINF] > 0
							nPreco :=  aCols[i,nPosVINF]
						else
							nPreco := aCols[i,nPPrcMoe] //MaTabPrVen(SC5->C5_TABELA,cPrd,nQtd,SC5->C5_CLIENTE, SC5->C5_LOJACLI, nMoeda ,dDataBase)
						endif
						nPreco := Round( (nPreco / (1- nAliqImp)) * nTaxa, TamSx3("C6_PRCVEN")[2] )
						aCols[i,nPTaxa] 	:= nTaxa
						aCols[i,nPPrc]  	:= nPreco
						aCols[i,nPPruni] 	:= nPreco
						aCols[i,nPValor] 	:= NoRound( (nPreco * nQtd ),2)

					Endif
				Endif
			Endif
		Endif

	Next

	SC6->(DbGoto(nReg))
	RestArea(_aArea)
Return
