#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

//Chamada por empresa
User Function WFSC()
	Local _nEmp
	Local _lAtivo
	
	Private _aMatriz  := {"00","0030001"}  // para abrir a 1a empresa //
	Private _aEmpresa := {}
	Conout('Inicio do processamento - SC() ' )
	RpcSetType(3)
	RpcSetEnv(_aMatriz[1],_aMatriz[2])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o JOB ja estiver em execucao, nao continua            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    _lAtivo:= SuperGetMv( "MV_WFXATIV" , .F. , .F. ,  ) // Indica se os processos de workflow estão ativos para envio de e-mail.
    
	If _lAtivo
		IF !LockByName("WFSC")
			Conout("JOB de aprovação de SC já estava em execução: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()										// Limpa o ambiente, liberando a licença e fechando as conexões
	    	RETURN
	    ENDIF        
	    
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(_aMatriz[1],.F.)
	//	WHILE !SM0->(EOF())
			Aadd(_aEmpresa, {SM0->M0_CODIGO,Alltrim(SM0->M0_CODFIL)})
	//		SM0->(DBSkip())
	//	END
		RpcClearEnv()
	    For _nEmp := 1 To Len(_aEmpresa)
			U_SC({_aEmpresa[_nEmp]})
	    Next
		Conout('Final do processamento - SC() ' )
	Else
		Conout('Parametro MV_WFXATIVO está como .F....  - SC() ' )
	Endif
   	Return

//Chamada por empresa - TimeOut
User Function WFSC_TO()
	Local _nEmpTO
	Local _lAtivo
	Private _aMatrizTO  := {"00","0030001"}  // para abrir a 1a empresa //
	Private _aEmpresaTO := {}
	Conout('Inicio do processamento - SC_TO() ' )
	RpcSetType(3)
	RpcSetEnv(_aMatrizTO[1],_aMatrizTO[2])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o JOB ja estiver em execucao, nao continua            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    _lAtivo:= SuperGetMv( "MV_WFXATIV" , .F. , .F. ,  ) // Indica se os processos de workflow estão ativos para envio de e-mail.
    
	If _lAtivo

		IF !LockByName("WFSC_TO")
			Conout("JOB de aprovação de SC (TIMEOUT) já estava em execução: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()										// Limpa o ambiente, liberando a licença e fechando as conexões
	    	RETURN
	    ENDIF
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(_aMatrizTO[1],.F.)
	//	WHILE !SM0->(EOF())
		Aadd(_aEmpresaTO, {SM0->M0_CODIGO,Alltrim(SM0->M0_CODFIL)})
	//		SM0->(DBSkip())
	//	END
		RpcClearEnv()
	    For _nEmpTO := 1 To Len(_aEmpresaTO)
			U_SC_TO({_aEmpresaTO[_nEmpTO]})
	    Next
		Conout('Final do processamento - SC_TO() ' )
	Else
		Conout('Parametro MV_WFXATIV está como .F....  - SC_TO() ' )
	Endif	
   	Return

User Function SC( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => SC()")
		RETURN
	EndIf
	RpcSetType(3)
	RpcSetEnv(aParam[1][1],aParam[1][2])
	U_CONSOLE('SC(aParam)inicio:' + aParam[1][1]   +'/'+ aParam[1][2])
	U_WKFSC(1)  		// 1 - ENVIO SC PARA APROVADORES
	U_WKFSC(3)  		// 3 - ENVIO SC ITENS APROVADOS PARA SOLICITANTE
	U_WKFSC(4)  		// 4 - ENVIO SC ITENS REPROVADOS PARA SOLICITANTE
	RpcClearEnv()
	U_CONSOLE('SC(aParam) final:' + aParam[1][1]   +'/'+ aParam[1][2])
	RETURN

User Function SC_TO( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => SC_TO()")
		RETURN
	EndIf
	RpcSetType(3)
	RpcSetEnv(aParam[1][1],aParam[1][2])
	U_CONSOLE('SC_TO(aParam)inicio:' + aParam[1][1]   +'/'+ aParam[1][2])
	U_WKFSC(5)  		// Timeout SCs
	RpcClearEnv()
	U_CONSOLE('SC_TO(aParam) final:' + aParam[1][1]   +'/'+ aParam[1][2])
	RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WKFSC  ºAutor  ³Microsiga           º Data ³  18/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 1 - ENVIO DE EMAIL PARA APROVADORES                        º±±
±±º          ³ 2 - RETORNO DE EMAIL COM RESPOSTA DE APROVADORES           º±±
±±º          ³ 3 - ENVIA RESPOSTA DE SOLIC APROVADA  PARA O COMPRADOR	  º±±
±±º          ³ 4 - ENVIA RESPOSTA DE SOLIC REPROVADO PARA O COMPRADOR	  º±±
±±º          ³ 5 - ENVIO DE EMAIL - ACAO TIMEOUT                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WKFSC(_nOpc, oProcess)
	Local _cIndex, _cFiltro, _cOrdem, _lProcesso := .F.
	Local _cEmp,_cFilial, _cOpcao, _cObs
	Local cObs 		:= ""
	Local _aSC1_1:=''
	Local i
	Private _cQuery := ''
	
	Private _aWF 			:= {}   
	Private _aSC1_1 		:= {}
	Private _aSC1_5 		:= {}
	Private _aSC1_5_aprov 	:= {}
	Private _aReg			:= {}
	
	DO 	CASE 
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³1 - Prepara as solicitacoes a serem enviados para aprovacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
		CASE _nOpc == 1
	
			U_CONSOLE("1 - Prepara as solicitacoes a serem enviadas para aprovacao")
			U_CONSOLE("1 - EmpFil:" + cEmpAnt + xFilial("SC1"))
	
		  	_cQuery := ""
		  	_cQuery += " SELECT DISTINCT "
		  	_cQuery += " C1_FILIAL,"  
		  	_cQuery += " C1_XAPROV," 
		  	_cQuery += " C1_NUM,"
		  	_cQuery += " C1_USER"   		  			  	
		  	_cQuery += " FROM " + RetSqlName("SC1") + " SC1"
		  	_cQuery += " WHERE D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND C1_FILIAL   = '" + xFilial("SC1") + "'"
			_cQuery += " AND C1_APROV='B' "
		  	_cQuery += " AND C1_WF = ' '"
		  	_cQuery += " AND TRIM(C1_XAPROV) IS NOT NULL " //Só envia para as SCs que tem o gestor da unidade requisitante informado
		  	_cQuery += " AND C1_XBLWF='S' " // incluido pro André Couto 23/06/2021 ,pois a SC pode ter muitos itens e o colaborador pode concluir em um 2º momento               
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM"
			  	
			TcQuery _cQuery New Alias "TMPSC1"
		
			dbGotop()
			While !TMPSC1->(Eof())                                                                
				_cFilial   := TMPSC1->C1_FILIAL
				_cNumSC    := TMPSC1->C1_NUM
				_cUser     := TMPSC1->C1_USER
				_cAprov    := TMPSC1->C1_XAPROV 
	
				Aadd(_aSC1_1, {_cFilial,_cNumSC,_cUser,_cAprov})
	
				TMPSC1->(DBSkip())           
			End
	
			dbSelectArea("TMPSC1")
			dbCloseArea()
	
			If Len(_aSC1_1) > 0
				For i := 1 to Len(_aSC1_1)
					_aWF := EnviaSC(_aSC1_1[i][1], _aSC1_1[i][2], _aSC1_1[i][3], _aSC1_1[i][4],MSDATE(),LEFT(TIME(),5), _nOpc)
					If Len(_aWF) > 0 
						_lProcesso 	:= .T.
						DBSelectarea("SC1")
						DBSetOrder(1)
						IF SC1->(DBSeek(_aSC1_1[i][1]+ _aSC1_1[i][2]))
							While SC1->(C1_FILIAL + C1_NUM) == _aSC1_1[i][1]+_aSC1_1[i][2] .and. !SC1->(Eof())
								Reclock("SC1",.F.)
								SC1->C1_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
					  			SC1->C1_WFID		:= _aWF[1]							// Rastreabilidade
								SC1->C1_XDTLIM		:= _aWF[2]		// Data Limite
								SC1->C1_XHRLIM		:= _aWF[3]		// Hora Limite
								SC1->C1_XWFLINK		:= _aWF[4]		// Arquivo HTML
								MSUnlock() 
								SC1->(DbSkip())  
							Enddo	  
						Endif
					Endif	
	        	Next 
			End
			
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2 - Processa O RETORNO DO EMAIL - GESTOR              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
		CASE _nOPC	== 2
	
			U_CONSOLE("2 - Processa O RETORNO DO EMAIL")
			U_CONSOLE("2 - EmpFil:" + cEmpAnt + xFilial("SC1"))
	                                                                         
			U_CONSOLE("2 - cFilAnt    :" + xFilial("SC1"))
	
			cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
			cNum        := alltrim(oProcess:oHtml:RetByName("C1_NUM"))
			cNomapro    := alltrim(oProcess:oHtml:RetByName("C1_NOMAPRO"))
			cWFID     	:= oProcess:fProcessId
			cTo   		:= oProcess:cTo
			cOPC   		:= alltrim(oProcess:oHtml:RetByName("OPC"))
			oProcess:Finish() // FINALIZA O PROCESSO
			
//			U_CONSOLE("2 - Chave   :" + xFilial("SC1") + cNum)
//			U_CONSOLE("2 - WFId    :" + cWFID)
//			U_CONSOLE("2 - cTo     :" + cTo)
	
			IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
	                             
				dbSelectArea("SC1")
				dbSetOrder(1)
				SC1->(DbSeek(xFilial("SC1")+cNum))
		        While !SC1->(Eof()) .And. SC1->C1_FILIAL+SC1->C1_NUM == xFilial("SC1")+cNum    
		            U_CONSOLE("2 - Filial + SC + Item: ["+SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM+"]")            
					IF ALLTRIM(SC1->C1_WFID) <> ALLTRIM(cWFID)
						U_CONSOLE("2 - Processo nao encontrado :" + cWFID + " Processo atual :" + SC1->C1_WFID)
						Return .F.
					ENDIF  
					RECLOCK("SC1",.F.)
					If cOpc == "S"  
						SC1->C1_APROV   := "L"
					Else
						SC1->C1_APROV   := "R"
					Endif
					SC1->C1_WF		:= "2"
					SC1->C1_NOMAPRO := cNomApro
					SC1->C1_XWFOBS	:= cObs
					MSUNLOCK()
					SC1->(DbSkip())
				Enddo
				
			ENDIF
			U_CONSOLE("Retorno processado : SC " +cNum )
			Return		
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3 - Envia resposta de solic. aprovada para o solicitante³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
		CASE _nOpc == 3
	
			U_CONSOLE("3 - Envia resposta de solicitacao APROVADA para o solicitante")
			U_CONSOLE("3 - EmpFil:" + cEmpAnt + xFilial("SC1"))
	
		  	_cQuery := ""
		  	_cQuery += " SELECT DISTINCT "
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM,"
		  	_cQuery += " C1_XAPROV," 
		  	_cQuery += " C1_USER"   
		  	
		  	_cQuery += " FROM " + RetSqlName("SC1") + " SC1"
		  	_cQuery += " WHERE SC1.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND C1_FILIAL   = '" + xFilial("SC1") + "'"
			_cQuery += " AND C1_APROV='L' "										// Liberado
			_cQuery += " AND C1_XAPROV <> '      ' "							// Aprovador
		  	_cQuery += " AND C1_WF <> '1'"	      						    	// 1 Enviado EMAIL
		  	                     
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM"
			  	
			TcQuery _cQuery New Alias "TMPSC1"
		
			dbGotop()
			While !TMPSC1->(Eof())                                                                
				_cFilial   := TMPSC1->C1_FILIAL
				_cNumSC    := TMPSC1->C1_NUM
				_cUser     := TMPSC1->C1_USER
				_cAprov    := TMPSC1->C1_XAPROV
				Aadd(_aSC1_1, {_cFilial,_cNumSC,_cUser,_cAprov})
				TMPSC1->(DBSkip())           
			End
	
			dbSelectArea("TMPSC1")
			dbCloseArea()
	
			If Len(_aSC1_1) > 0
				For i := 1 to Len(_aSC1_1)
					_aWF := EnviaSC(_aSC1_1[i][1], _aSC1_1[i][2], _aSC1_1[i][3], _aSC1_1[i][4],MSDATE(),LEFT(TIME(),5), _nOpc)
					If Len(_aWF) > 0 
						_lProcesso 	:= .T.
						DBSelectarea("SC1")
						DBSetOrder(1)
						IF SC1->(DBSeek(_aSC1_1[i][1]+ _aSC1_1[i][2]))
							While SC1->(C1_FILIAL + C1_NUM) == _aSC1_1[i][1]+_aSC1_1[i][2] .and. !SC1->(Eof())
								Reclock("SC1",.F.)
								SC1->C1_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
					  			SC1->C1_WFID		:= _aWF[1]							// Rastreabilidade
								MSUnlock() 
								SC1->(DbSkip())  
							Enddo	  
						Endif
					Endif	
	        	Next 
			End
		
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³4 - Envia resposta de solicitacao bloqueada para o comprador³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
		CASE _nOpc == 4
	
			U_CONSOLE("4 - Envia resposta de solicitacao bloqueada para o solicitante")
			U_CONSOLE("4 - EmpFil:" + cEmpAnt + xFilial("SC1"))
			
		  	_cQuery := ""
		  	_cQuery += " SELECT DISTINCT "
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM,"
		  	_cQuery += " C1_XAPROV," 
		  	_cQuery += " C1_USER"   
		  	
		  	_cQuery += " FROM " + RetSqlName("SC1") + " SC1"
		  	_cQuery += " WHERE SC1.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND C1_FILIAL   = '" + xFilial("SC1") + "'"
			_cQuery += " AND C1_APROV='R' "										// Rejeitado
			_cQuery += " AND C1_XAPROV <> '      ' "							// Aprovador
		  	_cQuery += " AND C1_WF <> '1'"	      						    	// 1 Enviado EMAIL
		  	                     
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM"
			  	
			TcQuery _cQuery New Alias "TMPSC1"
		
			dbGotop()
			While !TMPSC1->(Eof())                                                                
				_cFilial   := TMPSC1->C1_FILIAL
				_cNumSC    := TMPSC1->C1_NUM
				_cUser     := TMPSC1->C1_USER
				_cAprov    := TMPSC1->C1_XAPROV
	
				Aadd(_aSC1_1, {_cFilial,_cNumSC,_cUser,_cAprov})
	
				TMPSC1->(DBSkip())           
			End
	
			dbSelectArea("TMPSC1")
			dbCloseArea()
	
			If Len(_aSC1_1) > 0
				For i := 1 to Len(_aSC1_1)
					_aWF := EnviaSC(_aSC1_1[i][1], _aSC1_1[i][2], _aSC1_1[i][3], _aSC1_1[i][4],MSDATE(),LEFT(TIME(),5), _nOpc)
					If Len(_aWF) > 0 
						_lProcesso 	:= .T.
						DBSelectarea("SC1")
						DBSetOrder(1)
						IF SC1->(DBSeek(_aSC1_1[i][1]+ _aSC1_1[i][2]))
							While SC1->(C1_FILIAL + C1_NUM) == _aSC1_1[i][1]+_aSC1_1[i][2] .and. !SC1->(Eof())
								Reclock("SC1",.F.)
								SC1->C1_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
					  			SC1->C1_WFID		:= _aWF[1]							// Rastreabilidade
								MSUnlock() 
								SC1->(DbSkip())  
							Enddo	  
						Endif
					Endif	
	        	Next 
			End
	
		CASE _nOpc	== 5

			U_CONSOLE("5 - Envia solicitacoes - timeout")
			U_CONSOLE("5 - EmpFil:" + cEmpAnt + xFilial("SC1"))
		  	_cQuery := ""

		  	_cQuery += " SELECT DISTINCT "
		  	_cQuery += " C1_FILIAL,"  
		  	_cQuery += " C1_NUM,"
		  	_cQuery += " C1_XAPROV," 
		  	_cQuery += " C1_USER,"   
		  	_cQuery += " C1_EMISSAO," 
			_cQuery += " C1_XCOMEME,"//ANDRE
		  	_cQuery += " C1_XDTLIM,"   
		  	_cQuery += " C1_XHRLIM,"   
		  	_cQuery += " C1_XWFLINK"
		  	  	
		  	_cQuery += " FROM " + RetSqlName("SC1") + " SC1"
		
		  	_cQuery += " WHERE D_E_L_E_T_ <> '*'"
			_cQuery += " AND C1_APROV='B' "
		  	_cQuery += " AND C1_XDTLIM  <= '" + DTOS(MSDATE()) + "'"
		  	_cQuery += " AND C1_WF = '1'"
		  	_cQuery += " AND C1_WFID   <> ' '"
		  	                     
		  	_cQuery += " ORDER BY"

		  	_cQuery += " C1_XAPROV,"
		  	_cQuery += " C1_XDTLIM,"
		  	_cQuery += " C1_XHRLIM"
				  	
			TcQuery _cQuery New Alias "TMPSC1"
		
			dbGotop()
		
			_cTimeOut	:= GetNewPar("MV_WFTOSC","24:00")		// WF-Workflow TO-TimeOut SC-Solicitacao Compra
	
			While !TMPSC1->(Eof())
				_cFilial   := TMPSC1->C1_FILIAL
				_cNumSC    := TMPSC1->C1_NUM
				_cUser     := TMPSC1->C1_USER
				_cAprov    := TMPSC1->C1_XAPROV
				_dDtLim	   := TMPSC1->C1_XDTLIM	
				_cHrLim	   := TMPSC1->C1_XHRLIM	
	
				Aadd(_aSC1_5, {_cFilial,_cNumSC,_cUser,_cAprov, _dDtLim, _cHrLim}) // AQUI TEM O ARRAY COM TODOS OS APROVADORES
	
				TMPSC1->(DBSkip())           
			End

			dbSelectArea("TMPSC1")
			dbCloseArea()
	   
			If Len(_aSC1_5) > 0
			   _cAprovTO := _aSC1_5[1][4]
				For i := 1 to Len(_aSC1_5)
					IF _cAprovTO == _aSC1_5[i][4]
						// alimenta o array para o mesmo aprovador
						Aadd(_aSC1_5_Aprov, _aSC1_5)      
						_nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
						_nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60)
						_aTimeOut	:= U_GetTimeOut(_nTimeOut, StoD(_dDtLim),_cHrLim)
	
						DBSelectArea("SC1")
						DBSetOrder(1)
						IF SC1->(DBSeek(_aSC1_5[i][1] + _aSC1_5[i][2]))
							AADD( _aReg, {;
									SC1->C1_FILDEST,;
									SC1->C1_NUM, ;
									SC1->C1_XCOMEME,;//ANDRE
									DTOC(SC1->C1_EMISSAO), ;
				                                "",;
									DTOC(SC1->C1_XDTLIM) + '-' + SC1->C1_XHRLIM, ;
									'00', ;
									UsrRetName(SC1->C1_XAPROV),;
									SC1->C1_XWFLINK})
							While !SC1->(Eof()) .and. xFilial("SC1")+SC1->C1_NUM == _aSC1_5[i][1] + _aSC1_5[i][2]
								RECLOCK("SC1",.F.)
								SC1->C1_XDTLIM	:= _aTimeOut[3]	
								SC1->C1_XHRLIM	:= _aTimeOut[4]
								MSUNLOCK()
								SC1->(DbSkip())
							Enddo								
							aMsg    := {}
						Endif
					Else
						// envia a notificacao
						TO_Notif(_cAprovTO, _aReg)  // envia para aprovador
						_cAprovTO 	:= _aSC1_5[i][4]
						_aReg 		:= {}
					
					Endif			
				Next i			
				TO_Notif(_cAprovTO, _aReg)  // envia para aprovador
			Endif

	END CASE
	
	IF 	_lProcesso
		U_CONSOLE(" Mensagem processada " )
	ELSE
		U_CONSOLE(" Nao houve processamento")
	ENDIF
	
	RETURN
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaSC   ºAutor  ³Microsiga           º Data ³  08/15/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnviaSC(_cFilial,_cNum, _cUser, _cAprov, _dDTLimit, _cHRLimit, _nOpc)
	_cHttp		:= GetNewPar("MV_WFDHTTP", "http://189.20.203.131:9898")
	_cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  )) // Indica se os processos de workflow estão ativos para envio de e-mail.
	_cTo		:= IIF(_nOpc == 1, _cAprov , alltrim(FWSFALLUSERS({_cUser})[1][5]))
	_cTo 		:= Iif(!Empty(_cDestFixo),_cDestFixo,_cTo) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
	_cEmail		:= alltrim(FWSFALLUSERS({_cAprov})[1][5])
	_nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
	_cTimeOut	:= GetNewPar("MV_WFTOSC","24:00")
	_dDataLib	:= IIF( !EMPTY(_dDTLimit), _dDTLimit, MSDATE() )
	_cHoraLib	:= IIF( !EMPTY(_cHRLimit), _cHRLimit, LEFT(TIME(),5) )
	_nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60)
	cTp_Compra	:= ""
	_aTimeOut	:= U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)
	_nTotSc     := 0 // Wellignton Mendes
	_cFornExc   :=" "  // campo para exibir se é fornecedor exclusivo
	_cEmailFi	:= GetNewPar("MV_WFEMFIN","wmendes@renovaenergia.com.br")
		//------------------- VALIDACAO
	_lError := .F.
	if Empty(_cTo)
		aMsg := {}
		cTitle  := "Administrador do Workflow : NOTIFICACAO"
		aADD(aMsg , REPLICATE('*',80) )
		aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
		aADD(aMsg , "Solicitacao de Compra No: " + _cNum + " Usuario : " + UsrRetName(_cUser) )
		aADD(aMsg , "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" )
		aADD(aMsg , REPLICATE('*',80) )

		_lError := .T.
	Endif

	IF _lError
		U_NotifyAdm(cTitle, aMsg)
		_aReturn := {}
		AADD(_aReturn, "")
		AADD(_aReturn, _aTimeOut[1])
		AADD(_aReturn, _aTimeOut[2])
		AADD(_aReturn, "")  

		RETURN _aReturn
	ENDIF

	// ----- FIM DA VALIDACAO

	ChkFile("SC1")
	ChkFile("SA2")
	ChkFile("SB1")
	ChkFile("SBM")

	_cChaveSCR	:= _cFilial + 'SC' + _cNum
	_cNum 		:= PADR(ALLTRIM(_cNum),6)

	lDetalhe 	:= .F.
	lObs		:= .F.

	_cNum := TRIM(_cNum)

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+cFilAnt)

	DBSelectArea("SC1")
	DBSetOrder(1)
	DBSeek(xFilial("SC1")+_cNum,.f.)

	_cUserSC1 := SC1->C1_USER
//	_cUnidReq := Alltrim(SC1->C1_UNIDREQ) + "  " + Alltrim(Posicione("SY3",1,xFilial("SY3")+SC1->C1_UNIDREQ,"SY3->Y3_DESC"))
	_cUnidReq := Alltrim(Posicione("SY3",1,xFilial("SY3")+SC1->C1_UNIDREQ,"SY3->Y3_DESC"))

	DBSelectArea("SY1")
	DBSetOrder(1)
	DBSeek(xFilial("SY1")+SC1->C1_CODCOMP)


	DO CASE
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao
				oProcess          	:= TWFProcess():New( "000001", "Envio Aprovacao SC :" + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio SC : " + _cNum, "\WORKFLOW\HTML\SCAPROV_RENOVA.HTM" )
				oProcess:cSubject 	:= "Aprovacao SC " + _cNum
				oProcess:bReturn  	:= "U_WKFSC(2)"
//				oProcess:attachfile(cAttachFile)

		CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
				oProcess          	:= TWFProcess():New( "000003", "Envio p/solicitante SC aprovada : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio SC aprovada : " + _cNum, "\WORKFLOW\HTML\SCRESP_RENOVA.HTM" )
				oProcess:cSubject 	:= "Solicitacao de compra APROVADA: "  +  _cNum
				_cResposta			:= "A P R O V A D O"     
				_cTo				:= Alltrim(_cTo) + ";" + Alltrim(_cEmailFi)

		CASE _nOpc == 4		// Envio de email Reprovado para solicitante
				oProcess          	:= TWFProcess():New( "000004", "Envio p/solicitante SC reprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio SC reprovado : " + _cNum, "\WORKFLOW\HTML\SCRESP_RENOVA.HTM" )
				oProcess:cSubject 	:= "Solicitacao de compra REPROVADA: "  +  _cNum
				_cResposta			:= "<font color='#FF0000'>R E P R O V A D O</font>"

	ENDCASE

	_cTo 				:= Iif(!Empty(_cDestFixo),_cDestFixo,_cTo) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
	oProcess:cTo      	:= _cTo
	oProcess:UserSiga	:= _cUser
	oProcess:NewVersion(.T.)

 	oHtml     				:= oProcess:oHTML

	IF _nOpc == 1
		oHtml:ValByName( "C1_XWFOBS"		   , "" )
	ENDIF

	IF _nOpc == 3 .OR. _nOpc == 4
		oHtml:ValByName( "mensagem"  	, _cResposta)
		oHtml:ValByName( "C1_XWFOBS"  	, SC1->C1_XWFOBS)	 
	ENDIF

	//Cabecalho

	oHtml:ValByName( "CEMPANT"		, SM0->M0_NOME )
	oHtml:ValByName( "CFILANT"		, SM0->M0_CODFIL )
	oHtml:ValByName( "C1_FILIAL"	, SM0->M0_FILIAL )
	oHtml:ValByName( "C1_NUM"		, SC1->C1_NUM )
	oHtml:ValByName( "C1_EMISSAO"	, DTOC(SC1->C1_EMISSAO))
	oHtml:ValByName( "C1_UNIDREQ"   , Posicione("SY3",1,xFilial("SY3")+SC1->C1_UNIDREQ,"SY3->Y3_DESC"))
	oHtml:ValByName( "C1_USER"		, UsrFullName(SC1->C1_USER))
	oHtml:ValByName( "C1_XAPROV"	, UsrFullName(SC1->C1_XAPROV))
	oHtml:ValByName( "C1_XTOTSC"	, TRANSFORM(SC1->C1_XTOTSC,'@E 99,999,999,999.99')) //WELLINGTON MENDES TOTAL DA SC NO WF.
	oHtml:ValByName( "cTp_Compra"	,Iif(SC1->C1_XCOMEME = "1","Emergencial","Normal")) //ANDRE COUTO TIPO DA COMPRA NO CABEÇALHO DA SC NO WF.
	//oHtml:ValByName( "cTp_Compra"	,SC1->C1_XCOMEME) //ANDRE COUTO TIPO DA COMPRA NO CABEÇALHO DA SC NO WF.
	_cUserSC1 := UsrFullName(SC1->C1_USER)
	//AAdd( (oHtml:ValByName( "t.9"    )), _cTpCompra)
	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS
	//-------------------------------------------------------------
	While !SC1->(EOF()) .AND. SC1->C1_FILIAL == xFilial("SC1") .AND. SC1->C1_NUM == _cNum
        _cDescricao := ''
		DBSELECTAREA("SB1")
		DBSetOrder(1)
		DBSeek(xFilial()+SC1->C1_PRODUTO)
		_cDescricao := SC1->C1_PRODUTO+"-"+SB1->B1_DESC

		DBSELECTAREA("SBM")
		DBSetOrder(1)
		DBSeek(xFilial()+SB1->B1_GRUPO)

            // SE FORNECEDOR FOI INFORMADO //
		DBSELECTAREA("SA2")
		DBSetOrder(1)
		If DBSeek(xFilial()+SC1->C1_FORNECE+SC1->C1_LOJA)
			_cDescricao += CHR(10)+CHR(13)+'Fornecedor sugerido: '+ SA2->A2_NREDUZ
        ENDIF
        // CAMPO OBS //
        If SC1->C1_OBS <> ''
			_cDescricao += CHR(10)+CHR(13)+'Obs: '+ SC1->C1_OBS
        ENDIF
        _cFornExc  :=   Iif(SC1->C1_XFORESP = "1","Sim","Não") // Fornecedor Exclusivo
        //cTp_Compra := 	Iif(SC1->C1_XCOMEME = "1","Emergencial","Normal")//;Iif(SC1->C1_XTIPO = "1","Centralizada",;
						//Iif(SC1->C1_XTIPO = "2","Descentralizada",;
						//Iif(SC1->C1_XTIPO = "3","Compra pela Area",;
						//"Outros")))
		
		_nTotSc += SC1->C1_VLESTIM*SC1->C1_QUANT // Welington Mendes Multiplica quantidade por valor estimado para gerar o total da sc.
		
		AAdd( (oHtml:ValByName( "t.0"    )), Posicione("SM0",1,cEmpAnt+SC1->C1_FILDEST,"M0_FILIAL") )
		AAdd( (oHtml:ValByName( "t.1"    )), SC1->C1_ITEM)
		AAdd( (oHtml:ValByName( "t.2"    )), _cDescricao)
		AAdd( (oHtml:ValByName( "t.3"    )), TRANSFORM(SC1->C1_QUANT,'@E 999,999.99'))
		AAdd( (oHtml:ValByName( "t.4"    )), SB1->B1_UM)
		AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(SC1->C1_VLESTIM,'@E 99,999,999,999,999.99'))
		AAdd( (oHtml:ValByName( "t.6"    )), TRANSFORM(SC1->C1_VLESTIM*SC1->C1_QUANT,'@E 99,999,999,999,999.99'))
		AAdd( (oHtml:ValByName( "t.7"    )), Alltrim(Posicione("CTT",1,xfilial("CTT")+SC1->C1_CC,"CTT->CTT_DESC01")))
		AAdd( (oHtml:ValByName( "t.8"	 )), Alltrim(Posicione("CV0",1,xFilial("CV0")+"05"+SC1->C1_EC05DB  ,"CV0_DESC")))	
		//AAdd( (oHtml:ValByName( "t.9"    )), _cTpCompra)
		AAdd( (oHtml:ValByName( "t.10"   )), Alltrim(Posicione("CTD",1,xfilial("CTD")+SC1->C1_ITEMCTA,"CTD->CTD_DESC01"))) //ITEM CONTABIL
		AAdd( (oHtml:ValByName( "t.11"   )), Alltrim(Posicione("CTH",1,xfilial("CTH")+SC1->C1_CLVL   ,"CTH->CTH_DESC01"))) // CLASSE VR CONTABIL
        AAdd( (oHtml:ValByName( "t.12"   )), _cFornExc) // Fornecedor Exclusivo
        AAdd( (oHtml:ValByName( "t.13"   )), SC1->C1_XJUSTFO) // Justif. Fornec. Exclusivo
		SC1->(dbSkip())
	Enddo

	// ARRAY DE RETORNO
	_aReturn := {}
	AADD(_aReturn, oProcess:fProcessId)
	AADD(_aReturn, _aTimeOut[3])
	AADD(_aReturn, _aTimeOut[4])

	oHtml:ValByName( "data_hora"	, DTOC(MSDATE()) + " as " + LEFT(TIME(),5) )
	oProcess:nEncodeMime := 0

//	aAdd( oProcess:aParams, _cChave)

	DO CASE
		CASE _nOpc == 1    
			oProcess:cTo:= "000000"
			cProcess := oProcess:Start("\workflow\wfsc\")	// start workflow

			AADD(_aReturn, cProcess)  // para gravar o nome do html na SCR

			cSubject    := "Aprovação de Solicitação de compra No. " + _cNum

			aMsg := {}
			aaDD(aMsg, "Sr. Aprovador,")
			aaDD(aMsg, "Preparamos o documento abaixo para sua aprovação.")
			AADD(aMsg, "<br></br>")
			aaDD(aMsg, "Solicitacao de compra: <i>"+_cNum+"</i>") 
			aaDD(aMsg, "Valor total estimado: <i>"+ TRANSFORM(_nTotSc,'@E 99,999,999,999.99')+"</i>")
			aaDD(aMsg, "Solicitante: <i>"+_cUserSC1+"</i>")
			aaDD(aMsg, "Unid.Requisitante: <i>"+ _cUnidReq+"</i>" )
			AADD(aMsg, "<br></br>")
			AADD(aMsg, '<a href="' + _cHttp + '/workflow/wfsc/'  + alltrim(cProcess) + '.htm">Visualizar solicitação de compra</a>')
			AADD(aMsg, "<br></br>")
			AADD(aMsg, "Código de controle : <i>" + oProcess:fProcessId + "</i>")
			AADD(aMsg, "<br></br>")
			AADD(aMsg, "Atenciosamente,")
			AADD(aMsg, "Workflow Serviço de Mensagens")
			_cEmail := Iif(!Empty(_cDestFixo),_cDestFixo,_cEmail) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
			U_MailNotify( _cEmail, cSubject , aMsg )
		OTHERWISE
			oProcess:Start()
	END CASE

	return _aReturn


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TO_NOTIF  ºAutor  ³Microsiga           º Data ³  10/22/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 TimeOut - Notificacao                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TO_Notif(_cUser, _aReg)

local _nInd

	_cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  )) // Indica se os processos de workflow estão ativos para envio de e-mail.
	_aReg		:= aSort(_aReg,,,{ |x,y| x[01]+x[02] < y[01]+y[02] })

	_cHttp		:= GetNewPar("MV_WFDHTTP", "http://189.20.203.131:9898")
	aMsg 		:= {}
	_cTo		:= alltrim(FWSFALLUSERS({_cUser})[1][5])
	_cTo      	:= Iif(!Empty(_cDestFixo),_cDestFixo,_cTo) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.

	if Empty(_cTo)

		cTitle  := "Administrador do Workflow : NOTIFICACAO"
		aADD(aMsg , REPLICATE('*',80) )
		aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
		aADD(aMsg , "Time-Out SC - Usuario : " + UsrRetName(_cUser))
		aADD(aMsg , "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" )
		aADD(aMsg , REPLICATE('*',80))

		U_NotifyAdm(cTitle, aMsg)
		RETURN
	Endif

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt)

	oProcess          	:= TWFProcess():New( "000005", "SC-Time-Out Solicitacao de Compra / " + _cUser )
	oProcess          	:NewTask( "Time-Out de resposta SC Cod.User :"+_cUser, "\WORKFLOW\HTML\SCNotif_RENOVA.HTM" )
	oProcess:cSubject 	:= OemToAnsi("Solicitacoes de compra pendentes de aprovação")
	oProcess:cTo      	:= Iif(!Empty(_cDestFixo),_cDestFixo,_cTo) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
	oProcess:UserSiga	:= _cUser
	oProcess:NewVersion(.T.)

  	oHtml     			:= oProcess:oHTML

	// CABEÇALHO
	oHtml:ValByName( "CEMPANT" 	 	, cEmpAnt+" - "+SM0->M0_NOME)
	oHtml:ValByName( "USER"  	 	, UsrRetName(_cUser))			// Usuario
	oHtml:ValByName( "DATA_HORA" 	, DTOC(MSDATE()) + ' - ' + LEFT(TIME(),5) )				// Data e hora da geracao

	For _nInd := 1 TO Len(_aReg)
		AAdd( (oHtml:ValByName( "t.1"    )), Posicione("SM0",1,cEmpAnt+_aReg[_nInd][1],"M0_FILIAL"))
		AAdd( (oHtml:ValByName( "t.2"    )), _aReg[_nInd][2])
		AAdd( (oHtml:ValByName( "t.3"    )), _aReg[_nInd][3])
		AAdd( (oHtml:ValByName( "t.5"    )), _aReg[_nInd][5])
		AAdd( (oHtml:ValByName( "t.7"    )), _aReg[_nInd][7])
		AAdd( (oHtml:ValByName( "t.8"    )), '<a href="' + _cHttp + '/workflow/wfsc/'  + alltrim(_aReg[_nInd][8]) + '.htm">Visualizar solicitação de compra</a>')
	Next

	oProcess:nEncodeMime := 0
	oProcess:Start()
	RETURN
