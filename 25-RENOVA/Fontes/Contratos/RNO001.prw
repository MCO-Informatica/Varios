#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RNO001    º Autor ³ Marcelo IUSPA      º Data ³  08/06/15   º±±
±±º                     º Alter ³ PEDRO AUGUSTO      º Data ³  08/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro especifico de PA tyabela SZ7                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RNO001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro 	:= "Cadastro de PAs"
Private cAlias    	:= "SZ7"
Private cDelFunc  	:= ".T."    // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private aPar 	  	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCores  	:= {}

Private aRotina 	:= {{"Pesquisar"		,"AxPesqui",0,1} ,;
						{"Visualizar"		,"U_RNOMan",0,2} ,;
						{"Incluir"			,"U_RNOMan",0,3} ,;
						{"Alterar"			,"U_RNOMan",0,4} ,;
						{"Excluir"			,"U_RNOMan",0,5} ,;
						{"Legenda"      	,"U_RNOLEG",0,6} ,;
						{"Reenvia PA"      	,"U_PrepPAWF",0,7}}

aAdd(aCores, {"Z7_STATUS=='1'" ,"BR_VERDE"   })  	 // Aprovado
aAdd(aCores, {"Z7_STATUS=='2'" ,"BR_AZUL"    })      // Aguardando Aprovação
aAdd(aCores, {"Z7_STATUS=='3'" ,"BR_LARANJA" })      // Rejeitado
aAdd(aCores, {"Z7_STATUS=='E'" ,"BR_PINK"    })      //Erro na ExecAuto (Geracao da SE2)

dbSelectArea("SZ7")
dbSetOrder(1)

dbSelectArea(cAlias)
mBrowse( 6,1,22,75,cAlias,,,,,,aCores)
Return



User Function RNOMan(cAlias,nRecno,nOpc)

Local aArray 	:= {}
Local aParam	:= {}
Local _aBtns    := {}

Private lMsErroAuto := .F.
Private INCLUI      := ( nOpc == 3 )
Private ALTERA	    := ( nOpc == 4 )
Private EXCLUI      := ( nOpc == 5 )


Do 	Case
	Case nOpc == 2 // Visualizar                      
//		AxVisual( <cAlias>, <nReg>, <nOpc>,,,,, <aButtons>, <lMaximized>)	
//		aArray[n][1]  -->  Imagem do botão
//		aArray[n][2]  -->  Bloco de código contendo a ação que o botão executará
//		aArray[n][3]  -->  Título do botão
                                                                             
		_aBtns := {{'BUDGETY',{||U_AprovSZ7()},"Consulta aprovação" }}
		//_aBtns := {{'ReenviaPA',{||U_PrepPAWF()},"Reenviar p/aprovação" }}

		AxVisual( cAlias  , nRecno, nOpc  ,,,,,_aBtns) 
		
	Case nOpc == 3 // Inclusao

		Aadd( aParam, {|| .t.} )
		Aadd( aParam, {|| U_VLDSZ7()} )
		Aadd( aParam, {|| .t.} )
		Aadd( aParam, {|| .t.} )
        
		//If AxInclui(cAlias,nRecno,nOpc,,,,"U_VLDSZ7()") == 1
		If	AxInclui( cAlias, nRecno, nOpc, , , , , , , , aParam, , , ) == 1	
//			EnviaPA("I", SZ7->(Recno()))
// 			Aqui vou gerar a SCR, com base no grupo de aprovacao associado à unidade requisitante	
		    MAAlcDoc({SZ7->Z7_NUMSEQ,"PA",SZ7->Z7_VALOR,,,SZ7->Z7_GRAPROV,,1,1,SZ7->Z7_EMISSAO},,1) // recria nova alcada                           
		
		EndIf
		
	Case nOpc == 4	// Alteracao
		If 	AxAltera(cAlias,nRecno,nOpc,,,,,"U_VLDSZ7()") == 1
			Reclock("SZ7",.F.)
			SZ7->Z7_STATUS :='2'
			MSUnlock()
//			EnviaPA("A", SZ7->(Recno()))
// 			Aqui vou eliminar a SCR de origem e gerar a SCR, com base no grupo de aprovacao associado à unidade requisitante			
		    MAAlcDoc({SZ7->Z7_NUMSEQ,"PA",SZ7->Z7_VALOR,,,SZ7->Z7_GRAPROV,,1,1,SZ7->Z7_EMISSAO},,3) // exclui alcada existente
		    MAAlcDoc({SZ7->Z7_NUMSEQ,"PA",SZ7->Z7_VALOR,,,SZ7->Z7_GRAPROV,,1,1,SZ7->Z7_EMISSAO},,1) // recria nova alcada                           
		EndIf
		
	Case nOpc == 5 // Exclusao                                   
		
		//aParam[1]  -->  Bloco de código que será processado antes da exibição das informações na tela
		//aParam[2]  -->  Bloco de código para processamento na validação da confirmação da exclusão
		//aParam[3]  -->  Bloco de código que será executado dentro da transação da AxFunction()
		//aParam[4]  -->  Bloco de código que será executado fora da transação da AxFunction()
  
		If 	ApMsgYesNo('Confirma exclusão?')		
			Aadd( aParam, {|| .t.} )
			Aadd( aParam, {|| VldDeleta()} )
			Aadd( aParam, {|| .t.} )
			Aadd( aParam, {|| .t.} )
			
			AxDeleta( cAlias, nRecno, nOpc, /*<cTransact>*/, /*<aCpos>*/, /*<aButtons>*/, aParam, /*<aAuto>*/, /*<lMaximized>*/)
			// Aqui vou eliminar a SCR 
		    MAAlcDoc({SZ7->Z7_NUMSEQ,"PA",SZ7->Z7_VALOR,,,SZ7->Z7_GRAPROV,,1,1,SZ7->Z7_EMISSAO},,3) // exclui alcada existente                          
		EndIf		
		
EndCase

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//Valida gravacao da SZ7³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function VLDSZ7()

Local _lRet   	:= .T.
Local _nVal   	:= 0
Local _nConta 	:= 0
Local _nPerAP 	:= GetMV("MV_XPERAP")
Local aArea   	:= GetArea()
Local nVlrSC7 	:= 0

//Local nVlMin  	:= 0
//Local nFaixa	:= 0
//Local nVlFaixa1 := 0
//Local nVlFaixa2 := 0

//Local cNivel	:= "00"


// Fabio Jadao Caires - 29/11/2017
// Verifica se o parametro RN_VLMINPA e RN_VLMNPA2 existem na SX6, e o cria caso nao exista
/*
SX6->( DbSetOrder(1) )
If	!SX6->( DbSeek( xFilial("SX6") + "RN_VLMINPA") )
	
	RecLock("SX6",.T.)

	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "RN_VLMINPA"
	SX6->X6_TIPO 	:= "N"
	SX6->X6_DESCRIC	:= "Valor minimo para adiantamento PA"
	SX6->X6_CONTEUD	:= "10000"
	
	SX6->( MsUnlock() )
	
EndIf

If	!SX6->( DbSeek( xFilial("SX6") + "RN_VLAPR01") )
	
	RecLock("SX6",.T.)

	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "RN_VLAPR01"
	SX6->X6_TIPO 	:= "N"
	SX6->X6_DESCRIC	:= "Valor da Faixa de Aprovação PA Nivel1"
	SX6->X6_CONTEUD	:= "10000"
	
	SX6->( MsUnlock() )
	
EndIf

If	!SX6->( DbSeek( xFilial("SX6") + "RN_VLAPR02") )
	
	RecLock("SX6",.T.)

	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "RN_VLAPR02"
	SX6->X6_TIPO 	:= "N"
	SX6->X6_DESCRIC	:= "Valor da Faixa de Aprovação PA Nivel2"
	SX6->X6_CONTEUD	:= "100000"
	
	SX6->( MsUnlock() )
	
EndIf

If	!SX6->( DbSeek( xFilial("SX6") + "RN_GRPPA") )
	
	RecLock("SX6",.T.)

	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "RN_GRPPA"
	SX6->X6_TIPO 	:= "C"
	SX6->X6_DESCRIC	:= "Grupo de aprovacao padrao de pre-adiantamento"
	SX6->X6_DESC1	:= "Inicializador padrao do campo Z7_GRAPROV"
	SX6->X6_CONTEUD	:= "000305"
	
	SX6->( MsUnlock() )
	
	SX3->( DbSetOrder(2) )	// X3_CAMPO
	If	SX3->( DbSeek( "Z7_GRAPROV" ))
	
		If	SX3->X3_RELACAO == ""
			Reclock("SX3",.F.)
			SX3->X3_RELACAO := 'GetMV("RN_GRPPA")'
			SX3->( MsUnlock() )
		EndIf
		
	EndIf
	
EndIf


nVlMin  	:= GetMV("RN_VLMINPA")
nVlFaixa1 	:= GetMV("RN_VLAPR01")
nVlFaixa2 	:= GetMV("RN_VLAPR02")

// Fim do bloco alterado.
*/
DbSelectArea("SZ7")
dbSetOrder(1)

IF 	M->Z7_VENCTO < M->Z7_DATALIB
	Aviso("Pagamento Antecipado", "Data vencimento inferior a data de liberacao ", {" Ok "})
	_lRet := .F.
ENDIF

IF 	M->Z7_STATUS = "1"
	Aviso("Pagamento Antecipado", "PA já aprovado, para alterar deve excluir o adiantamento ", {" Ok "})
	_lRet := .F.
ENDIF

If 	!Empty(M->Z7_NUMPED)

	// Posiciono na amarração de Pedidos x PAs
	//	FIE->(dbSetOrder(1))
	//	FIE->(dbSeek(xFilial("FIE")+"P"+M->Z7_NUMPED))
	//	WHILE FIE->(!EOF()) .AND. M->Z7_NUMPED = FIE->FIE_PEDIDO
	//		_nVal := _nVal + FIE->FIE_VALOR
	//		FIE->(dBskip())
	//	ENDDO
	 
	DbSelectArea('SZ7')
	SZ7->( DbSetOrder(2) )
	If 	SZ7->( DbSeek(xFilial('SZ7') + M->Z7_FORNECE + M->Z7_LOJA + M->Z7_NUMPED ) ) 
	  	While SZ7->(!Eof()) .And. xFilial('SZ7') == SZ7->Z7_FILIAL .And. SZ7->Z7_FORNECE == M->Z7_FORNECE .And. SZ7->Z7_LOJA == M->Z7_LOJA .And. SZ7->Z7_NUMPED == M->Z7_NUMPED 
	  		If 	SZ7->Z7_NUMSEQ <> M->Z7_NUMSEQ // Wellington???
	  			_nVal += SZ7->Z7_VALOR 
	  		EndIf                
	  		SZ7->(DbSkip())
	  	EndDo
	EndIf
 	
	// Posiciono no Pedidos de Compras
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7")+M->Z7_NUMPED))
	While SC7->(!Eof()) .And. xFilial('SC7') == SC7->C7_FILIAL .And. SC7->C7_NUM == M->Z7_NUMPED
		nVlrSC7 += SC7->C7_TOTAL+SC7->C7_VALIPI	// INSERIDO Andre Couto O VaLOR DO IPI  15/07/2021	
		SC7->(DbSkip())	
	EndDo                                                    
	M->Z7_VALORAD :=_nVal//GRAVA O VALOR TOTAL DOS ADIANTAMENTOS JA INCLUIDOS PARA O PEDIDO     
	
	
	    IF (M->Z7_VALOR + _nVal) > nVlrSC7 	 
			Aviso("Pagamento Antecipado", "Valor do adiantamento superior ao PC."+ CRLF + "Valor pedido de compra: "+ ALLTRIM(TransForm( nVlrSC7,"@e 999,999,999.99"))+ CRLF + "Valor Max. de adiantamento permitido: "+ ALLTRIM(TransForm( (nVlrSC7),"@e 999,999,999.99")), {" Ok "})	
		   	_lRet := .f.
		EndIf

//		If ( M->Z7_VALOR + _nVal ) > nVlMin  	
/* Trava Retirada - solicitado por controles internos	
			IF (M->Z7_VALOR+_nVal )> ((nVlrSC7 * _nPerAP)/100)
				//	Aviso("Pagamento Antecipado", "Valor superior ao percentual permitido no PC ", {" Ok "})
				Aviso("Pagamento Antecipado", "Valor do adiantamento superior ao percentual permitido para este PC."+ CRLF + "Valor pedido de compra: "+ ALLTRIM(TransForm( nVlrSC7,"@e 999,999,999.99"))+ CRLF + "Valor Max. de adiantamento permitido: "+ ALLTRIM(TransForm( (nVlrSC7 * _nPerAP)/100,"@e 999,999,999.99")), {" Ok "})
				_lRet := .F.
			ENDIF
*/			

EndIf

_nVal 	:= 0  //Zerar o valor de adto sobre o percentual
_nConta := 0

If !Empty(M->Z7_CONTRA)
				//Verificar adiantamentos de Contrato x PAs
				SZ7->(dbSetOrder(3))
				SZ7->(dBGoTop())
				SZ7->(dbSeek(xFilial("SZ7")+M->Z7_FORNECE+M->Z7_LOJA+M->Z7_CONTRA+M->Z7_REVISAO))
				WHILE SZ7->(!EOF()) .AND. xFilial('SZ7') == SZ7->Z7_FILIAL  ;
									.AND. M->Z7_FORNECE  == SZ7->Z7_FORNECE ;
									.AND. M->Z7_LOJA     == SZ7->Z7_LOJA    ;
									.AND. M->Z7_CONTRA   == SZ7->Z7_CONTRA  ;
									.AND. M->Z7_REVISAO  == SZ7->Z7_REVISAO   
									
					If 	SZ7->Z7_NUMSEQ <> M->Z7_NUMSEQ 
						_nVal = _nVal + SZ7->Z7_VALOR
					EndIf
											
					SZ7->(dBskip())
					
				ENDDO
	// Posiciono o cadastro de Contrato
	CN9->( DbSetOrder(1) )
	CN9->( DbSeek(xFilial("CN9")+M->Z7_CONTRA+M->Z7_REVISAO) )
	_nPerAP  := CN9->CN9_XPERAD
	_nSaldoC := CN9->CN9_SALDO
	
	
    M->Z7_VALORAD :=_nVal//GRAVA O VALOR TOTAL DOS ADIANTAMENTOS JA INCLUIDOS PARA O CONTRATO / REVISÃO  
    
    
   //VALOR DO ADIANTAMENTO NÃO PODE SER MAIOR QUE O SALDO DO CONTRATO
	 	IF (M->Z7_VALOR + _nVal) > _nSaldoC 
			Aviso("Pagamento Antecipado","Valor já adiantado: "+ TransForm(_nVal,"@e 999,999,999.99")+ CRLF + "Valor Permitido: "+ TransForm( (_nSaldoC),"@e 999,999,999.99") + CRLF + "Valor superior ao Contrato ", {" Ok "},1,"Valor Saldo Contrato: " + TRANSFORM(_nSaldoC,"@e 999,999,999.99")) 	
		   	_lRet := .f.
		EndIf

	
/* trava de percentual retirada solicita por controles internos	
	 	IF (M->Z7_VALOR + _nVal) > ((_nSaldoC * _nPerAP)/100)
			Aviso("Pagamento Antecipado","Valor já adiantado: "+ TransForm(_nVal,"@e 999,999,999.99")+ CRLF + "Valor Permitido: "+ TransForm( (_nSaldoC * _nPerAP)/100,"@e 999,999,999.99") + CRLF + "Valor superior ao percentual permitido no Contrato ", {" Ok "},1,"Valor Saldo Contrato: " + TRANSFORM(_nSaldoC,"@e 999,999,999.99")) 
			
			//Aviso( "Atencao", "Solicitação de compra não pode estar em branco.", { "Ok" }, 1, "Solicitação de compra requerida." )		
		   	_lRet := .f.
		EndIf
*/
	
EndIf

If 	Inclui
	IF 	EMPTY(M->Z7_NUMPED) .AND. EMPTY(M->Z7_CONTRA)
		Aviso("SZ7", "Campos Pedido e Contrato não preenchidos ", {" Ok "})
		_lRet := .F.
		Return(_lRet)
	ENDIF
ElseIf Altera
	IF 	EMPTY(M->Z7_NUMPED) .AND. EMPTY(M->Z7_CONTRA)
		Aviso("SZ7", "Campos Pedido e Contrato não preenchidos ", {" Ok "})
		_lRet := .F.
		Return(_lRet)
	ENDIF
Endif
           
RestArea( aArea )

Return(_lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a legenda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function RNOLEG()

BrwLegenda(cCadastro,OemtoAnsi("Legenda"),{;
{'BR_AZUL'     , "Aguardando aprovação"		},;
{'BR_VERDE'    , "Aprovado"            		},;
{'BR_LARANJA'  , "Reprovado"           		},;
{'BR_PINK'     , "Erro - não gerou título" 	}})
Return
//============================================
// Reenvia Workflok para aprovação³          
// Data:26/03/2021
// Autor : André Couto
//============================================
User function PrepPAWF()
	Local _lRet 	:= .t.
	Local _aArea  := GetArea()  

If SZ7->Z7_STATUS <> "2"
	   	MsgBox( "Solicitação nao está com Status bloqueada, não pode ser reenviada para aprovação",  "Solicitação bloqueada" , "INFO")  
	   	_lRet 	:= .f.
	Else 
		If MsgYesNo("Confirma Re-envio para o aprovador da Sc  "+ SZ7->Z7_NUMSEQ+" ?") 
        	DbSelectArea("SCR")
			DbSetOrder(1)
			If SCR->(DbSeek(xFilial("SCR") + "PA" + Padr(SZ7->Z7_NUMSEQ, TamSX3("CR_NUM")[1])))  
			   	While SCR->(CR_FILIAL + CR_TIPO + CR_NUM) = xFilial("SCR") + "PA" + Padr(SZ7->Z7_NUMSEQ, TamSX3("CR_NUM")[1]).AND. SCR->CR_STATUS = "02"  .and. !SCR->(Eof()) 
			   		DbSelectArea("SAK")
					DbSetOrder(1)
					//SE O USUÁRIO TIVER COM A DATA PREENCHIDA, ELE VERIFICA SE HOJE O INTERVALO ESTÁ ATIVO
					IF SAK->(DbSeek(xFilial("SAK")+SCR->CR_APROV)) .AND. (!Empty(SAK->AK_XDTFERI) .And. !Empty(SAK->AK_XDFERIA))
						IF (Date() >= SAK->AK_XDTFERI .And. Date() <= SAK->AK_XDFERIA)
							IF !Empty(SAK->AK_APROSUP)								
								Reclock("SCR",.F.) //Jogo aqui pra dentro o código do usuáiro do APROVADOR SUPERIOR
									SCR->CR_USER := Posicione("SAK",1,xFilial("SAK")+SAK->AK_APROSUP,"AK_USER")
									SCR->CR_WF		:= Space(01)
									SCR->CR_WFID   	:= Space(10) //CR_XWFID
									SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
									SCR->CR_HRLIMIT	:= Space(5)
								MSUnlock()
								MsgInfo("Tempo previsto para reenvio do PA: "+SZ7->Z7_NUMSEQ+Chr(13)+Chr(10)+;
										"Aproximadamente 5 minutos. Aguarde!!!" ) 
							ELSE
								Alert("Usuário está em período de férias, por gentileza verifique o cadastro de APROVADOR")
							ENDIF
						ELSE
							Reclock("SCR",.F.)//Retorna o aprovador padrão se periodo de ferias acabou
                                SCR->CR_USER := Posicione("SAK",1,xFilial("SAK")+SAK->AK_COD,"AK_USER")//fim do periodo de ferias
								SCR->CR_WF		:= Space(01)
								SCR->CR_WFID   	:= Space(10) //CR_XWFID
								SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
								SCR->CR_HRLIMIT	:= Space(5)
							MSUnlock()
							MsgInfo("Tempo previsto para reenvio do PA: "+SZ7->Z7_NUMSEQ+Chr(13)+Chr(10)+;
									"Aproximadamente 5 minutos. Aguarde!!!" ) 																	
						ENDIF
					ELSE
						Reclock("SCR",.F.)
							SCR->CR_WF		:= Space(01)
							SCR->CR_WFID   	:= Space(10) //CR_XWFID
							SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
							SCR->CR_HRLIMIT	:= Space(5)
						MSUnlock()	
						MsgInfo("Tempo previsto para reenvio do PA: "+SZ7->Z7_NUMSEQ+Chr(13)+Chr(10)+;
								"Aproximadamente 5 minutos. Aguarde!!!" ) 										
					ENDIF
				SCR->(DbSkip())
				Enddo						
            Endif
        Endif
	Endif	
RestArea(_aArea)          
Return _lRet

					   /*If SCR->CR_STATUS = "02"
						RecLock("SCR",.F.)
						SCR->CR_WF		:= Space(01)
						SCR->CR_WFID   	:= Space(10) //CR_XWFID
						SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
						SCR->CR_HRLIMIT	:= Space(5)
						MSUnlock()
					Endif
				SCR->(DbSkip())
				Enddo						
            Endif
		   	MsgInfo("Tempo previsto para reenvio do PA: "+SZ7->Z7_NUMSEQ+Chr(13)+Chr(10)+;
			"Aproximadamente 5 minutos. Aguarde!!!" )  
        Endif
	Endif	
	RestArea(_aArea)          
	Return _lRet
*/
//////////////////////////
// Rotina de WORKFLOW   //
//////////////////////////
/*
Static Function EnviaPA(_cOpcao, _nRec)

Local _aArea 	:= GetArea("SZ7")
//Local _cRespWF 	:= ""	//Posicione("CTT",1,xFilial("CTT")+SZ7->Z7_CCUSTO, "CTT_XRSPWF")   // Wellington???
Local _cRespWF 	:= Posicione("CTT",1,xFilial("CTT")+SZ7->Z7_CCUSTO, "CTT_XRSPWF")
Local _cAprov  	:= ''

If 	_cRespWF == 'G'
	_cAprov := Posicione("CTT",1,xFilial("CTT")+SZ7->Z7_CCUSTO, "CTT_XGEST")
ElseIf _cRespWF == 'D'
	_cAprov := Posicione("CTT",1,xFilial("CTT")+SZ7->Z7_CCUSTO, "CTT_XDIRET")
Endif

//SAK->( DbSetOrder(1) )	//	AK_FILIAL + AK_COD
//SAK->( DbSeek( xFilial("SAK") + SZ7->Z7_APROV ) )

//IF	SAK->( EOF()) 
//	_cAprov	:= ""
//Else
//	_cAprov := SAK->AK_USER
//EndIf

If 	Empty(_cAprov)
	Alert("Aprovador nao definido, WF nao será enviado")
Else
	MsgRun("Aguarde, Enviando WorkFlow...",,{|| U_WFEnvAP( _cOpcao, _nRec, _cAprov ) })
Endif

RestArea(_aArea)

Return .t.
*/
/*

User Function WFEnvAP(cOpcao, nRec, cAprov) // inclusao ou alteracao //

Local _cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  ))  //Wellington???

oProcess:= TWFProcess():New( "000001", "Aprovação de PA" )
oProcess:NewTask( "Aprovação de Adiantamento", "\WORKFLOW\html\PAAprov_RENOVA.htm" )
oProcess:cSubject := "Aprovacao de Adiantamento: "+SZ7->Z7_NUMSEQ + " - " +Posicione("SM0",1,cEmpAnt+xFilial("SZ7"),"M0_FILIAL")

oProcess:bReturn := "U_WFRetPA()"
oHtml := oProcess:oHTML

oHtml:ValByName( "Z7_EMISSAO"	,	DtoC(SZ7->Z7_EMISSAO) )
oHtml:ValByName( "Z7_FILIAL"	,	SZ7->Z7_FILIAL 	)
oHtml:ValByName( "Z7_FILNOM"	,	Posicione("SM0",1,cEmpAnt+xFilial("SZ7"),"M0_FILIAL") 	)
oHtml:ValByName( "Z7_FORNECE"	,	SZ7->Z7_FORNECE )
oHtml:ValByName( "Z7_LOJA"		,	SZ7->Z7_LOJA 	)
oHtml:ValByName( "A2_NREDUZ"	,	Posicione("SA2",1,xFilial("SA2")+SZ7->Z7_FORNECE+SZ7->Z7_LOJA,"A2_NREDUZ") )
oHtml:ValByName( "Z7_VENCTO"	,	DtoC(SZ7->Z7_VENCTO) )
oHtml:ValByName( "Z7_VALOR"		,	TRANSFORM( SZ7->Z7_VALOR,PesqPict("SZ7", "Z7_VALOR") ) )
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
//oHtml:ValByName( "Z7_APROV"		,	Alltrim(SZ7->Z7_APROV) + " - " +  Alltrim(SZ7->Z7_NMAPROV) 	)

oProcess:cTo      		:= nil
oProcess:NewVersion(.T.)
oHtml     				:= oProcess:oHTML
oProcess:nEncodeMime 	:= 0
cMailID 				:= oProcess:Start("\workflow\emp"+cEmpAnt+"\wfpa\")   //Faz a gravacao do e-mail no cPath

chtmlfile  				:= cMailID + ".htm"

oProcess:newtask("Link"			, "\workflow\html\Link_renova.htm")  //Cria um novo processo de workflow que informara o Link ao usuario

oHtml:ValByName( "cDocto"	    , "Aprovação de Adiantamento No. "+SZ7->Z7_NUMSEQ)
oHtml:ValByName( "descproc"	    , "O Adiantamento abaixo aguarda sua aprovação. Para visualizá-lo clique no link abaixo:")
oHtml:ValByName( "cNomeProcesso", Alltrim(GetMv("MV_WFDHTTP")) + "/workflow/emp" + cempant + "/wfpa/" + chtmlfile ) // envia o link onde esta o arquivo html

oProcess:cTo 	  := Iif(!Empty(_cDestFixo),_cDestFixo, UsrRetMail(cAprov)) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
oProcess:cSubject := "Aprovacao de Adiantamento: "+SZ7->Z7_NUMSEQ + " - " +Posicione("SM0",1,cEmpAnt+xFilial("SZ7"),"M0_FILIAL")
oProcess:Start()

Return .T.
*/
/*
User function WFRetPA(oProcess)
Local nRecnoSZ7 	:= 0
Local _cDestFixo 	:= Alltrim(SuperGetMv( "MV_WFXDEST" , .F. , "wmendes@renovaenergia.com.br" ,  ))

Local cOpc     		:= alltrim(oProcess:oHtml:RetByName("OPC"))
Local cFil     		:= alltrim(oProcess:oHtml:RetByName("Z7_FILIAL"))
Local cDoc    		:= alltrim(oProcess:oHtml:RetByName("Z7_NUMSEQ"))
Local cUsr     		:= alltrim(oProcess:oHtml:RetByName("Z7_USUINCL"))
Local cChave 		:= cFil+cDoc
Local _lRet 		:= .T.

Private cWFObs     	:= alltrim(oProcess:oHtml:RetByName("WFOBS"))

Conout("WFRetPA - Processa O RETORNO DO EMAIL")
Conout("WFRetPA - EmpFil:" + cEmpAnt + cFilAnt)

oProcess:Finish() // FINALIZA O PROCESSO

If 	cOpc == "S"
	Conout("Titulo: "+ cChave + " Aprovado")
Else
	Conout("Titulo: "+ cChave + " Reprovado")
EndIf

If 	SZ7->(dbSeek(cChave))
	
	//Iif(cOpc=="S","1","3")
	
	If 	cOpc=="S"
		// Chamada da MSExecAuto - Desenvolvida por Iuspa / Antonio
		_lRet := U_RNO003()
	Else
		Reclock("SZ7",.F.)
			SZ7->Z7_WFOBS 	:= cWFObs
			SZ7->Z7_DATALIB := Date()
			SZ7->Z7_STATUS  := "3"
		MsUnlock()
	EndIf
Endif

oProcess	:= TWFProcess():New("00000","P.A. - "+Iif(_lRet==.T.,Iif(cOpc == "S","Aprovado","Reprovado"),"Erro na MSExecAuto"))
oProcess:NewTask('Envio','\WORKFLOW\html\PAResp_RENOVA.htm')
oProcess:nEncodeMime 	:= 0
oHtml		:= oProcess:oHtml

oHtml:ValByName( "RESPOSTA"		,	Iif(_lRet==.T.,Iif(cOpc == "S","Aprovado","Reprovado"),"Erro na MSExecAuto"))
oHtml:ValByName( "Z7_FILIAL"	,	SZ7->Z7_FILIAL 	)
oHtml:ValByName( "Z7_FILNOM"	,	Posicione("SM0",1,cEmpAnt+xFilial("SZ7"),"M0_FILIAL") 	)
oHtml:ValByName( "Z7_NUMTIT"	,	SZ7->Z7_NUMTIT )
oHtml:ValByName( "Z7_EMISSAO"	,	DtoC(SZ7->Z7_EMISSAO) )
oHtml:ValByName( "Z7_FORNECE"	,	SZ7->Z7_FORNECE )
oHtml:ValByName( "Z7_LOJA"		,	SZ7->Z7_LOJA 	)
oHtml:ValByName( "A2_NREDUZ"	,	Posicione("SA2",1,xFilial("SA2")+SZ7->Z7_FORNECE+SZ7->Z7_LOJA,"A2_NREDUZ") )
oHtml:ValByName( "Z7_VENCTO"	,	DtoC(SZ7->Z7_VENCTO) )
oHtml:ValByName( "Z7_VALOR"		,	TRANSFORM( SZ7->Z7_VALOR,PesqPict("SZ7", "Z7_VALOR") ) )
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
oHtml:ValByName( "Z7_WFOBS"		,	SZ7->Z7_WFOBS 	)
oHtml:ValByName( "Z7_OBS"		,	SZ7->Z7_OBS 	)
//oHtml:ValByName( "Z7_APROV"		,	Alltrim(SZ7->Z7_APROV) + " - " +  Alltrim(SZ7->Z7_NMAPROV) 	)

If 	_lRet := .T.
	oProcess:cTo	:= Iif(!Empty(_cDestFixo),_cDestFixo, UsrRetMail(cUsr)) //MV_WFXDEST, tipo texto: Se preenchido com um endereço de e-mail, deverá ocorrer desvio de todos os processos de workflow para este endereço. Se o parâmetro não existir seguirá o fluxo normal.
Else
	oProcess:cTo	:= GetMV("MV_WFADMIN")
Endif
	
If 	Empty(oProcess:cTo)
	Conout("Usuário " + cUsr + " não tem e-mail cadastrado.")
EndIf
	
//	oProcess:cSubject	:= "P.A. "+Iif(cOpc == "S","Aprovada","Reprovada")+": " + Alltrim(Posicione("SA2",1,xFilial("SA2")+SZ7->Z7_FORNECE+SZ7->Z7_LOJA,"A2_NREDUZ"))
oProcess:cSubject := "Adiantamento "+Iif(_lRet==.T.,Iif(cOpc == "S","Aprovado","Reprovado"),"- Erro na MSExecAuto")+": " + SZ7->Z7_NUMSEQ + " - " +Posicione("SM0",1,cEmpAnt+xFilial("SZ7"),"M0_FILIAL")
oProcess:Start()

Return

*/


// Dar a tratativa adequada: Validar se existe na SE2, se está pago, etc...
Static Function VldDeleta()

Local lRetorno	:= .F.
Local aAreaDel	:= GetArea()
Local aArray	:= {}

Private lMsErroAuto := .F.

Begin Transaction

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
IF 	SE2->(DBSEEK(xFilial("SE2")+SZ7->Z7_PREFIXO+SZ7->Z7_NUMTIT+SZ7->Z7_PARCELA+"PA "))
	AAdd( aArray, { "E2_PREFIXO" , SE2->E2_PREFIXO 	, NIL } )
	AAdd( aArray, { "E2_NUM"     , SE2->E2_NUM      , NIL } )
	AAdd( aArray, { "E2_PARCELA" , SE2->E2_PARCELA	, NIL } )
	AAdd( aArray, { "E2_TIPO"    , SE2->E2_TIPO     , NIL } ) 

	If 	!Empty( SZ7->Z7_NUMPED )	
	
		FIE->(dbSetOrder(3))	
		If 	FIE->(MsSeek(xFilial("FIE")+"P"+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)))	
			RecLock('FIE',.F.)
				FIE->(DbDelete())
			FIE->(MsUnlock())
		Endif
	EndIf
		
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	If 	lMsErroAuto  
		DisarmTransaction()
		MostraErro()
	Else
		lRetorno := .T.
		DbSelectArea("CNX")             //Contratos   -   TP_CONT = 1 - Compras
		CNX->(DBSETORDER(1))
		IF CNX->(DBSEEK(xFilial("CNX")+SZ7->Z7_CONTRA))
			WHILE CNX->(!EOF()) .AND. xFilial('SZ7') == SZ7->Z7_FILIAL ;
				.AND. SZ7->Z7_CONTRA == CNX->CNX_CONTRA
				If CNX->CNX_NUMTIT == SZ7->Z7_NUMTIT
					RecLock("CNX",.F.)
					CNX->(Dbdelete())
					MsUnLock()
				EndIf
				CNX->(dBskip())
			ENDDO
		EndIf
	Endif
Else
	lRetorno := .T.
EndIF

End Transaction
	
RestArea(aAreaDel)

Return( lRetorno )


//#include "fivewin.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³VerAprov ³ Autor ³ Pedro Augusto          ³ Data ³19/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma tela de consulta do status do Adiantamento        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RENOVA                                                     ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AprovSZ7() //)
	LOCAL bCampo
	LOCAL oDlg, oGet
	LOCAL nAcols := 0,nOpca := 0
	LOCAL cCampos
	LOCAL cSituaca := "",lBloq := .F.
	LOCAL cStatus  
	LOCAL oBold
	LOCAL nCntFor :=""
	
	If Empty(SZ7->Z7_USUINCL)
		Aviso("Atencao","Este Documento nao possui controle de aprovacao via Workflow.",{"Voltar"})
	
		dbSelectArea("SZ7")
		Return nOpca
	EndIf           
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre o arquivo SCR sem filtros    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ChkFile("SCR",.F.,"TMP")
	_cUsuario 	:= UsrRetName(SZ7->Z7_USUINCL)
	cStatus  	:= ""
	IF SZ7->Z7_STATUS == '1'
		cStatus := OemToAnsi("Adiantamento aprovado")
	endif
	IF SZ7->Z7_STATUS =='2'
		cStatus := OemToAnsi("Aguardando Liberação")
	endif
	IF SZ7->Z7_STATUS == '3'
		cStatus := OemToAnsi("Adiantamento Reprovado")
	endif
	
	aCols := {}
	aHeader := {}
	
	dbSelectArea("TMP")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+"PA"+SZ7->Z7_NUMSEQ,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a entrada de dados do arquivo                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aTELA[0][0],aGETS[0],Continua,nUsado:=0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aHeader com os campos fixos.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCampos := "CR_NIVEL/CR_OBS/CR_DATALIB"
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SCR")
	While !EOF() .And. (x3_arquivo == "SCR")
		IF AllTrim(x3_campo)$cCampos
			nUsado++
			AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
				       x3_tamanho, x3_decimal, x3_valid,;
				       x3_usado, x3_tipo, x3_arquivo, x3_context } )
			If AllTrim(x3_campo) == "CR_NIVEL"
				AADD(aHeader,{ OemToAnsi("Usuario"),"bCR_NOME", "@",;    //
				     15, 0, "","","C","",""} )
				nUsado++		
				AADD(aHeader,{ OemToAnsi("Situacao"),"bCR_SITUACA", "@",;    //
				     20, 0, "","","C","",""} )
				nUsado++						
				AADD(aHeader,{ OemToAnsi("Usuario Lib."),"bCR_NOMELIB", "@",;    //
				     15, 0, "","","C","",""} )
				nUsado++						
			EndIf					 
		Endif
		dbSkip()
	End
	dbSelectArea("TMP")
	While	!Eof() .And. CR_FILIAL+CR_TIPO+Alltrim(CR_NUM) == xFilial("SCR")+"PA"+ALLTRIM(SZ7->Z7_NUMSEQ)
		aadd(aCols,Array(nUsado+1))
		nAcols ++
		For nCntFor := 1 To nUsado
			If aHeader[nCntFor][02] == "bCR_NOME"
				aCols[nAcols][nCntFor] := UsrRetName(TMP->CR_USER)
			ElseIf aHeader[nCntFor][02] == "bCR_SITUACA"
			   Do Case
					Case TMP->CR_STATUS == "01"
						cSituaca := OemToAnsi("Aguardando") //
					Case TMP->CR_STATUS == "02"
						cSituaca := OemToAnsi("Em Aprovacao") //
					Case TMP->CR_STATUS == "03"
						cSituaca := OemToAnsi("Aprovado")  //					
					Case TMP->CR_STATUS == "04"
						cSituaca := OemToAnsi("Bloqueado") //	
						lBloq := .T.
					Case TMP->CR_STATUS == "05"
						cSituaca := OemToAnsi("Nivel Liberado ") // 
					EndCase
				aCols[nAcols][nCntFor] := cSituaca
			ElseIf aHeader[nCntFor][02] == "bCR_NOMELIB"
				aCols[nAcols][nCntFor] := UsrRetName(TMP->CR_USERLIB)			
			ElseIf ( aHeader[nCntFor][10] != "V")
				aCols[nAcols][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			EndIf
		Next nCntFor
		aCols[nAcols][nUsado+1] := .F.
		dbSkip()
	EndDo
	
	If Empty(aCols)
		Aviso("Atencao",OemToAnsi("Este adiantamento nao possui registros de aprovação."),{"Voltar"})
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		dbSelectArea("SZ7")
		Return nOpca
	EndIf
	
	If lBloq
		cStatus := OemToAnsi("ADIANTAMENTO BLOQUEADO") 
	EndIf
	
	Continua := .F.
	nOpca := 0
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg TITLE OEMTOANSI("Aprovação de adiantamento") From 109,95 To 400,600 OF oMainWnd PIXEL	 //
		@ 5,3 TO 32,250 LABEL "" OF oDlg PIXEL
		@ 15,7 SAY OemToAnsi("Numero") Of oDlg FONT oBold PIXEL SIZE 46,9 // 
		@ 14,32 MSGET SZ7->Z7_NUMSEQ Picture "@"  When .F. PIXEL SIZE 38,9 Of oDlg FONT oBold
		@ 15,103 SAY OemToAnsi("Usuário")  Of oDlg PIXEL SIZE 33,9 FONT oBold //
		@ 14,138 MSGET _cUsuario Picture "@" When .F. of oDlg PIXEL SIZE 103,9 FONT oBold
		@ 132,8 SAY OemToAnsi("Situação :") Of oDlg PIXEL SIZE 52,9 //''
		@ 132,38 SAY cStatus Of oDlg PIXEL SIZE 120,9 FONT oBold
		@ 132,205 BUTTON "Fechar" SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End()) Of oDlg PIXEL  //''
		oGet := MSGetDados():New(38,3,120,250,1,,,"")
	   @ 126,2   TO 127,250 LABEL '' OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	
	#IFNDEF WINDOWS
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Restaura a integridade da janela                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SetCursor(cSavCur5)
		DevPos(cSavRow5,cSavCol5)
		SetColor(cSavCor5)
		RestScreen(3,0,24,79,cSavScr5)
	#ENDIF
	
	dbSelectArea("SZ7")
	Return nOpca
	

//==============================================================================================================
// Gatilho para campo Z7_CONTRA
// Retorna valor conforme o campo informado: Z7_FORNECE / Z7_LOJA / Z7_ITEMCTA / Z7_CLVL / Z7_EC05DB / Z7_CCUSTO
// Se CNA_TIPPLA = "99J" - utiliza entidades contábeis do SC1
// Qualquer outro tipo utiliza do CNB
//
// Data: 31/08/2021
// Autor : Luiz M. Suguiura
//=============================================================================================================

User function RNGAT001(cCampo)

Local aArea    := GetArea()
Local cRet     := ""
Local cRevisao := ""

Default cCampo := ""

cCampo := AllTrim(cCampo)

if !cCampo $ "Z7_FORNECE;Z7_LOJA;Z7_ITEMCTA;Z7_CLVL;Z7_EC05DB;Z7_CCUSTO"
   return(cRet)
endif

dbSelectArea("CNA")
dbSetOrder(1)
dbSeek(xFilial("CNA")+M->Z7_CONTRA)

if CNA->CNA_TIPPLA = "99J"
   dbSelectArea("SC1")
   dbSetOrder(1)
   dbSeek(xFilial("SC1")+CNA->CNA_XSC)
else
   dbSelectArea("CN9")
   dbSetOrder(1)
   dbSeek(xFilial("CN9")+M->Z7_CONTRA)

   dbSelectArea("CNB")
   dbSetOrder(1)
   dbSeek(xFilial("CNB")+M->Z7_CONTRA+CN9->CN9_REVATU)
endif

do case
   case cCampo = "Z7_FORNECE"
        cRet := CNA->CNA_FORNEC
   case cCampo = "Z7_LOJA"
        cRet := CNA->CNA_LJFORN
   case cCampo = "Z7_ITEMCTA"
        if CNA->CNA_TIPPLA = "99J"
           cRet := SC1->C1_ITEMCTA
        else
           cRet := CNB->CNB_ITEMCT
        endif
   case cCampo = "Z7_CLVL"
        if CNA->CNA_TIPPLA = "99J"
           cRet := SC1->C1_CLVL
        else
           cRet := CNB->CNB_CLVL
        endif
   case cCampo = "Z7_EC05DB"
        if CNA->CNA_TIPPLA = "99J"
           cRet := SC1->C1_EC05DB
        else 
           cRet := CNB->CNB_EC05DB
        endif 
   case cCampo = "Z7_CCUSTO"
        if CNA->CNA_TIPPLA = "99J"
           cRet := ""
        else
           cRet := CNB->CNB_CC
        endif 
endcase

RestArea(aArea)

Return(cRet)

