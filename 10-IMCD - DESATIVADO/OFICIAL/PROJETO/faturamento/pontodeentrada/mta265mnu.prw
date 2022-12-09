#INCLUDE "rwmake.ch"
#include "protheus.ch"

User Function MTA265MNU//.customização do cliente 
//	aAdd(aRotina,{ "Redistribuição de Estoque", "u_ESTTR01()", 0 , 2, 0, .F.})	
//	aAdd(aRotina,{ "Etiqueta Entrada- Lote Fornecedor", "u_ETAIFF01()", 0 , 2, 0, .F.})	
//	aAdd(aRotina,{ "Etiqueta Entrada- Lote interno", "u_ETAIFF03()", 0 , 2, 0, .F.})	
	aAdd(aRotina,{ "Etiqueta entrada - Endereço", "u_ETAIFF06()", 0 , 2, 0, .F.})	
	aAdd(aRotina,{ "Etiqueta Saida- Nota Fiscal", "u_ETAIFF04()", 0 , 2, 0, .F.})
	aAdd(aRotina,{ "Etiqueta Saida- Nota Fiscal IMCD", "u_ETAIFF11()", 0 , 2, 0, .F.})	
//	aAdd(aRotina,{ "Etiqueta Saida- Avulso", "u_ETAIFF07()", 0 , 2, 0, .F.})	
	aAdd(aRotina,{ "Etiqueta - Avulsa", "u_ETAIFF02()", 0 , 2, 0, .F.})	
//	aAdd(aRotina,{ "Etiqueta - De endereços", "u_ETAIFF05()", 0 , 2, 0, .F.})	
//	aAdd(aRotina,{ "Etiqueta - De Endereço Especifica", "U_ETAIFF08()", 0 , 2, 0, .F.})	

Return