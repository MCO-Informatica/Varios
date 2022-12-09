#Include "Protheus.ch"

/*/{Protheus.doc} M460FIL

Ponto de Entrada executado no momento da abertura da tela para sele��o de pedidos para faturamento. Desta forma foi realizada a chamada de consulta padr�o personalizada (CCP003) para que seja realizado
o filtro das informa��es de acordo as parametriza�es das pergunta.

@author Totvs SM - David
@since 01/08/2011

/*/

User Function M460FIL() 
Local cQry2Sc9 := '' 
If FunName() <> "MATA460B"
	pergunte("CCP003", .F.)
	
	cQry2Sc9 := "      C9_GRUPO >='"+Mv_Par01+"' "
	cQry2Sc9 += ".AND. C9_GRUPO <='"+Mv_Par02+"' "
	cQry2Sc9 += ".AND. C9_TPCARGA <> '1' "
	If Mv_Par03 = 1
		cQry2Sc9 += ".AND. U_VNDA150(C9_PEDIDO,"+AllTrim(Str(MV_PAR04))+") "
	EndIf
	
	pergunte("MT461A", .F.)
EndIf
Return(cQry2SC9) 