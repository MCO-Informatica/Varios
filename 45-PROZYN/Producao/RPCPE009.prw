#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPCPR009  ºAutor  ³ Derik Santos      º Data ³  18/10/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para validação se o produto pode ser alocado na sala º±±
±±ºDesc.     ³ devido alguns produtos conterem alergenicos                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPE009()

Local _cSala   := RTRIM(M->C2_SALA)
Local _cProd	 := RTRIM(M->C2_PRODUTO)
Local _cAlergp := RTRIM(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_SNALERG"))
Local _cAlergs := RTRIM(Posicione("SZ6",1,xFilial("SZ6")+_cSala,"Z6_ALERG"))
Local _aProdAc := Separa(SuperGetMv("MV_PRODXAC",,""),";") // Leio o Parametro de Produtos x Ações para liberar seus produtos em qualquer sala.
Local _Pular   := .F.
Local _nCont   := 0

If _cAlergp == _cAlergs
	Return(_cSala)
ElseIf _cAlergp <> _cAlergs                                       
  	//Corro todos os Produtos na lista do MV_PRODXAC para pular ou não da validação da Sala - por CR - Valdimari Martins 13/02/2017
  	For _nCont := 1 To Len(_aProdAc)
		_cProdLib :=  substr(_aProdAc[_nCont],4,10)
   		If _cProd == _cProdLib
   		  _Pular := .T.
   		  exit
   		else
   		  _Pular := .F.  
		EndIf
  	Next                            
    if !_Pular
	    if _cAlergs == '3'
    	  	Return(_cSala)
    	else  
  	  		Alert("O Produto não poderá ser alocado nesta sala devido ao Alergênico, favor selecionar outra sala!")
 	  		Return(Space(3))
 		endif  
 	else
 	  	Return(_cSala)	
 	endif
EndIf

Return(Space(3))