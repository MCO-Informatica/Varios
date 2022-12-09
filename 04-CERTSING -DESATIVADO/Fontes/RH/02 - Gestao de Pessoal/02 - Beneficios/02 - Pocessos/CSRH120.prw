#Include 'Protheus.ch'

/*/{Protheus.doc} CSRH120
Benefícios - Ajusta verba de dependente, por falha em roteiro de calculo padrão
de plano de saúde, a verba de dependente e agregado esta errado.
OTRS - 2017122710001215 
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17 
@return null, Nulo
/*/
User Function CSRH120()
	Local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	Local cQuery  	:= '' 	//Query SQL
	Local lExeChange 	:= .T. //Executa o change Query
	Local nRec 		:= 0 	//Numero Total de Registros da consulta SQL
	Local cChaveRHK	:= ''
	Local cChaveRHR	:= ''

	//Seleciona somente dependentes e agregados	
	cQuery += " SELECT * FROM "
	cQuery += " "+RetSQLName("RHR")+" "+CRLF
	cQuery += " WHERE D_E_L_E_T_ =  ' ' "
	cQuery += "	AND RHR_CODIGO <> ' ' "
	cQuery += "	AND RHR_COMPPG = '"+RCH->RCH_PER+"' "
	cQuery += "	AND RHR_FILIAL = '"+SRA->RA_FILIAL+"' "
	cQuery += "	AND RHR_MAT    = '"+SRA->RA_MAT+"'	"

	If U_MontarSQL(cAlias, @nRec, cQuery, lExeChange)
		RHK->(dbSetOrder(1))
		RHR->(dbSetOrder(1))
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			cChaveRHK := (cAlias)->(RHR_FILIAL+RHR_MAT+RHR_TPFORN+RHR_CODFOR)
			cChaveRHR := (cAlias)->(RHR_FILIAL+RHR_MAT+RHR_COMPPG+RHR_ORIGEM+RHR_CODIGO+RHR_TPLAN+RHR_TPFORN+RHR_CODFOR+RHR_TPPLAN+RHR_PLANO+RHR_PD)
			if RHK->(dbSeek(cChaveRHK)) .and. RHR->(dbSeek(cChaveRHR)) 
				if 	RHK->RHK_PDDAGR != RHR->RHR_PD				
					RecLock('RHR', .F.)
					RHR->RHR_PD := RHK->RHK_PDDAGR 
					RHR->(MsUnLock())
				endif				
			endif
			(cAlias)->(DbSkip())
		EndDo
		
		(cAlias)->(DbCloseArea())
	endif
Return

