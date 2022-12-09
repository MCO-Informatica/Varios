#Include 'totvs.ch'
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

/**
*
* @author: Marcos Floridi Leme
* @since: 17/08/2021 
* @description: Função para validar o retorno do Dados da Consulta da Querie - Tela de Apontamento do PCP Mod. 2
*/ 
User Function SHPCP008()
	local lRet 	 := .T.
	Local cTexto := M->H6_OPERADO

//	RPCSetType( 3 )						// Não consome licensa de uso
//	Prepare Environment Empresa '01' Filial '01'

	aOper  := StrTokArr(cTexto,'/')
	_cErro := ""
	for _x := 1 to Len(aOper)
		DbSelectArea("CB1")
		DbSetOrder(3)
		If DbSeek(xFilial("CB1")+Padr(Alltrim(aOper[_x]),TamSX3("CB1_NOME")[1]))
			If CB1->CB1_STATUS == "2"
				_cErro += ("Operador "+aOper[_x]+" inativo!!!") + Chr(13)+Chr(10)
			EndIf
		Else
			_cErro += ("Operador "+aOper[_x]+" nao localizado!!!") + Chr(13)+Chr(10)
		EndIf
        _nCount := 0
		For _y := 1 to Len(aOper)
            If Alltrim(aOper[_y]) == Alltrim(aOper[_x])
    			_nCount ++
            EndIf
		Next
        If _nCount > 1
			_cErro += ("Operador "+aOper[_x]+" informado mais que uma vez!!!") + Chr(13)+Chr(10)
        EndIf
	Next

	If !Empty(_cErro)
		Alert(_cErro+"Utilize / para separar os nomes.")
		ConOut(_cErro+"Utilize / para separar os nomes.")
        RETURN .f.
	EndIf

return lRet
