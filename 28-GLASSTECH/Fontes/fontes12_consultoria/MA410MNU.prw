#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MA410MNU
//TODO Ponto de Entrada no inico da Função, antes de montar a ToolBar do Pedido de Compras, deve ser usado para adicionar botões do usuario na toolbar do PC ou AE através do retorno de um Array com a estrutura do botão a adicionar.
@author Douglas Silva
@since 04/10/2021
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function MA410MNU()

aadd(aRotina,{"Triagem de Pedidos","U_GTFAT01",0,7,0,NIL})

Return
