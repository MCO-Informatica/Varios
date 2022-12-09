#Include "Protheus.ch"  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MT410CPY  ³ Autor ³ Luiz Alberto          ³ Data ³06/03/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Metalacre        ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada executado na opcao de copia do pedido de  ³±±        
±±³          ³ venda. Para tratamento de reutilizacao de numeracao de la- ³±±        
±±³          ³ cres para pedidos com devolucao.                           ³±±        
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nota de Entrada                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Adalberto Neto³20/02/14³Localizar no aCols o campo C6_LOTECTL e limpar ³±±
±±³              ³        ³o mesmo na copia do pedido de venda.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT410CPY()
Local lRet 			:= .T.
Local nPosITEM 		:= GDFIELDPOS("C6_ITEM")
Local nPosLACRE 	:= GDFIELDPOS("C6_XLACRE")
Local nPosQTDVEN 	:= GDFIELDPOS("C6_QTDVEN")
Local nPosPRCVEN 	:= GDFIELDPOS("C6_PRCVEN")
Local nPosRECALC 	:= GDFIELDPOS("C6_RECALC")
Local nPosTES 		:= GDFIELDPOS("C6_TES")
Local nPosCF 		:= GDFIELDPOS("C6_CF")
Local nPosStandy	:= GDFIELDPOS('C6_XSTAND')// Bruno Abrigo em 12.06.12
Local nPosVolIte 	:= GDFIELDPOS('C6_XVOLITE')       
Local nPosEMBALA 	:= GDFIELDPOS('C6_XEMBALA') 
Local nPosLotCtl 	:= GDFIELDPOS("C6_LOTECTL")
Local nx 			:= 1                                               
Local LMENSAGEM 	:= .F.                

Public _lReap   	:= .F.    
Public _cPedRep 	:= ''                      
Public _lStand  	:= .F.

If Type("_lCopy") == "U"
	Public _lCopy := .T.
Endif

If nPosStandy > 0
	For nx := 1 To Len(aCols)          
		IF !LMENSAGEM 
			if Acols[nX][nPosStandy] = '1' 
				MSGALERT("O pedido copiado trata-se de um pedido stand by, a condicao Stand By nao será replicada para a cópia do pedido")
				lMensagem := .T.
				_lStand   := .T.
			endif
		ENDIF	
		aCols[nX][nPosRECALC] 	:= '1'
		aCols[nX][nPosStandy]	:= ''
		aCols[nX][nPosLotCtl]	:= ''
	//	aCols[nX][nPosVolIte] := 0
	//	aCols[nX][nPosEMBALA] := ''
	//	aCols[nX][nPoslacre]  := SC6->C6_XLACRE
	Next
	
	cQry:=" SELECT F1_DOC
	cQry+=" FROM "+RetSqlName("SF1")+" F1, "+RetSqlName("SD1")+" D1, "+RetSqlName("SD2")+" D2, "+RetSqlName("SC5")+" C5 "
	cQry+=" WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
	cQry+=" AND C5_NUM = '" + SC5->C5_NUM + "' "
	cQry+=" AND D2_FILIAL = C5_FILIAL "
	cQry+=" AND D2_PEDIDO = C5_NUM "
	cQry+=" AND D1_NFORI = D2_DOC "
	cQry+=" AND F1_DOC = D1_DOC "
	cQry+=" AND F1_SERIE = D1_SERIE "
	cQry+=" AND F1_FORNECE = D1_FORNECE "
	cQry+=" AND F1_LOJA = D1_LOJA "
	cQry+=" AND F1.D_E_L_E_T_ = '' "
	cQry+=" AND D1.D_E_L_E_T_ = '' "
	cQry+=" AND D2.D_E_L_E_T_ = '' "
	cQry+=" AND C5.D_E_L_E_T_ = '' "
	
	DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)
	
	lOk := .f.
	TRB->(DbGoTop())
	If TRB->(!EOF())
		lOk := .t.
	Endif
	TRB->(dbCloseArea())
	
	// Pedido copiado possui devolucao de nota fiscal
	
	If lOk
		If msgyesno("Atenção o Pedido Origem Possui Nota Fiscal de Devolução" + Chr(13) + Chr(10) +;
			"Deseja efetuar o reaproveitamento da númeração de Lacres " + Chr(13) + Chr(10) +;
			"utilizada no pedido Origem ?","Reaproveita Lacres")
			                                      
			_lReap   := .T.
			_cPedRep := SC5->C5_NUM
		        
			// QDO UTILIZA O REAPROVEITAMENTO, A LINHA NAO ENTRA NO RECALCULO
			For nx := 1 To Len(aCols)  
				If !aCols[nx,Len(aHeader)+1] // se o acols náo estiver deleta processa.		
					aCols[nX][nPosRECALC] := '2'
				endif
		    Next
		Endif
	Endif
Endif    
Return lRet