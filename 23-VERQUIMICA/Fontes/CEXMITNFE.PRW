#Include "Totvs.ch"

/*==========================================================================
Funcao...........:	CEXMITNFE
Autor............:	Amedeo D. Paoli Filho (Fabritech)
Descricao........:	Ponto de entrada apos carregar itens para lancar NF-e
							(Central XML)

Data.............:	05/2017
Parametros.......:	ExpA1 - Itens da NF
Retorno..........:	Array - 3 Posicoes
							1 - Itens da NF
							2 - Retorno .F. / .T.
							3 - Mensagem caso posicao 2 seja .F.
==========================================================================*/
User Function CEXMITNFE()
	Local aRetorno	:= PARAMIXB
	Local aAreaAt	:= GetArea()
	Local aAreaB1	:= SB1->( GetArea() )
	Local lRetorno	:= .T.
	Local cMensagem	:= ""
	Local nPosQtd	:= 0
	Local cCSTNfe	:= ""
	Local cCSTXml	:= ""
	Local nX		:= 0
	
	/*
	For nX := 1 To Len( aRetorno )
		
		nPosQtd	:= Ascan( aRetorno[nX], { |x| Alltrim( x[1] ) == "D1_VQ_VSEG" } )
		
		If nPosQtd > 0
			aRetorno[ nX ][ nPosQtd ][ 02 ]	:= 1000
		Else
			Aadd( aRetorno[ nX ],	{ "D1_VQ_VSEG", 1000, Nil } )
		EndIf
					
	Next nX
	*/
	
	//Valida CST Original x CST XML (ADICIONAR AQUI AS VALIDACOES ADICIONAIS)
	For nX := 1 To Len( aCols )
	
		//Se o CST do XML for diferente do CST do Pedido de Compra
		If aCols[ nX ][ 44 ] <> aCols[ nX ][ 45 ]
			//lRetorno	:= .F.
			cMensagem	:= "CST do Produto está divergente da CST do XML. Favor verificar!!!"
		EndIf
		
	Next nX

	RestArea( aAreaB1 )
	RestArea( aAreaAt )
	
Return { aRetorno, lRetorno, cMensagem }
