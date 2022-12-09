#include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VLDLICFORº Autor ³  Junior Carvalho   º Data ³  03/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida se o Fornecedor está com pendencias para            º±±
±±º          ³ emissao do PC (Min.Exerc/PF/PC/                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Parametros (CFORN, CLOJA )                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VLDLICFOR( _CFORNEC, _CLOJA )

Local lRet := .T.
Local cAviso := "Validar Licenças Fornecedor - VLDLICFOR"
Local cMsgRF := CRLF+"Verifique o Cadastro de Fornecedores [Receita Federal]"
Local cMsgSN := CRLF+"Verifique o Cadastro de Fornecedores [Simples Nacional]"
Local cMsgSI := CRLF+"Verifique o Cadastro de Fornecedores [Sintegra]"

if SA2->( dbSeek( xFilial( "SA2" ) + _CFORNEC + _CLOJA ) )
	
	IF Left(SA2->A2_EST,2) == "EX"
		lRet	:= .T.
	ELSE
		// Validacao na Receita Federal
		If Empty(SA2->A2_STATRF)
			Aviso(cAviso,"Consulta a este Fornecedor nao foi realizada na Receita Federal"+cMsgRF,{"OK"},1)
			lRet := .f.
		ElseIf Alltrim(SA2->A2_STATRF) == "I"  // Receita Federal
			Aviso(cAviso,"Fornecedor esta Inativo na Receita Federal."+cMsgRF,{"OK"},1)
			lRet := .F.
		Endif
		
		If Empty( SA2->A2_VALIDRF )
			Aviso(cAviso,"Data de Validade nao preenchida para este Fornecedor."+cMsgRF,{"OK"},1)
			lRet := .F.
		ElseIf SA2->A2_VALIDRF < DDATABASE
			Aviso(cAviso,"Data de Validade Expirada em "+DTOC(SA2->A2_VALIDRF)+" para este Fornecedor"+cMsgRF,{"OK"},1)
			lRet := .F.
		Endif
		
		// Validacao no Simples Nacional
		If Empty(SA2->A2_STATJ)
			Aviso(cAviso,"Consulta a este Fornecedor nao foi realizada no Simples Nacional."+cMsgSN,{"OK"},1)
		ElseIf Alltrim(SA2->A2_STATJ) == "I"  // Simples Nacional
			Aviso(cAviso,"Fornecedor esta Inativo no Simples Nacional."+cMsgSN,{"OK"},1)
			lRet := .F.
		Endif
		
		If Empty( SA2->A2_VALIDJ )
			Aviso(cAviso,"Data de Validade nao preenchida para este Fornecedor."+cMsgSN,{"OK"},1)
			lRet := .F.
		ElseIf SA2->A2_VALIDJ < DDATABASE
			Aviso(cAviso,"Data de Validade Expirada em "+DTOC(SA2->A2_VALIDJ)+" para este Fornecedor"+cMsgSN,{"OK"},1)
			lRet := .F.
		Endif
		
		// Validacao no Sintegra
		If !U_IsIsentoIE(SA2->A2_INSCR)
			If Empty(SA2->A2_STATSI)
				Aviso(cAviso,"Consulta a este Fornecedor nao foi realizada no Sintegra"+cMsgSI,{"OK"},1)
				lRet := .F.
			ElseIf Alltrim(SA2->A2_STATSI) == "I"  // Sintegra
				Aviso(cAviso,"Fornecedor esta Inativo no Sintegra"+cMsgSI,{"OK"},1)
				lRet := .F.
			Endif
			
			If Empty( SA2->A2_VALIDSI )
				Aviso(cAviso,"Data de Validade nao preenchida para este Fornecedor"+cMsgSI,{"OK"},1)
				lRet := .F.
			ElseIf SA2->A2_VALIDSI < DDATABASE
				Aviso(cAviso,"Data de Validade Expirada em "+DTOC(SA2->A2_VALIDSI)+" para este Fornecedor"+cMsgSI,{"OK"},1)
				lRet := .F.
			Endif
		Endif
	Endif
ENDIF

Return(lRet)
