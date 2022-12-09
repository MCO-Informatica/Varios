#include "Protheus.ch"
/* Permitir vetar o acesso a tabela de preços após o campo se preenchido */
User Function gtf004()

    Local lRet := .f.

	if oGetDad:nCount == 1 .and. tmp1->ck_valor == 0 .and. empty(m->cj_tabela)
        lRet := .t.
    endif

Return lRet
