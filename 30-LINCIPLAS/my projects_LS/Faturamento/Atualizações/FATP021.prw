#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"                                                                                                          

/*
+================================================================+
|Programa: FATP021| Autor: Antonio Carlos | Data: 06/10/09       |
+================================================================+
|Descricao: Rotina responsavel pelo processamento dos Pedidos    |
|de Venda/NF Fiscal ref. o processo de Devolução Simbólica entre |
|Laselva x Coligadas.                                            |
+================================================================+
|Uso: Laselva                                                    |
+================================================================+
*/

User Function FATP021()
                                  
Local nOpca 		:= 0
Local aSays 		:= {}
Local aButtons  	:= {}
Private cCadastro	:= "Devolucao Mercadorias Lojas - Laselva "

AADD(aSays,OemToAnsi( "Essa rotina tem por objetivo efetuar o processamento dos" ) ) 
AADD(aSays,OemToAnsi( "Pedidos de Vendas referente devolucao de mercadorias entre" ) )
AADD(aSays,OemToAnsi( "Lojas x Laselva." ) )
AADD(aSays,OemToAnsi( " " ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return NIL
EndIf

LjMsgRun("Aguarde..., Processando registros...",, {|| AtuDados() }) 

Return Nil

Return

Static Function AtuDados()

Local _aArea	:= GetArea() 

Local nTotRec	:= 0
Local _nVlrUnit	:= 0 
Local _nVlrItem := 0
Local _nReg		:= 0 
Local _nPrUnit	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0

Local _lFaz		:= .T.
	
Local nItePV	:= "0001"  
Local nItOri	:= "0001"
Local _cTes		:= "600"

Local _aCabPv		:= {}
Local _aItemTemp	:= {}  
Local _aItemPv		:= {}

//583 - Devolução Consig. S/ ICMS c/est
//624 - Devolução Consig. C/ ICMS c/est
//521 - Devolução Compra  S/ ICMS c/est
//522 - Devolução Compra  C/ ICMS c/est

Private	oDlgPC
Private _cNumPV 	:= Space(6)
Private _nCont		:= 0
Private _aPedidos	:= {}
Private _aCompras	:= {}

If Select("QRYAC") > 0
	DbSelectArea("QRYAC")
	DbCloseArea()
EndIf	

cQryAc := " SELECT * FROM DEVOLAUT WHERE CODFIL = '"+xFilial("SB6")+"' ORDER BY PRODUTO "
TcQuery cQryAc NEW ALIAS "QRYAC"

Count To nTotRec
ProcRegua(nTotRec)

DbSelectArea("QRYAC") 
QRYAC->( DbGoTop() )
If QRYAC->( !Eof() )
	
	While QRYAC->( !Eof() ) 
						
		IncProc("Processando Filial: "+QRYAC->LOJA )
		
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
						
			cFornece := QRYAC->FORNECEDOR
			cLoja	 := QRYAC->LOJA
			
			DbSelectArea("SA2")
			SA2->( DbSetOrder(1) )
			DbSeek( xFilial("SA2")+cFornece+cLoja)    
				
			cEstado := SA2->A2_EST
					
			_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
			{"C5_NUM"		,   _cNumPV						,Nil},;
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
			{"C5_STATUS"	,	'01'						,Nil},;
			{"C5_EMISSAO"	,	dDataBase					,Nil},;
			{"C5_DATA"		,	dDataBase					,Nil},;
			{"C5_HORA"		,	Time()						,Nil},;
			{"C5_MOEDA"		,	1							,Nil},;						
			{"C5_TIPLIB"	,	'1'							,Nil},;
			{"C5_TXMOEDA"	,	1							,Nil},;
			{"C5_TPCARGA"	,	'2'							,Nil},;
			{"C5_VEND1"		,	"000001"					,Nil}}
				    						    
	    	Aadd(_aPedidos,{_cNumPV})
	    
		EndIf
			
		_nQtdPag	:= QRYAC->QTD
					
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) )
		DbSeek( xFilial("SB1")+QRYAC->PRODUTO )
			
		cCf	:= Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
		
		If SM0->M0_ESTENT <> cEstado
			cCf := "6"+Substr(cCf,2,3)			
		EndIf	
		
		If !Substr(SA2->A2_CGC,1,8) == "53928891" .Or. Substr(SM0->M0_CGC,1,8) $ GetMv("MV_CNPJCOL")
			
			If Select("TMPSB6") > 0
				DbSelectArea("TMPSB6")	
				DbCloseArea()
			EndIf
			
			cQrySB6	:= " SELECT B6_DOC, B6_SERIE, B6_IDENT, 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,4) ELSE ROUND(B6_PRUNIT,4) END, B6_SALDO "
			cQrySB6 += " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
			cQrySB6 += " WHERE "
			cQrySB6 += " B6_FILIAL = '"+xFilial("SB6")+"' AND "
			cQrySB6 += " B6_PRODUTO = '"+QRYAC->PRODUTO+"' AND "
			cQrySB6 += " B6_CLIFOR = '"+cFornece+"' AND " 
			cQrySB6 += " B6_LOJA = '"+cLoja+"' AND " 			
			cQrySB6 += " B6_PODER3 = 'R' AND "
			cQrySB6 += " B6_ATEND <> 'S' AND "
			cQrySB6 += " B6_TPCF = 'F' AND " 
			cQrySB6 += " B6_SALDO > 0 AND "
			cQrySB6 += " SB6.D_E_L_E_T_ = '' "
			cQrySB6 += " ORDER BY B6_EMISSAO "			
			
			TcQuery cQrySB6 NEW ALIAS "TMPSB6"
				
			DbSelectArea("TMPSB6") 
			TMPSB6->( DbGoTop() )
			If TMPSB6->( !Eof() ) 
		
				_nQtdAux := QRYAC->QTD
			
				While TMPSB6->( !Eof() ) .And. _lFaz 
			
					If _nQtdAux <= TMPSB6->B6_SALDO
						_nQtdBx	:= _nQtdAux
						_lFaz	:= .F.
					Else
						_nQtdBx := TMPSB6->B6_SALDO
						_nQtdAux -= _nQtdBx  
					EndIf 
					
					_cDocB6	:= TMPSB6->B6_DOC		
					_cSerB6	:= TMPSB6->B6_SERIE		
					_cIdeB6	:= TMPSB6->B6_IDENT
					
					_nVlrUnit	:= Round(TMPSB6->PRECO,2)
					_nVlrItem   := Round((_nQtdBx * _nVlrUnit),2) 
					
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
						
						DbSelectArea("SA2")
						SA2->( DbSetOrder(1) )
						DbSeek( xFilial("SA2")+cFornece+cLoja ) 
					
						_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
						{"C5_NUM"		,   _cNumPV					,Nil},;
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
						{"C5_STATUS"	,	'01'						,Nil},;
						{"C5_EMISSAO"	,	dDataBase					,Nil},;
						{"C5_DATA"		,	dDataBase					,Nil},;
						{"C5_HORA"		,	Time()						,Nil},;
						{"C5_MOEDA"		,	1							,Nil},;						
						{"C5_TIPLIB"	,	'1'							,Nil},;
						{"C5_TXMOEDA"	,	1							,Nil},;
						{"C5_TPCARGA"	,	'2'							,Nil},;
						{"C5_VEND1"		,	"000001"					,Nil}}
					   
	    				Aadd(_aPedidos,{_cNumPV,Space(6)})
	    			    
			   		EndIf  
			   		
			   		If SB1->B1_GRUPO $ "0003/0004"
						_cTes := "583" 
					Else
						_cTes := "624" 
					EndIf          
		   												
					_aItemTemp := {{"C6_NUM"	,	_cNumPV				,Nil},;
					{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
					{"C6_ITEM"		,	nItePV							,Nil},;	
				   	{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
					{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
					{"C6_UM"		,	SB1->B1_UM						,Nil},;
					{"C6_QTDVEN"	,	_nQtdBx							,Nil},; 
					{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;	
					{"C6_PRCVEN"	,	_nVlrUnit						,Nil},;
					{"C6_VALOR"		,	_nVlrItem						,Nil},;
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
	   				
		   			_nReg++ 
				   	_nCont++
					nItePV := Soma1(nItePV)
					nItOri := Soma1(nItOri)
					aAdd(_aItemPv,aClone(_aItemTemp))
					
					If _nReg == 99   
						
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
							Replace C6_FILIAL With xFilial("SC6")
							SC6->( MsUnlock() )
					
						Next nX
						
						End Transaction 
						
						_aCabPv		:= {}
						_aItemPv	:= {}
						_cNumPV		:= Space(6)
						_nReg		:= 0
						nItePV		:= "0001"	 
								
					EndIf
					
					TMPSB6->( DbSkip() )
					_lFaz := .T.
							
				EndDo	
		   				   		
			Else
				
				Aadd(_aCompras,{SA2->A2_COD,SA2->A2_LOJA,SB1->B1_COD})			
			
			EndIf	
			
		Else
			
			_nQtdPag	:= QRYAC->QTD
			
			_nVlrUnit	:= Round(SB1->B1_UPRC,2)
			_nVlrItem   := Round((_nQtdPag * _nVlrUnit),2) 
					
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
						
				DbSelectArea("SA2")
				SA2->( DbSetOrder(1) )
				DbSeek( xFilial("SA2")+cFornece+cLoja ) 
					
				_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
				{"C5_NUM"		,   _cNumPV					,Nil},;
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
				{"C5_STATUS"	,	'01'						,Nil},;
				{"C5_EMISSAO"	,	dDataBase					,Nil},;
				{"C5_DATA"		,	dDataBase					,Nil},;
				{"C5_HORA"		,	Time()						,Nil},;
				{"C5_MOEDA"		,	1							,Nil},;						
				{"C5_TIPLIB"	,	'1'							,Nil},;
				{"C5_TXMOEDA"	,	1							,Nil},;
				{"C5_TPCARGA"	,	'2'							,Nil},;
				{"C5_VEND1"		,	"000001"					,Nil}}
					   
	    		Aadd(_aPedidos,{_cNumPV,Space(6)})
	    			    
			EndIf  
			
			If SB1->B1_GRUPO $ "0003/0004"
				_cTes := "525" 
			Else
				_cTes := "526" 
			EndIf          
														
			_aItemTemp := {{"C6_NUM"	,	_cNumPV				,Nil},;
			{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
			{"C6_ITEM"		,	nItePV							,Nil},;	
			{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
			{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
			{"C6_UM"		,	SB1->B1_UM						,Nil},;
			{"C6_QTDVEN"	,	_nQtdPag						,Nil},; 
			{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;	
			{"C6_PRCVEN"	,	_nVlrUnit						,Nil},;
			{"C6_VALOR"		,	_nVlrItem						,Nil},;
			{"C6_TES"		,	_cTes							,Nil},;	
			{"C6_CF"		,	cCf								,Nil},;
			{"C6_LOCAL"		,	SB1->B1_LOCPAD					,Nil},;	
			{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_SITTRIB") ,Nil},;
			{"C6_CLI"		,	SA2->A2_COD		 				,Nil},;
			{"C6_ENTREG"	,	dDataBase						,Nil},;	
			{"C6_LOJA"		,	SA2->A2_LOJA					,Nil},;
		   	{"C6_OP"		,	'02'							,Nil},;
		   	{"C6_TPOP"		,	'F'								,Nil},;
			{"C6_SUGENTR"	,	dDataBase						,Nil}}
	   				
		   	_nReg++ 
			_nCont++
			nItePV := Soma1(nItePV)
			nItOri := Soma1(nItOri)
			aAdd(_aItemPv,aClone(_aItemTemp))
					
			If _nReg == 99   
						
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
					Replace C6_FILIAL With xFilial("SC6")
					SC6->( MsUnlock() )
					
				Next nX
						
				End Transaction 
						
				_aCabPv		:= {}
				_aItemPv	:= {}
				_cNumPV		:= Space(6)
				_nReg		:= 0
				nItePV		:= "0001"	 
								
			EndIf
					
		EndIf	
		                                                                                                                      
		QRYAC->( DbSkip() )
				
	EndDo
	
EndIf	
		
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
		Replace C6_FILIAL With xFilial("SC6")
			
		SC6->( MsUnlock() )
	Next nX	 
		
	End Transaction 
		 	
	aCabPC		:= {}
	aItemPC		:= {}
	_aCabPv		:= {}
	_aItemPv	:= {}
	_cNumPV		:= Space(6)
	_cNumPC		:= Space(6)
	_nReg		:= 0
	nItePV		:= "0001"	 
	nItePC		:= "0001"		
						
EndIf 
	
For _nI := 1 To Len(_aPedidos)
	LibPed(_aPedidos[_nI,1])
Next _nI

If _nCont > 0
	
	DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,250 TITLE "Pedido" PIXEL
			
	@ 10,8 LISTBOX oLbx FIELDS HEADER "Pedido de Venda" SIZE 100,80 NOSCROLL OF oDlgPC PIXEL
			
	oLbx:SetArray(_aPedidos)
	oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1]}}
		
	@ 100,065 BUTTON "Ok"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End())
			
	ACTIVATE MSDIALOG oDlgPC CENTERED
	
Else     
	MsgStop("Nao existem registros para processamento!")
	oDlgPC:End()	
EndIf
	
RestArea(_aArea)
		
Return    

Static Function LibPed(cNumPed)

Local aArea		:= GetArea()
Local nX		:= 0
Local lLiberOk  := .T.
Local lCredito  := .F.
Local lEstoque  := .F.
Local lLiber    := .T.
Local lTransf   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no SC5 e SC6                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	DbSetOrder(1)
	If  DbSeek(xFilial()+cNumPed)
		While SC6->(!Eof()) .and. SC6->C6_NUM==cNumPed
			MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,@lCredito,@lEstoque,.T.,.T.,lLiber,lTransf)
			a450Grava(1,.T.,.T.)
			SC6->(dbskip())
		EndDo	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza do C5_LIBEROK e C5_STATUS                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	MsUnlock()
	
EndIf

RestArea(aArea)

Return()

Static Function GerComp()

Local nTotRec	:= 0
Local _nVlrUnit	:= 0 
Local _nVlrItem := 0
Local _nReg		:= 0 
Local _nPrUnit	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0

Local _lFaz		:= .T.
	
Local nItePV	:= "0001"  
Local nItOri	:= "0001"
Local _cTes		:= "600"

Local _aCabPv		:= {}
Local _aItemTemp	:= {}  
Local _aItemPv		:= {}

For _nI := 1 To Len(_aCompras)

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
						
		DbSelectArea("SA2")
		SA2->( DbSetOrder(1) )
		DbSeek( xFilial("SA2")+cFornece+cLoja ) 
					
		_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
		{"C5_NUM"		,   _cNumPV					,Nil},;
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
		{"C5_STATUS"	,	'01'						,Nil},;
		{"C5_EMISSAO"	,	dDataBase					,Nil},;
		{"C5_DATA"		,	dDataBase					,Nil},;
		{"C5_HORA"		,	Time()						,Nil},;
		{"C5_MOEDA"		,	1							,Nil},;						
		{"C5_TIPLIB"	,	'1'							,Nil},;
		{"C5_TXMOEDA"	,	1							,Nil},;
		{"C5_TPCARGA"	,	'2'							,Nil},;
		{"C5_VEND1"		,	"000001"					,Nil}}
					   
		Aadd(_aPedidos,{_cNumPV,Space(6)})
	    			    
	EndIf  
	
	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	DbSeek( xFilial("SB1")+QRYAC->PRODUTO )
			
	cCf	:= Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
		
	If SM0->M0_ESTENT <> cEstado
		cCf := "6"+Substr(cCf,2,3)			
	EndIf	
			
	If SB1->B1_GRUPO $ "0003/0004"
		_cTes := "521" 
	Else
		_cTes := "522" 
	EndIf          
														
	_aItemTemp := {{"C6_NUM"	,	_cNumPV				,Nil},;
	{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
	{"C6_ITEM"		,	nItePV							,Nil},;	
	{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
	{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
	{"C6_UM"		,	SB1->B1_UM						,Nil},;
	{"C6_QTDVEN"	,	_nQtdBx							,Nil},; 
	{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;	
	{"C6_PRCVEN"	,	_nVlrUnit						,Nil},;
	{"C6_VALOR"		,	_nVlrItem						,Nil},;
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
	{"C6_NFORI "	,	"1" 	     					,Nil}}
	   				
	_nReg++ 
	_nCont++
	nItePV := Soma1(nItePV)
	nItOri := Soma1(nItOri)
	aAdd(_aItemPv,aClone(_aItemTemp))
					
	If _nReg == 99   
						
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
			Replace C6_FILIAL With xFilial("SC6")
			SC6->( MsUnlock() )
					
		Next nX
						
		End Transaction 
						
		_aCabPv		:= {}
		_aItemPv	:= {}
		_cNumPV		:= Space(6)
		_nReg		:= 0
		nItePV		:= "0001"	 
								
	EndIf
					
Next _nI

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
		Replace C6_FILIAL With xFilial("SC6")
		SC6->( MsUnlock() )
					
	Next nX
						
	End Transaction 
						
	_aCabPv		:= {}
	_aItemPv	:= {}
	_cNumPV		:= Space(6)
	_nReg		:= 0
	nItePV		:= "0001"	 
								
EndIf
	
Return