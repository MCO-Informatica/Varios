#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma          บ Autor ณ                       บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATP014()
///////////////////////

Local nOpca 	:= 0
Local aSays 	:= {}
Local aButtons  := {}
Private cCadastro	:= "Fatura Consignacao"

AADD(aSays,OemToAnsi( "O objetivo deste programa  e gerar os Pedidos de Vendas" ) )
AADD(aSays,OemToAnsi( "ref. Acerto Consignacao com Coligadas." ) )
AADD(aSays,OemToAnsi( " " ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return NIL
EndIf

Processa( {|lEnd| GeraPV(@lEnd)}, "Aguarde...","Gerando Pedidos de Venda", .T. )

Return Nil

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraPV()      
////////////////////////

Local _aArea	:= GetArea()

Local _nVlrItem := 0
Local _nReg		:= 0
Local _nPrUnit	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0

Local _nPerDesc := 0
Local nDesc		:= 0
Local nPreco	:= 0
Local nTotRec	:= 0

Local nItePV	:= "0001" 
Local _cTes

Local _aCabPv		:= {}
Local _aItemTemp	:= {}
Local _aItemPv		:= {}
Local _aPedidos		:= {}
Local _cPedidos		:= ''
Local _nTotNF		:= 0

Local _cUser		:= RetCodUsr()

Private oDlgPC


cQry := " SELECT * FROM MARTE.SIGA.dbo.ACERTOB6B7 "
cQry += " WHERE TES = 0"
cQry += " ORDER BY FILORIG, FORNECEDOR, LOJA, ID "   

If Select('TMP') > 0
	DbSelectArea('TMP')
	DbCloseArea()
EndIf
MsAguarde({ ||dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQry),"TMP", .T., .T.),'Buscando informa็๕es de faturamento'})

Count To nTotRec      
nTotRec := (int(nTotRec/99))
ProcRegua(nTotRec)
_nPedido := 0

DbSelectArea("TMP")
TMP->(DbGoTop())
Do While !TMP->(Eof())
	
	_cFilAnt := cFilAnt
	cFilAnt  := TMP->FILORIG
	_cPedidos += 'Filial de origem: ' + cFilAnt + _cEnter
	Do While !TMP->(Eof()) .And. TMP->FILORIG == cFilAnt
		cCliente	:= TMP->FORNECEDOR
		cLoja		:= TMP->LOJA
		_nIdIni		:= TMP->ID
		IncProc("Montando Pedido de Vendas (" + alltrim(str(++_nPedido))+ '/' + alltrim(str(nTotRec)) + ")")
		Do While !TMP->(Eof()) .And. TMP->FILORIG == cFilAnt .And. TMP->FORNECEDOR == cCliente .And. TMP->LOJA == cLoja .and. _nReg < 99
			
			DbSelectArea("SA1")
			SA1->( DbSetOrder(1) )
			DbSeek( xFilial("SA1")+cCliente+cLoja )
			
			cEstado := SA1->A1_EST
			
			_nQtdPag := TMP->QTD
			
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) )
			DbSeek( xFilial("SB1")+Substr(TMP->PRODUTO,1,15) )
			
			nPreco := Round(TMP->UNITARIO,4)
			_nVlrItem   := Round((_nQtdPag * round(nPreco,2)),2)
			
			If SB1->B1_GRUPO $ GetMv("MV_GRPLIVR")
				_cTes := GetMv("MV_TESVCOL")
			Else
				_cTes := GetMv("MV_TESVCOO")
			EndIf
			
			_aCabPv	:= {}
			aAdd(_aCabPv,{"C5_FILIAL"	,	xFilial("SC5")				,Nil})
			aAdd(_aCabPv,{"C5_TIPO"		,   'N'							,Nil})
			aAdd(_aCabPv,{"C5_CLIENTE"	,	SA1->A1_COD					,Nil})
			aAdd(_aCabPv,{"C5_LOJACLI"	,	SA1->A1_LOJA				,Nil})
			aAdd(_aCabPv,{"C5_CLIENT"	,	SA1->A1_COD					,Nil})
			aAdd(_aCabPv,{"C5_LOJAENT"	,	SA1->A1_LOJA				,Nil})
			aAdd(_aCabPv,{"C5_TIPOCLI"	,	"R"							,Nil})
			aAdd(_aCabPv,{"C5_TRANSP"	,	"000001"					,Nil})
			aAdd(_aCabPv,{"C5_TPFRETE"	,	'F'							,Nil})
			aAdd(_aCabPv,{"C5_MOEDA"		,	1						,Nil})
			aAdd(_aCabPv,{"C5_CONDPAG"	,	SA1->A1_COND				,Nil})
			aAdd(_aCabPv,{"C5_STATUS"	,	'01'						,Nil})
			aAdd(_aCabPv,{"C5_EMISSAO"	,	dDataBase					,Nil})
			aAdd(_aCabPv,{"C5_DATA"		,	dDataBase					,Nil})
			If !empty(TMP->VENCI)
				aAdd(_aCabPv,{"C5_DATA1"		,	stod(TMP->VENCI)	,Nil})
			EndIf
			aAdd(_aCabPv,{"C5_HORA"		,	Time()						,Nil})
			aAdd(_aCabPv,{"C5_MOEDA"		,	1						,Nil})
			aAdd(_aCabPv,{"C5_TIPLIB"	,	'1'							,Nil})
			aAdd(_aCabPv,{"C5_TXMOEDA"	,	1							,Nil})
			aAdd(_aCabPv,{"C5_TPCARGA"	,	'2'							,Nil})
			aAdd(_aCabPv,{"C5_TES"    	,	_cTes						,Nil})
			aAdd(_aCabPv,{"C5_VEND1"		,	"000001"				,Nil})
			
			cCf	:= iif(SM0->M0_ESTENT <> cEstado,'6114','5114')
			
			_aItemTemp := {{"C6_ITEM"		,	nItePV							,Nil},;
			{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
			{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;
			{"C6_UM"		,	SB1->B1_UM						,Nil},;
			{"C6_QTDVEN"	,	_nQtdPag						,Nil},;
			{"C6_PRUNIT"	,	round(nPreco,2)					,Nil},;
			{"C6_PRCVEN"	,	round(nPreco,2)					,Nil},;
			{"C6_VALOR"		,	_nVlrItem						,Nil},;
			{"C6_TES"		,	_cTes							,Nil},;
			{"C6_CF"		,	cCf								,Nil},;
			{"C6_LOCAL"		,	SB1->B1_LOCPAD					,Nil},;
			{"C6_CLASFIS"	,	SB1->B1_ORIGEM + ""				,Nil},;
			{"C6_CLI"		,	SA1->A1_COD		 				,Nil},;
			{"C6_ENTREG"	,	dDataBase						,Nil},;
			{"C6_LOJA"		,	SA1->A1_LOJA					,Nil},;
			{"C6_OP"		,	'02'							,Nil},;
			{"C6_TPOP"		,	'F'								,Nil},;
			{"C6_SUGENTR"	,	dDataBase						,Nil}}
			
			_nReg++
			nItePV := Soma1(nItePV)
			aAdd(_aItemPv,aClone(_aItemTemp))
			
			_nIdFim		:= TMP->ID
			DbSelectArea('TMP')
			TMP->(DbSkip())
			
		EndDo
		
		lMsErroAuto := .f.
		IncProc("Gerando Pedido de Vendas (" + alltrim(str(_nPedido))+ '/' + alltrim(str(nTotRec)) + ")")
		MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
		If lMsErroAuto
			_lErros := .t.
			MostraErro()
		Else
			Aadd(_aPedidos,{SC5->C5_NUM})
			IncProc('Liberando PV gerado ' + SC5->C5_NUM + " (" + alltrim(str(_nPedido))+ '/' + alltrim(str(nTotRec)) + ")")
			LibPedid(SC5->C5_NUM)
			
			_cNota := ''
			IncProc('Gerando Nota Fiscal para o PV ' + SC5->C5_NUM + " (" + alltrim(str(_nPedido))+ '/' + alltrim(str(nTotRec)) + ")")
			_cNota := GravaNFS()
			_cPedidos += 'PV: ' + SC5->C5_NUM + ' Cli: ' + SA1->A1_COD + ' / ' + SA1->A1_LOJA + ' NF: ' + _cNota + ' ' + tran(SF2->F2_VALBRUT,'@E 999,999,999.99') + _cEnter

			SF2->(DbSeek(cFilAnt + _cNota + '8',.f.))
			_cQuery := "UPDATE " + RetSqlName('SE1') + " SET E1_VENCTO = '" + dtos(SC5->C5_DATA1) + "',E1_VENCREA = '" + dtos(SC5->C5_DATA1) + "',E1_VENCORI = '" + dtos(SC5->C5_DATA1) + "'"
			_cQuery += " WHERE E1_MSFIL = '" + cFilAnt + "'"
			_cQuery += " AND E1_NUM = '" + SF2->F2_DOC + "'"
			_cQuery += " AND E1_PREFIXO = '" + SF2->F2_PREFIXO + "'"
			_cQuery += " AND E1_CLIENTE = '" + SF2->F2_CLIENTE + "'"
			_cQuery += " AND E1_LOJA = '" + SF2->F2_LOJA + "'"
			TcSqlExec(_cQuery)                                                                                                          
			
            //TcSqlExec("UPDATE MARTE.SIGA.dbo.ACERTOB6B7 SET TES = 1 WHERE TES = 0 AND ID BETWEEN " + str(_nIdIni) + " AND " + str(_nIdFim))

			_nTotNF   += SF2->F2_VALBRUT
		EndIf
		
		_aCabPv		:= {}
		_aItemPv	:= {}
		_nReg		:= 0
		nItePV		:= "0001" 
		
		DbSelectArea('TMP')

	EndDo
	cFilAnt := _cFilAnt

	_cPedidos += _cEnter

EndDo

If Len(_aPedidos) > 0
	_cPedidos += _cEnter + ' Valor total: ' + tran(_nTotNF,'@E 999,999,999.99')
	Aviso("Pedidos de Venda Gerados",_cPedidos,{"Ok"},3)
Else
	MsgStop("Foram encontrados erros durante o processamnto!!!")
EndIf

DbSelectArea("TMP")
DbCloseArea()

RestArea(_aArea)

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPedid(cNumPed)
/////////////////////////////////

Local aArea		:= GetArea()
Local nX		:= 0
Local lLiberOk  := .T.
Local lCredito  := .T.
Local lEstoque  := .T.
Local lLiber    := .T.
Local lTransf   := .F.

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+cNumPed)
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->( DbSeek( xFilial("SC6")+cNumPed ) )
	Do While SC6->( !Eof() ) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cNumPed
		
		DbSelectArea("SC9")
		SC9->( DbSetOrder(1) )
		
		If SC9->( DbSeek( xFilial("SC9")+cNumPed+SC6->C6_ITEM+"01"+SC6->C6_PRODUTO ) )
			Reclock("SC9",.F.)
		Else
			Reclock("SC9",.T.)
		EndIf
		_nQuant := SC9->C9_QTDLIB
				
		SC9->C9_FILIAL 	:= xFilial("SC9")
		SC9->C9_PEDIDO	:= SC6->C6_NUM
		SC9->C9_ITEM	:= SC6->C6_ITEM
		SC9->C9_CLIENTE	:= SC6->C6_CLI
		SC9->C9_LOJA	:= SC6->C6_LOJA
		SC9->C9_PRODUTO	:= SC6->C6_PRODUTO
		SC9->C9_QTDLIB	:= SC6->C6_QTDVEN
		SC9->C9_DATALIB	:= dDatabase
		SC9->C9_SEQUEN	:= "01"
		SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
		SC9->C9_LOCAL	:= "01"
		SC9->C9_BLEST  	:= ""
		SC9->C9_BLCRED 	:= ""
		SC9->C9_TPCARGA	:= "2"
		
		Msunlock()
		
		DbSelectArea("SB2")
		//If DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NA ORIGEM
		If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
			RecLock("SB2",.f.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTatiane de Oliveira 11/02/2016                        ณ
//ณTrocou o campo b2_reserva por B2_XRESERV              ณ
//ณ o valor de pedido nใo faturado para a filial destino ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//			SB2->B2_XRESERV := SB2->B2_XRESERV - SC9->C9_QTDLIB // RESERVA
			SB2->B2_RESERVA := SB2->B2_XRESERV - _nQuant + SC9->C9_QTDLIB // RESERVA
			MsUnLock()
		EndIf
		
		If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
			RecLock("SB2",.F.)   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTatiane de Oliveira 05/02/16            ณ
//ณTrocou o campo b2_salpedi por B2_XTRANSIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
//			SB2->B2_SALPEDI := SB2->B2_SALPEDI - _nQuant + SC9->C9_QTDLIB // TRANSITO          

if SB2->B2_XTRANSI < 0 
	SB2->B2_XTRANSI:=0 
ELSE 
	SB2->B2_XTRANSI:=SB2->B2_XTRANSI 
endif

			SB2->B2_XTRANSI := SB2->B2_XTRANSI - _nQuant + SC9->C9_QTDLIB // TRANSITO
			MsUnLock()
		EndIf

		SC6->( DbSkip() )
		
	EndDo
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	MsUnlock()
	
EndIf

RestArea(aArea)

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaNFS()
//////////////////////////

Local aAreaAnt	 	:= GetArea()

Local aPvlNfs	 	:= {}
//Local _cSeek      := ''
Local _nPrcVen    := 0
Local _nRegDAK   	:= 0
Local lMostraCtb 	:= .F.
Local lAglutCtb  	:= .F.
Local lCtbOnLine 	:= .F.
Local lCtbCusto  	:= .F.
Local lReajuste  	:= .F.
Local lAtuSA7    	:= .F.
Local lECF       	:= .F.
Local nCalAcrs   	:= 1
Local nArredPrcLis 	:= 1
Local cRot       	:= ProcName()
Local cPedido := SC5->C5_NUM

// PREPARANDO A NOTA FISCAL
MV_PAR01 := 2           // Mostra Lan.Contab ?  Sim/Nao
MV_PAR02 := 2           // Aglut. Lanamentos ?  Sim/Nao
MV_PAR03 := 2           // Lan.Contab.On-Line?  Sim/Nao
MV_PAR04 := 2           // Contb.Custo On-Line?  Sim/Nao
MV_PAR05 := 1           // Reaj. na mesma N.F.?  Sim/Nao
MV_PAR06 := 0           // Taxa deflacao ICMS ?  Numerico
MV_PAR07 := 3           // Metodo calc.acr.fin?  Taxa defl/Dif.lista/% Acrs.ped
MV_PAR08 := 3           // Arred.prc unit vist?  Sempre/Nunca/Consumid.final
MV_PAR09 := Space( 04 ) // Agreg. liberac. de ?  Caracter
MV_PAR10 := Space( 04 ) // Agreg. liberac. ate?  Caracter
MV_PAR11 := 2           // Aglut.Ped. Iguais  ?  Sim/Nao
MV_PAR12 := 0           // Valor Minimo p/fatu?
MV_PAR13 := Space( 06 ) // Transportadora de  ?
MV_PAR14 := 'ZZZZZZ'    // Transportadora ate ?
MV_PAR15 := 2           // Atualiza Cli.X Prod?  Sim/Nao
MV_PAR16 := 1           // Emitir             ?  Nota/Cupom Fiscal

lMostraCtb  := MV_PAR01 == 1
lAglutCtb   := MV_PAR02 == 1
lCtbOnLine  := MV_PAR03 == 1
lCtbCusto   := MV_PAR04 == 1
lReajuste   := MV_PAR05 == 1

LAtuSA7lECF := .F.
lFaturado   := .F.

// Verifica se o pedido ja foi faturado
IF lFaturado
	Aviso( cRot, 'Pedido ja faturado anteriormente !!!', {'&Abandonar'} )
	Return( .F. )
Endif

// Gera nota.
SC5->( dbSetOrder( 1 ) ) //C5_FILIAL + C5_NUM
If SC5->( MsSeek( xFilial( 'SC5' ) + cPedido, .F. ) )
	
	SC6->( DbSetOrder(1) ) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	
	SC9->( DbSetOrder(1) ) //C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
	
	If SC9->( DbSeek( xFilial("SC9")+cPedido ) )
		
		Do While !SC9->(EOF()) .AND. SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL == xFilial('SC9')
			
			If SC6->( DbSeek( xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO ) )
				
				SE4->( dbSetOrder( 1 ) )
				SE4->( MsSeek( xFilial( 'SE4' ) + SC5->C5_CONDPAG, .F. ) )
				
				// Posiciona no produto
				SB1->( dbSetOrder( 1 ) )
				SB1->( MsSeek( xFilial( 'SB1' ) + SC6->C6_PRODUTO, .F. ) )
				
				// Posiciona no saldo em estoque
				SB2->( dbSetOrder( 1 ) )
				SB2->( MsSeek( xFilial( 'SB2' ) + SC6->C6_PRODUTO + SC6->C6_LOCAL, .F. ) )
				
				// Posiciona no TES
				cTes := SC6->C6_TES
				SF4->( dbSetOrder( 1 ) )
				SF4->( MsSeek( xFilial( 'SF4' ) + cTes, .F. ) )
				
				// Converte o valor unitario em Reais quando pedido em outra moeda
				_nPrcVen := SC9->C9_PRCVEN
				If ( SC5->C5_MOEDA <> 1 )
					dbSelectArea( 'SM2' )
					dbSetOrder( 1 )
					If dbSeek( DTOS( dDataBase ) )
						_nPrcVen := SC9->C9_PRCVEN * SM2->M2_MOEDA2
					Else
						_nPrcVen := xMoeda( _nPrcVen, SC5->C5_MOEDA, 1, dDataBase )
					EndIf
					
				EndIf
				
				// Monta array para gerar a nota fiscal
				Aadd( aPvlNfs, { SC9->C9_PEDIDO, ;
				SC9->C9_ITEM, ;
				SC9->C9_SEQUEN, ;
				SC9->C9_QTDLIB, ;
				_nPrcVen, ;
				SC9->C9_PRODUTO, ;
				.F., ;
				SC9->( RecNo() ), ;
				SC5->( RecNo() ), ;
				SC6->( RecNo() ), ;
				SE4->( RecNo() ), ;
				SB1->( RecNo() ), ;
				SB2->( RecNo() ), ;
				SF4->( RecNo() ), ;
				SC6->C6_LOCAL, ;
				_nRegDAK, ;
				SC9->C9_QTDLIB2} )
				
			Else
				
				MsgBox('Pedido de vendas nใo liberado','ATENวรO!!!','ALERT')
				aPvlNfs := {}
				Exit
				
			EndIf
			
			SC9->( DbSkip() )
			
		EndDo
		
	Else
		
		MsgBox('Pedido de vendas nใo liberado','ATENวรO!!!','ALERT')
		
	EndIf
	
Else
	
	MsgBox('Pedido de vendas nใo encontrado','ATENวรO!!!','ALERT')
	
EndIf

If !Empty( aPvlNfs )
	
	LimpaMoeda()
	
	//////////////////////////////////////////////////////////////////////
	/////	ponto de entrada para verifica็ใo da numera็ใo da nota fiscal
	//////////////////////////////////////////////////////////////////////
	// ATUALIZA A TABELA DE NOTAS FISCAIS PARA CNPJs QUE TEM MAIS DE UMA FILIAL
	
	DbSelectArea('SM0')
	_cCnpj := SM0->M0_CGC
	Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
	_cFiliais := ''
	_cQueryF  := ''
	DbGotop()
	Do While _cCnpj == SM0->M0_CGC .AND. !eof()
		_cQueryF += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(NFE_ID)),9))+1)),9) NOTA"
		_cQueryF += _cEnter + "FROM SPED050 (NOLOCK)"
		_cQueryF += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED" +" ('" + SM0->M0_CODFIL + "')"
		_cQueryF += _cEnter + "AND LEFT(NFE_ID,1) = '" + GetMv('FS_LASSER') +"'"
		_cQueryF += _cEnter + "AND D_E_L_E_T_ = ''"
		_cQueryF += _cEnter + "AND LEN(RTRIM(NFE_ID))>9"
		If SM0->M0_CODFIL $ ('C0/CB')
			_cQueryF += _cEnter + "AND NFE_ID not BETWEEN  '8  000010000' AND '89'"
		EndIf
		_cQueryF += _cEnter + "UNION"
		_cFiliais += SM0->M0_CODFIL + ','
		DbSkip()
	EndDo
	Set Filter To
	DbSeek(cEmpAnt+cFilAnt)
	
	_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')
	
	_cQuery2 := _cEnter + "SELECT ISNULL(MAX(NOTA),'') NOTA"
	_cQuery2 += _cEnter + "FROM"
	_cQuery2 += _cEnter + "("
	_cQuery2 += _cQueryF
	_cQuery2 += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(F2_DOC)),9))+1)),9) NOTA"
	_cQuery2 += _cEnter + "FROM SF2010"
	_cQuery2 += _cEnter + "WHERE F2_FILIAL IN " + _cfiliais
	_cQuery2 += _cEnter + "AND F2_SERIE = '" + GetMv('FS_LASSER') + "'"
	If SM0->M0_CODFIL $ ('C0/CB')
		_cQuery2 += _cEnter + "AND F2_SERIE+F2_DOC not BETWEEN  '8  000010000' AND '89'"
	EndIf
	_cQuery2 += _cEnter + "AND D_E_L_E_T_ = ''"
	_cQuery2 += _cEnter + ") A"
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery2),"_NF", .T., .T.)
	_cNota := _NF->NOTA
	DbCloseArea()
	_cNota := iif(empty(_cNota),'000000001',_cNota) 
	
	_cQuery := "UPDATE " + RetSqlName('SX5')
	_cQuery += _cEnter   + "SET X5_DESCRI = '" + _cNota + "', X5_DESCSPA ='" + _cNota + "', X5_DESCENG ='" + _cNota + "'"
	_cQuery += _cEnter   + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter   + "AND X5_CHAVE = '" + GetMv('FS_LASSER') + "'"
	_cQuery += _cEnter   + "AND D_E_L_E_T_ = ''"
	_cQuery += _cEnter   + "AND X5_FILIAL IN " + _cFiliais
	
	TcSqlExec(_cQuery)
	
	_aAlias := GetArea()
	
	_cSerie := padr(GetMv("FS_LASSER"),3,' ')
	_cNumNFX5F := alltrim(Posicione('SX5',1,cFilAnt + '01' + _cSerie,'X5_DESCRI'))
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			Do While !RecLock('SX5',.f.)
			EndDo
		EndIf
	Next
	
	_cFiltro   := "F1_FILIAL == '" + cFilAnt + "' .and. F1_SERIE == '" + _cSerie + "' .and. F1_FORMUL == 'S'"
	DbSelectArea('SF1')
	IndRegua("SF1",CriaTrab(,.f.),SF1->(IndexKey(1)),,,"Selecionando Registros...")
	Do While SF1->(DbSeek(xFilial('SF1') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	RetIndex()
	
	SF2->(DbSetOrder(1))
	Do While SF2->(DbSeek(xFilial('SF2') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			MsUnLock()
		EndIf
	Next
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			RecLock('SX5',.f.)
			SX5->X5_DESCRI  := _cNumNFX5F
			SX5->X5_DESCSPA := _cNumNFX5F
			SX5->X5_DESCENG := _cNumNFX5F
			MsUnLock()
		EndIf
	Next
	
	RestArea(_aAlias)
	//////////////////////////////////////////////////////////////////////
	_cNota := MaPvlNfs(aPvlNfs,;
	_cSerie,;
	lMostraCtb,;
	lAglutCtb,;
	lCtbOnLine,;
	lCtbCusto,;
	lReajuste,;
	nCalAcrs,;
	nArredPrcLis,;
	lAtuSA7,;
	lECF,;
	'',;
	,;
	NIL )
	
	_cNota := PadR(_cNota,9,' ')
	
EndIf

// Retorna as areas originais
RestArea( aAreaAnt )

Return( _cNota )


//quintino de lima km 5,5