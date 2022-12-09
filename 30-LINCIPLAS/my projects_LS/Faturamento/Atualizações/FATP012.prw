#INCLUDE "PROTHEUS.CH"   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP012   º Autor ³ Antonio Carlos     º Data ³  02/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                                     
±±ºDescricao ³ Rotina responsavel pelo processamento dos itens em Acerto  º±±
±±º          ³ de Consignacao para Pedidos Venda/Compra.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP012()

Local cAcerto	:= SZD->ZD_NUMAC
Local cLaselva	:= SZD->ZD_CODIGO
Local cLojLsv	:= SZD->ZD_LOJA

If SZD->ZD_STATUS == "P"
	Aviso("Acerto de Consignacao","Fechamento já processado!",{"Ok"})			
	Return(.F.)
EndIf	

LjMsgRun("Aguarde..., Gerando Pedidos de Vendas...",, {|| GeraPV(cAcerto,cLaselva,cLojLsv) }) 

Return

Static Function GeraPV(cNumAc,cMLSV,cLSV)

Local _aArea	:= GetArea() 

Local _nVlrItem := 0
Local _nReg		:= 0 
Local _nCont	:= 0
Local _nPrUnit	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0  

Local _nPerDesc := 0 
Local nDesc		:= 0
Local nPreco	:= 0
	
Local nItePV	:= "0001"  
Local _cTes		
Local _cNumPV 	:=  Space(6)

Local _aCabPv		:= {}
Local _aItemTemp	:= {}  
Local _aItemPv		:= {}
Local _aPedidos		:= {}

Local _cUser		:= RetCodUsr()

Private oDlgPC
Private _cNumSZD	:= cNumAc	
Private _cNLaselva	:= cMLSV
Private _cNLoja		:= cLSV
Private lMsErroAuto := .F.     

cQrySZE := " SELECT * "
cQrySZE += " FROM "+RetSqlName("SZE")+ " SZE (NOLOCK)"
cQrySZE += " INNER JOIN "+RetSqlName("SB1")+ " SB1 (NOLOCK)" 
cQrySZE += " ON ZE_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' 
cQrySZE += " INNER JOIN "+RetSqlName("SZD")+ " SZD (NOLOCK)" 
cQrySZE += " ON ZE_FILIAL = ZD_FILIAL AND ZE_NUMAC = ZD_NUMAC AND ZE_CODIGO = ZD_CODIGO AND ZE_LOJA = ZD_LOJA AND SZD.D_E_L_E_T_ = '' 
cQrySZE += " WHERE 
cQrySZE += " ZE_FILIAL 		= '"+ xFilial("SZE") +"' AND 
cQrySZE += " ZE_NUMAC 		= '"+ _cNumSZD +"' AND 
cQrySZE += " ZE_CODIGO 		= '"+ _cNLaselva +"' AND 
cQrySZE += " ZE_LOJA 		= '"+ _cNLoja +"' AND 
//cQrySZE += " ZE_PRODUTO 	= '594200' AND 
cQrySZE += " ZD_STATUS 		= 'A' AND 
cQrySZE += " SZE.D_E_L_E_T_ = '' 

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQrySZE), "TMPSZE", .F., .T.)    

//Begin Transaction

DbSelectArea("TMPSZE") 
TMPSZE->(DbGoTop())
If TMPSZE->(!Eof())
	While !TMPSZE->(Eof()) 
		
		cCliente	:= TMPSZE->ZE_CODIGO
		cLoja		:= TMPSZE->ZE_LOJA
		_cProduto	:= TMPSZE->ZE_PRODUTO
		
		While !TMPSZE->(Eof()) .And. TMPSZE->ZE_NUMAC == _cNumSZD .And. TMPSZE->ZE_CODIGO == _cNLaselva .And. TMPSZE->ZE_LOJA == _cNLoja 
				
			If Empty(_cNumPV)
	    	
		    	_cNumPV := GetSxeNum("SC5","C5_NUM")
				While .T.
					DbSelectArea("SC5")
					DbSetOrder(1)
					If DbSeek(xFilial("SC5")+_cNumPV)
						ConfirmSX8()
						_cNumPV := GetSxeNum("SC5","C5_NUM")
						Loop
					Else
						Exit
					EndIf
				EndDo	
						
				DbSelectArea("SA1")
				SA1->( DbSetOrder(1) )
				DbSeek( xFilial("SA1")+cCliente+cLoja )     
				
				cEstado := SA1->A1_EST
				
				/*
				_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
				{"C5_NUM"		,   _cNumPV						,Nil},;
				{"C5_TIPO"		,   'N'							,Nil},;
				{"C5_CLIENTE"	,	SA1->A1_COD					,Nil},;
				{"C5_LOJACLI"	,	SA1->A1_LOJA				,Nil},;
				{"C5_TIPOCLI"	,	"R"							,Nil},;
				{"C5_TRANSP"	,	"000001"					,Nil},;
				{"C5_TPFRETE"	,	'F'							,Nil},;
				{"C5_MOEDA"		,	1							,Nil},;
				{"C5_CONDPAG"	,	SA1->A1_COND				,Nil},;
				{"C5_STATUS"	,	'01'						,Nil},;
				{"C5_EMISSAO"	,	dDataBase					,Nil},;
				{"C5_DATA"		,	dDataBase					,Nil},;
				{"C5_HORA"		,	Time()						,Nil},;
				{"C5_VEND1"		,	"000001"					,Nil}}       
				*/
				
				_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
				{"C5_NUM"		,   _cNumPV						,Nil},;
				{"C5_TIPO"		,   'N'							,Nil},;
				{"C5_CLIENTE"	,	SA1->A1_COD					,Nil},;
				{"C5_LOJACLI"	,	SA1->A1_LOJA				,Nil},;
				{"C5_CLIENT"	,	SA1->A1_COD					,Nil},;					
				{"C5_LOJAENT"	,	SA1->A1_LOJA				,Nil},;						
				{"C5_TIPOCLI"	,	"R"							,Nil},;
				{"C5_TRANSP"	,	"000001"					,Nil},;
				{"C5_TPFRETE"	,	'F'							,Nil},;
				{"C5_MOEDA"		,	1							,Nil},;
				{"C5_CONDPAG"	,	SA1->A1_COND				,Nil},;
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
										 
		   	_nQtdPag := TMPSZE->ZE_QUANT
			
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) )
			DbSeek( xFilial("SB1")+_cProduto ) 

			If Select("TMPSB6") > 0
				DbSelectArea("TMPSB6")
				DbCloseArea()
			EndIf   
			
			cQrySB6 := " SELECT MAX(B6_PRUNIT) AS PRECO "
			cQrySB6 += " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
			cQrySB6 += " WHERE "
			cQrySB6 += " B6_FILIAL = '"+cLoja+"' AND "
			cQrySB6 += " B6_CLIFOR = '000001' AND "
			cQrySB6 += " B6_LOJA = '01' AND "			
			cQrySB6 += " B6_PRODUTO = '"+_cProduto+"' AND "
			cQrySB6 += " B6_PODER3 = 'R' AND "
			cQrySB6 += " B6_ATEND <> 'S' AND "
			cQrySB6 += " B6_TPCF = 'F' AND "
			cQrySB6 += " B6_SALDO > 0 AND 
			cQrySB6 += " SB6.D_E_L_E_T_ = '' "  

			dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQrySB6), "TMPSB6", .F., .T.)  
			
			DbSelectArea("TMPSB6") 
			TMPSB6->(DbGoTop())
			If TMPSB6->(!Eof())
				While !TMPSB6->(Eof())
					nPreco := TMPSB6->PRECO
					TMPSB6->(DbSkip())
				EndDo
			EndIf		
					
			_nVlrItem   := Round((_nQtdPag * nPreco),4) 		
			
			If SB1->B1_GRUPO $ GetMv("MV_GRPLIVR")
				_cTes := "607" 
			Else
				_cTes := "504" 
			EndIf          
			
			cCf	:= Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
		
			If SM0->M0_ESTENT <> cEstado
				cCf := "6"+Substr(cCf,2,3)			
			EndIf	
			/*											
			_aItemTemp := {{"C6_NUM"	,	_cNumPV				,Nil},;
			{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
			{"C6_ITEM"		,	nItePV							,Nil},;	
			{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
			{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
			{"C6_UM"		,	SB1->B1_UM						,Nil},;
			{"C6_PRCVEN"	,	nPreco							,Nil},;
			{"C6_PRUNIT"	,	nPreco							,Nil},;
			{"C6_QTDVEN"	,	_nQtdPag						,Nil},; 
			{"C6_QTDEMP"	,	_nQtdPag						,Nil},;	 
		   	{"C6_VALOR"		,	_nVlrItem						,Nil},;
			{"C6_TES"		,	_cTes							,Nil},;	
			{"C6_CF"		,	cCf								,Nil},;
			{"C6_LOCAL"		,	SB1->B1_LOCPAD					,Nil},;	
			{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_SITTRIB") ,Nil},;
			{"C6_CLI"		,	SA1->A1_COD		 				,Nil},;
			{"C6_ENTREG"	,	dDataBase						,Nil},;
		   	{"C6_LOJA"		,	SA1->A1_LOJA					,Nil}}      
		   	*/
		   	_aItemTemp := {{"C6_NUM"	,	_cNumPV				,Nil},;
			{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
			{"C6_ITEM"		,	nItePV							,Nil},;	
			{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
			{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
			{"C6_UM"		,	SB1->B1_UM						,Nil},;
			{"C6_QTDVEN"	,	_nQtdPag						,Nil},; 
			{"C6_PRUNIT"	,	nPreco							,Nil},;	
			{"C6_PRCVEN"	,	nPreco							,Nil},;
			{"C6_VALOR"		,	_nVlrItem						,Nil},;
			{"C6_TES"		,	_cTes							,Nil},;	
			{"C6_CF"		,	cCf								,Nil},;
			{"C6_LOCAL"		,	SD1->D1_LOCAL											,Nil},;	
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
				MsUnlock()
				
				//Grava o SC6
				DbSelectArea("SC6")
				For nX:= 1 to Len(_aItemPv)
					Reclock("SC6",.T.)
					
					For nZ := 1 to Len(_aItemPv[nX])
						cVar := Trim(_aItemPv[nX][nZ][1])
						Replace &cVar. With _aItemPv[nX][nZ][2]
					Next nZ
					Replace C6_FILIAL With xFilial("SC6")
							
					MsUnlock()
					DbCommit()
				Next nX	 
				
				End Transaction
		
				//For _nI := 1 To Len(_aPedidos)
					//U_LibPedAuto(_aPedidos[_nI,1])
				//Next _nI							
					
				_aCabPv		:= {}
				_aItemPv	:= {}
				_cNumPV		:= Space(6)
				_nReg		:= 0
				nItePV		:= "0001" 
										
			EndIf   	
		   				   		
			TMPSZE->(DbSkip())  
			_cProduto	:= TMPSZE->ZE_PRODUTO
			_nQtdPag	:= 0
		
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
		MsUnlock()
				
		//Grava o SC6
		DbSelectArea("SC6")
		For nX:= 1 to Len(_aItemPv)
			Reclock("SC6",.T.)
			For nZ := 1 to Len(_aItemPv[nX])
				cVar := Trim(_aItemPv[nX][nZ][1])
				Replace &cVar. With _aItemPv[nX][nZ][2]
			Next nZ
			Replace C6_FILIAL With xFilial("SC6")
							
			MsUnlock()
			DbCommit()
		Next nX	 
		
		End Transaction
		
		//For _nI := 1 To Len(_aPedidos)
			//U_LibPedAuto(_aPedidos[_nI,1])
		//Next _nI
	
		_aCabPv		:= {}
		_aItemPv	:= {}
		_cNumPV		:= Space(6)
		_nReg		:= 0
		nItePV		:= "0001" 

	EndIf
		
	If !lMsErroAuto  
	
		DbSelectArea("SZD")
		SZD->(DbSetOrder(1))
		If DbSeek(xFilial("SZD")+_cNumSZD+_cNLaselva+_cNLoja)
			RecLock("SZD",.F.)
			Replace SZD->ZD_STATUS With "P"
			MsUnLock()	
		EndIf	
		
		For _nI := 1 To Len(_aPedidos)
			DbSelectArea("PA6")
			PA6->( DbSetOrder(1) )
			If PA6->( DbSeek(xFilial("PA6")+_aPedidos[_nI,1]+SM0->M0_CODFIL) ) 
				RecLock("PA6",.F.)	
				DbDelete()
				MsUnLock()
			EndIf  
			
			DbSelectArea("PA7")
			PA7->( DbSetOrder(1) )
			If PA7->( DbSeek(xFilial("PA7")+_aPedidos[_nI,1]+SM0->M0_CODFIL) ) 
				While PA7->(!Eof()) .And. PA7->PA7_FILIAL == xFilial("PA7") .And. PA7->PA7_NUMROM == _aPedidos[_nI,1]+SM0->M0_CODFIL 
					RecLock("PA7",.F.)	
					DbDelete()
					MsUnLock()
					PA7->(DbSkip())
				EndDo	
			EndIf  
			
		Next _nI     
		
		For _nI := 1 To Len(_aPedidos)
			U_LibPedAuto(_aPedidos[_nI,1])
		Next _nI
			                                                                                       
		If _nCont > 0
				                                                                                                
			DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,265 TITLE "Pedidos Compra/Venda" PIXEL
			
			@ 10,8 LISTBOX oLbx FIELDS HEADER "Pedido de Venda" SIZE 120,80 NOSCROLL OF oDlgPC PIXEL
			
			oLbx:SetArray(_aPedidos)
			oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1]}}

			@ 100,050 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End()) 
    		
			ACTIVATE MSDIALOG oDlgPC CENTERED
							
	   	Else
	   	
	   		MsgStop("Foram encontrados erros durante o processamnto!!!")	
	   	
	   	EndIf	
	   	
	EndIf	   	
		
Else
		Aviso("Acerto de Consignacao","Nao ha registros para processamento!",{"Ok"})			

EndIf
	
//End Transaction

DbSelectArea("TMPSZE")
DbCloseArea()  

RestArea(_aArea)
		
Return  