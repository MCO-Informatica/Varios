#Include "Protheus.ch"
#Include "Ap5Mail.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"

#Define cEVENTO_VERIFICACAO 	 "GETVERGAR"
#Define cEVENTO_VALIDACAO 		 "GETVLDGAR"
#Define cEVENTO_EMISSAO 		 "GETEMIGAR"
#Define cEVENTO_ENVIA_PEDIDO_GAR "ENVIA-PEDIDO-GAR"
#Define lPARAMETROS 			 .T.

/*/{Protheus.doc} GAR
@author    bruno.nunes
@since     09/01/2021
@version   P12
/*/   
class ProcessamentoHUB
	data aListaPendente		as array
	data aParametros		as array
	data oLog				as object	
	data cQueryWhere		as string
	data lVisual			as logical

	method New() constructor
	method GetListaPendentes()
	method ProcessarLista( aLista )
	method ProcessarEvento( cEvento, cXML )
	method SetParametros( aListaGAR, dDataDe, dDataAte )
	method ShowParametros()
	method ProcessarVisual()
endclass

/*/{Protheus.doc} New
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method New() class ProcessamentoHUB as object
	::aListaPendente := {}
	::cQueryWhere 	 := ""
	::oLog := CSLog():New()
return self

/*/{Protheus.doc} SetParametros
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method SetParametros( aParam ) class ProcessamentoHUB as logical
	local i := 1
	local nTotal := 0
	local aListaGAR := {}
	local dDataDe   := ctod( "//" )
	local dDataAte  := ctod( "//" )
	
	default aParam := {}
	
	if len( aParam ) > 2
		if !empty( aParam[ 1 ] )
        	aListaGAR := StrToArray( aParam[ 1 ], CHR( 13 ) + CHR( 10 ) )
		endif
		if !empty( aParam[ 2 ] )
			dDataDe := aParam[ 2 ]
		endif
		if !empty( aParam[ 3 ] )
			dDataAte := aParam[ 3 ]
		endif
	endif

	::cQueryWhere := ""
	if len( aListaGAR ) > 0 
		::cQueryWhere += " AND PC3_PEDGAR IN ( "
		nTotal := len( aListaGAR )
		for i := 1 to nTotal
			if i != 1
				::cQueryWhere += ","
			endif
			::cQueryWhere += "'" + aListaGAR[ i ] + "'"
		next i
		::cQueryWhere += " ) "
	endif
	if  !empty( dDataDe ) 
		::cQueryWhere += " AND PC3_DATINC >= '" + DtoS( dDataDe ) + "'"
	endif
	if  !empty( dDataAte )
		::cQueryWhere += " AND PC3_DATINC <= '" + DtoS( dDataAte ) + "'"
	endif

return !empty( ::cQueryWhere )

/*/{Protheus.doc} ShowParametros
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method ShowParametros() class ProcessamentoHUB as logical
	local aPerguntas := {}
	local aRet := {}	
	local lRetorno := .F.

	aAdd( aPerguntas, { 11, "Pedidos GAR", "", ".T.", ".T.", .F.} ) //MultiGet 
	aAdd( aPerguntas, {  1, "Data de Inclusão De:"  , Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
	aAdd( aPerguntas, {  1, "Data de Inclusão Até:" , Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
    If lRetorno := Parambox( aPerguntas, "Parâmetros: Processo Lote", @aRet)
		lRetorno := ::SetParametros( aRet )
    EndIf	
return lRetorno

/*/{Protheus.doc} GetListaPendentes
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method GetListaPendentes( lShowPergs ) class ProcessamentoHUB as logical
	local aPendente := {}
	local cQuery    := ""
	local cAliasPC3 := ""
	local oSQL      := CSQuerySQL():New()
	local lProcessa := .T.

	default lShowPergs := .F.

	::aListaPendente := {}
	::lVisual := lShowPergs

	if lShowPergs
		lProcessa := ::ShowParametros()
	endif	

	if lProcessa
		cQuery := " SELECT "
		cQuery += " 	PC3_PEDGAR "
		cQuery += " FROM "
		cQuery += " 	" + RetSqlName( "PC3" ) + " PC3 "
		cQuery += " WHERE "
		cQuery += " 	PC3.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND ( 
		cQuery += " 			PC3.PC3_STPEGA = '2' OR "
		cQuery += " 			PC3.PC3_STAVLD = '2' OR "
		cQuery += " 			PC3.PC3_STAVER = '2' OR "
		cQuery += " 			PC3.PC3_STAEMI = '2' "
		cQuery += " 	) "
		if !empty( ::cQueryWhere )
			cQuery += ::cQueryWhere
		endif
		cQuery += " ORDER BY PC3.PC3_DATINC "
		if empty( ::cQueryWhere )
			cQuery += " FETCH FIRST 100 ROWS ONLY "
		endif		

		if oSQL:Consultar( cQuery )
			cAliasPC3 := oSQL:GetAlias()

			while ( cAliasPC3 )->( !EoF() )
				if PC3->( dbSeek( xFilial( "PC3" ) + ( cAliasPC3 )->PC3_PEDGAR ) )
					aPendente := {}

					aAdd( aPendente, PC3->PC3_PEDGAR ) //1
					aAdd( aPendente, PC3->PC3_ENPEGA ) //2
					aAdd( aPendente, PC3->PC3_VLDGAR ) //3
					aAdd( aPendente, PC3->PC3_VERGAR ) //4
					aAdd( aPendente, PC3->PC3_EMIGAR ) //5

					aAdd( ::aListaPendente, aPendente )
				endif
				( cAliasPC3 )->( dbSkip() )
			end
			( cAliasPC3 )->( dbCloseArea() )
		endif
	endif

return len( ::aListaPendente ) > 0

/*/{Protheus.doc} ProcessarLista
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method ProcessarLista( aLista ) class ProcessamentoHUB as Undefinied
	local aPendente  := {}
	local aLog		 := {}
	local i          := 0
	local nPendentes := 0

	default aLista := {}

	if len( aLista ) > 0
		::aListaPendente := aLista
	endif
	nPendentes := len( ::aListaPendente )

	if nPendentes > 0
		::oLog:SetAssunto( "[ ProcessamentoHUB ]" )

		if ::lVisual
			ProcRegua( nPendentes )
		endif		

		for i := 1 to nPendentes
			aLog := {}
			aPendente := ::aListaPendente[ i ]
			if ::lVisual
				IncProc( "Processando pedido GAR: " + aPendente[1] + CRLF + cValToChar( i ) + "/" + cValTochar( nPendentes ) )
			endif			
			aAdd( aLog, ::ProcessarEvento( cEVENTO_ENVIA_PEDIDO_GAR , aPendente[ 2 ] ) )
			aAdd( aLog, ::ProcessarEvento( cEVENTO_VALIDACAO  		, aPendente[ 3 ] ) )
			aAdd( aLog, ::ProcessarEvento( cEVENTO_VERIFICACAO		, aPendente[ 4 ] ) )
			aAdd( aLog, ::ProcessarEvento( cEVENTO_EMISSAO    		, aPendente[ 5 ] ) )
			::oLog:AddLog( aLog )
		next i
	endif
return

/*/{Protheus.doc} ProcessarEvento
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method ProcessarEvento( cEvento, cXML ) class ProcessamentoHUB as array
	local cMensagem := ""
	local oHUB      := nil
	local aLog      := {}

	if !empty( cEvento ) .and. !empty( cXML )
		oHUB := MensagemHUB():New( cXML ) 
		cMensagem := oHUB:ProcessarXML( cEvento ) 
		aAdd( aLog, "Processado o pedido GAR: " + oHUB:cPedidoGar  ) 
		aAdd( aLog, "XML de " + cEvento + ".: " + cXML  ) 
		aAdd( aLog, "Mensagem de retorno...: " + cMensagem )
	endif
	
return aLog

/*/{Protheus.doc} ProcessarEvento
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method ProcessarVisual() class ProcessamentoHUB as array
	Processa({|| ProcSub() }, "Processando Eventos GAR")
return

/*/{Protheus.doc} ProcessarEvento
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
Static Function ProcSub()
	local oHUB := ProcessamentoHUB():New()
	if oHUB:GetListaPendentes( lPARAMETROS )
		oHUB:ProcessarLista()
	    oHUB:oLog:EnviarLog()
	else
		MsgInfo( "Processo cancelado ou parâmetros inválidos", "Processamento em Lote" )
	endif
Return
