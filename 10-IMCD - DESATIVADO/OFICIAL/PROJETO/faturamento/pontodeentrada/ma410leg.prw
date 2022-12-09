#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MA410LEG  ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³16/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ adicionar cor a legenda                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA410LEG()
Local aCores := {}	

IF TYPE( "PARAMIXB" ) == "A"
	aCores := PARAMIXB
ENDIF
	nPos := ascan(aCores, {|x| x[1] = "BR_AZUL"})
	aCores[nPos,2] :=  "Pedido de Venda com Bloqueio de Crédito"
	nPosLar := ascan(aCores, {|x| x[1] = "BR_LARANJA"})
	aCores[nPosLar,2] :=  "Pedido de Venda Liberado no Crédito"
	Aadd( aCores,{ "BR_CINZA" ,"Cancelado" } )
	Aadd( aCores,{ "BR_PINK"  ,"Reprovado" } )
	Aadd( aCores,{ "BR_BRANCO"  ,"Bloqueio de Margem" } )
	Aadd( aCores,{ "BR_VIOLETA"  ,"Bloqueio Risco de Fraude" } )

Return( aCores )
