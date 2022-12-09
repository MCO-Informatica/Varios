#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | MTA440C5.PRW         | AUTOR | GENILSON LUCAS | DATA | 26/08/2010 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - MTA440C5()                                     |//
//|           | Este ponto esta localizado antes da liberação do pedido para o    |//
//|           | faturamento, afim de possibilitar a alteração do campo C5_X_MENRO |//
//|           | 							                                      |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////
                   

User Function MTA440C5()

Local aCampos	 := {}     
aCampos := {"C5_X_MENRO"} //Array com os campos

Return(aCampos)     
