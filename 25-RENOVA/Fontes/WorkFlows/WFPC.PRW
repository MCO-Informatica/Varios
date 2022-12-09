#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

//Chamada por empresa
User Function WFPC()
	Local _nEmp
	Local _lAtivo
	Private _aMatriz  := {"00","0030001"}  // para abrir a 1a empresa //
	Private _aEmpresa := {}
	Conout('Inicio do processamento - PC() ' )
	RpcSetType(3)
	RpcSetEnv(_aMatriz[1],_aMatriz[2])
    _lAtivo:= SuperGetMv( "MV_WFXATIVO" , .F. , .F. ,  ) // Indica se os processos de workflow estใo ativos para envio de e-mail.
    
	If _lAtivo
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se o JOB ja estiver em execucao, nao continua            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF !LockByName("WFPC")
			Conout("JOB de aprova็ใo de PC jแ estava em execu็ใo: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()										// Limpa o ambiente, liberando a licen็a e fechando as conex๕es
	    	RETURN
	    ENDIF
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(_aMatriz[1],.F.)
		WHILE !SM0->(EOF())
			Aadd(_aEmpresa, {SM0->M0_CODIGO,Alltrim(SM0->M0_CODFIL)})
			SM0->(DBSkip())
		END
		RpcClearEnv()
	    For _nEmp := 1 To Len(_aEmpresa)
			U_PC({_aEmpresa[_nEmp]})
	    Next
		Conout('Final do processamento - SC() ' )
	Else
		Conout('Parametro MV_WFXATIVO estแ como .F....  - PC() ' )
	Endif
   	Return

//Chamada por empresa - TimeOut
User Function WFPC_TO()
	Local _nEmpTO
	Local _lAtivo

	Private _aMatrizTO  := {"00","0030001"}  // para abrir a 1a empresa //
	Private _aEmpresaTO := {}
	Conout('Inicio do processamento - PC() ' )
	RpcSetType(3)
	RpcSetEnv(_aMatrizTO[1],_aMatrizTO[2])
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se o JOB ja estiver em execucao, nao continua            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    _lAtivo:= SuperGetMv( "MV_WFXATIVO" , .F. , .F. ,  ) // Indica se os processos de workflow estใo ativos para envio de e-mail.
    
	If _lAtivo
		IF !LockByName("WFPC_TO")
			Conout("JOB de aprova็ใo de PC (TIMEOUT) jแ estava em execu็ใo: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()	// Limpa o ambiente, liberando a licen็a e fechando as conex๕es
	    	RETURN
	    ENDIF
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(_aMatrizTO[1],.F.)
		WHILE !SM0->(EOF())
			Aadd(_aEmpresaTO, {SM0->M0_CODIGO,Alltrim(SM0->M0_CODFIL)})
			SM0->(DBSkip())
		END
		RpcClearEnv()
	    For _nEmpTO := 1 To Len(_aEmpresaTO)
			U_PC_TO({_aEmpresaTO[_nEmpTO]})
	    Next
		Conout('Final do processamento - PC_TO() ' )
	Else
		Conout('Parametro MV_WFXATIVO estแ como .F....  - PC_TO() ' )
	Endif
   	Return

User Function PC( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => PC()")
		RETURN
	EndIf
	RpcSetType(3)
	RpcSetEnv(aParam[1][1],aParam[1][2])
	U_CONSOLE('PC(aParam)inicio:' + aParam[1][1]   +'/'+ aParam[1][2])
	U_WKFPC(1)  		// 1 - ENVIO SC PARA APROVADORES
	U_WKFPC(3)  		// 3 - ENVIO SC ITENS APROVADOS PARA SOLICITANTE
	U_WKFPC(4)  		// 4 - ENVIO SC ITENS REPROVADOS PARA SOLICITANTE
	RpcClearEnv()
	U_CONSOLE('PC(aParam) final:' + aParam[1][1]   +'/'+ aParam[1][2])
	RETURN

User Function PC_TO( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => PC()")
		RETURN
	EndIf
	RpcSetType(3)
	RpcSetEnv(aParam[1][1],aParam[1][2])
	U_CONSOLE('PC_TO(aParam)inicio:' + aParam[1][1]   +'/'+ aParam[1][2])
	U_WKFPC(5)  		// 4 - ENVIO SC ITENS REPROVADOS PARA SOLICITANTE
	RpcClearEnv()
	U_CONSOLE('PC_TO(aParam) final:' + aParam[1][1]   +'/'+ aParam[1][2])
	RETURN
		
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWKFPC     บAutor  ณMicrosiga           บ Data ณ  18/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 - ENVIO DE EMAIL PARA APROVADORES                        บฑฑ
ฑฑบ          ณ 2 - RETORNO DE EMAIL COM RESPOSTA DE APROVADORES           บฑฑ
ฑฑบ          ณ 3 - ENVIA RESPOSTA DE PEDIDO APROVADO PARA O COMPRADOR	  บฑฑ
ฑฑบ          ณ 4 - ENVIA RESPOSTA DE PEDIDO APROVADO PARA O COMPRADOR	  บฑฑ
ฑฑบ          ณ 5 - ENVIO DE EMAIL - ACAO TIMEOUT                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WKFPC(_nOpc, oProcess)      
	Local _lProcesso := .F.
	Local _cFilial, _cOpcao, _cObs, _cChaveSCR
	
	Local nSaldo 		:= 0 , 	nSalDif 	:= 0  ,	cTipoLim  	:= ""
	Local aRetSaldo 	:={} ,	cAprov    	:= "" , cObs 		:= ""
	Local nTotal    	:= 0 , 	cGrupo	 	:= "" , lLiberou	:= .F.
	
	ChkFile("SCR")
	ChkFile("SAL")
	ChkFile("SC7")
	ChkFile("SCS")                    
	ChkFile("SAK")                    
	ChkFile("SM2")                    
	ChkFile("SE4")
	ChkFile("SC1")
	ChkFile("SC8")
	ChkFile("SA2")
	ChkFile("SB1")
	ChkFile("SBM")
	ChkFile("SCR")
	ChkFile("SC7")
	CHKFile("SAL")
	CHKFile("SD1")
	
	DO 	CASE 
	
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ1 - Prepara os pedidos a serem enviados para aprovacaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	
		CASE _nOpc == 1
	
			U_CONSOLE("1 - Prepara os pedidos a serem enviados para aprovacao")
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
		  	_cQuery += " CR_FILIAL = '" + xFilial("SCR") + "'"
		  	_cQuery += " AND CR_TIPO = 'PC'" 
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
            
				DBSelectArea("SC7")
				DBSetOrder(1)
				DBSeek(xFilial("SC7")+LEFT(TMP->CR_NUM,6))

				IF EMPTY(SC7->C7_APROV)
					DBSelectarea("SCR")
					DBSetOrder(2)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= "1" 		 // Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= "N/D"	 // Rastreabilidade
						MSUnlock()
					ENDIF	
				ELSE 	
					DBSelectArea("SC7")
					DBSetOrder(1)
					DBSeek(xFilial("SC7")+LEFT(TMP->CR_NUM,6))

					If  !empty(TMP->CR_DTLIMIT)
						IF TMP->CR_DTLIMIT == DTOS(MSDATE())
							IF TMP->CR_HRLIMIT  >  LEFT(TIME(),5)
								TMP->(DBSkip())
								LOOP						
							ENDIF
						ENDIF
					Endif	    

					_aWF	 		:= EnviaPC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) , TMP->CR_TOTAL, STOD(TMP->CR_DTLIMIT), TMP->CR_HRLIMIT, _nOpc)
					
					_lProcesso 	:= .T.
			
					DBSelectarea("SCR")
					DBSetOrder(2)   
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						Reclock("SCR",.F.)
                        u_console("_aWF[1]......: "+_aWF[1])
						SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= _aWF[1]		// Rastreabilidade
						SCR->CR_DTLIMIT		:= _aWF[2]		// Data Limite
						SCR->CR_HRLIMIT		:= _aWF[3]		// Hora Limite
						SCR->CR_WFLINK		:= _aWF[4]		// Arquivo HTML
						MSUnlock()     
								
					ENDIF
				ENDIF
				
				TMP->(DBSkip())           
			End
			
			dbSelectArea("TMP")
			dbCloseArea()

	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ2 - Processa O RETORNO DO EMAIL                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
		CASE _nOPC	== 2
	
			U_CONSOLE("2 - Processa O RETORNO DO EMAIL")
			U_CONSOLE("2 - EmpFil:" + cEmpAnt + cFilAnt)

			cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
			cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
			cFilAnt		:= padr(alltrim(oProcess:oHtml:RetByName("CFILANT")),7)
			__cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
			_cAprov    	:= alltrim(oProcess:oHtml:RetByName("CR_USER"))
			_cChaveSCR	:= Padr(__cChaveSCR,54)+_cAprov
			cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
//			cTo   		:= alltrim(oProcess:aParams[1])   //SUBS( alltrim(oProcess:cRetFrom), AT('<',alltrim(oProcess:cRetFrom)) + 1 , LEN(alltrim(oProcess:cRetFrom))-AT('<',alltrim(oProcess:cRetFrom))-1 )   			

			oProcess:Finish() // FINALIZA O PROCESSO
			
			U_CONSOLE("2 - cFilAnt    :" + cFilAnt)
			U_CONSOLE("2 - __cChaveSCR:" + __cChaveSCR)
			U_CONSOLE("2 - Opc        :" + cOpc)
			U_CONSOLE("2 - Obs        :" + cObs)
			U_CONSOLE("2 - WFId       :" + cWFID)
//			U_CONSOLE("2 - cTo        :" + cTo)
			U_CONSOLE("2 - _cAprov    :" + _cAprov)
//			U_CONSOLE("2 - _cChaveSCR :" + _cChaveSCR)

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

				// Verifica se o pedido de compra esta aprovado
				// Se estiver, finaliza o processo
				dbSelectArea("SC7")
				dbSetOrder(1)
				dbSeek(xFilial("SC7")+LEFT(SCR->CR_NUM,6))

				IF SC7->C7_CONAPRO <> "B"  // NAO ESTIVER BLOQUEADO
					U_CONSOLE("2 - Processo ja respondido via sistema :" + cWFID)
					Return .T.
				ENDIF

				// REPosiciona na tabela de Alcadas 
				DBSelectArea("SCR")
				DBSetOrder(2)
				DBSeek(__cChaveSCR)
				
				// verifica quanto a saldo de al็ada para aprova็ใo				
				// Se valor do pedido estiver dentro do limite Maximo e minimo 
				// Do aprovador , utiliza o controle de saldos, caso contrแrio nao
				// faz o tratamento como vistador.

				nTotal := SCR->CR_TOTAL
				
				lLiberou := MaAlcDoc({SCR->CR_NUM,"PC",nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))
				
				U_CONSOLE("2 - Liberado :" + IIF(lLiberou, "Sim", "Nao"))

				_lProcesso := .T.
				
				If lLiberou
					dbSelectArea("SC7")
					dbSetOrder(1)
					dbSeek(xFilial("SC7")+LEFT(SCR->CR_NUM,6))
			        While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == SCR->CR_FILIAL+LEFT(SCR->CR_NUM,6)
		                Reclock("SC7",.F.)
		                SC7->C7_CONAPRO 	:= "L"
		                MsUnlock()
		                dbSkip()
			        EndDo
				EndIf
			EndIf				

	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ3 - Envia resposta de pedido aprovado para o compradorณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	
		CASE _nOpc == 3
			U_CONSOLE("3 - Envia resposta de pedido APROVADO para o comprador")
			U_CONSOLE("3 - EmpFil:" + cEmpAnt + cFilAnt)
		  	_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " C7_FILIAL," 
		  	_cQuery += " C7_NUM,"
		  	_cQuery += " C7_ITEM,"    
		  	_cQuery += " C7_USER"   
		  	_cQuery += " FROM " + RetSqlName("SC7") + " SC7"
		  	_cQuery += " WHERE SC7.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND C7_FILIAL   = '" + xFilial("SC7") + "'"
			_cQuery += " AND C7_TIPO=1      "				// 1-Pedido de compra
			_cQuery += " AND C7_CONAPRO='L' "				// Liberado
			_cQuery += " AND C7_APROV <> '      ' "			// Grupo Aprovador
		  	_cQuery += " AND C7_WF <> '1'"	      			// 1 Enviado EMAIL
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C7_FILIAL," 
		  	_cQuery += " C7_NUM,"
		  	_cQuery += " C7_ITEM"
			TcQuery _cQuery New Alias "TMP"
			dbGotop()
			While !TMP->(Eof())
				_cNum	   := TMP->C7_NUM
				DBSelectarea("SCR")
				DBSetOrder(1)
				DBSeek(TMP->(C7_FILIAL+"PC"+_cNum),.T.)
				_lAchou  := .F.
				_lAprov	:= .F.
				_cChave	:= ''
				_nTotal	:= 0
				While !SCR->(EOF()) 						.AND. ;
	    		   	SCR->CR_FILIAL		== TMP->C7_FILIAL  	.AND. ;
	      			SCR->CR_TIPO 	    == "PC" 			.AND. ;
	        		SCR->CR_NUM         == Padr(TMP->C7_NUM,50)
	        		IF SCR->CR_STATUS == '03' .AND. !EMPTY(SCR->CR_LIBAPRO)   // SOMENTE CASO APROVADO
        				_cChave	:= SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
        				_lAprov	:= .T.
						_lAchou  := .T.        				
        				_nTotal	:= SCR->CR_TOTAL
        			ENDIF
	        		SCR->(DBSkip())
	        	End
				IF !_lAchou
					DBSelectarea("SC7")
					DBSetOrder(1)
					IF DBSeek(TMP->(C7_FILIAL+C7_NUM+C7_ITEM))
						Reclock("SC7",.F.)
						SC7->C7_WF			:= "1"   	                        // Status 1 - envio email
			  			SC7->C7_WFID		:= "N/D"   									// Rastreabilidade
						MSUnlock()
						TMP->(DBSkip())
					ENDIF
				ENDIF
	    		IF _lAprov
					_aWF:= EnviaPC(TMP->C7_FILIAL, Padr(TMP->C7_NUM, len(SCR->CR_NUM)), TMP->C7_USER , _cChave, _nTotal, ctod('  /  /  '), '     ',_nOpc)
//					EnvPCFor(TMP->C7_FILIAL, TMP->C7_NUM, TMP->C7_USER , _cChave, _nTotal, ctod('  /  /  '), '     ')
					_lProcesso 	:= .T.
					While !TMP->(EOF()) .AND. _cNum == TMP->C7_NUM 
						DBSelectarea("SC7")
						DBSetOrder(1)
						IF DBSeek(TMP->(C7_FILIAL+C7_NUM+C7_ITEM))
							Reclock("SC7",.F.)
							SC7->C7_WF			:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
				  			SC7->C7_WFID		:= _aWF[1]							// Rastreabilidade
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
	
			U_CONSOLE("4 - Envia resposta de pedido bloqueado para o comprador")
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
		  	_cQuery += " AND CR_TIPO = 'PC'"                            // PEDIDO DE COMPRA
		  	_cQuery += " AND CR_WF <> '1'"	      					    	// 1-Enviado
		  	
		  	_cQuery += " ORDER BY"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL,"
		  	_cQuery += " CR_USER"
		  	
			TcQuery _cQuery New Alias "TMP"
		                            
			dbGotop()
			While !TMP->(Eof())
				DBSelectArea("SC7")
				DBSetOrder(1)
				DBSeek(xFilial("SC7")+ LEFT(TMP->CR_NUM,6))

				IF EMPTY(SC7->C7_APROV)
					DBSelectarea("SCR")
					DBSetOrder(2)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= "1" 		 	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= "N/D"		   // Rastreabilidade
						MSUnlock()
					ENDIF	
				ELSE 				
					_aWF	 		:= EnviaPC(TMP->CR_FILIAL, TMP->CR_NUM, SC7->C7_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV) , TMP->CR_TOTAL, ctod('  /  /  '), '     ', _nOpc)
	
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

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ5 - ENVIO de Email - Acao TIME-OUT             		 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
		CASE _nOpc	== 5
	
				U_CONSOLE("5 - Acao TimeOut - PC")
	
				CHKFile("SAL")
				CHKFile("SCR")
				CHKFile("SC7")
				ChkFile("SCS")                    
				ChkFile("SAK")                    
				ChkFile("SM2")                    
				
				U_CONSOLE("5.1 - Libera็ใo")
				TimeOut("1")	// LIBERAวรO
	
				U_CONSOLE("5.2 - Bloqueio")
				TimeOut("2")	// BLOQUEIO
	
				U_CONSOLE("5.3 - Notifica็ใo")
				TimeOut("3")	// NOTIFICAวรO
			
	END CASE			
	
	IF 	_lProcesso 
		U_CONSOLE(" Mensagem processada " )
	ELSE
		U_CONSOLE(" Nao houve processamento")
	ENDIF	
					
	RETURN
	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaPC   บAutor  ณMicrosiga           บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaPC(_cFilial,_cNum, _cUser, _cChave, _nTotal, _dDTLimit, _cHRLimit, _nOpc)
	Local _cHttp		:= GetNewPar("MV_WFDHTTP", "http://189.20.203.131:9898")
	Local _cTo	   		:= IIF(_nOpc == 1, _cUser ,alltrim(FWSFALLUSERS({_cUser})[1][5]))
	Local _cEmail		:= alltrim(FWSFALLUSERS({_cUser})[1][5])
	Local _nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
	Local _cTimeOut		:= GetNewPar("MV_WFTOPC","24:00")
	Local _dDataLib		:= IIF( !EMPTY(_dDTLimit), _dDTLimit, MSDATE() )
	Local _cHoraLib		:= IIF( !EMPTY(_cHRLimit), _cHRLimit, LEFT(TIME(),5) )
	Local _nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60) 
	Local _nVrSC		:= 0
    Local _cUnidReq		:= ""


	_cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  )) // Indica se os processos de workflow estใo ativos para envio de e-mail.
	_cTo		:= IIF(_nOpc == 1, _cUser , Iif(!Empty(_cDestFixo),_cDestFixo,alltrim(FWSFALLUSERS({_cUser})[1][5]))) //MV_WFXDEST, tipo texto: Se preenchido com um endere็o de e-mail, deverแ ocorrer desvio de todos os processos de workflow para este endere็o. Se o parโmetro nใo existir seguirแ o fluxo normal.

	_aTimeOut	:= U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)

	Private _aPedidos:= {}       

	//------------------- VALIDACAO
	_lError := .F.
	if Empty(_cTo)
		aMsg := {}
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		aADD(aMsg , REPLICATE('*',80) )
		aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
		aADD(aMsg , "Pedido de Compra No: " + _cNum + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(_cUser) )
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
              
	_cChaveSCR	:= _cFilial + 'PC' + _cNum
	_cNum 		:= PADR(ALLTRIM(_cNum),6)

	DBSelectArea("SCR")
	DBSetOrder(2)
	DBSeek(_cChave)

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+cFilAnt)
	
	DBSelectArea("SC7")
	DBSetOrder(1)
	DBSeek(_cFilial+_cNum)

	DBSelectArea("SA2")
	DBSetOrder(1)
	DBSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	_cFornece := SC7->C7_FORNECE
	_cLojaFor := SC7->C7_LOJA

	DBSelectArea("SE4")
	DBSetOrder(1)
	DBSeek(xFilial("SE4")+SC7->C7_COND)

	DBSelectArea("SAL")
	DBSetOrder(3)
	DBSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APROV)

	DBSELECTAREA("CTT")
	DBSetOrder(1)
	DBSeek(xFilial("CTT")+SC7->C7_CC)
	_cCCusto := SC7->C7_CC

	_cVersao := ""
	DBSelectArea("SCY")
	DBSetOrder(1)
	DBSeek(_cFilial+_cNum) 
	
	While SCY->CY_FILIAL + SCY->CY_NUM == _cFilial+_cNum .AND. !SCY->(EOF())
		_cVersao := Alltrim(SCY->CY_VERSAO)
		SCY->(DbSkip())
	Enddo

	DO CASE 
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao
				oProcess          	:= TWFProcess():New( "000001", "Envio Aprovacao PC :" + _cFilial + "/" +  TRIM(_cNum) )
				oProcess			:NewTask( "Envio PC : "+_cFilial + _cNum, "\WORKFLOW\HTML\PCAPROV_RENOVA.HTM" )
				oProcess:cSubject 	:= "["+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)+"] Aprovacao pedido de compra: "+  _cNum
				oProcess:bReturn  	:= "U_WKFPC(2)"
		
		CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
				oProcess          	:= TWFProcess():New( "000003", "Envio p/comprador PC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC aprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PCRESP_RENOVA.HTM" )
				oProcess:cSubject 	:= "["+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)+"] Pedido de compra APROVADO: "  +  _cNum
				_cResposta			:= " A P R O V A D O "
			
		CASE _nOpc == 4		// Envio de email Reprovado para solicitante
				oProcess          	:= TWFProcess():New( "000004", "Envio p/comprador PC reprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC reprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PCRESP_RENOVA.HTM" )
				oProcess:cSubject 	:= "["+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)+"] Pedido de compra REPROVADO: "  +  _cNum
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
   
	//Cabecalho
	oHtml:ValByName( "CEMPFIL"		, Alltrim(SM0->M0_NOME) + " / "+ SM0->M0_FILIAL )
	oHtml:ValByName( "CFILANT"		, SM0->M0_CODFIL )
	oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM )
	oHtml:ValByName( "C7_EMISSAO"	, DTOC(SC7->C7_EMISSAO) )
	oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI)
	oHtml:ValByName( "C7_USER"		, UsrFullName(SC7->C7_USER))
	oHtml:ValByName( "CR_USER"		, _cUser )
	oHtml:ValByName( "A2_NOME"		, SA2->A2_NOME + " " + SA2->A2_COD)
//  _cUnidReq := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC + SC7->C7_ITEMSC,"SC1->C1_UNIDREQ")
//	oHtml:ValByName( "C1_UNIDREQ"	, _cUnidReq + " - " +Posicione("SY3",1,xFilial("SY3")+_cUnidReq,"SY3->Y3_DESC"))
	oHtml:ValByName( "C7_FILENT"	, SC7->C7_FILENT)

	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
	//-------------------------------------------------------------
	_nC7_TOTAL		:= 0
	_nC7_VLDESC		:= 0
	_nDESPESA		:= 0   
	_cTipo			:= ""
	_cCC			:= SC7->C7_CC

	// Loop Itens PC
	aTemp			:= {}
	aProd			:= {}

	lEnEmail		:= .T.
	
	While !SC7->(EOF()) .AND. SC7->C7_FILIAL == _cFilial .AND. SC7->C7_NUM == _cNum

        _nVrSC := 0
		DBSELECTAREA("SB1")
		DBSetOrder(1)
		DBSeek(xFilial()+SC7->C7_PRODUTO)
		
		DBSELECTAREA("SBM")
		DBSetOrder(1)
		DBSeek(xFilial()+SB1->B1_GRUPO)
                                                        
		AAdd( (oHtml:ValByName( "t.1"    )), SC7->C7_ITEM)
	  	_cUnidReq := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC + SC7->C7_ITEMSC,"SC1->C1_UNIDREQ")
		AAdd( (oHtml:ValByName( "t.1a"   )), _cUnidReq)
//		AAdd( (oHtml:ValByName( "t.2"    )), SC7->C7_PRODUTO)
		AAdd( (oHtml:ValByName( "t.2"    )), Alltrim(SB1->B1_DESC) + Iif(!Empty(SC7->C7_OBS)," - " + SC7->C7_OBS,""))
		AAdd( (oHtml:ValByName( "t.3"    )), TRANSFORM(SC7->C7_QUANT,'@E 999,999.99'))
		AAdd( (oHtml:ValByName( "t.4"    )), SB1->B1_UM)
        _nVarSC := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC + SC7->C7_ITEMSC,"SC1->C1_VLESTIM")
		
		AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(_nVarSC,'@E 99,999,999.99'))
		AAdd( (oHtml:ValByName( "t.5a"   )), TRANSFORM(SC7->C7_PRECO,'@E 99,999,999.99'))  //SC1->C1_VLESTIM
//		AAdd( (oHtml:ValByName( "t.8"    )), TRANSFORM(SC7->C7_IPI,'@E 99.99'))
		AAdd( (oHtml:ValByName( "t.6"    )), TRANSFORM(SC7->C7_TOTAL + SC7->C7_VALIPI,'@E 99,999,999,999.99'))
//		AAdd( (oHtml:ValByName( "t.10"   )), SC7->C7_DATPRF)
		AAdd( (oHtml:ValByName( "t.7"    )), Alltrim(Posicione("CTT",1,xfilial("CTT")+SC7->C7_CC,"CTT->CTT_DESC01")))
		AAdd( (oHtml:ValByName( "t.8"	 )), Alltrim(Posicione("CV0",1,xFilial("CV0")+"05"+SC7->C7_EC05DB  ,"CV0_DESC")))	
//		AAdd( (oHtml:ValByName( "t.9"    )), _cTpCompra)
		AAdd( (oHtml:ValByName( "t.10"   )), Alltrim(Posicione("CTD",1,xfilial("CTD")+SC7->C7_ITEMCTA,"CTD->CTD_DESC01"))) //ITEM CONTABIL
		AAdd( (oHtml:ValByName( "t.11"   )), Alltrim(Posicione("CTH",1,xfilial("CTH")+SC7->C7_CLVL   ,"CTH->CTH_DESC01"))) // CLASSE VR CONTABIL
		AAdd( (oHtml:ValByName( "t.12"   )), SC7->C7_NUMSC)
        
        Aadd(_aPedidos,{SC7->C7_ITEM, SC7->C7_PRODUTO} )
		_nC7_TOTAL 	:= _nC7_TOTAL 	+ SC7->C7_TOTAL + SC7->C7_VALIPI
		_nC7_VLDESC	:= _nC7_VLDESC	+ SC7->C7_VLDESC
		_nDESPESA 	:= _nDESPESA 	+ (SC7->C7_VALFRE + SC7->C7_DESPESA + SC7->C7_SEGURO)    
		
		SC7->(dbSkip()) 
	Enddo

	oHtml:ValByName( "C7_TOTAL"	    , TRANSFORM(_nC7_TOTAL 	,'@E 99,999,999.99'))
	oHtml:ValByName( "DESPESA"   	, TRANSFORM(_nDESPESA  	,'@E 99,999,999.99'))
	oHtml:ValByName( "C7_VLDESC" 	, TRANSFORM(_nC7_VLDESC	,'@E 99,999,999.99'))
	oHtml:ValByName( "CR_TOTAL"		, TRANSFORM(_nC7_TOTAL + _nDESPESA - _nC7_VLDESC,'@E 99,999,999.99'))

/*
COMENTADO A PEDIDO DO WELLINGTON EM 28 DE SETEMBRO DE 2015
	If _nOpc == 1
//      Imprimir os 3 ultimos pedidos para este item
	    _aSC7 := {}    
		For j = 1 to len(_aPedidos)   
		
			_cSelPed := " SELECT C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME, C7_QUANT, "
			_cSelPed += " C7_PRECO, C7_IPI , C7_EMISSAO, C7_DATPRF, C7_COND, E4_DESCRI, C7_QUJE "
			_cSelPed += " FROM (SELECT C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME, "
			_cSelPed += " C7_QUANT,C7_PRECO, C7_IPI , C7_EMISSAO, C7_DATPRF, C7_COND, E4_DESCRI, C7_QUJE "
			_cSelPed += "      FROM "+RetSqlName('SC7')+" SC7, "+RetSqlName('SA2')+" SA2, "+RetSqlName('SE4')+" SE4 "
			_cSelPed += "     WHERE C7_PRODUTO = '"+_aPedidos[j,2]+"'"
			_cSelPed += "       AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA  "
			_cSelPed += "       AND C7_COND       = E4_CODIGO"
			_cSelPed += "       AND C7_QUJE <> 0  "
			_cSelPed += "       AND C7_ENCER <> ' '  "
			_cSelPed += "  AND SC7.D_E_L_E_T_ = ' '  AND SA2.D_E_L_E_T_ = ' ' AND SE4.D_E_L_E_T_ = ' '" 
			_cSelPed += "  ORDER BY C7_EMISSAO DESC) TOP_SC7 "
			_cSelPed += "  WHERE rownum <= 3 "
			_cSelPed += "  ORDER BY rownum "
		
 			_cSelPed := ChangeQuery(_cSelPed)
 			TCQUERY _cSelPed NEW ALIAS "ULTC7"
	   		dbGoTop()     
			_lPedidos := .F.
			While !Eof()
                Aadd( _aSC7, {_aPedidos[j,1], ;
			    			  ULTC7->C7_NUM , ;   
			    			  ULTC7->A2_NOME, ;
			    			  TRANSFORM(ULTC7->C7_QUANT,'@E 99,999,999.99'), ;
			    			  TRANSFORM(ULTC7->C7_PRECO,'@E 99,999,999.999')  , ;
			    			  TRANSFORM(ULTC7->C7_IPI , '@E 99.99')     , ;
			    			  DtoC(StoD(ULTC7->C7_EMISSAO)) , ;
			    			  DtoC(StoD(ULTC7->C7_DATPRF))  , ;
			    			  ULTC7->E4_DESCRI              , ;
			    			  TRANSFORM(ULTC7->C7_QUJE,'@E 999,999.99') ;
			    			   } )
				_lPedidos := .t.
				DbSkip()	
			EndDo
			DbSelectArea("ULTC7")
			DbCloseArea("ULTC7")
		Next
		If !_lPedidos
//	 		_cExibe  := "<p><font color='#FF0000'>*** Nใo hแ historico de pedidos ***</font></p>"
			AAdd( (oHtml:ValByName( "tp.1"  )), " " )
			AAdd( (oHtml:ValByName( "tp.2"  )), " " )
			AAdd( (oHtml:ValByName( "tp.3"  )), " " )
			AAdd( (oHtml:ValByName( "tp.4"  )), " " )
			AAdd( (oHtml:ValByName( "tp.5"  )), " " )
			AAdd( (oHtml:ValByName( "tp.6"  )), " " )
			AAdd( (oHtml:ValByName( "tp.7"  )), " " )
//			AAdd( (oHtml:ValByName( "tp.8"  )), " " )
//			AAdd( (oHtml:ValByName( "tp.9"  )), " " )
			AAdd( (oHtml:ValByName( "tp.10" )), " " )
			
		Else	
//		    Asort(_aSC7,,, { |x,y| x[1]+x[7] < y[1]+y[7] } )
	   		_cItem := ""
		    For _j := 1 To Len(_aSC7)   
				AAdd( (oHtml:ValByName( "tp.1"  )), Iif(_aSC7[_j][1] == _cItem,"",_aSC7[_j][1]) )
				AAdd( (oHtml:ValByName( "tp.2"  )), _aSC7[_j][2] )
				AAdd( (oHtml:ValByName( "tp.3"  )), _aSC7[_j][3] )
				AAdd( (oHtml:ValByName( "tp.4"  )), _aSC7[_j][4] )
				AAdd( (oHtml:ValByName( "tp.5"  )), _aSC7[_j][5] )
				AAdd( (oHtml:ValByName( "tp.6"  )), _aSC7[_j][6] )
				AAdd( (oHtml:ValByName( "tp.7"  )), _aSC7[_j][7] )
//				AAdd( (oHtml:ValByName( "tp.8"  )), _aSC7[_j][8] )
//				AAdd( (oHtml:ValByName( "tp.9"  )), _aSC7[_j][9] )
				AAdd( (oHtml:ValByName( "tp.10" )), _aSC7[_j][10] )
		   		_cItem := _aSC7[_j][1]
			Next
		EndIf
	Endif	
*/
	
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
	AADD(_aReturn, _aTimeOut[3])
	AADD(_aReturn, _aTimeOut[4])

	oProcess:nEncodeMime := 0

	DO CASE
		CASE _nOpc == 1
			oProcess:cTo:= "000000"
			cProcess := oProcess:Start("\workflow\wfpc\")
                     
			AADD(_aReturn, cProcess)  // para gravar o nome do html na SCR

			cSubject    := Alltrim(SM0->M0_NOME)+" - Aprova็ใo de Pedido de compra No. " + _cNum

			aMsg := {}
			aaDD(aMsg, "Sr. Aprovador,")
			aaDD(aMsg, "Preparamos o documento abaixo para sua aprova็ใo.")  
			AADD(aMsg, "<br></br>")
			aaDD(aMsg, "["+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)+"] Aprovacao Pedido de compra: "+  _cNum+"</i>")  
			aaDD(aMsg, "Pedido de compra: <i>"+_cNum+"</i>")  
//			aaDD(aMsg, "Solicitante: <i>"+_cUserSC1+"</i>")  
//			aaDD(aMsg, "Unid.Requisitante: <i>"+ _cUnidReq+"</i>" )  
			aaDD(aMsg, "Valor: <i>"+ TRANSFORM(_nTotal,'@E 999,999,999.99')+"</i>")  
			AADD(aMsg, "<br></br>")
			AADD(aMsg, '<a href="' + _cHttp + '/workflow/wfpc/'  + alltrim(cProcess) + '.htm">Visualizar pedido de compra</a>')
			AADD(aMsg, "<br></br>")
			AADD(aMsg, "C๓digo de controle : <i>" + oProcess:fProcessId + "</i>")
			AADD(aMsg, "<br></br>")
			AADD(aMsg, "Atenciosamente,")
			AADD(aMsg, "Workflow Servi็o de Mensagens")
			_cEmail := Iif(!Empty(_cDestFixo),_cDestFixo,_cEmail) //MV_WFXDEST, tipo texto: Se preenchido com um endere็o de e-mail, deverแ ocorrer desvio de todos os processos de workflow para este endere็o. Se o parโmetro nใo existir seguirแ o fluxo normal.
			U_MailNotify( _cEmail, cSubject , aMsg )

		OTHERWISE       
				oProcess:cSubject    := "WORKFLOW  - Pedido de compra No. " + _cNum +Iif(_cVersao <> ""," Revisใo: "+_cVersao +" - ","") + Iif(_nOpc=3," APROVADO"," REPROVADO")
				oProcess:Start()
	END CASE
	return _aReturn

	  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTimeOUT   บAutor  ณMicrosiga           บ Data ณ  10/22/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP7 TimeOut -                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TimeOut(_cAcao)
	Local _cQuery               
	_cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  )) // Indica se os processos de workflow estใo ativos para envio de e-mail.


  	_cQuery := ""
  	_cQuery += " SELECT DISTINCT "
  	_cQuery += " CR_FILIAL, "
  	_cQuery += " CR_TIPO,"
  	_cQuery += " CR_NUM,"
  	_cQuery += " CR_EMISSAO,"
  	_cQuery += " CR_NIVEL,"
  	_cQuery += " CR_USER,"
  	_cQuery += " CR_APROV,"
  	_cQuery += " CR_TOTAL,"
  	_cQuery += " CR_DTLIMIT,"
  	_cQuery += " CR_HRLIMIT "
  	_cQuery += " CR_WFLINK,"
  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
  	_cQuery += " JOIN " + RetSqlName("SAL") + " SAL ON (AL_FILIAL = '" + xFilial('SAL') + "' AND AL_APROV = CR_APROV AND AL_ACAO = '" + _cAcao + "' AND SAL.D_E_L_E_T_ = ' ' )"		
  	_cQuery += " WHERE SCR.D_E_L_E_T_ = ' '"		
// 	_cQuery += " AND CR_FILIAL 	= '" + xFilial('SCR') +"'" // comentado, para con solidar filiais
  	_cQuery += " AND CR_STATUS 	= '02'"				
  	_cQuery += " AND CR_TIPO 	= 'PC'"				
  	_cQuery += " AND CR_DTLIMIT  <= '" + DTOS(MSDATE()) + "'"
  	_cQuery += " AND CR_WF 	= '1'"		
  	_cQuery += " AND CR_WFID 	<> ' '"		
  	_cQuery += " AND CR_WFLINK <> '"+Space(20)+"'"
  	_cQuery += " ORDER BY"
  	_cQuery += " CR_USER," 
  	_cQuery += " CR_DTLIMIT,"
  	_cQuery += " CR_HRLIMIT"

	TcQuery _cQuery New Alias "TMP"

	dbGotop()

	IF !TMP->(Eof())
		DO CASE 
			CASE _cAcao $ '1|2'
				While !TMP->(Eof())
					IF TMP->CR_DTLIMIT == DTOS(MSDATE())
						IF TMP->CR_HRLIMIT  >  LEFT(TIME(),5)
							TMP->(DBSkip())
							LOOP						
						ENDIF
					ENDIF
                                
					// EXECUTA AS VALIDAวีES SOBRE AS ALวADAS
					// Posiciona na tabela de Alcadas 
					DBSelectArea("SCR")
					DBSetOrder(1)
					DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL))
					
					IF !FOUND()    
						//"Este processo nao foi encontrado e portanto deve ser descartado
						// abre uma notificacao a pessoa que respondeu
						
						U_CONSOLE("5 - Alcada nao encontrada" + TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL))
						TMP->(DBSkip())
						LOOP
					ENDIF
					
					Reclock("SCR",.F.)
					SCR->CR_WF		:= "2"			// Status 2 - respondido
                    SCR->CR_OBS     := cObs
					MSUnlock()

					// NOTIFICA USUARIO DO PROCEDIMENTO AUTOMATICO						
					cTo		:= alltrim(FWSFALLUSERS({TMP->CR_USER})[1][5])
					cTo 	:= Iif(!Empty(_cDestFixo),_cDestFixo,alltrim(FWSFALLUSERS({TMP->CR_USER})[1][5])) //MV_WFXDEST, tipo texto: Se preenchido com um endere็o de e-mail, deverแ ocorrer desvio de todos os processos de workflow para este endere็o. Se o parโmetro nใo existir seguirแ o fluxo normal.
					aMsg   := {}   
					IF _cAcao == '1'
						cTitle	:= "Libera็ใo Automแtica do Pedido de compra No."  + TMP->CR_FILIAL+"-"+TMP->CR_NUM
						AADD(aMsg, Dtoc(MSDate()) + " - " + Time() + " * Liberado automaticamente pelo Administrador (Workflow) a ")
					ENDIF
					IF _cAcao == '2'
						cTitle	:= "Bloqueio Automแtico do Pedido de compra No."  + TMP->CR_FILIAL+"-"+TMP->CR_NUM
						AADD(aMsg, Dtoc(MSDate()) + " - " + Time() + " * Bloqueada automaticamente pelo Administrador (Workflow) a ")
					ENDIF
					AADD(aMsg, "Pedido de compras No: " + TMP->CR_FILIAL+"-"+TMP->CR_NUM + " sendo ")
					AADD(aMsg, "que a aprovacao deste pedido de compras por voc๊ excedeu o tempo as " +DTOC(STOD(TMP->CR_DTLIMIT)) + '-' + TMP->CR_HRLIMIT + ".")
					U_MailNotify(cTo, cTitle, aMsg)

					If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05" 
						U_CONSOLE("5 - Doc ja respondido " + TMP->(CR_FILIAL+CR_TIPO+CR_NUM))
						TMP->(DBSkip())
						LOOP
					EndIf
					cOpc 	:= Iif(_cAcao='1',"S","N")                                                  
					cObs	:= Iif(_cAcao='1',"Liberado ","Bloqueado")+ " por Timeout"
	
					// Verifica se o pedido de compra esta aprovado
					// Se estiver, finaliza o processo
					dbSelectArea("SC7")
					dbSetOrder(1)
					dbSeek(xFilial()+Alltrim(SCR->CR_NUM))
	
					IF SC7->C7_CONAPRO <> "B"  // NAO ESTIVER BLOQUEADO
						U_CONSOLE("5 - Pedido ja liberado " + TMP->(CR_FILIAL+CR_TIPO+CR_NUM))
						TMP->(DBSkip())
						LOOP
					ENDIF
					lLiberou := MaAlcDoc({TMP->CR_NUM,"PC",0,TMP->CR_APROV,,TMP->CR_APROV,,,,,},msdate(),If(cOpc=="S",4,6),,cObs)

					U_CONSOLE("5 - Pedido de compras " + TMP->(CR_FILIAL+CR_TIPO+CR_NUM) + " Respondido automaticamente")

					If lLiberou
						dbSelectArea("SC7")
						dbSetOrder(1)
						dbSeek(xFilial()+LEFT(SCR->CR_NUM,6))
				        While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == SCR->CR_FILIAL+LEFT(SCR->CR_NUM,6)
			                Reclock("SC7",.F.)
			                SC7->C7_CONAPRO 	:= "L"
			                MsUnlock()
			                dbSkip()
				        EndDo
					EndIf
				Enddo	
			CASE _cAcao == '3'
		            
				   	_cUser		:= ""         
					_cTimeOut	:= GetNewPar("MV_WFTOPC","24:00")		// WF-Workflow TO-TimeOut PC - Pedido Compra
				
					While !TMP->(Eof())
				
						IF TMP->CR_DTLIMIT == DTOS(MSDATE())
							IF TMP->CR_HRLIMIT  >  LEFT(TIME(),5)
								TMP->(DBSkip())
								LOOP						
							ENDIF
						ENDIF

						IF _cUser <> TMP->CR_USER
							_cUser 		:= TMP->CR_USER
							_aReg	 	:= {}
						ENDIF
					
						_nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
						_cTimeOut	:= IIF(!EMPTY(TMP->AL_TIMEOUT),TMP->AL_TIMEOUT, _cTimeOut )
						_nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60)
						_aTimeOut	:= U_GetTimeOut(_nTimeOut, StoD(TMP->CR_DTLIMIT),TMP->CR_HRLIMIT)
				
						DBSelectArea("SCR")
						DBSetOrder(2)
						DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						IF FOUND()
							RECLOCK("SCR",.F.)
							SCR->CR_DTLIMIT	:= _aTimeOut[3]	
							SCR->CR_HRLIMIT	:= _aTimeOut[4]
							MSUNLOCK()
						ENDIF
				
						AADD( _aReg, {;
								TMP->CR_FILIAL,;
								TMP->CR_NUM, ;
								DTOC(STOD(TMP->CR_EMISSAO)), ;
                                "",;
								DTOC(STOD(TMP->CR_DTLIMIT)) + '-' + TMP->CR_HRLIMIT, ;
								TMP->CR_NIVEL, ;
								UsrRetName(TMP->CR_USER),;
								TMP->CR_WFLINK})
/*						AADD( _aReg, {;
								TMP->CR_FILIAL + "-" +TMP->CR_NUM, ;
								DTOC(STOD(TMP->CR_EMISSAO)), ;
                                "",;
								DTOC(STOD(TMP->CR_DTLIMIT)) + '-' + TMP->CR_HRLIMIT, ;
								TMP->CR_NIVEL, ;
								UsrRetName(TMP->CR_USER),;
								UsrRetMail(TMP->CR_USER)})
*/
						aMsg    := {}   	
//						cTo		:= UsrRetMail(TMP->CR_USER)
//						cTitle	:= "TimeOut Pedido de Compras No." + TMP->CR_FILIAL+"-"+TMP->CR_NUM
//						AADD(aMsg, Dtoc(MSDate()) + " - " + Time() + " * Notificado o usuario comprador " + UsrRetName(_cUser))
//						AADD(aMsg, " que a aprovacao deste pedido de compras excedeu o tempo as " +DTOC(STOD(TMP->CR_DTLIMIT)) + '-' + TMP->CR_HRLIMIT + ".")
//						U_MailNotify(cTo, cTitle, aMsg)
						dbSelectArea("TMP")
						DBSkip()
				
						dbSelectArea("SC7")
						dbSetOrder(1)
						dbSeek(xFilial()+LEFT(SCR->CR_NUM,6)) 
						_cUser := SC7->C7_USER

						IF (TMP->(EOF()) .OR. _cUser <> TMP->CR_USER) .AND. !EMPTY(_cUser)
							TO_Notif(_cUser, _aReg)
						ENDIF
					END		
		ENDCASE
	ENDIF
			
	dbSelectArea("TMP")
	dbCloseArea()
	
	RETURN 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTO_NOTIF  บAutor  ณMicrosiga           บ Data ณ  10/22/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP7 TimeOut - Notificacao                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TO_Notif(_cUser, _aReg)
		
	_aReg		:= aSort(_aReg,,,{ |x,y| x[01]+x[02] < y[01]+y[02] })
	_cTo 			:= Iif(!Empty(_cDestFixo),_cDestFixo,alltrim(FWSFALLUSERS({_cUser})[1][5])) //MV_WFXDEST, tipo texto: Se preenchido com um endere็o de e-mail, deverแ ocorrer desvio de todos os processos de workflow para este endere็o. Se o parโmetro nใo existir seguirแ o fluxo normal.

	//-------------------------------------
	//------------------- VALIDACAO
	if Empty(_cTo)
		
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		cBody	:= REPLICATE('*',80) 
		cBody	+= Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' 
		cBody	+= "Time-Out PC - Usuario : " + UsrRetName(_cUser) 
		cBody	+= "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" 
		cBody	+= REPLICATE('*',80) 
		
		U_Console("TimeOutPC() - " + CHR(10) + CHR(13) + cBody)
		
		U_NotifyAdm(cTitle, cBody)
		RETURN
	Endif
   
	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt)

	oProcess          	:= TWFProcess():New( "000005", "PC-Time-Out Pedido de Compra / " + _cUser )
	oProcess          	:NewTask( "Time-Out de resposta PC Cod.User :"+_cUser, "\WORKFLOW\HTML\PCNOTIF_RENOVA.HTM" )
	oProcess:cSubject 	:= OemToAnsi("Pedidos de compra pendentes de aprova็ใo")
	oProcess:cTo      	:= _cTo
	oProcess:UserSiga	:= _cUser
	oProcess:NewVersion(.T.)

	// OBJETO OHTML                   
  	oHtml     			:= oProcess:oHTML

	// CABEวALHO 
	oHtml:ValByName( "CEMPANT" 	 	, cEmpAnt+" - "+SM0->M0_NOME)
	oHtml:ValByName( "USER"  	 	, UsrRetName(_cUser))			// Usuario
	oHtml:ValByName( "DATA_HORA" 	, DTOC(MSDATE()) + ' - ' + LEFT(TIME(),5) )				// Data e hora da geracao

	For _nInd := 1 TO Len(_aReg)
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(cEmpAnt + _aReg[_nInd][1])
		AAdd( (oHtml:ValByName( "t.1"    )), SM0->M0_FILIAL)
		AAdd( (oHtml:ValByName( "t.2"    )), _aReg[_nInd][2])
		AAdd( (oHtml:ValByName( "t.3"    )), _aReg[_nInd][3])
//		AAdd( (oHtml:ValByName( "t.4"    )), _aReg[_nInd][4])
		AAdd( (oHtml:ValByName( "t.5"    )), _aReg[_nInd][5])
		AAdd( (oHtml:ValByName( "t.6"    )), _aReg[_nInd][6])
		AAdd( (oHtml:ValByName( "t.7"    )), _aReg[_nInd][7])
		AAdd( (oHtml:ValByName( "t.8"    )), '<a href="' + _cHttp + '/workflow/wfpc/'  + alltrim(_aReg[_nInd][8]) + '.htm">Visualizar pedido de compra</a>')
	Next
	
	// ARRAY DE RETORNO
	oProcess:nEncodeMime := 0
	oProcess:Start()
	RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณEnvPCFor   บAutor  ณPedro Augusto      บ Data ณ 02/04/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Renova Energia                                             บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnvPCFor(_cFilial,_cNum, _cUser, _cChave, _nTotal, _dDTLimit, _cHRLimit, _nOpc)

	_cChaveSCR	:= PADR(_cFilial + 'PC' + _cNum,54)
	_cNum 		:= PADR(ALLTRIM(_cNum),6)

	DBSelectArea("SCR")
	DBSetOrder(2)
	DBSeek(_cChave)

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+cFilAnt)
	
	DBSelectArea("SC7")
	DBSetOrder(1)
	DBSeek(_cFilial+_cNum)

	DBSelectArea("SA2")
	DBSetOrder(1)
	DBSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

	DBSelectArea("SE4")
	DBSetOrder(1)
	DBSeek(xFilial("SE4")+SC7->C7_COND)

	_cTo	   		:= Alltrim(SA2->A2_EMAIL)

/*
	_lError := .F.
	if Empty(_cTo)
		aMsg := {}
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		aADD(aMsg , REPLICATE('*',80) )
		aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
		aADD(aMsg , "Pedido de Compra No: " + _cNum + " Filial : " + cFilAnt + " Fornecedor : " + SA2->A2_NOME )
		aADD(aMsg , "Campo EMAIL do cadastro de Fornecedores NAO PREENCHIDO. Favor solicitar a alteracao do cadastro ao setor competente " )
		aADD(aMsg , REPLICATE('*',80) )
		_lError := .T.
	Endif
                                                
	IF _lError
		U_NotifyAdm(cTitle, aMsg)
		_aReturn := {}
		AADD(_aReturn, "")
		AADD(_aReturn, _aTimeOut[1])
		AADD(_aReturn, _aTimeOut[2])
		
		RETURN _aReturn
	ENDIF
*/

	oProcess          	:= TWFProcess():New( "000006", "Envio p/fornecedor PC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
	oProcess          	:NewTask( "Envio PC aprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PCFORN_RENOVA.HTM" )

	oProcess:cTo      	:= _cTo

 	oHtml     				:= oProcess:oHTML

    //Cabecalho//
	oHtml:ValByName( "C7_FILIAL"	, SM0->M0_FILIAL )
	oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM )
	oHtml:ValByName( "C7_EMISSAO"	, DTOC(SC7->C7_EMISSAO) )

    //Dados Empresa - RENOVA
	oHtml:ValByName( "C_NOME"		, SM0->M0_NOMECOM)
	oHtml:ValByName( "C_CNPJ"	  	, SM0->M0_CGC)
	oHtml:ValByName( "C_ENDER" 		, Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_CIDCOB)  + " - " + Alltrim(SM0->M0_ESTCOB))
	oHtml:ValByName( "C_CEP"	 	, SM0->M0_CEPCOB )
	oHtml:ValByName( "C_TELFAX" 	, Alltrim(SM0->M0_TEL) + Iif(Alltrim(SM0->M0_FAX) == "",""," / "+SM0->M0_FAX))
	oHtml:ValByName( "C_CONTATO"	, UsrFullNameSC7->C7_USER)
	oHtml:ValByName( "C_EMAIL"		, alltrim(FWSFALLUSERS({SC7->C7_USER})[1][5]))
    //Dados Fornecedor
	oHtml:ValByName( "V_NOME"		, SA2->A2_NOME )
	oHtml:ValByName( "V_CNPJ"	  	, Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")) )
	oHtml:ValByName( "V_ENDER" 		, Alltrim(SA2->A2_END ) + " - " +Alltrim(SA2->A2_NR_END ) + " - " + Alltrim(SA2->A2_MUN )  + " - " + Alltrim(SA2->A2_EST ))
	oHtml:ValByName( "V_CEP"	 	, SA2->A2_CEP )
	oHtml:ValByName( "V_TELFAX" 	, Alltrim(SA2->A2_TEL) + Iif(Alltrim(SA2->A2_FAX) == "",""," / "+SA2->A2_FAX))
	oHtml:ValByName( "V_CONTATO"	, SA2->A2_CONTATO)
	oHtml:ValByName( "V_EMAIL"		, SA2->A2_EMAIL)

	//Dados cond. pagamento
	oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI)

	//Dados Garantia
	//oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI)

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+SC7->C7_FILENT)
	
	// Dados local entrega
	oHtml:ValByName( "E_NOME"		, SM0->M0_NOMECOM)
	oHtml:ValByName( "E_CNPJ"	  	, SM0->M0_CGC)
	oHtml:ValByName( "E_ENDER" 		, Alltrim(SM0->M0_ENDENT) + " - " + Alltrim(SM0->M0_CIDENT)  + " - " + Alltrim(SM0->M0_ESTENT))
	oHtml:ValByName( "E_CEP"	 	, SM0->M0_CEPCOB )

	//oHtml:ValByName( "C7_FILENT"	, SC7->C7_FILENT)

	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
	//-------------------------------------------------------------
	_nTOTMERC	:= 0
	_nSEGURO	:= 0
	_nFRETE		:= 0
	_nDESPESA	:= 0
	_nDESCONTO	:= 0
//	_nVALTOT	:= 0   

	While !SC7->(EOF()) .AND. SC7->C7_FILIAL == _cFilial .AND. SC7->C7_NUM == _cNum

		DBSELECTAREA("SB1")
		DBSetOrder(1)
		DBSeek(xFilial()+SC7->C7_PRODUTO)
		
		DBSELECTAREA("SBM")
		DBSetOrder(1)
		DBSeek(xFilial()+SB1->B1_GRUPO)
                                                        
		AAdd( (oHtml:ValByName( "t.1"    )), SC7->C7_ITEM)
		AAdd( (oHtml:ValByName( "t.2"    )), Alltrim(SB1->B1_DESC) + Iif(!Empty(SC7->C7_OBS)," - " + SC7->C7_OBS,""))
		AAdd( (oHtml:ValByName( "t.3"    )), SB1->B1_UM)
		AAdd( (oHtml:ValByName( "t.4"    )), TRANSFORM(SC7->C7_QUANT ,'@E 99,999,999.99'))
		AAdd( (oHtml:ValByName( "t.5"    )), SC7->C7_PRODUTO)
		AAdd( (oHtml:ValByName( "t.6"    )), TRANSFORM(SC7->C7_PRECO ,'@E 99,999,999.99'))
		AAdd( (oHtml:ValByName( "t.7"    )), TRANSFORM(SC7->C7_TOTAL ,'@E 99,999,999.99'))  
		AAdd( (oHtml:ValByName( "t.8"    )), TRANSFORM(SC7->C7_PICM  ,'@E 99.99'))
		AAdd( (oHtml:ValByName( "t.9"    )), TRANSFORM(SC7->C7_IPI   ,'@E 99.99'))
		AAdd( (oHtml:ValByName( "t.10"   )), TRANSFORM(SC7->C7_VALIPI,'@E 99,999,999.99'))
		AAdd( (oHtml:ValByName( "t.11"   )), SC7->C7_DATPRF)

		_nTOTMERC 	:= _nTOTMERC 	+ SC7->C7_TOTAL + SC7->C7_VALIPI
		_nSEGURO	:= _nSEGURO		+ SC7->C7_SEGURO
		_nFRETE		:= _nFRETE		+ SC7->C7_VALFRE
		_nDESPESA	:= _nDESPESA	+ SC7->C7_DESPESA
		_nDESCONTO	:= _nDESCONTO	+ SC7->C7_VLDESC
		
		SC7->(dbSkip()) 
	Enddo

	oHtml:ValByName( "VALMERC"	    , TRANSFORM(_nTOTMERC 	,'@E 99,999,999.99'))
	oHtml:ValByName( "SEGURO"   	, TRANSFORM(_nSEGURO  	,'@E 99,999,999.99'))
	oHtml:ValByName( "FRETE"	 	, TRANSFORM(_nFRETE		,'@E 99,999,999.99'))
	oHtml:ValByName( "DESPESA"	 	, TRANSFORM(_nDESPESA	,'@E 99,999,999.99'))
	oHtml:ValByName( "DESCONTO"	 	, TRANSFORM(_nDESCONTO	,'@E 99,999,999.99'))
	oHtml:ValByName( "VALTOT"		, TRANSFORM(_nTOTMERC + _nSEGURO + _nFRETE + _nDESPESA - _nDESCONTO,'@E 99,999,999.99'))

	
	// ARRAY DE RETORNO
	oProcess:nEncodeMime := 0

	oProcess:cSubject    := "PEDIDO DE COMPRA No. " + _cNum  + " APROVADO"
	oProcess:Start()
	return                                      
	