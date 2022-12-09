#INCLUDE "RWMAKE.ch" 
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ACD100VG  ³ Autor ³ Marcio Almenara      ³ Data ³ 10/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seta nova Ordem no SC9                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION ACD100VG()

Local nI
Local cCodOpe
Local aRecSC9	:= {}
Local aOrdSep	:= {}
Local cArm		:= Space(Tamsx3("B1_LOCPAD")[1])
Local cPedido	:= Space(6)
Local cCliente	:= Space(6)
Local cLoja		:= Space(2)
Local cCondPag	:= Space(3)
Local cLojaEnt	:= Space(2)
Local cAgreg	:= Space(4)
Local cOrdSep	:= Space(4)
Local cTipExp	:= ""
Local nPos      := 0
Local nMaxItens	:= GETMV("MV_NUMITEN")			//Numero maximo de itens por nota (neste caso por ordem de separacao)- by Erike
Local lConsNumIt:= SuperGetMV("MV_CBCNITE",.F.,.T.) //Parametro que indica se deve ou nao considerar o conteudo do MV_NUMITEN
Local lFilItens	:= ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
Local lLocOrdSep:= .F.
Private aLogOS	:= {}
nMaxItens := If(Empty(nMaxItens),99,nMaxItens)



ProcRegua( SC9->( LastRec() ), "oook" )
cCodOpe	 := cSeparador
SC5->(DbSetOrder(1));SC6->(DbSetOrder(1));SDC->(DbSetOrder(1));CB7->(DbSetOrder(2));CB8->(DbSetOrder(2))
SC9->(dbGoTop())

If nEmbSimul == 1 // Separacao com Embalagem Simultanea
	cTipExp := "01*"
Else
	cTipExp := "00*" // Separacao Simples
EndIF
If nEmbalagem == 1 // Embalagem
	cTipExp += "02*"
EndIF
If nGeraNota == 1 // Gera Nota
	cTipExp += "03*"
EndIF
If nImpNota == 1 // Imprime Nota
	cTipExp += "04*"
EndIF
If nImpEtVol == 1 // Imprime Etiquetas Oficiais de Volume
	cTipExp += "05*"
EndIF
If nEmbarque == 1 // Embarque
	cTipExp += "06*"
EndIF
If nAglutPed == 1 // Aglutina pedido
	cTipExp +="11*"
EndIf
If nAglutArm == 1 // Aglutina armazem
	cTipExp +="08*"
EndIf
If MV_PAR10 ==1 // pre-separacao
	cTipExp +="09*"
EndIf
If nConfLote == 1 // confere lote
	cTipExp +="10*"
EndIf

Dbselectarea("SC9")
DbsetOrder(10)
SC9->(dbGoTop())

While !SC9->(Eof())
		If ! SC9->(IsMark("C9_OK",ThisMark(),ThisInv()))
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If !Empty(SC9->(C9_BLEST+C9_BLCRED+C9_BLOQUEI))
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If lFilItens
		If !ExecBlock("ACDA100I",.F.,.F.)
			SC9->(DbSkip())
			IncProc()
			Loop
		Endif
	Endif
	//pesquisa se este item tem saldo a separar, caso tenha, nao gera ordem de separacao
	If CB8->(DbSeek(xFilial('CB8')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN+SC9->C9_PRODUTO)) .and. CB8->CB8_SALDOS > 0
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Existe saldo a separar deste item","NAO_GEROU_OS"}) //"Pedido"###"Existe saldo a separar deste item"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf

	If ! SC5->(DbSeek(xFilial('SC5')+SC9->C9_PEDIDO))
		// neste caso a base tem sc9 e nao tem sc5, problema de incosistencia de base
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Inconsistencia de base (SC5 x SC9)","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC5 x SC9)"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If ! SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
		// neste caso a base tem sc9,sc5 e nao tem sc6,, problema de incosistencia de base
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Inconsistencia de base (SC6 x SC9)","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC6 x SC9)"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf

	If !("08*" $ cTipExp)  // gera ordem de separacao por armazem
		cArm :=SC6->C6_LOCAL
	Else  // gera ordem de separa com todos os armazens
		cArm :=Space(Tamsx3("B1_LOCPAD")[1])
	EndIf
	If "11*" $ cTipExp //AGLUTINA TODOS OS PEDIDOS DE UM MESMO CLIENTE
		cPedido := Space(6)
	Else   // Nao AGLUTINA POR PEDIDO
		cPedido := SC9->C9_PEDIDO
	EndIf
	If "09*" $ cTipExp // AGLUTINA PARA PRE-SEPARACAO
		cPedido  := Space(6) // CASO SEJA PRE-SEPARACAO TEM QUE CONSIDERAR TODOS OS PEDIDOS
		cCliente := Space(6)
		cLoja    := Space(2)
		cCondPag := Space(3)
		cLojaEnt := Space(2)
		cAgreg   := Space(4)
	Else   // NAO AGLUTINA PARA PRE-SEPARACAO
		cCliente := SC6->C6_CLI
		cLoja    := SC6->C6_LOJA
		cCondPag := SC5->C5_CONDPAG
		cLojaEnt := SC5->C5_LOJAENT
		cAgreg   := SC9->C9_AGREG
	EndIf

	lLocOrdSep := .F.
	If CB7->(DbSeek(xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg))
		While CB7->(!Eof() .and. CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG==;
								xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg)
			If CB7->CB7_ORDSEP==cOrdSep
				lLocOrdSep := .T.
				Exit
			EndIf
			CB7->(DbSkip())
		EndDo
	EndIf

	If Localiza(SC9->C9_PRODUTO)
		If ! SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
			// neste caso nao existe composicao de empenho
			//Grava o historico das geracoes:
			aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Nao existe composicao de empenho (SDC)","NAO_GEROU_OS"}) //"Pedido"###"Nao existe composicao de empenho (SDC)"
			SC9->(DbSkip())
			IncProc()
			Loop
		EndIf
	EndIf

	If !lLocOrdSep .or. (("03*" $ cTipExp) .and. !("09*" $ cTipExp) .and. lConsNumIt .And. CB7->CB7_NUMITE >=nMaxItens)

		cOrdSep := CB_SXESXF("CB7","CB7_ORDSEP",,1)
		ConfirmSX8()

		CB7->(RecLock( "CB7",.T.))
		CB7->CB7_FILIAL := xFilial( "CB7" )
		CB7->CB7_ORDSEP := cOrdSep
		CB7->CB7_PEDIDO := cPedido
		CB7->CB7_CLIENT := cCliente
		CB7->CB7_LOJA   := cLoja
		CB7->CB7_COND   := cCondPag
		CB7->CB7_LOJENT := cLojaEnt
		CB7->CB7_LOCAL  := cArm
		CB7->CB7_DTEMIS := dDataBase
		CB7->CB7_HREMIS := Time()
		CB7->CB7_STATUS := " "
		CB7->CB7_CODOPE := cCodOpe
		CB7->CB7_PRIORI := "1"
		CB7->CB7_ORIGEM := "1"
		CB7->CB7_TIPEXP := cTipExp
		CB7->CB7_TRANSP := SC5->C5_TRANSP
		CB7->CB7_AGREG  := cAgreg 
		If	ExistBlock("A100CABE")
			ExecBlock("A100CABE",.F.,.F.)
		EndIf
		CB7->(MsUnlock())

		aadd(aOrdSep,CB7->CB7_ORDSEP)
	EndIf
	//Grava o historico das geracoes:
	nPos := Ascan(aLogOS,{|x| x[01]+x[02]+x[03]+x[04]+x[05]+x[10] == ("1"+"Pedido"+SC9->(C9_PEDIDO+C9_CLIENTE+C9_LOJA)+CB7->CB7_ORDSEP)})
	If nPos == 0
		aadd(aLogOS,{"1","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"","",cArm,"",CB7->CB7_ORDSEP}) //"Pedido"
	Endif

	If Localiza(SC9->C9_PRODUTO)
		While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+;
			DC_ITEM+DC_SEQ==xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM+C9_SEQUEN))

			SB1->(DBSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+SDC->DC_PRODUTO)) .AND. Alltrim(SB1->B1_TIPO) == "MO"
				SDC->(DbSkip())
				Loop
			Endif

			CB8->(RecLock("CB8",.T.))
			CB8->CB8_FILIAL := xFilial("CB8")
			CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
			CB8->CB8_ITEM   := SC9->C9_ITEM
			CB8->CB8_PEDIDO := SC9->C9_PEDIDO
			CB8->CB8_PROD   := SDC->DC_PRODUTO
			CB8->CB8_LOCAL  := SDC->DC_LOCAL
			CB8->CB8_QTDORI := SDC->DC_QUANT
			If "09*" $ cTipExp
				CB8->CB8_SLDPRE := SDC->DC_QUANT
			EndIf
			CB8->CB8_SALDOS := SDC->DC_QUANT
			If ! "09*" $ cTipExp .AND. nEmbalagem == 1
				CB8->CB8_SALDOE := SDC->DC_QUANT
			EndIf
			CB8->CB8_LCALIZ := SDC->DC_LOCALIZ
			CB8->CB8_NUMSER := SDC->DC_NUMSERI
			CB8->CB8_SEQUEN := SC9->C9_SEQUEN
			CB8->CB8_LOTECT := SC9->C9_LOTECTL
			CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
			CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1"," ")
			CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
			If	ExistBlock("ACD100GI")
				ExecBlock("ACD100GI",.F.,.F.)
			EndIf
			CB8->(MsUnLock())
			//Atualizacao do controle do numero de itens a serem impressos
			RecLock("CB7",.F.)
			CB7->CB7_NUMITE++
			CB7->(MsUnLock())
			SDC->( dbSkip() )
		EndDo
	Else
		CB8->(RecLock("CB8",.T.))
		CB8->CB8_FILIAL := xFilial("CB8")
		CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
		CB8->CB8_ITEM   := SC9->C9_ITEM
		CB8->CB8_PEDIDO := SC9->C9_PEDIDO
		CB8->CB8_PROD   := SC9->C9_PRODUTO
		CB8->CB8_LOCAL  := SC9->C9_LOCAL
		CB8->CB8_QTDORI := SC9->C9_QTDLIB
		If "09*" $ cTipExp
			CB8->CB8_SLDPRE := SC9->C9_QTDLIB
		EndIf
		CB8->CB8_SALDOS := SC9->C9_QTDLIB
		If ! "09*" $ cTipExp .AND. nEmbalagem == 1
			CB8->CB8_SALDOE := SC9->C9_QTDLIB
		EndIf
		CB8->CB8_LCALIZ := ""
		CB8->CB8_NUMSER := SC9->C9_NUMSERI
		CB8->CB8_SEQUEN := SC9->C9_SEQUEN
		CB8->CB8_LOTECT := SC9->C9_LOTECTL
		CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
		CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1"," ")
		CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
		If	ExistBlock("ACD100GI")
			ExecBlock("ACD100GI",.F.,.F.)
		EndIf
		CB8->(MsUnLock())

		//Atualizacao do controle do numero de itens a serem impressos
		RecLock("CB7",.F.)
		CB7->CB7_NUMITE++
		CB7->(MsUnLock())
	EndIf
	aadd(aRecSC9,{SC9->(Recno()),CB7->CB7_ORDSEP})
	IncProc()
	SC9->( dbSkip() )
EndDo

CB7->(DbSetOrder(1))
For nI := 1 to len(aOrdSep)
	CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
	CB7->(RecLock("CB7"))
	CB7->CB7_STATUS := "0"  // nao iniciado
	CB7->(MsUnlock())
	If	ExistBlock("ACDA100F")
		ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
	EndIf
Next
For nI := 1 to len(aRecSC9)
	SC9->(DbGoto(aRecSC9[nI,1]))
	SC9->(RecLock("SC9"))
	SC9->C9_ORDSEP := aRecSC9[nI,2]
	SC9->(MsUnlock())
Next
If !Empty(aLogOS)
	Log100VG()
Endif

Dbselectarea("SC9")
DbsetOrder(1)

Return(.F.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LogACDA100³ Autor ³ Henrique Gomes Oikawa ³ Data ³ 23/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibicao do log das geracoes das Ordens de Separacao       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Apos a geracao das OS sao exibidas todas as informacoes que³±±
±±³          ³ ocorreram durante o processo                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Log100VG()
Local i, j, k
Local cChaveAtu, cPedCli, cOPAtual

//Cabecalho do Log de processamento:
AutoGRLog(Replicate("=",75))
AutoGRLog("                         I N F O R M A T I V O") //"                         I N F O R M A T I V O"
AutoGRLog("               H I S T O R I C O   D A S   G E R A C O E S") //"               H I S T O R I C O   D A S   G E R A C O E S"

//Detalhes do Log de processamento:
AutoGRLog(Replicate("=",75))
AutoGRLog("I T E N S   P R O C E S S A D O S :") //"I T E N S   P R O C E S S A D O S :"
AutoGRLog(Replicate("=",75))
If aLogOS[1,2] == "Pedido" //"Pedido"
	aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[10]+x[03]+x[04]+x[05]+x[06]+x[07]+x[08]<y[01]+y[10]+y[03]+y[04]+y[05]+y[06]+y[07]+y[08]})
	// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Pedido + Cliente + Loja + Item + Produto + Local
	cChaveAtu := ""
	cPedCli   := ""
	For i:=1 to len(aLogOs)
		If aLogOs[i,10] <> cChaveAtu .OR. (aLogOs[i,03]+aLogOs[i,04] <> cPedCli)
			If !Empty(cChaveAtu)
				AutoGRLog(Replicate("-",75))
			Endif
			j:=0
			k:=i  //Armazena o conteudo do contador do laco logico principal (i) pois o "For" j altera o valor de i;
			cChaveAtu := aLogOs[i,10]
			For j:=k to len(aLogOs)
				If aLogOs[j,10] <> cChaveAtu
					Exit
				Endif
				If Empty(aLogOs[j,08]) //Aglutina Armazem
					AutoGRLog("Pedido: "+aLogOs[j,03]+" - Cliente: "+aLogOs[j,04]+"-"+aLogOs[j,05]) //"Pedido: "###" - Cliente: "
				Else
					AutoGRLog("Pedido: "+aLogOs[j,03]+" - Cliente: "+aLogOs[j,04]+"-"+aLogOs[j,05]+" - Local: "+aLogOs[j,08]) //"Pedido: "###" - Cliente: "###" - Local: "
				Endif
				cPedCli := aLogOs[j,03]+aLogOs[j,04]
				If aLogOs[j,10] == "NAO_GEROU_OS"
					Exit
				Endif
				i:=j
			Next
			AutoGRLog("Ordem de Separacao: "+If(aLogOs[i,01]=="1",aLogOs[i,10],"N A O  G E R A D A")) //"Ordem de Separacao: "###"N A O  G E R A D A"
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog("Motivo: ") //"Motivo: "
			Endif
		Endif
		If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
			AutoGRLog("Item"+aLogOs[i,06]+" - Produto: "+AllTrim(aLogOs[i,07])+" - Local: "+aLogOs[i,08]+" ---> "+aLogOs[i,09]) //"Item: "###" - Produto: "###" - Local: "
		Endif
	Next
Elseif aLogOS[1,2] == "Nota" //"Nota"
	aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[08]+x[03]+x[04]+x[05]+x[06]<y[01]+y[08]+y[03]+y[04]+y[05]+y[06]})
	// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Nota + Serie + Cliente + Loja
	cChaveAtu := ""
	For i:=1 to len(aLogOs)
		If aLogOs[i,08] <> cChaveAtu
			If !Empty(cChaveAtu)
				AutoGRLog(Replicate("-",75))
			Endif
			cChaveAtu := aLogOs[i,08]
			AutoGRLog("Nota: "+aLogOs[i,3]+"/"+aLogOs[i,04]+" - Cliente: "+aLogOs[i,05]+"-"+aLogOs[i,06]) //"Nota: "###" - Cliente: "
			AutoGRLog("Ordem de Separacao: "+If(aLogOs[i,01]=="1",aLogOs[i,08],"N A O  G E R A D A")) //"Ordem de Separacao: "###"N A O  G E R A D A"
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog("Motivo: ") //"Motivo: "
			Endif
		Endif
	Next
Else  //Ordem de Producao
	aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[07]+x[03]+x[04]<y[01]+y[07]+y[03]+y[04]})
	// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Ordem Producao + Produto
	cChaveAtu := ""
	cOPAtual  := ""
	For i:=1 to len(aLogOs)
		If aLogOs[i,07] <> cChaveAtu .OR. aLogOs[i,03] <> cOPAtual
			If !Empty(cChaveAtu)
				AutoGRLog(Replicate("-",75) )
			Endif
			j:=0
			k:=i  //Armazena o conteudo do contador do laco logico principal (i) pois o "For" j altera o valor de i;
			cChaveAtu := aLogOs[i,07]
			For j:=k to len(aLogOs)
				If aLogOs[j,07] <> cChaveAtu
					Exit
				Endif
				If Empty(aLogOs[j,05]) //Aglutina Armazem
					AutoGRLog("Ordem de Producao: "+aLogOs[i,03]) //"Ordem de Producao: "
				Else
					AutoGRLog("Ordem de Producao: "+aLogOs[i,03]+" - Local: "+aLogOs[j,05]) //"Ordem de Producao: "###" - Local: "
				Endif
				cOPAtual := aLogOs[j,03]
				If aLogOs[j,07] == "NAO_GEROU_OS"
					Exit
				Endif
				i:=j
			Next
			AutoGRLog("Ordem de Separacao: "+If(aLogOs[i,01]=="1",aLogOs[i,07],"N A O  G E R A D A")) //"Ordem de Separacao: "###"N A O  G E R A D A"
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog("Motivo: ") //"Motivo: "
			Endif
		Endif
		If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
			AutoGRLog(" ---> "+aLogOs[i,06])
		Endif
	Next
Endif
MostraPVG(aLogOS[1,2])
MostraErro()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MostraParam ³ Autor ³ Henrique Gomes Oikawa ³ Data ³ 28/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibicao dos parametros da geracao da Ordem de Separacao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MostraPVG(cTipGer)
Local cPergParam  := ""
Local cPergConfig := ""
Local cDescTipGer := ""
Local nTamSX1     := Len(SX1->X1_GRUPO)
Local aPerg       := {}
Local aParam      := {}
Local ni          := 0
Local ci          := 0
Local aLogs       := {}

If cTipGer == "Pedido" //"Pedido"
	cPergParam  := PADR('AIA102',nTamSX1)
	cPergConfig := PADR('AIA106',nTamSX1)
	cDescTipGer := 'PEDIDO DE VENDA' //'PEDIDO DE VENDA'
	aAdd(aParam,nConfLote)
	aAdd(aParam,nEmbSimul)
	aAdd(aParam,nEmbalagem)
	aAdd(aParam,nGeraNota)
	aAdd(aParam,nImpNota)
	aAdd(aParam,nImpEtVol)
	aAdd(aParam,nEmbarque)
	aAdd(aParam,nAglutPed)
	aAdd(aParam,nAglutArm)
Elseif cTipGer == "Nota" //"Nota"
	cPergParam  := PADR('AIA103',nTamSX1)
	cPergConfig := PADR('AIA107',nTamSX1)
	cDescTipGer := 'NOTA FISCAL' //'NOTA FISCAL'
	aAdd(aParam,nEmbSimuNF)
	aAdd(aParam,nEmbalagNF)
	aAdd(aParam,nImpNotaNF)
	aAdd(aParam,nImpVolNF)
	aAdd(aParam,nEmbarqNF)
Else //OP
	cPergParam  := PADR('AIA104',nTamSX1)
	cPergConfig := PADR('AIA108',nTamSX1)
	cDescTipGer := 'ORDEM DE PRODUCAO' //'ORDEM DE PRODUCAO'
	aAdd(aParam,nReqMatOP)
	aAdd(aParam,nAglutArmOP)
Endif

aAdd(aPerg,{"P A R A M E T R O S : "+cDescTipGer,cPergParam}) //"P A R A M E T R O S : "
aAdd(aPerg,{"C O N F I G U R A C O E S : "+cDescTipGer,cPergConfig}) //"C O N F I G U R A C O E S : "
//-- Carrega parametros SX1
SX1->(DbSetOrder(1))
For ni := 1 To Len(aPerg)
	ci := 1
	aAdd(aLogs,{aPerg[ni,2],{}})
	SX1->(DbSeek(aPerg[ni,2]))
	While SX1->(!Eof() .AND. X1_GRUPO == aPerg[ni,2])
		If	SX1->X1_GSC == 'G'
			cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+Alltrim(X1_CNT01)) //"Pergunta "
		Else
			If	ni == 1
				cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(X1_PRESEL==1,'Sim','Nao')) //"Pergunta "###'Sim'###'Nao'
			Else
				cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(aParam[ci++]==1,'Sim','Nao')) //"Pergunta "###'Sim'###'Nao'
			EndIf
		EndIf
		aAdd(aLogs[ni,2],cTexto)
		SX1->(dbSkip())
	EndDo
Next
//-- Gera Log
For ni := 1 To Len(aPerg)
	AutoGRLog(Replicate("=",75))
	AutoGRLog(aPerg[ni,1])
	AutoGRLog(Replicate("=",75))
	For ci := 1 To Len(aLogs[ni,2])
		AutoGRLog(aLogs[ni,2,ci])
	Next
Next
AutoGRLog(Replicate("=",75))
Return
