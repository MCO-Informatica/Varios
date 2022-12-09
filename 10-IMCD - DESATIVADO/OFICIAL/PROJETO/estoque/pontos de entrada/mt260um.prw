#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLOTEMUL � Autor � Giane - ADV Brasil � Data �  19/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � funcao para nao permitir usuario digitar qtdade nos itens  ���
���          � do orcamento/pedido, caso a qtdade nao seja multipla da    ���
���          � embalagem.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / televendas/orcamento e pedido de vendas���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT260UM
	Local _lRet 	:= .T. 
	Local cProd1 	:= cCodOrig
	Local cProd2 	:= cCodDest     
	Local _nQuant	:= nQuant260

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT260UM" , __cUserID )

	If Paramixb[1] == 1
		_nLoteM := Posicione("SB1",1,xfilial("SB1")+cProd1,"B1_LOTEMUL")
		_nConv  := Posicione("SB1",1,xfilial("SB1")+cProd1,"B1_CONV")
		_cTpCo  := Posicione("SB1",1,xFilial("SB1")+cProd1,"B1_TIPCONV")

		if _nLoteM > 0
			_nResto := MOD(_nQuant,_nLoteM)

			if _nResto > 0
				Alert("Atencao, quantidade digitada n�o � m�ltipla da Embalagem do produto Origem!")
				_lRet := .f.
			endif
		endif                                                                                    

		_nLoteM := Posicione("SB1",1,xfilial("SB1")+cProd2,"B1_LOTEMUL")
		_nConv  := Posicione("SB1",1,xfilial("SB1")+cProd2,"B1_CONV")
		_cTpCo  := Posicione("SB1",1,xFilial("SB1")+cProd2,"B1_TIPCONV")

		if _nLoteM > 0
			_nResto := MOD(_nQuant,_nLoteM)

			if _nResto > 0
				Alert("Atencao, quantidade digitada n�o � m�ltipla da Embalagem do produto Destino!")
				_lRet := .f.
			endif
		endif                                                                                    
	Endif

Return(_lRet)