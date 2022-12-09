#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} OM215MNU

Ponto de entrada para disponibilização de nova opção do browse de cadastro de transportadoras.
Com isso, foi inserida nova opção para acesso a tela de etiquetas de rastreio dos correios

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

User Function OM215MNU()

aAdd(aRotina , { 'Etiquetas'	,'U_VNDA560', 0 , 2} )
aAdd(aRotina , { 'Rel. Rastrea','U_VNDR010', 0 , 2} )
aAdd(aRotina , { 'Rel. PLP','U_VNDR020', 0 , 2} )

Return()