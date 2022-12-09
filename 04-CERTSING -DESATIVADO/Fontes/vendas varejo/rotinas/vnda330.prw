#INCLUDE "APWEBSRV.CH"
#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

//+-------------------------------------------------------------------+
//| Rotina | VNDA330 | Autor | Rafael Beghini | Data | 14.08.2019 
//+-------------------------------------------------------------------+
//| Descr. | Envia notificação ao HUB 
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+

User Function VNDA330(aParam, cPedSite, cDataProc)
	Local lJob 		:= ( Select( "SX6" ) == 0 )
	Local cJobEmp	:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, '02' , aParam[ 2 ] )	
	Local cSQL		:= ''
	
	Default	cPedSite:= ''
	Default cDataProc := ''
	
	IF lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIF

	//Andre Sant'ana - Compila 
	cDataProc := GetMV( 'MV_X330DTP' )
	Conout( "[ VNDA330 - " + Dtoc( Date() ) + " - " + Time() + " ] INICIO" )

	
	/*	Processos definidos nesta rotina
		1.Recibo de pagamento
		2.Envio Link Nota fiscal 			(cCategory := "NOTIFICA-NF")
		3.Pedidos cancelados 				(cCategory := "NOTIFICA-CANCELAMENTO-PEDIDO")
		4.Pedidos cancelados por Voucher 	(cCategory := "NOTIFICA-CANCELAMENTO-PEDIDO")
	*/

	//-- Processo 01
	cSQL += " SELECT C5_EMISSAO, " + CRLF
	cSQL += "	       C5_XNPSITE, " + CRLF
	cSQL += "	       SC5.R_E_C_N_O_ C5_RECNO " + CRLF
	cSQL += "	FROM " + RetSqlName('SC5') + " SC5 " + CRLF
	cSQL += "	       INNER JOIN " + RetSqlName('SC6') + " SC6 " + CRLF
	cSQL += "	               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "	                  AND C6_FILIAL = C5_FILIAL " + CRLF
	cSQL += "	                  AND C6_NUM = C5_NUM " + CRLF
	cSQL += "	                  AND C6_XNFCANC <> 'S' " + CRLF
	cSQL += "	WHERE  SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "	       AND C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	
	IF .NOT. Empty(cDataProc)
		cSQL += "	   AND C5_EMISSAO >= '" + cDataProc + "' " + CRLF
	EndIF

	IF .NOT. Empty(cPedSite)
		cSQL += "	   AND C5_XNPSITE = '" + cPedSite + "' " + CRLF
	EndIF
	
	cSQL += "	       AND C5_TIPMOV <> '2' " + CRLF
	cSQL += "	       AND C5_XNPSITE > ' ' " + CRLF
	cSQL += "	       AND C5_XRECPG > ' '  " + CRLF
	cSQL += "	       AND C5_XFLAGRC = ' ' " + CRLF
	cSQL += "	       AND ROWNUM <= 150    " + CRLF
	cSQL += "	GROUP  BY C5_EMISSAO,       " + CRLF
	cSQL += "	          C5_XNPSITE,    	" + CRLF
	cSQL += "	          SC5.R_E_C_N_O_    " + CRLF
	cSQL += "	ORDER  BY C5_XNPSITE        " + CRLF

	SendRecPG( cSQL )
	Sleep( 100 )
	
	//-- Processo 02 (Software)
	cSQL := ''
	cSQL += "SELECT C5_XNPSITE, " + CRLF
	cSQL += "       C5_NUM, " + CRLF
	cSQL += "       C5_XNFSFW, " + CRLF
	cSQL += "       C5_EMISSAO, " + CRLF
	cSQL += "       C6_SERIE, " + CRLF
	cSQL += "       C6_NOTA, " + CRLF
	cSQL += "       C6_DATFAT, " + CRLF
	cSQL += "       C6_XIDPED, " + CRLF
	cSQL += "       SC5.R_E_C_N_O_ C5_RECNO " + CRLF
	cSQL += "FROM   " + RetSqlName('SC5') + " SC5 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SC6') + " SC6 " + CRLF
	cSQL += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = C5_NUM " + CRLF
	cSQL += "                  AND SC6.C6_SERIE = 'RP2' " + CRLF
	cSQL += "                  AND C6_XNFCANC <> 'S' " + CRLF
	cSQL += "WHERE  SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	
	IF .NOT. Empty(cDataProc)
		cSQL += "	AND C5_EMISSAO >= '" + cDataProc + "' " + CRLF
	EndIF
	IF .NOT. Empty(cPedSite)
		cSQL += "	AND C5_XNPSITE = '" + cPedSite + "' " + CRLF
	EndIF
	
	cSQL += "       AND C5_XNPSITE > ' ' " + CRLF
	cSQL += "       AND C5_XNFSFW > ' ' " + CRLF
	cSQL += "       AND C5_XFLAGSF = ' ' " + CRLF
	cSQL += "       AND ROWNUM <= 150 " + CRLF
	cSQL += "GROUP  BY C5_XNPSITE, " + CRLF
	cSQL += "          C5_NUM, " + CRLF
	cSQL += "          C5_XNFSFW, " + CRLF
	cSQL += "          C5_EMISSAO, " + CRLF
	cSQL += "          C6_SERIE, " + CRLF
	cSQL += "          C6_NOTA, " + CRLF
	cSQL += "          C6_DATFAT," + CRLF
	cSQL += "          C6_XIDPED," + CRLF
	cSQL += "          SC5.R_E_C_N_O_" + CRLF

	SendLinkNF( cSQL, 'Software' )
	Sleep( 100 )
	
	//-- Processo 02 (Hardware)
	cSQL := ''
	cSQL += "SELECT C5_XNPSITE, " + CRLF
	cSQL += "       C5_NUM, " + CRLF
	cSQL += "       C5_XNFHRD, " + CRLF
	cSQL += "       C5_EMISSAO, " + CRLF
	cSQL += "       C6_SERIE, " + CRLF
	cSQL += "       C6_NOTA, " + CRLF
	cSQL += "       C6_DATFAT, " + CRLF
	cSQL += "       C6_XIDPED, " + CRLF
	cSQL += "       C6_XOPER, " + CRLF
	cSQL += "       SC5.R_E_C_N_O_ C5_RECNO " + CRLF
	cSQL += "FROM   " + RetSqlName('SC5') + " SC5 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SC6') + " SC6 " + CRLF
	cSQL += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = C5_NUM " + CRLF
	If cFilAnt == "02"
		cSQL += "                  AND SC6.C6_SERIE = '2  ' " + CRLF
	ElseIf cFilAnt == "01"
		cSQL += "                  AND SC6.C6_SERIE = '3  ' " + CRLF
	EndIf
	cSQL += "                  AND C6_XNFCANC <> 'S' " + CRLF
	cSQL += "WHERE  SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	
	IF .NOT. Empty(cDataProc)
		cSQL += "	AND C5_EMISSAO >= '" + cDataProc + "' " + CRLF
	EndIF
	IF .NOT. Empty(cPedSite)
		cSQL += "	AND C5_XNPSITE = '" + cPedSite + "' " + CRLF
	EndIF
	
	cSQL += "       AND C5_XNPSITE > ' ' " + CRLF
	cSQL += "       AND C5_XNFHRD > ' ' " + CRLF
	cSQL += "       AND C5_XFLAGHW = ' ' " + CRLF
	cSQL += "       AND ROWNUM <= 150 " + CRLF
	cSQL += "GROUP  BY C5_XNPSITE, " + CRLF
	cSQL += "          C5_NUM, " + CRLF
	cSQL += "          C5_XNFHRD, " + CRLF
	cSQL += "          C5_EMISSAO, " + CRLF
	cSQL += "          C6_SERIE, " + CRLF
	cSQL += "          C6_NOTA, " + CRLF
	cSQL += "          C6_DATFAT," + CRLF
	cSQL += "          C6_XIDPED," + CRLF
	cSQL += "          C6_XOPER," + CRLF
	cSQL += "          SC5.R_E_C_N_O_" + CRLF

	SendLinkNF( cSQL, 'Hardware' )
	Sleep( 100 )
	
	//-- Processo 02 (Entrega)
	cSQL := ''
	cSQL += "SELECT C5_XNPSITE, " + CRLF
	cSQL += "       C5_NUM, " + CRLF
	cSQL += "       C5_XNFHRE, " + CRLF
	cSQL += "       C5_EMISSAO, " + CRLF
	cSQL += "       C6_SERIE, " + CRLF
	cSQL += "       C6_NOTA, " + CRLF
	cSQL += "       C6_DATFAT, " + CRLF
	cSQL += "       C6_XIDPED, " + CRLF
	cSQL += "       SC5.R_E_C_N_O_ C5_RECNO " + CRLF
	cSQL += "FROM   " + RetSqlName('SC5') + " SC5 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SC6') + " SC6 " + CRLF
	cSQL += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = C5_NUM " + CRLF
	If cFilAnt == "02"
		cSQL += "                  AND SC6.C6_SERIE = '2  ' " + CRLF
	ElseIf cFilAnt == "01"
		cSQL += "                  AND SC6.C6_SERIE = '3  ' " + CRLF
	EndIf
	cSQL += "                  AND SC6.C6_XOPER = '53' " + CRLF
	cSQL += "                  AND C6_XNFCANC <> 'S' " + CRLF
	cSQL += "WHERE  SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	
	IF .NOT. Empty(cDataProc)
		cSQL += "	AND C5_EMISSAO >= '" + cDataProc + "' " + CRLF
	EndIF
	IF .NOT. Empty(cPedSite)
		cSQL += "	AND C5_XNPSITE = '" + cPedSite + "' " + CRLF
	EndIF
	
	cSQL += "       AND C5_XNPSITE > ' ' " + CRLF
	cSQL += "       AND C5_XNFHRE > ' ' " + CRLF
	cSQL += "       AND C5_XFLAGEN = ' ' " + CRLF
	cSQL += "       AND ROWNUM <= 150 " + CRLF
	cSQL += "GROUP  BY C5_XNPSITE, " + CRLF
	cSQL += "          C5_NUM, " + CRLF
	cSQL += "          C5_XNFHRE, " + CRLF
	cSQL += "          C5_EMISSAO, " + CRLF
	cSQL += "          C6_SERIE, " + CRLF
	cSQL += "          C6_NOTA, " + CRLF
	cSQL += "          C6_DATFAT," + CRLF
	cSQL += "          C6_XIDPED," + CRLF
	cSQL += "          SC5.R_E_C_N_O_" + CRLF

	SendLinkNF( cSQL, 'Entrega' )

	Conout( "[ VNDA330 - " + Dtoc( Date() ) + " - " + Time() + " ] FINAL" )
Return

//+-------------------------------------------------------------------+
//| Rotina | SendRecPG | Autor | Rafael Beghini | Data | 14.08.2019 
//+-------------------------------------------------------------------+
//| Descr. | Envia notificação de Recibo de Pagamento 
//+-------------------------------------------------------------------+
Static Function SendRecPG( cSQL )
	Local cTRB		:= GetNextAlias()
	Local nRECNO 	:= 0
	
	cSQL := ChangeQuery( cSQL )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	(cTRB)->( dbGotop() )
	
	Conout( "[ VNDA330 - " + Dtoc( Date() ) + " - " + Time() + " ] Recibo de pagamento" )

	While .NOT. (cTRB)->( EOF() )
		nRECNO := (cTRB)->C5_RECNO
		IF U_VNDA481( { nRECNO }, NIL, "Liberação de Pagamento Automatica ao Gerar Recibo de Pagamento" )
			SC5->( DbGoTo( nRECNO ) )
	
			RecLock("SC5", .F.)
				Replace SC5->C5_XFLAGRC With "X"
			SC5->(MsUnLock())
			//Conout( "[ VNDA330 - " + Dtoc( Date() ) + " - " + Time() + " ] Recibo >.< Pedido " + SC5->C5_XNPSITE + " Emissao " + dToC(SC5->C5_EMISSAO) )

			dbSelectArea('SC6')
			dbSetOrder(1)
			dbSeek( xFilial('SC6') + SC5->C5_NUM )

			While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)
				RecLock("SC6", .F.)
					Replace SC6->C6_XFLAGRC With "X"
				SC6->(MsUnLock())
				
				SC6->(DbSkip())
			End
		EndIF

		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return

//+-------------------------------------------------------------------+
//| Rotina | VNDA330 | Autor | Rafael Beghini | Data | 14.08.2019 
//+-------------------------------------------------------------------+
//| Descr. | Envia notificação da Nota Fiscal 
//+-------------------------------------------------------------------+
Static Function SendLinkNF( cSQL , cProcesso )
	Local cTRB			:= GetNextAlias()
	Local cJson			:= ''
	Local cDataGer		:= ''
	Local cCategory		:= 'NOTIFICA-NF'
	Local cError		:= ''
	Local cWarning		:= ''
	Local cSvcError		:= ''
	Local cSoapFCode	:= ''
	Local cSoapFDescr	:= ''
	Local cMSG			:= ''
	Local cOperDeliv 	:= GetNewPar("MV_XOPDELI", "01")
	Local lOk			:= .F.
	Local lErro			:= .T.
	Local lSeekC6		:= .F.
	Local nRECNO		:= 0
	Local oWsObj		:= NIL
	Local oWsRes		:= NIL
	

	oWsObj := WSVVHubServiceService():New()

	cSQL := ChangeQuery( cSQL )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	Conout( "[ VNDA330 - " + Dtoc( Date() ) + " - " + Time() + " ] Nota Fiscal - " + cProcesso )

	(cTRB)->( dbGotop() )
	While .NOT. (cTRB)->( EOF() )
		//Conout( "[ VNDA330 - " + Dtoc( Date() ) + " - " + Time() + " ] Link " + cProcesso + " >.< Pedido: " + (cTRB)->C5_XNPSITE + " Emissao " + dToC(sToD((cTRB)->C5_EMISSAO)) )
		cDataGer := Left( (cTRB)->C6_DATFAT, 4 ) + '-' + SubStr( (cTRB)->C6_DATFAT, 5, 2 ) + '-' + Right((cTRB)->C6_DATFAT,2)
		nRECNO	 := (cTRB)->C5_RECNO

		IF cProcesso == 'Software'
			cJson := '{"pedido":' + (cTRB)->C5_XNPSITE + ',' + IIF( .NOT. Empty((cTRB)->C6_XIDPED), '"pedidoItem":'+(cTRB)->C6_XIDPED + ',', '' ) +;
						'"tipo":"SERVICO","serie":"' + (cTRB)->C6_SERIE + '","numeroNF":"' + (cTRB)->C6_NOTA + '","dataGeracao":"' + cDataGer +;
						'T00:00:00.000Z","link":"' + Alltrim( (cTRB)->C5_XNFSFW ) + '"}'
		ElseIF cProcesso == 'Hardware'
			cJson := '{"pedido":' + (cTRB)->C5_XNPSITE + ',' + IIF( .NOT. Empty((cTRB)->C6_XIDPED), '"pedidoItem":'+(cTRB)->C6_XIDPED + ',', '' ) +;
						'"tipo":"PRODUTO","serie":"' + (cTRB)->C6_SERIE + '","numeroNF":"' + (cTRB)->C6_NOTA + '","dataGeracao":"' + cDataGer +;
						'T00:00:00.000Z","link":"' + Alltrim( (cTRB)->C5_XNFHRD ) + '"}'
		Else
			cJson := '{"pedido":' + (cTRB)->C5_XNPSITE + ',' + IIF( .NOT. Empty((cTRB)->C6_XIDPED), '"pedidoItem":'+(cTRB)->C6_XIDPED + ',', '' ) +;
						'"tipo":"ENTREGA","serie":"' + (cTRB)->C6_SERIE + '","numeroNF":"' + (cTRB)->C6_NOTA + '","dataGeracao":"' + cDataGer +;
						'T00:00:00.000Z","link":"' + Alltrim( (cTRB)->C5_XNFHRE ) + '"}'
		EndIF

		lOk	:= oWsObj:SendMessage( cCategory, cJson )

		cSvcError   := GetWSCError()  //-- Resumo do erro
		cSoapFCode  := GetWSCError(2) //-- Soap Fault Code
		cSoapFDescr := GetWSCError(3) //-- Soap Fault Description

		IF .NOT. Empty( cSvcError ) .OR. .NOT. Empty( cSoapFCode )
			lOk := .F.
		EndIF

		IF lOk
			oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
			IF "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
				IF oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
					SC5->( DbGoTo( nRECNO ) )
					RecLock("SC5", .F.)
						IF cProcesso == 'Software'
							Replace SC5->C5_XFLAGSF With "X"
						ElseIF cProcesso == 'Hardware'
							Replace SC5->C5_XFLAGHW With "X"
						Else
							Replace SC5->C5_XFLAGEN With "X"
						EndIF
					SC5->(MsUnLock())					
				End				
			EndIF
		EndIF

		IF cProcesso == 'Hardware' .And. (cTRB)->C6_XOPER == cOperDeliv
			DbSelectArea("PAG")
			PAG->( DbSetOrder(3) )
			IF PAG->( DbSeek( xFilial("PAG") + (cTRB)->C5_NUM ) )
				//Conout( "[ VNDA330 - " + Dtoc( Date() ) + " - " + Time() + " ] Link - " + cProcesso + ' (Rastreio) >.< Pedido: ' + (cTRB)->C5_XNPSITE + " Emissao " + dToC(sToD((cTRB)->C5_EMISSAO)) )
				cJson := '{"pedido":'+ Alltrim( (cTRB)->C5_XNPSITE ) + ',"rastreamento":"' + PAG->PAG_CODRAS + '"}'
				lOk := oWsObj:sendMessage( "NOTIFICA-ENTREGA-PEDIDO", cJson )

				cSvcError   := GetWSCError()  //-- Resumo do erro
				cSoapFCode  := GetWSCError(2) //-- Soap Fault Code
				cSoapFDescr := GetWSCError(3) //-- Soap Fault Description

				IF .NOT. Empty( cSvcError ) .OR. .NOT. Empty( cSoapFCode )
					lOk 	:= .F.
					cMSG	:= cSvcError + ' ' + cSoapFCode + ' ' + cSoapFDescr
				EndIF
				
				IF lOk
					oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
					IF "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
						IF oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
							U_GTPutOUT( (cTRB)->C5_XNPSITE,;
										"Q",;
										(cTRB)->C5_XNPSITE,;
										{ "VNDA330", { .T., "M00001", (cTRB)->C5_XNPSITE, "NOTIFICA-ENTREGA-PEDIDO enviada ao Hub com sucesso" } },;
										(cTRB)->C5_XNPSITE )
							lErro := .F.
						EndIF
					EndIF
					
				EndIF

				IF lErro					
					U_GTPutOUT( (cTRB)->C5_XNPSITE,;
								"Q",;
								(cTRB)->C5_XNPSITE,;
								{ "VNDA330", { .F., "E00024", (cTRB)->C5_XNPSITE, "Inconsistência: " + cMSG } },;
								(cTRB)->C5_XNPSITE )
					//Conout("[VNDA330] Inconsistência ao enviar informações aos correios do pedido Site "+(cTRB)->C5_XNPSITE+" rastreamento "+PAG->PAG_CODRAS+", vide GTOUT")					
				EndIF
			EndIF
		EndIF

		cSvcError   := ''
		cSoapFCode  := ''
		cSoapFDescr := ''
		cJson		:= ''
		cMSG		:= ''
		lErro		:= .T.

		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return
