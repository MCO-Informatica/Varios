#Include "Rwmake.ch"
#include "protheus.ch"
/*/{Protheus.doc} 
description
@type function
@version AaDd(aRotina, {"Reenvia p/ aprovacao", 	'U_EnvCTWF()'   ,0,2,0,NIL})// incluido em 04/12/2020 couto
@author andlcouto
@since 04/12/2020              
Re-envia o link para aprovação
/*/
User Function EnvCTWF() 

Local _lRet   := .T.
Local _aArea  := GetArea() 
Local _cTipo  := CN9->CN9_SITUACA
Local _cRtip :=""
 
	If !(CN9->CN9_SITUACA $ "04#09")
	   	MsgInfo("A Situação do Contrato :" +CN9->CN9_NUMERO+Chr(13)+Chr(10)+;
		" nao está apta para Aprovação")  
	   	_lRet 	:= .F. 
	Endif
If _cTipo == "04" // EM APROVAÇÃO
	 _cRtip:="CT"            
		// MsgYesNo("Olá Mundo, agora é " + Time(), "Confirma?")
		If MsgYesNo("Confirma Re-envio para o aprovador do Contrato  "+ CN9->CN9_NUMERO+" ?") 
			DbSelectArea("SCR")
			DbSetOrder(1)
			If SCR->(DbSeek(xFilial("SCR") +  _cRtip + Padr(CN9->CN9_NUMERO+CN9->CN9_REVISA, TamSX3("CR_NUM")[1])))  
			   	While SCR->(CR_FILIAL + CR_TIPO + CR_NUM) = xFilial("SCR")+  _cRtip+Padr(CN9->CN9_NUMERO+CN9->CN9_REVISA, TamSX3("CR_NUM")[1]).AND. SCR->CR_STATUS = "02"  .and. !SCR->(Eof()) 
			   	  DbSelectArea("SAK")
					DbSetOrder(1)//SE O USUÁRIO TIVER COM A DATA PREENCHIDA, ELE VERIFICA SE HOJE O INTERVALO ESTÁ ATIVO
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
								MsgInfo("Tempo previsto para reenvio do contrato: "+CN9->CN9_NUMERO+Chr(13)+Chr(10)+;
										"Aproximadamente 15 minutos. Aguarde!!!" ) 
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
							MsgInfo("Tempo previsto para reenvio do contrato: "+CN9->CN9_NUMERO+Chr(13)+Chr(10)+;
									"Aproximadamente 15 minutos. Aguarde!!!" ) 
						ENDIF
					ELSE
						Reclock("SCR",.F.)
							SCR->CR_WF		:= Space(01)
							SCR->CR_WFID   	:= Space(10) //CR_XWFID
							SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
							SCR->CR_HRLIMIT	:= Space(5)
						MSUnlock()	
						MsgInfo("Tempo previsto para reenvio do contrato: "+CN9->CN9_NUMERO+Chr(13)+Chr(10)+;
								"Aproximadamente 15 minutos. Aguarde!!!" ) 
			ENDIF
					SCR->(DbSkip())
				Enddo		
		Endif
    Endif
elseif  _cTipo == "09"// REVISÃO
         _cRtip:="RV"
			If MsgYesNo("Confirma Re-envio para o aprovador da revisão do Contrato  "+ CN9->CN9_NUMERO+" ?") 
				DbSelectArea("SCR")
				DbSetOrder(1)
				If SCR->(DbSeek(xFilial("SCR") +  _cRtip + Padr(CN9->CN9_NUMERO+CN9->CN9_REVISA, TamSX3("CR_NUM")[1])))  
			 	  	While SCR->(CR_FILIAL + CR_TIPO + CR_NUM) = xFilial("SCR")+ _cRtip+Padr(CN9->CN9_NUMERO+CN9->CN9_REVISA, TamSX3("CR_NUM")[1]).AND. SCR->CR_STATUS = "02"  .and. !SCR->(Eof()) 
			   			DbSelectArea("SAK")
					DbSetOrder(1)//SE O USUÁRIO TIVER COM A DATA PREENCHIDA, ELE VERIFICA SE HOJE O INTERVALO ESTÁ ATIVO
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
								MsgInfo("Tempo previsto para reenvio do contrato: "+CN9->CN9_NUMERO+Chr(13)+Chr(10)+;
										"Aproximadamente 15 minutos. Aguarde!!!" ) 
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
							MsgInfo("Tempo previsto para reenvio do contrato: "+CN9->CN9_NUMERO+Chr(13)+Chr(10)+;
									"Aproximadamente 15 minutos. Aguarde!!!" ) 
						ENDIF
					ELSE
						Reclock("SCR",.F.)
							SCR->CR_WF		:= Space(01)
							SCR->CR_WFID   	:= Space(10) //CR_XWFID
							SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
							SCR->CR_HRLIMIT	:= Space(5)
						MSUnlock()	
						MsgInfo("Tempo previsto para reenvio do contrato: "+CN9->CN9_NUMERO+Chr(13)+Chr(10)+;
								"Aproximadamente 15 minutos. Aguarde!!!" ) 
				ENDIF
				SCR->(DbSkip())
				Enddo						
            Endif
        Endif
	Endif
RestArea(_aArea)          
Return _lRet
