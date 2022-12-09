#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} lWsDarez
Rotina de consulta e limpeza de log�s de processamento recebidos pelo web service de integra��o com o faturamento 
@type function
@version 12.1.33 
@author elton.alves@totvs.com.br
@since 25/03/2022
/*/
User Function lWsDarez()

	Local oBrowse := FwLoadBrw("LWSDAREZ")

	oBrowse:Activate()

Return

/*/{Protheus.doc} BrowseDef
Monta a tela de browse da rotina
@type function
@version 12.1,33 
@author elton.alves@totvs.com.br
@since 25/03/2022
@return object, Objeto do Browse
/*/
Static Function BrowseDef()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias("SZ1")
	oBrowse:SetDescription("Log de Processamentos")

	oBrowse:AddLegend("Z1_STATUS=='0'", "GRAY"  , "N�o Processado"         )
	oBrowse:AddLegend("Z1_STATUS=='1'", "GREEN" , "Processado com Sucesso" )
	oBrowse:AddLegend("Z1_STATUS=='2'", "RED"   , "Processado com erros"   )

	oBrowse:SetMenuDef("LWSDAREZ")

Return oBrowse

/*/{Protheus.doc} MenuDef
Monta o array com a lista de rotinas da rotina
@type function
@version 12.1,33 
@author elton.alves@totvs.com.br
@since 25/03/2022
@return array, Array com os itens de menu
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.LWSDAREZ' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'			ACTION 'VIEWDEF.LWSDAREZ' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Limpar Registros' ACTION 'U_DEL_SZ1'     OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Reprocessa'       ACTION 'U_REP_SZ1'     OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Reprocessa Tudo'  ACTION 'U_REP_ALL'     OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Monta o modelo de dados da roina
@type function
@version 12.1,.33 
@author elton.alves@totvs.com.br
@since 25/03/2022
@return object, Objeto do modelo de dados
/*/
Static Function ModelDef()

	Local oModel := MPFormModel():New("MWSDAREZ")

	Local oStruSZ1 := FwFormStruct(1, "SZ1")

	oModel:AddFields("SZ1MASTER", NIL, oStruSZ1)

	oModel:SetDescription("Processamentos")

	oModel:GetModel("SZ1MASTER"):SetDescription("Dados dos Processamentos")

Return oModel

/*/{Protheus.doc} ViewDef
Monta o objeto da view do modelo de dados
@type function
@version 12.1.33 
@author elton.alves@totvs.com.br
@since 25/03/2022
@return object, Objeto da view
/*/
Static Function ViewDef()

	Local oView := FwFormView():New()

	Local oStruSZ1 := FwFormStruct(2, "SZ1")

	Local oModel := FwLoadModel("LWSDAREZ")

	oView:SetModel(oModel)

	oView:AddField("VIEW_SZ1", oStruSZ1, "SZ1MASTER")

	oView:CreateHorizontalBox("TELA" , 100)

	oView:SetOwnerView("VIEW_SZ1", "TELA")

Return oView

/*/{Protheus.doc} DEL_SZ1
Rotina que exclui log�s dos registros considerando a data de inclus�o, processamento e status
@type function
@version 12.1.33 
@author elton.alves@totvs.com.br
@since 25/03/2022
/*/
user function DEL_SZ1()

	local cCommand   := ''
	local cDtIncInic := ''
	local cDtIncFim  := ''
	local cDtPrcInic := ''
	local cDtPrcFim  := ''
	local lDelNoProc := .F.

	local cInList    := '1/2'
	local nStatus    := 0

	if Pergunte( 'LWSDAREZ', .T. )

		cDtIncInic := DtoS( MV_PAR01 )
		cDtIncFim  := DtoS( MV_PAR02 )
		cDtPrcInic := DtoS( MV_PAR03 )
		cDtPrcFim  := DtoS( MV_PAR04 )
		lDelNoProc := MV_PAR05 == 1

		cCommand += " UPDATE "  + RetSqlName( 'SZ1' ) + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
		cCommand += " WHERE Z1_DATAINC BETWEEN '" + cDtIncInic  + "' AND '" + cDtIncFim + "' "
		cCommand += " AND   Z1_DATAPRC BETWEEN '" + cDtPrcInic  + "' AND '" + cDtPrcFim + "' "

		if lDelNoProc

			cCommand += " OR Z1_DATAPRC = '" + Space( TamSx3( "Z1_DATAPRC" )[1] ) + "' "

			cInList := '0/' + cInList

		end if

		cCommand += " AND Z1_STATUS IN " + FormatIn( cInList, '/' )

		nStatus := TCSqlExec( cCommand )

		if nStatus < 0

			ApMsgStop( 'Um erro impediu que a limpeza fosse executada.' )

			autoGrLog( TCSQLError() )

			mostraErro()

		else

			ApMsgInfo( 'Limpeza executada com sucesso.' )

		end if

	end if

return

/*/{Protheus.doc} REP_SZ1
Permite o reprocessamento de uma requsi��o processada com erro.
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 16/05/2022
/*/
user function REP_SZ1()


	if SZ1->Z1_STATUS == '2' .or. SZ1->Z1_STATUS == '0'

		MsgRun("Aguarde...", "Reprocessando requisi��o.", {|| U_pWsDarez( SZ1->Z1_UUID ) })

	else

		ApMsgAlert( 'O reprocessamento s� � permitido para requisi��es com erro. ', 'Aten��o')

	end if

return

/*/{Protheus.doc} getPdShp
Fun��o a ser utilizada no incializador padr�o no inicializador do browse do campo Z1_PEDSHOP, para exibir o n�mero
do pedido shopfy quando SZ1->Z1_ROTINA == 'MATA410'
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 17/05/2022
@return characterer , retorna o c�digo do pedido se SZ1->Z1_ROTINA == 'MATA410' e branco se SZ1->Z1_ROTINA != 'MATA410'
/*/
user function getPdShp()

	if allTrim( SZ1->Z1_ROTINA ) == 'MATA410'

		jPedido := jsonObject():new()
		jPedido:fromJson( SZ1->Z1_BODYMSG )
		
		return jPedido:C5_XPEDSHP

	end if

return ''


User Function REP_ALL()


Processa( {|| FAZ_ALL() }, "Aguarde...", "Reprocessando registros com erro SZ1...",.F.)
RETURN

Static Function FAZ_ALL()

	local cAlias := "SZ1ALL"

	If Select(cAlias) <> 0
		(cAlias)->(DbCloseArea())
	EndIf

	BeginSql alias cAlias
       
        SELECT SZ1.Z1_UUID FROM %TABLE:SZ1% SZ1
        
        WHERE SZ1.%NOTDEL%
		AND SZ1.Z1_FILIAL = %XFILIAL:SZ1%
        AND (SZ1.Z1_STATUS = '0' OR SZ1.Z1_STATUS = '2')
       
	EndSql

	( cAlias )->( DbGoTop() )


	ProcRegua(RecCount())  

	while ! ( cAlias )->( Eof() )

		IncProc("Reprocessando todos os registros com erro - SZ1")

		U_pWsDarez( ( cAlias )->Z1_UUID )

		( cAlias )->( DbSkip() )

	end

	( cAlias )->( DbCloseArea() )

return

