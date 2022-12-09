#include "protheus.ch"
#include "parmtype.ch"   
#include "TopConn.ch" 

/*=============================================================
Programa...: MATA010
Descricao..: Modelo de dados para ponto de entrada do cadastro
			 de produtos em MVC 
Autor......: Anderson Goncalves
Data.......: 23/03/2021
=============================================================*/			
 
User Function MATA010()

/*=============================================================
  Variaveis da Rotina
=============================================================*/			
Local lRet 			:= .T.

If INCLUI .OR. ALTERA
    If SB1->(FieldPos("B1_XDTCAD")) > 0
        If SB1->B1_TIPO == "MC"
            If INCLUI
                RecLock("SB1",.F.)
                SB1->B1_MSBLQL := "2"
                SB1->(msUnlock())
            EndIf
        ElseIf SB1->B1_XDTCAD == ctod("  /  /  ")
            U_RWOKF01()
        Endif
    EndIf
EndIf

Return(lRet)
 
