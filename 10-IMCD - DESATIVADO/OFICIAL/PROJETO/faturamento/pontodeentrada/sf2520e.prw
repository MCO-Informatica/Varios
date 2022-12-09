/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³Marcos J.           º Data ³  11/27/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a exclusão da NF usada para remessa da embalagem.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#include "PROTHEUS.CH"
User Function SF2520E()
	Local cAlias    := Alias()
	Local aAreaSF2  := SF2->(GetArea())
	Local cFiltroSF2:= SF2->(DbFilter())

	Local aRegSD2   := {}
	Local aRegSE1   := {}
	Local aRegSE2   := {}
	Local aLinha    := {}
	Local aCabec    := {}
	Local aItens    := {}

	Local cChvSF2   := SF2->F2_NFEMB
	Local cNumPed   := ""
	Local cAliasSF2 := "SF2"

	Local lMostraCtb:= .F.
	Local lAglCtb   := .F.
	Local lContab   := .F.
	Local lCarteira := .F.

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "SF2520E" , __cUserID )

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	// Altera campo C5_LIBCRED para que a legenda do PV nao fique laranja (PGN 452/Daisy e 864/Celso) by Daniel em 09/03/11
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
	do While !Eof() .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5") + SD2->D2_PEDIDO)
	RecLock("SC5",.F.)
	SC5->C5_LIBCRED := " "
	msUnlock()
	Endif
	
	U_BAIXASC4( SD2->D2_COD, SD2->D2_QUANT,.F.)

	dbSelectArea("SD2")
	dbSkip()
	Enddo

	If !Empty(SF2->F2_NFEMB)
		SF2->(DbClearFilter())
		SF2->(DbSetOrder(1))
		SF2->(DbGoTop())
		SF2->(DbSeek(cChvSF2, .F.))
		If SF2->(Found())
			SD2->(DbSetOrder(3))
			SD2->(DbSeek(SubStr(cChvSF2, 1, 22), .F.))
			cNumPed := SD2->D2_PEDIDO

			lMostraCtb := MV_PAR01 == 1
			lAglCtb    := MV_PAR02 == 1
			lContab    := MV_PAR03 == 1
			lCarteira  := MV_PAR04 == 1

			//Exclui a nf de embalagem
			If MaCanDelF2(cAliasSF2, SF2->(RecNo()), @aRegSD2, @aRegSE1, @aRegSE2)
				SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))
			EndIf

			//Libera pedido para exclusao
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5") + cNumPed, .F.))

				SC6->(DbSetOrder(1))
				SC6->(DbSeek(xFilial("SC6") + cNumPed, .F.))
				While SC6->(!Eof()) .and. xFilial("SC6") + cNumPed == SC6->(C6_FILIAL + C6_NUM)
					aLinha := {}
					aAdd( aLinha, { "C6_ITEM"    , SC6->C6_ITEM   , Nil } )
					aAdd( aLinha, { "C6_PRODUTO" , SC6->C6_PRODUTO, Nil } )
					aAdd( aLinha, { "C6_EMBRET"  , SC6->C6_EMBRET , Nil } )
					aAdd( aLinha, { "C6_UM"      , SC6->C6_UM     , Nil } )
					aAdd( aLinha, { "C6_QTDVEN"  , SC6->C6_QTDVEN , Nil } )
					aAdd( aLinha, { "C6_PRCVEN"  , SC6->C6_PRCVEN , Nil } )
					aAdd( aLinha, { "C6_PRUNIT"  , SC6->C6_PRCVEN , Nil } )
					aAdd( aLinha, { "C6_VALOR"   , SC6->C6_VALOR  , Nil } )
					aAdd( aLinha, { "C6_QTDLIB"  , 0              , Nil } )
					aAdd( aLinha, { "C6_TES"     , SC6->C6_TES    , Nil } )
					aAdd( aLinha, { "C6_CLASFIS" , SC6->C6_CLASFIS, Nil } )
					aAdd( aLinha, { "C6_CLI"     , SC6->C6_CLI    , Nil } )
					aAdd( aLinha, { "C6_LOJA"    , SC6->C6_LOJA   , Nil } )
					aAdd( aLinha, { "C6_PEDCLI"  , SC6->C6_PEDCLI , Nil } )
					aAdd( aItens, aLinha )
					SC6->(DbSkip())
				EndDo

				aAdd( aCabec, { "C5_NUM"      , SC5->C5_NUM    , Nil } )
				aAdd( aCabec, { "C5_TIPO"     , SC5->C5_TIPO   , Nil } )
				aAdd( aCabec, { "C5_CLIENTE"  , SC5->C5_CLIENTE, Nil } )
				aAdd( aCabec, { "C5_LOJACLI"  , SC5->C5_LOJACLI, Nil } )
				aAdd( aCabec, { "C5_CLIENT"   , SC5->C5_CLIENT , Nil } )
				aAdd( aCabec, { "C5_LOJAENT"  , SC5->C5_LOJAENT, Nil } )
				aAdd( aCabec, { "C5_TIPOCLI"  , SC5->C5_TIPOCLI, Nil } )
				aAdd( aCabec, { "C5_CONDPAG"  , SC5->C5_CONDPAG, Nil } )
				aAdd( aCabec, { "C5_EMISSAO"  , SC5->C5_EMISSAO, Nil } )
				aAdd( aCabec, { "C5_TRANSP"   , SC5->C5_TRANSP , Nil } )
				aAdd( aCabec, { "C5_TPFRETE"  , SC5->C5_TPFRETE, Nil } )
				aAdd( aCabec, { "C5_MOEDA"    , SC5->C5_MOEDA  , Nil } )
				aAdd( aCabec, { "C5_TABELA"   , SC5->C5_TABELA , Nil})
				aAdd( aCabec, { "C5_NATUREZ"  , SC5->C5_NATUREZ , Nil})

				If Len(aItens) > 0
					MsExecAuto({|x, y, z| Mata410(x, y, z) }, aCabec, aItens, 4)
					If lMsErroAuto
						MostraErro()
					Else
						MsExecAuto({|x, y, z| Mata410(x, y, z) }, aCabec, aItens, 5)
						If lMsErroAuto
							MostraErro()
						EndIf				
					EndIf
				EndIf			
			EndIf
		EndIf
		SF2->(MsFilter(cFiltroSF2))
	EndIf

	RestArea(aAreaSF2)
	DbSelectArea(cAlias)
Return
