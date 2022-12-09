#Include 'Protheus.ch'
#Include 'Totvs.ch'
#Include 'Topconn.ch'
#Include 'rwmake.ch'
#Include 'tbiconn.ch'
//-----------------------------------------------------------------------------------
// Rotina    | CSFS0006 | Autor | Rodrigo Seiti Mitani   | Data | 20/10/2006
//-----------------------------------------------------------------------------------
// Descr.    | Confirmação da solicitação de atendimento.
//-----------------------------------------------------------------------------------
// Melhorias | Alteração no método de Query e geração do pedido, LOG para mostrar
//           | os pedidos gerados 
//           | Autor | Rafael Beghini | Data | 29/01/2016
//-----------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital
//-----------------------------------------------------------------------------------
User Function CSFS0006()
	Private cTitulo        := 'CSFS0006 | Gera Pedido'
	Private aLOG           := {}
	Private lRet           := .F.
	PRIVATE lMsErroAuto    := .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile := .T.
	
	ValidPerg("CSFPED")
	
	If Pergunte("CSFPED",.T.)
		FwMsgRun(,{|| CSFSProces() },cTitulo,'Aguarde, gerando pedido de venda...')
		IF lRet
			MsgInfo('Processo executado, verifique os pedidos gerados.', cTitulo)
			CSFSShowLg( aLOG )
		EndIF
	EndIF
Return
//-----------------------------------------------------------------------
// Rotina | CSFSProces | Autor | Rafael Beghini    | Data | 29/01/2016
//-----------------------------------------------------------------------
// Descr. | Executa o processamento e gera pedido de venda
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFSProces()
	Local cSQL     := ''
	Local cTRB     := '' 
	Local cTPCLI   := ''
	Local cVend    := ''
	Local cTpB1    := ''
	Local cMSG     := ''
	Local cTrue    := 'ALLWAYSTRUE()'
	
	Local cPath    := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp% 
	Local cLogFile := cPath + "GeraPedidos.LOG"
	
	Local _aItens  := {}
	Local _aCab    := {}
	Local _aRets   := {}
	Local aLOGErro := {}
	Local _ncounts := 1
	Local nHandle  := 0
	Local nX       := 0
	Local lCopy    := .F.
	
	cSQL += "SELECT * " 
	cSQL += "FROM  "+RetSqlName("PA0")+" PA0 "
	cSQL += " INNER JOIN "+RetSqlName("PA1")+" PA1 "
	cSQL += "       ON PA1_OS = PA0_OS "
	cSQL += "       AND PA1_FATURA = 'S' And PA1_MSPED = ' ' "
	cSQL += "WHERE  PA0.D_E_L_E_T_ = ' ' "
	cSQL += "       AND PA0_FILIAL = '" + xFilial('PA0') + "'"
	cSQL += "       AND PA0_OS BETWEEN     '" + Mv_par01 + "' AND '" + Mv_par02 + "' "  
	cSQL += "       AND PA0_CLILOC BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' " 
	cSQL += "       AND PA0_DTAGEN BETWEEN '" + dTos(Mv_par05) + "' AND '" + dTos(Mv_par06) + "' " 
	cSQL += "       AND PA0_STATUS = 'F' "
	cSQL += "       AND PA0_SITUAC = 'L' "
	cSQL += "ORDER BY PA0_OS ASC "
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	
	IF .NOT. (cTRB)->( EOF() )
		While .NOT. (cTRB)->( EOF() )
			lRet := .T.
			_numped	:= GETSXENUM("SC5","C5_NUM")
			
			_aItens  := {}
			_aCab    := {}
			_ncounts := 1
		
			PA1->( dbSetOrder(1) )
			IF PA1->( dbSeek( xFilial('PA1') + (cTRB)->PA0_OS ) )
				While .NOT. Eof() .And. PA1->PA1_FILIAL == (cTRB)->PA0_FILIAL .And. PA1->PA1_OS == (cTRB)->PA0_OS
					IF PA1->PA1_FATURA == 'S' .And. Empty(PA1->PA1_MSPED)
						cTpB1 := Posicione("SB1", 1, xFilial("SB1") + PA1->PA1_PRODUT, "B1_TIPO")
						cVend := IIF( cTpB1 $ GetMv("MV_MATHARD"), 'VA0001', 'CC0001' )
						
						IF !Posicione("SB1", 1, xFilial("SB1") + PA1->PA1_PRODUT, "B1_TIPO")	$ GetMv("MV_MATHARD")
							_aRets := {}
							aAdd( _aRets, {"C6_FILIAL"	, xFilial("SC6")											 , NIL   })
							aAdd( _aRets, {"C6_NUM"	, _numped													 , NIL   })
							aAdd( _aRets, {"C6_ITEM"	, StrZero(_ncounts,2)									 	 , NIL   })
							aAdd( _aRets, {"C6_PRODUTO"	, PA1->PA1_PRODUT											 , NIL   })
							aAdd( _aRets, {"C6_DESCRI"	, Posicione("SB1",1 ,xFilial("SB1") + PA1->PA1_PRODUT, "B1_DESC"), NIL   })
							aAdd( _aRets, {"C6_UM" 	, Posicione("SB1",1 ,xFilial("SB1") + PA1->PA1_PRODUT, "B1_UM")  , NIL   })
							aAdd( _aRets, {"C6_QTDVEN" 	, PA1->PA1_QUANT 											 , NIL   })
							aAdd( _aRets, {"C6_PRCVEN"	, PA1->PA1_PRCUNI											 , NIL   })
							aAdd( _aRets, {"C6_TES"	, PA1->PA1_TES            									 , cTrue })
							aAdd( _aRets, {"C6_PRUNIT"	, PA1->PA1_PRCUNI											 , NIL   })
							aAdd( _aRets, {"C6_VALOR"	, PA1->PA1_VALOR   										 , NIL   })
							aAdd( _aRets, {"C6_COMIS1"	, 0											 			 , NIL   })
							aAdd( _aRets, {"C6_ENTREG"	, dDataBase												 , NIL   })
							aAdd( _aRets, {"C6_LOCAL"	, "00" 													 , cTrue })
							aAdd( _aRets, {"C6_QTDLIB"	, PA1->PA1_QUANT											 , NIL   })
							aAdd( _aItens, _aRets)
							_ncounts:= _ncounts + 1
						EndIF
					EndIF
					PA1->( dbSkip() )
				End
			EndIF
			
			cTPCLI := Posicione("SA1",1 ,xFilial("SA1") + (cTRB)->PA0_CLILOC + (cTRB)->PA0_LOJLOC	, "A1_TIPO")
			
			_aCab := {}
			aAdd( _aCab,{"C5_FILIAL" , xFilial("SC5")                              , NIL   })
			aAdd( _aCab,{"C5_NUM"    , _numped                                     , NIL   })
			aAdd( _aCab,{"C5_TIPO"   , "N"                                         , NIL   })
			aAdd( _aCab,{"C5_TIPOCLI", cTPCLI                                      , NIL   })
			aAdd( _aCab,{"C5_CLIENTE", (cTRB)->PA0_CLILOC                          , NIL   })
			aAdd( _aCab,{"C5_LOJACLI", (cTRB)->PA0_LOJLOC                          , NIL   })
			aAdd( _aCab,{"C5_VEND1"  , cVend                                       , cTrue })
			aAdd( _aCab,{"C5_CONDPAG", (cTRB)->PA0_CONDPA                          , NIL   })
			aAdd( _aCab,{"C5_TPFRETE", "F"                                         , NIL   })
			aAdd( _aCab,{"C5_EMISSAO", dDATABASE                                   , NIL   })
			aAdd( _aCab,{"C5_MOEDA"  , 1                                           , NIL   })
			aAdd( _aCab,{"C5_XNATURE", "FT010001"                                  , NIL   })
			aAdd( _aCab,{"C5_AR"     , (cTRB)->PA0_AR	                              , NIL   })
			aAdd( _aCab,{"C5_XORIGPV", "5"                                         , NIL   })	
			aAdd( _aCab,{"C5_NUMATEX", (cTRB)->PA0_OS	                              , NIL   })	
			aAdd( _aCab,{"C5_MENNOTA", "Numero do Atendimento: " + (cTRB)->PA0_OS  , NIL   })	
			
			If Len(_aItens) > 0
				ConfirmSX8()
				
				lMsErroAuto := .F.    	
				lCopy       := .F.	
				aLOGErro    := {}
						
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gera pedido de venda            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItens,3)
				
				If lMsErroAuto
					RollBAckSx8()
					MsgAlert('Erro no atendimento ' + (cTRB)->PA0_OS + '. Não será possível incluir o pedido, verifique.', cTitulo)
							
					//////////////////////////
					aLOGErro := GetAutoGRLog()	 //função que retorna as informações de erro ocorridos durante o processo da rotina automática		
					
					If File( cLogFile )
						Ferase( cLogFile )
					EndIF
								
					If ( nHandle := MSFCreate(cLogFile,0) ) <> -1				
						lCopy := .T.			
					EndIf		
							
					If	lCopy  //grava as informações de log no arquivo especificado			
						For nX := 1 To Len( aLOGErro )				
							FWrite( nHandle, aLOGErro[nX] + CRLF )			
						Next nX			
						
						FClose(nHandle)
						ShellExecute( "Open", cLogFile , '', '', 1 ) //Abre o arquivo na tela após salvar
						Return		
					EndIf
					/////////////////////////
				Else
					aAdd( aLOG, { (cTRB)->PA0_OS, _numped } )
					
					PA0->( DbSetOrder(1) )
					IF PA0->( dbSeek( xFilial('PA0') + (cTRB)->PA0_OS ) )
						RecLock("PA0",.F.)
							PA0->PA0_SITUAC := 'P'
							PA0->PA0_STATUS := 'P' 
						MsUnlock()
					EndIF
					
					//Grava o numero do Pedido Microsiga no Item do Atendimento
					PA1->( dbSetOrder(1) )
					IF PA1->( dbSeek( xFilial('PA1') + (cTRB)->PA0_OS ) )
						While .NOT. Eof() .And. PA1->PA1_FILIAL == (cTRB)->PA0_FILIAL .And. PA1->PA1_OS == (cTRB)->PA0_OS
							IF PA1->PA1_FATURA == 'S' .And. Empty(PA1->PA1_MSPED)
								RecLock("PA1",.F.)
								PA1->PA1_MSPED := _numped
								MsUnlock()
							EndIF
							PA1->( dbSkip() )
						End
					EndIF
				EndIF
			Else
				RollBAckSx8()
			EndIF
		(cTRB)->( dbSkip() )	
		End
		(cTRB)->( dbCloseArea() )
	Else
		MsgAlert('Pesquisa Nula!' + CRLF + 'Não há ordens de serviço pendentes para a geração de pedidos, '+;
				'por favor verifique os parâmetros informados.', cTitulo)
	EndIF
Return(.T.)
//-----------------------------------------------------------------------
// Rotina | ValidPerg | Autor | Cristian Gutierrez    | Data | 17/01/2006
//-----------------------------------------------------------------------
// Descr. | Cria o grupo de perguntas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function ValidPerg(cPerg)
	Local aRegs := {}
	
	dbSelectArea("SX1")
	dbSetorder(1)
	
	If !dbSeek(cPerg)
		aAdd(aRegs,{cPerg,"01","Atendimento de ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"02","Atendimento ate?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"03","Cliente de     ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
		aAdd(aRegs,{cPerg,"04","Cliente ate    ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
		aAdd(aRegs,{cPerg,"05","Data de        ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"06","Date ate       ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	    U_CSGEN001(aRegs)
	EndIf
Return
//-----------------------------------------------------------------------
// Rotina | CSFSShowLg | Autor | Rafael Beghini    | Data | 29/01/2016
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar os pedidos de venda gerados
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFSShowLg( aLOG )
	Local oDlg
	Local oLst
		
	IF .NOT. Empty( aLOG ) 
		//Montagem da Tela
		Define MsDialog oDlg Title "Pedidos de venda gerados" From 0,0 To 300, 600 Of oMainWnd Pixel
			@ 010,005 LISTBOX oLst Fields HEADER "Nº Atendimento", "Nº Pedido Venda" SIZE 295,110 OF oDlg PIXEL
			oLst:SetArray(aLOG)
			oLst:nAt := 1
			oLst:bLine := { || { aLOG[oLst:nAt,1], aLOG[oLst:nAt,2] } }
		
			DEFINE SBUTTON FROM 130,005 TYPE 1 ACTION oDlg:End()      ENABLE OF oDlg  
			DEFINE SBUTTON FROM 130,040 TYPE 6 ACTION CSFSExcel(aLOG) ENABLE OF oDlg  
		Activate MSDialog oDlg Centered
	EndIF
Return(.T.)
//-----------------------------------------------------------------------
// Rotina | CSFSExcel  | Autor | Rafael Beghini    | Data | 29/01/2016
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar os dados em planilha
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFSExcel(aLOG)
	Local cCabec := "Pedidos de venda gerados em " + dToC(ddatabase)
	FwMsgRun(,{|| DlgToExcel( { { "ARRAY", cCabec, {'Nº Atendimento','Nº Pedido Venda'}, aLOG } } ) },cTitulo,'Aguarde, exportando os dados...') 
Return