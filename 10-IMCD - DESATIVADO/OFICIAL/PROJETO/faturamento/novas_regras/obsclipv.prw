#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � OBSCLIPV � Autor � Junior Carvalho    � Data �  15/06/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � Mostrar na tela a observacao do cadastro do cliente, como  ���
���          � um alerta.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI - Orcamento / Pedido de Venda            ���
���          � Usado no VALID dos campos C5_CLIENTE / CJ_CLIENTE.         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function OBSCLIPV(cAlias)
	Local _aArea := GetArea()
	Local cTexto := ""
	local lMsg := .T.

	if  !IsInCallStack("U_IMPQUOTE")
		IF !IsInCallStack("U_SF2460I")
			IF !IsInCallStack("U_M460FIM")

				IF cAlias == "SCJ"
					cChave := M->CJ_CLIENTE + iif(EMPTY(M->CJ_LOJA),'01',M->CJ_LOJA )
				ELSE
					cChave := M->C5_CLIENTE + iif(EMPTY(M->C5_LOJACLI),'01',M->C5_LOJACLI )

					If M->C5_TIPO $ "B|D"

						lMsg := .F.

					Endif
				ENDIF

				if lMsg
					DbSelectArea("SA1")
					DbSetOrder(1)
					if DbSeek(xFilial("SA1")+ cChave )
						cTexto := ALLTRIM(SA1->A1_OBSVEN)
						If !Empty( cTexto )

							Aviso("OBS. CLIENTE",cTexto,{"Ok"},3)

						EndIf

					Endif
				Endif
			Endif
		Endif
	Endif
	RestArea(_aArea)

Return .T.
