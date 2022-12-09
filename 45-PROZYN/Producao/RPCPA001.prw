#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPA001  ºAutor ³ DERIK SANTOS           º Data ³ 14/11/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para atualizar a sala utilizada na OP                 º±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Prozyn                                     º±±        
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCPA001()

Local _aSavArea 	:= GetArea()
Local _aSavSC2		:= SC2->(GetArea())
Local _aSavSZ6		:= SZ6->(GetArea())
Local _cCodprod 	:= RTRIM(SC2->C2_PRODUTO)
Local _cProduto 	:= RTRIM(Posicione("SB1",1,xFilial("SB1")+_cCodprod,"B1_DESC"))
Local _cOp 			:= SC2->C2_NUM
Private _cConteudo	:= SPACE(3)
Private _cRotina	:= "RPCPA001"
Private _aProdAc    := Separa(SuperGetMv("MV_PRODXAC",,""),";") // Leio o Parametro de Produtos x Ações para liberar seus produtos em qualquer sala.
Static oDlg5

@ 001,001 TO 100,550 DIALOG oDlg5 TITLE "Sala" 
@ 004,008 Say OemToAnsi("Tela para identificação da sala, a qual o Produto " + _cProduto + " será feito.")
@ 019,008 Say OemToAnsi("O campo sala da OP " + _cOp + " deverá possuir 3 caracteres.")
@ 034,030 Get _cConteudo F3 "SZ6" Size 90,11  
@ 034,150 Button OemToAnsi("_Salvar") Size 25,11 Action GrvEsterCQ()

Activate Dialog oDlg5 Centered
                  
RestArea(_aSavSZ6)
RestArea(_aSavSC2)
RestArea(_aSavArea)

Return(.T.)


//---- Rotina de confirmacao dos parametros.

Static Function GrvEsterCQ()

Local _Pular      := .F.
Local _nCont      := 0
Local _cProdLib   := ""


If Empty(_cConteudo)
	MsgStop("Informe a sala para dar continuidade na geração da OP",_cRotina+"_001")
	Return(.F.)
Else
	_cSala   := _cConteudo
	_cAlergp := RTRIM(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_SNALERG"))
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	
	If (_cSala == "000")  .Or. !(SZ6->(dbSeek(xFilial("SZ6")+_cSala)))
		MsgStop("Sala inválida!",_cRotina+"_002")
	 	Return(.F.)
	ElseIf (SZ6->Z6_ALERG == "1" .And. _cAlergs <> "1")
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
			MsgStop("O Produto não poderá ser alocado nesta sala devido ao Alergênico, favor selecionar outra sala!",_cRotina+"_003")
	 		Return(.F.)
	 	else
	 		Return(.T.)
	 	Endif			
	EndIf
EndIf

dbSelectArea("SC2")

Reclock("SC2",.F.)
	SC2->C2_SALA := _cConteudo
SC2->(MsUnlock())

Close(oDlg5) 

Return()