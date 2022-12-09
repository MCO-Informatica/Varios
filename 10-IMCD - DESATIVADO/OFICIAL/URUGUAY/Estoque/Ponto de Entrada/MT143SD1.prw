#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MT143SD1
Este ponto de entrada tem o objetivo de manipular o vetor dos itens que foram 
carregados a partir do registro na tabela DBC para geração do documento de entrada 
do tipo  5-FOB,  ou 8-CIF.
@author Junior Carvalho
@since 05/02/2020
@version 1.0
@param aRet, array, ParamIXB
@type function
@Return aRet
/*/

User Function MT143SD1
Local aRet:= ParamIXB[1]

AAdd(aRet[nItens],{"D1_LOTECTL" , DBC->DBC_XLOTE  , Nil})
AAdd(aRet[nItens],{"D1_DTVALID" , DBC->DBC_XVILOT  , Nil})
AAdd(aRet[nItens],{"D1_DFABRIC" , DBC->DBC_XDTFAB  , Nil})

Return aRet