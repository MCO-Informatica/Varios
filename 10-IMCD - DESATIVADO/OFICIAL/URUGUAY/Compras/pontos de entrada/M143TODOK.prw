#include 'protheus.ch'

/*/{Protheus.doc} M143TODOK
Punto de entrada antes de la grabación del registro
de doc. de entrada MATA143(Despacho)
@type function
@version 1.0
@author marcio.katsumata
@since 26/03/2020
@return logical, validación
/*/
user function M143TODOK()
    local lRetorno as logical
    
    //--------------------------------
    //Realiza a limpeza da variável 
    //global __cInternet
    //--------------------------------
    u_limpaMata143()

    //-------------------------------------------
    //Verifica se el campo Fecha Decl. (DATA DI)
    //esta preenchido
    //-------------------------------------------
    if !(lRetorno := !empty(M->DBA_DT_AVE))
        aviso("VALIDACIÓN INVOICE", "Verifique la fecha de declaración, este campo es obligatorio", {"Cancelar"}, 1)
    endif


return lRetorno 