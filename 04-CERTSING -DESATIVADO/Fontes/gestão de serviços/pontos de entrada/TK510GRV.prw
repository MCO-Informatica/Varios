#INCLUDE"PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

User Function TK510GRV( ntipo )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³TK510GRV    ³ Autor ³ Claudio H. Corrêa   ³ Data ³ 14/08/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao para validar ordem de serviço aberta no atendimento. |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                        	        						  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Local lRet

Private cLocal

if INCLUI

	cGeraOs := M->ADE_GERAOS
	
	If !Empty(cGeraOs)
	
		If cGeraOs == "1"
	
			lRet := .F.
				
			cLocal := MsDocPath()
				
			lRet := U_CSAGAUTO()
			
		End If
			
	End If

ElseIf ALTERA
	
	IF FUNNAME() <> "CSAG0001"
	
		cOs := M->ADE_OS
		
		If Empty(cOs)
	
			cGeraOs := M->ADE_GERAOS
		
			If !Empty(cGeraOs)
		
				If cGeraOs == "1"
		
					lRet := .F.
					
					cLocal := MsDocPath()
					
					lRet := U_CSAGAUTO()
				
				End If
				
			End If
			
		End If
		
	End If


End If

/*
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
	if FindFunction("u_csTK510GRV")
		lRet := u_csTK510GRV() 
	else
		lRet := .F.
	endif

endif
*/
	
Return (lRet)