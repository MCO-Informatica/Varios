#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | M410AGRV.PRW         | AUTOR | rdSolution     | DATA | 09/02/2007 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - M410AGRV()                                     |//
//|           | Este ponto esta localizado antes da alteração dos dados do pedido |//
//|           | venda e tem como objetivo guardar nos arrays os dados do pedido   |//
//|           | pedido de venda original.                                         |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////
User Function OM010FIL()

Local cQueryNew  := PARAMIXB[1]
Local cTabint    := ''
Local cTabExt    := ''
Local cBloq      := ''


IF MV_PAR08 == 3
	cTabExt := "('S'" + ",'N'" + ",'')"
ElseIf MV_PAR08 == 2
	cTabExt := "('N')"
Else
	cTabExt := "('S')"
EndIF

IF MV_PAR09 == 3
	cTabInt := "('S'" + ",'N'" + ",'')"
ElseIf MV_PAR09 == 2
	cTabInt := "('N')"
Else
	cTabInt := "('S')"
EndIF

IF MV_PAR10 == 1
	cBloq := "('1'" + ",'2'" + ",'')"
ElseIf MV_PAR10 == 2
	cBloq := "('2'" + ",'')"
EndIF
        
cQueryNew := ''
cQueryNew := "SELECT B1_COD,B1_DESC,B1_PRV1,B1_MSBLQL "
cQueryNew += "FROM "+RetSqlName("SB1")+ " SB1 "
cQueryNew += "WHERE "
cQueryNew += "B1_FILIAL ='"+xFilial("SB1")+"' AND "
cQueryNew += "B1_COD >= '"+mv_par01+"' AND "
cQueryNew += "B1_COD <= '"+mv_par02+"' AND "
cQueryNew += "B1_GRUPO >= '"+mv_par03+"' AND "
cQueryNew += "B1_GRUPO <= '"+mv_par04+"' AND "
cQueryNew += "B1_TIPO >= '"+mv_par05+"' AND "
cQueryNew += "B1_TIPO <= '"+mv_par06+"' AND "
cQueryNew += "B1_TABELA IN "+cTabExt+" AND "
cQueryNew += "B1_TAB_IN IN "+cTabInt+" AND "
cQueryNew += "B1_MSBLQL IN "+cBloq+" AND "
cQueryNew += "SB1.D_E_L_E_T_ = ' '"
cQueryNew += "ORDER BY "+SqlOrder(SB1->(IndexKey()))


Return cQueryNew
