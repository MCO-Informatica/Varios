#Include "rwmake.ch"

/*/{Protheus.doc} M460QRY

Ponto de Entrada executado no momento da abertura da tela para seleção de pedidos para faturamento. Desta forma foi realizada a chamada de consulta padrão personalizada (CCP003) para que seja realizado
o filtro das informações de acordo as parametrizaões das pergunta.

@author Microsiga
@since 05/03/2007
@version P11

/*/

User Function M460QRY(cQrySC9) 

Local cQry1Sc9 	:= ParamIxb[1] 
Local nTipFt 	:= ParamIxb[2]
Local cQry2Sc9 	:= cQrySC9:= '' 

If FunName() <> "MATA460B"
	/* 
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Abre novo grupo de Perguntas para tratar Grupo de Produtos    ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	pergunte("CCP003", .T.)
	
	cQry2Sc9 := " AND  SC9.C9_GRUPO >= '"+Mv_Par01+"' "
	cQry2Sc9 += " AND  SC9.C9_GRUPO <= '"+Mv_Par02+"' "
	cQry2Sc9 += " AND  SC9.C9_TPCARGA <> '1' "

	pergunte("MT461A", .F.)
EndIf
cQrySC9  := cQry1SC9 + cQry2SC9

Return(cQrySC9) 