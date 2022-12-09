#Include 'Protheus.ch'
#Include "TopConn.ch"

/*/{Protheus.doc} F460SE1
P.E - Informa dados complementares do t�tulo no processo de Liquida��o - VNDA600

@author Rafael Beghini
@since 12/04/2019
@version P12
/*/
User Function F460SE1()
    Local aArea := GetArea()
    Local aTRB  := U_A600E1COMP()
    RestArea( aArea )
Return( aTRB )