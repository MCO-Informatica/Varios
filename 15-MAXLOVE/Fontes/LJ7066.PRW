#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function LJ7066()

_aArea  := GetArea()

Reclock("SC5",.F.)
SC5->C5_X_USERS := "e-commerce"
SC5->C5_X_PROGR :=  "N"
SC5->C5_NOMCLI  :=  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
SC5->C5_X_EMPFA :=  "0105"
SC5->C5_XPRIORI  :=  "A"

If Subs(SC5->C5_PEDECOM,1,3)$"PLT"
    SC5->C5_VOLUME1 :=  1
    SC5->C5_ESPECI1 :=  "VOLUME"
    SC5->C5_TRANSP  :=  "000178"
EndIf

SC5->(MsUnLock())

DbSelectArea("SC9")
DbSetOrder(1)
If dbSeek(xfilial("SC9")+SC5->C5_NUM,.F.)
    While !Eof() .and. SC9->C9_PEDIDO == SC5->C5_NUM
        Reclock("SC9",.f.)
        SC9->C9_DATENT  := dDataBase
        SC9->C9_PEDECOM := SC5->C5_PEDECOM
        SC9->(MsUnLock())
        SC9->(dbSkip())
    EndDo    
EndIf

RestArea(_aArea)

Return
