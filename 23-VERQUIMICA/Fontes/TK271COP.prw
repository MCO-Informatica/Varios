#Include "Protheus.ch"
#Include "TopConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271COP    �Autor  �Danilo A. D. Busso� Data �  04/27/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada respons�vel por validar a copia do atendi- ���
���          �mento na tela do callcenter. Demanda originada por bug iden-���
���          �tificado pelo usuario (estava permitindo inserir atendimento���
���          �com cliente bloqueado no sistema, apesar do aviso, ele passa���
���          �por todas as etapas do atendimento )						  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				MsgInfo("O C�DIGO " + cCodCli + " e a LOJA " + cCodLoja + " n�o existe no cadastro de clientes!", "Verqu�mica - Notifica��o")
			Else
				If len(aCliente) > 1
					If !MsgYesNo("O C�DIGO " + cCodCli + " possui mais de uma loja cadastrada no sistema, deseja prosseguir a c�pia do atendimento para a loja " + cCodLoja + "?", "Verqu�mica - Notifica��o")
						lRet := .F.
						MsgInfo("Informe a loja desejada", "Verqu�mica - Notifica��o")
					Else
						If aCliente[nPos][3] == '1'
							lRet := .F.
							MsgInfo("O C�DIGO " + cCodCli + " e LOJA " + cCodLoja + " encontra-se bloqueado para utiliza��o, informe outra LOJA ou C�DIGO DE CLIENTE" , "Verqu�mica - Notifica��o")
						EndIf
					EndIf
				Else
					If aCliente[nPos][3] == '1'
						lRet := .F.
						MsgInfo("O C�DIGO " + cCodCli + " e LOJA " + cCodLoja + " encontra-se bloqueado para utiliza��o, informe outra LOJA ou C�DIGO DE CLIENTE" , "Verqu�mica - Notifica��o")
					EndIf
				EndIf
			EndIf	
	Else
		lRet := .F.
		MsgInfo("Data de Entrega n�o pode estar em branco nem ser menor que a Data do Novo Atendimento", "Verqu�mica - Notifica��o")
	EndIf
Else
	lRet := .F.
	MsgInfo("A Rotina de C�pia padr�o da TOTVS foi desabilitada, utilizar a C�PIA ATENDIMENTO","Verqu�mica Notifica��o")
EndIf
	
Return lRet

