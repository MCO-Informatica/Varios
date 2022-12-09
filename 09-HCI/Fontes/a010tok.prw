#Include "rwmake.ch"

User Function A010TOK()  

	Local lRetA010TOk := .T.
	Local _cMVEmpAnt	:= AllTrim(GetMV("ES_ATVCPEF",,"0250"))
	
	If M->B1_XSTATUS <>"EN"
		If M->B1_EMIN > 0
			MSGAlert("Diverg�ncia! Este Produto n�o pode ter Ponto de Pedido, j� que ele n�o est� cadastrado como Estoque Normal. Favor corrigir.")
			lRetA010TOk := .F.
		Endif
		
		If M->B1_ESTSEG > 0
			MSGAlert("Diverg�ncia! Este Produto n�o pode ter Estoque de Seguranca, j� que ele n�o est� cadastrado como Estoque Normal. Favor corrigir.")
			lRetA010TOk := .F.
		Endif
	Else
		If M->B1_XSTATUS =="EN" .And. !(cEmpAnt+cFilAnt $ _cMVEmpAnt)
			if M->B1_EMIN = 0 .OR. M->B1_ESTSEG = 0
				MSGAlert("Aten��o, Voc� cadastrou este produto como Estoque Normal, por�m sem as quantidades para sua reposi��o.")
			Endif		
		Endif
	Endif             
	
	If lRetA010TOk
		If cEmpAnt+cFilAnt $ _cMVEmpAnt //.And. M->B1_DATREF >= CtoD("05/10/2015")
			If SB1->(FieldPos("B1_XTPMAT")) != 0
				If Empty(M->B1_XTPMAT) .And. INCLUI
					Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio para montagem do c�digo do produto [Tp. Material] se encontra em branco. Favor verificar!"),{"Ok"},2)
					lRetA010TOk	:= .F.
					Return lRetA010TOk
				EndIf
				
				If M->B1_XTPMAT == "P" .Or. Upper(AllTrim(M->B1_TIPO)) == "MP"
					If Empty(M->B1_TIPO)
						Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio para montagem do c�digo do produto [Tipo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_GRUPO)
						Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio para montagem do c�digo do produto [Grupo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_XUNDNEG)
						Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio para montagem do c�digo do produto [Vis�o de Neg�cio] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_XATMAT)
						Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio para montagem do c�digo do produto [Atribui��o do Material] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
					EndIf
				ElseIf M->B1_XTPMAT == "I"
					If Empty(M->B1_TIPO)
						Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio para montagem do c�digo do produto [Tipo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
					If Empty(M->B1_GRUPO)
						Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio para montagem do c�digo do produto [Grupo] se encontra em branco. Favor verificar!"),{"Ok"},2)
						lRetA010TOk	:= .F.
						Return lRetA010TOk
					EndIf
				
				EndIf
			EndIf
		EndIf
	EndIf

Return lRetA010TOk