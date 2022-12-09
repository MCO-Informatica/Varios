#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณDelegante ณ Autor ณ Joao Tavares Junior   ณ Data ณ16/03/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Retorna um array com os delegantes que deverao receber o   ณฑฑ
ฑฑณ          ณ workflow para libera็ao                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe e ณ Void Delegantes(ExpN1,ExpN2,ExpA1)                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA1 = Array com informacoes do documento                 ณฑฑ
ฑฑณ          ณ       [1] Numero do documento                              ณฑฑ
ฑฑณ          ณ       [2] Tipo de Documento                                ณฑฑ
ฑฑณ          ณ       [3] Valor do Documento                               ณฑฑ
ฑฑณ          ณ       [4] Codigo do Aprovador                              ณฑฑ
ฑฑณ          ณ       [5] Codigo do Usuario                                ณฑฑ
ฑฑณ          ณ       [6] Aprovador Superior                               ณฑฑ
ฑฑณ          ณ       [7] Data de Emissao do Documento                     ณฑฑ
ฑฑณ          ณ       [8] Nivel do Aprovador                               ณฑฑ
ฑฑณ          ณ       [9] Observacao                                       ณฑฑ
ฑฑณ          ณ       [10]Status                                           ณฑฑ
ฑฑณ          ณ       [11]Motivos                                          ณฑฑ
ฑฑณ          ณ ExpN1 = Desconto Solicitado para Aprovacao                 ณฑฑ
ฑฑณ          ณ ExpN1 = Tipo da Operacao                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Delegantes(aDocto,nDescPed,lMargPed)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de Variaveis                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


Local nLimDesc		:= 0.00
Local nLimValor	 	:= 0.00
Local lRet			:= .F.
Local cUsusario		:=aDocto[5]
Local aArea		:= GetArea()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Busca o  aprovador                                              							 |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA2")
DbSetOrder(2)
dbGoTop()
If DbSeek(xFilial("PA2")+cUsusario,.F.)
	DbSelectArea("PA3")
	DbSetOrder(2)
	dbGotop()
	If DbSeek(xFilial("PA3")+PA2->PA2_CODIGO,.F.)
		cGrupo := PA3->PA3_CODIGO
		DbSetOrder(1)
		dbGotop()
		DbSeek(xFilial("PA3")+cGrupo+PA2->PA2_TIPO+PA2->PA2_CODIGO,.F.)
		While PA3->PA3_CODIGO == cGrupo
			DbSelectArea("PA4")
			DbSetOrder(1)
			If DbSeek(xFilial("PA4")+PA3->PA3_TIPO,.F.)
				nLimValor	:= PA4->PA4_VLRMAX
				nLimDesc	:= PA4->PA4_DESC
			Endif

			If lMargPed  // se margem permitida
				If (aDocto[3] < nLimValor .AND. nDescPed < nLimDesc)

					aDocto[4] := Posicione("PA2",1,xFilial("PA2") + PA3->PA3_CODAPR,"PA2_CODIGO")
					aDocto[5] := Posicione("PA2",1,xFilial("PA2") + PA3->PA3_CODAPR,"PA2_CODUSR")
					aDocto[9] := "Aprovacao via e-mail"
					aDocto[10] := "02"
					lRet := .T.
					Exit
				Endif
			Else // se margem abaixo do permitido
				If PA3->PA3_TIPO = GetNewPar("ES_NIVMAX","4")
					aDocto[4] := Posicione("PA2",1,xFilial("PA2") + PA3->PA3_CODAPR,"PA2_CODIGO")
					aDocto[5] := Posicione("PA2",1,xFilial("PA2") + PA3->PA3_CODAPR,"PA2_CODUSR")
					aDocto[9] := "Aprovacao via e-mail"
					aDocto[10] := "02"
					lRet := .T.
					Exit
				EndIf
			EndIf

			DbSelectArea("PA3")
			dbSkip()
		EndDo

		If cUsusario == aDocto[5]
			aDocto[9] := "Aprovado pelo usuario logado"
			aDocto[10] := "03"
		EndIf
	EndIf
	DbSelectArea("PA3")
	DbSetOrder(1)
EndIf

DbSelectArea("PA2")
DbSetOrder(1)

RestArea(aArea)

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AlcDoc 	ณ Autor ณ Fabio Cesar Congilio  ณ Data ณ15.08.2004ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Controla a alcada dos documentos   SCR-Bloqueios           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ AlcDoc(ExpA1,ExpN1)		                        		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA1 = Array com informacoes do documento                 ณฑฑ
ฑฑณ          ณ       [1] Numero do documento                              ณฑฑ
ฑฑณ          ณ       [2] Tipo de Documento                                ณฑฑ
ฑฑณ          ณ       [3] Valor do Documento                               ณฑฑ
ฑฑณ          ณ       [4] Codigo do Aprovador                              ณฑฑ
ฑฑณ          ณ       [5] Codigo do Usuario                                ณฑฑ
ฑฑณ          ณ       [6] Aprovador Superior                               ณฑฑ
ฑฑณ          ณ       [7] Data de Emissao do Documento                     ณฑฑ
ฑฑณ          ณ       [8] Nivel do Aprovador                               ณฑฑ
ฑฑณ          ณ       [9] Observacao                                       ณฑฑ
ฑฑณ          ณ       [10]Status                                           ณฑฑ
ฑฑณ          ณ       [11]Motivos                                          ณฑฑ
ฑฑณ          ณ ExpN1 = Operacao a ser executada                           ณฑฑ
ฑฑณ          ณ       1 = Inclusao do documento                            ณฑฑ
ฑฑณ          ณ       2 = Estorno do documento                             ณฑฑ
ฑฑณ          ณ       3 = Exclusao do documento                            ณฑฑ
ฑฑณ          ณ       4 = Aprovacao do documento                           ณฑฑ
ฑฑณ          ณ       5 = Estorno da Aprovacao                             ณฑฑ
ฑฑณ          ณ       6 = Bloqueio Manual da Aprovacao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AlcDoc1(aDocto,nOper)
Local cDocto	:= aDocto[1]
Local cTipoDoc	:= aDocto[2]
Local nValDcto	:= aDocto[3]
Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
Local cNivel	:= If(aDocto[8]==Nil,"01",aDocto[8])
Local cStatus	:= aDocto[10]
Local aArea		:= GetArea()
Local aAreaSCR  := SCR->(GetArea())
Local lRetorno	:= .T.
Local lAchou	:= .F.

cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))

If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek(xFilial()+cAprov)
	cUsuario :=	A3_CODUSR
EndIf
If nOper == 1  //Inclusao do Documento
	Reclock("SCR",.T.)
	SCR->CR_FILIAL	:= xFilial("SCR")
	SCR->CR_NUM		:= cDocto
	SCR->CR_TIPO	:= cTipoDoc
	SCR->CR_NIVEL	:= cNivel
	SCR->CR_USER	:= cUsuario
	SCR->CR_APROV	:= cAprov
	SCR->CR_STATUS	:= cStatus
	SCR->CR_OBS		:= aDocto[9]
	SCR->CR_TOTAL	:= nValDcto
	SCR->CR_EMISSAO := aDocto[7]
	MsUnlock()
EndIf
If nOper == 3  //exclusao do documento
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
	While !Eof() .And. SCR->CR_FILIAL+SUBSTRING(SCR->CR_TIPO,1,1)+SCR->CR_NUM == xFilial("SCR")+SUBSTRING(cTipoDoc,1,1)+cDocto
		Reclock("SCR",.F.,.T.)
		dbDelete()
		MsUnlock()
		dbSkip()
	EndDo
EndIf
If nOper == 4 //Aprovacao do documento
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza o saldo do aprovador.                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek(xFilial()+cAprov)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Libera o pedido pelo aprovador.                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SCR")
	cAuxNivel := CR_NIVEL
	Reclock("SCR",.F.)
	dbSetOrder(1)
	CR_STATUS	:= "03"
	CR_OBS		:= If(Len(aDocto)>8,aDocto[9],"")
	CR_DATALIB	:= dDataBase
	CR_USERLIB	:= cUsuario
	CR_LIBAPRO	:= SA3->A3_COD
	CR_VALLIB	:= nValDcto
	MsUnlock()
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
	nRec := RecNo()
	While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
		If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
			lAchou := .T.
			cNextNiv := CR_NIVEL
		EndIf
		If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
			Reclock("SCR",.F.)
			CR_STATUS := "02"
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Reposiciona e verifica se ja esta totalmente liberado.       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbGoto(nRec)
	While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
		If CR_STATUS != "03"
			lRetorno := .F.
		EndIf
		dbSkip()
	EndDo
EndIf
If nOper == 5  //Estorno da Aprovacao
EndIf
If nOper == 6  //Bloqueio manual
	Reclock("SCR",.F.)
	CR_STATUS := "04"
	CR_OBS	 := If(Len(aDocto)>7,aDocto[8],"")
	CR_DATALIB:= dDataBase
	MsUnlock()
	lRetorno := .F.
EndIf
dbSelectArea("SCR")
RestArea(aAreaSCR)
RestArea(aArea)
Return(lRetorno)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetComis  บAutor  ณJoao Tavares Junior บ Data ณ  03/16/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o percentual de comissao                            บฑฑ
ฑฑบ          ณ	 v                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RetComis(cAlias,nTp)

Local aAreaAnt 	:= GetArea()
Local lRet 		:= .T.
Local nComis1 	:= 0
Local nComis2 	:= 0
Local nComis3 	:= 0
Local nComis4 	:= 0
Local nComis5 	:= 0
Local cComis	:= 0
Local nX		:= 0
Local cVend		:= ""
Local cVend1	:= ""
Local cProduto	:= ""
Local cCliente	:= ""
Local cPos1		:= 0
Local cPos2		:= 0
Local cPos3		:= 0
Local cPos4		:= 0
Local cPos5    	:= 0

DEFAULT nTp		 := 1


If cAlias == "SCJ"
	dbSelectArea("SCJ")
	//If Inclui
		cVend 	 :=	"M->CJ_VEND"
		cVend1 	 :=	"M->CJ_VEND"
		cCliente :=	"M->CJ_CLIENTE+M->CJ_LOJA"
		cPos1		:= FieldPos( "CJ_VEND" )
		cPos2		:= FieldPos( "CJ_VEND2" )
		cPos3		:= FieldPos( "CJ_VEND3" )
		cPos4		:= FieldPos( "CJ_VEND4" )
		cPos5    	:= FieldPos( "CJ_VEND5" )
	//Else
	//	cVend 	 :=	"CJ_VEND"
	//	cVend1 	 :=	"CJ_VEND"
	//	cCliente :=	"CJ_CLIENTE+CJ_LOJA"
	//EndIf
	dbSelectArea("SCK")
	cProduto :=	If(Readvar()=="M->CK_PRODUTO","M->CK_PRODUTO","TMP1->CK_PRODUTO" )
	cComis	 :=	"CK_COMIS"
	dbSelectArea("SCJ")
Else
	dbSelectArea("SC5")
  //	If Inclui
		cVend 	 :=	"M->C5_VEND"
		cVend1 	 :=	"M->C5_VEND1"
		cCliente :=	"M->C5_CLIENTE+M->C5_LOJACLI"
//	Else
//		cVend 	 :=	"C5_VEND"
//		cVend1 	 :=	"C5_VEND1"
//		cCliente :=	"C5_CLIENTE+C5_LOJACLI"

//	EndIf

	cPos1		:= FieldPos( "C5_VEND1" )
	cPos2		:= FieldPos( "C5_VEND2" )
	cPos3		:= FieldPos( "C5_VEND3" )
	cPos4		:= FieldPos( "C5_VEND4" )
	cPos5    	:= FieldPos( "C5_VEND5" )

	dbSelectArea("SC6")
	cProduto :=	IIF(ReadVar()=='M->C6_PRODUTO', "M->C6_PRODUTO", "ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=='C6_PRODUTO'})]") //"C6_PRODUTO"
	cComis	 :=	"C6_COMIS"
	dbSelectArea("SC5")
EndIf



If Empty(&(cVEND1))
	MsgInfo("Informe o Codigo do Vendedor antes de Continuar","Atencao")
	lRet := .F.
EndIf


nComis1 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
nComis1 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND1),"A3_COMIS") == 0, nComis1,Posicione("SA3",1,xFilial("SA3") + &(cVEND1),"A3_COMIS"))
nComis1 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis1,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))


If cPos2  > 0
	If !Empty(&(cVEND+"2"))
		nComis2 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis2 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"2"),"A3_COMIS") == 0, nComis2,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"2"),"A3_COMIS"))
		nComis2 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis2,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf
If cPos3  > 0
	If !Empty(&(cVEND+"3"))
		nComis3 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis3 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"3"),"A3_COMIS") == 0, nComis3,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"3"),"A3_COMIS"))
		nComis3 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis3,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf
If cPos4  > 0
	If !Empty(&(cVEND+"4"))
		nComis4 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis4 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"4"),"A3_COMIS") == 0, nComis4,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"4"),"A3_COMIS"))
		nComis4 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis4,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf
If cPos5  > 0
	If !Empty(&(cVEND+"5"))
		nComis5 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis5 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"5"),"A3_COMIS") == 0, nComis5,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"5"),"A3_COMIS"))
		nComis5 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis5,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf



RestArea(aAreaAnt)

If nTp == 1
	If cAlias == "SCJ"
		dbSelectArea("TMP1")
		&(cComis+"1") := nComis1
		&(cComis+"2") := nComis2
		&(cComis+"3") := nComis3
		&(cComis+"4") := nComis4
		&(cComis+"5") := nComis5
	else
		aCols[n,GdFieldPos((cComis+"1"),aHeader)]:= nComis1
		aCols[n,GdFieldPos((cComis+"2"),aHeader)]:= nComis2
		aCols[n,GdFieldPos((cComis+"3"),aHeader)]:= nComis3
		aCols[n,GdFieldPos((cComis+"4"),aHeader)]:= nComis4
		aCols[n,GdFieldPos((cComis+"5"),aHeader)]:= nComis5
	endif

Else
	Return(nComis1+nComis2+nComis3+nComis4+nComis5)
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCus    บAutor  ณJoao Tavares Junior บ Data ณ  03/28/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetCus(cProduto,nQtdVend,nTipRet,nMoeda,cPrcCm1)
Local aAreaCus  	:= ( GetArea() )
Local cFornece		:= ""
Local nCustoMedUnit := 0
Local lValid		:= .T.
Local cTabPreco		:= ""
Local cGrupo		:= ""
Local lcusSb2		:= .T.
Local cGet2	 := Space(25)
Local dGet3	 := CtoD("/ /")
Local nGet1	 := 0
Local oGet1
Local oGet2
Local oGet3
Local aRet

// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
Default nMoeda 		:= 1
Default nTipRet 	:= 1

dbSelectArea("SB1")
dbSetOrder(1)

cFornece	:=Posicione("SB1",1,xFilial("SB1") + (cProduto),"B1_PROC+B1_LOJPROC")
cGrupo 		:=Posicione("SB1",1,xFilial("SB1") + (cProduto),"B1_GRUPO")
Default cPrcCm1		:=Posicione("SB1",1,xFilial("SB1") + (cProduto),"B1_PRCCM1")

dbSelectArea("SBM")
dbSetOrder(1)
cTabPreco		:=Posicione("SBM",1,xFilial("SBM") + (cGrupo),"BM_TABPRC")
If Empty(cTabPreco)
	dbSelectArea("SA2")
	dbSetOrder(1)
	cTabPreco	:=Posicione("SA2",1,xFilial("SA2") + (cFornece),"A2_CODTAB")
endIf

If cPrcCm1 == "S"
	dbSelectArea("SB2")
	dbSetOrder(1) //Produto + Armazem
	IF SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))

		nCustoMedUnit := SB2->B2_CM1

		// Verifica se o Saldo Atual e Menor do que a Qtd Vendida
		If SB2->B2_QATU < nQtdVend  .Or. nCustoMedUnit == 0

			lValid  := MaVldTabCom(SB1->B1_PROC,SB1->B1_LOJPROC,cTabPreco,,,dDatabase)
			If lValid
				nCustoMedUnit := 	MaTabPrCom(cTabPreco,SB1->B1_COD,nQtdVend,SB1->B1_PROC,SB1->B1_LOJPROC,nMoeda,dDatabase)
				lcusSb2		:= .F.
			EndIf
		EndIf
	EndIf
Else
	If cPrcCm1 == "2"
		cTabPreco := If(FunName()=="MATA415",M->CK_TABPRC,M->C6_TABPRC)
	EndIf
	lValid  := MaVldTabCom(SB1->B1_PROC,SB1->B1_LOJPROC,cTabPreco,,,dDatabase)
	If lValid
		nCustoMedUnit := 	MaTabPrCom(cTabPreco,SB1->B1_COD,nQtdVend,SB1->B1_PROC,SB1->B1_LOJPROC,nMoeda,dDatabase)
	Else
          aRet := {"",0}

	EndIf
	lcusSb2		:= .F.
EndIf


RestArea(aAreaCus)
If nTipRet == 1
	aRet := ({nCustoMedUnit})
Else
	If lcusSb2
		cTabPreco := "SB2"
	EndIf
	aRet := ({cTabPreco,nCustoMedUnit,"",cToD(" /  /  ")})
EndIf

If Empty(aRet[1]) .Or. aRet[2]==0

//Return({cGet2,nGet1,dGet3}

// REGRA CRIADA POR ROBSON PARA QUE O SISTEMA NAO FIQUE PERGUNTANDO O CUSTO A NAO SER QUANDO O CODIGO FOR ALTERADO

 IF cProduto=SB1->B1_COD
      IF FunName()=="MATA415"
        nGet1:= IIF(ReadVar()=='M->CK_CUSUNIT', M->CK_CUSUNIT, TMP1->CK_CUSUNIT)
        cGet2:= IIF(ReadVar()=='M->CK_FONTE', M->CK_FONTE, TMP1->CK_FONTE)
        dGet3:= IIF(ReadVar()=='M->CK_DTVALID', M->CK_DTVALID, TMP1->CK_DTVALID)
      ELSE
        nGet1:= IIF(ReadVar()=='M->C6_CUSUNIT', M->C6_CUSUNIT, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CUSUNIT"})])
        cGet2:= IIF(ReadVar()=='M->C6_FONTE', M->C6_FONTE, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FONTE"})])
        dGet3:= IIF(ReadVar()=='M->C6_DTVLCUS', M->C6_DTVLCUS, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVLCUS"})])
      ENDIF
 ENDIF
 if nGet1>0 .AND. cProduto=SB1->B1_COD
 else
	DEFINE MSDIALOG oDlg TITLE "Informe de Pre็o" FROM C(223),C(419) TO C(475),C(684) PIXEL
	// Cria Componentes Padroes do Sistema
	@ C(002),C(004) Say "O produto digitado nใo tem parโmetros fornecidos pelo sistema para formar pre็o de venda, favor informar custo, fonte e validade." Size C(118),C(024) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(038),C(004) Say "Custo (Sem Impostos):" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(038),C(060) MsGet oGet1 Var nGet1 Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg
	@ C(052),C(004) Say "Fonte (Fornecedor):" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(052),C(060) MsGet oGet2 Var cGet2 F3 "SA2" Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(065),C(004) Say "Validade :" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(065),C(060) MsGet oGet3 Var dGet3 Size C(060),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
	//@ C(099),C(055) Button "Ok" Size C(028),C(012) PIXEL OF oDlg ACTION(odlg:end())
	@ C(099),C(092) Button "Ok" Size C(028),C(012) PIXEL OF oDlg ACTION(odlg:end())

	// Cria ExecBlocks dos Componentes Padroes do Sistema

	ACTIVATE MSDIALOG oDlg CENTERED
    endif
    aRet := ({"INF",nGet1,cGet2,dGet3})

  EndIf

Return (aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetImpos  บAutor  ณMicrosiga           บ Data ณ  03/28/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetImpos(TES)

Local aAreaImp  := ( GetArea() )
Local nImpostos := 0
Local nSPercImp	:= 0
Local nRetImp	:= 0

If FunName() == "MATA415"
	U_Ma415Impos()
	nImpostos := TMP1->CK_PIS + TMP1->CK_COFINS + TMP1->CK_IPI + TMP1->CK_VLICM
ElseIf FunName() == "MATA410"

	nImpostos := aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VLICM"})];
	+ aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_IPI"})];
	+ aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PIS"})];
	+ aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COFINS"})]
Else
	nImpostos := 0
EndIf

nSPercImp := 1 - ((nImpostos) /100)


//Calculo o % Imposto
If  nImpostos == 0
	nRetImp := 0
Else
	nRetImp := nSPercImp
EndIf

RestArea(aAreaImp)

Return(nRetImp)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ GetTxs   ณ  Joao Tavares Junior          ณ Data ณ21.03.2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Inicializa os campos de Porcentagem e Valor do Produto     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Funcao para ficar no Valid do CK_Produto                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GetTxs(cAlias)

Local aAreatxs 	:= ( GetArea() )
Local nRetTxs	:= 0
Local nRetComis := 0
Local cProduto := ""
If cAlias = "SCJ"
	cProduto := IIF(ReadVar()=='M->CK_PRODUTO', "M->CK_PRODUTO", "TMP1->CK_PRODUTO")
Else
	cProduto := IIF(ReadVar()=='M->C6_PRODUTO', "M->C6_PRODUTO", "ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=='C6_PRODUTO'})]")
EndIf


dbSelectArea("SB1")
dbSetOrder(1)

If SB1->(dbSeek(xFilial("SB1") + &(cPRODUTO)))
	If !Empty(SB1->B1_GRPVAR)

		dbSelectArea("PA7")
		dbSetOrder(1)

		If PA7->(dbSeek(xFilial("PA7") + SB1->B1_GRPVAR))
			nRetComis := u_RetComis(cAlias,2) //nRetComis := u_RetComis("SCJ",2)
			nRetTxs	:= 1-((PA7->PA7_FRETE + PA7->PA7_MRG + PA7->PA7_TXFIN + nRetComis)/100)
		Endif
	Endif

Else

	MsgInfo("Produto nใo possui grupo de variaveis informado. Verifique no cadastro de produto","Atencao")

EndIf
RestArea(aAreaTxs)

Return (nRetTxs)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldUser   บAutor  ณMicrosiga           บ Data ณ  04/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldUser(cCampo)
Local nRec, nOrd, lRet, cValid,cAlias

cAlias:=Alias()
dbSelectArea("SX3")
nRec := Recno()
nOrd := IndexOrd()
dbSetOrder(2)
dbSeek(cCampo)
dbSetOrder(nOrd)
dbSelectArea(cAlias)

cValid := IIf(!Empty(SX3->X3_VLDUSER),Alltrim(SX3->X3_VLDUSER),"")

IF !Empty(cValid)
	Help := .t.
	lRet := &(cValid)
	Help := .f.
	IF lRet == .f.
		Help(" ",1,cCampo)
	Endif
Else
	lRet := .t.
Endif
dbSelectArea("SX3")
dbGoto(nRec)
dbSelectArea(cAlias)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHCAMARRA  บAutor  ณMicrosiga           บ Data ณ  04/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBLOQUEA ALTERACAO SE OC AMARRADA AO PV                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCAMARRA()
Local aAreaSC6 	:= GetArea()
LOCAL LRET:=.T.
Local cItem:=IIF(ReadVar()="M->C6_ITEM", "M->C6_ITEM", "ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=='C6_ITEM'})]")
Local cNum:=M->C5_NUM
dbSelectArea("SZK")
DbSetOrder(1)
IF SZK->(dbSeek(xFilial("SZK") +"PV"+cNum+&(cItem)))
  MsgInfo("Alteracao do Item de Pedido nao permitido...Existe Amarracoes em compras para este item","Atencao")
  //MsgInfo("Produto nใo possui grupo de variaveis informado. Verifique no cadastro de produto","Atencao")
  LRET:=.F.
ENDIF
dbSelectArea("PC2")
DbSetOrder(4)
MsSeek(xFilial("PC2")+CNum+&(cItem)+"000002")
WHILE (!Eof() .AND. PC2->PC2_NUM=cNum .AND. PC2->PC2_ITEM=&(cItem) .AND. PC2->PC2_SEQ="000002".and. lRet=.T.)
    if PC2->PC2_QTD >0
      MsgInfo("Alteracao de Item de Pedido nao permitida... O PV tem Controle de Processo... Somente o Depto Diligenciamento pode Liberar o Pedido")
      LRET:=.F. 
    ENDIF
    DBSKIP()
EndDo  
RestArea(aAreaSC6)
RETURN (LRET)
             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHCCVAL    บAutor  ณMicrosiga           บ Data ณ  04/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBLOQUEA ALTERACAO SE OC AMARRADA AO PV                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCCVAL(cOrigem)
Local cConverte:=""
Local nValor:=0
IF LEN(cOrigem)=0 
ELSE
for x:=1 to Len(cOrigem)
               if substring(cOrigem,x,1) $ "0/1/2/3/4/5/6/7/8/9/./,"
               if substring(cOrigem,x,1)="."
               else
                 if substring(cOrigem,x,1)=","
                   cConverte:=cConverte+"."
                 else
                   cConverte:=cConverte+substring(cOrigem,x,1)
                 endif
               endif
               endif
next
if Len(cConverte)>0 
  nValor:=VAL(cConverte)
endif
ENDIF
return(nvalor)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento para tema "Flat"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)
