/*/{Protheus.doc} GTXFUN01
//TODO Descrição auto-gerada.
@author Pirolo
@since 09/01/2020
@return Boolean, return_description
/*/
User Function GTFUN01A()
Local lRet := .T.

//Completa com zeros a esquerda a variavel relativa ao F1_DOC.
cNFiscal := StrZero(Val(cNFiscal), 9)

Return lRet

/*/{Protheus.doc} GTFUN01B
//TODO Descrição auto-gerada.
@author PIROLO
@since 28/01/2020
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function GTFUN01B()
Local lRet := .T.

//Completa com zeros a esquerda a variavel relativa ao F1_DOC.
M->E2_NUM := StrZero(Val(M->E2_NUM),9,0)

Return lRet

/*/{Protheus.doc} GTFUN01C
//TODO Descrição auto-gerada.
@author PIROLO
@since 28/01/2020
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function GTFUN01C()
Local lRet := .T.

//Completa com zeros a esquerda a variavel relativa ao F1_DOC.
M->E2_FORCTA := StrZero(Val(M->E2_FORCTA),10,0)

Return lRet
