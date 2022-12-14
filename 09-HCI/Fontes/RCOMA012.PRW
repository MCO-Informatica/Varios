
#Include "Protheus.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?RCOMA012  ?Autor  ?Robson Bueno        ? Data ?  19/04/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Cadatro para Controle de acesso a campos                    ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?Especifico HCI (utilizado junto com o RMATA030)             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function RCOMA012()

Local cRotDel 	:= "U_RCOMA12Del()" // Rotina para delecao
Local cTudOk  	:= "U_RCOMA12Tok()" // Rotina para alteracao

AxCadastro("SZW","Cadastro p/ Contr. de Acesso a Campos",cRotDel,cTudOk)	

Return (.T.)

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Funcao    ?RCOMA12DEL? Autor ? ROBSON BUENO          ? Data ? 25.05.07 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Verifica se esta regra e a ultima para o campo             ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Retorno   ? ExpL1: Logico                                              ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Parametros? Nenhum                                                     ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???   DATA   ? Programador   ?Manutencao Efetuada                         ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???          ?               ?                                            ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

user Function RCOMA12Del()
Local aSaveArea := GetArea()
Local lRetorno := .T.
Local nCont    :=0
//????????????????????????????????????????????????????????????????????????Ŀ
//?Verifica nos Itens em Obsolesc?ncia                                     ?
//??????????????????????????????????????????????????????????????????????????
LOCAL cCampos  := SZW->ZW_CAMPO
dbSelectArea("SZW")
dbSetOrder(1)
MsSeek(xFilial("SZW")+cCampos)
DO WHILE !EOF() .AND. cCampos=SZW->ZW_CAMPO
    nCont++
    DBSKIP(+1)
ENDDO
IF nCont=1 
dbSelectArea("SX3")
dbSetOrder(2)
IF dbSeek(cCampos)
If SX3->X3_WHEN != ""
	RecLock("SX3",.F.)
	SX3->X3_WHEN := ""
	MsUnlock()
ENDIF
ENDIF
endif
RestArea(aSaveArea)
Return(lRetorno)


/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ?RCOMA12TOK? Autor ? ROBSON BUENO DA SILVA ? Data ? 25/05/07 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Busca E GUARDA NA X3 SE amarra??o feita no usuario         ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Sintaxe   ? Void                                                       ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso      ? TECA060                                                    ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
User Function RCOMA12TOK()
Local aSaveArea := GetArea()
Local lRet    := .T.
LOCAL cCampo  := M->ZW_CAMPO
dbSelectArea("SX3")
dbSetOrder(2)
IF dbSeek(cCampo)
If SX3->X3_WHEN = "                                                            "
	RecLock("SX3",.F.)
	SX3->X3_WHEN := "U_RMATA030(" + chr(34)+ cCampo + chr(34) + ")"
	MsUnlock()
ENDIF
ENDIF
RestArea(aSaveArea)
Return(lRet)


