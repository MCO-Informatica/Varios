#Include 'Protheus.ch'

User Function F040RAUTO()
Local aParam := PARAMIXB
Local aAux := PARAMIXB[1]

//Centro de Custo.
//aAdd(aAux,{"E1_CCUSTO","998800000", Nil})
//Conta Contabil.
//aAdd(aAux,{"E1_CONTAD","1000011", Nil})

//Natureza.
aAdd(aAux,{"E1_NATUREZ","61001", Nil})

Return aAux
