#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MKFAT001 º Autor ³ Paulo - ADV Brasil º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função de usuário que verifica a situação do cliente, quan-º±±
±±º          ³ do da inclusão dos Pedidos de Venda ou orcamento           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                            MANUTENCAO                                 º±±
±±ÌÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º SEQ  ³ DATA       | DESCRICAO                                         º±±
±±ÌÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 001  ³ 02/12/2015 | JUNIOR CARVALHO - Se vier de amostra, não precisa º±±
±±º      ³            | passar pela validacao                             º±±
±±ÈÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MKFAT001()
	//funcao usada nos gatilhos dos campos: C5_CLIENTE(001)  e UA_CLIENTE()
	Local _aArea := GetArea()
	Local _cMens := ""
	Local cChave := M->C5_CLIENTE+M->C5_LOJACLI
	LOCAL lRet := .T.

	IF !IsInCallStack("U_AFT20GPV") .AND. M->C5_CONDPAG <> "100" .AND. !(M->C5_TIPO $ 'D|B')
		// Verifica o status do cliente antes de continuar a análise do PV
		dbSelectArea("SA1")
		dbSetOrder(1)

		If dbSeek(xFilial("SA1")+cChave)

				If	SA1->A1_POSCLI == "A"
					_cMens := "À VISTA"
					IF(M->C5_CONDPAG <> "000" .AND. cEmpAnt == '01') .OR. (alltrim(M->C5_CONDPAG) <> "01" .AND. cEmpAnt == '02') 
						lRet := .F.
						MSGSTOP(OemToAnsi("A Condição de Pagamento deve ser "+ _cMens),"MKFAT001")
					ENDIF
				ElseIf SA1->A1_POSCLI == "B"
					_cMens := "BLOQUEADO"
					MSGSTOP(OemToAnsi("Favor entrar em contato com o Depto. de Crédito, para tratar do cliente em questão."),"MKFAT001")
					lRet := .F.
				ElseIf SA1->A1_POSCLI == "M"
					_cMens := "MONITORADO"
					MSGINFO(OemToAnsi("O Status do cliente é : "+_cMens),"MKFAT001")
				Else
					_cMens := "LIBERADO"
				EndIf

				if IsInCallStack("U_MT410INC")  .AND. lRet
					U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Situação do Cliente',"O Status do cliente é : "+_cMens)
				EndIf
			
		ELSE
			Alert("Cliente não localizado")
			lRet := .F.
		EndIf

	Endif

	RestArea(_aArea)

Return(lRet)
