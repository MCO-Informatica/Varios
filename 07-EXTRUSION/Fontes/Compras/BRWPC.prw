
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? BRWPC      ?Autor  ? Antonio Carvalho ? Data ?  18/09/20   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Exibir nome do Fornecedor no Pedido de Compra              ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? ALLTEC                                                     ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/



USER FUNCTION BRWPC()

Local _cRetorno

_cRetorno := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"SA2->A2_NREDUZ")     


Return _cRetorno