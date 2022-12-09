#Include 'Protheus.ch'
#Include 'TopConn.ch'
//+-------------------------------------------------------------------+
//| Rotina | VNDA690 | Autor | Rafael Beghini | Data | 19.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para Cancelamento do Pedido Site chamado na rotina
//|        | de Voucher
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function VNDA690( )
	Local cNumvou  := SZF->ZF_COD
	Local aRet     := {}
	Local aParBox  := {}
	Local cXNPSITE := ''
	
	Private cXtitulo := "Cancelamento Pedido Site"
	Private cFunName := FunName()
	
	IF MsgYesNo('Deseja cancelar o pedido site referente ao voucher ' + cNumvou + '?' ,cXtitulo)
		aAdd(aParBox,{11,"Informe o motivo","",".T.",".T.",.T.})
		IF ParamBox(aParBox,cXtitulo,@aRet)
			cXNPSITE := A690QRY( cNumvou )
			IF .NOT. Empty(cXNPSITE)
				FWMsgRun(, {|| A690Proc( cXNPSITE, aRet ) },cXtitulo,'Cancelando Pedido Site, favor aguardar...')
			EndIF
		Else
			MsgInfo("Operação cancelada, necessário informar o motivo.",cXtitulo)
			Return(.F.)
		EndIF
	Else
		MsgInfo("Operação cancelada.",cXtitulo)
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A690QRY | Autor | Rafael Beghini | Data | 19.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Executa a query para pegar as informações e prosseguir.
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A690QRY( cNUMVOU )
	Local cSQL := '' 
	Local cTRB := ''
	Local cRET := ''
	
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
		cRET := (cTRB)->ZG_PEDSITE + ';' + (cTRB)->ZG_NUMPED + ';'	 + (cTRB)->ZF_TIPOVOU
	(cTRB)->( dbSkip() )	
	End
	IF Empty(cRET)
		MsgInfo("Pedido site não localizado, operação cancelada.",cXtitulo)
		Return(.F.)	
	EndIF
	(cTRB)->( DbCloseArea() )	
Return( cRET )
//+-------------------------------------------------------------------+
//| Rotina | A690Proc | Autor | Rafael Beghini | Data | 19.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Processa o cancelamento do Pedido Site
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A690Proc( cXNPSITE, aRet )
	Local cPedLog  := ''
	Local cPEDSITE := ''
	Local cNUMPED  := ''
	Local cTIPO    := ''
	Local cMSG     := ''
	Local aDADOS   := StrToKarr( cXNPSITE, ';' )
	Local lRet     := .F.
	Local lFound   := .T.
	
	cPEDSITE := aDADOS[1]
	cNUMPED  := aDADOS[2]
	cTIPO    := aDADOS[3]
	
	IF cTIPO == 'F' //Gera Pedido
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
						 " (Atendente) em ["+DtoC(Date())+"-"+Time()+"] Motivo: " + rTrim(aRet[1]) + " ***"
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
	EndIF
	cMSG := "*** Pedido cancelado manualmente através da rotina [" + cFunName + "] por " + Upper(Alltrim(cUserName)) +; 
			 " (Atendente) em ["+DtoC(Date())+"-"+Time()+"] Motivo: " + rTrim(aRet[1]) + " ***"
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
	
	U_VNDA331( {'01','02',cXNPSITE + ';CANCELAMENTO VOUCHER;' + cMSG} )
	U_GTPutOUT(cPEDSITE,"X",cPedLog,{"VNDA690",{.F.,"M00002",cMSG}},cPEDSITE)
	
	MsgInfo("Solicitação de cancelamento realizada com Sucesso",cXtitulo)
Return