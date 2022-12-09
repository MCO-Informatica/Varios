#Include 'Protheus.ch'

/*/{Protheus.doc} TK510FIL

Ponto de entrada para personalização do filtro de chamados mostrados na tela de servicedesk

@author Totvs SM - David
@since 25/07/2014
@version P11

/*/

User Function tk510fil()
	Local cRetFil	:= ""

//Chamada de função para escolha de grupo do operador
	If  U_CTSDK022()
		
		// Retorna Filtro para chamados do grupo do operador
		SU7->(DbSetOrder(4))
		
		If SU7->(DbSeek(xFilial("SU7")+__cUserId))
			cRetFil	:= "ADE->ADE_FILIAL == '"+xFilial("ADE")+"' .AND. ADE->ADE_GRUPO == '"+SU7->U7_POSTO+"'"
		EndIf
	EndIf
Return(cRetFil)

