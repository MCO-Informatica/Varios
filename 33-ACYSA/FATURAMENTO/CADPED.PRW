#INCLUDE "rwmake.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NOVO3     ? Autor ? AP6 IDE            ? Data ?  17/10/12   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Codigo gerado pelo AP6 IDE.                                ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP6 IDE                                                    ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function cadped


Private cCadastro := "Pedido de Vendas"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Ajusta Lote","u_AjusLote(.t.)",0,2},;
             {"Visualizar","u_AjusLote(.f.)",0,2} ,;
             {"Imprimir","u_RPEDIDO()",0,3} }       
             

Private cString := "SC5"
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea(cString)

SET FILTER TO (empty(C5_NOTA))
mBrowse( 6,1,22,75,"SC5")

dbSelectArea("SC5")         
SET FILTER TO 

Return
