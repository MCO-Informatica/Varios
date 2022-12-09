#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: MA030TOK | Autor: Celso Ferrone Martins   | Data: 19/02/2015 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Ponto de entrada paera validar compos de preenchimento     |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function MA030TOK()

Local lRet := .T.

If M->A1_TIPO == "X"
	If !Empty(M->A1_CGC)
		lRet := .F.
		MsgAlert("Cliente de exportacao nao pode ter CNPJ preenchido","Cliente Exportacao!!!")
	EndIf
	If lRet .and. M->A1_EST != "EX"
		lRet := .F.
		MsgAlert("Estado do cliente de exportacao tem que ser EX.","Cliente Exportacao!!!")
	EndIf
	If lRet .and. M->A1_COD_MUN != "99999"
		lRet := .F.
		MsgAlert("Municipio do cliente de exportacao tem que ser 99999","Cliente Exportacao!!!")
	EndIf
	If lRet .and. Alltrim(M->A1_PAIS) == "105"
		lRet := .F.
		MsgAlert("Pais nao poder ser 105-Brasil","Cliente Exportacao!!!")
	EndIf
	If lRet .and. M->A1_CODPAIS == "01058"
		lRet := .F.
		MsgAlert("Pais Bacen. nao poder ser 01058-Brasil","Cliente Exportacao!!!")
	EndIf
Else
	If Empty(M->A1_CGC)
		lRet := .F.
		MsgAlert("Preencha o CNPJ.","Campo CNPJ!!!")
	EndIf
	If lRet .and. M->A1_EST == "EX"
		lRet := .F.
		MsgAlert("Estado EX utiliuzado somente para cliente de Exportacao.","Atencao!!!")
	EndIf
	If lRet .and. M->A1_COD_MUN == "99999"
		lRet := .F.
		MsgAlert("Municipio 99999 utiliuzado somente para cliente de Exportacao.","Atencao!!!")
	EndIf
EndIf

Return(lRet)