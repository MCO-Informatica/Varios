#Include "rwmake.ch"

User Function A010TOK()  

	Local lRetA010TOk := .T.
	Local _cMVEmpAnt	:= AllTrim(GetMV("ES_ATVCPEF",,"0250"))
	
	If M->B1_XSTATUS <>"EN"
		If M->B1_EMIN > 0
			MSGAlert("Divergência! Este Produto não pode ter Ponto de Pedido, já que ele não está cadastrado como Estoque Normal. Favor corrigir.")
			lRetA010TOk := .F.
		Endif
		
		If M->B1_ESTSEG > 0
			MSGAlert("Divergência! Este Produto não pode ter Estoque de Seguranca, já que ele não está cadastrado como Estoque Normal. Favor corrigir.")
			lRetA010TOk := .F.
		Endif
	Else
		If M->B1_XSTATUS =="EN" .And. !(cEmpAnt+cFilAnt $ _cMVEmpAnt)
			if M->B1_EMIN = 0 .OR. M->B1_ESTSEG = 0
				MSGAlert("Atenção, Você cadastrou este produto como Estoque Normal, porém sem as quantidades para sua reposição.")
			Endif		
		Endif
	Endif             
	
	If lRetA010TOk
		If cEmpAnt+cFilAnt $ _cMVEmpAnt //.And. M->B1_DATREF >= CtoD("05/10/2015")
			If SB1->(FieldPos("B1_XTPMAT")) != 0
				If Empty(M->B1_XTPMAT) .And. INCLUI
					Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório para montagem do código do produto [Tp. Material] se encontra em branco. Favor verificar!"),{"Ok"},2)
					lRetA010TOk	:= .F.
					Return lRetA010TOk
				EndIf
				
				If M->B1_XTPMAT == "P" .Or. Upper(AllTrim(M->B1_TIPO)) == "MP"
					If Empty(M->B1_TIPO)
						Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório para montagem do código do produto [Tipo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_GRUPO)
						Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório para montagem do código do produto [Grupo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_XUNDNEG)
						Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório para montagem do código do produto [Visão de Negócio] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_XATMAT)
						Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório para montagem do código do produto [Atribuição do Material] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
					EndIf
				ElseIf M->B1_XTPMAT == "I"
					If Empty(M->B1_TIPO)
						Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório para montagem do código do produto [Tipo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_GRUPO)
						Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório para montagem do código do produto [Grupo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
				
				EndIf
			EndIf
		EndIf
	EndIf

Return lRetA010TOk