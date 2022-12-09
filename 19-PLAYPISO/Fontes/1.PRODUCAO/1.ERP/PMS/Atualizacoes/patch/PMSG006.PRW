#include "topconn.ch"

User Function PMSG006()

Local aAreaAF3 := AF3->(getArea())

If Altera
    If MsgYesNo("Confirma Alteração no Valor do Cust. Stand para o Valor do Cadastro de Produto?","Confirma")


        M->AF3_CUSTD :=  Posicione("SB1",1,xFilial("SB1")+aCols[n,2],"B1_CUSTD") 
        
    /*Else            

         M->AF3_CUSTD  := POSICIONE("AF3",1,XFilial("AF3")+AF2->AF2_ORCAME+AF2->AF2_TAREFA+aCols[N,1],"AF3_CUSTD")*/

    EndIf

EndIf    

Restarea(aAreaAF3)

Return M->AF3_CUSTD
