#Include "Protheus.ch"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271COP    ºAutor  ³Danilo A. D. Bussoº Data ³  04/27/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada responsável por validar a copia do atendi- º±±
±±º          ³mento na tela do callcenter. Demanda originada por bug iden-º±±
±±º          ³tificado pelo usuario (estava permitindo inserir atendimentoº±±
±±º          ³com cliente bloqueado no sistema, apesar do aviso, ele passaº±±
±±º          ³por todas as etapas do atendimento )						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TK271COP(cNmAten, dNewAtd, cCodCli, cCodLoja, cCodOpe, dDtEnt, lMtDtEnt)
Local lRet := .T.               
Local cQuery := ""
Local cNewAlias := GetNextAlias()
Local aCliente := {}



If IsInCallStack("U_VQCPYTMK")
	
	If dDtEnt >= dNewAtd
			cQuery += " SELECT A1_COD, A1_LOJA, A1_MSBLQL FROM "+ RETSQLNAME("SA1")
			cQuery += " WHERE A1_COD = '"+cCodCli+"'
			cQuery += " AND D_E_L_E_T_ <> '*'"
			
			cQuery := ChangeQuery(cQuery)
			
			If Select(cNewAlias) > 0
				( cNewAlias )->( DbCloseArea() )
			EndIf
			
			TcQuery cQuery New Alias ( cNewAlias )
			
			While !( cNewAlias )->( Eof() )    
			 		Aadd(aCliente, { ( cNewAlias )->A1_COD, ( cNewAlias )->A1_LOJA, ( cNewAlias )->A1_MSBLQL })
				( cNewAlias )->( DbSkip() )
			EndDo
			
			nPos := Ascan(aCliente, {|x| x[1]+x[2]==cCodCli+cCodLoja})
			
			If nPos == 0
				lRet := .F.
				MsgInfo("O CÓDIGO " + cCodCli + " e a LOJA " + cCodLoja + " não existe no cadastro de clientes!", "Verquímica - Notificação")
			Else
				If len(aCliente) > 1
					If !MsgYesNo("O CÓDIGO " + cCodCli + " possui mais de uma loja cadastrada no sistema, deseja prosseguir a cópia do atendimento para a loja " + cCodLoja + "?", "Verquímica - Notificação")
						lRet := .F.
						MsgInfo("Informe a loja desejada", "Verquímica - Notificação")
					Else
						If aCliente[nPos][3] == '1'
							lRet := .F.
							MsgInfo("O CÓDIGO " + cCodCli + " e LOJA " + cCodLoja + " encontra-se bloqueado para utilização, informe outra LOJA ou CÓDIGO DE CLIENTE" , "Verquímica - Notificação")
						EndIf
					EndIf
				Else
					If aCliente[nPos][3] == '1'
						lRet := .F.
						MsgInfo("O CÓDIGO " + cCodCli + " e LOJA " + cCodLoja + " encontra-se bloqueado para utilização, informe outra LOJA ou CÓDIGO DE CLIENTE" , "Verquímica - Notificação")
					EndIf
				EndIf
			EndIf	
	Else
		lRet := .F.
		MsgInfo("Data de Entrega não pode estar em branco nem ser menor que a Data do Novo Atendimento", "Verquímica - Notificação")
	EndIf
Else
	lRet := .F.
	MsgInfo("A Rotina de Cópia padrão da TOTVS foi desabilitada, utilizar a CÓPIA ATENDIMENTO","Verquímica Notificação")
EndIf
	
Return lRet

