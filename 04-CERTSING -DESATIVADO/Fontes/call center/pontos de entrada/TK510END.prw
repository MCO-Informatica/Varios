#include "protheus.ch"
                                                      
/*
-------------------------------------------------------------------------------
| Rotina     | TK510END     | Autor | Gustavo Prudente   | Data | 27.04.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Ponto de entrada para gravar informacoes complementares apos   |
|			 | finalizar a gravacao do atendimento.                           |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
User Function TK510END()

	local cGeraOs 			:= iif( ADE->(FieldPos("ADE_GERAOS")) > 0, ADE->(ADE_GERAOS), "" )
	local cExec 			:= "Service-Desk x Checkout"
	local cProcExp			:= "PE TK510END"
	local lRet				:= .F.
	local cMVChkGrupo		:= alltrim(getMv('MV_CHKGRUP'))
	local cMVChkVendaOcorr	:= alltrim(getMv('MV_CHKOCVD'))
	Local cIncidente		:= ''
	if empty( cGeraOs )
			
		//--------------------------------------------------
		// PROJETO	: Integracao Service-Desk x Checkout
		// @author	: Douglas Parreja
		// @since	: 24/05/2016
		// @Fonte	: csADE03xFun.prw
		//
		// Realizado ajuste para que ao usuario clicar
		// em finalizar o chamado, sera exibido o Link   
		// do checkout a ser clicado.
		// Este Link sera gravado na tabela ADF gerando
		// uma nova interacao.
		//--------------------------------------------------
		if FindFunction("u_csTK510END")
		 		
			//----------------------	
			// Valida Upd/Ambiente
			//----------------------
			if u_csCheckUpd()			
		
				if len( aCols ) > 0
					//--------------------------------------------------
					// Verifico se consta no Grupo
					//--------------------------------------------------
					if AScan(aCols, {|x| x[8] $ cMVChkGrupo}) > 0 
						//--------------------------------------------------
						// Verifico se na ADF tem gerado Ocorrencia Checkout
						//--------------------------------------------------
						if AScan(aCols, {|x| x[2] $ cMVChkVendaOcorr}) > 0
							lRet := u_csTK510END()
						endif
					endif
				endif
			else
				lRet := .F.
			endif		
		else
			lRet := .F.
		endif	
		if !lRet
			u_autoMsg(cExec,cProcExp,"Nao foi possivel concluir a gravacao do Registro. Ponto Entrada TK510END." )
		endif
	
	else
	
		// Alteração para gravar o campo de OS no teleatendimento - Claudio Henrique Corrêa 24/06/2015
		cOs := PA0->PA0_OS
		
		BEGIN TRANSACTION
		RecLock( "ADE", .F. )
		ADE->ADE_OS := cOs
		ADE->( MsUnlock() )
		END TRANSACTION
		
		// Evita que o atendimento fique como pendente e atribuido a um operador que o alterou
		If ALTERA .And. ADE->ADE_XSTOPE == "1"
			
			BEGIN TRANSACTION
			RecLock( "ADE", .F. )
			ADE->ADE_XSTOPE := "2"
			ADE->( MsUnlock() )
			END TRANSACTION
			
		EndIf
	
	endif
	
	If ALTERA .And. Empty( MSMM(ADE->ADE_CODINC) )
		cIncidente := U_CSCODINC()
		MSMM(,TamSx3("ADE_INCIDE")[1],,cIncidente,1,,,"ADE","ADE_CODINC")
	EndIF

Return .T.