#include "Protheus.ch"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATE002()   ºAutor  ³Ricardo Nisiyama º Data ³  30/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada que trata item a item para verificação    º±±
±±º          ³ de Regra do tempo de analise x tempo de entrega x inclusao º±±
±±º          ³ do pedido após as 12hrs.                                	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12                          	                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


//—————————————————————————
User Function RFATE002()
//—————————————————————————

Private _lOk		:= .T.
Private aArea		:= GetArea()
Private nPosProd	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
Private nPosQtd		:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" 	})
Private nPosEntr	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG" 	})
Private nPosDtAnExt	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_DTANEXT"	})
Private nPosSugentr	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_SUGENTR"	})
Private nPosDtProd	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_DTPROD" 	})
Private _cProd		:= aCols[N][nPosProd]
Private _nQtdVen	:= aCols[N][nPosQtd]
Private _cTmpAna	:= Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_TEMPANA")
Private _cTmpEnt	:= Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_TEMPENT")
Private _nPrzRep	:= U_RFATE010(_cProd,_nQtdVen)
Private _cTime		:= TIME() // Resultado: 10:37:17
Private _dDataMax	:= M->C5_FECENT
Private _cMsgEst	:= ""
Private _lAuto		:= .F.

	If Altera //.Or. Inclui
		Return(_lOk)
	EndIf
	
	If _nPrzRep > 0
		_cMsgEst := " Não há saldo disponível em estoque, será considerado mais " + AllTrim(Str(_nPrzRep)) + " dia(s) para produção."
	EndIf
	
	//Análise Interna
	If _cTime < "12:00:00" .and. _cTmpEnt = "1"
		MsgAlert("O tempo de entrega desse produto é de 48 horas e o tempo de analise é de " + _cTmpEnt + " dias." + _cMsgEst)
		If _lAuto
			If  M->C5_FECENT < datavalida(DDatabase+2+_nPrzRep)
			
				If datavalida(DDatabase+1+_nPrzRep) > _dDataMax
					_dDataMax := datavalida(DDatabase+2+_nPrzRep)
				EndIf         
				M->C5_FECENT := _dDataMax
				dispGat()                         
			Endif	
		EndIf
		//U_RFATE001()
	Elseif _cTime > "12:00:00" .and. _cTmpEnt = "1"
		MsgAlert("O tempo de entrega desse produto é de 48 horas e o tempo de analise é de " + _cTmpEnt + " dias." + _cMsgEst)
		If _lAuto		
			If  M->C5_FECENT < datavalida(DDatabase+3+_nPrzRep)
			
				If datavalida(DDatabase+2+_nPrzRep) > _dDataMax
					_dDataMax := datavalida(DDatabase+3+_nPrzRep)
				EndIf         
				M->C5_FECENT := _dDataMax
				dispGat()
			Endif
		EndIf
		//U_RFATE001()
	Elseif _cTime < "12:00:00" .and. _cTmpEnt = "2"
		MsgAlert("O tempo de entrega desse produto é de 72 horas e o tempo de analise é de " + _cTmpEnt + " dias." + _cMsgEst)
		If _lAuto
			If  M->C5_FECENT < datavalida(DDatabase+1+_nPrzRep)
			
				If datavalida(DDatabase+2+_nPrzRep) > _dDataMax
					_dDataMax := datavalida(DDatabase+1+_nPrzRep)
				EndIf
				M->C5_FECENT := _dDataMax
				dispGat()
			Endif
		EndIf
		//U_RFATE001()
	Elseif _cTime > "12:00:00" .and. _cTmpEnt = "2"
		MsgAlert("O tempo de entrega desse produto é de 72 horas e o tempo de analise é de " + _cTmpEnt + " dias." + _cMsgEst)
		If _lAuto
			If  M->C5_FECENT < datavalida(DDatabase+2+_nPrzRep)
			
				If datavalida(DDatabase+3+_nPrzRep) > _dDataMax
					_dDataMax := datavalida(DDatabase+2+_nPrzRep)
				EndIf         
				M->C5_FECENT := _dDataMax
				dispGat()
			Endif
		EndIf
	ElseIf _lAuto
	
		_nAcresc := 0
		
		If _cTime > "12:00:00"
			_nAcresc := 1
		EndIf
		
		If  M->C5_FECENT <= datavalida(DDatabase+_nPrzRep+_nAcresc)
			
			If _nPrzRep > 0
				MsgAlert(_cMsgEst)
			EndIf
			
			If datavalida(DDatabase+_nPrzRep+_nAcresc) > _dDataMax
				_dDataMax := datavalida(DDatabase+_nPrzRep+_nAcresc)
			EndIf
			
			M->C5_FECENT := _dDataMax
			dispGat()
		EndIf
	EndIf

 	// Análise Externa - por CR - Valdimari Martins 20/02/2017 -- Início
 	// Calcular o prazo de entrega caso tenha Análise Externa
 	dbselectArea("SA7")
 	dbSetOrder(1)                               
 	aCols[n,nPosDtProd] := ctod("  /  /  ")
	aCols[n,nPosDtAnExt]:= ctod("  /  /  ")
	aCols[n,nPosEntr] 	:= ctod("  /  /  ")
	aCols[n,nPosSugentr]:= ctod("  /  /  ")
 	If dbSeek(xFilial("SA7")+M->C5_CLIENTE+M->C5_LOJACLI+_cProd)
 		If datavalida(DDatabase + SA7->A7_AnTempo) > _dDataMax
  	      	_dDataMax 				:= datavalida(DDatabase + SA7->A7_AnTempo + 1)

			M->C5_FECENT  			:= _dDataMax
			dispGat()   	      

		   	If Inclui .and. SA7->A7_AnTempo > 0  //.And. _lAuto
	    		aCols[n,nPosDtProd] := datavalida(DDatabase + 1)
			    aCols[n,nPosDtAnExt]:= _dDataMax
			   	aCols[n,nPosEntr] 	:= _dDataMax
			    aCols[n,nPosSugentr]:= _dDataMax
		   	EndIf
		Endif	
   	Endif
 	// Análise Externa - por CR - Valdimari Martins 20/02/2017 -- Final
   	
   	If Inclui .And. _lAuto
	   	aCols[n,nPosEntr] 	:= _dDataMax
   	EndIf
 	
 	//Forço o refresh na tela
	GETDREFRESH()
	SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
	oGetDad:Refresh()
Return(_lOk)      

Static Function dispGat()

	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek("C5_FECENT")
		_cValid := AllTrim(SX3->X3_VALID + IIF(!Empty(SX3->X3_VALID).AND.!Empty(SX3->X3_VLDUSER),".AND."," ") + SX3->X3_VLDUSER)
			  
		If Empty(_cValid)
		_cValid  := ".T."
		EndIf
			  
		_lRet := &_cValid
		
		If _lRet .AND. ExistTrigger("C5_FECENT")
			RunTrigger(1)
			EvalTrigger()
		EndIf
	Endif
Return()