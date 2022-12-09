#include 'protheus.ch'


/*/{Protheus.doc} M460MARK
O ponto de entrada M460MARK � utilizado para validar os pedidos marcados 
e est� localizado no in�cio da fun��o a460Nota (endere�a rotinas para a 
gera��o dos arquivos SD2/SF2).
Ser� informado no terceiro par�metro a s�rie selecionada na gera��o da 
nota e o n�mero da nota fiscal poder� ser verificado pela vari�vel private 
cNumero.
@type function
@version 1.0
@author marcio.katsumata
@since 13/04/2020
@return return_type, return_description
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6784189
/*/
user function M460MARK ()
    local lRetorno as logical
    local aAreaTrb as array
    local cMarca460 as character


    cMarca460 := PARAMIXB[1]
    aAreaTrb  := getArea()
    lRetorno  := .T.

    TRB->(dbGoTop())

    while TRB->(!eof())

        if TRB->C9_OK == cMarca460

            //---------------------------------------------
            //Realiza a valida��o do shelf life do lote.
            //----------------------------------------------
            if !u_validaShelfLife(TRB->C9_CLIENTE,TRB->C9_LOJA,TRB->C9_PEDIDO,TRB->C9_ITEM,TRB->C9_PRODUTO,;
                                  TRB->C9_LOCAL, TRB->C9_LOTECTL, TRB->C9_QTDLIB,.t.)
                lRetorno := .F.
            endif

        endif

        TRB->(dbSkip())

    enddo


    restArea(aAreaTrb)
    aSize(aAreaTrb,0)


return lRetorno