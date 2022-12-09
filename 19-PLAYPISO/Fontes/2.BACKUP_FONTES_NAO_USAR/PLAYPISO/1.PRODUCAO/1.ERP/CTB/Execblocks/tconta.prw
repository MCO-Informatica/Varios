#Include "Protheus.ch"

User Function tconta(nAcao)
Local aArea    := GetArea()
Local nRet    := 0
Local xContaCli:= ""
Local cSeekSD2 := ""
Local lServ    := .F.
Local lRemessa := .F.
Local lVenda   := .F.



DEFAULT nAcao := 1

DbSelectArea("SA1")
DbSetorder(1)
DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
If SA1->A1_COD == SF2->F2_CLIENTE .AND. SA1->A1_LOJA == SF2->F2_LOJA
	xContaCli:= SA1->A1_CONTA
Endif


DbSelectArea("SD2")
SD2->(DbSetOrder(3))
If SD2->(DbSeek(cSeekSD2 := xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
	While SD2->(!Eof()) .And. SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA ) == cSeekSD2
		If SD2->D2_TES$"502/522/523/524/525/526/528/529"  //adicionado tes 528,526 ,529   por Nádia em 30/0608
			lServ := .T.
		Endif                                  
		
		If SD2->D2_TES$ "520/527"   //513 não contab. /incluido 527 - alterado em 30/06/08 por Nádia
			lRemessa := .T.
		Endif
		
		If ALLTRIM(SD2->D2_CF)$"5102/6102/5551/6551/6502/5502"  //adicionado 5551/6551/6502 em 30/06/08 por Nádia
			lVenda := .T.
		Endif
		SD2->(DBSKIP())
	Enddo
	
	If lServ
		If nAcao == 1 //-- Acao 1 = Debito
			nRet := xContacli
		ElseIf nAcao == 2 //-- Acao 2 Credito
			nRet := "31100100001"
		Elseif nAcao == 3// -- Historico
			nRet := "Vr. Serviços prestados Conf.nf  "
		EndIf
	EndIF
	
	
	If lRemessa
		If nAcao == 1 //-- Acao 1 = Debito
			nRet := "41100100001"
		ElseIf nAcao == 2 //-- Acao 2 Credito
			nRet := "11400100001"
		Elseif nAcao == 3 // -- Historico
			nRet := "Transferencia Material  Conforme nf "
		EndIf
	EndIF
	
	If lVenda
		If nAcao == 1 //-- Acao 1 = Debito
			nRet := xContacli
		ElseIf nAcao == 2 //-- Acao 2 Credito
			nRet := "31200100001"
		Elseif nAcao == 3 // -- Historico
			nRet := "Vr. Venda  Conf. nf "
		EndIf
	EndIF
EndIf

RestArea(aArea)


Return nRet



