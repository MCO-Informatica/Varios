#Include "PROTHEUS.CH"
#Include "Ap5Mail.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"

#Define cEVENTO_VERIFICACAO 'GETVERGAR'
#Define cEVENTO_VALIDACAO 	'GETVLDGAR'
#Define cEVENTO_EMISSAO 	'GETEMIGAR'
#Define cSX6 				'MV_PROCHUB'

User Function VNDA760()
	local oHUB := nil
	local i := 0
	local nTotal := 0
	local aPendente  := {}
	local lProcAgent := .F.
	
	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"

	if !GetMv( cSX6, .T. )
		CriaPar( {{ cSX6, "L", "MensagemHUB. Processa em ProcAgente?", ".T." }})
	endif
	lProcAgent := GetMv( cSX6 )

	oHUB := ProcessamentoHUB():New() 
	if oHUB:GetListaPendentes()
		if lProcAgent 
			nTotal := len( oHUB:aListaPendente ) 
			for i := 1 to nTotal
				aPendente := oHUB:aListaPendente[ i ]
				U_Send2Proc( aPendente[ 1 ], "U_VNDA761", aPendente )
			next i
		else
			oHUB:ProcessarLista()
			oHUB:oLog:EnviarLog()
		endif
	endif

	RESET ENVIRONMENT
Return 

User Function VNDA761( aPendente )
	local oHUB := nil
	default aPendente := {}
	if len( aPendente ) > 0
		oHUB := ProcessamentoHUB():New() 
		oHUB:ProcessarLista( { aPendente } )
		oHUB:oLog:EnviarLog()	
	endif
Return




/*/{Protheus.doc} CriaPar
Função para criação de parâmetros (SX6)
@type function
@author Atilio
@since 12/11/2015
@version 1.0
@param aPars, Array, Array com os parâmetros do sistema
@example
CriaPar(aParametros)
@obs Abaixo a estrutura do array:
[01] - Parâmetro (ex.: "MV_X_TST")
[02] - Tipo (ex.: "C")
[03] - Descrição (ex.: "Parâmetro Teste")
[04] - Conteúdo (ex.: "123;456;789")
/*/
static function CriaPar( aPars )
	Local nAtual  := 0
	Local aArea   := GetArea()
	Local aAreaX6 := SX6->(GetArea())
	Default aPars := {}
	
	dbSelectArea( "SX6" )
	SX6->( dbGoTop() )
	For nAtual := 1 To Len( aPars ) 	//Percorrendo os parâmetros e gerando os registros
		//Se não conseguir posicionar no parâmetro cria
		If !( SX6->( dbSeek( xFilial("SX6") + aPars[ nAtual ][ 1 ] ) ) )
			RecLock("SX6", .T.)
			SX6->X6_VAR     := aPars[nAtual][1] //Nome do parametro
			SX6->X6_TIPO    := aPars[nAtual][2]  // Tipo do parametro
			SX6->X6_PROPRI  := "U" //Parametro customizado
			SX6->X6_DESCRIC := aPars[nAtual][3] //Descrição Português
			SX6->X6_DSCSPA  := aPars[nAtual][3] //Descrição Espanhol
			SX6->X6_DSCENG  := aPars[nAtual][3] //Descrição Ingles
			SX6->X6_CONTEUD := aPars[nAtual][4] //Conteúdo Português
			SX6->X6_CONTSPA := aPars[nAtual][4] //Conteúdo Espanhol
			SX6->X6_CONTENG := aPars[nAtual][4] //Conteúdo Ingles
			SX6->(MsUnlock())
		EndIf
	Next nAtual
	
	RestArea( aAreaX6 )
	RestArea( aArea   )

Return 


User Function VNDA762()
	local cQuery := ""
	local cPC3 := ""
	local cChavePC3 := ""
	local oSQL   := CSQuerySQL():New()
	local cVldGAR := ""
	local cVerGAR := ""
	local cEmiGAR := ""
	
	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"

	cQuery += " SELECT "
	cQuery += " 	PC3_PEDGAR,  "
	cQuery += " 	COUNT(*) QTD, "
	cQuery += " 	MAX( UTL_RAW.CAST_TO_VARCHAR2( dbms_lob.substr( PC3_VLDGAR, 2000, 1) ) ) PC3_VLDGAR, "
	cQuery += " 	MAX( UTL_RAW.CAST_TO_VARCHAR2( dbms_lob.substr( PC3_VERGAR, 2000, 1) ) ) PC3_VERGAR, "
	cQuery += " 	MAX( UTL_RAW.CAST_TO_VARCHAR2( dbms_lob.substr( PC3_EMIGAR, 2000, 1) ) ) PC3_EMIGAR  "
	cQuery += " FROM PC3010 "
	cQuery += " WHERE D_E_L_E_T_ = ' '  "
	cQuery += " GROUP BY PC3_PEDGAR "
	cQuery += " HAVING COUNT(*) >  1 "

	if oSQL:Consultar( cQuery )
		PC3->( dbSetOrder( 1 ) )
		cPC3 := oSQL:GetAlias()
		while ( cPC3 )->( !EoF() ) 
			conout( "VNDA762 - PEDGAR: " + ( cPC3 )->PC3_PEDGAR )
			cChavePC3 := xFilial("PC3") + ( cPC3 )->PC3_PEDGAR
			nQtd := 0
			if PC3->( dbSeek( cChavePC3 ) )
				while PC3->( !EoF() ) .and. PC3->( PC3_FILIAL + PC3_PEDGAR ) == cChavePC3
					nQtd++
					RecLock( "PC3", .F. )
					cVldGAR := alltrim( ( cPC3 )->PC3_VLDGAR )
					cVerGAR := alltrim( ( cPC3 )->PC3_VERGAR )
					cEmiGAR := alltrim( ( cPC3 )->PC3_EMIGAR )
					PC3->PC3_VLDGAR := iif( !empty( cVldGAR ), cVldGAR, PC3->PC3_VLDGAR  )
					PC3->PC3_VERGAR := iif( !empty( cVerGAR ), cVerGAR, PC3->PC3_VERGAR  )
					PC3->PC3_EMIGAR := iif( !empty( cEmiGAR ), cEmiGAR, PC3->PC3_EMIGAR  )
					PC3->PC3_STAVLD := "2"
					PC3->PC3_STAVER := "2"
					PC3->PC3_STAEMI := "2"
					PC3->PC3_DATALT := dDatabase
					PC3->PC3_HORALT := Time()

					if nQtd > 1
						PC3->( dbDelete() )
						conout( "VNDA762 - DELETADO PEDGAR: " + PC3->PC3_PEDGAR )
					endif
					
					PC3->(MsUnLock())
					PC3->( dbSkip() )
				end
				PC3->( dbCloseArea() )
			endif
			( cPC3 )->( dbSkip() )
		end
		( cPC3 )->( dbCloseArea() )
	else
		conout( "Não tem pedido GAR duplicado" )
	endif	

	RESET ENVIRONMENT
Return
