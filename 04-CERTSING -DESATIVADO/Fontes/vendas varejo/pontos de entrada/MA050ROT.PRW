#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MA050ROT

Ponto de entrada para Incusão de nova opção para consulta de etiquetas dos correios no cadastro de transportadoras.

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

User Function MA050ROT()

Local aRotUser := {}  
  
aAdd(aRotUser , { 'Rastreamento','U_VNDA540', 0 , 2} )

Return(aRotUser)
