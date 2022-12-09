#INCLUDE "rwmake.ch"

/*/{Protheus.doc} tsts
//TODO Descrição auto-gerada.
@author rickson.oliveira
@since 04/03/2021
@version 1.0
@ECOPRO
@return ${return}, ${return_description}
@type function
/*/

User Function SF2460I

    _aArea:= GetArea()
        
    RecLock("SF2",.f.)
    SF2->F2_XNOMCLI := Iif(SF2->F2_TIPO$"BD",POSICIONE("SA2",1,XFILIAL("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA, "A2_NREDUZ"),POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA, "A1_NOME"))
    MsUnLock()

RestArea(_aArea)

Return
