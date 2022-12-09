#INCLUDE "PROTHEUS.CH"                                      
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103LDV    Autor ³ Triyo               º Data ³  05/10/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para alterar o valor unitarioº±±
±±º          ³ na devolução de venda           .                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA ENERGIA                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103LDV()
Local aLinhas 	:= ParamIXB[1]
Local cAliasSD2 := ParamIXB[2]
Local nX		:= 0

	If (nX := aScan(aLinhas,{|x| AllTrim(UPPER(x[1])) == "D1_VUNIT" }) ) > 0
		 aLinhas[nX,2] := (cAliasSD2)->D2_PRCVEN  //  { "D1_VUNIT"  , (cAliasSD2)->D2_PRCVEN, Nil })
	Endif

	If (nX := aScan(aLinhas,{|x| AllTrim(UPPER(x[1])) == "D1_TOTAL" }) ) > 0	
		aLinhas[nX,2] := (cAliasSD2)->D2_TOTAL //{ "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"), Nil })
	Endif

	If (nX := aScan(aLinhas,{|x| AllTrim(UPPER(x[1])) == "D1_VALDESC" }) ) > 0	
		aLinhas[nX,2] := (cAliasSD2)->D2_DESCON //  { "D1_VALDESC", (cAliasSD2)->D2_DESCON , Nil } )						
    Endif

Return aLinhas