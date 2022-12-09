/*
5202 - 	Devolução de compra para comercialização
5411 - 	Devolução de compra para comercialização em operação com mercadoria sujeita ao regime de substituição tributária
As devoluções /\

Bonificação e etc é devolvido com cfop 1949...

vendas de produtos comprados para comercialização \/
		
 
5102 - 	Venda de mercadoria adquirida ou recebida de terceiros
5104 - 	Venda de mercadoria adquirida ou recebida de terceiros, efetuada fora do estabelecimento
5106 - 	Venda de mercadoria adquirida ou recebida de terceiros, que não deva por ele transitar
5119 - 	Venda de mercadoria adquirida ou recebida de terceiros entregue ao destinatário por conta e ordem do adquirente originário, em venda à ordem
5120 -	Venda de mercadoria adquirida ou recebida de terceiros entregue ao destinatário pelo vendedor remetente, em venda à ordem
5403 - 	Venda de mercadoria adquirida ou recebida de terceiros em operação com mercadoria sujeita ao regime de substituição tributária, na condição de contribuinte substituto
5405 - 	Venda de mercadoria adquirida ou recebida de terceiros em operação com mercadoria sujeita ao regime de substituição tributária, na condição de contribuinte substituído
5910 - 	Remessa em bonificação, doação ou brinde
*/

#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
+==================+======================+================+
|Programa: SF2460I |Autor: Antonio Carlos |Data: 13/03/08  |
+==================+======================+================+
|Descricao: Ponto de Entrada utilizado no final da grava   |
|cao do SF2, onde sao processados Pedido de Compra/Pre-Nota|
|para acerto de Consignacao.                               |
+==========================================================+
|Uso: Laselva                                              |
+==========================================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SF2460I()
///////////////////////

Local aArea			:= GetArea()

Local _nRegPC		:= 0
Local _nRegPV		:= 0
Local _nRegPCP		:= 0
Local _nQtde		:= 0
Local _nPreco		:= 0
Local _nTotal		:= 0
Local _nVlrItem		:= 0
Local nItPC			:= "0001"
Local nItPCP		:= "0001"
//Local nItPV 		:= "01"                                                                                 
Local nItPV 		:= "0001"                                                                                 
Local _cCnpj 		:= ""
Local _cTesCCons	:= GetMv(iif(right(SC5->C5_CONDPAG,1) <> 'X',"MV_TESCCOR",'LS_PPCCONS'))  // Armazena Tes utlizada na compra da consignacao para produtos do grupo 0004 Revistas.                
Local _cTesPV		:= GetMv(iif(right(SC5->C5_CONDPAG,1) <> 'X',"MV_TESDSC",'LS_PPDSIMB'))	// Armazena Tes utilizado na devolucao simbolica da consignacao.   
Local _cNumPC		:= Space(6)
Local _cNumPV		:= Space(6)
Local _cNumPCP		:= Space(6)
Local aCabec		:= {}
Local aLinha		:= {}
Local aLinPCP		:= {}
Local aItePCP		:= {}
Local aCabPv		:= {}
Local aItemTemp		:= {}
Local aItemPV		:= {}
Local _aPedidos		:= {}
Local _aPedPCP		:= {}
Local _lGeraPV		:= .T.
Private aItens		:= {}
Private _aPerdas	:= {}
Private lMsErroAuto	:= .F.
Private oDlgPC
Private oLbx                                                                

//U_SX5NOTA()

////////////////////////////////////////////////////////////////
_cQuery := "UPDATE SZ9"
_cQuery += _cEnter + " SET Z9_QUANT = Z9_QUANT - D2_QUANT"
_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SZ9') + " SZ9 (NOLOCK)"
_cQuery += _cEnter + " ON Z9_FILIAL 		= D2_FILIAL"
_cQuery += _cEnter + " AND Z9_PRODUTO 		= D2_COD"
_cQuery += _cEnter + " AND SZ9.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
_cQuery += _cEnter + " ON F4_CODIGO 		= D2_TES"
_cQuery += _cEnter + " AND F4_ESTOQUE 		= 'S'"
_cQuery += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + " WHERE D2_DOC 		= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND D2_SERIE 		= '" + SF2->F2_SERIE + "'"
_cQuery += _cEnter + " AND D2_CF 			IN ('','','')   " ///////////////////////////////////////////////////////////////
_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ 	= ''"
nValSQL :=  TcSqlExec(_cQuery)

////////////////////////////////////////////////////////////////
_cQuery := "UPDATE SD2"
_cQuery += _cEnter + " SET D2_CLASFIS = B1_ORIGEM + F4_SITTRIB, D2_NUMSERI = '" + left(SC5->C5_DESCMUN,20) + "',"
_cQuery += _cEnter + " D2_SITTRIB = "		   
_cQuery += _cEnter + " CASE RIGHT(F4_SITTRIB,2) "
_cQuery += _cEnter + " WHEN  '00'  "
_cQuery += _cEnter + " 		THEN CASE "
_cQuery += _cEnter + " 			WHEN D2_PICM = 0 "
_cQuery += _cEnter + " 				THEN '1' "
_cQuery += _cEnter + " 			ELSE"
_cQuery += _cEnter + " 				CASE WHEN SD2.D2_PICM < 10 "
_cQuery += _cEnter + " 				THEN 'T0'+REPLACE(CONVERT(VARCHAR,D2_PICM),'.','')+'0' "
_cQuery += _cEnter + " 				ELSE 'T'+CONVERT(VARCHAR,D2_PICM)+'00' "
_cQuery += _cEnter + " 			END"
_cQuery += _cEnter + " 		END	 "
_cQuery += _cEnter + " 	WHEN  '10'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN  '20'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN  '30'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN  '40'"
_cQuery += _cEnter + " 		THEN 'I1'"
_cQuery += _cEnter + " 	WHEN  '41'"
_cQuery += _cEnter + " 		THEN 'N'"
_cQuery += _cEnter + " 	WHEN  '50'"			//??
_cQuery += _cEnter + " 		THEN ''"
_cQuery += _cEnter + " 	WHEN  '51'"			//??
_cQuery += _cEnter + " 		THEN ''"
_cQuery += _cEnter + " 	WHEN '60'"
_cQuery += _cEnter + " 		THEN 'N1'"
_cQuery += _cEnter + " 	WHEN  '70'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN '90'"
_cQuery += _cEnter + " 		THEN CASE WHEN D2_VALIMP1 = 0 AND D2_VALIMP2 = 0 AND D2_VALIMP3 = 0 AND D2_VALIMP4 = 0 AND D2_VALIMP5 = 0 AND D2_VALIMP6 = 0"
_cQuery += _cEnter + " 			THEN 'N1'"
_cQuery += _cEnter + " 			ELSE 'S0500'"
_cQuery += _cEnter + " 			END"
_cQuery += _cEnter + " 	ELSE ''	"
_cQuery += _cEnter + " 	END"

_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " ON B1_COD = D2_COD"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND F4_CODIGO = D2_TES"

_cQuery += _cEnter + " WHERE SD2.D_E_L_E_T_ = ''
_cQuery += _cEnter + " AND D2_DOC 			= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND D2_SERIE 		= '" + SF2->F2_SERIE + "'"
_cQuery += _cEnter + " AND D2_FILIAL 		= '" + SF2->F2_FILIAL + "'"
_cQuery += _cEnter + " AND D2_CLIENTE 		= '" + SF2->F2_CLIENTE + "'"
_cQuery += _cEnter + " AND D2_LOJA 			= '" + SF2->F2_LOJA + "'"

nValSQL := TcSqlExec(_cQuery)

////////////////////////////////////////////////////////////////
_cQuery := "UPDATE " + RetSqlName('SFT')
_cQuery += _cEnter + " SET FT_CLASFIS = D2_CLASFIS"
_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
_cQuery += _cEnter + " WHERE " + RetSqlName('SFT') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND FT_NFISCAL 		= D2_DOC"
_cQuery += _cEnter + " AND FT_SERIE 		= D2_SERIE"
_cQuery += _cEnter + " AND FT_FILIAL 		= D2_FILIAL"
_cQuery += _cEnter + " AND FT_ITEM 			= D2_ITEM"
_cQuery += _cEnter + " AND D2_DOC 			= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND D2_SERIE 		= '" + SF2->F2_SERIE + "'"
_cQuery += _cEnter + " AND D2_FILIAL 		= '" + SF2->F2_FILIAL + "'"
nValSQL := TcSqlExec(_cQuery)                
                     
////////////////////////////////////////////////////////////////
_cQuery := "UPDATE " + RetSqlName('CD2')
_cQuery += _cEnter + " SET CD2_ORIGEM = B1_ORIGEM"
_cQuery += _cEnter + " FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " WHERE B1_COD 		= CD2_CODPRO"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + " AND " + RetSqlName('CD2') + ".D_E_L_E_T_ = ''"
//_cQuery += _cEnter + " AND CD2_ORIGEM 	= ''"
_cQuery += _cEnter + " AND CD2_TPMOV 		= 'S'"
_cQuery += _cEnter + " AND CD2_FILIAL 		= '" + SF2->F2_FILIAL + "'"
_cQuery += _cEnter + " AND CD2_DOC 			= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND CD2_SERIE 		= '" + SF2->F2_SERIE + "'"
If SF1->F1_TIPO $ 'NCIP'
	_cQuery += _cEnter + " AND CD2_CODCLI 	= '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + " AND CD2_LOJCLI 	= '" + SF2->F2_LOJA + "'"
Else
	_cQuery += _cEnter + " AND CD2_CODFOR 	= '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + " AND CD2_LOJFOR 	= '" + SF2->F2_LOJA + "'"
EndIf                                    
nValSQL := TcSqlExec(_cQuery)

_cQuery := "SELECT F2_DOC, F2_SERIE, F2_FILIAL, F2_EMISSAO, F2_CLIENTE, F2_LOJA, " + iif(SC5->C5_TIPO $ 'B/D', 'A2_NREDUZ','A1_NREDUZ') + " NREDUZ, dbo.DESEMBARALHA(F2_USERLGI) USUARIO"
_cQuery += _cEnter + " FROM " + RetSqlName('SF2') + " SF2 (NOLOCK)"
If SC5->C5_TIPO $ 'B/D'
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SA2') + " SA2 (NOLOCK)"
	_cQuery += _cEnter + " ON A2_COD 			= F2_CLIENTE"
	_cQuery += _cEnter + " AND A2_LOJA 			= F2_LOJA"
	_cQuery += _cEnter + " AND SA2.D_E_L_E_T_ 	= ''"
Else	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SA1') + " SA1 (NOLOCK)"
	_cQuery += _cEnter + " ON A1_COD	 		= F2_CLIENTE"
	_cQuery += _cEnter + " AND A1_LOJA 			= F2_LOJA"
	_cQuery += _cEnter + " AND SA1.D_E_L_E_T_	= ''"
EndIf	
_cQuery += _cEnter + " WHERE F2_EMISSAO 		= '" + dtos(dDataBase) + "'"
_cQuery += _cEnter + " AND F2_FILIAL 			= '" + xFilial('SF2') + "'"
_cQuery += _cEnter + " AND F2_CLIENTE 			<> '999999'"
_cQuery += _cEnter + " AND SF2.D_E_L_E_T_ 		= ''"
_cQuery += _cEnter + " AND F2_DOC 		  		= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND F2_SERIE 	  		= '" + SF2->F2_SERIE + "'"

DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"_SF2", .T., .T.)

_nQuant := 0
_cTexto := 'Este número de nota fiscal está sendo utilizado mais de uma vez.' + _cEnter
_cTexto += 'Exclua uma das notas fiscais geradas para corrigir' + _cEnter + _cEnter

Do While !eof()
	++_nQuant
	_cTexto += _SF2->F2_CLIENTE + '/' + _SF2->F2_LOJA + ' - ' + _SF2->NREDUZ + '(' + _SF2->USUARIO + ')' + _cEnter
	DbSkip()
EndDo
DbCloseArea()

If _nQuant > 1
	MsgAlert(_cTexto,'Expedição')
EndIf	

If SC5->C5_TIPO $ "B/D"
	_cCnpj := SA2->A2_CGC
Else
	_cCnpj := SA1->A1_CGC
EndIf
                                                   
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////      notas fiscais de transferencia de crédito de icms
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

If Posicione('SF4',1,xFilial('SF4') + SD2->D2_TES,'F4_FORMULA') == '999'
	
	RecLock('SF2',.f.)
	SF2->F2_VALICM  := SF2->F2_VALBRUT
	SF2->F2_TRANSP  := ''
	MsUnLock()

	RecLock('SF3',.f.)
	SF3->F3_VALOBSE := SF2->F2_VALICM
	MsUnLock()

////////////////////////////////////////////////////////////////
	_cQuery := "UPDATE " + RetSqlName('SD2')
	_cQuery += " SET D2_VALICM = D2_TOTAL" 
	_cQuery += " WHERE D2_FILIAL 	= '" + SF2->F2_FILIAL + "'"
	_cQuery += " AND D2_DOC 		= '" + SF2->F2_DOC + "'"
	_cQuery += " AND D2_SERIE 		= '" + SF2->F2_SERIE + "'"
	nValSQL := TcSqlExec(_cQuery)

////////////////////////////////////////////////////////////////
	_cQuery := "UPDATE " + RetSqlName('SFT')
	_cQuery += " SET FT_VALICM = FT_VALCONT" 
	_cQuery += " WHERE FT_FILIAL 	= '" + SF2->F2_FILIAL + "'"
	_cQuery += " AND FT_NFISCAL 	= '" + SF2->F2_DOC + "'"
	_cQuery += " AND FT_SERIE 		= '" + SF2->F2_SERIE + "'"
	nValSQL := TcSqlExec(_cQuery)

EndIf

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DbSelectArea('PA6')
If DbSeek(xFilial('PA6') + SD2->D2_PEDIDO + SD2->D2_FILIAL,.f.)
	_cQuery := "SELECT SUM(PA7_QTDREC) QTDREC"
	_cQuery += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK)"
	_cQuery += _cEnter + " WHERE PA7_NUMROM 	= '" + PA6->PA6_NUMROM + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ 		= ''"
	DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"_PA7", .T., .T.)

	RecLock('PA6',.f.)
	PA6->PA6_STATUS := iif(_PA7->QTDREC > 0 .and. SF2->F2_FILIAL <> 'C0', '05','04')
	PA6->PA6_NFS    := SF2->F2_DOC
	PA6->PA6_SERIE  := SF2->F2_SERIE
	PA6->PA6_USER   := Embaralha(cUserName,0 )
	MsUnLock()                                              
	
	_PA7->(DbCloseArea())
		
EndIf

If !Substr(_cCnpj,1,8) $ GetMv("MV_CNPJLSV") .And. SC5->C5_TIPO  $  "B/D"
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		While SD2->(!Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+;
			SD2->D2_LOJA == SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
			
			If !SD2->D2_TES $ GetMv("MV_TESDCO") .Or. !SD2->D2_GRUPO $ GetMv("MV_GRPREVI")  //Armazena Tes utilizada para devolucao de mercadoria recebida em consignacao.
				SD2->(DbSkip())
				Loop
			EndIf
			
			DbSelectArea("SB6")
			SB6->(DbSetOrder(3))
			If SB6->(DbSeek(xFilial("SB6")+SD2->D2_IDENTB6+SD2->D2_COD+"R"))
				If SD2->D2_TES == Alltrim(GetMv("MV_TESDSC"))	//Armazena Tes utilizado na devolucao simbolica da consignacao. 
					_nQtde += SD2->D2_QUANT
					_lGeraPV := .F.
				Else
					_nQtde += SB6->B6_SALDO
				EndIf
			EndIf
			
			If SD2->D2_TES == Alltrim(GetMv("MV_TESDSC")) .And. SD2->D2_GRUPO $ GetMv("MV_GRPREVI")	//Armazena Tes utilizado na devolucao simbolica da consignacao. 
				Aadd( _aPerdas,{.T.,SD2->D2_COD} )		
			EndIf
			
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
			
			cEstado := SA2->A2_EST
			
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			DbSeek( xFilial("SB1")+SB6->B6_PRODUTO )
			
			If _lGeraPV .And. _nQtde > 0
				If Empty(_cNumPV)
					_cNumPV := GetSxeNum("SC5","C5_NUM")
					While .T.
						DbSelectArea("SC5")
						DbSetOrder(1)
						If DbSeek(xFilial("SC5")+_cNumPV)
							ConfirmSX8()
							_cNumPV := GetSxeNum("SC5","C5_NUM")
						Else
							ConfirmSX8()
							Exit
						EndIf
					EndDo
					
					aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")				,Nil},;
								{"C5_NUM"		,   _cNumPV				   		,Nil},;
								{"C5_TIPO"		,   'B'							,Nil},;
								{"C5_CLIENTE"	,	SA2->A2_COD					,Nil},;
								{"C5_LOJACLI"	,	SA2->A2_LOJA				,Nil},;
								{"C5_CLIENT"	,	SA2->A2_COD					,Nil},;
								{"C5_LOJAENT"	,	SA2->A2_LOJA				,Nil},;				   
								{"C5_TIPOCLI"	,	"R"							,Nil},;
								{"C5_TRANSP"	,	"000001"					,Nil},;
								{"C5_TPFRETE"	,	'F'							,Nil},;
								{"C5_MOEDA"		,	1							,Nil},;
								{"C5_CONDPAG"	,	SA2->A2_COND				,Nil},;
								{"C5_TES"    	,	_cTesPV						,Nil},;
								{"C5_STATUS"	,	'01'						,Nil},;
								{"C5_EMISSAO"	,	dDataBase					,Nil},;
								{"C5_DATA"		,	dDataBase					,Nil},;
								{"C5_HORA"		,	Time()						,Nil},;
								{"C5_VEND1"		,	"000001"					,Nil},;
								{"C5_USERCAL"	,	"NF " + SF2->F2_DOC + SF2->F2_SERIE ,Nil}}
					
					Aadd(_aPedidos,{_cNumPV,_cNumPC})
				EndIf
				
			EndIf
			
			aLinha	:= {}
			
			If _nQtde > 0 .And. SD2->D2_TES == Alltrim(GetMv("MV_TESDSC"))	//Armazena Tes utilizado na devolucao simbolica da consignacao. 
				
				If Empty(_cNumPC)
					
					_cNumPC := GetSxeNum("SC7","C7_NUM")
					While .T.
						DbSelectArea("SC7")
						DbSetOrder(1)
						If DbSeek(xFilial("SC7")+_cNumPC)
							ConfirmSX8()
							_cNumPC := GetSxeNum("SC7","C7_NUM")
						Else
							ConfirmSX8()
							Exit
						EndIf
					EndDo
					
					Aadd(_aPedidos,{_cNumPV,_cNumPC})
					
				EndIf   
				
				_nTotal := Round(SB6->B6_PRUNIT*_nQtde,4)
				
				aLinha	:= {}
		   			 
			   	aAdd(aLinha,{"C7_FILIAL"	,xFilial("SC7")			,NIL})          //Item 
				aAdd(aLinha,{"C7_TIPO"		,1						,NIL})          //Item 		   			                                                                       		
				aAdd(aLinha,{"C7_ITEM"		,nItPC					,NIL})          //Item
				aAdd(aLinha,{"C7_PRODUTO"	,SB1->B1_COD			,NIL})     		//Produto
				aAdd(aLinha,{"C7_QUANT"		,_nQtde		   			,NIL})          //Quantidade
				aAdd(aLinha,{"C7_PRECO"		,SB6->B6_PRUNIT			,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_TOTAL"		,_nTotal				,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_DATPRF"	,dDataBase				,NIL})          //Preco unitario				
				aAdd(aLinha,{"C7_LOCAL"		,SB1->B1_LOCPAD			,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_TPFRETE"	,"C"					,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_IPIBRUTO"	,"B"					,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_FLUXO"		,"S"					,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_CONAPRO"	,"L"					,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_USER"		,RetCodUsr()			,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_MOEDA"		,1						,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_TXMOEDA"	,1						,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_PENDEN"	,"N"					,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_POLREPR"	,"N"					,NIL})          //Preco unitario
				aAdd(aLinha,{"C7_TES"		,_cTesCCons				,Nil})			//Armazena Tes utlizada na compra da consignacao para produtos do grupo 0004 Revistas.     
				aAdd(aLinha,{"C7_TPOP"		,"F"					,NIL})          //Tipo de OP  
				aAdd(aLinha,{"C7_DESCRI"	,SB1->B1_DESC			,NIL})          //Tipo de OP  					
				aAdd(aLinha,{"C7_UM"		,SB1->B1_UM				,NIL})          //Tipo de OP  
				aAdd(aLinha,{"C7_TPOP"		,"F"					,NIL})          //Tipo de OP  
				aAdd(aLinha,{"C7_NUM"		,_cNumPC				,Nil})			//Numero do Pedido
				aAdd(aLinha,{"C7_EMISSAO"	,dDataBase				,Nil})			//Data de Emissao
				aAdd(aLinha,{"C7_FORNECE"	,SA2->A2_COD			,Nil})  		//Fornecedor
				aAdd(aLinha,{"C7_LOJA"		,SA2->A2_LOJA			,Nil})      	//Loja do Fornecedor
				aAdd(aLinha,{"C7_CONTATO"	,""						,Nil})			//Contato
				aAdd(aLinha,{"C7_COND"		,SA2->A2_COND			,Nil})       	//Condicao de Pagamento
				aAdd(aLinha,{"C7_FILENT"	,Substr(cNumEmp,3,2)	,Nil}) 			//Filial de Entrega  
				aAdd(aLinha,{"C7_OBS"		, "DEV SIMB " + SF2->F2_DOC + SF2->F2_SERIE,Nil}) // NOTA FISCAL DE DEVOLUCAO SIMBOLICA
					
				aAdd(aItens,aLinha)
				nItPC := Soma1(nItPC)
				_nRegPC++ 
		
			EndIf
			
			
			If _lGeraPV .And. _nQtde > 0
				cCf	:= Posicione("SF4",1,xFilial("SF4")+_cTesPv,"F4_CF")
				
				If SM0->M0_ESTENT <> cEstado
					cCf := "6"+Substr(cCf,2,3)
				EndIf
				
				_nVlrItem := Round(SB6->B6_PRUNIT*_nQtde,4)
				
				nItPCP:=POSICIONE("SD1",3 , xFilial("SD1") + SB6->B6_DOC+SB6->B6_SERIE+SB6->B6_CLIFOR+SB6->B6_LOJA+SB6->B6_PRODUTO, "SD1->D1_ITEM")
				
				
				aItemTemp := {{"C6_NUM"	,	_cNumPV					,Nil},;
				{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
				{"C6_ITEM"		,	nItPV							,Nil},;
				{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
				{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;
				{"C6_UM"		,	SB1->B1_UM						,Nil},;
				{"C6_QTDVEN"	,	_nQtde							,Nil},;
				{"C6_PRUNIT"	,	SB6->B6_PRUNIT					,Nil},;
				{"C6_PRCVEN"	,	SB6->B6_PRUNIT					,Nil},;
				{"C6_VALOR"		,	_nVlrItem						,Nil},;
				{"C6_TES"		,	_cTesPv							,Nil},;
				{"C6_CF"		,	cCf								,Nil},;
				{"C6_DESCONT"	,	SD2->D2_DESC					,Nil},;
				{"C6_LOCAL"		,	SB1->B1_LOCPAD					,Nil},;
				{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTesPv,"F4_SITTRIB") ,Nil},;
				{"C6_CLI"		,	SA2->A2_COD		 				,Nil},;
				{"C6_ENTREG"	,	dDataBase						,Nil},;
				{"C6_LOJA"		,	SA2->A2_LOJA					,Nil},;
				{"C6_NFORI "	,	SB6->B6_DOC		  				,Nil},;
				{"C6_SERIORI "	,	SB6->B6_SERIE  					,Nil},;
				{"C6_ITEMORI "	,	nItPV	,Nil},; //nItPV				
				{"C6_IDENTB6 "	,	SB6->B6_IDENT		 			,Nil}}

				nItPV := Soma1(nItPV,4)
				
				aAdd(aItemPv,aClone(aItemTemp))
				_nRegPV++
				
			EndIf
			
			_nQtde := 0
			
			SD2->(DbSkip())
			
		EndDo
		
		
		If _nRegPC > 0
		
			//Grava a SC7
			DbSelectArea("SC7")
			For nX:= 1 to Len(aItens)
				Reclock("SC7",.T.)
			
				For nZ := 1 to Len(aItens[nX])
					cVar := Trim(aItens[nX][nZ][1])
					Replace &cVar. With aItens[nX][nZ][2]
		   		Next nZ
		   		Replace C7_FILIAL With xFilial("SC7")
			
				MsUnlock()
		   		DbCommit()
	   		Next nX	
			
		EndIf
		
		
		If _lGeraPV .And. _nRegPV > 0
			
			
			//Grava o SC5
			DbSelectArea("SC5")
			Reclock("SC5",.T.)
			For ny := 1 to Len(aCabPv)
				cVar := Trim(aCabPv[ny][1])
				Replace &cVar. With aCabPv[nY][2]
			Next ny
			SC5->( MsUnlock() )
				
			//Grava o SC6
			DbSelectArea("SC6")
			For nX:= 1 to Len(aItemPv)
				Reclock("SC6",.T.)
							
				For nZ := 1 to Len(aItemPv[nX])
					cVar := Trim(aItemPv[nX][nZ][1])
					Replace &cVar. With aItemPv[nX][nZ][2]
				Next nZ
				Replace C6_FILIAL With xFilial("SC6")
							
				SC6->( MsUnlock() )
				
			Next nX                         
				
		EndIf
		
		For _nI := 1 To Len(_aPedidos)
			U_LibPedAuto(_aPedidos[_nI,1])			
		Next _nI
		
		If _nRegPC > 0 .Or. _nRegPV > 0
			
			DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,250 TITLE "Pedidos de Venda" PIXEL
			
			@ 10,8 LISTBOX oLbx FIELDS HEADER "Pedido de Venda","Pedido de Compra" SIZE 100,80 NOSCROLL OF oDlgPC PIXEL
			
			oLbx:SetArray(_aPedidos)
			oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1],_aPedidos[oLbx:nAt,2]}}
			
			@ 100,065 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End())
			
			ACTIVATE MSDIALOG oDlgPC CENTERED
			
		EndIf
		
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If SD2->( DbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
			DbSelectArea("SC5")
			SC5->( DbSetOrder(1) )			
			If SC5->( DbSeek( xFilial("SC5")+SD2->D2_PEDIDO ) )	
				If !Empty(SC5->C5_NUMFEC)
					
					DbSelectArea("SZA")
					SZA->( DbSetOrder(1) )			
					If SZA->( DbSeek( xFilial("SZA")+SC5->C5_NUMFEC ) )	
						If SZA->ZA_STATUS <> "P"
							RecLock("SZA",.F.)
							SZA->ZA_STATUS := "P"
							SZA->( MsUnLock() )
						EndIf
						
					EndIf		
				EndIf
			EndIf	
		EndIf
		
	EndIf
EndIf

If SF2->F2_TIPO $ 'DB'
////////////////////////////////////////////////////////////////
	_cQuery := "UPDATE " + RetSqlName('SE2')
	_cQuery += _cEnter + " SET E2_FILORIG = '" + cFilAnt + "', E2_CLASS = '" + SA2->A2_CLASS + "'"
	_cQuery += _cEnter + " WHERE E2_PREFIXO = '" + SF2->F2_PREFIXO + "'"
	_cQuery += _cEnter + " AND E2_NUM = '" + SF2->F2_DUPL + "'"
	_cQuery += _cEnter + " AND E2_FORNECE = '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + " AND E2_LOJA = '" + SF2->F2_LOJA + "'"
Else
////////////////////////////////////////////////////////////////
	_cQuery := "UPDATE " + RetSqlName('SE1')
	_cQuery += _cEnter + " SET E1_FILORIG = '" + cFilAnt + "', E1_CLASS = '" + SA1->A1_CLASS + "'"
	_cQuery += _cEnter + " WHERE E1_PREFIXO = '" + SF2->F2_PREFIXO + "'"
	_cQuery += _cEnter + " AND E1_NUM = '" + SF2->F2_DUPL + "'"
	_cQuery += _cEnter + " AND E1_CLIENTE = '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + " AND E1_LOJA = '" + SF2->F2_LOJA + "'"
EndIf
nValSQL := TcSqlExec(_cQuery)

DbSelectArea("SCV")
SCV->(DbSetOrder(1))
If SCV->(DbSeek(xFilial("SCV")+SC5->C5_NUM))
	If Alltrim(SCV->CV_FORMAPG) $ "MPE/MPP"
		DbSelectArea("SE1")
		SE1->(DbSetOrder(2))
		If SE1->( DbSeek(xFilial("SE1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_SERIE+SC5->C5_NOTA) )
			While SE1->(!Eof()) .And. SE1->E1_FILORIG+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == SC5->C5_FILIAL+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_SERIE+SC5->C5_NOTA
				RecLock("SE1",.F.)
				Replace SE1->E1_NATUREZ With Alltrim(SCV->CV_FORMAPG)
				MsUnLock()
				SE1->(DbSkip())
			EndDo
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ImpPerda(aItens)
////////////////////////////////

Local _cStrAux 	:= ""
Local _cStrCod 	:= ""
Local _aItens	:= {}

Local _nQtdPT	:= 0
Local _nValPT	:= 0
Local _nValP 	:= 0
Local _nQtdPTP	:= 0 
Local _nQtdP	:= 0
Local _nValPTP	:= 0
Local _nQtdG 	:= 0
Local _nQtdPTG	:= 0
Local _nValPTG	:= 0

Private oDlgPC
Private oLbx

AEval(aItens, {|x| If(x[1]==.T.,_cStrAux+="'"+SubStr(x[2],1,TamSX3("D2_COD")[1])+"'"+",",Nil)})
_cStrCod := Substr(_cStrAux,1,Len(_cStrAux)-1)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC, "
cQry += " COALESCE((SELECT SUM(E.D1_QUANT) FROM "+RetSqlName("SD1")+" E WITH(NOLOCK)  WHERE E.D1_FILIAL = '"+xFilial("SD2")+"' AND E.D1_COD = A.D2_COD AND E.D1_TES = '063' AND  E.D_E_L_E_T_ = ''),0) AS 'CONSIGNADA', "
cQry += " COALESCE((SELECT D1_CUSTO/D1_QUANT FROM "+RetSqlName("SD1")+" F WITH(NOLOCK)  WHERE F.D1_FILIAL = '"+xFilial("SD2")+"' AND F.D1_COD = A.D2_COD AND F.D1_TES = '063' AND  F.D_E_L_E_T_ = ''),0) AS 'CUSTO', "
cQry += " COALESCE((SELECT SUM(D.D2_QUANT) FROM "+RetSqlName("SD2")+" D WITH(NOLOCK)  WHERE D.D2_FILIAL = '"+xFilial("SD2")+"' AND D.D2_COD = A.D2_COD AND D.D2_TES = '599' AND  D.D_E_L_E_T_ = ''),0) AS 'DEVOLVIDA',"
cQry += " COALESCE(SUM(A.D2_QUANT),0) AS 'VENDIDA', " 
cQry += " COALESCE((SELECT SUM(C.D2_QUANT) FROM "+RetSqlName("SD2")+" C WITH(NOLOCK)  WHERE C.D2_FILIAL = '"+xFilial("SD2")+"' AND C.D2_COD = A.D2_COD AND C.D2_TES = '600' AND  C.D_E_L_E_T_ = ''),0) AS 'COMPRA', "
cQry += " COALESCE(SUM(A.D2_QUANT),0) - "
cQry += " COALESCE((SELECT SUM(C.D2_QUANT) FROM "+RetSqlName("SD2")+" C WITH(NOLOCK)  WHERE C.D2_FILIAL = '"+xFilial("SD2")+"' AND C.D2_COD = A.D2_COD AND C.D2_TES = '600' AND  C.D_E_L_E_T_ = ''),0) AS 'DIFERENCA' "
cQry += " FROM "+RetSqlName("SD2")+" A WITH(NOLOCK) "
cQry += " INNER JOIN "+RetSqlName("SB1")+" B WITH(NOLOCK)  ON B.B1_COD = A.D2_COD AND B.D_E_L_E_T_ = '' "
cQry += " WHERE "
If SM0->M0_CODFIL == "01"
	cQry += " A.D2_FILIAL < '99' AND " 
Else
	cQry += " A.D2_FILIAL = '"+xFilial("SD2")+"' AND "
EndIf
cQry += " A.D2_CLIENTE = '999999' AND "
cQry += " A.D2_COD IN ( "+_cStrCod+" )  AND "
cQry += " A.D2_TIPO = 'N' AND "
cQry += " A.D_E_L_E_T_ = '' "
cQry += " GROUP BY A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC "
cQry += " ORDER BY A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC "

Memowrite("SF2460I.SQL",cQry)

TcQuery cQry NEW ALIAS "TMP"

DbSelectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() )
	     
		If TMP->DIFERENCA <> 0
						
			oProcess := TWFProcess():New( "SF2460I1", "Relatorio de Perdas" )
			oProcess:NewTask( "Relatorio", "\WORKFLOW\HTML\PERDAS_REVISTA.HTM" )

			oProcess:cSubject	:= "Relatorio de Perdas - Revistas"	
			oHTML := oProcess:oHTML
				
			oHtml:ValByname("CODIGO"	, SF2->F2_CLIENTE+" - "+SF2->F2_LOJA)
			oHtml:ValByName("FORNECEDOR", Substr(Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_NOME"),1,30) )
			oHtml:ValByname("FILIAL"	, SM0->M0_CODFIL+" - "+SM0->M0_FILIAL)
			oHtml:ValByName("NF"		, SF2->F2_DOC+" - "+SF2->F2_SERIE)
	
			While TMP->( !Eof() )
		
				If TMP->DIFERENCA < 0
					_nQtdP := (TMP->DIFERENCA*(-1))
					_nValP := TMP->CUSTO*_nQtdP					
					_nQtdPTP += _nQtdP
					_nValPTP += _nValP
				Else
					_nQtdG := TMP->DIFERENCA	
					_nValP := TMP->CUSTO*_nQtdG									
					_nQtdPTG += _nQtdG
					_nValPTG += _nValP
				EndIf
											
				Aadd( (oHtml:ValByName( "IT.PRODUTO" )),TMP->D2_COD )
				Aadd( (oHtml:ValByName( "IT.DESC" )),Substr(Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_DESC"),1,30) )
				Aadd( (oHtml:ValByName( "IT.CONSIG" )),TRANSFORM( TMP->CONSIGNADA,'@E 999,999,999.99' ) )
				Aadd( (oHtml:ValByName( "IT.VENDAS" )),TRANSFORM( TMP->VENDIDA,'@E 999,999,999.99' ) )
				Aadd( (oHtml:ValByName( "IT.DEVOL" )),TRANSFORM( TMP->DEVOLVIDA,'@E 999,999,999.99' ) )
				Aadd( (oHtml:ValByName( "IT.COMPRA" )),TRANSFORM( TMP->COMPRA,'@E 999,999,999.99' ) )
				Aadd( (oHtml:ValByName( "IT.PERDA" )),TRANSFORM( _nQtdP,'@E 999,999,999.99' ) )
				Aadd( (oHtml:ValByName( "IT.GANHO" )),TRANSFORM( _nQtdG,'@E 999,999,999.99' ) )
				Aadd( (oHtml:ValByName( "IT.VALOR" )),TRANSFORM( _nValP,'@E 999,999,999.99' ) )
							
				TMP->( DbSkip() )
		
			EndDo 
			
			_nQtdPT += _nQtdPTP-_nQtdPTG
			_nValPT	+= _nValPTP-_nValPTG
			
			oHtml:ValByName( "QTD" ,TRANSFORM( _nQtdPT,'@E 999,999,999.99' ) )
			oHtml:ValByName( "LBTOTAL" ,TRANSFORM( _nValPT,'@E 999,999,999.99') )

			oProcess:Start() 										
							
							
		EndIf					
	    	
		TMP->( DbSkip() )
		
	EndDo
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RelPerdas()
///////////////////////////

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "com os produtos do Acerto de Consignacao - Revistas. "
Local cDesc3       := " "
Local cPict        := ""
Local titulo       := "ACERTO DE REVISTAS " 
Local nLin         := 80

Local Cabec1       := "Produto           Descricao                         Consignacao         Vendas        Devolucao      Compra      Perda         Ganho            Valor         "
                      //"Fornecedor/Loja: "  + _cForn + space(02) + _cLoja + space(02)+ Posicione("SA2", 1, xFilial("SA2") + _cForn + _cLoja ,"A2_NREDUZ")
Local Cabec2       := ""
              //        99  9999  123456   99   01234567   1234   12345678901234567890 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234567890 
              //       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890   
              //                 1         2         3         4         5         6         7         8         9         10        11        12        13
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RelPerdas" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RelPerdas" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunRel03(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREL03  º Autor ³ AP6 IDE            º Data ³  13/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunRel03(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Local _cStrAux 	:= ""
Local _cStrCod 	:= ""
Local _aItens	:= {}

Local _nQtdPT	:= 0
Local _nValPT	:= 0
Local _nValP 	:= 0
Local _nQtdPTP	:= 0 
Local _nQtdP	:= 0
Local _nValPTP	:= 0
Local _nQtdG 	:= 0
Local _nQtdPTG	:= 0
Local _nValPTG	:= 0

AEval(_aPerdas, {|x| If(x[1]==.T.,_cStrAux+="'"+SubStr(x[2],1,TamSX3("D2_COD")[1])+"'"+",",Nil)})
_cStrCod := Substr(_cStrAux,1,Len(_cStrAux)-1)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC, "
cQry += " COALESCE((SELECT SUM(E.D1_QUANT) FROM "+RetSqlName("SD1")+" E WITH(NOLOCK)  WHERE E.D1_FILIAL = '"+xFilial("SD2")+"' AND E.D1_COD = A.D2_COD AND E.D1_TES = '063' AND  E.D_E_L_E_T_ = ''),0) AS 'CONSIGNADA', "
cQry += " COALESCE((SELECT D1_CUSTO/D1_QUANT FROM "+RetSqlName("SD1")+" F WITH(NOLOCK)  WHERE F.D1_FILIAL = '"+xFilial("SD2")+"' AND F.D1_COD = A.D2_COD AND F.D1_TES = '063' AND  F.D_E_L_E_T_ = ''),0) AS 'CUSTO', "
cQry += " COALESCE((SELECT SUM(D.D2_QUANT) FROM "+RetSqlName("SD2")+" D WITH(NOLOCK)  WHERE D.D2_FILIAL = '"+xFilial("SD2")+"' AND D.D2_COD = A.D2_COD AND D.D2_TES = '599' AND  D.D_E_L_E_T_ = ''),0) AS 'DEVOLVIDA',"
cQry += " COALESCE(SUM(A.D2_QUANT),0) AS 'VENDIDA', " 
cQry += " COALESCE((SELECT SUM(C.D2_QUANT) FROM "+RetSqlName("SD2")+" C WITH(NOLOCK)  WHERE C.D2_FILIAL = '"+xFilial("SD2")+"' AND C.D2_COD = A.D2_COD AND C.D2_TES = '600' AND  C.D_E_L_E_T_ = ''),0) AS 'COMPRA', "
cQry += " COALESCE(SUM(A.D2_QUANT),0) - "
cQry += " COALESCE((SELECT SUM(C.D2_QUANT) FROM "+RetSqlName("SD2")+" C WITH(NOLOCK)  WHERE C.D2_FILIAL = '"+xFilial("SD2")+"' AND C.D2_COD = A.D2_COD AND C.D2_TES = '600' AND  C.D_E_L_E_T_ = ''),0) AS 'DIFERENCA' "
cQry += " FROM "+RetSqlName("SD2")+" A WITH(NOLOCK) "
cQry += " INNER JOIN "+RetSqlName("SB1")+" B WITH(NOLOCK)  ON B.B1_COD = A.D2_COD AND B.D_E_L_E_T_ = '' "
cQry += " WHERE "
If SM0->M0_CODFIL == "01"
	cQry += " A.D2_FILIAL < '99' ) AND " 
Else
	cQry += " A.D2_FILIAL = '"+xFilial("SD2")+"' AND "
EndIf
cQry += " A.D2_CLIENTE = '999999' AND "
cQry += " A.D2_COD IN ( "+_cStrCod+" )  AND "
cQry += " A.D2_TIPO = 'N' AND "
cQry += " A.D_E_L_E_T_ = '' "
cQry += " GROUP BY A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC "
cQry += " ORDER BY A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC "

TcQuery cQry NEW ALIAS "TMP"

SetRegua( RecCount() )
   
If nLin > 55 
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
EndIf    

DbSelectArea("TMP")	
TMP->( DbGoTop() )
If TMP->( !Eof() )

	While TMP->( !Eof() )
	
		If TMP->DIFERENCA <> 0
						
			While TMP->( !Eof() )
		
				If TMP->DIFERENCA < 0
					_nQtdP := (TMP->DIFERENCA*(-1))
					_nValP := TMP->CUSTO*_nQtdP					
					_nQtdPTP += _nQtdP
					_nValPTP += _nValP
				Else
					_nQtdG := TMP->DIFERENCA	
					_nValP := TMP->CUSTO*_nQtdG									
					_nQtdPTG += _nQtdG
					_nValPTG += _nValP
				EndIf
				
				@ nLin,01	PSAY TMP->D2_COD
				@ nLin,18	PSAY Substr( Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_DESC"),1,30 ) 
   				@ nLin,50	PSAY TMP->CONSIGNADA	Picture "@E 999,999,999.99"
				@ nLin,64	PSAY TMP->VENDIDA		Picture "@E 999,999,999.99"
				@ nLin,78	PSAY TMP->DEVOLVIDA		Picture "@E 999,999,999.99"
				@ nLin,92	PSAY TMP->COMPRA		Picture "@E 999,999,999.99"
				@ nLin,106	PSAY _nQtdP				Picture "@E 999,999,999.99"
				@ nLin,120	PSAY _nQtdG				Picture	"@E 999,999,999.99"
				@ nLin,134	PSAY _nValP				Picture "@E 999,999,999.99"
      
				nLin := nLin + 1 
														
				TMP->( DbSkip() )
		
			EndDo 
			
			_nQtdPT += _nQtdPTP-_nQtdPTG
			_nValPT	+= _nValPTP-_nValPTG
			
		EndIf					
	    	
		TMP->( DbSkip() )
		
	EndDo
	
EndIf

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return     
