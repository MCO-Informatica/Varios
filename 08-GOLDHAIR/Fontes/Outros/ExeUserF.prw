#INCLUDE "Rwmake.ch"


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?EXEUSERF  ?Autor  ?Guilherme Giuliano  ? Data ?  04/04/11   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Execu??o de User Functions                                 ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/


************************************************************
User Function ExeUserF
************************************************************

local oDlg := nil

Private cFunc 	:= space(40)

@ 000,000 TO 120,300 DIALOG oDlg TITLE "Execu??o de User Function"
@ 003,008 say "User Function: "
@ 003,045 get cFunc picture "@!" size 100,13
@ 020,020 BMPBUTTON TYPE 1 ACTION &cFunc
@ 020,055 BMPBUTTON TYPE 2 ACTION close(oDlg)
ACTIVATE DIALOG oDlg CENTERED
    

return
