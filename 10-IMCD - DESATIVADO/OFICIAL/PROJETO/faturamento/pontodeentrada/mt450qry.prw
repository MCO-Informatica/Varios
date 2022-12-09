#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT450QRY � Autor � Giane - ADV Brasil � Data �  03/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para modificar query da rotina de libera  ���
���          � cao de credito e estoque                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / faturamento/liberacao cred/estoque aut ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT450QRY()
	Local _cQuery := Paramixb[1]
	Local nPos := 0  
	Local _cQry1 := ""
	Local _cQry2 := ""
	Local nTam

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT450QRY" , __cUserID )

	nPos := AT('SC6RECNO',_cQuery)                          

	_cQry1 := Left(_cQuery,nPos+8) + ", SC9.C9_BLEST, SC9.C9_CLIENTE, SC9.C9_LOJA, SC9.C9_PRODUTO "

	nTam := len(_cQuery) - (nPos+8)
	_cQry2 := Substr(_cQuery,nPos+8, nTam)   


Return(_cQry1+_cQry2)