/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GRVLOGPD º Autor ³ Giane - ADV Brasil º Data ³  25/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para gravar o log do pedido na tabela SZ4           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / televendas/orcamento                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GrvLogPd(cNum, cCli, cLoja, cEvento, cMotivo, cItem, cAltera )
Local _aArea := GetArea()

if cItem == NIl
	cItem := ""
endif

DbSelectArea("SZ4")
Reclock("SZ4",.t.)
SZ4->Z4_FILIAL  := xFilial("SZ4")
SZ4->Z4_PEDIDO  := cNum
SZ4->Z4_ITEPED  := cItem
SZ4->Z4_CLIENTE := cCli
SZ4->Z4_LOJA    := cLoja
SZ4->Z4_DATA    := date()
SZ4->Z4_HORA    := time()
SZ4->Z4_USUARIO := __cUserId
SZ4->Z4_EVENTO  := cEvento

if cMotivo != Nil
	SZ4->Z4_MOTIVO := cMotivo
endif

if cAltera != NIl
	MSMM( , TamSx3("Z4_ALTERA")[1], , cAltera, 1, , , "SZ4", "Z4_CODALTE" )
endif

MsUnlock()

RestArea(_aArea)
Return Nil
