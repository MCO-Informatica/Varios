#INCLUDE "PROTHEUS.CH"
#INCLUDE "rWmaKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc}  function
description
@author  author
@since   date?
@version version
/*/
//-------------------------------------------------------------------

USER FUNCTION ALTVAL ()

Local aArea         := GetArea()
Local cPrefixo      := "VL "
Local cNum          := TamSx3("E2_NUM")[1]
Local cFornece      := "000000"
Local cLoja         := "00"
Local nValor        := 0

Pergunte("XALTVALE",.T.)

cNum      := Alltrim(MV_PAR01)
cFornece  := Alltrim(MV_PAR02)
cLoja     := MV_PAR03 
nValor    := MV_PAR04 //Valor Parcela



//Selecionando a Tabela
dbSelectArea ('SE2')

//Posicionando Indice 6 E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO
SE2->(dbSetOrder(6))

//Condição
    If SE2->(DbSeek (xFilial('SE2')+ cFornece + cLoja + cPrefixo + cNum ))

        While (Eof() == .f.) .and. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == (xFilial('SE2')+ cFornece + cLoja + cPrefixo + cNum )

                If nValor <= 0
                    Alert("Valor da Parcela Incorreto")
                EndIf

            If Alltrim(SE2->E2_TIPO)$"VL " .and. nValor > 0

                RecLock('SE2', .F.)
                SE2->E2_VALOR  := nValor  
                SE2->E2_VLCRUZ := nValor
                SE2->E2_SALDO  := nValor
                SE2->(MsUnlock())
            Endif

            SE2->(DBSkip())
        
        End

    Alert("Alteração Efetuada")   

    Else
        Alert("Titulo Não Encontrado!!!")
    Endif

RestArea(aArea)

Return

