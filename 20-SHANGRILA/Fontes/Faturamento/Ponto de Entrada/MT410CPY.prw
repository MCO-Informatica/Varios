#Include "Rwmake.ch"

User Function MT410CPY

M->C5_XLOGBLQ   := ""
M->C5_XBLQ      := ""

Return .T.




PercAci := Val(SubStr(Posicione("RCC",1,"S037"+xFilial("RCC")+Space(06)+"001","RCC_CONTEU"),12,6))
