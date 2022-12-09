#Include "Protheus.ch"
#include "Totvs.ch"
#Include "Ap5Mail.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"

//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | Jira     |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| 30/07/2020 | Bruno Nunes   |                                                                                  | 1.00   | PROT-134 |
//|            |               |                                                                                  |	       |          |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+

#DEFINE cFUNCAO_FATURAMENTO "u_CerFatPr"
#DEFINE cSX6_LOG        "LG_CERFATALL"
#DEFINE lWAIT           .F. //Indica se, verdadeiro (.T.), o processo ser· finalizado; caso contr·rio, falso (.F.).
#DEFINE cSITUACAO_1_1   "1.1"   //01
#DEFINE cSITUACAO_1_2   "1.2"	//02
#DEFINE cSITUACAO_2_1_1 "2.1.1" //03
#DEFINE cSITUACAO_2_1_2 "2.1.2"	//04
#DEFINE cSITUACAO_2_2_1 "2.2.1" //05
#DEFINE cSITUACAO_2_2_2 "2.2.2" //06
#DEFINE cSITUACAO_3_1_0 "3.1"   //07
#DEFINE cSITUACAO_3_2_0 "3.2"   //08
#DEFINE cSITUACAO_4_1_1 "4.1.1" //09
#DEFINE cSITUACAO_4_1_2 "4.1.2" //10
#DEFINE cSITUACAO_4_2_1 "4.2.1" //11
#DEFINE cSITUACAO_4_2_2 "4.2.2" //12
#DEFINE cSITUACAO_4_3_1 "4.3.1" //13
#DEFINE cSITUACAO_4_4_1 "4.4.1" //14
#DEFINE cSITUACAO_4_4_2 "4.4.2" //15
#DEFINE cSITUACAO_4_5_1 "4.5.1" //16
#DEFINE cSITUACAO_4_5_2 "4.5.2" //17
#DEFINE cSITUACAO_4_6_1 "4.6.1" //18
#DEFINE cSITUACAO_4_6_2 "4.6.2" //19
#DEFINE cSITUACAO_5_1_1 "5.1.1" //20
#DEFINE cSITUACAO_5_1_2 "5.1.2" //21
#DEFINE cSITUACAO_5_2_1 "5.2.1" //22
#DEFINE cSITUACAO_5_2_2 "5.2.2" //23
#DEFINE cSITUACAO_6_1_1 "6.1.1" //24
#DEFINE cSITUACAO_6_1_2 "6.1.2" //25
#DEFINE cSITUACAO_7_1_1 "7.1.1" //26
#DEFINE cSITUACAO_7_1_2 "7.1.2" //27
#DEFINE cSITUACAO_7_2_1 "7.2.1" //28
#DEFINE cSITUACAO_7_2_2 "7.2.2" //29
#DEFINE cSITUACAO_8_1_1 "8.1.1" //30

/*/{Protheus.doc} CerFatAL
Fatura pendencias de pedidos emitidos ou validados
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
User Function CerFatAL( aParam )
	Local lJob 		 := ( Select( "SX6" ) == 0 )
	Local cJobEmp	 := iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	 := iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local cMV_CERFAT := 'MV_CERFAT'
	LOcal dDataRef	 := CTOD('//')
	Local cEnvSrv    := GetEnvServer()
	Local aSQL       := {}
	Local i          := 0
	local oLog 		 := nil
	
	fatConout( "Processo iniciado" )
	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	If !GetMv( cMV_CERFAT, .T. )
		CriarSX6( cMV_CERFAT, 'N', 'Numero de dias para retroceder na query - ROTINAS CerFatPE.prw', '30' )
	Endif

	oLog := CSLog():New( cSX6_LOG )
	oLog:SetAssunto( "[ CERFATAL ] - DistribuiÁ„o de JOBS" )

	//Data de referencia usado nas query
	dDataRef := dDatabase - GetMv( cMV_CERFAT, .F. )
	
	aAdd( aSQL, { getQSit110( dDataRef ), cSITUACAO_1_1   } ) //01 - CerFat( cSQL, '1.1'   )
	aAdd( aSQL, { getQSit120( dDataRef ), cSITUACAO_1_2   } ) //02 - CerFat( cSQL, '1.2'   )
	aAdd( aSQL, { getQSit211( dDataRef ), cSITUACAO_2_1_1 } ) //03 - CerFat( cSQL, '2.1.1' )
	aAdd( aSQL, { getQSit212( dDataRef ), cSITUACAO_2_1_2 } ) //04 - CerFat( cSQL, '2.1.2' )
	aAdd( aSQL, { getQSit221( dDataRef ), cSITUACAO_2_2_1 } ) //05 - CerFat( cSQL, '2.2.1' )
	aAdd( aSQL, { getQSit222( dDataRef ), cSITUACAO_2_2_2 } ) //06 - CerFat( cSQL, '2.2.2' )
	aAdd( aSQL, { getQSit310( dDataRef ), cSITUACAO_3_1_0 } ) //07 - CerFat( cSQL, '3.1'   )
	aAdd( aSQL, { getQSit320( dDataRef ), cSITUACAO_3_2_0 } ) //08 - CerFat( cSQL, '3.2'   )
	aAdd( aSQL, { getQSit411( dDataRef ), cSITUACAO_4_1_1 } ) //09 - CerFat( cSQL, '4.1.1' )
	aAdd( aSQL, { getQSit412( dDataRef ), cSITUACAO_4_1_2 } ) //10 - CerFat( cSQL, '4.1.2' )
	aAdd( aSQL, { getQSit421( dDataRef ), cSITUACAO_4_2_1 } ) //11 - CerFat( cSQL, '4.2.1' )
	aAdd( aSQL, { getQSit422( dDataRef ), cSITUACAO_4_2_2 } ) //12 - CerFat( cSQL, '4.2.2' )
	aAdd( aSQL, { getQSit431( dDataRef ), cSITUACAO_4_3_1 } ) //13 - CerFat( cSQL, '4.3.1' )
	aAdd( aSQL, { getQSit441( dDataRef ), cSITUACAO_4_4_1 } ) //14 - CerFat( cSQL, '4.4.1' )
	aAdd( aSQL, { getQSit442( dDataRef ), cSITUACAO_4_4_2 } ) //15 - CerFat( cSQL, '4.4.2' )
	aAdd( aSQL, { getQSit451( dDataRef ), cSITUACAO_4_5_1 } ) //16 - CerFat( cSQL, '4.5.1' )
	aAdd( aSQL, { getQSit452( dDataRef ), cSITUACAO_4_5_2 } ) //17 - CerFat( cSQL, '4.5.2' )
	aAdd( aSQL, { getQSit461( dDataRef ), cSITUACAO_4_6_1 } ) //18 - CerFat( cSQL, '4.6.1' )
	aAdd( aSQL, { getQSit462( dDataRef ), cSITUACAO_4_6_2 } ) //19 - CerFat( cSQL, '4.6.2' )
	aAdd( aSQL, { getQSit511( dDataRef ), cSITUACAO_5_1_1 } ) //20 - CerFat( cSQL, '5.1.1' )
	aAdd( aSQL, { getQSit512( dDataRef ), cSITUACAO_5_1_2 } ) //21 - CerFat( cSQL, '5.1.2' )
	aAdd( aSQL, { getQSit521( dDataRef ), cSITUACAO_5_2_1 } ) //22 - CerFat( cSQL, '5.2.1' )
	aAdd( aSQL, { getQSit522( dDataRef ), cSITUACAO_5_2_2 } ) //23 - CerFat( cSQL, '5.2.2' )
	aAdd( aSQL, { getQSit611( dDataRef ), cSITUACAO_6_1_1 } ) //24 - CerFat( cSQL, '6.1.1' )
	aAdd( aSQL, { getQSit612( dDataRef ), cSITUACAO_6_1_2 } ) //25 - CerFat( cSQL, '6.1.2' )
	aAdd( aSQL, { getQSit711( dDataRef ), cSITUACAO_7_1_1 } ) //26 - CerFat( cSQL, '7.1.1' )
	aAdd( aSQL, { getQSit712( dDataRef ), cSITUACAO_7_1_2 } ) //27 - CerFat( cSQL, '7.1.2' )
	aAdd( aSQL, { getQSit721( dDataRef ), cSITUACAO_7_2_1 } ) //28 - CerFat( cSQL, '7.2.1' )
	aAdd( aSQL, { getQSit722( dDataRef ), cSITUACAO_7_2_2 } ) //29 - CerFat( cSQL, '7.2.2' )
	aAdd( aSQL, { getQSit811( dDataRef ), cSITUACAO_8_1_1 } ) //30 - CerFat( cSQL, '8.1.1' )
	
	for i := 1 to len( aSQL )
		StartJob( cFUNCAO_FATURAMENTO, cEnvSrv, lWAIT, aSQL[ i ][ 1 ], aSQL[ i ][ 2 ], aParam ) //StartJob( < cName >, < cEnv >, < lWait >, [ parm1,parm2,...parm25 ] )
		oLog:AddLog( "JOB iniciado da situaÁ„o: " + aSQL[ i ][ 2 ] )
	next i 
	
	oLog:EnviarLog()
	
	If lJob
		RESET ENVIRONMENT
	EndIf
	fatConout( "Processo finalizado" )
Return

/*/{Protheus.doc} CerFatPr
Processa condiÁıes de faturamento
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
User Function CerFatPr( cSQL, cSituac, aParam )
	Local nTotThread := 0
	Local bOldBlock	 := nil
	Local cErrorMsg	 := ""
	Local lLiBBloq	 := .F.
	Local cTRB		 := GetNextAlias()
	Local cPedido    := ""
	Local cPedGarIt	 := ""
	local oLog 		 := nil
	local oLogEsp	 := nil
	local cPedSite   := ""
	local aLogPedSit := {}
	local lJob 		 := ( Select( "SX6" ) == 0 )
	local cJobEmp	 := iif( aParam == NIL, '01', aParam[ 1 ] )
	local cJobFil	 := iif( aParam == NIL, '02', aParam[ 2 ] )	

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf
	
	oLog := CSLog():New()
	oLog:AddLog( "Processo iniciado da situaÁ„o: " + cSituac )
	oLog:SetAssunto( "[ CERFATPR ] - Processamento da situaÁ„o: " + cSituac )
	fatConout( "Processo iniciado da situaÁ„o: " + cSituac )
	
	//TRATAMENTO PARA ERRO FATAL NA THREAD
	cErrorMsg := ""
	bOldBlock := ErrorBlock({|e| U_ProcError(e) })

	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	
	While (cTRB)->( !Eof() )
		cPedido     := ''
		cPedGarIt   := ''
		lFat        := .F.  
		lServ       := .F.
		lProd       := .F.
		lEnt        := .F.
		cOperVenH   := nil
		cOperEntH   := nil
		cOperVenS   := nil
		lRecPgto    := .F.
		lGerTitRecb := .F.
		cTipTitRecb := ''     
		cSituacao   := SUBSTR( (cTRB)->SITUACAO, 1, 1 )
		cProcSit    := (cTRB)->SITUACAO
		lLiBBloq	:= .F.

		IF (cTRB)->OPERACAO =='61' .AND. (cTRB)->DATEMIS > ' '		
			lFat        := .T.
			lServ       := .T.
			cOperVenS   := (cTRB)->OPERACAO
			cPedido		:= (cTRB)->PEDIDO
			cPedGarIt	:= (cTRB)->PEDORI   // SEMPRE VIR¡ DA SC6
		ElseIf (cTRB)->OPERACAO =='62' .AND. ( ((cTRB)->DATVER > ' ' .or. (cTRB)->DATEMIS > ' ') .Or. (cTRB)->ENTREGAHW == "TRUE") //Pode acontecer da mensagem verificaÁ„o n„o chegar				
			lFat        := .T.
			lProd       := .T.
			cOperVenH	:= (cTRB)->OPERACAO
			cPedido		:= (cTRB)->PEDIDO
			cPedGarIt	:= (cTRB)->PEDORI
		ElseIf (cTRB)->OPERACAO =='53' .AND. ( ((cTRB)->DATVER > ' ' .Or. (cTRB)->DATEMIS > ' ') .Or. (cTRB)->ENTREGAHW == "TRUE") 	
			lFat        := .F.
			lEnt	    := .T.
			cOperEntH   := (cTRB)->OPERACAO
			cPedido		:= (cTRB)->PEDIDO
			cPedGarIt	:= (cTRB)->PEDORI
		ElseIf (cTRB)->OPERACAO == '51'
			lFat        := .T.
			lServ       := .T.
			cOperVenS   := (cTRB)->OPERACAO
			cPedido		:= (cTRB)->PEDIDO
			cPedGarIt	:= (cTRB)->PEDORI
		ElseIf (cTRB)->OPERACAO == '52' 
			lFat        := .T.
			lProd       := .T.
			cOperVenH	:= (cTRB)->OPERACAO
			cPedido		:= (cTRB)->PEDIDO
			cPedGarIt	:= (cTRB)->PEDORI
		Else
			cMsg := "Nao localizada operaÁ„o de varejo para este pedido " + (cTRB)->PEDIDO + ' Situacao '+ cProcSit
			oLog:AddLog( cMsg ) 
		Endif
		
		cPedSite := (cTRB)->PEDSITE
		
		if cPedido == "9GPXN0"
			oLogEsp := CSLog():New()
			
			oLogEsp:SetAssunto( "[ CERFATPR ] - Teste de pedido bloqueado: " + cSituac  )
			oLogEsp:AddLog( "Tentativa de faturar o pedido bloqueado" )
			oLogEsp:AddLog( "C6_BLQ = "+ (ctrb)->BLQ )
			oLogEsp:SetEmail("luciano.oliveira@certisign.com.br; bruno.nunes@certisign.com.br")
			oLogEsp:EnviarLog()
		endif
		
		oLog:AddLog( { "SituaÁ„o: " + cSituac, "Pedido Site: " + cPedSite, "Pedido Protheus: " + cPedido, "Pedido GAR: " + cPedGarIt } )
		
		If !Empty( cPedido )
			
			aParamFun :=  {cPedido,;
			Val((cTRB)->PEDSITE),;
			lFat,;
			nil,;
			lServ,;
			lProd,;
			nil,;
			cOperVenH,;
			cOperEntH,;
			cOperVenS,;
			nil,;
			nil,;
			lRecPgto,;
			lGerTitRecb,;
			cTipTitRecb,;
			lEnt,;
			nil,;
			nil,;
			cPedGarIt}

			cErrorMsg := ""
			bOldBlock := ErrorBlock({|e| U_ProcError(e) })
			
			BEGIN SEQUENCE      
				//Faz distribuiÁ„o e monitora a quantidade de thread em execuÁ„o
				nThread := 0
				aUsers 	:= Getuserinfoarray()
				aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA191".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatAL" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })			
			END SEQUENCE

			ErrorBlock(bOldBlock)

			cErrorMsg := U_GetProcError()
			If !empty(cErrorMsg)
				fatConout( "Inconsistencia no Faturamento: " + CRLF + cErrorMsg )
				oLog:AddLog( "Inconsistencia no Faturamento: " + cErrorMsg )
			EndIf
			
			If nThread <= 20
				If SC5->( DBSeek( xFilial("SC5") + cPedido ) )   
					If ! cSituacao == '1' 
						IF cSituacao=='5' .or. cSituacao=='6' .or. cSituacao=='7' 
							//Retira o bloqueio                 
							DbSelectArea("SC6")
							DbSetOrder(1)
							If DbSeek(xFilial("SC6")+cPedido)
								// SE EXISTE BLOQUEIO E N√O … CHARGE BACK
								IF SUBSTR(SC5->C5_NOTA,1,6)=="XXXXXX" //Alterado para cl·usulas INNER JOIN da consulta SQL para os casos 5, 6 e 7. AND. !(ALLTRIM(SC5->C5_ARQVTEX)=='CHARGEBACK' .OR. ALLTRIM(SC5->C5_ARQVTEX)=='REEMBOLSO' .OR. ALLTRIM(SC5->C5_ARQVTEX)=='AUDITORIA' )

									RecLock("SC5",.F.)
									SC5->C5_NOTA := " "
									SC5->(MsUnlock())     
									oLog:AddLog( "SC5 - Retirou o bloqueio de residuo na nota: " + SC5->C5_NOTA )
									
									While cPedido == SC6->C6_NUM
										If Empty(SC6->C6_NOTA)
											RecLock("SC6",.F.)
											SC6->C6_BLQ := " "
											SC6->(MsUnlock())
											lLiBBloq := .T.
											oLog:AddLog( "SC6 - Retirou o bloqueio de residuo na nota: " + SC6->C6_NOTA )
											
											if cPedido == "9GPXN0"
												oLogEsp := CSLog():New()
												
												oLogEsp:SetAssunto( "[ CERFATPR ] - Teste de pedido bloqueado: " + cSituac  )
												oLogEsp:AddLog( "Deixou o bloqueio em branco campo" )
												oLogEsp:AddLog( "C6_BLQ = "+ (ctrb)->BLQ )
												oLogEsp:SetEmail("luciano.oliveira@certisign.com.br; bruno.nunes@certisign.com.br")
												oLogEsp:EnviarLog()
											endif											
											
										EndIf
										DbSelectArea("SC6")
										DbSkip()
									EndDo
								ENDIF
							EndIf
							//Fim da alteraÁ„o para bloqueio
						Endif

						IF (ctrb)->BLQ = ' ' .OR. lLiBBloq
							//Fatura pendencias 
							nTotThread += 1
							nRecPed := SC5->(recno())
							oLog:AddLog( "U_VNDA191 - Faturando pedido site: " + cPedSite )
							StartJob( "U_VNDA191", GetEnvServer(), .F., cJobEmp, cJobFil, aParamFun, nRecPed )  //Apenas nota de entrega
							//U_VNDA191('01', '02', aParamFun,nRecPed)
							aAdd( aLogPedSit, cPedSite )
						EndIF
					Else
						IF cSituacao=='1'
							//Add Residuo                
							DbSelectArea("SC6")
							DbSetOrder(1)
							If DbSeek(xFilial("SC6")+cPedido)						
								IF EMPTY(SC5->C5_NOTA) 
									RecLock("SC5",.F.)
									SC5->C5_NOTA := "XXXXXX   "
									IF EMPTY(SC5->C5_ARQVTEX)
										SC5->C5_ARQVTEX:='CERFAT - SIT -'+ cProcSit 
									EndIf
									SC5->(MsUnlock())    
									oLog:AddLog( "SC5 - Adiciona residuo: " + SC5->C5_NOTA + ", CERFAT - SIT - " + cProcSit  ) 
								EndIf

								While cPedido == SC6->C6_NUM
									If Empty(SC6->C6_NOTA)
										RecLock("SC6",.F.)
										SC6->C6_BLQ := "R"
										SC6->(MsUnlock())
										oLog:AddLog( "SC6 - Adiciona residuo: " + SC6->C6_NOTA  )
									EndIf
									DbSelectArea("SC6")
									DbSkip()
								EndDo
							EndIf
						Endif
					EndIf
				EndIF
				(cTRB)->( dbSkip() )				
			Else
				While nThread > 20
					oLog:AddLog( "Quantidade de threads consumidas no processo: " + cValToChar( nThread )  )
					
					sleep(20000)
					cErrorMsg := ""
					bOldBlock := ErrorBlock({|e| U_ProcError(e) })
			
					BEGIN SEQUENCE      
						nThread := 0
						aUsers 	:= Getuserinfoarray()
						aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA191".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatAL" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
					END SEQUENCE

					ErrorBlock(bOldBlock)

					cErrorMsg := U_GetProcError()
					If !empty(cErrorMsg)
						fatConout( "Inconsistencia no Faturamento: " + CRLF + cErrorMsg )
						oLog:AddLog( "Inconsistencia no Faturamento: " + cErrorMsg )
					EndIf
					
					oLog:AddLog( "Quantidade de threads abertas apÛs liberaÁ„o : " + cValToChar( nThread )  )
				EndDo	
			EndIf
		
			If nTotThread > 20                           
				fatConout( "Processou " + cValToChar( nTotThread ) + " threads - Libera memoria - SituaÁ„o: " + cSituac )
				oLog:AddLog( "Processou " + cValToChar( nTotThread ) + " threads - Libera memoria - SituaÁ„o: " + cSituac )
				DelClassIntf()
				nTotThread := 0
			EndIf
		ELSE
			(cTRB)->( dbSkip() )
		EndIf	
	End
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

	oLog:AddLog( "Quantidade de pedidos que iniciaram o JOB de faturamento: " + cValToChar( len( aLogPedSit ) ) )

	fatConout(   "Finalizado processamento da situaÁ„o: " + cSituac )
	oLog:AddLog( "Finalizado processamento da situaÁ„o: " + cSituac )
	oLog:EnviarLog()

	If lJob
		RESET ENVIRONMENT
	EndIf	
Return  

/*/{Protheus.doc} CerFatPE
Processar faturamento de pedidos sem link de hardware, software ou nao faturados.
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
User Function CerFatPE()
	Local cSql 			:= ""
	Local nDias			:= 0
	Local nTotThread	:= 0
	Local cCodFil		:= ""             

	// Abre empresa para Faturamento retirar coment√°rio para processamento em JOB
	RpcSetType(3)
	RpcSetEnv('01','02')

	nDias := GetMV( "MV_XDIAPRC",, 3 )

	cSql := "SELECT PEDIDO, PEDSITE, XOPERSERVICO, XOPERPRODUTO " 
	cSql += "FROM ( "
	cSql += "      SELECT * "
	cSql += "      FROM ( "  
		
	cSql += "            SELECT C5_NUM PEDIDO, C5_EMISSAO, C5_XNPSITE PEDSITE, C5_CHVBPAG, C5_TIPMOV, C6_XOPER AS XOPERSERVICO, ' ' AS XOPERPRODUTO, "
	cSql += "					C5_XLINDIG, C5_XBANDEI, C5_XNUMCAR, C5_XCODAUT, C5_XARQCC,C5_XNFHRD,C5_XNFSFW,C5_XNFHRE "
	cSql += "            FROM SC5010, SC6010 "
	cSql += "            WHERE C5_FILIAL = '"+xFilial("SC5")+"' "
	cSql += "            AND C5_XNPSITE > ' ' "
	cSql += "            AND SC5010.D_E_L_E_T_=' '  "
	cSql += "            AND C5_EMISSAO >= '" + DtoS( Date() - nDias ) + "' "
	//cSql += "            AND C5_XNFSFW = '                                                                                ' "
	cSql += "            AND C6_FILIAL = C5_FILIAL "
	cSql += "            AND C6_NUM = C5_NUM AND C6_XOPER = '51' AND C6_BLQ=' ' AND C6_NOTA=' ' "
	cSql += "            AND ( ( C5_XORIGPV <> '8' ) OR ( C5_XORIGPV = '8' AND C5_XLIBFAT='S' ) ) "
	cSql += "            ) BD1 "
				
	cSql += "            INNER JOIN ( "
	cSql += "                      SELECT ZQ_PEDIDO, MAX(ZQ_ID||' '||ZQ_NF1||' '||ZQ_NF2||' '||ZQ_STATUS||' '||ZQ_OCORREN||' '||ZQ_DATA) AS ZQ_STATUS "
	cSql += "                      FROM SZQ010  "
	cSql += "                      WHERE SZQ010.ZQ_FILIAL = ' ' AND "
	cSql += "                      SZQ010.D_E_L_E_T_ = ' ' "
	cSql += "                      GROUP BY  ZQ_PEDIDO, ZQ_ID||' '||ZQ_NF1||' '||ZQ_NF2||' '||ZQ_STATUS||' '||ZQ_OCORREN||' '||ZQ_DATA "
	cSql += "                      ) BD2 ON BD1.PEDSITE = BD2.ZQ_PEDIDO  "
		
	cSql += "      UNION "
		
	cSql += "      SELECT * "
	cSql += "      FROM (   "
		
	cSql += "            SELECT C5_NUM, C5_EMISSAO, C5_XNPSITE PEDSITE, C5_CHVBPAG, C5_TIPMOV, ' '  AS XOPERSERVICO, C6_XOPER AS XOPERPRODUTO, "
	cSql += "					C5_XLINDIG, C5_XBANDEI, C5_XNUMCAR, C5_XCODAUT, C5_XARQCC,C5_XNFHRD,C5_XNFSFW,C5_XNFHRE "
	cSql += "            FROM SC5010, SC6010 "
	cSql += "            WHERE C5_FILIAL = '"+xFilial("SC5")+"' "
	cSql += "            AND C5_XNPSITE >' ' "
	cSql += "            AND SC5010.D_E_L_E_T_=' ' "
	cSql += "            AND C5_EMISSAO >= '" + DtoS( Date() - nDias ) + "' "
//	cSql += "            AND C5_XNFHRD = '                                                                                ' "
	cSql += "            AND C6_FILIAL = C5_FILIAL "
	cSql += "            AND C6_NUM = C5_NUM "
	cSql += "            AND C6_XOPER = '52' AND C6_BLQ=' ' AND C6_NOTA=' ' "
	cSql += "            ) BD1 "
	cSql += "            INNSER JOIN ( "
	cSql += "                      SELECT ZQ_PEDIDO, MAX(ZQ_ID||' '||ZQ_NF1||' '||ZQ_NF2||' '||ZQ_STATUS||' '||ZQ_OCORREN||' '||ZQ_DATA) AS ZQ_STATUS "
	cSql += "                      FROM SZQ010  "
	cSql += "                      WHERE SZQ010.ZQ_FILIAL=' ' AND"
	cSql += "                      SZQ010.D_E_L_E_T_=' ' "
	cSql += "                      GROUP BY  ZQ_PEDIDO, ZQ_ID||' '||ZQ_NF1||' '||ZQ_NF2||' '||ZQ_STATUS||' '||ZQ_OCORREN||' '||ZQ_DATA "
	cSql += "                      ) BD2 ON BD1.PEDSITE=BD2.ZQ_PEDIDO  "

	cSql += "     ) GROUP BY PEDIDO, PEDSITE, XOPERSERVICO, XOPERPRODUTO "

	cSql := ChangeQuery( cSql )                                         

	cTrb:= GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)


	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))    

	While (ctrb)->( !Eof() )
		
		lFat        :=.T.
		lServ       :=IIF(EMPTY((ctrb)->XOPERSERVICO),.F.,.T.)  
		lProd       :=IIF(EMPTY((ctrb)->XOPERPRODUTO),.F.,.T.)  
		lEnt        :=.F.
		cOperVen    :=(ctrb)->XOPERPRODUTO
		cOperEntH   :=nil
		cOperVenS   :=(ctrb)->XOPERSERVICO
		lRecPgto    :=.F.
		lGerTitRecb :=.F.
		cTipTitRecb :=''
		cPedido     :=(ctrb)->PEDIDO

		//Faz distribuiÁ„o e monitora a quantidade de thread em execuÁ„o
		nThread := 0
		aUsers 	:= Getuserinfoarray()
		aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatPE" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
		
		If nThread <= 10

			If SC5->(MsSeek(xFilial("SC5")+cPedido))                      
				nTotThread += 1
				nRecPed:=sc5->(recno())
				
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
				
				If AllTrim(SA1->A1_EST)=="RJ" .And. lProd
					cCodFil := "01"
				Else
					cCodFil := "02"
				Endif

				StartJob("U_VNDA190P",GetEnvServer(),.F.,'01',cCodFil,nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb)  //Apenas nota de entrega
				//U_VNDA190P('01',cCodFil,nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb	)  //Para debugar utilizar este
			EndIf
			
			(ctrb)->( DbSkip() )  
			
		Else
			
			While nThread > 10
				SLEEP(60000)      
				nThread := 0
				aUsers 	:= Getuserinfoarray()
				aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatPE" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
			EndDo

					
		EndIf

		If nTotThread > 10                           
			fatConout( "Processou " + cValToChar( nTotThread ) + " threads - Libera memoria" )
			DelClassIntf()
			nTotThread := 0
		EndIf
		

	End   
	(ctrb)->( DbCloseArea() )
	MsgAlert("Processo Finalizado")

Return                                                

/*/{Protheus.doc} CerFatCa
Processar faturamento de pedidos sem link de hardware, software ou nao faturados.
@author Gustavo / Giovanni
@since 08/05/2013
/*/ 
User Function CerFatCa( aParam )
	Local lJob 		 := ( Select( "SX6" ) == 0 )
	Local cJobEmp	 := iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	 := iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local cSql 		 := ""                  
	Local nDias		 := 0
	Local nTotThread := 0
	local oLog 		 := nil
	local cPedSite   := ""
	local aLogPedSit := {}

	// Abre empresa para Faturamento retirar coment√°rio para processamento em JOB	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	oLog := CSLog():New( cSX6_LOG )
	oLog:SetAssunto( "[ CERFATCA ] - Processar faturamento de pedidos sem link de hardware, software ou nao faturados." )                                                         

	nDias := GetMV( "MV_XDIAPRC",, 3 )

	cSql := "SELECT "
	cSql += "	C5_NUM     AS PEDIDO, " 
	cSql += "	C5_XNPSITE AS PEDSITE "
	cSql += "FROM ( "
	cSql += "			SELECT   C5_EMISSAO, " 
	cSql += "					 C6_PRODUTO,  "
	cSql += "					 C6_XOPER, "
	cSql += "					 C6_NOTA,  "
	cSql += "					 C6_SERIE,  "
	cSql += "					 C6_DATFAT, "
	cSql += "					 C5_NUM,  "
	cSql += "					 C5_XNPSITE, " 
	cSql += "					 C5_CHVBPAG, "
	cSql += "					 C5_XCARTAO, "
	cSql += "					 C5_XCODAUT, "
	cSql += "					 C5_XARQCC,  "
	cSql += "					 C5_XDOCUME,  "
	cSql += "					 C5_XNFHRD, "
	cSql += "					 C5_XNFSFW,  "
	cSql += "					 C5_XNFHRE,  "
	cSql += "					 SC5.C5_XLINDIG "
	cSql += "			FROM    "
	cSql += "					 " + RetSqlName("SC5") + " SC5, "
	cSql += "					 " + RetSqlName("SC6") + " SC6  "
	cSql += "			WHERE "
	cSql += "					 SC5.C5_FILIAL  = '" + xFilial("SC5") + "' AND "
	cSql += "					 SC5.C5_EMISSAO BETWEEN '" + DtoS( Date() - nDias ) + "' AND  TO_CHAR((SYSDATE -1),'YYYYMMDD' ) AND " 
	cSql += "					 SC5.D_E_L_E_T_ = ' ' AND "
	cSql += "					 SC5.C5_TIPMOV  = '2' AND "
	cSql += "					 SC5.C5_XARQCC  = ' ' AND "
	cSql += "					 SC5.C5_XCODAUT > ' ' AND "
	cSql += "					 SC6.C6_FILIAL  = SC5.C5_FILIAL AND "
	cSql += "					 SC6.C6_NUM     = SC5.C5_NUM AND "
	cSql += "					 SC6.D_E_L_E_T_ = ' ' AND "
	cSql += "					 SC6.C6_NOTA    = ' ' AND  "
	cSql += "					 SC6.C6_BLQ     = ' ' AND  "
	cSql += "					 SC6.C6_XOPER   = '51' AND " 
	cSql += "					 ( ( SC5.C5_XORIGPV <> '8' ) OR ( SC5.C5_XORIGPV = '8' AND SC5.C5_XLIBFAT='S' ) ) "
	cSql += "			UNION " // Nao faturados Software
	cSql += "			SELECT   "
	cSql += "					C5_EMISSAO, " 
	cSql += "					C6_PRODUTO,  "
	cSql += "					C6_XOPER, "
	cSql += "					C6_NOTA,  "
	cSql += "					C6_SERIE,  "
	cSql += "					C6_DATFAT, "
	cSql += "					C5_NUM,  "
	cSql += "					C5_XNPSITE, " 
	cSql += "					C5_CHVBPAG, "
	cSql += "					C5_XCARTAO, "
	cSql += "					C5_XCODAUT, "
	cSql += "					C5_XARQCC,  "
	cSql += "					C5_XDOCUME, "
	cSql += "					C5_XNFHRD,  "
	cSql += "					C5_XNFSFW,  "
	cSql += "					C5_XNFHRE,  "
	cSql += "					SC5.C5_XLINDIG "
	cSql += "			FROM "
	cSql += "					" + RetSqlName("SC5") + " SC5, "
	cSql += "					" + RetSqlName("SC6") + " SC6  "
	cSql += "			WHERE "
	cSql += "					SC5.C5_FILIAL  = '" + xFilial("SC5") + "' AND "
	cSql += "					SC5.C5_EMISSAO BETWEEN '" + DtoS( Date() - nDias ) + "' AND  TO_CHAR((SYSDATE -1),'YYYYMMDD' ) AND " 
	cSql += "					SC5.D_E_L_E_T_ = ' ' AND "
	cSql += "					SC5.C5_TIPMOV  = '2' AND "
	cSql += "					SC5.C5_XARQCC  = ' ' AND "
	cSql += "					SC5.C5_XCODAUT > ' ' AND "
	cSql += "					SC6.C6_FILIAL  = SC5.C5_FILIAL AND "
	cSql += "					SC6.C6_NUM     = SC5.C5_NUM AND "
	cSql += "					SC6.D_E_L_E_T_ = ' '  AND "
	cSql += "					SC6.C6_XOPER   = '52' AND "
	cSql += "					SC6.C6_NOTA    = ' '  AND " 
	cSql += "					SC6.C6_BLQ     = ' ' "
	cSql += " ) "
	cSql += "GROUP BY  C5_NUM, C5_XNPSITE "

	cSql := ChangeQuery( cSql )

	cTrb:= GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	
	oLog:AddLog( "Iniciando processamento " )
	While (ctrb)->( !Eof() )  
		lFat        :=.T.
		lServ       :=.T.  
		lProd       :=.T.  
		lEnt        :=.F.
		cOperVen    :='52'
		cOperEntH   :=nil
		cOperVenS   :='51'
		lRecPgto    :=.F.
		lGerTitRecb :=.F.
		cTipTitRecb :=' '
		cPedido     := (ctrb)->PEDIDO
		cPedSite    := (ctrb)->PEDSITE
		
		oLog:AddLog( { "Pedido Protheus: " + cPedido, "Pedido Site: " + cPedSite } )

		//Faz distribuiÁ„o e monitora a quantidade de thread em execuÁ„o
		nThread := 0
		aUsers 	:= Getuserinfoarray()
		aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatCa" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
		
		If nThread <= 10
			If SC5->(MsSeek(xFilial("SC5")+cPedido))                     
				nTotThread += 1
				nRecPed:=sc5->(recno())
				oLog:AddLog( "U_VNDA190P - Faturando pedido site: " + cPedSite )
				StartJob("U_VNDA190P",GetEnvServer(),.F.,cJobEmp,cJobFil,nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb)  //Apenas nota de entrega
				//U_VNDA190P('01','02',nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb	)  //Para debugar utilizar este
				aAdd( aLogPedSit, cPedSite )
			EndIf
			(ctrb)->( DbSkip() )  
		Else
			While nThread > 10
				oLog:AddLog( "Quantidade de threads consumidas no processo: " + cValToChar( nThread )  )
				SLEEP( 60000 )
				nThread := 0
				aUsers 	:= Getuserinfoarray()
				aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatCa" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
				oLog:AddLog( "Quantidade de threads abertas apÛs liberaÁ„o : " + cValToChar( nThread )  )
			EndDo
		EndIf

		If nTotThread > 10                           
			fatConout(   "Processou " + cValToChar( nTotThread ) + " threads - Libera memoria" )
			oLog:AddLog( "Processou " + cValToChar( nTotThread ) + " threads - Libera memoria" )
			DelClassIntf()
			nTotThread := 0
		EndIf
	End   
	
	oLog:AddLog( "Quantidade de pedidos que iniciaram o JOB de faturamento: " + cValToChar( len( aLogPedSit ) ) )
	oLog:AddLog( "Finalizado processamento" )
	oLog:EnviarLog()
	
	If lJob
		RESET ENVIRONMENT
	EndIf	
Return

/*/{Protheus.doc} FatPltGr
Processar faturamento de pedidos em POLITICA DE GARANTIA
@author Giovanni
@since 29/09/2015
/*/
User Function FatPltGr(cXC5_NUM)
	// Faturamento da Pol√≠tica de Garantia
	
	Local   dEmisDe  	:= StoD('20200101')
	Local   dEmisAte 	:= NIL
	Local   dValidAte	:= NIL
	Local	dC5EmisAte	:= NIL
	Local 	cPedGar     := ''
	Local 	lFat        :=.F.
	Local 	lServ       :=.F.
	Local 	lProd       :=.F.
	Local 	lEnt        :=.F.
	Local 	cOperVen    :=nil
	Local 	cOperEntH   :=nil
	Local 	cOperVenS   :=nil
	Local 	lRecPgto    :=.F.
	Local 	lGerTitRecb :=.F.
	Local 	cTipTitRecb :=''
	Local 	dDtRef      := nil
	Local 	cTpRef      := ''
	Local   cPedVenda   := ''
	Local 	dDataProc   := nil
	Local 	cProdutoH   := ''
	Local 	nVlrPrdH    := 0
	Local 	nVlrPisH    := 0
	Local   nVlrCofH  	:= 0

	Local 	cProdutoS   := ''
	Local 	nVlrServ    := 0
	Local 	nVlrPisS    := 0
	Local   nVlrCofS 	:= 0
	Local   nTotThread  := 0
	Local   nLimite     := 0

//	Local 	nLin		:= 0    // RETIRADO POR NUNCA SER USADA - mgomes.upduo - 24/03/2021
//	Local	aProdutoS	:= {}   // RETIRADO POR NUNCA SER USADA - mgomes.upduo - 24/03/2021
	Local	cXnpSite	:= ''
	Local   cWhere		:= ''
	Local 	lJob		:= (Select('SX6')==0)
//	local	aTeste      := ""  // RETIRADO POR NUNCA SER USADA - mgomes.upduo - 24/03/2021
	local oLog 		 := nil
	
	Default cXC5_NUM	:= ''

	fatConout("PREPARA«√O EXECU«√O FATPLTGR")

	IF lJob
		RpcSetType( 3 )
		RpcSetEnv( '01', '02' )
	EndIF

	dEmisDe := StoD( GetMV( "MV_XCORFPL",, DtoS(dEmisDe) ) )  // CORTE DA PLT - EXECUTAR SOMENTE A PARTIR DE 2021 - REUNI√O YURI, ALINE

	oLog := CSLog():New( cSX6_LOG )
	oLog:SetAssunto( "[ FatPltGr ] - JOB Politica de Garantia" )

	fatConout("INICIO EXECU«√O FATPLTGR - EMISS√O PEDIDO A PARTIR DE "+DtoC(dEmisDe))

	nDiasPltP := GetMV( "MV_XDIAPGP",, 181)   //dias que se apropria da receita do pedido caso somente tenha sido pago
	dEmisAte 	:= dDataBase-nDiasPltP
	nDiasPltV := GetMV( "MV_XDIAPGV",, 31 )   //dias que se apropria da receita do pedido a partir da validaÁ„o
	dValidAte	:= dDataBase-nDiasPltV	

	//dEmisAte 	:= dDataBase-181
	//dValidAte	:= dDataBase-31
	dC5EmisAte	:= LastYDate(DDatabase)

	cWhere := "% " + Iif(Empty(cXC5_NUM),""," AND C5_NUM = '" + cXC5_NUM + "'") + " %"

	IF Select("PLTGRT") > 0
		DbSelectArea("PLTGRT")
		DbCloseArea()
	ENDIF

	BeginSql Alias "PLTGRT"
		
  
		SELECT *
		FROM
		(
		SELECT
				GTLEGADO.R_E_C_N_O_ RECLEG,
				C5_NUM PEDIDO,
				GT_PEDVENDA,
				GT_TYPE,
				GT_INPROC,
				GT_PRODUTO,
				GT_LANCTBPRD,
				GT_DTBAIXA,
				C5_EMISSAO EMISSAO_PED,
				C5_XNPSITE CODSITE,
				C5_CHVBPAG ,
				C6_PEDGAR CODGAR,
				C6_PRODUTO,
				C5_ARQVTEX,
				NVL((SELECT MAX (SZ5.Z5_DATVAL)  FROM %Table:SZ5% SZ5 WHERE Z5_FILIAL=%xFilial:SZ5% AND Z5_PEDGAR=C6_PEDGAR AND C6_PEDGAR > ' ' AND SZ5.D_E_L_E_T_=' '),' ')  AS DATVAL,
				NVL((SELECT MAX (SZ5.Z5_DATEMIS) FROM %Table:SZ5% SZ5 WHERE Z5_FILIAL=%xFilial:SZ5% AND Z5_PEDGAR=C6_PEDGAR AND C6_PEDGAR > ' ' AND SZ5.D_E_L_E_T_=' '),' ')  AS DATEMIS,
				NVL((SELECT MAX (SZ5.Z5_PEDGANT) FROM %Table:SZ5% SZ5 WHERE Z5_FILIAL=%xFilial:SZ5% AND Z5_PEDGAR=C6_PEDGAR AND C6_PEDGAR > ' ' AND SZ5.D_E_L_E_T_=' '),' ')  AS PEDGANT,
				C5_TIPMOV TIPMOV,
				C5_TIPVOU TIPVOU,
				C5_XNATURE NATUREZA,
				NVL((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C6_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR' ),' ')  AS EMIS_PR,
				NVL((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C6_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC'),' ')  AS EMIS_NCC,  
				NVL((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C6_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR' ), 0 )  AS VALOR_PR,
				NVL((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C6_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC'), 0 )  AS VALOR_NCC,
				NVL((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C6_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR' ), 0 )  AS SALDO_PR,
				NVL((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C6_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC'), 0 )  AS SALDO_NCC,
				C5_XCARTAO CARTAO,
				C5_XCODAUT CODAUT,
				C5_XNPARCE PARCELA,
				C5_XLINDIG LINHA_DIG,
				C5_XNUMVOU NUMVOU,
				C5_XRECPG RECIBO,
				C5_XNFHRD NF_HRD,
				C5_XNFSFW NF_SFW,
				C5_TOTPED TOTPED, 
				C5_NOTA   NOTASC5,
				C6_NOTA   NOTA,
				C6_ITEM,
				C6_XOPER,
				C6_VALOR,
				SC6.R_E_C_N_O_ RECSC6
		FROM
			%Table:SC5% SC5
				INNER JOIN %Table:SC6% SC6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND SC6.D_E_L_E_T_=' '
				LEFT JOIN GTLEGADO ON GT_PEDVENDA=SC6.C6_NUM AND GT_PRODUTO=SC6.C6_PRODUTO AND GT_PEDGAR=SC6.C6_PEDGAR AND GTLEGADO.D_E_L_E_T_=' '
		WHERE
			SC5.D_E_L_E_T_ = ' '
			AND C5_FILIAL = %xFilial:SC5% 
			AND C5_EMISSAO >= %Exp:DtoS(dEmisDe)%
			AND C5_EMISSAO <= %Exp:DtoS(dC5EmisAte)%
			AND C5_XORIGPV = ANY ( '2', 'A', 'B' )
			AND C5_XRECPG > ' ' 
			AND C5_NOTA = ' '
			AND C6_NOTA = ' '
			%Exp:cWhere%
		
		) 
		
		WHERE 
		
			( GT_PEDVENDA IS NULL OR (GT_TYPE='S' AND GT_INPROC='F' AND NOTA= ' ') )

			AND 
			(
				/* RECEBIMENTOS DE PEDIDOS GAR QUE EST√ÉO VALIDADOS A MAIS DE 3O DIAS E N√ÉO FORAM EMITIDOS*/       
				( DATVAL>' 'and DATVAL<=%Exp:DtoS(dValidAte)%  And PEDGANT=' ' AND ( SALDO_PR>0 OR SALDO_NCC>0) )
				
			OR
				(
					( /*AUTORIZA√á√ïES DE PAGAMENTO DE CART√ÉO DE PEDIDOS GAR QUE N√ÉO FORAM VALIDADOS OU N√ÉO FORAM EMITIDOS A MAIS DE 180 DIAS.*/
						(EMIS_PR >=%Exp:DtoS(dEmisDe)%  AND EMIS_PR<=%Exp:DtoS(dEmisAte)% AND ( SALDO_PR>0 OR SALDO_NCC>0))
						OR 
						/* RECEBIMENTOS DE PEDIDOS GAR (CART√ÉO OU BOLETO) QUE N√ÉO FORAM VALIDADOS OU N√ÉO FORAM EMITIDOS A MAIS DE 180 DIAS.*/
						(EMIS_NCC >= %Exp:DtoS(dEmisDe)% AND EMIS_NCC<= %Exp:DtoS(dEmisAte)% AND SALDO_NCC>0 )
					)
					
					/* E QUE A DATA DE N√ÉO FORAM VALIDADOS NOS ULTIMOS 30 DIAS  */	
					AND (DATVAL<=%Exp:DtoS(dValidAte)%)       
					/* E QUE N√ÉO SEJA SALDO RESIDUAL DE COMPENSA«ÉO DE Tˇ?ULOS - SER√ÉO TRATADOS NA ROTINA FCOMPSUB().*/
					AND VALOR_NCC>0.02
				)
			)

		ORDER BY PEDIDO, C6_ITEM

	EndSql
	
	//aTeste := GetLastQuery() - recupera query de um beginSQL - so usar para debug 

	PLTGRT->( dbGotop() )
	While PLTGRT->( !Eof() )
		cPedGar     := PLTGRT->CODGAR
		cXnpSite	:= PLTGRT->CODSITE
		lFat        :=.F.
		lServ       :=.F.
		lProd       :=.F.
		lEnt        :=.F.
		cOperVen    :=nil
		cOperEntH   :=nil
		cOperVenS   :=nil
		lRecPgto    :=.F.
		lGerTitRecb :=.F.
		cTipTitRecb :=''
		dDtRef      := Stod(IIF( !Empty(PLTGRT->EMIS_PR) .and. (PLTGRT->EMIS_PR<PLTGRT->EMIS_NCC)  , PLTGRT->EMIS_PR ,   IIF(!empty(PLTGRT->EMIS_NCC),PLTGRT->EMIS_NCC,PLTGRT->EMIS_PR )))
		cTpRef      := IIF( !Empty(PLTGRT->EMIS_PR) .and. (PLTGRT->EMIS_PR<PLTGRT->EMIS_NCC)  , "PR" ,   IIF(!empty(PLTGRT->EMIS_NCC),"NCC","PR" ))
		cPedVenda   := PLTGRT->PEDIDO
		dDataProc   := dDataBase
		cProdutoH   := ''
		nVlrPrdH    := 0
		nVlrPisH    := 0
		nVlrCofH  	:= 0
		cOperVenS   := ''
		cProdutoS   := ''
		nVlrServ    := 0
		nVlrPisS    := 0
		nVlrCofS 	:= 0
		nTotThread  := 0

		oLog:AddLog( { "Pedigo GAR: " + cPedGar, "Pedigo Site: " + cXnpSite } )

		IF PLTGRT->C6_XOPER $ '51,61' //.AND. EMPTY(PLTGRT->NOTA)
			//Prepara faturamento somente do Servi√ßo e grava na tabela de legado para controle e referencia
			lFat        := .T.
			lServ       := .T.
			cOperVenS   := PLTGRT->C6_XOPER
			cProdutoS   := PLTGRT->C6_PRODUTO
			nVlrServS   := PLTGRT->C6_VALOR  
			nVlrPisS    := 0
			nVlrCofS 	:= 0

			//Atualiza o produto da GTLEGADO quando o cÛdigo Pedido GAR È diferente da SC6
			atuLegProd( PLTGRT->RECLEG, cPedGar, cProdutoS, cXnpSite, cPedVenda, PLTGRT->EMISSAO_PED, nVlrServS )

			nLimite := 15
			nThread := nLimite
			While nThread >= nLimite
				nThread := 0
				aUsers 	:= Getuserinfoarray()
				aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatAL" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
				IF nThread >= nLimite
				   Sleep(5000)
				Endif
			EndDo

			nTotThread += 1
			If nTotThread >= nLimite
				fatConout( "FATPLTGR Processou " + cValToChar( nTotThread ) + " threads - Libera memoria" )
				DelClassIntf()
				nTotThread := 0
			EndIf

			lRet := fGrvLeg( cPedVenda, 'S', cProdutoS, nVlrServS, nVlrPisS, nVlrCofS, dDataProc, dDtRef, cTpRef,cPedGar, cXnpSite  )
			If lRet 

				If SC5->(MsSeek(xFilial("SC5")+cPedVenda))
					nRecPed := SC5->(recno())
					
					DbSelectArea('SC5')
					//DbGoTo(nRecPed)
					Reclock('SC5',.F.)
					SC5->C5_XMENSUG:='024'
					MsUnlock()

					Sleep(5000)
						
					StartJob("U_VNDA190P",GetEnvServer(),.F.,'01','02',nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb,PLTGRT->RECSC6)   // ACRESCENTEI PARAMETRO RECNO SC6 PARA POSICIONAR SC6 NA FUN«√O VNDA190 PEDGAR - mgomes.upduo - 24/03/2021
					//U_VNDA190P('01','02',nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb,PLTGRT->RECSC6)  //Para debugar utilizar este

				Endif
						
			EndIf

		ElseIf PLTGRT->C6_XOPER $ '52,62' //.AND. EMPTY(PLTGRT->NOTA)
		
			//N√£o fatura produtos em garantia. Apenas registra na tabela de Legado para contabiliza√ß√£o
		
			cProdutoH   := PLTGRT->C6_PRODUTO
			nVlrPrdH    := PLTGRT->C6_VALOR  
			nVlrPisH    := PLTGRT->C6_VALOR*1.65/100 
			nVlrCofH  	:= PLTGRT->C6_VALOR*7.60/100
		
			fGrvLeg( cPedVenda, 'P', cProdutoH,	nVlrPrdH, nVlrPisH, nVlrCofH, dDataProc, dDtRef, cTpRef, cPedGar, cXnpSite )

		Endif

		PLTGRT->( DbSkip() )

		/*	BLOCO ABAIXO SUBSTITUIDO PELO BLOCO ACIMA INICIADO NA LINHA 905, POR mgomes.upduo (SIS-152) - 24/03/2021
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+cPedVenda)	
		
		WHILE !Eof().And. SC6->C6_NUM==cPedVenda
		
				IF SC6->C6_XOPER $ '51,61' .AND. EMPTY(SC6->C6_NOTA)
					//Prepara faturamento somente do Servi√ßo e grava na tabela de legado para controle e referencia
					lFat        := .T.
					lServ       := .T.
					cOperVenS   := SC6->C6_XOPER
					cProdutoS   := SC6->C6_PRODUTO
					nVlrServS   := SC6->C6_VALOR  
					nVlrPisS    := 0
					nVlrCofS 	:= 0
					
					//Atualiza o produto da GTLEGADO quando o cÛdigo Pedido GAR È diferente da SC6
					atuLegProd( PLTGRT->RECLEG, cPedGar, cProdutoS, cXnpSite, cPedVenda, PLTGRT->EMISSAO_PED )
								
					aADD( aProdutoS, {cProdutoS,nVlrServS,nVlrPisS,nVlrCofS} )
					
				ElseIf SC6->C6_XOPER $ '52,62' .AND. EMPTY(SC6->C6_NOTA)
				
					//N√£o fatura produtos em garantia. Apenas registra na tabela de Legado para contabiliza√ß√£o
				
					cProdutoH   := SC6->C6_PRODUTO
					nVlrPrdH    := SC6->C6_VALOR  
					nVlrPisH    := SC6->C6_VALOR*1.65/100 
					nVlrCofH  	:= SC6->C6_VALOR*7.60/100
				
					fGrvLeg( cPedVenda, 'P', cProdutoH,	nVlrPrdH, nVlrPisH, nVlrCofH, dDataProc, dDtRef, cTpRef, cPedGar, cXnpSite )
			
					DbSelectArea("SC6")
					DbSkip() 
					Loop
				Else
					DbSelectArea("SC6")
					DbSkip() 
					Loop
				Endif
				DbSelectArea("SC6")
				DbSkip() 
		EndDo
		
		If !EMPTY(cPedVenda) .AND. lFat

			//Faz distribui√ß√£o e monitora a quantidade de thread em execu√ß√£o
			nThread := 0
			aUsers 	:= Getuserinfoarray()
			aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatAL" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })

			If nThread <= 20

				If SC5->(MsSeek(xFilial("SC5")+cPedVenda))
					nTotThread += 1

					nRecPed:=SC5->(recno())
					
					For nLin := 1 To Len( aProdutoS )
							//fGrvLeg( cPedVenda, 'S', cProdutoS		 , nVlrServS		, nVlrPisS		   , nVlrCofS		  , dDataProc, dDtRef, cTpRef,cPedGar, cXnpSite   )
						lRet := fGrvLeg( cPedVenda, 'S', aProdutoS[nLin,1], aProdutoS[nLin,2], aProdutoS[nLin,3], aProdutoS[nLin,4], dDataProc, dDtRef, cTpRef,cPedGar, cXnpSite   )
					Next nLin

					If lRet 
						
						DbSelectArea('SC5')
						DbGoTo(nRecPed)
						Reclock('SC5',.F.)
						SC5->C5_XMENSUG:='024'
						MsUnlock()
						
						StartJob("U_VNDA190P",GetEnvServer(),.F.,'01','02',nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb)
						//U_VNDA190P('01','02',nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb	)  //Para debugar utilizar este
					
					Endif
					
				EndIf

				PLTGRT->( DbSkip() )

			Else

				While nThread>20
					SLEEP(60000)
					nThread := 0
					aUsers 	:= Getuserinfoarray()
					aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatAL" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })

				EndDo

			EndIf

			If nTotThread > 20
				fatConout( "Processou " + cValToChar( nTotThread ) + " threads - Libera memoria" )
				DelClassIntf()
				nTotThread := 0
			EndIf

		ELSE
			PLTGRT->( DbSkip() )
		EndIf
		aProdutoS := {}
		*/
	EndDo
	PLTGRT->( DbCloseArea() )
	oLog:EnviarLog()

	fatConout("FIM EXECU«√O FATPLTGR")
Return                  

/*/{Protheus.doc} fGrvLeg
Grava legado
@author Giovanni
@since 29/09/2015
/*/
Static Function fGrvLeg(cPedVenda, cType, cProduto,	nVlrPrd, nVlrPis, nVlrCofins, dDataProc, dDtRef, cTpRef, cPedGar, cXnpSite  )
	Local lRet:=.f.
    Local lExistGar := .NOT. Empty( cPedGar )
    Local cSeek := IIF( lExistGar, cPedGar + cType + cProduto, cXnpSite + cType + cProduto )

    USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela GTLEGADO - SHARED" )
        Return(lRet)
	Endif
	IF lExistGar
		//Seta pela ordem PEDIDO GAR
		DbSetIndex("GTLEGADO02")
    Else
		//Seta pela ordem PEDIDO SITE
		DbSetIndex("GTLEGADO04")
    EndIF
	dbSelectArea("GTLEGADO")
	dbSetOrder(1)

    If !DbSeek( cSeek ) 
        GTLEGADO->( RecLock("GTLEGADO",.T.) )
        GTLEGADO->GT_PEDVENDA	:= cPedVenda
        GTLEGADO->GT_PEDGAR 	:= cPedGar
        GTLEGADO->GT_PEDSITE 	:= cXnpSite
        GTLEGADO->GT_TYPE   	:= cType
        GTLEGADO->GT_INPROC 	:= .F.          
        GTLEGADO->GT_DATA		:= dDataProc
        GTLEGADO->GT_DTREF		:= dDtRef
        GTLEGADO->GT_TPREF		:= cTpRef
        GTLEGADO->GT_PRODUTO	:= cProduto
        GTLEGADO->GT_VLRPRD		:= nVlrPrd
        GTLEGADO->GT_VLRPIS		:= nVlrPis
        GTLEGADO->GT_VLRCOFINS	:= nVlrCofins
        GTLEGADO->( MsUnlock() )
		lRet := .T.
    ElseIF GTLEGADO->GT_INPROC == .F.
        lRet := .T. //Retorna Verdadeiro para processar fatuaramento
    Else
        lRet := .F. //Retorna Falso para n√£o processar faturamento
    Endif
    GTLEGADO->( DbCloseArea() )
Return(lRet)       

/*/{Protheus.doc} fGrvLeg
Funcao de execucao unica, para criar campo adicional na GTLEGADO
@author Giovanni
@since 29/09/2015
/*/
User Function fGrvLeg()

	rpcsetenv('01','02')

	USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	If neterr()
		MsgStop("Falha ao abrir GTLEGADO")
		return
	Endif

	aStru := dbstruct()

	aNewStru := aclone(aStru)

	If fieldpos("GT_DATA") > 0
	//	MsgInfo("Campo GT_DATA JA CRIADO")
	ELSE
		aadd(aNewStru,{"GT_PEDVENDA" ,"C",6,0})    // PEDIDO DE VENDA
		aadd(aNewStru,{"GT_DATA"     ,"D",8,0})    // DATA DO PROCESSAMENTO
		aadd(aNewStru,{"GT_DTREF"    ,"D",8,0})    // DATA DE REFERENCIA/ PR OU NCC
		aadd(aNewStru,{"GT_TPREF"    ,"C",3,0})    // TIPO DE REFERENCIA/ PR OU NCC
		aadd(aNewStru,{"GT_LANCTBPRD","D",8,0})    // DATA LANC. PRD NA CONTABILDIADE
		aadd(aNewStru,{"GT_REVCTBPRD","D",8,0})    // DATA REVERS√ÉO DO LANC PRD NA CONTABILDIADE
		aadd(aNewStru,{"GT_PRODUTO"  ,"C",15,0})   // CODIGO DO PRODUTO DE REFERENCIA
		aadd(aNewStru,{"GT_VLRPRD"   ,"N",16,2})   // VLR DO PRODUTO DE REFERENCIA/ PR OU NCC
		aadd(aNewStru,{"GT_VLRPIS"   ,"N",16,2})   // DATA DE REFERENCIA/ PR OU NCC
		aadd(aNewStru,{"GT_VLRCOFINS","N",16,2})   // DATA DE REFERENCIA/ PR OU NCC
	Endif

	If fieldpos("GT_DTBAIXA") > 0
	//	MsgInfo("Campo GT_DTBAIXA JA CRIADO")
	ELSE
		aadd(aNewStru,{"GT_DTBAIXA"     ,"D",8,0})    // DATA DA BAIXA
		aadd(aNewStru,{"GT_DTESTBAIXA"  ,"D",8,0})    // DATA DO ESTONO DA BAIXA
	Endif


	If fieldpos("GT_PRODUTO") > 0
	//	MsgInfo("Campo GT_PRODUTO J`CRIADO")
	ELSE
		aadd(aNewStru,{"GT_PRODUTO"  ,"C",15,0})   // CODIGO DO PRODUTO DE REFERENCIA
	Endif

	IF !len(aNewStru)>0
		Return
	Endif
	USE

	lOk := TcAlter("GTLEGADO",aStru,aNewStru)

	IF !lOk
		MsgStop(tcsqlerror(),"Falha em TCAlter")
	Else
		MSgInfo("Campo GT_INPROC acrescentado com sucesso")
	Endif

	If !TcCanOpen('GTLEGADO','GTLEGADO02' )
		USE GTLEGADO ALIAS GTLEGADO EXCLUSIVE NEW VIA "TOPCONN"
		
		IF NetErr()
			UserException("Falta ao abrir GTLEGADO em modo exclusivo para criacao do indice." )
		Endif
		
		// Cria o indice para busca de dados
		INDEX ON GT_PEDGAR + GT_TYPE + GT_PRODUTO TO ("GTLEGADO02")
		
		USE		
	Endif

Return

/*/{Protheus.doc} FCompSub
Processar compensaÁ„o e substituiÁ„o de pedidos pendentes
@author Giovanni
@since 29/09/2015
/*/
User Function FCompSub(aParam,cPedErp)
	Local lJob 			:= ( Select( "SX6" ) == 0 )
	//Local cJobEmp		:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	//Local cJobFil		:= Iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local cSQL			:= ''
	Local cBeginQry		:= ''
	Local cMiddleQry	:= ''
	Local cQryPed		:= ''
	Local cQryValid		:= ''
	Local cEndQry		:= ''
	Local cFilterPed	:= ''
	Local cFilterValid	:= ''
	Local cFilterNPed	:= ''
	Local cEmisIn		:= ''
	Local cEmisAt		:= ''

	Default cPedErp		:= ''
	Default cJobEmp		:= '01'
	Default cJobFil		:= '02'
	Default cEmisDe 	:= '20180101'

	fatConout( "PREPARA«√O EXECU«√O FCOMPSUB" )

	if valtype(aParam) == "A"
	   if len(aParam) > 0
		  cJobEmp:= aParam[ 1 ]
		  cJobFil:= aParam[ 2 ]
	   endif
	endif
	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	cEmisDe := GetMV( "MV_XCORSUB",, cEmisDe )  // CORTE DA SUB
	//cEmisDe := '20191201'
	//cEmisAt := '20190631'
	nDias := 100
	cEmisIn := cEmisDe

	while cEmisDe <= DtoS(dDatabase+nDias)

		fatConout( "INICIO EXECU«√O FCOMPSUB - EMISS√O PEDIDO A PARTIR DE "+DtoC(StoD(cEmisDe)) )

		cEmisAt := dtos( stod(cEmisDe) + nDias )

		cBeginQry := "SELECT ( ( TOTPED - VALOR_NF ) - ( SALDO_PR + SALDO_NCC ) ) AS DIF, " + CRLF
		cBeginQry += "       BASE.* " + CRLF
		cBeginQry += "FROM   (SELECT /*+ INDEX(SC5 "+RetSqlName("SC5")+"2) */ C5_NUM PEDIDO, " + CRLF
		cBeginQry += "               C5_EMISSAO EMISSAO_PED, " + CRLF
		cBeginQry += "               C5_XNPSITE CODSITE, " + CRLF
		cBeginQry += "               C5_CHVBPAG CODGAR, " + CRLF
		cBeginQry += "               C5_TIPMOV TIPMOV, " + CRLF
		cBeginQry += "               C5_TIPVOU TIPVOU, " + CRLF
		cBeginQry += "               C5_XNATURE NATUREZA, " + CRLF

		//-- PEDIDOS
		cQryPed := "  NVL((SELECT Sum(E1_VALOR) FROM "+RetSqlName("SE1")+" SE11 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE11.D_E_L_E_T_ = ' ' AND SE11.E1_TIPO = 'PR'), 0) AS VALOR_PR, " + CRLF
		cQryPed += "  NVL((SELECT Sum(E1_VALOR) FROM "+RetSqlName("SE1")+" SE12 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE12.D_E_L_E_T_ = ' ' AND SE12.E1_TIPO = 'NCC' AND SE12.E1_PREFIXO IN ( 'RCP', 'VDI', 'RCO' )), 0) AS VALOR_NCC, " + CRLF
		cQryPed += "  NVL((SELECT Sum(E1_VALOR) FROM "+RetSqlName("SE1")+" SE13 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE13.D_E_L_E_T_ = ' ' AND SE13.E1_TIPO = 'NF'), 0) AS VALOR_NF," + CRLF
		cQryPed += "  NVL((SELECT Sum(E1_SALDO) FROM "+RetSqlName("SE1")+" SE14 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE14.D_E_L_E_T_ = ' ' AND SE14.E1_TIPO = 'PR'), 0) AS SALDO_PR," + CRLF
		cQryPed += "  NVL((SELECT Sum(E1_SALDO) FROM "+RetSqlName("SE1")+" SE15 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE15.D_E_L_E_T_ = ' ' AND SE15.E1_TIPO = 'NCC' AND SE15.E1_PREFIXO IN ( 'RCP', 'VDI', 'RCO' )), 0) AS SALDO_NCC," + CRLF
		cQryPed += "  NVL((SELECT Sum(E1_SALDO) FROM "+RetSqlName("SE1")+" SE16 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE16.D_E_L_E_T_ = ' ' AND SE16.E1_TIPO = 'NF'), 0) AS SALDO_NF," + CRLF

		//-- VALIDA«√O
		cQryValid := " NVL((SELECT Sum(E1_VALOR) FROM "+RetSqlName("SE1")+" SE11 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE11.D_E_L_E_T_ = ' ' AND SE11.E1_TIPO = 'PR'), 0) AS VALOR_PR, " + CRLF
		cQryValid += " NVL((SELECT Sum(E1_VALOR) FROM "+RetSqlName("SE1")+" SE12 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_OS=C5_NUMATEX   AND SE12.D_E_L_E_T_ = ' ' AND SE12.E1_TIPO = 'NCC' AND SE12.E1_PREFIXO IN ( 'RCP', 'VDI', 'RCO' )), 0) AS VALOR_NCC, " + CRLF
		cQryValid += " NVL((SELECT Sum(E1_VALOR) FROM "+RetSqlName("SE1")+" SE13 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE13.D_E_L_E_T_ = ' ' AND SE13.E1_TIPO = 'NF'), 0) AS VALOR_NF," + CRLF
		cQryValid += " NVL((SELECT Sum(E1_SALDO) FROM "+RetSqlName("SE1")+" SE14 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE14.D_E_L_E_T_ = ' ' AND SE14.E1_TIPO = 'PR'), 0) AS SALDO_PR," + CRLF
		cQryValid += " NVL((SELECT Sum(E1_SALDO) FROM "+RetSqlName("SE1")+" SE15 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_OS=C5_NUMATEX   AND SE15.D_E_L_E_T_ = ' ' AND SE15.E1_TIPO = 'NCC' AND SE15.E1_PREFIXO IN ( 'RCP', 'VDI', 'RCO' )), 0) AS SALDO_NCC," + CRLF
		cQryValid += " NVL((SELECT Sum(E1_SALDO) FROM "+RetSqlName("SE1")+" SE16 WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND E1_PEDIDO = C5_NUM AND SE16.D_E_L_E_T_ = ' ' AND SE16.E1_TIPO = 'NF'), 0) AS SALDO_NF," + CRLF

		cMiddleQry := "               C5_XCARTAO CARTAO," + CRLF
		cMiddleQry += "               C5_XCODAUT CODAUT," + CRLF
		cMiddleQry += "               C5_XDOCUME DOCUMENTO," + CRLF
		cMiddleQry += "               C5_XNPARCE PARCELA," + CRLF
		cMiddleQry += "               C5_XLINDIG LINHA_DIG," + CRLF
		cMiddleQry += "               C5_XNUMVOU NUMVOU," + CRLF
		cMiddleQry += "               C5_XRECPG RECIBO," + CRLF
		cMiddleQry += "               C5_XNFHRD NF_HRD," + CRLF
		cMiddleQry += "               C5_XNFSFW NF_SFW," + CRLF
		cMiddleQry += "               C5_TOTPED TOTPED," + CRLF
		cMiddleQry += "               C5_NOTA NOTA," + CRLF
		cMiddleQry += "               TRIM(C5_ARQVTEX) ARQVTEX," + CRLF
		cMiddleQry += "               C5_XBANDEI BANDEIRA" + CRLF
		cMiddleQry += "        FROM   "+RetSqlName("SC5")+" SC5 " + CRLF
		cMiddleQry += "        WHERE  SC5.D_E_L_E_T_ = ' ' " + CRLF
		cMiddleQry += "               AND SC5.C5_FILIAL = '"+sc5->(xfilial())+"' " + CRLF
		cMiddleQry += "               AND SC5.C5_EMISSAO >= '"+cEmisDe+"' " + CRLF
		If !empty(cEmisAt)
			cMiddleQry += "               AND SC5.C5_EMISSAO <= '"+cEmisAt+"' " + CRLF
		endif
		cMiddleQry += "               AND SC5.C5_XMENSUG = ' ' " + CRLF

		If !empty(cPedErp)
			cFilterNPed := " AND SC5.C5_NUM = '" + cPedErp + "' "  + CRLF
		Else
			cFilterNPed := " " 
		Endif

		cFilterPed := " AND SC5.C5_XNPSITE > ' ' ) BASE" + CRLF

		cFilterValid := " AND SC5.C5_NUMATEX > ' ' ) BASE" + CRLF

		cEndQry := " WHERE  ( BASE.DOCUMENTO = ' ' " + CRLF
		cEndQry += "			AND ( VALOR_PR > 0 " + CRLF
		cEndQry += "				OR ( ( VALOR_NF = VALOR_NCC ) AND ( SALDO_NF > 0 OR SALDO_NCC > 0 ) ) " + CRLF
		cEndQry += "				OR ( ( ( ( TOTPED - VALOR_NF ) - ( SALDO_NCC ) ) <> 0 ) AND ( SALDO_NF > 0 AND SALDO_NCC > 0 ) ) " + CRLF
		cEndQry += "				) " + CRLF
		cEndQry += "		)        " + CRLF
		cEndQry += "		OR 		" + CRLF
		cEndQry += "		( BASE.DOCUMENTO > ' ' " + CRLF
		cEndQry += "			AND ( ( ( VALOR_PR = VALOR_NF AND VALOR_NF = VALOR_NCC ) AND ( SALDO_NF > 0 OR SALDO_PR > 0 OR SALDO_NCC > 0 ) )" + CRLF
		cEndQry += "				  OR ( ( ( ( TOTPED - VALOR_NF ) - ( SALDO_PR + SALDO_NCC ) ) <> 0 ) AND ( SALDO_NF > 0 ) AND ( SALDO_PR > 0 OR SALDO_NCC > 0 ) )" + CRLF
		cEndQry += "                  OR ( ( VALOR_PR = VALOR_NCC ) AND VALOR_NF = 0 AND ( SALDO_PR > 0 OR SALDO_NCC > 0 ) AND ARQVTEX = 'CHARGEBACK' )" + CRLF
		cEndQry += "				)" + CRLF
		cEndQry += "		)" + CRLF

		//cSQL := cBeginQry + cQryPed + cMiddleQry + cFilterNPed + cFilterPed  + cEndQry
		cSQL := cBeginQry + cQryPed + cMiddleQry + cFilterNPed + cFilterPed
		ExecCompSu( cSQL, 'CompensaÁ„o pedidos', StoD(cEmisDe) )

		//cSQL := cBeginQry + cQryValid + cMiddleQry + cFilterNPed + cFilterValid + cEndQry
		cSQL := cBeginQry + cQryValid + cMiddleQry + cFilterNPed + cFilterValid
		ExecCompSu( cSQL, 'CompensaÁ„o ValidaÁ„o externa', StoD(cEmisDe) )

		cEmisDe := cEmisAt

	end

	fatConout("FIM EXECU«√O FCOMPSUB INICIADO EM "+DtoC(StoD(cEmisIn)))

Return

/*/{Protheus.doc} ExecCompSu
Processa a funÁ„o FCompSUB()
@author Giovanni
@since 29/09/2015
/*/
Static Function ExecCompSu( cSQL, cProcesso, dEmisDe )
	Local aSe1CAN		:= {}
	Local aSe1NF		:= {}
	Local cPedido   	:= ''
	Local cPedSite		:= ''
	Local cBandeira		:= ''
	Local cQuery		:= ''
	Local cTrbSql		:= ''
	Local cEstorno		:= ''
	Local cTRB			:= GetNextAlias()
	Local lVldSldNF 	:= .F.
	Local lVldSldRes	:= .F.
	Local nx

	Default dEmisDe  	:= StoD('20180101')
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	fatConout( "Processo iniciado: " + cProcesso )

	While (cTRB)->( !Eof() )

		If ( EMPTY((cTRB)->DOCUMENTO) .AND.;
			( (cTRB)->VALOR_PR > 0 .OR.;
			( ( (cTRB)->VALOR_NF == (cTRB)->VALOR_NCC ) .AND. ( (cTRB)->SALDO_NF > 0 .OR. (cTRB)->SALDO_NCC > 0 ) ) .OR.;
			( ( ( ( (cTRB)->TOTPED - (cTRB)->VALOR_NF ) - ( (cTRB)->SALDO_NCC )) <> 0 ) .AND. ( (cTRB)->SALDO_NF > 0 .AND. (cTRB)->SALDO_NCC > 0 ) );
			);
		) .OR.;
		( !EMPTY((cTRB)->DOCUMENTO) .AND.;
			( ( ( (cTRB)->VALOR_PR == (cTRB)->VALOR_NF .AND. (cTRB)->VALOR_NF == (cTRB)->VALOR_NCC) .AND. ( (cTRB)->SALDO_NF > 0 .OR. (cTRB)->SALDO_PR > 0 .OR. (cTRB)->SALDO_NCC > 0) ) .OR.;
			( ( ( ( (cTRB)->TOTPED - (cTRB)->VALOR_NF ) - ( (cTRB)->SALDO_PR + (cTRB)->SALDO_NCC) ) <> 0 ) .AND. ( (cTRB)->SALDO_NF > 0 ) .AND. ( (cTRB)->SALDO_PR > 0 .OR. (cTRB)->SALDO_NCC > 0 ) ) .OR.;
			( ( (cTRB)->VALOR_PR == (cTRB)->VALOR_NCC ) .AND. (cTRB)->VALOR_NF == 0 .AND. ( (cTRB)->SALDO_PR > 0 .OR. (cTRB)->SALDO_NCC > 0 ) .AND. ALLTRIM((cTRB)->ARQVTEX) == 'CHARGEBACK' ) ;
			);
		)

		cPedido		:= (cTRB)->PEDIDO
		cPedSite 	:= AllTrim( (cTRB)->CODSITE )
		cBandeira	:= AllTrim( (cTRB)->BANDEIRA )

		If Empty( (cTRB)->ARQVTEX )
			lVldData := .T.                                                                                               
			/*
			//Se o VALOR Total da NF √© Igual ao VALOR Total da NCC OU diferen√ßa entre OS VALORES √© menor igual a 0.02 OU a ddiferen√ßa entre OS SALDOS √© menor igual a 0.02, 
			//Ent√£o for√ßa a compensa√ß√£o dos SALDOS em aberto independente do valor do saldo das parcelas
			//Sen√£o for√ßa a compensa√ßao somente de saldos res√≠duais < 0.02 de parcelas
			lVldSldRes:= iif( FCOMPSUB->VALOR_NF==FCOMPSUB->VALOR_NCC .or. ;
							(FCOMPSUB->SALDO_NF-FCOMPSUB->SALDO_NCC>=-0.02 .AND. FCOMPSUB->SALDO_NF-FCOMPSUB->SALDO_NCC<=0.02) .or.;
							(FCOMPSUB->VALOR_NF-FCOMPSUB->VALOR_NCC>=-0.02 .AND. FCOMPSUB->VALOR_NF-FCOMPSUB->VALOR_NCC<=0.02) .OR.;  ,.f.,.t.) 
			*/
			lVldSldRes := .F. //se est√° no select √© porque existe um erro ou falta compesa√ß√£o. Ent√£o For√ßa a compensa√ß√£o independente de saldo ou parcela	                                                                                                                             
			lVldSldNF := iif(	(cTRB)->SALDO_PR>0 .and.((cTRB)->VALOR_NF-(cTRB)->VALOR_PR>=-0.02 .AND. (cTRB)->VALOR_NF-(cTRB)->VALOR_PR<=0.02),.F.,.T.)//Se saldo do PR maior que Zero, Ignora Saldo da NF. Considera o Valor o que ir√° for√ßar a substitui√ß√£o do PR pela NF
			
			//VERIFICA NECESSIDADE DE PROCURA DE BAIXAS INDEVIDAS POR CANCELAMENTO
			cQuery := "SELECT SE1.R_E_C_N_O_ RECE1, SE5.R_E_C_N_O_ RECE5 , SE5.E5_SEQ SEQ"
			cQuery += "		FROM "+RetSqlName("SE5")+ " SE5 
			
			cQuery += "	         LEFT JOIN "+RetSqlName("SE5")+ " ESTORNO ON "
			cQuery += "	         ESTORNO.E5_FILIAL='"+xFilial("SE5")+"' AND  "
			cQuery += "	         ESTORNO.E5_DATA>='"+DtoS(dEmisDe)+"'  AND "
			cQuery += "	         ESTORNO.D_E_L_E_T_=' ' AND "
			cQuery += "	         ESTORNO.E5_MOTBX='CAN' AND "
			cQuery += "	         ESTORNO.E5_FILIAL=SE5.E5_FILIAL AND "
			cQuery += "	         ESTORNO.E5_PREFIXO=SE5.E5_PREFIXO AND "
			cQuery += "	         ESTORNO.E5_NUMERO= SE5.E5_NUMERO AND "
			cQuery += "	         ESTORNO.E5_PARCELA=SE5.E5_PARCELA AND "
			cQuery += "	         ESTORNO.E5_TIPO=SE5.E5_TIPO AND "
			cQuery += "	         ESTORNO.E5_CLIFOR=SE5.E5_CLIFOR AND "
			cQuery += "	         ESTORNO.E5_LOJA=SE5.E5_LOJA AND "
			cQuery += "	         ESTORNO.E5_SEQ=SE5.E5_SEQ AND "
			cQuery += "	         ESTORNO.E5_TIPODOC='ES', "

			cQuery += "	    	 "+RetSqlName("SE1") +" SE1  "
			cQuery += "		WHERE "
			cQuery += "		SE5.E5_FILIAL='"+xFilial("SE5")+"' "
			cQuery += "		AND SE5.E5_DATA>='"+DtoS(dEmisDe)+"' "
			cQuery += "		AND SE5.D_E_L_E_T_=' ' "
			cQuery += "		AND SE5.E5_SITUACA=' ' "
			cQuery += "		AND SE5.E5_MOTBX='CAN' AND SE5.E5_HISTOR =SE5.E5_PREFIXO||SE5.E5_NUMERO||SE5.E5_PARCELA||SE5.E5_TIPO||'CAN' "  
			cQuery += "		AND SE1.E1_FILIAL='"+xFilial("SE1")+"' "
			cQuery += "		AND SE1.E1_PREFIXO=SE5.E5_PREFIXO "
			cQuery += "		AND SE1.E1_NUM=SE5.E5_NUMERO "
			cQuery += "		AND SE1.E1_PARCELA=SE5.E5_PARCELA "
			cQuery += "		AND SE1.E1_TIPO=SE5.E5_TIPO "
			cQuery += "		AND SE1.E1_CLIENTE=SE5.E5_CLIFOR "
			cQuery += "		AND SE1.E1_LOJA=SE5.E5_LOJA "
			cQuery += "		AND SE1.E1_PEDIDO='"+cPedido+"' "
			cQuery += "		AND SE1.D_E_L_E_T_=' ' "
			cQuery += "		AND ESTORNO.E5_DATA IS NULL "

			cTrbSql := GetNextAlias()
			PLSQuery( cQuery, CTrbSql )
			
			aSe1CAN := {}
			
			While !(cTrbSql)->(Eof())
				AAdd( aSe1CAN, {(cTrbSql)->RECE1,(cTrbSql)->RECE5,(cTrbSql)->SEQ} )
				(cTrbSql)->(DbSkip())
			End

			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )
			
			If Len(aSe1CAN)>0
				For nx:=1 to len(aSe1CAN)
					cEstorno := aSe1CAN[ nX, 3 ]
					
					//VERIFICA SE CANCELAMENTO FOI CONTABILIZADO
					DbSelectArea("SE5")
					SE5->( dbGoTo( aSe1CAN[ nX, 2 ]) )
					
					//Atualiza campo de controle de contabiliza√ß√£o para que no estorno seja criado um novo registro no E5. 
					//Por padr√£o este campo fica fazio se o motivo o baixa for n√£o gerar movimento banc√°rio. Porem, para efeito de posi√ß√£o de 
					//t√≠tulos a receber se faz necess√°rio conhecer a data da baixa e a data de cancelamento da baixa. 

					Reclock("SE5",.F.)
						SE5->E5_LOTE := '8850'
					MSUNLOCK()
					
					//Estorna a baixa do t√≠tulo
					//Manter SE1 POSICIONADO
					DbSelectArea("SE1")
					SE1->( dbGoTo( aSe1CAN[ nX, 1 ]) )
					
					FaBaixaCR(	{0,0,0}, {},.F.,.F., .F.,cEstorno,.F.)
				
					SE5->(MSUNLOCK())
					SE1->(MSUNLOCK())
					SA1->(MSUNLOCK())  
					
					cEstorno := NIL
					
					IF SE1->E1_TIPO <> 'NCC'
						lVldData := .F. //Deve usar a data base para compensaÁ„o
					Endif
				Next
			Endif	 
				
			// Localiza as NFs do pedido para substituiÁ„o dos PR ou compensaÁ„o das NCCs
			cSql := "SELECT R_E_C_N_O_ RECE1 "
			cSql += " FROM "+RetSqlName("SE1")
			cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += " E1_TIPO ='NF' AND"
			cSql += " E1_PEDIDO = '"+cPedido+"' AND "
			if lVldSldNF //considera saldo da NF 
				cSql += " E1_SALDO > 0 AND "
			Endif
			cSql += " D_E_L_E_T_ = ' ' "
				
			cTrbSql := GetNextAlias()
			PLSQuery( cSql, CTrbSql )
			
			aSe1NF := {}
			
			While !(cTrbSql)->(Eof())
				AAdd( aSe1Nf, {cPedido,(cTrbSql)->RECE1} )
				(cTrbSql)->(DbSkip())
			End

			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )
			
			If Len(aSe1Nf) > 0
				//verifica se deve substituir as PR e Compensar as NCC
				//User funtion do M460fin
				//aparan[1] Array com Pedido e Recnos do SE1
				//aparan[2] //Valida database para movimenta√ß√£o financeira, default (.f.) Database, Se .T. Ser√° considerada a maior data de emissao para movimenta√ß√£o entre (NF e NCC), (NF e PR) e (NCC e PR)
				//aparan[3] //Valida apenas saldo residual 0,01, defult(.t.)., Se .f. vai compesar todos os valores em aberto para NCC e NF. 
							//Cuidado pois (.f.) impacta diretamente na compara√ß√£o entre o saldo no contas a receber e saldo das contas cont√°beis. Existe risco de Compensa√ß√£o indevida
				//aparan[4] //Ignora parcela e saldo do PR. defult(.t.)., Se .f. for√ßa a subsitui√ß√£o do PR pela NF.
							
				U_VldRecPg( aSe1Nf,lVldData,lVldSldRes,lVldSldNF )		
			Endif

		ElseIF Alltrim( (cTRB)->ARQVTEX ) == 'CHARGEBACK'
			fCompCHA( cPedido, cPedSite, cBandeira )
		EndIF

		Endif
    		
		(cTRB)->( dbSkip() )
	End

	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

	fatConout( "Processo finalizado: " + cProcesso )
Return

/*/{Protheus.doc} FatPltVl
Rotina para ajustar o valor total do pedido no registro da GtLegado para ServiÁo
@author Rafael Beghini       
@since 11/06/2018
/*/
User Function FatPltVl()
    Local aRET   := {}
    Local aPAR   := {}
    Local cWhen1 := "IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '1'"
    Local cWhen2 := "IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '2'"
    Local lProc  := .F.

    Private aPedidos := {}

    aAdd(aPAR,{9,"Selecione a opÁ£Ø, processar pedido ?nico ou por arquivo",200,7,.T.})
    aAdd(aPAR,{3,"Tipo",1,{"Pedido ?nico","Ler arquivo"},50,"",.T.})
    aAdd(aPAR,{1,"Pedido GAR",Space(10),"","","",cWhen1,0,.F.})
    aAdd(aPAR,{6,"Buscar arquivo",Space(80),"","",cWhen2,50,.F.,"Arquivo Texto|*.TXT","C:\temp"})

    IF ParamBox(aPAR,"Ajuste GtLegado...",@aRET)
        lProc := IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '2'
        IF lProc
            Processa({|| aPedidos := A010Txt( aRET ) },"Lendo arquivo Texto...", "Processando aguarde...", .F.)
            Processa({|| A020Proc('2', aPedidos ) },"Ajustando Dados GtLegado", "Processando aguarde...", .F.)
        Else
            Processa({|| A020Proc('1', aPedidos, aRET[ 3 ] ) },"Ajustando Dados GtLegado", "Processando aguarde...", .F.)
        EndIF
        MsgInfo('Processo finalizado, por favor verifique.','[FatPltVl] - Ajuste GtLegado')
    Else
        MsgAlert('Processo cancelado pelo usu·≤©o','[FatPltVl] - Ajuste GtLegado')
    EndIF
Return

/*/{Protheus.doc} A010Txt
LÍ†arquivo TEXTO para o ajuste dos pedidos.
@author Rafael Beghini       
@since 11/06/2018
/*/
Static Function A010Txt( aRET )
    Local cFile := aRET[ 4 ]
    Local aTRB  := {}

    IF !File(cFile)
        MsgAlert("Arquivo texto: "+cFile+" n√£o localizado")
        Return
    Endif

    FT_FUSE(cFile)              //ABRIR
    FT_FGOTOP()                 //PONTO NO TOPO
    ProcRegua(FT_FLASTREC())    //QTOS REGISTROS LER

    While !FT_FEOF()
        IncProc()
        // Capturar dados
        aADD( aTRB , FT_FREADLN() ) //LENDO LINHA 
        FT_FSKIP()   
    EndDo

    FT_FUSE() //fecha o arquivo txt
Return( aTRB )

/*/{Protheus.doc} A020Proc
Processa o ajuste na GtLegado.
@author Rafael Beghini       
@since 11/06/2018
/*/
Static Function A020Proc( cTipo, aDados, cPedGAR )
    Local cSQL  := ''
    Local cTRB  := ''
    Local nLin  := 0

    Default cPedGAR := ''

    A030UseGTL()
    
    IF cTipo == '1' //Pedido ⁄Æico
        ProcRegua( 1 ) 
        cSQL += "SELECT Sum(C6_VALOR) AS VALOR, " + CRLF
        cSQL += "       GT.R_E_C_N_O_ As GT_RECNO " + CRLF
        cSQL += "FROM   GTLEGADO GT " + CRLF
        cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5 " + CRLF
        cSQL += "               ON C5_FILIAL = ' ' " + CRLF
        cSQL += "                  AND C5_NUM = GT_PEDVENDA " + CRLF
        cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
        cSQL += "       INNER JOIN " + RetSqlName('SC6') + " C6 " + CRLF
        cSQL += "               ON C6_FILIAL = C5_FILIAL " + CRLF
        cSQL += "                  AND C6_NUM = GT_PEDVENDA " + CRLF
        cSQL += "                  AND C6.D_E_L_E_T_ = ' ' " + CRLF
        cSQL += "WHERE  GT_TYPE = 'S' " + CRLF
        cSQL += "       AND GT_PEDGAR = '" + cPedGAR + "' " + CRLF
        cSQL += "GROUP  BY GT.R_E_C_N_O_ " + CRLF

        cTRB := GetNextAlias()
	    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

        IF .NOT. (cTRB)->( EOF() )
            IncProc()
            // Posicionar no registro que foi reservado.
            GTLEGADO->( dbGoTo( (cTRB)->GT_RECNO ) )
            GTLEGADO->( RecLock( 'GTLEGADO', .F. ) )
            GTLEGADO->GT_VLRPRD	:= (cTRB)->VALOR
            GTLEGADO->( MsUnLock() )
        EndIF

        (cTRB)->( dbCloseArea() )
	    FErase( cTRB + GetDBExtension() )
    Else
        ProcRegua( Len( aDados ) ) 
        For nLin := 1 To Len( aDados )
            cSQL := "SELECT Sum(C6_VALOR) AS VALOR, " + CRLF
            cSQL += "       GT.R_E_C_N_O_ As GT_RECNO " + CRLF
            cSQL += "FROM   GTLEGADO GT " + CRLF
            cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5 " + CRLF
            cSQL += "               ON C5_FILIAL = ' ' " + CRLF
            cSQL += "                  AND C5_NUM = GT_PEDVENDA " + CRLF
            cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
            cSQL += "       INNER JOIN " + RetSqlName('SC6') + " C6 " + CRLF
            cSQL += "               ON C6_FILIAL = C5_FILIAL " + CRLF
            cSQL += "                  AND C6_NUM = GT_PEDVENDA " + CRLF
            cSQL += "                  AND C6.D_E_L_E_T_ = ' ' " + CRLF
            cSQL += "WHERE  GT_TYPE = 'S' " + CRLF
            cSQL += "       AND GT_PEDGAR = '" + aDados[nLin] + "' " + CRLF
            cSQL += "GROUP  BY GT.R_E_C_N_O_ " + CRLF

            cTRB := GetNextAlias()
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
            IncProc()
            IF .NOT. (cTRB)->( EOF() )
                // Posicionar no registro que foi reservado.
                GTLEGADO->( dbGoTo( (cTRB)->GT_RECNO ) )
                GTLEGADO->( RecLock( 'GTLEGADO', .F. ) )
                GTLEGADO->GT_VLRPRD	:= (cTRB)->VALOR
                GTLEGADO->( MsUnLock() )
            EndIF

            (cTRB)->( dbCloseArea() )
            FErase( cTRB + GetDBExtension() )
        Next nLin
    EndIF
Return

/*/{Protheus.doc} A030UseGTL
Rotina para abrir a tabela GTLOG e seus Ìndices.
@author Rafael Beghini       
@since 11/06/2018
/*/
Static Function A030UseGTL()
	USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela GTLEGADO - SHARED" )
	Endif
	dbSetIndex("GTLEGADO01")
	dbSelectArea("GTLEGADO")
	dbSetOrder(1)
Return

/*/{Protheus.doc} PltPSite
Rotina para Gerar PLT para pedidos GAR vazio
@author Rafael Beghini       
@since 23/08/2018
/*/
User Function PltPSite()
	Local aRET   := {}
    Local aPAR   := {}
	Local cWhen1 := "IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '1'"
    Local cWhen2 := "IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '2'"
	Local cOper  := ''
    Local cProc  := ''
	Local cMsg	 := ''

    Private aPedidos := {}
    
    aAdd(aPAR,{9,"Informe o pedido protheus para gerar a polÌtica",200,7,.T.})
    aAdd(aPAR,{3,"Tipo",1,{"Pedido ?nico","Ler arquivo"},50,"",.T.})
	aAdd(aPAR,{1,"Pedido",Space(06),"","","",cWhen1,0,.F.})
    aAdd(aPAR,{6,"Buscar arquivo",Space(80),"","",cWhen2,80,.F.,"Arquivo Texto|*.TXT","C:\temp"})
	aAdd(aPAR,{3,"OperaÁ„o",1,{"Compensar NF ServiÁo","Gerar polÌtica produto"},100,"",.T.})

    IF ParamBox(aPAR,"CorreÁ„o polÌtica PedGar em branco",@aRET)
		cProc := IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) )
		cOper := IIf( ValType( Mv_par05 ) == 'C', Subs(Mv_par05,1,1), LTrim( Str( Mv_par05, 1, 0 ) ) )
		
		IF cProc == '1' //1.Processar pedido ˙nico 2.Processar arquivo
			//1.Compensar NF ServiÁo†2.Gerar PLT Produto
			IF cOper == '1' 
				FWMsgRun(,{|| U_FatPltGr( aRET[ 3 ] ) },,'Aguarde, compensando a NF de serviÁo..')
				cMsg := 'Processo finalizado com sucesso. ' + CRLF
				cMsg += 'PrÛximo passo È†executar a operaÁ„o de gerar a polÌtica para o pedido [' + aRET[ 3 ] + ']'
				Aviso( 'CorreÁ„o polÌtica PedGar em branco', cMsg, {'Concluir'}, 1 )
			Else
				IF PltValid( aRET[ 3 ] )
					FWMsgRun(,{|| U_CFSA510G( , aRET[ 3 ] ) },,'Aguarde, gerando polÌtica para o pedido informado...')
					cMsg := 'Processo finalizado com sucesso. ' + CRLF
					cMsg += 'Consulte o pedido [' + aRET[ 3 ] + '], e verifique suas informaÁıes.'
				Else
					cMsg := 'N„o foi possÌvel executar.' + CRLF
					cMsg += 'O pedido ainda n„o foi faturado a NF de serviÁo'
				EndIF
				Aviso( 'CorreÁ„o polÌtica PedGar em branco', cMsg, {'Concluir'}, 1 )
			EndIF
		Else
			Processa({|| aPedidos := A010Txt( aRET ) },"Lendo arquivo Texto...", "Processando aguarde...", .F.)
			IF .NOT. Empty( aPedidos )
				PltExec( aPedidos, cOper )
			EndIF
		EndIF
	Else
        MsgAlert('Processo cancelado pelo usu·rio','CorreÁ„o polÌtica PedGar em branco')
    EndIF
Return

/*/{Protheus.doc} PltExec
Apresenta a tela de processamento
@author Rafael Beghini       
@since 23/08/2018
/*/
Static Function PltExec(aPedidos, cModo)
    Local oDlg   := Nil
    Local oSay   := Nil
    Local oMeter := Nil
    Local nMeter := 0
	Local cMsg	 := iIF( cModo == '1', 'Aguarde, compensando a NF de serviÁo', 'Aguarde, gerando a polÌtica' )

    Define Dialog oDlg Title 'CorreÁ„o polÌtica PedGar em branco' From 0,0 To 70,380 Pixel
        @05,05  Say oSay Prompt cMsg Of oDlg Pixel Colors CLR_RED,CLR_WHITE Size 185,20
        @15,05  Meter oMeter Var nMeter Pixel Size 160,10 Of oDlg
        @13,170 BITMAP Resource "PCOIMG32.PNG" SIZE 015,015 OF oDlg NOBORDER PIXEL
    Activate Dialog oDlg Centered On Init ( PltExecA(@cModo, oDlg, oSay, oMeter), oDlg:End() )
    
Return

/*/{Protheus.doc} PltExecA
Tela de progresso do processamento da compensaÁ„o da NF de serviÁo
@author Rafael Beghini       
@since 23/08/2018
/*/
Static Function PltExecA(cModo, oDlg, oSay, oMeter)
	Local nSeconds    := 0
    Local nCount      := 0
    Local nLastUpdate := 0
	Local nLin		  := 0
	Local cMsg		  := iIF( cModo == '1', 'Aguarde, compensando a NF de serviÁo', 'Aguarde, gerando a polÌtica. ' )

	oMeter:SetTotal( Len(aPedidos) )
    nSeconds := Seconds()

	oSay:SetText( cMsg + 'Total de registro(s): ' + AllTrim( Str( Len(aPedidos) ) ) )

	For nLin := 1 To Len( aPedidos )
		nCount++
        IF (Seconds() - nLastUpdate) > 1 // Se passou 1 segundo desde a ?ltima atualizaÁ£Ø da tela
            oMeter:Set(nCount)
            oDlg:CommitControls() // Para atualizar a tela e o usu·≤©o receber o feedback

            nLastUpdate := Seconds()
        EndIf

		//1.Compensar NF ServiÁo†2.Gerar PLT Produto
		IF cModo == '1'
			U_FatPltGr( rTrim(aPedidos[nLin]) )
		Else
			IF PltValid( rTrim(aPedidos[nLin]) )
				U_CFSA510G( , rTrim(aPedidos[nLin]) )
			EndIF
		EndIF

		Sleep(5000)		
	Next nLin
	oMeter:Set(nCount) // Efetua uma atualizaÁ„o final para garantir que o usu·rio veja o resultado do processamento
    oDlg:CommitControls() // Para atualizar a tela e o usu·rio receber o feedback

	IF cModo == '1'
		cMsg := 'Processo finalizado com sucesso. ' + CRLF
		cMsg += 'PrÛximo passo È†executar a operaÁ„o de gerar a polÌtica para o mesmo arquivo lido'
		Aviso( 'CorreÁ„o polÌtica PedGar em branco', cMsg, {'Concluir'}, 1 )
	Else
		cMsg := 'Processo finalizado com sucesso. ' + CRLF
		cMsg += 'Consulte os pedidos do arquivo texto e verifique suas informaÁıes.'
		Aviso( 'CorreÁ„o polÌtica PedGar em branco', cMsg, {'Concluir'}, 1 )
	EndIF
Return

/*/{Protheus.doc} PltValid
Valida se o pedido foi gerado e esta na GTLEGADO
@author Rafael Beghini       
@since 23/08/2018
/*/
Static Function PltValid( cPedido )
	Local cSQL	:= ''
	Local cTRB	:= ''
	Local lOk	:= .F.

	cSQL += "SELECT Count(*) As Count " + CRLF
	cSQL += "FROM   GTLEGADO " + CRLF
	cSQL += "WHERE  GT_TYPE = 'P' " + CRLF
	cSQL += "       AND GT_PEDVENDA = '" + cPedido + "' " + CRLF

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	lOk := (cTRB)->Count > 0

	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return( lOk )

/*/{Protheus.doc} AtuGtLeg
Rotina para Ajustar os dados da GTLegado (Itens)
@author Rafael Beghini       
@since 23/08/2018
/*/
User Function AtuGtLeg()
	Local aRET   := {}
    Local aPAR   := {}
    Local cSQL  := ''
    Local cTRB  := ''

    aAdd(aPAR,{9,"Informe o pedido protheus",200,7,.T.})
    aAdd(aPAR,{1,"Pedido",Space(06),"","","",".T.",0,.T.})
    
    IF ParamBox(aPAR,"Ajuste GTLegado...",@aRET)
		cSQL += "SELECT C5_NUM, C5_EMISSAO, C5_CHVBPAG, C5_XNPSITE, C6_PRODUTO, C6_VALOR  " + CRLF
		cSQL += "FROM   SC5010 C5 " + CRLF
		cSQL += "       INNER JOIN SC6010 C6 " + CRLF
		cSQL += "               ON C6_FILIAL = C5_FILIAL " + CRLF
		cSQL += "                  AND C6_NUM = C5_NUM " + CRLF
		cSQL += "                  AND C6.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "WHERE  C5.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "       AND C5_FILIAL = ' ' " + CRLF
		cSQL += "       AND C5_NUM = '" + aRET[ 2 ] + "' " + CRLF
		
		cTRB := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

		IF .NOT. (cTRB)->( EOF() )
			While .NOT. (cTRB)->( EOF() )
				IF (cTRB)->C6_XOPER $ '51,61'
					fGrvLeg( (cTRB)->C5_NUM, 'S', (cTRB)->C6_PRODUTO,	(cTRB)->C6_VALOR, 0, 0, dDataBase, (cTRB)->C5_EMISSAO, 'NCC', (cTRB)->C5_CHVBPAG, (cTRB)->C5_XNPSITE )
				ElseIF (cTRB)->C6_XOPER $ '52,62'
					fGrvLeg( (cTRB)->C5_NUM, 'P', (cTRB)->C6_PRODUTO,	(cTRB)->C6_VALOR, (cTRB)->C6_VALOR*1.65/100, (cTRB)->C6_VALOR*7.60/100, dDataBase, (cTRB)->C5_EMISSAO, 'NCC', (cTRB)->C5_CHVBPAG, (cTRB)->C5_XNPSITE )
				Endif
				(cTRB)->( dbSkip() )
			End
		EndIF
		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
    Else
        MsgAlert('Processo cancelado pelo usu·rio','[AtuGtLeg] - Ajuste GTLegado')
    EndIF
Return

/*/{Protheus.doc} FcompPLT
Rotina para compensar pedidos pendentes que tiveram PolÌtica
@author Rafael Beghini       
@since 08/10/2018
/*/
User Function FcompPLT()

	Local cPedido   := nil    
	Local lVldSldNF := nil
	Local lVldSldRes:= nil
	Local lJob		:= (Select('SX6')==0)
	Local nx
	Local cPedErp   := ""
	Local cWhere    := "% %"

	Default dEmisDe := StoD('20200101')  //StoD('20150101')

	fatConout("PREPARA«√O EXECU«√O FCOMPPLT")
	IF lJob
		RpcSetType( 3 )
		RpcSetEnv( '01', '02' )
	EndIf

	if !empty(cPedErp)
	   cWhere := "%AND C5_NUM = '"+cPedErp+"'%"
	endif
	dEmisDe := StoD(GetMV( "MV_XCORPLT",, DtoS(dEmisDe) ) ) // CORTE DA SUB
	fatConout( "INICIO EXECU«√O FCOMPPLT - EMISS√O PEDIDO A PARTIR DE "+DtoC(dEmisDe) )
	
	BeginSql Alias "FCOMPPLT"
		SELECT ((TOTPED-VALOR_NF)-(SALDO_PR+SALDO_NCC)) AS DIF, BASE.*
		FROM
		(
		SELECT
			C5_NUM PEDIDO,
			C5_EMISSAO EMISSAO_PED,
			C5_XNPSITE CODSITE,
			C5_CHVBPAG CODGAR,
			//nvl((SELECT MAX (SZ5.Z5_DATVAL) FROM %Table:SZ5% SZ5 WHERE Z5_FILIAL=%xFilial:SZ5% AND Z5_PEDGAR=C5_CHVBPAG AND C5_CHVBPAG>' '  AND SZ5.D_E_L_E_T_=' '),' ')  AS DATVAL,
			//nvl((SELECT MAX (SZ5.Z5_DATEMIS) FROM %Table:SZ5% SZ5 WHERE Z5_FILIAL=%xFilial:SZ5% AND Z5_PEDGAR=C5_CHVBPAG AND C5_CHVBPAG>' ' AND SZ5.D_E_L_E_T_=' '),' ')  AS DATEMIS,
			C5_TIPMOV TIPMOV,
			C5_TIPVOU TIPVOU,
			C5_XNATURE NATUREZA,
			//nvl((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR'),' ')  AS EMIS_PR,
			//nvl((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC' AND SE1.E1_PREFIXO IN ('RCP','VDI','RCO')),' ') AS EMIS_NCC,  
			//nvl((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NF'),' ')  AS EMIS_NF,  
			nvl((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR'),0)  AS VALOR_PR,
			nvl((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC' AND SE1.E1_PREFIXO IN ('RCP','VDI','RCO')),0) AS VALOR_NCC,
			nvl((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NF'),0)  AS VALOR_NF,
			nvl((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR'),0) AS SALDO_PR,
			nvl((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC' AND SE1.E1_PREFIXO IN ('RCP','VDI','RCO')),0) AS SALDO_NCC,
			nvl((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NF'),0)  AS SALDO_NF,
			C5_XCARTAO CARTAO,
			C5_XCODAUT CODAUT,
			C5_XDOCUME DOCUMENTO,
			C5_XNPARCE PARCELA,
			C5_XLINDIG LINHA_DIG,
			C5_XNUMVOU NUMVOU,
			C5_XRECPG RECIBO,
			C5_XNFHRD NF_HRD,
			C5_XNFSFW NF_SFW,
			C5_TOTPED TOTPED, 
			C5_NOTA   NOTA   
		FROM
			%Table:SC5% SC5
		WHERE
			C5_FILIAL = %xFilial:SC5% 
			AND C5_EMISSAO >= %Exp:DtoS(dEmisDe)%
			AND C5_XNPSITE > ' ' 
			AND SC5.D_E_L_E_T_ = ' '
			AND SC5.C5_XMENSUG = '024'
			%Exp:cWhere%
		) BASE 
		
		WHERE 

			(BASE.DOCUMENTO=' ' AND
			(
				VALOR_PR>0 //--N√ÉO PODERIA EXISTIR PR PARA BOLETO OU VENDA SEM DOCUMENTO DE AUTORIZA√á√ÉO 
				OR
				(
				(VALOR_NF=VALOR_NCC) AND ( SALDO_NF>0 OR SALDO_NCC>0 )// --FALTA COMPENSA√á√ÉO
				)
				OR 
				(
				( ((TOTPED-VALOR_NF)-(SALDO_NCC))<>0 )  AND          (SALDO_NF>0   AND   SALDO_NCC>0) //-- FATURADO E N√ÉO RECEBIDO
				)
			)
			)
			OR 
			(BASE.DOCUMENTO>' ' AND
			(  //--Baixados indevidamente
				// (   Tem VL de Pr = Nf  AND    Vl de NF = NCC     )  AND  (     Tem saldo NF ou PR ou NCC           ) 
				(
				(   VALOR_PR=VALOR_NF  AND VALOR_NF = VALOR_NCC  )  AND  ( SALDO_NF>0 OR SALDO_PR>0 OR SALDO_NCC>0 )
				)
				OR 
				//--N√£o compensados
				//  ((Saldo a faturar )-(saldo a compensar/subistituir))<>0) AND (somente para NF com saldo>0) AND (existe saldo a compensar/substituir)
				(
				( ((TOTPED-VALOR_NF )-(     SALDO_PR+SALDO_NCC      ))<>0) AND          (SALDO_NF>0)         AND       (SALDO_PR>0 OR SALDO_NCC>0)
				)
			)
			)			

	EndSql

	While FCOMPPLT->( !Eof() )   
		cPedido := FCOMPPLT->PEDIDO
		lVldData := .F. //.T.                                                                                                  
		/*
		//Se o VALOR Total da NF √© Igual ao VALOR Total da NCC OU diferen√ßa entre OS VALORES √© menor igual a 0.02 OU a ddiferen√ßa entre OS SALDOS √© menor igual a 0.02, 
		//Ent√£o for√ßa a compensa√ß√£o dos SALDOS em aberto independente do valor do saldo das parcelas
		//Sen√£o for√ßa a compensa√ßao somente de saldos res√≠duais < 0.02 de parcelas
		lVldSldRes:= iif( FCOMPPLT->VALOR_NF==FCOMPPLT->VALOR_NCC .or. ;
						(FCOMPPLT->SALDO_NF-FCOMPPLT->SALDO_NCC>=-0.02 .AND. FCOMPPLT->SALDO_NF-FCOMPPLT->SALDO_NCC<=0.02) .or.;
						(FCOMPPLT->VALOR_NF-FCOMPPLT->VALOR_NCC>=-0.02 .AND. FCOMPPLT->VALOR_NF-FCOMPPLT->VALOR_NCC<=0.02) .OR.;  ,.f.,.t.) 
		*/
		lVldSldRes := .F. //se est√° no select √© porque existe um erro ou falta compesa√ß√£o. Ent√£o For√ßa a compensa√ß√£o independente de saldo ou parcela	                                                                                                                             
		lVldSldNF := iif(	FCOMPPLT->SALDO_PR>0 .and.(FCOMPPLT->VALOR_NF-FCOMPPLT->VALOR_PR>=-0.02 .AND. FCOMPPLT->VALOR_NF-FCOMPPLT->VALOR_PR<=0.02),.F.,.T.)//Se saldo do PR maior que Zero, Ignora Saldo da NF. Considera o Valor o que ir√° for√ßar a substitui√ß√£o do PR pela NF
		
		//VERIFICA NECESSIDADE DE PROCURA DE BAIXAS INDEVIDAS POR CANCELAMENTO
		cSql := "		SELECT SE1.R_E_C_N_O_ RECE1, SE5.R_E_C_N_O_ RECE5 , SE5.E5_SEQ SEQ"
		cSql += "		FROM "+RetSqlName("SE5")+ " SE5 
		
		cSql += "	         LEFT JOIN "+RetSqlName("SE5")+ " ESTORNO ON "
		cSql += "	         ESTORNO.E5_FILIAL='"+xFilial("SE5")+"' AND  "
		cSql += "	         ESTORNO.E5_DATA>='"+DtoS(dEmisDe)+"'  AND "
		cSql += "	         ESTORNO.D_E_L_E_T_=' ' AND "
		cSql += "	         ESTORNO.E5_MOTBX='CAN' AND "
		cSql += "	         ESTORNO.E5_FILIAL=SE5.E5_FILIAL AND "
		cSql += "	         ESTORNO.E5_PREFIXO=SE5.E5_PREFIXO AND "
		cSql += "	         ESTORNO.E5_NUMERO= SE5.E5_NUMERO AND "
		cSql += "	         ESTORNO.E5_PARCELA=SE5.E5_PARCELA AND "
		cSql += "	         ESTORNO.E5_TIPO=SE5.E5_TIPO AND "
		cSql += "	         ESTORNO.E5_CLIFOR=SE5.E5_CLIFOR AND "
		cSql += "	         ESTORNO.E5_LOJA=SE5.E5_LOJA AND "
		cSql += "	         ESTORNO.E5_SEQ=SE5.E5_SEQ AND "
		cSql += "	         ESTORNO.E5_TIPODOC='ES', "

		cSql += "	    	 "+RetSqlName("SE1") +" SE1  "
		cSql += "		WHERE "
		cSql += "		SE5.E5_FILIAL='"+xFilial("SE5")+"' "
		cSql += "		AND SE5.E5_DATA>='"+DtoS(dEmisDe)+"' "
		cSql += "		AND SE5.D_E_L_E_T_=' ' "
		cSql += "		AND SE5.E5_SITUACA=' ' "
		cSql += "		AND SE5.E5_MOTBX='CAN' AND SE5.E5_HISTOR =SE5.E5_PREFIXO||SE5.E5_NUMERO||SE5.E5_PARCELA||SE5.E5_TIPO||'CAN' "  
		cSql += "		AND SE1.E1_FILIAL='"+xFilial("SE1")+"' "
		cSql += "		AND SE1.E1_PREFIXO=SE5.E5_PREFIXO "
		cSql += "		AND SE1.E1_NUM=SE5.E5_NUMERO "
		cSql += "		AND SE1.E1_PARCELA=SE5.E5_PARCELA "
		cSql += "		AND SE1.E1_TIPO=SE5.E5_TIPO "
		cSql += "		AND SE1.E1_CLIENTE=SE5.E5_CLIFOR "
		cSql += "		AND SE1.E1_LOJA=SE5.E5_LOJA "
		cSql += "		AND SE1.E1_PEDIDO='"+cPedido+"' "
		cSql += "		AND SE1.D_E_L_E_T_=' ' "
		cSql += "		AND ESTORNO.E5_DATA IS NULL "

		cTrbSql:=GetNextAlias()
		PLSQuery( cSql, CTrbSql )
		
		aSe1CAN:={}
		
		While !(cTrbSql)->(Eof())
			AAdd( aSe1CAN, {(cTrbSql)->RECE1,(cTrbSql)->RECE5,(cTrbSql)->SEQ} )
			(cTrbSql)->(DbSkip())
		End

		(cTrbSql)->(DbCloseArea())
		
		If Len(aSe1CAN)>0
			
			For nx:=1 to len(aSe1CAN)
			
				cEstorno:=aSe1CAN[ nX, 3 ]
				
				//VERIFICA SE CANCELAMENTO FOI CONTABILIZADO
				DbSelectArea("SE5")
				SE5->( dbGoTo( aSe1CAN[ nX, 2 ]) )
				
				//Atualiza campo de controle de contabiliza√ß√£o para que no estorno seja criado um novo registro no E5. 
				//Por padr√£o este campo fica fazio se o motivo o baixa for n√£o gerar movimento banc√°rio. Porem, para efeito de posi√ß√£o de 
				//t√≠tulos a receber se faz necess√°rio conhecer a data da baixa e a data de cancelamento da baixa. 

				Reclock("SE5",.F.)
				SE5->E5_LOTE:='8850'
				MSUNLOCK()
				
				//Estorna a baixa do t√≠tulo
				//Manter SE1 POSICIONADO
				DbSelectArea("SE1")
				SE1->( dbGoTo( aSe1CAN[ nX, 1 ]) )
				
				
				FaBaixaCR(	{0,0,0}, {},.F.,.F., .F.,cEstorno,.F.)
			
				SE5->(MSUNLOCK())
				SE1->(MSUNLOCK())
				SA1->(MSUNLOCK())  
				
				cEstorno:=NIL
				
				IF SE1->E1_TIPO<>'NCC'
					lVldData:=.f. //Deve usar a data base para compensa√ß√£o
				Endif    
				
			Next		                                                      
			
		Endif	 
		
		// Localiza as NFs do pedido para Substitui√ß√£o dos PR ou Compensa√ß√£o das NCCs
		cSql := "SELECT R_E_C_N_O_ RECE1 "
		cSql += " FROM "+RetSqlName("SE1")
		cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
		cSql += " E1_TIPO ='NF' AND"
		cSql += " E1_PEDIDO = '"+cPedido+"' AND "
		if lVldSldNF //considera saldo da NF 
			cSql += " E1_SALDO > 0 AND "
		Endif
		cSql += " D_E_L_E_T_ = ' ' "
			
		cTrbSql:=GetNextAlias()
		PLSQuery( cSql, CTrbSql )
		
		aSe1NF:={}
		
		While !(cTrbSql)->(Eof())
			AAdd( aSe1Nf, {cPedido,(cTrbSql)->RECE1} )
			(cTrbSql)->(DbSkip())
		End

		(cTrbSql)->(DbCloseArea())
		
		If Len(aSe1Nf)>0

			//verifica se deve substituir as PR e Compensar as NCC
			//User funtion do M460fin
			//aparan[1] Array com Pedido e Recnos do SE1
			//aparan[2] //Valida database para movimenta√ß√£o financeira, default (.f.) Database, Se .T. Ser√° considerada a maior data de emissao para movimenta√ß√£o entre (NF e NCC), (NF e PR) e (NCC e PR)
			//aparan[3] //Valida apenas saldo residual 0,01, defult(.t.)., Se .f. vai compesar todos os valores em aberto para NCC e NF. 
						//Cuidado pois (.f.) impacta diretamente na compara√ß√£o entre o saldo no contas a receber e saldo das contas cont√°beis. Existe risco de Compensa√ß√£o indevida
			//aparan[4] //Ignora parcela e saldo do PR. defult(.t.)., Se .f. for√ßa a subsitui√ß√£o do PR pela NF.
						
			U_VldRecPg( aSe1Nf,lVldData,lVldSldRes,lVldSldNF )
	
		Endif
				
		FCOMPPLT->( dbSkip() )
	EndDo

	fatConout("FIM EXECU«√O FCOMPPLT")

Return

/*/{Protheus.doc} FatRecPa
Rotina para reenvio do recibo de pagamento.
@author Rafael Beghini       
@since 13/12/2018
/*/
User Function FatRecPa(aParam)
	Local lJob 			:= ( Select( "SX6" ) == 0 )
	Local cJobEmp		:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil		:= Iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local cSQL			:= ''
	Local cTRB			:= ''
	Local dDataIni		:= CTOD('//')
	Local dDataFim		:= CTOD('//')
	Local nThread		:= 0
	Local nTotThread 	:= 0
	Local aUsers		:= {}
	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	dDataIni := Date() - GetMV('MV_GERECPG',.F.)
	dDataFim := Date()

	cSQL += "SELECT C5.R_E_C_N_O_ RECNO " + CRLF
	cSQL += "FROM   " + RetSqlName('SE1') + " E1 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5 " + CRLF
	cSQL += "               ON C5_FILIAL = E1_FILIAL " + CRLF
	cSQL += "                  AND C5_NUM = E1_PEDIDO " + CRLF
	cSQL += "                  AND C5_XRECPG = ' ' " + CRLF
	cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  E1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND E1_FILIAL = ' ' " + CRLF
	cSQL += "       AND E1_PREFIXO = 'RCP' " + CRLF
	cSQL += "       AND E1_TIPO = 'NCC' " + CRLF
	cSQL += "       AND E1_EMISSAO >= '" + DtoS(dDataIni) + "' " + CRLF
	cSQL += "       AND E1_EMISSAO <= '" + DtoS(dDataFim) + "' " + CRLF

	fatConout( "[xGerRecp] - Inicio query" )
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	fatConout( "[xGerRecp] - Processou query " )
	While .NOT. (cTRB)->( EOF() )
		SC5->( dbGoto( (cTRB)->RECNO ) )
		nTotThread += 1
		//U_X410PAG( 'SC5', SC5->( Recno() ), 2, 'JOB - Reenvio de recibo e notificaÁ„o de pagamento' )
		
		//Faz distribui√ß√£o e monitora a quantidade de thread em execu√ß√£o
		nThread := 0
		aUsers 	:= Getuserinfoarray()
		aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatPE" .OR.ALLTRIM(UPPER(x[5])) == "PRC" .OR.;
							ALLTRIM(UPPER(x[5])) == "U_X410PAG",nThread++,nil )  })
	
		If nThread <= 10
			StartJob("U_X410PAG",GetEnvServer(),.F.,'SC5', SC5->( Recno() ), 2, 'JOB - Reenvio de recibo e notificaÁ„o de pagamento')
		Else
			While nThread>10
				SLEEP(6000)      
				nThread := 0
				aUsers 	:= Getuserinfoarray()
				aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA190P".OR.ALLTRIM(UPPER(x[5])) == "U_CerFatPE" .OR.ALLTRIM(UPPER(x[5])) == "PRC" .OR.;
							ALLTRIM(UPPER(x[5])) == "U_X410PAG",nThread++,nil )  })
			EndDo           
		EndIf

		If nTotThread > 10                           
			DelClassIntf()
			nTotThread := 0
		EndIf
		
		(cTRB)->( dbSkip() )
    End

    (cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return

/*/{Protheus.doc} fCompCHA
Realiza a compensaÁ„o da PRR e baixa da NCC para casos que n„o foi gerado a NF
@author Rafael Beghini       
@since 13/12/2018
/*/
Static Function fCompCHA( cPedido, cPedSite, cBandeira )
	Local cBco			:= ""
	Local cAge			:= ""
	Local cCta			:= ""
	Local cSql			:= ""
	Local cTrbSql		:= ""
	Local aSe1PR		:= {}
	Local aSe1NF		:= {}
	Local aBaixa		:= {}
	Local aFaVlAtuCR	:= {}
	Local aSE1Dados		:= {}
	Local aParam		:= {}
	Local aSe1BxNccCha	:= {}
	Local aRet			:= {}
	Local nI			:= 0
	Local nD			:= 0

	//Trata todas as pendÍncias do Pedido
	//ForÁa primeiro o tratamento do PR
	//Identifica as parcelas DE PR em aberto para SubsituiÁ„o
	//O PR ser· substituÌdo pela NCC
	
	cSql := "SELECT R_E_C_N_O_ RECE1 "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO='PR' AND"
	cSql += " E1_SALDO > 0 AND "
	cSql += " D_E_L_E_T_ = ' ' "
	
	cTrbSql := GetNextAlias()
	PLSQuery( cSql, cTrbSql )
	
	While !(cTrbSql)->(Eof())
		AAdd( aSe1PR, (cTrbSql)->RECE1 )
		(cTrbSql)->(DbSkip())
	EndDo
	
	(cTrbSql)->(DbCloseArea())
	
	If len(aSe1PR)>0//Baixa provisÛrio correspondente  a parcela
		For nI:=1 to len(aSe1PR)
			
			SE1->( dbGoTo( aSe1PR[nI] ) )
			
			cBco := ' ' //PadR("000",TamSx3("E8_BANCO")[1])
			cAge := ' ' //PadR("00000",TamSx3("E8_AGENCIA")[1])
			cCta := ' ' //PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])
			
			aBaixa := {}
			aBaixa := { "SUB", SE1->E1_SALDO, cBco,cAge,cCta, dDataBase, dDataBase }
			
			aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
			
			aSE1Dados := {}
			
			AAdd( aSE1Dados, { aSe1PR[nI], "Bx "+PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD','')),TamSx3("E8_CONTA")[1])+" PSite.: " + cPedSite, AClone( aFaVlAtuCR ) } )
			aRet := {}
			aRet := U_CSFA530( 1, {aSe1PR[nI]}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
			SE5->(MSUNLOCK())
			SE1->(MSUNLOCK())
			SA1->(MSUNLOCK())			
		Next
	Endif

	//Identifica existencia de PR. Se existir PR com Saldo ent„o n„o pode baixar a NCC por CHA
	cSql := ""
	cSql += "SELECT E1_TIPO, R_E_C_N_O_ RECE1 "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO ='PR' AND "
	cSql += " E1_SALDO > 0 AND "
	cSql += " D_E_L_E_T_ = ' ' "
	
	cTrbSql:=GetNextAlias()
	PLSQuery( cSql, cTrbSql )
	
	aSe1PR	:= {}	
	While !(cTrbSql)->(Eof())
		AAdd( aSe1PR,{cPedido, (cTrbSql)->RECE1} )
		(cTrbSql)->(DbSkip())
	EndDo
	
	(cTrbSql)->(DbCloseArea())
	
	If Len(aSe1PR)==0
		//Identifica as NCC com Saldo para Baixa por Charge
		cSql := ""
		cSql += "SELECT R_E_C_N_O_ RECE1 "
		cSql += " FROM "+RetSqlName("SE1")
		cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
		cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO='NCC'"
		cSql += " AND E1_SALDO > 0 AND "
		cSql += " D_E_L_E_T_ = ' ' "
		
		cTrbSql := GetNextAlias()
		PLSQuery( cSql, cTrbSql )
		
		While !(cTrbSql)->(Eof())
			AAdd( aSe1BxNccCha, (cTrbSql)->RECE1 )
			(cTrbSql)->(DbSkip())
		End
		
		(cTrbSql)->(DbCloseArea())
		
		If len(aSe1BxNccCha)>0//Baixa NCC por ChargeBack correspondente a parcela

			//Se existir NF com Saldo ent„o compensar com NCC por CHA. Permanecendo saldo no NCC baixar com CHA
			//Se n„o existir NF com Saldo ent„o baixar NCC por CHA.
			cSql := ""
			cSql += "SELECT E1_TIPO, R_E_C_N_O_ RECE1 "
			cSql += " FROM "+RetSqlName("SE1")
			cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO ='NF' AND "
			cSql += " E1_SALDO > 0 AND "
			cSql += " D_E_L_E_T_ = ' ' "
			
			cTrbSql:=GetNextAlias()
			PLSQuery( cSql, cTrbSql )
			
			While !(cTrbSql)->(Eof())
				AAdd( aSe1NF, (cTrbSql)->RECE1 )
				(cTrbSql)->(DbSkip())
			EndDo
			
			(cTrbSql)->(DbCloseArea())

			if len(aSe1NF) == 0
			
				For nI:=1 to len(aSe1BxNccCha)
					SE1->( dbGoTo( aSe1BxNccCha[nI] ) )
					
					cBco := ' '//PadR("000",TamSx3("E8_BANCO")[1])
					cAge := ' '//PadR("00000",TamSx3("E8_AGENCIA")[1])
					cCta := ' '//PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])
					
					aBaixa := {}
					aBaixa := { "CHA", SE1->E1_SALDO, cBco,cAge,cCta, dDataBase, dDataBase }
					
					aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
					
					aSE1Dados := {}
					
					AAdd( aSE1Dados, { aSe1BxNccCha[nI], "ChargeBack "+PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD','')),TamSx3("E8_CONTA")[1])+" PSite.: " + cPedSite, AClone( aFaVlAtuCR ) } )
					
					
					aRet := U_CSFA530( 1, {aSe1BxNccCha[nI]}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
					SE5->(MSUNLOCK())
					SE1->(MSUNLOCK())
					SA1->(MSUNLOCK())				
				Next

			else

				lVldData := .f.
			    dDataAnt := dDataBase
				aParam := {.F.,.F.,.F.,.F.,.F.,.F.}
				For nI:=1 to Len(aSe1NF)
				    SE1->( dbGoTo( aSe1NF[ nI ] ) )
				    ddataNF :=SE1->E1_EMISSAO
					For nD:=1 to Len(aSe1BxNccCha)
						SE1->( dbGoTo( aSe1BxNccCha[ nD ] ) )
						dDataRF	:=SE1->E1_EMISSAO
						if lVldData
							dDataBase:=iif( dtos(ddataNF)>dtoS(dDataRF) , dDataNF , DdataRF )
						Endif
						aRet := U_CSFA530( 3, { aSe1NF[ nI ] }, /*aBaixa*/, {aSe1BxNccCha[ nD ]}, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, /*aDadosBaixa*/, /*aNewSE1*/ )
						SE5->(MSUNLOCK())
						SE1->(MSUNLOCK())
						SA1->(MSUNLOCK())             
					Next nD
				Next nI
				dDataBase := dDataAnt

				aSe1BxNccCha := {}

				cSql := ""
				cSql += "SELECT R_E_C_N_O_ RECE1 "
				cSql += " FROM "+RetSqlName("SE1")
				cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
				cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO='NCC'"
				cSql += " AND E1_SALDO > 0 AND "
				cSql += " D_E_L_E_T_ = ' ' "
				
				cTrbSql := GetNextAlias()
				PLSQuery( cSql, cTrbSql )
				
				While !(cTrbSql)->(Eof())
					AAdd( aSe1BxNccCha, (cTrbSql)->RECE1 )
					(cTrbSql)->(DbSkip())
				End
				
				(cTrbSql)->(DbCloseArea())

				If len(aSe1BxNccCha)>0//Baixa NCC por ChargeBack correspondente a parcela

					For nI:=1 to len(aSe1BxNccCha)
						SE1->( dbGoTo( aSe1BxNccCha[nI] ) )
						
						cBco := ' '//PadR("000",TamSx3("E8_BANCO")[1])
						cAge := ' '//PadR("00000",TamSx3("E8_AGENCIA")[1])
						cCta := ' '//PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])
						
						aBaixa := {}
						aBaixa := { "CHA", SE1->E1_SALDO, cBco,cAge,cCta, dDataBase, dDataBase }
						
						aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
						
						aSE1Dados := {}
						
						AAdd( aSE1Dados, { aSe1BxNccCha[nI], "ChargeBack "+PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD','')),TamSx3("E8_CONTA")[1])+" PSite.: " + cPedSite, AClone( aFaVlAtuCR ) } )
						
						aRet := U_CSFA530( 1, {aSe1BxNccCha[nI]}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
						SE5->(MSUNLOCK())
						SE1->(MSUNLOCK())
						SA1->(MSUNLOCK())				
					Next

				endif

			endif
		Endif
	Endif
Return

/*/{Protheus.doc} getQSit110
Registros para eliminar resÌduos de pedidos que tem movimentaÁ„o de voucher e que o voucher n„o È do tipo F - VERIFICA«√O (Z5_DATVER)
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit110( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif
	
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 1.1.0                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registros para eliminar resÌduos de pedidos que tem movimentaÁ„o de voucher e que o voucher n„o È do tipo F - VERIFICA«√O (Z5_DATVER)      |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	cSQL := "SELECT /*+ PARALLEL(5) */" + CRLF
	cSQL += "	   '1.1'          SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > '  ' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_TIPVOU <> 'F' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NOT NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit120
Registros para eliminar resÌduos de pedidos que tem movimentaÁ„o de voucher e que o voucher n„o È do tipo F - EMISS√O (Z5_DATEMIS)
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit120( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 1.2.0                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros para eliminar resÌduos de pedidos que tem movimentaÁ„o de voucher e que o voucher n„o È do tipo F - EMISS√O (Z5_DATEMIS)         |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	cSQL := "SELECT /*+ PARALLEL(5) */" + CRLF
	cSQL += "       '1.2'          SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > '  ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL  " + CRLF
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > '  ' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_TIPVOU <> 'F' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NOT NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit211
Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - VERIFICA«√O (Z5_DATVER) ZG para C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit211( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 2.1.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - VERIFICA«√O (Z5_DATVER) ZG para C6                       |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */" + CRLF
	cSQL += "       '2.1.1'          SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '62' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit212
Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - EMISSAO (Z5_DATEMIS) ZG para C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit212( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 2.1.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - EMISSAO (Z5_DATEMIS) ZG para C6                          |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	cSQL := "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'2.1.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '62' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit221
Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - VERIFICAO (Z5_DATVER) ZG para C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit221( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 2.2.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - VERIFICAO (Z5_DATVER) ZG para C5                         |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'2.2.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > '  ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND C5_CHVBPAG = Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON C6_FILIAL = C5_FILIAL " + CRLF
	cSQL += "                  AND C6_NUM = C5_NUM " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "WHERE  Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '62' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit222
Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - EMISS√O (Z5_DATEMIS) ZG para C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit222( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 2.2.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operacao 62 validos e/ou verificados e/ou emitidos e n„o faturados - EMISS√O (Z5_DATEMIS) ZG para C5                          |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ""
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'2.2.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > '  ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON C5_CHVBPAG = Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '62' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit310
Registros de operaÁ„o 61 com certificados emitidos e n„o faturados - EMISS√O (Z5_DATEMIS) ZG para C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit310( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 3.1.0                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 61 com certificados emitidos e n„o faturados - EMISS√O (Z5_DATEMIS) ZG para C6                                       |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'3.1'          SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '61' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit320
Registros de operaÁ„o 61 com certificados emitidos e n„o faturados - EMISS√O (Z5_DATEMIS) ZG para C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit320( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 3.2.0                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 61 com certificados emitidos e n„o faturados - EMISS√O (Z5_DATEMIS) ZG para C5                                       |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'3.2'          SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '61' " + CRLF
	cSQL += "       AND SZG.ZG_NUMVOUC IS NULL" + CRLF
return cSQL

/*/{Protheus.doc} getQSit411
Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
VERIFICA«√O (Z5_DATVER) ZG PARA C6 PARA C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit411( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.1.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| VERIFICA«√O (Z5_DATVER) ZG PARA C6 PARA C5                                                                                                 |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.1.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '52' " + CRLF
return cSQL

/*/{Protheus.doc} getQSit412
Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
EMISS√O (Z5_DATEMIS) ZG PARA C6 PARA C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit412( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.1.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| EMISS√O (Z5_DATEMIS) ZG PARA C6 PARA C5                                                                                                    |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+

	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.1.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '52'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit421
Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
VERIFICA«√O (Z5_DATVER) ZG PARA C6 PARA C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit421( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.2.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| VERIFICA«√O (Z5_DATVER) ZG PARA C6 PARA C5                                                                                                 |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
		
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.2.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '53'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit422
Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
EMISS√O (Z5_DATEMIS) ZG PARA C6 PARA C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit422( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.2.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| EMISS√O (Z5_DATEMIS) ZG PARA C6 PARA C5                                                                                                    |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.2.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '53'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit431
Registros de operaÁ„o 51 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
EMISS√O (Z5_DATEMIS) ZG PARA C6 PARA C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit431( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.3.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 51 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| EMISS√O (Z5_DATEMIS) ZG PARA C6 PARA C5                                                                                                    |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.3.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit441
Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
VERIFICA«√O (Z5_DATVER) ZG PARA C5 PARA C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit441( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.4.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| VERIFICA«√O (Z5_DATVER) ZG PARA C5 PARA C6                                                                                                 |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
		
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.4.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '52'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit442
Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
EMISS√O (Z5_DATEMIS) ZG PARA C5 PARA C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit442( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.4.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 52 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          | 
	//| EMISS√O (Z5_DATEMIS) ZG PARA C5 PARA C6                                                                                                    |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.4.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '52'" + CRLF
return cSQL


/*/{Protheus.doc} getQSit451
Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
VERIFICA«√O (Z5_DATVER) ZG PARA C5 PARA C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit451( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.5.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| VERIFICA«√O (Z5_DATVER) ZG PARA C5 PARA C6                                                                                                 |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
		
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.5.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '53'" + CRLF
return cSQL


/*/{Protheus.doc} getQSit452
Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
EMISS√O (Z5_DATEMIS) ZG PARA C5 PARA C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit452( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.5.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registros de operaÁ„o 53 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| EMISS√O (Z5_DATEMIS) ZG PARA C5 PARA C6                                                                                                    |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
		
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.5.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '53'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit461
Registros de operaÁ„o 51 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
EMISS√O (Z5_DATEMIS) C5 PARA C6  E DA Z5 PARA ZG
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit461( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.6.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registros de operaÁ„o 51 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| EMISS√O (Z5_DATEMIS) C5 PARA C6  E DA Z5 PARA ZG                                                                                           | 
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	 
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.6.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG = Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit462
Registros de operaÁ„o 51 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)
EMISS√O (Z5_DATEMIS) C6 PARA C5  E DA Z5 PARA ZG
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit462( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 4.6.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registros de operaÁ„o 51 (validos ou emitidos) e n„o faturados (geralmente com voucher do tipo F)                                          |
	//| EMISS√O (Z5_DATEMIS) C6 PARA C5  E DA Z5 PARA ZG                                                                                           |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	 
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'4.6.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_NUMVOUC  CODVOUCHER, " + CRLF
	cSQL += "       SZG.ZG_CODFLU  CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND SC6.C6_BLQ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_NOTA = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "              ON SZG.ZG_NUMPED = SZ5.Z5_PEDGAR " + CRLF
	cSQL += "                 AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                 AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                 AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER = '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit511
Registro de voucher com PEDIDOS DE ORIGEM n„o faturados (geralmente tipos 'A', 'H', '2')
DIFERENTE DE OPERA«’ES DE SERVI«O (61 e 62) ZF para C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit511( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 5.1.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registro de voucher com PEDIDOS DE ORIGEM n„o faturados (geralmente tipos 'A', 'H', '2')                                                   |
	//| DIFERENTE DE OPERA«’ES DE SERVI«O (61 e 62) ZF para C6                                                                                     |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
		
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'5.1.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDIDO > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = SZF.ZF_PEDIDO " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' '" + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '61' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit512
Registro de voucher com PEDIDOS DE ORIGEM n„o faturados (geralmente tipos 'A', 'H', '2')
TOD  OPERA«’ES PENDENTES COM Z5_EMISS√O - DE ZF PARA C6
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit512( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 5.1.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registro de voucher com PEDIDOS DE ORIGEM n„o faturados (geralmente tipos 'A', 'H', '2')                                                   |
	//| TOD  OPERA«’ES PENDENTES COM Z5_EMISS√O - DE ZF PARA C6                                                                                    |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'5.1.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDIDO > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_PEDGAR = SZF.ZF_PEDIDO " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR > ' '" + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
return cSQL

/*/{Protheus.doc} getQSit521
Registro de voucher com pedidos de origem n„o faturados (geralmente tipos 'A', 'H', '2')
DIFERENTE DE OPERA«’ES DE SERVI«O ZF para C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit521( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 5.2.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registro de voucher com pedidos de origem n„o faturados (geralmente tipos 'A', 'H', '2')                                                   |
	//| DIFERENTE DE OPERA«’ES DE SERVI«O ZF para C5                                                                                               |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'5.2.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDIDO > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_CHVBPAG = SZF.ZF_PEDIDO " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' ' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '61' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit522
Registro de voucher com pedidos de origem n„o faturados (geralmente tipos 'A', 'H', '2')
Tod  operaÁıes pendentes com Z5_DATEMISS  DA ZF PARA C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit522( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 5.2.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registro de voucher com pedidos de origem n„o faturados (geralmente tipos 'A', 'H', '2')                                                   |
	//| Tod  operaÁıes pendentes com Z5_DATEMISS  DA ZF PARA C5                                                                                    |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'5.2.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDIDO > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_CHVBPAG = SZF.ZF_PEDIDO " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_CHVBPAG > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
return cSQL

/*/{Protheus.doc} getQSit611
Registro de voucher com pedidos SITE n„o faturados (geralmente tipos 'A', 'H', '2')
VERIFICA«√O Diferente d operaÁıes de serviÁo DA ZF PARA C5
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit611( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 6.1.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registro de voucher com pedidos SITE n„o faturados (geralmente tipos 'A', 'H', '2')                                                        |
	//| VERIFICA«√O Diferente d operaÁıes de serviÁo DA ZF PARA C5                                                                                 |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'6.1.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDSITE > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_XNPSITE = SZF.ZF_PEDSITE " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_XNPSITE > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' '" + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '61' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '51' " + CRLF
return cSQL

/*/{Protheus.doc} getQSit612
Registro de voucher com pedidos SITE n„o faturados (geralmente tipos 'A', 'H', '2')
EMISS√O Diferente d operaÁıes de serviÁo
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit612( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 6.1.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registro de voucher com pedidos SITE n„o faturados (geralmente tipos 'A', 'H', '2')                                                        |
	//| EMISS√O Diferente d operaÁıes de serviÁo                                                                                                   |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'6.1.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDSITE > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_XNPSITE = SZF.ZF_PEDSITE " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_XNPSITE > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' '" + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '61' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit711
Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2')
VERIFICA«√O Diferente d operaÁıes de serviÁo DA
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit711( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 7.1.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2')                                                         |
	//| VERIFICA«√O Diferente d operaÁıes de serviÁo DA                                                                                            |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'7.1.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDVEND > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_NUM = SZF.ZF_PEDVEND " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_XNPSITE > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = SZF.ZF_PEDIDO  " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' '" + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '61' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit712
Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2') EMISS√O Todas as operaÁıes pendentes de varejo
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit712( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 7.1.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2') EMISS√O Todas as operaÁıes pendentes de varejo          |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
		
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'7.1.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDVEND > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_NUM = SZF.ZF_PEDVEND " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_XNPSITE > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_FILIAL = SC5.C5_FILIAL " + CRLF
	cSQL += "                  AND SC6.C6_NUM = SC5.C5_NUM " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = SZF.ZF_PEDIDO  " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' '" + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
return cSQL

/*/{Protheus.doc} getQSit721
Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2')
VERIFICA«√O Diferente dE operaÁıes de serviÁo
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit721( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 7.2.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+	
	//| Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2')                                                         |
	//| VERIFICA«√O Diferente dE operaÁıes de serviÁo                                                                                              |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
		
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'7.2.1'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDVEND > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_NUM = SZF.ZF_PEDVEND " + CRLF
	//cSQL += "                  AND SC6.C6_PEDGAR = SZF.ZF_PEDIDO  " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = SZF.ZF_PEDIDO  " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' '" + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_XNPSITE > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATVER >= '" + dToS(dDataRef) + "' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '61' " + CRLF
	cSQL += "       AND SC6.C6_XOPER <> '51'" + CRLF
return cSQL

/*/{Protheus.doc} getQSit722
Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2')
EMISS√O Tod  operaÁıes pendentes de varejo
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
static function getQSit722( dDataRef )
	local cSQL := ""
	
	default dDataRef := ctod("//")
	
	if empty(dDataRef)
		return ""
	endif

	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 7.2.2                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registro de voucher com pedidos ERP n„o faturados (geralmente tipos 'A', 'H', '2')                                                         |
	//| EMISS√O Tod  operaÁıes pendentes de varejo                                                                                                 |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	
	cSQL := ''
	cSQL += "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'7.2.2'        SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR  PEDORI, " + CRLF
	cSQL += "       SZ5.Z5_PEDGAR  PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    NOTA, " + CRLF
	cSQL += "       SZ5.Z5_GRUPO   GRUPO, " + CRLF
	cSQL += "       SZ5.Z5_DESGRU  DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     BLQ, " + CRLF
	cSQL += "       SZ5.Z5_TIPVOU   TIPVOUCHER, " + CRLF
	cSQL += "       SZ5.Z5_CODVOU   CODVOUCHER, " + CRLF
	cSQL += "       ' '             CODFLUXO, " + CRLF
	cSQL += "       SZ5.Z5_EMISSAO DATREGISTRO, " + CRLF
	cSQL += "       SZ5.Z5_DATVAL  DATVAL, " + CRLF
	cSQL += "       SZ5.Z5_DATVER  DATVER, " + CRLF
	cSQL += "       SZ5.Z5_DATEMIS DATEMIS, " + CRLF
	cSQL += "       'FALSE' 	   ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SZ5010 SZ5 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZG010 SZG " + CRLF
	cSQL += "               ON SZ5.Z5_PEDGAR = SZG.ZG_NUMPED " + CRLF
	cSQL += "                  AND SZG.ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMPED > ' ' " + CRLF
	cSQL += "                  AND SZG.ZG_NUMVOUC > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SZF010 SZF " + CRLF
	cSQL += "               ON SZG.ZG_NUMVOUC = SZF.ZF_COD " + CRLF
	cSQL += "                  AND SZF.ZF_FILIAL = '" + xFilial("SZF") + "' " + CRLF
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SZF.ZF_PEDVEND > ' ' " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "               ON SC6.C6_NUM = SZF.ZF_PEDVEND  " + CRLF
	cSQL += "                  AND SC6.C6_PEDGAR = SZF.ZF_PEDIDO  " + CRLF
	cSQL += "                  AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC6.C6_DATFAT = ' '" + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_NUM = SC6.C6_NUM  " + CRLF
	cSQL += "                  AND SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SC5.C5_XNPSITE > ' ' " + CRLF
	cSQL += "                  AND SC5.C5_ARQVTEX = ' ' " + CRLF
	cSQL += "WHERE  SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " + CRLF
	cSQL += "       AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND SZ5.Z5_DATEMIS >= '" + dToS(dDataRef) + "' " + CRLF
return cSQL

/*/{Protheus.doc} getQSit810
Registros para faturamento referentes ‡ entrega de Hardware Avulso
@author Gustavo / Giovanni
@since 01/05/2013
/*/ 
Static Function getQSit811(dDataRef)
	
	Local cSQL := ""
	
	DEFAULT dDataRef := ctod("//")
	
	If empty(dDataRef)
		Return ""
	EndIf
	
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| SITUACAO 8.1.1                                                                                                                             |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	//| Registros referentes ‡ entrega de Hardware Avulso                                                                                          |
	//+--------------------------------------------------------------------------------------------------------------------------------------------+
	cSQL := "SELECT /*+ PARALLEL(5) */ " + CRLF
	cSQL += "		'8.1.1'        	SITUACAO, " + CRLF
	cSQL += "       SC5.C5_NUM      PEDIDO, " + CRLF
	cSQL += "       SC5.C5_XNPSITE 	PEDSITE, " + CRLF
	cSQL += "       SC6.C6_PEDGAR   PEDORI, " + CRLF
	cSQL += "       ''			  	PEDGAR, " + CRLF
	cSQL += "       SC6.C6_XOPER   	OPERACAO, " + CRLF
	cSQL += "       SC6.C6_NOTA    	NOTA, " + CRLF
	cSQL += "       ''			   	GRUPO, " + CRLF
	cSQL += "       ''			  	DESGRUPO, " + CRLF
	cSQL += "       SC6.C6_BLQ     	BLQ, " + CRLF
	cSQL += "       ''			 	TIPVOUCHER, " + CRLF
	cSQL += "       ''				CODVOUCHER, " + CRLF
	cSQL += "       ''			  	CODFLUXO, " + CRLF
	cSQL += "       ''			 	DATREGISTRO, " + CRLF
	cSQL += "       ''			  	DATVAL, " + CRLF
	cSQL += "       ''			  	DATVER, " + CRLF
	cSQL += "       ''			 	DATEMIS, " + CRLF
	cSQL += "       'TRUE' 			ENTREGAHW " + CRLF
	cSQL += "FROM   PROTHEUS.SC6010 SC6 " + CRLF
	cSQL += "       INNER JOIN PROTHEUS.SC5010 SC5 " + CRLF
	cSQL += "               ON SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
  	cSQL += "	   	AND C5_XNPSITE > ' '" 			+ CRLF
  	cSQL += "	   	AND C5_EMISSAO >= '" + DTOS(dDataRef) + "'" 	+ CRLF
	cSQL += "       AND SC6.C6_BLQ 	= ' ' " 		+ CRLF
	cSQL += "       AND SC6.C6_NOTA = ' ' " 		+ CRLF	
	cSQL += "	   	AND C6_XCDPRCO 	= ' '" 			+ CRLF	
	cSQL += "       AND SC6.C6_XOPER IN('53','62')" + CRLF
	cSQL += "	   	AND UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(SC5.C5_XOBS,2000,1)) LIKE  '%Posto de Entrega:%'" + CRLF
	cSQL += "       AND SC6.D_E_L_E_T_ = ' ' " + CRLF
return cSQL

/*/{Protheus.doc} fatConout
Conout mais detalhado.
@author Bruno Nunes
@since 31/07/2020
/*/ 
static function fatConout( cMsg )
	Conout( ' [ Tempo ]: '  + Dtoc( Date() ) + ' ' + Time() + ;
			' [ Fonte ]: '  + FunName()                     + ;
			' [ Funcao ]: ' + ProcName( 1 )                 + ;
			' [ Linha ]: '  + cValToChar( ProcLine( 1 ) )   + ;
			' [ Msg ]: '    + cMsg )
Return

//
/*/{Protheus.doc} atuLegProd
Atualiza o produto da GTLEGADO quando o cÛdigo Pedido GAR È diferente da SC6
@author Bruno Nunes
@since 17/09/2020
@alteraÁ„o: 24/03/2021 - TambÈm ira alterar o Valor no campo GT_VLRPRD - por mgomes.upduo
/*/ 
static function atuLegProd( cRecLeg, cPedGar, cProduto, cPedSite, cPedVenda, cEmissao, nVlrServS )
	local lRet := .F.
	local oLog := nil
	
	default cRecLeg   := ""
	default cPedGar   := ""
	default cProduto  := ""
	default cPedSite  := ""
	default cPedVenda := ""
	default cEmissao  := ""

    USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	if NetErr()
		UserException( "Falha ao abrir tabela GTLEGADO - SHARED" )
        return( lRet )
	endif

	dbSetIndex( "GTLEGADO05" )
	dbSelectArea( "GTLEGADO" )
	dbSetOrder( 1 )
    if dbSeek( cPedGar + cValToChar( cRecLeg ) ) 
        if GTLEGADO->GT_PRODUTO != cProduto .and. ;
           GTLEGADO->GT_PEDGAR  == cPedGar  
           
        	GTLEGADO->( RecLock( "GTLEGADO", .F. ) )
        	GTLEGADO->GT_PRODUTO := cProduto
			GTLEGADO->GT_VLRPRD  := nVlrServS
        	GTLEGADO->( MsUnlock() )
        	lRet := .T.

        	oLog := CSLog():New()
        	oLog:SetAssunto( "[ atuLegProd ] - Produto da GTLEGADO atualizado" )
        	oLog:AddLog( {"Pedido GAR....: " + cPedGar  ,;
        				  "Pedido Venda..: " + cPedVenda,;
        				  "Pedido Site...: " + cPedSite ,;
        				  "Codigo Produto: " + cProduto ,;
						  "valor Produto.: " + str(nVlrServS) ,;
        				  "Emissao.......: " + cEmissao } )
        	oLog:EnviarLog()

        endif
    endif
    GTLEGADO->( DbCloseArea() )
return lRet
