/*
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? M040SE1  ? Autor ? Rogerio Leite          ? Data ? 17.07.06 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Geracao de Faturas a Receber - Validacao do Prefixo         ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ? FINA280                                                     ???
??????????????????????????????????????????????????????????????????????????Ĵ??
??? ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ???
??????????????????????????????????????????????????????????????????????????Ĵ??
??? PROGRAMADOR  ? DATA   ? BOPS ?  MOTIVO DA ALTERACAO                    ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???XXXXXXXXXXXXXX?XX/XX/XX?XXXXXX?                                         ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
*/
User Function F190VNAT()
Local lRet190oK:= .T.,aAreaLoc:=GetArea()
//IF len(trim(cNatur190))=0
//  lRet190ok:=.F.
//ENDIF
RestArea(aAreaLoc)
Return lRet190Ok


