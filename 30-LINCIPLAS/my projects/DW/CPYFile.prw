User Function CPYFile()

//IF file("\\192.168.20.118\G\MP8\PROTHEUS_DATA\data\sc5010.dbf") == .T.
//	ALERT("OK 1")
//ELSEIF file("\\nikolas-pc\G\MP8\PROTHEUS_DATA\data\sc5010.dbf")
//	ALERT("OK 2")
//ELSEIF FILE("F:\MP8\PROTHEUS_DATA\data\SC5010.DBF")
//	ALERT("OK 3")

cMens1 := "A(s) seguinte(s) tabela(s) foram copiada(s) com sucesso: <BR>"
cMens2 := "O(s) seguinte(s) indices(s) foram copiados(s) com sucesso: <BR>"

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SC5010.DBF","\DW", .T.)
	cMens1 += "SC5 - Cabe�alho Pedido de Venda <BR>"
ENDIF

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SC6010.DBF","\DW", .T.)
	CpyT2S("E:\MP8\PROTHEUS_DATA\data\SC6010.FPT","\DW", .T.)
	cMens1 += "SC6 - Itens Pedido de Venda <BR>"
ENDIF

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SF2010.DBF","\DW", .T.)
	cMens1 += "SF2 - Cabe�alho Nota Fiscal <BR>"
ENDIF

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SD2010.DBF","\DW", .T.)
	cMens1 += "SD2 - Itens Nota Fiscal <BR>"
ENDIF

/*
IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SC6010.FPT","\DW", .T.)
cMens += "SC6 - Itens Pedido de Venda"
ENDIF
*/

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SC5010.CDX","\DW", .T.)
	cMens2 += "SC5 - Cabe�alho Pedido de Venda <BR>"
ENDIF

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SC6010.CDX","\DW", .T.)
	cMens2 += "SC6 - Itens Pedido de Venda <BR>"
ENDIF

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SF2010.CDX","\DW", .T.)
	cMens2 += "SF2 - Cabe�alho Nota Fiscal <BR>"
ENDIF

IF CpyT2S("E:\MP8\PROTHEUS_DATA\data\SD2010.CDX","\DW", .T.)
	cMens2 += "SD2 - Itens Nota Fiscal <BR>"
ENDIF

//Alert(cMens1 +"<BR>"+ cMens2)
MSGINFO(cMens1 +"<BR>"+ cMens2)

//Alert(cMens2)

Return

/*
#include "protheus.ch"
User Function TestErase()

Local cFile := '\DATA\XXX.DBF'

If MsErase(cFile)
ApMsgAlert("O arquivo foi apagado.")
Else
ApMsgAlert("O arquivo n�o pode ser apagado.")
EndIF

// teste
//  FUNCAO PARA DELETAR OS ARQUIVOS DENTRO DO PROTHEUS
//FERASE("\DW\SC5010.DBF")


Return
*/
