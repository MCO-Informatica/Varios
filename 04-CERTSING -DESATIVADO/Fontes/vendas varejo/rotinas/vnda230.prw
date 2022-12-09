#INCLUDE "Protheus.ch" 
#Include "TopConn.ch"

// GATILHO DO CAMPO ZF_PEDIDO PARA PREENCHER O NUMERO DA NOTA NO CAMPO ZF_PEDVEND


User Function VNDA230(cPedGar)

Local cPedido := ""
Local cSqlRet := ""


cSqlRet := "SELECT SC6.C6_NUM FROM " + RetSqlName("SC6") + " SC6"
cSqlRet += " WHERE SC6.C6_FILIAL = '" + xFilial("SC6") +"' AND SC6.C6_PEDGAR = '"+ Alltrim(cPedGar);
		+"' AND SC6.D_E_L_E_T_ <> '*'"
		

cSqlRet := ChangeQuery(cSqlRet)
TCQUERY cSqlRet NEW ALIAS "TMPSC6"


DbSelectArea("TMPSC6")

If TMPSC6->(!Eof())
	TMPSC6->(DbGoTop())
	cPedido := Alltrim(TMPSC6->C6_NUM)
Endif

DbSelectArea("TMPSC6")
TMPSC6->(DbCloseArea())       
		


Return cPedido