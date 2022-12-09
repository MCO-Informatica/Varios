#INCLUDE"PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

User Function TK510GRV( ntipo )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �TK510GRV    � Autor � Claudio H. Corr�a   � Data � 14/08/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao para validar ordem de servi�o aberta no atendimento. |��
�������������������������������������������������������������������������Ĵ��
��� Uso      �                        	        						  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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