#Include 'Protheus.ch'

/*/{Protheus.doc} RESTG05
Fonte Customizado para calcular a DENSIDADE da Rotina Movimento Interno.
@type User Function
@version 12.2.33
@author Anderson Martins
@since 8/31/2022
/*/

User Function RESTG05()

Local nQuant    := aCols[n,Ascan(aHeader, {|x|, Upper(Alltrim(x[2])) == "D4_QUANT" })]
Local nDensid   := aCols[n,Ascan(aHeader, {|x|, Upper(Alltrim(x[2])) == "D4_XDENSID" })]
Local c2UM      := Posicione("SB1",1,xFilial("SB1")+aCols[n,Ascan(aHeader, {|x|, Upper(Alltrim(x[2])) == "D4_COD" })],"B1_SEGUM")
Local lRet      := ""

IF !EMPTY(c2UM)

    lRet := nQuant * nDensid

ELSE

    Alert("Produto não possui 2ª Unidade de Medida cadastrada!")
    aCols[n,Ascan(aHeader, {|x|, Upper(Alltrim(x[2])) == "D4_XDENSID" })] := 0
    lRet    := 0

ENDIF

Return lRet
