#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

&&==========================================================================================================================================================
&&Nelson Hammel - 14/09/11 - Ponto de entrada para adicionar rotina cust onde fa�o sele��o de filtros

User Function TK271ROTM()

	Local aRotina := {}
	&&Adiciona Rotina Customizada aos botoes do Browse

	aAdd( aRotina, { 'Imp Or�amento' 	,'U_ImpOrcX', 0 , 7 })

	Return aRotina

	&&==========================================================================================================================================================
