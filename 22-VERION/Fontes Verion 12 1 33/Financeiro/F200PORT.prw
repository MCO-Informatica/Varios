User Function F200PORT()
Local lRet := .T.

lRet := MsgYesNo("Usa conta informada no titulo?", "Atenção")

//MsgInfo("FIN200X!!!","PE F200PORT!")

U_FIN200X()

Return lRet
