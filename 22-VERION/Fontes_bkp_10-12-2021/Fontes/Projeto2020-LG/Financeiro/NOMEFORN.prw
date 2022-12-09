#include "rwmake.ch"

User Function NOMEFORN()

_cNOME := Replicate(" ",53)

dbSelectArea("SF1")
dbSetOrder(1)
dbSeek(xFilial()+SE2->E2_NUM+SE2->E2_PREFIXO)

If found()
   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA)
   If found()
      _cNOME := SA2->A2_NOME
   EndIf
Else
   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
   If found()
      _cNOME := SA2->A2_NOME
   EndIf   
EndIf

Return(_cNOME)


User Function CNPJFORN()

_cCNPJ := Replicate("0",14)

dbSelectArea("SF1")
dbSetOrder(1)
dbSeek(xFilial()+SE2->E2_NUM+SE2->E2_PREFIXO)

If found()
   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA)
   If found()
      _cCNPJ := SA2->A2_CGC
   EndIf
Else
   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
   If found()
      _cCNPJ := SA2->A2_CGC
   EndIf
EndIf

Return(_cCNPJ)


User Function INSCFORN()

_cInscr := Replicate("0",14)

dbSelectArea("SF1")
dbSetOrder(1)
dbSeek(xFilial()+SE2->E2_NUM,SE2->E2_PREFIXO)

If found()
   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA)
   If found()
      _cInscr := SA2->A2_INSCR
   EndIf
Else
   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
   If found()
      _cInscr := SA2->A2_INSCR
   EndIf
EndIf

Return(_cInscr)