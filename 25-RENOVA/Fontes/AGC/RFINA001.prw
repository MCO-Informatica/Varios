#INCLUDE 'TOTVS.CH'
#Include "rwmake.ch"
#Include 'FWMVCDef.ch'

/*==========================================================
= Rotina para cálculo do valor principal acrescido dos juros 
= para uso na rotina de geração do arquivo remessa CNAB a
= pagar
= Utilizar nos arquivos de configuração do CNAB
= Autor: Luiz M Suguiura

  Santander - SANTANDE.2PE:
     STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,15)
 
  Sispag - ITAUPAGE.PAG:
  IIF((SEA->EA_MODELO)=="30",FORMULA("004"),FORMULA("005"))
 
      Formula 004 - STRZERO((SE2->(E2_SALDO-E2_DECRESC+E2_ACRESC))*100,15)
      Formula 005 - STRZERO((SE2->(E2_VALOR-E2_DECRESC+E2_ACRESC))*100,15)

*///========================================================

user function RFINA001()

Local nJuros     := 0   
Local nAtraso    := 0
Local nPrincipal := 0

/* BLOCO DESBILITADO POIS O SEGMENTO J NÃO SERÁ UTILIZADO - PARA UTILIZAR, DESCOMENTAR E INCLUIR PARAMETRO 
user function RFINA001(cMod)
Default cMod := "30"

if cMod = "31"
   nPrincipal := SE2->E2_VALOR
else
   nPrincipal := SE2->E2_SALDO     STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC+U_RFINA001())*100,15)
endif
*/ 

nPrincipal := SE2->E2_SALDO

nAtraso := SE2->E2_VENCREA - SE2->E2_VENCTO

if DOW(SE2->E2_VENCTO) = 1 .or. DOW(SE2->E2_VENCTO) = 7     // Vencimento Sábado ou Domingo
   if nAtraso <=2                                           // Atraso sendo menor que dois dias, significa que houve alteração
      nAtraso := 0                                          // padrão por ser final de semana e não devido ao PRJ
   endif                                                    // Considerar somente se a diferença de dias 1 ou 2
endif

nJuros := round(((SE2->E2_PORCJUR / 100) * nAtraso) * nPrincipal, 2)  // Retorno da função

nPrincipal := nPrincipal + nJuros

return(nJuros) 

