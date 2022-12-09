#Include "Protheus.ch"
#Include "RWMAKE.ch"

/*
+==================+======================+==============+
|Programa: MT140CPO|Autor: Antonio Carlos |Data: 13/03/08|
+==================+======================+==============+
|Descricao: Ponto de Entrada utilizado para adicionar    |
|campos na GetDados da rotina de Pre-Nota.               |
+========================================================+
|Uso: Laselva                                            |
+========================================================+
*/

User Function MT140CPO()
Public __dDtRecebe := iif(inclui,ctod(''),SF1->F1_RECBMTO)
If !l140Auto
	If  empty(__dDtRecebe) .and. (inclui .or. altera)
		U_DlgDtRec()
	EndIf
EndIf

Return{"D1_IDENTB6"}

