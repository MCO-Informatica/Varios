#INCLUDE "PROTHEUS.CH"   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP004   º Autor ³ Antonio Carlos     º Data ³  07/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo processamento dos itens para Acertoº±±
±±º          ³ de Consignacao em Pedido de Compra.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP004()

Local cAcerto	:= SZA->ZA_NUMFEC

If SZA->ZA_STATUS == "P"
	Aviso("Acerto de Consignacao","Fechamento já processado!",{"Ok"})			
	Return(.F.)
EndIf	

LjMsgRun("Aguarde..., Gerando pedidos de compra...",, {|| GeraPC(cAcerto) }) 

Return

Static Function GeraPC(cNumAc)

Local _aArea		:= GetArea()

Local _nVlrUnit		:= 0
Local _nVlrTot		:= 0 
Local _nReg			:= 0 
Local _nCont		:= 0
Local _nQtdCon		:= 0
Local _nPrUnit		:= 0
Local _nVlrCon		:= 0
Local _nSldSB6		:= 0
Local _nVlrSB6		:= 0
Local _nSldSB2		:= 0
Local _nVlrSB2		:= 0
Local _nQtdPag		:= 0
Local _nVlrPag		:= 0   

Local _cProduto
	
Local _cTes		
Local nItens		:= "0001" 
Local cNumAc		:= SZA->ZA_NUMFEC
Local _cNumPed 		:=  Space(6)

Local aCabec		:= {}
Local aItens		:= {}
Local _aItemTemp	:= {}  
Local _aPedidos		:= {}
Local _cUser		:= RetCodUsr()
Local _aArea		:= GetArea() 

Private oDlgPC		
Private lMsErroAuto := .F.     

cQuery := " SELECT ZA_NUMFEC, ZA_FORNECE, ZA_LOJAFOR, ZB_PRODUTO, ZB_PRUNIT, SUM(ZB_SLDSB6) AS SLDSB6, ZB_SLDSB2, B1_LOCPAD "
cQuery += " FROM " + RetSqlName('SZA') + " SZA (NOLOCK) "

cQuery += " INNER JOIN " + RetSqlName('SZB') + " SZB (NOLOCK) ""
cQuery += " ON ZA_FILIAL = ZB_FILIAL AND ZA_NUMFEC = ZB_NUMFEC AND SZB.D_E_L_E_T_ = '' " 

cQuery += " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK) "
cQuery += " ON ZB_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "

cQuery += " WHERE "
cQuery += " ZA_FILIAL 		= '"+xFilial("SZA")+"' AND "
cQuery += " ZA_NUMFEC 		= '"+cNumAc+"' AND "
cQuery += " ZA_STATUS 		= 'A' AND " 
cQuery += " SZA.D_E_L_E_T_ 	= '' "
cQuery += " GROUP BY ZA_NUMFEC, ZA_FORNECE, ZA_LOJAFOR, ZB_PRODUTO, ZB_PRUNIT, ZB_SLDSB2, B1_LOCPAD "
cQuery += " ORDER BY ZA_NUMFEC "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TMP", .F., .T.)   

Begin Transaction

DbSelectArea("TMP") 
TMP->(DbGoTop())
If !Eof()
	While !TMP->(Eof()) 
		
		cFornece	:= TMP->ZA_FORNECE
		cLoja		:= TMP->ZA_LOJAFOR
		_cNumPro	:= TMP->ZA_NUMFEC
		_cNumPed	:= Space(6)
		_cProduto	:= TMP->ZB_PRODUTO
		
		
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+TMP->ZA_FORNECE+TMP->ZA_LOJAFOR) 
		
		//While !TMP->(Eof()) .And. TMP->ZA_FORNECE+TMP->ZA_LOJAFOR == cFornece+cLoja
		While !TMP->(Eof()) .And. TMP->ZA_NUMFEC == _cNumPro

			While _cProduto == TMP->ZB_PRODUTO
			
				_nSldSB2 	:= TMP->ZB_SLDSB2 
				_nSldSB6 	+= TMP->SLDSB6 
				
				_nPrUnit	:=	Round(TMP->ZB_PRUNIT,4)	 
			
				TMP->(DbSkip())  
			
			EndDo
			
			_nQtdPag := _nSldSB6 - _nSldSB2
				
			//If !SA2->A2_CGC $ GetMv("MV_LSVCNPJ")
				If Empty(_cNumPed)
					_cNumPed := GetSxeNum("SC7","C7_NUM")
					While .T.
						DbSelectArea("SC7")
						DbSetOrder(1)
						If DbSeek(xFilial("SC7")+_cNumPed)
							ConfirmSX8()
							_cNumPed := GetSxeNum("SC7","C7_NUM")
							Loop
						Else
							Exit
						EndIf
					EndDo
					Aadd(_aPedidos,{_cNumPed})
					
					aAdd(aCabec,{"C7_NUM"		,_cNumPed				,Nil})		//Numero do Pedido
			   		aAdd(aCabec,{"C7_EMISSAO"	,dDataBase				,Nil})		//Data de Emissao
					aAdd(aCabec,{"C7_FORNECE"	,SA2->A2_COD			,Nil})  	//Fornecedor
					aAdd(aCabec,{"C7_LOJA"		,SA2->A2_LOJA			,Nil})      //Loja do Fornecedor
					aAdd(aCabec,{"C7_CONTATO"	,"LASELVA"				,Nil})		//Contato
					aAdd(aCabec,{"C7_COND"		,SA2->A2_COND			,Nil})      //Condicao de Pagamento
					aAdd(aCabec,{"C7_FILENT"	,Substr(cNumEmp,3,2)	,Nil}) 		//Filial de Entrega       	  		  	
				
				EndIf
						
			If SA2->A2_CGC $ "53928891000107"
				cFil := "01"
			ElseIf SA2->A2_CGC $ "53928891004366"	
				cFil := "81"
			EndIf	
							
			//_nPrUnit	:=	Round(TMP->ZB_PRUNIT,4)	 
			//_nQtdPag	:=	Round(TMP->QTDPAG,4)	 
			
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) ) 
			//If SB1->( DbSeek(xFilial("SB1")+TMP->ZB_PRODUTO) )
			If SB1->( DbSeek(xFilial("SB1")+_cProduto) )
				If SB1->B1_GRUPO $ GetMv("MV_GRPLIVR")
					_cTes := GetMv("MV_TESCCOL")
				ElseIf SB1->B1_GRUPO $ GetMv("MV_GRPREVI")
					_cTes := GetMv("MV_TESCCOR")					 	
				Else 
					_cTes := SB1->B1_TE
				EndIf	
			EndIf       
			
			aLinha	:= {}	
				
			aAdd(aLinha,{"C7_ITEM"		,nItens						,NIL})     	//Item
			//aAdd(aLinha,{"C7_PRODUTO"	,TMP->ZB_PRODUTO			,NIL})     	//Produto
			aAdd(aLinha,{"C7_PRODUTO"	,_cProduto					,NIL})     	//Produto
			aAdd(aLinha,{"C7_QUANT"		,_nQtdPag					,NIL})     	//Quantidade
			aAdd(aLinha,{"C7_PRECO"		,_nPrUnit					,NIL})     	//Preco unitario
			aAdd(aLinha,{"C7_TES"		,_cTes						,Nil})     	//Sequencia MRP
			aAdd(aLinha,{"C7_TPOP"		,"F"						,NIL})     	//Tipo de OP
			aAdd(aLinha,{"C7_NUMFEC"	,_cNumPro					,Nil}) 		//Nr.do Acerto de Consignacao		
			aAdd(aLinha,{"C7_OBS"		,"PED.REF.ACERTO: "+_cNumPro,Nil}) 		//Nr.do Acerto de Consignacao		
							
			nItens := Soma1(nItens)
			aAdd(aItens,aLinha)
			_nReg++
			_nCont++
			
			If _nReg == 9999
				If Empty(_cNumPed)
					MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3) 
				Else
					MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,aCabec,aItens,3,.F.)
				EndIf	
			
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
				EndIf	
			
				If SA2->A2_CGC $ GetMv("MV_LSVCNPJ")
					LsvSB6Ori(_cNumPed,"LSV",cFil,cFornece,cLoja) 							
				EndIf 
				
				nItens		:= "0001" 
				aCabec		:= {}
				aItens		:= {}
				_nReg		:= 0
				_cNumPed	:= Space(6)
							
			EndIf 
			
			_cProduto	:= TMP->ZB_PRODUTO
			_nSldSB2 := 0
			_nSldSB6 := 0   
			_nQtdPag := 0
			
			//TMP->(DbSkip())
			
		EndDo	
		
		If _nReg > 0
			If Empty(_cNumPed)
				MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3) 
			Else
				MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,aCabec,aItens,3,.F.)
			EndIf	
			
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
			
				If SA2->A2_CGC $ GetMv("MV_LSVCNPJ")
					LsvSB6Ori(_cNumPed,"LSV",cFil,cFornece,cLoja) 							
				EndIf 
			EndIf		
		EndIf		 			
		
		nItens		:= "0001"
		aCabec		:= {}
		aItens		:= {}
		_nReg		:= 0
		
	EndDo
		
		If !lMsErroAuto
			DbSelectArea("SZA")
			SZA->(DbSetOrder(1))
			DbSeek(xFilial("SZA")+_cNumPro)
			RecLock("SZA",.F.)
			Replace SZA->ZA_STATUS With "P"
			MsUnLock()	
			
			If _nCont > 0
				
				If !Empty(_cNUmPed)
				
					DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,230 TITLE "Pedidos de Compra" PIXEL
			
					@ 10,8 LISTBOX oLbx FIELDS HEADER "Nr. Pedido" SIZE 100,80 NOSCROLL OF oDlgPC PIXEL
			
					oLbx:SetArray(_aPedidos)
					oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1]}}

					@ 100,065 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End()) 
    		
					ACTIVATE MSDIALOG oDlgPC CENTERED
				
				Else 
					
					Aviso("Acerto de Consignacao","NF de Entrada: '"+_cNumPro+"'!",{"Ok"})					
							
				EndIf
						
				
			EndIf	
	   	Else
	   		MsgStop("Foram encontrados erros durante o processamnto!!!")	
	   	EndIf	
		
Else
		Aviso("Acerto de Consignacao","Nao ha registros para processamento!",{"Ok"})			

EndIf
	
End Transaction

DbSelectArea("TMP")
DbCloseArea()  

RestArea(_aArea)
		
Return  

Static Function LsvSB6Ori(_cDoc,_cSerie,_cFil,_cFornece,_cLoja)

Local aArea			:= GetArea()
Local _cNumPed		:= Space(6) 
Local nItens		:= "0001"
Local nItOri		:= "0001"
Local _lFaz			:= .T.
Local _nQtdBx		:= 0
Local _nQtdSD1		:= 0
Local _nReg			:= 0
Local _nVlrUnit		:= 0
Local _nVlrItem		:= 0  
Local _cTes			:= GetMv("MV_TESDSC")
Local _aCabPv		:= {}
Local _aItemPv		:= {}
Local _aItemTemp	:= {} 
Local _cCGC			:= SM0->M0_CGC

Local nHdl			:= 0													// Handle do arquivo de log de erros
Local cEOL			:= ""													// Variavel para caractere de CR + LF
Local _cLinha		:= ""													// Conteudo da Linha a ser gravada
Local _lRet			:= 0
//Local _cReferArq	:= "ACERTO_"+SM0->M0_FILIAL+"_"+DToS(dDataBase)+"_"+STRTRAN(TIME(),':','_')
Local _cReferArq	:= "ACERTO_"+SM0->M0_FILIAL+"_"+DToS(dDataBase)
Local cDir			:= IIf(_cFil == "81",GetMv("MV_LSVCONS")+"\81\",GetMv("MV_LSVCONS")+"\01\")

Private lMsErroAuto := .F.    		

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
EndIf

If File(cDir+_cReferArq+".txt")
	Ferase(_cReferArq)								// Elimina arquivo, caso exista
Endif

nHdl := fCreate(cDir+_cReferArq+".txt")				// Cria arquivo txt de log de erros

If nHdl == -1										// Erro na criacao do arquivo
	MsgAlert("O arquivo de nome " + _cReferArq + " nao pode ser criado!","Atencao!")
EndIf

DbSelectArea("SC7")
SC7->(DbSetOrder(1)) 
If DbSeek(xFilial("SC7")+_cDoc)
	While !Eof() .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_FORNECE == _cFornece .And. SC7->C7_LOJA == _cLoja .And. SC7->C7_NUM == _cDoc 
		
		If _nReg == 0	 
	    	//DbSelectArea("SA1")
			//DbSetOrder(9)
			//DbSeek(xFilial("SA1")+SM0->M0_CGC+SM0->M0_CODFIL) 
			
			_cLinha	:= "1"+SM0->M0_CGC+SM0->M0_CODFIL+SM0->M0_FILIAL+DTOC(dDatabase)
			_cLinha	+= cEOL
			fWrite(nHdl,_cLinha,Len(_cLinha))
	    EndIf	
	    
		_nReg++
		
		_cLinha := ""
		_cLinha += "2"+SC7->C7_ITEM+SC7->C7_PRODUTO+StrZero(SC7->C7_QUANT*100,14)+StrZero(SC7->C7_PRECO*100,14)
		_cLinha	+= cEOL
		fWrite(nHdl,_cLinha,Len(_cLinha))
	
		SC7->(DbSkip()) 
		
	EndDo	
EndIf		
		
	If _nReg > 0
		_cLinha := "3"
		_cLinha	+= cEOL
		fWrite(nHdl,_cLinha,Len(_cLinha))
	EndIf

FClose(nHdl)

RestArea(aArea)
	
	
/*
DbSelectArea("SD1")
DbSetOrder(1)
If DbSeek(xFilial("SD1")+_cDoc+_cSerie+_cFornece+_cLoja)
	While !Eof() .And. SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DOC == _cDoc .And. SD1->D1_SERIE == _cSerie .And.;
	SD1->D1_FORNECE == _cFornece .And. SD1->D1_LOJA == _cLoja
	
		If !SD1->D1_TES $ GetMv("MV_TESCCO")
			SD1->(DbSkip())
			Loop
		EndIf
	
	    If _nReg == 0	 
	    				
			DbSelectArea("SA1")
			DbSetOrder(3)
			DbSeek(xFilial("SA1")+_cCGC) 
			
			_cLinha	:= "1"+_cCGC+DTOC(dDatabase)
			_cLinha	+= cEOL
			fWrite(nHdl,_cLinha,Len(_cLinha))
	    EndIf
		
		DbSelectArea("SB1")
		DbSetOrder(1)                                                              
		DbSeek(xFilial("SB1") + SD1->D1_COD)
		
			DbSelectArea("SB6")
			DbSetOrder(1)
			If DbSeek(_cFil+SD1->D1_COD+SA1->A1_COD+SA1->A1_LOJA)
				_nQtdSD1 := SD1->D1_QUANT			
					While !Eof() .And. SB6->B6_FILIAL+SB6->B6_PRODUTO+SB6->B6_CLIFOR+SB6->B6_LOJA ==  _cFil+SD1->D1_COD+SA1->A1_COD+SA1->a1_LOJA .And. _lFaz
				
					If _nQtdSD1 <= SB6->B6_SALDO
						_nQtdBx	:= _nQtdSD1
						_lFaz	:= .F.
						_lInclui := .T.		
					Else
						_nQtdBx := SB6->B6_SALDO
						_nQtdSD1 -= _nQtdBx  
					EndIf 
				
					_cDocB6	:= SB6->B6_DOC		
					_cSerB6	:= SB6->B6_SERIE		
					_cIdeB6	:= SB6->B6_IDENT
					
					_nVlrUnit	:= Round(SD1->D1_VUNIT,2)
			
					_nVlrItem   := Round((_nQtdBx * SD1->D1_VUNIT),2)
				
			   		_nReg++
				   	nItOri := Soma1(nItOri)
					aAdd(_aItemPv,aClone(_aItemTemp))
					
					_cLinha := ""
					_cLinha += "2"+nItens+SD1->D1_COD+StrZero(_nQtdBx*100,9)+StrZero(_nVlrUnit*100,11)
					_cLinha	+= cEOL
					fWrite(nHdl,_cLinha,Len(_cLinha))
					
					nItens := Soma1(nItens)
				
					SB6->(DbSkip())
				EndDo	
			EndIf	
		 SD1->(DbSkip())
		 _nQtdBx	:= 0
		_nQtdSD1	:= 0	
		_lFaz		:= .T.
	EndDo		
EndIf	
*/

Return