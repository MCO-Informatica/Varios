#INCLUDE "rwmake.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ?? 
???Programa  ?GFATCLI   ? Autor ? RODRIGO            ? Data ?  02/06/06   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Gatilho de alerta de clientes                              ??? 
???          ? Validacao do Cnpj antes da barra                           ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP6 IDE                                                    ??? 
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? 
/*/


User Function GFATCLI()

       _cCGC := SUBSTR(M->A1_CGC,1,8)   
       _aArea := GetArea()      

       dBSelectArea("SA1")
       DbSetOrder(3) 

       If DbSeek(xFilial()+_cCGC)

             Alert("O CNPJ COM INICIO " + _cCGC + " JA EXISTE.")

       Endif

RestArea(_aArea)
Return(M->A1_CGC)

