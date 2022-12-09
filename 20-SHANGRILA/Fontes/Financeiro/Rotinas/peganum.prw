#Include "RwMake.Ch"

User Function PEGANUM
*-------------------- 
// Pega o último número do Cadastro de Contas a Pagar

Local wret := M->E2_NUM
If Empty(M->E2_NUM) .And. M->E2_PREFIXO = "ZZZ" 
   Dbselectarea("SE2")
   Dbsetorder(1)
   Dbseek(xFilial("SE2")+M->E2_PREFIXO+"999999",.T.)
   Dbskip(-1)
   If SE2->E2_PREFIXO <> "ZZZ"
      wret := "000001"
   Else
      wret := Strzero(Val(SE2->E2_NUM)+1,6)
   Endif
Endif
Return(wret)







