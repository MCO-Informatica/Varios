#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"


USER FUNCTION A460COL()


Aadd(aHeader,{"Pessoa","E1_XPESSO","@!"               ,01,0,"Pertence('FJ')","û","C","SE1" } )
Aadd(aHeader,{"CPF/CNPJ","E1_XCPF","@R 99.999.999/9999-99",14,0,"CGC(E1_XCPF)","û","C","SE1" } )

Return