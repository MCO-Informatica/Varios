#include "topconn.ch"

User Function PMSG001()

Local aAreaAF3 := AF3->(getArea())

If Altera

    If MsgYesNo("Confirma Alteração no Valor do Cust. Stand?","Confirma")

        M->AF3_CUSTD :=  aCols[n,Ascan(aHeader, {|x|, Upper(Alltrim(x[2])) == "AF3_CUSTD" })]
        
    Else            
        
        M->AF3_CUSTD  := POSICIONE("AF3",1,XFilial("AF3")+AF2->AF2_ORCAME+AF2->AF2_TAREFA+aCols[N,1],"AF3_CUSTD")

    EndIf

EndIf    

Restarea(aAreaAF3)

Return M->AF3_CUSTD
