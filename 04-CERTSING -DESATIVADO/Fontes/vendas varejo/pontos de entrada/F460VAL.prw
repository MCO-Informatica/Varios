#Include 'Protheus.ch'
#Include "TopConn.ch"

/*/{Protheus.doc} F460VAL
P.E - Grava dados complementares do título no processo de Liquidação - VNDA600

@author Rafael Beghini
@since 12/04/2019
@version P12
/*/
User Function F460VAL()
    Local aArea := GetArea()
    SE1->E1_OCORREN := ParamIXB[ 1 ]
    SE1->E1_ORIGPV  := ParamIXB[ 2 ]
    RestArea( aArea )
Return