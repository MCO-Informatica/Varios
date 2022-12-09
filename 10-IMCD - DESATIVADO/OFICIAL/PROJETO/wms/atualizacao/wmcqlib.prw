#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WMCQLIB   �Autor  �Edson Estevam       � Data �  15/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Na libera��o do CQ atribui no campo servi�o o conteudo     ���
���          � inserido no campo Seri�o de Entrada no complemento de      ���
���          � Produtos                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Makeni                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WMCQLIB()

	Local _aArea 	     := GetArea()
	Local _aAreaB5       := SB5->(GetArea())
	Local _cproduto      := QEK->QEK_PRODUTO
	Local _nPosTipo      := aScan(aHeader,{|x| AllTrim(x[2]) == "D7_TIPO"} )
	Local _nPosServ      := aScan(aHeader,{|x| AllTrim(x[2]) == "D7_SERVIC"} )
	local _nPosTpEst     := aScan(aHeader,{|x| AllTrim(x[2]) == "D7_TPESTR" } )

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "WMCQLIB" , __cUserID )

	//Carrega o c�digo do Produto da Tabela SD7

	_cTipo      := aCols[n,_nPosTipo]
	_cServico    :=aCols[n, _nPosServ]
	If GetMv( "MV_INTDL" ) == "S"
		If !Empty(_cProduto)
			dbSelectArea("SB5")
			dbSetOrder(1)

			If dbSeek(xFilial("SB5")+  _cproduto ,.F.)
				_cServico:= Alltrim(SB5->B5_SERVENT)
			EndIf
			aCols[n,_nPosTpEst] := "000003"
		EndIf
	EndIf

	// _cServico := "   "   // Incluido a pedido de Leomar (temporariamente)


	RestArea(_aAreaB5)
	RestArea(_aArea)

Return(_cServico)
