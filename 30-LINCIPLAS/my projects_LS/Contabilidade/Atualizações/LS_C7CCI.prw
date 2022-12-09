#Include "topconn.CH"
#Include "rwmake.CH"
#Include "protheus.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INICIALIZADOR DOS CAMPOS DE CENTRO DE CUSTO
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CCINIT()
////////////////////////
                                             
_cQuery := "SELECT MAX(CTT_CUSTO) CTT_CUSTO"
_cQuery += " FROM " + RetSqlName('CTT') + " CTT (NOLOCK)"
_cQuery += " WHERE CTT_DESC03 LIKE '%" + cFilAnt + "%'"
_cQuery += " AND CTT.D_E_L_E_T_ = ''"
_cQuery += " AND CTT_DTEXSF = ''"
_cQuery += " AND CTT_CLASSE = '2'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)

_cCusto :=  TRB->CTT_CUSTO
DbCloseArea()

Return(_cCusto)


/*

X3_RELACAO (D1_CC,C7_CC, C6_CC)

iif(cfilAnt $ '01/A0/C0/BH/G0/R0/T0', '', U_LS_CCINIT())

X3_VLDUSER
if(!cFilAnt$CTT->CTT_DESC03,Aviso('Pedido de Compras','CC invalido para esta filial',{'OK'},2,'Pedidos de Compra')=9,.t.)       
*/