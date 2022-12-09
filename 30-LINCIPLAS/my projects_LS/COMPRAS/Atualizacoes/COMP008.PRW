#INCLUDE "PROTHEUS.CH"                                                                                                                        
                                                                                                                                               
/*
+=========================================================+                                                                               
|Programa: COMP008 |Autor: Antonio Carlos |Data: 19/04/10 |
+=========================================================+
|Descricao: Rotina responsavel pela Aprovação/Bloqueio do | 
|Pedido de Compra via e-mail.                             |
+=========================================================+
|Uso: Especifico Laselva                                  |
+=========================================================+
*/

User Function COMP008(oProcess) 

Local _cNumPed	:= ""
Local _cRetorn	:= "" 
Local _cHtm		:= "" 
Local _cObs		:= ""
Local _cUser	:= Space(6) 
Local _cGrpApv	:= Space(6)                                                                    
Local _nValPed	:= 0
Local _nSaldo	:= 0
Local _nSaldoI	:= 0
Local _nCont	:= 0
Local _lAprova	:= .F.
Local _aAprov	:= {}
Local _aItens	:= {}
Local _cEmail	

ConOut("COMP008 - CNUMEMP: "  )
ConOut("COMP008 - CNUMEMP: " + cNumEmp )
ConOut("COMP008 - SIGAMAT: " + SM0->M0_FILIAL )

_cRetorn	:= oProcess:oHtml:RetByName("RBAPROVA")
_cUser		:= oProcess:oHtml:RetByName("RESPUSR")
_cGrpApv	:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_COD")
_cCodigo	:= oProcess:oHtml:RetByName("CODIGO")
_cForne		:= oProcess:oHtml:RetByName("FORNECEDOR")
_cCompra	:= oProcess:oHtml:RetByName("CODCOMP")
_cNomCom	:= oProcess:oHtml:RetByName("COMPRADOR")

_aFilial	:= oProcess:oHtml:RetByName("IT.FILIAL")
_aPedido	:= oProcess:oHtml:RetByName("IT.PEDIDO")
_aPrzEnt	:= oProcess:oHtml:RetByName("IT.PRZENTREGA")
_aCPagto	:= oProcess:oHtml:RetByName("IT.CONDPAGTO")
_aQtdIte	:= oProcess:oHtml:RetByName("IT.QTDITENS")
_aValor		:= oProcess:oHtml:RetByName("IT.VALOR")

_nQtd		:= oProcess:oHtml:RetByName("QTD")
_nTotal		:= oProcess:oHtml:RetByName("LBTOTAL")

_cObsA		:= Alltrim(oProcess:oHtml:RetByName("S2"))

/*
_cRetorn	:= "S"
_cUser		:= "000372"
_cGrpApv	:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_COD")
_cCodigo	:= "005827"
_cForne		:= "CABOCLO"
_cCompra	:= "000368"
_cNomCom	:= "comp1"

_aFilial	:= {"02 - GRU","04 - CGH"}
_aPedido	:= {"013131","013132"}
_aCPagto	:= {"28 DIAS","28 DIAS"}
_aQtdIte	:= {'418','232'}
_aValor		:= {'960,18','490,20'}

_nQtd		:= '650.00'
_nTotal		:= '1,450.38'
*/

If Substr(_cRetorn,1,1) == "S"	 

	For n := 1 To Len(_aPedido)
	
	DbSelectArea("SCR")		
	SCR->( DbSetOrder(2) )
	If SCR->( DbSeek( Substr(_aFilial[n],1,2)+"PC"+_aPedido[n]+Space(44)+_cUser ) )
	
		_nValPed := SCR->CR_TOTAL
		
		If SCR->CR_NIVEL == "01" .And. SCR->CR_STATUS <> "03"
		
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			_nCont++
		
			DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_aFilial[n],1,2)+"PC"+_cNumPed+Space(44)+"02" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	
			
	 		If n == 1
	 		
	 			oProcess:Finish()
	 			
	 			//Cria o processo
				oProcess := TWFProcess():New( "PEDREP", "Pedido de Compras - Reposicao" )

				//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
				oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP1.HTM" ) 			
				oProcess:cSubject := "Aprovacao Pedido de Compra - Reposicao "	

				//Chama rotina de aprovacao
				oProcess:bReturn := "U_COMP008()"

				//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
				oHTML := oProcess:oHTML
				
				DbSelectArea("SY1")
				SY1->( DbSetOrder(3) )
				If SY1->( Dbseek(xFilial("SY1")+_cCompra) )
	
					DbSelectarea("SAL")
					SAL->( DbSetOrder(1) )
					If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
						While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		        	        If SAL->AL_NIVEL == "02"  
		        	        	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM ) 
									Aadd(_aAProv,{SAL->AL_USER,Alltrim(UsrRetMail(SAL->AL_USER))})
								Endif
							EndIf	
							SAL->( Dbskip() )		
						EndDo
					EndIf
            	
		 		EndIf
				
				//Preenche os dados do cabecalho 
				oHtml:ValByname( "CODIGO", _cCodigo )
				oHtml:ValByName( "FORNECEDOR", _cForne )
				oHtml:ValByName( "EMISSAO", dDataBase )
				oHtml:ValByName( "RESPUSR", _aAprov[1,1] )
				oHtml:ValByName( "APROVADOR", UsrRetName(_aAprov[1,1]) )
				oHtml:ValByName( "CODCOMP", _cCompra )
				oHtml:ValByName( "COMPRADOR", _cNomCom )
	 		
	 		EndIf
	 		
	 		Aadd( (oHtml:ValByName( "IT.FILIAL" )), _aFilial[n]		)
			Aadd( (oHtml:ValByName( "IT.PEDIDO" )), _aPedido[n]		)
			Aadd( (oHtml:ValByName( "IT.CONDPAGTO" )), _aCPagto[n]	)
			Aadd( (oHtml:ValByName( "IT.PRZENTREGA" )), _aPrzEnt[n]	)
			Aadd( (oHtml:ValByName( "IT.QTDITENS" )), _aQtdIte[n]	)
			Aadd( (oHtml:ValByName( "IT.VALOR" )), _aValor[n] 		)

			Aadd(_aItens, {_aFilial[n],_aPedido[n],_aCPagto[n],_aPrzEnt[n],_aQtdIte[n],_aValor[n]})
							
		ElseIf SCR->CR_NIVEL == "02" .And. SCR->CR_STATUS <> "03"
				
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			_nCont++
			
        	DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 		
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_aFilial[n],1,2)+"PC"+_cNumPed+Space(44)+"03" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	

			If n == 1
			
				oProcess:Finish()
	 			
	 			//Cria o processo
				oProcess := TWFProcess():New( "PEDREP", "Pedido de Compras - Reposicao" )

				//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
				oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP1.HTM" ) 			
				oProcess:cSubject := "Aprovacao Pedido de Compra - Reposicao "	

				//Chama rotina de aprovacao
				oProcess:bReturn := "U_COMP008()"

				//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
				oHTML := oProcess:oHTML
				
				DbSelectArea("SY1")
				SY1->( DbSetOrder(3) )
				If SY1->( Dbseek(xFilial("SY1")+_cCompra) )
	
					DbSelectarea("SAL")
					SAL->( DbSetOrder(1) )
					If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
						While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		        	        If SAL->AL_NIVEL == "03" 
		        	        	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM ) 
									Aadd(_aAProv,{SAL->AL_USER,Alltrim(UsrRetMail(SAL->AL_USER))})
								Endif
							EndIf	
							SAL->( Dbskip() )		
						EndDo
					EndIf
            	
		 		EndIf
				
				//Preenche os dados do cabecalho 
				oHtml:ValByname( "CODIGO", _cCodigo )
				oHtml:ValByName( "FORNECEDOR", _cForne )
				oHtml:ValByName( "EMISSAO", dDataBase )
				oHtml:ValByName( "RESPUSR", _aAprov[1,1] )
				oHtml:ValByName( "APROVADOR", UsrRetName(_aAprov[1,1]) )
				oHtml:ValByName( "CODCOMP", _cCompra )
				oHtml:ValByName( "COMPRADOR", _cNomCom )
				 		
	 		EndIf
	 		
	 		Aadd( (oHtml:ValByName( "IT.FILIAL" )), _aFilial[n]		)
			Aadd( (oHtml:ValByName( "IT.PEDIDO" )), _aPedido[n]		)
			Aadd( (oHtml:ValByName( "IT.CONDPAGTO" )), _aCPagto[n]	)
			Aadd( (oHtml:ValByName( "IT.PRZENTREGA" )), _aPrzEnt[n]	)
			Aadd( (oHtml:ValByName( "IT.QTDITENS" )), _aQtdIte[n]	)
			Aadd( (oHtml:ValByName( "IT.VALOR" )), _aValor[n] 		)
			
			Aadd(_aItens, {_aFilial[n],_aPedido[n],_aCPagto[n],_aPrzEnt[n],_aQtdIte[n],_aValor[n]})

		ElseIf ( SCR->CR_NIVEL == "03" .And. SCR->CR_TOTAL > GetMv("MV_VLRGER") .And. SCR->CR_STATUS <> "03" )		
				
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			_nCont++

	        DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_aFilial[n],1,2)+"PC"+_cNumPed+Space(44)+"04" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	

			If n == 1
			
				oProcess:Finish()
	 			
	 			//Cria o processo
				oProcess := TWFProcess():New( "PEDREP", "Pedido de Compras - Reposicao" )

				//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
				oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP1.HTM" ) 			
				oProcess:cSubject := "Aprovacao Pedido de Compra - Reposicao "	

				//Chama rotina de aprovacao
				oProcess:bReturn := "U_COMP008()"

				//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
				oHTML := oProcess:oHTML
				
				DbSelectArea("SY1")
				SY1->( DbSetOrder(3) )
				If SY1->( Dbseek(xFilial("SY1")+_cCompra) )
	
					DbSelectarea("SAL")
					SAL->( DbSetOrder(1) )
					If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
						While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		        	        If SAL->AL_NIVEL == "04"  
		        	        	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM ) 
									Aadd(_aAProv,{SAL->AL_USER,Alltrim(UsrRetMail(SAL->AL_USER))})
								Endif
							EndIf	
							SAL->( Dbskip() )		
						EndDo
					EndIf
            	
		 		EndIf
				
				//Preenche os dados do cabecalho 
				oHtml:ValByname( "CODIGO", _cCodigo )
				oHtml:ValByName( "FORNECEDOR", _cForne )
				oHtml:ValByName( "EMISSAO", dDataBase )
				oHtml:ValByName( "RESPUSR", _aAprov[1,1] )
				oHtml:ValByName( "APROVADOR", UsrRetName(_aAprov[1,1]) )
				oHtml:ValByName( "CODCOMP", _cCompra )
				oHtml:ValByName( "COMPRADOR", _cNomCom )
	 		
	 		EndIf
	 		
	 		Aadd( (oHtml:ValByName( "IT.FILIAL" )), _aFilial[n]		)
			Aadd( (oHtml:ValByName( "IT.PEDIDO" )), _aPedido[n]		)
			Aadd( (oHtml:ValByName( "IT.CONDPAGTO" )), _aCPagto[n]	)
			Aadd( (oHtml:ValByName( "IT.PRZENTREGA" )), _aPrzEnt[n]	)
			Aadd( (oHtml:ValByName( "IT.QTDITENS" )), _aQtdIte[n]	)
			Aadd( (oHtml:ValByName( "IT.VALOR" )), _aValor[n] 		)
			
			Aadd(_aItens, {_aFilial[n],_aPedido[n],_aCPagto[n],_aPrzEnt[n],_aQtdIte[n],_aValor[n]})
	
		ElseIf SCR->CR_NIVEL == "03" .And. SCR->CR_STATUS <> "03"

			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			_nCont++

            DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_aFilial[n],1,2)+"PC"+_cNumPed+Space(44)+"04" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_aFilial[n],1,2)+_aPedido[n] ) )
			While SC7->( !Eof() ) .And. Substr(_aFilial[n],1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _aPedido[n]
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "L"
				SC7->( MsUnLock() )
				SC7->( DbSkip() )
			EndDo
			
			Aadd(_aItens, {_aFilial[n],_aPedido[n],_aCPagto[n],_aPrzEnt[n],_aQtdIte[n],_aValor[n]})
			
			//TRATAR E-MAIL APROVAÇÃO FINAL
			_lAprova := .T.
			
		ElseIf ( SCR->CR_NIVEL == "04" .And. SCR->CR_TOTAL > GetMv("MV_VLRDIR") .And. SCR->CR_STATUS <> "03" )		
				
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			_nCont++

	        DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_aFilial[n],1,2)+"PC"+_cNumPed+Space(44)+"05" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	

			If n == 1
			
				oProcess:Finish()
	 			
	 			//Cria o processo
				oProcess := TWFProcess():New( "PEDREP", "Pedido de Compras - Reposicao" )

				//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
				oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP1.HTM" ) 			
				oProcess:cSubject := "Aprovacao Pedido de Compra - Reposicao "	

				//Chama rotina de aprovacao
				oProcess:bReturn := "U_COMP008()"

				//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
				oHTML := oProcess:oHTML
				
				DbSelectArea("SY1")
				SY1->( DbSetOrder(3) )
				If SY1->( Dbseek(xFilial("SY1")+_cCompra) )
	
					DbSelectarea("SAL")
					SAL->( DbSetOrder(1) )
					If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
						While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		        	        If SAL->AL_NIVEL == "05"   
		        	        	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM ) 
									Aadd(_aAProv,{SAL->AL_USER,Alltrim(UsrRetMail(SAL->AL_USER))})
								Endif
							EndIf	
							SAL->( Dbskip() )		
						EndDo
					EndIf
            	
		 		EndIf
				
				//Preenche os dados do cabecalho 
				oHtml:ValByname( "CODIGO", _cCodigo )
				oHtml:ValByName( "FORNECEDOR", _cForne )
				oHtml:ValByName( "EMISSAO", dDataBase )
				oHtml:ValByName( "RESPUSR", _aAprov[1,1] )
				oHtml:ValByName( "APROVADOR", UsrRetName(_aAprov[1,1]) )
				oHtml:ValByName( "CODCOMP", _cCompra )
				oHtml:ValByName( "COMPRADOR", _cNomCom )
	 		
	 		EndIf
	 		
	 		Aadd( (oHtml:ValByName( "IT.FILIAL" )), _aFilial[n]		)
			Aadd( (oHtml:ValByName( "IT.PEDIDO" )), _aPedido[n]		)
			Aadd( (oHtml:ValByName( "IT.CONDPAGTO" )), _aCPagto[n]	)
			Aadd( (oHtml:ValByName( "IT.PRZENTREGA" )), _aPrzEnt[n]	)
			Aadd( (oHtml:ValByName( "IT.QTDITENS" )), _aQtdIte[n]			)
			Aadd( (oHtml:ValByName( "IT.VALOR" )), _aValor[n]			 )
			
			Aadd(_aItens, {_aFilial[n],_aPedido[n],_aCPagto[n],_aPrzEnt[n],_aQtdIte[n],_aValor[n]})
			
		ElseIf SCR->CR_NIVEL == "04" .And. SCR->CR_STATUS <> "03"

			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			SCR->( DbSeek( xFilial("SCR")+"PC"+_cNumPed ) )
	
			While SCR->( !Eof() ) .And. SCR->CR_FILIAL == xFilial("SCR") .And. Alltrim(SCR->CR_NUM) == _cNumPed
	
				If SCR->CR_STATUS <> "03"
					
					RecLock("SCR",.F.)
					SCR->CR_DATALIB	:= dDataBase	
					SCR->CR_STATUS	:= "03"
					SCR->CR_USERLIB := _cUser
					SCR->CR_VALLIB	:= SCR->CR_TOTAL
					SCR->CR_TIPOLIM := "D"
					SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
					SCR->( MsUnLock() )
					
					_nCont++
						
				EndIf	
		
				SCR->( DbSkip() )
		
			EndDo

            DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_aFilial[n],1,2)+"PC"+_cNumPed+Space(44)+"05" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "03"
				SCR->( MsUnLock() )
				
			EndIf	
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_aFilial[n],1,2)+_aPedido[n] ) )
			While SC7->( !Eof() ) .And. Substr(_aFilial[n],1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _aPedido[n]
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "L"
				SC7->( MsUnLock() )
				SC7->( DbSkip() )
			EndDo
			
			Aadd(_aItens, {_aFilial[n],_aPedido[n],_aCPagto[n],_aPrzEnt[n],_aQtdIte[n],_aValor[n]})
			
			//TRATAR E-MAIL APROVAÇÃO
			_lAprova := .T.
			
		ElseIf SCR->CR_NIVEL == "05" .And. SCR->CR_STATUS <> "03"

			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			_nCont++

            DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_aFilial[n],1,2)+_aPedido[n] ) )
			While SC7->( !Eof() ) .And. Substr(_aFilial[n],1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _aPedido[n]
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "L"
				SC7->( MsUnLock() )
				SC7->( DbSkip() )
			EndDo
			
			Aadd(_aItens, {_aFilial[n],_aPedido[n],_aCPagto[n],_aPrzEnt[n],_aQtdIte[n],_aValor[n]})
			
			//TRATAR E-MAIL APROVAÇÃO
			_lAprova := .T.
	    
	    EndIf
	    
	EndIf	    
	
	Next n
	
	If !_lAprova .And. _nCont > 0
	
		oHtml:ValByName( "LBTOTAL"	,Alltrim(_nTotal) )
		oHtml:ValByName( "QTD" 		,Alltrim(_nQtd) ) 
		
		oHtml:ValByName( "S1", " "+Alltrim(_cObsA) ) 
		
		oProcess:ClientName( cUserName )
		cMailID := oProcess:Start()
		_cEmail := _aAprov[1,2]
					
		//cAssunto	:= "Aprovacao Pedido de Compra"
		//cHtmlLink	:= "\WORKFLOW\HTML\LINKPED.HTM" //se for utilizar o link
		//oProcess:NewTask(cAssunto, cHtmlLink)  //Gera o processo para envio do link para o aprovador e os usuarios que serao copiados.
		//oProcess:cSubject := cAssunto //se for utilizar o link
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Endereco eletronico do destinatario aprovador.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oProcess:cTo := _cEmail
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Link com o endereco para acesso a pagina.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oProcess:oHtml:ValByName("cPath"	,"\\TERRA\workflow\emp01\temp\" +cMailID+ ".htm")
		//cPath := "\\192.168.0.194\workflow\emp01\temp\" +cMailID+ ".htm"
		cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Apos ter repassado todas as informacoes necessarias para o ³
		//³workflow, solicita a ser executado o método Start() para se³
		//³gerado todo processo e enviar a mensagem ao destinatário.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oProcess:Start()
		
		_cTo		:= _cEmail
		_cSubject	:= " Aprovacao Pedido de Compra - Reposicao "
	
		_cHtm += "	<TABLE border=0 width=800>  "
		_cHtm += "   <tr> "
		//_cHtm += "   <td width=180><img src=\\192.168.0.194\workflow\header_logo.jpg></img></td> "
		_cHtm += "   <td width=180><img src=http:\\localhost:7914\header_logo.jpg></img></td> "
		_cHtm += "   </tr> "
		_cHtm += "	</TABLE> "

		_cHtm += "	<BR> "

		_cHtm += " 	<TABLE border=0 width=800> "
		_cHtm += " 	   <tr> "
		_cHtm += "      <td width=600><font color=#000040 size=3 face=Verdana><hr><b>Aprovação de Pedido de Compra - Reposicao</b></hr></font></td> "
		_cHtm += "	   </tr> "
		_cHtm += "	</TABLE> "

		_cHtm += " 	<BR> "

		_cHtm += "	<b>Favor acessar o link abaixo:</b> "

		_cHtm += "	<BR> "
		_cHtm += " 	<BR> "

		_cHtm += "	<a href="+cPath+">PEDIDO</a> "

		//U_EnvMail(_cTo,_cSubject, _cHtm,)
		cQuery := ""
		cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
		TcSQLExec(cQuery)
		
	ElseIf _nCont > 0
	
		oProcess:Finish()
		
		_cTo := Alltrim(UsrRetMail(_cCompra))
		_cSubject	:= " Liberação Pedido de Compra - Reposicao "
	
		_cHtm+= " <td width=600><font color=#000040 size=3 face=Verdana><hr><b>Aprovacao Pedido de Compra - Reposicao</b></hr></font></td> "

		//Cabecalho
		_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405> "
		_cHtm+="   <tr>"
		_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center> "
		_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>FORNECEDOR</b></font></TD> "
		_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center> "
		_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>NOME</b></font></TD> "
		_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center> "
		_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>DATA APROVACAO</b></font></TD> "
		_cHtm+="   </tr> "
		_cHtm+="   <tr> "
		_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center> "
		_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cCodigo+"</b></font></TD> "
		_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center> "
		_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cForne+"</b></font></TD> "
		_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center> "
		_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+DTOC(dDataBase)+"</b></font></TD> "
		_cHtm+="   </tr> "
		_cHtm+="</TABLE> "
		_cHtm+="<br> "
		
		//Aprovador
		_cHtm+=" <TABLE width=200 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033> "
		_cHtm+="     <TR> "
		_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center> "
		_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovado por:</b></font> "
		_cHtm+="         </TD> "
		_cHtm+="     </TR> "
		_cHtm+="     <TR> "
		_cHtm+="         <TD style=WIDTH: 500px bgColor=#ffffff align=LEFT> "
		_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font> "
		_cHtm+="         </TD> "
		_cHtm+="     </TR> "
		_cHtm+=" </TABLE> "
		
		//Itens Aprovação
		_cHtm+=" <TABLE border=0 width=500 cellSpacing=1 cellPadding=1> "
		_cHtm+="    <TR> "
		_cHtm+="       <TD width=615 height=100> "
		_cHtm+="    <TABLE width=610 height=30 cellSpacing=1 cellPadding=1 border=0 bordercolor=#9999cc> "
		_cHtm+="            <TR> "
		_cHtm+="                <td width=400> "
		_cHtm+="                <font color=#000040 size=3 face=Verdana><hr><b>Itens da Aprovacao</b></hr></font></td> "
		_cHtm+="             </TR> "
		_cHtm+="          </TABLE> "
		_cHtm+=" <TABLE width=650 height=40 cellSpacing=1 cellPadding=1 border=1 bordercolor=#9999cc> "
		_cHtm+="             <TR> "
		_cHtm+="                <TD width=200 height=20 bgColor=#9999cc align=left> "
		_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Filial</b></font></TD> "
		_cHtm+="                <TD wigth=50 height=20 bgColor=#9999ccalign=left> "
		_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Pedido</b></font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=right> "
		_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Cond.pagto</b></font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=right> "
 		_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Prazo Entrega</b></font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=center> "
		_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Qtd Itens</b></font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=center> "
		_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Valor</b></font></TD> "
		_cHtm+="             </TR> "
		
		For _nLin:=1 to Len(_aItens)
			_cHtm+="             <TR> "
			_cHtm+="                <TD width=200 height=20 bgColor=#ffffff align=left> "
			_cHtm+="                <font color=#000040 size=2 face=Verdana>"+_aItens[_nLin,1]+"</font></TD> "
			_cHtm+="                <TD width=50 height=20 bgColor=#ffffff align=left> "
			_cHtm+="                <font color=#000040 size=2 face=Verdana>"+_aItens[_nLin,2]+"</font></TD> "
			_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=right> "
			_cHtm+="                <font color=#000040 size=2 face=Verdana>"+_aItens[_nLin,3]+"</font></TD> "
			_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=right> "
			_cHtm+="                <font color=#000040 size=2 face=Verdana>"+DTOC(_aItens[_nLin,4])+"</font></TD> "
			_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=center> "
			_cHtm+="                <font color=#000040 size=2 face=Verdana>"+TRANSFORM( Val(_aItens[_nLin,5]),"@E 999,999,999.99" )+"</font></TD> "
			_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=center> "
			_cHtm+="                <font color=#000040 size=2 face=Verdana>"+TRANSFORM( Val(_aItens[_nLin,6]),"@E 999,999,999.99" )+"</font></TD> "
			_cHtm+="             </TR> "
		Next	
		
		_cHtm+="          </TABLE> "
		_cHtm+="       </TD> "
		_cHtm+="    </TR> "
		_cHtm+="</TABLE> "
		
		_cHtm+="<TR> "
		_cHtm+="<TD width=470 height=10 bgColor=#ffffff> "
		_cHtm+="<font color=#000040 size=2 face=Verdana> "
		_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD> "
		_cHtm+="</TR> "

		//U_EnvMail(_cTo,_cSubject, _cHtm,)
		cQuery := ""
		cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
		TcSQLExec(cQuery)
		
	EndIf	
	
Else	

	oProcess:Finish()
	
	_cTo := Alltrim(UsrRetMail(_cCompra))
	_cSubject	:= " Bloqueio Pedido de Compra - Reposicao "
	
	_cHtm+= " <td width=600><font color=#000040 size=3 face=Verdana><hr><b>Bloqueio Pedido de Compra - Reposicao</b></hr></font></td> "

	//Cabecalho
	_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405> "
	_cHtm+="   <tr>"
	_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center> "
	_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>FORNECEDOR</b></font></TD> "
	_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center> "
	_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>NOME</b></font></TD> "
	_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center> "
	_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>DATA BLOQUEIO</b></font></TD> "
	_cHtm+="   </tr> "
	_cHtm+="   <tr> "
	_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center> "
	_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cCodigo+"</b></font></TD> "
	_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center> "
	_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cForne+"</b></font></TD> "
	_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center> "
	_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+DTOC(dDataBase)+"</b></font></TD> "
	_cHtm+="   </tr> "
	_cHtm+="</TABLE> "
	_cHtm+="<br> "
	
	//Aprovador
	_cHtm+=" <TABLE width=200 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033> "
	_cHtm+="     <TR> "
	_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center> "
	_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Bloqueado por:</b></font> "
	_cHtm+="         </TD> "
	_cHtm+="     </TR> "
	_cHtm+="     <TR> "
	_cHtm+="         <TD style=WIDTH: 500px bgColor=#ffffff align=LEFT> "
	_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font> "
	_cHtm+="         </TD> "
	_cHtm+="     </TR> "
	_cHtm+=" </TABLE> "
		
	//Itens Aprovação
	_cHtm+=" <TABLE border=0 width=500 cellSpacing=1 cellPadding=1> "
	_cHtm+="    <TR> "
	_cHtm+="       <TD width=615 height=100> "
	_cHtm+="    <TABLE width=610 height=30 cellSpacing=1 cellPadding=1 border=0 bordercolor=#9999cc> "
	_cHtm+="            <TR> "
	_cHtm+="                <td width=400> "
	_cHtm+="                <font color=#000040 size=3 face=Verdana><hr><b>Itens da Aprovacao</b></hr></font></td> "
	_cHtm+="             </TR> "
	_cHtm+="          </TABLE> "
	_cHtm+=" <TABLE width=650 height=40 cellSpacing=1 cellPadding=1 border=1 bordercolor=#9999cc> "
	_cHtm+="             <TR> "
	_cHtm+="                <TD width=200 height=20 bgColor=#9999cc align=left> "
	_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Filial</b></font></TD> "
	_cHtm+="                <TD wigth=50 height=20 bgColor=#9999ccalign=left> "
	_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Pedido</b></font></TD> "
	_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=right> "
	_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Cond.pagto</b></font></TD> "
	_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=right> "
 	_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Prazo Entrega</b></font></TD> "
	_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=center> "
	_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Qtd Itens</b></font></TD> "
	_cHtm+="                <TD width=100 height=20 bgColor=#9999cc align=center> "
	_cHtm+="                <font color=#ffffff size=2 face=Verdana><b>Valor</b></font></TD> "
	_cHtm+="             </TR> "
	
	For _nLin:=1 to Len(_aItens)
		_cHtm+="             <TR> "
		_cHtm+="                <TD width=200 height=20 bgColor=#ffffff align=left> "
		_cHtm+="                <font color=#000040 size=2 face=Verdana>"+_aItens[_nLin,1]+"</font></TD> "
		_cHtm+="                <TD width=50 height=20 bgColor=#ffffff align=left> "
		_cHtm+="                <font color=#000040 size=2 face=Verdana>"+_aItens[_nLin,2]+"</font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=right> "
		_cHtm+="                <font color=#000040 size=2 face=Verdana>"+_aItens[_nLin,3]+"</font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=right> "
		_cHtm+="                <font color=#000040 size=2 face=Verdana>"+DTOC(_aItens[_nLin,4])+"</font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=center> "
		_cHtm+="                <font color=#000040 size=2 face=Verdana>"+TRANSFORM( Val(_aItens[_nLin,5]),"@E 999,999,999.99" )+"</font></TD> "
		_cHtm+="                <TD width=100 height=20 bgColor=#ffffff align=center> "
		_cHtm+="                <font color=#000040 size=2 face=Verdana>"+TRANSFORM( Val(_aItens[_nLin,6]),"@E 999,999,999.99" )+"</font></TD> "
		_cHtm+="             </TR> "
	Next	
		
	_cHtm+="          </TABLE> "
	_cHtm+="       </TD> "
	_cHtm+="    </TR> "
	_cHtm+="</TABLE> "
	
	_cHtm+="<TR> "
	_cHtm+="<TD width=470 height=10 bgColor=#ffffff> "
	_cHtm+="<font color=#000040 size=2 face=Verdana> "
	_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD> "
	_cHtm+="</TR> "
		
	//U_EnvMail(_cTo,_cSubject, _cHtm,)
	cQuery := ""
	cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
	TcSQLExec(cQuery)

EndIf	
     
Return  