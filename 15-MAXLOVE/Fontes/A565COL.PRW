#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"


USER FUNCTION A565COL()


Aadd(aHeader,{"Pessoa"   ,"E2_XPESSO","@!"                   ,01,0,"Pertence('FJ')","û","C","SE1" } )
Aadd(aHeader,{"CPF/CNPJ" ,"E2_XCPF"  ,"@R 99.999.999/9999-99",14,0,"CGC(E2_XCPF)","û","C","SE1" } )
Aadd(aHeader,{"Historico","E2_HIST"  ,"@!"                   ,50,0,"","û","C","SE1" } )

Return