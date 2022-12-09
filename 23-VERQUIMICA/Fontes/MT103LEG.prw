#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MT103LEG  | Autor: Celso Ferrone Martins  | Data: 30/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para alterar as cores da Legenda da NF de entrada       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function MT103LEG()

Local aNewLeg := {}

aAdd(aNewLeg, {"ENABLE"    ,"Docto. nao Classificado"})
aAdd(aNewLeg, {"BR_LARANJA","Docto. Bloqueado"})
aAdd(aNewLeg, {"BR_VIOLETA","Doc. C/Bloq. de Mov."})
aAdd(aNewLeg, {"DISABLE"   ,"Docto. Normal"})
aAdd(aNewLeg, {"BR_CINZA"  ,"Docto. de Beneficiamento"})
aAdd(aNewLeg, {"BR_AMARELO","Docto. de Devolucao" })
aAdd(aNewLeg, {"BR_AZUL"   ,"Docto. de Compl. IPI"})
aAdd(aNewLeg, {"BR_MARROM" ,"Docto. de Compl. ICMS"})
aAdd(aNewLeg, {"BR_PINK"   ,"Docto. de Compl. Preco/Frete/Desp. Imp."})
aAdd(aNewLeg, {"BR_BRANCO" ,"Docto. de Frete Nf de Saida"})
aAdd(aNewLeg, {"BR_PRETO"  ,"Docto. em processo de conferencia"})

Return(aNewLeg)