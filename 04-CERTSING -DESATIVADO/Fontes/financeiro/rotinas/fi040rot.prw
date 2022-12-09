#Include "Totvs.ch"

User Function FI040ROT              

Local aRotina := ParamIxb

aadd(aRotina,{'Rastrear LP',"U_CSCTB01('SE1',SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_EMISSAO,SE1->(RECNO()))",0,3,0,NIL})

Return aRotina                                        