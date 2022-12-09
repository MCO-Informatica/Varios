#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

//Chamada por empresa
User Function WFPA()
	Local _nEmp
	Local _lAtivo
	Private _aMatriz  := {"00","0030001"}  // para abrir a 1a empresa //
	Private _aEmpresa := {}
	Conout('Inicio do processamento - PA() ' )
	RpcSetType(3)
	RpcSetEnv(_aMatriz[1],_aMatriz[2])
    _lAtivo:= SuperGetMv( "MV_WFXATIVO" , .F. , .F. ,  ) // Indica se os processos de workflow estใo ativos para envio de e-mail.
    
	If _lAtivo
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se o JOB ja estiver em execucao, nao continua            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF !LockByName("WFPA")
			Conout("JOB de aprova็ใo de PA jแ estava em execu็ใo: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()										// Limpa o ambiente, liberando a licen็a e fechando as conex๕es
	    	RETURN
	    ENDIF
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(_aMatriz[1],.F.)
		WHILE !SM0->(EOF())   
			//If Alltrim(SM0->M0_CODFIL) == "0030001" // SOMENTE PARA TESTAR
				Aadd(_aEmpresa, {SM0->M0_CODIGO,Alltrim(SM0->M0_CODFIL)})
			//Endif
			SM0->(DBSkip())
		END
		RpcClearEnv()
	    For _nEmp := 1 To Len(_aEmpresa)
			U_PA({_aEmpresa[_nEmp]})
	    Next
		Conout('Final do processamento - PA() ' )
	Else
		Conout('Parametro MV_WFXATIVO estแ como .F....  - PA() ' )
	Endif
   	Return

User Function PA( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => PA()")
		RETURN
	EndIf
	RpcSetType(3)
	RpcSetEnv(aParam[1][1],aParam[1][2])
	U_CONSOLE('PA(aParam)inicio:' + aParam[1][1]   +'/'+ aParam[1][2])
	U_WKFPA(1)  		// 1 - ENVIO SC PARA APROVADORES
	U_WKFPA(3)  		// 3 - ENVIO SC ITENS APROVADOS PARA SOLICITANTE
	U_WKFPA(4)  		// 4 - ENVIO SC ITENS REPROVADOS PARA SOLICITANTE
	RpcClearEnv()
	U_CONSOLE('PA(aParam) final:' + aParam[1][1]   +'/'+ aParam[1][2])
	RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณWKFPA     บAutor  ณPedro Augusto       บ Data ณ  13/03/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 - ENVIO DE EMAIL PARA APROVADORES                        บฑฑ
ฑฑบ          ณ 2 - RETORNO DE EMAIL COM RESPOSTA DE APROVADORES           บฑฑ
ฑฑบ          ณ 3 - ENVIA RESPOSTA DE ADIANTAMENTO APROVADO PARA O USUARIO บฑฑ
ฑฑบ          ณ 4 - ENVIA RESPOSTA DE ADIANTAMENTO REPROVADO PARA O USUARIOบฑฑ
ฑฑบ          ณ 5 - ENVIO DE EMAIL - ACAO TIMEOUT                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RENOVA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
User Function WKFPA(_nOpc, oProcess)      
	Local _lProcesso := .F.
	Local _cFilial, _cOpcao, _cObs, _cChaveSCR
	
	Local nSaldo 		:= 0 , 	nSalDif 	:= 0  ,	cTipoLim  	:= ""
	Local aRetSaldo 	:={} ,	cAprov    	:= "" , cObs 		:= ""
	Local nTotal    	:= 0 , 	cGrupo	 	:= "" , lLiberou	:= .F.
	
	ChkFile("SCR")
	ChkFile("SAL")
	ChkFile("SZ7")
	ChkFile("SAK")                    
	ChkFile("SE4")
	ChkFile("SA2")
	ChkFile("SBM")
	ChkFile("SCR")
	CHKFile("SAL")
	
	DO 	CASE 
		/*
		//ณ1 - Prepara os adiantamentos a serem enviados para aprovacaoณ
		*/
		CASE _nOpc == 1
	
			U_CONSOLE("1 - Prepara os adiantamentos a serem enviados para aprovacao")
			U_CONSOLE("1 - EmpFil:" + cEmpAnt + cFilAnt)

_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_TIPO,"   
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL," 
		  	_cQuery += " CR_TOTAL," 
		  	_cQuery += " CR_USER,"   
		  	_cQuery += " CR_APROV,"   
		  	_cQuery += " CR_DTLIMIT,"
		  	_cQuery += " CR_HRLIMIT"

		  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
		  	_cQuery += " WHERE "
		  	_cQuery += "     CR_FILIAL = '" + xFilial("SCR") + "'"
		  	_cQuery += " AND CR_TIPO = 'PA'" 
		  	_cQuery += " AND CR_STATUS = '02'"  						// Em aprovacao
		  	_cQuery += " AND CR_DTLIMIT  <= '" + DTOS(MSDATE()) + "'"	// Data Limite
		  	_cQuery += " AND CR_WF = ' '"
		  	_cQuery += " AND SCR.D_E_L_E_T_ = ' '"

		  	_cQuery += " ORDER BY"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL,"
		  	_cQuery += " CR_USER"
		  	
			TcQuery _cQuery New Alias "TMP"
		
			dbGotop()
			While !TMP->(Eof())
            
				DBSelectArea("SZ7")
				DBSetOrder(1)
				DBSeek(xFilial("SZ7")+PADR(TMP->CR_NUM,TamSX3("Z7_NUMSEQ")[1]))

				IF EMPTY(SZ7->Z7_GRAPROV)
					DBSelectarea("SCR")
					DBSetOrder(2)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= "1" 		 // Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= "N/D"	 // Rastreabilidade
						MSUnlock()
					ENDIF	
				ELSE 	
					_aWF	 		:= EnviaPA(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) , TMP->CR_TOTAL, STOD(TMP->CR_DTLIMIT), TMP->CR_HRLIMIT, _nOpc)
					
					_lProcesso 	:= .T.
			
					DBSelectarea("SCR")
					DBSetOrder(2)   
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						Reclock("SCR",.F.)
                        u_console("_aWF[1]......: "+_aWF[1])
						SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= _aWF[1]		// Rastreabilidade
//						SCR->CR_DTLIMIT		:= _aWF[2]		// Data Limite
//						SCR->CR_HRLIMIT		:= _aWF[3]		// Hora Limite
//						SCR->CR_WFLINK		:= _aWF[4]		// Arquivo HTML
						MSUnlock()     
								
					ENDIF
				ENDIF
				
				TMP->(DBSkip())           
			End
			
			dbSelectArea("TMP")
			dbCloseArea()

	/*
	//ณ2 - Processa O RETORNO DO EMAIL                       ณ
	*/
		CASE _nOPC	== 2
	
			U_CONSOLE("2 - Processa O RETORNO DO EMAIL")
			U_CONSOLE("2 - EmpFil:" + cEmpAnt + cFilAnt)

			cWFObs     	:= alltrim(oProcess:oHtml:RetByName("WFOBS"))

			Conout("WFRetPA - Processa O RETORNO DO EMAIL")
			Conout("WFRetPA - EmpFil:" + cEmpAnt + cFilAnt)
			
			cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
			cFilAnt		:= padr(alltrim(oProcess:oHtml:RetByName("CFILANT")),7)
			__cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
			_cAprov    	:= alltrim(oProcess:oHtml:RetByName("CR_USER"))
			_cChaveSCR	:= Padr(__cChaveSCR,54)+_cAprov
			cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))

			oProcess:Finish() // FINALIZA O PROCESSO
			
			U_CONSOLE("2 - cFilAnt    :" + cFilAnt)
			U_CONSOLE("2 - __cChaveSCR:" + __cChaveSCR)
			U_CONSOLE("2 - Opc        :" + cOpc)
			U_CONSOLE("2 - Obs        :" + cObs)
			U_CONSOLE("2 - WFId       :" + cWFID)
			U_CONSOLE("2 - _cAprov    :" + _cAprov)

			IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
				// Posiciona na tabela de Alcadas 
				DBSelectArea("SCR")
				DBSetOrder(2)
				DBSeek(__cChaveSCR)
				IF !FOUND() .OR. TRIM(SCR->CR_WFID) <> TRIM(cWFID)
					U_CONSOLE("2 - Processo nao encontrado :" + cWFID + " Processo atual :" + SCR->CR_WFID)
					Return .T.
				ENDIF
				
				Reclock("SCR",.F.)
				SCR->CR_WF		:= "2"			// Status 2 - respondido
				SCR->CR_OBS		:= cObs
				MSUnlock()

				If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
					U_CONSOLE("2 - Processo ja respondido via sistema :" + cWFID)
					Return .T.
				EndIf

				nTotal := SCR->CR_TOTAL

				dbSelectArea("SZ7")
				dbSetOrder(1)
				SZ7->(dbSeek(xFilial("SZ7")+LEFT(SCR->CR_NUM,(Len(SZ7->Z7_NUMSEQ)))))

				lLiberou := MaAlcDoc({SCR->CR_NUM,"PA",nTotal,SCR->CR_APROV,,SZ7->Z7_GRAPROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))
				
				U_CONSOLE("2 - Liberado :" + IIF(lLiberou, "Sim", "Nao"))

				_lProcesso := .T.
				
				If lLiberou
					If cOpc=="S"
						u_console("cOpc = S: chamando U_RNO003")
						// Chamada da MSExecAuto - Desenvolvida por Iuspa / Antonio
						_lRet := U_RNO003() 
						If _lRet == .F.
							u_console("cOpc = S: lRet = F - Erro na MsExecAuto")
							RecLock("SZ7", .F.) 
							SZ7->Z7_STATUS := "E"
							MsUnlock()
						Else
							u_console("MsExecAuto retornou T - Processamento OK")
						Endif
					Else
						Reclock("SZ7",.F.)
							u_console("cOpc = N")
							SZ7->Z7_WFOBS 	:= cWFObs
							SZ7->Z7_DATALIB := Date()
							SZ7->Z7_STATUS  := "3"
						MsUnlock()
					EndIf
				EndIf
			EndIf				

	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ3 - Envia resposta de pedido aprovado para o compradorณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	
		CASE _nOpc == 3
			U_CONSOLE("3 - Envia resposta de pedido APROVADO para o usuario")
			U_CONSOLE("3 - EmpFil:" + cEmpAnt + cFilAnt)
		  	_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " Z7_FILIAL," 
		  	_cQuery += " Z7_NUMSEQ,"
		  	_cQuery += " Z7_USUINCL"   
		  	_cQuery += " FROM " + RetSqlName("SZ7") + " SZ7"
		  	_cQuery += " WHERE SZ7.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND Z7_FILIAL   = '" + xFilial("SZ7") + "'"
		  	_cQuery += " AND Z7_WF <> '1'"	      			// 1 Enviado EMAIL
		  	_cQuery += " ORDER BY"
		  	_cQuery += " Z7_FILIAL," 
		  	_cQuery += " Z7_NUMSEQ"
			TcQuery _cQuery New Alias "TMP"
			dbGotop()
			While !TMP->(Eof())
				_cNum	   := TMP->Z7_NUMSEQ
				DBSelectarea("SCR")
				DBSetOrder(1)
				DBSeek(TMP->(Z7_FILIAL+"PA"+_cNum),.T.)
				_lAchou  := .F.
				_lAprov	:= .F.
				_cChave	:= ''
				_nTotal	:= 0
				While !SCR->(EOF()) 						.AND. ;
	    		   	SCR->CR_FILIAL		== TMP->Z7_FILIAL  	.AND. ;
	      			SCR->CR_TIPO 	    == "PA" 			.AND. ;
	        		SCR->CR_NUM         == Padr(TMP->Z7_NUMSEQ,TamSX3("CR_NUM")[1])
	        		IF SCR->CR_STATUS == '03' .AND. !EMPTY(SCR->CR_LIBAPRO)   // SOMENTE CASO APROVADO
        				_cChave	:= SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
        				_lAprov	:= .T.
						_lAchou  := .T.        				
        				_nTotal	:= SCR->CR_TOTAL
        			ENDIF
	        		SCR->(DBSkip())
	        	End
				IF !_lAchou
					DBSelectarea("SZ7")
					DBSetOrder(1)
					IF DBSeek(TMP->(Z7_FILIAL+Z7_NUMSEQ))
						Reclock("SZ7",.F.)
						SZ7->Z7_WF			:= "1"   	                        // Status 1 - envio email
						MSUnlock()
						TMP->(DBSkip())
					ENDIF
				ENDIF
	    		IF _lAprov
					_aWF:= EnviaPA(TMP->Z7_FILIAL, Padr(TMP->Z7_NUMSEQ, len(SCR->CR_NUM)), TMP->Z7_USUINCL , _cChave, _nTotal, ctod('  /  /  '), '     ',_nOpc)
					_lProcesso 	:= .T.
					While !TMP->(EOF()) .AND. _cNum == TMP->Z7_NUMSEQ 
						DBSelectarea("SZ7")
						DBSetOrder(1)
						IF DBSeek(TMP->(Z7_FILIAL+Z7_NUMSEQ))
							Reclock("SZ7",.F.)
							SZ7->Z7_WF			:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
							MSUnlock()
						ENDIF
						TMP->(DBSkip())
					END
				ENDIF
			END
			dbSelectArea("TMP")
			dbCloseArea()

	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ4 - Envia resposta de pedido bloqueado para o compradorณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
		CASE _nOpc == 4
	
			U_CONSOLE("4 - Envia resposta de adiantamentos reprovados para o usuario")
			U_CONSOLE("4 - EmpFil:" + cEmpAnt + cFilAnt)
			
		  	_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_TIPO,"   
		  	_cQuery += " CR_NUM,"    
		  	_cQuery += " CR_NIVEL," 
		  	_cQuery += " CR_TOTAL," 
		  	_cQuery += " CR_USER,"   
		  	_cQuery += " CR_APROV"    
		  	
		  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
		  	_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND CR_FILIAL = '" + xFilial("SCR") + "'"
//		  	_cQuery += " AND CR_FILIAL = '" + cFilAnt + "'"
		  	_cQuery += " AND CR_LIBAPRO <> '      '" 							// Seleciona o Aprovador que reprovou
		  	_cQuery += " AND CR_STATUS = '04'"                          // REPROVADO
		  	_cQuery += " AND CR_TIPO = 'PA'"                            // PEDIDO DE COMPRA
		  	_cQuery += " AND CR_WF <> '1'"	      					    	// 1-Enviado
		  	
		  	_cQuery += " ORDER BY"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL,"
		  	_cQuery += " CR_USER"
		  	
			TcQuery _cQuery New Alias "TMP"
		                            
			dbGotop()
			While !TMP->(Eof())
            
				DBSelectArea("SZ7")
				DBSetOrder(1)
				DBSeek(xFilial("SZ7")+PADR(TMP->CR_NUM,TamSX3("Z7_NUMSEQ")[1]))

				IF EMPTY(SZ7->Z7_GRAPROV)
					DBSelectarea("SCR")
					DBSetOrder(2)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= "1" 		 // Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= "N/D"	 // Rastreabilidade
						MSUnlock()
					ENDIF	
				ELSE 	
					_aWF	 		:= EnviaPA(TMP->CR_FILIAL, TMP->CR_NUM, SZ7->Z7_USUINCL , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV) , TMP->CR_TOTAL, ctod('  /  /  '), '     ', _nOpc)
	
					DBSelectarea("SCR")
					DBSetOrder(2)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= _aWF[1]							// Rastreabilidade
						MSUnlock()
					ENDIF
				ENDIF		
				_lProcesso := .T.
							
				dbSelectArea("TMP")
				DBSkip()
			End
			
			dbSelectArea("TMP")
			dbCloseArea()
	END CASE			
	
	IF 	_lProcesso 
		U_CONSOLE(" Mensagem processada " )
	ELSE
		U_CONSOLE(" Nao houve processamento")
	ENDIF	
					
	RETURN
	


Static Function EnviaPA(_cFilial,_cNum, _cUser, _cChave, _nTotal, _dDTLimit, _cHRLimit, _nOpc)
	Local _cHttp		:= GetNewPar("MV_WFDHTTP", "http://189.20.203.131:9898")

	Local _cTo	   		:= IIF(_nOpc == 1, _cUser ,alltrim(FWSFALLUSERS({_cUser})[1][5]))
	Local _cEmail		:= alltrim(FWSFALLUSERS({_cUser})[1][5])
	Local _nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
	Local _cTimeOut		:= GetNewPar("MV_WFTOPC","24:00")
	Local _dDataLib		:= IIF( !EMPTY(_dDTLimit), _dDTLimit, MSDATE() )
	Local _cHoraLib		:= IIF( !EMPTY(_cHRLimit), _cHRLimit, LEFT(TIME(),5) )
	Local _nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60) 
//	Local _nVrSC		:= 0
    Local _cUnidReq		:= "" 
    Local nSaldoc       :=0
    Local nVlrSC7       :=0
	Local nPercAdPc     :=0
    Local nPercAdC      :=0
	Local nValAdt       :=0
	_cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  )) // Indica se os processos de workflow estใo ativos para envio de e-mail.
	_cTo		:= IIF(_nOpc == 1, _cUser , Iif(!Empty(_cDestFixo),_cDestFixo,alltrim(FWSFALLUSERS({_cUser})[1][5]))) //MV_WFXDEST, tipo texto: Se preenchido com um endere็o de e-mail, deverแ ocorrer desvio de todos os processos de workflow para este endere็o. Se o parโmetro nใo existir seguirแ o fluxo normal.

//	_aTimeOut	:= U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)

//	Private _aPedidos:= {}       

	//------------------- VALIDACAO
	_lError := .F.
	if Empty(_cTo)
		aMsg := {}
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		aADD(aMsg , REPLICATE('*',80) )
		aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
		aADD(aMsg , "Pagamento antecipado No: " + _cNum + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(_cUser) )
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
              
	_cChaveSCR	:= _cFilial + 'PA' + _cNum
	_cNum 		:= PADR(_cNum,TamSX3("Z7_NUMSEQ")[1])

	DBSelectArea("SCR")
	DBSetOrder(2)
	DBSeek(_cChave)

	DBSelectArea("SZ7")
	DBSetOrder(1)
	DBSeek(xFilial("SZ7")+_cNum)  
	
	nValAdt:= SZ7->Z7_VALOR + SZ7->Z7_VALORAD// Valor que esta sendo adiantado + os valores adiantados anteriores para o pedido ou contrato
        
	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+cFilAnt)          

//WELLINGTON MENDES INCLUSAO DE PERCENTUAL JA ADIANTADO E VLR/SALDO DE PEDIDO E CONTRATOS.	
	If !EMPTY(SZ7->Z7_CONTRA)  //QUANDO O ADT ษ PARA CONTRATO
		DBSelectArea("CN9")
		DbSetOrder(1)
		DbSeek(xFilial("CN9")+SZ7->Z7_CONTRA+SZ7->Z7_REVISAO)
		nSaldoC := CN9->CN9_SALDO
		nPercAdC:= (nValAdt/nSaldoC) *100
	
	Else//caso contrario o adiantamento ้ para pedido
		DBSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial("SC7")+SZ7->Z7_NUMPED)                                                         
		While SC7->(!Eof()) .And. xFilial('SC7') == SC7->C7_FILIAL .And. SC7->C7_NUM == SZ7->Z7_NUMPED
		nVlrSC7 += SC7->C7_TOTAL	
		SC7->(DbSkip())	
		EndDo
   		nPercAdPc:= (nValAdt/nVlrSC7)*100
	Endif
	

	
//	DBSelectArea("SE4")
//	DBSetOrder(1)
//	DBSeek(xFilial("SE4")+SC7->C7_COND)
/*
	DBSelectArea("SAL")
	DBSetOrder(3)
	DBSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APROV)
 */
	DO CASE 
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao
				oProcess          	:= TWFProcess():New( "000001", "Envio Aprovacao PA :" + _cFilial + "/" +  TRIM(_cNum) )
				oProcess			:NewTask( "Envio PA : "+_cFilial + _cNum, "\WORKFLOW\HTML\PAAPROV_RENOVA.HTM" )
				oProcess:cSubject 	:= "["+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)+"] Aprovacao PA: "+  _cNum
				oProcess:bReturn  	:= "U_WKFPA(2)"
		
		CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
				oProcess          	:= TWFProcess():New( "000003", "Envio p/comprador PA aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PA aprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PARESP_RENOVA.HTM" )
				oProcess:cSubject 	:= "["+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)+"] Adiantamento APROVADO: "  +  _cNum
				_cResposta			:= " A P R O V A D O "
			
		CASE _nOpc == 4		// Envio de email Reprovado para solicitante
				oProcess          	:= TWFProcess():New( "000004", "Envio p/comprador PA reprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PA reprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PARESP_RENOVA.HTM" )
				oProcess:cSubject 	:= "["+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)+"] Adiantamento REPROVADO: "  +  _cNum
				_cResposta			:= "<font color='#FF0000'>R E P R O V A D O </font>"
	
	ENDCASE

	_cTo 				:= Iif(!Empty(_cDestFixo),_cDestFixo,_cTo) //MV_WFXDEST, tipo texto: Se preenchido com um endere็o de e-mail, deverแ ocorrer desvio de todos os processos de workflow para este endere็o. Se o parโmetro nใo existir seguirแ o fluxo normal.
	oProcess:cTo      	:= _cTo
	oProcess:UserSiga	:= _cUser
	oProcess:NewVersion(.T.)
	
 	oHtml     				:= oProcess:oHTML

	IF _nOpc == 1
		oHtml:ValByName( "CFILANT"	   , xFilial("SCR"))
		oHtml:ValByName( "CHAVE"	   , _cChave)
		oHtml:ValByName( "WFID"		   , oProcess:fProcessId)
		oHtml:ValByName( "OBS"		   , "" )
		
	ENDIF

	IF _nOpc == 3 .OR. _nOpc == 4
		oHtml:ValByName( "mensagem"  	, _cResposta)	 
	ENDIF
   
	oHtml:ValByName( "Z7_EMISSAO"	,	DtoC(SZ7->Z7_EMISSAO) )
	oHtml:ValByName( "Z7_FILIAL"	,	SZ7->Z7_FILIAL 	)
	oHtml:ValByName( "Z7_FILNOM"	,	Posicione("SM0",1,cEmpAnt+xFilial("SZ7"),"M0_FILIAL") 	)
	oHtml:ValByName( "Z7_FORNECE"	,	SZ7->Z7_FORNECE )
	oHtml:ValByName( "Z7_LOJA"		,	SZ7->Z7_LOJA 	)
	oHtml:ValByName( "A2_NREDUZ"	,	Posicione("SA2",1,xFilial("SA2")+SZ7->Z7_FORNECE+SZ7->Z7_LOJA,"A2_NREDUZ") )
	oHtml:ValByName( "Z7_VENCTO"	,	DtoC(SZ7->Z7_VENCTO) )
	oHtml:ValByName( "Z7_VALOR"		,	TRANSFORM( SZ7->Z7_VALOR,PesqPict("SZ7", "Z7_VALOR") ) )
	oHtml:ValByName( "Z7_VALORAD"	,	TRANSFORM( nValAdt,PesqPict("SZ7", "Z7_VALORAD") ) )//VALOR QUE ESTA SENDO ADIANTADO NO MOMENTO + TOTAL DE ADIANTAMENTOS JA REALIZADOS PARA O PEDIDO OU CONTRATO
	oHtml:ValByName( "Z7_NATUREZ"	,	SZ7->Z7_NATUREZ+" ["+Alltrim(Posicione("SED",1,xFilial("SED")+SZ7->Z7_NATUREZ,"ED_DESCRIC"))+"]" )
	oHtml:ValByName( "Z7_CCUSTO"	,	SZ7->Z7_CCUSTO +" ["+Alltrim(Posicione("CTT",1,xFilial("CTT")+SZ7->Z7_CCUSTO ,"CTT_DESC01"))+"]"	)
	oHtml:ValByName( "Z7_ITEMCTA"	,	SZ7->Z7_ITEMCTA+" ["+Alltrim(Posicione("CTD",1,xFilial("CTD")+SZ7->Z7_ITEMCTA,"CTD_DESC01"))+"]"    )
	oHtml:ValByName( "Z7_CLVL"		,	SZ7->Z7_CLVL   +" ["+Alltrim(Posicione("CTH",1,xFilial("CTH")+SZ7->Z7_CLVL  ,"CTh_DESC01"))+"]"	)
	oHtml:ValByName( "Z7_EC05DB"	,	SZ7->Z7_EC05DB +" ["+Alltrim(Posicione("CV0",1,xFilial("CV0")+"05"+SZ7->Z7_EC05DB  ,"CV0_DESC"))+"]")	
	
	_cConta := Alltrim(Posicione("SED",1,xFilial("SED")+SZ7->Z7_NATUREZ,"ED_CONTA"))
	
	oHtml:ValByName( "Z7_CONTA"		,	_cConta  +" ["+Alltrim(Posicione("CT1",1,xFilial("CT1")+_cConta  ,"CT1_DESC01"))+"]"	)
	oHtml:ValByName( "Z7_NUMSEQ"	,	SZ7->Z7_NUMSEQ 	)
	oHtml:ValByName( "Z7_NUMPED"	,	SZ7->Z7_NUMPED 	)
	//oHtml:ValByName( "Z7_NUMTIT"	,	SZ7->Z7_NUMTIT 	)
	oHtml:ValByName( "Z7_CONTRA"	,	SZ7->Z7_CONTRA 	)
	oHtml:ValByName( "Z7_PABCO"		,	SZ7->Z7_PABCO 	)
	oHtml:ValByName( "Z7_PAAGENC"	,	SZ7->Z7_PAAGENC )
	oHtml:ValByName( "Z7_PACONTA"	,	SZ7->Z7_PACONTA )
	oHtml:ValByName( "Z7_USUINCL"	,	SZ7->Z7_USUINCL )
	oHtml:ValByName( "Z7_USUNAME"	,	UsrFullName(SZ7->Z7_USUINCL) )
	oHtml:ValByName( "Z7_OBS"		,	SZ7->Z7_OBS )              
	oHtml:ValByName( "CTSALDO"      ,   IIF(nSaldoC > 0, TRANSFORM(nSaldoC,PesqPict("CN9", "CN9_SALDO")),0)) //saldo do contrato    
	oHtml:ValByName( "NVALPED"      ,   IIF(nVlrSC7 > 0, TRANSFORM(nVlrSC7,PesqPict("SC7", "C7_TOTAL")),0)) //Valor total do pedido de compra    
	oHtml:ValByName( "NPERCENT"     ,   IIF(nPercAdC > 0, nPercAdC, nPercAdPc)) //Percentual ja adiantado sobre pedido ou contrato
		
	//-------------------------------------------------------------
	// ALIMENTA A TELA DE PROCESSO DE APROVAวรO DE PEDIDO DE COMPRA
	//-------------------------------------------------------------
	
//	_cCHAVESCR := SUBS(_cCHAVE, 1, 24)
	
	DBSelectarea("SCR")
	DBSetOrder(1)
	DBSeek(_cCHAVESCR,.T.)
	
	WHILE !SCR->(EOF()) .AND. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) == _cCHAVESCR
		cSituaca := ""
		Do Case
             Case SCR->CR_STATUS == "01"
                     cSituaca := "Aguardando"
             Case SCR->CR_STATUS == "02"
                     cSituaca := "Em Aprovacao"
             Case SCR->CR_STATUS == "03"
                     cSituaca := "Aprovado"
             Case SCR->CR_STATUS == "04"
                     cSituaca := "Bloqueado"
                     lBloq := .T.
             Case SCR->CR_STATUS == "05"
                     cSituaca := "Nivel Liberado"
        EndCase	
                                             
		_cT4 := UsrRetName(SCR->CR_USERLIB)
		_cT6 := SCR->CR_OBS
		
		AAdd( (oHtml:ValByName( "t1.1"    )), SCR->CR_NIVEL)
		AAdd( (oHtml:ValByName( "t1.2"    )), UsrFullName(SCR->CR_USER))
		AAdd( (oHtml:ValByName( "t1.3"    )), cSituaca    )
		AAdd( (oHtml:ValByName( "t1.4"    )), IIF(EMPTY(_cT4),"", _cT4))
		AAdd( (oHtml:ValByName( "t1.5"    )), DTOC(SCR->CR_DATALIB))
		AAdd( (oHtml:ValByName( "t1.6"    )), IIF(EMPTY(_cT6),"", _cT6))  
		
		SCR->(DBSkip())
   ENDDO

	
	// ARRAY DE RETORNO
	_aReturn := {}
	AADD(_aReturn, oProcess:fProcessId)
	AADD(_aReturn, "")
	AADD(_aReturn, "")

	oProcess:nEncodeMime := 0

	DO CASE
		CASE _nOpc == 1
			oProcess:cTo      		:= nil
			oProcess:NewVersion(.T.)
			oHtml     				:= oProcess:oHTML
			oProcess:nEncodeMime 	:= 0
			cMailID 				:= oProcess:Start("\workflow\emp"+cEmpAnt+"\wfpa\")   //Faz a gravacao do e-mail no cPath
	
			AADD(_aReturn, cMailID)  // para gravar o nome do html na SCR
		
			chtmlfile  				:= cMailID + ".htm"
			
			oProcess:newtask("Link"			, "\workflow\html\Link_renova.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
			
			oHtml:ValByName( "cDocto"	    , "Aprova็ใo de Adiantamento No. "+SZ7->Z7_NUMSEQ)
			oHtml:ValByName( "descproc"	    , "O Adiantamento abaixo aguarda sua aprova็ใo. Para visualizแ-lo clique no link abaixo:")
			oHtml:ValByName( "cNomeProcesso", Alltrim(GetMv("MV_WFDHTTP")) + "/workflow/emp" + cempant + "/wfpa/" + chtmlfile ) // envia o link onde esta o arquivo html
			
			oProcess:cTo 	  := Iif(!Empty(_cDestFixo),_cDestFixo, alltrim(FWSFALLUSERS({_cUser})[1][5])) //MV_WFXDEST, tipo texto: Se preenchido com um endere็o de e-mail, deverแ ocorrer desvio de todos os processos de workflow para este endere็o. Se o parโmetro nใo existir seguirแ o fluxo normal.
			oProcess:cSubject := "Aprovacao de Adiantamento: "+SZ7->Z7_NUMSEQ + " - " +Posicione("SM0",1,cEmpAnt+xFilial("SZ7"),"M0_FILIAL")
			oProcess:Start()
			
			
		OTHERWISE       
				oProcess:cSubject    := "WORKFLOW  - Adiantamento No. " + _cNum + Iif(_nOpc=3," APROVADO"," REPROVADO")
				oProcess:Start()
	END CASE
	return _aReturn

	  

	