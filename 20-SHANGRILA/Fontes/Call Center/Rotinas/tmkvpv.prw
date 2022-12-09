
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 18/08/11 - Rotina para tratamento do pedido de vendas gerado por TMK, conforme regra estabelecida

User Function TMKVFIM()

	//ALTERADO BRUNO 29-09-14
	local nPbrut     := 0
	local nUBZPeCub  := 0
	local nUBZCubage := 0
	//TERMINO BRUNO 29-09-14

//==========================================================================================================================================================

If M->UA_FLAG<>"1" .And. (M->UA_OPER=="1") //.And. (Alltrim(M->UA_X_CODRE)=="5130" .Or. Alltrim(M->UA_X_CODRE)=="5150")
	
	_cAlias_	:= Alias()
	_nRec_  	:= Recno()
	_cIndex_	:= IndexOrd()
	
	xEstNorte := GETMV("MV_NORTE")
	xNum	:=Alltrim(SC5->C5_NUM)
	xItem	:=0
	xArray	:={}
	xCol	:=1
	xCol1	:=1
	xCodRe	:=M->UA_X_CODRE
	xEst	:=POSICIONE("SA1",1,xfilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST")
	Iif (xEst=='SP', xRegiao := '1',Iif(xEst $ xEstNorte,xRegiao := '2',xRegiao := '3'))
	xMsgCli	:=POSICIONE("SA1",1,xfilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_MENSAGE")
	
	//==========================================================================================================================================================
	//Atualização do cabeçalho do pedido
	
	RecLock("SC5",.F.)
	SC5->C5_X_CODRE	:= M->UA_X_CODRE	//REGRA DESCONTO
	SC5->C5_DTENTR	:= M->UA_ENTREGA	//DATA ENTREGA
	SC5->C5_X_MENRO	:= M->UA_MENRO   //MENSAGEM ROMANEIO
	SC5->C5_MENNOTA	:= M->UA_MENNOTA	//MENSAGEM NOTA
	SC5->C5_MENPAD	:= xMsgCli		//MENSAGEM NO CADASTRO DE CLIENTE
	SC5->C5_DATA1	:= M->UA_DATA1	//VENCIMENTO 1
	SC5->C5_DATA2	:= M->UA_DATA2	//VENCIMENTO 2
	SC5->C5_DATA3	:= M->UA_DATA3	//VENCIMENTO 3
	SC5->C5_DATA4	:= M->UA_DATA4	//VENCIMENTO 4
	SC5->C5_PARC1	:= M->UA_PARC1	//PARCELA 1
	SC5->C5_PARC2	:= M->UA_PARC2	//PARCELA 2
	SC5->C5_PARC3	:= M->UA_PARC3	//PARCELA 3
	SC5->C5_PARC4	:= M->UA_PARC4	//PARCELA 4
	SC5->C5_VEND2	:= M->UA_VEND2	//VENDEDOR 2
	SC5->C5_COMIS2	:= M->UA_COMIS2	//COMISSAO 2
	SC5->C5_HORA	:= M->UA_HORA	//COMISSAO 2
	SC5->C5_USERINC	:= M->UA_USERINC	//COMISSAO 2
	SC5->C5_TRANSP	:= M->UA_TRANSP	//TRANSP
	SC5->C5_REDESP	:= M->UA_REDESP	//REDESP
	SC5->C5_TPFRETE	:= M->UA_TPFRETE //TIPO FRETE TRANSP
	SC5->C5_TPFREDE := M->UA_TPREDES	//TIPO FREDE REDESP
	SC5->C5_XTEMRED	:= M->UA_XTEMRED	//TEM REDESPACHO
	SC5->C5_TIPLIB 	:= "1"	//TRANSP
	SC5->C5_ESPECI1 := "VOL"
	SC5->C5_X_PBRUT := M->UA_X_PBRUT
	MsUnLock()
	
	
	//==========================================================================================================================================================
	//Cria Array para armazenar dados para geração de novos registros
	DbSelectArea("SX3")
	DbSetOrder(1)
	dbSeek("SC6")
	While !Eof().And.(SX3->X3_ARQUIVO=="SC6")
		If SX3->X3_CONTEXT<>"V"
			aadd(xArray,{Alltrim(SX3->X3_CAMPO),,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,})
		EndIf
		DbSkip()
	EndDo
	
	//==========================================================================================================================================================
	//Abre SC6 para processamento
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6") + xNum)
	while !Eof() .And. SC6->C6_NUM==xNum
		
		xGrupo 	:= Alltrim(Posicione("SB1",1,xFilial("SB1")+Alltrim(SC6->C6_PRODUTO),"B1_GRUPO"))
		yTES 	:= Posicione("SZ0",1,xFilial("SZ0")+xCodRe+xGrupo+xRegiao,"Z0_TESOPER")
		yCF 	:= Posicione("SF4",1,xFilial("SF4")+yTES,"F4_CF")
		xPedCli	:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_PEDCLI")
		xObserv	:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_OBS")
		xDtEntr	:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_DTENTRE")
		xTO		:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_OPER")
		xPRCTAB	:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_PRCTAB")

//========TRATATIVA DA COMISSAO DO CALL CENTER PARA O PEDIDO

		//M->UA_VEND		
		//M->UA_CLIENTE
		//Posicione("DA3",1,xFilial("DA3")+_aOldSC5[nI,nX],"DA3_DESC")
		Posicione("SA3",1,xFilial("SA3")+M->UA_VEND,"A3_TIPO")
		Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE,"A1_COMIS")		
		
		//If SA3->A3_TIPO == 'I' .AND. SA1->A1_COMIS == 0
		//If Posicione("SA3",1,xFilial("SA3")+M->UA_VEND,"A3_TIPO") == 'I' .AND. Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE,"A1_COMIS") == 0
		If Posicione("SA3",1,xFilial("SA3")+M->UA_VEND,"A3_TIPO") $ 'I/E' .AND. Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE,"A1_COMIS") == 0
		//			GdFieldPut("C6_COMIS1",M->C5_COMIS1,_x)
		//			M->C5_XNCOMIS := '2'
				//Elseif M->XCOMCLI <> 0
		//Elseif SA1->A1_COMIS <> 0
		xComis	:= Posicione("SA3",1,xFilial("SA3")+M->UA_VEND,"A3_COMIS")

		Elseif Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE,"A1_COMIS") <> 0
					//GdFieldPut("C6_COMIS1",M->C5_XCOMCLI,_x)
					//GdFieldPut("C6_COMIS1",SA1->A1_COMIS,_x)
					//M->C5_XNCOMIS := '3'
		xComis	:= Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE,"A1_COMIS")

		Else
					//M->C5_XNCOMIS := '1'
		xComis	:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_COMIS1")
		Endif


		//xComis	:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_COMIS1")
		xDescMax:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_DESCMAX")
		//ALTERADO BRUNO 29-09-14
		nPBrut	  := Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_X_PBRUT")																				
		nUBZPeCub := Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_ZPECUB")																				
		nUBZCubage:= Posicione("SUB",3,xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM,"UB_ZCUBAGE")		 
		//TERMINO BRUNO 29-09-14
		//==========================================================================================================================================================
		//Valida valores que serão gravados/alterados conforme xCodRe
		
		If xCodRE=="5150 "
			
			XPRCVEN		:=(SC6->C6_PRCVEN/2)
			XVALOR		:=(SC6->C6_VALOR/2)
			XVALDESC	:=(SC6->C6_VALDESC/2)
			XPRUNIT		:=(SC6->C6_PRUNIT/2)
			
			yPRCVEN		:=(SC6->C6_PRCVEN/2)
			yVALOR		:=(SC6->C6_VALOR/2)
			yVALDESC	:=(SC6->C6_VALDESC/2)
			yPRUNIT		:=(SC6->C6_PRUNIT/2)
			
		ElseIf xCodRE=="5130 "
			
			XPRCVEN		:=(SC6->C6_PRCVEN*0.30)
			XVALOR		:=(SC6->C6_VALOR*0.30)
			XVALDESC	:=(SC6->C6_VALDESC*0.30)
			XPRUNIT		:=(SC6->C6_PRUNIT*0.30)
			
			yPRCVEN		:=(SC6->C6_PRCVEN*0.70)
			yVALOR		:=(SC6->C6_VALOR*0.70)
			yVALDESC	:=(SC6->C6_VALDESC*0.70)
			yPRUNIT		:=(SC6->C6_PRUNIT*0.70)
			
		EndIf
		//==========================================================================================================================================================
		//Atribui os novos valores aos registro corrente
		
		RecLock("SC6",.F.)
		If xCodRe=="5150 " .Or. xCodRe=="5130 "
			SC6->C6_PRCVEN	:=XPRCVEN
			SC6->C6_VALOR	:=XVALOR
			SC6->C6_VALDESC	:=XVALDESC
			SC6->C6_PRUNIT	:=XPRUNIT
		EndIf
		SC6->C6_PEDCLI	:=xPedCli
		SC6->C6_OBSERV	:=xObserv
		SC6->C6_DTENTR	:=xDtEntr
		SC6->C6_X_TO	:=xTO
		SC6->C6_COMIS1	:=xComis
		SC6->C6_X_PRLST :=xPrcTab
		SC6->C6_X_DESCO :=xDescMax
		//ALTERADO BRUNO 29-09-14

		SC6->C6_X_PBRUT := nPbrut
		SC6->C6_ZPECUB	:= nUBZPeCub 
		SC6->C6_ZCUBAGE	:= nUBZCubage
		//TERMINO BRUNO 29-09-14
		MsUnLock("SC6")
		
		//==========================================================================================================================================================
		//Atribui valores do registro corrente a um array para posteriormente serem adicionados a tabela
		If xCodRe=="5150 " .Or. xCodRe=="5130 "
			
			xCol:=xCol+1
			For Y:=1 to Len(xArray)
				xCampo:=Alltrim(xArray[Y,1])
				
				If xCampo=="C6_PRCVEN"
					xArray[Y,xCol]	:=yPRCVEN
				ElseIf xCampo=="C6_VALOR"
					xArray[Y,xCol]	:=yVALOR
				ElseIf xCampo=="C6_VALDESC"
					xArray[Y,xCol]	:=yVALDESC
				ElseIf xCampo=="C6_PRUNIT"
					xArray[Y,xCol]	:=yPRUNIT
				ElseIf xCampo=="C6_TES"
					xArray[Y,xCol]	:=yTES
				ElseIf xCampo=="C6_CF"
					xArray[Y,xCol]	:=yCF
				Else
					xArray[Y,xCol]:=&("SC6->"+xCampo) //Validar largura do array
				EndIf
				
			Next
			
		EndIf
		xItem+=1
		DbSkip()
	EndDo()
	
	DbCloseArea("SC6")
	
	//==========================================================================================================================================================
	//Atribui os dados do array a tabela
	If xCodRe=="5150 " .Or. xCodRe=="5130 "
		
		DbSelectArea("SC6")
		For S:=1 to xCol-1  //xCol=itens
			
			xCol1:=xCol1+1
			
			RecLock("SC6",.T.)
			
			For U:=1 to Len(xArray)
				xCampo:=Alltrim(xArray[U,1])
				If xCampo=="C6_ITEM"
					xItem+=1
					&("SC6->"+xCampo):=Strzero((xItem),2)
				Else
					&("SC6->"+xCampo):=xArray[U,xCol1]
				EndIf
			Next
			MsUnLock("SC6")
		Next
		DbCloseArea("SC6")
		
	EndIf
	dbSelectArea(_cAlias_)
	dbSetOrder(_cIndex_)
	dbGoto(_nRec_)
	
EndIf

//EndIf
Return()
