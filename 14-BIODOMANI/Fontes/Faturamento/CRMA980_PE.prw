#Include 'Protheus.ch'

//---------------------------------------------------------------------------------
// Rotina | CRMA980        | Autor | Lucas Baia          | Data |    13/05/2022	
//---------------------------------------------------------------------------------
// Descr. | Ponto de Entrada em MVC do Cadastro de Clientes (MATA030)
//---------------------------------------------------------------------------------
// Uso    | BIODOMANI
//---------------------------------------------------------------------------------


User Function CRMA980()

	Local aParam    := PARAMIXB //Par�metro obrigat�rio no PEs em MVC, pois eles trazem informa��es importantes sobre o estado e ponto de execu��o da rotina.
	Local xRet      := .T. //Esta variavel pode retornar no final, tanto l�gico quanto um array.

/* RETORNO DO ARRAY aParam
1   O   Objeto do formul�rio ou do modelo, conforme o caso
2   C   ID do Local de execu��o do ponto de entrada
3   C   ID do Formul�rio
*/

	Local oObject   := aParam[1] //Objeto do formul�rio ou do modelo, conforme o caso
	Local cIdPonto  := aParam[2] //ID do Local de execu��o do ponto de entrada
	//Local cIdModel  := aParam[3] //ID do Formul�rio

	Local nOperation     := oObject:GetOperation()

	Local lmercos := .f.
	Local nI := 0
/*
1- Pesquisar
2- Visualizar
3- Incluir
4- Alterar
5- Excluir
6- Outras Fun��es
7- Copiar
*/

	IF aParam[2] <> Nil //Se ele estiver diferente de nulo, quer dizer que alguma a��o est� sendo feita no modelo

		IF cIdPonto == "MODELPOS" //Na valida��o total do modelo.

			If FWFldGet("A1_TIPO") == "X"
				If !Empty(FWFldGet("A1_CGC"))
					xRet := .F.
					Help(NIL, NIL, "EXPORTACAO", NIL, "Cliente de exporta��o n�o pode ter CNPJ preenchido", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf

				If xRet .and. FWFldGet("A1_EST") != "EX"
					xRet := .F.
					Help(NIL, NIL, "EXPORTACAO", NIL, "Estado do cliente de exporta��o tem que ser EX.", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf

				If xRet .and. FWFldGet("A1_COD_MUN") != "99999"
					xRet := .F.
					Help(NIL, NIL, "EXPORTACAO", NIL, "Municipio do cliente de exporta��o tem que ser 99999", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf

				If xRet .and. Alltrim(FWFldGet("A1_PAIS")) == "105"
					xRet := .F.
					Help(NIL, NIL, "EXPORTACAO", NIL, "Pa�s nao pode ser 105-Brasil", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf

				If xRet .and. FWFldGet("A1_CODPAIS") == "01058"
					xRet := .F.
					Help(NIL, NIL, "EXPORTACAO", NIL, "Pa�s Bacen. n�o pode ser 01058-Brasil", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf

				If xRet .and. FWFldGet("A1_ESTC") == "EX"
					xRet := .F.
					Help(NIL, NIL, "DADOS_INCORRETO", NIL, "A UF de End. de Cobran�a n�o pode ser EX", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Por favor Revisar Endere�o de Cobran�a!"})
				EndIf

				If xRet .and. FWFldGet("A1_ESTE") == "EX"
					xRet := .F.
					Help(NIL, NIL, "DADOS_INCORRETO", NIL, "A UF de End. de Entrega n�o pode ser EX", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Por favor Revisar Endere�o de Entrega!"})
				EndIf

			Else

				If Empty(FWFldGet("A1_CGC"))
					xRet := .F.
					Help(NIL, NIL, "CAMPO CNPJ!!!", NIL, "Preencha o CNPJ.", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf

				If xRet .and. FWFldGet("A1_EST") == "EX"
					xRet := .F.
					Help(NIL, NIL, "Aten��o!!!", NIL, "Estado EX utilizado somente para cliente de Exporta��o.", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf

				If xRet .and. FWFldGet("A1_COD_MUN") == "99999"
					xRet := .F.
					Help(NIL, NIL, "Aten��o!!!", NIL, "Municipio 99999 utilizado somente para cliente de Exporta��o.", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
				EndIf
			EndIf

		ENDIF


		IF cIdPonto == "MODELCOMMITTTS" //Ap�s a grava��o total do modelo e dentro da transa��o.

			IF nOperation == 4 //Altera��o

				SA1->A1_YDTALT := dDataBase

			ENDIF

			IF FWFldGet("A1_EST") <> "EX"
				SA1->A1_ENDCOB		:= FWFldGet("A1_END")
				SA1->A1_BAIRROC		:= FWFldGet("A1_BAIRRO")
				SA1->A1_CEPC		:= FWFldGet("A1_CEP")
				SA1->A1_MUNC		:= FWFldGet("A1_MUN")
				SA1->A1_ESTC		:= FWFldGet("A1_EST")

				SA1->A1_ENDENT		:= FWFldGet("A1_END")
				SA1->A1_BAIRROE		:= FWFldGet("A1_BAIRRO")
				SA1->A1_CEPE		:= FWFldGet("A1_CEP")
				SA1->A1_MUNE		:= FWFldGet("A1_MUN")
				SA1->A1_ESTE		:= FWFldGet("A1_EST")
			ENDIF

		ENDIF

		If cIdPonto == "FORMCOMMITTTSPOS"
			for nI := 1 to len(procname())
				if procname(nI) == 'U_MERCOS03'
					lmercos := .t.
				endif
			next
			if !lmercos
				if nOperation == 3 //Inclus�o
					u_pem030inc(.t.)
				else
					if nOperation == 4 //Altera��o
						u_pemaltcli(.t.)
					elseif nOperation == 5 //Exclus�o
						u_pem030exc()
					endif
				endif
			endif
		endif
	ENDIF

Return xRet
