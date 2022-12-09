#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

//FUNÇÃO QUE EXECUTA LOGO APÓS A PRIMEIRA PESSOA LOGA NO SISTEMA E CONFIRMA AS MOEDAS

User Function MGETMOED()

u_CCIMOEDA(.F.)

MsgAlert("ATUALIZAR TAXA PTAX DANDO OK ")

M->M2_MOEDA2     :=  SM2->M2_MOEDA2
M->M2_MOEDA3     :=  SM2->M2_MOEDA3 
M->M2_MOEDA4     :=  SM2->M2_MOEDA4 
M->M2_MOEDA5     :=  SM2->M2_MOEDA5 
M->M2_MOEDA6     :=  SM2->M2_MOEDA6 
If !cEmpAnt$"04"
	M->M2_MOEDA7    :=  SM2->M2_MOEDA7 
EndIf
		
  
Return  

