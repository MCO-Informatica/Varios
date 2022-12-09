
#Include "TOTVS.CH"
#Include "RWMAKE.CH"

/*/{Protheus.doc} FA200FIL
Ponto de entrada para substitui��o da pesquisa do T�tulo a Receber.

paramixb: aValores (consultar TDN - https://tdn.totvs.com/x/kKL8J)

@type       Function
@author     TOTVS
@since      25/05/2021
@return     Nil
/*/
User Function FA200FIL()

    Local cNumeroTit    As Character

    cNumeroTit  := paramIXB[1]

	//Sua forma para pesquisa do t�tulo a receber
    SE1->(DbSelectArea("SE1"))
    SE1->(DbSetOrder(16))
    SE1->(DbGoTop())

    If SE1->(DbSeek(FwXFilial("SE1") + SubStr(cNumeroTit, 1, 10)))
        Conout("T�tulo encontrado atrav�s do ponto de entrada FA200FIL!")
    Else
        //S� � permitida a manipula��o da vari�vel lHelp. Caso queira que o help seja exibido, lHelp deve receber .T.
        lHelp       := .F.
        //Vari�veis permitidas para uso, mas que N�O devem ser manipuladas
        //cNumTit     := ""
        //cEspecie    := ""
    EndIf

Return Nil
