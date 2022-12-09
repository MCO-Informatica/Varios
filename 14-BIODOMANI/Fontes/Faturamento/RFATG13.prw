#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TOTVS.CH"
//
// Funcao para atualizar o campo C6_LOCAL dos itens do pedido ao alterar o campo C5_X_ARMAZ
//

User Function RFATG13()

Local nPPro  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local cRet   := M->C5_X_ARMAZ
Local nItens := Len(aCols)
Local nAtual := 1
Local nQEst  := 0
//Local cAmb   := Upper(GetEnvServ())

//if cAmb <> "DESENV"
//   return(cRet)
//ENDIF

if nItens = 0 .or. (nItens = 1 .and. Empty(AllTrim(aCols[1][nPPro] )))
   Return(cRet)
endif

while .t.
  
   if nAtual > nItens
      exit
   endif

   // Obs: mesmo que esteja marcado como "deletado" no aCols alterar

   if !Empty(AllTrim(aCols[nAtual][nPPro]))
      GdFieldPut("C6_LOCAL",cRet ,nAtual)
      n     := nAtual
      nQEst := U_RFATG07()
      GdFieldPut("C6_X_QTEST",nQEst ,nAtual)
   endif

   nAtual++

enddo

n := 1
oGetDad:oBrowse:Refresh()                

Return(cRet)
