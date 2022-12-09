#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTVALPR_X ºAutor  ³Mateus Hengle       º Data ³  03/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite validar alteracao nos campos Lacre e Qtd           º±±
±±º          ³ Se for alterar, bloqueia                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTValPR_X(CAMPO,valor,ANTIGO)

Local nPosLacre := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XLACRE" })
Local nPosProd  := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO" })
Local nPosqtde  := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT" })
Local nPosEntr  := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_DTENTRE" })
Local nPosNumOp := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_NUMOP" })
Local nPosStand := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XSTAND" })
Local nPosCPO   := AScan(aHeader,{|x| AllTrim(x[2]) == campo })
Local lRet	    :=.T. 
Local oldCont   := aCols[n,nPoscpo]
Local newCont   := VALOR

if Type ("_lReap") == 'U'
	_lReap := .F.
ENDIF
                          

if Type ("_lCopy") == 'U'
	_lCopy := .F.
ENDIF

if Type ("_cPedRep") == 'U'
	_cPedRep := ''
ENDIF                       

Return .T.

if !aCols[n,Len(aHeader)+1]
	if !EMPTY(aCols[n,nPosLacre])       
		IF _lReap .and. !Empty(_cPedRep) 
			if Altera .Or. M->UA_OPER == '1'
				if campo == 'UB_QUANT' .and. !Empty(aCols[n,nPoscpo])
					MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				Elseif campo == 'UB_DTENTRE' .and. !Empty(aCols[n,nPoscpo]) .And. !Empty(aCols[n,nPosNumOp])
					MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				Elseif campo == 'UB_XLACRE' .and. !Empty(aCols[n,nPosLacre])
					MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				Elseif campo == 'UB_XSTAND' .and. !Empty(aCols[n,nPoscpo])
					MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
//					return(.f.)               
				endif
			else		
				if campo == 'UB_QUANT' .and. aCols[n,nPoscpo] == 0 
					return .t.
				else
					MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)
				endif   
			endif
		elseif _lCopy  
			if Altera .Or. M->UA_OPER == '1'
				if campo == 'UB_QUANT' .and. aCols[n,nPoscpo] == 0
					return .t.
				else
					MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
			else			
				if campo == 'UB_QUANT'
				     // SÓ PODE ALTERAR O CAMPO QTDE. LACRE E PRODUTO NAO PODE.
			    ELSE
					MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)
				ENDIF 
			endif
		elseif Altera .Or. M->UA_OPER == '1' // nao pode alterar qtde, produto e lacre e data entrega
			if campo == 'UB_QUANT' .and. !Empty(aCols[n,nPoscpo])
				MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
				return(.f.)               
			Elseif campo == 'UB_DTENTRE' .and. !Empty(aCols[n,nPoscpo]) .And. !Empty(aCols[n,nPosNumOp])
				MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
				return(.f.)               
			Elseif campo == 'UB_XLACRE' .and. !Empty(aCols[n,nPosLacre])
				MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
				return(.f.)               
			Elseif campo == 'UB_XSTAND' .and. !Empty(aCols[n,nPoscpo])
				MsgStop("Não é permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
//				return(.f.)               
			endif
		Endif
	endif
EndIf


Return(.T.)
