
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa   MA110BLO  ?Autor  ?Pedro Augusto       ? Data ?  29/10/09   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? PE para desabilitar o botao de aprovacao de SC             ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Workflow RENOVA                                            ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function MT110BLO()                                         
Local lRet := .T.
Local caUser := RetCodUsr()

If C1_XAPROV <> __cUserID
	Aviso("Atencao","Usu?rio n?o ? o Gestor desta solicita??o de compra",{"Voltar"})
	lRet := .F.
ENDIF
RETURN lRet
