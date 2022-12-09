/*Descrição:
O ponto de entrada F090FILEMI tem como finalidade permitir ao cliente customizar qual campo de data de
emissão será considerado no filtro dos títulos trazidos para a baixa automática.
No RdMake ele deve retornar qual campo do SE2 se quer utilizar no filtro de data de emissão da baixa a
pagar.
Eventos
  */
  
#include "PROTHEUS.CH"
#include "RWMAKE.CH"  

User Function F090FILEMI    

Return "E2_EMISSAO"