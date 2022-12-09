#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"


User Function M020Inc()

    Local aArea     := GetArea()


    aAutoCab    :={}
    aAutoItens  :={}
    aLinha      :={}
    lMsErroAuto := .F.

    aadd(aAutoCab,{"CT1_CONTA"    ,M->A2_CONTA     ,Nil})
    aadd(aAutoCab,{"CT1_DESC01"   ,M->A2_NOME 	   ,Nil})
    aadd(aAutoCab,{"CT1_CLASSE"   ,"2"	           ,Nil})
    aadd(aAutoCab,{"CT1_DTEXIS"   ,ctod("01/01/80"),Nil})
    aadd(aAutoCab,{"CT1_NORMAL"   ,"2"	           ,Nil})
    aadd(aAutoCab,{"CT1_NTSPED"   ,"02"		       ,Nil})
    aadd(aAutoCab,{"CT1_SPEDST"	  ,"2"		       ,Nil})

    MSExecAuto({|x,y| CTBA020(x,y)},aAutoCab,3,aAutoItens)
    If lMsErroAuto
        MostraErro()
        DisarmTransaction()
        break
    EndIf

    dbselectarea("CVD")
    CVD->(dbsetorder(1))
    If !CVD->(dbseek(xfilial("CVD")+SA2->A2_CONTA))

        Reclock("CVD",.T.)
        CVD->CVD_FILIAL		:= XFILIAL("CVD")
        CVD->CVD_ENTREF		:= "10"
        CVD->CVD_CTAREF		:= "2.01.01.01.00"
        CVD->CVD_CONTA		:= SA2->A2_CONTA
        CVD->CVD_CUSTO		:= ""
        CVD->CVD_CODPLA		:= "001"
        CVD->CVD_TPUTIL		:= "A"
        Msunlock("CVD")

    EndIf

    RestArea(aArea)

Return