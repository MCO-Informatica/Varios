#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA455ML º Autor ³   Luiz oliveira    º Data ³  25/07/18   º±±
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

	dbSelectArea(ParamIxb[1])  // Alias TRB do MarkBrowse
	dbGoTop()

	While !Eof()
		If U_FatorVal((ParamIxb[1])->TRB_LOTECT)    
			RecLock(ParamIxb[1],.f.)     
				dbdelete()
			MsUnLock()
		Endif 
		dbSelectArea(ParamIxb[1])
		dbSkip()
	EndDo
	Pack
	dbGotop()

	RestArea(aArea)


	dbSelectArea(ParamIxb[1])  // Alias TRB do MarkBrowse
	dbGoTop()
	
Return(nQtdSel)                                




User Function FatorVal(cLoteCtl)    // Retorna TRUE se o cLoteCtl NAO atende a regra do Fator de Validade
	Local lNaoPode 	:= .F.
	Local _cTipo := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_TIPO")


	If _cTipo <> 'MA'  
		dbSelectArea("SB8")
		dbSetOrder(3)         
		If dbSeek(xFilial("SB8") + SB1->B1_COD + SC6->C6_LOCAL + cLoteCtl)
			If SB8->B8_DTVALID < dDataBase 
			lNaoPode := .T. 
			Endif
		Endif
	Endif

Return(lNaoPode)