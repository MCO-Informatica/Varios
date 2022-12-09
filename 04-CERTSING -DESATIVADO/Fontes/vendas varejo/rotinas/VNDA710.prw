#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | VNDA710 | Autor | Rafael Beghini | Data | 20.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para Cancelamento do Pedido Site chamado na rotina
//|        | de Service Desk
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function VNDA710( cXNPSITE, cFunName, cCancelamento )
	Local cSQL    := ''
	Local cTRB    := ''
	Local cRET    := ''
	Local cNUMVOU := ''
	Local lRet := .F.
	
	Default cCancelamento = 'Cancelamento Pedido'

	Private cXtitulo := "Cancelamento Pedido Site"
	
    /*
		Ajustes de código para atender Migração versão P12
		Uso de DbOrderNickName
		OTRS:2017103110001774
	*/
	SC5->(DbOrderNickName("PEDSITE"))		
	//SC5->( dbSetOrder(8) )
	
	SZG->( dbSetOrder(3) )
	SZG->( dbSeek( xFilial('SZG') + cXNPSITE ) )
	IF SZG->( Found() )
		cNUMVOU := SZG->ZG_NUMVOUC
		cSQL += "SELECT zf_tipovou, " + CRLF
		cSQL += "       zg_numvouc, " + CRLF
		cSQL += "       zg_numped,  " + CRLF
		cSQL += "       zg_pedsite  " + CRLF
		cSQL += "FROM   "+ RetSqlName("SZG") + " ZG " + CRLF
		cSQL += "       INNER JOIN "+ RetSqlName("SZF") + " ZF " + CRLF
		cSQL += "               ON zf_filial = zg_filial " + CRLF
		cSQL += "                  AND zf_cod = zg_numvouc " + CRLF
		cSQL += "                  AND zf_codflu = zg_codflu " + CRLF
		cSQL += "                  AND zf.d_e_l_e_t_ = ' ' " + CRLF
		cSQL += "WHERE  zg.d_e_l_e_t_  = ' ' " + CRLF
		cSQL += "       AND zg_filial  = '" + xFilial('SZG') +"' " + CRLF
		cSQL += "       AND zg_numvouc = '" + cNUMVOU        +"' " + CRLF
		
		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		PLSQuery( cSQL, cTRB )
		
		While .NOT. (cTRB)->( EOF() )
			cMSG := "Efetuado cancelamento do pedido por " + Upper(Alltrim(cUserName)) +; 
					" em ["+DtoC(Date())+"-"+Time()+"]"
			cRET := (cTRB)->ZG_PEDSITE + ';' + (cTRB)->ZG_NUMPED + ';'	 + (cTRB)->ZF_TIPOVOU + ';' + cCancelamento + ';' + cMSG
		(cTRB)->( dbSkip() )	
		End
		IF Empty(cRET)
			MsgInfo("Pedido site não localizado.",cXtitulo)
			Return( lRet )	
		Else
			A710Proc( cRET, cFunName )
		EndIF	
		(cTRB)->( DbCloseArea() )	
	ElseIF SC5->( dbSeek( xFilial('SC5') + cXNPSITE ) )
		cMSG := "Efetuado cancelamento do pedido por " + Upper(Alltrim(cUserName)) +; 
				" em ["+DtoC(Date())+"-"+Time()+"]"
		cRET := cXNPSITE + ';' + cXNPSITE + ';SC5;' + cCancelamento + ';' + cMSG
		A710Proc( cRET, cFunName )
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A710Proc | Autor | Rafael Beghini | Data | 20.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Processa o cancelamento do pedido site
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A710Proc( cXNPSITE, cFunName )
	Local cPedLog  := ''
	Local cPEDSITE := ''
	Local cNUMPED  := ''
	Local cTIPO    := ''
	Local cMSG     := ''
	Local aDADOS   := StrToKarr( cXNPSITE, ';' )
	Local nTot     := Len(aCOLS)
	Local lRet     := .F.
	Local lFound   := .T.
	
	cPEDSITE := aDADOS[1]
	cNUMPED  := aDADOS[2]
	cTIPO    := aDADOS[3]
	
	IF cTIPO == 'F' .OR. cTIPO == 'SC5' //Gera Pedido
        /*
		Ajustes de código para atender Migração versão P12
		Uso de DbOrderNickName
		OTRS:2017103110001774
		*/
		SC5->(DbOrderNickName("PEDSITE"))			
		//SC5->( dbSetOrder(8) ) //Ordem Pedido Site
		IF SC5->( dbSeek( xFilial('SC5') + cPEDSITE ) )
			cPedLog := IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,cPEDSITE)
			SC6->( dbSetOrder(1) )
			IF SC6->( dbSeek( xFilial('SC6') + SC5->C5_NUM ) )
				While !SC6->(EoF()) .And. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM
					//Marca os campos de informação de cancelamento
				    SC6->( RecLock("SC6", .F.) )
						SC6->C6_XNFCANC := "S"
						SC6->C6_XDTCANC := DdataBase
						SC6->C6_XHRCANC := Time()
						//SC6->C6_BLQ := "R" //Retirado conforme solicição Giovanni 30.05.2016
					SC6->(MsUnLock())
					
					lRet := .T.
					SC6->(DbSkip())
				End
			Else
				MsgStop("Não foram encontrados itens para Cancelar.",cXtitulo)
				Return(.F.)
			EndIF
			If lRet
				cMSG := "*** Pedido cancelado manualmente através da rotina [" + cFunName + "] por " + Upper(Alltrim(cUserName)) +; 
						 " (Atendente) em ["+DtoC(Date())+"-"+Time()+"] ***"
				//Marca o pedido para ser enviado ao hub 
				SC5->( RecLock("SC5", .F.) )
					SC5->C5_XFLAGEN := ''
					SC5->C5_XOBS	  := cMSG + CRLF + CRLF + SC5->C5_XOBS
					SC5->C5_NOTA    := IIF(Empty(SC5->C5_NOTA),'XXXXXX',SC5->C5_NOTA)
				SC5->(MsUnLock())
			EndIF
		Else
			MsgStop("Pedido Site não localizado.",cXtitulo)
			Return(.F.)
		EndIF
		
		SZG->( dbSetOrder(3) )
		SZG->( dbSeek( xFilial('SZG') + cPEDSITE ) )
		IF SZG->( Found() )
			SZG->( RecLock( 'SZG', .F. ) ) 
			SZG->ZG_MOTCANC := cMSG + CRLF + CRLF + SZG->ZG_MOTCANC
			SZG->ZG_XFLAGEN := ''
			SZG->ZG_FLAGCAN := 'X'
			SZG->( MsUnLock() )
			lRet  := .T.
			lFound := .F.
		EndIF
	ElseIf cTIPO <> 'SC5'
		cMSG := "*** Pedido cancelado manualmente através da rotina [" + cFunName + "] por " + Upper(Alltrim(cUserName)) +; 
				 " (Atendente) em ["+DtoC(Date())+"-"+Time()+"] ***"
		//Grava o motivo do cancelamento na SZG
		//Grava o motivo do cancelamento na SZG
		//Garanto que irá encontrar pelo Pedido SITE ou Pedido GAR
		SZG->( dbSetOrder(3) )
		SZG->( dbSeek( xFilial('SZG') + cPEDSITE ) )
		IF SZG->( Found() )
			SZG->( RecLock( 'SZG', .F. ) ) 
			SZG->ZG_MOTCANC := cMSG + CRLF + CRLF + SZG->ZG_MOTCANC
			SZG->ZG_XFLAGEN := ''
			SZG->ZG_FLAGCAN := 'X'
			SZG->( MsUnLock() )
			lRet  := .T.
			lFound := .F.
		EndIF
		
		IF lFound
			SZG->( dbSetOrder(1) )
			SZG->( dbSeek( xFilial('SZG') + cNUMPED ) )
			IF SZG->( Found() )
				SZG->( RecLock( 'SZG', .F. ) ) 
				SZG->ZG_MOTCANC := cMSG + CRLF + CRLF + SZG->ZG_MOTCANC
				SZG->ZG_XFLAGEN := ''
				SZG->ZG_FLAGCAN := 'X'
				SZG->( MsUnLock() )
				lRet := .T.
			EndIF
		EndIF
	Else
		lRet := .T.
		cMSG := "*** Pedido cancelado manualmente através da rotina [" + cFunName + "] por " + Upper(Alltrim(cUserName)) +; 
		        " (Atendente) em ["+DtoC(Date())+"-"+Time()+"] ***"
	EndIF
	
	U_VNDA331( {'01','02',cXNPSITE} )
	U_GTPutOUT(cPEDSITE,"X",cPedLog,{"VNDA710",{.F.,"M00002",cMSG}},cPEDSITE)
	
	IF lRet
		MsgInfo("Solicitação de cancelamento realizada com Sucesso",cXtitulo)
	EndIF	
Return