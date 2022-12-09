#INCLUDE 'RWMAKE.CH'
User Function MTGRVSD5()
Local cAlias    := PARAMIXB[1]
Local cProduto  := PARAMIXB[2]
Local cLocal    := PARAMIXB[3]
Local cLoteCtl  := PARAMIXB[4]
Local cNumLote  := PARAMIXB[5]
Local cOp       := PARAMIXB[6]
Local dDtValid  := PARAMIXB[7]
Local lProducao := PARAMIXB[8]
// Parametros do array PARAMIXB
// PARAMIXB[1] - Alias que esta gerando o movimento na tabela SD5
// PARAMIXB[2] - Codigo do produto
// PARAMIXB[3] - Armazem
// PARAMIXB[4] - Lote
// PARAMIXB[5] - SubLote
// PARAMIXB[6] - Numero da ordem de producao
// PARAMIXB[7] - Data de validade
// PARAMIXB[8] - Movimento originado de apontamento de producao

If !lProducao  // Movimento de Producao 
	If cAlias == 'SD2'   //Movimento Internos  
						// ATENCAO - ESTE PONTO DE ENTRADA ESTA DENTRO DE UMA TRANSACAO  
						// Customizacoes do Cliente  
						// As tabelas SB8 e a tabela de movimento passada pela variavel cAlias estao posicionads. 
		If !SD5->(dbSetOrder(2), dbSeek(xFilial("SD5")+cProduto+cLocal+cLoteCtl))
			MsgStop("Atenção Não Foram Geradas Informações na Tabela SD5 Movimento por Lote ! " + Chr(13) + Chr(10) + "Produto: " + cProduto + " Armz: " + cLocal + " Lote: " + cLoteCtl + " Printe e Guarde Esta Tela !")
		Endif
	EndIf
Else // Outras customizacoes
EndIf 
Return Nil