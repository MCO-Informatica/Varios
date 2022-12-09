#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTVALPED  บAutor  ณBruno Daniel Abrigo บ Data ณ  10/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Permite validar alteracao nos campos Lacre e Qtd           บฑฑ
ฑฑบ          ณ Se for alterar, bloqueia                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTValPROD(CAMPO,valor,ANTIGO)

Local nPosLacre := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XLACRE" })
Local nPosProd  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
Local nPosqtde  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
Local nPosOP    := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_NUMOP" })
Local nPosCtr   := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_CONTRAT" })
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
			if Altera
				if campo == 'C6_ENTREG' .And. Empty(aCols[n,nPosOP])
					return .t.
				else
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
				if campo == 'C6_XLACRE' .And. Empty(aCols[n,nPosOP])
					return .t.
				else
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
				If !Empty(aCols[n,nPosCtr]) .And. Empty(aCols[n,nPosOP])
					Return .t.
				Endif
				if campo == 'C6_QTDVEN' .and. aCols[n,nPoscpo] == 0
					return .t.
				else
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
				if campo == 'C6_XSTAND'
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
			else		
				if campo == 'C6_XSTAND'
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
				if campo == 'C6_QTDVEN' .and. aCols[n,nPoscpo] == 0 
					return .t.
				else
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)
				endif   
			endif
		elseif _lCopy  
			if Altera
				if campo == 'C6_XSTAND'
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
				If !Empty(aCols[n,nPosCtr]) .And. Empty(aCols[n,nPosOP])
					Return .t.
				Endif
				if campo == 'C6_QTDVEN' .and. aCols[n,nPoscpo] == 0
					return .t.
				else
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
			else			
				if campo == 'C6_XSTAND'
					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
					return(.f.)               
				endif
				if campo == 'C6_QTDVEN'
				     // Sำ PODE ALTERAR O CAMPO QTDE. LACRE E PRODUTO NAO PODE.
			    ELSE
//					MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
//					return(.f.)
				ENDIF 
			endif
		elseif Altera // nao pode alterar qtde, produto e lacre
/*			if campo == 'C6_XSTAND'
				MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
				return(.f.)               
			endif */
			If Empty(aCols[n,nPosOP]) .And. Empty(aCols[n,nPosCtr])
				Return .t.
			Endif
			if campo == 'C6_QTDVEN' .and. aCols[n,nPoscpo] == 0
				return .t.
			else
				MsgStop("Nใo ้ permitido alterar o campo " + aHeader[nPosCPO,1] + ". Inclua um novo Item.") 
				return(.f.)               
			endif
		Endif
	endif
EndIf


Return(.T.)