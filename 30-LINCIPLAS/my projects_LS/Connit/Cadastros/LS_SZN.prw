#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NOVO9     ? Autor ? AP6 IDE            ? Data ?  23/08/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Codigo gerado pelo AP6 IDE.                                ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP6 IDE                                                    ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function LS_SZN()


Private cString := "SZN"

dbSelectArea("SZN")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Exce??es",'.t.','.t.') //VldAlt(inclui,altera),VldExc(exclui))

Return