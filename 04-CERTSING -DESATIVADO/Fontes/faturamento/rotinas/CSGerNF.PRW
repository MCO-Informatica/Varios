#INCLUDE "PROTHEUS.CH"
#Include "topconn.ch"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
//+-------------------------------------------------------------------+
//| Rotina | CSGerNF | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para reenviar o link da Nota Fiscal
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSGerNF()
	Local aPergs   	:= {}
	Local aRet	   	:= {}
	Local aSAY  	:= {'Rotina para reenviar o link da Nota Fiscal','Pesquisa efetuada pelo número NOTA FISCAL','','Clique em OK para prosseguir...'}
    Local aBTN  	:= {}
    Local cNFPar  	:= Space(09)
	Local cOpc		:= ""
	Local nOpc  	:= 0

	Private cTitulo := '[CSGerNF] - Reenvio de nota fiscal'
	
	aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

	FormBatch('CSGerNF', aSAY, aBTN )

	IF nOpc == 1
		AAdd( aPergs ,{2,'Tipo NF'  ,1,{'1=Produto','2=Serviço'},115,'',.T.})
		aAdd( aPergs ,{1,"Número NF",cNFPar,"@!",'!Empty(mv_par02)',,'.T.',40,.T.})
			
		If ParamBox(aPergs,"Parâmetros...",@aRet)
			cOpc   := cValTochar( aRet[1] )
			cNFPar := aRet[2]
			FwMsgRun(, {|| GeraEspelho(cOpc,cNFPar) },cTitulo,'Aguarde, reenviando o link...')									
		Endif
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | GeraEspelho | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para reenviar o link da Nota Fiscal
//+-------------------------------------------------------------------+
Static Function GeraEspelho(cOpcPar, cCodNf)
	Local aRET			:= {}
	Local aEspelho 		:= {}
	Local aData			:= {}
	Local aArea 		:= {}
	Local cJsonNf		:= ''
	Local cCategory		:= "NOTIFICA-NF"
	Local cSvcError   	:= ''
	Local cSoapFCode 	:= ''
	Local cSoapFDescr 	:= ''
	Local cError	  	:= ''
	Local cWarning	  	:= ''
	Local cSQL		  	:= ''
	Local cTRB		  	:= ''
	Local lOk			:= .F.
	Local oWsObj
	Local oWsRes	

	cSQL += "SELECT SF2.R_E_C_N_O_ RECNO " + CRLF
	cSQL += "FROM   " + RetSqlName("SF2") + " SF2 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SD2") + " SD2 " + CRLF
	cSQL += "               ON D2_FILIAL = F2_FILIAL " + CRLF
	cSQL += "                  AND D2_DOC = F2_DOC " + CRLF
	cSQL += "                  AND D2_SERIE = F2_SERIE " + CRLF
	cSQL += "                  AND SD2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SC6") + " SC6 " + CRLF
	cSQL += "               ON C6_FILIAL = ' ' " + CRLF
	cSQL += "                  AND C6_NUM = D2_PEDIDO " + CRLF
	cSQL += "                  AND C6_NOTA = D2_DOC " + CRLF
	cSQL += "                  AND C6_SERIE = D2_SERIE " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SC5") + " SC5 " + CRLF
	cSQL += "               ON C5_FILIAL = C6_FILIAL " + CRLF
	cSQL += "                  AND C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SF2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND F2_FILIAL = '" + xFilial('SF2') + "' " + CRLF
	If cOpcPar == "1"
		cSQL += "       AND F2_SERIE = ANY('2  ','3  ')" + CRLF
	ElseIf cOpcPar == "2"
		cSQL += "       AND F2_SERIE = 'RP2'" + CRLF
	Endif
	cSQL += "       AND F2_DOC = '" + cCodNf + "' " + CRLF
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	IF .NOT. (cTRB)->( EOF() )
		oWsObj := WSVVHubServiceService():New()
		(cTRB)->( dbGotop() )
    	While .NOT. (cTRB)->( EOF() )
			aRet := {}
			Aadd( aRet, .T. )
			Aadd( aRet, '000135' )

			SF2->( DbGoto( (cTRB)->RECNO ) )
						
			SC6->( DbSetOrder(4) )	//C6_FILIAL+C6_NOTA+C6_SERIE
			SC6->( MsSeek( xFilial("SC6") + SF2->(F2_DOC + F2_SERIE) ) )
						
			SC5->( DbSetOrder(1) )	//C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5") + SC6->C6_NUM ) )
			
			aArea := { SF2->( GetArea() ), SC5->( GetArea() ), SC6->( GetArea() ) }
			
			If cOpcPar == "1"
				aEspelho := U_GARR010(aRet)	//NOTA DE PRODUTO
			ElseIf cOpcPar == "2"
				aEspelho := U_GARR020(aRet,.T.) //NOTA DE SERVIÇO
			EndIf
			
			AEval( aArea, {|xArea| RestArea( xArea ) } )
			
			Conout( '[CSGerNFS] - Nota Fiscal ' + SF2->F2_DOC )

			IF aEspelho[1]
				If cOpcPar == "1" .and. !Empty(SC5->C5_XNFHRD)
					
					If Empty( SC6->C6_XIDPED )
						cJsonNf := '{"pedido":'+SC5->C5_XNPSITE+',"tipo":"PRODUTO","serie":"'+SF2->F2_SERIE+'","numeroNF":"'+SF2->F2_DOC+'","dataGeracao":"'+Left(dToS(SC6->C6_DATFAT),4)+'-'+SubStr(dToS(SC6->C6_DATFAT),5,2)+'-'+Right(dToS(SC6->C6_DATFAT),2)+'T00:00:00.000Z","link":"'+Alltrim(SC5->C5_XNFHRD)+'"}'
					Else
						cJsonNf := '{"pedido":'+SC5->C5_XNPSITE+',"pedidoItem":'+SC6->C6_XIDPED+',"tipo":"PRODUTO","serie":"'+SF2->F2_SERIE+'","numeroNF":"'+SF2->F2_DOC+'","dataGeracao":"'+Left(dToS(SC6->C6_DATFAT),4)+'-'+SubStr(dToS(SC6->C6_DATFAT),5,2)+'-'+Right(dToS(SC6->C6_DATFAT),2)+'T00:00:00.000Z","link":"'+Alltrim(SC6->C6_XNFHRD)+'"}'
					EndIF
			
				Endif
				
				If cOpcPar == "2" .and. !Empty(SC5->C5_XNFSFW)
					
					If Empty( SC6->C6_XIDPED )
						cJsonNf := '{"pedido":'+SC5->C5_XNPSITE+',"tipo":"SERVICO","serie":"'+SF2->F2_SERIE+'","numeroNF":"'+SF2->F2_DOC+'","dataGeracao":"'+Left(dToS(SC6->C6_DATFAT),4)+'-'+SubStr(dToS(SC6->C6_DATFAT),5,2)+'-'+Right(dToS(SC6->C6_DATFAT),2)+'T00:00:00.000Z","link":"'+Alltrim(SC5->C5_XNFSFW)+'"}'
					Else
						cJsonNf := '{"pedido":'+SC5->C5_XNPSITE+',"pedidoItem":'+SC6->C6_XIDPED+',"tipo":"SERVICO","serie":"'+SF2->F2_SERIE+'","numeroNF":"'+SF2->F2_DOC+'","dataGeracao":"'+Left(dToS(SC6->C6_DATFAT),4)+'-'+SubStr(dToS(SC6->C6_DATFAT),5,2)+'-'+Right(dToS(SC6->C6_DATFAT),2)+'T00:00:00.000Z","link":"'+Alltrim(SC6->C6_XNFSFW)+'"}'
					EndIF
			
				Endif
						
				lOk := oWsObj:sendMessage(cCategory,cJsonNf)
					
				cSvcError   := GetWSCError()  // Resumo do erro
				cSoapFCode  := GetWSCError(2)  // Soap Fault Code
				cSoapFDescr := GetWSCError(3)  // Soap Fault Description
					
				If !empty(cSoapFCode)
					(cTRB)->( dbSkip() )
					Loop
				ElseIf !Empty(cSvcError)
					(cTRB)->( dbSkip() )
					Loop
				Endif
					
				If lOk
					oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
					If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
						If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
							DbSelectArea("SC5")
							SC5->(DbSetOrder(1))	//C5_FILIAL + C5_NUM
							If SC5->(DbSeek(xFilial("SC5") + SC5->C5_NUM ))						
								RecLock("SC5", .F.)
								IF cOpcPar == "1" //Produto
									Replace SC5->C5_XFLAGHW With "X"
								ElseIF cOpcPar == "2" //Software
									Replace SC5->C5_XFLAGSF With "X" 
								EndIF
								MsUnLock()
							EndIf	
							
							SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
							lSeekC6 := SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
							
							If lSeekC6 
								While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NOTA+C6_SERIE) == xFilial("SC6")+SF2->(F2_DOC+F2_SERIE)
									RecLock("SC6", .F.)
										IF cOpcPar == "1" //Produto
											Replace SC6->C6_XFLAGHW With "X"
										ElseIF cOpcPar == "2" //Software
											Replace SC6->C6_XFLAGSF With "X" 
										EndIF
									SC6->(MsUnLock())
									
									SC6->(DbSkip())
								End
							EndIf
							HS_MsgInf( "Link da NF " + cCodNf + " enviado com sucesso." + CRLF + "Consulte os dados no CheckOut" + CRLF + CRLF +;
										Alltrim( cValToChar( aEspelho[4] ) ), "Atenção","[CSGerNF] Reenvio Link Nota Fiscal")
						EndIf					
					EndIf
				EndIf
			Else
				HS_MsgInf("Não foi possível a geração do Link." + CRLF + "Não será enviado para o CheckOut" + CRLF + CRLF +;
					Alltrim( cValToChar( aEspelho[2] ) ) + CRLF+;
					Alltrim( cValToChar( aEspelho[3] ) ) + CRLF+;
					Alltrim( cValToChar( aEspelho[4] ) ) , "Atenção","[CSGerNF] Reenvio Link Nota Fiscal")
			EndIF
			
			aEspelho := {}
			
			(cTRB)->( dbSkip() )
    	End

		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
	Else
		HS_MsgInf("Nota fiscal não localizada, verifique os parâmetros","Atenção","[CSGerNF] Reenvio Link Nota Fiscal")
	EndIF
Return		
