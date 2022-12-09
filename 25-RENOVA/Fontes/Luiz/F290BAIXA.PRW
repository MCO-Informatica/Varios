#include 'protheus.ch'

// Se durante a baixa dos titulos origem para gerar fatura(s), existir pelo menos
// um título origem que seja anterior a RJ, a(s) fatura(s) deve(m) ser gerada(s) 
// Bloqueado(s) 

User Function F290BAIXA()

if SE2->E2_EMISSAO <= CtoD("16/10/2019")
   lBloqueioRJ := .T. 
endif

Return(" ")
