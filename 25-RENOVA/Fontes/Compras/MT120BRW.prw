#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
|================================================================|
|Programa.: 	MT120BRW  										 |
|Autor....:	Alcouto												 |
|Data.....: 25/03/2021											 |
|Descricao: 	PE utilizado para adicionar opcoes no aRotina	 |
|  			1) Opcao para remover opcao de aprovacao padrao	     |
|			2) Opcao para Enviar SC para aprovacao (EnvSCWF)     |
|			3) Verifica periodo de ferias para reenvio do wf	 |
|Uso......: 	Renova Energia									 |
|================================================================|
*/

User Function MT120BRW()
	
	AaDd(aRotina, {"Envia p/ aprovacao"	 , 	'U_PrepPCWF' ,0, 2})
	Aadd(aRotina,{"Ajutar data de Entrega", 'U_PClib',0,4,10,Nil})
	Return 
                      
//	Opcao para Enviar PC para aprovacao (chamada da funcao EnvPCWF) 
//	Apenas Refaz o processo de aprovacao 	
User function PrepPCWF()
	Local _lRet 	:= .t.
	Local _aArea  := GetArea()  

	If SC7->C7_CONAPRO <> "B"
	   	MsgBox( "Solicitação nao está com Status bloqueada, não pode ser reenviada para aprovação",  "Solicitação bloqueada" , "INFO")  
	   	_lRet 	:= .f.
	Else 
		If MsgYesNo("Confirma Re-envio para o aprovador da PC  "+ SC7->C7_NUM+" ?") 
        	DbSelectArea("SCR")
			DbSetOrder(1)			
			If SCR->(DbSeek(xFilial("SCR") + "PC" + Padr(SC7->C7_NUM, TamSX3("CR_NUM")[1])))  
				While SCR->(CR_FILIAL + CR_TIPO + CR_NUM) = xFilial("SCR") + "PC" + Padr(SC7->C7_NUM, TamSX3("CR_NUM")[1])  .AND. SCR->CR_STATUS = "02"   .and. !SCR->(Eof()) 
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

								MsgInfo("Tempo previsto para reenvio da PC: "+SC7->C7_NUM+Chr(13)+Chr(10)+;
								"Aproximadamente 5 minutos. Aguarde!!!" )  
							ELSE
								Alert("Usuário está em período de férias, por gentileza verifique o cadastro de APROVADOR")
							ENDIF
						ELSE
							Reclock("SCR",.F.)//Retorna o aprovador padrão se periodo de ferias acabou
                                SCR->CR_USER    := Posicione("SAK",1,xFilial("SAK")+SAK->AK_COD,"AK_USER")//fim do periodo de ferias
								SCR->CR_WF		:= Space(01)
								SCR->CR_WFID   	:= Space(10) //CR_XWFID
								SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
								SCR->CR_HRLIMIT	:= Space(5)
							MSUnlock()
							MsgInfo("Tempo previsto para reenvio da PC: "+SC7->C7_NUM+Chr(13)+Chr(10)+;
							"Aproximadamente 5 minutos. Aguarde!!!" )  																		
						ENDIF
					ELSE
						Reclock("SCR",.F.)
							SCR->CR_WF		:= Space(01)
							SCR->CR_WFID   	:= Space(10) //CR_XWFID
							SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
							SCR->CR_HRLIMIT	:= Space(5)
						MSUnlock()	
						MsgInfo("Tempo previsto para reenvio da PC: "+SC7->C7_NUM+Chr(13)+Chr(10)+;
						"Aproximadamente 5 minutos. Aguarde!!!" )  											
					ENDIF
				SCR->(DbSkip())
				Enddo						
            Endif
        Endif
	Endif	
	RestArea(_aArea)          
	Return _lRet
         