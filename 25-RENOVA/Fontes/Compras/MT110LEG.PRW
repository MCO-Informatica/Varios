#include "protheus.ch"
#include "rwmake.ch"
/*
|================================================================|
|Programa.: 	MT110LEG     						    		 |
|Autor....:	Alcouto												 |
|Data.....: 23/06/2021											 |
|Descricao: 	Rotina utilizada incluir legenda para sc não	 |
|  			    enviada para aprovação                           |
|Uso......: 	Renova Energia									 |
|================================================================|
*/

User Function MT110LEG()
Local aCores    := PARAMIXB[1]
Local cCondic   := 'AllTrim(C1_XBLWF) == "S"'
Local cNomeCor := 'BR_VIOLETA'

//Adiciona uma nova linha no array
ASIZE(aCores,Len(aCores)+1)

//Posiciona a linha vazia criada no topo do array
AINS(aCores,1)    

aCores[1]:={cCondic,cNomeCor}

Return (aCores)
