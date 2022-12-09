#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   º Autor ³  Daniel   Gondran  º Data ³ 27/10/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para validar alguns campos na inclusao    º±±
±±º          ³ de produtos                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A010TOK()
	Local lRet := .T.
	PRIVATE cMsg := ", para produtos tipo MR ou MA"

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "A010TOK" , __cUserID )
	IF cEmpAnt == '01'

		If M->B1_MSBLQL <> '1'


			If M->B1_TIPO $ "MR/PA"
				IF !( M->B1_FAM $ '00|32') .and. M->B1_GRUPO <> '0099'
					If M->B1_LOCALIZ <> "S"
						Alert ("Controle de Endereçamento deve ser 'S=SIM' para produtos tipo MR ou PA")
						lRet := .F.
					Endif

					If M->B1_LOTEMUL == 0
						Alert ("Lote Multiplo deve ser diferente de zero para produtos tipo MR ou PA")
						lRet := .F.
					Endif

					If M->B1_PESO == 0
						Alert ("Peso Liquido deve ser diferente de zero para produtos tipo MR ou PA")
						lRet := .F.
					Endif

					If M->B1_TIPOCQ <> "Q"
						Alert ("Tipo de CQ deve ser 'Q=SigaQuality' para produtos tipo MR ou PA")
						lRet := .F.
					Endif

					If M->B1_CUSTD <= 0
						Alert ("O CUSTO STAND precisa ser preenchido para produtos tipo MR ou PA")
						lRet := .F.
					Endif
				Endif
				If EMPTY(M->B1_QE)
					Alert ("Qtd.Embalag deve ser diferente de zero ''"+cMsg)
					lRet := .F.
				Endif
				If M->B1_TIPO == "MA"
					If M->B1_EMB <> "AMO"
						Alert ("Embalagem deve ser 'AMO' para produtos tipo MA")
						lRet := .F.
					Endif
				Endif
			Endif

			If M->B1_TIPO == "SV"
				If M->B1_EMB <> "000"
					Alert ("Embalagem deve ser '000' para produtos tipo SV")
					lRet := .F.
				Endif
			Endif

			If Empty(M->B1_CONTA)
				Alert ("preencher a Conta Contabil")
				lRet := .F.
			Endif

			If Empty(M->B1_POSIPI)
				Alert ("preencher a NCM")
				lRet := .F.
			Endif

			If Empty(M->B1_ORIGEM)
				Alert ("preencher a Origem")
				lRet := .F.
			Endif
		ELSE
			If M->B1_TIPO $ "MR/PA"
				IF( M->B1_XCOTA == '1' .AND. EMPTY(M->B1_XAIMP) )
					MsgStop("Preencher o Campo (Autor. Imp?) - ABA EIC")
					lRet := .F.
				Endif

			/*
				IF( M->B1_XCOTA == '1' .AND. M->B1_XQTDCOT <= 0)
			MsgStop("Preencher o Campo (Qtd Liberada) - ABA EIC")
			lRet := .F.
				Endif
			*/
				IF(M->B1_ANUENTE == '1' .AND. EMPTY(M->B1_XF_LI) )
					MsgStop("Preencher o Campo (Fase LI) - ABA EIC")
					lRet := .F.
				Endif

				If Empty(M->B1_POSIPI)
					Alert ("preencher a NCM")
					lRet := .F.
				Endif

				If Empty(M->B1_ORIGEM)
					Alert ("preencher a Origem")
					lRet := .F.
				Endif

				If Empty(M->B1_CONTA)
					Alert ("preencher a Conta Contabil")
					lRet := .F.
				Endif

			Endif

		Endif

	ELSEIF cEmpAnt == '02'
//////////////////////////////////////////////////////////////////////////////////////////////
// CONSIDERAR PRODUTO TIPO MR/MA - EMPRESA FARMA
/////////////////////////////////////////////////////////////////////////////////////////////
		If M->B1_TIPO $ "MR/MA"
			If M->B1_LOCALIZ <> "S"
				Alert ("Controle de Endereçamento deve ser 'S=SIM' "+cMsg)
				lRet := .F.
			Endif
			If EMPTY(M->B1_QE)
				Alert ("Qtd.Embalag deve ser diferente de zero ''"+cMsg)
				lRet := .F.
			Endif
			If M->B1_PESO == 0
				Alert ("Peso Liquido deve ser diferente de zero"+cMsg)
				lRet := .F.
			Endif
		Endif
		If M->B1_MSBLQL <> '1'
			If M->B1_GRUPO =='INDE'
				Alert ("Não é possível desbloquear Produtos com o GRUPO INDE")
				lRet := .F.
			Endif
		Endif

	ELSEIF cEmpAnt == '04'
		lRet := .T.
	Endif

Return (lRet)
