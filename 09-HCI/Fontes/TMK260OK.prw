#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"
#include "TBICONN.CH" 

User Function TMK260OK()

	If SUS->(FieldPos("US_XSEG1")) != 0
		If ALLTRIM(M->US_XSEG1) == "OT"
			If EMPTY(M->US_XSEG2)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio [Descri��o do Segmento] se encontra em branco. Favor verificar!"),{"Ok"},2)
				Return(.F.)
			EndIf
		EndIf
	EndIf
	
	If SUS->(FieldPos("US_XOBRA")) != 0
		If ALLTRIM(M->US_XOBRA) == "S"
			If EMPTY(M->US_XOBRAD)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio [Descri��o da Obra Financiada] se encontra em branco. Favor verificar!"),{"Ok"},2)
				Return(.F.)
			EndIf
		EndIf
	EndIf
	
	If SUS->(FieldPos("US_XISENF")) != 0
		If ALLTRIM(M->US_XISENF) == "S"
			If EMPTY(M->US_XISENFD)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Campo obrigat�rio [Descri��o da Isen��o Fiscal] se encontra em branco. Favor verificar!"),{"Ok"},2)
				Return(.F.)
			EndIf
		EndIf
	EndIf

Return(.T.)