/*Descri??o:
O ponto de entrada F090FILEMI tem como finalidade permitir ao cliente customizar qual campo de data de
emiss?o ser? considerado no filtro dos t?tulos trazidos para a baixa autom?tica.
No RdMake ele deve retornar qual campo do SE2 se quer utilizar no filtro de data de emiss?o da baixa a
pagar.
Eventos
  */
  
#include "PROTHEUS.CH"
#include "RWMAKE.CH"  

User Function F090FILEMI    

Return "E2_EMISSAO"