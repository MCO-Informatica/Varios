#include "rwmake.ch"

/*/{Protheus.doc} User Function zSchedule
    (long_description)
    @type  Function
    @author user
    @since 13/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function zSchedule()
    u_EvOCA()
    U_EvOCA2()
    U_zCPCEnvM()
Return 


Static Function SchedDef()

    Local aOrd      := {}
    Local aParam    := {}

    aParam := { "P" ,;
    "PARAMDEF"      ,;
    ""              ,;
    aOrd            ,;
    } 
    
Return aParam
