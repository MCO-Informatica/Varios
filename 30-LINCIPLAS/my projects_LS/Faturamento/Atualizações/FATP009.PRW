#INCLUDE "PROTHEUS.CH"   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP009   º Autor ³ Antonio Carlos     º Data ³  02/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo processamento dos itens em Acerto  º±±
±±º          ³ de Consignacao para Pedidos Venda/Compra.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP009()

Local cAcerto	:= SZA->ZA_NUMFEC

If SZA->ZA_STATUS == "P"
	Aviso("Acerto de Consignacao","Fechamento já processado!",{"Ok"})			
	Return(.F.)
EndIf	

LjMsgRun("Aguarde..., Gerando Pedidos de Vendas/Compras...",, {|| GeraPC(cAcerto) }) 

Return

Static Function GeraPC(cNumAc)

Local _aArea	:= GetArea() 

Local _nVlrUnit	:= 0
Local _nVlrTot	:= 0 
Local _nReg		:= 0 
Local _nCont	:= 0
Local _nQtdCon	:= 0
Local _nPrUnit	:= 0
Local _nVlrCon	:= 0
Local _nSldSB6	:= 0
Local _nVlrSB6	:= 0
Local _nSldSB2	:= 0
Local _nVlrSB2	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0
Local _nVlrPag	:= 0  

Local _lFaz		:= .T.
	
Local nItens	:= "0001"  
Local nItOri	:= "0001"
//Local _cTes		:= GetMv("MV_TESCCO")
Local _cTes		:= "599"
Local cNumAc	:= SZA->ZA_NUMFEC
Local _cNumPed 	:=  Space(6)

Local _aCabPv		:= {}
Local _aItemPv		:= {}
Local _aItemTemp	:= {}  
Local _aPedidos		:= {}
Local _cUser		:= RetCodUsr()

Private oDlgPC		
Private lMsErroAuto := .F.     

cQuery := " SELECT ZA_NUMFEC, ZA_FORNECE, ZA_LOJAFOR, ZB_PRODUTO, ZB_PRUNIT, SUM(ZB_SLDSB6) AS SLDSB6, ZB_SLDSB2, B1_LOCPAD "
cQuery += " FROM "+RetSqlName("SZA")+" SZA (NOLOCK)"
cQuery += " INNER JOIN "+RetSqlName("SZB")+" SZB (NOLOCK)"
cQuery += " ON ZA_FILIAL = ZB_FILIAL AND ZA_NUMFEC = ZB_NUMFEC AND SZB.D_E_L_E_T_ = '' " 
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK)"
cQuery += " ON ZB_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += " ZA_FILIAL = '"+xFilial("SZA")+"' AND "
cQuery += " ZA_NUMFEC = '"+cNumAc+"' AND "
cQuery += " ZA_STATUS = 'A' AND "
cQuery += " SZA.D_E_L_E_T_ = '' "
cQuery += " GROUP BY ZA_NUMFEC, ZA_FORNECE, ZA_LOJAFOR, ZB_PRODUTO, ZB_PRUNIT, ZB_SLDSB2, B1_LOCPAD "
cQuery += " ORDER BY ZA_NUMFEC "

memowrite("FATP004.SQL",cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TMP", .F., .T.)   

Begin Transaction

DbSelectArea("TMP") 
TMP->(DbGoTop())
If TMP->(!Eof())
	While !TMP->(Eof()) 
		
		cFornece	:= TMP->ZA_FORNECE
		cLoja		:= TMP->ZA_LOJAFOR
		_cNumPro	:= TMP->ZA_NUMFEC
		_cProduto	:= TMP->ZB_PRODUTO
		_cNumPed	:= Space(6)
		
		While !TMP->(Eof()) .And. TMP->ZA_NUMFEC == _cNumPro
				
			If Empty(_cNumPed)
	    	
		    	_cNumPed := GetSxeNum("SC5","C5_NUM")
				While .T.
					DbSelectArea("SC5")
					DbSetOrder(1)
					If DbSeek(xFilial("SC5")+_cNumPed)
						ConfirmSX8()
						_cNumPed := GetSxeNum("SC5","C5_NUM")
						Loop
					Else
						Exit
					EndIf
				EndDo	
						
				DbSelectArea("SA2")
				SA2->( DbSetOrder(1) )
				DbSeek( xFilial("SA2")+cFornece+cLoja ) 
				
				_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
				{"C5_NUM"		,   _cNumPed					,Nil},;
				{"C5_TIPO"		,   'B'							,Nil},;
				{"C5_CLIENTE"	,	SA2->A2_COD					,Nil},;
				{"C5_LOJACLI"	,	SA2->A2_LOJA				,Nil},;
				{"C5_TIPOCLI"	,	"R"							,Nil},;
				{"C5_TRANSP"	,	"000001"					,Nil},;
				{"C5_TPFRETE"	,	'F'							,Nil},;
				{"C5_MOEDA"		,	1							,Nil},;
				{"C5_CONDPAG"	,	SA2->A2_COND				,Nil},;
				{"C5_STATUS"	,	'01'						,Nil},;
				{"C5_EMISSAO"	,	dDataBase					,Nil},;
				{"C5_DATA"		,	dDataBase					,Nil},;
				{"C5_HORA"		,	Time()						,Nil},;
				{"C5_VEND1"		,	"000001"					,Nil}}   
				
				
	    
		        Aadd(_aPedidos,{_cNumPed})
	    
		    EndIf
			
			While _cProduto == TMP->ZB_PRODUTO
			
				_nSldSB6	+=  Round(TMP->SLDSB6,2)	 
				_nSldSB2		:=	Round(TMP->ZB_SLDSB2,2)	 
							
				TMP->(DbSkip())
			
			EndDo
			
			_nQtdPag := _nSldSB6 - _nSldSB2	          
			
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) )
			DbSeek( xFilial("SB1")+_cProduto )
			
			If Select("TMPSB6") > 0
				DbSelectArea("TMPSB6")	
				DbCloseArea()
			EndIf
			
			
			cQuery1 := " SELECT B6_DOC, B6_SERIE, B6_IDENT, B6_PRUNIT, B6_SALDO "
			cQuery1 += " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
			cQuery1 += " WHERE "
			cQuery1 += " B6_FILIAL = '"+xFilial("SB6")+"' AND "
			cQuery1 += " B6_PRODUTO = '"+_cProduto+"' AND "
			cQuery1 += " B6_CLIFOR = '"+cFornece+"' AND " 
			cQuery1 += " B6_LOJA = '"+cLoja+"' AND " 			
			cQuery1 += " B6_PODER3 = 'R' AND B6_SALDO > 0 AND "
			cQuery1 += " SB6.D_E_L_E_T_ = '' "

			dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery1), "TMPSB6", .F., .T.) 
			
			DbSelectArea("TMPSB6") 
			TMPSB6->(DbGoTop())
			If TMPSB6->(!Eof()) 
				_nQtdAux := _nQtdPag
				While !TMPSB6->(Eof()) .And. _lFaz 
			
					If _nQtdAux <= TMPSB6->B6_SALDO
						_nQtdBx	:= _nQtdAux
						_lFaz	:= .F.
						_lInclui := .T.		
					Else
						_nQtdBx := TMPSB6->B6_SALDO
						_nQtdAux -= _nQtdBx  
					EndIf 
					
					_cDocB6	:= TMPSB6->B6_DOC		
					_cSerB6	:= TMPSB6->B6_SERIE		
					_cIdeB6	:= TMPSB6->B6_IDENT
					
					_nVlrUnit	:= Round(TMPSB6->B6_PRUNIT,2)
					_nVlrItem   := Round((_nQtdBx * _nVlrUnit),2) 
					
					If Empty(_cNumPed)
	    	
					   	_cNumPed := GetSxeNum("SC5","C5_NUM")
						While .T.
							DbSelectArea("SC5")
							DbSetOrder(1)
							If DbSeek(xFilial("SC5")+_cNumPed)
								ConfirmSX8()
								_cNumPed := GetSxeNum("SC5","C5_NUM")
								Loop
							Else
								Exit
							EndIf
						EndDo	
						
						DbSelectArea("SA2")
						SA2->( DbSetOrder(1) )
						DbSeek( xFilial("SA2")+cFornece+cLoja ) 
					
						_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
						{"C5_NUM"		,   _cNumPed					,Nil},;
						{"C5_TIPO"		,   'B'							,Nil},;
						{"C5_CLIENTE"	,	SA2->A2_COD					,Nil},;
						{"C5_LOJACLI"	,	SA2->A2_LOJA				,Nil},;
						{"C5_TIPOCLI"	,	"R"							,Nil},;
						{"C5_TRANSP"	,	"000001"					,Nil},;
						{"C5_TPFRETE"	,	'F'							,Nil},;
						{"C5_MOEDA"		,	1							,Nil},;
						{"C5_CONDPAG"	,	SA2->A2_COND				,Nil},;
						{"C5_STATUS"	,	'01'						,Nil},;
						{"C5_EMISSAO"	,	dDataBase					,Nil},;
						{"C5_DATA"		,	dDataBase					,Nil},;
						{"C5_HORA"		,	Time()						,Nil},;
						{"C5_VEND1"		,	"000001"					,Nil}}
	    				    
	    			    Aadd(_aPedidos,{_cNumPed})
	    				    
		   			 EndIf
					
									
					_aItemTemp := {{"C6_NUM"	,	_cNumPed			,Nil},;
					{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
					{"C6_ITEM"		,	nItens							,Nil},;	
			   		{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
					{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
					{"C6_UM"		,	SB1->B1_UM						,Nil},;
				   	{"C6_QTDVEN"	,	_nQtdBx							,Nil},; 
					{"C6_QTDEMP"	,	_nQtdBx							,Nil},;	 
		   			{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;	
					{"C6_PRCVEN"	,	_nVlrUnit						,Nil},;
					{"C6_VALOR"		,	_nVlrItem						,Nil},;
					{"C6_TES"		,	_cTes							,Nil},;	
					{"C6_CF"		,	Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_CF")		,Nil},;
					{"C6_LOCAL"		,	SD1->D1_LOCAL											,Nil},;	
				   	{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_SITTRIB") ,Nil},;
					{"C6_CLI"		,	SA2->A2_COD		 				,Nil},;
					{"C6_ENTREG"	,	dDataBase						,Nil},;	
		   			{"C6_LOJA"		,	SA2->A2_LOJA					,Nil},;
					{"C6_NFORI "	,	_cDocB6      					,Nil},;
		   			{"C6_SERIORI "	,	_cSerB6        					,Nil},;
					{"C6_ITEMORI "	,	nItOri         					,Nil},;
	   				{"C6_IDENTB6 "	,	_cIdeB6				 			,Nil}}
   	        	
			   		_nReg++ 
			   		_nCont++
					nItens := Soma1(nItens)
					nItOri := Soma1(nItOri)
					aAdd(_aItemPv,aClone(_aItemTemp))
					
					If _nReg == 1
					
						MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
						If lMsErroAuto
							MostraErro()
							If ( __lSX8)
								RollBackSX8()
							EndIf
							DisarmTransaction()
						Else		
							If ( __lSX8)
								ConfirmSX8()
							EndIf 
							
							_aCabPv		:= {}
							_aItemPv	:= {}
							_cNumPed	:= Space(6)
							_nReg		:= 0
							nItens		:= "0001"	 
							nItOri		:= "0001"		
						EndIf 
					
					EndIf   
						
					TMPSB6->(DbSkip())
							
		   		EndDo	
		   				   		
		   	EndIf	
				

			
			_cProduto	:= TMP->ZB_PRODUTO
			_nQtdPag	:= 0
			_nSldSB6	:= 0
			_nSldSB2	:= 0	
			_lFaz		:= .T.	
				
		EndDo	
			
	EndDo
		
	If _nReg > 0
		MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
		If lMsErroAuto
			MostraErro()
			If ( __lSX8)
				RollBackSX8()
			EndIf
			DisarmTransaction()
		Else		
			If ( __lSX8)
				ConfirmSX8()
			EndIf   
			_nCont
		EndIf 
	EndIf		
		
	If !lMsErroAuto
		DbSelectArea("SZA")
		SZA->(DbSetOrder(1))
		DbSeek(xFilial("SZA")+_cNumPro)
		RecLock("SZA",.F.)
		Replace SZA->ZA_STATUS With "P"
		MsUnLock()	
			                                                                                       
		If _nCont > 0
				                                                                                                
			DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,230 TITLE "Pedidos de Venda" PIXEL
			
			@ 10,8 LISTBOX oLbx FIELDS HEADER "Nr. Pedido" SIZE 100,80 NOSCROLL OF oDlgPC PIXEL
			
			oLbx:SetArray(_aPedidos)
			oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1]}}

			@ 100,065 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End()) 
    		
			ACTIVATE MSDIALOG oDlgPC CENTERED
							
	   	Else
	   	
	   		MsgStop("Foram encontrados erros durante o processamnto!!!")	
	   	
	   	EndIf	
	   	
	EndIf	   	
		
Else
		
		Aviso("Acerto de Consignacao","Nao ha registros para processamento!",{"Ok"})			

EndIf
	
End Transaction

DbSelectArea("TMP")
DbCloseArea()  

RestArea(_aArea)
		
Return  