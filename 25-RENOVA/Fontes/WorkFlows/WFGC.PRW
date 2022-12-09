/*
Programa.: 	WFGC 
Autor....:	Pedro Augusto
Data.....: 	04/10/2015 
Descricao: 	Rotinas de :
			- envio de e-mail de contratos para aprovacao 
			- Tratamento das respostas via HTTP
			- envio de e-mail de contratos aprovados / reprovados aos USUARIOS
Uso......: 	RENOVA
*/
#include "rwmake.ch"       
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
                                                                            
/*
Chamada por empresa
*/
User Function WFGC()
	Local _nEmp   
	Local _lAtivo
	
	Private _aMatriz  := {"00","0030001"}  // para abrir a 1a empresa //
	Private _aEmpresa := {}  
	Conout('Inicio do processamento - GC() ' )
	RpcSetType(3)
	RpcSetEnv(_aMatriz[1],_aMatriz[2])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o JOB ja estiver em execucao, nao continua            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    _lAtivo:= SuperGetMv( "MV_WFXATIV" , .F. , .F. ,  ) // Indica se os processos de workflow estão ativos para envio de e-mail.
    
	If _lAtivo
		IF !LockByName("WFGC")
			Conout("JOB de aprovação de Inclusão de Contratos já estava em execução: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()										// Limpa o ambiente, liberando a licença e fechando as conexões
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
	
		U_CONSOLE("["+DtoC(Date())+" "+Time()+"]: Processando U_GC() " )
	
	    For _nEmp := 1 To Len(_aEmpresa)
			U_GC({_aEmpresa[_nEmp]})
	    Next
		U_CONSOLE("["+DtoC(Date())+" "+Time()+"]: Final do processamento - GC() " )
	Else
		Conout('Parametro MV_WFXATIV está como .F....  - GC() ' )
	Endif
   	Return
   	
/*                                                           
Prepara ambiente - Empresa / Filial
*/
User Function GC( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => GC()")
		RETURN
	EndIf
	RpcSetType(3)
	RpcSetEnv(aParam[1][1],aParam[1][2])
	U_CONSOLE('GC(aParam)inicio:' + aParam[1][1]   +'/'+ aParam[1][2])
	U_WKFGC(1)  		// 1 - ENVIO SC PARA APROVADORES
 	U_WKFGC(3)  		// 3 - ENVIO SC ITENS APROVADOS PARA SOLICITANTE
	U_WKFGC(4)  		// 4 - ENVIO SC ITENS REPROVADOS PARA SOLICITANTE
	RpcClearEnv()
	U_CONSOLE('GC(aParam) final:' + aParam[1][1]   +'/'+ aParam[1][2])
	RETURN

/*
Rotina principal:
			- envio de e-mail de CONTRATOS para aprovacao 
			- Tratamento das respostas via HTTP
			- envio de e-mail de contratos aprovados / reprovados aos usuarios
*/
		
User Function WKFGC(_nOpc, oProcess)      
	Local _lProcesso := .F.
	Local _cFilial, _cChaveSCR
	Local _cAprov    	:= "" , cObs 		:= ""
	Local nTotal    	:= 0 , 	cGrupo	 	:= "" , lLiberou	:= .F.
    Local cTipoSCR	:= ""

	Private _aWF    := {}
	Private _aReturn 
	Private	cNumRev := ''
	Private	aCampos	:= {}
	Private aHeader := {}
	Private aCols	:= {}  
	Private oModel  
	Private oModelCT   
	Private oModelCN9
	Private oModelCNA
	Private oModelCNB
	Private lAlcCtDoc
	Private lAlcCtEc
			
	ChkFile("SCR")
	ChkFile("SAL")
	ChkFile("CN9")
	ChkFile("SCS")                    
	ChkFile("SAK")                    
	ChkFile("SE4")
	ChkFile("SA2")
	ChkFile("SB1")
	ChkFile("SBM")
	
	DO 	CASE 
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³1 - Prepara os contratos a serem enviados para aprovacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
		CASE _nOpc == 1
	
//			U_CONSOLE("1 - Prepara os contratos a serem enviados para aprovacao")
//			U_CONSOLE("1 - EmpFil:" + cEmpAnt + cFilAnt)
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
//		  	_cQuery += " AND CR_TIPO = 'CT'" 
		  	_cQuery += " AND CR_TIPO = 'CT'" 
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
            
				DBSelectArea("CN9")
				DBSetOrder(1)
				DBSeek(xFilial("CN9")+LEFT(TMP->CR_NUM,18))  

				If Alltrim(CN9->CN9_REVISA) == ""  // Somente contratos, revisao é outra rotina
					IF EMPTY(CN9->CN9_APROV)
						DBSelectarea("SCR")
						DBSetOrder(2)
						IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
							Reclock("SCR",.F.)
							SCR->CR_WF			:= "1" 		 // Status 1 - envio para aprovadores / branco-nao houve envio
				  			SCR->CR_WFID		:= "N/D"	 // Rastreabilidade
	
						ENDIF	
					ELSE 	
						If  !empty(TMP->CR_DTLIMIT)
							IF TMP->CR_DTLIMIT == DTOS(MSDATE())
								IF TMP->CR_HRLIMIT  >  LEFT(TIME(),5)
									TMP->(DBSkip())
									LOOP						
								ENDIF
							ENDIF
						Endif	    
	
						_aWF	 		:= U_EnviaGC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) , TMP->CR_TOTAL, STOD(TMP->CR_DTLIMIT), TMP->CR_HRLIMIT, _nOpc)
						
						_lProcesso 	:= .T.
				
						DBSelectarea("SCR")
						DBSetOrder(2)   
						IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
							Reclock("SCR",.F.)
							SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
				  			SCR->CR_WFID		:= _aWF[1]		// Rastreabilidade
							SCR->CR_DTLIMIT		:= _aWF[2]		// Data Limite
							SCR->CR_HRLIMIT		:= _aWF[3]		// Hora Limite
							MSUnlock()     
									
						ENDIF
					ENDIF
				ENDIF					
				TMP->(DBSkip())           
			End
			
			dbSelectArea("TMP")
			dbCloseArea()

	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2 - Processa O RETORNO DO EMAIL                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
		CASE _nOPC	== 2
	
		U_CONSOLE("["+DtoC(Date())+" "+Time()+"]: 2 - Processa O RETORNO DO EMAIL")
		
		__cChaveSCR	:= oProcess:oHtml:RetByName("CHAVE")
		_cAprov    	:= alltrim(oProcess:oHtml:RetByName("CR_USER"))
		_cChaveSCR	:= Padr(__cChaveSCR,59)+_cAprov
		cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
		cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
		cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
		
		oProcess:Finish() // FINALIZA O PROCESSO
		
		U_CONSOLE("2 - cFilAnt    :" + cFilAnt)
		U_CONSOLE("2 - __cChaveSCR:" + __cChaveSCR)
		U_CONSOLE("2 - Opc        :" + cOpc)
		U_CONSOLE("2 - Obs        :" + cObs)
		U_CONSOLE("2 - WFId       :" + cWFID)
		U_CONSOLE("2 - _cAprov    :" + _cAprov)
		//			U_CONSOLE("2 - _cChaveSCR :" + _cChaveSCR)
		
		Begin Transaction
		
			// Posiciona na tabela de Alcadas
			DBSelectArea("SCR")
			DBSetOrder(2)
			DBSeek(__cChaveSCR)
			IF !FOUND()
				U_CONSOLE("2 - Processo nao encontrado : Not Found")
				Return .T.
			Endif
			If ALLTRIM(SCR->CR_WFID) <> ALLTRIM(cWFID)
				U_CONSOLE("2 - Processo nao encontrado :" + cWFID + " Processo atual :" + SCR->CR_WFID)
				Return .T.
			ENDIF
			
			IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
				_nRecSCR := SCR->(Recno())
				_lRet := .T. 	 
				Reclock("SCR",.F.)
				SCR->CR_WF		:= "2"			// Status 2 - respondido
				MSUnlock()
				conout(": _cChave: "+_cChaveSCR)
				//------------------------------------------------------//	
				If cOpc == "S"
					If CN9->(MsSeek(xFilial("CN9")+AllTrim(SCR->CR_NUM))) //Posiciona no contrato da aprovação
						_nRecnoCN9 := CN9->(Recno())
						//--Popula model da tela de contrato para ser feito validações da aprovação do contrato.
						oModelCT:= FWLoadModel(If(CN9->CN9_ESPCTR == "1","CNTA300","CNTA301"))
						oModelCT:SetOperation(4)  
						oModelCT:Activate()

						Cn300RetSt("COMPRA")		
					Endif								
				//Modelo MVC alterado pelo analista Ronaldo Dantas - TOTVS em 19/06/2018
					If Type('oModelCT') == "O"
						oModel := oModelCT

						_lLiberou := GCTAlcEnt(oModel,4,4,SCR->CR_TIPO,SCR->CR_NUM,Type('cNumRev'),Type('aCampos'),Type('aHeader'),Type('aCols'),Type('N'))							

						//FIM DO PROCESSO - Ronaldo Dantas - TOTVS em 19/06/2018.
					EndIf
				Else
					_lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_GRUPO,,,,,cObs},msdate(),If(cOpc=="S",4,6))
					IF cOpc == "N" 
						dbSelectArea("CN9")
						dbSetOrder(1)
						If dbSeek(xFilial("CN9")+SCR->CR_NUM)
							CN9->CN9_XWF 	:= " "
							MsUnlock()
						EndIf
						u_console("Contrato Rejeitado - Em Elabora?o" )
			  		ENDIF       	
				SCR->(DbGoTo(_nRecSCR))  
            Endif
		End Transaction	
	    End
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3 - Envia resposta de contratos aprovado para o usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
		CASE _nOpc == 3
//			U_CONSOLE("3 - Envia resposta de contrato aprovado para o usuario")
//			U_CONSOLE("3 - EmpFil:" + cEmpAnt + cFilAnt)
		  	_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " CN9_FILIAL," 
		  	_cQuery += " CN9_NUMERO,"
		  	_cQuery += " CN9_REVISA,"    
		  	_cQuery += " CN9_XCODUS "   
		  	_cQuery += " FROM " + RetSqlName("CN9") + " CN9"
		  	_cQuery += " WHERE CN9.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND CN9_FILIAL   = '" + xFilial("CN9") + "'"
			_cQuery += " AND CN9_SITUAC = '05' "				// Liberado
			_cQuery += " AND CN9_APROV <> '      ' "			// Grupo Aprovador
		  	_cQuery += " AND CN9_XWF <> '1'"	      			// 1 Enviado EMAIL
		  	_cQuery += " ORDER BY"
		  	_cQuery += " CN9_FILIAL," 
		  	_cQuery += " CN9_NUMERO,"
		  	_cQuery += " CN9_REVISA"
			TcQuery _cQuery New Alias "TMP"
			dbGotop()
			While !TMP->(Eof())
				If Alltrim(TMP->CN9_REVISA) == ""  // Somente contratos, revisao é outra rotina
					_cNum	   := TMP->CN9_NUMERO + TMP->CN9_REVISA
					
					cTipoSCR := "CT"				
					
					DBSelectarea("SCR")
					DBSetOrder(1)
					DBSeek(xFilial("SCR")+cTipoSCR+_cNum,.T.)
					_lAchou  := .F.
					_lAprov	:= .F.
					_cChave	:= ''
					_nTotal	:= 0
					While !SCR->(EOF()) 						.AND. ;
		    		   	SCR->CR_FILIAL		== xFilial("SCR") 	.AND. ;
		      			SCR->CR_TIPO 	    == cTipoSCR			.AND. ;
		        		SCR->CR_NUM         == Padr(_cNum,50)
		        		IF SCR->CR_STATUS == '03' .AND. !EMPTY(SCR->CR_LIBAPRO)   // SOMENTE CASO APROVADO
	        				_cChave	:= SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
	        				_lAprov	:= .T.
							_lAchou  := .T.        				
	        				_nTotal	:= SCR->CR_TOTAL
	        			ENDIF
		        		SCR->(DBSkip())
		        	End
					IF !_lAchou
						DBSelectarea("CN9")
						DBSetOrder(1)
						IF DBSeek(TMP->(CN9_FILIAL+CN9_NUMERO+CN9_REVISA))
							Reclock("CN9",.F.)
							CN9->CN9_XWF		:= "1"   	                        // Status 1 - envio email
				  			CN9->CN9_XWFID		:= "N/D"   									// Rastreabilidade
							MSUnlock()
							TMP->(DBSkip())
						ENDIF
					ENDIF
	
		    		IF _lAprov
						_aWF:= U_EnviaGC(TMP->CN9_FILIAL, TMP->CN9_NUMERO+TMP->CN9_REVISA, TMP->CN9_XCODUS , _cChave, _nTotal, ctod('  /  /  '), '     ',_nOpc)
	
						_lProcesso 	:= .T.
	
						DBSelectarea("CN9")
						DBSetOrder(1)
						IF DBSeek(TMP->(CN9_FILIAL+CN9_NUMERO+CN9_REVISA))
							Reclock("CN9",.F.)
							CN9->CN9_XWF		:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
				  			CN9->CN9_XWFID		:= _aWF[1]							// Rastreabilidade
							MSUnlock()
						ENDIF
				    ENDIF
				ENDIF
				TMP->(DBSkip())
			END
			dbSelectArea("TMP")
			dbCloseArea()

	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³4 - Envia resposta de contratos bloqueado para o usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
		CASE _nOpc == 4
	
//			U_CONSOLE("4 - Envia resposta de contratos bloqueado para o usuario")
//			U_CONSOLE("4 - EmpFil:" + cEmpAnt + cFilAnt)
			
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
//		  	_cQuery += " AND CR_LIBAPRO <> '      '" 							// Seleciona o Aprovador que reprovou
		  	_cQuery += " AND CR_STATUS = '04'"                          // REPROVADO
		  	_cQuery += " AND CR_TIPO = 'CT'"                            // contratos
		  	_cQuery += " AND CR_WF <> ' '"	      					    	// 1-Enviado
		  	_cQuery += " ORDER BY"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL,"
		  	_cQuery += " CR_USER"
		  	
			TcQuery _cQuery New Alias "TMP"
		                            
			dbGotop()
			While !TMP->(Eof())
				If Alltrim(CN9->CN9_REVISA) == ""  // Somente contratos, revisao é outra rotina
					DBSelectArea("CN9")
					DBSetOrder(1)
					DBSeek(xFilial("CN9")+ LEFT(TMP->CR_NUM,18))
	
					IF EMPTY(CN9->CN9_APROV)
						DBSelectarea("SCR")
						DBSetOrder(2)
						IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
							Reclock("SCR",.F.)
							SCR->CR_WF			:= "1" 		 	// Status 1 - envio para aprovadores / branco-nao houve envio
				  			SCR->CR_WFID		:= "N/D"		   // Rastreabilidade
							MSUnlock()
						ENDIF	
					ELSE 				
						_aWF	 		:= U_EnviaGC(TMP->CR_FILIAL, TMP->CR_NUM, CN9->CN9_XCODUS , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV) , TMP->CR_TOTAL, ctod('  /  /  '), '     ', _nOpc)
		
						DBSelectarea("SCR")
						DBSetOrder(2)
						IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
							Reclock("SCR",.F.)
							SCR->CR_WF			:= IIF(EMPTY(_aWF[1]),"1"," ")  	// Status 1 - envio para aprovadores / branco-nao houve envio
				  			SCR->CR_WFID		:= _aWF[1]							// Rastreabilidade
							MSUnlock()
						ENDIF
					ENDIF		
					_lProcesso := .T.
				ENDIF				
				dbSelectArea("TMP")
				DBSkip()
			End
			
			dbSelectArea("TMP")
			dbCloseArea()
	END CASE			
	
	IF 	_lProcesso 
		U_CONSOLE(" Mensagem processada " )
	ENDIF	
					
	RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaPC   ºAutor  ³Microsiga           º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER Function EnviaGC(_cFilial,_cNum, _cUser, _cChave, _nTotal, _dDTLimit, _cHRLimit, _nOpc)
	Local _cHttp		:= GetNewPar("MV_WFDHTTP", "http://189.20.203.131:9898")

	Local _cTo	   		:= IIF(_nOpc == 1, _cUser ,alltrim(FWSFALLUSERS({_cUser})[1][5]))
	Local _cEmail		:= alltrim(FWSFALLUSERS({_cUser})[1][5])
	Local _nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
	Local _cTimeOut		:= GetNewPar("MV_WFTOPC","24:00")
	Local _dDataLib		:= IIF( !EMPTY(_dDTLimit), _dDTLimit, MSDATE() )
	Local _cHoraLib		:= IIF( !EMPTY(_cHRLimit), _cHRLimit, LEFT(TIME(),5) )
	Local _nTimeOut  	:= 0
	Local lBloq 		:= .F.
	Local _cTipoCT		:= ""

//	_cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  )) // Indica se os processos de workflow estão ativos para envio de e-mail.
	_cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "pedroaugustoc@hotmail.com" ,  )) // Indica se os processos de workflow estão ativos para envio de e-mail.
	_cTo		:= IIF(_nOpc == 1, _cUser , Iif(!Empty(_cDestFixo),_cDestFixo,alltrim(FWSFALLUSERS({_cUser})[1][5]))) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.

	_aTimeOut	:= U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)

//	Private _aTimeOut	:= {MSDATE(),'00:00',MSDATE(), "00:00"}
	Private _aUnvige	                               

	//------------------- VALIDACAO
	_lError := .F.
	if Empty(_cTo)
		aMsg := {}
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		aADD(aMsg , REPLICATE('*',80) )
		aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
		aADD(aMsg , "Contrato No: " + _cNum + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(_cUser) )
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
              
	_cNum 		:= ALLTRIM(_cNum)

	DBSelectArea("SCR")
	DBSetOrder(2)
	DBSeek(_cChave)

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+cFilAnt)
	
	DBSelectArea("CN9")
	DBSetOrder(1)
	DBSeek(xFilial("CN9")+_cNum)

	_cChaveSCR	:= PADR( XfILIAL("SCR") + 'CT' + _cNum,59)

	DBSelectArea("CN1")
	DBSetOrder(1)
	DBSeek(xFilial("CN1")+CN9->CN9_TPCTO)
                  
	_cTipoCT	:= Iif(CN1->CN1_ESPCTR == '1',"C","V")   // C-Compra ou V-Venda    

	DBSelectArea("SE4")
	DBSetOrder(1)
	DBSeek(xFilial("SE4")+CN9->CN9_CONDPG)

	DBSelectArea("SAL")
	DBSetOrder(3)
	DBSeek(xFilial("SAL")+CN9->CN9_APROV+SCR->CR_APROV)

	DO CASE 
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao
				oProcess	:= TWFProcess():New( "000001", "Envio Aprovacao GC :" + _cFilial + "/" +  TRIM(_cNum) )
				oProcess:NewTask( "Envio GC : "+_cFilial + _cNum, "\WORKFLOW\HTML\GCAPROV_RENOVA.HTM" )
				oProcess:bReturn  	:= "U_WKFGC(2)"
		
		CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
				oProcess    := TWFProcess():New( "000003", "Envio p/comprador GC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess:NewTask( "Envio GC aprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\GCRESP_RENOVA.HTM" )
				_cResposta	:= " A P R O V A D O "
			
		CASE _nOpc == 4		// Envio de email Reprovado para solicitante
				oProcess    := TWFProcess():New( "000004", "Envio p/comprador GC reprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess:NewTask( "Envio GC reprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\GCRESP_RENOVA.HTM" )
				_cResposta	:= "<font color='#FF0000'>R E P R O V A D O </font>"
	
	ENDCASE

	_cTo 				:= Iif(!Empty(_cDestFixo),_cDestFixo,_cTo) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
	oProcess:cTo      	:= _cTo
	oProcess:UserSiga	:= _cUser
	oProcess:NewVersion(.T.)
 	oHtml  				:= oProcess:oHTML

	IF _nOpc == 1
		oHtml:ValByName( "CFILANT"	   , xFilial("SCR"))
		oHtml:ValByName( "CHAVE"	   , _cChave)
		oHtml:ValByName( "WFID"		   , oProcess:fProcessId)
		oHtml:ValByName( "OBS"		   , "" )
	ENDIF

	IF _nOpc == 3 .OR. _nOpc == 4
		oHtml:ValByName( "mensagem"  	, _cResposta)	 
	ENDIF   
	//Busca descricao da undiade de vigencia no cbox da SX3
	_aUnvige:= RetSx3Box( Posicione("SX3", 2, "CN9_UNVIGE", "X3CBox()" ),,, TamSX3("CN9_UNVIGE")[1] )
	_nPos 	:= aScan( _aUnvige, { |x| x[2] == CN9->CN9_UNVIGE } )
	_cUnvige:= Alltrim(_aUnvige[_nPos][3])
	
	//Cabecalho
	oHtml:ValByName( "CN9_FILIAL"	, SM0->M0_NOMECOM )
	oHtml:ValByName( "CN9_NUMERO"	, CN9->CN9_NUMERO )
//	oHtml:ValByName( "CN9_REVISA"	, CN9->CN9_REVISA)
	oHtml:ValByName( "CN1_CODIGO"	, CN1->CN1_CODIGO )
	oHtml:ValByName( "CN1_DESCRI"	, Alltrim(CN1->CN1_DESCRI) )
	oHtml:ValByName( "CR_USER"		, _cUser)
	oHtml:ValByName( "CR_NUSER"		, UsrFullName(_cUser))

	oHtml:ValByName( "CN9_DESCRI"	, CN9->CN9_DESCRI )
	oHtml:ValByName( "CN9_CODOBJ"	, MSMM(CN9->CN9_CODOBJ) )  
	oHtml:ValByName( "CN9_DTINIC"	, DTOC(CN9->CN9_DTINIC) )  
	oHtml:ValByName( "CN9_DTASSI"	, DTOC(CN9->CN9_DTASSI) ) 
	oHtml:ValByName( "CN9_DTFIM"	, DTOC(CN9->CN9_DTFIM ) ) 
	oHtml:ValByName( "CN9_VIGE"	    , Alltrim(TRANSFORM(CN9->CN9_VIGE ,PesqPict("CN9","CN9_VIGE"))))
	oHtml:ValByName( "CN9_UNVIGE"	, "(Unid.Vigência: "  + _cUnvige + ")")
//	oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI)
	oHtml:ValByName( "CN9_TOTAL"	, Alltrim(TRANSFORM(CN9->CN9_VLINI ,PesqPict("CN9","CN9_VLINI"))))
	oHtml:ValByName( "CN9_XUSER"	, UsrFullName(CN9->CN9_XCODUS))

	oHtml:ValByName( "FORCLI"		, Iif(_cTipoCT == "C","Fornecedor","Cliente"))  
          
	//-----------------------------
	// Body de cliente / fornecedor
	//-----------------------------
	If _cTipoCT == 'C' // compra, busca fornecedor(es)
		DBSelectArea("CNC")
		DBSetOrder(1)
		DBSeek(xFilial("CNC")+CN9->CN9_NUMERO+CN9->CN9_REVISA)
		
		While xFilial("CNC")+CNC->CNC_NUMERO+CNC->CNC_REVISA == xFilial("CN9")+CN9->CN9_NUMERO+CN9->CN9_REVISA .and. !CNC->(Eof())  
			AAdd( (oHtml:ValByName( "t.1"  )), CNC->CNC_CODIGO)
			AAdd( (oHtml:ValByName( "t.2"  )), CNC->CNC_LOJA)
			AAdd( (oHtml:ValByName( "t.3"  )), Posicione("SA2",1,xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA,"A2_NOME"))
			CNC->(DbSkip())
		Enddo	
	Else // venda, busca cliente
		DBSelectArea("SA1")
		DBSetOrder(1)
		DBSeek(xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL)
		AAdd( (oHtml:ValByName( "t.1"  )), CN9->CN9_CLIENT)
		AAdd( (oHtml:ValByName( "t.2"  )), CN9->CN9_LOJACL)
		AAdd( (oHtml:ValByName( "t.3"  )), Posicione("SA1",1,xFilial("SA2")+CN9->CN9_CLIENT+CN9->CN9_LOJACL,"A1_NOME"))
	Endif
           
	//----------------------------------------
	// Body de Planilha(s) (TABELAS CNA E CNB)
	//----------------------------------------
	DBSelectArea("CNA")
	DBSetOrder(1)
	DBSeek(xFilial("CNA")+ CN9->CN9_NUMERO + CN9->CN9_REVISA)
	
	_lPlanilha := .F.
	
	While CNA->(CNA_FILIAL + CNA_CONTRA + CNA_REVISA) == xFilial("CNA") + CN9->(CN9_NUMERO + CN9_REVISA) .and. !CNA->(Eof())    
		DBSelectArea("CNB")
		DBSetOrder(1)
		DBSeek(xFilial("CNB")+ CNA->CNA_CONTRA + CNA->CNA_REVISA + CNA->CNA_NUMERO)
		While CNB->(CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO) == xFilial("CNB")+CNA->(CNA_CONTRA+CNA_REVISA+CNA_NUMERO) .and. !CNB->(Eof())    
			AAdd( (oHtml:ValByName( "tp.1"  )), CNB->CNB_NUMERO)
			AAdd( (oHtml:ValByName( "tp.2"  )), CNB->CNB_ITEM  )
			AAdd( (oHtml:ValByName( "tp.3"  )), CNA->CNA_FORNEC + "-" + CNA->CNA_LJFORN)
			AAdd( (oHtml:ValByName( "tp.4"  )), CNB->CNB_PRODUT)
			AAdd( (oHtml:ValByName( "tp.5"  )), Posicione("SB1",1,xFilial("SB1")+CNB->CNB_PRODUT,"B1_DESC"))
			AAdd( (oHtml:ValByName( "tp.6"  )), Alltrim(TRANSFORM(CNB->CNB_QUANT  ,PesqPict("CNB","CNB_QUANT" ))))
			AAdd( (oHtml:ValByName( "tp.7"  )), CNB->CNB_UM)
			AAdd( (oHtml:ValByName( "tp.8"  )), Alltrim(TRANSFORM(CNB->CNB_VLUNIT ,PesqPict("CNB","CNB_VLUNIT"))))  
			AAdd( (oHtml:ValByName( "tp.9"  )), Alltrim(TRANSFORM(CNB->CNB_VLTOT  ,PesqPict("CNB","CNB_VLTOT" ))))
			AAdd( (oHtml:ValByName( "tp.10" )), Alltrim(Posicione("CTD",1,xfilial("CTD") + CNB->CNB_ITEMCT,"CTD_DESC01"))) 
			AAdd( (oHtml:ValByName( "tp.11" )), Alltrim(Posicione("CTH",1,xfilial("CTH") + CNB->CNB_CLVL,"CTH_DESC01"))) 
			AAdd( (oHtml:ValByName( "tp.12" )), Alltrim(Posicione("CTT",1,xfilial("CTT") + CNB->CNB_CC,"CTT_DESC01")))
			AAdd( (oHtml:ValByName( "tp.13"	)), Alltrim(Posicione("CV0",1,xFilial("CV0") +"05"+CNB->CNB_EC05DB  ,"CV0_DESC"  )))	
		
			_lPlanilha := .T.
			CNB->(DbSkip())

		Enddo
		CNA->(DbSkip())
	Enddo	                
	
	If !(_lPlanilha)
		AAdd( (oHtml:ValByName( "tp.1"  )), " ")
		AAdd( (oHtml:ValByName( "tp.2"  )), " ")
		AAdd( (oHtml:ValByName( "tp.3"  )), " ")
		AAdd( (oHtml:ValByName( "tp.4"  )), " ")
		AAdd( (oHtml:ValByName( "tp.5"  )), " ")
		AAdd( (oHtml:ValByName( "tp.6"  )), " ")
		AAdd( (oHtml:ValByName( "tp.7"  )), " ")
		AAdd( (oHtml:ValByName( "tp.8"  )), " ")
		AAdd( (oHtml:ValByName( "tp.9"  )), " ")
	Endif
	//-------------------------------------------------------------
	// ALIMENTA A TELA DE PROCESSO DE APROVAÇÃO DE CONTRATO
	//-------------------------------------------------------------
	DBSelectarea("SCR")
	DBSetOrder(1)
	DBSeek(_cCHAVESCR,.T.)
	
	WHILE !SCR->(EOF()) .AND. Alltrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == Alltrim(_cCHAVESCR)

		cSituaca := ""
		Do Case
             Case SCR->CR_STATUS == "01"
//               cSituaca := "Aguardando"
				 cSituaca   := IIF(lBloq,"Bloqueado","Aguardando Lib") 
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
			oProcess:cTo      		:= nil
			oProcess:NewVersion(.T.)
			oHtml     				:= oProcess:oHTML
			oProcess:nEncodeMime := 0
			cMailID := oProcess:Start("\workflow\wfgc\")   //Faz a gravacao do e-mail no cPath
			
			chtmlfile  := cmailid + ".htm"                         
			
			csubj := "Aprovação de contrato - Filial: "+_cFilial+" / Numero: "+_cNum 
			oProcess:newtask("Link", "\workflow\html\Link_renova.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
			oHtml:ValByName( "cDocto"	    , "Contrato Filial: "+_cFilial+" / Numero: "+_cNum)
			oHtml:ValByName( "descproc"	    , "O contrato abaixo aguarda sua aprovação. Para visualizá-lo clique no link abaixo:")
			oHtml:ValByName("cNomeProcesso", Alltrim(GetMv("MV_WFDHTTP"))+"/workflow/wfgc/"+chtmlfile ) // envia o link onde esta o arquivo html
			_cEmail := Iif(!Empty(_cDestFixo),_cDestFixo,_cEmail) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
			oProcess:cTo 	   := _cEmail                                                              

			oProcess:cSubject := cSubj
			
			oProcess:Start()

		OTHERWISE       
			oProcess:cSubject    := "WORKFLOW  - Contrato - Filial: "+_cFilial+" / Número: " + _cNum  + Iif(_nOpc=3," APROVADO"," REPROVADO")
			oProcess:Start()
	END CASE
	return _aReturn
    