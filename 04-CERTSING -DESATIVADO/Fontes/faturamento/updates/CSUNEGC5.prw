#Include 'Protheus.ch'


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSUNEGC5 |Autor: |David Alves dos Santos |Data: |06/08/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para atualizar unidade de negocio da tabela SC6.       |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSUNEGC5()
	
	Local nItem := aScan( aHeader, {|X| X[2] == "C6_UNEG   "} )
	Local nX    := 0
	
	//-> Atualiza o aCols com a unidade de negócio do cabeçalho.
	For nX := 1 To Len(aCols)
		If !Empty(M->C5_UNEG)
			aCols[nX,nItem] := M->C5_UNEG
		EndIf
	Next nX
	
	//-> Atualiza a getDados.
	oGetDad:Refresh()
	
Return



User Function CSUNEGC6()

	Local cRet := ""
	
	If FunName() = "MATA410" 
		Alert(FunName("MATA410"))
		cRet := Iif(Empty(C5_UNEG),Posicione('ACV',5,xfilial('ACV')+M->C6_PRODUTO, 'ACV_CATEGO'),M->C5_UNEG)
	Else
		Alert(FunName("MATA410"))
		cRet := Posicione('ACV', 5, xfilial('ACV') + SC6->C6_PRODUTO, 'ACV_CATEGO')
	EndIf        

Return( cRet )