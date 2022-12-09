#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

&&==========================================================================================================================================================
&&Nelson Hammel - 14/09/11 - Ponto de entrada para adicionar rotina cust onde faço seleção de filtros

User Function TK271ROTM()

	Local aRotina := {}
	&&Adiciona Rotina Customizada aos botoes do Browse

	aAdd( aRotina, { 'Imp Orçamento' 	,'U_ImpOrcX', 0 , 7 })

	Return aRotina

	&&==========================================================================================================================================================
