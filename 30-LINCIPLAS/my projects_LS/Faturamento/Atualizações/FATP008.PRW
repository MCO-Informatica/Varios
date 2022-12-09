#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP008   º Autor ³ Antonio Carlos     º Data ³  02/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo processamento dos itens em Acerto  º±±
±±º          ³ de Consignacao para Pedidos Venda/Compra.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATP008()
///////////////////////

Local cAcerto	:= SZA->ZA_NUMFEC
Local _lPedVC	:= .F.

Conout("*** La Selva - User Function FATP008 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If SZA->ZA_STATUS == "P"
	Aviso("Acerto de Consignação","Fechamento já processado!",{"Ok"})
	Return(.F.)
EndIf

DbSelectArea("SC5")
SC5->( DbsetOrder(5) )
If SC5->( DbSeek(xFilial("SC5")+SZA->ZA_NUMFEC) )
	_lPedVC := .T.
EndIf

DbSelectArea("SC7")
SC7->( DbOrderNickName("NUMFEC") )
If SC7->( DbSeek(xFilial("SC7")+SZA->ZA_NUMFEC) )
	_lPedVC := .T.
EndIf

If _lPedVC
	Aviso("Acerto de Consignação","Existem pedidos de Venda e/ou Compra ref. esse Acerto, "+Chr(13)+;
	"efetue a exclusao para prosseguir com a operacao!",{"Ok"})
	Return(.F.)
EndIf

_nMaxReg := GetMv("MV_NUMITEN") // Quantidade maxima de produtos por nota fiscal //iif(SZA->ZA_FORNECE == '005509',999,99)

If MsgBox('Confirma processamento do Acerto nro ' + SZA->ZA_NUMFEC + '?','ATENÇÃO!!!','YESNO')
	LjMsgRun("Aguarde... Gerando Pedidos de Vendas/Compras...",, {|| GeraPC(cAcerto) })
EndIf

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraPC(cNumAc)
//////////////////////////////

Local _aArea		:= GetArea()

Local _nVlrUnit		:= 0
Local _nVlrItem 	:= 0
Local _nReg			:= 0
Local _nRegPC		:= 0
Local _nCont		:= 0
Local _nPrUnit		:= 0
Local _nQtdAux		:= 0
Local _nQtdPag		:= 0

Local _lFaz			:= .T.

Local nItePV		:= "0001" 
Local nItePC		:= "0001"
Local nItOri		:= "0001"
Local _cTes			:= GetMv("MV_TESDSC")
Local _cNumPV 		:= Space(6)
Local _cNumPC 		:= Space(6)
Local _cNumSZA		:= cNumAc

Local aCabPC		:= {}
Local aLinha		:= {}
Local aItemPC		:= {}
Local _aCabPv		:= {}
Local _aItemTemp	:= {}
Local _aItemPv		:= {}
Local _aPedidos		:= {}

Local _cUser		:= RetCodUsr()
Local cDescProd		:= ""

Private oDlgPC
Private _cNumSZA	:= cNumAc
Private lMsErroAuto := .F.

Conout("*** La Selva - Static Function GeraPC - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

cQry := " SELECT * "
cQry += _cEnter + " FROM " + RetSqlName("SZB") + " SZB (NOLOCK) "

cQry += _cEnter + " INNER JOIN " + RetSqlName("SZA") + " SZA (NOLOCK) "
cQry += _cEnter + " 						ON ZB_FILIAL 		= ZA_FILIAL"
cQry += _cEnter + " 						AND ZB_NUMFEC 		= ZA_NUMFEC" 
cQry += _cEnter + " 						AND SZA.D_E_L_E_T_ 	= '' "
cQry += _cEnter + " 						AND ZA_STATUS 		= 'A'"

cQry += _cEnter + " WHERE ZB_FILIAL 	= '" + xFilial("SZA") + "'"
cQry += _cEnter + " AND ZB_NUMFEC 		= '" + _cNumSZA + "'"
cQry += _cEnter + " AND ZB_QTDPAG 		> 0 "
cQry += _cEnter + " AND SZB.D_E_L_E_T_ 	= '' "
cQry += _cEnter + " ORDER BY ZB_ITEM"

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TMP", .F., .T.)

If eof()
	Aviso("Acerto de Consignação","Não há registros para processamento!",{"Ok"})
	DbCloseArea()
	Return()
EndIf

Do While TMP->( !Eof() )
	
	cFornece	:= TMP->ZA_FORNECE
	cLoja		:= TMP->ZA_LOJAFOR
	cProduto	:= TMP->ZB_PRODUTO
	
	Do While TMP->( !Eof() ) .And. TMP->ZB_FILIAL == xFilial("SZB") .And. TMP->ZA_FORNECE == cFornece .And. TMP->ZA_LOJAFOR == cLoja .And. TMP->ZB_PRODUTO == cProduto
		
		If Empty(_cNumPV)
			
			_cNumPV := GetSxeNum("SC5","C5_NUM")
			Do While .T.
				DbSelectArea("SC5")
				DbSetOrder(1)
				If DbSeek(xFilial("SC5")+_cNumPV)
					RollBackSX8()
					_cNumPV := GetSxeNum("SC5","C5_NUM")
				Else
					ConfirmSX8()
					Exit
				EndIf
			EndDo
			
			DbSelectArea("SA2")
			SA2->( DbSetOrder(1) )
			DbSeek( xFilial("SA2")+cFornece+cLoja)
			
			cEstado := SA2->A2_EST
			
			_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")			,Nil},;
						{"C5_NUM"		,   _cNumPV					,Nil},;
						{"C5_TIPO"		,   'B'						,Nil},;
						{"C5_CLIENTE"	,	SA2->A2_COD				,Nil},;
						{"C5_LOJACLI"	,	SA2->A2_LOJA			,Nil},;
						{"C5_CLIENT"	,	SA2->A2_COD				,Nil},;
						{"C5_LOJAENT"	,	SA2->A2_LOJA			,Nil},;
						{"C5_TIPOCLI"	,	"R"						,Nil},;
						{"C5_TRANSP"	,	"000001"				,Nil},;
						{"C5_TPFRETE"	,	'F'						,Nil},;
						{"C5_MOEDA"		,	1						,Nil},;
						{"C5_CONDPAG"	,	SA2->A2_COND			,Nil},;
						{"C5_STATUS"	,	'01'					,Nil},;
						{"C5_EMISSAO"	,	dDataBase				,Nil},;
						{"C5_DATA"		,	dDataBase				,Nil},;
						{"C5_HORA"		,	Time()					,Nil},;
						{"C5_NUMFEC"	,	_cNumSZA				,Nil},;
						{"C5_MOEDA"		,	1						,Nil},;
						{"C5_TIPLIB"	,	'1'						,Nil},;
						{"C5_TXMOEDA"	,	1						,Nil},;
						{"C5_TPCARGA"	,	'2'						,Nil},;
						{"C5_VEND1"		,	"000001"				,Nil}}
						//{"C5_DESC1"		,	100-SZA->ZA_PORCDES		,Nil},;
			
			If Empty(_cNumPC)
				_cNumPC := GetSxeNum("SC7","C7_NUM")
				Do While .T.
					DbSelectArea("SC7")
					DbSetOrder(1)
					If DbSeek(xFilial("SC7")+_cNumPC)
						RollBackSX8()
						_cNumPC := GetSxeNum("SC7","C7_NUM")
					Else
						ConfirmSX8()
						Exit
					EndIf
				EndDo
				
			EndIf
			
			Aadd(_aPedidos,{_cNumPV,_cNumPC})
			
		EndIf
		
		_nQtdPag	:= TMP->ZB_QTDPAG
		
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) )
		DbSeek( xFilial("SB1")+cProduto )
		
		cCf	:= Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
		IF cEstado="EX"
		cCf := "7"+Substr(cCf,2,3)		
		ELSE
			If SM0->M0_ESTENT <> cEstado
				cCf := "6"+Substr(cCf,2,3)
			//	If !empty(SF4->F4_CF_FORA)
			//		cCf := SF4->F4_CF_FORA
			//	EndIf
			ELSE
				cCf := "5"+Substr(cCf,2,3)
			ENDIF	
		EndIf
		
		//cQrySB6	:= " SELECT B6_DOC, B6_SERIE, B6_IDENT, 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,4) ELSE ROUND(B6_PRUNIT,4) END, B6_SALDO "
		cQrySB6	:= " SELECT B6_DOC "
		cQrySB6 += _cEnter + " , B6_SERIE "
		cQrySB6 += _cEnter + " , B6_IDENT "
		cQrySB6 += _cEnter + " , B6_SALDO "
		cQrySB6 += _cEnter + " , D1_VUNIT 								PRECO "
		cQrySB6 += _cEnter + " , D1_VALDESC 							VALDESC "
		cQrySB6 += _cEnter + " , D1_DESC 								PORCDESC "
		cQrySB6 += _cEnter + " , ROUND(D1_VALDESC/D1_QUANT,4) 			VALDESC_UNIT "
		cQrySB6 += _cEnter + " , D1_VUNIT-ROUND(D1_VALDESC/D1_QUANT,4)	PRECO_FINAL "
		
		cQrySB6 += _cEnter + " FROM " + RetSqlName("SB6") + " SB6 (NOLOCK) " 
		
		cQrySB6 += _cEnter + " INNER JOIN " + RetSqlName("SD1") + " SD1 (NOLOCK) "
		cQrySB6 += _cEnter + " ON D1_FILIAL 		= B6_FILIAL "
		cQrySB6 += _cEnter + " AND D1_DOC 			= B6_DOC "
		cQrySB6 += _cEnter + " AND D1_SERIE	 		= B6_SERIE "
		cQrySB6 += _cEnter + " AND D1_FORNECE 		= B6_CLIFOR "
		cQrySB6 += _cEnter + " AND D1_LOJA 			= B6_LOJA "
		cQrySB6 += _cEnter + " AND SD1.D_E_L_E_T_	= '' "
		cQrySB6 += _cEnter + " AND D1_COD 			= B6_PRODUTO "

		cQrySB6 += _cEnter + " WHERE B6_FILIAL 		= '" + xFilial("SB6") 	+ "'"
		cQrySB6 += _cEnter + " AND B6_PRODUTO 		= '" + cProduto 		+ "'"
		cQrySB6 += _cEnter + " AND B6_CLIFOR 		= '" + cFornece 		+ "'"
		cQrySB6 += _cEnter + " AND B6_LOJA 			= '" + cLoja 			+ "'"
		cQrySB6 += _cEnter + " AND B6_PODER3 		= 'R' "
		cQrySB6 += _cEnter + " AND B6_ATEND 		<> 'S' "
		cQrySB6 += _cEnter + " AND B6_TPCF 			= 'F' "
		cQrySB6 += _cEnter + " AND B6_SALDO 		> 0 "
		cQrySB6 += _cEnter + " AND SB6.D_E_L_E_T_ 	= '' "
		cQrySB6 += _cEnter + " ORDER BY B6_EMISSAO "
		
		If Select("TMPSB6") > 0
			DbSelectArea("TMPSB6")
			DbCloseArea()
		EndIf

		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQrySB6), "TMPSB6", .F., .T.)
		
 		_nQtdAux := _nQtdPag
		Do While !TMPSB6->(Eof()) .and. _lFaz
			
			If _nQtdAux <= TMPSB6->B6_SALDO
				_nQtdBx		:= _nQtdAux
				_lFaz		:= .F.
				_lInclui	:= .T.
			Else
				_nQtdBx 	:= TMPSB6->B6_SALDO
				_nQtdAux 	-= _nQtdBx
			EndIf
			
			_cDocB6			:= TMPSB6->B6_DOC
			_cSerB6			:= TMPSB6->B6_SERIE
			_cIdeB6			:= TMPSB6->B6_IDENT
			/*
			//_nVlrUnit		:= Round(TMPSB6->B6_PRUNIT,2)
			_nVlrUnit		:= IIF(TMP->ZB_VALPROD==0,Round(TMPSB6->PRECO,2),TMP->ZB_VALPROD) 											// VALOR UNITARIO SEM DESCONTO
			_nPorcDesc		:= TMP->ZB_PORCDES 			//100-SZA->ZA_PORCDES 					// Round((100*_nVlrUDesc)/_nVlrUnit	,2) // PORCENTAGEM DE DESCONTO
			_nVlrUDesc		:= TMP->ZB_DESPROD // /_nQtdBx 	//ROUND((_nVlrUnit*_nPorcDesc)/100  ,2)	// Round(TMPSB6->VALDESC			,2) // VALOR UNITARIO DE DESCONTO
			_nVlrDesc		:= Round((TMP->ZB_DESPROD*_nQtdBx)	,2) //TMP->ZB_DESPROD			//Round(_nVlrUDesc*_nQtdBx			,2) 										// VALOR TOTAL DE DESCONTO 
			_nVlrUnitD		:= Round(_nVlrUnit - _nVlrUDesc		,2) 																	// VALOR UNITARIO COM DESCONTO
			_nVlrItem   	:= Round((_nQtdBx *  _nVlrUnit)		,2) 																	// VALOR TOTAL SEM O DESCONTO
			_nVlrItemD  	:= Round((_nQtdBx *  _nVlrUnitD)	,2) 																	// VALOR TOTAL COM O DESCONTO
			*/
			cDescProd		:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
			//_nVlrUnit		:= Round(TMPSB6->B6_PRUNIT,2)
			_nVlrUnit		:= IIF(TMP->ZB_VALPROD==0,Round(TMPSB6->PRECO,2),TMP->ZB_VALPROD) 				// VALOR UNITARIO SEM DESCONTO
			_nPorcDesc		:= IIF(TMP->ZB_PORCDES==0,TMPSB6->PORCDESC,TMP->ZB_PORCDES) //100-SZA->ZA_PORCDES // PORCENTAGEM DE DESCONTO
			_nVlrUDesc		:= TMPSB6->VALDESC_UNIT /* / _nQtdBx*/											// VALOR UNITARIO DE DESCONTO
			_nVlrDesc		:= TMPSB6->VALDESC_UNIT * _nQtdBx 												// VALOR TOTAL DE DESCONTO 
			_nVlrUnitD		:= Round(_nVlrUnit - _nVlrUDesc		,4) 										// VALOR UNITARIO COM DESCONTO
			_nVlrItem   	:= Round((_nQtdBx *  _nVlrUnit)		,2) 										// VALOR TOTAL SEM O DESCONTO
			_nVlrItemD  	:= Round((_nQtdBx *  _nVlrUnitD)	,2) 										// VALOR TOTAL COM O DESCONTO
			
			If Empty(_cNumPV)
				
				_cNumPV := GetSxeNum("SC5","C5_NUM")
				While .T.
					DbSelectArea("SC5")
					DbSetOrder(1)
					If DbSeek(xFilial("SC5")+_cNumPV)
						RollBackSX8()
						_cNumPV := GetSxeNum("SC5","C5_NUM")
					Else
						ConfirmSX8()
						Exit
					EndIf
				EndDo
				
				If empty(_cNumPc)
					_cNumPC := GetSxeNum("SC7","C7_NUM")
					While .T.
						DbSelectArea("SC7")
						DbSetOrder(1)
						If DbSeek(xFilial("SC7")+_cNumPC)
							RollBackSX8()
							_cNumPC := GetSxeNum("SC7","C7_NUM")
						Else
							ConfirmSX8()
							Exit
						EndIf
					EndDo
				EndIf
				
				DbSelectArea("SA2")
				SA2->( DbSetOrder(1) )
				DbSeek( xFilial("SA2")+cFornece+cLoja )
				
				_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")		,Nil},;
							{"C5_NUM"		,   _cNumPV				,Nil},;
							{"C5_TIPO"		,   'B'					,Nil},;
							{"C5_CLIENTE"	,	SA2->A2_COD			,Nil},;
							{"C5_LOJACLI"	,	SA2->A2_LOJA		,Nil},;
							{"C5_CLIENT"	,	SA2->A2_COD			,Nil},;
							{"C5_LOJAENT"	,	SA2->A2_LOJA		,Nil},;
							{"C5_TIPOCLI"	,	"R"					,Nil},;
							{"C5_TRANSP"	,	"000001"			,Nil},;
							{"C5_TPFRETE"	,	'F'					,Nil},;
							{"C5_MOEDA"		,	1					,Nil},;
							{"C5_CONDPAG"	,	SA2->A2_COND		,Nil},;
							{"C5_STATUS"	,	'01'				,Nil},;
							{"C5_EMISSAO"	,	dDataBase			,Nil},;
							{"C5_DATA"		,	dDataBase			,Nil},;
							{"C5_HORA"		,	Time()				,Nil},;
							{"C5_NUMFEC"	,	_cNumSZA			,Nil},;
							{"C5_MOEDA"		,	1					,Nil},;
							{"C5_TIPLIB"	,	'1'					,Nil},;
							{"C5_TXMOEDA"	,	1					,Nil},;
							{"C5_TPCARGA"	,	'2'					,Nil},;
							{"C5_LIBEROK"	,	'1'					,Nil},;
							{"C5_VEND1"		,	"000001"			,Nil}}
							//{"C5_DESC1"	,	_nPorcDesc			,Nil},;
				
				Aadd(_aPedidos,{_cNumPV,Space(6)})
				
			EndIf
			
			_aItemTemp := {{"C6_NUM"		,	_cNumPV							,Nil},;
							{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
							{"C6_ITEM"		,	nItePV							,Nil},;
							{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
							{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;
							{"C6_UM"		,	SB1->B1_UM						,Nil},;
							{"C6_QTDVEN"	,	_nQtdBx							,Nil},;
							{"C6_QTDLIB"	,	_nQtdBx							,Nil},;
							{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;
							{"C6_PRCVEN"	,	_nVlrUnitD						,Nil},;
							{"C6_VALOR"		,	_nVlrItemD						,Nil},;
							{"C6_DESCONT"	,	_nPorcDesc						,Nil},;
							{"C6_VALDESC"	,	_nVlrDesc						,Nil},;
							{"C6_TES"		,	_cTes							,Nil},;
							{"C6_CF"		,	cCf								,Nil},;
							{"C6_LOCAL"		,	SB1->B1_LOCPAD					,Nil},;
							{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_SITTRIB") ,Nil},;
							{"C6_CLI"		,	SA2->A2_COD		 				,Nil},;
							{"C6_ENTREG"	,	dDataBase						,Nil},;
							{"C6_LOJA"		,	SA2->A2_LOJA					,Nil},;
							{"C6_OP"		,	'02'							,Nil},;
							{"C6_TPOP"		,	'F'								,Nil},;
							{"C6_SUGENTR"	,	dDataBase						,Nil},;
							{"C6_NFORI "	,	_cDocB6      					,Nil},;
							{"C6_SERIORI "	,	_cSerB6        					,Nil},;
							{"C6_ITEMORI "	,	nItOri         					,Nil},;
							{"C6_IDENTB6 "	,	_cIdeB6				 			,Nil}}
							
							
			
			aLinha	:= {}
			
			aAdd(aLinha,{"C7_FILIAL"	,xFilial("SC7")			,NIL})  //Item
			aAdd(aLinha,{"C7_TIPO"		,1						,NIL})  //Item
			aAdd(aLinha,{"C7_ITEM"		,nItePC					,NIL})  //Item
			aAdd(aLinha,{"C7_PRODUTO"	,SB1->B1_COD			,NIL})	//Produto
			aAdd(aLinha,{"C7_QUANT"		,_nQtdBx				,NIL})  //Quantidade
			aAdd(aLinha,{"C7_PRECO"		,_nVlrUnit				,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_TOTAL"		,_nVlrItem				,NIL})  //Preco total
			aAdd(aLinha,{"C7_DESC1"		,_nPorcDesc				,Nil})
			aAdd(aLinha,{"C7_VLDESC"	,_nVlrDesc				,Nil})
			aAdd(aLinha,{"C7_DATPRF"	,dDataBase				,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_LOCAL"		,SB1->B1_LOCPAD			,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_TPFRETE"	,"C"					,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_IPIBRUTO"	,"B"					,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_FLUXO"		,"S"					,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_CONAPRO"	,"L"					,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_USER"		,RetCodUsr()			,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_MOEDA"		,1						,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_TXMOEDA"	,1						,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_PENDEN"	,"N"					,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_POLREPR"	,"N"					,NIL})  //Preco unitario
			aAdd(aLinha,{"C7_TES"		,GetMv("MV_TESCCOL")	,Nil})	//Sequencia MRP
			aAdd(aLinha,{"C7_TPOP"		,"F"					,NIL})  //Tipo de OP
			aAdd(aLinha,{"C7_DESCRI"	,SB1->B1_DESC			,NIL})  //Tipo de OP
			aAdd(aLinha,{"C7_UM"		,SB1->B1_UM				,NIL})  //Tipo de OP
			aAdd(aLinha,{"C7_TPOP"		,"F"					,NIL})  //Tipo de OP
			aAdd(aLinha,{"C7_NUM"		,_cNumPC				,Nil})	//Numero do Pedido
			aAdd(aLinha,{"C7_EMISSAO"	,dDataBase				,Nil})	//Data de Emissao
			aAdd(aLinha,{"C7_FORNECE"	,SA2->A2_COD			,Nil})  //Fornecedor
			aAdd(aLinha,{"C7_LOJA"		,SA2->A2_LOJA			,Nil})  //Loja do Fornecedor
			aAdd(aLinha,{"C7_CONTATO"	,""						,Nil})	//Contato
			aAdd(aLinha,{"C7_COND"		,SA2->A2_COND			,Nil})  //Condicao de Pagamento
			aAdd(aLinha,{"C7_FILENT"	,Substr(cNumEmp,3,2)	,Nil}) 	//Filial de Entrega
			aAdd(aLinha,{"C7_NUMFEC"	,_cNumSZA				,Nil}) 	//Nr.do Acerto de Consignacao
			aAdd(aLinha,{"C7_APROV"		,"000070"				,Nil}) 	//Codigo do aprovador responsavel
			
			aAdd(aItemPC,aLinha)
			nItePC 		:= Soma1(nItePC)
			
			_nRegPC++
			_nReg++
			_nCont++
			nItePV 		:= Soma1(nItePV)
			nItOri 		:= Soma1(nItOri)
			aAdd(_aItemPv,aClone(_aItemTemp))
			
			/*
			TMP->(DbSkip())
			_lFimArq := TMP->(eof())
			If _lfimarq
				a:=0
			endif
			TMP->(DbSkip(-1))
			*/
			If _nReg == _nMaxReg //99 .and. cFornece <> '005509') .or.(cFornece == '005509' .and. _lFimArq)
				
				Begin Transaction
				
				//Grava o SC5
				DbSelectArea("SC5")
				Reclock("SC5",.T.)
				For ny := 1 to Len(_aCabPv)
					cVar := Trim(_aCabPv[ny][1])
					Replace &cVar. With _aCabPv[nY][2]
				Next ny
				SC5->( MsUnlock() )
				
				//Grava o SC6
				DbSelectArea("SC6")
				For nX := 1 to Len(_aItemPv)
					Reclock("SC6",.T.)
					
					For nZ := 1 to Len(_aItemPv[nX])
						cVar := Trim(_aItemPv[nX][nZ][1])
						Replace &cVar. With _aItemPv[nX][nZ][2]
					Next nZ
					SC6->C6_FILIAL := xFilial("SC6")
					
					SC6->( MsUnlock() )
	
				Next nX
				
				End Transaction
				
				_aCabPv		:= {}
				_aItemPv	:= {}
				_cNumPV		:= Space(6)
				/*
				// Retirado por Thiago Queiroz em 04/12/2013
				// Não há necessidade de quebrar o pedido de compras em mais de um pedido
				If SA2->A2_COD == '000003'
					_cNumPC	:= Space(6)
					//nItePC	:= "0001"
				EndIf
				*/
				_nReg		:= 0
				nItePV		:= "0001" 
								
			EndIf
			
			TMPSB6->(DbSkip())
			
		EndDo
		DbCloseArea()      
		
		DbSelectArea('TMP')
		TMP->(DbSkip())
		
		cFornece	:= TMP->ZA_FORNECEDOR
		cLoja		:= TMP->ZA_LOJAFOR
		cProduto	:= TMP->ZB_PRODUTO
		_nQtdPag	:= 0
		_lFaz		:= .T.
		
	EndDo
	
EndDo

If _nReg > 0
	
	Begin Transaction
	
	//Grava o SC5
	
	DbSelectArea("SC5")
	Reclock("SC5",.T.)
	For ny := 1 to Len(_aCabPv)
		cVar := Trim(_aCabPv[ny][1])
		Replace &cVar. With _aCabPv[nY][2]
	Next ny
	SC5->( MsUnlock() )
	
	//Grava o SC6
	DbSelectArea("SC6")
	For nX:= 1 to Len(_aItemPv)
		Reclock("SC6",.T.)
		
		For nZ := 1 to Len(_aItemPv[nX])
			cVar := Trim(_aItemPv[nX][nZ][1])
			Replace &cVar. With _aItemPv[nX][nZ][2]
		Next nZ
		SC6->C6_FILIAL := xFilial("SC6")
		
		SC6->( MsUnlock() )

		Reclock("SC9",.T.)
		SC9->C9_FILIAL  := xFilial("SC9")
		SC9->C9_PEDIDO  := SC6->C6_NUM
		SC9->C9_ITEM    := SC6->C6_ITEM
		SC9->C9_SEQUEN  := '01'
		SC9->C9_PRODUTO := SC6->C6_PRODUTO
		SC9->C9_QTDLIB  := SC6->C6_QTDVEN
		SC9->C9_CLIENTE := SC6->C6_CLI
		SC9->C9_LOJA    := SC6->C6_LOJA
		SC9->C9_DATALIB := date()
		SC9->C9_GRUPO   := Posicione('SB1',1,xFilial('SB1') + SC6->C6_PRODUTO,'B1_GRUPO')
		SC9->C9_PRCVEN  := SC6->C6_PRCVEN
		SC9->C9_LOCAL   := SC6->C6_LOCAL
		SC9->C9_TPCARGA := '2'
		SC9->C9_QTDLIB2 := SC6->C6_UNSVEN
		SC9->C9_IDENTB6 := SC6->C6_IDENTB6
		SC9->( MsUnlock())

	Next nX
	
	
	End Transaction
	
	_aCabPv		:= {}
	_aItemPv	:= {}
	_cNumPV		:= Space(6)
	_nReg		:= 0
	nItePV		:= "0001" 
	
EndIf

//Grava a SC7
If _nRegPC > 0
	
	Begin Transaction
	
	DbSelectArea("SC7")
	For nX:= 1 to Len(aItemPC)
		Reclock("SC7",.T.)
		
		For nZ := 1 to Len(aItemPC[nX])
			cVar := Trim(aItemPC[nX][nZ][1])
			Replace &cVar. With aItemPC[nX][nZ][2]
		Next nZ
		Replace C7_FILIAL With xFilial("SC7")
		
		SC7->( MsUnlock() )
	Next nX
	
	End Transaction
	
	aCabPC		:= {}
	aItemPC		:= {}
	_cNumPC		:= Space(6)
	_nRegPC		:= 0
	nItePC		:= "0001"
	
EndIf

DbSelectArea("SZA")
SZA->( DbSetOrder(1) )
If DbSeek(xFilial("SZA")+_cNumSZA)
	RecLock("SZA",.F.)
	Replace SZA->ZA_STATUS With "P"
	MsUnLock()
EndIf

If _nCont > 0
	
	DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,265 TITLE "Pedidos Compra/Venda" PIXEL
	@ 10,8 LISTBOX oLbx FIELDS HEADER "Pedido de Venda","Pedido de Compra" SIZE 120,80 NOSCROLL OF oDlgPC PIXEL
	oLbx:SetArray(_aPedidos)
	oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1],_aPedidos[oLbx:nAt,2]}}
	//oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1],"000000"}}
	@ 100,050 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End())
	ACTIVATE MSDIALOG oDlgPC CENTERED
	
Else
	
	MsgStop("Foram encontrados erros durante o processamento!!!")
	
EndIf


If Select("TMPSB6") > 0
	DbSelectArea("TMPSB6")
	DbCloseArea()
EndIf

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

RestArea(_aArea)

Return

Static Function LibPed(cNumPed)
Conout("*** La Selva - Static Function LibPed - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

DbSelectArea("SC9")
DbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
If DbSeek(xFilial("SC9")+cNumPed)
	While SC9->(!Eof()) .and. SC9->C9_PEDIDO==cNumPed
		SC9->(a460Estorna(.T.))
		SC9->(dbskip())
	EndDo
EndIf

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+cNumPed)
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->( DbSeek( xFilial("SC6")+cNumPed ) )
	While SC6->( !Eof() ) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cNumPed
		
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
		SC9->C9_TPCARGA	:= "2"
		SC9->C9_IDENTB6	:= SC6->C6_IDENTB6
		
		SC9->( Msunlock() )
		
		DbSelectArea("SB2")
		//If DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NA ORIGEM
		If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
			RecLock("SB2",.f.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 11/02/2016                        ³
//³Trocou o campo b2_reserva por B2_XRESERV              ³
//³ o valor de pedido não faturado para a filial destino ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


			SB2->B2_RESERVA := SB2->B2_RESERVA - _nQuant + SC9->C9_QTDLIB  // RESERVA
			MsUnLock()
		EndIf
		
		If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if SB2->B2_XTRANSI < 0 
	SB2->B2_XTRANSI:=0 
ELSE 
	SB2->B2_XTRANSI:=SB2->B2_XTRANSI 
endif		
			RecLock("SB2",.f.)                                                      
			SB2->B2_XTRANSI := SB2->B2_XTRANSI - _nQuant + SC9->C9_QTDLIB // TRANSITO			
//			SB2->B2_SALPEDI := SB2->B2_SALPEDI - _nQuant + SC9->C9_QTDLIB // TRANSITO
			MsUnLock()
		EndIf
		SC6->( DbSkip() )
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza do C5_LIBEROK e C5_STATUS                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	MsUnlock()
	
EndIf

Return
