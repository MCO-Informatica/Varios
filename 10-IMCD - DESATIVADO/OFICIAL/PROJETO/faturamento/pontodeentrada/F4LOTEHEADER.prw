#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} Manipula o cabeçalho para seleção de lote
LOCALIZAÇÃO: Function F4Lote() - Responsável por fazer a consulta aos
Saldos do Lotes da Rastreabilidade.
EM QUE PONTO: O Ponto de Entrada F4LoteHeader permite manipular o 
cabeçalho a ser usado na consulta F4Lote para seleção do lote.
@author  marcio.katsumata
@since   04/02/2020
@version 1.0
@param   
/*/
//-------------------------------------------------------------------
user function F4LoteHeader()

    local aHeaderF4 as array

    aHeaderF4 := aClone(PARAMIXB[3])

    //Adicionando o campo observação
    aadd(aHeaderF4, "Observacao")

return aHeaderF4