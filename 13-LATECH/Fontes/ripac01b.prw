#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RIPAC01b ³ Autor ³                       ³ Data ³ 06.07.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importa os dados do SIGAADV para o IPAC                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Alfama                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RIPAC01b

cPerg :="IPAC1B"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametro                         ³
//³ mv_par01    Cod. Vendedor                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
If !Pergunte(cPerg,.T.)
	Return .F.
EndIf

_cVendedor:= mv_par01
_cFilSA1  := xFilial("SA1")
_cFilSB1  := xFilial("SB1")
_cFilSB5  := xFilial("SB5")
_cFilSC5  := xFilial("SC5")
_cFilSC6  := xFilial("SC6")
_cFilSF4  := xFilial("SF4")
_cFilSZ2  := xFilial("SZ2")
_cFilSZ6  := xFilial("SZ6")
_cFilDBH  := xFilial("DBH")
//_cCaminho := "\KIBON\RETORNO\"
_cCaminho := "\\DISTR_KB\AP5\KIBON\RETORNO\"

lTchau := .F.
MsAguarde( { |lTchau|GeraIpac() }, "Gerando Informacoes..." )

_CMsg := "Importacao finalizada com sucesso - Vendedor "+Right(_cVendedor,3)
MsgInfo(_CMsg)

Return(.T.)

*---------------------------------------------------------------------------*
Static Function GeraIpac
*---------------------------------------------------------------------------*

MsProcTxt("Descompactando pedido de venda")

_cLinhaBat := "@ECHO OFF" + Chr( 13 ) + Chr( 10 )
_cLinhaBat += "@ECHO Aguarde, Descompactando arquivos ..." + Chr( 13 ) + Chr( 10 )
_cLinhaBat += "G:" + Chr( 13 ) + Chr( 10 )
_cLinhaBat += "PKUNZIP -O "+"\\Distr_kb\AP5\Kibon\Retorno\"+Right(_cVendedor,3)+Right(_cVendedor,3)+" \\Distr_kb\AP5\Kibon\Retorno"+ Chr( 13 ) + Chr( 10 )
_cLinhaBat += "@ECHO Arquivos descompactados com sucesso - Feche esta janela p/continuar o processo ... " + Chr( 13 ) + Chr( 10 )
MemoWrit( "C:\DESCORET.BAT", _cLinhaBat )

WinExec( "COMMAND.COM /C \DESCORET.BAT" )
Inkey(5)

DbSelectArea("SA1")
DbSetOrder(1)
DbSelectArea("SB1")
DbSetOrder(1)
DbSelectArea("SB5")
DbSetOrder(1)
DbSelectArea("SF4")
DbSetOrder(1)

MsProcTxt("Verificando Arquivos")

_nDescon  := 0
_nPercent := 0

_cSeq  := Right(_cVendedor,3)
_cComp := _cSeq+"."+_cSeq
_cArq1 := _cCaminho+"PEDI"+_cComp
_cArq2 := _cCaminho+"ITEM"+_cComp
_cArq3 := _cCaminho+"MENS"+_cComp          
_cArq4 := _cCaminho+"MOTI"+_cComp
_cArq5 := _cCaminho+"CLI"+_cComp
_cArq6 := _cCaminho+Right(_cVendedor,3)+Right(_cVendedor,3)+".ZIP"
_cArq7 := _cCaminho+"ITDES"+_cComp

If !File(_cArq1)
	_CMsg := "Nao Foi Localizado o Arquivo "+_carq1
	MsgInfo(_CMsg,"Importação Abandonada !")
	Return(.f.)
ElseIf !File(_cArq2)
	_CMsg := "Nao Foi Localizado o Arquivo "+_carq2
	MsgInfo(_CMsg,"Importação Abandonada !")
	Return(.f.)
EndIf

MsProcTxt("Criando Estruturas")
_aStruSc5 := {}
Aadd(_aStruSc5,{"CODCLI","C",006,0})
Aadd(_aStruSc5,{"LOJCLI","C",002,0})
Aadd(_aStruSc5,{"PEDIDO","C",006,0})
Aadd(_aStruSc5,{"DATPED","C",008,0})
Aadd(_aStruSc5,{"PEDCLI","C",015,0})
Aadd(_aStruSc5,{"OBSERV","C",120,0})
Aadd(_aStruSc5,{"HINI"  ,"C",004,0})
Aadd(_aStruSc5,{"HFIM"  ,"C",004,0})
Aadd(_aStruSc5,{"TIPO"  ,"C",001,0})
Aadd(_aStruSc5,{"VLIND" ,"C",008,0})
Aadd(_aStruSc5,{"LISTAP","C",003,0})

//_cIndSc5 := CriaTrab(Nil,.f.)
//_cArqSc5 := CriaTrab(Nil,.f.)
//DbCreate(_cArqSc5,_aStruSc5)
//dbUseArea(.T.,__LocalDriver,_cArqSc5,"SC5TRB",.F.,.F.)
//IndRegua('SC5TRB',_cIndSc5,'PEDIDO+CODCLI+LOJCLI',,, 'Selecionando Cabecalho...')
  
_cArqSc5 := CriaTrab(_aStruSc5,.T.)
dbUseArea(.T.,,_cArqSc5,"SC5TRB",.F.,.F.)
dbSelectArea("SC5TRB")
IndRegua('SC5TRB',_cArqSc5,'PEDIDO+CODCLI+LOJCLI',,, 'Selecionando Cabecalho...')

_aStruSc6 := {}
Aadd(_aStruSc6,{"PEDIDO" ,"C",006,0})
Aadd(_aStruSc6,{"PRODUTO","C",006,0})
Aadd(_aStruSc6,{"QUANT"  ,"C",014,0})
Aadd(_aStruSc6,{"QTDBONI","C",014,0})
Aadd(_aStruSc6,{"PRECO"  ,"C",007,0})
Aadd(_aStruSc6,{"PERCDES","C",004,0})
Aadd(_aStruSc6,{"SUBST"  ,"C",007,0})

//_cIndSc6 := CriaTrab(Nil,.f.)
//_cArqSc6 := CriaTrab(Nil,.f.)
//DbCreate(_cArqSc6,_aStruSc6)
//dbUseArea(.T.,__LocalDriver,_cArqSc6,"SC6TRB",.F.,.F.)
//IndRegua('SC6TRB',_cIndSc6,'PEDIDO',,, 'Selecionando Cabecalho...')

_cArqSc6 := CriaTrab(_aStruSc6,.T.)
dbUseArea(.T.,,_cArqSc6,"SC6TRB",.F.,.F.)
dbSelectArea("SC6TRB")
IndRegua('SC6TRB',_cArqSc6,'PEDIDO',,, 'Selecionando Cabecalho...')

_aStruDBH := {}
Aadd(_aStruDBH,{"CODCLI"	,"C",006,0})
Aadd(_aStruDBH,{"LOJCLI"	,"C",002,0})
Aadd(_aStruDBH,{"CODDES"	,"C",006,0})
Aadd(_aStruDBH,{"PRODUTO"	,"C",006,0})
Aadd(_aStruDBH,{"DESCONTO"	,"C",007,0})
Aadd(_aStruDBH,{"PERCENT"	,"C",004,0})
Aadd(_aStruDBH,{"PARTKIBON"	,"C",007,0})
Aadd(_aStruDBH,{"PARTDISTR"	,"C",007,0})
Aadd(_aStruDBH,{"DATAEMIS"	,"C",008,0})
Aadd(_aStruDBH,{"PEDIDO"	,"C",006,0})

_cArqDBH := CriaTrab(_aStruDBH,.T.)
dbUseArea(.T.,,_cArqDBH,"DBHTRB",.F.,.F.)
dbSelectArea("DBHTRB")
IndRegua('DBHTRB',_cArqDBH,'PEDIDO+PRODUTO',,, 'Selecionando Cabecalho...')

MsProcTxt("Atualizando Arquivos Temporarios")
DbSelectArea("SC5TRB")
Append From &_cArq1 SDF

DbSelectArea("SC6TRB")
Append From &_cArq2 SDF

If File(_cArq7)
	DbSelectArea("DBHTRB")
	Append From &_cArq7 SDF
EndIf
MsProcTxt("Verificando Arquivos Temporarios")
DbSelectArea("SC5TRB")
DbGoTop()
While !EOF()
	
	_cMens := "Pedido do Vendedor nº "+SC5TRB->PEDIDO
	
	DbSelectArea("SC6TRB")
	If !DbSeek(SC5TRB->PEDIDO)
		MsgInfo(_cMens+" Imcompleto!")
		DbSelectArea("SC5TRB")
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SA1")
	If !DbSeek(_cFilSa1+SC5TRB->CODCLI+SC5TRB->LOJCLI)
		MsgInfo("Cliente Nao Cadastrado "+SC5TRB->CODCLI+"/"+SC5TRB->LOJCLI,_cMens)
		DbSelectArea("SC5TRB")
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SC5TRB")
	
	_cPedido := GetSx8Num("SC5")
	ConfirmSx8()
	_nTotDig := _nVlrTotal := _nTotInd := 0
	
	DbSelectArea("SC5")
	RecLock("SC5",.T.)
	SC5->C5_FILIAL  := _cFilSC5
	SC5->C5_NUM     := _cPedido
	SC5->C5_TIPO    := "N"
	SC5->C5_MONTCAR := CRIAVAR("C5_MONTCAR",.T.)
	SC5->C5_CLIENTE := SC5TRB->CODCLI
	SC5->C5_LOJAENT := SC5TRB->LOJCLI
	SC5->C5_LOJACLI := SC5TRB->LOJCLI
	SC5->C5_EMISSAO := dDataBase
	SC5->C5_TABELA  := Right(SC5TRB->LISTAP,1)
	SC5->C5_TABPRE  := CRIAVAR("C5_TABPRE",.T.)
	SC5->C5_CONDPAG := SA1->A1_COND
	SC5->C5_FORMAPG := SA1->A1_FORMAPG
	SC5->C5_VEND1   := MV_PAR01
	SC5->C5_BANCO   := SA1->A1_BCO1
	SC5->C5_TIPOCLI := SA1->A1_TIPO
	SC5->C5_TIPLIB  := "1"
	SC5->C5_TPMOV   := "1"
//	SC5->C5_TPFRETE := "C"
	SC5->C5_MOEDA   := 1
//	SC5->C5_INCISS  := "N"
	SC5->C5_SETOR   := Posicione("SA1",1,xFilial("SA1")+SC5TRB->CODCLI+SC5TRB->LOJCLI,"A1_SETOR")
	SC5->C5_ACRSFIN := Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_ACRSFIN")
    SC5->C5_COMIS1	:= Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_COMIS")
	MsUnlock()			
	
	nItem := 1
	DbSelectArea("SC6TRB")
	DbSeek(SC5TRB->PEDIDO)
	While SC6TRB->PEDIDO == SC5TRB->PEDIDO .and. !EOF()
		
		DbSelectArea("SB1")
		If !DbSeek(_cFilSb1+Right(SC6TRB->PRODUTO,5))
			MsgInfo("Produto nao localizado "+Right(SC6TRB->PRODUTO,5),_cMens)
			DbSelectArea("SC6TRB")
			DbSkip()
			Loop
		EndIf
		
		If Val(SC5TRB->LISTAP) > 1
			DbSelectArea("SB5")
			If !DbSeek(_cFilSb5+Right(SC6TRB->PRODUTO,5))
				MsgInfo("Complemento de Produto nao localizado "+Right(SC6TRB->PRODUTO,5),_cMens)
				DbSelectArea("SC6TRB")
				DbSkip()
				Loop
			EndIf
			
			_cTabela  := "SB5->B5_PRV"+Right(SC5TRB->LISTAP,1)
			_nPrLista := &_cTabela
			
		Else
			_nPrLista := SB1->B1_PRV1
		EndIf                                          

		If File(_cArq7)
			_cArqIndDBH := CriaTrab(Nil,.F.) 
			_nDescon := _nPercent := 0
			DbSelectArea("DBHTRB")
			IndRegua('DBHTRB',_cArqIndDBH,'PEDIDO+PRODUTO',,,'Gerando Indice...')		
			If DbSeek(SC5TRB->PEDIDO+SC6TRB->PRODUTO)
				While !Eof() .And. SC5TRB->PEDIDO+SC6TRB->PRODUTO == DBHTRB->PEDIDO+DBHTRB->PRODUTO				
   					_nDescon  += Noround((((_nPrLista-_nDescon)*(VAL(DBHTRB->PERCENT)/100))/100),2) //VAL(DBHTRB->DESCONT)
	             	_nPercent += VAL(DBHTRB->PERCENT)/100             	             	
	             	DBHTRB->(dbSkip())
	       		End
       		Endif
		Endif
	
		DbSelectArea("SC6")
		RecLock("SC6",.T.)
		 SC6->C6_FILIAL  := _cFilSC6
		 SC6->C6_NUM     := SC5->C5_NUM
		 SC6->C6_TPMOV   := "1"
		 SC6->C6_ITEM    := STRZERO(nItem,2)
		 SC6->C6_CLI     := SC5TRB->CODCLI
		 SC6->C6_LOJA    := SC5TRB->LOJCLI
		 SC6->C6_PRODUTO := Right(SC6TRB->PRODUTO,5)
		 SC6->C6_UM      := SB1->B1_UM
		 SC6->C6_PRUNIT  := _nPrLista
//		 SC6->C6_PRUNIT  := VAL(SC6TRB->PRECO)/100
		 SC6->C6_QTDVEN  := VAL(SC6TRB->QUANT)/100
//		 SC6->C6_PRCVEN  := VAL(SC6TRB->PRECO)/100
		 SC6->C6_PRCVEN  := (_nPrLista-_nDescon)
		 SC6->C6_VALOR   := ROUND(SC6->C6_QTDVEN*SC6->C6_PRCVEN,2)
		 SC6->C6_TES     := MV_PAR02
		 SC6->C6_CF      := POSICIONE("SF4",1,_cFilSf4+MV_PAR02,"F4_CF")
		 SC6->C6_SEGUM   := SB1->B1_SEGUM
		 SC6->C6_LOCAL   := SB1->B1_LOCPAD
		 SC6->C6_ENTREG  := SC5->C5_EMISSAO
		 SC6->C6_PEDCLI  := SC5TRB->PEDCLI
		 SC6->C6_DESCRI  := SB1->B1_DESC
		 SC6->C6_CLASFIS := SB1->B1_ORIGEM+POSICIONE("SF4",1,_cFilSf4+MV_PAR02,"F4_SITTRIB")
		 SC6->C6_CALCDES := "S"
		 SC6->C6_DESCONT := _nPercent //Percentual
		 SC6->C6_VALDESC := _nDescon  //Valor do desconto
		MsUnlock()
		_nTotDig	+= SC6->C6_QTDVEN
		_nVlrTotal	+= SC6->C6_VALOR
		nItem++
		
		If val(SC6TRB->QTDBONI) > 0
			DbSelectArea("SC6")
			RecLock("SC6",.T.)
			SC6->C6_FILIAL  := _cFilSC6
			SC6->C6_NUM     := SC5->C5_NUM
			SC6->C6_TPMOV   := "4"
			SC6->C6_ITEM    := STRZERO(nItem,2)
			SC6->C6_CLI     := SC5TRB->CODCLI
			SC6->C6_LOJA    := SC5TRB->LOJCLI
			SC6->C6_PRODUTO	:= Right(SC6TRB->PRODUTO,5)
			SC6->C6_UM      := SB1->B1_UM
			SC6->C6_PRUNIT  := _nPrLista
			SC6->C6_QTDVEN  := VAL(SC6TRB->QTDBONI)/100
			SC6->C6_PRCVEN  := VAL(SC6TRB->PRECO)/100
			SC6->C6_VALOR   := ROUND(SC6->C6_QTDVEN*SC6->C6_PRCVEN,2)
			SC6->C6_TES     := MV_PAR03
			SC6->C6_CF      := POSICIONE("SF4",1,_cFilSf4+MV_PAR03,"F4_CF")
			SC6->C6_SEGUM   := SB1->B1_SEGUM
			SC6->C6_LOCAL   := SB1->B1_LOCPAD
			SC6->C6_ENTREG  := SC5->C5_EMISSAO
			SC6->C6_PEDCLI  := SC5TRB->PEDCLI
			SC6->C6_DESCRI  := SB1->B1_DESC
			MsUnlock()
			_nTotDig += SC6->C6_QTDVEN
			nItem++
		EndIf
		
		DbSelectArea("SC6TRB")
		DbSkip()
		
	EndDo
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	If _nTotDig	 == 0
		DbDelete()
	Else
		SC5->C5_QTDDIG := _nTotDig
	EndIf
	MsUnlock()

	nItem := 1	
	If File(_cArq7)
		DbSelectArea("DBHTRB")
		DbSeek(SC5TRB->PEDIDO)
		While DBHTRB->PEDIDO == SC5TRB->PEDIDO .and. !EOF()
		
			DbSelectArea("SB1")
			If !DbSeek(_cFilSb1+Right(DBHTRB->PRODUTO,5))
				MsgInfo("Produto nao localizado no SB1"+DBHTRB->PRODUTO,_cMens)
				DbSelectArea("DBHTRB")
				DbSkip()
				Loop
			EndIf
		
			DbSelectArea("DBH")
			RecLock("DBH",.T.)
			DBH->DBH_FILIAL  := _cFilDBH
			DBH->DBH_STATUS  := "P"
			DBH->DBH_TIPO    := "P"
			DBH->DBH_TPDESC  := "D"
			DBH->DBH_PEDIDO  := SC5->C5_NUM
			DBH->DBH_ITEMPV  := STRZERO(nItem,2)
			DBH->DBH_CLIENT  := SC5TRB->CODCLI			
			DBH->DBH_LOJA    := SC5TRB->LOJCLI		
			DBH->DBH_CODDES  := DBHTRB->CODDES
			DBH->DBH_PRODUT  := Right(DBHTRB->PRODUTO,5)//DBHTRB->PRODUTO
			DBH->DBH_VALDES  := VAL(DBHTRB->DESCONTO)/100
			DBH->DBH_PERC    := VAL(DBHTRB->PERCENT)/100
			DBH->DBH_KIBON   := VAL(DBHTRB->PARTKIBON)/100
			DBH->DBH_DISTR   := VAL(DBHTRB->PARTDISTR)/100
			DBH->DBH_DATA    := SC5->C5_EMISSAO
			DBH->DBH_OK      := "NC"	
			DBH->DBH_OBS     := "EM PEDIDO"
			MsUnlock()
			nItem++
		
			DbSelectArea("DBHTRB")
			DbSkip()
		
		EndDo
	Endif
///////////////////////////////////////////////////////////////////////////////////////	
	//Verifica se exite indenizacao.
	
	_cQuery := "SELECT DB1.DB1_NUM, DB1.DB1_CLIENT, DB1.DB1_LOJA, DB2.DB2_NUM, "
	_cQuery += "DB2.DB2_STATUS"
	_cQuery += "FROM "+RetSqlName("DB1")+" DB1, "
	_cQuery += RetSqlName("DB2")+" DB2 "
	_cQuery += "WHERE DB1_FILIAL = '"+xFilial("DB1")+"'"
	_cQuery += "  AND DB2_FILIAL = '"+xFilial("DB2")+"'"
	_cQuery += "  AND DB1.D_E_L_E_T_ <> '*'"
	_cQuery += "  AND DB2.D_E_L_E_T_ <> '*'"
	_cQuery += "  AND DB1.DB1_CLIENT = '"+SC5TRB->CODCLI+"'"
	_cQuery += "  AND DB1.DB1_LOJA   = '"+SC5TRB->LOJCLI+"'"
	_cQuery += "  AND DB1.DB1_NUM = DB2.DB2_NUM "
	_cqUERY := Change(_cQuery)

	dbUseArea                     //Crio o Arqui temp
	
	dbSelectarea("Query")
	
	While !Eof() //Somo para ver o valor daq indenizacao
		
		If DB2.DB2_VALOR <= (_nVlrTotal*0.95) .And. _nTotInd <= (_nVlrTotal*0.95)//Criar parametro para guardar o pecentual
			_nTotInd :=	_nTotInd + DB2.DB2_VALOR
			Aadd(_aIndeniz,DB2.DB2_NUM)
		Endif	
	    
	End

    If _nTotInd > 0
		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		 SC5->C5_DESCONT := _nTotInd
		MsUnlock()		
		For I:=1 to Len(_aIndeniz)                                                    
			If dbSeek(Indenizacao)
				RecLock("DB2",.F.)
				 DB2->DB2_PEDIDO := 
				MsUnlock()
			Endif			    		
		Next	
	Endif	
	DbSelectArea("SC5TRB")
	DbSkip()
	
EndDo  //Fim da importacao do pedido de venda

If File(_cArq3)
	MsProcTxt("Mensagens")
	DbSelectArea("SZ2")
	DbSetOrder(1)	
EndIf

If File(_cArq4)	
	MsProcTxt("Motivos de Nao Atendimento")
	_aStruSZ6 := {}
	Aadd(_aStruSZ6,{"CLIENTE","C",006,0})
	Aadd(_aStruSZ6,{"LOJA"   ,"C",002,0})
	Aadd(_aStruSZ6,{"EMISSAO","C",008,0})
	Aadd(_aStruSZ6,{"HORA"   ,"C",004,0})
	Aadd(_aStruSZ6,{"CODMOT" ,"C",002,0})
	
	_cArqSZ6 := CriaTrab(_aStruSZ6,.T.)
	dbUseArea(.T.,,_cArqSZ6,"SZ6TRB",.F.,.F.)

	DbSelectArea("SZ6TRB")
	Append From &_cArq4 SDF
	DbSelectArea("SZ6TRB")
	
	DbSelectArea("SZ6")
	DbSetOrder(1)
	
	DbSelectArea("SZ6TRB")
	DbGoTop()
	While !EOF()
		
		_cData := right(SZ6TRB->EMISSAO,2)+"/"+subs(SZ6TRB->EMISSAO,5,2)+"/"+left(SZ6TRB->EMISSAO,4)
		msginfo(_cData,"_cData")
		DbSelectArea("SZ6")
		RecLock("SZ6",.T.)
		SZ6->Z6_FILIAL  := _cFilSZ6
		SZ6->Z6_CLIENTE := SZ6TRB->CLIENTE
		SZ6->Z6_LOJA    := SZ6TRB->LOJA
		SZ6->Z6_EMISSAO := ctod(_cData)
		SZ6->Z6_HORA    := Left(SZ6TRB->HORA,2)+":"+RIGHT(SZ6TRB->HORA,2)
		SZ6->Z6_CODMOT  := SZ6TRB->CODMOT
		MsUnlock()
		
		DbSelectArea("SZ6TRB")
		DbSkip()
		
	EndDo
	
	SZ6TRB-> ( DbCloseArea() )
	fRename(_cArq4,_cCaminho+"ok\"+dtos(dDataBase)+"vMOTI."+_cSeq)
	
EndIf

If File(_cArq5)
	
	MsProcTxt("Clientes Alterados")
	_aStruSA1 := {}
	Aadd(_aStruSA1,{"CLIENTE","C",006,0})
	Aadd(_aStruSA1,{"LOJA"   ,"C",002,0})
	Aadd(_aStruSA1,{"CONTATO","C",015,0})
	Aadd(_aStruSA1,{"FONE"   ,"C",015,0})
	Aadd(_aStruSA1,{"FANTAS" ,"C",040,0})
	Aadd(_aStruSA1,{"EMAIL"  ,"C",030,0})
	
//	_cArqSA1 := CriaTrab(Nil,.f.)
//	DbCreate(_cArqSA1,_aStruSA1)
//	dbUseArea(.T.,__LocalDriver,_cArqSA1,"SA1TRB",.F.,.F.)
	_cArqSA1 := CriaTrab(_aStruSA1,.T.)
	dbUseArea(.T.,,_cArqSA1,"SZ6TRB",.F.,.F.)
	
	DbSelectArea("SA1TRB")
	Append From &_cArq5 SDF
	
	DbSelectArea("SA1TRB")
	DbGoTop()
	While !EOF()
		
		DbSelectArea("SA1")
		If !DbSeek(_cFilSa1+SA1TRB->CLIENTE+SA1TRB->LOJA)
			MsgInfo("Cliente nao encontrado ",SA1TRB->CLIENTE+SA1TRB->LOJA)
			DbSelectArea("SA1TRB")
			DbSkip()
			Loop
		EndIf
		
		RecLock("SA1",.F.)
		SA1->A1_CONTATO := SA1TRB->CONTATO
		SA1->A1_TEL     := SA1TRB->FONE
		SA1->A1_NREDUZ  := SA1TRB->FANTAS
		SA1->A1_EMAIL   := SA1TRB->EMAIL
		MsUnlock()
		
		DbSelectArea("SA1TRB")
		DbSkip()
		
	EndDo
	
	SA1TRB-> ( DbCloseArea() )
	fRename(_cArq5,_cCaminho+"ok\"+dtos(dDataBase)+"vCLI."+_cSeq)
	
EndIf

SC5TRB-> ( DbCloseArea() )
SC6TRB-> ( DbCloseArea() )
DBHTRB-> ( DbCloseArea() )

Ferase(_cArqSc5+".DBF")
Ferase(_cArqSc6+".DBF")

FRename(_cArq1,_cCaminho+"ok\"+dtos(dDataBase)+"vPEDI."+_cSeq)
FRename(_cArq2,_cCaminho+"ok\"+dtos(dDataBase)+"vITEM."+_cSeq)
FErase(_cArq6)

Return(.T.)

Static Function ValidPerg
cAlias := Alias()
aRegs  :={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Cod. Vendedor      ?","mv_ch1","C",6 ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"02","TES Venda          ?","mv_ch2","C",3 ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","SF4"})
AADD(aRegs,{cPerg,"03","TES Bonificacao    ?","mv_ch3","C",3 ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SF4"})

DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j<=Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(cAlias)
Return
