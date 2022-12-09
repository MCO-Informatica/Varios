#Include 'Protheus.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 22/10/2014 - 16:03:29
* @description: Rotina utilizada na validação de usuário do campo H6_MOTIVO, para verificar se o registro está
* ou não ativo na tabela ZRM. 
*/ 
User Function SHPCP004()
	
	local lRet		:= .T.
	local cHabili	:= POSICIONE("ZRM",1,xFilial("ZRM")+M->H6_MOTIVO,"ZRM_HABILI") 
	
	if cHabili == "N"
		alert("Utilize outro motivo. Este motivo foi desabilitado na rotina 'Motivo Horas Improdutivas'")
		lRet := .F.
	endIf
	 
Return lRet

