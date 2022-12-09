#include 'protheus.ch'


/*/{Protheus.doc} MT120FIM
LOCALIZAÇÃO: O ponto se encontra no final da função A120PEDIDO
EM QUE PONTO: Após a restauração do filtro da FilBrowse depois 
de fechar a operação realizada no pedido de compras, é a ultima 
instrução da função A120Pedido.
@type function
@version 1.0
@author marcio.katsumata
@since 26/08/2020
@return return_type, return_description
@see    https://tdn.totvs.com/display/public/PROT/MT120FIM
/*/
User Function MT120FIM()

	Local cNumPed   as character
	Local cQuery    as character
	Local cAliasTrb as character
	local nOpcao    as numeric
	local cRecnos   as character
	local nInd      as numeric
	local cDeleted  as character
	local aAreas    as array

	If PARAMIXB[3] == 0

		Return()

	Endif

	aAreas := {SCR->(getArea()), getArea()}
	cNumPed   := PARAMIXB[2]
	cQuery    := ""
	cAliasTrb := GetNextAlias()
	nOpcao    := PARAMIXB[1]



	dbSelectArea("SCR")

	//-------------------------------------------------
	//Verifica se existe pedidos bloqueados por alçada
	//porém com a SCR deletadas, apenas na inclusão
	//-------------------------------------------------
	if (type("inclui") == 'L' .and. Inclui ) .OR. nOpcao == 3 .OR. nOpcao == 9 .OR. ( type("aMTA120G1") == "A" .and. empty(aMTA120G1[1]) .and. empty(aMTA120G1[2]) )

		cQuery := " SELECT SCR.R_E_C_N_O_ AS REGISTRO FROM " +RetSqlName("SCR")+ " SCR "
		cQuery += " INNER JOIN "+retSqlName("SC7")+" SC7 ON(SC7.C7_NUM ='"+cNumPed+"' "
		cQuery += " AND SC7.C7_FILIAL ='"+xFilial("SC7")+"'AND SC7.D_E_L_E_T_ = ' ' AND SC7.C7_CONAPRO = 'B' )"
		cQuery += " WHERE SCR.D_E_L_E_T_ = '*' AND SCR.CR_NUM  = '"+cNumPed+"' AND SCR.CR_FILIAL= '"+xFilial("SCR")+"' "

		DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),cAliasTrb,.T.,.F.)

		while (cAliasTrb)->(!eof())

			SCR->(dbGoTo((cAliasTrb)->REGISTRO))
			reclock("SCR", .F.)
			SCR->(dbRecall())
			SCR->(MsUnlock())

			(cAliasTrb)->(dbSkip())

		enddo

		(cAliasTrb)->(dbCloseArea())
	else

		if type("lMTA120G1") == "L" .and. lMTA120G1

			cDeleted := ArrTokStr(aMTA120G1[2], ",")
			cRecnos := ArrTokStr(aMTA120G1[1], ",")

			if !empty(cDeleted)
				cRecnos += ","+cDeleted
			endif

			cQuery := " SELECT R_E_C_N_O_ AS REGISTRO FROM "+RetSqlName("SCR")
			cQuery += " WHERE D_E_L_E_T_ = '*' AND CR_NUM  = '"+cNumPed+"' AND CR_FILIAL= '"+xFilial("SCR")+"' AND R_E_C_N_O_ NOT IN ("+cRecnos+") "

			DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),cAliasTrb,.T.,.F.)

			while (cAliasTrb)->(!eof())

				SCR->(dbGoTo((cAliasTrb)->REGISTRO))
				reclock("SCR", .F.)
				SCR->(dbRecall())
				SCR->(MsUnlock())
				(cAliasTrb)->(dbSkip())
			enddo

			(cAliasTrb)->(dbCloseArea())
		else
			if type("aMTA120G1") == "A"
				for nInd:= 1 to len(aMTA120G1[1])
					SCR->(dbGoTo(val(aMTA120G1[1][nInd])))
					reclock("SCR", .F.)
					SCR->(dbRecall())
					SCR->(MsUnlock())

				next nInd
			endif
		endif
	endif

	aEval(aAreas,{|aArea|restArea(aArea)})
	aSize(aAreas,0)

return
