#include 'Protheus.ch'


/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PONTO DE ENTRADA CHAMADA MA030TOK, SE REFERE A GRAVAÇÃO DE CADASTRO DE CLIENTE, ESTE PONTO DE ENTRADA SERVE PARA INCLUSÃO E ALTERAÇÃO JUNTOS.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
User Function MA030TOK()
Local aArea := GetArea()
Local lRet := .T.

//********************************************************************************************************************
//VALIDAÇÃO PARA CLIENTES ESTRANGEIROS
If M->A1_TIPO == "X"
	If !Empty(M->A1_CGC)
		lRet := .F.
		MsgAlert("Cliente de exportação não pode ter CNPJ preenchido","Cliente Exportação!!!")
	EndIf

	If lRet .and. M->A1_EST != "EX"
		lRet := .F.
		MsgAlert("Estado do cliente de exportação tem que ser EX.","Cliente Exportação!!!")
	EndIf

	If lRet .and. M->A1_COD_MUN != "99999"
		lRet := .F.
		MsgAlert("Municipio do cliente de exportação tem que ser 99999","Cliente Exportação!!!")
	EndIf

	If lRet .and. Alltrim(M->A1_PAIS) == "105"
		lRet := .F.
		MsgAlert("País nao pode ser 105-Brasil","Cliente Exportação!!!")
	EndIf

	If lRet .and. M->A1_CODPAIS == "01058"
		lRet := .F.
		MsgAlert("País Bacen. não pode ser 01058-Brasil","Cliente Exportação!!!")
	EndIf

Else

	If Empty(M->A1_CGC)
		lRet := .F.
		MsgAlert("Preencha o CNPJ.","Campo CNPJ!!!")
	EndIf

	If lRet .and. M->A1_EST == "EX"
		lRet := .F.
		MsgAlert("Estado EX utilizado somente para cliente de Exportação.","Atenção!!!")
	EndIf
    
	If lRet .and. M->A1_COD_MUN == "99999"
		lRet := .F.
		MsgAlert("Municipio 99999 utilizado somente para cliente de Exportação.","Atenção!!!")
	EndIf
EndIf

    If !Empty(trim(M->A1_TABELA))

        DbSelectArea("DA0")
        DA0->(DbSetOrder(1))

        If DA0->(DbSeek(xFilial("DA0")+M->A1_TABELA)) .and. Trim(DA0->DA0_CONDPG) != Trim(M->A1_COND)
            DA0->(RecLock("DA0",.F.))
            DA0->DA0_CONDPG := M->A1_COND
            DA0->(MsUnlock())
        EndIf

    EndIf

    If Trim(M->A1_VEND) != Trim(SA1->A1_VEND)
        M->A1_XDTOLDV := Date()
        M->A1_XOLDVND := SA1->A1_VEND
    EndIf
    
    RestArea(aArea)

return lRet 
