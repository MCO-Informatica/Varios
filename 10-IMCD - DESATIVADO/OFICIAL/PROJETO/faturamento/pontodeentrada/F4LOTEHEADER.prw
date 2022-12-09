#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} Manipula o cabe�alho para sele��o de lote
LOCALIZA��O: Function F4Lote() - Respons�vel por fazer a consulta aos
Saldos do Lotes da Rastreabilidade.
EM QUE PONTO: O Ponto de Entrada F4LoteHeader permite manipular o 
cabe�alho a ser usado na consulta F4Lote para sele��o do lote.
@author  marcio.katsumata
@since   04/02/2020
@version 1.0
@param   
/*/
//-------------------------------------------------------------------
user function F4LoteHeader()

    local aHeaderF4 as array

    aHeaderF4 := aClone(PARAMIXB[3])

    //Adicionando o campo observa��o
    aadd(aHeaderF4, "Observacao")

return aHeaderF4