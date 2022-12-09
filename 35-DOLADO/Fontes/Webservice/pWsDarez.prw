#include 'Protheus.ch'

/*/{Protheus.doc} pWsDarez
Rotina que recebe um id de um processamento da tabela SZ1 e processa o mesmo
@type function
@version  
@author Vladimir
@since 20/10/2022
@param cId, character, id do processamento a ser executado
@return variant, return_description
/*/

user function pWsDarez( cId )

	local cRotina := ''
	local cSeek   := xFilial( 'SZ1' ) + cId
	local cError  := ''
	Local bError  := ErrorBlock( { | oErro | cErro := oErro:Description } )
	Local aArea   := getArea()

	DbSelectArea( 'SZ1' )
	SZ1->( DbSetOrder( 1 ) )

	restArea( aArea )

	if SZ1->( DbSeek( cSeek ) ) .And. AllTrim( cSeek ) == AllTrim( SZ1->( Z1_FILIAL + Z1_UUID ) )

		cRotina := AllTrim( Upper( SZ1->Z1_ROTINA ) )

		if cRotina == 'CRMA980' // Cadastro de Clientes

			pCRMA980()

		elseif cRotina == 'MATA410' // Pedido de Vendas

			pMata410()

		elseif cRotina == 'FINA070' // Baixa a Receber

			pFina070()

		elseif cRotina == 'FINA040' // Inclusão de um RA

			pFina040()

		else

			regSZ1( '1', 'Rotina não tem processamento definido.' )

		endif

		if !Empty( cError )

			regSZ1( '2', cError )

		end if

	else

		ConOut( 'id: ' + cId + ' não localizado para filial: ' + SM0->M0_CODFIL )

	end if

	ErrorBlock( bError )

return

/*/{Protheus.doc} pCRMA980
Rotina que executa o processamento de inclusão de cliente 
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 25/03/2022
/*/
static function pCRMA980()

	local oJson     := jsonObject():New()
	local aJsonProp := {}
	local aSa1      := {}
	local nX        := 0
	local nOpc      := 0
	local cCampo    := ''
	local xValor    := ''
	local cCodigo   := ''
	local cLoja     := ''
	local nPosCod   := 0
	local nPosLoja  := 0
	local aErro     := {}
	local cErro     := ''
	local cSeek     := ''

	private lMsErroAuto    := .F.
	private lMsHelpAuto    := .T.
	private lAutoErrNoFile := .T.

	oJson:fromJson( SZ1->Z1_BODYMSG )

	aJsonProp := aClone( ClassDataArr( oJson ) )

	for nX := 1 to Len( aJsonProp )

		cCampo := aJsonProp[ nX, 1 ]
		xValor := aJsonProp[ nX, 2 ]

		if ValType( xValor ) == 'C'

			xValor := PadR( xValor, GetSx3Cache( cCampo, 'X3_TAMANHO' ) )

		end if

		aAdd( aSa1, { cCampo, xValor, nil } )

	next nx

	nPosCod  := aScan( aSa1, { | x | AllTrim( upper( x[ 1 ] ) ) == 'A1_COD'  } )
	nPosLoja := aScan( aSa1, { | x | AllTrim( upper( x[ 1 ] ) ) == 'A1_XLJSHPF' } )

	if ! Empty( nPosCod ) .And. ! Empty( nPosLoja )

		cCodigo := aSa1[ nPosCod , 2 ]
		cLoja   := aSa1[ nPosLoja, 2 ]

		DbSelectArea( 'SA1' )
		SA1->( DBOrderNickname( 'LOJASHOPFY' ) )

		cSeek := xFilial( 'SA1' ) + cCodigo + cLoja

		if DbSeek( cSeek ) .And. AllTrim( cSeek ) == AllTrim( SA1->( A1_FILIAL + A1_COD + A1_XLJSHPF ) )

			nPosLoja := aScan( aSa1, { | x | AllTrim( upper( x[ 1 ] ) ) == 'A1_LOJA' } )

			if nPosLoja == 0

				aAdd( aSa1, { 'A1_LOJA', SA1->A1_LOJA, nil } )

			end if

			nOpc := 4

		else

			nOpc := 3

		end if

	else

		nOpc := 3

	end if

	aSa1 := aClone( ordemSX3( aSa1 ) )

	Begin Transaction

		MSExecAuto( { | a, b, c | CRMA980( a, b, c ) }, aSa1, nOpc )

		if lMsErroAuto

			lMsErroAuto := .F.

			aErro := aClone( GetAutoGRLog() )

			for nX := 1 to Len( aErro )

				cErro += aErro[ nX ] + CRLF

			next nX

			DisarmTransaction()

		endif

	End Transaction

	if Empty( cErro )

		regSZ1( '1', 'Cadastro de cliente processado com sucesso.' )

	else

		regSZ1( '2', cErro )

	endif

return

/*/{Protheus.doc} pMata410
Rotina que executa o processamento de inclusão de pedido de venda 
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 25/03/2022
/*/
static function pMata410()

	local oJson     := jsonObject():New()
	local aJsonProp := {}
	local aSC5      := {}
	local cFormPag  := ''
	local lGeraRA   := .F.
	local cType     := ''
	local aSC6      := {}
	local aSC6Item  := {}
	local nValorPed := 0
	local nX        := 0
	local nY        := 0
	local cCampo    := ''
	local xValor    := ''
	local aErro     := {}
	local cErro     := ''
	local nPos      := 0
	local cLjShpf   := ''
	local cCodigo   := ''
	local cPedShp   := ''

	/*Declara variáveis para a Rotina de decompor produto kit no pedido de venda*/
	local nPItem  := 0
	local nPProd  := 0
	local nPQtdVen:= 0
	local nPQtdLib:= 0
	local nPPrcVen:= 0
	local nPOper  := 0
	local nPValDes:= 0

	local cItem := "00"
	local cProd := ""
	local nQtdVen := 0
	local nQtdLib := 0
	local nPrunit := 0
	local nPrcVen := 0
	local nValor  := 0
	local nValDes := 0
	local nPercDes:= 0
	local cOper   := ""

	local cCodKit := ""
	Local nQtdKit := 0
	local nLibKit := 0
	local nPunKit := 0
	Local nPrcKit := 0
	local nVlrKit := 0
	local nTotKit := 0
	Local nDesKit := 0

	local ntotprc := 0
	local ntotuni := 0
	local ntotdes := 0
	Local nI	  := 0
	Local lAchou  := .f.
	local aLinha  := {}
	local aSC6linha:= {}
	local aSC6Itens:= {}
	local nPercFix:= 0
	local nPrv1   := 0
	Local aEst    := {}
	Local nEst    := 0
	/*Declara variáveis para a Rotina de decompor produto kit no pedido de venda*/

	private lMsErroAuto    := .F.
	private lMsHelpAuto    := .T.
	private lAutoErrNoFile := .T.

	//SX3->( DbSetOrder( 2 ) )

	oJson:fromJson( SZ1->Z1_BODYMSG )

	aJsonProp := aClone( ClassDataArr( oJson ) )

	for nX := 1 to Len( aJsonProp )

		cCampo := aJsonProp[ nX, 1 ]
		xValor := aJsonProp[ nX, 2 ]

		if AllTrim( cCampo ) != 'SC6'

			cType := GetSx3Cache( cCampo, 'X3_TIPO' )

			if ! Empty( cType ) .And. cType == 'D'

				xValor := StoD( xValor )

			end if

			aAdd( aSC5, { cCampo, xValor, nil } )

			if SubStr( AllTrim( cCampo ), 1, 7 ) == 'C5_PARC'

				nValorPed += xValor

			end if

			if cCampo == 'C5_XFORMPG'

				cFormPag := xValor

				lGeraRA := ! cFormPag $ GetMv( 'DR_FORMPRA' )

			end if

		end if

	next nX

	if aScan( aJsonProp, {|x|x[1] == 'SC6'} ) > 0 .And. ValType( oJson['SC6'] ) == 'A'

		for nX := 1 to len( oJson[ 'SC6' ] )

			aJsonProp := aClone( ClassDataArr( oJson[ 'SC6' ][ nX ] ) )

			for nY := 1 to Len( aJsonProp )

				cCampo := aJsonProp[ nY, 1 ]
				xValor := aJsonProp[ nY, 2 ]

				aAdd( aSC6Item, { cCampo, xValor, nil } )

			next nY

			aSC6Item := aClone( ordemSX3( aSC6Item ) )

			aAdd( aSC6, aClone( aSC6Item ) )

			aSize( aSC6Item, 0 )

		next nX

		/*Rotina para decompor produto kit no pedido de venda*/
		//cLin := ""
		sb1->(DbSetOrder(1))
		da1->(DbSetOrder(2))
		for nX := 1 to Len(aSC6)

			lAchou := .f.
			aSC6linha := aSC6[nX]

			nPItem  := Ascan(aSC6linha, {|x| Alltrim(x[1]) == "C6_ITEM"})
			nPProd  := Ascan(aSC6linha, {|x| Alltrim(x[1]) == "C6_PRODUTO"})
			nPQtdVen := Ascan(aSC6linha, {|x| Alltrim(x[1]) == "C6_QTDVEN"})
			nPPrcVen := Ascan(aSC6linha, {|x| Alltrim(x[1]) == "C6_PRCVEN"})
			nPQtdLib := Ascan(aSC6linha, {|x| Alltrim(x[1]) == "C6_QTDLIB"})
			nPOper   := Ascan(aSC6linha, {|x| Alltrim(x[1]) == "C6_OPER"})
			nPValDes := Ascan(aSC6linha, {|x| Alltrim(x[1]) == "C6_VALDESC"})

			cCodKit := Padr( aSC6linha[nPProd,2] ,TamSx3("B1_COD")[1] )
			nQtdKit := aSC6linha[nPQtdVen,2]
			nLibKit := aSC6linha[nPQtdLib,2]
			nPunKit := aSC6linha[nPPrcVen,2]
			nDesKit := aSC6linha[nPValDes,2]
			nPrcKit := nPunKit - round( nDesKit/nQtdKit, 2 )
			nTotKit := nPunKit * nQtdKit
			nVlrKit := nPrcKit * nQtdKit

			cOper   := aSC6linha[nPOper,2]

			ntotprc := 0
			ntotuni := 0
			ntotdes := 0

			if da1->(dbseek(xfilial()+cCodKit+"001")) .and. sb1->(dbseek(xfilial()+cCodKit)) .and. ;
				sb1->b1_xkit == "1" .and. sb1->b1_prv1 > 0

				aEst := retEstrut(cCodKit,nQtdKit)
				nEst := len(aEst)
				if nEst > 0
					lAchou := .t.

					if nDesKit > 0
						nPercDes := nDesKit / ( nPunKit * nQtdKit )
						nPercFix := da1->da1_vlrdes / sb1->b1_prv1
					else
						nPercDes := da1->da1_vlrdes / sb1->b1_prv1
						nPercFix := 0
					endif

					for nI := 1 to nEst

						sb1->(dbseek(xfilial()+aEst[nI,1]))

						cProd 	:= aEst[nI,1]
						nQtdVen := aEst[nI,2]
						if nPercFix > 0
							nPrv1 := round( sb1->b1_prv1 - ( sb1->b1_prv1 * nPercFix ), 2 )
						else
							nPrv1 := sb1->b1_prv1
						endif
						nPrcVen := round( nPrv1 - ( nPrv1 * nPercDes ), 2 )
						nValor  := round( nPrcVen * nQtdVen , 2 )
						nQtdLib := ( nLibKit / nQtdKit ) * aEst[nI,2]
						if nDesKit > 0
							nPrunit := nPrv1
						else
							nPrunit := nPrcVen
						endif
						nValDes := ( nPrunit - nPrcVen ) * nQtdVen

						ntotprc += ( nPrcVen * nQtdVen )
						ntotuni += ( nPrunit * nQtdVen )
						ntotdes += nValDes

						if nI == nEst

							nPrcVen := nPrcVen + ( ( nVlrKit - ntotprc ) / nQtdKit)
							nValor  := nValor + ( nTotKit - ntotuni )
							nValDes := nValDes + ( nDesKit - ntotdes )
							if nDesKit > 0
								nPrunit := nPrcVen + round( nValDes / nQtdVen , 2 )
							else
								nPrunit := nPrcVen
							endif

						endif

						aLinha := {}
						cItem := soma1(cItem,2)
						aadd(aLinha,{"C6_ITEM"	 ,cItem			,Nil})
						aadd(aLinha,{"C6_PRODUTO",cProd			,Nil})
						aadd(aLinha,{"C6_QTDVEN" ,nQtdVen		,Nil})
						aadd(aLinha,{"C6_PRUNIT" ,nPrunit       ,Nil})
						aadd(aLinha,{"C6_PRCVEN" ,nPrcVen       ,Nil})
						aadd(aLinha,{"C6_QTDLIB" ,nQtdLib		,Nil})
						aadd(aLinha,{"C6_OPER"	 ,cOper         ,Nil})
						aadd(aLinha,{"C6_VALDESC",nValDes       ,Nil})
						aadd(aLinha,{"C6_XCODKIT",cCodKit       ,Nil})
						//aLinha := aClone( ordemSX3( aLinha ) )
						aLinha := aClone( aLinha )
						aadd(aSC6Itens, aClone( aLinha ) )
						//cLin += cItem+cProd+str(nQtdVen)+str(nPrunit)+str(nPrcVen)+str(nQtdLib)+str(nValDes)+chr(10)+chr(13)
					next

				endif
			endif
			if !lAchou
				aLinha := {}
				cItem := soma1(cItem,2)
				aadd(aLinha,{"C6_ITEM"	 ,cItem		,Nil})
				aadd(aLinha,{"C6_PRODUTO",cCodKit	,Nil})
				aadd(aLinha,{"C6_QTDVEN" ,nQtdKit	,Nil})
				aadd(aLinha,{"C6_PRUNIT" ,nPunKit	,Nil})
				aadd(aLinha,{"C6_PRCVEN" ,nPrcKit	,Nil})
				aadd(aLinha,{"C6_QTDLIB" ,nLibKit	,Nil})
				aadd(aLinha,{"C6_OPER"	 ,cOper		,Nil})
				aadd(aLinha,{"C6_VALDESC",nDesKit	,Nil})
				aLinha := aClone( aLinha )
				aadd(aSC6Itens, aClone( aLinha ) )
				//cLin += cItem+cCodKit+str(nQtdkit)+str(nPunkit)+str(nPrcKit)+str(nLibKit)+str(nDesKit)+chr(10)+chr(13)
			endif
		next
		aSC6 := aClone( aSC6Itens )
		//memowrite( "c:\temp\teste.txt", cLin )
		/*Fim Rotina para decompor produto kit no pedido de venda*/

	end if

	if aScan( aSC5, { |x|  x[1] == 'C5_CONDPAG' } )  == 0

		if lGeraRA

			aAdd( aSC5, { 'C5_CONDPAG', GetMv( 'DR_CONDCRA' ), nil } )

		else

			aAdd( aSC5, { 'C5_CONDPAG', GetMv( 'DR_CONDSRA' ), nil } )

		end if

	end if

	if aScan( aSC5, { |x|  x[1] == 'C5_TIPO' } )  == 0

		aAdd( aSC5, { 'C5_TIPO', 'N', nil } )

	end if

	nPos := aScan( aSC5, { |x|  x[1] == 'C5_XLJSHPF' } )

	if nPos <> 0

		cLjShpf := PadR( aSC5[ nPos, 2 ], TamSx3( 'C5_XLJSHPF' )[1] )

		nPos := aScan( aSC5, { |x|  x[1] == 'C5_CLIENTE' } )

		cCodigo := PadR( aSC5[ nPos, 2 ], TamSx3( 'C5_CLIENTE' )[1] )

		DbSelectArea( 'SA1' )
		SA1->( DBOrderNickname( 'LOJASHOPFY' ) )

		if SA1->( DbSeek( xfilial('SA1') + cCodigo + cLjShpf ) )

			aAdd( aSC5, { 'C5_LOJACLI', SA1->A1_LOJA, nil } )
			aAdd( aSC5, { 'C5_LOJAENT', SA1->A1_LOJA, nil } )

		end if

	end if

	aSC5 := aClone( ordemSX3( aSC5 ) )

	nPos := aScan( aSC5, { |x|  x[1] == 'C5_XPEDSHP' } )

	If Len(aSC5) > 0 .and. Len(aSC6) > 0

		if nPos <> 0

			cPedShp := aSC5[ nPos, 2 ]

			DbSelectArea( 'SC5' )
			SC5->( DBOrderNickname( 'PEDSHP' ) )

			if ! ( SC5->( DbSeek( cPedShp ) ) .And.;
					AllTrim( cPedShp ) == AllTrim( SC5->C5_XPEDSHP ) )

				Begin Transaction

				/****************************************************/
				/* Força buscar a TES inteligente e o CFOP correto  */
				/****************************************************/

					ajustaCfop( aSc5, aSc6 )

				/****************************************************/
				/****************************************************/
				/****************************************************/

					MSExecAuto( {|a,b,c| MATA410(a, b, c) }, aSC5, aSC6, 3 )

					if lMsErroAuto

						lMsErroAuto := .F.

						aErro := aClone( GetAutoGRLog() )

						for nX := 1 to Len( aErro )

							cErro += aErro[ nX ] + CRLF

						next nX

						DisarmTransaction()

					else

						if  lGeraRA

							_cC5Num := ''

							pFina040(  aSC5, nValorPed )

							if lMsErroAuto

								lMsErroAuto := .F.

								aErro := aClone( GetAutoGRLog() )

								for nX := 1 to Len( aErro )

									cErro += aErro[ nX ] + CRLF

								next nX

								DisarmTransaction()

							else

								vincAdtPed( aSC5, nValorPed )

							endif

						endif

					endif

				End Transaction

			else

				cErro := 'Pedido ShopFy já existente.'

			end if

		else

			cErro := 'É Obrigatório informar o campo C5_XPEDSHP'

		end if
	else
		cErro := 'Estrutura do objeto JSON está incompleta'
	Endif

	if Empty( cErro )

		regSZ1( '1', 'Pedido de venda processado com sucesso.' )

	else

		regSZ1( '2', cErro )

	endif

return

/*/{Protheus.doc} ajustaCfop
Força a busca da TES inteligente e do CFOP e atribui estes valores ao array do execauto aSC6
@type function
@version  12.1.33
@author elton.alves
@since 14/05/2022
@param aSc5, array, Array do execauto mata410 com os dados da tabela SC5
@param aSc6, array, Array do execauto mata410 com os dados da tabela SC6
/*/
static function ajustaCfop( aSc5, aSc6 )

	local nX        := 0
	local aDadosCfo := {}
	local cTesInt   := ''
	local cCfop     := ''
	local cCliente  := SA1->A1_COD
	local cLojaEnt  := SA1->A1_LOJA
	local cProduto  := ''
	local cOrigem   := ''
	local cTpOper   := ''
	local nPos      := 0

	Aadd( aDadosCfo, { "OPERNF","S" } )
	Aadd( aDadosCfo, { "TPCLIFOR",SA1->A1_TIPO } )
	Aadd( aDadosCfo, { "UFDEST",SA1->A1_EST } )
	Aadd( aDadosCfo, { "INSCR" ,SA1->A1_INSCR } )
	Aadd( aDadosCfo, { "CONTR", SA1->A1_CONTRIB } )

	DbSelectArea( 'SF4' )
	SF4->( DbSetOrder( 1 ) )

	for nX := 1 to len( aSc6 )

		nPos := aScan( aSc6[ nX ], { | item | Upper( AllTrim( item[ 1 ] ) ) == 'C6_PRODUTO' } )

		if nPos > 0

			cProduto :=  aSc6[ nX, nPos, 2 ]
			cOrigem  := posicione( 'SB1', 1, xFilial( 'SB1' ) + cProduto, 'B1_ORIGEM' )

		end if

		nPos := aScan( aSc6[ nX ], { | item | Upper( AllTrim( item[ 1 ] ) ) == 'C6_OPER' } )

		if nPos > 0

			cTpOper :=  aSc6[ nX, nPos, 2 ]

		end if

		nPos := aScan( aSc6[ nX ], { | item | Upper( AllTrim( item[ 1 ] ) ) == 'C6_PRODUTO' } )

		/********************************************/
		/** Força o códiogo do produto em maiúsculo */
		/********************************************/
		if nPos > 0

			aSc6[ nX, nPos, 2 ] := Upper( aSc6[ nX, nPos, 2 ] )

		end if
		if SA1->A1_EST <> 'SP'
		cTesInt := '800'
		else
		cTesInt := '501'
		endif

		/*		
		cTesInt := MaTesInt( 2, cTpOper, cCliente, cLojaEnt, 'C', cProduto, 'C6_TES',;
			SA1->A1_TIPO, GetMv( 'MV_ESTADO' ), cOrigem )
		*/
		
		if ! Empty( cTesInt ) .And. SF4->( DbSeek( xFilial( 'SF4' ) + cTesInt) .And.;
				allTrim( F4_CODIGO ) == allTrim( cTesInt ) )

			cCfop := MaFisCfo(, SF4->F4_CF, aDadosCfo)

			aAdd( aSc6[ nX ], { 'C6_TES', cTesInt, nil } )
			aAdd( aSc6[ nX ], { 'C6_CF' , cCfop  , nil } )

		end if

	next nX

return

/*/{Protheus.doc} pFina040
Rotina que executa o processamento de inclusão do recebimento antecipado (RA)
@type function
@version 12.1.33 
@author elton.alves@totvs.com.br
@since 25/03/2022
@param aSC5, array, Array de dados do cabeçalho do pedido de venda
@param nValorPed, numeric, Valor total do pedido de vendas
/*/
static function pFina040(  aSC5, nValorPed )

	local aSE1      := {}
	local cNum      := ''
	local cCliente  := ''
	local cLoja     := ''
	local cNatureza := ''
	local cFormPag  := ''
	local aDadosBco := {}
	local cBanco    := ''
	local cAgencia  := ''
	local cConta    := ''
	local nPos      := 0
	local cAlias    := getnextalias()
	local lSomeRA   := aSC5 == nil .Or. nValorPed == nil
	local oJson     := jsonObject():new()
	local aErro     := {}
	local cErro     := ''
	local nX        := 0

	Private cParc     := ''

	if lSomeRA

		private lMsErroAuto    := .F.
		private lMsHelpAuto    := .T.
		private lAutoErrNoFile := .T.

		oJson:fromJson( SZ1->Z1_BODYMSG )

		DbSelectArea( 'SC5' )
		SC5->( DBOrderNickname( 'PEDSHP' ) )

		if SC5->( DbSeek(  oJson['C5_XPEDSHP'] ) .And.;
				allTrim( oJson['C5_XPEDSHP'] ) == allTrim( C5_XPEDSHP ) )

			nValorPed  := oJson['E1_VLCRUZ']

			SC5->( aSC5 := {;
				{ "C5_XPEDSHP", oJson['C5_XPEDSHP'], nil },;
				{ "C5_CLIENTE", C5_CLIENTE, nil },;
				{ "C5_LOJACLI", C5_LOJACLI, nil },;
				{ "C5_XFORMPG", C5_XFORMPG, nil }})

			RecLock( 'SC5', .F. )

			SC5->C5_CONDPAG := GetMv( 'DR_CONDCRA' )

			SC5->( MsUnlock() )


		else

			regSZ1( '2', 'Pedido não localizado' )

			return

		end if

	end if

	nPos    := aScan( aSC5, { |x| x[1] == 'C5_XPEDSHP'} )
	cPedShp := aSC5[ nPos, 2]

	If Select(cAlias) <> 0

		(cAlias)->(DbCloseArea())

	EndIf

	BEGINSQL ALIAS cAlias
	
	%NOPARSER%
	
	SELECT * FROM %TABLE:SC5% 
	WHERE C5_XPEDSHP = %EXP:cPedShp%
	AND C5_FILIAL = %XFILIAL:SC5%
	AND %NOTDEL%
	
	ENDSQL

	If (cAlias)->(!EOF())

		_cC5Num := SC5->C5_NUM

	EndIf

	(cAlias)->(DbCloseArea())

	cNum := _cC5Num

	BEGINSQL ALIAS cAlias
	
	%NOPARSER%
	
	SELECT MAX( E1_PARCELA ) E1_PARCELA FROM %TABLE:SE1% 
	WHERE E1_FILIAL = %XFILIAL:SE1%
	AND E1_PREFIXO = 'PED'
	AND E1_NUM     = %EXP:cNum%
	AND E1_TIPO    = 'RA'
	AND %NOTDEL%
	
	ENDSQL

	If (cAlias)->(EOF())

		cParc := StrZero( 1, TamSx3('E1_PARCELA')[1] )

	else

		cParc := Soma1( ( cAlias )->E1_PARCELA )

	EndIf

	(cAlias)->(DbCloseArea())

	nPos := aScan( aSC5, { |x| x[1] == 'C5_CLIENTE'} )
	cCliente := aSC5[ nPos, 2]
	cCliente := PadR( cCliente, TamSx3('C5_CLIENTE')[1] )

	nPos := aScan( aSC5, { |x| x[1] == 'C5_LOJACLI'} )
	cLoja := aSC5[ nPos, 2]

	nPos := aScan( aSC5, { |x| x[1] == 'C5_XFORMPG'} )
	cFormPag := aSC5[ nPos, 2]

	aDadosBco := StrTokArr2( Posicione( 'SX5', 1, xFilial('SX5') + 'ZX' + cFormPag, 'X5_DESCRI'), '/', .T. )
	cBanco    := aDadosBco[1]
	cAgencia  := aDadosBco[2]
	cConta    := aDadosBco[3]

	cNatureza := Posicione( 'SA1', 1, xFilial( 'SA1' ) + cCliente + cLoja, 'A1_NATUREZ' )

	aAdd( aSE1, { "E1_PREFIXO"  , "PED"     , NIL } )
	aAdd( aSE1, { "E1_NUM"      , cNum      , NIL } )
	aAdd( aSE1, { "E1_PARCELA"  , cParc     , NIL } )
	aAdd( aSE1, { "E1_TIPO"     , "RA"      , NIL } )
	aAdd( aSE1, { "E1_NATUREZ"  , cNatureza , NIL } )
	aAdd( aSE1, { "E1_CLIENTE"  , cCliente  , NIL } )
	aAdd( aSE1, { "E1_LOJA"     , cLoja     , NIL } )
	aAdd( aSE1, { "E1_EMISSAO"  , Date()    , NIL } )
	aAdd( aSE1, { "E1_VENCTO"   , Date()    , NIL } )
	aAdd( aSE1, { "E1_VENCREA"  , Date()    , NIL } )
	aAdd( aSE1, { "CBCOAUTO"    , cBanco    , NIL } )
	aAdd( aSE1, { "CAGEAUTO"    , cAgencia  , NIL } )
	aAdd( aSE1, { "CCTAAUTO"    , cConta    , NIL } )
	aAdd( aSE1, { "E1_VALOR"    , nValorPed , NIL } )

	MsExecAuto( { | x, y | FINA040( x, y ) } , aSE1, 3)

	if lSomeRA

		if lMsErroAuto

			lMsErroAuto := .F.

			aErro := aClone( GetAutoGRLog() )

			for nX := 1 to Len( aErro )

				cErro += aErro[ nX ] + CRLF

			next nX

			regSZ1( '2', cErro )

		else

			vincAdtPed( aSC5, nValorPed )

			regSZ1( '1', 'RA incluído com sucesso' )

		end if

	end if

return

/*/{Protheus.doc} vincAdtPed
Função que vincula o pedido de vendas ao recebimento antecipdo (RA)
@type function
@version 12.1.33 
@author elton.alves@totvs.com.br
@since 25/03/2022
@param aSC5, array, Array de dados do cabeçalho do pedido de venda
@param nValorPed, numeric, Valor total do pedido de vendas
/*/
static function vincAdtPed( aSC5, nValorPed )

	local cNum     := _cC5Num
	local cCliente := aSC5[ aScan( aSC5, { |x| x[1] == 'C5_CLIENTE' } ), 2 ]
	local cLoja    := aSC5[ aScan( aSC5, { |x| x[1] == 'C5_LOJACLI' } ), 2 ]

	DbSelectArea( 'FIE' )

	RecLock( 'FIE', .T. )

	FIE->FIE_FILIAL := xFilial( 'FIE' )
	FIE->FIE_CART   := 'R'
	FIE->FIE_PEDIDO := cNum
	FIE->FIE_PREFIX := 'PED'
	FIE->FIE_NUM    := cNum
	FIE->FIE_PARCEL := cParc
	FIE->FIE_TIPO   := 'RA'
	FIE->FIE_CLIENT := cCliente
	FIE->FIE_LOJA   := cLoja
	FIE->FIE_VALOR  := nValorPed
	FIE->FIE_SALDO  := nValorPed
	FIE->FIE_FILORI := xFilial( 'FIE' )

	FIE->( MsUnlock() )

return

/*/{Protheus.doc} pFina070
processa a baixa de uma parcela de título a receber de um pedido já faturado.
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 25/03/2022
/*/
static function pFina070()

	local cAlias     := getNextAlias()
	local cPedShopfy := ''
	local cNumParc   := ''
	local dDtBaixa   := ctod('')
	local cHist      := ''
	local aDadosBco  := ''
	local cBanco     := ''
	local cAgencia   := ''
	local cConta     := ''
	local cPrefix    := ''
	local cNum       := ''
	local cParcela   := ''
	local cTipo      := ''
	local cFormPg    := ''
	local nValor     := 0
	local oJson      := jsonObject():New()
	local aBaixa     := {}
	local nX         := 0
	local aErro      := {}
	local cErro      := ''
	local aArea      := GetArea()

	private lMsErroAuto    := .F.
	private lMsHelpAuto    := .T.
	private lAutoErrNoFile := .T.

	oJson:fromJson( SZ1->Z1_BODYMSG )

	cPedShopfy := if( Empty( oJson['C5_XPEDSHP'] ), '', oJson['C5_XPEDSHP'] )
	cNumParc   := if( Empty( oJson['E1_PARCELA'] ), '', oJson['E1_PARCELA'] )
	dDtBaixa   := StoD( if( Empty( oJson['E1_BAIXA'] ), '', oJson['E1_BAIXA'] ) )
	cHist      := if( Empty( oJson['E5_HISTOR'] ), '', oJson['E5_HISTOR'] )

	dDataBase := dDtBaixa

	If Select(cAlias) <> 0
		(cAlias)->(DbCloseArea())
	EndIf

	BeginSql alias cAlias
		
		SELECT DISTINCT 
		SE1.E1_PREFIXO, SE1.E1_NUM, 
		SE1.E1_TIPO, SE1.E1_EMISSAO, 
		SE1.E1_CLIENTE, SE1.E1_LOJA, 
		SE1.E1_PARCELA, SE1.E1_VLCRUZ,
		SC5.C5_XFORMPG 
			
		FROM %TABLE:SC5% SC5 

		INNER JOIN %TABLE:SD2% SD2
		ON SC5.D_E_L_E_T_ = SD2.D_E_L_E_T_
		AND SC5.C5_FILIAL = SD2.D2_FILIAL
		AND SC5.C5_NUM = SD2.D2_PEDIDO
		AND SC5.C5_CLIENTE = SD2.D2_CLIENTE
		AND SC5.C5_LOJACLI = SD2.D2_LOJA
		
		INNER JOIN %TABLE:SE1% SE1
		ON SD2.D_E_L_E_T_ = SE1.D_E_L_E_T_
		AND SE1.E1_FILIAL = SD2.D2_FILIAL
		AND SE1.E1_PREFIXO = SD2.D2_SERIE
		AND SE1.E1_NUM = SD2.D2_DOC
		AND SE1.E1_EMISSAO = SD2.D2_EMISSAO
		AND SE1.E1_CLIENTE = SD2.D2_CLIENTE
		AND SE1.E1_LOJA = SD2.D2_LOJA 

		WHERE SC5.%NOTDEL%
		AND SC5.C5_XPEDSHP = %EXP:cPedShopfy%
		AND SC5.C5_FILIAL  = %XFILIAL:SC5%
        AND ( SE1.E1_PARCELA = %EXP:cNumParc% OR SE1.E1_PARCELA = %EXP:IF( cNumParc=="1", "", "*" )% )
		AND SE1.E1_BAIXA   = %EXP:Space( TamSx3('E1_BAIXA')[1] )%

		UNION ALL

		SELECT 
		SE1.E1_PREFIXO,
		SE1.E1_NUM,
		SE1.E1_TIPO,
		SE1.E1_EMISSAO,
		SE1.E1_CLIENTE,
		SE1.E1_LOJA,
		SE1.E1_PARCELA,
		SE1.E1_VLCRUZ,
		'000000'

		FROM %TABLE:SE1% SE1

		WHERE SE1.%NOTDEL%
		AND SE1.E1_BAIXA   = %EXP:SPACE(8)%
		AND SE1.E1_XPEDSHP = %EXP:cPedShopfy%
		AND SE1.E1_PARCELA = %EXP:cNumParc%
		AND SE1.E1_BAIXA   = %EXP:Space( 10 )%

	EndSql

	if ( cAlias )->( eof() )

		cErro := 'Não foi localizado nenhum registro para ser baixado'

	else

		cPrefix    := ( cAlias )->E1_PREFIXO
		cNum       := ( cAlias )->E1_NUM
		cParcela   := ( cAlias )->E1_PARCELA
		cTipo      := ( cAlias )->E1_TIPO
		cFormPg    := ( cAlias )->C5_XFORMPG
		nValor     := ( cAlias )->E1_VLCRUZ

		( cAlias )->( DbCloseArea() )

		RestArea( aArea )

		aDadosBco := StrTokArr2( Posicione( 'SX5', 1, xFilial('SX5') + 'ZX' + cFormPg, 'X5_DESCRI'), '/', .T. )
		cBanco    := padR( aDadosBco[1], TamSx3( 'E5_BANCO'   )[ 1 ] )
		cAgencia  := padR( aDadosBco[2], TamSx3( 'E5_AGENCIA' )[ 1 ] )
		cConta    := padR( aDadosBco[3], TamSx3( 'E5_CONTA'   )[ 1 ] )

		aAdd( aBaixa, { 'E1_PREFIXO'  , cPrefix             , nil } )
		aAdd( aBaixa, { 'E1_NUM'      , cNum                , nil } )
		aAdd( aBaixa, { 'E1_PARCELA'  , cParcela            , nil } )
		aAdd( aBaixa, { 'E1_TIPO'     , cTipo               , nil } )
		aAdd( aBaixa, { 'AUTMOTBX'    , GetMv( 'DR_MOTBX' ) , nil } )
		aAdd( aBaixa, { 'AUTBANCO'    , cBanco              , nil } )
		aAdd( aBaixa, { 'AUTAGENCIA'  , cAgencia            , nil } )
		aAdd( aBaixa, { 'AUTCONTA'    , cConta              , nil } )
		aAdd( aBaixa, { 'AUTDTBAIXA'  , dDtBaixa            , nil } )
		aAdd( aBaixa, { 'AUTDTCREDITO', dDtBaixa            , nil } )
		aAdd( aBaixa, { 'AUTHIST'     , cHist               , nil } )
		aAdd( aBaixa, { 'AUTVALREC'   , nValor              , nil } )

		Begin Transaction

			MSExecAuto( { | x, y | Fina070( x, y ) }, aBaixa, 3 )

			if lMsErroAuto

				lMsErroAuto := .F.

				aErro := aClone( GetAutoGRLog() )

				for nX := 1 to Len( aErro )

					cErro += aErro[ nX ] + CRLF

				next nX

				DisarmTransaction()

			end if

		End Transaction

	end if

	if Empty( cErro )

		regSZ1( '1', 'Baixa processada com sucesso' )

	else

		regSZ1( '2', cErro )

	endif

return

/*/{Protheus.doc} ordemSX3
Coloca a lista de campo do array de um execauto na ordem do dicionário de dados
@type function
@version 12.1.33 
@author elton.alves@totvs.com.br
@since 25/03/2022
@param aLstCpos, array, Array com a lista de campos a ser ordenada
@return array, Array com a lista de campos ordenada
/*/
static function ordemSX3( aLstCpos )

	local aOrdem := {}
	local aRet   := {}
	local nX     := 0
	local cOrdem := ''
	local nPos   := 0

	for nX := 1 to len( aLstCpos )

		cOrdem := GetSx3Cache( aLstCpos[nX,1], 'X3_ORDEM' )

		if ! empty( cOrdem )

			aAdd( aOrdem, { cOrdem, aLstCpos[nX,1] } )

		end if

	next nX

	aSort( aOrdem,,, { | x, y | x[ 1 ] < y[ 1 ] } )

	for nx := 1 to len( aOrdem )

		nPos := aScan( aLstCpos, { | x | x[ 1 ] == aOrdem[ nX, 2 ] } )

		if nPos > 0

			aAdd( aRet, aClone( aLstCpos[ nPos ] ) )

		end if

	next nX

return aRet

/*/{Protheus.doc} regSZ1
Registra no processamento o status e a mensagem de observação
@type function
@version  12.1.33
@author elton.alves
@since 25/03/2022
@param cStatus, character, satatus a ser registrado no processamento
@param cMensagem, character, Mensagem de observação a ser registrada no processamento
/*/
static function regSZ1( cStatus, cMensagem )

	RecLock( 'SZ1', .F. )

	SZ1->Z1_DATAPRC := Date()
	SZ1->Z1_HORAPRC := Time()
	SZ1->Z1_STATUS  := cStatus
	SZ1->Z1_OBSERV  := cMensagem

	SZ1->( MsUnlock() )

return

Static Function retEstrut(cPrdPai,nQtdPai)

	Local aRet := {}
	Local aEst := {}
	Local nI := 0
	//Local cQuery := ""
	Local cAlias := GetNextAlias()

	BEGINSQL ALIAS cAlias
	%NOPARSER%
	SELECT G1_FILIAL,G1_COD,G1_COMP,G1_QUANT FROM %TABLE:SG1%
	WHERE G1_FILIAL = %XFILIAL:SG1% AND G1_COD = %EXP:cPrdPai%
	AND %NOTDEL%
	ENDSQL

	//cQuery := "select g1_filial,g1_cod,g1_comp,g1_quant from "+RetSQLName("SG1")+" g1 "
	//cQuery += "where g1_filial = '"+xFilial("SG1")+"' and g1_cod = '"+cPrdPai+"' and g1.d_e_l_e_t_ = ' ' "
	//cQuery := ChangeQuery( cQuery )
	//dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.f.,.t.)
	while (cAlias)->( !eof() )
		aEst := retEstrut((cAlias)->g1_comp,nQtdPai*(cAlias)->g1_quant)
		if len(aEst) > 0
			for nI := 1 to len(aEst)
				aadd( aRet, {aEst[nI,1],aEst[nI,2],aEst[nI,3],aEst[nI,4]} )
			next
		else
			aadd( aRet, {(cAlias)->g1_comp,nQtdPai*(cAlias)->g1_quant,cPrdPai,nQtdPai} )
		endif

		(cAlias)->(dbskip())
	end

	(cAlias)->( DbCloseArea() )

Return aRet

