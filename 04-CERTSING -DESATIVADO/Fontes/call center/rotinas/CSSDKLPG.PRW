#include "protheus.ch"

#define GRP_SCORP	"SCP"	// Identificacao do grupo de Sistemas Corporativos
#define GRP_FISCAL	"FIS"	// Identificacao do grupo Fiscal
#define GRP_BACKOFFICE	"BKF"	// Identificacao do grupo OPERACOES

/*
---------------------------------------------------------------------------
| Rotina    | CSSDKLPG    | Autor | Gustavo Prudente | Data | 26.05.2014  |
|-------------------------------------------------------------------------|
| Descricao | Job de liberacao automatica de pagamentos - Service Desk    |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function CSSDKLPG( aParSch )
	Local cGrupo		:= ""	// Codigo do grupo ou dos grupos separados por "/" para selecao dos atendimentos
	Local cOper			:= ""  	// Codigo do operador que sera registrado na interacao do atendimento
	Local cCatSFW		:= ""	// Categoria software
	Local cCatHRD		:= ""	// Categoria Hardware
	Local dDataProc		:= CtoD( "" )	// Data de processamento (DataBase)
	Local nDiasRet  	:= 0	// Numero de dias para retornar a database e selecionar os atendimentos
	Local nX			:= 0	// Contador generico
	Local nTotal		:= 0    // Total de atendimentos processados
	Local aStatusLib	:= { 0, "",	"" }
	Local aGrpDes		:= {}	// Vetor com os grupos de destino para transferencia (parametro MV_XGPDLPG)

	/*
	aStatusLib - [ 1 ] - Acao que deve ser realizada no atendimento 0-Nenhuma, 1-Transferir, 2-Encerrar
	[ 2 ] - Mensagem a ser gravada no campo observacao da interacao do atendimento
	[ 3 ] - Grupo de destino para transferencia do atendimento
	*/

	Default aParSch		:= {}

	If Len( aParSch ) == 0
		aParSch := { "01", "02" }
	EndIf

	RpcSetType( 3 )
	RpcSetEnv( aParSch[ 1 ], aParSch[ 2 ] )

	cCatSFW		:= GetNewPar ("MV_GARSFT", "2" )
	cCatHRD		:= GetNewPar( "MV_GARHRD", "1" )
	cOper		:= GetNewPar( "MV_XOPELPG", "" )
	cCodOco		:= GetNewPar( "MV_XOCOLPG", "" )
	cCodAcao	:= GetNewPar( "MV_XACALPG", "" )

	lLogLpg		:= GetNewPar( "MV_XLOGLPG", .F. )

	nDiasRet	:= GetNewPar( "MV_XDIALPG", 0 )

	aGrpDes		:= StrToKArr( GetNewPar( "MV_XGPDLPG", "SCP90" ), "/" )
	aGrpProc 	:= StrToKArr( GetNewPar( "MV_XGRPLPG", "" ), "/" )

	dDataProc	:= dDataBase - nDiasRet

	// Rotina de geracao de log no console.log
	LogServer( "Inicio do processamento. ", lLogLpg )

	// Se nao conseguiu traduzir o parametro com os grupos, retorna com mensagem no console
	If Len( aGrpProc ) == 0
		LogServer( "Termino inexperado: Não foram encontrados grupos para processamento.", lLogLpg )
		Return( .F. )
	EndIf

	// Verifica se o operador informado eh valido para realizar o processamento
	If Empty( cOper )
		LogServer( "Termino inexperado: Operador não informado no parâmetro MV_XOPELPG.", lLogLpg )
		Return( .F. )
	Else
		SU7->( dbSetOrder( 1 ) )
		If ! SU7->( DbSeek( xFilial( "SU7" ) + cOper ) ) .Or. AllTrim( SU7->U7_COD ) <> AllTrim( cOper )
			LogServer( "Termino inexperado: Operador informado no parâmetro MV_XOPELPG não existe.", lLogLpg )
			Return( .F. )
		EndIf
	EndIf

	For nX := 1 To Len( aGrpProc )

		// Grupo de pagamento de boleto ou cartão
		cGrupo := aGrpProc[ nX ]

		// Query para buscar os atendimentos que devem ser liberados automaticamente
		BeginSql Alias "TRBADE"

			SELECT	ADE.R_E_C_N_O_ REG, ADE.ADE_CODIGO, MAX( ADE.ADE_PEDGAR ) ADE_PEDGAR,
			MAX( ADE.ADE_XPSITE ) ADE_XPSITE, MAX( ADF.ADF_CODSU0 ) ADF_CODSU0
			FROM 	%Table:ADE% ADE
			JOIN	%Table:ADF% ADF ON
			ADF.ADF_FILIAL = %xFilial:ADF%
			AND ADF.ADF_CODIGO = ADE.ADE_CODIGO
			AND ADF.ADF_DATA || ADF.ADF_HORA = (
			SELECT  MAX( ADF2.ADF_DATA || ADF2.ADF_HORA )
			FROM    %Table:ADF% ADF2
			WHERE   	ADF2.ADF_FILIAL = %xFilial:ADF%
			AND ADF2.ADF_CODIGO = ADE.ADE_CODIGO
			AND ADF2.ADF_CODSU9 <> 'TMK001'
			AND ADF2.%notDel% )
			AND ADF.%notDel%
			WHERE 		ADE.ADE_FILIAL = %xFilial:ADE%
			AND	ADE.ADE_GRUPO = %Exp:cGrupo%
			AND	ADE.ADE_STATUS <> '3'
			AND	(ADE.ADE_DATA >= %Exp:dDataProc% OR ADE.ADE_DATUSO >= %Exp:dDataProc%)
			AND	ADE.%notDel%
			GROUP BY ADE.R_E_C_N_O_, ADE.ADE_CODIGO

		EndSql

		// Libera pagamento e transfere para o grupo de origem todos os atendimentos selecionados
		Do While TRBADE->( ! EoF() )

			aStatusLib := { 0, "", "" }   // Zera status da liberacao

			// Alteração para transferir OS sem conter pedido Site ou Gar e liberar pagamento

			If Select("_PA0") > 0
				DbSelectArea("_PA0")
				DbCloseArea()
			End If 

			cQRYPA0 := " SELECT * "
			cQRYPA0 += " FROM "+ RETSQLNAME("PA0")
			cQRYPA0 += " WHERE D_E_L_E_T_ = '' "
			cQRYPA0 += " AND PA0_FILIAL = '" + xFilial("PA0") + "' "
			cQRYPA0 += " AND PA0_PROTOC = '" + TRBADE->ADE_CODIGO + "' "

			cQRYPA0 := changequery(cQRYPA0)

			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQRYPA0),"_PA0",.F.,.T.)

			cOs := _PA0->PA0_OS

			If Empty( _PA0->PA0_OS )

				// Somente processa a liberacao se tiver preenchido o pedido GAR ou pedido Site
				If Empty( TRBADE->ADE_XPSITE ) .And. Empty( TRBADE->ADE_PEDGAR )

					lRet := .F.
					aStatusLib := { 1, ;
					"Liberação não realizada. Pedido GAR ou pedido site não informados no atendimento.", ;
					RetGrpDes( GRP_SCORP, aGrpDes ) }	// SCP - Sistemas Corporativos

				ElseIf !Empty( TRBADE->ADE_XPSITE )

					lRet := XLibSite( TRBADE->ADE_XPSITE, cOper, @aStatusLib, aGrpDes, cCatSFW, cCatHRD )

				ElseIf !Empty( TRBADE->ADE_PEDGAR )

					lRet := XLibGAR( TRBADE->ADE_PEDGAR, cOper, @aStatusLib, aGrpDes, cCatSFW, cCatHRD  )

				EndIf

			Else

				lRet := XLibOs( _PA0->PA0_OS, cOper, @aStatusLib, aGrpDes, cCatSFW, cCatHRD )

				If lRet

					BEGIN TRANSACTION                         
						// Posiciona no atendimento selecionado
						DbSelectArea( "ADE" )
						DbGoTo( TRBADE->REG )

						RecLock("ADE",.F.)
						// Se estiver em branco o grupo de destino, assume o grupo de origem
						If (Len( aStatusLib ) < 3 .Or. Empty( aStatusLib[ 3 ] ))
							ADE->ADE_GRUPO := RetGrpDes( GRP_BACKOFFICE, aGrpDes )
						Else
							ADE->ADE_GRUPO := aStatusLib[ 3 ]
						EndIf				            

						MsunLock("ADE")

						RecLock("PA0",.F.)
						PA0->PA0_STATUS := "2"
						MsUnlock("PA0")

					END TRANSACTION	

					DbSelectArea("PAW")
					DbSetOrder(4)
					DbSeek(xFilial("PAW")+_PA0->PA0_OS)

					If Found()

						While !EOF() .and. PAW->PAW_STATUS == "P"

							If PAW->PAW_OS == cOs

								BEGIN TRANSACTION 							
									RecLock("PAW",.F.)
									PAW->PAW_STATUS := "L"
									MsUnlock()
								END TRANSACTION

							End If

							dBSkip()

						End

						cFileName := ""

						cMail := _PA0->PA0_EMAIL

						cAssuntoEm := 'Solicitação de validação em domicílio - Confirmação de pagamento e agendamento' //'Solicitação de atendimento - Confirmação de Pagamento'

						cCase := "PAGAMENTO"

						lRet := U_CSFSEmail(cOs, cFileName, cMail, cAssuntoEm, cCase)

					End If

				End If

			End If

			// Realiza a acao de transferencia ou encerramento do atendimento
			If aStatusLib[ 1 ] > 0

				If aStatusLib[ 1 ] == 1			// Transfere atendimento
					ProcTransf( cOper, aStatusLib )

				ElseIf aStatusLib[ 1 ] == 2     // Finaliza atendimento
					ProcFinal( cOper, aStatusLib, cCodOco, cCodAcao )

				EndIf

			EndIf

			// Se houve problema no processamento, grava log no console do servidor
			If ! lRet
				LogServer( "[ Problemas ao processar o protocolo: " + AllTrim( TRBADE->ADE_CODIGO ) + " ] " + aStatusLib[ 2 ], lLogLpg )
			EndIf

			nTotal ++

			TRBADE->( DbSkip() )

		EndDo

		TRBADE->( DbCloseArea() )

	Next nX

	LogServer( "Termino normal. " + AllTrim( Str( nTotal ) ) + " atendimento(s) processado(s).", lLogLpg )

Return( .T. )


/*
---------------------------------------------------------------------------
| Rotina    | LogServer   | Autor | Gustavo Prudente | Data | 28.05.2014  |
|-------------------------------------------------------------------------|
| Descricao | Grava log no console do server                              |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Mensagem a ser gravada no log                       |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function LogServer( cMsg, lLogLpg )

	Default cMsg	:= ""
	Default lLogLpg	:= .F.

	If lLogLpg
		Conout( "[CSSDKLPG] [" + DtoC( Date() ) + " " + Time() + "] " + cMsg )
	EndIf

Return( Nil )


/*
---------------------------------------------------------------------------
| Rotina    | LoadACols   | Autor | Gustavo Prudente | Data | 30.05.2014  |
|-------------------------------------------------------------------------|
| Descricao | Preenche os dadosd e aHeader e aCols para transferencia     |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Codigo do atendimento a ser transferido             |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function LoadACols( cCodADE )
	Local aArea		:= GetArea()		// Salva a area
	Local nX		:= 0 				// Contador de colunas
	Local nUsado	:= 0
	Local nLenCOls	:= 0
	Local cFilADF	:= xFilial( "ADF" )

	DbSelectArea( "SX3" )
	DbSetorder( 1 )
	DbSeek( "ADF" )

	While !Eof() .And. X3_ARQUIVO == "ADF"

		If X3Uso( X3_USADO )
			nUsado++
			Aadd( aHeader, {	X3TITULO()	,;			// 01
			X3_CAMPO	,;			// 02
			X3_PICTURE	,;			// 03
			X3_TAMANHO	,;			// 04
			X3_DECIMAL	,;			// 05
			X3_VALID	,;			// 06
			X3_USADO	,;			// 07
			X3_TIPO		,;			// 08
			X3_ARQUIVO	,;			// 09
			X3_CONTEXT	,;			// 10
			X3_PROPRI 	} )			// 11
		Endif
		DbSkip()

	EndDo

	DbSelectArea( "ADF" )
	DbSetorder( 1 )
	DbSeek( cFilADF + cCodADE )

	While !EoF() .And. ADF_FILIAL == cFilADF .And. ADF_CODIGO == cCodADE

		Aadd( aCols, Array( nUsado + 1 ) )

		nLenCols := Len( aCols )

		For nX := 1 to Len( aHeader )

			If ( aHeader[ nX, 10 ] != "V" .And. aHeader[ nX, 08 ] != "M" )
				aCols[ nLenCols, nX ] := FieldGet( FieldPos( aHeader[ nX, 2] ) )
			Else
				If IsHeadAlias( aHeader[ nX, 2 ] )
					aCols[ nLenCols, nX ] := "ADF"
				ElseIf IsHeadRec( aHeader[ nX, 2 ] )
					aCols[ nLenCols, nX ] := Recno()
				ElseIf ( aHeader[ nX, 08 ] != "M" )
					aCols[ nLenCols, nX ] := CriaVar( aHeader[ nX, 2 ], .T. )
				ElseIf ( aHeader[ nX, 08 ] == "M" )
					aCols[ nLenCols, nX ] := ""
				Else
					aCols[ nLenCols, nX ] := FieldGet( FieldPos( aHeader[ nX, 2 ] ) )
				Endif
			Endif

			aCols[ nLenCols, nUsado + 1 ] := .F.

		Next nX

		DbSelectArea("ADF")
		DbSkip()

	EndDo

	RestArea( aArea )

Return( Nil )



/*
---------------------------------------------------------------------------
| Rotina    | XLibGAR     | Autor | Gustavo Prudente | Data | 30.05.2014  |
|-------------------------------------------------------------------------|
| Descricao | Identifica e libera pedido GAR para validacao, com envio de |
|           | notificacao ao HUB. 										  |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Numero do pedido GAR para liberacao de pagamento    |
|           | EXPC2 - Operador para registro na interacao do atendimento  |
|           | EXPA3 - Vetor com o status da liberacao de pagamento        |
|           |         [ 1 ] - Codigo da acao a ser tomada apos a liberacao|
|           |                 0 - Nenhuma acao                            |
|           |                 1 - Transfere o atendimento para um grupo   |
|           |                 2 - Encerra o atendimento                   |
|           |         [ 2 ] - Mensagem a ser gravada no item do chamado   |
|           |         [ 3 ] - Grupo de destino para transferencia         |
|           | EXPA4 - Vetor os grupos de destino (parametro MV_XGPDLPG)   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function XLibGar( cPedGar, cOper, aStatusLib, aGrpDes, cCatSFW, cCatHRD )

	Local aArea		:= GetArea()
	Local aRetLib	:= {}
	Local aMsg		:= {}

	Local nRecC5	:= 0
	Local lRet		:= .T.

	Local cOperNPF	:= GetNewPar("MV_XOPENPF", "61,62")

	/*
	Ajustes de código para atender Migração versão P12
	Uso de DbOrderNickName
	OTRS:2017103110001774
	*/
	DbSelectArea( "SC5" )
	DbOrderNickName("NUMPEDGAR")

	lRet := DbSeek( xFilial( "SC5" ) + cPedGar )

	If ! lRet
		// Transfere com a mensagem abaixo para o grupo de Sistemas Corporativos (GRP_SCORP)
		aStatusLib := {	1, ;
		"Liberação não realizada. Pedido GAR " + AllTrim( cPedGar ) + " não localizado no Protheus.", ;
		RetGrpDes( GRP_SCORP, aGrpDes ) }	// SCP - Sistemas Corporativos

	ElseIf SC5->C5_TIPMOV == "2" .And. Empty( SC5->C5_XCODAUT )
		lRet := .F.
		aStatusLib := { 1, "Liberação não realizada. Pedido " + AllTrim( cPedGar ) + " referente a compra com cartão nâo Autorizado." }

	ElseIf ( ( SC5->C5_XORIGPV <> "7" .And. Empty( SC5->C5_CHVBPAG ) ) .Or. ( SC5->C5_XORIGPV == "7" .and. Empty( SC5->C5_XPEDORI ) ) )
		lRet := .F.
		aStatusLib := { 1, "Liberação não realizada. Pedido " + AllTrim( cPedGar ) + " do Portal de Assinaturas não necessita de liberação." }

	EndIf

	If lRet

		// Verifica se o pedido foi liberado anteriormente
		aRetLib := XVerLib( SC5->C5_NUM, cCatSFW, cCatHRD )

		If ! aRetLib[ 1 ]
			// Retorna o atendimento para o grupo de origem com a mensagem
			aStatusLib := { 1, aRetLib[ 2 ] }
			lRet := .F.
		Else

			nRecC5 := SC5->( Recno() )

			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
				lRecPag 	:= SC6->C6_XOPER $ cOperNPF
			EndIf


			U_XA410HRD()

			SC5->( DbGoTo( nRecC5 ) )

			xObs := SC5->C5_XOBS

			Reclock( "SC5", .F. )
			SC5->C5_XOBS := "*** Liberação de pagamento realizada pelo Financeiro em " + ;
			DtoC( Date() ) + "-" + Time() + " - Protocolo: " + ;
			TRBADE->ADE_CODIGO + " ***" + chr( 13 ) + chr( 10 ) + xObs
			SC5->( Msunlock()  )

			aMsg := XVerPDF( aRetLib[ 3 ] /* lSfw */, aRetLib[ 4 ] /* lHrd */, SC5->C5_XNFSFW, SC5->C5_XNFHRD, lRecPag ,SC5->C5_XRECPG )

			If lRecPag .and. ! Empty( aMsg[ 1 ] )		// Mensagem de erro

				// 1 - Transfere atendimento com a mensagem para o grupo Sistemas Corporativos
				aStatusLib := { 1, "Pedido site "+SC5->C5_XNPSITE+" com inconsistência na geração de recibo automatico pelo ServiceDesk.", RetGrpDes( GRP_SCORP, aGrpDes ) }
				lRet := .F.

			ElseIf ! Empty( aMsg[ 1 ] )		// Mensagem de erro

				// 1 - Transfere atendimento com a mensagem para o grupo Fiscal (GRP_FISCAL)
				aStatusLib := { 1, aMsg[ 1 ], RetGrpDes( GRP_FISCAL, aGrpDes ) }
				lRet := .F.

			ElseIf ! Empty( aMsg[ 2 ] )	// Mensagem de aviso

				// 2 - Finaliza o atendimento com a mensagem abaixo
				aStatusLib := { 2, aMsg[ 2 ] }

			EndIf


		EndIf

	EndIf

	RestArea( aArea )

Return( lRet )


/*
---------------------------------------------------------------------------
| Rotina    | XLibSite    | Autor | Gustavo Prudente | Data | 02.06.2014  |
|-------------------------------------------------------------------------|
| Descricao | Identifica e libera pedido de hardware avulso.              |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Numero do pedido site gravado no atendimento        |
|           | EXPC2 - Mensagem para interacao na resposta do atendimento  |
|           | EXPA3 - Vetor com o status da liberacao de pagamento        |
|           |         [ 1 ] - Codigo da acao a ser tomada apos a liberacao|
|           |                 0 - Nenhuma acao                            |
|           |                 1 - Transfere o atendimento para um grupo   |
|           |                 2 - Encerra o atendimento                   |
|           |         [ 2 ] - Mensagem a ser gravada no item do chamado   |
|           |         [ 3 ] - Grupo de destino para transferencia         |
|           | EXPC4 - Vetor com os grupos de destino para transferencia   |
|           | EXPC5 - Categoria de software informada em parametro        |
|           | EXPC6 - Categoria de hardware informada em parametro        |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function XLibSite( cPedSite, cOper, aStatusLib, aGrpDes, cCatSFW, cCatHRD )
	Local aArea    := GetArea()
	Local aRetLib  := {}
	Local aRVou	   := {}
	Local aMsg	   := {}
	Local nRecC5   := 0
	Local lRet	   := .T.
	Local cOperNPF := GetNewPar("MV_XOPENPF", "61,62")
	local oVoucher := nil

	/*
	Ajustes de código para atender Migração versão P12
	Uso de DbOrderNickName
	OTRS:2017103110001774
	*/

	DbSelectArea( "SC5" )
	DbOrderNickName("PEDSITE")
	lRet := DbSeek( xFilial( "SC5" ) + cPedSite )

	If ! lRet
		// Transfere com a mensagem abaixo para o grupo de Sistemas Corporativos (GRP_SCORP)
		aStatusLib := {	1, ;
		"Liberação não realizada. Pedido Site número " + AllTrim( cPedSite ) + " não localizado no Protheus.", ;
		RetGrpDes( GRP_SCORP, aGrpDes ) }	// SCP - Sistemas Corporativos
	ElseIf SC5->C5_TIPMOV =="2"  .And. Empty( SC5->C5_XCODAUT )
		lRet := .F.
		aStatusLib := { 1, "Liberação não realizada. Pedido " + AllTrim( cPedSite ) + " referente a compra com Cartão nâo Autorizado." }
	ElseIf Empty( SC5->C5_XNPSITE )
		lRet := .F.
		aStatusLib := { 1, ;
		"Liberação não realizada. Pedido "  + AllTrim( cPedSite ) + " não se refere a compra via site.", ;
		RetGrpDes( GRP_SCORP, aGrpDes ) } // SCP - Sistemas Corporativos
	EndIf

	If lRet
		// Verifica se o pedido foi liberado anteriormente
		aRetLib := XVerLib( SC5->C5_NUM, cCatSFW, cCatHRD )
		If ! aRetLib[ 1 ]
			// Retorna o atendimento para o grupo de origem com a mensagem
			aStatusLib := { 1, "Liberação já realizada anteriormente. " + aRetLib[ 2 ] }
			lRet := .F.
		Else
			nRecC5		:= SC5->( Recno() )
			xObs   		:= SC5->C5_XOBS
			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
				lRecPag 	:= SC6->C6_XOPER $ cOperNPF
			EndIf

			// Processa Faturamento
			If ! Empty( SC5->C5_XNUMVOU )
				//Carrega dados do 
				oVoucher := getVoucher( cPedSite )

				//Valida voucher
				aRVou := U_VNDA430( oVoucher )
				
				aParamFun := {SC5->C5_NUM,;
				Val(SC5->C5_XNPSITE),;
				.T.,;
				nil,;
				aRVou[4],;
				aRVou[5],;
				nil,;
				iif(!Empty(aRVou[7]),aRVou[7],nil),;
				iif(!Empty(aRVou[8]),aRVou[8],nil),;
				iif(!Empty(aRVou[6]),aRVou[6],nil),;
				nil,;
				nil,;
				.T.,;
				.F.,;
				nil,;
				nil}

				U_VNDA190( "" ,aParamFun )

			Else

				U_XA410HRD()

			EndIf

			SC5->( DbGoTo( nRecC5 ) )

			Reclock( "SC5", .F. )
			SC5->C5_XOBS := "*** Liberado e faturado pelo Financeiro em " + ;
			DtoC( Date() ) + "-" + Time() + " + Protocolo: " + ;
			TRBADE->ADE_CODIGO + " ***" + chr(13) + chr(10) + xObs
			SC5->( MsUnlock() )

			aMsg := XVerPDF( aRetLib[ 3 ] /* lSfw */, aRetLib[ 4 ] /* lHrd */, SC5->C5_XNFSFW, SC5->C5_XNFHRD, lRecPag ,SC5->C5_XRECPG )

			If lRecPag .and. ! Empty( aMsg[ 1 ] )

				// 1 - Transfere atendimento com a mensagem para o Sistemas Corporativos
				aStatusLib := { 1, "Pedido site "+SC5->C5_XNPSITE+" com inconsistencia na geração de recibo automatico pelo ServiceDesk.", RetGrpDes( GRP_SCORP, aGrpDes ) }
				lRet := .F.

			ElseIf ! Empty( aMsg[ 1 ] )
				// 1 - Transfere atendimento com a mensagem para o grupo Fiscal (GRP_FISCAL)
				aStatusLib := { 1, aMsg[ 1 ], RetGrpDes( GRP_FISCAL, aGrpDes ) }
				lRet := .F.

			ElseIf ! Empty( aMsg[ 2 ] )
				// 2 - Finaliza o atendimento com a mensagem abaixo
				aStatusLib := { 2, "Liberação realizada. " + aMsg[ 2 ] }

			EndIf

		EndIf

	EndIf

	RestArea( aArea )

Return( lRet )


/*
---------------------------------------------------------------------------
| Rotina    | RetGrpDes   | Autor | Gustavo Prudente | Data | 03.06.2014  |
|-------------------------------------------------------------------------|
| Descricao | Retorna o codigo do grupo de destino para transferencia do  |
|           | atendimento, a partir do parametro MV_XGPDLPG 			  |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Sigla do grupo de atendimento do parametro          |
|           | EXPC2 - Codigo do grupo de atendimento do Service Desk      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function RetGrpDes( cSigla, aGrpDes )

	Local nPos := 0
	Local cRet := "90"		// Quando nao existir grupos de destino, assume sistemas corporativos

	nPos := aScan( aGrpDes, { |x| SubStr( x, 1, 3 ) == cSigla } )

	// Se encontrou, retorna o codigo do grupo de destino
	If nPos > 0

		cRet := SubStr( aGrpDes[ nPos ], 4, Len( aGrpDes[ nPos ] ) )

		// Se nao encontrou o grupo de destino, assume sistemas corporativos
	Else

		// Procura codigo de sistemas corporativos se existir elementos no vetor de grupos de destino
		If Len( aGrpDes ) > 0

			nPos := aScan( aGrpDes, { |x| SubStr( x, 1, 3 ) == GRP_SCORP } )

			// Se encontrou, busca o codigo na posicao do grupo
			If nPos > 0
				cRet := SubStr( aGrpDes[ nPos ], 4, Len( aGrpDes[ nPos ] ) )
			EndIf

		EndIf

	EndIf

Return( cRet )



/*
---------------------------------------------------------------------------
| Rotina    | ProcTransf  | Autor | Gustavo Prudente | Data | 28.05.2014  |
|-------------------------------------------------------------------------|
| Descricao | Realiza o processamento de transferencia do atendimento     |
|           | de volta para o grupo de origem                             |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Codigo do operador do service-desk que fara a       |
|           |         transferencia do atendimento automaticamente        |
|           | EXPN2 - Numero do recno do atendimento a realizar a transf. |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ProcTransf( cOper, aStatusLib )

	Local aArea 	:= GetArea()
	Local cFilSU0	:= xFilial("SU0")
	Local cFilSKK	:= xFilial("SKK")
	Local cGrpDes	:= ""
	Local cAssunto	:= ""
	Local cDescGrp	:= ""
	Local cCodADE	:= ""
	Local cDescObs	:= ""

	Private aHeader	:= {}
	Private aCols	:= {}

	// Posiciona no atendimento selecionado
	DbSelectArea( "ADE" )
	DbGoTo( TRBADE->REG )

	// Se estiver em branco o grupo de destino, assume o grupo de origem
	If Len( aStatusLib ) < 3 .Or. Empty( aStatusLib[ 3 ] )
		cGrpDes := TRBADE->ADF_CODSU0
	Else
		cGrpDes := aStatusLib[ 3 ]
	EndIf

	// Monta variaveis de memoria do atendimento
	cCodADE		:= TRBADE->ADE_CODIGO
	cAssunto	:= Posicione( "SKK", 1, cFilSKK + cGrpDes, "KK_CODSKQ" )
	cDescGrp	:= Posicione( "SU0", 1, cFilSU0 + cGrpDes, "U0_NOME" )

	// Monta texto do campo observacao
	If Empty( aStatusLib[ 2 ] )
		cDescObs := "Chamado transferido para área : " + cDescGrp
	Else
		cDescObs := aStatusLib[ 2 ]
	EndIf

	// Carrega aHeader e aCols
	LoadACols( cCodADE )

	// Efetiva transferencia do atendimento
	Tk510ClrGrp()
	Tk510TGrp( cGrpDes, cOper )

	TkUpdCall(	/*cFil*/,;
	/*cCodAction*/,;
	/*cCodReview*/,;
	cDescObs,;
	/*cTPACAO*/,;
	cOper,;
	cGrpDes,;//Posicione("SU7", 1, xFilial("SU7")+TkOperador(), "U7_POSTO"),;
	"",;
	/*dPrazo*/,;
	dDatabase,;
	cCodADE,;
	"TMK001")

	// Libera atendimento
	TK510UsrLock( "U", cCodADE, cOper )

	RestArea( aArea )

Return( .T. )


/*
---------------------------------------------------------------------------
| Rotina    | ProcFinal   | Autor | Gustavo Prudente | Data | 03.06.2014  |
|-------------------------------------------------------------------------|
| Descricao | Realiza o processamento de encerramento do atendimento      |
|           | no grupo do atendimento para ocorrencia e acao configurados |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Codigo do operador do service-desk que fara a       |
|           |         transferencia do atendimento automaticamente        |
|           | EXPA2 - Vetor com as informacoes de status de liberacao     |
|           | EXPC3 - Codigo da ocorrencia de encerramento configurada    |
|           | EXPC4 - Codigo da acao de encerramento configurada          |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ProcFinal( cOper, aStatusLib, cCodOco, cCodAcao )

	Local cCodADE	:= TRBADE->ADE_CODIGO
	Local lLogLpg	:= GetNewPar( "MV_XLOGLPG", "F" )
	private aHeader:={}
	private acols:={}

	// Se nao foi preenchido ocorrencia nem acao para encerramento, registra mensagem de log no servidor
	If Empty( cCodOco ) .And. Empty( cCodAcao )

		LogServer( "Encerramento não realizado. Verifique se os parâmetros MV_XOCOLPG e MV_XACALPG estão configurados.", lLogLpg )

	Else

		If Empty( cCodOco )

			LogServer( "Encerramento não realizado. O parâmetro MV_XOCOLPG deve ser configurado para ocorrer o encerramento.", lLogLpg )

		Else

			// Posiciona no atendimento selecionado
			DbSelectArea( "ADE" )
			DbGoTo( TRBADE->REG )

			// Se estiver em branco o grupo de destino, assume o grupo de origem
			If Len( aStatusLib ) < 3 .Or. Empty( aStatusLib[ 3 ] )
				cGrpDes := TRBADE->ADF_CODSU0
			Else
				cGrpDes := aStatusLib[ 3 ]
			EndIf

			// Carrega aHeader e aCols
			LoadACols( cCodADE )

			// Efetiva encerramento do atendimento com a ocorrencia e acao configuradas
			TkUpdCall(	/*cFil*/,;
			cCodAcao/*cCodAction*/,;
			/*cCodReview*/,;
			aStatusLib[ 2 ],;
			/*cTPACAO*/,;
			cOper,;
			cGrpDes,;//Posicione("SU7", 1, xFilial("SU7")+TkOperador(), "U7_POSTO"),;
			"",;
			/*dPrazo*/,;
			dDatabase,;
			cCodADE,;
			cCodoco )

			// Libera atendimento
			TK510UsrLock( "U", cCodADE, cOper )

		EndIf

	EndIf

Return( .T. )


/*
---------------------------------------------------------------------------
| Rotina    | UPDLPG01    | Autor | Gustavo Prudente | Data | 29.05.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para rotina de liberacao automatica de      |
|           | pagamentos - Service Desk                                   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function UPDLPG01

	Local cModulo := "TMK"
	Local bPrepar := { || UPLPGIni() }
	Local nVersao := 1.1

	Private aSX3  := {}
	Private aHelp := {}

	NGCriaUpd( cModulo, bPrepar, nVersao )

Return


/*
---------------------------------------------------------------------------
| Rotina    | UPDLPgIni   | Autor | Gustavo Prudente | Data | 29.05.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para rotina de liberacao automatica de      |
|           | pagamentos - Service Desk                                   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function UPLPGIni()

	Local cLog := ""

	// ADE - Atendimentos Service-Desk
	AAdd( aSX3, {	"ADE","","ADE_XPSITE","C", 10,0 ,"Pedido Site","Pedido Site", ;
	"Pedido Site" ,"Numero do pedido no site" ,"Numero do pedido no site", "Numero do pedido no site", ;
	"9999999999","Vazio() .Or. u_CTSDK20( M->ADE_XPSITE )","€€€€€€€€€€€€€€ ","","",1,"þÀ","","","U","N","A","R", ;
	"","","","","","","","","","1","","","","","","","","" } )

	AAdd( aHelp, { "ADE_XNPSITE" ,"Número do pedido site."} )

	cLog := "(SX3) Tabela ADE - Novo campo ADE_XPSITE" + CRLF
	cLog += "(HELP) Tabela ADE - Novo help do campo ADE_XPSITE"

	NGUpdObserv( cLog )

Return( .T. )


/*
---------------------------------------------------------------------------
| Rotina    | XVerLib     | Autor | Gustavo Prudente | Data | 10.06.2014  |
|-------------------------------------------------------------------------|
| Descricao | Verifica se o pedido foi liberado anteriormente e retorna   |
|           | mensagem das notas ja geradas.                              |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Numero do pedido de venda Protheus (SC5)            |
|           | EXPC2 - Categoria de produtos de software                   |
|           | EXPC3 - Categoria de produtos de hardware                   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function XVerLib( cNumPed, cCatSFW, cCatHRD )

	Local nX		:= 0

	Local lSfw		:= .F.
	Local lHrd		:= .F.

	Local cMsg		:= ""
	Local cCatTmp	:= cCatSFW

	Default cNumPed := SC5->C5_NUM

	For nX := 1 To 2

		If nX == 2
			cCatTMP := cCatHRD
		EndIf

		// Query que verifica se o Pedido contem produtos de Software
		BeginSql Alias "TRBSC6"

			SELECT Count( C6.R_E_C_N_O_ ) NCOUNT
			FROM %Table:SC6% C6
			INNER JOIN %Table:SB1% B1 ON
			B1.B1_FILIAL = %xFilial:SB1% AND
			B1.B1_COD    = C6.C6_PRODUTO AND
			B1.B1_CATEGO = %Exp:cCatTMP% AND
			B1.%notDel%
			WHERE
			C6.C6_FILIAL = %xFilial:SC6% AND
			C6.C6_NUM    = %Exp:cNumPed% AND
			C6.%notDel%

		EndSql

		If nX == 2		// Venda de Software
			lHrd := TRBSC6->NCOUNT > 0
		Else 			// Venda de Hardware
			lSfw := TRBSC6->NCOUNT > 0
		EndIf

		TRBSC6->( DbCloseArea() )

	Next nX

	If !Empty(SC5->C5_XRECPG)
		cMsg := "Pedido já estava liberado"
	ELseIf lHrd .And. !Empty( SC5->C5_XNFHRD ) .And. lSfw .and. !Empty( SC5->C5_XNFSFW )
		cMsg := "Pedido já estava liberado"
	ElseIf lHrd .And. !lSfw .And. !Empty( SC5->C5_XNFHRD )
		cMsg := "Pedido já estava liberado"
	ElseIf !lHrd .And. lSfw .And. !Empty( SC5->C5_XNFSFW )
		cMsg := "Pedido já estava liberado"
	EndIf

Return( { Empty( cMsg ), cMsg, lSfw, lHrd } )



/*
---------------------------------------------------------------------------
| Rotina    | XVerPDF     | Autor | Gustavo Prudente | Data | 24.06.2014  |
|-------------------------------------------------------------------------|
| Descricao | Verifica se o link das notas de hardware e/ou software      |
|           | foram gerados corretamente e retorna mensagem.              |
|-------------------------------------------------------------------------|
| Parametros| EXPL1 - Indica se existe produto de software                |
|           | EXPL2 - Indica se existe produto de hardware                |
|           | EXPC3 - Link da nota de software                            |
|           | EXPC4 - Link da nota de hardware                            |
|           | EXPC5 - Indica se refere a pedido que necessita de recibo   |
|           | EXPC6 - Link do recibo de pagamento                         |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function XVerPDF( lSfw, lHrd, cLinkSfw, cLinkHrd, lRecPag ,cLinkRcb )

	Local cMsgAvi := ""
	Local cMsgErr := ""

	If lRecPag .and. !Empty(cLinkRcb)
		cMsgAvi := "Pedido liberado com sucesso"

	ElseIf lRecPag .and. Empty(cLinkRcb)
		cMsgErr := "Inconsistência ao gerar recibo"

	ElseIf lHrd .And. ! Empty( cLinkHrd ) .And. lSfw .And. ! Empty( cLinkSfw )
		cMsgAvi := "Pedido liberado com sucesso"

	ElseIf lHrd .And. lSfw .And. ( Empty( cLinkHrd ) .Or. Empty( cLinkSfw ) )
		cMsgErr := "Inconsistência ao Gerar PDF das Notas de Hardware ou Software"

	ElseIf lHrd .And. !lSfw .And. !Empty( cLinkHrd )
		cMsgAvi := "Pedido liberado com sucesso"

	ElseIf lHrd .And. !lSfw .And. Empty( cLinkHrd )
		cMsgErr := "Inconsistência ao Gerar PDF da Nota de Hardware"

	ElseIf !lHrd .And. lSfw .And. !Empty( cLinkSfw )
		cMsgAvi := "Pedido liberado com sucesso"

	ElseIf !lHrd .And. lSfw .And. Empty( cLinkSfw )
		cMsgErr := "Inconsistência ao Gerar PDF da Nota de Software"

	EndIf

Return( { cMsgErr, cMsgAvi } )


/*
---------------------------------------------------------------------------
| Rotina    | XLibOs   | Autor | Claudio H. Correa | Data | 02.06.2014  |
|-------------------------------------------------------------------------|
| Descricao | Identifica e libera OS.                                     |
|-------------------------------------------------------------------------|
| Parametros|                                                             |
|           |                                                             |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function XLibOs( cOs, cOper, aStatusLib, aGrpDes, cCatSFW, cCatHRD )

	Local aArea := GetArea()
	Local lRet  := .T.

	DbSelectArea( "PA0" )
	DbSetOrder( 1 )

	lRet := DbSeek( xFilial( "PA0" ) + cOs )

	If lRet

		If PA0->PA0_STATUS == "1"

			aStatusLib := {   2, ;
			"Liberação realizada. OS número " + cOs, ;
			RetGrpDes( GRP_BACKOFFICE, aGrpDes ) }

		Else

			aStatusLib := { 1, "Liberação não realizada, pois a OS já se encontra liberada e ou finalizada. " }
			lRet := .F.

		End If

	End If


	RestArea( aArea )

Return( lRet )

static function getVoucher( cPedSite )
	local oVoucher := nil
	local oPedido  := nil
	local oQuery   := nil
	local cError   := ""
	local cWarning := ""
	local cID      := ""
	local cQuery   := ""
	local cAlias   := ""
	local nPed     := 0

	cQuery := "SELECT GT_ID "
	cQuery += "		FROM GTIN "
	cQuery += "WHERE GT_TYPE = 'F' "
	cQuery += "		AND D_E_L_E_T_ = ' ' "	
	cQuery += "		AND GT_XNPSITE IN ('"+ alltrim( cPedSite )+ "')"
	
	oQuery := CSQuerySQL():New()
	if oQuery:Consultar( cQuery )
		cAlias := oQuery:GetAlias()
		cID    := ( cAlias )->GT_ID
		( cAlias )->( dbCloseArea() )
	
		//Monto XML do pedido
		oPedido  := montarXML( cID, @cError, @cWarning, @nPed )
	
		//Carrego dados do Voucher
		oVoucher := CSVoucherPV:New( cID, cPedSite, cPedSite, oPedido:_LISTPEDIDOFULLTYPE:_PEDIDO[ nPed ] )
	endif
return oVoucher

static function montarXML( cID, cError, cWarning, nPed )
	Local cRootPath		:= ""
	Local cArquivo		:= ""
	
	default cID      := ""
	default cError   := ""
	default cWarning := ""
	default nPed     := 0 

	//Monta caminho do arquivo
	cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
	cRootPath	+= "vendas_site\"
	If Len( cID ) <= 18
		cArquivo	:= "Pedidos_" + Left(cID,12) + ".XML"
	Else
		cArquivo	:= "Pedidos_" + Left(cID,17) + ".XML"
	EndIf
	cArquivo	:= cRootPath + cArquivo

	//Monta xml com base em arquivo fisico gravado no servidor
	oXml := XmlParserFile( cArquivo, "_", @cError, @cWarning )
	
	if empty( cError)
		If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
			XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
		EndIf

		nPed := Val( Right( alltrim( cID ), 6 ) )
	endif
return oXml