////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	M410PCDV
// Autor 		Alexandre Dalpiaz
// Data 		26/11/2012
// Descricao  	PONTO DE ENTRADA na rotina de retorno em Pedidos de Venda - altera o vetor aCols, mais especificamente referente os campos
//              C6_VALDESC, C6_VALOR e C6_PRCVEN, para ficarem de acordo com a nota de entrada
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function M410PCDV()
////////////////////////

Local _cAlias := paramixb[1]
Local _nPosic := len(aCols)
local  cTipo := POSICIONE("SF1", 1, xFilial("SF1") +QRYSD1->D1_DOC, "F1_TIPO")
If _cAlias == 'QRYSD1'
	GdFieldPut('C6_VALDESC',QRYSD1->D1_VALDESC,_nPosic)
	GdFieldPut('C6_VALOR',GdFieldGet('C6_VALOR',_nPosic) - QRYSD1->D1_VALDESC,_nPosic)
	GdFieldPut('C6_PRCVEN',GdFieldGet('C6_VALOR',_nPosic) / GdFieldGet('C6_QTDVEN',_nPosic),_nPosic)
	
	IF 	cTipo $ 'N/C/I/P'
		CEST:=SA1->A1_EST
	ELSE
		CEST:=SA2->A2_EST
	ENDIF
	
	IF CEST=="EX"
		GdFieldPut('C6_CF' , '7' + SUBSTR(SF4->F4_CF,2,3), _nPosic)
	ELSE
		If SM0->M0_ESTENT == CEST
			GdFieldPut('C6_CF' , '5' +SUBSTR(SF4->F4_CF,2,3), _nPosic)
		Else
			GdFieldPut('C6_CF' , '6' + SUBSTR(SF4->F4_CF,2,3), _nPosic)
		EndIf
	ENDIF
EndIf
Return()
