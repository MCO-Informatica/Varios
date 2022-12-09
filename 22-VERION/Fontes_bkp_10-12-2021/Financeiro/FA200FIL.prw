
#Include "TOTVS.CH"
#Include "RWMAKE.CH"

/*/{Protheus.doc} FA200FIL
Ponto de entrada para substituição da pesquisa do Título a Receber.

paramixb: aValores (consultar TDN - https://tdn.totvs.com/x/kKL8J)

@type       Function
@author     TOTVS
@since      25/05/2021
@return     Nil
/*/
User Function FA200FIL()

    Local cNumeroTit    As Character

    cNumeroTit  := paramIXB[1]

	//Sua forma para pesquisa do título a receber
    SE1->(DbSelectArea("SE1"))
    SE1->(DbSetOrder(16))
    SE1->(DbGoTop())

    If SE1->(DbSeek(FwXFilial("SE1") + SubStr(cNumeroTit, 1, 10)))
        Conout("Título encontrado através do ponto de entrada FA200FIL!")
    Else
        //Só é permitida a manipulação da variável lHelp. Caso queira que o help seja exibido, lHelp deve receber .T.
        lHelp       := .F.
        //Variáveis permitidas para uso, mas que NÃO devem ser manipuladas
        //cNumTit     := ""
        //cEspecie    := ""
    EndIf

Return Nil
