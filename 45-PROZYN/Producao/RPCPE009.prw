#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RPCPR009  �Autor  � Derik Santos      � Data �  18/10/2016  ���
��������������������������������������������������������������������������͹��
���Desc.     � Rotina para valida��o se o produto pode ser alocado na sala ���
���Desc.     � devido alguns produtos conterem alergenicos                 ���
��������������������������������������������������������������������������͹��
���Uso       � Protheus 12 - Prozyn                                        ���
��������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������͹��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function RPCPE009()

Local _cSala   := RTRIM(M->C2_SALA)
Local _cProd	 := RTRIM(M->C2_PRODUTO)
Local _cAlergp := RTRIM(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_SNALERG"))
Local _cAlergs := RTRIM(Posicione("SZ6",1,xFilial("SZ6")+_cSala,"Z6_ALERG"))
Local _aProdAc := Separa(SuperGetMv("MV_PRODXAC",,""),";") // Leio o Parametro de Produtos x A��es para liberar seus produtos em qualquer sala.
Local _Pular   := .F.
Local _nCont   := 0

If _cAlergp == _cAlergs
	Return(_cSala)
ElseIf _cAlergp <> _cAlergs                                       
  	//Corro todos os Produtos na lista do MV_PRODXAC para pular ou n�o da valida��o da Sala - por CR - Valdimari Martins 13/02/2017
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
  	  		Alert("O Produto n�o poder� ser alocado nesta sala devido ao Alerg�nico, favor selecionar outra sala!")
 	  		Return(Space(3))
 		endif  
 	else
 	  	Return(_cSala)	
 	endif
EndIf

Return(Space(3))