#INCLUDE "rwmake.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NOVO3     ? Autor ? AP6 IDE            ? Data ?  14/05/14   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Codigo gerado pelo AP6 IDE.                                ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP6 IDE                                                    ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function CLOTE


//?????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de Variaveis                                             ?
//???????????????????????????????????????????????????????????????????????

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZL"

dbSelectArea("SZL")
dbSetOrder(1)

AxCadastro(cString,"NUMEROS DE SERIE",cVldExc,cVldAlt)

Return
