#Include "protheus.ch"
#include "topconn.ch"

//+-----------------------------------------------------------------------------------//
//|Funcao....: ACOMA003()
//|Autor.....: Luiz Alberto
//|Data......: 11 de novembro de 2014, 09:00
//|Descricao.: Schedule / Job para baixar e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function ACOMA003()
*-----------------------------------------------------------*
Local lEhJob := .T.

RpcSetType(3)
RpcSetEnv("01","01")
SetUserDefault("000000")

//Chama rotina que baixa e-mails (XML Pre Nota Entrada) e grava protheus
U_GXNBxa(lEhJob)

// Finaliza a abertura dos dicionários
RpcClearEnv()

Return