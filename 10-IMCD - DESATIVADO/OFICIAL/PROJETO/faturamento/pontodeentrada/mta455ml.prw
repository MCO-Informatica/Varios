#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA455ML º Autor ³   Daniel   Gondran º Data ³  15/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para excluir do browse de escolha de lotesº±±
±±º          ³ aqueles que nao atenderem a regra do fator de validade do  º±±
±±º          ³ cliente, na liberacao de estoque.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / liberacao estoque manual               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA455ML()

	Local aArea  	:= GetArea()
	Local lPode		:= .F.
	Local nQtdSel  	:= 0

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA455ML" , __cUserID )

	dbSelectArea(ParamIxb[1])  // Alias TRB do MarkBrowse
	dbGoTop()

	if  !(SC5->C5_TIPO $ "B/D") .and. !EMPTY((ParamIxb[1])->TRB_LOTECT)
		if !EMPTY(SA1->A1_OBSLOG)
			aviso("IMCD",SA1->A1_OBSLOG, {"OK"}, 3, "Mensagem", , "BR_AZUL")
		endif	
	endif

	While !Eof()
		If !(SC5->C5_TIPO $ "B/D") .and. U_FatorVal((ParamIxb[1])->TRB_LOTECT,ParamIxb[1])    

			//		oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA455ML - LOTE: "+ (ParamIxb[1])->TRB_LOTECT , __cUserID )

			RecLock(ParamIxb[1],.f.)     
			dbdelete()
			//		(ParamIxb[1])->TRB_QTDLIB := 0
			MsUnLock()
		Endif 
		dbSelectArea(ParamIxb[1])
		dbSkip()
	EndDo
	Pack
	dbGotop()

	RestArea(aArea)

Return(nQtdSel)                                




User Function FatorVal(cLoteCtl,cAliasFtVl)    // Retorna TRUE se o cLoteCtl NAO atende a regra do Fator de Validade
	Local lNaoPode 	:= .F.
	Local nFator	:= SA1->A1_FATVALI
	Local nDiasVal  := 0
	Local dDataLim
	Local _cTipo := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_TIPO")


	If nFator > 0  .AND. _cTipo <> 'MA'  // ALTERADO POR SANDRA NISHIDA EM 190516, EXCLUIDO AS AMOSTRAS
		lNaoPode := .T.
		dbSelectArea("SB8")
		dbSetOrder(3)         
		If dbSeek(xFilial("SB8") + SB1->B1_COD + SC6->C6_LOCAL + cLoteCtl)

			If Empty(SB8->B8_DFABRIC)
				Alert("Atenção: Lote " + AllTrim(SB8->B8_LOTECTL) + " do produto " + SB8->B8_PRODUTO + " sem data de fabricação! Verifique")
			Endif
			nDiasVal := SB8->B8_DTVALID - SB8->B8_DFABRIC 
			nDiasVal := nDiasVal * ( nFator / 100 )
			dDataLim := SB8->B8_DFABRIC + nDiasVal
		Endif

		If  dDataBase <= dDataLim
			lNaoPode := .F.
			//-------------------------------------------------
			//Equalizar data de validade da tabela temporária
			//-------------------------------------------------
			if SB8->B8_DTVALID <> (cAliasFtVl)->TRB_DTVALI
				RecLock(cAliasFtVl,.f.) 
				(cAliasFtVl)->TRB_DTVALI := SB8->B8_DTVALID 
				(cAliasFtVl)->(MsUnLock())	
			endif
		Endif
	Endif

Return(lNaoPode)
