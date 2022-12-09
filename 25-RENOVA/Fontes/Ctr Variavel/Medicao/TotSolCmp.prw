#Include "Protheus.ch"
#Include "TopConn.ch"



/*/{Protheus.doc} TotSolCmp
Função para totalizar o valor estimado da solicitação de compra
@type User_function
@version  1
@author Junior Placido
@since 14/04/2021
@param cSCNum, character, numero_solicitacao_compra
@return Numeric, total_SC
/*/
User Function TotSolCmp(cSCNum)
	Local cSql := ""

	//Default cSCNum := '000006'

	cSql := "SELECT SUM(C1_VLESTIM) TOTAL FROM "+RetSqlName("SC1")+" SC1 WHERE SC1.D_E_L_E_T_<>'*' AND C1_NUM = '"+cSCNum+"' "

	If Select("QRY") > 0  //Verifica se a Alias temporaria não existe
		QRY->(DbCloseArea())
	EndIf

	TCQuery cSql New Alias "QRY" //Novo Alias temporario

	nTotal := QRY->TOTAL //Armazena Total

	If Select("QRY") > 0
		QRY->(DbCloseArea()) //Fecha tabela temporaria
	EndIf

	AltSC1(cSCNum)

Return nTotal



/*
Ajusta os campos de contrato na solicitação, ao informa-la no contrato e remove de outras solicitações em que
o contrato esteja amarrado, considerando que a solicitação amarrada não aparece na lista para ser selecionada
então foi amarrada anteriormente no contrato e o mesmo foi alterado após a gravação dos campos na SC1,
também considerando que não é possivel associar a mesma solicitação em diversos contratos
*/
Static Function AltSC1(cSCNum)
Local cSql := ""


	cSql := "UPDATE "+RetSqlName("SC1")+" SC1 SET SC1.C1_XCONTRA = ' ', SC1.C1_FLAGGCT = ' ' WHERE SC1.D_E_L_E_T_<>'*' AND SC1.C1_NUM <> '"+cSCNum+"' AND SC1.C1_XCONTRA = '"+M->CN9_NUMERO+"' "
	TcSqlExec(cSql)

	cSql := "UPDATE "+RetSqlName("SC1")+" SC1 SET SC1.C1_XCONTRA = '"+M->CN9_NUMERO+"', SC1.C1_FLAGGCT = '1' WHERE SC1.D_E_L_E_T_<>'*' AND SC1.C1_NUM = '"+cSCNum+"' "
	TcSqlExec(cSql)

Return
