#INCLUDE "PROTHEUS.CH"   
#INCLUDE "TOPCONN.CH"   

/*
+===========================================================+
|Programa: FATP025 |Autor: Antonio Carlos |Data: 14/09/11   |
+===========================================================+
|Descrição: Rotina responsavel pela devolução de Mercadoria |
|Consignada entre Laselva x Coligadas.                      |
+===========================================================+
|Uso: Especifico                                            |
+===========================================================+
*/

User Function FATP025()    

Local nOpca 	:= 0
Local aSays 	:= {}
Local aButtons  := {}
Private cCadastro	:= "Transferencia entre Lojas"

AADD(aSays,OemToAnsi( "Esta rotina tem como objetivo gerar os Pedidos de Vendas referente" ) ) 
AADD(aSays,OemToAnsi( "devolucao de mercadoria consignada entre Coligadas x Laselva." ) )
AADD(aSays,OemToAnsi( " " ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return NIL
EndIf

Processa( {|lEnd| AtuDados(@lEnd)}, "Aguarde...","Gerando Pedidos de Devolucao", .T. )

Return Nil

Static Function AtuDados()

Local _nVlrUnit	:= 0
Local _nVlrTot	:= 0 
Local _nCont	:= 0 
Local _nReg		:= 0 
Local _nQtdBx	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0
Local nTotRec	:= 0

Local _lFaz		:= .T.                             
	
Local nItens	:= "0001"  
Local nItOri	:= "0001"
Local _cTes		:= Space(3)
LOCAL cCf		:= Space(4)
Local _cNumPed 	:=  Space(6)
lOCAL cEstado:=""
Local _aCabPv		:= {}
Local _aItensPv		:= {}
Local _aItemTemp	:= {}  
Local _aPedidos		:= {}

Private oDlgPC		
Private lMsErroauto	:= .F.

_cFornece	:= "000003"
_cLoja		:= "DW"		

cQry := " SELECT * "
cQry += " FROM MARTE.SIGA.dbo.T141211 "
cQry += " ORDER BY GRUPO, CODIGO  "

TcQuery cQry NEW ALIAS "TMP"

Count To nTotRec
ProcRegua(nTotRec)

Begin Transaction

DbSelectArea("TMP") 
TMP->( DbGoTop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() ) 
	
		_cGrupo	:= TMP->GRUPO
			
		While TMP->( !Eof() ) .And. _cGrupo	== TMP->GRUPO 
		
			IncProc("Processando...")
				
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
						
				DbSelectArea("SA1")
				SA1->( DbSetOrder(1) )
				DbSeek( xFilial("SA1")+_cFornece+_cLoja ) 
								
				_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
				{"C5_NUM"		,   _cNumPed					,Nil},;
				{"C5_TIPO"		,   'B'							,Nil},;
				{"C5_CLIENTE"	,	SA1->A1_COD					,Nil},;
				{"C5_LOJACLI"	,	SA1->A1_LOJA				,Nil},;				
				{"C5_CLIENT"	,	SA1->A1_COD					,Nil},;
				{"C5_LOJAENT"	,	SA1->A1_LOJA				,Nil},;				
				{"C5_TIPOCLI"	,	"R"							,Nil},;
				{"C5_CONDPAG"	,	SA1->A1_COND				,Nil}}

				cEstado :=SA1->A1_EST					    
			EndIf
			
			_nQtdPag := TMP->QTD
			_cTes := TMP->TES		
			cCf	:= Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
            

IF cEstado="EX"
		cCf := "7"+Substr(cCf,2,3)		
		ELSE
			If SM0->M0_ESTENT <> cEstado
				cCf := "6"+Substr(cCf,2,3)
			ELSE
				cCf := "5"+Substr(cCf,2,3)
			ENDIF	
		EndIf
		
		
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) )
			DbSeek( xFilial("SB1")+TMP->CODIGO )
			
			_nVlrUnit := Round(SB1->B1_UPRC,2)
			_nVlrItem := _nQtdPag * _nVlrUnit													
																	
			_aItemTemp := {{"C6_NUM"	,	_cNumPed								,Nil},;
			{"C6_FILIAL"	,	xFilial("SC6")										,Nil},;
			{"C6_ITEM"		,	nItens												,Nil},;	
			{"C6_PRODUTO"	,	SB1->B1_COD											,Nil},;
			{"C6_QTDVEN"	,	_nQtdPag											,Nil},; 
			{"C6_PRUNIT"	,	_nVlrUnit											,Nil},;	
			{"C6_PRCVEN"	,	_nVlrUnit											,Nil},;
			{"C6_VALOR"		,	_nVlrItem											,Nil},;
			{"C6_TES"		,	_cTes												,Nil},;	
			{"C6_CF"		,	cCf													,Nil}}
						   	        	
			_nReg++ 
			_nCont++
			nItens := Soma1(nItens)
			nItOri := Soma1(nItOri)
			aAdd(_aItensPv,aClone(_aItemTemp))
					
			If _nReg == 70
			
				lMsErroAuto := .F.
				MsExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItensPv,3)
				
				If lMsErroAuto
					MostraErro()
				Else
					Aadd(_aPedidos,{_cNumPed})	
				EndIf	
				
				_aCabPv		:= {}
				_aItensPv	:= {}
				_cNumPed	:= Space(6)
				_nReg		:= 0
				nItens		:= "0001"	 
				nItOri		:= "0001"		
								
				/*	
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
				
				_aCabPv		:= {}
				_aItemPv	:= {}
				_cNumPed	:= Space(6)
				_nReg		:= 0
				nItens		:= "01"	
				nItOri		:= "01"		
					
				End Transaction						
				*/
					
			EndIf	
			
			TMP->( DbSkip() )
								
		EndDo	
							
		If _nReg > 0
		    
				lMsErroAuto := .F.
				MsExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItensPv,3)
				
				If lMsErroAuto
					MostraErro()					
				Else
					Aadd(_aPedidos,{_cNumPed})	
				EndIf	
				
				_aCabPv		:= {}                                            
				_aItensPv	:= {}
				_cNumPed	:= Space(6)
				_nReg		:= 0
				nItens		:= "0001"	 
				nItOri		:= "0001"				
			
			/*
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
					
			_aCabPv		:= {}
			_aItemPv	:= {}
			_cNumPed	:= Space(6)
			_nReg		:= 0
			nItens		:= "01"	
			nItOri		:= "01"		
				
			End Transaction
			*/
			
		EndIf		
		
	EndDo	
						                                                                                       
	If _nCont > 0
	
		/*
		If Len(_aPedidos) > 0
		
			For _nI := 1 To Len(_aPedidos)
				LibPedid(_aPedidos[_nI,1])
			Next _nI
		
		EndIf	
		*/
				                                                                                                
		DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,230 TITLE "Pedidos de Venda" PIXEL
		
		@ 10,8 LISTBOX oLbx FIELDS HEADER "Nr. Pedido" SIZE 100,80 NOSCROLL OF oDlgPC PIXEL
			
		oLbx:SetArray(_aPedidos)
		oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1]}}

		@ 100,065 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End()) 
    		
		ACTIVATE MSDIALOG oDlgPC CENTERED
							
	Else
	   	
		MsgStop("Foram encontrados erros durante o processamnto!!!")	
	   	
	EndIf	
	   		
Else
		
		Aviso("Acerto de Consignacao","Nao ha registros para processamento!",{"Ok"})			

EndIf
	
End Transaction

DbSelectArea("TMP")
DbCloseArea()  
		
Return  

Static Function LibPedid(cNumPed)

Local aArea		:= GetArea()
Local nX		:= 0
Local lLiberOk  := .T.
Local lCredito  := .T.
Local lEstoque  := .T.
Local lLiber    := .T.
Local lTransf   := .F.

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

			SB2->B2_XRESERV := SB2->B2_RESERVA - _nQuant + SC9->C9_QTDLIB// RESERVA
//			SB2->B2_RESERVA := SB2->B2_RESERVA - _nQuant + SC9->C9_QTDLIB // RESERVA

			MsUnLock()
		EndIf
		
		If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
			RecLock("SB2",.F.)   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
//			SB2->B2_SALPEDI := SB2->B2_SALPEDI - _nQuant + SC9->C9_QTDLIB // TRANSITO    

if SB2->B2_XTRANSI < 0 
	SB2->B2_XTRANSI:=0 
ELSE 
	SB2->B2_XTRANSI:=SB2->B2_XTRANSI 
endif
		SB2->B2_XTRANSI  := SB2->B2_XTRANSI - _nQuant + SC9->C9_QTDLIB // TRANSITO
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

RestArea(aArea)

Return()